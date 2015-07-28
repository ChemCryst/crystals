c      COMMON/XCONST/NOWT,PI,TWOPI,TWOPIS,RTD,DTR,
c     2 UISO,ZERO,ZEROSQ,VALUE,VALUSQ,BLANKS

      character(len=88), parameter :: BLANKS =      ''
      integer, PARAMETER :: NOWT= -1000000 
      real, PARAMETER :: UISO = 0.0000005, ZERO = 0.00005, VALUE = 0.0001 
      real, PARAMETER :: PI = 3.1415926535897932 
      real, PARAMETER :: TWOPI = 2.0 * PI 
      real, PARAMETER :: TWOPIS = TWOPI * PI 
      real, PARAMETER :: RTD = 180.0 / PI 
      real, PARAMETER :: DTR = PI / 180.0 
      real, PARAMETER :: ZEROSQ = ZERO * ZERO 
      real, PARAMETER :: VALUSQ = VALUE * VALUE 

