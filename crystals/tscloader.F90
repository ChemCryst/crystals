! Module for loading tsc 
!
! int load(filename) - reads filename (tsc file) into hash array
!   0: success
!  -1: file not found
!  -2: file invalid
!  -3: other error
!
! void reset() - clears array
!
! int getcsf( h,k,l,atom, &a, &b ) - gets complex scattering factor
!  hkl: indices
! atom: name of atom format: 'N2'
! a and b: complex scattering factor  
!  -1: hkl data point missing
!  -2: no data loaded
!

module aspher_scatt_hash
  use iso_fortran_env
  implicit none

  type, public :: hkla_type
     integer :: h
     integer :: k
     integer :: l
     character(len=8) :: atom
  end type hkla_type

  type, public :: ab_type
     real :: a
     real :: b
	 contains
	   procedure ab_unequal
	   generic :: operator(/=) => ab_unequal
	   procedure ab_equal
	   generic :: operator(==) => ab_equal
  end type ab_type

#define FFH_KEY_TYPE type(hkla_type)
#define FFH_CUSTOM_KEYS_EQUAL
#define FFH_VAL_TYPE type(ab_type)
#include "ffhash_inc.f90"

  logical function ab_unequal(lhs,rhs)
     class(ab_type), intent(in) :: lhs, rhs
	 ab_unequal = ( lhs%a /= rhs%a ) .or. ( lhs%b /= rhs%b )
  end function ab_unequal
  logical function ab_equal(lhs,rhs)
     class(ab_type), intent(in) :: lhs, rhs
	 ab_equal = .not. ab_unequal(lhs,rhs)
  end function ab_equal

  pure logical function keys_equal(a, b)
    type(hkla_type), intent(in) :: a, b
    keys_equal = (a%h == b%h) .and. ( a%k == b%k ) .and. ( a%l == b%l ) .and. (a%atom == b%atom)
  end function keys_equal

end module aspher_scatt_hash


module aspher_scatterers

  use iso_fortran_env, dp => real64
  use aspher_scatt_hash

  implicit none

  character(len=8), allocatable :: atom_labels (:)
  integer :: tsc_error_count
  integer :: tsc_store_fc     ! 0 for FC, 1 for FC(ASPH) - FC(IAM)


  type, public :: tscstorage
	type(ffh_t) :: hkldict
	contains
	  
	      procedure, pass :: sethkl => data_sethkl
	      procedure, pass :: clear => data_clear
	      procedure, pass :: load => data_load
	      procedure, pass :: gethkl => data_gethkl
	end type		  
  
  contains

	  integer function data_load(self,filename)
