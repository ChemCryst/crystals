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
    integer(kind=c_int), dimension(2000) :: ipts
  end subroutine fastfpoly
end interface

interface
  subroutine fastepoly (nv, ipts) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer(kind=c_int), value :: nv
    integer(kind=c_int), dimension(2000) :: ipts
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
#endif

contains

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
    integer nv, ipts(2000)

    call fastfpoly(nv, ipts)
end subroutine

subroutine fstepo(nv, ipts)
    implicit none
    integer nv
    integer, dimension(2000) :: ipts

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

end module
