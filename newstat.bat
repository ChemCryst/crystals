if exist newstat.int del newstat.int
if exist newstat.lis del newstat.lis
cvs status >newstat.int

ecce newstat.int newstat.lis newstat.dat

if exist newstat.lis type newstat.lis
