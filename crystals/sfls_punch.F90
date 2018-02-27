!> The module sfls_punch_mod deals with the export of different matrices and claculations during refinement
!!
!! \detaileddescription
!!
!! 4 options under \sfls, \refine can be used: PUNCH, CALCULATE, PLOT, P1
!! - PUNCH:  Outputs available: Matlab(1), plain text(2) and numpy(3) 
!! - CALCULATE: leverages(1)
!! - PLOT(optional): yes or no. plot a graph on crystals gui.
!! - P1(optional): parameter used to tweak results of punch and/or calculate
!!
!! (1.1) **Matlab output (PUNCH=MATLAB)**
!!
!! - design*.m stores the design matrix. The h,k,l index is written as a comment before the row of the design matrix.
!!   The design matrix is weighted with the square root of the weights so that when forming the normal matrix the result is weighted.
!! - normal*.m stores the normal matrix and the variance/covariance matrix as a n*n matrix
!! - wdf*.m stores the weights
!!
!! (1.2) **Plain ascii output (PUNCH=TEXT)**
!!
!! - design*.dat stores the design matrix. Each row starts with the h,k,l index followed by the derivatives
!!   The design matrix is weighted with the square root of the weights so that when forming the normal matrix the result is weighted.
!! - normal*.dat stores the normal matrix as a n*n matrix
!! - variance*.dat stores the variance/covariance matrix as a n*n matrix
!! - wdf*.dat stores the weights
!!
!! (1.3) **Numpy output (PUNCH=NUMPY)**
!!
!! - design*.npy stores the design matrix. Each row starts with the h,k,l index followed by the derivatives
!!   The design matrix is weighted with the square root of the weights so that when forming the normal matrix the result is weighted.
!! - normal*.npy stores the normal matrix as a n*n matrix
!! - variance*.npy stores the variance/covariance matrix as a n*n matrix
!! - wdf*.npy stores the weights
!! - crystals*.py is python with a bunch of usefull matrices fr doing calculations.
!!
!! ################################################################
!!
!! (2.1) **leverages (CALCULATE=LEVERAGES)**
!!
!! - Calculate leverages and t values to a file. Format is set using PUNCH.
!!
!! ################################################################
!!
!! (3.1) **Option PLOT=YES**
!!
!! - When used with CALCULATE, it plots graphs in the gui window.
!!
!! ################################################################
!!
!! (4.1) **Option P1=0.0**
!!
!! - When use with CALCULATE, it passes arguments. Their use differ depending
!!   on the calculation made. At the moment, only the leverages calculations exist
!!   and the P1 parameter chose the least square parameter to plot its \em t value.
!!
!! ################################################################
!!
!! The file naming is kept consistent. The same index is used for files written is the same cycle. See sfls_punch_get_newfileindex().
!!
module sfls_punch_mod
implicit none
integer, private :: normal_unit=0 !< unit number for the file
integer, private :: design_unit=0 !< unit number for the file
integer, private :: wdf_unit=0 !< unit number for the file
integer, private :: reflections_unit=0  !< unit number for the file
integer, private, save :: fileindex=-1 !< index used in the different filenames
integer, parameter, private :: funitconstant=452 !< constant added to graphical unit to generate a file unit
!> List of filename used. This list is used to find a new index for the filenames.
character(len=27), dimension(6), parameter, private :: filelist=(/ &
&  'normal     ', &
&  'design     ', &
&  'reflections', &
&  'wdf        ', &
&  'variance   ', &
&  'leverages  ' /)
!> list of extension used. This list is used to find a new index for the filenames.
character(len=4), dimension(3), parameter, private :: extlist=(/ '.m  ', '.dat' , '.npy'/)

private sfls_punch_get_newfileindex
private sfls_punch_addtodesign_sp, sfls_punch_addtodesign_dp

!> generic interface for sfls_punch_addtodesign
interface sfls_punch_addtodesign
    module procedure :: sfls_punch_addtodesign_sp, sfls_punch_addtodesign_dp
end interface
  
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
!            print *, 'normal matrix file already opened'
            call abort()
        end if

        ! search for new file to open
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'normal', filecount, '.m'

        normal_unit=785
        open(normal_unit, file=file_name, status='new')
        write(normal_unit, '(A,I12)') '% ', L12B1
        write(normal_unit, '(''N={};'')')
        write(normal_unit, '(''VC={};'')')
        
    case(2) ! plain text
    ! Nothing needed here

    case(3) ! numpy
    ! Nothing needed here
        
    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine
    
!> Close normal[0-9].* file
subroutine sfls_punch_close_normalfile(sfls_punch_flag)
implicit none
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
logical fileopened

    ! Write header
    select case(sfls_punch_flag)
    case(1) ! matlab
        if(normal_unit==0) then
!            print *, 'normal matrix file not opened yet'
            call abort()
        end if
        
        inquire(normal_unit, opened=fileopened)
        if(.not. fileopened) then
!            print *, 'normal matrix file not opened but unit set'
            call abort()
        end if        

        write(normal_unit, '(''N=collectBlocks(N)'')')
        write(normal_unit, '(''VC=collectBlocks(VC);'')')        
        close(normal_unit)
        normal_unit=0
        
    case(2) ! plain text
    ! Nothing needed here
        
    case(3) ! numpy
    ! Nothing needed here

    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> Initialisation of design[0-9]* file
subroutine sfls_punch_init_design(sfls_punch_flag)
implicit none
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
integer filecount
character(len=255) :: file_name

    if(design_unit/=0) then
!        print *, 'design matrix file already opened'
        call abort()
    end if

    ! search for new file to open
    filecount = sfls_punch_get_newfileindex()

    ! Write header
    select case(sfls_punch_flag)
    case(1) ! matlab

        design_unit=786
        write(file_name, '(a,i0,a)') 'design', filecount, '.m'
        open(design_unit, file=file_name, status='new')
        write (design_unit, '(''a=['')')
        
    case(2) ! plain text

        design_unit=786
        write(file_name, '(a,i0,a)') 'design', filecount, '.dat'
        open(design_unit, file=file_name, status='new')
        call print_design_header()

    case(3) ! numpy

        design_unit=786
        write(file_name, '(a,i0,a)') 'design', filecount, '.npy'
        open(design_unit, file=file_name, status='new', access='stream', form='unformatted')
        write(design_unit) repeat(' ', 128) ! book space for numpy header
        
    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> Initialisation of reflections[0-9]* file
subroutine sfls_punch_init_reflections(sfls_punch_flag, header)
implicit none
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
character(len=*), dimension(:), intent(in) :: header
integer filecount
character(len=255) :: file_name

    if(reflections_unit/=0) then
!        print *, 'design matrix file already opened'
        call abort()
    end if

    ! search for new file to open
    filecount = sfls_punch_get_newfileindex()

    ! Write header
    select case(sfls_punch_flag)
    case(1) ! matlab

        reflections_unit=796
        write(file_name, '(a,i0,a)') 'reflections', filecount, '.m'
        open(reflections_unit, file=file_name, status='new')
        write (reflections_unit, '(''a=['')')
        
    case(2) ! plain text

        reflections_unit=796
        write(file_name, '(a,i0,a)') 'reflections', filecount, '.dat'
        open(reflections_unit, file=file_name, status='new')
        call print_reflections_header(header)

    case(3) ! numpy

        reflections_unit=796
        write(file_name, '(a,i0,a)') 'reflections', filecount, '.npy'
        open(reflections_unit, file=file_name, status='new', access='stream', form='unformatted')
        write(reflections_unit) repeat(' ', 128) ! book space for numpy header
        
    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine


!> Writting the normal matrix to the file (before conditioning)
subroutine sfls_punch_normal(nmatrix, nmsize, sfls_punch_flag)
use numpy_mod, only: numpy_save
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
!            print *, 'normal matrix file not opened yet'
            call abort()
        end if

        write (normal_unit, '(A, '' = ['')') 'N{length(N)+1}'
        do xpos = 1, nmsize
            do ypos = 1, nmsize
                if (mod(ypos, 6) .eq. 0) write (normal_unit, '(A)') '...'
                write (normal_unit, '(G16.8$)') unpacked(ypos, xpos)
            end do
            if (xpos/=nmsize) then
                write (normal_unit, '(A)') ';'
            end if
        end do
        write (normal_unit, '(A)') '];'

    case(2) ! plain text

        ! search for new file to open
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'normal', filecount, '.dat'
        normal_unit=785
        open(normal_unit, file=file_name, status='new')
        do xpos = 1, nmsize
            write (normal_unit, *) unpacked(:, xpos)
        end do    
        close(normal_unit)
        normal_unit=0

    case(3) ! numpy

        ! search for new file to open
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'normal', filecount, '.npy'
        call numpy_save(trim(file_name), unpacked, shape(unpacked))
        
    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select
end subroutine

!> Writting of the variance/covariance matrix to the file
subroutine sfls_punch_variance(nmatrix, nmsize, sfls_punch_flag)
use numpy_mod, only: numpy_save
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
!            print *, 'normal matrix file not opened yet'
            call abort()
        end if

        write (normal_unit, '(A, '' = ['')') 'VC{length(VC)+1}'
        do xpos = 1, nmsize
            do ypos = 1, nmsize
                if (mod(ypos, 6) .eq. 0) write (normal_unit, '(A)') '...'
                write (normal_unit, '(G16.8$)') unpacked(ypos, xpos)
            end do
            if (xpos/=nmsize) then
                write (normal_unit, '(A)') ';'
            end if
        end do
        write (normal_unit, '(A)') '];'

    case(2) ! plain text

        ! search for new file to open
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'variance', filecount, '.dat'
        normal_unit=785
        open(normal_unit, file=file_name, status='new')
        do xpos = 1, nmsize
            write (normal_unit, *) unpacked(:, xpos)
        end do    
        close(normal_unit)
        normal_unit=0

    case(3) ! numpy

        ! search for new file to open
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'variance', filecount, '.npy'
        call numpy_save(trim(file_name), unpacked, shape(unpacked))
        
    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select
