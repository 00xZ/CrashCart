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

echo [1/41] Desktop
robocopy "%PROFILE%\Desktop" "C:\Users\%USER%\Desktop" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [2/41] Documents
robocopy "%PROFILE%\Documents" "C:\Users\%USER%\Documents" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [3/41] Downloads
robocopy "%PROFILE%\Downloads" "C:\Users\%USER%\Downloads" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [4/41] Pictures
robocopy "%PROFILE%\Pictures" "C:\Users\%USER%\Pictures" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [5/41] Videos
robocopy "%PROFILE%\Videos" "C:\Users\%USER%\Videos" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [6/41] Music
robocopy "%PROFILE%\Music" "C:\Users\%USER%\Music" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [7/41] Favorites
robocopy "%PROFILE%\Favorites" "C:\Users\%USER%\Favorites" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [8/41] Saved Games
robocopy "%PROFILE%\Saved Games" "C:\Users\%USER%\Saved Games" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [9/41] OneDrive
robocopy "%PROFILE%\OneDrive" "C:\Users\%USER%\OneDrive" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [10/41] AppData\Roaming
robocopy "%PROFILE%\AppData\Roaming" "C:\Users\%USER%\AppData\Roaming" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [11/41] Contacts
robocopy "%PROFILE%\Contacts" "C:\Users\%USER%\Contacts" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [12/41] Links
robocopy "%PROFILE%\Links" "C:\Users\%USER%\Links" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [13/41] Searches
robocopy "%PROFILE%\Searches" "C:\Users\%USER%\Searches" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [14/41] Google Chrome
robocopy "%PROFILE%\AppData\Local\Google\Chrome\User Data" "C:\Users\%USER%\AppData\Local\Google\Chrome\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [15/41] Microsoft Edge
robocopy "%PROFILE%\AppData\Local\Microsoft\Edge\User Data" "C:\Users\%USER%\AppData\Local\Microsoft\Edge\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [16/41] Mozilla Firefox
robocopy "%PROFILE%\AppData\Roaming\Mozilla\Firefox" "C:\Users\%USER%\AppData\Roaming\Mozilla\Firefox" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [17/41] Brave Browser
robocopy "%PROFILE%\AppData\Local\BraveSoftware\Brave-Browser\User Data" "C:\Users\%USER%\AppData\Local\BraveSoftware\Brave-Browser\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [18/41] Opera
robocopy "%PROFILE%\AppData\Roaming\Opera Software" "C:\Users\%USER%\AppData\Roaming\Opera Software" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [19/41] Vivaldi
robocopy "%PROFILE%\AppData\Local\Vivaldi\User Data" "C:\Users\%USER%\AppData\Local\Vivaldi\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [20/41] Outlook Data
robocopy "%PROFILE%\Documents\Outlook Files" "C:\Users\%USER%\Documents\Outlook Files" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul
robocopy "%PROFILE%\AppData\Local\Microsoft\Outlook" "C:\Users\%USER%\AppData\Local\Microsoft\Outlook" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [21/41] Wi-Fi Profiles
if exist "%PROFILE%\WiFi" (
    netsh wlan add profile filename="%PROFILE%\WiFi\*.xml" user=all >nul 2>&1
)

echo [22/41] SSH Keys
robocopy "%PROFILE%\.ssh" "C:\Users\%USER%\.ssh" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [23/41] Sticky Notes
robocopy "%PROFILE%\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" "C:\Users\%USER%\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [24/41] Quick Access
robocopy "%PROFILE%\AppData\Roaming\Microsoft\Windows\Recent" "C:\Users\%USER%\AppData\Roaming\Microsoft\Windows\Recent" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [25/41] Steam Saves
robocopy "%PROFILE%\AppData\Local\Steam" "C:\Users\%USER%\AppData\Local\Steam" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [26/41] Steam Userdata
robocopy "%PROFILE%\AppData\Roaming\Steam" "C:\Users\%USER%\AppData\Roaming\Steam" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [27/41] Discord
robocopy "%PROFILE%\AppData\Roaming\discord" "C:\Users\%USER%\AppData\Roaming\discord" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [28/41] Epic Games
robocopy "%PROFILE%\AppData\Local\EpicGamesLauncher" "C:\Users\%USER%\AppData\Local\EpicGamesLauncher" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [29/41] Battle.net
robocopy "%PROFILE%\AppData\Roaming\Battle.net" "C:\Users\%USER%\AppData\Roaming\Battle.net" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [30/41] Ubisoft Connect
robocopy "%PROFILE%\AppData\Local\Ubisoft Game Launcher" "C:\Users\%USER%\AppData\Local\Ubisoft Game Launcher" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [31/41] EA App
robocopy "%PROFILE%\AppData\Local\Electronic Arts" "C:\Users\%USER%\AppData\Local\Electronic Arts" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [32/41] OBS Studio
robocopy "%PROFILE%\AppData\Roaming\obs-studio" "C:\Users\%USER%\AppData\Roaming\obs-studio" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [33/41] Teams
robocopy "%PROFILE%\AppData\Roaming\Microsoft\Teams" "C:\Users\%USER%\AppData\Roaming\Microsoft\Teams" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [34/41] Zoom
robocopy "%PROFILE%\AppData\Roaming\Zoom" "C:\Users\%USER%\AppData\Roaming\Zoom" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [35/41] Dropbox
robocopy "%PROFILE%\AppData\Roaming\Dropbox" "C:\Users\%USER%\AppData\Roaming\Dropbox" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [36/41] Google Drive
robocopy "%PROFILE%\AppData\Local\Google\DriveFS" "C:\Users\%USER%\AppData\Local\Google\DriveFS" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [37/41] Thunderbird
robocopy "%PROFILE%\AppData\Roaming\Thunderbird" "C:\Users\%USER%\AppData\Roaming\Thunderbird" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [38/41] FileZilla
robocopy "%PROFILE%\AppData\Roaming\FileZilla" "C:\Users\%USER%\AppData\Roaming\FileZilla" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [39/41] Windows Themes
robocopy "%PROFILE%\AppData\Local\Microsoft\Windows\Themes" "C:\Users\%USER%\AppData\Local\Microsoft\Windows\Themes" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [40/41] Startup Folder
robocopy "%PROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" "C:\Users\%USER%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [41/41] Git Config
if exist "%PROFILE%\.gitconfig" copy "%PROFILE%\.gitconfig" "C:\Users\%USER%\" /Y >nul

color 0A
echo.
echo SUCCESS: %USER% restored.
timeout /t 2 >nul

exit /b
