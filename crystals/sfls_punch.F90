!> The module sfls_punch_mod deals with the export of different matrices during refinement
!!
!! \detaileddescription
!!
!! 2 Outputs are available: Matlab(1) and plain text(2)
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
!! The file naming is kept consistent. The same index is used for files written is the same cycle. See sfls_punch_get_newfileindex().
!!
module sfls_punch_mod
implicit none
integer, private :: normal_unit=0 !< unit number for the file
integer, private :: design_unit=0 !< unit number for the file
integer, private :: wdf_unit=0 !< unit number for the file
integer, private, save :: fileindex=-1 !< index used in the different filenames
!> List of filename used. This list is used to find a new index for the filenames.
character(len=24), dimension(4), parameter, private :: filelist=(/ &
&  'normal  ', &
&  'design  ', &
&  'wdf     ', &
&  'variance' /)
!> list of extension used. This list is used to find a new index for the filenames.
character(len=4), dimension(2), parameter, private :: extlist=(/ '.m  ', '.dat' /)

private sfls_punch_get_newfileindex
  
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
        filecount = sfls_punch_get_newfileindex()
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
    filecount = sfls_punch_get_newfileindex()

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
        call print_design_header()
        
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
        filecount = sfls_punch_get_newfileindex()
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
        filecount = sfls_punch_get_newfileindex()
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
        
        write(lineformat, '("(3I5, 3X, ",I0,"E25.16)")') ubound(designmatrix, 1)
        do i=1, ubound(designmatrix, 2)
            write(design_unit, lineformat) hkllist(:,i), designmatrix(:,i)
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
        filecount = sfls_punch_get_newfileindex()
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
        filecount = sfls_punch_get_newfileindex()
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
    if(normal_unit/=0) then
        print *, 'normal file still open'
        call abort()
    end if
    if(design_unit/=0) then
        print *, 'design file still open'
        call abort()
    end if
    if(wdf_unit/=0) then
        print *, 'wdf file still open'
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
use xiobuf_mod, only: cmon
implicit none

integer, parameter :: nameln = 18 
integer, parameter :: lover = 10 , nover = 6 
integer, parameter :: latomp = 8 , natomp = 13 
character(len=132) :: cline1 , cline2

integer i, j, k, l, icombf, iend, ipos, istat
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

integer, parameter :: iversn=210, icomsz=512

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
        print *, "error more than 1 bloc"
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



end module


