module sleef

interface
  subroutine sleef_sincosf(input, sincos) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    real(kind=c_float), value :: input
    real(kind=c_float), dimension(2), intent(out) :: sincos
  end subroutine
end interface

interface
  function sleef_expf(input) bind(c, name='xexpf')
    use, intrinsic :: ISO_C_BINDING
    implicit none
    real(kind=c_float), value :: input
    real(kind=c_float) :: sleef_expf
  end function
end interface

end module