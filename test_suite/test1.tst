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
\rele print CROUTPUT:
\use cyclo.in
# Do a pretty picture:
\MOLAX
ATOM FIRST UNTIL LAST
PLOT
END

#                                         NOFSQ, NOANOM
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
\USE cycloref.dat

#                                         NOFSQ, ANOM
\use cyclo.in
\list 16
limit 10. EXTPARAM
end
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=NO
END
\USE cycloref.dat

#                                         FSQ, NOANOM
\use cyclo.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=YES
END
\USE cycloref.dat

#                                         FSQ, ANOM
\use cyclo.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\USE cycloref.dat

#                                         And close the program.
\FINISH
