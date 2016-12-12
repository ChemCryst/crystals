#!/bin/sh
gfortran61 -g -static -fcheck=all crystal_data.F90 shelx_procedures.F90 shelx2cry_dict.F90 shelx2cry_mod.F90 shelx2cry.F90 ../../sginfo/libsginfo.a -Wall -Wextra -Wfatal-errors -O2 -std=f2003 -fall-intrinsics -I../../sginfo/ -o shelx2cry
