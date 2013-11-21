

SET(CMAKE_BUILD_TYPE Release)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(Data)
# SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/..)

ADD_CUSTOM_TARGET(subdscbuild DEPENDS commands.dsc)

ADD_CUSTOM_COMMAND(
      OUTPUT commands.dsc
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/crysdef.srt crystals.srt
      COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/commands.src commands.src
      COMMAND ${CMAKE_COMMAND} -E remove deleteme.mon deleteme.spq deleteme.lis fort.14
      COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/dscbuild.cmake
      COMMAND ${CMAKE_COMMAND} -E remove crystals.srt
      DEPENDS commands.src crystals
      COMMENT "Processing commands.src into commands.dsc"
)





