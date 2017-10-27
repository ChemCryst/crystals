module store_mod

integer NFL,LFL,NUL 
!C----- DONT FORGET TO SET ISIZST IN PRESETS
real, dimension(16777216) :: STORE

common/XDATC/NFL,LFL,NUL 
common/XDATA/STORE

end module

