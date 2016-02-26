

enable_language(Fortran)

add_definitions(-D_GIL_)
add_definitions(-DCRY_OSWIN32)
add_definitions(-DCRY_GNU)
#add_definitions(-DCRY_OWNLAPACK)
add_definitions(-D_GNUF77_)
ADD_DEFINITIONS(-D_NOHDF5_)
ADD_DEFINITIONS(-fno-sign-zero)

if ( useGUI )
add_definitions(-D__WXMAC__)
add_definitions(-D__WXOSX__)
add_definitions(-D__WXOSX_COCOA__)
add_definitions(-D__WXUSINGDLL)
add_definitions(-DCRY_GUI)
else()
add_definitions(-DCRY_NOGUI)
endif()
add_definitions(-std=legacy)
add_definitions(-fno-automatic)
add_definitions(-fno-inline)
add_definitions(-fexceptions)
add_definitions(-D _HOL_)
#add_definitions(-mmacosx-version-min=10.7)
#add_definitions(-arch x86_64)


add_library(CrystalsFortran OBJECT
crystals_hdf5.F90
xdaval.inc.F90
xunits.inc.F90
xssval.inc.F90
xerval.inc.F90
xiobuf.inc.F90
xdisc.inc.F90
solve_helper.F90
mrgrnk.F90
${CMAKE_SOURCE_DIR}/gui/fwrapper_gui.f90
absorb.F
accumula.F
alter5.F
aniso.F
anisotfs.F
calcul.F
characte.F
control.F
crystals.F
csdcode.F
difabs.F
disc.F
distan.F
distangl.F
empabs.F
execute.F
fiddle.F
findfrag.F
foreig.F
fourie.F
fourier.F
genedit.F
geomet.F
geometry.F
guibit.F
hydrogen.F
input.F
input6.F
invert.F
lexical.F
link.F
list11.F
list12.F
list16.F
list26.F
list4.F
list50.F
list6.F
lists1.F
lists2.F
lists3.F
lists4.F
matrix.F
modify5.F
mtapes.F
normal.F
paramlist.F
planes.F
prcss.F
prcss6.F
presets.F
publsh.F
punch.F
read.F
read6.F
reductio.F
regular.F
restr.F
results.F
rotax.F
script.F
service.F
setting.F
sfls.F
slant.F
solve.F
sort.F
spacegrp.F
special.F
specific.F
summary.F
syntax.F
torsion.F
trial.F
vcv.F
weight.F
lapack.F
)

SET_SOURCE_FILES_PROPERTIES(lapack.F PROPERTIES COMPILE_FLAGS -O0)
