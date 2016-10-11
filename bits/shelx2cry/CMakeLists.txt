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


set (EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# Executables

# Reset flags
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")

set(CMAKE_C_FLAGS_RELEASE "-O1")
SET (CMAKE_Fortran_FLAGS_RELEASE "-O2")
message(STATUS "shelx2cry fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")

add_executable (shelx2cry shelx2cry_mod.F90  shelx2cry.F90)
message(STATUS "End building shelx2cry")
message("")



