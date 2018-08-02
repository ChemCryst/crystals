!> Write extra information which cannot be used directly in crystals
module extras_mod
private
public extras, extras_t

type extras_t
    private
    integer funit
contains
    procedure write, close, open
end type

contains

!> Constructor
function extras(filepath)
implicit none
type(extras_t) :: extras
character(len=*), intent(in) :: filepath

    call extras%open(filepath)

end function

!> Open file
subroutine open(self, filepath)
implicit none
class(extras_t) :: self
character(len=*), intent(in) :: filepath

    self%funit=145
    open(self%funit, file=filepath)

end subroutine

!> Write to the file
subroutine write(self, text)
implicit none
class(extras_t) :: self
character(len=*), intent(in) :: text

    write(self%funit, '(A)') text

end subroutine

!> Close file
subroutine close(self)
implicit none
class(extras_t) :: self

    close(self%funit)

end subroutine

end module
