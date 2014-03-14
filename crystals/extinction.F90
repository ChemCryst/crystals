module extinction_mod

logical, public :: extinct

contains

subroutine sphericalextinct_init(wavelength, radiationtype, pol1, pol2, del)
use xlst01_mod, only: l1p1
use store_mod, only:store
!use xlst05_mod, only: l5o
use xlst13_mod, only: L13DC
use math_mod, only: radians
implicit none

real, intent(out) :: pol1, pol2, del
real, intent(in) :: wavelength
integer, intent(in) :: radiationtype

real theta1, theta2, s, a, c

    THETA1=STORE(L13DC+1)
    THETA2=STORE(L13DC+2)

    !EXT=STORE(L5O+5)
    POL1=1.
    POL2=0.
    DEL=wavelength*wavelength/(STORE(L1P1+6)*STORE(L1P1+6))
    if(radiationtype.LT.0) then   ! CHECK IF WE ARE USING NEUTRONS OR XRAYS
!--WE ARE USING XRAYS
        DEL=DEL*wavelength*0.0794
!  SET UP THE POLARISATION CONSTANTS
        THETA2=radians(THETA2) !  D converts from degrees to radians
        A=COS(THETA2)
        C=SIN(THETA2)
        S=COS(radians(THETA1))
        A=A*A
        C=C*C
        S=S*S
        POL1=A+C*S
!djwoct2010 POL2 had found itself outside of the if clause
        POL2=C+A*S
    end if
end subroutine

end module
