C $Log: not supported by cvs2svn $
C Revision 1.5  2001/10/08 12:25:59  ckp2
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
C Revision 1.4  2001/09/19 08:50:10  ckp2
C Template #VISUALISE command for Steven's project.
C
C Revision 1.3  2001/02/26 10:30:24  richard
C Added changelog to top of file
C
C
CODE FOR WEIGHT
      SUBROUTINE WEIGHT
      CALL XSYSDC(-1,1)
      CALL XWAITS
       RETURN
      END

CODE FOR XWAITS
      SUBROUTINE XWAITS
C--SUBROUTINE TO CONTROL THE APPLICATION OF LIST 4 AND CHECK THE RESULTS
\XUNITS
C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
      GOTO (2000,3000,1300,8000,8100,1300),NUM
1300  CALL GUEXIT(601)

C--ROUTINE TO APPLY THE PARAMETERS IN LIST 4
2000  CONTINUE
      CALL XAPP04
      RETURN

C--ROUTINE TO CHECK THE WEIGHTING SCHEME
3000  CONTINUE
      CALL XANAL
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
C
