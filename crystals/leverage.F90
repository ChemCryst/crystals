module leverage_mod

type leverage_type
real, dimension(:,:), allocatable :: tvalues
end type

type(leverage_type) :: leverage_results

contains

!> Calculate the t values from a leverage analysis
!!
!! The higher the value, the higher the influence of the reflection on the input parameter
!! The improvment on the standard deviation can written as: 
!! V_new = V_old - (V_old tr(z_i) z_i V_old) / ( 1 + z_i V_old tr(z_i))
!!       = V_old - T_value
!!
!! - V_new: improved variance/covariance matrix
!! - V_old: current vairance/covariance matric
!! - tr(): transpose
!! - z_i a row of the design matrix (ith observation)
!!
!!
!! Only a parameter j analyzed ( j,j position in V), expression can be simplified
!! (V_old tr(z_i) z_i V_old) = dot_product(V_old_j, z_i)**2
!! V_old_j: j row or column of V_old
!!
subroutine leverage(parameterindex, errcode)
!$ use OMP_LIB
use xlst05_mod, only: l5o, m5a, l5, md5, n5
use xlst06_mod, only: md6
use xlst02_mod, only: ic
use xlst12_mod, only: n12, m12b
use xlst23_mod, only: L23M, L23SP
use store_mod, only: istore, store, nfl
use xsflsw_mod, only: anomal
use xstr11_mod, only: str11=>xstr11
use xlst11_mod, only: l11
use xlst03_mod, only: n3
use xworkb_mod, only: jr, jq, jn
use xunits_mod, only: ierflg
implicit none

interface
    subroutine XSFLSX(tc, sst, &
        &   reflectiondata, temporaryderivatives)
        implicit none
        real, intent(out) :: tc, sst
        real, dimension(:), intent(inout) :: reflectiondata
        double precision, dimension(:), intent(out) :: temporaryderivatives
    end subroutine
end interface

interface
    subroutine xab2fc(reflectiondata, scalew, partialderivatives,temporaryderivatives)
        implicit none
        real, intent(in) :: scalew
        real, dimension(:), intent(inout) :: reflectiondata
        double precision, dimension(:), intent(out) :: partialderivatives
        double precision, dimension(:), intent(in) :: temporaryderivatives
    end subroutine
end interface

interface
    integer function KFNRnew(L6W, N6W, reflectiondata) 
    implicit none
    integer, intent(inout) :: l6w, n6w
    real, dimension(:), intent(out) :: reflectiondata
    end function
end interface

!> Index in the variance/covariance matrix corresponding to the parameter to study
integer, intent(in) :: parameterindex
!> error code of the subroutine, 0 = no error
integer, intent(out) :: errcode

integer :: tid
integer, parameter :: storechunk=128
character(len=4) :: buffer

!> array holding the derivatives against each parameter
double precision, dimension(:), allocatable :: temporaryderivatives

real, dimension(:,:), allocatable :: reflectionsdata 
real, dimension(:,:), allocatable :: varcovarmatrix
real, dimension(:,:), allocatable :: temp2d
real, dimension(:), allocatable :: tempvec
double precision, dimension(:), allocatable :: designmatrix
! Number of reflections stores in the reflectionsdata buffer
integer reflectionsdata_size
! Current index in the reflectionsdata buffer
integer reflectionsdata_index
!> Number of parameters
integer num_parameters
real scalew, tc, sst, scaleo
real numerator, denominator
integer n6w, l6w, i, j, k, ifnr, currentchunk

integer, external :: kexist, KSET53, ktyp06, kspini, KCHNFL, kspget
integer iuln, ityp06,IUPDAT, nupdat, igstat, m5, mgm
real stoler


errcode=0

print *, 'kexist1', kexist(1)
print *, 'kexist2', kexist(2)
print *, 'kexist3', kexist(3)
print *, 'kexist5', kexist(5)
print *, 'kexist6', kexist(6)
print *, 'kexist11', kexist(11)
print *, 'kexist12', kexist(12)
print *, 'Loading 01'
call xfal01
print *, 'Loading 02'
call xfal02
print *, 'Loading 05 before 03'
call xfal05

