c      COMMON /XLSVAL/ ILSCLN , ILSCLS , ILSCLV , ILSEXI , ILSAVI ,
c     2 ILSMSG , ILSNMS , ILSERF , ILSPUF , ILSDLF , ILSOWF , ILSCUR ,
c     3 ILSRTF , ILSSET , ILSCLR , ILSOVR , ILSRDY , ILSUPD , ILSRFI



c      DATA ILSCLN / 1 / , ILSCLS / 2 / , ILSCLV / 3 /
c      DATA ILSEXI / 4 / , ILSAVI / 5 / , ILSRFI / 6 /

c      DATA ILSERF / 1 / , ILSPUF / 2 / , ILSDLF / 3 /
c      DATA ILSOWF / 4 / , ILSCUR / 5 / , ILSRTF / 2 /

c      DATA ILSMSG / 1 / , ILSNMS / -1 /

c      DATA ILSSET / -1 / , ILSCLR / 1 /
c      DATA ILSOVR / -1 / , ILSRDY / 0 / , ILSUPD / 1 /

      integer, parameter :: ILSCLN=1, ILSCLS=2, ILSCLV=3,
     1            ILSEXI=4, ILSAVI=5, ILSRFI=6 

      integer, parameter :: ILSERF=1, ILSPUF=2, ILSDLF=3,
     1            ILSOWF=4, ILSCUR=5, ILSRTF=2 

      integer, parameter :: ILSSET=-1, ILSCLR=1, ILSOVR=-1,
     1            ILSRDY=0, ILSUPD=1 


      integer :: ILSMSG, ILSNMS

      COMMON /XLSVAL/ 
     2 ILSMSG , ILSNMS 
