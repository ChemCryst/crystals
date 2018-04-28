module xlink_mod
implicit none

! ---- SIZE = 128 + ISSBFS*ISSNBF FOR ISSNBF LE 24. DONT FORGET XSTATS NCACHE
      integer, parameter :: LINKDM = 12928
      integer, dimension(LINKDM) :: link
      
      COMMON/XBUFFD/LINK
      
end module

