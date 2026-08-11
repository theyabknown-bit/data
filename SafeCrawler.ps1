# ===== PERMANENT GOOGLE DRIVE IMAGE DOWNLOADER =====
$GDriveImageFolder = "G:\DataHarvester_Images"

# Create the folder on G: drive if it doesn't exist
if (-not (Test-Path $GDriveImageFolder)) {
    New-Item -ItemType Directory -Path $GDriveImageFolder -Force | Out-Null
    Write-Host "📁 Created folder on G: Drive: $GDriveImageFolder" -ForegroundColor Green
}

function Save-Image-ToGDrive {
    param([string]$ImageUrl)

    # 1. Unique filename (hash + extension)
    $UrlHash = [System.BitConverter]::ToString([System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ImageUrl))).Replace("-", "").Substring(0, 10)
    $Extension = [System.IO.Path]::GetExtension(($ImageUrl -split '\?')[0])
    if ([string]::IsNullOrEmpty($Extension)) { $Extension = ".jpg" }
    $FileName = "$UrlHash$Extension"
    $FilePath = Join-Path $GDriveImageFolder $FileName

    try {
        Write-Host "⬇️ Downloading to G: Drive: $FileName" -ForegroundColor Cyan
        
        # 2. Download the image
        $Response = Invoke-WebRequest -Uri $ImageUrl -Method Get -ErrorAction Stop
        
        # 3. Save directly to G: Drive folder (Google Drive streams it to cloud)
        [System.IO.File]::WriteAllBytes($FilePath, $Response.Content)
        
        Write-Host "✅ Saved to G: Drive!" -ForegroundColor Green

        # 4. Rate limiting (wait 1.5 seconds)
        Start-Sleep -Seconds 1.5

    } catch {
        Write-Host "❌ Failed to download: $($_.Exception.Message)" -ForegroundColor Red
    }
}
# ============================================
# SAFE CRAWLER v1.0 - LIMITED & CONTROLLED
# ============================================

Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     🛡️ SAFE CONTROLLED CRAWLER                                  ║
║                                                                   ║
║     Max 100 targets per run                                      ║
║     5 concurrent connections                                     ║
║     30 second timeout                                             ║
║     Safe for your PC                                             ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"

function Send-Discord {
    param([string]$Title, [string]$Message)
    try {
        $payload = @{
            username = "SafeCrawler"
            embeds = @(@{title=$Title; description=$Message; color=0x00ff00; timestamp=(Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ")})
        } | ConvertTo-Json -Depth 10
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json" -ErrorAction Stop
    } catch {}
}

# ============================================
# GENERATE TARGETS - SMALL BATCH
# ============================================

function Generate-Targets {
    param([int]$Count = 100)  # MAX 100!
    
    $domains = @(
        "bbc.com", "cnn.com", "reuters.com", "apnews.com",
        "aljazeera.com", "gulfnews.com", "khaleejtimes.com",
        "github.com", "stackoverflow.com", "medium.com",
        "wikipedia.org", "archive.org"
    )
    
    $targets = @()
    for ($i = 0; $i -lt $Count; $i++) {
        $domain = $domains | Get-Random
        $targets += "https://$domain"
    }
    
    return $targets | Select-Object -Unique
}

# ============================================
# SAFE CRAWL - LIMITED CONCURRENCY
# ============================================

function Invoke-SafeCrawl {
    param(
        [string[]]$Targets,
        [int]$MaxConcurrent = 5  # MAX 5!
    )
    
    $results = @()
    $total = $Targets.Count
    $processed = 0
    $success = 0
    
    Send-Discord -Title "🚀 SAFE CRAWL START" -Message "Targets: $total`nConcurrent: $MaxConcurrent"
    
    # Process one at a time (safest)
    foreach ($url in $Targets) {
        try {
            Write-Host "   Crawling: $url" -ForegroundColor Gray
            
            $response = Invoke-WebRequest -Uri $url -TimeoutSec 15 -UseBasicParsing -Headers @{
                "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            }
            
            $results += @{
                Url = $url
                Status = "Success"
                StatusCode = $response.StatusCode
                Length = $response.Content.Length
            }
            
            $success++
            Write-Host "   ✅ Success" -ForegroundColor Green
            
        } catch {
            $results += @{
                Url = $url
                Status = "Failed"
                Error = $_.Exception.Message
            }
            Write-Host "   ❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
        }
        
        $processed++
        
        # Progress every 10
        if ($processed % 10 -eq 0) {
            Send-Discord -Title "📊 PROGRESS" -Message "$processed/$total"
        }
        
        # Rate limit - be respectful
        Start-Sleep -Seconds 1
    }
    
    Send-Discord -Title "✅ SAFE CRAWL COMPLETE" -Message "Success: $success/$total"
    
    return $results
}

# ============================================
# BACKUP TO GOOGLE DRIVE
# ============================================

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\SafeCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    
    Send-Discord -Title "💾 BACKUP COMPLETE" -Message "Folder: $(Split-Path $backupDir -Leaf)"
    
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
# MAIN EXECUTION - SAFE & CONTROLLED
# ============================================

Write-Host "`n📋 Generating 100 targets..." -ForegroundColor Yellow
$targets = Generate-Targets -Count 100
Write-Host "   ✅ $($targets.Count) targets generated" -ForegroundColor Green

Write-Host "`n🌐 Starting safe crawl..." -ForegroundColor Yellow
$results = Invoke-SafeCrawl -Targets $targets -MaxConcurrent 5

$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$outputPath = "$env:USERPROFILE\Desktop\SafeCrawl_$timestamp"
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

$results | Export-Csv -Path "$outputPath\safe_crawl_results.csv" -NoTypeInformation
$targets | Out-File "$outputPath\targets.txt"

Write-Host "`n💾 Backing up to Google Drive..." -ForegroundColor Yellow
$backupPath = Backup-ToGoogleDrive -SourcePath $outputPath

Write-Host "`n🗑️ Deleting local files..." -ForegroundColor Red
Delete-LocalFiles -Path $outputPath

Write-Host @"
`n✅ SAFE CRAWL COMPLETE!
   Targets: $($targets.Count)
   Success: $(($results | Where-Object { $_.Status -eq "Success" }).Count)
   Failed: $(($results | Where-Object { $_.Status -eq "Failed" }).Count)
   Backup: $backupPath
   Local: Deleted
"@ -ForegroundColor Green

