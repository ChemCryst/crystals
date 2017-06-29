program dsc2hdf5
use HDF5
use cryshdf5_mod
implicit none

!!!! hdf5 variables
type(t_dsc_hdf5) :: crfile
!integer :: recordsize ! size of the opaque datatype record in bytes
integer(hsize_t), dimension(1) :: maxdims  ! dataset dimensions
integer     ::   rank = 1                        ! dataset rank
integer(hsize_t), dimension(1) :: dims  ! dataset dimensions
integer     ::   error ! error flag
integer(hsize_t), dimension(1) :: chunksize 
integer(size_t) :: datasize
integer(hid_t) :: crp_list
integer(hid_t) :: aspace_id     ! Attribute Dataspace identifier
integer(hid_t) :: attr_id       ! Attribute identifier    
integer(hsize_t), dimension(1) :: adims  ! Attribute dimension
integer(hid_t) :: atype_id      ! Attribute Dataspace identifier 
integer(size_t) :: attrlen    ! Length of the attribute string   
character(len=8) :: sdate
character(len=10) :: stime

integer(hsize_t), dimension(1) :: recordoffset      !hyperslab offset in the file 
integer(hsize_t), dimension(1) :: slicedimension 
integer(hid_t) :: filespace     !< dataspace identifier 
integer(hid_t) :: slicespace_id ! memory dataspace identifier

integer, parameter :: dsc_unit=123
character(len=1024) :: dsc_name
integer recordsize
logical file_exists

integer(HSIZE_T), parameter :: slice_len=512
integer, dimension(slice_len) :: dsc_slice
integer(HSIZE_T) :: address
integer ios
    
