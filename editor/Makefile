include ../build/makefile.in

LD = g77

all : cryseditor

cryseditor : cryseditor.o
	$(LD) $(FLAGS) $(LIBRARIES) $(DEBUG) -o $@$(SUFFIX) cryseditor.o

