include makefile.in


all : crysexe data scripts bits

crysexe : 
	$(MAKE) -f Makefile.crystals

data : 
	$(MAKE) -f Makefile.data

scripts :
	$(MAKE) -f Makefile.script

bits :
	$(MAKE) -f Makefile.bits

clean :
	$(MAKE) -f Makefile.script clean
	$(MAKE) -f Makefile.data clean
	$(MAKE) -f Makefile.crystals clean
	$(MAKE) -f Makefile.bits clean


