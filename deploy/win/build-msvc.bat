:: build
setlocal

set qtplatform=%PLATFORM%
for %%* in (.) do set CurrDirName=%%~nx*

echo %VC_DIR% %VC_VARSALL%
call %VC_DIR% %VC_VARSALL% || exit /B 1

mkdir build-%qtplatform%
cd build-%qtplatform%

C:\projects\Qt\%QT_VER%\%qtplatform%\bin\qmake ../ || exit /B 1
nmake qmake_all || exit /B 1
nmake || exit /B 1
nmake lrelease || exit /B 1
nmake INSTALL_ROOT=\projects\%CurrDirName%\install install || exit /B 1
