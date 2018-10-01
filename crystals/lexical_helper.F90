!> Module for the lexical analyzer \ingroup crystals
module xlexical_mod
implicit none
private

!> type holding information during preprocssing
type restraint_t
  character(len=5) :: type !< type of restraint
  character(len=:), allocatable :: original !< original text
  character(len=:), allocatable :: processed !< pre-processed text
end type
!> Storage of the list of restraints before after pre-processing
type(restraint_t), dimension(:), allocatable :: restraints_list
integer :: restraints_list_index = 0 !< index in restraints_list
public restraints_list, restraints_list_index

!> List of crystals bond definition
!!    1 = single  2= double  3=triple  4=quadruple
!!    5 = aromatic      6 = polymeric single
!!    7 = delocalised   9 = pi-bond
character(len=2), dimension(8), parameter :: bond_list_definition = &
& (/ '--', '==', '-=', '##', '@@', '&&', '~~', 'oo' /)

!> Symmetry operator as defined in crystals
type sym_op_t
  integer S !< S specifies a symmetry operator provided in LIST 2. 'S' may take any value between '-NSYM' and '+NSYM', except zero, where 'NSYM' is the number of symmetry equivalent positions provided in LIST 2
  integer L !< L specifies the non-primitive lattice translation that is to be added after the coordinates have been modified by the operations given by 'S'.
  real, dimension(3) :: translation !< translation part
end type 

!> general atom type
type atom_t
  character(len=5) :: label !< atomic type
  integer :: serial !< serial number
  type(sym_op_t) :: sym_op !< symmetry operator
  integer :: ref !< a ref number used when building pairs
  integer :: bond !< type of bond when used in pairs
contains
  procedure :: init => init_atom !< initialise object
  procedure :: text => atom_text !< pretty print
end type

!> variable name and its value
type variable_t
  character(len=64) :: label !< name of variable
  real :: rvalue !< value
end type
!> Hold the list of variables for substitution
!! definition: `define a = 0.01`
!! usage: `dist 0.0, $a = mean ...`
type(variable_t), dimension(256) :: restraints_var_list
integer :: restraints_var_list_index = 0 !< max index in restraints_var_list

public lexical_preprocessing, restraints_init

contains

!> Initialise restraints
subroutine restraints_init()
implicit none
  if(allocated(restraints_list)) then
    deallocate(restraints_list)
    restraints_list_index = 0
  end if
  restraints_var_list_index = 0
end subroutine

!> Preprocess a restraint with various substitutions
subroutine lexical_preprocessing(image_text, ierror)
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
implicit none
character(len=*) :: image_text !< text of the restraint (one line)
integer, intent(out) :: ierror !< error code 0==success
integer i
type(restraint_t), dimension(:), allocatable :: restraints_temp

  ierror=0
  
  restraints_list_index = restraints_list_index + 1
  if(.not. allocated(restraints_list)) then
    allocate(restraints_list(128))
  end if
  if(restraints_list_index>size(restraints_list)) then
    call move_alloc(restraints_list, restraints_temp)
    allocate(restraints_list(size(restraints_temp)+128))
    restraints_list(1:size(restraints_temp)) = restraints_temp
  end if
  
  allocate(character(len=len_trim(image_text)) :: &
  & restraints_list(restraints_list_index)%original)
  restraints_list(restraints_list_index)%original=trim(image_text)
  if(len_trim(restraints_list(restraints_list_index)%original)>4) then
    do i=restraints_list_index, 1, -1
      if(restraints_list(i)%original(1:4)=='CONT') then
        cycle
      else
        restraints_list(restraints_list_index)%type=restraints_list(i)%original(1:5)
        exit
      end if
    end do  
  else
    restraints_list(restraints_list_index)%type=restraints_list(restraints_list_index)%original
  end if

  ! Look for variable definition: define a = 0.01
  call define_variable(image_text, ierror)
  if(ierror/=0) return
  
  ! replace variable names with their definition: $a
  call substitue_variable(image_text, ierror)
  if(ierror/=0) return
  
  ! look for bonds definitions: C--H
  call replace_bonds(image_text)  
  
  ! expand atom names: C(*)
  call expand_atoms_names(image_text, ierror)
  
  ! expand xchiv restraint
  call expand_xchiv(image_text, ierror)  

  ! expand rigu restraint
  call expand_rigu(image_text, ierror)  

  associate(restraint => restraints_list(restraints_list_index))
    allocate(character(len=len_trim(image_text)) :: restraint%processed)
    restraint%processed=trim(image_text)

    if(image_text/=restraint%original) then
      write(cmon, '(A,A)') '{I --- ', restraint%original
      call xprvdu(ncvdu,1,0)
      write(cmon, '(A,A)') '{I +++ ', restraint%processed
      call xprvdu(ncvdu,1,0)
    end if
  end associate

end subroutine

