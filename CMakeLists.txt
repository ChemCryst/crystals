#On MAC OS currently need to use the XCode provided gcc and a compatible
#gfortran (e.g. v4.2.3). If you have other gcc installed, make sure you
#set CC=/usr/bin/gcc and CXX=/usr/bin/g++ before running cmake.

CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(Crystals)

SET(CMAKE_VERBOSE_MAKEFILE OFF)
SET(CMAKE_COLOR_MAKEFILE ON)

option (verbose "verbose" OFF)
option (useGUI "useGUI" ON)
option (usePY "usePY" OFF)
option (use32 "use32" OFF)
option (useSTATIC "useSTATIC" OFF)
option (useOPENMP "useOPENMP" ON)
option (useHDF5 "useHDF5" OFF) # hdf5 storage, use system library
option (compileHDF5 "compileHDF5" OFF) # hdf5 storage, download and compile hdf5
option (useGGDB3 "useGGDB3" OFF) # used for orion (old dgb)
option (usepFUnit "usepFUnit" OFF)  
option (useFAST "useFAST" OFF)  
option (useSLEEF "useSLEEF" OFF)  


option (withSUPERFLIP "withSUPERFLIP" OFF)  
option (withEDMA "withEDMA" OFF)  

if(verbose)
    SET(CMAKE_VERBOSE_MAKEFILE ON)
endif ()

SET( Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules" )
message(STATUS "Modules saved at [${CMAKE_BINARY_DIR}/FortranModules]")
INCLUDE_DIRECTORIES(${Fortran_MODULE_DIRECTORY})
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules")

if(useSTATIC)
    SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    SET(BUILD_SHARED_LIBRARIES OFF)
    SET(CMAKE_EXE_LINKER_FLAGS "-static")
    SET(wxWidgets_USE_STATIC ON)
    message(STATUS "Building static version")
endif ()

ENABLE_LANGUAGE(Fortran)
INCLUDE (CPack)
IF (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} GREATER 3.0)
    include(CheckFortranCompilerFlag)
Endif()

if (${CMAKE_SYSTEM_NAME} MATCHES "MINGW64_NT" OR ${CMAKE_SYSTEM_NAME} MATCHES "MINGW32_NT") 
    message(STATUS "Building using MSYS2, Mingw64 toolchain")
    SET(MSYS ON)
endif ()

# check gcc suite version
if(CMAKE_COMPILER_IS_GNUCC)
  exec_program(
      ${CMAKE_C_COMPILER}
      ARGS                    --version
      OUTPUT_VARIABLE _compiler_output)
  string(REGEX REPLACE "^.*([0-9]\\.[0-9]\\.[0-9]).*$" "\\1" gcc_compiler_version ${_compiler_output})
  message(STATUS "C compiler version: ${gcc_compiler_version} [${CMAKE_C_COMPILER}]")
  
  if(gcc_compiler_version VERSION_LESS "4.6")
      message(FATAL_ERROR "Your C compiler is too old")
  elseif(gcc_compiler_version VERSION_LESS "4.6")
      message(WARNING "Your C compiler might be too old")  
  endif ()

  exec_program(
      ${CMAKE_CXX_COMPILER}
      ARGS                    --version
      OUTPUT_VARIABLE _compiler_output)
  string(REGEX REPLACE "^.*([0-9]\\.[0-9]\\.[0-9]).*$" "\\1" gcc_compiler_version ${_compiler_output})
  message(STATUS "C++ compiler version: ${gcc_compiler_version} [${CMAKE_CXX_COMPILER}]")
  
  if(gcc_compiler_version VERSION_LESS "4.6")
      message(FATAL_ERROR "Your C compiler is too old")
  elseif(gcc_compiler_version VERSION_LESS "4.6")
      message(WARNING "Your C compiler might be too old")  
  endif ()

  exec_program(
      ${CMAKE_Fortran_COMPILER}
      ARGS                    --version
      OUTPUT_VARIABLE _compiler_output)
  string(REGEX REPLACE "^.*([0-9]\\.[0-9]\\.[0-9]).*$" "\\1" gcc_compiler_version ${_compiler_output})
  message(STATUS "Fortran compiler version: ${gcc_compiler_version} [${CMAKE_Fortran_COMPILER}]")
  
  if(gcc_compiler_version VERSION_LESS "4.6")
      message(FATAL_ERROR "Your C compiler is too old")
  elseif(gcc_compiler_version VERSION_LESS "4.6")
      message(WARNING "Your C compiler might be too old")  
  endif ()
