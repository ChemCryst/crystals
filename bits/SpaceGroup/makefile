CC = g++

CFILES = BaseTypes.cpp InteractiveControl.cpp PCPort.cpp SpaceGroups.cpp UnitCell.cpp Conditions.cpp Exceptions.cpp  main.cpp ReflectionMerging.cpp Stats.cpp CrystalSystem.cpp HKLData.cpp Matrices.cpp RunParameters.cpp CodeLibrary/CPP/ReadWriteLock.cpp CodeLibrary/CPP/ComClasses.cpp CodeLibrary/C/MathFunctions.cpp CodeLibrary/CPP/semaphore.cpp CodeLibrary/CPP/StringClasses.cpp

OBJECT = SpaceGroup
INCLUDES = CodeLibrary/Headers/
CFLAGS = -I $(INCLUDES) -o $(OBJECT)

all : 
	$(CC) $(CFILES) $(CFLAGS)

debug:
	$(CC) $(CFILES) $(CFLAGS) -g

dep:
	$(CC) $(CFILES) $(CFLAGS) -MD