!> Crystallographic data of a structure during import from shelx
module crystal_data_m

logical, public :: the_end=.false. !< has the keyword END been reached

integer, parameter :: crystals_fileunit=1234 !< unit number for the crystals file ouput

type line_t
    integer :: line_number=1 !< Hold the line number from the shelx file
    character(len=:), allocatable :: line !< line content
end type

character(len=512), dimension(512) :: list1 !< Array holding list1 instructions
integer :: list1index=0 !< index in list1
character(len=512), dimension(512) :: list13 !< Array holding list13 instructions
integer :: list13index=0 !< index in list13
character(len=512), dimension(512) :: list12 !< Array holding list12 instructions
integer :: list12index=0  !< index in list12
character(len=512), dimension(4) :: list31=''  !< Array holding list31 instructions
character(len=512), dimension(5) :: composition=''  !< Array holding composition instructions

character(len=3), dimension(128) :: sfac='' !< List of atom types (sfac from shelx)
real, dimension(14, 128) :: sfac_long=0.0 !< a1 b1 a2 b2 a3 b3 a4 b4 c f' f" mu r wt coefficients (sfac from shelx)
real, dimension(128) :: sfac_units !< number of elements in unit cell
integer :: sfac_index=0 !< current index in sfac
real, dimension(:), allocatable :: fvar !< list of free variables (sfac from shelx)
real, dimension(6) :: unitcell=0.0 !< Array holding the unit cell parameters (a,b,c, alpha,beta,gamma). ANgle sin degree
integer :: residue=0 !< Current residue
character(len=128), dimension(:), allocatable :: residue_names !< Name or class of the residues
integer :: part=0 !< current part
real :: part_sof=-1.0 !< Overriding subsequent site occupation factor

type disp_t
    character(len=512) :: shelxline !< raw line from res/ins file
    integer :: line_number !< line number of shelxline from res/ins file
    character(len=3) :: atom
    real, dimension(3) :: values
end type
type(disp_t), dimension(:), allocatable :: disp_table !< List of disp keywords

!> Atom type. It holds hold the information about an atom in the structure
type atom_t
    character(len=6) :: label !< label from shelx
    integer :: sfac !< sfac from shelx
    real, dimension(3) :: coordinates !< x,y,z fractional coordinates from shelx
    real, dimension(6) :: aniso !< Anistropic displacement parameters U11 U22 U33 U23 U13 U12 from shelx
    real :: iso !< isotropic temperature factor from shelx
    real :: sof !< Site occupation factor from shelx
    integer resi !< residue from shelx
    integer part !< group from shelx
    character(len=512) :: shelxline !< raw line from res/ins file
    integer :: line_number !< line number of shelxline from res/ins file
    integer :: crystals_serial !< crystals serial code
end type
type(atom_t), dimension(:), allocatable :: atomslist !< list of atoms in the res/ins file
integer atomslist_index !< Current index in the list of atoms list (atomslist)

!> Space group type. All the lements describing the space group.
type spacegroup_t
    integer :: latt !< lattice type from shelx (1=P, 2=I, 3=rhombohedral obverse on hexagonal axes, 4=F, 5=A, 6=B, 7=C)
    character(len=128), dimension(32) :: symm !< list of symmetry element as seen in res/ins file
    integer :: symmindex=0 !< current index in symm
    character(len=128) :: symbol !< Space group symbol
end type
type(spacegroup_t), save :: spacegroup !< Hold the spagroup information

!> type DFIX
type dfix_t
    real :: distance, esd
    character(len=6) :: atom1, atom2
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=128) :: namedresidue !< Residue alias name
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(dfix_t), dimension(1024), save :: dfix_table
integer :: dfix_table_index=0

!> type MPLA
type mpla_t
    character(len=6), dimension(:), allocatable :: atoms
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=128) :: namedresidue='' !< Residue alias
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(mpla_t), dimension(1024), save :: mpla_table
integer :: mpla_table_index=0

