# ===== GITHUB AUTO-UPLOADER (RETRY LOOP) =====
$GitHubToken = "YOUR_GITHUB_PAT_HERE"
$LocalRepoPath = "C:\Users\theya\Desktop\data-git-repo"
$MaxRetries = 5

$SourceFolders = @(
    "C:\Users\theya\Desktop\data-repo",
    "G:\DataHarvester_Images"
)

try {
    Write-Host "📦 Syncing data to GitHub..." -ForegroundColor Cyan

    if (-not (Test-Path $LocalRepoPath)) {
        Write-Host "Cloning repository..."
        git clone "https://$GitHubToken@github.com/theyabknown-bit/data.git" $LocalRepoPath
    }

    # Copy files to repo
    foreach ($Path in $SourceFolders) {
        if (Test-Path $Path) {
            Write-Host "Copying files from $Path..."
            Copy-Item -Path "$Path\*" -Destination "$LocalRepoPath\" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    Push-Location $LocalRepoPath

    # Add and Commit
    git add -A
    $CommitMessage = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m "$CommitMessage"

    # RETRY LOOP TO PUSH
    $Pushed = $false
    for ($i = 0; $i -lt $MaxRetries; $i++) {
        try {
            git pull --rebase origin main
            git push origin main
            $Pushed = $true
            break
        } catch {
            Write-Host "⚠️ Push failed (attempt $($i + 1)/$MaxRetries). Retrying..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
        }
    }

    Pop-Location

    if ($Pushed) {
        Write-Host "✅ Data successfully pushed to GitHub!" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to push after $MaxRetries attempts." -ForegroundColor Red
    }
} catch {
    Write-Host "❌ Script error: $($_.Exception.Message)" -ForegroundColor Red
}
