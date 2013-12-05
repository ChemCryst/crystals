C $Log: calcul.F,v $
C Revision 1.4  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.3  2003/02/14 17:09:01  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.2  2001/02/26 10:24:13  richard
C Added changelog to top of file
C
C
CODE FOR CALCUL
      SUBROUTINE CALCUL
      CALL XSYSDC ( -1 , 1 )
C----- CALL SFLS WITH PARAMETER READ ENABLED
      ITYP06 = 1
      CALL XSFLSB(1,ITYP06 )
      RETURN
      END
C

