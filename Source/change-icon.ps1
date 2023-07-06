$exePath = ".\PC Optimizer Pro.exe"
$iconPath = ".\Assets\computer.ico"

$shell = New-Object -ComObject Shell.Application
$shortcut = $shell.CreateShortcut($exePath)
$shortcut.IconLocation = $iconPath
$shortcut.Save()

$shell.Namespace((Split-Path -Parent $exePath)).ParseName((Split-Path -Leaf $exePath)).InvokeVerb("Properties")