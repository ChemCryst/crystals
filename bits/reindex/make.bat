set EDCODE=DVF
@set OPATH=%PATH%
@set OLIB=%LIB%
@set PATH=C:\Progra~1\Micros~3\vc98\bin;C:\Progra~1\Micros~3\df98\bin;%PATH%
@set LIB=C:\Progra~1\Micros~3\vc98\lib;C:\Progra~1\Micros~3\df98\lib;%LIB%
@set LINK=
editor reindex.src reindex.for code=%EDCODE% macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\edreindex.lis
DF reindex.for /MD /optimize
@set PATH=%OPATH%
@set LIB=%OLIB%
