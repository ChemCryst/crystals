PROJECT(sginfo)
message("")
message(STATUS "Building sginfo")

enable_language(Fortran)
#set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
set(CMAKE_BUILD_TYPE Release)

if(APPLE)
  SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
ENDIF(APPLE)

cmake_minimum_required(VERSION 2.8)

SET( Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules" )
message(STATUS "Modules saved at [${CMAKE_BINARY_DIR}/FortranModules]")
INCLUDE_DIRECTORIES(${Fortran_MODULE_DIRECTORY})
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules")

set (EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# Executables

# Reset flags
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")

set(CMAKE_C_FLAGS_RELEASE "-O1")
SET (CMAKE_Fortran_FLAGS_RELEASE "-O2")
message(STATUS "shelx2cry fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")

add_library(sginfo STATIC 
sgclib.c
sgfind.c
sghkl.c
sgio.c
sgsi.c
sginfo_extra.c
sginfo_type.F90
sginfo.F90
)
SET_TARGET_PROPERTIES(sginfo PROPERTIES Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} )    
message(STATUS "End building sginfo")

message("")



