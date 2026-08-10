import requests
import json
import time
from datetime import datetime

class GitHubScraper:
    def __init__(self, token=None):
        self.session = requests.Session()
        self.session.headers.update({
            'Accept': 'application/vnd.github.v3+json',
            'User-Agent': 'GitHub-Scraper/1.0'
        })
        if token:
            self.session.headers.update({'Authorization': f'token {token}'})
        self.rate_limit_remaining = 5000
        self.rate_limit_reset = 0

    def _check_rate_limit(self):
        """Check and wait if rate limit is exceeded"""
        if self.rate_limit_remaining < 10:
            wait_time = max(0, self.rate_limit_reset - time.time()) + 10
            print(f"Rate limit low. Waiting {wait_time:.0f} seconds...")
            time.sleep(wait_time)
            self._update_rate_limit()

    def _update_rate_limit(self):
        """Update rate limit status"""
        resp = self.session.get('https://api.github.com/rate_limit')
        if resp.status_code == 200:
            data = resp.json()
            self.rate_limit_remaining = data['resources']['core']['remaining']
            self.rate_limit_reset = data['resources']['core']['reset']

    def get_user_repos(self, username, max_pages=10):
        """Get all repositories for a user"""
        repos = []
        page = 1
        while page <= max_pages:
            self._check_rate_limit()
            url = f'https://api.github.com/users/{username}/repos'
            params = {'page': page, 'per_page': 100, 'sort': 'updated'}
            resp = self.session.get(url, params=params)
            
            if resp.status_code == 200:
                data = resp.json()
                if not data:
                    break
                repos.extend(data)
                page += 1
                print(f"  Page {page-1}: {len(data)} repos")
            elif resp.status_code == 403:
                self._update_rate_limit()
                self._check_rate_limit()
            else:
                print(f"Error: {resp.status_code}")
                break
        
        return repos

    def search_repos(self, query, max_pages=10):
        """Search repositories by query"""
        repos = []
        page = 1
        while page <= max_pages:
            self._check_rate_limit()
            url = 'https://api.github.com/search/repositories'
            params = {'q': query, 'page': page, 'per_page': 100}
            resp = self.session.get(url, params=params)
            
            if resp.status_code == 200:
                data = resp.json()
                if not data.get('items'):
                    break
                repos.extend(data['items'])
                page += 1
                print(f"  Page {page-1}: {len(data['items'])} repos")
            elif resp.status_code == 403:
                self._update_rate_limit()
                self._check_rate_limit()
            else:
                print(f"Error: {resp.status_code}")
                break
        
        return repos

    def get_repo_info(self, owner, repo):
        """Get detailed repository information"""
        self._check_rate_limit()
        url = f'https://api.github.com/repos/{owner}/{repo}'
        resp = self.session.get(url)
        
        if resp.status_code == 200:
            return resp.json()
        elif resp.status_code == 403:
            self._update_rate_limit()
            self._check_rate_limit()
            return None
        else:
            print(f"Error: {resp.status_code}")
            return None

    def save_results(self, data, filename):
        """Save results to JSON file"""
        with open(filename, 'w', encoding='utf-8') as f:
            json.dump(data, f, indent=2, default=str)
        print(f"Saved {len(data)} items to {filename}")

# Example usage
if __name__ == '__main__':
    scraper = GitHubScraper()
    
    # Get user repositories
    print("=== Getting user repositories ===")
    user = "Parth971"
    repos = scraper.get_user_repos(user, max_pages=5)
    scraper.save_results(repos, f"{user}_repos.json")
    
    # Search for trending repos
    print("\n=== Searching for Python repositories ===")
    search_results = scraper.search_repos("language:python stars:>100", max_pages=3)
    scraper.save_results(search_results, "python_trending.json")
    
    print(f"\nTotal: {len(repos)} repos from user, {len(search_results)} from search")
