module xlexical_mod

type atom_t
  character(len=5) :: label !< atomic type
  integer :: serial !< serial number
  character(len=24) :: sym_op !< symmetry operator
  integer :: ref !< a ref number used when building pairs
  integer :: bond !< type of bond when used in pairs
contains
  procedure :: init => init_atom 
  procedure :: text => atom_text
end type

private init_atom, atom_text

contains

subroutine lexical_preprocessing(image_text)
use xlst41_mod, only: l41b, m41b, md41b, n41b !< Connectivity
use xlst05_mod, only: l5, md5, n5 !< atomic model
use xiobuf_mod, only: cmon !< I/O units
use xunits_mod, only: ncvdu !< I/O units
use store_mod, only: istore=>i_store, store, c_store, i_store_set
implicit none

  character(len=*) :: image_text
  character(len=128) :: ctemp
  character(len=10), dimension(:), allocatable :: elements

  integer neighbour_address, neighbour_cpt
  integer, dimension(3) :: xchiv_neighbours
  integer lp, rp, i
  character(len=3) :: label
  integer serial
  
  ! variable substitution
  type variable_t
    character(len=64) :: label
    real :: rvalue
  end type
  type(variable_t), dimension(256) :: restraints_var_list
  integer :: restraints_var_list_index = 0
  integer dollar_start, dollar_end, eq
  character(len=64) :: var_name
  logical invalid
  
  ! atoms pairs
  type(atom_t), dimension(:), allocatable :: atoms
  type(atom_t), dimension(:,:), allocatable :: pairs

  
  integer m5
  character(len=16) :: atom_name
  integer itemp
  
  integer ia1, ia2, icpt, j

!c        allocate(atoms(2))
!c        atoms(1)%label='C'
!c        atoms(1)%serial=-1
!c        atoms(1)%sym_op=''
!c        atoms(2)%label='C'
!c        atoms(2)%serial=-1
!c        atoms(2)%sym_op=''
!c        call get_pairs(atoms, pairs)
!c        do icpt=1, ubound(pairs, 2)
!c          print *, pairs(1,icpt)%text(), ' ', 
!c     1      pairs(1,icpt)%bond, ' ', pairs(2,icpt)%text()
!c        !print *, pairs
!c        end do
        
  ! process local variable definition
  if(image_text(1:6)=='DEFINE') then 
    eq = index(image_text, '=')
    var_name = trim(adjustl(image_text(7:eq-1)))
    invalid=.false.
    do icpt=1, len_trim(var_name)
      if(iachar(var_name(icpt:icpt))<65 .or. iachar(var_name(icpt:icpt))>90) then
        invalid=.true.
        write(cmon, '(A,A)') '{E ', trim(image_text) 
        CALL XPRVDU(NCVDU,1,0)
        write(cmon, '(A,A,A)') '{E ', repeat(' ', 6+icpt), '^'
        CALL XPRVDU(NCVDU,1,0)
        write(cmon, '(A,A,A)') '{E Error: Invalid variable name, character `', &
        & var_name(icpt:icpt), '` not allowed'
        CALL XPRVDU(NCVDU,1,0)
      end if
    end do
    if(.not. invalid) then
      restraints_var_list_index=restraints_var_list_index+1
      restraints_var_list(restraints_var_list_index)%label=trim(adjustl(image_text(7:eq-1)))
      read(image_text(eq+1:), *) restraints_var_list(restraints_var_list_index)%rvalue
    else
      image_text='REM '//trim(image_text)
    end if
  end if

  ! substitute variable with its value
  ! 
  dollar_start = index(image_text, '$')
  do while(dollar_start>0)
    ! capture variable name
    dollar_end=dollar_start+1
    do while(image_text(dollar_end:dollar_end)/=' ')
      dollar_end=dollar_end+1
    end do
    var_name=trim(image_text(dollar_start+1:dollar_end))

    ! look for its value in the table
    do  i=1, restraints_var_list_index
      if(restraints_var_list(i)%label == var_name) then
        write(var_name, '(F0.6)') restraints_var_list(i)%rvalue
        image_text=image_text(1:dollar_start-1)//' '// &
        & trim(var_name)//' '//trim(image_text(dollar_end+1:))
      end if
    end do
    dollar_start = index(image_text, '$')
  end do

  ! expand atoms type
  if(index(image_text, '(*)')>0) then
    call explode(image_text, 10, elements)
    image_text=''
    do i=1, size(elements)
      dollar_start = index(elements(i), '(*)')
      ! capture atom type
      if(dollar_start>0) then
        var_name=elements(i)(1:dollar_start-1)

        if(i<size(elements)) then
          if(trim(elements(i+1))=='TO') then
            ! need to be done in pairs
            write(cmon, '(A,A)') '{E ', trim(image_text)//' '//elements(i)//' '// &
            & elements(i+1) 
            CALL XPRVDU(NCVDU,1,0)
            write(cmon, '(A,A,A)') '{E Error: Generic pairs are not implemented'
            CALL XPRVDU(NCVDU,1,0)
            image_text=trim(image_text)//' '//elements(i)
            cycle
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
    print *, trim(image_text)
  end if

  if(image_text(1:5)=='XCHIV') then       ! Expand xchiv        
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

  !c                print *, label, serial, 
  !c     1            trim(c_store(IA1)), NINT(STORE(IA1+1)),
  !c     1            trim(c_store(IA2)), NINT(STORE(IA2+1))
          if( trim(label)==trim(c_store(IA1)) .and. serial==NINT(STORE(IA1+1)) ) then
            if(trim(c_store(IA1))/='H') then
              neighbour_address=IA2 
            end if
          else if( trim(label)==trim(c_store(IA2)) .and.  serial==NINT(STORE(IA2+1)) ) then
            if(trim(c_store(IA2))/='H') then
              neighbour_address=ia1
            end if
          else
            neighbour_address=-1
          end if

          if(neighbour_address>0) then
            neighbour_cpt=neighbour_cpt+1
            if(neighbour_cpt>3) then
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
        end if
      else
        image_text=trim(image_text)//' '//trim(elements(i))
      end if
    end do
  end if ! expand xchiv



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
  character(len=lenstring) :: bufferlabel
  integer i, j, k, start
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
    
