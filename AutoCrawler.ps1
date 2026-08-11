# ============================================
# AUTO-CRAWLER v1.0 - NEVER STOPS
# Different websites every time
# Auto-delete, backup to Google Drive + GitHub
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"
$telegramToken = "8920421579:AAFg4xSpqIEy6yWHOb-38XKAu-RHp5sovLE"
$telegramChatId = "8606735568"

# ============================================
# MASSIVE DOMAIN LIST (NEVER REPEATS)
# ============================================

$allDomains = @(
    # News Sites
    "bbc.com", "cnn.com", "reuters.com", "apnews.com", "bloomberg.com",
    "aljazeera.com", "gulfnews.com", "khaleejtimes.com", "arabnews.com",
    "theguardian.com", "nytimes.com", "washingtonpost.com", "wsj.com",
    "thetimes.co.uk", "independent.co.uk", "telegraph.co.uk", "ft.com",
    "economist.com", "businessinsider.com", "forbes.com", "cnbc.com",
    "marketwatch.com", "barron.com", "seekingalpha.com", "finance.yahoo.com",
    "thedailybeast.com", "politico.com", "thehill.com", "axios.com",
    
    # Tech Sites
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
    
    # Government Sites (UAE)
    "moia.gov.ae", "mof.gov.ae", "dubaipolice.gov.ae", "abudhabi.ae",
    "sharjah.ae", "rak.ae", "ajman.ae", "uaq.ae", "fujairah.ae",
    "visitabudhabi.ae", "dubai.ae", "moh.gov.ae", "dha.gov.ae",
    "seha.ae", "doh.gov.ae", "haad.ae",
    
    # Government Sites (Saudi)
    "moi.gov.sa", "mof.gov.sa", "mci.gov.sa", "moh.gov.sa",
    "moe.gov.sa", "my.gov.sa", "vision2030.gov.sa", "saudi.gov.sa",
    "sfda.gov.sa", "chi.gov.sa",
    
    # Government Sites (India)
    "nic.in", "india.gov.in", "mea.gov.in", "mha.gov.in",
    "gsi.gov.in", "mohfw.gov.in", "education.gov.in", "cbhi.gov.in",
    "icmr.gov.in", "nhp.gov.in",
    
    # Government Sites (UK)
    "gov.uk", "parliament.uk", "nhs.uk", "bbc.co.uk",
    "met.police.uk", "nationalcrimeagency.gov.uk",
    
    # Government Sites (US)
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
    
    # Regional Sites
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
    
    # Additional International
    "lemonde.fr", "elpais.com", "corriere.it", "spiegel.de",
    "nypost.com", "chicagotribune.com", "latimes.com",
    "bostonglobe.com", "usatoday.com", "denverpost.com",
    "seattletimes.com", "sfchronicle.com"
)

# ============================================
# RANDOMIZE AND ROTATE DOMAINS
# ============================================

$random = [System.Random]::new()
$usedDomains = @()

function Get-RandomDomains {
    param([int]$Count = 20)
    
    # Check if we've used all domains
    if ($usedDomains.Count -ge $allDomains.Count) {
        Write-Host "🔄 All domains used! Resetting..." -ForegroundColor Yellow
        $global:usedDomains = @()
    }
    
    # Get available domains (not used recently)
    $available = $allDomains | Where-Object { $_ -notin $usedDomains }
    
    # If not enough available, reset
    if ($available.Count -lt $Count) {
        $global:usedDomains = @()
        $available = $allDomains
    }
    
    # Pick random domains
    $picked = $available | Get-Random -Count ([Math]::Min($Count, $available.Count))
    
    # Mark as used
    $global:usedDomains += $picked
    
    Write-Host "📋 Picked $($picked.Count) new domains (Used: $($usedDomains.Count)/$($allDomains.Count))" -ForegroundColor Gray
    
    return $picked | ForEach-Object { "https://$_" }
}

# ============================================
# SEND TO DISCORD
# ============================================

function Send-Discord {
    param([string]$Title, [string]$Message, [string]$Color = "0x00ff00")
    try {
        $payload = @{
            username = "AutoCrawler_$(Get-Random -Min 1000 -Max 9999)"
            embeds = @(@{
                title = $Title
                description = $Message
                color = [int]$Color
                timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ")
            })
        } | ConvertTo-Json -Depth 10
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json" -ErrorAction Stop
    } catch {}
}

# ============================================
# SEND TO TELEGRAM
# ============================================

function Send-Telegram {
    param([string]$Message)
    try {
        $url = "https://api.telegram.org/bot$telegramToken/sendMessage"
        $body = @{chat_id = $telegramChatId; text = $Message; parse_mode = "HTML"}
        Invoke-RestMethod -Uri $url -Method Post -Body $body -ErrorAction Stop
    } catch {}
}

# ============================================
# SAFE CRAWL
# ============================================

