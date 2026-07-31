@echo off
setlocal EnableDelayedExpansion

title UserSync v1.0
color 07
mode con: cols=65 lines=20

:MENU
cls

color 0B
color 0B
echo +-----------------------------------------------------------+
echo ^|                                                           ^|
echo ^|                        UserSync                           ^|
echo ^|              Windows User Profile Backup                  ^|
echo ^|                                                           ^|
echo ^|  - Documents, Desktop, Downloads, Pictures, Videos        ^|
echo ^|  - Browser Profiles, Outlook, AppData, User Settings      ^|
echo ^|  - Supports BitLocker Recovery and Drive-to-Drive Backup  ^|
echo ^|                                                           ^|
echo +-----------------------------------------------------------+
color 07
color 07

color 07
echo.
echo Destination:
echo %USERPROFILE%\Desktop\
echo.
echo ==============================================================
echo.

set /p SOURCE=Source Drive Letter To Copy From (Example D): 
set SOURCE=%SOURCE::=%

echo.
echo Checking drive...

:: Is the drive already accessible?
if exist "%SOURCE%:\Users" goto DRIVEOK

:: Check if the drive appears to be BitLocker encrypted
manage-bde -status %SOURCE%: >"%TEMP%\usersync_bde.txt" 2>nul

findstr /I "BitLocker" "%TEMP%\usersync_bde.txt" >nul
if errorlevel 1 (
    del "%TEMP%\usersync_bde.txt" >nul 2>&1
    goto GENERICERROR
)

del "%TEMP%\usersync_bde.txt" >nul 2>&1

:BITLOCKER
color 0E
echo.
echo +-----------------------------------------------------------+
echo ^|                 BITLOCKER DRIVE DETECTED                  ^|
echo ^|                                                           ^|
echo ^|  This drive appears to be BitLocker encrypted.            ^|
echo ^|                                                           ^|
echo ^|  Enter the 48-digit recovery key below.                   ^|
echo ^|                                                           ^|
echo +-----------------------------------------------------------+
echo.

set /p RECOVERYKEY=Recovery Key:

if "%RECOVERYKEY%"=="" (
    color 0A
    goto MENU
)

echo.
echo Attempting to unlock drive...
manage-bde -unlock %SOURCE%: -RecoveryPassword %RECOVERYKEY%

timeout /t 2 >nul

if exist "%SOURCE%:\Users" (
    color 0A
    echo.
    echo [SUCCESS] Drive unlocked successfully.
    echo.
    goto DRIVEOK
)

color 0C
echo.
echo +-----------------------------------------------------------+
echo ^|                     UNLOCK FAILED                         ^|
echo ^|                                                           ^|
echo ^|  The recovery key was incorrect or the drive could not    ^|
echo ^|  be unlocked.                                             ^|
echo ^|                                                           ^|
echo +-----------------------------------------------------------+
echo.
pause >nul
goto MENU
:DRIVEOK
echo.
echo [OK] Drive is accessible.
echo.

echo.
echo.
echo Where would you like to save the backup?
echo.
echo   [1] Desktop
echo   [2] Another Drive
echo.

choice /C 12 /N /M "Select an option (1-2): "

if errorlevel 2 goto OTHERDRIVE
if errorlevel 1 goto DESKTOP

:DESKTOP
echo.
set /p BACKUPNAME=Create Backup Folder Name:
set "DEST=%USERPROFILE%\Desktop\%BACKUPNAME%"
goto DESTREADY

:OTHERDRIVE
echo.
set /p DESTDRIVE=Destination Drive Letter (Example E):
set "DESTDRIVE=%DESTDRIVE::=%"

if not exist "%DESTDRIVE%:\" (
    color 0C
    echo.
    echo [ERROR] Destination drive not found.
    echo.
    timeout /t 2 >nul
    color 07
    goto MENU
)

echo.
set /p BACKUPNAME=Create Backup Folder Name:
set "DEST=%DESTDRIVE%:\%BACKUPNAME%"

:DESTREADY

cls
echo.
echo ==========================================
echo        INITIALIZING BACKUP...
echo ==========================================
echo.

mkdir "%DEST%" >nul 2>&1

