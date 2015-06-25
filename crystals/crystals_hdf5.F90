#ifdef _NOHDF5_

! dummy hdf5 function to avoid linking to hdf5 when hdf5 is not used
module hdf5_dsc

logical, private, parameter :: debug_hdf5 = .false.
INTEGER, PARAMETER :: HID_T = 4

type, public :: t_dsc_hdf5
    integer(hid_t) :: file_id       ! file identifier
    character(len=1024) :: file_name
    integer :: idunit
    character(len=3) :: dsc_dsetname = "dsc"     ! dataset name
    integer :: dsc_blocksize = 2048 ! size of the chunks for dsc
    integer(hid_t) :: dsc_dset_id       ! dataset identifier
    integer(hid_t) :: dsc_dspace_id     ! dataspace identifier
    integer(hid_t) :: dsc_dtype         ! opaque datatype
    character(len=10) :: dsc_dtype_tag = "dsc record"
    !integer(hid_t) :: crp_list      ! dataset creation property identifier 
    !integer(hid_t) :: filespace     ! dataspace identifier 
    !integer(hid_t) :: slicespace_id ! memory dataspace identifier
end type

type(t_dsc_hdf5), dimension(:), allocatable, target, private :: hdf5_dic
logical :: hdf5_in_use = .false.

contains

subroutine hdf5_dsc_open(crfile, filename, error)
    implicit none
    type(t_dsc_hdf5), pointer :: crfile
    integer, intent(out) :: error
    character(len=*), intent(in) :: filename
    
    error = -1
end subroutine

subroutine hdf5_dsc_kfetch(crfile, fetch_address, dataread, error)
    use xdaval_mod
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(in) :: fetch_address
    integer, dimension(:), intent(out) :: dataread
    integer, intent(out) :: error
    
   error=-1
end subroutine

subroutine hdf5_dsc_kstore(crfile, store_address, datastore, error)
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(in) :: store_address
    integer, dimension(:), intent(in) :: datastore
    integer, intent(out) :: error
    
    error = -1
end subroutine

subroutine hdf5_dsc_get_dspace(crfile) 
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile

end subroutine


subroutine hdf5_dsc_get_dset(crfile) 
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
end subroutine

subroutine hdf5_dsc_get_dtype(crfile)
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
end subroutine

subroutine hdf5_dic_del(idunit, error)
    implicit none
    integer, intent(in) :: idunit
    integer, intent(out) :: error

    error =-1
end subroutine

subroutine hdf5_dic_add(crfile, error)
    implicit none
    type(t_dsc_hdf5), pointer :: crfile
    type(t_dsc_hdf5), dimension(size(hdf5_dic)) :: temp
    integer, intent(out) :: error
    integer i

    error=-1
end subroutine


subroutine hdf5_dic_get(crfile, idunit, error)
    implicit none
    type(t_dsc_hdf5), pointer :: crfile
    integer, intent(in) :: idunit
    integer, intent(out) :: error
    
    error=-1
end subroutine
    

subroutine xdaend_hdf5 (crfile, last )
    use xunits_mod !include 'XUNITS.INC'
    use xssval_mod !include 'XSSVAL.INC'
    use xerval_mod !include 'XERVAL.INC'
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile      
    integer, intent(out) :: last
end subroutine

subroutine hdf5_dsc_extend(crfile, error, extendsizearg)
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(out) :: error
    integer, intent(in), optional :: extendsizearg
    
    error = -1
end subroutine

!code for xdaxtn
subroutine xdaxtn_hdf5 (crfile, ibegin,icount )
    use xunits_mod !include 'XUNITS.INC'
    use xssval_mod !include 'XSSVAL.INC'
    use xerval_mod !include 'XERVAL.INC'
    use xdaval_mod !include 'XDAVAL.INC'
    use xiobuf_mod !include 'XIOBUF.INC'
    implicit none

    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(in) :: ibegin, icount

end subroutine


subroutine xdaini_hdf5(crfile)
    use xdisc_mod !include 'xdisc.inc'
    use xunits_mod !include 'xunits.inc'
    use xssval_mod !include 'xssval.inc'
    use xdaval_mod !include 'xdaval.inc'
    use xiobuf_mod !include 'xiobuf.inc'
    implicit none

    type(t_dsc_hdf5), pointer :: crfile
