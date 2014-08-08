C $Log: not supported by cvs2svn $
C Revision 1.15  2010/07/21 15:57:32  djw
C Include list type in PUNCH 6 C
C
C Revision 1.14  2010/06/03 16:57:28  djw
C Add comments to explain the different PUNCH 6 x types
C
C Revision 1.13  2008/10/01 11:06:47  djw
C Output LIST 6 on scale of Fc for use in PLATON
C
C Revision 1.12  2008/03/07 16:09:48  djw
C changes to help with the correct computation of Fourier maps from twinned crystals.  THe old COPY67 subroutine did not pack the data properly unless the keys were the default keys.  The job is now done
C
C Revision 1.11  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.10  2004/05/12 09:55:07  rich
C Remove debugging print.
C
C Revision 1.9  2004/04/21 13:11:45  rich
C Added "#PUNCH 6 G" command, it outputs a SHELX format reflection
C file, but using slightly perturbed Fcalc^2 and made-up sigma(F-calc^2).
C
C Added a routine ISCNTRC(HKL) to determine if a given reflection is
C in a centrosymmetric class of reflections (e.g. the h0l class in monoclinic-b
C ). Used in plot of phase distribution to exclude this class of reflections.
C Added text to xphase.scp to explain this.
C
C Revision 1.8  2003/06/27 10:11:34  rich
C Added "#PUNCH 6 F" - outputs a plain HKLF4 format listing to the
C punch file with no headers or anything.
C
C Revision 1.7  2003/02/14 17:09:02  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.6  2003/01/15 10:57:05  rich
C \PUNCH 6 E punches a CIF format reflection file with F squared instead of
C Fs (PUNCH 6 B)
C
C Revision 1.5  2001/10/08 12:25:58  ckp2
C
C All program sub-units now RETURN to the main CRYSTL() function inbetween commands.
C The changes made are: in every sub-program the GOTO's that used to loop back for
C the next KNXTOP command have been changed to RETURN's. In the main program KNXTOP is now
C called at the top of the loop, but first the current ProgramName (KPRGNM) array is cleared
C to ensure the KNXTOP knows that it is not in the correct sub-program already. (This
C is the way KNXTOP worked on the very first call within CRYSTALS).
C
C We now have one location (CRYSTL()) where the program flow returns between every command. I will
C put this to good use soon.
C
C Revision 1.4  2001/02/26 10:26:48  richard
C Added changelog to top of file
C
C
CODE FOR INPUT6
      SUBROUTINE INPUT6
      CALL XSYSDC(-1,1)
      CALL XRDL67
      RETURN
      END

CODE FOR XRDL67
      SUBROUTINE XRDL67
C--MAIN ROUTINE TO CONTROL THE INPUT OF LIST 6 AND LIST 7

      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)




c      WRITE ( CMON, '(A,6I6)')'List input', NUM,LSTOP,LSTNO,ICLASS
c      CALL XPRVDU(NCVDU, 1,0)









C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN

C--BRANCH ON THE TYPE OF OPERATION
      IF(LSTOP)1400,1400,1900
C--THIS IS NOT A LIST INPUT OPERATION  -  BRANCH ON THE FUNCTION
1400  CONTINUE
cdjw2010 Why is this reset here?
      LSTNO=6
      GOTO (2100,2200,2600,2700,2300,1500),NUM
1500  CALL GUEXIT(325)

C--THIS IS A LIST TYPE OPERATION  -  BRANCH ON ITS FUNCTION
1900  CONTINUE
      GOTO (2100,6000,7000,1300),LSTOP

1300  CALL GUEXIT(150)

C--READ THE LIST FROM THE INPUT MEDIUM
2100  CONTINUE
      CALL XRD06(LSTNO)
      RETURN

C--'#ABS' INSTRUCTION
2200  CONTINUE
      CALL XABS
      RETURN

C---- '#COPY67'
2300  CONTINUE
C----- CREATE A LIST 7 FROM A LIST 6
      CALL XCPY67
      RETURN

C--'#TITLE' INSTRUCTION
2600  CONTINUE
      CALL XRCN
      RETURN

C--'#END' INSTRUCTION
2700  CONTINUE
      CALL XMONTR(-1)
      CALL XEND
      RETURN

C--PRINT THE LIST
6000  CONTINUE
      ITEMP1=NR60
      ITEMP2=NR61
      NR60=0
      NR61=0
      I=KRDDPV(ISTORE(NFL),4)
      NR60=ITEMP1
      NR61=ITEMP2
      CALL XRSL
      CALL XCSAE
      IF(ICLASS)6410,6420,6020
