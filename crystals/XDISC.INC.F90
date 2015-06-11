! module version on the INC file with common blocks
! The common blocks are kept inside the module untile all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XDISC INC file
module xdisc_mod
    integer nu
    
    common/XDISC/NU 
end module

