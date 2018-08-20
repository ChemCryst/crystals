!> This program convert a shelxl ins or res file to a crystals file
!! 
!! Usage: shelx2cry filename
!! \defgroup shelx2cry
program shelx2cry
use shelx2cry_mod
use crystal_data_m
use shelx2cry_cifparse_m
use, intrinsic :: iso_fortran_env, only : output_unit
implicit none

integer arg_cpt, iostatus, arg_length
integer shelxf_id !< unit id of the shelx file
character(len=:), allocatable :: arg_val, crystals_filepath, log_filepath
character(len=char_len) :: res_file, hkl_file, buffer, shelx_filepath
type(line_t) :: line
logical file_exists
integer i
integer error
type(cif_t), dimension(:), allocatable :: cif_content

summary%error_no=0
summary%warning_no=0
hkl_file=''
shelx_filepath=''

! Default length
allocate(character(len=1) :: arg_val)

arg_cpt=command_argument_count()
if( arg_cpt<1) then
    print *, "Wrong number of arguments expected"
    print *, 'Use `shelx2cry --help` for help'
    stop
end if

i=0
do 
    if(i>=arg_cpt) exit
    i=i+1
    
    ! arg length first
    call get_command_argument(i, arg_val, arg_length, iostatus)
    if(iostatus>0) then
        print *, i, 'Cannot retrieve command line argument'
        call abort()
    end if
    deallocate(arg_val)
    allocate(character(len=max(13, arg_length)) :: arg_val)
    call get_command_argument(i, arg_val, arg_length, iostatus)
    if(iostatus/=0) then
        print *, i, 'Cannot retrieve command line argument again'
        call abort()
    end if
    
    if(arg_val(1:6)=='--help' .or. arg_val(1:2)=='-h') then
        print *, 'shelx2cry: Conversion utility from shelxl files to crystals'
        print *, ''
        print *, 'Usage : shelx2cry [-o file] [-l log] [--hkl=file.hkl] [-i] file'
        print *, ''
        print *, 'List of options:'
        print *, '--help, -h                   This help'
        print *, '--hkl file.hkl               Specify an hkl file [default: name taken from the resfile]'
        print *, '-o output                    File for crystals [default: crystalsinput.dat]'
        print *, '-l log file                  Log output to a file [default: shelx2cry.log]'
        print *, '-i, --interactive            Interactive mode'
        print *, ''
        stop
    
    else if(arg_val(1:13)=='--interactive' .or. arg_val(1:2)=='-i') then
        Interactive_mode=.true.
    else if(arg_val(1:5)=='--hkl') then
        ! check if name is not included
        if(len_trim(arg_val)>5) then
            ! we assume a separator (typically =: --hkl=truc.hkl)
            hkl_file=adjustl(arg_val(7:))
        else
            !filename in next argument
            ! arg length first
            i=i+1
            call get_command_argument(i, arg_val, arg_length, iostatus)
            if(iostatus>0) then
                print *, i, 'Cannot retrieve command line argument'
                call abort()
            end if
            deallocate(arg_val)
            allocate(character(len=max(6, arg_length)) :: arg_val)
            call get_command_argument(i, arg_val, arg_length, iostatus)
            if(iostatus/=0) then
                print *, i, 'Cannot retrieve command line argument again'
                call abort()
            end if
            hkl_file=arg_val
        end if

    else if(arg_val(1:2)=='-o') then
        if(len_trim(arg_val)==2) then
            if(i==arg_cpt) then
                print *, 'missing argument for -o'
                stop
            end if
            i=i+1

            ! arg length first
            call get_command_argument(i, arg_val, arg_length, iostatus)
            if(iostatus>0) then
                print *, i, 'Cannot retrieve command line argument'
                call abort()
            end if
            allocate(character(len=arg_length) :: crystals_filepath)
            call get_command_argument(i, crystals_filepath, arg_length, iostatus)
            if(iostatus/=0) then
                print *, i, 'Cannot retrieve command line argument again'
                call abort()
            end if
            
            print *, 'Crystals output file: ', crystals_filepath
        else
            if(arg_val(3:3)=='=') arg_val(3:3)=' '
            if(trim(arg_val(3:))/='') then
                allocate(character(len=len_trim(adjustl(arg_val(3:)))) :: crystals_filepath)
                crystals_filepath=adjustl(arg_val(3:))
                print *, 'Crystals output file: ', crystals_filepath
            end if
        end if
    else if(arg_val(1:2)=='-l') then
        if(len_trim(arg_val)==2) then
            if(i==arg_cpt) then
                print *, 'missing argument for -l'
                stop
            end if
            i=i+1

            ! arg length first
            call get_command_argument(i, arg_val, arg_length, iostatus)
            if(iostatus>0) then
                print *, i, 'Cannot retrieve command line argument'
                call abort()
            end if
            allocate(character(len=arg_length) :: log_filepath)
            call get_command_argument(i, log_filepath, arg_length, iostatus)
            if(iostatus/=0) then
                print *, i, 'Cannot retrieve command line argument again'
                call abort()
            end if
        else
            if(arg_val(3:3)=='=') arg_val(3:3)=' '
            if(trim(arg_val(3:))/='') then
                allocate(character(len=len_trim(trim(adjustl(arg_val(3:))))) :: log_filepath)
                log_filepath=trim(adjustl(arg_val(3:)))
            end if
        end if
    else
        if(len_trim(shelx_filepath)>0) then
            print *, 'Error: an input file already read'
            stop
        end if
        shelx_filepath=arg_val
    end if
