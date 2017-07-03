!> Data storage for the calculation of restraints. It supplements the actual storage in STORE for the moment
!!
!! \section Implementation
!! The object is filled in different subroutine. XAPP16 creates the restraint list and add in the the text from list16.
!! In the same subroutine, inside individual call to restraints subroutines (XCV* and the like), the individual information is added to the object.
!! the derivatives are added in XADCPD.
!!
!! In order to run check hi without dependency, a special call to XAPP16 and XADCPD is made (calconly=.true.) in XCHK16 which does not apply the changes to the disc.
!!
!! For now this object only complements the original storage in the dsc and this new information is not saved and must be computed everytime.
module list26_mod
implicit none

type atom_t
    character(len=4) :: label !< label of the atom
    integer :: serial !< serial number of the atom
    real, dimension(3,3) :: M !< Transformation matrix
    real, dimension(3) :: coordinates_crys !< coordinates in crystal system
    real, dimension(3) :: coordinates_cart !< coordinates in transformed coordinate system
    real, dimension(3,3) :: adps_crys !< adps in crystal system
    real, dimension(3,3) :: adps_cart !< adps in transformed coordinate system
end type

type block_t !< blocks used during refinement
    real, dimension(:), allocatable :: derivatives !< unweighting line of the design matrix in the current block (derivatives)
    integer, dimension(:), allocatable :: parameters !< list of the parameters corresponding to the derivatives
    real :: weight !< weight of the restraint
contains
    procedure, pass(self) :: print => formatted_derivatives
    procedure, pass(self) :: printp => formatted_parameters
end type

type subrestraint_t !< subrestraints type 
    type(block_t), dimension(:), allocatable :: blocks !< list blocks
    type(atom_t), dimension(:), allocatable :: atoms !< atoms involved in a subrestraint.
    character(len=1024) :: description !< Some help that could be helpful when debugging
end type

type restraints_t !< restraint type
    character(len=4096) :: restraint_text !< Text of the restraint from the user
    character(len=128) :: restraint_type !< type of restraint (distance, plane...)
    integer :: user_index !< index of restraint in gui window (list 16)
    type(subrestraint_t), dimension(:), allocatable :: subrestraints !< list of subrestraints generated from the restraint
contains
    procedure, pass(self) :: print => printrestraint !< print the content of the object (used for debugging)
end type

private extend_restraints, extend_subrestraints, extend_blocks, extend_atoms, extend_parent, extend_parameters

interface extend !< generic procedure to extend the several allocatables objects
    module procedure extend_restraints, extend_subrestraints, extend_blocks, extend_atoms, extend_parent, extend_parameters
end interface extend
    

type(restraints_t), dimension(:), allocatable :: restraints_list !< Main list of restraint

integer, dimension(:), allocatable :: subrestraints_parent !< compatibility layer with the old code which does not distinguished between user restraints and computed restraints
integer :: current_restraintindex=0 !< counter use for compatibility with the old code

type param_t !< Type holding the description of a least square parameter
    integer index !< index of the refinable parameter
    character(len=4) :: label !< label of the atom
    integer serial !< serial of the atom
    character(len=24) :: name !< Name of the parameter
contains
    procedure, pass(self) :: print => printparam !< print the content of the object (used for debugging)
end type
type(param_t), dimension(:), allocatable :: parameters_list !< List of least parameters

contains

!> extend an array of integer
subroutine extend_parent(object, argsize, reset)
implicit none
integer, dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
integer, dimension(:), allocatable :: temp
integer isize, newstart

if(present(argsize)) then
    isize=argsize
else
    isize=1
end if

if(present(reset)) then
    if(reset) then
        if(allocated(object)) deallocate(object)
    end if
end if

if(allocated(object)) then
    call move_alloc(object, temp)

    allocate(object(size(temp)+isize))
    object(1:size(temp)) = temp
    newstart=size(temp)+1
else
    allocate(object(isize))
    newstart=1
end if

object(newstart:)=0

end subroutine

!> extend an array of restraints
subroutine extend_restraints(object, argsize, reset)
implicit none
type(restraints_t), dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
type(restraints_t), dimension(:), allocatable :: temp
integer isize, newstart

