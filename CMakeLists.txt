
#On MAC OS currently need to use the XCode provided gcc and a compatible 
#gfortran (e.g. v4.2.3). If you have other gcc installed, make sure you
#set CC=/usr/bin/gcc and CXX=/usr/bin/g++ before running cmake.

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ENABLE_LANGUAGE(Fortran)

SET(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
SET(wxWidgets_CONFIG_EXECUTABLE /Users/richard.cooper/wxWidgets-2.9.5/bld/wx-config)
FIND_PACKAGE(wxWidgets REQUIRED html adv core gl base stc)
INCLUDE(${wxWidgets_USE_FILE})

SET(APPS /Users/richard.cooper/crystals/go7/crystals.app)
SET(DIRS )

IF (NOT CMAKE_BUILD_TYPE)   # make sure that the default is a RELEASE

    SET (CMAKE_BUILD_TYPE RELEASE CACHE STRING
         "Choose the type of build, options are: None Debug Release."  FORCE)

ENDIF()

# FFLAGS depend on the compiler
GET_FILENAME_COMPONENT (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

IF (Fortran_COMPILER_NAME STREQUAL "gfortran")  # gfortran

    SET (CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fno-f2c -O3")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")

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



IF (APPLE)

  SET(CMAKE_OSX_ARCHITECTURES "x86_64" )
  SET(CMAKE_OSX_DEPLOYMENT_TARGET "10.8") 
  SET(CMAKE_OSX_SYSROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.8.sdk")
#  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
#  SET(CMAKE_LINKER_EXE_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=c++")

ENDIF ()


PROJECT(Crystals)


# Testing related directives for test coverage
ENABLE_TESTING()
INCLUDE(CTest)

# Libraries
ADD_SUBDIRECTORY(script)
ADD_SUBDIRECTORY(gui)
ADD_SUBDIRECTORY(crystals)
ADD_SUBDIRECTORY(cameron)
ADD_SUBDIRECTORY(bits)
ADD_SUBDIRECTORY(datafiles)
ADD_SUBDIRECTORY(precomp)

# Executables

ADD_DEFINITIONS(-D_GIL_)
ADD_DEFINITIONS(-D_GNUF77_)
ADD_DEFINITIONS(-D__WXMAC__)
ADD_DEFINITIONS(-D__WXOSX__)

# Script file sources and targets

FILE (GLOB sscfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.ssc")
SET  (scpfiles)
FOREACH (_file ${sscfiles})
    STRING(REPLACE ".ssc" ".scp" file_scp ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_scp} 
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/crysedit.pl ${CMAKE_CURRENT_SOURCE_DIR}/${_file} ${file_scp} code=GIL incl=+ excl=- comm=\\%\\%
                        DEPENDS ${_file} )
    LIST(APPEND scpfiles ${file_scp})
ENDFOREACH()

# Data file sources and targets

FILE (GLOB sdafiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.sda")
SET  (datfiles)
FOREACH (_file ${sdafiles})
    STRING(REPLACE ".sda" ".dat" file_dat ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_dat} 
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/crysedit.pl ${CMAKE_CURRENT_SOURCE_DIR}/${_file} ${file_dat} code=GIL incl=+ excl=- comm=\#
                        DEPENDS ${_file} )
    LIST(APPEND datfiles ${file_dat})
ENDFOREACH()

FILE (GLOB ssrfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/datafiles/*.ssr")
SET  (srtfiles)
FOREACH (_file ${ssrfiles})
    STRING(REPLACE ".ssr" ".srt" file_srt ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_srt} 
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/crysedit.pl ${CMAKE_CURRENT_SOURCE_DIR}/${_file} ${file_srt} code=GIL incl=+ excl=- comm=\#
                        DEPENDS ${_file} )
    LIST(APPEND srtfiles ${file_srt})
ENDFOREACH()


SET_SOURCE_FILES_PROPERTIES( ${scpfiles} PROPERTIES MACOSX_PACKAGE_LOCATION Resources/script GENERATED 1  )
SET_SOURCE_FILES_PROPERTIES( ${datfiles} PROPERTIES MACOSX_PACKAGE_LOCATION Resources/script GENERATED 1  )
SET_SOURCE_FILES_PROPERTIES( ${srtfiles} PROPERTIES MACOSX_PACKAGE_LOCATION Resources GENERATED 1  )

ADD_CUSTOM_TARGET ( dscbuild ALL DEPENDS crystals commands.dsc )
ADD_CUSTOM_COMMAND ( OUTPUT commands.dsc COMMAND cp datafiles/commands.dsc . DEPENDS subdscbuild ${CMAKE_BINARY_DIR}/datafiles/commands.dsc )
SET_SOURCE_FILES_PROPERTIES( commands.dsc PROPERTIES MACOSX_PACKAGE_LOCATION Resources GENERATED 1  )



ADD_EXECUTABLE (crystals MACOSX_BUNDLE ${scpfiles} ${datfiles} ${srtfiles} gui/gcrystals.cc)

TARGET_LINK_LIBRARIES(crystals CameronFortran CrystalsFortran CrystalsUserInterface ${wxWidgets_LIBRARIES})

INSTALL(CODE "
      include(BundleUtilities)
      fixup_bundle(\"${APPS}\"  \"\"  \"${DIRS}\")
      " COMPONENT Runtime)

