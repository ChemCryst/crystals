!> Module for the lexical analyzer
module lexical_mod
  implicit none
  private ! make everything private by default

  integer, parameter :: split_len = 64 !< length of element when splitting strings

  !> type holding information during preprocssing
  type lexical_t
    character(len=5) :: type !< type of restraint
    character(len=:), allocatable :: original !< original text
    character(len=:), allocatable :: processed !< pre-processed text
  end type
  !> Storage of the list of restraints before after pre-processing
  type(lexical_t), dimension(:), allocatable :: lexical_list
  integer :: lexical_list_index = 0 !< index in lexical_list
  public lexical_list, lexical_list_index

  ! The backslash character causes problem in doxygen, using the following workaround instead
  character(len=2), parameter :: qmark = char(63)//char(63) !< the ?? string
  ! The ampersand is causing ifort to crash
  character(len=2), parameter :: amps = char(38)//char(38) !< the && string
  !> List of crystals bond definition
  !! -  10 = any type
  !! -   1 = single  2= double  3=triple  4=quadruple
  !! -   5 = aromatic      6 = polymeric single
  !! -   7 = delocalised   8 = strange    9 = pi-bond
  character(len=2), dimension(10), parameter :: bond_list_definition = &
  & (/'--', '==', '-=', '##', '@@', amps, '~~', '**', '::', qmark/)

  !> Symmetry operator as defined in crystals
  type sym_op_t
    integer S !< S specifies a symmetry operator provided in LIST 2. 'S' may take any value between '-NSYM' and '+NSYM', except zero, where 'NSYM' is the number of symmetry equivalent positions provided in LIST 2
    integer L !< L specifies the non-primitive lattice translation that is to be added after the coordinates have been modified by the operations given by 'S'.
    real, dimension(3) :: translation !< translation part
  end type

  !> Symmetry operator in matrix notation
  type sym_mat_t
    real, dimension(3, 3) :: R !< rotation matrix
    real, dimension(3) :: T !< Translation
  end type

  !> general atom type
  type atom_t
    integer :: l5addr !< address in list 5 in store
    character(len=5) :: label !< atomic type
    integer :: serial !< serial number
    type(sym_op_t) :: sym_op !< symmetry operator
    type(sym_mat_t) :: sym_mat !< symmetry operator in matrix form
    integer :: ref !< a ref number used when building pairs
    integer :: bond !< type of bond when used in pairs
    integer :: part !< part number
    integer :: resi !< residue number
  contains
    procedure :: init => init_atom !< initialise object
    procedure :: text => atom_text !< pretty print
    procedure :: sym_mat_update => atom_update_sym_mat !< update matrix notation using crystals notation (sym_op)
    procedure, private :: atom_compare !< overload equivalence to compare atom type object
    generic :: operator(==) => atom_compare !< overload ==
    generic :: operator(/=) => atom_compare !< overload /=
    generic :: operator( .eqv. ) => atom_compare !< overload .eqv.
    generic :: operator( .neqv. ) => atom_compare !< overload .neqv.
  end type

  !> variable name and its value
  type variable_t
    character(len=64) :: label !< name of variable
    real :: rvalue !< value
  end type
  !> Hold the list of variables for substitution
  !! definition: `define a = 0.01`
  !! usage: `dist 0.0, $a = mean ...`
  type(variable_t), dimension(256) :: lexical_var_list
  integer :: lexical_var_list_index = 0 !< max index in lexical_var_list

  logical :: list16_modified = .false. !< flag to notify a modification of the input
  logical :: initialised = .false. !< flag to indicate the state of the module

  integer savedl5, savedn5, savedmd5
  integer savedl41b, savedmd41b, savedn41b

  public lexical_preprocessing, lexical_list_init, lexical_print_changes

