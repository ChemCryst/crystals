
@echo building %1.obj
@editor %SRCDIR%\%1.src %1.for code=%EDCODE% macro=%CRYSSRC%\cryssrc\macrofil.mac > %CRYSBUILD%\errors\ed%1.lis

@goto %COMPCODE%

:DOS
FTN77 %1.for /binary frel\%1.obj        /no_warn73 /zero
FTN77 %1.for /binary fdbg\%1.obj /debug /no_warn73 /zero
goto next1


:F95
FTN95 %1.for /binary frel\%1.obj        /no_warn73 /zero /silent
FTN95 %1.for /binary fdbg\%1.obj /debug /no_warn73 /zero /silent
goto next1

:DVF
DF %1.for /object:frel\%1.obj /ML /optimize:4 /list:%CRYSBUILD%\errors\for%1.lis /nolink
DF %1.for /object:fdbg\%1.obj /MLd /debug /Zt /check:bounds /check:overflow /check:format /warn:argument_checking /warn:nofileopt /show:none /list:%CRYSBUILD%\errors\dfor%1.lis /nolink 

goto next1

:LIN
:GIL
g77 -c %1.for -o frel/%1.obj -O2
g77 -c %1.for -o fdbg/%1.obj -g
goto next1
    
:GID
@if "%1" == "lapack"  goto nooptGID
DF %1.for /object:frel\%1.obj /MD /optimize:4 /winapp  /list:%CRYSBUILD%\errors\for%1.lis /nolink
goto nextGID
:nooptGID
DF %1.for /object:frel\%1.obj /MD /optimize:0 /winapp  /list:%CRYSBUILD%\errors\for%1.lis /nolink
:nextGID
DF %1.for /object:fdbg\%1.obj /MDd /debug /Zt /check:bounds /check:format /check:overflow /check:underflow /warn:argument_checking /winapp /warn:nofileopt /show:none /list:%CRYSBUILD%\errors\dfor%1.lis /nolink
@goto next1

:WXS
@if exist frel\%1.obj del frel\%1.obj
@if exist fdbg\%1.obj del fdbg\%1.obj
g77 -c %1.for -fno-automatic -fno-globals -Wno-globals -o frel/%1.obj -O2
g77 -c %1.for -fno-automatic -fno-globals -Wno-globals -o fdbg/%1.obj -g
goto next1



:next1

    
