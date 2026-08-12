# ===== TELEGRAM CONTROLLER (WORKING AUTOCRAWL) =====
$BotToken = "8604319266:AAH53veZLjVq_aoO4geWfVfBb3_tprCSMnw"
$ChatID = "8606735568"

Write-Host "🤖 Telegram Bot Controller started!" -ForegroundColor Cyan
Write-Host "📱 Listening for commands..." -ForegroundColor Cyan

while ($true) {
    try {
        $Updates = Invoke-RestMethod -Uri "https://api.telegram.org/bot$BotToken/getUpdates?offset=-1" -Method Get -ErrorAction SilentlyContinue
        if ($Updates.ok -and $Updates.result.Count -gt 0) {
            $Latest = $Updates.result[-1]
            $Message = $Latest.message.text
            $ChatID = $Latest.message.chat.id
            $User = $Latest.message.from.username

            if ($Message -and $Message -ne "") {
                Write-Host "📩 Received: $Message from @$User" -ForegroundColor Yellow
                
                $Command = $Message.Split(" ")[0]
                $Arg = $Message.Substring($Command.Length).Trim()
                $Response = ""

                if ($Command -eq "/start") {
                    $Response = "🤖 Bot is alive! Type /help"
                }
                elseif ($Command -eq "/help") {
                    $Response = @"
🤖 @DataHarvester2026Bot

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🕷️ CRAWLING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/crawl50 - Safe crawl (50 sites)
/crawl500 - Massive crawl (500 sites)
/crawl5000 - MEGA crawl (5000 sites)
/crawl10000 - MEGA crawl (10000 sites)
/megacrawl [count] [depth] - Custom crawl
  Example: /megacrawl 5000 3
/autocrawl - 24/7 auto crawler
/stopcrawl - Stop auto crawler

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 DATA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/status - System status
/downloadimages - Download direct image URLs

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚙️ SYSTEM
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/exec [command] - Run PowerShell
/clean - Clean temp files
/help - This message

Bot: @DataHarvester2026Bot 🤖
"@
                }
                elseif ($Command -eq "/status") {
                    try {
                        $Drive = Get-PSDrive C
                        $Used = [math]::Round($Drive.Used / 1GB, 2)
                        $Total = [math]::Round(($Drive.Free + $Drive.Used) / 1GB, 2)
                        $Time = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
                        $Response = "📊 STATUS`nStorage: $Used GB / $Total GB`nTime: $Time"
                    } catch {
                        $Response = "⚠️ Could not get status"
                    }
                }
                elseif ($Command -eq "/autocrawl") {
                    $Existing = Get-Job -Name "AutoCrawl" -ErrorAction SilentlyContinue
                    if ($Existing) {
                        $Response = "🔄 Auto-crawl is already running!`nTo stop: /stopcrawl"
                    } else {
                        Start-Job -Name "AutoCrawl" -ScriptBlock {
                            while ($true) {
                                & "C:\Users\theya\Desktop\DataHarvester\MegaCrawler.ps1" -TargetCount 100 -MaxDepth 2
                                Start-Sleep -Seconds 3600
                            }
                        }
                        $Response = "🔄 Auto-crawl started!`n📋 Crawling 100 sites every hour.`nTo stop: /stopcrawl"
                    }
                }
                elseif ($Command -eq "/stopcrawl") {
                    $Job = Get-Job -Name "AutoCrawl" -ErrorAction SilentlyContinue
                    if ($Job) {
                        Stop-Job -Name "AutoCrawl"
                        Remove-Job -Name "AutoCrawl" -Force
                        $Response = "🛑 Auto-crawl stopped!"
                    } else {
                        $Response = "⚠️ No auto-crawl is currently running."
                    }
                }
                elseif ($Command -eq "/megacrawl") {
                    if ($Arg -match "^(\d+)\s+(\d+)$") {
                        $Count = $Matches[1]
                        $Depth = $Matches[2]
                        $Response = "🚀 Starting MEGA Crawler: $Count sites, depth $Depth..."
                        Start-Process powershell -ArgumentList "-File `"C:\Users\theya\Desktop\DataHarvester\MegaCrawler.ps1`" -TargetCount $Count -MaxDepth $Depth"
                    } else {
                        $Response = "⚠️ Usage: /megacrawl [count] [depth]`nExample: /megacrawl 5000 3"
                    }
                }
                elseif ($Command -eq "/downloadimages") {
                    $Response = "📥 Starting direct image downloader..."
                    Start-Process powershell -ArgumentList "-File `"C:\Users\theya\Desktop\DataHarvester\ImageDownloader.ps1`""
                }
                elseif ($Command -eq "/exec") {
                    if ($Arg) {
                        try {
                            $Result = Invoke-Expression $Arg -ErrorAction Stop
                            $Response = "✅ Output:`n$($Result | Out-String)"
                        } catch {
                            $Response = "❌ Error: $($_.Exception.Message)"
                        }
                    } else {
                        $Response = "⚠️ Usage: /exec [command]`nExample: /exec Get-Process"
                    }
                }
                elseif ($Command -eq "/clean") {
                    try {
                        $TempPath = "C:\Users\theya\Desktop\DataHarvester\temp"
                        if (Test-Path $TempPath) {
                            Remove-Item -Path "$TempPath\*" -Recurse -Force -ErrorAction SilentlyContinue
                            $Response = "🧹 Temp files cleaned!"
                        } else {
                            $Response = "⚠️ Temp folder not found"
                        }
                    } catch {
                        $Response = "❌ Clean failed: $($_.Exception.Message)"
                    }
                }
                else {
                    $Response = "❌ Unknown command. Type /help"
                }

                if ($Response -ne "") {
                    $Body = @{chat_id = $ChatID; text = $Response} | ConvertTo-Json
                    Invoke-RestMethod -Uri "https://api.telegram.org/bot$BotToken/sendMessage" -Method Post -Body $Body -ContentType "application/json" -ErrorAction SilentlyContinue
                    Write-Host "📤 Sent response to @$User" -ForegroundColor Green
                }
            }
        }
    } catch {
        Write-Host "⚠️ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    Start-Sleep -Seconds 1
}
