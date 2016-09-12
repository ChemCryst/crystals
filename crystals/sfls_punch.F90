! The module sfls_punch_mod deals with the export of different matrices during refinement
module sfls_punch_mod
implicit none
integer, private :: normal_unit=0 !< unit number for the file
integer, private :: design_unit=0 !< unit number for the file
integer, private :: wdf_unit=0 !< unit number for the file
integer, private :: fileindex=-1 !< index used in the different filenames
!> List of filename used. This list is used to find a new index for the filenames.
character(len=24), dimension(4), parameter, private :: filelist=(/ &
&  'normal  ', &
&  'design  ', &
&  'wdf     ', &
&  'variance' /)
!> list of extension used. This list is used to find a new index for the filenames.
character(len=4), dimension(2), parameter, private :: extlist=(/ '.m  ', '.dat' /)

private get_newfilename
  
contains

!> Open and initialise normal[0-9].* file
subroutine sfls_punch_init_normalfile(sfls_punch_flag, l12b1)
implicit none
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
integer, intent(in) :: l12b1 !< Number of parameters from the least squares
integer filecount
character(len=255) :: file_name

    ! Write header
    select case(sfls_punch_flag)
    case(1) ! matlab
        if(normal_unit/=0) then
            print *, 'normal matrix file already opened'
            call abort()
        end if

        ! search for new file to open
        filecount = get_newfilename()
        write(file_name, '(a,i0,a)'), 'normal', filecount, '.m'

        normal_unit=785
        open(normal_unit, file=file_name, status='new')
        write(normal_unit, '(A,I12)') '% ', L12B1
        write(normal_unit, '(''N={};'')')
        write(normal_unit, '(''VC={};'')')
        
    case(2) ! plain text
    ! Nothing needed here
        
    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine
    
!> Close normal[0-9].* file
subroutine sfls_punch_close_normalfile(sfls_punch_flag)
implicit none
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
integer filecount
logical file_exists
character(len=255) :: file_name
character(len=4) :: file_ext 
logical fileopened

    ! Write header
    select case(sfls_punch_flag)
    case(1) ! matlab
        if(normal_unit==0) then
            print *, 'normal matrix file not opened yet'
            call abort()
        end if
        
        inquire(normal_unit, opened=fileopened)
        if(.not. fileopened) then
            print *, 'normal matrix file not opened but unit set'
            call abort()
        end if        

        write(normal_unit, '(''N=collectBlocks(N)'')')
        write(normal_unit, '(''VC=collectBlocks(VC);'')')        
        close(normal_unit)
        normal_unit=0
        
    case(2) ! plain text
    ! Nothing needed here
        
    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> Initialisation of design[0-9].m file
subroutine sfls_punch_init_design(sfls_punch_flag)
implicit none
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
integer filecount
character(len=255) :: file_name

    if(design_unit/=0) then
        print *, 'design matrix file already opened'
        call abort()
    end if

    ! search for new file to open
    filecount = get_newfilename()

    ! Write header
    select case(sfls_punch_flag)
    case(1) ! matlab

        design_unit=786
        write(file_name, '(a,i0,a)'), 'design', filecount, '.m'
        open(design_unit, file=file_name, status='new')
        write (design_unit, '(''a=['')')
        
    case(2) ! plain text

        design_unit=786
        write(file_name, '(a,i0,a)'), 'design', filecount, '.dat'
        open(design_unit, file=file_name, status='new')
        
    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> Writting the normal matrix to the file (before conditioning)
