
if "%PLATFORM%" == "static" (
	rename static static_win || exit \B 1
	7z a build_static_win_%QT_VER%.zip static_win || exit \B 1
	move build_static_win_%QT_VER%.zip ..\..\..\ || exit \B 1
) else (
	7z a build_%PLATFORM%_%QT_VER%.zip C:\projects\qregovar\release || exit \B 1
)
