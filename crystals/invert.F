C $Log: invert.F,v $
C Revision 1.5  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.4  2001/10/08 12:25:58  ckp2
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
C Revision 1.3  2001/02/26 10:26:49  richard
C Added changelog to top of file
C
C
CODE FOR INVERT
      SUBROUTINE INVERT
      implicit none
      
      CALL XSYSDC(-1,1)
      CALL XSFLSD
      RETURN
      END
C
CODE FOR XSFLSD
      SUBROUTINE XSFLSD
      implicit none
C--MAIN CONTROL ROUTINE FOR INVERTING THE NORMAL MATRIX
C  AND SOLVING THE LEAST SQUARES EQUATIONS.

      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM24.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST24.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST24.INC'

      INCLUDE 'IDIM24.INC'
      
      INTEGER num, i, j, iclass, lstno, lstop
      
      INTEGER, EXTERNAL :: KRDDPV, KNXTOP

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)

C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN

C--BRANCH ON THE TYPE OF OPERATION
      GOTO (2000,6000,7000,8000,8500,8600,1300),NUM
1300  CALL GUEXIT(57)

C--'#INVERT'  -  INVERT THE NORMAL MATRIX
2000  CONTINUE
      CALL XSFLSE
      RETURN

C--'#SOLVE'  -  SOLVE THE NORMAL EQUATIONS
6000  CONTINUE
      CALL XSFLSG
      RETURN

C--'#NEWSHIFTS'  -  PREPARE LIST 24 WHEN IT IS OUT OF STEP
7000  CONTINUE
      I=KRDDPV(ISTORE(NFL),1)
C--LOAD LIST 12 TO FIND THE NUMBER OF LEAST SQUARES PARAMETERS
      CALL XFAL12(0,0,I,J)
      IF ( IERFLG .LT. 0 ) RETURN
C--SET THE ORDER OF THE SHIFT LIST
      N24=N12
C--CREATE LIST 24
      CALL XCELST(24,ICOM24,IDIM24)
C--WRITE THE LIST TO THE DISC
      CALL XWLSTD(24,ICOM24,IDIM24,0,0)
      CALL XRSL
      CALL XCSAE
      RETURN

C--'#CYCLENDS' INSTRUCTION
8000  CONTINUE
      I=KRDDPV(ISTORE(NFL),1)
      CALL XCYCLE
      RETURN

C--'#END' INSTRUCTION
8500  CONTINUE
      CALL XMONTR(-1)
      CALL XEND
      RETURN
C
C--'#TITLE' INSTRUCTION
8600  CONTINUE
      CALL XRCN
      RETURN
      END
C

