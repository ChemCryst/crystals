C $Log: aniso.F,v $
C Revision 1.6  2008/09/08 10:18:32  djw
C Enable/inhibit punching of ADP info from XPRAXI
C
C Revision 1.5  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.4  2001/10/08 12:25:57  ckp2
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
C Revision 1.3  2001/02/26 10:24:13  richard
C Added changelog to top of file
C
C
CODE FOR ANISO
      SUBROUTINE ANISO
      CALL XSYSDC(-1,1)
      CALL XANISO
      RETURN
      END
C
CODE FOR XANISO
      SUBROUTINE XANISO
C--CONTROL ROUTINE FOR ANISO CALCULATIONS
C
C--
C
      INCLUDE 'XUNITS.INC'
C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)

C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
      GO TO (2000,3000,8000,8100,1300),NUM
1300      CALL GUEXIT (343)

C--COMPUT THE COMPONENTS AND COSINES FROM THE ANISO T.F.'S
2000  CONTINUE
      CALL XPRAXI( -1, -1, 0, J, K, L, 2, 0, 0)
      RETURN
C
C--TLS CALCULATIONS
3000  CONTINUE
      CALL RSUB06
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

