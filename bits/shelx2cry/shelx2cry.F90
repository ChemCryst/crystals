!> This program convert a shelxl ins or res file to a crystals file
!! 
!! Usage: shelx2cry filename
program shelx2cry
use shelx2cry_mod
use crystal_data_m
use, intrinsic :: iso_fortran_env, only : output_unit
implicit none

integer arg_cpt, iostatus, arg_length
integer shelxf_id !< unit id of the shelx file
character(len=:), allocatable :: shelx_filepath, arg_val, crystals_filepath, log_filepath
type(line_t) :: line
logical file_exists, foundres
integer i

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
    allocate(character(len=max(6, 20)) :: arg_val)
    call get_command_argument(i, arg_val, arg_length, iostatus)
    if(iostatus/=0) then
        print *, i, 'Cannot retrieve command line argument again'
        call abort()
    end if
    
    if(arg_val(1:6)=='--help' .or. arg_val(1:2)=='-h') then
        print *, 'shelx2cry: Conversion utility from shelxl files to crystals'
        print *, ''
        print *, 'Usage : shelx2cry [-o file] [-l log] file'
        print *, ''
        print *, 'List of options:'
        print *, '--help, -h This help'
        print *, '-o output file for crystals [default: crystalsinput.dat]'
        print *, '-l log file [default: stdout]'
        print *, ''
        stop
    
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
            
            print *, 'Log output file: ', log_filepath
        else
            if(arg_val(3:3)=='=') arg_val(3:3)=' '
            if(trim(arg_val(3:))/='') then
                allocate(character(len=len_trim(trim(adjustl(arg_val(3:))))) :: log_filepath)
                log_filepath=trim(adjustl(arg_val(3:)))
                print *, 'Log output file: ', log_filepath
            end if
        end if
    else
        if(allocated(shelx_filepath)) then
            print *, 'Error: an input file already read'
            stop
        end if
        allocate(character(len=arg_length+4+4) :: shelx_filepath)
        shelx_filepath=repeat(' ', arg_length+4+4)
        shelx_filepath(1:arg_length)=arg_val
    end if
end do

if(.not. allocated(shelx_filepath)) then
    ! dummy allocate to suppress gfortran warning
    allocate(character(len=0) :: shelx_filepath)
    print *, 'Input file missing'
    stop
end if

if(allocated(log_filepath)) then
    log_unit=4521
    open(log_unit, file=log_filepath, status="replace")
else
    log_unit=output_unit
end if

if(.not. allocated(crystals_filepath)) then
    allocate(character(len=len('crystalsinput.dat')) :: crystals_filepath)
    crystals_filepath='crystalsinput.dat'
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
                write(log_unit,'(a,a,a,a,a,a,a,a)') 'Cannot find `', trim(shelx_filepath), '`, `', &
                &   trim(shelx_filepath),'.ins`', ' or `', &
                &   trim(shelx_filepath),'.res`' 
                stop            
            else
                call extract_res_from_cif(trim(shelx_filepath)//'.cif', foundres)
                if(.not. foundres) then
                    write(log_unit,*) 'Error: No res file included in cif file'
                    stop
                end if
                shelx_filepath=trim(shelx_filepath)//'1.res'
            end if
        else
            shelx_filepath=trim(shelx_filepath)//'1.res'
        end if
    else
        shelx_filepath=trim(shelx_filepath)//'1.ins'
    end if
end if

if(shelx_filepath(len_trim(shelx_filepath)-2:)=="cif") then
    call extract_res_from_cif(trim(shelx_filepath), foundres)
    if(.not. foundres) then
        write(log_unit,*)'Error: No res file included in cif file'
        stop
    end if
    shelx_filepath(len_trim(shelx_filepath)-3:)='1.res'
end if

shelxf_id=816
open(unit=shelxf_id,file=trim(shelx_filepath), status='old')
iostatus=0
do while(iostatus==0)
    call readline(shelxf_id, line, iostatus)
    !print *, 'reading: ', line%line_number, iostatus, trim(line%line)
    call call_shelxprocess(line)
    if(the_end) exit
end do
close(shelxf_id)

call write_crystalfile(crystals_filepath)


end program
