!> Crystallographic data of a structure during import from shelx
module crystal_data_m

logical, public :: the_end=.false. !< has the keyword END been reached

integer, parameter :: crystals_fileunit=1234 !< unit number for the crystals file ouput
integer :: log_unit
integer, parameter :: lenlabel=12
integer, parameter :: line_length=72

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
    character(len=lenlabel) :: label !< label from shelx
    integer :: sfac !< sfac from shelx
    real, dimension(3) :: coordinates !< x,y,z fractional coordinates from shelx
    real, dimension(6) :: aniso !< Anistropic displacement parameters U11 U22 U33 U23 U13 U12 from shelx
    real :: iso !< isotropic temperature factor from shelx
    real :: sof !< Site occupation factor from shelx
    integer :: multiplicity !< multiplicity (calculated)
    integer resi !< residue from shelx
    integer part !< group from shelx
    character(len=512) :: shelxline !< raw line from res/ins file
    integer :: line_number !< line number of shelxline from res/ins file
    integer :: crystals_serial !< crystals serial code
end type
type(atom_t), dimension(:), allocatable :: atomslist !< list of atoms in the res/ins file
integer atomslist_index !< Current index in the list of atoms list (atomslist)

!> Symmetry operators
type SeitzMx_t
    integer, dimension(3,3) :: R !< rotation part of the symmetry
    integer, dimension(3) :: T !< translation * 12 (see sginfo and STBF)
end type

!> Space group type. All the lements describing the space group.
type spacegroup_t
    integer :: latt !< lattice type from shelx (1=P, 2=I, 3=rhombohedral obverse on hexagonal axes, 4=F, 5=A, 6=B, 7=C)
    character(len=128), dimension(32) :: symm !< list of symmetry element read from res/ins file
    integer :: symmindex=0 !< current index in symm
    character(len=128) :: symbol !< Space group symbol
    type(SeitzMx_t), dimension(:), allocatable :: ListSeitzMx !< list of symmetry operators as matrices, see sginfo
    integer :: centric 
end type
type(spacegroup_t), save :: spacegroup !< Hold the spagroup information

!> type DFIX
type dfix_t
    real :: distance, esd
    character(len=lenlabel) :: atom1, atom2
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=128) :: namedresidue !< Residue alias name
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(dfix_t), dimension(1024), save :: dfix_table
integer :: dfix_table_index=0

!> type FLAT
type flat_t
    character(len=lenlabel), dimension(:), allocatable :: atoms
    real esd !< esd of the restraint
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=128) :: namedresidue='' !< Residue alias
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(flat_t), dimension(1024), save :: flat_table
integer :: flat_table_index=0

!> type EADP
type eadp_t
    character(len=lenlabel), dimension(:), allocatable :: atoms
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    character(len=128) :: namedresidue='' !< Residue alias
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(eadp_t), dimension(1024), save :: eadp_table
integer :: eadp_table_index=0

!> type ISOR
type isor_t
    character(len=lenlabel), dimension(:), allocatable :: atoms
    integer :: residue=-99 !< Residue number -99=None, -1=all, else is the residue number
    real :: esd1, esd2 !< if the atom is terminal (or makes no bonds), esd2 is used instead of esd1
    character(len=128) :: namedresidue='' !< Residue alias
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(isor_t), dimension(1024), save :: isor_table
integer :: isor_table_index=0

!> type RIGU
type rigu_t
    character(len=lenlabel), dimension(:), allocatable :: atoms
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
    character(len=lenlabel), dimension(:,:), allocatable :: atom_pairs !< pairs of atoms 
    integer :: residue=-99 !< Residue number -99=None, -98=alias residue, -1=all, else is the residue number
    character(len=128) :: namedresidue='' !< Alias of a residue
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
end type
type(sadi_t), dimension(1024), save :: sadi_table
integer :: sadi_table_index=0

!> type SAME
type same_t
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
    character(len=lenlabel), dimension(:), allocatable :: list1 !< reference atoms
    character(len=lenlabel), dimension(:), allocatable :: list2 !< target atoms
    real esd1, esd2 !< esds
    character(len=128) :: namedresidue !< Residue alias
    integer :: residue !< Residue number -99=None, -1=all, else is the residue number
