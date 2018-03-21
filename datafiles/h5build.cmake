
if(APPLE)
SET (ENV{CRYSDIR} "./")
EXECUTE_PROCESS (COMMAND ../crystals --hdf5 )
# EXECUTE_PROCESS (COMMAND ../crystals.app/Contents/MacOS/crystals ./ )

elseif( useGUI )

MESSAGE( STATUS "Using cl helper app to build h5 file." )
# GUI versions with cl helper app.
  if(WIN32)
    SET (ENV{CRYSDIR} .\\ )
    EXECUTE_PROCESS (COMMAND ../crystalscl.exe  --hdf5 .\\ )
  else()
    SET (ENV{CRYSDIR} ./ )
    EXECUTE_PROCESS (COMMAND ../crystalscl  --hdf5 )
  endif()

else()

MESSAGE( STATUS "Using command line version to build h5 file." )
# Command line versions
  if(WIN32)
    SET (ENV{CRYSDIR} .\\ )
    EXECUTE_PROCESS (COMMAND ../crystals.exe  --hdf5 .\\ )
  else()
    SET (ENV{CRYSDIR} ./ )
    EXECUTE_PROCESS (COMMAND ../crystals  --hdf5 )
  endif()

endif()
