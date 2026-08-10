# Bulk GitHub scraper – multiple users
import requests
import json
import time
import os

# List of users to scrape
USERS = [
    "Parth971",
    "octocat",
    "torvalds",
    "google",
    "microsoft",
    "facebook",
    "twitter",
    "apple",
    "amzn",
    "netflix"
]

def scrape_user(username):
    try:
        url = f'https://api.github.com/users/{username}/repos'
        resp = requests.get(url, params={'per_page': 100})
        if resp.status_code == 200:
            return resp.json()
    except:
        pass
    return []

all_repos = []
for user in USERS:
    print(f"Scraping: {user}")
    repos = scrape_user(user)
    if repos:
        all_repos.extend(repos)
        print(f"  Found {len(repos)} repos")
    time.sleep(0.5)

# Save all
with open('bulk_repos.json', 'w') as f:
    json.dump(all_repos, f, indent=2, default=str)

print(f"\nTotal repos: {len(all_repos)}")
print("Saved to bulk_repos.json")
