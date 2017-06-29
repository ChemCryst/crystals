program fixh5
implicit none
character(len=512) :: filename
character :: c
integer ios, i, j, file_size
character(len=512) :: buff
character(len=2), parameter :: pstart='(/', pend='/)'
character(len=2), parameter :: pstartb='{', pendb='}'
logical inpattern
character(len=2048) :: buffer

call get_command_argument(1, filename)

! making a backup
inquire (file=filename, size=file_size)
open(unit=123, file=filename, access='direct', status='old', &
&   action='read', iostat=ios, recl=len(buffer))
! record for writting is 1 to ensure identical copy
open(unit=124, file=trim(filename)//'.old', access='direct', &
&   status='replace', action='write', iostat=ios, recl=1)
i = 1
do
    read(unit=123, rec=i, iostat=ios) buffer
    if (ios/=0) exit
    do j=(i-1)*len(buffer)+1, min(file_size, i*len(buffer))
        write(unit=124, rec=j) buffer(j-(i-1)*len(buffer):j-(i-1)*len(buffer))
    end do
    i = i + 1
end do
close(123)
close(124)
        
open(123, file=trim(filename)//'.old', status='old', form='unformatted', access='direct', recl=1)
open(124, file=trim(filename), status='replace', form='unformatted', access='direct', recl=1)

i=0
j=0
inpattern=.false.
do
    i=i+1
    read(123, rec=i, iostat=ios) c
    if(ios/=0) exit
    
    if(c==pstart(1:1)) then
        j=j+1
        write(124, rec=j) c
        i=i+1
        read(123, rec=i, iostat=ios) c
        if(ios/=0) exit
        if(c==pstart(2:2)) then
            inpattern=.true.
        end if
    end if

    if(c==pend(1:1)) then
        j=j+1
        write(124, rec=j) c
        i=i+1
        read(123, rec=i, iostat=ios) c
        if(ios/=0) exit
        if(c==pend(2:2)) then
            inpattern=.false.
        end if
    end if

    if(c==pstartb(1:1)) then
        inpattern=.true.
    end if

    if(c==pendb(1:1)) then
        inpattern=.false.
    end if
    
    if(c==char(10) .or. c==char(13)) then
        if(inpattern) then
            cycle
        end if
    end if
    
    j=j+1
    write(124, rec=j) c
end do

close(123)
close(124)


end program

