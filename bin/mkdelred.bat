@echo oN
SET XCODE=F95
SET XPROG=DELRED
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
MKDIR %CRYSBUILD%\ERRORS
cd %CRYSBUILD%\CODE
mkdir %XPROG%
CD %XPROG%

copy %CRYSSRC%\cryssrc\empty .


echo building %XPROG%.obj
editor %CRYSSRC%\bits\%XPROG%\%XPROG%.src %XPROG%.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
ftn95/zero/save %XPROG%.FOR >> %CRYSBUILD%\errors\%XPROG%.lis
slink %XPROG%.obj -file:%CRYSBUILD%\%XPROG%.exe >> %CRYSBUILD%\errors\%XPROG%.lis
CD %CRYSBUILD%

SET XCODE=
SET XPROG=
CD %CRYSSRC%
