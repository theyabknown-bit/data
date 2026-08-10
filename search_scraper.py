# Search-based scraper – hundreds of repos
import requests
import json
import time

def search_github(query, max_pages=10):
    results = []
    for page in range(1, max_pages + 1):
        url = 'https://api.github.com/search/repositories'
        params = {'q': query, 'per_page': 100, 'page': page}
        try:
            resp = requests.get(url, params=params)
            if resp.status_code == 200:
                data = resp.json()
                items = data.get('items', [])
                if not items:
                    break
                results.extend(items)
                print(f"Page {page}: {len(items)} repos")
            elif resp.status_code == 403:
                print("Rate limit hit, waiting...")
                time.sleep(60)
                continue
            else:
                print(f"Error: {resp.status_code}")
                break
        except Exception as e:
            print(f"Error: {e}")
            break
        time.sleep(0.2)
    return results

# Search for repositories
queries = [
    "language:python stars:>1000",
    "language:javascript stars:>1000",
    "language:java stars:>1000",
    "topic:machine-learning",
    "topic:blockchain",
    "topic:cybersecurity"
]

all_results = []
for query in queries:
    print(f"\nSearching: {query}")
    results = search_github(query, max_pages=5)
    all_results.extend(results)
    print(f"Found {len(results)} repos")
    time.sleep(1)

# Save results
with open('search_results.json', 'w') as f:
    json.dump(all_results, f, indent=2, default=str)

print(f"\nTotal repositories: {len(all_results)}")
