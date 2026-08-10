# ============================================
# ULTIMATE DATA HARVESTER
# Extracts: Emails, Phones, Addresses, Social Profiles, Government Data
# ============================================

import requests
import re
import time
import json
import os
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime

class UltimateDataHarvester:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.results = {
            'emails': [],
            'phones': [],
            'addresses': [],
            'social': [],
            'urls': [],
            'government': []
        }

    # ============================================
    # EMAIL EXTRACTION
    # ============================================
    def extract_emails(self, text, source):
        pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
        emails = re.findall(pattern, text)
        for email in set(emails):
            self.results['emails'].append({'value': email, 'source': source})

    # ============================================
    # PHONE EXTRACTION
    # ============================================
    def extract_phones(self, text, source):
        patterns = [
            r'\+\d{1,4}[\s\-]?\(?\d{1,4}\)?[\s\-]?\d{1,4}[\s\-]?\d{1,4}',
            r'\d{3}[\s\-]?\d{3}[\s\-]?\d{4}',
            r'\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{4}',
            r'\d{10,15}'
        ]
        phones = []
        for pattern in patterns:
            phones.extend(re.findall(pattern, text))
        for phone in set(phones):
            if len(phone) >= 10 and len(phone) <= 15:
                self.results['phones'].append({'value': phone, 'source': source})

    # ============================================
    # ADDRESS EXTRACTION
    # ============================================
    def extract_addresses(self, text, source):
        patterns = [
            r'\b\d{1,5}\s+[A-Za-z0-9\s,.-]+(?:Street|St|Avenue|Ave|Road|Rd|Boulevard|Blvd|Lane|Ln|Drive|Dr|Court|Ct|Way|Parkway|Pkwy|Plaza|Square|Circle|Cir|Terrace|Ter|Place|Pl|Highway|Hwy)\b',
            r'\b\d{5}(?:-\d{4})?\b',
            r'P\.?O\.?\s*Box\s*\d+',
            r'\b[A-Z][a-z]+(?:[-\s][A-Z][a-z]+)*,\s*[A-Z]{2}\s+\d{5}\b'
        ]
        for pattern in patterns:
            addresses = re.findall(pattern, text, re.I)
            for addr in set(addresses):
                if len(str(addr)) > 10:
                    self.results['addresses'].append({'value': str(addr)[:100], 'source': source})

    # ============================================
    # SOCIAL MEDIA PROFILES
    # ============================================
    def extract_social(self, text, source):
        platforms = {
            'GitHub': r'github\.com/([a-zA-Z0-9_-]+)',
            'Twitter': r'twitter\.com/([a-zA-Z0-9_]+)',
            'Instagram': r'instagram\.com/([a-zA-Z0-9_.]+)',
            'Facebook': r'facebook\.com/([a-zA-Z0-9.]+)',
            'LinkedIn': r'linkedin\.com/in/([a-zA-Z0-9_-]+)',
            'YouTube': r'youtube\.com/@([a-zA-Z0-9_-]+)',
            'TikTok': r'tiktok\.com/@([a-zA-Z0-9_.]+)',
            'Reddit': r'reddit\.com/user/([a-zA-Z0-9_-]+)',
            'Telegram': r't\.me/([a-zA-Z0-9_]+)',
            'Discord': r'discord\.com/users/([0-9]+)',
            'Pinterest': r'pinterest\.com/([a-zA-Z0-9_-]+)'
        }
        for platform, pattern in platforms.items():
            matches = re.findall(pattern, text, re.I)
            for match in set(matches):
                self.results['social'].append({
                    'platform': platform,
                    'username': match,
                    'url': f'https://{platform.lower()}.com/{match}' if platform != 'Reddit' else f'https://reddit.com/user/{match}',
                    'source': source
                })

    # ============================================
    # URL EXTRACTION
    # ============================================
    def extract_urls(self, text, source):
        pattern = r'https?://[^\s<>"{}|\\^`\[\]]+'
        urls = re.findall(pattern, text)
        for url in set(urls):
            self.results['urls'].append({'value': url, 'source': source})

    # ============================================
    # GOVERNMENT DATA SCRAPING
    # ============================================
    def scrape_government(self, url):
        try:
            response = self.session.get(url, timeout=15)
            text = response.text
            self.extract_emails(text, url)
            self.extract_phones(text, url)
            self.extract_addresses(text, url)
            self.extract_social(text, url)
            self.extract_urls(text, url)
            self.results['government'].append({'url': url, 'status': 'success'})
        except Exception as e:
            self.results['government'].append({'url': url, 'status': 'failed', 'error': str(e)})

    # ============================================
    # SOCIAL MEDIA SEARCH
    # ============================================
    def search_social(self, username):
        platforms = {
            'GitHub': f'https://github.com/{username}',
            'Twitter': f'https://twitter.com/{username}',
            'Instagram': f'https://www.instagram.com/{username}/',
            'Facebook': f'https://www.facebook.com/{username}',
            'Reddit': f'https://www.reddit.com/user/{username}',
            'TikTok': f'https://www.tiktok.com/@{username}',
            'YouTube': f'https://www.youtube.com/@{username}',
            'Pinterest': f'https://www.pinterest.com/{username}/',
            'Telegram': f'https://t.me/{username}',
            'Tumblr': f'https://{username}.tumblr.com',
            'Medium': f'https://medium.com/@{username}',
            'Dev.to': f'https://dev.to/{username}',
            'Twitch': f'https://www.twitch.tv/{username}',
            'Snapchat': f'https://www.snapchat.com/add/{username}',
            'Threads': f'https://www.threads.net/@{username}',
            'SoundCloud': f'https://soundcloud.com/{username}',
            'VK': f'https://vk.com/{username}',
            'Spotify': f'https://open.spotify.com/user/{username}',
            'GitLab': f'https://gitlab.com/{username}',
            'Bitbucket': f'https://bitbucket.org/{username}',
            'Flickr': f'https://www.flickr.com/people/{username}/',
            'Keybase': f'https://keybase.io/{username}'
        }
        for platform, url in platforms.items():
            try:
                response = self.session.get(url, timeout=8)
                if response.status_code == 200:
                    self.results['social'].append({
                        'platform': platform,
                        'username': username,
                        'url': url,
                        'status': 'found'
                    })
            except:
                pass
            time.sleep(0.1)

