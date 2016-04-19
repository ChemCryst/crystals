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

SET (CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -std=legacy -fno-automatic -fno-inline -O1")



add_executable (shelxs shelxs.F ../Common/nobuf.c)
add_executable (sxtocry sxtocry.F ../Common/nobuf.c)



