C $Log: not supported by cvs2svn $
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
C Revision 1.4  2001/07/03 08:59:18  ckp2
C Rotax function #ROTAX/PARAM TOL=0.2/END
C
C Revision 1.3  2001/02/26 10:29:09  richard
C Added changelog to top of file
C
C
CODE FOR PRCSS6
      SUBROUTINE PRCSS6
      CALL XSYSDC(-1,1)
      CALL XPRC06
      RETURN
      END
C
CODE FOR XPRC06
      SUBROUTINE XPRC06
C--MAIN ROUTINE TO CONTROL THE PROCESSING OF LIST 6

\ISTORE
\STORE
\XUNITS
\XLST50
\QSTORE

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION

      GOTO (1500,2200,2300,2400,2500,2550,2600,2700,4000,4100,
     2      1500),NUM
1500  CALL GUEXIT(324)

C--'#SYST' INSTRUCTION
2200  CONTINUE
      CALL XSYST
      RETURN
          
C--'#SORT' INSTRUCTION
2300  CONTINUE
      CALL XSORT
      RETURN

C--'#MERGE' INSTRUCTION
2400  CONTINUE
      CALL WMERGE
      RETURN

C--'#ROTAX' INSTRUCTION
2500  CONTINUE
      CALL XROTAX
      RETURN

C--'#WILSON' INSTRUCTION
2550  CONTINUE
      CALL MLTNRM
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

C--'#LP' INSTRUCTION
4000  CONTINUE
      CALL XLP
      RETURN

C--'#REORDER' INSTRUCTION
4100  CONTINUE
      CALL XREORD
      RETURN
      END

