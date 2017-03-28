!fwrapper pass through functions for the GUI version
!! subroutines below are wrappers around the c functions call


subroutine fwexec(cc)
    implicit none
    character*(*) cc

end subroutine

subroutine fcallc(cc)
    implicit none
    character*(*) cc

end subroutine


subroutine fstlin(ix1, iy1, ix2, iy2)
    implicit none
    integer ix1, ix2, iy1, iy2

end subroutine
      
subroutine fstfel(ix, iy, iw, ih)
    implicit none
    integer ix, iy, iw, ih

end subroutine
    
subroutine fsteel(ix, iy, iw, ih)
    implicit none
    integer ix, iy, iw, ih

end subroutine

subroutine fstfpo(nv, ipts)
    implicit none
    integer nv, ipts(:)

end subroutine

subroutine fstepo(nv, ipts)
    implicit none
    integer nv
    integer, dimension(:) :: ipts

end subroutine

subroutine fstext(ix, iy, ctext, ifsize)
    implicit none
    integer n, ix, iy, ifsize
    character*(*) ctext
    character*80  ntext

end subroutine

subroutine fstcol(ir, ig, ib)
    implicit none
    integer ir, ig, ib

end subroutine

subroutine fstclr()
    implicit none

end subroutine

subroutine fstbnd(ix1,iy1,iz1,ix2,iy2,iz2,ir,ig,ib,irad, &
&   ibt,inp,lpts,illen,clabl,islen,cslabl)

    integer ix1, ix2, iz1, iy1, iy2, iz2
    integer ir,ig,ib,irad,ibt,inp,lpts(*),illen
    character*(*) clabl
    character*(*) cslabl

    character*(illen+1) blabl
    character*(islen+1) bslabl

end subroutine



subroutine fstatm(ce,is,ll,cl,ix,iy,iz,ir,ig,ib,ioc,rco, &
&   ivd,isp,ifl,ru1,ru2,ru3,ru4,ru5,ru6,ru7,ru8,ru9, &
&   rfx,rfy,rfz,iff,ifa,ifg,rue,rus)

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ivd
    integer isp,ifl, iff, ifa, ifg, is
    real ru1,ru2,ru3,ru4,ru5,ru6,ru7,ru8,ru9,rco,rfx,rfy,rfz
    real rue, rus
    character*(*) cl
    character ce*4, be*5
    character*(ll+1) bl
end subroutine

subroutine fstsph(ll,cl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
&   isp,ifl,iso,irad)

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ico,ivd
    integer isp,ifl,iso,irad
    character*(*) cl
    character*(ll+1) bl

end subroutine

subroutine fstrng(ll,cl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
&   isp,ifl,iso,irad, idec, iaz)

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ico,ivd
    integer isp,ifl,iso,irad,idec,iaz
    character*(*) cl
    character*(ll+1) bl
end subroutine
