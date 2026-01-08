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

# ============================================================================
# STEP 2: Prompt for VBS or VBE
# ============================================================================
Write-Host ""
Write-Host "[2/5] Select warning file type:"
$fileType = Read-Host "VBS or VBE?"

$warningFile = ".\Assets\warning.$($fileType.ToLower())"

if (-not (Test-Path $warningFile)) {
    Write-Host "ERROR: $warningFile not found!"
    pause
    exit
}

Write-Host "Using $warningFile"

# ============================================================================
# STEP 3: Inject warning into script
# ============================================================================
Write-Host ""
Write-Host "[3/5] Injecting warning into script..."

$warningContent = Get-Content $warningFile -Raw
$scriptContent = Get-Content ".\PC Optimizer Pro.ps1" -Raw

$pattern = "(?s)\`$vbsContent = @'.*?'@"
$replacement = "`$vbsContent = @'`r`n$warningContent`r`n'@"
$newScript = $scriptContent -replace $pattern, $replacement

$tempScript = ".\PC-Optimizer-Pro-TEMP.ps1"
$utf8BOM = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllText($tempScript, $newScript, $utf8BOM)

Write-Host "Warning injected"

# ============================================================================
# STEP 4: Convert to EXE with icon
# ============================================================================
Write-Host ""
Write-Host "[4/5] Converting to EXE..."

$iconPath = ".\Assets\computer.ico"
if (-not (Test-Path $iconPath)) {
    Write-Host "WARNING: Icon not found at $iconPath"
    $iconPath = $null
}

$exePath = ".\PC Optimizer Pro.exe"

if ($iconPath) {
    Invoke-ps2exe -inputFile $tempScript -outputFile $exePath -iconFile $iconPath -requireAdmin
} else {
    Invoke-ps2exe -inputFile $tempScript -outputFile $exePath -requireAdmin
}

Write-Host "EXE created: $exePath"

# ============================================================================
# STEP 5: Clean up temp file
# ============================================================================
Write-Host ""
Write-Host "[5/5] Cleaning up..."

Remove-Item $tempScript -Force

Write-Host "Build complete!"
Write-Host ""
pause