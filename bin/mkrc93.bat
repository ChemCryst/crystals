@echo oN
SET XCODE=F95
SET XPROG=RC93
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

IF EXIST RC93.EXE COPY RC93.EXE ERC93.EXE <YES.DAT
IF EXIST RC93.EXE DEL RC93.EXE

IF EXIST %CRYSSRC%\bits\%XPROG%\%XPROG%.SSR COPY %CRYSSRC%\bits\%XPROG%\%XPROG%.SSR %XPROG%.SRT <YES.DAT


SET XCODE=
SET XPROG=
