import requests
import re
import time
import json
from datetime import datetime

class OSINTSearch:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.results = {}

    def search_breaches(self, email):
        """Search for email breaches"""
        try:
            url = f"https://haveibeenpwned.com/api/v3/breachedaccount/{email}"
            response = self.session.get(url)
            if response.status_code == 200:
                return response.json()
            elif response.status_code == 404:
                return []
            else:
                return None
        except:
            return None

    def search_social(self, username):
        """Search for username across social platforms"""
        platforms = {
            'github': f'https://github.com/{username}',
            'twitter': f'https://twitter.com/{username}',
            'instagram': f'https://www.instagram.com/{username}/',
            'facebook': f'https://www.facebook.com/{username}',
            'linkedin': f'https://www.linkedin.com/in/{username}/',
            'youtube': f'https://www.youtube.com/@{username}',
            'reddit': f'https://www.reddit.com/user/{username}',
            'tiktok': f'https://www.tiktok.com/@{username}',
            'pinterest': f'https://www.pinterest.com/{username}/',
            'tumblr': f'https://{username}.tumblr.com',
            'medium': f'https://medium.com/@{username}',
            'devto': f'https://dev.to/{username}',
            'hashnode': f'https://hashnode.com/@{username}',
            'producthunt': f'https://www.producthunt.com/@{username}',
            'angellist': f'https://angel.co/u/{username}',
            'bitbucket': f'https://bitbucket.org/{username}',
            'gitlab': f'https://gitlab.com/{username}',
            'pastebin': f'https://pastebin.com/u/{username}',
            'replit': f'https://replit.com/@{username}',
            'codepen': f'https://codepen.io/{username}'
        }
        
        results = {}
        for platform, url in platforms.items():
            try:
                response = self.session.get(url, timeout=10)
                if response.status_code == 200:
                    if "404" not in response.text.lower() and "not found" not in response.text.lower():
                        results[platform] = {'url': url, 'exists': True}
                    else:
                        results[platform] = {'url': url, 'exists': False}
                else:
                    results[platform] = {'url': url, 'exists': False}
            except:
                results[platform] = {'url': url, 'exists': False, 'error': True}
            time.sleep(0.3)
        
        return results

    def extract_emails(self, url):
        """Extract emails from a website"""
        try:
            response = self.session.get(url, timeout=15)
            pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
            emails = re.findall(pattern, response.text)
            return list(set(emails))
        except:
            return []

    def extract_phones(self, url):
        """Extract phone numbers from a website"""
        try:
            response = self.session.get(url, timeout=15)
            patterns = [
                r'\+\d{1,3}[\s\-]?\(?\d{1,4}\)?[\s\-]?\d{1,4}[\s\-]?\d{1,4}',
                r'\d{3}[\s\-]?\d{3}[\s\-]?\d{4}',
                r'\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{4}'
            ]
            phones = []
            for pattern in patterns:
                phones.extend(re.findall(pattern, response.text))
            return list(set(phones))
        except:
            return []

def main():
    print("="*50)
    print("OSINT SEARCH TOOL")
    print("="*50)
    print("1. Search email across platforms")
    print("2. Search username across social media")
    print("3. Scrape emails from a website")
    print("4. Scrape phone numbers from a website")
    print("5. Full scan (email + breaches + social)")
    print("="*50)
    
    choice = input("Enter choice (1-5): ")
    searcher = OSINTSearch()
    
    if choice == "1":
        email = input("Enter email: ")
        print(f"\nSearching for {email}...")
        
        print("\nBreaches:")
        breaches = searcher.search_breaches(email)
        if breaches:
            for breach in breaches:
                print(f"  - {breach.get('Name', 'Unknown')} ({breach.get('BreachDate', 'Unknown')})")
        else:
            print("  No breaches found")
    
    elif choice == "2":
        username = input("Enter username: ")
        print(f"\nSearching for @{username} across social media...")
        results = searcher.search_social(username)
        
        found = [p for p, data in results.items() if data.get('exists')]
        if found:
            print("\n✅ Found on:")
            for platform in found:
                print(f"  - {platform}: {results[platform]['url']}")
        else:
            print("❌ No social media profiles found")
    
    elif choice == "3":
        url = input("Enter website URL: ")
        emails = searcher.extract_emails(url)
        print(f"\nFound {len(emails)} emails:")
        for email in emails:
            print(f"  {email}")
    
    elif choice == "4":
        url = input("Enter website URL: ")
        phones = searcher.extract_phones(url)
        print(f"\nFound {len(phones)} phone numbers:")
        for phone in phones:
            print(f"  {phone}")
    
    elif choice == "5":
        email = input("Enter email: ")
        print(f"\n=== FULL SCAN: {email} ===")
        
        # Breaches
        print("\n[1] Breach Database:")
        breaches = searcher.search_breaches(email)
        if breaches:
            for breach in breaches:
                print(f"  - {breach.get('Name', 'Unknown')} ({breach.get('BreachDate', 'Unknown')})")
        else:
            print("  No breaches found")
        
        # Social media (extract username from email)
        username = email.split('@')[0]
        print(f"\n[2] Social Media (@{username}):")
        results = searcher.search_social(username)
        found = [p for p, data in results.items() if data.get('exists')]
        if found:
            for platform in found:
                print(f"  ✅ {platform}: {results[platform]['url']}")
        else:
            print("  ❌ No social media profiles found")
    
    print("\n" + "="*50)
    print("Search complete!")

if __name__ == "__main__":
    main()
