!> Additional subroutine for list 12
!!
!! For now this object only complements the original storage in the dsc and this new information is not saved and must be computed everytime.
module list12_mod
implicit none

type param_t !< Type holding the description of a least square parameter
    integer, dimension(:), allocatable :: indices !< indices of the refinable parameters dependant on the physical parameter
    real, dimension(:), allocatable :: weights !< coefficient of the iths parameters listed in indices
    integer offset !< offset address in list 5
    character(len=4) :: label !< label of the atom
    integer serial !< serial of the atom
    character(len=24) :: name !< Name of the parameter
contains
    procedure, pass(self) :: print => printparam !< print the content of the object (used for debugging)
end type

private printparam, extend_parameters

contains

!> Load the least squares parameters with their name and their index in the design matrix
!!
!! The subroutine has no side effect and do not modify any global variables 
subroutine load_lsq_params(parameters_list)
implicit none

integer i, j, k, icomp, physnum, icpt
!integer, dimension(:), allocatable :: istore
type(param_t), dimension(:), allocatable, intent(out) :: parameters_list !< List of least squares parameters
type(param_t), dimension(:), allocatable :: phys_list !< List of physical parameters


    call load_phys_params(phys_list)
    
    ! count number of lsq parameters
    j=0
    do i=1, size(phys_list)
        if(allocated(phys_list(i)%indices)) then
            j=max(j,maxval(phys_list(i)%indices))
        end if
    end do
    
    allocate(parameters_list(j))
    
    icomp=0 ! index for composite variable (the lsq parameters depends on several phys parameters)
    do i=1, size(parameters_list)
        ! count number of physical parameters dependant on the ith lsq parameter
        physnum=0
        do j=1, size(phys_list)
            if(allocated(phys_list(j)%indices)) then
                do k=1, size(phys_list(j)%indices)
                    if(i==phys_list(j)%indices(k)) then
                        physnum=physnum+1
                    end if
                end do
            end if
        end do
        allocate(parameters_list(i)%indices(physnum))

        if(size(parameters_list(i)%indices)>1) then
            icomp=icomp+1
            parameters_list(i)%serial=icomp
            parameters_list(i)%label='Comp'
            parameters_list(i)%name=''
        end if
        
        icpt=0
        do j=1, size(phys_list)
            if(allocated(phys_list(j)%indices)) then
                do k=1, size(phys_list(j)%indices)
                    if(i==phys_list(j)%indices(k)) then
                        icpt=icpt+1
                        parameters_list(i)%indices(icpt)=j
                        
                        if(size(parameters_list(i)%indices)==1) then
                            parameters_list(i)%serial=phys_list(j)%serial
                            parameters_list(i)%label=phys_list(j)%label
                            parameters_list(i)%name=phys_list(j)%name
                        end if
                    end if                    
                end do
            end if
        end do
    end do
              
end subroutine

!> Load the physical parameters with their name 
!!
!! The subroutine has no side effect and do not modify any global variables 
subroutine load_phys_params(parameters_list)
use store_mod, only: store, istore => i_store, c_store
use xlst05_mod, only: l5, md5
use xlst12_mod, only: L12O, L12LS, L12ES, L12BS, L12CL, L12PR, L12EX ! addresses of different scales
use xscale_mod, only: KSCAL ! constant defined in preset
use xopk_mod, only: kvp ! constant defined in preset
use xapk_mod, only: icoord, nkao ! constant defined in preset
use xconst_mod, only: nowt ! constant
implicit none

integer IADDL,IADDR,IADDD
character(len=1024) :: formatstr
integer ilebp, js, jt, ju, jv, jw, na, i, j, k
!integer, dimension(:), allocatable :: istore
type(param_t), dimension(:), allocatable, intent(out) :: parameters_list !< List of least squares parameters
type(param_t), dimension(:), allocatable :: temp_list !< List of least squares parameters
integer :: list_index
logical found
real weight

character(len=:), dimension(:), allocatable :: list_char
character(len=24) :: tempc

integer m5, m12, l12a, md12a ! not using variables from common block. it is unnecessary and could cause side effects
integer, dimension(6) :: scales ! addresses of scales whose order matches kscal

integer, external :: khuntr

!    allocate(istore(size(store)))
!    istore=transfer(store, istore)

