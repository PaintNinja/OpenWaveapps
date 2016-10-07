@echo off
set BINDIR=%~dp0
cd /d %BINDIR%
title=Wave Deploy v0.72b
setlocal DisableDelayedExpansion

:: The "Deploy" WaveApp gets a specified AppName and group and sends it to all clients. Only the clients know what user groups they're on, so they decide if they accept the requested AppName depending on whether they match the specified groups.

REM Load user configuration if found, if not load default settings
if exist Deploy.conf (
	set /P IPRange=<Deploy.conf
) else (
	echo ERROR: Failed to load user configuration from "%BINDIR%Deploy.conf", loading default settings...
	set IPRange=127.0.0.0-127.0.0.1
	echo %IPRange%>Deploy.conf
)

REM Throw an error if arguments are missing
if "%1"=="" (
	echo Missing arguments!
	echo.
	echo For help, run me with the argument "/h"
	echo To change IP range settings, run me with the argument "/config"
	pause
	goto:eof
)

if "%1"=="/h" (
	echo Usage: Deploy ^(Undeploy^) ^[AppName^] ^[User group^(s^)^]
	pause
	goto:eof
)

if "%1"=="/config" (
	goto Config
)

if "%2"=="" (
	echo Missing arguments!
	echo.
	echo For help, run me with the argument "/h"
	echo To change IP range settings, run me with the argument "/config"
	pause
	goto:eof
) else (
	goto Start
)

:Config
echo Configuration
echo --------------
echo.
echo Default IP range is: "127.0.0.0-127.0.0.1"
echo Current IP range is set to: "%IPRange%"
echo.
set /P ChangeIPRangePrompt=Set a new/custom IP range? ^(Y/n^): 
echo ChangeIPRangePrompt: %ChangeIPRangePrompt%
if /I "%ChangeIPRangePrompt%"=="y" (
	echo Opening up Notepad... edit and save the file, then close Notepad to save changes.
	start /wait notepad Deploy.conf
	echo Press any key to exit...
	pause >nul
) else (
	echo That's all, folks!
	echo Press any key to exit...
	pause >nul
)
exit

:Start
:: Determine the waveapp being deployed
set WaveApp=%1

:: Check if the app is to be deployed or undeployed (by default, we will deploy the app unless "Undeploy" is specified)
if /I "%WaveApp%"=="Undeploy" (
	REM The app is to be undeployed. %2 now contains the desired WaveApp to remove.
	set Undeploy=y
	set WaveApp=%2
	REM Determine the user group requirements
	set ForUserGroups=%3
) else (
	REM Determine the user group requirements
	set ForUserGroups=%2
)

if "%Undeploy%"=="y" (
	echo Undeploying the WaveApp "%WaveApp%" to all users in the group^(s^) "%ForUserGroups%" within the IP range "%IPRange%"
	goto Undeploy
) else (
	echo Deploying the WaveApp "%WaveApp%" to all users in the group^(s^) "%ForUserGroups%" within the IP range "%IPRange%"
)

:Deploy
REM Send the app deployment request to all clients via WaveRAT
call WaveRAT-Sender-Deploy.bat,%IPRange%,DeploymentReciever,%WaveApp%,%ForUserGroups%

REM Exit when finished
exit

:Undeploy
:: Check if we're in the required user group
whoami /groups /fo csv | findstr /I "%ForUserGroups%" > NUL
if not %ERRORLEVEL%==1 (
	REM We match the required user group! Install the waveapp.
	start /MIN Wave:,Uninstall,%WaveApp%
)
exit