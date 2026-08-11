# ============================================
# ENHANCED AUTO-CRAWLER v2.0
# 10,000+ SITES - ALL FEATURES
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"
$telegramToken = "8920421579:AAFg4xSpqIEy6yWHOb-38XKAu-RHp5sovLE"
$telegramChatId = "8606735568"

# ============================================
# MASSIVE DOMAIN LIST - 200+ DOMAINS
# Each domain generates multiple URLs
# ============================================

$domainList = @(
    # Government
    ".gov.ae", ".gov.sa", ".gov.in", ".gov.uk", ".gov.us",
    ".gov.au", ".gov.ca", ".gov.de", ".gov.fr", ".gov.jp",
    ".gov.sg", ".gov.my", ".gov.qa", ".gov.om", ".gov.bh",
    ".gov.kw", ".gov.eg", ".gov.za", ".gov.br", ".gov.mx",
    
    # News
    "bbc.com", "cnn.com", "reuters.com", "apnews.com", "bloomberg.com",
    "aljazeera.com", "gulfnews.com", "khaleejtimes.com", "arabnews.com",
    "theguardian.com", "nytimes.com", "washingtonpost.com", "wsj.com",
    "thetimes.co.uk", "independent.co.uk", "telegraph.co.uk", "ft.com",
    "economist.com", "businessinsider.com", "forbes.com", "cnbc.com",
    "marketwatch.com", "barron.com", "seekingalpha.com", "finance.yahoo.com",
    "thedailybeast.com", "politico.com", "thehill.com", "axios.com",
    
    # Tech
    "github.com", "stackoverflow.com", "medium.com", "dev.to",
    "techcrunch.com", "wired.com", "arstechnica.com", "theverge.com",
    "techmeme.com", "hackernews.com", "producthunt.com", "betakit.com",
    "venturebeat.com", "siliconangle.com", "tech.eu", "theregister.com",
    "zdnet.com", "cnet.com", "engadget.com", "gizmodo.com",
    
    # Social Media
    "twitter.com", "instagram.com", "facebook.com", "linkedin.com",
    "youtube.com", "reddit.com", "tiktok.com", "snapchat.com",
    "pinterest.com", "tumblr.com", "flickr.com", "vimeo.com",
    "discord.com", "telegram.org", "signal.org", "whatsapp.com",
    
    # UAE Government
    "moia.gov.ae", "mof.gov.ae", "dubaipolice.gov.ae", "abudhabi.ae",
    "sharjah.ae", "rak.ae", "ajman.ae", "uaq.ae", "fujairah.ae",
    "visitabudhabi.ae", "dubai.ae", "moh.gov.ae", "dha.gov.ae",
    "seha.ae", "doh.gov.ae", "haad.ae",
    
    # Saudi Government
    "moi.gov.sa", "mof.gov.sa", "mci.gov.sa", "moh.gov.sa",
    "moe.gov.sa", "my.gov.sa", "vision2030.gov.sa", "saudi.gov.sa",
    "sfda.gov.sa", "chi.gov.sa",
    
    # India Government
    "nic.in", "india.gov.in", "mea.gov.in", "mha.gov.in",
    "gsi.gov.in", "mohfw.gov.in", "education.gov.in", "cbhi.gov.in",
    "icmr.gov.in", "nhp.gov.in",
    
    # UK Government
    "gov.uk", "parliament.uk", "nhs.uk", "bbc.co.uk",
    "met.police.uk", "nationalcrimeagency.gov.uk",
    
    # US Government
    "usa.gov", "whitehouse.gov", "congress.gov", "state.gov",
    "defense.gov", "fbi.gov", "cia.gov", "nsa.gov",
    "cdc.gov", "nih.gov", "fda.gov", "usda.gov",
    "commerce.gov", "justice.gov", "treasury.gov",
    
    # Education
    "harvard.edu", "mit.edu", "stanford.edu", "oxford.ac.uk",
    "cambridge.org", "ucl.ac.uk", "imperial.ac.uk", "ethz.ch",
    "nus.edu.sg", "ntu.edu.sg", "hkust.edu.hk", "kyoto-u.ac.jp",
    "unsw.edu.au", "sydney.edu.au", "melbourne.edu.au",
    "coursera.org", "edx.org", "udemy.com", "khanacademy.org",
    
    # Healthcare
    "who.int", "mayoclinic.org", "webmd.com", "healthline.com",
    "medicalnewstoday.com", "medscape.com", "drugs.com", "rxlist.com",
    
    # Business
    "amazon.com", "apple.com", "microsoft.com", "google.com",
    "facebook.com", "netflix.com", "tesla.com", "spacex.com",
    "uber.com", "airbnb.com", "slack.com", "zoom.us",
    "salesforce.com", "oracle.com", "ibm.com", "cisco.com",
    "intel.com", "amd.com", "nvidia.com", "qualcomm.com",
    
    # Regional
    "thenationalnews.com", "gulf-times.com", "omanobserver.om",
    "qatar-tribune.com", "kuwaittimes.net", "bna.bh",
    "arabtimesonline.com", "jordantimes.com", "dailynewsegypt.com",
    
    # Reference
    "wikipedia.org", "archive.org", "britannica.com",
    "sciencedirect.com", "nature.com", "science.org",
    "theatlantic.com", "nationalgeographic.com",
    
    # Sports
    "espn.com", "skysports.com", "bbc.co.uk/sport",
    "theathletic.com", "sportingnews.com",
    
    # Entertainment
    "imdb.com", "rottentomatoes.com", "metacritic.com",
    "billboard.com", "rollingstone.com", "pitchfork.com",
    
    # International
    "lemonde.fr", "elpais.com", "corriere.it", "spiegel.de",
    "nypost.com", "chicagotribune.com", "latimes.com",
    "bostonglobe.com", "usatoday.com", "denverpost.com",
    "seattletimes.com", "sfchronicle.com"
)

