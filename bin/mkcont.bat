@echo oN
SET XCODE=F95
SET XPROG=contour
if "%CRYSSRC%" == "" goto cryssrcerror
if "%CRYSBUILD%" == "" goto crysbuilderror
MKDIR %CRYSBUILD%\ERRORS
cd %CRYSBUILD%\CODE
mkdir %XPROG%
CD %XPROG%

copy %CRYSSRC%\cryssrc\empty .
SAVE THE OLD PATH
SET OPATH=%PATH%
PATH=C:\FTN77_32.DIR\;%PATH%


echo building %XPROG%.obj
if exist %xprog%.for del %xprog%.for
if exist %xprog%.for del %xprog%.obj
if exist %CRYSBUILD%:%XPROG%.exe %CRYSBUILD%:%XPROG%.exe 
rem
editor %CRYSSRC%\bits\%XPROG%\ajicont.old ajicont.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
editor %CRYSSRC%\bits\%XPROG%\ashley.old ashley.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
editor %CRYSSRC%\bits\%XPROG%\contor.old contor.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
editor %CRYSSRC%\bits\%XPROG%\drwplot.old drwplot.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
editor %CRYSSRC%\bits\%XPROG%\extras.old extras.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
editor %CRYSSRC%\bits\%XPROG%\mapper.old mapper.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
editor %CRYSSRC%\bits\%XPROG%\vgacalls.old vgacalls.for code=%XCODE%  macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\%XPROG%.lis
ftn77 *.FOR   /no_warn73 >> %CRYSBUILD%\errors\%XPROG%.lis
slink *.obj -file:%CRYSBUILD%\%XPROG%.exe >> %CRYSBUILD%\errors\%XPROG%.lis
CD %CRYSBUILD%


PATH=%OPATH%
SET XCODE=
SET XPROG=
