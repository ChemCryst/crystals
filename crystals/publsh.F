C $Log: not supported by cvs2svn $
C Revision 1.7  2002/07/29 13:01:41  richard
C #THLIM calls completeness code, which inserts values into L30.
C
C Revision 1.6  2001/10/08 12:25:58  ckp2
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
C Revision 1.5  2001/02/26 10:29:07  richard
C Added changelog to top of file
C
C
CODE FOR PUBLSH
      SUBROUTINE PUBLSH
      CALL XSYSDC(-1,1)
      CALL XPUBL
      RETURN
      END
C
CODE FOR XPUBL
      SUBROUTINE XPUBL
C--MAIN ROUTINE TO CONTROL PUBLICATION LISTINGS
C
C--
\XERVAL
C
C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
C
C  REFLECTIONS  PARAMETERS  SUMMARY  GENERALEDIT  CIFOUT
C
      GO TO ( 2100, 2200, 2300, 2400, 2600, 2700, 1500 ) , NUM
1500  CONTINUE
      CALL XERHND ( IERPRG )
C
C--'#REFLECTIONS' INSTRUCTION
2100  CONTINUE
      CALL SPRT6P
      RETURN
C
C--'#PARAMETERS' INSTRUCTION
2200  CONTINUE
      CALL SPRT5P
      RETURN
C
2300  CONTINUE
C
C -- 'SUMMARY'
C
      CALL XSMMRY
      RETURN
C
2400  CONTINUE
C
C -- 'GENERALEDIT'
C
      CALL XGENED
      RETURN
2600  CONTINUE
C----- CIFOUT CIF OUTPUT
      CALL XCIFX
      RETURN

2700  CONTINUE
C----- THLIM - work out completeness, and stick in L30.
      CALL XTHX
      RETURN
C
      END
C

CODE FOR XTHX
      SUBROUTINE XTHX

      CALL XCSAE
      I = KRDDPV ( IPLOT , 1 )

      IF (I.GE.0) CALL XTHLIM(RICA,RICB,RICC,RICD,RICE,IPLOT)
      RETURN
      END
