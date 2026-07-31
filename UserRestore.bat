@echo off
setlocal EnableDelayedExpansion

title ----- UserRestore -----
color 0B 
mode con: cols=70 lines=25

:MENU
cls
echo +------------------------------------------------------------------+
echo ^|                                                                  ^|
echo ^|                         UserRestore                              ^|
echo ^|                   User Profile Restoration                       ^|
echo ^|                                                                  ^|
echo ^|  Restore files created by UserSync                               ^|
echo ^|                                                                  ^|
echo +------------------------------------------------------------------+
echo.

echo Where is your backup?
echo.
echo   [1] Desktop
echo   [2] Another Drive
echo.

choice /C 12 /N /M "Select an option (1-2): "

if errorlevel 2 goto OTHER
if errorlevel 1 goto DESKTOP

:DESKTOP
cls

echo.
echo Backups found on Desktop:
echo.

set COUNT=0

for /d %%D in ("%USERPROFILE%\Desktop\*") do (
    set /a COUNT+=1
    set FOLDER!COUNT!=%%~fD
    echo !COUNT!. %%~nxD
)

if %COUNT%==0 (
    echo.
    echo No backup folders were found.
    pause
    goto MENU
)

echo.
set /p PICK=Select Backup Number:

call set "BACKUP=%%FOLDER%PICK%%%"
goto CHECK

:OTHER

set /p DRIVE=Backup Drive Letter (Example E):
set DRIVE=%DRIVE::=%

if not exist "%DRIVE%:\" (
    echo.
    echo Drive not found.
    pause
    goto MENU
)

echo.

set COUNT=0

for /d %%D in ("%DRIVE%:\*") do (
    set /a COUNT+=1
    set FOLDER!COUNT!=%%~fD
    echo !COUNT!. %%~nxD
)

echo.
set /p PICK=Select Backup Number:

call set "BACKUP=%%FOLDER%PICK%%%"

:CHECK

if not exist "%BACKUP%" (
    echo.
    echo Invalid backup.
    pause
    goto MENU
)

cls
echo.
echo Backup Selected:
echo %BACKUP%
echo.

pause

cls

echo ===============================================
echo Beginning Restore...
echo ===============================================
echo.

for /d %%U in ("%BACKUP%\*") do (
    call :RESTORE "%%U"
)

color 0A
echo.
echo ===============================================
echo Restore Complete!
echo ===============================================
echo.
echo You may now restart Windows.
echo.
pause
exit

:RESTORE

set PROFILE=%~1
set USER=%~nx1

if /I "%USER%"=="Public" exit /b
if /I "%USER%"=="Default" exit /b
if /I "%USER%"=="Default User" exit /b
if /I "%USER%"=="All Users" exit /b
if /I "%USER%"=="defaultuser0" exit /b

cls
color 0E

echo ===============================================
echo Restoring %USER%
echo ===============================================
echo.

if not exist "C:\Users\%USER%" (
    echo Creating C:\Users\%USER%
    mkdir "C:\Users\%USER%" >nul
)

echo [1/20] Desktop
robocopy "%PROFILE%\Desktop" "C:\Users\%USER%\Desktop" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [2/20] Documents
robocopy "%PROFILE%\Documents" "C:\Users\%USER%\Documents" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [3/20] Downloads
robocopy "%PROFILE%\Downloads" "C:\Users\%USER%\Downloads" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [4/20] Pictures
robocopy "%PROFILE%\Pictures" "C:\Users\%USER%\Pictures" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [5/20] Videos
robocopy "%PROFILE%\Videos" "C:\Users\%USER%\Videos" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [6/20] Music
robocopy "%PROFILE%\Music" "C:\Users\%USER%\Music" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [7/20] Favorites
robocopy "%PROFILE%\Favorites" "C:\Users\%USER%\Favorites" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [8/20] Saved Games
robocopy "%PROFILE%\Saved Games" "C:\Users\%USER%\Saved Games" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [9/20] Contacts
robocopy "%PROFILE%\Contacts" "C:\Users\%USER%\Contacts" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [10/20] Links
robocopy "%PROFILE%\Links" "C:\Users\%USER%\Links" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [11/20] Searches
robocopy "%PROFILE%\Searches" "C:\Users\%USER%\Searches" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [12/20] OneDrive
robocopy "%PROFILE%\OneDrive" "C:\Users\%USER%\OneDrive" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [13/20] AppData
robocopy "%PROFILE%\AppData" "C:\Users\%USER%\AppData" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [14/20] Browser Data
robocopy "%PROFILE%\AppData\Local" "C:\Users\%USER%\AppData\Local" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [15/20] Outlook
robocopy "%PROFILE%\Documents\Outlook Files" "C:\Users\%USER%\Documents\Outlook Files" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [16/20] SSH Keys
robocopy "%PROFILE%\.ssh" "C:\Users\%USER%\.ssh" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [17/20] Sticky Notes
robocopy "%PROFILE%\AppData\Local\Packages" "C:\Users\%USER%\AppData\Local\Packages" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [18/20] Quick Access
robocopy "%PROFILE%\AppData\Roaming\Microsoft\Windows\Recent" "C:\Users\%USER%\AppData\Roaming\Microsoft\Windows\Recent" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [19/20] Minecraft
robocopy "%PROFILE%\AppData\Roaming\.minecraft" "C:\Users\%USER%\AppData\Roaming\.minecraft" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [20/20] Git Config
if exist "%PROFILE%\.gitconfig" copy "%PROFILE%\.gitconfig" "C:\Users\%USER%\" /Y >nul

color 0A
echo.
echo SUCCESS: %USER% restored.
timeout /t 2 >nul

exit /b
