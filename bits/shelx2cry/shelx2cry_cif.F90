!> Module for the parsing of cif files \ingroup shelx2cry
module shelx2cry_cifparse_m

integer, parameter :: char_len=128 !< constant for the length of the different strings and buffers

type cif_t !< This type hold the information contained in a cif file
    character(len=char_len) :: data_id = ''!< cif data block header (data_*)
    character(len=char_len), dimension(7) :: cell = '' !< Unit cell parameters (a,b,c,alpha,beta,gamma,volume)
    character(len=char_len) :: crystal_group_name = '' !< Space group in Hall notation (_space_group_name_Hall )
    character(len=char_len) :: crystal_group_name_alt = '' !< Space group alternative name (_space_group_name_H-M_alt)
    character(len=char_len) :: crystal_system = '' !< Crystal system (_space_group_crystal_system)
    character(len=char_len) :: chemical_name_common = '' !< Chemical name (_chemical_name_common)
    integer :: resfile_no = 0 !< number of res file in a data block. Should be one or zero.
    integer :: hklfile_no = 0 !< number of hkl file in a data block. Should be one or zero.
    integer :: fabfile_no = 0 !< number of fab file in a data block. Should be one or zero.
end type

contains

!> Scan all the data blocks in a cif file. Store the result in a cif_t type.
subroutine scan_cif(cifpath, cif_content, error)
implicit none
character(len=*), intent(in) :: cifpath !< Path to the cif file
integer, intent(out) :: error !< error flag
type(cif_t), dimension(:), allocatable, intent(out) :: cif_content !< Content of the cif
integer, parameter :: cifid=815
type(cif_t), dimension(:), allocatable :: cif_content_temp
integer cif_content_index
character(len=1024) :: buffer
integer iostatus
integer i

    error = 0
    cif_content_index=0
    allocate(cif_content_temp(32))

    open(unit=cifid,file=cifpath, status='old')
    do
        read(cifid, '(a)', iostat=iostatus) buffer
        if(iostatus>0) then ! error
            error = iostatus
            exit
        else if(iostatus<0) then ! end of file
            exit
        end if
        if(index(adjustl(buffer), 'data_')==1) then
            if(cif_content_index==size(cif_content_temp)) then ! buffer full, extending...
                call move_alloc(cif_content_temp,cif_content)
                allocate(cif_content_temp(size(cif_content)+32))
                cif_content_temp(1:size(cif_content))=cif_content
                deallocate(cif_content)
            end if
            cif_content_index=cif_content_index+1
            cif_content_temp(cif_content_index)%data_id=adjustl(buffer)
            cif_content_temp(cif_content_index)%data_id=cif_content_temp(cif_content_index)%data_id(6:)
        else if(index(buffer, '_shelx_res_file')>0 .or. &
        &   index(buffer,'_iucr_refine_instructions_details')>0) then
            ! found a res file!
            cif_content_temp(cif_content_index)%resfile_no=cif_content_temp(cif_content_index)%resfile_no+1
        else if(index(buffer, '_shelx_hkl_file')>0) then
            ! found a hkl file!
            cif_content_temp(cif_content_index)%hklfile_no=cif_content_temp(cif_content_index)%hklfile_no+1
        else if(index(buffer, '_shelx_fab_file')>0) then
            ! found a fab file (squeeze)!
            cif_content_temp(cif_content_index)%fabfile_no=cif_content_temp(cif_content_index)%fabfile_no+1
        else if(index(buffer, '_cell_length_a')>0) then
            cif_content_temp(cif_content_index)%cell(1)=adjustl(buffer(index(buffer, '_cell_length_a')+15:))
        else if(index(buffer, '_cell_length_b')>0) then
            cif_content_temp(cif_content_index)%cell(2)=adjustl(buffer(index(buffer, '_cell_length_b')+15:))
        else if(index(buffer, '_cell_length_c')>0) then
            cif_content_temp(cif_content_index)%cell(3)=adjustl(buffer(index(buffer, '_cell_length_c')+15:))
        else if(index(buffer, '_cell_angle_alpha')>0) then
            cif_content_temp(cif_content_index)%cell(4)=adjustl(buffer(index(buffer, '_cell_angle_alpha')+18:))
        else if(index(buffer, '_cell_angle_beta')>0) then
            cif_content_temp(cif_content_index)%cell(5)=adjustl(buffer(index(buffer, '_cell_angle_beta')+17:))
        else if(index(buffer, '_cell_angle_gamma')>0) then
            cif_content_temp(cif_content_index)%cell(6)=adjustl(buffer(index(buffer, '_cell_angle_gamma')+18:))
        else if(index(buffer, '_cell_volume')>0) then
            cif_content_temp(cif_content_index)%cell(7)=adjustl(buffer(index(buffer, '_cell_volume')+13:))
        else if(index(buffer, '_space_group_crystal_system')>0) then
            cif_content_temp(cif_content_index)%crystal_system= &
            &   adjustl(buffer(index(buffer, '_space_group_crystal_system')+28:))
        else if(index(buffer, '_space_group_name_H-M_alt')>0) then
            cif_content_temp(cif_content_index)%crystal_group_name_alt= &
            &   adjustl(buffer(index(buffer, '_space_group_name_H-M_alt')+26:))
        else if(index(buffer, '_space_group_name_Hall')>0) then
            cif_content_temp(cif_content_index)%crystal_group_name= &
            &   adjustl(buffer(index(buffer, '_space_group_name_Hall')+23:))
        else if(index(buffer, '_chemical_name_common')>0) then
            cif_content_temp(cif_content_index)%chemical_name_common= &
            &   adjustl(buffer(index(buffer, '_chemical_name_common')+22:))
        end if        
    end do

    allocate(cif_content(cif_content_index))
    cif_content=cif_content_temp(1:cif_content_index)
    close(cifid)
    
