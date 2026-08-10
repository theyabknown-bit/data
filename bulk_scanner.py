import requests
import re
import time

def extract_phones(url):
    try:
        response = requests.get(url, timeout=15, headers={"User-Agent": "Mozilla/5.0"})
        patterns = [
            r'\+\d{1,4}[\s\-]?\(?\d{1,4}\)?[\s\-]?\d{1,4}[\s\-]?\d{1,4}',
            r'\d{3}[\s\-]?\d{3}[\s\-]?\d{4}',
            r'\(?\d{3}\)?[\s\-]?\d{3}[\s\-]?\d{4}',
            r'\d{10,15}'
        ]
        phones = []
        for pattern in patterns:
            phones.extend(re.findall(pattern, response.text))
        return list(set(phones))
    except Exception as e:
        print(f"Error: {e}")
        return []

def extract_emails(url):
    try:
        response = requests.get(url, timeout=15, headers={"User-Agent": "Mozilla/5.0"})
        pattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
        emails = re.findall(pattern, response.text)
        return list(set(emails))
    except Exception as e:
        print(f"Error: {e}")
        return []

# Targets to scan
targets = [
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_Australia",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_India",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_China",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_the_United_Kingdom",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_the_United_States",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_Canada",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_Germany",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_France",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_Japan",
    "https://en.wikipedia.org/wiki/Telephone_numbers_in_Brazil"
]

all_phones = []
all_emails = []

print("=" * 60)
print("SCANNING MULTIPLE SOURCES")
print("=" * 60)

for target in targets:
    print(f"\n[+] Scanning: {target}")
    
    phones = extract_phones(target)
    emails = extract_emails(target)
    
    if phones:
        print(f"    📱 Found {len(phones)} phone numbers")
        all_phones.extend(phones)
    if emails:
        print(f"    📧 Found {len(emails)} emails")
        all_emails.extend(emails)
    
    time.sleep(0.5)

print("\n" + "=" * 60)
print("SUMMARY")
print("=" * 60)
print(f"Total phone numbers found: {len(all_phones)}")
print(f"Total emails found: {len(all_emails)}")

# Save results
with open("phone_numbers_extracted.txt", "w") as f:
    f.write("\n".join(all_phones))
print(f"\n✅ Phone numbers saved to: phone_numbers_extracted.txt")

with open("emails_extracted.txt", "w") as f:
    f.write("\n".join(all_emails))
print(f"✅ Emails saved to: emails_extracted.txt")
