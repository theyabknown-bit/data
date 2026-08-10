import json

# Load your cleaned data
with open('C:/Users/theya/Google Drive/DataHarvester_Backup/harvest_2026-08-10_095810/cleaned_data_20260810_104012.json', 'r') as f:
    data = json.load(f)

# Create a flat array for the frontend
output = []

# Add phones
for item in data.get('phones', []):
    output.append({
        'type': 'phone',
        'value': item.get('value', ''),
        'source': item.get('source', '')
    })

# Add emails
for item in data.get('emails', []):
    output.append({
        'type': 'email',
        'value': item.get('value', ''),
        'source': item.get('source', '')
    })

# Add addresses
for item in data.get('addresses', []):
    output.append({
        'type': 'address',
        'value': item.get('value', ''),
        'source': item.get('source', '')
    })

# Add URLs
for item in data.get('urls', []):
    output.append({
        'type': 'url',
        'value': item.get('value', ''),
        'source': item.get('source', '')
    })

# Add social
for item in data.get('social', []):
    output.append({
        'type': 'social',
        'value': f"{item.get('platform', '')}: {item.get('username', '')}",
        'source': item.get('source', '')
    })

# Save to docs/data/data.json
with open('docs/data/data.json', 'w') as f:
    json.dump(output, f, indent=2)

print(f"✅ Created data.json with {len(output)} entries")
print(f"  Phones: {len(data.get('phones', []))}")
print(f"  URLs: {len(data.get('urls', []))}")
print(f"  Social: {len(data.get('social', []))}")
