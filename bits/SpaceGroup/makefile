CC = g++

CFILES = BaseTypes.cpp InteractiveControl.cpp PCPort.cpp SpaceGroups.cpp UnitCell.cpp Conditions.cpp exceptions.cpp  main.cpp ReflectionMerging.cpp stats.cpp CrystalSystem.cpp HKLData.cpp Matrices.cpp RunParameters.cpp CodeLibrary/cpp/ReadWriteLock.cpp CodeLibrary/CPP/Comclasses.cpp CodeLibrary/C/MathFunctions.cpp CodeLibrary/CPP/semaphore.cpp CodeLibrary/CPP/StringClasses.cpp

OBJECT = SpaceGroup
INCLUDES = CodeLibrary/Headers/
CFLAGS = -I$(INCLUDES) -o$(OBJECT)

all : 
	$(CC) $(CFILES) $(CFLAGS)

debug:
	$(CC) $(CFILES) $(CFLAGS) -g

dep:
	$(CC) $(CFILES) $(CFLAGS) -MD