end subroutine

end module

#else

!> The module hdf5_dsc holds the necessary subroutine to handle the new hdf5 
!> file format storage.
!> At present, the dsc file remains in place inside a hdf5 dataspace using an opaque datatype
module hdf5_dsc
use hdf5

integer, parameter :: ISSDAR_copy = 512
logical :: hdf5_in_use = .false.
logical, parameter :: debug_hdf5 = .false.

type, public :: t_dsc_hdf5
    integer(hid_t) :: file_id       ! file identifier
    character(len=1024) :: file_name
    integer :: idunit
    character(len=3) :: dsc_dsetname = "dsc"     ! dataset name
    integer :: dsc_blocksize = 2048 ! size of the chunks for dsc
    integer(hid_t) :: dsc_dset_id       ! dataset identifier
    integer(hid_t) :: dsc_dspace_id     ! dataspace identifier
    integer(hid_t) :: dsc_dtype         ! opaque datatype
    character(len=10) :: dsc_dtype_tag = "dsc record"
    !integer(hid_t) :: crp_list      ! dataset creation property identifier 
    !integer(hid_t) :: filespace     ! dataspace identifier 
    !integer(hid_t) :: slicespace_id ! memory dataspace identifier
end type

type(t_dsc_hdf5), dimension(:), allocatable, target, private :: hdf5_dic

contains

subroutine hdf5_dsc_use_set() bind(c)
    implicit none
    
    hdf5_in_use = .true.
    !print *, 'hdf5 set in use in fortran'
end subroutine
    

subroutine hdf5_dsc_open(crfile, filename, error)
    implicit none
    type(t_dsc_hdf5), pointer, intent(inout) :: crfile
    integer, intent(out) :: error
    character(len=*), intent(in) :: filename
    integer :: errorb
    logical fexist
    
    error = 0
    ! look for a new space to open hdf5 file
    call hdf5_dic_add(crfile, error)
    if(error/=0) then
        print *, 'error during creation of a new hdf5 file'
        call exit(1)
    end if
    crfile%idunit=-1 ! temporary unit
    crfile%file_name=filename

    !
    ! Initialize FORTRAN interface. 
    !
    
    CALL h5open_f(error)            
    
    ! check if the file exist
    inquire(file=filename, exist=fexist)
    !print *, trim(filename), fexist
    if(fexist) then
        call h5fopen_f(filename, H5F_ACC_RDWR_F, crfile%file_id, error)
        !print *, 'here!', error
        if(error/=0) then
            if(debug_hdf5) then
                print *, 'Cannot open the file ', trim(filename)
            end if
            ! destroy record in hdf5 dic
            call hdf5_dic_del(crfile%idunit, errorb)
            if(errorb/=0) then
                print *, 'Impossible to remove the failed open hdf5 file from the dictionary'
                print *, 'It is not possible to recover'
                call exit(1)
            end if
        end if      
        crfile%dsc_dset_id=0      
        crfile%dsc_dspace_id=0    
        crfile%dsc_dtype=0      
    else
    
        !
        ! Create a new file using the default properties.
        !
        !print *, 'creating hdf5 ', filename
        CALL h5fcreate_f(filename, H5F_ACC_EXCL_F, crfile%file_id, error)
        if(error/=0) then
            ! destroy record in hdf5 dic
            !print *, 'Impossible to create hdf5 file'
            if(debug_hdf5) then
                print *, 'Impossible to create the hdf5 file ', trim(filename)
            end if
            call hdf5_dic_del(crfile%idunit, errorb)
            if(errorb/=0) then
                print *, 'Impossible to remove the failed open hdf5 file from the dictionary'
                print *, 'It is not possible to recover'
                call exit(1)
            end if
        end if
        crfile%dsc_dset_id=0      
        crfile%dsc_dspace_id=0    
        crfile%dsc_dtype=0          
    end if
end subroutine

