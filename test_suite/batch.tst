# Test of batch refinement.
#
# This test takes a non-centro structure (cyclo) and tests all the
# following features of SFLS in all combinations:
#
#  Refinement, Scale, Calc            } These options are worked
#  Mixed ISO/ANISO refinement         } through in the instruction file
#  Extinction                         } batch.ref.
#
#  F and F squared refinement FSQ or NOFSQ
#  Anomalous scattering ANOM or NOANOM
#
#
\set time slow
\rele print CROUTPUT:

#                                         NOFSQ, NOANOM
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
\use batch.in
\USE batch.ref

#                                         NOFSQ, ANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=NO
END
\use batch.in
\USE batch.ref

#                                         FSQ, NOANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=YES
END
\use batch.in
\USE batch.ref

#                                         FSQ, ANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\use batch.in
\USE batch.ref

#                                         And close the program.
\FINISH