if(present(argsize)) then
    isize=argsize
else
    isize=1
end if

if(present(reset)) then
    if(reset) then
        if(allocated(object)) deallocate(object)
    end if
end if

if(allocated(object)) then
    call move_alloc(object, temp)

    allocate(object(size(temp)+isize))
    object(1:size(temp)) = temp
    newstart=size(temp)+1
else
    allocate(object(isize))
    newstart=1
end if

object(newstart:)%restraint_text=''
object(newstart:)%restraint_type=''

end subroutine

!> extend an array of subrestraints
subroutine extend_subrestraints(object, argsize, reset)
implicit none
type(subrestraint_t), dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
type(subrestraint_t), dimension(:), allocatable :: temp
integer isize, newstart

if(present(argsize)) then
    isize=argsize
else
    isize=1
end if

if(present(reset)) then
    if(reset) then
        if(allocated(object)) deallocate(object)
    end if
end if

if(allocated(object)) then
    call move_alloc(object, temp)

    allocate(object(size(temp)+isize))
    object(1:size(temp)) = temp
    newstart=size(temp)+1
else
    allocate(object(isize))
    newstart=1
end if

end subroutine

!> extend an array of blocks
subroutine extend_blocks(object, argsize, reset)
implicit none
type(block_t), dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
type(block_t), dimension(:), allocatable :: temp
integer isize

if(present(argsize)) then
    isize=argsize
else
    isize=1
end if

if(present(reset)) then
    if(reset) then
        if(allocated(object)) deallocate(object)
    end if
end if

if(allocated(object)) then
    call move_alloc(object, temp)

    allocate(object(lbound(temp,1):ubound(temp,1)+isize))
    object(lbound(temp,1):ubound(temp,1)) = temp
else
    allocate(object(0:isize-1))
end if

end subroutine

!> extend an array of parameters
subroutine extend_parameters(object, argsize, reset)
implicit none
type(param_t), dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
type(param_t), dimension(:), allocatable :: temp
integer isize, newstart,i

if(present(argsize)) then
    isize=argsize
else
    isize=1
end if

if(present(reset)) then
    if(reset) then
        if(allocated(object)) deallocate(object)
    end if
end if

if(allocated(object)) then
    call move_alloc(object, temp)

    allocate(object(size(temp)+isize))
    object(1:size(temp)) = temp
    newstart=size(temp)+1
else
    allocate(object(isize))
    newstart=1
end if

object(newstart:)%index=-99 !< Index of the parameter
object(newstart:)%label='' !< label of the atom
object(newstart:)%serial=-1 !< serial number of the atom
object(newstart:)%name='' !< Name of the parameter
end subroutine

!> extend an array of atoms
subroutine extend_atoms(object, argsize, reset)
implicit none
type(atom_t), dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
type(atom_t), dimension(:), allocatable :: temp
integer isize, newstart,i

if(present(argsize)) then
    isize=argsize
else
    isize=1
end if

if(present(reset)) then
    if(reset) then
        if(allocated(object)) deallocate(object)
    end if
end if

if(allocated(object)) then
    call move_alloc(object, temp)

    allocate(object(size(temp)+isize))
    object(1:size(temp)) = temp
    newstart=size(temp)+1
else
    allocate(object(isize))
    newstart=1
end if

object(newstart:)%label='' !< label of the atom
object(newstart:)%serial=-1 !< serial number of the atom
do i=newstart, size(object)
    object(i)%M=0.0 !< Transformation matrix
    object(i)%coordinates_crys=0.0 !< coordinates in crystal system
    object(i)%coordinates_cart=0.0 !< coordinates in transformed coordinate system
    object(i)%adps_crys=0.0 !< adps in crystal system
    object(i)%adps_cart=0.0 !< adps in transformed coordinate system
end do
end subroutine

!> print the content of a restraint
subroutine printrestraint(self)
implicit none
class(restraints_t), intent(in) :: self
integer i, j, k
character(len=128) :: buffer
character(len=1024) :: atomlist

