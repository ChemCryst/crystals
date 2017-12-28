!> The module sfls_punch_mod deals with the export of different matrices and claculations during refinement
!!
!! \detaileddescription
!!
!! 2 options under \sfls, \refine can be used: PUNCH and CALCULATE
!! Punch Outputs available: Matlab(1), plain text(2) and numpy(3) 
!! calculate options: leverages(1)
!! 
!!
!! (1) **Matlab output (PUNCH=MATLAB)**
!!
!! - design*.m stores the design matrix. The h,k,l index is written as a comment before the row of the design matrix.
!!   The design matrix is weighted with the square root of the weights so that when forming the normal matrix the result is weighted.
!! - normal*.m stores the normal matrix and the variance/covariance matrix as a n*n matrix
!! - wdf*.m stores the weights
!!
!! (2) **Plain ascii output (PUNCH=TEXT)**
!!
!! - design*.dat stores the design matrix. Each row starts with the h,k,l index followed by the derivatives
!!   The design matrix is weighted with the square root of the weights so that when forming the normal matrix the result is weighted.
!! - normal*.dat stores the normal matrix as a n*n matrix
!! - variance*.dat stores the variance/covariance matrix as a n*n matrix
!! - wdf*.dat stores the weights
!!
!! (3) **Numpy output (PUNCH=NUMPY)**
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
!! (1) ** leverages (CALCULATE=LEVERAGES)**
!!
!! - Calculate leverages and t values to a file. Format is set using PUNCH.
!!
!! The file naming is kept consistent. The same index is used for files written is the same cycle. See sfls_punch_get_newfileindex().
!!
module sfls_punch_mod
implicit none
integer, private :: normal_unit=0 !< unit number for the file
integer, private :: design_unit=0 !< unit number for the file
integer, private :: wdf_unit=0 !< unit number for the file
integer, private, save :: fileindex=-1 !< index used in the different filenames
!> List of filename used. This list is used to find a new index for the filenames.
character(len=25), dimension(5), parameter, private :: filelist=(/ &
&  'normal   ', &
&  'design   ', &
&  'wdf      ', &
&  'variance ', &
&  'leverages' /)
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

