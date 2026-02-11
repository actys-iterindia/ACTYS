@echo off
setlocal enabledelayedexpansion

echo =======================================
echo     ACTYS Windows Global Setup
echo =======================================

:: 1.1 Check Registry for existing ACTYS_HOME
set "REG_PATH="
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v ACTYS_HOME 2^>nul') do set "REG_PATH=%%B"

if not defined REG_PATH (
    echo [INFO] ACTYS_HOME is not currently set.
    goto :PROMPT_USER
)

powershell -Command "Write-Host '[INFO] Current Registry ACTYS_HOME: %REG_PATH% ' -ForegroundColor magenta"
set /p "KEEP=Do you want to keep this path? (Y/N): "
if /I "%KEEP%"=="Y" (
    set "ACTYS_HOME_FINAL=%REG_PATH%"
    goto :APPLY_PATH
)

:: 1.2 set new if user wants
reg delete "HKCU\Environment" /v ACTYS_HOME /f >nul
powershell -command "$o=[Environment]::GetEnvironmentVariable('Path','User'); $n=(($o.Split(';')|Where-Object{$_ -notlike '*ACTYS*'}) -join ';'); [Environment]::SetEnvironmentVariable('Path',$n,'User')"

:PROMPT_USER
echo.
powershell -Command "Write-Host 'Enter ACTYS folder path (Default: %USERPROFILE%\ACTYS)' -ForegroundColor green"
set /p "USER_PATH=: "
if "%USER_PATH%"=="" set "USER_PATH=%USERPROFILE%\ACTYS"
set "ACTYS_HOME_FINAL=%USER_PATH%"

:: 1.3 Save to Registry
setx ACTYS_HOME "%ACTYS_HOME_FINAL%" >nul
goto :CONTINUE_SETUP

:APPLY_PATH
:: Update the User PATH permanently
powershell -command "$o=[Environment]::GetEnvironmentVariable('Path','User'); if($o -notlike '*%ACTYS_HOME_FINAL%*'){$n=$o+';'+'%ACTYS_HOME_FINAL%'; [Environment]::SetEnvironmentVariable('Path',$n,'User')}"

:: 1.4 Verification (Force local update so this window can see it)
set "PATH=%PATH%;%ACTYS_HOME_FINAL%"
set "ACTYS_HOME=%ACTYS_HOME_FINAL%"

echo.
echo ===========================================
echo    ACTYS Executable Path Verification
echo ===========================================

if exist "%ACTYS_HOME_FINAL%\actyswindows.exe" (
    powershell -Command "Write-Host '[OK] Found actyswindows.exe in %ACTYS_HOME_FINAL%' -ForegroundColor green"
    powershell -Command "Write-Host '[OK] Global command 'actyswindows.exe' is now configured.' -ForegroundColor green"
) else (
    powershell -Command "Write-Host '[ERROR] Could not find actyswindows.exe inside:' -ForegroundColor red"
    echo %ACTYS_HOME_FINAL%
    powershell -Command "Write-Host 'Please move the EXE to %ACTYS_HOME% folder.' -ForegroundColor magenta"
)
goto :CONTINUE_SETUP

:CONTINUE_SETUP
:: 2 set directories
set "EXE_NAME=actyswindows.exe"
set "DATA_ROOT=%ACTYS_HOME%\Data"
set "TARGET_DIR=%DATA_ROOT%\EAF2010"
set "ARCHIVE_NAME=EAF2010data.tar.bz2"
set "ARCHIVE_PATH=%DATA_ROOT%\%ARCHIVE_NAME%"
set "SUB_FOLDER=%TARGET_DIR%\EAF2010data"

:: 2.1 Set Environment Variable
setx ACTYS_HOME "%ACTYS_HOME%" >nul
powershell -Command "Write-Host ' ACTYS_HOME path is: %ACTYS_HOME%' -ForegroundColor green"
:: Adding ACTYS folder to the User's PATH so you can run the exe from anywhere
:: We check if it's already in the path first to avoid duplicates
echo %PATH% | findstr /I /C:"%ACTYS_HOME%" >nul
if %errorlevel% NEQ 0 (
    echo Adding ACTYS to PATH...
    setx PATH "%PATH%;%ACTYS_HOME%" >nul
    powershell -Command "Write-Host ' [SUCCESS] PATH updated. Note: You may need to restart your terminal to see changes.' -ForegroundColor green"
) else (
    powershell -Command "Write-Host ' ACTYS is already in your PATH.' -ForegroundColor magenta"
)


