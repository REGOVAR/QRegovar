
if "%PLATFORM%" == "mingw53_32" (
	call %~dp0\build-mingw.bat || exit /B 1
) else (
	call %~dp0\build-msvc.bat || exit /B 1
)
