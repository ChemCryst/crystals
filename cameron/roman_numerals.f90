! Contributed by Jeanne T. Martin, LLNL

module roman_numerals

implicit type(roman) (c, i, r)

type roman
  private
  integer                          :: value
  character, dimension(:), pointer :: as_seen
end type roman

interface assignment (=)
  module procedure r_ass_i, r_ass_c, c_ass_r, i_ass_r
end interface

interface len
  module procedure rom_len
end interface

interface int
  module procedure rom_int
end interface

interface roman_number
  module procedure roman_number_i, roman_number_c
end interface

interface operator (+)
  module procedure rom_a_rom, int_a_rom, rom_a_int, ch_a_rom, rom_a_ch
end interface

interface operator (-)
   module procedure rom_s_rom, int_s_rom, rom_s_int, ch_s_rom, rom_s_ch
end interface

interface operator (*)
   module procedure rom_m_rom, int_m_rom, rom_m_int, ch_m_rom, rom_m_ch
end interface

interface operator (/)
   module procedure rom_d_rom, int_d_rom, rom_d_int, ch_d_rom, rom_d_ch
end interface

interface operator (==)
   module procedure rom_eq_rom, int_eq_rom, rom_eq_int, ch_eq_rom, rom_eq_ch
end interface

interface operator (/=)
   module procedure rom_ne_rom, int_ne_rom, rom_ne_int, ch_ne_rom, rom_ne_ch
end interface

interface operator (<)
   module procedure rom_lt_rom, int_lt_rom, rom_lt_int, ch_ne_rom, rom_ne_ch
end interface

interface operator (<=)
   module procedure rom_le_rom, int_le_rom, rom_le_int, ch_le_rom, rom_le_ch
end interface

interface operator (>)
   module procedure rom_gt_rom, int_gt_rom, rom_gt_int, ch_gt_rom, rom_gt_ch
end interface

interface operator (>=)
   module procedure rom_ge_rom, int_ge_rom, rom_ge_int, ch_ge_rom, rom_ge_ch
end interface

type(roman) temp

contains

subroutine r_ass_i (r, i)
  type(roman), intent(out) :: r
  integer, intent(in) :: i

! local variables
  integer n, j, k, u, v, l
  character pool(13), temp(16)
  integer space

! initializations
  data pool / 'M','2','D','5','C','2','L','5','X','2','V','5','I' /
  if (i <= 0 .or. i > 3999) call error_range (i)
  n = i
  v = 1000
  j = 1     ! index for pool
  l = 1     ! index for temp

! obtain roman representation
  outer: do
    inner: do
      if (n < v) exit inner
      temp(l) = pool(j)
      l = l + 1;  n = n - v
    end do inner
    if (n <= 0) exit outer
    k = j + 2
    u = v / (ichar(pool(k-1)) - ichar('0'))
    if (pool(k-1) == '2') then
      k = k + 2
      u = u / (ichar(pool(k-1)) - ichar('0'))
    end if
    if (n + u >= v) then
      temp(l) = pool(k)
      l = l + 1;  n = n + u
    else
      j = j + 2
      v = v / (ichar(pool(j-1)) - ichar('0'))
    end if  
end do outer

! perform assignment
  r % value = i
  allocate (r % as_seen(l-1), stat = space)
  if (space /= 0) then
    write (*, "(/, 'no more space', /)")
    stop
  end if
  r % as_seen = temp(1:l-1)

end subroutine r_ass_i


subroutine r_ass_c (r, ch)
  type(roman), intent(out) :: r
  character (*), intent(in) :: ch

! local variables
  integer M, D, C, L, X, V, I
  parameter (M = 1, D = 2, C = 3, L = 4, X = 5, V = 6, I = 7)
  integer convert(iachar("C"):iachar("X"))
  data convert / C, D, 0, 0, 0, 0, I, 0, 0, L, M, 0, 0, 0, 0, &
                 0, 0, 0, 0, V, 0, X /
  integer table (7, 0:9)

!                   -- state transition table --

