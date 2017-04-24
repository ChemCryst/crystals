!> This module list the subroutine processing each keyword of a res file
module shelx_procedures_m
integer, parameter, private :: debug=0
contains

!> Keyword not yet supprted by crystals
subroutine shelx_unsupported(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    print *, 'Warning: `',trim(shelxline%line(1:4)),'` Not supported '
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
integer i, j, linepos, start, iostatus
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
character(len=128) :: buffernum
character(len=128) :: namedresidue
real distance, esd
integer :: dfixresidue
character(len=64), dimension(:), allocatable :: splitbuffer
character(len=:), allocatable :: stripline

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=5 ! First 4 is DFIX
    namedresidue=''
    
    if(len_trim(shelxline%line)<5) then
        write(*,*) 'Error: Empty DFIX'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
    end if
    
    dfixresidue=-99
    buffernum=''
    ! check for subscripts on dfix
    if(shelxline%line(5:5)=='_') then
        ! check for `_*̀
        if(shelxline%line(6:6)=='*') then
            dfixresidue=-1
            linepos=7
        else
            ! check for a residue number
            found=.true.
            j=0
            do while(found)
                found=.false.
                do i=1, 10
                    if(shelxline%line(6+j:6+j)==numbers(i)) then
                        found=.true.
                        buffernum(j+1:j+1)=shelxline%line(6+j:6+j)
                        j=j+1
                        exit
                    end if
                end do
            end do
            if(len_trim(buffernum)>0) then
                read(buffernum, *) dfixresidue
                linepos=6+j
            end if
            
            ! check for a residue name
            if(dfixresidue==-99) then
                if(shelxline%line(6:6)/=' ') then
                    ! DFIX applied to named residue
                    i=6
                    j=1
                    do while(shelxline%line(i:i)/=' ')
                        namedresidue(j:j)=shelxline%line(i:i)
                        i=i+1
                        j=j+1
                        linepos=linepos+1
                        if(i>=len(shelxline%line)) exit
                    end do
                    dfixresidue=-98
                    linepos=linepos+1
                else
                    write(*,*) 'Error: Cannot have a space after `_` '
                    write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    write(*,*) repeat(' ', 5+5+nint(log10(real(shelxline%line_number)))+1), '^'
                    return
                end if
            end if
        end if
    end if
    
    stripline=deduplicates(shelxline%line(linepos:))
    stripline=to_upper(stripline)    

    splitbuffer=explode(stripline, 64)    
    
    ! first element is the distance
    read(splitbuffer(1), *, iostat=iostatus) distance
    if(iostatus/=0) then
        write(*,*) 'Error: Expected a number but got ', trim(splitbuffer(1))
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
    end if

    ! Second element could be the esd
    read(splitbuffer(2), *, iostat=iostatus) esd
    if(iostatus/=0) then
        ! no esd, use default
        esd=0.02
        start=2
    else
        start=3
    end if
    
    do i=start, size(splitbuffer),2
        if( (i+1)>size(splitbuffer) ) then
            print *, 'Error: Missing a label in DFIX'
            write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            write(*,*) repeat(' ', 5+4+len_trim(shelxline%line)), '^'
            return
        end if
            
        dfix_table_index=dfix_table_index+1
        dfix_table(dfix_table_index)%distance=distance
        dfix_table(dfix_table_index)%esd=esd
        dfix_table(dfix_table_index)%atom1=to_upper(trim(splitbuffer(i)))
        dfix_table(dfix_table_index)%atom2=to_upper(trim(splitbuffer(i+1)))
        dfix_table(dfix_table_index)%shelxline=trim(shelxline%line)
        dfix_table(dfix_table_index)%line_number=shelxline%line_number
        dfix_table(dfix_table_index)%residue=dfixresidue
        dfix_table(dfix_table_index)%namedresidue=namedresidue
    end do

end subroutine

!> Parse the MPLA keyword. Restrain Plane
subroutine shelx_mpla(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, linepos, start, iostatus
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
character(len=128) :: buffernum
character(len=128) :: namedresidue
integer :: mplaresidue, numatom
character(len=128), dimension(:), allocatable :: splitbuffer
character(len=:), allocatable :: stripline

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=5 ! First 4 is DFIX
    
    if(len_trim(shelxline%line)<5) then
        write(*,*) 'Error: Empty MPLA'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
    end if

    if(index(shelxline%line,'<')>0 .or. index(shelxline%line,'>')>0) then
        write(*,*) 'Error: < or > is not implemented'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
    end if
    
    if(index(shelxline%line,'$')>0) then
        write(*,*) 'Error: symmetry equivalent `_$?` is not implemented'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
    end if
    
    mplaresidue=-99
    buffernum=''
    ! check for subscripts on dfix
    if(shelxline%line(5:5)=='_') then
        ! check for `_*̀
        if(shelxline%line(6:6)=='*') then
            mplaresidue=-1
            linepos=7
        else
            ! check for a residue number
            found=.true.
            j=0
            do while(found)
                found=.false.
                do i=1, 10
                    if(shelxline%line(6+j:6+j)==numbers(i)) then
                        found=.true.
                        buffernum(j+1:j+1)=shelxline%line(6+j:6+j)
                        j=j+1
                        exit
                    end if
                end do
            end do
            if(len_trim(buffernum)>0) then
                read(buffernum, *) mplaresidue
                linepos=6+j
            end if

            ! check for a residue name
            if(mplaresidue==-99) then
                if(shelxline%line(6:6)/=' ') then
                    ! MPLA applied to named residue
                    i=6
                    j=1
                    do while(shelxline%line(i:i)/=' ')
                        namedresidue(j:j)=shelxline%line(i:i)
                        i=i+1
                        j=j+1
                        linepos=linepos+1
                        if(i>=len(shelxline%line)) exit
                    end do
                    mplaresidue=-98
                    linepos=linepos+1
                else
                    write(*,*) 'Error: Cannot have a space after `_` '
                    write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    write(*,*) repeat(' ', 5+5+nint(log10(real(shelxline%line_number)))+1), '^'
                    return
                end if
            end if        
        end if
    end if
    
    stripline=deduplicates(shelxline%line(linepos:))
    stripline=to_upper(stripline)    

    splitbuffer=explode(stripline, 128)    
    
    ! first element is the number of atoms (optional)
    read(splitbuffer(1), *, iostat=iostatus) numatom
    if(iostatus/=0) then
        numatom=-1
        start=0
    else
        start=1
        if( numatom<3 ) then
            print *, "Error: Can't fit a plane with less than 3 atoms"
            write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            return
        end if
    end if
        
    mpla_table_index=mpla_table_index+1
    allocate(mpla_table(mpla_table_index)%atoms(size(splitbuffer)-start))
    mpla_table(mpla_table_index)%atoms=to_upper(splitbuffer(start+1:size(splitbuffer)))
    mpla_table(mpla_table_index)%shelxline=trim(shelxline%line)
    mpla_table(mpla_table_index)%line_number=shelxline%line_number
    mpla_table(mpla_table_index)%residue=mplaresidue
    mpla_table(mpla_table_index)%namedresidue=namedresidue

end subroutine

!> Parse the SADI keyword. Restrain bond distances to be equal to each others
subroutine shelx_sadi(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, linepos, start, iostatus
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
character(len=128) :: buffernum
real esd
integer :: sadiresidue
character(len=128), dimension(:), allocatable :: splitbuffer
character(len=:), allocatable :: stripline
character(len=128) :: namedresidue

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=5 ! First 4 is DFIX
    
    if(len_trim(shelxline%line)<5) then
        write(*,*) 'Error: Empty SADI'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
    end if
    
    sadiresidue=-99
    buffernum=''
    ! check for subscripts on sadi
    if(shelxline%line(5:5)=='_') then
        ! check for `_*̀
        if(shelxline%line(6:6)=='*') then
            sadiresidue=-1
            linepos=7
        else
            ! check for a residue number
            found=.true.
            j=0
            do while(found)
                found=.false.
                do i=1, 10
                    if(shelxline%line(6+j:6+j)==numbers(i)) then
                        found=.true.
                        buffernum(j+1:j+1)=shelxline%line(6+j:6+j)
                        j=j+1
                        exit
                    end if
                end do
            end do
            if(len_trim(buffernum)>0) then
                read(buffernum, *) sadiresidue
                linepos=6+j
            end if
            
            ! check for a residue name
            if(sadiresidue==-99) then
                if(shelxline%line(6:6)/=' ') then
                    ! DFIX applied to named residue
                    namedresidue=''
                    i=6
                    j=1
                    do while(shelxline%line(i:i)/=' ')
                        namedresidue(j:j)=shelxline%line(i:i)
                        i=i+1
                        j=j+1
                        linepos=linepos+1
                        if(i>=len(shelxline%line)) exit
                    end do
                    sadiresidue=-98
                    linepos=linepos+1
                else
                    write(*,*) 'Error: Cannot have a space after `_` '
                    write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    write(*,*) repeat(' ', 5+5+nint(log10(real(shelxline%line_number)))+1), '^'
                    return
                end if
            end if
        end if
    end if
    
    stripline=deduplicates(shelxline%line(linepos:))
    stripline=to_upper(stripline)    

    splitbuffer=''
    splitbuffer=explode(stripline, 128)    
    
    ! first element is the esd
    read(splitbuffer(1), *, iostat=iostatus) esd
    if(iostatus==0) then
        start=2
    else
        ! no esd, use default
        esd=0.02
        start=1
    end if
    
    sadi_table_index=sadi_table_index+1
    sadi_table(sadi_table_index)%esd=esd
    sadi_table(sadi_table_index)%shelxline=trim(shelxline%line)
    sadi_table(sadi_table_index)%line_number=shelxline%line_number
    sadi_table(sadi_table_index)%residue=sadiresidue
    sadi_table(sadi_table_index)%namedresidue=namedresidue
    
    do j=1, size(splitbuffer)
        if( trim(splitbuffer(j))=='' ) exit
    end do
    if(mod(j-start,2)/=0) then
        ! odd number of atoms
        print *, 'Error: Missing a label in SADI'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        return
    end if
    allocate(sadi_table(sadi_table_index)%atom_pairs(2, (j-start)/2))
    
    do i=0, (j-start)/2-1
        sadi_table(sadi_table_index)%atom_pairs(:,i+1)=(/splitbuffer(start+i*2), splitbuffer(start+i*2+1)/)
    end do

end subroutine

!> Pars the CELL keyword. Extract the unit cell parameter and wavelength
subroutine shelx_cell(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
real :: wave
character dummy
integer iostatus

    !CELL 1.54187 14.8113 13.1910 14.8119 90 98.158 90
    read(shelxline%line, *, iostat=iostatus) dummy, wave, unitcell
    if(iostatus/=0) then
        print *, 'Error: Syntax error'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        call abort()
    end if
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
integer iostatus

    read(shelxline%line(5:), *, iostat=iostatus) esds
    if(iostatus/=0) then
        print *, 'Error: Syntax error'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        call abort()
    end if
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
real, dimension(:), allocatable :: fvartemp

    temp=0.0
    read(shelxline%line(5:), *, iostat=iostatus) temp
    if(temp(1024)/=0.0) then
        print *, 'More than 1024 free variable?!?!'
        call abort()
    end if
    do i=1024,1,-1
        if(temp(i)/=0.0) exit
    end do
    if(.not. allocated(fvar)) then
        allocate(fvar(i))
        fvar=temp(1:i)
    else
        allocate(fvartemp(size(fvar)))
        fvartemp=fvar
        deallocate(fvar)
        allocate(fvar(i+size(fvartemp)))
        fvar(1:size(fvartemp))=fvartemp
        fvar(size(fvartemp)+1:)=temp(1:i)
    end if

end subroutine

!> Parse the SFAC keyword. Extract the atoms type use in the file.
subroutine shelx_sfac(shelxline)
use crystal_data_m, only: sfac, sfac_index, line_t, to_upper, sfac_long
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, code, iostatus
character(len=3) :: buffer
real, dimension(14) :: longsfac

    i=5
    !print *, trim(shelxline%line)
    do while(i<=len_trim(shelxline%line))
        if(shelxline%line(i:i)==' ') then
            i=i+1
            cycle
        end if
        
        buffer=''
        j=0
        do while(shelxline%line(i:i)/=' ')
            code=iachar(shelxline%line(i:i))
            if( .not. ((code>=65 .and. code<=90) .or. (code>=97 .and. code<=122)) ) then
                ! long sfac maybe?
                ! SFAC E a1 b1 a2 b2 a3 b3 a4 b4 c f' f" mu r wt
                read(shelxline%line(i:), *, iostat=iostatus) longsfac
                if(iostatus/=0) then
                    print *, 'Error: Syntax error'
                    write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    call abort()
                end if
                sfac_long(:,sfac_index)=longsfac
                !write(*, '(I3, 14F6.2)') sfac_index, longsfac
                return
            else
                j=j+1
                buffer(j:j)=shelxline%line(i:i)
                i=i+1
                if(i>len_trim(shelxline%line)) exit
            end if
        end do
        sfac_index=sfac_index+1
        !print *, sfac_index, to_upper(buffer)
        sfac(sfac_index)=to_upper(buffer)
    end do   

end subroutine

!> Parse the UNIT keyword. Extract the number of each atomic elements.
!! Write the corresponding `composition` command for crystals
subroutine shelx_unit(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, k, code, iostatus
character(len=12) :: buffer
    !SFAC C H N O
    !UNIT 116 184 8 8
    !
    ! \COMPOSITION
    ! CONTENT C 6 H 5 N O 2.5 CL
    ! SCATTERING CRSCP:SCATT.DAT
    ! PROPERTIES CRSCP:PROPERTIES.DAT
    ! END

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
        read(buffer, *, iostat=iostatus) sfac_units(k)
    end do   

    composition(1)='\COMPOSITION'
    !CONTENT C 6 H 5 N O 2.5 CL
    composition(2)='CONTENT '
    do i=1, k
        if(abs(nint(sfac_units(i))-sfac_units(i))<0.01) then
            write(buffer, '(I0)') nint(sfac_units(i))
        else
            write(buffer, '(F0.2)') sfac_units(i)
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
character(len=128) :: aname, buffer
integer i, j, start
character(len=128), dimension(:), allocatable :: residue_temp

    !read(shelxline%line(5:), *) residue
    
    ! Read in the number
    start=5
    do while(shelxline%line(start:start)==' ')
        start=start+1
        if(start>len_trim(shelxline%line)) exit
    end do
    j=0
    buffer=''
    do i=start, len_trim(shelxline%line)
        if(shelxline%line(i:i)==' ') then
            exit
        end if
        j=j+1
        buffer(j:j)=shelxline%line(i:i)
    end do
    read(buffer, *) residue
    !print *, trim(shelxline%line), trim(buffer), residue
    
    !if(residue==0) then
    !    print *, 'Error: residue index is zero'
    !    call abort()
    !end if

    ! Read in the residue name
    start=i
    if(start<=len_trim(shelxline%line)) then
        do while(shelxline%line(start:start)==' ')
            start=start+1
            if(start>len_trim(shelxline%line)) exit
        end do
        j=0
        buffer=''
        do i=start, len_trim(shelxline%line)
            if(shelxline%line(i:i)==' ') then
                exit
            end if
            j=j+1
            buffer(j:j)=shelxline%line(i:i)
        end do
        read(buffer, *) aname
    else
        aname=''
    end if
    !residue_names
    if(aname/='') then
        if(.not. allocated(residue_names)) then
            allocate(residue_names(max(1024, residue)))
            residue_names=''
            residue_names(residue)=trim(aname)
        else
            if(residue>size(residue_names)) then
                allocate(residue_temp(size(residue_names)))
                residue_temp=residue_names
                deallocate(residue_names)
                allocate(residue_names(max(size(residue_temp)+1024, residue)))
                residue_names=''
                residue_names(1:size(residue_temp))=residue_temp
                residue_names(residue)=trim(aname)
            else
                residue_names(residue)=trim(aname)
            end if
        end if
    end if
end subroutine

!> Parse PART keyword. Change the current part to the new value found.<br />
!! This instruction is not used in crystals, parts are recovered from the use of free variables in occupancy.
subroutine shelx_part(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer iostatus

    read(shelxline%line(5:), *, iostat=iostatus) part, part_sof
    if(iostatus/=0) then
        read(shelxline%line(5:), *, iostat=iostatus) part
        part_sof=-1.0
        if(iostatus/=0) then
            part=0
            print *, 'Error: syntax error in PART instruction'
            write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        end if
    end if
    
    if(part<0) then
        part=-part
        print *, 'Error: Suppression of special position constraints not supported'
        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
    end if
    
end subroutine

!> Parse SAME keyword. 
subroutine shelx_same(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer cont, i, j
character(len=2048) :: bufferline
character(len=:), allocatable :: stripline
character(len=6) :: startlabel, endlabel
logical collect, reverse
   
    ! extracting list of atoms, first removing duplicates spaces and keyword
    stripline=deduplicates(shelxline%line(5:))
    stripline=to_upper(stripline)
    
    ! looking for <,> shortcut
    cont=max(index(stripline, '<'), index(stripline, '>'))
    !print *, '*************** ', cont
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
        do i=cont+1, len_trim(stripline)
            if(stripline(i:i)==' ' .or. stripline(i:i)=='<' .or. stripline(i:i)=='>') then
                exit
            end if
            j=j+1
            endlabel(j:j)=stripline(i:i)
        end do  
        
        ! then looking for label on the left
        cont=max(index(stripline, '<'), index(stripline, '>'))
        if(stripline(cont-1:cont-1)==' ') cont=cont-1        
        j=7
        startlabel=''
        do i=cont-1, 1, -1
            if(stripline(i:i)==' ' .or. stripline(i:i)=='<' .or. stripline(i:i)=='>') then
                exit
            end if
            j=j-1
            startlabel(j:j)=stripline(i:i)
        end do  
        startlabel=adjustl(startlabel)

        ! scanning atom list to find the implicit atoms
        if(reverse) then
            i=atomslist_index
        else
            i=1
        end if
        collect=.false.
        do 
            if(trim(atomslist(i)%label)==trim(startlabel)) then
                !found the first atom
                !print *, trim(shelxline%line)
                !print *, 'Found start: ', trim(startlabel)
                collect=.true.
            end if
            if(reverse) then
                i=i-1
                if(i<1) then
                    if(collect) then
                        print *, 'Error: Cannot find end atom ', trim(endlabel)
                        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    else
                        print *, 'Error: Cannot find first atom ', trim(startlabel)
                        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    end if
                    same_processing=-1
                    return
                end if
            else
                i=i+1
                if(i>atomslist_index) then
                    if(collect) then
                        print *, 'Error: Cannot find end atom ', trim(endlabel)
                        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    else
                        print *, 'Error: Cannot find first atom ', trim(startlabel)
                        write(*, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    end if
                    same_processing=-1
                    return
                end if
            end if
            if(collect) then
                if(trim(atomslist(i)%label)==trim(endlabel)) then
                    !print *, 'Found end: ', trim(endlabel)
                    !print *, 'Done!!!!!'
                    ! job done
                    exit
                end if
                
                if(trim(sfac(atomslist(i)%sfac))/='H' .and. &
                &   trim(sfac(atomslist(i)%sfac))/='D') then
                    ! adding the atom to the list
                    bufferline=trim(bufferline)//' '//trim(atomslist(i)%label)
                end if
            end if
        end do
        ! concatenating the remaining
        bufferline=trim(bufferline)//' '//&
        &   trim(adjustl(stripline(max(index(stripline, '<'), index(stripline, '>'))+1:)))

        !print *, trim(stripline)
        !print *, trim(bufferline)
        stripline=bufferline
        cont=max(index(stripline, '<'), index(stripline, '>'))
    end do
    
    ! set the flag
    ! It is necessary as further information needs to be collected after this keyword.
    same_processing=0
    
    same_table_index=same_table_index+1
    ! allocate and split line into all the individual labels
    same_table(same_table_index)%list1=explode(stripline, 6)
    allocate(same_table(same_table_index)%list2(size(same_table(same_table_index)%list1)))
    same_table(same_table_index)%list2=''
    same_table(same_table_index)%shelxline=shelxline%line
    
    !print *, trim(shelxline%line)
    !print *, stripline
    !print *, same_table(same_table_index)%list1
    
end subroutine


!> Parse the END keyword. Set the_end to true.
subroutine shelx_end(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    the_end=.true.
    
end subroutine

end module
