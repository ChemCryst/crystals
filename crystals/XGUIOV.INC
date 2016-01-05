      integer, parameter :: MAXAT = 5000 * 3, MATINF = 600
      LOGICAL LGUIL1, LGUIL2, LUPDAT, QSINL5, INSTRC, PTINL5
      real, dimension(matinf) :: ATINF
      
      real :: RLENTH, TMPLEN, TSTORE(MAXAT)
      real :: GCENTX, GCENTY, GCENTZ      
      integer :: ISERIA, NATINF, IATINF(MATINF)
      
      COMMON /XGUIOV/ RLENTH, TMPLEN, ISERIA, NATINF, 
     1 LGUIL1, LGUIL2, LUPDAT, QSINL5, INSTRC,
     2 IATINF, TSTORE, GCENTX, GCENTY, GCENTZ, PTINL5
     
      integer KSTAT1, KSTAT2, KSTAT3, KSTAT5,
     1                KSTAT6, KSTATQ, KSTATI, KSTATP
      COMMON /XGUIST/ KSTAT1, KSTAT2, KSTAT3, KSTAT5,
     1                KSTAT6, KSTATQ, KSTATI, KSTATP
      
      integer, dimension(50) :: ISERnn
      COMMON/JSERNN/ ISERNN

