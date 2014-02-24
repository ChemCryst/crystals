!$Rev::                                                                 $:  Revision of last commit
!$Author::                                                              $:  Author of last commit
!$Date::                                                                $:  Date of last commit

C $Log: solve.F,v $
C Revision 1.72  2013/11/11 21:01:45  rich
C Set CTEXT for overall parameters outside conditional print block
C
C Revision 1.71  2013/11/07 10:47:26  pascal
C fix stack overflow for digital compiler
C
C Revision 1.70  2013/11/06 12:06:34  pascal
C catch singularity during inversion and returning an error
C
C Revision 1.69  2013/11/05 12:39:11  pascal
C small changes
C
C Revision 1.68  2013/10/14 08:56:41  pascal
C fixed eigen filtering value
C
C Revision 1.67  2013/10/11 16:21:13  pascal
C new LDLT inversion
C
C Revision 1.66  2013/10/09 13:56:18  pascal
C new algorithm for cholesky inversion, more stable
C
C Revision 1.65  2013/10/07 15:27:50  pascal
C add dedicated subroutine for cholesky + preconditioning, move lapack functions to lapack.f
C
C Revision 1.64  2013/09/23 10:26:22  rich
C Extra lapack dependecies (4) for non-intels
C
C Revision 1.63  2013/09/23 10:16:05  rich
C Extra lapack dependecies (3) for non-intels
C
C Revision 1.62  2013/09/23 09:56:50  rich
C Extra lapack dependecies (2) for non-intels
C
C Revision 1.61  2013/09/23 09:45:59  rich
C Extra lapack dependecies for non-intels
C
C Revision 1.60  2013/09/23 08:12:00  rich
C Duplicated function
C
C Revision 1.59  2013/09/23 08:05:50  rich
C Misplaced END
C
C Revision 1.58  2013/09/23 08:00:28  rich
C Missing END
C
C Revision 1.57  2013/09/23 07:54:04  rich
C Leave in lapack routines for non-intel compiler versions for now
C
C Revision 1.56  2013/09/22 21:43:39  rich
C Improved accumulation.
C
C Revision 1.55  2013/09/19 21:35:39  rich
C Change precision of listing output where not important to reduce differences across platforms.
C Important changes - SFLS now uses builtin cos() and sin() functions rather than Chebyshev
C approximations.
C
C Revision 1.54  2013/06/13 11:04:20  djw
C remove an historical debugging print to the punch file
C
C Revision 1.53  2012/10/25 13:32:10  djw
C Change format and add text to output from each cycle to help clarify why refinement is terminating.
C
C Revision 1.52  2012/08/29 13:25:13  djw
C Old test for number of observations actually used number of degrees of freedom. Fixed
C
C Revision 1.51  2012/03/16 11:04:52  rich
C Fully expand normal matrix for eigenvalue decomposition (not just lower tri).
C
C Revision 1.50  2011/09/01 11:55:27  rich
C Corrected DU[ISO] scaled shift calc - but it makes no difference.
C
C Revision 1.49  2011/08/31 15:41:58  rich
C Added COMMON required for ISSPRT
C
C Revision 1.48  2011/05/04 11:48:19  rich
C Output L12 size as comment at top of MATLAB output.
C
C Revision 1.47  2011/03/21 13:57:22  rich
C Update files to work with gfortran compiler.
C
C Revision 1.46  2011/02/07 16:59:07  djw
C Put IDIM09 as a parameter in ICOM09 so that we can use it to declare work space
C
C Revision 1.45  2010/09/17 07:13:57  djw
C Output mean C-C distance to terminal and listing
C
C Revision 1.44  2010/03/04 15:12:06  djw
C Correct initialisatio of ABSF
C
C Revision 1.43  2009/06/22 06:54:48  djw
C Provide name (not just number) for overall parameters whose shift is reduced
C
C Revision 1.42  2009/06/04 14:32:11  djw
C compute GOF for X-ray data only
C
C Revision 1.41  2009/06/03 09:04:04  djw
C Highlight singularities in RED on monitor
C
C Revision 1.40  2009/04/28 09:51:44  djw
C Compute mean(abs(shift/su)) for CIF compliance.  Store in STORE(L30RF+11), in place of total minimisation function, which was never used
C
C Revision 1.39  2008/09/08 10:18:32  djw
C Enable/inhibit punching of ADP info from XPRAXI
C
C Revision 1.38  2008/08/04 16:50:03  djw
C Restore storage of extinction esd - it had got lost
C
C Revision 1.37  2007/10/09 07:04:41  djw
C Final tweaks to Stefans code
C
C Revision 1.36  2007/04/05 14:30:18  djw
C New adaptive damping for Stefans code, save C-C esd for printcif
C
C Revision 1.35  2007/03/08 11:50:38  djw
C Partial shifts for Stefans code
C
C Revision 1.34  2006/11/10 08:38:46  djw
C Remove old debugging print
C
C Revision 1.33  2006/08/02 06:20:31  djw
C Ensure that partial shifts are applied to Du[iso] corections
C
C Revision 1.32  2006/02/17 14:51:54  djw
C Fix some writes to monitir/listinganisotfs.fpp
C
C Revision 1.31  2005/05/31 12:43:50  djw
C Try to sort out use of L33CD and M33CD in SOLVE.FPP
C
C Revision 1.30  2005/05/13 12:08:52  stefan
C 1. Changed the call to the paramlist accumalation to work with the new version. Also made the matlab output output multi block normal matrices and sets it up to use the script collectBlocks to put it together in one matrix.
C
C Revision 1.29  2005/03/07 09:04:50  djw
C Add (commented) code for outputting shift info to PCH file for potential future use in pre-conditioning
C
C Revision 1.28  2005/03/03 18:10:09  stefan
C 1. Made the punching of the normal matrix a little more advanced so that it now outputs all the different blocks of the matrix
C
C Revision 1.27  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2005/01/04 11:31:17  rich
C Fix weird format statement.
C
C Revision 1.1.1.1  2004/12/13 11:16:07  rich
C New CRYSTALS repository
C
C Revision 1.25  2004/11/18 17:01:47  stefan
C 1. Add code to output the normal matrix in a format which matlab will understand and read in.
C
C Revision 1.24  2004/10/06 09:23:07  rich
C Fix non-g77 friendly FORMAT statements (Allen Oliver).
C
C Revision 1.23  2004/09/29 11:57:18  rich
C Compress the output the happens during each cycle of SFLS.
C
C Revision 1.22  2004/07/08 15:25:33  rich
C Updated \MASK code to include mask generation for solvent accessible volume.
C (It wasn't finished before.) Mask is stored in list 42.
C
C Revision 1.21  2004/07/02 13:26:01  rich
C Remove dependency on HARWELL and NAG libraries. Replaced with LAPACK
C and BLAS code (and a home-made bessel function approximation).
C
C Revision 1.20  2003/06/19 16:29:50  rich
C
C Store, in L30, the number of restraints that L16 is generating.
C
C Output, to the CIF, the _refine_ls_number_restraints for info.
C
C Revision 1.19  2003/01/15 15:26:39  rich
C Removal of NCAWU calls throught the standard SFLS refinement instruction. If
C anywhere will benefit from less IO, it's here.
C
C Revision 1.18  2002/12/04 14:31:11  rich
C Reformat output during refinement.
C
C Allow punching to MATLAB files, including restraints.
C
C Tidy some routines.
C
C Revision 1.17  2002/11/18 18:09:22  djw
C Output Reversals on Screen
C
C Revision 1.16  2002/06/05 15:29:57  richard
C Serious bug fix: GooF, S, calculation was picking up SIGMACUT rather than
C NPARAM from L30.
C
C Revision 1.15  2002/03/06 15:35:53  Administrator
C Fix a format statement, enable Extinction and TWINS to be refined together
C
C Revision 1.14  2002/03/05 11:30:44  Administrator
C FInal rendering of LIST 23 conditions
C
C Revision 1.13  2002/02/22 14:32:21  Administrator
C Modify LIST 23 conditions, and improve termination messages
C
C Revision 1.12  2002/02/13 15:32:20  Administrator
C Reduce calls to SPECIAL in multicycle SFLS, enable shift reversal monitoring, and fix Lachlans shift bounding
C
C Revision 1.11  2002/02/13 12:12:13  ckp2
C Store extinction param su in List 30.
C
C Revision 1.10  2002/02/12 12:54:50  Administrator
C Allow filtering of reflections in SFLS/CALC
C
C Revision 1.9  2002/01/09 14:59:18  Administrator
C bound shifts, abandon ill-conditioned problem
C
C Revision 1.8  2001/07/11 10:19:21  ckpgroup
C Enable -ve Flack Parameter
C
C Revision 1.7  2001/02/26 10:29:07  richard
C Added changelog to top of file
C
C
CODE FOR XSFLSE
      SUBROUTINE XSFLSE
      use solve_helper
      implicit none
C--GENERAL MATRIX INVERSION AND CALCULATION OF SHIFT ROUTINES.
C
C  THESE ROUTINES INVERT THE NORMAL MATRIX AND OUTPUT
C  THE CORRECTED PARAMETERS IN A LIST 24
C
C--THE ADDRESS OF THE PARAMETER GROUP SHIFT STACK IS :
C
C  JC  ADDRESS OF THE FIRST ENTRY.
C  JD  ADDRESS OF THE LAST ENTRY
C
C--THE FORMAT OF THE PARAMETER GROUP SHIFT STACKS IS AS FOLLOWS :
C
C  0  SHIFT FACTOR FOR THIS PARAMETER GROUP, COMPUTED OR FROM LIST 23
C  1  NUMBER OF PARAMETERS REFINED IN THIS GROUP
C  2  SUM OF THE CALCULATED SHIFTS
C  3  SUM OF THE CALCULATED SHIFTS SQUARED
C  4  NUMBER OF CHANGES OF SIGN COMPARED WITH THE LAST CYCLE
c  5  MAX SHIFT
C  6  RMS (SHIFT/ESD)
C
C--THIS IS REPEATED FOR THE FOLLOWING GROUPS :
C
C  OVERALL PARAMETERS
C  TYPE
C  SERIAL
C  OCC
C  U[ISO]
C  X
C  Y
C  Z
C  U[11]
C  U[22]
C  .
C  U[33]
C
C--THE FORMAT OF THE SHIFT STACK AFTER INVERSION IS :
C
C  0  ADDRESS OF THE INFORMATION FOR THE GROUP OF THIS PARAMETER
C  1  CALCULATED SHIFT
C
C--THIS FORMAT IS REPEATED FOR ALL THE REFINED PARAMETERS
C
C--
      CHARACTER(len=21) :: CTEXT, CSAVE
      CHARACTER(len=14), parameter :: CLST23(4)=(/ 'R-factor    ', 
     1 'Rw          ', 'shift/esd   ', 'Min function' /)

C-------STEFANS VARIABLES
      INTEGER ZEROED_COUNT
      INTEGER YCOUNT
      REAL  THRESH_HOLD, RHS
      REAL  SQRT_Mii, SQRT_Mjj, Mij
C----------------------------
      INCLUDE 'TYPE11.INC'
C
C
      REAL, DIMENSION(6) :: A1
      REAL, DIMENSION(3) :: B1,C1
      INCLUDE 'ICOM11.INC'
      INCLUDE 'ICOM12.INC'
      INCLUDE 'ICOM24.INC'
      INCLUDE 'ICOM30.INC'
      INCLUDE 'ICOM33.INC'
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XWORK.INC'
      INCLUDE 'XWORKA.INC'
      real djwscl
      common /xpatch/djwscl
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XLST24.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XLST33.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XOPK.INC'
      INCLUDE 'XSCALE.INC'
      INCLUDE 'XLSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QSTR11.INC'
C
C
      !EQUIVALENCE (A1(1),A)
      INCLUDE 'QLST11.INC'
      INCLUDE 'QLST12.INC'
      INCLUDE 'QLST30.INC'
      INCLUDE 'QLST24.INC'
      INCLUDE 'QLST33.INC'
C
      INCLUDE 'IDIM11.INC'
      INCLUDE 'IDIM12.INC'
      INCLUDE 'IDIM24.INC'
      INCLUDE 'IDIM33.INC'
C
C---- no of words in summary stack
      INTEGER :: MW=7
C
C----- SET THE PRINT THRESHOLDS
      REAL :: RMAX=3., SOESD=1.0, CCOEF=.8, RMSSM=0.0
      
C
      INTEGER :: IVERSN=410
      
      REAL absf, absfm, adprev, adpshift, adpsoe, adptms, augfac
      REAL cond, fcond, discrm, filter
      INTEGER iaddd, iaddl, iaddr, icapt, iconvg, ihit, ilevel
      INTEGER inm, iscl, ispar, istat, istat2, iuln, ival, ivec
      INTEGER iwrk, jsave, ke, ko, l11c, l11rc, lennam, lflds
      INTEGER m11db, m11rdb, m11rs, method, m11s, nelem, nflds, nmw
      REAL oldshift, ovrrev, ovrshift, ovrsoe, ovrtms, revshift, rfshift
      REAL rlast, rmss, scalsv, smax, sssr, terms, usershift, xyzrev
      REAL xyzshift, xyzsoe, xyztms
      
      real, dimension(:), allocatable :: ref
      real, dimension(:,:), allocatable :: check, unpacked
      integer info, nrej
      
      integer, external :: KRDDPV, KHUNTR, KCHLFL, KSET52, KADD11
      integer, external :: KEXIST, KPARAM, KBLCK, KFLSP, KLSCHK
      real, external :: tri_matrix_apply_threshhold

      
C
C
C--INITIALISE THE TIMING FUNCTION
      CALL XTIME1(2)
C--READ ANY OTHER PARAMETERS
      if (KRDDPV ( ISTORE(NFL),1 ) .LT. 0 ) then
          call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
          return
      end if
C----- METHOD = 0 FOR CHOLESKI, ELSE 1
      METHOD = ISTORE(NFL)
C--CLEAR THE CORE
      CALL XCSAE
      CALL XRSL
C--LOAD THE CONTROL LISTS
      CALL XFAL23
      CALL XFAL33
      if ( IERFLG .LT. 0 ) then
          call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
          return
      end if
cdjwdec06 - save the sparsity flag. 0=sparse
      ispar = istore(m33cd+13)
C--LOAD A FEW MORE LISTS
      CALL XFAL01
      CALL XFAL05
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL30
cdjwdec06 - save the last r-factor
      rlast = store(l30rf)
c
C--PRINT OUT THE PAGE HEADING
      CALL XPRTCN
      I=NINT(STORE(M33V))
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1000)I
1000  FORMAT(' Matrix inversion and calculation',
     2 ' of the shifts for S.F.L.S. cycle number ',I5)
C--FIND THE 'MAP' PARAMETER
      ISTAT2=ISTORE(M33CD+3)
C----- FIND THE 'PRINT' LEVEL
      ILEVEL=ISTORE(M33CD+7)
      IF (ILEVEL .GE. 0) THEN
      IF (ISSPRT .EQ. 0) THEN
       WRITE(NCWU,3555)
       WRITE(NCWU,1020) RMAX, SOESD
      ENDIF
1020  FORMAT(' Parameters for which the shift ratio exceeds ',F5.2,
     1 ' (SRATIO)',
     2 /      '            and/or the shift-over-esd exceeds ',F5.2,
     3 ' (S/ESD)',
     4 /      '            and/or there is a relatively large shift.',
     5 /' Parameters marked COMPOSITE contain derivatives from ',
     6  'other physical parameters'/)
      ENDIF
C----- SET THE EIGENVALUE FILTERS
      AUGFAC = STORE(M33CD+9)
      FILTER = STORE(M33CD+10)
      DISCRM = STORE(M33CD+11)
C----- MAXIMUM  SHIFT/ESD
C>DJWOCT96
      SMAX = -1000000.0
C<DJWOCT96
C--FIND THE NEW MATRIX FLAG
      JK=ISTORE(M33CD+6)
C--SET UP THE SHIFT AREA
      LN=24
      IREC=1001
      NMW=MD33ST-1
      JC=KCHLFL(MW*NMW)
      JD=JC+(NMW-1)*MW
cdec06
         if (ispar .eq.0) then
c-----    set general shift to 0.8 for sparse build
          store(m33sv)=min(store(m33sv), 0.8)
         endif
c
C--FIND THE POINTERS TO THE SHIFT INFORMATION
      JA=M33ST+1
      JB=M33SV+1
C--SET UP THE PARAMETER GROUP SHIFT LOCATIONS
      do I=JC,JD,MW
         STORE(I)=1.
         STORE(I+1)=0.
         STORE(I+2)=0.
         STORE(I+3)=0.
         STORE(I+4)=0.
         STORE(I+5) = 0.
         store(i+6) = 0.
C--CHECK IF A SHIFT FACTOR HAS BEEN GIVEN IN LIST 33
         if(ISTORE(JA)<0) then
C--MOVE THE SHIFT FACTOR FROM LIST 33
cdec06
            if (ispar .eq.0) then
c-----    set maximal shift to 0.8 for sparse build
                store(jb)=min(store(jb), 0.8)
            endif
            STORE(I)=STORE(JB)         
         endif
C--INCREMENT THE POINTERS
         JA=JA+1
         JB=JB+1
      end do

C
      IF (METHOD .EQ. 1) THEN
        IF (ISSPRT .EQ. 0) WRITE(NCWU,1151)  AUGFAC, FILTER, DISCRM
1151    FORMAT(1X, ' Eigen filters ', 3(G10.4,3X) )
      ENDIF
C--FORM THE ABSOLUTE LIST 12
      JQ=2
      JS=1
      CALL XFAL12(JS,JQ,JR,JN)
      if ( IERFLG .LT. 0 ) then
          call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
          return
      end if
C--SET UP THE POINTER TO THE RESULTS AREA
      JO=JN
C--LINK LISTS 5 AND 12
      I=KSET52(0,-1)
      if ( IERFLG .LT. 0 ) then
          call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
          return
      end if
C--LOAD THE MATRIX
C----- CLEAR THE MATRIX AREA
      IULN = 11
      CALL XIN11
C----- LOAD THE LIST 11 HEADERS
      CALL XLDLST(IULN, ICOM11, IDIM11, 0)
      if ( IERFLG .LT. 0 ) then
          call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
          return
      end if
C----- SAVE THE DISK BUFFER ADDRESSES
      M11S  = L11
      M11RS  = L11R
C--SET UP THE ANSWERS AREA
      LN=11
      KO=KADD11(1001,MD11,N12+1)
      if ( IERFLG .LT. 0 ) then
          call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
          return
      end if
C--CHECK FOR AN OLD LIST 24, AND LOAD IT IF POSSIBLE
      L24=NOWT
      MD24=0
      KE=24
      if(KEXIST(KE)>0) then
