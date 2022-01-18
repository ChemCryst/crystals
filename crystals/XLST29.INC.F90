module xlst29_mod
  implicit none

  INTEGER L29, M29, MD29, N29, L29V, M29V, MD29V, N29V
  COMMON/XLST29/L29,M29,MD29,N29, L29V,M29V,MD29V,N29V 

!!
! The module procedures below take a normal L29 in loaded in STORE and 
! produce a copy with similar structure on the heap. To begin with it's 
! cannot be directly written back to store, but feel free to add this 
! functionality.
!    .TYPE               0    0    1    0    0 NULL
!    .COVALENT           0    0    1    0    0 0.8
!    .VANDERWAALS        0    0    1    0    0 1.5
!    .IONIC              0    0    1    0    0 0.6
!    .NUMBER             0    0    1    0    0 0
!    .MUA                0    0    1    0    0 0
!    .WEIGHT             0    0    1    0    0 0
!    .COLOUR             0    0    1    0    0 UNKNOWN
!!

  type atomprops_t
    character(len=4) :: label   
    real :: covalent
    real :: vanderwaals
    real :: ionic
    real :: number  ! number of atoms of this type in cell
    real :: mua     
    real :: weight
    character(len=4) :: colour 
  end type

  type(atomprops_t), dimension(:), allocatable :: atom_properties !< List of atom properties
  private append_atomprop

  interface l29_find 
    module procedure l29_findc, l29_findi 
  end interface l29_find

contains
 
!> extend an array of derivatives type
  subroutine append_atomprop(prop)
    implicit none
    type(atomprops_t), allocatable :: prop
    type(atomprops_t), dimension(:), allocatable :: temp

    if (allocated(atom_properties)) then
      call move_alloc(atom_properties, temp)
      allocate (atom_properties(size(temp)+1))  ! allocate bigger array
      atom_properties(1:size(temp)) = temp
      atom_properties(size(temp)+1:) = prop
    else
      allocate (atom_properties(1))
      atom_properties(1:) = prop
    end if

  end subroutine

!> initialize from a L29 in store
  subroutine l29_init()
    use store_mod, only: store, istore => i_store, c_store
    implicit none
    type(atomprops_t), allocatable :: prop

! TODO Check list is loaded
    if (l29 <= 0) return


    if (allocated(atom_properties)) then
      deallocate(atom_properties)
    end if 

!!    character(len=4) :: label   
!!    real :: covalent
!!    real :: vanderwaals
!!    real :: ionic
!!    real :: number  ! number of atoms of this type in cell
!!    real :: mua     
!!    real :: weight
!!    character(len=4) :: colour 

    
    do m29 = l29, l29 + ( (n29-1) * md29 ), md29
      allocate(prop)
      prop%label = c_store(m29)
      prop%covalent = store(m29+1)
      prop%vanderwaals = store(m29+2)
      prop%ionic = store(m29+3)
      prop%number = store(m29+4)
      prop%mua = store(m29+5)
      prop%weight = store(m29+6)
      prop%colour = c_store(m29+7)      
      call append_atomprop(prop)
      deallocate(prop)
    end do

  end subroutine


  subroutine l29_display()
    use xiobuf_mod, only: cmon
    use xunits_mod, only: ncvdu, ncwu
    implicit none
    integer :: i
    type(atomprops_t) :: prop
    
    if ( .not. allocated(atom_properties) ) then 
      write (cmon, '(4X, A)') '{W No atom properties loaded'
      call xprvdu(NCVDU,1,0)
      return
    end if

    do i = 1, size(atom_properties)
      associate (a=>atom_properties(i))
        write (cmon, '(A,6F7.2,A)') a%label, a%covalent, a%vanderwaals, a%ionic, &
        &   a%number, a%mua, a%weight, a%colour
        call xprvdu(NCVDU,1,0) 
      end associate
    end do
  end subroutine  

  integer function l29_findi(ilabel, atomprop)
    implicit none
    integer, intent(in) :: ilabel
    character(len=4) :: clabel
    type(atomprops_t) atomprop
    clabel = transfer(ilabel, 'aaaa')
    l29_findi = l29_findc(clabel,atomprop)
    return
  end function
    


  integer function l29_findc(clabel, atomprop)
    use xiobuf_mod, only: cmon
    use xunits_mod, only: ncvdu, ncwu
    implicit none
    interface
      Pure Function to_upper (str) Result (string)
      Character(*), Intent(In) :: str
      Character(LEN(str))      :: string
      end function
    end interface
    
    character(len=4), intent(in) :: clabel
    character(len=4) :: uclabel
    type(atomprops_t) atomprop
    integer :: i
    
    l29_findc = 0
    
    uclabel = to_upper(clabel)

    if ( .not. allocated(atom_properties) ) then 
      write (cmon, '(4X, A)') '{W No atom properties loaded'
      call xprvdu(NCVDU,1,0)
      return
        end if

    do i = 1, size(atom_properties)
      associate (a=>atom_properties(i))
        if ( a%label == clabel ) then
          atomprop = a
          l29_findc = i 
          return
        end if
      end associate
    end do
  end function 



end module
