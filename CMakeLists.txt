#On MAC OS currently need to use the XCode provided gcc and a compatible
#gfortran (e.g. v4.2.3). If you have other gcc installed, make sure you
#set CC=/usr/bin/gcc and CXX=/usr/bin/g++ before running cmake.

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(Crystals)

ENABLE_LANGUAGE(Fortran)
INCLUDE (CPack)
IF (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} GREATER 3.0)
    include(CheckFortranCompilerFlag)
Endif()

option (useGUI "useGUI" ON)
option (usePY "usePY" OFF)
option (usePY "use32" OFF)

if ( use32 )
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -m32")
endif()

find_package(BLAS)
find_package(LAPACK)

if(BLAS_LIBRARIES_DIR)
   link_directories( ${BLAS_LIBRARIES_DIR} )
endif()
if ( BLAS_LIBRARIES )
   link_libraries ( ${BLAS_LIBRARIES} )
endif()
if ( BLAS_LINKER_FLAGS )
   uniquely_add_flags ( CMAKE_MODULE_LINKER_FLAGS ${BLAS_LINKER_FLAGS} )
endif()

if(LAPACK_LIBRARIES_DIR)
   link_directories( ${LAPACK_LIBRARIES_DIR} )
endif()
if ( LAPACK_LIBRARIES )
   link_libraries ( ${LAPACK_LIBRARIES} )
endif()
if ( LAPACK_LINKER_FLAGS )
   uniquely_add_flags ( CMAKE_MODULE_LINKER_FLAGS ${LAPACK_LINKER_FLAGS} )
endif()



if ( useGUI )
        message("Using gui")
	add_definitions(-DCRY_GUI)
	add_definitions(-D_GIL_)
	SET(MINGW 1)
	SET(wxWidgets_ROOT_DIR "c:/wx3")
	SET(wxWidgets_LIB_DIR "c:/wx3/lib/gcc_dll")
	set(wxWidgets_CONFIGURATION mswu)
	FIND_PACKAGE(wxWidgets REQUIRED html stc scintilla adv core gl base )
	INCLUDE(${wxWidgets_USE_FILE})
		
else()
	add_definitions(-DCRY_NOGUI)
	add_definitions(-D_LIN_)
endif()

if ( usePY )
	add_definitions(-DCRY_PY)
endif()

if ( WIN32 )
add_definitions(-DCRY_OSWIN32)
endif()
add_definitions(-DCRY_GNU)
ADD_DEFINITIONS(-D_NOHDF5_)
add_definitions(-D _HOL_)
ADD_DEFINITIONS(-D__MIN__)
ADD_DEFINITIONS(-D_GNUF77_)


string (TIMESTAMP CRYYEAR "%Y")
string (TIMESTAMP CRYMONTH "%m")
string (TIMESTAMP CRYDAY "%d")
set (CRYSVNVER "$ENV{CRYSVNVER}")
IF (NOT CRYSVNVER)  # not set
	SET (CRYSVNVER "0000")
ENDIF()
message(STATUS "Compilation date = ${CRYDAY} / ${CRYMONTH} / ${CRYYEAR}")

IF (NOT CMAKE_BUILD_TYPE)   # make sure that the default is a RELEASE
    SET (CMAKE_BUILD_TYPE RELEASE CACHE STRING
         "Choose the type of build, options are: None Debug Release."  FORCE)
ENDIF()

# FFLAGS depend on the compiler
GET_FILENAME_COMPONENT (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

IF (Fortran_COMPILER_NAME STREQUAL "gfortran")  # gfortran
    SET (CMAKE_Fortran_FLAGS_RELEASE "-fno-f2c -O3 -g -fno-sign-zero -ftree-vectorize -msse2")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O1 -g -Wall -Wextra")
    if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER "4.5")
        SET (CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fcheck=all")
    else ()
        SET (CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fbounds-check")
    endif()
ELSEIF (Fortran_COMPILER_NAME STREQUAL "ifort")  # ifort (untested)
    SET (CMAKE_Fortran_FLAGS_RELEASE "-f77rtl -O3")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-f77rtl -O0 -g")
ELSEIF (Fortran_COMPILER_NAME STREQUAL "g77")   # g77
    SET (CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fno-f2c -O3")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")
ELSE ()
    MESSAGE ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
    MESSAGE ("Fortran compiler: " ${Fortran_COMPILER_NAME})
    MESSAGE ("No optimized Fortran compiler flags are known, we just try -O2...")
    SET (CMAKE_Fortran_FLAGS_RELEASE "-O2")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")
ENDIF ()

SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu++11")


IF (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} GREATER 3.0)
    check_fortran_compiler_flag("-std=legacy" _std_legacy_flag)
    check_fortran_compiler_flag("-fexceptions" _f_exceptions)
    check_fortran_compiler_flag("-fno-sign-zero" _f_no_signzero)

    if(_std_legacy_flag)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=legacy")
    endif()
    if(-fexceptions)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fexceptions")
    endif()
    if(-fno-sign-zero)
      set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-sign-zero")
    endif()
ELSE ()
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -std=legacy")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fexceptions")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-sign-zero")
ENDIF ()

    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fabi-version=9")