!                M    D    C    L    X    V    I
!             ________________________________________   
  data table /   1,  12,  21,  32,  41,  52,  61, &   ! initial
                 3,   3,  21,  32,  41,  52,  61, &   ! after D
                74,  74,  21,  32,  41,  52,  61, &   ! after C
                 3,   3,   3,   3,  41,  52,  61, &   ! after L
                 3,   3,  84,  84,  41,  52,  61, &   ! after X
                 3,   3,   3,   3,   3,   3,  61, &   ! after V
                 3,   3,   3,   3,  94,  94,  61, &   ! after I
                 3,   3,   3,  32,  41,  52,  61, &   ! after CM or CD
                 3,   3,   3,   3,   3,  52,  61, &   ! after XC or XL
                 3,   3,   3,   3,   3,   3,   3  /   ! after IX or IV

  integer, dimension(7) :: addend = (/ 1000, 500, 100, 50, 10, 5, 1 /)
  integer, dimension(6) :: addend2 = (/ 800, 300, 80, 30, 8, 3 /)

  integer state, new_state, letter, count(7)

  integer rlen            ! length of roman number
  integer ix              ! loop index
  integer space           ! check available space

! initializations
  r % value = 0
  ! rlen = len_trim(ch)  ! len_trim does not work for NAG because character                   ! strings are stored with a terminal blank followed by nulls

  do ix = len(ch), 0, -1
    if (ch(ix:ix).ne.achar(0)) exit
  end do
  do rlen = ix, 0, -1
    if (ch(rlen:rlen).ne." ") exit
  end do

  if (rlen == 0)  then
    nullify (r % as_seen)
    return
  end if

  count = 0
  new_state = 0

! verify and translate roman digits to integer values
  do ix = 1, rlen
    if (ch(ix:ix) < "C" .or. ch(ix:ix) > "X") then
      call error_baddig (ch(ix:ix), r)
      return
    end if
    letter = convert (iachar(ch(ix:ix)))
    if (letter == 0) then
      call error_baddig (ch(ix:ix), r)
      return
    end if
    state = new_state
    new_state = table(letter, state)/10
    select case (mod(table(letter, state), 10))
      case (1)
        r % value = r % value + addend(letter)
        count(letter) = count(letter) + 1
        if (count(letter) > 3) then
          call error_too_many (ch(ix:ix), r)
          return
        end if
        cycle
      case (2)
        r % value = r % value + addend(letter)
        count = 0
        cycle
      case (3)
        call error_misplaced (ch(ix:ix), r)
        return
      case (4)
        r % value = r % value + addend2(letter)
        count = 0
        cycle
    end select
  end do

  allocate (r % as_seen(1:rlen), stat = space)
  if (space /= 0) then
    write (*, "(/, 'no more space', /)")
    stop
  end if
  do ix = 1, rlen
    r % as_seen(ix) = ch(ix:ix)
  end do

end subroutine r_ass_c


subroutine c_ass_r (c, r)
  character (len=*), intent(out) :: c
  type(roman), intent(in) :: r 

  integer i, ii        ! loop indices

  do i = 1, min(len(c), size(r % as_seen))
    c(i:i) = r % as_seen(i)
  enddo
  if (i <= len(c)) then
    do ii = i, len(c)
      c(ii:ii) = " "
    end do
   end if
end subroutine c_ass_r

subroutine i_ass_r (i, r)
  integer, intent(out) :: i
  type(roman), intent(in) :: r
  i = r % value
end subroutine i_ass_r

! get length of roman number
integer function rom_len (r)
  type(roman), intent(in) :: r
  rom_len = size(r % as_seen)
end function rom_len

! get integer value of roman number
integer function rom_int(r)
  type(roman), intent(in) :: r
  rom_int = r % value
end function rom_int

! get roman number of integer
function roman_number_i (i)
  integer, intent(in) :: i
  roman_number_i = i
end function roman_number_i

! get roman number of character
function roman_number_c (c)
  character (len=*), intent(in) :: c
  roman_number_c = c
end function roman_number_c


! addition
function rom_a_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  rom_a_rom = r1 % value + r2 % value
end function rom_a_rom

function int_a_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  int_a_rom = i + r % value
end function int_a_rom

