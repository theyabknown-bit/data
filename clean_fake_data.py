import json

# Load the enriched data
with open('enriched_all_data_20260810_105824.json', 'r') as f:
    data = json.load(f)

# Remove test/fake entries
fake_emails = ['email@example.com', 'test@example.com', 'sample@example.com']
fake_phones = ['1234567890', '0987654321', '555-123-4567']

# Clean emails
data['emails'] = [e for e in data['emails'] if e not in fake_emails]

# Clean phones
data['phones'] = [p for p in data['phones'] if p.get('formatted', '').replace('+', '') not in fake_phones and len(p.get('formatted', '')) >= 10]

# Remove duplicates
seen = set()
data['phones'] = [p for p in data['phones'] if p.get('formatted') not in seen and not seen.add(p.get('formatted'))]

seen = set()
data['urls'] = [u for u in data['urls'] if u.get('raw') not in seen and not seen.add(u.get('raw'))]

# Save cleaned data
with open('enriched_cleaned.json', 'w') as f:
    json.dump(data, f, indent=2, default=str)

print(f"✅ Data cleaned!")
print(f"  Emails: {len(data['emails'])}")
print(f"  Phones: {len(data['phones'])}")
print(f"  URLs: {len(data['urls'])}")
print(f"  Social: {len(data['social'])}")
print(f"  Total: {len(data['emails']) + len(data['phones']) + len(data['urls']) + len(data['social'])}")

# Update the website data.json
website_data = []
for item in data.get('phones', [])[:500]:
    website_data.append({'type': 'phone', 'value': item.get('formatted', ''), 'source': item.get('source_type', '')})
for item in data.get('urls', [])[:500]:
    website_data.append({'type': 'url', 'value': item.get('raw', ''), 'source': item.get('domain', '')})
for item in data.get('social', [])[:500]:
    website_data.append({'type': 'social', 'value': f"{item.get('platform', '')}: {item.get('username', '')}", 'source': item.get('source_type', '')})
for item in data.get('emails', []):
    website_data.append({'type': 'email', 'value': item, 'source': 'extracted'})

with open('docs/data/data.json', 'w') as f:
    json.dump(website_data, f, indent=2)

print(f"✅ Website data.json updated with {len(website_data)} entries")
