!> This module holds the different subroutines for shel2cry
!! 
module shelx2cry_mod
integer, private, save :: line_number=1 !< Hold the line number from the shelx file

!> List of shelx keywords
character(len=4), dimension(77), parameter , private:: shelx_keywords=(/ &
&   'ABIN', 'ACTA', 'AFIX', 'ANIS', 'ANSC', 'ANSR', 'BASF', 'BIND', 'BLOC', &
&   'BOND', 'BUMP', 'CELL', 'CGLS', 'CHIV', 'CONF', 'CONN', 'DAMP', 'DANG', &
&   'DEFS', 'DELU', 'DFIX', 'DISP', 'EADP', 'END ', 'EQIV', 'EXTI', 'EXYZ', &
&   'FEND', 'FLAT', 'FMAP', 'FRAG', 'FREE', 'FVAR', 'GRID', 'HFIX', 'HKLF', &
&   'HTAB', 'ISOR', 'LATT', 'LAUE', 'LIST', 'L.S.', 'MERG', 'MORE', 'MOVE', &
&   'MPLA', 'NCSY', 'NEUT', 'OMIT', 'PART', 'PLAN', 'PRIG', 'REM ', 'RESI', &
&   'RIGU', 'RTAB', 'SADI', 'SAME', 'SFAC', 'SHEL', 'SIMU', 'SIZE', 'SPEC', &
&   'STIR', 'SUMP', 'SWAT', 'SYMM', 'TEMP', 'TITL', 'TWIN', 'TWST', 'UNIT', &
&   'WGHT', 'WIGL', 'WPDB', 'XNPD', 'ZERR' /) 


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
logical :: the_end=.false. !< has the keyword END been reached

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

!> Read a line of the res/inf file. If line is split using `=`, reconstruct the full line.
subroutine readline(shelxf_id, line, current_line, iostatus)
implicit none
integer, intent(in) :: shelxf_id !< res/ins file unit number
character(len=:), allocatable, intent(out) :: line !< Line read from res/ins file
integer, intent(out) :: current_line !< Line number of the line just read in res/ins file
integer, intent(out) :: iostatus !< status of the read
character(len=1024) :: buffer
character(len=:), allocatable :: linetemp
integer first

current_line=line_number
first=0
do
    read(shelxf_id, '(a)', iostat=iostatus) buffer
    if(iostatus/=0) then
        line=''
        return
    end if
    line_number=line_number+1
    first=first+1
    if(first==1 .and. buffer(1:1)==' ') then ! cycle except if continuation line
        first=0
        cycle 
    end if
    if(allocated(line)) then
        ! appending new text
        allocate(character(len=len_trim(line)) :: linetemp)
        linetemp=line
        deallocate(line)
        allocate(character(len=len(linetemp)+len_trim(buffer)) :: line)
        line=linetemp
        deallocate(linetemp)
    else        
        allocate(character(len=len_trim(buffer)) :: line)
        line=''
    end if
    if(len_trim(line)>0) then
        line=trim(line)//' '//trim(buffer)
    else
        line=trim(buffer)
    end if

    if(line(len_trim(line):len_trim(line))/='=') then
        ! end of line
        return
    else
        ! Continuation line present, appending next line...
        ! removing continuation symbol
        line(len_trim(line)-1:len_trim(line))=' '
    end if
end do

end subroutine

!> Process a line from the res/ins file. 
!! The subroutine is looking for shelx keywords and calling the adhoc subroutine.
subroutine call_shelxprocess(line)
implicit none
character(len=*), intent(in) :: line !< line from res/ins file
character(len=4) :: keyword
logical found

character(len=6) :: label
integer atomtype, iostatus
real, dimension(3) :: coordinates
real occupancy
real, dimension(6) :: aniso
real iso
integer i

found=.false.

if(len_trim(line)<3) then
    return
end if

! 4 letters keywords first
if(len_trim(line)>3) then
    keyword=line(1:4)
    select case (keyword)
        case ('TITL')
        call shelx_titl(line)
        found=.true.

        case ('CELL')
        call shelx_cell(line)
        found=.true.

        case ('ZERR')
        call shelx_zerr(line)
        found=.true.

        case ('SFAC')
        call shelx_sfac(line)
        found=.true.

        case ('FVAR')
        call shelx_fvar(line)
        found=.true.

        case ('UNIT')
        call shelx_unit(line)
        found=.true.

        case ('LATT')
        call shelx_latt(line)
        found=.true.

        case ('SYMM')
        call shelx_symm(line)
        found=.true.

        case ('RESI')
        call shelx_resi(line)
        found=.true.

        case ('PART')
        call shelx_part(line)
        found=.true.

        case ('DFIX')
        call shelx_dfix(line)
        found=.true.
    end select 
end if

! 3 letters keywords 
keyword=line(1:3)
select case (keyword)
    case ('REM')
    call shelx_rem(line)
    found=.true.

    case ('END')
    call shelx_end(line)
    found=.true.

end select 
! deprecated keywords
if(line(1:4)=='TIME' .or. line(1:4)=='HOPE' .or. line(1:4)=='MOLE') then
	write(*, '(a)') 'Keywords `TIME`, `TIME` and `MOLE` are deprecated and therefore ignored'
	write(*, '(a,I0,a, a)') 'Line ', line_number,': ', trim(line)
	return
end if

if(found) return

! Check for any valid keyword that we do not handle yet
do i=1, size(shelx_keywords)
    if(len_trim(line)>3) then
        if(line(1:4)==shelx_keywords(i)) then
			write(*, '(a,a,a)') 'Found `', trim(shelx_keywords(i)), '` keyword which is not supported by crystals: '
			write(*, '(a,I0,a, a)') 'Line ', line_number,': ', trim(line)
			return
		end if
    end if
end do

! there is something but it is not a keyword.
! Check for atoms:

! No keyword found, probably an atom list
! O1    4    0.560776    0.256941    0.101770    11.00000    0.07401    0.12846 0.04453   -0.00865    0.01598   -0.01300
read(line, *, iostat=iostatus) label, atomtype, coordinates, occupancy, aniso 
if(iostatus==0) then
   call shelxl_atomaniso(label, atomtype, coordinates, occupancy, aniso, line)
end if

! try without aniso parameter
if(iostatus/=0) then
    !H1N   2    0.426149    0.251251    0.038448    11.00000   -1.20000
    read(line, *, iostat=iostatus) label, atomtype, coordinates, occupancy, iso 
    if(iostatus==0) then
       call shelxl_atomiso(label, atomtype, coordinates, occupancy, iso, line)
    end if
end if

! try with just the coordinates
if(iostatus/=0) then
    !H1N   2    0.426149    0.251251    0.038448    11.00000   -1.20000
    read(line, *, iostat=iostatus) label, atomtype, coordinates
    if(iostatus==0) then
       call shelxl_atomiso(label, atomtype, coordinates, 1.0, 0.05, line)
    end if
end if

!if(.not. found) then
!    print *, 'unknwon keyword ', line(1:min(4, len_trim(line))), ' on line ', line_number
!end if

end subroutine

!> Parse the TITL keyword. Extract the space group name
subroutine shelx_titl(line)
implicit none
character(len=*), intent(in) :: line
integer start

