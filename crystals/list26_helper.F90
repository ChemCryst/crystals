module list26_mod


type atom_t
    character(len=4) :: atom !< label of the atom
    integer :: serial !< serial number of the atom
    real, dimension(3,3) :: M !< Transformation matrix
    real, dimension(3) :: coordinates_crys !< coordinates in crystal system
    real, dimension(3) :: coordinates_cart !< coordinates in transformed coordinate system
    real, dimension(3,3) :: adps_crys !< adps in crystal system
    real, dimension(3,3) :: adps_cart !< adps in transformed coordinate system
    real, dimension(6) :: adps_derivatives !< derivatives of the adps
end type

type results_t
    type(atom_t), dimension(10) :: atoms
end type

end module
