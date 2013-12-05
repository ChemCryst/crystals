C $Log: trial.F,v $
C Revision 1.7  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:05  rich
C New CRYSTALS repository
C
C Revision 1.6  2001/10/08 12:25:59  ckp2
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
C Revision 1.5  2001/01/12 15:06:46  CKP2
C Make slant callable
C
C Revision 1.4  2000/12/05 12:44:42  CKP2
C make SLANT into subroutine
C
C Revision 1.3  2000/10/31 15:38:04  ckp2
C Link to XVSLANT code.
C
CODE FOR TRIAL
      SUBROUTINE TRIAL
      CALL XSYSDC(-1,1)
      CALL XTRLC
      RETURN
      END
C
CODE FOR XTRLC
      SUBROUTINE XTRLC
C--SLANT FOURIER AND TRIAL MAP CONTROL ROUTINE
C*******************************************************
C
C              Maximise THE PEARSON CORRELATION COEFF
C
C    r = [SIG{(Fo-<Fo>)(Fc-<Fc>)}] / [SIG(Fo-<Fo>)**2. SIG(Fc->Fc>)**2]
C         all coefficients are moduli
C
C--
C      ST UP A DUMMY ARRAY SO THAT XSLANT CAN BE CALLED INTERNALLY
      DIMENSION ADJW(1), IDJW(1)
      EQUIVALENCE (ADJW(1), IDJW(1))
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'QSTORE.INC'

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
      GOTO (2100,2200,2300,1500),NUM
1500  CALL GUEXIT(413)

C--'#TRIAL' INSTRUCTION
2100  CONTINUE
      CALL XTRIAL
      RETURN

C--'#SLANT' INSTRUCTION
2200  CONTINUE
      ADJW(1) = -100.
      CALL XSLANT(IDJW,1)
      RETURN

C--'#VSLANT' INSTRUCTION
2300  CONTINUE
      CALL XVSLANT
      RETURN
      END
C

