%module crystals
%include "modelparameters.i"

%{
#include "cinterface.h"
%}

%include "cinterface.h"

%pythoncode %{
print "crystals import initialisation. Importing crysdata module..."
import crysdata
crysdir = crysdata.get_path('')
print "Data is at " + crysdir
# Store crysdir in C++ variable.

Crystals.storecrysdir(crysdir)

%}