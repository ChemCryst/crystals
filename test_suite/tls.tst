#
# This test takes cyclo and tests TLS calculations
#

\set time slow
\rele print CROUTPUT:
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
\LIST 12
FULL X'S U'S
END
\SFLS
R
END
\SFLS
R
END
\SFLS
R
END
\SFLS
R
END

\ANISO
ATOM C(1) C(2) O(3) O(5) C(4) C(10) C(11)
TLS
SAVE
END
\PRINT 20                                                                       
END
\ANISO
ATOM C(1) N(6) C(7) C(9) C(10) C(11)
TLS
SAVE
END
\PRINT 20                                                                       
END
\ANISO
ATOM TYPE(C)
TLS
SAVE
END
\PRINT 20                                                                       
END
\ANISO
ATOM TYPE(C) TYPE(O) TYPE(N)
TLS
SAVE
END
\PRINT 20                                                                       
END
#                                         And close the program.
\FINISH
