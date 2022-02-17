@echo on

SetLocal EnableDelayedExpansion

for /f "delims=" %%d in ( 'dir /a:d /b "C:\Program Files (x86)\Intel\oneAPI"' ) do call :DoIt "%%d"
goto EndDoIt

:DoIt
  set "componentpath=C:\Program Files (x86)\Intel\oneAPI\%~1"

  echo: Componentpath: '%componentpath%'
 
  rem delete existing symbolic link
 
  dir "%componentpath%"
  
  if EXIST "%componentpath%\latest" (
      rmdir "%componentpath%\latest"
      for /f "tokens=* usebackq" %%f in (`dir /b "%componentpath%\" ^| findstr /V latest ^| sort`) do @set "LATEST_VERSION=%%f"
      if "%LATEST_VERSION%" neq ""  (
         echo: make link to: "%componentpath%\%LATEST_VERSION%"
         mklink /d "%componentpath%\latest" "%componentpath%\%LATEST_VERSION%"
	  )
  )

exit /b
:EndDoIt