# Testing related directives for test coverage
#ENABLE_TESTING()
#INCLUDE(CTest)

# Libraries
ADD_SUBDIRECTORY(script)
ADD_SUBDIRECTORY(sleef)
ADD_SUBDIRECTORY(crystals crys_fortran)
ADD_SUBDIRECTORY(cameron)
ADD_SUBDIRECTORY(datafiles)
ADD_SUBDIRECTORY(precomp)
if ( useGUI )
	ADD_SUBDIRECTORY(gui)
	ADD_SUBDIRECTORY(bits)
endif()
if ( usePY )
  ADD_SUBDIRECTORY(pyinterface)
endif()


add_dependencies(CameronFortran CrystalsFortran) 

# Executables

ADD_CUSTOM_COMMAND ( OUTPUT commands.dsc COMMAND ${CMAKE_COMMAND} -E copy datafiles/commands.dsc . DEPENDS subdscbuild ${CMAKE_BINARY_DIR}/datafiles/commands.dsc )


# Script file sources and targets

FILE (GLOB sscfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.ssc")
SET  (scpfiles)
FOREACH (_file ${sscfiles})
    STRING(REPLACE ".ssc" ".scp" file_scp ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_scp}
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_scp} -D__INW__ -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
                        DEPENDS ${_file} )
    LIST(APPEND scpfiles ${file_scp})
ENDFOREACH()







# Data file sources and targets

FILE (GLOB sdafiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.sda")
SET  (datfiles)
FOREACH (_file ${sdafiles})
    STRING(REPLACE ".sda" ".dat" file_dat ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_dat}
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_dat} -D__INW__ -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
	DEPENDS ${_file} )
    LIST(APPEND datfiles ${file_dat})
ENDFOREACH()

FILE (GLOB ssrfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/datafiles" "${CMAKE_CURRENT_SOURCE_DIR}/datafiles/*.ssr")
SET  (srtfiles)
FOREACH (_file ${ssrfiles})
    STRING(REPLACE ".ssr" ".srt" file_srt ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_srt}
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_srt} -D__INW__ -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/datafiles/${_file}
                        DEPENDS datafiles/${_file} )
    LIST(APPEND srtfiles ${file_srt})
ENDFOREACH()


if ( useGUI )
# For the fwrapper module
	INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR}/crys_fortran)
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} $<TARGET_OBJECTS:CrystalsUserInterface> gui/gcrystals.cc crystals/crystals.F)
	TARGET_LINK_LIBRARIES(crystals CrystalsSleef CrystalsFortran CameronFortran ${wxWidgets_LIBRARIES})
	SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_GUI)
elseif( usePY )
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals.F)
    SET_TARGET_PROPERTIES(crystals PROPERTIES LINKER_LANGUAGE Fortran)
	TARGET_LINK_LIBRARIES(crystals CrystalsSleef CrystalsFortran CameronFortran )
else()
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals.F)
    SET_TARGET_PROPERTIES(crystals PROPERTIES LINKER_LANGUAGE Fortran)
	TARGET_LINK_LIBRARIES(crystals CrystalsSleef CrystalsFortran CameronFortran)
	SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_NOGUI)
endif()

find_package(OpenGL REQUIRED)
find_package(GLUT REQUIRED)
include_directories( ${OPENGL_INCLUDE_DIRS}  ${GLUT_INCLUDE_DIRS} )
target_link_libraries(crystals ${OPENGL_LIBRARIES} ${GLUT_LIBRARY} )


ADD_CUSTOM_TARGET ( startups ALL DEPENDS dscbuild ${srtfiles} )
ADD_CUSTOM_TARGET ( dscbuild ALL DEPENDS commands.dsc crystals )
