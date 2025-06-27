
cmake_minimum_required(VERSION 3.1)

project(Crystals)

set(CMAKE_COLOR_MAKEFILE ON)

# -------------------- Options --------------------

option(verbose "verbose" OFF)
option(useGUI "useGUI" ON)
option(useCustomMKL "useCustomMKL" OFF)
option(usePY "usePY" OFF)
option(use32 "use32" OFF)
option(useSTATIC "useSTATIC" OFF)
option(useOPENMP "useOPENMP" ON)
option(useHDF5 "useHDF5" OFF) # hdf5 storage, use system library
option(compileHDF5 "compileHDF5" OFF) # hdf5 storage, download and compile hdf5
option(useGGDB3 "useGGDB3" OFF) # used for orion (old dgb)
option(usepFUnit "usepFUnit" OFF)
option(useFAST "useFAST" OFF)
option(withSUPERFLIP "withSUPERFLIP" OFF)
option(withEDMA "withEDMA" OFF)

if(verbose)
    set(CMAKE_VERBOSE_MAKEFILE ON)
endif ()

# -------------------- Directories --------------------

set( Fortran_MODULE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules" )
message(STATUS "Modules saved at [${CMAKE_BINARY_DIR}/FortranModules]")
include_directories(${Fortran_MODULE_DIRECTORY})
file(MAKE_DIRECTORY "${CMAKE_BINARY_DIR}/FortranModules")


# -------------------- Static Build --------------------
if(useSTATIC)
    set( CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    set( BUILD_SHARED_LIBRARIES OFF)
    set( CMAKE_EXE_LINKER_FLAGS "-static")
    set( wxWidgets_USE_STATIC ON)
    set( wxSTATICEXTRA_LIBS "-loleacc -luxtheme")
    message( STATUS "Building static version")
endif ()

# -------------------- Languages and Packages --------------------
enable_language(Fortran C CXX)
include(CPack)
include(CheckFortranCompilerFlag)


# -------------------- Platform Detection --------------------
if(${CMAKE_SYSTEM_NAME} MATCHES "MINGW64_NT" OR ${CMAKE_SYSTEM_NAME} MATCHES "MINGW32_NT")
    message( STATUS "Building using MSYS2, Mingw64 toolchain")
    set( MSYS ON)
endif()

# -------------------- Compiler Version Checks --------------------
if(CMAKE_COMPILER_IS_GNUCC)
  exec_program(
      ${CMAKE_C_COMPILER}
      ARGS                    --version
      OUTPUT_VARIABLE _compiler_output)
  message(STATUS "C compiler version: ${CMAKE_C_COMPILER_VERSION} [${CMAKE_C_COMPILER}]")

  if(CMAKE_C_COMPILER_VERSION VERSION_LESS 4.6)
      message(FATAL_ERROR "Your C compiler is too old")
  elseif(CMAKE_C_COMPILER_VERSION VERSION_LESS 4.6)
      message(WARNING "Your C compiler might be too old")
  endif()

  exec_program(
      ${CMAKE_CXX_COMPILER}
      ARGS                    --version
      OUTPUT_VARIABLE _compiler_output)
  message( STATUS "C++ compiler version: ${CMAKE_CXX_COMPILER_VERSION} [${CMAKE_CXX_COMPILER}]")

  if( CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.6)
      message(FATAL_ERROR "Your C compiler is too old")
  elseif(CMAKE_CXX_COMPILER_VERSION VERSION_LESS 4.6)
      message(WARNING "Your C++ compiler might be too old")
  endif ()

  exec_program(
      ${CMAKE_Fortran_COMPILER}
      ARGS                    --version
      OUTPUT_VARIABLE _compiler_output)
  message( STATUS "Fortran compiler version: ${CMAKE_Fortran_COMPILER_VERSION} [${CMAKE_Fortran_COMPILER}]")

  if(CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 4.6)
      message( FATAL_ERROR "Your Fortran compiler is too old")
  elseif(CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 4.6)
      message( WARNING "Your Fortran compiler might be too old")
  endif ()
endif ()

# FFLAGS depend on the compiler
get_filename_component(Fortran_COMPILER_NAME "${CMAKE_Fortran_COMPILER}" NAME)

if ((Fortran_COMPILER_NAME MATCHES "ifort") OR (Fortran_COMPILER_NAME MATCHES "ifort.exe")) # ifort (untested)
    message(WARNING "Using Intel Fortran compiler.")
    set (IFORT_COMPILER 1)
endif()

if ((Fortran_COMPILER_NAME MATCHES "ifx") OR (Fortran_COMPILER_NAME MATCHES "ifx.exe")) # ifort (untested)
    message(WARNING "Using Intel IFX Fortran compiler.")
    set (IFX_COMPILER 1)
endif()

# -------------------- Perl --------------------
find_package( Perl REQUIRED)
if( PERL_FOUND )
    message( STATUS "Perl executable: [${PERL_EXECUTABLE}]")
endif()

# -------------------- BLAS/LAPACK/MKL --------------------
if ( useCustomMKL ) 

    message(STATUS "Using Custom MKL library: ./mkl_custom.lib")
    link_libraries ( "mkl_custom.lib" )  
    link_directories( ${CMAKE_BINARY_DIR} )
  
else()

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
            message(STATUS "Using builtin BLAS and LAPACK library")
            add_definitions(-DCRY_OWNLAPACK)
        endif ()
    endif()
endif ()

if(BLA_VENDOR)
	string(TOUPPER ${BLA_VENDOR} TEMP)
	if(TEMP MATCHES "INTEL")
		add_definitions(-DCRY_MKL)
	endif()
endif ()

# -------------------- Compiler Flags --------------------
set( CMAKE_Fortran_FLAGS "")
set( CMAKE_C_FLAGS "")
set( CMAKE_CXX_FLAGS "")

if( useOPENMP )
    find_package( OpenMP )
    if ( OPENMP_FOUND )
        set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
        set ( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        set ( CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${OpenMP_Fortran_FLAGS}")
    endif()
endif ()

if ( use32 )
    message(STATUS "Building 32bit")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32")
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32")
    set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -m32")
endif()

# -------------------- Platform Definitions --------------------
if ( ${CMAKE_SYSTEM_NAME} STREQUAL "Linux" )
    add_definitions(-DCRY_OSLINUX)
endif ()


# -------------------- GUI and WX --------------------
if ( useGUI )
    message(STATUS "Building gui")
    add_definitions(-DCRY_GUI)
    add_definitions(-DCRY_USEWX)
    if ( WIN32 )
        find_package(wxWidgets REQUIRED html stc adv core gl base scintilla)
    else ()
        find_package(wxWidgets REQUIRED html stc adv core gl base)
    endif ()
    include(${wxWidgets_USE_FILE})



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

# -------------------- Python Interface --------------------
if ( usePY )
    message(STATUS "Building the python crystals interface")
    add_definitions(-DCRY_PY)
endif()

# -------------------- OS Definitions --------------------
if ( WIN32 )
    add_definitions(-DCRY_OSWIN32)
    if ( IFORT_COMPILER OR IFX_COMPILER )
        add_definitions(-D__INW__)
    else ()
        add_definitions(-D__MIN__)
    endif()
endif()

if ( APPLE )
    add_definitions(-DCRY_OSMAC)
endif()

if ( MSYS )
    add_definitions(-DCRY_OSWIN32)
endif()

add_definitions(-D_NOHDF5_)

# -------------------- Misc Definitions --------------------
# F77: Required to assign hollerith data in a legacy manner to integers
add_definitions(-D _HOL_)

string(TIMESTAMP CRYYEAR "%Y")
string(TIMESTAMP CRYMONTH "%b")
string(TIMESTAMP CRYDAY "%d")

set (CRYVMAJOR "$ENV{CRYVMAJOR}")
if  ("${CRYVMAJOR}" STREQUAL "" ) 
    MESSAGE("CRYVMAJOR Version major not set - using ... 10")
	set (CRYVMAJOR "10")
endif()	

set (CRYVMINOR "$ENV{CRYVMINOR}")
if  ("${CRYVMINOR}" STREQUAL "" ) 
    MESSAGE("CRYVMINOR Version minor not set - using ... 1")
	set (CRYVMINOR "1")
endif()	

set (CRYVPATCH "$ENV{CRYVPATCH}")
if  ("${CRYVPATCH}" STREQUAL "" ) 
    MESSAGE("CRYVPATCH Version patch not set - using ... 100")
	set (CRYVPATCH "100")
endif()	

math(EXPR CRYVERSUM "(${CRYVMAJOR} * 100000 ) + ( ${CRYVMINOR} * 1000 ) + ${CRYVPATCH}") 

set (CRYSVNVER "$ENV{CRYSVNVER}")
set (CRYHOST "${CMAKE_SYSTEM_NAME}")


if("${CMAKE_SIZEOF_VOID_P}" EQUAL "8")
    MESSAGE("++ 64 bit architecture")
    if(use32)
        set(CRYARCH "x86")
    else ()
        set(CRYARCH "x86_64")
    endif ()
else()
    set(CRYARCH "x86")
endif()

if( NOT CRYSVNVER)  # not set
    if( ${CMAKE_SYSTEM_NAME} STREQUAL "Linux" )
        EXECUTE_PROCESS(COMMAND svnversion ${CMAKE_SOURCE_DIR} OUTPUT_VARIABLE CRYSVNVER OUTPUT_STRIP_TRAILING_WHITESPACE)
        # `:` is a special character in crystals.srt
        STRING(REPLACE ":" "%" CRYSVNVER "${CRYSVNVER}")
        STRING(SUBSTRING "${CRYSVNVER}" 0 8 CRYSVNVER)
        if ( "${CRYSVNVER}" STREQUAL "" )   # svnversion command failed
           set( CRYSVNVER "0000" )
        endif()
    else()
        set(CRYSVNVER "0000")
    endif()
    message(STATUS "Svn version: ${CRYSVNVER}")
endif()
message(STATUS "Compilation date = ${CRYDAY} / ${CRYMONTH} / ${CRYYEAR}")

if(NOT CMAKE_BUILD_TYPE)   # make sure that the default is a RELEASE
    set(CMAKE_BUILD_TYPE RELEASE CACHE STRING
         "Choose the type of build, options are: None Debug Release."  FORCE)
endif()
string(TOUPPER ${CMAKE_BUILD_TYPE} CMAKE_BUILD_TYPE)



# -------------------- Compiler Flags by Compiler --------------------
if(Fortran_COMPILER_NAME MATCHES "gfortran")  # gfortran

    add_definitions(-DCRY_GNU)

    if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 10)
        set(MISMATCH_FLAG "-fallow-argument-mismatch")
    else ()
        set(MISMATCH_FLAG "")
    endif ()

    if(useFAST)
        set(CMAKE_Fortran_FLAGS_RELEASE "-fno-f2c -O3 -g -march=native -Wfatal-errors -ftree-vectorize -flto -fwhole-program ${MISMATCH_FLAG}")
    else ()
        set(CMAKE_Fortran_FLAGS_RELEASE "-fno-f2c -O3 -g -Wfatal-errors -ftree-vectorize -msse2 -w ${MISMATCH_FLAG}")
    endif ()
    set(CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g -Wfatal-errors -Wall -Wextra ${MISMATCH_FLAG}")
    if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER 4.5)
        set (CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fcheck=all ${MISMATCH_FLAG}")
    else ()
        set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -fbounds-check")
    endif()
    if(useFAST)
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -std=gnu++11 -O3 -g -march=native -ftree-vectorize -flto -fwhole-program")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -g -march=native -ftree-vectorize -flto -fwhole-program")
    else ()
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -std=gnu++11 -O3 -g -ftree-vectorize -msse2")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -g -ftree-vectorize -msse2")
    endif ()
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -std=gnu++11 -O1 -g")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O1 -g")

    if ( WIN32 )

		ENABLE_LANGUAGE(RC)
	#    set(_WINDRES_INCLUDE_DIRS -I${CMAKE_CURRENT_SOURCE_DIR})
		foreach(wx_include_dir ${wxWidgets_INCLUDE_DIRS})
			set(_WINDRES_INCLUDE_DIRS "${_WINDRES_INCLUDE_DIRS} -I${wx_include_dir}")
		endforeach(wx_include_dir ${wxWidgets_INCLUDE_DIRS})
		set(CMAKE_RC_COMPILER_INIT windres)
		set(CMAKE_RC_COMPILE_OBJECT
		"<CMAKE_RC_COMPILER> -O coff <DEFINES> -i <SOURCE> -o <OBJECT> ${_WINDRES_INCLUDE_DIRS}")

		message(STATUS ${CMAKE_RC_COMPILE_OBJECT})

    endif()

elseif( IFORT_COMPILER ) # ifort (untested)

  if(UNIX)

	    set (CMAKE_Fortran_FLAGS_RELEASE "-debug all -g -O3 -fpp -mkl -diag-disable:8291 -traceback")
	    set (CMAKE_Fortran_FLAGS_DEBUG   "-g -check all -debug all -ftrapuv -fpe0 -fstack-protector-all -O0 -fpp -mkl -diag-disable:8291 -check uninit -traceback -check nooutput_conversion")

  else()

	    set(CMAKE_Fortran_FLAGS_RELEASE "-O3 -fpp -MD /heap-arrays:8 -Qdiag-disable:8291 -traceback -QaxSSE2")
	    set(CMAKE_Fortran_FLAGS_DEBUG   "-check:all -MDd /heap-arrays:8 -debug:all -Qtrapuv -fpe0 -fpp -warn:nofileopt -Qdiag-disable:8291 -Qdiag-disable:8290 -check:format -check:overflow -check:pointers -check:noarg_temp_created -check:uninit -traceback -check:nooutput_conversion")
    	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}  /O2  /EHs /W3 /Oy- ")
    	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /EHs /W3 /Oy- ")
    	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}  /O2 /EHs /W3 /Oy- ")
    	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}  /EHs /W3 /Oy- ")

	    add_definitions(-DWIN32)
	    add_definitions(-DWXUSINGDLL)
	    add_definitions(-D_WINDOWS)
	    add_definitions(-D_UNICODE)
	    add_definitions(-D__WXMSW__)
	    add_definitions(-D_CRT_SECURE_NO_WARNINGS)

	    set(CMAKE_CXX_LINK_EXECUTABLE "ifort <OBJECTS>  -o <TARGET> <LINK_LIBRARIES> /link <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS>")

    endif()

	add_definitions(-DCRYSVNVER=${CRYSVNVER})

    if(CMAKE_BUILD_TYPE MATCHES Debug)
		add_definitions(-DDEBUG)
	else()
		add_definitions(-DNDEBUG)
	endif()

	include_directories(gui)

