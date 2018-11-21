!> Crystallographic data of a structure during import from shelx \ingroup shelx2cry
module crystal_data_m

  logical, public :: the_end = .false. !< has the keyword END been reached

  logical, public :: Interactive_mode = .false. !< Ask user question if set to .true.

  integer, parameter :: crystals_fileunit = 1234 !< unit number for the crystals file ouput
  integer :: log_unit
  integer, parameter :: lenlabel = 12
  integer, parameter :: line_length = 72
  integer, parameter :: shelxline_length = 1024

  type hklf_t !< hold information from hklf card
    integer :: code !< hklf code (1,2,3,4,5 or 6)
    real, dimension(3, 3) :: transform !< transformation matrix for h,k,l indices
    real :: scale !< Unused in crystals, scaling factors for the intensities and sigmas
  end type
  type(hklf_t) :: hklf

  type omit_t !< hold information from omit and shel card
    real :: twotheta = 0.0 !< 2theta limit
    real, dimension(2) :: shel = (/-1.0, -1.0/)
    integer, dimension(:, :), allocatable :: hkl !< list of hkl indices
    integer index !< number of hkl reflections omitted
  end type
  type(omit_t) omitlist

  type line_t
    integer :: line_number = 1 !< Hold the line number from the shelx file
    character(len=:), allocatable :: line !< line content
  end type

  real, dimension(6) :: list4 = 0.0 !< Array holding the values of the shelx weighting scheme
  character(len=512), dimension(512) :: list1 !< Array holding list1 instructions
  integer :: list1index = 0 !< index in list1
  character(len=512), dimension(512) :: list13 !< Array holding list13 instructions
  integer :: list13index = 0 !< index in list13
  character(len=512), dimension(512) :: list12 !< Array holding list12 instructions
  integer :: list12index = 0  !< index in list12
  character(len=512), dimension(4) :: list31 = ''  !< Array holding list31 instructions
  character(len=512), dimension(5) :: composition = ''  !< Array holding composition instructions

  character(len=3), dimension(128) :: sfac = '' !< List of atom types (sfac from shelx)
  real, dimension(14, 128) :: sfac_long = 0.0 !< a1 b1 a2 b2 a3 b3 a4 b4 c f' f" mu r wt coefficients (sfac from shelx)
  real, dimension(128) :: sfac_units !< number of elements in unit cell
  integer :: sfac_index = 0 !< current index in sfac
  real, dimension(:), allocatable :: fvar !< list of free variables (sfac from shelx)
  real, dimension(6) :: unitcell = 0.0 !< Array holding the unit cell parameters (a,b,c, alpha,beta,gamma). ANgle sin degree
  real wavelength !< wavelengh from shelx CELL card
  integer :: part = 0 !< current part
  real :: part_sof = -1.0 !< Overriding subsequent site occupation factor

!> EQIV data type (EQIV $n symmetry operation)
  type eqiv_t
    integer :: index !< index of symmetry operator
    character(len=128) :: text !< symmetry operator as in EQIV
    real, dimension(3, 3) :: rotation !< rotation matrix
    real, dimension(3) :: translation !< translation
    integer :: S !< index of symmetry operator in LIST 2, if sapce group is centric, S is negative if inverted
    integer :: L !< non-primitive lattice translation
    real, dimension(3) :: crystals_translation !< shitfs in unit cells to be added
  end type
  type(eqiv_t), dimension(128) :: eqiv_list !< list of all eqiv instructions
  integer :: eqiv_list_index = 0 !< current index in eqiv_list

!> data type for RESI
  type resi_t
    integer :: number !< numeric number
    character(len=4) :: class !< class of the residue (4 apha numeric characters max, cannot start with a number)
    character(len=128) :: alias !< an alias
    integer :: crystals_residue !< residue used for crystals (only support integers)
    integer :: shelx_line_number
  contains
    procedure :: init => init_resi !< initialise object
    procedure :: is_set => is_resi_set !< overload .eqv.
    procedure, private :: resi_compare, nresi_compare !< overload equivalence to compare resi type object
    generic :: operator(==) => resi_compare !< overload ==
    generic :: operator(/=) => nresi_compare !< overload /=
    generic :: operator( .eqv. ) => resi_compare !< overload .eqv.
    generic :: operator( .neqv. ) => nresi_compare !< overload .neqv.
  end type
  type(resi_t), dimension(512) :: resi_list !< list of all resi instructions
  integer :: resi_list_index = 0 !< max index in resi_list
  integer :: current_resi_index = 0 !< current residue

  type disp_t
    character(len=512) :: shelxline !< raw line from res/ins file
    integer :: line_number !< line number of shelxline from res/ins file
    character(len=3) :: atom
    real, dimension(3) :: values
  end type
  type(disp_t), dimension(:), allocatable :: disp_table !< List of disp keywords

