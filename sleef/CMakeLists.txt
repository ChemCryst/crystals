

enable_language(Fortran)

add_library(CrystalsSleef STATIC 
fwrapper.f90
cwrapper.c
sleefsp.c
)
