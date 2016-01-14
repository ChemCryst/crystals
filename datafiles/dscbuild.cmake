
if(APPLE)
SET (ENV{CRYSDIR} ./)
EXECUTE_PROCESS (COMMAND ../crystals.app/Contents/MacOS/crystals ./ )
else()
SET (ENV{CRYSDIR} .\\ )
EXECUTE_PROCESS (COMMAND ../crystals.exe .\\ )
endif()