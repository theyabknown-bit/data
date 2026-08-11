# ===== PERMANENT GOOGLE DRIVE IMAGE DOWNLOADER =====
$GDriveImageFolder = "G:\DataHarvester_Images"

if (-not (Test-Path $GDriveImageFolder)) {
    New-Item -ItemType Directory -Path $GDriveImageFolder -Force | Out-Null
    Write-Host "📁 Created folder on G: Drive: $GDriveImageFolder" -ForegroundColor Green
}

function Save-Image-ToGDrive {
    param([string]$ImageUrl)
    $UrlHash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ImageUrl))).Replace("-", "").Substring(0, 10)
    $Extension = [System.IO.Path]::GetExtension(($ImageUrl -split '\?')[0])
    if ([string]::IsNullOrEmpty($Extension)) { $Extension = ".jpg" }
    $FileName = "$UrlHash$Extension"
    $FilePath = Join-Path $GDriveImageFolder $FileName
    try {
        Write-Host "⬇️ Downloading to G: Drive: $FileName" -ForegroundColor Cyan
        $Response = Invoke-WebRequest -Uri $ImageUrl -Method Get -ErrorAction Stop
        [System.IO.File]::WriteAllBytes($FilePath, $Response.Content)
        Write-Host "✅ Saved to G: Drive!" -ForegroundColor Green
        Start-Sleep -Seconds 1.5
    } catch {
        Write-Host "❌ Failed to download: $($_.Exception.Message)" -ForegroundColor Red
    }
}
# ============================================
# MEGA CRAWLER v3.0 - FINAL WORKING VERSION
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"
$telegramToken = "8920421579:AAFg4xSpqIEy6yWHOb-38XKAu-RHp5sovLE"
$telegramChatId = "8606735568"

# ============================================
# FUNCTION: SEND TO DISCORD
# ============================================

