\set time slow
\rele print CROUTPUT:
\TITLE real structure from james.thomson@chem.ox.ac.uk to test adps restraints
END
\use sgd464.in
\LIST 16
UPERP  0.00, 0.0001   = C(20) TO C(19)
UPERP2 0.00, 0.0001 = C(20) TO C(19) TO C(21)
UPLANE 0.00, 0.0001 = C(19) TO C(20) TO C(21)
UALIGN 0.0, 0.0001 = C(20) TO C(21)
END
\CHECK HI
END
\SFLS
REFINE
END
\CHECK HI
END
\FINI
\\
