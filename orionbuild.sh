#!/bin/sh
cmake ../ -DCMAKE_LIBRARY_PATH=/files/pparois/root/lib/ -DCMAKE_Fortran_COMPILER=gfortran61 -DCMAKE_C_COMPILER=gcc61 -DCMAKE_CXX_COMPILER=g++61 -DCMAKE_BUILD_TYPE=debug
