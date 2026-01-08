# Auto-elevate to admin if not already
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Requesting admin privileges..."
    $scriptPath = $PSCommandPath
    $scriptDir = Split-Path -Parent $scriptPath
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -Command `"Set-Location '$scriptDir'; & '$scriptPath'`"" -Verb RunAs
    exit
}

# ============================================================================
# STEP 1: Install ps2exe from .nupkg
# ============================================================================
Write-Host "[1/5] Checking ps2exe..."

if (Get-Module -ListAvailable ps2exe) {
    Write-Host "ps2exe already installed, skipping"
} else {
    Write-Host "ps2exe not installed, looking for .nupkg..."
    
    $nupkg = Get-ChildItem -Filter "ps2exe*.nupkg" | Select-Object -First 1
    
    if (-not $nupkg) {
        Write-Host "ERROR: ps2exe not installed and ps2exe.nupkg not found!"
        Write-Host "Please download ps2exe.nupkg or run: Install-Module ps2exe"
        pause
        exit
    }
    
    Write-Host "Installing from $($nupkg.Name)..."
    
    $zipPath = $nupkg.FullName -replace '\.nupkg$', '.zip'
    Copy-Item $nupkg.FullName $zipPath
    Expand-Archive $zipPath -DestinationPath ".\ps2exe-temp" -Force
    Remove-Item $zipPath
    
    $modulePath = "$env:ProgramFiles\WindowsPowerShell\Modules\ps2exe"
    New-Item -ItemType Directory -Path $modulePath -Force | Out-Null
    Copy-Item ".\ps2exe-temp\*" -Destination $modulePath -Recurse -Force
    Remove-Item ".\ps2exe-temp" -Recurse -Force
    
    Write-Host "ps2exe installed"
}

Import-Module ps2exe
Start-Sleep -Seconds 2

# ============================================================================
# STEP 2: Remove all comments from original script
# ============================================================================
Write-Host ""
Write-Host "[2/5] Removing comments from original script..."

$scriptContent = Get-Content ".\PC Optimizer Pro.ps1" -Raw

# Remove multi-line comments <# ... #>
$scriptContent = $scriptContent -replace '(?s)<#.*?#>', ''

# Remove ONLY lines that are pure comments (start with #)
$lines = $scriptContent -split "`r?`n"
$cleanedLines = @()

foreach ($line in $lines) {
    # Skip empty lines
    if ($line -match '^\s*$') {
        continue
    }
    
    # Only remove lines that START with # (pure comment lines)
    if ($line -match '^\s*#') {
        continue
    } else {
        $cleanedLines += $line
    }
}

$scriptContent = $cleanedLines -join "`r`n"

Write-Host "Comments removed"
Start-Sleep -Seconds 2

# ============================================================================
# STEP 3: Prompt for VBS/VBE/None
# ============================================================================
Write-Host ""
Write-Host "[3/5] Select warning file type:"
Write-Host "  VBS - Unencrypted VBScript"
Write-Host "  VBE - Encrypted VBScript"
Write-Host "  N   - No warning (skip)"
$fileType = Read-Host "Choose (VBS/VBE/N)"

if ($fileType -match '^[Nn]$') {
    Write-Host "Skipping warning injection"
    $warningContent = ""
} else {
    $warningFile = ".\Assets\warning.$($fileType.ToLower())"
    
    if (-not (Test-Path $warningFile)) {
        Write-Host "ERROR: $warningFile not found!"
        pause
        exit
    }
    
    Write-Host "Using $warningFile"
    $warningContent = Get-Content $warningFile -Raw
}

# ============================================================================
# STEP 4: Inject warning into script
# ============================================================================
Write-Host ""
Write-Host "[4/5] Injecting warning into script..."

$pattern = "(?s)\`$vbsContent = @'.*?'@"
$replacement = "`$vbsContent = @'`r`n$warningContent`r`n'@"
$newScript = $scriptContent -replace $pattern, $replacement

Write-Host "Warning injected"
Start-Sleep -Seconds 2

# ============================================================================
# STEP 5: Convert to EXE with icon
# ============================================================================
Write-Host ""
Write-Host "[5/5] Converting to EXE..."

$utf8BOM = New-Object System.Text.UTF8Encoding $true
$tempScript = Join-Path $PWD "PC-Optimizer-Pro-TEMP.ps1"
[System.IO.File]::WriteAllText($tempScript, $newScript, $utf8BOM)

$iconPath = Join-Path $PWD "Assets\computer.ico"
if (-not (Test-Path $iconPath)) {
    Write-Host "WARNING: Icon not found at $iconPath"
    $iconPath = $null
}

$exePath = Join-Path $PWD "PC Optimizer Pro.exe"

if ($iconPath) {
    Invoke-ps2exe -inputFile $tempScript -outputFile $exePath -iconFile $iconPath -requireAdmin -UNICODEEncoding
} else {
    Invoke-ps2exe -inputFile $tempScript -outputFile $exePath -requireAdmin -UNICODEEncoding
}

Write-Host "EXE created: $exePath"
Start-Sleep -Seconds 2

# ============================================================================
# STEP 6: Clean up temp file
# ============================================================================
Write-Host ""
Write-Host "[6/5] Cleaning up..."

Remove-Item $tempScript -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Build complete!"
Write-Host ""
pause