function rom_a_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  rom_a_int = r % value + i
end function rom_a_int

function ch_a_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  ch_a_rom = roman_number(c) + r
end function ch_a_rom

function rom_a_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  rom_a_ch = r + roman_number(c)
end function rom_a_ch

!subtraction
function rom_s_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  rom_s_rom = r1 % value - r2 % value
end function rom_s_rom

function int_s_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  int_s_rom = i - r % value
end function int_s_rom

function rom_s_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  rom_s_int = r % value - i
end function rom_s_int

function ch_s_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  ch_s_rom = roman_number(c) - r
end function ch_s_rom

function rom_s_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  rom_s_ch = r - roman_number(c)
end function rom_s_ch

! multiplication
function rom_m_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  rom_m_rom = r1 % value * r2 % value
end function rom_m_rom

function int_m_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  int_m_rom = i * r % value
end function int_m_rom

function rom_m_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  rom_m_int = r % value * i
end function rom_m_int

function ch_m_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  ch_m_rom = roman_number(c) * r
end function ch_m_rom

function rom_m_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  rom_m_ch = r * roman_number(c)
end function rom_m_ch

! division
function rom_d_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  rom_d_rom = r1 % value / r2 % value
end function rom_d_rom

function int_d_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  int_d_rom = i / r % value
end function int_d_rom

function rom_d_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  rom_d_int = r % value / i
end function rom_d_int

function ch_d_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  ch_d_rom = roman_number(c) / r
end function ch_d_rom

function rom_d_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  rom_d_ch = r / roman_number(c)
end function rom_d_ch

! comparison - equal
logical function rom_eq_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  if (r1 % value == r2 % value) then
    rom_eq_rom = .true.
  else
    rom_eq_rom = .false.
  end if
end function rom_eq_rom

logical function int_eq_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  if (i == r % value) then
    int_eq_rom = .true.
  else
    int_eq_rom = .false.
  end if
end function int_eq_rom

logical function rom_eq_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  if (r % value == i) then
    rom_eq_int = .true.
  else
    rom_eq_int = .false.
  end if
end function rom_eq_int

logical function ch_eq_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  temp = c
  if (temp % value == r % value) then
    ch_eq_rom = .true.
  else
    ch_eq_rom = .false.
  end if
end function ch_eq_rom

logical function rom_eq_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  temp = c
  if (r % value == temp % value) then
    rom_eq_ch = .true.
  else
    rom_eq_ch = .false.
  end if
end function rom_eq_ch

! comparison -  not equal
logical function rom_ne_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  if (r1 % value /= r2 % value) then
    rom_ne_rom = .true.
  else
    rom_ne_rom = .false.
  end if
end function rom_ne_rom

logical function int_ne_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  if (i /= r % value) then
    int_ne_rom = .true.
  else
    int_ne_rom = .false.
  end if
end function int_ne_rom

logical function rom_ne_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  if (r % value /= i) then
    rom_ne_int = .true.
  else
    rom_ne_int = .false.
  end if
end function rom_ne_int

logical function ch_ne_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  temp = c
  if (temp % value /= r % value) then
    ch_ne_rom = .true.
  else
    ch_ne_rom = .false.
  end if
end function ch_ne_rom

logical function rom_ne_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  temp = c
  if (r % value /= temp % value) then
    rom_ne_ch = .true.
  else
    rom_ne_ch = .false.
  end if
end function rom_ne_ch

! comparison - less than
logical function rom_lt_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  if (r1 % value < r2 % value) then
    rom_lt_rom = .true.
  else
    rom_lt_rom = .false.
  end if
end function rom_lt_rom

logical function int_lt_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  if (i < r % value) then
    int_lt_rom = .true.
  else
    int_lt_rom = .false.
  end if
end function int_lt_rom

logical function rom_lt_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  if (r % value < i) then
    rom_lt_int = .true.
  else
    rom_lt_int = .false.
  end if
end function rom_lt_int

logical function ch_lt_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  temp = c
  if (temp % value < r % value) then
    ch_lt_rom = .true.
  else
    ch_lt_rom = .false.
  end if
end function ch_lt_rom

