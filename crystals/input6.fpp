C $Log: not supported by cvs2svn $
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


CODE FOR INPUT6
      SUBROUTINE INPUT6
      CALL XSYSDC(-1,1)
      CALL XRDL67
      RETURN
      END

CODE FOR XRDL67
      SUBROUTINE XRDL67
C--MAIN ROUTINE TO CONTROL THE INPUT OF LIST 6 AND LIST 7

\ISTORE
\STORE
\XUNITS
\XCHARS
\XLST50
\XERVAL
\XSSVAL
\XIOBUF
\QSTORE

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)




      WRITE ( CMON, '(A,6I6)')'List input', NUM,LSTOP,LSTNO,ICLASS
      CALL XPRVDU(NCVDU, 1,0)









C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN

C--BRANCH ON THE TYPE OF OPERATION
      IF(LSTOP)1400,1400,1900
C--THIS IS NOT A LIST INPUT OPERATION  -  BRANCH ON THE FUNCTION
1400  CONTINUE
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
      CALL XPRT6C(-1)
      RETURN
C--PRINT ON THE SCALE OF /FC/
6420  CONTINUE
      CALL XPRT6C(+1)
      RETURN
C--NORMAL LIST PRINT
6020  CONTINUE
      CALL XPRTLN(LSTNO)
      RETURN

C--LIST PUNCH ROUTINE
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
      WRITE ( NCAWU , 7200 ) LSTNO , IH
      WRITE ( CMON, 7200) LSTNO, IH
      CALL XPRVDU(NCVDU, 1,0)
7200  FORMAT(' Illegal list number for ''',A1,'punch''')
      CALL XERHND ( IERERR )
      RETURN
C--CHECK THE TYPE OF PUNCH
7300  CONTINUE
C           A     B     C     D     E     F     G
      GOTO (7310, 7340, 7320, 7330, 7350, 7360, 7370 ) ICLASS+2
      RETURN
C--NORMAL PUNCH FORMAT
7310  CONTINUE
      CALL XPCH6G(LSTNO,ICLASS)
      RETURN
C--NORMAL DATA, ONE REFLECTION PRE CARD
7320  CONTINUE
      CALL XPCH6S(LSTNO)
      RETURN
C--OBSERVED QUANTITIES ONLY
7330  CONTINUE
      CALL XPCH6O(LSTNO)
      RETURN
C----- CIF OUTPUT F's
7340  CONTINUE
      CALL XPCH6C(LSTNO,0)
      RETURN
C----- CIF OUTPUT F^2's
7350  CONTINUE
      CALL XPCH6C(LSTNO,1)
      RETURN
C----- PLAIN SHELX HKL OUTPUT
7360  CONTINUE
      CALL XPCH6X(LSTNO,0)
      RETURN
C----- SHELX HKL OUTPUT of FC with made up sigmas.
7370  CONTINUE
      CALL XPCH6X(LSTNO,1)
      RETURN
      END

