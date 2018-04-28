!> Module replacing the use of environment variables to pass values from 
!! C++ to fortran
!! On recent intel and gfortran it uses dynamic allocated character length (f2003 feature)
module global_vars_mod
#if !defined(CRY_FORTDIGITAL)
use iso_c_binding
#endif
logical, parameter, private :: debug = .false.

!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )
type, private :: t_env_table
    character(len=:), allocatable :: key
    character(len=:), allocatable :: valeur
end type
#else
type, private :: t_env_table
    character(len=2048) :: key
    character(len=2048) :: valeur
end type
#endif

type(t_env_table), dimension(:), allocatable, private :: environment_table

contains

!> Add or replace an element in the dictionary
subroutine env_table_add(key, valeur) 
    use c_strings_mod
    implicit none
    character(len=*) :: key, valeur
    type(t_env_table), dimension(size(environment_table)) :: temp
!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )
    character(len=:), allocatable :: valuetemp
#else
    character(len=2048) :: valuetemp
#endif
    integer error, i
    
    call env_table_get(key, valuetemp, error)
    if(error >0) then
        ! we found the same key, update key with new value
!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )
        deallocate(environment_table(error)%valeur)
        allocate(environment_table(error)%valeur, source=valeur)
        environment_table(error)%valeur=valeur
#else
        if(len_trim(valeur)>len(environment_table(error)%valeur)) then
 !           print *, 'Value too large to be hold in environment_table'
 !           print *, 'Contact the authors'
            call exit(1)
        else
            environment_table(error)%valeur=valeur
        end if
#endif

        if(debug) then
            print *, 'Replacing key/val: ', trim(key), '/', trim(valeur)
        end if
    else
        if(debug) then
            print *, 'Inserting key/val: ', trim(key), '/', trim(valeur)
        end if

        ! insert new key
        if(allocated(environment_table)) then
            temp=environment_table
            deallocate(environment_table)
            allocate(environment_table(size(temp)+1))
!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )            
            environment_table(1:size(temp))=temp
            allocate(environment_table(size(temp)+1)%key, source=key)
            allocate(environment_table(size(temp)+1)%valeur, source=valeur)
#else
            environment_table(1:size(temp))=temp
            environment_table(size(temp)+1)%key=key
            environment_table(size(temp)+1)%valeur=valeur
#endif
        else
            allocate(environment_table(1))
!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )            
            allocate(environment_table(1)%key, source=key)
            allocate(environment_table(1)%valeur, source=valeur)
#else
            environment_table(1)%key=key
            environment_table(1)%valeur=valeur
#endif
        end if
    end if
    
end subroutine

!> Add or replace an element in a dictionary (function called from C)
#if defined(CRY_FORTDIGITAL)
subroutine env_table_add_c(c_key, c_value) 
!dec$ attributes c :: env_table_add_c
    use c_strings_mod
    implicit none
    character (len=1), dimension (*), intent (in) :: c_key, c_value
    !dec$ attributes reference :: c_key
    !dec$ attributes reference :: c_value
#else
subroutine env_table_add_c(c_key, c_value) bind(c)
    use c_strings_mod
    implicit none
    character (kind=c_char, len=1), dimension (*), intent (in) :: c_key, c_value
#endif

!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )    
    character(len=:), allocatable :: key, valeur
#else
    character(len=2048) :: key, valeur
#endif

    call c_f_strings(c_key, key)
    call c_f_strings(c_value, valeur)

    call env_table_add(key, valeur)

end subroutine

!> Look for a value in the dictionary given a key
subroutine env_table_get(key, valeur, error)
    implicit none
    character(len=*), intent(in) :: key
!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )    
    character(len=:), allocatable, intent(out) :: valeur
#else
    character(len=2048), intent(out) :: valeur
#endif
    integer, intent(out) :: error
    integer i,lengthval,lengthkey
    
    error = 0
    
    if(.not. allocated(environment_table)) then
        error = -1
        return
    end if
    
    do i=1, size(environment_table)
        if(environment_table(i)%key==key) then
!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )    
            !allocate(valeur, source=environment_table(i)%valeur)
            allocate(character(len=len(environment_table(i)%valeur)) ::valeur)
            valeur=environment_table(i)%valeur
#else
            valeur=environment_table(i)%valeur
#endif
            error=i
            if(debug) then
                print *, 'Found in environment_table key `', trim(key), '` value `', trim(valeur), '` at ', i
                print *, 'size of key/value: ', len(environment_table(i)%key), '/', len(environment_table(i)%valeur)
            end if
            return
        end if
    end do
    
    ! key not found
    error = -1
end subroutine

!> Look for a value in the dictionary given a key (function called from C)
#if defined(CRY_FORTDIGITAL)
subroutine env_table_get_c(c_key, c_value, c_error) 
!dec$ attributes c :: env_table_get_c
    use c_strings_mod
    implicit none
    character (len=1), dimension (*), intent (in) :: c_key
    !dec$ attributes reference :: c_key
    character (len=1), dimension (*), intent (out) :: c_value
    !dec$ attributes reference :: c_value
    integer, intent(out) :: c_error
    !dec$ attributes reference :: c_error
#else
subroutine env_table_get_c(c_key, c_value, c_error) bind(c)
    use ISO_C_BINDING
    use c_strings_mod
    implicit none
    character (kind=c_char, len=1), dimension (*), intent (in) :: c_key
    character (kind=c_char, len=1), dimension (*), intent (out) :: c_value
    integer(kind=c_int), intent(out) :: c_error
#endif

!/* Test for GCC >= 4.7 or intel >= 14 */
#if __GNUC__ > 4 || \
    (__GNUC__ == 4 && (__GNUC_MINOR__ > 6)) || \
    (__INTEL_COMPILER > 1399 )    
    character(len=:), allocatable :: key, valeur
#else
    character(len=2048) :: key, valeur
#endif
    integer error

    call c_f_strings(c_key, key)
    call c_f_strings(c_value, valeur)

    call env_table_get(key, valeur, error)
    c_error=error

end subroutine

end module
