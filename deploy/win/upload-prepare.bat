
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

	7z a build_%PLATFORM%_%QT_VER%.zip C:\projects\qregovar\release || exit \B 1
)
