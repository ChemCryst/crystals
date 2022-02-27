PROJECT(sir92)
message("")
message(STATUS "Building sir92")

enable_language(Fortran)
#set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
set(CMAKE_BUILD_TYPE Release)

if(APPLE)
  SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
ENDIF(APPLE)
IF (IFORT_COMPILER)
	add_definitions(-DCRY_FORTINTEL)
ENDIF()


cmake_minimum_required(VERSION 3.0)


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

IF (IFORT_COMPILER)
set (CMAKE_Fortran_LINKER_PREFERENCE 80)
set (CMAKE_FORTRAN_LINK_EXECUTABLE "ifort  <CMAKE_Fortran_LINK_FLAGS> <LINK_FLAGS> <FLAGS> <OBJECTS>  -o <TARGET> <LINK_LIBRARIES>")

add_executable (sir92 WIN32 norm92.F sir92.F )
TARGET_LINK_LIBRARIES(sir92 ifqwin.lib ifqw_mdi.lib)


#target_link_options (sir92 PUBLIC "/libs:qwin")
set_property(TARGET sir92 PROPERTY LINKER_LANGUAGE Fortran)
SET_TARGET_PROPERTIES(sir92 PROPERTIES LINKER_LANGUAGE Fortran)

# target_link_libraries(sir92 "qwin")
ELSE()
add_executable (sir92 norm92.F sir92.F sir92X11.c)
target_link_libraries(sir92 "-lX11")
ENDIF()
message(STATUS "End building sir92")
message("")
