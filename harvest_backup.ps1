# ============================================
# AUTO-BACKUP + LOCAL DELETE
# ============================================

$date = Get-Date -Format "yyyy-MM-dd_HHmmss"
$drivePath = "C:\Users\theya\Google Drive\DataHarvester_Backup"
$repoPath = "C:\Users\theya\Desktop\data-repo"
$desktopPath = "C:\Users\theya\Desktop"

Write-Host "=== AUTO-BACKUP STARTED: $date ===" -ForegroundColor Cyan

# 1. Create backup folder in Google Drive
$backupFolder = "$drivePath\harvest_$date"
New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null
Write-Host "Created backup folder: $backupFolder" -ForegroundColor Yellow

# 2. Copy ALL data to Google Drive
Write-Host "Copying data to Google Drive..." -ForegroundColor Yellow
Copy-Item -Recurse -Path "$repoPath\*" -Destination $backupFolder -Force -ErrorAction SilentlyContinue
Copy-Item "$desktopPath\*.txt" -Destination $backupFolder -Force -ErrorAction SilentlyContinue

$backupSize = (Get-ChildItem $backupFolder -Recurse | Measure-Object -Property Length -Sum).Sum
Write-Host "Backup complete: $([math]::Round($backupSize/1KB, 2)) KB" -ForegroundColor Green

# 3. Push to GitHub
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
Set-Location $repoPath
git add .
git commit -m "Auto-sync: $date"
git push origin main

# 4. DELETE LOCAL DATA (everything except scripts and .git)
Write-Host "Deleting local data..." -ForegroundColor Red

# Delete all text files
Remove-Item "$repoPath\*.txt" -Force -ErrorAction SilentlyContinue
Remove-Item "$desktopPath\*.txt" -Force -ErrorAction SilentlyContinue

# Delete all JSON files
Remove-Item "$repoPath\*.json" -Force -ErrorAction SilentlyContinue

# Delete all log files
Remove-Item "$repoPath\*.log" -Force -ErrorAction SilentlyContinue

# Delete all harvested folders (epstein_, bbc_data, israel_, etc.)
Get-ChildItem -Path $repoPath -Directory | Where-Object {
    $_.Name -match "epstein_|bbc_data|harvest_output|israel_|dubai_|uae_|riyadh_|qatar_|jordan_|kuwait_|bahrain_|oman_|egypt_|jerusalem_|tel_aviv_|haifa_|abudhabi_|sharjah_|saudi_|state_dept|un_contact|usa_|whitehouse|address_crawl"
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Delete all folders except .git and docs (keep GitHub Pages)
Get-ChildItem -Path $repoPath -Directory | Where-Object {
    $_.Name -notin @('.git', 'docs')
} | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# Keep only essential files
Write-Host "Keeping: .git, docs, main.py, harvest_backup.ps1" -ForegroundColor Yellow

Write-Host "✅ Local data deleted." -ForegroundColor Red
Write-Host "Data is now only on Google Drive and GitHub." -ForegroundColor Green
Write-Host "=== AUTO-BACKUP + DELETE COMPLETED ===" -ForegroundColor Cyan