!> Atom type. It holds hold the information about an atom in the structure
  type atom_t
    character(len=lenlabel) :: label = '' !< label from shelx
    integer :: sfac = 0 !< sfac from shelx
    real, dimension(3) :: coordinates = 0.0 !< x,y,z fractional coordinates from shelx
    real, dimension(6) :: aniso = 0.0 !< Anistropic displacement parameters U11 U22 U33 U23 U13 U12 from shelx
    real :: iso = 0.0 !< isotropic temperature factor from shelx
    real :: sof = 0.0 !< Site occupation factor from shelx
    integer :: multiplicity = 0 !< multiplicity (calculated)
    type(resi_t) :: resi  !< residue from shelx
    integer :: part = 0 !< group from shelx
    character(len=shelxline_length) :: shelxline = '' !< raw line from res/ins file
    integer :: line_number = 0 !< line number of shelxline from res/ins file
    integer :: crystals_serial = -1 !< crystals serial code
  contains
    procedure, private :: atom_compare_to_shelx !< compare atom_shelx_t to atom_t
    generic :: operator(==) => atom_compare_to_shelx !< overload ==
    procedure :: crystals_label !< return a crystals label TYPE(SERIAL,S,L,TX,TY,TZ)
  end type
  type(atom_t), dimension(:), allocatable :: atomslist !< list of atoms in the res/ins file
  integer atomslist_index !< Current index in the list of atoms list (atomslist)

!> Shelxl atom type
  type atom_shelx_t
    character(len=lenlabel) :: label = '' !< shelx label
    character(len=lenlabel) :: text = '' !< raw label from shelx
    type(resi_t) :: resi
    integer :: symmetry !< XX_$y
    logical :: previous !< XX_-
    logical :: after !< XX_+
    logical :: resi_all !< all residues
  contains
    procedure :: init => init_atom_shelx !< initialise object
    procedure, private :: shelx_compare_to_atom !< compare atom_shelx_t to atom_t
    generic :: operator(==) => shelx_compare_to_atom !< overload ==
  end type
  interface atom_shelx_t
    module procedure read_atom_shelx
  end interface

!> Symmetry operators
  type SeitzMx_t
    integer, dimension(3, 3) :: R !< rotation part of the symmetry
    integer, dimension(3) :: T !< translation * 12 (see sginfo and STBF)
  end type

!> Space group type. All the elements describing the space group.
  type spacegroup_t
    integer :: latt !< lattice type from shelx (1=P, 2=I, 3=rhombohedral obverse on hexagonal axes, 4=F, 5=A, 6=B, 7=C)
    character(len=128), dimension(32) :: symm !< list of symmetry element read from res/ins file
    integer :: symmindex = 0 !< current index in symm
    character(len=128) :: symbol !< Space group symbol
    type(SeitzMx_t), dimension(:), allocatable :: ListSeitzMx !< list of symmetry operators as matrices, see sginfo
    integer :: centric
  end type
  type(spacegroup_t), save :: spacegroup !< Hold the spagroup information

!> type DFIX
  type dfix_t
    real :: distance, esd
    character(len=lenlabel) :: atom1, atom2
    type(resi_t) :: residue !< Residue
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
  end type
  type(dfix_t), dimension(1024), save :: dfix_table
  integer :: dfix_table_index = 0

!> type FLAT
  type flat_t
    character(len=lenlabel), dimension(:), allocatable :: atoms
    real esd !< esd of the restraint
    type(resi_t) :: residue !< Residue
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
  end type
  type(flat_t), dimension(1024), save :: flat_table
  integer :: flat_table_index = 0

