@echo off
SET Version=Stable v1.01
SET Title=OpenFolder %Version%
SET ErrorTitle=OpenFolder Error %Version%
Title=OpenFolder - %Version%
if "%1"=="" (
goto Welcome
)
if "%1"=="license" (
goto License
) else (
goto OpenFolder
)
:Welcome
cls
echo %Title%
if exist %Wave%\libs\UI.cmd (
call %Wave%\libs\UI.cmd,TitleBar
) else (
echo ======================
)
echo This tiny Wave webapp opens a specific folder on the PC it is run on, if
echo it exists, of course. To view this webapp's license, run me with the argument
echo "license". (Wave:,OpenFolder,license)
echo.
echo Run this with the argument of the folder you want to open. If the folder
echo doesn't exist, we'll let you know.
echo.
echo Example: Wave:,OpenFolder,%%ProgramFiles%%
echo will open the %%ProgramFiles%% folder
echo.
echo Tip! Use %%Username%% for stuff like C:\Users\%%Username%%\Documents for
echo example so that you can open up the "Documents" folder on the current user
echo even if you don't know the username.
echo.
pause
exit
:OpenFolder
if not exist "%1" (
cls
echo %ErrorTitle%
echo ======================
echo Whoops! I couldn't find the folder or directory:
echo %1
echo ...so I was unable to open it.
pause
exit
) else (
start explorer.exe %1
exit
)
:License
echo This webapp is licensed under the permissive MIT license.
echo.
echo The MIT License (MIT)
echo.
echo Copyright (c) 2016 Oscar Nardone
echo.
echo Permission is hereby granted, free of charge, to any person obtaining a copy
echo of this software and associated documentation files (the "Software"), to deal
echo in the Software without restriction, including without limitation the rights
echo to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
echo copies of the Software, and to permit persons to whom the Software is
echo furnished to do so, subject to the following conditions:
echo.
echo The above copyright notice and this permission notice shall be included in all
echo copies or substantial portions of the Software.
echo.
echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
echo IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
echo FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
echo AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
echo LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
echo OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
echo SOFTWARE.
echo.
echo To quit,
pause
exit