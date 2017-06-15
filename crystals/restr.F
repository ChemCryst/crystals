C $Log: not supported by cvs2svn $
C Revision 1.1.1.1  2004/12/13 11:16:07  rich
C New CRYSTALS repository
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
C Revision 1.3  2001/02/26 10:30:23  richard
C Added changelog to top of file
C
C
CODE FOR RESTR
      SUBROUTINE RESTR
      CALL XSYSDC(-1,1)
      CALL XWASER
      RETURN
      END
C
CODE FOR XWASER
      SUBROUTINE XWASER
C--SUBROUTINE TO CONTROL THE APPLICATION AND CHECKING OF RESTRAINTS.
C
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'QSTORE.INC'

      interface 
          subroutine XAPP16(calconlyarg)
              logical, optional, intent(in) :: calconlyarg
          end subroutine
      end interface
C
C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C--BRANCH ON THE TYPE OF OPERATION
      GOTO (2000,3000,4000,5000,1300),NUM
1300  CALL GUEXIT(341)
C
C--ROUTNE APPLY THE RESTRAINTS STORED IN LIST 16/26
2000  CONTINUE
      CALL XAPP16
      RETURN
C
C--ROUTINE TO CHECK THE RESTRAINTS STORED IN LIST 16/26
3000  CONTINUE
      CALL XCHK16
      RETURN
C
C--'#END' INSTRUCTION
4000  CONTINUE
      CALL XMONTR(-1)
      CALL XEND
      RETURN
C
C--'#TITLE' INSTRUCTION
5000  CONTINUE
      CALL XRCN
      RETURN
      END

