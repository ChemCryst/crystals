set(CMAKE_BUILD_TYPE Release)

if(APPLE)
  SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
ENDIF(APPLE)

cmake_minimum_required(VERSION 2.8)


set (EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# Executables

add_definitions(-D_GNUF77_)
add_definitions(-D _HOL_)


add_executable (crysload crysload.cc)



