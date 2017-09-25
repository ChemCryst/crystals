#!/bin/sh
cmake3 ../ -Dverbose=YES -DwithSUPERFLIP=YES -DwithEDMA=YES -DCMAKE_LIBRARY_PATH=/files/pparois/root/lib/ -DCMAKE_Fortran_COMPILER=gfortran71 -DCMAKE_C_COMPILER=gcc71 -DCMAKE_CXX_COMPILER=g++71 -DBLA_VENDOR=OpenBLAS -DBLAS_LIBRARIES=/files/pparois/root/lib/libopenblas.so -DLAPACK_LIBRARIES=/files/pparois/root/lib/libopenblas.so -DCMAKE_BUILD_TYPE=debug