!> Initialisation of design[0-9].m file
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
subroutine sfls_punch_leverages(nsize)
use list26_mod, only: subrestraints_parent, restraints_list
use xiobuf_mod, only: cmon !< screen
use xunits_mod, only: ncvdu !< lis file
use numpy_mod, only: numpy_read_header, numpy_write_header
!$ use OMP_LIB
implicit none
integer, intent(in) :: nsize !< number of parameters during least squares
integer, parameter :: block_size=512
integer filecount, variance_unit, leverage_unit
character(len=255) :: file_name, formatstr
double precision, dimension(:,:), allocatable :: variance, design_block, temp_block, tij_block, T2ij_block
double precision, dimension(:), allocatable :: maxtij, maxT2ij
double precision, dimension(:), allocatable :: leverage_all, temp1d
double precision, dimension(3) :: hkl_dp
real, dimension(:,:), allocatable :: temp2d
integer info, irestraint, i, j, numobs, islider, datheader
double precision normalize, check
integer, dimension(:,:), allocatable :: hkl
logical file_exists
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

    write(cmon,'(A,A)') '{I Starting leverages calculations...'
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
            allocate(temp2d(nsize, nsize))
            read(variance_unit) temp2d
            allocate(variance(nsize, nsize))
            variance=temp2d
            deallocate(temp2d)
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
        if(vorder=='C') then
            variance=transpose(variance)
        end if
    else
        open(variance_unit, file=file_name, status='old')
        allocate(variance(nsize, nsize))
        read(variance_unit, *) variance
        close(variance_unit)
    end if

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
    allocate(maxtij(nsize))
    allocate(maxT2ij(nsize))
    allocate(design_block(nsize, block_size))
    allocate(temp_block(nsize, block_size))
    allocate(tij_block(block_size, nsize))
    allocate(T2ij_block(block_size, nsize))
    allocate(leverage_all(0))
    maxtij=0.0d0
    maxT2ij=0.0d0

    ! first pre-calculate some constants
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
            hkl(:,mod(numobs-1,block_size)+1)=nint(hkl_dp)
        else
            read(design_unit, *, iostat=info, iomsg=msgstatus) hkl(:,mod(numobs-1,block_size)+1), &
            &   design_block(:,mod(numobs-1,block_size)+1)
        end if
        if(info/=0) exit
        
        if(mod(numobs-1,block_size)+1==block_size) then ! processing the block of design matrix
    
            ! Calculation of leverage see https://doi.org/10.1107/S0021889812015191
            ! Hat matrix: A (A^t W A)^-1 A^t W, leverage is diagonal element
            ! A is design matrix, W weight as a diagonal matrix
            ! (A^t W A)^-1 is the inverse of normal matrix
            ! calculation can be done one row of A at at time
            
            ! bit for leverages
            !temp_block=matmul(variance, design_block)
            call dsymm('L', 'U', nsize, block_size, 1.0d0, variance, nsize, design_block, nsize, 0.0d0, temp_block, nsize)
            !call dgemm('N', 'N', nsize, block_size, nsize, 1.0d0, variance, nsize, design_block, nsize, 0.0d0, temp_block, nsize)

            ! bit for tij
            !tij_block=matmul(transpose(design_block), variance)
            call dgemm('T', 'N', block_size, nsize, nsize, 1.0d0, design_block, nsize, &
            &   variance, nsize, 0.0d0, tij_block, block_size)
                        
            call move_alloc(leverage_all, temp1d)
            allocate(leverage_all(size(temp1d)+block_size))
            leverage_all(1:size(temp1d))=temp1d
            deallocate(temp1d)
            
            do i=1, block_size
                leverage_all(size(leverage_all)-block_size+i)=dot_product(design_block(:,i), temp_block(:,i))
                !leverage_all(size(leverage_all)-block_size+i) = ddot(nsize, design_block(:,i), 1, temp_block(:,i), 1)

                T2ij_block(i,:)=tij_block(i,:)**2/(1.0d0+leverage_all(size(leverage_all)-block_size+i))
            end do
            
            do i=1, nsize
                maxtij(i)=max(maxtij(i), maxval(abs(tij_block(:,i))))
                maxT2ij(i)=max(maxT2ij(i), maxval(abs(T2ij_block(:,i))))
            end do

            ! updating slider in the gui
            islider=islider+(50-islider)/4
            call slider(islider,100)
            
        end if
        
    end do
    
    ! Processing the remaining incomplete block
    if(mod(numobs-1,block_size)+1/=block_size) then ! processing the reamining block
        design_block(:,mod(numobs-1,block_size)+1:)=0.0d0 ! zeroing unusued part of the block
    
        call dsymm('L', 'U', nsize, block_size, 1.0d0, variance, nsize, design_block, nsize, 0.0d0, temp_block, nsize)

        call dgemm('T', 'N', block_size, nsize, nsize, 1.0d0, design_block, nsize, &
        &   variance, nsize, 0.0d0, tij_block, block_size)

        call move_alloc(leverage_all, temp1d)
        allocate(leverage_all(size(temp1d)+mod(numobs-1,block_size)))
        leverage_all(1:size(temp1d))=temp1d
        deallocate(temp1d)
        
        do i=1, mod(numobs-1,block_size)
            leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i)=dot_product(design_block(:,i), temp_block(:,i))

            T2ij_block(i,:)=tij_block(i,:)**2/(1.0d0+leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i))
        end do
        
        do i=1, nsize
            maxtij(i)=max(maxtij(i), maxval(abs(tij_block(:,i))))
            maxT2ij(i)=max(maxT2ij(i), maxval(abs(T2ij_block(:,i))))
        end do    
    end if
    numobs=numobs-1
    
    ! updating slider in the gui
    islider=50
    call slider(islider,100)
    
    normalize=real(numobs, kind(1.0d0))/real(nsize, kind(1.0d0))
    
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
    ! Calculating the various values again and printing
    ! using the leverages from previous run
    !##################################################################
    write(formatstr, '(A,I0,A)') '(A, ", ", 3(I0,", "), 2(F7.4, ", "), ',2*nsize,'(1PE10.3, :, ", "))'
    if(file_type/=0) then
        write(leverage_unit, '(8(''"'',A,''"'',:,","))') 'Restraint','h','k','l', &
        &   'Leverage', 'Normalised leverage', 'Normalised t_ij', 'Normalised T2_ij'
    end if
    ! data don't fit in memory and processing line by line is too slow
    ! Using a blocking algorithm where a block of the design matrix is read and processed
    info=0
    irestraint=0
    numobs=0
    check=0.0d0
    do while(info==0)
        numobs=numobs+1
        if(file_type==0) then
            read(design_unit, iostat=info) hkl_dp, &
            &   design_block(:,mod(numobs-1,block_size)+1)
            hkl(:,mod(numobs-1,block_size)+1)=nint(hkl_dp)
        else
            read(design_unit, *, iostat=info) hkl(:,mod(numobs-1,block_size)+1), &
            &   design_block(:,mod(numobs-1,block_size)+1)
        end if
        if(info/=0) exit
        
        if(mod(numobs-1,block_size)+1==block_size) then ! processing the block of design matrix
    
            ! Calculation of leverage see https://doi.org/10.1107/S0021889812015191
            ! Hat matrix: A (A^t W A)^-1 A^t W, leverage is diagonal element
            ! A is design matrix, W weight as a diagonal matrix
            ! (A^t W A)^-1 is the inverse of normal matrix
            ! calculation can be done one row of A at at time
            
            !tij_block=matmul(transpose(design_block), variance)
            call dgemm('T', 'N', block_size, nsize, nsize, 1.0d0, design_block, nsize, &
            &   variance, nsize, 0.0d0, tij_block, block_size)
            
            do i=1, block_size
                T2ij_block(i,:)=tij_block(i,:)**2/(1.0d0+leverage_all(size(leverage_all)-block_size+i))
                
                if(all(hkl(:,i)==0)) then
                    irestraint=irestraint+1
                end if
                
                if(file_type==0) then
                    write(leverage_unit) &
                    &   real(hkl(:,i), kind(1.0d0)), leverage_all(size(leverage_all)-block_size+i), &
                    &   leverage_all(size(leverage_all)-block_size+i)*normalize, &
                    &   ( tij_block(i,j)/maxtij(j)*100.0d0, T2ij_block(i,j)/maxT2ij(j)*100.0d0, j=1, nsize )                
                else
                    if(irestraint==0) then
                        write(leverage_unit, formatstr) &
                        &   '""', hkl(:,i), leverage_all(size(leverage_all)-block_size+i), &
                        &   leverage_all(size(leverage_all)-block_size+i)*normalize, &
                        &   ( tij_block(i,j)/maxtij(j)*100.0d0, T2ij_block(i,j)/maxT2ij(j)*100.0d0, j=1, nsize )
                    else
                        write(leverage_unit, formatstr) &
                        &   '"'//cleanrestraint(trim(restraints_list(subrestraints_parent(irestraint))%restraint_text))//'"', &
                        &   hkl(:,i), leverage_all(size(leverage_all)-block_size+i), &
                        &   leverage_all(size(leverage_all)-block_size+i)*normalize, &
                        &   ( tij_block(i,j)/maxtij(j)*100.0d0, T2ij_block(i,j)/maxT2ij(j)*100.0d0, j=1, nsize )
                    end if
                end if
            end do

            ! updating slider in the gui
            islider=islider+(100-islider)/4
            call slider(islider,100)

        end if
        
    end do
    
    ! Processing the remaining incomplete block
    if(mod(numobs-1,block_size)+1/=block_size) then ! processing the reamining block
        design_block(:,mod(numobs-1,block_size)+1:)=0.0d0 ! zeroing unusued part of the block
    
        call dgemm('T', 'N', block_size, nsize, nsize, 1.0d0, design_block, nsize, &
        &   variance, nsize, 0.0d0, tij_block, block_size)
        
        do i=1, mod(numobs-1,block_size)
            T2ij_block(i,:)=tij_block(i,:)**2/(1.0d0+leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i))

            if(all(hkl(:,i)==0)) then
                irestraint=irestraint+1
            end if
            
            if(file_type==0) then
                write(leverage_unit) &
                &   real(hkl(:,i), kind(1.0d0)), leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i), &
                &   leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i)*normalize, &
                &   ( tij_block(i,j)/maxtij(j)*100.0d0, T2ij_block(i,j)/maxT2ij(j)*100.0d0, j=1, nsize )
            else
                if(irestraint==0) then
                    write(leverage_unit, formatstr) &
                    &   '""', hkl(:,i), leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i), &
                    &   leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i)*normalize, &
                    &   ( tij_block(i,j)/maxtij(j)*100.0d0, T2ij_block(i,j)/maxT2ij(j)*100.0d0, j=1, nsize )
                else
                    write(leverage_unit, formatstr) &
                    &   '"'//cleanrestraint(trim(restraints_list(subrestraints_parent(irestraint))%restraint_text))//'"', &
                    &   hkl(:,i), leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i), &
                    &   leverage_all(size(leverage_all)-mod(numobs-1,block_size)+i)*normalize, &
                    &   ( tij_block(i,j)/maxtij(j)*100.0d0, T2ij_block(i,j)/maxT2ij(j)*100.0d0, j=1, nsize )
                end if
            end if
        end do
    end if    
    numobs=numobs-1

    if(file_type==0) then
        call numpy_write_header(leverage_unit, (/numobs, 5+2*nsize/), 128, 'C', '<f8')
    end if
    
    close(leverage_unit)
    design_unit=0
    
    write(cmon,'(A,A)') '{I Leverages written in file: ', trim(file_name)
    call xprvdu(ncvdu, 1,0)      
    call slider(100,100)

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
use store_mod
use xlst01_mod
use xlst05_mod
use list12_mod
use xlst12_mod
use xscale_mod
use xopk_mod
use xapk_mod
use xconst_mod
use numpy_mod
implicit none

