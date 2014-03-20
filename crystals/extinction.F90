!> Calculate extinction parameters
module extinction_mod

logical, public :: extinct

type extinction_type
!> first part and second part of the polarisation correction
real :: pol1, pol2
!> the fixed part of delta
real :: del
!> extinction parameter (r*)  -  see larson in c.c. 1970.
real :: ext
!> Wavelength in angstrom
real :: wavelength
!> type of radiation. if <0, neutron radiation. Originally was variable NU
integer :: radiationtype
end type

type(extinction_type), private :: extinct_parameters

contains

!> Initialise common variables for extinction accross reflections
subroutine sphericalextinct_init(wavelength, radiationtype, THETA1, THETA2, ext, volume)
use math_mod, only: radians
#if defined(_GIL_) || defined(_LIN_) 
use sleef    
#endif
implicit none

!> Wavelength in angstrom
real, intent(in) :: wavelength
!> type of radiation. if <0, neutron radiation. Originally was variable NU
integer, intent(in) :: radiationtype
!> polarisation constants
real, intent(in) :: THETA1, THETA2
!> extinction parameter (r*)  -  see larson in c.c. 1970.
real, intent(in) :: ext
!> Unit cell volume
real, intent(in) :: volume

real theta1r, theta2r, s, a, c
real, dimension(2) :: theta2sincos

    THETA1r=radians(THETA1)
    THETA2r=radians(THETA2)
    extinct_parameters%EXT=ext
    extinct_parameters%radiationtype=radiationtype
    extinct_parameters%wavelength=wavelength
    extinct_parameters%POL1=1.
    extinct_parameters%POL2=0.
    extinct_parameters%DEL=wavelength**2/volume**2
    
    if(radiationtype.LT.0) then   ! CHECK IF WE ARE USING NEUTRONS OR XRAYS
!--WE ARE USING XRAYS
        extinct_parameters%DEL=extinct_parameters%DEL*wavelength*0.0794
!  SET UP THE POLARISATION CONSTANTS
#if defined(_GIL_) || defined(_LIN_) 
        !A=COS(THETA2)**2
        !C=SIN(THETA2)**2
        !S=COS(THETA1)**2
        call sleef_sincosf(THETA2r, theta2sincos)          
        theta2sincos=theta2sincos**2
        s=sleef_cosf(THETA1r)          
#else
        theta2sincos=(/ SIN(THETA2r), COS(THETA2r) /)**2 ! C, A
        !A=COS(THETA2)**2
        !C=SIN(THETA2)**2
        S=COS(THETA1r)**2
#endif
        extinct_parameters%POL1=theta2sincos(2)+theta2sincos(1)*S
!djwoct2010 POL2 had found itself outside of the if clause
        extinct_parameters%POL2=theta2sincos(1)+theta2sincos(2)*S
    end if
    
end subroutine

!> Calculate extinction coeficients
!! It needs a call to sphericalextinct_init before using this subroutine
subroutine sphericalextinct_coefs(sst, reflectiondata, extinct_coeficients)
use xconst_mod, only: zero
implicit none
!> extinction coefficients ext1, ext2, ext3, ext4, delta
!! - <b>ext1</b>  (1 + 2*(r*)* /fc/ **2*delta)
!! - <b>ext2</b>  (1 + (r*)* /fc/ **2*delta)
!! - <b>ext3</b>  ext1/ext2
!! - <b>ext4</b>  ext1^-0.25
!! - <b>delta</b> the extinction multiplier  -  see larson.
real, dimension(:), intent(out) :: extinct_coeficients
real a, delta, path
!> Rollett 5.12.8  sst = h"^t.h" = [sin(theta)/lambda]^2
real, intent(in) :: sst
!> list 6 contents plus extra bits, see @ref reflectionsdata
real, dimension(:), intent(in) :: reflectiondata

    A=MIN(1.,extinct_parameters%wavelength*sqrt(sST))
    !A=ASIN(A)*2.
    PATH=reflectiondata(1+9)  ! CHECK MEAN PATH LENGTH
    if(PATH.LE.ZERO) PATH = 1.
    !DELTA=DEL*PATH/SIN(A)  ! COMPUTE DELTA FOR NEUTRONS
    ! sin(a) = sin(sin-1(a)*2.0) (see above)
    ! equivalent to 2*a*sqrt(1-a**)
    DELTA=extinct_parameters%DEL*PATH/(2.0*a*sqrt(1.0-a**2))

    if(extinct_parameters%radiationtype.LT.0)THEN ! WE ARE USING XRAYS
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
    extinct_coeficients(5)=delta
    
end subroutine

end module
