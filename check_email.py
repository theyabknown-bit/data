import asyncio
import holehe

async def check_email(email):
    """Check email using holehe"""
    print(f"\n[+] Checking: {email}")
    print("=" * 50)
    
    try:
        # Method: Use the core module
        from holehe import core
        result = await core.holehe(email)
        
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
    except Exception as e:
        print(f"⚠️ Error: {e}")
        print("Trying alternative method...")
        try:
            import holehebetter
            holehebetter.holehe(email)
        except Exception as e2:
            print(f"⚠️ Alternative also failed: {e2}")

if __name__ == "__main__":
    email = input("Enter email to check (or press Enter for default): ").strip()
    if not email:
        email = "theyabknown@gmail.com"
    asyncio.run(check_email(email))
