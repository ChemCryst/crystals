include makefile.in


all : crysexe data scripts bits documentation

crysexe : 
	$(MAKE) -f Makefile.crystals

data : 
	$(MAKE) -f Makefile.data

scripts :
	$(MAKE) -f Makefile.script

documentation :
	$(MAKE) -f Makefile.manual

bits :
	$(MAKE) -f Makefile.bits

clean :
	$(MAKE) -f Makefile.script clean
	$(MAKE) -f Makefile.data clean
	$(MAKE) -f Makefile.crystals clean
	$(MAKE) -f Makefile.bits clean
	$(MAKE) -f Makefile.manual clean

tidy :
	$(MAKE) -f Makefile.script tidy
	$(MAKE) -f Makefile.data tidy
	$(MAKE) -f Makefile.crystals tidy
	$(MAKE) -f Makefile.bits tidy
	$(MAKE) -f Makefile.manual tidy


