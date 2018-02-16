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

!> Get item at address k in store as characters
elemental character(len=4) function c_store(k)  
implicit none
integer, intent(in) :: k !< address in store

c_store = transfer(STORE(k), 'aaaa')

end function

!> Set item at address k in store as integer
subroutine i_store_set(k, v)  
implicit none
integer, intent(in) :: k !< address in store
integer, intent(in) :: v !< value to transfer

STORE(k) = transfer(v, store(1))

end subroutine

end module