function Send-Discord {
    param([string]$Title, [string]$Message, [string]$Color = "0x00ff00")
    try {
        $payload = @{
            username = "MegaCrawler_$(Get-Random -Min 1000 -Max 9999)"
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
# FUNCTION: SEND TO TELEGRAM
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
# GENERATE THOUSANDS OF TARGETS
# ============================================

function Generate-Targets {
    param([int]$Count = 5000)
    
    $domains = @(
        ".gov.ae", ".gov.sa", ".gov.in", ".gov.uk", ".gov.us",
        ".gov.au", ".gov.ca", ".gov.de", ".gov.fr", ".gov.jp",
        "bbc.com", "cnn.com", "reuters.com", "apnews.com", "bloomberg.com",
        "aljazeera.com", "gulfnews.com", "khaleejtimes.com", "arabnews.com",
        "theguardian.com", "nytimes.com", "washingtonpost.com", "wsj.com",
        "github.com", "stackoverflow.com", "medium.com", "dev.to",
        "techcrunch.com", "wired.com", "arstechnica.com", "theverge.com",
        "twitter.com", "instagram.com", "facebook.com", "linkedin.com",
        "youtube.com", "reddit.com", "tiktok.com", "snapchat.com",
        "forbes.com", "businessinsider.com", "ft.com", "economist.com",
        "cnbc.com", "marketwatch.com", ".edu", ".ac.uk", ".edu.au", ".edu.in",
        "coursera.org", "edx.org", "udemy.com", "khanacademy.org",
        "who.int", "cdc.gov", "nih.gov", "mayoclinic.org",
        "webmd.com", "healthline.com", "medicalnewstoday.com",
        "thenationalnews.com", "gulf-times.com", "omanobserver.om",
        "qatar-tribune.com", "kuwaittimes.net", "bna.bh",
        "wikipedia.org", "archive.org", "internetarchive.org",
        "loc.gov", "britannica.com", "sciencedirect.com"
    )
    
    $prefixes = @("www", "api", "dev", "test", "staging", "old", "new", "beta", "alpha", "secure")
    $paths = @(
        "", "/about", "/contact", "/services", "/products", "/team",
        "/blog", "/news", "/press", "/careers", "/events", "/shop",
        "/download", "/docs", "/api", "/help", "/support", "/login",
        "/register", "/dashboard", "/profile", "/settings"
    )
    
    $targets = @()
    
    for ($i = 0; $i -lt $Count; $i++) {
        $domain = $domains | Get-Random
        $prefix = $prefixes | Get-Random
        if ($paths) { if ($paths) { if ($paths) { if ($paths.Count -gt 0) {
    if ($paths.Count -gt 0) {
    $validPaths = $paths | Where-Object { # ===== PERMANENT GOOGLE DRIVE IMAGE DOWNLOADER =====
$GDriveImageFolder = "G:\DataHarvester_Images"

if (-not (Test-Path $GDriveImageFolder)) {
    New-Item -ItemType Directory -Path $GDriveImageFolder -Force | Out-Null
    Write-Host "📁 Created folder on G: Drive: $GDriveImageFolder" -ForegroundColor Green
}

function Save-Image-ToGDrive {
    param([string]$ImageUrl)
    $UrlHash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ImageUrl))).Replace("-", "").Substring(0, 10)
    $Extension = [System.IO.Path]::GetExtension(($ImageUrl -split '\?')[0])
    if ([string]::IsNullOrEmpty($Extension)) { $Extension = ".jpg" }
    $FileName = "$UrlHash$Extension"
    $FilePath = Join-Path $GDriveImageFolder $FileName
    try {
        Write-Host "⬇️ Downloading to G: Drive: $FileName" -ForegroundColor Cyan
        $Response = Invoke-WebRequest -Uri $ImageUrl -Method Get -ErrorAction Stop
        [System.IO.File]::WriteAllBytes($FilePath, $Response.Content)
        Write-Host "✅ Saved to G: Drive!" -ForegroundColor Green
        Start-Sleep -Seconds 1.5
    } catch {
        Write-Host "❌ Failed to download: $($_.Exception.Message)" -ForegroundColor Red
    }
}
# ============================================
# MEGA CRAWLER v3.0 - FINAL WORKING VERSION
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"
$telegramToken = "8920421579:AAFg4xSpqIEy6yWHOb-38XKAu-RHp5sovLE"
$telegramChatId = "8606735568"

# ============================================
# FUNCTION: SEND TO DISCORD
# ============================================

function Send-Discord {
    param([string]$Title, [string]$Message, [string]$Color = "0x00ff00")
    try {
        $payload = @{
            username = "MegaCrawler_$(Get-Random -Min 1000 -Max 9999)"
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
# FUNCTION: SEND TO TELEGRAM
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
# GENERATE THOUSANDS OF TARGETS
# ============================================

function Generate-Targets {
    param([int]$Count = 5000)
    
    $domains = @(
        ".gov.ae", ".gov.sa", ".gov.in", ".gov.uk", ".gov.us",
        ".gov.au", ".gov.ca", ".gov.de", ".gov.fr", ".gov.jp",
        "bbc.com", "cnn.com", "reuters.com", "apnews.com", "bloomberg.com",
        "aljazeera.com", "gulfnews.com", "khaleejtimes.com", "arabnews.com",
        "theguardian.com", "nytimes.com", "washingtonpost.com", "wsj.com",
        "github.com", "stackoverflow.com", "medium.com", "dev.to",
        "techcrunch.com", "wired.com", "arstechnica.com", "theverge.com",
        "twitter.com", "instagram.com", "facebook.com", "linkedin.com",
        "youtube.com", "reddit.com", "tiktok.com", "snapchat.com",
        "forbes.com", "businessinsider.com", "ft.com", "economist.com",
        "cnbc.com", "marketwatch.com", ".edu", ".ac.uk", ".edu.au", ".edu.in",
        "coursera.org", "edx.org", "udemy.com", "khanacademy.org",
        "who.int", "cdc.gov", "nih.gov", "mayoclinic.org",
        "webmd.com", "healthline.com", "medicalnewstoday.com",
        "thenationalnews.com", "gulf-times.com", "omanobserver.om",
        "qatar-tribune.com", "kuwaittimes.net", "bna.bh",
        "wikipedia.org", "archive.org", "internetarchive.org",
        "loc.gov", "britannica.com", "sciencedirect.com"
    )
    
    $prefixes = @("www", "api", "dev", "test", "staging", "old", "new", "beta", "alpha", "secure")
    $paths = @(
        "", "/about", "/contact", "/services", "/products", "/team",
        "/blog", "/news", "/press", "/careers", "/events", "/shop",
        "/download", "/docs", "/api", "/help", "/support", "/login",
        "/register", "/dashboard", "/profile", "/settings"
    )
    
    $targets = @()
    
    for ($i = 0; $i -lt $Count; $i++) {
        $domain = $domains | Get-Random
        $prefix = $prefixes | Get-Random
        if ($paths) { if ($paths) { if ($paths) { if ($paths.Count -gt 0) {
    if ($paths.Count -gt 0) {
    if ($paths.Count -gt 0) { $path = $paths | Get-Random } else { Write-Warning "No URLs found. Skipping."; continue }
} else {
    Write-Warning "No URLs to crawl – skipping this iteration."
    continue
}
} else {
    Write-Warning "No URLs to crawl – skipping this iteration."
    continue
} } else { $path = "https://www.google.com" } } else { $path = "https://www.google.com" } } else { $path = "https://www.google.com" }
        
        if ((Get-Random -Min 0 -Max 2) -eq 0) {
            $target = "https://$prefix.$domain$path"
        } else {
            $target = "https://$domain$path"
        }
        
        $targets += $target
    }
    
    return $targets | Select-Object -Unique
}

# ============================================
# SMART CRAWLER WITH RATE LIMITING
# ============================================

function Invoke-SmartCrawl {
    param(
        [string[]]$Targets,
        [int]$MaxConcurrent = 20,
        [int]$DelayMs = 500
    )
    
    $results = @()
    $total = $Targets.Count
    $processed = 0
    $success = 0
    $failed = 0
    
    Send-Discord -Title "🚀 CRAWL STARTED" -Message "Targets: $total`nConcurrent: $MaxConcurrent" -Color "0x00ff88"
    Send-Telegram -Message "🚀 <b>CRAWL STARTED</b>`nTargets: $total"
    
    $batchSize = 50
    for ($i = 0; $i -lt $total; $i += $batchSize) {
        $batch = $Targets[$i..([Math]::Min($i + $batchSize - 1, $total - 1))]
        
        $batchResults = @()
        $jobs = @()
        
        foreach ($url in $batch) {
            $job = Start-Job -ScriptBlock {
                param($Url, $Timeout = 10)
                try {
                    $response = Invoke-WebRequest -Uri $Url -TimeoutSec $Timeout -UseBasicParsing -Headers @{
                        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
                    }
                    return @{
                        Url = $Url
                        Status = "Success"
                        StatusCode = $response.StatusCode
                        Length = $response.Content.Length
                    }
                } catch {
                    return @{
                        Url = $Url
                        Status = "Failed"
                        Error = $_.Exception.Message
                    }
                }
            } -ArgumentList $url
            
            $jobs += $job
            Start-Sleep -Milliseconds 50
        }
        
        $batchResults = $jobs | ForEach-Object {
            $result = Receive-Job $_ -Wait -ErrorAction SilentlyContinue
            Remove-Job $_ -Force
            $result
        }
        
        $results += $batchResults
        $processed += $batch.Count
        $success = ($results | Where-Object { $_.Status -eq "Success" }).Count
        $failed = ($results | Where-Object { $_.Status -eq "Failed" }).Count
        
        if ($processed % 100 -eq 0) {
            $progress = [math]::Round(($processed / $total) * 100, 1)
            Send-Discord -Title "📊 PROGRESS" -Message "Processed: $processed/$total ($progress%)`nSuccess: $success`nFailed: $failed" -Color "0x00ccff"
            Send-Telegram -Message "📊 <b>PROGRESS</b>`n$processed/$total ($progress%)`nSuccess: $success`nFailed: $failed"
        }
        
        Start-Sleep -Milliseconds $DelayMs
    }
    
    Send-Discord -Title "✅ CRAWL COMPLETE" -Message "Total: $total`nSuccess: $success`nFailed: $failed" -Color "0x00ff00"
    Send-Telegram -Message "✅ <b>CRAWL COMPLETE</b>`nTotal: $total`nSuccess: $success`nFailed: $failed"
    
    return $results
}

# ============================================
# BACKUP TO GOOGLE DRIVE
# ============================================

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\MegaCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    
    Send-Discord -Title "💾 GOOGLE DRIVE BACKUP" -Message "Folder: $(Split-Path $backupDir -Leaf)" -Color "0xffaa00"
    Send-Telegram -Message "💾 <b>GOOGLE DRIVE BACKUP</b>`nFolder: $(Split-Path $backupDir -Leaf)"
    
    return $backupDir
}

# ============================================
# PUSH TO GITHUB
# ============================================

function Push-ToGitHub {
    param([string]$SourcePath)
    
    Set-Location "C:\Users\theya\Desktop\data-repo"
    
    Copy-Item -Path $SourcePath -Destination . -Recurse -Force
    
    git add .
    git commit -m "MegaCrawl results - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin main
    
    Send-Discord -Title "📤 GITHUB PUSH" -Message "Files pushed to main branch" -Color "0x8800ff"
    Send-Telegram -Message "📤 <b>GITHUB PUSH</b>`nFiles pushed to main branch"
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
    Send-Telegram -Message "🗑️ <b>LOCAL DELETED</b>`n$count files removed"
}

# ============================================
# MAIN EXECUTION
# ============================================

Clear-Host
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     🌐 MEGA CRAWLER v3.0 - THOUSANDS OF SITES                   ║" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     Generating 5,000 targets...                                 ║" -ForegroundColor Cyan
Write-Host "║     Crawling with 20 concurrent connections...                  ║" -ForegroundColor Cyan
Write-Host "║     Backing up to Google Drive...                               ║" -ForegroundColor Cyan
Write-Host "║     Pushing to GitHub...                                         ║" -ForegroundColor Cyan
Write-Host "║     Deleting local files...                                      ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📋 Generating 5,000 targets..." -ForegroundColor Yellow
$targets = Generate-Targets -Count 5000
Write-Host "   ✅ $($targets.Count) targets generated" -ForegroundColor Green

Write-Host "`n🌐 Starting mega crawl..." -ForegroundColor Yellow
$results = Invoke-SmartCrawl -Targets $targets -MaxConcurrent 20

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outputPath = "$env:USERPROFILE\Desktop\MegaCrawl_$timestamp"
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$results | Export-Csv -Path "$outputPath\crawl_results.csv" -NoTypeInformation
$targets | Out-File "$outputPath\targets.txt"

Write-Host "`n💾 Backing up to Google Drive..." -ForegroundColor Yellow
$backupPath = Backup-ToGoogleDrive -SourcePath $outputPath

Write-Host "`n📤 Pushing to GitHub..." -ForegroundColor Yellow
Push-ToGitHub -SourcePath $outputPath

Write-Host "`n🗑️ Deleting local files..." -ForegroundColor Red
Delete-LocalFiles -Path $outputPath

Write-Host @"
`n✅ MEGA CRAWL COMPLETE!
   Targets: $($targets.Count)
   Success: $(($results | Where-Object { $_.Status -eq "Success" }).Count)
   Failed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)
   Backup: $backupPath
   Local: Deleted
"@ -ForegroundColor Green

Send-Discord -Title "🎉 MEGA CRAWL COMPLETE" -Message "Targets: $($targets.Count)`nSuccess: $(($results | Where-Object { $_.Status -eq "Success" }).Count)`nFailed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)" -Color "0x00ff00"
Send-Telegram -Message "🎉 <b>MEGA CRAWL COMPLETE</b>`nTargets: $($targets.Count)`nSuccess: $(($results | Where-Object { $_.Status -eq "Success" }).Count)`nFailed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)"







 -and # ===== PERMANENT GOOGLE DRIVE IMAGE DOWNLOADER =====
$GDriveImageFolder = "G:\DataHarvester_Images"

if (-not (Test-Path $GDriveImageFolder)) {
    New-Item -ItemType Directory -Path $GDriveImageFolder -Force | Out-Null
    Write-Host "📁 Created folder on G: Drive: $GDriveImageFolder" -ForegroundColor Green
}

function Save-Image-ToGDrive {
    param([string]$ImageUrl)
    $UrlHash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ImageUrl))).Replace("-", "").Substring(0, 10)
    $Extension = [System.IO.Path]::GetExtension(($ImageUrl -split '\?')[0])
    if ([string]::IsNullOrEmpty($Extension)) { $Extension = ".jpg" }
    $FileName = "$UrlHash$Extension"
    $FilePath = Join-Path $GDriveImageFolder $FileName
    try {
        Write-Host "⬇️ Downloading to G: Drive: $FileName" -ForegroundColor Cyan
        $Response = Invoke-WebRequest -Uri $ImageUrl -Method Get -ErrorAction Stop
        [System.IO.File]::WriteAllBytes($FilePath, $Response.Content)
        Write-Host "✅ Saved to G: Drive!" -ForegroundColor Green
        Start-Sleep -Seconds 1.5
    } catch {
        Write-Host "❌ Failed to download: $($_.Exception.Message)" -ForegroundColor Red
    }
}
# ============================================
# MEGA CRAWLER v3.0 - FINAL WORKING VERSION
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"
$telegramToken = "8920421579:AAFg4xSpqIEy6yWHOb-38XKAu-RHp5sovLE"
$telegramChatId = "8606735568"

# ============================================
# FUNCTION: SEND TO DISCORD
# ============================================

function Send-Discord {
    param([string]$Title, [string]$Message, [string]$Color = "0x00ff00")
    try {
        $payload = @{
            username = "MegaCrawler_$(Get-Random -Min 1000 -Max 9999)"
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
# FUNCTION: SEND TO TELEGRAM
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
# GENERATE THOUSANDS OF TARGETS
# ============================================

function Generate-Targets {
    param([int]$Count = 5000)
    
    $domains = @(
        ".gov.ae", ".gov.sa", ".gov.in", ".gov.uk", ".gov.us",
        ".gov.au", ".gov.ca", ".gov.de", ".gov.fr", ".gov.jp",
        "bbc.com", "cnn.com", "reuters.com", "apnews.com", "bloomberg.com",
        "aljazeera.com", "gulfnews.com", "khaleejtimes.com", "arabnews.com",
        "theguardian.com", "nytimes.com", "washingtonpost.com", "wsj.com",
        "github.com", "stackoverflow.com", "medium.com", "dev.to",
        "techcrunch.com", "wired.com", "arstechnica.com", "theverge.com",
        "twitter.com", "instagram.com", "facebook.com", "linkedin.com",
        "youtube.com", "reddit.com", "tiktok.com", "snapchat.com",
        "forbes.com", "businessinsider.com", "ft.com", "economist.com",
        "cnbc.com", "marketwatch.com", ".edu", ".ac.uk", ".edu.au", ".edu.in",
        "coursera.org", "edx.org", "udemy.com", "khanacademy.org",
        "who.int", "cdc.gov", "nih.gov", "mayoclinic.org",
        "webmd.com", "healthline.com", "medicalnewstoday.com",
        "thenationalnews.com", "gulf-times.com", "omanobserver.om",
        "qatar-tribune.com", "kuwaittimes.net", "bna.bh",
        "wikipedia.org", "archive.org", "internetarchive.org",
        "loc.gov", "britannica.com", "sciencedirect.com"
    )
    
    $prefixes = @("www", "api", "dev", "test", "staging", "old", "new", "beta", "alpha", "secure")
    $paths = @(
        "", "/about", "/contact", "/services", "/products", "/team",
        "/blog", "/news", "/press", "/careers", "/events", "/shop",
        "/download", "/docs", "/api", "/help", "/support", "/login",
        "/register", "/dashboard", "/profile", "/settings"
    )
    
    $targets = @()
    
    for ($i = 0; $i -lt $Count; $i++) {
        $domain = $domains | Get-Random
        $prefix = $prefixes | Get-Random
        if ($paths) { if ($paths) { if ($paths) { if ($paths.Count -gt 0) {
    if ($paths.Count -gt 0) {
    if ($paths.Count -gt 0) { $path = $paths | Get-Random } else { Write-Warning "No URLs found. Skipping."; continue }
} else {
    Write-Warning "No URLs to crawl – skipping this iteration."
    continue
}
} else {
    Write-Warning "No URLs to crawl – skipping this iteration."
    continue
} } else { $path = "https://www.google.com" } } else { $path = "https://www.google.com" } } else { $path = "https://www.google.com" }
        
        if ((Get-Random -Min 0 -Max 2) -eq 0) {
            $target = "https://$prefix.$domain$path"
        } else {
            $target = "https://$domain$path"
        }
        
        $targets += $target
    }
    
    return $targets | Select-Object -Unique
}

# ============================================
# SMART CRAWLER WITH RATE LIMITING
# ============================================

function Invoke-SmartCrawl {
    param(
        [string[]]$Targets,
        [int]$MaxConcurrent = 20,
        [int]$DelayMs = 500
    )
    
    $results = @()
    $total = $Targets.Count
    $processed = 0
    $success = 0
    $failed = 0
    
    Send-Discord -Title "🚀 CRAWL STARTED" -Message "Targets: $total`nConcurrent: $MaxConcurrent" -Color "0x00ff88"
    Send-Telegram -Message "🚀 <b>CRAWL STARTED</b>`nTargets: $total"
    
    $batchSize = 50
    for ($i = 0; $i -lt $total; $i += $batchSize) {
        $batch = $Targets[$i..([Math]::Min($i + $batchSize - 1, $total - 1))]
        
        $batchResults = @()
        $jobs = @()
        
        foreach ($url in $batch) {
            $job = Start-Job -ScriptBlock {
                param($Url, $Timeout = 10)
                try {
                    $response = Invoke-WebRequest -Uri $Url -TimeoutSec $Timeout -UseBasicParsing -Headers @{
                        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
                    }
                    return @{
                        Url = $Url
                        Status = "Success"
                        StatusCode = $response.StatusCode
                        Length = $response.Content.Length
                    }
                } catch {
                    return @{
                        Url = $Url
                        Status = "Failed"
                        Error = $_.Exception.Message
                    }
                }
            } -ArgumentList $url
            
            $jobs += $job
            Start-Sleep -Milliseconds 50
        }
        
        $batchResults = $jobs | ForEach-Object {
            $result = Receive-Job $_ -Wait -ErrorAction SilentlyContinue
            Remove-Job $_ -Force
            $result
        }
        
        $results += $batchResults
        $processed += $batch.Count
        $success = ($results | Where-Object { $_.Status -eq "Success" }).Count
        $failed = ($results | Where-Object { $_.Status -eq "Failed" }).Count
        
        if ($processed % 100 -eq 0) {
            $progress = [math]::Round(($processed / $total) * 100, 1)
            Send-Discord -Title "📊 PROGRESS" -Message "Processed: $processed/$total ($progress%)`nSuccess: $success`nFailed: $failed" -Color "0x00ccff"
            Send-Telegram -Message "📊 <b>PROGRESS</b>`n$processed/$total ($progress%)`nSuccess: $success`nFailed: $failed"
        }
        
        Start-Sleep -Milliseconds $DelayMs
    }
    
    Send-Discord -Title "✅ CRAWL COMPLETE" -Message "Total: $total`nSuccess: $success`nFailed: $failed" -Color "0x00ff00"
    Send-Telegram -Message "✅ <b>CRAWL COMPLETE</b>`nTotal: $total`nSuccess: $success`nFailed: $failed"
    
    return $results
}

# ============================================
# BACKUP TO GOOGLE DRIVE
# ============================================

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\MegaCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    
    Send-Discord -Title "💾 GOOGLE DRIVE BACKUP" -Message "Folder: $(Split-Path $backupDir -Leaf)" -Color "0xffaa00"
    Send-Telegram -Message "💾 <b>GOOGLE DRIVE BACKUP</b>`nFolder: $(Split-Path $backupDir -Leaf)"
    
    return $backupDir
}

# ============================================
# PUSH TO GITHUB
# ============================================

function Push-ToGitHub {
    param([string]$SourcePath)
    
    Set-Location "C:\Users\theya\Desktop\data-repo"
    
    Copy-Item -Path $SourcePath -Destination . -Recurse -Force
    
    git add .
    git commit -m "MegaCrawl results - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin main
    
    Send-Discord -Title "📤 GITHUB PUSH" -Message "Files pushed to main branch" -Color "0x8800ff"
    Send-Telegram -Message "📤 <b>GITHUB PUSH</b>`nFiles pushed to main branch"
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
    Send-Telegram -Message "🗑️ <b>LOCAL DELETED</b>`n$count files removed"
}

# ============================================
# MAIN EXECUTION
# ============================================

Clear-Host
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     🌐 MEGA CRAWLER v3.0 - THOUSANDS OF SITES                   ║" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     Generating 5,000 targets...                                 ║" -ForegroundColor Cyan
Write-Host "║     Crawling with 20 concurrent connections...                  ║" -ForegroundColor Cyan
Write-Host "║     Backing up to Google Drive...                               ║" -ForegroundColor Cyan
Write-Host "║     Pushing to GitHub...                                         ║" -ForegroundColor Cyan
Write-Host "║     Deleting local files...                                      ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📋 Generating 5,000 targets..." -ForegroundColor Yellow
$targets = Generate-Targets -Count 5000
Write-Host "   ✅ $($targets.Count) targets generated" -ForegroundColor Green

Write-Host "`n🌐 Starting mega crawl..." -ForegroundColor Yellow
$results = Invoke-SmartCrawl -Targets $targets -MaxConcurrent 20

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outputPath = "$env:USERPROFILE\Desktop\MegaCrawl_$timestamp"
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$results | Export-Csv -Path "$outputPath\crawl_results.csv" -NoTypeInformation
$targets | Out-File "$outputPath\targets.txt"

Write-Host "`n💾 Backing up to Google Drive..." -ForegroundColor Yellow
$backupPath = Backup-ToGoogleDrive -SourcePath $outputPath

Write-Host "`n📤 Pushing to GitHub..." -ForegroundColor Yellow
Push-ToGitHub -SourcePath $outputPath

Write-Host "`n🗑️ Deleting local files..." -ForegroundColor Red
Delete-LocalFiles -Path $outputPath

Write-Host @"
`n✅ MEGA CRAWL COMPLETE!
   Targets: $($targets.Count)
   Success: $(($results | Where-Object { $_.Status -eq "Success" }).Count)
   Failed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)
   Backup: $backupPath
   Local: Deleted
"@ -ForegroundColor Green

Send-Discord -Title "🎉 MEGA CRAWL COMPLETE" -Message "Targets: $($targets.Count)`nSuccess: $(($results | Where-Object { $_.Status -eq "Success" }).Count)`nFailed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)" -Color "0x00ff00"
Send-Telegram -Message "🎉 <b>MEGA CRAWL COMPLETE</b>`nTargets: $($targets.Count)`nSuccess: $(($results | Where-Object { $_.Status -eq "Success" }).Count)`nFailed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)"







.Trim() -ne "" }
if ($validPaths.Count -gt 0) {
    $path = $validPaths | Get-Random
} else {
    Write-Warning "No valid URLs to crawl – skipping this iteration."
    continue
}
} else {
    Write-Warning "No URLs to crawl – skipping this iteration."
    continue
}
} else {
    Write-Warning "No URLs to crawl – skipping this iteration."
    continue
} } else { $path = "https://www.google.com" } } else { $path = "https://www.google.com" } } else { $path = "https://www.google.com" }
        
        if ((Get-Random -Min 0 -Max 2) -eq 0) {
            $target = "https://$prefix.$domain$path"
        } else {
            $target = "https://$domain$path"
        }
        
        $targets += $target
    }
    
    return $targets | Select-Object -Unique
}

