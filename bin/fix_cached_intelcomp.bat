for /f "delims=" %%d in ( 'dir /a:d /b "C:\Program Files (x86)\Intel\oneAPI"' ) do call :DoIt "%%d"
goto EndDoIt

:DoIt
  set "componentpath=C:\Program Files (x86)\Intel\oneAPI\%~1"
  set "cname=%~n1"

  echo: Componentpath: '%componentpath%'
  echo: cname: '%cname%'
  
  rem delete existing symbolic link
  
  rmdir "%componentpath%\latest"
  
  for /f "tokens=* usebackq" %%f in (`dir /b "C:\Program Files (x86)\Intel\oneAPI\compiler\" ^| findstr /V latest ^| sort`) do @set "LATEST_VERSION=%%f"

  mklink /d "%componentpath%\latest" "%componentpath%\%LATEST_VERSION%"

exit /b
:EndDoIt
