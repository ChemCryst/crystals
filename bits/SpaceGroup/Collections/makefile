CXX = g++

SRC = BaseTypes.cpp ComClasses.cpp Exceptions.cpp MathFunctions.cpp Matrices.cpp StringClasses.cpp Timer.cpp Wrappers.cpp
OBJECTS = BaseTypes.o ComClasses.o Exceptions.o MathFunctions.o Matrices.o StringClasses.o Timer.o Wrappers.o

depend : 
	rm .depend
	$(CXX) -M -MF .depend $(SRC) 
	
include .depend 

all : $(OBJECTS)
	
%.o : %.cpp
	$(CXX) -c -o $*.o $<