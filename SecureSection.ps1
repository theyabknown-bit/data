# ============================================
# SECURE LEGAL/ILLEGAL SECTION
# Password: theyab!@12
# ============================================

function Show-AccessDenied {
    Clear-Host
    Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║              ⛔ ACCESS DENIED                                     ║
║                                                                   ║
║  This section requires authentication.                           ║
║  Please run again with correct password.                        ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Red
    exit
}

function Show-LegalSection {
    Clear-Host
    Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                    ⚖️ LEGAL SECTION                              ║
║                    Authorized Access Only                        ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  ✅ LEGAL USES OF DATA HARVESTING:                               ║
║                                                                   ║
║  1. Research and Education                                       ║
║     - Academic research on cybersecurity                        ║
║     - Training and awareness programs                           ║
║     - Educational purposes                                       ║
║                                                                   ║
║  2. Security Research                                            ║
║     - Vulnerability assessment                                   ║
║     - Penetration testing (with authorization)                  ║
║     - Security audit                                             ║
║                                                                   ║
║  3. Business Intelligence                                        ║
║     - Market research                                            ║
║     - Competitive analysis                                       ║
║     - Lead generation (compliant)                                ║
║                                                                   ║
║  4. Public Information Gathering                                 ║
║     - Public records research                                    ║
║     - Government transparency                                    ║
║     - Journalistic purposes                                      ║
║                                                                   ║
║  5. Law Enforcement (with warrant)                               ║
║     - Criminal investigation                                     ║
║     - Evidence gathering                                         ║
║     - Court-ordered surveillance                                 ║
║                                                                   ║
║  6. Cybersecurity Defense                                        ║
║     - Threat intelligence                                        ║
║     - Risk assessment                                            ║
║     - Incident response                                          ║
║                                                                   ║
║  7. Compliance                                                   ║
║     - GDPR compliance checks                                    ║
║     - CCPA compliance checks                                     ║
║     - Regulatory compliance                                      ║
║                                                                   ║
║  8. Penetration Testing (with permission)                        ║
║     - Authorized security testing                                ║
║     - Ethical hacking                                            ║
║     - Bug bounty research                                        ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  ⚠️ KEY PRINCIPLES:                                              ║
║                                                                   ║
║  • Always have permission before scanning                       ║
║  • Respect robots.txt                                            ║
║  • Follow rate limiting                                          ║
║  • Comply with data protection laws                              ║
║  • Handle data responsibly                                       ║
║  • Delete data when no longer needed                            ║
║  • Encrypt sensitive data                                        ║
║  • Inform users of data collection                               ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  📜 RELEVANT LAWS:                                               ║
║                                                                   ║
║  • UAE: Federal Law No. 2 of 2019 (Cybercrimes)                ║
║  • Saudi Arabia: Anti-Cyber Crime Law                           ║
║  • India: IT Act 2000 & Data Protection Bill                   ║
║  • GDPR (EU)                                                     ║
║  • CCPA (California)                                             ║
║  • CFAA (US)                                                     ║
║  • Computer Misuse Act (UK)                                      ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green
}

function Show-IllegalSection {
    Clear-Host
    Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║                    🚫 ILLEGAL SECTION                            ║
║                    UN-AUTHORIZED ACCESS                          ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  ❌ ILLEGAL USES OF DATA HARVESTING:                             ║
║                                                                   ║
║  1. Unauthorized Access                                          ║
║     - Hacking without permission                                ║
║     - Bypassing security measures                               ║
║     - Credential theft                                           ║
║                                                                   ║
║  2. Data Theft                                                    ║
║     - Stealing personal information                              ║
║     - Identity theft                                             ║
║     - Financial fraud                                            ║
║                                                                   ║
║  3. Privacy Violations                                            ║
║     - Spying on individuals                                      ║
║     - Stalking                                                    ║
║     - Unauthorized surveillance                                  ║
║                                                                   ║
║  4. Intellectual Property Theft                                  ║
║     - Stealing trade secrets                                     ║
║     - Copyright infringement                                     ║
║     - Patent theft                                               ║
║                                                                   ║
║  5. Malware Distribution                                          ║
║     - Spreading viruses                                          ║
║     - Ransomware attacks                                         ║
║     - Botnet creation                                            ║
║                                                                   ║
║  6. Phishing Attacks                                              ║
║     - Email scams                                                 ║
║     - Spear phishing                                             ║
║     - Smishing                                                    ║
║                                                                   ║
║  7. DDoS Attacks                                                  ║
║     - Website takedowns                                          ║
║     - Service disruption                                         ║
║     - Extortion                                                   ║
║                                                                   ║
║  8. Data Ransom                                                  ║
║     - Ransomware demands                                         ║
║     - Blackmail                                                   ║
║     - Extortion                                                   ║
║                                                                   ║
║  9. Insider Trading                                               ║
║     - Using stolen data for trading                              ║
║     - Market manipulation                                        ║
║                                                                   ║
║  10. Espionage                                                    ║
║      - Corporate espionage                                       ║
║      - State-sponsored attacks                                  ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  ⚠️ LEGAL CONSEQUENCES:                                          ║
║                                                                   ║
║  UAE: Imprisonment up to 15 years + fines up to AED 15M        ║
║  KSA: Imprisonment up to 10 years + fines up to SAR 5M        ║
║  India: Imprisonment up to 10 years + fines                     ║
║  USA: Imprisonment up to 20 years + fines                       ║
║  EU: Fines up to €20M or 4% of global turnover                 ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  📋 WHAT CONSTITUTES ILLEGAL HARVESTING:                        ║
║                                                                   ║
║  ❌ Accessing systems without authorization                      ║
║  ❌ Bypassing authentication measures                            ║
║  ❌ Extracting personal data without consent                    ║
║  ❌ Selling or trading stolen data                              ║
║  ❌ Using data for malicious purposes                           ║
║  ❌ Exceeding authorized scope of access                        ║
║  ❌ Modifying or destroying data                                ║
║  ❌ Denial of service attacks                                   ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Red
}