# ============================================
# RUN THE HARVESTER
# ============================================
def main():
    harvester = UltimateDataHarvester()
    
    print("=" * 60)
    print("ULTIMATE DATA HARVESTER")
    print("=" * 60)
    print("Extracting: Emails, Phones, Addresses, Social Profiles, URLs")
    print("=" * 60)
    
    # 1. Search for a username
    username = input("Enter username to search: ").strip()
    if username:
        print(f"\n[1] Searching social media for @{username}...")
        harvester.search_social(username)
    
    # 2. Enter websites to scrape
    print("\n[2] Enter websites to scrape (comma separated, or press Enter to skip):")
    urls_input = input("URLs: ").strip()
    if urls_input:
        urls = [u.strip() for u in urls_input.split(',') if u.strip()]
        print(f"Scraping {len(urls)} websites...")
        with ThreadPoolExecutor(max_workers=5) as executor:
            executor.map(harvester.scrape_government, urls)
    
    # 3. Enter text to extract from
    print("\n[3] Enter text to extract data from (press Enter to skip):")
    text = input("Text: ").strip()
    if text:
        harvester.extract_emails(text, "user-input")
        harvester.extract_phones(text, "user-input")
        harvester.extract_addresses(text, "user-input")
        harvester.extract_social(text, "user-input")
        harvester.extract_urls(text, "user-input")
    
    # ============================================
    # OUTPUT RESULTS
    # ============================================
    print("\n" + "=" * 60)
    print("RESULTS")
    print("=" * 60)
    
    # Count totals
    email_count = len(harvester.results['emails'])
    phone_count = len(harvester.results['phones'])
    address_count = len(harvester.results['addresses'])
    social_count = len(harvester.results['social'])
    url_count = len(harvester.results['urls'])
    gov_count = len(harvester.results['government'])
    
    print(f"📧 Emails: {email_count}")
    print(f"📱 Phones: {phone_count}")
    print(f"🏠 Addresses: {address_count}")
    print(f"👤 Social Profiles: {social_count}")
    print(f"🔗 URLs: {url_count}")
    print(f"🏛️ Government Sites Scraped: {gov_count}")
    
    # Save to files
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    with open(f"emails_{timestamp}.txt", "w") as f:
        for item in harvester.results['emails']:
            f.write(f"{item['value']} - {item['source']}\n")
    
    with open(f"phones_{timestamp}.txt", "w") as f:
        for item in harvester.results['phones']:
            f.write(f"{item['value']} - {item['source']}\n")
    
    with open(f"addresses_{timestamp}.txt", "w") as f:
        for item in harvester.results['addresses']:
            f.write(f"{item['value']} - {item['source']}\n")
    
    with open(f"social_{timestamp}.txt", "w") as f:
        for item in harvester.results['social']:
            f.write(f"{item['platform']}: {item['username']} - {item['url']} ({item['source']})\n")
    
    with open(f"urls_{timestamp}.txt", "w") as f:
        for item in harvester.results['urls']:
            f.write(f"{item['value']} - {item['source']}\n")
    
    # Full JSON output
    with open(f"full_data_{timestamp}.json", "w") as f:
        json.dump(harvester.results, f, indent=2, default=str)
    
    print(f"\n✅ Data saved to files with timestamp: {timestamp}")
    print("=" * 60)

if __name__ == "__main__":
    main()