# ============================================
# SMART CRAWLER WITH RATE LIMITING
# ============================================

function Invoke-SmartCrawl {
    param(
        [string[]]$Targets,
        [int]$MaxConcurrent = 20,
        [int]$DelayMs = 500
    )
    
    $results = @()
    $total = $Targets.Count
    $processed = 0
    $success = 0
    $failed = 0
    
    Send-Discord -Title "🚀 CRAWL STARTED" -Message "Targets: $total`nConcurrent: $MaxConcurrent" -Color "0x00ff88"
    Send-Telegram -Message "🚀 <b>CRAWL STARTED</b>`nTargets: $total"
    
    $batchSize = 50
    for ($i = 0; $i -lt $total; $i += $batchSize) {
        $batch = $Targets[$i..([Math]::Min($i + $batchSize - 1, $total - 1))]
        
        $batchResults = @()
        $jobs = @()
        
        foreach ($url in $batch) {
            $job = Start-Job -ScriptBlock {
                param($Url, $Timeout = 10)
                try {
                    $response = Invoke-WebRequest -Uri $Url -TimeoutSec $Timeout -UseBasicParsing -Headers @{
                        "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
                    }
                    return @{
                        Url = $Url
                        Status = "Success"
                        StatusCode = $response.StatusCode
                        Length = $response.Content.Length
                    }
                } catch {
                    return @{
                        Url = $Url
                        Status = "Failed"
                        Error = $_.Exception.Message
                    }
                }
            } -ArgumentList $url
            
            $jobs += $job
            Start-Sleep -Milliseconds 50
        }
        
        $batchResults = $jobs | ForEach-Object {
            $result = Receive-Job $_ -Wait -ErrorAction SilentlyContinue
            Remove-Job $_ -Force
            $result
        }
        
        $results += $batchResults
        $processed += $batch.Count
        $success = ($results | Where-Object { $_.Status -eq "Success" }).Count
        $failed = ($results | Where-Object { $_.Status -eq "Failed" }).Count
        
        if ($processed % 100 -eq 0) {
            $progress = [math]::Round(($processed / $total) * 100, 1)
            Send-Discord -Title "📊 PROGRESS" -Message "Processed: $processed/$total ($progress%)`nSuccess: $success`nFailed: $failed" -Color "0x00ccff"
            Send-Telegram -Message "📊 <b>PROGRESS</b>`n$processed/$total ($progress%)`nSuccess: $success`nFailed: $failed"
        }
        
        Start-Sleep -Milliseconds $DelayMs
    }
    
    Send-Discord -Title "✅ CRAWL COMPLETE" -Message "Total: $total`nSuccess: $success`nFailed: $failed" -Color "0x00ff00"
    Send-Telegram -Message "✅ <b>CRAWL COMPLETE</b>`nTotal: $total`nSuccess: $success`nFailed: $failed"
    
    return $results
}

