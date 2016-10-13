module sginfo_mod
use sginfo_type_mod
use, intrinsic :: iso_c_binding

!void InitSgInfo(T_SgInfo *SgInfo);
interface
    subroutine InitSgInfo(SgInfo) bind(c, name="InitSgInfo")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
    end subroutine
end interface

!int Add2ListSeitzMx(T_SgInfo *SgInfo, const T_RTMx *NewSMx);
interface
    function Add2ListSeitzMx(SgInfo, NewSMx) bind(c, name="Add2ListSeitzMx")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        type(T_RTMx) :: NewSMx
        integer(c_int) :: Add2ListSeitzMx
    end function
end interface

!int MemoryInit(T_SgInfo *SgInfo) 
interface
    function MemoryInit(SgInfo) bind(c, name="MemoryInit")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        integer(c_int) :: MemoryInit
    end function
end interface

!int CompleteSgInfo(T_SgInfo *SgInfo)
interface
    function CompleteSgInfo(SgInfo) bind(c, name="CompleteSgInfo")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        integer(c_int) :: CompleteSgInfo
    end function
end interface

!int AddInversion2ListSeitzMx(T_SgInfo *SgInfo)
interface
    function AddInversion2ListSeitzMx(SgInfo) bind(c, name="AddInversion2ListSeitzMx")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        integer(c_int) :: AddInversion2ListSeitzMx
    end function
end interface

!void PrintTabSgNameEntry(const T_TabSgName *tsgn, int Style, int space, FILE *fpout)
interface
    subroutine PrintTabSgNameEntry(tsgn, style, space, fpout) bind(c, name="PrintTabSgNameEntry")
    use sginfo_type_mod
    implicit none
        type(c_ptr) :: tsgn
        type(c_ptr), value :: fpout
        integer(c_int), value :: style, space
    end subroutine
end interface

! const char *RTMx2XYZ(const T_RTMx *RTMx, int FacRo, int FacTr,
!                     int Decimal, int TrFirst, int Low,
!                     const char *Seperator,
!                     char *BufferXYZ, int SizeBufferXYZ)
!  lsmx = &SgInfo->ListSeitzMx[1]; /* skip first = identity matrix */
!
!  for (iList = 1; iList < SgInfo->nList; iList++, lsmx++)
!  {
!        xyz = RTMx2XYZ(lsmx, 1, STBF, 1, 1, 0, ", ", NULL, 0);
        
contains

! Copy a C string, passed by pointer, to a Fortran string.
! If the C pointer is NULL, the Fortran string is blanked.
! C_string must be NUL terminated, or at least as long as F_string.
! If C_string is longer, it is truncated. Otherwise, F_string is
! blank-padded at the end.
  subroutine C_F_string_ptr(C_string, F_string)
    type(C_ptr), intent(in) :: C_string
    character(len=*), intent(out) :: F_string
    character(len=1,kind=C_char), dimension(:), pointer :: p_chars
    integer :: i
    if (.not. C_associated(C_string)) then
      F_string = ' '
    else
      call C_F_pointer(C_string,p_chars,[huge(0)])
      i=1
      do while(p_chars(i)/=C_NULL_char .and. i<=len(F_string))
        F_string(i:i) = p_chars(i)
        i=i+1
      end do
      if (i<len(F_string)) F_string(i:) = ' '
    end if
  end subroutine C_F_string_ptr

end module