endif ()

FIND_PACKAGE ( Perl REQUIRED)
IF ( PERL_FOUND )
    MESSAGE ( STATUS "Perl executable: [${PERL_EXECUTABLE}]")
ENDIF ( PERL_FOUND )

IF (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} GREATER 3.5)
    find_package(BLAS)
    find_package(LAPACK)

    if(BLAS_FOUND AND LAPACK_FOUND)
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
        message(STATUS "Using BLAS library: ${BLAS_LIBRARIES}")
    else ()
        message(STATUS "Using builtin BLAS and LAPACK library")
        add_definitions(-DCRY_OWNLAPACK)
    endif ()
else ()
    find_library(OpenBLAS_LIBRARY openblaso)
    if(OpenBLAS_LIBRARY)
        message(STATUS "Using OpenBLAS [${OpenBLAS_LIBRARY}]")
    else ()
        find_package(BLAS)
        find_package(LAPACK)

        if(BLAS_FOUND AND LAPACK_FOUND)
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
            message(STATUS "Using BLAS library: ${BLAS_LIBRARIES}")
        else ()
            message(STATUS "Using builtin BLASS library")
            add_definitions(-DCRY_OWNLAPACK)
        endif ()    
    endif()
endif ()

# Reset flags
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")
set(CMAKE_CXX_FLAGS "")

if(useOPENMP)
    find_package(OpenMP)
    if (OPENMP_FOUND)
        set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
        set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        set (CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_Fortran_FLAGS}")
    endif()
endif ()

if ( use32 )
    message(STATUS "Building 32bit")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -m32")
endif()

if ( ${CMAKE_SYSTEM_NAME} STREQUAL "Linux" )
    add_definitions(-DCRY_OSLINUX)
endif ()


if ( useGUI )
    message(STATUS "Building gui")
    add_definitions(-DCRY_GUI)
    add_definitions(-DCRY_USEWX)
    if ( WIN32 )
        SET(MINGW 1)
        SET(wxWidgets_ROOT_DIR "c:/wx3")
        SET(wxWidgets_LIB_DIR "c:/wx3/lib/gcc_dll")
        set(wxWidgets_CONFIGURATION mswu)
        FIND_PACKAGE(wxWidgets REQUIRED html stc adv core gl base scintilla)
    else ()
        FIND_PACKAGE(wxWidgets REQUIRED html stc adv core gl base)
    endif ()
    INCLUDE(${wxWidgets_USE_FILE})
    


    if(APPLE)
        add_definitions(-D__MAC__)
    elseif(UNIX)
        add_definitions(-D__GIL__)
    endif()
    
else()
    add_definitions(-DCRY_NOGUI)
    if(UNIX)
        add_definitions(-D__LIN__)
    endif()
endif()

if ( usePY )
    message(STATUS "Building the python crystals interface")
    add_definitions(-DCRY_PY)
endif()

if ( WIN32 )
    add_definitions(-DCRY_OSWIN32)
    add_definitions(-D__MIN__)
endif()

if ( APPLE )
    add_definitions(-DCRY_OSMAC)
endif()

if ( MSYS )
    add_definitions(-DCRY_OSWIN32)
endif()
add_definitions(-DCRY_GNU)

if( compileHDF5 )
    SET(useHDF5 ON)
endif ()
if(NOT useHDF5)
    add_definitions(-D_NOHDF5_)
