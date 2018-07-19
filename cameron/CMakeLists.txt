PROJECT(cameron)
message("")
message(STATUS "Building cameron")

enable_language(Fortran)

# Reset flags
set(CMAKE_Fortran_FLAGS "")

if ( useGUI )
#add_definitions(-D_GIL_)
#add_definitions(-D__WXMAC__)
#add_definitions(-D__WXOSX__)
#add_definitions(-D__WXOSX_COCOA__)
add_definitions(-D__WXUSINGDLL)
endif()

#add_definitions(-I/Users/richard.cooper/crystals/crystals)
add_definitions(-I\"${CMAKE_CURRENT_SOURCE_DIR}/../crystals\")
add_definitions(-I\"${CMAKE_CURRENT_BINARY_DIR}/../crys_fortran\")

GET_FILENAME_COMPONENT (Fortran_COMPILER_NAME "${CMAKE_Fortran_COMPILER}" NAME)
if ((Fortran_COMPILER_NAME MATCHES "ifort") OR (Fortran_COMPILER_NAME MATCHES "ifort.exe")) # ifort (untested)
    message(WARNING "Using Intel Fortran compiler.")  
    SET (IFORT_COMPILER 1)
endif()


IF(NOT IFORT_COMPILER)
add_definitions(-D_GNUF77_)
add_definitions(-std=legacy)
add_definitions(-fno-automatic)
add_definitions(-fno-inline)
add_definitions(-fexceptions)
ENDIF()

add_definitions(-D _HOL_)
#add_definitions(-arch x86_64)


message(STATUS "cameron fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")
add_library(CameronFortran STATIC 
altered.F
block.F
button.F
ccontrol.F
comm.F
cspecific.F
duplicat.F
general.F
graphics.F
maths1.F
maths2.F
mouse.F
outer.F
vander.F
wincode.F
)

message(STATUS "End building cameron")
message("")
