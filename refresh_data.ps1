# ============================================
# 7-DAY DATA REFRESH
# ============================================

$date = Get-Date -Format "yyyy-MM-dd"
$dataPath = "C:\Users\theya\Google Drive\DataHarvester_Backup"
$repoPath = "C:\Users\theya\Desktop\data-repo"

Write-Host "🔄 REFRESHING DATA: $date" -ForegroundColor Cyan

# 1. Re-run the ultimate harvester
Write-Host "  Running harvester..." -ForegroundColor Yellow
cd C:\Users\theya\Desktop\data-repo
python ultimate_harvester_fixed.py

# 2. Clean the new data
Write-Host "  Cleaning data..." -ForegroundColor Yellow
python clean_data.py

# 3. Copy to Google Drive with timestamp
$backupFolder = "$dataPath\research_refresh_$date"
New-Item -ItemType Directory -Path $backupFolder -Force
Copy-Item *.txt, *.json $backupFolder -Force

# 4. Push to GitHub
Write-Host "  Pushing to GitHub..." -ForegroundColor Yellow
cd $repoPath
Copy-Item "$dataPath\research_refresh_$date\*.txt" . -Force
Copy-Item "$dataPath\research_refresh_$date\*.json" . -Force
git add *.txt *.json
git commit -m "Data refresh: $date"
git push origin main

Write-Host "✅ REFRESH COMPLETE: $date" -ForegroundColor Green
Write-Host "  Backup: $backupFolder" -ForegroundColor Gray
Write-Host "  GitHub: https://github.com/theyabknown-bit/data" -ForegroundColor Gray
