#!/bin/sh
# gfortran81 -g -fno-realloc-lhs -static -fcheck=all -Wno-compare-reals crystal_data.F90 shelx_procedures.F90 shelx2cry_dict.F90 shelx2cry_mod.F90 shelx2cry.F90 ../../sginfo/libsginfo.a -Wall -Wextra -Wfatal-errors -O2 -std=f2003 -fall-intrinsics -I../../sginfo/  -o shelx2cry

set -x
FC=gfortran81
FFLAGS="-g -fno-realloc-lhs -static -fcheck=all -Wno-compare-reals -c -I../../sginfo"
$FC $FFLAGS crystal_data.F90
$FC $FFLAGS shelx2cry_cif.F90
$FC $FFLAGS shelx_procedures.F90
$FC $FFLAGS shelx2cry_dict.F90
$FC $FFLAGS shelx2cry_mod.F90
$FC $FFLAGS shelx2cry.F90

$FC *.o ../../sginfo/libsginfo.a -o shelx2cry

