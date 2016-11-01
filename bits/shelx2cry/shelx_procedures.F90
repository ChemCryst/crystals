!> This module list the subroutine processing each keyword of a res file
module shelx_procedures_m
integer, parameter, private :: debug=0
contains

!> Keyword not yet supprted by crystals
subroutine shelx_unsupported(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    print *, 'Warning: Not supported '
    write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)

end subroutine

!> Deprecated keywords not used in shelx anymore
subroutine shelx_deprecated(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    ! deprecated keywords
    write(*, '(a)') 'Warning: Keywords `TIME`, `HOPE` and `MOLE` are deprecated in shelx and therefore ignored'
    write(*, '(a,I0,a, a)') 'Line ', shelxline%line_number,': ', trim(shelxline%line)

end subroutine

!> Silently ignored keywords. Those are irrelevant for the structure
subroutine shelx_ignored(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    if(debug>0) then
        print *, 'Notice: Ignored keyword '
        print *, shelxline%line_number, trim(shelxline%line)
    end if
    
end subroutine

!> Parse the TITL keyword. Extract the space group name
subroutine shelx_titl(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer start

    ! extract space group
    start=index(shelxline%line, 'in ')
    if(start==0) then
        spacegroup%symbol='Unknown'
        !write(*,*) 'Error: Space group not specified in TITL'
        !write(*, '("shelxline ", I0, ": ", a)') line_number, trim(shelxline)
        !stop
    end if
        
    spacegroup%symbol=shelxline%line(start+3:)

end subroutine

!> Parse the DFIX keyword. Restrain bond distances
subroutine shelx_dfix(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer i, linepos
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
character(len=128) :: buffer, buffer2
real distance, esd
integer :: dfixresidue

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=4 ! First 4 is DFIX

    ! check for `_*̀
    dfixresidue=-99
    if(shelxline%line(5:5)=='_') then
        if(shelxline%line(6:6)=='*') then
            dfixresidue=-1
        else
            found=.false.
            do i=1, 10
                if(shelxline%line(6:6)==numbers(i)) then
                    found=.true.
                    read(shelxline%line(6:6), *) dfixresidue
                    exit
                end if
            end do
        end if
        linepos=6
    end if

    do while(linepos<=len(shelxline%line))
        linepos=linepos+1
        if(shelxline%line(linepos:linepos)/=' ') exit
    end do
    if(linepos>len(shelxline%line)) then
        write(*,*) ' I have not found anything after DFIX'
        write(*,*) shelxline%line_number, trim(shelxline%line)
        stop
    end if

    ! we have something, must be the distance
    buffer=''
    do while(shelxline%line(linepos:linepos)/=' ')
        found=.false.
        do i=1, size(numbers)
            if(shelxline%line(linepos:linepos)==numbers(i)) then
                found=.true.
                exit
            end if
        end do
        if(.not. found) then
            ! no number.
            write(*,*) 'Expected a number but got ', shelxline%line(linepos:linepos)
            write(*,*) shelxline%line
            write(*,*) repeat(' ', linepos-1), '^'
            stop
        end if
        buffer=trim(buffer)//shelxline%line(linepos:linepos)
        linepos=linepos+1
    end do
    ! number read, lets convert it to a proper one
    read(buffer, *) distance

    ! skip spaces again
    do while(linepos<=len(shelxline%line))
        if(shelxline%line(linepos:linepos)/=' ') exit
        linepos=linepos+1
    end do
    if(linepos>len(shelxline%line)) then
        write(*,*) ' I have not found the esd or atom definition'
        write(*,*) shelxline%line
        stop
    end if
        
    ! we have something, must be esd or atom
    found=.false.
    do i=1, size(numbers)
        if(shelxline%line(linepos:linepos)==numbers(i)) then
            found=.true.
            exit
        end if
    end do
    if(found) then
        ! it's a number!
        buffer=''
        do while(shelxline%line(linepos:linepos)/=' ')
            found=.false.
            do i=1, size(numbers)
                if(shelxline%line(linepos:linepos)==numbers(i)) then
                    found=.true.
                    exit
                end if
            end do
            if(.not. found) then
                write(*,*) 'Expected a number but got ', shelxline%line(linepos:linepos)
                write(*,*) shelxline%line
                write(*,*) repeat(' ', linepos-1), '^'
                stop
            end if
            buffer=trim(buffer)//shelxline%line(linepos:linepos)
            linepos=linepos+1
        end do
        ! number read, lets convert it to a proper one
        read(buffer, *) esd
    else
        esd=0.02
    end if  

    ! fetch now the list of atoms
    do
        !print *, trim(shelxline(linepos:))
        ! skip spaces again
        do while(linepos<=len(shelxline%line))
            if(shelxline%line(linepos:linepos)/=' ') exit
            linepos=linepos+1
        end do
        if(linepos>len(shelxline%line)) exit
        ! get atom
        buffer=''
        do while(shelxline%line(linepos:linepos)/=' ')
            buffer=trim(buffer)//shelxline%line(linepos:linepos)
            linepos=linepos+1
            if(linepos>len(shelxline%line)) exit
        end do

        ! get second atom
        do while(linepos<=len(shelxline%line))
            linepos=linepos+1
            if(shelxline%line(linepos:linepos)/=' ') exit
        end do
        if(linepos>len(shelxline%line)) exit
        buffer2=''
        do while(shelxline%line(linepos:linepos)/=' ')
            buffer2=trim(buffer2)//shelxline%line(linepos:linepos)
            linepos=linepos+1
            if(linepos>len(shelxline%line)) exit      
        end do
        
        !print *, trim(buffer), '++', trim(buffer2)
        !print *, linepos, len(shelxline)
        dfix_table_index=dfix_table_index+1
        dfix_table(dfix_table_index)%distance=distance
        dfix_table(dfix_table_index)%esd=esd
        dfix_table(dfix_table_index)%atom1=to_upper(trim(buffer))
        dfix_table(dfix_table_index)%atom2=to_upper(trim(buffer2))
        dfix_table(dfix_table_index)%shelxline=trim(shelxline%line)
        dfix_table(dfix_table_index)%line_number=shelxline%line_number
        dfix_table(dfix_table_index)%residue=dfixresidue
    end do

end subroutine

!> Pars the CELL keyword. Extract the unit cell parameter and wavelength
subroutine shelx_cell(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
real :: wave
character dummy

    !CELL 1.54187 14.8113 13.1910 14.8119 90 98.158 90
    read(shelxline%line, *) dummy, wave, unitcell
    list1index=list1index+1
    write(list1(list1index), '(a5,1X,6(F0.5,1X))') 'REAL ', unitcell
    list13index=list13index+1
    write(list13(list13index), '(a,F0.5)') 'COND WAVE= ', wave

end subroutine

!> Parse the ZERR keyword. Extract the esds on the unit cell parameters
subroutine shelx_zerr(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
real, dimension(7) :: esds

    read(shelxline%line(5:), *) esds
    write(list31(1), '(a)') '\LIST 31'
    write(list31(2), '("MATRIX V(11)=",F0.5, ", V(22)=",F0.5, ", V(33)=",F0.5)') esds(2:4)
    write(list31(3), '("CONT V(44)=",F0.5, ", V(55)=",F0.5, ", V(66)=",F0.5)') esds(5:7)
    write(list31(4), '(a)') 'END'

end subroutine

!> Parse the FVAR keyword. Extract the overall scale parameter and free variable
subroutine shelx_fvar(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
real, dimension(1024) :: temp ! should be more than enough
integer iostatus, i

    temp=0.0
    read(shelxline%line(5:), *, iostat=iostatus) temp(1:3)
    if(temp(1024)/=0.0) then
        print *, 'More than 1024 free variable?!?!'
        call abort()
    end if
    do i=1024,1,-1
        if(temp(i)/=0.0) exit
    end do
    allocate(fvar(i))
    fvar=temp(1:i)

end subroutine

!> Parse the SFAC keyword. Extract the atoms type use in the file.
subroutine shelx_sfac(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, k, code
character(len=3) :: buffer

    sfac=''
    k=0

    i=5
    do while(i<=len_trim(shelxline%line))
        if(shelxline%line(i:i)==' ') then
            i=i+1
            cycle
        end if
        
        buffer=''
        j=0
        do while(shelxline%line(i:i)/=' ')
            code=iachar(shelxline%line(i:i))
            if( (code<65 .and. code>90) .or. (code<97 .and. code>122) ) then
                print *, 'Error in SFAC'
                call abort()
            end if
            j=j+1
            buffer(j:j)=shelxline%line(i:i)
            i=i+1
            if(i>len_trim(shelxline%line)) exit
        end do
        k=k+1
        sfac(k)=buffer
    end do   

end subroutine

!> Parse the UNIT keyword. Extract the number of each atomic elements.
!! Write the corresponding `composition` command for crystals
subroutine shelx_unit(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
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
    do while(i<=len_trim(shelxline%line))
        if(shelxline%line(i:i)==' ') then
            i=i+1
            cycle
        end if
        
        buffer=''
        j=0
        do while(shelxline%line(i:i)/=' ')
            read(buffer, '(I1)', iostat=iostatus) code
            if(iostatus/=0 .and. shelxline%line(i:i)/='.') then
                print *, 'Wrong input in UNIT'
                call abort()
            end if
            j=j+1
            buffer(j:j)=shelxline%line(i:i)
            i=i+1
            if(i>len_trim(shelxline%line)) exit
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
        
end subroutine
 
!> Parse the LATT keyword. Extract the lattice type.
subroutine shelx_latt(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    read(shelxline%line(5:), *) spacegroup%latt

end subroutine

!> Parse the SYMM keyword. Extract the symmetry operators as text.
subroutine shelx_symm(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    spacegroup%symmindex=spacegroup%symmindex+1
    read(shelxline%line(5:), '(a)') spacegroup%symm(spacegroup%symmindex)

end subroutine

!> Parse RESI keyword. Change the current residue to the new value found.
subroutine shelx_resi(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    read(shelxline%line(5:), *) residue
end subroutine

!> Parse PART keyword. Change the current part to the new value found.
subroutine shelx_part(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    read(shelxline%line(5:), *) part
end subroutine

!> Parse the END keyword. Set the_end to true.
subroutine shelx_end(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    the_end=.true.

end subroutine

end module
