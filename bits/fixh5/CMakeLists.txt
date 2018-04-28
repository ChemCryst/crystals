PROJECT(fixh5)
message("")
message(STATUS "Building fixh5")

enable_language(Fortran)


set (EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

# Executables

# Reset flags
set(CMAKE_Fortran_FLAGS "")
set(CMAKE_C_FLAGS "")


add_executable (fixh5 fixh5.F90 )

message(STATUS "End building fixh5")


message("")



