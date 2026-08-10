import asyncio
from holehe import core

async def check_email(email):
    print(f"\n[+] Checking: {email}")
    print("=" * 50)
    
    try:
        # Try using core.main (it might accept an email parameter)
        if hasattr(core, 'main'):
            print("Using core.main...")
            result = await core.main(email)
            print_result(result)
        elif hasattr(core, 'maincore'):
            print("Using core.maincore...")
            result = await core.maincore(email)
            print_result(result)
        else:
            print("No suitable function found. Trying alternative...")
            # Try running the module directly
            import subprocess
            subprocess.run(["python", "-m", "holehe", email])
    except Exception as e:
        print(f"⚠️ Error: {e}")

def print_result(result):
    if result:
        found = []
        for site, data in result.items():
            if data.get("exists", False):
                found.append(site)
                print(f"  ✅ {site}")
        if found:
            print(f"\n✅ Found on {len(found)} sites: {', '.join(found)}")
        else:
            print("\n❌ Not found on any checked sites")
    else:
        print("❌ No results returned")

if __name__ == "__main__":
    email = input("Enter email to check (or press Enter for default): ").strip()
    if not email:
        email = "theyabknown@gmail.com"
    asyncio.run(check_email(email))
