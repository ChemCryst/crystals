C $Log: not supported by cvs2svn $
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
C Revision 1.3  2001/02/26 10:26:47  richard
C Added changelog to top of file
C
C
CODE FOR FOURIE
      SUBROUTINE FOURIE
      CALL XSYSDC(-1,1)
      CALL XFOURA
      RETURN
      END
C
CODE FOR XFOURA
      SUBROUTINE XFOURA
C--MAIN CONTROL ROUTINE FOR FOURIER CALCULATIONS

\ISTORE
\ICOM24
\STORE
\XUNITS
\XLST12
\XLST24
\XLST50
\QSTORE
\QLST24

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)

C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION

      GOTO (2000,8000,8100,2010,1300),NUM

1300  CALL GUEXIT(541)

C--'#FOURIER' INSTRUCTION
2000  CONTINUE
      CALL XFOURB
      RETURN

C--'#MASK' INSTRUCTION
2010  CONTINUE
      CALL XMASK(0)
      RETURN

C--'#END' INSTRUCTION
8000  CONTINUE
      CALL XMONTR(-1)
      CALL XEND
      RETURN

C--'#TITLE' INSTRUCTION
8100  CONTINUE
      CALL XRCN
      RETURN
      END