!   0: success
!  -1: file not found
!  -2: file invalid
!  -3: other error
		class(tscstorage), intent(inout) :: self
		character(len=*), intent(in) :: filename
		integer :: io
		tsc_error_count = 0
		open(131, file=filename, iostat=io)

		if ( io /= 0 ) then
			data_load = -1 
        else
            io = data_clear(self)               ! Remove any previous data
			data_load = data_read(self)    ! Do reading in helper function so we can ensure we close the file.
		end if

		close (131)

	  end function

	  integer function data_read(self)
		class(tscstorage), intent(inout) :: self
		character(len=8),allocatable :: sclabels(:)
		character(len=8) ctemp
		real, allocatable :: sfs(:,:)
		integer :: i, j, io, nscatt, h, k, l
		logical :: header
		logical :: inlab
		character(len=4096) :: line
		
		header = .false.
		nscatt = 0

		do
			read(131, '(A)', iostat = io, end = 90) line
            			
			if ( io /= 0 ) then
				if ( nscatt == 0 ) then
					data_read = -2   ! file format invalid (SCATTERERS not found)
                else 
                    if ( allocated (sfs) ) deallocate(sfs)
                    if ( allocated (sclabels) ) deallocate(sclabels)
					data_read = -3   ! other format problem
				end if
			end if
			
			if ( header ) then     ! read line
				read(line,*,iostat = io, err=901) h,k,l, sfs
				if ( io /= 0 ) goto 901

				do j = 1, nscatt
					i = self%sethkl(h,k,l,sclabels(j),sfs(1,j),sfs(2,j))   ! should return 0 (OK)
					if ( i /= 0) then 
                    if ( allocated (sfs) ) deallocate(sfs)
                    if ( allocated (sclabels) ) deallocate(sclabels)
						data_read = -4
						return
					end if
				end do
			
			else   ! look for SCATTERERS or DATA lines.

				if ( line(1:11) == 'SCATTERERS:' ) then
					if ( nscatt /= 0 ) then  ! Found two SCATTERERS lines
						data_read = -3
                        if ( allocated (sfs) ) deallocate(sfs)
                        if ( allocated (sclabels) ) deallocate(sclabels)
						return
					else                     ! Store scatterers and count
						! Count number of scatterers and convert first space to comma for easy read in a moment
						inlab = .false.
						do i = 12, len(line)
						   if ( line(i:i) == ' ' ) then
						       if ( inlab ) then
						          line(i:i) = ','
						          inlab = .false.
 						          nscatt = nscatt + 1
						       end if
						   else
						       inlab = .true.
						   end if
						end do
						! Allocate buffer for scatterers
						allocate(sclabels(nscatt))
						allocate(sfs(2,nscatt))
						! Read them in
						read (line(12:),*) sclabels(1:nscatt)
						do j = 1, nscatt
							call xccupc(sclabels(j),ctemp)
							sclabels(j) = ctemp
						end do
						
!						write(123,*) nscatt, sclabels
						
					end if
				! end of 'SCATTERERS' find
				else if ( line(1:5) == 'DATA:' ) then   ! Header line for data block.
					if ( nscatt == 0 ) then
						data_read = -3
						return
					end if
					header = .true.
				end if
			end if
		end do
		
90      continue
        if ( allocated (sfs) ) deallocate(sfs)
        if ( allocated (sclabels) ) deallocate(sclabels)
		data_read = 0
		return
		
901     continue		
        if ( allocated (sfs) ) deallocate(sfs)
        if ( allocated (sclabels) ) deallocate(sclabels)
		data_read = -4
		return

	  end function
	  
		
	  integer function data_clear(self)
		class(tscstorage), intent(inout) :: self
		! dummy test - load in some fake data
		call self%hkldict%reset()
		tsc_error_count = 0
		data_clear = 0
	  end function
		
  
	  integer function data_gethkl(self, h,k,l, atom, a,b)
		class(tscstorage), intent(inout) :: self
	    integer, intent(in) :: h, k, l
		character(len=*), intent(in) :: atom
		real, intent(out) :: a, b
		type(ab_type) :: ab
		type(hkla_type) :: hkl 

		data_gethkl = 0
		a = 0.0
		b = 0.0
		ab = ab_type(0.0,0.0)
		hkl = hkla_type(h,k,l,atom)
		call self%hkldict%get_value(hkl, ab, data_gethkl)

        if ( data_gethkl < 0 ) then   
            hkl = hkla_type(-h,-k,-l,atom)  ! check Friedel opposite
            call self%hkldict%get_value(hkl, ab, data_gethkl)
            if  (data_gethkl < 0 ) tsc_error_count = tsc_error_count + 1
            a = ab%a
            b = -ab%b                       ! Friedel has opposite sign for imaginary part.
        else
            a = ab%a
            b = ab%b
        end if
        
      end function

	  integer function data_sethkl(self, h,k,l,atom,a,b)
		class(tscstorage), intent(inout) :: self
	    integer, intent(in) :: h, k, l
		character(len=*), intent(in) :: atom
		real, intent(in) :: a, b
		type(ab_type) :: ab
		type(hkla_type) :: hkl 
		
		ab = ab_type(a,b)
		hkl = hkla_type(h,k,l,atom)
		
        call self%hkldict%ustore_value(hkl, ab)
		
		data_sethkl = 0
	  end function

