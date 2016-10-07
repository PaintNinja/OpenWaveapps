@echo off

REM Set and change the working directory to the directory this batch file currently resides in
set BINDIR=%~dp0
cd /D %BINDIR%

REM We are currently at Wave\Wave\webapps\Undeploy. Let's get to the root Wave directory so we can execute a command to it, regardless if this install is a portable install or a standard one.
cd ..
cd ..
cd ..

REM We're there now. Let's execute WaveThinclient to run the Deployment webapp and parse the args to it
start WaveThinclient.exe . Deploy Undeploy %*