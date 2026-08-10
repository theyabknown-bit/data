import asyncio
from holehe import core

async def check_email(email):
    print(f"\n[+] Checking: {email}")
    print("=" * 50)
    
    try:
        # Try core.maincore (likely the correct function)
        if hasattr(core, 'maincore'):
            print("Using core.maincore...")
            result = await core.maincore(email)
            
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
        else:
            print("No suitable function found.")
            
    except Exception as e:
        print(f"⚠️ Error: {e}")

if __name__ == "__main__":
    email = input("Enter email to check (or press Enter for default): ").strip()
    if not email:
        email = "theyabknown@gmail.com"
    asyncio.run(check_email(email))
