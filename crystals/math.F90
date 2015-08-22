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

elemental function degrees(angle)
	implicit none
	real, intent(in) :: angle
	real degrees
	
	degrees = angle*180.0/pi
end function

!***********************************************************************************************************************************
!  M33INV  -  Compute the inverse of a 3x3 matrix.
!
!  A       = input 3x3 matrix to be inverted
!  AINV    = output 3x3 inverse of matrix A
!  OK_FLAG = (output) .TRUE. if the input matrix could be inverted, and .FALSE. if the input matrix is singular.
!***********************************************************************************************************************************
subroutine m33inv (a, ainv, ok_flag)

implicit none

real, dimension(3,3), intent(in)  :: a
real, dimension(3,3), intent(out) :: ainv
logical, intent(out) :: ok_flag

real, parameter :: eps = 1.0e-10
real :: det
real, dimension(3,3) :: cofactor


det =   a(1,1)*a(2,2)*a(3,3)  &
&    - a(1,1)*a(2,3)*a(3,2)  &
&    - a(1,2)*a(2,1)*a(3,3)  &
&    + a(1,2)*a(2,3)*a(3,1)  &
&    + a(1,3)*a(2,1)*a(3,2)  &
&    - a(1,3)*a(2,2)*a(3,1)

if (abs(det) .le. eps) then
 ainv = 0.0d0
 ok_flag = .false.
 return
end if

cofactor(1,1) = +(a(2,2)*a(3,3)-a(2,3)*a(3,2))
cofactor(1,2) = -(a(2,1)*a(3,3)-a(2,3)*a(3,1))
cofactor(1,3) = +(a(2,1)*a(3,2)-a(2,2)*a(3,1))
cofactor(2,1) = -(a(1,2)*a(3,3)-a(1,3)*a(3,2))
cofactor(2,2) = +(a(1,1)*a(3,3)-a(1,3)*a(3,1))
cofactor(2,3) = -(a(1,1)*a(3,2)-a(1,2)*a(3,1))
cofactor(3,1) = +(a(1,2)*a(2,3)-a(1,3)*a(2,2))
cofactor(3,2) = -(a(1,1)*a(2,3)-a(1,3)*a(2,1))
cofactor(3,3) = +(a(1,1)*a(2,2)-a(1,2)*a(2,1))

ainv = transpose(cofactor) / det

ok_flag = .true.

return

end subroutine m33inv

!> Compute the determinant of a 3x3 matrix
real function determinant3x3(a) result(det)
	implicit none
    real, dimension(3,3), intent(in) :: a

	det = a(1,1)*(a(2,2)*a(3,3) - a(3,2)*a(2,3)) &
       + a(1,2)*(a(3,1)*a(2,3) - a(2,1)*a(3,3))  &
       + a(1,3)*(a(2,1)*a(3,2) - a(3,1)*a(2,2))
end function

end module
