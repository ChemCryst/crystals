module sfls_stack_mod

type hkl_indices_t
    integer :: h,k,l
    real pshift
end type

type stack_t
    real, dimension(:), allocatable :: derivatives ! +1:+2 size(n12)
    integer, dimension(3) :: hkl ! +3:+5
    real :: Fcalc ! +6
    real :: Phase ! +7
    integer :: element ! +8
    type(hkl_indices_t), dimension(:), allocatable :: hkl_sym ! +9:+10 size(n2t-1)
    real :: pshift ! +11
    real :: fried ! +12
    real :: acr ! +13
    real :: aci ! +14
    real :: bcr ! +15
    real :: bci ! +16
    real, dimension(:), allocatable :: derivatives_temp ! +18:+19 size(n12)
    integer :: batch ! +20 (store(m6+13))
    
end type
type(stack_t), dimension(:), allocatable :: stack
integer, dimension(:), allocatable :: stack_indices
type(stack_t) :: temp_stack
type(stack_t) :: one_stack

integer new_jref_stack_start

contains

subroutine print_stack(header)
use xsflsw_mod
use store_mod
use xlst02_mod
implicit none
character(len=*), intent(in), optional :: header
integer i, j, cpt

if(present(header)) then
  print *, header, ' #### jref_stack_start ', jref_stack_start, new_jref_stack_start
else
  print *, '#### jref_stack_start ', jref_stack_start, new_jref_stack_start
end if
i=i_store(jref_stack_start)
cpt=1
do while(i>0)
  print *, 'ptr ', i, '(',nint(store(i+3)), nint(store(i+4)), nint(store(i+5)),')',cpt
  do j=0, n2t-1
    print *, '    ', j, nint(store(i_store(i+9)+j*4+0)), nint(store(i_store(i+9)+j*4+1)), &
    &   nint(store(i_store(i+9)+j*4+2)), store(i_store(i+9)+j*4+3)
  end do
  cpt=cpt+1
  i=i_store(i)
end do
print *, '-----'
print *, stack_indices
do i=1, size(stack_indices)-1
  print *, i, stack_indices(i), stack(stack_indices(i))%hkl
end do
print *, '#### ####'

end subroutine

function findloc(array, needle)
implicit none
integer findloc
integer, dimension(0:), intent(in) :: array
integer, intent(in) :: needle
integer i

findloc=-1
do i=0, size(array)-1
    if(array(i)==needle) then
        findloc=i
        exit
    end if
end do

end function

end module