:: 2.2 Setup Directories
if not exist "%DATA_ROOT%" mkdir "%DATA_ROOT%"
if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%"

echo Step 1: Checking for data archives...

:: 2.3 Archive Check
if exist "%ARCHIVE_PATH%" goto :EXTRACT_START

powershell -Command "Write-Host ' [Error!] %ARCHIVE_NAME% not found in %DATA_ROOT%.' -ForegroundColor red"
start "" "https://git.oecd-nea.org/fispact/nuclear_data/-/raw/main/EAF2010data.tar.bz2?inline=false"
start "" "https://git.oecd-nea.org/fispact/nuclear_data/-/raw/main/ebins.tar.bz2?inline=false"
powershell -Command "Write-Host ' Please check your downloads and copy %ARCHIVE_NAME% and ebins.tar.bz2 to:' -ForegroundColor magenta"
echo %DATA_ROOT%
pause
goto :EXTRACT_START
:: exit /b


:EXTRACT_START
:: 3.1 extract the tar files
echo %ARCHIVE_NAME% found.
set "EXTRACT_SUCCESS=0"

:: Try TAR first
tar --version >nul 2>&1
if !errorlevel! NEQ 0 goto :TRY_7ZIP

echo Using tar to extract...
tar -xjf "%ARCHIVE_PATH%" -C "%TARGET_DIR%"
if !errorlevel! EQU 0 set "EXTRACT_SUCCESS=1"
goto :MOVE_FILES


:TRY_7ZIP
:: 3.2  check if 7zip exists
if not exist "C:\Program Files\7-Zip\7z.exe" goto :NO_TOOLS
echo Using 7-Zip to extract...
"C:\Program Files\7-Zip\7z.exe" x "%ARCHIVE_PATH%" -so | "C:\Program Files\7-Zip\7z.exe" x -si -ttar -o"%TARGET_DIR%" -aoa >nul
if !errorlevel! EQU 0 set "EXTRACT_SUCCESS=1"
goto :MOVE_FILES


:NO_TOOLS
:: 3.3  checking unzip tools
powershell -Command "Write-Host ' [Error!] No automated extraction tool found (tar or 7-Zip).' -ForegroundColor red"
start "" "https://www.7-zip.org/"
powershell -Command "Write-Host ' 7-zip is downloaded to default download location. Install 7-zip first.' -ForegroundColor magenta" 
pause
:: exit /b


:MOVE_FILES
:: 4.1 check files and folders
:: Logic to handle the EAF2010data subfolder if it exists
if not exist "%SUB_FOLDER%" goto :RENAME_PHASE

echo.
echo Moving files from %SUB_FOLDER% to %TARGET_DIR%...
:: Overwrite existing and move 'fus' files
xcopy "%SUB_FOLDER%\*fus*" "%TARGET_DIR%\" /Y /Q >nul
:: pause to ensure file handles are released by Windows
timeout /t 2 /nobreak >nul
rd /s /q "%SUB_FOLDER%"


:RENAME_PHASE
:: 4.2 Renaming Logic
echo.
echo Step 2: Renaming files (converting *20100 to *2010)...
:: Ensure we are in the correct directory
pushd "%TARGET_DIR%"

for %%f in (*fus*20100) do (
    set "oldname=%%f"
    set "newname=!oldname:~0,-1!"
    
    if exist "!newname!" del /f /q "!newname!"
    echo Renaming: !oldname! --^> !newname!
    ren "!oldname!" "!newname!"
)
popd

:EBINS
:: 5.1 Handle ebins
if not exist "%DATA_ROOT%\ebins.tar.bz2" goto :TEST_RUN
echo.
echo Extracting ebins...
tar -xjf "%DATA_ROOT%\ebins.tar.bz2" -C "%DATA_ROOT%" >nul 2>&1
:: del /f /q "%DATA_ROOT%\ebins.tar.bz2"

