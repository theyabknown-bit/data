# ===== DIRECT IMAGE DOWNLOADER (LOCAL FOLDER) =====

# Use local folder instead of G: drive
$ImageFolder = "C:\Users\theya\Desktop\DataHarvester_Images"

# Create folder if missing
if (-not (Test-Path $ImageFolder)) {
    New-Item -ItemType Directory -Path $ImageFolder -Force | Out-Null
    Write-Host "📁 Created: $ImageFolder" -ForegroundColor Green
}

# Load URLs
$ImageList = "C:\Users\theya\Desktop\DataHarvester\direct_images.txt"
if (-not (Test-Path $ImageList)) {
    Write-Host "❌ No image list found. Creating default..." -ForegroundColor Yellow
    @"
https://picsum.photos/200/300
https://picsum.photos/300/400
https://picsum.photos/400/300
"@ | Out-File -FilePath $ImageList -Encoding UTF8
}

$Urls = Get-Content $ImageList | Where-Object { $_ -and $_.Trim() -ne "" }

Write-Host "`n═══════════════════════════════════════"
Write-Host "📥 DIRECT IMAGE DOWNLOADER"
Write-Host "═══════════════════════════════════════"
Write-Host "📋 Downloading $($Urls.Count) images..."
Write-Host "📁 Saving to: $ImageFolder"
Write-Host "═══════════════════════════════════════`n"

$Count = 0
$Total = $Urls.Count

foreach ($Url in $Urls) {
    $Count++
    $Percent = [math]::Round(($Count / $Total) * 100)
    
    try {
        # Generate filename
        $FileName = [System.IO.Path]::GetFileName(($Url -split '\?')[0])
        if ([string]::IsNullOrEmpty($FileName) -or $FileName -match '^[0-9]+$') {
            $Hash = [System.BitConverter]::ToString(
                [System.Security.Cryptography.MD5]::Create().ComputeHash(
                    [System.Text.Encoding]::UTF8.GetBytes($Url)
                )
            ).Replace("-", "").Substring(0, 10)
            $FileName = "$Hash.jpg"
        }
        $FilePath = Join-Path $ImageFolder $FileName
        
        Write-Host "[$Percent%] ⬇️ Downloading: $FileName"
        $Response = Invoke-WebRequest -Uri $Url -UseBasicParsing -Method Get -ErrorAction Stop
        [System.IO.File]::WriteAllBytes($FilePath, $Response.Content)
        Write-Host "✅ Saved: $FileName" -ForegroundColor Green
        
    } catch {
        Write-Host "❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n═══════════════════════════════════════"
Write-Host "✅ COMPLETED! Downloaded $Count images"
Write-Host "📁 Location: $ImageFolder"
Write-Host "═══════════════════════════════════════`n"

# Telegram notification
$BotToken = "8604319266:AAH53veZLjVq_aoO4geWfVfBb3_tprCSMnw"
$ChatID = "8606735568"
$Message = "✅ IMAGE DOWNLOAD COMPLETED!`n📸 $Count images downloaded`n📁 $ImageFolder"
try {
    $Body = @{chat_id = $ChatID; text = $Message} | ConvertTo-Json
    Invoke-RestMethod -Uri "https://api.telegram.org/bot$BotToken/sendMessage" -Method Post -Body $Body -ContentType "application/json" -ErrorAction SilentlyContinue
} catch {}

Start-Sleep -Seconds 3
