module sginfo_type_mod
use, intrinsic :: iso_c_binding

!#define STBF 12 /* Seitz           Matrix Translation Base Factor */
!
!#define CRBF 12 /* Change of Basis Matrix Rotation    Base Factor */
!#define CTBF 72 /* Change of Basis Matrix Translation Base Factor */
real, parameter :: sginfo_stbf=12.0
real, parameter :: sginfo_crbf=12.0
real, parameter :: sginfo_ctbf=72.0

!   typedef struct
!  {
!    int  Code;
!    int  nTrVector;
!    int  *TrVector;
!  }
!  T_LatticeInfo;
type, bind(c) :: T_LatticeInfo
    character(c_char) :: Code
    integer(c_int) :: nTrVector
    type(c_ptr) :: TrVector
end type

!typedef struct
!  {
!    int                  GenOption;
!    int                  Centric;
!    int                  InversionOffOrigin;
!    const T_LatticeInfo  *LatticeInfo;
!    int                  StatusLatticeTr;
!    int                  OriginShift[3];
!    int                  nList;
!    int                  MaxList;
!    T_RTMx               *ListSeitzMx;
!    T_RotMxInfo          *ListRotMxInfo;
!    int                  OrderL;
!    int                  OrderP;
!    int                  XtalSystem;
!    int                  UniqueRefAxis;
!    int                  UniqueDirCode;
!    int                  ExtraInfo;
!    int                  PointGroup;
!    int                  nGenerator;
!    int                   Generator_iList[4];
!    char                 HallSymbol[MaxLenHallSymbol + 1];
!    const T_TabSgName    *TabSgName;
!    const int            *CCMx_LP;
!    int                  n_si_Vector;
!    int                  si_Vector[9];
!    int                  si_Modulus[3];
!  }
!  T_SgInfo;
type, bind(c) :: T_sginfo
    integer(c_int) GenOption
    integer(c_int) Centric
    integer(c_int) InversionOffOrigin
    type(c_ptr) :: LatticeInfo
    integer(c_int) StatusLatticeTr
    integer(c_int), dimension(3) :: OriginShift
    integer(c_int) nList
    integer(c_int) MaxList
    type(c_ptr) :: ListSeitzMx
    type(c_ptr) :: ListRotMxInfo
    integer(c_int) OrderL
    integer(c_int) OrderP
    integer(c_int) XtalSystem
    integer(c_int) UniqueRefAxis
    integer(c_int) UniqueDirCode
    integer(c_int) ExtraInfo
    integer(c_int) PointGroup
    integer(c_int) nGenerator
    integer(c_int), dimension(4) :: Generator_iList
    character, dimension(40) :: HallSymbol
    type(c_ptr) :: TabSgName
    type(c_ptr) :: CCMx_LP
    integer(c_int) n_si_Vector
    integer(c_int), dimension(9) :: si_Vector
    integer(c_int), dimension(3) :: si_Modulus
end type

!typedef union
!  {
!    struct { int R[9], T[3]; } s;
!    int                        a[12];
!  }
!  T_RTMx;
type, bind(c) :: T_RTMx
	integer(c_int), dimension(9) :: R
	integer(c_int), dimension(3) :: T
end type

!typedef struct
!  {
!    const char  *HallSymbol;
!    const int   SgNumber;
!    const char  *Extension;
!    const char  *SgLabels;
!  }
!  T_TabSgName;
type, bind(c) :: T_TabSgName
	type(c_ptr) :: HallSymbol
	integer(c_int) :: SgNumber
	type(c_ptr) :: Extension
	type(c_ptr) :: SgLabels
end type


character(len=12), dimension(0:7), parameter :: XS_name=(/ &
&	 "Unknown     ", &
&    "Triclinic   ", &
&    "Monoclinic  ", &
&    "Orthorhombic", &
&    "Tetragonal  ", &
&    "Trigonal    ", &
&    "Hexagonal   ", &
&    "Cubic       " /)
  
