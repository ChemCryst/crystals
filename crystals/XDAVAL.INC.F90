! module version on the INC file with common blocks
! The common blocks are kept inside the module untile all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XDAVAL INC file
module xdaval_mod
	integer IDAINI,IDATOT,IDAMAX,IDAMIN,IDAAUT,IDAQUA,IDATRY
	
    COMMON /XDAVAL/ IDAINI,IDATOT,IDAMAX,IDAMIN,IDAAUT,IDAQUA,IDATRY
end module

