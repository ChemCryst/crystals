

CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

PROJECT(Data)
# SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/..)

ADD_CUSTOM_TARGET(subdscbuild DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/commands.dsc)

# GUI version uses crystalscl helper to build dsc file as intermediate step...
if ( useGUI )
  ADD_CUSTOM_COMMAND(
      OUTPUT commands.dsc
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/crysdef.srt crystals.srt
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/commands.src commands.src
      COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.dsc 
      COMMAND ${CMAKE_COMMAND} -D useGUI=yes -P ${CMAKE_CURRENT_SOURCE_DIR}/dscbuild.cmake
      COMMAND ${CMAKE_COMMAND} -E remove crystals.srt
      DEPENDS commands.src crystalscl
      COMMENT "Processing commands.src into commands.dsc"
)
else()
  ADD_CUSTOM_COMMAND(
      OUTPUT commands.dsc
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/crysdef.srt crystals.srt
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/commands.src commands.src
      COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.dsc 
      COMMAND ${CMAKE_COMMAND} -D useGUI=no -P ${CMAKE_CURRENT_SOURCE_DIR}/dscbuild.cmake
      COMMAND ${CMAKE_COMMAND} -E remove crystals.srt
      DEPENDS commands.src crystals
      COMMENT "Processing commands.src into commands.dsc"
)
endif()

if(useHDF5)

    ADD_CUSTOM_TARGET(subh5build DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/commands.h5 subdscbuild)
	if ( useGUI )
	  ADD_CUSTOM_COMMAND(
		  OUTPUT commands.h5
		  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/crysdef.srt crystals.srt
		  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/commands.src commands.src
		  COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.h5 
		  COMMAND ${CMAKE_COMMAND} -D useGUI=yes -P ${CMAKE_CURRENT_SOURCE_DIR}/h5build.cmake
		  COMMAND ${CMAKE_COMMAND} -E remove crystals.srt
		  DEPENDS commands.src crystalscl
		  COMMENT "Processing commands.src into commands.h5"
	)
	else()
	  ADD_CUSTOM_COMMAND(
		  OUTPUT commands.h5
		  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/crysdef.srt crystals.srt
		  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/commands.src commands.src
		  COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.h5
		  COMMAND ${CMAKE_COMMAND} -D useGUI=no -P ${CMAKE_CURRENT_SOURCE_DIR}/h5build.cmake
		  COMMAND ${CMAKE_COMMAND} -E remove crystals.srt
		  DEPENDS commands.src crystals
		  COMMENT "Processing commands.src into commands.h5"
	)
	endif()

endif ()

get_target_property(_if_compile_defs CrystalsDefines INTERFACE_COMPILE_DEFINITIONS)
set(defstring)
foreach(_def ${_if_compile_defs})
   list( APPEND defstring -D${_def})
endforeach()


set (CRYHOST "${CMAKE_SYSTEM_NAME}")

# Data file sources and targets
# Note that srt files end up in the main directory (above this one).

FILE (GLOB ssrfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/*.ssr")
SET  (srtfiles)
FOREACH (_file ${ssrfiles})
    STRING(REPLACE ".ssr" ".srt" file_srt ${_file})
    SET( arguments -ds -w -imacros ${CMAKE_SOURCE_DIR}/gui/crystalsinterface.h -o ${CMAKE_BINARY_DIR}/${file_srt} -DCRYARCH=${CRYARCH} -DCRYHOST=${CRYHOST} -DCRYSVNVER=${CRYSVNVER} -DCRYVERSUM=${CRYVERSUM} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} )
    list(APPEND arguments ${defstring})
    ADD_CUSTOM_COMMAND( OUTPUT ${CMAKE_BINARY_DIR}/${file_srt}
                        COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/editor/filepp.pl ${arguments} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
                        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_file} 
                        COMMENT "${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/editor/filepp.pl ${arguments} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}")
    LIST(APPEND srtfiles ${CMAKE_BINARY_DIR}/${file_srt})
ENDFOREACH()

add_library(CrystalsData INTERFACE ${srtfiles})
target_link_libraries(CrystalsData INTERFACE CrystalsDefines)