function Invoke-SafeCrawl {
    param([string[]]$Targets, [int]$MaxConcurrent = 5)
    
    $results = @()
    $total = $Targets.Count
    $success = 0
    
    foreach ($url in $Targets) {
        try {
            Write-Host "   Crawling: $url" -ForegroundColor Gray
            $response = Invoke-WebRequest -Uri $url -TimeoutSec 15 -UseBasicParsing -Headers @{
                "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            }
            $results += @{Url=$url; Status="Success"; StatusCode=$response.StatusCode; Length=$response.Content.Length}
            $success++
            Write-Host "   ✅ Success ($($response.StatusCode))" -ForegroundColor Green
        } catch {
            $results += @{Url=$url; Status="Failed"; Error=$_.Exception.Message}
            Write-Host "   ❌ Failed" -ForegroundColor Red
        }
        Start-Sleep -Milliseconds 300
    }
    
    return $results
}

# ============================================
# BACKUP TO GOOGLE DRIVE
# ============================================

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\AutoCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    Send-Discord -Title "💾 BACKUP COMPLETE" -Message "Folder: $(Split-Path $backupDir -Leaf)`nSize: $([math]::Round((Get-ChildItem $SourcePath -Recurse | Measure-Object Length -Sum).Sum / 1KB, 2)) KB"
    return $backupDir
}

# ============================================
# DELETE LOCAL FILES
# ============================================

function Delete-LocalFiles {
    param([string]$Path)
    $count = (Get-ChildItem -Path $Path -Recurse -File).Count
    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
    Send-Discord -Title "🗑️ LOCAL DELETED" -Message "Files removed: $count"
}

# ============================================
# RUN FOREVER LOOP
# ============================================

Clear-Host
Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     🤖 AUTO-CRAWLER - RUNS FOREVER                               ║
║                                                                   ║
║     Different websites every cycle                               ║
║     Auto-backup to Google Drive + GitHub                        ║
║     Auto-delete local files                                     ║
║     Runs 24/7                                                   ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Send-Discord -Title "🤖 AUTO-CRAWLER STARTED" -Message "System will run continuously with different sites" -Color "0x00ff00"
Send-Telegram -Message "🤖 <b>AUTO-CRAWLER STARTED</b>`nSystem running 24/7"

$cycle = 0

while ($true) {
    $cycle++
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    
    Write-Host @"
`n========================================
🔄 CYCLE $cycle - $timestamp
========================================
"@ -ForegroundColor Cyan
    
    # Get fresh domains
    $targets = Get-RandomDomains -Count 20
    
    # Send status
    Send-Discord -Title "🔄 CYCLE $cycle" -Message "Targets: $($targets.Count)`nTime: $timestamp" -Color "0x00ccff"
    Send-Telegram -Message "🔄 <b>CYCLE $cycle</b>`nTargets: $($targets.Count)"
    
    # Crawl
    Write-Host "🌐 Crawling..." -ForegroundColor Yellow
    $results = Invoke-SafeCrawl -Targets $targets -MaxConcurrent 5
    
    $successCount = ($results | Where-Object { $_.Status -eq "Success" }).Count
    $failedCount = ($results | Where-Object { $_.Status -eq "Failed" }).Count
    
    # Save results
    $outputPath = "$env:USERPROFILE\Desktop\AutoCrawl_Cycle$cycle"
    New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
    $results | Export-Csv -Path "$outputPath\cycle_$cycle.csv" -NoTypeInformation
    $targets | Out-File "$outputPath\targets_$cycle.txt"
    
    # Backup to Google Drive
    Write-Host "💾 Backing up..." -ForegroundColor Yellow
    $backupPath = Backup-ToGoogleDrive -SourcePath $outputPath
    
    # Push to GitHub
    Write-Host "📤 Pushing to GitHub..." -ForegroundColor Yellow
    Set-Location "C:\Users\theya\Desktop\data-repo"
    Copy-Item -Path $outputPath -Destination . -Recurse -Force
    git add .
    git commit -m "AutoCrawl Cycle $cycle - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin main
    
    # Delete local
    Write-Host "🗑️ Deleting local..." -ForegroundColor Red
    Delete-LocalFiles -Path $outputPath
    
    Write-Host @"
`n✅ CYCLE $cycle COMPLETE!
   Success: $successCount
   Failed: $failedCount
   Backup: $backupPath
   Local: Deleted
"@ -ForegroundColor Green
    
    Send-Discord -Title "✅ CYCLE $cycle COMPLETE" -Message "Success: $successCount/$($targets.Count)" -Color "0x00ff00"
    Send-Telegram -Message "✅ <b>CYCLE $cycle COMPLETE</b>`nSuccess: $successCount/$($targets.Count)"
    
    # Calculate next cycle start
    $nextCycle = (Get-Date).AddMinutes(5).ToString('HH:mm:ss')
    Write-Host "⏳ Next cycle at: $nextCycle" -ForegroundColor Yellow
    
    # Wait 5 minutes before next cycle
    for ($i = 5; $i -gt 0; $i--) {
        Write-Host "   Waiting $i minutes..." -ForegroundColor Gray
        Start-Sleep -Seconds 60
    }
}