end subroutine

!> Write a part of the design matrix to the file or close the file.
!! 
!! It is important to pass the correct shape of the design matrix when closing so that the subroutine can work out the size of it.
subroutine sfls_punch_addtodesign_dp(designmatrix, hkllist, sfls_punch_flag, punch)
use numpy_mod, only: numpy_save, numpy_write_header
implicit none
double precision, dimension(:,:), intent(in) :: designmatrix !< Block of the design matrix
integer, dimension(:,:), intent(in) :: hkllist !< List of corresponding hkl indices
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
logical, optional, intent(in) :: punch !< Flag to close the file when done
integer i, mypos, m, n
logical fileopened
character(len=256) :: lineformat

    select case(sfls_punch_flag)
    case(1) ! matlab

        if(present(punch)) then
            write (design_unit, '(''];'')')
            close(design_unit)
            design_unit=0
            return
        end if

        if(design_unit==0) then
!            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'design matrix file not opened but unit set'
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
!            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'design matrix file not opened but unit set'
            call abort()
        end if
        
        write(lineformat, '("(3I5, 3X, ",I0,"E25.16)")') ubound(designmatrix, 1)
        do i=1, ubound(designmatrix, 2)
            write(design_unit, lineformat) hkllist(:,i), designmatrix(:,i)
        end do
        
    case(3) ! numpy
        if(present(punch)) then
            ! writing header
            ! we need to know how many values were written, it is a bit of guess work as the shape is not known
            inquire(unit=design_unit, pos=mypos) ! size of data in bytes is mypos-1-128, 128 is the space reserved for header, -1 because it is the position for a new write
            m=ubound(designmatrix, 1)
            n=((mypos-1-128)/8)/(m+3)
            call numpy_write_header(design_unit, (/n,m+3/), 128, 'C', '<f8')            
            
            close(design_unit)
            design_unit=0
            return
        end if
        
        if(design_unit==0) then
#if defined(CRY_OSLINUX)
            print *, 'design matrix file not opened yet'
#endif            
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
#if defined(CRY_OSLINUX)
            print *, 'design matrix file not opened but unit set'
#endif        
            call abort()
        end if

        do i=1, ubound(designmatrix, 2)
            write(design_unit) real(hkllist(:,i), kind(1.0d0)), designmatrix(:,i)
        end do

    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> Write a part of the design matrix to the file
subroutine sfls_punch_addtodesign_sp(designmatrix, hkllist, sfls_punch_flag, punch)
use numpy_mod, only: numpy_write_header
implicit none
real, dimension(:,:), intent(in) :: designmatrix !< Block of the design matrix
integer, dimension(:,:), intent(in) :: hkllist !< List of corresponding hkl indices
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
logical, optional, intent(in) :: punch !< Flag to close the file when done
integer i, m, n, mypos
logical fileopened
character(len=256) :: lineformat

    select case(sfls_punch_flag)
    case(1) ! matlab

        if(present(punch)) then
            write (design_unit, '(''];'')')
            close(design_unit)
            design_unit=0
            return
        end if

        if(design_unit==0) then
!            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'design matrix file not opened but unit set'
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
!            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'design matrix file not opened but unit set'
            call abort()
        end if
        
        write(lineformat, '("(3I5, 3X, ",I0,"E15.6)")') ubound(designmatrix, 1)
        do i=1, ubound(designmatrix, 2)
            write(design_unit, lineformat) hkllist(:,i), designmatrix(:,i)
        end do

    case(3) ! numpy
    
        if(present(punch)) then
            ! writing header
            ! we need to know how many values were written, it is a bit of guess work as the shape is not known
            inquire(unit=design_unit, pos=mypos) ! size of data in bytes is mypos-1-128, 128 is the space reserved for header, -1 because it is the position for a new write
            m=ubound(designmatrix, 1)
            n=((mypos-1-128)/4)/(m+3)
            call numpy_write_header(design_unit, (/n,m+3/), 128, 'C', '<f4')            

            close(design_unit)
            design_unit=0
            return
        end if
        
        if(design_unit==0) then
