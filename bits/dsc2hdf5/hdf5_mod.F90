module cryshdf5_mod
use HDF5
implicit none

logical, parameter :: debug_hdf5=.true.

type :: t_dsc_hdf5
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


contains

subroutine hdf5_dsc_extend(crfile, error, extendsizearg)
    implicit none
    type(t_dsc_hdf5), intent(inout) :: crfile
    integer, intent(out) :: error
    integer, intent(in), optional :: extendsizearg
    integer(hsize_t), dimension(1) :: readdims ! dataset dimensions
    integer(hsize_t), dimension(1) :: readmaxdims  ! dataset dimensions
    integer fileend
    integer :: extendsize
    integer recordsize
    
    inquire(iolength=recordsize) 1.0
    if(present(extendsizearg)) then
        extendsize=extendsizearg*recordsize
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

subroutine xdaend_hdf5 (crfile, last )
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
    integer recordsize

    inquire(iolength=recordsize) 1.0
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
    last = readdims(1)/recordsize
end subroutine

end module
