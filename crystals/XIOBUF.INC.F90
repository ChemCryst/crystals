! module version on the INC file with common blocks
! The common blocks are kept inside the module untile all the common blocks
! are converted to modules
! This file must be kept in sync with the corresponding INC file

!> module version of XIOBUF INC file
module xiobuf_mod

!----- THE MONITOR FILE BUFFERS
      CHARACTER(len=132) ::   CIOBUF
      CHARACTER(len=2)   ::   CCRCHR, MACDUM
      COMMON /XIOBUF/         CIOBUF, CCRCHR, MACDUM
!----- THE VDU AND ERROR MONITOR BUFFERS
      INTEGER, PARAMETER ::   LINBUF=24
      CHARACTER(len=256) ::   CCVDU(LINBUF), CCEROR(LINBUF)
      CHARACTER(len=256) ::   CMON(LINBUF)
      COMMON /XCIOBF/ CCVDU, CCEROR, CMON
      INTEGER LVDU, MVDU, LEROR, MEROR
      COMMON /XIIOBF/ LVDU, MVDU, LEROR, MEROR

end module