integer IADDL,IADDR,IADDD
integer, parameter :: pyfile=578
type(param_t), dimension(:), allocatable :: parameters_list !< List of least squares parameters
integer i
character eol

type(atom_t) 
  character(len=4) :: label
  integer serial
end type
type(atom_t), dimension(:), allocatable :: l5model

integer, external :: khuntr

    ! Check if list 1 and 5 are loaded
    IF (KHUNTR (1,0, IADDL,IADDR,IADDD,-1) /= 0) then
      print *, 'Error, list 1 not loaded'
      call abort()
    end if
    IF (KHUNTR (5,0, IADDL,IADDR,IADDD,-1) /= 0) then
      print *, 'Error, list 5 not loaded'
      call abort()
    end if
    ! cannot check list 12. Must assume it is loaded
    !IF (KHUNTR (12,0, IADDL,IADDR,IADDD,-1) /= 0) then
    !  print *, 'Error, list 12 not loaded'
    !  call abort()
    !end if

    print *, "unit cell ", STORE(L1P1:L1P1+5)
    print *, "reciprocal unit cell ", STORE(L1P2:L1P2+5)
    print *, "orthogonalisation matrix ", STORE(L1O1:L1O1+8)
    print *, "metric tensor ", STORE(L1M1:L1M1+8)
    
    open(pyfile, file="crystals.py")

    write(pyfile, '(a)') "#!/usr/bin/env python"
    write(pyfile, '(a)') "import numpy"
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

    
    call load_lsq_params(parameters_list)
    write(pyfile, '(a)') "lsq_params={"
    eol=','
    do i=1, size(parameters_list)
        if(i==size(parameters_list)) then
            eol=''
        end if
        if(mod(i,10)==0) then
            write(pyfile, *) ''
        end if
        if(parameters_list(i)%index>-1) then
            ! python indices are zero based, hence index-1 below
            if(parameters_list(i)%serial>0) then
                write(pyfile, '(4x, """", a,"(",I0,")", 1X, a,""":",I0, a)', advance="no") trim(parameters_list(i)%label), &
                &   parameters_list(i)%serial, trim(parameters_list(i)%name), parameters_list(i)%index-1, eol
            else
                write(pyfile, '(4x, """", a,""":",I0, a)') &
                &   trim(parameters_list(i)%name), parameters_list(i)%index-1, eol
            end if
        end if
    end do
    write(pyfile, '(a)') "}"


    allocate(l5model(N5))
    write(pyfile, '(a)' ) '# Overall parameters'
    write(pyfile, '(a ,F11.6,4(1X,F9.6),1X,F17.7)' ) '# ', STORE(L5O:L5O+5)
    
    m5=l5
