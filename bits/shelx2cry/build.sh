#!/bin/sh
gfortran -g -fno-realloc-lhs -static -fcheck=all -Wno-compare-reals crystal_data.F90 shelx_procedures.F90 shelx2cry_dict.F90 shelx2cry_mod.F90 shelx2cry.F90 ../../sginfo/libsginfo.a -Wall -Wextra -Wfatal-errors -O2 -std=f2003 -fall-intrinsics -I../../sginfo/ -o shelx2cry
