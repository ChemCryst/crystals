!> Module dealing with the absolution configuration of the crystal structure
!! 
module sfls_punch_mod
implicit none
integer, private :: normal_unit=0
integer, private :: design_unit=0
integer, private :: wdf_unit=0

contains

subroutine sfls_punch_init_normalfile(sfls_punch_flag, l12b1, M33CD15)
implicit none
integer, intent(in) :: sfls_punch_flag, l12b1, M33CD15
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
        filecount = get_newfilename('normal', '.m')
        write(file_name, '(a,i0,a)'), 'normal', filecount, '.m'
        print *, trim(file_name)

        normal_unit=785
        open(normal_unit, file=file_name, status='new')
        write(normal_unit, '(A,I12)') '% ', L12B1
        write(normal_unit, '(''N={};'')')
        if (M33CD15 .eq. 1 ) then
            write(normal_unit, '(''NNorm={};'')')
            write(normal_unit, '(''VCNorm={};'')')
        end if
        write(normal_unit, '(''VC={};'')')
        write(normal_unit, '(''NormVect={};'')')
        write(normal_unit, '(''NBackNorm={};'')')    
        
    case(2) ! plain text
    ! Nothing needed here
        
    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine
    
subroutine sfls_punch_close_normalfile(sfls_punch_flag, m33cd15)
implicit none
integer, intent(in) :: sfls_punch_flag
integer, intent(in) :: m33cd15
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
        if (m33cd15 .eq. 1 ) then
            write(normal_unit, '(''NNorm=collectBlocks(NNorm);'')')
            write(normal_unit, '(''VCNorm=collectBlocks(VCNorm);'')')
        end if
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

subroutine sfls_punch_init_design(sfls_punch_flag)
use xlst12_mod, only: L12B
use xlst33_mod, only: M33CD
implicit none
integer, intent(in) :: sfls_punch_flag
integer filecount
character(len=255) :: file_name

    if(design_unit/=0) then
        print *, 'design matrix file already opened'
        call abort()
    end if

    ! Write header
    select case(sfls_punch_flag)
    case(1) ! matlab

        ! search for new file to open
        filecount = max(get_newfilename('design', '.m'), get_newfilename('wdf', '.m'))

        design_unit=786
        write(file_name, '(a,i0,a)'), 'design', filecount, '.m'
        open(design_unit, file=file_name, status='new')
        write (design_unit, '(''a=['')')
        
    case(2) ! plain text

        ! search for new file to open
        filecount = max(get_newfilename('design', '.dat'), get_newfilename('wdf', '.dat'))

        design_unit=786
        write(file_name, '(a,i0,a)'), 'design', filecount, '.dat'
        open(design_unit, file=file_name, status='new')
        
    case default
        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

subroutine sfls_punch_normal(nmatrix, nmsize, sfls_punch_flag)
implicit none
real, dimension(:), intent(in) :: nmatrix
integer, intent(in) :: nmsize
integer, intent(in) :: sfls_punch_flag
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
        filecount = get_newfilename('normal', '.dat')
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

subroutine sfls_punch_variance(nmatrix, nmsize, sfls_punch_flag)
implicit none
real, dimension(:), intent(in) :: nmatrix
integer, intent(in) :: nmsize
integer, intent(in) :: sfls_punch_flag
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
        filecount = get_newfilename('variance', '.dat')
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

subroutine sfls_punch_addtodesign(designmatrix, hkllist, punch)
implicit none
double precision, dimension(:,:), intent(in) :: designmatrix
integer, dimension(:,:), intent(in) :: hkllist
logical, optional, intent(in) :: punch
integer i
logical fileopened

    if(present(punch)) then
        write (design_unit, '(''];'')')
        close(design_unit)
        design_unit=0
        return
    end if

    print *, 'Punching...'
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

end subroutine


subroutine sfls_punch_addtowdf(wdf, punch)
implicit none
real, intent(in) :: wdf
logical, optional, intent(in) :: punch
real, dimension(:), allocatable, save :: wdflist
real, dimension(:), allocatable :: wdftemp
integer, save :: wdfindex=0
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
    
    ! search for new file to open
    filecount = get_newfilename('wdf', '.m')
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

integer function get_newfilename(file_name, file_ext) result(filecount)
implicit none
logical file_exists
character(len=*), intent(in) :: file_name, file_ext
character(len=255) :: tempstr

    ! search for new file to open
    filecount = 0
    file_exists = .true.
    do while (file_exists)
        write(tempstr, '(a,i0,a)'), file_name, filecount, file_ext
        inquire(FILE=trim(tempstr), EXIST=file_exists)
        filecount = filecount + 1
    end do
    filecount=filecount-1
    
end function

end module


