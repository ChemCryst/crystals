
if not exist %CRYSSRC%\scriptsrc\%1.ssc goto next1

echo building %1.scp
editor %SRCDIR%\%1.ssc %1.scp code=%EDCODE% macro=%CRYSSRC%\cryssrc\macrofil.mac incl=+ excl=- comm=%%%% > %CRYSBUILD%\errors\scp%1.lis

:next1

if not exist %CRYSSRC%\scriptsrc\%1.sda goto exit

echo building %1.dat
editor %SRCDIR%\%1.sda %1.dat code=%EDCODE% macro=%CRYSSRC%\cryssrc\macrofil.mac incl=+ excl=- comm=#  > %CRYSBUILD%\errors\dat%1.lis


:exit