end do

if(len_trim(shelx_filepath)==0) then
    print *, 'Input file missing'
    stop
end if

if(allocated(log_filepath)) then
    if(trim(log_filepath)=='stdout') then
        log_unit=output_unit
    else
        log_unit=4521
        open(log_unit, file=log_filepath, status="replace")
    end if
else
    log_unit=4521
    open(log_unit, file="shelx2cry.log", status="replace")
end if

if(.not. allocated(crystals_filepath)) then
    allocate(character(len=len('crystalsinput.cry')) :: crystals_filepath)
    crystals_filepath='crystalsinput.cry'
end if

! check if the file exists
inquire(file=trim(shelx_filepath), exist=file_exists)
if(.not. file_exists) then
    ! File does not exist, trying when adding extension
    inquire(file=trim(shelx_filepath)//'.ins', exist=file_exists)
    if(.not. file_exists) then
        inquire(file=trim(shelx_filepath)//'.res', exist=file_exists)
        if(.not. file_exists) then
            inquire(file=trim(shelx_filepath)//'.cif', exist=file_exists)
            if(.not. file_exists) then
                write(*,'(a,a,a,a,a,a,a,a)') 'Cannot find `', trim(shelx_filepath), '`, `', &
                &   trim(shelx_filepath),'.ins`', ' or `', &
                &   trim(shelx_filepath),'.res`' 
                stop            
            else
                shelx_filepath=trim(shelx_filepath)//'.cif'
            end if
        else
            shelx_filepath=trim(shelx_filepath)//'.res'
        end if
    else
        shelx_filepath=trim(shelx_filepath)//'.ins'
    end if
end if

if(shelx_filepath(len_trim(shelx_filepath)-2:)=="cif") then
    Print *, 'Processing cif file ', trim(shelx_filepath)
    call scan_cif(trim(shelx_filepath), cif_content, error)
    if(error/=0) then
        print *, 'Error while reading the cif file'
        stop
    end if
    if(count(cif_content%resfile_no>0)==0) then
        print *, 'Error: No res file included in cif file'
        stop
    else if(count(cif_content%resfile_no>0)>1) then
        ! more then one file, extracting them all
        call extract_res_from_cif(trim(shelx_filepath))
        if(interactive_mode) then
            call ask_user(cif_content, i)
            res_file=shelx_filepath
            res_file(len_trim(res_file)-3:)='_'//trim(cif_content(i)%data_id)//'.res'
        else
            !print list of files and quit
            call print_content(cif_content)
            write(*, '(a)') 'Res file created:'
            do i=1, size(cif_content)
                if(cif_content(i)%resfile_no==1) then
                    buffer=shelx_filepath
                    buffer(len_trim(buffer)-3:)='_'//trim(cif_content(i)%data_id)//'.res'
                    write(*, '(1x,"- ", a)') trim(buffer)
                end if
            end do
            write(*, *) ''                    
            print *, 'Several res file found, re-run program on the newly created res files '
            print *, 'of your choice or use the interactive mode.'   
            stop
        end if
    else
        do i=1, size(cif_content)
            if(cif_content(i)%resfile_no==1) then
                res_file=shelx_filepath
                res_file(len_trim(res_file)-3:)='_'//trim(cif_content(i)%data_id)//'.res'
                exit
            end if
        end do
    end if
    shelx_filepath=trim(res_file)
end if

shelxf_id=816
open(unit=shelxf_id,file=trim(shelx_filepath), iostat=iostatus, status='old')
if(iostatus/=0) then
    print *, 'Error: Cannot open the file ', trim(shelx_filepath)
    stop
else
    print *, 'Processing res file ', trim(shelx_filepath)
    print *, ''
end if
iostatus=0
do while(iostatus==0)
    call readline(shelxf_id, line, iostatus)
    !print *, 'reading: ', line%line_number, iostatus, trim(line%line)
    call call_shelxprocess(line)
    if(the_end) exit
end do
close(shelxf_id)

open(crystals_fileunit, file=crystals_filepath)
call write_crystalfile(crystals_filepath)

if(hklf%code==5) then ! Cannot directly import hkl, it needs to go through hklf5tocry first
    info_table_index=info_table_index+1
    info_table(info_table_index)%text='Warning: Cannot process an hklf5 file here, use hklf5cry from within crystals'
else
    ! filename for hkl file given?
    if(trim(hkl_file)=='') then
        ! append hkl file processing if present with the same name as res file
        inquire(file=shelx_filepath(1:len_trim(shelx_filepath)-3)//'hkl', exist=file_exists)
        if(file_exists) then
            write(*, *) 'Processing hkl file header'
            call write_hkl(shelx_filepath(1:len_trim(shelx_filepath)-3)//'hkl')
        else
            info_table_index=info_table_index+1
            info_table(info_table_index)%text='Warning: Could not find the corresponding hkl file '// &
            &   shelx_filepath(1:len_trim(shelx_filepath)-3)//'hkl'
            info_table_index=info_table_index+1
            info_table(info_table_index)%text='         You will have to import it manually'
            
            if(any(abs(hklf%transform-matrix_eye(3))>1e-3)) then
                info_table_index=info_table_index+1
                info_table(info_table_index)%text='         A transformation matrix is present, '
                info_table_index=info_table_index+1
                info_table(info_table_index)%text='         do not forget to convert the hkl indices using:'
                do i=1, 3
                    info_table_index=info_table_index+1
                    write(info_table(info_table_index)%text, '(9X, "|",3(F8.3,1X),"|")') hklf%transform(i,:)
                end do
            end if
            
        end if
    else
        ! append hkl file processing if present with the same name as res file
        inquire(file=trim(hkl_file), exist=file_exists)
        if(file_exists) then
            write(*, *) 'Processing hkl file header'
            call write_hkl(trim(hkl_file))
        else
            info_table_index=info_table_index+1
            info_table(info_table_index)%text='Warning: Could not find the hkl file given: '//trim(hkl_file)
        end if
    end if
end if

close(crystals_fileunit)

! print out saved warnings
write(log_unit, '(a)') ''
if(summary%error_no>0) then
    if(allocated(log_filepath)) then
        write(log_unit, '(I0, 1X, a)') summary%error_no, 'Error(s) found during conversion, please check the log file'
    else
        write(log_unit, '(I0, 1X, a)') summary%error_no, 'Error(s) found during conversion, please check the output'
    end if
    write(log_unit, *) ''
end if

if(shelx_unsupported_list_index>0) then
    write(*,*) ''
    write(*, '(a)') 'List of ignored shexl commands:'
    do i=1, shelx_unsupported_list_index
        write(*, '(4X, a,": ", I0,1X,a)') shelx_unsupported_list(i)%tag, shelx_unsupported_list(i)%num, 'time(s)'
    end do
    write(*,*) ''
end if

if(info_table_index>0) then
    do i=1, info_table_index
        if(log_unit==4521) then
            write(*, '(a, a)') '## ', trim(info_table(i)%text)
        end if
        write(log_unit, '(a, a)') '## ', trim(info_table(i)%text)
    end do
end if

print *, ''
print *, 'All done.'

end program
