# This data tests diffin.exe - data is read from a .cif_od file (without hkl data).
# The CRYSTALS input is renamed to diffin.out so that it will be compared to a reference
# output file for each platform.
\set time slow
\store CSYS SVN '0000'
$ % CRYSDIR:diffin.exe -b -d A -o diffin2.out sg.cif_od 

\FINISH