!> type EADP
  type eadp_t
    character(len=lenlabel), dimension(:), allocatable :: atoms
    type(resi_t) :: residue !< Residue
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
  end type
  type(eadp_t), dimension(1024), save :: eadp_table
  integer :: eadp_table_index = 0

!> type ISOR
  type isor_t
    type(resi_t) :: residue !< Residue
    real :: esd1, esd2 !< if the atom is terminal (or makes no bonds), esd2 is used instead of esd1
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
  end type
  type(isor_t), dimension(1024), save :: isor_table
  integer :: isor_table_index = 0

!> type SADI
  type sadi_t
    real :: esd
    type(atom_shelx_t) :: residue !< Residue
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
  end type
  type(sadi_t), dimension(1024), save :: sadi_table
  integer :: sadi_table_index = 0

!> type RIGU
  type rigu_t
    real :: esd12 !< esd 1,2-distances
    real :: esd13 !< esd 1,3-distances
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
  end type
  type(rigu_t), dimension(1024), save :: rigu_table
  integer :: rigu_table_index = 0

!> type SAME
  type same_t
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
    integer, dimension(:), allocatable :: list_to !< target atoms
    real esd1, esd2 !< esds
  end type
  type(same_t), dimension(1024) :: same_table
  integer :: same_table_index = 0

!> type info. List of warning saved for printing at the end so they don't get lost
  type info_t
    character(len=shelxline_length) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
    character(len=1024) :: text
  end type
  type(info_t), dimension(1024) :: info_table
  integer :: info_table_index = 0

  type summary_t
    integer :: error_no !< Number of errors issued
    integer :: warning_no !< number of warnings issued
  end type
  type(summary_t) :: summary

  type shelx_unsupported_t !< type for the list of the tags found in the res file not supported by crystals
    character(len=4) :: tag = '' !< shelxl tag
    integer :: num = 0 !< number of tag found
  end type
  type(shelx_unsupported_t), dimension(80) :: shelx_unsupported_list !< list of the tags found in the res file not supported by crystals
  integer :: shelx_unsupported_list_index = 0

contains

!> Transform a string to upper case
  elemental subroutine to_upper(strIn, strOut)
    implicit none

    character(len=*), intent(inout) :: strIn !< mixed case input and upper case output if output not supplied
    character(len=len(strIn)), intent(out), optional :: strOut !< upper case output
    integer :: i, j

    do i = 1, len(strIn)
      j = iachar(strIn(i:i))
      if (j >= iachar("a") .and. j <= iachar("z")) then
        if (present(strOut)) then
          strOut(i:i) = achar(iachar(strIn(i:i))-32)
        else
          strIn(i:i) = achar(iachar(strIn(i:i))-32)
        end if
      else
        if (present(strOut)) then
          strOut(i:i) = strIn(i:i)
        end if
      end if
    end do

  end subroutine to_upper

  elemental function to_upper_fun(strIn) result(strOut)
    implicit none

    character(len=*), intent(in) :: strIn !< mixed case input
    character(len=len(strIn)) :: strOut !< upper case output
    integer :: i, j

    do i = 1, len(strIn)
      j = iachar(strIn(i:i))
      if (j >= iachar("a") .and. j <= iachar("z")) then
        strOut(i:i) = achar(iachar(strIn(i:i))-32)
      else
        strOut(i:i) = strIn(i:i)
      end if
    end do

  end function to_upper_fun

!> Remove repeated separators. Default separator is space
  subroutine deduplicates(line, strip, sep_arg)
    implicit none
    character(len=*) :: line !< text to process
    character, intent(in), optional :: sep_arg !< Separator to deduplicate
    character(len=:), allocatable, intent(out), optional :: strip
    character(len=len_trim(line)) :: buffer
    integer i, k, sepfound
    character sep

    if (present(sep_arg)) then
      sep = sep_arg
    else
      sep = ' '
    end if

    buffer = ''
    k = 0
    sepfound = 1
    do i = 1, len_trim(line)
      if (line(i:i) /= sep) then
        sepfound = 0
        k = k+1
        buffer(k:k) = line(i:i)
      else
        if (sepfound == 0) then
          k = k+1
          buffer(k:k) = line(i:i)
          sepfound = sepfound+1
        end if
      end if
    end do

    buffer = adjustl(buffer)
    if (present(strip)) then
      allocate (character(len=len_trim(buffer)) :: strip)
      strip = trim(buffer)
    else
      line = trim(buffer)
    end if
  end subroutine