end subroutine

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
subroutine get_pairs(atoms, pairs)
! we assume list 5 and 41 already loaded
use xlst05_mod, only: l5, md5
use xlst41_mod, only: m41b, l41b, n41b, md41b
use store_mod, only: istore => i_store, c_store, store
implicit none
type(atom_t), dimension(:), intent(in) :: atoms
type(atom_t), dimension(:,:), allocatable, intent(out) :: pairs
!integer, intent(in), optional :: distance
integer i, ia1, ia2
type(atom_t) :: left, right
type(atom_t), dimension(:,:), allocatable :: pairs_temp
integer pair_index

  allocate(pairs_temp(2, 128))
  call pairs_temp%init()
  pair_index=0
  
  do m41b = l41b, l41b + (n41b-1)*md41b, md41b
    ia1 = l5 + istore(m41b)*md5
    ia2 = l5 + istore(m41b+6)*md5

    call left%init()
    call right%init()
    print *, 'new bond'
    do i=1, size(atoms) 
      print *, atoms(i)%label, trim(c_store(ia1)), trim(c_store(ia2))
      if(trim(atoms(i)%label)==trim(c_store(ia1))) then
        if(atoms(i)%serial==-1) then
          ! found one side
          if(right%ref/=i) then
            left%label=c_store(ia1)
            left%serial=nint(store(ia1+1))
            left%ref=i
            left%bond=istore(m41b+12)
            print *, left
            !left%sym_op= ! to do
          end if
        end if
      end if

      if(trim(atoms(i)%label)==trim(c_store(ia2))) then
        print *, 'h'
        if(atoms(i)%serial==-1) then
          ! found the other side
          print *, 'i', left%ref, i
          if(left%ref/=i) then
            print *, 'j'
            right%label=c_store(ia2)
            right%serial=nint(store(ia2+1))
            right%ref=i
            left%bond=istore(m41b+12)
            !right%sym_op= ! to do
          end if
        end if
      end if
      print *, i, left%text(), ' ', right%text()
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

elemental subroutine init_atom(self)
implicit none
class(atom_t), intent(inout) :: self
  self%label = ''
  self%serial = -1
  self%sym_op = ''
  self%ref = -1
end subroutine

function atom_text(self)
implicit none
class(atom_t), intent(inout) :: self
character(len=:), allocatable ::atom_text
character(len=256) :: buffer

  write(buffer, '(A,"(",I0,")")') trim(self%label), self%serial
  atom_text=trim(buffer)
end function

end module
