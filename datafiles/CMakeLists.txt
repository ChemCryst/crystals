

SET(CMAKE_BUILD_TYPE Release)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(Data)
# SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/..)

ADD_CUSTOM_TARGET(subdscbuild DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/commands.dsc)

# GUI version uses crystalscl helper to build dsc file as intermediate step...
if ( useGUI )
  ADD_CUSTOM_COMMAND(
      OUTPUT commands.dsc
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/crysdef.srt crystals.srt
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/commands.src commands.src
      COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.dsc commands.h5
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
      COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.dsc commands.h5
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
		  COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.h5 commands.dsc
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
		  COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14 commands.h5 commands.dsc
		  COMMAND ${CMAKE_COMMAND} -D useGUI=no -P ${CMAKE_CURRENT_SOURCE_DIR}/h5build.cmake
		  COMMAND ${CMAKE_COMMAND} -E remove crystals.srt
		  DEPENDS commands.src crystals
		  COMMENT "Processing commands.src into commands.h5"
	)
	endif()

endif ()