C--AN OLD LIST 24 IS ACCESSIBLE  -  BRING IT DOWN
          CALL XFAL24
          if ( IERFLG .LT. 0 ) then
              call error9900(IOPINV , IOPABN , 0, 
     1            IOPINV, IOPEND, IVERSN)
              return
          end if
      end if
C--SET THE NUMBER OF SINGULARITIES TO ZERO INITIALLY
      JA=0
      JB=JO
      IF(ISTAT2/=0) then 
C--PRINT THE ALLOCATED STORE
          CALL XPCM(1)
      end if
C
      D=STORE(L11P+17)
C--CHECK THAT THE NUMBER OF DEGREES OF FREEDOM IS POSITIVE
      IF (  STORE(L11P+16) .LE. ZERO) THEN
            I=NINT(STORE(L11P+24)+STORE(L11P+27))
            CALL XERHDR(0)
            WRITE ( CMON, 1351)  
     1      I,NINT(STORE(L11P+16))
            CALL OUTCOL(3)
            CALL XPRVDU(NCVDU, 4,0)
            CALL OUTCOL(1)
            IF (ISSPRT .EQ. 0) WRITE( NCWU,1351)
     1      I,NINT(STORE(L11P+16))
1351        FORMAT(
     1 'Ill-conditioned problem'/,
     1 ' Insufficient data to refine all variables',/
     2 '          No of observations = ',I10,/
     3 '    No of degrees of freedom = ',I10,/)
            E = 0.
            call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
            return
      ELSE
            E=D/STORE(L11P+16)
      ENDIF
C--CHECK THE TYPE OF LIST 11

cdjwapr09 F is counter for sum of squares, ABSF for sum abs(shift/esd)
      F = 0.0
      ABSF = 0
      JP=ISTORE(L11P+15)
C--CHECK IF THE MATRIX IS OF AN ACCEPTABLE TYPE
      IF ( IABS(JP) .NE. 1 ) then !       GO TO 9910
C -- LIST 11 WRONG TYPE
          IF (ISSPRT .EQ. 0) WRITE ( NCWU , 
     1        '( 1X , "List 11 is the wrong type" )' )
          WRITE ( CMON, '( 1X , "List 11 is the wrong type" )')
          CALL XPRVDU(NCVDU, 1,0)
          CALL XERHND ( IERERR )
          call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
          return
      end if
      
C--CHECK IF THE DUMMY OVERALL TEMPERATURE FACTOR HAS BEEN REFINED
      IF (KPARAM(1,L12O,M12,M12O,0,L5O)<=0) then ! 1700, 1700, 1750
C--NO REFINEMENT
          STORE(L11P+22)=0.
      else
     
C--REFINEMENT  -  CHECK THE MATRIX TYPE
          IF(JP>0) then !1900,1900,1800
C--CALCULATE THE CORRECTION FOR THE DUMMY OVERALL TEMPERATURE FACTOR
C  IGNORING THE SCALE FACTOR INTERACTION
C----- RESERVE SPACE FOR AND GET DIAGONAL ELEMENT AND VECTOR TERM
              L11C = KADD11 (-101, MD11, 2)
              JY=KBLCK(ISTORE(M12O))
              CALL XDOWNF ( JY, XSTR11(MD11*L11C+1-MD11), MD11)
              JX=L11R+ISTORE(M12O)-1
              CALL XDOWNF ( JX, XSTR11(MD11*L11C+1), MD11)
              STORE(L11P+22) = XSTR11(L11C+1) / XSTR11(L11C)
C--CHECK IF A 'WEIGHT' IS TO BE APPLIED
              IF(ISTORE(M12+1)/=1) then 
                  STORE(L11P+22)=STORE(L11P+22)*STORE(M12O+1)
              end if
          end if ! 1900  CONTINUE
      end if
C----- SAVE THE FREE ADDRESSES IN THE MATRIX WORK AREA
      LFLDS = LFLD
      NFLDS = NFLD
      M12B=L12B
      JT=1
      M24=L24
C
C
C----- WE ARE GOING TO START UPDATING LIST 11
      CALL XLSALT ( IULN , 0 , 0 , ILSOWF , ILSUPD )
C--BEGIN THE INVERSION  -  A BLOCK AT A TIME
C----- SET THE RUNNING ADDRESS FOR STEPPING THROUGH THE MATRIX
      M11DB = M11S
      M11RDB = M11RS
C
      if (ISTORE(M33CD+5) .eq. 1) then
            call open_normalfile(73)
            write(73, '(A,I12)') '% ', ISTORE(M12B+1)
            write(73, '(''N={};'')')
            if (ISTORE(M33CD+15) .eq. 1 ) then
                  write(73, '(''NNorm={};'')')
                  write(73, '(''VCNorm={};'')')
            end if
            write(73, '(''VC={};'')')
            write(73, '(''NormVect={};'')')
            write(73, '(''NBackNorm={};'')')
      end if
      DO JZ=1,N12B ! label 3500
C---- RESET MATRIX AREA
         LFLD = LFLDS
         NFLD = NFLDS
C----- INDICATE WE MAY NEED A CAPTION LATER
         ICAPT = 0
C--INVERT THE  MATRIX BLOCK IF IT IS NECESSARY
         JY=ISTORE(M12B+1)
         NELEM = (JY*(JY+1))/2
C
         IF ( (JP .LE. 0) .OR.(METHOD .EQ. 0) ) THEN
C-----  RE-USE OF MSTRIX OR CHOLESKI - GET SOME CORE FOR THE UPPER TRIAN
            L11C = KADD11(-101,MD11,NELEM)
c oct-05
C----- ALLOCATE SPACE FOR SCALE VECTOR
            ISCL = KADD11( 1013, MD11, JY)
c oct-05

         ELSE
C-----  GET SOME CORE FOR THE FULL MATRIX
            L11C = KADD11( -101, MD11, JY*JY)
C----- ALLOCATE SPACE FOR EIGEN VALUES
            IVAL = KADD11( 1012, MD11, JY)
C----- ALLOCATE SPACE FOR SCALE VECTOR
            ISCL = KADD11( 1013, MD11, JY)
C----- ALLOCATE SPACE FOR EGENVECTORS
            IVEC = KADD11( 1014, MD11, JY*JY)
C----- ALLOCATE WORK SPACE
            IWRK = KADD11( 1015, MD11, 5*JY)
            if ( IERFLG .LT. 0 ) then
                call error9900(IOPINV , IOPABN , 0, 
     1              IOPINV, IOPEND, IVERSN)
                return
            end if
         ENDIF
         M11 = L11C
         INM = L11C
C--BRING DOWN THE MATRIX - REMEMBER MD11 INDICATES SINGLE OR DOUBLE PREC

      CALL XDOWNF (M11DB, XSTR11 (MD11*L11C-MD11+1), MD11*NELEM)
C     If we are going to threshhold the normal matrix then we do it here
      if ( store(M33CD+16) .gt. 0 ) then
            ZEROED_COUNT =  tri_matrix_apply_threshhold(STR11(L11C),
     1       JY*(JY+1)/2, JY, store(M33CD+16))
      end if
C --- If we are doing matlab punching then do it here.      
      IF ( ISTORE(M33CD+5) .Eq. 1 ) THEN
          call matlab_add_matrix_to_cell(73, STR11(L11C), JY*(JY+1)/2, 
     1      JY, 'N')
      END IF
Cc ---If we want to normalise the normal matrix do so...      
C      if (ISTORE(M33CD+15) .eq. 1) then
CC --- Allocate space for the normalisation vector
C            ivector = KADD11( 1016, MD11, JY*2)   
C            IF ( IERFLG .LT. 0 ) GO TO 9900 ! If there is an error do what david seems to do.
C            call tri_matrix_normalise(str11(L11C), 
C     1        JY*(JY+1)/2, JY, STR11(ivector))
C            call matlab_add_vector_to_cell(73, STR11(ivector), JY,
C     1            'NormVect')  
CC-- If we are doing matlab punching then do it here.      
C            if ( ISTORE(M33CD+5) .Eq. 1 ) then
C                call matlab_add_matrix_to_cell(73, STR11(L11C), 
C     1           JY*(JY+1)/2, JY, 'NNorm')
C            end if
C            call create_param_list_from_mat(str11(L11C), JY*(JY+1)/2,
C     1       JY, 1, 0.0026D0)     ! The last but one parameter needs to be corrected as currently this will not handle multiple blocks
C            call tri_matrix_normalise_with(str11(L11C), 
C     1           JY*(JY+1)/2, JY, STR11(ivector))
C            if ( ISTORE(M33CD+5) .Eq. 1 ) then
C                call matlab_add_matrix_to_cell(73, STR11(L11C), 
C     1           JY*(JY+1)/2, JY, 'NBackNorm')
C            end if
C      end if
      

CDJW-OCT-05
c      write(ncwu,'(a)') 'The scaling vector'
c         IDJW = L11C
c         jdjw = iscl
c         DO 2051 I = 1, JY
c            str11(jdjw) = STR11(IDJW)
c            IDJW = IDJW + JY - I + 1
c            jdjw=jdjw+1

c        call outv(str11(iscl),jy)
CDJW-OCT-05

   
      IF (JP .GT. 0 ) THEN
C----- CHOOSE INVERTOR
            IF (METHOD .LE. 0) THEN   !Cholesky
c                allocate(ref(JY*(JY+1)/2))
c                ref=STR11(L11C:L11C+JY*(JY+1)/2-1)
c               call eigen_inversion(STR11(L11C:L11C+JY*(JY+1)/2-1),
c     1              JY, 100.0)
c               !deallocate(ref)

c L D L^t inversion + preconditioning
#ifdef _DIGITALF77_
c stupid compiler has a stack overflow by making a temporary array 
               call LDLT_inversion(
     1             STR11(L11C), JY, info)
#else
               call LDLT_inversion(
     1             STR11(L11C:L11C+JY*(JY+1)/2-1), JY, info)
#endif
               if(info>0) then
                  WRITE ( CMON, '(A,I8,A)') '{E Parameter ', info, 
     1                ' is singular. Inversion failed.' 
                  CALL XPRVDU(NCVDU, 1,0)
                  STR11(L11C:L11C+JY*(JY+1)/2-1)=0.0
                  CALL XSING(info-1,JY,L11C,L11C)    
                else if(info<0) then
                  WRITE ( CMON, '(I8,A,A)') '{E ', info, 
     1                ' argument of SSYTRF or SSYTRI ',
     2                'has an illegal value.' 
                  CALL XPRVDU(NCVDU, 1,0)
                  STR11(L11C:L11C+JY*(JY+1)/2-1)=0.0
                  CALL XSING(info-1,JY,L11C,L11C)    
                end if
                    
c Cholesky inversion + preconditioning
c               call choleskyl_inversion(
c     1             STR11(L11C:L11C+JY*(JY+1)/2-1), JY, info)
c                print *, STR11(L11C:L11C+5)

c - original cholesky               
               !print *, '****** origin', STR11(L11C:L11C+4)
c               call date_and_time(VALUES=measuredtime)
c               starttime=((measuredtime(5)*3600+measuredtime(6)*60)+
c     1             measuredtime(7))+measuredtime(8)/1000.0
c               print *, 'start xchols'
c               call flush
c               STR11(L11C:L11C+JY*(JY+1)/2-1)=ref
c               CALL XCHOLS(JY, L11C, KO)
c                print *, STR11(L11C:L11C+5)
c               call date_and_time(VALUES=measuredtime)
c               print *, 'xchols done in (s): ', 
c     1             ((measuredtime(5)*3600+measuredtime(6)*60)+
c     2             measuredtime(7))+measuredtime(8)/1000.0-starttime
c               call flush

c                allocate(unpacked(JY,JY))
c                allocate(check(JY,JY))
c                do i=1, JY
c                    j = ((i-1)*(2*(JY)-i+2))/2
c                    k = j + JY - i
c                    unpacked(i:JY, i)=STR11(L11C+j:L11C+k)
c                    unpacked(i, i:JY)=STR11(L11C+j:L11C+k)
c                    check(i:JY, i)=ref(1+j:1+k)
c                    check(i, i:JY)=ref(1+j:1+k)
c                end do
c                check=matmul(check, unpacked)
c                do i=1,min(15,JY)
c                    write(*, '(15(F5.2,1X))') check(1:min(15,JY),i)
c                end do
c                deallocate(unpacked)
c                deallocate(check)
c                deallocate(ref)
               
c               print *, '****** ref', STR11(L11C:L11C+4)
               
               
            ELSE
C----- EXPAND  LOWER TRIANGLE OF FULL SQUARE

c      WRITE (NCWU,103)
c103   FORMAT(/ , ' The Lower triangle Normal Matrix' )
c      JLC = JY
c      JLD = INM
c      DO JLI = 1, JY
c        WRITE (NCWU,101) JLI, JLC
c        WRITE (NCWU, 102) (STR11(JLD+I),I=0,JLC-1)
c101     FORMAT (/, ' Column ', I5, I6)
c102     FORMAT((1X,80G15.8/))
c        JLD = JLD + JLC
c        JLC = JLC - 1
c      ENDDO
c
c1031   FORMAT(/ , ' A test matrix' )
c      DO JLI = 0, 8
c        WRITE (NCWU,1021) JLI, IMLIND(3,JLI)
c1021     FORMAT((1X,2I5))
c      ENDDO
c
c
c
               call eigen_inversion(STR11(L11C:L11C+JY*(JY+1)/2-1),
     1              JY, 1e-2, nrej, cond, fcond, info)

               if ( nrej .gt. 0 ) THEN
                  WRITE ( CMON, '(A,I8,A)') '{E ', nrej, 
     1   ' eigenvalues rejected.' 
                  CALL XPRVDU(NCVDU, 1,0)
                  WRITE ( CMON, '(A,G9.2,A,G9.2)') 
     1'{E Condition before filtering', cond, 
     1' and after filtering ', fcond
                  CALL XPRVDU(NCVDU, 1,0)
                else
                  WRITE ( CMON, '(A,G9.2)') 
     1'{I Condition number of normal matrix ', cond
                  CALL XPRVDU(NCVDU, 1,0)
                end if

c               CALL XMTCVT (INM, JY, 1, MD11)
c               CALL XFILTR
c     1      (STR11(INM), STR11(IVAL), STR11(IVEC), STR11(ISCL),
c     2      STR11(IWRK), JY, AUGFAC, FILTER, DISCRM, ILEVEL  )
C----- COMPRESS INVERTED MATRIX
c               CALL XMTCVT (INM, JY, 2, MD11)
            ENDIF
         ENDIF
         
c --- If we normalised the matrix then denormalise it      
C         if (ISTORE(M33CD+15) .eq. 1 ) then
CC               if ( ISTORE(M33CD+5) .Eq. 1 ) then
C                   call matlab_add_matrix_to_cell(73, STR11(L11C), 
C     1               JY*(JY+1)/2, JY, 'VCNorm')
C               end if
C               call matlab_add_vector_to_cell(73, STR11(ivector), JY,
C     1            'NormVect')
CC               call inv_diag(STR11(ivector), JY)
C               call matlab_add_vector_to_cell(73, STR11(ivector), JY,
C     1            'NormVect')
C               call tri_matrix_normalise_with(str11(L11C), 
C     1           JY*(JY+1)/2, JY, STR11(ivector))
C         end if 
         
C-- If we are doing matlab punching then do it here.      
         if ( ISTORE(M33CD+5) .Eq. 1 ) then
            call matlab_add_matrix_to_cell(73, STR11(L11C), 
     1            JY*(JY+1)/2, JY, 'VC')
         end if

                 
         L11RC = KADD11(-102,MD11R, JY)
         M11R=L11RC
         if ( IERFLG .LT. 0 ) then
             call error9900(IOPINV , IOPABN , 0, IOPINV, IOPEND, IVERSN)
             return
         end if
C--BRING DOWN THE VECTOR
         CALL XDOWNF (M11RDB, XSTR11 (MD11R*L11RC-MD11R+1), MD11R*JY)
         CALL XSOLVE(JY, L11C, M11R, KO)
C--SPREAD OUT THE NEW SHIFTS TO ALLOW THE STORAGE OF OTHER DATA
         JV=JO+JY+JY-2
         JW=KO+JY-1
         do JU=1,JY
            STORE(JV)=STR11(JW)
            ISTORE(JV+1)=NOWT
            JV=JV-2
            JW=JW-1
         end do
         JQ=M11
C--SEARCH THROUGH THE ATOMIC PARAMETERS FOR EACH OF THE
C  LEAST SQUARES PARAMETERS IN TURN
C
C----- SET UP THE START ADDRESSES
         M5 = L5 - MD5
         M12 = L12O
         L12A = NOWT
         JS = 0
C
C
         do JX=1,JY
            S=0.0
            C=0.
C----- LOOK FOR PATAMETER 'JT'
C      JT            ABSOLUTE L.S. PARAMETER NO.
C      JS            PHYSICAL PARAMETER NO FROM WHICH TO START SEARCH
C      JR            SINGULARITY SYMBOL
C      JO            SHIFT ADDRESS
C      JX            RELATIVE PARAMETER NO
C      JC            SHIFT DETAILS ADDRESS
C      JQ            ADDRESS IN LIST 11
C      JZ             BLOCK NUMBER
C      ICAPT          CAPTION FLAG
C      E             SIG W DELSQ / N-M
C      C             SHIFT RATIO
C      A             ESD
C      S             SHIFT/ESD
C      ILEVEL        MONITORING LEVEL
C      MW            NO OF ITEMS PER ENTRY IN SHIFT DETAILS
c
            IHIT = KFLSP (JT, JS, JR, JO, JX, JC, JQ, JZ, ICAPT,
     1                   E, C, A, S, RMAX, SOESD, ILEVEL, MW, CTEXT)
     
            IF (IHIT /= 0) then
C--PARAMETER HAS BEEN FOUND  -  CALCULATE THE RESULTS
C----- SUM OF SQUARES SHIFT / ESD
                F = F + S*S
                ABSF = ABSF + ABS(S)
C ----- FIND THE MAXIMUM SHIFT /ESD
C>DJWOCT96
                IF (ABS(S) .GT. SMAX) THEN
                   SMAX = ABS(S)
                   JSAVE = JT
                   CSAVE = CTEXT
                ENDIF
C<DJWOCT96
C----- IF SINGULAR, INCREMENT COUNTER
                IF (A .LT. ZEROSQ) JA = JA + 1
C
C--STORE THE SHIFT INFORMATION FOR THIS COORDINATE
C      JD=ISTORE(JO+1)
C-C-C-CHECK SHIFT-TYPE
C-C-C-SHIFT OF OV, OCC, X, Y, Z, U[13], U[12] (NOT AMBIGUOUS)
                IF ((JS .LE. 7) .OR. (JS .GE. 12)) THEN
                   JD=ISTORE(JO+1)
