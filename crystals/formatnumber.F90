! The module formatnumbers_mod contains subroutine to handle number formating as xxx(yy)
module formatnumbers_mod

private print_value_sp, print_value_dp

interface print_value
    module procedure print_value_sp, print_value_dp
end interface

contains

!> Format a number with its esd (single precision)
function print_value_sp(num, esd) result(formatted_output)
implicit none
real, intent(in) :: num, esd
character(len=:), allocatable :: formatted_output
character(len=1024) :: buffer
integer digit
character(len=256) :: formatstr

if(esd<0.0) then
    print *, 'negative esd'
    stop
end if

if(esd>=1.0) then
    write(buffer, "(I0,'(',I0,')')") nint(num), ceiling(esd)
else
    digit=ceiling(-log10(esd))
    write(formatstr, "(a,I0,a)") '(F0.',digit+1, "'(',I0,')')"
    write(buffer, formatstr) num, ceiling(esd*10**(digit+1))
end if

allocate(character(len=len_trim(buffer)) :: formatted_output)
formatted_output=trim(buffer)

end function

!> Format a number with its esd (double precision)
function print_value_dp(num, esd) result(formatted_output)
implicit none
double precision, intent(in) :: num, esd
character(len=:), allocatable :: formatted_output
character(len=1024) :: buffer
integer digit
character(len=256) :: formatstr

if(esd<0.0) then
    print *, 'negative esd'
    stop
end if

if(esd>=1.0) then
    write(buffer, "(I0,'(',I0,')')") nint(num), ceiling(esd)
else
    digit=ceiling(-log10(esd))
    write(formatstr, "(a,I0,a)") '(F0.',digit+1, "'(',I0,')')"
    write(buffer, formatstr) num, ceiling(esd*10**(digit+1))
end if

allocate(character(len=len_trim(buffer)) :: formatted_output)
formatted_output=trim(buffer)

end function

end module