:TEST_RUN
:: 6.1 Example Run
echo.
echo Step 3: Running test...
if not exist "%ACTYS_HOME%\run" mkdir "%ACTYS_HOME%\run"
if not exist "%ACTYS_HOME%\examples_windows\CrW" goto :FINISH

copy /Y "%ACTYS_HOME%\examples_windows\CrW" "%ACTYS_HOME%\run\CrW" >nul
copy /Y "%ACTYS_HOME%\examples_windows\EU-FW" "%ACTYS_HOME%\run\EU-FW" >nul
powershell -Command "$c = Get-Content '%ACTYS_HOME%\run\CrW'; $c[1] = '%ACTYS_HOME%\Data'; $c | Set-Content '%ACTYS_HOME%\run\CrW'"

cd /d "%ACTYS_HOME%\run"
set "INPUT_FILE=%ACTYS_HOME%\run\CrW"
set "NEW_FLUX_PATH=FLUX_FILE %ACTYS_HOME%\run\EU-FW"

if not exist "%INPUT_FILE%" (
    echo [ERROR] Input file %INPUT_FILE% not found.
    goto :FINISH
)

:: 6.2 License Verification
echo.
echo Step 1: Verifying System License...

:: Get MAC Address and format it with hyphens (e.g., 08-00-27-F2-B4-D1)
for /f "tokens=3 delims=," %%a in ('getmac /v /fo csv /nh ^| findstr /i "Ethernet Local"') do (
    set "MAC=%%~a"
    set "MAC=!MAC::=-!"
)

if not defined MAC (
    powershell -Command "Write-Host ' [ERROR] Could not detect System MAC Address.' -ForegroundColor red"
    pause
    exit /b
)

set "LICENSE_NAME=actys_license_!MAC!"
set "LICENSE_PATH=%DATA_ROOT%\!LICENSE_NAME!"

if exist "!LICENSE_PATH!" (
    powershell -Command "Write-Host '[OK] Valid license found: !LICENSE_NAME!' -ForegroundColor Green"
) else (
    echo.
    powershell -Command "Write-Host '[Error!] License file NOT found for MAC: !MAC!' -ForegroundColor Red"
    echo Looking for: !LICENSE_NAME! in %DATA_ROOT%
    echo.
    
    :: Instructional text in Cyan (readable Blue)
    powershell -Command "Write-Host 'Please provide full path to the license file. For Example:' -ForegroundColor Cyan"
    powershell -Command "Write-Host '%USERPROFILE%\Downloads\!LICENSE_NAME!' -ForegroundColor Cyan"
    echo.

    set /p "SOURCE_LICENSE=: "
    
    if not exist "!SOURCE_LICENSE!" (
        powershell -Command "Write-Host '[ERROR!] Provided license file does not exist.' -ForegroundColor Red"
        powershell -Command "Write-Host 'Please contact actys@iterindia.in to obtain actys license for macid !MAC!' -ForegroundColor Red"
        pause
        exit /b
    )

    :: Copy and rename to ensure it matches the required format
    copy /Y "!SOURCE_LICENSE!" "!LICENSE_PATH!" >nul
    powershell -Command "Write-Host '[SUCCESS] License copied to %DATA_ROOT%' -ForegroundColor Green"
)



:: replace Data folder and flux file path as per the current user settings
:: Line 2 (Index 1) -> %DATA_ROOT%
:: Line 18 (Index 17) -> %ACTYS_HOME%\run\EU-FW
powershell -Command ^
    "$lines = Get-Content '%INPUT_FILE%';" ^
    "$lines[1] = '%DATA_ROOT%';" ^
    "$lines[17] = '%NEW_FLUX_PATH%';" ^
    "$lines | Set-Content '%INPUT_FILE%'"

echo Paths updated in %INPUT_FILE% successfully.
if exist "..\%EXE_NAME%" (
    echo CrW | "..\%EXE_NAME%"
)

:FINISH
echo.
echo ===========================================
echo Setup Finished.
echo ===========================================
pause