!    do i=1, n5

! WRITE(NCPU,1000)N5,MD5LS,MD5ES,MD5BS
!1000  FORMAT(13HREAD NATOM = ,I6,11H, NLAYER = ,I4,13H, NELEMENT = ,I4,
!     2 11H, NBATCH = ,I4)
!C--OUTPUT THE OVERALL PARAMETERS
!       WRITE(NCPU,1050) STORE(L5O),STORE(L5O+1),STORE(L5O+2),
!     1 STORE(L5O+3),STORE(L5O+4),STORE(L5O+5)
!1050  FORMAT(8HOVERALL ,F11.6,4(1X,F9.6),1X,F17.7)
!      ENDIF
!C--CHECK FOR SOME ATOMS
!      IF(N5)1200,1200,1100
!C--OUTPUT THE ATOMS
!1100  CONTINUE
!      M5 = L5
!      DO 1170 K = 1, N5
!C----- DONT PUNCH 'SPARE' FOR THE MOMENT - IT CAUSES PROBLEMS
!C      WITH ALIEN PROGRAMS
!CDJWNOV2000 REINTRODUCE PUNCHING OF ALL DATA
!C      MD5TMP = MIN (13, MD5)
!      MD5TMP = MIN(18, MD5) 
!      J = M5 + 13
!C Offset18 used to contain a 4 character string '    ' by default.
!C Catch that value here and change it to zero.
!      IF ( ISTORE(M5+17) .EQ. 538976288 ) ISTORE(M5+17) = 0
!C ISTORE bits will only print if J=18, not if J=14.
!      WRITE(NCPU,1150) (STORE(I), I = M5, J),
!     1                (ISTORE(I), I= J+1, M5+MD5TMP -1 )
!1150  FORMAT
!     1 ('ATOM ',A4,1X,F11.0,F11.6,F11.0,3F11.6/
!     2 'CON U[11]=',6F11.6/
!     3 'CON SPARE=',F11.2,3I11,10X,I12)
!      M5 = M5 + MD5
!1170  CONTINUE
!C--CHECK IF THERE ARE ANY LAYER SCALES TO OUTPUT
!      IF (IN .LE. 0) GOTO 1700
!1200  CONTINUE
!      IF(MD5LS)1350,1350,1250
!C--PUNCH THE LAYER SCALES
!1250  CONTINUE
!      M5LS=L5LS+MD5LS-1
!      WRITE(NCPU,1300)(STORE(I),I=L5LS,M5LS)
!1300  FORMAT(10HLAYERS    ,6F11.6/(10HCONTINUE  ,6F11.6))
!C--CHECK IF THERE ARE ANY ELEMENT SCALES TO OUTPUT
!1350  CONTINUE
!      IF(MD5ES)1500,1500,1400
!C--OUTPUT THE ELEMENT SCALES
!1400  CONTINUE
!      M5ES=L5ES+MD5ES-1
!      WRITE(NCPU,1450)(STORE(I),I=L5ES,M5ES)
!1450  FORMAT(10HELEMENTS  ,6F11.6/(10HCONTINUE  ,6F11.6))
!C--CHECK IF THERE ARE ANY BATCH SCALS TO BE OUTPUT
!1500  CONTINUE
!      IF(MD5BS)1650,1650,1550
!C--OUTPUT THE BATCH SCALE FACTORS
!1550  CONTINUE
!      M5BS=L5BS+MD5BS-1
!      WRITE(NCPU,1600)(STORE(I),I=L5BS,M5BS)
!1600  FORMAT(10HBATCH     ,6F11.6/(10HCONTINUE  ,6F11.6))
!C--AND NOW THE 'END'
!1650  CONTINUE
!      CALL XPCHND(ncpu)
!1700  CONTINUE
!      RETURN
!C
!9900  CONTINUE
!C -- ERRORS
!      CALL XOPMSG ( IOPPCH , IOPLSP , 5 )
!      RETURN




    close(pyfile)

end subroutine

end module


