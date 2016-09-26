subroutine guexit(ivar)
end subroutine

subroutine getvar(ivar)
end subroutine

subroutine getcom(ivar)
end subroutine

! The module frwrapper_gui contains subroutine calling C functions
module fwrappergui_mod

contains

!>  to C function fastline (iso_c_bindings)
!! Draw a line in cameron component
  subroutine fastline(jx1, jy1, jx2, jy2) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> Coordinates of point A making the [AB] line
    integer(kind=c_int), value, intent(in) :: jx1, jy1
    !> Coordinates of point B making the [AB] line
    integer(kind=c_int), value, intent(in) :: jx2, jy2
  end subroutine fastline


!>  to C function fastfelli (iso_c_bindings)
!! Draw an ellipse in cameron component
  subroutine fastfelli (jx, jy, jw, jh) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> coordinates of the centre forming the ellipse
    integer(kind=c_int), value, intent(in) :: jx, jy
    !> width of the ellipse
    integer(kind=c_int), value, intent(in) :: jw
    !> height of the ellipse
    integer(kind=c_int), value, intent(in) :: jh
  end subroutine fastfelli


!>  to C function fastfeelli (iso_c_bindings)
!! Draw an ellipse in cameron component
  subroutine fasteelli (jx, jy, jw, jh) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> coordinates of the centre forming the ellipse
    integer(kind=c_int), value, intent(in) :: jx, jy
    !> width of the ellipse
    integer(kind=c_int), value, intent(in) :: jw
    !> height of the ellipse
    integer(kind=c_int), value, intent(in) :: jh
  end subroutine fasteelli


!>  to C function fastfpoly (iso_c_bindings)
!! Draw a polygon in cameron component
  subroutine fastfpoly (nv, ipts) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> number of points in the polygon
    integer(kind=c_int), value :: nv
    !> Array of point coordinates forming a polygon (size 2*nv)
    integer(kind=c_int), dimension(*) :: ipts
  end subroutine fastfpoly


!>  to C function fastepoly (iso_c_bindings)
!! Draw a polygon in cameron component
  subroutine fastepoly (nv, ipts) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> number of points in the polygon
    integer(kind=c_int), value :: nv
    !> Array of point coordinates forming a polygon (size 2*nv)
    integer(kind=c_int), dimension(*) :: ipts
  end subroutine fastepoly



!>  to C function fasttext (iso_c_bindings)
!! Draw a text in cameron component
  subroutine fasttext (jx, jy, caline, jfs) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> location of the text as coordinates
    integer(kind=c_int), value :: jx,jy
    !> font size
    integer(kind=c_int), value :: jfs
    !> Text to print
    character(kind=c_char) :: caline
  end subroutine fasttext




!>  to C function fastcolour (iso_c_bindings)
!! Set a color (RGB) in cameron component
  subroutine fastcolour ( jr, jg, jb ) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> color coded af RGB components
    integer(kind=c_int), value :: jr, jg, jb
    end subroutine fastcolour



!>  to C function fastclear (iso_c_bindings)
!! Clear screen in cameron component
  subroutine fastclear () bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
  end subroutine fastclear





!>  to C function guexec (iso_c_bindings)
!! Unkwown function
  subroutine guexec (caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    character caline
  end subroutine guexec


!>  to C function callccode (iso_c_bindings)
!! Unkwown function
  subroutine callccode (caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    character caline
  end subroutine callccode



!>  to C function cinextcommand (iso_c_bindings)
!! Unkwown function
  subroutine cinextcommand (istat, caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: istat
    character caline
  end subroutine cinextcommand




!>  to C function ciendthread (iso_c_bindings)
!! Unkwown function
  subroutine ciendthread (ivar) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: ivar
  end subroutine ciendthread





!>  to C function fastbond (iso_c_bindings)
!! Unkwown function call from guibits.F
  subroutine fastbond (jx1, jy1, jz1, jx2, jy2, jz2, &
  & jr,jg,jb,jrad,jbt,jnp,kpts,dlabl,dslabl) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> 3D atomic coordinates of atoms A
    integer, value :: jx1, jy1, jz1
    !> 3D atomic coordinates of atoms A
    integer, value :: jx2, jy2, jz2
    !> Colour coded as RGB components
    integer, value :: jr, jg, jb
    !> radius of the bond
    integer, value :: jrad
    integer, value ::  jbt, jnp
    integer, dimension(*) :: kpts
    character dlabl, dslabl
  end subroutine fastbond




!>  to C function fastatom (iso_c_bindings)
!! Unkwown function call from guibits.F
  subroutine fastatom (de,js,dl,jx,jy,jz,jr,jg,jb,joc,sco, &
  &  jvd,jsp,jfl,su1,su2,su3,su4,su5,su6,su7,su8,su9, &
  &  sfx,sfy,sfz,jff,jfa,jfg,sue,sus ) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: jx,jy,jz,jr,jg,jb,joc,jvd
    integer, value :: jsp,jfl, jff,jfa,jfg,js
    real, value :: sco,su1,su2,su3,su4,su5,su6,su7,su8,su9,sfx,sfy,sfz
    real, value :: sue,sus
    character dl,de
  end subroutine fastatom




!>  to C function fastsphere (iso_c_bindings)
!! Unkwown function call from guibits.F
  subroutine fastsphere (dl,jx,jy,jz,jr,jg,jb,joc,jco,jvd, &
  &  jsp,jfl,jiso,jrad) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: jx,jy,jz,jr,jg,jb,joc,jco,jvd
    integer, value :: jsp,jfl,jiso,jrad
    character dl
  end subroutine fastsphere




!>  to C function fastdonut (iso_c_bindings)
!! Unkwown function call from guibits.F
  subroutine fastdonut (dl,jx,jy,jz,jr,jg,jb,joc,jco,jvd, &
  & jsp,jfl,jiso,jrad, jdec, jaz) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: jx,jy,jz,jr,jg,jb,joc,jco,jvd
    integer, value :: jsp,jfl,jiso,jrad, jdec, jaz
    character dl
  end subroutine fastdonut



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

end module
