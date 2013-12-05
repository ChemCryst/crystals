C $Log: fourie.F,v $
C Revision 1.6  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:10  rich
C New CRYSTALS repository
C
C Revision 1.5  2003/12/02 11:52:33  rich
C Code for \MASK command.
C
C Changed output of Fourier map data, so that the cell is NOT permuted
C in the output file. This makes the output the same form as the
C \slant file. The permutation can be recovered from the translation
C matrix given at the top of the file.
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

      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM24.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST24.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST24.INC'

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