!> Split a string into different pieces given a separator. Defaul separator is space.
!! Len of pieces must be passed to the function
subroutine explode(line, lenstring, elements, sep_arg, greedy_arg)
implicit none
  character(len=*), intent(in) :: line !< text to process
  integer, intent(in) :: lenstring !< length of each individual elements
  character, intent(in), optional :: sep_arg !< Separator 
  logical, intent(in), optional :: greedy_arg !< do not merge consecutive separators if false
  character(len=lenstring), dimension(:), allocatable, intent(out) :: elements
  character(len=lenstring), dimension(:), allocatable :: temp
  character(len=lenstring) :: bufferlabel
  integer i, j, k, n, m, start, maxel
  character sep
  logical greedy

  if(present(sep_arg)) then
    sep=sep_arg
  else
    sep=' '
  end if

  if(present(greedy_arg)) then
    greedy=greedy_arg
  else
    greedy=.true.
  end if
  
  start=1
  if(greedy) then
    do while(line(start:start)==sep)
      start=start+1
    end do
  end if
  
  allocate(elements(count_char(trim(line), sep, greedy)+1-start+1))

  k=1
  j=0
  bufferlabel=''
  do i=start, len_trim(line)
    if(line(i:i)==sep) then
      if(greedy .and. i>1) then
        if(line(i-1:i-1)==sep) then
          cycle
        end if
      end if
      elements(k)=bufferlabel
      k=k+1
      j=0
      bufferlabel=''
      cycle            
    end if
    j=j+1
    if(j>lenstring) cycle
    bufferlabel(j:j)=line(i:i)
  end do
  if(j>0 .and. trim(bufferlabel)/='') then
    elements(k)=bufferlabel
  end if
  
  ! check for parenthesis, separator is allowed inside them
  maxel = size(elements)
  i = 1
  do 
    if(i>maxel) exit
    n = count( (/ (elements(i)(j:j), j=1, len_trim(elements(i))) /) == '(' ) 
    m = count( (/ (elements(i)(j:j), j=1, len_trim(elements(i))) /) == ')' ) 
    if(n/=m .and. i<size(elements)) then
      ! found unbalanced parenthesis, merging next field
      maxel = maxel -1
      elements(i) = trim(elements(i))//trim(elements(i+1))
      elements(i+1:maxel)=elements(i+2:maxel+1)
      cycle
    end if
    i = i +1
  end do
  if(maxel<size(elements)) then
    call move_alloc(elements, temp)
    allocate(elements(maxel))
    elements=temp(1:maxel)
  end if
end subroutine

!> count the number of a character, option to count consecutive ones as one.
pure function count_char(line, c, greedy) result(cpt)
implicit none
character(len=*), intent(in) :: line !< text to process
character, intent(in) :: c !< character to search
logical, intent(in) :: greedy
integer cpt !< Number of character found
integer i

    cpt=0
    do i=1, len_trim(line)
        if(line(i:i)==c) then
            if(greedy .and. i>1) then
                if(line(i-1:i-1)/=c) then
                    cpt=cpt+1
                end if
            end if
        end if
    end do
    
end function

!> Get get pairs of atoms using the connectivity list
subroutine get_pairs(atoms, pairs, bond_type)
! we assume list 5 and 41 already loaded
use xlst05_mod, only: l5, md5 !< atomic model
use xlst41_mod, only: m41b, l41b, n41b, md41b !< connectivity list
use store_mod, only: istore => i_store, c_store, store
implicit none
type(atom_t), dimension(:), intent(in) :: atoms !< list of atoms to use
type(atom_t), dimension(:,:), allocatable, intent(out) :: pairs !< pairs of atoms found
integer, intent(in), optional :: bond_type !< optional bond type to look for
integer i, ia1, ia2
type(atom_t) :: left, right
type(atom_t), dimension(:,:), allocatable :: pairs_temp
integer pair_index

  allocate(pairs_temp(2, 128))
  call pairs_temp%init()
  pair_index=0
  
  if(md41b==0) then
    ! no bonds
    allocate(pairs(0,0))
    return
  end if
  
  do m41b = l41b, l41b + (n41b-1)*md41b, md41b
    ia1 = l5 + istore(m41b)*md5
    ia2 = l5 + istore(m41b+6)*md5
    
    call left%init()
    call right%init()
    do i=1, size(atoms) 
      if(trim(atoms(i)%label)==trim(c_store(ia1))) then
        if(atoms(i)%serial==-1) then
          ! found one side
          if(left%serial==-1 .and. right%ref/=i) then
            ! left has not been assigned yet atom(i) is not used in right
            left%label=c_store(ia1)
            left%serial=nint(store(ia1+1))
            left%ref=i
            left%bond=istore(m41b+12)
            left%sym_op%S=istore(m41b+1)
            left%sym_op%L=istore(m41b+2)
            left%sym_op%translation=store(m41b+3:m41b+5)
          end if
        else
          if(atoms(i)%serial==nint(store(ia1+1))) then
            ! left has not been assigned yet atom(i) is not used in right
            left%label=c_store(ia1)
            left%serial=nint(store(ia1+1))
            left%ref=i
            left%bond=istore(m41b+12)
            left%sym_op%S=istore(m41b+1)
            left%sym_op%L=istore(m41b+2)
            left%sym_op%translation=store(m41b+3:m41b+5)
          end if
        end if
      end if

      if(trim(atoms(i)%label)==trim(c_store(ia2))) then
        if(atoms(i)%serial==-1) then
          ! found the other side
          if(right%serial==-1 .and. left%ref/=i) then
            ! right has not been assigned yet atom(i) is not used in left
            right%label=c_store(ia2)
            right%serial=nint(store(ia2+1))
            right%ref=i
            right%bond=istore(m41b+12)
            right%sym_op%S=istore(m41b+7)
            right%sym_op%L=istore(m41b+8)
            right%sym_op%translation=store(m41b+9:m41b+11)
          end if
        else
          if(atoms(i)%serial==nint(store(ia2+1))) then
            ! right has not been assigned yet atom(i) is not used in left
            right%label=c_store(ia2)
            right%serial=nint(store(ia2+1))
            right%ref=i
            right%bond=istore(m41b+12)
            right%sym_op%S=istore(m41b+7)
            right%sym_op%L=istore(m41b+8)
            right%sym_op%translation=store(m41b+9:m41b+11)
          end if
        end if
      end if
    end do
  
    if(left%ref/=-1 .and. right%ref/=-1) then
      if(present(bond_type)) then
        if(bond_type/=left%bond .or. bond_type/=right%bond) then
          ! incorrect bond type, ignoring...
          cycle
        end if
      end if
      
      pair_index=pair_index+1
      if(pair_index>ubound(pairs_temp, 2)) then
        call move_alloc(pairs_temp, pairs)
        allocate(pairs_temp(2, size(pairs)))
        call pairs_temp%init()
        pairs_temp(:, 1:ubound(pairs, 2))=pairs
      end if
      pairs_temp(1, pair_index)=left
      pairs_temp(2, pair_index)=right
    end if
  end do

  allocate(pairs(2, pair_index))
  pairs=pairs_temp(:,1:pair_index) 

