program shelx2cry
use shelx2cry_mod
implicit none
integer arg_cpt, iostatus, arg_length, shelxf_id, line_number
character(len=:), allocatable :: shelx_filepath, line
logical file_exists

! Default length
allocate(character(len=1) :: shelx_filepath)

arg_cpt=command_argument_count()
if( arg_cpt/=1) then
    print *, "Wrong number of arguments expected"
    stop
end if

! Get the argument length first
call get_command_argument(1, shelx_filepath, arg_length, iostatus)
if(iostatus>0) then
    print *, 'Cannot retrieve command line argument'
    call abort()
end if

! allocated path with correct length (+4 for extension of needed)
deallocate(shelx_filepath)
allocate(character(len=arg_length+4) :: shelx_filepath)
call get_command_argument(1, shelx_filepath, arg_length, iostatus)
if(iostatus/=0) then
    print *, 'Cannot retrieve command line argument again'
    call abort()
end if

! check if the file exists
inquire(file=trim(shelx_filepath), exist=file_exists)
if(.not. file_exists) then
    ! File does not exist, trying when adding extension
    inquire(file=trim(shelx_filepath)//'.ins', exist=file_exists)
    if(.not. file_exists) then
        inquire(file=trim(shelx_filepath)//'.res', exist=file_exists)
        if(.not. file_exists) then
            print *, 'Cannot find `', trim(shelx_filepath), '`, `', &
            &   trim(shelx_filepath)//'.ins`', ' or `', &
            &   trim(shelx_filepath)//'.res`' 
            stop            
        else
            shelx_filepath=trim(shelx_filepath)//'.res'
        end if
    else
        shelx_filepath=trim(shelx_filepath)//'.ins'
    end if
end if

open(newunit=shelxf_id,file=trim(shelx_filepath), status='old')
iostatus=0
do while(iostatus==0)
    call readline(shelxf_id, line, line_number, iostatus)
    !print *, line_number, iostatus, trim(line)
    call call_shelxprocess(line)
    if(the_end) exit
end do

call write_crystalfile()





end program
