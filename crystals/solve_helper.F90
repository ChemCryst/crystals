!$Rev::                                                                 $:  Revision of last commit
!$Author::                                                              $:  Author of last commit
!$Date::                                                                $:  Date of last commit

! The module solve_helper contains methods to invert the normal matrix
module solve_helper
contains 

!> code for the inversion of the normal matrix using eigen decomposition
!! Small eigen values are filtered out based on a condition number threshold
subroutine eigen_inversion(nmatrix, nmsize, eigcutoff, nrejected, condition, filtered_condition, info)
use m_mrgrnk
implicit none
!> Leading dimension of the matrix nmatrix
integer, intent(in) :: nmsize
!> On input symmetric real matrix stored in packed format (lower triangle)
!! aij is stored in AP( i+(2n-j)(j-1)/2) for j <= i.
!! On output the inverse of the matrix is return
real, dimension(nmsize*(nmsize+1)/2), intent(inout) :: nmatrix
!> Value for the relative precision cutoff (condition number * machine precision)
real, intent(in) :: eigcutoff
!> condition number of matrix
real, intent(out) :: condition
!> condition number of filtered_condition
real, intent(out) :: filtered_condition
!> number of eigenvalues filtered out during inversion
integer, intent(out) :: nrejected

real, dimension(:), allocatable :: preconditioner, eigvalues, work
integer, dimension(:), allocatable :: iwork
real, dimension(:,:), allocatable :: eigvectors, invert
logical truncated
integer i, j, k, info
real, dimension(1) :: lwork
integer, dimension(1) :: liwork

#if defined(_GIL_) || defined(_LIN_)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))<epsilon(0.0)) then
        preconditioner(i)=nmatrix(1+j)
    else
        preconditioner(i)=1.0
    end if
end do      
preconditioner = 1.0/sqrt(preconditioner) 
       
! unpacking normal matrix
! not necessary but unpacked data operations are better optimised in lapack
! unpacking + invert + packing is faster
! Applying C N C preconditioning at the same time
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
! only the lower triangle is referenced
allocate(eigvectors(nmsize, nmsize))
do i=1, nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    !unpacking
    eigvectors(i:nmsize, i)=nmatrix(1+j:1+k)
    ! Not loading upper trinagle
    !eigvectors(i, i:nmsize)=nmatrix(1+j:1+k)
    ! preconditioning
    eigvectors(i:nmsize, i)=preconditioner(i)*eigvectors(i:nmsize, i)
    eigvectors(i:nmsize, i)=preconditioner(i:nmsize)*eigvectors(i:nmsize, i)
end do

!open(666, file='matrix', form="unformatted",access="stream")
!write(666) eigvectors
!close(666)

! eigen value filtering
allocate(eigvalues(nmsize))
#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)
#endif

allocate(work(1 + 6*nmsize + 2*nmsize**2))
allocate(iwork(3 + 5*nmsize))
! eigen decomposition
call ssyevd ('V', 'L', nmsize, eigvectors, nmsize, eigvalues, &
    work, 1 + 6*nmsize + 2*nmsize**2, iwork, 3 + 5*nmsize, info)
#if defined(_GIL_) || defined(_LIN_)
print *, 'ssyevd info: ', info
#endif
deallocate(iwork)
deallocate(work)