end subroutine

!> Get get 1,3 pairs of atoms using the precomputed 1,3 connectivity with get_connectivity_13
subroutine get_pairs_13(atoms, connectivity_13, pairs)
! we assume list 5 and 41 already loaded
use xlst05_mod, only: l5, md5 !< atomic model
use xlst41_mod, only: m41b, l41b, n41b, md41b !< connectivity list
use store_mod, only: istore => i_store, c_store, store
implicit none
type(atom_t), dimension(:), intent(in) :: atoms !< list of atoms to use
integer, dimension(:,:), intent(in) :: connectivity_13 !< 1,3 connectivity as calculated by get_connectivity_13
type(atom_t), dimension(:,:), allocatable, intent(out) :: pairs !< pairs of 1,3 atoms found
integer i, j, ia1, ia3, m41b_1, m41b_3
type(atom_t) :: left, right
type(atom_t), dimension(:,:), allocatable :: pairs_temp
integer pair_index
integer ia2

  allocate(pairs_temp(2, 128))
  call pairs_temp%init()
  pair_index=0
  
  if(size(connectivity_13)==0) then
    ! no bonds
    allocate(pairs(0,0))
    return
  end if
  
  do j=1, ubound(connectivity_13, 2)
    !print *, '======================'
    ia1=connectivity_13(1,j)
    m41b_1=connectivity_13(2,j)
    ia3=connectivity_13(5,j)
    m41b_3=connectivity_13(6,j)
    !print *, connectivity_13(:,j)
    ia2=connectivity_13(3,j)
    !write(*, '(3(A4,1X,I0,1X))') store(ia1), int(store(ia1+1)), store(ia2), int(store(ia2+1)), store(ia3), int(store(ia3+1))
    
    call left%init()
    call right%init()

    do i=1, size(atoms) 
      !print *, atoms(i)%text()
      if(trim(atoms(i)%label)==trim(c_store(ia1))) then
        !print *, 'left ', atoms(i)%text()
        if(atoms(i)%serial==-1) then
          ! found one side
          if(left%serial==-1 .and. right%ref/=i) then
            ! left has not been assigned yet atom(i) is not used in right
            ! print *, 'left ', trim(c_store(ia1)), nint(store(ia1+1)), i, left%ref, right%ref
            left%label=c_store(ia1)
            left%serial=nint(store(ia1+1))
            left%ref=i
            left%sym_op%S=istore(m41b_1+1)
            left%sym_op%L=istore(m41b_1+2)
            left%sym_op%translation=store(m41b_1+3:m41b_1+5)
          end if
        else if(atoms(i)%serial==nint(store(ia1+1))) then
          ! print *, 'left ', trim(c_store(ia1)), nint(store(ia1+1)), i, left%ref, right%ref
          left%label=c_store(ia1)
          left%serial=nint(store(ia1+1))
          left%ref=i
          left%sym_op%S=istore(m41b_1+1)
          left%sym_op%L=istore(m41b_1+2)
          left%sym_op%translation=store(m41b_1+3:m41b_1+5)
        end if
      end if

      if(trim(atoms(i)%label)==trim(c_store(ia3))) then
        !print *, 'right ', atoms(i)%text()
        if(atoms(i)%serial==-1) then
          ! found the other side
          if(right%serial==-1 .and. left%ref/=i) then
            ! print *, 'right ', trim(c_store(ia3)), nint(store(ia3+1)), i, left%ref, right%ref
            ! right has not been assigned yet atom(i) is not used in left
            right%label=c_store(ia3)
            right%serial=nint(store(ia3+1))
            right%ref=i
            right%sym_op%S=istore(m41b_3+7)
            right%sym_op%L=istore(m41b_3+8)
            right%sym_op%translation=store(m41b_3+9:m41b_3+11)
          end if
        else if(atoms(i)%serial==nint(store(ia3+1))) then
          ! print *, 'right ', trim(c_store(ia3)), nint(store(ia3+1)), i, left%ref, right%ref
          right%label=c_store(ia3)
          right%serial=nint(store(ia3+1))
          right%ref=i
          right%sym_op%S=istore(m41b_3+7)
          right%sym_op%L=istore(m41b_3+8)
          right%sym_op%translation=store(m41b_3+9:m41b_3+11)
        end if
      end if
    end do
  
    if(left%ref/=-1 .and. right%ref/=-1) then
      pair_index=pair_index+1
      if(pair_index>ubound(pairs_temp, 2)) then
        call move_alloc(pairs_temp, pairs)
        allocate(pairs_temp(2, size(pairs)))
        call pairs_temp%init()
        pairs_temp(:, 1:ubound(pairs, 2))=pairs
      end if
      pairs_temp(1, pair_index)=left
      pairs_temp(2, pair_index)=right
    end if
  end do
  
  allocate(pairs(2, pair_index))
  pairs=pairs_temp(:,1:pair_index) 

