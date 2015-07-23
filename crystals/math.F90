module math_mod
implicit none

real, parameter :: pi = 3.1415926535897932_8

contains

elemental function radians(angle)
	implicit none
	real, intent(in) :: angle
	real radians
	
	radians = angle*pi/180.0
end function

!***********************************************************************************************************************************
!  M33INV  -  Compute the inverse of a 3x3 matrix.
!
!  A       = input 3x3 matrix to be inverted
!  AINV    = output 3x3 inverse of matrix A
!  OK_FLAG = (output) .TRUE. if the input matrix could be inverted, and .FALSE. if the input matrix is singular.
!***********************************************************************************************************************************
SUBROUTINE M33INV (A, AINV, OK_FLAG)

IMPLICIT NONE

real, DIMENSION(3,3), INTENT(IN)  :: A
real, DIMENSION(3,3), INTENT(OUT) :: AINV
LOGICAL, INTENT(OUT) :: OK_FLAG

real, PARAMETER :: EPS = 1.0E-10
real :: DET
real, DIMENSION(3,3) :: COFACTOR


DET =   A(1,1)*A(2,2)*A(3,3)  &
&    - A(1,1)*A(2,3)*A(3,2)  &
&    - A(1,2)*A(2,1)*A(3,3)  &
&    + A(1,2)*A(2,3)*A(3,1)  &
&    + A(1,3)*A(2,1)*A(3,2)  &
&    - A(1,3)*A(2,2)*A(3,1)

IF (ABS(DET) .LE. EPS) THEN
 AINV = 0.0D0
 OK_FLAG = .FALSE.
 RETURN
END IF

COFACTOR(1,1) = +(A(2,2)*A(3,3)-A(2,3)*A(3,2))
COFACTOR(1,2) = -(A(2,1)*A(3,3)-A(2,3)*A(3,1))
COFACTOR(1,3) = +(A(2,1)*A(3,2)-A(2,2)*A(3,1))
COFACTOR(2,1) = -(A(1,2)*A(3,3)-A(1,3)*A(3,2))
COFACTOR(2,2) = +(A(1,1)*A(3,3)-A(1,3)*A(3,1))
COFACTOR(2,3) = -(A(1,1)*A(3,2)-A(1,2)*A(3,1))
COFACTOR(3,1) = +(A(1,2)*A(2,3)-A(1,3)*A(2,2))
COFACTOR(3,2) = -(A(1,1)*A(2,3)-A(1,3)*A(2,1))
COFACTOR(3,3) = +(A(1,1)*A(2,2)-A(1,2)*A(2,1))

AINV = TRANSPOSE(COFACTOR) / DET

OK_FLAG = .TRUE.

RETURN

END SUBROUTINE M33INV

end module
