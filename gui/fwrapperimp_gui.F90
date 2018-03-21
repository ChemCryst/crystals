!fwrapper pass through functions for the GUI version
!! subroutines below are wrappers around the c functions call

integer function fwexec(cc)
    use fwrappergui_mod, only: guexec
    implicit none
    character*(*) cc
    fwexec = guexec(cc)
    return 
end function


subroutine fcallc(cc)
    use fwrappergui_mod, only: callccode
    implicit none
    character*(*) cc

    call callccode(cc)
end subroutine


subroutine fstlin(ix1, iy1, ix2, iy2)
    use fwrappergui_mod, only: fastline
    implicit none
    integer ix1, ix2, iy1, iy2

    call fastline(ix1, iy1, ix2, iy2)
end subroutine
      
subroutine fstfel(ix, iy, iw, ih)
    use fwrappergui_mod, only: fastfelli
    implicit none
    integer ix, iy, iw, ih

    call fastfelli(ix, iy, iw, ih)
end subroutine
    
subroutine fsteel(ix, iy, iw, ih)
    use fwrappergui_mod, only: fasteelli
    implicit none
    integer ix, iy, iw, ih

    call fasteelli(ix, iy, iw, ih)
end subroutine

subroutine fstfpo(nv, ipts)
    use fwrappergui_mod, only: fastfpoly
    implicit none
    integer nv, ipts(nv*2)

    call fastfpoly(nv, ipts)
end subroutine

subroutine fstepo(nv, ipts)
    use fwrappergui_mod, only: fastepoly
    implicit none
    integer nv
    integer, dimension(nv*2) :: ipts

    call fastepoly(nv, ipts)
end subroutine

subroutine fstext(ix, iy, ctext, ifsize)
    use fwrappergui_mod, only: fasttext
    implicit none
    integer n, ix, iy, ifsize
    character*(*) ctext
    character*80  ntext

    n=len_trim(ntext)
    n = min(n,79)        ! set n to be no more than 79
    ntext = ctext
    ntext(n+1:n+1) = char(0)  ! make into a c string.

    call fasttext(ix, iy, ntext, ifsize )
end subroutine

subroutine fstcol(ir, ig, ib)
    use fwrappergui_mod, only: fastcolour
    implicit none
    integer ir, ig, ib

    call fastcolour(ir, ig, ib)
end subroutine

subroutine fstclr()
    use fwrappergui_mod, only: fastclear
    implicit none

    call fastclear()
end subroutine

subroutine fstbnd(ix1,iy1,iz1,ix2,iy2,iz2,ir,ig,ib,irad, &
&   ibt,inp,lpts,illen,clabl,islen,cslabl)
    use fwrappergui_mod, only: fastbond

    integer ix1, ix2, iz1, iy1, iy2, iz2
    integer ir,ig,ib,irad,ibt,inp,lpts(*),illen
    character*(*) clabl
    character*(*) cslabl

    character*(illen+1) blabl
    character*(islen+1) bslabl

    blabl = clabl(1:illen)  // char(0)
    bslabl= cslabl(1:islen) // char(0)

    call fastbond(ix1,iy1,iz1,ix2,iy2,iz2,ir,ig,ib,irad, &
    &   ibt,inp,lpts,blabl,bslabl)
end subroutine



subroutine fstatm(ce,is,ll,cl,ix,iy,iz,ir,ig,ib,ioc,rco, &
&   ivd,isp,ifl,ru1,ru2,ru3,ru4,ru5,ru6,ru7,ru8,ru9, &
&   rfx,rfy,rfz,iff,ifa,ifg,rue,rus,isflg)
    use fwrappergui_mod, only: fastatom

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ivd
    integer isp,ifl, iff, ifa, ifg, is, isflg
    real ru1,ru2,ru3,ru4,ru5,ru6,ru7,ru8,ru9,rco,rfx,rfy,rfz
    real rue, rus
    character*(*) cl
    character ce*4, be*5
    character*(ll+1) bl

    bl = cl(1:ll)  // char(0)
    be = ce(1:4)  // char(0)

    call fastatom(be,is,bl,ix,iy,iz,ir,ig,ib,ioc,rco,ivd, &
    &   isp,ifl,ru1,ru2,ru3,ru4,ru5,ru6,ru7,ru8,ru9,rfx,rfy,rfz, &
    &   iff, ifa, ifg, rue, rus, isflg)
end subroutine

subroutine fstsph(ll,cl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
&   isp,ifl,iso,irad)
    use fwrappergui_mod, only: fastsphere

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ico,ivd
    integer isp,ifl,iso,irad
    character*(*) cl
    character*(ll+1) bl

    bl = cl(1:ll)  // char(0)

    call fastsphere(bl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
    &   isp,ifl,iso,irad)
end subroutine

subroutine fstrng(ll,cl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
&   isp,ifl,iso,irad, idec, iaz)
    use fwrappergui_mod, only: fastdonut

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ico,ivd
    integer isp,ifl,iso,irad,idec,iaz
    character*(*) cl
    character*(ll+1) bl

    bl = cl(1:ll)  // char(0)

    call fastdonut(bl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
    &   isp,ifl,iso,irad, idec,iaz)
end subroutine
