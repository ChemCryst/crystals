module sginfo_type_mod
use, intrinsic :: iso_c_binding

!   typedef struct
!  {
!    int  Code;
!    int  nTrVector;
!    int  *TrVector;
!  }
!  T_LatticeInfo;
type, bind(c) :: T_LatticeInfo
    character(kind=c_char) Code
    integer(c_int) nTrVector
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
  
end module