echo Source      : %SOURCE%:\
echo Destination : %DEST%
echo.
timeout /t 2 >nul

for /D %%U in ("%SOURCE%:\Users\*") do (
    call :BackupUser "%%U"
)

color 0B
cls
echo.
echo +-----------------------------------------------------------+
echo ^|                                                           ^|
echo ^|            BACKUP COMPLETED SUCCESSFULLY!                  ^|
echo ^|                                                           ^|
echo +-----------------------------------------------------------+
echo.
echo Files saved to:
echo.
echo %DEST%
echo.
pause
exit

:BackupUser

set "PROFILE=%~1"
set "USER=%~nx1"

if /I "%USER%"=="Public" exit /b
if /I "%USER%"=="Default" exit /b
if /I "%USER%"=="Default User" exit /b
if /I "%USER%"=="All Users" exit /b
if /I "%USER%"=="defaultuser0" exit /b
cls
color 0E
echo.

echo Calculating profile size...

for /f %%A in ('
    powershell -NoProfile -Command ^
    "$size=(Get-ChildItem -LiteralPath '%PROFILE%' -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum; '{0:N2}' -f ($size/1GB)"
') do set "SIZEGB=%%A"

echo ===============================================================
echo Backing Up: %USER%
echo Estimated Profile Size: %SIZEGB% GB
echo ===============================================================
echo [1/10] Desktop
echo [1/41] Desktop
robocopy "%PROFILE%\Desktop" "%DEST%\%USER%\Desktop" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [2/41] Documents
robocopy "%PROFILE%\Documents" "%DEST%\%USER%\Documents" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [3/41] Downloads
robocopy "%PROFILE%\Downloads" "%DEST%\%USER%\Downloads" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [4/41] Pictures
robocopy "%PROFILE%\Pictures" "%DEST%\%USER%\Pictures" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [5/41] Videos
robocopy "%PROFILE%\Videos" "%DEST%\%USER%\Videos" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [6/41] Music
robocopy "%PROFILE%\Music" "%DEST%\%USER%\Music" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [7/41] Favorites
robocopy "%PROFILE%\Favorites" "%DEST%\%USER%\Favorites" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [8/41] Saved Games
robocopy "%PROFILE%\Saved Games" "%DEST%\%USER%\Saved Games" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [9/41] OneDrive
robocopy "%PROFILE%\OneDrive" "%DEST%\%USER%\OneDrive" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [10/41] AppData\Roaming
robocopy "%PROFILE%\AppData\Roaming" "%DEST%\%USER%\AppData\Roaming" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [11/41] Contacts
robocopy "%PROFILE%\Contacts" "%DEST%\%USER%\Contacts" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [12/41] Links
robocopy "%PROFILE%\Links" "%DEST%\%USER%\Links" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [13/41] Searches
robocopy "%PROFILE%\Searches" "%DEST%\%USER%\Searches" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [14/41] Google Chrome
robocopy "%PROFILE%\AppData\Local\Google\Chrome\User Data" "%DEST%\%USER%\AppData\Local\Google\Chrome\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [15/41] Microsoft Edge
robocopy "%PROFILE%\AppData\Local\Microsoft\Edge\User Data" "%DEST%\%USER%\AppData\Local\Microsoft\Edge\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [16/41] Mozilla Firefox
robocopy "%PROFILE%\AppData\Roaming\Mozilla\Firefox" "%DEST%\%USER%\AppData\Roaming\Mozilla\Firefox" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [17/41] Brave Browser
robocopy "%PROFILE%\AppData\Local\BraveSoftware\Brave-Browser\User Data" "%DEST%\%USER%\AppData\Local\BraveSoftware\Brave-Browser\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [18/41] Opera
robocopy "%PROFILE%\AppData\Roaming\Opera Software" "%DEST%\%USER%\AppData\Roaming\Opera Software" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [19/41] Vivaldi
robocopy "%PROFILE%\AppData\Local\Vivaldi\User Data" "%DEST%\%USER%\AppData\Local\Vivaldi\User Data" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [20/41] Outlook Data
robocopy "%PROFILE%\Documents\Outlook Files" "%DEST%\%USER%\Documents\Outlook Files" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul
robocopy "%PROFILE%\AppData\Local\Microsoft\Outlook" "%DEST%\%USER%\AppData\Local\Microsoft\Outlook" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [21/41] Wi-Fi Profiles
if exist "%ProgramData%\Microsoft\Wlansvc" (
    mkdir "%DEST%\%USER%\WiFi" >nul 2>&1
    netsh wlan export profile key=clear folder="%DEST%\%USER%\WiFi" >nul 2>&1
)

echo [22/41] SSH Keys
robocopy "%PROFILE%\.ssh" "%DEST%\%USER%\.ssh" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [23/41] Sticky Notes
robocopy "%PROFILE%\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" "%DEST%\%USER%\AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [24/41] Quick Access
robocopy "%PROFILE%\AppData\Roaming\Microsoft\Windows\Recent" "%DEST%\%USER%\AppData\Roaming\Microsoft\Windows\Recent" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [25/41] Steam Saves
robocopy "%PROFILE%\AppData\Local\Steam" "%DEST%\%USER%\AppData\Local\Steam" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [26/41] Steam Userdata
robocopy "%PROFILE%\AppData\Roaming\Steam" "%DEST%\%USER%\AppData\Roaming\Steam" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [27/41] Discord
robocopy "%PROFILE%\AppData\Roaming\discord" "%DEST%\%USER%\AppData\Roaming\discord" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [28/41] Epic Games
robocopy "%PROFILE%\AppData\Local\EpicGamesLauncher" "%DEST%\%USER%\AppData\Local\EpicGamesLauncher" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [29/41] Battle.net
robocopy "%PROFILE%\AppData\Roaming\Battle.net" "%DEST%\%USER%\AppData\Roaming\Battle.net" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [30/41] Ubisoft Connect
robocopy "%PROFILE%\AppData\Local\Ubisoft Game Launcher" "%DEST%\%USER%\AppData\Local\Ubisoft Game Launcher" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [31/41] EA App
robocopy "%PROFILE%\AppData\Local\Electronic Arts" "%DEST%\%USER%\AppData\Local\Electronic Arts" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [32/41] OBS Studio
robocopy "%PROFILE%\AppData\Roaming\obs-studio" "%DEST%\%USER%\AppData\Roaming\obs-studio" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [33/41] Teams
robocopy "%PROFILE%\AppData\Roaming\Microsoft\Teams" "%DEST%\%USER%\AppData\Roaming\Microsoft\Teams" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [34/41] Zoom
robocopy "%PROFILE%\AppData\Roaming\Zoom" "%DEST%\%USER%\AppData\Roaming\Zoom" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [35/41] Dropbox
robocopy "%PROFILE%\AppData\Roaming\Dropbox" "%DEST%\%USER%\AppData\Roaming\Dropbox" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [36/41] Google Drive
robocopy "%PROFILE%\AppData\Local\Google\DriveFS" "%DEST%\%USER%\AppData\Local\Google\DriveFS" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [37/41] Thunderbird
robocopy "%PROFILE%\AppData\Roaming\Thunderbird" "%DEST%\%USER%\AppData\Roaming\Thunderbird" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [38/41] FileZilla
robocopy "%PROFILE%\AppData\Roaming\FileZilla" "%DEST%\%USER%\AppData\Roaming\FileZilla" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [39/41] Windows Themes
robocopy "%PROFILE%\AppData\Local\Microsoft\Windows\Themes" "%DEST%\%USER%\AppData\Local\Microsoft\Windows\Themes" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [40/41] Startup Folder
robocopy "%PROFILE%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" "%DEST%\%USER%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul

echo [41/41] Git Config
if exist "%PROFILE%\.gitconfig" copy "%PROFILE%\.gitconfig" "%DEST%\%USER%\" /Y >nul

if exist "%PROFILE%\.gitconfig" copy "%PROFILE%\.gitconfig" "%DEST%\%USER%\" >nul

robocopy "%PROFILE%\AppData\Roaming\.minecraft" "%DEST%\%USER%\AppData\Roaming\.minecraft" /E /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul
color 0A
echo.
echo [SUCCESS] %USER% Backup Complete.
echo.
echo.
echo Backup completed successfully.
echo.
echo You may now close this window.
pause >nul
