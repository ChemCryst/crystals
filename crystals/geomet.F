C $Log: geomet.F,v $
C Revision 1.8  2011/11/03 09:21:18  rich
C Support #SUS command.
C
C Revision 1.7  2009/12/23 08:24:17  djw
C Add link to vcv matrix - not yet finished
C
C Revision 1.6  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.5  2001/12/14 14:44:30  Administrator
C
C DJW Combine TLS amd MOLAX into new module GEOEMTRY. This enables angles
C beween plane normals (etc) and libration axes to be computed.  Add code
C to enable TLS restaints to be generated, and to enable the user to
C modify the T and L tensors
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
C Revision 1.3  2001/02/26 10:26:48  richard
C Added changelog to top of file
C
C
CODE FOR GEOMET
      SUBROUTINE GEOMET
      CALL XSYSDC(-1,1)
      CALL XGEOM
      RETURN
      END
C
CODE FOR XGEOM
      SUBROUTINE XGEOM
C--CONTROL ROUTINE FOR GEOMETRICAL CALCULATIONS
      INCLUDE 'XUNITS.INC'
C
C--LOAD THE NEXT '#INSTRUCTION'
      NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
C
C--CHECK IF WE SHOULD RETURN
      IF(NUM.LE.0) RETURN
C
C--BRANCH ON THE TYPE OF OPERATION
1200  CONTINUE
      GOTO (2000,3000,3500,4000,5000,9000,9500,1300),NUM
1300  CALL GUEXIT(342)
C
C--MOLECULAR AXES CALCULATION
2000  CONTINUE
      CALL SMOLAX
      RETURN
C
C--TORSION ANGLE CALCULATION
3000  CONTINUE
      CALL HTORS
      RETURN
C
C--COMBINED MOLAX/TLS
3500  CONTINUE
      CALL SGEOM
      RETURN
C
C--VCV MATRIX
4000  CONTINUE
      CALL VCV
      RETURN
C
C--SUS MATRIX
5000  CONTINUE
      CALL SUSCAL
      RETURN
C
C--'#END' INSTRUCTION
9000  CONTINUE
      CALL XMONTR(-1)
      CALL XEND
      RETURN

C--'#TITLE' INSTRUCTION
9500  CONTINUE
      CALL XRCN
      RETURN
      END