contains

  !> Initialise restraints
  subroutine lexical_list_init()
    use lists2_mod, only: xldlst
    use store_mod, only: store
    use xlisti_mod, only: l0, m0, n0, md0 !< core list variables
    implicit none
    integer, parameter :: idim05 = 40
    integer, dimension(idim05) :: icom05
    integer, parameter :: idim41 = 16
    integer, dimension(idim41) :: icom41
    integer n0old

    integer, external :: kexist

    initialised = .true.

    if (allocated(lexical_list)) then
      deallocate (lexical_list)
      lexical_list_index = 0
    end if
    lexical_var_list_index = 0
    list16_modified = .false.

    if (kexist(41) .gt. 0 .and. kexist(5) .gt. 0) then
      ! load list 5 and 41 and save their adresses
      ! Their existence from other subroutines is wiped out to avoid side effects
      n0old = n0
      call xldlst(5, icom05, idim05, 0)

      ! removing record in chain list
      if (n0old /= n0) then
        ! a new record has been added
        if (n0 > 1) then
          n0 = n0-1
        else
          n0 = 0
          l0 = -1000000
          m0 = -1000000
        end if
      end if

      ! saving list 5 address
      savedl5 = icom05(1)
      savedn5 = icom05(4)
      savedmd5 = icom05(3)

      n0old = n0
      call xldlst(41, icom41, idim41, 0)

      ! removing record in chain list
      if (n0old /= n0) then
        ! a new record has been added
        if (n0 > 1) then
          n0 = n0-1
        else
          n0 = 0
          l0 = -1000000
          m0 = -1000000
        end if
      end if

      ! saving list 41 addresses
      savedl41b = icom41(1)
      savedmd41b = icom41(3)
      savedn41b = icom41(4)
    else
      savedl5 = 0
      savedn5 = 0
      savedmd5 = 0
      savedl41b = 0
      savedmd41b = 0
      savedn41b = 0
    end if
  end subroutine

  !> Preprocess a restraint with various substitutions
  subroutine lexical_preprocessing(image_text, ierror)
    implicit none
    character(len=*) :: image_text !< text of the restraint (one line)
    integer, intent(out) :: ierror !< error code 0==success
    integer i
    type(lexical_t), dimension(:), allocatable :: lexical_temp
    logical change, changesub

    ierror = 0
    change = .false.

    if (.not. initialised) then
      ierror = -1
      call print_to_mon('{E Error: Lexical helper not initialised')
      return
    end if

    ! update index and allocate/etend storage if necessary
    lexical_list_index = lexical_list_index+1
    if (.not. allocated(lexical_list)) then
      allocate (lexical_list(128))
    end if
    if (lexical_list_index > size(lexical_list)) then
      call move_alloc(lexical_list, lexical_temp)
      allocate (lexical_list(size(lexical_temp)+128))
      lexical_list(1:size(lexical_temp)) = lexical_temp
    end if

    ! save type of restraint, check for cont and look for parent restraint for the type
    allocate (character(len=len_trim(image_text)) :: &
    & lexical_list(lexical_list_index)%original)
    lexical_list(lexical_list_index)%original = trim(image_text)
    lexical_list(lexical_list_index)%type = ''
    do i = lexical_list_index, 1, -1
      if (len_trim(lexical_list(i)%original) > 4) then
        if (lexical_list(i)%original(1:4) == 'CONT') then
          cycle
        else
          lexical_list(lexical_list_index)%type = lexical_list(i)%original(1:5)
          exit
        end if
      end if
    end do
    if (lexical_list(lexical_list_index)%type == '') then
      lexical_list(lexical_list_index)%type = lexical_list(lexical_list_index)%original
    end if

    if (image_text(1:4) == 'REM ') then
      ! ignore comments
      associate (restraint=>lexical_list(lexical_list_index))
        allocate (character(len=len_trim(image_text)) :: restraint%processed)
        restraint%processed = trim(image_text)
      end associate
      return
    end if

    ! insert missing spaces around operators
    call fixed_spacing(image_text)

    ! check atoms
    call check_atom(image_text, ierror)
    if (ierror /= 0) return

    ! Look for variable definition: define a = 0.01
    call define_variable(image_text, ierror)
    if (ierror /= 0) return

    ! replace variable names with their definition: $a
    call substitue_variable(image_text, ierror, changesub)
    if (ierror /= 0) return
    change = change .or. changesub

    ! look for bonds definitions: C--H, ...
    call replace_bonds(image_text, changesub)
    change = change .or. changesub

    ! expand atom names: C(*), ...
    call expand_atoms_names(image_text, ierror, changesub)
    change = change .or. changesub

    ! expand xchiv restraint
    call expand_xchiv(image_text, ierror, changesub)
    change = change .or. changesub

    ! expand rigu restraint
    call expand_rigu(image_text, ierror, changesub)
    change = change .or. changesub

    associate (restraint=>lexical_list(lexical_list_index))
      allocate (character(len=len_trim(image_text)) :: restraint%processed)
      restraint%processed = trim(image_text)

      if (change) then
        list16_modified = .true.
        call print_to_mon('{I --- '//trim(restraint%original), wrap_arg=.true.)
        call print_to_mon('{I +++ '//trim(restraint%processed), wrap_arg=.true.)
      else
        ! no changes, restore original in case the formatting has been changed
        restraint%processed = restraint%original
      end if
    end associate
    
  end subroutine

  !> Split a string into different pieces given a separator. Defaul separator is space.
  !! - Len of pieces must be passed to the function
  !! - separator inside parenthesis are allowed
  subroutine explode(line, lenstring, elements, sep_arg, fieldpos, greedy_arg)
    implicit none
    character(len=*), intent(in) :: line !< text to process
    integer, intent(in) :: lenstring !< length of each individual elements
    character, intent(in), optional :: sep_arg !< Separator
    integer, dimension(:), allocatable, intent(out), optional :: fieldpos !< index of each field in the original string
    logical, intent(in), optional :: greedy_arg !< do not merge consecutive separators if false
    character(len=lenstring), dimension(:), allocatable, intent(out) :: elements
    character(len=lenstring), dimension(:), allocatable :: temp
    integer, dimension(:), allocatable :: fieldpostemp
    character(len=lenstring) :: bufferlabel
    integer i, j, k, n, start, maxel, bufferpos
    character sep
    logical greedy

    if (present(sep_arg)) then
      sep = sep_arg
    else
      sep = ' '
    end if

    if (present(greedy_arg)) then
      greedy = greedy_arg
    else
      greedy = .true.
    end if

    n = count_char(trim(line), sep, greedy)
    allocate (elements(n+1))
    if (present(fieldpos)) then
      allocate (fieldpos(n+1))
    end if

    start = 1
    if (greedy) then
      do while (line(start:start) == sep)
        start = start+1
      end do
    end if

    k = 1
    j = 0
    bufferlabel = ''
    elements = ''
    bufferpos = 0
    do i = start, len_trim(line)
      if (line(i:i) == sep) then
        if (greedy .and. i > 1) then
          if (line(i-1:i-1) == sep) then
            cycle
          end if
        end if
        elements(k) = bufferlabel
        if (present(fieldpos)) then
          fieldpos(k) = bufferpos
        end if
        k = k+1
        j = 0
        bufferlabel = ''
        cycle
      end if
      j = j+1
      if (j > lenstring) then
        call print_to_mon('{E Programming error: len too short for elements in explode (lexical_helper.F90)')
        cycle
      end if
      if (j == 1) then
        bufferpos = i
      end if
      bufferlabel(j:j) = line(i:i)
    end do
    if (j > 0 .and. trim(bufferlabel) /= '') then
      elements(k) = bufferlabel
      if (present(fieldpos)) then
        fieldpos(k) = bufferpos
      end if
    end if

    ! check for parenthesis, separator is allowed inside them
    maxel = size(elements)
    i = 1
    do
      if (i > maxel) exit
      n = 0
      do j = 1, len_trim(elements(i))
        if (elements(i) (j:j) == '(') then
          n = n+1
        else if (elements(i) (j:j) == ')') then
          n = n-1
        end if
      end do
      if (n /= 0 .and. i < size(elements)) then
        ! found unbalanced parenthesis, merging next field
        maxel = maxel-1
        elements(i) = trim(elements(i))//trim(elements(i+1))
        elements(i+1:maxel) = elements(i+2:maxel+1)
        if (present(fieldpos)) then
          fieldpos(i+1:maxel) = fieldpos(i+2:maxel+1)
        end if
        cycle
      end if
      i = i+1
    end do
    if (maxel < size(elements)) then
      call move_alloc(elements, temp)
      allocate (elements(maxel))
      elements = temp(1:maxel)
      if (present(fieldpos)) then
        call move_alloc(fieldpos, fieldpostemp)
        allocate (fieldpos(maxel))
        fieldpos = fieldpostemp(1:maxel)
      end if
    end if
  end subroutine

  !> count the number of a character, option to count consecutive ones as one.
  !! if greedy is set, separators at begining of line are ignored
  function count_char(line, c, greedy) result(cpt)
    implicit none
    character(len=*), intent(in) :: line !< text to process
    character, intent(in) :: c !< character to search
    logical, intent(in) :: greedy
    integer cpt !< Number of character found
    integer i, start

    cpt = 0

    if (greedy) then
      i = 1
      do while (line(i:i) == c)
        i = i+1
      end do
      start = i
    else
      start = 1
    end if

    do i = start, len_trim(line)
      if (line(i:i) == c) then
        if (greedy) then
          if (i > 1) then
            if (line(i-1:i-1) /= c) then
              cpt = cpt+1
            end if
          end if
        else
          cpt = cpt+1
        end if
      end if
    end do

  end function

  !> Get get pairs of atoms using the connectivity list
  subroutine get_pairs(atoms, pairs, bond_type)
    ! we assume list 5 and 41 already loaded
    use xlst41_mod, only: l41b, n41b, md41b !< connectivity list
    use store_mod, only: istore => i_store, c_store, store
    implicit none
    type(atom_t), dimension(:), intent(in) :: atoms !< list of atoms to use
    type(atom_t), dimension(:, :), allocatable, intent(out) :: pairs !< pairs of atoms found
    integer, intent(in), optional :: bond_type !< optional bond type to look for
    integer i
    type(atom_t) :: left, right
    type(atom_t), dimension(:, :), allocatable :: pairs_temp
    type(atom_t), dimension(2) :: bond_atoms
    integer pair_index, m41b

    allocate (pairs_temp(2, 128))
    call pairs_temp%init()
    pair_index = 0

    if (md41b == 0) then
      ! no bonds
      allocate (pairs(0, 0))
      return
    end if

    do m41b = l41b, l41b+(n41b-1)*md41b, md41b
      bond_atoms = load_atom_from_l41(m41b)
      call left%init()
      call right%init()

      do i = 1, size(atoms)
        if (trim(atoms(i)%label) == trim(bond_atoms(1)%label)) then
          if (atoms(i)%serial == -1) then
            ! found one side
            if (left%serial == -1 .and. right%ref /= i) then
              ! left has not been assigned yet atom(i) is not used in right
              left = bond_atoms(1)
              left%ref = i
            end if
          else
            if (atoms(i) == bond_atoms(1)) then
              ! left has not been assigned yet atom(i) is not used in right
              left = bond_atoms(1)
              left%ref = i
            end if
          end if
        end if

        if (trim(atoms(i)%label) == trim(bond_atoms(2)%label)) then
          if (atoms(i)%serial == -1) then
            ! found the other side
            if (right%serial == -1 .and. left%ref /= i) then
              ! right has not been assigned yet atom(i) is not used in left
              right = bond_atoms(2)
              right%ref = i
            end if
          else
            if (atoms(i) == bond_atoms(2)) then
              ! right has not been assigned yet atom(i) is not used in left
              right = bond_atoms(2)
              right%ref = i
            end if
          end if
        end if
      end do

      if (left%ref /= -1 .and. right%ref /= -1) then
        if (present(bond_type)) then
          if (bond_type /= size(bond_list_definition)) then ! last bond type is any type
            if (bond_type /= left%bond .or. bond_type /= right%bond) then
              ! incorrect bond type, ignoring...
              cycle
            end if
          end if
        end if

        pair_index = pair_index+1
        if (pair_index > ubound(pairs_temp, 2)) then
          call move_alloc(pairs_temp, pairs)
          allocate (pairs_temp(2, size(pairs)))
          call pairs_temp%init()
          pairs_temp(:, 1:ubound(pairs, 2)) = pairs
        end if
        pairs_temp(1, pair_index) = left
        pairs_temp(2, pair_index) = right
      end if
    end do

    allocate (pairs(2, pair_index))
    pairs = pairs_temp(:, 1:pair_index)

  end subroutine

  !> Get get 1,3 pairs of atoms using the precomputed 1,3 connectivity with get_connectivity_13
  subroutine get_pairs_13(atoms, connectivity_13, pairs)
    ! we assume list 5 and 41 already loaded
    use xlst41_mod, only: l41b, n41b, md41b !< connectivity list
    use store_mod, only: istore => i_store, c_store, store
    implicit none
    type(atom_t), dimension(:), intent(in) :: atoms !< list of atoms to use
    type(atom_t), dimension(:, :), intent(in) :: connectivity_13 !< 1,3 connectivity as calculated by get_connectivity_13
    type(atom_t), dimension(:, :), allocatable, intent(out) :: pairs !< pairs of 1,3 atoms found
    integer i, j
    type(atom_t) :: left, right
    type(atom_t), dimension(:, :), allocatable :: pairs_temp
    integer pair_index

    allocate (pairs_temp(2, 128))
    call pairs_temp%init()
    pair_index = 0

    if (size(connectivity_13) == 0) then
      ! no bonds
      allocate (pairs(0, 0))
      return
    end if

    do j = 1, ubound(connectivity_13, 2)

      call left%init()
      call right%init()

      do i = 1, size(atoms)
        !print *, atoms(i)%text()
        if (atoms(i)%label == connectivity_13(1, j)%label) then
          !print *, 'left ', atoms(i)%text()
          if (atoms(i)%serial == -1) then
            ! found one side
            if (left%serial == -1 .and. right%ref /= i) then
              ! left has not been assigned yet atom(i) is not used in right
              ! print *, 'left ', trim(c_store(ia1)), nint(store(ia1+1)), i, left%ref, right%ref
              left = connectivity_13(1, j)
              left%ref = i
            end if
          else if (atoms(i)%serial == connectivity_13(1, j)%serial) then
            ! print *, 'left ', trim(c_store(ia1)), nint(store(ia1+1)), i, left%ref, right%ref
            left = connectivity_13(1, j)
            left%ref = i
          end if
        end if

        if (trim(atoms(i)%label) == connectivity_13(3, j)%label) then
          !print *, 'right ', atoms(i)%text()
          if (atoms(i)%serial == -1) then
            ! found the other side
            if (right%serial == -1 .and. left%ref /= i) then
              ! print *, 'right ', trim(c_store(ia3)), nint(store(ia3+1)), i, left%ref, right%ref
              ! right has not been assigned yet atom(i) is not used in left
              right = connectivity_13(3, j)
              right%ref = i
            end if
          else if (atoms(i)%serial == connectivity_13(3, j)%serial) then
            ! print *, 'right ', trim(c_store(ia3)), nint(store(ia3+1)), i, left%ref, right%ref
            right = connectivity_13(3, j)
            right%ref = i
          end if
        end if
      end do

      if (left%ref /= -1 .and. right%ref /= -1) then
        pair_index = pair_index+1
        if (pair_index > ubound(pairs_temp, 2)) then
          call move_alloc(pairs_temp, pairs)
          allocate (pairs_temp(2, size(pairs)))
          call pairs_temp%init()
          pairs_temp(:, 1:ubound(pairs, 2)) = pairs
        end if
        pairs_temp(1, pair_index) = left
        pairs_temp(2, pair_index) = right
      end if
    end do

    allocate (pairs(2, pair_index))
    pairs = pairs_temp(:, 1:pair_index)

  end subroutine

  !> Get get 1,3 list of atoms using the connectivity list
  subroutine get_connectivity_13(connectivity_13)
    ! we assume list 5 and 41 already loaded
    use xlst41_mod, only: l41b, n41b, md41b !< connectivity list
    use store_mod, only: istore => i_store, c_store, store
    implicit none
    type(atom_t), dimension(:, :), allocatable, intent(out) :: connectivity_13 !< list of 3 atoms vectors forming 1-3 connections
    type(atom_t), dimension(:, :), allocatable :: connectivity_13_temp
    integer m41b_1, m41b_2, connectivity_13_index
    type(atom_t), dimension(2) :: bond1_atoms, bond2_atoms

    if (md41b == 0) then
      ! no bonds
      allocate (connectivity_13(0, 0))
      return
    end if

    allocate (connectivity_13_temp(3, 128))
    connectivity_13_index = 0

    do m41b_1 = l41b, l41b+(n41b-1)*md41b, md41b
      bond1_atoms = load_atom_from_l41(m41b_1)

      do m41b_2 = l41b, l41b+(n41b-1)*md41b, md41b
        if (m41b_2 < m41b_1) then
          cycle
        end if
        bond2_atoms = load_atom_from_l41(m41b_2)

        if (bond1_atoms(1) == bond2_atoms(1) .and. &
        & bond1_atoms(2) /= bond2_atoms(2)) then

          connectivity_13_index = connectivity_13_index+1
          if (connectivity_13_index > ubound(connectivity_13_temp, 2)) then
            call extend_connectivity(connectivity_13_temp)
          end if
          connectivity_13_temp(1, connectivity_13_index) = bond1_atoms(2)
          connectivity_13_temp(2, connectivity_13_index) = bond1_atoms(1)
          connectivity_13_temp(3, connectivity_13_index) = bond2_atoms(2)
          !write(*,*) '1 ', bond1_atoms(2)%text(), bond1_atoms(1)%text(), bond2_atoms(1)%text(), bond2_atoms(2)%text()

        else if (bond1_atoms(2) == bond2_atoms(1) .and. &
        & bond1_atoms(1) /= bond2_atoms(2)) then

          connectivity_13_index = connectivity_13_index+1
          if (connectivity_13_index > ubound(connectivity_13_temp, 2)) then
            call extend_connectivity(connectivity_13_temp)
          end if
          connectivity_13_temp(1, connectivity_13_index) = bond1_atoms(1)
          connectivity_13_temp(2, connectivity_13_index) = bond1_atoms(2)
          connectivity_13_temp(3, connectivity_13_index) = bond2_atoms(2)
          !write(*,*) '2 ', bond1_atoms(1)%text(), bond1_atoms(2)%text(), bond2_atoms(1)%text(), bond2_atoms(2)%text()

        else if (bond1_atoms(1) == bond2_atoms(2) .and. &
        & bond1_atoms(2) /= bond2_atoms(1)) then

          connectivity_13_index = connectivity_13_index+1
          if (connectivity_13_index > ubound(connectivity_13_temp, 2)) then
            call extend_connectivity(connectivity_13_temp)
          end if
          connectivity_13_temp(1, connectivity_13_index) = bond1_atoms(2)
          connectivity_13_temp(2, connectivity_13_index) = bond1_atoms(1)
          connectivity_13_temp(3, connectivity_13_index) = bond2_atoms(1)
          !write(*,*) '3 ', bond1_atoms(2)%text(), bond1_atoms(1)%text(), bond2_atoms(2)%text(), bond2_atoms(1)%text()

        else if (bond1_atoms(2) == bond2_atoms(2) .and. &
        & bond1_atoms(1) /= bond2_atoms(1)) then

          connectivity_13_index = connectivity_13_index+1
          if (connectivity_13_index > ubound(connectivity_13_temp, 2)) then
            call extend_connectivity(connectivity_13_temp)
          end if
          connectivity_13_temp(1, connectivity_13_index) = bond1_atoms(1)
          connectivity_13_temp(2, connectivity_13_index) = bond1_atoms(2)
          connectivity_13_temp(3, connectivity_13_index) = bond2_atoms(1)
          !write(*,*) '4 ', bond1_atoms(1)%text(), bond1_atoms(2)%text(), bond2_atoms(2)%text(), bond2_atoms(1)%text()

        end if
      end do
    end do

    allocate (connectivity_13(6, 1:connectivity_13_index))
    connectivity_13 = connectivity_13_temp(:, 1:connectivity_13_index)

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
      type(atom_t), dimension(:, :), allocatable, intent(inout) :: connectivity_13
      type(atom_t), dimension(:, :), allocatable :: temp

      call move_alloc(connectivity_13, temp)
      allocate (connectivity_13(6, size(temp)+128))
      connectivity_13(:, 1:ubound(temp, 2)) = temp

    end subroutine

  end subroutine

  !> initialise atom_t type with default values
  elemental subroutine init_atom(self)
    implicit none
    class(atom_t), intent(inout) :: self
    self%l5addr = -1
    self%label = ''
    self%serial = -1
    self%sym_op%S = 1
    self%sym_op%L = 1
    self%sym_op%translation = 0.0
    self%sym_mat%R = 0.0
    self%sym_mat%T = 0.0
    self%ref = -1
    self%part = 0
    self%resi = 0
  end subroutine

  !> pretty print for atom_t type
  function atom_text(self)
    implicit none
    class(atom_t), intent(in) :: self
    character(len=:), allocatable ::atom_text
    character(len=256) :: buffer

    if (any(self%sym_op%translation /= 0.0)) then
      write (buffer, '(A,"(",3(I0,","),2(F8.4,","),F8.4,")")') &
      & trim(self%label), self%serial, self%sym_op%S, self%sym_op%L, self%sym_op%translation
    else if (self%sym_op%L /= 1) then
      write (buffer, '(A,"(",2(I0,","),I0,")")') &
      & trim(self%label), self%serial, self%sym_op%S, self%sym_op%L
    else if (self%sym_op%S /= 1) then
      write (buffer, '(A,"(",1(I0,","),I0,")")') &
      & trim(self%label), self%serial, self%sym_op%S
    else
      write (buffer, '(A,"(",I0,")")') &
      & trim(self%label), self%serial
    end if

    atom_text = trim(buffer)
  end function

  !> replace a bond place holder with paris of bonded atoms (C--H => C(1) to H(1), ...)
  subroutine replace_bonds(text, change)
    implicit none
    character(len=*), intent(inout) :: text
    logical, intent(out) :: change
    character(len=4) :: bond_type_text, left, right
    integer bond_type, location, motif_len
    integer i, j
    ! atoms pairs
    type(atom_t), dimension(2) :: atoms
    type(atom_t), dimension(:, :), allocatable :: pairs
    character(len=8000) :: replacement
    character(len=512) :: buffer
    logical found, empty

    found = .false. ! true if a bond definition is found
    empty = .true. ! true if all bond definitions are empty
    change = .false.

    do ! loop until everything is found
      bond_type = -1
      do i = 1, size(bond_list_definition)
        write (bond_type_text, '("-",I0,"-")') i
        if (index(text, bond_list_definition(i)) > 0 .or. &
        & index(text, bond_type_text) > 0) then
          bond_type = i
          exit
        end if
      end do

      ! special case for -0- which is any bond like -10-
      write (bond_type_text, '("-",I0,"-")') 0
      if (index(text, bond_type_text) > 0) then
        bond_type = size(bond_list_definition)
      end if

      if (bond_type <= 0) then
        exit
      else
        found = .true. ! if true, we have found at least a bond definition
      end if

      ! we found a bond definition, we now fetch the atom type
      ! get which bond text is used first, numeric or characters
      change = .true.
      location = index(text, bond_list_definition(bond_type))
      if (location > 0) then
        motif_len = len(bond_list_definition(bond_type))
      else
        write (bond_type_text, '("-",I0,"-")') bond_type
        location = index(text, bond_type_text)
        motif_len = len_trim(bond_type_text)
      end if

      i = 1
      left = ''
      do while (text(location-i:location-i) /= ' ')
        if (i > 3) then
          exit
        end if
        left(3-i+1:3-i+1) = text(location-i:location-i)
        i = i+1
      end do
      left = adjustl(left)

      i = 1
      right = ''
      do while (text(location+motif_len+i-1:location+motif_len+i-1) /= ' ')
        if (i > 3) then
          exit
        end if
        right(i:i) = text(location+motif_len+i-1:location+motif_len+i-1)
        i = i+1
      end do

      if (left /= '' .and. right /= '') then
        ! all good to look for pairs
        call atoms%init()
        atoms(1)%label = left
        atoms(2)%label = right
        call get_pairs(atoms, pairs, bond_type)
        if (size(pairs) == 0) then
          ! no pairs, remove the bond place holder
          text = text(1:location-len_trim(left)-1)//text(location+motif_len+len_trim(right):)
          cycle
        end if

        replacement = ''
        do i = 1, ubound(pairs, 2)
          write (buffer, '(A,"(",I0,") TO ",A,"(",I0,")")') &
          & trim(pairs(1, i)%label), pairs(1, i)%serial, &
          & trim(pairs(2, i)%label), pairs(2, i)%serial
          replacement = trim(replacement)//' '//trim(buffer)//','
          empty = .false.
        end do
        replacement(len_trim(replacement):len_trim(replacement)) = ' '

        i = location-len_trim(left)
        j = location+motif_len+len_trim(right)-1

        text = text(1:i-1)//trim(replacement)//trim(text(j+1:))
      end if
    end do

    if (found .and. empty) then
      ! nothing have been found, commenting out the restraint
      call print_to_mon('{I No bond found in restraint:')
      call print_to_mon('{I '//trim(text))
      text = 'REM '//trim(text)
    end if

  end subroutine

  !> define a variable for later use using the DEFINE `restraint`
  subroutine define_variable(image_text, ierror)
    implicit none
    character(len=*), intent(inout) :: image_text
    integer, intent(out) :: ierror
    integer eq
    character(len=64) :: var_name
    integer i

    ierror = 0

    ! process local variable definition
    if (image_text(1:6) == 'DEFINE') then
      eq = index(image_text, '=')
      var_name = trim(adjustl(image_text(7:eq-1)))
      do i = 1, len_trim(var_name)
        if (iachar(var_name(i:i)) < 65 .or. iachar(var_name(i:i)) > 90) then
          call print_to_mon('{E '//trim(image_text))
          call print_to_mon('{E '//repeat('-', 6+i)//'^')
          call print_to_mon('{E Error: Invalid variable name, character `'// &
          & var_name(i:i)//'` not allowed')
          ierror = -1
          return
        end if
      end do
      lexical_var_list_index = lexical_var_list_index+1
      lexical_var_list(lexical_var_list_index)%label = trim(adjustl(image_text(7:eq-1)))
      read (image_text(eq+1:), *) lexical_var_list(lexical_var_list_index)%rvalue
    end if

  end subroutine

  !> substitute a variable with its value
  subroutine substitue_variable(image_text, ierror, change)
    implicit none
    character(len=*), intent(inout) :: image_text
    integer, intent(out) :: ierror
    logical, intent(out) :: change
    integer dollar_start, dollar_end
    character(len=64) :: var_name
    integer i
    logical found

    ierror = 0
    change = .false.

    dollar_start = index(image_text, '$')
    do while (dollar_start > 0)
      ! capture variable name
      dollar_end = dollar_start+1
      do while (image_text(dollar_end:dollar_end) /= ' ')
        dollar_end = dollar_end+1
      end do
      var_name = trim(image_text(dollar_start+1:dollar_end))

      ! look for its value in the table
      found = .false.
      do i = 1, lexical_var_list_index
        if (lexical_var_list(i)%label == var_name) then
          write (var_name, '(F0.6)') lexical_var_list(i)%rvalue
          image_text = image_text(1:dollar_start-1)//' '// &
          & trim(var_name)//' '//trim(image_text(dollar_end+1:))
          found = .true.
          change = .true.
        end if
      end do
      if (found) then
        dollar_start = index(image_text, '$')
      else
        call print_to_mon('{E '//trim(image_text))
        call print_to_mon('{E '//repeat('-', dollar_start-1)// &
        & repeat('^', len_trim(var_name)+1))
        call print_to_mon('{E Error: Definition of variable `$'// &
        & trim(var_name)//'` is missing')
        ierror = -1
        return
      end if
    end do
  end subroutine

  !> expand generic atoms name.
  !! - C(*) == all C atoms
  !! - C(part=i) all C atoms in part i
  !! - C(resi=i) all C atoms in residue i
  subroutine expand_atoms_names(image_text, ierror, modified)
    use store_mod, only: store, istore => i_store
    implicit none
    character(len=*), intent(inout) :: image_text
    integer, intent(out) :: ierror
    logical, intent(out) :: modified
    character(len=len(image_text)) :: original
    character(len=len(image_text)) :: buffer
    character(len=split_len), dimension(:), allocatable :: elements
    integer m5, k
    character(len=16) :: atom_name
    integer pattern_start
    integer i, j
    character(len=64) :: var_name
    type(atom_t) :: atom, atom_l5

    ierror = 0
    modified = .false.
    original = image_text

    ! expand atoms type
    if (index(image_text, '(*)') > 0) then
      call explode(image_text, split_len, elements)
      image_text = ''
      do i = 1, size(elements)
        pattern_start = index(elements(i), '(*)')
        ! capture atom type
        if (pattern_start > 0) then
          var_name = elements(i) (1:pattern_start-1)

          if (i < size(elements)) then
            if (trim(elements(i+1)) == 'TO') then
              ! need to be done in pairs
              call print_to_mon('{E '//trim(image_text)//' '//elements(i)//' '// &
              & trim(elements(i+1)))
              call print_to_mon('{E Error: Generic pairs are not implemented')
              image_text = trim(image_text)//' '//elements(i)
              ierror = -1
              return
            end if
          end if

          ! look for all atoms with same type
          m5 = savedl5
          do j = 1, savedn5
            if (transfer(store(m5), '    ') == var_name) then
              write (atom_name, '(A,"(",I0,")")') trim(transfer(store(m5), '    ')), &
              & nint(store(m5+1))
              image_text = trim(image_text)//' '//trim(atom_name)
              modified = .true.
            end if
            m5 = m5+savedmd5
          end do
        else
          image_text = trim(image_text)//' '//elements(i)
        end if
      end do
      image_text = adjustl(image_text)
    end if

    ! expand part and resi
    call explode(image_text, split_len, elements) ! split atom list
    buffer = elements(1)
    do i = 2, size(elements)
      atom = read_atom(trim(elements(i)))
      if (atom%part > 0 .or. atom%resi > 0) then
        modified = .true.

        m5 = savedl5
        do k = 1, savedn5
          write (atom_l5%label, '(A4)') store(m5)
          atom_l5%serial = nint(store(m5+1))
          atom_l5%part = istore(m5+14)
          atom_l5%resi = istore(m5+16)

          if (atom%part > 0 .and. atom_l5%part == atom%part) then
            write (atom_name, '(A,"(",I0,")")') trim(atom_l5%label), atom_l5%serial
            buffer = trim(buffer)//' '//trim(atom_name)
          else if (atom%resi > 0 .and. atom_l5%resi == atom%resi) then
            write (atom_name, '(A,"(",I0,")")') trim(atom_l5%label), atom_l5%serial
            buffer = trim(buffer)//' '//trim(atom_name)
          end if
          m5 = m5+savedmd5
        end do

      else
        buffer = trim(buffer)//' '//trim(elements(i))
      end if
    end do
    image_text = buffer

  end subroutine

  !> expand XCHIV restraints. look for the 3 neighbours.
  subroutine expand_xchiv(image_text, ierror, change)
    use store_mod, only: istore => i_store, store, c_store, i_store_set
    implicit none
    character(len=*), intent(inout) :: image_text
    integer, intent(out) :: ierror
    logical, intent(out) :: change
    character(len=split_len), dimension(:), allocatable :: elements
    integer neighbour_address, neighbour_cpt
    type(atom_t), dimension(6) :: xchiv_neighbours
    integer i, j
    type(atom_t) :: atom
    type(atom_t), dimension(2) :: bond_atoms
    integer m41b

    ierror = 0
    change = .false.

    if (lexical_list(lexical_list_index)%type == 'XCHIV') then       ! Expand xchiv

      if (image_text(1:4) == 'CONT') then
        ierror = -1
        call print_to_mon('{E '//trim(image_text))
        call print_to_mon('{E Error: XCHIV Restraint cannot be split over multiple lines')
        return
      end if

      ! split atom list
      call explode(image_text, split_len, elements)

      image_text = trim(elements(1))
      do i = 2, size(elements)
        atom = read_atom(trim(elements(i)))
        if (atom%serial /= -1) then
          ! explicit neighbours
          neighbour_cpt = 0
          do m41b = savedl41b, savedl41b+(savedn41b-1)*savedmd41b, savedmd41b
            bond_atoms = load_atom_from_l41(M41B)

            neighbour_address = -1
            if (bond_atoms(1) == atom .and. trim(bond_atoms(2)%label) /= 'H') then
              neighbour_address = 2
            else if (bond_atoms(2) == atom .and. trim(bond_atoms(1)%label) /= 'H') then
              neighbour_address = 1
            end if

            if (neighbour_address > 0) then
              neighbour_cpt = neighbour_cpt+1
              if (neighbour_cpt > 6) then
                exit
              end if
              xchiv_neighbours(neighbour_cpt) = bond_atoms(neighbour_address)
            end if
          end do

          if (neighbour_cpt == 3) then ! xchiv requires exactly 3 neighbours
            change = .true.
            image_text = trim(image_text)//' '//trim(elements(i))
            do j = 1, 3
              image_text = trim(image_text)//' '//xchiv_neighbours(j)%text()
            end do
          else
            call print_to_mon('{E '//trim(image_text))
            call print_to_mon('{E Error: XCHIV needs exactly 3 non hydrogen neigbours for '//trim(elements(i)))
            do j = 1, min(neighbour_cpt, size(xchiv_neighbours))
              call print_to_mon(xchiv_neighbours(j)%text())
            end do
            ierror = -1
            return
          end if
        else
          image_text = trim(image_text)//' '//trim(elements(i))
        end if
      end do
    end if ! expand xchiv
  end subroutine

  !> Rewrite shelxl RIGU restraint into crystals RIGU implementation (atoms pairs)
  subroutine expand_rigu(image_text, ierror, change)
    implicit none
    character(len=*), intent(inout) :: image_text
    integer, intent(out) :: ierror !< error code 0==success
    logical, intent(out) :: change
    character(len=len(image_text)) :: original
    character(len=split_len), dimension(:), allocatable :: elements
    integer start, i, j
    type(atom_t), dimension(:), allocatable :: atoms
    character(len=64) :: buffer
    type(atom_t), dimension(:, :), allocatable :: connectivity_13
    type(atom_t), dimension(:, :), allocatable :: pairs
    character, dimension(13), parameter :: numbers = (/'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.', '-', '+'/)
    logical found
    real esd13

    ierror = 0
    original = image_text
    change = .false.

    if (lexical_list(lexical_list_index)%type == 'XRIGU') then
      change = .true.

      if (image_text(1:4) == 'CONT') then
        ierror = -1
        call print_to_mon('{E '//trim(image_text))
        call print_to_mon('{E Error: XRIGU Restraint cannot be split over multiple lines')
        return
      end if

      ! split atom list
      call explode(image_text, split_len, elements)

      if (size(elements) < 3) then
        ierror = -1
        call print_to_mon('{E '//trim(image_text))
        call print_to_mon('{E Error: XRIGU Restraint needs more than one atom')
        return
      end if

      ! elements(1) is XRIGU
      image_text = 'URIGU'
      start = 1
      found = .false.
      do i = 1, len_trim(elements(2))
        do j = 1, size(numbers)
          if (elements(2) (i:i) == numbers(j)) then
            found = .true.
            exit
          end if
        end do
        if (.not. found) exit
      end do
      if (found) then
        start = start+1
        image_text = trim(image_text)//' '//elements(2)
      else
        image_text = trim(image_text)//' 0.004'
      end if
      found = .false.
      do i = 1, len_trim(elements(3))
        do j = 1, size(numbers)
          if (elements(3) (i:i) == numbers(j)) then
            found = .true.
            exit
          end if
        end do
        if (.not. found) exit
      end do
      if (found) then
        start = start+1
        image_text = trim(image_text)//' '//elements(3)
        read (elements(3), *) esd13
      else
        image_text = trim(image_text)//' 0.004'
        esd13 = 0.004
      end if

      if (size(elements)-start < 2) then
        ierror = -1
        image_text = original
        call print_to_mon('{E '//trim(image_text))
        call print_to_mon('{E Error: XRIGU Restraint needs more than one atom')
        return
      end if

      allocate (atoms(size(elements)-start))
      call atoms%init()
      do i = start+1, size(elements)
        atoms(i-start) = read_atom(trim(elements(i)))
        if (atoms(i-start)%serial == -1) then
          ierror = -1
          image_text = original
          return
        end if
      end do
      call get_pairs(atoms, pairs)

      ! write the number of 1,2 distances pairs
      write (buffer, '(I0)') ubound(pairs, 2)
      image_text = trim(image_text)//' '//trim(buffer)
      if (ubound(pairs, 2) > 0) then
        found = .true.
      else
        found = .false.
      end if

      do i = 1, ubound(pairs, 2)
        write (buffer, '(A,"(",I0,") TO ", A, "(",I0,")")') &
        & trim(pairs(1, i)%label), pairs(1, i)%serial, &
        & trim(pairs(2, i)%label), pairs(2, i)%serial
        image_text = trim(image_text)//' '//trim(buffer)//','
      end do
      image_text(len_trim(image_text):len_trim(image_text)) = ' '

      if (abs(esd13) > 1e-6) then
        call get_connectivity_13(connectivity_13)
        call get_pairs_13(atoms, connectivity_13, pairs)

        if (ubound(pairs, 2) > 0) then
          image_text = trim(image_text)//','
        end if
        do i = 1, ubound(pairs, 2)
          write (buffer, '(A,"(",I0,") TO ", A, "(",I0,")")') &
          & trim(pairs(1, i)%label), pairs(1, i)%serial, &
          & trim(pairs(2, i)%label), pairs(2, i)%serial
          image_text = trim(image_text)//' '//trim(buffer)//','
        end do
        if (ubound(pairs, 2) > 0) then
          image_text(len_trim(image_text):len_trim(image_text)) = ' '
        else
          if (.not. found) then ! no 1,2 pairs and no 1,3 pairs
            ! commenting out restraint, it is empty
            image_text = 'REM '//trim(image_text)
          end if
        end if
      else
        if (.not. found) then ! no 1,2 pairs and no 1,3 pairs
          ! commenting out restraint, it is empty
          image_text = 'REM '//trim(image_text)
        end if
      end if
    end if
    !print *, trim(image_text)

  end subroutine

  !> Parse an atom definition TYPE(SERIAL,S,L,TX,TY,TZ)
  !! If serial returns -1, there was an error
  function read_atom(text) result(atom)
    implicit none
    character(len=*), intent(in) :: text
    type(atom_t) :: atom
    integer i, j, k, n, info, eoffset
    character(len=len(text)) :: buffer
    character(len=split_len), dimension(:), allocatable :: elements
    character(len=128) :: msgstatus
    logical skip_position

    character(len=6), dimension(16), parameter :: param_name = (/  &
    & 'X     ', 'Y     ', 'Z     ', 'OCC   ', 'U[ISO]', 'SPARE ',&
    & 'U[11] ', 'U[22] ', 'U[33] ', 'U[23] ', 'U[13] ', 'U[12] ',&
    & "X'S   ", "U'S   ", "UIJ'S ", "UII'S "/)

    call atom%init()

    ! catch (*) notation
    if (index(text, '(*)') > 0) then
      atom%serial = -1
      return
    end if

    i = index(text, '(')
    j = index(text, ')')

    if (i > 1 .and. j > i) then
      buffer = text(i+1:j-1)
      atom%label = adjustl(text(1:i-1))
      call explode(buffer, split_len, elements, ',', greedy_arg=.false.)
      eoffset = 0
      do j = 1, size(elements)
        skip_position = .false.
        info = 0
        msgstatus = ''
        if (trim(elements(j)) /= '') then
          do k = 1, size(param_name)
            if (index(elements(j), trim(param_name(k))) > 0) then
              ! valid instruction but not used in restraints
              eoffset = eoffset+1
              skip_position = .true.
              exit
            end if
          end do

          if (index(elements(j), 'PART') > 0) then
            n = index(elements(j), '=')
            if (n > 0) then
              read (elements(j) (n+1:), *, iostat=info, iomsg=msgstatus) atom%part
              eoffset = eoffset+1
              skip_position = .true.
            end if
          else if (index(elements(j), 'RESI') > 0) then
            n = index(elements(j), '=')
            if (n > 0) then
              read (elements(j) (n+1:), *, iostat=info, iomsg=msgstatus) atom%resi
              eoffset = eoffset+1
              skip_position = .true.
            end if
          end if

          if (.not. skip_position) then
            select case (j+eoffset)
            case (1) ! serial
              read (elements(j), *, iostat=info, iomsg=msgstatus) atom%serial
              if (atom%serial < 0) then
                info = -1
                msgstatus = 'Negative serial number is not valid'
              end if
            case (2) ! symmetry operator provided in the unit cell symmetry LIST 2
              read (elements(j), *, iostat=info, iomsg=msgstatus) atom%sym_op%S
            case (3) ! the non-primitive lattice translation that is to be added
              read (elements(j), *, iostat=info, iomsg=msgstatus) atom%sym_op%L
              if (atom%sym_op%L < 1 .or. atom%sym_op%L > 4) then
                info = -1
                msgstatus = 'Lattice translation number is not valid'
              end if
            case (4)
              read (elements(j), *, iostat=info, iomsg=msgstatus) atom%sym_op%translation(1)
            case (5)
              read (elements(j), *, iostat=info, iomsg=msgstatus) atom%sym_op%translation(2)
            case (6)
              read (elements(j), *, iostat=info, iomsg=msgstatus) atom%sym_op%translation(3)
            case default
              write (msgstatus, '(A, I0, 1X, I0)') '{E Error: wrong offset in read_atom ', j, eoffset
              info = -1
              atom%serial = -1
            end select
          end if
          if (info /= 0) then ! error when reading one of the values
            call print_to_mon('{E Error: '//trim(text)//' is not a valid atom name')
            call print_to_mon('{E '//trim(msgstatus))
            atom%serial = -1
            return
          end if
        end if
      end do
    else
      atom%serial = -1
      return
    end if

    call atom%sym_mat_update(info)
    if (info /= 0) then
      atom%serial = -1
      return
    end if
  end function

  !> Update symmetry oprators from crystals notation to matrix notation
  subroutine atom_update_sym_mat(self, ierror)
    use xlst02_mod, only: n2, l2, md2, l2p, n2p, md2p
    use xunits_mod, only: ierflg
    use store_mod, only: store
    implicit none
    class(atom_t), intent(inout) :: self
    integer, intent(out) :: ierror
    integer i, j
    character(len=256) :: logtext

    ierror = 0
    i = l2+(md2*(abs(self%sym_op%S)-1))
    if (self%sym_op%L == 0) then
      j = l2p+(md2p*(self%sym_op%L))
    else
      j = l2p+(md2p*(self%sym_op%L-1))
    end if

    if (i > l2+((n2-1)*md2) .or. i < l2 .or. l2 < 1) then
      write (logtext, '(A,I0)') '{E Error: invalid symmetry operator index ', self%sym_op%S
      call print_to_mon(logtext)
      ierror = -1
      return
    end if
    if (j > l2p+((n2p-1)*md2p) .or. j < l2p .or. l2p < 1) then
      write (logtext, '(A,I0)') '{E Error: invalid lattice translation index ', self%sym_op%L
      call print_to_mon(logtext)
      ierror = -1
      return
    end if

    self%sym_mat%R = transpose(reshape(store(i:i+8), (/3, 3/)))
    self%sym_mat%T = store(j:j+2)+self%sym_op%translation

    if (self%sym_op%S < 0) then
      self%sym_mat%R = -1.0*self%sym_mat%R
    end if

  end subroutine

  !> bond information from list 41 into a pair of atom_t objects
  function load_atom_from_l41(l41addr) result(atom)
    use store_mod, only: istore => i_store, c_store, store
    implicit none
    integer, intent(in) :: l41addr
    type(atom_t), dimension(2) :: atom
    integer l5addr

    l5addr = savedl5+istore(l41addr)*savedmd5
    atom(1)%l5addr = l5addr
    atom(1)%label = trim(c_store(l5addr))
    atom(1)%serial = nint(store(l5addr+1))
    atom(1)%part = istore(l5addr+14)
    atom(1)%resi = istore(l5addr+16)
    atom(1)%bond = istore(l41addr+12)
    atom(1)%sym_op%S = istore(l41addr+1)
    atom(1)%sym_op%L = istore(l41addr+2)
    !print *, nint(store(l41addr+1)), istore(l41addr+1)
    !print *, nint(store(l41addr+2)), istore(l41addr+2)
    atom(1)%sym_op%translation = store(l41addr+3:l41addr+5)

    l5addr = savedl5+istore(l41addr+6)*savedmd5
    atom(2)%l5addr = l5addr
    atom(2)%label = trim(c_store(l5addr))
    atom(2)%serial = nint(store(l5addr+1))
    atom(2)%part = istore(l5addr+14)
    atom(2)%resi = istore(l5addr+16)
    atom(2)%bond = istore(l41addr+12)
    atom(2)%sym_op%S = istore(l41addr+7)
    atom(2)%sym_op%L = istore(l41addr+8)
    !print *, nint(store(l41addr+7)), istore(l41addr+7)
    !print *, nint(store(l41addr+8)), istore(l41addr+8)
    atom(2)%sym_op%translation = store(l41addr+9:l41addr+11)
  end function

  !> compare 2 atom_t object type together
  function atom_compare(atom1, atom2) result(r)
    implicit none
    class(atom_t), intent(in) :: atom1, atom2
    logical :: r

    r = .true.

    if (atom1%label /= atom2%label) r = .false.
    !print *, 'label ', atom1%label, atom2%label, r
    if (atom1%serial /= atom2%serial) r = .false.
    !print *, 'serial ', atom1%serial, atom2%serial, r
    if (atom1%part /= atom2%part) r = .false.
    !print *, 'part ', atom1%part, atom2%part, r
    if (atom1%resi /= atom2%resi) r = .false.
    !print *, 'resi ', atom1%resi, atom2%resi, r
    if (atom1%sym_op%S /= atom2%sym_op%S) r = .false.
    !print *, 'S ', atom1%sym_op%S, atom2%sym_op%S, r
    if (atom1%sym_op%L /= atom2%sym_op%L) r = .false.
    !print *, 'L ', atom1%sym_op%L, atom2%sym_op%L, r

    if (any(abs(atom1%sym_op%translation-atom2%sym_op%translation) > 0.01)) r = .false.

    !print *, atom1%text(), atom2%text()
    !print *, 'here ', r

  end function

  subroutine print_to_mon(text, wrap_arg)
    use xiobuf_mod, only: cmon !< I/O units
    use xunits_mod, only: ncwu, ncvdu !< I/O units
    implicit none
    character(len=*), intent(in) :: text !< text to print to screen
    logical, intent(in), optional :: wrap_arg !< option to wrap text over several lines
    logical wrap
    integer istart, iend
    integer, parameter :: line_len = 100 !< length of a line
    integer, parameter :: tab_len = 4 !< length of tabulation to insert after a wrap
    character(len=3) :: prefix !< color code prefix

    if (present(wrap_arg)) then
      wrap = wrap_arg
    else
      wrap = .false.
    end if
    prefix = ''

#ifdef CRY_NOGUI
    if (text(1:1) == '{') then
      istart = 4
    else
      istart = 1
    end if
    write (ncwu, '(A)') trim(text(istart:iend))
#else
    if (text(1:1) == '{') then
      prefix = text(1:3)
    end if
    istart = 1
    write (ncwu, '(A)') trim(text(istart+len_trim(prefix)-1:iend))
#endif


    if (wrap) then
      if (line_len < len_trim(text)) then
        iend = line_len+istart-1
        do while (text(iend:iend) /= ' ')
          iend = iend-1
          if (iend < 1) exit
        end do
      else
        iend = len_trim(text)
      end if
    else
      iend = len_trim(text)
    end if
    write (cmon, '(A)') trim(text(istart:iend))
    call xprvdu(ncvdu, 1, 0)
    istart = iend+1
    iend = min(iend+line_len-tab_len, len_trim(text))

    do while (istart < len_trim(text))

      if (iend < len_trim(text)) then
        do while (text(iend:iend) /= ' ')
          iend = iend-1
          if (iend < istart) exit
        end do
      else
        iend = len_trim(text)
      end if

      write (cmon, '(A, A, A)') prefix, repeat(' ', tab_len), trim(adjustl(text(istart:iend)))
      call xprvdu(ncvdu, 1, 0)

      istart = iend+1
      iend = min(iend+line_len, len_trim(text))
    end do

  end subroutine

  !> look for atom definition and check if there are in List 5
  subroutine check_atom(image_text, ierror)
    use store_mod, only: store
    implicit none
    character(len=*), intent(inout) :: image_text
    integer, intent(out) :: ierror
    character(len=split_len), dimension(:), allocatable :: elements
    integer, dimension(:), allocatable :: fieldpos
    type(atom_t) :: atom
    integer i, j, m5, n, m
    logical found
    character(len=8), dimension(13), parameter :: ignore = (/ &
                                                  'RENAME  ', &
                                                  'LAYER   ', &
                                                  'ELEMENT ', &
                                                  'PROFILE ', &
                                                  'DELETE  ', &
                                                  'CREATE  ', &
                                                  'OLD     ', &
                                                  'RESI    ', &
                                                  'CONTINUE', &
                                                  'BEFORE  ', &
                                                  'AFTER   ', &
                                                  'CONT    ', &
                                                  'MOVE    '/)

    ierror = 0

    if (image_text(1:4) == 'REM ') then ! ignore comments
      return
    end if

    do i = 1, size(ignore)
      if (image_text(1:len_trim(ignore(i))) == trim(ignore(i))) then ! ignore some instructions
        return
      end if
    end do

    ! split atom list
    call explode(image_text, split_len, elements, fieldpos=fieldpos)

    do i = 2, size(elements)

      do j = 1, size(ignore)
        if (elements(i) (1:len_trim(ignore(j))) == trim(ignore(j))) then ! ignore some instructions
          return
        end if
      end do

      atom = read_atom(trim(elements(i)))

      if (atom%label == 'G') then
        ! metric tensor!
        if (atom%serial < 1 .or. atom%serial > 3) then
          n = index(image_text, trim(elements(i)))
          call print_to_mon('{E Error: '//trim(image_text))
          call print_to_mon('{E '//repeat('-', n+6)//repeat('^', len_trim(elements(i))))
          call print_to_mon('{E Error: index out of bound for the metric tensor '//trim(elements(i)))
          ierror = -1
        end if
        if (atom%sym_op%S < 1 .or. atom%sym_op%S > 3) then
          n = index(image_text, trim(elements(i)))
          call print_to_mon('{E Error: '//trim(image_text))
          call print_to_mon('{E '//repeat('-', n+6)//repeat('^', len_trim(elements(i))))
          call print_to_mon('{E Error: index out of bound for the metric tensor '//trim(elements(i)))
          ierror = -1
        end if
        cycle
      end if

      if (atom%serial /= -1) then
        ! check list 5
        m5 = savedl5
        found = .false.
        do j = 1, savedn5
          if (transfer(store(m5), '    ') == atom%label .and. &
          & nint(store(m5+1)) == atom%serial) then
            found = .true.
            exit
          end if
          m5 = m5+savedmd5
        end do

        if (.not. found) then
          n = fieldpos(i)
          if (i < size(fieldpos)) then
            m = fieldpos(i+1)-fieldpos(i)
          else
            m = len_trim(image_text)-fieldpos(i)
          end if
          call print_to_mon('{E Error: '//trim(image_text))
          call print_to_mon('{E '//repeat('-', n+6)//repeat('^', m))
          call print_to_mon('{E Error: atom '//trim(elements(i))//' is not present in the model')
          ierror = -1
        end if
      end if
    end do
  end subroutine

  !> Insert spaces around operators when necessary
  !! Splitting of expression relies on spaces.
  subroutine fixed_spacing(image_text)
    implicit none
    character(len=*), intent(inout) :: image_text
    character, dimension(5), parameter :: parameters = (/'/', '*', '-', '+', '='/)
    integer n, i, k, s, m
    character, dimension(10), parameter :: numbers = (/'0', '1', '2', '3', '4', '5', '6', '7', '8', '9'/)
    logical founda, foundb

    ! insert spaces around = if missing
    s = index(image_text, ' ') ! look for the first space, do not touch the first keyword
    do i = 1, size(parameters)
      n = s
      do
        n = n+1
        if (n > len_trim(image_text)) exit

        if (image_text(n:n) == parameters(i) .and. n > 1) then
          if (image_text(n-1:n-1) /= ' ' .and. image_text(n+1:n+1) /= ' ') then
            ! exceptions
            if (image_text(n-1:n+2) == 'F-SQ') then
              n = n+2
              cycle
            end if

            if (i < 5) then
              founda = .false. !after
              foundb = .false. !before
              do k = 1, size(numbers)
                if (image_text(n+1:n+1) == numbers(k)) then
                  founda = .true.
                  exit
                end if
              end do
              do k = 1, size(numbers)
                if (image_text(n-1:n-1) == numbers(k)) then
                  foundb = .true.
                  exit
                end if
              end do
              if (founda .and. foundb) then
                ! do nothing
              else if (founda) then
                image_text = image_text(1:n-1)//' '//parameters(i)//trim(image_text(n+1:))
                n = n+1
              else if (foundb) then
                image_text = image_text(1:n-1)//parameters(i)//trim(image_text(n+1:))
                n = n+1
              else
                image_text = image_text(1:n-1)//' '//parameters(i)//' '//trim(image_text(n+1:))
                n = n+2
              end if
            else
              image_text = image_text(1:n-1)//' '//parameters(i)//' '//trim(image_text(n+1:))
              n = n+2
            end if
          else if (image_text(n-1:n-1) /= ' ') then
            if (i < 5) then
              foundb = .false. !before
              do k = 1, size(numbers)
                if (image_text(n-1:n-1) == numbers(k)) then
                  foundb = .true.
                  exit
                end if
              end do
              if (.not. foundb) then
                image_text = image_text(1:n-1)//' '//parameters(i)//trim(image_text(n+1:))
                n = n+1
              end if
            else
              image_text = image_text(1:n-1)//' '//parameters(i)//trim(image_text(n+1:))
              n = n+1
            end if
          else if (image_text(n+1:n+1) /= ' ') then
            if (i < 5) then
              founda = .false. !before
              do k = 1, size(numbers)
                if (image_text(n+1:n+1) == numbers(k)) then
                  founda = .true.
                  exit
                end if
              end do
              if (.not. founda) then
                image_text = image_text(1:n-1)//parameters(i)//' '//trim(image_text(n+1:))
                n = n+1
              end if
            else
              image_text = image_text(1:n-1)//' '//parameters(i)//trim(image_text(n+1:))
              n = n+1
            end if
          end if
        end if
      end do
    end do

    ! remove spaces between label and serial in an atom definition
    ! ie. C  (1) => c(1)
    s = index(image_text, ' ') ! look for the first space, do not touch the first keyword
    n = s
    do
      n = n+1
      if (n > len_trim(image_text)) exit

      if (image_text(n:n) == '(' .and. n > 1) then
        if (image_text(n-1:n-1) == ' ') then
          m = 1
          do while (image_text(n-m:n-m) == ' ')
            m = m+1
          end do
          if (n-m > s .and. iachar(image_text(n-m:n-m)) > 64 .and. iachar(image_text(n-m:n-m)) < 89) then ! text already upper case at this point
            ! removing the spaces
            image_text = image_text(1:n-m)//trim(image_text(n:))
            n = n-m
          end if
        end if
      end if
    end do

  end subroutine

!> print the content before and after the changes from this module
  subroutine lexical_print_changes(iounit)
    implicit none
    integer, intent(in) :: iounit
    integer i

    if (list16_modified .and. allocated(lexical_list)) then
      write (iounit, '(A)') '-- Original input to lexical analyzer:'
      do i = 1, lexical_list_index
        write (iounit, '(A)') lexical_list(i)%original
      end do
      write (iounit, '(A)') '-- Modified input to lexical analyzer:'
      do i = 1, lexical_list_index
        write (iounit, '(A)') lexical_list(i)%processed
      end do
    end if
  end subroutine

end module
