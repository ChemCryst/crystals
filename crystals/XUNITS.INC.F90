! module version on the INC file with common blocks
! The common blocks are kept inside the module untile all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XUNITS INC file
module xunits_mod
INTEGER NCRU,NCRRU,NCWU,NCPU,IPAGE(5),NCARU,NCAWU
INTEGER IQUN,JQUN,IERFLG ,IUSFLG,NCSU,NCEXTR,NCQUE,NCCBU
INTEGER NCFPU1, NCFPU2, NUCOM, NCVDU, NCEROR, NCADU, NCMU, NCCHW
INTEGER NCPDU, NCDBU, NCEXTR2

COMMON/XUNITS/NCRU,NCRRU,NCWU,NCPU,IPAGE,NCARU,NCAWU, &
    IQUN,JQUN,IERFLG ,IUSFLG,NCSU,NCEXTR,NCQUE,NCCBU, &
    NCFPU1, NCFPU2, NUCOM, NCVDU, NCEROR, NCADU, NCMU, NCCHW, &
    NCPDU, NCDBU, NCEXTR2
end module
