

enable_language(Fortran)


add_definitions(-DCRY_PY)

include_directories(../crystals)

add_library(CrystalsPyInterface STATIC
cinterface.c
cryspy.F
)