!> Split a string into different pieces given a separator. Defaul separator is space.
!! Len of pieces must be passed to the function
  pure subroutine explode(line, lenstring, elements, sep_arg)
    implicit none
    character(len=*), intent(in) :: line !< text to process
    integer, intent(in) :: lenstring !< length of each individual elements
    character, intent(in), optional :: sep_arg !< Separator
    character(len=lenstring), dimension(:), allocatable, intent(out) :: elements
    character(len=lenstring) :: bufferlabel
    integer i, j, k
    character sep

    if (present(sep_arg)) then
      sep = sep_arg
    else
      sep = ' '
    end if

    allocate (elements(count_char(line, ' ')+1))

    k = 1
    j = 0
    bufferlabel = ''
    do i = 1, len_trim(line)
      if (line(i:i) == sep) then
        elements(k) = bufferlabel
        k = k+1
        j = 0
        bufferlabel = ''
        cycle
      end if
      j = j+1
      if (j > lenstring) cycle
      bufferlabel(j:j) = line(i:i)
    end do
    if (j > 0) then
      elements(k) = bufferlabel
    end if

  end subroutine

  pure function count_char(line, c) result(cpt)
    implicit none
    character(len=*), intent(in) :: line !< text to process
    character, intent(in) :: c !< character to search
    integer cpt !< Number of character found
    integer i

    cpt = 0
    do i = 1, len_trim(line)
      if (line(i:i) == c) then
        cpt = cpt+1
      end if
    end do
  end function

!> explicit the use of '$', '<' or '>' in the list of atoms
  subroutine explicit_atoms(linein, lineout, errormsg)
    implicit none
    character(len=*), intent(in) :: linein
    character(len=:), allocatable, intent(out) :: lineout
    character(len=:), allocatable, intent(out) :: errormsg
    character(len=2048) :: bufferline, expandlist
    logical reverse, collect
    type(atom_shelx_t) :: startlabel, endlabel, keyword
    integer cont, i, k
    character(len=lenlabel), dimension(:), allocatable :: splitbuffer

    bufferline = linein
    call to_upper(bufferline)

    do
      expandlist = ''

      ! looking for <,> shortcut
      cont = max(index(bufferline, '<'), index(bufferline, '>'))
      if (cont == 0) then
        exit
      end if

      if (cont > 0) then
        ! ensure spaces around operator
        bufferline = bufferline(1:cont-1)//' '//bufferline(cont:cont)//' '//trim(bufferline(cont+1:))
      end if

      ! extracting list of atoms, first removing duplicates spaces and keyword
      call deduplicates(bufferline)
      call explode(bufferline, lenlabel, splitbuffer)

      keyword = atom_shelx_t(splitbuffer(1))
      do i = 2, size(splitbuffer)
        if (trim(splitbuffer(i)) == '<' .or. trim(splitbuffer(i)) == '>') then
          startlabel = atom_shelx_t(splitbuffer(i-1))
          endlabel = atom_shelx_t(splitbuffer(i+1))
          if (trim(splitbuffer(i)) == '>') then
            reverse = .false.
          else
            reverse = .true.
          end if

          ! scanning atom list to find the implicit atoms
          if (reverse) then
            k = atomslist_index
          else
            k = 1
          end if
          collect = .false.
          do
            if (trim(atomslist(k)%label) == trim(startlabel%label)) then
              !found the first atom
              !write(log_unit, *) isor_table(i)%shelxline
              !write(*, *) 'Found start: ', trim(startlabel%label)
              if (startlabel%resi%is_set()) then
                if (atomslist(k)%resi == startlabel%resi) then
                  collect = .true.
                end if
              else if (keyword%resi%is_set()) then
                if (keyword%resi == atomslist(k)%resi) then
                  collect = .true.
                end if
              else
                collect = .true.
              end if
            end if
            if (reverse) then
              k = k-1
              if (k < 1) then
                if (collect) then
                  allocate (character(len=29+len_trim(endlabel%text)) :: errormsg)
                  write (errormsg, *) 'Error: Cannot find end atom ', trim(endlabel%text)
                else
                  allocate (character(len=31+len_trim(startlabel%text)) :: errormsg)
                  write (errormsg, *) 'Error: Cannot find first atom ', trim(startlabel%text)
                end if
                return
              end if
            else
              k = k+1
              if (k > atomslist_index) then
                if (collect) then
                  allocate (character(len=29+len_trim(endlabel%text)) :: errormsg)
                  write (errormsg, *) 'Error: Cannot find end atom ', trim(endlabel%text)
                else
                  allocate (character(len=31+len_trim(startlabel%text)) :: errormsg)
                  write (errormsg, *) 'Error: Cannot find first atom ', trim(startlabel%text)
                end if
                return
              end if
            end if
            !print *, K, trim(atomslist(k)%label),' ', trim(endlabel%label),' ', trim(atomslist(k)%label)==trim(endlabel%label)

            if (collect) then
              if (trim(atomslist(k)%label) == trim(endlabel%label)) then
                !found the first atom
                !write(log_unit, *) isor_table(i)%shelxline
                !write(*, *) 'Found end: ', trim(endlabel%label)
                if (startlabel%resi%is_set()) then
                  if (atomslist(k)%resi == startlabel%resi) then
                    exit
                  end if
                else if (keyword%resi%is_set()) then
                  if (keyword%resi == atomslist(k)%resi) then
                    exit
                  end if
                else
                  exit
                end if
              end if

              if (trim(sfac(atomslist(k)%sfac)) /= 'H' .and. &
              &   trim(sfac(atomslist(k)%sfac)) /= 'D') then
                ! adding the atom to the list
                expandlist = trim(expandlist)//' '//trim(atomslist(k)%label)
              end if
            end if
          end do

          bufferline = bufferline(1:cont-1)//' '//trim(expandlist)//' '//trim(bufferline(cont+1:))
        end if
      end do
    end do

    allocate (character(len=len_trim(bufferline)) :: lineout)
    lineout = trim(bufferline)

  end subroutine

