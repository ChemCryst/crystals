set EDCODE=DVF
set OPATH=%PATH%
set OLIB=%LIB%
set PATH=C:\Progra~1\Micros~3\vc98\bin;C:\Progra~1\Micros~3\df98\bin;%PATH%
set LIB=C:\Progra~1\Micros~3\vc98\lib;C:\Progra~1\Micros~3\df98\lib;%LIB%
set LINK=

editor contour.src contour.for code=%EDCODE% macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\edcontour.lis

DF contour.for /object:contour.obj /libs:qwin /optimize:4

set PATH=%OPATH%

