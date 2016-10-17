!> F90 wrapper around sginfo library
!! See http://cci.lbl.gov/sginfo/sginfo_reference.html for more details
module sginfo_mod
use sginfo_type_mod
use, intrinsic :: iso_c_binding

!> void InitSgInfo(T_SgInfo *SgInfo);
interface
    subroutine InitSgInfo(SgInfo) bind(c, name="InitSgInfo")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
    end subroutine
end interface

!> int Add2ListSeitzMx(T_SgInfo *SgInfo, const T_RTMx *NewSMx);
interface
    function Add2ListSeitzMx(SgInfo, NewSMx) bind(c, name="Add2ListSeitzMx")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        type(T_RTMx) :: NewSMx
        integer(c_int) :: Add2ListSeitzMx
    end function
end interface

!> int MemoryInit(T_SgInfo *SgInfo) 
interface
    function MemoryInit(SgInfo) bind(c, name="MemoryInit")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        integer(c_int) :: MemoryInit
    end function
end interface

!> int CompleteSgInfo(T_SgInfo *SgInfo)
interface
    function CompleteSgInfo(SgInfo) bind(c, name="CompleteSgInfo")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        integer(c_int) :: CompleteSgInfo
    end function
end interface

!> int AddInversion2ListSeitzMx(T_SgInfo *SgInfo)
interface
    function AddInversion2ListSeitzMx(SgInfo) bind(c, name="AddInversion2ListSeitzMx")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        integer(c_int) :: AddInversion2ListSeitzMx
    end function
end interface

!> void PrintTabSgNameEntry(const T_TabSgName *tsgn, int Style, int space, FILE *fpout)
interface
    subroutine PrintTabSgNameEntry(tsgn, style, space, fpout) bind(c, name="PrintTabSgNameEntry")
    use sginfo_type_mod
    implicit none
        type(c_ptr) :: tsgn
        type(c_ptr), value :: fpout
        integer(c_int), value :: style, space
    end subroutine
end interface

!> const char *RTMx2XYZ(const T_RTMx *RTMx, int FacRo, int FacTr,
!!                     int Decimal, int TrFirst, int Low,
!!                     const char *Seperator,
!!                     char *BufferXYZ, int SizeBufferXYZ)
interface
    function cRTMx2XYZ(RTMx, FacRo, FacTr, DecimalTr, TrFirst, Low, Separator, &
    &   BufferXYZ, SizeBufferXYZ) bind(c, name="RTMx2XYZ")
    use sginfo_type_mod
    implicit none
        type(T_RTMx) :: RTMx
        integer(c_int), value :: Facro, FacTr, DecimalTr, TrFirst, Low
        character(kind=c_char), dimension(*) :: Separator
        character(kind=C_char), dimension(*) :: BufferXYZ
        integer(c_int), value :: SizeBufferXYZ
        type(c_ptr) :: cRTMx2XYZ
    end function
end interface        

!> int ParseSymXYZ(const char *SymXYZ, T_RTMx *SeitzMx, int FacTr)
interface
    function ParseSymXYZ(SymXYZ, SeitzMx, FacTr) bind(c, name="ParseSymXYZ")
    use sginfo_type_mod
    implicit none
        character(kind=C_char), dimension(*) :: SymXYZ
        type(T_RTMx) :: SeitzMx
        integer(C_int), value :: FacTr
        integer(C_int) :: ParseSymXYZ
    end function
end interface

!> int AddLatticeTr2ListSeitzMx(T_SgInfo *SgInfo,
!!                             const T_LatticeInfo *LatticeInfo);
interface
    function AddLatticeTr2ListSeitzMx(SgInfo, LatticeInfo) bind(c, name="AddLatticeTr2ListSeitzMx")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        type(T_LatticeInfo) :: LatticeInfo
        integer(C_int) :: AddLatticeTr2ListSeitzMx
    end function
end interface

!> int AddLatticeCode(T_SgInfo *SgInfo, char code)
interface
    function AddLatticeCode(SgInfo, code) bind(c, name="AddLatticeCode")
    use sginfo_type_mod
    implicit none
        type(T_sginfo) :: SgInfo
        character(kind=c_char) :: code
        integer(C_int) :: AddLatticeCode
    end function
end interface

contains

!> Copy a C string, passed by pointer, to a Fortran string.
! Copy a C string, passed by pointer, to a Fortran string.
! If the C pointer is NULL, the Fortran string is blanked.
! C_string must be NUL terminated, or at least as long as F_string.
! If C_string is longer, it is truncated. Otherwise, F_string is
! blank-padded at the end.
! http://fortranwiki.org/fortran/show/c_interface_module
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

!> Intermediary function to C function RTMx2XYZ from sginfo
function RTMx2XYZ(RTMx, FacRo, FacTr, DecimalTr, TrFirst, Low, Separator)
use sginfo_type_mod
implicit none
    type(T_RTMx) :: RTMx !< Symmetry operator
    integer(c_int), value :: Facro !< constant sginfo_crbf
    integer(c_int), value :: FacTr !< constant sginfo_stbf
    integer(c_int), value :: DecimalTr !< ouput as decimal (1) or fractions (0)
    integer(c_int), value :: TrFirst !< translation first (1) ie: x,1/2+y,-z
    integer(c_int), value :: Low !< lower case (1)
    character(len=*) :: Separator !< separator between groups ', ' ie: x, y, z
    character(kind=c_char), dimension(len(Separator)+1) :: cSeparator !< separator is C format
    type(c_ptr) :: RTMx2XYZ !< C pointer to resulting string
    integer i

    !type(c_ptr) :: BufferXYZ=C_NULL_PTR
    character(kind=C_char), dimension(128) :: BufferXYZ
    integer(c_int) :: SizeBufferXYZ=125
    
    do i=1, len(Separator)
        cSeparator(i)=Separator(i:i)
    end do
    cSeparator(size(cSeparator))=C_NULL_CHAR
    BufferXYZ=''
    BufferXYZ(128)=C_NULL_CHAR

    RTMx2XYZ=cRTMx2XYZ(RTMx, FacRo, FacTr, DecimalTr, TrFirst, Low, cSeparator, &
    &   BufferXYZ, SizeBufferXYZ)

end function
    
end module
