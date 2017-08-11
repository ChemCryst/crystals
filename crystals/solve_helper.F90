! The module solve_helper contains methods to invert the normal matrix
module solve_helper
contains 

!> code for the inversion of the normal matrix using eigen decomposition
!! Small eigen values are filtered out based on a condition number threshold
subroutine eigen_inversion(nmatrix, nmsize, eigcutoff, nrejected, condition, filtered_condition, info, blasname)
use m_mrgrnk
use xiobuf_mod, only: cmon
use xunits_mod, only: ncvdu, ncwu
use xssval_mod, only: issprt
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
integer, intent(out) :: info !< error code on exit
character(len=16), intent(out) :: blasname !< name of blas subroutine where error occured

real, dimension(:), allocatable :: preconditioner, eigvalues, work
integer, dimension(:), allocatable :: iwork
real, dimension(:,:), allocatable :: eigvectors, invert
logical truncated
integer i, j, k

#if defined(CRY_OSLINUX)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

blasname=''

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))>epsilon(0.0)) then
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
#if defined(CRY_OSLINUX)
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)
#endif

allocate(work(1 + 6*nmsize + 2*nmsize**2))
allocate(iwork(3 + 5*nmsize))
! eigen decomposition
call ssyevd ('V', 'L', nmsize, eigvectors, nmsize, eigvalues, &
    work, 1 + 6*nmsize + 2*nmsize**2, iwork, 3 + 5*nmsize, info)
#if defined(CRY_OSLINUX)
print *, 'ssyevd info: ', info
#endif
deallocate(iwork)
deallocate(work)

#if defined(CRY_OSLINUX)
call date_and_time(VALUES=measuredtime)
print *, 'eigen decomp done in (ms): ', &
    ((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)-starttime
#endif

if(info>0) then
    blasname='SSYEVD'
    return
end if

! eigen values cutoff
              
truncated=.false.
i=1
nrejected = 0
! filtering base on relative precision we want to obtain
do while(eigvalues(nmsize)/max(tiny(1.0),eigvalues(i))*epsilon(1.0)>eigcutoff)
    !call mrgrnk(abs(eigvectors(:,i)), iwork)
    !print *, i, eigvalues(nmsize), eigvalues(i)
    WRITE ( CMON, '(A,1PE10.3,A,I0)') '{I Eigenvalue ', eigvalues(i), &
    &  ' rejected. Hint: look at parameter ', maxloc(abs(eigvectors(:,i)))
    CALL XPRVDU(NCVDU, 1,0)
    if(issprt==0) then
      WRITE ( NCWU, '(A,1PE10.3,A,I0)') ' Eigenvalue ', eigvalues(i), &
      &  ' rejected. Hint: look at parameter ', maxloc(abs(eigvectors(:,i)))
    end if
#if defined(CRY_OSLINUX)
    print *, i, eigvalues(i), ' eig value rejected, max eig value: ', eigvalues(nmsize)
    print *, maxloc(abs(eigvectors(:,i))), maxval(abs(eigvectors(:,i)))
#endif
    truncated=.true.
    i=i+1
end do
nrejected = i - 1
condition = eigvalues(nmsize)/max(tiny(1.0),eigvalues(1))
filtered_condition = condition 

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

#if defined(CRY_OSLINUX)
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+ &
    measuredtime(7))*1000.0+measuredtime(8)
#endif

do i=1, nmsize
   eigvectors(:,i)=eigvectors(:,i)*eigvalues(i)
end do
invert=0.0

call SSYRK('L','N',nmsize,nmsize,1.0,eigvectors,nmsize,1.0,invert,nmsize)

#if defined(CRY_OSLINUX)
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

info=0

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))>epsilon(0.0)) then
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
deallocate(unpacked)

end subroutine

!> code for the inversion of the normal matrix using LDL^t decomposition
!! of symmetric matrices
subroutine LDLT_inversion(nmatrix, nmsize, info)
use xiobuf_mod, only: cmon
use xunits_mod, only:ncvdu,ncwu
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
real rcond, onenorm
integer, external :: ILAENV

#if defined(CRY_OSLINUX)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

info=0

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))>epsilon(0.0)) then
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
onenorm=0.0
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
    
    onenorm=max(onenorm, sum(abs(unpacked(i:nmsize,i)))+sum(abs(unpacked(i,1:i-1))))
end do

print *, '3 ', onenorm
do i=1, 5
print *, unpacked(1:5,i)
end do

