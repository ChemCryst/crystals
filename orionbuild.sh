#!/bin/sh
cmake ../ -Dverbose=YES -DwithSUPERFLIP=YES -DwithEDMA=YES -DCMAKE_LIBRARY_PATH=/files/pparois/root/lib/ -DCMAKE_Fortran_COMPILER=gfortran71 -DCMAKE_C_COMPILER=gcc71 -DCMAKE_CXX_COMPILER=g++71 -DCMAKE_BUILD_TYPE=debug