!> return the identity matrix
  function matrix_eye(order)
    implicit none
    integer, intent(in) :: order !< order of the matrix
    real, dimension(order, order) :: matrix_eye !< identity matrix
    integer i

    matrix_eye = 0.0
    do i = 1, order
      matrix_eye(i, i) = 1.0
    end do
  end function

!> parse a shelx label, also constructor of read_atom_shelx
  function read_atom_shelx(atom_text) result(atom)
    implicit none
    character(len=*), intent(in) :: atom_text
    type(atom_shelx_t) :: atom
    integer i

    i = index(atom_text, '_')
    call atom%init()
    atom%text = atom_text
    if (i > 0) then
      atom%label = atom_text(1:i-1)
      if (atom_text(i+1:i+1) == '$') then
        ! symmetry operator
        read (atom_text(i+2:), *) atom%symmetry
      else if (atom_text(i+1:i+1) == '+') then
        atom%after = .true.
      else if (atom_text(i+1:i+1) == '-') then
        atom%previous = .true.
      else
        ! a number?
        if (ichar(atom_text(i+1:i+1)) > 47 .and. ichar(atom_text(i+1:i+1)) < 58) then
          read (atom_text(i+1:), *) atom%resi%number
        else if (len_trim(atom_text) > i+4) then
          ! an alias
          atom%resi%alias = atom_text(i+1:)
        else
          atom%resi%class = atom_text(i+1:)
        end if
      end if
    else
      atom%label = atom_text
    end if
  end function

!> Initialise resi_t type
  elemental subroutine init_resi(self)
    implicit none
    class(resi_t), intent(inout) :: self
    self%number = 0
    self%class = ''
    self%alias = ''
  end subroutine

!> initialise atom_shelx_t type
  elemental subroutine init_atom_shelx(self)
    implicit none
    class(atom_shelx_t), intent(inout) :: self
    self%text = ''
    self%label = ''
    call self%resi%init()
    self%symmetry = 0
    self%previous = .false.
    self%after = .false.
    self%resi_all = .false.
  end subroutine

