

enable_language(Fortran)

if ( useGUI )
#add_definitions(-D_GIL_)
#add_definitions(-D__WXMAC__)
#add_definitions(-D__WXOSX__)
#add_definitions(-D__WXOSX_COCOA__)
add_definitions(-D__WXUSINGDLL)
endif()

add_definitions(-D_GNUF77_)
add_definitions(-std=legacy)
#add_definitions(-I/Users/richard.cooper/crystals/crystals)
add_definitions(-I\"${CMAKE_CURRENT_SOURCE_DIR}/../crystals\")
add_definitions(-I\"${CMAKE_CURRENT_BINARY_DIR}/../crys_fortran\")

add_definitions(-std=legacy)
add_definitions(-fno-automatic)
add_definitions(-fno-inline)
add_definitions(-fexceptions)
add_definitions(-D _HOL_)
#add_definitions(-arch x86_64)


add_library(CameronFortran STATIC 
altered.F
block.F
button.F
ccontrol.F
comm.F
cspecific.F
duplicat.F
general.F
graphics.F
maths1.F
maths2.F
mouse.F
outer.F
vander.F
wincode.F
)