else ()
    if(NOT compileHDF5 )
        find_package( HDF5 COMPONENTS Fortran REQUIRED )
        include_directories(${HDF5_INCLUDE_DIRS})
        link_libraries( ${HDF5_LIBRARIES} )
        message(STATUS "Using hdf5 libraries [${HDF5_LIBRARIES}]")
        message(STATUS "Using hdf5 include dir [${HDF5_INCLUDE_DIRS}]")
    else ()
        find_package(ZLIB REQUIRED)
    endif ()
endif ()

# Required to assign hollerith data in a legacy manner to integers
add_definitions(-D _HOL_)


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
string(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE)

# FFLAGS depend on the compiler
GET_FILENAME_COMPONENT (Fortran_COMPILER_NAME "${CMAKE_Fortran_COMPILER}" NAME)

IF (Fortran_COMPILER_NAME MATCHES "gfortran")  # gfortran
    if(useFAST)
        SET (CMAKE_Fortran_FLAGS_RELEASE "-fno-omit-frame-pointer -fno-f2c -O3 -g -march=native -Wfatal-errors -ftree-vectorize -flto -fwhole-program")
    else ()
        SET (CMAKE_Fortran_FLAGS_RELEASE "-fno-omit-frame-pointer -fno-f2c -O3 -g -Wfatal-errors -ftree-vectorize -msse2")
    endif ()
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-fno-omit-frame-pointer -fno-f2c -O0 -g -Wfatal-errors -Wall -Wextra")
    if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER "4.5")
        SET (CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fcheck=all")
    else ()
        SET (CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fbounds-check")
    endif()
    if(useFAST)
        SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fno-omit-frame-pointer -std=gnu++11 -O3 -g -march=native -ftree-vectorize -flto -fwhole-program")
        SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fno-omit-frame-pointer -O3 -g -march=native -ftree-vectorize -flto -fwhole-program")
    else ()
        SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fno-omit-frame-pointer -std=gnu++11 -O3 -g -ftree-vectorize -msse2")
        SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fno-omit-frame-pointer -O3 -g -ftree-vectorize -msse2")
    endif ()
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fno-omit-frame-pointer -std=gnu++11 -O1 -g")
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fno-omit-frame-pointer  -O1 -g")
ELSEIF ((Fortran_COMPILER_NAME MATCHES "ifort") OR (Fortran_COMPILER_NAME MATCHES "ifort.exe")) # ifort (untested)
    SET (CMAKE_Fortran_FLAGS_RELEASE "-debug -g -O3 -fpp -mkl")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-g -check all -debug all -ftrapuv -fpe0 -fstack-protector-all -O0 -fpp -mkl")
    SET (IFORT_COMPILER 1)
ELSEIF (Fortran_COMPILER_NAME MATCHES "g77")   # g77
    SET (CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fno-f2c -O3")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")
ELSE ()
    MESSAGE ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
    MESSAGE ("Fortran compiler: " ${Fortran_COMPILER_NAME})
    MESSAGE ("No optimized Fortran compiler flags are known, we just try -O2...")
    SET (CMAKE_Fortran_FLAGS_RELEASE "-O2")
    SET (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")
ENDIF ()



IF (${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} GREATER 3.0)
    check_fortran_compiler_flag("-std=legacy" _std_legacy_flag)
    check_fortran_compiler_flag("-fexceptions" _f_exceptions)
    check_fortran_compiler_flag("-fno-sign-zero" _f_no_signzero)

    if(_std_legacy_flag)
      set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -std=legacy")
      set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -std=gnu")
    endif()
    if(_f_exceptions)
      set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -fexceptions")
      set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fexceptions")
    endif()
    if(_f_no_signzero)
      set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -fno-sign-zero")
      set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fno-sign-zero")
    endif()
ELSE ()
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -std=legacy")
    set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -std=gnu")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -fexceptions")
    set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fexceptions")
    set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -fno-sign-zero")
    set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fno-sign-zero")
ENDIF ()

if( useGGDB3 )
    message(STATUS "Using dwarf3 debug format")
    SET(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -gdwarf-3")
    SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -gdwarf-3")
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -gdwarf-3")
    SET(CMAKE_Fortran_FLAGS_RELEASE   "${CMAKE_Fortran_FLAGS_RELEASE} -gdwarf-3")
    SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -gdwarf-3")
    SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -gdwarf-3")
endif ()

if(CMAKE_BUILD_TYPE MATCHES RELEASE)
    message("")
    message(STATUS "Compiling optimised version")
    message(STATUS "Fortran flags: ${CMAKE_Fortran_FLAGS_RELEASE}")
    message(STATUS "C flags: ${CMAKE_C_FLAGS_RELEASE}")
    message(STATUS "C++ flags: ${CMAKE_CXX_FLAGS_RELEASE}")
elseif(CMAKE_BUILD_TYPE MATCHES DEBUG)
    message("")
    message(STATUS "Compiling debugging version")
    message(STATUS "Fortran flags: ${CMAKE_Fortran_FLAGS_DEBUG}")
    message(STATUS "C flags: ${CMAKE_C_FLAGS_DEBUG}")
    message(STATUS "C++ flags: ${CMAKE_CXX_FLAGS_DEBUG}")
else ()
    message(FATAL_ERROR "Unknown build type ${CMAKE_BUILD_TYPE}")
endif ()
# Testing related directives for test coverage
#ENABLE_TESTING()
#INCLUDE(CTest)

# Libraries
ADD_SUBDIRECTORY(script)
IF ( NOT IFORT_COMPILER )
    IF ( useSLEEF )
        ADD_SUBDIRECTORY(sleef)
        SET (SLEEFTARGET CrystalsSleef)
        add_definitions(-DUSE_SLEEF)
    ENDIF ()
ENDIF()
ADD_SUBDIRECTORY(sginfo)
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

# Because external project call cmake externally too we need to pass the compiler and module path via cmake_args
if(compileHDF5)
    include(${CMAKE_ROOT}/Modules/ExternalProject.cmake)
    message("")
    message(STATUS "Building hdf5")

    find_package(ZLIB REQUIRED STATIC)
    
    set(HDF5_prefix "${CMAKE_BINARY_DIR}/hdf5")
    file(MAKE_DIRECTORY "${HDF5_prefix}")
    
    set(hdf5url "https://www.hdfgroup.org/package/cmake-unix/?wpdmdl=4301")

    #see http://hdf-forum.184993.n3.nabble.com/Compilation-of-HDF5-1-10-1-with-MSYS-and-MiNGW-td4029696.html
    ExternalProject_Add(
            hdf5_project
            URL ${hdf5url}
            DOWNLOAD_NAME "hdf5-1.10.1.tar.gz"
            CMAKE_ARGS -DSF_MODPATH=${SF_MODPATH} -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER} -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER} -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                            -DBUILD_SHARED_LIBS:Bool=OFF
                            -DBUILD_TESTING:Bool=OFF
                            -DHDF5_ENABLE_Z_LIB_SUPPORT:Bool=ON
                            -DHDF5_BUILD_HL_LIB:Bool=ON
                            -DHDF5_BUILD_TOOLS:Bool=OFF
                            -DCMAKE_INSTALL_PREFIX:PATH=${HDF5_prefix}
                            -DHDF5_BUILD_FORTRAN:BOOL=ON
                            -DHDF5_ENABLE_F2003:BOOL=ON
                            -DCMAKE_VERBOSE_MAKEFILE=ON
                            -DCMAKE_Fortran_FLAGS=-cpp
                            -G${CMAKE_GENERATOR}
             SOURCE_SUBDIR "../hdf5_project/hdf5-1.10.1/"
    )
    
    # move mod files so that crystals can find them when its been built
    ExternalProject_Add_Step(
        hdf5_project mvmod
        DEPENDEES  install
        DEPENDERS 
        ALWAYS 1
        COMMAND ${CMAKE_COMMAND} -E copy_directory  "${HDF5_prefix}/include/static" "${Fortran_MODULE_DIRECTORY}/"        
    )
    
    # fix h5Config_f.inc files on windows. No harm to do on other platforms
    ExternalProject_Add_Step(
        hdf5_project fixh5sa
        DEPENDEES configure
        DEPENDERS build
        COMMAND ${CMAKE_BINARY_DIR}/fixh5  ${CMAKE_BINARY_DIR}/hdf5_project-prefix/src/hdf5_project-build/H5config_f.inc
    )
    # fix H5fort_type_defines.h files on windows. No harm to do on other platforms
    ExternalProject_Add_Step(
        hdf5_project fixh5sb
        DEPENDEES configure
        DEPENDERS build
        COMMAND ${CMAKE_BINARY_DIR}/fixh5  ${CMAKE_BINARY_DIR}/hdf5_project-prefix/src/hdf5_project-build/fortran/H5fort_type_defines.h
    )
     

    set(HDF5_LIBRARY_DIR "${HDF5_prefix}/lib")
    set(HDF5_LIBRARY 
    "${HDF5_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}hdf5_fortran-static.a;${HDF5_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}hdf5_f90cstub-static.a;${HDF5_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}hdf5-static.a")
    set(HDF5_HL_LIBRARY 
    "${HDF5_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}hdf5_hl_fortran-static.a;${HDF5_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}hdf5_hl_f90cstub-static.a;${HDF5_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}hdf5_hl-static.a")

    set(HDF5_LIBRARIES "${HDF5_HL_LIBRARY};${HDF5_LIBRARY}")
    INCLUDE_DIRECTORIES("${HDF5_prefix}/include")

    message(STATUS "Using hdf5 libraries [${HDF5_LIBRARIES}]")
    

    message(STATUS "End Building hdf5")
endif()



add_dependencies(CameronFortran CrystalsFortran) 
if( compileHDF5 )
    add_dependencies(CrystalsFortran hdf5_project) 
endif ()

# Executables
get_property(value DIRECTORY PROPERTY COMPILE_DEFINITIONS)
if (value)
   foreach(item ${value})
       list(APPEND flags "-D${item}")
   endforeach()
endif()

message( STATUS "Defines: ${value}" )
message( STATUS "Flags: ${flags}" )


ADD_CUSTOM_COMMAND ( OUTPUT commands.dsc COMMAND ${CMAKE_COMMAND} -E copy datafiles/commands.dsc . DEPENDS subdscbuild )
if( useHDF5 )
    ADD_CUSTOM_COMMAND ( OUTPUT commands.h5 COMMAND ${CMAKE_COMMAND} -E copy datafiles/commands.h5 . DEPENDS subh5build )
endif ()
#ADD_CUSTOM_COMMAND ( OUTPUT commands.dsc COMMAND ${CMAKE_COMMAND} -E copy datafiles/commands.dsc . DEPENDS subdscbuild ${CMAKE_BINARY_DIR}/datafiles/commands.dsc )

# Script file sources and targets
FILE (GLOB sscfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.ssc")
SET  (scpfiles)
FOREACH (_file ${sscfiles})
    STRING(REPLACE ".ssc" ".scp" file_scp ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_scp}
                        COMMAND ${PERL_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_scp} ${flags} -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
                        DEPENDS ${_file} )
    LIST(APPEND scpfiles ${file_scp})
ENDFOREACH()







# Data file sources and targets

FILE (GLOB sdafiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.sda")
SET  (datfiles)
FOREACH (_file ${sdafiles})
    STRING(REPLACE ".sda" ".dat" file_dat ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_dat}
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_dat} ${flags} -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
    DEPENDS ${_file} )
    LIST(APPEND datfiles ${file_dat})
