@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

@SETLOCAL
@if not exist ..\editor\cryseditor.exe cd ..\editor&&call make_w32.bat&&cd ..
@ENDLOCAL
mkdir script
@FOR %%I IN ( ..\script\*.ssc ) DO ..\editor\cryseditor %%I script\%%~nI.scp code=%COMPCODE% incl=+ excl=- comm=%%%% 
@FOR %%I IN ( ..\script\*.sda ) DO ..\editor\cryseditor %%I script\%%~nI.dat code=%COMPCODE% incl=+ excl=- comm=# 
@goto exit

:clean
del script\*.scp
del script\*.dat
rmdir script

:tidy

:exit
