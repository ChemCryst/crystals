module fwrappergui_mod

#if defined(CRY_FORTDIGITAL)
interface
  subroutine fastline (jx1, jy1, jx2, jy2)
    !dec$ attributes c :: fastline
    !dec$ attributes value :: jx1
    !dec$ attributes value :: jy1
    !dec$ attributes value :: jx2
    !dec$ attributes value :: jy2
    integer jx1, jy1, jx2, jy2
  end subroutine fastline
end interface

interface
  subroutine fastfelli (jx, jy, jw, jh)
    !dec$ attributes c :: fastfelli
    !dec$ attributes value :: jx
    !dec$ attributes value :: jy
    !dec$ attributes value :: jw
    !dec$ attributes value :: jh
    integer jx, jy, jw, jh
  end subroutine fastfelli
end interface

interface
  subroutine fasteelli (jx, jy, jw, jh)
    !dec$ attributes c :: fasteelli
    !dec$ attributes value :: jx
    !dec$ attributes value :: jy
    !dec$ attributes value :: jw
    !dec$ attributes value :: jh
    integer jx, jy, jw, jh
  end subroutine fasteelli
end interface

interface
  subroutine fastfpoly (nv, ipts)
    !dec$ attributes c :: fastfpoly
    !dec$ attributes value :: nv
    !dec$ attributes reference :: ipts
    integer nv, ipts(2000)
  end subroutine fastfpoly
end interface

interface
  subroutine fastepoly (nv, ipts)
    !dec$ attributes c :: fastepoly
    !dec$ attributes value :: nv
    !dec$ attributes reference :: ipts
    integer nv, ipts(2000)
  end subroutine fastepoly
end interface

interface
  subroutine fasttext (jx, jy, caline, jfs)
    !dec$ attributes c :: fasttext
    !dec$ attributes value :: jx
    !dec$ attributes value :: jy
    !dec$ attributes value :: jfs
    !dec$ attributes reference :: caline
    integer jx,jy, jfs
    character caline
  end subroutine fasttext
end interface

interface
  subroutine fastcolour ( jr, jg, jb )
    !dec$ attributes c :: fastcolour
    !dec$ attributes value :: jr
    !dec$ attributes value :: jg
    !dec$ attributes value :: jb
    integer jr, jg, jb
    end subroutine fastcolour
end interface

interface
  subroutine fastclear () 
    !dec$ attributes c :: fastclear
  end subroutine fastclear
end interface



interface
  subroutine guexec (caline)
    !dec$ attributes c :: guexec
    character*(*) caline
    !dec$ attributes reference :: caline
  end subroutine guexec
end interface

interface
  subroutine callccode (caline)
    !dec$ attributes c :: callccode
    character*(*) caline
    !dec$ attributes reference :: caline
  end subroutine callccode
end interface

interface
  subroutine cinextcommand (istat, caline)
    !dec$ attributes c :: cinextcommand
    integer istat
    character*256 caline
    !dec$ attributes reference :: caline
  end subroutine cinextcommand
end interface

interface
  subroutine ciendthread (ivar)
    !dec$ attributes c :: ciendthread
    integer ivar
  end subroutine ciendthread
end interface


interface
  subroutine fastbond (jx1, jy1, jz1, jx2, jy2, jz2, &
  & jr,jg,jb,jrad,jbt,jnp,kpts,dlabl,dslabl)
    !dec$ attributes c :: fastbond
    !dec$ attributes value :: jx1
    !dec$ attributes value :: jy1
    !dec$ attributes value :: jz1
    !dec$ attributes value :: jx2
    !dec$ attributes value :: jy2
    !dec$ attributes value :: jz2
    !dec$ attributes value :: jr
    !dec$ attributes value :: jg
    !dec$ attributes value :: jb
    !dec$ attributes value :: jrad
    !dec$ attributes value :: jbt
    !dec$ attributes value :: jnp
    !dec$ attributes reference :: kpts
    !dec$ attributes reference :: dlabl
    !dec$ attributes reference :: dslabl
    integer jx1, jy1, jz1, jx2, jy2, jz2
    integer jr, jg, jb, jrad, jbt, jnp, kpts(*)
    character dlabl, dslabl
  end subroutine fastbond
end interface

