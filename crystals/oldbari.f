C $Log: not supported by cvs2svn $
C Revision 1.4  2003/08/05 11:11:10  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.3  2001/02/26 10:24:13  richard
C Added changelog to top of file
C
C Commented out whole file. None of this is called.
C
CCODE FOR XSPINC
C      SUBROUTINE XSPINC
CC--
CC-- INITIALIZATION SUBROUTINE FOR SPECIAL POSITIONS FROM CRYSTALS
CC--
CC-- SOPER  SYMMETRY OPERATORS MATRIX
CC-- CENTRT TRANSLATION MATRIX FOR NON PRIMITIVE LATTICE
CC-- AAA    CONSTANTS TO COMPUTE ATOSM DISTANCES
CC-- NOPER  NUMBER OF SYMMETRI OPERATORS
CC-- NCENTR NUMBER OF TRANSLATION MATRICIES
CC-- ICENT  = 0  NONCENTROSYMMETRIC SPACE GROUP
CC--        = 1  CENTROSYMMETRIC SPACE GROUP
CC-- KPOL   = 0  NO FLOATING ORIGIN
CC--        > 0  FLOATING ORIGIN (SEE SUBR. FLORIG)
CC-- JSYS   CRYSTAL FAMILY
CC-- LAT    =  1   2   3   4   5   6   7
CC--           P   A   B   C   F   I   R
CC-- INDV,MPV  UTILITY ARRAY
CC-- JSPINI = +1 COMMON /SPEC/ ALREADY FILLED
CC--        = -1 COMMON /SPEC/ ACTUALLY NOT INITIALIZED
CC--        =  0  SIR ENVIRONMENT - DO NOT MIND ABOUT INITIALIZATION
CC-- DDMIN  MINIMUN DISTANCE TO DEFINE A PEAK
CC--        BEING IN GENERAL POSITION
C      DIMENSION KCENTR(7),ABC(3),ANG(3),IBRVC(7)
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *             KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAX,NCWX
C\ISTORE
CC
C\STORE
C\XUNITS
C\XSSVAL
C\XLISTI
C\XLST01
C\XLST02
C\XLST05
C\XCONST
C\XSPECC
CC
C\QSTORE
CC
CC     CONVERSION ARRAY FROM CRYSTALS TO SIR CENTRING
C        DATA IBRVC / 1, 6, 7, 5, 2, 3, 4/
CC     SIR NOTATION        P, A, B, C, F, I, R
CC     CRYSTALS NOTATION   P, I, R, F, A, B, C
CC
C      XSPINI = -1
C      IF (KHUNTR (1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
C      IF (KHUNTR (2,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL02
C      IF (IERFLG .LE. 0) RETURN
C      XSPINI = +1
CC
CC----- REFORMAT THE SYMMETRY INFORMATION
C      NOPER = N2
C      ICENT = IC
C      M2 = L2
C      DO 800, K=1,N2
C        DO 810 I = 1,3
C          DO 820 J=1,3
CC---        ROTATIONAL SYMMETRY ELEMENTS
CCGIANLUCAS ORIGINAL            SOPER(J,I,K) = NINT(STORE(M2))
C            SOPER(I,J,K) = NINT(STORE(M2))
C            M2 = M2 + 1
C820       CONTINUE
C810     CONTINUE
C        DO 830 I =  1,3
CC--       TRANSLATIONAL ELEMENTS
C          SOPER(I,4,K) = STORE(M2)
C          M2 = M2 + 1
C830     CONTINUE
C800   CONTINUE
CC
CC-- INITIALIZE OUTPUT CHANNELS
CC
C      NCAX = NCAWU
C      NCWX = NCWU
CC
CC-- CELL PARAMETERS, CENT AND LATTICE CODE NEEDED
CC
C      DO 920 I=1,3
C         ABC(I)= STORE(L1P1+I-1)
C         ANG(I)= STORE(L1P1+3  )
C  920 CONTINUE
C      AAA(1)=ABC(1)*ABC(1)
C      AAA(2)=ABC(2)*ABC(2)
C      AAA(3)=ABC(3)*ABC(3)
C      AAA(4)=2.0*ABC(1)*ABC(2)*COS(ANG(3))
C      AAA(5)=2.0*ABC(1)*ABC(3)*COS(ANG(2))
C      AAA(6)=2.0*ABC(2)*ABC(3)*COS(ANG(1))
CC-- CRYSTAL FAMILY - WE ONLY NEED TO KNOW IF
CC--                  SPACE GROUP IS TRIGONAL OR EXAGONAL
CC--                  IN THIS CASE  JSYS = 5
CC--                  OTHERWISE          = 0
C      JSYS=0
C      DO 930 I=1,3
C  930 ANG(I)=ANG(I)*RTD
C      SUM1=0.0
C      SUM2=0.0
C      DO 935 I=1,2
C      SUM1=SUM1+ABC(I)
C  935 SUM2=SUM2+ANG(I)
C      SUM1=SUM1/2.0
C      SUM2=SUM2/2.0
C      IF (ABS(SUM1-ABC(1)).LT.ZERO.AND.
C     *    ABS(SUM2-90.00).LT.ZERO.AND.
C     *    ABS(ANG(3)-120.0).LT.ZERO) JSYS=5
CC
CC----- REFORMAT CENTRINGS
C      LAT = IBRVC(IL)
CC----- NO OF CENTRINGS
C      DO 940 I=2,6
C  940 KCENTR(I)=2
C      KCENTR(1)=1
C      KCENTR(5)=4
C      KCENTR(7)=3
C      NCENTR=KCENTR(LAT)
C      RETURN
C      END
CC
CC
CC-- SIR CODE FOR SPECLIB
CC**********************************************************************
CC        SPECIAL POSITION LIBRARY FLOW DIAGRAM
CC
CC --->-----+---------------------------+--------------->----
CC        XSPINB(*)                  KSPECB
CC        XFLORI       +-----------+----+-----+----------+
CC                  XNUOVA       XELLES      XTHERM    XPRING
CC            +--------+---------+
CC          XEQUI   XDISTB     XDEPA
CC                             XCMAT
CC
CC   ALSO AVAILABLE XWRIFL TO PRINT INFORMATION ABOUT FLOAT. ORIGIN
CC                  XSP12  TO GENERATE A BLOCK OF LIST 12
CC                  XCMPRP TO COMPRESS A STRING
CC
CC   (*) THIS SUBROUTINE IS THE ONLY PACKAGE-SPECIFIC ONE
CC
CC**********************************************************************
CC-----------------------------------------------------
CCODE FOR XSPINB
C      SUBROUTINE XSPINB
CC--
CC-- INITIALIZATION SUBROUTINE FOR SPECIAL POSITIONS
CC--
CC-- SOPER  SYMMETRY OPERATORS MATRIX
CC-- CENTRT TRANSLATION MATRIX FOR NON PRIMITIVE LATTICE
CC-- AAA    CONSTANTS TO COMPUTE ATOMS DISTANCES
CC-- NOPER  NUMBER OF SYMMETRI OPERATORS
CC-- NCENTR NUMBER OF TRANSLATION MATRICIES
CC-- ICENT  = 0  NONCENTROSYMMETRIC SPACE GROUP
CC--        = 1  CENTROSYMMETRIC SPACE GROUP
CC-- KPOL   = 0  NO FLOATING ORIGIN
CC--        > 0  FLOATING ORIGIN (SEE SUBR. FLORIG)
CC-- JSYS   CRYSTAL FAMILY
CC-- LAT    =  1   2   3   4   5   6   7   (ERLANGEN)
CC--           P   A   B   C   F   I   R
CC-- LAT    =  P   A   B   C   I   F   R   (MULTAN)
CC-- INDV,MPV  UTILITY ARRAY
CC-- JSPINI = +1 COMMON /SPEC/ ALREADY FILLED
CC--        = -1 COMMON /SPEC/ ACTUALLY NOT INITIALIZED
CC--        =  0  SIR ENVIRONMENT - DO NOT MIND ABOUT INITIALIZATION
CC-- DDMIN  MINIMUN DISTANCE TO DEFINE A PEAK
CC--        BEING IN GENERAL POSITION
C      DIMENSION KCENTR(7),ABC(3),ANG(3)
C      COMMON/UNIT/LN,LO,IFOUR,JREL,ISCRA,JHOST,PI,ITLE(20),NPC
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C      COMMON /ERL/ KMAT(48,3,3),TMAT(48,3),NT(16),JSYSX,NGEN
C     *,IROT(48,48),JSVET(10),ISVET(8),NORI,MODUL(3),NSS(3)
C      COMMON/TAPE/CELL(6),NEQV,ICENTX,LATX,NATM,TS(3,24),IS(2,3,24),NSYM
C     *              ,DUMA(3)
C      DIMENSION LATXV(7)
C      DATA LATXV/1,2,3,4,6,5,7/
CC
CC-- INITIALIZE OUTPUT CHANNELS
CC
C      NCAWU=LO
C      NCWU =LO
CC
CC-- CELL PARAMETERS, CENT AND LATTICE CODE NEEDED
CC
C      TWOPI=8*ATAN(1.0)
C      LAT=LATXV(LATX)
C      ICENT=ICENTX
C      JSYS=JSYSX
C      DO 10 I=2,6
C   10 KCENTR(I)=2
C      KCENTR(1)=1
C      KCENTR(5)=4
C      KCENTR(7)=3
C      DO 20 I=1,3
C         ABC(I)=CELL(I)
C         ANG(I)=CELL(I+3)*TWOPI/360.0
C   20 CONTINUE
C      AAA(1)=ABC(1)*ABC(1)
C      AAA(2)=ABC(2)*ABC(2)
C      AAA(3)=ABC(3)*ABC(3)
C      AAA(4)=2.0*ABC(1)*ABC(2)*COS(ANG(3))
C      AAA(5)=2.0*ABC(1)*ABC(3)*COS(ANG(2))
C      AAA(6)=2.0*ABC(2)*ABC(3)*COS(ANG(1))
CC
C      NCENTR=KCENTR(LAT)
CC
CC-- AT THIS POINT I NEED MATRICIES TO FILL 'SOPER'
CC
C      NOPER=NEQV
C      DO 15 K=1,NEQV
C      DO 15 I=1,3
C      SOPER(I,4,K)=TMAT(K,I)
C      DO 15 J=1,3
C      SOPER(I,J,K)=KMAT(K,I,J)
C   15 CONTINUE
CC-- COMPUTE FLOATING ORIGIN CODE
C      CALL XFLORI
C      IF (JSPINI.NE.0) JSPINI=1
C      RETURN
C      END
CC----------------------------------------------------------------------
CCODE FOR UTIBLK
CC**** This file has been moved to PRESETS for compatibility, L. Macko
CCODE FOR XFLORI
C      SUBROUTINE XFLORI
CC
CC-- FLOATING ORIGIN SUBROUTINE
CC
CC-- KPOL CODE IS COMPUTED TO TAKE
CC-- INTO ACCOUNT FLOATING ORIGIN.
CC-- IF KPOL.EQ.0 THEN NO FLOATING ORIGIN
CC-- IF KPOL.NE.0 THEN THE FLOATING DIRECTION
CC--                   CORRESPONDS TO 1'S IN THE CODE
CC                     E.G.   KPOL=001 FLOAT. ORIGIN ALONG Z
CC                            KPOL=100 FLOAT. ORIGIN ALONG X
CC
C      DIMENSION JFL(3)
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C      IF (ICENT.EQ.1) THEN
C                        KPOL=0
C                      ELSE
C                        DO 60 K=1,3
C                          JFL(K)=0
C                          DO 50 I=1,NOPER
C                            DO 40 J=1,3
C                              JFL(K)=JFL(K)+SOPER(J,K,I)
C   40                       CONTINUE
C   50                     CONTINUE
C                          IF (JFL(K).NE.NOPER) THEN
CC--  NON - FLOATING DIRECTION
C                                                 JFL(K)=0
C                                               ELSE
CC--  FLOATING DIRECTION
C                                                 JFL(K)=1
C                                               ENDIF
C   60                   CONTINUE
C                        MULT=100
C                        KPOL=0
C                        DO 70 I=1,3
C                        KPOL=KPOL+JFL(I)*MULT
C                        MULT=MULT/10
C   70                   CONTINUE
C                      ENDIF
C      RETURN
C      END
CCODE FOR KSPECB
C      FUNCTION KSPECB(NEWVET,XO,XN,KEY,ITYPE,ISER,KHEAD,IACTN)
CC
CC-- FUNCTION TO HANDLE ATOMS IN SPECIAL POSITION
CC
CC   RETURN VALUE
CC          KSPECB = +1 ATOM IN GENERAL POSITION
CC                 = -1 ATOM IN SPECIAL POSITION
CC-- MEANING OF PARAMETERS
CC     XO    = ARRAY CONTAINING ORIGINAL VALUES FOR X,Y,Z,OCC,U'S,C-OCC
CC     XN    = ARRAY CONTAINING MODIFIED VALUES FOR X,Y,Z,OCC,U'S,C-OCC
CC    KEY    = ARRAY CONTAINING CONDITIONS FOR      X,Y,Z,    U'S,C-OCC
CC  ITYPE    = TYPE OF ATOM
CC   ISER    = SERIAL NUMBER
CC  KHEAD    =  0  HEADING FOR SPECIAL POSITION TO BE PRINT
CC           =  1  HEADING NOT TO BE PRINTED
CC     IACTN =     ACTION TO BE TAKEN :
CC           =  1  COMPUTE CRYSTALLOGRAPHIC OCCUPATION
CC           =  2  GENERATE KEY ARRAY AND UPDATE X'S AND U'S
CC           =  3  PRINT INFORMATION
CC    NEWVET = MATRIX CONTAINING INFORMATION ABOUT
CC             THE SYMMETRY OPERATORS INVOLVED
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C      DIMENSION XO(11),XN(11),KEY(10),NEWVET(48,3)
CC
C      DO 10 I=1,9
C   10 KEY(I)=I
C      KEY(10)=1
C      CALL XNUOVA(XO,XN,KEY,N,NEWVET,ISER)
C      KSPECB=1
C      IF (KEY(10).GT.1) THEN
C         KSPECB=-1
C         IF (IACTN.GT.1) THEN
C            IF (KEY(10).NE.1) THEN
C                                CALL XELLES(NEWVET,N,KEY)
C                                CALL XTHERM(NEWVET,N,KEY)
C                              ENDIF
C             IF (IACTN.GT.2) CALL XPRING(KEY,ITYPE,ISER,XN,KHEAD)
C                         ENDIF
C                        ENDIF
C      RETURN
C      END
CCODE FOR XNUOVA
C      SUBROUTINE XNUOVA(XO,XN,KEY,NR,NEWVET,ISER)
CC--
CC-- SUBROUTINES TO RECOGNIZE IF A PEAK IS IN A SPECIAL POSITION.
CC-- IF IT IS VERY CLOSE TO IT, THE PEAK IS "MOVED" IN IT.
CC--
CC-- CHECK IF ATOMS ARE IN SPECIAL POSITION
CC-- COMPUTING THE DISTANCE BETWEEN AN ATOM
CC-- AND ITS SYMMETRY EQUIVALENTS
CC--
C      DIMENSION XO(11),XN(11),KEY(10),VET(2)
C      DIMENSION XEQ(3),M(3,3),S(3),XB1(3),XB2(3),NEWVET(48,3)
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
CC
C      ISER = ISER
C      VET(1)= 1.0
C      VET(2)=-1.0
C      DO 20 I=1,11
C   20 XN(I)=XO(I)
C      DO 30 I=1,3
C      XB1(I)=XO(I)
C   30 XB2(I)=XO(I)
C      IFIN=ICENT+1
C      NR=0
C      DO 50 KT=1,NCENTR
C        DO 50 IFI=1,IFIN
C          COEF=VET(IFI)
C          DO 50 K=1,NOPER
C            IF (K.EQ.1.AND.IFI.EQ.1.AND.KT.EQ.1) GO TO 50
C            CALL XEQUI(XB2,K,COEF,XEQ,KT)
C            CALL XDISTB(XB2,XEQ,D,S)
C            IF (D.LE.DDMIN) THEN
C                              NR=NR+1
C                              NEWVET(NR,3)=K*COEF
C                              DO 40 J=1,3
C                                XB1(J)=XB1(J)+XB2(J)+S(J)
C   40                         CONTINUE
C                            ENDIF
C   50 CONTINUE
C      IF (NR.NE.0) THEN
C                DO 70 L=1,NR
C                   K=NEWVET(L,3)
C                   COEF=1.0
C                   IF (K.LT.0) THEN
C                                 K=-K
C                                 COEF=-1.0
C                               ENDIF
C                   DO 60 II=1,3
C                      DO 60 J=1,3
C                         M(II,J)=COEF*SOPER(II,J,K)
C   60              CONTINUE
C                   CALL XDEPAC(M,IND,INEW)
C                   NEWVET(L,1)=INEW
C                   NEWVET(L,2)=IND
C   70           CONTINUE
C                DO 80 J=1,3
C                   XB1(J)=XB1(J)/FLOAT(NR+1)
C   80           CONTINUE
C                ELSE
C                DO 90 J=1,3
C                   NEWVET(1,J)=1
C   90           CONTINUE
C                ENDIF
CC
C      KCOND=NR+1
C      DO 100 I=1,3
C  100 XN(I)=XB1(I)
C      XN(11)=1.0/FLOAT(KCOND)
C      KEY(10)=KCOND
C      RETURN
C      END
CCODE FOR XEQUI
C      SUBROUTINE XEQUI(XB2,K,COEF,XEQ,KT)
CC--
CC-- COMPUTES THE SYMMETRY EQUIVALENT OF AN ATOM
CC--
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C      DIMENSION XB2(3),XEQ(3)
CC
C      DO 10 L=1,3
C      KTL=(KT-1)*3+L
C      XEQ(L)=SOPER(L,4,K)+CENTRT(LAT,KTL)
C      DO 10 J=1,3
C   10 XEQ(L)=XEQ(L)+XB2(J)*COEF*SOPER(L,J,K)
C      RETURN
C      END
CCODE FOR XDISTB
C      SUBROUTINE XDISTB(XB2,XEQ,D,S)
CC--
CC-- SUBROUTINE USED TO COMPUTE THE DISTANCE BETWEEN
CC-- AN ATOM AND ITS EQUIVALENT
CC--
C      DIMENSION XEQ(3),XB2(3),DELTA(8,3),DP(3),DS(3),S(3)
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C\XSSVAL
CC
C      DO 20 I=1,3
C         D=XEQ(I)-XB2(I)
C         DP(I)=D-INT(D)
C         IF (DP(I).LE.0.0) THEN
C                           DS(I)=DP(I)+1.0
C                           ELSE
C                           DS(I)=DP(I)-1.0
C                           ENDIF
C   20 CONTINUE
C      DELTA(1,1)=DP(1)
C      DELTA(1,2)=DP(2)
C      DELTA(1,3)=DP(3)
C      DELTA(2,1)=DP(1)
C      DELTA(2,2)=DP(2)
C      DELTA(2,3)=DS(3)
C      DELTA(3,1)=DP(1)
C      DELTA(3,2)=DS(2)
C      DELTA(3,3)=DP(3)
C      DELTA(4,1)=DP(1)
C      DELTA(4,2)=DS(2)
C      DELTA(4,3)=DS(3)
C      DELTA(5,1)=DS(1)
C      DELTA(5,2)=DP(2)
C      DELTA(5,3)=DP(3)
C      DELTA(6,1)=DS(1)
C      DELTA(6,2)=DP(2)
C      DELTA(6,3)=DS(3)
C      DELTA(7,1)=DS(1)
C      DELTA(7,2)=DS(2)
C      DELTA(7,3)=DP(3)
C      DELTA(8,1)=DS(1)
C      DELTA(8,2)=DS(2)
C      DELTA(8,3)=DS(3)
C      DIMI=99999.9
C      DO 40 I=1,8
C         D2=DELTA(I,1)*DELTA(I,1)*AAA(1)
C     1     +DELTA(I,2)*DELTA(I,2)*AAA(2)
C     2     +DELTA(I,3)*DELTA(I,3)*AAA(3)
C     3     +DELTA(I,1)*DELTA(I,2)*AAA(4)
C     4     +DELTA(I,1)*DELTA(I,3)*AAA(5)
C     5     +DELTA(I,2)*DELTA(I,3)*AAA(6)
C      IF (D2 .LT. 0.0) THEN
C      IF (ISSPRT .EQ. 0) THEN
CC            WRITE(NCWU,100) D2
C      ENDIF
C100         FORMAT(1X, ' Negative distance found in XDIST ',G12.5,
C     1           ' Please show to DJW' )
C            D = SQRT (-D2)
C      ELSE
C            D = SQRT (D2)
C      ENDIF
C         IF (D.LT.DIMI) THEN
C                        DIMI=D
C                        DO 30 J=1,3
C                           S(J)=DELTA(I,J)
C   30                   CONTINUE
C                        ENDIF
C   40 CONTINUE
C      D=DIMI
C      RETURN
C      END
CCODE FOR XDEPAC
C      SUBROUTINE XDEPAC(M,IND,INEW)
CC--
CC-- USING A CODE ASSOCIATED TO THE MATRIX IN USE
CC-- FINDS OUT WHICH KIND OF SYMMETRY OPERATOR
CC-- IS INVOLVED
CC--
C      DIMENSION M(3,3)
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C\XSSVAL
CC
C      CALL XCMAT(M,MP)
CC
C      IN=0
C      DO 10 I=1,64
C         IF (MP.EQ.MPV(I)) IN=I
C   10 CONTINUE
CC
C      IF (IN.EQ.0) THEN
C      IF (ISSPRT .EQ. 0) THEN
C                      WRITE(NCWU,*) 'STOP SPECLIB - XDEPAC '
C      ENDIF
C      IF (ISSPRT .EQ. 0) THEN
C                      WRITE(NCWU,'(3I4)') ((M(I,J),J=1,3),I=1,3)
C                      WRITE(NCWU,'(I10)')      MP
C      ENDIF
CC                      STOP 'SPECLIB - XDEPAC '
C                      CALL GUEXIT (2002)
C                    ENDIF
CC
C      IND=IN
C      INW=1
C      IF (IN.GT.32) THEN
C                      INW=-1
C                      IN=IN-32
C                     ENDIF
C      INEW=INW*INDV(IN)
C      RETURN
C      END
CCODE FOR XCMAT
C      SUBROUTINE XCMAT(M,MP)
CC--
CC-- THIS SUBROUTINE IS USED TO TRANSFORM A ROTATIONAL
CC-- MATRIX IN A UNIQUE NUMBER TO USE LIKE A POINTER
CC-- TO RECOGNIZE WHICH KIND OF OPERATOR IS INVOLVED
CC-- ( MIRROR , 2-FOLD AXIS ETC. )
CC--
C      DIMENSION M(3,3)
CC
C      MP=0
C      IEXP=-1
C      DO 10 I=1,3
C         DO 10 J=1,3
C            IEXP=IEXP+1
C            IF (M(I,J).GE.0) THEN
C                               MP=MP+M(I,J)*2**IEXP
C                             ELSE
C                               MP=MP+2**IEXP+2**(IEXP+9)
C                             ENDIF
C   10 CONTINUE
C      RETURN
C      END
CCODE FOR XWRIFL
C      SUBROUTINE XWRIFL
CC
CC-- WRITE INFORMATION ABOUT FREELY FLOATING ORIGIN
CC
C      CHARACTER*3 XYZ,XYZFR
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C\XSSVAL
CC
C      KDUMMY=KPOL
C      XYZ='XYZ'
C      DO 10 I=1,3
C      J=4-I
C      IPR=MOD(KDUMMY,10)
C      KDUMMY=KDUMMY/10
C      XYZFR(J:J)=' '
C      IF (IPR.EQ.1) XYZFR(J:J)=XYZ(J:J)
C   10 CONTINUE
C      IF (ISSPRT .EQ. 0) THEN
C      IF (KPOL.NE.0) WRITE(NCWU,30) XYZFR
C      ENDIF
C   30 FORMAT(/,20X,
C     *' *** WARNING *** FREELY FLOATING ORIGIN ALONG ',A3,/)
C      RETURN
C      END
CCODE FOR XELLES
C      SUBROUTINE XELLES(NEWVET,N,KEY)
CC
CC-- THIS SUBROUTINE COMPUTES THE
CC-- CONDITIONS FOR LEAST SQUARES SHIFTS
CC
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C      INTEGER XEQ(3),XYZ(3),XYO(3),IFLC(3),KEY(10)
C      INTEGER MULT(3),NEWVET(48,3)
CC
C      NN=N+1
C      MULT(1)=-1
C      MULT(2)= 1
C      MULT(3)= 2
C      XYO(1)=3
C      XYO(2)=11
C      XYO(3)=13
C      DO 10 I=1,3
C         XYZ(I)=XYO(I)
C   10 CONTINUE
C      DO 30 M=1,N
C         COEF=1.0
C         K=NEWVET(M,3)
C         IF (K.LT.0) THEN
C                       K=-K
C                       COEF=-1
C                     ENDIF
C         DO 20 L=1,3
C            XEQ(L)=0
C            DO 20 J=1,3
C   20          XEQ(L)=XEQ(L)+XYO(J)*SOPER(L,J,K)*COEF
C         DO 25 J=1,3
C            IF (XYZ(J).NE.0) THEN
C                               XYZ(J)=XYZ(J)+XEQ(J)
C                             ENDIF
C   25 CONTINUE
C   26 FORMAT(2(3I4,5X),2X,I2,')',F5.1)
C   30 CONTINUE
C      IFL=0
C      DO 35 I=1,3
C      IF (XYZ(I).NE.0) THEN
C                         IF (MOD(XYZ(I),NN).NE.0) IFL=1
C                       ENDIF
C   35 CONTINUE
C      IF (IFL.EQ.0) THEN
C                      DO 38 I=1,3
C   38                 XYZ(I)=XYZ(I)/NN
C                    ENDIF
CC
C      DO 40 I=1,3
C         IFLC(I)=0
C   40 CONTINUE
C      K=0
C      DO 60 I=1,3
C      IF (XYZ(I).NE.0) THEN
C      IF (K.EQ.0) THEN
C                    K=1
C                    IF (XYZ(I).LT.0) THEN
C                                       DO 50 J=1,3
C                                          XYZ(J)=-XYZ(J)
C   50                                  CONTINUE
C                                     ENDIF
C                  ENDIF
C                  ENDIF
C   60 CONTINUE
C      DO 110 I=1,2
C         IF (IFLC(I).EQ.0) THEN
C            IF (XYZ(I).NE.0) THEN
C               K=1
C               IFL2=0
C               DO 80 J=I+1,3
C                  IFL1=0
C                  DO 70 L=1,3
C                     IF (XYZ(I)*MULT(L).EQ.XYZ(J)) THEN
C                                                     IFLC(J)=MULT(L)
C                                                     IFLC(I)=1
C                                                     IFL1=1
C                                                   ENDIF
C                     IF (IFL1.EQ.0) THEN
C                     IF (XYZ(I).EQ.XYZ(J)*MULT(L)) THEN
C                                                     IFLC(I)=MULT(L)
C                                                     IFLC(J)=1
C                                                     IFL1=1
C                                                   ENDIF
C                                    ENDIF
C   70             CONTINUE
C               IFL2=IFL2+IFL1
C   80          CONTINUE
C                  IF (IFL2.NE.0) THEN
C                                  L=0
C                                  DO 90 J=1,3
C                                     IF (IFLC(J).NE.0) THEN
C                                                         IF (L.EQ.0) L=J
C                                                       ENDIF
C   90                             CONTINUE
C                                  DO 100 J=1,3
C                           IF (IFLC(J).NE.0) XYZ(J)=XYO(L)*IFLC(J)
C  100                             CONTINUE
C                                 ENDIF
C                             ENDIF
C                       ENDIF
C  110 CONTINUE
C      DO 130 I=1,3
C         IFL=0
C         IF (XYZ(I).NE.0) THEN
C                          DO 120 J=1,3
C                             DO 120 K=1,3
C                                IF (XYZ(I).EQ.XYO(J)*MULT(K)) IFL=1
C  120                     CONTINUE
C                          IF (IFL.EQ.0) XYZ(I)=XYO(I)
C                          ENDIF
C  130 CONTINUE
C      DO 150 J=1,3
C         IF (XYZ(J).NE.0) THEN
C            DO 140 K=1,3
C                    IF (XYZ(J).EQ.XYO(K))   THEN
C                                              XYZ(J)=K
C               ELSE IF (XYZ(J).EQ.2*XYO(K)) THEN
C                                              XYZ(J)=20+K
C               ELSE IF (XYZ(J).EQ.-XYO(K))  THEN
C                                              XYZ(J)=-K
C                                             ENDIF
C  140       CONTINUE
C         ENDIF
C  150 CONTINUE
C      DO 155 I=1,3
C        IX=XYZ(I)
C        IFL=0
C        IF (IX.LT.0) THEN
C                       DO 153 J=1,3
C                          IF (XYZ(J).EQ.-IX) IFL=1
C  153                  CONTINUE
C                       IF (IFL.EQ.0) XYZ(I)=-XYZ(I)
C                     ENDIF
C  155 CONTINUE
C      DO 160 I=1,3
C  160 KEY(I)=XYZ(I)
C      IF (KEY(3).EQ.23.OR.KEY(3).EQ.-3) KEY(3)=3
C      RETURN
C      END
CCODE FOR XPRING
C      SUBROUTINE XPRING(KEY,ITYPE,ISER,XN,KHEAD)
CC
CC-- PRINT SYMMETRY RESTRICTIONS ON ATOMIC PARAMETRS
CC
CC--   KEY  ARRAY CONTAINING SYMMETRY RESTRICTIONS
CC   ITYPE  ATOM TYPE (HOLLERITH*4)
CC    ISER  SERIAL
CC      XN  ARRAY CONTAINING VALUES FOR ATOMIC PARAMETERS
CC
C      CHARACTER LINE*42,KEYC(9)*2
C      DIMENSION KEY(10),XN(11)
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C\XSSVAL
C      DATA KEYC/' X',' Y',' Z','11','22','33','23','13','12'/
CC
C      K=1
C      MM=5
C      DO 80 J=1,9
C      IF (J.LE.4) THEN
C                    MM=4
C                  ELSE
C                    MM=5
C                  ENDIF
C       KJ=KEY(J)
C       L=K+5
C       IF (KJ.GE.0) THEN
C            IF (KJ.EQ.0) THEN
C                           WRITE(LINE(K:L),'(''  0  '')')
C       ELSE IF (KJ.LE.J) THEN
C                           WRITE(LINE(K:L),'(1X,A2,3X)') KEYC(KJ)
C       ELSE IF (KJ.GT.9) THEN
C            IF (KJ.GT.20) THEN
C                          KJ=KJ-20
C                          WRITE(LINE(K:L),'(A2,''*2 '')') KEYC(KJ)
C                          ELSE
C                          KJ=KJ-10
C                          WRITE(LINE(K:L),'(A2,''/2 '')') KEYC(KJ)
C                          ENDIF
C       ELSE IF (KJ.LT.J) THEN
C                           WRITE(LINE(K:L),'(1X,A2,2X)') KEYC(KJ)
C                         ENDIF
C                    ELSE
C                      KJ=-KJ
C                      IF (J.LE.3) THEN
C                          WRITE(LINE(K:L),'('' -'',A1,2X)')KEYC(KJ)(2:2)
C                                  ELSE
C                          WRITE(LINE(K:L),'(''-'',A2,2X)') KEYC(KJ)
C                                  ENDIF
C                    ENDIF
C       K=K+MM
C   80 CONTINUE
CC
C      IF (JSPINI.NE.0) THEN
CC
CC-- CRYSTALS OUTPUT
CC
C         IF (KHEAD.EQ.0) THEN
C      IF (ISSPRT .EQ. 0) THEN
C                           WRITE(NCWU,100)
C      ENDIF
C                           KHEAD=1
C  100 FORMAT(' TYPE SERIAL    SYMMETRY RESTRICTIONS ',
C     2       'ON ATOMIC PARAMETERS')
C                         ENDIF
C      IF (ISSPRT .EQ. 0) THEN
C         WRITE(NCWU,200) ITYPE,ISER,LINE
C      ENDIF
C  200 FORMAT(2X,A4,I4,4X,A42)
C                       ELSE
CC
CC-- SIR OUTPUT
CC
C      IF (ISSPRT .EQ. 0) THEN
C         WRITE(NCWU,300) (XN(I),I=1,3),XN(11),LINE
C      ENDIF
CC  300 FORMAT('+',45X,3F7.3,F8.4,1X,A42)
C  300 FORMAT(1X,45X,3F7.3,F8.4,1X,A42)
C                       ENDIF
C      RETURN
C      END
CCODE FOR XSP12
C      SUBROUTINE XSP12(KEY,ITYPE,ISER,NCHAN)
CC
CC-- GENERATE LIST 12
CC
CC--   KEY =  ARRAY CONTAINING CONDITIONS ABOUT X'S U'S
CC-- ITYPE =  TYPE OF ATOM
CC--  ISER =  SERIAL NUMBER
CC-- NCHAN =  OUTPUT CHANNNEL
CC
C      CHARACTER KEYC(9)*5,ITEM*16,LINE*80
C      INTEGER KEY(10),EQU(9),WEI(9),FIX(9),IWQ(9)
C      DATA KEYC/'X    ','Y    ','Z    ',
C     *          'U[11]','U[22]','U[33]','U[23]','U[13]','U[12]'/
CC
C      IFIX=0
C      IWEI=0
C      IEQU=0
C      DO 100 I=1,9
C      IW1=0
C      K=KEY(I)
C      IF (K.NE.I) THEN
C              IF (K.EQ.0) THEN
C                            IFIX=IFIX+1
C                            FIX(IFIX)=I
C                          ELSE
C                IF (K.LT.0) THEN
C                              IW1=-1
C                              IW2=I
C                              KEY(I)=-K
C           ELSE IF (K.GT.9) THEN
C                              IW1=2
C                              IW2=I
C                              KEY(I)=MOD(K,20)
C                            ENDIF
C                            IF (IW1.NE.0) THEN
C                                            IWEI=IWEI+1
C                                            WEI(IWEI)=IW1
C                                            IWQ(IWEI)=IW2
C                                          ENDIF
C                          ENDIF
C                  ENDIF
C  100 CONTINUE
C      IF (IFIX.NE.0) THEN
C          DO 103 I=8,80
C  103     LINE(I:I)=' '
C          LINE(1:7)='FIX    '
C          IP=11
C          DO 105 I=1,IFIX
C             WRITE(ITEM,110) ITYPE,ISER,KEYC(FIX(I))
C             CALL XCMPRP(ITEM,LITEM)
C             WRITE(LINE(IP:IP+LITEM-1),'(A)') ITEM(1:LITEM)
C             IP=IP+LITEM+4
C  105     CONTINUE
C          WRITE(NCHAN,'(A)') LINE
C        ENDIF
C      IF (IWEI.NE.0) THEN
C          DO 108 I=8,80
C  108     LINE(I:I)=' '
C          LINE(1:7)='WEIGH  '
C          IP=8
C          DO 109 I=1,IWEI
C             WRITE(ITEM,110) ITYPE,ISER,KEYC(IWQ(I))
C             CALL XCMPRP(ITEM,LITEM)
C             WRITE(LINE(IP:IP+LITEM+2),'(I2,1X,A)')
C     *             WEI(I),ITEM(1:LITEM)
C             IP=IP+LITEM+4
C  109 CONTINUE
C      WRITE(NCHAN,'(A)') LINE
C      ENDIF
C  110 FORMAT(A4,'(',I4,',',A5,')')
C      DO 200 I=1,8
C      IF (KEY(I).EQ.0) GO TO 200
C      IEQU=0
C      DO 150 J=I+1,9
C      IF (KEY(J).EQ.0) GO TO 150
C      IF (KEY(J).EQ.KEY(I)) THEN
C                      IF (IEQU.EQ.0) THEN
C                                        IEQU=IEQU+1
C                                        EQU(IEQU)=I
C                                      ENDIF
C                             IEQU=IEQU+1
C                             EQU(IEQU)=J
C                             KEY(J)=0
C                           ENDIF
C  150 CONTINUE
C      IF (IEQU.NE.0) THEN
C          DO 106 K=8,80
C  106     LINE(K:K)=' '
C          LINE(1:7)='EQUIV  '
C          IP=11
C          DO 107 K=1,IEQU
C             WRITE(ITEM,110) ITYPE,ISER,KEYC(EQU(K))
C             CALL XCMPRP(ITEM,LITEM)
C             WRITE(LINE(IP:IP+LITEM-1),'(A)') ITEM(1:LITEM)
C             IP=IP+LITEM+4
C  107     CONTINUE
C          WRITE(NCHAN,'(A)') LINE
C        ENDIF
C  200 CONTINUE
C      RETURN
C      END
CCODE FOR XCMPRP
C      SUBROUTINE XCMPRP(STRING,LSTRI)
CC
C      CHARACTER*(*) STRING
C      CHARACTER IB
CC
C      IB=' '
C      K=LEN(STRING)
C      J=1
C      DO 10 I=1,K
C      IF (STRING(I:I).NE.IB) THEN
C                               STRING(J:J)=STRING(I:I)
C                               J=J+1
C                             ENDIF
C   10 CONTINUE
C      LSTRI=J-1
C      IF (J.LE.K) THEN
C                    DO 20 I=J,K
C   20               STRING(I:I)=IB
C                  ENDIF
C      RETURN
C      END
CCODE FOR XTHERM
C      SUBROUTINE XTHERM(NEWVET,NR,KEY)
CC
CC-- THIS SUBROUTINE COMPUTES THE CONDITIONS FOR
CC-- THERMAL PARAMETERS ACCORDING TO:
CC
CC           W.J.A.M. PETERSE AND J.H. PALME
CC           ACTA CRYST. (1966). 20, 147
CC
C      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
C     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
C      INTEGER NEWVET(48,3),IVET(48),S,Q(3,3),BINV(9,6),IJT(6,2),ITT(6)
C      INTEGER Q12,Q13,Q23,VTERM(6),BIN1(6,6),KEY(10)
CC
C      DO 10 I=1,6
C         VTERM(I)=99
C   10 CONTINUE
C      ITT(1)=1
C      ITT(2)=5
C      ITT(3)=9
C      ITT(4)=6
C      ITT(5)=3
C      ITT(6)=2
C      DO 18 K=1,6
C      ICT=0
C      DO 15 I=1,3
C      DO 15 J=1,3
C      ICT=ICT+1
C      IF (ICT.EQ.ITT(K)) THEN
C                           IJT(K,1)=I
C                           IJT(K,2)=J
C                         ENDIF
C   15 CONTINUE
C   18 CONTINUE
C      IVET(1)=1
C      DO 20 I=1,NR
C         IVET(I+1)=NEWVET(I,3)
C   20 CONTINUE
C      N=NR+1
C      KK=0
C      DO 50 I=1,3
C         DO 50 J=1,3
C            DO 30 K=1,3
C               DO 30 L=1,3
C                  Q(K,L)=0
C                  DO 30 JS=1,N
C                     COEF=1.0
C                     S=IVET(JS)
C                     IF (S.LT.0) THEN
C                                   S=-S
C                                   COEF=-1
C                                 ENDIF
C                     Q(K,L)=Q(K,L)+SOPER(I,K,S)*SOPER(J,L,S)
C   30             CONTINUE
C         Q12=Q(1,2)+Q(2,1)
C         Q13=Q(1,3)+Q(3,1)
C         Q23=Q(2,3)+Q(3,2)
C         KK=KK+1
C         DO 40 K=1,3
C            BINV(KK,K)=Q(K,K)
C   40    CONTINUE
C         BINV(KK,4)=Q12
C         BINV(KK,5)=Q13
C         BINV(KK,6)=Q23
C   50 CONTINUE
C      DO 60 K=1,6
C         ISK=0
C         I=IJT(K,1)
C         J=IJT(K,2)
C         KK=ITT(K)
C         DO 60 L=1,6
C            BIN1(K,L)=BINV(KK,L)
C   60 CONTINUE
C      IF (JSYS.EQ.5) THEN
C                       DO 70 I=4,6
C                          DO 70 L=1,6
C                             BIN1(I,L)=2*BIN1(I,L)
C   70                  CONTINUE
C                     ENDIF
C      DO 90 I=1,6
C         KI=IJT(I,1)
C         KJ=IJT(I,2)
C         IFL=0
C         DO 80 J=1,6
C            IF (BIN1(I,J).NE.0) IFL=1
C   80    CONTINUE
C         IF (IFL.EQ.0) VTERM(I)=0
C   90 CONTINUE
C      KK=1
C      DO 120 I=1,5
C         ICH=0
C         IF (VTERM(I).EQ.99) THEN
C                               DO 110 K=I+1,6
C                                     DO 110 IS=-1,1,2
C                                      DO 110 JS=0,1
C                                        JSC=MOD(JS+1,2)
C                                        DO 110 LS=0,1
C                                        LSC=MOD(LS+1,2)
C                                        MI=LS*2**JS+LSC
C                                        MK=LS*2**JSC+LSC
C                                        IFLS=0
C                                        DO 100 J=1,6
C                                           IBI=BIN1(I,J)*MI
C                                           IBK=BIN1(K,J)*IS*MK
C                                           IF (IBI.NE.IBK) IFLS=1
C  100                                   CONTINUE
C                                        IF (IFLS.EQ.0) THEN
C                                            IF (ICH.EQ.0) KK=KK+1
C                                            ICH=1
C                                            VTERM(I)=KK*MK
C                                            VTERM(K)=KK*IS*MI
C                                            ENDIF
C  110                          CONTINUE
C                               IF (VTERM(I).EQ.99) VTERM(I)=1
C                             ENDIF
C  120 CONTINUE
C      IF (VTERM(6).EQ.99) VTERM(6)=1
C      JPREVA=0
C      JPREVB=0
C      DO 150 I=1,6
C         VTERM(I)=6-VTERM(I)
C               IF (VTERM(I).EQ.0) THEN
C                                    IF (JPREVB.EQ.0) THEN
C                                                 VTERM(I)=20+I
C                                                 JPREVB=I
C                                                ELSE
C                                                  VTERM(I)=20+JPREVB
C                                                ENDIF
C          ELSE IF (VTERM(I).EQ.3) THEN
C                                    IF (JPREVB.EQ.0) THEN
C                                                  VTERM(I)=I
C                                                  JPREVB=I
C                                                ELSE
C                                                  VTERM(I)=JPREVB
C                                                ENDIF
C          ELSE IF (VTERM(I).EQ.4) THEN
C                                    IF (JPREVA.EQ.0) THEN
C                                                  VTERM(I)=I
C                                                  JPREVA=I
C                                                ELSE
C                                                  VTERM(I)=JPREVA
C                                                ENDIF
C          ELSE IF (VTERM(I).EQ.5) THEN
C                                    VTERM(I)=I
C          ELSE IF (VTERM(I).EQ.6) THEN
C                                    VTERM(I)=0
C          ELSE IF (VTERM(I).EQ.9) THEN
C                                    IF (JPREVB.EQ.0) THEN
C                                                  VTERM(I)=-I
C                                                  JPREVB=I
C                                                ELSE
C                                                  VTERM(I)=-JPREVB
C                                                ENDIF
C                                  ENDIF
C  150 CONTINUE
C      DO 170 J=4,9
C      I=J-3
C      JV=VTERM(I)
C      IF (JV.NE.0) THEN
C         IF (JV.LE.9) THEN
C                        JV=JV+3*ISIGN(1,JV)
C                      ELSE
C                        JV=(MOD(JV,20)+3)+20
C                      ENDIF
C                   ENDIF
C  170 KEY(J)=JV
C      IF (KEY(9).LE.6.AND.KEY(9).GE.4) KEY(9)=KEY(9)+10
C      RETURN
C      END

