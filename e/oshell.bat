@echo off
rem SCRIPT to start appropriate command shell.
rem if %1 is "P" then shell stays open.
IF %1==P goto skip
IF "%OS%" == "Windows_NT" cmd /c %1 %2 %3 %4 %5 %6 %7
IF NOT "%OS%" == "Windows_NT" command.com /e:3072 /c %1 %2 %3 %4 %5 %6 %7
goto end
:skip
SHIFT
IF "%OS%" == "Windows_NT" cmd /k %1 %2 %3 %4 %5 %6 %7
IF NOT "%OS%" == "Windows_NT" command.com /e:3072 /k %1 %2 %3 %4 %5 %6 %7
:end
