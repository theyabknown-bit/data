# ===== CLEAN BOT – ARRAY ARGUMENTS =====
$BotToken = "8604319266:AAH53veZLjVq_aoO4geWfVfBb3_tprCSMnw"
$BotURL = "https://api.telegram.org/bot$BotToken"
$ChatID = "8606735568"
$LastUpdateID = 0

function Send-Telegram {
    param($Message)
    try {
        $Body = @{chat_id = $ChatID; text = $Message} | ConvertTo-Json
        Invoke-RestMethod -Uri "$BotURL/sendMessage" -Method Post -Body $Body -ContentType "application/json" -ErrorAction SilentlyContinue
    } catch {}
}

function Get-Updates {
    param($Offset)
    try {
        $Response = Invoke-RestMethod -Uri "$BotURL/getUpdates?offset=$Offset&timeout=30" -Method Get -ErrorAction SilentlyContinue
        return $Response
    } catch { return $null }
}

try {
    $Test = Invoke-RestMethod -Uri "$BotURL/getMe" -Method Get -ErrorAction SilentlyContinue
    if ($Test.ok) {
        Write-Host "✅ Bot ONLINE: @$($Test.result.username)" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ Bot failed to start" -ForegroundColor Red
    exit
}

Write-Host "🤖 Bot running! Send /help to @DataHarvester2026Bot" -ForegroundColor Green

while ($true) {
    try {
        $Updates = Get-Updates -Offset ($LastUpdateID + 1)
        if ($Updates -and $Updates.ok -and $Updates.result) {
            foreach ($Update in $Updates.result) {
                $LastUpdateID = $Update.update_id
                if ($Update.message -and $Update.message.text) {
                    $Command = $Update.message.text.Trim()
                    Write-Host "📨 $Command" -ForegroundColor Cyan

                    if ($Command -eq "/help") {
                        Send-Telegram -Message "🤖 @DataHarvester2026Bot

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔄 CRAWLING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/crawl50 - Safe crawl (50 sites)
/crawl500 - Massive crawl (500 sites)
/crawl5000 - MEGA crawl (5000 sites)
/crawl10000 - MEGA crawl (10000 sites)
/megacrawl [count] [depth] - Custom crawl
  Example: /megacrawl 5000 3
/autocrawl - 24/7 auto crawler
/stop - Stop current operation

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 DATA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/extract [type] - Extract email/phone/url/ip
/search [query] - Search data
/status - System status

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️ SYSTEM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/exec [command] - Run PowerShell
  Example: /exec Get-Process
/restart - Restart system
/clean - Clean temp files
/help - This message

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Bot: @DataHarvester2026Bot ✅"
                    }
                    elseif ($Command -eq "/status") {
                        $Drive = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'" -ErrorAction SilentlyContinue
                        $Free = [math]::Round($Drive.FreeSpace / 1GB, 2)
                        $Total = [math]::Round($Drive.Size / 1GB, 2)
                        Send-Telegram -Message "📊 STATUS
Storage: $Free GB / $Total GB
Time: $(Get-Date)"
                    }
                    elseif ($Command -match "/exec (.+)") {
                        $Cmd = $Matches[1]
                        try {
                            $Result = Invoke-Expression $Cmd 2>&1 | Out-String
                            if ($Result.Length -gt 3900) { $Result = $Result.Substring(0, 3900) + "..." }
                            if ($Result) { Send-Telegram -Message "✅ $Result" } else { Send-Telegram -Message "✅ Done" }
                        } catch {
                            Send-Telegram -Message "❌ Error: $_"
                        }
                    }
                    elseif ($Command -eq "/crawl50") {
                        Send-Telegram -Message "🔄 Starting Safe Crawler (50 sites)..."
                        Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile", "-ExecutionPolicy", "Bypass", "-File", ""C:\Users\theya\Desktop\DataHarvester\SafeCrawler.ps1"" -WindowStyle Normal
                        Send-Telegram -Message "✅ Started!"
                    }
                    elseif ($Command -match "/megacrawl\s+(\d+)(?:\s+(\d+))?") {
                        $Count = [int]$Matches[1]
                        $Depth = if ($Matches[2]) { [int]$Matches[2] } else { 3 }
                        Send-Telegram -Message "🔄 Starting MEGA Crawler: $Count sites, depth $Depth..."
                        # Use an ARRAY of arguments – no quoting issues
                        $Args = @("-NoProfile", "-ExecutionPolicy", "Bypass", "-File", "C:\Users\theya\Desktop\DataHarvester\MegaCrawler.ps1", "-TargetCount", $Count, "-MaxDepth", $Depth)
                        Start-Process -FilePath "powershell.exe" -ArgumentList $Args -WindowStyle Normal
                        Send-Telegram -Message "✅ Started!"
                    }
                    elseif ($Command -eq "/stop") {
                        Get-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*Crawler*" } | Stop-Process -Force
                        Send-Telegram -Message "🛑 Stopped all crawlers"
                    }
                    elseif ($Command -eq "/clean") {
                        Get-ChildItem -Path "C:\Users\theya\Desktop\data-repo\*.tmp" -ErrorAction SilentlyContinue | Remove-Item -Force
                        Send-Telegram -Message "🧹 Cleaned temp files"
                    }
                    elseif ($Command -eq "/start") {
                        Send-Telegram -Message "🤖 @DataHarvester2026Bot is alive! Type /help"
                    }
                    else {
                        Send-Telegram -Message "❌ Unknown command. Type /help"
                    }
                }
            }
        }
        Start-Sleep -Milliseconds 500
    }
    catch {
        Start-Sleep -Seconds 1
    }
}