integer i, j, file_size
character(len=2048) :: buffer

       
    inquire(iolength=recordsize) 1.0
    

    ! check if filename is passed via argument
    i=command_argument_count()
    if(i>0) then
        call get_command_argument(1 , buffer)
        dsc_name=trim(buffer)
    else
        dsc_name='crfilev2.dsc'
    end if
    inquire(file=dsc_name, exist=file_exists)
    if(.not. file_exists) then
        print *, 'File ', trim(dsc_name), ' does not exists'
        stop
    end if
    
    i=index(dsc_name, '.dsc')
    if(i==0) then
        print *, 'The file given is not a dsc file'
        stop
    end if
    crfile%file_name=dsc_name
    crfile%file_name(i:i+3)='.h5 '
    
    ! check if hdf5 already exists, if it is the case, make a backup
    inquire(file=crfile%file_name, exist=file_exists)
    if(file_exists) then
    
        ! making a backup
        inquire (file=crfile%file_name, size=file_size)
        open(unit=123, file=crfile%file_name, access='direct', status='old', &
        &   action='read', iostat=error, recl=len(buffer))
        ! record for writting is 1 to ensure identical copy
        open(unit=124, file=trim(crfile%file_name)//'.old', access='direct', &
        &   status='replace', action='write', iostat=error, recl=1)
        i = 1
        do
            read(unit=123, rec=i, iostat=error) buffer
            if (error/=0) exit
            do j=(i-1)*len(buffer)+1, min(file_size, i*len(buffer))
                write(unit=124, rec=j) buffer(j-(i-1)*len(buffer):j-(i-1)*len(buffer))
            end do
            i = i + 1
        end do
        close(123)
        close(124)

        ! deleting the file
        open(unit=1234, iostat=ios, file=crfile%file_name, status='old')
        if (ios == 0) close(1234, status='delete')    
    end if

    open(dsc_unit, file=dsc_name, access='direct', form='unformatted', recl=recordsize*slice_len)
    inquire (file=dsc_name, size=file_size)
    
    !
    ! Initialize FORTRAN interface. 
    !    
    CALL h5open_f(error)            
    
    ! creating the hdf5 file
    CALL h5fcreate_f(crfile%file_name, H5F_ACC_EXCL_F, crfile%file_id, error)
    if(error/=0) then
        ! destroy record in hdf5 dic
        !print *, 'Impossible to create hdf5 file'
        if(debug_hdf5) then
            print *, 'Impossible to create the hdf5 file ', trim(crfile%file_name)
        end if
    end if
    crfile%dsc_dset_id=0      
    crfile%dsc_dspace_id=0    
    crfile%dsc_dtype=0          


    ! set up a few constants
    dims = (/8*crfile%dsc_blocksize/)
    chunksize = (/crfile%dsc_blocksize/)
    maxdims = (/h5s_unlimited_f/)
    
    ! Create attribute holding version number
    adims = 1
    CALL h5screate_simple_f(1, adims, aspace_id, error)
    CALL h5acreate_f(crfile%file_id, "Version", H5T_NATIVE_INTEGER, aspace_id, attr_id, error)
    CALL h5awrite_f(attr_id, H5T_NATIVE_INTEGER, (/0/), adims, error)
    CALL h5aclose_f(attr_id, error)

    ! Create attribute with date and time
    adims = 1
    call DATE_AND_TIME(sdate, stime)
    CALL h5tcopy_f(H5T_NATIVE_CHARACTER, atype_id, error)
    attrlen=len(sdate)+len(stime)+1
    CALL h5tset_size_f(atype_id, attrlen, error)    
    CALL h5screate_simple_f(1, adims, aspace_id, error)
    CALL h5acreate_f(crfile%file_id, "Creation date", atype_id, aspace_id, attr_id, error)
    CALL h5awrite_f(attr_id, atype_id, sdate//' '//stime , adims, error)
    CALL h5aclose_f(attr_id, error)

    !
    ! create the dataspace.
    !
    call h5screate_simple_f(1, (/2_hsize_t/), crfile%dsc_dspace_id, error, &
    &    maxdims=maxdims)
    if(error==-1) then 
        print *, 'Error during initialisation 1'
        call exit(1)
    end if

    !
    !create and modify dataset creation properties, i.e. enable chunking and compression
    !
    call h5pcreate_f(H5P_DATASET_CREATE_F, crp_list, error)
    if(error==-1) then 
        print *, 'Error during initialisation 2'
        call exit(1)
    end if
    ! enable chunks
    call h5pset_chunk_f(crp_list, rank, chunksize, error)
    if(error==-1) then 
        print *, 'Error during initialisation 3'
        call exit(1)
    end if

    ! Set ZLIB / DEFLATE Compression using compression level 6.
    CALL h5pset_deflate_f(crp_list, 6, error)
    if(error==-1) then 
        print *, 'Error during setup of compression in hdf5 file'
        call exit(1)
    end if

    !
    ! create opaque datatype and set the tag to something appropriate.
    ! This datatype holds the dsc file
    !
    datasize=recordsize
    call h5tcreate_f(h5t_opaque_f, datasize, crfile%dsc_dtype,error)
    if(error==-1) then 
        print *, 'Error during initialisation 4'
        call exit(1)
    end if
    ! set the tag
    call h5tset_tag_f(crfile%dsc_dtype,crfile%dsc_dtype_tag,error)
    if(error==-1) then 
        print *, 'Error during initialisation 5'
        call exit(1)
    end if

    !
    ! create the dataset with default properties. (the dsc itself)
    !
    call h5dcreate_f(crfile%file_id, crfile%dsc_dsetname, &
    &    crfile%dsc_dtype, &
    &    crfile%dsc_dspace_id, crfile%dsc_dset_id, &
    &    error, crp_list)
    if(error==-1) then 
        print *, 'Error during initialisation 6'
        call exit(1)
    end if

    call h5pclose_f(crp_list, error) 


    ! start copying the data
    address=0
    do     
        address=address+1
        read ( dsc_unit, rec = address, iostat = error) dsc_slice
        if(error/=0) then
            exit
        end if
    
        slicedimension(1)=size(dsc_slice)    
        ! extend the dsc datatype
        call hdf5_dsc_extend(crfile, error, size(dsc_slice))
        if(debug_hdf5) then
            if(error==-1) then
                print *, 'Error when extending the dsc dataset (kstore)'
            end if
        end if    
        if(error==-1) return
        ! get the dspace again has it is closed when extended
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
        recordoffset(1) = slice_len*(address-1)
        call h5sselect_hyperslab_f(filespace, H5S_SELECT_SET_F, recordoffset, slicedimension, error)      
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
        if(debug_hdf5) then
            if(error==-1) then
                print *, 'Error when creating a tempoaray dataspace (kstore)'
            end if
        end if
        if(error==-1) return

        !
        !write the data to the hyperslab.
        !    
        call h5dwrite_f(crfile%dsc_dset_id, crfile%dsc_dtype, dsc_slice, slicedimension, &
        &   error, file_space_id = filespace, mem_space_id = slicespace_id)
        if(debug_hdf5) then
            if(error==-1) then
                print *, 'Error when writing data (kstore)'
                stop
            end if
        end if
        
    end do
    
    ! no more data to copy, close everything
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
    !print *, 'h5scl    

    CALL h5fclose_f(crfile%file_id, error)


end program


