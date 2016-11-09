#!/bin/sh
set -x
CC=gcc
FC=gfortran
CFLAGS="-g -gdwarf-3 -O0 -c "
FFLAGS="-g -gdwarf-3 -O0 -c -fcheck=all "
$CC $CFLAGS sgclib.c  
$CC $CFLAGS sgfind.c  
$CC $CFLAGS sghkl.c  
$CC $CFLAGS sgio.c  
$CC $CFLAGS sgsi.c  
$CC $CFLAGS sginfo_extra.c
#gfortran -g -gdwarf-3 -O0 -c -fcheck=all c_strings.F90
$FC $FFLAGS sginfo_type.F90
$FC $FFLAGS sginfo.F90
$FC $FFLAGS test.F90
$FC sgclib.o sgfind.o sghkl.o sgio.o sgsi.o sginfo_extra.o sginfo_type.o sginfo.o test.o -o test
ar rcs libsginfo.a sgclib.o sgfind.o sghkl.o sgio.o sgsi.o sginfo_extra.o sginfo_type.o sginfo.o 
