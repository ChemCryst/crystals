!> Derived type dealing with Sort and insert of values
!! Used to store the worst reflections during the refinement
module sort_mod

type sort_type
    !> Array use for the sorted data
    real, dimension(:,:), allocatable :: array
    !> Data to insert into array
    real, dimension(:), allocatable :: insert
    !> offset in record of item to be sorted (i.e. column number in array)
    integer ipos
    !> Type of sorting: 
    !! - -1 smallest to largest
    !! -  0 absolute largest to smallest
    !! -  1 largest to smallest
    integer itype
end type

contains

!> Initialization for sorting
subroutine sort_type2init(this, ipos, itype, initsize)
implicit none
type(sort_type), intent(out) :: this
!> offset in record of item to be sorted (i.e. column number in array)
integer, intent(in) :: ipos
!> Type of sorting: 
!! - -1 smallest to largest
!! -  0 absolute largest to smallest
!! -  1 largest to smallest
integer, intent(in) :: itype
!> Initialization size of the array
integer, dimension(2), intent(in) :: initsize

allocate(this%array(initsize(1), initsize(2)))
allocate(this%insert(initsize(1)))
this%ipos=ipos
this%itype=itype
this%array=0.0
if (this%itype < 0) then
    this%array(this%ipos, :) = huge(this%array(1,1))
else if (this%itype > 0) then
    this%array(this%ipos, :) = -huge(this%array(1,1))
endif

end subroutine 

!> Store the occurences of a record containing the smallest or largest occurences of an item
!! Initialization must be done before use.
subroutine sort_type2insert_sort(this)
implicit none
type(sort_type), intent(inout) :: this
integer i, nsort
logical ihit

if(.not. allocated(this%array)) then
    print *, 'Programmer error'
    print *, 'Initialization must be done before using mod_sort::insert_sort'
    stop
end if

nsort=ubound(this%array,2)

!----- insertion
ihit = .false.
do i = 1, nsort
    if (this%itype < 0) then
        if (this%insert(this%ipos) <= this%array(this%ipos, i)) ihit = .true.
    else if (this%itype > 0) then
        if (this%insert(this%ipos) >= this%array(this%ipos,i)) ihit = .true.
    else
        if (abs(this%insert(this%ipos)) >= abs(this%array(this%ipos, i))) ihit = .true.
    endif
    
    if (ihit) then
        ihit = .false.
!-----    pushed remainder down
        this%array(:,i+1:nsort)=this%array(:,i:nsort-1)
        this%array(:,i)=this%insert
        return
    endif
  end do 
end subroutine

end module
