module xlst33_mod

integer l33cd,m33cd,md33cd,n33cd,l33sv,m33sv,md33sv,n33sv
integer l33st,m33st,md33st,n33st,l33ib,m33ib,md33ib,n33ib
integer l33v,m33v,md33v,n33v,l33cb,m33cb,md33cb,n33cb
integer ityp33 

common/xlst33/l33cd,m33cd,md33cd,n33cd,l33sv,m33sv,md33sv,n33sv, &
    l33st,m33st,md33st,n33st,l33ib,m33ib,md33ib,n33ib, &
    l33v,m33v,md33v,n33v,l33cb,m33cb,md33cb,n33cb,ityp33 

integer, parameter :: idim33=25

!integer, dimension(25) :: icom33
!equivalence (icom33(1),l33cd) 

end module
