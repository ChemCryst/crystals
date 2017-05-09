

cmake_minimum_required(VERSION 2.8)

project(Bits)

add_subdirectory(cif2cry)
add_subdirectory(convplat)
add_subdirectory(csd2cry)
add_subdirectory(delred)
add_subdirectory(foxman)
add_subdirectory(hklf5)
add_subdirectory(Diffractometers)
add_subdirectory(reindex)
add_subdirectory(shelxs)
add_subdirectory(shelx2cry)
if ( NOT WIN32 )
  add_subdirectory(sir92)
endif()
#add_subdirectory(loader)

include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)

message("")
message(STATUS "Building superflip")
ExternalProject_Add(
    superflip_project
    URL http://superflip.fzu.cz/download/superflip.tar.gz
    UPDATE_COMMAND ${CMAKE_COMMAND} -E copy
                          ${CMAKE_SOURCE_DIR}/bits/superflip/CMakeLists.txt
                          ${CMAKE_CURRENT_BINARY_DIR}/superflip_project-prefix/src/superflip_project/CMakeLists.txt
    BUILD_IN_SOURCE 1
    INSTALL_COMMAND cp ${CMAKE_CURRENT_BINARY_DIR}/superflip_project-prefix/src/superflip_project/superflip ${CMAKE_BINARY_DIR}/
)


message(STATUS "End Building superflip")
