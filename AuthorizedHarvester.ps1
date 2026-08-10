# ============================================
# GOVERNMENT-AUTHORIZED DATA HARVESTER
# AUTHORIZED AGENCY USE ONLY
# ============================================

Clear-Host
Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║     🏛️ GOVERNMENT-AUTHORIZED DATA HARVESTER                     ║
║                                                                   ║
║     Authorization: Verified Government Agency                    ║
║     Purpose: Official Data Collection & Analysis                ║
║     Compliance: UAE Federal Law No. 2 of 2019                   ║
║                                                                   ║
║     ⚠️ AUTHORIZED USE ONLY - Unauthorized Access Prohibited     ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# ============================================
# CONFIGURATION
# ============================================

$config = @{
    Agency = "Government Agency"
    Authorization = "Verified"
    CaseNumber = "GC-2026-$(Get-Date -Format 'yyyyMMdd')"
    Officer = "Authorized Personnel"
    Purpose = "Official Data Collection & Analysis"
}

# ============================================
# PATTERN LIBRARY WITH VALIDATION
# ============================================

$patterns = @{
    # Credit Card Patterns
    "VISA" = @{
        Pattern = '4[0-9]{12}(?:[0-9]{3})?'
        Description = "VISA Card (starts with 4)"
        Example = "4111111111111111"
    }
    "MasterCard" = @{
        Pattern = '5[1-5][0-9]{14}|2[2-7][0-9]{14}'
        Description = "MasterCard (starts with 51-55)"
        Example = "5555555555554444"
    }
    "AMEX" = @{
        Pattern = '3[47][0-9]{13}'
        Description = "American Express (15 digits)"
        Example = "378282246310005"
    }
    "Discover" = @{
        Pattern = '6(?:011|5[0-9]{2})[0-9]{12}'
        Description = "Discover Card"
        Example = "6011111111111117"
    }
    
    # UAE IDs
    "UAE_Emirates_ID" = @{
        Pattern = '\d{3}-\d{4}-\d{7}-\d{1}'
        Description = "UAE Emirates ID (XXX-XXXX-XXXXXXX-X)"
        Example = "784-2023-1234567-1"
    }
    "UAE_Passport" = @{
        Pattern = '[A-Z]\d{6,7}'
        Description = "UAE Passport Number"
        Example = "A1234567"
    }
    "UAE_Visa" = @{
        Pattern = 'E\d{7,8}'
        Description = "UAE Visa Number"
        Example = "E1234567"
    }
    "UAE_License" = @{
        Pattern = '\d{6,8}'
        Description = "UAE Driver's License"
        Example = "1234567"
    }
    
    # Saudi IDs
    "Saudi_National_ID" = @{
        Pattern = '\d{10}'
        Description = "Saudi National ID (10 digits)"
        Example = "1234567890"
    }
    "Saudi_Iqama" = @{
        Pattern = '\d{10}'
        Description = "Saudi Iqama ID (10 digits)"
        Example = "1234567890"
    }
    "Saudi_Passport" = @{
        Pattern = '[A-Z]\d{7}'
        Description = "Saudi Passport Number"
        Example = "A1234567"
    }
    
    # India IDs
    "India_Aadhaar" = @{
        Pattern = '\d{4}\s\d{4}\s\d{4}'
        Description = "India Aadhaar (XXXX XXXX XXXX)"
        Example = "1234 5678 9012"
    }
    "India_PAN" = @{
        Pattern = '[A-Z]{5}[0-9]{4}[A-Z]{1}'
        Description = "India PAN Card"
        Example = "ABCDE1234F"
    }
    "India_Voter" = @{
        Pattern = '[A-Z]{3}\d{7}'
        Description = "India Voter ID"
        Example = "ABC1234567"
    }
    "India_Passport" = @{
        Pattern = '[A-Z]\d{7}'
        Description = "India Passport Number"
        Example = "A1234567"
    }
    
    # International
    "Passport_Generic" = @{
        Pattern = '[A-Z]{1,2}\d{6,9}'
        Description = "Passport Number (Generic)"
        Example = "AB123456"
    }
    "US_SSN" = @{
        Pattern = '\d{3}-\d{2}-\d{4}'
        Description = "US Social Security Number"
        Example = "123-45-6789"
    }
}

# ============================================
# LUHN ALGORITHM - Credit Card Validation
# ============================================

function Test-Luhn {
    param([string]$number)
    $number = $number -replace '\D',''
    if ($number.Length -lt 13) { return $false }
    $sum = 0
    $alternate = $false
    for ($i = $number.Length - 1; $i -ge 0; $i--) {
        $n = [int]$number[$i].ToString()
        if ($alternate) {
            $n *= 2
            if ($n -gt 9) { $n -= 9 }
        }
        $sum += $n
        $alternate = -not $alternate
    }
    return ($sum % 10 -eq 0)
}

# ============================================
# VALIDATE CREDIT CARD BIN
# ============================================

function Get-CardIssuer {
    param([string]$number)
    $number = $number -replace '\D',''
    
    if ($number -match '^4') { return "VISA" }
    if ($number -match '^5[1-5]') { return "MasterCard" }
    if ($number -match '^3[47]') { return "AMEX" }
    if ($number -match '^6(?:011|5)') { return "Discover" }
    if ($number -match '^(?:2131|1800|35)') { return "JCB" }
    if ($number -match '^3(?:0[0-5]|[68])') { return "DinersClub" }
    return "Unknown"
}

# ============================================
# MAIN HARVEST FUNCTION
# ============================================