subroutine hdf5_dsc_kfetch(crfile, fetch_address, dataread, error)
    use xdaval_mod
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(in) :: fetch_address
    integer, dimension(:), intent(out) :: dataread
    integer, intent(out) :: error
    integer idaerr, inext, ireq
    
    integer fileend
    integer(hsize_t), dimension(1) :: recordoffset      !hyperslab offset in the file 
    integer(hsize_t), dimension(1) :: slicedimension 
    integer(hid_t) :: slicespace_id ! memory dataspace identifier
    type(c_ptr) :: f_ptr
    integer     ::   rank = 1                        ! dataset rank      

    
    slicedimension = (/size(dataread)/)

    ! check if the read is no bigger than the data
    call xdaend_hdf5(crfile, fileend )

    !print *, 'n, fileend ', n, fileend
    if(fetch_address>fileend) then
        error = -1
        return                 
    end if
        
    !
    !select a hyperslab.
    !
    !call h5dget_space_f(crfile%dsc_dset_id, filespace, error)
    ! offset in records from, the begining of the dataset
    recordoffset(1) = (fetch_address-1)*ISSDAR_copy
    call h5sselect_hyperslab_f(crfile%dsc_dspace_id, H5S_SELECT_SET_F, recordoffset, slicedimension, error)      
    !print *, 'KFETCH: select slice', error
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when selecting a slice (kfetch)'
        end if
    end if
    if(error==-1) return

    !
    ! create a dataspace to hold the slice in memory
    call h5screate_simple_f(rank,slicedimension,slicespace_id,error) 
    !print *, 'KFETCH ', error
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when creating a dataspace (kfetch)'
        end if
    end if
    if(error==-1) return
    
    !
    ! reading the data from the hyperslab.
    !    
    !print *, crfile%dsc_dtype, crfile%dsc_dset_id
    if(crfile%dsc_dtype==0) then
        call hdf5_dsc_get_dtype(crfile)
    end if
    call h5dread_f(crfile%dsc_dset_id, crfile%dsc_dtype, dataread, &
    &   slicedimension, error, &
    &   mem_space_id = slicespace_id, file_space_id = crfile%dsc_dspace_id )
    !print *, 'KFETCH loc, read, error ', fetch_address, dataread(1), error, size(dataread)
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when reading a slice (kfetch)'
        end if
    end if
    if(error==-1) return
    !write(*, '(A,   10(Z8.8, 1X))') 'kfetch', dataread(1:10)
        
end subroutine

subroutine hdf5_dsc_kstore(crfile, store_address, datastore, error)
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(in) :: store_address
    integer, dimension(:), intent(in) :: datastore
    integer, intent(out) :: error
    
    integer fileend
    integer(hsize_t), dimension(1) :: recordoffset      !hyperslab offset in the file 
    integer(hsize_t), dimension(1) :: slicedimension 
    integer(hid_t) :: filespace     ! dataspace identifier 
    integer(hid_t) :: slicespace_id ! memory dataspace identifier
    type(c_ptr) :: f_ptr
    integer     ::   rank = 1                        ! dataset rank      
    integer(hsize_t), dimension(1) :: readdims ! dataset dimensions
    integer(hsize_t), dimension(1) :: readmaxdims  ! dataset dimensions
    integer last
        
    slicedimension(1)=size(datastore)
    ! check if there is enough space
    call xdaend_hdf5 (crfile, last )
    
    if(last<=store_address) then
        call hdf5_dsc_extend(crfile, error, store_address-last+1)
    end if
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when extending the dsc dataset (kstore)'
        end if
    end if    
    if(error==-1) return
    call hdf5_dsc_get_dspace(crfile) 

    !
    !select a hyperslab.
    !
    call h5dget_space_f(crfile%dsc_dset_id, filespace, error)
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when getting the dsc dataspace (kstore)'
        end if
    end if    
    if(error==-1) return
    !! offset in records from, the begining of the dataset
    recordoffset(1) = (store_address-1)*ISSDAR_copy
    call h5sselect_hyperslab_f(filespace, H5S_SELECT_SET_F, recordoffset, slicedimension, error)      
    !print *, 'xdaxtn_hdf5: select slice', error
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when selecting a slice (kstore)'
        end if
    end if
    if(error==-1) return

    !
    ! create a dataspace to hold the slice in memory
    !
    call h5screate_simple_f(rank,slicedimension,slicespace_id,error) 
    !print *, 'xdaxtn_hdf5 ', error
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when creating a tempoaray dataspace (kstore)'
        end if
    end if
    if(error==-1) return

    !
    !write the data to the hyperslab.
    !    
    call h5dwrite_f(crfile%dsc_dset_id, crfile%dsc_dtype, datastore, slicedimension, &
    &   error, file_space_id = filespace, mem_space_id = slicespace_id)
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when writing data (kstore)'
        end if
    end if
    !print *, 'xdaxtn_hdf5 writing: ', store_address, datastore(1), error
