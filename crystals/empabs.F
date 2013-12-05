C $Log: empabs.F,v $
C Revision 1.4  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:10  rich
C New CRYSTALS repository
C
C Revision 1.3  2001/10/08 12:25:58  ckp2
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
C Revision 1.2  2001/02/26 10:25:32  richard
C Added changelog to top of file


CODE FOR DIFABS
      SUBROUTINE DIFABS
      CALL XSYSDC(-1,1)
      CALL XDIFAB
      RETURN
      END

CODE FOR XDIFAB
      SUBROUTINE XDIFAB
C--MAIN ROUTINE TO CONTROL DIFABS

      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'QSTORE.INC'

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0)RETURN

C--BRANCH ON THE TYPE OF OPERATION
      GO TO ( 2000 , 1500 ) , NUM

1500  CONTINUE
      CALL XERHND ( IERPRG )

2000  CONTINUE
C -- 'DIFABS' INSTRUCTION
      CALL XDFABS
      RETURN
      END

