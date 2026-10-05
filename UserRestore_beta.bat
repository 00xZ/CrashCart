@echo off
setlocal EnableDelayedExpansion

title ----- UserRestore -----
color 0B

net session >nul 2>&1
if errorlevel 1 (
    echo Please right-click this file and choose "Run as administrator".
    pause
    exit /b
)

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
    set "FOLDER!COUNT!=%%~fD"
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
cls
set /p DRIVE=Backup Drive Letter (Example E): 
set DRIVE=%DRIVE::=%
set DRIVE=%DRIVE:~0,1%

if not exist "%DRIVE%:\" (
    echo.
    echo Drive not found.
    pause
    goto MENU
)

REM If the old drive has a Users folder, use it directly
if exist "%DRIVE%:\Users\" (
    set "BACKUP=%DRIVE%:\Users"
    echo.
    echo Found %DRIVE%:\Users - using it.
    timeout /t 2 >nul
    goto CHECK
)

echo.
echo Folders on %DRIVE%: (system folders hidden)
echo.
set COUNT=0
for /d %%D in ("%DRIVE%:\*") do (
    set "N=%%~nxD"
    set SKIP=0
    for %%S in ("Windows" "Program Files" "Program Files (x86)" "ProgramData" "$Recycle.Bin" "System Volume Information" "Recovery" "PerfLogs" "Config.Msi" "Documents and Settings") do (
        if /I "!N!"=="%%~S" set SKIP=1
    )
    if "!SKIP!"=="0" (
        set /a COUNT+=1
        set "FOLDER!COUNT!=%%~fD"
        echo !COUNT!. %%~nxD
    )
)
if %COUNT%==0 (
    echo No usable folders found.
    pause
    goto MENU
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
echo Each folder inside it will be treated as a user profile.
echo.
pause

cls
echo.
echo Restore mode:
echo.
echo   [1] Full       (move EVERYTHING back to C:)
echo   [2] Selective  (documents, browsers, app data, etc. - copies only)
echo.
choice /C 12 /N /M "Select a mode (1-2): "
if errorlevel 2 (set RMODE=SELECTIVE) else (set RMODE=FULL)

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
echo Anything that could not be moved is listed in restore_log.txt
echo on your Desktop (Full mode). You may now restart Windows.
echo.
pause
exit /b

:RESTORE
set "PROFILE=%~1"
set "USER=%~nx1"

if /I "%USER%"=="Public" exit /b
if /I "%USER%"=="Default" exit /b
if /I "%USER%"=="Default User" exit /b
if /I "%USER%"=="All Users" exit /b
if /I "%USER%"=="defaultuser0" exit /b

cls
color 0E
echo ===============================================
echo Restoring %USER%  (%RMODE%)
echo ===============================================
echo.

if not exist "C:\Users\%USER%" (
    echo Creating C:\Users\%USER%
    mkdir "C:\Users\%USER%" >nul
)

if /I "%RMODE%"=="FULL" goto FULLRESTORE

REM ---------------- SELECTIVE ----------------
set N=0
for %%P in (
    "Desktop" "Documents" "Downloads" "Pictures" "Videos" "Music"
    "Favorites" "Saved Games" "OneDrive" "Contacts" "Links" "Searches"
    ".ssh" "AppData\Roaming"
    "AppData\Local\Google\Chrome\User Data"
    "AppData\Local\Microsoft\Edge\User Data"
    "AppData\Local\BraveSoftware\Brave-Browser\User Data"
    "AppData\Local\Vivaldi\User Data"
    "AppData\Local\Microsoft\Outlook"
    "AppData\Local\Packages\Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe"
    "AppData\Local\Steam"
    "AppData\Local\EpicGamesLauncher"
    "AppData\Local\Ubisoft Game Launcher"
    "AppData\Local\Electronic Arts"
    "AppData\Local\Google\DriveFS"
    "AppData\Local\Microsoft\Windows\Themes"
) do (
    set /a N+=1
    if exist "%PROFILE%\%%~P\" (
        echo [!N!] %%~P
        robocopy "%PROFILE%\%%~P" "C:\Users\%USER%\%%~P" /E /B /R:1 /W:1 /NFL /NDL /NJH /NJS /XJ >nul
    )
)

if exist "%PROFILE%\WiFi" netsh wlan add profile filename="%PROFILE%\WiFi\*.xml" user=all >nul 2>&1
if exist "%PROFILE%\.gitconfig" copy "%PROFILE%\.gitconfig" "C:\Users\%USER%\" /Y >nul

color 0A
echo.
echo SUCCESS: %USER% restored.
timeout /t 2 >nul
exit /b

REM ---------------- FULL ----------------
:FULLRESTORE
echo Moving everything for %USER% ...
echo.
robocopy "%PROFILE%" "C:\Users\%USER%" /E /MOVE /B /COPY:DAT /DCOPY:DAT /XJ /XO /R:1 /W:1 /MT:16 /NP /NFL /NDL /NJH ^
  /XF NTUSER.DAT* ntuser.ini UsrClass.dat* *.LOG1 *.LOG2 *.blf *.regtrans-ms ^
  /XD "%PROFILE%\AppData\Local\Temp" "$RECYCLE.BIN" "System Volume Information" ^
  /LOG+:"%USERPROFILE%\Desktop\restore_log.txt" >nul
if errorlevel 8 (
    color 0C
    echo WARNING: some files could not be moved. See restore_log.txt on the Desktop.
    timeout /t 5 >nul
) else (
    color 0A
    echo SUCCESS: %USER% moved.
    timeout /t 2 >nul
)
exit /b
