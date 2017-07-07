\set time slow
\rele print CROUTPUT:
\TITLE real structure from james.thomson@chem.ox.ac.uk to test adps restraints
END
\use sgd464.in
\LIST 16
rem execution
UPERP  0.00, 0.0001   = C(20) TO C(19)
UPERP2 0.00, 0.0001 = C(20) TO C(19) TO C(21)
UPLANE 0.00, 0.0001 = C(19) TO C(20) TO C(21)
UALIGN 0.0, 0.0001 = C(20) TO C(21)
RIGU 0.0, 0.0001 = C(20) TO C(21)
ULIJ 0.0, 0.0001 = C(19) TO C(21) TO C(20) TO C(21) TO C(22) TO C(23)
UEIG 0.0, 0.001 = C(20)
uqiso 0.0, 0.001 = Cl(4)
uvol 0.0, 0.001 = c(2) to cl(3)
END
\SFLS
REFINE
END
\CHECK HI
END
\FINISH

