cd %CRYSBUILD%\script
perl -w %CRYSSRC%\bin\scpcheck.pl

@echo The following files (if any) are present in the source,
@echo but have not been created - check SCRIPT.BAT:
@fc %CRYSSRC%\scriptsrc\*.ssc *.scp |grep -i "no such"
@fc %CRYSSRC%\scriptsrc\*.sda *.dat |grep -i "no such"
