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

real, dimension(:,:), allocatable :: invertm !< Inverted normal matrix

type derivatives_t
    integer :: ioldrestraint !< Restraint index in design matrix
    integer :: irestraint !< restraint index in list 26
    integer :: isubrestraint !< sub restraint index
    real :: weight !< weight of the derivatives
    real, dimension(:), allocatable :: derivatives !< list of derivatives, all blocks appended
    integer, dimension(:), allocatable :: parameters !< parameters corresponding to the derivatives
contains 
	procedure, pass(self) :: dump => dumpderivatives
end type
type(derivatives_t), dimension(:), allocatable :: restraints_derivatives !< List of derivatives for the restraints

type atom_t
    character(len=4) :: label !< label of the atom
    integer :: serial !< serial number of the atom
    real, dimension(3,3) :: M !< Transformation matrix
    real, dimension(3) :: coordinates_crys !< coordinates in crystal system
    real, dimension(3) :: coordinates_cart !< coordinates in transformed coordinate system
    real, dimension(3,3) :: adps_crys !< adps in crystal system
    real, dimension(3,3) :: adps_cart !< adps in transformed coordinate system
    real, dimension(3,3) :: adps_target !< target adps
    real rvalue
    real rtarget 
end type

type subrestraint_t !< subrestraints type 
    type(atom_t), dimension(:), allocatable :: atoms !< atoms involved in a subrestraint.
    character(len=1024) :: description !< Some help that could be helpful when debugging
    real :: rvalue
end type

type restraints_t !< restraint type
    character(len=4096) :: restraint_text !< Text of the restraint from the user
    character(len=4096) :: description !< Description
    character(len=128) :: restraint_type !< type of restraint (distance, plane...)
    integer :: user_index !< index of restraint in gui window (list 16)
    type(subrestraint_t), dimension(:), allocatable :: subrestraints !< list of subrestraints generated from the restraint
contains
    procedure, pass(self) :: print => printrestraint !< print the content of the object (used for debugging)
end type

private extend_restraints, extend_subrestraints, extend_atoms
private extend_parent, extend_parameters, extend_derivatives

interface extend !< generic procedure to extend the several allocatables objects
    module procedure extend_restraints, extend_subrestraints, &
    &	extend_atoms, extend_parent, extend_parameters, extend_derivatives
end interface extend
    

type(restraints_t), dimension(:), allocatable :: restraints_list !< Main list of restraint

integer, dimension(:), allocatable :: subrestraints_parent !< compatibility layer with the old code which does not distinguished between user restraints and computed restraints
integer :: current_restraintindex=0 !< counter use for compatibility with the old code

type param_t !< Type holding the description of a least square parameter
    integer index !< index of the refinable parameter
    integer offset !< offset address in list 5
    character(len=4) :: label !< label of the atom
    integer serial !< serial of the atom
    character(len=24) :: name !< Name of the parameter
contains
    procedure, pass(self) :: print => printparam !< print the content of the object (used for debugging)
end type
type(param_t), dimension(:), allocatable :: parameters_list !< List of least squares parameters

contains

!> extend an array of derivatives type
subroutine extend_derivatives(object, argsize, reset)
implicit none
type(derivatives_t), dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
type(derivatives_t), dimension(:), allocatable :: temp
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

object(newstart:)%ioldrestraint=-1
object(newstart:)%irestraint=-1
object(newstart:)%isubrestraint=-1
    
end subroutine

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
    object(i)%adps_target=0.0 !< target adps 
    object(i)%rvalue=0.0 !< actual value
    object(i)%rtarget=0.0 !< target value
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
        
   end do
end if
    
end subroutine

!> print the content of a parameter
subroutine printparam(self)
implicit none
class(param_t), intent(in) :: self

write(*,'(I5,1X,I6,1X,A,"(",I0,")",1X,A)') self%index, self%offset, trim(self%label), self%serial, trim(self%name)

end subroutine

!> Print the leverage values of a restraint given the invert matrix
subroutine showleverage(rindex)
use xiobuf_mod, only: cmon
use xunits_mod, only: ncvdu
implicit none
integer, intent(in) :: rindex !< index of restraint in list 26
integer i, k
real leverage

if(.not. allocated(restraints_derivatives)) then
    write(cmon, '(10X, a)') '- Derivatives not found, do a refinement cycle to get leverages -'
    CALL XPRVDU(NCVDU, 1,0)
    return
end if

do k=1, size(restraints_derivatives)
	if(rindex==restraints_derivatives(k)%irestraint) then
		associate(r => restraints_derivatives(k))

			leverage=dot_product(r%derivatives, matmul(invertm, r%derivatives))

			WRITE(CMON,'(10X, A, a, "(",I0,"): ", 1PE10.3, 2X, A )') &
			&   'Leverage ', &
			&   trim(restraints_list(rindex)%subrestraints(r%isubrestraint)%atoms(1)%label), &
			&   restraints_list(rindex)%subrestraints(r%isubrestraint)%atoms(1)%serial, &
			&   leverage*r%weight**2, &
			&	trim(restraints_list(rindex)%subrestraints(r%isubrestraint)%description)
			CALL XPRVDU(NCVDU, 1,0)
			
		end associate
     end if
end do
  
end subroutine

!> print the derivatives in the lis output file
subroutine printderivatives(rindex)
use xunits_mod, only: ncwu
implicit none
integer, intent(in) :: rindex
integer i, j, k, cpt
character(len=128) :: formatstr
character(len=4096) :: strlong
integer, dimension(:), allocatable :: list

if(.not. allocated(restraints_derivatives)) then
	WRITE(NCWU,'(A)') 'No derivatives stored, do a refinement cycle'
	return
end if

do k=1, size(restraints_derivatives)
	if(rindex==restraints_derivatives(k)%irestraint) then
		associate(r => restraints_derivatives(k))
			cpt=count(r%parameters/=0)	
			allocate(list(cpt))
			list=pack( (/ (i, i=1, size(r%parameters)) /), r%parameters/=0)

			write(formatstr, '(A,I0,A,A)') "(",cpt, '(A4,"(",I4,")",A6,2X)',")"
			write(strlong, formatstr) ( &
			&   trim(parameters_list(list(i))%label), parameters_list(list(i))%serial, &
			&   trim(parameters_list(list(i))%name) ,i=1, size(list))
			
			WRITE(NCWU,'(6X,A)') trim(strlong)

			write(formatstr, '(A,I0,A,A)') "(",cpt, '(I5,":",1PE10.3,2X)',")"
			write(strlong, formatstr) (r%parameters(list(i)),r%weight*r%derivatives(list(i)),i=1, size(list))
			WRITE(NCWU,'(6X,A,3X,A)') trim(strlong), 'pp'
			deallocate(list)
		end associate
	end if
end do


end subroutine

!> dump content of derivatives_t (debugging)
subroutine dumpderivatives(self)
implicit none
class(derivatives_t), intent(in) :: self

	print *, self%ioldrestraint, self%irestraint, self%isubrestraint, self%weight
end subroutine

end module