# ============================================
# USER AGENTS - ROTATE TO AVOID DETECTION
# ============================================

$userAgents = @(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/120.0",
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1",
    "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
)

# ============================================
# PATHS TO EXPLORE
# ============================================

$paths = @(
    "", "/", "/about", "/contact", "/services", "/products", "/team",
    "/blog", "/news", "/press", "/careers", "/events", "/shop",
    "/download", "/docs", "/api", "/help", "/support", "/login",
    "/register", "/dashboard", "/profile", "/settings", "/privacy",
    "/terms", "/faq", "/sitemap", "/robots.txt", "/feed",
    "/archive", "/category", "/tag", "/author", "/search"
)

# ============================================
# GENERATE 10,000+ TARGETS
# ============================================

function Generate-MassiveTargets {
    param([int]$Count = 10000)
    
    $targets = @()
    $random = [System.Random]::new()
    
    Write-Host "📋 Generating $Count targets..." -ForegroundColor Yellow
    
    while ($targets.Count -lt $Count) {
        $domain = $domainList | Get-Random
        $path = $paths | Get-Random
        
        # Add with www and without
        if ($random.Next(0, 2) -eq 0) {
            $target = "https://www.$domain$path"
        } else {
            $target = "https://$domain$path"
        }
        
        # Add variations
        $variations = @(
            $target,
            $target + "/",
            $target + "?page=1",
            $target + "?sort=recent",
            $target + "?filter=all"
        )
        
        $targets += $variations | Where-Object { $_ -notin $targets }
        
        if ($targets.Count % 1000 -eq 0) {
            Write-Host "   Generated: $($targets.Count)/$Count" -ForegroundColor Gray
        }
    }
    
    Write-Host "   ✅ $($targets.Count) targets generated" -ForegroundColor Green
    return $targets | Select-Object -First $Count
}

# ============================================
# SMART CRAWLER WITH ALL FEATURES
# ============================================

