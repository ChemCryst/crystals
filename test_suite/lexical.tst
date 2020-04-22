\ Torture test for the lexical analyzer
\set time slow
\rele print CROUTPUT:
\TITLE  Torture test for the lexical analyzer
END
\use sgd464.in
\bondcalc
\ spaces
\LIST 16
dist 0.0,  1.0=mean cl(1) to c(2),c(2)to cl(3  ) , cl(  3  ) to cl(1)
dist 0.0 ,1.0 = mean C -- C C==C C-5- C
end
\ atom specification
\list 16
uqiso 1.0 Cl(resi=1)
ueqiv 1.0 C(*)
end
\ rigu restraint
\list 16
xrigu C(*)
Xrigu 0.04 0.0 C(*)
end
\ variables
\list 16
define a=1.0
define b = 0.01
dist $a,$b=Cl(1)to Cl(3)
dist $a , $b = Cl(1) to Cl(3)
end
\ invalid atom
\list 16
uqiso 0.01 C(128) C(2, 128)
\end
\ everything here is ignored because of the error above
\finish