!C  L12LS   ADDRESS OF THE ENTRY FOR THE LAYER SCALES
!C  L12ES   ADDRESS OF THE ELEMENT SCALES
!C  L12BS   THE ADDRESS OF THE BATCH SCALE FACTORS.
!C  L12CL   THE ADDRESS OF THE CELL PARAMETERS
!C  L12PR   THE ADDRESS OF THE PROFILE PARAMETERS
!C  L12EX   THE ADDRESS OF THE EXTINCTION PARAMETERS
    scales = (/L12LS, L12ES, L12BS, L12CL, L12PR, L12EX/)

    ! Check if list 5 is loaded
    IF (KHUNTR (5,0, IADDL,IADDR,IADDD,-1) /= 0) then
!      print *, 'Error, list 5 not loaded'
      call abort() ! not loading the list, crystals very temperamental on loading it is better to let the user do it beforehand
    end if
    ! cannot check list 12. Must assume it is loaded
    !IF (KHUNTR (12,0, IADDL,IADDR,IADDD,-1) /= 0) then
    !  print *, 'Error, list 12 not loaded'
    !  call abort()
    !end if

    M5 = L5 - MD5
    M12 = L12O
    L12A = NOWT
    JS = 0
    list_index = 0
    call extend_parameters(temp_list)

    DO WHILE(M12 .GE. 0)   ! More stuff in L12
        IF(ISTORE(M12+1).GT.0) THEN ! Any refined params
!C--COMPUTE THE ADDRESS OF THE FIRST PART FOR THIS GROUP
            L12A=ISTORE(M12+1)
!C--CHECK IF THIS PART CONTAINS ANY REFINABLE PARAMETERS
            DO WHILE(L12A.GT.0) ! --CHECK IF THERE ARE ANY MORE PARTS FOR THIS ATOM OR GROUP
                IF(ISTORE(L12A+3).LT.0) EXIT
!C--SET UP THE CONSTANTS TO PASS THROUGH THIS PART
                MD12A=ISTORE(L12A+1)
                JU=ISTORE(L12A+2) 
                JV=ISTORE(L12A+3)
                JS=ISTORE(L12A+4)+1
!C--SEARCH THIS PART OF THIS ATOM
                DO JW=JU,JV,MD12A
                    JT=ISTORE(JW)
                    ILEBP = 0
                    DO NA=1,size(scales)
                        IF(scales(na).EQ.M12) THEN
!C--LAYER OR ELEMENT BATCH OR PARAMETER PRINT
                            ILEBP = 1
                            EXIT
                        END IF
                    END DO

                    if ( md12a .gt. 1 ) then
                      weight = store(jw+1)
                    else
                      weight = 1.
                    endif
                    
                    IF ( ILEBP .EQ. 1 ) THEN
                        if(list_index==size(temp_list)) then
                            call extend_parameters(temp_list)
                        end if
                        list_index=list_index+1
                        write(formatstr, '(2A)') KSCAL(:,NA+2)
                        allocate(temp_list(list_index)%indices(1))
                        allocate(temp_list(list_index)%weights(1))
                        temp_list(list_index)%weights(1)=weight
                        temp_list(list_index)%indices(1)=JT
                        temp_list(list_index)%name=trim(formatstr)
                        temp_list(list_index)%offset=M5

!C--CHECK IF THIS IS AN OVERALL PARAMETER
                    ELSE IF (M12.EQ.L12O) THEN
                        if(list_index==size(temp_list)) then
                            call extend_parameters(temp_list)
                        end if
                        list_index=list_index+1
                        write(formatstr, '(100A)') KVP(:,JS)
                        allocate(temp_list(list_index)%indices(1))
                        allocate(temp_list(list_index)%weights(1))
                        temp_list(list_index)%weights(1)=weight
                        temp_list(list_index)%indices(1)=JT
                        temp_list(list_index)%name=trim(formatstr)
                        temp_list(list_index)%offset=M5
                    ELSE  
