if "%CRYSEMAIL%" == "TRUE" perl ..\bin\errmail.pl %1 %2 %3
if not "%CRYSEMAIL%" == "TRUE" type %3 & echo An error occured & pause
exit /b 1
