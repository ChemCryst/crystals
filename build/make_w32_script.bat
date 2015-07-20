@setlocal EnableExtensions EnableDelayedExpansion
@call make_w32_include.bat
@if "%1" == "clean" goto clean
@if "%1" == "tidy" goto tidy

mkdir script
@FOR %%I IN ( ..\script\*.ssc ) DO perl ..\editor\filepp.pl -w -imacros ..\gui\crystalsinterface.h -o script\%%~nI.scp -D__%COMPCODE%__ -DCRYSVNVER=%CRYSVNVER% -DCRYMONTH=%CRYMONTH% -DCRYYEAR=%CRYYEAR% %%I
@FOR %%I IN ( ..\script\*.sda ) DO perl ..\editor\filepp.pl -w -imacros ..\gui\crystalsinterface.h -o script\%%~nI.dat -D__%COMPCODE%__ %%I

@goto exit


:clean
del script\*.scp
del script\*.dat
rmdir script

:tidy

:exit
