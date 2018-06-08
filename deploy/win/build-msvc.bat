@echo on
setlocal


:: setup compil env
set VC_DIR="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
:: find the varsall parameters
if "%PLATFORM%" == "msvc2017_64" set VC_VARSALL=amd64
if "%PLATFORM%" == "winrt_x64_msvc2017" set VC_VARSALL=amd64_x86
if "%PLATFORM%" == "winrt_x86_msvc2017" set VC_VARSALL=amd64_x86
if "%PLATFORM%" == "winrt_armv7_msvc2017" set VC_VARSALL=amd64_x86
if "%PLATFORM%" == "msvc2015_64" set VC_VARSALL=amd64
if "%PLATFORM%" == "msvc2015" set VC_VARSALL=amd64_x86
if "%PLATFORM%" == "static" set VC_VARSALL=amd64

set qtplatform=%PLATFORM%
call %VC_DIR% %VC_VARSALL%



for %%* in (.) do set CurrDirName=%%~nx*
C:\Qt\%QT_VER%\%qtplatform%\bin\qmake .\app\ || exit /B 1

:: compilation
nmake qmake_all || exit /B 1
nmake || exit /B 1
nmake release || exit /B 1
echo "step 4"
nmake INSTALL_ROOT=\projects\%CurrDirName%\install install || exit /B 1
echo "step 5"

:: qt deploy
C:\Qt\%QT_VER%\%qtplatform%\bin\windeployqt.exe C:\projects\qregovar\release --qmldir C:\projects\qregovar\app\UI\