logical function rom_lt_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  temp = c
  if (r % value < temp % value) then
    rom_lt_ch = .true.
  else
    rom_lt_ch = .false.
  end if
end function rom_lt_ch

! comparison - less than or equal
logical function rom_le_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  if (r1 % value <= r2 % value) then
    rom_le_rom = .true.
  else
    rom_le_rom = .false.
  end if
end function rom_le_rom

logical function int_le_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  if (i <= r % value) then
    int_le_rom = .true.
  else
    int_le_rom = .false.
  end if
end function int_le_rom

logical function rom_le_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  if (r % value <= i) then
    rom_le_int = .true.
  else
    rom_le_int = .false.
  end if
end function rom_le_int

logical function ch_le_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  temp = c
  if (temp % value <= r % value) then
    ch_le_rom = .true.
  else
    ch_le_rom = .false.
  end if
end function ch_le_rom

logical function rom_le_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  temp = c
  if (r % value <= temp % value) then
    rom_le_ch = .true.
  else
    rom_le_ch = .false.
  end if
end function rom_le_ch

! comparison - greater than
logical function rom_gt_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  if (r1 % value > r2 % value) then
    rom_gt_rom = .true.
  else
    rom_gt_rom = .false.
  end if
end function rom_gt_rom

logical function int_gt_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  if (i > r % value) then
    int_gt_rom = .true.
  else
    int_gt_rom = .false.
  end if
end function int_gt_rom

logical function rom_gt_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  if (r % value > i) then
    rom_gt_int = .true.
  else
    rom_gt_int = .false.
  end if
end function rom_gt_int

logical function ch_gt_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  temp = c
  if (temp % value > r % value) then
    ch_gt_rom = .true.
  else
    ch_gt_rom = .false.
  end if
end function ch_gt_rom

logical function rom_gt_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  temp = c
  if (r % value > temp % value) then
    rom_gt_ch = .true.
  else
    rom_gt_ch = .false.
  end if
end function rom_gt_ch

! comparison - greater than or equal
logical function rom_ge_rom (r1, r2)
  type(roman), intent(in) :: r1, r2
  if (r1 % value >= r2 % value) then
    rom_ge_rom = .true.
  else
    rom_ge_rom = .false.
  end if
end function rom_ge_rom

logical function int_ge_rom (i, r)
  integer, intent(in) :: i
  type(roman), intent(in) :: r
  if (i >= r % value) then
    int_ge_rom = .true.
  else
    int_ge_rom = .false.
  end if
end function int_ge_rom

logical function rom_ge_int (r, i)
  type(roman), intent(in) :: r
  integer, intent(in) :: i
  if (r % value >= i) then
    rom_ge_int = .true.
  else
    rom_ge_int = .false.
  end if
end function rom_ge_int

logical function ch_ge_rom (c, r)
  character (*), intent(in) :: c
  type(roman), intent(in) :: r
  temp = c
  if (temp % value >= r % value) then
    ch_ge_rom = .true.
  else
    ch_ge_rom = .false.
  end if
end function ch_ge_rom

logical function rom_ge_ch (r, c)
  type(roman), intent(in) :: r
  character (*), intent(in) :: c
  temp = c
  if (r % value >= temp % value) then
    rom_ge_ch = .true.
  else
    rom_ge_ch = .false.
  end if
end function rom_ge_ch

! print roman number
subroutine print_roman (r)
  type(roman), intent(in) :: r
  if (associated(r % as_seen)) then
    write (unit=*, fmt="(16a1)", advance = "no") r % as_seen
  else
    write (unit=*, fmt="('0')", advance = "no") 
  end if
end subroutine print_roman

subroutine error_range (i)
  integer, intent(in) :: i
  write (*, "(i6, 2x, 'out of range for roman number',/)") i
end subroutine error_range

subroutine error_misplaced (c, r)  
  character, intent(in) :: c
  type(roman), intent(inout) :: r
  write (*, "('badly-formed roman number - misplaced digit ',1a,/)") c
  r % value = 0
  nullify (r % as_seen)
end subroutine error_misplaced

