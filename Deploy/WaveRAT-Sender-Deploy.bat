@echo off
set BINDIR=%~dp0
cd /d %BINDIR%

REM Prompt for input if arguments are missing
if "%1"=="" (
	set /P %1=Please enter an IP range in the format x.x.x.x-y.y.y.y: 
)
if "%2"=="" (
	set /P %2=Please enter an AppName request you wish to send to the specified IPs: 
)

:StartSend
if exist waveratsendapp.tmp del /q waveratsendapp.tmp
REM  %1 is the IP range, %2 is the appname
set waveratsendiprange=%1
set waveratsendapp=%2,%3,%4,%5,%6,%7,%8,%9
echo %waveratsendapp% >waveratsendapp.tmp

REM This seperates the two IPs in the range. E.g. IPStartRange is 192.168.1.2 and IPEndRange is 192.168.1.8 if the input is "192.168.1.2-192.168.1.8"
echo %waveratsendiprange%>IPRange.tmp
for /F "tokens=1-2* delims=-" %%A in (IPRange.tmp) do (
	set IPStartRange=%%A
	set IPEndRange=%%B
)

echo %IPStartRange%>IPStartRange.tmp
echo %IPEndRange%>IPEndRange.tmp
REM Now seperate the 4 parts of each IP address into their own variables
for /F "tokens=1-4* delims=." %%A in (IPStartRange.tmp) do (
	set IPStartRange-1=%%A
	set IPStartRange-2=%%B
	set IPStartRange-3=%%C
	set IPStartRange-4=%%D
)

for /F "tokens=1-4* delims=." %%A in (IPEndRange.tmp) do (
	set IPEndRange-1=%%A
	set IPEndRange-2=%%B
	set IPEndRange-3=%%C
	set IPEndRange-4=%%D
)

REM IP range command for loop code adapted from https://jwcooney.com/2014/11/27/batch-script-to-ping-a-range-of-ip-addresses-to-identify-active-computers/
set startTime=%time%
REM Time difference code from http://stackoverflow.com/questions/9922498/calculate-time-difference-in-windows-batch-file

rem Get start time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

setlocal EnableDelayedExpansion
echo Starting deployment...
for /L %%w in (%IPStartRange-1%,1,%IPEndRange-1%) do @(
	for /L %%x in (%IPStartRange-2%,1,%IPEndRange-2%) do @(
		for /L %%y in (%IPStartRange-3%,1,%IPEndRange-3%) do @(
			for /L %%z in (%IPStartRange-4%,1,%IPEndRange-4%) do @(
				echo Sending WaveRAT command to IP: %%w.%%x.%%y.%%z
				set CurrentIP=%%w.%%x.%%y.%%z
				type waveratsendapp.tmp | ncat --send-only -w 2s !CurrentIP! 8080
			)
		)
	)
)
setlocal DisableDelayedExpansion

rem Get end time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

rem Get elapsed time:
set /A elapsed=end-start

rem Show elapsed time:
set /A hh=elapsed/(60*60*100), rest=elapsed%%(60*60*100), mm=rest/(60*100), rest%%=60*100, ss=rest/100, cc=rest%%100
if %mm% lss 10 set mm=0%mm%
if %ss% lss 10 set ss=0%ss%
if %cc% lss 10 set cc=0%cc%

echo.
echo *** Finished! ***
if %hh% EQU 0 (
	echo Run time = %mm%mins %ss%secs
) else (
	echo Run time = %hh%hours %mm%mins %ss%secs
)
echo.
echo To exit, press any key...
pause >NUL