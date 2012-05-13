if "%CRYSEMAIL%" == "TRUE" perl ..\bin\errmail.pl %1 %2 %3
if not "%CRYSEMAIL%" == "TRUE" type %3 & echo An error occured
@if "%CRBUILDEXIT%" == "TRUE"  exit 1
exit /b 1
