!> Additional subroutine for list 12
!!
!! For now this object only complements the original storage in the dsc and this new information is not saved and must be computed everytime.
module list12_mod
implicit none

type param_t !< Type holding the description of a least square parameter
    integer index !< index of the refinable parameter
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
use store_mod, only: store
use xlst05_mod, only: l5, md5
use xlst12_mod, only: L12O, L12LS, L12ES, L12BS, L12CL, L12PR, L12EX ! addresses of different scales
use xscale_mod, only: KSCAL ! constant defined in preset
use xopk_mod, only: kvp ! constant defined in preset
use xapk_mod, only: icoord, nkao ! constant defined in preset
use xconst_mod, only: nowt ! constant
implicit none

integer IADDL,IADDR,IADDD
character(len=1024) :: formatstr
integer ilebp, js, jt, ju, jv, jw, na
integer, dimension(:), allocatable :: istore
type(param_t), dimension(:), allocatable, intent(out) :: parameters_list !< List of least squares parameters

integer m5, m12, l12a, md12a ! not using variables from common block. it is unnecessary and could cause side effects
integer, dimension(6) :: scales ! addresses of scales whose order matches kscal

integer, external :: khuntr

    allocate(istore(size(store)))
    istore=transfer(store, istore)

!C  L12LS   ADDRESS OF THE ENTRY FOR THE LAYER SCALES
!C  L12ES   ADDRESS OF THE ELEMENT SCALES
!C  L12BS   THE ADDRESS OF THE BATCH SCALE FACTORS.
!C  L12CL   THE ADDRESS OF THE CELL PARAMETERS
!C  L12PR   THE ADDRESS OF THE PROFILE PARAMETERS
!C  L12EX   THE ADDRESS OF THE EXTINCTION PARAMETERS
    scales = (/L12LS, L12ES, L12BS, L12CL, L12PR, L12EX/)

    ! Check if list 5 is loaded
    IF (KHUNTR (5,0, IADDL,IADDR,IADDD,-1) /= 0) then
      print *, 'Error, list 5 not loaded'
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

                    IF ( ILEBP .EQ. 1 ) THEN
                        call extend_parameters(parameters_list)
                        write(formatstr, '(A)') KSCAL(:,NA+2)
                        parameters_list(size(parameters_list))%index=JT
                        parameters_list(size(parameters_list))%name=trim(formatstr)
                        parameters_list(size(parameters_list))%offset=M5

!C--CHECK IF THIS IS AN OVERALL PARAMETER
                    ELSE IF (M12.EQ.L12O) THEN
                        call extend_parameters(parameters_list)
                        write(formatstr, '(100A)') KVP(:,JS)
                        parameters_list(size(parameters_list))%index=JT
                        parameters_list(size(parameters_list))%name=trim(formatstr)
                        parameters_list(size(parameters_list))%offset=M5
                    ELSE  
!C-C-C-DISTINCTION BETWEEN ANISO'S AND ISO/SPECIAL'S FOR PRINT
                        IF((STORE(M5+3) .GE. 1.0) .AND. (JS .GE. 8)) THEN
                            call extend_parameters(parameters_list)
                            write(formatstr, '(100A)') ICOORD(:,JS+NKAO)
                            parameters_list(size(parameters_list))%index=JT
                            parameters_list(size(parameters_list))%label=transfer(STORE(M5), 'aaaa')
                            if(isnan(STORE(M5+1))) then
                                parameters_list(size(parameters_list))%serial= -1
                            else
                                parameters_list(size(parameters_list))%serial=NINT(STORE(M5+1))
                            end if
                            parameters_list(size(parameters_list))%name=trim(formatstr)
                            parameters_list(size(parameters_list))%offset=M5
                        ELSE
                            call extend_parameters(parameters_list)
                            write(formatstr, '(100A)') ICOORD(:,JS)
                            parameters_list(size(parameters_list))%index=JT
                            parameters_list(size(parameters_list))%label=transfer(STORE(M5), 'aaaa')
                            if(isnan(STORE(M5+1))) then
                                parameters_list(size(parameters_list))%serial= -1
                            else
                                parameters_list(size(parameters_list))%serial=NINT(STORE(M5+1))
                            end if
                            parameters_list(size(parameters_list))%name=trim(formatstr)
                            parameters_list(size(parameters_list))%offset=M5
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
    isize=1
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

object(newstart:)%index=-99 !< Index of the parameter
object(newstart:)%label='' !< label of the atom
object(newstart:)%serial=-1 !< serial number of the atom
object(newstart:)%name='' !< Name of the parameter
end subroutine

!> print the content of a parameter
subroutine printparam(self)
implicit none
class(param_t), intent(in) :: self

write(*,'(I5,1X,I6,1X,A,"(",I0,")",1X,A)') self%index, self%offset, trim(self%label), self%serial, trim(self%name)

end subroutine


end module
