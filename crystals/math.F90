module math_mod

real, parameter:: pi=3.14159265359

contains

elemental real function degrees(angle_radians)
implicit none
real, intent(in) :: angle_radians

degrees=angle_radians*180.0/pi

end function

elemental real function radians(angle_degrees)
implicit none
real, intent(in) :: angle_degrees

radians=angle_degrees*pi/180.0

end function


end module
