program test
use sginfo_type_mod
use sginfo_mod
implicit none
integer error, i
character(len=1024) :: regular_string

type(T_sginfo) :: sginfo
type(T_RTMx) :: NewSMx
type(T_LatticeInfo) :: LatticeInfo
type(T_TabSgName), pointer :: TabSgName
type(T_LatticeInfo), pointer :: LatticeInfoPtr
type(c_ptr) :: fpout
character(len=1024) :: buffer
type(T_RTMx), dimension(:), pointer :: lsmx
type(c_ptr) :: xyzptr
integer(c_int), dimension(:), pointer :: tr

call InitSgInfo(SgInfo)
error=MemoryInit(SgInfo)
print *, 'MemoryInit ', error

print *, 'x, y+1/2, z+1/2'

!call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo, (/1/) )
!print *, LatticeInfo%Code
!error=AddLatticeCode(SgInfo, 'A') 

NewSMx%R=0
NewSMx%T=0
NewSMx%R(1)=-1
NewSMx%R(5)=-1
NewSMx%R(9)=1
NewSMx%T(1)=0
NewSMx%T(3)=0

error=Add2ListSeitzMx(SgInfo, NewSMx)
print *, 'Add2ListSeitzMx ', error

NewSMx%R=0
NewSMx%T=0
NewSMx%R(1)=1
NewSMx%R(5)=1
NewSMx%R(9)=1
NewSMx%T(1)=6
NewSMx%T(3)=6

error=Add2ListSeitzMx(SgInfo, NewSMx)
print *, 'Add2ListSeitzMx ', error

!LatticeInfo%Code=latt
!print *, LatticeInfo%Code
!error=AddLatticeTr2ListSeitzMx(SgInfo, LatticeInfo)
!print *, 'AddLatticeTr2ListSeitzMx ', error
!error=AddLatticeCode(SgInfo, 'B')

error=CompleteSgInfo(SgInfo)
print *, 'CompleteSgInfo ', error

call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfoPtr )
print *, LatticeInfoPtr%Code
print *, LatticeInfoPtr%nTrVector
call C_F_POINTER(LatticeInfoPtr%TrVector, tr, (/ LatticeInfoPtr%nTrVector*3 /) )
print *, tr

    if(C_associated(SgInfo%ListSeitzMx)) then
        call C_F_POINTER(SgInfo%ListSeitzMx, lsmx, (/ SgInfo%nlist /) )
        do i=1, SgInfo%nlist
            xyzptr=RTMx2XYZ(lsmx(i), 1, nint(sginfo_stbf), 0, 1, 0, ", ")
            call C_F_string_ptr(xyzptr, buffer)
            write(*, '(a, a)') 'SYMM ', trim(buffer)        
        end do
    else
        print *, 'Error: No summetry operators in SgInfo%ListSeitzMx'
        call abort()
    end if


print *, 'Hall Symbol ', SgInfo%HallSymbol
!call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)

print *, 'Lattice code ', LatticeInfo%Code

print *, 'Crystal system ', XS_name(SgInfo%XtalSystem)

print *, ""
print *, ""
print *, ""

call InitSgInfo(SgInfo)

print *, '-x, y+1/2, -z+1/2'

NewSMx%R=0
NewSMx%T=0
NewSMx%R(1)=-1
NewSMx%R(5)=1
NewSMx%R(9)=-1
NewSMx%T(1)=-6!nint(-0.5*12)
NewSMx%T(2)=6
NewSMx%T(3)=6

error=Add2ListSeitzMx(SgInfo, NewSMx)
print *, 'Add2ListSeitzMx ', error

error=AddInversion2ListSeitzMx(SgInfo)
print *, 'AddInversion2ListSeitzMx ', error

error=CompleteSgInfo(SgInfo)
print *, 'CompleteSgInfo ', error

print *, 'Hall Symbol ', SgInfo%HallSymbol
!   call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)

print *, 'Lattice code ', LatticeInfo%Code

print *, 'Crystal system ', XS_name(SgInfo%XtalSystem)

print *, 'assoc ', C_associated(SgInfo%TabSgName)
call C_F_POINTER(SgInfo%TabSgName, TabSgName)

call C_F_string_ptr(TabSgName%HallSymbol, regular_string)
print *, 'HallSymbol ', trim(regular_string)
call C_F_string_ptr(TabSgName%SgLabels, regular_string)
print *, 'SgLabels ', trim(regular_string)
call C_F_string_ptr(TabSgName%Extension, regular_string)
print *, 'Extension ', trim(regular_string)

!call PrintTabSgNameEntry(SgInfo%TabSgName, 0, 0, fpout)


end program