! Lattice type: 1=P, 2=I, 3=rhombohedral obverse on hexagonal axes, 4=F, 5=A, 6=B, 7=C
!  latt   Code  nTrVector  TrVector
!   1      'P'      1      0,0,0
!   5      'A'      2      0,0,0   0 ,1/2,1/2
!   6      'B'      2      0,0,0  1/2, 0 ,1/2
!   7      'C'      2      0,0,0  1/2,1/2, 0
!   2      'I'      2      0,0,0  1/2,1/2,1/2
!   3      'R'      3      0,0,0  2/3,1/3,1/3  1/3,2/3,2/3
!   0      'S'      3      0,0,0  1/3,1/3,2/3  2/3,2/3,1/3
!   0      'T'      3      0,0,0  1/3,2/3,1/3  2/3,1/3,2/3
!   4      'F'      4      0,0,0   0 ,1/2,1/2  1/2, 0 ,1/2  1/2,1/2, 0  
type T_LatticeTranslation
    integer :: latt !< latt code from shelxl
    character :: code !< Character code of lattice
    integer nTrVector !< number of translation vectors
    integer, dimension(3,4) :: TrVector !< translation vectors
end type

interface T_LatticeTranslation
    module procedure T_LatticeTranslation_init
end interface

type(T_LatticeTranslation), dimension(9) :: LatticeTranslation

contains

function T_LatticeTranslation_init()
implicit none
integer i
integer t_latticetranslation_init
real, parameter :: a13=1.0/3.0
real, parameter :: a23=2.0/3.0

    t_latticetranslation_init=0
    
    do i=1, size(LatticeTranslation)
        LatticeTranslation(i)%TrVector=0
        LatticeTranslation(i)%latt=i
    end do
    LatticeTranslation(8)%latt=0
    LatticeTranslation(9)%latt=0
    
    LatticeTranslation(1)%code='P'
    LatticeTranslation(2)%code='I'
    LatticeTranslation(3)%code='R'
    LatticeTranslation(4)%code='F'
    LatticeTranslation(5)%code='A'
    LatticeTranslation(6)%code='B'
    LatticeTranslation(7)%code='C'
    LatticeTranslation(8)%code='S'
    LatticeTranslation(9)%code='T'
    
    LatticeTranslation(1)%nTrVector=1
    LatticeTranslation(2)%nTrVector=2
    LatticeTranslation(3)%nTrVector=3
    LatticeTranslation(4)%nTrVector=4
    LatticeTranslation(5)%nTrVector=2
    LatticeTranslation(6)%nTrVector=2
    LatticeTranslation(7)%nTrVector=2
    LatticeTranslation(8)%nTrVector=3
    LatticeTranslation(9)%nTrVector=3
    
    LatticeTranslation(2)%TrVector(:,2)=nint(sginfo_stbf*0.5)
    !0,0,0  2/3,1/3,1/3  1/3,2/3,2/3
    LatticeTranslation(3)%TrVector(:,2)=nint(sginfo_stbf*(/a23, a13, a13/))
    LatticeTranslation(3)%TrVector(:,3)=nint(sginfo_stbf*(/a13, a23, a23/))
    !0,0,0   0 ,1/2,1/2  1/2, 0 ,1/2  1/2,1/2, 0  
    LatticeTranslation(4)%TrVector(:,2)=nint(sginfo_stbf*(/0.0, 0.5, 0.5/))
    LatticeTranslation(4)%TrVector(:,3)=nint(sginfo_stbf*(/0.5, 0.0, 0.5/))
    LatticeTranslation(4)%TrVector(:,4)=nint(sginfo_stbf*(/0.5, 0.5, 0.0/))    
    !0,0,0   0 ,1/2,1/2
    LatticeTranslation(5)%TrVector(:,2)=nint(sginfo_stbf*(/0.0, 0.5, 0.5/))
    !0,0,0  1/2, 0 ,1/2
    LatticeTranslation(6)%TrVector(:,2)=nint(sginfo_stbf*(/0.5, 0.0, 0.5/))
    !0,0,0  1/2,1/2, 0
    LatticeTranslation(7)%TrVector(:,2)=nint(sginfo_stbf*(/0.5, 0.5, 0.0/))
    !0,0,0  1/3,1/3,2/3  2/3,2/3,1/3
    LatticeTranslation(8)%TrVector(:,2)=nint(sginfo_stbf*(/a13, a13, a23/))
    LatticeTranslation(8)%TrVector(:,3)=nint(sginfo_stbf*(/a23, a23, a13/))
    !0,0,0  1/3,2/3,1/3  2/3,1/3,2/3
    LatticeTranslation(9)%TrVector(:,2)=nint(sginfo_stbf*(/a13, a23, a13/))
    LatticeTranslation(9)%TrVector(:,3)=nint(sginfo_stbf*(/a23, a13, a23/))

end function
  
end module
