! module version on the INC file with common blocks
! The common blocks are kept inside the module untile all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XERVAL INC file
module xerval_mod

INTEGER IERNOP,IERSFL,IERWRN,IERERR,IERSEV,IERCAT
INTEGER IERPRG,IERABO,IERUNW
COMMON /XERVAL/IERNOP,IERSFL,IERWRN,IERERR,IERSEV,IERCAT,IERPRG,IERABO,IERUNW

end module
