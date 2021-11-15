


cmake_minimum_required(VERSION 3.0)

project(Scripts)



get_target_property(_if_compile_defs CrystalsDefines INTERFACE_COMPILE_DEFINITIONS)
set(defstring)
foreach(_def ${_if_compile_defs})
   list( APPEND defstring -D${_def})
endforeach()

# Script file sources and targets
FILE (GLOB sscfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/*.ssc")
SET  (scpfiles)
FOREACH (_file ${sscfiles})
    STRING(REPLACE ".ssc" ".scp" file_scp ${_file})
    SET( arguments -ds -w -imacros ${CMAKE_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_scp} -DCRYARCH=${CRYARCH} -DCRYHOST=${CRYHOST} -DCRYSVNVER=${CRYSVNVER} -DCRYVERSUM=${CRYVERSUM} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} )
    list(APPEND arguments ${defstring})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_scp}
                        COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/editor/filepp.pl ${arguments} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
                        DEPENDS ${_file} 
                        COMMENT "${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/editor/filepp.pl ${arguments} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}")
    LIST(APPEND scpfiles ${file_scp})
ENDFOREACH()

FILE (GLOB sdafiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/*.sda")
SET  (datfiles)
FOREACH (_file ${sdafiles})
    STRING(REPLACE ".sda" ".dat" file_dat ${_file})
    SET( arguments -ds -w -imacros ${CMAKE_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_dat} -DCRYARCH=${CRYARCH} -DCRYHOST=${CRYHOST} -DCRYSVNVER=${CRYSVNVER} -DCRYVERSUM=${CRYVERSUM} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} )
    list(APPEND arguments ${defstring})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_dat}
                        COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/editor/filepp.pl ${arguments} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
                        DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_file} 
                        COMMENT "${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/editor/filepp.pl ${arguments} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}")
    LIST(APPEND datfiles ${file_dat})
ENDFOREACH()

#FILE (GLOB pyfiles "${CMAKE_CURRENT_SOURCE_DIR}/*.py")
#foreach(_file IN LISTS pyfiles)
#    add_custom_command(
#                TARGET PyFileTarget PRE_BUILD
#                COMMAND ${CMAKE_COMMAND} -E copy_if_different ${_file} .
#                COMMENT "Copying header: ${_file}")
#endforeach()



file(GLOB templateFiles RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*.py)
foreach(templateFile ${templateFiles})
	set(srcTemplatePath ${CMAKE_CURRENT_SOURCE_DIR}/${templateFile})
	if(NOT IS_DIRECTORY ${srcTemplatePath})
		message(STATUS "Configuring file ${templateFile}")
		configure_file(
				${srcTemplatePath}
				${templateFile}
				COPYONLY)
	endif(NOT IS_DIRECTORY ${srcTemplatePath})
endforeach(templateFile)


# Data file sources and targets
#FILE (GLOB pyfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/*.py")
#message( STATUS "Pyfiles ${pyfiles}" )
#SET  (pyoutfiles)
#FOREACH (_file ${pyfiles})
##    get_filename_component(pyfile "${_file}" NAME)
#    set( pyfile ${_file} )
##    message(STATUS "Generating ${pyfile}")
#    ADD_CUSTOM_COMMAND( OUTPUT ${CMAKE_CURENT_BINARY_DIR}${pyfile}
#                COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_file}" "${pyfile}"
#                COMMENT "Copying py script file: ${_file} to ${pyfile}"
#				DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_file} )
#    LIST(APPEND pyoutfiles ${CMAKE_CURENT_BINARY_DIR}${pyfile} )
#ENDFOREACH()



add_library(CrystalsScripts INTERFACE ${scpfiles} ${datfiles})
target_link_libraries(CrystalsScripts INTERFACE CrystalsDefines)
