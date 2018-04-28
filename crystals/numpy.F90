!> module dealing with the export of data to numpy in python
module numpy_mod

contains

!> write the output of an array to a numpy npy file
subroutine numpy_write_header(npyunit, datashape, header_size, order, npyformat)
use iso_c_binding, only: c_short
implicit none
integer, dimension(:), intent(in) :: datashape !< shape of the original array datas
integer, intent(in) :: npyunit !< unit of the file to write
character, intent(in) :: order !< order covention (F=Fortran or column by column, C=C or rows by rows)
integer, intent(in) :: header_size !< size of header, multiple of 16
character(len=*), intent(in) :: npyformat !< format of the data. '<f4' is single precision, '<f8' is double precision

character(len=6), parameter :: magic=char(147)//'NUMPY' ! npy magic constant
character(len=:), allocatable :: formatstr ! len(formatstr)+len(major,minor)+len(magic) multiple of 16
character(len=128) :: formatshape
character, parameter :: major=char(1) !< npy major version
character, parameter :: minor=char(0) !< npy minor version
integer(c_short) :: c_hsize !< Size of the header. size must be lower than 37767
character(len=5) :: order_bool

    if(mod(header_size, 16)/=0 .or. header_size>37767) then
#if defined(CRY_OSLINUX)
        print *, 'numpy header size must be a multiple of 16 and lower than 37767'
#endif
        call abort()
    end if
    c_hsize=header_size-10 ! 10 is the size of magic+major+minor+header_size
    allocate(character(len=c_hsize) :: formatstr)
    
    if(order=='F') then
        order_bool='True'
    else
        order_bool='False'
    end if

    write(formatshape, '(15(I0,:,","))') datashape
    formatshape="("//trim(formatshape)//")"

    write(npyunit, pos=1) magic, major, minor
    write(npyunit) c_hsize 
    write(formatstr, '(a,a,a,a,a,a,a,a)') "{'descr': '",npyformat, &
    &   "', 'fortran_order': ",&
    &   trim(order_bool),", 'shape': ", &
    &   trim(formatshape),", }", char(12)
    write(npyunit) formatstr

end subroutine

!> write the output of an array to a numpy npy file
subroutine numpy_save(npyname, datas, datashape, orderarg)
use iso_c_binding, only: c_short
implicit none
real, dimension(*), intent(in) :: datas !< data to write to disk
integer, dimension(:), intent(in) :: datashape !< shape of the original array datas
character(len=*), intent(in) :: npyname !< name of the file to write
character, optional, intent(in) :: orderarg !< order covention (F=Fortran or column by column, C=C or rows by rows)

character(len=6), parameter :: magic=char(147)//'NUMPY' ! npy magic constant
character(len=118) :: formatstr ! len(formatstr)+len(major,minor)+len(magic) multiple of 16
character(len=128) :: formatshape
integer, parameter :: npyunit=874
character, parameter :: major=char(1) ! npy major version
character, parameter :: minor=char(0) ! npy minor version
integer(c_short) :: header_size = len(formatstr) ! size must be lower than 37767
character(len=5) :: order !< order covention (F=Fortran or column by column, C=C or rows by rows)

    if(present(orderarg)) then
        if(orderarg=='F') then
            order='True'
        else
            order='False'
        end if
    else
        order='True'
    end if

    write(formatshape, '(15(I0,:,","))') datashape
    formatshape="("//trim(formatshape)//")"

    open(npyunit, file=trim(npyname), access='stream', form='unformatted')
    write(npyunit) magic, major, minor
    write(npyunit) header_size
    write(formatstr, '(a,a,a,a,a,a)') "{'descr': '<f4', 'fortran_order': ",&
    &   trim(order),", 'shape': ", &
    &   trim(formatshape),", }", char(12)
    write(npyunit) formatstr
    write(npyunit) datas(1:product(datashape))
    close(npyunit)

end subroutine

!> read numpy header of an opened file and leave the position at the begining of the data
subroutine numpy_read_header(npyunit, order, datashape, npyformat)
use iso_c_binding, only: c_short
implicit none
integer, intent(in) :: npyunit !< unit number of the file to operate on
character, intent(out) :: order !< order covention (F=Fortran or column by column, C=C or rows by rows)
integer, dimension(:), allocatable, intent(out) :: datashape !< shape of the array stored
integer, intent(out) :: npyformat !< format number, only 2 supported for now: single and double precision
character(len=6), parameter :: magicnpy=char(147)//'NUMPY' ! npy magic constant
character(len=6) :: magic
character(len=:), allocatable :: formatstr ! len(formatstr)+len(major,minor)+len(magic) multiple of 16
character(len=128) :: formatshape, ctemp
character :: major !< npy major version
character :: minor !< npy minor version
integer(c_short) :: header_size 
integer n,m, i

read(npyunit, pos=1) magic, major, minor, header_size

if(magic/=magicnpy) then
    print *, 'This is not a numpy file'
    call abort()
end if

allocate(character(len=header_size) :: formatstr)
read(npyunit) formatstr

! extract the shape
n=index(formatstr, 'shape')
ctemp=formatstr(n+7:len(formatstr))
n=index(ctemp, '(')
m=index(ctemp, ')')
ctemp=ctemp(n+1:m-1)
! count number of ","
n = count(transfer(ctemp, 'a', len(ctemp)) == ",") 
allocate(datashape(n+1))
read(ctemp, *) datashape

! extract the order
n=index(formatstr, 'fortran_order')
ctemp=formatstr(n+15:len(formatstr))
n=index(ctemp, ',')
ctemp(n:len(ctemp))=repeat(' ', len(ctemp)-n)
n=index(ctemp, 'True')
if(n>0) then
    order='F'
else
    order='C'
end if

! extract the format
npyformat=-1
n=index(formatstr, 'descr')
ctemp=formatstr(n+7:len(formatstr))
n=index(ctemp, ',')
ctemp(n:len(ctemp))=repeat(' ', len(ctemp)-n)
n=index(ctemp, 'f4')
if(n>0) then
    npyformat=4
end if
n=index(ctemp, 'f8')
if(n>0) then
    npyformat=8
end if

end subroutine

end module
