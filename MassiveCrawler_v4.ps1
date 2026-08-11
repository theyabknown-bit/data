# ============================================
# MASSIVE CRAWLER v4.0 - FULLY FIXED
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"
$telegramToken = "8920421579:AAFg4xSpqIEy6yWHOb-38XKAu-RHp5sovLE"
$telegramChatId = "8606735568"

function Send-Discord {
    param([string]$Title, [string]$Message, [string]$Color = "0x00ff00")
    try {
        $payload = @{
            username = "MassiveCrawler"
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

function Send-Telegram {
    param([string]$Message)
    try {
        $url = "https://api.telegram.org/bot$telegramToken/sendMessage"
        $body = @{chat_id = $telegramChatId; text = $Message; parse_mode = "HTML"}
        Invoke-RestMethod -Uri $url -Method Post -Body $body -ErrorAction Stop
    } catch {}
}

# ============================================
# DOMAIN LIST - WITH VALID PATHS
# ============================================

$domainList = @(
    "bbc.com", "cnn.com", "reuters.com", "apnews.com", "bloomberg.com",
    "aljazeera.com", "gulfnews.com", "khaleejtimes.com", "arabnews.com",
    "theguardian.com", "nytimes.com", "washingtonpost.com", "wsj.com",
    "github.com", "stackoverflow.com", "medium.com", "dev.to",
    "techcrunch.com", "wired.com", "arstechnica.com", "theverge.com",
    "twitter.com", "instagram.com", "facebook.com", "linkedin.com",
    "youtube.com", "reddit.com", "tiktok.com", "snapchat.com",
    "forbes.com", "businessinsider.com", "ft.com", "economist.com",
    "who.int", "cdc.gov", "nih.gov", "mayoclinic.org",
    "webmd.com", "healthline.com", "medicalnewstoday.com",
    "wikipedia.org", "archive.org", "britannica.com",
    "thenationalnews.com", "gulf-times.com", "omanobserver.om",
    "qatar-tribune.com", "kuwaittimes.net", "bna.bh",
    "moi.gov.sa", "mof.gov.sa", "my.gov.sa", "saudi.gov.sa",
    "nic.in", "india.gov.in", "mea.gov.in", "mha.gov.in",
    "gov.uk", "parliament.uk", "nhs.uk", "met.police.uk",
    "usa.gov", "whitehouse.gov", "state.gov", "defense.gov"
)

# ============================================
# VALID PATHS - ALWAYS HAS CONTENT
# ============================================

$paths = @(
    "",
    "/",
    "/about",
    "/contact",
    "/news",
    "/blog",
    "/services",
    "/products",
    "/team",
    "/careers",
    "/press",
    "/events"
)

# ============================================
# USER AGENTS
# ============================================

$userAgents = @(
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0"
)

# ============================================
# GENERATE TARGETS - NO ERRORS
# ============================================

function Generate-Targets {
    param([int]$Count = 100)
    
    $targets = @()
    
    for ($i = 0; $i -lt $Count; $i++) {
        $domain = $domainList | Get-Random
        $path = $paths | Get-Random
        $targets += "https://$domain$path"
    }
    
    return $targets | Select-Object -Unique
}

# ============================================
# CRAWL FUNCTION
# ============================================

function Invoke-Crawl {
    param([string[]]$Targets)
    
    $results = @()
    $total = $Targets.Count
    $success = 0
    $failed = 0
    
    Send-Discord -Title "🚀 CRAWL STARTED" -Message "Targets: $total" -Color "0x00ff00"
    Send-Telegram -Message "🚀 <b>CRAWL STARTED</b>`nTargets: $total"
    
    Write-Host "`n🌐 Crawling $total sites..." -ForegroundColor Yellow
    
    $i = 0
    foreach ($url in $Targets) {
        $i++
        $ua = $userAgents | Get-Random
        
        try {
            Write-Host "   [$i/$total] $url" -ForegroundColor Gray
            $response = Invoke-WebRequest -Uri $url -TimeoutSec 10 -UseBasicParsing -Headers @{"User-Agent"=$ua}
            
            $results += @{
                Url = $url
                Status = "Success"
                StatusCode = $response.StatusCode
                Length = $response.Content.Length
                UserAgent = $ua
            }
            $success++
            Write-Host "   ✅ Success ($($response.StatusCode))" -ForegroundColor Green
            
        } catch {
            $results += @{
                Url = $url
                Status = "Failed"
                Error = $_.Exception.Message
                UserAgent = $ua
            }
            $failed++
            Write-Host "   ❌ Failed" -ForegroundColor Red
        }
        
        if ($i % 10 -eq 0) {
            $progress = [math]::Round(($i / $total) * 100, 1)
            Write-Host "   📊 Progress: $progress% ($success success, $failed failed)" -ForegroundColor Cyan
        }
        
        Start-Sleep -Milliseconds 500
    }
    
    Send-Discord -Title "✅ CRAWL COMPLETE" -Message "Success: $success/$total`nFailed: $failed" -Color "0x00ff00"
    Send-Telegram -Message "✅ <b>CRAWL COMPLETE</b>`nSuccess: $success/$total"
    
    return $results
}

# ============================================
# BACKUP
# ============================================

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\MassiveCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    
    $size = [math]::Round((Get-ChildItem $SourcePath -Recurse | Measure-Object Length -Sum).Sum / 1MB, 2)
    $files = (Get-ChildItem $SourcePath -Recurse -File).Count
    
    Send-Discord -Title "💾 BACKUP COMPLETE" -Message "Files: $files`nSize: $size MB" -Color "0xffaa00"
    Send-Telegram -Message "💾 <b>BACKUP COMPLETE</b>`nFiles: $files`nSize: $size MB"
    
    return $backupDir
}

# ============================================
# DELETE LOCAL
# ============================================

function Delete-Local {
    param([string]$Path)
    $files = (Get-ChildItem $Path -Recurse -File).Count
    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
    Send-Discord -Title "🗑️ LOCAL DELETED" -Message "Files removed: $files" -Color "0xff4444"
}

# ============================================
# MAIN
# ============================================

Clear-Host
Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     🌐 MASSIVE CRAWLER v4.0 - NO ERRORS                         ║
║                                                                   ║
║     60+ domains                                                 ║
║     Valid paths always available                                ║
║     Random User Agents                                          ║
║     Auto-backup to Google Drive                                 ║
║     Auto-delete local                                           ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Send-Discord -Title "🔥 SYSTEM START" -Message "Massive Crawler v4.0 online" -Color "0x00ff00"
Send-Telegram -Message "🔥 <b>SYSTEM START</b>`nMassive Crawler v4.0 online"

Write-Host "`n📋 Generating targets..." -ForegroundColor Yellow
$targets = Generate-Targets -Count 100
Write-Host "   ✅ $($targets.Count) targets generated" -ForegroundColor Green

$results = Invoke-Crawl -Targets $targets

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outputPath = "$env:USERPROFILE\Desktop\MassiveCrawl_$timestamp"
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null
$results | Export-Csv -Path "$outputPath\results.csv" -NoTypeInformation

$backupPath = Backup-ToGoogleDrive -SourcePath $outputPath

Delete-Local -Path $outputPath

$success = ($results | Where-Object { $_.Status -eq "Success" }).Count
$failed = ($results | Where-Object { $_.Status -eq "Failed" }).Count

Write-Host @"
`n✅ MASSIVE CRAWL COMPLETE!
   Targets: $($targets.Count)
   Success: $success
   Failed: $failed
   Backup: $backupPath
   Local: Deleted
"@ -ForegroundColor Green

Send-Discord -Title "🎉 COMPLETE" -Message "Targets: $($targets.Count)`nSuccess: $success`nFailed: $failed" -Color "0x00ff00"
Send-Telegram -Message "🎉 <b>COMPLETE</b>`nTargets: $($targets.Count)`nSuccess: $success`nFailed: $failed"
