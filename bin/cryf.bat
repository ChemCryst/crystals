
@echo building %1.obj

@goto %COMPCODE%
:DOS
FTN77 %SRCDIR%\%1.for /binary %1.obj        /no_warn73 /zero
rem FTN77 %SRCDIR%\%1.for /binary %1.obj /debug /no_warn73 /zero
goto next1

:F95
FTN95 %SRCDIR%\%1.for /binary %1.obj        /no_warn73 /zero /silent
rem FTN95 %1.for /binary fdbg\%1.obj /debug /no_warn73 /zero /silent
goto next1

:DVF
DF %SRCDIR%\%1.for /object:%1.obj /ML /optimize:4 /list:for%1.lis /nolink
rem DF %1.for /object:fdbg\%1.obj /MLd /debug /Zt /check:bounds /check:overflow /check:format /warn:argument_checking /warn:nofileopt /show:none /list:%CRYSBUILD%\errors\dfor%1.lis /nolink 
goto next1

:GID
@if "%1" == "lapack"  goto nooptGID
DF /fpp /define:_%COMPCODE%_ /I..\crystals %SRCDIR%\%1.fpp /object:%1.obj /MD /optimize:4 /winapp /list:for%1.lis /nolink
goto next1

:nooptGID
DF /fpp /define:_%COMPCODE%_ %SRCDIR%\%1.f /object:%1.obj /MD /optimize:0 /winapp /list:for%1.lis /nolink

:nextGID
@rem DF %1.for /object:fdbg\%1.obj /MDd /debug /Zt /check:bounds /check:format /check:overflow /check:underflow /warn:argument_checking /winapp /warn:nofileopt /show:none /list:%CRYSBUILD%\errors\dfor%1.lis /nolink
@goto next1

:next1
