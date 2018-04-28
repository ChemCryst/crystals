!> Dictionary handling the call of the correct subroutine depending on the shelx keyword
module shelx_keywords_dict_m

!> Typical interface used when calling the subroutines
!! All the subroutines have the same interface
abstract interface
    subroutine shelx_dummy(shelxline)
    use crystal_data_m, only: line_t
    type(line_t), intent(in) :: shelxline
    end subroutine shelx_dummy
end interface

!> a tuple of the dictionary
type tuple_t
    character(len=4) :: key !< shelx keyword
    procedure(shelx_dummy), pointer, nopass :: func !< corresponding subroutine
end type

!> The dictionnary containing all the tuples
type dict_t
    type(tuple_t), dimension(:), allocatable :: tuples
contains
    procedure, pass(this) :: getvalue !< Get the subroutine corresponding to a keyword
end type

!> Constructor filling up the dictionnary
interface dict_t
    procedure constructor
end interface

contains 

!> Constructor filling up the dictionnary
function constructor() result(this)
use shelx_procedures_m
implicit none
type(dict_t) :: this
    
    allocate(this%tuples(80))
    associate (tuples => this%tuples)
        tuples(1)%key='ABIN'
        tuples(1)%func => shelx_abin
        tuples(2)%key='ACTA'
        tuples(2)%func => shelx_ignored
        tuples(3)%key='AFIX'
        tuples(3)%func => shelx_unsupported    
        tuples(4)%key='ANIS'
        tuples(4)%func => shelx_unsupported    
        tuples(5)%key='ANSC'
        tuples(5)%func => shelx_unsupported    
        tuples(6)%key='ANSR'
        tuples(6)%func => shelx_unsupported    
        tuples(7)%key='BASF'
        tuples(7)%func => shelx_unsupported    
        tuples(8)%key='BIND'
        tuples(8)%func => shelx_unsupported    
        tuples(9)%key='BLOC'
        tuples(9)%func => shelx_unsupported    
        tuples(10)%key='BOND'
        tuples(10)%func => shelx_ignored    
        tuples(11)%key='BUMP'
        tuples(11)%func => shelx_unsupported    
        tuples(12)%key='CELL'
        tuples(12)%func => shelx_cell
        tuples(13)%key='CGLS'
        tuples(13)%func => shelx_unsupported    
        tuples(14)%key='CHIV'
        tuples(14)%func => shelx_unsupported    
        tuples(15)%key='CONF'
        tuples(15)%func => shelx_ignored    
        tuples(16)%key='CONN'
        tuples(16)%func => shelx_unsupported    
        tuples(17)%key='DAMP'
        tuples(17)%func => shelx_unsupported    
        tuples(18)%key='DANG'
        tuples(18)%func => shelx_dfix    
        tuples(19)%key='DEFS'
        tuples(19)%func => shelx_unsupported    
        tuples(20)%key='DELU'
        tuples(20)%func => shelx_unsupported    
        tuples(21)%key='DFIX'
        tuples(21)%func => shelx_dfix
        tuples(22)%key='DISP'
        tuples(22)%func => shelx_disp    
        tuples(23)%key='EADP'
        tuples(23)%func => shelx_eadp
        tuples(24)%key='END '
        tuples(24)%func => shelx_end
        tuples(25)%key='EQIV'
        tuples(25)%func => shelx_unsupported    
        tuples(26)%key='EXTI'
        tuples(26)%func => shelx_unsupported    
        tuples(27)%key='EXYZ'
        tuples(27)%func => shelx_unsupported    
        tuples(28)%key='FEND'
        tuples(28)%func => shelx_unsupported    
        tuples(29)%key='FLAT'
        tuples(29)%func => shelx_flat
        tuples(30)%key='FMAP'
        tuples(30)%func => shelx_ignored    
        tuples(31)%key='FRAG'
        tuples(31)%func => shelx_unsupported    
        tuples(32)%key='FREE'
        tuples(32)%func => shelx_unsupported    
        tuples(33)%key='FVAR'
        tuples(33)%func => shelx_fvar    
        tuples(34)%key='GRID'
        tuples(34)%func => shelx_unsupported    
        tuples(35)%key='HFIX'
        tuples(35)%func => shelx_unsupported    
        tuples(36)%key='HKLF'
        tuples(36)%func => shelx_hklf    
        tuples(37)%key='HTAB'
        tuples(37)%func => shelx_ignored    
        tuples(38)%key='ISOR'
        tuples(38)%func => shelx_isor
        tuples(39)%key='LATT'
        tuples(39)%func => shelx_latt    
        tuples(40)%key='LAUE'
        tuples(40)%func => shelx_unsupported    
        tuples(41)%key='LIST'
        tuples(41)%func => shelx_ignored    
        tuples(42)%key='L.S.'
        tuples(42)%func => shelx_ignored    
        tuples(43)%key='MERG'
        tuples(43)%func => shelx_ignored    
        tuples(44)%key='MORE'
        tuples(44)%func => shelx_ignored    
        tuples(45)%key='MOVE'
        tuples(45)%func => shelx_unsupported    
        tuples(46)%key='MPLA'
        tuples(46)%func => shelx_unsupported    
        tuples(47)%key='NCSY'
        tuples(47)%func => shelx_unsupported    
        tuples(48)%key='NEUT'
        tuples(48)%func => shelx_unsupported    
        tuples(49)%key='OMIT'
        tuples(49)%func => shelx_unsupported    
        tuples(50)%key='PART'
        tuples(50)%func => shelx_part    
        tuples(51)%key='PLAN'
        tuples(51)%func => shelx_ignored    
        tuples(52)%key='PRIG'
        tuples(52)%func => shelx_unsupported    
        tuples(53)%key='REM '
        tuples(53)%func => shelx_ignored    
        tuples(54)%key='RESI'
        tuples(54)%func => shelx_resi
        tuples(55)%key='RIGU'
        tuples(55)%func => shelx_rigu
        tuples(56)%key='RTAB'
        tuples(56)%func => shelx_unsupported    
        tuples(57)%key='SADI'
        tuples(57)%func => shelx_sadi
        tuples(58)%key='SAME'
        tuples(58)%func => shelx_same    
        tuples(59)%key='SFAC'
        tuples(59)%func => shelx_sfac
        tuples(60)%key='SHEL'
        tuples(60)%func => shelx_unsupported    
        tuples(61)%key='SIMU'
        tuples(61)%func => shelx_unsupported    
        tuples(62)%key='SIZE'
        tuples(62)%func => shelx_unsupported    
        tuples(63)%key='SPEC'
        tuples(63)%func => shelx_unsupported    
        tuples(64)%key='STIR'
        tuples(64)%func => shelx_unsupported    
        tuples(65)%key='SUMP'
        tuples(65)%func => shelx_unsupported    
        tuples(66)%key='SWAT'
        tuples(66)%func => shelx_unsupported    
        tuples(67)%key='SYMM'
        tuples(67)%func => shelx_symm    
        tuples(68)%key='TEMP'
        tuples(68)%func => shelx_unsupported    
        tuples(69)%key='TITL'
        tuples(69)%func => shelx_titl    
        tuples(70)%key='TWIN'
        tuples(70)%func => shelx_unsupported    
        tuples(71)%key='TWST'
        tuples(71)%func => shelx_unsupported    
        tuples(72)%key='UNIT'
        tuples(72)%func => shelx_unit    
        tuples(73)%key='WGHT'
        tuples(73)%func => shelx_unsupported    
        tuples(74)%key='WIGL'
        tuples(74)%func => shelx_unsupported    
        tuples(75)%key='WPDB'
        tuples(75)%func => shelx_ignored    
        tuples(76)%key='XNPD'
        tuples(76)%func => shelx_unsupported    
        tuples(77)%key='ZERR'
        tuples(77)%func => shelx_zerr    
        tuples(78)%key='TIME'
        tuples(78)%func => shelx_deprecated    
        tuples(79)%key='HOPE'
        tuples(79)%func => shelx_deprecated    
        tuples(80)%key='MOLE'
        tuples(80)%func => shelx_deprecated    
    end associate
    
end function

!> Get the subroutine corresponding to a keyword
subroutine getvalue(this, key, proc)
implicit none
class(dict_t) :: this
character(len=4), intent(in) :: key
procedure(shelx_dummy), pointer, intent(out) :: proc
integer i
    
    proc => null()
    if(.not. allocated(this%tuples)) then
        print *, 'Error: Dictionary not initialized!'
        call abort()
    end if
    associate (tuples => this%tuples)
        do i=1, size(tuples)
            if(key==tuples(i)%key) then
                proc => tuples(i)%func
                exit
            end if
        end do
    end associate
    
end subroutine


end module
