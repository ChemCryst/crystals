# Makefile for building $(PROG) on *nix using gnu make
# Written by Stefan Pantos 22/11/2004

#Compilers
LD = g77
F77 = g77
CC = gcc

#Flags
FFLAGS = -O2 -D $(COMPCODE)
LDFLAGS = -O2
CFLAGS = -O2

DEBUG =

#Source
FSRC = csd2cry.fpp
CSRC = nobuf.c
SSRSRC =
SRCSRC =

#Object
FOBJ = $(FSRC:.fpp=.o)
COBJ = $(CSRC:.c=.o)

PROG = csd2cry

#Directories
INSTALLDIR = 

#Misc
MACROFILE = 


%.o : %.fpp
	$(F77) -c $(FFLAGS) $(DEBUG) -o $@ $<

%.o : %.c
	$(CC) -c $(CFLAGS) $(DEBUG) -o $@ $<

all : $(PROG)

$(PROG) : $(FOBJ) $(COBJ)
	$(LD) $(LDFLAGS) $(DEBUG) -o $@ $^

clean :
	rm -f $(PROG) $(FOBJ) $(COBJ)

install :$(INSTALLDIR)
	cp $(PROG) $(INSTALLDIR)

$(INSTALLDIR) :
	mkdir -p $(INSTALLDIR)
