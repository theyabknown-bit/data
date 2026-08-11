# ============================================
# ENHANCED DISCORD LOGGER - FINAL WORKING
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"
$userName = "DataHarvester-Logger"

# ============================================
# FUNCTION: SEND TO DISCORD
# ============================================

function Send-DiscordLog {
    param(
        [string]$Title,
        [string]$Message,
        [string]$Color = "0x00ff00",
        [string]$Footer = "DataHarvester"
    )
    
    try {
        $payload = @{
            username = $userName
            embeds = @(
                @{
                    title = $Title
                    description = $Message
                    color = [int]$Color
                    timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ")
                    footer = @{ text = $Footer }
                }
            )
        } | ConvertTo-Json -Depth 10
        
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json" -ErrorAction Stop
        Write-Host "✅ Discord log sent: $Title" -ForegroundColor Green
    } catch {
        Write-Host "❌ Discord log failed: $_" -ForegroundColor Red
    }
}

# ============================================
# FUNCTION: SEND HARVEST RESULTS
# ============================================

function Send-HarvestResults {
    param(
        [string]$Source,
        [int]$Records,
        [string]$Type,
        [string]$Details
    )
    
    $msg = "**Source:** $Source`n**Records:** $Records`n**Type:** $Type`n**Details:** $Details`n**Time:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Send-DiscordLog -Title "📊 HARVEST RESULTS" -Message $msg -Color "0x00ff88"
}

# ============================================
# FUNCTION: SEND MEDICAL DATA
# ============================================

function Send-MedicalData {
    param(
        [string]$Code,
        [string]$Description,
        [string]$Source,
        [int]$Count
    )
    
    $msg = "**Code:** $Code`n**Description:** $Description`n**Source:** $Source`n**Count:** $Count`n**Time:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Send-DiscordLog -Title "🏥 MEDICAL DATA" -Message $msg -Color "0xff6600"
}

# ============================================
# FUNCTION: SEND DASHBOARD STATS
# ============================================

function Send-DashboardStats {
    param(
        [int]$Total,
        [int]$Phones,
        [int]$URLs,
        [int]$Social,
        [int]$Emails
    )
    
    $msg = "**Total Matches:** $Total`n**Phones:** $Phones`n**URLs:** $URLs`n**Social:** $Social`n**Emails:** $Emails`n**Updated:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Send-DiscordLog -Title "📈 DASHBOARD STATS" -Message $msg -Color "0x00ccff"
}

# ============================================
# FUNCTION: SEND FILE SUMMARY
# ============================================

