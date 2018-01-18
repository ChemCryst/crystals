!> Generic module dealings with strings between C and fortran
!! 
module c_strings_mod
interface
    ! steal std c library function rather than writing our own.
#if defined(CRY_FORTDIGITAL)
    function strlen(s) 
    !dec$ attributes c :: strlen
        implicit none
        character (len=1), dimension (*), intent(in) :: s
        !dec$ attributes reference :: s
        integer :: strlen
        !dec$ attributes reference :: strlen
        !----
    end function strlen
#else    
    function strlen(s) bind(c, name='strlen')
        use, intrinsic :: iso_c_binding, only: c_size_t, c_char
        implicit none
        character (kind=c_char, len=1), dimension (*), intent(in) :: s
        integer(c_size_t) :: strlen
        !----
    end function strlen
#endif
end interface

logical, private, parameter :: debug = .false.

contains

!> Convert a C string into a fortran character type
subroutine c_f_strings ( input_string, regular_string ) 
#if defined(CRY_FORTDIGITAL)
    implicit none  
    character (len=1), dimension (*), intent (in) :: input_string
    !dec$ attributes reference :: input_string
    character, parameter :: c_null_char = char(0)
#else
    use iso_c_binding, only: C_CHAR, c_null_char
    implicit none  
    character (kind=c_char, len=1), dimension (*), intent (in) :: input_string
#endif
    
!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )
    character(len=:), allocatable, intent(out) :: regular_string
#else
    character(len=2048), intent(out) :: regular_string
#endif
    integer :: i, lenstr

    lenstr=strlen(input_string)
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )
    if(allocated(regular_string)) deallocate(regular_string)
    allocate(character(len=lenstr) :: regular_string)
#else
    if(lenstr>2048) then
!        print *, 'Error: input_string is too long for the harcoded string'
!        print *, 'Contact the authors'
        call abort()
    end if
#endif
   
    do i=1,lenstr 
        if ( input_string (i) == c_null_char ) then
            exit 
        else
            regular_string (i:i) = input_string (i)
        end if
    end do 
    
    if(debug) then
        print *, "converted from C: ", regular_string, '(', len(regular_string),')'
    end if

end subroutine 

end module c_strings_mod