!open(666, file='matrix', form="unformatted",access="stream")
!write(666) unpacked
!close(666)

#if defined(CRY_OSLINUX) 
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)
#endif

allocate(ipiv(nmsize))
lwork = ILAENV( 1, 'SSYTRF', 'L', nmsize, nmsize, -1, -1)
allocate(work(nmsize*lwork))
call SSYTRF( 'L', nmsize, unpacked, nmsize, IPIV, WORK, nmsize*lwork, INFO )
#if defined(CRY_OSLINUX)
print *, 'SSYTRF info: ', info
#endif
deallocate(work)

if(info/=0) then 
    return
end if

allocate(work(2*nmsize))
allocate(iwork(nmsize))
call SSYCON( 'L', nmsize, unpacked, nmsize, ipiv, onenorm, rcond, work, iwork, info )
#if defined(CRY_OSLINUX)
print *, 'SSYCON info: ', info
#endif
deallocate(work)
deallocate(iwork)

if(info/=0) then 
    return
end if

#if defined(CRY_OSLINUX)
print *, 'condition number ', 1.0/rcond
print *, 'relative error ', 1.0/rcond*epsilon(1.0)
#endif

if(1.0/rcond*epsilon(1.0)>10.0) then
    info=1111111
    WRITE ( CMON, '(A, 1PE10.3)') '{I 1-norm ', onenorm
    CALL XPRVDU(NCVDU, 1,0) 
    WRITE ( CMON, '(A, 1PE10.3)') '{I condition number ', 1.0/rcond
    CALL XPRVDU(NCVDU, 1,0) 
    WRITE ( CMON, '(A, 1PE10.3)') '{I relative error ', 1.0/rcond*epsilon(1.0)
    CALL XPRVDU(NCVDU, 1,0)     
    return
end if

allocate(work(nmsize))
call SSYTRI( 'L', nmsize, unpacked, nmsize, IPIV, WORK, INFO )
#if defined(CRY_OSLINUX)
print *, 'SSYTRI info: ', info
#endif
deallocate(ipiv)
deallocate(work)

#if defined(CRY_OSLINUX) 
call date_and_time(VALUES=measuredtime)
print *, 'invert via LDL^t decomposition', &
&       ((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000 +&
&       measuredtime(8)-starttime, 'ms'
#endif

if(info/=0) then 
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

!> code for the inversion of the normal matrix using LDL^t decomposition
!! of symmetric matrices (double precision)
subroutine LDLT_inversion_dp(nmatrix, nmsize, info)
use xiobuf_mod, only: cmon
use xunits_mod, only:ncvdu, ncwu
implicit none
!> Leading dimension of the matrix nmatrix
integer, intent(in) :: nmsize
!> On input symmetric real matrix stored in packed format (lower triangle)
!! aij is stored in AP( i+(2n-j)(j-1)/2) for j <= i.
!! On output the inverse of the matrix is return
real, dimension(nmsize*(nmsize+1)/2), intent(inout) :: nmatrix
!> Status of the calculation. =0 if success
integer, intent(out) :: info

double precision, dimension(:), allocatable :: preconditioner
integer i, j, k, lwork 
double precision, dimension(:,:), allocatable :: unpacked

double precision, dimension(:), allocatable :: work
integer, dimension(:), allocatable :: ipiv, iwork
double precision rcond, onenorm
integer, external :: ILAENV

#if defined(CRY_OSLINUX)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

info=0

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))>epsilon(0.0d0)) then
        preconditioner(i)=nmatrix(1+j)
    else
        preconditioner(i)=1.0d0
    end if
end do      
preconditioner = 1.0d0/sqrt(preconditioner) 

! unpacking lower triangle for memory efficiency and preconditioning:
! N' = C N C
! N: normal matrix
! C: diagonal matrix with elements from the N diagonal
onenorm=0.0d0
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
    
    onenorm=max(onenorm, sum(abs(unpacked(i:nmsize,i)))+sum(abs(unpacked(i,1:i-1))))
end do

!open(666, file='matrix', form="unformatted",access="stream")
!write(666) unpacked
!close(666)

#if defined(CRY_OSLINUX) 
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)
#endif

allocate(ipiv(nmsize))
lwork = ILAENV( 1, 'DSYTRF', 'L', nmsize, nmsize, -1, -1)
allocate(work(nmsize*lwork))
call DSYTRF( 'L', nmsize, unpacked, nmsize, IPIV, WORK, nmsize*lwork, INFO )
#if defined(CRY_OSLINUX)
print *, 'DSYTRF info: ', info
#endif
deallocate(work)