elseif( IFX_COMPILER ) # ifx (untested)

    set(CMAKE_Fortran_FLAGS_RELEASE "/O3 /fpp /MD  /heap-arrays:8 /traceback /Qdiag-disable:8291")
    set(CMAKE_Fortran_FLAGS_DEBUG   "/Od /fpp /MDd /heap-arrays:8 /traceback /Qdiag-disable:8291 /Qdiag-disable:8290 /warn:nofileopt /debug:all /fpe:0 /check:all,noarg_temp_created,nooutput_conversion" )
# NB the supressed checks: noarg_temp_created,nooutput_conversion hide warnings about temporary array copies in argument lists and numbers exceeding field width in format statements
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}  /O2  /EHs /W3 /Oy- ")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /EHs /W3 /Oy- ")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}  /O2 /EHs /W3 /Oy- ")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}  /EHs /W3 /Oy- ")

    add_definitions(-DWIN32)
    add_definitions(-DWXUSINGDLL)
    add_definitions(-D_WINDOWS)
    add_definitions(-D_UNICODE)
    add_definitions(-D__WXMSW__)
    add_definitions(-D_CRT_SECURE_NO_WARNINGS)

    set(CMAKE_CXX_LINK_EXECUTABLE "icx -fortlib <OBJECTS>  -o <TARGET> <LINK_LIBRARIES> /link <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS>")

	add_definitions(-DCRYSVNVER=${CRYSVNVER})

    if(CMAKE_BUILD_TYPE MATCHES Debug)
		add_definitions(-DDEBUG)
	else()
		add_definitions(-DNDEBUG)
	endif()

	include_directories(gui)

