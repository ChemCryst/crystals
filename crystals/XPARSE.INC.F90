module xparse_mod

type, public :: ksv_type
    character(len=4) :: kname
    integer, dimension(:), allocatable :: kshape
    integer :: address
end type

type(ksv_type), dimension(20) :: ksv_new

contains

subroutine ksv_init()
implicit none

ksv_new( 1)%kname='A'
allocate(ksv_new( 1)%kshape(1))
ksv_new( 1)%kshape=(/6/)
ksv_new( 2)%kname='CV'
allocate(ksv_new( 2)%kshape(1))
ksv_new( 2)%kshape=(/1/)
ksv_new( 3)%kname='AR'
allocate(ksv_new( 3)%kshape(1))
ksv_new( 3)%kshape=(/6/)
ksv_new( 4)%kname='RCV'
allocate(ksv_new( 4)%kshape(1))
ksv_new( 4)%kshape=(/1/)
ksv_new( 5)%kname='G'
allocate(ksv_new( 5)%kshape(2))
ksv_new( 5)%kshape=(/3,3/)
ksv_new( 6)%kname='GR'
allocate(ksv_new( 6)%kshape(2))
ksv_new( 6)%kshape=(/3,3/)
ksv_new( 7)%kname='L'
allocate(ksv_new( 7)%kshape(2))
ksv_new( 7)%kshape=(/3,3/)
ksv_new( 8)%kname='LR'
allocate(ksv_new( 8)%kshape(2))
ksv_new( 8)%kshape=(/3,3/)
ksv_new( 9)%kname='CONV'
allocate(ksv_new( 9)%kshape(1))
ksv_new( 9)%kshape=(/3/)
ksv_new(10)%kname='RIJ'
allocate(ksv_new(10)%kshape(1))
ksv_new(10)%kshape=(/6/)
ksv_new(11)%kname='ANIS'
allocate(ksv_new(11)%kshape(1))
ksv_new(11)%kshape=(/6/)
ksv_new(12)%kname='SM'
allocate(ksv_new(12)%kshape(3))
ksv_new(12)%kshape=(/3,4,96/)
ksv_new(13)%kname='SMI'
allocate(ksv_new(13)%kshape(3))
ksv_new(13)%kshape=(/3,4,96/)
ksv_new(14)%kname='NPLT'
allocate(ksv_new(14)%kshape(2))
ksv_new(14)%kshape=(/3,4/)
ksv_new(15)%kname='PI'
allocate(ksv_new(15)%kshape(1))
ksv_new(15)%kshape=(/1/)
ksv_new(16)%kname='TPI'
allocate(ksv_new(16)%kshape(1))
ksv_new(16)%kshape=(/1/)
ksv_new(17)%kname='TPIS'
allocate(ksv_new(17)%kshape(1))
ksv_new(17)%kshape=(/1/)
ksv_new(18)%kname='DTR'
allocate(ksv_new(18)%kshape(1))
ksv_new(18)%kshape=(/1/)
ksv_new(19)%kname='RTD'
allocate(ksv_new(19)%kshape(1))
ksv_new(19)%kshape=(/1/)
ksv_new(20)%kname='ZERO'
allocate(ksv_new(20)%kshape(1))
ksv_new(20)%kshape=(/1/)

end subroutine

end module
