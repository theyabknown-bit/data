# ============================================
# DISCORD LOGGER - COMPLETE SYSTEM
# ============================================

$webhookUrl = "https://discord.com/api/webhooks/1536521751540928552/dsO1CIJtt-DUh50mnyKrxyy_ozJRHaoSHdoCoLw2faRFsNtbvIphabN1KI5W0w-ELktM"

function Send-DiscordLog {
    param($Title, $Message, $Color = "0x00ff00")
    try {
        $payload = @{
            username = "DataHarvester-Logger"
            embeds = @(@{ title = $Title; description = $Message; color = [int]$Color; timestamp = (Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ") })
        } | ConvertTo-Json -Depth 10
        Invoke-RestMethod -Uri $webhookUrl -Method Post -Body $payload -ContentType "application/json" -ErrorAction Stop
        Write-Host "✅ Discord log sent: $Title" -ForegroundColor Green
    } catch { Write-Host "❌ Discord log failed: $_" -ForegroundColor Red }
}

# Send test log
Send-DiscordLog -Title "✅ SYSTEM STARTED" -Message "DataHarvester logging online`nUser: $env:USERNAME`nComputer: $env:COMPUTERNAME"

# Watch for logs
Get-ChildItem -Path "C:\Users\theya\Desktop\data-repo\*.log" -Recurse | ForEach-Object {
    Send-DiscordLog -Title "📄 LOG FOUND" -Message "File: $($_.Name)`nSize: $([math]::Round($_.Length/1KB,2)) KB"
}

Write-Host "✅ Discord logger ready!" -ForegroundColor Green
