PROJECT(edma)
message("")
message(STATUS "Building edma")

enable_language(Fortran)
#set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
set(CMAKE_BUILD_TYPE Release)

if(APPLE)
  SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
ENDIF(APPLE)

cmake_minimum_required(VERSION 2.8)

message("Args: -DSF_MODPATH=${SF_MODPATH} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${SF_MODPATH}")

# Executables

# Reset flags
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")

SET (CMAKE_Fortran_FLAGS_RELEASE "-O2 -g")
message(STATUS "edma fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")

add_executable (edma pliv.c Variables_mod.f90 Input_lib.f90 EDMA.f90 RhoIO_lib.f90 BayMEM_lib.f90 BayMEM_wlib.f90 EDMA_lib.f90 Splines_lib.f90)
message(STATUS "End building edma")
message("")