end subroutine

subroutine hdf5_dsc_get_dspace(crfile) 
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer error
    
    if(crfile%dsc_dset_id==0) then
        call hdf5_dsc_get_dset(crfile) 
    end if  
    
    call h5dget_space_f(crfile%dsc_dset_id, crfile%dsc_dspace_id, error) 
    !print *, 'Getting dspace '
    if(error/=0) then
        print *, 'h5dget_space_f ', crfile%dsc_dset_id
        print *, 'Impossible to copy the dsc dataset to a dataspace'
        call exit(1)
    end if
end subroutine


subroutine hdf5_dsc_get_dset(crfile) 
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer error

    if(crfile%file_id==0) then
        print *, 'hdf5 file not opened, cannot get dataset'
        call exit(1)
    end if

    CALL h5dopen_f(crfile%file_id, crfile%dsc_dsetname, crfile%dsc_dset_id, error)
    if(error/=0) then
        print *, 'Impossible to open the dsc dataset from: ', crfile%file_name
        call exit(1)
    end if
end subroutine

subroutine hdf5_dsc_get_dtype(crfile)
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer error

    if(crfile%dsc_dset_id==0) then
        call hdf5_dsc_get_dset(crfile) 
    end if

    call h5dget_type_f(crfile%dsc_dset_id, crfile%dsc_dtype, error) 
    !print *, crfile%dsc_dset_id, crfile%dsc_dspace_id, crfile%dsc_dtype
    if(error/=0) then
        print *, 'Impossible to get the data type of the dsc dataspace'
        call exit(1)
    end if
end subroutine

subroutine hdf5_dic_del(idunit, error)
    implicit none
    integer, intent(in) :: idunit
    type(t_dsc_hdf5), dimension(size(hdf5_dic)) :: temp
    integer, intent(out) :: error
    integer i

    error=-1
    if(allocated(hdf5_dic)) then
        temp=hdf5_dic
        
        do i=1, size(temp)
            if(temp(i)%idunit==idunit) then
                deallocate(hdf5_dic)
                if(size(temp)>1) then
                    allocate(hdf5_dic(size(temp)-1))
                    if(i>1) then
                        hdf5_dic(1:i-1)=temp(1:i-1)
                    end if
                    if(i<size(temp)) then
                        hdf5_dic(i:size(hdf5_dic))=temp(i+1:size(hdf5_dic)+1)
                    end if
                end if
                error = 0
                return
            end if
        end do
    end if
end subroutine

subroutine hdf5_dic_add(crfile, error)
    implicit none
    type(t_dsc_hdf5), intent(out), pointer :: crfile
    type(t_dsc_hdf5), dimension(size(hdf5_dic)) :: temp
    integer, intent(out) :: error
    integer i

    error=-1
    if(allocated(hdf5_dic)) then
        temp=hdf5_dic
        deallocate(hdf5_dic)
        allocate(hdf5_dic(size(temp)+1))
        hdf5_dic(1:size(temp))=temp
        crfile=>hdf5_dic(size(temp)+1)
        error = 0
    else
        allocate(hdf5_dic(1))
        crfile=>hdf5_dic(1)
        error = 0
    end if
end subroutine


subroutine hdf5_dic_get(crfile, idunit, error)
    implicit none
    type(t_dsc_hdf5), intent(out), pointer :: crfile
    integer, intent(in) :: idunit
    integer, intent(out) :: error
    integer i
    
    !print *, 'hdf5 dic ', size(hdf5_dic)
    error=-1
    if(allocated(hdf5_dic)) then
        do i=1, size(hdf5_dic)
            !print *, 'search dic ', trim(hdf5_dic(i)%file_name), hdf5_dic(i)%idunit
            !print *, 'idunit in dic ', i, hdf5_dic(i)%idunit
            if(hdf5_dic(i)%idunit==idunit) then
                crfile=>hdf5_dic(i)
                error=0
                return
            end if
        end do
    end if
    