end subroutine

!> Get get 1,3 list of atoms using the connectivity list
subroutine get_connectivity_13(connectivity_13)
! we assume list 5 and 41 already loaded
use xlst05_mod, only: l5, md5 !< atomic model
use xlst41_mod, only: l41b, n41b, md41b !< connectivity list
use store_mod, only: istore => i_store, c_store, store
implicit none
integer, dimension(:,:), allocatable, intent(out) :: connectivity_13 !< list of 3 atoms vectors forming 1-3 connections
integer, dimension(:,:), allocatable :: connectivity_13_temp
integer m41b_1, m41b_2, ia1, ia2, ib1, ib2, connectivity_13_index

  if(md41b==0) then
    ! no bonds
    allocate(connectivity_13(0,0))
    return
  end if

  allocate(connectivity_13_temp(6, 128))
  connectivity_13_temp=0
  connectivity_13_index=0
    
  do m41b_1 = l41b, l41b + (n41b-1)*md41b, md41b
    ia1 = l5 + istore(m41b_1)*md5
    ia2 = l5 + istore(m41b_1+6)*md5

    do m41b_2 = l41b, l41b + (n41b-1)*md41b, md41b
      if(m41b_2<m41b_1) then
        cycle
      end if
      
      ib1 = l5 + istore(m41b_2)*md5
      ib2 = l5 + istore(m41b_2+6)*md5
      
      if( ia1==ib1 .and. ia2/=ib2 .and. &
      & istore(m41b_1+1)==istore(m41b_2+1) .and. &
      & istore(m41b_1+2)==istore(m41b_2+2) .and. &
      & all(abs(store(m41b_1+3:m41b_1+5)-store(m41b_2+3:m41b_2+5))<0.001) ) then
      
        connectivity_13_index=connectivity_13_index+1
        if(connectivity_13_index>ubound(connectivity_13_temp, 2)) then
          call extend_connectivity(connectivity_13_temp)
        end if
        connectivity_13_temp(1,connectivity_13_index)=ia2
        connectivity_13_temp(2,connectivity_13_index)=m41b_1
        connectivity_13_temp(3,connectivity_13_index)=ia1
        connectivity_13_temp(4,connectivity_13_index)=m41b_1
        connectivity_13_temp(5,connectivity_13_index)=ib2
        connectivity_13_temp(6,connectivity_13_index)=m41b_2
        !write(*, '(3(A4,1X,I0,1X))') store(ia2), int(store(ia2+1)), store(ia1), int(store(ia1+1)), store(ib2), int(store(ib2+1))
        
      else if(ia1==ib2 .and. ia2/=ib1 .and. &
      & istore(m41b_1+1)==istore(m41b_2+1) .and. &
      & istore(m41b_1+2)==istore(m41b_2+2) .and. &
      & all(abs(store(m41b_1+3:m41b_1+5)-store(m41b_2+3:m41b_2+5))<0.001) ) then
      
        connectivity_13_index=connectivity_13_index+1
        if(connectivity_13_index>ubound(connectivity_13_temp, 2)) then
          call extend_connectivity(connectivity_13_temp)
        end if
        connectivity_13_temp(1,connectivity_13_index)=ia2
        connectivity_13_temp(2,connectivity_13_index)=m41b_1
        connectivity_13_temp(3,connectivity_13_index)=ia1
        connectivity_13_temp(4,connectivity_13_index)=m41b_1
        connectivity_13_temp(5,connectivity_13_index)=ib1
        connectivity_13_temp(6,connectivity_13_index)=m41b_2
        !write(*, '(3(A4,1X,I0,1X))') store(ia2), int(store(ia2+1)), store(ia1), int(store(ia1+1)), store(ib1), int(store(ib1+1))
        
      else if(ia2==ib1 .and. ia1/=ib2 .and. &
      & istore(m41b_1+1)==istore(m41b_2+1) .and. &
      & istore(m41b_1+2)==istore(m41b_2+2) .and. &
      & all(abs(store(m41b_1+3:m41b_1+5)-store(m41b_2+3:m41b_2+5))<0.001) ) then
      
        connectivity_13_index=connectivity_13_index+1
        if(connectivity_13_index>ubound(connectivity_13_temp, 2)) then
          call extend_connectivity(connectivity_13_temp)
        end if
        connectivity_13_temp(1,connectivity_13_index)=ia1
        connectivity_13_temp(2,connectivity_13_index)=m41b_1
        connectivity_13_temp(3,connectivity_13_index)=ia2
        connectivity_13_temp(4,connectivity_13_index)=m41b_1
        connectivity_13_temp(5,connectivity_13_index)=ib2
        connectivity_13_temp(6,connectivity_13_index)=m41b_2
        !write(*, '(3(A4,1X,I0,1X))') store(ia1), int(store(ia1+1)), store(ia2), int(store(ia2+1)), store(ib2), int(store(ib2+1))
        
      else if(ia2==ib2 .and. ia1/=ib1 .and. &
      & istore(m41b_1+1)==istore(m41b_2+1) .and. &
      & istore(m41b_1+2)==istore(m41b_2+2) .and. &
      & all(abs(store(m41b_1+3:m41b_1+5)-store(m41b_2+3:m41b_2+5))<0.001) ) then
      
        connectivity_13_index=connectivity_13_index+1
        if(connectivity_13_index>ubound(connectivity_13_temp, 2)) then
          call extend_connectivity(connectivity_13_temp)
        end if
        connectivity_13_temp(1,connectivity_13_index)=ia1
        connectivity_13_temp(2,connectivity_13_index)=m41b_1
        connectivity_13_temp(3,connectivity_13_index)=ia2
        connectivity_13_temp(4,connectivity_13_index)=m41b_1
        connectivity_13_temp(5,connectivity_13_index)=ib1
        connectivity_13_temp(6,connectivity_13_index)=m41b_2
        !write(*, '(3(A4,1X,I0,1X))') store(ia1), int(store(ia1+1)), store(ia2), int(store(ia2+1)), store(ib1), int(store(ib1+1))
        
      end if
    end do
  end do
  
  allocate(connectivity_13(6, 1:connectivity_13_index))
  connectivity_13=connectivity_13_temp(:,1:connectivity_13_index)
  
  !do connectivity_13_index=1, ubound(connectivity_13, 2)
  !  print *, trim(c_store(connectivity_13(1,connectivity_13_index))), &
  !  & nint(store(connectivity_13(1,connectivity_13_index)+1)), ' # ', &
  !  & trim(c_store(connectivity_13(5,connectivity_13_index))), &
  !  & nint(store(connectivity_13(5,connectivity_13_index)+1))
  !end do
