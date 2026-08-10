# ============================================
# DATA ENRICHMENT – Adds Context to Raw Data
# ============================================

import json
import re
from datetime import datetime

def enrich_phone(phone):
    """Add context to phone numbers"""
    enriched = {
        'raw': phone,
        'type': 'phone',
        'valid': True,
        'formatted': re.sub(r'[^0-9+]', '', str(phone)),
        'country_code': None,
        'source_type': 'government_website'
    }
    
    # Try to detect country code
    clean = enriched['formatted']
    if clean.startswith('+'):
        # International format
        match = re.match(r'\+(\d{1,3})', clean)
        if match:
            enriched['country_code'] = match.group(1)
    else:
        # Try to detect US numbers
        if len(clean) == 10:
            enriched['country_code'] = '1'
            enriched['formatted'] = f'+1{clean}'
    
    return enriched

def enrich_url(url):
    """Add context to URLs"""
    enriched = {
        'raw': url,
        'type': 'url',
        'domain': None,
        'path': None,
        'source_type': 'government_website'
    }
    
    # Extract domain
    match = re.search(r'https?://(?:www\.)?([^/]+)', url)
    if match:
        enriched['domain'] = match.group(1)
    
    # Extract path
    match = re.search(r'https?://[^/]+(/[^?#]*)', url)
    if match:
        enriched['path'] = match.group(1) or '/'
    
    return enriched

def enrich_social(social_item):
    """Add context to social profiles"""
    enriched = {
        'platform': social_item.get('platform', ''),
        'username': social_item.get('username', ''),
        'url': social_item.get('url', ''),
        'type': 'social',
        'source_type': 'government_website',
        'official': False,
        'verified': False
    }
    
    # Mark official government accounts
    official_keywords = ['whitehouse', 'statedept', 'un', 'usagov', 'gov', 'canada', 'uk']
    platform = enriched['platform'].lower()
    username = enriched['username'].lower()
    
    if any(kw in username or kw in platform for kw in official_keywords):
        enriched['official'] = True
    
    return enriched

def enrich_data(data):
    """Enrich all data in the dataset"""
    enriched = {
        'phones': [],
        'urls': [],
        'social': [],
        'emails': [],
        'addresses': [],
        'metadata': {
            'enriched_date': datetime.now().isoformat(),
            'source': 'government_websites',
            'version': '1.0'
        }
    }
    
    # Enrich phones
    for phone in data.get('phones', []):
        enriched['phones'].append(enrich_phone(phone.get('value', '')))
    
    # Enrich URLs
    for url in data.get('urls', []):
        enriched['urls'].append(enrich_url(url.get('value', '')))
    
    # Enrich social
    for social in data.get('social', []):
        enriched['social'].append(enrich_social(social))
    
    # Copy emails and addresses (no enrichment needed)
    enriched['emails'] = data.get('emails', [])
    enriched['addresses'] = data.get('addresses', [])
    
    return enriched

# Load your cleaned data
with open('cleaned_data_20260810_104012.json', 'r') as f:
    data = json.load(f)

# Enrich it
enriched = enrich_data(data)

# Save enriched data
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
with open(f'enriched_data_{timestamp}.json', 'w') as f:
    json.dump(enriched, f, indent=2, default=str)

# Generate research report
print("="*60)
print("📊 ENRICHED DATA REPORT")
print("="*60)
print(f"📱 Phones: {len(enriched['phones'])}")
print(f"🔗 URLs: {len(enriched['urls'])}")
print(f"👤 Social: {len(enriched['social'])}")
print(f"📧 Emails: {len(enriched['emails'])}")
print(f"🏠 Addresses: {len(enriched['addresses'])}")

# Government accounts detected
official = [s for s in enriched['social'] if s.get('official')]
print(f"\n🏛️ Official government accounts detected: {len(official)}")
for s in official[:5]:
    print(f"  ✓ {s['platform']}: {s['username']}")

print("\n✅ Enriched data saved to:")
print(f"  enriched_data_{timestamp}.json")