C-C-C
C-C-C-GENERAL REMARK CONCERNING THIS PART:
C-C-C-NORMALLY JD IS OBTAINED FROM ISTORE(JO+1). THIS ISN'T POSSIBLE
C-C-C-FOR THE SHIFTS OF SPECIAL PARAMETERS, BECAUSE ISTORE(JO+1)
C-C-C-CARRIES ALWAYS THE ADDRESS FOR THE CORRESPONDING STANDARD-
C-C-C-PARAMETER.
C-C-C-SO WE USE THE INFORMATION FROM STORE(M5+3) (TYPE OF ATOM)
C-C-C-AND JS (TYPE OF SHIFT). M5 AND JS ARE UPDATED IN KFLSP.
C-C-C-DANGER: IT MIGHT BE THAT
C-C-C-THE INFORMATION IN ISTORE(JO+1) IS NECESSARY IN A DIFFERENT PLACE
C-C-C-OF THE PROGRAM EVEN FOR THE SPECIAL SHIFTS. FOR THE FUTUR: WE
C-C-C-HAVE TO FIND THE PLACE WHERE ISTORE(JO+1) IS SET AND MAKE SURE
C-C-C-THAT IT IS ALSO DONE FOR THE SPECIAL PARAMETERS
C-C-C
C-C-C-SHIFT OF U[11]/U[ISO]/"U[ISO]" (AMBIGUOUS)
                ELSE IF (JS .EQ. 8) THEN
C-C-C-ANISOTROPIC ATOM (---> SHIFT OF U[11])
                    IF (NINT(STORE(M5+3)) .EQ. 0) THEN
                        JD=ISTORE(JO+1)
C-C-C-ISOTROPIC ATOM (---> SHIFT OF U[ISO])
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 1) THEN
                        JD=JC+4*MW
C-C-C-SURFACE OF SPHERE (---> SHIFT OF "U[ISO]", I.E. THICKN. OF SURF.)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 2) THEN
                        JD=JC+14*MW
C-C-C-LINE (---> SHIFT OF "U[ISO]", I.E. THICKNESS OF LINE)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 3) THEN
                        JD=JC+16*MW
C-C-C-RING (---> SHIFT OF "U[ISO]", I.E. THICKN. OF RING)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 4) THEN
                        JD=JC+20*MW
                    ENDIF
C-C-C-SHIFT OF U[22]/SIZE (AMBIGUOUS)
                ELSE IF (JS .EQ. 9) THEN
C-C-C-ANISOTROPIC ATOM (---> SHIFT OF U[22])
                    IF (NINT(STORE(M5+3)) .EQ. 0) THEN
                        JD=ISTORE(JO+1)
C-C-C-SURFACE OF SPHERE (---> SHIFT OF SIZE, I.E. RADIUS OF SPHERE)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 2) THEN
                        JD=JC+15*MW
C-C-C-LINE (---> SHIFT OF SIZE, I.E. LENGTH OF LINE)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 3) THEN
                        JD=JC+17*MW
C-C-C-RING (---> SHIFT OF SIZE, I.E. RADIUS OF RING)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 4) THEN
                       JD=JC+21*MW
                    ENDIF
C-C-C-SHIFT OF U[33]/DECLINAT (AMBIGUOUS)
                ELSE IF (JS .EQ. 10) THEN
C-C-C-ANISOTROPIC ATOM (---> SHIFT OF U[33])
                    IF (NINT(STORE(M5+3)) .EQ. 0) THEN
                        JD=ISTORE(JO+1)
C-C-C-LINE (---> SHIFT OF DECLINAT OF LINE)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 3) THEN
                        JD=JC+18*MW
C-C-C-RING (---> SHIFT OF DECLINAT OF RINGNORMAL)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 4) THEN
                        JD=JC+22*MW
                    ENDIF
C-C-C-SHIFT OF U[23]/AZIMUTH (AMBIGUOUS)
                ELSE IF (JS .EQ. 11) THEN
C-C-C-ANISOTROPIC ATOM (---> SHIFT OF U[23])
                    IF (NINT(STORE(M5+3)) .EQ. 0) THEN
                        JD=ISTORE(JO+1)
C-C-C-LINE (---> SHIFT OF AZIMUTH OF LINE)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 3) THEN
                        JD=JC+19*MW
C-C-C-RING (---> SHIFT OF AZIMUTH OF RINGNORMAL)
                    ELSE IF (NINT(STORE(M5+3)) .EQ. 4) THEN
                        JD=JC+23*MW
                    END IF
                ENDIF
                STORE(JD+1)=STORE(JD+1)+1.
                STORE(JD+2)=STORE(JD+2)+STORE(JO)
                STORE(JD+3)=STORE(JD+3)+STORE(JO)*STORE(JO)
                STORE(JD+5) = MAX(STORE(JD+5), ABS(STORE(JO)) )
                store(jd+6)=store(jd+6)+s*s
C--CHECK IF THE SIGN HAS CHANGED COMPARED WITH THE LAST CYCLE
                if(C<0) then 
C--THE SIGN HAS CHANGED
                    STORE(JD+4)=STORE(JD+4)+1.
                end if
C--UPDATE THE ADDRESS AND CONTROL FLAGS
                JO=JO+2
                JQ=JQ+JY-JX+1
                JT=JT+1
                M24=M24+MD24
             end if
         end do
C----- PUT THE GOODIES BACK ON THE DISK
         CALL XUPF (M11DB, XSTR11 (MD11*L11C-MD11+1), MD11*NELEM)
         CALL XUPF (M11RDB, XSTR11 (MD11R*L11RC-MD11R+1), MD11R*JY)
C--CHANGE TO THE NEXT BLOCK - UPDATE DISK ADDRESSES
         M11DB = M11DB +((ISTORE(M12B+1)+1)*ISTORE(M12B+1))/2
         M11RDB = M11RDB+ISTORE(M12B+1)
         M12B=M12B+MD12B
      end do ! 3500  CONTINUE
      
      if (ISTORE(M33CD+5) .eq. 1) then
            write(73, '(''N=collectBlocks(N)'')')
            if (ISTORE(M33CD+15) .eq. 1 ) then
                  write(73, '(''NNorm=collectBlocks(NNorm);'')')
                  write(73, '(''VCNorm=collectBlocks(VCNorm);'')')
            end if
            write(73, '(''VC=collectBlocks(VC);'')')
            CLOSE(73)
      end if
C--PRINT THE OVERALL STATISTICS
      ICONVG = 0
c save sum of squares
      sssr = f
      IF (ISSPRT .EQ. 0) WRITE(NCWU,3550) F, nint(store(l11p+23))
c
3550  FORMAT(/ 
cRIC13:     1 '   Sum of the squares of the ratio (Shift/e.s.d.) =',F16.4,
     1 '   Sum of the squares of the ratio (Shift/e.s.d.) =',F16.0,
     2  / 48x, 'for ',6x,  I5,' parameters')
C
C----- TIDY UP PARAMETER NAME
      CALL XCRAS ( CSAVE, LENNAM )
C----- COMPUTE AND STORE RMS SHIFT/ESD
      RMSS=SQRT(F/STORE(L11P+23))
C MEAN ABSOLUTE SHIFT/ESD
      ABSFM = ABSF/STORE(L11P+23)
c----- RMS (shift/esd)
      STORE(M33V+3)=RMSS
C----- STORE MAXIMUM SHIFT/ESD
CDJW0202      STORE(M33V+3) = ABS(SMAX)

      IF (ISSPRT .EQ. 0) WRITE( NCWU,3556) RMSS,absfm 
CRIC13:3556  FORMAT(29X,'    The rms (shift/su)  =', F16.7/
CRIC13:     1 29x,      ' The mean abs(shift/su) =', F16.7)
3556  FORMAT(29X,'    The rms (shift/su)  =', F16.3/
     1 29x,      ' The mean abs(shift/su) =', F16.3)

      IF (ISSPRT .EQ. 0) WRITE(NCWU,3557) SMAX, JSAVE, CSAVE(1:LENNAM)
CRIC13:3557  FORMAT(' The largest (shift/esd) =',F10.6,
3557  FORMAT(' The largest (shift/esd) =',F10.2,
     1 ', for Parameter ', I4,', ', A/)


      WRITE ( CMON, 
     1 '('' Shift/su: sumsq='',f12.5,'' rms='',f12.5,
     2 '' max='',f12.5,'' for '',A)'')'),
     3 F, RMSS, SMAX, CSAVE(1:LENNAM)
      CALL XPRVDU(NCVDU, 1,0)

C---JAN97 - THE FOLLOWING STATEMENT MAY BE NEEDED IF THE
C   SHIFT RATIO IS EVER RE-COMPUTED
3555  FORMAT(/ ' The SHIFT RATIO is the shift calculated for this',
     2 ' cycle',/,' divided by the corresponding',
     3 ' shift for the last cycle.')
C
      ISTORE(L11P+15)=-1
C----- NOW WRITE BACK THE HEADER INDICATING THAT WE ARE UPDATING IT
C----- RESTORE THE DISK ADDRESSES
      L11 = M11S
      L11R = M11RS
      ISTAT = KLSCHK ( IULN , 0 , 0 , ILSEXI , ILSNMS , I , IERNOP )
      IF ( ISTAT .GT. 0 ) CALL XLSALT ( IULN , 0 , 0 , ILSOWF , ILSUPD )
      CALL XWLSTD(IULN,ICOM11,IDIM11,-1,0)
      CALL XMKOWF(11,0)
      CALL XALTES(11,1)
C
C--UPDATE THE LIST 23 ON THE DISC AND CHECK TERMINATIONS
      JD=JC+(NMW-1)*MW
C----- CHECK FOR TOO MANY SINGULARITIES
      IF (JA .LE. ISTORE(L23MN)) THEN
C----- SINGULARITY SITUATION IS OKAY
        IF (JA .GT. 0 ) THEN
          IF ( ISSPRT .EQ. 0 ) WRITE(NCWU, 3650) JA, ISTORE(L23MN)
          WRITE ( CMON, 3650) JA, ISTORE(L23MN)
          CALL XPRVDU(NCVDU, 1,0)
3650      FORMAT( ' The number of singularities, ', I4,
     1 ' is within the permited limit ', I4)
            JA=0
        ENDIF
      ELSE
            IF ( ISSPRT .EQ. 0 ) WRITE(NCWU, 3651) JA, ISTORE(L23MN)
            WRITE ( CMON, 3650) JA, ISTORE(L23MN)
            CALL XPRVDU(NCVDU, 2,0)
3651        FORMAT( '{E The number of singularities, ', I4,
     1 ' exceeds the permited limit ', I4/
     2 ' Terminating after this cycle')
      ENDIF
C--UPDATE THE VALUES OF THE VARIOUS DETERMINED FUNCTIONS

      JU=1
C--CHECK IF THIS IS THE FIRST CYCLE TO SEE IF DIFFERENCES CAN BE CALCULA
      if(ISTORE(L33CB+1)>0) then ! 3800,3800,3750
C--CHECK IF THE LAST CYCLE INVOLVED REFINEMENT
          if(ISTORE(M33CD-1)/=1) then ! 3800,3850,3800
C--NO REFINEMENT LAST TIME
              JU=-1
          end if
      else
          JU=-1
      end if
C--CHECK IF SINGULARITIES ALREADY INDICATE TERMINATION

C--CHECK THE CONDITIONS THAT MUST BE MET BY ALL CYCLES
      IF ( ISSPRT.EQ. 0)  write(ncwu,3901)
3901  format(32x,'Min',10x,'Actual',11x,'Max')
      M23AC=L23AC
      JE=M33V
      JG=2
      JF=MD23AC/JG
      I = 0
      J = 0
      do I=1,JF
C--CHECK THE MINIMUM VALUE
          IF ( ISSPRT.EQ. 0)
     1        write(ncwu,'(a,a,3g15.2e2)') 'All cycle   ',clst23(i),
     1        store(m23ac),store(je+1),store(m23ac+1)
          if (store(je+1) .lt. store(m23ac)) then
              call stopcycles(istore, l33cb, n33ib, 
     1            clst23, i, j, ncvdu, ncwu, issprt, cmon)
              JU=-1
              exit
          end if
          
C--CHECK THE MAXIMUM VALUE

          if (store(je+1) .gt. store(m23ac+1)) then
              call stopcycles(istore, l33cb, n33ib, 
     1            clst23, i, j, ncvdu, ncwu, issprt, cmon)
              JU=-1
              exit
          end if
C--UPDATE FOR THE NEXT CONDITION

          JE=JE+1
          M23AC=M23AC+JG
      end do

      I = 0
C--CHECK IF WE SHOULD CHECK INTER-CYCLE CONDITIONS
      IF(JU>0) then ! 4400,4400,4100
C--LOOP OVER THE INTER-CYCLE CONDITIONS
          M23IC=L23IC
          JH=M33V-MD33V
          JE=M33V
C--LOOP OVER EACH
          do J = 1, JF ! 4250
              A=STORE(JH+1)-STORE(JE+1)
              IF ( ISSPRT .EQ. 0 ) 
     1            write(ncwu,'(a,a,3g15.2e2)') 'Inter cycle ',clst23(j),
     1            store(m23ic),a,store(m23ic+1)
C--CHECK THE MIMIMUM
              if (a .lt. store(m23ic)) then
                  call stopcycles(istore, l33cb, n33ib, 
     1                clst23, i, j, ncvdu, ncwu, issprt, cmon)
                  exit
              end if
C--CHECK THE MAXIMUM
              if (a .gt. store(m23ic+1)) then
                  call stopcycles(istore, l33cb, n33ib, 
     1                clst23, i, j, ncvdu, ncwu, issprt, cmon)
                  exit
              end if
C--UPDATE
              JE=JE+1
              JH=JH+1
              M23IC=M23IC+JG 
          end do ! 4250  CONTINUE
          J = 0
      end if ! 4400  CONTINUE

      IF ((ICONVG .EQ. 1) .OR. ( JA .NE. 0)) ISTORE(L33CB) = N33IB
      CALL XWLSTD(33,ICOM33,IDIM33,-1,-1)
      CALL XDUMP
C
C--START OF SHIFT STATISTICS PART
      D=1./MAX(ZEROSQ,STORE(L11P+26))
      E=1./MAX(ZEROSQ,STORE(L11P+29))
C--CALCULATE THE HAMILTON WEIGHTED R-VALUES
      A=100.*SQRT(STORE(L11P+25)*D)
      B=100.*SQRT(STORE(L11P+28)*E)
      IF ((STORE(L11P+26) + STORE(L11P+29)) .LE. ZERO) THEN
            C = 0.
      ELSE
      C=100.*SQRT((STORE(L11P+25)+STORE(L11P+28))/(STORE(L11P+26)
     2 +STORE(L11P+29)))
      ENDIF
C--DETERMINE THE NUMBER OF OBSERVATIONS ETC.
      I=NINT(STORE(L11P+23))   !LS parameters
      J=NINT(STORE(L11P+24))   !No X-ray observations
      K=NINT(STORE(L11P+27))   !No of restraints
      L=J+K
      M=NINT(STORE(L11P+16))   !No of X-rays + restraints - No of param
C--PRINT THE HEADING AND THE VARIOUS DETAILS AMASSED
      CALL XPRTCN
      IF (L .LE. 0) THEN
        IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU,4448)
          WRITE(NCWU,4447)
        ENDIF
        WRITE ( CMON, 4447)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
4447  FORMAT(1X ,' You have used neither restraints nor reflections')
4448  FORMAT(/60(2H *)/)
C
      IF (ISSPRT .EQ. 0) THEN
        WRITE(NCWU,4448)
        WRITE(NCWU,4450)I,M,J,K,L,STORE(L11P+25),STORE(L11P+28),
     2 STORE(L11P+17),A,B,C
        WRITE(NCWU,4448)
      ENDIF
C
4450  FORMAT( ' Statistics for',I6,' least squares parameters,',
     1 ' with',I6,' degrees of freedom',
     3 /' Number of observations',3I18,
cRIC13:     4 /' Minimisation function',E23.7,2E18.7
     4 /' Minimisation function',E23.3,2E18.3
     5 /' Hamilton weighted R-value',F16.3,2F18.3)
C
      IF ( K .GT. 0 ) THEN   ! Only useful if there are restraints.
        WRITE(CMON, 4451) J,K,L, A,B,C
        CALL XPRVDU(NCVDU, 2,0)
      END IF
c4451  FORMAT( ' Statistics for',I6,' least squares parameters,',
c     1 ' with',I6,' degrees of freedom',
c     2 / 38X,'X-rays',8X,'Restraints',9X,'All',
c     3 /' Number of observations   ',3I16,
c     5 /' Hamilton weighted R-value',3F16.3)
4451  FORMAT(5X,I7,' reflections + ',I7,' restraints = ',I7,
     1           ' observations',/,
     2 1X,'Weighted-R:',1X,G10.4,12X,G10.4,12X,G10.4)
C
C>DJWSEP96
C----- UPDATE LIST 30
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL30
C>DJWSEP96
C----- Rw
      STORE(L30RF+1 ) = A
C----- NO. PARAM
      STORE(L30RF+2 ) = STORE(L11P+23)
C----- Number of restraints
      STORE(L30CF+13 ) = STORE(L11P+27)
C----- S GOONDNESS OF FIT - ONLY IF SOME OBSERVATIONS
      IF (STORE(L11P+24)+STORE(L11P+27) .GT. STORE(L30RF+2)) THEN
cdjwjun09  This GOF originally included efffect of restraintS in denom. 
c          Rewritten to just use X-rays
c            STORE(L30RF+4 ) = SQRT(STORE(L11P+17) /
c     1      (STORE(L11P+24)+ STORE(L11P+27)- STORE(L30RF+2)))
             STORE(L30RF+4) = SQRT(STORE(L11P+25) / 
     1       (STORE(L11P+24)-store(l11p+23)))
cdjwjun09
      ENDIF
C----- MAXIMUM SHIFT/ESD
      STORE(L30RF+7 ) = SMAX
      STORE(L30RF+8 ) = STORE(L11P+24)
      IF (STORE(L11P+24) .GT. ZERO) STORE(L30RF+9 ) = STORE(L11P+25)
      IF (STORE(L11P+27) .GT. ZERO) STORE(L30RF+10 ) = STORE(L11P+28)
CDJWAPR09
C      IF (C .GT. ZERO)              STORE(L30RF+11 ) = STORE(L11P+17)
C MEAN ABS(SHIFT/SU)
      STORE(L30RF+11) = ABSFM
      CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
