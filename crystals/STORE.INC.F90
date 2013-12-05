module store_mod
      integer, parameter :: storelength=16777216
      integer nfl,lfl,nul 
      common/xdatc/nfl,lfl,nul 
!----- dont forget to set isizst in presets
      real, dimension(storelength) :: store
      common/xdata/store

      integer, dimension(storelength) :: istore
      
      equivalence (store,istore) 
     

end module
