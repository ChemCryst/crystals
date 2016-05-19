! module version on the INC file with common blocks
! The common blocks are kept inside the module untile all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XLST39 INC file
module xlst39_mod

    integer L39I,M39I,MD39I,N39I
    integer L39F,M39F,MD39F,N39F
    integer L39O,M39O,MD39O,N39O 
    common /XLST39/  L39I,M39I,MD39I,N39I, &
    &   L39F,M39F,MD39F,N39F, &
    &   L39O,M39O,MD39O,N39O 

end module
