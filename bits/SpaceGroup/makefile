CC = g++
CFILES = CrystalSystem.cpp Exceptions.cpp HKLData.cpp main.cpp Matrices.cpp Stats.cpp UnitCell.cpp ../CodeLibrary/CPP/ReadWriteLock.cpp ../CodeLibrary/CPP/ComClasses.cpp ../CodeLibrary/C/MathFunctions.cpp ../CodeLibrary/CPP/semaphore.cpp ../CodeLibrary/CPP/StringClassses.cpp

OBJECT = SpaceGroup
INCLUDES = ../CodeLibrary/Headers/
CFLAGS = -I$(INCLUDES) -o$(OBJECT)

all : 
	$(CC) $(CFILES) $(CFLAGS)

debug:
	$(CC) $(CFILES) $(CFLAGS) -g
