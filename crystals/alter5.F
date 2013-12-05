C $Log: alter5.F,v $
C Revision 1.8  2011/04/08 12:58:47  djw
C Add ORIGIN module
C
C Revision 1.7  2007/10/09 06:48:32  djw
C Add hyrdogen renumbering
C
C Revision 1.6  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.5  2003/03/26 10:36:09  rich
C Prototype #MATCH code. Syntax: #MATCH/MAP atoms/ONTO atoms/END
C It does the match, refines it, prints stats and writes a cameron.ini
C and regular.l5i which can be viewed by choosing "Graphics"->"Special"->"existing input files".
C
C Revision 1.4  2002/12/16 18:00:27  rich
C New Perturb command. Allows per parameter shift multipliers, and a general
C multiplier to apply to all shifts. The shifts respect weights setup in
C List 22 so that atoms do not move from special positions, and competing
C occupancies continue to add up to the same number. By default it creates
C new list 5s, but can be forced not to by directing: "WRITE OVER=YES".
C Shifts for XYZ are given in Angstrom, for OCC in natural units, for overall and
C temperature factors as a fraction of the existing value.
C
C Revision 1.3  2001/10/08 12:25:57  ckp2
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
C Revision 1.2  2001/02/26 10:24:13  richard
C Added changelog to top of file
C
C
CODE FOR ALTER5
      SUBROUTINE ALTER5
      CALL XSYSDC(-1,1)
      CALL XMODL5
      RETURN
      END

CODE FOR XMODL5
      SUBROUTINE XMODL5
C--SUBROUTINE TO MODIFY THE CONTENTS OF LIST 5.

      INCLUDE 'XUNITS.INC'
      INCLUDE 'XERVAL.INC'

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)

C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN

C--BRANCH ON THE TYPE OF OPERATION
      GO TO ( 200,300,400,800, 810, 820, 500, 600, 700, 830, 840, 
     1 850, 9910 ),NUM
      GO TO 9910

C--ROUTINES TO MODIFY LIST 5
200   CONTINUE
      CALL XMOD05
      RETURN

C--ROUTINE TO CONVERT ANISO TEMPERATORE FACTORS.
300   CONTINUE
      CALL XBUC
      RETURN

C--ROUTINE TO GENERATE HYDROGEN ATOMS
400   CONTINUE
      CALL SYDROG
      RETURN

C----- PERHYDRO COMMAND
500   CONTINUE
      CALL XPERHY
      RETURN

C----- VOIDS COMMAND
600   CONTINUE
      CALL XVOID
      RETURN

C----- PERTURB COMMAND
700   CONTINUE
      CALL PRTB12
      RETURN

C--'#END' INSTRUCTION
800   CONTINUE
      CALL XMONTR(-1)
      CALL XEND

C--'#TITLE' INSTRUCTION
810   CONTINUE
      CALL XRCN
      RETURN

C -- 'REGULARISE' INSTRUCTION
820   CONTINUE
      CALL XREGUL
      RETURN

C -- 'MATCH' INSTRUCTION
830   CONTINUE
      CALL XMATCH
      RETURN

C -- 'HNAME' INSTRUCTION
840   CONTINUE
      CALL XSYSTH
      RETURN
C
C --  'ORIGIN' INSTRUCTION
850   CALL XORIGIN
      RETURN
C
C
9910  CONTINUE
      CALL XERHND ( IERPRG )
      RETURN

      END