!            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(design_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'design matrix file not opened but unit set'
            call abort()
        end if
        
        do i=1, ubound(designmatrix, 2)
            write(design_unit) real(hkllist(:,i), kind(1.0)), designmatrix(:,i)
        end do

    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> add a value to wdf in memory. When punch is set, the content is written to a file
subroutine sfls_punch_addtowdf(wdf, sfls_punch_flag, punch)
use numpy_mod, only: numpy_save
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
 !       print *, 'Cannot output array, not allocated'
        call abort()
    end if
    
    if(wdfindex==0) then
!        print *, 'Cannot output array, wdflist is empty'
        call abort()
    end if
    
    select case(sfls_punch_flag)
    case(1) ! matlab

        ! search for new file to open
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'wdf', filecount, '.m'
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
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'wdf', filecount, '.dat'
        wdf_unit=785
        open(wdf_unit, file=file_name, status='new')
        write(wdf_unit, *) wdflist(1:wdfindex)
        close(wdf_unit)
        wdf_unit=0
        deallocate(wdflist)
        wdfindex=0

    case(3) ! numpy

        ! search for new file to open
        filecount = sfls_punch_get_newfileindex()
        write(file_name, '(a,i0,a)') 'wdf', filecount, '.npy'
        call numpy_save(trim(file_name), wdflist(1:wdfindex), (/wdfindex/))        
        deallocate(wdflist)
        wdfindex=0

    case default
 !       print *, 'Punch flag not recognised ', sfls_punch_flag
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

!> Write a part of the design matrix to the file
subroutine sfls_punch_addtoreflections(hkl, datas, sfls_punch_flag, punch)
use numpy_mod, only: numpy_write_header
implicit none
integer, dimension(3), intent(in) :: hkl
real, dimension(:), intent(in) :: datas
integer, intent(in) :: sfls_punch_flag !< Flag controlling the type of output
logical, optional, intent(in) :: punch !< Flag to close the file when done
integer m, n, mypos
logical fileopened
character(len=256) :: lineformat

    select case(sfls_punch_flag)
    case(1) ! matlab

        if(present(punch)) then
            write (reflections_unit, '(''];'')')
            close(reflections_unit)
            design_unit=0
            return
        end if

        if(reflections_unit==0) then
!            print *, 'reflections file not opened yet'
            call abort()
        end if
        
        inquire(reflections_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'reflections file not opened but unit set'
            call abort()
        end if
        
        write(reflections_unit, '(a, 3I4)') ' % ', hkl
        write(lineformat, '(a,I0,a)') '(',size(datas),'G16.8)'
        write(reflections_unit, lineformat) datas

    case(2) ! plain text
    
        if(present(punch)) then
            close(reflections_unit)
            reflections_unit=0
            return
        end if
        
        if(reflections_unit==0) then
!            print *, 'reflections file not opened yet'
            call abort()
        end if
        
        inquire(reflections_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'reflections file not opened but unit set'
            call abort()
        end if
        
        write(lineformat, '("(3I5, 3X, 1P, ",I0,"E15.6)")') size(datas)
        write(reflections_unit, lineformat) hkl, datas

    case(3) ! numpy
    
        if(present(punch)) then
            ! writing header
            ! we need to know how many values were written, it is a bit of guess work as the shape is not known
            inquire(unit=reflections_unit, pos=mypos) ! size of data in bytes is mypos-1-128, 128 is the space reserved for header, -1 because it is the position for a new write
            m=size(datas)
            n=((mypos-1-128)/4)/(m+3)
            call numpy_write_header(reflections_unit, (/n, m+3/), 128, 'C', '<f4')            

            close(reflections_unit)
            reflections_unit=0
            return
        end if
        
        if(reflections_unit==0) then
!            print *, 'design matrix file not opened yet'
            call abort()
        end if
        
        inquire(reflections_unit, opened=fileopened)
        if(.not. fileopened) then
 !           print *, 'design matrix file not opened but unit set'
            call abort()
        end if
        
        write(reflections_unit) real(hkl, kind(1.0)), datas

    case default
!        print *, 'Punch flag not recognised ', sfls_punch_flag
        call abort()
    end select

end subroutine

!> Search for the next available index for the file name.
!!
!! The index is not independent between files. The index is determined for a group of files using \p filelist and \p extlist.
!! Therefore, files with the same index belongs together.
integer function sfls_punch_get_newfileindex() result(filecount)
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
                write(tempstr, '(a,i0,a)') trim(filelist(j)), filecount, trim(extlist(i))                
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
    if(normal_unit/=0) then
 !       print *, 'normal file still open'
        call abort()
    end if
    if(design_unit/=0) then
 !       print *, 'design file still open'
        call abort()
    end if
    if(wdf_unit/=0) then
 !       print *, 'wdf file still open'
        call abort()
    end if
    fileindex=-1
end subroutine

subroutine print_reflections_header(header)
implicit none
character(len=*), dimension(:), intent(in) :: header
integer i

write(reflections_unit, '(a)', advance='no') '# '
do i=1, size(header)-1
    write(reflections_unit, '(a, a, a)', advance='no') '"', trim(header(i)), '", '
end do
write(reflections_unit, '(a, a, a)') '"', trim(header(size(header))), '"'

end subroutine

subroutine print_design_header()
use xunits_mod, only: ierflg
use xssval_mod, only: issprt
use xlst05_mod, only: l5, m5, md5, n5
use xlst12_mod, only: l12a, l12b, l12o, m12, m12a, m12b, md12a, md12b, n12, n12b
use xerval_mod, only:
use xopval_mod, only: iopabn, iopcmi, iopend, iopp22
implicit none

integer, parameter :: nameln = 18 
integer, parameter :: lover = 10 , nover = 6 
integer, parameter :: latomp = 8 , natomp = 13 
character(len=132) :: cline1 , cline2

integer i, j, l, iend, ipos
integer length, natom, nbatch, ncell, nelem, nexti, nlayer
integer nprof, nunref

real weight

include 'ISTORE.INC'
include 'STORE.INC'
include 'QSTORE.INC'

character(len=lover), dimension(nover), parameter :: cover= &
& (/ '   scale' , ' du[iso]' , ' ou[iso]', 'polarity' , ' enantio' , 'extparam' /)
character(len=latomp), dimension(natomp), parameter :: catomp= &
& (/ '        ' , '        ' , '   occ  ' , ' (flag) ', &
&    '    x   ' , '    y   ' , '    z   ' , &
&    '  u[11] ' , '  u[22] ' , '  u[33] ' , &
&    '  u[23] ' , '  u[13] ' , '  u[12] ' /)
character(len=latomp), dimension(natomp), parameter :: catomps= &
& (/ '        ' , '        ' , '        ' , '        ' , &
&    '        ' , '        ' , '        ' , &
&    '  u[iso]' , '  size  ' , '   dec  ' , &
&    '   azi  ' , '        ' , '        ' /)

!integer, external :: kstall, krddpv, kprtln

!    icombf = kstall (icomsz)
!    call xzerof (store(icombf), icomsz)

!    istat = krddpv ( istore(icombf) , icomsz )
!    if ( istat .lt. 0 ) then
!        print *, "error allocating space in store"
!        call abort()
!    end if !go to 9910

!    !c -- check if list 22 is available for printing
!    istat = kprtln ( 22 , i )
!    if ( istat .lt. 0 ) then !
!        print *, "error list 22 not available"
!        call abort()
!    end if !go to 9900

!    !c -- load lists 5 and 22
!    call xfal05
!    call xfal12 ( 0 , 0 , i , j )
!    if ( ierflg .lt. 0 ) then
!        print *, "error when loading list 5 or 22"
!        call abort()
!    end if !go to 9900

    if(n12b>1) then
!        print *, "error more than 1 bloc"
        call abort()
    end if
    
    write ( design_unit , 1205 )
    1205  format ('# Matrix relating least-squares parameters ' , &
    & 'to ''physical'' parameters' , /,'#' , /, &
    & '# format of entry describing relation of each physical ' , &
    & 'parameter that contributes to a least-squares parameter : ', /, &
    & '#', 10x , 'least-squares parameter number' , /, & 
    & '#', 10x , 'weight of the contribution' , /, '#' )

    m12=l12o
    m5 = l5
    j = 0

    natom = n5 + 1
    nlayer = natom + 1
    nelem = nlayer + 1
    nbatch = nelem + 1
    ncell = nbatch + 1
    nprof = ncell + 1
    nexti = nprof + 1

    !c -- pass through the groups
    do while(m12>0) !1250  continue
        l12a = istore(m12+1)

        cline1 = ' '
        cline2 = ' '

        j = j + 1

        !c -- write column headings
        if ( j .eq. 1 ) then
            write ( design_unit , 1255 ) cover
            1255    format ( '#', /  , '#', 19x , 13a )
            length = lover
        else if ( j .eq. 2 ) then
            write ( design_unit , 1256 ) catomp
            write ( design_unit , 1257 ) catomps
            1256    format ( '#', /  , '#', 3x , 13a )
            1257    format ( '#', 3x , 13a , / , '#')
            length = latomp
        endif

        !c -- write blank line separating atoms
        !write ( design_unit , '("#pp", 1X)' )

        !c -- assign a name to this group
        if ( j .eq. 1 ) then
            cline1(1:nameln) = 'overall parameters'
        else if ( j .le. natom ) then
            write ( cline1(1:nameln) , '(a4,f8.0)' ) istore(m5),store(m5+1)
            !c-c-c-write flag value into outputline
            write ( cline1((nameln+length+1):(nameln+2*length)) , &
            &         '(3x,a1,i1,a1,2x)' ) '(' , nint(store(m5+3)) , ')'
            m5 = m5 + md5
        else if ( j .eq. nlayer ) then
            cline1(1:nameln)  = 'layer scales'
        else if ( j .eq. nbatch ) then
            cline1(1:nameln) = 'batch scales'
        else if ( j .eq. nelem ) then
            cline1(1:nameln) = 'element scales'
        else if ( j .eq. ncell ) then
            cline1(1:nameln) = 'cell parameters'
        else if ( j .eq. nprof ) then
            cline1(1:nameln) = 'profile parameters'
        else if ( j .eq. nexti ) then
            cline1(1:nameln) = 'extinction param'
        endif

        ipos = nameln + 1

        !c -- pass through the individual parts for each group
        do while(l12a>0) !1350  continue

            md12a=istore(l12a+1)
            m12a=istore(l12a+2)
            l=istore(l12a+3)
            nunref = istore(l12a+4)
            !c
            !c-c-c-following (outer) if-block only reasonable for nunref < 0,
            !-c-c-but when could this happen ?????
            if ( nunref .le. 0 ) then
            else
                if ( (j .ge. 2) .and. (j .le. natom) ) then
                    !c-c-c-atomic parameters
                    ipos = ipos + (nunref-2) * length
                else
                    !c-c-c-overall and other parameters
                    ipos = ipos + nunref * length
                endif
            endif

            do i = m12a , l , md12a ! 1400
                iend = ipos + length - 1
                if ( md12a .gt. 1 ) then
                    weight = store(i+1)
                else
                    weight = 1.
                endif
                if ( istore(i) .gt. 0 ) then
                    write ( cline1(ipos:iend) , '(i5,3x)' ) istore(i)
                    write ( cline2(ipos:iend) , '(f8.4)' ) weight
                end if
                ipos = iend + 1
            end do !1400  continue
            
            write ( design_unit , "('#', 1X, A)" ) cline1
            write ( design_unit , "('#', 1X, A)" ) cline2
            ipos = nameln + 1
            cline1 = ' '
            cline2 = ' '

            !c -- increment to the next part
            l12a = istore(l12a)

            !c -- check if there is another part
        end do !if ( l12a .gt. 0 ) go to 1350

        !c -- increment to the next atom
        !2050  continue
        m12=istore(m12)
    end do !if ( m12 .gt. 0 ) go to 1250
    
    write(design_unit, '(A)') '#', '#'
    write(cline1, '("(A, A4, 2A5, 3X, ",I0,"I25)")') N12
    write(design_unit, cline1) '#', 'h', 'k', 'l', (/ (i, i=1, n12) /)

end subroutine

!> \brief Output leverages and t values to an output file
!! 
!! - Calculate the leverages and t values as described in https://doi.org/10.1107/S0021889812015191
!! - The calculation is done in 2 steps because we need the maximum t values to normalise the data and the t values are too much to be stored
!! - First calculate the leverages and store all of them, then the t values and save the max value
!! - Then calculate the t values again, normalise them and write to a file
!! 
!! The calculation is using a blocking algorithm to improve speed. block_size reflections are loaded and
!! the block is processed in one go. openmp does not make significant speed, I suspect the I/O is a limited factor.
!! using workshare for formatting the data, writing and calculating might speed things up but it does not seem to be necessary at the moment
subroutine sfls_punch_leverages(nsize, plot, tselectedarg)
use list26_mod, only: subrestraints_parent, restraints_list
use xiobuf_mod, only: cmon !< screen
use xunits_mod, only: ncvdu !< lis file
use numpy_mod, only: numpy_read_header, numpy_write_header
use list12_mod, only: param_t, load_lsq_params !< parameters list
!$ use OMP_LIB
implicit none
integer, intent(in) :: nsize !< number of parameters during least squares
logical, intent(in), optional :: plot !< plot some graphs
integer, intent(inout), optional :: tselectedarg !< choice of parameter to plot
integer, parameter :: block_size=2048
integer filecount, variance_unit, leverage_unit, refl_unit, sigmas_unit
character(len=255) :: file_name, formatstr
double precision, dimension(:,:), allocatable :: variance, design_block, temp2d !< inverse of the normal, block of the design matrix and temporary 2D matrix
double precision, dimension(:,:), allocatable :: reflections !< reflections data from reflections??.*
double precision, dimension(:,:), allocatable :: sigmas, sigmast !< sigmas and moo data from sigmas.dat (generated when merging)
double precision maxt, maxT2
double precision, dimension(:), allocatable :: leverage_all, tvalues, t2values, temp1d
double precision, dimension(3) :: hkl_dp
type(param_t), dimension(:), allocatable :: lsq_list !< List of least squares parameters
real, dimension(:,:), allocatable :: ftemp2d
real, dimension(:), allocatable :: ftemp1d
integer tselected
integer info, irestraint, i, j, k, previous, numobs, islider, datheader
double precision normalize
integer, dimension(:,:), allocatable :: hkl,temp2di
integer numfields, iostatus
logical file_exists, sigmas_exists, found
integer file_type !<  0 for npy, 1 for dat
character vorder, dorder
integer, dimension(:), allocatable :: vdatashape, ddatashape
integer vnpyformat, dnpyformat
character(len=1024) :: msgstatus
#if defined(CRY_OSLINUX)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

double precision, external :: ddot !< blas dot product

    if(present(tselectedarg)) then
        tselected=tselectedarg
    else
        tselected=1
    end if
    if(tselected>nsize) then
        tselected=nsize
    else if (tselected<1) then
        tselected=1
    end if

    write(cmon,'(A,A)') '{I Starting leverages calculations'
    call xprvdu(ncvdu, 1,0)
    write(cmon,'(A,I0)') '{I Calculating T2 values for parameter ', tselected
    call xprvdu(ncvdu, 1,0)
    ! updating slider in the gui
    call slider(0,100)
    
    if(design_unit/=0) then
#ifdef CRY_OSLINUX
        print *, 'design matrix file already opened'
#endif        
        call abort()
    end if

#if defined(CRY_OSLINUX)
    call date_and_time(VALUES=measuredtime)
    starttime=((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)
#endif

    ! search index for file to open and create
    filecount = sfls_punch_get_newfileindex()

    !####################
    !Looking for design matrix
    design_unit=786
    write(file_name, '(a,i0,a)') 'design', filecount, '.npy'
    inquire(file=file_name, exist=file_exists)
    file_type=0
    if(.not. file_exists) then
        write(file_name, '(a,i0,a)') 'design', filecount, '.dat'
        inquire(file=file_name, exist=file_exists)
        file_type=1
        if(.not. file_exists) then
            file_type=-1
#ifdef CRY_OSLINUX
            print *, 'design matrix file does not exist, programming error'
#endif        
            call abort()
        end if
    end if
    if(file_type==0) then
        open(design_unit, file=file_name, status='old', access='stream',  form='unformatted')
        call numpy_read_header(design_unit, dorder, ddatashape, dnpyformat)
        if(dnpyformat/=8) then
#ifdef CRY_OSLINUX
            print *, 'npy format in design matrix not supported ', dnpyformat
#endif        
            call abort()
        end if
        if(dorder/='C') then
#ifdef CRY_OSLINUX
            print *, 'npy order in design matrix not supported'
#endif        
            call abort()
        end if
    else
        open(design_unit, file=file_name, status='old')
        ! skip header
        info=0
        datheader=0
        do while(info==0)
            datheader=datheader+1
            read(design_unit, '(a)', iostat=info) formatstr
            if(formatstr(1:5)=='#   h') then
                exit
            end if
        end do
    end if
    
    !####################
    !Looking for variance matrix
    variance_unit=787
    write(file_name, '(a,i0,a)') 'variance', filecount, '.npy'
    inquire(file=file_name, exist=file_exists)
    file_type=0
    if(.not. file_exists) then
        write(file_name, '(a,i0,a)') 'variance', filecount, '.dat'
        inquire(file=file_name, exist=file_exists)
        file_type=1
        if(.not. file_exists) then
            file_type=-1
#ifdef CRY_OSLINUX
            print *, 'inverse of the normal matrix file does not exist, programming error'
#endif        
            call abort()
        end if
    end if
    if(file_type==0) then
        open(variance_unit, file=file_name, status='old', access='stream',  form='unformatted')
        call numpy_read_header(variance_unit, vorder, vdatashape, vnpyformat)
        if(size(vdatashape)/=2) then
#ifdef CRY_OSLINUX
            print *, 'data are not 2D'
#endif        
            call abort()
        end if
        if(vdatashape(1)/=nsize .or. vdatashape(2)/=nsize) then
#ifdef CRY_OSLINUX
            print *, 'data have the wrong size'
#endif        
            call abort()
        end if
        if(vnpyformat==4) then
            allocate(ftemp2d(nsize, nsize))
            read(variance_unit) ftemp2d
            allocate(variance(nsize, nsize))
            variance=ftemp2d
            deallocate(ftemp2d)
        else if(vnpyformat==8) then            
            allocate(variance(nsize, nsize))
            read(variance_unit) variance
        else 
#ifdef CRY_OSLINUX
            print *, 'npy format not supported'
#endif        
            call abort()
        end if
        close(variance_unit) 
        !no need the matrix is symmetric
        !if(vorder=='C') then
        !    variance=transpose(variance)
        !end if
    else
        open(variance_unit, file=file_name, status='old')
        allocate(variance(nsize, nsize))
        read(variance_unit, *) variance
        close(variance_unit)
    end if

    !####################
    !Looking for reflections data
    refl_unit=788
    write(file_name, '(a,i0,a)') 'reflections', filecount, '.npy'
    inquire(file=file_name, exist=file_exists)
    file_type=0
    if(.not. file_exists) then
        write(file_name, '(a,i0,a)') 'reflections', filecount, '.dat'
        inquire(file=file_name, exist=file_exists)
        file_type=1
        if(.not. file_exists) then
            file_type=-1
#ifdef CRY_OSLINUX
            print *, 'inverse of the normal matrix file does not exist, programming error'
#endif        
            call abort()
        end if
    end if
    if(file_type==0) then
        open(refl_unit, file=file_name, status='old', access='stream',  form='unformatted')
        call numpy_read_header(refl_unit, vorder, vdatashape, vnpyformat)
        if(size(vdatashape)/=2) then
#ifdef CRY_OSLINUX
            print *, 'data are not 2D'
#endif        
            call abort()
        end if
        if(vorder=='C') then
            if(vnpyformat==4) then
                allocate(ftemp1d(vdatashape(2)))
                allocate(reflections(vdatashape(1), vdatashape(2)))
                do i=1, vdatashape(1)
                    read(refl_unit) ftemp1d
                    reflections(i, :)=ftemp1d
                end do
                deallocate(ftemp1d)
            else if(vnpyformat==8) then            
                allocate(reflections(vdatashape(1), vdatashape(2)))
                read(refl_unit) reflections
            else 
            
#ifdef CRY_OSLINUX
                print *, 'npy format not supported'
#endif        
                call abort()
            end if
        else
             if(vnpyformat==4) then
                allocate(ftemp2d(vdatashape(1), vdatashape(2)))
                read(refl_unit) ftemp2d
                allocate(reflections(vdatashape(1), vdatashape(2)))
                reflections=ftemp2d
                deallocate(ftemp2d)
            else if(vnpyformat==8) then            
                allocate(reflections(vdatashape(1), vdatashape(2)))
                read(refl_unit) reflections
            else 
            
#ifdef CRY_OSLINUX
                print *, 'npy format not supported'
#endif        
                call abort()
            end if
        end if
        close(refl_unit) 
    else
        open(refl_unit, file=file_name, status='old')
        read(refl_unit, '(a)', iostat=info) formatstr
        if(formatstr(1:1)/='#') then
#ifdef CRY_OSLINUX
            print *, 'Error reflections file should start with a header line'
#endif              
            call abort()
        end if
        numfields=1
        do i=1, len_trim(formatstr)
            if(formatstr(i:i)==",") then
                numfields=numfields+1
            end if
        end do
        
        i=0
        allocate(reflections(1024, numfields))
        do 
            i=i+1
            if(i>ubound(reflections, 1)) then
                ! extend reflections
                call move_alloc(reflections, temp2d)
                allocate(reflections(ubound(temp2d, 1)+1024, numfields))
                reflections(1:ubound(temp2d, 1), :)=temp2d
                deallocate(temp2d)
            end if
            read(refl_unit, *, iostat=iostatus)  reflections(i, :)
            if(iostatus/=0) exit
        end do
        close(refl_unit)
    end if
    
    !####################
    !Looking for sigmas and moo
    sigmas_unit=788
    inquire(file='sigmas.dat', exist=sigmas_exists)
    if(sigmas_exists) then

        open(sigmas_unit, file='sigmas.dat', status='old')
        read(sigmas_unit, '(a)', iostat=info) formatstr ! skip first line (header)
        
        i=0
        allocate(sigmast(1024, 7))
        do 
            i=i+1
            if(i>ubound(sigmast, 1)) then
                ! extend reflections
                call move_alloc(sigmast, temp2d)
                allocate(sigmast(ubound(temp2d, 1)+1024, 7))
                sigmast(1:ubound(temp2d, 1), :)=temp2d
                deallocate(temp2d)
            end if
            read(sigmas_unit, *, iostat=iostatus)  sigmast(i, :)
            if(iostatus/=0) exit
        end do
        close(sigmas_unit)
        
        ! extracting the reflections that we need
        allocate(sigmas(ubound(reflections, 1), 7))
        previous=1
        k=0
        mainloop:do i=1, ubound(reflections, 1)
            found=.false.
            do j=previous, ubound(sigmas, 1) ! that should make the search faster if file is sorted
                if(j>ubound(sigmast, 1)) then ! unexpected error, cannot find the reflections. Is it the right file for the structure?
                    ! cancelling use of the sigmas
                    deallocate(sigmast)
                    exit mainloop
                end if
                if(all(nint(reflections(i,1:3))==nint(sigmast(j,1:3)))) then
                    k=k+1
                    sigmas(k,:)=sigmast(j,:)
                    previous=j
                    found=.true.
                    exit
                end if
            end do
            if(.not. found) then
                do j=1, ubound(sigmas, 1) ! doing the search again from the start, the file might not be sorted
                    if(j>ubound(sigmast, 1)) then ! unexpected error, cannot find the reflections. Is it the right file for the structure?
                        ! cancelling use of the sigmas
                        deallocate(sigmast)
                        exit mainloop
                    end if
                    if(all(nint(reflections(i,1:3))==nint(sigmast(j,1:3)))) then
                        k=k+1
                        sigmas(k,:)=sigmast(j,:)
                        previous=j
                        found=.true.
                        exit
                    end if
                end do
            end if
        end do mainloop
        deallocate(sigmast)
    end if
    
    call plot_leverages_init(1, '_VLEVP', 'k x Fo')
    call plot_leverages_init(2, '_VLEVR', 'sin(\Theta)/\lambda')
    if(sigmas_exists) then
        call plot_leverages_init(3, '_VLEVM', 'moo')
    end if
    
    !####################
    !opening leverages file for output
    leverage_unit=788
    if(file_type==0) then
        write(file_name, '(a,i0,a)') 'leverages', filecount, '.npy'
        open(leverage_unit, file=file_name, status='new', access='stream',  form='unformatted')
        write(leverage_unit) repeat(' ', 128) ! book space for numpy header
    else
        write(file_name, '(a,i0,a)') 'leverages', filecount, '.dat'
        open(leverage_unit, file=file_name, status='new')
    end if
    
    allocate(hkl(3, block_size))
    allocate(design_block(nsize, block_size))
    allocate(temp2d(nsize, block_size))
    allocate(leverage_all(0))
    allocate(tvalues(0))
    allocate(t2values(0))
    maxt=0.0d0
    maxT2=0.0d0

    ! Calculate leverages and T values
    !##################################################################
    info=0
    numobs=0
    islider=0
    ! data don't fit in memory and processing line by line is too slow
    ! Using a blocking algorithm where a block of the design matrix is read and processed
    ! leverages are saved for later the rest is just to calculate the max values
    do while(info==0)
        
        numobs=numobs+1
        if(file_type==0) then
            read(design_unit, iostat=info) hkl_dp, &
            &   design_block(:,mod(numobs-1,block_size)+1)
            hkl(:,numobs)=nint(hkl_dp)
        else
            read(design_unit, *, iostat=info, iomsg=msgstatus) hkl(:,numobs), &
            &   design_block(:,mod(numobs-1,block_size)+1)
        end if
        if(info/=0) exit
        
        if(mod(numobs-1,block_size)+1==block_size) then ! processing the block of design matrix
    
            ! Calculation of leverage see https://doi.org/10.1107/S0021889812015191
            ! Hat matrix: A (A^t W A)^-1 A^t W, leverage is diagonal element
            ! A is design matrix, W weight as a diagonal matrix
            ! (A^t W A)^-1 is the inverse of normal matrix
            ! calculation can be done one row of A at at time
            ! Careful, data store in fortran order, matriced are transposed compared to the Math
            
            ! bit for leverages
            !temp_block=matmul(variance, design_block)
            call dsymm('L', 'U', nsize, block_size, 1.0d0, variance, nsize, design_block, nsize, 0.0d0, temp2d, nsize)
            !call dgemm('N', 'N', nsize, block_size, nsize, 1.0d0, variance, nsize, design_block, nsize, 0.0d0, temp_block, nsize)
                        
            call move_alloc(hkl, temp2di)
            allocate(hkl(3, ubound(temp2di, 2)+block_size))
            hkl(1:3, 1:ubound(temp2di, 2))=temp2di
            deallocate(temp2di)
            call move_alloc(leverage_all, temp1d)
            allocate(leverage_all(size(temp1d)+block_size))
            leverage_all(1:size(temp1d))=temp1d
            deallocate(temp1d)
            call move_alloc(tvalues, temp1d)
            allocate(tvalues(size(temp1d)+block_size))
            tvalues(1:size(temp1d))=temp1d
            deallocate(temp1d)
            call move_alloc(t2values, temp1d)
            allocate(t2values(size(temp1d)+block_size))
            t2values(1:size(temp1d))=temp1d
            deallocate(temp1d)
            
            do i=1, block_size
                leverage_all(size(leverage_all)-block_size+i)=dot_product(design_block(:,i), temp2d(:,i))
                !leverage_all(size(leverage_all)-block_size+i) = ddot(nsize, design_block(:,i), 1, temp_block(:,i), 1) ! not much faster, vectors probably too small

                ! Careful, design is stored tansposed plus variance is symmtric so we can use the column instead of the row (contiguous in memory)
                ! tvalues(size(tvalues)-block_size+i)=dot_product(design_block(:,i), variance(:,tselected)) ! Replaced with faster blas call
            end do
            call dgemv('T', nsize, block_size, 1.0d0, design_block, nsize, &
            &   variance(:,tselected), 1, 0.0d0, tvalues(size(tvalues)-block_size+1:), 1)

            ! updating slider in the gui
            ! we don't know the number of observation so working out something for the slider
            islider=islider+(100-islider)/4
            call slider(islider,100)
            
        end if
        
    end do
    
    ! Processing the remaining incomplete block
    if(mod(numobs-1,block_size)+1/=block_size) then ! processing the reamining block
        design_block(:,mod(numobs-1,block_size)+1:)=0.0d0 ! zeroing unusued part of the block
    
        call dsymm('L', 'U', nsize, block_size, 1.0d0, variance, nsize, design_block, nsize, 0.0d0, temp2d, nsize)

        call move_alloc(leverage_all, temp1d)
        allocate(leverage_all(size(temp1d)+mod(numobs-1,block_size)))
        leverage_all(1:size(temp1d))=temp1d
        deallocate(temp1d)
        call move_alloc(tvalues, temp1d)
        allocate(tvalues(size(temp1d)+mod(numobs-1,block_size)))
        tvalues(1:size(temp1d))=temp1d
        deallocate(temp1d)
        call move_alloc(t2values, temp1d)
        allocate(t2values(size(temp1d)+mod(numobs-1,block_size)))
        t2values(1:size(temp1d))=temp1d
        deallocate(temp1d)
        
        do i=1, mod(numobs-1,block_size)
            leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i)=dot_product(design_block(:,i), temp2d(:,i))

            !tvalues(size(tvalues)-mod(numobs-1,block_size)+i)=dot_product(design_block(:,i), variance(:,tselected)) ! replaced with blas call below
        end do
        call dgemv('T', nsize, mod(numobs-1,block_size), 1.0d0, design_block, nsize, &
        &   variance(:,tselected), 1, 0.0d0, tvalues(size(tvalues)-mod(numobs-1,block_size)+1:), 1)
        
    end if
    numobs=numobs-1

    t2values(1:numobs)= tvalues(1:numobs)**2 / (1.0d0+leverage_all(1:numobs))
    maxt=maxval(abs(tvalues))
    maxt2=maxval(abs(t2values))
        
    ! updating slider in the gui
    call slider(100,100)
    
    normalize=real(numobs, kind(1.0d0))/real(nsize, kind(1.0d0))
    irestraint=0
    
    if(file_type==0) then
        ! reading the header again will reset the position in the file
        call numpy_read_header(design_unit, dorder, ddatashape, dnpyformat)
    else
        rewind ( unit=design_unit )  ! going back to begining of the file
        ! skip header
        do i=1, datheader
            read(design_unit, '(a)') formatstr
        end do
    end if
    
    ! Writing the values to a file and plotting
    !##################################################################
    write(formatstr, '(A,I0,A)') '(A, ", ", 3(I0,", "), 2(F7.4, ", "), ',2,'(1PE10.3, :, ", "))'
    if(file_type/=0) then
        write(leverage_unit, '(8(''"'',A,''"'',:,","))') 'Restraint','h','k','l', &
        &   'Leverage', 'Normalised leverage', 'Normalised t_ij', 'Normalised T2_ij'
    end if
    
    ! updating slider in the gui
    call slider(0,100)
    do i=1, numobs
        if(mod(i, numobs/10)==0) then
            call slider(90*i/numobs, 100)
        end if
    
        if(hkl(1,i)>1000) then
            irestraint=irestraint+1
        end if
                
        if(file_type==0) then
            write(leverage_unit) &
            &   real(hkl(:,i), kind(1.0d0)), leverage_all(i), &
            &   leverage_all(i)*normalize, &
            &   tvalues(i)/maxt*100.0d0, t2values(i)/maxT2*100.0d0
            if(irestraint==0) then
                if(present(plot)) then
                    if(plot) then
                        call plot_leverages_push(1, hkl(:,i), reflections(i, 4), &
                        &   leverage_all(i), &
                        &   -t2values(i)/maxT2*100.0d0)
                        call plot_leverages_push(2, hkl(:,i), reflections(i, 9), &
                        &   leverage_all(i), &
                        &   -t2values(i)/maxT2*100.0d0)
                        if(sigmas_exists) then
                            if(all(hkl(:,i)==nint(sigmas(i,1:3)))) then
                                call plot_leverages_push(3, hkl(:,i), sigmas(i, 7), &
                                &   leverage_all(i), &
                                &   -t2values(i)/(sigmas(i, 7)*maxT2)*100.0d0)
                            end if
                        end if
                    end if
                end if
            end if
        else
            if(irestraint==0) then
                write(leverage_unit, formatstr) &
                &   '""', hkl(:,i), leverage_all(i), &
                &   leverage_all(i)*normalize, &
                &   tvalues(i)/maxt*100.0d0, T2values(i)/maxT2*100.0d0
                if(present(plot)) then
                    if(plot) then
                        call plot_leverages_push(1, hkl(:,i), reflections(i, 4), &
                        &   leverage_all(i), &
                        &   -t2values(i)/maxT2*100.0d0)
                        call plot_leverages_push(2, hkl(:,i), reflections(i, 9), &
                        &   leverage_all(i), &
                        &   -t2values(i)/maxT2*100.0d0)
                        if(sigmas_exists) then
                            if(all(hkl(:,i)==nint(sigmas(i,1:3)))) then
                                call plot_leverages_push(3, hkl(:,i), sigmas(i, 7), &
                                &   leverage_all(i), &
                                &   -t2values(i)/(sigmas(i, 7)*maxT2)*100.0d0)
                            end if
                        end if
                    end if
                end if
            else
                write(leverage_unit, formatstr) &
                &   '"'//cleanrestraint(trim(restraints_list(subrestraints_parent(irestraint))%restraint_text))//'"', &
                &   hkl(:,i), leverage_all(i), &
                &   leverage_all(i)*normalize, &
                &   tvalues(i)/maxt*100.0d0, T2values(i)/maxT2*100.0d0
            end if
        end if
    end do
    ! updating slider in the gui
    call slider(90,100)

    if(present(plot)) then
        if(plot) then
            call plot_leverages_close(1)
            call plot_leverages_close(2)
            call plot_leverages_close(3)
            call load_lsq_params(lsq_list)
            write (cmon,'(a)') '^^CO  SET LSPARAMBOX REMOVE 0'
            call xprvdu(ncvdu,1,0)            
            write (cmon,'(a)') '^^WI SET LSPARAMBOX ADDTOLIST'
            call xprvdu(ncvdu,1,0)            
            do i=1, size(lsq_list)
                write(cmon, '(a, a, a)') "^^WI  '", trim(lsq_list(i)%print()), "'"
                call xprvdu(ncvdu, 1,0)
            end do
            write(cmon, '(a, a)') '^^WI  NULL'
            call xprvdu(ncvdu, 1,0)
            write(cmon, '(a, I0)') '^^WI SET LSPARAMBOX SELECTION=', tselected
            call xprvdu(ncvdu, 1,0)
        end if
    end if
    
    if(file_type==0) then
        call numpy_write_header(leverage_unit, (/numobs, 5+2*nsize/), 128, 'C', '<f8')
    end if
    
    close(leverage_unit)
    design_unit=0
    
    write(cmon,'(A,A)') '{I Leverages written in file: ', trim(file_name)
    call xprvdu(ncvdu, 1,0)      
    ! updating slider in the gui
    call slider(100,100)

    call Rfactorlev(reflections(1:numobs-irestraint,:), leverage_all(1:numobs-irestraint), numobs-nsize)

#if defined(CRY_OSLINUX)
    call date_and_time(VALUES=measuredtime)
    print *, ''
    print *, '--- Calculation of leverages ---'
    print *, 'sum of leverage and num of observations ', sum(leverage_all), numobs    
    print *, 'Calculation of leverages done in ', &
    ((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)-starttime, 'ms'
#endif

end subroutine

subroutine Rfactorlev(reflections, leverages, ratio)
use xiobuf_mod, only: cmon !< screen
use xunits_mod, only: ncvdu, ncwu !< lis file
use xssval_mod, only: issprt
use m_mrgrnk
use, intrinsic :: IEEE_ARITHMETIC
implicit none
double precision, dimension(:,:), intent(in) :: reflections !< reflection data
double precision, dimension(:), intent(in) :: leverages !< leverages
integer, intent(in) :: ratio !< unused
integer, dimension(:), allocatable :: sort_keys
double precision num, denum
integer i,j, levbin, rselect, start
character(len=3), dimension(4) :: rtype=(/' R1', 'wR2', ' R1', 'wR2'/)
integer, parameter :: nbins=5
integer, dimension(nbins,10) :: bins
character(len=24), dimension(nbins) :: fbins
double precision, dimension(nbins) :: nums, denums
double precision, dimension(nbins+1) :: bounds
double precision, dimension(nbins+1,10) :: Rwlev
double precision, dimension(10) :: levbounds
character(len=128) :: buffer
double precision interval
real dummy, fsq, sfsq
real, dimension(:), allocatable :: Ios ! I/sigma

    write(cmon, '(a)') ''
    call xprvdu(ncvdu, 1,0)
    write(cmon, '(a)') 'R1 and wR2 as a function of leverages and I/sigma'
    call xprvdu(ncvdu, 1,0)
    write(cmon, '(a)') ''
    call xprvdu(ncvdu, 1,0)
    if (issprt .eq. 0) then
        write(ncwu,'(a)') ''
        write(ncwu,'(a)') 'R1 and wR2 as a function of leverages and I/sigma'
        write(ncwu,'(a)') ''
    end if
    
    allocate(Ios(size(leverages)))
    allocate(sort_keys(size(leverages)))
    
    Ios=0.0
    do i=1, size(leverages)   
        call XSQRF (fsq,real(reflections(i, 4)),dummy,sfsq,real(reflections(i, 5)))
        Ios(i)=fsq/sfsq
    end do

    call mrgrnk(Ios, sort_keys)

    bounds(1)=-100.0d0
    bounds(2)=3.0d0
    do i=1, size(Ios)
        if(Ios(sort_keys(i))>=3.0) exit
    end do
    start=i
    interval=(size(Ios)-start)/(nbins-1)
    do i=3,nbins
        bounds(i)=real(nint(Ios(sort_keys((i-2)*interval+start))), kind(bounds(1)))
    end do
    bounds(nbins+1)=huge(1.0)

    call mrgrnk(leverages, sort_keys)

    do rselect=1, 2
    ! reselect=1 => R1
    ! reselect=2 => wR2
        if(rselect==1) then
            write(cmon,*) "R1 factor on binned reflections on I/sigma as function of leverages"
            call xprvdu(ncvdu, 1,0) 
        else if(rselect==2) then
            write(cmon,*) "wR2 factor on binned reflections on I/sigma as function of leverages"
            call xprvdu(ncvdu, 1,0) 
        end if
        
        nums=0.0d0
        denums=0.0d0
        num=0.0d0
        denum=0.0d0
        levbin=1
        bins=0
        Rwlev=0.0d0
        do i=1, size(leverages)   
            if(rselect==1) then
                num=num+abs(abs(reflections(sort_keys(i), 4))-reflections(sort_keys(i), 6))
                denum=denum+abs(reflections(sort_keys(i), 4))
            else if(rselect==2) then
                num=num+reflections(sort_keys(i), 7)**2*(reflections(sort_keys(i), 4)**2-reflections(sort_keys(i), 6)**2)**2
                denum=denum+reflections(sort_keys(i), 7)**2*reflections(sort_keys(i), 4)**4
            end if
            do j=1, nbins
                if(Ios(i)>=bounds(j) .and. &
                &   Ios(i)<=bounds(j+1)) then
                    if(rselect==1) then
                        bins(j,levbin:)=bins(j,levbin:)+1
                        nums(j)=nums(j)+abs(abs(reflections(sort_keys(i), 4))-reflections(sort_keys(i), 6))
                        denums(j)=denums(j)+abs(reflections(sort_keys(i), 4))
                    else if(rselect==2) then
                        bins(j,levbin:)=bins(j,levbin:)+1
                        nums(j)=nums(j)+reflections(sort_keys(i), 7)**2* &
                        &   (reflections(sort_keys(i), 4)**2-reflections(sort_keys(i), 6)**2)**2
                        denums(j)=denums(j)+reflections(sort_keys(i), 7)**2*reflections(sort_keys(i), 4)**4
                    end if
                    exit
                end if
            end do

            if(real(i, kind(1.0d0))/real(size(leverages), kind(1.0d0))>=0.1d0*levbin) then
                if(rselect==1) then
                    Rwlev(1:nbins,levbin)=100.0d0*nums/denums
                    Rwlev(nbins+1, levbin)=100.0d0*num/denum
                else if(rselect==2) then
                    Rwlev(1:nbins,levbin)=100.0d0*sqrt(nums/denums)
                    Rwlev(nbins+1, levbin)=100.0d0*sqrt(num/denum)
                end if
                levbounds(levbin)=leverages(sort_keys(i))
                levbin=levbin+1
            end if
        end do
        
#ifdef CRY_GUI
        write(cmon,'(" I/s    |   <3   |",3(1X,I2,"-",I2,1X,"|"), 1X,">",I2, "   |")') &
        &   (/ (nint(bounds(i)), nint(bounds(i+1)), i=2, nbins-1) /), nint(bounds(nbins))
        call xprvdu(ncvdu, 1,0)
        do i=1, 10
                    
            do j=1, nbins
                if(ieee_is_nan(Rwlev(j,i))) then
                    fbins(j)='no refls'
                else
                    if(Rwlev(j,i)>1.5*Rwlev(j,10)) then
                        write(fbins(j), '("{4,0",F8.2,"{1,0")') Rwlev(j,i)
                    else if(Rwlev(j,i)>1.2*Rwlev(j,10)) then
                        write(fbins(j), '("{6,0",F8.2,"{1,0")') Rwlev(j,i)
                    else
                        write(fbins(j), '("{1,0",F8.2,"{1,0")') Rwlev(j,i)
                    end if
                end if
            end do

            if(i==10) then
                do j=1, nbins
                    if(Rwlev(j,i)>1.2*Rwlev(nbins+1,i) .or. Rwlev(j,i)<0.8*Rwlev(nbins+1,i)) then
                        write(fbins(j), '("{11,0",F8.2,"{1,0")') Rwlev(j,i)
                    end if
                end do
            end if
            
            write(cmon,'(" {1,15n refl |", 5I8,  "|  lev<",1P,E8.2,"  {1,0")')  bins(:,i), levbounds(i)
            call xprvdu(ncvdu, 1,0)
            cmon(1)=' '//rtype(rselect)//'    |'
            do j=1, nbins
                cmon(1)=trim(cmon(1))//trim(fbins(j))
            end do
            if(Rwlev(nbins+1,i)>1.5*Rwlev(nbins+1,10)) then
                write(fbins(1), '("|  ",a,"={4,0 ",F0.2,"{1,0")') rtype(rselect), Rwlev(nbins+1,i)
            else if(Rwlev(nbins+1,i)>1.2*Rwlev(nbins+1,10)) then
                write(fbins(1), '("|  ",a,"={6,0 ",F0.2,"{1,0")') rtype(rselect), Rwlev(nbins+1,i)
            else
                write(fbins(1), '("|  ",a,"={1,0 ",F0.2,"{1,0")') rtype(rselect), Rwlev(nbins+1,i)
            end if
            cmon(1)=trim(cmon(1))//trim(fbins(1))
            call xprvdu(ncvdu, 1,0)
        end do
        write(cmon,'(" I/s    |   <3   |",3(1X,I2,"-",I2,1X,"|"), 1X,">",I2, "   |")') &
        &   (/ (nint(bounds(i)), nint(bounds(i+1)), i=2, nbins-1) /), nint(bounds(nbins))
        call xprvdu(ncvdu, 1,0)
#else
        write(cmon,'(" I/s    |   <3   |",3(1X,I2,"-",I2,1X,"|"), 1X,">",I2, "   |")') &
        &   (/ (nint(bounds(i)), nint(bounds(i+1)), i=2, nbins-1) /), nint(bounds(nbins))
        call xprvdu(ncvdu, 1,0)
        do i=1, 10                
            write(cmon,'(" n refl |", 5I8,  "|  lev<",1P,E8.2)')  bins(:,i), levbounds(i)
            call xprvdu(ncvdu, 1,0)
            write(buffer, '(a, I0, a)') '(1X, a, a, ',nbins,'F8.2,"|", F8.2)'
            write(cmon,buffer) rtype(rselect), '    |', Rwlev(:,i)
        call xprvdu(ncvdu, 1,0)
        end do
        write(cmon,'(" I/s    |   <3   |",3(1X,I2,"-",I2,1X,"|"), 1X,">",I2, "   |")') &
        &   (/ (nint(bounds(i)), nint(bounds(i+1)), i=2, nbins-1) /), nint(bounds(nbins))
        call xprvdu(ncvdu, 1,0)
#endif
        
        write(cmon,'(a)') ''
        call xprvdu(ncvdu, 1,0)
        
        if (issprt .eq. 0) then
            write(ncwu,'(" I/s    |   <3   |",3(1X,I2,"-",I2,1X,"|"), 1X,">",I2, "   |")') &
            &   (/ (nint(bounds(i)), nint(bounds(i+1)), i=2, nbins-1) /), nint(bounds(nbins))
            do i=1, 10                
                write(ncwu,'(" n refl |", 5I8,  "|  lev<",1P,E8.2)')  bins(:,i), levbounds(i)
                write(buffer, '(a, I0, a)') '(1X, a, a, ',nbins,'F8.2,"|", F8.2)'
                write(ncwu,buffer) rtype(rselect), '    |', Rwlev(:,i)
            end do
            write(ncwu,'(" I/s    |   <3   |",3(1X,I2,"-",I2,1X,"|"), 1X,">",I2, "   |")') &
            &   (/ (nint(bounds(i)), nint(bounds(i+1)), i=2, nbins-1) /), nint(bounds(nbins))
            
            write(ncwu,'(a)') ''
        end if
    end do

end subroutine

!> This function return the text of the restraint as one line only
function cleanrestraint(text)
implicit none
character(len=*), intent(in) :: text
character(len=len(text)) :: temp
character(len=:), allocatable :: cleanrestraint
integer i

temp=text

i=index(temp, 'CONT')
do while(i>0)
    temp=temp(1:i-1)//temp(i+4:)//'    '
    i=index(temp, 'CONT')
end do

i=index(temp, achar(10))
do while(i>0)
    temp=temp(1:i-1)//temp(i+1:)//' '
    i=index(temp, achar(10))
end do

i=index(temp, achar(13))
do while(i>0)
    temp=temp(1:i-1)//temp(i+1:)//' '
    i=index(temp, achar(13))
end do

cleanrestraint=trim(temp)

end function

!> This subroutine write a python file with all the necessary info to do some calculations
subroutine sfls_punch_python()
use store_mod, only: store, istore=>i_store
use xlst01_mod !< unit cell
use xlst02_mod !< symmetry operators
use xlst05_mod !< atomic model
use list12_mod !< matrix of constraints
use xlst12_mod !< matrix of constraints
use xscale_mod, only: nsc, kscal
use xopk_mod, only: kvp
use xapk_mod, only: nkao, nwka, icoord
use xconst_mod, only: nowt
use xunits_mod, only: ierflg
implicit none

integer IADDL,IADDR,IADDD
integer, parameter :: pyfile=578
type(param_t), dimension(:), allocatable :: lsq_list !< List of least squares parameters
type(param_t), dimension(:), allocatable :: phys_list !< List of physical parameters
integer i, j, k, filecount
character eol
character(len=128) :: file_name

type atom_t 
  character(len=4) :: label
  integer serial
end type
type(atom_t), dimension(:), allocatable :: l5model

character(len=6) flag
character(len=24) :: buffer
character(len=6), parameter :: iblank='      '
integer ILEBP, jrr, js, jt, ju, jv, jw, jx, na, nc
!integer, dimension(40) :: icom12
!equivalence(l12, icom12(1))
integer, dimension(6) :: icom12
real weight
real, dimension(:,:), allocatable :: constraintstable
character(len=24), dimension(:), allocatable :: physicallist
integer :: physicalindex, icentr

integer, external :: khuntr

    icom12=(/L12LS, L12ES, L12BS, L12CL, L12PR, L12EX/)
    if(nsc>6) then
      print *, 'programmer error'
      call abort()
    end if

    ! check if list 1 and 5 are loaded
    if (khuntr (1,0, iaddl,iaddr,iaddd,-1) /= 0) then
      CALL XFAL01
      !print *, 'error, list 1 not loaded'
      !call abort()
      if ( ierflg .lt. 0 ) then
        print *, 'error, list 1 cannot be loaded'
        call abort()
      endif
    end if
    if (khuntr (2,0, iaddl,iaddr,iaddd,-1) /= 0) then
      call xfal02
      if ( ierflg .lt. 0 ) then
        print *, 'error, list 2 cannot be loaded'
        call abort()
      endif
    end if
    if (khuntr (5,0, iaddl,iaddr,iaddd,-1) /= 0) then
      print *, 'error, list 5 not loaded'
      call abort()
    end if
    ! cannot check list 12. must assume it is loaded
    !IF (KHUNTR (12,0, IADDL,IADDR,IADDD,-1) /= 0) then
    !  print *, 'Error, list 12 not loaded'
    !  call abort()
    !end if
    
    ! search index for file to open and create
    filecount = sfls_punch_get_newfileindex()

    write(file_name, '(a,i0,a)') 'crysdata', filecount, '.py'
    open(pyfile, file=trim(file_name))

    write(pyfile, '(a)') "#!/usr/bin/env python"
    write(pyfile, '(a)') "import numpy"
    write(pyfile, '(a)') ""
    write(pyfile, '(a)') ""

    write(pyfile, '(a)') "class Atom:"
    write(pyfile, '(4X, a)') '"""Atom definition class"""'
    write(pyfile, '(4X, a)') 'label=""'
    write(pyfile, '(4X, a)') "serial=0"
    write(pyfile, '(4X, a)') "occupancy=0"
    write(pyfile, '(4X, a)') "flag=0"
    write(pyfile, '(4X, a)') "xyz=numpy.zeros(3)"
    write(pyfile, '(4X, a)') "adp=numpy.zeros(6)"
    write(pyfile, '(4X, a)') ""
    write(pyfile, '(4X, a)') "def adp33(self):"
    write(pyfile, '(8X, a)') "a=numpy.array((3,3))"
    write(pyfile, '(8X, a)') "a[0,0]=self.adp[0]"
    write(pyfile, '(8X, a)') "a[1,1]=self.adp[1]"
    write(pyfile, '(8X, a)') "a[2,2]=self.adp[2]"
    write(pyfile, '(8X, a)') "a[1,2]=self.adp[3]"
    write(pyfile, '(8X, a)') "a[0,2]=self.adp[4]"
    write(pyfile, '(8X, a)') "a[0,1]=self.adp[5]"
    write(pyfile, '(8X, a)') "a[2,1]=self.adp[3]"
    write(pyfile, '(8X, a)') "a[2,0]=self.adp[4]"
    write(pyfile, '(8X, a)') "a[1,0]=self.adp[5]"
    write(pyfile, '(8X, a)') "return a"
    write(pyfile, '(a)') ""

    write(pyfile, '(a)') "class TRM:"
    write(pyfile, '(4X, a)') '"""Symmetry operator"""'
    write(pyfile, '(4X, a)') 'R=numpy.zeros((3,3))'
    write(pyfile, '(4X, a)') 'T=numpy.zeros((3))'

    write(pyfile, '(a)') ""
    write(pyfile, '(a)') ""

    write(pyfile, '(a)') "#Unit cell [a,b,c,alpha,beta,gamma]"
    write(pyfile, "('cell=numpy.array([',5(F0.4,','),F0.4,'])')") STORE(L1P1:L1P1+5)
    write(pyfile, '(a)') "#Reciprocal unit cell [a*,b*,c*,alpha*,beta*,gamma*]"
    write(pyfile, "('rcell=numpy.array([',5(F0.4,','),F0.4,'])')") STORE(L1P2:L1P2+5)
    write(pyfile, '(a)') "#Orthogonalisation matrix"
    write(pyfile, "('ortho=numpy.array([',2('[',F0.4,',',F0.4,',',F0.4,'],'),'[',F0.4,',',F0.4,',',F0.4,']])')") STORE(L1O1:L1O1+8)
    write(pyfile, '(a)') "#Metric tensor"
    write(pyfile, "('metric=numpy.array([',2('[',F0.4,',',F0.4,',',F0.4,'],'),'[',F0.4,',',F0.4,',',F0.4,']])')") STORE(L1M1:L1M1+8)

    
    ! Least square parameters list
    write(pyfile, '(a)') ""
    call load_lsq_params(lsq_list)
    write(pyfile, '(a)') "lsq_params={"
    eol=','
    do i=1, size(lsq_list)
      if(i==size(lsq_list)) then
        eol=''
      end if
      if(mod(i,10)==0) then
        write(pyfile, *) ''
      end if
      if(lsq_list(i)%index>-1) then
        ! python indices are zero based, hence index-1 below
        if(lsq_list(i)%serial>0) then
          write(pyfile, '(4x, """", a,"(",I0,")", 1X, a,""":",I0, a)', advance="no") trim(lsq_list(i)%label), &
          &   lsq_list(i)%serial, trim(lsq_list(i)%name), lsq_list(i)%index-1, eol
        else
          write(pyfile, '(4x, """", a,""":",I0, a)') &
          &   trim(lsq_list(i)%name), lsq_list(i)%index-1, eol
        end if
      end if
    end do
    write(pyfile, '(a)') "}"


    ! List 5 model
    write(pyfile, '(a)') ""
    write(pyfile, '(a)' ) '# Overall parameters'
    write(pyfile, '(a ,F11.6)' ) 'scale=', STORE(L5O)
    write(pyfile, '(a ,F11.6)' ) 'ou_iso=', STORE(L5O+1)
    write(pyfile, '(a ,F11.6)' ) 'du_iso=', STORE(L5O+2)
    write(pyfile, '(a ,F11.6)' ) 'polarity=', STORE(L5O+3)
    write(pyfile, '(a ,F11.6)' ) 'enantio=', STORE(L5O+4)
    write(pyfile, '(a ,F11.6)' ) 'extinction=', STORE(L5O+5)
    
    write(pyfile, '(a)') ""
    allocate(l5model(N5))
    write(pyfile, '(a,I0,a)') "model = [ Atom() for i in range(",n5,")]"
    
    m5=l5
    do i=1, n5
      WRITE(pyfile,'(a,a,"(",I0,")",a)') '# Atom ', trim(transfer(STORE(M5), 'aaaa')), nint(STORE(M5+1))
      write(pyfile, '(a,I0,a,a,a)') "model[",i-1,'].label="',trim(transfer(STORE(M5), 'aaaa')),'"'
      write(pyfile, '(a,I0,a,I0)') "model[",i-1,'].serial=',nint(STORE(M5+1))
      write(pyfile, '(a,I0,a,F0.6)') "model[",i-1,'].occupancy=',STORE(M5+2)
      write(pyfile, '(a,I0,a,I0)') "model[",i-1,'].flag=',nint(STORE(M5+3))
      write(pyfile, '(a,I0,a,2(F0.6,","),F0.6,a)') "model[",i-1,'].xyz=numpy.array([',STORE(M5+4:M5+6),'])'
      write(pyfile, '(a,I0,a,5(F0.6,","),F0.6,a)') "model[",i-1,'].adp=numpy.array([',STORE(M5+7:M5+12),'])'
      M5 = M5 + MD5
    end do
    
    ! matrix of constraints
    call load_phys_params(phys_list)
    allocate(constraintstable(size(phys_list), size(lsq_list)))
    allocate(character(len=24) :: physicallist(size(phys_list)))
    physicallist=''
    physicalindex=0
    !      jt            absolute l.s. parameter no.
    !      js            physical parameter no from which to start search
    !      jx            relative parameter no

    jx = 12
    m5 = l5 - md5
    m12 = l12o
    l12a = nowt
    js = 0

    flag = iblank

    do while(m12 .ge. 0)   ! more stuff in l12
      if(istore(m12+1).gt.0) then ! any refined params
!c--compute the address of the first part for this group
        l12a=istore(m12+1)
!c--check if this part contains any refinable parameters
        do while(l12a.gt.0) ! --check if there are any more parts for this atom or group
          if(istore(l12a+3).lt.0) exit
!c--set up the constants to pass through this part
          md12a=istore(l12a+1)
          ju=istore(l12a+2) 
          jv=istore(l12a+3)
          js=istore(l12a+4)+1
!c--search this part of this atom
          do jw=ju,jv,md12a
            jt=istore(jw)

            ilebp = 0
            do na=1,nsc
              if(icom12(na).eq.m12) then
!c--layer or element batch or parameter print
                 ilebp = 1
                 exit
              end if
            end do

            if ( md12a .gt. 1 ) then
              weight = store(jw+1)
            else
              weight = 1.
            endif

            if ( ilebp .eq. 1 ) then
              if(jt>0) then
                physicalindex=physicalindex+1
                if(physicalindex>ubound(physicallist, 1)) then
                  !print *, 'index out of bound 1'
                  call abort()
                end if
                write(buffer, '(2a4)') (kscal(nc,na+2),nc=1,2)
                write(physicallist(physicalindex), '(a,1x,i0)') trim(buffer), js
                constraintstable(physicalindex, JT)=weight
              end if

!c--check if this is an overall parameter
            else if (m12.eq.l12o) then
              if(jt>0) then
                physicalindex=physicalindex+1
                if(physicalindex>ubound(physicallist, 1)) then
                  !print *, 'index out of bound 2'
                  call abort()
                end if
                write(physicallist(physicalindex), '(3a4)') (kvp(jrr,js),jrr=1,2)
                constraintstable(physicalindex, JT)=weight
              end if
            else  
!c-c-c-distinction between aniso's and iso/special's for print

              if((store(m5+3) .ge. 1.0) .and. (js .ge. 8)) then
                if(jt>0) then
                  physicalindex=physicalindex+1
                  if(physicalindex>ubound(physicallist, 1)) then
                    !print *, 'index out of bound 3'
                    call abort()
                  end if
                  write(buffer, '(a4)') store(m5)
                  write(physicallist(physicalindex), '(a,"(",I0,")",1X,3a4)') &
                  &   trim(buffer),nint(store(m5+1)),(icoord(jrr,js+nkao),jrr=1,nwka)
                  constraintstable(physicalindex, JT)=weight
                end if
              else
                if(jt>0) then
                  physicalindex=physicalindex+1
                  if(physicalindex>ubound(physicallist, 1)) then
                    !print *, 'index out of bound 4 ', physicalindex, ubound(physicallist, 1)
                    call abort()
                  end if
                  write(buffer, '(a4)') store(m5)
                  write(physicallist(physicalindex), '(a4,"(",I0,")",1X,3a4)') &
                  &   trim(buffer),nint(store(m5+1)), (icoord(jrr,js),jrr=1,nwka)
                  constraintstable(physicalindex, JT)=weight
                end if
              endif
                            
            endif              
!c
!c--increment to the next parameter of this part
            js=js+1
          end do
!c--change parts for this atom or group
          l12a=istore(l12a)
        end do
      end if
!c--move to the next group or atom
      m5=m5+md5
      m12=istore(m12)
    end do
      
    write(pyfile,'(a)') ''
    write(pyfile,'(a)') '# Matrix of constraints'
    write(pyfile,'(a,I0,",",I0,a)') 'mconstraints=numpy.zeros( (', physicalindex, size(lsq_list),') )'
    do j=1, size(lsq_list)
      do i=1, physicalindex
        if(constraintstable(i, j)/=0.0) then
          write(pyfile, '(a,I0,",",I0,a,F5.2)') 'mconstraints[', i-1, j-1, ']=', constraintstable(i, j)
        end if
      end do
    end do
      

    ! physical parameters list
    write(pyfile, '(a)') ""
    write(pyfile, '(a)') "parameters={"
    eol=','
    do i=1, physicalindex
      if(i==physicalindex) then
        eol=''
      end if
      if(mod(i,10)==0) then
        write(pyfile, *) ''
      end if
      write(pyfile, '(4x, """", a,""":",I0, a)', advance="no") trim(adjustl(physicallist(i))), i, eol
    end do
    write(pyfile, '(a)') "}"
    
    ! space group symbol
    write(pyfile, '(a)') ""
    j=l2sg+md2sg-1
    write (buffer,'(4(A4,1X))') (istore(i),i=l2sg,j)   
    write(pyfile, '(a, a)') '# Space group: ', trim(buffer)
    icentr=nint(store(l2c))
    write(pyfile, '(a)') '# 1 means centrosymmetric, zero otherwise'
    write(pyfile, '(a,I0)') "centering = ", icentr
    
    ! symmetry operators
    write(pyfile, '(a,I0,a)') "TRMlist = [ TRM() for i in range(",n2p*n2,")]"
    m2p = l2p+((n2p-1)*md2p)
    m2 = l2+((n2-1)*md2)

    k=-1
    do i=l2,m2,md2
     do j=l2p,m2p,md2p
       k=k+1
       write(pyfile, '(a,I0,a)') 'TRMlist[',k,'].R = numpy.array(['
       write(pyfile, '(4X, a,2(F4.1,","),F4.1,a)') '[', STORE(I:I+2), '],'
       write(pyfile, '(4X, a,2(F4.1,","),F4.1,a)') '[', STORE(I+3:I+5), '],'
       write(pyfile, '(4X, a,2(F4.1,","),F4.1,a)') '[', STORE(I+6:I+8), ']])'
       write(pyfile, '(a,I0,a)') 'TRMlist[',k,'].T = numpy.array('
       write(pyfile, '(4X, a,2(F4.1,"/12.0,"),F4.1,"/12.0", a)') '[', STORE(j:j+2)*12.0, '])'
     end do
    end do    
    write(pyfile, '(a)') ""

    close(pyfile)

end subroutine

!> Initialise a plot of the leverages
subroutine plot_leverages_init(gunit, plotid, xaxis)
implicit none
integer, intent(in) :: gunit !< graph id
character(len=*), intent(in) :: plotid !< id of the plot in SCRIPT
character(len=*), intent(in) :: xaxis !< xaxis name in the plot
integer :: funit

funit=funitconstant+gunit

open(funit, status="scratch")

WRITE(funit,'(A,6(/,A))') &
&   '^^PL PLOTDATA '//trim(plotid)//' SCATTER ATTACH '//trim(plotid)//' KEY', &
&   '^^PL XAXIS TITLE '''//trim(xaxis)//''' NSERIES=2 LENGTH=2000', &
&   '^^PL YAXIS TITLE ''Leverage, P\_i\_i'' ZOOM -1.0 1.0', &
&   '^^PL YAXISRIGHT TITLE ''-100*T2/max(T2)''', &
&   '^^PL SERIES 1 TYPE SCATTER SERIESNAME ''Leverage''', &
&   '^^PL SERIES 2 TYPE SCATTER', &
&   '^^PL SERIESNAME ''Influence of remeasuring (normalised)'' USERIGHTAXIS'

end subroutine

!> Add data to the leverages plot
subroutine plot_leverages_push(gunit, hkl, x, Pii, red)
implicit none
integer, intent(in) :: gunit !< graph id
integer, dimension(3), intent(in) :: hkl !< hkl indices
double precision, intent(in) :: x !< Fobs
double precision, intent(in) :: Pii !< leverage
double precision, intent(in) :: red !< T2 (t**2)/(1.0+PII)
character(len=64) :: hkllab !< hkl indices formatted string
integer :: funit

funit=funitconstant+gunit

write(hkllab, '(2(i0,","),i0)') hkl
write(funit,'(3a,4f11.4)') &
&   '^^PL LABEL ''',trim(hkllab),''' DATA ',x,pii,x, red

end subroutine

!> Close the ploting of the leverages in crystals gui
subroutine plot_leverages_close(gunit)
use xiobuf_mod, only: cmon !< screen
use xunits_mod, only: ncvdu !< lis file
implicit none
integer, intent(in) :: gunit !< graph id
integer :: funit, iostatus
character(len=512) :: buffer

funit=funitconstant+gunit

write(funit,'(a,f18.14,a/a)')'^^PL YAXISRIGHT ZOOM -100.0 ',&
&   100.0,' SHOW', &
&   '^^CR'
write(funit,'(a,/a)')'^^PL YAXIS ZOOM -1.0 1.0 SHOW',&
&   '^^CR'

rewind(funit)
do
  read(funit, '(a)', iostat=iostatus) buffer
  if(iostatus/=0) exit
  write(cmon, '(a)') trim(buffer)
  call XPRVDU (NCVDU,1,0)
end do
close(funit)

end subroutine

end module


