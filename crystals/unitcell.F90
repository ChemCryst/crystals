!> This module holds the unit cell parameters and related values
!! 
!! \par List of old adresses in STORE
!! - L1P1,M1P1,MD1P1,N1P1 unit cell parameters
!! - L1P2,M1P2,MD1P2,N1P2 reciprocal unit cell parameters
!! - L1M1,M1M1,MD1M1,N1M1 REAL METRIC TENSOR, INCLUDING AND EXCLUDING THE CELL PARAMETERS  
!! - L1M2,M1M2,MD1M2,N1M2 RECIPROCAL METRIC TENSOR, INCLUDING AND EXCLUDING THE CELL PARAMETERS
!! - L1O1,M1O1,MD1O1,N1O1 REAL OTHOGONALISATION MATRIX, INCLUDING AND EXCLUDING THE CELL PARAMETERS
!! - L102,M1O2,MD1O2,N1O2 RECIPROCAL ORTHOGONALISATION MATRIX, INCLUDING AND EXCLUDING THE CELL PARAMETERS
!! - L1S, M1S, MD1S, N1S  THE R(II)'S AND R(IJ)'S USED TO CALCULATE SIN(THETA)/LAMBDA
!! - L1A, M1A, MD1A, N1A  ANISOTROPIC TEMPERATURE FACTOR COEFFICIENTS
!! - L1C, M1C, MD1C, N1C  CONSTANTS TO CONVERT AN ATOM FROM ISO TO ANISO

module unitcell_mod

!> Unit cell object
type, public :: t_unitcell
    integer :: status=-1 !< Status of the list
    real :: a,b,c,alpha,beta,gamma !< Cell parameters (angles in radians)
    real :: ra,rb,rc,ralpha,rbeta,rgamma !< reciprocal cell parameters (angles in radians)
contains    
    procedure, pass(this) :: set_cell
    procedure, pass(this) :: set_cella
    generic :: set => set_cell, set_cella
    procedure, pass(this) :: printall
    procedure, pass(this) :: volume
    procedure, pass(this) :: rvolume
    procedure, pass(this) :: orthogonalisation
    procedure, pass(this) :: orthogonalisation_exclcell
    procedure, pass(this) :: rorthogonalisation
    procedure, pass(this) :: rorthogonalisation_exclcell
    procedure, pass(this) :: rmetric
    procedure, pass(this) :: rmetric_exclcell
    procedure, pass(this) :: metric
    procedure, pass(this) :: metric_exclcell
    procedure, pass(this) :: Rij ! L1S
    procedure, pass(this) :: Rij_linear ! L1S
    procedure, pass(this) :: adp_coefs ! L1A
    procedure, pass(this) :: iso_to_aniso ! L1C
    procedure, pass(this) :: gumtrx_adps ! GUMTRX(19:27)
end type

!> Set the direct cell and reciprocal given either cell (generic interface of ::set_cell, ::set_cella)
interface set
	module procedure set_cell, set_cella
end interface
    
private set_cell, set_cella

type(t_unitcell), dimension(:), allocatable :: unitcells

contains

!> Alias of ::set_cell with array input
subroutine set_cella(this, cell, celltype)
    implicit none
    class(t_unitcell) :: this
    real, dimension(6), intent(in) :: cell
    integer, intent(in), optional :: celltype
    
    call set_cell(this, cell(1),cell(2),cell(3),cell(4),cell(5),cell(6), celltype)
        
end subroutine

!> Set the direct cell and reciprocal given either cell
subroutine set_cell(this, a,b,c,alpha,beta,gamma, celltype)
	use math_mod
    implicit none
    class(t_unitcell) :: this
    real, intent(in) :: a,b,c,alpha,beta,gamma
    real, dimension(3,3) :: rmetric
    integer, optional, intent(in) :: celltype !< Values below zero denotes a real cell in input
    logical :: directcell
    ! temporary angles for conversions
    real talpha, tbeta, tgamma
    
    if(present(celltype)) then
		if(celltype<=0) then
			directcell=.true.
		else
			directcell=.false.
		end if
	else
		! Guessing if it is a direct cell or reciprocal cell
		if(a>1.0 .and. b>1.0 .and. c>1.0) then
			directcell=.true.
		end if
	end if
	
	! guessing if cosine, radians or degrees have been used
	if(alpha<=1.0 .and. beta<=1.0 .and. gamma<=1.0) then
		! We have cosines (most likely)
		talpha=acos(alpha)
		tbeta=acos(beta)
		tgamma=acos(gamma)
	else if(alpha<pi .and. beta<pi .and. gamma<pi) then
		! We have radians
		talpha=alpha
		tbeta=beta
		tgamma=gamma
	else
		! We have degrees
		talpha=radians(alpha)
		tbeta=radians(beta)
		tgamma=radians(gamma)
	end if
	
	if(directcell) then    
		this%a=a
		this%b=b
		this%c=c
		this%alpha=talpha
		this%beta=tbeta
		this%gamma=tgamma
		
		this%rgamma=acos((cos(talpha)*cos(tbeta)-cos(tgamma))/(sin(talpha)*sin(tbeta)))

		rmetric=this%rmetric()
		
		this%ra=sqrt(rmetric(1,1))
		this%rb=sqrt(rmetric(2,2))
		this%rc=sqrt(rmetric(3,3))
		this%rgamma=acos(rmetric(1,2)/(this%ra*this%rb))
		this%rbeta=acos(rmetric(1,3)/(this%ra*this%rc))
		this%ralpha=acos(rmetric(2,3)/(this%rb*this%rc))
	else
		this%ra=a
		this%rb=b
		this%rc=c
		this%ralpha=talpha
		this%rbeta=tbeta
		this%rgamma=tgamma
		
		this%gamma=acos((cos(talpha)*cos(tbeta)-cos(tgamma))/(sin(talpha)*sin(tbeta)))

		rmetric=this%rmetric()
		
		this%ra=sqrt(rmetric(1,1))
		this%rb=sqrt(rmetric(2,2))
		this%rc=sqrt(rmetric(3,3))
		this%rgamma=acos(rmetric(1,2)/(this%ra*this%rb))
		this%rbeta=acos(rmetric(1,3)/(this%ra*this%rc))
		this%ralpha=acos(rmetric(2,3)/(this%rb*this%rc))
	end if	
	
    this%status=0    
    
