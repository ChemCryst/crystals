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
real, dimension(:), allocatable :: fvar !< list of free variables (sfac from shelx)
real, dimension(6) :: unitcell=0.0 !< Array holding the unit cell parameters (a,b,c, alpha,beta,gamma). ANgle sin degree
integer :: residue=0 !< Current residue
integer :: part=0 !< current part

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
type(spacegroup_t) :: spacegroup !< Hold the spagroup information

!> type DFIX
type dfix_t
    real :: distance, esd
    character(len=6) :: atom1, atom2
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(dfix_t), dimension(1024) :: dfix_table
integer :: dfix_table_index=0

contains

!> Transform a string to upper case
function to_upper(strIn) result(strOut)
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

end module