contains

  !> Extend connectivity_13 array when full
  subroutine extend_connectivity(connectivity_13)
  implicit none
  integer, dimension(:,:), allocatable, intent(inout) :: connectivity_13
  integer, dimension(:,:), allocatable :: temp
  
  call move_alloc(connectivity_13, temp)
  allocate(connectivity_13(6, size(temp)+128))
  connectivity_13=0
  connectivity_13(:,1:ubound(temp,2))=temp
  
  end subroutine

end subroutine

!> initialise atom_t type with default values
elemental subroutine init_atom(self)
implicit none
class(atom_t), intent(inout) :: self
  self%label = ''
  self%serial = -1
  self%sym_op%S=0
  self%sym_op%L=0
  self%sym_op%translation=0.0
  self%ref = -1
end subroutine

!> pretty print for atom_t type
function atom_text(self)
implicit none
class(atom_t), intent(in) :: self
character(len=:), allocatable ::atom_text
character(len=256) :: buffer

  write(buffer, '(A,"(",I0,")")') trim(self%label), self%serial
  atom_text=trim(buffer)
end function

!> replace a bond place holder with paris of bonded atoms (C--H => C(1) to H(1), ...)
subroutine replace_bonds(text)
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
implicit none
character(len=*), intent(inout) :: text
character(len=3) :: bond_type_text, left, right
integer bond_type, location, motif_len
integer i, j
! atoms pairs
type(atom_t), dimension(2) :: atoms
type(atom_t), dimension(:,:), allocatable :: pairs
character(len=8000) :: replacement
character(len=512) :: buffer

  do ! loop until everything is found
    bond_type=-1
    do i=1, size(bond_list_definition)  
      write(bond_type_text, '("-",I0,"-")') i
      if(index(text, bond_list_definition(i))>0 .or. &
      & index(text, bond_type_text)>0) then
        bond_type=i
        exit
      end if
    end do
  
    if(bond_type<=0) then
      exit
    end if
  
    ! we found a bond definition, we now fetch the atom type
    location=index(text, bond_list_definition(bond_type))
    if(location>0) then
      motif_len=len(bond_list_definition(bond_type))
    else
      write(bond_type_text, '("-",I0,"-")') bond_type
      location=index(text, bond_type_text)
      motif_len=len_trim(bond_type_text)
    end if
    
    i=1
    left=''
    do while(text(location-i:location-i)/=' ')
      if(i>3) then
        exit
      end if
      left(3-i+1:3-i+1)=text(location-i:location-i)
      i=i+1
    end do
    left=adjustl(left)
    
    i=1
    right=''
    do while(text(location+motif_len+i-1:location+motif_len+i-1)/=' ')
      if(i>3) then
        exit
      end if
      right(i:i)=text(location+motif_len+i-1:location+motif_len+i-1)
      i=i+1
    end do    
  
  
    if(left/='' .and. right/='') then
      ! all good to look for pairs
      call atoms%init()
      atoms(1)%label=left
      atoms(2)%label=right      
      call get_pairs(atoms, pairs, bond_type)
      if(size(pairs)==0) then
        ! no pairs, remove the bond place holder
        text=text(1:location-len_trim(left)-1)//text(location+motif_len+len_trim(right):)
        cycle
      end if
      
      replacement=''
      do i=1, ubound(pairs,2)
        write(buffer, '(A,"(",I0,") TO ",A,"(",I0,")")') &
        & trim(pairs(1,i)%label), pairs(1,i)%serial, &
        & trim(pairs(2,i)%label), pairs(2,i)%serial
        replacement=trim(replacement)//' '//trim(buffer)//','
      end do
      replacement(len_trim(replacement):len_trim(replacement))=' '

      i=location-len_trim(left)
      j=location+motif_len+len_trim(right)-1
      
      text=text(1:i-1)//trim(replacement)//trim(text(j+1:))
    end if
  end do
