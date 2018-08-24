!> Module for the parsing of cif files \ingroup shelx2cry
module shelx2cry_cifparse_m

integer, parameter :: char_len=128 !< constant for the length of the different strings and buffers

type cif_t !< This type hold the information contained in a cif file
    character(len=char_len) :: data_id = ''!< cif data block header (data_*)
    character(len=char_len) :: audit_creation_method = '' !< Software used for refinement
    character(len=char_len), dimension(7) :: cell = '' !< Unit cell parameters (a,b,c,alpha,beta,gamma,volume)
    character(len=char_len) :: crystal_group_name = '' !< Space group in Hall notation (_space_group_name_Hall )
    character(len=char_len) :: crystal_group_name_alt = '' !< Space group alternative name (_space_group_name_H-M_alt)
    character(len=char_len) :: crystal_system = '' !< Crystal system (_space_group_crystal_system)
    character(len=char_len) :: chemical_name_common = '' !< Chemical name (_chemical_name_common)
    integer :: resfile_no = 0 !< number of res file in a data block. Should be one or zero.
    integer :: hklfile_no = 0 !< number of hkl file in a data block. Should be one or zero.
    integer :: fabfile_no = 0 !< number of fab file in a data block. Should be one or zero.
    integer :: hklchecksum_cal = 0 !< Shelxl checksum calculated from data
    integer :: hklchecksum_ref = 0 !< shelxl checksum as read in the cif
    integer :: reschecksum_cal = 0 !< Shelxl checksum calculated from data
    integer :: reschecksum_ref = 0 !< shelxl checksum as read in the cif
    integer :: fabchecksum_cal = 0 !< Shelxl checksum calculated from data
    integer :: fabchecksum_ref = 0 !< shelxl checksum as read in the cif
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
character(len=1024) :: buffer, tempc
integer iostatus
integer i, checksum

    error = 0
    cif_content_index=0
    allocate(cif_content_temp(32))

    open(unit=cifid,file=cifpath, status='old')
    read(cifid, '(a)', iostat=iostatus) buffer
    do
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
        else if(index(buffer, '_audit_creation_method')>0) then
            cif_content_temp(cif_content_index)%audit_creation_method=adjustl(buffer(index(buffer, '_audit_creation_method')+22:))
            if(trim(cif_content_temp(cif_content_index)%audit_creation_method)=='') then ! probably a text bloc
                read(cifid, '(a)', iostat=iostatus) buffer
                if(iostatus>0) then ! error
                    error = iostatus
                    exit
                else if(iostatus<0) then ! end of file
                    exit
                end if   
                if(trim(buffer)==';') then ! it is a text bloc
                    do 
                        read(cifid, '(a)', iostat=iostatus) buffer
                        if(iostatus>0) then ! error
                            error = iostatus
                            exit
                        else if(iostatus<0) then ! end of file
                            exit
                        end if   
                        if(trim(buffer)==';') then
                            exit
                        else
                            cif_content_temp(cif_content_index)%audit_creation_method= &
                            &   trim(cif_content_temp(cif_content_index)%audit_creation_method)// &
                            &   ' '//trim(buffer)
                        end if
                    end do
                end if
            end if
        else if(index(buffer, '_shelx_res_file')>0 .or. &
        &   index(buffer,'_iucr_refine_instructions_details')>0) then
            ! found a res file!
            cif_content_temp(cif_content_index)%resfile_no=cif_content_temp(cif_content_index)%resfile_no+1

            ! Calculate shelxl checksum
            read(cifid, '(a)', iostat=iostatus) buffer
            if(iostatus>0) then ! error
                error = iostatus
                exit
            else if(iostatus<0) then ! end of file
                exit
            end if   
            if(trim(buffer)==';') then ! Start of the bloc
                checksum=0
                do 
                    read(cifid, '(a)', iostat=iostatus) buffer
                    if(iostatus>0) then ! error
                        error = iostatus
                        exit
                    else if(iostatus<0) then ! end of file
                        exit
                    end if   
                    if(trim(buffer)==';') then ! end of the bloc
                        exit
                    else
                        do i=1, len_trim(buffer)
                            if(buffer(i:i)>' ') then
                                checksum=checksum+iachar(buffer(i:i))
                            end if
                        end do                
                    end if
                end do
                checksum=mod(checksum, 714025)
                checksum=checksum*1366+150889
                checksum=mod(checksum, 714025)
                checksum=mod(checksum, 100000)        
                cif_content_temp(cif_content_index)%reschecksum_cal=checksum
            end if
        else if(index(buffer, '_shelx_res_checksum')>0) then
            read(buffer, *) tempc, cif_content_temp(cif_content_index)%reschecksum_ref
        else if(index(buffer, '_shelx_hkl_file')>0 .or. &
        &   index(buffer, '_iucr_refine_reflections_details')>0) then
            ! found a hkl file!
            cif_content_temp(cif_content_index)%hklfile_no=cif_content_temp(cif_content_index)%hklfile_no+1
            
            ! Calculate shelxl checksum
            read(cifid, '(a)', iostat=iostatus) buffer
            if(iostatus>0) then ! error
                error = iostatus
                exit
            else if(iostatus<0) then ! end of file
                exit
            end if   
            if(trim(buffer)==';') then ! Start of the bloc
                checksum=0
                do 
                    read(cifid, '(a)', iostat=iostatus) buffer
                    if(iostatus>0) then ! error
                        error = iostatus
                        exit
                    else if(iostatus<0) then ! end of file
                        exit
                    end if   
                    if(trim(buffer)==';') then ! end of the bloc
                        exit
                    else
                        do i=1, len_trim(buffer)
                            if(buffer(i:i)>' ') then
                                checksum=checksum+iachar(buffer(i:i))
                            end if
                        end do                
                    end if
                end do
                checksum=mod(checksum, 714025)
                checksum=checksum*1366+150889
                checksum=mod(checksum, 714025)
                checksum=mod(checksum, 100000)        
                cif_content_temp(cif_content_index)%hklchecksum_cal=checksum
            end if
        else if(index(buffer, '_shelx_hkl_checksum')>0) then
            read(buffer, *) tempc, cif_content_temp(cif_content_index)%hklchecksum_ref
        else if(index(buffer, '_shelx_fab_file')>0) then
            ! found a fab file (squeeze)!
            cif_content_temp(cif_content_index)%fabfile_no=cif_content_temp(cif_content_index)%fabfile_no+1

            ! Calculate shelxl checksum
            read(cifid, '(a)', iostat=iostatus) buffer
            if(iostatus>0) then ! error
                error = iostatus
                exit
            else if(iostatus<0) then ! end of file
                exit
            end if   
            if(trim(buffer)==';') then ! Start of the bloc
                checksum=0
                do 
                    read(cifid, '(a)', iostat=iostatus) buffer
                    if(iostatus>0) then ! error
                        error = iostatus
                        exit
                    else if(iostatus<0) then ! end of file
                        exit
                    end if   
                    if(trim(buffer)==';') then ! end of the bloc
                        exit
                    else
                        do i=1, len_trim(buffer)
                            if(buffer(i:i)>' ') then
                                checksum=checksum+iachar(buffer(i:i))
                            end if
                        end do                
                    end if
                end do
                checksum=mod(checksum, 714025)
                checksum=checksum*1366+150889
                checksum=mod(checksum, 714025)
                checksum=mod(checksum, 100000)        
                cif_content_temp(cif_content_index)%fabchecksum_cal=checksum
            end if
        else if(index(buffer, '_shelx_fab_checksum')>0) then
            read(buffer, *) tempc, cif_content_temp(cif_content_index)%fabchecksum_ref
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
        
        read(cifid, '(a)', iostat=iostatus) buffer
        if(iostatus>0) then ! error
            error = iostatus
            exit
        else if(iostatus<0) then ! end of file
            exit
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
                write(*, '(a18,1x,a)') 'Refined by:', trim(cif_content(i)%audit_creation_method(1:14*3))
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
integer res_signature, i
logical test

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
            res_signature=0
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                print *, 'unexpected line: ', trim(buffer)
                print *, 'I was expecting `;`'
                call abort()
            end if
            
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
                if(index(buffer, 'CELL')==1 .or. &
                &   index(buffer, 'HKLF')==1 .or. &
                &   index(buffer, 'SFAC')==1) then
                    res_signature=res_signature+1
                end if
                write(resid, '(a)') trim(buffer)
            end do
            if(res_signature==3) then 
                close(resid)
            else ! this is not a shelx res file, deleting
                close(resid)
                ! weird, if I add status="delete" above it does not work. 
                ! I have to close it, open it again and then close it with delete
                ! (gfortran 8.1)
                print *, 'The instruction details from the cif are not a res file'
                open(unit=resid,file=trim(res_filepath)) 
                close(resid, status="DELETE", iostat=res_signature)
            end if
        end if

        if(index(buffer, '_shelx_hkl_file')>0 .or. &
        &   index(buffer, '_iucr_refine_reflections_details')>0) then
            ! found a hkl file!
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                write(log_unit, '(2a)') 'unexpected line: ', trim(buffer)
                write(log_unit, '(a)') 'I was expecting `;`'
                call abort()
            end if
            
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
            end do
        end if        
        
        if(index(buffer, '_shelx_fab_file')>0) then
            ! found a fab file (squeeze)!
            read(cifid, '(a)', iostat=iostatus) buffer
            if(trim(buffer)/=';') then
                write(log_unit, '(2a)') 'unexpected line: ', trim(buffer)
                write(log_unit, '(a)') 'I was expecting `;`'
                call abort()
            end if
            
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
            end do
        end if        
    end do
            
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
    
    if(res_cpt>0) then
        do i=1, size(cif_content)
            write(*, '(a)') repeat('=',14*3+1+18)
            if(cif_content(i)%resfile_no==0) then
                write(*, '(i3,")",1X,a)') i, trim(cif_content(i)%data_id)
                write(*, '(3X,a)') 'No res file present in this section'
            else
                write(*, '(i3,")",1X,a)') i, trim(cif_content(i)%data_id)
                write(*, '(a18,1x,a)') 'Refined by:', trim(cif_content(i)%audit_creation_method(1:14*3))
                write(*, '(a18,1x,a)') 'Name:', trim(cif_content(i)%chemical_name_common)
                write(*, '(a18,1x,a)') 'Crystal system:', trim(cif_content(i)%crystal_system)
                write(*, '(a18,1x,a)') 'Space group:', trim(cif_content(i)%crystal_group_name)
                write(*, '(a18,1x,a)') 'Space group alt:', trim(cif_content(i)%crystal_group_name_alt)
                write(*, '(a18,1x,3a14)') 'Cell lengths:', cif_content(i)%cell(1:3)
                write(*, '(a18,1x,3a14)') 'Cell angles:', cif_content(i)%cell(4:6)
                if(cif_content(i)%reschecksum_ref/=0) then
                    if(cif_content(i)%reschecksum_ref/=cif_content(i)%reschecksum_cal) then
                        write(*, '(a)') '/!\ The res file is corrupted, the checksum does not match'
                    end if
                end if
            end if
            if(cif_content(i)%hklfile_no==0) then
                write(*, '(3X, a)') 'No hkl file present in this section'
            else
                if(cif_content(i)%hklchecksum_ref/=0) then
                    if(cif_content(i)%hklchecksum_ref/=cif_content(i)%hklchecksum_cal) then
                        write(*, '(a)') '/!\ The hkl file is corrupted, the checksum does not match'
                    end if
                end if
            end if
            if(cif_content(i)%fabfile_no==1) then
                write(*, '(3X, a)') 'A fab file has been found, the structure has been squeezed'
                if(cif_content(i)%fabchecksum_ref/=0) then
                    if(cif_content(i)%fabchecksum_ref/=cif_content(i)%fabchecksum_cal) then
                        write(*, '(a)') '/!\ The fab file is corrupted, the checksum does not match'
                    end if
                end if
            end if
        end do
        write(*, '(a)') repeat('=',14*3+1+18)
        
    end if
end subroutine

end module
