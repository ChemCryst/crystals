CXX = g++
LD = g++

SRC = Conditions.cpp HKLData.cpp LaueGroupGraph.cpp PointGroups.cpp Stats.cpp main.cpp CrystSymmetry.cpp MergedData.cpp RunParameters.cpp Symmetry.cpp CrystalSystem.cpp LaueClasses.cpp PCPort.cpp SpaceGroups.cpp UnitCell.cpp 

OBJECT_FILES = Conditions.o HKLData.o LaueGroupGraph.o PointGroups.o Stats.o main.o CrystSymmetry.o MergedData.o RunParameters.o Symmetry.o CrystalSystem.o LaueClasses.o PCPort.o SpaceGroups.o UnitCell.o 

COLLECTIONS = Collections

PROG = TheDeterminator
RM = /bin/rm -f
OBJECTDIR = release
LIBRARYS = $(COLLECTIONS)
INCLUDES = -I $(COLLECTIONS)

OBJECTDIR = release
OBJECTS := $(foreach FILE, $(OBJECT_FILES), $(OBJECTDIR)/$(FILE))
OBJ_EXT =.o
DEP_EXT =.dep
DEPENDENCYFILES = $(foreach FILE, $(OBJECT_FILES), $(subst $(OBJ_EXT),$(DEP_EXT), $(FILE)))

CFLAGS =
LDFLAGS = 
FILE_EXTENTION = 

%.dep : %.cpp 
	$(CXX) -M -MF $@ $(CFLAGS) -I $(INCLUDES) $< -o $(OBJECTDIR)/$*.o

depend : dir_exist $(DEPENDENCYFILES)
	rm -f .depend
	cat $(DEPENDENCYFILES) > .depend


include .depend

all: dir_exist $(PROG)

dir_exist: $(OBJECTDIR)
	@echo "Creating directorys..."
	mkdir -p $(OBJECTDIR)
	@echo $(OBJECTS)

$(PROG): collection $(OBJECTS)
	$(LD) $(LDFLAGS) $(COLLECTIONS)/$(OBJECTDIR)/*.o $(OBJECTDIR)/*.o -o $(OBJECTDIR)/$(PROG)

$(OBJECTDIR)/%.o: %.cpp 
	$(CXX) $(CFLAGS) $(INCLUDES) -c -o $@ $<

collection: 
	(cd $(COLLECTIONS); make all)
