C $Log: prcss6.F,v $
C Revision 1.12  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:08  rich
C New CRYSTALS repository
C
C Revision 1.11  2003/09/17 14:38:11  rich
C Thetabs call inserted just slightly in the wrong place. Fixed.
C
C Revision 1.10  2003/09/05 19:28:58  djw
C Spherical absorption corection Directive
C
C Revision 1.9  2003/07/15 09:46:21  rich
C New SGPLOT instruction. Takes a 3x3 matrix,A, to select reflection classes
C (if h == Ah, then the reflection is selected). Takes a 3x1 vector, B, and
C a value, N, to split the selected class into two conditions (if mod(B'h,N) is
C zero the reflection is 'allowed' if it is non-zero the reflection is
C 'dis-allowed'. These allowed and disallowed from the class are plotted as
C two series of a bar graph showing frequency vs. sqrt(Fo).
C
C Revision 1.8  2003/07/08 10:08:03  rich
C
C New #TWINPLOT instruction. Given a twin-law, it
C builds a histogram of deviation of transformed lattice
C points, h' (=R.h), from integer lattice points.
C The units are A-1, the same as ROTAX and the TWINTOL
C parameter used for reading in twin laws. This graph may
C be used to choose a suitable TWINTOL.
C
C Revision 1.7  2002/02/28 18:04:20  ckp2
C New command #SIGMADIST for producing sigma distribution graph. It doesn't
C do anything else.
C
C Revision 1.6  2002/02/28 11:34:46  ckp2
C Wilson plot & E stat code.
C
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
c
      GOTO (1500,2200,2300,2400,2500,2550,2600,2700,4000,4100,
     2      4200,4300,4400,4500,1500),NUM
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

C--'#SIGMADIST' INSTRUCTION
4200  CONTINUE
      CALL XSGDST
      RETURN
C
C--'#TWINPLOT' INSTRUCTION
4300  CONTINUE
      CALL XTWINP
      RETURN

C--'#SGPLOT' INSTRUCTION
4400  CONTINUE
      CALL XSPGPL
      RETURN
c
C--'#THETABS'INSTRUCTION
4500  CONTINUE
      CALL XTHABS
      RETURN
      END