function Show-EducationalNotice {
    Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║  📚 EDUCATIONAL USE ONLY                                         ║
║                                                                   ║
║  This information is provided for educational purposes only.    ║
║  Understanding illegal activities helps protect against them.   ║
║                                                                   ║
║  Always:                                                         ║
║  ✅ Get permission before scanning                              ║
║  ✅ Follow the law                                              ║
║  ✅ Respect privacy                                             ║
║  ✅ Use data responsibly                                         ║
║                                                                   ║
║  Never:                                                          ║
║  ❌ Access systems without authorization                        ║
║  ❌ Steal or misuse data                                        ║
║  ❌ Harm others                                                  ║
║  ❌ Break the law                                                ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Yellow
}

# ============================================
# MAIN MENU
# ============================================

Clear-Host

Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║           🔐 SECURE ACCESS REQUIRED                             ║
║                                                                   ║
║           Legal & Illegal Section                               ║
║           Password Protected                                    ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

$password = Read-Host "`nEnter Password" -AsSecureString
$plainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

if ($plainPassword -eq "theyab!@12") {
    Clear-Host
    Write-Host @"
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║              ✅ ACCESS GRANTED                                    ║
║                                                                   ║
║              Welcome Authorized User                             ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Green
    
    Show-EducationalNotice
    
    $choice = Read-Host "`nSelect Section:`n1 - Legal`n2 - Illegal`n3 - Both`n4 - Export to Files`n5 - Exit`n`nChoice"
    
    switch ($choice) {
        "1" { Show-LegalSection }
        "2" { Show-IllegalSection }
        "3" { 
            Show-LegalSection
            Write-Host "`nPress Enter to continue to Illegal Section..." -ForegroundColor Yellow
            Read-Host
            Show-IllegalSection
        }
        "4" { 
            Write-Host "`n📁 Exporting to files..." -ForegroundColor Yellow
            $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
            Show-LegalSection | Out-File "$env:USERPROFILE\Desktop\legal_section_$timestamp.txt" -Encoding UTF8
            Show-IllegalSection | Out-File "$env:USERPROFILE\Desktop\illegal_section_$timestamp.txt" -Encoding UTF8
            $backupDir = "C:\Users\theya\Google Drive\DataHarvester_Backup\legal_illegal_$timestamp"
            New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
            Copy-Item "$env:USERPROFILE\Desktop\legal_*.txt" -Destination $backupDir -Force
            Copy-Item "$env:USERPROFILE\Desktop\illegal_*.txt" -Destination $backupDir -Force
            Write-Host "✅ Exported to: $backupDir" -ForegroundColor Green
            Remove-Item "$env:USERPROFILE\Desktop\legal_*.txt" -Force -ErrorAction SilentlyContinue
            Remove-Item "$env:USERPROFILE\Desktop\illegal_*.txt" -Force -ErrorAction SilentlyContinue
            explorer $backupDir
        }
        "5" { 
            Write-Host "`nExiting..." -ForegroundColor Yellow
            exit 
        }
        default { 
            Write-Host "`nInvalid choice. Exiting." -ForegroundColor Red
            exit
        }
    }
    
    Write-Host "`n`nPress Enter to exit..." -ForegroundColor Yellow
    Read-Host
    
} else {
    Show-AccessDenied
}
