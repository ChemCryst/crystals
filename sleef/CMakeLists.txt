PROJECT(CrystalsSleef)
message("")
message(STATUS "Building CrystalsSleef")


enable_language(Fortran)

SET( Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules" )
message(STATUS "Modules saved at [${CMAKE_BINARY_DIR}/FortranModules]")
INCLUDE_DIRECTORIES(${Fortran_MODULE_DIRECTORY})
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules")

set (EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

add_library(CrystalsSleef STATIC 
fwrapper.f90
cwrapper.c
sleefsp.c
)

SET_TARGET_PROPERTIES(CrystalsSleef PROPERTIES Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} )    
message(STATUS "End building CrystalsSleef")

message("")

