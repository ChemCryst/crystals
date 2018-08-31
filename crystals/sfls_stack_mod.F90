module sfls_stack_mod

type hkl_indices_t
    integer :: h,k,l
    real pshift
end type

type stack_t
    real, dimension(:), allocatable :: derivatives ! +1:+2 size(n12)
    integer, dimension(3) :: hkl ! +3:+5
    real :: Fcalc ! +6
    real :: Phase ! +7
    integer :: element ! +8
    type(hkl_indices_t), dimension(:), allocatable :: hkl ! +9:+10 size(n2t-1)
    real :: pshift ! +11
    real :: fried ! +12
    real :: acr ! +13
    real :: aci ! +14
    real :: bcr ! +15
    real :: bci ! +16
    real, dimension(:), allocatable :: derivatives_temp ! +18:+19 size(n12)
    integer :: batch ! +20 (store(m6+13))
    
end type
type(stack_t), dimension(:), allocatable :: stack


end module