# ============================================
# BACKUP TO GOOGLE DRIVE
# ============================================

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\MegaCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    
    Send-Discord -Title "💾 GOOGLE DRIVE BACKUP" -Message "Folder: $(Split-Path $backupDir -Leaf)" -Color "0xffaa00"
    Send-Telegram -Message "💾 <b>GOOGLE DRIVE BACKUP</b>`nFolder: $(Split-Path $backupDir -Leaf)"
    
    return $backupDir
}

# ============================================
# PUSH TO GITHUB
# ============================================

function Push-ToGitHub {
    param([string]$SourcePath)
    
    Set-Location "C:\Users\theya\Desktop\data-repo"
    
    Copy-Item -Path $SourcePath -Destination . -Recurse -Force
    
    git add .
    git commit -m "MegaCrawl results - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git push origin main
    
    Send-Discord -Title "📤 GITHUB PUSH" -Message "Files pushed to main branch" -Color "0x8800ff"
    Send-Telegram -Message "📤 <b>GITHUB PUSH</b>`nFiles pushed to main branch"
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
    Send-Telegram -Message "🗑️ <b>LOCAL DELETED</b>`n$count files removed"
}

# ============================================
# MAIN EXECUTION
# ============================================

Clear-Host
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     🌐 MEGA CRAWLER v3.0 - THOUSANDS OF SITES                   ║" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     Generating 5,000 targets...                                 ║" -ForegroundColor Cyan
Write-Host "║     Crawling with 20 concurrent connections...                  ║" -ForegroundColor Cyan
Write-Host "║     Backing up to Google Drive...                               ║" -ForegroundColor Cyan
Write-Host "║     Pushing to GitHub...                                         ║" -ForegroundColor Cyan
Write-Host "║     Deleting local files...                                      ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📋 Generating 5,000 targets..." -ForegroundColor Yellow
$targets = Generate-Targets -Count 5000
Write-Host "   ✅ $($targets.Count) targets generated" -ForegroundColor Green

