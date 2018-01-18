PROJECT(sir92)
message("")
message(STATUS "Building sir92")

enable_language(Fortran)
#set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
set(CMAKE_BUILD_TYPE Release)

if(APPLE)
  SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
ENDIF(APPLE)

cmake_minimum_required(VERSION 2.8)


set (EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# Executables

#add_definitions(-D_GIL_)
add_definitions(-D _HOL_)

# Reset flags
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")

set(CMAKE_C_FLAGS_RELEASE "-O1")
SET (CMAKE_Fortran_FLAGS_RELEASE "-O1 -std=legacy -fno-automatic -fno-inline")
message(STATUS "sir92 fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")

add_executable (sir92 norm92.F sir92.F sir92X11.c)
target_link_libraries(sir92 "-lX11")
message(STATUS "End building sir92")
message("")
