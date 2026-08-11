# ============================================
# SAFE CRAWLER - 200 TARGETS
# ============================================

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

function Generate-Targets {
    param([int]$Count = 200)
    
    $domains = @(
        "bbc.com", "cnn.com", "reuters.com", "apnews.com",
        "aljazeera.com", "gulfnews.com", "khaleejtimes.com",
        "github.com", "stackoverflow.com", "medium.com",
        "wikipedia.org", "archive.org", "theguardian.com",
        "nytimes.com", "washingtonpost.com", "wsj.com",
        "techcrunch.com", "wired.com", "arstechnica.com",
        "bloomberg.com", "forbes.com", "businessinsider.com",
        "ft.com", "economist.com", "cnbc.com", "marketwatch.com",
        "who.int", "cdc.gov", "nih.gov", "mayoclinic.org",
        "webmd.com", "healthline.com", "medicalnewstoday.com"
    )
    
    $targets = @()
    for ($i = 0; $i -lt $Count; $i++) {
        $domain = $domains | Get-Random
        $targets += "https://$domain"
    }
    
    return $targets | Select-Object -Unique
}

function Invoke-SafeCrawl {
    param([string[]]$Targets, [int]$MaxConcurrent = 10)
    
    $results = @()
    $total = $Targets.Count
    $success = 0
    
    Send-Discord -Title "🚀 SAFE CRAWL START" -Message "Targets: $total`nConcurrent: $MaxConcurrent"
    
    foreach ($url in $Targets) {
        try {
            Write-Host "   Crawling: $url" -ForegroundColor Gray
            $response = Invoke-WebRequest -Uri $url -TimeoutSec 15 -UseBasicParsing -Headers @{
                "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
            }
            $results += @{Url=$url; Status="Success"; StatusCode=$response.StatusCode; Length=$response.Content.Length}
            $success++
            Write-Host "   ✅ Success" -ForegroundColor Green
        } catch {
            $results += @{Url=$url; Status="Failed"; Error=$_.Exception.Message}
            Write-Host "   ❌ Failed" -ForegroundColor Red
        }
        Start-Sleep -Milliseconds 500
    }
    
    Send-Discord -Title "✅ SAFE CRAWL COMPLETE" -Message "Success: $success/$total"
    return $results
}

function Backup-ToGoogleDrive {
    param([string]$SourcePath)
    $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\SafeCrawl_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    Copy-Item -Path $SourcePath -Destination $backupDir -Recurse -Force
    Send-Discord -Title "💾 BACKUP COMPLETE" -Message "Folder: $(Split-Path $backupDir -Leaf)"
    return $backupDir
}

function Delete-LocalFiles {
    param([string]$Path)
    Remove-Item -Path "$Path\*" -Recurse -Force -ErrorAction SilentlyContinue
}

Clear-Host
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     🛡️ SAFE CRAWLER - 200 TARGETS                              ║" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📋 Generating 200 targets..." -ForegroundColor Yellow
$targets = Generate-Targets -Count 200
Write-Host "   ✅ $($targets.Count) targets generated" -ForegroundColor Green

Write-Host "`n🌐 Starting safe crawl..." -ForegroundColor Yellow
$results = Invoke-SafeCrawl -Targets $targets -MaxConcurrent 10

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