end subroutine
    
subroutine printdic()
    implicit none
    integer i

    if(allocated(hdf5_dic)) then
        do i=1, size(hdf5_dic)
            print *, 'dic ', i, trim(hdf5_dic(i)%file_name), hdf5_dic(i)%idunit
        end do
    else 
        print *, 'dic not alloated'
    end if
    
end subroutine

subroutine xdaend_hdf5 (crfile, last )
    use xunits_mod !include 'XUNITS.INC'
    use xssval_mod !include 'XSSVAL.INC'
    use xerval_mod !include 'XERVAL.INC'
    implicit none
!c
!c -- returns number of record that would follow the last actually
!c    present in a disc file
!c

    type(t_dsc_hdf5), intent(inout) :: crfile      
    integer, intent(out) :: last
    integer(hsize_t), dimension(1) :: readdims ! dataset dimensions
    integer(hsize_t), dimension(1) :: readmaxdims  ! dataset dimensions
    integer error

    if(crfile%dsc_dspace_id==0) then
        ! dataspace not opened
        ! Open an existing dataset.
        !
        call hdf5_dsc_get_dspace(crfile) 
    end if
        
    !
    ! read the dimensions of the current data set
    !
    !print *, 'crfile%dsc_dspace_id ', crfile%dsc_dspace_id
    call h5sget_simple_extent_dims_f(crfile%dsc_dspace_id, readdims, &
    &    readmaxdims, error)
    !print *, error
    !print *, 'dims: ', readdims, ' maxdims: ', readmaxdims
    if(error==-1) then
        print *, 'error in xdaend_hdf5'
        call exit(1)
    end if
    last = readdims(1)/ISSDAR_copy
end subroutine

subroutine hdf5_dsc_extend(crfile, error, extendsizearg)
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(out) :: error
    integer, intent(in), optional :: extendsizearg
    integer(hsize_t), dimension(1) :: readdims, maxdims ! dataset dimensions
    integer(hsize_t), dimension(1) :: readmaxdims  ! dataset dimensions
    integer fileend
    integer :: extendsize
    integer     ::   rank = 1                        ! dataset rank
    
    if(present(extendsizearg)) then
        extendsize=extendsizearg*ISSDAR_copy
    else
        extendsize=crfile%dsc_blocksize
    end if
    
    if(crfile%dsc_dspace_id==0) then
        call hdf5_dsc_get_dspace(crfile) 
    end if
    
    !
    ! read the dimensions of the current data set
    !
    call h5sget_simple_extent_dims_f(crfile%dsc_dspace_id, &
    &   readdims, readmaxdims, error)
    !print *, 'h5sget_simple_extent_dims_f ', error
    !print *, 'dims: ', readdims, ' maxdims: ', readmaxdims            
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when readinf dimension of the dsc (dsc_extend)'
        end if
    end if
    if(error==-1) return

    call xdaend_hdf5(crfile, fileend )
    !
    !extend the dataset by the chunk size
    !
    call h5dset_extent_f(crfile%dsc_dset_id, &
        readdims+extendsize, error)
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when extending the dsc (dsc_extend)'
        end if
    end if
    !print *, 'h5dset_extent_f ', error
    if(error==-1) return
            
    ! We now need to get a new dataset, closing the current one and opening a new one with the updated size
    !
    ! end access to the dataset and release resources used by it.
    !
    call h5dclose_f(crfile%dsc_dset_id, error)
    crfile%dsc_dset_id=0
    !print *, 'h5dclose_f ', error
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when closing the dataset (dsc_extend)'
        end if
    end if
    if(error==-1) return

    !
    ! terminate access to the data space.
    !
    call h5sclose_f(crfile%dsc_dspace_id, error)
    crfile%dsc_dspace_id=0
    if(debug_hdf5) then
        if(error==-1) then
            print *, 'Error when closing dataspace (dsc_extend)'
        end if
    end if
    !print *, 'h5sclose_f ', error

end subroutine