end type
type(same_t), dimension(1024) :: same_table
integer :: same_table_index=0

!> type info. List of warning saved for printing at the end so they don't get lost
type info_t
    character(len=1024) :: shelxline !< raw instruction line from res file
    integer :: line_number !< Line number form res file
    character(len=1024) :: text
end type
type(info_t), dimension(1024) :: info_table
integer :: info_table_index=0

contains

!> Transform a string to upper case
elemental subroutine to_upper(strIn, strOut)
 implicit none

 character(len=*), intent(inout) :: strIn !< mixed case input
 character(len=len(strIn)), intent(out), optional :: strOut !< upper case output
 integer :: i,j

     do i = 1, len(strIn)
          j = iachar(strIn(i:i))
          if (j>= iachar("a") .and. j<=iachar("z") ) then
               if(present(strOut)) then
                   strOut(i:i) = achar(iachar(strIn(i:i))-32)
               else 
                   strIn(i:i) = achar(iachar(strIn(i:i))-32)
               end if
          else
               if(present(strOut)) then
                   strOut(i:i) = strIn(i:i)
               end if
          end if
     end do

end subroutine to_upper

!> Remove repeated separators. Default separator is space
subroutine deduplicates(line, strip, sep_arg)
implicit none
character(len=*), intent(in) :: line !< text to process
character, intent(in), optional :: sep_arg !< Separator to deduplicate
character(len=:), allocatable, intent(out) :: strip
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
    strip=trim(buffer)

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
    
end subroutine

pure function count_char(line, c) result(cpt)
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