function Invoke-SmartCrawl {
    param(
        [string[]]$Targets,
        [int]$MaxConcurrent = 20,
        [int]$DelayMs = 1000,
        [string]$OutputPath
    )
    
    $results = @()
    $total = $Targets.Count
    $processed = 0
    $success = 0
    $failed = 0
    $startTime = Get-Date
    
    Send-Discord -Title "🚀 MASSIVE CRAWL START" -Message "Targets: $total`nConcurrent: $MaxConcurrent" -Color "0x00ff88"
    Send-Telegram -Message "🚀 <b>MASSIVE CRAWL START</b>`nTargets: $total"
    
    $batchSize = 50
    for ($i = 0; $i -lt $total; $i += $batchSize) {
        $batch = $Targets[$i..([Math]::Min($i + $batchSize - 1, $total - 1))]
        
        $batchResults = @()
        
        foreach ($url in $batch) {
            # Random User-Agent
            $ua = $userAgents | Get-Random
            
            try {
                $response = Invoke-WebRequest -Uri $url -TimeoutSec 15 -UseBasicParsing -Headers @{
                    "User-Agent" = $ua
                    "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
                    "Accept-Language" = "en-US,en;q=0.9"
                    "Accept-Encoding" = "gzip, deflate, br"
                    "Connection" = "keep-alive"
                    "Upgrade-Insecure-Requests" = "1"
                }
                
                # Extract data
                $html = $response.Content
                $emails = [regex]::Matches($html, '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}') | ForEach-Object { $_.Value } | Select-Object -Unique
                $phones = [regex]::Matches($html, '\+\d{1,3}[-\s]?\d{3,15}|00\d{1,3}[-\s]?\d{3,15}|\(\d{1,3}\)[-\s]?\d{3,15}') | ForEach-Object { $_.Value } | Select-Object -Unique
                
                $batchResults += @{
                    Url = $url
                    Status = "Success"
                    StatusCode = $response.StatusCode
                    Length = $response.Content.Length
                    Emails = $emails -join ", "
                    Phones = $phones -join ", "
                    UserAgent = $ua
                }
                $success++
                
            } catch {
                $batchResults += @{
                    Url = $url
                    Status = "Failed"
                    Error = $_.Exception.Message
                    Emails = ""
                    Phones = ""
                    UserAgent = $ua
                }
                $failed++
            }
            
            $processed++
            
            # Rate limiting
            Start-Sleep -Milliseconds $DelayMs
        }
        
        $results += $batchResults
        
        # Progress update
        if ($processed % 100 -eq 0) {
            $elapsed = (Get-Date) - $startTime
            $rate = [math]::Round($processed / $elapsed.TotalSeconds, 1)
            $eta = [math]::Round(($total - $processed) / $rate, 0)
            
            $progress = [math]::Round(($processed / $total) * 100, 1)
            Send-Discord -Title "📊 PROGRESS" -Message "Processed: $processed/$total ($progress%)`nSuccess: $success`nFailed: $failed`nRate: $rate/s`nETA: $eta seconds" -Color "0x00ccff"
            
            if ($processed % 500 -eq 0) {
                Send-Telegram -Message "📊 <b>PROGRESS</b>`n$processed/$total ($progress%)`nSuccess: $success`nFailed: $failed"
            }
        }
    }
    
    $endTime = Get-Date
    $duration = $endTime - $startTime
    
    Send-Discord -Title "✅ MASSIVE CRAWL COMPLETE" -Message "Total: $total`nSuccess: $success`nFailed: $failed`nDuration: $($duration.ToString('hh\:mm\:ss'))" -Color "0x00ff00"
    Send-Telegram -Message "✅ <b>MASSIVE CRAWL COMPLETE</b>`nTotal: $total`nSuccess: $success`nFailed: $failed`nDuration: $($duration.ToString('hh\:mm\:ss'))"
    
    return $results
}

# ============================================
# BACKUP TO GOOGLE DRIVE WITH SIZE
# ============================================

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\MassiveCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    
    $size = [math]::Round((Get-ChildItem $SourcePath -Recurse | Measure-Object Length -Sum).Sum / 1MB, 2)
    $files = (Get-ChildItem $SourcePath -Recurse -File).Count
    
    Send-Discord -Title "💾 GOOGLE DRIVE BACKUP" -Message "Folder: $(Split-Path $backupDir -Leaf)`nFiles: $files`nSize: $size MB" -Color "0xffaa00"
    Send-Telegram -Message "💾 <b>GOOGLE DRIVE BACKUP</b>`nFiles: $files`nSize: $size MB"
    
    return $backupDir
}

