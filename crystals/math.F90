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

!> Compute the determinant of a 3x3 matrix
real function determinant3x3(a) result(det)
	implicit none
    real, dimension(3,3), intent(in) :: a

	det = a(1,1)*(a(2,2)*a(3,3) - a(3,2)*a(2,3)) &
       + a(1,2)*(a(3,1)*a(2,3) - a(2,1)*a(3,3))  &
       + a(1,3)*(a(2,1)*a(3,2) - a(3,1)*a(2,2))
end function

!> Invert a matrix
subroutine matinv(a, ainv, ok_flag)
implicit none
real, dimension(3,3), intent(in)  :: a
real, dimension(3,3), intent(out) :: ainv
logical, intent(out) :: ok_flag
integer, dimension(minval(shape(a))) :: ipiv
integer info
double precision, dimension(ubound(a, 1)) :: work
double precision, dimension(3,3) :: b

b=a

    call dGETRF( ubound(a, 1), ubound(a, 2), b, ubound(a, 1), IPIV, INFO )
    call dGETRI( ubound(a, 1), b, ubound(a, 1), IPIV, WORK, ubound(a, 1), INFO	)

ainv=b

end subroutine

end module