interface
  subroutine fastatom (de,js,dl,jx,jy,jz,jr,jg,jb,joc,sco, &
  &  jvd,jsp,jfl,su1,su2,su3,su4,su5,su6,su7,su8,su9, &
  &  sfx,sfy,sfz,jff,jfa,jfg,sue,sus )
    !dec$ attributes c :: fastatom
    !dec$ attributes value :: js
    !dec$ attributes value :: jx
    !dec$ attributes value :: jy
    !dec$ attributes value :: jz
    !dec$ attributes value :: jr
    !dec$ attributes value :: jg
    !dec$ attributes value :: jb
    !dec$ attributes value :: joc
    !dec$ attributes value :: sco
    !dec$ attributes value :: jvd
    !dec$ attributes value :: jsp
    !dec$ attributes value :: jfl
    !dec$ attributes value :: su1
    !dec$ attributes value :: su2
    !dec$ attributes value :: su3
    !dec$ attributes value :: su4
    !dec$ attributes value :: su5
    !dec$ attributes value :: su6
    !dec$ attributes value :: su7
    !dec$ attributes value :: su8
    !dec$ attributes value :: su9
    !dec$ attributes value :: sfx
    !dec$ attributes value :: sfy
    !dec$ attributes value :: sfz
    !dec$ attributes value :: sue
    !dec$ attributes value :: sus
    !dec$ attributes value :: jfa
    !dec$ attributes value :: jfg
    !dec$ attributes value :: jff
    !dec$ attributes reference :: dl
    !dec$ attributes reference :: de
    integer jx,jy,jz,jr,jg,jb,joc,jvd
    integer jsp,jfl, jff,jfa,jfg,js
    real sco,su1,su2,su3,su4,su5,su6,su7,su8,su9,sfx,sfy,sfz
    real sue,sus
    character dl,de
  end subroutine fastatom
end interface

interface
  subroutine fastsphere (dl,jx,jy,jz,jr,jg,jb,joc,jco,jvd, &
  &  jsp,jfl,jiso,jrad)
    !dec$ attributes c :: fastsphere
    !dec$ attributes value :: jx
    !dec$ attributes value :: jy
    !dec$ attributes value :: jz
    !dec$ attributes value :: jr
    !dec$ attributes value :: jg
    !dec$ attributes value :: jb
    !dec$ attributes value :: joc
    !dec$ attributes value :: jco
    !dec$ attributes value :: jvd
    !dec$ attributes value :: jsp
    !dec$ attributes value :: jfl
    !dec$ attributes value :: jiso
    !dec$ attributes value :: jrad
    !dec$ attributes reference :: dl
    integer jx,jy,jz,jr,jg,jb,joc,jco,jvd
    integer jsp,jfl,jiso,jrad
    character dl
  end subroutine fastsphere
end interface

interface
  subroutine fastdonut (dl,jx,jy,jz,jr,jg,jb,joc,jco,jvd, &
  & jsp,jfl,jiso,jrad, jdec, jaz)
    !dec$ attributes c :: fastdonut
    !dec$ attributes value :: jx
    !dec$ attributes value :: jy
    !dec$ attributes value :: jz
    !dec$ attributes value :: jr
    !dec$ attributes value :: jg
    !dec$ attributes value :: jb
    !dec$ attributes value :: joc
    !dec$ attributes value :: jco
    !dec$ attributes value :: jvd
    !dec$ attributes value :: jsp
    !dec$ attributes value :: jfl
    !dec$ attributes value :: jiso
    !dec$ attributes value :: jrad
    !dec$ attributes value :: jdec
    !dec$ attributes value :: jaz
    !dec$ attributes reference :: dl
    integer jx,jy,jz,jr,jg,jb,joc,jco,jvd
    integer jsp,jfl,jiso,jrad, jdec, jaz
    character dl
  end subroutine fastdonut
end interface
#else

interface
  subroutine fastline(jx1, jy1, jx2, jy2) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value, intent(in) :: jx1, jy1, jx2, jy2
  end subroutine fastline
end interface

interface
  subroutine fastfelli (jx, jy, jw, jh) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value, intent(in) :: jx, jy, jw, jh
  end subroutine fastfelli
end interface

interface
  subroutine fasteelli (jx, jy, jw, jh) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value, intent(in) :: jx, jy, jw, jh
  end subroutine fasteelli
end interface

interface
  subroutine fastfpoly (nv, ipts) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value :: nv
    integer(kind=c_int), dimension(*) :: ipts
  end subroutine fastfpoly
end interface

interface
  subroutine fastepoly (nv, ipts) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value :: nv
    integer(kind=c_int), dimension(*) :: ipts
  end subroutine fastepoly
end interface

interface
  subroutine fasttext (jx, jy, caline, jfs) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value :: jx,jy, jfs
    character(kind=c_char) :: caline
  end subroutine fasttext