end subroutine

!> Ask the user for which dataset to convert to crystals
subroutine ask_user(cif_content, chosen_id)
implicit none
type(cif_t), dimension(:), intent(in) :: cif_content !< Cif file content obtained from scan_cif
integer, intent(out) :: chosen_id !< Chosen dataset as the index in cif_content
integer i, res_cpt, ierror
character(len=char_len) :: message

    ! check if multiple files are present
    res_cpt=0
    do i=1, size(cif_content)
        if(cif_content(i)%resfile_no>1) then
            print *, "Error: invalid cif file. More than one res file in ", trim(cif_content(i)%data_id)
        else if(cif_content(i)%resfile_no>0) then 
            res_cpt=res_cpt+1
        end if
    end do
    
    if(res_cpt>1) then
        do i=1, size(cif_content)
            write(*, '(a)') repeat('=',14*3+1+18)
            if(cif_content(i)%resfile_no==0) then
                write(*, '(i3,")",1X,a)') i, trim(cif_content(i)%data_id)
                write(*, '(3X,a)') 'No res file present in this section'
            else
                write(*, '(i3,")",1X,a)') i, trim(cif_content(i)%data_id)
                write(*, '(a18,1x,a)') 'Name:', trim(cif_content(i)%chemical_name_common)
                write(*, '(a18,1x,a)') 'Crystal system:', trim(cif_content(i)%crystal_system)
                write(*, '(a18,1x,a)') 'Space group:', trim(cif_content(i)%crystal_group_name)
                write(*, '(a18,1x,a)') 'Space group alt:', trim(cif_content(i)%crystal_group_name_alt)
                write(*, '(a18,1x,3a14)') 'Cell lengths:', cif_content(i)%cell(1:3)
                write(*, '(a18,1x,3a14)') 'Cell angles:', cif_content(i)%cell(4:6)
            end if
        end do
        write(*, '(a)') repeat('=',14*3+1+18)
        
        message=''
        do        
            if(len_trim(message)>0) then
                write(*, '(a)') trim(message)
            end if
            write(*, '(a,"[",I0,"-",I0,"]: ")', advance='no') 'Choose which file to import ',1,size(cif_content)
            read(*, '(I4)', iostat=ierror) chosen_id
            ! check user input
            if(ierror/=0) then
                write(message,'(a,"[",I0,"-",I0,"]")')  &
                &   'Error: invalid choice. Choose a number in the interval ',1,size(cif_content)
                cycle
            else
                if(chosen_id<1 .or. chosen_id>size(cif_content)) then  
                    write(message,'(a,"[",I0,"-",I0,"]")') &
                    &   'Error: invalid choice. Choose a number in the interval ',1,size(cif_content)
                    cycle
                else
                    if(cif_content(chosen_id)%resfile_no<1) then
                        write(message,'(a)') &
                        &   'Error: Empty dataset, no res file present '
                        cycle
                    end if
                    exit
                end if
            end if
        end do
    end if
    print *, ''
    
