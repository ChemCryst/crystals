\set time slow
\rele print CROUTPUT:
\TITLE real structure from james.thomson@chem.ox.ac.uk to test adps restraints
END
\use sgd464.in
\LIST 16
rem execution
UPERP 0.0001 C(20) TO C(19)
UPERP 0.0001 C(20) TO C(19) TO C(21)
UPLANE 0.0001 C(19) TO C(20) TO C(21)
UALIGN 0.0001 C(20) C(21)
URIGU 0.0001 C(20) TO C(21)
ULIJ 0.0001 C(19) TO C(21) TO C(20), C(21) TO C(22) TO C(23),
cont C(23) TO C(25) TO C(24)
UEIG 0.001 C(20)
uqiso 0.001 Cl(4)
uvol 0.001 cl(1) cl(3) cl(4)
utls 0.001 c(17) c(18) c(19) c(20) c(21) c(22)
ueqiv 0.001 c(24) c(25) c(26) c(27) c(28) c(29)
END
\SFLS
REFINE
END
\CHECK HI
END
\FINISH