C--PRINT ON THE SCALE OF /FO/
6410  CONTINUE
cdjwjul2010 - add list number
      CALL XPRT6C(lstno, -1)
      RETURN
C--PRINT ON THE SCALE OF /FC/
6420  CONTINUE
      CALL XPRT6C(lstno, +1)
      RETURN
C--NORMAL LIST PRINT
6020  CONTINUE
      CALL XPRTLN(LSTNO)
      RETURN

C--LIST PUNCH ROUTINE
C
C      A     COMPRESSED PUNCH FORMAT
C                  XPCH6G(LSTNO,ICLASS)
C      B     CIF OUTPUT F's
C                  XPCH6C(LSTNO,0)
C      C     NORMAL DATA, ONE REFLECTION PRE CARD
C                  XPCH6S(LSTNO,LSTNO)
C      D     OBSERVED QUANTITIES ONLY
C                  XPCH6O(LSTNO)
C      E     CIF OUTPUT F^2's
C                  XPCH6C(LSTNO,1)
C      F     PLAIN SHELX HKL OUTPUT
C                  XPCH6X(LSTNO,0)
C      G     SHELX HKL OUTPUT of FC with made up sigmas.
C                  XPCH6X(LSTNO,1)
C      H     CIF OUTPUT F^2's  on scale of Fc
C                  XPCH6C(LSTNO,2)
C      J     SIM WEIGHT TEST
7000  CONTINUE
      ITEMP1=NR60
      ITEMP2=NR61
      NR60=0
      NR61=0
      I=KRDDPV(ISTORE(NFL),4)
      NR60=ITEMP1
      NR61=ITEMP2
      CALL XRSL
      CALL XCSAE
C--CHECK THAT THIS IS LIST 6
C      IF(LSTNO-6)7100,7300,7100
      IF ((LSTNO .EQ. 6) .OR. (LSTNO .EQ.7)) GOTO 7300
C--NOT LIST 6  -  AN ERROR
7100  CONTINUE
      CALL XERHDR(0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,7200)LSTNO,IH
      WRITE ( CMON, 7200) LSTNO, IH
      CALL XPRVDU(NCVDU, 1,0)
7200  FORMAT(' Illegal list number for ''',A1,'punch''')
      CALL XERHND ( IERERR )
      RETURN
C--CHECK THE TYPE OF PUNCH
7300  CONTINUE
C           A    B    C    D    E    F    G    H    I    J
      GOTO (7310,7340,7320,7330,7350,7360,7370,7380,7390,7400 ) 
     1 ICLASS+2
71    CONTINUE
      CALL XERHDR(0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,72)ICLASS
      WRITE ( CMON, 72) ICLASS
      CALL XPRVDU(NCVDU, 1,0)
72    FORMAT(' Illegal list 6 punch type', i4)
      CALL XERHND ( IERERR )
      RETURN
C--COMPRESSED PUNCH FORMAT - A
7310  CONTINUE
      CALL XPCH6G(LSTNO,ICLASS)
      RETURN
C--NORMAL DATA, ONE REFLECTION PRE CARD - C
7320  CONTINUE
cdjwmar08 - ENSURE LIST 6 IS PUNCH AS LIST 6
      CALL XPCH6S(LSTNO,LSTNO)
      RETURN
C--OBSERVED QUANTITIES ONLY - D
7330  CONTINUE
      CALL XPCH6O(LSTNO)
      RETURN
C----- CIF OUTPUT F's - B
7340  CONTINUE
      CALL XPCH6C(LSTNO,0)
      RETURN
C----- CIF OUTPUT F^2's - E
7350  CONTINUE
      CALL XPCH6C(LSTNO,1)
      RETURN
C----- PLAIN SHELX HKL OUTPUT  - F
7360  CONTINUE
      CALL XPCH6X(LSTNO,0)
      RETURN
C----- SHELX HKL OUTPUT of FC with made up sigmas. - G
7370  CONTINUE
      CALL XPCH6X(LSTNO,1)
C----- CIF OUTPUT F^2's  on scale of Fc- H
7380  CONTINUE
      CALL XPCH6C(LSTNO,2)
      RETURN
C----- All set keys
7390  CONTINUE
      CALL XPCH6Z(LSTNO)
      RETURN
7400  CONTINUE
      CALL SIMTEST(LSTNO)
      RETURN
      END

