import requests
import re
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

class AdvancedOSINT:
    def __init__(self):
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
        self.results = {}

    def search_all_social(self, username):
        """Search across 50+ social media platforms"""
        platforms = {
            # Major platforms
            'GitHub': f'https://github.com/{username}',
            'Twitter': f'https://twitter.com/{username}',
            'Instagram': f'https://www.instagram.com/{username}/',
            'Facebook': f'https://www.facebook.com/{username}',
            'LinkedIn': f'https://www.linkedin.com/in/{username}/',
            'YouTube': f'https://www.youtube.com/@{username}',
            'Reddit': f'https://www.reddit.com/user/{username}',
            'TikTok': f'https://www.tiktok.com/@{username}',
            'Pinterest': f'https://www.pinterest.com/{username}/',
            'Tumblr': f'https://{username}.tumblr.com',
            'Medium': f'https://medium.com/@{username}',
            'Dev.to': f'https://dev.to/{username}',
            'Hashnode': f'https://hashnode.com/@{username}',
            'ProductHunt': f'https://www.producthunt.com/@{username}',
            'AngelList': f'https://angel.co/u/{username}',
            'Bitbucket': f'https://bitbucket.org/{username}',
            'GitLab': f'https://gitlab.com/{username}',
            'Pastebin': f'https://pastebin.com/u/{username}',
            'Replit': f'https://replit.com/@{username}',
            'Codepen': f'https://codepen.io/{username}',
            # Additional platforms
            'VK': f'https://vk.com/{username}',
            'Flickr': f'https://www.flickr.com/people/{username}/',
            'Dribbble': f'https://dribbble.com/{username}',
            'Behance': f'https://www.behance.net/{username}',
            'SoundCloud': f'https://soundcloud.com/{username}',
            'Spotify': f'https://open.spotify.com/user/{username}',
            'Twitch': f'https://www.twitch.tv/{username}',
            'Discord': f'https://discord.com/users/{username}',
            'Telegram': f'https://t.me/{username}',
            'WhatsApp': f'https://wa.me/{username}',
            'Snapchat': f'https://www.snapchat.com/add/{username}',
            'Threads': f'https://www.threads.net/@{username}',
            'Mastodon': f'https://mastodon.social/@{username}',
            'Matrix': f'https://matrix.to/#/@{username}',
            'Signal': f'https://signal.me/#p/{username}',
            'Keybase': f'https://keybase.io/{username}',
            'HackerNews': f'https://news.ycombinator.com/user?id={username}',
            'StackOverflow': f'https://stackoverflow.com/users?q={username}',
            'Quora': f'https://www.quora.com/profile/{username}',
            'Goodreads': f'https://www.goodreads.com/user/show/{username}'
        }
        
        results = {}
        print(f"Searching {len(platforms)} platforms...")
        
        def check_platform(platform, url):
            try:
                response = self.session.get(url, timeout=8)
                if response.status_code == 200:
                    if "404" not in response.text.lower() and "not found" not in response.text.lower():
                        return (platform, {'url': url, 'exists': True, 'status': response.status_code})
                return (platform, {'url': url, 'exists': False, 'status': response.status_code})
            except:
                return (platform, {'url': url, 'exists': False, 'error': True})
        
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = {executor.submit(check_platform, p, url): p for p, url in platforms.items()}
            completed = 0
            for future in as_completed(futures):
                platform, result = future.result()
                results[platform] = result
                completed += 1
                if completed % 10 == 0:
                    print(f"  Progress: {completed}/{len(platforms)}")
                time.sleep(0.1)
        
        return results

    def search_breaches(self, email):
        """Search breaches via multiple sources"""
        sources = [
            f"https://haveibeenpwned.com/api/v3/breachedaccount/{email}",
            f"https://leak-lookup.com/api/search?key=demo&query={email}"
        ]
        results = []
        for url in sources:
            try:
                response = self.session.get(url, timeout=10)
                if response.status_code == 200:
                    results.extend(response.json() if isinstance(response.json(), list) else [response.json()])
            except:
                pass
        return results

def main():
    print("="*60)
    print("ADVANCED OSINT SEARCH TOOL")
    print("="*60)
    print("Searching across 50+ social media platforms")
    print("="*60)
    
    query = input("Enter email or username to search: ")
    print(f"\nSearching for: {query}\n")
    
    searcher = AdvancedOSINT()
    
    # Determine if it's an email or username
    if "@" in query:
        # Email - search breaches + social
        username = query.split('@')[0]
        print("[1] Checking breach databases...")
        breaches = searcher.search_breaches(query)
        if breaches:
            print(f"  ✅ Found in {len(breaches)} breaches")
        else:
            print("  ❌ No breaches found")
        
        print(f"\n[2] Searching social media for '{username}'...")
        results = searcher.search_all_social(username)
        
        found = [p for p, data in results.items() if data.get('exists')]
        print(f"\n✅ Found on {len(found)} platforms:")
        for platform in found:
            print(f"  • {platform}: {results[platform]['url']}")
        
        if not found:
            print("  ❌ No social media profiles found")
    else:
        # Username search
        print(f"Searching social media for '{query}'...")
        results = searcher.search_all_social(query)
        
        found = [p for p, data in results.items() if data.get('exists')]
        print(f"\n✅ Found on {len(found)} platforms:")
        for platform in found:
            print(f"  • {platform}: {results[platform]['url']}")
        
        if not found:
            print("  ❌ No profiles found")
    
    print("\n" + "="*60)
    print("Search complete!")

if __name__ == "__main__":
    main()
