set EDCODE=DVF
@set OPATH=%PATH%
@set OLIB=%LIB%
@set PATH=C:\Progra~1\Micros~3\vc98\bin;C:\Progra~1\Micros~3\df98\bin;%PATH%
@set LIB=C:\Progra~1\Micros~3\vc98\lib;C:\Progra~1\Micros~3\df98\lib;%LIB%
@set LINK=
DF convplat.for /MD  /optimize
@set PATH=%OPATH%
@set LIB=%OLIB%
