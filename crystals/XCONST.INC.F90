!      COMMON/XCONST/NOWT,PI,TWOPI,TWOPIS,RTD,DTR,
!     2 UISO,ZERO,ZEROSQ,VALUE,VALUSQ,BLANKS
module xconst_mod

character(len=88), parameter :: blanks = '' 
integer, parameter :: nowt= -1000000 
real, parameter :: uiso = 0.0000005, zero = 0.00005
real, parameter :: value = 0.0001 
real, parameter :: pi = 3.1415926535897932 
real, parameter :: twopi = 2.0 * pi 
real, parameter :: twopis = twopi * pi 
real, parameter :: rtd = 180.0 / pi 
real, parameter :: dtr = pi / 180.0 
real, parameter :: zerosq = zero * zero 
real, parameter :: valusq = value * value 

end module
