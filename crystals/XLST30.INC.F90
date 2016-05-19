module xlst30_mod

integer l30dr,m30dr,md30dr,n30dr, l30cd,m30cd,md30cd,n30cd 
integer l30rf,m30rf,md30rf,n30rf, l30ix,m30ix,md30ix,n30ix
integer l30ab,m30ab,md30ab,n30ab, l30ge,m30ge,md30ge,n30ge
integer l30cl,m30cl,md30cl,n30cl, l30sh,m30sh,md30sh,n30sh
integer l30cf,m30cf,md30cf,n30cf

common/xlst30/ &
    l30dr,m30dr,md30dr,n30dr, l30cd,m30cd,md30cd,n30cd, & 
    l30rf,m30rf,md30rf,n30rf, l30ix,m30ix,md30ix,n30ix, &
    l30ab,m30ab,md30ab,n30ab, l30ge,m30ge,md30ge,n30ge, &
    l30cl,m30cl,md30cl,n30cl, l30sh,m30sh,md30sh,n30sh, &
    l30cf,m30cf,md30cf,n30cf

!--set the dimension of the common block for list 30
integer, parameter :: idim30 = 36
!integer, dimension(idim30) :: icom30 

!equivalence (l30dr,icom30(1)) 

end module
