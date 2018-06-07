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

call %VC_DIR% %VC_VARSALL%
echo "step 1"



set qtplatform=%PLATFORM%
for %%* in (.) do set CurrDirName=%%~nx*

echo "step 2"

C:\Qt\%QT_VER%\%qtplatform%\bin\qmake .\app\ || exit /B 1
echo "step 3"

nmake qmake_all || exit /B 1
echo "step 4"

nmake || exit /B 1
echo "step 5"

nmake lrelease || exit /B 1
echo "step 6"

nmake INSTALL_ROOT=\projects\%CurrDirName%\install install || exit /B 1
