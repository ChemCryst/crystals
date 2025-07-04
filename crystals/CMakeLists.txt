

enable_language(Fortran)


if ( useGUI )
   add_definitions(-D__WXUSINGDLL)
   add_definitions(-DCRY_GUI)
else()
   add_definitions(-DCRY_NOGUI)
endif()


add_library(CrystalsFortran OBJECT
helper.c
mrgrnk.f90
crystals_hdf5.F90
numpy.F90
lists1.F
KCHAR.INC.F90
STORE.INC.F90
XCARDS.INC.F90
XCHARS.INC.F90
XCOMPD.INC.F90
XDAVAL.INC.F90
XDISCB.INC.F90
XUNITS.INC.F90
XSSVAL.INC.F90
XERVAL.INC.F90
XIOBUF.INC.F90
XDISC.INC.F90
XLEXCH.INC.F90
XLEXIC.INC.F90
XLINK.INC.F90
XLISTI.INC.F90
XLST01.INC.F90
XLST02.INC.F90
XLST03.INC.F90
XLST05.INC.F90
XLST06.INC.F90
XLST6B.INC.F90
XLST12.INC.F90
XLST13.INC.F90
XLST23.INC.F90
XLST28.INC.F90
XLST30.INC.F90
XLST33.INC.F90
XLST39.INC.F90
XLST40.INC.F90
XLST41.INC.F90
XLST50.INC.F90
XLXPRT.INC.F90
XCONST.INC.F90
XAPK.INC.F90
XOPK.INC.F90
XOPVAL.INC.F90
XRTLSC.INC.F90
XSCALE.INC.F90
XSFLSW.INC.F90
XSFWK.INC.F90
XSTATS.INC.F90
XWORK.INC.F90
XWORKA.INC.F90
XWORKB.INC.F90
math.F90
formatnumber.F90
solve_helper.F90
sfls_punch.F90
absolut.F90
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
fcal.F
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
lexical_helper.F90
lexical.F
link.F
list11.F
list12_helper.F90
list12.F
list16.F
list26_helper.F90
list26.F
list4.F
list50.F
list6.F
lists2.F
lists3.F
lists4.F
matrix.F
modify5.F
mtapes.F
normal.F
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
sfls_stack_mod.F90
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

if (Fortran_COMPILER_NAME MATCHES "gfortran")  # gfortran
   # gfortran: Trap NaN as those seem to appear sometimes in the fourier test
   set_property( SOURCE fourier.F PROPERTY COMPILE_FLAGS -ffpe-trap=invalid )
   set_property( SOURCE fourie.F PROPERTY COMPILE_FLAGS -ffpe-trap=invalid )
   set_source_files_properties(lapack.F PROPERTIES COMPILE_FLAGS -O0)
endif()

set_target_properties(CrystalsFortran PROPERTIES LINKER_LANGUAGE Fortran)

# These lines add definitions at the preprocessor stage - when CMake is checking for module dependencies in the Fortran.
# Without these lines modules may be built in the wrong order causing a compilation failure in parallel builds.
if ( useGUI )
   set_target_properties(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_GUI)
else()
   set_target_properties(CrystalsFortran PROPERTIES COMPILE_DEFINITIONS  CRY_NOGUI)
endif()


