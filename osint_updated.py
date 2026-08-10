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

    def check_platform(self, platform, url):
        try:
            response = self.session.get(url, timeout=8, allow_redirects=True)
            text = response.text.lower()
            
            # Check for indicators of a missing/non-existent profile
            not_found_indicators = [
                'user not found',
                'page not found',
                'profile not found',
                "this account doesn't exist",
                "sorry, this page isn't available",
                "we couldn't find this account",
                "doesn't exist",
                "is not available",
                "no results found",
                "sorry, this page is not available",
                "this profile is not available",
                "account not found"
            ]
            
            if any(phrase in text for phrase in not_found_indicators):
                return (platform, {'url': url, 'exists': False, 'status': response.status_code, 'error': 'Profile not found'})
            
            # Platform-specific checks
            if platform == 'TikTok' and ('discontinued operating' in text or 'tiktok hong kong' in text):
                return (platform, {'url': url, 'exists': False, 'status': response.status_code, 'error': 'Service not available in region'})
            
            if platform == 'Instagram' and 'instagram.com/explore' in text:
                return (platform, {'url': url, 'exists': False, 'status': response.status_code, 'error': 'Profile not found'})
            
            if platform == 'Twitter' and 'this account doesn’t exist' in text:
                return (platform, {'url': url, 'exists': False, 'status': response.status_code, 'error': 'Profile not found'})
            
            if platform == 'GitHub' and 'there is no page' in text:
                return (platform, {'url': url, 'exists': False, 'status': response.status_code, 'error': 'Profile not found'})
            
            if response.status_code == 200:
                return (platform, {'url': url, 'exists': True, 'status': response.status_code})
            else:
                return (platform, {'url': url, 'exists': False, 'status': response.status_code})
        except Exception as e:
            return (platform, {'url': url, 'exists': False, 'error': str(e)})

    def search_all_social(self, username):
        platforms = {
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
            'VK': f'https://vk.com/{username}',
            'Flickr': f'https://www.flickr.com/people/{username}/',
            'Dribbble': f'https://dribbble.com/{username}',
            'Behance': f'https://www.behance.net/{username}',
            'SoundCloud': f'https://soundcloud.com/{username}',
            'Spotify': f'https://open.spotify.com/user/{username}',
            'Twitch': f'https://www.twitch.tv/{username}',
            'Telegram': f'https://t.me/{username}',
            'Snapchat': f'https://www.snapchat.com/add/{username}',
            'Threads': f'https://www.threads.net/@{username}',
            'Mastodon': f'https://mastodon.social/@{username}',
            'Keybase': f'https://keybase.io/{username}',
            'HackerNews': f'https://news.ycombinator.com/user?id={username}',
            'StackOverflow': f'https://stackoverflow.com/users?q={username}',
            'Quora': f'https://www.quora.com/profile/{username}',
            'Goodreads': f'https://www.goodreads.com/user/show/{username}'
        }
        
        results = {}
        print(f"Searching {len(platforms)} platforms...")
        
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = {executor.submit(self.check_platform, p, url): p for p, url in platforms.items()}
            completed = 0
            for future in as_completed(futures):
                platform, result = future.result()
                results[platform] = result
                completed += 1
                if completed % 10 == 0:
                    print(f"  Progress: {completed}/{len(platforms)}")
        
        return results

def main():
    print("="*60)
    print("ADVANCED OSINT SEARCH TOOL (UPDATED)")
    print("="*60)
    print("Searching across 40+ social media platforms")
    print("With improved detection for missing profiles")
    print("="*60)
    
    query = input("Enter email or username to search: ")
    print(f"\nSearching for: {query}\n")
    
    searcher = AdvancedOSINT()
    
    if "@" in query:
        username = query.split('@')[0]
        print(f"[1] Searching social media for '{username}'...")
        results = searcher.search_all_social(username)
        
        found = [p for p, data in results.items() if data.get('exists')]
        print(f"\n✅ Found on {len(found)} platforms:")
        for platform in found:
            print(f"  • {platform}: {results[platform]['url']}")
        
        not_found = [p for p, data in results.items() if not data.get('exists')]
        if not_found:
            print(f"\n❌ Not found on {len(not_found)} platforms")
            for platform in not_found[:10]:
                print(f"  • {platform}: {results[platform].get('error', 'Profile not found')}")
    else:
        print(f"Searching social media for '{query}'...")
        results = searcher.search_all_social(query)
        
        found = [p for p, data in results.items() if data.get('exists')]
        print(f"\n✅ Found on {len(found)} platforms:")
        for platform in found:
            print(f"  • {platform}: {results[platform]['url']}")
    
    print("\n" + "="*60)
    print("Search complete!")

if __name__ == "__main__":
    main()
