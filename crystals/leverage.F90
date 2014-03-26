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
subroutine leverage(parameterindex, maxvalues, errcode)
!$ use OMP_LIB
use xlst05_mod, only: l5o
use xlst06_mod, only: md6
use xlst02_mod, only: ic
use xlst12_mod, only: n12, m12b
use store_mod, only: istore, store
use xsflsw_mod, only: anomal
use xstr11_mod, only: str11=>xstr11
use xlst11_mod, only: m11
implicit none

interface
    integer function KFNRnew(L6W, N6W, reflectiondata) 
    implicit none
    integer, intent(inout) :: l6w, n6w
    real, dimension(:), intent(out) :: reflectiondata
    end function
end interface

!> Index in the variance/covariance matrix corresponding to the parameter to study
integer, intent(in) :: parameterindex
!> Maximum reflections saved for the leverage analysis
integer, intent(in) :: maxvalues
!> error code of the subroutine, 0 = no error
integer, intent(out) :: errcode

integer :: tid
integer, parameter :: storechunk=128
character(len=4) :: buffer

!> array holding the derivatives against each parameter
double precision, dimension(:), allocatable :: temporaryderivatives

real, dimension(:,:), allocatable :: reflectionsdata 
real, dimension(:,:), allocatable :: varcovarmatrix
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
integer n6w, l6w, i, j, k, jq, ifnr, currentchunk


if(.not. allocated(leverage_results%tvalues)) then
    allocate(leverage_results%tvalues(4,maxvalues))
else
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

jq=(2-ic)  ! set up the storage locations for the partial derivatives
if ( anomal ) jq = jq * 2
jq=max(jq,2)

allocate(reflectionsdata(MD6,storechunk*tid))

num_parameters=ISTORE(M12B+1)
allocate(varcovarmatrix(num_parameters, num_parameters))
allocate(tempvec(num_parameters))
do i=1, num_parameters
    j = ((i-1)*(2*(num_parameters)-i+2))/2
    k = j + num_parameters - i
    varcovarmatrix(i:num_parameters, i)=STR11(m11+j:m11+k)
    varcovarmatrix(i, i+1:num_parameters)=STR11(m11+j+1:m11+k)
end do

!----- OVERALL SCALE
SCALEO=STORE(L5O)

reflectionsdata_size=storechunk*tid
currentchunk=-1
do WHILE (reflectionsdata_size==storechunk*tid)  ! START OF THE LOOP OVER REFLECTIONS
    currentchunk=currentchunk+1
    
    ! Prefectching a bunch of reflections. Number depends on the number of threads
    ! It is a multiple of storechunk
    do while(reflectionsdata_size<storechunk*tid)
        ifNR = KFNRnew(l6w, n6w, reflectionsdata(1:md6,reflectionsdata_size))
        if(ifnr<0) then
            reflectionsdata_size=reflectionsdata_size-1
            exit
        end if
    end do

    ! Case when number of reflections is exactly a multiple of the buffer
    if(reflectionsdata_size==0) cycle
    

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
        call SSYMV('L', num_parameters, 1.0, varcovarmatrix, num_parameters, &
        &   designmatrix, 1, 0.0, tempvec, 1.0)
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

end subroutine

end module
