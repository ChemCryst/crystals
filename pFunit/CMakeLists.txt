cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

if(NOT WIN32)
  string(ASCII 27 Esc)
  set(ColourReset "${Esc}[m")
  set(BoldCyan    "${Esc}[1;36m")
endif()

project(pfunit-crystals)

set(SF_MODPATH "${CMAKE_SOURCE_DIR}/cmakemodules/")
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")
set(CMAKE_CXX_FLAGS "")

if(NOT usepFUnit)
    return ()
endif ()
message("")
message("${BoldCyan}Setting up unit testing${ColourReset}")

enable_language(Fortran)

set(CRYSLIB "${CMAKE_BINARY_DIR}/crys_fortran/libCrystalsFortran.a")

if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
    set(CMAKE_Fortran_FLAGS "-g -fprofile-arcs -ftest-coverage")
endif()

if(useOPENMP)
	find_package(OpenMP)
	if (OPENMP_FOUND)
		set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
		set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
		set (CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_Fortran_FLAGS}")
	endif()
endif ()

set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR};${CMAKE_MODULE_PATH}")
set(CMAKE_PREFIX_PATH "${CMAKE_SOURCE_DIR};${CMAKE_PREFIX_PATH}")
if(DEFINED ENV{PFUNIT})
    message(STATUS "pFUnit search location: $ENV{PFUNIT}")
else ()
    message(FATAL_ERROR "PFUNIT environment variable missing")
endif ()

find_package(pFUnit REQUIRED)
if(PFUNIT_FOUND)
    message(STATUS "pFUnit found [${PFUNIT_PARSER}]")
    message(STATUS "pFUnit library [${PFUNIT_LIBRARY}]")
endif ()

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/generated)
file(WRITE ${PROJECT_BINARY_DIR}/generated/testSuites.inc "")

include_directories(
    ${PROJECT_SOURCE_DIR}
    ${PROJECT_BINARY_DIR}/generated
    ${PFUNIT_MODULE_DIR}
    )

set(_test_sources)
FILE(GLOB testslist "${PROJECT_SOURCE_DIR}/*.pf")

FOREACH(_test ${testslist})
    get_filename_component(test_basename ${_test} NAME_WE)
    MESSAGE(STATUS "Building test file: ${test_basename}")
    set(test_dependency ${_test})
    add_custom_command(
        OUTPUT ${PROJECT_BINARY_DIR}/generated/${test_basename}.F90
        COMMAND python ${PFUNIT_PARSER} ${_test} ${PROJECT_BINARY_DIR}/generated/${test_basename}.F90
        DEPENDS ${test_dependency}
        )
    set(_test_sources ${_test_sources} ${PROJECT_BINARY_DIR}/generated/${test_basename}.F90)
    file(APPEND ${PROJECT_BINARY_DIR}/generated/testSuites.inc "ADD_TEST_SUITE(${test_basename}_suite)\n")
endforeach()

set_source_files_properties(${PFUNIT_DRIVER} PROPERTIES GENERATED 1)

add_executable(
    pftest_alltests
    ${CMAKE_SOURCE_DIR}/pFunit/dummymodule.f90
    ${PFUNIT_DRIVER}
    ${_test_sources}
    )

get_target_property(linkflags crystals LINK_LIBRARIES)
target_link_libraries(
    pftest_alltests
    ${PFUNIT_LIBRARY}
    ${CRYSLIB}
    ${linkflags}
    )

enable_testing()
add_test(pftest_alltests ${PROJECT_BINARY_DIR}/pftest_alltests)
add_custom_command(TARGET pftest_alltests POST_BUILD COMMAND pftest_alltests)

