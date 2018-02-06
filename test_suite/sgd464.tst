\ Each restraint is tested separately to avoid side effects on the output
\ the scheme is: check, refine and check
\set time slow
\rele print CROUTPUT:
\TITLE real structure from james.thomson@chem.ox.ac.uk to test adps restraints
END
\ test 1
\use sgd464.in
\LIST 16
UPERP 0.0001 cl(1) to c(2), cl(3) to c(2), cl(4) to c(2)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 2
\use sgd464.in
\LIST 16
UPERP 0.0001 c(24) to c(29) to c(25), c(25) to c(24) to c(26)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 3
\use sgd464.in
\LIST 16
UPLANE 0.0001 c(24) to c(29) to c(25), c(25) to c(24) to c(26)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 4
\use sgd464.in
\LIST 16
UALIGN 0.0001 c(24) c(25) c(26) c(27) c(28) c(29)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 5
\use sgd464.in
\LIST 16
URIGU 0.0001 c(7) to c(9), c(9) to c(11)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 6
\use sgd464.in
\LIST 16
ULIJ 0.0001 c(24) to c(25) to c(26), c(25) to c(26) to c(27),
cont c(26) to c(27) to c(28)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 7
\use sgd464.in
\LIST 16
UEIG 0.0001 CL(1) cl(3)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 8
\use sgd464.in
\LIST 16
UQISO 0.0001 CL(1) cl(3)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 9
\use sgd464.in
\LIST 16
UVOL 0.0001 CL(1) cl(3)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 10
\use sgd464.in
\LIST 16
UEQIV 0.0001 CL(1) cl(3)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\ test 11
\use sgd464.in
\LIST 16
UTLS 0.0001 6 c(24) c(25) c(26) c(27) c(28) c(29) c(23)
END
\CHECK HI
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\SFLS
REFINE
END
\CHECK HI
END
rem =========================================================
\FINISH

