# Test of neutron data refinement.
#
# This test takes a neutron structure and tests
# following features in all combinations:
#
#  Refinement, Scale, Calc            } These options are worked
#  Fourier                            } through in the instruction file
#  Extinction                         } neutron.ref.
#
#  F and F squared refinement FSQ or NOFSQ
#  Anomalous scattering ANOM or NOANOM
#
#  
#
\set time slow
\rele print CROUTPUT:

#                                         NOFSQ, NOANOM
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
\use neutron.in
\USE neutron.ref

#                                         NOFSQ, ANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=NO
END
\use neutron.in
\USE neutron.ref

#                                         FSQ, NOANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=YES
END
\use neutron.in
\USE neutron.ref

#                                         FSQ, ANOM
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\use neutron.in
\USE neutron.ref

#                                         And close the program.
\FINISH
