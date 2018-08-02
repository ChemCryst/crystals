!> This module list the subroutine processing each keyword of a res file
module shelx_procedures_m
integer, parameter, private :: debug=0
contains

!> Keyword not yet supprted by crystals
subroutine shelx_unsupported(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    write(log_unit, '(a,a,a)') 'Warning: `',trim(shelxline%line(1:4)),'` Not supported '
    write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)

end subroutine

!> Deprecated keywords not used in shelx anymore
subroutine shelx_deprecated(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    ! deprecated keywords
    write(log_unit, '(a)') 'Warning: Keywords `TIME`, `HOPE` and `MOLE` are deprecated in shelx and therefore ignored'
    write(log_unit, '(a,I0,a, a)') 'Line ', shelxline%line_number,': ', trim(shelxline%line)

end subroutine

!> Silently ignored keywords. Those are irrelevant for the structure
subroutine shelx_ignored(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    if(debug>0) then
        write(log_unit, *) 'Notice: Ignored keyword '
        write(log_unit, *) shelxline%line_number, trim(shelxline%line)
    end if
    
end subroutine

!> Parse ABIN keyword. It is ignored but the user is warned that the structure has been squeezed
subroutine shelx_abin(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    write(log_unit, *) 'Warning: Structure has been SQUEEZED '
    write(log_unit, *) shelxline%line_number, trim(shelxline%line)
    info_table_index=info_table_index+1
    info_table(info_table_index)%shelxline=trim(shelxline%line)
    info_table(info_table_index)%line_number=shelxline%line_number
    info_table(info_table_index)%text='Warning: Structure has been SQUEEZED '
    
end subroutine

!> Parse HKLF keyword. It is ignored but the user is warned that the structure has been TWINNED if HKLF 5 is found
subroutine shelx_hklf(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
character(len=512) :: buffer
character(len=:), allocatable :: stripline
character(len=lenlabel), dimension(:), allocatable :: splitbuffer
integer i, hklfcode
real s
real, dimension(9) :: transform
logical transforml, file_exists

    s=1.0
    transform=0.0
    transform(1)=1.0
    transform(5)=1.0
    transform(9)=1.0
    transforml=.false.
    
    buffer=shelxline%line(5:len(shelxline%line))
    buffer=adjustl(buffer)
    
    if(len_trim(buffer)==0) then
        return
    end if
    
    call deduplicates(trim(buffer), stripline)
    call explode(stripline, lenlabel, splitbuffer)

    ! trying to make sense of the hklf instruction   
    read(splitbuffer(1), *) hklfcode
    if(size(splitbuffer)==1) then
        ! all good, nothing to do
    else if(size(splitbuffer)==2) then
        ! First is the hklf code, then it is a scale factor:
        ! the scale factor S multiplies both Fo² and σ(Fo²)
        read(splitbuffer(2), *) s
        transforml=.true.
    else if(size(splitbuffer)==10) then
        ! First is the hklf code, then a transformation matrix:
        do i=1,9
            read(splitbuffer(i+1), *) transform(i)
        end do
        transforml=.true.
    else if(size(splitbuffer)==11) then
        ! First is the hklf code, then a scale factor, then a transformation matrix:
        read(splitbuffer(2), *) s
        do i=1,9
            read(splitbuffer(i+2), *) transform(i)
        end do
        transforml=.true.
    else
        write(log_unit,*) 'Warning: Unsupported combination of arguments in HKLF'
        write(log_unit, '("shelxline ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
    end if
    
    if(hklfcode<1 .or. hklfcode>6) then
        write(log_unit, *) 'Error: Invalid HKLF code '
        write(log_unit, *) shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    
    if(hklfcode==5) then ! twin refinement expecting hklf 5 file later, issuing a warning
        write(log_unit, *) 'Warning: Structure is TWINNED and HKLF 5 has been used '
        write(log_unit, *) shelxline%line_number, trim(shelxline%line)
        info_table_index=info_table_index+1
        info_table(info_table_index)%shelxline=trim(shelxline%line)
        info_table(info_table_index)%line_number=shelxline%line_number
        info_table(info_table_index)%text='Warning: Structure is TWINNED and HKLF 5 has been used'
    end if
        
    if(transforml) then
        ! check that the determinant is positive
        if(m33det(reshape(transform, (/3,3/)))<=0) then ! matrix is transposed but the determinant is unaffected.
            transforml=.true.
            write(log_unit,*) 'Error: The transformation matrix from HKLF is invalid (determinant<=0)'
            write(log_unit, '("shelxline ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            summary%error_no=summary%error_no+1
        end if
        
        write(buffer, '(A, I0)') 'HKLF ', hklfcode
        call extras_info%write(trim(buffer))
        write(buffer, '(A, F14.8)') 'SCAL ', s
        call extras_info%write(trim(buffer))
        write(buffer, '(A, 3F14.8)') 'R     ', transform(1:3)
        call extras_info%write(trim(buffer))
        write(buffer, '(A, 3F14.8)') 'R     ', transform(4:6)
        call extras_info%write(trim(buffer))
        write(buffer, '(A, 3F14.8)') 'R     ', transform(7:9)
        call extras_info%write(trim(buffer))

        info_table_index=info_table_index+1
        info_table(info_table_index)%shelxline=trim(shelxline%line)
        info_table(info_table_index)%line_number=shelxline%line_number
        info_table(info_table_index)%text='Warning: hkl indices need transforming, see transform.cry'
    end if
    
contains

    !***********************************************************************************************************************************
    !  M33DET  -  Compute the determinant of a 3x3 matrix.
    !***********************************************************************************************************************************
    !> Return the determinant of a 3x3 matrix
    function m33det (a) result (det)
    implicit none
    real, dimension(3,3), intent(in)  :: a
    real :: det

        det =   a(1,1)*a(2,2)*a(3,3)  &
            - a(1,1)*a(2,3)*a(3,2)  &
            - a(1,2)*a(2,1)*a(3,3)  &
            + a(1,2)*a(2,3)*a(3,1)  &
            + a(1,3)*a(2,1)*a(3,2)  &
            - a(1,3)*a(2,2)*a(3,1)

        return
    end function m33det
    
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
        !write(log_unit,*) 'Error: Space group not specified in TITL'
        !write(log_unit, '("shelxline ", I0, ": ", a)') line_number, trim(shelxline)
        !stop
    end if
        
    spacegroup%symbol=shelxline%line(start+3:)

end subroutine

!> Parse the DFIX and DANG keyword. Restrain bond distances
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
character(len=lenlabel), dimension(:), allocatable :: splitbuffer
character(len=:), allocatable :: stripline

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=5 ! First 4 is DFIX or DANG
    namedresidue=''
    
    if(len_trim(shelxline%line)<5) then
        write(log_unit,*) 'Error: Empty DFIX or DANG'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
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
                    write(log_unit,*) 'Error: Cannot have a space after `_` '
                    write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    write(log_unit,*) repeat(' ', 5+5+nint(log10(real(shelxline%line_number)))+1), '^'
                    summary%error_no=summary%error_no+1
                    return
                end if
            end if
        end if
    end if
    
    call deduplicates(shelxline%line(linepos:), stripline)
    call to_upper(stripline)    

    call explode(stripline, lenlabel, splitbuffer)    
    
    ! first element is the distance
    read(splitbuffer(1), *, iostat=iostatus) distance
    if(iostatus/=0) then
        write(log_unit,*) 'Error: Expected a number but got ', trim(splitbuffer(1))
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    
    if(distance>15.0) then
        write(log_unit,*) 'Error: Distance should between 0.0 and 15.0 but got ', trim(splitbuffer(1))
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if

    ! Second element could be the esd
    read(splitbuffer(2), *, iostat=iostatus) esd
    if(iostatus/=0) then
        ! no esd, use default
        if(shelxline%line(1:4)=='DFIX') then
            esd=0.02
        else
            esd=0.04
        end if
        start=2
    else
        start=3
    end if
    
    do i=start, size(splitbuffer),2
        if( (i+1)>size(splitbuffer) ) then
            write(log_unit, *) 'Error: Missing a label in DFIX'
            write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            write(log_unit,*) repeat(' ', 5+4+len_trim(shelxline%line)), '^'
            summary%error_no=summary%error_no+1
            return
        end if
            
        dfix_table_index=dfix_table_index+1
        dfix_table(dfix_table_index)%distance=distance
        dfix_table(dfix_table_index)%esd=esd
        call to_upper(splitbuffer(i), dfix_table(dfix_table_index)%atom1)
        call to_upper(splitbuffer(i+1), dfix_table(dfix_table_index)%atom2)
        dfix_table(dfix_table_index)%shelxline=trim(shelxline%line)
        dfix_table(dfix_table_index)%line_number=shelxline%line_number
        dfix_table(dfix_table_index)%residue=dfixresidue
        dfix_table(dfix_table_index)%namedresidue=namedresidue
    end do

end subroutine

!> Parse the FLAT keyword. Restrain Plane
subroutine shelx_flat(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    if(len_trim(shelxline%line)<5) then
        write(log_unit,*) 'Error: Empty FLAT'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if

    ! doing processing later, we don't know the atom list yet
        
    flat_table_index=flat_table_index+1
    flat_table(flat_table_index)%shelxline=trim(shelxline%line)
    flat_table(flat_table_index)%line_number=shelxline%line_number

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
character(len=lenlabel), dimension(:), allocatable :: splitbuffer
character(len=:), allocatable :: stripline
character(len=128) :: namedresidue

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=5 ! First 4 is DFIX
    
    if(len_trim(shelxline%line)<5) then
        write(log_unit,*) 'Error: Empty SADI'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
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
                    write(log_unit,*) 'Error: Cannot have a space after `_` '
                    write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    write(log_unit,*) repeat(' ', 5+5+nint(log10(real(shelxline%line_number)))+1), '^'
                    summary%error_no=summary%error_no+1
                    return
                end if
            end if
        end if
    end if
    
    call deduplicates(shelxline%line(linepos:), stripline)
    call to_upper(stripline)
    call explode(stripline, lenlabel, splitbuffer)    
    
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
        write(log_unit, *) 'Error: Missing a label in SADI'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    allocate(sadi_table(sadi_table_index)%atom_pairs(2, (j-start)/2))
    
    do i=0, (j-start)/2-1
        sadi_table(sadi_table_index)%atom_pairs(:,i+1)= &
        &   (/splitbuffer(start+i*2), splitbuffer(start+i*2+1)/)
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
        write(log_unit, *) 'Error: Syntax error'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
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
        write(log_unit, *) 'Error: Syntax error'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
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
        write(log_unit, *) 'More than 1024 free variable?!?!'
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
use crystal_data_m, only: sfac, sfac_index, line_t, to_upper, sfac_long, log_unit, summary
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, code, iostatus
character(len=3) :: buffer
real, dimension(14) :: longsfac

    i=5
    !write(log_unit, *) trim(shelxline%line)
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
                    write(log_unit, *) 'Error: Syntax error'
                    write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    summary%error_no=summary%error_no+1
                    call abort()
                end if
                sfac_long(:,sfac_index)=longsfac
                !write(log_unit, '(I3, 14F6.2)') sfac_index, longsfac
                return
            else
                j=j+1
                buffer(j:j)=shelxline%line(i:i)
                i=i+1
                if(i>len_trim(shelxline%line)) exit
            end if
        end do
        sfac_index=sfac_index+1
        !write(log_unit, *) sfac_index, to_upper(buffer)
        call to_upper(buffer, sfac(sfac_index))
    end do   

end subroutine

!> Parse the DISP keyword. Extract the atoms type use in the file.
subroutine shelx_disp(shelxline)
use crystal_data_m, only: disp_table, line_t, to_upper, deduplicates, explode, summary
use crystal_data_m, only: sfac_index, sfac, log_unit
implicit none
type(line_t), intent(in) :: shelxline
integer i, j
character(len=:), allocatable :: stripped
character(len=len_trim(shelxline%line)), dimension(:), allocatable :: exploded

    if(sfac_index==0) then
        write(log_unit, *) 'Error: SFAC card missing before DISP'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        call abort()
    end if
    
    if(.not. allocated(disp_table)) then
        ! DISP always appear after all the SFAC cards, so it is safe to allocate here
        allocate(disp_table(sfac_index))
        do i=1, sfac_index
            disp_table(i)%atom=''
            disp_table(i)%shelxline=''
            disp_table(i)%line_number=0
            disp_table(i)%values=0.0
        end do
    end if

    call deduplicates(shelxline%line, stripped)
    call explode(stripped, len_trim(shelxline%line), exploded)
    
    do i=1, sfac_index
        if(trim(sfac(i))==trim(exploded(2))) then
            disp_table(i)%atom=trim(exploded(2))
            disp_table(i)%values=0.0
            disp_table(i)%shelxline=trim(shelxline%line)
            disp_table(i)%line_number=shelxline%line_number
            do j=3, size(exploded)
                read(exploded(j), *) disp_table(i)%values(j-2)
            end do
            exit
        end if
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
                write(log_unit, *) 'Wrong input in UNIT'
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
    !write(log_unit, *) trim(shelxline%line), trim(buffer), residue
    
    !if(residue==0) then
    !    write(log_unit, *) 'Error: residue index is zero'
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
            write(log_unit, *) 'Error: syntax error in PART instruction'
            write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            summary%error_no=summary%error_no+1
        end if
    end if
    
    if(part<0) then
        part=-part
        write(log_unit, *) 'Error: Suppression of special position constraints not supported'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
    end if
    
end subroutine

!> Parse SAME keyword. 
subroutine shelx_same(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    if(len_trim(shelxline%line)<5) then
        write(log_unit,*) 'Error: Empty SAME'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
        
    same_table_index=same_table_index+1
    same_table(same_table_index)%shelxline=trim(shelxline%line)
    same_table(same_table_index)%line_number=shelxline%line_number
    same_table(same_table_index)%esd1=0.0
    same_table(same_table_index)%esd2=0.0
    same_table(same_table_index)%residue=-99
    same_table(same_table_index)%namedresidue=''

end subroutine

!> Parse the EADP keyword. Restrain Plane
subroutine shelx_eadp(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, linepos, start, iostatus
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
character(len=128) :: buffernum
character(len=128) :: namedresidue
integer :: eadpresidue, numatom
character(len=lenlabel), dimension(:), allocatable :: splitbuffer
character(len=:), allocatable :: stripline

    write(log_unit,*) 'Warning: EADP implemented as a restraint'
    write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)  

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=5 ! First 4 is EADP
    
    if(len_trim(shelxline%line)<5) then
        write(log_unit,*) 'Error: Empty EADP'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if

    if(index(shelxline%line,'<')>0 .or. index(shelxline%line,'>')>0) then
        write(log_unit,*) 'Error: < or > is not implemented'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    
    if(index(shelxline%line,'$')>0) then
        write(log_unit,*) 'Error: symmetry equivalent `_$?` is not implemented'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    
    eadpresidue=-99
    buffernum=''
    ! check for subscripts on dfix
    if(shelxline%line(5:5)=='_') then
        ! check for `_*̀
        if(shelxline%line(6:6)=='*') then
            eadpresidue=-1
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
                read(buffernum, *) eadpresidue
                linepos=6+j
            end if

            ! check for a residue name
            if(eadpresidue==-99) then
                if(shelxline%line(6:6)/=' ') then
                    ! FLAT applied to named residue
                    i=6
                    j=1
                    do while(shelxline%line(i:i)/=' ')
                        namedresidue(j:j)=shelxline%line(i:i)
                        i=i+1
                        j=j+1
                        linepos=linepos+1
                        if(i>=len(shelxline%line)) exit
                    end do
                    eadpresidue=-98
                    linepos=linepos+1
                else
                    write(log_unit,*) 'Error: Cannot have a space after `_` '
                    write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    write(log_unit,*) repeat(' ', 5+5+nint(log10(real(shelxline%line_number)))+1), '^'
                    summary%error_no=summary%error_no+1
                    return
                end if
            end if        
        end if
    end if
    
    call deduplicates(shelxline%line(linepos:), stripline)
    call to_upper(stripline)    

    call explode(stripline, lenlabel, splitbuffer)    
    
    ! first element is the number of atoms (optional)
    read(splitbuffer(1), *, iostat=iostatus) numatom
    if(iostatus/=0) then
        numatom=-1
        start=0
    else
        start=1
        if( numatom<2 ) then
            write(log_unit, *) "Error: 2 atoms needed at least for EADP"
            write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
            summary%error_no=summary%error_no+1
            return
        end if
    end if
        
    eadp_table_index=eadp_table_index+1
    allocate(eadp_table(eadp_table_index)%atoms(size(splitbuffer)-start))
    call to_upper(splitbuffer(start+1:size(splitbuffer)), eadp_table(eadp_table_index)%atoms)
    eadp_table(eadp_table_index)%shelxline=trim(shelxline%line)
    eadp_table(eadp_table_index)%line_number=shelxline%line_number
    eadp_table(eadp_table_index)%residue=eadpresidue
    eadp_table(eadp_table_index)%namedresidue=namedresidue

end subroutine

!> Parse the RIGU keyword. Restrain Plane
subroutine shelx_rigu(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
integer i, j, linepos, start, iostatus
character, dimension(13), parameter :: numbers=(/'0','1','2','3','4','5','6','7','8','9','.','-','+'/)
logical found
character(len=128) :: buffernum
character(len=128) :: namedresidue
integer :: riguresidue
character(len=lenlabel), dimension(:), allocatable :: splitbuffer
character(len=:), allocatable :: stripline
real s1, s2

    ! parsing more complicated on this one as we don't know the number of parameters
    linepos=5 ! First 4 is RIGU
    
    if(len_trim(shelxline%line)<5) then
        write(log_unit,*) 'Error: Empty RIGU'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if

    if(index(shelxline%line,'<')>0 .or. index(shelxline%line,'>')>0) then
        write(log_unit,*) 'Error: < or > is not implemented'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    
    if(index(shelxline%line,'$')>0) then
        write(log_unit,*) 'Error: symmetry equivalent `_$?` is not implemented'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    
    riguresidue=-99
    buffernum=''
    ! check for subscripts on dfix
    if(shelxline%line(5:5)=='_') then
        ! check for `_*̀
        if(shelxline%line(6:6)=='*') then
            riguresidue=-1
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
                read(buffernum, *) riguresidue
                linepos=6+j
            end if

            ! check for a residue name
            if(riguresidue==-99) then
                if(shelxline%line(6:6)/=' ') then
                    ! RIGU applied to named residue
                    i=6
                    j=1
                    do while(shelxline%line(i:i)/=' ')
                        namedresidue(j:j)=shelxline%line(i:i)
                        i=i+1
                        j=j+1
                        linepos=linepos+1
                        if(i>=len(shelxline%line)) exit
                    end do
                    riguresidue=-98
                    linepos=linepos+1
                else
                    write(log_unit,*) 'Error: Cannot have a space after `_` '
                    write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
                    write(log_unit,*) repeat(' ', 5+5+nint(log10(real(shelxline%line_number)))+1), '^'
                    summary%error_no=summary%error_no+1
                    return
                end if
            end if        
        end if
    end if
    
    call deduplicates(shelxline%line(linepos:), stripline)
    call to_upper(stripline)    

    call explode(stripline, lenlabel, splitbuffer)
    
    ! first element is s1 (esd for 1,2 distances)
    read(splitbuffer(1), *, iostat=iostatus) s1
    if(iostatus/=0) then
        s1=-1
        start=0
    else
        ! second element is s2 (esd for 1,3 distances)
        read(splitbuffer(1), *, iostat=iostatus) s2
        if(iostatus/=0) then
            s2=-1
            start=1
        else
            start=2
        end if
    end if
    
    if(start>1) then
        write(log_unit,*) 'Error: s1, s2 options in RIGU not supported '
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
    
    rigu_table_index=rigu_table_index+1
    allocate(rigu_table(rigu_table_index)%atoms(size(splitbuffer)-start))
    call to_upper(splitbuffer(start+1:size(splitbuffer)), rigu_table(rigu_table_index)%atoms)
    rigu_table(rigu_table_index)%shelxline=trim(shelxline%line)
    rigu_table(rigu_table_index)%line_number=shelxline%line_number
    rigu_table(rigu_table_index)%residue=riguresidue
    rigu_table(rigu_table_index)%namedresidue=namedresidue

end subroutine

!> Parse the END keyword. Set the_end to true.
subroutine shelx_end(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    the_end=.true.
    
end subroutine

!> Parse the ISOR keyword. Restrain to isotropic
subroutine shelx_isor(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline

    if(len_trim(shelxline%line)<5) then
        write(log_unit,*) 'Error: Empty ISOR'
        write(log_unit, '("Line ", I0, ": ", a)') shelxline%line_number, trim(shelxline%line)
        summary%error_no=summary%error_no+1
        return
    end if
        
    isor_table_index=isor_table_index+1
    isor_table(isor_table_index)%shelxline=trim(shelxline%line)
    isor_table(isor_table_index)%line_number=shelxline%line_number
    isor_table(isor_table_index)%esd1=0.0
    isor_table(isor_table_index)%esd2=0.0

end subroutine

!> Parse the SHEL keyword. 
subroutine shelx_shel(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
character(len=512) :: buffer

    write(buffer, '(A, A)') 'SHEL ', trim(adjustl(shelxline%line(5:)))
    call extras_info%write(trim(buffer))
end subroutine

!> Parse the OMIT keyword. 
subroutine shelx_omit(shelxline)
use crystal_data_m
implicit none
type(line_t), intent(in) :: shelxline
character(len=512) :: buffer

    write(buffer, '(A, A)') 'OMIT ', trim(adjustl(shelxline%line(5:)))
    call extras_info%write(trim(buffer))
end subroutine

end module
