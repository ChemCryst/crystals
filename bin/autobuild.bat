if "%CRYSSRC%" == "" builderr.bat CRYSSRC_CHECK
CD %CRYSSRC%
if NOT %ERRORLEVEL% == 0 builderr.bat CRYSSRC_NOT_FOUND %CRYSSRC%
RMDIR /q /s %CRYSBUILD% > prev
cvs -d %CVSROOT% update -d > cvsup
if NOT %ERRORLEVEL% == 0 builderr.bat CVS_UPDATE cvs cvsup
MKDIR %CRYSBUILD%
CD %CRYSBUILD%
call code
CD %CRYSBUILD%
call script
CD %CRYSBUILD%
call local
CD %CRYSBUILD%
call dsc
CD %CRYSBUILD%
call precomp
CD %CRYSBUILD%
call buildman
call inst