#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
print *, 'eigen decomp done in (ms): ', &
    ((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)-starttime
#endif

if(info>0) then
    return
end if

! eigen values cutoff
              
truncated=.false.
i=1
nrejected = 0
allocate(iwork(nmsize))
! filtering base on relative precision we want to obtain
do while(eigvalues(nmsize)/max(tiny(1.0),eigvalues(i))*epsilon(1.0)>eigcutoff)
    !call mrgrnk(abs(eigvectors(:,i)), iwork)
    !print *, i, eigvalues(nmsize), eigvalues(i)
#if defined(_GIL_) || defined(_LIN_)
    print *, i, eigvalues(i), ' eig value rejected, max eig value: ', eigvalues(nmsize)
#endif
    truncated=.true.
    i=i+1
end do
nrejected = i - 1
condition = eigvalues(nmsize)/max(tiny(1.0),eigvalues(1))
filtered_condition = condition 
deallocate(iwork)

if(truncated) then
    filtered_condition = eigvalues(nmsize)/max(tiny(1.0),eigvalues(i))
    eigvalues(1:i-1)=0.0
    eigvalues(i:nmsize)=1.0/sqrt(eigvalues(i:nmsize))
else
   eigvalues=1.0/sqrt(eigvalues)
end if


! Inverting (C N C) matrix using eigen decomposition + filtered eigen values
allocate(invert(nmsize,nmsize))
! N^-1 = V E V^t
!      = V E^0.5 E^0.5 V^t
!      = (V E^0.5) (V E^0.5)^t
!               invert = matmul((eigvectors), matmul(eigvalues, 
!                   transpose(eigvectors)))

#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)
#endif
do i=1, nmsize
   eigvectors(:,i)=eigvectors(:,i)*eigvalues(i)
end do
invert=0.0

call SSYRK('L','N',nmsize,nmsize,1.0,eigvectors,nmsize,1.0,invert,nmsize)
#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
print *, 'Formation of the inverse done in (ms): ', &
    ((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)-starttime
#endif
! Pack normal matrix back into original crystals storage
do i=1,nmsize
    j = ((i-1)*(2*nmsize-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=invert(i:nmsize,i)
end do             

deallocate(invert)
deallocate(eigvectors)
deallocate(eigvalues)                      
   
! revert pre conditioning                   
! Applying C (C N C)^-1 C to get N^-1
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=preconditioner(i:nmsize)*nmatrix(1+j:1+k)
    nmatrix(1+j:1+k)=preconditioner(i)*nmatrix(1+j:1+k)
end do              
deallocate(preconditioner)

end subroutine

!> code for the inversion of the normal matrix using cholesky decomposition
!! Original algorithm from crystals + preconditioning
subroutine cholesky_inversion(nmatrix, nmsize, info)
implicit none
!> Leading dimension of the matrix nmatrix
integer, intent(in) :: nmsize
!> On input symmetric real matrix stored in packed format (lower triangle)
!! aij is stored in AP( i+(2n-j)(j-1)/2) for j <= i.
!! On output the inverse of the matrix is return
real, dimension(nmsize*(nmsize+1)/2), intent(inout) :: nmatrix
!> Status of the calculation. =0 if success
integer, intent(out) :: info

real, dimension(:), allocatable :: preconditioner
integer i, j, k
real, dimension(:,:), allocatable :: unpacked

real sumc
real, dimension(:), allocatable :: diag

integer :: starttime
integer, dimension(8) :: measuredtime

info=0

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))<epsilon(0.0)) then
        preconditioner(i)=nmatrix(1+j)
    else
        preconditioner(i)=1.0
    end if
end do      
preconditioner = 1.0/sqrt(preconditioner) 

! Applying C N C
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=preconditioner(i)*nmatrix(1+j:1+k)
    nmatrix(1+j:1+k)=preconditioner(i:nmsize)*nmatrix(1+j:1+k)
end do              

! unpacking lower triangle for memory efficiency
allocate(unpacked(nmsize, nmsize))
do i=1, nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    unpacked(i:nmsize, i)=nmatrix(1+j:1+k)
    unpacked(i, i+1:nmsize)=nmatrix(1+j+1:1+k)
end do

!call date_and_time(VALUES=measuredtime)
!starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)

! Cholesky decomposition
! result is upper triangular
! inverse of the diagonal elements in diag
allocate(diag(nmsize))
do  i=1,nmsize
    do  j=i,nmsize
        sumc=unpacked(j,i)
        sumc=sumc-sum(unpacked(1:i-1,i)*unpacked(1:i-1,j))
        if(i.eq.j)then
            if(sumc.le.epsilon(0.)) then
                diag(i)=0.0
                info=-1
            end if
            diag(i)=1.0/sqrt(sumc)
        else
            unpacked(i,j)=sumc*diag(i)
        endif
    enddo 
enddo 

!call date_and_time(VALUES=measuredtime)
!print *, 'PP* ****** cholesky decomposition ', info, &
!&       ((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)-starttime, 'ms'

!call date_and_time(VALUES=measuredtime)
!starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)

! Inversion of a lower triangle matrix
! diagonal elements in diagonal
! for efficiency both lower and upper part are used
! zeroing lower triangle and copying upper part into lower part
do i=1, nmsize
    unpacked(i+1:nmsize, i)=unpacked(i,i+1:nmsize)
end do

do i=1,nmsize
    unpacked(i,i)=diag(i)
    do j=i+1,nmsize
        unpacked(j,i)=-sum(unpacked(i:j-1,j)*unpacked(i:j-1,i))*diag(j)
    enddo 
enddo 
deallocate(diag)

