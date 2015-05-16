include ../build/makefile.in

#LD = gfortran

all : cryseditor

cryseditor : cryseditor.o
	$(LD) $(FLAGS) $(LIBRARIES) $(DEBUG) -o $@$(SUFFIX) cryseditor.o

