\ This data tests diffin.exe - data is read from a .cif_od file (without hkl data).
\ The CRYSTALS input is named diffin3.out so that it will be compared to a reference
\ output file for each platform.
\set time slow
\store CSYS SVN '0000'
$ % CRYSDIR:diffin -b -d A -o diffin3.out ks.cif_od 
\
\ This script appends the hkl output "ksv2.hkl" to "diffin3.out" for test comparison purposes.
\
\script diffin3
\
\FINISH
