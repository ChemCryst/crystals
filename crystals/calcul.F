C $Log: not supported by cvs2svn $
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
