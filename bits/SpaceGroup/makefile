CC = g++
LD = g++

SRC = main.cpp Conditions.cpp Matrices.cpp RunParameters.cpp CrystalSystem.cpp LaueClasses.cpp MergedData.cpp SpaceGroups.cpp Exceptions.cpp LaueGroupGraph.cpp Stats.cpp HKLData.cpp UnitCell.cpp 

#../CodeLibrary/CPP/BaseTypes.cpp ../CodeLibrary/CPP/StringClasses.cpp ../CodeLibrary/CPP/ComClasses.cpp ../CodeLibrary/CPP/Timer.cpp ../CodeLibrary/CPP/Wrappers.cpp ../CodeLibrary/C/MathFunctions.cpp

OBJECTS = main.o Conditions.o Matrices.o RunParameters.o CrystalSystem.o LaueClasses.o MergedData.o SpaceGroups.o Exceptions.o LaueGroupGraph.o Stats.o HKLData.o UnitCell.o 

LIBRARY_CPP_OBJ = BaseTypes.o StringClasses.o ComClasses.o Timer.o Wrappers.o 
LIBRARY_C_OBJ = MathFunctions.o

LIBRARY_CPP_DIR = ../CodeLibrary/CPP/build/objects/
LIBRARY_C_DIR = ../CodeLibrary/C/build/objects/
PROG = TheDeterminator
RM = /bin/rm -f
OBJECTDIR = build/objects/
INCLUDES = ../CodeLibrary/Headers/
CFLAGS = -I $(INCLUDES)
#LDFLAGS = 

depend:
	makedepend -f .depend -- $(CFLAGS) -- $(SRC) 2> depend.log 

include .depend

all: $(PROG)

$(PROG): cpp_lib_obj c_lib_obj $(OBJECTS) 
	$(LD) $(LIBRARY_CPP_DIR)*.o $(LIBRARY_C_DIR)*.o $(OBJECTDIR)*.o -o build/$(PROG)

%.o: %.cpp 
	$(CC) $(CFLAGS) -c $< -o $(OBJECTDIR)$*.o

cpp_lib_obj: 
	(cd ../CodeLibrary/CPP/; make $(LIBRARY_CPP_OBJ))

c_lib_obj:
	(cd ../CodeLibrary/C/; make $(LIBRARY_C_OBJ))