elseif(Fortran_COMPILER_NAME MATCHES "g77")   # g77

    add_definitions(-DCRY_GNU)
    set(CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fno-f2c -O3")
    set(CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")

else()

    message("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
    message("Fortran compiler: " ${Fortran_COMPILER_NAME})
    message("No optimized Fortran compiler flags are known, we just try -O2...")
    set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
    set(CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")

endif()


# -------------------- Fortran Compiler Feature Checks --------------------
check_fortran_compiler_flag("-std=legacy" _std_legacy_flag)
check_fortran_compiler_flag("-fexceptions" _f_exceptions)
check_fortran_compiler_flag("-fno-sign-zero" _f_no_signzero)

if(_std_legacy_flag)
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

if( useGGDB3 )
    message(STATUS "Using dwarf3 debug format")
    set(CMAKE_Fortran_FLAGS_DEBUG   "${CMAKE_Fortran_FLAGS_DEBUG} -gdwarf-3")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -gdwarf-3")
    set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -gdwarf-3")
    set(CMAKE_Fortran_FLAGS_RELEASE   "${CMAKE_Fortran_FLAGS_RELEASE} -gdwarf-3")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -gdwarf-3")
    set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -gdwarf-3")
endif ()

# -------------------- Build Type Messages --------------------
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
    message("")
    message(FATAL_ERROR "Unknown build type ${CMAKE_BUILD_TYPE}")
endif ()

# -------------------- Subdirectories --------------------
add_subdirectory(manual)
add_subdirectory(script)
add_subdirectory(sginfo)
add_subdirectory(crystals crys_fortran)
add_subdirectory(cameron)
add_subdirectory(datafiles)
add_subdirectory(precomp)
add_subdirectory(bits)

if ( useGUI )
    add_subdirectory(gui)
endif()

if ( usePY )
    add_subdirectory(pyinterface)
endif()

add_dependencies(CameronFortran CrystalsFortran)

# --- Grab definitions for data file / script generation ---

get_property(value DIRECTORY PROPERTY COMPILE_DEFINITIONS)
if (value)
   foreach(item ${value})
       list(APPEND flags "-D${item}")
   endforeach()
endif()

message( STATUS "Defines: ${value}" )
message( STATUS "Flags: ${flags}" )


add_custom_command ( OUTPUT commands.dsc COMMAND ${CMAKE_COMMAND} -E copy datafiles/commands.dsc . DEPENDS subdscbuild )

# -------------------- Script files ------------------

file (GLOB sscfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.ssc")
set  (scpfiles)
foreach (_file ${sscfiles})
    string(REPLACE ".ssc" ".scp" file_scp ${_file})
    add_custom_command( OUTPUT ${file_scp}
                        COMMAND ${PERL_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_scp} ${flags} -DCRYSVNVER=${CRYSVNVER} -DCRYVERSUM=${CRYVERSUM} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
                        DEPENDS ${_file} )
    list(APPEND scpfiles ${file_scp})
endforeach()


# -------------------- Data files --------------------

file(GLOB sdafiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/script/*.sda")
set(datfiles)
foreach(_file ${sdafiles})
    string(REPLACE ".sda" ".dat" file_dat ${_file})
    add_custom_command( OUTPUT ${file_dat}
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_dat} ${flags} -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} -DCRYVERSUM=${CRYVERSUM} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
    DEPENDS ${_file} )
    list(APPEND datfiles ${file_dat})
endforeach()

file(GLOB ssrfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}/datafiles" "${CMAKE_CURRENT_SOURCE_DIR}/datafiles/*.ssr")
set(srtfiles)
foreach(_file ${ssrfiles})
    string(REPLACE ".ssr" ".srt" file_srt ${_file})
    add_custom_command( OUTPUT ${file_srt}
                        COMMAND perl ${CMAKE_CURRENT_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_CURRENT_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_srt} ${flags} -DCRYARCH=${CRYARCH} -DCRYHOST=${CRYHOST} -DCRYSVNVER=${CRYSVNVER} -DCRYVERSUM=${CRYVERSUM} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/datafiles/${_file}
                        DEPENDS datafiles/${_file} )
    list(APPEND srtfiles ${file_srt})
endforeach()

# -------------------- Executables and Linking --------------------

if ( useGUI )
    include_directories(${CMAKE_BINARY_DIR}/crys_fortran)
    add_executable(crystals WIN32 ${scpfiles} ${datfiles} ${srtfiles} $<TARGET_OBJECTS:CrystalsUserInterface> ${CMAKE_SOURCE_DIR}/gui/fwrapper_gui.F90 ${CMAKE_SOURCE_DIR}/gui/fwrapperimp_gui.F90 gui/gcrystals.cpp crystals/crystals.F gui/wx.rc)
    add_executable(crystalscl ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals-cl.F ${CMAKE_SOURCE_DIR}/gui/fwrapperimp_cl.F90 )

    if(MSYS)
        set(OPENGL_INCLUDE_DIR "/mingw64/x86_64-w64-mingw32/include/")
        set(OPENGL_gl_LIBRARY "/mingw64/bin/")
        set(MSYS2LIBS  "-lstdc++ -lopengl32  -lglu32 -llzma" )
    else ()
        set(MSYS2LIBS  "" )
    endif()
    find_package(OpenGL REQUIRED)
    message(STATUS "Using OpenGL libraries: ${OPENGL_LIBRARIES}")
    include_directories( ${OPENGL_INCLUDE_DIRS}  )
    target_link_libraries(crystals ${OPENGL_LIBRARIES} )


    target_link_libraries(crystals CrystalsFortran CameronFortran ${wxWidgets_LIBRARIES} ${MSYS2LIBS} ${wxSTATICEXTRA_LIBS})
    set_target_properties(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_GUI)
    set_target_properties(CrystalsFortran PROPERTIES Fortran_MODULE_DIRECTORY ${Fortran_MODULE_DIRECTORY} )
    target_link_libraries(crystalscl CrystalsFortran CameronFortran)

elseif( usePY )
    add_executable (crystals ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals.F)
    set_target_properties(crystals PROPERTIES LINKER_LANGUAGE Fortran)
    target_link_libraries(crystals CrystalsFortran CameronFortran )
else()
    add_executable(crystals ${scpfiles} ${datfiles} ${srtfiles} crystals/crystals.F)
    set_target_properties(crystals PROPERTIES LINKER_LANGUAGE Fortran)
    target_link_libraries(crystals CrystalsFortran CameronFortran)
    set_target_properties(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_NOGUI)
endif()


if(IFORT_COMPILER OR IFX_COMPILER)
    set_target_properties(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_FORTINTEL)
endif()

if(OpenBLAS_LIBRARY)
    target_link_libraries(crystals ${OpenBLAS_LIBRARY})
    if ( useGUI )
        target_link_libraries(crystalscl ${OpenBLAS_LIBRARY})
    endif ()
endif ()

add_custom_target( startups ALL DEPENDS dscbuild ${srtfiles} )
add_custom_target( dscbuild ALL DEPENDS commands.dsc crystals )