!> Check if any residue is set
  function is_resi_set(resi) result(r)
    implicit none
    class(resi_t), intent(in) :: resi
    logical :: r

    r = .false.
    if (resi%number /= 0) then
      r = .true.
    else if (resi%class /= '') then
      r = .true.
    else if (resi%alias /= '') then
      r = .true.
    end if
  end function

!> compare 2 resi_t object type together
  function resi_compare(resi1, resi2) result(r)
    implicit none
    class(resi_t), intent(in) :: resi1, resi2
    logical :: r

    r = .true.
    if (resi1%number /= resi2%number) then
      r = .false.
    else if (resi1%class /= resi2%class) then
      r = .false.
    else if (resi1%alias /= resi2%alias) then
      r = .false.
    end if

  end function

!> negation of resi_compare
  function nresi_compare(resi1, resi2) result(r)
    implicit none
    class(resi_t), intent(in) :: resi1, resi2
    logical :: r
    r = .not. resi_compare(resi1, resi2)
  end function

!> compare atom_t and atom_shelx_t together
  function atom_compare_to_shelx(atom1, atom2) result(r)
    implicit none
    class(atom_t), intent(in) :: atom1
    class(atom_shelx_t), intent(in) :: atom2
    logical :: r

    r = .true.
    if (atom1%label /= atom2%label) then
      r = .false.
    else
      if (atom1%resi%is_set() .and. atom2%resi%is_set()) then
        r = atom1%resi == atom2%resi
      end if
    end if

  end function

!> compare atom_t and atom_shelx_t together
  function shelx_compare_to_atom(atom2, atom1) result(r)
    implicit none
    class(atom_t), intent(in) :: atom1
    class(atom_shelx_t), intent(in) :: atom2
    logical :: r

    r = atom_compare_to_shelx(atom1, atom2)
  end function

  function find_in_atom_list(atom) result(idatom)
    implicit none
    type(atom_shelx_t), intent(in) :: atom
    integer idatom
    integer i

    if (atom%resi_all) then
      print *, 'Cannot find an atom with all residues specifies'
      call abort()
    end if
    if (atom%previous .or. atom%after) then
      print *, 'Not implemented'
      call abort()
    end if

    do i = 1, size(atomslist)
      if (atom%resi%is_set()) then
        if (atom == atomslist(i)) then
          idatom = i
          return
        end if
      else
        if (atom%label == atomslist(i)%label) then
          idatom = i
          return
        end if
      endif
    end do

    idatom = 0

  end function

!> Return the list of residues given a class
  function resilist_from_class(classname) result(resilist)
    implicit none
    character(len=4), intent(in) :: classname !< name of the class
    integer i, cpt
    integer, dimension(:), allocatable :: resilist !< list of residue numbers

    cpt = 0
    do i = 1, resi_list_index
      if (resi_list(i)%class == classname) then
        cpt = cpt+1
      end if
    end do

    cpt = 0
    allocate (resilist(cpt))
    do i = 1, resi_list_index
      if (resi_list(i)%class == classname) then
        resilist(cpt) = resi_list(i)%number
      end if
    end do

  end function

!> Return a label in crystals format
  function crystals_label(self, symmetry) result(label)
    implicit none
    class(atom_t) :: self !< atom to format
    integer, intent(in), optional :: symmetry !< symmetry operator (index in eqiv_list)
    character(len=:), allocatable :: label
    character(len=128) :: buffer

    if (present(symmetry)) then
      if (symmetry > 0 .and. symmetry <= eqiv_list_index) then
        write (buffer, '(a,"(",3(I0,","),2(F0.3,","),F0.3,")")') &
        &   trim(sfac(self%sfac)), self%crystals_serial, &!
        &   eqiv_list(symmetry)%S, eqiv_list(symmetry)%L, eqiv_list(symmetry)%crystals_translation
      else
        write (buffer, '(a,"(",I0,")")') &
        &   trim(sfac(self%sfac)), self%crystals_serial
      end if
    else
      write (buffer, '(a,"(",I0,")")') &
      &   trim(sfac(self%sfac)), self%crystals_serial
    end if

    allocate (character(len=len_trim(buffer)) :: label)
    label = trim(buffer)

  end function

end module
