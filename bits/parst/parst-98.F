C* Version for PC.    Release  February 1998
C* Math co-processor is requested.
C***********************************************************************
C*                                                                     *
C* PARST: a system of computer routines for calculating molecular par- *
C* ameters from results of crystal structure analyses.                 *
C*                           by M.NARDELLI                             *
C* Dipartimento di Chimica Generale ed Inorganica, Chimica Analitica,  *
C* Chimica Fisica della Universita` degli Studi di Parma, Centro di    *
C* Studio per la Strutturistica Diffrattometrica del C.N.R., Viale     *
C* delle Scienze, I-43100 Parama, Italy.                               *
C*                                                                     *
C* Published in: Computer & Chemistry, (1983), 7, 95-98                *
C*          and: J. Appl. Cryst. (1995). 28, 659.                      *
C*                                                                     *
C* The program calculates: Niggli's reduced cell, orthogonal coordi-   *
C* nates, principal axes of thermal ellipsoids, bond lengths (uncor-   *
C* rected and corrected for thermal motion), angles, torsions, planes, *
C* straight lines, angles formed by planes and lines, puckering and    *
C* displacement asymmetry parameters of rings, spherical polar coordi- *
C* nates for stereographic projections, intramolecular and intermol-   *
C* ecular contacts, possible hydrogen bonds, coordinates of hydrogens  *
C* in typical groups, for a given set of atoms. The s.u.'s for all     *
C* these magnitudes are calculated. Comparison of the coordinates of   *
C* pairs of subsets of atoms is also considered.                       *
C*                                                                     *
C*                             Input data                              *
C*                          ----------------                           *
C* Unit number of input file: 13.  It contains:                        *
C* 1.Title card: TITLE (80A1)                                          *
C* 2.Space group card: symbol of the space group (80A1)                *
C*   It is important that the character in column 1 is the symbol of   *
C*   the Bravais lattice.                                              *
C*   N.B.- Rombohedral lattices must be indicated as P when a rombo-   *
C*   hedral cell is chosen, as R when the cell is hexagonal (obverse   *
C*   cell: -h+k+l = 3n )                                               *
C* 3.Control card (free format): N,D3,DM,NH1,NTN,LSP,LSL,NPR,NST,KL,   *
C*   KY,KC,KO,KB,KA,KT,KD,KE,KOR,NI                                    *
C*     N=Total number of atoms (max. 500)                              *
C*     D3=Minimum distance for non-bonding intramol. contacts (dummy)  *
C*     DM=Maximum distance for non-bonding contacts                    *
C*     NH1=Number of groups of hydrogen atoms whose coordinates must   *
C*         be calculated (max. number of H-atoms: 500-N)               *
C*     NTN=Number of distances or angles formed by non-bonded atoms    *
C*     LSP=Number of planes (max. 50)                                  *
C*     LSL=Number of lines (max. 50)                                   *
C*     NPR=Number of rings (max. 50)                                   *
C*     NST=Number of stereographic sets                                *
C*     KL=Code for the format of the atomic parameters                 *
C*     KY=0 no crystal data (cards 4 and 5 must not be given)          *
C*       =1 crystal data are printed                                   *
C*     KC=0 no coordinates,          =1 coordinates are printed        *
C*     KO=0 no orthog. coord.,       =1 orthog. coord. are printed     *
C*     KB=0 no bond distances,       =1 bond distances are printed     *
C*     KB=-1 only bond distances not involving hydrogens are printed   *
C*     KA=0 no angles,               =1 angles are printed             *
C*     KA=-1 only bond angles not involving hydrogens are printed      *
C*     KT=0 no torsions,             =1 torsion angles are calculated  *
C*     KT=-1 only torsion angles not involving hydrogens are printed   *
C*     KD=0 no interatomic contacts, =1 interatomic contacts are calc. *
C*     KD=-1 only intra-contacts not involving hydrogens are printed   *
C*     KE=0 no intermolecular contacts, =1 intermolecular contacts     *
C*          less than DM and possible hydrogen bonds are calculated    *
C*     KE=-1 only inter-contacts not involving hydrogens are printed   *
C*     KOR=0  no thermal parameters in the input                       *
C*     KOR=1, beta: exp[-(beta11*h**2+...+2*beta12*h*k+...)]           *
C*     KOR=2, U: exp[-2*pi**2(U11*h**2*(a*)**2+...+2*U12*h*k*          *
C*                                                   (a*)*(b*)+...)]   *
C*     KOR=3, B: exp[-0.25*(B11*h**2*(a*)**2+...+2*B12*h*k*            *
C*                                                   (a*)*(b*)+...)]   *
C*     KOR=4, b: exp[-(b11*h**2+...+b12*h*k+...)]                      *
C*     KOR=5, U*:exp[-2*pi**2(U11*h**2*(a*)**2+...+2*U12*h*k*          *
C*                                       (a*)*(b*)*cos(gamma*)+...)]   *
C*     KOR=6, B*: exp[-0.25*(B11*h**2*(a*)**2+...+2*B12*h*k*           *
C*                                       (a*)*(b*)*cos(gamma*)+...)]   *
C*     KOR=7, anisotropic thermal parameters given in the input, but   *
C*            not processed and printed                                *
C*                                                                     *
C* N.B.-If there are isotropic atoms together with anisotropic ones,   *
C*     the thermal parameter for them is given as U11 (or B11, etc.)   *
C*     and zeros must be given for U22, U33, U12, U13, U23             *
C*                                                                     *
C*     NI=Number of pairs of subset of atoms whose coordinates are to  *
C*     be compared.                                                    *
C*     If NI is negative only research of missing symmetries is        *
C*     carried out.                                                    *
C* 4.Data card (free format): NNS,Z,AL                                 *
C*     NNS=Number of atomic species in the chemical formula            *
C*     Z  =Number of molecules in the unit cell                        *
C*     AL =Wavelength (Cu or Mo K-alpha)                               *
C* 5.Formula card (free format): symbols of the atoms, within apices,  *
C*     followed by their numbers                                       *
C* 6.Parameter card (free format): a,b,c,sigma(a),sigma(b),sigma(c),   *
C*     alpha,beta,gamma,sigma(alpha),sigma(beta),sigma(gamma)          *
C* 7.Coordinate format card: Format of the coordinate cards (80A1);    *
C*   this card is not given if KL=4                                    *
C* 8.Coordinate cards (thermal parameters are given only if KOR is     *
C*   not equal to zero)                                                *
C*     If KL=1: ATOM(6A1),X,Y,Z,S(X),S(Y),S(Z),B11,B22,B33,B23,B13,    *
C*              B12,S(B11),S(B22),S(B33),S(B23),S(B13),S(B12)          *
C*     If KL=2: ATOM(6A1),X,Y,Z,B11,B22,B33,B23,B13,B12,S(X),S(Y),     *
C*              S(Z),S(B11),S(B22),S(B33),S(B23),S(B13),S(B12)         *
C*     If KL=3: ATOM(6A1),X,S(X),Y,S(Y),Z,S(Z),B11,S(B11),B22,S(B22),  *
C*              B33,S(B33),B23,S(B23),B13,S(B13),B12,S(B12)            *
C*     If KL=4: FORMAT UNIMOL (7X,6A1,2X,3F8.5,12X,3(5A1,3X))          *
C*              KOR must be 0                                          *
C*   N.B.- When KY=0, i.e. the formula card is not given, the second   *
C*         character of the atomic labels cannot be alphabetic when    *
C*         the chemical simbol requires only one character (e.g.: H,   *
C*         B, C, N, O, F, O, S,... ).                                  *
C*         When KY=1, i.e. the formula card is given, there is no      *
C*         restriction for the second character of the labels of these *
C*         atoms.                                                      *
C* 9.Cards for hydrogens in calculated positions: KDG,D,SB             *
C*   (these cards mustn't be given if NH1=0)                           *
C*     If KDG=1,(methyl):SB=ATOM1,ATOM2,ATOM3 (I1,1X,F6.4,3(6A1))      *
C*        ATOM1 is bonded to hydrogens and to ATOM2; ATOM2 is bonded   *
C*        to ATOM1 and to ATOM3                                        *
C*     If KDG=2,(methylene): as for methyl, ATOM2 and ATOM3 are bonded *
C*        to ATOM1                                                     *
C*     If KDG=3,(tert-C):SB=ATOM1,ATOM2,ATOM3,ATOM4 (I1,1X,F6.4,4(6A1) *
C*        ATOM1 is bonded to hydrogen,ATOM2,ATOM3,ATOM4                *
C*     If KDG=4 (benzene): as for methylene                            *
C*     If KDG=5 (alkyne): SB=ATOM1,ATOM2 (I1,1X,F6.4,2(6A1))           *
C*        ATOM1 is bonded to hydrogen and to ATOM2                     *
C*     If KDG=6 (ethylenic system): as for tert-C; ATOM1 is bonded to  *
C*        two hydrogens and to ATOM2 which is planarly bonded to ATOM1 *
C*        ATOM3 and ATOM4                                              *
C*   N.B.- If KOR is not equal to zero, an isotropic thermal parameter *
C*         is assigned equal to the arithmetic mean of the anisotropic *
C*         parameters of the atom the hydrogen is attached to          *
C*     D = ATOM1-H distance (F6.4)                                     *
C*     SB= Labels of the non-hydrogen atoms                            *
C*10.Cards for distances or angles formed by non-bonded atoms.         *
C*   IF two atoms are given:                                           *
C*     ATOM1,ATOM2  (FORMAT (2(6A1))                                   *
C*   the distance between them is given.                               *
C*   If three atoms are given:                                         *
C*     ATOM1,ATOM2,ATOM3  (FORMAT (3(6A1))                             *
C*   the angle at ATOM2 is calculated.                                 *
C*   While, if four atoms are given:                                   *
C*     ATOM1,ATOM2,ATOM3,ATOM4  (FORMAT (4(6A1))                       *
C*   a torsion angle is calculated.                                    *
C*11.Cards for LQ-planes: NT,NFP,names of the atoms                    *
C*     FORMAT (2I2,4X,12(6A1)/(12(6A1)))                               *
C*     NT=Total number of atoms (max 40)                               *
C*     NFP=Number of the atoms not defining the plane                  *
C*12.Cards for LQ-lines: NT,NFP,names of the atoms                     *
C*     FORMAT (2I2,4X,12(6A1)/(12(6A1)))                               *
C*     NT=Total number of atoms (max 40)                               *
C*     NFP=Number of the atoms not defining the line                   *
C*13.Cards for puckered rings: NP,Names of the atoms in the right      *
C*   sequence                                                          *
C*     FORMAT (I2,6X,12(6A1)/(12(6A1)))                                *
C*     NP=Number of the atoms of the ring (max 40)                     *
C*14.Cards for stereographic projections: KO,NP,NQ,names of the atoms  *
C*   in the right sequence                                             *
C*     FORMAT(I1,2I2,3X,12(6A1)/(12(6A1)))                             *
C*     KO=1,origin at 1st atom,Z axis along ATOM1-ATOM2                *
C*     KO=2,origin at 1st atom,Z axis perpendicular to the mean plane  *
C*          through the first NQ atoms, excepting ATOM1                *
C*     KO=3,origin at the center of the first NQ atoms, Z axis perpen- *
C*          dicular to the plane through them                          *
C*     NP=Total number of atoms (max 40)                               *
C*     NQ=Number of the atoms defining the projection plane inclusive  *
C*     of first atom                                                   *
C*15.Data for intermolecular contacts (it must be given even if KE=0): *
C*     IC,NE,NT (Free FORMAT)                                          *
C*     IC=1 if the space group is acentric                             *
C*       =-1 if the space group is centric                             *
C*     NE=Number of the equivalent positions (the general, X Y Z, and  *
C*        the centrosymmetric ones must be omitted)                    *
C*     NT=Maximum translation required (suggested 1 when the set of    *
C*        atoms in the general position is the nearest to the origin,  *
C*        2 in the other cases)                                        *
C*16.Equivalent position cards: one equivalent position per card       *
C*   (38A1). Examples: 1/2-X,1/2+Y,1/2+Z                               *
C*                       Y-X,-X,1/3+Z                                  *
C*17.Card with the total number of atoms whose coordinates are com-    *
C*   pared (free FORMAT).                                              *
C*18.Cards with the labels of the atoms whose coordinates are compared *
C*   (12(6A1)). First the atoms of the first subset, then the atoms    *
C*   of the second subset exactly in the same sequence.                *
C*   Of course card 17 and cards 18 are not given if NI=0.             *
C*                                                                     *
C*   Unit number of output file: 15.                                   *
C*                                                                     *
C***********************************************************************
      PROGRAM PARST97
      CHARACTER*1 BRV,FRMT(80),STPE(38,50),SDOL(6,500),DDOL(6,4),
     1 PDOL(6,40),FPDOL(6,40),LA1(2,20),MINUS(2),LTP(7),UNIM(3,5),
     2 II(5),CHR2,LBL(6,40),LB1(6,2),SDL1(2,500),AAAA(6),LBA(2),CHR1
      CHARACTER*2 LA(20),SDL2(500)
      CHARACTER*80 FRT
      INTEGER NS(3),IL(2,700),IA(3,2000),IT(4,3000),LE1(24,3,3),
     1 IL1(2,700)
      DOUBLE PRECISION M1,M2,M3,M4,UP,CP,AM,SAM,CDP,SCDP,PV(40,3),
     1 PSV(40,3),X1,SX1,XO1,SXO1,CDL,SCDL,DX(40,3),SXC(40,3),DQ(20),
     2 SQ(20),DPHI(20),SPHI(20),DTHE(20),STHE(20),DQT,SQT
      DIMENSION S1(40,3),S2(20),S3(20),S4(20),PV1(40,3),XCF(40,3),
     1 QMF(40),PHIF(40),THETAF(40),C(3),SC(3),A(3),SA(3),V(3,500),
     2 S(3,500),VO(3,500),X(3),SX(3),RO(4,3),DST(3),SD(4,3),XR(3,3),
     3 SXR(3,3),XO(3),SXO(3),SPV(40,3),AM(3),SAM(3),CDP(3,50),
     4 SCDP(3,50),CDL(3,50),SCDL(3,50),SO(3,500),ZC(40),F1(24,3),
     5 FB(3),SSS1(3),SSS2(3),XX(2,3),SXX(2,3),XXO(2,3),D(3),H(3)
      EQUIVALENCE (LA(1),LA1(1,1)),(LBL(1,1),LB1(1,1)),(SDL2(1),
     1 SDL1(1,1))
      COMMON/GRP1/C,SC,A,SA
     1      /GRP2/XR,SXR
     2      /GRP3/VO,SO
     3      /GRP4/SDOL
     4      /GRP6/RO,DST
     5      /GRP7/FPDOL
     6      /GRP8/PV,PSV,AM,SAM
     7      /GRP9/ZC
     8      /GRP10/LA
     9      /GRP11/ANAA(20)
     1      /GRP12/NNS
      COMMON/COOR/V,S
     1      /NEW/IL
     2      /NEW2/IA
     3      /NEW3/IT
     4      /NEW1/XK(3),O(3,3)
     5      /GRN1/PDOL
     6      /GRN2/NFP
     7      /LBL1/X1(3),SX1(3),XO1(3),SXO1(3)
      COMMON/INS2/QM(20),PHI(20),THETA(20),QT
     1      /INS3/CR(3)
     2      /INS4/CS(3),SN(3)
     3      /INS5/XC(40,3),S1
     4      /EQVP/LE1,F1,FB
     5      /LBL4/STPE
     6      /EDAT/IC,NE
      COMMON/INS6/G(6)
     1      /INS7/PVT(40,3)
     2      /INS8/B(6,500),SB(6,500)
     3      /INS1/M1,M2,M3,M4
     4      /LBL2/CP,UP,NN
     5      /LBL6/NPE,LH(50,3,3),FH(50,3)
     6      /INPOU/IN,IO
     7      /GRG1/SDL2
     8      /GRG2/IL1
      DATA LTP /'P','A','B','C','I','F','R'/
      PG=3.14159265
      RD=57.295779513
      M1=32007779D0
      M2=23717810D0
      M3=52636370D0
      CP=1D-3
      NN=200
      UP=1D0/(CP*DSQRT(1D0*NN))
      CP1=CP
      IN=13
      IO=15
c      CALL INPOUT
c- name the devices directly for CRYSTALS
      OPEN(UNIT=IN,FILE='parst-in.dat',FORM='FORMATTED')
      OPEN(UNIT=IO,FILE='parst-out.cry',FORM='FORMATTED')
      REWIND(UNIT=IO)
C-----Read title, codes and parameters
      READ(IN,'(80A1)') FRMT
      WRITE(IO,'(1X,80A1)') FRMT
      READ(IN,'(80A1)') FRMT
      WRITE(IO,'(1X,80A1)') FRMT
      BRV=FRMT(1)
      DO 302 I=1,7
      IF(BRV.EQ.LTP(I))GO TO 130
302   CONTINUE
      WRITE(IO,298) BRV
298   FORMAT(/' The symbol ',A1,'for lattice type is uncorrect.'/
     1 ' Symbol P has been assumed'/)
      BRV=LTP(1)
130   CONTINUE
      READ(IN,*)N,D3,DM,NH1,NTN,LSP,LSL,NPR,NST,KL,KY,KC,KO,KB,KA,KT,
     1 KD,KE,KOR,NI
      IF(N.LE.500)GO TO 1
      N=500
      WRITE(IO,203)
203   FORMAT(/' There are too many atoms.'/
     1 ' The calculations are carried out on the first 500 atoms.'/)
1     IF(LSP.LE.50)GO TO 2
      WRITE(IO,204)
204   FORMAT(/' Too many planes are requested.'/
     1 ' The calculations are carried out on the first 50 planes.'/)
      LSP=50
2     IF(LSL.LE.50)GO TO 3
      WRITE(IO,205)
205   FORMAT(/' Too many lines are requested.'/
     1 ' The calculations are carried out on the first 50 lines.'/)
      LSL=50
3     IF(KY.EQ.0) GO TO 6
      READ(IN,*)NNS,Z,AL
      READ(IN,*)(LA(I),ANAA(I),I=1,NNS)
      DO 31 I=1,NNS
      MINUS(1)=LA1(1,I)
      MINUS(2)=LA1(2,I)
      NCS=2
      CALL MINUMA(NCS,MINUS)
      LA1(1,I)=MINUS(1)
31    LA1(2,I)=MINUS(2)
6     READ(IN,*)C,SC,A,SA
      DO 300 I=1,3
300   IF(SC(I).LE.1E-9)SC(I)=C(I)*1E-9
      CALL VOLMET(RD,VL,SGAR,CSAR,SNAR)
      CALL NIGGLI(BRV,RD)
      IF(KY.EQ.0) GO TO 7
      CALL MOLABS(NNS,VL,Z,AL)
C-----Read atom symbols,coordinates,thermal parameters & s.u.'s
7     IF(KL.EQ.4) GO TO 19
      READ(IN,'(A80)') FRT
      IF(KOR.EQ.0) GO TO 8
      GO TO (9,11,13),KL
8     GO TO (15,15,17,19),KL
9     DO 10 J=1,N
10    READ(IN,FRT)(SDOL(L,J),L=1,6),(V(I,J),I=1,3),(S(I,J),I=1,3),
     1 (B(I,J),I=1,6),(SB(I,J),I=1,6)
      GO TO 22
11    DO 12 J=1,N
12    READ(IN,FRT)(SDOL(L,J),L=1,6),(V(I,J),I=1,3),(B(I,J),I=1,6),
     1 (S(I,J),I=1,3),(SB(I,J),I=1,6)
      GO TO 22
13    DO 14 J=1,N
14    READ(IN,FRT)(SDOL(L,J),L=1,6),(V(I,J),S(I,J),I=1,3),
     1 (B(I,J),SB(I,J),I=1,6)
      GO TO 22
15    DO 16 J=1,N
16    READ(IN,FRT)(SDOL(L,J),L=1,6),(V(I,J),I=1,3),(S(I,J),I=1,3)
      GO TO 22
17    DO 18 J=1,N
18    READ(IN,FRT)(SDOL(L,J),L=1,6),(V(I,J),S(I,J),I=1,3)
      GO TO 22
19    DO 21 J=1,N
      READ(IN,'(7X,6A1,2X,3F8.5,12X,3(5A1,3X))')(SDOL(L,J),L=1,6),
     1 (V(I,J),I=1,3),((UNIM(I,K),K=1,5),I=1,3)
      DO 21 I=1,3
      DO 20 JJ=1,5
20    II(JJ)=UNIM(I,JJ)
      CALL CONVE(II,DH)
21    S(I,J)=DH
22    CONTINUE
C-----Orthogonal coordinates and s.u.'s
      DO 39 I=1,3
      XK(I)=0.0
      DO 37 J=1,N-1
      DO 37 K=J+1,N
37    XK(I)=XK(I)+(V(I,J)-V(I,K))**2
39    XK(I)=SQRT(XK(I)/(N*(N-1)))/4
      O(1,1)=C(1)
      O(1,2)=C(2)*CS(3)
      O(1,3)=C(3)*CS(2)
      O(2,1)=0.0
      O(2,2)=C(2)*SN(3)
      O(2,3)=-C(3)*SN(2)*CSAR
      O(3,1)=0.0
      O(3,2)=0.0
      O(3,3)=C(3)*SN(2)*SNAR
      DO 41 J=1,N
      DO 40 I=1,3
      X(I)=V(I,J)
40    SX(I)=S(I,J)
      CALL ORTHO(X,SX,XO,SXO,SGAR,CSAR,SNAR)
      DO 41 I=1,3
      VO(I,J)=XO(I)
      SO(I,J)=SXO(I)
41    CONTINUE
      IF(NH1.EQ.0.OR.N.GT.500) GO TO 23
      CALL CALCOH(N,NH1,KOR)
23    CONTINUE
C-----Matrix of the atom symbols
      DO 32 J=1,N
      MINUS(1)=SDOL(1,J)
      MINUS(2)=SDOL(2,J)
      CALL MINUMA(NCS,MINUS)
      SDOL(1,J)=MINUS(1)
      SDOL(2,J)=MINUS(2)
      DO 38 L=1,6
38    AAAA(L)=SDOL(L,J)
      CALL LABL(AAAA,KY,NNS,LA1,LBA,KKD)
      SDL1(1,J)=LBA(1)
      SDL1(2,J)=LBA(2)
32    CONTINUE
C-----Print atomic coordinates
      IF(KC.EQ.0) GO TO 36
      WRITE(IO,'(/'' Number of atoms:  '',I5//'' Atomic coordinates''/
     1 '' Atom'',14X,''X/a'',17X,''Y/b'',17X,''Z/c'')')N
      DO 25 J=1,N
      DO 24 I=1,3
24    NS(I)=(S(I,J)*1E5+.5)
      CHR1=SDOL(1,J)
      CHR2=SDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,1)=SDOL(1,J)
      LBL(2,1)=CHR2
      LBL(3,1)=SDOL(3,J)
      LBL(4,1)=SDOL(4,J)
      LBL(5,1)=SDOL(5,J)
      LBL(6,1)=SDOL(6,J)
25    WRITE(IO,'(1X,6A1,6X,3(F8.5,''('',I5,'')'',5X))')(LBL(L,1),
     1 L=1,6),(V(I,J),NS(I),I=1,3)
36    IF(KO.EQ.0) GO TO 160
      WRITE(IO,215)((O(I,J),J=1,3),I=1,3)
215   FORMAT(/' Orthogonal coordinates (Angstrom)'/
     1 1X,'Orthogonalization matrix:'/
     2 1X,'a  b cosgamma        c cosbeta     ',1X,3F10.5/
     3 1X,'0  b singamma  -c sinbeta cosalpha*',1X,3F10.5/
     4 1X,'0       0       c sinbeta sinalpha*',1X,3F10.5//
     5 1X,'Atom',14X,'X',19X,'Y',19X,'Z')
      DO 42 J=1,N
      CHR1=SDOL(1,J)
      CHR2=SDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,1)=SDOL(1,J)
      LBL(2,1)=CHR2
      LBL(3,1)=SDOL(3,J)
      LBL(4,1)=SDOL(4,J)
      LBL(5,1)=SDOL(5,J)
      LBL(6,1)=SDOL(6,J)
42    WRITE(IO,'(1X,6A1,4X,3(F8.4,''('',F6.4,'')'',4X))')(LBL(L,1),
     1 L=1,6),(VO(I,J),SO(I,J),I=1,3)
160   IF(KOR.EQ.0.OR.KOR.EQ.7) GO TO 43
C-----Anisotropic displacement parameters
      CALL THERPA(RD,N,KOR,PG)
C-----Interatomic distances
43    KLG=0
      CALL BONDI(N,NL,KB,KLG,NL2,DM,KOR,NH2,KD,NNB)
      NL2=NL
      NNB=NL-NNB
      IF(KB.NE.0) WRITE(IO,'('' Number of bond distances:  '',I5/)')NNB
C-----Bond angles
      IF(N.LT.3)GO TO 120
      IF(KA.NE.0) WRITE(IO,218)
218   FORMAT(/' Bond angles (deg)'/
     1 1X,'(s.u. following Cruickshank, Internat. Tables, II, 1959, ',
     2 'p.331)'/34X,'Angle',6X,'s.u.')
      CALL TERNE(NL,NA)
      N1A=0
      DO 47 J=1,NA
      DO 46 K=1,3
      CHR1=SDOL(1,IA(K,J))
      CHR2=SDOL(2,IA(K,J))
      CALL LABLAT(CHR1,CHR2)
      LBL(1,K)=SDOL(1,IA(K,J))
      LBL(2,K)=CHR2
      LBL(3,K)=SDOL(3,IA(K,J))
      LBL(4,K)=SDOL(4,IA(K,J))
      LBL(5,K)=SDOL(5,IA(K,J))
      LBL(6,K)=SDOL(6,IA(K,J))
      DO 46 I=1,3
      XR(K,I)=VO(I,IA(K,J))
46    SXR(K,I)=SO(I,IA(K,J))
      CALL BNDAN(RD,XR,SXR,T1,SA1)
      KD1=0
      IF(KA.LT.0)THEN
      IF(SDL2(IA(1,J)).EQ.'H '.OR.SDL2(IA(3,J)).EQ.'H ')KD1=1
      ENDIF
      IF(KA.NE.0.AND.KD1.EQ.0)WRITE(IO,'(1X,2(6A1,''- ''),6A1,11X,F6.2,
     1 3X,F6.2)')((LBL(L,K),L=1,6),K=1,3),T1,SA1
      IF(KD1.EQ.0)N1A=N1A+1
47    CONTINUE
      IF(KA.NE.0) WRITE(IO,'('' Number of angles:  '',I5/)')N1A
      IF(N.LT.4.OR.NA.LT.2.OR.KT.EQ.0)GO TO 131
C-----Torsion angles and s.u.'s
      WRITE(IO,221)
221   FORMAT(' Torsion angles (deg)'/' (right-hand rule, ',
     1 'Klyne & Prelog.(1960). Experientia,16,521)'/' (s.u.',
     2 ' following Stanford & Waser, Acta Cryst.(1972).A28,213)'/
     3 36X,'Angle',6X,'s.u.')
      CALL QUART(NL,NA,NT)
      KTT=0
      DO 52 J=1,NT
      DO 50 I=1,4
      DO 49 K=1,3
      RO(I,K)=VO(K,IT(I,J))
49    SD(I,K)=SO(K,IT(I,J))
      DO 50 L=1,6
50    DDOL(L,I)=SDOL(L,IT(I,J))
      CALL TORS2(SD,TAU,SIGTAU,KTR)
      DO 155 I=1,4
      CHR1=DDOL(1,I)
      CHR2=DDOL(2,I)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,I)=DDOL(1,I)
      LBL(2,I)=CHR2
      LBL(3,I)=DDOL(3,I)
      LBL(4,I)=DDOL(4,I)
      LBL(5,I)=DDOL(5,I)
155   LBL(6,I)=DDOL(6,I)
      IF(KTR.EQ.1)GO TO 51
      KD1=0
      IF(KT.LT.0)THEN
      IF(SDL2(IT(1,J)).EQ.'H '.OR.SDL2(IT(4,J)).EQ.'H ')THEN
      KD1=1
      KTT=KTT+1
      GO TO 52
      ENDIF
      ENDIF
      WRITE(IO,'(1X,3(6A1,''-''),6A1,5X,2(2X,F7.2))')((LBL(L,I),L=1,6),
     1 I=1,4),TAU,SIGTAU
      GO TO 52
51    KTT=KTT+KTR
      WRITE(IO,238)((LBL(L,I),L=1,6),I=1,4)
238   FORMAT(1X,'Torsion angle ',3(6A1,'-'),6A1,' cannot be ',
     1 'calculated,'/' as two of the three vectors defining it are ',
     2 'nearly collinear')
52    CONTINUE
      NT=NT-KTT
      IF(KT.NE.0) WRITE(IO,'('' Number of torsion angles:  '',I5/)')NT
131   IF(NTN.EQ.0) GO TO 53
C-----Distances or angles formed by non-bonded atoms
      WRITE(IO,206)
206   FORMAT(/' Distances (Angstrom) or angles (deg) formed',
     1 ' by non-bonded atoms'/39X,'Dist./Ang.',5X,'s.u.')
      DO 29 J=1,NTN
      DO 44 K=1,4
      DO 44 L=1,6
44    DDOL(L,K)=' '
      READ(IN,'(4(6A1))')((DDOL(L,K),L=1,6),K=1,4)
      DO 45 K=1,4
      MINUS(1)=DDOL(1,K)
      MINUS(2)=DDOL(2,K)
      CALL MINUMA(NCS,MINUS)
      DDOL(1,K)=MINUS(1)
45    DDOL(2,K)=MINUS(2)
      DO 125 I=1,4
      CHR1=DDOL(1,I)
      CHR2=DDOL(2,I)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,I)=DDOL(1,I)
      LBL(2,I)=CHR2
      LBL(3,I)=DDOL(3,I)
      LBL(4,I)=DDOL(4,I)
      LBL(5,I)=DDOL(5,I)
125   LBL(6,I)=DDOL(6,I)
      IF(DDOL(1,3).NE.' ')GO TO 126
C-----Distances between two atoms
      DO 129 I=1,2
      DO 127 K=1,N
127   IF(DDOL(1,I).EQ.SDOL(1,K).AND.DDOL(2,I).EQ.SDOL(2,K).AND.
     1 DDOL(3,I).EQ.SDOL(3,K).AND.DDOL(4,I).EQ.SDOL(4,K).AND.
     2 DDOL(5,I).EQ.SDOL(5,K).AND.DDOL(6,I).EQ.SDOL(6,K))GO TO 128
      WRITE(IO,228)(DDOL(L,I),L=1,6)
      GO TO 29
128   DO 129 L=1,3
      XX(I,L)=V(L,K)
      SXX(I,L)=S(L,K)
129   XXO(I,L)=VO(L,K)
      DA=0.0
      DO 132 L=1,3
      SSS1(L)=SXX(1,L)
      SSS2(L)=SXX(2,L)
      DD=XXO(1,L)-XXO(2,L)
      IF(ABS(DD).GT.1E-9)DD=DD**2
132   DA=DD+DA
      DA=SQRT(DA)
      DO 133 L=1,3
      D(L)=XX(1,L)-XX(2,L)
      H(L)=D(L)*SC(L)
133   D(L)=D(L)*C(L)
      CALL SGMD(D,H,SSS1,SSS2,DA,SDA)
      WRITE(IO,'(1X,6A1,''...'',6A1,20X,2(4X,F7.4))')((LBL(L,I),
     1 L=1,6),I=1,2),DA,SDA
      GO TO 29
126   IF(DDOL(1,4).NE.' ')GO TO 111
C-----Angles defined by three atoms
      DO 48 I=1,3
      DO 56 K=1,N
56    IF(DDOL(1,I).EQ.SDOL(1,K).AND.DDOL(2,I).EQ.SDOL(2,K).AND.
     1 DDOL(3,I).EQ.SDOL(3,K).AND.DDOL(4,I).EQ.SDOL(4,K).AND.
     2 DDOL(5,I).EQ.SDOL(5,K).AND.DDOL(6,I).EQ.SDOL(6,K))GO TO 64
      WRITE(IO,228)(DDOL(L,I),L=1,6)
      GO TO 29
64    DO 48 L=1,3
      XR(I,L)=VO(L,K)
48    SXR(I,L)=SO(L,K)
      CALL BNDAN(RD,XR,SXR,T1,SA1)
      WRITE(IO,'(1X,2(6A1,''...''),6A1,11X,2(4X,F7.2))')((LBL(L,I),
     1 L=1,6),I=1,3),T1,SA1
      GO TO 29
C-----Torsion angles defined by four atoms (non necessarily bonded)
111   DO 28 I=1,4
      DO 26 K=1,N
26    IF(DDOL(1,I).EQ.SDOL(1,K).AND.DDOL(2,I).EQ.SDOL(2,K).AND.
     1 DDOL(3,I).EQ.SDOL(3,K).AND.DDOL(4,I).EQ.SDOL(4,K).AND.
     2 DDOL(5,I).EQ.SDOL(5,K).AND.DDOL(6,I).EQ.SDOL(6,K))GO TO 27
      WRITE(IO,228)(DDOL(L,I),L=1,6)
      GO TO 29
27    DO 28 L=1,3
      RO(I,L)=VO(L,K)
28    SD(I,L)=SO(L,K)
      CALL TORS2(SD,TAU,SIGTAU,KTR)
      IF(KTR.EQ.1)GO TO 124
      WRITE(IO,'(1X,3(6A1,''...''),6A1,2X,2(4X,F7.2))')((LBL(L,I),
     1 L=1,6),I=1,4),TAU,SIGTAU
      GO TO 29
124   WRITE(IO,263)((LBL(L,I),L=1,6),I=1,4)
263   FORMAT(' Torsion ',3(6A1,'-'),6A1,' cannot be calculated')
29    CONTINUE
C-----Bond matrix involving hydrogens
53    CALL HB1(NL,NH)
C-----Least-squares planes or lines
      IF(LSP.EQ.0.AND.LSL.EQ.0) GO TO 82
      IF(LSP.EQ.0)GO TO 63
      WRITE(IO,224)
224   FORMAT(/' Weighted least-squares planes through the starred',
     1 ' atoms'/' (Nardelli, Musatti, Domiano & Andreetti',
     2 ' Ric.Sci.(1965),15(II-A),807).'/' Equation of the plane:',
     3 ' m1*X+m2*Y+m3*Z=d')
      IDEP=0
      I=1
      DO 4 III=1,LSP
      LD=1
      CALL READAT(LD,NC,NT,NFP,IER)
      IF(IER.EQ.1)GO TO 4
      DO 33 J=1,NT
      MINUS(1)=PDOL(1,J)
      MINUS(2)=PDOL(2,J)
      CALL MINUMA(NCS,MINUS)
      PDOL(1,J)=MINUS(1)
33    PDOL(2,J)=MINUS(2)
      NP=NT-NFP
      IF(NP.LE.40)GO TO 55
      WRITE(IO,'(/'' There are too many atoms in plane N. '',I2/
     1 '' Please, reduce their number''/)')I
      NP=40
55    IF(NP.GE.3)GO TO 57
      WRITE(IO,227)((PDOL(L,J),L=1,6),J=1,NT)
227   FORMAT(/' The number of the atoms is not enough',
     1 ' to define plane:'/8X,12(6A1)/(12(6A1)))
      IDEP=IDEP+1
      GO TO 4
57    DO 58 J=1,NFP
      DO 58 L=1,6
58    FPDOL(L,J)=PDOL(L,NP+J)
      DO 61 J=1,NP
      DO 59 L=1,N
59    IF(PDOL(1,J).EQ.SDOL(1,L).AND.PDOL(2,J).EQ.SDOL(2,L).AND.
     1 PDOL(3,J).EQ.SDOL(3,L).AND.PDOL(4,J).EQ.SDOL(4,L).AND.
     2 PDOL(5,J).EQ.SDOL(5,L).AND.PDOL(6,J).EQ.SDOL(6,L))GO TO 60
      WRITE(IO,228)(PDOL(LL,J),LL=1,6)
228   FORMAT(/' Atom with symbol  ',6A1,'  does not exist.'/
     1 ' Please, check your input data'/)
      IDEP=IDEP+1
      GO TO 4
60    DO 61 K=1,3
      PV(J,K)=VO(K,L)
61    PSV(J,K)=SO(K,L)
      CALL LSQPLA(NP,I,N,IERR)
      IF(IERR.EQ.1)THEN
      WRITE(IO,264)((PDOL(L,J),L=1,6),J=1,NT)
264   FORMAT(//' The plane corresponding to the following atoms',
     1 ' cannot be calculated.'/' Check the coordinates of the input',
     2 ' atoms:'/8X,12(6A1)/(12(6A1)))
      IDEP=IDEP+1
      GO TO 4
      ENDIF
      DO 62 K=1,3
      CDP(K,I)=AM(K)
62    SCDP(K,I)=SAM(K)
      I=I+1
4     CONTINUE
      LSP=LSP-IDEP
63    IF(LSL.EQ.0)GO TO 73
      WRITE(IO,229)
229   FORMAT(/' Weighted least-squares lines through the starred atoms',
     1 /' (Schoemaker,Waser,Marsh & Bergman,Acta Cryst.(1959).12,600)',
     2 /' m1,m2,m3 are the direction cosines referred ',
     3 'to the X,Y,Z orthogonal axes.'/
     4 ' X0,Y0,Z0 are the coordinates of the centroid',
     5 ' of the set of atoms.'/' Equation of the line:',
     6 ' (X-X0)/m1=(Y-Y0)/m2=(Z-Z0)/m3')
      IDEP=0
      I=1
      DO 5 III=1,LSL
      LD=1
      CALL READAT(LD,NC,NT,NFP,IER)
      IF(IER.EQ.1)GO TO 5
      DO 34 J=1,NT
      MINUS(1)=PDOL(1,J)
      MINUS(2)=PDOL(2,J)
      CALL MINUMA(NCS,MINUS)
      PDOL(1,J)=MINUS(1)
34    PDOL(2,J)=MINUS(2)
      NP=NT-NFP
      IF(NP.LE.40)GO TO 65
      WRITE(IO,230)I
230   FORMAT(/' There are too many atoms in the line N. ',I2/
     1 ' Please, reduce their number'/)
      NP=40
65    IF(NP.LT.2)GO TO 66
      GO TO 67
66    WRITE(IO,231)((PDOL(L,J),L=1,6),J=1,NT)
231   FORMAT(//' The number of the atoms is not enough to define line:'/
     1 8X,12(6A1))
      WRITE(IO,'(/)')
      IDEP=IDEP+1
      GO TO 5
67    DO 68 J=1,NFP
      DO 68 L=1,6
68    FPDOL(L,J)=PDOL(L,NP+J)
      DO 71 J=1,NP
      DO 69 L=1,N
69    IF(PDOL(1,J).EQ.SDOL(1,L).AND.PDOL(2,J).EQ.SDOL(2,L).AND.
     1 PDOL(3,J).EQ.SDOL(3,L).AND.PDOL(4,J).EQ.SDOL(4,L).AND.
     2 PDOL(5,J).EQ.SDOL(5,L).AND.PDOL(6,J).EQ.SDOL(6,L))GO TO 70
      WRITE(IO,228)(PDOL(LL,J),LL=1,6)
      GO TO 5
70    DO 71 K=1,3
      PV(J,K)=VO(K,L)
71    PSV(J,K)=SO(K,L)
      CALL LSQLIN(NP,I,N)
      DO 72 K=1,3
      CDL(K,I)=AM(K)
72    SCDL(K,I)=SAM(K)
      I=I+1
5     CONTINUE
      LSL=LSL-IDEP
73    IF(LSP.LT.2)GO TO 76
      WRITE(IO,232)
232   FORMAT(' Dihedral angles formed by LSQ-planes'/
     1 ' Plane - plane',12X,'angle (s.u.)',13X,'angle (s.u.)')
      LSPM1=LSP-1
      DO 75 K=1,LSPM1
      L=K+1
      DO 75 J=L,LSP
      DO 74 I=1,3
      X1(I)=CDP(I,K)
      SX1(I)=SCDP(I,K)
      XO1(I)=CDP(I,J)
74    SXO1(I)=SCDP(I,J)
      CALL ANGDS(K,J,RD)
75    CONTINUE
76    IF(LSL.LT.2)GO TO 79
      WRITE(IO,233)
233   FORMAT(/' Angles formed by LSQ-lines'/
     1 ' Line  - line ',12X,'angle (s.u.)',13X,'angle (s.u.)')
      LSPM1=LSL-1
      DO 78 K=1,LSPM1
      L=K+1
      DO 78 J=L,LSL
      DO 77 I=1,3
      X1(I)=CDL(I,K)
      SX1(I)=SCDL(I,K)
      XO1(I)=CDL(I,J)
77    SXO1(I)=SCDL(I,J)
      CALL ANGDS(K,J,RD)
78    CONTINUE
79    IF((LSP*LSL).EQ.0)GO TO 82
      WRITE(IO,234)
234   FORMAT(/' Angles formed by lines and normals to planes'/
     1 ' Line  - plane',12X,'angle (s.u.)',13X,'angle (s.u.)')
      DO 81 K=1,LSL
      DO 81 J=1,LSP
      DO 80 I=1,3
      X1(I)=CDL(I,K)
      SX1(I)=SCDL(I,K)
      XO1(I)=CDP(I,J)
80    SXO1(I)=SCDP(I,J)
      CALL ANGDS(K,J,RD)
81    CONTINUE
82    IF (NPR.EQ.0) GO TO 110
C-----Ring puckering coordinates
      WRITE(IO,235)
235   FORMAT(//' Ring puckering coordinates'/
     1 ' following Cremer D. & Pople J.A., JACS (1975).97,1354')
      DO 109 I=1,NPR
      WRITE(IO,236)I
236   FORMAT(/' Ring ',I2)
      LD=2
      CALL READAT(LD,NC,NP,NFP,IER)
      IF(IER.EQ.1)GO TO 109
      DO 35 J=1,NP
      MINUS(1)=PDOL(1,J)
      MINUS(2)=PDOL(2,J)
      CALL MINUMA(NCS,MINUS)
      PDOL(1,J)=MINUS(1)
35    PDOL(2,J)=MINUS(2)
      DO 85 J=1,NP
      DO 83 L=1,N
      IF(PDOL(1,J).EQ.SDOL(1,L).AND.PDOL(2,J).EQ.SDOL(2,L).AND.
     1 PDOL(3,J).EQ.SDOL(3,L).AND.PDOL(4,J).EQ.SDOL(4,L).AND.
     2 PDOL(5,J).EQ.SDOL(5,L).AND.PDOL(6,J).EQ.SDOL(6,L))GO TO 84
83    CONTINUE
      CHR1=PDOL(1,J)
      CHR2=PDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,J)=PDOL(1,J)
      LBL(2,J)=CHR2
      LBL(3,J)=PDOL(3,J)
      LBL(4,J)=PDOL(4,J)
      LBL(5,J)=PDOL(5,J)
      LBL(6,J)=PDOL(6,J)
      WRITE(IO,228)(LBL(LL,J),LL=1,6)
      GO TO 109
84    DO 85 K=1,3
      PVT(J,K)=VO(K,L)
      PV1(J,K)=VO(K,L)
85    SPV(J,K)=CP1*SO(K,L)
      NS1=0
      NM1=NP/2-1
      NM2=(NP+1)/2-2
      NM3=(NP+2)/2-3
      DO 86 J=1,NP
      DO 86 K=1,3
86    SXC(J,K)=0D0
      DO 87 M=1,20
      SQ(M)=0D0
      SPHI(M)=0D0
87    STHE(M)=0D0
      SQT=0D0
88    CONTINUE
      CALL CRTCRD(NP,PG)
      CALL PUCK(NP,PG,KDC)
      IF(KDC.EQ.1)GO TO 108
      IF(NS1.NE.0)GO TO 93
      DO 89 J=1,NP
      DO 89 K=1,3
89    XCF(J,K)=XC(J,K)
      DO 90 M=1,NM1
90    QMF(M)=QM(M)
      DO 91 M=1,NM2
91    PHIF(M)=PHI(M)
      DO 92 M=1,NM3
92    THETAF(M)=THETA(M)
      QTF=QT
93    NS1=NS1+1
      DO 94 J=1,NP
      DO 94 K=1,3
      DX(J,K)=ABS(XCF(J,K)-XC(J,K))
94    IF(DX(J,K).GT.1D-07)SXC(J,K)=SXC(J,K)+DX(J,K)**2
      DO 95 M=1,NM1
      DQ(M)=ABS(QMF(M)-QM(M))
95    IF(DQ(M).GT.1D-07)SQ(M)=SQ(M)+DQ(M)**2
      DO 96 M=1,NM2
      DPHI(M)=ABS(PHIF(M)-PHI(M))
96    IF(DPHI(M).GT.1D-07)SPHI(M)=SPHI(M)+DPHI(M)**2
      DO 97 M=1,NM3
      DTHE(M)=ABS(THETAF(M)-THETA(M))
97    IF(DTHE(M).GT.1D-07)STHE(M)=STHE(M)+DTHE(M)**2
      DQT=ABS(QTF-QT)
      IF(DQT.GT.1D-07)SQT=SQT+DQT**2
      IF((NS1-NN-1).EQ.0)GO TO 99
      DO 98 K=1,NP
      DO 98 J=1,3
      M4=M1+M2+M3
      IF(M2.LT.5D7)M4=M4+1357D0
      IF(M4.GE.1D8)M4=M4-1D8
      IF(M4.GE.1D8)M4=M4-1D8
      M1=M2
      M2=M3
      M3=M4
      IF(M3.GE.5D7)PVT(K,J)=PV1(K,J)+SPV(K,J)
98    IF(M3.LT.5D7)PVT(K,J)=PV1(K,J)-SPV(K,J)
      GO TO 88
99    CONTINUE
      DO 100 J=1,NP
      DO 100 K=1,3
      S1(J,K)=0.0
100   IF(SXC(J,K).GT.1D-16)S1(J,K)=UP*DSQRT(SXC(J,K))
      DO 101 M=1,NM1
      S2(M)=0.0
101   IF(SQ(M).GT.1D-16)S2(M)=UP*DSQRT(SQ(M))
      DO 102 M=1,NM2
      S3(M)=0.0
102   IF(SPHI(M).GT.1D-16)S3(M)=UP*DSQRT(SPHI(M))
      DO 103 M=1,NM3
      S4(M)=0.0
103   IF(STHE(M).GT.1D-16)S4(M)=UP*DSQRT(STHE(M))
      S5=0.0
      IF(SQT.GT.1D-16)S5=UP*DSQRT(SQT)
      WRITE(IO,239)
239   FORMAT(' Atom',11X,' Internal cartesian coordinates'/
     1 14X,'X',15X,'Y',15X,'Z')
      DO 104 J=1,NP
      CHR1=PDOL(1,J)
      CHR2=PDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,J)=PDOL(1,J)
      LBL(2,J)=CHR2
      LBL(3,J)=PDOL(3,J)
      LBL(4,J)=PDOL(4,J)
      LBL(5,J)=PDOL(5,J)
      LBL(6,J)=PDOL(6,J)
104   WRITE(IO,240)(LBL(L,J),L=1,6),(XCF(J,K),S1(J,K),K=1,3)
240   FORMAT(1X,6A1,1X,3(1X,F7.4,'(',F6.4,')'))
      DO 105 M=1,NM1
      MP1=M+1
      IF(MP1.LT.10)WRITE(IO,241)MP1,QMF(M),S2(M)
241   FORMAT(' q',I1,1X,' = ',F7.4,'(',F6.4,')')
      IF(MP1.GE.10)WRITE(IO,242)MP1,QMF(M),S2(M)
242   FORMAT(' q',I2,' = ',F7.4,'(',F6.4,')')
105   CONTINUE
      IF(NP.LT.5)GO TO 152
      DO 106 M=1,NM2
      MP1=M+1
      PHIF(M)=PHIF(M)*RD
      S3(M)=S3(M)*RD
      IF(MP1.LT.10)WRITE(IO,243)MP1,PHIF(M),S3(M)
243   FORMAT(' phi',I1,'  = ',F7.2,'(',F6.2,')')
      IF(MP1.GE.10)WRITE(IO,244)MP1,PHIF(M),S3(M)
244   FORMAT(' phi',I2,' = ',F7.2,'(',F6.2,')')
106   CONTINUE
      IF(NP.LT.6)GO TO 152
      WRITE(IO,245)QTF,S5
245   FORMAT(' Total puckering amplitude:  QT = ',F7.4,'(',F6.4,')')
      WRITE(IO,246)
246   FORMAT(' Spherical polar angles:')
      DO 107 M=1,NM3
      MP1=M+1
      THETAF(M)=THETAF(M)*RD
      S4(M)=S4(M)*RD
      IF(MP1.LT.10)WRITE(IO,247)MP1,THETAF(M),S4(M)
247   FORMAT(' Theta',I1,'  = ',F7.2,'(',F6.2,')')
      IF(MP1.GE.10)WRITE(IO,248)MP1,THETAF(M),S4(M)
248   FORMAT(' Theta',I2,' = ',F7.2,'(',F6.2,')')
107   CONTINUE
152   WRITE(IO,'(/'' Asymmetry parameters''/'' Following Nardelli M.'',
     1 '', Acta Cryst.(1983). C39, 1141''/)')
      DO 151 J=1,NP
      DO 151 K=1,3
151   XC(J,K)=XCF(J,K)
      CALL ASYMMP(NP)
      GO TO 109
108   WRITE(IO,249)
249   FORMAT(/' The number of the atoms in the ring is too small,',
     1 ' please check it.'/)
109   CONTINUE
110   IF(NST.EQ.0)GO TO 120
C-----Polar coordinates of atomic environments
      WRITE(IO,250)
250   FORMAT(//' Cartesian and spherical polar coordinates'/
     1 ' for stereographic projections')
      DO 119 I=1,NST
      WRITE(IO,'(/'' Set '',I2/)')I
      LD=3
      CALL READAT(LD,KO,NP,NQ,IER)
      IF(IER.EQ.1)GO TO 119
      DO 54 J=1,NP
      MINUS(1)=PDOL(1,J)
      MINUS(2)=PDOL(2,J)
      CALL MINUMA(NCS,MINUS)
      PDOL(1,J)=MINUS(1)
54    PDOL(2,J)=MINUS(2)
      DO 114 J=1,NP
      CHR1=PDOL(1,J)
      CHR2=PDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,J)=PDOL(1,J)
      LBL(2,J)=CHR2
      LBL(3,J)=PDOL(3,J)
      LBL(4,J)=PDOL(4,J)
      LBL(5,J)=PDOL(5,J)
      LBL(6,J)=PDOL(6,J)
      DO 112 L=1,N
      IF(PDOL(1,J).EQ.SDOL(1,L).AND.PDOL(2,J).EQ.SDOL(2,L).AND.
     1 PDOL(3,J).EQ.SDOL(3,L).AND.PDOL(4,J).EQ.SDOL(4,L).AND.
     2 PDOL(5,J).EQ.SDOL(5,L).AND.PDOL(6,J).EQ.SDOL(6,L))GO TO 113
112   CONTINUE
      WRITE(IO,228)(LBL(L,J),L=1,6)
      GO TO 119
113   DO 114 K=1,3
114   PVT(J,K)=VO(K,L)
      GO TO(115,116,117),KO
115   WRITE(IO,253)(LBL(L,1),L=1,6),(LBL(L,1),L=1,6),
     1 (LBL(L,2),L=1,6)
253   FORMAT(' Atom ',6A1,' is at the origin.'/
     1 ' The Z axis lies along the vector ',6A1,'-',6A1)
      GO TO 118
116   NQM1=NQ-1
      WRITE(IO,254)(LBL(L,1),L=1,6),NQM1,(LBL(L,1),L=1,6)
254   FORMAT(' Atom ',6A1,' is at the origin.'/
     1 ' The Z axis is perpendicular to the mean plane'/
     2 ' through the ',I2,' atoms following ',6A1)
      GO TO 118
117   WRITE(IO,255)NQ,NQ
255   FORMAT(' The origin is at the geometrical centre of the set'/
     1 ' formed by the first ',I2,' atoms.'/
     2 ' The Z axis is perpendicular to the mean plane'/
     3 ' through the first ',I2,' atoms')
118   CALL CRTPL(KO,NQ,NP,PDOL,PG,RD)
119   CONTINUE
C120  IF(KD.EQ.0)GO TO 121
C-----Interatomic contacts less than DM
120   KLG=1
      CALL BONDI(N,NL,KB,KLG,NL2,DM,KOR,NH2,KD,NNB)
      NNB=NL-NNB
      IF(KD.NE.0)WRITE(IO,256)NNB
256   FORMAT(' Number of contacts:  ',I5)
C-----Intermolecular contacts less than DM
121   NL=0
      IS=0
      NPE=0
      DO 30 I=1,38
      DO 30 J=1,50
30    STPE(I,J)=' '
      KKR=1
      CALL INTERC(N,DM,NL,BRV,NH2,IS,KKR,KE)
      IF(KE.NE.0) WRITE(IO,256) NL
      IF(NH.EQ.0) GO TO 154
C-----Possible hydrogen bonds
      CALL HDRB(NH,NH2,RD,SGAR,CSAR,SNAR)
      IF(IS.EQ.0) GO TO 154
      WRITE(IO,261)
261   FORMAT(/' Warning! The number of possible hydrogen ',
     1 'bonds may be greater than that quoted'/)
154   IF(NI.EQ.0) GO TO 123
C-----Comparison of atomic subsets
      WRITE(IO,262)
262   FORMAT(//' Comparison of coordinates of atomic subsets'/)
      NIA=ABS(NI)
      DO 153 I=1,NIA
      KE=ABS(KE)
      CALL SYMMOL(N,I,NI,KE,BRV)
153   CONTINUE
123   WRITE(IO,258)
258   FORMAT(//' I hope that you succeeded in using this program and'/
     1' that the results of the calculations are useful to have'/
     2' a better understanding of your structure. Best wishes!')
122   CLOSE (IN)
      CLOSE (IO)
      STOP
      END
 
      SUBROUTINE INPOUT
C-----Assignes the input and output files
      CHARACTER*10 STR1
      CHARACTER*8,STR2
      CHARACTER*14 FILIN
      COMMON/INPOU/IN,IO
      STR1='Key in the'
      STR2='put file'
      WRITE(*,'(1X,A10,'' in'',A8/'' ?>'')')STR1,STR2
      READ(*,'(A14)')FILIN
      OPEN(UNIT=IN,FILE=FILIN,FORM='FORMATTED')
      REWIND(UNIT=IN)
      WRITE(*,'(1X,A10,'' out'',A8/'' ?>'')')STR1,STR2
      READ(*,'(A14)')FILIN
      OPEN(UNIT=IO,FILE=FILIN,FORM='FORMATTED')
      REWIND(UNIT=IO)
      RETURN
      END
 
      SUBROUTINE MINUMA(N,STR)
C-----This routine transforms the lower case characters into upper
C-----case characters, in a string of N characters
      CHARACTER*1 MINU(26),MAIU(26),STR(N)
      COMMON/MIMA/MINU,MAIU
      DO 2 I=1,N
      DO 1 J=1,26
      IF(STR(I).NE.MINU(J)) GO TO 1
      STR(I)=MAIU(J)
      GO TO 2
1     CONTINUE
2     CONTINUE
      RETURN
      END
 
      SUBROUTINE LABLAT(CHR1,CHR2)
C-----This routine transforms the second character of an atom label
C-----in a low case character when this is part of the atomic symbol
      CHARACTER*1 MINU(26),MAIU(26),CHR1,CHR2,LA1(2,20)
      CHARACTER*2 LA(20)
      EQUIVALENCE (LA1(1,1),LA(1))
      COMMON/MIMA/MINU,MAIU
     1      /GRP10/LA
     2      /GRP12/NNS
      DO 1 I=1,NNS
      IF(CHR1.EQ.LA1(1,I).AND.CHR2.EQ.LA1(2,I))GO TO 2
1     CONTINUE
      RETURN
2     DO 3 J=1,26
      IF(CHR2.EQ.MAIU(J)) CHR2=MINU(J)
3     CONTINUE
      RETURN
      END
 
      SUBROUTINE LABL(AAAA,KY,NS,LA1,LBA,KKD)
C-----This routine finds the atom species from its label
      CHARACTER*1 AAAA(6),LA1(2,20),LBA(2),MINU(26),MAIU(26),MINUS(2)
      COMMON/INPOU/IN,IO
     1      /MIMA/MINU,MAIU
      DO 7 I=1,NS
      MINUS(1)=LA1(1,I)
      MINUS(2)=LA1(2,I)
      CALL MINUMA(2,MINUS)
      LA1(1,I)=MINUS(1)
7     LA1(2,I)=MINUS(2)
      IF(KY.EQ.1)THEN
      DO 1 J=1,NS
      IF(AAAA(1).EQ.LA1(1,J).AND.AAAA(2).EQ.LA1(2,J))GO TO 3
1     CONTINUE
      DO 2 K=1,NS
      IF(AAAA(1).EQ.LA1(1,K))GO TO 4
2     CONTINUE
      WRITE(IO,100)AAAA
100   FORMAT('Atom ',6A1,' is not among the given species'/
     1 'The first two characters are assumed')
      LBA(1)=AAAA(1)
      LBA(2)=AAAA(2)
      KKD=1
      RETURN
3     LBA(1)=LA1(1,J)
      LBA(2)=LA1(2,J)
      RETURN
4     LBA(1)=LA1(1,K)
      LBA(2)=' '
      RETURN
      ENDIF
      LBA(1)=AAAA(1)
      DO 5 I=1,26
      IF(AAAA(2).EQ.MAIU(I))GO TO 6
5     CONTINUE
      LBA(2)=' '
      RETURN
6     LBA(2)=AAAA(2)
      RETURN
      END
 
      SUBROUTINE VOLMET(RD,VL,SGAR,CSAR,SNAR)
C-----Calculates the unit cell volume with its s.u. and
C-----the metric tensor
      DIMENSION H(3),T(3)
      COMMON/GRP1/C(3),SC(3),A(3),SA(3)
     1      /INS3/CR(3)
     2      /INS4/CS(3),SN(3)
     3      /INS6/G(6)
     4      /INPOU/IN,IO
      WRITE(IO,'(/'' Crystal data'')')
      WRITE(IO,100)(C(I),SC(I),A(I),SA(I),I=1,3)
100   FORMAT(' a = ',F8.4,'(',F6.4,')',25X,'alpha= ',F6.2,'(',
     1 F4.2,')'/' b = ',F8.4,'(',F6.4,')',25X,'beta = ',F6.2,'(',
     2 F4.2,')'/' c = ',F8.4,'(',F6.4,')',25X,'gamma= ',F6.2,'(',
     3 F4.2,')')
      DO 3 I=1,3
      A(I)=A(I)/RD
      IF(ABS(SA(I)).EQ.0.) GO TO 2
      SA(I)=SA(I)/RD
2     CS(I)=COS(A(I))
      IF(ABS(CS(I)).LT.1E-6)CS(I)=0.
      SN(I)=SIN(A(I))
      R=SC(I)/C(I)
      H(I)=0.
3     IF(R.GT.1E-9)H(I)=R*R
      R=1.-CS(1)*CS(1)-CS(2)*CS(2)+CS(3)*(2.*CS(1)*CS(2)-CS(3))
      VL=C(1)*C(2)*C(3)*SQRT(R)
      T(1)=CS(2)*CS(3)-CS(1)
      T(2)=CS(1)*CS(3)-CS(2)
      T(3)=CS(1)*CS(2)-CS(3)
      Q1=0.0
      Q2=0.0
      DO 4 I=1,3
      Q1=Q1+H(I)
      Q3=SN(I)*T(I)*SA(I)
      IF(ABS(Q3).LT.1E-8)Q3=0.
4     Q2=Q2+Q3*Q3
      SV=VL*SQRT(Q1+Q2/(R*R))
      CR(1)=C(2)*C(3)*SN(1)/VL
      CR(2)=C(1)*C(3)*SN(2)/VL
      CR(3)=C(1)*C(2)*SN(3)/VL
      WRITE(IO,101)VL,SV
101   FORMAT(' V = ',F9.2,'(',F5.2,')  cubic-Angstrom'/)
      CSAR=T(1)/(SN(2)*SN(3))
      IF(ABS(CSAR).LT.1E-6)CSAR=0.0
      SNAR=SQRT(1.-CSAR*CSAR)
      SGAR=SQRT((SN(1)*SA(1))**2+((SN(2)*CS(3)+CSAR*CS(2)*SN(3))*
     1 SA(2))**2+((CS(2)*SN(3)+CSAR*SN(2)*CS(3))*SA(3))**2)/(SNAR
     2 *SN(2)*SN(3))
      IF(ABS(SGAR).LT.1E-8)SGAR=0.0
      DO 6 I=1,3
6     G(I)=C(I)*C(I)
      G(4)=C(2)*C(3)*CS(1)
      G(5)=C(1)*C(3)*CS(2)
      G(6)=C(1)*C(2)*CS(3)
      RETURN
      END
 
      SUBROUTINE NIGGLI(BRV,RD)
C-----This routine carries out the Niggli reduction using the
C-----Crivy & Gruber algorithm (Acta Cryst.(1976).A32,297).
      CHARACTER*1 BRV
      DIMENSION MT(3,3),AMT(3,3),CN(3),AN(3),ANIG(6),AT1(3,3)
      COMMON/CST1/C1(3),A1(3),T(3,3),AT(3)
     1      /GRP1/C2(3),SC2(3),A2(3),SA2(3)
     2      /INS4/CS(3),SN(3)
     3      /INPOU/IN,IO
      DO 1 I=1,3
      C1(I)=C2(I)
1     A1(I)=A2(I)
      CALL PRMTRN(BRV)
      A=C1(1)**2
      B=C1(2)**2
      C=C1(3)**2
      X=2*C1(2)*C1(3)*AT(1)
      E=2*C1(1)*C1(3)*AT(2)
      Z=2*C1(1)*C1(2)*AT(3)
      DO 2 I=1,3
      DO 2 J=1,3
      AMT(I,J)=0.0
2     IF(I.EQ.J)AMT(I,J)=1.
      NN=0
3     CONTINUE
      IF(ABS(X).LT.1E-5)X=0.0
      IF(ABS(E).LT.1E-5)E=0.0
      IF(ABS(Z).LT.1E-5)Z=0.0
      IF(ABS(A-B).LT.1E-5)B=A
      IF(ABS(A-C).LT.1E-5)C=A
      IF(ABS(B-C).LT.1E-5)C=B
      IF(ABS(ABS(X)-ABS(A)).LT.1E-5)X=ISG(X)*A
      IF(ABS(ABS(E)-ABS(A)).LT.1E-5)E=ISG(E)*A
      IF(ABS(ABS(Z)-ABS(A)).LT.1E-5)Z=ISG(Z)*A
      IF(ABS(ABS(X)-ABS(B)).LT.1E-5)X=ISG(X)*B
      IF(ABS(ABS(E)-ABS(B)).LT.1E-5)E=ISG(E)*B
      IF(ABS(ABS(Z)-ABS(B)).LT.1E-5)Z=ISG(Z)*B
      IF(ABS(ABS(X)-ABS(C)).LT.1E-5)X=ISG(X)*C
      IF(ABS(ABS(E)-ABS(C)).LT.1E-5)E=ISG(E)*C
      IF(ABS(ABS(Z)-ABS(C)).LT.1E-5)Z=ISG(Z)*C
      NN=NN+1
      IF(NN.GT.1000) RETURN
      IF(A.GT.B.OR.(A.EQ.B.AND.ABS(X).GT.ABS(E)))GO TO 4
      GO TO 6
C-----Step 1
4     DP=A
      A=B
      B=DP
      DP=X
      X=E
      E=DP
      DO 5 I=1,3
      DO 5 J=1,3
5     MT(I,J)=0
      MT(1,2)=1
      MT(2,1)=1
      MT(3,3)=1
      CALL MTP3(MT,AMT)
6     CONTINUE
      IF(B.GT.C.OR.(B.EQ.C.AND.ABS(E).GT.ABS(Z)))GO TO 7
      GO TO 9
C-----Step 2
7     DP=B
      B=C
      C=DP
      DP=E
      E=Z
      Z=DP
      DO 8 I=1,3
      DO 8 J=1,3
8     MT(I,J)=0
      MT(1,1)=1
      MT(2,3)=1
      MT(3,2)=1
      CALL MTP3(MT,AMT)
      GO TO 3
C-----Step 3
9     DO 10 I=1,3
      DO 10 J=1,3
10    MT(I,J)=0.0
      DO 11 I=1,3
11    MT(I,I)=1
      Y=X*E*Z
      IF(Y.LE.0.0) GO TO 33
      MT(1,1)=ISG(Y)*ISG(X)
      MT(2,2)=ISG(Y)*ISG(E)
      MT(3,3)=ISG(Y)*ISG(Z)
      CALL MTP3(MT,AMT)
      X=ABS(X)
      E=ABS(E)
      Z=ABS(Z)
      GO TO 12
C-----Step 4
33    IF(Y.EQ.0.0) GO TO 34
      MT(1,1)=ISG(Y)*ISG(X)
      MT(2,2)=ISG(Y)*ISG(E)
      MT(3,3)=ISG(Y)*ISG(Z)
      CALL MTP3(MT,AMT)
      X=-1.0*ABS(X)
      E=-1.0*ABS(E)
      Z=-1.0*ABS(Z)
      GO TO 12
34    CALL MTP3(MT,AMT)
12    IF(ABS(X).GT.B.OR.(X.EQ.B.AND.(2.*E).LT.Z).OR.
     1 (X.EQ.(-B).AND.Z.LT.0.0)) GO TO 16
      GO TO 18
C-----Step 5
16    DO 17 I=1,3
      DO 17 J=1,3
      MT(I,J)=0
17    IF(I.EQ.J)MT(I,J)=1
      MT(3,2)=-(ISG(X)*ISG(E)*ISG(Z))
      IF((X*E*Z).EQ.0.0)MT(3,2)=-1
      IF(X.EQ.0.0.AND.E.EQ.0.0.AND.Z.NE.0.0)MT(3,2)=-ISG(Z)
      IF(X.EQ.0.0.AND.E.NE.0.0.AND.Z.EQ.0.0)MT(3,2)=-ISG(E)
      IF(X.NE.0.0.AND.E.EQ.0.0.AND.Z.EQ.0.0)MT(3,2)=-ISG(X)
      CALL MTP3(MT,AMT)
      C=B+C-X*ISG(X)
      E=E-Z*ISG(X)
      X=X-2.*B*ISG(X)
      GO TO 3
C-----Step 6
18    IF(ABS(E).GT.A.OR.(E.EQ.A.AND.(2.*X).LT.Z).OR.
     1 (E.EQ.(-A).AND.Z.LT.0.)) GO TO 19
      GO TO 21
19    DO 20 I=1,3
      DO 20 J=1,3
      MT(I,J)=0
20    IF(I.EQ.J)MT(I,J)=1
      MT(3,1)=-(ISG(X)*ISG(E)*ISG(Z))
      IF((X*E*Z).EQ.0.0)MT(3,1)=-1
      IF(X.EQ.0.0.AND.E.EQ.0.0.AND.Z.NE.0.0)MT(3,1)=-ISG(Z)
      IF(X.EQ.0.0.AND.E.NE.0.0.AND.Z.EQ.0.0)MT(3,1)=-ISG(E)
      IF(X.NE.0.0.AND.E.EQ.0.0.AND.Z.EQ.0.0)MT(3,1)=-ISG(X)
      CALL MTP3(MT,AMT)
      C=A+C-E*ISG(E)
      X=X-Z*ISG(E)
      E=E-2.*A*ISG(E)
      GO TO 3
21    CONTINUE
C-----Step 7
      IF(ABS(Z).GT.A.OR.(Z.EQ.A.AND.(2.*X).LT.E).OR.
     1 (Z.EQ.(-A).AND.E.LT.0.)) GO TO 22
      GO TO 24
22    DO 23 I=1,3
      DO 23 J=1,3
      MT(I,J)=0
23    IF(I.EQ.J)MT(I,J)=1
      MT(2,1)=-(ISG(X)*ISG(E)*ISG(Z))
      IF((X*E*Z).EQ.0.0)MT(2,1)=-1
      IF(X.EQ.0.0.AND.E.EQ.0.0.AND.Z.NE.0.0)MT(2,1)=-ISG(Z)
      IF(X.EQ.0.0.AND.E.NE.0.0.AND.Z.EQ.0.0)MT(2,1)=-ISG(E)
      IF(X.NE.0.0.AND.E.EQ.0.0.AND.Z.EQ.0.0)MT(2,1)=-ISG(X)
      CALL MTP3(MT,AMT)
      B=A+B-Z*ISG(Z)
      X=X-E*ISG(Z)
      Z=Z-2.*A*ISG(Z)
      GO TO 3
24    DP=X+E+Z+A+B
      IF(DP.LT.0.0.OR.(DP.EQ.0.0.AND.(2.*(A+E)+Z).GT.0.0)) GO TO 25
      GO TO 27
C-----Step 8
25    C=A+B+C+X+E+Z
      X=2.*B+X+Z
      E=2.*A+E+Z
      DO 26 I=1,3
      DO 26 J=1,3
      MT(I,J)=0
26    IF(I.EQ.J)MT(I,J)=1
      MT(3,1)=1
      MT(3,2)=1
      CALL MTP3(MT,AMT)
      GO TO 3
C-----Calculation and printing of final parameters
27    ANIG(1)=A
      ANIG(2)=B
      ANIG(3)=C
      ANIG(4)=X/2.
      ANIG(5)=E/2.
      ANIG(6)=Z/2.
      DO 28 I=1,3
28    CN(I)=SQRT(ANIG(I))
      AN(1)=ANIG(4)/(CN(2)*CN(3))
      AN(2)=ANIG(5)/(CN(1)*CN(3))
      AN(3)=ANIG(6)/(CN(1)*CN(2))
      DO 30 I=1,3
      IF(ABS(AN(I)).LE.1E-6)GO TO 29
      AN(I)=ATAN2(SQRT(1.-AN(I)**2),AN(I))
      AN(I)=AN(I)*RD
      GO TO 30
29    AN(I)=90.
30    CONTINUE
      DO 31 I=1,3
      DO 31 J=1,3
      AT1(I,J)=0.
      DO 31 K=1,3
31    AT1(I,J)=AT1(I,J)+AMT(I,K)*T(K,J)
      WRITE(IO,100)CN,AN,ANIG,((AT1(I,J),J=1,3),I=1,3)
100   FORMAT(/' Niggli reduced cell: ',3F7.3,3F7.2/
     1 ' Niggli matrix:   ',3F12.4/18X,3F12.4/
     2 ' Transformation matrix: ',3F8.2/2(24X,3F8.2/))
      RETURN
      END
 
      SUBROUTINE PRMTRN(BRV)
C-----This routine transforms a non primitive lattice into a
C-----primitive one
      CHARACTER*1 BRV
      DIMENSION CT(3),TT(3,3)
      COMMON/CST1/C(3),A(3),T(3,3),AT(3)
     1      /INS4/CS(3),SN(3)
      DO 15 I=1,3
      DO 15 J=1,3
15    T(I,J)=0.
      DO 1 I=1,3
      AT(I)=CS(I)
1     T(I,I)=1.0
C-----Set up the matrix transforming the given cell in a primitive one
      R1=1./2.
      R2=1./3.
      R3=2.*R2
      IF(BRV.EQ.'P')GO TO 14
      IF(BRV.NE.'A')GO TO 2
      T(3,2)=R1
      T(3,3)=R1
2     IF(BRV.NE.'B')GO TO 3
      T(1,1)=R1
      T(1,3)=R1
3     IF(BRV.NE.'C')GO TO 4
      T(2,1)=R1
      T(2,2)=R1
4     IF(BRV.NE.'I')GO TO 5
      T(3,1)=R1
      T(3,2)=R1
      T(3,3)=R1
5     IF(BRV.NE.'F')GO TO 6
      T(1,1)=R1
      T(1,2)=R1
      T(2,1)=-R1
      T(2,2)=R1
      T(3,1)=R1
      T(3,3)=R1
6     IF(BRV.NE.'R')GO TO 7
      T(1,1)=R3
      T(1,2)=R2
      T(1,3)=R2
      T(2,1)=-R2
      T(2,2)=R2
      T(2,3)=R2
      T(3,1)=-R2
      T(3,2)=-R3
      T(3,3)=R2
C-----Calculate three lattice vectors
7     DO 9 I=1,3
      CT(I)=0.0
      DO 8 J=1,3
8     CT(I)=CT(I)+(T(I,J)*C(J))**2
      CT(I)=CT(I)+2.0*(T(I,1)*T(I,2)*C(1)*C(2)*CS(3)+
     1 T(I,2)*T(I,3)*C(2)*C(3)*CS(1)+T(I,1)*T(I,3)*C(1)*C(3)*CS(2))
9     CT(I)=SQRT(ABS(CT(I)))
C-----Calculate the angles formed by three lattice vectors
      DO 10 I=1,3
      TT(1,I)=T(2,I)
10    TT(2,I)=T(3,I)
      T1=CT(2)
      T2=CT(3)
      CALL VECTANG(TT,C,CS,T1,T2,TH,CSTH)
      A(1)=TH
      AT(1)=CSTH
      DO 11 I=1,3
11    TT(1,I)=T(1,I)
      T1=CT(1)
      CALL VECTANG(TT,C,CS,T1,T2,TH,CSTH)
      A(2)=TH
      AT(2)=CSTH
      DO 12 I=1,3
12    TT(2,I)=T(2,I)
      T2=CT(2)
      CALL VECTANG(TT,C,CS,T1,T2,TH,CSTH)
      A(3)=TH
      AT(3)=CSTH
      DO 13 I=1,3
13    C(I)=CT(I)
14    RETURN
      END
 
      SUBROUTINE VECTANG(IN,C,CS,T1,T2,TH,CSTH)
C-----Calculate the angle formed by two lattice vectors
      DIMENSION C(3),CS(3)
      REAL IN(3,3)
      CSTH=IN(1,1)*IN(2,1)*C(1)**2+IN(1,2)*IN(2,2)*C(2)**2+
     1 IN(1,3)*IN(2,3)*C(3)**2
      CSTH=CSTH+(IN(1,1)*IN(2,2)+IN(2,1)*IN(1,2))*C(1)*C(2)*CS(3)+
     1          (IN(1,2)*IN(2,3)+IN(2,2)*IN(1,3))*C(2)*C(3)*CS(1)+
     2          (IN(1,3)*IN(2,1)+IN(2,3)*IN(1,1))*C(3)*C(1)*CS(2)
      IF(ABS(CSTH).LT.1E-6) CSTH=0.0
      CSTH=CSTH/(T1*T2)
      SNTH=SQRT(ABS(1.0-CSTH**2))
      TH=ATAN2(SNTH,CSTH)
      RETURN
      END
 
      SUBROUTINE MTP3(M,AM)
C-----This routine multiplies two 3x3 matrices, the first being
C-----integer, the latter real. The product is put in AM
      DIMENSION M(3,3),AM(3,3),AM1(3,3)
      DO 1 I=1,3
      DO 1 J=1,3
      AM1(I,J)=0.0
      DO 1 K=1,3
1     AM1(I,J)=AM1(I,J)+M(I,K)*AM(K,J)
      DO 2 I=1,3
      DO 2 J=1,3
2     AM(I,J)=AM1(I,J)
      RETURN
      END
 
      FUNCTION ISG(X)
      ISG=1
      IF(X.LT.0.0)ISG=-1
      RETURN
      END
 
      SUBROUTINE MOLABS(NS,VL,Z,AL)
C-----This routine calculates the molecular mass, F(000),
C-----and the absorption coefficient
      CHARACTER*1 CHR1,CHR2,LA1(2,20)
      CHARACTER*2 NOMAT(103),LA(20)
      EQUIVALENCE(LA1(1,1),LA(1))
      REAL MU
      DIMENSION ANAA(20),PA(94),AS1(94),AS2(94)
      COMMON/GRP10/LA
     1      /GRP11/ANAA
     2      /SMBL/NOMAT
     3      /ATWG/PA
     4      /ASSB/AS1,AS2
     5      /INPOU/IN,IO
      IL=AL
      PM=0.0
      MU=0.0
      Z0=0.0
      DO 1 J=1,NS
      DO 2 K=1,94
      IF(LA(J).EQ.NOMAT(K))GO TO 3
   2  CONTINUE
   3  PM=PM+PA(K)*ANAA(J)
      Z0=Z0+K*ANAA(J)
      IF(IL.EQ.0)GO TO 4
      MU=MU+AS1(K)*ANAA(J)
      GO TO 1
   4  MU=MU+AS2(K)*ANAA(J)
   1  CONTINUE
      Z0=Z*Z0
      MU=Z*MU/VL
      DC=1.66053*PM*Z/VL
      KDC=0
      DO 5 I=1,NS
      CHR1=LA1(1,I)
      CHR2=LA1(2,I)
      CALL LABLAT(CHR1,CHR2)
      LA1(2,I)=CHR2
      NNA=ANAA(I)
      DFF=ANAA(I)-NNA
5     IF(ABS(DFF).GT.1E-4)KDC=1
      IF(KDC.EQ.0)WRITE(IO,'(1X,18(A2,F4.0,1X))')(LA(I),ANAA(I),I=1,NS)
      IF(KDC.EQ.1)WRITE(IO,'(1X,10(A2,F6.3,2X))')(LA(I),ANAA(I),I=1,NS)
      WRITE(IO,103)PM,Z,DC,Z0,MU,AL
103   FORMAT(' M',7X,'=',F10.3,10X,'(Atomic weights 1977)'/
     1 ' Z       =',4X,F5.2,/
     2 ' D(calc.)=',2X,F9.4,9X,'Mg/m**3',/' F(000)  =',F8.1/
     3 ' mu      =',2X,F8.3,10X,'cm**-1 (Int.Tab. Vol.C, Table',
     4 ' 4.2.4.2, p.193)'/
     4 ' Lambda  =',5X,F9.7,6X,'Angstrom')
      RETURN
      END
 
      SUBROUTINE ORTHO(X,SX,XO,SXO,SGAR,CSAR,SNAR)
C-----Calculates the orthogonal coordinates with s.u.'s
      DIMENSION XO(3),SXO(3),X(3),SX(3)
      COMMON/GRP1/C(3),SC(3),A(3),SA(3)
     2      /INS4/CS(3),SN(3)
     4      /NEW1/XK(3),O(3,3)
      R=1E-6
      DO 1 I=1,3
      IF(ABS(XK(I)).LT.R) XK(I)=0.0
      IF(SC(I).LT.R) SC(I)=0.0
      IF(SA(I).LT.R) SA(I)=0.0
      IF(ABS(CS(I)).LT.R) CS(I)=0.0
1     IF(SX(I).LT.R) SX(I)=0.0
      IF(SGAR.LT.R) SGAR=0.0
      IF(ABS(CSAR).LT.R) CSAR=0.0
      XO(1)=X(1)*O(1,1)+X(2)*O(1,2)+X(3)*O(1,3)
      XO(2)=X(2)*O(2,2)+X(3)*O(2,3)
      XO(3)=X(3)*O(3,3)
      SXO(1)=SQRT((XK(1)*SC(1))**2+(XK(2)*CS(3)*SC(2))**2
     1 +(XK(3)*CS(2)*SC(3))**2+(C(1)*SX(1))**2+(C(2)*CS(3)*SX(2))
     2 **2+(C(3)*CS(2)*SX(3))**2+(XK(2)*C(2)*SN(3)*SA(3))**2
     3 +(XK(3)*C(3)*SN(2)*SA(2))**2)
      SXO(2)=SQRT((XK(2)*SN(3)*SC(2))**2+(XK(3)*SN(2)*CSAR*
     1 SC(3))**2+(C(2)*SN(3)*SX(2))**2+(C(3)*SN(2)*CSAR*SX(3))
     2 **2+(XK(2)*C(2)*CS(3)*SA(3))**2+(XK(3)*C(3)*CS(2)*CSAR*
     3 SA(2))**2+(XK(3)*C(3)*SN(2)*SNAR*SGAR)**2)
      SXO(3)=SQRT((XK(3)*SN(2)*SNAR*SC(3))**2+(C(3)*SN(2)*SNAR
     1 *SX(3))**2+(C(3)*XK(3)*CS(2)*SNAR*SA(2))**2+(C(3)*XK(3)*
     2 SN(2)*CSAR*SGAR)**2)
      RETURN
      END
 
      SUBROUTINE CALCOH(N,NH1,KOR)
C-----This routine calculates the hydrogen coordinates in typical
C-----groups following M.Nardelli (Computers & Chemistry (1982),
C-----6,139)
      CHARACTER*1 SDOL(6,500),SL(6,4),MINUS(2),CRT(6),STR
      DIMENSION OI(6),X1(3),X2(3),XF(3,3),AN(6),XA(3,6),SS(3)
      COMMON/GRP3/VO(3,500),SO(3,500)
     1      /COOR/V(3,500),S(3,500)
     2      /GRP4/SDOL
     3      /NEW1/XK(3),O1(3,3)
     4      /INS8/B(6,500),SB(6,500)
     5      /LTD1/XB(3,5)
     6      /INPOU/IN,IO
      OI(1)=1./O1(1,1)
      OI(2)=-O1(1,2)/(O1(1,1)*O1(2,2))
      OI(3)=(O1(1,2)*O1(2,3)-O1(2,2)*O1(1,3))/
     1 (O1(1,1)*O1(2,2)*O1(3,3))
      OI(4)=1./O1(2,2)
      OI(5)=-O1(2,3)/(O1(2,2)*O1(3,3))
      OI(6)=1./O1(3,3)
      NH=0
      DO 32 J=1,NH1
      IF(N.GE.500) GO TO 33
      READ(IN,'(I1,1X,F6.4,4(6A1))') KDG,D,((SL(L,K),L=1,6),K=1,4)
      DO 41 I=1,4
      MINUS(1)=SL(1,I)
      MINUS(2)=SL(2,I)
      NCS=2
      CALL MINUMA(NCS,MINUS)
      SL(1,I)=MINUS(1)
41    SL(2,I)=MINUS(2)
      DO 40 I=1,3
40    SS(I)=0.0
      BH=0.0
      SBH=0.0
      GO TO(34,34,35,34,36,35),KDG
34    NN=3
      GO TO 37
35    NN=4
      GO TO 37
36    NN=2
37    DO 3 K=1,NN
      DO 1 JJ=1,N
      DO 39 L=1,6
      CRT(L)=SDOL(L,JJ)
      STR=CRT(L)
      N1=1
      CALL MINUMA(N1,STR)
      CRT(L)=STR
      IF(SL(L,K).NE.CRT(L)) GO TO 1
39    CONTINUE
      JL=JJ
      GO TO 2
1     CONTINUE
      WRITE(IO,100)(SL(L,K),L=1,6)
100   FORMAT(/' Atom ',6A1,' doesn''t exist in your set. ',
     1 'Please, check your input data.'/)
      GO TO 32
2     DO 3 L=1,3
      XA(L,K)=VO(L,JL)
      SS(L)=SS(L)+SO(L,JL)**2
      IF(K.NE.1.OR.KOR.EQ.0) GO TO 3
      BH=BH+B(L,JL)
      SBH=SBH+SB(L,JL)
3     CONTINUE
      IF(KOR.EQ.0) GO TO 4
      BH=BH/3.
      SBH=SBH/3.
4     DO 5 L=1,3
5     SS(L)=SQRT(SS(L))
      GO TO(6,12,16,21,25,28),KDG
C-----Methyl group
6     DO 7 I=1,3
7     X1(I)=XA(I,2)-XA(I,3)
      CALL NORM(X1)
      DO 8 I=1,3
      XA(I,4)=XA(I,1)+X1(I)*D
      XB(I,1)=XA(I,1)
      XB(I,2)=XA(I,2)
8     XB(I,3)=XA(I,4)
      CALL METLNE(D)
      DO 9 I=1,3
      XA(I,5)=XB(I,4)
9     XA(I,6)=XB(I,5)
      DO 11 L=4,6
      N=N+1
      IF(N.GT.500) GO TO 33
      DO 10 I=1,3
10    X1(I)=XA(I,L)
      CALL COORDH(N,NH,X1,SS,OI,KOR,BH,SBH)
11    CONTINUE
      GO TO 32
C-----Methylene group
12    DO 13 I=1,3
      DO 13 L=1,3
13    XB(L,I)=XA(L,I)
      CALL METLNE(D)
      DO 15 L=4,5
      N=N+1
      IF(N.GT.500) GO TO 33
      DO 14 I=1,3
14    X1(I)=XB(I,L)
      CALL COORDH(N,NH,X1,SS,OI,KOR,BH,SBH)
15    CONTINUE
      GO TO 32
C-----Tert-C group
16    DO 17 I=1,3
      DO 17 L=1,3
17    XF(L,I)=XA(L,1)-XA(L,I+1)
      DO 19 I=1,3
      DO 18 L=1,3
18    X1(L)=XF(L,I)
      CALL NORM(X1)
      DO 19 L=1,3
19    XF(L,I)=X1(L)
      AN(1)=XF(2,1)*XF(3,2)-XF(3,1)*XF(2,2)
      AN(2)=XF(3,1)*XF(1,2)-XF(1,1)*XF(3,2)
      AN(3)=XF(1,2)*XF(2,3)-XF(2,2)*XF(1,3)
      AN(4)=XF(2,1)*XF(1,3)-XF(1,1)*XF(2,3)
      AN(5)=XF(1,1)*XF(2,2)-XF(1,2)*XF(2,1)
      AN(6)=(AN(1)*XF(1,3)+AN(2)*XF(2,3))/AN(5)+XF(3,3)
      X1(3)=(AN(3)+AN(4)+AN(5))/(AN(5)*AN(6))
      X1(2)=(X1(3)*AN(2)+XF(1,1)-XF(1,2))/AN(5)
      X1(1)=(X1(3)*AN(1)+XF(2,2)-XF(2,1))/AN(5)
      CALL NORM(X1)
      DO 20 I=1,3
      XA(I,5)=XA(I,1)+X1(I)*D
20    X1(I)=XA(I,5)
      N=N+1
      IF(N.GT.500) GO TO 33
      CALL COORDH(N,NH,X1,SS,OI,KOR,BH,SBH)
      GO TO 32
C-----Benzene C-H group
21    DO 22 L=1,3
      X1(L)=XA(L,1)-XA(L,2)
22    X2(L)=XA(L,1)-XA(L,3)
      CALL NORM(X1)
      CALL NORM(X2)
      DO 23 L=1,3
23    X1(L)=X1(L)+X2(L)
      CALL NORM(X1)
      DO 24 L=1,3
      XA(L,4)=XA(L,1)+X1(L)*D
24    X1(L)=XA(L,4)
      N=N+1
      IF(N.GT.500) GO TO 33
      CALL COORDH(N,NH,X1,SS,OI,KOR,BH,SBH)
      GO TO 32
C-----Alkyne group
25    DO 26 L=1,3
26    X1(L)=XA(L,1)-XA(L,2)
      CALL NORM(X1)
      DO 27 L=1,3
      XA(L,3)=XA(L,1)+X1(L)*D
27    X1(L)=XA(L,3)
      N=N+1
      IF(N.GT.500) GO TO 33
      CALL COORDH(N,NH,X1,SS,OI,KOR,BH,SBH)
      GO TO 32
C-----Ethylenic system
28    DO 31 L=1,2
      DO 29 I=1,3
29    X1(I)=XA(I,2)-XA(I,L+2)
      CALL NORM(X1)
      DO 30 I=1,3
30    X1(I)=XA(I,1)+X1(I)*D
      N=N+1
      IF(N.GT.500) GO TO 33
      CALL COORDH(N,NH,X1,SS,OI,KOR,BH,SBH)
31    CONTINUE
32    CONTINUE
      GO TO 38
33    N=500
38    RETURN
      END
 
      SUBROUTINE NORM(X)
C-----This routine normalizes a 3-dimensional vector
      DIMENSION X(3)
      COMMON/INPOU/IN,IO
      S=0.0
      DO 1 I=1,3
1     S=S+X(I)**2
      S=SQRT(S)
      IF(S.LT.1E-6)THEN
      WRITE(IO,'(''WARNING: There is something wrong with the '',
     1 ''input data'')')
      S=1.0
      ENDIF
      DO 2 I=1,3
2     X(I)=X(I)/S
      RETURN
      END
 
      SUBROUTINE COORDH(N,NH,X,SS,O,KOR,BH,SBH)
C-----This routine puts a hydrogen atom in the coordinate Tables
      CHARACTER*1 SDOL(6,500),INDC(10),SAT(6)
      DIMENSION X(3),O(6),SS(3)
      COMMON/COOR/V(3,500),S(3,500)
     1      /GRP3/VO(3,500),SO(3,500)
     2      /GRP4/SDOL
     3      /INS8/B(6,500),SB(6,500)
      DATA INDC/'0','1','2','3','4','5','6','7','8','9'/
      NH=NH+1
      DO 1 I=1,3
      VO(I,N)=X(I)
1     SO(I,N)=SS(I)
      V(1,N)=X(1)*O(1)+X(2)*O(2)+X(3)*O(3)
      V(2,N)=X(2)*O(4)+X(3)*O(5)
      V(3,N)=X(3)*O(6)
      S(1,N)=SS(1)*O(1)+SS(2)*O(2)+SS(3)*O(3)
      S(2,N)=SS(2)*O(4)+SS(3)*O(5)
      S(3,N)=SS(3)*O(6)
      ND=NH/10
      NU=NH-ND*10
      SAT(1)='H'
      SAT(2)=' '
      SAT(3)=' '
      SAT(4)=' '
      SAT(5)=' '
      SAT(6)=' '
      DO 4 I=1,10
      IF(ND.NE.I-1) GO TO 3
      SAT(3)=INDC(I)
3     IF(NU.NE.I-1) GO TO 4
      SAT(4)=INDC(I)
4     CONTINUE
      IF(SAT(3).EQ.'0') SAT(3)=' '
      DO 5 I=1,6
5     SDOL(I,N)=SAT(I)
      IF(KOR.EQ.0) GO TO 7
      B(1,N)=BH
      SB(1,N)=SBH
      DO 6 I=2,6
      B(I,N)=0.0
6     SB(I,N)=0.0
7     RETURN
      END
 
      SUBROUTINE METLNE(D)
C-----This routine calculates the coordinates of methylene
C-----hydrogens
      DIMENSION A(3),B(3),S(3),T(3)
      COMMON/LTD1/XB(3,5)
     1      /INPOU/IN,IO
      DO 1 I=1,3
      A(I)=XB(I,1)-XB(I,2)
1     B(I)=XB(I,1)-XB(I,3)
      CALL NORM(A)
      CALL NORM(B)
      DO 2 I=1,3
2     S(I)=A(I)+B(I)
      CALL NORM(S)
      T(1)=A(2)*B(3)-A(3)*B(2)
      T(2)=A(3)*B(1)-A(1)*B(3)
      T(3)=A(1)*B(2)-A(2)*B(1)
      CALL NORM(T)
      D1=D*SQRT(1./3.)
      D2=D*SQRT(2./3.)
      DO 3 I=1,3
      XB(I,4)=XB(I,1)+S(I)*D1+T(I)*D2
3     XB(I,5)=XB(I,1)+S(I)*D1-T(I)*D2
      RETURN
      END
 
      SUBROUTINE THERPA(RD,N,KT,PG)
C-----This routine calculates the mean-square displacements
C-----along the principal axes of the thermal ellipsoids and
C-----the isotropic equivalent thermal parameters
      CHARACTER*1 SDOL(6,500),CHR1,CHR2,LBL(6,4)
      DOUBLE PRECISION M1,M2,M3,M4,UP,CP,DQ,SDQ,DR(3),SDR(3)
      DIMENSION F(3,3),FT(3,3),T(3,3),R(3),Q(3,3),E(3,3),
     1 C(3),A(3),CR(3),BT(6,500),BC(6,500),
     2 NT(6),G(6),CS(3),SN(3),SA2(3),SC1(3),
     3 SC(3),SA(3),SBT(6,500),NST(6),RF(3),
     4 S2(3),C1(3),A1(3),BT1(6,500)
      COMMON/INS1/M1,M2,M3,M4
     1      /GRP1/C,SC1,A,SA2
     2      /GRP4/SDOL
     3      /INS8/BT,SBT
     4      /LBL2/CP,UP,NN
     5      /INPOU/IN,IO
      P2=2.*PG*PG
      CP1=CP
      DO 24 I=1,3
      C1(I)=C(I)
      A1(I)=A(I)
      SC(I)=SC1(I)*CP1
24    SA(I)=SA2(I)/RD*CP1
      GO TO (25,26,27,28,17,19),KT
25    WRITE(IO,103)
103   FORMAT(/' Displacement parameters, beta(I,J)x10**5')
      WRITE(IO,112)
112   FORMAT(' exp(-(beta11*h**2+...+2*beta12*h*k+...)')
      WRITE(IO,113)
113   FORMAT(' Atom    beta11',5X,'beta22',5X,'beta33',5X,
     1 'beta23',5X,'beta13',5X,'beta12')
      GO TO 29
26    WRITE(IO,104)
104   FORMAT(/' Displacement parameters, U(I,J)x10**4')
      WRITE(IO,114)
114   FORMAT(' exp(-2*pi**2(U11*h**2*(a*)**2+...+2*U12*h*k*',
     1 '(a*)*(b*)+...)')
      WRITE(IO,115)
115   FORMAT(' Atom    U11',8X,'U22',8X,'U33',8X,'U23',8X,
     1 'U13',8X,'U12')
      GO TO 29
27    WRITE(IO,105)
105   FORMAT(/' Displacement parameters, B(I,J)x10**2')
      WRITE(IO,116)
116   FORMAT(' exp(-0.25*(B11*h**2*(a*)**2+...+2*B12*h*',
     1 'k*(a*)*(b*)+...)')
      WRITE(IO,117)
117   FORMAT(' Atom    B11',8X,'B22',8X,'B33',8X,'B23',8X,
     1 'B13',8X,'B12')
      GO TO 29
28    WRITE(IO,106)
106   FORMAT(/' Displacement parameters, b(I,J)x10**5')
      WRITE(IO,118)
118   FORMAT(' exp(-b11*h**2+...+b12*h*k+...)')
      WRITE(IO,119)
119   FORMAT(' Atom    b11',8X,'b22',8X,'b33',8X,'b23',8X,
     1 'b13',8X,'b12')
      GO TO 29
17    WRITE(IO,104)
      WRITE(IO,109)
109   FORMAT(' exp(-2*pi**2(U11*h**2*(a*)**2+...+2*U12*h*',
     1 'k*(a*)*(b*)*cos(gamma*)+...)')
      WRITE(IO,115)
      GO TO 29
19    WRITE(IO,105)
      WRITE(IO,110)
110   FORMAT(' exp(-2*pi**2(B11*h**2*(a*)**2+...+2*B12*h*',
     1 'k*(a*)*(b*)*cos(gamma*)+...)')
      WRITE(IO,117)
29    CONTINUE
      T1=1E5
      IF(KT.EQ.2.OR.KT.EQ.5)T1=1E4
      IF(KT.EQ.3.OR.KT.EQ.6)T1=1E2
      DO 1 I=1,N
      DO 30 J=1,6
      BT1(J,I)=BT(J,I)
      IF(BT(J,I).GE.0) NT(J)=(BT(J,I)*T1+.5)
      IF(BT(J,I).LT.0) NT(J)=(BT(J,I)*T1-.5)
30    NST(J)=(SBT(J,I)*T1+.5)
      CHR1=SDOL(1,I)
      CHR2=SDOL(2,I)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,1)=SDOL(1,I)
      LBL(2,1)=CHR2
      LBL(3,1)=SDOL(3,I)
      LBL(4,1)=SDOL(4,I)
      LBL(5,1)=SDOL(5,I)
      LBL(6,1)=SDOL(6,I)
      DO 42 J=2,6
      IF(NT(J).NE.0)GO TO 43
42    CONTINUE
      WRITE(IO,121)(LBL(L,1),L=1,6),NT(1),NST(1)
121   FORMAT(1X,6A1,I5,'(',I4,')')
      GO TO 1
43    WRITE(IO,107)(LBL(L,1),L=1,6),(NT(J),NST(J),J=1,6)
107   FORMAT(1X,6A1,6(I5,'(',I4,')'))
      DO 44 J=1,6
44    SBT(J,I)=CP1*SBT(J,I)
1     CONTINUE
      WRITE(IO,108)
108   FORMAT(/' Principal axes of the thermal ellipsoids,',
     1 ' Uequiv. (x10**4 A**2) and'/' Bequiv.(A**2)'/
     2 ' Atom',6X,'R1',9X,'R2',9X,'R3',8X,'Uequiv.',5X,
     3 'Bequiv.  Rmax/Rmin')
      DO 15 K=1,N
      DO 40 I=2,6
      IF(BT(I,K).GT.1E-6)GO TO 41
40    CONTINUE
      GO TO 15
41    CONTINUE
      NS1=0
      SDQ=0D0
      DO 39 I=1,3
39    SDR(I)=0D0
23    CONTINUE
      DO 2 I=1,3
      CS(I)=COS(A(I))
      SN(I)=SIN(A(I))
2     G(I)=C(I)*C(I)
      G(4)=C(2)*C(3)*CS(1)
      G(5)=C(1)*C(3)*CS(2)
      G(6)=C(1)*C(2)*CS(3)
      CSAR=(CS(2)*CS(3)-CS(1))/(SN(2)*SN(3))
      CSBR=(CS(1)*CS(3)-CS(2))/(SN(1)*SN(3))
      CSGR=(CS(1)*CS(2)-CS(3))/(SN(1)*SN(2))
      SNGR=SQRT(1.-CSGR*CSGR)
      RP=SNGR/SN(3)
      SNBR=SN(2)*RP
      SNAR=SN(1)*RP
      CR(1)=1./(C(1)*SN(3)*SNBR)
      CR(2)=1./(C(2)*SN(3)*SNAR)
      CR(3)=1./(C(3)*SN(2)*SNAR)
      F(1,1)=C(1)*SN(2)*SNGR
      F(2,2)=C(2)*SN(1)
      F(3,3)=C(3)
      F(2,1)=0.0
      F(3,1)=0.0
      F(3,2)=0.0
      F(1,2)=-F(1,1)*CSGR/SNGR
      F(1,3)=C(1)*CS(2)
      F(2,3)=C(2)*CS(1)
      DO 18 I=1,3
      DO 18 J=1,3
18    FT(I,J)=F(J,I)
      GO TO(3,4,5,6,4,5),KT
3     DO 7 I=1,6
7     BC(I,K)=BT(I,K)
      GO TO 14
4     DO 9 I=1,3
9     BC(I,K)=P2*CR(I)*CR(I)*BT(I,K)
      BC(4,K)=P2*CR(2)*CR(3)*BT(4,K)
      BC(5,K)=P2*CR(1)*CR(3)*BT(5,K)
      BC(6,K)=P2*CR(1)*CR(2)*BT(6,K)
      IF(KT.EQ.5)GO TO 8
      GO TO 14
5     DO 11 I=1,3
11    BC(I,K)=CR(I)*CR(I)*BT(I,K)/4.
      BC(4,K)=CR(2)*CR(3)*BT(4,K)/4.
      BC(5,K)=CR(1)*CR(3)*BT(5,K)/4.
      BC(6,K)=CR(1)*CR(2)*BT(6,K)/4.
      IF(KT.EQ.6)GO TO 8
      GO TO 14
6     DO 13 I=1,3
13    BC(I,K)=BT(I,K)
      DO 12 I=4,6
12    BC(I,K)=BT(I,K)/2.
      GO TO 14
8     BC(4,K)=BC(4,K)*CSAR
      BC(5,K)=BC(5,K)*CSBR
      BC(6,K)=BC(6,K)*CSGR
14    CONTINUE
      B1=0.0
      B2=0.0
      DO 16 I=1,3
      B1=B1+BC(I,K)*G(I)
16    B2=B2+BC(I+3,K)*G(I+3)
      BQ=(4./3.)*(B1+2.*B2)
      DO 20 I=1,3
20    T(I,I)=BC(I,K)
      T(2,3)=BC(4,K)
      T(1,3)=BC(5,K)
      T(1,2)=BC(6,K)
      T(2,1)=T(1,2)
      T(3,1)=T(1,3)
      T(3,2)=T(2,3)
      CALL MATPR3(T,F,E)
      CALL MATPR3(FT,E,Q)
      CALL EGNVL3(Q,R)
      DO 38 I=1,3
38    R(I)=R(I)/P2
      IF(NS1.NE.0)GO TO 32
      BQF=BQ
      DO 31 I=1,3
31    RF(I)=R(I)
32    NS1=NS1+1
      DQ=ABS(BQ-BQF)
      IF(DQ.GT.1D-07)SDQ=SDQ+DQ**2
      DO 33 I=1,3
      DR(I)=ABS(R(I)-RF(I))
33    IF(DR(I).GT.1D-07)SDR(I)=SDR(I)+DR(I)**2
      IF((NS1-NN-1).EQ.0)GO TO 36
      DO 34 I=1,3
      CALL URN
      IF(M3.GE.5D7)C(I)=C1(I)+SC(I)
      IF(M3.LT.5D7)C(I)=C1(I)-SC(I)
      CALL URN
      IF(M3.GE.5D7)A(I)=A1(I)+SA(I)
34    IF(M3.LT.5D7)A(I)=A1(I)-SA(I)
      DO 35 I=1,6
      CALL URN
      IF(M3.GE.5D7)BT(I,K)=BT1(I,K)+SBT(I,K)
35    IF(M3.LT.5D7)BT(I,K)=BT1(I,K)-SBT(I,K)
      GO TO 23
36    S1=0.
      IF(SDQ.GT.1D-16)S1=UP*DSQRT(SDQ)
      T1=1E4
      DO 37 I=1,3
      S2(I)=0.
      IF(SDR(I).GT.1D-16)S2(I)=UP*DSQRT(SDR(I))
      NT(I)=(RF(I)*T1+.5)
      NST(I)=(S2(I)*T1+.5)
      NU=(BQF/(4*P2)*T1+.5)
37    NSU=(S1/(4*P2)*T1+.5)
      RTO=AMAX1(RF(1),RF(2),RF(3))/AMIN1(RF(1),RF(2),RF(3))
      CHR1=SDOL(1,K)
      CHR2=SDOL(2,K)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,1)=SDOL(1,K)
      LBL(2,1)=CHR2
      LBL(3,1)=SDOL(3,K)
      LBL(4,1)=SDOL(4,K)
      LBL(5,1)=SDOL(5,K)
      LBL(6,1)=SDOL(6,K)
      WRITE(IO,111)(LBL(L,1),L=1,6),(NT(I),NST(I),I=1,3),NU,NSU,
     1 BQF,S1,RTO
111   FORMAT(1X,6A1,4(1X,I4,1H(,I4,1H)),F6.2,1H(,F4.2,1H),F7.2)
      IF(KT.NE.4)GO TO 15
      DO 10 I=4,6
10    BT(I,K)=BT(I,K)/2.
15    CONTINUE
      RETURN
      END
 
      SUBROUTINE MATPR3(A,B,C)
C-----This routine forms the product of two 3x3 matrices
      DIMENSION A(3,3),B(3,3),C(3,3)
      DO 1 I=1,3
      DO 1 J=1,3
      C(I,J)=0.
      DO 1 K=1,3
1     C(I,J)=C(I,J)+A(I,K)*B(K,J)
      RETURN
      END
 
      SUBROUTINE EGNVL3(A,R)
C-----This routine calculates the eigenvalues of a 3x3
C-----positive definite matrix
      DIMENSION A(3,3),R(3),H(3)
      H(1)=-(A(1,1)+A(2,2)+A(3,3))
      H(2)=A(1,1)*(A(2,2)+A(3,3))+A(2,2)*A(3,3)-A(1,2)*A(2,1)
     1 -A(1,3)*A(3,1)-A(2,3)*A(3,2)
      H(3)=A(1,1)*(A(2,3)*A(3,2)-A(2,2)*A(3,3))+A(1,2)*(A(2,1)*A(3,3)-
     1 A(2,3)*A(3,1))+A(1,3)*(A(3,1)*A(2,2)-A(2,1)*A(3,2))
      DO 18 I=1,3
      IF(ABS(H(I)).LT.1.E-6)H(I)=0.0
18    CONTINUE
      Q=(3.*H(2)-H(1)**2)/9.
      S=(9.*H(1)*H(2)-27.*H(3)-2.*H(1)**3)/54.
      B=H(1)/3.
      CSF=-S/SQRT(ABS(-Q**3))
      IF(ABS(CSF).LT.1.E-6) GO TO 1
      IF(ABS(CSF).GT.1.) GO TO 2
      SNF=SQRT(ABS(1.-CSF**2))
      T=ATAN2(SNF,CSF)/3.
      GO TO 3
1     T=0.0
      GO TO 3
2     T=1.5707963
      IF(CSF.LT.0.)T=3.14159265
3     CONTINUE
      P=1.047197551
      U=-2.*SQRT(ABS(-Q))
      R(3)=U* COS(T)-B
      R(1)=U* COS(T+2.*P)-B
      R(2)=U* COS(T+4.*P)-B
      RETURN
      END
 
      SUBROUTINE BONDI(N,NL,KB,KLG,NL2,DM,KOR,NH2,KD,NNB)
C-----This routine calculates bond distances with s.u.'s,
C-----corrected for thermal motion, and the bond matrix
      CHARACTER*1 STR(3),SDOL(6,500),CHR1,CHR2,LBL(6,2)
      CHARACTER*2 NOMAT(103),KS(2),SDL2(500)
      REAL GA(3,3),BA(2,3,3),GS(3),BGS(3),D(3),LB,W(2),BP(6,500)
      DIMENSION RG(2),IRAG(103),DD(3),H(3),S1(3),S2(3)
      COMMON/GRP1/C(3),SC(3),A(3),SA(3)
     1      /GRP3/VO(3,500),SO(3,500)
     2      /GRP4/SDOL
     3      /INS3/CR(3)
     4      /INS4/CS(3),SN(3)
     5      /INS6/G(6)
     6      /INS8/B(6,500),SB(6,500)
     7      /COOR/V(3,500),S(3,500)
      COMMON/NEW/IL(2,700)
     1      /NEW2/IA(3,2000)
     2      /SMBL/NOMAT
     3      /ATRD/IRAG
     4      /INPOU/IN,IO
     5      /GRG1/SDL2
     6      /GRG2/IL1(2,700)
     7      /CRC1/STR
     8      /CRC2/LBL
      DATA P/9.86960440/
      DO 61 I=1,6
      DO 61 J=1,500
61    BP(I,J)=0.
      NL=0
      NH2=0
      NNB=0
      STR(1)=' '
      STR(2)=' '
      STR(3)=' '
      IF(KLG.EQ.0)STR(2)='-'
      IF(KLG.EQ.1)GO TO 57
      GO TO 58
57    DO 59 I=1,3
59    STR(I)='.'
58    IF((KB.EQ.0.AND.KLG.EQ.0).OR.(KD.EQ.0.AND.KLG.NE.0)) GO TO 39
      IF(KLG.EQ.0) WRITE(IO,180)
180   FORMAT(/' Bond distances (Angstrom)')
      IF(KLG.NE.0) WRITE(IO,181)DM
181   FORMAT(//' Interatomic contacts less than ',F4.2,' Angstrom, ',
     1 'involving atoms of'/' the original set.')
      IF(KOR.EQ.0) WRITE(IO,182)
182   FORMAT(27X,'Distance',5X,'s.u.')
      IF(KOR.NE.0) WRITE(IO,183)
183   FORMAT(' (Corrections following Busing & Levy, ',
     1 'Acta Cryst.(1964).17,142)'/
     2 17X,'uncorrected',4X,'lower',4X,'upper',4X,'riding',
     3 2X,'non-correlated'/18X,'distance',6X,'bound',4X,
     4 'bound',4X,'motion',5X,'motion')
39    IF(KOR.EQ.0) GO TO 13
      GO TO (38,14,15,38),KOR
14    DO 16 J=1,N
      DO 17 I=1,3
17    BP(I,J)=B(I,J)*2.*P*CR(I)*CR(I)
      BP(4,J)=B(4,J)*2.*P*CR(2)*CR(3)
      BP(5,J)=B(5,J)*2.*P*CR(1)*CR(3)
16    BP(6,J)=B(6,J)*2.*P*CR(1)*CR(2)
      GO TO 13
15    DO 18 J=1,N
      DO 19 I=1,3
19    BP(I,J)=B(I,J)/4.*CR(I)*CR(I)
      BP(4,J)=B(4,J)/4.*CR(2)*CR(3)
      BP(5,J)=B(5,J)/4.*CR(1)*CR(3)
18    BP(6,J)=B(6,J)/4.*CR(1)*CR(2)
      GO TO 13
38    DO 37 J=1,N
      DO 37 I=1,6
37    BP(I,J)=B(I,J)
13    NM1=N-1
      DO 1 J=1,NM1
      JP1=J+1
      DO 1 K=JP1,N
      KKK=0
      DO 53 L=2,6
      IF(BP(L,J).GT.1E-6)GO TO 54
53    CONTINUE
      KKK=1
      GO TO 56
54    DO 55 L=2,6
      IF(BP(L,K).GT.1E-6)GO TO 56
55    CONTINUE
      KKK=1
56    CONTINUE
      D1=0.0
      DO 2 I=1,3
      D(I)=VO(I,J)-VO(I,K)
      IF(ABS(D(I)).LT.1E-9) D(I)=0.0
2     D1=D1+D(I)*D(I)
      IF(ABS(D1).LT.1E-6)GO TO 1
      D1=SQRT(D1)
      KS(1)=SDL2(J)
      KS(2)=SDL2(K)
      DO 45 JJ=1,2
      DO 46 I=1,103
      IF(KS(JJ).EQ.NOMAT(I)) GO TO 47
46    CONTINUE
      WRITE(IO,'(''WARNING: atom '',A2,'' does not exist'')')KS(JJ)
      RG(JJ)=IRAG(103)
      GO TO 45
47    RG(JJ)=IRAG(I)
45    CONTINUE
      DSTC=(RG(1)+RG(2))/100.
      ICOD=1
      IF(D1.LE.(DSTC-0.5)) ICOD=3
      IF(D1.GE.(DSTC+0.5)) ICOD=2
      IF(KLG.NE.1.OR.D1.GT.3..OR.D1.LT.1.2) GO TO 50
      IF((KS(1).EQ.'H '.AND.KS(2).EQ.'H ').OR.
     1   (KS(1).NE.'H '.AND.KS(2).NE.'H ')) GO TO 50
      IF(KS(1).NE.'H ') KS(2)=KS(1)
      IF(KS(2).NE.'H '.AND.KS(2).NE.'O '.AND.KS(2).NE.'N '.AND.KS(2).
     1 NE.'S '.AND.KS(2).NE.'SE'.AND.KS(2).NE.'F '.AND.KS(2).NE.'CL'.
     2 AND.KS(2).NE.'BR'.AND.KS(2).NE.'I ')GO TO 50
      NH2=NH2+1
      IA(3,NH2)=0
      IF(KS(1).NE.'H ') GO TO 51
      IA(1,NH2)=J
      IA(2,NH2)=K
      GO TO 50
51    IA(2,NH2)=J
      IA(1,NH2)=K
50    IF(KLG.EQ.1)THEN
      IF(D1.GT.DM.OR.KD.EQ.0) GO TO 1
      DO 62 L=1,NL2
      IF((IL1(1,L).EQ.J.AND.IL1(2,L).EQ.K).OR.(IL1(1,L).EQ.K.AND.
     1 IL1(2,L).EQ.J))GO TO 1
62    CONTINUE
      ENDIF
      CHR1=SDOL(1,J)
      CHR2=SDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,1)=SDOL(1,J)
      LBL(2,1)=CHR2
      LBL(3,1)=SDOL(3,J)
      LBL(4,1)=SDOL(4,J)
      LBL(5,1)=SDOL(5,J)
      LBL(6,1)=SDOL(6,J)
      CHR1=SDOL(1,J)
      CHR2=SDOL(2,K)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,2)=SDOL(1,K)
      LBL(2,2)=CHR2
      LBL(3,2)=SDOL(3,K)
      LBL(4,2)=SDOL(4,K)
      LBL(5,2)=SDOL(5,K)
      LBL(6,2)=SDOL(6,K)
      KD1=0
      IF(SDL2(J).EQ.'H '.OR.SDL2(K).EQ.'H ')KD1=1
      IF(KLG.EQ.1) GO TO 6
      GO TO (6,1,40),ICOD
40    IF(KB.NE.0) WRITE(IO,195)((LBL(L,KK),L=1,6),KK=1,2),D1
195   FORMAT(' The distance  ',6A1,'-',6A1,' = ',F6.4,
     1 '  is too short')
6     DO 3 I=1,3
      S1(I)=S(I,J)
      S2(I)=S(I,K)
      D(I)=V(I,K)-V(I,J)
      H(I)=D(I)*SC(I)
3     DD(I)=D(I)*C(I)
      CALL SGMD(DD,H,S1,S2,D1,SD1)
      IF(KB.EQ.0.AND.KLG.EQ.0) GO TO 7
      IF(KOR.EQ.0.OR.KKK.EQ.1) GO TO 8
      DO 9 I=2,6
9     IF(B(I,J).NE.0.) GO TO 10
      KB1=0
      GO TO 34
10    KB1=1
34    DO 11 I=2,6
11    IF(B(I,K).NE.0.) GO TO 12
      KB2=0
      GO TO 35
12    KB2=1
35    IF(KB1.EQ.0)W(1)=BP(1,J)/(P*CR(1)*CR(1))
      IF(KB2.EQ.0)W(2)=BP(1,K)/(P*CR(1)*CR(1))
      IF(KB1.EQ.0.AND.KB2.EQ.0) GO TO 31
      IF(KB1.EQ.1.AND.KB2.EQ.0) KM=1
      IF(KB1.EQ.0.AND.KB2.EQ.1) KM=2
      IF(KB1.EQ.1.AND.KB2.EQ.1) KM=3
      DO 20 I=1,3
20    GA(I,I)=G(I)
      GA(1,2)=G(6)
      GA(1,3)=G(5)
      GA(2,3)=G(4)
      DO 21 I=1,2
      DO 21 JJ=1,3
21    GA(JJ,I)=GA(I,JJ)
      DO 22 I=1,3
      GS(I)=0.
      DO 22 JJ=1,3
22    GS(I)=GS(I)+GA(I,JJ)*D(JJ)
      SGS=0.
      DO 23 I=1,3
      SGS=SGS+D(I)*GS(I)
      BA(1,I,I)=BP(I,J)
23    BA(2,I,I)=BP(I,K)
      BA(1,2,1)=BP(6,J)
      BA(2,2,1)=BP(6,K)
      BA(1,3,1)=BP(5,J)
      BA(2,3,1)=BP(5,K)
      BA(1,3,2)=BP(4,J)
      BA(2,3,2)=BP(4,K)
      DO 25 L=1,2
      DO 25 I=1,2
      DO 25 JJ=1,3
25    BA(L,I,JJ)=BA(L,JJ,I)
      IF(KM.EQ.1.OR.KM.EQ.3) M=1
      IF(KM.EQ.2) M=2
33    DO 26 I=1,3
      BGS(I)=0.0
      DO 26 JJ=1,3
26    BGS(I)=BGS(I)+BA(M,I,JJ)*GS(JJ)
      GSBGS=0.0
      TR=0.0
      DO 27 I=1,3
      GSBGS=GSBGS+GS(I)*BGS(I)
27    TR=TR+GA(I,I)*BA(M,I,I)
      TR=TR+2.*(GA(1,2)*BA(M,1,2)+GA(1,3)*BA(M,1,3)+
     1 GA(2,3)*BA(M,2,3))
 
      IF(SGS.LT.1E-6)THEN
      WRITE(IO,'(''WARNING: There is something wrong with the input'',
     1 '' data'')')
      SGS=1.0
      ENDIF
 
      WP=ABS((TR-GSBGS/SGS)/(2.*P))
      GO TO (28,29,30),KM
28    W(1)=WP
      GO TO 31
29    W(2)=WP
      GO TO 31
30    IF(M.EQ.1) GO TO 32
      W(2)=WP
      GO TO 31
32    W(1)=WP
      M=2
      GO TO 33
31    WL=SQRT(W(2))-SQRT(W(1))
      WU=SQRT(W(2))+SQRT(W(1))
      LB=D1+(WL*WL)/(2.*D1)
      UB=D1+(WU*WU)/(2.*D1)
      RM=D1+ABS(W(2)-W(1))/(2.*D1)
      UNC=D1+(W(2)+W(1))/(2.*D1)
8     ND1=((SD1+5E-5)*1E4)
      K1=KB
      IF(KLG.EQ.1)K1=KD
      CALL WRTDST(K1,KD1,KOR,KKK,D1,ND1,LB,UB,RM,UNC,NNB)
7     NL=NL+1
      IF(KLG.EQ.1) GO TO 1
      IF(NL.GT.700) GO TO 4
      IL(1,NL)=J
      IL(2,NL)=K
      IL1(1,NL)=J
      IL1(2,NL)=K
1     CONTINUE
      GO TO 5
4     IF(KLG.EQ.1)WRITE(IO,191)NL
191   FORMAT(/' There are too many contacts (',I3,').'/
     1 ' Please, reduce the number of the atoms'/)
      NL=NL-1
5     RETURN
      END
 
      SUBROUTINE WRTDST(K1,KD1,KOR,KKK,D1,ND1,LB,UB,RM,UNC,NNB)
C-----Print bond or contact distances
      CHARACTER*1 STR(3),LBL(6,2)
      REAL LB
      COMMON/INPOU/IN,IO
     1      /CRC1/STR
     2      /CRC2/LBL
      IF(K1.EQ.0) RETURN
      IF(K1.GT.0.OR.(K1.LT.0.AND.KD1.EQ.0))THEN
      IF(KOR.EQ.0.OR.KKK.EQ.1)THEN
      WRITE(IO,100)(LBL(L,1),L=1,6),STR,(LBL(L,2),L=1,6),D1,ND1
100   FORMAT(1X,6A1,3A1,6A1,1X,F6.4,'(',I4,')')
      ELSE
      WRITE(IO,101)(LBL(L,1),L=1,6),STR,(LBL(L,2),L=1,6),D1,ND1,
     1 LB,UB,RM,UNC
101   FORMAT(1X,6A1,3A1,6A1,1X,F6.4,'(',I4,')',3(3X,F6.4),5X,F6.4)
      ENDIF
      ELSE
      NNB=NNB+1
      ENDIF
      RETURN
      END
 
      SUBROUTINE TERNE(NL,NA)
C-----This routine deduces from bond matrix, (IL(2,NL)), the IA(3,NA)
C-----matrix formed by the order numbers of the atoms defining bond
C-----angles (NA = number of angles)
      DIMENSION IL(2,700),IA(3,2000)
      DIMENSION P(3),VO(3,500),SO(3,500)
      COMMON/NEW/IL
     1      /NEW2/IA
     2      /INPOU/IN,IO
     3      /GRP3/VO,SO
      NA=1
      NLM1=NL-1
      KK=1
1     DO 2 J=1,NLM1
      JP1=J+1
      DO 2 K=JP1,NL
      GO TO(3,4,5,6),KK
3     IF(IL(1,J).NE.IL(1,K))GO TO 2
      IA(1,NA)=IL(2,J)
      IA(2,NA)=IL(1,J)
      IA(3,NA)=IL(2,K)
      GO TO 7
4     IF(IL(1,J).NE.IL(2,K))GO TO 2
      IA(1,NA)=IL(2,J)
      IA(2,NA)=IL(1,J)
      IA(3,NA)=IL(1,K)
      GO TO 7
5     IF(IL(2,J).NE.IL(1,K))GO TO 2
      IA(1,NA)=IL(1,J)
      IA(2,NA)=IL(2,J)
      IA(3,NA)=IL(2,K)
      GO TO 7
6     IF(IL(2,J).NE.IL(2,K))GO TO 2
      IA(1,NA)=IL(1,J)
      IA(2,NA)=IL(2,J)
      IA(3,NA)=IL(1,K)
7     NA=NA+1
      IF(NA.GT.2000)GO TO 8
2     CONTINUE
      IF(KK.EQ.4)GO TO 9
      KK=KK+1
      GO TO 1
8     WRITE(IO,100)NA
100   FORMAT(/' There are too many angles (',I3,').'/
     1 ' Please, reduce the number of the atoms'/)
9     NA=NA-1
      DO 10 L=1,10
      DO 10 I=1,NA-1
      DO 10 J=I+1,NA
      IF(IA(2,I).LT.IA(2,J))GO TO 10
      IF(IA(2,I).EQ.IA(2,J).AND.IA(1,I).LT.IA(1,J))GO TO 10
      IF(IA(2,I).EQ.IA(2,J).AND.IA(1,I).EQ.IA(1,J).AND.
     1 IA(3,I).LT.IA(3,J))GO TO 10
      DO 11 K=1,3
      P(K)=IA(K,I)
11    IA(K,I)=IA(K,J)
      DO 12 KK=1,3
12    IA(KK,J)=P(KK)
10    CONTINUE
C-----Eliminate zero angles
      DO 15 I=1,NA
      DO 13 K=1,3
13    DD=0.0
      DO 14 K=1,3
14    DD=DD+(VO(K,IA(1,I))-VO(K,IA(3,I)))**2
      DD=SQRT(DD)
      IF(DD.LT.1E-6)THEN
      IA(1,I)=0
      IA(3,I)=0
      ENDIF
15    CONTINUE
16    CONTINUE
      DO 18 I=1,NA
      IF(IA(1,I).EQ.0.AND.IA(3,I).EQ.0)THEN
      DO 17 J=I,NA-1
      DO 17 K=1,3
17    IA(K,J)=IA(K,J+1)
      NA=NA-1
      GO TO 19
      ENDIF
18    CONTINUE
      GO TO 20
19    GO TO 16
20    RETURN
      END
 
      SUBROUTINE BNDAN(RD,X,SX,THT,STHT)
C-----This routine calculates a bond angle and its s.u., using the
C-----Cruickshank's formula (Intern. Tab. X-Ray Cryst., Vol.II,
C-----1959, p.331).
      DIMENSION X(3,3),SX(3,3),D(3,3),DT(3),P(3,3),S2(3),XR(3)
      DIMENSION SM(3)
      COMMON/INPOU/IN,IO
      DO 1 I=1,3
      D(1,I)=X(1,I)-X(2,I)
      D(2,I)=X(3,I)-X(2,I)
1     D(3,I)=X(3,I)-X(1,I)
      DO 3 I=1,3
      DT(I)=0.
      DO 2 J=1,3
2     DT(I)=DT(I)+D(I,J)**2
3     DT(I)=SQRT(DT(I))
      DO 4 I=1,3
 
      IF(DT(I).LT.1E-6)THEN
      WRITE(IO,'(''WARNING: There is something wrong with the '',
     1 ''input data'')')
      DT(I)=1.0
      ENDIF
 
      DO 4 J=1,3
4     D(I,J)=D(I,J)/DT(I)
      CST=0.
      DO 5 K=1,3
5     CST=CST+(D(1,K)*D(2,K))
      IF(ABS(CST).GT.1.) THEN
      RS=1.0
      CST=SIGN(RS,CST)
      ENDIF
      SNT=SQRT(ABS(1.-CST*CST))
      THT=RD*ATAN2(SNT,CST)
      IF(ABS(SNT).LT.1E-7)GO TO 16
      DO 6 I=1,3
      P(1,I)=-(D(1,I)*CST+D(2,I))/SNT
6     P(3,I)=(D(2,I)*CST+D(1,I))/SNT
      DO 11 I=1,3
11    P(2,I)=-(DT(1)*P(3,I)+DT(2)*P(1,I))/DT(3)
      DO 7 I=1,3
7     XR(I)=P(1,I)
      CALL NORM(XR)
      DO 8 I=1,3
8     P(1,I)=XR(I)
      DO 9 I=1,3
9     XR(I)=P(3,I)
      CALL NORM(XR)
      DO 10 I=1,3
10    P(3,I)=XR(I)
      DO 12 I=1,3
12    XR(I)=P(2,I)
      CALL NORM(XR)
      DO 13 I=1,3
13    P(2,I)=XR(I)
      DO 15 I=1,3
      S2(I)=0.
      DO 14 J=1,3
      IF(ABS(SX(I,J)).LT.1E-7)GO TO 16
14    S2(I)=S2(I)+(P(I,J)/SX(I,J))**2
      IF(ABS(S2(I)).LT.1E-7)GO TO 16
15    S2(I)=1./S2(I)
      STHT=S2(1)/DT(1)**2+(1./DT(1)**2+1./DT(2)**2-
     1 2.*CST/(DT(1)*DT(2)))*S2(2)+S2(3)/DT(2)**2
      GO TO 18
16    DO 17 I=1,3
17    SM(I)=SQRT((SX(I,1)**2+SX(I,2)**2+SX(I,3)**2)/3.)
C     STHT=(SM(1)**2+SM(2)**2)/(DT(1)**2)+(SM(2)**2+SM(3)**2)/
C    1 (DT(2)**2)-(2.0*SM(2)**2*CST)/(DT(1)*DT(2))
      STHT=(SM(1)/DT(1))**2+(SM(3)/DT(2))**2+SM(2)**2*(1./DT(1)**2+
     1 1./DT(2)**2-2.*CST/(DT(1)*DT(2)))
18    STHT=RD*SQRT(ABS(STHT))
      RETURN
      END
 
      SUBROUTINE QUART(NL,NA,NT)
C-----From the bond matrix (IL(2,NL)) and the angle matrix (IA(3,NA)),
C-----this routine deduces the IT(4,NT) mmatrix formed by the order
C-----numbers of the atoms defining the torsion angles
C-----(NT= number of torsion angles)
      DIMENSION IL(2,700),IA(3,2000),IT(4,3000),P(4)
      COMMON/NEW/IL
     1      /NEW2/IA
     2      /NEW3/IT
     3      /INPOU/IN,IO
      NT=0
      DO 1 I=1,NA
      DO 1 J=1,NL
      IF(IA(2,I).EQ.IL(1,J).OR.IA(2,I).EQ.IL(2,J))GO TO 1
      IF(IA(1,I).NE.IL(1,J).OR.IA(3,I).EQ.IL(2,J))GO TO 1
      IF(NT.EQ.0)GO TO 2
      DO 3 K=1,NT
      IF(IA(3,I).EQ.IT(4,K).AND.IA(2,I).EQ.IT(3,K).AND.IA(1,I).EQ.
     1 IT(2,K).AND.IL(2,J).EQ.IT(1,K))GO TO 1
3     CONTINUE
2     NT=NT+1
      IF(NT.GT.3000)GO TO 13
      IT(1,NT)=IA(3,I)
      IT(2,NT)=IA(2,I)
      IT(3,NT)=IA(1,I)
      IT(4,NT)=IL(2,J)
1     CONTINUE
      DO 4 I=1,NA
      DO 4 J=1,NL
      IF(IA(2,I).EQ.IL(1,J).OR.IA(2,I).EQ.IL(2,J))GO TO 4
      IF(IA(1,I).NE.IL(2,J).OR.IA(3,I).EQ.IL(1,J))GO TO 4
      IF(NT.EQ.0)GO TO 5
      DO 6 K=1,NT
      IF(IA(3,I).EQ.IT(4,K).AND.IA(2,I).EQ.IT(3,K).AND.IA(1,I).EQ.
     1 IT(2,K).AND.IL(1,J).EQ.IT(1,K))GO TO 4
6     CONTINUE
5     NT=NT+1
      IF(NT.GT.3000)GO TO 13
      IT(1,NT)=IA(3,I)
      IT(2,NT)=IA(2,I)
      IT(3,NT)=IA(1,I)
      IT(4,NT)=IL(1,J)
4     CONTINUE
      DO 7 I=1,NA
      DO 7 J=1,NL
      IF(IA(2,I).EQ.IL(1,J).OR.IA(2,I).EQ.IL(2,J))GO TO 7
      IF(IA(3,I).NE.IL(1,J).OR.IA(1,I).EQ.IL(2,J))GO TO 7
      IF(NT.EQ.0)GO TO 8
      DO 9 K=1,NT
      IF(IA(1,I).EQ.IT(4,K).AND.IA(2,I).EQ.IT(3,K).AND.IA(3,I).EQ.
     1 IT(2,K).AND.IL(2,J).EQ.IT(1,K))GO TO 7
9     CONTINUE
8     NT=NT+1
      IF(NT.GT.3000)GO TO 13
      IT(1,NT)=IA(1,I)
      IT(2,NT)=IA(2,I)
      IT(3,NT)=IA(3,I)
      IT(4,NT)=IL(2,J)
7     CONTINUE
      DO 10 I=1,NA
      DO 10 J=1,NL
      IF(IA(2,I).EQ.IL(1,J).OR.IA(2,I).EQ.IL(2,J))GO TO 10
      IF(IA(3,I).NE.IL(2,J).OR.IA(1,I).EQ.IL(1,J))GO TO 10
      IF(NT.EQ.0)GO TO 11
      DO 12 K=1,NT
      IF(IA(1,I).EQ.IT(4,K).AND.IA(2,I).EQ.IT(3,K).AND.IA(3,I).EQ.
     1 IT(2,K).AND.IL(1,J).EQ.IT(1,K))GO TO 10
12    CONTINUE
11    NT=NT+1
      IF(NT.GT.3000)GO TO 13
      IT(1,NT)=IA(1,I)
      IT(2,NT)=IA(2,I)
      IT(3,NT)=IA(3,I)
      IT(4,NT)=IL(1,J)
10    CONTINUE
      DO 15 I=1,NT
      IF(IT(2,I).LT.IT(3,I))GO TO 15
      DO 16 K=1,4
16    P(K)=IT(K,I)
      DO 19 KK=1,4
      IT(5-KK,I)=P(KK)
19    CONTINUE
15    CONTINUE
      DO 17 L=1,10
      DO 17 I=1,NT-1
      DO 17 J=I+1,NT
      IF(IT(2,I).LT.IT(2,J))GO TO 17
      IF(IT(2,I).EQ.IT(2,J).AND.IT(3,I).LT.IT(3,J))GO TO 17
      IF(IT(2,I).EQ.IT(2,J).AND.IT(3,I).EQ.IT(3,J).AND.
     1 IT(1,I).LT.IT(1,J))GO TO 17
      IF(IT(2,I).EQ.IT(2,J).AND.IT(3,I).EQ.IT(3,J).AND.
     1 IT(1,I).EQ.IT(1,J).AND.IT(4,I).LT.IT(4,J))GO TO 17
      DO 18 KL=1,4
      P(KL)=IT(KL,I)
18    IT(KL,I)=IT(KL,J)
      DO 20 KL=1,4
      IT(KL,J)=P(KL)
20    CONTINUE
17    CONTINUE
      GO TO 14
13    WRITE(IO,193)NT
193   FORMAT(/' There are too many torsion angles (',I3,').'/
     1 ' Please, reduce the number of the atoms'/)
      NT=2000
14    RETURN
      END
 
      SUBROUTINE TORS2(SD,TAU,SIGTAU,KTR)
C-----This routine calculates the torsion angle formed by the atoms
C-----1-2-3-4.The angle is positive when the 1-2 bond, view down the
C-----2-3 bond, will eclipse the 3-4 bond when rotates less than 180
C-----deg in a clockwise direction ("right-hand rule",Klyne,W.&
C-----Prelog,V. (1960), Experientia, 16, 521).
C-----S.u. following Stanford & Waser (1972). Acta Cryst.A28,213.
      REAL M(3,3)
      DIMENSION R(4,3),DLT(3,3),DST(3),SD(4,3),DS(4)
      COMMON/GRP6/R,DST
      KTR=0
      DO 1 J=1,3
      DLT(1,J)=R(2,J)-R(1,J)
      DLT(2,J)=R(2,J)-R(3,J)
      DLT(3,J)=R(4,J)-R(3,J)
    1 CONTINUE
      DO 2 I=1,3
      DST(I)=SQRT(DLT(I,1)**2+DLT(I,2)**2+DLT(I,3)**2)
      IF(DST(I).EQ.0.) GO TO 4
   2  CONTINUE
      DO 3 I=1,3
      DO 3 J=1,3
      M(I,J)=DLT(I,J)/DST(I)
   3  CONTINUE
      CF1=M(1,1)*M(2,1)+M(1,2)*M(2,2)+M(1,3)*M(2,3)
      CF2=M(2,1)*M(3,1)+M(2,2)*M(3,2)+M(2,3)*M(3,3)
      IF(ABS(CF1).GT..999990.OR.ABS(CF2).GT..999990)GO TO 4
      SF1=SQRT(1.-CF1**2)
      SF2=SQRT(1.-CF2**2)
      P=SF1*SF2
      IF(ABS(P).LT.1.E-5)GO TO 4
      STAU=(M(3,1)*(M(2,2)*M(1,3)-M(1,2)*M(2,3))
     1 +M(3,2)*(M(1,1)*M(2,3)-M(1,3)*M(2,1))
     2 +M(3,3)*(M(2,1)*M(1,2)-M(1,1)*M(2,2)))/P
      CTAU=((M(2,2)*M(1,3)-M(1,2)*M(2,3))*( M(3,2)*M(2,3)-M(2,2)*M(3,3)
     1 )+(M(2,3)*M(1,1)-M(2,1)*M(1,3))*(M(3,3)*M(2,1)-M(3,1)*M(2,3))
     2 +(M(2,1)*M(1,2)-M(1,1)*M(2,2))*(M(3,1)*M(2,2)-M(2,1)*M(3,2)))/P
      RR=57.295779
      TAU1=ATAN2(STAU,CTAU)
      TAU=RR*TAU1
      IF(TAU.GT.180.)TAU=TAU-360.
      DO 6 I=1,4
      DS(I)=(SD(I,1)**2+SD(I,2)**2+SD(I,3)**2)/3.
6     DS(I)=SQRT(DS(I))
      S1=(DS(1)/(DST(1)*SF1))**2
      A1=(DST(2)-DST(1)*CF1)/(DST(1)*SF1)
      A2=(DST(2)-DST(3)*CF2)/(DST(3)*SF2)
      S2=(DS(2)/DST(2))**2*(A1**2-2.*A1*(CF2/SF2)*CTAU+(CF2/SF2)**2)
      S3=(DS(3)/DST(2))**2*(A2**2-2.*A2*(CF1/SF1)*CTAU+(CF1/SF1)**2)
      S4=(DS(4)/(DST(3)*SF2))**2
      IF((S1+S2+S3+S4).LT.0.) GO TO 4
      SIGTAU=RR*SQRT(S1+S2+S3+S4)
      GO TO 5
   4  KTR=1
   5  RETURN
      END
 
      SUBROUTINE HB1(NL,NH)
C-----This routine choses all the bonds involving the hydrogen
C-----atom in the bonds matrix
      CHARACTER*1 SDOL(6,500)
      CHARACTER*2 SDL2(500)
      COMMON/GRP4/SDOL
     1      /NEW/IL(2,700)
     2      /GRG1/SDL2
      DO 2 L=1,NL
      IF(SDL2(IL(2,L)).EQ.'H ')GO TO 2
      IF(SDL2(IL(1,L)).EQ.'H ')GO TO 1
      IL(1,L)=0
      IL(2,L)=0
      GO TO 2
1     IRS=IL(1,L)
      IL(1,L)=IL(2,L)
      IL(2,L)=IRS
2     CONTINUE
      NL1=NL-1
      DO 4 L=1,NL1
      LP1=L+1
      DO 4 J=LP1,NL
      IF(IL(1,L).NE.0)GO TO 4
      IF(IL(1,J).EQ.0)GO TO 4
      DO 3 K=1,2
      IRS=IL(K,L)
      IL(K,L)=IL(K,J)
3     IL(K,J)=IRS
4     CONTINUE
      NH=0
      DO 5 L=1,NL
5     IF(IL(1,L).NE.0)NH=NH+1
      RETURN
      END
 
      BLOCK DATA
      CHARACTER*1 MINU(26),MAIU(26)
      CHARACTER*2 NOMAT(103)
      DOUBLE PRECISION M1,M2,M3,M4,UP,CP
      DIMENSION PA(94),AS1(94),AS2(94),IRAG(103)
      COMMON/INS1/M1,M2,M3,M4
     1      /LBL2/CP,UP,NN
     2      /LBL3/CHI2(100)
     3      /SMBL/NOMAT
     4      /ATRD/IRAG
     5      /ATWG/PA
     6      /ASSB/AS1,AS2
     7      /MIMA/MINU,MAIU
      DATA M1,M2,M3/32007779D0,23717810D0,52636370D0/
      DATA CP,NN/1D-03,200/
      DATA MINU/'a','b','c','d','e','f','g','h','i','j','k','l','m',
     1 'n','o','p','q','r','s','t','u','v','w','x','y','z'/
      DATA MAIU/'A','B','C','D','E','F','G','H','I','J','K','L','M',
     1 'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'/
      DATA NOMAT/'H ','HE','LI','BE','B ','C ','N ','O ','F ','NE',
     1 'NA','MG','AL','SI','P ','S ','CL','AR','K ','CA','SC',
     2 'TI','V ','CR','MN','FE','CO','NI','CU','ZN','GA','GE',
     3 'AS','SE','BR','KR','RB','SR','Y ','ZR','NB','MO','TC',
     4 'RU','RH','PD','AG','CD','IN','SN','SB','TE','I ','XE',
     5 'CS','BA','LA','CE','PR','ND','PM','SM','EU','GD','TB',
     6 'DY','HO','ER','TM','YB','LU','HF','TA','W ','RE','OS',
     7 'IR','PT','AU','HG','TL','PB','BI','PO','AT','RN','FR',
     8 'RA','AC','TH','PA','U ','NP','PU','AM','CM','BK','CF',
     9 'ES','FM','MD','NO','LW'/
      DATA PA/1.0079,4.0026,6.941,9.01218,10.81,12.011,14.0067,
     1 15.9994,18.9984,20.179,22.98977,24.305,26.98154,28.086,
     2 30.97376,32.06,35.453,39.948,39.098,40.08,44.9559,47.9,
     3 50.9415,51.996,54.938,55.847,58.9332,58.71,63.546,65.38,
     4 69.72,72.59,74.9216,78.96,79.904,83.8,85.4678,87.62,
     5 88.9059,91.22,92.9064,95.94,98.9062,101.07,102.9055,
     6 106.4,107.868,112.4,114.82,118.69,121.75,127.6,126.9045,
     7 131.3,132.9044,137.34,138.9055,140.12,140.9077,144.24,
     8 147.,150.4,151.96,157.25,158.9254,162.5,164.9304,167.26,
     9 168.9342,173.04,174.97,178.49,180.9479,183.85,186.2,190.2,
     1 192.22,195.09,196.9665,200.59,204.37,207.2,208.9804,210.,
     2 210.,222.,223.,226.0254,227.,232.0381,231.0359,238.029,
     3 237.0482,242./
      DATA AS1/.655,1.94,5.76,16.6,41.5,89.9,173.,304.,
     1 498.,768.,1140.,1610.,2220.,2970.,3880.,4970.,6240.,
     2 7720.,9400.,11300.,13500.,15900.,18500.,21300.,24600.,
     3 28000.,31400.,4760.,5470.,6290.,7190.,8190.,9290.,10500.,
     4 11800.,13200.,14800.,16500.,18300.,20300.,22300.,24600.,
     5 27000.,29500.,32300.,35200.,38200.,41500.,45000.,48600.,
     6 52500.,56500.,60700.,65200.,70000.,75000.,80300.,85700.,
     7 91200.,96800.,102000.,108000.,110000.,105000.,84700.,
     8 97700.,34700.,36700.,39300.,41000.,45000.,46000.,48500.,
     9 51300.,57200.,58000.,62400.,63400.,66900.,66800.,75400.,
     1 79800.,84300.,88100.,86500.,97200.,102000.,102000.,
     2 143000.,118000.,106000.,112000.,123000.,113000./
      DATA AS2/.624,1.34,2.28,3.83,6.61,11.5,19.6,32.5,
     1 51.5,78.6,116.,165.,229.,310.,410.,532.,678.,
     2 851.,1050.,1290.,1560.,1860.,2200.,2580.,3020.,3490.,4010.,
     3 4570.,5180.,5860.,6600.,7380.,8220.,9110.,10000.,11000.,
     4 12100.,13200.,14300.,2470.,2730.,3000.,3320.,3640.,3990.,
     5 4360.,4760.,5180.,5630.,6110.,6620.,7160.,7730.,8340.,
     6 8980.,9650.,10400.,11100.,11900.,12700.,13500.,14400.,
     7 15400.,16300.,17400.,18400.,19500.,20700.,21900.,23100.,
     8 24400.,25800.,27200.,28600.,30100.,31600.,33100.,34800.,
     9 36500.,38200.,40100.,41900.,43800.,45800.,40700.,39800.,
     1 32200.,33000.,54000.,37000.,38700.,40300.,25700.,16200./
      DATA IRAG/37,93,134,90,82,77,75,73,72,131,154,130,118,
     1 111,106,102,99,174,196,174,144,136,117,128,122,130,126,
     2 140,138,131,126,122,119,116,114,189,211,192,162,148,
     3 139,133,135,140,145,148,153,148,144,141,138,135,133,
     4 209,225,198,169,165,165,164,165,166,185,161,159,159,
     5 158,157,156,170,156,157,143,137,128,126,132,150,150,
     6 149,148,147,146,168,150,214,230,204,188,165,150,142,
     7 165,166,185,161,160,160,160,160,160,160,160/
       DATA CHI2/3.84,5.99,7.81,9.49,11.1,12.6,14.1,15.5,16.9
     1 ,18.3,19.7,21.0,22.4,23.7,25.0,26.3,27.6,28.9,30.1,31.4,
     2 32.7,33.9,35.2,36.4,37.7,38.9,40.1,41.3,42.6,43.8,45.0,
     3 46.2,47.4,48.6,49.8,51.0,52.2,53.4,54.6,55.8,57.0,58.2,
     4 59.3,60.5,61.7,62.8,64.0,65.2,66.3,67.5,68.7,69.8,71.0,
     5 72.1,73.3,74.5,75.6,76.8,77.9,79.1,80.2,81.4,82.5,83.7,
     6 84.8,85.9,87.0,88.2,89.4,90.5,91.6,92.8,93.9,95.1,96.2,
     7 97.3,98.5,99.6,100.8,101.9,103.0,104.1,105.3,106.4,107.5,
     8 108.6,109.7,110.9,112.0,113.1,114.2,115.3,116.5,117.6,
     9 118.7,119.8,120.9,122.1,123.2,124.3/
      END
 
      SUBROUTINE LSQPLA(NP,NL,N,IERR)
C-----This routine calculates the weighted least-squares plane
C-----through a group of  atoms with s.u.'s
      CHARACTER*1 STR(4),PDOL(6,40),FPDOL(6,40),SDOL(6,500),CHR1,
     1 CHR2,LBL(6)
      DOUBLE PRECISION A(6),W2(40),C(10),RA(6),DET,M1,M2,M3,M4,
     1 SDM(3),DR(3),DD,SDD,AM(3),SAM(3),PPM(3),DA,DB,DG,DL,
     2 SW2,SW2M,PV(40,3),PSV(40,3),QV(40,3),XM(3),PM(3),PAMU,
     3 D1,DF,CP,UP,DY,DEP
      DIMENSION FPV(40,3),FPSV(40,3)
      COMMON/INS1/M1,M2,M3,M4
     1      /GRP3/V(3,500),S(3,500)
     2      /GRP7/FPDOL
     3      /GRN1/PDOL
     4      /GRN2/NFP
     5      /LBL2/CP,UP,NN
     6      /LBL3/CHI2(100)
     7      /GRP4/SDOL
     8      /GRP8/PV,PSV,AM,SAM
     9      /INPOU/IN,IO
      IERR=0
      DO 41 I=1,NP
      DO 41 J=1,3
41    QV(I,J)=PV(I,J)
      NS1=0
      DO 42 I=1,3
42    SDM(I)=0D0
      SDD=0D0
43    CONTINUE
      IF (NP.EQ.3) GO TO 4
      DO 1 J=1,3
   1  XM(J)=0.
      DO 2 J=1,3
      DO 3 I=1,NP
      IF(DABS(PV(I,J)).LT.1.D-6) PV(I,J)=0D0
   3  XM(J)=XM(J)+PV(I,J)
   2  XM(J)=XM(J)/NP
      DO 5 I=1,6
   5  A(I)=0D0
      DO 6 I=1,NP
      A(1)=A(1)+(PV(I,1)-XM(1))**2
      A(2)=A(2)+(PV(I,1)-XM(1))*(PV(I,2)-XM(2))
      A(3)=A(3)+(PV(I,1)-XM(1))*(PV(I,3)-XM(3))
      A(4)=A(4)+(PV(I,2)-XM(2))**2
      A(5)=A(5)+(PV(I,2)-XM(2))*(PV(I,3)-XM(3))
      A(6)=A(6)+(PV(I,3)-XM(3))**2
   6  CONTINUE
      IF(A(1).EQ.0D0.AND.A(2).EQ.0D0.AND.A(3).EQ.0D0) GO TO 28
      IF(A(2).EQ.0D0.AND.A(4).EQ.0D0.AND.A(5).EQ.0D0) GO TO 29
      IF(A(3).EQ.0D0.AND.A(5).EQ.0D0.AND.A(6).EQ.0D0) GO TO 30
      DA=A(1)+A(4)+A(6)
      DB=-(A(1)*A(4)+A(1)*A(6)+A(4)*A(6))+A(2)**2+A(3)**2+A(5)**2
      DG=A(1)*A(4)*A(6)+2.*(A(2)*A(3)*A(5))-(A(1)*A(5)**2+A(4)*
     1 A(3)**2+A(6)*A(2)**2)
      IF(DABS(DG).LT.1.D-6) GO TO 39
      DEP=DB**2-4.*DA*DG
      IF(DEP.LT.0D0)THEN
      IERR=1
      RETURN
      ENDIF
      DL=(-DB-DSQRT(DEP))/(2.*DA)
      IF(DABS(DL).LT.1.D-6) GO TO 13
   7  DY=DL**3+DA*DL**2+DB*DL+DG
      DL=DL-DY/(3.*DL**2+2.*DA*DL+DB)
      IF(DABS(DY).GT.1D-6) GO TO 7
      GO TO 13
  39  DL=0D0
  13  PM(1)=A(3)*(A(4)-DL)-A(2)*A(5)
      PM(2)=A(5)*(A(1)-DL)-A(2)*A(3)
      PM(3)=A(2)**2-(A(1)-DL)*(A(4)-DL)
      GO TO 40
  28  PM(1)=1.0
      PM(2)=0.0
      PM(3)=0.0
      GO TO 40
  29  PM(1)=0.0
      PM(2)=1.0
      PM(3)=0.0
      GO TO 40
  30  PM(1)=0.0
      PM(2)=0.0
      PM(3)=1.0
  40  PAMU=DSQRT(PM(1)**2+PM(2)**2+PM(3)**2)
      DO 8 I=1,3
   8  PM(I)=PM(I)/PAMU
  20  DO 9 I=1,NP
   9  W2(I)=1./((PM(1)*PSV(I,1))**2+(PM(2)*PSV(I,2))**2+(PM(3)*
     1PSV(I,3))**2)
      SW2=0.0
      DO 26 I=1,NP
  26  SW2=SW2+W2(I)
      SW2M=SW2/NP
      DO 27 I=1,NP
  27  W2(I)=W2(I)/SW2M
      DO 10 I=1,10
  10  C(I)=0.0
      DO 11 I=1,NP
      C(1)=C(1)+PV(I,1)**2*W2(I)
      C(2)=C(2)+PV(I,1)*PV(I,2)*W2(I)
      C(3)=C(3)+PV(I,1)*PV(I,3)*W2(I)
      C(4)=C(4)-PV(I,1)*W2(I)
      C(5)=C(5)+PV(I,2)**2*W2(I)
      C(6)=C(6)+PV(I,2)*PV(I,3)*W2(I)
      C(7)=C(7)-PV(I,2)*W2(I)
      C(8)=C(8)+PV(I,3)**2*W2(I)
      C(9)=C(9)-PV(I,3)*W2(I)
  11  C(10)=C(10)+W2(I)
      A(1)=C(1)-(C(4)**2)/C(10)
      A(2)=C(2)-(C(4)*C(7))/C(10)
      A(3)=C(3)-(C(4)*C(9))/C(10)
      A(4)=C(5)-(C(7)**2)/C(10)
      A(5)=C(6)-(C(7)*C(9))/C(10)
      A(6)=C(8)-(C(9)**2)/C(10)
      DET=A(1)*A(4)*A(6)+2.*A(2)*A(3)*A(5)-A(1)*A(5)*A(5)-A(4)*A(3)*
     1 A(3)-A(6)*A(2)*A(2)
      IF(DABS(DET).GT.1D-9) GO TO 22
      D1=0.0
      DO 23 I=1,3
      D1=D1+PM(I)*XM(I)
  23  PPM(I)=PM(I)
      GO TO 21
  22  RA(1)=(A(4)*A(6)-A(5)**2)/DET
      RA(2)=(-A(2)*A(6)+A(3)*A(5))/DET
      RA(3)=(A(2)*A(5)-A(3)*A(4))/DET
      RA(4)=(A(1)*A(6)-A(3)**2)/DET
      RA(5)=(-A(1)*A(5)+A(2)*A(3))/DET
      RA(6)=(A(1)*A(4)-A(2)**2)/DET
      PPM(1)=RA(1)*PM(1)+RA(2)*PM(2)+RA(3)*PM(3)
      PPM(2)=RA(2)*PM(1)+RA(4)*PM(2)+RA(5)*PM(3)
      PPM(3)=RA(3)*PM(1)+RA(5)*PM(2)+RA(6)*PM(3)
      PAMU=(PPM(1)**2+PPM(2)**2+PPM(3)**2)
      PAMU=DSQRT(PAMU)
      DO 12 I=1,3
12    PPM(I)=PPM(I)/PAMU
      IF(DABS(DABS(PPM(1))-DABS(PM(1))).LT.1D-5.AND.DABS(DABS(PPM(2))
     1 -DABS(PM(2))).LT.1D-5.AND.DABS(DABS(PPM(3))-DABS(PM(3))).
     2 LT.1D-5) GO TO 18
      DO 24 I=1,3
24    PM(I)=PPM(I)
      GO TO 20
18    DO 15 I=1,3
15    XM(I)=0D0
      DO 16 I=1,3
      DO 16 J=1,NP
16    XM(I)=XM(I)+(W2(J)*PV(J,I))/C(10)
      D1=0.0
      DO 17 I=1,3
17    D1=D1+PPM(I)*XM(I)
      GO TO 21
4     PPM(1)=PV(1,2)*(PV(2,3)-PV(3,3))+PV(2,2)*(PV(3,3)-PV(1,3))+
     1       PV(3,2)*(PV(1,3)-PV(2,3))
      PPM(2)=PV(1,3)*(PV(2,1)-PV(3,1))+PV(2,3)*(PV(3,1)-PV(1,1))+
     1        PV(3,3)*(PV(1,1)-PV(2,1))
      PPM(3)=PV(1,1)*(PV(2,2)-PV(3,2))+PV(2,1)*(PV(3,2)-PV(1,2))+
     1        PV(3,1)*(PV(1,2)-PV(2,2))
      D1=PV(1,1)*(PV(2,2)*PV(3,3)-PV(3,2)*PV(2,3))+
     1     PV(2,1)*(PV(3,2)*PV(1,3)-PV(1,2)*PV(3,3))+
     2     PV(3,1)*(PV(1,2)*PV(2,3)-PV(2,2)*PV(1,3))
      PAMU=0.0
      DO 14 I=1,3
14    PAMU=PAMU+PPM(I)**2
      PAMU=DSQRT(PAMU)
      DO 19 I=1,3
19    PPM(I)=PPM(I)/PAMU
      D1=D1/PAMU
21    CONTINUE
      IF(NS1.NE.0)GO TO 44
      DO 25 I=1,3
25    AM(I)=PPM(I)
      DF=D1
44    NS1=NS1+1
      DO 45 I=1,3
      DR(I)=DABS(PPM(I)-AM(I))
45    IF(DR(I).GT.1D-7)SDM(I)=SDM(I)+DR(I)**2
      DD=DABS(D1-DF)
      IF(DD.GT.1D-7)SDD=SDD+DD**2
      IF((NS1-NN-1).EQ.0)GO TO 47
      DO 46 I=1,NP
      DO 46 J=1,3
      CALL URN
      DA=PSV(I,J)*CP
      IF(M3.GE.5D7)PV(I,J)=QV(I,J)+DA
46    IF(M3.LT.5D7)PV(I,J)=QV(I,J)-DA
      GO TO 43
47    CONTINUE
      DO 48 I=1,3
      SAM(I)=0.0
48    IF(SDM(I).GT.1D-16)SAM(I)=UP*DSQRT(SDM(I))
      SD=0.0
      IF(SDD.GT.1D-16)SD=UP*DSQRT(SDD)
      WRITE(IO,215) NL
215   FORMAT(/' Plane ',I2)
      SUMR=0.0
      WRITE(IO,302)(AM(K),SAM(K),K=1,3),DF,SD
302   FORMAT(' m1 = ',F9.5,'(',F7.5,')'/
     1 ' m2 = ',F9.5,'(',F7.5,')'/' m3 = ',F9.5,'(',F7.5,')'/
     2 ' D  = ',F9.5,'(',F7.5,')')
      WRITE(IO,303)
303   FORMAT(' Atom',14X,'d',10X,'s',11X,'d/s',6X,'(d/s)**2')
      DO 31 K=1,NP
      DSTP=AM(1)*QV(K,1)+AM(2)*QV(K,2)+AM(3)*QV(K,3)-DF
      SDSTP=((AM(1)*PSV(K,1))**2+(AM(2)*PSV(K,2))**2+
     1       (AM(3)*PSV(K,3))**2)
      SDSTP=SQRT(SDSTP)
      IF(SDSTP.LT.1.E-4)SDSTP=1.E-4
      RDS1=DSTP/SDSTP
      RDS2=RDS1**2
      CHR1=PDOL(1,K)
      CHR2=PDOL(2,K)
      CALL LABLAT(CHR1,CHR2)
      LBL(1)=PDOL(1,K)
      LBL(2)=CHR2
      LBL(3)=PDOL(3,K)
      LBL(4)=PDOL(4,K)
      LBL(5)=PDOL(5,K)
      LBL(6)=PDOL(6,K)
      WRITE(IO,310)LBL,DSTP,SDSTP,RDS1,RDS2
310   FORMAT(1X,6A1,'*',5X,F10.4,1X,F10.4,2X,F10.3,F13.3)
      SUMR=SUMR+RDS2
31    CONTINUE
      IF(NFP.EQ.0)GO TO 202
      DO 32 J=1,NFP
      DO 33 L=1,N
      IF(FPDOL(1,J).EQ.SDOL(1,L).AND.FPDOL(2,J).EQ.SDOL(2,L).AND.
     1   FPDOL(3,J).EQ.SDOL(3,L).AND.FPDOL(4,J).EQ.SDOL(4,L).AND.
     2   FPDOL(5,J).EQ.SDOL(5,L).AND.FPDOL(6,J).EQ.SDOL(6,L))GO TO 34
33    CONTINUE
      GO TO 32
34    DO 35 K=1,3
      FPV(J,K)=V(K,L)
      FPSV(J,K)=S(K,L)
35    CONTINUE
      DSTP=AM(1)*FPV(J,1)+AM(2)*FPV(J,2)+AM(3)*FPV(J,3)-DF
      SDSTP=((AM(1)*FPSV(J,1))**2+(AM(2)*FPSV(J,2))**2+
     1        (AM(3)*FPSV(J,3))**2)
      SDSTP=SQRT(SDSTP)
      IF(SDSTP.LT.1.E-4)SDSTP=1.E-4
      RDS1=DSTP/SDSTP
      RDS2=RDS1**2
      CHR1=FPDOL(1,J)
      CHR2=FPDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1)=FPDOL(1,J)
      LBL(2)=CHR2
      LBL(3)=FPDOL(3,J)
      LBL(4)=FPDOL(4,J)
      LBL(5)=FPDOL(5,J)
      LBL(6)=FPDOL(6,J)
      WRITE(IO,304)LBL,DSTP,SDSTP,RDS1,RDS2
304   FORMAT(1X,6A1,6X,F10.4,1X,F10.4,2X,F10.3,F13.3)
32    CONTINUE
202   NGL=3
      STR(1)='p'
      STR(2)='l'
      STR(3)='a'
      STR(4)='n'
      CALL PRTPL(SUMR,NP,STR,NGL)
      RETURN
      END
 
      SUBROUTINE PRTPL(SUMR,NP,STR,NGL)
C-----This routine prints the results of the analysis of planarity
C-----or linearity
      CHARACTER*1 STR(4)
      COMMON/LBL3/CHI2(100)
     1      /INPOU/IN,IO
      WRITE(IO,100)
100   FORMAT(48X,12('='))
      WRITE(IO,101)SUMR
101   FORMAT(15X,'Sum((d/s)**2) for starred atoms',3X,F10.3)
      IF(NP.EQ.NGL)GO TO 3
      NDF=NP-NGL
      WRITE(IO,102)NDF,CHI2(NDF)
102   FORMAT(' Chi-squared at 95% for ',I2,' degrees of freedom: ',
     1 F5.2)
      IF(SUMR.GT.CHI2(NDF))WRITE(IO,103)(STR(L),L=1,4)
103   FORMAT(' The group of atoms deviates significantly from ',
     1 4A1,'arity',/)
      IF(SUMR.LE.CHI2(NDF))WRITE(IO,104)STR
104   FORMAT(' The group of atoms does not deviate significantly ',
     1 'from ',4A1,'arity',/)
3     RETURN
      END
 
      SUBROUTINE LSQLIN(NP,NL,N)
C-----This routine calculates the weighted least-squares line
C-----through a given set of atoms with s.u.'s
      CHARACTER*1 STR(4),PDOL(6,40),FPDOL(6,40),SDOL(6,500),CHR1,
     1 CHR2,LBL(6)
      DIMENSION R(3),PM(3),SXM(3),PPM(3),XM(3),H(3),QV(40,3)
      DOUBLE PRECISION A(6),W2(40),XM,SXM,H,Q,SK,DSC,SNF,T,U,P,
     1 R,F,PM,PPM,SDM(3),DR(3),B,CSF,RMX,DSTP,SDSTP,PAMU,M1,M2,
     2 M3,M4,PV,PSV,QV,AM,SAM,CP,UP
      COMMON/INS1/M1,M2,M3,M4
     1      /GRP3/V(3,500),S(3,500)
     2      /GRP7/FPDOL
     3      /GRN1/PDOL
     4      /GRN2/NFP
     5      /LBL2/CP,UP,NN
     6      /LBL3/CHI2(100)
     7      /GRP4/SDOL
     8      /GRP8/PV(40,3),PSV(40,3),AM(3),SAM(3)
     9      /INPOU/IN,IO
      DO 79 I=1,NP
      W2(I)=1.
      DO 79 J=1,3
      IF(PSV(I,J).LT.1D-5) PSV(I,J)=1D-5
      QV(I,J)=PV(I,J)
79    CONTINUE
      DO 2 I=1,3
2     SDM(I)=0D0
      NS1=0
33    CONTINUE
      DO 78 I=1,3
78    PPM(I)=0.
      DO 1 J=1,3
      XM(J)=0.
      DO 3 I=1,NP
3     XM(J)=XM(J)+PV(I,J)
1     XM(J)=XM(J)/NP
      DO 11 J=1,3
      H(J)=0D0
      DO 12 I=1,NP
12    H(J)=H(J)+DABS(PV(I,J)-XM(J))
11    H(J)=H(J)/NP
      IF(NP.EQ.2) GO TO 4
20    CONTINUE
      DO 5 I=1,6
5     A(I)=0D0
      DO 6 I=1,NP
      A(1)=A(1)+(PV(I,1)-XM(1))**2*W2(I)
      A(2)=A(2)+(PV(I,1)-XM(1))*(PV(I,2)-XM(2))*W2(I)
      A(3)=A(3)+(PV(I,1)-XM(1))*(PV(I,3)-XM(3))*W2(I)
      A(4)=A(4)+(PV(I,2)-XM(2))**2*W2(I)
      A(5)=A(5)+(PV(I,2)-XM(2))*(PV(I,3)-XM(3))*W2(I)
6     A(6)=A(6)+(PV(I,3)-XM(3))**2*W2(I)
      DO 15 K=1,6
      IF(DABS(A(K)).LT.1.D-6)A(K)=0D0
15    CONTINUE
      IF(A(2).LT.1D-9.AND.A(3).LT.1D-9.AND.A(5).LT.1D-9)GO TO 14
      GO TO 16
14    IF(A(1).GT.1D-9.AND.A(4).LT.1D-9.AND.A(6).LT.1D-9)GO TO 28
      IF(A(4).GT.1D-9.AND.A(1).LT.1D-9.AND.A(6).LT.1D-9)GO TO 29
      IF(A(6).GT.1D-9.AND.A(1).LT.1D-9.AND.A(4).LT.1D-9)GO TO 30
16    CONTINUE
      H(1)=-(A(1)+A(4)+A(6))
      H(2)=-(A(2)*A(2)+A(3)*A(3)+A(5)*A(5)-(A(1)*A(4)
     1 +A(1)*A(6)+A(4)*A(6)))
      H(3)=-(A(1)*A(4)*A(6)+2.*A(2)*A(3)*A(5)-
     1 (A(1)*A(5)*A(5)+A(4)*A(3)*A(3)+A(6)*A(2)*A(2)))
      DO 18 I=1,3
      IF(DABS(H(I)).LT.1.D-6)H(I)=0D0
18    CONTINUE
      Q=(3.*H(2)-H(1)**2)/9.
      SK=(9.*H(1)*H(2)-27.*H(3)-2.*H(1)**3)/54.
      DSC=Q**3+SK**2
      B=H(1)/3.
      CSF=-SK/DSQRT(DABS(-Q**3))
      SNF=DSQRT(DABS(1.-CSF**2))
      T=DATAN2(SNF,CSF)/3.
      P=1.047197551
      U=-2.*DSQRT(DABS(-Q))
      R(1)=U*DCOS(T)-B
      R(2)=U*DCOS(T+2.*P)-B
      R(3)=U*DCOS(T+4.*P)-B
      RMX=DMAX1(DABS(R(1)),DABS(R(2)),DABS(R(3)))
      DO 13 I=1,2
      PM(1)=(A(4)-RMX)*(A(6)-RMX)-A(5)**2
      PM(2)=A(3)*A(5)-A(2)*(A(6)-RMX)
13    PM(3)=A(2)*A(5)-A(3)*(A(4)-RMX)
      PAMU=DSQRT(PM(1)**2+PM(2)**2+PM(3)**2)
      DO 25 I=1,3
25    PM(I)=PM(I)/PAMU
      SK=0.0
      DO 9 I=1,NP
      W2(I)=0.0
      DO 9 J=1,3
      W2(I)=W2(I)+(1-PM(J)**2)*PSV(I,J)**2
      IF(W2(I).LT.1.D-8) W2(I)=1.D-8
      W2(I)=1./W2(I)
9     SK=SK+W2(I)
      Q=SK/NP
      DO 27 I=1,NP
27    W2(I)=W2(I)/Q
      SK=0D0
      DO 82 I=1,NP
82    SK=SK+W2(I)**2
      SK=DSQRT(SK)
      DO 83 I=1,NP
83    W2(I)=W2(I)/SK
      IF(DABS(DABS(PPM(1))-DABS(PM(1))).LT.1D-5.AND.DABS(DABS
     1 (PPM(2))-DABS(PM(2))).LT.1D-5.AND.DABS(DABS(PPM(3))-
     2 DABS(PM(3))).LT.1D-5) GO TO 21
      DO 23 I=1,3
23    PPM(I)=PM(I)
      GO TO 20
4     PAMU=0D0
      DO 47 I=1,3
      R(I)=PV(2,I)-PV(1,I)
47    PAMU=PAMU+R(I)**2
      PAMU=DSQRT(PAMU)
      DO 54 I=1,3
54    PPM(I)=R(I)/PAMU
      GO TO 21
28    PPM(1)=1.
      PPM(2)=0.
      PPM(3)=0.
      GO TO 7
29    PPM(1)=0.
      PPM(2)=1.
      PPM(3)=0.
      GO TO 7
30    PPM(1)=0.
      PPM(2)=0.
      PPM(3)=1.
7     CONTINUE
21    IF(DABS(PPM(1)).GT..9999) GO TO 10
      IF(DABS(PPM(2)).GT..9999) GO TO 24
      IF(DABS(PPM(3)).GT..9999) GO TO 26
      GO TO 17
10    PPM(1)=1.
      PPM(2)=0.
      PPM(3)=0.
      GO TO 17
24    PPM(1)=0.
      PPM(2)=1.
      PPM(3)=0.
      GO TO 17
26    PPM(1)=0.
      PPM(2)=0.
      PPM(3)=1.
17    CONTINUE
      IF(NS1.NE.0)GO TO 8
      DO 22 I=1,3
22    AM(I)=PPM(I)
8     NS1=NS1+1
      DO 19 I=1,3
      DR(I)=DABS(PPM(I)-AM(I))
19    IF(DR(I).GT.1D-7)SDM(I)=SDM(I)+DR(I)**2
      IF((NS1-NN-1).EQ.0)GO TO 37
      DO 35 I=1,NP
      DO 35 J=1,3
      CALL URN
      Q=PSV(I,J)*CP
      IF(M3.GE.5D7)PV(I,J)=QV(I,J)+Q
35    IF(M3.LT.5D7)PV(I,J)=QV(I,J)-Q
      GO TO 33
37    CONTINUE
      DO 38 I=1,3
      SAM(I)=0.
38    IF(SDM(I).GT.1D-16)SAM(I)=UP*DSQRT(SDM(I))
      DO 49 J=1,3
      XM(J)=0.
      SXM(J)=0.
      DO 48 I=1,NP
      XM(J)=XM(J)+QV(I,J)
48    SXM(J)=SXM(J)+PSV(I,J)**2
      XM(J)=XM(J)/NP
49    SXM(J)=DSQRT(SXM(J))/NP
      WRITE(IO,100)NL
100   FORMAT(/'  Line ',I2)
      WRITE(IO,101)(AM(I),SAM(I),XM(I),SXM(I),I=1,3)
101   FORMAT(' m1 = ',F9.5,'(',F7.5,')',5X,'X0 = ',F9.5,'(',F7.5,
     1 ')'/' m2 = ',F9.5,'(',F7.5,')',5X,'Y0 = ',F9.5,'(',F7.5,
     2 ')'/' m3 = ',F9.5,'(',F7.5,')',5X,'Z0 = ',F9.5,'(',F7.5,')')
      WRITE(IO,102)
102   FORMAT(' Atom',14X,'d',10X,'s',11X,'d/s',6X,'(d/s)**2')
      SUMR=0.0
      DO 39 K=1,NP
      F=0.0
      DSTP=0.0
      SDSTP=0.0
      DO 31 I=1,3
      H(I)=QV(K,I)-XM(I)
      IF(DABS(H(I)).LT.1.D-8)H(I)=0.0
      R(I)=1.-PPM(I)**2
      DSTP=DSTP+H(I)**2
      F=F+H(I)*PPM(I)
31    SDSTP=SDSTP+PSV(K,I)**2*R(I)
      IF(DSTP.LT.1.D-8) DSTP=0.0
      IF(DABS(F).LT.1.D-8) F=0.0
      DSTP=DSQRT(DABS(DSTP-F**2))
      SDSTP=DSQRT(DABS(SDSTP))
      IF(SDSTP.LT.1.D-5)SDSTP=1.D-5
      RDS1=DSTP/SDSTP
      RDS2=RDS1**2
      CHR1=PDOL(1,K)
      CHR2=PDOL(2,K)
      CALL LABLAT(CHR1,CHR2)
      LBL(1)=PDOL(1,K)
      LBL(2)=CHR2
      LBL(3)=PDOL(3,K)
      LBL(4)=PDOL(4,K)
      LBL(5)=PDOL(5,K)
      LBL(6)=PDOL(6,K)
      WRITE(IO,103)LBL,DSTP,SDSTP,RDS1,RDS2
103   FORMAT(1X,6A1,'*',5X,F10.4,1X,F10.4,2X,F10.3,F13.3)
      SUMR=SUMR+RDS2
39    CONTINUE
      IF(NFP.EQ.0) GO TO 104
      DO 40 J=1,NFP
      DO 41 L=1,N
      IF(FPDOL(1,J).EQ.SDOL(1,L).AND.FPDOL(2,J).EQ.SDOL(2,L).AND.
     1   FPDOL(3,J).EQ.SDOL(3,L).AND.FPDOL(4,J).EQ.SDOL(4,L).AND.
     2   FPDOL(5,J).EQ.SDOL(5,L).AND.FPDOL(6,J).EQ.SDOL(6,L))GO TO 42
41    CONTINUE
      GO TO 40
42    DO 43 K=1,3
      QV(J,K)=V(K,L)
      PSV(J,K)=S(K,L)
      IF(PSV(J,K).LT.1D-5)PSV(J,K)=1D-5
43    CONTINUE
      F=0.0
      DSTP=0.0
      SDSTP=0.0
      DO 32 I=1,3
      H(I)=QV(J,I)-XM(I)
      R(I)=1.-PPM(I)**2
      DSTP=DSTP+H(I)**2
      F=F+H(I)*PPM(I)
32    SDSTP=SDSTP+PSV(J,I)**2*R(I)
      DSTP=DSQRT(DABS(DSTP-F**2))
      SDSTP=DSQRT(DABS(SDSTP))
      IF(SDSTP.LT.1.D-5)SDSTP=1.D-5
      RDS1=DSTP/SDSTP
      RDS2=RDS1**2
      CHR1=FPDOL(1,J)
      CHR2=FPDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1)=FPDOL(1,J)
      LBL(2)=CHR2
      LBL(3)=FPDOL(3,J)
      LBL(4)=FPDOL(4,J)
      LBL(5)=FPDOL(5,J)
      LBL(6)=FPDOL(6,J)
      WRITE(IO,105)LBL,DSTP,SDSTP,RDS1,RDS2
105   FORMAT(1X,6A1,6X,F10.4,1X,F10.4,2X,F10.3,F13.3)
40    CONTINUE
104   NGL=2
      STR(1)='l'
      STR(2)='i'
      STR(3)='n'
      STR(4)='e'
      CALL PRTPL(SUMR,NP,STR,NGL)
      RETURN
      END
 
      SUBROUTINE ANGDS(K,J,RD)
C-----This routine calculates the angle formed by planes or
C-----lines with s.u.
      DOUBLE PRECISION M1,M2,M3,M4,UP,XU(3),XOU(3),CST,SNT,S1,S2,
     1 TH,ST,CP,X,SX,XO,SXO
      COMMON/INS1/M1,M2,M3,M4
     1      /LBL1/X(3),SX(3),XO(3),SXO(3)
     2      /LBL2/CP,UP,NN
     3      /INPOU/IN,IO
      NS1=0
      ST=0D0
      DO 1 I=1,3
      SX(I)=CP*SX(I)
      SXO(I)=CP*SXO(I)
      XU(I)=X(I)
1     XOU(I)=XO(I)
2     CONTINUE
      S1=0D0
      S2=0D0
      DO 3 I=1,3
      S1=S1+XU(I)**2
3     S2=S2+XOU(I)**2
      S1=DSQRT(S1)
      S2=DSQRT(S2)
      DO 4 I=1,3
      XU(I)=XU(I)/S1
4     XOU(I)=XOU(I)/S2
      CST=0D0
      DO 5 I=1,3
5     CST=CST+XU(I)*XOU(I)
      IF(DABS(CST).LT.1D-8)CST=0D0
      SNT=DSQRT(DABS(1D0-CST**2))
      S1=DATAN2(SNT,CST)
      IF(NS1.NE.0)GO TO 6
      TH=S1
6     NS1=NS1+1
      S2=DABS(S1-TH)
      IF(S2.GT.1D-7)ST=ST+S2**2
      IF((NS1-NN-1).EQ.0)GO TO 9
      DO 7 I=1,3
      CALL URN
      IF(M3.GE.5D7)XU(I)=X(I)+SX(I)
7     IF(M3.LT.5D7)XU(I)=X(I)-SX(I)
      DO 8 I=1,3
      CALL URN
      IF(M3.GE.5D7)XOU(I)=XO(I)+SXO(I)
8     IF(M3.LT.5D7)XOU(I)=XO(I)-SXO(I)
      GO TO 2
9     SA=0.0
      IF(ST.GT.1D-16)SA=(UP*DSQRT(ST))
      ANG=TH*RD
      ANG1=ANG
      IF(ANG.GT.90)ANG=180-ANG
      IF(ANG1.LT.90)ANG1=180-ANG1
      SA=SA*RD
      WRITE(IO,100)K,J,ANG,SA,ANG1,SA
100   FORMAT(2X,I2,6X,I2,2(13X,F6.2,'(',F5.2,')'))
      RETURN
      END
 
      SUBROUTINE CRTCRD(NP,PG)
C-----This routine calculates the cartesian coordinates for a
C-----set of atoms assuming the origin at the center of the set
C-----NP=number of the atoms of the set (max 40)
C-----XC=cartesian coordinates
      DIMENSION B(3,3),R2(3),R3(3)
      COMMON/INS7/PV(40,3)
     1      /GRP9/ZC(40)
     2      /INS5/XC(40,3),S1(40,3)
      DO 1 K=1,3
1     B(1,K)=0.0
      DO 2 K=1,3
      DO 3 J=1,NP
3     B(1,K)=B(1,K)+PV(J,K)
2     B(1,K)=B(1,K)/NP
      DO 4 J=1,NP
      DO 4 K=1,3
4     PV(J,K)=PV(J,K)-B(1,K)
      DO 5 K=1,3
      R2(K)=0.0
5     R3(K)=0.0
      F=NP
      DO 6 K=1,3
      DO 6 J=1,NP
      F1=J-1
      F2=F1/F
      R2(K)=R2(K)+PV(J,K)*SIN(2.*PG*F2)
6     R3(K)=R3(K)+PV(J,K)*COS(2.*PG*F2)
      B(3,1)=R2(2)*R3(3)-R2(3)*R3(2)
      B(3,2)=R2(3)*R3(1)-R2(1)*R3(3)
      B(3,3)=R2(1)*R3(2)-R2(2)*R3(1)
      AQ=SQRT(B(3,1)**2+B(3,2)**2+B(3,3)**2)
      DO 7 K=1,3
7     B(3,K)=B(3,K)/AQ
      V=0.0
      DO 8 K=1,3
8     V=V+PV(1,K)*B(3,K)
      DO 9 K=1,3
9     R2(K)=V*B(3,K)
      DO 10 K=1,3
10    R3(K)=PV(1,K)-R2(K)
      V=0.0
      DO 11 K=1,3
11    V=V+R3(K)**2
      V=SQRT(V)
      DO 12 K=1,3
12    B(2,K)=R3(K)/V
      B(1,1)=B(2,2)*B(3,3)-B(2,3)*B(3,2)
      B(1,2)=B(2,3)*B(3,1)-B(2,1)*B(3,3)
      B(1,3)=B(2,1)*B(3,2)-B(2,2)*B(3,1)
      AQ=SQRT(B(1,1)**2+B(1,2)**2+B(1,3)**2)
      DO 13 K=1,3
13    B(1,K)=B(1,K)/AQ
      DO 14 J=1,NP
      DO 15 I=1,3
      XC(J,I)=0.
      DO 15 K=1,3
15    XC(J,I)=XC(J,I)+B(I,K)*PV(J,K)
14    CONTINUE
      DO 16 J=1,NP
16    ZC(J)=XC(J,3)
      RETURN
      END
 
      SUBROUTINE PUCK(NP,PG,KDC)
C-----This routine calculates the ring puckering coordinates
C-----following Cremer & Pople, JACS (1975).97,1354.
C-----NP=number of atoms of the ring (max 40)
C-----ZC=cartesian Z coordinates
C-----QM=puckering amplitude
C-----PHI=puckering angle
C-----QT=total puckering amplitude
C-----THETA=spherical polar angle
      DIMENSION QC(20),QS(20)
      COMMON/GRP9/ZC(40)
     1      /INS2/QM(20),PHI(20),THETA(20),QT
      F=NP
      KDC=0
      DO 15 L=1,20
15    THETA(L)=0.0
      IF(MOD(NP,2).EQ.0)GO TO 5
      IF(NP.LT.5)GO TO 13
      NM1=(NP-1)/2
      QT=0.0
      DO 1 M=2,NM1
      QC(M-1)=0.
      QS(M-1)=0.
      DO 2 J=1,NP
      F1=M*(J-1)
      QC(M-1)=QC(M-1)+SQRT(2./F)*ZC(J)*COS(2.*PG*F1/F)
2     QS(M-1)=QS(M-1)-SQRT(2./F)*ZC(J)*SIN(2.*PG*F1/F)
      PHI(M-1)=ATAN2(QS(M-1),QC(M-1))
1     QM(M-1)=QS(M-1)/SIN(PHI(M-1))
      IF(NP.LT.7)GO TO 14
      DO 3 M=2,NM1
3     QT=QT+QM(M-1)**2
      QT=SQRT(QT)
      NM3=(NP-3)/2
      DO 4 M=2,NM3
4     THETA(M-1)=ATAN2(QM(M-1),QM(M))
      GO TO 14
5     IF(NP.LT.4)GO TO 13
      IF(NP.EQ.4)GO TO 11
      NM1=NP/2-1
      DO 6 M=2,NM1
      QC(M-1)=0.0
      QS(M-1)=0.0
      DO 7 J=1,NP
      F1=M*(J-1)
      QC(M-1)=QC(M-1)+SQRT(2./F)*ZC(J)*COS(2.*PG*F1/F)
7     QS(M-1)=QS(M-1)-SQRT(2./F)*ZC(J)*SIN(2.*PG*F1/F)
      PHI(M-1)=ATAN2(QS(M-1),QC(M-1))
6     QM(M-1)=QS(M-1)/SIN(PHI(M-1))
      NPF2=NP/2
      QM(NPF2-1)=0.0
      DO 8 J=1,NP
      F1=J-1
8     QM(NPF2-1)=QM(NPF2-1)+SQRT(1./F)*ZC(J)*COS(PG*F1)
      QT=0.0
      DO 9 M=2,NPF2
9     QT=QT+QM(M-1)**2
      QT=SQRT(QT)
      DO 10 M=2,NM1
10    THETA(M-1)=ATAN2(QM(M-1),QM(M))
      GO TO 14
11    QM(1)=0.0
      DO 12 J=1,NP
      F1=J-1
12    QM(1)=QM(1)+SQRT(1./F)*ZC(J)*COS(PG+F1)
      GO TO 14
13    KDC=1
14    RETURN
      END
 
      SUBROUTINE CRTPL(KO,NQ,NP,PDOL,PG,RD)
C-----This routine calculates the cartesian and spherical polar
C-----coordinates for a set of atoms
C-----NP=number of the atoms of the set (max=40)
C-----PDOL=symbols of the atoms
C-----XC=cartesian coordinates
C-----XP=spherical polar coordinates
      CHARACTER*1 PDOL(6,40),CHR1,CHR2,LBL(6)
      DIMENSION B(3,3),R2(3),R3(3),XC(40,3),XP(40,3)
      COMMON/INS7/PV(40,3)
     1      /INPOU/IN,IO
      DO 1 K=1,3
1     B(1,K)=0.0
      DO 5 K=1,3
      R2(K)=0.0
5     R3(K)=0.0
      AQ=0.0
      V=0.0
      GO TO (18,29,19),KO
18    DO 20 K=1,3
20    B(1,K)=PV(1,K)
      DO 21 J=1,NP
      DO 21 K=1,3
21    PV(J,K)=PV(J,K)-B(1,K)
      GO TO (22,29),KO
22    DO 23 K=1,3
23    AQ=AQ+PV(2,K)**2
      AQ=SQRT(AQ)
      DO 24 K=1,3
24    B(3,K)=PV(2,K)/AQ
      DO 25 K=1,3
25    V=V+PV(3,K)*B(3,K)
      DO 26 K=1,3
26    R2(K)=V*B(3,K)
      DO 27 K=1,3
27    R3(K)=PV(3,K)-R2(K)
      GO TO 31
29    K1=2
      GO TO 32
19    K1=1
32    QN=NQ-K1+1
      DO 2 K=1,3
      DO 3 J=K1,NQ
3     B(1,K)=B(1,K)+PV(J,K)
2     B(1,K)=B(1,K)/QN
      DO 4 J=1,NP
      DO 4 K=1,3
4     PV(J,K)=PV(J,K)-B(1,K)
      DO 6 K=1,3
      DO 6 J=K1,NQ
      F1=J-K1
      F2=F1/QN
      R2(K)=R2(K)+PV(J,K)*SIN(2.*PG*F2)
6     R3(K)=R3(K)+PV(J,K)*COS(2.*PG*F2)
      B(3,1)=R2(2)*R3(3)-R2(3)*R3(2)
      B(3,2)=R2(3)*R3(1)-R2(1)*R3(3)
      B(3,3)=R2(1)*R3(2)-R2(2)*R3(1)
      AQ=SQRT(B(3,1)**2+B(3,2)**2+B(3,3)**2)
      DO 7 K=1,3
7     B(3,K)=B(3,K)/AQ
      V=0.0
      DO 8 K=1,3
8     V=V+PV(K1,K)*B(3,K)
      DO 9 K=1,3
9     R2(K)=V*B(3,K)
      DO 10 K=1,3
10    R3(K)=PV(K1,K)-R2(K)
31    V=0.0
      DO 11 K=1,3
11    V=V+R3(K)**2
      V=SQRT(V)
      DO 12 K=1,3
12    B(2,K)=R3(K)/V
      B(1,1)=B(2,2)*B(3,3)-B(2,3)*B(3,2)
      B(1,2)=B(2,3)*B(3,1)-B(2,1)*B(3,3)
      B(1,3)=B(2,1)*B(3,2)-B(2,2)*B(3,1)
      AQ=SQRT(B(1,1)**2+B(1,2)**2+B(1,3)**2)
      DO 13 K=1,3
13    B(1,K)=B(1,K)/AQ
      DO 14 J=1,NP
      DO 15 I=1,3
      XC(J,I)=0.0
      DO 15 K=1,3
15    XC(J,I)=XC(J,I)+B(I,K)*PV(J,K)
14    CONTINUE
      GO TO(37,33,37),KO
33    DO 35 K=1,3
35    B(1,K)=XC(1,K)
      DO 34 J=1,NP
      DO 34 K=1,3
34    XC(J,K)=XC(J,K)-B(1,K)
37    DO 16 J=1,NP
      XP(J,1)=SQRT(XC(J,1)**2+XC(J,2)**2+XC(J,3)**2)
      IF(ABS(XC(J,1)).LT.1E-7.AND.ABS(XC(J,2)).LT.1E-7)GO TO 38
      IF(ABS(XC(J,1)).LT.1E-7) XC(J,1)=0.0
      IF(ABS(XC(J,2)).LT.1E-7) XC(J,2)=0.0
      XP(J,2)=ATAN2(XC(J,2),XC(J,1))
      XP(J,2)=XP(J,2)*RD
      V=XC(J,3)/XP(J,1)
      IF(V**2.GT.1.)V=1.
      XP(J,3)=ATAN2(SQRT(1.-V**2),V)*RD
      IF(XP(J,3).EQ.0.)XP(J,2)=0.0
      GO TO 16
38    XP(J,2)=0.
      XP(J,3)=0.
16    CONTINUE
      WRITE(IO,100)
100   FORMAT(' Atom      cartesian coordinates',6X,
     1 'spherical coordinates'/12X,'X',8X,'Y',8X,'Z',9X,
     2 'R',6X,'Phi',4X,'Theta')
      DO 17 J=1,NP
      CHR1=PDOL(1,J)
      CHR2=PDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1)=PDOL(1,J)
      LBL(2)=CHR2
      LBL(3)=PDOL(3,J)
      LBL(4)=PDOL(4,J)
      LBL(5)=PDOL(5,J)
      LBL(6)=PDOL(6,J)
17    WRITE(IO,110)LBL,(XC(J,K),K=1,3),(XP(J,L),L=1,3)
110   FORMAT(1X,6A1,3F9.4,F9.3,2F8.2)
      RETURN
      END
 
      SUBROUTINE CONVE(II,DX)
      DIMENSION IX(5)
      CHARACTER*1 II(5),IA(10)
      DATA IA/'0','1','2','3','4','5','6','7','8','9'/
      DO 2 I=1,5
      IX(I)=0
      DO 3 K=1,10
      IF(IA(K).EQ.II(I)) GO TO 1
3     CONTINUE
1     IX(I)=K-1
2     CONTINUE
      IF(II(5).NE.' ') DX=IX(1)*0.1+IX(2)*0.01+IX(3)*0.001+
     1 IX(4)*0.0001+IX(5)*0.00001
      IF(II(5).EQ.' ') DX=IX(1)*0.01+IX(2)*0.001+IX(3)*0.0001+
     1 IX(4)*0.00001
      IF(II(4).EQ.' ') DX=IX(1)*0.001+IX(2)*0.0001+IX(3)*0.00001
      IF(II(3).EQ.' ') DX=IX(1)*0.0001+IX(2)*0.00001
      IF(II(2).EQ.' ') DX=IX(1)*0.00001
      IF(II(1).EQ.' ') DX=0.0
      RETURN
      END
 
      SUBROUTINE URN
C-----This routine calculates 8-digit pseudo-random numbers
C-----following C.G.Swain & M.S.Swain, J.Chem.Inf.Comput.Sci.
C-----(1980),20, p. 56
      DOUBLE PRECISION M1,M2,M3,M4
      COMMON/INS1/M1,M2,M3,M4
      M4=M1+M2+M3
      IF(M2.LT.5D7)M4=M4+1357D0
      IF(M4.GE.1D8)M4=M4-1D8
      IF(M4.GE.1D8)M4=M4-1D8
      M1=M2
      M2=M3
      M3=M4
      RETURN
      END
 
      SUBROUTINE ASYMMP(NP)
C-----This routine calculates the displacement asymmetry
C-----parameters DS(A),DS(A-B),D2(A),D2(A-B) for a N-membered ring
C-----(MAX N=40).
      CHARACTER*1 PDOL(6,40),CHR1,CHR2,LBL(6,40)
      COMMON/GRN1/PDOL
     1      /GRN3/LBL
     2      /INS5/XC(40,3),SC(40,3)
     3      /PAR1/DS(2),SDS(2),D2(2),SD2(2),KDC
     4      /INPOU/IN,IO
      DO 1 J=1,NP
      XC(J,1)=SQRT(XC(J,1)**2+XC(J,2)**2+XC(J,3)**2)
1     SC(J,1)=SQRT(SC(J,1)**2+SC(J,2)**2+SC(J,3)**2)
      KDC=MOD(NP,2)
      NP1=NP+1
      DO 2 J=NP1,40
      DO 2 L=1,6
2     PDOL(L,J)=' '
      DO 9 J=1,40
      CHR1=PDOL(1,J)
      CHR2=PDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,J)=PDOL(1,J)
      LBL(2,J)=CHR2
      LBL(3,J)=PDOL(3,J)
      LBL(4,J)=PDOL(4,J)
      LBL(5,J)=PDOL(5,J)
9     LBL(6,J)=PDOL(6,J)
      WRITE(IO,100)((LBL(L,J),L=1,6),J=1,20)
100   FORMAT(1X,80A1)
      IF(KDC.NE.0)GO TO 4
      ND2=NP/2
      M=ND2-1
      M1=M+1
      DO 3 I=1,ND2
      DO 7 K=1,2
      DS(K)=0.0
      SDS(K)=0.0
      D2(K)=0.0
7     SD2(K)=0.0
      N1=2
      N2=ND2
      L=1
      CALL APAR(NP,N1,N2,M,L)
      N1=1
      L=2
      CALL APAR(NP,N1,N2,M1,L)
      WRITE(IO,101)(LBL(L,1),L=1,6),DS(1),SDS(1),(LBL(L,1),L=1,6),
     1 (LBL(L,NP),L=1,6),DS(2),SDS(2),(LBL(L,1),L=1,6),D2(1),
     2 SD2(1),(LBL(L,1),L=1,6),(LBL(L,NP),L=1,6),D2(2),SD2(2)
101   FORMAT(1X,'DS(',6A1,')=',F6.4,'(',F6.4,')',8X,
     1  'DS(',6A1,'-',6A1,')=',F6.4,'(',F6.4,')'/
     2       1X,'D2(',6A1,')=',F6.4,'(',F6.4,')',8X,
     3  'D2(',6A1,'-',6A1,')=',F6.4,'(',F6.4,')'/)
      CALL ROTRIN(NP)
3     CONTINUE
      GO TO 6
4     M=(NP-1)/2
      N1=2
      N2=M+1
      L=1
      DO 5 I=1,NP
      DO 8 K=1,2
      DS(K)=0.0
      SDS(K)=0.0
      D2(K)=0.0
8     SD2(K)=0.0
      CALL APAR(NP,N1,N2,M,L)
      WRITE(IO,102)(LBL(K,1),K=1,6),DS(1),SDS(1),(LBL(K,1),K=1,6),
     1 D2(1),SD2(1)
102   FORMAT(1X,'DS(',6A1,')=',F6.4,'(',F6.4,')',8X,'D2(',6A1,
     1 ')=',F6.4,'(',F6.4,')')
      CALL ROTRIN(NP)
5     CONTINUE
6     RETURN
      END
 
      SUBROUTINE APAR(NP,N1,N2,M,L)
C-----This routine calculates the displacement asymmetry
C-----parameters with s.u.'s.
      COMMON/INS5/Z(40,3),S(40,3)
     1      /PAR1/DS(2),SDS(2),D2(2),SD2(2),KDC
      MM=M
      KK=2
      IF(L.EQ.2)KK=1
      DO 1 J=N1,N2
      K=NP-J+KK
      B1=Z(J,3)/Z(J,1)
      B2=Z(K,3)/Z(K,1)
      A1=(B1-B2)**2
      A2=(B1+B2)**2
      DS(L)=DS(L)+A1
      D2(L)=D2(L)+A2
      A3=(S(J,3)**2+(Z(J,3)*S(J,1)/Z(J,1)**2)**2)/Z(J,1)**2
     1  +(S(K,3)**2+(Z(K,3)*S(K,1)/Z(K,1)**2)**2)/Z(K,1)**2
      SDS(L)=SDS(L)+A1*A3
1     SD2(L)=SD2(L)+A2*A3
      DS(L)=SQRT(DS(L)/MM)
      SDS(L)=(SQRT(SDS(L))/(MM*DS(L)))
      IF(L.NE.1)GO TO 2
      B1=(Z(1,3)/Z(1,1))**2
      D2(L)=D2(L)+B1
      SD2(L)=SD2(L)+((S(1,3)/Z(1,1))**2+(Z(1,3)*S(1,1)/Z(1,1)
     1 **2)**2)*B1
      MM=MM+1
      IF(KDC.NE.0)GO TO 2
      K=NP/2+1
      B2=(Z(K,3)/Z(K,1))**2
      D2(L)=D2(L)+B2
      SD2(L)=SD2(L)+((S(K,3)/Z(K,1))**2+(Z(K,3)*S(K,1)/Z(K,1)
     1 **2)**2)*B2
      MM=MM+1
2     CONTINUE
      D2(L)=SQRT(D2(L)/MM)
      SD2(L)=(SQRT(SD2(L))/(MM*D2(L)))
      RETURN
      END
 
      SUBROUTINE ROTRIN(NP)
C-----This routine performs a cyclic permutation of the atoms
C-----in a ring
      CHARACTER*1 PDOL(6,40),RS(6),CHR1,CHR2,LBL(6,40)
      DIMENSION R1(3),R2(3)
      COMMON/GRN1/PDOL
     1      /GRN3/LBL
     2      /INS5/Z(40,3),S(40,3)
      DO 4 L=1,6
4     RS(L)=PDOL(L,1)
      DO 1 K=1,3
      R1(K)=Z(1,K)
1     R2(K)=S(1,K)
      NP1=NP-1
      DO 2 J=1,NP1
      DO 5 L=1,6
5     PDOL(L,J)=PDOL(L,J+1)
      DO 2 K=1,3
      Z(J,K)=Z(J+1,K)
2     S(J,K)=S(J+1,K)
      DO 6 L=1,6
6     PDOL(L,NP)=RS(L)
      DO 3 K=1,3
      Z(NP,K)=R1(K)
3     S(NP,K)=R2(K)
      DO 7 J=1,40
      CHR1=PDOL(1,J)
      CHR2=PDOL(2,J)
      CALL LABLAT(CHR1,CHR2)
      LBL(1,J)=PDOL(1,J)
      LBL(2,J)=CHR2
      LBL(3,J)=PDOL(3,J)
      LBL(4,J)=PDOL(4,J)
      LBL(5,J)=PDOL(5,J)
7     LBL(6,J)=PDOL(6,J)
      RETURN
      END
 
      SUBROUTINE INTERC(N,DM,NL,BRV,NH2,IS,KKR,KE)
C-----This routine calculates all the interatomic contacts,
C-----involving atoms of different equivalent positions in the same
C-----or in adjacent cells, less than a given maximum value
      CHARACTER*1 STR(38),BRV,STPE(38,50),SDOL(6,500),
     1 AD1(6),AD2(6),STR1(38)
      CHARACTER*2 SDL2(500),AAD1,AAD2
      INTEGER LE1(24,3,3),LE(3,3)
      DIMENSION B(3,3),F1(24,3),F(3),FB(3)
      COMMON/COOR/V(3,500),S(3,500)
     1      /GRP1/C(3),SC(3),A(3),SA(3)
     2      /INS4/CS(3),SN(3)
     3      /GRP4/SDOL
     4      /EQVP/LE1,F1,FB
     5      /COOA/X1(3),X2(3),S1(3),S2(3)
     6      /LBL4/STPE
     7      /LBL6/NPE,LH(50,3,3),FH(50,3)
      COMMON/NEW/IL(2,700)
     1      /NEW2/IA(3,2000)
     2      /NEW3/IT(4,3000)
     3      /INPOU/IN,IO
     4      /EDAT/IC,NE
     5      /BRAV/KB,B
     6      /GRG1/SDL2
      DO 16 I=1,24
      DO 16 J=1,3
      F1(I,J)=0.0
      DO 16 K=1,3
16    LE1(I,J,K)=0
      READ(IN,*,END=21)IC,NE,NT
      GO TO 22
21    STOP
22    NE=NE+1
      IF(KKR.EQ.1.AND.KE.NE.0)WRITE(IO,100)
100   FORMAT(/' Equivalent positions:'/2X,'x,y,z')
      IF(NE.EQ.1)GO TO 12
      DO 1 I=2,NE
      CALL DECEQP(STR,LE,F)
      NST=38
      CALL LABCOO(NST,STR,STR1)
      IF(KKR.EQ.1.AND.KE.NE.0)WRITE(IO,101)STR1
101   FORMAT(2X,38A1)
      DO 1 J=1,3
      F1(I,J)=F(J)
      LE1(1,J,J)=1
      DO 1 K=1,3
1     LE1(I,J,K)=LE(J,K)
      GO TO 14
12    DO 13 J=1,3
13    LE1(1,J,J)=1
14    CONTINUE
      IF(IC.EQ.1)GO TO 15
      IF(KKR.EQ.1.AND.KE.NE.0)WRITE(IO,102)
102   FORMAT(' plus the centrosymmetric ones')
15    CONTINUE
      IF(KKR.EQ.1.AND.KE.NE.0)WRITE(IO,104)NT
104   FORMAT(/' Maximum translation by',I2,' unit cell'/)
      DO 19 I=1,3
      DO 19 J=1,3
19    B(I,J)=0.0
      IF(KKR.EQ.1.AND.KE.NE.0)WRITE(IO,103)DM
103   FORMAT(/' Intermolecular contacts less than ',F4.2,
     1 ' Angstrom'/54X,'Distance   s.u.')
      KB=0
      IF(BRV.EQ.'P') GO TO 7
      IF(BRV.NE.'A') GO TO 2
      B(1,2)=1./2.
      B(1,3)=1./2.
      KB=1
      GO TO 7
2     IF(BRV.NE.'B') GO TO 3
      B(1,1)=1./2.
      B(1,3)=1./2.
      KB=1
      GO TO 7
3     IF(BRV.NE.'C') GO TO 4
      B(1,1)=1./2.
      B(1,2)=1./2.
      KB=1
      GO TO 7
4     IF(BRV.NE.'I') GO TO 5
      B(1,1)=1./2.
      B(1,2)=1./2.
      B(1,3)=1./2.
      KB=1
      GO TO 7
5     IF(BRV.NE.'R') GO TO 6
      B(1,1)=1./3.
      B(2,2)=1./3.
      B(2,3)=1./3.
      B(1,2)=2*B(1,1)
      B(1,3)=2*B(1,1)
      B(2,1)=2*B(1,1)
      KB=2
      GO TO 7
6     B(1,2)=1./2.
      B(1,3)=1./2.
      B(2,1)=1./2.
      B(2,3)=1./2.
      B(3,1)=1./2.
      B(3,2)=1./2.
      KB=3
7     CONTINUE
      IF(KKR.EQ.0)GO TO 20
      DO 11 I=1,N
      DO 11 J=1,N
      DO 18 L=1,6
      AD1(L)=SDOL(L,I)
18    AD2(L)=SDOL(L,J)
      AAD1=SDL2(I)
      AAD2=SDL2(J)
      DO 8 K=1,3
      X1(K)=V(K,I)
      S1(K)=S(K,I)
      X2(K)=V(K,J)
8     S2(K)=S(K,J)
      DO 17 L=1,3
17    FB(L)=0.0
      IF(KKR.EQ.1)CALL DISCON(AD1,AD2,AAD1,AAD2,DM,NL,NT,NH2,I,J,IS,KE)
      IF(KB.EQ.0)GO TO 11
      DO 10 L=1,KB
      DO 9  K=1,3
9     FB(K)=B(L,K)
      IF(KKR.EQ.1)CALL DISCON(AD1,AD2,AAD1,AAD2,DM,NL,NT,NH2,I,J,IS,KE)
10    CONTINUE
11    CONTINUE
20    RETURN
      END
 
      SUBROUTINE LABCOO(N,STR,STR1)
C-----Transforms X,Y,Z upper case to x,y,z low case in a N character
C-----string
      CHARACTER*1 STR(N),STR1(N)
      DO 1 I=1,N
      STR1(I)=STR(I)
      IF(STR(I).EQ.'X')THEN
      STR1(I)='x'
      ELSEIF(STR(I).EQ.'Y')THEN
      STR1(I)='y'
      ELSEIF(STR(I).EQ.'Z')THEN
      STR1(I)='z'
      ENDIF
1     CONTINUE
      RETURN
      END
 
      SUBROUTINE DISCON(AD1,AD2,AAD1,AAD2,DM,NL,NT,NH2,NI,NJ,IS,KE)
      CHARACTER*1 STPE(38,50),AD1(6),AD2(6)
      CHARACTER*2 AAD1,AAD2,SDL2(500)
      INTEGER LE1(24,3,3),FT(3),LE(3,3)
      DIMENSION F1(24,3),FB(3),F(3)
      COMMON/COOA/X1(3),X2(3),S1(3),S2(3)
     1      /GRP1/C(3),SC(3),A(3),SA(3)
     2      /INS4/CS(3),SN(3)
     3      /EQVP/LE1,F1,FB
     4      /LBL4/STPE
     5      /LBL6/NPE,LH(50,3,3),FH(50,3)
     6      /NEW/IL(2,700)
     7      /NEW2/IA(3,2000)
     8      /NEW3/IT(4,3000)
     9      /EDAT/IC,NE
     1      /GRG1/SDL2
      KM=2*NT+1
      DO 3 I=1,NE
      DO 3 I1=1,KM
      FT(1)=I1-NT-1
      DO 3 I2=1,KM
      FT(2)=I2-NT-1
      DO 3 I3=1,KM
      FT(3)=I3-NT-1
      DO 1 J=1,3
      F(J)=F1(I,J)+FB(J)+FT(J)
      DO 1 K=1,3
1     LE(J,K)=LE1(I,J,K)
      CALL DSTCHB(DM,AD1,AD2,AAD1,AAD2,LE,F,NL,NH2,NI,NJ,IS,KE)
      IF(IC.NE.-1) GO TO 3
      DO 2 J=1,3
      F(J)=-F1(I,J)+FB(J)+FT(J)
      DO 2 K=1,3
2     LE(J,K)=-LE1(I,J,K)
      CALL DSTCHB(DM,AD1,AD2,AAD1,AAD2,LE,F,NL,NH2,NI,NJ,IS,KE)
3     CONTINUE
      RETURN
      END
 
      SUBROUTINE DSTCHB(DM,AD1,AD2,AAD1,AAD2,LE,F,NL,NH2,NI,NJ,IS,KE)
C-----This routine calculates interatomic distances involving
C-----atoms translated in equivalent positions
      CHARACTER*1 STR(38),STPE(38,50),AD1(6),AD2(6),
     1 STR1(38),AD3(6),AD4(6),CHR1,CHR2,SSS(9)
      CHARACTER*2 AAD1,AAD2,DLS2(500)
      INTEGER LE(3,3)
      DIMENSION F(3),X(3),H(3),D(3)
      COMMON/COOA/X1(3),X2(3),S1(3),S2(3)
     1      /GRP1/C(3),SC(3),A(3),SA(3)
     2      /INS4/CS(3),SN(3)
     3      /LBL4/STPE
     4      /LBL6/NPE,LH(50,3,3),FH(50,3)
     5      /NEW/IL(2,700)
     6      /NEW2/IA(3,2000)
     7      /NEW3/IT(4,3000)
     8      /INPOU/IN,IO
     9      /GRG1/DLS2
      DATA SSS/' ','x',',','+','y',',','+','z',' '/
      DO 1 I=1,3
      X(I)=F(I)
      DO 1 J=1,3
1     X(I)=X(I)+LE(I,J)*X2(J)
      DO 2 I=1,3
2     IF(ABS(X(I)-X2(I)).GT.1E-4)GO TO 3
      GO TO 7
3     DA=0.0
      DO 4 I=1,3
      D(I)=X1(I)-X(I)
      H(I)=D(I)*SC(I)
      D(I)=D(I)*C(I)
4     DA=DA+D(I)**2
      DA=DA+2*(D(1)*D(2)*CS(3)+D(1)*D(3)*CS(2)+D(2)*D(3)*CS(1))
20    IF(ABS(DA).LT.1E-8)THEN
      DA=0.0
      SDA=0.0
      GO TO 19
      ENDIF
      DA=SQRT(DA)
      IF(DM.LE.3.0) GO TO 5
      IF(DA.GT.DM) GO TO 7
      GO TO 6
5     IF(DA.GT.3.0) GO TO 7
6     IF(DA.GT.DM) GO TO 8
      CALL SGMD(D,H,S1,S2,DA,SDA)
19    CALL EQPDEC(LE,F,STR)
      NST=38
      CALL LABCOO(NST,STR,STR1)
      IF(STR1(1).EQ.'+')STR1(1)=' '
      DO 16  L=1,6
      AD3(L)=AD1(L)
16    AD4(L)=AD2(L)
      CHR1=AD3(1)
      CHR2=AD3(2)
      CALL LABLAT(CHR1,CHR2)
      AD3(2)=CHR2
      CHR1=AD4(1)
      CHR2=AD4(2)
      CALL LABLAT(CHR1,CHR2)
      AD4(2)=CHR2
      KD1=0
      IF(KE.LT.0.AND.(AAD1.EQ.'H '.OR.AAD2.EQ.'H '))KD1=1
      DO 23 I=1,9
      IF(STR1(I).NE.SSS(I))GO TO 18
23    CONTINUE
      GO TO 7
18    DO 21 I=1,4
      IF(AD3(I).NE.AD4(I))GO TO 22
21    CONTINUE
      IF(DA.LT.1E-2)GO TO 7
      IF(KE.GE.0)KD1=0
22    IF(KE.NE.0.AND.KD1.EQ.0) WRITE(IO,100)AD3,AD4,STR1,DA,SDA
100   FORMAT(1X,6A1,'...',6A1,1X,38A1,F6.4,2X,F6.4)
      IF(KD1.EQ.1) GO TO 8
      NL=NL+1
8     IF(DA.LT.1E-2.OR.DA.GT.3.0)GO TO 7
      IF(AAD1.NE.'H ') GO TO 7
      IF(AAD2.NE.'N '.AND.AAD2.NE.'O '.AND.AAD2.NE.'S '
     1 .AND.AAD2.NE.'SE'.AND.AAD2.NE.'F '.AND.AAD2.NE.'CL'
     2 .AND.AAD2.NE.'BR'.AND.AAD2.NE.'I ') GO TO 7
      CALL EQPDEC(LE,F,STR)
      NH2=NH2+1
      IA(1,NH2)=NI
      IA(2,NH2)=NJ
      IF(NPE.EQ.0) GO TO 14
      DO 13 I=1,NPE
      DO 12 K=1,38
12    IF(STPE(K,I).NE.STR(K)) GO TO 13
      IA(3,NH2)=I
      GO TO 7
13    CONTINUE
14    NPE =NPE+1
      IF(NPE.GT.50) GO TO 11
      IA(3,NH2)=NPE
      DO 9 K=1,38
9     STPE(K,NPE)=STR(K)
      DO 10 J=1,3
      FH(NPE,J)=F(J)
      DO 10 I=1,3
10    LH(NPE,I,J)=LE(I,J)
      GO TO 7
11    IS=1
7     RETURN
      END
 
      SUBROUTINE DECEQP(STR,LE,F)
C-----This routine decodes the equivalent positions
      CHARACTER*1 STR(38),COO(13)
      INTEGER LE(3,3)
      DIMENSION F(3)
      COMMON/INPOU/IN,IO
      DATA COO/'X','Y','Z',',','/','+','-','1','2','3','4','5','6'/
      DO 18 I=1,3
      F(I)=0.0
      DO 18 J=1,3
18    LE(I,J)=0
      DO 19 I=1,38
19    STR(I)=' '
      READ(IN,100)STR
100   FORMAT(38A1)
      NCS=38
      CALL MINUMA(NCS,STR)
C-----Elimination of redundant blanks
      DO 20 K=1,5
      DO 20 I=1,37
      IF(STR(I).EQ.' ')THEN
      DO 21 J=I,37
21    STR(J)=STR(J+1)
      ENDIF
20    CONTINUE
      N=0
      DO 1 I=1,37
      IF(STR(I).EQ.' '.AND.STR(I+1).EQ.' ')GO TO 2
      IF(STR(I).NE.COO(4))GO TO 1
      N=N+1
      IF(N.EQ.1)NA=I
      IF(N.EQ.2)NB=I
1     CONTINUE
2     DO 16 K=1,3
      GO TO (4,5,6),K
4     N1=1
      N2=NA-1
      GO TO 7
5     N1=NA+1
      N2=NB-1
      GO TO 7
6     N1=NB+1
      N2=20
7     KS=1
      KD=0
      DO 15 I=N1,N2
      IF(STR(I).EQ.' '.AND.STR(I+1).EQ.' ')GO TO 17
      IF(STR(I).EQ.' ')GO TO 15
      DO 8 J=1,13
      IF(STR(I).EQ.COO(J))GO TO 9
8     CONTINUE
      GO TO 15
9     IF(J.EQ.4)GO TO 15
      IF(J.EQ.7)KS=-1
      IF(J.EQ.5)KD=1
      IF(J.GT.3)GO TO 11
      DO 10 L=1,3
10    IF(K.EQ.L)LE(L,J)=1*KS
      KS=1
      GO TO 15
11    IF(J.LT.8)GO TO 15
      IF(KD.EQ.1)GO TO 13
      DO 12 L=1,3
12    IF(K.EQ.L)F(L)=(J-7)*KS
      KS=1
      GO TO 15
13    DO 14 L=1,3
      IF(K.EQ.L)F(L)=F(L)/(J-7)
14    CONTINUE
      KD=0
15    CONTINUE
16    CONTINUE
17    RETURN
      END
 
      SUBROUTINE EQPDEC(LE,F,STR)
C-----This routine encodes the matrix and the vector describing
C-----an equivalent position into an alphanumeric string
      CHARACTER*1 STR(38),COO(6)
      INTEGER NT(3),LE(3,3),LE1(3)
      DIMENSION F(3),F1(3)
      DATA COO/'X','Y','Z','1','2','3'/
      DO 12 I=1,38
12    STR(I)=' '
      STR(13)=','
      STR(26)=','
      DO 1 I=1,3
      NT(I)=F(I)
1     F1(I)=F(I)-NT(I)
      DO 8 I=1,3
      IF(I.EQ.1) N=0
      IF(I.EQ.2) N=13
      IF(I.EQ.3) N=26
      DO 2 J=1,3
      LE1(J)=LE(I,J)
      IF(LE1(J).LT.0)STR(2*J-1+N)='-'
      IF(LE1(J).GT.0)STR(2*J-1+N)='+'
      IF(IABS(LE1(J)).EQ.1)STR(2*J+N)=COO(J)
2     CONTINUE
      IF(ABS(F(I)).LT.1E-4) GO TO 8
      IF(ABS(F1(I)).LT.1E-4) GO TO 6
      IF(F(I).LT.0.)STR(7+N)='-'
      IF(F(I).LT.0.)STR(11+N)='-'
      IF(F(I).GT.0.)STR(7+N)='+'
      IF(F(I).GT.0.)STR(11+N)='+'
C40   IF(F(I).LE.0.0) GO TO 50
C     STR(7+N)='+'
C     STR(11+N)='+'
C50   STR(9+N)='/'
      STR(9+N)='/'
      IF(ABS(F1(I)).GT.0.6) GO TO 3
      STR(8+N)='1'
      IF(ABS(F1(I)).LT.0.2)STR(10+N)='6'
      IF(ABS(F1(I)).LT.0.3.AND.ABS(F1(I)).GT.0.2)STR(10+N)='4'
      IF(ABS(F1(I)).LT.0.4.AND.ABS(F1(I)).GT.0.3)STR(10+N)='3'
      IF(ABS(F1(I)).LT.0.6.AND.ABS(F1(I)).GT.0.4)STR(10+N)='2'
      GO TO 6
3     IF(ABS(F1(I)).GT.0.7) GO TO 4
      STR(8+N)='2'
      STR(10+N)='3'
      GO TO 6
4     IF(ABS(F1(I)).GT.0.8) GO TO 5
      STR(8+N)='3'
      STR(10+N)='4'
      GO TO 6
5     STR(8+N)='5'
      STR(10+N)='6'
6     IF(NT(I).EQ.0) GO TO 8
      DO 7 J=1,3
      IF(IABS(NT(I)).EQ.J.AND.NT(I).GT.0)STR(11+N)='+'
      IF(IABS(NT(I)).EQ.J.AND.NT(I).LT.0)STR(11+N)='-'
7     IF(IABS(NT(I)).EQ.J)STR(12+N)=COO(J+3)
8     CONTINUE
      IF(STR(12).EQ.' ') STR(11)=' '
      IF(STR(25).EQ.' ') STR(24)=' '
      IF(STR(38).EQ.' ') STR(37)=' '
      DO 11 K=1,4
      DO 10 I=1,37
      IF(STR(I).NE.' ') GO TO 10
      DO 9 J=I,37
9     STR(J)=STR(J+1)
      STR(38)=' '
10    CONTINUE
11    CONTINUE
      RETURN
      END
 
      SUBROUTINE HDRB(NH,NH2,RD,SGAR,CSAR,SNAR)
C-----This routine calculates the relevant parameters of
C-----hydrogen bonds
      CHARACTER*1 STPE(38,50),SDOL(6,500),STR(38),STR1(38),
     1 CHR1,CHR2,LBL(6,4)
      CHARACTER*2 KF(4),SDL2(500)
      DIMENSION XR(3,3),SXR(3,3),X1(3),X2(3),SX1(3),SX2(3),
     1 XO1(3),XO2(3),SXO1(3),X(3),DTI(8,500),DTC(3,500)
      COMMON/GRP1/C(3),SC(3),A(3),SA(3)
     1      /GRP3/VO(3,500),SO(3,500)
     2      /GRP4/SDOL
     3      /NEW1/XK(3),O(3,3)
     4      /INS4/CS(3),SN(3)
     5      /NEW/IL(2,700)
     6      /NEW2/IA(3,2000)
     7      /NEW3/IT(4,3000)
      COMMON/LBL4/STPE
     1      /LBL6/NPE,LH(50,3,3),FH(50,3)
     2      /COOR/V(3,500),S(3,500)
     3      /INPOU/IN,IO
     4      /GRG1/SDL2
      DATA KF/'H ','C ','N ','O '/
      WRITE(IO,100)
100   FORMAT(//' Possible hydrogen bonds'/' Donor-H',9X,
     1 'Donor...Acceptor',6X,'H...Acceptor',10X,'Donor-H...',
     2 '...Acceptor'/)
      NLH=0
      DO 33 I=1,3
      DO 33 J=1,500
33    DTC(I,J)=0.0
      DO 11 I=1,NH
      DO 11 J=1,NH2
      IF(IL(2,I).NE.IA(1,J))GO TO 11
      IF(SDL2(IL(1,I)).EQ.KF(1))GO TO 11
      D1=0.
      D2=0.
      D3=0.
      KDC=0
      DO 1 K=1,3
      XR(1,K)=VO(K,IL(1,I))
      XR(2,K)=VO(K,IL(2,I))
      SXR(1,K)=SO(K,IL(1,I))
1     SXR(2,K)=SO(K,IL(2,I))
      IF(IA(3,J).NE.0)GO TO 3
      DO 2 K=1,3
      X(K)=V(K,IA(2,J))
      XR(3,K)=VO(K,IA(2,J))
2     SXR(3,K)=SO(K,IA(2,J))
      GO TO 7
3     DO 4 L=1,3
      X(L)=FH(IA(3,J),L)
      DO 4 K=1,3
4     X(L)=X(L)+LH(IA(3,J),L,K)*V(K,IA(2,J))
      DO 5 K=1,3
      X1(K)=X(K)
5     SX1(K)=S(K,IA(2,J))
      CALL ORTHO(X1,SX1,XO1,SXO1,SGAR,CSAR,SNAR)
      DO 6 K=1,3
      XR(3,K)=XO1(K)
6     SXR(3,K)=SXO1(K)
7     DO 8 K=1,3
      X1(K)=V(K,IL(1,I))
      X2(K)=X(K)
      SX1(K)=S(K,IL(1,I))
      SX2(K)=S(K,IA(2,J))
      XO1(K)=XR(1,K)
8     XO2(K)=XR(3,K)
      CALL DSSG(X1,X2,SX1,SX2,XO1,XO2,KDC,D2,SD2)
      IF(KDC.EQ.1)GO TO 11
      DO 9 K=1,3
      X2(K)=V(K,IL(2,I))
      SX2(K)=S(K,IL(2,I))
9     XO2(K)=XR(2,K)
      CALL DSSG(X1,X2,SX1,SX2,XO1,XO2,KDC,D1,SD1)
      IF(KDC.EQ.1)GO TO 11
      DO 10 K=1,3
      X1(K)=X(K)
      SX1(K)=S(K,IA(2,J))
10    XO1(K)=XR(3,K)
      DO 24 K=1,3
      IF(ABS(XR(1,K)-XR(3,K)).GT.1E-4)GO TO 25
24    CONTINUE
      GO TO 11
25    CALL DSSG(X1,X2,SX1,SX2,XO1,XO2,KDC,D3,SD3)
      IF(KDC.EQ.1)GO TO 11
      CALL BNDAN(RD,XR,SXR,T1,SA1)
      IF(T1.LT.80.)GO TO 11
      NLH=NLH+1
      IT(1,NLH)=IL(1,I)
      IT(2,NLH)=IL(2,I)
      IT(3,NLH)=IA(2,J)
      IT(4,NLH)=IA(3,J)
      DTI(1,NLH)=D1
      DTI(2,NLH)=SD1
      DTI(3,NLH)=D2
      DTI(4,NLH)=SD2
      DTI(5,NLH)=D3
      DTI(6,NLH)=SD3
      DTI(7,NLH)=T1
      DTI(8,NLH)=SA1
      IF(SDL2(IT(1,NLH)).EQ.KF(2))GO TO 27
      IF(SDL2(IT(1,NLH)).EQ.KF(3))GO TO 28
      IF(SDL2(IT(1,NLH)).EQ.KF(4))GO TO 29
      GO TO 11
27    D13=1.080
      GO TO 30
28    D13=1.030
      GO TO 30
29    D13=0.938
30    KKD=1
      CALL NORMHB(XR,D13,D23,ANG)
      DTC(1,NLH)=D13
      DTC(2,NLH)=D23
      DTC(3,NLH)=ANG
11    CONTINUE
      IF(NLH.EQ.0)GO TO 26
23    CONTINUE
      DO 18 I=1,NPE
      DO 15 J=1,NLH
      IF(I.EQ.IT(4,J)) GO TO 18
15    CONTINUE
      DO 17 L=I,NPE
      DO 16 K=1,38
16    STPE(K,L)=STPE(K,L+1)
      DO 17 JJ=1,NLH
17    IF(IT(4,JJ).EQ.L+1) IT(4,JJ)=L
      NPE=NPE-1
      GO TO 23
18    CONTINUE
      NL1=NLH-1
      DO 21 I=1,NL1
      IP1=I+1
      DO 21 J=IP1,NLH
      IF(IT(4,I).LE.IT(4,J))GO TO 21
      DO 19 K=1,4
      IRS=IT(K,I)
      IT(K,I)=IT(K,J)
19    IT(K,J)=IRS
      DO 20 K=1,8
      ARS=DTI(K,I)
      DTI(K,I)=DTI(K,J)
20    DTI(K,J)=ARS
      DO 32 K=1,3
      ARS=DTC(K,I)
      DTC(K,I)=DTC(K,J)
32    DTC(K,J)=ARS
21    CONTINUE
      DO 22 I=1,NLH
      DO 37 K=1,3
      CHR1=SDOL(1,IT(K,I))
      CHR2=SDOL(2,IT(K,I))
      CALL LABLAT(CHR1,CHR2)
      LBL(1,K)=SDOL(1,IT(K,I))
      LBL(2,K)=CHR2
      LBL(3,K)=SDOL(3,IT(K,I))
      LBL(4,K)=SDOL(4,IT(K,I))
      LBL(5,K)=SDOL(5,IT(K,I))
37    LBL(6,K)=SDOL(6,IT(K,I))
      WRITE(IO,101)(LBL(L,1),L=1,6),(LBL(L,2),L=1,6),
     1 (LBL(L,1),L=1,6),(LBL(L,3),L=1,6),IT(4,I),
     2 (LBL(L,2),L=1,6),(LBL(L,3),L=1,6),IT(4,I),
     3 (LBL(L,1),L=1,6),(LBL(L,2),L=1,6),
     4 (LBL(L,3),L=1,6),IT(4,I)
101   FORMAT(1X,6A1,'-',6A1,3X,6A1,'...',6A1,'(',I2,')',3X,6A1,
     1 '...',6A1,'(',I2,')',3X,6A1,'-',6A1,'...',6A1,'(',I2,')')
      IF(DTC(1,I).EQ.0)GO TO 31
      WRITE(IO,106)(DTI(K,I),K=1,8),(DTC(L,I),L=1,3)
106   FORMAT(1X,F5.3,'(',F4.3,')',5X,F5.3,'(',F4.3,')',11X,F5.3,
     1 '(',F4.3,')',11X,F6.2,'(',F5.2,')',/,1X,F5.3,33X,F5.3,
     2 17X,F6.2,7X,'(**)',/)
      GO TO 22
31    WRITE(IO,107)(DTI(K,I),K=1,8)
107   FORMAT(1X,F5.3,'(',F4.3,')',5X,F5.3,'(',F4.3,')',11X,F5.3,
     1 '(',F4.3,')',11X,F6.2,'(',F5.2,')',/)
22    CONTINUE
26    CONTINUE
      WRITE(IO,102)NLH
102   FORMAT(' Number of possible hydrogen bonds',I4/)
      IF(NLH.EQ.0)GO TO 13
      IF(KKD.EQ.1)WRITE(IO,108)
108   FORMAT(1X,'(**) Values normalized following G.A.Jeffrey & ',
     1 'L.Lewis, Carbohydr.Res.'/6X,'(1978).60,179; R.Taylor, ',
     2 'O.Kennard, Acta Cryst.(1983).B39,133.'/)
      WRITE(IO,103)
103   FORMAT(/' Equivalent positions:')
      IF(IT(4,1).NE.0)GO TO 14
      WRITE(IO,105)
105   FORMAT(' ( 0)',4X,'x,y,z')
14    DO 12 I=1,NPE
      DO 36 K=1,38
36    STR(K)=STPE(K,I)
      NST=38
      CALL LABCOO(NST,STR,STR1)
      IF(STR1(1).EQ.'+')STR1(1)=' '
12    WRITE(IO,104)I,STR1
104   FORMAT(' (',I2,')',3X,38A1)
13    RETURN
      END
 
      SUBROUTINE DSSG(X1,X2,SX1,SX2,XO1,XO2,KDC,DA,SDA)
C-----This routine calculates an interatomic distance with s.u.
      DIMENSION X1(3),SX1(3),X2(3),SX2(3),XO1(3),XO2(3),
     1 D(3),H(3)
      COMMON/GRP1/C(3),SC(3),A(3),SA(3)
     1      /GRP3/VO(3,500),SO(3,500)
     2      /INS4/CS(3),SN(3)
     3      /COOR/V(3,500),S(3,500)
     4      /INPOU/IN,IO
      DA=0.
      KDC=0
      DO 1 K=1,3
      D(1)=XO1(K)-XO2(K)
      IF(ABS(D(1)).GT.1E-9)D(1)=D(1)**2
1     DA=DA+D(1)
      DA=SQRT(DA)
      IF(DA.LT.1E-6)GO TO 3
      IF(DA.GT.4.0)GO TO 3
      DO 2 K=1,3
      D(K)=X1(K)-X2(K)
      H(K)=D(K)*SC(K)
2     D(K)=D(K)*C(K)
      CALL SGMD(D,H,SX1,SX2,DA,SDA)
      GO TO 4
3     KDC=1
4     RETURN
      END
 
      SUBROUTINE NORMHB(XR,D13,D23,ANG)
C-----This routine normalizes a hydrogen bond
      DIMENSION XR(3,3),DDC(3),DD2(3),X3(3)
      RD=57.295779513
      D12=0.0
      DO 1 K=1,3
      DDC(K)=XR(2,K)-XR(1,K)
1     D12=D12+DDC(K)**2
      D12=SQRT(D12)
      D23=0.0
      DO 2 K=1,3
      DDC(K)=DDC(K)/D12
      X3(K)=DDC(K)*D13+XR(1,K)
      DD2(K)=X3(K)-XR(3,K)
2     D23=D23+DD2(K)**2
      D23=SQRT(D23)
      CSAN=0.0
      DO 3 K=1,3
      DD2(K)=DD2(K)/D23
3     CSAN=CSAN+DDC(K)*DD2(K)
      SNAN=SQRT(1.-CSAN**2)
      ANG=ATAN2(SNAN,CSAN)*RD
      RETURN
      END
 
      SUBROUTINE SGMD(D,H,S1,S2,DA,SDA)
C-----This routine calculates the s.u. of an interatomic distance
      DIMENSION P(3),T(3),D(3),H(3),S1(3),S2(3)
      COMMON/GRP1/C(3),SC(3),A(3),SA(3)
     1      /INS4/CS(3),SN(3)
     2      /INPOU/IN,IO
 
      IF(ABS(DA).LT.1E-6)THEN
      WRITE(IO,'(''WARNING: There is something wrong with the '',
     1 ''input data'')')
      DA=1.0
      ENDIF
 
      DO 1 I=1,3
1     P(I)=H(I)**2+C(I)**2*(S1(I)**2+S2(I)**2)
      H(1)=D(1)+D(2)*CS(3)+D(3)*CS(2)
      H(2)=D(2)+D(3)*CS(1)+D(1)*CS(3)
      H(3)=D(3)+D(1)*CS(2)+D(2)*CS(1)
      T(1)=D(1)*D(2)*SN(3)*SA(3)
      T(2)=D(2)*D(3)*SN(1)*SA(1)
      T(3)=D(3)*D(1)*SN(2)*SA(2)
      SDA=0.0
      DO 2 I=1,3
2     SDA=SDA+H(I)**2*P(I)+T(I)**2
      SDA=SQRT(SDA)/DA
      RETURN
      END
 
      SUBROUTINE SYMMOL(NN,NI,NNKI,KE,BRV)
C-----This routine compares the coordinates of two sets of atoms
C-----to see if the sets can be considered significantly different
      CHARACTER*1 SDOL(6,500),SBL(6,500),MINUS(2),LB3(100,6),BRV,
     1 LB4(100,6),STR(38),STR1(38),STPE(38,50)
      DIMENSION VV(3,500),SV(3,500),VVO(3,500),SSO(3,500),CHI2(100),
     1 X(3),B(2,3),R(2,3),SB(2,3),SR(2,3),T1(3),ST(3,4),SN(3),TT(3),
     2 VA(3,500),VN(3,500),RT(3,3),T(3),SDM(3,500),RT1(3,3),RTT(3,3),
     3 P1(3,100),P2(3,100),PS1(3,100),PS2(3,100),SET3(100,3),
     4 SET4(100,3),SET5(100,3),F1(24,3),FB(3),F(3),B2(3,3),B1(4,3),
     5 SSET3(100,3),SSET4(100,3)
      INTEGER LE1(24,3,3),LE(3,3)
      DOUBLE PRECISION AM,S1,ST
      EQUIVALENCE (P1(1,1),VVO(1,1)),(P2(1,1),VVO(1,101)),
     1 (PS1(1,1),SV(1,1)),(PS2(1,1),SV(1,101))
      COMMON/LBL7/AM(10)
     1      /LBL5/S1(4)
     2      /NEW1/XK(3),O(3,3)
     3      /GRP4/SDOL
     4      /GRP3/VO(3,500),SO(3,500)
     5      /COOR/V(3,500),S(3,500)
     6      /LBL3/CHI2
     7      /INPOU/IN,IO
     8      /LBLS/LB3,LB4
      COMMON/EDAT/IC,NE
     1      /LBL4/STPE
     2      /EQVP/LE1,F1,FB
     3      /BRAV/KB,B2
      KR=1
      IF(KE.EQ.1.OR.NI.GT.1)GO TO 53
      READ(IN,*)N
      IF(N.GT.1)KR=0
      IF(KR.EQ.0)GO TO 51
      BACKSPACE(IN)
      KKR=0
      CALL INTERC(N,DM,NL,BRV,NH2,IS,KKR,KE)
53    READ(IN,*)N
51    IF(N.LT.200) GO TO 4
      WRITE(IO,102)N
102   FORMAT(/' The number of atoms to consider for comparison:',
     1 I3,', is too large. Please, check your input data.'/)
      GO TO 47
4     DO 20 I=1,3
      B1(1,I)=0.0
      DO 20 J=1,3
20    B1(I+1,J)=B2(I,J)
      READ(IN,'(72A1)')((SBL(L,I),L=1,6),I=1,N)
      DO 7 J=1,N
      MINUS(1)=SBL(1,J)
      MINUS(2)=SBL(2,J)
      NCS=2
      CALL MINUMA(NCS,MINUS)
      SBL(1,J)=MINUS(1)
7     SBL(2,J)=MINUS(2)
      IF(MOD(N,2).NE.0) GO TO 38
      DO 3 I=1,N
      DO 2 J=1,NN
      DO 6 L=1,6
      IF(SBL(L,I).NE.SDOL(L,J)) GO TO 2
6     CONTINUE
      DO 1 K=1,3
      VV(K,I)=V(K,J)
      SV(K,I)=S(K,J)
      VVO(K,I)=VO(K,J)
1     SSO(K,I)=SO(K,J)
      GO TO 3
2     CONTINUE
      WRITE(IO,101)(SBL(L,I),L=1,6)
101   FORMAT(/' Atom ',6A1,' doesn''t exist in your set. Please, ',
     1 'check your input data.'/)
      GO TO 47
3     CONTINUE
      WRITE(IO,103)NI,NI
103   FORMAT(/15X,'Set',I2,17X,'Set',I2,'''')
      N1=N/2
      DO 5 I=1,N1
5     WRITE(IO,104)(SBL(L,I),L=1,6),(SBL(L,N1+I),L=1,6)
104   FORMAT(15X,6A1,16X,6A1)
C-----Look for symmetry relating the two sets
      DO 21 II=1,KB+1
      DO 24 KK=1,3
24    FB(KK)=B1(II,KK)
      DO 49 I=1,N1
      DO 48 K=1,3
      LB3(I,K)=SBL(K,I)
      LB4(I,K)=SBL(K,N1+I)
      SET3(I,K)=VV(K,I)
      SET4(I,K)=VV(K,N1+I)
      SSET3(I,K)=SV(K,I)
48    SSET4(I,K)=SV(K,N1+I)
      LB3(I,4)=SBL(4,I)
      LB4(I,4)=SBL(4,N1+I)
      LB3(I,5)=SBL(5,I)
      LB4(I,5)=SBL(5,N1+I)
      LB3(I,6)=SBL(6,I)
49    LB4(I,6)=SBL(6,N1+I)
      IF(KR.EQ.0)THEN
      CALL AVERG(N1,SET3,SET4,SSET3,SSET4)
      IC=1
      ELSE
      DO 11 I=1,NE
      DO 8 J=1,3
      F(J)=F1(I,J)+FB(J)
      DO 8 K=1,3
8     LE(J,K)=LE1(I,J,K)
      DO 10 J=1,N1
      DO 9 K=1,3
      X(K)=F(K)
      DO 9 L=1,3
9     X(K)=X(K)+LE(K,L)*SET4(J,L)
      DO 10 K=1,3
10    SET5(J,K)=X(K)
      CALL EQPDEC(LE,F,STR)
      NST=38
      CALL LABCOO(NST,STR,STR1)
      IF(STR1(1).EQ.'+')STR1(1)=' '
      WRITE(IO,105)NI,NI,STR1
105   FORMAT(/60('=')/' Set ',I2,' in general position, set ',I2,
     1 ''' in ',38A1)
11    CALL AVERG(N1,SET3,SET5,SSET3,SSET4)
      ENDIF
      IF(IC.EQ.-1)THEN
      DO 19 I=1,NE
      DO 16 J=1,3
      F(J)=-F1(I,J)+FB(J)
      DO 16 K=1,3
16    LE(J,K)=-LE1(I,J,K)
      DO 18 J=1,N1
      DO 17 K=1,3
      X(K)=F(K)
      DO 17 L=1,3
17    X(K)=X(K)+LE(K,L)*SET4(J,L)
      DO 18 K=1,3
18    SET5(J,K)=X(K)
      CALL EQPDEC(LE,F,STR)
      NST=38
      CALL LABCOO(NST,STR,STR1)
      IF(STR1(1).EQ.'+')STR1(1)=' '
      WRITE(IO,105)NI,NI,STR1
19    CALL AVERG(N1,SET3,SET5,SSET3,SSET4)
      ENDIF
21    CONTINUE
      IF(NNKI.LT.0)GO TO 47
C-----Calculation of the coordinates of the centroids
      DO 12 K=1,2
      N1=N/2*(K-1)+1
      N2=N/2*K
      DO 12 I=1,3
      B(K,I)=0.
      R(K,I)=0.
      SB(K,I)=0.
      SR(K,I)=0.
      DO 12 J=N1,N2
      B(K,I)=B(K,I)+VV(I,J)
      R(K,I)=R(K,I)+VVO(I,J)
      SB(K,I)=SB(K,I)+SV(I,J)**2
12    SR(K,I)=SR(K,I)+SSO(I,J)**2
      DO 13 K=1,2
      DO 13 I=1,3
      B(K,I)=B(K,I)*2./N
      R(K,I)=R(K,I)*2./N
      SB(K,I)=SQRT(SB(K,I))
13    SR(K,I)=SQRT(SR(K,I))
      WRITE(IO,110)
110   FORMAT(//' Coordinates of the centroids of the two sets',
     1 ' referred to the'/' crystallographic axes and to',
     2 ' orthogonal axes')
      DO 14 K=1,2
      IF(K.EQ.1)WRITE(IO,108)NI
      IF(K.EQ.2)WRITE(IO,109)NI
108   FORMAT(/7H SET N.,I2)
109   FORMAT(/7H SET N.,I2,1H')
14    WRITE(IO,111)(B(K,I),SB(K,I),R(K,I),SR(K,I),I=1,3)
111   FORMAT(' X/a =',F9.5,'(',F7.5,')',12X,'X =',
     1 F8.4,'(',F6.4,')'/' Y/b =',F9.5,'(',F7.5,')',12X,'Y =',
     2 F8.4,'(',F6.4,')'/' Z/c =',F9.5,'(',F7.5,')',12X,'Z =',
     3 F8.4,'(',F6.4,')')
      KK=0
15    CONTINUE
      DO 31 L=1,10
31    AM(L)=0.
      DO 32 L=1,3
      DO 32 K=1,4
32    ST(L,K)=0.
      N2=N/2
C-----Calculation of the rotation matrix and translation vector
      IF(KK.EQ.0)N2=0
      N1=N2+1
      N3=N/2+N2
      DO 40 J=N1,N3
      IF(KK.EQ.0) K=J+N/2
      IF(KK.EQ.1) K=J-N/2
      DO 39 I=1,3
      X(I)=VV(I,J)
      AM(I)=AM(I)+X(1)*X(I)
      DO 39 L=1,3
39    ST(I,L)=ST(I,L)+VV(L,J)*VV(I,K)
      AM(4)=AM(4)+X(1)
      AM(5)=AM(5)+X(2)*X(2)
      AM(6)=AM(6)+X(2)*X(3)
      AM(7)=AM(7)+X(2)
      AM(8)=AM(8)+X(3)*X(3)
      AM(9)=AM(9)+X(3)
      DO 40 L=1,3
40    ST(L,4)=ST(L,4)+VV(L,K)
      AM(10)=N/2
      CALL INMTS4
      DO 43 K=1,3
      DO 41 I=1,4
41    S1(I)=ST(K,I)
      CALL PMSV4
      DO 42 L=1,3
      IF(KK.EQ.0)RT(K,L)=S1(L)
      IF(KK.EQ.1)RT1(K,L)=S1(L)
42    CONTINUE
      IF(KK.EQ.0)T(K)=S1(4)
      IF(KK.EQ.1)T1(K)=S1(4)
43    CONTINUE
C-----Print the rotation matrices and translation vectors
      WRITE(IO,115)
115   FORMAT(//' Least-squares rotation matrix & translation ',
     1 'vector')
      IF(KK.EQ.0)WRITE(IO,120)NI,NI
      IF(KK.EQ.1)WRITE(IO,121)NI,NI
120   FORMAT(' which bring set ',I2,'''',' into set ',I2/)
121   FORMAT(' which bring set',I2,' into set ',I2,''''/)
      WRITE(IO,122)
122   FORMAT(12X,'Rotation matrix',17X,'Transl.vector'/)
      IF(KK.EQ.0)THEN
      WRITE(IO,116)((RT(I,L),L=1,3),T(I),I=1,3)
      CALL NORMAT(RT,RTT,T,TT)
      WRITE(IO,127)((RTT(I,J),J=1,3),TT(I),I=1,3)
      ELSEIF(KK.EQ.1)THEN
      WRITE(IO,116)((RT1(I,L),L=1,3),T1(I),I=1,3)
      CALL NORMAT(RT1,RTT,T1,TT)
      WRITE(IO,127)((RTT(I,J),J=1,3),TT(I),I=1,3)
      ENDIF
116   FORMAT(1X,3F11.5,8X,F12.5)
127   FORMAT(/6X,'Normalized rotation matrix',10X,'1/2 Transl.vector'
     1 //(3(1X,3F11.5,8X,F12.5/)))
C-----Calculation of transformed fractional coordinates
      IF(KK.EQ.0)WRITE(IO,124)NI
      IF(KK.EQ.1)WRITE(IO,125)NI
124   FORMAT(//' Corrected fractional coordinates for set',I3,'''')
125   FORMAT(//' Corrected fractional coordinates for set',I3)
      WRITE(IO,117)
117   FORMAT(' (The differences with the previous ones are given ',
     2 'in parentheses)'//' Atom',11X,'X/a',17X,'Y/b',17X,'Z/c')
      DO 46 J=N1,N3
      DO 45 I=1,3
      IF(KK.EQ.0)VN(I,J)=RT(I,1)*VV(1,J)+RT(I,2)*VV(2,J)
     1 +RT(I,3)*VV(3,J)+T(I)
      IF(KK.EQ.1)VN(I,J)=RT1(I,1)*VV(1,J)+RT1(I,2)*VV(2,J)
     1 +RT1(I,3)*VV(3,J)+T1(I)
      IF(KK.EQ.0)VA(I,J)=(VN(I,J)+VV(I,J+N/2))/2.
      IF(KK.EQ.1)VA(I,J)=(VN(I,J)+VV(I,J-N/2))/2.
      SDM(I,J)=VN(I,J)-VA(I,J)
      IF(KK.EQ.0)SN(I)=VN(I,J)-VV(I,J+N/2)
      IF(KK.EQ.1)SN(I)=VN(I,J)-VV(I,J-N/2)
45    CONTINUE
      IF(KK.EQ.0)WRITE(IO,118)(SBL(L,J+N/2),L=1,6),
     1 (VN(I,J),SN(I),I=1,3)
      IF(KK.EQ.1)WRITE(IO,118)(SBL(L,J-N/2),L=1,6),
     1 (VN(I,J),SN(I),I=1,3)
46    CONTINUE
118   FORMAT(1X,6A1,1X,3(F10.5,'(',F8.5,')'))
      WRITE(IO,119)
119   FORMAT(//' Averaged fractional coordinates'/
     1 ' (The differences with the previous values are given ',
     2 'in parentheses)'//' Atom',11X,'X/a',17X,'Y/b',17X,'Z/c')
      DO 37 J=N1,N3
      IF(KK.EQ.0)WRITE(IO,118)(SBL(L,J+N/2),L=1,6),
     1 (VA(I,J),SDM(I,J),I=1,3)
      IF(KK.EQ.1)WRITE(IO,118)(SBL(L,J-N/2),L=1,6),
     1 (VA(I,J),SDM(I,J),I=1,3)
37    CONTINUE
      KK=KK+1
      IF(KK.EQ.1) GO TO 15
C-----Calculation of internal orthogonal coordinates
      DO 22 I=1,3
22    X(I)=RT(I,1)*B(1,1)+RT(I,2)*B(1,2)+RT(I,3)*B(1,3)+T(I)
      DO 23 J=1,N2
      VVO(1,J)=O(1,1)*VN(1,J)+O(1,2)*VN(2,J)+O(1,3)*VN(3,J)
      VVO(2,J)=O(2,2)*VN(2,J)+O(2,3)*VN(3,J)
23    VVO(3,J)=O(3,3)*VN(3,J)
      R(1,1)=O(1,1)*X(1)+O(1,2)*X(2)+O(1,3)*X(3)
      R(1,2)=O(2,2)*X(2)+O(2,3)*X(3)
      R(1,3)=O(3,3)*X(3)
      WRITE(IO,112)
112   FORMAT(//' Orthogonal internal coordinates of the two ',
     1 'sets'//' Atom',13X,'X''',18X,'Y''',18X,'Z''')
      N2=N/2
      DO 33 I=1,3
33    XK(I)=0.
      DO 36 J=1,N2
      K=N2+J
      DO 35 I=1,3
      VVO(I,J)=VVO(I,J)-R(1,I)
      VVO(I,K)=VVO(I,K)-R(2,I)
C     SV(I,J)=SQRT(SSO(I,J)**2+SR(1,I)**2)
C     SV(I,K)=SQRT(SSO(I,K)**2+SR(2,I)**2)
      SV(I,J)=SSO(I,J)
      SV(I,K)=SSO(I,K)
      P1(I,J)=VVO(I,J)
      P2(I,J)=VVO(I,K)
      PS1(I,J)=SV(I,J)
      PS2(I,J)=SV(I,K)
      SN(I)=VVO(I,J)-VVO(I,K)
      X(I)=ABS(VVO(I,J)-VVO(I,K))/SQRT(SV(I,J)**2+SV(I,K)**2)
35    XK(I)=XK(I)+X(I)**2
36    WRITE(IO,113)(SBL(L,J),L=1,6),(VVO(I,J),SV(I,J),I=1,3),
     1 (SBL(L,K),L=1,6),(VVO(I,K),SV(I,K),I=1,3),
     2 (SN(I),I=1,3),(X(I),I=1,3)
113   FORMAT(2(1X,6A1,1X,3(F10.5,'(',F8.5,')')/),
     1 ' D',8X,F11.4,2(9X,F11.4)/' D/S',6X,F11.4,2(9X,F11.4))
      WRITE(IO,114)(XK(I),I=1,3)
114   FORMAT(//10X,'Sum((d/s)**2)'/' X''',3X,F15.4/
     1 ' Y''',3X,F15.4/' Z''',3X,F15.4)
      IF(N2.GT.100) GO TO 47
      WRITE(IO,126)N2,CHI2(N2)
126   FORMAT(/' Chi-squared at 95% for ',I3,' degrees of ',
     1 'freedom: ',F5.2)
      CALL HLFNOR(N2,P1,P2,PS1,PS2)
      GO TO 47
38    WRITE(IO,123)
123   FORMAT(/' The number of atoms in the two sets is not ',
     1 'equal.'/' Please, check the input data'/ )
47    RETURN
      END
 
      SUBROUTINE NORMAT(A,A1,T,T1)
C-----Normalize a 3x3 matrix and calculate 1/2(3-vector)
      DIMENSION A(3,3),X(3),A1(3,3),T(3),T1(3)
      DO 2 I=1,3
      DO 1 J=1,3
1     X(J)=A(I,J)
      CALL NORM(X)
      DO 2 J=1,3
      A1(I,J)=X(J)
2     T1(I)=T(I)*0.50
      RETURN
      END
 
      SUBROUTINE AVERG(NN,SET3,SET4,SSET3,SSET4)
C-----Coordinate differences and half-sums are calculated
C-----together with weighted averages and s.u.'s
      CHARACTER*1 LB3(100,6),LB4(100,6)
      DIMENSION SET3(100,3),SET4(100,3),AM(2,3),SM(2,3),AA(3),SS(3),
     1 SS2(3),SSET3(100,3),SSET4(100,3),SW(3)
      COMMON/INPOU/IN,IO
     1      /LBLS/LB3,LB4
     3      /MTRX/AM,SM
      KDC=0
1     IF(KDC.EQ.0) THEN
      WRITE(IO,100)
100   FORMAT(/' Co-ordinate differences'/)
      WRITE(IO,101)
101   FORMAT(' Atom1   Atom2',8X,'x1-x2',8X,'y1-y2',8X,'z1-z2')
      ELSE
      WRITE(IO,102)
102   FORMAT(/' Co-ordinate half-sums'/)
      WRITE(IO,103)
103   FORMAT(' Atom1   Atom2',6X,'(x1+x2)/2',4X,'(y1+y2)/2',4X,
     1 '(z1+z2)/2')
      ENDIF
      DO 2 K=1,3
      SS(K)=0.
      SW(K)=0.
2     SS2(K)=0.
      DO 4 I=1,NN
      DO 3 K=1,3
      IF(SSET3(I,K).LT.1E-5)SSET3(I,K)=1E-5
      IF(SSET4(I,K).LT.1E-5)SSET4(I,K)=1E-5
      W1=1./(SSET3(I,K)**2+SSET4(I,K)**2)
      IF(KDC.EQ.0) AA(K)=SET3(I,K)-SET4(I,K)
      IF(KDC.EQ.1) AA(K)=(SET3(I,K)+SET4(I,K))/2
      SS(K)=SS(K)+AA(K)*W1
      SW(K)=SW(K)+W1
3     SS2(K)=SS2(K)+W1*AA(K)**2
      WRITE(IO,110)(LB3(I,L),L=1,6),(LB4(I,L),L=1,6),AA
110   FORMAT(1X,6A1,2X,6A1,3(4X,F9.5))
4     CONTINUE
      DO 5 K=1,3
      AA(K)=SS(K)/SW(K)
5     SS2(K)=SQRT(ABS(SS2(K)/SW(K)-AA(K)**2))
      IF(KDC.EQ.0) THEN
      DO 6 K=1,3
      AM(1,K)=AA(K)
6     SM(1,K)=SS2(K)
      ELSE
      DO 7 K=1,3
      AM(2,K)=AA(K)
7     SM(2,K)=SS2(K)
      ENDIF
      WRITE(IO,104)AA,SS2
104   FORMAT(1X,53('-')/' Average ',10X,3(F9.5,4X)/' s.u.',14X,
     1 3(F9.5,4X))
      IF(KDC.EQ.1) GO TO 8
      KDC=1
      GO TO 1
8     CALL FINDSYM
      RETURN
      END
 
      SUBROUTINE FINDSYM
C-----This subroutine looks for pseudo symmetry elements
      CHARACTER*1 AA(6)
      DIMENSION AM(2,3),SM(2,3),RM(6),SG(6),NO(6)
      COMMON/INPOU/IN,IO
     1      /MTRX/AM,SM
      DATA AA/'x','y','z','x','y','z'/
      DO 1 I=1,3
C-----Set up matrices
      RM(I)=AM(1,I)
      SG(I)=SM(1,I)
1     NO(I)=I
      DO 2 I=4,6
      RM(I)=AM(2,I-3)
      SG(I)=SM(2,I-3)
2     NO(I)=I
C-----Ordering according to increasing s.u.'s
      DO 3 K=1,5
      DO 3 I=1,5
      IF(SG(I).LT.SG(I+1)) GO TO 3
      RSV=SG(I)
      SG(I)=SG(I+1)
      SG(I+1)=RSV
      RSV=RM(I)
      RM(I)=RM(I+1)
      RM(I+1)=RSV
      NSV=NO(I)
      NO(I)=NO(I+1)
      NO(I+1)=NSV
3     CONTINUE
      IF(SG(3).GT.0.05) GO TO 7
C-----Look for symmetry center
      IF(NO(1).GT.3.AND.NO(2).GT.3.AND.NO(3).GT.3) THEN
      DO 5 K=1,2
      DO 5 I=1,2
      IF(NO(I).LT.NO(I+1)) GO TO 5
      NSV=NO(I)
      NO(I)=NO(I+1)
      NO(I+1)=NSV
      RSV=RM(I)
      RM(I)=RM(I+1)
      RM(I+1)=RSV
      RSV=SG(I)
      SG(I)=SG(I+1)
      SG(I+1)=RSV
5     CONTINUE
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
103   FORMAT(/1X,39('*')/' There is no significant interpretation.'/
     1 ' Look carefully through the results.'/1X,39('*'))
      GO TO 8
      ELSE
      WRITE(IO,100)AA(NO(1)),RM(1),SG(1),AA(NO(2)),RM(2),SG(2),
     1 AA(NO(3)),RM(3),SG(3)
100   FORMAT(/' There is a pseudo CENTER OF SYMMETRY at:'/20X,A1,
     1 ' =',F7.4,'(',F5.3,')'/20X,A1,' =',F7.4,'(',F5.3,')'/20X,A1,
     2 ' =',F7.4,'(',F5.3,')')
      ENDIF
C-----Look for translations only
      ELSEIF(NO(1).LT.4.AND.NO(2).LT.4.AND.NO(3).LT.4) THEN
      DO 6 K=1,2
      DO 6 I=1,2
      IF(NO(I).LT.NO(I+1)) GO TO 6
      NSV=NO(I)
      NO(I)=NO(I+1)
      NO(I+1)=NSV
      RSV=RM(I)
      RM(I)=RM(I+1)
      RM(I+1)=RSV
      RSV=SG(I)
      SG(I)=SG(I+1)
      SG(I+1)=RSV
6     CONTINUE
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
      GO TO 8
      ELSE
      WRITE(IO,104)RM(1),SG(1),AA(NO(1)),RM(2),SG(2),AA(NO(2)),
     1 RM(3),SG(3),AA(NO(3))
104   FORMAT(/' There are only pseudo TRANSLATIONS:'/15X,F7.4,'(',F5.3,
     1 ') along ',A1/15X,F7.4,'(',F5.3,') along ',A1/15X,F7.4,'(',
     2 F5.3,') along ',A1)
      ENDIF
C-----Look for two-fold axis
      ELSEIF(NO(1).LT.4.AND.NO(2).GT.3.AND.NO(3).GT.3) THEN
      IF(NO(3).LT.NO(2))THEN
      IR=NO(2)
      NO(2)=NO(3)
      NO(3)=IR
      RSV=RM(2)
      RM(2)=RM(3)
      RM(3)=RSV
      RSV=SG(2)
      SG(2)=SG(3)
      SG(3)=RSV
      ENDIF
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
      GO TO 8
      ELSE
      WRITE(IO,101)AA(NO(2)),RM(2),SG(2),AA(NO(3)),RM(3),SG(3),
     1 AA(NO(1)),RM(1),SG(1)
101   FORMAT(/' There is a pseudo TWO-FOLD AXIS at ',A1,' =',F7.4,'(',
     1 F5.3,') and'/1X,A1,' =',F7.4,'(',F5.3,') parallel to ',A1,
     2 ' with translation ',F7.4,'(',F5.3,')')
      ENDIF
      ELSEIF(NO(1).GT.3.AND.NO(2).LT.4.AND.NO(3).GT.3) THEN
      IF(NO(3).LT.NO(1))THEN
      IR=NO(1)
      NO(1)=NO(3)
      NO(3)=IR
      RSV=RM(1)
      RM(1)=RM(3)
      RM(3)=RSV
      RSV=SG(1)
      SG(1)=SG(3)
      SG(3)=RSV
      ENDIF
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
      GO TO 8
      ELSE
      WRITE(IO,101)AA(NO(1)),RM(1),SG(1),AA(NO(3)),RM(3),SG(3),
     1 AA(NO(2)),RM(2),SG(2)
      ENDIF
      ELSEIF(NO(1).GT.3.AND.NO(2).GT.3.AND.NO(3).LT.4) THEN
      IF(NO(2).LT.NO(1))THEN
      IR=NO(1)
      NO(1)=NO(2)
      NO(2)=IR
      RSV=RM(1)
      RM(1)=RM(2)
      RM(2)=RSV
      RSV=SG(1)
      SG(1)=SG(2)
      SG(2)=RSV
      ENDIF
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
      GO TO 8
      ELSE
      WRITE(IO,101)AA(NO(1)),RM(1),SG(1),AA(NO(2)),RM(2),SG(2),
     1 AA(NO(3)),RM(3),SG(3)
      ENDIF
C-----Look for symmetry plane
      ELSEIF(NO(1).LT.4.AND.NO(2).LT.4.AND.NO(3).GT.3) THEN
      IF(NO(2).LT.NO(1))THEN
      IR=NO(1)
      NO(1)=NO(2)
      NO(2)=IR
      RSV=RM(1)
      RM(1)=RM(2)
      RM(2)=RSV
      RSV=SG(1)
      SG(1)=SG(2)
      SG(2)=RSV
      ENDIF
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
      GO TO 8
      ELSE
      WRITE(IO,102)AA(NO(3)),RM(3),SG(3),AA(NO(1)),AA(NO(2)),
     1 AA(NO(1)),RM(1),SG(1),AA(NO(2)),RM(2),SG(2)
102   FORMAT(/' There is a pseudo SYMMETRY PLANE at ',A1,' =',F7.4,'(',
     1 F5.3,') parallel'/' to ',A1,',',A1,' with translations: ',
     2 A1,' =',F7.4,'(',F5.3,') and ',A1,' =',F7.4,'(',F5.3,')')
      ENDIF
      ELSEIF(NO(1).LT.4.AND.NO(2).GT.3.AND.NO(3).LT.4) THEN
      IF(NO(3).LT.NO(1))THEN
      IR=NO(1)
      NO(1)=NO(3)
      NO(3)=IR
      RSV=RM(1)
      RM(1)=RM(3)
      RM(3)=RSV
      RSV=SG(1)
      SG(1)=SG(3)
      SG(3)=RSV
      ENDIF
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
      GO TO 8
      ELSE
      WRITE(IO,102)AA(NO(2)),RM(2),SG(2),AA(NO(1)),AA(NO(3)),
     1 AA(NO(1)),RM(1),SG(1),AA(NO(3)),RM(3),SG(3)
      ENDIF
      ELSEIF(NO(1).GT.3.AND.NO(2).LT.4.AND.NO(3).LT.4) THEN
      IF(NO(3).LT.NO(2))THEN
      IR=NO(2)
      NO(2)=NO(3)
      NO(3)=IR
      RSV=RM(2)
      RM(2)=RM(3)
      RM(3)=RSV
      RSV=SG(2)
      SG(2)=SG(3)
      SG(3)=RSV
      ENDIF
      IF(AA(NO(1)).EQ.AA(NO(2)).OR.AA(NO(1)).EQ.AA(NO(3)).OR.
     1 AA(NO(2)).EQ.AA(NO(3)))THEN
      WRITE(IO,103)
      GO TO 8
      ELSE
      WRITE(IO,102)AA(NO(1)),RM(1),SG(1),AA(NO(2)),AA(NO(3)),
     1 AA(NO(2)),RM(2),SG(2),AA(NO(3)),RM(3),SG(3)
      ENDIF
      ENDIF
      GO TO 8
7     WRITE(IO,'(/1X,75(''*'')/'' There is no direct indication '',
     1 ''of a symmetry operation between the two sets''/
     2 '' Look carefully through the results.''/1X,75(''*'')/)')
8     RETURN
      END
 
      SUBROUTINE INMTS4
C-----This routine inverts a symmetric 4x4 matrix
      DOUBLE PRECISION A(10),D,P1,P2,X,C,Q1,Q2,Q4,R1,R2,R3,X1
      COMMON/LBL7/A
      D=A(1)*A(5)-A(2)**2
      P1=A(2)*A(6)-A(3)*A(5)
      P2=A(2)*A(3)-A(1)*A(6)
      X=A(8)+(P1*A(3)+P2*A(6))/D
      C=1./(X*D)
      Q1=(C*P1**2+A(5))/D
      Q2=(C*P1*P2-A(2))/D
      Q4=(C*P2**2+A(1))/D
      R1=Q1*A(4)+Q2*A(7)+C*P1*A(9)
      R2=Q2*A(4)+Q4*A(7)+C*P2*A(9)
      R3=C*(P1*A(4)+P2*A(7))+A(9)/X
      X1=A(10)-(R1*A(4)+R2*A(7)+R3*A(9))
      A(4)=-R1/X1
      A(1)=Q1-A(4)*R1
      A(2)=Q2-A(4)*R2
      A(3)=C*P1-A(4)*R3
      A(7)=-R2/X1
      A(5)=Q4-A(7)*R2
      A(6)=C*P2-A(7)*R3
      A(9)=-R3/X1
      A(8)=1/X-A(9)*R3
      A(10)=1./X1
      RETURN
      END
 
      SUBROUTINE PMSV4
C-----This routine calculates the product of a symmetric 4x4
C-----matrix with a vector
      DOUBLE PRECISION B(4),E(4),A(10)
      COMMON/LBL7/A/LBL5/B
      E(1)=A(1)*B(1)+A(2)*B(2)+A(3)*B(3)+A(4)*B(4)
      E(2)=A(2)*B(1)+A(5)*B(2)+A(6)*B(3)+A(7)*B(4)
      E(3)=A(3)*B(1)+A(6)*B(2)+A(8)*B(3)+A(9)*B(4)
      E(4)=A(4)*B(1)+A(7)*B(2)+A(9)*B(3)+A(10)*B(4)
      DO 1 I=1,4
1     B(I)=E(I)
      RETURN
      END
 
      SUBROUTINE HLFNOR(N,P1,P2,PS1,PS2)
C-----Calculates the half-normal probability plots for the two
C-----sets of coordinates and for all the interatomic distances
C-----less than 4.65 A
      DIMENSION P1(3,200),P2(3,200),PS1(3,200),PS2(3,200),D(3),SD(3),
     1 PA(500),PB(500),PSA(500),PSB(500)
      COMMON/INPOU/IN,IO
      WRITE(IO,100)
100   FORMAT(/' Comparison of the two sets by half-normal probability',
     1 ' plots'/' S.C. Abrahams & E.T. Keve (1971). Acta Cryst., A27,',
     2 ' 157')
C-----Comparison of coordinates
      NP=0
      DO 4 I=1,N
      DO 4 J=1,3
      NP=NP+1
      PA(NP)=P1(J,I)
      PB(NP)=P2(J,I)
      IF(PS1(J,I).EQ.0.0.OR.PS2(J,I).EQ.0.0)THEN
      NP=NP-1
      GO TO 4
      ELSE
      PSA(NP)=PS1(J,I)
      PSB(NP)=PS2(J,I)
      ENDIF
4     CONTINUE
      WRITE(IO,101)
101   FORMAT(/' Comparison of coordinates'/1X,25('=')/)
      CALL ABRA(NP,PA,PB,PSA,PSB)
C-----Comparison of distances
      NN=0
      DO 1 I=1,N-1
      DO 1 J=I+1,N
      D1=0.0
      SD1=0.0
      DO 2 K=1,3
      D(K)=(P1(K,I)-P1(K,J))**2
      SD(K)=D(K)*(PS1(K,I)**2+PS1(K,J)**2)
      D1=D1+D(K)
2     SD1=SD1+SD(K)
      D1=SQRT(D1)
      DMAX=4.65
      IF(D1.GT.DMAX) GO TO 1
      SD1=SQRT(SD1)/D1
      D2=0.0
      SD2=0.0
      DO 3 K=1,3
      D(K)=(P2(K,I)-P2(K,J))**2
      SD(K)=D(K)*(PS2(K,I)**2+PS2(K,J)**2)
      D2=D2+D(K)
3     SD2=SD2+SD(K)
      D2=SQRT(D2)
      IF(D2.GT.DMAX) GO TO 1
      SD2=SQRT(SD2)/D2
      NN=NN+1
      PA(NN)=D1
      PB(NN)=D2
      PSA(NN)=SD1
      PSB(NN)=SD2
1     CONTINUE
      WRITE(IO,102)DMAX
102   FORMAT(/' Comparison of the distances less than',F7.3/1X,44('=')/)
      CALL ABRA(NN,PA,PB,PSA,PSB)
      RETURN
      END
 
      SUBROUTINE ABRA(N,PP1,PP2,S1,S2)
      DIMENSION P1(500),P2(500),S1(500),S2(500),DP(500),
     1 S(500),COM(500),PX(500),D(500),X(500),DSO(500),
     2 DSI(500),IORD(500),PP1(500),PP2(500)
C-----DIMENSION IX(500),IY(500)
      EQUIVALENCE (P1(1),PX(1)),(P2(1),X(1)),(S(1),D(1))
      COMMON/INPOU/IN,IO
      DO 12 I=1,N
      P1(I)=PP1(I)
12    P2(I)=PP2(I)
C-----Calcola i delta/sigma
      AN=0.0
      AD=0.0
      DO 3 I=1,N
      DP(I)=P1(I)-P2(I)
      AN=AN+DP(I)
      AD=AD+(ABS(P1(I))+ABS(P2(I)))/2.0
      S(I)=SQRT(S1(I)**2+S2(I)**2)
      DSI(I)=ABS(DP(I))/S(I)
      IORD(I)=I
3     COM(I)=DSI(I)
      R12=AN/AD
C-----Dispone i delta/sigma in ordine crescente
      CALL ORD(COM,DSO,N)
C-----Fa la statistica dei delta/sigma
      NM2=0
      NM25=0
      NM3=0
      DSMAX=DSO(1)
      DO 6 I=1,N
      IF(DSO(I).GT.DSMAX) DSMAX=DSO(I)
      IF(DSO(I).GT.2.0) NM2=NM2+1
      IF(DSO(I).GT.2.5) NM25=NM25+1
      IF(DSO(I).GT.3.0) NM3=NM3+1
6     CONTINUE
C-----Stampa la tabella dei dati di ingresso e dei delta/sigma
      WRITE(IO,108)
108   FORMAT(4X,'P1',6X,'P2',6X,'S1',6X,'S2',6X,'D=P1-P2',3X,'<S>',5X,
     1 'D/S',6X,'i  D/S(ord)')
      DO 7 I=1,N
7     WRITE(IO,109)P1(I),P2(I),S1(I),S2(I),DP(I),S(I),DSI(I),I,DSO(I)
109   FORMAT(4F8.5,3X,3F8.5,I5,F8.5)
      WRITE(IO,110)R12,NM2,NM25,NM3,DSMAX
110   FORMAT(/' Disagreement index: ',
     1 'R12=Sum|P1-P2|/Sum[(|P1|+|P2|)/2] = ',F7.4/
     2 ' N. delta/sigma > 2   =',I4/
     3 ' N. delta/sigma > 2.5 =',I4/
     4 ' N. delta/sigma > 3   =',I4/
     5 ' delta/sigma max.     =',F7.4)
C-----Calcola la distribuzione normale
      DO 8 I=1,N
      PX(I)=(2.*I-1)/2./N
      PSUB=(1.-PX(I))/2.
      CALL NDR(PSUB,XSUB,DSUB,IER)
      D(I)=DSUB
8     X(I)=-XSUB
C-----Stampa i dati relativi al diagramma
      WRITE(IO,111)
111   FORMAT(//4X,'i',5X,'D/S',4X,'P(X)',6X,'X',7X,'D'/)
      DO 9 I=1,N
9     WRITE(IO,112)I,DSO(I),PX(I),X(I),D(I)
112   FORMAT(I5,4F8.3)
C-----Stampa il grafico del "half-normal probability plot"
      WRITE(IO,'('' '')')
      CALL PLTLIN(N,X,DSO)
C-----Calcola l'equazione della retta e stampa i risultati
      CALL REGRLIN(N,X,DSO)
      RETURN
      END
 
      SUBROUTINE PLTLIN(N,X,Y)
C-----Gives an x,y plot on the line printer
      CHARACTER*1 STR(101)
      DIMENSION X(N),Y(N),IX(500),IY(500),AA(6)
      COMMON/INPOU/IN,IO
      XMX=X(1)
      YMX=Y(1)
      DO 1 I=1,N
      IF(X(I).GT.XMX) XMX=X(I)
      IF(Y(I).GT.YMX) YMX=Y(I)
1     CONTINUE
      DO 2 I=1,N
      IX(I)=X(I)*100/XMX
2     IY(I)=Y(I)*50/YMX
      PX=XMX/100
      PY=YMX/50
      DO 9 I=1,51
      K=51-I
      STR(1)='.'
      STR(101)='.'
      IF(K.EQ.0.OR.K.EQ.50)THEN
      DO 3 L=1,101
3     STR(L)='.'
      DO 4 L=1,101,10
4     STR(L)='!'
      ENDIF
      DO 5 J=1,N
      IF(IY(J).EQ.K)THEN
      STR(IX(J)+1)='*'
      ENDIF
5     CONTINUE
      DO 6 L=1,11
      IF(K.NE.(50-(L-1)*5)) GO TO 6
      IF(STR(1).NE.'*') STR(1)='-'
      WRITE(IO,'(1X,F7.2,2X,101A1)')(YMX-(L-1)*5*PY),STR
      GO TO 7
6     CONTINUE
      IF(K.EQ.33)THEN
      WRITE(IO,'(''D/s(obs.) '',101A1)')STR
      ELSE
      WRITE(IO,'(10X,101A1)')STR
      ENDIF
7     DO 8 L=1,101
8     STR(L)=' '
9     CONTINUE
      DO 10 L=1,6
10    AA(L)=(L-1)*PX*20
      WRITE(IO,100)AA
100   FORMAT(6X,F8.2,5(12X,F8.2))
      WRITE(IO,101)
101   FORMAT(56X,'D/s(expected)'/)
      RETURN
      END
 
      SUBROUTINE ORD(P,PORD,N)
      DIMENSION P(N),PORD(N)
      DO 1 I=1,N
      AMIN=P(1)
      K=1
      DO 2 J=1,N
      IF(P(J).GE.AMIN)GO TO 2
      K=J
      AMIN=P(J)
2     CONTINUE
      PORD(I)=P(K)
      P(K)=10.E17
1     CONTINUE
      RETURN
      END
 
      SUBROUTINE NDR(P,X,D,IER)
      IER=0
      IF(P)1,4,2
1     IER=1
      GO TO 12
2     IF(P-1.0)7,6,1
4     X=-0.999999E+17
5     D=0.0
      GO TO 12
6     X=0.999999E+17
      GO TO 5
7     D=P
      IF(D-0.5)9,9,8
8     D=1.0-D
9     T2=ALOG(1.0/(D*D))
      T=SQRT(T2)
      X=T-(2.515517+0.802853*T+0.010328*T2)/(1.0+1.432788*T+
     1 0.189269*T2+0.001308*T*T2)
      IF(P-0.5)10,10,11
10    X=-X
11    D=0.3989423*EXP(-X*X/2.0)
12    RETURN
      END
 
      SUBROUTINE REGRLIN(N,X,Y)
C-----Calculate the coefficients of the LS-straight-line running
C-----through a set of points.
C-----Equation of the line: y=a+bx
C-----SA = sigma(a),   SB = sigma(b)
      DIMENSION X(N),Y(N)
      DOUBLE PRECISION SX,SY,SX2,SY2,SXY,SSX,SSY,D,AD,BD,DR2,ND,
     1 SDY2,DD,SAD,SBD,XD,YD
      COMMON/INPOU/IN,IO
      SX=0D0
      SY=0D0
      SX2=0D0
      SY2=0D0
      SXY=0D0
      DO 1 I=1,N
      XD=X(I)
      YD=Y(I)
      SX=SX+XD
      SY=SY+YD
      SX2=SX2+XD**2
      SY2=SY2+YD**2
1     SXY=SXY+XD*YD
      SSX=SX**2
      SSY=SY**2
      D=N*SX2-SSX
      IF(D.EQ.0D0)THEN
      WRITE(IO,100)
100   FORMAT(/' The calculation cannot be performed')
      STOP
      ELSE
      ENDIF
      ND=N
      AD=(SX2*SY-SX*SXY)/D
      BD=(ND*SXY-SX*SY)/D
      DR2=(AD*SY+BD*SXY-SSY/ND)/(SY2-SY**2/ND)
      DR2=DSQRT(DR2)
      SDY2=0.0
      DO 2 I=1,N
      XD=X(I)
      YD=Y(I)
      YC=AD+BD*XD
2     SDY2=SDY2+(AD+BD*XD-YD)**2
      DD=D*(ND-2D0)
      SAD=DSQRT((SDY2*SX2)/DD)
      SBD=DSQRT((SDY2*ND)/DD)
      A=AD
      B=BD
      SA=SAD
      SB=SBD
      R2=DR2
      WRITE(IO,101)N,A,SA,B,SB,R2
101   FORMAT(/' Regression line through (delta/sigma)observed vs ',
     1 '(delta/sigma)expected '/' (N=number of points, i=intercept, ',
     2 's=slope, r=determination coefficient)'/
     3 ' N = ',I4/
     4 ' i = ',F7.4,'(',F6.4,')'/
     5 ' s = ',F7.4,'(',F6.4,')'/
     6 ' r = ',F7.4)
      RETURN
      END
 
      SUBROUTINE READAT(LD,NC,NT,NFP,IER)
C-----This routine reads a list of atom labels
C-----LD=1 planes and lines;  LD=2 rings; LD=3 stereographic projections
      CHARACTER*1 PDOL(6,40)
      CHARACTER*80 STG
      COMMON/GRN1/PDOL
     1      /INPOU/IN,IO
      STG(1:80)=' '
      READ(IN,'(A80)')STG
      GOTO(1,2,3),LD
1     READ(STG(1:4),'(2I2)')NT,NFP
      GO TO 4
2     READ(STG(1:2),'(I2)')NT
      GO TO 4
3     READ(STG(1:5),'(I1,2I2)')NC,NT,NFP
4     IF(NT.GT.40)THEN
      WRITE(IO,'(''The number of atoms is greater than 40'')')
      IER=1
      RETURN
      ENDIF
      IF(NT.GT.12)GO TO 5
      READ(STG(9:80),'(12(6A1))')((PDOL(L,J),L=1,6),J=1,NT)
      RETURN
5     MIN=1
      READ(STG(9:80),'(12(6A1))')((PDOL(L,J),L=1,6),J=1,12)
6     MIN=MIN+12
      MAX=MIN+11
      IF(MAX.GT.NT)MAX=NT
      READ(IN,'(A80)')STG
      READ(STG(1:80),'(12(6A1))')((PDOL(L,J),L=1,6),J=MIN,MAX)
      IF(NT.GT.MAX)GO TO 6
      RETURN
      END
