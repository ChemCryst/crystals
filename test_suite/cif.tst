#
# This test takes a non-centro structure (cyclo) and tests all the
# following features of SFLS in all combinations:
#
#  Refinement, Scale, Calc            } These options are worked
#  Mixed ISO/ANISO refinement         } through in the instruction file
#  Extinction                         } cycloref.dat.
#
#  F and F squared refinement FSQ or NOFSQ
#  Anomalous scattering ANOM or NOANOM
#

\set time slow
\store CSYS SVN '0000'
\use cyclo.in
# Do a pretty picture:
\MOLAX
ATOM FIRST UNTIL LAST
PLOT
END
#                                         FSQ, ANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\USE cycloref.dat

\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END
\SFLS
REF
REF
END


\ For non-gui versions bonding is not always updated.
#BONDCALC FORCE
END

#STORE CSYS CIF 'cif.out'

#APPEND PUNCH

#CIF
END

#PARAMETERS
LAYOUT INSET = 1 NCHAR = 120 ESD=EXCLRH
COORD SELECT=ALL MONITOR=LOW PRINT=YES PUNCH=CIF NCHAR=14
U'S MONITOR=OFF, PRINT=NO, PUNCH=NO, NCHAR=14
END
#DIST
E.S.D YES YES
SELECT RANGE=L41
OUTPUT MON=DIST PUNCH = CIF HESD=NONFIXED
END
#DISTANCE 
OUT PUNCh=H-CIF mon=ang
SELECT RANGE=LIMIT
LIMIT 0.7 2.6 0.7 2.6 
E.S.D YES YES
PIVOT H
BOND O N C
END 
#PUNCH 12 C
END
#PUNCH 16 C
END
#SUM LIST 28 HI
END
#                                         And close the program.
\FINISH