subroutine sfls_punch_normal(nmatrix, nmsize, sfls_punch_flag)
implicit none
real, dimension(:), intent(in) :: nmatrix !< Normal matrix (packed upper triangular)
integer, intent(in) :: nmsize !< size of the matrix
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
real, dimension(:,:), allocatable :: unpacked
integer i,j,k, xpos, ypos
character(len=255) :: file_name
integer filecount

    allocate(unpacked(nmsize, nmsize))
    do i=1, nmsize
        j = ((i-1)*(2*(nmsize)-i+2))/2
        k = j + nmsize - i
        ! unpacking
        unpacked(i:nmsize, i)=nmatrix(1+j:1+k)
        unpacked(i, i+1:nmsize)=nmatrix(1+j+1:1+k)
    end do

    select case(sfls_punch_flag)
    case(1) ! matlab
        if(normal_unit==0) then
            print *, 'normal matrix file not opened yet'
            call abort()
        end if

        write (normal_unit, '(A, '' = ['')'), 'N{length(N)+1}'
        do xpos = 1, nmsize
            do ypos = 1, nmsize
                if (mod(ypos, 6) .eq. 0) write (normal_unit, '(A)'), '...'
                write (normal_unit, '(G16.8$)'), unpacked(ypos, xpos)
            end do
            if (xpos/=nmsize) then
                write (normal_unit, '(A)'), ';'
            end if
        end do
        write (normal_unit, '(A)'), '];'

    case(2) ! plain text

        ! search for new file to open
        filecount = get_newfilename()
        write(file_name, '(a,i0,a)'), 'normal', filecount, '.dat'
        normal_unit=785
        open(normal_unit, file=file_name, status='new')
        do xpos = 1, nmsize
            write (normal_unit, *), unpacked(:, xpos)
        end do    
        close(normal_unit)
        normal_unit=0
        
    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select
end subroutine

!> Writting of the variance/covariance matrix to the file
subroutine sfls_punch_variance(nmatrix, nmsize, sfls_punch_flag)
implicit none
real, dimension(:), intent(in) :: nmatrix !< Variance/covariance matrix (packed upper triangular)
integer, intent(in) :: nmsize !< size of the matrix
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
real, dimension(:,:), allocatable :: unpacked
integer i,j,k, xpos, ypos
character(len=255) :: file_name
integer filecount

    allocate(unpacked(nmsize, nmsize))
    do i=1, nmsize
        j = ((i-1)*(2*(nmsize)-i+2))/2
        k = j + nmsize - i
        ! unpacking
        unpacked(i:nmsize, i)=nmatrix(1+j:1+k)
        unpacked(i, i+1:nmsize)=nmatrix(1+j+1:1+k)
    end do

    select case(sfls_punch_flag)
    case(1) ! matlab
        if(normal_unit==0) then
            print *, 'normal matrix file not opened yet'
            call abort()
        end if

        write (normal_unit, '(A, '' = ['')'), 'VC{length(VC)+1}'
        do xpos = 1, nmsize
            do ypos = 1, nmsize
                if (mod(ypos, 6) .eq. 0) write (normal_unit, '(A)'), '...'
                write (normal_unit, '(G16.8$)'), unpacked(ypos, xpos)
            end do
            if (xpos/=nmsize) then
                write (normal_unit, '(A)'), ';'
            end if
        end do
        write (normal_unit, '(A)'), '];'

    case(2) ! plain text

        ! search for new file to open
        filecount = get_newfilename()
        write(file_name, '(a,i0,a)'), 'variance', filecount, '.dat'
        normal_unit=785
        open(normal_unit, file=file_name, status='new')
        do xpos = 1, nmsize
            write (normal_unit, *), unpacked(:, xpos)
        end do    
        close(normal_unit)
        normal_unit=0
        
    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select
end subroutine