!> explicit the use of '<' or '>' in the list of atoms
subroutine explicit_atoms(linein, lineout, errormsg)
implicit none
character(len=*), intent(in) :: linein
character(len=:), allocatable, intent(out) :: lineout
character(len=:), allocatable, intent(out) :: errormsg
character(len=:), allocatable :: stripline
character(len=:), allocatable :: bufferline
logical reverse, collect
character(len=6) :: startlabel, endlabel, buffer
integer cont, k, j, startresidue, endresidue, tagresidue

    startresidue=0
    endresidue=0
   
    ! extracting list of atoms, first removing duplicates spaces and keyword
    call deduplicates(linein, bufferline)
    call to_upper(bufferline)
    allocate(character(len=4096) :: stripline)
    stripline=bufferline
    deallocate(bufferline)
    allocate(character(len=4096) :: bufferline)
    
    ! checking for a residue number on the command
    buffer=''
    if(index(linein, '_')==5) then
        k=5
        do
            k=k+1
            if(linein(k:k)/=' ') then
                buffer=trim(buffer)//linein(k:k)
            else
                exit
            end if
        end do
        read(buffer, *) tagresidue
    else
        tagresidue=0
    end if
    
    ! looking for <,> shortcut
    cont=max(index(stripline, '<'), index(stripline, '>'))
    !write(log_unit, *) '*************** ', cont
    do while(cont>0)
        if(index(stripline, '<')==cont) then    
            reverse=.true.
        else
            reverse=.false.
        end if
    
        ! found < or >, expliciting atom list
        bufferline=stripline(1:cont-1)
        
        ! first searching for label on the right
        if(stripline(cont+1:cont+1)==' ') cont=cont+1        
        j=0
        endlabel=''
        do k=cont+1, len_trim(stripline)
            if(stripline(k:k)==' ' .or. stripline(k:k)=='<' .or. stripline(k:k)=='>') then
                exit
            end if
            j=j+1
            endlabel(j:j)=stripline(k:k)
        end do  
        ! check for residue
        k=index(endlabel, '_')
        if(k>0) then
            read(endlabel(k+1:), *) endresidue
            endlabel=endlabel(1:k-1)
        end if
        
        ! then looking for label on the left
        cont=max(index(stripline, '<'), index(stripline, '>'))
        if(stripline(cont-1:cont-1)==' ') cont=cont-1        
        j=7
        startlabel=''
        do k=cont-1, 1, -1
            if(stripline(k:k)==' ' .or. stripline(k:k)=='<' .or. stripline(k:k)=='>') then
                exit
            end if
            j=j-1
            startlabel(j:j)=stripline(k:k)
        end do  
        startlabel=adjustl(startlabel)
        ! check for residue
        k=index(startlabel, '_')
        if(k>0) then
            read(startlabel(k+1:), *) startresidue
            startlabel=startlabel(1:k-1)
        end if

        ! scanning atom list to find the implicit atoms
        if(reverse) then
            k=atomslist_index
        else
            k=1
        end if
        collect=.false.
        do 
            if(trim(atomslist(k)%label)==trim(startlabel)) then
                !found the first atom
                !write(log_unit, *) isor_table(i)%shelxline
                !write(log_unit, *) 'Found start: ', trim(startlabel)
                if(startresidue/=0) then
                    if(startresidue==atomslist(k)%resi) then
                        collect=.true.
                    end if
                else if (tagresidue/=0) then
                    if(tagresidue==atomslist(k)%resi) then
                        collect=.true.
                    end if
                else
                    collect=.true.
                end if
            end if
            if(reverse) then
                k=k-1
                if(k<1) then
                    if(collect) then
                        allocate(character(len=32+len_trim(endlabel)) :: errormsg)
                        write(errormsg, *) 'Error: Cannot find end atom ', trim(endlabel)
                    else
                        allocate(character(len=32+len_trim(startlabel)) :: errormsg)
                        write(errormsg, *) 'Error: Cannot find first atom ', trim(startlabel)
                    end if
                    return
                end if
            else
                k=k+1
                if(k>atomslist_index) then
                    if(collect) then
                        allocate(character(len=32+len_trim(endlabel)) :: errormsg)
                        write(errormsg, *) 'Error: Cannot find end atom ', trim(endlabel)
                    else
                        allocate(character(len=32+len_trim(startlabel)) :: errormsg)
                        write(errormsg, *) 'Error: Cannot find first atom ', trim(startlabel)
                    end if
                    return
                end if
            end if
            if(collect) then
                if(trim(atomslist(k)%label)==trim(endlabel)) then
                    !write(log_unit, *) 'Found end: ', trim(endlabel)
                    !write(log_unit, *) 'Done!!!!!'
                    ! job done
                    if(startresidue/=0) then
                        if(startresidue==atomslist(k)%resi) then
                            exit
                        end if
                    else if (tagresidue/=0) then
                        if(tagresidue==atomslist(k)%resi) then
                            exit
                        end if
                    else
                        exit
                    end if
                end if
                
                if(trim(sfac(atomslist(k)%sfac))/='H' .and. &
                &   trim(sfac(atomslist(k)%sfac))/='D') then
                    ! adding the atom to the list
                    bufferline=trim(bufferline)//' '//trim(atomslist(k)%label)
                end if
            end if
        end do
        ! concatenating the remaining
        bufferline=trim(bufferline)//' '//&
        &   trim(adjustl(stripline(max(index(stripline, '<'), index(stripline, '>'))+1:)))

        !write(log_unit, *) trim(stripline)
        !write(log_unit, *) trim(bufferline)
        stripline=bufferline
        cont=max(index(stripline, '<'), index(stripline, '>'))
    end do
        
    allocate(character(len=len_trim(stripline)) :: lineout)
    lineout=trim(stripline)
        
end subroutine

!> Extract any residue information from an instruction or an atom
subroutine get_residue(txtin, label, resi_num, resi_name)
implicit none
character(len=*), intent(in) :: txtin
integer, intent(out) :: resi_num
character(len=lenlabel), intent(out) :: label
character(len=128), intent(out) :: resi_name
integer ipos, iostatus

    resi_num=0
    resi_name=''

    ipos=index(txtin, '_')
    if(ipos==0) then
        label=txtin
        return
    end if
    
    ! We have a residue
    label=txtin(1:ipos-1)
    
    read(txtin(ipos+1:), *, iostat=iostatus) resi_num
    if(iostatus/=0) then 
        ! not a number
        resi_num=0
        resi_name=txtin(ipos+1:)
    end if
    
end subroutine
    

end module