!call date_and_time(VALUES=measuredtime)
!print *, 'PP* ***** Triangle inverse ', info  , &
!&       ((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)-starttime, 'ms'

! Formation of the invert of the normal matrix
call STRMM('L','L','T','N',nmsize,nmsize,1.0,unpacked,nmsize,unpacked,nmsize)

! Pack normal matrix back into original crystals storage
do i=1,nmsize
    j = ((i-1)*(2*nmsize-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=unpacked(i:nmsize,i)
end do    

! revert pre conditioning                   
! Applying C (C N C)^-1 C to get N^-1
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=preconditioner(i)*nmatrix(1+j:1+k)
    nmatrix(1+j:1+k)=preconditioner(i:nmsize)*nmatrix(1+j:1+k)
end do  
            
deallocate(preconditioner)

end subroutine

!> code for the inversion of the normal matrix using LDL^t decomposition
!! of symmetric matrices
subroutine LDLT_inversion(nmatrix, nmsize, info)
implicit none
!> Leading dimension of the matrix nmatrix
integer, intent(in) :: nmsize
!> On input symmetric real matrix stored in packed format (lower triangle)
!! aij is stored in AP( i+(2n-j)(j-1)/2) for j <= i.
!! On output the inverse of the matrix is return
real, dimension(nmsize*(nmsize+1)/2), intent(inout) :: nmatrix
!> Status of the calculation. =0 if success
integer, intent(out) :: info

real, dimension(:), allocatable :: preconditioner
integer i, j, k, lwork 
real, dimension(:,:), allocatable :: unpacked

real, dimension(:), allocatable :: work
integer, dimension(:), allocatable :: ipiv, iwork
real rcond
integer, external :: ILAENV

#if defined(_GIL_) || defined(_LIN_)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

info=0

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))<epsilon(0.0)) then
        preconditioner(i)=nmatrix(1+j)
    else
        preconditioner(i)=1.0
    end if
end do      
preconditioner = 1.0/sqrt(preconditioner) 

! unpacking lower triangle for memory efficiency and preconditioning:
! N' = C N C
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
allocate(unpacked(nmsize, nmsize))
do i=1, nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    ! unpacking
    ! only lower triangle is referenced
    unpacked(i:nmsize, i)=nmatrix(1+j:1+k)
    ! applying preconditioning
    unpacked(i:nmsize, i)=preconditioner(i:nmsize)*unpacked(i:nmsize, i)
    unpacked(i:nmsize, i)=preconditioner(i)*unpacked(i:nmsize, i)
    !unpacked(i, i+1:nmsize)=nmatrix(1+j+1:1+k)
end do

!open(666, file='matrix', form="unformatted",access="stream")
!write(666) unpacked
!close(666)

#if defined(_GIL_) || defined(_LIN_) 
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)
#endif

allocate(ipiv(nmsize))
lwork = ILAENV( 1, 'SSYTRF', 'L', nmsize, nmsize, -1, -1)
allocate(work(nmsize*lwork))
call SSYTRF( 'L', nmsize, unpacked, nmsize, IPIV, WORK, nmsize*lwork, INFO )
#if defined(_GIL_) || defined(_LIN_)
print *, 'SSYTRF info: ', info
#endif
deallocate(work)

if(info>0) then 
    return
end if

allocate(work(2*nmsize))
allocate(iwork(nmsize))
call SSYCON( 'L', nmsize, unpacked, nmsize, ipiv, 1.0, rcond, work, iwork, info )
#if defined(_GIL_) || defined(_LIN_)
print *, 'SSYCON info: ', info
#endif
deallocate(work)
deallocate(iwork)
#if defined(_GIL_) || defined(_LIN_)
print *, 'condition number ', 1.0/rcond
print *, 'relative error ', 1.0/rcond*epsilon(1.0)
#endif

allocate(work(nmsize))
call SSYTRI( 'L', nmsize, unpacked, nmsize, IPIV, WORK, INFO )
#if defined(_GIL_) || defined(_LIN_)
print *, 'SSYTRI info: ', info
#endif
deallocate(ipiv)
deallocate(work)

#if defined(_GIL_) || defined(_LIN_) 
call date_and_time(VALUES=measuredtime)
print *, 'invert via LDL^t decomposition', &
&       ((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000 +&
&       measuredtime(8)-starttime, 'ms'
#endif

if(info>0) then 
    return
end if

! Pack normal matrix back into original crystals storage
! revert pre conditioning                   
! Applying C (C N C)^-1 C to get N^-1
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
do i=1,nmsize
    j = ((i-1)*(2*nmsize-i+2))/2
    k = j + nmsize - i
    ! packing back matrix
    nmatrix(1+j:1+k)=unpacked(i:nmsize,i)
    ! revert preconditioning
    nmatrix(1+j:1+k)=preconditioner(i:nmsize)*nmatrix(1+j:1+k)
    nmatrix(1+j:1+k)=preconditioner(i)*nmatrix(1+j:1+k)
end do    
            
deallocate(preconditioner)
deallocate(unpacked)

end subroutine

!> code for the inversion of the normal matrix using cholesky decomposition
!! from lapack
subroutine choleskyl_inversion(nmatrix, nmsize, info)
implicit none
!> Leading dimension of the matrix nmatrix
integer, intent(in) :: nmsize
!> On input symmetric real matrix stored in packed format (lower triangle)
!! aij is stored in AP( i+(2n-j)(j-1)/2) for j <= i.
!! On output the inverse of the matrix is return
real, dimension(nmsize*(nmsize+1)/2), intent(inout) :: nmatrix
!> Status of the calculation. =0 if success
integer, intent(out) :: info

real, dimension(:), allocatable :: preconditioner
integer i, j, k
real, dimension(:,:), allocatable :: unpacked, original

real, dimension(:), allocatable :: work
integer, dimension(:), allocatable :: iwork
real rcond

integer :: starttime
integer, dimension(8) :: measuredtime

info=0

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))<epsilon(0.0)) then
        preconditioner(i)=nmatrix(1+j)
    else
        preconditioner(i)=1.0
    end if