if(info>0) then 
    return
end if

allocate(work(2*nmsize))
allocate(iwork(nmsize))
call DSYCON( 'L', nmsize, unpacked, nmsize, ipiv, onenorm, rcond, work, iwork, info )
#if defined(CRY_OSLINUX)
print *, 'DSYCON info: ', info
#endif
deallocate(work)
deallocate(iwork)
#if defined(CRY_OSLINUX)
print *, 'condition number ', 1.0d0/rcond
print *, 'relative error ', 1.0d0/rcond*epsilon(1.0d0)
#endif

if(1.0d0/rcond*epsilon(1.0d0)>1.0d-5) then
    info=1111111
    WRITE ( CMON, '(A, 1PE10.3)') '{I 1-norm ', onenorm
    CALL XPRVDU(NCVDU, 1,0) 
    WRITE ( CMON, '(A, 1PE10.3)') '{I condition number ', 1.0d0/rcond
    CALL XPRVDU(NCVDU, 1,0) 
    WRITE ( CMON, '(A, 1PE10.3)') '{I relative error ', 1.0d0/rcond*epsilon(1.0d0)
    CALL XPRVDU(NCVDU, 1,0)     
    return
end if

allocate(work(nmsize))
call DSYTRI( 'L', nmsize, unpacked, nmsize, IPIV, WORK, INFO )
#if defined(CRY_OSLINUX)
print *, 'DSYTRI info: ', info
#endif
deallocate(ipiv)
deallocate(work)

#if defined(CRY_OSLINUX) 
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

info=0

! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))>epsilon(0.0)) then
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
#if defined(CRY_OSLINUX)
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
deallocate(unpacked)

end subroutine

!> code for the inversion of the normal matrix using LDL^t decomposition
!! of symmetric matrices with dynamic handling of conditioning
subroutine auto_inversion(nmatrix, nmsize, info, blasname)
use xiobuf_mod, only: cmon
use xunits_mod, only:ncvdu,ncwu
implicit none
!> Leading dimension of the matrix nmatrix
integer, intent(in) :: nmsize
!> On input symmetric real matrix stored in packed format (lower triangle)
!! aij is stored in AP( i+(2n-j)(j-1)/2) for j <= i.
!! On output the inverse of the matrix is return
real, dimension(nmsize*(nmsize+1)/2), intent(inout) :: nmatrix
!> Status of the calculation. =0 if success
integer, intent(out) :: info
character(len=16), intent(out) :: blasname !< name of the blas function where error occurs

real, dimension(:), allocatable :: preconditioner
double precision, dimension(:), allocatable :: dpreconditioner
integer i, j, k, lwork 
real, dimension(:,:), allocatable :: unpacked
double precision, dimension(:,:), allocatable :: dunpacked

real, dimension(:), allocatable :: work
double precision, dimension(:), allocatable :: dwork
integer, dimension(:), allocatable :: ipiv, iwork
real rcond, onenorm, lnorm
double precision drcond, donenorm, dlnorm
integer, external :: ILAENV

real condition, filtered_condition
integer nrejected

double precision, dimension(:,:), allocatable :: ref, check
real rmax
logical, parameter :: checkid=.false.

#if defined(CRY_OSLINUX)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

info=0
blasname=''

!open(123, file="2", STATUS='REPLACE')
!write(123, *) nmatrix
!close(123)


#if defined(CRY_OSLINUX)
print *, ''
print *, '--- Automatic inversion ---'
print *, 'single precision'
#endif


! preconditioning using diagonal terms
! Allocate diagonal vector
allocate(preconditioner(nmsize))
do i=1,nmsize
    j = ((i-1)*(2*(nmsize)-i+2))/2
    if(abs(nmatrix(1+j))>epsilon(0.0)) then
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
onenorm=0.0
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
    
    onenorm=max(onenorm, sum(abs(unpacked(i:nmsize,i)))+sum(abs(unpacked(i,1:i-1))))
end do

! debugging, check A^-1 A
if(checkid) then
    allocate(ref(nmsize,nmsize))
    ref=unpacked
    do i=1, nmsize
        ref(i, i+1:nmsize)=ref(i+1:nmsize, i)
    end do
end if

!open(666, file='matrix', form="unformatted",access="stream")
!write(666) unpacked
!close(666)

