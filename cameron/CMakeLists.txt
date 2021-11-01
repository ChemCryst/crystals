PROJECT(cameron)
message("")
message(STATUS "Building cameron")

enable_language(Fortran)

# Reset flags
#set(CMAKE_Fortran_FLAGS "")



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

target_link_libraries( CameronFortran PUBLIC CrystalsDefines )
target_include_directories(CameronFortran PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/../crystals" )
target_include_directories(CameronFortran PRIVATE "${CMAKE_CURRENT_BINARY_DIR}/../crys_fortran" )


message(STATUS "End building cameron")
message("")
