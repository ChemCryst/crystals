

cmake_minimum_required(VERSION 2.8)

project(Bits)

set(SF_MODPATH "${CMAKE_SOURCE_DIR}/cmakemodules/")

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

# Because external project call cmake externally too we need to pass the compiler and module path via cmake_args
if(withSUPERFLIP)
	message("")
	message(STATUS "Building superflip")

	ExternalProject_Add(
		superflip_project
		URL http://superflip.fzu.cz/download/superflip.tar.gz
		UPDATE_COMMAND ${CMAKE_COMMAND} -E copy
							  ${CMAKE_SOURCE_DIR}/bits/superflip/CMakeLists.txt
							  ${CMAKE_CURRENT_BINARY_DIR}/superflip_project-prefix/src/superflip_project/CMakeLists.txt
		BUILD_IN_SOURCE 1
		CMAKE_ARGS -DSF_MODPATH=${SF_MODPATH} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
		INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/superflip_project-prefix/src/superflip_project/superflip${CMAKE_EXECUTABLE_SUFFIX} ${CMAKE_BINARY_DIR}/
	)

	message(STATUS "End Building superflip")
endif()

if(withEDMA)
message("")
message(STATUS "Building edma")
ExternalProject_Add(
    edma_project
    URL http://superflip.fzu.cz/download/EDMA.tar.gz
    UPDATE_COMMAND ${CMAKE_COMMAND} -E copy
                          ${CMAKE_SOURCE_DIR}/bits/edma/CMakeLists.txt
                          ${CMAKE_CURRENT_BINARY_DIR}/edma_project-prefix/src/edma_project/CMakeLists.txt
    BUILD_IN_SOURCE 1
    CMAKE_ARGS -DSF_MODPATH=${SF_MODPATH} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/edma_project-prefix/src/edma_project/edma${CMAKE_EXECUTABLE_SUFFIX} ${CMAKE_BINARY_DIR}/
)

message(STATUS "End Building edma")
endif()
