module tlistc_mod
      integer, parameter :: nlistc=36
      character(len=48), dimension(nlistc) :: clists
      common /xlistc/ clists
end module
