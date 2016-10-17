#!/bin/sh
gfortran -g -fcheck=all shelx2cry_mod.F90 shelx2cry.F90 ../../sginfo/libsginfo.a -Wall -Wextra -Wfatal-errors -O2 -I../../sginfo/ -o shelx2cry