!> type EADP
type eadp_t
    character(len=6), dimension(:), allocatable :: atoms
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=128) :: namedresidue='' !< Residue alias
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(eadp_t), dimension(1024), save :: eadp_table
integer :: eadp_table_index=0

!> type RIGU
type rigu_t
    character(len=6), dimension(:), allocatable :: atoms
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=128) :: namedresidue='' !< Residue alias
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
    real :: s1, s2
end type
type(rigu_t), dimension(1024), save :: rigu_table
integer :: rigu_table_index=0

!> type SADI
type sadi_t
    real :: esd
    character(len=6), dimension(:,:), allocatable :: atom_pairs !< pairs of atoms 
    integer :: residue=-99 !< Residue number -99=None, -98=alias residue, -1=all, else is the residue number
    character(len=128) :: namedresidue='' !< Alias of a residue
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(sadi_t), dimension(1024), save :: sadi_table
integer :: sadi_table_index=0

!> type SAME
type same_t
    character(len=1024) :: shelxline
    character(len=6), dimension(:), allocatable :: list1
    character(len=6), dimension(:), allocatable :: list2
end type
type(same_t), dimension(1024) :: same_table
integer :: same_table_index=0
integer :: same_processing=-1 !< flag if we are currently processing a same instruction. -1: nothing to do. >=0: working on it

contains

!> Transform a string to upper case
elemental function to_upper(strIn) result(strOut)
 implicit none

 character(len=*), intent(in) :: strIn !< mixed case input
 character(len=len(strIn)) :: strOut !< upper case output
 integer :: i,j

     do i = 1, len(strIn)
          j = iachar(strIn(i:i))
          if (j>= iachar("a") .and. j<=iachar("z") ) then
               strOut(i:i) = achar(iachar(strIn(i:i))-32)
          else
               strOut(i:i) = strIn(i:i)
          end if
     end do

end function to_upper

!> Remove repeated separators. Default separator is space
function deduplicates(line, sep_arg) result(strip)
implicit none
character(len=*), intent(in) :: line !< text to process
character, intent(in), optional :: sep_arg !< Separator to deduplicate
character(len=:), allocatable :: strip
character(len=len_trim(line)) :: buffer
integer i,k, sepfound
character sep

    if(present(sep_arg)) then
        sep=sep_arg
    else
        sep=' '
    end if

    buffer=''
    k=0
    sepfound=1
    do i=1, len_trim(line)
        if(line(i:i)/=sep) then
            sepfound=0
            k=k+1
            buffer(k:k)=line(i:i)
        else
            if(sepfound==0) then
                k=k+1
                buffer(k:k)=line(i:i)                
                sepfound=sepfound+1
            end if
        end if
    end do

    buffer=adjustl(buffer)    
    allocate(character(len=len_trim(buffer)) :: strip)
    strip=buffer(1:len_trim(buffer))

end function

!> Split a string into different pieces given a separator. Defaul separator is space.
!! Len of pieces must be passed to the function
function explode(line, lenstring, sep_arg) result(elements)
implicit none
character(len=*), intent(in) :: line !< text to process
integer lenstring !< length of each individual elements
character, intent(in), optional :: sep_arg !< Separator 
character(len=lenstring), dimension(:), allocatable :: elements
character(len=lenstring) :: bufferlabel
integer i, j, k
character sep

    if(present(sep_arg)) then
        sep=sep_arg
    else
        sep=' '
    end if
    
    allocate(elements(count_char(line, ' ')+1))

    k=1
    j=0
    bufferlabel=''
    do i=1, len_trim(line)
        if(line(i:i)==sep) then
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
    if(j>0) then
        elements(k)=bufferlabel
    end if
    
end function

function count_char(line, c) result(cpt)
implicit none
character(len=*), intent(in) :: line !< text to process
character, intent(in) :: c !< character to search
integer cpt !< Number of character found
integer i

    cpt=0
    do i=1, len_trim(line)
        if(line(i:i)==c) then
            cpt=cpt+1
        end if
    end do
end function


end module
