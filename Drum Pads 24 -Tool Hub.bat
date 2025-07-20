@echo off
title Drum Pads 24 - Advanced Tools
color 0B

:: --- CONFIGURATION SECTION ---
:: IMPORTANT: Customize these paths to match your system setup!
set "EMULATOR_PATH_1=C:\Program Files\BlueStacks_nxt\HD-Player.exe"
set "EMULATOR_NAME_1=BlueStacks"

set "EMULATOR_PATH_2=C:\Program Files\Nox\bin\Nox.exe"
set "EMULATOR_NAME_2=NoxPlayer"

set "ADB_PATH=C:\platform-tools\adb.exe" :: Path to your ADB executable (download Android SDK Platform-Tools)

set "EMULATOR_DATA_FOLDER_1=C:\Users\%USERNAME%\Documents\BlueStacks" :: Example for BlueStacks shared folder
set "EMULATOR_DATA_FOLDER_2=C:\Users\%USERNAME%\Nox_share" :: Example for NoxPlayer shared folder (adjust as needed)

set "RECORDED_SOUNDS_FOLDER=C:\Users\%USERNAME%\Desktop\DrumPads24_Recordings" :: Where you might save recordings

:: --- END CONFIGURATION SECTION ---

:: Ensure recorded sounds folder exists
if not exist "%RECORDED_SOUNDS_FOLDER%" (
    mkdir "%RECORDED_SOUNDS_FOLDER%"
    echo Created recording folder: "%RECORDED_SOUNDS_FOLDER%"
    timeout /t 2 /nobreak >nul
)

:menu
cls
echo.
echo ===========================================
echo   Drum Pads 24 - Advanced Tool Hub
echo ===========================================
echo.
echo   [1] Launch %EMULATOR_NAME_1%
echo   [2] Launch %EMULATOR_NAME_2%
echo   [3] Open %EMULATOR_NAME_1% Data Folder
echo   [4] Open %EMULATOR_NAME_2% Data Folder
echo   [5] Open Recorded Sounds Folder
echo.
echo   [A] ADB: Check Devices
echo   [B] ADB: Install Drum Pads 24 APK (Requires APK in same folder)
echo   [C] ADB: Pull Emulator/Device Screenshots (from default Android path)
echo   [D] ADB: Shell Access
echo.
echo   [W] Open Drum Pads 24 Website
echo   [Y] Open Drum Pads 24 YouTube Channel
echo.
echo   [S] Show Configuration Paths
echo   [E] Exit
echo.
set /p choice="Enter your choice: "

if /i "%choice%"=="1" goto launch_emulator1
if /i "%choice%"=="2" goto launch_emulator2
if /i "%choice%"=="3" goto open_data_folder1
if /i "%choice%"=="4" goto open_data_folder2
if /i "%choice%"=="5" goto open_recorded_sounds
if /i "%choice%"=="A" goto adb_devices
if /i "%choice%"=="B" goto adb_install_apk
if /i "%choice%"=="C" goto adb_pull_screenshots
if /i "%choice%"=="D" goto adb_shell
if /i "%choice%"=="W" goto open_website
if /i "%choice%"=="Y" goto open_youtube
if /i "%choice%"=="S" goto show_config
if /i "%choice%"=="E" goto :EOF
goto invalid_choice

:launch_emulator1
if exist "%EMULATOR_PATH_1%" (
    echo Launching %EMULATOR_NAME_1%...
    start "" "%EMULATOR_PATH_1%"
) else (
    echo Error: %EMULATOR_NAME_1% path not found: "%EMULATOR_PATH_1%"
)
pause
goto menu

:launch_emulator2
if exist "%EMULATOR_PATH_2%" (
    echo Launching %EMULATOR_NAME_2%...
    start "" "%EMULATOR_PATH_2%"
) else (
    echo Error: %EMULATOR_NAME_2% path not found: "%EMULATOR_PATH_2%"
)
pause
goto menu

:open_data_folder1
if exist "%EMULATOR_DATA_FOLDER_1%" (
    echo Opening %EMULATOR_NAME_1% data folder...
    start "" "%EMULATOR_DATA_FOLDER_1%"
) else (
    echo Error: %EMULATOR_NAME_1% data folder path not found: "%EMULATOR_DATA_FOLDER_1%"
    echo Please configure it in the batch file.
)
pause
goto menu

