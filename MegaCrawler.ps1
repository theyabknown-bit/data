# ===== MEGA CRAWLER (WITH DISCORD + PROGRESS) =====

# 1. Configuration
$TargetCount = 5
$MaxDepth = 1
$ImageFolder = "G:\DataHarvester_Images"
$DiscordWebhook = "https://discord.com/api/webhooks/1537176745776652458/SlYqM8fLJQcEPz5E9v6B66XRRLYd_tRIfnjmgw-Jn3OSf0K2SVwDooBI1SxlwFbSh5Y8"

# Create folder if missing
if (-not (Test-Path $ImageFolder)) {
    New-Item -ItemType Directory -Path $ImageFolder -Force | Out-Null
    Write-Host "📁 Created: $ImageFolder" -ForegroundColor Green
}

# 2. Load URLs
$UrlFile = "C:\Users\theya\Desktop\DataHarvester\urls.txt"
if (Test-Path $UrlFile) {
    $Urls = Get-Content -Path $UrlFile | Where-Object { $_ -and $_.Trim() -ne "" }
} else {
    $Urls = @(
        "https://www.google.com",
        "https://www.wikipedia.org",
        "https://www.github.com",
        "https://www.example.com"
    )
}

# Limit to target count
$Urls = $Urls | Select-Object -First $TargetCount
$TotalSites = $Urls.Count
$CurrentSite = 0

Write-Host "`n═══════════════════════════════════════"
Write-Host "🌐 MEGA CRAWLER STARTED"
Write-Host "═══════════════════════════════════════"
Write-Host "📋 Crawling $TotalSites sites..."
Write-Host "📁 Saving images to: $ImageFolder"
Write-Host "═══════════════════════════════════════`n"

# ===== DISCORD FUNCTION =====
function Send-DiscordMessage {
    param([string]$Message)
    try {
        $Body = @{ content = $Message } | ConvertTo-Json
        Invoke-RestMethod -Uri $DiscordWebhook -Method Post -Body $Body -ContentType "application/json" -ErrorAction SilentlyContinue
    } catch {
        Write-Host "⚠️ Discord send failed" -ForegroundColor Yellow
    }
}

# ===== TELEGRAM FUNCTION =====
function Send-TelegramMessage {
    param([string]$Message)
    $BotToken = "8604319266:AAH53veZLjVq_aoO4geWfVfBb3_tprCSMnw"
    $ChatID = "8606735568"
    try {
        $Body = @{chat_id = $ChatID; text = $Message} | ConvertTo-Json
        Invoke-RestMethod -Uri "https://api.telegram.org/bot$BotToken/sendMessage" -Method Post -Body $Body -ContentType "application/json" -ErrorAction SilentlyContinue
    } catch {}
}

# ===== SEND START NOTIFICATIONS =====
Send-DiscordMessage "🚀 **CRAWL STARTED!**`n📋 $TotalSites sites`n📁 $ImageFolder"
Send-TelegramMessage "🚀 MEGA CRAWLER STARTED!`n📋 $TotalSites sites`n📁 $ImageFolder"

# ===== IMAGE DOWNLOADER =====
function Save-Image {
    param([string]$ImageUrl)

    $UrlHash = [System.BitConverter]::ToString(
        [System.Security.Cryptography.MD5]::Create().ComputeHash(
            [System.Text.Encoding]::UTF8.GetBytes($ImageUrl)
        )
    ).Replace("-", "").Substring(0, 10)
    
    $Extension = [System.IO.Path]::GetExtension(($ImageUrl -split '\?')[0])
    if ([string]::IsNullOrEmpty($Extension)) { $Extension = ".jpg" }
    $FileName = "$UrlHash$Extension"
    $FilePath = Join-Path $ImageFolder $FileName

    try {
        Write-Host "⬇️ Downloading: $FileName"
        $Response = Invoke-WebRequest -Uri $ImageUrl -UseBasicParsing -Method Get -ErrorAction Stop
        [System.IO.File]::WriteAllBytes($FilePath, $Response.Content)
        Start-Sleep -Seconds 0.5
        return $true
    } catch {
        Write-Host "❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# ===== CRAWL LOOP WITH PROGRESS =====
$TotalImages = 0
$ProgressStep = [math]::Max(1, [math]::Floor($TotalSites / 10))  # Update every 10%

foreach ($Url in $Urls) {
    $CurrentSite++
    $Percent = [math]::Round(($CurrentSite / $TotalSites) * 100)
    
    Write-Host "`n🕸️ [$Percent%] Crawling: $Url" -ForegroundColor Cyan

    try {
        $Html = Invoke-WebRequest -Uri $Url -UseBasicParsing -Method Get -ErrorAction Stop

        # Find images
        $Html.Images | ForEach-Object {
            $ImgUrl = $_.src
            if ($ImgUrl) {
                if ($ImgUrl -match "^/") {
                    $BaseUri = [System.Uri]::new($Url)
                    $ImgUrl = $BaseUri.Scheme + "://" + $BaseUri.Host + $ImgUrl
                }
                if ($ImgUrl -match "\.(png|jpg|jpeg|webp|gif)$") {
                    if (Save-Image -ImageUrl $ImgUrl) {
                        $TotalImages++
                    }
                }
            }
        }

        # Send progress updates every 10%
        if ($CurrentSite % $ProgressStep -eq 0 -or $CurrentSite -eq $TotalSites) {
            $ProgressMsg = "📊 Progress: $Percent% ($CurrentSite/$TotalSites sites)`n📸 Images: $TotalImages"
            Send-DiscordMessage "📊 **PROGRESS UPDATE**`n$ProgressMsg"
            Send-TelegramMessage "📊 $Percent% complete - $TotalImages images downloaded"
        }

    } catch {
        Write-Host "⚠️ Error: $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host "`n═══════════════════════════════════════"
Write-Host "✅ CRAWL COMPLETED!"
Write-Host "═══════════════════════════════════════"
Write-Host "📸 Total Images: $TotalImages"
Write-Host "═══════════════════════════════════════`n"

# ===== SEND COMPLETION NOTIFICATIONS =====
$CompletionMsg = "✅ **CRAWL COMPLETED!**`n📸 $TotalImages images downloaded`n📁 $ImageFolder"
Send-DiscordMessage $CompletionMsg
Send-TelegramMessage "✅ MEGA CRAWLER COMPLETED!`n📸 $TotalImages images saved to G: drive."

# ===== RUN GITHUB UPLOADER =====
try {
    & "C:\Users\theya\Desktop\DataHarvester\GitHubUploader.ps1"
} catch {
    Write-Host "⚠️ GitHub upload skipped"
}

Write-Host "`n🧹 All done. Closing window in 3 seconds..."
Start-Sleep -Seconds 3
