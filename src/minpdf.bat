@echo off
setlocal enabledelayedexpansion
echo.
echo   *** minPDF by Max Haase ***
echo.
set "GRAYSCALE=0"
set "QUALITY=75"
set "OUTPUT_NAME="
set "FILES="
:parse
if "%~1"=="" goto done
set "a=%~1"
if /I "%a%"=="-g" set "GRAYSCALE=1" & shift & goto parse
if /I "%a%"=="-h" goto usage
if /I "%a%"=="-q" set "QUALITY=%~2" & shift & shift & goto parse
if /I "%a%"=="-o" set "OUTPUT_NAME=%~2" & shift & shift & goto parse
if not "%a:~0,1%"=="-" set "FILES=!FILES! "%~1"" & shift & goto parse
echo Unknown option: %a%
goto usage
:done
if "%FILES%"=="" goto usage
set "GS="
set "PDFUNITE="
if exist "%~dp0bin\gswin64c.exe" set "GS=%~dp0bin\gswin64c.exe"
if exist "%~dp0bin\pdfunite.exe" set "PDFUNITE=%~dp0bin\pdfunite.exe"
if "%GS%"=="" ( where gswin64c.exe >nul 2>&1 && set "GS=gswin64c.exe" )
if "%PDFUNITE%"=="" ( where pdfunite.exe >nul 2>&1 && set "PDFUNITE=pdfunite.exe" )
if "%GS%"=="" ( echo Ghostscript not found. Place gswin64c.exe in bin\ & exit /b 1 )
if "%PDFUNITE%"=="" ( echo pdfunite not found. Place pdfunite.exe in bin\ & exit /b 1 )
set /a CRES=72 + (%QUALITY% * 228 / 100)
set /a JQ=10 + (%QUALITY% * 90 / 100)
if "%OUTPUT_NAME%"=="" (
    for %%F in (!FILES!) do ( set "FIRST=%%~nF" & goto gotfirst )
    :gotfirst
    for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set dt=%%I
    set "OUTPUT_NAME=!FIRST!_!dt:~0,8!_!dt:~8,6!.pdf"
)
set "MERGED="
echo !FILES! | findstr /C:" " >nul
if !errorlevel! equ 0 (
    set "TMP=%TEMP%\minpdf_%RANDOM%"
    mkdir "!TMP!"
    set "MERGED=!TMP!\merged.pdf"
    "%PDFUNITE%" !FILES! "!MERGED!"
    if !errorlevel! neq 0 ( echo pdfunite failed & rd /s /q "!TMP!" & exit /b 1 )
) else (
    for %%F in (!FILES!) do set "MERGED=%%~fF"
)
echo Compressing: !MERGED! -^> %OUTPUT_NAME%
"%GS%" -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dBATCH ^
 -dDetectDuplicateImages=true -dCompressFonts=true -dSubsetFonts=true ^
 -dDownsampleColorImages=true -dColorImageDownsampleType=/Bicubic ^
 -dColorImageResolution=%CRES% -dJPEGQ=%JQ% ^
 -sOutputFile="%OUTPUT_NAME%" "!MERGED!"
if defined TMP rd /s /q "!TMP!" 2>nul
echo Done: %OUTPUT_NAME%
exit /b 0
:usage
echo Usage: minpdf [-g] [-q 10-90] [-o OUT.pdf] FILE...
exit /b 1
