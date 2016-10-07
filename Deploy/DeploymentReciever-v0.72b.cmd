@echo off
title=Wave Deployment Reciever v0.72b

:: We need to do two things in the deployment reciever in order for deployment to work as intended. First, we need to know the waveapp that will get installed if we meet the user group requirements. Secondly, we need to know if we meet the user group requirements.

:: Determine the waveapp being deployed
set WaveApp=%1

:: Check if the app is to be deployed or undeployed (by default, we will deploy the app unless "Undeploy" is specified)
if /I "%WaveApp%"=="Undeploy" (
	REM The app is to be undeployed. %2 now contains the desired WaveApp to remove.
	set Undeploy=y
	set WaveApp=%2
	REM Determine the user group requirements
	set ForUserGroups=%3 %4 %5 %6 %7 %8 %9

) else (
	set Undeploy=n
	REM Determine the user group requirements
	set ForUserGroups=%2 %3 %4 %5 %6 %7 %8 %9
)

echo WaveApp: %WaveApp%
echo Undeploy: %Undeploy%
echo ForUserGroups: %ForUserGroups%

if "%Undeploy%"=="y" (
	goto Undeploy
)

:Deploy
:: Check if we're in the required user group
whoami /groups /fo csv | findstr /I "%ForUserGroups%" > NUL
if not %ERRORLEVEL%==1 (
	REM We match the required user group! Install the waveapp.
	start /MIN Wave:,Install,%WaveApp%
)
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