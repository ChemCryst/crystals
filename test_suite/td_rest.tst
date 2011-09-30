#
# This test takes cyclo and tests symmetric and asymmetric restraints
#

\set time slow
\rele print CROUTPUT:
\
\TITLE Cyclo in P 21 21 21
\LIST 1 
REAL 4.925  11.035 15.322  90.000  90.000  90.000 
\SPACE
SYMBOL P 21 21 21
END
\ Work get scattering factors and put them into list 3
#COMPOSIT                                                                       
CONTE  C 28. H 44. N 4. O 12.
SCATT CRYSDIR:script/scatt.dat
PROPERTIES CRYSDIR:script/propwin.dat
END
\LIST 29
READ NELEM = 4
ELEM C .8  1.5    .6 28 9.17 12      BLAC
ELEM H .6  1.0    .4 44 .07  1       BLUE
ELEM O .77 1.78 1.36 12 3.25 15.9994 RED
ELEM N .77 1.78 -0.1 4  1.96 14.0067 LGRE
END
\LIST 4 
END 
\LIST 13 
COND 0.71073
END 
\LIST 28
END
\ HOOK UP THE REFLECTION FILE
#OPEN HKLI  "cyclo.hkl"                                                         
#HKLI                                                                           
READ   F'S=FSQ  NCOEF = 5  TYPE = FIXED CHECK = NO
INPUT H K L /FO/ SIGMA(/FO/)
FORMAT (3F4.0, 2F8.0)
STORE NCOEF=6
OUTPUT INDICES /FO/ SIGMA(/FO/) RATIO/JCODE CORRECTIONS SERIAL
END 
\SYST 
\SORT 
\MERGE 
REFLECTION LIST=LOW
\LIST 6 
\                           STORE REFLECTIONS ON DISC FOR FUTURE USE 
READ TYPE = COPY 
END 
#purg
end
#list 12
block o(6,u's) c(7,u's)
end
#use td_rest.l5
#list 16
compil
exec
u(ij) 0.0,.001 = o(6) to c(7)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

#use td_rest.l5
#list 16
compil
exec
u(ij) 0.0,.001 = c(7) to o(6)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

# -------------------------------------
#use td_rest.l5
#list 16
compil
exec
vib 0.0,.001 = o(6) to c(7)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

#use td_rest.l5
#list 16
compil
exec
vib 0.0,.001 = c(7) to o(6)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

#purg
end
#use td_rest.l5
#list 16
compil
exec
a-u(ij) 0.0,.001 = o(6) to c(7)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

#use td_rest.l5
#list 16
compil
exec
a-u(ij) 0.0,.001 = c(7) to o(6)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

# -------------------------------------
#use td_rest.l5
#list 16
compil
exec
a-vib 0.0,.001 = o(6) to c(7)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

#use td_rest.l5
#list 16
compil
exec
a-vib 0.0,.001 = c(7) to o(6)
end
#list 26
end
#check hi
end
#sfls
ref
end
#check hi
end

#end

