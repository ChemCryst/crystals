module xworkb_mod

integer ji,jn,jo,jp,jq,jr,nd,ne,nf,ni,nl,nm,nn,nr,nt,nu,nv
common/xworkb/ji,jn,jo,jp,jq,jr,nd,ne,nf,ni,nl,nm,nn,nr,nt,nu,nv

!integer, dimension(17) :: iworka
!equivalence (iworka(1),ji)
contains

subroutine xworkb_zeros
implicit none
ji=0
jn=0
jo=0
jp=0
jq=0
jr=0
nd=0
ne=0
nf=0
ni=0
nl=0
nm=0
nn=0
nr=0
nt=0
nu=0
nv=0
end subroutine

end module