end subroutine

!> Extract a res file from a cif file
subroutine extract_res_from_cif(shelx_filepath)
use crystal_data_m, only: log_unit
implicit  none
character(len=*), intent(in) :: shelx_filepath
character(len=char_len) :: res_filepath, fab_filepath, hkl_filepath
integer resid, cifid, iostatus
character(len=2048) :: buffer, tempc
character(len=char_len) :: data_id
integer checksumhkl, checksumhklref, i
integer checksumres, checksumresref
integer checksumfab, checksumfabref

    checksumhkl=0
    checksumhklref=0
    checksumres=0
    checksumresref=0
    checksumfab=0
    checksumfabref=0

    cifid=815
    open(unit=cifid,file=shelx_filepath, status='old')
    do
        read(cifid, '(a)', iostat=iostatus) buffer
        if(iostatus/=0) then
            exit
        end if
        if(index(adjustl(buffer), 'data_')==1) then
            data_id=adjustl(buffer)
            data_id=data_id(6:)
        end if
        
        if(index(buffer, '_shelx_res_file')>0 .or. &
        &   index(buffer,'_iucr_refine_instructions_details')>0) then
            ! found a res file!
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                print *, 'unexpected line: ', trim(buffer)
                print *, 'I was expecting `;`'
                call abort()
            end if
            
            checksumres=0
            res_filepath=shelx_filepath
            res_filepath(len_trim(res_filepath)-3:)='_'//trim(data_id)//'.res'
            resid=816
            open(unit=resid,file=trim(res_filepath))       
            do
                read(cifid, '(a)', iostat=iostatus) buffer
                if(iostatus/=0 .or. trim(buffer)==';') then
                    close(resid)
                    exit
                end if
                write(resid, '(a)') trim(buffer)
                do i=1, len_trim(buffer)
                    if(buffer(i:i)>' ') then
                        checksumres=checksumres+iachar(buffer(i:i))
                    end if
                end do                
            end do
            checksumres=mod(checksumres, 714025)
            checksumres=checksumres*1366+150889
            checksumres=mod(checksumres, 714025)
            checksumres=mod(checksumres, 100000)        
        end if
        if(index(buffer, '_shelx_res_checksum')>0) then
            read(buffer, *) tempc, checksumresref
        end if

        if(index(buffer, '_shelx_hkl_file')>0) then
            ! found a hkl file!
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                write(log_unit, '(2a)') 'unexpected line: ', trim(buffer)
                write(log_unit, '(a)') 'I was expecting `;`'
                call abort()
            end if
            
            checksumhkl=0
            hkl_filepath=shelx_filepath
            hkl_filepath(len_trim(hkl_filepath)-3:)='_'//trim(data_id)//'.hkl'
            resid=816
            open(unit=resid,file=trim(hkl_filepath))       
            do
                read(cifid, '(a)', iostat=iostatus) buffer
                if(iostatus/=0 .or. trim(buffer)==';') then
                    close(resid)
                    exit
                end if
                write(resid, '(a)') trim(buffer)
                do i=1, len_trim(buffer)
                    if(buffer(i:i)>' ') then
                        checksumhkl=checksumhkl+iachar(buffer(i:i))
                    end if
                end do                
            end do
            checksumhkl=mod(checksumhkl, 714025)
            checksumhkl=checksumhkl*1366+150889
            checksumhkl=mod(checksumhkl, 714025)
            checksumhkl=mod(checksumhkl, 100000)        
        end if
        if(index(buffer, '_shelx_hkl_checksum')>0) then
            read(buffer, *) tempc, checksumhklref
        end if
        
        
        if(index(buffer, '_shelx_fab_file')>0) then
            ! found a fab file (squeeze)!
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                write(log_unit, '(2a)') 'unexpected line: ', trim(buffer)
                write(log_unit, '(a)') 'I was expecting `;`'
                call abort()
            end if
            
            checksumfab=0
            fab_filepath=shelx_filepath
            fab_filepath(len_trim(fab_filepath)-3:)='_'//trim(data_id)//'.fab'
            resid=816
            open(unit=resid,file=trim(fab_filepath))       
            do
                read(cifid, '(a)', iostat=iostatus) buffer
                if(iostatus/=0 .or. trim(buffer)==';') then
                    close(resid)
                    exit
                end if
                write(resid, '(a)') trim(buffer)
                do i=1, len_trim(buffer)
                    if(buffer(i:i)>' ') then
                        checksumfab=checksumfab+iachar(buffer(i:i))
                    end if
                end do                
            end do
            checksumfab=mod(checksumfab, 714025)
            checksumfab=checksumfab*1366+150889
            checksumfab=mod(checksumfab, 714025)
            checksumfab=mod(checksumfab, 100000)        
        end if        
        if(index(buffer, '_shelx_fab_checksum')>0) then
            read(buffer, *) tempc, checksumfabref
        end if
    end do
    
    ! checking checksums
    if(checksumhklref>0 .and. checksumhkl>0) then
        if(checksumhkl/=checksumhklref) then
            write(log_unit, '(a, a)') 'hkl file is corrupted, the checksum is invalid in ', trim(hkl_filepath)
        end if
        checksumhklref=0
        checksumhkl=0
    end if
    if(checksumfabref>0 .and. checksumfab>0) then
        if(checksumfab/=checksumfabref) then
            write(log_unit, '(a, a)') 'fab file is corrupted, the checksum is invalid in ', trim(fab_filepath)
        end if
        checksumfabref=0
        checksumfab=0
    end if
    if(checksumresref>0 .and. checksumres>0) then
        if(checksumres/=checksumresref) then
            write(log_unit, '(a, a)') 'res file is corrupted, the checksum is invalid in ', trim(res_filepath)
        end if
        checksumres=0
        checksumresref=0
    end if
        
