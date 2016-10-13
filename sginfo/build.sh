#!/bin/sh
set -x
gcc -g -gdwarf-3 -O0 -c sgclib.c  
gcc -g -gdwarf-3 -O0 -c sgfind.c  
gcc -g -gdwarf-3 -O0 -c sghkl.c  
gcc -g -gdwarf-3 -O0 -c sgio.c  
gcc -g -gdwarf-3 -O0 -c sgsi.c  
gcc -g -gdwarf-3 -O0 -c sginfo_extra.c
#gfortran -g -gdwarf-3 -O0 -c -fcheck=all c_strings.F90
gfortran -g -gdwarf-3 -O0 -c -fcheck=all sginfo_type.F90
gfortran -g -gdwarf-3 -O0 -c -fcheck=all sginfo.F90
gfortran -g -gdwarf-3 -O0 -c -fcheck=all test.F90
gfortran sgclib.o sgfind.o sghkl.o sgio.o sgsi.o sginfo_extra.o sginfo_type.o sginfo.o test.o -o test
ar rcs libsginfo.a sgclib.o sgfind.o sghkl.o sgio.o sgsi.o sginfo_extra.o sginfo_type.o sginfo.o 
