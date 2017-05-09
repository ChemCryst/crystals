PROJECT(superflip)
message("")
message(STATUS "Building superflip")

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

SET (CMAKE_Fortran_FLAGS_RELEASE "-O2 -g")
message(STATUS "superflip fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")

add_executable (superflip pliv.c lapack_sgelsy.f matrices.f90 symmetry_tools.f90 sf_modules.f90 sf_input.f90 sf_lib.f90 sf_output.f90 sf_chargeflip_lib.f90 sf_symmetry_lib.f90 sf_splines_lib.f90 superflip.f90)
TARGET_LINK_LIBRARIES(superflip "-lfftw3f -lm")
message(STATUS "End building superflip")
message("")



