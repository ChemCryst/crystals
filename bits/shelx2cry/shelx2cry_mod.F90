module shelx2cry_mod
integer, private, save :: line_number=1

character(len=4), dimension(77), parameter :: shelx_keywords=(/ &
&   'ABIN', 'ACTA', 'AFIX', 'ANIS', 'ANSC', 'ANSR', 'BASF', 'BIND', 'BLOC', &
&   'BOND', 'BUMP', 'CELL', 'CGLS', 'CHIV', 'CONF', 'CONN', 'DAMP', 'DANG', &
&   'DEFS', 'DELU', 'DFIX', 'DISP', 'EADP', 'END ', 'EQIV', 'EXTI', 'EXYZ', &
&   'FEND', 'FLAT', 'FMAP', 'FRAG', 'FREE', 'FVAR', 'GRID', 'HFIX', 'HKLF', &
&   'HTAB', 'ISOR', 'LATT', 'LAUE', 'LIST', 'L.S.', 'MERG', 'MORE', 'MOVE', &
&   'MPLA', 'NCSY', 'NEUT', 'OMIT', 'PART', 'PLAN', 'PRIG', 'REM ', 'RESI', &
&   'RIGU', 'RTAB', 'SADI', 'SAME', 'SFAC', 'SHEL', 'SIMU', 'SIZE', 'SPEC', &
&   'STIR', 'SUMP', 'SWAT', 'SYMM', 'TEMP', 'TITL', 'TWIN', 'TWST', 'UNIT', &
&   'WGHT', 'WIGL', 'WPDB', 'XNPD', 'ZERR' /)

character(len=512), dimension(512) :: list1
integer :: list1index=0
character(len=512), dimension(512) :: list13
integer :: list13index=0
character(len=512), dimension(512) :: list12
integer :: list12index=0
character(len=512), dimension(5) :: composition

character(len=3), dimension(128) :: sfac
integer :: residue=0
integer :: part=0
logical :: the_end=.false.

type atom_t
    character(len=6) :: label
    integer :: sfac
    real, dimension(3) :: coordinates
    real, dimension(6) :: aniso !< U11 U22 U33 U23 U13 U12
    real :: iso
    real :: sof !< Site occupation factor
    integer resi !< residue
    integer part !< group
    character(len=512) :: shelxline
end type
type(atom_t), dimension(:), allocatable :: atomslist
integer atomslist_index

type spacegroup_t
    integer :: latt
    character(len=128), dimension(32) :: symm
    integer :: symmindex=0
    character(len=128) :: symbol
end type
type(spacegroup_t) :: spacegroup 

type shelx_serial_t
    character(len=6) :: shelx_label
    character(len=3) :: atom
    integer :: crystals_serial
end type
type(shelx_serial_t), dimension(:), allocatable :: shelx2crystals_serial

contains

subroutine readline(shelxf_id, line, current_line, iostatus)
implicit none
integer, intent(in) :: shelxf_id
character(len=:), allocatable, intent(out) :: line
integer, intent(inout) :: current_line
integer, intent(out) :: iostatus
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
        exit
    else
        ! Continuation line present, appending next line...
        ! removing continuation symbol
        line(len_trim(line)-1:len_trim(line))=' '
    end if
end do

end subroutine

subroutine call_shelxprocess(line)
implicit none
character(len=*), intent(in) :: line
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
    print *, 'Blank line'
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

        case ('SFAC')
        call shelx_sfac(line)
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

if(found) return

! Check for any valid keyword that we do not handle yet
do i=1, size(shelx_keywords)
    if(len_trim(line)>3) then
        if(line(1:4)==shelx_keywords(i)) return
    end if
end do

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

!if(.not. found) then
!    print *, 'unknwon keyword ', line(1:min(4, len_trim(line))), ' on line ', line_number
!end if

end subroutine

subroutine shelx_titl(line)
implicit none
character(len=*), intent(in) :: line
integer start

! extract space group
start=index(line, 'in ')
spacegroup%symbol=line(start+3:)

!print *, line_number, ' Processing TITL' 
end subroutine

subroutine shelx_rem(line)
implicit none
character(len=*), intent(in) :: line

!print *, line_number, ' Processing REM' 
end subroutine

!CELL 1.54187 14.8113 13.1910 14.8119 90 98.158 90
subroutine shelx_cell(line)
implicit none
character(len=*), intent(in) :: line
real, dimension(7) :: cell
character dummy

read(line, *) dummy, cell
list1index=list1index+1
write(list1(list1index), '(a5,1X,6(F0.5,1X))') 'REAL ', cell(2:7)
list13index=list13index+1
write(list13(list13index), '(a,F0.5)') 'COND WAVE= ', cell(1)

!print *, line_number, ' Processing CELL' 
end subroutine

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

