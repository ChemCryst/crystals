&
& This test checks that the & character works as a replacement for # or \
& (useful for French keyboards)

&set time slow
&rele print CROUTPUT:
&use ampcyclo.in
& Do a pretty picture:
&MOLAX
ATOM FIRST UNTIL LAST
PLOT
END

&                                         NOFSQ, NOANOM
&LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
&USE ampref.dat

&                                         And close the program.
&FINISH
