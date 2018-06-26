
if "%PLATFORM%" == "static" (
	rename static static_win || exit \B 1
	7z a build_static_win_%QT_VER%.zip static_win || exit \B 1
	move build_static_win_%QT_VER%.zip ..\..\..\ || exit \B 1
) else (
	:: clean package
	del C:\projects\qregovar\release\*.h
	del C:\projects\qregovar\release\*.cpp
	del C:\projects\qregovar\release\*.obj
	ren "C:\projects\qregovar\release\QRegovar.exe" "C:\projects\qregovar\release\regovar.exe"

	if "%PLATFORM%" == "msvc2017_64" (
		7z a regovar-client_%VERSION%_x86-64.zip C:\projects\qregovar\release || exit \B 1
	)
	if "%PLATFORM%" == "msvc2015" (
		7z a regovar-client_%VERSION%_x86-32.zip C:\projects\qregovar\release || exit \B 1
	)
)
