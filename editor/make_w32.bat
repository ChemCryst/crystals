@call ..\build\make_w32_include.bat
@set OPATH=%PATH%
@set OLIB=%LIB%
@set PATH=C:\Progra~1\Micros~3\vc98\bin;C:\Progra~1\Micros~3\df98\bin;%PATH%
@set LIB=C:\Progra~1\Micros~3\vc98\lib;C:\Progra~1\Micros~3\df98\lib;%LIB%
@set LINK=
%F77% ..\editor\cryseditor.fpp %FOUT%..\editor\cryseditor.obj %FDEF% %FOPTS%
%LD% %OPT% %LDCFLAGS% *.obj %OUT%cryseditor.exe
@set PATH=%OPATH%
@set LIB=%OLIB%