end subroutine

!> define a variable for later use using the DEFINE `restraint`
subroutine define_variable(image_text, ierror)
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
implicit none
character(len=*), intent(inout) :: image_text
integer, intent(out) :: ierror
integer eq
character(len=64) :: var_name
integer i

  ierror = 0

  ! process local variable definition
  if(image_text(1:6)=='DEFINE') then 
    eq = index(image_text, '=')
    var_name = trim(adjustl(image_text(7:eq-1)))
    do i=1, len_trim(var_name)
      if(iachar(var_name(i:i))<65 .or. iachar(var_name(i:i))>90) then
        write(cmon, '(A,A)') '{E ', trim(image_text) 
        CALL XPRVDU(NCVDU,1,0)
        write(cmon, '(A,A,A)') '{E ', repeat('-', 6+i), '^'
        CALL XPRVDU(NCVDU,1,0)
        write(cmon, '(A,A,A)') '{E Error: Invalid variable name, character `', &
        & var_name(i:i), '` not allowed'
        CALL XPRVDU(NCVDU,1,0)
        ierror = -1
        return
      end if
    end do
    restraints_var_list_index=restraints_var_list_index+1
    restraints_var_list(restraints_var_list_index)%label=trim(adjustl(image_text(7:eq-1)))
    read(image_text(eq+1:), *) restraints_var_list(restraints_var_list_index)%rvalue
  end if
  
end subroutine

!> substitute a variable with its value
subroutine substitue_variable(image_text, ierror)
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
implicit none
character(len=*), intent(inout) :: image_text
integer, intent(out) :: ierror
integer dollar_start, dollar_end
character(len=64) :: var_name
integer i
logical found

  ierror = 0

  dollar_start = index(image_text, '$')
  do while(dollar_start>0)
    ! capture variable name
    dollar_end=dollar_start+1
    do while(image_text(dollar_end:dollar_end)/=' ')
      dollar_end=dollar_end+1
    end do
    var_name=trim(image_text(dollar_start+1:dollar_end))

    ! look for its value in the table
    found = .false.
    do  i=1, restraints_var_list_index
      if(restraints_var_list(i)%label == var_name) then
        write(var_name, '(F0.6)') restraints_var_list(i)%rvalue
        image_text=image_text(1:dollar_start-1)//' '// &
        & trim(var_name)//' '//trim(image_text(dollar_end+1:))
        found = .true.
      end if
    end do
    if(found) then
      dollar_start = index(image_text, '$')
    else
      write(cmon, '(A,A)') '{E ', trim(image_text) 
      CALL XPRVDU(NCVDU,1,0)
      write(cmon, '(A,A,A)') '{E ', repeat('-', dollar_start-1), &
      & repeat('^', len_trim(var_name)+1)
      CALL XPRVDU(NCVDU,1,0)
      write(cmon, '(A,A,A)') '{E Error: Definition of variable `$', &
      & trim(var_name), '` is missing'
      call xprvdu(ncvdu,1,0)   
      ierror = -1
      return
    end if
  end do