ENDFOREACH()

FILE (GLOB ssrfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/datafiles" "${CMAKE_CURRENT_SOURCE_DIR}/datafiles/*.ssr")
SET  (srtfiles)
FOREACH (_file ${ssrfiles})
    STRING(REPLACE ".ssr" ".srt" file_srt ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_srt}
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_srt} ${flags} -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/datafiles/${_file}
                        DEPENDS datafiles/${_file} )
    LIST(APPEND srtfiles ${file_srt})
ENDFOREACH()

if ( useGUI )
    INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR}/crys_fortran)
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} $<TARGET_OBJECTS:CrystalsUserInterface> ${CMAKE_SOURCE_DIR}/gui/fwrapper_gui.F90 ${CMAKE_SOURCE_DIR}/gui/fwrapperimp_gui.F90 gui/gcrystals.cc crystals/crystals.F)
    ADD_EXECUTABLE (crystalscl ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals-cl.F ${CMAKE_SOURCE_DIR}/gui/fwrapperimp_cl.F90 )

    if(MSYS)
        SET(OPENGL_INCLUDE_DIR "/mingw64/x86_64-w64-mingw32/include/")
        SET(OPENGL_gl_LIBRARY "/mingw64/bin/")
        SET(MSYS2LIBS  "-lstdc++ -lopengl32  -lglu32 -llzma" )
    else ()
        SET(MSYS2LIBS  "" )
    endif()
    find_package(OpenGL REQUIRED)
    message(STATUS "Using OpenGL libraries: ${OPENGL_LIBRARIES}")
    include_directories( ${OPENGL_INCLUDE_DIRS}  )
    target_link_libraries(crystals ${OPENGL_LIBRARIES} )

    TARGET_LINK_LIBRARIES(crystals ${SLEEFTARGET} CrystalsFortran CameronFortran ${wxWidgets_LIBRARIES} ${MSYS2LIBS})
    SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_GUI)
    SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} )    
    
#    SET_TARGET_PROPERTIES(crystalscl PROPERTIES LINKER_LANGUAGE Fortran)
    TARGET_LINK_LIBRARIES(crystalscl ${SLEEFTARGET} CrystalsFortran CameronFortran)
#    SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_NOGUI)

elseif( usePY )
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals.F)
    SET_TARGET_PROPERTIES(crystals PROPERTIES LINKER_LANGUAGE Fortran)
    TARGET_LINK_LIBRARIES(crystals ${SLEEFTARGET} CrystalsFortran CameronFortran )
else()
    ADD_EXECUTABLE (crystals ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals.F)
    SET_TARGET_PROPERTIES(crystals PROPERTIES LINKER_LANGUAGE Fortran)
    TARGET_LINK_LIBRARIES(crystals ${SLEEFTARGET} CrystalsFortran CameronFortran)
    SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_NOGUI)
endif()


IF (IFORT_COMPILER)
    SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_FORTINTEL)
ENDIF()

if(OpenBLAS_LIBRARY)
    TARGET_LINK_LIBRARIES(crystals ${OpenBLAS_LIBRARY})
  if ( useGUI )
    TARGET_LINK_LIBRARIES(crystalscl ${OpenBLAS_LIBRARY})
  endif ()
endif ()

if( useHDF5 )
  if( WIN32 )
    TARGET_LINK_LIBRARIES(crystalscl "${HDF5_LIBRARIES}")
    TARGET_LINK_LIBRARIES(crystals "${HDF5_LIBRARIES}")
  else ()
    TARGET_LINK_LIBRARIES(crystalscl "${HDF5_LIBRARIES};dl")
    TARGET_LINK_LIBRARIES(crystals "${HDF5_LIBRARIES};dl")
  endif ()
  TARGET_LINK_LIBRARIES(crystalscl ${ZLIB_LIBRARIES})
  TARGET_LINK_LIBRARIES(crystals  ${ZLIB_LIBRARIES})
  ADD_CUSTOM_TARGET ( h5build ALL DEPENDS commands.h5 crystals )
  ADD_CUSTOM_TARGET ( h5startups ALL DEPENDS h5build ${srtfiles} )
endif ()

ADD_CUSTOM_TARGET ( startups ALL DEPENDS dscbuild ${srtfiles} )
ADD_CUSTOM_TARGET ( dscbuild ALL DEPENDS commands.dsc crystals )

# Unit testing
ADD_SUBDIRECTORY(pFunit)