subroutine error_baddig (c, r)  
  character, intent(in) :: c
  type(roman), intent(inout) :: r
  write (*, "('badly-formed roman number - invalid digit ',1a,/)") c
  r % value = 0
  nullify (r % as_seen)
end subroutine error_baddig

subroutine error_too_many (c, r)
  character, intent(in) :: c
  type(roman), intent(inout) :: r
  write (*, "('badly-formed roman number - too many digits ',1a,/)") c
  r % value = 0
  nullify (r % as_seen)
end subroutine error_too_many

end module roman_numerals

program test_roman_numerals
use roman_numerals
implicit none

character (len=16) table(3999)
type(roman) r
integer i

type(roman) year_2000, cornerstone, bad_place, bad_dig, bad_dig2, long_dig, BC
type(roman) bad_place2, too_big
type(roman) errors(10), arith(5)
integer centuries, ix, iy, iz
character (len = 16) long
character (len = 3) short

! test r = i
! print table of all roman numbers, save roman values for 2nd part of test
write (*, "(' Integer  Roman Number')")
! do i = 1, 3999
  do i = 1900, 2000  ! shortened to reduce output
  r = i
  write (*, "(/, 4x, i4, 2x)", advance = "NO") i
  call print_roman (r)
  table(i) = r
end do
write (*, "(2/)")

! test r = c
! print table again converting roman to integer
write (*, "(' Integer  Roman Number', /)")
! do i = 1, 3999
  do i = 1985, 1995  ! shortened to reduce output
  r = table(i)
  write (*, "(4x, i4, 2x, 16a, /)") int(r), table(i)
end do
write (*, "(/)")

! test c = r
long = r
short = r
write (*, "(' short and long ', 2a17)")  short, long

! test i = r
ix = r
write (*, "(/,' ix = ', i4)") ix

! test len
ix = len(r)
write (*, "(' len(r) = ', i4, /)") ix

! test roman_number
iy = roman_number(25)
iz = roman_number("XXIX")
write (*, "(' iy and iz ', 2i4, /)") iy, iz


! test error procedures, arithmetic, and comparison

year_2000 = "MM"
too_big = 2 * year_2000
cornerstone = 1913
BC = -12
bad_place = "XXIC"
bad_dig = "MCM XXX III"
long_dig = "MCMXXXIII  "
write (*, "(/, 'long_dig = ')", advance = "NO")
call print_roman (long_dig)

centuries = int(cornerstone/100)
if (cornerstone.eq.1913) then
  write (*, "(/,'good .eq. test')")
else
  write (*, "(/,'bad .eq. test')")
end if
if (cornerstone == "MCMXIII") then
  write (*, "(/,'good == test')")
else
  write (*, "(/,'bad == test')")
end if
if (long_dig > 1900) then
  write (*, "(/,'good > test')")
else
  write (*, "(/,'bad > test')")
end if

bad_dig2 = "MQM"
bad_place2 = "MMIVX"


write (*, "('centuries = ', i4,/)") centuries
write (*, "('cornerstone = ')", advance = "NO")
call print_roman (cornerstone)
write (*, "(/, 'year_2000 = ')", advance = "NO")
call print_roman (year_2000)
write (*, "(/, 'bad_place = ')", advance = "NO")
call print_roman (bad_place)
write (*, "(/, 'bad_dig = ')", advance = "NO")
call print_roman (bad_dig)
write (*, "(/)")

errors(1) = "MCCCCX"
errors(2) = "MDDCX"
errors(3) = "LXIVI"
write (*, "(/, 'LXIVI = ', i4, /)") int(errors(3))
errors(4) = "LIXIV"
errors(5) = "MCMDXX"
errors(6) = "MCMXXXXI"
errors(7) = "MXLX"
write (*, "(/, 'MXLX = ', i4, /)") int(errors(7))
errors(8) = "MCMCXX"
errors(9) = "MXLXI"

arith(1) = 2
arith(2) = arith(1) * "X"
arith(3) = arith(2) / "IV"
arith(4) = arith(3) + cornerstone
arith(5) = year_2000 - "CIII"
write (*, "(/, 'arith = ', 5i6, /)") ((int(arith(i))), i = 1, 5)

end program test_roman_numerals
