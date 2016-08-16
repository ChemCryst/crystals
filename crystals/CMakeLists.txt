

enable_language(Fortran)


if ( useGUI )
add_definitions(-D__WXUSINGDLL)
add_definitions(-DCRY_GUI)
else()
add_definitions(-DCRY_NOGUI)
endif()


add_library(CrystalsFortran STATIC
crystals_hdf5.F90
XDAVAL.INC.F90
XUNITS.INC.F90
XSSVAL.INC.F90
XERVAL.INC.F90
XIOBUF.INC.F90
XDISC.INC.F90
XLST01.INC.F90
XLST05.INC.F90
XLST06.INC.F90
XLST13.INC.F90
XLST23.INC.F90
XLST28.INC.F90
XLST30.INC.F90
XLST39.INC.F90
XCONST.INC.F90
XOPVAL.INC.F90
formatnumber.F90
solve_helper.F90
mrgrnk.F90
absolut.F90
${CMAKE_SOURCE_DIR}/gui/fwrapper_gui.F90
absorb.F
accumula.F
alter5.F
aniso.F
anisotfs.F
calcul.F
characte.F
control.F
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

target_link_libraries(CrystalsFortran openblas)
SET_TARGET_PROPERTIES(CrystalsFortran PROPERTIES LINKER_LANGUAGE Fortran)
SET_SOURCE_FILES_PROPERTIES(lapack.F PROPERTIES COMPILE_FLAGS -O0)