!> Write a part of the design matrix to the file
subroutine sfls_punch_addtodesign(designmatrix, hkllist, sfls_punch_flag, punch)
implicit none
double precision, dimension(:,:), intent(in) :: designmatrix !< Block of the design matrix
integer, dimension(:,:), intent(in) :: hkllist !< List of corresponding hkl indices
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
logical, optional, intent(in) :: punch !< Flag to close the file when done
integer i
logical fileopened

    select case(sfls_punch_flag)
    case(1) ! matlab

        if(present(punch)) then
            write (design_unit, '(''];'')')
            close(design_unit)
            design_unit=0
            return
        end if

        if(design_unit==0) then
            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
            print *, 'design matrix file not opened but unit set'
            call abort()
        end if
        
        do i=1, ubound(designmatrix, 2)
            write(design_unit, '(a, 3I4)') ' % ', hkllist(:,i)
            write(design_unit, '(5G16.8,: ," ...")') designmatrix(:,i)
        end do

    case(2) ! plain text
    
        if(present(punch)) then
            close(design_unit)
            design_unit=0
            return
        end if

        if(design_unit==0) then
            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
            print *, 'design matrix file not opened but unit set'
            call abort()
        end if
        
        do i=1, ubound(designmatrix, 2)
            write(design_unit, *) hkllist(:,i), designmatrix(:,i)
        end do

    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> add a value to wdf in memory. When punch is set, the content is written to a file
subroutine sfls_punch_addtowdf(wdf, sfls_punch_flag, punch)
implicit none
real, intent(in) :: wdf !< wdf value
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
logical, optional, intent(in) :: punch !< Flag to write and close the file
real, dimension(:), allocatable, save :: wdflist !< Array holding the wdf values
real, dimension(:), allocatable :: wdftemp
integer, save :: wdfindex=0 !< current index in wdflist
character(len=255) :: file_name
integer filecount

if(present(punch)) then
    if(.not. allocated(wdflist)) then
        print *, 'Cannot output array, not allocated'
        call abort()
    end if
    
    if(wdfindex==0) then
        print *, 'Cannot output array, wdflist is empty'
        call abort()
    end if
    
    select case(sfls_punch_flag)
    case(1) ! matlab

        ! search for new file to open
        filecount = get_newfilename()
        write(file_name, '(a,i0,a)'), 'wdf', filecount, '.m'
        wdf_unit=785
        open(wdf_unit, file=file_name, status='new')
        write (wdf_unit, '(''DF=['')')
        write(wdf_unit, '(5G16.8,: ," ...")') wdflist(1:wdfindex)
        write (wdf_unit, '(''];'')')
        close(wdf_unit)
        wdf_unit=0
        deallocate(wdflist)
        wdfindex=0

    case(2) ! plain text

        ! search for new file to open
        filecount = get_newfilename()
        write(file_name, '(a,i0,a)'), 'wdf', filecount, '.dat'
        wdf_unit=785
        open(wdf_unit, file=file_name, status='new')
        write(wdf_unit, *) wdflist(1:wdfindex)
        close(wdf_unit)
        wdf_unit=0
        deallocate(wdflist)
        wdfindex=0

    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select
    
    return
    
end if

if(wdfindex==0) then
    allocate(wdflist(1024))
end if

if(wdfindex>=size(wdflist)) then
    ! array full, extending...
    allocate(wdftemp(size(wdflist)))
    wdftemp=wdflist
    deallocate(wdflist)
    allocate(wdflist(size(wdftemp)+1024))
    wdflist(1:size(wdftemp))=wdftemp
    deallocate(wdftemp)
end if

wdfindex=wdfindex+1
wdflist(wdfindex)=wdf

end subroutine

!> Search for the next available index for the file name
integer function get_newfilename() result(filecount)
implicit none
logical file_exists
character(len=255) :: tempstr
integer i, j

    if(fileindex>=0) then
        filecount=fileindex
        return
    end if
    
    filecount=-1
    dofind:do
        file_exists=.false.
        filecount=filecount+1
        do i=1,size(extlist)
            do j=1,size(filelist)
                write(tempstr, '(a,i0,a)'), trim(filelist(j)), filecount, trim(extlist(i))                
                inquire(FILE=trim(tempstr), EXIST=file_exists)
                if(file_exists) cycle dofind
            end do
        end do
        exit dofind
    end do dofind
    
    fileindex=filecount
end function

!> Reset the counter for the filename
subroutine sfls_punch_reset_filename()
implicit none
    fileindex=-1
end subroutine

end module