write(*,*) trim(self%restraint_text)
if(trim(self%restraint_type)/='') then
   write(*,*) trim(self%restraint_type)
else
    write(*,*) '`No description`'
end if
if(allocated(self%subrestraints)) then
   write(*, '(I0, 1X, A)') size(self%subrestraints), ' subrestraints:'
   do i=1, size(self%subrestraints)
       write(*, '(4X,A)') trim(self%subrestraints(i)%description)
       atomlist=''
       if(allocated(self%subrestraints(i)%atoms)) then
           do j=1, size(self%subrestraints(i)%atoms)
               write(buffer, '(A,"(",I0,")")') trim(self%subrestraints(i)%atoms(j)%label), &
               &   self%subrestraints(i)%atoms(j)%serial
               atomlist=trim(atomlist)//' '//trim(buffer)
           end do
           write(*, '(4X,I0,1X,A)') i, trim(atomlist)
       end if
        
       if(allocated(self%subrestraints(i)%blocks)) then
           write(*, '(4X,I0,A)') ubound(self%subrestraints(i)%blocks, 1), ' block(s):'
           do j=1, ubound(self%subrestraints(i)%blocks, 1)
               write(buffer, '("(7X,''('',I0,'')'',",I0,"(1X,1PE9.2))")') size(self%subrestraints(i)%blocks(j)%derivatives)
               write(*, buffer) size(self%subrestraints(i)%blocks(j)%derivatives), self%subrestraints(i)%blocks(j)%derivatives
               write(*, '(A, 1PE10.3)') 'Weight: ', self%subrestraints(i)%blocks(j)%weight
           end do
       end if
   end do
end if
    
end subroutine

!> print the content of a restraint
subroutine printparam(self)
implicit none
class(param_t), intent(in) :: self
integer i, j, k
character(len=128) :: buffer
character(len=1024) :: atomlist

write(*,'(I5,1X,A,"(",I0,")",1X,A)') self%index, trim(self%label), self%serial, trim(self%name)

end subroutine

function formatted_derivatives(self, weight) result(str)
implicit none
class(block_t), intent(in) :: self
real, intent(in), optional :: weight
character(len=:), allocatable :: str
integer cpt, i
character(len=128) :: formatstr
character(len=4096) :: strlong
integer, dimension(:), allocatable :: list

cpt=count(self%parameters/=0)
allocate(list(cpt))
list=pack( (/ (i, i=1, size(self%parameters)) /), self%parameters/=0)

write(formatstr, '(A,I0,A,A)') "(",cpt, '(I5,":",1PE10.3,2X)',")"

if(present(weight)) then
    write(strlong, formatstr) (self%parameters(list(i)),weight*self%derivatives(list(i)),i=1, size(list))
else
    write(strlong, formatstr) (self%parameters(list(i)),self%derivatives(list(i)),i=1, size(list))
end if

str=trim(strlong)

end function

function formatted_parameters(self, names) result(str)
implicit none
class(block_t), intent(in) :: self
logical, intent(in), optional :: names !< print names instead of nmubers
character(len=:), allocatable :: str
integer cpt, i, j
character(len=128) :: formatstr
character(len=4096) :: strlong
integer, dimension(:), allocatable :: list

cpt=count(self%parameters/=0)
allocate(list(cpt))
list=pack( (/ (i, i=1, size(self%parameters)) /), self%parameters/=0)

do i=1, cpt
    do j=1, size(parameters_list)
        if( list(i)==parameters_list(j)%index ) then
            list(i)=j
            exit
        end if
    end do
end do


if(present(names)) then
    write(formatstr, '(A,I0,A,A)') "(",cpt, '(A4,"(",I4,")",A6,2X)',")"
    write(strlong, formatstr) ( &
    &   trim(parameters_list(list(i))%label), parameters_list(list(i))%serial, &
    &   trim(parameters_list(list(i))%name) ,i=1, size(list))
else
    write(formatstr, '(A,I0,A,A)') "(",cpt, '(I16,2X)',")"
    write(strlong, formatstr) (list(i) ,i=1, size(list))
end if

str=trim(strlong)

end function


end module