!SFAC C H N O
!UNIT 116 184 8 8
!
! \COMPOSITION
! CONTENT C 6 H 5 N O 2.5 CL
! SCATTERING CRSCP:SCATT.DAT
! PROPERTIES CRSCP:PROPERTIES.DAT
! END
subroutine shelx_unit(line)
implicit none
character(len=*), intent(in) :: line
integer i, j, k, code, iostatus
character(len=3) :: buffer
real, dimension(128) :: units

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
 
subroutine shelx_latt(line)
implicit none
character(len=*) :: line

read(line(5:), *) spacegroup%latt

end subroutine

subroutine shelx_symm(line)
implicit none
character(len=*) :: line

spacegroup%symmindex=spacegroup%symmindex+1
read(line(5:), '(a)') spacegroup%symm(spacegroup%symmindex)

end subroutine

subroutine shelxl_atomaniso(label, atomtype, coordinates, sof, aniso, line)
implicit none
character(len=*), intent(in) :: label
integer, intent(in) :: atomtype 
real, dimension(:), intent(in) :: coordinates
real, intent(in) :: sof
real, dimension(6), intent(in) :: aniso
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
end subroutine


subroutine shelxl_atomiso(label, atomtype, coordinates, sof, iso, line)
implicit none
character(len=*), intent(in) :: label
integer, intent(in) :: atomtype 
real, dimension(:), intent(in) :: coordinates
real, intent(in) :: sof
real, intent(in) :: iso
integer i 
character(len=*) :: line
 
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
atomslist(atomslist_index)%iso=abs(iso)
atomslist(atomslist_index)%sof=sof
atomslist(atomslist_index)%resi=residue
atomslist(atomslist_index)%part=part
atomslist(atomslist_index)%shelxline=line

end subroutine

subroutine write_crystalfile()
implicit none
integer i, j
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
            list12index=list12index+1
            write(list12(list12index), '("FIX ",a,"(",I0,", occ)")') &
            &   trim(sfac(atomslist(i)%sfac)), shelx2crystals_serial(i)%crystals_serial
        else if(abs(atomslist(i)%sof)>=20.0) then
            occ=abs(atomslist(i)%sof)-int(abs(atomslist(i)%sof)/10.0)*10.0
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
        write(123, '(a,1X,a)') '# ', trim(atomslist(i)%shelxline)
        write(123, '("ATOM TYPE=", a, ", SERIAL=",I0, ", OCC=",F0.5, ", FLAG=", I0)')  &
        &   trim(sfac(atomslist(i)%sfac)), shelx2crystals_serial(i)%crystals_serial, occ, flag
        if(any(atomslist(i)%aniso/=0.0)) then
            write(123, '("CONT X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
            &   atomslist(i)%coordinates
            write(123, '("CONT U[11]=", F0.5,", U[22]=", F0.5,", U[33]=", F0.5)') &
            &   atomslist(i)%aniso(1:3)
            write(123, '("CONT U[23]=", F0.5,", U[13]=", F0.5,", U[12]=", F0.5)') &
            &   atomslist(i)%aniso(4:6)
        else
            write(123, '("CONT U[11]=",F0.5, ", X=",F0.5, ", Y=",F0.5, ", Z=", F0.5)') &
            &   atomslist(i)%iso, atomslist(i)%coordinates        
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

close(123)
end subroutine

subroutine readsymm(symmtext,symmatrix, translation)
! convert a text symmetry operation into a 3*3 matrix plus a vector
implicit none
character(len=*), intent(in) :: symmtext
character(len=10) numberstring
real, dimension(3,3), intent(out) :: symmatrix
real, dimension(3), intent(out) :: translation
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

subroutine shelx_resi(line)
implicit none
character(len=*) :: line

read(line(5:), *) residue
end subroutine

subroutine shelx_part(line)
implicit none
character(len=*) :: line

read(line(5:), *) part
end subroutine

subroutine shelx_end(line)
implicit none
character(len=*) :: line

the_end=.true.

end subroutine

subroutine getshelx2crystals_serial()
implicit none
integer i, j, k, start
character(len=6) :: label, buffer
logical found, foundresidue

allocate(shelx2crystals_serial(atomslist_index))

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
    shelx2crystals_serial(i)%shelx_label=label
    shelx2crystals_serial(i)%atom=sfac(atomslist(i)%sfac)
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
        read(buffer, *) shelx2crystals_serial(i)%crystals_serial
    end if    
end do

! Most likely we have duplicates, lets fix that
found=.true.
duplicates:do while(found)
    found=.false.
    do i=1, atomslist_index
        do j=i+1, atomslist_index
            if(shelx2crystals_serial(i)%crystals_serial==shelx2crystals_serial(j)%crystals_serial) then
                if(shelx2crystals_serial(i)%atom==shelx2crystals_serial(j)%atom) then
                    ! identical serial, incrementing and starting search again
                    shelx2crystals_serial(i)%crystals_serial=shelx2crystals_serial(i)%crystals_serial+1
                    found=.true.
                    cycle duplicates
                end if
            end if
        end do
    end do
end do duplicates


end subroutine
 
end module





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