print *, 'Loading 23'
call xfal23
STOLER = STORE(L23SP+5)

!print *, 'Loading 30'
!CALL XFAL30
!IF (IERFLG .LT. 0) then
!    print *, 'Error loading 30'
!end if


      IF (IUPDAT .GE. 0)  I = KSPINI( -1, STOLER) ! SET THE OCCUPANCIES
      NUPDAT = 0  
      J =NFL
      I = KCHNFL(40)  ! SAVE SOME WORK SPACE
      M5 = L5
      DO I = 1, N5   ! Set occupancies
        IF (IUPDAT .GE. 0) THEN
          IGSTAT =KSPGET ( STORE(J), STORE(J+10), ISTORE(J+20), &
          & STORE(J+30), MGM, M5, IUPDAT, NUPDAT)
        ELSE
          STORE(M5+13) = 1.0
        ENDIF
        M5 = M5 + MD5
      END DO
      NFL= J

print *, 'Loading 03 (depends on 30?)'
call xfal03
print *, 'here'
ITYP06=1
 IULN = KTYP06(ITYP06)  ! FIND THE REFELCTIONLIST TYPE
print *, 'Loading 06'
 CALL XFAL06(IULN,1)

!print *, 'Loading 11'
!      CALL XFAL11(1,1)
      
!C--SET THE ANOMALOUS DISPERSION FLAG
!C SET TO -1 FOR NO ANOMALOUS DISPERSION, ELSE 0 Replaced by ANOMAL      
      ANOMAL = .FALSE.
      IF ( ISTORE(L23M) .EQ. 0 ) ANOMAL = .TRUE.

jq=(2-ic)  ! set up the storage locations for the partial derivatives
if ( anomal ) jq = jq * 2
jq=max(jq,2)

print *, 'Loading 12'
call xfal12(-1,JQ,JR,JN)  ! LOAD LIST 12
N3=KSET53(0)+1
!print *, 'm5a, istore(m5a)', m5a, istore(m5a)

!C--BRING DOWN THE MATRIX
CALL XFAL11(1,1)
print *, 'error xfal11', IERFLG
if(IERFLG<0) return

if(allocated(leverage_results%tvalues)) then
    errcode=1 ! Calculation already done previously
    return
end if

!     Working out the number of threads available
tid=1
!$    tid =  omp_get_max_threads() 

!     To be replaced by GET_ENVIRONMENT_VARIABLE f2003 feature
!     getenv is a deprecated extension      
#if defined(_OPENMP)
CALL GETENV('OMP_NUM_THREADS', buffer) 
if(buffer/='    ') then
    read(buffer, '(I4)') i
    if(i>0) then
        tid=i
    end if
end if
#endif

allocate(reflectionsdata(MD6+11,storechunk*tid))
reflectionsdata=0.0

num_parameters=N12
print *, 'num_parameters', num_parameters
allocate(varcovarmatrix(num_parameters, num_parameters))
allocate(tempvec(num_parameters))
do i=1, num_parameters
    j = ((i-1)*(2*(num_parameters)-i+2))/2
    k = j + num_parameters - i
    varcovarmatrix(i:num_parameters, i)=STR11(l11+j:l11+k)
    varcovarmatrix(i, i+1:num_parameters)=STR11(l11+j+1:l11+k)
end do

!----- OVERALL SCALE
SCALEO=STORE(L5O)