! extract space group
start=index(line, 'in ')
spacegroup%symbol=line(start+3:)

!print *, line_number, ' Processing TITL' 
end subroutine

!> Parse the DFIX keyword. Restrain bond distances
subroutine shelx_dfix(line)
implicit none
character(len=*), intent(in) :: line
integer linepos, i, j
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
character(len=128) :: buffer, buffer2
real distance, esd
integer :: residue

!print *, line

! parsing more complicated on this one as we don't know the number of parameters
linepos=4 ! First 4 is DFIX

! check for `_*̀
residue=-99
if(line(5:5)=='_') then
	if(line(6:6)=='*') then
		residue=-1
	else
		found=.false.
		do i=1, 10
			if(line(6:6)==numbers(i)) then
				found=.true.
				read(line(6:6), *) residue
				exit
			end if
		end do
	end if
	linepos=6
end if

do while(linepos<=len(line))
	linepos=linepos+1
	if(line(linepos:linepos)/=' ') exit
end do
if(linepos>len(line)) then
	write(*,*) ' I have not found anything after DFIX'
	write(*,*) line
	stop
end if

! we have something, must be the distance
buffer=''
do while(line(linepos:linepos)/=' ')
	found=.false.
	do i=1, size(numbers)
		if(line(linepos:linepos)==numbers(i)) then
			found=.true.
			exit
		end if
	end do
	if(.not. found) then
		! no number.
		write(*,*) 'Expected a number but got ', line(linepos:linepos)
		write(*,*) line
		write(*,*) repeat(' ', linepos-1), '^'
		stop
	end if
	buffer=trim(buffer)//line(linepos:linepos)
	linepos=linepos+1
end do
! number read, lets convert it to a proper one
read(buffer, *) distance

! skip spaces again
do while(linepos<=len(line))
	if(line(linepos:linepos)/=' ') exit
	linepos=linepos+1
end do
if(linepos>len(line)) then
	write(*,*) ' I have not found the esd or atom definition'
	write(*,*) line
	stop
end if
	
! we have something, must be esd or atom
found=.false.
do i=1, size(numbers)
	if(line(linepos:linepos)==numbers(i)) then
		found=.true.
		exit
	end if
end do
if(found) then
	! it's a number!
	buffer=''
	do while(line(linepos:linepos)/=' ')
		found=.false.
		do i=1, size(numbers)
			if(line(linepos:linepos)==numbers(i)) then
				found=.true.
				exit
			end if
		end do
		if(.not. found) then
			write(*,*) 'Expected a number but got ', line(linepos:linepos)
			write(*,*) line
			write(*,*) repeat(' ', linepos-1), '^'
			stop
		end if
		buffer=trim(buffer)//line(linepos:linepos)
		linepos=linepos+1
	end do
	! number read, lets convert it to a proper one
	read(buffer, *) esd
else
	esd=0.02
end if	

! fetch now the list of atoms
do
	!print *, trim(line(linepos:))
	! skip spaces again
	do while(linepos<=len(line))
		if(line(linepos:linepos)/=' ') exit
		linepos=linepos+1
	end do
	if(linepos>len(line)) exit
	! get atom
	buffer=''
	do while(line(linepos:linepos)/=' ')
		buffer=trim(buffer)//line(linepos:linepos)
		linepos=linepos+1
		if(linepos>len(line)) exit
	end do

	! get second atom
	do while(linepos<=len(line))
		linepos=linepos+1
		if(line(linepos:linepos)/=' ') exit
	end do
	if(linepos>len(line)) exit
	buffer2=''
	do while(line(linepos:linepos)/=' ')
		buffer2=trim(buffer2)//line(linepos:linepos)
		linepos=linepos+1
		if(linepos>len(line)) exit		
	end do
	
	!print *, trim(buffer), '++', trim(buffer2)
	!print *, linepos, len(line)
	dfix_table_index=dfix_table_index+1
	dfix_table(dfix_table_index)%distance=distance
	dfix_table(dfix_table_index)%esd=esd
	dfix_table(dfix_table_index)%atom1=trim(buffer)
	dfix_table(dfix_table_index)%atom2=trim(buffer2)
	dfix_table(dfix_table_index)%shelxline=trim(line)
	dfix_table(dfix_table_index)%line_number=line_number
	dfix_table(dfix_table_index)%residue=residue
end do

end subroutine

!> Parse the REM keryword. Do nothing
subroutine shelx_rem(line)
implicit none
character(len=*), intent(in) :: line

!print *, line_number, ' Processing REM' 
end subroutine

!> Pars the CELL keyword. Extract the unit cell parameter and wavelength
subroutine shelx_cell(line)
implicit none
character(len=*), intent(in) :: line
real :: wave
character dummy

!CELL 1.54187 14.8113 13.1910 14.8119 90 98.158 90
read(line, *) dummy, wave, unitcell
list1index=list1index+1
write(list1(list1index), '(a5,1X,6(F0.5,1X))') 'REAL ', unitcell
list13index=list13index+1
write(list13(list13index), '(a,F0.5)') 'COND WAVE= ', wave

!print *, line_number, ' Processing CELL' 
end subroutine

!> Parse the ZERR keyword. Extract the esds on the unit cell parameters
subroutine shelx_zerr(line)
implicit none
character(len=*), intent(in) :: line
real, dimension(7) :: esds

read(line(5:), *) esds
write(list31(1), '(a)') '\LIST 31'
write(list31(2), '("MATRIX V(11)=",F0.5, ", V(22)=",F0.5, ", V(33)=",F0.5)') esds(2:4)
write(list31(3), '("CONT V(44)=",F0.5, ", V(55)=",F0.5, ", V(66)=",F0.5)') esds(5:7)
write(list31(4), '(a)') 'END'

!print *, line_number, ' Processing CELL' 
end subroutine

!> Parse the FVAR keyword. Extract the overall scale parameter and free variable
subroutine shelx_fvar(line)
implicit none
character(len=*), intent(in) :: line
real, dimension(1024) :: temp ! should be more than enough
integer iostatus, i

temp=0.0
read(line(5:), *, iostat=iostatus) temp(1:3)
if(temp(1024)/=0.0) then
    print *, 'More than 1024 free variable?!?!'
    call abort()
end if
do i=1024,1,-1
    if(temp(i)/=0.0) exit
end do
allocate(fvar(i))
fvar=temp(1:i)

!print *, line_number, ' Processing CELL' 
end subroutine

!> Parse the SFAC keyword. Extract the atoms type use in the file.
subroutine shelx_sfac(line)
implicit none
character(len=*), intent(in) :: line
integer i, j, k, code
character(len=3) :: buffer

sfac=''
k=0

i=5
do while(i<=len_trim(line))
    if(line(i:i)==' ') then
        i=i+1
        cycle
    end if
    
    buffer=''
    j=0
    do while(line(i:i)/=' ')
        code=iachar(line(i:i))
        if( (code<65 .and. code>90) .or. (code<97 .and. code>122) ) then
            print *, 'Error in SFAC'
            call abort()
        end if
        j=j+1
        buffer(j:j)=line(i:i)
        i=i+1
        if(i>len_trim(line)) exit
    end do
    k=k+1
    sfac(k)=buffer
end do   

!print *, line_number, ' Processing SFAC' 
end subroutine

!> Parse the UNIT keyword. Extract the number of each atomic elements.
!! Write the corresponding `composition` command for crystals
subroutine shelx_unit(line)
implicit none
character(len=*), intent(in) :: line
integer i, j, k, code, iostatus
character(len=3) :: buffer
real, dimension(128) :: units
!SFAC C H N O
!UNIT 116 184 8 8
!
! \COMPOSITION
! CONTENT C 6 H 5 N O 2.5 CL
! SCATTERING CRSCP:SCATT.DAT
! PROPERTIES CRSCP:PROPERTIES.DAT
! END

units=0
k=0

i=5
do while(i<=len_trim(line))
    if(line(i:i)==' ') then
        i=i+1
        cycle
    end if
    
    buffer=''
    j=0
    do while(line(i:i)/=' ')
        read(buffer, '(I1)', iostat=iostatus) code
        if(iostatus/=0 .and. line(i:i)/='.') then
            print *, 'Wrong input in UNIT'
            call abort()
        end if
        j=j+1
        buffer(j:j)=line(i:i)
        i=i+1
        if(i>len_trim(line)) exit
    end do
    k=k+1
    read(buffer, *, iostat=iostatus) units(k)
end do   

composition(1)='\COMPOSITION'
!CONTENT C 6 H 5 N O 2.5 CL
composition(2)='CONTENT '
do i=1, k
    if(abs(nint(units(i))-units(i))<0.01) then
        write(buffer, '(I0)') nint(units(i))
    else
        write(buffer, '(F0.2)') units(i)
    end if
    composition(2)=trim(composition(2))//' '//trim(sfac(i))//' '//trim(buffer)
end do
! SCATTERING CRSCP:SCATT.DAT
composition(3)='SCATTERING CRYSDIR:script/scatt.dat'
! PROPERTIES CRSCP:PROPERTIES.DAT
composition(4)='PROPERTIES CRYSDIR:script/propwin.dat'
! END
composition(5)='END'
    
!print *, line_number, ' Processing UNITS' 
end subroutine
 
!> Parse the LATT keyword. Extract the lattice type.
subroutine shelx_latt(line)
implicit none
character(len=*) :: line

read(line(5:), *) spacegroup%latt

end subroutine

!> Parse the SYMM keyword. Extract the symmetry operators as text.
subroutine shelx_symm(line)
implicit none
character(len=*) :: line

spacegroup%symmindex=spacegroup%symmindex+1
read(line(5:), '(a)') spacegroup%symm(spacegroup%symmindex)

end subroutine

!> Parse the atom parameters when adps are present.
subroutine shelxl_atomaniso(label, atomtype, coordinates, sof, aniso, line)
implicit none
character(len=*), intent(in) :: label !< shelxl label
integer, intent(in) :: atomtype !< atom type as integer (position in sfac)
real, dimension(:), intent(in) :: coordinates !< atomic coordinates
real, intent(in) :: sof !< site occupation factor (sof) from shelx
real, dimension(6), intent(in) :: aniso !< adps U11 U22 U33 U23 U13 U12
character(len=*) :: line
integer i
 
if(.not. allocated(atomslist)) then
    allocate(atomslist(1024))
    atomslist_index=0
    atomslist%label=''
    atomslist%sfac=0
    do i=1, size(atomslist)
        atomslist(i)%coordinates=0.0
        atomslist(i)%aniso=0.0
    end do
    atomslist%iso=0.0
    atomslist%sof=0.0
    atomslist%resi=0
    atomslist%part=0
    atomslist%shelxline=''
    atomslist%crystals_serial=-1
end if

atomslist_index=atomslist_index+1
atomslist(atomslist_index)%label=label
atomslist(atomslist_index)%sfac=atomtype
atomslist(atomslist_index)%coordinates=coordinates
atomslist(atomslist_index)%aniso=aniso
atomslist(atomslist_index)%sof=sof
atomslist(atomslist_index)%resi=residue
atomslist(atomslist_index)%part=part
atomslist(atomslist_index)%shelxline=line
atomslist(atomslist_index)%line_number=line_number
end subroutine

!> Parse the atom parameters when adps are not present but isotropic temperature factor.
subroutine shelxl_atomiso(label, atomtype, coordinates, sof, iso, line)
implicit none
character(len=*), intent(in) :: label!< shelxl label
integer, intent(in) :: atomtype !< atom type as integer (position in sfac)
real, dimension(:), intent(in) :: coordinates !< atomic coordinates
real, intent(in) :: sof !< site occupation factor (sof) from shelx
real, intent(in) :: iso !< isotropic temperature factor
integer i, j, k
character(len=*) :: line
real, dimension(3,3) :: orthogonalisation, uij, metric, rmetric
double precision, dimension(3,3) :: temp
double precision, dimension(3) :: eigv
real, dimension(6) :: unitcellradian
real rgamma
logical ok_flag

unitcellradian(1:3)=unitcell(1:3)
unitcellradian(4:6)=unitcell(4:6)*2.0*3.14159/360.0

rgamma=acos((cos(unitcellradian(4))*cos(unitcellradian(5))-cos(unitcellradian(6)))/&
&   (sin(unitcellradian(4))*sin(unitcellradian(5))))
orthogonalisation=0.0
orthogonalisation(1,1) = unitcellradian(1)*sin(unitcellradian(5))*sin(rgamma)
orthogonalisation(2,1) = -unitcellradian(1)*sin(unitcellradian(5))*cos(rgamma)
orthogonalisation(2,2) = unitcellradian(2)*sin(unitcellradian(4))
orthogonalisation(3,1) = unitcellradian(1)*cos(unitcellradian(5))
orthogonalisation(3,2) = unitcellradian(2)*cos(unitcellradian(4))
orthogonalisation(3,3) = unitcellradian(3)
metric = matmul(transpose(orthogonalisation), orthogonalisation)
call m33inv(metric, rmetric, ok_flag)
 
if(.not. allocated(atomslist)) then
    allocate(atomslist(1024))
    atomslist_index=0
    atomslist%label=''
    atomslist%sfac=0
    do i=1, size(atomslist)
        atomslist(i)%coordinates=0.0
        atomslist(i)%aniso=0.0
    end do
    atomslist%iso=0.0
    atomslist%sof=0.0
    atomslist%resi=0
    atomslist%part=0
    atomslist%shelxline=''
end if

atomslist_index=atomslist_index+1
atomslist(atomslist_index)%label=label
atomslist(atomslist_index)%sfac=atomtype
atomslist(atomslist_index)%coordinates=coordinates
if(iso<0.0) then
    ! If an isotropic U is given as -T, where T is in the range 
    ! 0.5 < T < 5, it is fixed at T times the Ueq of the previous 
    ! atom not constrained in this way
    do i=atomslist_index-1, 1, -1
        if(atomslist(i)%iso>0.0) then
            atomslist(atomslist_index)%iso=atomslist(i)%iso*iso
            exit
        else if(any(atomslist(i)%aniso/=0.0)) then
            ! anisotropic displacements, need to calculate Ueq first
            uij(1,1)=atomslist(i)%aniso(1)
            uij(2,2)=atomslist(i)%aniso(2)
            uij(3,3)=atomslist(i)%aniso(3)
            uij(2,3)=atomslist(i)%aniso(4)
            uij(3,2)=atomslist(i)%aniso(4)
            uij(1,3)=atomslist(i)%aniso(5)
            uij(3,1)=atomslist(i)%aniso(5)
            uij(1,2)=atomslist(i)%aniso(6)
            uij(2,1)=atomslist(i)%aniso(6)
            do j=1, 3
                do k=1, 3
                    uij(k,j)=uij(k,j)*sqrt(rmetric(j,j)*rmetric(k,k))
                end do
            end do
            temp=matmul(orthogonalisation, matmul(uij, transpose(orthogonalisation)))
            call DSYEVC3(temp, eigv)
            atomslist(atomslist_index)%iso=1.0/3.0*sum(eigv)*iso
            exit
        end if
    end do
else
    atomslist(atomslist_index)%iso=iso
end if  
atomslist(atomslist_index)%sof=sof
atomslist(atomslist_index)%resi=residue
atomslist(atomslist_index)%part=part
atomslist(atomslist_index)%shelxline=line
atomslist(atomslist_index)%line_number=line_number

end subroutine

!> Write the crystals file
subroutine write_crystalfile()
implicit none
integer i, j, k
real occ
character lattice
character(len=3) :: centric
!1=P, 2=I, 3=rhombohedral obverse on hexagonal axes, 4=F, 5=A, 6=B, 7=C
character, dimension(7), parameter :: latticeletters=(/'P', 'I', 'R', 'F', 'A', 'B', 'C'/)
real, dimension(3,3) :: matrix
real, dimension(3) :: translation
!character, dimension(3), parameter :: axis=(/'X', 'Y', 'Z'/)
integer flag
character, dimension(12), parameter :: letters=&
&   (/'a', 'b', 'c', 'd', 'n', 'm', 'A', 'B', 'C', 'D', 'N', 'M'/)
character(len=1024) :: buffer, buffer2
integer serial1, serial2

open(123, file='crystalsinput.dat')

! process serial numbers 
call getshelx2crystals_serial

! process list1
!\LIST 1
! REAL A= B= C= ALPHA= BETA= GAMMA=
! END
if(list1index>0) then
    write(123, '(a)') '\LIST 1'
    do i=1, list1index
        write(123, '(a)') list1(i)
    end do
    write(123, '(a)') 'END'
end if

if(trim(list31(1))/='') then
    do i=1, size(list31)
        if(trim(list31(i))=='') exit
        write(123, '(a)') trim(list31(i))
    end do
end if

! process list2
! \LIST 2
! CELL NSYM= 2, LATTICE = B
! SYM X, Y, Z
! SYM X, Y + 1/2,  - Z
! SPACEGROUP B 1 1 2/B
! CLASS MONOCLINIC
! END
if(spacegroup%latt<0) then
    centric='YES'
else
    centric='NO '
end if
lattice=latticeletters(abs(spacegroup%latt))

! (1) Second character must be a space
if(spacegroup%symbol(2:2)/=' ') then
    spacegroup%symbol(2:)=' '//spacegroup%symbol(2:)
end if

! (2) Any opening brackets must be removed.
! (3) Any closing brackets become spaces, unless followed by '/'
i=index(spacegroup%symbol, '(')
do while(i>0)
    spacegroup%symbol=spacegroup%symbol(1:i-1)//spacegroup%symbol(i+1:)
    i=index(spacegroup%symbol, '(')
end do
i=index(spacegroup%symbol, ')')
do while(i>0)
    if(spacegroup%symbol(i+1:i+1)/='/') then
        spacegroup%symbol(i:i)=' '
    else
        spacegroup%symbol=spacegroup%symbol(1:i-1)//spacegroup%symbol(i+1:)
    end if
    i=index(spacegroup%symbol, '')
end do

! (4) There is always a space after a, b, c, d, n or m
do i=1, size(letters)
    j=3
    do while(j<=len_trim(spacegroup%symbol))
        if(spacegroup%symbol(j:j)==letters(i) .and. &
        &   spacegroup%symbol(j+1:j+1)/=' ') then
            spacegroup%symbol=spacegroup%symbol(1:j)//' '//spacegroup%symbol(j+1:)
            j=3
            cycle
        end if
        j=j+1
    end do
end do

! (5) There is always a space before 6
j=3
do while(j<=len_trim(spacegroup%symbol))
    if(spacegroup%symbol(j:j)=='6' .and. &
    &   spacegroup%symbol(j-1:j-1)/=' ') then
        spacegroup%symbol=spacegroup%symbol(1:j-1)//' '//spacegroup%symbol(j:)
        j=3
        cycle
    end if
    j=j+1
end do

! (6a) Adjacent numbers always have #1>#2.
! (6b) Always a space after a number, unless another number or /
j=3
do while(j<=len_trim(spacegroup%symbol))
    if(iachar(spacegroup%symbol(j:j))>=48 .and. iachar(spacegroup%symbol(j:j))<=57) then
        ! We have a number
        if(iachar(spacegroup%symbol(j+1:j+1))>=48 .and. iachar(spacegroup%symbol(j+1:j+1))<=57) then
            ! followed by another number
            if(iachar(spacegroup%symbol(j:j))<=iachar(spacegroup%symbol(j+1:j+1))) then
                spacegroup%symbol=spacegroup%symbol(1:j)//' '//spacegroup%symbol(j+1:)
                j=3
                cycle
            end if
        else if(spacegroup%symbol(j+1:j+1)/=' ' .and. spacegroup%symbol(j+1:j+1)/='/') then
            spacegroup%symbol=spacegroup%symbol(1:j)//' '//spacegroup%symbol(j+1:)
            j=3
            cycle        
        end if
    end if
    j=j+1
end do

! (7) There is always a space before -, and one digit after.
j=3
do while(j<=len_trim(spacegroup%symbol))
    if(spacegroup%symbol(j:j)=='-') then
        if(spacegroup%symbol(j-1:j-1)/=' ') then
            spacegroup%symbol=spacegroup%symbol(1:j)//' '//spacegroup%symbol(j+1:)
            j=3
            cycle
        end if
    end if
    j=j+1
end do
j=3
do while(j<=len_trim(spacegroup%symbol))
    if(spacegroup%symbol(j:j)=='-') then
        if(spacegroup%symbol(j+2:j+2)/=' ') then
            spacegroup%symbol=spacegroup%symbol(1:j+1)//' '//spacegroup%symbol(j+2:)
            j=3
            cycle
        end if
    end if
    j=j+1
end do

write(123, '(a)') '\SPACEGROUP'
write(123, '(a,1X,a)') 'SYMBOL', trim(spacegroup%symbol)
write(123, '(a)') 'END'

!write(123, '(a)') '\LIST 2'
!if(centric=='YES') then
!    j=(spacegroup%symmindex+1)*2
!else
!    j=spacegroup%symmindex+1
!end if
!write(123, '("CELL NSYM=", I0, ", LATTICE=", A, ", CENTRIC=", A)') &
!&   j, lattice, centric
!write(123, '(a)') 'SYM X, Y, Z'
!if(centric=='YES') then
!    write(123, '(a)') 'SYM -X, -Y, -Z'
!end if
!do i=1, spacegroup%symmindex
!    if(trim(spacegroup%symm(i))/='') then
!        if(centric=='YES') then
!            ! symmetry operator is process then rewritten so that the inverted operation can be derived
!            call readsymm(trim(spacegroup%symm(i)), matrix, translation)
!            buffer=''
!            do j=1, 3
!                do k=1, 3
!                    if(abs(matrix(j,k))>0.01 .and. abs(abs(matrix(j,k))-1.0)>0.01) then
!                        write(buffer2, '(SP,F0.2,a)') matrix(j,k), axis(k)
!                        buffer=trim(buffer)//' '//trim(buffer2)
!                    else if(abs(matrix(j,k)-1.0)<0.01) then
!                       buffer=trim(buffer)//' '//axis(k)
!                    else if(abs(matrix(j,k)+1.0)<0.01) then
!                       buffer=trim(buffer)//' -'//axis(k)
!                    end if
!                end do
!                if(abs(translation(j))>0.01) then
!                    write(buffer2, '(SP, F0.3)') translation(j)
!                    buffer=trim(buffer)//' '//trim(buffer2)
!                end if
!                if(j/=3) then
!                    buffer=trim(buffer)//', '
!                end if
!            end do
!            write(123, '(a, 1X, a)') 'SYM', trim(buffer)
!            matrix=-matrix
!            translation=-translation
!            buffer=''
!            do j=1, 3
!                do k=1, 3
!                    if(abs(matrix(j,k))>0.01 .and. abs(abs(matrix(j,k))-1.0)>0.01) then
!                        write(buffer2, '(SP,F0.2,a)') matrix(j,k), axis(k)
!                        buffer=trim(buffer)//' '//trim(buffer2)
!                    else if(abs(matrix(j,k)-1.0)<0.01) then
!                       buffer=trim(buffer)//' '//axis(k)
!                    else if(abs(matrix(j,k)+1.0)<0.01) then
!                       buffer=trim(buffer)//' -'//axis(k)
!                    end if
!                end do
!                if(abs(translation(j))>0.01) then
!                    write(buffer2, '(SP, F0.3)') translation(j)
!                    buffer=trim(buffer)//' '//trim(buffer2)
!                end if
!                if(j/=3) then
!                    buffer=trim(buffer)//', '
!                end if
!            end do
!            write(123, '(a, 1X, a)') 'SYM', trim(buffer)
!        else
!            write(123, '(a, 1X, a)') 'SYM', trim(spacegroup%symm(i))
!        end if
!    else
!        exit
!    end if
!end do
!write(123, '(a)') 'END'

! process list13
! \LIST 13
! CRYSTAL FRIEDELPAIRS= TWINNED= SPREAD=
! DIFFRACTION GEOMETRY= RADIATION=
! CONDITIONS WAVELENGTH= THETA(1)= THETA(2)= CONSTANTS . .
! MATRIX R(1)= R(2)= R(3)= . . . R(9)=
! TWO H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=
! THREE H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=
! REAL COMPONENTS= H= K= L= ANGLES=
! RECIPROCAL COMPONENTS= H= K= L= ANGLES=
! AXIS H= K= L=
if(list13index>0) then
    write(123, '(a)') '\LIST 13'
    do i=1, list13index
        write(123, '(a)') list13(i)
    end do
    write(123, '(a)') 'END'
end if

! composition
if(trim(composition(1))/='') then
    do i=1, 5
        write(123, '(a)') composition(i)
    end do
end if

! atom list
!#LIST	   5
!READ NATOM =     24, NLAYER =    0, NELEMENT =    0, NBATCH =    0
!OVERALL   10.013602  0.050000  0.050000  1.000000  0.000000	  156.0803375
!
!ATOM CU            1.   1.000000         0.   0.500000  -0.297919   0.250000
!CON U[11]=   0.052972   0.024222   0.052116   0.000000  -0.004649   0.000000
!CON SPARE=	 0.50          0   26279939          1                     0
!
!ATOM H            81.   1.000000         1.   0.465536   0.338532   0.388114
!CON U[11]=   0.050000   0.000000   0.000000   0.000000   0.000000   0.000000
!CON SPARE=	 1.00          0    8388609          1                     0
!
! ATOM TYPE=C,SERIAL=4,OCC=1,U[ISO]=0,X=0.027,Y=0.384,Z=0.725,
! CONT U[11]=0.075,U[22]=0.048,U[33]=.069
! CONT U[23]=-.007,U[13]=.043,U[12]=-.001
if(atomslist_index>0) then
    write(123, '(a)') '\LIST 5'
    write(123, '("READ NATOM = ",I0,", NLAYER = ",I0,'// &
    &   '", NELEMENT = ",I0,", NBATCH = ",I0)') &
    &   atomslist_index, 0, 0, 0
    do i=1, atomslist_index
        ! extracting occupancy from sof
        if(atomslist(i)%sof>=10.0 .and. atomslist(i)%sof<20.0) then
            ! fixed occupancy
            occ=atomslist(i)%sof-10.0
            !list12index=list12index+1
            !write(list12(list12index), '("FIX ",a,"(",I0,", occ)")') &
            !&   trim(sfac(atomslist(i)%sfac)), shelx2crystals_serial(i)%crystals_serial
        else if(abs(atomslist(i)%sof)>=20.0) then
            occ=abs(atomslist(i)%sof)-int(abs(atomslist(i)%sof)/10.0)*10.0
            if(atomslist(i)%sof>0) then
                occ=occ*fvar(int(abs(atomslist(i)%sof)/10.0))
            else
                occ=occ*(1.0-fvar(int(abs(atomslist(i)%sof)/10.0)))
            end if
            ! restraints done later
        else if(atomslist(i)%sof<0.0) then
            print *, "don't know what to do with negative soc"
            stop
        else            
            occ=atomslist(i)%sof
        end if
        if(atomslist(i)%iso/=0.0) then
            flag=1
        else
            flag=0
        end if
        if(atomslist(i)%crystals_serial==-1) then
			print *, 'Error: crystals serial not defined'
			call abort()
		end if
        
        write(123, '(a,1X,a)') '# ', trim(atomslist(i)%shelxline)
        write(123, '("ATOM TYPE=", a, ", SERIAL=",I0, ", OCC=",F0.5, ", FLAG=", I0)')  &
        &   trim(sfac(atomslist(i)%sfac)), atomslist(i)%crystals_serial, occ, flag
        if(any(atomslist(i)%aniso/=0.0)) then
            write(123, '("CONT X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
            &   atomslist(i)%coordinates
            write(123, '("CONT U[11]=", F0.5,", U[22]=", F0.5,", U[33]=", F0.5)') &
            &   atomslist(i)%aniso(1:3)
            write(123, '("CONT U[23]=", F0.5,", U[13]=", F0.5,", U[12]=", F0.5)') &
            &   atomslist(i)%aniso(4:6)
        else
            write(123, '("CONT U[11]=",F0.5, ", X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
            &   abs(atomslist(i)%iso), atomslist(i)%coordinates        
        end if
        if(atomslist(i)%resi>0) then
            write(123, '("CONT RESIDUE=",I0)') atomslist(i)%resi
        end if
        if(atomslist(i)%part>0) then
            write(123, '("CONT PART=",I0)') atomslist(i)%part+1000
        end if
    end do
    write(123, '(a)') 'END'
end if

if(list12index>0) then
    write(123, '(a)') '\LIST 12'
    do i=1, list12index
        write(123, '(a)') list12(i)
    end do
    write(123, '(a)') 'END'
end if

call writelist16()

close(123)
end subroutine

!> Parse symmetry operator as text into a 3x3 matrix plus a translational vector
subroutine readsymm(symmtext,symmatrix, translation)
implicit none
character(len=*), intent(in) :: symmtext !< Raw symmetry operator as text
character(len=10) numberstring
real, dimension(3,3), intent(out) :: symmatrix !< 3x3 rotation matrix
real, dimension(3), intent(out) :: translation !< translational vector
logical fractionbool, numberfound

integer length, coma, i, numberinteger,j
real signnumber, numerator, denominator

length=len(symmtext)
signnumber=1.0
coma=1
symmatrix=0
translation=0.0
numerator=0.0
denominator=1.0
fractionbool=.false.
numberfound=.false.
numberstring=''
j=1

!if (verbose==1) then
!    print *, 'reading symmetry: ',TRIM(ADJUSTL(symmtext))
!endif

do i=1,length
    if (symmtext(i:i)==' ') then
        cycle
    elseif (symmtext(i:i)=='-') then
        if (numberfound.eqv..true.) then
            call storenumber(fractionbool, numerator, denominator,    &
&                   numberstring, signnumber)
            translation(coma)=calctranslation(fractionbool,         &
&                   numerator, denominator)                        
            numberfound=.false.
            numerator=0.0
            denominator=1.0
        endif
        signnumber=-1.0
        cycle
    elseif (symmtext(i:i)=='+') then
        if (numberfound.eqv..true.) then
            call storenumber(fractionbool, numerator, denominator,    &
&                 numberstring, signnumber)
            translation(coma)=calctranslation(fractionbool,         &
&                 numerator, denominator)
            numberfound=.false.
            numerator=0.0
            denominator=1.0
        endif
        signnumber=1.0
        cycle
    elseif (symmtext(i:i)=='x' .or. symmtext(i:i)=='X') then
        symmatrix(coma,1)=int(signnumber)
        signnumber=1.0
        cycle
    elseif (symmtext(i:i)=='y' .or. symmtext(i:i)=='Y') then
        symmatrix(coma,2)=int(signnumber)
        signnumber=1.0
        cycle
    elseif (symmtext(i:i)=='z' .or. symmtext(i:i)=='Z') then
        symmatrix(coma,3)=int(signnumber)
        signnumber=1.0
        cycle
    elseif (symmtext(i:i)==',') then
        if (numberfound.eqv..true.) then
            call storenumber(fractionbool, numerator, denominator,    &
&                 numberstring, signnumber)
            translation(coma)=calctranslation(fractionbool,         &
&                 numerator, denominator)
            numberfound=.false.
            numerator=0.0
            denominator=1.0
        endif
        signnumber=1.0
        numerator=0.0
        denominator=1.0
        fractionbool=.false.
        numberstring=''
        j=1
        coma=coma+1
        cycle
    elseif (symmtext(i:i)=='/') then         
        if (numberfound.eqv..true.) then
            call storenumber(fractionbool, numerator, denominator,    &
&                   numberstring, signnumber)
        endif
        numberstring=''
        j=1
        fractionbool=.true.
        cycle
    else
        read(symmtext(i:i),*) numberinteger
        if (numberinteger/=0) then
            numberfound=.true.
            numberstring(j:j)=symmtext(i:i)
            j=j+1
        endif
        cycle
     endif
      
enddo

if (numberfound.eqv..true.) then
    call storenumber(fractionbool, numerator, denominator,            &
&           numberstring, signnumber)
    translation(coma)=calctranslation(fractionbool, numerator,      &
&            denominator)
endif

contains
    PURE function calctranslation(fractionbool, numerator, denominator)
    logical, intent(in) :: fractionbool
    real, intent(in) :: numerator, denominator
    real calctranslation
  
        if (fractionbool.eqv..false.) then
            calctranslation=numerator
            return
        else
            calctranslation=numerator/denominator
            return
        endif
    end function
    subroutine storenumber(fractionbool, numerator, denominator,      &
&        numberstring, signnumber)
    logical fractionbool
    real numerator, denominator, signnumber, numberreal
    character(len=10) numberstring
        read (numberstring, *) numberreal
        if (fractionbool.eqv..false.) then
            numerator=signnumber*numberreal
        else
            denominator=numberreal
        endif
    end subroutine
end subroutine

!> Parse RESI keyword. Change the current residue to the new value found.
subroutine shelx_resi(line)
implicit none
character(len=*) :: line

read(line(5:), *) residue
end subroutine

!> Parse PART keyword. Change the current part to the new value found.
subroutine shelx_part(line)
implicit none
character(len=*) :: line

read(line(5:), *) part
end subroutine

!> Parse the END keyword. Set the_end to true.
subroutine shelx_end(line)
implicit none
character(len=*) :: line

the_end=.true.

end subroutine

!> Algorithm to translate shelx labels into crystals serial code.
subroutine getshelx2crystals_serial()
implicit none
integer i, j, k, start
character(len=6) :: label, buffer
logical found, foundresidue

! shelx allows the same label in different residues. It's messing up the numerotation for crystals
! in this case, we will prefix the serial in crystals with the residue
foundresidue=.false.
do i=1, atomslist_index
    if(atomslist(i)%resi/=0) then
        foundresidue=.true.
        exit
    end if
end do        

do i=1, atomslist_index
    label=atomslist(i)%label
    ! fetch first number
    start=0
    do j=1, len_trim(label)
        if(iachar(label(j:j))>=48 .and. iachar(label(j:j))<=57) then ! [0-9]
            start=j
            exit
        end if
    end do
    if(start/=0) then
        ! fetch the serial number
        buffer=''
        k=0
        ! Now check if labels are duplicated
        if(foundresidue) then
            do j=1, atomslist_index 
                if(i/=j) then
                    if(atomslist(i)%label==atomslist(j)%label) then !found a duplicate
                        ! now prefix serial with residue
                        write(buffer, '(I0)') atomslist(i)%resi
                        k=len_trim(buffer)
                        exit
                    end if
                end if
            end do
        end if
        do j=start, len_trim(label)
            if(iachar(label(j:j))>=48 .and. iachar(label(j:j))<=57) then ! [0-9]
                k=k+1
                buffer(k:k)=label(j:j)
            else
                ! no more number but a suffix not supported by crystals
                ! if it is a symbol ignore it and hope for something after
                if(iachar(label(j:j))<48 .or. iachar(label(j:j))>122) cycle
                if(iachar(label(j:j))>57 .and. iachar(label(j:j))<65) cycle
                if(iachar(label(j:j))>90 .and. iachar(label(j:j))<97) cycle
                ! if a letter, append its number in alphabet instead
                if(iachar(label(j:j))>=65 .and. iachar(label(j:j))<=90) then ! [A-Z]
                    k=k+1
                    write(buffer(k:), '(I0)') iachar(label(j:j))-64
                    if(iachar(label(j:j))-64>10) k=k+1
                end if
            end if
        end do
        read(buffer, *) atomslist(i)%crystals_serial
    end if    
end do

! Most likely we have duplicates, lets fix that
found=.true.
duplicates:do while(found)
    found=.false.
    do i=1, atomslist_index
        do j=i+1, atomslist_index
            if(atomslist(i)%crystals_serial==atomslist(j)%crystals_serial) then
                if(atomslist(i)%sfac==atomslist(j)%sfac) then
                    ! identical serial, incrementing and starting search again
                    atomslist(i)%crystals_serial=atomslist(i)%crystals_serial+1
                    found=.true.
                    cycle duplicates
                end if
            end if
        end do
    end do
end do duplicates


end subroutine

!***********************************************************************************************************************************
!  M33INV  -  Compute the inverse of a 3x3 matrix.
!
!  A       = input 3x3 matrix to be inverted
!  AINV    = output 3x3 inverse of matrix A
!  OK_FLAG = (output) .TRUE. if the input matrix could be inverted, and .FALSE. if the input matrix is singular.
!***********************************************************************************************************************************
!> Compute the inverse of a 3x3 matrix.
SUBROUTINE M33INV (A, AINV, OK_FLAG)

IMPLICIT NONE

real, DIMENSION(3,3), INTENT(IN)  :: A
real, DIMENSION(3,3), INTENT(OUT) :: AINV
LOGICAL, INTENT(OUT) :: OK_FLAG

real, PARAMETER :: EPS = 1.0E-10
real :: DET
real, DIMENSION(3,3) :: COFACTOR


DET =   A(1,1)*A(2,2)*A(3,3)  &
&    - A(1,1)*A(2,3)*A(3,2)  &
&    - A(1,2)*A(2,1)*A(3,3)  &
&    + A(1,2)*A(2,3)*A(3,1)  &
&    + A(1,3)*A(2,1)*A(3,2)  &
&    - A(1,3)*A(2,2)*A(3,1)

IF (ABS(DET) .LE. EPS) THEN
 AINV = 0.0D0
 OK_FLAG = .FALSE.
 RETURN
END IF

COFACTOR(1,1) = +(A(2,2)*A(3,3)-A(2,3)*A(3,2))
COFACTOR(1,2) = -(A(2,1)*A(3,3)-A(2,3)*A(3,1))
COFACTOR(1,3) = +(A(2,1)*A(3,2)-A(2,2)*A(3,1))
COFACTOR(2,1) = -(A(1,2)*A(3,3)-A(1,3)*A(3,2))
COFACTOR(2,2) = +(A(1,1)*A(3,3)-A(1,3)*A(3,1))
COFACTOR(2,3) = -(A(1,1)*A(3,2)-A(1,2)*A(3,1))
COFACTOR(3,1) = +(A(1,2)*A(2,3)-A(1,3)*A(2,2))
COFACTOR(3,2) = -(A(1,1)*A(2,3)-A(1,3)*A(2,1))
COFACTOR(3,3) = +(A(1,1)*A(2,2)-A(1,2)*A(2,1))

AINV = TRANSPOSE(COFACTOR) / DET

OK_FLAG = .TRUE.

RETURN

END SUBROUTINE M33INV


!https://www.mpi-hd.mpg.de/personalhomes/globes/3x3/
!Joachim Kopp
!Efficient numerical diagonalization of hermitian 3x3 matrices
!Int. J. Mod. Phys. C 19 (2008) 523-548
!arXiv.org: physics/0610206
!* ----------------------------------------------------------------------------
!* Numerical diagonalization of 3x3 matrcies
!* Copyright (C) 2006  Joachim Kopp
!* ----------------------------------------------------------------------------
!* This library is free software; you can redistribute it and/or
!* modify it under the terms of the GNU Lesser General Public
!* License as published by the Free Software Foundation; either
!* version 2.1 of the License, or (at your option) any later version.
!*
!* This library is distributed in the hope that it will be useful,
!* but WITHOUT ANY WARRANTY; without even the implied warranty of
!* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!* Lesser General Public License for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with this library; if not, write to the Free Software
!* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
!* ----------------------------------------------------------------------------

!> Calculates the eigenvalues of a symmetric 3x3 matrix A using Cardano's analytical algorithm.
!* ----------------------------------------------------------------------------
      SUBROUTINE DSYEVC3(A, W)
!* ----------------------------------------------------------------------------
!* Calculates the eigenvalues of a symmetric 3x3 matrix A using Cardano's
!* analytical algorithm.
!* Only the diagonal and upper triangular parts of A are accessed. The access
!* is read-only.
!* ----------------------------------------------------------------------------
!* Parameters:
!*   A: The symmetric input matrix
!*   W: Storage buffer for eigenvalues
!* ----------------------------------------------------------------------------
!*     .. Arguments ..
      DOUBLE PRECISION A(3,3)
      DOUBLE PRECISION W(3)

!*     .. Parameters ..
      DOUBLE PRECISION SQRT3
      PARAMETER        ( SQRT3 = 1.73205080756887729352744634151D0 )

!*     .. Local Variables ..
      DOUBLE PRECISION M, C1, C0
      DOUBLE PRECISION DE, DD, EE, FF
      DOUBLE PRECISION P, SQRTP, Q, C, S, PHI
  
!*     Determine coefficients of characteristic poynomial. We write
!*           | A   D   F  |
!*      A =  | D*  B   E  |
!*           | F*  E*  C  |
      DE    = A(1,2) * A(2,3)
      DD    = A(1,2)**2
      EE    = A(2,3)**2
      FF    = A(1,3)**2
      M     = A(1,1) + A(2,2) + A(3,3)
      C1    = ( A(1,1)*A(2,2) + A(1,1)*A(3,3) + A(2,2)*A(3,3) ) - (DD + EE + FF)
      C0    = A(3,3)*DD + A(1,1)*EE + A(2,2)*FF - A(1,1)*A(2,2)*A(3,3) - 2.0D0 * A(1,3)*DE

      P     = M**2 - 3.0D0 * C1
      Q     = M*(P - (3.0D0/2.0D0)*C1) - (27.0D0/2.0D0)*C0
      SQRTP = SQRT(ABS(P))

      PHI   = 27.0D0 * ( 0.25D0 * C1**2 * (P - C1) + C0 * (Q + (27.0D0/4.0D0)*C0) )
      PHI   = (1.0D0/3.0D0) * ATAN2(SQRT(ABS(PHI)), Q)

      C     = SQRTP * COS(PHI)
      S     = (1.0D0/SQRT3) * SQRTP * SIN(PHI)

      W(2) = (1.0D0/3.0D0) * (M - C)
      W(3) = W(2) + S
      W(1) = W(2) + C
      W(2) = W(2) - S

      END SUBROUTINE
!* End of subroutine DSYEVC3

subroutine extract_res_from_cif(shelx_filepath, found)
implicit  none
character(len=*), intent(in) :: shelx_filepath
logical, intent(out) :: found
character(len=len(shelx_filepath)) :: res_filepath
integer resid, cifid, iostatus
character(len=2048) :: buffer

found=.false.
open(newunit=cifid,file=shelx_filepath, status='old')
do
    read(cifid, '(a)', iostat=iostatus) buffer
    if(iostatus/=0) then
        return
    end if
    if(index(buffer, '_shelx_res_file')>0) then
		! found a res file!
		found=.true.
		read(cifid, '(a)', iostat=iostatus) buffer
		if(trim(buffer)/=';') then
			print *, 'unexpected line: ', trim(buffer)
			print *, 'I was expecting `;`'
			call abort()
		end if
		
		res_filepath=shelx_filepath
		res_filepath(len_trim(res_filepath)-2:)='res'
		open(newunit=resid,file=res_filepath)		
		do
			read(cifid, '(a)', iostat=iostatus) buffer
			if(iostatus/=0 .or. trim(buffer)==';') then
				close(resid)
				return
			end if
			write(resid, '(a)') trim(buffer)
		end do
	end if

    if(index(buffer, '_shelx_hkl_file')>0) then
		! found a hkl file!
		read(cifid, '(a)', iostat=iostatus) buffer
		if(trim(buffer)/=';') then
			print *, 'unexpected line: ', trim(buffer)
			print *, 'I was expecting `;`'
			call abort()
		end if
		
		res_filepath=shelx_filepath
		res_filepath(len_trim(res_filepath)-2:)='hkl'
		open(newunit=resid,file=res_filepath)		
		do
			read(cifid, '(a)', iostat=iostatus) buffer
			if(iostatus/=0 .or. trim(buffer)==';') then
				close(resid)
				return
			end if
			write(resid, '(a)') trim(buffer)
		end do
	end if
	
end do


end subroutine

subroutine writelist16()
implicit none
integer i, j, k, l, k1,k2
integer, dimension(1024) :: serial1, serial2
logical found

! Restraints
write(123, '(a)') '\LIST 16'
write(123, '(a)') 'NO'
write(123, '(a)') 'REM   HREST   START (DO NOT REMOVE THIS LINE)' 
write(123, '(a)') 'REM   HREST   END (DO NOT REMOVE THIS LINE) '
! DISTANCE 1.000000 , 0.050000 = N(1) TO C(3) 
do i=1, dfix_table_index
	write(123, '(a, a)') '# ', dfix_table(i)%shelxline
	! get serial for atom 1
	serial1=0
	k1=0
	do j=1, atomslist_index
		if(trim(dfix_table(i)%atom1)==trim(atomslist(j)%label)) then
			k1=k1+1
			serial1(k1)=j
		end if
	end do
	! get serial for atom 2
	serial2=0
	k2=0
	do j=1, atomslist_index
		if(trim(dfix_table(i)%atom2)==trim(atomslist(j)%label)) then
			k2=k2+1
			serial2(k2)=j
		end if
	end do
	
	if(dfix_table(i)%residue==-99) then
		! No residue used
		if(k1>1 .or. k2>1) then
			print *, 'Error: duplicated label found and no residue specified in DFIX'
			write(*, '("Line ", I0, ": ", a)') dfix_table(i)%line_number, dfix_table(i)%shelxline
			do j=1, k1
				write(*, '("Line ", I0, ": ", a)') atomslist(serial1(j))%line_number, trim(atomslist(serial1(j))%shelxline)
			end do
			do j=1, k2
				write(*, '("Line ", I0, ": ", a)') atomslist(serial2(j))%line_number, trim(atomslist(serial2(j))%shelxline)
			end do
			call abort()
		else if(k1==0 .or. k2==0) then
			print *, 'Cannot find ', dfix_table(i)%atom1, ' or ', dfix_table(i)%atom2, ' in res file'
			call abort()
		else
			! good to go
			if(atomslist(serial1(1))%crystals_serial==-1 .or. atomslist(serial2(1))%crystals_serial==-1) then
				print *, 'Error: Crystals serial not defined'
				call abort()
			end if
			write(123, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
			&	'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
			&	trim(sfac(atomslist(serial1(1))%sfac)), atomslist(serial1(1))%crystals_serial, &
			&	trim(sfac(atomslist(serial2(1))%sfac)), atomslist(serial2(1))%crystals_serial
		end if
	else if(dfix_table(i)%residue==-1) then
		! dfix applied to all residues
		if(k1/=k2) then
			print *, 'Error: check your res file. I cannot find all the atom in all the residues'
			call abort()
		else
			do k=1, k1
				! good to go
				! looking for matching residue
				found=.false.
				do l=1, k1
					if(atomslist(serial1(k))%resi==atomslist(serial2(l))%resi) then
						found=.true.
						exit
					end if
				end do
				if(.not. found) then
					print *, 'Error: cannot find the corresponding atom in the residue ', atomslist(serial1(k))%resi
					call abort()
				end if
									
				if(atomslist(serial1(k))%crystals_serial==-1 .or. atomslist(serial2(l))%crystals_serial==-1) then
					print *, 'Error: Crystals serial not defined'
					call abort()
				end if
				write(123, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
				&	'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
				&	trim(sfac(atomslist(serial1(k))%sfac)), atomslist(serial1(k))%crystals_serial, &
				&	trim(sfac(atomslist(serial2(l))%sfac)), atomslist(serial2(l))%crystals_serial
			end do
		end if
	else
		! looking for a specific residue
		found=.false.
		do l=1, k1
			if(dfix_table(i)%residue==atomslist(serial1(l))%resi) then
				found=.true.
				exit
			end if
		end do
		k1=l
		if(.not. found) then
			print *, 'Error: cannot find the corresponding atom in the residue ', dfix_table(i)%residue
			write(*, '("Line ", I0, ": ", a)') dfix_table(i)%line_number, trim(dfix_table(i)%shelxline)
			call abort()
		end if
		do l=1, k2
			if(dfix_table(i)%residue==atomslist(serial2(l))%resi) then
				found=.true.
				exit
			end if
		end do
		k2=l
		if(.not. found) then
			print *, 'Error: cannot find the corresponding atom in the residue ', dfix_table(i)%residue
			write(*, '("Line ", I0, ": ", a)') dfix_table(i)%line_number, trim(dfix_table(i)%shelxline)
			call abort()
		end if

		write(123, '(a, 1X, F0.5, ",", F0.5, " = ", a,"(",I0,")", " TO ", a,"(",I0,")")') &
		&	'DISTANCE', dfix_table(i)%distance, dfix_table(i)%esd, &
		&	trim(sfac(atomslist(serial1(k1))%sfac)), atomslist(serial1(k1))%crystals_serial, &
		&	trim(sfac(atomslist(serial2(k2))%sfac)), atomslist(serial2(k2))%crystals_serial
		
	end if
				
end do
write(123, '(a)') 'END'
!write(123, '(a)') '# Remove space after hash to activate next line'
!write(123, '(a)') '# USE LAST'

end subroutine

 
end module
