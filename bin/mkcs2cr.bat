@echo oN
SET XCODE=F95
SET XPROG=CSD2CRY
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
MKDIR %CRYSBUILD%\ERRORS
cd %CRYSBUILD%\CODE
mkdir %XPROG%
CD %XPROG%

copy %CRYSSRC%\cryssrc\empty .


echo building %XPROG%.obj
editor %CRYSSRC%\bits\%XPROG%\%XPROG%.src %XPROG%.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
rem ftn95/zero/check %XPROG%.FOR >> %CRYSBUILD%\errors\%XPROG%.lis
DF %xprog%.for /object:%xprog%.obj /nolink /debug:none /warn:argument_checking /math_library:fast
rem slink %XPROG%.obj -file:%CRYSBUILD%\%XPROG%.exe >> %CRYSBUILD%\errors\%XPROG%.lis
DF %XPROG%.obj  /EXE:%CRYSBUILD%\%XPROG%.exe >> %CRYSBUILD%\errors\%XPROG%.lis
CD %CRYSBUILD%

SET XCODE=
SET XPROG=
CD %CRYSSRC%
