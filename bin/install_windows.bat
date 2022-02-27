REM SPDX-FileCopyrightText: 2020 Intel Corporation
REM
REM SPDX-License-Identifier: MIT

set URL=%1
set COMPONENTS=%2
set THING=%3

curl.exe --output %THING%.exe --url %URL% --retry 5 --retry-delay 5
start /b /wait %THING%.exe -s -x -f %THING%_extracted --log extract.log
del %THING%.exe

dir %THING%_extracted

if "%COMPONENTS%"=="" (
  %THING%_extracted\bootstrapper.exe -s --action install --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.
) else (
  %THING%_extracted\bootstrapper.exe -s --action install --components=%COMPONENTS% --eula=accept -p=NEED_VS2017_INTEGRATION=0 -p=NEED_VS2019_INTEGRATION=0 -p=NEED_VS2022_INTEGRATION=0 --log-dir=.
)
