
if(APPLE)
SET (ENV{CRYSDIR} "./")
EXECUTE_PROCESS (COMMAND ../crystals )
# EXECUTE_PROCESS (COMMAND ../crystals.app/Contents/MacOS/crystals ./ )

elseif( useGUI )

MESSAGE( STATUS "Using cl helper app to build dsc file." )
# GUI versions with cl helper app.
  if(WIN32)
    SET (ENV{CRYSDIR} .\\ )
    EXECUTE_PROCESS (COMMAND ../crystalscl.exe .\\ )
  else()
    SET (ENV{CRYSDIR} ./ )
    EXECUTE_PROCESS (COMMAND ../crystalscl  )
  endif()

else()

MESSAGE( STATUS "Using command line version to build dsc file." )
# Command line versions
  if(WIN32)
    SET (ENV{CRYSDIR} .\\ )
    EXECUTE_PROCESS (COMMAND ../crystals.exe .\\ )
  else()
    SET (ENV{CRYSDIR} ./ )
    EXECUTE_PROCESS (COMMAND ../crystals  )
  endif()

endif()