# ============================================
# PUSH TO GITHUB WITH SUMMARY
# ============================================

function Push-ToGitHub {
    param([string]$SourcePath, [string]$Summary)
    
    Set-Location "C:\Users\theya\Desktop\data-repo"
    
    Copy-Item -Path $SourcePath -Destination . -Recurse -Force
    
    git add .
    git commit -m "MassiveCrawl: $Summary"
    git push origin main
    
    Send-Discord -Title "📤 GITHUB PUSH" -Message "$Summary" -Color "0x8800ff"
}

# ============================================
# DELETE LOCAL FILES
# ============================================

function Delete-LocalFiles {
    param([string]$Path)
    
    $files = Get-ChildItem -Path $Path -Recurse -File
    $count = $files.Count
    
    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Send-Discord -Title "🗑️ LOCAL DELETED" -Message "Files removed: $count" -Color "0xff4444"
}

# ============================================
# MAIN EXECUTION
# ============================================

Clear-Host
Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     🌐 MASSIVE CRAWLER v2.0 - 10,000 SITES                      ║
║                                                                   ║
║     ✅ 200+ domains                                              ║
║     ✅ 10,000+ targets                                           ║
║     ✅ Random User Agents                                        ║
║     ✅ Data Extraction                                           ║
║     ✅ Auto-backup to Google Drive                              ║
║     ✅ Auto-push to GitHub                                      ║
║     ✅ Auto-delete local                                        ║
║     ✅ Real-time Discord + Telegram updates                    ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Generate targets
$targets = Generate-MassiveTargets -Count 10000

# Create output folder
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outputPath = "$env:USERPROFILE\Desktop\MassiveCrawl_$timestamp"
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

# Save targets
$targets | Out-File "$outputPath\targets_10k.txt"

# Crawl
$results = Invoke-SmartCrawl -Targets $targets -MaxConcurrent 20 -DelayMs 500 -OutputPath $outputPath

# Save results
$results | Export-Csv -Path "$outputPath\results_10k.csv" -NoTypeInformation

# Create summary
$success = ($results | Where-Object { $_.Status -eq "Success" }).Count
$failed = ($results | Where-Object { $_.Status -eq "Failed" }).Count
$totalEmails = ($results | ForEach-Object { $_.Emails }).Count
$totalPhones = ($results | ForEach-Object { $_.Phones }).Count

$summary = @"
CRAWL SUMMARY
=============
Targets: $($targets.Count)
Success: $success
Failed: $failed
Emails Found: $totalEmails
Phones Found: $totalPhones
Time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
"@
$summary | Out-File "$outputPath\summary.txt"

# Backup to Google Drive
$backupPath = Backup-ToGoogleDrive -SourcePath $outputPath

# Push to GitHub
Push-ToGitHub -SourcePath $outputPath -Summary "10,000 targets - $success success, $totalEmails emails"

# Delete local
Delete-LocalFiles -Path $outputPath

Write-Host @"
`n✅ MASSIVE CRAWL COMPLETE!
   Targets: $($targets.Count)
   Success: $success
   Failed: $failed
   Emails: $totalEmails
   Phones: $totalPhones
   Backup: $backupPath
   Local: Deleted
"@ -ForegroundColor Green

Send-Discord -Title "🎉 MASSIVE CRAWL COMPLETE" -Message "Targets: $($targets.Count)`nSuccess: $success`nEmails: $totalEmails`nPhones: $totalPhones" -Color "0x00ff00"
Send-Telegram -Message "🎉 <b>MASSIVE CRAWL COMPLETE</b>`nTargets: $($targets.Count)`nSuccess: $success`nEmails: $totalEmails`nPhones: $totalPhones"