:open_data_folder2
if exist "%EMULATOR_DATA_FOLDER_2%" (
    echo Opening %EMULATOR_NAME_2% data folder...
    start "" "%EMULATOR_DATA_FOLDER_2%"
) else (
    echo Error: %EMULATOR_NAME_2% data folder path not found: "%EMULATOR_DATA_FOLDER_2%"
    echo Please configure it in the batch file.
)
pause
goto menu

:open_recorded_sounds
echo Opening recorded sounds folder...
start "" "%RECORDED_SOUNDS_FOLDER%"
pause
goto menu

:check_adb
if not exist "%ADB_PATH%" (
    echo.
    echo ERROR: ADB not found at "%ADB_PATH%"
    echo Please download Android SDK Platform-Tools and update the ADB_PATH variable.
    echo You can download it from: https://developer.android.com/tools/releases/platform-tools
    echo Extract it and set ADB_PATH to the 'platform-tools\adb.exe' location.
    pause
    goto menu
)
goto :EOF

:adb_devices
call :check_adb
if errorlevel 1 goto menu
echo.
echo Running ADB devices...
"%ADB_PATH%" devices
echo.
echo (Ensure your emulator/device is running and ADB debugging is enabled)
pause
goto menu

:adb_install_apk
call :check_adb
if errorlevel 1 goto menu
echo.
set /p "apk_name=Enter the full name of the Drum Pads 24 APK file (e.g., DrumPads24.apk): "
if not exist "%~dp0%apk_name%" (
    echo ERROR: APK file "%apk_name%" not found in the same directory as this batch file.
    pause
    goto menu
)
echo Installing "%apk_name%"...
"%ADB_PATH%" install "%~dp0%apk_name%"
echo.
echo (Make sure only one device/emulator is connected or specify target with -s <device_id>)
pause
goto menu

:adb_pull_screenshots
call :check_adb
if errorlevel 1 goto menu
echo.
echo Pulling screenshots from /sdcard/DCIM/Screenshots/ or /sdcard/Pictures/Screenshots/
echo to "%RECORDED_SOUNDS_FOLDER%"...
echo.
:: Try common screenshot paths
"%ADB_PATH%" pull /sdcard/DCIM/Screenshots/ "%RECORDED_SOUNDS_FOLDER%"
"%ADB_PATH%" pull /sdcard/Pictures/Screenshots/ "%RECORDED_SOUNDS_FOLDER%"
echo.
echo Screenshot pulling complete. Check "%RECORDED_SOUNDS_FOLDER%"
pause
goto menu

:adb_shell
call :check_adb
if errorlevel 1 goto menu
echo.
echo Entering ADB Shell. Type 'exit' to return to this menu.
echo.
"%ADB_PATH%" shell
echo.
echo Exited ADB Shell.
pause
goto menu

:open_website
echo Opening Drum Pads 24 Website...
start "" "https://drumpads24.com/"
goto menu

:open_youtube
echo Opening Drum Pads 24 YouTube Channel...
start "" "https://www.youtube.com/c/DrumPads24"
goto menu

:show_config
cls
echo ===========================================
echo   Current Configuration Paths
echo ===========================================
echo.
echo EMULATOR_PATH_1: "%EMULATOR_PATH_1%"
echo EMULATOR_NAME_1: "%EMULATOR_NAME_1%"
echo EMULATOR_PATH_2: "%EMULATOR_PATH_2%"
echo EMULATOR_NAME_2: "%EMULATOR_NAME_2%"
echo ADB_PATH:          "%ADB_PATH%"
echo EMULATOR_DATA_FOLDER_1: "%EMULATOR_DATA_FOLDER_1%"
echo EMULATOR_DATA_FOLDER_2: "%EMULATOR_DATA_FOLDER_2%"
echo RECORDED_SOUNDS_FOLDER: "%RECORDED_SOUNDS_FOLDER%"
echo.
echo Make sure these paths are correct for your system.
echo Edit the .bat file in a text editor to change them.
pause
goto menu

:invalid_choice
echo Invalid choice. Please try again.
pause
goto menu