reflectionsdata_size=storechunk*tid
currentchunk=-1
do WHILE (reflectionsdata_size==storechunk*tid)  ! START OF THE LOOP OVER REFLECTIONS
    currentchunk=currentchunk+1
    
    ! Prefectching a bunch of reflections. Number depends on the number of threads
    ! It is a multiple of storechunk
    reflectionsdata_size=0
    do while(reflectionsdata_size<storechunk*tid)
        reflectionsdata_size=reflectionsdata_size+1
        ifNR = KFNRnew(l6w, n6w, reflectionsdata(1:md6,reflectionsdata_size))
        if(ifnr<0) then
            reflectionsdata_size=reflectionsdata_size-1
            exit
        end if
    end do

    ! Case when number of reflections is exactly a multiple of the buffer
    if(reflectionsdata_size==0) cycle
    
    if(.not. allocated(leverage_results%tvalues)) then
        allocate(leverage_results%tvalues(4,storechunk*tid))
    else
        ! extend current array
        if(allocated(temp2d)) deallocate(temp2d)
        allocate(temp2d(4, ubound(leverage_results%tvalues,2)))
        temp2d=leverage_results%tvalues
        deallocate(leverage_results%tvalues)
        allocate(leverage_results%tvalues(4, ubound(temp2d,2)+storechunk*tid))
        leverage_results%tvalues(:, 1:ubound(temp2d,2))=temp2d
        leverage_results%tvalues(:, ubound(temp2d,2):ubound(leverage_results%tvalues,2))=0.0
    end if

    

    !  SCALEO  THE OVERALL SCALE FACTOR FROM LIST 5.
    !          'SCALEO' IS ASSUMED NOT TO BE ZERO.
    !  SCALEK  THE OVERALL /FO/ SCALE FACTOR (=1.0/SCALEG, UNLESS
    !          'SCALEG' IS ZERO, WHEN 'SCALEK' IS SET TO 1.0). - =1.0/scaleo
    !  SCALEW  SCALEG*W - =scaleo*w

    !$OMP PARALLEL default(none)&
    !$OMP& shared(reflectionsdata, n12, tid, currentchunk, leverage_results) &
    !$OMP& shared(parameterindex, num_parameters, varcovarmatrix, scaleo) &
    !$OMP& shared(reflectionsdata_size, jq) &
    !$OMP& private(scalew, temporaryderivatives, numerator, denominator, tempvec) &
    !$OMP& private(designmatrix, tc, sst)

    if(allocated(temporaryderivatives)) deallocate(temporaryderivatives)
    allocate(temporaryderivatives(n12*jq))
    if(allocated(designmatrix)) deallocate(designmatrix)
    allocate(designmatrix(n12))

    !$OMP DO schedule(dynamic, 32)
    do reflectionsdata_index=1, reflectionsdata_size

        call XSFLSX(tc, sst, reflectionsdata(:,reflectionsdata_index), temporaryderivatives)
        
        !FO=reflectionsdata(1+3,reflectionsdata_index) ! SET UP /FO/ ETC. FOR THIS REFLECTION
        !W=reflectionsdata(1+4,reflectionsdata_index) 
        ! scalew = scaleg * w
        SCALEW=SCALEO*reflectionsdata(1+4,reflectionsdata_index) 
        call XAB2FC(reflectionsdata(:,reflectionsdata_index), scalew, &
        &   designmatrix, temporaryderivatives)  ! DERIVE THE TOTALS AGAINST /FC/ FROM THOSE W.R.T. A AND B

        ! V_old tr(z_i)
        !call SSYMV('L', num_parameters, 1.0, varcovarmatrix, num_parameters, &
        !&   real(designmatrix, kind(1.0)), 1, 0.0, tempvec, 1)
        TEMPVEC=MATMUL(varcovarmatrix, real(designmatrix, kind(1.0)))
        ! 1.0 + z_i [V_old tr(z_i)]
        denominator = 1.0 + dot_product(designmatrix, tempvec)

        ! (V_old tr(z_i) z_i V_old) for only one parameter
        ! dot_product(V_old_jrow, z_i)**2
        numerator = dot_product(varcovarmatrix(:,parameterindex), &
        &   designmatrix)**2

        leverage_results%tvalues(1:3,currentchunk*storechunk*tid+reflectionsdata_index)=reflectionsdata(1:3, reflectionsdata_index)
        leverage_results%tvalues(4,currentchunk*storechunk*tid+reflectionsdata_index)=numerator/denominator
    end do
    !$OMP END DO
    
    !$OMP END PARALLEL    
end do


print *, 'End  leverage'
end subroutine

end module