end subroutine

!> Print the content of a cif file
subroutine print_content(cif_content)
implicit none
type(cif_t), dimension(:), intent(in) :: cif_content !< Cif file content obtained from scan_cif
integer i, res_cpt

    ! check if multiple files are present
    res_cpt=0
    do i=1, size(cif_content)
        if(cif_content(i)%resfile_no>1) then
            print *, "Error: invalid cif file. More than one res file in ", trim(cif_content(i)%data_id)
        else if(cif_content(i)%resfile_no>0) then 
            res_cpt=res_cpt+1
        end if
    end do
    
    if(res_cpt>1) then
        do i=1, size(cif_content)
            write(*, '(a)') repeat('=',14*3+1+18)
            if(cif_content(i)%resfile_no==0) then
                write(*, '(i3,")",1X,a)') i, trim(cif_content(i)%data_id)
                write(*, '(3X,a)') 'No res file present in this section'
            else
                write(*, '(i3,")",1X,a)') i, trim(cif_content(i)%data_id)
                write(*, '(a18,1x,a)') 'Name:', trim(cif_content(i)%chemical_name_common)
                write(*, '(a18,1x,a)') 'Crystal system:', trim(cif_content(i)%crystal_system)
                write(*, '(a18,1x,a)') 'Space group:', trim(cif_content(i)%crystal_group_name)
                write(*, '(a18,1x,a)') 'Space group alt:', trim(cif_content(i)%crystal_group_name_alt)
                write(*, '(a18,1x,3a14)') 'Cell lengths:', cif_content(i)%cell(1:3)
                write(*, '(a18,1x,3a14)') 'Cell angles:', cif_content(i)%cell(4:6)
            end if
            if(cif_content(i)%hklfile_no==0) then
                write(*, '(3X, a)') 'No hkl file present in this section'
            end if
            if(cif_content(i)%fabfile_no==1) then
                write(*, '(3X, a)') 'A fab file has been found, the structure has been squeezed'
            end if
        end do
        write(*, '(a)') repeat('=',14*3+1+18)
        
    end if
end subroutine

end module