end subroutine

!> expand generic atoms name. only C(*) == all C is implemented
subroutine expand_atoms_names(image_text, ierror)
use store_mod, only: store
use xlst05_mod, only: l5, md5, n5 !< atomic model
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
implicit none
character(len=*), intent(inout) :: image_text
integer, intent(out) :: ierror
character(len=10), dimension(:), allocatable :: elements
integer m5
character(len=16) :: atom_name
integer pattern_start
integer i, j
character(len=64) :: var_name

  ierror = 0

  ! expand atoms type
  if(index(image_text, '(*)')>0) then
    call explode(image_text, 10, elements)
    image_text=''
    do i=1, size(elements)
      pattern_start = index(elements(i), '(*)')
      ! capture atom type
      if(pattern_start>0) then
        var_name=elements(i)(1:pattern_start-1)

        if(i<size(elements)) then
          if(trim(elements(i+1))=='TO') then
            ! need to be done in pairs
            write(cmon, '(A,A)') '{E ', trim(image_text)//' '//elements(i)//' '// &
            & elements(i+1) 
            CALL XPRVDU(NCVDU,1,0)
            write(cmon, '(A,A,A)') '{E Error: Generic pairs are not implemented'
            CALL XPRVDU(NCVDU,1,0)
            image_text=trim(image_text)//' '//elements(i)
            ierror = -1
            return
          end if
        end if

        ! look for all atoms with same type
        if(n5>0) then
          m5 = l5
          do j = 1, n5
            if(transfer(store(m5), '    ')==var_name) then
              write(atom_name, '(A,"(",I0,")")') trim(transfer(store(m5), '    ')), &
              & nint(store(m5+1))
              image_text=trim(image_text)//' '//trim(atom_name)
            end if
            m5 = m5 + md5
          end do
        end if
      else
        image_text=trim(image_text)//' '//elements(i)
      end if
    end do
    image_text=adjustl(image_text)
  end if
end subroutine

!> expand XCHIV restraints. look for the 3 neighbours.
subroutine expand_xchiv(image_text, ierror)
use store_mod, only: istore=>i_store, store, c_store, i_store_set
use xlst41_mod, only: l41b, m41b, md41b, n41b !< Connectivity
use xlst05_mod, only: l5, md5, n5 !< atomic model
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
implicit none
character(len=*), intent(inout) :: image_text
integer , intent(out) :: ierror
character(len=10), dimension(:), allocatable :: elements
integer neighbour_address, neighbour_cpt
integer, dimension(6) :: xchiv_neighbours
integer lp, rp, i
character(len=3) :: label
integer serial
character(len=128) :: ctemp
integer ia1, ia2, j

  ierror = 0

  if(restraints_list(restraints_list_index)%type=='XCHIV') then       ! Expand xchiv        

    if(image_text(1:4)=='CONT') then      
      ierror = -1
      write(cmon, '(A,A)') '{E ', trim(image_text) 
      CALL XPRVDU(NCVDU,1,0)
      write(cmon, '(A)') '{E Error: XCHIV Restraint cannot be split over multiple lines'
      call xprvdu(ncvdu,1,0)
      return
    end if
    
    ! split atom list
    call explode(image_text, 10, elements)

    image_text = trim(elements(1))
    do i=2, size(elements)
      lp = index(elements(i), '(')
      rp = index(elements(i), ')')
      if(lp>0 .and. rp>0) then
        ! explicit neighbours
        associate(el => elements(i)) 
          label = el(1:lp-1)
          read(el(lp+1:rp-1), *) serial  
        end associate
        neighbour_cpt=0
        xchiv_neighbours=0
        DO M41B = L41B, L41B + (N41B-1)*MD41B, MD41B
          IA1 = L5 + ISTORE(M41B)*MD5
          IA2 = L5 + ISTORE(M41B+6)*MD5

          neighbour_address=-1
          if( trim(label)==trim(c_store(IA1)) .and. serial==NINT(STORE(IA1+1)) ) then
            if(trim(c_store(IA2))/='H') then
              neighbour_address=IA2 
            end if
          else if( trim(label)==trim(c_store(IA2)) .and.  serial==NINT(STORE(IA2+1)) ) then
            if(trim(c_store(IA1))/='H') then
              neighbour_address=ia1
            end if
          end if

          if(neighbour_address>0) then
            neighbour_cpt=neighbour_cpt+1
            if(neighbour_cpt>6) then
              exit
            end if
            xchiv_neighbours(neighbour_cpt)=neighbour_address
          end if
        end do

        if(neighbour_cpt==3) then ! xchiv requires exactly 3 neighbours
          image_text=trim(image_text)//' '//trim(elements(i))
          do j=1, 3
            write(ctemp, '(A,"(",I0,")")') trim(c_store(xchiv_neighbours(j))), &
            & nint(store(xchiv_neighbours(j)+1))
            image_text=trim(image_text)//' '//ctemp
          end do
        else
          write(cmon, '(A,A)') '{E ', trim(image_text) 
          CALL XPRVDU(NCVDU,1,0)
          write(cmon, '(A,A)') '{E Error: XCHIV needs exactly 3 non hydrogen neigbours for ', trim(elements(i))
          call xprvdu(ncvdu,1,0)        
          do j=1, min(neighbour_cpt, size(xchiv_neighbours))
            write(cmon, '(A,"(",I0,")")') trim(c_store(xchiv_neighbours(j))), &
            & nint(store(xchiv_neighbours(j)+1))
            call xprvdu(ncvdu,1,0)        
          end do
          ierror = -1
          return
        end if
      else
        image_text=trim(image_text)//' '//trim(elements(i))
      end if
    end do
  end if ! expand xchiv
