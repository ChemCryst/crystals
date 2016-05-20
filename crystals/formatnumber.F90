! The module formatnumbers_mod contains subroutine to handle number formating as xxx(yy)
module formatnumber_mod

private print_value_sp, print_value_dp

interface print_value
    module procedure print_value_sp, print_value_dp
end interface

contains

!> Format a number with its esd (single precision)
function print_value_sp(num, esd, opt_fixedform, opt_precision, opt_length) result(formatted_output)
implicit none
real, intent(in) :: num, esd
!> flag to outuput fixed format (leading space for minus sign)
logical, optional, intent(in) :: opt_fixedform
!> number of digit to keep for the esd
integer, optional, intent(in) :: opt_precision
!> fix a length for the return of the value. Padded with blanks
integer, optional, intent(in) :: opt_length
character(len=:), allocatable :: formatted_output
character(len=1024) :: buffer
integer digit, total, digitesd
character(len=256) :: formatstr
logical fixedform

if(esd<0.0) then
    print *, 'print_value_sp, negative esd'
    call abort()
end if

if(present(opt_length)) then
    if(opt_length>1024) then
        print *, 'Error: overflow of string buffer'
        call abort()
    end if
end if

fixedform=.false.
if(present(opt_fixedform)) then
    if(opt_fixedform) then        
        fixedform=.true.
    end if
end if

if(present(opt_precision)) then
    digitesd=opt_precision
else
    digitesd=2
end if

if(esd>=10.0) then
    if(fixedform .and. num>0.0) then
        write(buffer, "(' ',I0,'(',I0,')')") nint(num), ceiling(esd)
    else
        write(buffer, "(I0,'(',I0,')')") nint(num), ceiling(esd)
    end if
else if(esd>=1.0) then
    ! rule of 19
    if(ceiling(esd*10.0)>2*10**(digitesd-1)-1) then
        if(fixedform .and. num>0.0) then
            write(buffer, "(' ',I0,'(',I0,')')") nint(num), ceiling(esd)
        else
            write(buffer, "(I0,'(',I0,')')") nint(num), ceiling(esd)
        end if
    else
        if(fixedform .and. num>0.0) then
            write(buffer, "(' ',F0.1,'(',I0,')')") num, ceiling(esd*10.0)
        else
            write(buffer, "(F0.1,'(',I0,')')") num, ceiling(esd*10.0)
        end if
    end if
else
    digit=ceiling(-log10(esd))-1
    ! rule of 19
    if(esd*10**(digit+digitesd)>2*10**(digitesd-1)-1) then
        digitesd=digitesd-1
    end if
    digitesd=max(1, digitesd)
    if(fixedform) then
        if(abs(num)<1.0) then
            total=digit+digitesd+4
        else
            total=digit+digitesd+3+nint(log10(abs(num)))
        end if
    else
        total=0
    end if
    
    write(formatstr, "(a,I0,a,I0,a)") '(F',total,'.',digit+digitesd, "'(',I0,')')"
    write(buffer, formatstr) num, ceiling(esd*10**(digit+digitesd))
end if

if(present(opt_length)) then
    allocate(character(len=opt_length) :: formatted_output)
    formatted_output=buffer(1:opt_length)
else
    allocate(character(len=len_trim(buffer)) :: formatted_output)
    formatted_output=trim(buffer)
end if

end function

!> Format a number with its esd (double precision)
function print_value_dp(num, esd, opt_fixedform, opt_precision, opt_length) result(formatted_output)
implicit none
double precision, intent(in) :: num, esd
!> flag to outuput fixed format (leading space for minus sign)
logical, optional, intent(in) :: opt_fixedform
!> number of digit to keep for the esd
integer, optional, intent(in) :: opt_precision
!> fix a length for the return of the value. Padded with blanks
integer, optional, intent(in) :: opt_length
character(len=:), allocatable :: formatted_output
character(len=1024) :: buffer
integer digit, total, digitesd
character(len=256) :: formatstr
logical fixedform

if(esd<0.0) then
    print *, 'print_value_sp, negative esd'
    call abort()
end if

if(present(opt_length)) then
    if(opt_length>1024) then
        print *, 'Error: overflow of string buffer'
        call abort()
    end if
end if

fixedform=.false.
if(present(opt_fixedform)) then
    if(opt_fixedform) then        
        fixedform=.true.
    end if
end if

if(present(opt_precision)) then
    digitesd=opt_precision
else
    digitesd=2
end if

if(esd>=10.0) then
    if(fixedform .and. num>0.0) then
        write(buffer, "(' ',I0,'(',I0,')')") nint(num), ceiling(esd)
    else
        write(buffer, "(I0,'(',I0,')')") nint(num), ceiling(esd)
    end if
else if(esd>=1.0) then
    ! rule of 19
    if(ceiling(esd*10.0)>2*10**(digitesd-1)-1) then
        if(fixedform .and. num>0.0) then
            write(buffer, "(' ',I0,'(',I0,')')") nint(num), ceiling(esd)
        else
            write(buffer, "(I0,'(',I0,')')") nint(num), ceiling(esd)
        end if
    else
        if(fixedform .and. num>0.0) then
            write(buffer, "(' ',F0.1,'(',I0,')')") num, ceiling(esd*10.0)
        else
            write(buffer, "(F0.1,'(',I0,')')") num, ceiling(esd*10.0)
        end if
    end if
else
    digit=ceiling(-log10(esd))-1
    ! rule of 19
    if(esd*10**(digit+digitesd)>2*10**(digitesd-1)-1) then
        digitesd=digitesd-1
    end if
    digitesd=max(1, digitesd)
    if(fixedform) then
        if(abs(num)<1.0) then
            total=digit+digitesd+4
        else
            total=digit+digitesd+3+nint(log10(abs(num)))
        end if
    else
        total=0
    end if
    
    write(formatstr, "(a,I0,a,I0,a)") '(F',total,'.',digit+digitesd, "'(',I0,')')"
    write(buffer, formatstr) num, ceiling(esd*10**(digit+digitesd))
end if

if(present(opt_length)) then
    allocate(character(len=opt_length) :: formatted_output)
    formatted_output=buffer(1:opt_length)
else
    allocate(character(len=len_trim(buffer)) :: formatted_output)
    formatted_output=trim(buffer)
end if

end function

end module
