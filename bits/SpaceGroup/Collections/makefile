CXX = g++

SRC = BaseTypes.cpp ComClasses.cpp Exceptions.cpp MathFunctions.cpp Matrices.cpp StringClasses.cpp Timer.cpp Wrappers.cpp
OBJECT_FILES = BaseTypes.o ComClasses.o Exceptions.o MathFunctions.o Matrices.o StringClasses.o Timer.o Wrappers.o
OBJECTDIR = release
OBJECTS := $(foreach FILE, $(OBJECT_FILES), $(OBJECTDIR)/$(FILE))
OBJ_EXT =.o
DEP_EXT =.dep
DEPENDENCYFILES = $(foreach FILE, $(OBJECT_FILES), $(subst $(OBJ_EXT),$(DEP_EXT), $(FILE)))

%.dep : %.cpp
	$(CXX) -M -MF $@ $< $(CFLAGS) $(INCLUDES) -o $(OBJECTDIR)/$*.o

all : dir_exist depend $(OBJECTS)

depend : dir_exist $(DEPENDENCYFILES)
	rm .depend
	cat $(DEPENDENCYFILES) > .depend

include .depend 

dir_exist: $(OBJECTDIR)
	@echo Making directories... 
	@echo $(OBJECTS)
	mkdir -p $(OBJECTDIR)

$(OBJECTDIR)/%.o : %.cpp
	$(CXX) $(CFLAGS) $(INCLUDES) -c -o $@ $<