end interface

interface
  subroutine fastcolour ( jr, jg, jb ) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value :: jr, jg, jb
    end subroutine fastcolour
end interface

interface
  subroutine fastclear () bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
  end subroutine fastclear
end interface



interface
  subroutine guexec (caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    character caline
  end subroutine guexec
end interface

interface
  subroutine callccode (caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    character caline
  end subroutine callccode
end interface

interface
  subroutine cinextcommand (istat, caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: istat
    character caline
  end subroutine cinextcommand
end interface

interface
  subroutine ciendthread (ivar) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: ivar
  end subroutine ciendthread
end interface


interface
  subroutine fastbond (jx1, jy1, jz1, jx2, jy2, jz2, &
  & jr,jg,jb,jrad,jbt,jnp,kpts,dlabl,dslabl) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: jx1, jy1, jz1, jx2, jy2, jz2
    integer, value :: jr, jg, jb, jrad, jbt, jnp
    integer, dimension(*) :: kpts
    character dlabl, dslabl
  end subroutine fastbond
end interface

interface
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
end interface

interface
  subroutine fastsphere (dl,jx,jy,jz,jr,jg,jb,joc,jco,jvd, &
  &  jsp,jfl,jiso,jrad) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: jx,jy,jz,jr,jg,jb,joc,jco,jvd
    integer, value :: jsp,jfl,jiso,jrad
    character dl
  end subroutine fastsphere
end interface

interface
  subroutine fastdonut (dl,jx,jy,jz,jr,jg,jb,joc,jco,jvd, &
  & jsp,jfl,jiso,jrad, jdec, jaz) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: jx,jy,jz,jr,jg,jb,joc,jco,jvd
    integer, value :: jsp,jfl,jiso,jrad, jdec, jaz
    character dl
  end subroutine fastdonut
end interface
#endif

contains

#if defined(CRY_GUI)
subroutine fstlin(ix1, iy1, ix2, iy2)
    implicit none
    integer ix1, ix2, iy1, iy2

    call fastline(ix1, iy1, ix2, iy2)
end subroutine
      
subroutine fstfel(ix, iy, iw, ih)
    implicit none
    integer ix, iy, iw, ih

    call fastfelli(ix, iy, iw, ih)
end subroutine
    
subroutine fsteel(ix, iy, iw, ih)
    implicit none
    integer ix, iy, iw, ih

    call fasteelli(ix, iy, iw, ih)
end subroutine

subroutine fstfpo(nv, ipts)
    implicit none
    integer nv, ipts(:)

    call fastfpoly(nv, ipts)
end subroutine

subroutine fstepo(nv, ipts)
    implicit none
    integer nv
    integer, dimension(:) :: ipts

    call fastepoly(nv, ipts)
end subroutine

subroutine fstext(ix, iy, ctext, ifsize)
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
    implicit none
    integer ir, ig, ib

    call fastcolour(ir, ig, ib)
end subroutine

subroutine fstclr()
    implicit none

    call fastclear()
end subroutine

subroutine fstbnd(ix1,iy1,iz1,ix2,iy2,iz2,ir,ig,ib,irad, &
&   ibt,inp,lpts,illen,clabl,islen,cslabl)

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
&   rfx,rfy,rfz,iff,ifa,ifg,rue,rus)

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ivd
    integer isp,ifl, iff, ifa, ifg, is
    real ru1,ru2,ru3,ru4,ru5,ru6,ru7,ru8,ru9,rco,rfx,rfy,rfz
    real rue, rus
    character*(*) cl
    character ce*4, be*5
    character*(ll+1) bl

    bl = cl(1:ll)  // char(0)
    be = ce(1:4)  // char(0)

    call fastatom(be,is,bl,ix,iy,iz,ir,ig,ib,ioc,rco,ivd, &
    &   isp,ifl,ru1,ru2,ru3,ru4,ru5,ru6,ru7,ru8,ru9,rfx,rfy,rfz, &
    &   iff, ifa, ifg, rue, rus)
end subroutine

subroutine fstsph(ll,cl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
&   isp,ifl,iso,irad)

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

    integer ll,ix,iy,iz,ir,ig,ib,ioc,ico,ivd
    integer isp,ifl,iso,irad,idec,iaz
    character*(*) cl
    character*(ll+1) bl

    bl = cl(1:ll)  // char(0)

    call fastdonut(bl,ix,iy,iz,ir,ig,ib,ioc,ico,ivd, &
    &   isp,ifl,iso,irad, idec,iaz)
end subroutine
#endif

end module