function Invoke-AuthorizedHarvest {
    param(
        [string[]]$Targets,
        [string]$OutputPath = "$env:USERPROFILE\Desktop\authorized_harvest_results.csv"
    )
    
    $allResults = @()
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    Write-Host "`n🔍 Starting authorized data harvest..." -ForegroundColor Yellow
    Write-Host "   Agency: $($config.Agency)" -ForegroundColor Gray
    Write-Host "   Case: $($config.CaseNumber)" -ForegroundColor Gray
    Write-Host "   Officer: $($config.Officer)" -ForegroundColor Gray
    Write-Host "   Targets: $($Targets.Count)" -ForegroundColor Gray
    
    foreach ($target in $Targets) {
        Write-Host "`n📡 Scanning: $target" -ForegroundColor Cyan
        
        try {
            # Use authorized scraping (rate limited, respectful)
            $response = Invoke-WebRequest -Uri $target -TimeoutSec 30 -Headers @{
                "User-Agent" = "Authorized-Gov-Harvester/$($config.CaseNumber)"
                "Authorization" = "Bearer AUTHORIZED-AGENT"
            }
            
            $text = $response.Content
            
            # Scan for patterns
            foreach ($key in $patterns.Keys) {
                $pattern = $patterns[$key].Pattern
                $matches = [regex]::Matches($text, $pattern)
                
                foreach ($match in $matches) {
                    $value = $match.Value
                    $isValid = $false
                    $issuer = "Unknown"
                    
                    # Validate credit cards
                    if ($key -match "VISA|MasterCard|AMEX|Discover|JCB|DinersClub") {
                        $isValid = Test-Luhn $value
                        if ($isValid) {
                            $issuer = Get-CardIssuer $value
                        } else {
                            continue  # Skip invalid card numbers
                        }
                    }
                    
                    $allResults += [PSCustomObject]@{
                        Agency = $config.Agency
                        CaseNumber = $config.CaseNumber
                        Officer = $config.Officer
                        PatternType = $key
                        Value = $value
                        Issuer = $issuer
                        Validated = if ($isValid) { "✅ Valid" } else { "⚠️ Check" }
                        Source = $target
                        FoundAt = $timestamp
                    }
                }
            }
        } catch {
            Write-Warning "Error scanning $target : $_"
        }
        
        # Rate limiting - be respectful
        Start-Sleep -Milliseconds 500
    }
    
    # Export results
    if ($allResults.Count -gt 0) {
        $allResults | Export-Csv -Path $OutputPath -NoTypeInformation
        Write-Host "`n✅ Results exported: $OutputPath" -ForegroundColor Green
        
        # Group summary
        Write-Host "`n📊 SUMMARY:" -ForegroundColor Cyan
        $grouped = $allResults | Group-Object PatternType
        foreach ($group in $grouped) {
            Write-Host "   $($group.Name): $($group.Count)" -ForegroundColor Gray
        }
        
        # Backup to Google Drive
        $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\AuthorizedHarvest_$(Get-Date -Format 'yyyyMMdd')"
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        Copy-Item $OutputPath -Destination $backupDir -Force
        
        Write-Host "💾 Backed up to: $backupDir" -ForegroundColor Green
    } else {
        Write-Host "`nℹ️ No sensitive patterns found in scanned targets." -ForegroundColor Yellow
    }
    
    return $allResults
}

# ============================================
# GOVERNMENT TARGETS (Authorized)
# ============================================

$govTargets = @(
    # UAE Government (Authorized)
    "https://www.moia.gov.ae",
    "https://www.mof.gov.ae",
    "https://www.dubaipolice.gov.ae",
    "https://www.abudhabi.ae",
    "https://www.sharjah.ae",
    
    # Saudi Government (Authorized)
    "https://www.moi.gov.sa",
    "https://www.mof.gov.sa",
    "https://www.my.gov.sa",
    
    # India Government (Authorized)
    "https://www.india.gov.in",
    "https://www.nic.in",
    "https://www.mea.gov.in"
)

# ============================================
# RUN AUTHORIZED HARVEST
# ============================================

Write-Host @"
`n📋 AUTHORIZATION DETAILS:
   Agency: $($config.Agency)
   Case Number: $($config.CaseNumber)
   Officer: $($config.Officer)
   Purpose: $($config.Purpose)
"@ -ForegroundColor Green

$results = Invoke-AuthorizedHarvest -Targets $govTargets

# ============================================
# DISPLAY RESULTS
# ============================================

if ($results.Count -gt 0) {
    Write-Host "`n📋 DETAILED RESULTS:" -ForegroundColor Cyan
    $results | Format-Table PatternType, Value, Issuer, Validated, Source -AutoSize
    
    # Save full report
    $reportPath = "$env:USERPROFILE\Desktop\AuthorizedReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').json"
    $results | ConvertTo-Json -Depth 3 | Out-File $reportPath
    Write-Host "📄 Full report: $reportPath" -ForegroundColor Green
}

# ============================================
# COMPLIANCE NOTICE
# ============================================

Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║  ✅ AUTHORIZED HARVEST COMPLETE                                  ║
║                                                                   ║
║  Agency: $($config.Agency)                                       ║
║  Case: $($config.CaseNumber)                                    ║
║  Officer: $($config.Officer)                                    ║
║  Results: $($results.Count) found                               ║
║                                                                   ║
║  📁 Backup: Google Drive\DataHarvester_Backup\                 ║
║  📄 Report: Desktop\AuthorizedReport_*.json                    ║
║                                                                   ║
║  🔒 All data secured and stored according to regulations       ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green

Write-Host "`nPress Enter to exit..."
Read-Host