end subroutine

subroutine expand_rigu(image_text, ierror)  
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
implicit none
character(len=*), intent(inout) :: image_text
integer, intent(out) :: ierror !< error code 0==success
character(len=10), dimension(:), allocatable :: elements
integer start, i, j
type(atom_t), dimension(:), allocatable :: atoms
character(len=64) :: buffer
integer, dimension(:,:), allocatable :: connectivity_13
type(atom_t), dimension(:,:), allocatable :: pairs
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
real esd13

  ierror = 0

  if(restraints_list(restraints_list_index)%type=='XRIGU') then      
  
    if(image_text(1:4)=='CONT') then      
      ierror = -1
      write(cmon, '(A,A)') '{E ', trim(image_text) 
      CALL XPRVDU(NCVDU,1,0)
      write(cmon, '(A)') '{E Error: XRIGU Restraint cannot be split over multiple lines'
      call xprvdu(ncvdu,1,0)
      return
    end if
  
    ! split atom list
    call explode(image_text, 10, elements)
    
    ! elements(1) is XRIGU
    image_text='URIGU'
    start=1
    found=.false.
    do i=1, len_trim(elements(2))
      do j=1, size(numbers)
        if(elements(2)(i:i)==numbers(j)) then
          found=.true.
          exit
        end if
      end do
      if(.not. found) exit
    end do
    if(found) then
      start=start+1
      image_text=trim(image_text)//' '//elements(2)
    else
      image_text=trim(image_text)//' 0.004'
    end if
    found=.false.
    do i=1, len_trim(elements(3))
      do j=1, size(numbers)
        if(elements(3)(i:i)==numbers(j)) then
          found=.true.
          exit
        end if
      end do
      if(.not. found) exit
    end do
    if(found) then
      start=start+1
      image_text=trim(image_text)//' '//elements(3)
      read(elements(3),*) esd13
    else
      image_text=trim(image_text)//' 0.004'
    end if
    
    allocate(atoms(size(elements)-start))
    call atoms%init()
    do i=start+1, size(elements)
      atoms(i-start)=read_atom(trim(elements(i)))
    end do
    call get_pairs(atoms, pairs)
    
    ! write the number of 1,2 distances pairs
    write(buffer, '(I0)') ubound(pairs, 2)
    image_text=trim(image_text)//' '//trim(buffer)
    
    do i=1, ubound(pairs, 2)
      write(buffer, '(A,"(",I0,") TO ", A, "(",I0,")")') &
      & trim(pairs(1,i)%label), pairs(1,i)%serial, &
      & trim(pairs(2,i)%label), pairs(2,i)%serial
      image_text=trim(image_text)//' '//trim(buffer)//','
    end do
    image_text(len_trim(image_text):len_trim(image_text))=' '
    
    if(abs(esd13)>1e-6) then
      call get_connectivity_13(connectivity_13)    
      call get_pairs_13(atoms, connectivity_13, pairs)

      if(ubound(pairs, 2)>0) then
        image_text=trim(image_text)//','
      end if
      do i=1, ubound(pairs, 2)
        write(buffer, '(A,"(",I0,") TO ", A, "(",I0,")")') &
        & trim(pairs(1,i)%label), pairs(1,i)%serial, &
        & trim(pairs(2,i)%label), pairs(2,i)%serial
        image_text=trim(image_text)//' '//trim(buffer)//','
      end do
      if(ubound(pairs, 2)>0) then
        image_text(len_trim(image_text):len_trim(image_text))=' '
      end if
    end if
  end if
  !print *, trim(image_text)
    
end subroutine

function read_atom(text) result(atom)
implicit none
character(len=*), intent(in) :: text
type(atom_t) :: atom
integer i, j

  i=index(text,'(')
  j=index(text,')')
  
  if(i>0 .and. j>0) then
    atom%label=text(1:i-1)
    read(text(i+1:j-1), *) atom%serial
  else
    atom%label=text
  end if

end function

end module
