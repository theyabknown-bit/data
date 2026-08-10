# ============================================
# ENRICH ALL DATA FILES (Recursive)
# Scans all subfolders for data files
# ============================================

import os
import re
import json
from datetime import datetime

def enrich_phone(phone):
    if not phone:
        return None
    phone = str(phone).strip()
    enriched = {
        'raw': phone,
        'type': 'phone',
        'formatted': re.sub(r'[^0-9+]', '', phone),
        'country_code': None,
        'source_type': 'data_file'
    }
    clean = enriched['formatted']
    if clean.startswith('+'):
        match = re.match(r'\+(\d{1,3})', clean)
        if match:
            enriched['country_code'] = match.group(1)
    elif len(clean) == 10:
        enriched['country_code'] = '1'
        enriched['formatted'] = f'+1{clean}'
    elif len(clean) == 11 and clean.startswith('1'):
        enriched['country_code'] = '1'
        enriched['formatted'] = f'+{clean}'
    return enriched

def enrich_url(url):
    if not url:
        return None
    url = str(url).strip()
    enriched = {
        'raw': url,
        'type': 'url',
        'domain': None,
        'path': None,
        'source_type': 'data_file'
    }
    match = re.search(r'https?://(?:www\.)?([^/]+)', url)
    if match:
        enriched['domain'] = match.group(1)
    match = re.search(r'https?://[^/]+(/[^?#]*)', url)
    if match:
        enriched['path'] = match.group(1) or '/'
    return enriched

def extract_and_enrich(content):
    results = {'phones': [], 'urls': [], 'emails': [], 'social': []}
    
    # Extract phones
    phones = re.findall(r'\+\d{1,4}[\s\-]?\(?\d{1,4}\)?[\s\-]?\d{1,4}[\s\-]?\d{1,4}|\d{3}[\s\-]?\d{3}[\s\-]?\d{4}|\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{4}|\d{10,15}', content)
    for phone in set(phones):
        enriched = enrich_phone(phone)
        if enriched and len(enriched['formatted']) >= 10:
            results['phones'].append(enriched)
    
    # Extract URLs
    urls = re.findall(r'https?://[^\s<>"{}|\\^`\[\]]+', content)
    for url in set(urls):
        enriched = enrich_url(url)
        if enriched:
            results['urls'].append(enriched)
    
    # Extract emails
    emails = re.findall(r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}', content)
    results['emails'] = list(set([e for e in emails if '@' in e and 'png' not in e and 'jpg' not in e]))
    
    # Extract social media usernames
    social_patterns = {
        'Instagram': r'instagram\.com/([a-zA-Z0-9_.]+)',
        'Facebook': r'facebook\.com/([a-zA-Z0-9.]+)',
        'Twitter': r'twitter\.com/([a-zA-Z0-9_]+)',
        'LinkedIn': r'linkedin\.com/in/([a-zA-Z0-9_-]+)',
        'GitHub': r'github\.com/([a-zA-Z0-9_-]+)',
        'YouTube': r'youtube\.com/@([a-zA-Z0-9_-]+)',
        'TikTok': r'tiktok\.com/@([a-zA-Z0-9_.]+)',
        'Reddit': r'reddit\.com/user/([a-zA-Z0-9_-]+)',
        'Telegram': r't\.me/([a-zA-Z0-9_]+)'
    }
    for platform, pattern in social_patterns.items():
        matches = re.findall(pattern, content, re.I)
        for username in set(matches):
            results['social'].append({
                'platform': platform,
                'username': username,
                'url': f'https://{platform.lower()}.com/{username}' if platform != 'Reddit' else f'https://reddit.com/user/{username}',
                'type': 'social',
                'source_type': 'data_file',
                'official': False
            })
    
    return results

# ============================================
# SCAN ALL SUBFOLDERS
# ============================================

all_data = {'phones': [], 'urls': [], 'emails': [], 'addresses': [], 'social': []}
processed_files = []

# Walk through all subfolders
for root, dirs, files in os.walk('.'):
    for filename in files:
        if filename.endswith(('.txt', '.json')) and not filename.startswith('enriched_'):
            filepath = os.path.join(root, filename)
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                data = extract_and_enrich(content)
                all_data['phones'].extend(data['phones'])
                all_data['urls'].extend(data['urls'])
                all_data['emails'].extend(data['emails'])
                all_data['social'].extend(data['social'])
                processed_files.append(filepath)
                print(f"  ✅ {filepath}")
            except Exception as e:
                print(f"  ⚠️ {filepath}: {e}")

# Remove duplicates
all_data['phones'] = list({p['raw']: p for p in all_data['phones']}.values())
all_data['urls'] = list({u['raw']: u for u in all_data['urls']}.values())
all_data['emails'] = list(set(all_data['emails']))
all_data['social'] = list({s['username'] + s['platform']: s for s in all_data['social']}.values())

# Mark official government accounts
official_keywords = ['whitehouse', 'statedept', 'un', 'usagov', 'gov', 'canada', 'uk', 'australia', 'canada']
for social in all_data['social']:
    username = social.get('username', '').lower()
    if any(kw in username for kw in official_keywords):
        social['official'] = True

timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
output_filename = f"enriched_all_data_{timestamp}.json"

with open(output_filename, 'w') as f:
    json.dump(all_data, f, indent=2, default=str)

print("="*60)
print("📊 ENRICH ALL DATA - COMPLETE")
print("="*60)
print(f"✅ Processed: {len(processed_files)} files")
print(f"📱 Phones: {len(all_data['phones'])}")
print(f"🔗 URLs: {len(all_data['urls'])}")
print(f"📧 Emails: {len(all_data['emails'])}")
print(f"👤 Social: {len(all_data['social'])}")
print("="*60)

official = [s for s in all_data['social'] if s.get('official')]
print(f"🏛️ Official accounts: {len(official)}")
for s in official[:10]:
    print(f"  ✓ {s['platform']}: {s['username']}")

print(f"💾 Saved: {output_filename}")
