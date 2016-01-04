
#On MAC OS currently need to use the XCode provided gcc and a compatible
#gfortran (e.g. v4.2.3). If you have other gcc installed, make sure you
#set CC=/usr/bin/gcc and CXX=/usr/bin/g++ before running cmake.

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ENABLE_LANGUAGE(Fortran)
INCLUDE (CPack)

option (useGUI "useGUI" ON)

if ( useGUI )
add_definitions(-DCRY_GUI)
else()
add_definitions(-DCRY_NOGUI)
endif()

if(APPLE)
set (CPACK_GENERATOR "DragNDrop")
set (CPACK_BUNDLE_NAME "Crystals")
SET(CPACK_INSTALL_CMAKE_PROJECTS  "${CMAKE_BINARY_DIR};Crystals;ALL;/")
SET(CPACK_PACKAGE_VENDOR "Chem Cryst")
SET(CPACK_PACKAGE_VERSION "15.0.0")
SET(CPACK_PACKAGE_VERSION_MAJOR "15")
SET(CPACK_PACKAGE_VERSION_MINOR "0")
SET(CPACK_PACKAGE_VERSION_PATCH "0")
endif()

SET(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmakemodules/")

if ( useGUI )
#SET(wxWidgets_CONFIG_EXECUTABLE /Users/richard.cooper/wxWidgets-2.9.5/b2/wx-config)
SET(MINGW 1)
SET(wxWidgets_ROOT_DIR "c:/wx3")
SET(wxWidgets_LIB_DIR "c:/wx3/lib/gcc_dll")
set(wxWidgets_CONFIGURATION mswu)
FIND_PACKAGE(wxWidgets REQUIRED html adv core gl base stc)
INCLUDE(${wxWidgets_USE_FILE})
endif()

string (TIMESTAMP CRYYEAR "%Y")
string (TIMESTAMP CRYMONTH "%m")
string (TIMESTAMP CRYDAY "%d")

set (CRYSVNVER "$ENV{CRYSVNVER}")
IF (NOT CRYSVNVER)  # not set
SET (CRYSVNVER "0000")
ENDIF()


message(STATUS "Compilation date = ${CRYDAY} / ${CRYMONTH} / ${CRYYEAR}")
if (APPLE)
SET(APPS ${CMAKE_BINARY_DIR}/crystals.app)
endif()

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
#  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
#  SET(CMAKE_LINKER_EXE_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=c++")

ENDIF ()


PROJECT(Crystals)

ADD_DEFINITIONS(-D__MIN__)

# Testing related directives for test coverage
ENABLE_TESTING()
INCLUDE(CTest)

# Libraries
ADD_SUBDIRECTORY(script)
ADD_SUBDIRECTORY(sleef)

if ( useGUI )
ADD_SUBDIRECTORY(gui)
endif()
ADD_SUBDIRECTORY(crystals)
ADD_SUBDIRECTORY(cameron)
if ( useGUI )
#ADD_SUBDIRECTORY(bits)
endif()
ADD_SUBDIRECTORY(datafiles)
ADD_SUBDIRECTORY(precomp)

# Executables

#ADD_DEFINITIONS(-DCRY_OWNLAPACK)
ADD_DEFINITIONS(-D_GNUF77_)
ADD_DEFINITIONS(-std=gnu++11)

if(APPLE)
ADD_DEFINITIONS(-D__WXMAC__)
ADD_DEFINITIONS(-D__WXOSX__)
endif()
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

if(APPLE)
SET_SOURCE_FILES_PROPERTIES( ${scpfiles} PROPERTIES MACOSX_PACKAGE_LOCATION Resources/script GENERATED 1  )
SET_SOURCE_FILES_PROPERTIES( ${datfiles} PROPERTIES MACOSX_PACKAGE_LOCATION Resources/script GENERATED 1  )
SET_SOURCE_FILES_PROPERTIES( ${srtfiles} PROPERTIES MACOSX_PACKAGE_LOCATION Resources GENERATED 1  )
endif()

ADD_CUSTOM_TARGET ( startups ALL DEPENDS dscbuild ${srtfiles} )
ADD_CUSTOM_TARGET ( dscbuild ALL DEPENDS commands.dsc crystals )

SET_SOURCE_FILES_PROPERTIES( commands.dsc PROPERTIES MACOSX_PACKAGE_LOCATION Resources GENERATED 1  )

if (APPLE)
set( MACOSX_BUNDLE_ICON_FILE crystals.icns )
endif()

#ADD_CUSTOM_COMMAND ( OUTPUT commands.dsc COMMAND cp datafiles/commands.dsc . DEPENDS subdscbuild ${CMAKE_BINARY_DIR}/datafiles/commands.dsc )
ADD_CUSTOM_COMMAND ( OUTPUT commands.dsc COMMAND ${CMAKE_COMMAND} -E copy datafiles/commands.dsc . DEPENDS subdscbuild ${CMAKE_BINARY_DIR}/datafiles/commands.dsc )


if (APPLE)
  ADD_CUSTOM_TARGET ( osx_bundle_dirs
    COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/ProjectName.app/Contents/Resources
    COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/ProjectName.app/Contents/MacOS
    COMMAND cp ${CMAKE_SOURCE_DIR}/precomp/MAC/${MACOSX_BUNDLE_ICON_FILE}
    ${CMAKE_CURRENT_BINARY_DIR}/crystals.app/Contents/Resources/${MACOSX_BUNDLE_ICON_FILE} )

   ADD_EXECUTABLE (crystals MACOSX_BUNDLE ${scpfiles} ${datfiles} ${srtfiles} gui/gcrystals.cc)
   add_dependencies(crystals osx_bundle_dirs )

else()

  if ( useGUI )
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} gui/gcrystals.cc)
  else()
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} )
    SET_TARGET_PROPERTIES(crystals PROPERTIES LINKER_LANGUAGE Fortran)
  endif()