end do      
preconditioner = 1.0/sqrt(preconditioner) 

! Applying C N C
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=preconditioner(i)*nmatrix(1+j:1+k)
    nmatrix(1+j:1+k)=preconditioner(i:nmsize)*nmatrix(1+j:1+k)
end do              

! unpacking lower triangle for memory efficiency
allocate(unpacked(nmsize, nmsize))
!allocate(original(nmsize, nmsize))
do i=1, nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    unpacked(i:nmsize, i)=nmatrix(1+j:1+k)
    unpacked(i, i+1:nmsize)=nmatrix(1+j+1:1+k)
end do
!original=unpacked

!open(666, file='matrix', form="unformatted",access="stream")
!write(666) unpacked
!close(666)

!call date_and_time(VALUES=measuredtime)
!starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)

! choleski decomposition
call  SPOTRF( 'L', nmsize, unpacked, nmsize, info )

!condition number
allocate(work(3*nmsize))
allocate(iwork(nmsize))
call SPOCON( 'L', nmsize, unpacked, nmsize, 1.0, rcond, work, iwork, info )
deallocate(work)
deallocate(iwork)
#if defined(_GIL_) || defined(_LIN_)
print *, 'condition number ', 1.0/rcond
print *, 'relative error ', 1.0/rcond*epsilon(1.0)
#endif
! inversion using previous decomposition
call  SPOTRI( 'L', nmsize, unpacked, nmsize, info )

!call date_and_time(VALUES=measuredtime)
!print *, 'PP* ***** LDL ', info  , &
!&       ((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)-starttime, 'ms'

do i=1, nmsize
    unpacked(i, i+1:nmsize)=unpacked(i+1:nmsize, i)
end do

!original=matmul(original, unpacked)
!do  i=1, 5
!  print *, original(i,1:5)
!end do
!j=0
!do i=1, nmsize
!  j=j+nint(original(i,i))
!  original(i,i)=0.0
!end do
!print *, j
!print *, maxval(abs(original)), maxloc(abs(original))

! Pack normal matrix back into original crystals storage
do i=1,nmsize
    j = ((i-1)*(2*nmsize-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=unpacked(i:nmsize,i)
end do    

! revert pre conditioning                   
! Applying C (C N C)^-1 C to get N^-1
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    k = j + nmsize - i
    nmatrix(1+j:1+k)=preconditioner(i)*nmatrix(1+j:1+k)
    nmatrix(1+j:1+k)=preconditioner(i:nmsize)*nmatrix(1+j:1+k)
end do  
            
deallocate(preconditioner)

end subroutine

subroutine error9900(a, b, c, d, e, f)
! this subroutine replaces in solve.F:
!5275  CONTINUE
!C
!      CALL XOPMSG( IOPINV, IOPEND, IVERSN)
!C
!      CALL XTIME2(2)
!      RETURN
!C
!9900  CONTINUE
!C -- ERRORS
!      CALL XOPMSG ( IOPINV , IOPABN , 0 )
!      GO TO 5275
! similar calls used in several places, all factored here
implicit none
integer a, b, c, d, e, f

      CALL XOPMSG ( a , b , c )
      CALL XOPMSG( d, e, f)
      CALL XTIME2(2)

end subroutine

subroutine stopcycles(istore, l33cb, n33ib, clst23, i, j, ncvdu, ncwu, issprt, cmon)
implicit  none
integer l33cb, n33ib, i, j, ncvdu, ncwu, issprt
integer, dimension(:) :: istore
character(len=*), dimension(:) :: cmon
character(len=*), dimension(:) :: clst23

istore(l33cb)=n33ib
if (i .gt. 0) then
    write(cmon(1), '(" Forced termination after this cycle: ", &
    &    " Actual value condition on: ",A)' ) clst23(i)(:)
       call xprvdu(ncvdu, 1,0)
       if (issprt .eq. 0) write(ncwu,'(A)') cmon(1)
      endif
      if (j .gt. 0) then
       write(cmon(1),'(" Forced termination after this cycle: ", &
       &    " Relative change condition on ",   A)') clst23(j)(:)
       call xprvdu(ncvdu, 1,0)
       if (issprt .eq. 0) write(ncwu,'(A)') cmon(1)
      endif
      
end subroutine

end module