!code for xdaxtn
subroutine xdaxtn_hdf5 (crfile, ibegin,icount )
    use xunits_mod !include 'XUNITS.INC'
    use xssval_mod !include 'XSSVAL.INC'
    use xerval_mod !include 'XERVAL.INC'
    use xdaval_mod !include 'XDAVAL.INC'
    use xiobuf_mod !include 'XIOBUF.INC'
    use hdf5
    implicit none

    type(t_dsc_hdf5), intent(inout) :: crfile
    integer(hsize_t), dimension(1) :: recordoffset      !hyperslab offset in the file 
    integer(hsize_t), dimension(1) :: slicedimension
    integer, dimension(ISSDAR_copy), target :: writedata ! write buffer
    integer(hid_t) :: filespace     ! dataspace identifier 
    integer(hid_t) :: slicespace_id ! memory dataspace identifier
    integer     ::   rank = 1                        ! dataset rank
    integer     ::   error ! error flag
    type(c_ptr) :: f_ptr
    integer(hsize_t), dimension(1) :: readdims ! dataset dimensions
    integer(hsize_t), dimension(1) :: readmaxdims, maxdims  ! dataset dimensions
    integer(hid_t) :: crp_list

    
    integer, intent(in) :: ibegin, icount
    
    integer i, iend, ios, istart, iunit, fileend, extend

!c
!c -- write 'icount' records to disc file on unit 'iunit'
!c    starting at record 'ibegin'
!c
!c
!c
!c -- if it is not possible to write new records to a direct access
!c    file, replace this routine with a suitable dummy. it will be
!c    necessary in this case to provide a method of extending disc
!c    files manually, as well as a means of creating new direct access
!c    files. this might be done by appending a new small file onto the
!c    existing one.
!c
!c
!c
!c    if ibegin is less than or equal to 0, the end of file will
!c    be searched for.
!c
!c -- ibegin may be a constant and so should not be modified
!c


    !print *, 'xdaxtn_hdf5 start'
    slicedimension = (/ISSDAR_copy/)
    istart = ibegin
    writedata=0

    if ( istart .lt. 0 ) call xdaend_hdf5(crfile, istart )

    !c -- no operation
    if ( icount .le. 0 ) go to 8000

    iend = istart + icount - 1
    if ( idamax .le. 0 ) go to 1900
    if ( iend .gt. idamax ) go to 9920
    1900  continue
    
    if(iend>istart) then
        call hdf5_dsc_extend(crfile, error, iend-istart+1)
        !print *, 'hdf5_dsc_extend ', error
        if (error == -1) goto 9900
    end if
    
    2000  continue

    8000  continue
    return

    9900  continue
    !c -- error while extending disc file
    if (issprt .eq. 0) then
        write ( ncwu , 9910 ) iunit
    endif
    !cjan08      write ( ncawu , 9910 ) iunit
    write ( cmon, 9910 ) iunit
    call xprvdu(nceror, 1,0)
    9910  format ( 1x , 'an error has occured while extending file ' , &
    &   'on unit ' , i3 )
    call xeriom ( iunit , ios )
    call xerhnd ( iercat )
    9920  continue
    !c -- size too great
    if (issprt .eq. 0) then
    write ( ncwu , 9925 ) iunit
    endif
    !cjan08      write ( ncawu , 9925 ) iunit
    write ( cmon, 9925 ) iunit
    call xprvdu(nceror, 1,0)
    9925  format ( 1x , 'the maximum size of the file on unit ' , i3 , &
    &   ' has been exceeded' )
    call xerhnd ( iercat )
    go to 9900
end subroutine


subroutine xdaini_hdf5(crfile)
    use xdisc_mod !include 'xdisc.inc'
    use xunits_mod !include 'xunits.inc'
    use xssval_mod !include 'xssval.inc'
    use xdaval_mod !include 'xdaval.inc'
    use xiobuf_mod !include 'xiobuf.inc'
    use hdf5
    implicit none

