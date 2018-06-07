
if "%PLATFORM%" == "msvc2017_64" set PACKAGE=win64_msvc2017_64
if "%PLATFORM%" == "winrt_x64_msvc2017" set PACKAGE=win64_msvc2017_winrt_x64
if "%PLATFORM%" == "winrt_x86_msvc2017" set PACKAGE=win64_msvc2017_winrt_x86
if "%PLATFORM%" == "winrt_armv7_msvc2017" set PACKAGE=win64_msvc2017_winrt_armv7
if "%PLATFORM%" == "msvc2015_64" set PACKAGE=win64_msvc2015_64
if "%PLATFORM%" == "msvc2015" set PACKAGE=win32_msvc2015
if "%PLATFORM%" == "mingw53_32" (
	set PACKAGE=win32_mingw53
	set EXTRA_MODULES=qt.tools.win32_mingw530;%EXTRA_MODULES%
)
if "%PLATFORM%" == "static" set PACKAGE=src


:: build static qt
if "%PLATFORM%" == "static" (
	%~dp0\setup-qt-static.bat || exit \B 1
)

:: mingw32 make workaround
if "%PLATFORM%" == "mingw53_32" (
	copy C:\projects\Qt\Tools\mingw530_32\bin\mingw32-make.exe C:\projects\Qt\Tools\mingw530_32\bin\make.exe
)
