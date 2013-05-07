include makefile.in

ifneq ($(COMPCODE), MAC)
all : crysexe data scripts bits documentation
	@echo .
	@echo .
	@echo .     To test this build of CRYSTALS: 	
	@echo ".       export CRYSDIR=$(CURDIR)/"
	@echo .     and then start CRYSTALS from a command prompt:
	@echo ".       $(CURDIR)/crystals$(SUFFIX)"
	@echo .
	@echo .     To make an installer:
	@echo .       $(MAKE) dist
	@echo .     and to run the install:
ifeq ($(COMPCODE),WXS)
	@echo .       ../installer/crystals-*.exe
endif
ifneq ($(COMPCODE),WXS)
	@echo .       rpm -i ../installer/crystals-*.rpm
endif
else
all : crysexe data scripts bits documentation
	@echo .
	@echo .
	@echo .     To create an Mac OS Application:
	@echo .        $(MAKE) app-package
	@echo .     To run crystals:	
	@echo ".     Double click on Crystals application in $(CURDIR)"
endif
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

ifeq ($(COMPCODE), MAC)
app-package : ./Crystals.app crysexe data scripts bits documentation
	$(MAKE) -f Makefile.script tidy
	$(MAKE) -f Makefile.data tidy
	$(MAKE) -f Makefile.crystals tidy
	$(MAKE) -f Makefile.bits tidy
	$(MAKE) -f Makefile.manual tidy
	-rm -f crystals.pst cameron.pst
	mkdir -p Crystals.app/Contents/Resources/Crystals_Resources
	mkdir -p Crystals.app/Contents/MacOS
	mkdir -p Crystals.app/Contents/Resources/Crystals_Resources/Libraries
	cp -R `ls | grep -v obj | grep -v dscbuild | grep -v Crystals.app` Crystals.app/Contents/Resources/Crystals_Resources
	cp ../gui/mac/Crystals.icns  Crystals.app/Contents/Resources/
	cp ../gui/mac/Info.plist ../gui/mac/PkgInfo Crystals.app/Contents/
	mv Crystals.app/Contents/Resources/Crystals_Resources/Crystals Crystals.app/Contents/MacOS/
	rm -Rf `find Crystals.app/Contents/Resources/Crystals_Resources -name CVS`
	cp ../bin/crystals.script Crystals.app/Contents/Resources/Crystals_Resources

./Crystals.app : 
	mkdir $@
endif

ifeq ($(COMPCODE),WXS)
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
endif	

ifneq ($(COMPCODE),WXS)
dist : ../installer crystals crysexe data scripts bits documentation
	$(MAKE) -f Makefile.script tidy
	$(MAKE) -f Makefile.data tidy
	$(MAKE) -f Makefile.crystals tidy
	$(MAKE) -f Makefile.bits tidy
	$(MAKE) -f Makefile.manual tidy
	-rm -f crystals.pst cameron.pst
	$(INSTALL) -d ../rpmbuild
	$(INSTALL) -d ../rpmbuild/usr
	$(INSTALL) -d ../rpmbuild/usr/bin
	$(INSTALL) -d ../rpmbuild/usr/crystals
	cp -R `ls | grep -v obj | grep dscbuild` ../rpmbuild/usr/crystals 
	cp -R $(CURDIR)/* ../rpmbuild/usr/crystals
	rm -Rf ../rpmbuild/usr/crystals/obj
	rm -Rf ../rpmbuild/usr/crystals/dscbuild
	rm -Rf `find ../rpmbuild/usr/crystals/ -name CVS`
	$(INSTALL) ../bin/crystals.script ../rpmbuild/usr/bin/crystals
	rpmbuild --rcfile /usr/lib/rpm/rpmrc:../bin/rpmrc -bb ../bin/crystals.spec --buildroot $(CURDIR)/../rpmbuild
endif

../installer :
	mkdir $@
