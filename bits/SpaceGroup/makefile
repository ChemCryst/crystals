CXX = g++
LD = g++

SRC = Conditions.cpp HKLData.cpp LaueGroupGraph.cpp PointGroups.cpp Stats.cpp main.cpp CrystSymmetry.cpp MergedData.cpp RunParameters.cpp Symmetry.cpp CrystalSystem.cpp LaueClasses.cpp PCPort.cpp SpaceGroups.cpp UnitCell.cpp 

OBJECTS = Conditions.o HKLData.o LaueGroupGraph.o PointGroups.o Stats.o main.o CrystSymmetry.o MergedData.o RunParameters.o Symmetry.o CrystalSystem.o LaueClasses.o PCPort.o SpaceGroups.o UnitCell.o 

COLLECTIONS = Collections/

PROG = TheDeterminator
RM = /bin/rm -f
OBJECTDIR = 
LIBRARYS = $(COLLECTIONS)
INCLUDES = $(COLLECTIONS)
CFLAGS = -I $(INCLUDES) 
LDFLAGS = 

depend :
	rm -f .depend
	$(CXX) -M -MF .depend -- $(CFLAGS) -- $(SRC)

include .depend

all: $(PROG)

$(PROG): collection $(OBJECTS)
	$(LD) $(LDFLAGS) $(COLLECTIONS)*.o $(OBJECTDIR)*.o -o build/$(PROG)

%.o: %.cpp 
	$(CXX) $(CFLAGS) -c $< -o $(OBJECTDIR)$*.o

collection: 
	(cd $(COLLECTIONS); make all)
	