module store_mod

integer NFL,LFL,NUL 
!C----- DONT FORGET TO SET ISIZST IN PRESETS
real, dimension(16777216) :: STORE

common/XDATC/NFL,LFL,NUL 
common/XDATA/STORE

contains

!> Get item at address k in store as integer
elemental integer function i_store(k)  
implicit none
integer, intent(in) :: k !< address in store

i_store = transfer(STORE(k), 1)

end function


end module