end module


!
!subroutine fabstuff()
!  use ab_dataset
!  use iso_fortran_env, dp => real64
!
!  type(ab_data) :: fullhkldict
!  real(dp) :: matrix1(12), matrix2(12) ! 
!  real :: a,b
!  
!  
!  matrix1 = (/ 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0 /)
!  matrix2 = (/ -1.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0 /)
!  
!! Use ab_dataset to hide details and add symmetry generating initialisation
!  
!  i = fullhkldict%sethkl(1,1,1,0.5,0.4)   ! should return -1 (error) as sym is not initialized
!
!  if ( i == -1 ) then
!     print *, "PASSED uninit check"
!  else
!     error stop "FAILED"
!  end if
!  
!  call fullhkldict%addsym(matrix1)
!  call fullhkldict%addsym(matrix2)
!
!  i = fullhkldict%sethkl(1,1,1,0.5,0.4)   ! should return 0 (OK) as sym is initialized
!  i = fullhkldict%sethkl(1,0,0,0.6,0.5)   ! should return 0 (OK) as sym is initialized
!  i = fullhkldict%sethkl(0,1,0,0.7,0.6)   ! should return 0 (OK) as sym is initialized
!  if ( i == 0 ) then
!     print *, "PASSED init check"
!  else
!     error stop "FAILED"
!  end if
!
!  i = fullhkldict%gethkl(1,1,1,a,b)
!  print *, i,  1, 1, 1,a,b
!  i = fullhkldict%gethkl(-1,-1,-1,a,b)
!  print *, i, -1,-1,-1,a,b
!  i = fullhkldict%gethkl(1,1,1,a,b)
!  print *, i,  1, 1, 1,a,b
!  i = fullhkldict%gethkl(-1,-1,-1,a,b)
!  print *, i, -1,-1,-1,a,b
!  i = fullhkldict%gethkl(2,2,2,a,b)
!  print *, i,  2, 2, 2,a,b
!  i = fullhkldict%gethkl(-2,-2,-2,a,b)
!  print *, i, -2,-2,-2,a,b
!  i = fullhkldict%gethkl(1,0,0,a,b)
!  print *, i, 1,0,0,a,b
!  i = fullhkldict%gethkl(-1,0,0,a,b)
!  print *, i, -1,0,0,a,b
!  i = fullhkldict%gethkl(0,1,0,a,b)
!  print *, i, 0, 1,0,a,b
!  i = fullhkldict%gethkl(0,-1,0,a,b)
!  print *, i, 0, -1,0,a,b
!  i = fullhkldict%gethkl(0,0,1,a,b)
!  print *, i, 0,0,1,a,b
!  i = fullhkldict%gethkl(0,0,-1,a,b)
!  print *, i, 0,0,-1,a,b
!
!
!end subroutine
!
!
!program test
!  use iso_fortran_env, dp => real64
!  use m_hkl_ab_table
!  implicit none
!
!  type(ffh_t) :: h
!  type(hkl_type) :: x, y, z
!  type(ab_type) :: v1, v2, v3, vab
!  integer, parameter    :: hkl_max = 85    ! should generate about five million combinations
!  integer               :: nh, nk, nl, i, status
!  integer, allocatable  :: keys(:)
!  integer, allocatable  :: key_counts(:)
!  real(dp)              :: t_start, t_end
!  real :: abrand(2)
!
!  x%h = 123
!  x%k = 234
!  x%l = 345
!  y%h = 56
!  y%k = 67
!  y%l = 78
!  z = hkl_type(123,234,345)   ! positional member variable initialisation
!  
!  v1 = ab_type(1.00, -0.5)
!  v2 = ab_type(3.14, 2.72)
!  v3 = ab_type(-0.717, -1.54)
!  
!  call h%ustore_value(x, v1)
!  call h%ustore_value(y, v2)
!
!  print *, h%fget_value(x)
!  print *, h%fget_value(y)
!  print *, h%fget_value(z)
!  if (h%fget_value(z) .eq. ab_type(1.0,-0.5)) then
!     print *, "PASSED equality"
!  else
!     error stop "FAILED"
!  end if
!
!  if (h%fget_value(z) .ne. ab_type(2.0,-0.5)) then
!     print *, "PASSED inequality 1"
!  else
!     error stop "FAILED"
!  end if
!
!  if (h%fget_value(y) .ne. ab_type(3.14,2)) then
!     print *, "PASSED inequality 2"
!  else
!     error stop "FAILED"
!  end if
!  
!! benchmark five million
!
!  call cpu_time(t_start)
!  do nh = -hkl_max, hkl_max
!    do nk = -hkl_max, hkl_max
!      do nl = -hkl_max, hkl_max
!	    call random_number(abrand)
!	    call h%ustore_value(hkl_type(nh,nk,nl), ab_type(abrand(1), abrand(2)))
!	  end do
!	end do
!  end do
!  call cpu_time(t_end)
!
!  write(*,*) "Storage benchmark"
!  write(*, "(A,E12.4)") "Elapsed time (s) ", t_end - t_start
!  write(*, "(A,I12)")   "n_keys_stored    ", h%n_keys_stored
!  write(*, "(A,I12)")   "n_occupied       ", h%n_occupied
!  write(*, "(A,I12)")   "n_buckets        ", h%n_buckets
!
!! replace all values
!
!  call cpu_time(t_start)
!  do nh = -hkl_max, hkl_max
!    do nk = -hkl_max, hkl_max
!      do nl = -hkl_max, hkl_max
!	    call h%ustore_value(hkl_type(nh,nk,nl), ab_type(nh*1.0, nk*100.0 + nl * 1.0))
!	  end do
!	end do
!  end do
!  call cpu_time(t_end)
!
!  write(*,*) "Storage benchmark 2"
!  write(*, "(A,E12.4)") "Elapsed time (s) ", t_end - t_start
!  write(*, "(A,I12)")   "n_keys_stored    ", h%n_keys_stored
!  write(*, "(A,I12)")   "n_occupied       ", h%n_occupied
!  write(*, "(A,I12)")   "n_buckets        ", h%n_buckets
!
!! retreive and check all values
!
!  call cpu_time(t_start)
!  
!  do nh = -hkl_max, hkl_max
!    do nk = -hkl_max, hkl_max
!      do nl = -hkl_max, hkl_max
!	    vab = h%fget_value(hkl_type(nh,nk,nl))
!		if ( vab /= ab_type(nh*1.0, nk*100.0 + nl * 1.0)) then
!			print *, "Val check error: ", nh,nk,nl, vab
!		end if
!	  end do
!	end do
!  end do
!  call cpu_time(t_end)
!
!  
!  write(*,*) "Storage benchmark 3"
!  write(*, "(A,E12.4)") "Elapsed time (s) ", t_end - t_start
!  write(*, "(A,I12)")   "n_keys_stored    ", h%n_keys_stored
!  write(*, "(A,I12)")   "n_occupied       ", h%n_occupied
!  write(*, "(A,I12)")   "n_buckets        ", h%n_buckets
!
!! check some values
!
!  print *, h%fget_value(hkl_type(1,1,1))
!  print *, h%fget_value(hkl_type(1,2,3))
!  print *, h%fget_value(hkl_type(84,84,84))
!
!
!  ! Count number of keys that occur an odd number of times
!!  allocate(key_counts(minval(keys):maxval(keys)))
!!  key_counts = 0
!
!!        key_counts(keys(n)) = key_counts(keys(n)) + 1
!!  end do
!!  n = sum(iand(key_counts, 1))
!
!!  if (n /= h%n_keys_stored) then
!!     error stop "FAILED"
!!  else
!!     print *, "PASSED"
!!  end if
!
!  ! Clean up allocated storage
!  call h%reset()
!!  deallocate(key_counts)
!
!  call fabstuff
!	
!
!end program test
  
