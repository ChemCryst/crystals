C $Log: not supported by cvs2svn $
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

\XUNITS
\XERVAL

C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)

C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN

C--BRANCH ON THE TYPE OF OPERATION
      GO TO ( 200, 300, 400, 800, 810, 820, 500, 600, 700, 9910 ),NUM
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
C
9910  CONTINUE
      CALL XERHND ( IERPRG )
      RETURN

      END

