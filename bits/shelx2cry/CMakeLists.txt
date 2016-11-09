PROJECT(shelx2cry)
message("")
message(STATUS "Building cif2cry")

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

set(CMAKE_C_FLAGS_RELEASE "-O2 -g")
SET (CMAKE_Fortran_FLAGS_RELEASE "-O2 -g -fcheck=all")
message(STATUS "shelx2cry fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")

add_executable (shelx2cry crystal_data.F90 shelx_procedures.F90 shelx2cry_dict.F90 shelx2cry_mod.F90  shelx2cry.F90)
TARGET_LINK_LIBRARIES(shelx2cry "${CMAKE_BINARY_DIR}/sginfo/libsginfo.a")
SET_TARGET_PROPERTIES(shelx2cry PROPERTIES Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} )    

message(STATUS "End building shelx2cry")

# Unit testing
ADD_SUBDIRECTORY(pFunit)

message("")



