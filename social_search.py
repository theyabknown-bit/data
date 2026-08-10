import requests
import re
import time

def search_username(username):
    """Search for a username across social media platforms"""
    platforms = {
        "Reddit": f"https://www.reddit.com/user/{username}",
        "GitHub": f"https://github.com/{username}",
        "Twitter": f"https://twitter.com/{username}",
        "Instagram": f"https://www.instagram.com/{username}/",
        "Facebook": f"https://www.facebook.com/{username}",
        "YouTube": f"https://www.youtube.com/@{username}",
        "TikTok": f"https://www.tiktok.com/@{username}",
        "Pinterest": f"https://www.pinterest.com/{username}/",
        "Tumblr": f"https://{username}.tumblr.com",
        "Medium": f"https://medium.com/@{username}",
        "Dev.to": f"https://dev.to/{username}",
        "Twitch": f"https://www.twitch.tv/{username}",
        "Telegram": f"https://t.me/{username}",
        "Snapchat": f"https://www.snapchat.com/add/{username}",
        "Threads": f"https://www.threads.net/@{username}",
        "Keybase": f"https://keybase.io/{username}",
        "GitLab": f"https://gitlab.com/{username}",
        "Bitbucket": f"https://bitbucket.org/{username}",
        "SoundCloud": f"https://soundcloud.com/{username}",
        "AngelList": f"https://angel.co/u/{username}",
        "Flickr": f"https://www.flickr.com/people/{username}/",
        "VK": f"https://vk.com/{username}",
        "Spotify": f"https://open.spotify.com/user/{username}",
        "HackerNews": f"https://news.ycombinator.com/user?id={username}",
        "Goodreads": f"https://www.goodreads.com/user/show/{username}"
    }
    
    found_platforms = []
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})
    
    print(f"Searching for '{username}' across {len(platforms)} platforms...")
    
    for platform, url in platforms.items():
        try:
            response = session.get(url, timeout=8, allow_redirects=True)
            text = response.text.lower()
            
            # Check if profile exists
            if response.status_code == 200:
                # Check for "not found" indicators
                not_found = [
                    'user not found', 'page not found', 'profile not found',
                    'this account doesn\'t exist', 'sorry, this page isn\'t available',
                    'doesn\'t exist', 'account not found', 'no results found'
                ]
                
                if any(phrase in text for phrase in not_found):
                    continue
                
                # Platform-specific checks
                if platform == 'TikTok' and ('discontinued operating' in text or 'tiktok hong kong' in text):
                    continue
                
                if platform == 'Instagram' and 'instagram.com/explore' in text:
                    continue
                
                if platform == 'YouTube' and ('no results' in text or 'not found' in text):
                    continue
                
                found_platforms.append(f"  ✅ {platform}: {url}")
            else:
                # Status code not 200
                continue
        except Exception as e:
            pass
        
        time.sleep(0.1)
    
    return found_platforms

def main():
    print("=" * 50)
    print("SOCIAL MEDIA USERNAME SEARCH")
    print("=" * 50)
    
    username = input("Enter username to search: ").strip()
    if not username:
        print("❌ Username cannot be empty")
        return
    
    print(f"\nSearching for: @{username}\n")
    
    results = search_username(username)
    
    if results:
        print(f"\n✅ Found on {len(results)} platforms:")
        for r in results:
            print(r)
    else:
        print("\n❌ No social media profiles found for: @" + username)

if __name__ == "__main__":
    main()
