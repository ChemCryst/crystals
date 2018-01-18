#
# This test takes a centro twinned structure (keen) and tests all the
# following features of SFLS in all combinations:
#
#  Refinement, Scale, Calc            } These options are worked
#  Mixed ISO/ANISO refinement         } through in the instruction file
#                                     } keenref.dat.
#
#  F and F squared refinement FSQ or NOFSQ
#  Anomalous scattering ANOM or NOANOM
#

\                     Run through some simple stuff, then
\                     use keenref.dat a number of times under
\                     different conditions.
#set time slow
#rele print CROUTPUT:
\                     Read in the reflection data and initial model
#USE keen.in
\
\                     Test some statistics
#WILSON
FILTER LIST28 = NO
END
#SIGMADIST                                                                      
END
\
\                      Simple refinement
#LIST 12                                                                        
BLOCK SCALE X'S, U[ISO]
END
\
\                      Unit weights
#LIST 4
END
#WEIGHT
END
\
\                      Make sure scale is right
#SFLS
SCALE
END
#SFLS                                                                           
SCALE
END
\
\                      No restraints
#LIST     16
NO
END
#LIST 22                                                                        
END
#PRINT 12                                                                       
END
#SFLS                                                                           
REFINE
REFINE
REFINE
REFINE
REFINE
END
#SFLS                                                                           
REFINE
REFINE
REFINE
REFINE
REFINE
END
\
\                      Now try aniso refinement
#LIST     16
LIMIT      0.1 U[11] 
LIMIT      0.1 U[22] 
LIMIT      0.1 U[33] 
LIMIT      0.1 U[12] 
LIMIT      0.1 U[13] 
LIMIT      0.1 U[23] 
END
#LIST 12
BLOCK SCALE X'S, U'S
END
#LIST 22                                                                        
END
#SFLS                                                                           
REFINE
REFINE
REFINE
REFINE
REFINE
END
\
\                      Quick test of rotax
#ROTAX
TOLERANCE FOM= 5.000000
ROTATION ANGLE= 180.000000 INVERT=NO
END
\
\                      It will have found this twin law.
#LIST 25
READ NELEM = 2
MATRIX 1 0 0 0 1 0 0 0 1
MATRIX 1 0 0 0 -1 0 -1 0 -1
END
\
\                      Use twin law to assign element types.
#LIST 6
READ TYPE=TWIN
MATRIX TWINTOL= 0.005000
END
\
\                      First experiment. FSQ, NOANOM
#LIST 23
MODIFY EXTINCTION=NO ANOM=NO
MINIMISE F-SQ=YES
END
#USE keenref.dat
#sum l 12
end
#sum l 16
end
#sum l 17
end
\
\                      Second experiment. NOFSQ, NOANOM
#LIST 23
MODIFY EXTINCTION=NO ANOM=NO
MINIMISE F-SQ=NO
END
#USE keenref.dat
\
\                      Third experiment. FSQ, ANOM
#LIST 23
MODIFY EXTINCTION=NO ANOM=YES
MINIMISE F-SQ=YES
END
#USE keenref.dat
\
\                      Fourth experiment. NOFSQ, ANOM
#LIST 23
MODIFY EXTINCTION=NO ANOM=YES
MINIMISE F-SQ=NO
END
#USE keenref.dat
\
\end