allocate(ipiv(nmsize))
lwork = ILAENV( 1, 'SSYTRF', 'L', nmsize, nmsize, -1, -1)
allocate(work(nmsize*lwork))
call SSYTRF( 'L', nmsize, unpacked, nmsize, IPIV, WORK, nmsize*lwork, INFO )
#if defined(CRY_OSLINUX)
print *, 'SSYTRF info: ', info
#endif
deallocate(work)

if(info/=0) then 
    blasname='SSYTRF'
    return
end if

allocate(work(2*nmsize))
allocate(iwork(nmsize))
call SSYCON( 'L', nmsize, unpacked, nmsize, ipiv, onenorm, rcond, work, iwork, info )
#if defined(CRY_OSLINUX)
print *, 'SSYCON info: ', info
#endif
deallocate(work)
deallocate(iwork)

if(info/=0) then 
    blasname='SSYCON'
    return
end if

#if defined(CRY_OSLINUX)
print *, 'condition number ', 1.0/rcond
print *, 'relative error ', 1.0/rcond*epsilon(1.0)
print *, 'One norm ', onenorm
#endif
WRITE ( NCWU, '(A, 1X,3(A, 1PE9.2,1X))') 'Single precision: ', &
&   '1-norm: ', onenorm, &
&   'condition number: ', 1.0d0/rcond, &
&   'relative error: ', 1.0d0/rcond*epsilon(1.0)


if(1.0/rcond*epsilon(1.0)>1e-3) then
    ! not enough precision, using double precision
#if defined(CRY_OSLINUX)
    print *, 'double precision'
#endif

    ! preconditioning using diagonal terms
    ! Allocate diagonal vector
    allocate(dpreconditioner(nmsize))
    do i=1,nmsize
        j = ((i-1)*(2*(nmsize)-i+2))/2
        if(abs(nmatrix(1+j))>epsilon(0.0d0)) then
            dpreconditioner(i)=nmatrix(1+j)
        else
            dpreconditioner(i)=1.0d0
        end if
    end do      
    dpreconditioner = 1.0d0/sqrt(dpreconditioner) 

    ! unpacking lower triangle for memory efficiency and preconditioning:
    ! N' = C N C
    ! N: normal matrix
    ! C: diagonal matrix with elements from the N diagonal
    donenorm=0.0d0
    allocate(dunpacked(nmsize, nmsize))
    do i=1, nmsize
        j = ((i-1)*(2*(nmsize)-i+2))/2
        k = j + nmsize - i
        ! unpacking
        ! only lower triangle is referenced
        dunpacked(i:nmsize, i)=nmatrix(1+j:1+k)
        ! applying preconditioning
        dunpacked(i:nmsize, i)=dpreconditioner(i:nmsize)*dunpacked(i:nmsize, i)
        dunpacked(i:nmsize, i)=dpreconditioner(i)*dunpacked(i:nmsize, i)
        !unpacked(i, i+1:nmsize)=nmatrix(1+j+1:1+k)
        
        donenorm=max(donenorm, sum(abs(dunpacked(i:nmsize,i)))+sum(abs(dunpacked(i,1:i-1))))
    end do

    !allocate(ipiv(nmsize))
    lwork = ILAENV( 1, 'DSYTRF', 'L', nmsize, nmsize, -1, -1)
    allocate(dwork(nmsize*lwork))
    call DSYTRF( 'L', nmsize, dunpacked, nmsize, IPIV, dWORK, nmsize*lwork, INFO )
#if defined(CRY_OSLINUX)
    print *, 'DSYTRF info: ', info
#endif
    deallocate(dwork)

    if(info/=0) then 
        blasname='DSYTRF'
        return
    end if

    allocate(dwork(2*nmsize))
    allocate(iwork(nmsize))
    call DSYCON( 'L', nmsize, dunpacked, nmsize, ipiv, donenorm, drcond, dwork, iwork, info )
#if defined(CRY_OSLINUX)
    print *, 'DSYCON info: ', info
#endif
    deallocate(dwork)
    deallocate(iwork)
    
    if(info/=0) then 
        blasname='DSYCON'
        return
    end if
    
#if defined(CRY_OSLINUX)
    print *, 'condition number ', 1.0d0/drcond
    print *, 'relative error ', 1.0d0/drcond*epsilon(1.0d0)
    print *, 'One norm ', donenorm
