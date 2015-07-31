      integer, PARAMETER :: IFLMAX = 20
      integer                                     IFLIND,NCLU
      integer, dimension(IFLMAX) :: NCUFU,IFLCHR
      integer                                            IRDPAG, IRDLIN
      integer, dimension(IFLMAX) :: IRDLOG, IRDCPY, IRDCAT
      integer, dimension(IFLMAX) :: IRDCMS, IRDINC, IRDSCR, IRDSRQ
      integer, dimension(IFLMAX) :: IRDREC, IRDFND, IRDHGH
            
      COMMON /UFILE/ NCUFU,IFLCHR,IFLIND,NCLU,
     2 IRDLOG, IRDCPY, IRDCAT, IRDPAG, IRDLIN,
     3 IRDCMS, IRDINC, IRDSCR, IRDSRQ,
     4 IRDREC, IRDFND, IRDHGH
     
      integer, PARAMETER :: NFLMAX=55
      integer, dimension(8, NFLMAX) :: KEYFIL
      integer, dimension(NFLMAX) :: IFLUNI, IFLACC
      integer, dimension(NFLMAX) :: IFLSTA, IFLFRM, IFLREA, IFLOPN
      integer, dimension(NFLMAX) :: IFLLCK 
      integer NFLUSD 
      
      COMMON /XFLDAT/ KEYFIL, IFLUNI, IFLACC,
     1  IFLSTA, IFLFRM, IFLREA, IFLOPN,
     2  IFLLCK , NFLUSD 

