@echo off
chcp 65001
mode con cols=85 lines=25
color a
title                                                        @inso.vs Cleaner.

::Auto-elevation en droits d'admin
    if "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
    >nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
    ) ELSE (
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
    )

        if '%errorlevel%' NEQ '0' (
            ::echo Demande des droits d'Administrateur
            goto UACPrompt
        ) else ( goto gotAdmin )

        :UACPrompt
            echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
            set params= %cmdline%
            echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

            "%temp%\getadmin.vbs"
            del "%temp%\getadmin.vbs"
            exit /B

        :gotAdmin
            pushd "%CD%"
            CD /D "%~dp0"
::Fin de l'auto-elevation
timeout 5
chcp 437 > nul
POWERSHELL "$Devices = Get-PnpDevice | ? Status -eq Unknown;foreach ($Device in $Devices) { &\"pnputil\" /remove-device $Device.InstanceId }"
    rd /s /f /q C:\windows\temp\*.*
        rd /s /q C:\windows\temp
         rd /s /q C:\$Recycle.bin
md c:\windows\temp
    del /s /f /q C:\WINDOWS\Prefetch
       del /q/f/s C:\Windows\Prefetch\*
del /s /f /q C:\Windows\Prefetch\*.*
       del /s /f /q %temp%\*.*
       del /q/f/s %TEMP%\*
    del /q/f/s C:\Windows\Temp\*
       del /q/f/s "%USERPROFILE%\Local Settings\Temporary Internet Files\*"
     del /q/f/s C:\Windows\SoftwareDistribution\Download\*
      del /q/f/s C:\Windows\Logs

del /s /f /q %userprofile%\Recent\*.*
 del /s /f /q %USERPROFILE%\appdata\local\temp\*.*
   del /s /f /q %SystemRoot%\Panther\*
   del /Q C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*
     del /s /f /q %SystemRoot%\inf\setupapi.app.log
      del /s /f /q %SystemRoot%\inf\setupapi.dev.log
       del /s /f /q %SystemRoot%\inf\setupapi.offline.log
       del /Q C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache\IE\*.*

rd /s /q %temp%
    md %temp%
rd /y C:\windows\tempor~1
 rd /y C:\windows\temp
  rd /y C:\windows\tmp
   rd /y C:\windows\ff*.tmp
    rd /y C:\windows\history
       del C:\windows\cookies
        del C:\windows\recent
         del C:\windows\spool\printers
          del C:\WIN386.SWP
timeout 1 nobreak

for /F "tokens=*" %%G in ('wevtutil.exe el') DO (call :do_clear "%%G")

cls
color 4
echo "Logs" and "Cache" ont ete supprimer !
echo.----------------------------------
echo.- Press une touche pour quitter...
echo.----------------------------------
pause > nul
exit

:checkPermissions
fsutil dirty query %systemdrive% >nul
if %errorLevel% NEQ 0 (
	echo Re-essaye en lancant en admin.
	pause > nul
	exit
)
exit /b

:do_clear
echo clearing %1
wevtutil.exe cl %1
goto :eof

chcp 65001
exit /b