include makefile.in


all : crysexe data scripts bits documentation
	@echo .
	@echo .
	@echo .     To test this build of CRYSTALS: 
	@echo .       export CRYSDIR=$(CURDIR) 
	@echo .     and then start CRYSTALS from a command prompt:
	@echo .       $(CURDIR)/crystals.exe
	@echo .
	@echo .     To make an installer:
	@echo .       $(MAKE) dist
	@echo .     and to run the install:
	@echo .       ../installer/crystals-*.exe
	@echo .

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

dist : ../installer crysexe data scripts bits documentation
	$(MAKE) -f Makefile.script tidy
	$(MAKE) -f Makefile.data tidy
	$(MAKE) -f Makefile.crystals tidy
	$(MAKE) -f Makefile.bits tidy
	$(MAKE) -f Makefile.manual tidy
	-rm -f crystals.pst cameron.pst
	cd ../installer
	@echo "Running the setup compiler... (Inno Setup)"
	/c/progra~1/innose~1/iscc.exe ../bin/crystals.iss
	@echo "Setup compiler finished. Output .exe is in ../installer"
	

../installer :
	mkdir ../installer