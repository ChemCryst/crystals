


cmake_minimum_required(VERSION 3.0)

project(Scripts)

get_target_property(_if_compile_defs GeneralDefines INTERFACE_COMPILE_DEFINITIONS)


set(defstring)
foreach(_def ${_if_compile_defs})
   set( defstring ${defstring} -D${_def})
endforeach()


# Script file sources and targets
FILE (GLOB sscfiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/*.ssc")
SET  (scpfiles)
FOREACH (_file ${sscfiles})
    STRING(REPLACE ".ssc" ".scp" file_scp ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_scp}
                        COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_scp} ${defstring} -DCRYSVNVER=${CRYSVNVER} -DCRYVERSUM=${CRYVERSUM} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
                        DEPENDS ${_file} )
    LIST(APPEND scpfiles ${file_scp})
ENDFOREACH()

FILE (GLOB sdafiles RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/*.sda")
SET  (datfiles)
FOREACH (_file ${sdafiles})
    STRING(REPLACE ".sda" ".dat" file_dat ${_file})
    ADD_CUSTOM_COMMAND( OUTPUT ${file_dat}
                        COMMAND perl ${CMAKE_SOURCE_DIR}/editor/filepp.pl -ds -w -imacros ${CMAKE_SOURCE_DIR}/gui/crystalsinterface.h -o ${file_dat} ${defstring} -DCRYSVNVER=${CRYSVNVER} -DCRYMONTH=${CRYMONTH} -DCRYYEAR=${CRYYEAR} -DCRYVERSUM=${CRYVERSUM} ${CMAKE_CURRENT_SOURCE_DIR}/${_file}
    DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/${_file} )
    LIST(APPEND datfiles ${file_dat})
ENDFOREACH()



# Data file sources and targets
FILE (GLOB pyfiles "${CMAKE_CURRENT_SOURCE_DIR}/*.py")
SET  (pyoutfiles)
FOREACH (_file ${pyfiles})
    get_filename_component(pyfile "${_file}" NAME)
    message(STATUS "Generating ${pyfile}")
    ADD_CUSTOM_COMMAND( OUTPUT ${pyfile}
                COMMAND ${CMAKE_COMMAND} -E copy_if_different "${_file}" "${pyfile}"
                COMMENT "Copying py script file: ${_file} to ${pyfile}"
				DEPENDS ${_file} )
    LIST(APPEND pyoutfiles ${pyfile})
ENDFOREACH()



add_library(CrystalsScripts INTERFACE ${scpfiles} ${pyoutfiles} ${datfiles})
target_link_libraries(CrystalsScripts INTERFACE GeneralDefines)