end subroutine

!> Return the volume of the unit cell
function volume(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real :: volume   
   
    volume = this%a*this%b*this%c*(1-cos(this%alpha)**2-cos(this%beta)**2 - &
    &   cos(this%gamma)**2+2*cos(this%alpha)*cos(this%beta)*cos(this%gamma))**(0.5)
end function

!> Return the reciprocal volume of the unit cell
function rvolume(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real :: rvolume   
   
    rvolume = this%ra*this%rb*this%rc*(1-cos(this%ralpha)**2-cos(this%rbeta)**2 - &
    &   cos(this%rgamma)**2+2*cos(this%ralpha)*cos(this%rbeta)*cos(this%rgamma))**(0.5)
end function

!> Return a reciprocal orthogonalisation matrix
function rorthogonalisation(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: rorthogonalisation
    logical OK_FLAG
    
    call matinv(this%orthogonalisation(), rorthogonalisation, OK_FLAG)
    rorthogonalisation=transpose(rorthogonalisation)
end function

!> Return a reciprocal orthogonalisation matrix excluding cell parameters
function rorthogonalisation_exclcell(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: rorthogonalisation_exclcell, cell, temp
    
    cell=0.0
    cell(1,1)=1.0/this%ra
    cell(2,2)=1.0/this%rb
    cell(3,3)=1.0/this%rc
    
    rorthogonalisation_exclcell=matmul(this%rorthogonalisation(), cell)
        
end function

!> Return a real orthogonalisation matrix
function orthogonalisation(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: orthogonalisation
    
    orthogonalisation=0.0
    orthogonalisation(1,1) = this%a*sin(this%beta)*sin(this%rgamma)
    orthogonalisation(2,1) = -this%a*sin(this%beta)*cos(this%rgamma)
    orthogonalisation(2,2) = this%b*sin(this%alpha)
    orthogonalisation(3,1) = this%a*cos(this%beta)
    orthogonalisation(3,2) = this%b*cos(this%alpha)
    orthogonalisation(3,3) = this%c
    
end function

!> Return a real orthogonalisation matrix excluding the cell parameters
function orthogonalisation_exclcell(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: orthogonalisation_exclcell, cell
    
    cell=0.0
    cell(1,1)=1.0/this%a
    cell(2,2)=1.0/this%b
    cell(3,3)=1.0/this%c
    
    orthogonalisation_exclcell=matmul(this%orthogonalisation(), cell)
    
end function

!> Return the metric tensor
function metric(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: metric, o
    
    o = this%orthogonalisation()
    metric = matmul(transpose(o), o)
end function

!> Return the reciprocal metric tensor
function rmetric(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: rmetric
    logical OK_FLAG
        
    call matinv(this%metric(), rmetric, OK_FLAG)
end function

!> Return the reciprocal metric tensor excluding cell parameters
function rmetric_exclcell(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: rmetric_exclcell, o
    
    o = this%rorthogonalisation_exclcell()
    rmetric_exclcell = matmul(transpose(o), o)
end function

!> Return the metric tensor excluding cell parameters
function metric_exclcell(this)
    use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: o, metric_exclcell

    o = this%orthogonalisation_exclcell()
    metric_exclcell = matmul(transpose(o), o)
        
end function

!> Return the R(ii) and R(ij) used to calculate sin(theta)/lambda as a linear array of 6 elements
function Rij_linear(this)
    implicit none
    class(t_unitcell) :: this
    real, dimension(6) :: Rij_linear
    real, dimension(3,3) :: rmetric
    integer i
    
    rmetric=this%rmetric()
   
    do i=1, 3
        Rij_linear(i)=0.25*rmetric(i,i)
    end do
    Rij_linear(4)=0.5*rmetric(2,3)
    Rij_linear(5)=0.5*rmetric(1,3)
    Rij_linear(6)=0.5*rmetric(1,2)
end function

!> Return the R(ii) and R(ij) used to calculate sin(theta)/lambda
function Rij(this)
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: Rij
    
    Rij=0.25*this%rmetric()
    
end function

!> Constants to convert an atom from iso to aniso
function iso_to_aniso(this)
    implicit none
    class(t_unitcell) :: this
    real, dimension(3) :: iso_to_aniso
    
    iso_to_aniso=cos( (/this%ralpha, this%rbeta, this%rgamma/) )
end function

!> Anisotropic temperature factor coefficients
!! 3x3 tensor stored flat as a 1-D array of 6 elements
function adp_coefs(this)
	use math_mod
    implicit none
    class(t_unitcell) :: this
    real, dimension(6) :: adp_coefs
    real, dimension(3,3) :: rmetric
    
    rmetric=this%rmetric()
    
    adp_coefs(1)=-2.0*pi**2*rmetric(1,1)
    adp_coefs(2)=-2.0*pi**2*rmetric(2,2)
    adp_coefs(3)=-2.0*pi**2*rmetric(3,3)
    adp_coefs(4)=-4.0*pi**2*this%rb*this%rc
    adp_coefs(5)=-4.0*pi**2*this%rc*this%ra
    adp_coefs(6)=-4.0*pi**2*this%ra*this%rb
    
end function

! Return GUMTRX(19:27) originally defined in XFAL01 when loading list 1
! It is used to draw the adps on screen
function gumtrx_adps(this)
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: gumtrx_adps

    real calp, cbet, cgam, rn
    real, dimension(3) :: d
    integer i
    real, dimension(3,3) :: ortho
    
    ortho=this%orthogonalisation()
    calp=cos(this%alpha)
    cbet=cos(this%beta)
    cgam=cos(this%gamma)
    rn=sqrt(1.0+2.0*calp*cbet*cgam-calp**2-cbet**2-cgam**2)
    d(1)=sin(this%alpha)/(rn*this%a)
    d(2)=sin(this%beta)/(rn*this%b)
    d(3)=sin(this%gamma)/(rn*this%c)

    do i=1,3
        gumtrx_adps(i,:)=ortho(i,:)*d
    end do

end function

subroutine printall(this)
    implicit none
    class(t_unitcell) :: this
    real, dimension(3,3) :: tensor
    real, dimension(6) :: vector
    
    print *, 'Status: ', this%status
    
    print *, ''
    print *, 'Unit cell parameters: '
    write(*, '("a=",F0.3,1X,"b=",F0.3,1X,"c=",F0.3,1X,"alpha=",F0.3,1X,"beta=",F0.3,1X,"gamma=",F0.3)') &
    &   this%a, this%b, this%c, this%alpha, this%beta, this%gamma

    print *, 'Reciprocal unit cell parameters: '
    write(*, '("a=",F0.6,1X,"b=",F0.6,1X,"c=",F0.6,1X,"alpha=",F0.3,1X,"beta=",F0.3,1X,"gamma=",F0.3)') &
    &   this%ra, this%rb, this%rc, this%ralpha, this%rbeta, this%rgamma

    print *, ''
    print *, 'Real metric tensor including and excluding cell parameters: '
    tensor=this%metric()
    write(*, '(3(3(F9.4,1X)/))') transpose(tensor)
    print *, ''
    tensor=this%metric_exclcell()
    write(*, '(3(3(F9.4,1X)/))') transpose(tensor)

    print *, ''
    print *, 'Reciprocal metric tensor including and excluding cell parameters: '
    tensor=this%rmetric()
    write(*, '(3(3(F9.6,1X)/))') transpose(tensor)
    print *, ''
    tensor=this%rmetric_exclcell()
    write(*, '(3(3(F9.6,1X)/))') transpose(tensor)

    print *, ''
    print *, 'Real orthogonalisation matrix including and excluding cell parameters: '
    tensor=this%orthogonalisation()
    write(*, '(3(3(F9.4,1X)/))') transpose(tensor)
    print *, ''
    tensor=this%orthogonalisation_exclcell()
    write(*, '(3(3(F9.4,1X)/))') transpose(tensor)
    
    print *, ''
    print *, 'Reciprocal orthogonalisation matrix including and excluding cell parameters: '
    tensor=this%rorthogonalisation()
    write(*, '(3(3(F9.6,1X)/))') transpose(tensor)
    print *, ''
    tensor=this%rorthogonalisation_exclcell()
    write(*, '(3(3(F9.6,1X)/))') transpose(tensor)
    
    print *, ''
    print *, 'The R(ii) and R(ij)''s used to calculate sin(theta)/lambda: '
    tensor=this%Rij()
    write(*, '(3(3(F9.6,1X)/))') transpose(tensor)

    print *, ''
    print *, 'The anisotropic temperature factirs coeficients: '
    vector=this%adp_coefs()
    write(*, '(6(F9.6,1X))') vector

    print *, ''
    print *, 'Contants to convert an atom from iso to aniso: '
    vector(1:3)=this%iso_to_aniso()
    write(*, '(3(F9.6,1X))') vector(1:3)

end subroutine

end module

