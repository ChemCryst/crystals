@echo oN
SET XCODE=DOS
SET XPROG=SIR92
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
MKDIR %CRYSBUILD%\ERRORS
cd %CRYSBUILD%\CODE
mkdir %XPROG%
CD %XPROG%

copy %CRYSSRC%\cryssrc\empty .

rem SAVE THE OLD PATH
SET OPATH=%PATH%
PATH=C:\FTN77_32.DIR\;%PATH%

echo building %XPROG%.obj
editor %CRYSSRC%\bits\%XPROG%\%XPROG%.src %XPROG%.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
ftn77 /intl/silent %XPROG%.FOR >> %CRYSBUILD%\errors\%XPROG%.lis


echo building NORM92.obj
editor %CRYSSRC%\bits\%XPROG%\NORM92.src NORM92.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac >> %CRYSBUILD%\errors\%XPROG%.lis
ftn77 /SAVE/intl/silent NORM92.FOR >> %CRYSBUILD%\errors\%XPROG%.lis

slink %XPROG%.obj NORM92.OBJ -file:%CRYSBUILD%\%XPROG%.exe >> %CRYSBUILD%\errors\%XPROG%.lis
CD %CRYSBUILD%

IF EXIST SIR92.EXE COPY SIR92.EXE ESIR92.EXE <YES.DAT
IF EXIST SIR92.EXE DEL SIR92.EXE
IF EXIST %CRYSSRC%\bits\%XPROG%\FORM.DAT COPY %CRYSSRC%\bits\%XPROG%\FORM.DAT  FORM.DAT <YES.DAT

PATH=%OPATH%
SET XCODE=
SET XPROG=