#endif
    WRITE ( NCWU, '(A, 1X,3(A, 1PE9.2,1X))') 'Double precision: ', &
    &   '1-norm: ', donenorm, &
    &   'condition number: ', 1.0d0/drcond, &
    &   'relative error: ', 1.0d0/drcond*epsilon(1.0d0)


    if(1.0d0/drcond*epsilon(1.0d0)>1e-3) then
        ! we are in trouble, even double precision is not good enough
#if defined(CRY_OSLINUX)
        print *, 'eigen values filtering'
#endif
        
        call eigen_inversion(nmatrix, nmsize, 1e-5, nrejected, condition, filtered_condition, info, blasname)
        if(info/=0) then 
            return
        end if
        if(info==0 .and. nrejected>0) then
            info=1111111
        end if
        return
    else ! carry on ldldt double precision
            
        WRITE ( CMON, '(1X,3(A, 1PE9.2,1X))') '(dp inverse) 1-norm: ', donenorm, &
        &   'cond. number: ', 1.0d0/drcond, &
        &   'rel. error: ', 1.0d0/drcond*epsilon(1.0d0)
        CALL XPRVDU(NCVDU, 1,0)     

        allocate(dwork(nmsize))
        call DSYTRI( 'L', nmsize, dunpacked, nmsize, IPIV, dWORK, INFO )
#if defined(CRY_OSLINUX)
        print *, 'DSYTRI info: ', info
#endif
        deallocate(ipiv)
        deallocate(dwork)

        if(info/=0) then 
            blasname='DSYTRI'
            return
        end if
        
        if(checkid) then
            do i=1, nmsize
                dunpacked(i, i+1:nmsize)=dunpacked(i+1:nmsize, i)
            end do
            allocate(check(nmsize,nmsize))
        
            call DGEMM('T','N',nmsize,nmsize,nmsize,1.0d0,dunpacked,nmsize,ref,nmsize,0.0d0,check,nmsize)
            
            rmax=0.0
            do i=1, nmsize
                if(abs(check(i,i))>rmax) then
                    rmax=check(i,i)
                end if
                check(i,i)=0.0
            end do
            print *, 'diag max, min, max, cn', rmax, minval(check), maxval(check)
        end if


        ! Pack normal matrix back into original crystals storage
        ! revert pre conditioning                   
        ! Applying C (C N C)^-1 C to get N^-1
        ! N: normal matrix
        ! C: diagonal matrix with elements from the N diagonal
        do i=1,nmsize
            j = ((i-1)*(2*nmsize-i+2))/2
            k = j + nmsize - i
            ! revert preconditioning
            dunpacked(i:nmsize, i)=dpreconditioner(i:nmsize)*dunpacked(i:nmsize, i)
            dunpacked(i:nmsize, i)=dpreconditioner(i)*dunpacked(i:nmsize, i)
            ! packing back matrix
            nmatrix(1+j:1+k)=dunpacked(i:nmsize,i)
        end do    
        
        deallocate(dpreconditioner)
        deallocate(dunpacked)   
        return
    
    end if
else ! all good for single precision inversion

    WRITE ( CMON, '(1X,3(A, 1PE9.2,1X))') '(sp inverse) 1-norm: ', onenorm, &
    &   'cond. number: ', 1.0/rcond, &
    &   'rel. error: ', 1.0/rcond*epsilon(1.0)
    CALL XPRVDU(NCVDU, 1,0)     

    allocate(work(nmsize))
    call SSYTRI( 'L', nmsize, unpacked, nmsize, IPIV, WORK, INFO )
#if defined(CRY_OSLINUX)
    print *, 'SSYTRI info: ', info
#endif
    deallocate(ipiv)
    deallocate(work)

    if(info/=0) then 
        blasname='SSYTRI'
        return
    end if

    if(checkid) then
        do i=1, nmsize
            unpacked(i, i+1:nmsize)=unpacked(i+1:nmsize, i)
        end do
        allocate(dunpacked(nmsize,nmsize))
        dunpacked=unpacked
        allocate(check(nmsize,nmsize))
    
        call DGEMM('T','N',nmsize,nmsize,nmsize,1.0d0,dunpacked,nmsize,ref,nmsize,0.0d0,check,nmsize)
        
        rmax=0.0
        do i=1, nmsize
            if(abs(check(i,i))>rmax) then
                rmax=check(i,i)
            end if
            check(i,i)=0.0
        end do
        print *, 'diag max, min, max', rmax, minval(check), maxval(check)            
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
end if

end subroutine

end module
