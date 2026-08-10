import json

# Load your enriched data
with open('enriched_all_data_20260810_105824.json', 'r') as f:
    data = json.load(f)

# Create a flat array for the frontend
output = []

# Add phones (limit to 200 for website performance)
for item in data.get('phones', [])[:200]:
    output.append({
        'type': 'phone',
        'value': item.get('formatted', item.get('raw', '')),
        'source': item.get('source_type', '')
    })

# Add URLs (limit to 200)
for item in data.get('urls', [])[:200]:
    output.append({
        'type': 'url',
        'value': item.get('raw', ''),
        'source': item.get('domain', '')
    })

# Add social (limit to 200)
for item in data.get('social', [])[:200]:
    output.append({
        'type': 'social',
        'value': f"{item.get('platform', '')}: {item.get('username', '')}",
        'source': item.get('source_type', '')
    })

# Add emails
for item in data.get('emails', []):
    output.append({
        'type': 'email',
        'value': item,
        'source': 'extracted'
    })

# Save to docs/data/data.json
with open('docs/data/data.json', 'w') as f:
    json.dump(output, f, indent=2)

print(f"✅ data.json created with {len(output)} entries")
print(f"  Phones: {len([x for x in output if x['type'] == 'phone'])}")
print(f"  URLs: {len([x for x in output if x['type'] == 'url'])}")
print(f"  Social: {len([x for x in output if x['type'] == 'social'])}")
print(f"  Emails: {len([x for x in output if x['type'] == 'email'])}")
print(f"  Total: {len(output)}")
