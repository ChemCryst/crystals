@call ..\build\make_w32_include.bat
SETLOCAL
@set OPATH=%PATH%
@set OLIB=%LIB%
goto %COMPCODE%

:INW
%F77% ..\editor\cryseditor.fpp %FOUT%..\..\editor\cryseditor.obj %FDEF% %FOPTS%
%LD% %OPT% %LDFLAGS% ..\editor\*.obj %OUT%cryseditor.exe
goto DONE

:DVF
:GID
call "c:\program files\microsoft visual studio\df98\bin\dfvars.bat"
%F77% ..\editor\cryseditor.fpp %FOUT%..\..\editor\cryseditor.obj %FDEF% %FOPTS%
%LD% %OPT% %LDCFLAGS% ..\editor\*.obj %OUT%cryseditor.exe

:DONE
@set PATH=%OPATH%
@set LIB=%OLIB%
ENDLOCAL