C--OUTPUT THE INFORMATION FOR THE CALCULATED SHIFTS
      IF (ISSPRT .EQ. 0) WRITE(NCWU,4500)
4500  FORMAT(////,' Calculated shifts')
c shift info is held at m33sv+ and JC+
c j    0 = general
c      1 = overall  = JC
c      4 = occ      = JC+3mw  = JE
c      5 = Uiso     = Jc+4mw
c      6 = x        = JC+5mw
c      9 = U11      = JC+8mw
c
c----- find average adp and position
c      reversals and s/esd
      ovrtms=0.
      ovrrev=0.
      ovrsoe=0.
      adptms=0.
      adprev=0.
      adpsoe=0.
      xyztms=0.
      xyzrev=0.
      xyzsoe=0.
C--COMPUTE THE mean TOTALS TO BE PRINTED
      Y=0.
      Z=0.
      j = 0
      do I=JC,JD,MW
          j = j + 1
          terms = store(i+1)
             select case(j)
                case(1)
c  overall
                  ovrtms = ovrtms+terms
                  ovrsoe = ovrsoe +store(i+6)
                case(5,9,10,11)
c  adp
                  adptms=adptms+terms
                  adpsoe=adpsoe+store(i+6)            
                case(6,7,8)
c   xyz
                  xyztms=xyztms+terms
                  xyzsoe=xyzsoe+store(i+6)            
             end select
c
c      check no of reversals is valid
           if (store(i+4) .gt. zero) then
             select case(j)
                case(5,9,10,11)
c  adp
                  adprev=adprev+store(i+4)            
                case(6,7,8)
c   xyz
                  xyzrev=xyzrev+store(i+4)            
             end select
          endif
          Y=Y+STORE(I+1)
          Z=Z+STORE(I+4)
          STORE(I+1)=1./AMAX1(STORE(I+1),1.)
          STORE(I+2)=STORE(I+2)*STORE(I+1)
          STORE(I+3)=SQRT(STORE(I+3)*STORE(I+1))
          STORE(I+4)=STORE(I+4)*STORE(I+1)*100.
          store(i+6)=SQRT(STORE(I+6)*STORE(I+1))
      end do
c
c      write(ncwu,'(3(a,g16.4))')'adptms',adptms,' xyztms',xyztms,
c     1 ' ovrtms',ovrtms 
c      write(ncwu,'(3(a,g16.4))')'adpsoe',adpsoe,' xyzsoe',xyzsoe,
c     1 ' ovrsoe',ovrsoe 
      ovrsoe=sqrt(ovrsoe/max(1.,ovrtms))
      adpsoe=sqrt(adpsoe/max(1.,adptms))
      xyzsoe=sqrt(xyzsoe/max(1.,xyztms))
      adprev=100. * adprev/max(1.,adptms)
      xyzrev=100. * xyzrev/max(1.,xyztms)
c      write(ncwu,'(3(a,g16.4))')'adpsoe',adpsoe,' xyzsoe',xyzsoe,
c     1 ' ovrsoe',ovrsoe 
c      write(ncwu,'(3(a,g16.4))')'adprev',adprev,' xyzrev',xyzrev,
c     1 ' ovrrev',ovrrev 
c
c
C--CONVERT THE MEAN, RMS AND MAX POSN. COORDS. TO ANGSTROM
      JF=JC+5*MW
      JG=L1P1
      DO I=1,3
          A1(I)=STORE(JF+2)*STORE(JG)
          A1(I+3)=STORE(JF+3)*STORE(JG)
          B1(I)=STORE(JF+5)*STORE(JG)
          JF=JF+MW
          JG=JG+1
      end do
      A=A1(1)
      JE=JC+3*MW
C--PRINT THE RESULTS
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,4650)
4650  FORMAT(
     1 /13X,'Overall',4X,'Occ',5X,'U[iso]',4X,'X',8X,'Y',8X,'Z',
     2 7X,'U[11]',4X,'U[22]',4X,'U[33]',4X,'U[23]',4X,'U[13]',4X,
     3 'U[12]'//)
c
      WRITE(NCWU,4651)STORE(JC+2),(STORE(I+2),I=JE,JC+13*MW,MW),
     2 (A1(I),I=1,3),
     3 STORE(JC+3),(STORE(I+3),I=JE,JC+13*MW,MW),(A1(I),I=4,6)
cRIC13:4651  FORMAT(' Mean      ',12F9.5
4651  FORMAT(' Mean      ',F9.2,11F9.4
     5 /           38X,3F9.4
cRIC13:     6 //' R.M.S.    ',12F9.5
     6 //' R.M.S.    ',F9.2,11F9.4
     7 /           38X,3F9.4)
c
      WRITE(NCWU,4653) STORE(JC+6),(STORE(I+6),I=JE,JC+13*MW,MW)
cRIC13:4653  FORMAT(/' RMS sh/esd',12F9.5,
cRIC13@     1 /           38X,3F9.5)
4653  FORMAT(/' RMS sh/esd',12F9.2,
     1 /           38X,3F9.3)
c
      WRITE(NCWU,4660) STORE(JC+5),(STORE(I+5),I=JE,JC+13*MW,MW),
     1 (B1(I),I=1,3)
cRIC13:4660  FORMAT(/' Maximum   ',12F9.5,
4660  FORMAT(/' Maximum   ',F9.2,11F9.4,
     1 /           38X,3F9.4)
      ENDIF
      
C--CHECK IF WE MUST PRINT THE SIGN CHANGE INFORMATION
      IF(M24>0) then 
          Z=Z/Y*100.
          IF (ISSPRT .EQ. 0) THEN
c             WRITE(NCWU,4750)STORE(JC+4),(STORE(I+4),I=JE,JD,MW),Z
              WRITE(NCWU,4750) STORE(JC+4),
     1            (STORE(I+4),I=JE,JC+13*MW,MW),z
          ENDIF
c         WRITE(CMON,'(''Shift Reversals'')')
c         CALL XPRVDU(NCVDU, 1,0)
          WRITE(CMON,4701)
4701      FORMAT(' Shift     Scale  Occ U[iso]   X    Y    Z  U[11]',
     1        ' U[22] U[33] U[23] U[13] U[12]')
          CALL XPRVDU(NCVDU, 1,0)
          WRITE(CMON,4702)STORE(JC+4),(STORE(I+4),I=JE,JC+13*MW,MW)
4702      FORMAT(' Reversals',3(1X,F5.1),3(F5.1),6(1X,F5.1))
          CALL XPRVDU(NCVDU, 1,0)
4750      FORMAT(/10H Reversals,12F9.2///
     2     44H Reversals is the percentage of shifts whose,
     3     41H signs have changed since the last cycle,,8H and is ,F6.2,
     4     20H for all parameters.)
c4750  FORMAT(/' Reversals ',12F9.2/)
c
C-C-C-PRINT THE RESULTS (FOR SPECIAL SHIFTS)
c      IF (ISSPRT .EQ. 0) THEN
c      WRITE(NCWU,4760)
c      ENDIF
c4760  FORMAT(/' Calculated shifts for special parameters')
c      IF (ISSPRT .EQ. 0) THEN
c      WRITE(NCWU,4770)(STORE(I+2),I=JC+14*MW,JC+23*MW,MW),
c     2 (STORE(I+3),I=JC+14*MW,JC+23*MW,MW)
c4770  FORMAT(/13X,'UisoSph',2X,'RadSph',3X,
c     2 'UisoLin',2X,'LenLin',3X,'DecLin',3X,'AziLin',3X,
c     3 'UisoRin',2X,'RadRin',3X,'DecRin',3X,'AziRin'
c     4 //' Mean      ',10F9.5//' R.M.S.    ',10F9.5)
c      WRITE(NCWU,4653) (STORE(I+6),I=JC+14*MW,JC+23*MW,MW)
c      WRITE(NCWU,4775) (STORE(I+5),I=JC+14*MW,JC+23*MW,MW)
c4775  FORMAT(/' Maximum   ',10F9.5)
c      ENDIF
c
c
C--CHECK IF WE MUST PRINT THE SIGN CHANGE INFORMATION
c      Z=Z/Y*100.
CDJW0105
          DO I =1,3
              C1(I) = STORE(JE+4+(I+1)*MW)
          ENDDO
C- USED WHEN TRYING TO OPTIMISE THE LS WEIGHTING
C- OUTPUTS THE SHIFT INFO FOR CURRENT CYCLE TO PUNCH FILE
C      CALL XLSDEL (A1,B1,C1)
CDJW0105
c      IF (ISSPRT .EQ. 0) THEN
c      WRITE(NCWU,4785)(STORE(I+4),I=JC+14*MW,JC+23*MW,MW),Z
c      ENDIF
c4785  FORMAT(/' Reversals',10F9.2///
c     2 ' Reversals is the percentage of shifts whose',
c     3 ' signs have changed since the last cycle,'/,' and is ',F6.2,
c     4 ' for all parameters.')
      end if
c
c
C--COMPUTE THE SHIFT FACTORS TO APPLY IF ANY
      J=M33ST+1
      K=M33SV+1
C--STORE THE SHIFTS INFORMATION IN ANGSTROM FOR X, Y AND Z
      JF=JC+5*MW
      Do I=4,6
cdkw0202      STORE(JF+3)=A1(I)
C----- USE MAXIMUM NOT RMS
          STORE(JF+3)=B1(I-3)
          JF=JF+MW
      end do
C--SEE IF THE SHIFTS HAVE TO BE CALCULATED
      do I=JC,JD,MW
          IF(ISTORE(J)==0) then
c----- TYPE eq 0 -MAX- check actual values
C--CHECK IF THE R.M.S. VALUE IS TOO LARGE
CDJW0102 CHANGED TO WORK ON MAXIMUM VALUE. 
c      Store(k) is a list33 value, store(i+3) is rms shift
              IF(STORE(K)-STORE(I+3)<0) then 
C--CALCULATE THE NEW SHIFT FACTOR
c----- TYPE eq 1 - FORCE- force shifts to max, even if lower
CDJW0102--- CHANGE TO ZERO (FROM SQ) TO AVOID
C      MASSIVE SHIFTS IF MAXIMUM SHIFT IS SMALL
                  IF(STORE(I+3)-ZERO>0.0) then
c     new shift = list33 shift/ rms shift
                      STORE(I)=STORE(K)/STORE(I+3)
                  end if
              end if
          else if(ISTORE(J)>0) then
CDJW0102--- CHANGE TO ZERO (FROM SQ) TO AVOID
C      MASSIVE SHIFTS IF MAXIMUM SHIFT IS SMALL
              IF(STORE(I+3)-ZERO>0.0) then
c     new shift = list33 shift/ rms shift
                  STORE(I)=STORE(K)/STORE(I+3)
              end if
          end if
cdjwdec06
c      store(i) = min(store(I), store(k))
c----- TYPE eq -1 - normal scale factors
C--COMPUTE THE NEW TOTALS AFTER THE NEW SHIFT FACTOR HAS BEEN APPLIED
cdjwdec06
c---- reset values in list 33
          istore(j) = -1
          store(k) = store(i)
cdjwdec06
          STORE(I+2)=STORE(I+2)*STORE(I)
          STORE(I+3)=STORE(I+3)*STORE(I)
          J=J+1
          K=K+1
      end do
c
cdjwdec06
c      Code to catch run-away refinements, especially
c      with the sparse matrix build.
c      xyz,occ,ext,Flack are caught as absolute values in KFLSP
c      adp and overall are caught here (SFLSE) by looking at 
c      shift/esd, reversals and R-factor.
c
      if (ispar .eq.0) then
       adpshift = min(1., 4./adpsoe)
       ovrshift = min(1., 4./ovrsoe)
       xyzshift = min(1., 8./xyzsoe)
      else
       adpshift = min(1., 15./adpsoe)
       ovrshift = min(1., 15./ovrsoe)
       xyzshift = min(1., 15./xyzsoe)
      endif
c
      usershift = store(m33sv+1)      !current overall
      oldshift = usershift
c
c--- check for old shift factor for adps
      if (m33sv .gt. l33sv) then
c        write(ncwu,'(a)') 'old and new shift factors'
c        write(ncwu,'(20i5)')(istore(jjdjw),jjdjw=m33st,m33st+md33st-1)
c        write(ncwu,'(20f5.2)') 
c     1  (store(jjdjw-md33sv),jjdjw=m33sv,m33sv+md33sv-1)
c        write(ncwu,'(20f5.2)')(store(jjdjw),jjdjw=m33sv,m33sv+md33sv-1)
c
c       Find minimum of current and oldshifts

        k=0      !general
        if (istore(k+m33st) .eq. -1) 
     1    oldshift= min(store(k+m33sv-md33sv),oldshift)
        k=1      !overall
        if (istore(k+m33st) .eq. -1) 
     1   oldshift= min(store(k+m33sv-md33sv),oldshift)
        k=5      !Uiso
        if (istore(k+m33st) .eq. -1) 
     1   oldshift= min(store(k+m33sv-md33sv),oldshift)
        do k=9,11      !Uii
        if (istore(k+m33st) .eq. -1) 
     1   oldshift= min(store(k+m33sv-md33sv),oldshift)
        enddo
      endif         
c
c
      rfshift = 1.
      if (ispar .eq. 0) then
c-- sparse build - modify shift factor depending upon R
       if (rlast .ge. 30.) then
        rfshift = .3
       else if (rlast .ge. 20.) then
        rfshift = .5
       else
        rfshift = .8
       endif 
      endif
c
       revshift = 1.0
       if ((adprev .gt. 0.0) .and. (adpsoe .gt. 2.)) then
c  reversal info if large shifts
         if (adprev .gt. 80.) then
           revshift =  0.41
         else if (adprev .gt. 70.) then
           revshift =  0.71
         else if (adprev .lt. 35.) then
           revshift = 1.09
         endif
       endif
      if (revshift .le. 1.0) then
      adpshift=min(1.,usershift,rfshift,adpshift,revshift)
      else
      adpshift=revshift*adpshift
      endif
c
c now overall
      ovrshift=ovrshift * revshift
c
c      now do something about xyz
       revshift = 1.0
       if ((xyzrev .gt. 0.0) .and. (xyzsoe .gt. 3.)) then
c  reversal info if large shifts
         if (xyzrev .gt. 80.) then
           revshift =  0.41
         else if (xyzrev .gt. 70.) then
           revshift =  0.71
         else if (xyzrev .lt. 35.) then
           revshift = 1.09
         endif
       endif
      if (revshift .le. 1.0) then
      xyzshift=min(1.,usershift,rfshift,xyzshift,revshift)
      else
      xyzshift=revshift*xyzshift
      endif

c
c
c      write(ncwu,'(8(a,f8.4,x))')'usershift',usershift,
c     1 'oldshift',oldshift,'rfshift',rfshift,'adpshift',adpshift,
c     2 'revshift',revshift,'adp',adpshift,' xyz',xyzshift,' Over',
c     3 ovrshift
c
c5102  format(a,f8.1,a,f6.2,a,f6.2,2(a,2f6.2),a,f6.2,
c     1 a,f6.3,a,f6.3,a,f6.3)
c      write(ncwu,5102)
c     1 'Sssr=',sssr, ' Smax=',smax,' Rmss=',rmss,
c     2 ' Av Rev ', adprev,xyzrev,
c     3 ' Av shift/esd', adpsoe,xyzsoe, 
c     4 ' R= ',store(l30rf),' adp=',adpshift,' Xyz', xyzshift,
c     5 ' Over', ovrshift

c
c       write(ncwu,'(a)') 'Current shift factors'
c       write(ncwu,'(20i5)') (istore(jjdjw),jjdjw=m33st,m33st+md33st-1)
c       write(ncwu,'(20f5.2)') (store(jjdjw),jjdjw=m33sv,m33sv+md33sv-1)
c
c write back to list 33
       k=0 !general
         if (istore(k+m33st) .eq. -1) 
     1    store(k+m33sv)= min(adpshift,store(k+m33sv))
       k=1 !overall
         if (istore(k+m33st) .eq. -1) 
     1    store(k+m33sv)= min(adpshift, ovrshift,store(k+m33sv))
       k=5 !Uiso
         if (istore(k+m33st) .eq. -1) 
     1    store(k+m33sv)= min(adpshift,store(k+m33sv))
       do k=6,8 ! xyz
         if (istore(k+m33st) .eq. -1) 
     1    store(k+m33sv)= xyzshift
       enddo
       do k=9,14 !adp
         if (istore(k+m33st) .eq. -1) 
     1    store(k+m33sv)= min(adpshift, store(k+m33sv))
       enddo
c
c       
c       write(ncwu,'(/a)') 'New shift factors'
c       write(ncwu,'(20f5.2)') (store(jjdjw),jjdjw=m33sv,m33sv+md33sv-1)
c
      J=M33ST+1
      k=m33sv+1
c--see if the shifts have to be adjusted
      do i=jc,jd,mw
       if(istore(j) .EQ. -1)  then
        store(i) = store(k)
        store(i+2)=store(i+2)*store(i)
        store(i+3)=store(i+3)*store(i)
       endif
       j=j+1
       k=k+1
      enddo
c
c
      if ( issprt .eq. 0 ) write(ncwu,5105)
     2 store(jc),(store(i),i=je,jc+23*mw,mw)
5105  format(
     2       //' Shift',
     3        /' factors   ',12F9.5,
     4        /'           ',12F9.5)
c--shuffle the results for x, y and z
      jf=jc+5*mw
      jg=l1p1
      do i=1,3
          a1(i)=store(jf+2)*store(jg)
          a1(i+3)=store(jf+3)
          store(jf+3)=store(jf+3)/store(jg)
          jf=jf+mw
          jg=jg+1
      end do
      a=a1(1)
cdjwaug06
c----- DU[ISO] in SFLSG needs to be scaled if there are
c      partial shifts
c
      scalsv = ovrshift
      if (ovrshift .lt. 1.0) then
        write(cmon,'(a,f4.2)') 'Over-all rescaling factor ', scalsv
        call outcol(9)
        call xprvdu(ncvdu, 1,0)
        call outcol(1)
        if (issprt .eq. 0) write(ncwu,'(//a//)') cmon(1)
      endif
c      djwscl =  min(shift, scalsv)
c ric11 - shift is not initialised.
      djwscl =   scalsv
C
cdjwdec06
c----- rewrite list 33 to disk in case scalefactors have been changed
      CALL XWLSTD(33,ICOM33,IDIM33,-1,-1)
c
C
C--PREPARE THE LIST 24 FOR OUTPUT
      CALL XCSAE
      N24=N12
      CALL XCELST(24,ICOM24,IDIM24)
C--SET UP THE SHIFTS IN THE OUTPUT AREA
      J=L24
      K=L24+(N24-1)*MD24
      do I=J,K,MD24
C--SET THE CALCULATED SHIFT
          STORE(I)=STORE(JB)
C--COMPUTE THE APPLIED SHIFT
          L=ISTORE(JB+1)
          STORE(I+1)=STORE(JB)*STORE(L)
          JB=JB+2
      end do
      CALL XWLSTD(24,ICOM24,IDIM24,-1,0)
C----- PRINT LARGE CORRELATION COEFFICIENTS
cdjw0102      CALL XPR11L(CCOEF)
c5275  CONTINUE
C
      CALL XOPMSG( IOPINV, IOPEND, IVERSN)
      CALL XTIME2(2)
      RETURN      
C
      END
C
CODE FOR OUTV
      SUBROUTINE OUTV(A,N)
      implicit none
      
      integer, intent(in) :: N
      real, dimension(N), intent(in) :: A
      INCLUDE 'XUNITS.INC'
      WRITE(NCWU, 123) A
123   FORMAT(10F13.0)
      RETURN
      END
      
C
C
CODE FOR XFILTR
      SUBROUTINE XFILTR (A, B, C, U, W, M, AUGFAC, FILTER, DISC, ILEVEL)
      implicit none
C----- INVERT NORMAL MATRIX BY EIGENVALUE FILTERING
C
C      N.x = y
C      N = V.D.V'
C      N-1 = V.D-1.V'
C      x = N-1. y
C
C      THIS IS NOT AS EFFICIENT AS SOLVING THE EQUATIONS DIRECTLY FROM
C      EIGEN FACTORS (SEE BELOW), BUT IS NECESSARY IF WE NEED TO SAVE
C      THE INVERSE FOR THE ESDS.
C      N.x = y
C      V.D.V'.x = y
C      D.V'.x = V'. y      (V' = V-1)
C      V'.x = D-1.V'. y
C      x = V.D-1.V'. y
C
C----- A(M,M) NORMAL MATRIX - UPPER TRIANGLE USED AS WORK SPACE, LOWER
C             RETURNED UNCHANGED.
C----- B(M)   EIGENVALUES
C----- C(M,M) EIGENVECTORS
C----- U(M)   SCALING VECTOR
C----- W(5*M) WORK AREA
C----- AUGFAC AUGMENTATION (MARQUARDT) FACTOR    E.G. 0.0000
C----- FILTER FILTER LEVEL                       E.G. 0.00005
C----- DISC   DISCONTINUITY VALUE                E.G. 100
C----- ILEVEL MONITOR LEVEL -1 OFF,  2 HIGH
C
      DIMENSION A(M,M), B(M), C(M,M), U(M), W(5*M)
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      
      real, intent(in) :: w, augfac, filter, disc
      real, intent(inout) :: a, b, c, u
      integer, intent(in) :: ilevel, m
      
      real x, y, z, uj, sum
      integer i, j, k, ii, ij, ik, info
C
C
C
C PRE-SCALE NORMAL MATRIX.
C GET INVERSE DIAGONAL SCALING MATRIX U FROM NORMAL MATRIX.
C THE ELEMENTS ARE 1./SQRT(DIAGONAL ELEMENT OF NORMAL MATRIX)
C
c      WRITE (NCWU,103)
c103   FORMAT(/ , ' The Normal Matrix' )
c      DO J = 1, M
c        WRITE (NCWU,101) J
c        WRITE (NCWU, 102) (A(I,J),I=1,M)
c101     FORMAT (/, ' Column ', I5)
c102     FORMAT((1X,20G15.8/))
c      ENDDO

      DO I=1,M
        U(I)=1.0
        IF (ABS(A(I,I)) .GT. ZERO) U(I)=1.0 / SQRT(A(I,I))
      end do
C
C SCALE MATRIX BY U
C
      DO J=1, M
        UJ=U(J)
        DO K=1,J
          A(J,K) = A(J,K) * U(K) * UJ
        end do
      end do
C
C-----  EA06C RETURNS EIGENVECTORS AND EIGENVALUES
C
C      CALL EA06C(A, B, C, M, M, M, W)
C
C Replace Harwell routine with LAPACK one. Differences: The LAPACK
C one overwrites the normal matrix with the eigenvectors. That's OK,
C we overwrite it with it's inverse soon anyway.
C
      INFO = 0
      CALL SSYEV('V','L', M, A, M, B, W, M*5, INFO)
C
C
      IF (ILEVEL .GE.2) THEN
        IF (ISSPRT .EQ. 0) THEN
          WRITE (NCWU,1000)
          WRITE (NCWU, 1010) (B(I),I=1,M)
        ENDIF
1000    FORMAT(/,' Eigen values of Normal matrix')
1010    FORMAT((1X,10F8.3/))
        IF (ISSPRT .EQ. 0) THEN
          WRITE (NCWU,1020)
1020      FORMAT(/ , ' Eigen vectors of Normal Matrix' )
          DO J = 1, M
          WRITE (NCWU,1030) J
          WRITE (NCWU, 1015) (A(I,J),I=1,M)
1030      FORMAT (/, ' Column ', I5)
1015      FORMAT((1X,20F6.2/))
          end do
        ENDIF
      ENDIF
C
C                  EIGENVALUE FILTERING
C
C----- SEE IF THERE IS A DISCONTINUITY IN THE MAGNITUDES OF THE
C      EIGENVALUES. IF THERE IS, SET ALL THE SMALL ONES TO ZERO.
C
C
C----- FIND LARGEST AND SMALLEST
      Y = B(1)
      Z = B(1)
      II = 1
      IK = 1
      DO I = 2, M
       IF ( B(I) .GT. Y ) THEN
         II = I
         Y = B(I)
       ELSE IF (B(I) .LT. Z) THEN
         IK = I
         Z = B(I)
       ENDIF
      end do

c      WRITE(NCWU,'(A,I4)')'Info: ',INFO
c      WRITE(NCWU,'(A,2(I4,G15.8))')'Largest, smallest: ',II,Y,IK,Z

C
C----- FIND NEXT LARGEST
      l120:DO J = 1, M ! 120
         X = Z
         IJ = IK
         DO I = 1, M ! 110
           IF( (B(I).GT.X) .AND. (B(I).LT.Y) )  THEN
             X = B(I)
             IJ = I
           ENDIF
         end do ! 110      CONTINUE

c      WRITE(NCWU,'(A,I4,G15.8)')'Next largest: ',IJ,X


C-----   LOOK FOR A DISCONTINUITY
         IF ( Y .GT. (DISC * X)) THEN
C-----   RESET ALL SMALLER TO ZERO AND EXIT LOOP
         IF (ISSPRT .EQ. 0) WRITE(NCWU,111) II, Y, IJ, X
         WRITE ( CMON,113 )
         CALL XPRVDU(NCVDU, 1,0)
113      FORMAT(' Discontinuity in eigenvector list ')
111      FORMAT(' Discontinuity in eigenvector list ',/,
     1    12X, 2(I5, G11.4,4X))
           DO K = 1, M ! 115
             IF(B(K) .LE. X ) THEN
                  IF (ISSPRT .EQ. 0) WRITE(NCWU,112)  K, B(K)
                  WRITE ( CMON,112 ) K
                  CALL XPRVDU(NCVDU, 1,0)
 112              FORMAT(1X,' Zeroing eigen value ',I5,4X, G11.4,
     1            ' Eigen vectors are: ')
                  B(K) = 0.0
                  IF (ISSPRT .EQ. 0) WRITE (NCWU, 1015) (A(I,K),I=1,M)
             END IF
           end do ! 115        CONTINUE
           exit l120
         ELSE
C-----     EXCHANGE SMALLER
           Y = X
           II = IJ
         ENDIF
       end do l120
C
C------ INVERT DIAGONAL MATRIX, REJECTING LOW EIGENVALUES AND
C------ AUGMENTING OTHERS.
C
      DO I=1,M
        IF(B(I) .GT. FILTER) THEN
              B(I) = 1.0 / (B(I) + AUGFAC)
        ELSE
              B(I) = 0.0
        ENDIF
      end do

C
C----- TRANSPOSE 'A' into 'C' TO INCREASE EFFICIENCY OF INNER LOOP LATER
       DO J = 1,M
         DO I = 1, M
            C(J,I) = A(I,J)
         END DO
       END DO
C
C----- FORM       N-1 = U.V.D-1.V'.U'
C
      DO J = 1, M
        UJ = U(J)
        DO I = 1, M
          SUM = 0.0
          DO K = 1,M
            SUM =  SUM + ( B(K) * C(K,I) * C(K,J) )
          END DO
         A(I,J) = SUM * U(I) * UJ
        END DO
      END DO
C
      RETURN
      END
CODE FOR XMTCVT
      SUBROUTINE XMTCVT(IADD, N, ITYPE, ILEN)
      implicit none
C
C----- ILEN LENGTH OF REPRESENTATION OF VALUE (MD11)
C      IF ITYPE = 1
C----- EXPAND A LOWER TRIANGLE STARTING AT IADD AND STORED BY COLUMNS
C      INTO LOWER HALF OF SQUARE SYMETRIC MATRIX STARTING AT SAME ADDRES
C      ELSE
C----- CONTRACT A SQUARE MATRIX INTO A LOWER TRIANGLE
C
      INCLUDE 'TYPE11.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'QSTR11.INC'
      
      integer nim, n, m, l, iadd, jadd, itl, itd, isl, isd, isf
      integer ilen, itype, ia
      
      integer, external :: IMLIND
C
C
C

c      WRITE(442,*) 'Ilen: ', ILEN

      IF ( ITYPE .EQ. 1 ) THEN
        DO L = (N*N)-1, N, -1
          IA = IMLIND(N,L)
c          WRITE(442,*)'Moving: ', IA, ' to ', L
          XSTR11(IADD+L) = XSTR11(IADD+IA)
        END DO
        RETURN
      END IF  

      JADD = IADD - 1
      DO L = 2, N ! 10
      IF (ITYPE .EQ. 1) THEN
            STOP 'Reimplemented above'
            M = N - L + 2
      ELSE
            M = L
      ENDIF
C---- NUMBER OF ITEMS IN COLUMN M
            NIM = N - M + 1
C----- ADDRESS OG LAST ELEMENT OF COLUMN M OF LOWER TRIANGLE
            ITL = JADD + M* (2*N - M +1) /2
C----- ADDRESS OF DIAGONAL ELEMENT OF COLUMN M OF LOWER TRIANGLE
            ITD = ITL - NIM + 1
C----- ADDRESS OF LAST ELEMENT IN COLUMN M IN SQUARE MATRIX
            ISL = JADD + M * N
C----- ADDRESS OF FIRST ELEMENT IN COLUMN M IN SQUARE MATRIX
            ISF = ISL - N + 1
C----- ADDRESS OF DIAGONAL ELEMENT IN COLUMN M IN SQUARE MATRIX
            ISD = ISL - NIM + 1
C----- MOVE THE COLUMN ALONG
      IF (ITYPE .EQ. 1) THEN
            CALL XMOVE (XSTR11(ITD), XSTR11(ISD), NIM*ILEN)
      ELSE
            CALL XMOVE (XSTR11(ISD), XSTR11(ITD), NIM*ILEN)
      ENDIF
      end do ! 10    CONTINUE
C
      END
C
C Given zero-based index into NxN square array, give corresponding index into lower triangle array, 
C assuming symmetry.
CODE FOR IMLIND
      integer FUNCTION IMLIND(N,I)
      implicit none
      integer, intent(in) :: n, i
      integer irow, icol, itemp
C N - dimension of matrix
C I - 0-based index into 3x3 matrix, e.g. 8 = 3,3 for a 3x3 matrix
C IMLIND - 0-based index of position (column order), e.g. 5 = 3,3 for a 3x3 lower triangle matrix
      
      IROW = MOD(I,N) ! zero-based row index
      ICOL = (I - IROW) / N !  zero-based col index

c      WRITE(442,*)'IMLIND:', N, ' ', I


C Lower triangle only contains entries where row >= col, swap if reqd:
      IF ( IROW < ICOL ) THEN
         ITEMP = IROW
         IROW = ICOL
         ICOL = ITEMP
      END IF


C Compute index into lower triangle of IROW, ICOL

      IMLIND = ( ICOL * ( 2 * N - ICOL - 1 ) / 2 ) + IROW

c     $B22+(9-C$17)/2*C$17

c      WRITE(442,*) 'IROW, ICOL, IMLIND: ', IROW, ICOL, IMLIND
c      WRITE(442,*) 'IROW, ICOL: ', IROW, ICOL
c      WRITE(442,*) 'IROW, ICOL, IMLIND: ', IROW, ICOL, IMLIND
      RETURN
      END

         

CODE FOR KFLSP
      integer FUNCTION KFLSP (JT, JS, JR, JO, JX, JC, JQ, JZ, ICAPT,
     1 E, C, A, S, RMAX, SOESD, ILEVEL, MW, CTEXT)
      implicit none
C
C----- FIND A LEAST SQUARES PARAMETER IN LIST 5 AND LIST 12
C      AND OUTPUT DETAILS
C      RETURN VALUE GT ZERO IF SUCCESSFULL
C
C      JT            ABSOLUTE L.S. PARAMETER NO.
C      JS            PHYSICAL PARAMETER NO FROM WHICH TO START SEARCH
C      JR            SINGULARITY SYMBOL
C      JO            SHIFT ADDRESS
C      JX            RELATIVE PARAMETER NO
C      JC            SHIFT DETAILS ADDRESS
C      JQ            ADDRESS IN LIST 11
C      JZ             BLOCK NUMBER
C      ICAPT          CAPTION FLAG
C      E             SIG W DELSQ / N-M
C      C             SHIFT RATIO
C      A             ESD
C      S             SHIFT/ESD
C      ILEVEL        MONITORING LEVEL
C      MW            NO OF ITEMS PER ENTRY IN SHIFT DETAILS
C
C------ ALL EXCEPT JT ARE UPDATED BY THIS ROUTINE
C
      CHARACTER(len=6) :: FLAG
      CHARACTER(len=6), parameter :: JQUEST='??????'
      CHARACTER(len=6), parameter :: IBLANK='      '
      CHARACTER(len=6), parameter :: SRATIO='SRATIO' 
      CHARACTER(len=6), parameter :: IOESD ='S/ESD '
      CHARACTER(len=6), parameter :: TOOBIG='LARGE '
      CHARACTER(len=4), parameter :: IQUEST='????'
      CHARACTER(len=*), intent(inout) :: CTEXT
      INCLUDE 'TYPE11.INC'
      INCLUDE 'ICOM12.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      integer, dimension(4) :: IP
C----- MAXIMUM SHIFT VALUES
      real, dimension(13), parameter :: PARVAL=
     1    (/ 0.,0.,1.,.05,.25,.25,.25,.05,.05,.05,.05,.05,.05 /)
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST24.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XOPK.INC'
      INCLUDE 'XSCALE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QSTR11.INC'
      INCLUDE 'QLST12.INC'
      INCLUDE 'XIOBUF.INC'
      
      integer, intent(inout) :: jr, js, ICAPT
      integer, intent(in) :: JT, JO, JX, JC, JQ, JZ
      integer, intent(in) :: ILEVEL, MW
      real, intent(inout) :: a, c, s
      real, intent(in) :: E, RMAX, SOESD

      integer nc, nb, na, m5g, jw, jv, ju, js2, jrr, jd, itype
      integer iprint, ihit, idjw
      real adjw, bdjw, cdjw, edjw, djwsin
      
C
      KFLSP = 0
      IHIT = 0
C----- SET A BLANK
      JR = IB
      FLAG = IBLANK
C----- SET MONITORING FLAGS
      IPRINT = 0
      IF (ILEVEL .GT. 0) THEN
            ITYPE = 1
      ELSE
            ITYPE = 0
      ENDIF
C----- SAVE THE INITIAL VALUES
      IP(1) = M5
      IP(2) = M12
      IP(3) = L12A
      IP(4) = JS
      do while(M12>0) !2150  CONTINUE
C--CHECK IF THIS GROUP CONTAINS ANY REFINED PARAMETERS
          IF(ISTORE(M12+1)<=0) then !3250,3250,2200
              M5=M5+MD5
              M12=ISTORE(M12)
              cycle
          end if
C--COMPUTE THE ADDRESS OF THE FIRST PART FOR THIS GROUP
c2200  CONTINUE
          L12A=ISTORE(M12+1)
C--CHECK IF THIS PART CONTAINS ANY REFINABLE PARAMETERS
          do while(L12A>0)  !2250  CONTINUE
              IF(ISTORE(L12A+3)<0) then !3200,2300,2300
                  L12A=ISTORE(L12A)
                  cycle
              end if
C--SET UP THE CONSTANTS TO PASS THROUGH THIS PART
c2300  CONTINUE
              MD12A=ISTORE(L12A+1)
              JU=ISTORE(L12A+2)
              JV=ISTORE(L12A+3)
              JS=ISTORE(L12A+4)+1
C--SEARCH THIS PART OF THIS ATOM
              DO JW=JU,JV,MD12A ! 3150
C--CHECK IF THIS IS THE PARAMETER THAT WE ARE SEARCHING FOR
                  IF(JT-ISTORE(JW)/=0) then !3100,2350,3100
                      JS=JS+1
                      cycle
                  end if
c2350  CONTINUE
C------ A HIT
                  IHIT = IHIT + 1
                  IF ( IHIT .EQ. 1 ) THEN
C---------  SAVE THE HIT VALUES
                       IP(1) = M5
                       IP(2) = M12
                       IP(3) = L12
                       IP(4) = JS
                       KFLSP = JW
                       js2 = 0
C---------  COMPUTE ESD
                       A=STR11(JQ)
                       A=SQRT(A*E)
C--CHECK IF WE ARE USING AN OLD LIST 24
cdjw0202
                       c = 0.                       
                       !idjw = iquest
                       idjw = TRANSFER(iquest, idjw)
                       IF(M24 .GT. 0) THEN
C---------- USING AN OLD LIST 24 - CHECK THAT SHIFT IS NOT SINGULAR
C---------- COMPUTE THE RATIO OF THE TWO SHIFTS
cdjwdec06
                           IF (ABS(STORE(M24)) .GT. ZEROSQ) then
                               C = STORE(JO) / STORE(M24)
                           endif
                       ENDIF
                       edjw = c
C--IF THIS PARAMETER IS NOT SINGULAR,  COMPUTE THE SHIFT/E.S.D. RATIO
                       IF ( A .GT. ZEROSQ) THEN
                           S = STORE(JO) / A
                       ELSE
C----------  IT IS SINGULAR
cdjwdec06
                           s = 0.
                           !JR = IQUEST
                           JR = TRANSFER(iquest, JR)
                           FLAG = JQUEST
                           ITYPE = 1
                       ENDIF
C--------- THE SHIFT RATIO
                       IF (ABS (C) .GT. RMAX) THEN
                             ITYPE = 1
                             FLAG = SRATIO
                       ENDIF
C--------- THE SHIFT / ESD
                       IF (ABS (S) .GT. SOESD) THEN
                           ITYPE = 1
                           FLAG = IOESD
                       ENDIF
cdec06            IF (ITYPE .NE. 1) THEN
C------------- CHECK IF SHIFT TOO BIG
                       IF((M12 .NE. L12O) .AND. (M12 .NE. L12LS) .AND.
     1                     (M12 .NE. L12ES) .AND. (M12 .NE. L12BS)) THEN
C------------- ATOMIC PARAMETER
                           js2 = js
                           idjw = istore(m5)
                           IF (JS .GE. 5 .AND. JS .LE. 7) THEN
                              IF (ABS( STORE(JO) ) * STORE(L1P1+JS-5)
     1                            .GT. PARVAL(JS) ) THEN
                                   ITYPE=1
                                   FLAG = TOOBIG
                              ENDIF
cdjwdec06
                              adjw = a*STORE(L1P1+JS-5)
                              bdjw = abs(store(jo))*STORE(L1P1+JS-5)
                              cdjw = store(m5+js-1)*STORE(L1P1+JS-5)
                           ELSE
                              IF (ABS(STORE(JO)) .GT. PARVAL(JS)) THEN
                                   ITYPE = 1
                                   FLAG = TOOBIG
                              ENDIF
cdjwdec06
                              adjw = a
                              bdjw = abs(store(jo))
                              cdjw = store(m5+js-1)
                           ENDIF
                        ELSE
                           IF (M12 .EQ. L12O) THEN
C------------- AN OVERALL PARAMETER
                              js2 = 20+js
                              M5G = L5O
                           ELSE IF (M12 .EQ. L12LS) THEN
C------------- LAYER SCALE
                              M5G = L5LS
                           ELSE IF (M12 .EQ. L12ES) THEN
C------------  ELEMENT SCALES
                              M5G = L5ES
                          ELSE IF (M12 .EQ. L12BS) THEN
C------------  BATCH SCALE
                              M5G = L5BS
                          ELSE IF (M12 .EQ. L12CL) THEN
C------------  CELL PARAM
                              M5G = L5CL
                          ELSE IF (M12 .EQ. L12PR) THEN
C------------  PROFILE PARAM
                              M5G = L5PR
                          ELSE
C------------  ANISO-EXTINCTION PARAM
                              M5G = L5EX
                          ENDIF
c                         check we are not just starting from zero
                          if (abs(store(jo)) .ge. zero) then
                              IF(ABS(STORE(JO)) .GT. .1*STORE(M5G-1+JS))
     1                            THEN
                                  ITYPE = 1
                                  FLAG = TOOBIG
                              ENDIF
                          endif
                          adjw = a
                          bdjw = abs(store(jo))
                          cdjw = store(m5g+js-1)
                      ENDIF
cdec06            ENDIF
cdec06 Set maximal shifts for positions and occupation.
c      cannot do same for adps and scale because they
c      are seriously correlated so must be dealt with
c      by setting shift factors.
c-----       get the sign of the shift
                      djwsin = sign(real(1., kind(store)),store(jo))
                      select case(js2)
                      case(3)
c  occ - delta max = .7
C                      if (bdjw .ge. .7) then
cjan07              store(jo)=djwsin*0.33
cjan07              call rstmsg(idjw,store(m5+1),js2,bdjw, store(jo),a)
C                      endif
                       case(5,6,7)
c  xyz - delta max = .2A
C                       if (bdjw .ge. .2) then
cjan07              store(jo)=djwsin*.2/(store(l1p1+js2-5))
cjan07              call rstmsg(idjw,store(m5+1),js2,bdjw, store(jo),a)
C                       endif
                       case(8,9,10,23)
c  uii or iso
c             if (bdjw .ge. .02) then
c                  store(jo)=djwsin*.02
c                  call rstmsg(idjw,store(m5+1),js2,bdjw, store(jo),a)
c             endif
                       case(11,12,13)
c  uij
c             if (bdjw .ge. 15.*adjw) then
c                  store(jo)=15.*djwsin*adjw
c                  call rstmsg(idjw,store(m5+1),js2,bdjw, store(jo),a)
c             endif
                       case(21)
c  scale
c             if (bdjw .ge. cdjw) then 
c                  if (store(jo) .gt. 0.) store(jo)=cdjw
c                  if (store(jo) .lt. 0.) store(jo)=-.5*cdjw
c                  call rstmsg(idjw,store(m5+1),js2,bdjw, store(jo),a)
c             endif
                       case(22)
c  DU[iso]
c             if (bdjw .ge. .01) then
c                  store(jo)=djwsin*.01
c                  call rstmsg(idjw,store(m5+1),js2,bdjw, store(jo),a)
c             endif
                       case(24,25)
c  polarity and Flack
                       if (bdjw .ge. 15.*adjw) then
                           store(jo)=djwsin*15.*adjw
                           call rstmsg(idjw,store(m5+1),js2,
     1                         bdjw, store(jo),a)
                       endif
                       case(26)
c  Extinction
c aug07
cric      write(ncwu,'(4f10.5)')bdjw,cdjw,djwsin,a
                       if (cdjw .ge. zero) then
                           if (bdjw .ge. 0.2*cdjw) then
                               store(jo)=djwsin*0.2*cdjw
                               call rstmsg(idjw,store(m5+1),
     1                             js2,bdjw, store(jo),a)
                           endif
                        endif
                       end select


C--------- NOW ADJUST THE PRINT LEVEL IF NECESSARY
                      IF ( ITYPE .EQ. 1 ) IPRINT = 1
                  ENDIF

C
                  IF (ICAPT .EQ. 0) THEN
                      IF (IPRINT .EQ. 1) THEN
                          IF (ISSPRT .EQ. 0) THEN
                              WRITE(NCWU,1950)JZ
                          ENDIF
1950    FORMAT(/' Block',I4/8X,'Param.',4X,'Rel. param.',4X,
     2  'Calc. shift',4X,'Shift ratio',4X,'E.S.D.',5X,'Shift/E.S.D.',
     3  4X,'Type',3X,'Serial',4X,'Coordinate'/)
                          ICAPT = 1
                      ENDIF
                      IF (ITYPE .EQ. 1) THEN
                          ICAPT = 1
                      ENDIF
                 ENDIF
C
C--CHECK IF THIS IS AN OVERALL PARAMETER
                 IF(M12-L12O==0) THEN !2800,2700,2800
C--PRINT FOR OVERALL PARAMETERS
c2700  CONTINUE
                     IF (IHIT .EQ. 1) ISTORE(JO+1) = JC
                     WRITE(CTEXT,'(2A4,I1)')
     1                   (KVP(JRR,JS),JRR=1,2)
                     IF ((IPRINT .EQ. 1 ) .AND. 
     1                   (ISSPRT .EQ. 0) ) THEN
                            WRITE(NCWU,2750) FLAG,JT,JX,STORE(JO),C,A,
     1                          S,(KVP(JRR,JS),JRR=1,2)
                     ENDIF
CRIC13:2750  FORMAT(1X,A6,I5,I12,F18.5,F13.2,F13.5,F14.5,26X,2A4,I3)
2750  FORMAT(1X,A6,I5,I12,F18.3,E13.1,E13.3,F14.2,26X,2A4,I3)
                         JS=JS+1
                         cycle  !GOTO 3300
                    end if ! 2800  CONTINUE
C--CHECK IF THIS A SCALE OR GENERAL PARAMETER
                    NB=17
                    DO NA=1,NSC ! 2950
                        IF(ICOM12(NB)/=M12) then ! 2900,2850,2900
                            NB=NB+4
                            cycle
                        end if

C--LAYER OR ELEMENT BATCH OR PARAMETER PRINT
c2850  CONTINUE
                        IF (IHIT .EQ. 1) ISTORE(JO+1) = JC
                            WRITE(CTEXT,'(2A4,I1)')  
     1                          (KSCAL(NC,NA+2),NC=1,2),JS
                            IF ((IPRINT .EQ. 1 ) .AND. 
     1                          (ISSPRT .EQ. 0) ) THEN
                            WRITE(NCWU,2750)FLAG,JT,JX,STORE(JO),C,
     2                          A,S,(KSCAL(NC,NA+2),NC=1,2),JS
                        ENDIF
                        JS=JS+1
                        exit !GOTO 3300
C--UPDATE FOR THE NEXT SCALE
                    end do !2950  CONTINUE
                    if(NA<NSC) then
                        cycle
                    end if
C
C--PRINT FOR ATOMS
                    JD=JC+MW*JS
                    IF (IHIT .EQ. 1) THEN
                        WRITE(CTEXT,'(A4,I4,1X,3A4)') STORE(M5), 
     1                      NINT(STORE(M5+1)),
     2                      (ICOORD(JRR,JS),JRR=1,NWKA)
                        ISTORE(JO+1) = JD
                        IF ( (IPRINT .EQ. 1) .AND. (ISSPRT .EQ. 0)) THEN
C-C-C-DISTINCTION BETWEEN ANISO'S AND ISO/SPECIAL'S FOR PRINT
                            IF((STORE(M5+3) .GE. 1.0) .AND. 
     1                          (JS .GE. 8)) THEN
                                WRITE(NCWU,3050) FLAG,JT,JX,
     1                              STORE(JO),C,A,S,STORE(M5),
     2                              NINT(STORE(M5+1)),
     3                              (ICOORD(JRR,JS+NKAO),JRR=1,NWKA)
                            ELSE
                                WRITE(NCWU,3050) FLAG,JT,JX,STORE(JO),
     1                              C,A,S,STORE(M5),
     2                              NINT(STORE(M5+1)),
     3                              (ICOORD(JRR,JS),JRR=1,NWKA)
                            ENDIF
C             WRITE(NCWU,3050)FLAG,JT,JX,STORE(JO),C,A,S,STORE(M5),
C     2       STORE(M5+1),(ICOORD(JRR,JS),JRR=1,NWKA)
                        ENDIF
cRIC13:3050  FORMAT(1X,A6,I5,I12,F18.5,F13.2,F13.5,F14.4,8X,A4,I4,1X,3A4)
3050  FORMAT(1X,A6,I5,I12,F18.4,E13.1,E13.3,F14.2,8X,A4,I4,1X,3A4)
                    ELSE IF (IHIT .GE. 2) THEN
                        IF ((ISSPRT .EQ. 0) .AND. (IPRINT .EQ. 1)) 
     1                      WRITE(NCWU,3051)
                        IF (ITYPE .EQ. 1) WRITE(NCWU,3091)
3051        FORMAT(1X,107X,'Composite',/)
3091        FORMAT(1X,69X,'Composite',/)
                    ENDIF
C--INCREMENT TO THE NEXT PARAMETER OF THIS PART
                    JS=JS+1
              end do  !3150  CONTINUE
C--CHANGE PARTS FOR THIS ATOM OR GROUP
              L12A=ISTORE(L12A)
C--CHECK IF THERE ARE ANY MORE PARTS FOR THIS ATOM OR GROUP
          end do  !IF(L12A)3250,3250,2250
C--MOVE TO THE NEXT GROUP OR ATOM

          M5=M5+MD5
          M12=ISTORE(M12)
      end do
C----- RESTORE VALUES FROM INITIAL HIT
      M5  = IP(1)
      M12 = IP(2)
      L12 = IP(3)
      JS  = IP(4)
      END function
CODE FOR XSFLSG
      SUBROUTINE XSFLSG
      use solve_helper, only: error9900
      implicit none
C--SOLUTION ROUTINES
C
C--THESE ROUTINES READ DOWN LIST 24 FROM THE DISC AND APPLY
C  THE RESULTS
C
C--
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM05.INC'
      INCLUDE 'ICOM12.INC'
      INCLUDE 'ICOM30.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XPDS.INC'
C
C
      real f
      real, dimension(11) :: bc
      integer, dimension(14) :: ibc
      COMMON /XWORK/F,BC,IBC
      INCLUDE 'XWORKA.INC'
      real djwscl
      common /xpatch/djwscl
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XLST24.INC'
      INCLUDE 'XLST33.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XOPK.INC'
      INCLUDE 'XSCALE.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST05.INC'
      INCLUDE 'QLST12.INC'
      INCLUDE 'QLST30.INC'
C
C
      integer, parameter :: IVERSN=301
C
C---- CARBON
      character(len=4), parameter :: JCARB='C   '
      
      integer i, j, k, nupdat, nesdc, mgm, l, iupdat, ilevel, iprint
      integer istat2, ikey, igstat, ifsq, iaddu, iaddr, iaddd, iaddl
      real oscale, stoler, umin, u, b, aesdc
      
      integer, external :: kspini, kchlfl, krddpv, kset52, kparam
      integer, external :: kspget, kchnfl, khuntr
C
C      INITIALISE C ESD
      AESDC = 0.0
      NESDC = 0
C
C--INITIALISE THE TIMING ROUTINES
      CALL XTIME1(2)
C--READ THE CONTROL DATA FOR THIS ROUTINE
      IF ( KRDDPV ( ISTORE(NFL),1 ) .LT. 0 ) then !GO TO 9910
          CALL XOPMSG ( IOPGNP , IOPCMI , 0 )
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
      
      IPRINT=ISTORE(NFL)
C--LOAD LIST 33 TO FIND THE PRINT VARIABLE
      CALL XFAL33
      IF ( IERFLG .LT. 0 ) then !GO TO 9900
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
      
      ISTAT2=ISTORE(M33CD+3)
C----- FIND THE LISTING LEVEL
      ILEVEL=ISTORE(M33CD+7)
C----- LOAD LIST 23 TO GET UMIN
      CALL XFAL23
C--FIND THE MINIMUM ALLOWED TEMPERATURE FACTOR
      UMIN=STORE(L23AC+8)
C----- SAVE THE TOLERANCE AND UPDATE VALUES
      STOLER = STORE(L23SP+5)
      IUPDAT = ISTORE(L23SP+1)
C----- SAVE THE F**2 FLAG
      IFSQ = ISTORE(L23MN+1)
C--CLEAR THE CORE
      CALL XCSAE
      CALL XRSL
C----- SAVE SOME SPACE FOR THE U AXES
      IADDU = KCHLFL (4)
C--LOAD A FEW LISTS
      CALL XFAL01
      CALL XFAL05
capr07
      CALL XFAL30
      IF ( IERFLG .LT. 0 ) then !GO TO 9900
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
C----- SET THE OCCUPANCIES
      IF (IUPDAT .GE. 0) THEN
          I = KSPINI( -1, STOLER)
C----- SAVE SOME WORK SPACE
          J =NFL
          I = KCHNFL(40)
          M5 = L5
          DO I = 1, N5 ! 1160
              IF (IUPDAT .GE. 0)
     1        IGSTAT =KSPGET ( STORE(J), STORE(J+10), ISTORE(J+20),
     2        STORE(J+30), MGM, M5, IUPDAT, NUPDAT)
              M5 = M5 + MD5
          end do !1160  CONTINUE
          NFL= J
      ENDIF
C
C----- CHECK AND RESET SOME OVERALL PARAMETERS
C----- ENANTIOPOLE
CDJWJUN01      STORE(L5O+4) = MAX (STORE(L5O+4), 0.0)
C----- EXTINCTION
      STORE(L5O+5) = MAX (STORE(L5O+5), -ZERO)
C----- ELEMENT SCALES
      K=L5ES
      DO I=1,MD5ES ! 1165
          STORE(K) = MAX (STORE(K), 0.0)
          K=K+1
      end do !1165  CONTINUE
C
C--LOOP OVER EACH ATOM CHECKING TEMPERATURE FACTORS
C-C-C-LOOP OVER EACH ATOM CHECKING T.F. AND SPECIAL PARAMETERS
C--CHECK THAT THERE IS AT LEAST ONE ATOM IN LIST 5
      !IF (N5 .LE. 0) GOTO 6050 useless, next loop no executed if I<1 anyway
      IF (N5 > 0) M5=L5
      DO I=1,N5 ! 6300
          IF (ABS(STORE(M5+3)) .LE. UISO) THEN
C-C-C-CHECK ANISOTROPIC ATOMS
C--CHECK THE SMALLEST U AXIS
              CALL XEQUIV ( 1, M5, MD5, IADDU )
              IF (STORE(IADDU+1) .LT. UMIN) THEN
C--THIS ANISOTROPIC TEMPERATURE FACTOR IS NOT ALLOWED
C- RESET TO MINIMUM
                  U = UMIN+ZERO
                  STORE(M5+7) = MAX(U,STORE(M5+7))
                  STORE(M5+8) = MAX(U,STORE(M5+8))
                  STORE(M5+9) = MAX(U,STORE(M5+9))
                  STORE(M5+10) = MAX(0.01*U,STORE(M5+10))*STORE(L1C)
                  STORE(M5+11) = MAX(0.01*U,STORE(M5+11))*STORE(L1C+1)
                  STORE(M5+12) = MAX(0.01*U,STORE(M5+12))*STORE(L1C+2)
              ENDIF
          ELSE
C--CHECK THE ISOTROPIC ATOM OR SPECIAL FIGURE
C--CHECK THE ISOTROPIC TEMPERATURE FACTOR
C            IF(STORE(M5+3) .LE. UMIN) THEN
              IF(STORE(M5+7) .LE. UMIN) THEN
C--THIS U[ISO] VALUE IS OUT OF RANGE
C                  STORE(M5+3) = UMIN + ZERO
                  STORE(M5+7) = UMIN + ZERO
              ENDIF
C-C-C-CHECK OF SPECIAL FIGURE SPECIFIC PARAMETERS
              IF (NINT(STORE(M5+3)) .GE. 2) THEN
C-C-C-CHECK OF SIZE FOR ALL SPECIAL FIGURES
                  IF (STORE(M5+8) .LT. 0.0005) THEN
                      STORE(M5+8)=0.001
                  ENDIF
C-C-C-CHECK OF DECLINAT AND AZIMUTH FOR LINE AND RING
                  IF (NINT(STORE(M5+3)) .GE. 3) THEN
C-C-C-CHECK WHETHER DECLINAT MIGHT BE GIVEN IN DEGREES
C-C-C-(SUPPOSED IF ANGLE BIGGER THAN 5.0)
C-C-C-(THIS BLOCK CAN BE REMOVED WHEN IT IS MADE SURE THAT THE VALUE
C-C-C-OF ANGLE IS ALWAYS IN UNITS OF 100 DEGREES.)
                      IF ((STORE(M5+9) .GE. 5.0).OR.
     1                    (STORE(M5+9) .LE. -5.0)) THEN
                          STORE(M5+9)=STORE(M5+9)/100
                      ENDIF
C-C-C-BRING DECLINAT INTO PRACTICAL RANGE IF TOO FAR AWAY FROM IT
                      IF ((STORE(M5+9) .GT. 3.6).OR.
     1                    (STORE(M5+9) .LT. -3.6)) THEN
                          STORE(M5+9)=MOD(STORE(M5+9),3.6)
                      ENDIF
                      IF (STORE(M5+9) .GT. 1.8) THEN
                          STORE(M5+9)=STORE(M5+9)-3.6
                      ELSE IF (STORE(M5+9) .LT. -1.8) THEN
                          STORE(M5+9)=STORE(M5+9)+3.6
                      ENDIF
C-C-C-CHECK WHETHER DECLINAT IS CLOSE TO 0.0 OR +/-1.8
                      IF ((ABS(STORE(M5+9)+1.8) .LT. 0.001) .OR.
     2                    (ABS(STORE(M5+9)-1.8) .LT. 0.001) .OR.
     3                    (ABS(STORE(M5+9)) .LT. 0.001)) THEN
C-C-C-GIVE AZIMUTH ARBITRARY VALUE (0.0)
C-C-C-PERHAPS IT'S REASONABLE TO REMOVE THE AUTOMATICAL CHANGE
                          STORE(M5+10) = 0.0
                      ELSE
C-C-C-CHECK WHETHER AZIMUTH MIGHT BE GIVEN IN DEGREES
C-C-C-(SUPPOSED IF ANGLE BIGGER THAN 5.0)
C-C-C-(THIS BLOCK CAN BE REMOVED WHEN IT IS MADE SURE THAT THE VALUE
C-C-C-OF ANGLE IS ALWAYS IN UNITS OF 100 DEGREES.)
                          IF ((STORE(M5+10) .GE. 5.0).OR.
     1                        (STORE(M5+10) .LE. -5.0)) THEN
                              STORE(M5+10)=STORE(M5+10)/100
                          ENDIF
C-C-C-BRING AZIMUTH INTO PRACTICAL RANGE IF TOO FAR AWAY FROM IT
                          IF ((STORE(M5+10) .GT. 3.6).OR.
     1                        (STORE(M5+10) .LT. -3.6)) THEN
                              STORE(M5+10)=MOD(STORE(M5+10),3.6)
                          ENDIF
                          IF (STORE(M5+10) .GT. 1.8) THEN
                              STORE(M5+10)=STORE(M5+10)-3.6
                          ELSE IF (STORE(M5+10) .LT. -1.8) THEN
                              STORE(M5+10)=STORE(M5+10)+3.6
                          ENDIF
                      ENDIF
                  ENDIF
              ENDIF
          ENDIF
          M5 = M5 + MD5
      end do ! 6300  CONTINUE
C--FORM THE ABSOLUTE LIST 12
      JQ=0
      JS=1
      CALL XFAL12(JS,JQ,JR,JN)
      IF ( IERFLG .LT. 0 ) then !GO TO 9900
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
C--LINK LIST 5 AND 12
      I=KSET52(0,-1)
C--SET A PRINT CONTROL VARIABLE
      IF ( IERFLG .LT. 0 ) then !GO TO 9900
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
      JA=2
C--CHECK IF THE E.S.D.'S ETC. ARE TO BE PRINTED
      IF(IPRINT/=0) then !1100,1150,1100
C--ONLY PRINT THE PARAMETERS
          JA=1
      end if
C--BRING DOWN THE MATRIX
      CALL XFAL11(1,1)
      IF ( IERFLG .LT. 0 ) then !GO TO 9900
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
C--FETCH A FEW CONSTANTS FROM THE MATRIX
      F=STORE(L11P+17)/STORE(L11P+16)
      B=STORE(L11P+22)
      IF(ISTAT2/=0) then !1200,1250,1200
C--PRINT THE ALLOCATED STORE
          CALL XPCM(1)
C--PRINT OUT A FEW CAPTIONS
      end if
      CALL XPRTCN
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1300)(IB,I=1,JA)
      ENDIF
1300  FORMAT(' Generation and output of the new parameter list',//,
     2 ' Format : ',5X,'New coordinate',2A1/15X,'Applied shift',/15X,
     3 'Calculated E.S.D.',/,15X,'E.S.D. in angstrom')
C>DJWSEP96
C--BRING DOWN THE SHIFT LIST
      IF (KHUNTR (24,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL24
cdjw0202      CALL XFAL24
      IF ( IERFLG .LT. 0 ) then !GO TO 9900
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
C--SET THE POINTER FOR THE ACCUMULATION OF THE E.S.D. DATA
      JS=NFL
C
C
C---- THE OVERALL PARAMETERS
C--SET UP THE FORMAT AND BEGIN THE APPLICATION OF THE SHIFTS
      BC(1:MD5O)=0.0
C--OUTPUT THE RESULTS FOR THE OVERALL PARMAETERS
      M12=L12O
C----- IF F**2 REFINEMENT, SQUARE THE SCALE FACTOR, AND SQRT IT LATER
C      NOTE! THE EDS WILL STILL BE ON THE BASIS OF F**2, BUT WE CAN
C      KIND OF FIX IT FOR THE PRINTOUT
      IF (IFSQ .GE. 0) THEN
C-----      FIRST SQUARE THE OVERALL SCALE
            OSCALE = STORE(L5O)
            STORE(L5O) =  STORE(L5O) * STORE(L5O)
      ENDIF
      CALL XAPPLY(L5O,MD5O,1)
      IF (IFSQ .GE. 0) THEN
C-----      NOW THE SHIFT HAS BEEN APPLIED, RESTORE THE SCALEFACTOR
            STORE(L5O) = SQRT( STORE(L5O) )
C------     AND FUDGE THE SHIFT AND ESD
            APD(1) = STORE(L5O) - OSCALE
            BPD(1) = 0.5 * BPD(1)
      ENDIF
      IF ( IERFLG .LT. 0 ) then !GO TO 9900
          call error9900(IOPGNP , IOPABN , 0, IOPGNP, IOPEND, IVERSN)
          return
      end if
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1400)MD5O
      ENDIF
CAPR07      IF (  KEXIST ( 30 ) .GE. 1 )   THEN
C----- SAVE THE 'FLACK' INFORMATION IN LIST 30
CAPR07        IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL30
        IF (BPD(5) .GE. ZERO) THEN
          IF( MD30GE .GE. 6) THEN
            STORE(L30GE+6) = STORE(L5O+4)
            STORE(L30GE+7) = BPD(5)
          ENDIF
        ENDIF
CAPR07        ENDIF
C----- SAVE THE 'EXTINCTION ESD' INFORMATION IN LIST 30
caug08
c        IF (BPD(6) .GE. ZERO) THEN
         IF( MD30CF .GE. 8) THEN
          STORE(L30CF+8) = BPD(6)
         ENDIF
c        ENDIF
CAPR07        CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
C<DJWSEP96
1400  FORMAT(///1X,I2,'  Overall parameter(s)'/)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1450)((KVP(I,J),I=1,2),J=1,NKO)
      ENDIF
1450  FORMAT(3X,5(1X,2A4),5X,2A4,5X,6(1X,2A4))
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1450)
      ENDIF
      J=L5O+MD5O-1
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1500)(STORE(I),I=L5O,J)
      ENDIF
cRIC13:1500  FORMAT(2X,5F9.5,E15.5,3X,6F9.5)
1500  FORMAT(2X,5F9.3,E15.4,3X,6F9.4)
C--CHECK IF ALL THE INFORMATION IS TO BE PRINTED
      IF(IPRINT==0) then !1700,1550,1700
C--PRINT THE E.S.D.'S AND SHIFTS
          IF (ISSPRT .EQ. 0) THEN
              WRITE(NCWU,1500)(APD(I),I=1,MD5O)
          ENDIF
          IF (ISSPRT .EQ. 0) THEN
              WRITE(NCWU,1500)(BPD(I),I=1,MD5O)
          ENDIF
C--CHECK ON THE DUMMY OVERALL TEMPERATURE FACTOR
          IF(KPARAM(1,L12O,L12A,M12A,0,L5O)>0) then ! 1700, 1700, 1600
C--CALCULATE THE NECESSARY CORRECTION TERM
              JX=(ISTORE(M12A)-1)*MD24+L24
cdjwjul07
c----- DU[ISO] in SFLSG needs to be scaled if there are
c      partial shifts by factor from SFLSE
C   B holds the shift to the DU[iso]. 
              B= STORE(JX+1) - (B * DJWSCL)
cric11 - added brackets around difference above. Wrongly. Now fixed.
c
              IF (ISSPRT .EQ. 0) THEN
                  WRITE(NCWU,1650)B
              ENDIF
cRIC13:1650  FORMAT(/,' Correction to isotropic temperature factor = ',F9.5)
1650  FORMAT(/,' Correction to isotropic temperature factor = ',F9.4)
              !GOTO 1900
              call error9900(IOPGNP , IOPABN , 0, 
     1            IOPGNP, IOPEND, IVERSN)
              return
          end if 
      end if! 1700  CONTINUE
C--CHECK ON THE OVERALL TEMPERATURE FACTOR
      IF(KPARAM(2,L12O,L12A,M12A,0,L5O)>0) then ! 1900, 1900, 1750
C--CHECK IF THERE ARE ANY ATOMS IN LIST 5
          IF(N5>0) then !1900,1900,1800
C--APPLY THE NEW VALUE TO ALL THE ATOMS
              M5=L5
              DO JX=1,N5 ! 1850
C      STORE(M5+3)=STORE(L5O+2)
                  STORE(M5+7)=STORE(L5O+2)
C-C-C-SET FLAG OF ATOM TO ISOTROPIC
                  STORE(M5+3)=1.0
                  M5=M5+MD5
               end do ! 1850  CONTINUE
C--CHECK ON THE LAYER, ELEMENT AND BATCH SCALE FACTORS
          end if
      end if ! 1900  CONTINUE
      J=17
      K=17
C--LOOP OVER EACH TYPE OF SCALE FACTOR
      DO I=1,NSC ! 2100
          IF(ICOM05(J+2)>0) then !2050,2050,1950
C--PRINT A CAPTION
              IF (I .LE. 3) THEN
                  IF (ISSPRT .EQ. 0) THEN
                      WRITE(NCWU,2000)ICOM05(J+2),(KSCAL(L,I+2),L=1,2)
                  ENDIF
              ELSE
                  IF (ISSPRT .EQ. 0) THEN
                      WRITE(NCWU,2001)ICOM05(J+2),(KSCAL(L,I+2),L=1,2)
                  ENDIF
              ENDIF
2000          FORMAT(///1X,I2,2X,2A4, ' Scale Factors')
2001          FORMAT(///1X,I2,2X,2A4, ' Parameters')
C--SET THE POINTERS TO THE SCALES OF INTEREST
              M5A=ICOM05(J)
              MD5A=ICOM05(J+2)
              M12=ICOM12(K)
C--APPLY THE SHIFT DATA
              CALL XAPSCL(1,IPRINT)
              IF ( IERFLG .LT. 0 ) then !GO TO 9900
                  call error9900(IOPGNP , IOPABN , 0, 
     1                IOPGNP, IOPEND, IVERSN)
                  return
              end if
C--UPDATE FOR THE NEXT TYPE OF SCALE
          end if ! 2050  CONTINUE
          J=J+4
          K=K+4
      end do !2100  CONTINUE
C
C--WRITE THE CAPTION FOR THE ATOMS
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2150)N5
2150  FORMAT(///1X,I5,'  atom(s)'/)
C--CHECK IF THERE ARE ANY ATOMS IN LIST 5
      IF(N5>0) then !2950,2950,2200
C--THERE ARE SOME ATOMS  -  PRINT THE PARAMETER TYPES
          IF (ISSPRT .EQ. 0) THEN
C-C-C-PARAMETERS FOR ANISOTROPIC ATOM
C      WRITE(NCWU,2250)((ICOORD(I,J),I=1,2),J=1,NKA)
              WRITE(NCWU,2250)((ICOORD(I,J),I=1,2),J=1,13)
C-C-C-EXTRA LINE FOR ISOTROPIC ATOM, SPHERE, LINE, RING
              WRITE(NCWU,2260)((ICOORD(I,J),I=1,2),J=NKA-3,NKA-2),
     2            (ICOORD(1,J),J=NKA-1,NKA)
          ENDIF
2250      FORMAT(3X   , 14(1X,2A4))
2260      FORMAT(3X   , 63X,2(1X,2A4),2(1X,A4,'/100'))
C--SET UP THE CONSTANTS INVOLVING THE DUMMY TEMPERATURE CORRECTION
          JY=L1C
          BC(1:5)=0.0
          BC(6:8)=B
          BC(9:11)=B*STORE(L1C:L1C+2)
          BC(2)=B
          M5=L5
          M12=L12
          M5A=L5+2
C--MAIN LOOP FOR PROCESSING THE ATOMS
          DO I=1,N5 ! 2900
              MD5A=M5+NKA-1
C       N5A=NKA-2
CDJW0102      N5A=NKA-8
              N5A = NKAV
              U=STORE(M5+3)
              CALL XAPPLY(M5A,N5A,-1)
C--CHECK WHETHER ISO- OR ANISO- PRINT IS REQUIRED
C----- ISO OR ANISO ATOM - TO FIND NUMBER OF KEYS
C-C-C-CHECK WHETHER ISO-, ANISO- SPECIAL PRINT IS REQUIRED
C-C-C-ISO, ANISO OR SPECIAL ATOM - TO FIND NUMBER OF KEYS
C---- SET NUMBER TO ISO
C       IKEY=5
              IKEY=6
C-C-C-CHECK WHETHER ATOM IS ANISOTROPIC
              IF(ABS(U)-UISO<0.0) then !2302,2303,2303
C----- ANISO
                  IKEY=11
              end if ! 2303    CONTINUE
C-C-C-CHECK WHETHER ATOM IS REALLY ISOTROPIC OR SPHERE, LINE, RING
              IF (NINT(ABS(U)) .EQ. 2) THEN
                  IKEY=7
              ELSE IF (NINT(ABS(U)) .GE. 3) THEN
                  IKEY=9
              ENDIF
C----- CHECK LISTING LEVEL
              IF(ILEVEL<=0) then !2305,2305,2330
C----- CHECK IF ANY PARAMETER HAS AN ESD
                  if(all(abs(BPD(1:IKEY))<1e-6)) then
C----- ALL ESD TOO SMALL- NO NEED TO PRINT
                      M12=ISTORE(M12)
                      M5=M5+MD5
                      M5A=M5A+MD5
                      cycle ! GOTO 2850
                  end if
              end if ! 2330    CONTINUE
C----- WE NEED A PRINT
C-C-C-CHECK WHETHER ATOM IS ANISO
              IF(ABS(U)-UISO>0.0) then !2550,2350,2350
C--ISO- PRINT
C-C-C-CHECK WHETHER ATOM IS REALLY ISOTROPIC OR SPHERE, LINE, RING
                  IF (NINT(ABS(U)) .EQ. 2) THEN ! 2510
C-C-C-SPHERE- PRINT
                      MD5A=M5+8
                      N5A=7
                      IF (ISSPRT .EQ. 0) then 
                          WRITE(NCWU,'(/5X,A4,F9.0,1X,11F9.4)')
     1                        (STORE(J),J=M5,MD5A)
                      end if
C--CHECK IF THE E.S.D.'S ETC. ARE TO BE PRINTED
                      IF(IPRINT/=0) then !2850,2520,2850
                          M12=ISTORE(M12)
                          M5=M5+MD5
                          M5A=M5A+MD5
                          cycle ! GOTO 2850
                      end if
C--PRINT THE SHIFTS AND E.S.D.'S
                      IF (ISSPRT .EQ. 0) THEN
                          WRITE(NCWU,'(19X,F9.4,9X,9F9.4)')(APD(1)), 
     1                        (APD(J),J=3,N5A)
                          WRITE(NCWU,'(19X,F9.4,9X,9F9.4)')(BPD(1)), 
     1                        (BPD(J),J=3,N5A)
                      END IF
                      GOTO 2750                      
                  ELSE IF (NINT(ABS(U)) .GE. 3) THEN
                      !GOTO 2530
                      ! does nothing
                  else              
C-C-C-ISO- PRINT
C                     MD5A=M5+6
                      MD5A=M5+7
C                     N5A=5
                      N5A=6
                      IF (ISSPRT .EQ. 0) then
                          WRITE(NCWU,2400)(STORE(J),J=M5,MD5A)
                      end if
2400    FORMAT(/5X,A4,F9.0,1X,11F9.4)
C--CHECK IF THE E.S.D.'S ETC. ARE TO BE PRINTED
                      IF(IPRINT/=0) then !2850,2450,2850
                          M12=ISTORE(M12)
                          M5=M5+MD5
                          M5A=M5A+MD5
                          cycle  ! GOTO 2850
                      end if
C--PRINT THE SHIFTS AND E.S.D.'S
                      IF (ISSPRT .EQ. 0) THEN
C                         WRITE(NCWU,2500)(APD(J),J=1,N5A)
                          WRITE(NCWU,2500)(APD(1)),(APD(J),J=3,N5A)
C2500   FORMAT(19X,11F9.5)
2500    FORMAT(19X,F9.4,9X,9F9.4)
C                         IF (ISSPRT .EQ. 0) THEN
C                         WRITE(NCWU,2500)(BPD(J),J=1,N5A)
                          WRITE(NCWU,2500)(BPD(1)),(BPD(J),J=3,N5A)
                      ENDIF
                      GOTO 2750     
C-C-C-SPHERE- PRINT
                      MD5A=M5+8
                      N5A=7
                      IF (ISSPRT .EQ. 0) then 
                          WRITE(NCWU,2515)(STORE(J),J=M5,MD5A)
                      end if
2515    FORMAT(/5X,A4,F9.0,1X,11F9.4)
C--CHECK IF THE E.S.D.'S ETC. ARE TO BE PRINTED
                      IF(IPRINT/=0) then !2850,2520,2850
                          M12=ISTORE(M12)
                          M5=M5+MD5
                          M5A=M5A+MD5
                          cycle  ! GOTO 2850
                      end if
C--PRINT THE SHIFTS AND E.S.D.'S
                      IF (ISSPRT .EQ. 0) THEN
                          WRITE(NCWU,2525)(APD(1)), (APD(J),J=3,N5A)
                          WRITE(NCWU,2525)(BPD(1)), (BPD(J),J=3,N5A)
2525    FORMAT(19X,F9.4,9X,9F9.4)
                      END IF
                      GOTO 2750                                   
                  ENDIF
C-C-C-LINE/RING- PRINT
                  MD5A=M5+10
                  N5A=9
                  IF (ISSPRT .EQ. 0) then 
                      WRITE(NCWU,2535) (STORE(J),J=M5,MD5A) 
                  end if
2535    FORMAT(/5X,A4,F9.0,1X,11F9.4)
C--CHECK IF THE E.S.D.'S ETC. ARE TO BE PRINTED
                  IF(IPRINT/=0) then !2850,2540,2850
                      M12=ISTORE(M12)
                      M5=M5+MD5
                      M5A=M5A+MD5
                      cycle  ! GOTO 2850
                  end if
C--PRINT THE SHIFTS AND E.S.D.'S
                  IF (ISSPRT .EQ. 0) THEN 
                      WRITE(NCWU,2545)(APD(1)),(APD(J),J=3,N5A)
                      WRITE(NCWU,2545)(BPD(1)),(BPD(J),J=3,N5A)
2545    FORMAT(19X,F9.4,9X,9F9.4)
                  END IF
                  GOTO 2750
C--ANISO- PRINT
               end if ! 2550    CONTINUE
C-C-C      MD5A=M5+2
C-C-C      N5A=M5+NKA-3
CDJW0102      MD5A=M5+13
              MD5A=M5+NKAV+1
              IF (ISSPRT .EQ. 0) THEN
C         WRITE(NCWU,2600)(STORE(J),J=M5,MD5A),(STORE(J+2),J=MD5A,N5A)
                  WRITE(NCWU,2600)(STORE(J),J=M5,MD5A)
              ENDIF
C2600   FORMAT(/5X,A4,F9.0,1X,F9.4,9X,10F9.4)
2600    FORMAT(/5X,A4,F9.0,1X,11F9.4)
C--CHECK IF THE E.S.D.'S ARE TO BE PRINTED
              IF(IPRINT/=0) then !2850,2650,2850
                  M12=ISTORE(M12)
                  M5=M5+MD5
                  M5A=M5A+MD5
                  cycle  ! GOTO 2850
              end if
C-C-C-IS THE NEXT STATEMENT REASONABLE ? (N5A NOT USED AGAIN)
              N5A=NKA-2
              IF (ISSPRT .EQ. 0) THEN
C        WRITE(NCWU,2700)APD(1),(APD(J-2),J=5,NKA)
CCCCCCNKA IS 20 NOW INSTEAD OF 18
C        WRITE(NCWU,2700)APD(1),(APD(J-2),J=5,NKA-4)
C-C-C-NKA IS 22 NOW INSTEAD OF 20
CDJW0102      WRITE(NCWU,2700)APD(1),(APD(J-2),J=5,NKA-6)
                  WRITE(NCWU,2700)APD(1),(APD(J),J=3,NKAV)
              ENDIF
2700    FORMAT(19X,F9.4,9X,10F9.4)
              IF (ISSPRT .EQ. 0) THEN
C         WRITE(NCWU,2700)BPD(1),(BPD(J-2),J=5,NKA)
C         WRITE(NCWU,2700)BPD(1),(BPD(J-2),J=5,NKA-4)
CDJW0102      WRITE(NCWU,2700)BPD(1),(BPD(J-2),J=5,NKA-6)
                  WRITE(NCWU,2700)BPD(1),(BPD(J),J=3,NKAV)
              ENDIF
C--PRINT THE POSITIONAL E.S.D.'S IN ANGSTROM
2750    CONTINUE
              BPD(3)=BPD(3)*STORE(L1P1)
              BPD(4)=BPD(4)*STORE(L1P1+1)
              BPD(5)=BPD(5)*STORE(L1P1+2)
CAPR07
              IF (ISTORE(M5) .EQ. transfer(JCARB, ISTORE(M5)) ) THEN
                  AESDC = AESDC + BPD(3)+BPD(4)+BPD(5)
                  NESDC=NESDC+3
              ENDIF
              IF (ISSPRT .EQ. 0) then
                  WRITE(NCWU,2800)(BPD(J),J=3,5)
              end if
2800    FORMAT(37X,3F9.4)
C--UPDATE FOR THE NEXT ATOM
              M12=ISTORE(M12)
              M5=M5+MD5
              M5A=M5A+MD5
          end do  ! 2900  CONTINUE
C--END OF THE UPDATING  -  PREPARE TO OUTPUT A NEW LIST 5
      end if !2950  CONTINUE
C NOW A PARAMETER      INCLUDE 'IDIM05.INC'
C--OUTPUT THE NEW LIST 5
      CALL XWLSTD(5,ICOM05,IDIM05,0,-1)
C----- SAVE THE MEAN C-C ESD
      WRITE ( CMON,'(a,f8.4)' ) 
     1  'Mean C-C su = ',AESDC/MAX(1.0, real(NESDC))
      call outcol(7)
      CALL XPRVDU(NCVDU, 1,0)
      call outcol(1)
      IF (ISSPRT .EQ.0) WRITE(NCWU,'(A)')cmon(1)
c
c
      STORE(L30CF+14) = AESDC/MAX(1.0, real(NESDC))
       CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
C
C----- CHECK THE ANISO TFS
C----- SET THE AUXILLIARY LIST 5 ADDRESSES
      L5A=L5
      N5A=N5
      MD5A=MD5
      M5A=M5
      CALL XPRAXI( -1, 1, 0, L5A, MD5A, N5A, 0, 0, 0)
      CALL XOPMSG ( IOPGNP , IOPEND , IVERSN )
      CALL XTIME2(2)
      RETURN
C
      END
c
c
CODE FOR RSTMSG
      SUBROUTINE RSTMSG(idjw,serial,js2,OLD,update,esd)
      implicit none
C      IDJW      ATOM NAME IN A4 CHARATER FORM
C      SERIAL    ATOM SERIAL NUMBER
C      JS2       PARAMETER ID (X=5,SCALE=21)
C      OLD       LSQ SHIFT
C      UPDATE    MODIFIED SHIFT
C      ESD       ESD
C
      character(len=6), dimension(11), parameter  :: ctype(11)=
     1    (/'Occ   ', 'U[iso]', 'x     ','y     ','z     ',
     2      'U[11] ', 'U[22] ', 'U[33] ', 
     3      'U[23] ', 'U[13] ', 'U[12] '/)
      character(len=10), dimension(6), parameter :: Covera(6)=
     1    (/'Scale     ', 'D[u]      ', 'O[u]      ', 
     2      'Polarity  ', 'Enantio   ', 'Extinction'/)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
      
      integer, intent(in) :: idjw, js2
      real, intent(in) :: serial, old, update, esd
      real a
      
      A=SIGN(1.,UPDATE)
      if (js2 .le. 13 ) then
        WRITE ( CMON,'(A, A4,I4,1x,A6,3(2x,a,F10.4))') 
     1 'Resetting shift for ',
     2  idjw,NINT(SERIAL),ctype(js2-2),'Shift= ', A*OLD, 'Esd= ',esd,
     3  'New shift= ',UPDATE
      else
c        Overall parameters
        WRITE ( CMON,'(A, A,3(2x,a,F10.2))') 
     1  'Resetting shift for ',covera(js2-20),
     1  'Shift= ', A*OLD, 'Esd= ',esd,
     2  'New shift= ',UPDATE
      endif
      CALL OUTCOL(3)
      CALL XPRVDU(NCVDU, 4,0)
      CALL OUTCOL(1)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') CMON(1)
      RETURN
      END
C
C
CODE FOR XAPSCL
      SUBROUTINE XAPSCL(IFIRST,IPRINT)
      implicit none
C--CALCULATE AND APPLY THE SHIFTS FOR LAYER OF ELEMENT SCALES
C
C  IFIRST  THE NUMBER OF THE FIRST SCALE THAT CAN BE USED
C  IPRINT  IF NOT ZERO, THEN ONLY THE NEW PARAMETERS ARE PRINTED.
C
C--VARIOUS CONTROL VARIABLES MUST BE SET :
C
C  M5A     ADDRESS OF THE FIRST SCALE
C  MD5A    THE NUMBER OF SCALES
C  M12     ADDRESS OF THE GROUP HEADER FOR THE SCALES
C
C--
      INCLUDE 'ISTORE.INC'
C
C
      real, dimension(14) :: BBC
C
      INCLUDE 'STORE.INC'
C
C
      integer, dimension(14) :: ibc
      real f
      real, dimension(11) :: bc
      COMMON /XWORK/F,BC,IBC
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST24.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
      EQUIVALENCE (BBC(1),IBC(1))
      
      integer i, iprint, ifirst
C
C--SET THE REFINEMENT POINTER TO INDICATE THAT REFINEMENT IS BEING DONE
      ND=0
C--CHECK IF THIS GROUP CONTAINS ANY PARTS
      IF(ISTORE(M12+1)<=0) then !1000,1000,1050
C--NO REFINEMENT FOR THIS PARAMETER GROUP
          ND=-1
      end if
      NA=IFIRST
      NB=0
C--CHECK IF THERE ARE ANY MORE SCALES TO LOOK AT
      do while(MD5A>0)
C--ALTER THE ADDRESSES FOR EACH OF THE PARTS
          L12A=ISTORE(M12+1)
C--CHECK IF THERE ARE ANY PARTS TO PROCESS
          IF(ND>=0) then !1350,1250,1250
              do 
                  ISTORE(L12A+2)=ISTORE(L12A+2)+NB*ISTORE(L12A+1)
                  ISTORE(L12A+4)=ISTORE(L12A+4)+NB
C--CHECK IF THERE ANY MORE PARTS
                  IF(ISTORE(L12A)>0) then !1350,1350,1300
                      L12A=ISTORE(L12A)
                      !GOTO 1250
                  else
                      exit
                  end if
              end do
C--CALCULATE THE NUMBER OF SCALES HERE AND OUTPUT A CAPTION
          end if

          NC=MIN(MD5A,11)
          DO I=1,NC !1400
              IBC(I)=NA+I-1
          end do
          APD(1:NC)=0.0
          BPD(1:NC)=0.0

          IF (ISSPRT .EQ. 0) THEN
              WRITE(NCWU,1450)(IBC(I),I=1,NC)
          ENDIF
1450  FORMAT(//1X,I6,10I9)
C--CHECK IF ANY MORE SCALES HAVE BEEN REFINED
          IF(ND>=0) then !1700,1500,1500
              L12A=ISTORE(M12+1)
              IF(ISTORE(L12A+2)<=ISTORE(L12A+3)) then !1550,1550,1700
                  !DO I=1,NC ! 1600
                  !    BBC(I)=BC(I)
                  !    BC(I)=0.
                  !end do
                  bbc(1:NC)=bc(1:NC)
                  bc(1:NC)=0.0

                  NE=1-NB
                  CALL XAPPLY(M5A,NC,NE)
                  IF ( IERFLG .LT. 0 ) exit
                  !DO I=1,NC ! 1650
                  !    BC(I)=BBC(I)
                  !end do
                  bc(1:NC)=bbc(1:NC)
              end if
          end if
C--PRINT THE RESULTS
          NE=M5A+NC-1
          IF (ISSPRT .EQ. 0) THEN
              WRITE(NCWU,1750)(STORE(I),I=M5A,NE)
          ENDIF
cRIC13:1750  FORMAT(/2X,11F9.5)
1750  FORMAT(/2X,11F9.3)
C--CHECK IF THE E.S.D.'S ETC. ARE TO BE PRINTED
          IF(IPRINT==0) then !1900,1800,1900
C--PRINT THE SHIFTS AND E.S.D.'S
              IF (ISSPRT .EQ. 0) THEN
                  WRITE(NCWU,1850)(APD(I),I=1,NC)
              ENDIF
              IF (ISSPRT .EQ. 0) THEN
                  WRITE(NCWU,1850)(BPD(I),I=1,NC)
              ENDIF
cRIC13:1850  FORMAT(2X,11F9.5)
1850  FORMAT(2X,11F9.3)
C--UPDATE FOR THE NEXT ROW
          end if

          MD5A=MD5A-NC
          M5A=M5A+NC
          NA=NA+NC
          L12A=ISTORE(M12+1)
C--CHECK IF THE LIST 12 NEEDS RESTORING
          IF(ND>=0) then !2050,1950,1950
              do 
                  ISTORE(L12A+2)=ISTORE(L12A+2)-NB*ISTORE(L12A+1)
                  ISTORE(L12A+4)=ISTORE(L12A+4)-NB
C--CHECK IF THERE ARE ANY MORE PARTS
                  IF(ISTORE(L12A)>0) then !2050,2050,2000
                      L12A=ISTORE(L12A)
                  else
                      exit
                  end if
              end do
          end if

          NB=NB+NC
      end do
C
      END subroutine
C
CODE FOR XAPPLY
      SUBROUTINE XAPPLY(LP,NPAR,IBIAS)
      implicit none
C--APPLY THE CALCULATED SHIFTS
C
C  APD    LOCATION OF THE APPLIED SHIFTS
C  BPD    LOCATION OF THE E.S.D.'S
C  LP     LOCATION OF THE PARAMETERS TO BE CORRECTED
C  NPAR   NUMBER OF PARAMETERS TO BE CORRECTED
C  IBIAS  RELATIVE VALUE TO OBTAIN THE FIRST VALUE IN LOCATION 1 OF APD
C
C--'BC' IS USED TO STORE THE CORRECTIONS TO THE T.F.'S
C
C  THE FOLLOWING VARIABLES ARE USED :
C
C  L24 SET ON ENTRY
C  JP
C
C  JR
C  JS  SET ON ENTRY FOR WORK SPACE
C  JT
C  JU
C  .
C  .
C  JZ
C
C--REQUIRES M12 SET ON ENTRY
C
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
C
C
      real f
      real, dimension(11) :: bc
      integer, dimension(14) :: ibc
      COMMON /XWORK/F,BC,IBC
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST24.INC'
      INCLUDE 'XERVAL.INC'
C
      INCLUDE 'QSTORE.INC'
      
      integer, intent(in) :: lp, npar, ibias
            
      real, external :: xvar
      integer, external :: KBLCK
C
C--CLEAR THE TEMPORARY STORAGE
C
      APD(1:NPAR)=0.0
      BPD(1:NPAR)=0.0

C--CHECK IF ANY COORDINATES HAVE BEEN REFINED
      IF(ISTORE(M12+1)>0) then !1100,1100,1050
          L12A=ISTORE(M12+1)
          IF(ISTORE(L12A+3)<0) then !1100,1150,1150
              return
          end if
      else 
          return
      end if
      MD12A=ISTORE(L12A+1)
      JU=ISTORE(L12A+2)
      JV=ISTORE(L12A+3)
      JT=ISTORE(L12A+4)
      JP=JT+IBIAS
C--SEARCH FOR THE CONTRIBUTIONS TO EACH PARAMETER IN TURN
      DO JW=JU,JV,MD12A ! 1850
          IF(ISTORE(JW)>0) then !1800,1800,1200
              APD(JP)=BC(JP)
              JX=JW
              JY=L12A 
              JR=JS
              JZ=0
C--CHECK IF THIS PART FOR THIS PARAMETER HAS BEEN REFINED
              do while(JY>0)
                  IF(ISTORE(JX)>0) then !1550,1550,1300
C--CHECK IF THERE IS ENOUGH CORE FOR THIS CONTRIBUTOR
                      IF ( JR + 4 - LFL >0 ) then ! 1400 , 1400 , 9910
C -- CORE OVEFLOW
                          CALL XICA
                          CALL XERHND ( IERERR )
                          return
                      end if
C--ADD THE CONTRIBUTIONS INTO THE STACK
                      ISTORE(JR)=ISTORE(JX)
                      ISTORE(JR+2)=KBLCK(ISTORE(JR))
                      ISTORE(JR+1)=M12B
                      STORE(JR+3)=1.
                      IF(ISTORE(JY+1)/=1) then ! 1450,1500,1450
                          STORE(JR+3)=STORE(JX+1)
                      end if
                      JR=JR+4
                      JZ=JZ+1
C--CALCULATE THE CONTRIBUTION OF THIS PART TO THE SHIFT
                      JX=(ISTORE(JX)-1)*MD24+L24
                      APD(JP)=APD(JP)+STORE(JX+1)*STORE(JR-1)
                  end if
C--CARRY ONTO THE NEXT PART

                  JY=ISTORE(JY)
                  do while(JY>0)
C--MOVE ONTO THE NEXT PART  -  CHECK FOR REFINEMENT OF THIS PARAMETER
                      JX=ISTORE(JY+2)+ISTORE(JY+1)*(JT-ISTORE(JY+4))
                      IF(JX-ISTORE(JY+2)==0) then
                          exit
                      else if(JX-ISTORE(JY+2)>0) then
                          IF(ISTORE(JY+3)-JX>=0) then
                              exit
                          end if
                      end if
                      JY=ISTORE(JY)
                  end do 
              end do 
C--NO MORE PARTS  -  CHECK IF THIS PARAMETER HAS BEEN REFINED
              IF(JZ>0) then !1800,1800,1750
C--CALCULATE THE E.S.D.
                  BPD(JP)=XVAR(JS,JZ,4,JR)
                  BPD(JP)=SQRT(BPD(JP)*F)
              end if
          end if
          JT=JT+1
          JP=JP+1
      end do ! 1850  CONTINUE
C--APPLY THE SHIFTS
      JX=LP
      DO JY=1,NPAR ! 1900
          STORE(JX)=STORE(JX)+APD(JY)
          JX=JX+1
      end do ! 1900  CONTINUE
C
      end subroutine
CODE FOR XLSDEL
      SUBROUTINE XLSDEL(A,B,C)
      implicit none
c----- output shift summary info to punch
      DIMENSION A(6), B(3), C(3)
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      
      real, intent(in) :: a,b,c
      integer i
      
      WRITE(NCPU,100)
     1 (A(I),I=1,3),
     1 (A(3+I),I=1,3),
     2 (B(I),I=1,3),
     3 (C(I),I=1,3)
100   FORMAT ('# ', 4(3F9.5,3X))
      RETURN
      END      

Code for open_normalfile
C --- Subroutine for opening a new file for outputing the normal matrix into.
C fileid - The file id to open the file under.
      Subroutine open_normalfile(fileid)
      implicit none

      integer fileid, filecount, i
      logical file_exists
      character*255 file_name

      filecount = 0
      file_exists = .true.
      do while (file_exists)
         write(file_name, '(a,i4,a)'), 'normal', filecount, '.m'
         call xcras(file_name, i) 
         inquire(FILE=FILE_NAME(1:i), EXIST=file_exists)
         filecount = filecount + 1
      end do
      OPEN(fileid, FILE=file_name, STATUS='UNKNOWN')
      end subroutine open_normalfile