function Send-FileSummary {
    param([string]$Path)
    
    $files = Get-ChildItem -Path $Path -File -ErrorAction SilentlyContinue
    $totalSize = [math]::Round(($files | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
    $fileTypes = $files | Group-Object Extension | Select-Object Name, Count | Sort-Object Count -Descending
    
    $summary = "**Location:** $Path`n**Total Files:** $($files.Count)`n**Total Size:** $totalSize MB`n`n**File Types:**`n"
    foreach ($type in $fileTypes) {
        $summary += "   $($type.Name): $($type.Count)`n"
    }
    
    Send-DiscordLog -Title "📁 FILE SUMMARY" -Message $summary -Color "0x00aa88"
}

# ============================================
# FUNCTION: SEND SYSTEM STATUS
# ============================================

function Send-SystemStatus {
    param([string]$Status)
    
    try {
        $cpu = Get-Counter "\Processor(_Total)\% Processor Time" -ErrorAction SilentlyContinue
        $cpuValue = if ($cpu) { [math]::Round($cpu.CounterSamples.CookedValue, 1) } else { "N/A" }
        
        $memory = Get-Counter "\Memory\Available MBytes" -ErrorAction SilentlyContinue
        $memValue = if ($memory) { [math]::Round($memory.CounterSamples.CookedValue, 0) } else { "N/A" }
    } catch {
        $cpuValue = "N/A"
        $memValue = "N/A"
    }
    
    $msg = "**Status:** $Status`n**CPU Usage:** $cpuValue%`n**Available Memory:** $memValue MB`n**User:** $env:USERNAME`n**Computer:** $env:COMPUTERNAME`n**Time:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Send-DiscordLog -Title "🖥️ SYSTEM STATUS" -Message $msg -Color "0x4488ff"
}

# ============================================
# FUNCTION: SEND LOG FILE CONTENT
# ============================================

function Send-LogContent {
    param(
        [string]$FilePath,
        [int]$Lines = 50,
        [string]$Title = "📄 LOG CONTENT"
    )
    
    if (Test-Path $FilePath) {
        $content = Get-Content $FilePath -Tail $Lines -ErrorAction SilentlyContinue
        if ($content) {
            $truncated = $content -join "`n"
            if ($truncated.Length -gt 1900) {
                $truncated = $truncated.Substring(0, 1900) + "`n... (truncated)"
            }
            Send-DiscordLog -Title $Title -Message "```$truncated```" -Color "0x00ccff"
        }
    } else {
        Send-DiscordLog -Title "⚠️ FILE NOT FOUND" -Message "Path: $FilePath" -Color "0xffff00"
    }
}

# ============================================
# FUNCTION: SEND ALL LOGS SUMMARY
# ============================================

function Send-AllLogsSummary {
    $logPaths = @(
        "C:\Users\theya\Desktop\data-repo",
        "C:\Users\theya\Desktop\DataHarvester"
    )
    
    $totalLogs = 0
    $totalSize = 0
    
    foreach ($path in $logPaths) {
        $logs = Get-ChildItem -Path $path -Filter "*.log" -Recurse -ErrorAction SilentlyContinue
        $totalLogs += $logs.Count
        $totalSize += ($logs | Measure-Object -Property Length -Sum).Sum
    }
    
    $totalSizeMB = [math]::Round($totalSize / 1MB, 2)
    
    $msg = "**Total Log Files:** $totalLogs`n**Total Size:** $totalSizeMB MB`n**Last Scan:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Send-DiscordLog -Title "📊 ALL LOGS SUMMARY" -Message $msg -Color "0x00aa88"
}

# ============================================
# FUNCTION: SEND REAL DATA FOUND
# ============================================

function Send-RealDataFound {
    param(
        [string]$Type,
        [string]$Value,
        [string]$Source,
        [string]$Category = "Contact"
    )
    
    $msg = "**Type:** $Type`n**Value:** $Value`n**Source:** $Source`n**Category:** $Category`n**Found:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Send-DiscordLog -Title "🔍 REAL DATA FOUND" -Message $msg -Color "0x00ff88"
}

# ============================================
# FUNCTION: SEND ERROR WITH DETAILS
# ============================================

function Send-ErrorLog {
    param(
        [string]$Error,
        [string]$Source,
        [string]$Action
    )
    
    $msg = "**Action:** $Action`n**Error:** $Error`n**Source:** $Source`n**Time:** $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Send-DiscordLog -Title "❌ ERROR" -Message $msg -Color "0xff0000"
}

# ============================================
# RUN ALL REPORTS
# ============================================

Clear-Host
Write-Host "╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     📡 ENHANCED DISCORD LOGGER                                   ║" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "║     Sending real data to Discord                                ║" -ForegroundColor Cyan
Write-Host "║                                                                   ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan

Write-Host "`n📡 Sending logs to Discord..." -ForegroundColor Yellow

# 1. System Status
Send-SystemStatus -Status "🟢 Online"

# 2. Dashboard Stats
Send-DashboardStats -Total 2577 -Phones 126 -URLs 126 -Social 126 -Emails 12

# 3. File Summary
Send-FileSummary -Path "C:\Users\theya\Desktop\data-repo"

# 4. All Logs Summary
Send-AllLogsSummary

# 5. Send latest harvest results (if any)
$latestLog = Get-ChildItem -Path "C:\Users\theya\Desktop\data-repo" -Filter "*.log" -Recurse | Sort-Object LastWriteTime -Descending | Select-Object -First 1
if ($latestLog) {
    Send-LogContent -FilePath $latestLog.FullName -Lines 30 -Title "📄 LATEST LOG: $($latestLog.Name)"
}

# 6. Send medical data summary if exists
$medicalFile = "C:\Users\theya\Desktop\data-repo\medical_data_harvest.csv"
if (Test-Path $medicalFile) {
    $medicalCount = (Import-Csv $medicalFile -ErrorAction SilentlyContinue).Count
    if ($medicalCount -gt 0) {
        Send-MedicalData -Code "Multiple" -Description "Medical Records" -Source "SEHA, ICMR, MOHFW" -Count $medicalCount
    }
}

# 7. Send real data summary
$realFile = Get-ChildItem -Path "C:\Users\theya\Desktop\data-repo" -Filter "real_data_harvest_*.csv" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($realFile) {
    $realCount = (Import-Csv $realFile.FullName -ErrorAction SilentlyContinue).Count
    if ($realCount -gt 0) {
        Send-HarvestResults -Source "Real Data Harvest" -Records $realCount -Type "Contacts" -Details "$realCount entries found"
    }
}

Write-Host "`n✅ All logs sent to Discord!" -ForegroundColor Green
Write-Host "📊 Check your Discord channel to see the data." -ForegroundColor Gray

# ============================================
# CONTINUOUS MONITORING (Final Fixed)
# ============================================

Write-Host "`n🔄 Starting continuous monitoring..." -ForegroundColor Yellow
Write-Host "   Press Ctrl+C to stop" -ForegroundColor Gray

# Watch for new files and send to Discord
try {
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "C:\Users\theya\Desktop\data-repo"
    $watcher.Filter = "*.*"
    $watcher.EnableRaisingEvents = $true
    $watcher.IncludeSubdirectories = $true
    
    # Define the action
    $action = {
        $file = $Event.SourceEventArgs.FullPath
        $name = $Event.SourceEventArgs.Name
        $changeType = $Event.SourceEventArgs.ChangeType
        
        Send-DiscordLog -Title "📄 FILE $changeType" -Message "**File:** $name`n**Path:** $file" -Color "0x00ccff"
        
        if ($name -match "\.(csv|json|log)$") {
            Start-Sleep -Seconds 1
            if (Test-Path $file) {
                $content = Get-Content $file -Head 5 -ErrorAction SilentlyContinue
                if ($content) {
                    Send-DiscordLog -Title "📊 NEW DATA" -Message "```$($content -join "`n")```" -Color "0x00ff88"
                }
            }
        }
    }
    
    # Register the event
    $eventJob = Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action $action
    $eventJob = Register-ObjectEvent -InputObject $watcher -EventName "Changed" -Action $action
    
    Write-Host "✅ Watcher started. New files will be sent to Discord." -ForegroundColor Green
    
    # Keep running with heartbeat
    while ($true) {
        Start-Sleep -Seconds 60
        $files = Get-ChildItem -Path "C:\Users\theya\Desktop\data-repo" -Filter "*.csv" -ErrorAction SilentlyContinue
        if ($files.Count -gt 0) {
            Send-DiscordLog -Title "💓 HEARTBEAT" -Message "**CSV Files:** $($files.Count)`n**Latest:** $($files[-1].Name)" -Color "0x00ccff"
        }
    }
} catch {
    Write-Host "⚠️ Watcher error: $_" -ForegroundColor Red
    Write-Host "Continuing without file monitoring..." -ForegroundColor Yellow
    
    # Just send heartbeat
    while ($true) {
        Start-Sleep -Seconds 60
        $files = Get-ChildItem -Path "C:\Users\theya\Desktop\data-repo" -Filter "*.csv" -ErrorAction SilentlyContinue
        if ($files.Count -gt 0) {
            Send-DiscordLog -Title "💓 HEARTBEAT" -Message "**CSV Files:** $($files.Count)`n**Latest:** $($files[-1].Name)" -Color "0x00ccff"
        }
    }
}
