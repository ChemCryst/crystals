C $Log: weight.F,v $
C Revision 1.12  2008/12/18 16:40:05  djw
C Add LEVEL parameter to control level of output
C
C Revision 1.11  2007/12/12 16:05:12  djw
C Normlise GOF
C
C Revision 1.10  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.9  2003/03/05 16:53:18  rich
C Removed dynamic arrays from weighting routine. There is no way all reflections
C can be held in memory for large structures. Stack overflows.
C The Sheldrick weights now use multiple passes of L6 to calculate best fits.
C
C Revision 1.8  2003/02/14 17:09:02  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.7  2002/06/24 15:33:50  richard
C Load list 6 before calling XAPP04, so that it can use dynamic arrays.
C
C Revision 1.6  2002/03/16 19:07:47  richard
C Removed #VISUALISE command - originally present as prototype for Steve, but
C now graphs are built into other commands.
C
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
C
      PARAMETER (NPROC4=5)
      DIMENSION IPROC4(NPROC4)
      INCLUDE 'XUNITS.INC'
C
C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
      GOTO (2000,3000,1300,8000,8100,4000,1300),NUM
1300  CALL GUEXIT(601)

C--ROUTINE TO APPLY THE PARAMETERS IN LIST 4
2000  CONTINUE

C--READ ANY DIRECTIVES THAT OFFER THEMSELVES
      I=KRDDPV(IPROC4,NPROC4)
      IF ( I .LT. 0 ) GO TO 1300
c      IULN06 = KTYP06(IPROC4(3))
c      CALL XFAL06(IULN06, 0) !Get N6D for dynamic arrays in XAPP04
      CALL XAPP04(IPROC4,NPROC4)
      RETURN

C--ROUTINE TO CHECK THE WEIGHTING SCHEME
3000  CONTINUE
      CALL XANAL
      RETURN
c
c----- Scale the weights
4000  continue
c      call xrewt
      write(ncwu,*)' Not available'
      return
c
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