!C-C-C-DISTINCTION BETWEEN ANISO'S AND ISO/SPECIAL'S FOR PRINT
                        IF((STORE(M5+3) .GE. 1.0) .AND. (JS .GE. 8)) THEN
                            if(list_index==size(temp_list)) then
                                call extend_parameters(temp_list)
                            end if
                            list_index=list_index+1
                            write(formatstr, '(100A)') ICOORD(:,JS+NKAO)
                            allocate(temp_list(list_index)%indices(1))
                            allocate(temp_list(list_index)%weights(1))
                            temp_list(list_index)%weights(1)=weight
                            temp_list(list_index)%indices(1)=JT
                            temp_list(list_index)%label=c_store(m5)
                            if(isnan(STORE(M5+1))) then
                                temp_list(list_index)%serial= -1
                            else
                                temp_list(list_index)%serial=NINT(STORE(M5+1))
                            end if
                            temp_list(list_index)%name=trim(formatstr)
                            temp_list(list_index)%offset=M5
                        ELSE
                            if(list_index==size(temp_list)) then
                                call extend_parameters(temp_list)
                            end if
                            list_index=list_index+1
                            write(formatstr, '(100A)') ICOORD(:,JS)
                            allocate(temp_list(list_index)%indices(1))
                            allocate(temp_list(list_index)%weights(1))
                            temp_list(list_index)%weights(1)=weight
                            temp_list(list_index)%indices(1)=JT
                            temp_list(list_index)%label=c_store(m5)
                            if(isnan(STORE(M5+1))) then
                                temp_list(list_index)%serial= -1
                            else
                                temp_list(list_index)%serial=NINT(STORE(M5+1))
                            end if
                            temp_list(list_index)%name=trim(formatstr)
                            temp_list(list_index)%offset=M5
                        ENDIF
                    ENDIF
!C
!C--INCREMENT TO THE NEXT PARAMETER OF THIS PART
                    JS=JS+1
                END DO
!C--CHANGE PARTS FOR THIS ATOM OR GROUP
                L12A=ISTORE(L12A)
            END DO
        END IF
!C--MOVE TO THE NEXT GROUP OR ATOM
        M5=M5+MD5
        M12=ISTORE(M12)
    END DO
    
! A physical parameter can be listed several times if involved with several least square parameters    
    allocate(character(len=24) :: list_char(list_index))
    k=0
    do i=1, list_index
        found=.false.
        do j=1, k
            write(tempc,'(a,I0,a)') trim(temp_list(i)%label), temp_list(i)%serial, trim(temp_list(i)%name)
            if(tempc==list_char(j)) then
                found=.true.
                exit
            end if
        end do
        if(.not. found) then
            k=k+1
            write(list_char(k),'(a,I0,a)') trim(temp_list(i)%label), temp_list(i)%serial, trim(temp_list(i)%name)
        end if
    end do
    
    ! create the final list without duplicates
    call extend_parameters(parameters_list, k)
    do i=1, k
        ! count the number of least squares parameters link to this phys parameter
        na=0
        do j=1, list_index
            write(tempc,'(a,I0,a)') trim(temp_list(j)%label), temp_list(j)%serial, trim(temp_list(j)%name)
            if(tempc==list_char(i)) then
                na=na+1
            end if
        end do
        
        ! create and merge records
        allocate(parameters_list(i)%indices(na))
        allocate(parameters_list(i)%weights(na))
        k=0
        do j=1, list_index
            write(tempc,'(a,I0,a)') trim(temp_list(j)%label), temp_list(j)%serial, trim(temp_list(j)%name)
            if(tempc==list_char(i)) then
                k=k+1
                if(k==1) then
                    parameters_list(i)%label=temp_list(j)%label
                    parameters_list(i)%serial=temp_list(j)%serial
                    parameters_list(i)%offset=temp_list(j)%offset
                    parameters_list(i)%name=temp_list(j)%name
                end if
                parameters_list(i)%indices(k)=temp_list(j)%indices(1)
                parameters_list(i)%weights(k)=temp_list(j)%weights(1)
            end if
        end do
    end do
                      
end subroutine

!> extend an array of parameters
subroutine extend_parameters(object, argsize, reset)
implicit none
type(param_t), dimension(:), allocatable, intent(inout) :: object !< object to extend
integer, optional, intent(in) :: argsize !< number of elements to add
logical, intent(in), optional :: reset !< reallocate a new object
type(param_t), dimension(:), allocatable :: temp
integer isize, newstart

if(present(argsize)) then
    isize=argsize
else
    isize=128
end if

if(present(reset)) then
    if(reset) then
        if(allocated(object)) deallocate(object)
    end if
end if

if(allocated(object)) then
    call move_alloc(object, temp)

    allocate(object(size(temp)+isize))
    object(1:size(temp)) = temp
    newstart=size(temp)+1
else
    allocate(object(isize))
    newstart=1
end if

object(newstart:)%label='' !< label of the atom
object(newstart:)%serial=-1 !< serial number of the atom
object(newstart:)%name='' !< Name of the parameter
end subroutine

!> print the content of a parameter
function printparam(self)
implicit none
class(param_t), intent(in) :: self
character(len=:), allocatable :: printparam

write(printparam, *) '[', self%indices, '] ', trim(self%label), ' ', self%serial, ' ', trim(self%name)

end function


end module
