\release printer CROUTPUT:
\set time slow
#
#
#
#
\USE shapering.in
#                                         NOFSQ, NOANOM
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
#list 4
end
#SFLS
R
R
R
R
END
\USE shapering1.in
\USE shapering.ref
#                                         NOFSQ, ANOM
\use shapering.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=NO
END
#list 4
end
#SFLS
R
R
R
R
END
\USE shapering2.in
\USE shapering.ref
#                                         FSQ, NOANOM
\use shapering.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=YES
END
#list 4
end
#SFLS
R
R
R
R
END
\USE shapering3.in
\USE shapering.ref
#                                         FSQ, ANOM
\use shapering.in
\LIST 23 
MODIFY EXTINCTION=YES ANOM=YES
MINIMISE F-SQ=YES
END
#list 4
end
#SFLS
R
R
R
R
END
\USE shapering4.in
\USE shapering.ref
\FINI
