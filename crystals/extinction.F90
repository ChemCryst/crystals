module extinction_mod

logical, public :: extinct

type extinction_type
real :: pol1, pol2, del
real :: ext
end type

type(extinction_type), public :: extinct_parameters

contains

subroutine sphericalextinct_init(wavelength, radiationtype)
use xlst01_mod, only: l1p1
use store_mod, only:store
!use xlst05_mod, only: l5o
use xlst13_mod, only: L13DC
use xlst05_mod, only: L5o
use math_mod, only: radians
#if defined(_GIL_) || defined(_LIN_) 
use sleef    
#endif
implicit none

real, intent(in) :: wavelength
integer, intent(in) :: radiationtype

real theta1, theta2, s, a, c
real, dimension(2) :: theta2sincos

    THETA1=radians(STORE(L13DC+1))
    THETA2=radians(STORE(L13DC+2))
    extinct_parameters%EXT=STORE(L5O+5)
    
    extinct_parameters%POL1=1.
    extinct_parameters%POL2=0.
    extinct_parameters%DEL=wavelength**2/STORE(L1P1+6)**2
    if(radiationtype.LT.0) then   ! CHECK IF WE ARE USING NEUTRONS OR XRAYS
!--WE ARE USING XRAYS
        extinct_parameters%DEL=extinct_parameters%DEL*wavelength*0.0794
!  SET UP THE POLARISATION CONSTANTS
#if defined(_GIL_) || defined(_LIN_) 
        !A=COS(THETA2)**2
        !C=SIN(THETA2)**2
        !S=COS(THETA1)**2
        call sleef_sincosf(THETA2, theta2sincos)          
        theta2sincos=theta2sincos**2
        s=sleef_cosf(THETA1)          
#else
        theta2sincos=(/ SIN(THETA2), COS(THETA2) /)**2 ! C, A
        !A=COS(THETA2)**2
        !C=SIN(THETA2)**2
        S=COS(THETA1)**2
#endif
        extinct_parameters%POL1=theta2sincos(2)+theta2sincos(1)*S
!djwoct2010 POL2 had found itself outside of the if clause
        extinct_parameters%POL2=theta2sincos(1)+theta2sincos(2)*S
    end if
end subroutine

subroutine sphericalextinct_coefs(wavelength, radiationtype, sst, reflectiondata, extinct_coeficients)
use xconst_mod, only: zero
implicit none
real, dimension(4), intent(out) :: extinct_coeficients
real a, delta, path
real, intent(in) :: wavelength ! ang
integer, intent(in) :: radiationtype
real, intent(in) :: sst
real, dimension(:), intent(in) :: reflectiondata

    A=MIN(1.,wavelength*sqrt(sST))
    !A=ASIN(A)*2.
    PATH=reflectiondata(1+9)  ! CHECK MEAN PATH LENGTH
    if(PATH.LE.ZERO) PATH = 1.
    !DELTA=DEL*PATH/SIN(A)  ! COMPUTE DELTA FOR NEUTRONS
    ! sin(a) = sin(sin-1(a)*2.0) (see above)
    ! equivalent to 2*a*sqrt(1-a**)
    DELTA=extinct_parameters%DEL*PATH/(2.0*a*sqrt(1.0-a**2))
    if(radiationtype.LT.0)THEN ! WE ARE USING XRAYS
        ! cos(a) = cos(sin-1(a)*2.0) (see above)
        ! equivalent to 1-2a**2
        !A=COS(A)**2
        A=1.0-2.0*a**2
        DELTA=DELTA*(extinct_parameters%POL1+extinct_parameters%POL2*A*A)/(extinct_parameters%POL1+extinct_parameters%POL2*A)
    end if
    extinct_coeficients(1)=1.+2.*extinct_parameters%EXT*reflectiondata(1+5)**2*DELTA
    extinct_coeficients(2)=1.0+extinct_parameters%EXT*reflectiondata(1+5)**2*DELTA
    extinct_coeficients(3)=extinct_coeficients(2)/(extinct_coeficients(1)**(1.25))
    extinct_coeficients(4)=(extinct_coeficients(1)**(-.25))
end subroutine

end module
