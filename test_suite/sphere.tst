\release printer CROUTPUT:
\set time slow
#
#
#
#
\USE sphere.in
#                                         NOFSQ, NOANOM
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
\USE sphere.ref

#                                         NOFSQ, ANOM
\use sphere.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=NO
END
\USE sphere.ref

#                                         FSQ, NOANOM
\use sphere.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=YES
END
\USE sphere.ref

#                                         FSQ, ANOM
\use sphere.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
\USE sphere.ref
\FINI
