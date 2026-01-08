' First warning
Warning1 = MsgBox("THIS IS NOT AN ACTUAL PC CLEANING UTILITY. IF RAN, WILL DELETE SYSTEM 32 AND RUIN YOUR COMPUTER! DO YOU WANT TO RUN THIS PROGRAM RESULTING IN AN UNUSABLE COMPUTER?!?!?!?", 4+16, "WARNING!!!!!!!!!!!!")

Dim oShell : Set oShell = CreateObject("WScript.Shell")

If Warning1 = vbYes Then
    ' Second warning
    Warning2 = MsgBox("FINAL WARNING: This will PERMANENTLY DESTROY your Windows installation. Your PC will be COMPLETELY UNUSABLE and require a full reinstall. Are you ABSOLUTELY CERTAIN you want to continue?", 4+48, "FINAL WARNING NO GOING BACK!")
    
    If Warning2 = vbYes Then
        oShell.Run "taskkill /f /im Cscript.exe", , True
        oShell.Run "taskkill /f /im wscript.exe", , True
    Else
        oShell.Run "taskkill /f /im cmd.exe", , True
        oShell.Run "taskkill /f /im conhost.exe", , True
        oShell.Run "taskkill /f /im Cscript.exe", , True
        oShell.Run "taskkill /f /im wscript.exe", , True
    End If
    
ElseIf Warning1 = vbNo Then
    oShell.Run "taskkill /f /im cmd.exe", , True
    oShell.Run "taskkill /f /im conhost.exe", , True
    oShell.Run "taskkill /f /im Cscript.exe", , True
    oShell.Run "taskkill /f /im wscript.exe", , True
End If