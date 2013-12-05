C $Log: prcss.F,v $
C Revision 1.6  2009/11/03 11:17:43  djw
C Add comments and set up processing for LIST 18, the SMILES string
C
C Revision 1.5  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:08  rich
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
C Revision 1.3  2001/02/26 10:29:09  richard
C Added changelog to top of file
C
C
CODE FOR PRCSS
      SUBROUTINE PRCSS
      CALL XSYSDC(-1,1)
      CALL XPRCLS
      RETURN
      END
C
CODE FOR XPRCLS
      SUBROUTINE XPRCLS
C--LIST PROCESSING CONTROL ROUTINES
C
      INCLUDE 'XUNITS.INC'
C--
C      see also INPUT.FPP
C--FETCH THE NEXT '#INSTRUCTION' FROM THE INPUT STREAM
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
c      write(ncwu,'(3(a,i6))') 'List op =', lstop, ' List no =', LSTNO,
c     1 'Num = ', num
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
      IF(LSTOP-1)1250,1250,3000
C--LIST PROCESSING
1250  CONTINUE
      GOTO (2100, 2200, 2300,1300 ),  NUM
1300  CALL GUEXIT(160)
C
C--PROCESS LIST 12 TO PRODUCE LIST 22
2100  CONTINUE
      CALL XPRC12
      RETURN
C
C--PROCESS LIST 16 TO PRODUCE LIST 26
2200  CONTINUE
      CALL XPRC16
      RETURN
C
C----- PROCESS LISTS 5 AND 12 TO SET UP SPECIAL POSITION CONDITIONS
2300  CONTINUE
      CALL XSPECM
      RETURN
C
C--LIST PRINTING OR PUNCHING
3000  CONTINUE
      IF(LSTOP-2)3100,3200,3100
C--ILLEGAL OPERATION
3100  CONTINUE
      CALL XMONTR(0)
      RETURN
C--CHECK FOR LIST 22 PRINT
3200  CONTINUE
      IF(NUM-1)3100,3300,3100
C--PRINT LIST 22
3300  CONTINUE
      CALL XRSL
      CALL XCSAE
      CALL XMONTR(-1)
      CALL XPRT22
      RETURN
      END

