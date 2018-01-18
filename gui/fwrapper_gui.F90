! The module frwrapper_gui contains subroutine calling C functions
module fwrappergui_mod

#if defined(CRY_FORTDIGITAL)
!> interface to C function fastline (digital compiler)
!! Draw a line in cameron component
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

!> interface to C function fastfelli (digital compiler)
!! Draw an ellipse in cameron component
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

!> interface to C function fastfeelli (digital compiler)
!! Draw an ellipse in cameron component
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

!> interface to C function fastfpoly (digital compiler)
!! Draw a polygon in cameron component
interface
  subroutine fastfpoly (nv, ipts)
    !dec$ attributes c :: fastfpoly
    !dec$ attributes value :: nv
    !dec$ attributes reference :: ipts
    integer nv, ipts(2000)
  end subroutine fastfpoly
end interface

!> interface to C function fastepoly (digital compiler)
!! Draw a polygon in cameron component
interface
  subroutine fastepoly (nv, ipts)
    !dec$ attributes c :: fastepoly
    !dec$ attributes value :: nv
    !dec$ attributes reference :: ipts
    integer nv, ipts(2000)
  end subroutine fastepoly
end interface

!> interface to C function fasttext (digital compiler)
!! Draw a text in cameron component
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

!> interface to C function fastcolour (digital compiler)
!! Set a color (RGB) in cameron component
interface
  subroutine fastcolour ( jr, jg, jb )
    !dec$ attributes c :: fastcolour
    !dec$ attributes value :: jr
    !dec$ attributes value :: jg
    !dec$ attributes value :: jb
    integer jr, jg, jb
    end subroutine fastcolour
end interface

!> interface to C function fastclear (digital compiler)
!! Clear screen in cameron component
interface
  subroutine fastclear () 
    !dec$ attributes c :: fastclear
  end subroutine fastclear
end interface



!> interface to C function guexec (digital compiler)
!! Unkwown function
interface
   integer function guexec (caline)
    !dec$ attributes c :: guexec
    character*(*) caline
    !dec$ attributes reference :: caline
  end function guexec
end interface

!> interface to C function callccode (digital compiler)
!! Unkwown function
interface
  subroutine callccode (caline)
    !dec$ attributes c :: callccode
    character*(*) caline
    !dec$ attributes reference :: caline
  end subroutine callccode
end interface

!> interface to C function cinextcommand (digital compiler)
!! Unkwown function
interface
  subroutine cinextcommand (istat, caline)
    !dec$ attributes c :: cinextcommand
    integer istat
    character*256 caline
    !dec$ attributes reference :: caline
  end subroutine cinextcommand
end interface

!> interface to C function ciendthread (digital compiler)
!! Unkwown function
interface
  subroutine ciendthread (ivar)
    !dec$ attributes c :: ciendthread
    integer ivar
  end subroutine ciendthread
end interface


!> interface to C function fastbond (digital compiler)
!! Unkwown function call from guibits.F
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

!> interface to C function fastatom (digital compiler)
!! Unkwown function call from guibits.F
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

!> interface to C function fastsphere (digital compiler)
!! Unkwown function call from guibits.F
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

!> interface to C function fastdonut (digital compiler)
!! Unkwown function call from guibits.F
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
!> interface to C function fastline (iso_c_bindings)
!! Draw a line in cameron component
  subroutine fastline(jx1, jy1, jx2, jy2) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> Coordinates of point A making the [AB] line
    integer(kind=c_int), value, intent(in) :: jx1, jy1
    !> Coordinates of point B making the [AB] line
    integer(kind=c_int), value, intent(in) :: jx2, jy2
  end subroutine fastline
end interface


interface
!> interface to C function fastfelli (iso_c_bindings)
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
end interface


interface
!> interface to C function fastfeelli (iso_c_bindings)
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
end interface


interface
!> interface to C function fastfpoly (iso_c_bindings)
!! Draw a polygon in cameron component
  subroutine fastfpoly (nv, ipts) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> number of points in the polygon
    integer(kind=c_int), value :: nv
    !> Array of point coordinates forming a polygon (size 2*nv)
    integer(kind=c_int), dimension(*) :: ipts
  end subroutine fastfpoly
end interface


interface
!> interface to C function fastepoly (iso_c_bindings)
!! Draw a polygon in cameron component
  subroutine fastepoly (nv, ipts) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> number of points in the polygon
    integer(kind=c_int), value :: nv
    !> Array of point coordinates forming a polygon (size 2*nv)
    integer(kind=c_int), dimension(*) :: ipts
  end subroutine fastepoly
end interface


interface
!> interface to C function fasttext (iso_c_bindings)
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
end interface


interface
!> interface to C function fastcolour (iso_c_bindings)
!! Set a color (RGB) in cameron component
  subroutine fastcolour ( jr, jg, jb ) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    !> color coded af RGB components
    integer(kind=c_int), value :: jr, jg, jb
    end subroutine fastcolour
end interface

interface
!> interface to C function fastclear (iso_c_bindings)
!! Clear screen in cameron component
  subroutine fastclear () bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
  end subroutine fastclear
end interface




interface
!> interface to C function guexec (iso_c_bindings)
!! Unkwown function
  integer function guexec (caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    character caline
  end function guexec
end interface


interface
!> interface to C function callccode (iso_c_bindings)
!! Unkwown function
  subroutine callccode (caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    character caline
  end subroutine callccode
end interface


interface
!> interface to C function cinextcommand (iso_c_bindings)
!! Unkwown function
  subroutine cinextcommand (istat, caline) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: istat
    character caline
  end subroutine cinextcommand
end interface


interface
!> interface to C function ciendthread (iso_c_bindings)
!! Unkwown function
  subroutine ciendthread (ivar) bind(c)
    use, intrinsic :: ISO_C_BINDING
    implicit none
    integer, value :: ivar
  end subroutine ciendthread
end interface



interface
!> interface to C function fastbond (iso_c_bindings)
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
end interface


interface
!> interface to C function fastatom (iso_c_bindings)
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
end interface


interface
!> interface to C function fastsphere (iso_c_bindings)
!! Unkwown function call from guibits.F
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
!> interface to C function fastdonut (iso_c_bindings)
!! Unkwown function call from guibits.F
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


end module