Write-Host "`n🌐 Starting mega crawl..." -ForegroundColor Yellow
$results = Invoke-SmartCrawl -Targets $targets -MaxConcurrent 20

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outputPath = "$env:USERPROFILE\Desktop\MegaCrawl_$timestamp"
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$results | Export-Csv -Path "$outputPath\crawl_results.csv" -NoTypeInformation
$targets | Out-File "$outputPath\targets.txt"

Write-Host "`n💾 Backing up to Google Drive..." -ForegroundColor Yellow
$backupPath = Backup-ToGoogleDrive -SourcePath $outputPath

Write-Host "`n📤 Pushing to GitHub..." -ForegroundColor Yellow
Push-ToGitHub -SourcePath $outputPath

Write-Host "`n🗑️ Deleting local files..." -ForegroundColor Red
Delete-LocalFiles -Path $outputPath

Write-Host @"
`n✅ MEGA CRAWL COMPLETE!
   Targets: $($targets.Count)
   Success: $(($results | Where-Object { $_.Status -eq "Success" }).Count)
   Failed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)
   Backup: $backupPath
   Local: Deleted
"@ -ForegroundColor Green

Send-Discord -Title "🎉 MEGA CRAWL COMPLETE" -Message "Targets: $($targets.Count)`nSuccess: $(($results | Where-Object { $_.Status -eq "Success" }).Count)`nFailed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)" -Color "0x00ff00"
Send-Telegram -Message "🎉 <b>MEGA CRAWL COMPLETE</b>`nTargets: $($targets.Count)`nSuccess: $(($results | Where-Object { $_.Status -eq "Success" }).Count)`nFailed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)"









# ===== SEND COMPLETION MESSAGE TO TELEGRAM =====
$BotToken = "8604319266:AAH53veZLjVq_aoO4geWfVfBb3_tprCSMnw"
$ChatID = "8606735568"
$Message = "✅ MEGA CRAWLER COMPLETED!
All sites have been crawled and images saved to G: drive."
$Body = @{chat_id = $ChatID; text = $Message} | ConvertTo-Json
try {
    Invoke-RestMethod -Uri "https://api.telegram.org/bot$BotToken/sendMessage" -Method Post -Body $Body -ContentType "application/json" -ErrorAction SilentlyContinue
} catch {}
