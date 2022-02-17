for /f "delims=" %%d in ( 'dir /a:d /b "C:\Program Files (x86)\Intel\oneAPI"' ) do call :DoIt "%%d"
goto EndDoIt

:DoIt
  set "componentpath=C:\Program Files (x86)\Intel\oneAPI\%~1"
  set "cname=%~n1"

  echo: Componentpath: '%componentpath%'
  echo: cname: '%cname%'
  
  rem delete existing symbolic link
  
  dir %componentpath%
  
  if EXIST "%componentpath%\latest" (
      rmdir "%componentpath%\latest"
      for /f "tokens=* usebackq" %%f in (`dir /b "C:\Program Files (x86)\Intel\oneAPI\compiler\" ^| findstr /V latest ^| sort`) do @set "LATEST_VERSION=%%f"
      echo: make link to: "%componentpath%\%LATEST_VERSION%"
      mklink /d "%componentpath%\latest" "%componentpath%\%LATEST_VERSION%"
  )

exit /b
:EndDoIt
