PROJECT(convplat)
message("")
message(STATUS "Building convplat")

enable_language(Fortran)
#set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
set(CMAKE_BUILD_TYPE Release)

if(APPLE)
  SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
ENDIF(APPLE)

cmake_minimum_required(VERSION 2.8)


set (EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# Executables

add_definitions(-D_GNUF77_)
add_definitions(-D _HOL_)

# Reset flags
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")

set(CMAKE_C_FLAGS_RELEASE "-O1")
SET (CMAKE_Fortran_FLAGS_RELEASE "-O1 -std=legacy -fno-automatic -fno-inline")
message(STATUS "convplat fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")

add_executable (convplat convplat.F ../Common/nobuf.c)
add_executable (platanom platanom.F ../Common/nobuf.c)
message(STATUS "End building convplat")
message("")
