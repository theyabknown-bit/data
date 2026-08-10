# ============================================
# DATA CLEANER FOR PERSONAL RESEARCH
# Removes false positives, duplicates, invalid data
# ============================================

import re
import json
import os
from datetime import datetime

# Load the raw JSON data
with open('full_data_20260810_095737.json', 'r') as f:
    raw_data = json.load(f)

# ============================================
# VALIDATION FUNCTIONS
# ============================================

def is_valid_email(email):
    """Check if email is valid (not a false positive)"""
    if not email or '@' not in email:
        return False
    # Remove common false positives
    false_positives = ['@2x.png', '@3x.png', '@example.com', 'png', 'jpg', 'jpeg', 'gif']
    for fp in false_positives:
        if fp in email:
            return False
    # Must have a valid domain (at least 2 chars after dot)
    parts = email.split('@')
    if len(parts) != 2:
        return False
    domain = parts[1].lower()
    if '.' not in domain or len(domain.split('.')[-1]) < 2:
        return False
    return True

def is_valid_phone(phone):
    """Check if phone number is valid"""
    if not phone:
        return False
    # Remove common false positives
    phone = str(phone).strip()
    if len(phone) < 10 or len(phone) > 15:
        return False
    # Must contain mostly digits
    digits = re.sub(r'[\s\-+()]', '', phone)
    if not digits.isdigit() or len(digits) < 10:
        return False
    return True

def is_valid_address(address):
    """Check if address is valid (not page structure noise)"""
    if not address or len(address) < 10:
        return False
    address = str(address).lower()
    # Must contain a number and street indicator
    street_indicators = ['street', 'st ', 'avenue', 'ave ', 'road', 'rd ', 'drive', 'dr ', 'lane', 'ln ', 'court', 'ct ', 'way', 'plaza', 'square', 'circle', 'boulevard', 'blvd']
    has_street = any(indicator in address for indicator in street_indicators)
    # Must contain a number
    has_number = any(char.isdigit() for char in address)
    # Must not contain HTML/CSS noise
    html_noise = ['banner', 'optin', 'cmplz', 'layout', 'footer', 'header', 'widget', 'sidebar', 'class="', 'id="']
    is_noise = any(noise in address for noise in html_noise)
    return has_street and has_number and not is_noise

def is_valid_url(url):
    """Check if URL is valid"""
    if not url:
        return False
    url = str(url).strip()
    if not url.startswith(('http://', 'https://')):
        return False
    # Remove common broken URLs
    broken = ['...', '{{', '}}', '${', '()', '%s', 'undefined']
    for b in broken:
        if b in url:
            return False
    return True

def get_source_domain(url):
    """Extract domain from URL for grouping"""
    try:
        match = re.search(r'https?://(?:www\.)?([^/]+)', url)
        if match:
            return match.group(1)
    except:
        pass
    return 'unknown'

# ============================================
# CLEAN DATA
# ============================================

cleaned_data = {
    'emails': [],
    'phones': [],
    'addresses': [],
    'urls': [],
    'social': [],
    'by_source': {}
}

# Clean emails
seen_emails = set()
for item in raw_data.get('emails', []):
    email = item.get('value', '')
    source = item.get('source', '')
    if is_valid_email(email) and email not in seen_emails:
        cleaned_data['emails'].append({'value': email, 'source': source})
        seen_emails.add(email)

# Clean phones
seen_phones = set()
for item in raw_data.get('phones', []):
    phone = item.get('value', '')
    source = item.get('source', '')
    if is_valid_phone(phone) and phone not in seen_phones:
        cleaned_data['phones'].append({'value': phone, 'source': source})
        seen_phones.add(phone)

# Clean addresses
seen_addresses = set()
for item in raw_data.get('addresses', []):
    address = item.get('value', '')
    source = item.get('source', '')
    if is_valid_address(address) and address not in seen_addresses:
        cleaned_data['addresses'].append({'value': address, 'source': source})
        seen_addresses.add(address)

# Clean URLs
seen_urls = set()
for item in raw_data.get('urls', []):
    url = item.get('value', '')
    source = item.get('source', '')
    if is_valid_url(url) and url not in seen_urls:
        cleaned_data['urls'].append({'value': url, 'source': source})
        seen_urls.add(url)

# Clean social (already clean, just deduplicate)
seen_social = set()
for item in raw_data.get('social', []):
    key = f"{item.get('platform', '')}|{item.get('username', '')}"
    if key not in seen_social:
        cleaned_data['social'].append(item)
        seen_social.add(key)

# Group by source
for category in ['emails', 'phones', 'addresses', 'urls']:
    for item in cleaned_data[category]:
        domain = get_source_domain(item.get('source', ''))
        if domain not in cleaned_data['by_source']:
            cleaned_data['by_source'][domain] = {'emails': [], 'phones': [], 'addresses': [], 'urls': []}
        cleaned_data['by_source'][domain][category].append(item['value'])

# ============================================
# SAVE CLEANED DATA
# ============================================

timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

# Save cleaned JSON
with open(f"cleaned_data_{timestamp}.json", "w") as f:
    json.dump(cleaned_data, f, indent=2, default=str)

# Save text files
with open(f"cleaned_emails_{timestamp}.txt", "w") as f:
    f.write("\n".join([item['value'] for item in cleaned_data['emails']]))

with open(f"cleaned_phones_{timestamp}.txt", "w") as f:
    f.write("\n".join([item['value'] for item in cleaned_data['phones']]))

with open(f"cleaned_addresses_{timestamp}.txt", "w") as f:
    f.write("\n".join([item['value'] for item in cleaned_data['addresses']]))

with open(f"cleaned_urls_{timestamp}.txt", "w") as f:
    f.write("\n".join([item['value'] for item in cleaned_data['urls']]))

# Summary report
print("=" * 60)
print("DATA CLEANING COMPLETE")
print("=" * 60)
print(f"📧 Emails: {len(raw_data['emails'])} → {len(cleaned_data['emails'])} valid")
print(f"📱 Phones: {len(raw_data['phones'])} → {len(cleaned_data['phones'])} valid")
print(f"🏠 Addresses: {len(raw_data['addresses'])} → {len(cleaned_data['addresses'])} valid")
print(f"🔗 URLs: {len(raw_data['urls'])} → {len(cleaned_data['urls'])} valid")
print(f"👤 Social: {len(raw_data['social'])} → {len(cleaned_data['social'])} valid")
print("=" * 60)

# Print invalid counts
print("\n❌ Removed (false positives):")
print(f"  Emails: {len(raw_data['emails']) - len(cleaned_data['emails'])}")
print(f"  Phones: {len(raw_data['phones']) - len(cleaned_data['phones'])}")
print(f"  Addresses: {len(raw_data['addresses']) - len(cleaned_data['addresses'])}")
print(f"  URLs: {len(raw_data['urls']) - len(cleaned_data['urls'])}")
print("=" * 60)

print(f"\n✅ Cleaned data saved with timestamp: {timestamp}")
print(f"  cleaned_data_{timestamp}.json")
print(f"  cleaned_emails_{timestamp}.txt")
print(f"  cleaned_phones_{timestamp}.txt")
print(f"  cleaned_addresses_{timestamp}.txt")
print(f"  cleaned_urls_{timestamp}.txt")