endif()


if (useGUI)
add_library(everything $<TARGET_OBJECTS:CrystalsUserInterface> $<TARGET_OBJECTS:CrystalsFortran>)
else()
add_library(everything $<TARGET_OBJECTS:CrystalsFortran>)
endif()

if (useGUI)
TARGET_LINK_LIBRARIES(crystals everything CrystalsSleef CameronFortran openblas ${wxWidgets_LIBRARIES})
else()
#link_directories( ${CMAKE_CURRENT_SOURCE_DIR}/openblas )
TARGET_LINK_LIBRARIES(crystals everything CrystalsSleef CameronFortran openblas)
endif()


INSTALL(CODE "
      include(BundleUtilities)
      fixup_bundle(\"${APPS}\"  \"\"  \"${DIRS}\")
      " COMPONENT Runtime)

if (APPLE)
INSTALL(FILES ${CMAKE_BINARY_DIR}/commands.dsc DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )

INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/cif2cry/cif2cry DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/shelxs/shelxs DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/shelxs/sxtocry DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/convplat/convplat DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/delred/delred DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/foxman/pcf2cry DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/sir92/sir92 DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/csd2cry/csd2cry DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/hklf5/hklf52cry DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )
INSTALL(PROGRAMS ${CMAKE_BINARY_DIR}/bits/Diffractometers/diffin DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources )

FILE (COPY "${CMAKE_CURRENT_SOURCE_DIR}/precomp/all/script" DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources)
FILE (COPY "${CMAKE_CURRENT_SOURCE_DIR}/precomp/all/demo" DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources)
FILE (COPY "${CMAKE_CURRENT_SOURCE_DIR}/precomp/all/form.dat" DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources)

INSTALL (PROGRAMS "${CMAKE_CURRENT_SOURCE_DIR}/precomp/MAC/superflip" DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources)
INSTALL (PROGRAMS "${CMAKE_CURRENT_SOURCE_DIR}/precomp/MAC/EDMA" DESTINATION ${CMAKE_BINARY_DIR}/crystals.app/Contents/Resources)
endif()
