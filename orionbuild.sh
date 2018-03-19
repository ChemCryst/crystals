#!/bin/sh
module load intel/2017
cmake3 ../ -Dverbose=YES -DwithSUPERFLIP=YES -DwithEDMA=YES -DCMAKE_LIBRARY_PATH=/files/ric/pparois/root/lib/ -DCMAKE_Fortran_COMPILER=gfortran73 -DCMAKE_C_COMPILER=gcc73 -DCMAKE_CXX_COMPILER=g++73 -DBLA_VENDOR=Intel10_64lp -DCMAKE_BUILD_TYPE=debug

