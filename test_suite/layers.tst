# Test of layer refinement.
#
# This test takes a non-centro structure (cyclo) and tests all the
# following features of SFLS in all combinations:
#
#  Refinement, Scale, Calc            } These options are worked
#  Mixed ISO/ANISO refinement         } through in the instruction file
#  Extinction                         } layer.ref
#
#  F and F squared refinement FSQ or NOFSQ
#  Anomalous scattering ANOM or NOANOM
#
#
\set time slow
\rele print CROUTPUT:
\use layer.in

#                                         NOFSQ, NOANOM
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
\USE layer.ref

#                                         NOFSQ, ANOM
\use layer.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=NO
END
\USE layer.ref

#                                         FSQ, NOANOM
\use layer.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=YES
END
\USE layer.ref

#                                         FSQ, ANOM
\use layer.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\USE layer.ref
                                                
#                                         And close the program.
\FINISH
