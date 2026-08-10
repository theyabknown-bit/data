import asyncio
import argparse
import re
import os
import hashlib
from datetime import datetime, timezone
import aiohttp
from bs4 import BeautifulSoup
from fake_useragent import UserAgent
from urllib.parse import urljoin, urlparse

# Expanded pattern list for real-world extraction
PATTERNS = {
    'address_full': re.compile(r'\b\d{1,5}\s+[A-Za-z0-9\s,.-]+(?:Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Lane|Ln|Drive|Dr|Court|Ct|Way|Parkway|Pkwy|Plaza|Square|Circle|Cir|Terrace|Ter|Place|Pl|Highway|Hwy)\b', re.I),
    'address_po': re.compile(r'\bPO\s+Box\s+\d{1,5}\b', re.I),
    'address_zip': re.compile(r'\b\d{5}(?:-\d{4})?\b'),
    'address_state': re.compile(r'\b[A-Z]{2}\s+\d{5}\b'),
    'address_city_state': re.compile(r'\b[A-Z][a-z]+(?:[-\s][A-Z][a-z]+)*,\s*[A-Z]{2}\s+\d{5}\b'),
    'email': re.compile(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'),
    'phone': re.compile(r'\b(?:\+?1[-.\s]?)?\(?[0-9]{3}\)?[-.\s]?[0-9]{3}[-.\s]?[0-9]{4}\b'),
    'ssn': re.compile(r'\b(?!000|666|9\d{2})([0-8]\d{2}|7[0-6]\d|77[0-2])-?(?!00)\d{2}-?(?!0000)\d{4}\b'),
    'cc': re.compile(r'\b(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(?:011|5[0-9]{2})[0-9]{12})\b'),
    'passport': re.compile(r'\b[A-Z][0-9]{8}\b'),
    'ip': re.compile(r'\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b'),
    'url': re.compile(r'https?://[^\s<>"{}|\\^`\[\]]+'),
    'date': re.compile(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{2,4}\b|\b(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\s+\d{1,2},?\s+\d{4}\b'),
    'address': re.compile(r'\b\d{1,5}\s+[A-Za-z0-9\s,.]+(?:Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Lane|Ln|Drive|Dr|Court|Ct|Way|Parkway|Pkwy)\b', re.I),
    'name': re.compile(r'\b(?:Mr\.|Ms\.|Mrs\.|Dr\.|Prof\.)\s+[A-Z][a-z]+\s+[A-Z][a-z]+\b'),
    'username': re.compile(r'@[A-Za-z0-9_]{3,30}'),
    'hash_md5': re.compile(r'\b[a-fA-F0-9]{32}\b'),
    'hash_sha1': re.compile(r'\b[a-fA-F0-9]{40}\b'),
    'hash_sha256': re.compile(r'\b[a-fA-F0-9]{64}\b'),
}

def luhn_check(n):
    n = str(n)
    total = 0
    rev = n[::-1]
    for i, d in enumerate(rev):
        digit = int(d)
        if i % 2 == 1:
            digit *= 2
            if digit > 9:
                digit -= 9
        total += digit
    return total % 10 == 0

def validate_cc(cc):
    clean = re.sub(r'\D', '', cc)
    return luhn_check(clean) if len(clean) >= 13 else False

async def fetch(session, url, ua, timeout=20):
    headers = {
        'User-Agent': ua.random,
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'en-US,en;q=0.5',
    }
    try:
        async with session.get(url, headers=headers, timeout=timeout, allow_redirects=True) as resp:
            if resp.status == 200:
                content_type = resp.headers.get('Content-Type', '')
                if 'text/html' in content_type or 'application/xml' in content_type:
                    return await resp.text(), str(resp.url)
                return None, None
    except Exception as e:
        pass
    return None, None

async def crawl_real(session, url, ua, depth, max_pages=100):
    visited = set()
    queue = [(url, 0)]
    all_matches = []
    pages_crawled = 0

    while queue and len(visited) < max_pages:
        current_url, current_depth = queue.pop(0)
        if current_url in visited or current_depth > depth:
            continue
        visited.add(current_url)
        pages_crawled += 1

        html, final_url = await fetch(session, current_url, ua)
        if not html:
            continue

        soup = BeautifulSoup(html, 'html.parser')
        
        # Remove script, style, meta, and nav elements to reduce noise
        for element in soup(['script', 'style', 'nav', 'footer', 'header', 'aside']):
            element.decompose()
        
        text = soup.get_text(separator=' ', strip=True)

        # Extract all patterns
        for pattern_name, pattern in PATTERNS.items():
            for match in pattern.findall(text):
                if pattern_name == 'cc':
                    if validate_cc(match):
                        clean = re.sub(r'\D', '', match)
                        all_matches.append(f"{pattern_name}: {clean[:4]}****{clean[-4:]} from {final_url}")
                else:
                    # Mask sensitive data
                    if pattern_name in ['ssn', 'passport', 'phone', 'email']:
                        if pattern_name == 'ssn':
                            masked = f"***-**-{match[-4:]}"
                        elif pattern_name == 'passport':
                            masked = f"{match[:2]}****{match[-2:]}"
                        elif pattern_name == 'phone':
                            masked = f"{match[:3]}***{match[-4:]}"
                        elif pattern_name == 'email':
                            parts = match.split('@')
                            masked = f"{parts[0][:2]}***@{parts[1]}"
                        else:
                            masked = match
                        all_matches.append(f"{pattern_name}: {masked} from {final_url}")
                    else:
                        all_matches.append(f"{pattern_name}: {match[:50]} from {final_url}")

        # Extract links for deeper crawling
        if current_depth < depth:
            for link in soup.find_all('a', href=True):
                new_url = urljoin(final_url, link['href'])
                if new_url.startswith(('http://', 'https://')):
                    # Avoid common non-content extensions
                    if not any(ext in new_url.lower() for ext in ['.pdf', '.jpg', '.png', '.gif', '.mp4', '.zip']):
                        queue.append((new_url, current_depth + 1))

        await asyncio.sleep(1.0)  # Rate limiting - be respectful

        print(f"[{datetime.now(timezone.utc)}] Crawled {pages_crawled} pages, found {len(all_matches)} matches")

    return all_matches

async def main():
    p = argparse.ArgumentParser()
    p.add_argument('--url', required=True, help='Target URL to crawl')
    p.add_argument('--depth', type=int, default=1, help='Crawl depth (0 = current page only)')
    p.add_argument('--max-pages', type=int, default=50, help='Maximum pages to crawl')
    p.add_argument('--output', default='harvest_output', help='Output folder')
    args = p.parse_args()

    os.makedirs(args.output, exist_ok=True)
    ua = UserAgent()

    print(f"[{datetime.now(timezone.utc)}] Starting REAL online crawl: {args.url}")
    print(f"[{datetime.now(timezone.utc)}] Depth: {args.depth}, Max pages: {args.max_pages}")

    async with aiohttp.ClientSession() as session:
        matches = await crawl_real(session, args.url, ua, args.depth, args.max_pages)

    # Save results
    output_file = os.path.join(args.output, 'harvest_summary.log')
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(matches))

    print(f"[{datetime.now(timezone.utc)}] Crawl complete. Found {len(matches)} matches.")
    print(f"[{datetime.now(timezone.utc)}] Results saved to: {output_file}")
    
    # Show top matches
    for m in matches[:20]:
        print(f"  {m}")

if __name__ == '__main__':
    asyncio.run(main())
