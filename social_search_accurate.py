import requests
import re
import time

def search_username(username):
    """Accurately search for a username across social media platforms"""
    
    # Platforms with specific detection methods
    platforms = {
        "GitHub": {
            "url": f"https://github.com/{username}",
            "check": lambda t, u: "is not a valid user" not in t and "there is no page" not in t
        },
        "Instagram": {
            "url": f"https://www.instagram.com/{username}/",
            "check": lambda t, u: "instagram.com/explore" not in t and "page not found" not in t and "sorry, this page isn't available" not in t
        },
        "Facebook": {
            "url": f"https://www.facebook.com/{username}",
            "check": lambda t, u: "this content isn't available" not in t and "page not found" not in t
        },
        "YouTube": {
            "url": f"https://www.youtube.com/@{username}",
            "check": lambda t, u: "no results found" not in t and "404" not in t
        },
        "TikTok": {
            "url": f"https://www.tiktok.com/@{username}",
            "check": lambda t, u: "discontinued operating" not in t and "tiktok hong kong" not in t
        },
        "Reddit": {
            "url": f"https://www.reddit.com/user/{username}",
            "check": lambda t, u: "page not found" not in t and "user doesn't exist" not in t
        },
        "Twitter": {
            "url": f"https://twitter.com/{username}",
            "check": lambda t, u: "this account doesn’t exist" not in t and "page not found" not in t
        },
        "Pinterest": {
            "url": f"https://www.pinterest.com/{username}/",
            "check": lambda t, u: "page not found" not in t and "doesn't exist" not in t
        },
        "Tumblr": {
            "url": f"https://{username}.tumblr.com",
            "check": lambda t, u: "not found" not in t and "404" not in t
        },
        "Medium": {
            "url": f"https://medium.com/@{username}",
            "check": lambda t, u: "page not found" not in t and "not found" not in t
        },
        "Dev.to": {
            "url": f"https://dev.to/{username}",
            "check": lambda t, u: "404" not in t and "not found" not in t
        },
        "Twitch": {
            "url": f"https://www.twitch.tv/{username}",
            "check": lambda t, u: "page not found" not in t and "we couldn't find this page" not in t
        },
        "Telegram": {
            "url": f"https://t.me/{username}",
            "check": lambda t, u: "channel doesn't exist" not in t
        },
        "Snapchat": {
            "url": f"https://www.snapchat.com/add/{username}",
            "check": lambda t, u: "couldn't find" not in t and "user not found" not in t
        },
        "Threads": {
            "url": f"https://www.threads.net/@{username}",
            "check": lambda t, u: "page not found" not in t and "not available" not in t
        },
        "SoundCloud": {
            "url": f"https://soundcloud.com/{username}",
            "check": lambda t, u: "404" not in t
        },
        "VK": {
            "url": f"https://vk.com/{username}",
            "check": lambda t, u: "page not found" not in t
        },
        "Spotify": {
            "url": f"https://open.spotify.com/user/{username}",
            "check": lambda t, u: "not found" not in t and "404" not in t
        },
        "GitLab": {
            "url": f"https://gitlab.com/{username}",
            "check": lambda t, u: "page not found" not in t
        },
        "HackerNews": {
            "url": f"https://news.ycombinator.com/user?id={username}",
            "check": lambda t, u: "no such user" not in t and "not found" not in t
        },
        "Goodreads": {
            "url": f"https://www.goodreads.com/user/show?q={username}",
            "check": lambda t, u: "404" not in t
        },
        "Keybase": {
            "url": f"https://keybase.io/{username}",
            "check": lambda t, u: "not found" not in t
        },
        "AngelList": {
            "url": f"https://angel.co/u/{username}",
            "check": lambda t, u: "404" not in t
        },
        "Bitbucket": {
            "url": f"https://bitbucket.org/{username}",
            "check": lambda t, u: "404" not in t
        }
    }
    
    found_platforms = []
    session = requests.Session()
    session.headers.update({"User-Agent": "Mozilla/5.0"})
    
    print(f"Searching for '{username}' across {len(platforms)} platforms...")
    
    for platform, data in platforms.items():
        url = data["url"]
        check = data["check"]
        
        try:
            response = session.get(url, timeout=8, allow_redirects=True)
            text = response.text.lower()
            
            if response.status_code == 200:
                # Platform-specific check
                if check(text, url):
                    found_platforms.append(f"  ✅ {platform}: {url}")
            elif response.status_code == 302 and platform in ["Twitter", "Instagram"]:
                # Some platforms use 302 redirects for valid profiles
                found_platforms.append(f"  ✅ {platform}: {url} (redirect)")
        except Exception as e:
            pass
        
        time.sleep(0.1)
    
    return found_platforms

def main():
    print("=" * 55)
    print("ACCURATE SOCIAL MEDIA SEARCH")
    print("=" * 55)
    print("Using content-based detection to minimize false positives")
    print("=" * 55)
    
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
    
    print("\n" + "=" * 55)
    print("Note: Results are based on content checks. Some may still be false positives.")
    print("=" * 55)

if __name__ == "__main__":
    main()
