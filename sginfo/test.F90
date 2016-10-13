program test
use sginfo_type_mod
use sginfo_mod
implicit none
integer error, i
character(len=1024) :: regular_string

type(T_sginfo) :: sginfo
type(T_RTMx) :: NewSMx
type(T_LatticeInfo), pointer :: LatticeInfo
type(T_TabSgName), pointer :: TabSgName
type(c_ptr) :: fpout

call InitSgInfo(SgInfo)
error=MemoryInit(SgInfo)
print *, 'MemoryInit ', error

print *, 'x, y+1/2, z+1/2'

NewSMx%R=0
NewSMx%T=0
NewSMx%R(1)=1
NewSMx%R(5)=1
NewSMx%R(9)=1
NewSMx%T(2)=nint(0.5*12)
NewSMx%T(3)=nint(0.5*12)

error=Add2ListSeitzMx(SgInfo, NewSMx)
print *, 'Add2ListSeitzMx ', error

error=CompleteSgInfo(SgInfo)
print *, 'CompleteSgInfo ', error

print *, 'Hall Symbol ', SgInfo%HallSymbol
call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)

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
call C_F_POINTER(SgInfo%LatticeInfo, LatticeInfo)

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