!c
!c -- initialise the new direct access file on unit 'idunit'
!c
!c

    !!!! hdf5 variables
    type(t_dsc_hdf5), pointer :: crfile
    !integer :: recordsize ! size of the opaque datatype record in bytes
    integer(hsize_t), dimension(1) :: maxdims  ! dataset dimensions
    integer     ::   rank = 1                        ! dataset rank
    integer(hsize_t), dimension(1) :: dims  ! dataset dimensions
    integer     ::   error ! error flag
    integer(hsize_t), dimension(1) :: chunksize 
    integer(size_t) :: datasize
    integer(hid_t) :: crp_list
    integer recordsize

    character*10 newnam
    integer irecno, ireq, n, nsaveu
    
    interface
        function kswpdu ( iunit )
            implicit none
            integer, intent(in) :: iunit
            integer :: kswpdu
        end function
    end interface

    !print *, associated(crfile)

    !print *, 'xdaini_hdf5 start'
    inquire(iolength=recordsize) 1.0

    dims = (/8*crfile%dsc_blocksize/)
    chunksize = (/crfile%dsc_blocksize/)
    ! constants only defined after h5open
    maxdims = (/h5s_unlimited_f/)


    !
    ! create the dataspace.
    !
    call h5screate_simple_f(rank, dims, crfile%dsc_dspace_id, error, &
    &    maxdims=maxdims)
    if(error==-1) then 
        print *, 'Error during initialisation 1'
        call exit(1)
    end if
    !print *, error
    !print *, dims, maxdims
    !print *, 'crfile%dsc_dspace_id ', crfile%dsc_dspace_id

    !
    !modify dataset creation properties, i.e. enable chunking
    !
    call h5pcreate_f(h5p_dataset_create_f, crp_list, error)
    if(error==-1) then 
        print *, 'Error during initialisation 2'
        call exit(1)
    end if
    call h5pset_chunk_f(crp_list, rank, chunksize, error)
    if(error==-1) then 
        print *, 'Error during initialisation 3'
        call exit(1)
    end if


    !
    ! create opaque datatype and set the tag to something appropriate.
    !
    inquire(iolength=recordsize) 1.0
    datasize=recordsize
    call h5tcreate_f(h5t_opaque_f, datasize, crfile%dsc_dtype,error)
    if(error==-1) then 
        print *, 'Error during initialisation 4'
        call exit(1)
    end if
    !print *, error
    call h5tset_tag_f(crfile%dsc_dtype,crfile%dsc_dtype_tag,error)
    if(error==-1) then 
        print *, 'Error during initialisation 5'
        call exit(1)
    end if
    !print *, error


    !
    ! create the dataset with default properties.
    !
    call h5dcreate_f(crfile%file_id, crfile%dsc_dsetname, &
    &    crfile%dsc_dtype, &
    &    crfile%dsc_dspace_id, crfile%dsc_dset_id, &
    &    error, crp_list)
    if(error==-1) then 
        print *, 'Error during initialisation 6'
        call exit(1)
    end if
    !print *, 'h5dcreate_f ', error, crfile%dsc_dset_id, crfile%dsc_dspace_id

    idatot = -1
    ireq = min ( idaini , idaqua )
    ireq = max ( ireq , idamin )
    irecno = 1
    !c
    !c -- write a few records to the file
    !c
    call xdaxtn_hdf5 (crfile, irecno , ireq )
    idatot = irecno + ireq -  1
    !c
    !c -- initialise file and current list indexes
    !c
    nsaveu = kswpdu ( crfile%idunit )
    !c
    call xsetfi
    call xsetli
    !c
    n = kswpdu ( nsaveu )
    !c
    call xdanam ( crfile%idunit , newnam )
    !c
    if (issprt .eq. 0) then
    write ( ncwu , 1010 ) crfile%idunit , newnam
    endif
    !cjan08      write ( ncawu , 1010 ) idunit , newnam
    1010  format ( // , 1x , 72 ( '*' ) , / , &
    & 1x , 'a new direct access file has been created ' , &
    & 'on unit ' , i3 , ' -- ' , a10 , ' file' , / , &
    & 1x , 72 ( '*' ) , // )
    write ( cmon, 1011 ) crfile%idunit , newnam
    call xprvdu(ncvdu, 1,0)
    1011  format( 1x , 'a new direct access file has been created ' , &
    & 'on unit ' , i3 , ' -- ' , a10 , ' file')
    !c
    return
end subroutine

end module

#endif
