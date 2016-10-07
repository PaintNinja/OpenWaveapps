@echo off
echo Wave Documentation fetcher v0.1b
echo ---------------------------------
echo.
set BINDIR=%~dp0
cd /d %BINDIR%

:CheckVersion
cd /d %BINDIR%
if exist "lastversion.txt" (
	set /P version=<lastversion.txt
) else (
	echo v0.1b>lastversion.txt
	set /P version=<lastversion.txt
)
if not "%version%"=="v0.1b" (
	del /f documentation.html
	del /f lastversion.txt
)

:Start
cd /d %BINDIR%
if exist "documentation.html" (
	echo Opening the documentation in your default web browser, please wait...
	start /max documentation.html
) else (
	start /B PowerShell.exe -NoLogo -NoProfile -NonInteractive -WindowStyle Normal -Command exit
	cd /d %BINDIR%
	cd ..
	cd ..
	cd libs
	echo Downloading the latest documentation, please wait...
	call cURL.exe --tcp-nodelay --http2-prior-knowledge -# -o %BINDIR%documentation.html https://wave.gadget-guy.com/documentation.html
	echo Done!
	goto Start
)
exit