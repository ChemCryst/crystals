      PROGRAM MAIN
C
#if defined(CRY_FORTDIGITAL)
      interface
        subroutine no_stdout_buffer
        !dec$ attributes c :: no_stdout_buffer
        end subroutine
      end interface
#else
      interface
        subroutine no_stdout_buffer() bind(c)
          use, intrinsic :: ISO_C_BINDING
          implicit none
        end subroutine
      end interface
#endif

      INTEGER IO(3,3), ONAM(4), IY(6), BUF(2000)
      COMMON CEL(6),A,B,C,DELTA,DELT1,IO,IF,LT,LP,LZ
      CHARACTER *80 FILENM
#if defined(_HOL_)
          DATA IY/1HY,1HN,1HO,1Hy,1Hn,1Ho/
#else
      DATA IY/'Y','N','O','y','n','o'/
#endif

      call no_stdout_buffer()

      LT = 6
      LP = 1
      LZ=5
      IF = 0
      WRITE(LT,910)
      WRITE(LT,911)
911   FORMAT(
     1 'Delaunay Reduction Program - authors E.J.Fitzgerald,'/
     2 ' P.R.Mallinson, March 1971 - February 1972,'/
     3 ' after P.A.Tucker, December 1968.'/
     4 'Corrected, extended, and transformation matrices added by'/
     5 ' David L. Hughes, July 1979.'/
     6 'Interactive version for Prime,  D.L.H., February 1981.'/
     7 'ALTRIX, for better triclinic cells, added by D.L.H., ',
     8 'November 1982.'/
     9 'VAX Version Changes by T.K. Dickens.')
      GO TO 2
1      WRITE(LT,'('' Error Please Re:'')')
2      WRITE(LT,'('' Output file name: '')')
      READ(LZ,'(A80)',ERR=1,END=99) FILENM
      OPEN(UNIT=LP,ACCESS='SEQUENTIAL',
     .      FORM='FORMATTED',STATUS='unknown',FILE=FILENM)
      GO TO 10
    5      GOTO(10,27,10,10,27,10),I
   10      CALL DLPRE
      IF(IF.NE.0) CALL REDUC
      WRITE(LT,900)
      READ(LZ,901) IA
      DO 25 I=1,6
      IF(IA.EQ.IY(I)) GO TO 5
   25      CONTINUE
   27  WRITE(LP,902)
      WRITE(LT,902)
      STOP
99    STOP ' END OF FILE INPUT WHILE TRYING TO READ'
900   FORMAT (' Another set of data - Y or N')
901   FORMAT (A1)
902   FORMAT (/ ' DELRED completed'//)
903   FORMAT (' Printer file failed to open')
904   FORMAT (' Printer file failed to close')
905   FORMAT (' Reply not recognised.  Try again')
906   FORMAT (' Printer file failed to truncate')
907   FORMAT (' File system error.  Spooling failed.')
908   FORMAT (' Your spool file, ', 3A2, ', is', I4, ' records long.')
909   FORMAT (' Printer file ', 4A2, ' failed to delete.')
910   FORMAT(' DELRED, a Delaunay reduction program',/,1X)
      END
      SUBROUTINE DLPRE
C       SETS UP ARBITRARY PRIMITIVE CELL FROM INPUT DATA.
C       CALLED BY DELRED.
      INTEGER TYPE(14), IO(3,3), FACT(4), TITLE(20)
      REAL F(3), CPA(3)
      DIMENSION CP(6),X(108),Y(108),Z(108),ISUB(3),DD(3,3),
     * DIST(108),PROD(3)
      COMMON CEL(6),A,B,C,DELTA,DELT1,IO,IF,LT,LP,LZ
#if defined(_HOL_)
      DATA TYPE/1HP,1HR,1HA,1HB,1HC,1HI,1HF,
     1 1Hp,1Hr,1Ha,1Hb,1Hc,1Hi,1Hf/
      DATA FACT/4H(*0., 4H5)  , 4H    , 4H    /
#else
      DATA TYPE/'P','R','A','B','C','I','F',
     1 'p','r','a','b','c','i','f'/
      DATA FACT/'(*0.', '5)', '    ', '  '/
#endif

C       STATEMENT FUNCTIONS
      ANGLE(A,B,C)=(B+C-A)/(2.*SQRT(B*C))
      ANORM(X1,Y1,Z1)=SQRT(X1*X1+Y1*Y1+Z1*Z1)
C
      WRITE (LT,915)
      READ (LZ,909) TITLE
      WRITE (LT,912)
      READ (LZ,*) CP
      WRITE (LP,910) TITLE, CP
10    WRITE (LT,913)
      READ (LZ,914) LA
      DO 20 I=1,14
      IF (LA.EQ.TYPE(I)) GO TO 30
20    CONTINUE
      WRITE (LT,916)
      GO TO 10
30    CONTINUE
      IF (I .GT. 7) I = I-7
      IND3 = I
      DELTA = 0.001
      DELT1 = 0.1
      IF (CP(4)-1.)60,60,40
40    DO 50 I=4,6
50    CP(I)=COS(CP(I)*3.1415927/180.)
60    IF(CP(1).GT.1.0) GO TO 70
      CALL CCP(CP)
70    V=VOLE(CP)
      VLIM = V/500.
      SG=SQRT(1.-CP(6)*CP(6))
      WRITE (LT,908) V
      WRITE (LP,906) TYPE(IND3), CP
      WRITE (LP,908) V
      WRITE (LP,907) DELTA,VLIM
C       P LATTICE GENERATION
      N=0
      DO 120 I=1,3
      DO 120 J=1,3
      DO 120 K=1,3
      N=N+1
      X(N)=FLOAT(I)-2.
      Y(N)=FLOAT(J)-2.
      Z(N)=FLOAT(K)-2.
      GO TO (120,120,85,90,100,80,100),IND3
C       I LATTICE GENERATION
80    X(N+1)=X(N)+.5
      Y(N+1)=Y(N)+.5
      Z(N+1)=Z(N)+.5
      N=N+1
      GO TO 120
C       A LATTICE GENERATION
85    X(N+1)=X(N)
      Y(N+1)=Y(N)+.5
      Z(N+1)=Z(N)+.5
      N=N+1
      GO TO 120
C       B LATTICE GENERATION
90    X(N+1)=X(N)+.5
      Y(N+1)=Y(N)
      Z(N+1)=Z(N)+.5
      N=N+1
      GO TO 120
C       C LATTICE GENERATION
100   X(N+1)=X(N)+.5
      Y(N+1)=Y(N)+.5
      Z(N+1)=Z(N)
      N=N+1
C       F LATTICE GENERATION
      IF (IND3-6)120,110,110
110   X(N+1)=X(N)
      Y(N+1)=Y(N)-.5
      Z(N+1)=Z(N)+.5
      N=N+1
      X(N+1)=X(N)-.5
      Y(N+1)=Y(N)+.5
      Z(N+1)=Z(N)
      N=N+1
120   CONTINUE
      DO 130 I=1,N
130   DIST(I)=(X(I)*CP(1))**2+(Y(I)*CP(2))**2+(Z(I)*CP(3))**2+2.*X(I)*
     * Y(I)*CP(1)*CP(2)*CP(6)+2.*Y(I)*Z(I)*CP(2)*CP(3)*CP(4)+2.*X(I)*
     * Z(I)*CP(1)*CP(3)*CP(5)
C       SORT VECTOR LENGTHS INTO INCREASING ORDER
      N1=N-1
      DO 150 I=1,N1
      I1=I+1
      DO 150 J=I1,N
      IF (DIST(I)-DIST(J)-0.005)150,150,140
140   K = J-I-1
      TD=DIST(I)
      TX = X(I)
      TY = Y(I)
      TZ = Z(I)
      DIST(I)=DIST(J)
      X(I) = X(J)
      Y(I) = Y(J)
      Z(I) = Z(J)
      IF (K) 145,145,143
143   DO 144 L=1,K
      M = J-L
      DIST(M+1) = DIST(M)
      X(M+1) = X(M)
      Y(M+1) = Y(M)
144   Z(M+1) = Z(M)
145   DIST(I+1) = TD
      X(I+1) = TX
      Y(I+1) = TY
      Z(I+1) = TZ
150   CONTINUE
      WRITE (LP,903) N,(I,DIST(I),X(I),Y(I),Z(I),I=1,20)
C       APPLY COLLINEARITY AND COPLANARITY TESTS, SELECT ARBITRARY
C       PRIMITIVE CELL
      CEL(1) = SQRT(DIST(2))
      ISUB(1) = 2
      J = 1
      I1 = 2
      N1 = N-1
      DO 230 K=3,N1
      I2 = K
160   DD(J,J)=((X(I1)-X(I2))*CP(1))**2+((Y(I1)-Y(I2))*CP(2))**2+((Z(I1)-
     * Z(I2))*CP(3))**2+2.*(X(I1)-X(I2))*(Y(I1)-Y(I2))*CP(1)*CP(2)*CP(6)
     * +2.*(Y(I1)-Y(I2))*(Z(I1)-Z(I2))*CP(2)*CP(3)*CP(4)+2.*(X(I1)-
     * X(I2))*(Z(I1)-Z(I2))*CP(1)*CP(3)*CP(5)
      M = 7-J
      CEL(M) = ANGLE(DD(J,J), DIST(I1), DIST(I2))
      IF (1. - ABS(CEL(M)) - DELTA)170,170,190
170   GO TO (230,210,180),J
180   I1 = 2
      GO TO 210
190   GO TO (200,220,240),J
200   ISUB(2) = K
210   I2 = I2+1
      J = 2
      GO TO 160
220   ISUB(3) = I2
      I1 = ISUB(2)
      J = 3
      GO TO 160
cdjw moved into do-loop
240   CEL(2)=SQRT(DIST(I1))
      CEL(3)=SQRT(DIST(I2))
      V=VOLE(CEL)
      IF (V-VLIM) 250,250,270
250   IF (ISUB(3) - N)180,260,260
260   WRITE (LT,901)
      WRITE (LP,901)
      RETURN
cdjw moved into do-loop
C       TEST FOR RIGHT-HANDEDNESS (SEE IF ANGLE BETWEEN AXIS 3 AND
C       VECTOR PRODUCT OF AXES 1 AND 2 IS ACUTE).
270   DO 280 I=1,3
      I1=ISUB(I)
      DD(1,I)=CP(1)*X(I1)+CP(2)*CP(6)*Y(I1)+CP(3)*CP(5)*Z(I1)
      DD(2,I)=CP(2)*SG*Y(I1)+Z(I1)*CP(3)*(CP(4)-CP(5)*CP(6))/SG
280   DD(3,I)=Z(I1)*VOLE(CP)/(CP(1)*CP(2)*SG)
      DO 320 I=1,3
      J=I+1
      IF (J-3)300,300,290
290   J=J-3
300   kK=J+1
      IF (kK-3)320,320,310
310   kK=kK-3
320   PROD(I)=DD(J,1)*DD(kK,2)-DD(kK,1)*DD(J,2)
      A = (PROD(1)*DD(1,3)+PROD(2)*DD(2,3)+PROD(3)*DD(3,3))/
     * (ANORM(PROD(1),PROD(2),PROD(3))*ANORM(DD(1,3),DD(2,3),DD(3,3)))
      IF (A)250,330,330
330   A=ARCOS(A)*180./3.1415927
C       APPLY DELAUNAY REDUCTION TO ARBITRARY PRIMITIVE CELL
      IF = 3
      DO 340 I=1,3
      I1 = ISUB(I)
      IX = X(I1)
      IY = Y(I1)
      IZ = Z(I1)
      XX = IX
      YY = IY
      ZZ = IZ
      F(1) = ABS(X(I1)-XX)
      F(2) = ABS(Y(I1)-YY)
      F(3) = ABS(Z(I1)-ZZ)
      DO 340 J=1,3
      IF (F(J) - 0.001)340,340,350
340   CONTINUE
      GO TO 370
350   FAC = F(J)
      IF = 1
      DO 360 I=1,3
      I1 = ISUB(I)
      X(I1) = X(I1)/FAC
      Y(I1) = Y(I1)/FAC
360   Z(I1) = Z(I1)/FAC
370   DO 380 I=1,3
      I1 = ISUB(I)
      IO(I,1) = NINT(X(I1))
      IO(I,2) = NINT(Y(I1))
      IO(I,3) = NINT(Z(I1))
380   CPA(I) = ARCOS(CEL(I+3))*180./3.1415927
      WRITE (LP,904) ISUB
      WRITE (LP,911) ISUB(3),ISUB(1),ISUB(2),A
      WRITE (LT,902) (CEL(I),I=1,3), (CPA(I),I=1,3)
      WRITE (LP,902) (CEL(I),I=1,3), (CPA(I),I=1,3)
      WRITE (LT,908) V
      WRITE (LP,908) V
      N1 = IF
      N2 = IF + 1
      WRITE (LT,905) ((IO(I,J), J=1,3), I=1,3), (FACT(N),N=N1,N2)
      WRITE (LP,905) ((IO(I,J), J=1,3), I=1,3), (FACT(N),N=N1,N2)
      RETURN
900   FORMAT (' Collinearity test fault - DELTA too large',
     * ' - check cell data')
901   FORMAT (' Coplanarity test fault - volume limit too large',
     * ' - check cell data')
902   FORMAT (' Arbitrary primitive cell'/5X, 3F10.3, 3F9.2)
903   FORMAT (/' The first twenty shortest vectors (',I3,' generated)',
     * /7X, 'LENGTH**2',4X,'X/A',4X,'Y/B',4X,'Z/C'/20(I5,F9.2,2X,
     * 3F7.1/))
904   FORMAT (/' Numbers',I3,',',I3,' and',I3,' are chosen')
905   FORMAT (' Current transformation matrix is', 3(2X,3I3), 3X, 2A4//)
906   FORMAT (/' Initial real cell (Angstroms and cosines) - Lattice ',
     * 'type ', A1/ 5X, 3F10.3, 3F9.5)
907   FORMAT (/' DELTA for collinearity test =', F9.5//' Volume limit f'
     *, 'or coplanarity test =', F8.2)
908   FORMAT (8X, '*** Unit cell volume =', F9.2, ' ***')
909   FORMAT (20A4)
910   FORMAT (' DELRED : ',
     *   20A4,/,' Input unit cell dimensions',/,
     *   5X,6F10.5)
911   FORMAT (/' Intervectorial angle', I3,' with',I3,' cross',I3,' is',
     * F8.3,' degrees'//)
912   FORMAT(' Enter cell dimensions (real or recip., angles in degree',
     * 's or cosines) : ')
913   FORMAT (' Enter lattice type - one of P,R,A,B,C,I,F :')
914   FORMAT (A1)
915   FORMAT (' Enter title : ')
916   FORMAT (' Type not recognised'/)
c end of do loop
230   CONTINUE
      WRITE (LT,900)
      WRITE (LP,900)
      RETURN
      END
      SUBROUTINE REDUC
C       DELAUNAY REDUCTION ROUTINE, CALLED FROM DELRED.
      INTEGER TABLE(144),SECT(6),IY(6)
      INTEGER IK(12), INN(12,3,3), ION(3,3), IO(3,3), IOP(3,3), FACT(4)
      DIMENSION P(6),Q(6),INDEX(6),Y(7,12),R(6),CP(6),PP(6)
      COMMON CEL(6),A,B,C,DELTA,DELT1,ION,IF,LT,LP,LZ
      DATA TABLE/1,2,3,4,5,6,1,0,3,4,5,6,1,0,3,4,0,6,1,1,1,4,4,4,1,0,1,
     *4,0,1,1,0,0,4,1,1,1,2,1,4,5,4,1,2,3,1,5,3,1,0,3,4,5,1,1,0,1,4,5,4,
     *1,0,3,1,0,6,0,2,0,4,5,6,0,0,0,4,5,6,1,0,0,
     *4,5,5,1,2,0,1,2,0,1,2,3,1,2,3,1,0,3,3,5,1,1,2,1,1,5,1,0,0,0,4,4,6,
     *1,0,1,1,5,1,1,1,3,1,1,3,0,0,0,4,4,4,1,1,0,1,1,0,1,1,1,1,1,1/
#if defined(_HOL_)
      DATA FACT/4H(*0., 4H5)  , 4H    , 4H    /
      DATA IY/1HY,1HN,1HO,1Hy,1Hn,1Ho/
#else
      DATA FACT/'(*0.', '5)', '    ', '  '/
      DATA IY/'Y','N','O','y','n','o'/
#endif
C       CALCULATE SELLING PARAMETERS
      P(1) = CEL(2)*CEL(3)*CEL(4)
      P(2) = CEL(1)*CEL(3)*CEL(5)
      P(3) = CEL(1)*CEL(2)*CEL(6)
      P(4)=-1.*(CEL(1)**2+P(2)+P(3))
      P(5)=-1.*(CEL(2)**2+P(1)+P(3))
      P(6)=-1.*(CEL(3)**2+P(1)+P(2))
      DO 5 I=1,6
5     PP(I) = P(I)
      DO 10 M=1,3
      DO 10 N=1,3
10    IOP(M,N) = ION(M,N)
      DO 15 I=1,6
15    CP(I) = CEL(I)
      GO TO 35
20    DO 25 I=1,6
25    P(I) = PP(I)
      DO 30 M=1,3
      DO 30 N=1,3
30    ION(M,N) = IOP(M,N)
      WRITE (LT,910)
      READ (LZ,*) DELT1
35    ICN = 0
      IZ = 0
      IMP = 0
      WRITE (LP,913) DELT1
      N1 = IF
      N2 = IF + 1
      WRITE (LP,909) ICN,P,((ION(I,J),J=1,3),I=1,3),(FACT(N),N=N1,N2)
C       TEST FOR END OF REDUCTION
40    DO 45 I=1,6
      IF (P(I)-DELT1)45,45,55
45    CONTINUE
      DO 50 I=1,12
50    IK(I) = I
      GO TO 170
C       DELAUNAY REDUCTION, ONE CYCLE
55    IF (I-3)60,60,70
60    P(I+3)=P(I+3)-P(I)
      L=I+3
      GO TO 75
70    P(I-3)=P(I-3)-P(I)
      L=I-3
75    DO 90 J=1,6
      IF (J-I)80,90,80
80    IF (J-L)85,90,85
85    P(J)=P(I)+P(J)
90    CONTINUE
      DO 95 K=1,3
      DO 95 L=1,3
95    IO(K,L) = ION(K,L)
      GO TO (100,110,120,130,140,150),I
100   IN=2
      JN=6
      DO 105 M=1,3
      ION(1,M) = IO(1,M) + IO(3,M)
      ION(2,M) = IO(2,M)
105   ION(3,M) =-IO(3,M)
      GO TO 160
110   IN=1
      JN=6
      DO 115 M=1,3
      ION(1,M) = IO(1,M)
      ION(2,M) = IO(2,M) + IO(3,M)
115   ION(3,M) =-IO(3,M)
      GO TO 160
120   IN=1
      JN=5
      DO 125 M=1,3
      ION(1,M) = IO(1,M)
      ION(2,M) =-IO(2,M)
125   ION(3,M) = IO(2,M) + IO(3,M)
      GO TO 160
130   IN=5
      JN=6
      DO 135 M=1,3
      ION(1,M) = IO(1,M)
      ION(2,M) =-IO(1,M) - IO(3,M)
135   ION(3,M) =-IO(1,M) - IO(2,M)
      GO TO 160
140   IN=4
      JN=6
      DO 145 M=1,3
      ION(1,M) =-IO(2,M) - IO(3,M)
      ION(2,M) = IO(2,M)
145   ION(3,M) =-IO(1,M) - IO(2,M)
      GO TO 160
150   IN=4
      JN=5
      DO 155 M=1,3
      ION(1,M) =-IO(2,M) - IO(3,M)
      ION(2,M) =-IO(1,M) - IO(3,M)
155   ION(3,M) = IO(3,M)
160   Q1=P(IN)
      Q2=P(JN)
      P(IN)=Q2
      P(JN)=Q1
      P(I)=-1.*P(I)
      ICN=ICN+1
      DO 165 M=1,3
      DO 165 N=1,3
165   ION(M,N) = -ION(M,N)
      WRITE (LP,909) ICN,P,((ION(K,L),L=1,3),K=1,3),(FACT(N),N=N1,N2)
      GO TO 40
170   CALL DSHORT(P, Y, IK, ION, INN, IF, LT, LP)
C       SEARCH THE REDUCED PARAMETERS FOR ZEROS AND EQUALITIES AND
C       COMPARE WITH TABLE OF CONVENTIONAL CELLS.
      K=1
175   DO 180 I=1,6
180   Q(I)=Y(I,K)
      DO 210 J=1,6
      IF (ABS(Q(J))-DELT1)205,205,190
190   DO 200 I=1,6
      IF (ABS(Y(I,K)-Q(J))-DELT1)195,195,200
195   INDEX(J)=I
      GO TO 210
200   CONTINUE
      WRITE (LT,908)
      WRITE (LP,908)
      GO TO 655
205   INDEX(J)=0
210   CONTINUE
      L=1
      MM=6
      JIK=0
215   J=1
      IF (MM-144)280,280,220
220   K=K+1
      IF (K-12)175,175,225
cdjw225   IF (IZ)230,230,265
225   IF (IZ)230,230,267
230   DO 240 I=1,6
      R(I) = P(I)
      IF (R(I) + DELT1)240,235,235
235   IZ = IZ + 1
240   CONTINUE
      IF (IZ)275,275,245
245   DO 270 JJ=1,IZ
      IJ = 0
      DO 265 II=1,6
      IF (R(II) + DELT1)265,250,250
250   IJ = IJ + 1
      IF (IJ-JJ)265,255,265
255   DO 260 K=1,6
260   P(K) = R(K)
      I=II
      WRITE (LT,903)
      WRITE (LP,903)
      GO TO 55
265   CONTINUE
270   CONTINUE
267   continue
275   WRITE (LT,917) R
      WRITE (LT,907)
      WRITE (LP,907)
      CALL FAILD(R,DELT1,LT,LP)
      GO TO 655
280   DO 285 I=L,MM
      SECT(J)=TABLE(I)
285   J=J+1
      JIK=JIK+1
      DO 290 I=1,6
      IF (INDEX(I)-SECT(I))320,290,320
290   CONTINUE
      DO 295 I=1,6
295   P(I)=Y(I,K)
      DO 300 I=1,3
      DO 300 J=1,3
300   IO(I,J) = INN(K,I,J)
      WRITE(LP,901) K, ((IO(L,M),M=1,3),L=1,3), (FACT(N),N=N1,N2)
      WRITE (LT,900) P, JIK
      WRITE (LP,906) JIK
305   CALL CALCK(P(2)+P(4)+P(3),P(3)+P(5)+P(1),P(1)+P(6)+P(2))
      PIF = 180./3.1415927
      CEL(4) = PIF * ARCOS(P(1)/(B*C))
      CEL(5) = PIF * ARCOS(P(2)/(A*C))
      CEL(6) = PIF * ARCOS(P(3)/(A*B))
      WRITE (LT,902) CEL
      WRITE (LP,902) CEL
      IF(IMP)315,310,315
310   GO TO (325,325,325,345,355,365,375,385,415,445,455,465,520,530,
     *540,550,560,570,585,595,605,615,625,635),JIK
315   GO TO (435,510,405),IMP
C       CALCULATE THE BRAVAIS LATTICE PARAMETERS
320   L=L+6
      MM=MM+6
      GO TO 215
325   CALL CALCK(P(2)+P(4)+P(3),P(3)+P(5)+P(1),P(1)+P(6)+P(2))
      DO 330 M=1,3
      DO 330 N=1,3
330   ION(N,M) = IO(N,M)
      CALL CALCC(P(1)/(B*C),P(2)/(C*A),P(3)/(A*B),1,3,1)
      DO 335 I=1,6
335   CEL(I) = CP(I)
      DO 340 M=1,3
      DO 340 N=1,3
340   ION(M,N) = IOP(M,N)
      CALL CRYDA
      DO 342 I=1,3
      CEL(I) = CP(I)
      J = I+3
342   CEL(J) = ARCOS(CP(J)) * PIF
      DO 344 M=1,3
      DO 344 N=1,3
344   ION(M,N) = IOP(M,N)
      CALL ALTRIX
      WRITE (LT,917) P
      GO TO 655
345   CALL CALCK(P(4)+2.*P(1),P(4)+2.*P(1),P(4)+2.*P(1))
      DO 350 M=1,3
      ION(1,M) =-IO(2,M)
      ION(2,M) =-IO(1,M)
350   ION(3,M) =-IO(3,M)
      CALL CALCC(P(1)/A**2,P(1)/A**2,P(1)/A**2,4, 6,2)
      CALL ROHEX
      GO TO 655
355   CALL CALCK(P(4)+P(1),P(4)+P(1),P(4)+P(1))
      DO 360 M=1,3
      ION(1,M) = IO(1,M) + IO(2,M) + IO(3,M)
      ION(2,M) = IO(1,M)
360   ION(3,M) = IO(1,M) + IO(2,M)
      CALL CALCC(P(4)/(P(4)+P(1)),P(4)/(P(4)+P(1)),P(4)/(P(4)+P(1)),4,6,
     *2)
      CALL ROHEX
      GO TO 655
365   CALL CALCK(2.*P(1),2.*P(1),P(4))
      DO 370 M=1,3
      ION(1,M) = IO(2,M) + IO(3,M)
      ION(2,M) =-IO(2,M)
370   ION(3,M) = IO(1,M)
      CALL CALCC(0.,0.,-0.5,7,9,1)
      GO TO 655
375   CALL CALCK(2.*P(4)+2.*P(1),2.*P(4)+2.*P(1)+4.*P(2),P(5)+2.*P(1))
      DO 380 M=1,3
      ION(1,M) =-IO(1,M) - IO(3,M)
      ION(2,M) = IO(1,M) - IO(3,M)
380   ION(3,M) =-IO(2,M)
      CALL CALCC(0.,(2.*P(1))/(A*C),0.,10,12,4)
      GO TO 650
385   IF (P(1) - P(3))405,405,390
390   PT = P(1)
      P(1) = P(3)
      P(3) = PT
      P(4) = P(1)
      P(6) = P(3)
      DO 395 M=1,3
      ION(1,M) =-IO(1,M)
      ION(2,M) = IO(1,M) + IO(2,M) + IO(3,M)
395   ION(3,M) =-IO(3,M)
      DO 400 M=1,3
      DO 400 N=1,3
400   IO(N,M) = ION(N,M)
      IMP = 3
      GO TO 645
405   CALL CALCK(4.*P(2)+2.*P(1)+2.*P(3),2.*P(1)+2.*P(3),P(2)+P(5)+2.*
     *P(3))
      DO 410 M=1,3
      ION(1,M) = IO(1,M) - IO(3,M)
      ION(2,M) =-IO(1,M) - IO(3,M)
410   ION(3,M) = IO(2,M) + IO(3,M)
      CALL CALCC(0.,2.*(P(2)+P(3))/(A*C),0.,10,12,4)
      GO TO 650
415   IF (P(3) - P(4))420,435,435
420   PT = P(3)
      P(3) = P(4)
      P(4) = PT
      DO 425 M=1,3
      ION(1,M) =-IO(1,M)
      ION(2,M) = IO(1,M) + IO(2,M)
425   ION(3,M) = IO(3,M)
      DO 430 M=1,3
      DO 430 N=1,3
430   IO(M,N) = -ION(M,N)
      IMP = 1
      GO TO 645
435   CALL CALCK (4.*P(3)+4.*P(5)+2.*P(1),2.*P(1),P(4)+P(3))
      DO 440 M=1,3
      ION(1,M) = -(2*IO(2,M)) - IO(3,M)
      ION(2,M) = IO(3,M)
440   ION(3,M) =-IO(1,M)
      CALL CALCC(0.,2.*P(3)/(A*C),0.,10,12,4)
      GO TO 650
445   CALL CALCK(2.*P(4)+2.*P(1),2.*P(4)+2.*P(1),2.*P(1)+P(5))
      DO 450 M=1,3
      ION(1,M) =-IO(1,M) - IO(3,M)
      ION(2,M) = IO(1,M) - IO(3,M)
450   ION(3,M) =-IO(2,M)
      CALL CALCC(0.,2.*P(1)/(A*C),0.,10,12,4)
      GO TO 650
455   CALL CALCK(4.*P(3)+2.*P(1),2.*P(1),P(3)+P(6))
      WRITE (LT,904)
      WRITE (LP,904)
      DO 460 M=1,3
      DO 460 N=1,3
460   ION(N,M) = 0
      CALL CALCC(0.,2.*P(3)/(A*C),0.,10,12,4)
      GO TO 650
465   IF(P(2) - P(4))475,470,470
470   IF(P(2) - P(6))480,510,510
475   IF(P(4) - P(6))480,490,490
480   PT = P(6)
      P(6) = P(2)
      P(2) = PT
      DO 485 M=1,3
      ION(1,M) = IO(1,M) + IO(3,M)
      ION(2,M) = IO(2,M)
485   ION(3,M) =-IO(3,M)
      GO TO 500
490   PT = P(4)
      P(4) = P(2)
      P(2) = PT
      DO 495 M=1,3
      ION(1,M) =-IO(1,M)
      ION(2,M) = IO(2,M)
495   ION(3,M) = IO(1,M) + IO(3,M)
500   DO 505 M=1,3
      DO 505 N=1,3
505   IO(M,N) = -ION(M,N)
      IMP = 2
      GO TO 645
510   CALL CALCK(P(2)+P(4),P(5),P(2)+P(6))
      DO 515 M=1,3
      ION(1,M) =-IO(1,M)
      ION(2,M) = IO(2,M)
515   ION(3,M) =-IO(3,M)
      CALL CALCC(0.,P(2)/(A*C),0.,10,12,1)
      IF = -IF
      CALL CRYDA
      GO TO 655
520   CALL CALCK(P(4),P(5),P(6))
      DO 525 M=1,3
      ION(1,M) =-IO(1,M)
      ION(2,M) =-IO(2,M)
525   ION(3,M) = IO(3,M)
      CALL CALCC(0.,0.,0.,13,15,1)
      GO TO 580
530   CALL CALCK (2.*P(5)+4.*P(1),2.*P(5),1.*P(4))
      DO 535 M=1,3
      ION(1,M) =-IO(2,M) + IO(3,M)
      ION(2,M) = IO(2,M) + IO(3,M)
535   ION(3,M) =-IO(1,M)
      CALL CALCC(0.,0.,0.,13,15,4)
      GO TO 655
540   CALL CALCK(2.*P(1),2.*P(2),2.*P(1)+2.*P(2))
      DO 545 M=1,3
      ION(1,M) = IO(1,M) + IO(3,M)
      ION(2,M) =-IO(2,M) - IO(3,M)
545   ION(3,M) = IO(1,M) + IO(2,M)
      CALL CALCC(0.,0.,0.,13,15,5)
      GO TO 580
550   CALL CALCK(2.*P(3)+2.*P(1),2.*P(2)+2.*P(3),2.*P(1)+2.*P(2))
      DO 555 M=1,3
      ION(1,M) = IO(1,M) + IO(3,M)
      ION(2,M) = IO(2,M) + IO(3,M)
555   ION(3,M) =-IO(1,M) - IO(2,M)
      CALL CALCC(0.,0.,0.,13,15,5)
      GO TO 580
560   CALL CALCK(2.*P(3),2.*P(1),2.*P(3)+4.*P(5)+2.*P(1))
      DO 565 M=1,3
      ION(1,M) = IO(1,M)
      ION(2,M) =-IO(3,M)
565   ION(3,M) = IO(1,M) + (2*IO(2,M)) + IO(3,M)
      CALL CALCC(0.,0.,0.,13,15,5)
      GO TO 580
570   CALL CALCK(4.*(P(1)+P(2)),4.*(P(1)+P(5)),4.*P(1))
      DO 575 M=1,3
      ION(1,M) = IO(1,M) - IO(3,M)
      ION(2,M) = IO(1,M) + (2*IO(2,M)) + IO(3,M)
575   ION(3,M) = IO(1,M) + IO(3,M)
      CALL CALCC(0.,0.,0.,13,15,6)
580   IF = IF+10
      CALL CRYDA
      GO TO 655
585   CALL CALCK(P(4),P(4),P(6))
      DO 590 M=1,3
      ION(1,M) =-IO(1,M)
      ION(2,M) =-IO(2,M)
590   ION(3,M) = IO(3,M)
      CALL CALCC(0.,0.,0.,16,18,1)
      GO TO 655
595   CALL CALCK(2.*P(1),2.*P(1),4.*(P(5)+P(1)))
      DO 600 M=1,3
      ION(1,M) = IO(3,M)
      ION(2,M) = IO(1,M)
600   ION(3,M) = IO(1,M) + (2*IO(2,M)) + IO(3,M)
      CALL CALCC(0.,0.,0.,16,18,5)
      GO TO 655
605   CALL CALCK(2.*P(3)+2.*P(1),2.*P(3)+2.*P(1),4.*P(1))
      DO 610 M=1,3
      ION(1,M) = IO(1,M) + IO(3,M)
      ION(2,M) = IO(2,M) + IO(3,M)
610   ION(3,M) =-IO(1,M) - IO(2,M)
      CALL CALCC(0.,0.,0.,16,18,5)
      GO TO 655
615   CALL CALCK(P(4),P(4),P(4))
      DO 620 M=1,3
      ION(1,M) =-IO(1,M)
      ION(2,M) =-IO(2,M)
620   ION(3,M) = IO(3,M)
      CALL CALCC(0.,0.,0.,19,21,1)
      GO TO 655
625   CALL CALCK(4.*P(1),4.*P(1),4.*P(1))
      DO 630 M=1,3
      ION(1,M) =-IO(1,M) - IO(2,M) - (IO(3,M)*2.)
      ION(2,M) =-IO(1,M) - IO(2,M)
630   ION(3,M) =-IO(1,M) + IO(2,M)
      CALL CALCC(0.,0.,0.,19,21,6)
      GO TO 655
635   CALLCALCK(4.*P(1),4.*P(1),4.*P(1))
      DO 640 M=1,3
      ION(1,M) =-IO(2,M) - IO(3,M)
      ION(2,M) = IO(1,M) + IO(2,M)
640   ION(3,M) = IO(1,M) + IO(3,M)
      CALL CALCC(0.,0.,0.,19,21,5)
      GO TO 655
645   WRITE (LT,916) P
      WRITE (LP,905)
      ICN = ICN+1
      WRITE (LP,909) ICN,P,((IO(K,L),L=1,3),K=1,3),(FACT(N),N=N1,N2)
      GO TO 305
650   CALL ALMON
655   WRITE (LT,911) DELT1
660   READ (LZ,912) IA
      DO 665 I=1,6
      IF (IA.EQ.IY(I)) GO TO 670
665   CONTINUE
      WRITE (LT,915)
      GO TO 660
670   GO TO (20, 675, 20, 20, 675, 20), I
675   RETURN
900   FORMAT (' The Selling parameters'/7X, 6F9.3/
     * '    correspond to tetrahedron no.', I3//)
901   FORMAT (' No.', I3, ' is chosen.  Transformation matrix is',3(2X,
     * 3I3), 3X, 2A4)
902   FORMAT (' Reduced primitive cell dimensions'/5X, 3F10.3, 3F9.2)
903   FORMAT (/' Non-standard tetrahedron.  Trying zero transformation')
904   FORMAT (' Overall matrix not known ** Please come and see DLH.')
905   FORMAT (/' Symmetric transformation applied for improved reduced',
     * ' primitive cell')
906   FORMAT (/' Selling parameters match pattern of tetrahedron no.',
     * I3//)
907   FORMAT (' .....Reduced parameters do not correspond to a valid',
     * ' unit cell.....'//)
908   FORMAT (' Selling parameter indexing fault  - DELTA smaller',
     * ' than available precision')
909   FORMAT (1H , I4, 2X, 6F9.3, 3(2X, 3I3), 3X, 2A4)
910   FORMAT (' Enter new DELT1 value : ')
911   FORMAT ('    ******************************',//
     *' Recycle with a different DELT1 (currently',F7.3,') - Y or N : ')
912   FORMAT (A1)
913   FORMAT (' Selling parameters after successive cycles of reduct',
     * 'ion.'/'    Quantities greater than',F8.2, ' (DELT1) taken as ',
     * 'positive.'/ ' Cycle',6X,'P', 8X,'Q', 8X,'R', 8X,'S', 8X,'T', 8X,
     * 'U',6X,'Current transformation matrix')
914   FORMAT (I4, 2X, 6F9.3)
915   FORMAT (' Reply not recognised .  Try again')
916   FORMAT (' Symmetric transformation gives Selling parameters',
     * /7X, 6F9.3)
917   FORMAT (/' The Selling parameters are'/ 7X, 6F9.3)
      END
      SUBROUTINE DSHORT(P, Y, IK, IO, INN, IF, LT, LP)
C       OBTAIN THE 12 PERMUTATIONS OF P,Q,R,S,T,U CORRESPONDING TO
C       THE TETRAHEDRON ORIENTATIONS WITH RELATIVE POSITIONS OF EDGES
C       PRESERVED.  CALLED BY REDUC IN DELRED.
      INTEGER IK(12), IO(3,3), INN(12,3,3)
      INTEGER FACT(4)
      DIMENSION P(6),Z(6),Y(7,12)
#if defined(_HOL_)
      DATA FACT/4H(*0., 4H5)  , 4H    , 4H    /
#else
      DATA FACT/'(*0.', '5)', '    ', '  '/
#endif
      DO 10 I=1,6
10    Z(I)=P(I)
      CALL PERM3(Z,Y,1)
      Z(1)=P(4)
      Z(2)=P(5)
      Z(3)=P(3)
      Z(4)=P(1)
      Z(5)=P(2)
      Z(6)=P(6)
      CALL PERM3(Z,Y,4)
      Z(1)=P(2)
      Z(2)=P(3)
      Z(3)=P(1)
      Z(4)=P(5)
      Z(5)=P(6)
      Z(6)=P(4)
      CALL PERM3(Z,Y,7)
      Z(1)=P(4)
      Z(2)=P(2)
      Z(3)=P(6)
      Z(4)=P(1)
      Z(5)=P(5)
      Z(6)=P(3)
      CALL PERM3(Z,Y,10)
C       SORT DELAUNAY TETRAHEDRON ORIENTATIONS IN INCREASING ORDER OF
C       ABS(P)+ABS(Q)+ABS(R)
      DO 40 N=1,11
      M=N+1
      DO 40 J=M,12
      IF (Y(7,N)-Y(7,J)-0.2)40,40,20
20    K = J-N-1
      DO 30 I=1,7
      TEMP=Y(I,N)
      Y(I,N)=Y(I,J)
      IF (K) 30, 30, 23
23    DO 25 L=1,K
      M = J-L
25    Y(I,M+1) = Y(I,M)
30    Y(I,N+1) = TEMP
      IT = IK(N)
      IK(N) = IK(J)
      IF (K) 37, 37, 32
32    DO 35 L=1,K
      M=J-L
35    IK(M+1) = IK(M)
37    IK(N+1) = IT
40    CONTINUE
      CALL TWELM(IK, IO, INN)
      N1 = IF
      N2 = IF + 1
      WRITE (LP,900) (J, Y(7,J), (Y(I,J),I=1,6), IK(J), ((INN(J,K,L),L=
     * 1,3),K=1,3), (FACT(N),N=N1,N2), J=1,12)
      WRITE (LP,901)
      RETURN
900   FORMAT (/' The values of ABS(P)+ABS(Q)+ABS(R) and corresponding ',
     * 'Selling parameters'/'   for the 12 ordered orientations of the',
     * ' tetrahedron'/' No.  Sum',7X,'P',9X,'Q',9X,'R',9X,'S',9X,'T',9X,
     * 'U',5X,'Old   Current transformation matrix'/ 12(I3, F7.1,6F10.3,
     * I4, 2X, 3I3, 2X, 3I3, 2X, 3I3, 2X, 2A4/))
901   FORMAT (2X)
      END
      SUBROUTINE CALCC (D,E,F,M,N,MN)
C       BRAVAIS LATTICE PARAMETER ASSIGNMENT.  CALLED BY REDUC
C       IN DELRED.
      INTEGER TYPE(6), TITLE(21)
      DIMENSION  OI(3,3), CELL(6)
      COMMON CEL(6),A,B,C,DELTA,DELT1,IO(3,3),IF,LT,LP,LZ
#if defined(_HOL_)
      DATA TYPE/1HP,1HR,1HB,1HC,1HI,1HF/
      DATA TITLE/4HTRIC,4HLINI,1HC,4HRHOM,4HBOHE,4HDRAL,4HHEXA,4HGONA,
     * 1HL,4HMONO,4HCLIN,2HIC,4HORTH,4HORHO,4HMBIC,4HTETR,4HAGON,2HAL,
     * 4HCUBI,1HC,1H /
#else
      DATA TYPE/'P','R','B','C','I','F'/
      DATA TITLE/'TRIC','LINI','C','RHOM','BOHE','DRAL','HEXA','GONA',
     * 'L','MONO','CLIN','IC','ORTH','ORHO','MBIC','TETR','AGON','AL',
     * 'CUBI','C',' '/
#endif
      PIF=180./3.1415927
      CEL(4)=D
      CEL(5)=E
      CEL(6)=F
      V=VOLE(CEL) + 0.05
      CEL(4)=PIF * ARCOS(D) + 0.005
      CEL(5)=PIF * ARCOS(E) + 0.005
      CEL(6)=PIF * ARCOS(F) + 0.005
      WRITE (LT,907) (TITLE(J),J=M,N),TYPE(MN)
      WRITE (LP,903)
      WRITE (LP,904)
      WRITE (LP,900) (TITLE(J), J=M,N), TYPE(MN)
      WRITE (LP,904)
      IF (IF-2)10,30,30
10    DO 20 I=1,3
      DO 20 J=1,3
      OI(I,J) = IO(I,J)
20    OI(I,J) = OI(I,J) * 0.5
      WRITE (LT,902) (CEL(I),I=1,3), (OI(1,I),I=1,3), CEL(4), (OI(2,I),
     * I=1,3), CEL(5), (OI(3,I),I=1,3), CEL(6)
      WRITE (LP,902) (CEL(I),I=1,3), (OI(1,I),I=1,3), CEL(4), (OI(2,I),
     * I=1,3), CEL(5), (OI(3,I),I=1,3), CEL(6)
      GO TO 40
30    WRITE (LT,901) (CEL(I),I=1,3), (IO(1,I),I=1,3), CEL(4), (IO(2,I),
     * I=1,3), CEL(5), (IO(3,I),I=1,3), CEL(6)
      WRITE (LP,901) (CEL(I),I=1,3), (IO(1,I),I=1,3), CEL(4), (IO(2,I),
     * I=1,3), CEL(5), (IO(3,I),I=1,3), CEL(6)
40    WRITE (LT,905) V
      WRITE (LP,908) V
      DO 50 J=1,3
      I=J+3
      CEL(J) = CEL(J) - 0.00005
      CELL(J) = CEL(J)
      CEL(I) = CEL(I) - 0.005
      CELL(I) = CEL(I)
50    CEL(I) = COS(CEL(I)/PIF)
      CALL CCP(CEL)
      DO 60 I=4,6
      J = I-3
      CEL(J) = CEL(J) + 0.0000005
60    CEL(I)=PIF*ARCOS(CEL(I)) + 0.005
      WRITE (LP,906) CEL
      DO 70 I=1,6
70    CEL(I) = CELL(I)
      RETURN
900   FORMAT (15X,'* ',3A4,' Lattice type ',A1,' *')
901   FORMAT (/16X,'A =',F9.4,5X,'Overall transformation matrix is'/16X,
     * 'B =',F9.4,/16X,'C =',F9.4, 15X,3I3/12X,'Alpha =',F9.2, 15X,3I3/
     * 13X,'Beta =',F9.2, 15X,3I3/12X,'Gamma =',F9.2)
902   FORMAT (/16X,'A =',F9.4,5X,'Overall transformation matrix is'/16X,
     * 'B =',F9.4,/16X,'C =',F9.4, 13X,3F5.1/12X,'Alpha =',F9.2,13X,
     * 3F5.1/13X,'Beta =',F9.2, 13X,3F5.1/12X,'Gamma =',F9.2)
903   FORMAT (/' Conventional Bravais cell')
904   FORMAT (15X,'*******************************')
905   FORMAT (11X,'Volume =', F9.1)
906   FORMAT (' Reciprocal cell parameters'/ 5X, 3F10.6, 3F9.2//)
907   FORMAT (' Conventional Bravais cell :', 3A4, ' Lattice ',
     * 'type ', A1)
908   FORMAT (/ 10X, 'Volume =', F9.1//)
      END
      SUBROUTINE ALMON
C       DETERMINES CELLS AND TRANSFORMATION MATRICES OF ALTERNATIVE
C       MONOCLINIC CENTRED CELLS.  CALLED BY REDUC, IN DELRED.
      REAL X(5), Y(5), D(5), CBET(10)
      INTEGER ION(3,3), INC(3), FACT(4)
      COMMON CEL(6),A,B,C,DELTA,DELT1,IO(3,3),IF,LT,LP,LZ
#if defined(_HOL_)
      DATA INC/1HC, 1HI, 1HF/
      DATA FACT/4H(*0., 4H5)  , 4H    , 4H    /
#else
      DATA INC/'C', 'I', 'F'/
      DATA FACT/'(*0.', '5)', '    ', '  '/
#endif
      WRITE (LP,900)
      WRITE (LT,904)
      A = CEL(1)
      BST = (180. - CEL(5))*3.1415927/180.
      CC = CEL(3)*COS(BST)
      CS = CEL(3)*SIN(BST)
      N = 0
      X(1) = A
      X(2) = A - CC
      X(3) = A - 2.*CC
      X(4) = -CC
      X(5) =-A - CC
      Y(2) = CS
      Y(1) = 0.
      Y(3) = 2.*CS
      Y(4) = CS
      Y(5) = CS
      DO 10 I=1,5
10    D(I) = SQRT(X(I)*X(I) + Y(I)*Y(I))
      DO 20 I=1,4
      II = I+1
      DO 20 J=II,5
      N = N+1
      CBET(N) = (X(I)*X(J) + Y(I)*Y(J))/(D(I)*D(J))
      CB = CBET(N)
      BETA = ARCOS(CB)*180./3.1415927
20    CONTINUE
      ID = 0
30    BET = ABS(CBET(1))
      K = 1
      DO 50 N=2,10
      CB = ABS(CBET(N))
      IF (CB - BET)40,50,50
40    BET = CB
      K = N
50    CONTINUE
      DO 60 M=1,3
60    ION(2,M) = IO(2,M)
      KK = 0
      DO 70 I=1,4
      II = I+1
      DO 70 J=II,5
      KK = KK+1
      IF (KK-K)70,80,70
70    CONTINUE
80    IL = 0
      CB = CBET(K)
      GO TO(100,100,100,100,120,150,90,130,90,160),K
90    CBET(K) = 1.0
      GO TO 30
100   IC = 1
      DO 110 M=1,3
110   ION(1,M) = IO(1,M)
      GO TO 180
120   L = I
      I = J
      J = L
      IL = 1
130   IC = 1
      DO 140 M=1,3
140   ION(1,M) = IO(1,M) + (2*IO(3,M))
      GO TO 180
150   L = I
      I = J
      J = L
      IL = 1
160   IC = 2
      DO 170 M=1,3
170   ION(1,M) = IO(3,M)
180   GO TO(360,190,210,230,250),J
190   DO 200 M=1,3
200   ION(3,M) = IO(1,M) + IO(3,M)
      GO TO 270
210   IC = 3
      DO 220 M=1,3
220   ION(3,M) = IO(1,M) + (2*IO(3,M))
      GO TO 270
230   DO 240 M=1,3
240   ION(3,M) = IO(3,M)
      GO TO 270
250   DO 260 M=1,3
260   ION(3,M) = -IO(1,M) + IO(3,M)
270   IF (CB)300,300,280
280   CB = -CB
      DO 290 M=1,3
      DO 290 N=2,3
290   ION(N,M) = -ION(N,M)
300   IF (IL)310,330,310
310   DO 320 M=1,3
320   ION(2,M) = -ION(2,M)
330   CEL(1) = D(I)
      CEL(3) = D(J)
      CEL(5) = ARCOS(CB) * 180./3.1415927
      DO 340 L=1,3
      CEL(L) = CEL(L) + 0.0005
340   CEL(L+3) = CEL(L+3) + 0.005
      N1 = IF
      N2 = IF + 1
      ID = ID + 1
      WRITE (LP,901) CEL, INC(IC), ((ION(M,N),N=1,3),M=1,3), (FACT(N),N=
     *N1,N2)
      WRITE (LT,903) CEL, INC(IC), ((ION(M,N),N=1,3),M=1,3), (FACT(N),N=
     *N1,N2)
      DO 350 L=1,3
      CEL(L) = CEL(L) - 0.0005
350   CEL(L+3) = CEL(L+3) - 0.005
      CBET(K) = 1.0
      GO TO (30,30,370),ID
360   WRITE (LT,902)
      WRITE (LP,902)
370   WRITE (LT,905)
      RETURN
900   FORMAT (' Alternative centred monoclinic lattices, with beta ',
     * 'nearest to 90 deg.',/'    (Dimensions, Centred type, Overall',
     * ' transformation matrix)'/)
901   FORMAT (3F8.3, 3F7.2, 3X, A1, '-centred ', 3(2X, 3I3), 2X, 2A4)
902   FORMAT (' Something wrong - alternatives not found')
903   FORMAT (1H , 3F8.3, 3F7.2, 3X, A1, '-centred',/
     1 6X, 3(2X, 3I3), 2X, 2A4)
904   FORMAT (' Alternative centred monoclinic lattices, with beta ',
     * 'nearest to 90 deg.',/'    (Dimensions and Centred type)')
905   FORMAT (2X)
      END
      SUBROUTINE TWELM(IK, IO, INN)
C       ASSIGNS TRANSFORMATION MATRICES FOR THE TWELVE POSSIBLE
C       ORIENTATIONS OF THE REDUCED TETRAHEDRON.  CALLED BY DSHORT,
C       IN DELRED
      INTEGER IK(12), IO(3,3), INN(12,3,3)
      DO 140 N=1,12
      IKN = IK(N)
      DO 140 M=1,3
      GO TO (10,30,40,50,60,70,80,90,100,110,120,130),IKN
10    DO 20 I=1,3
20    INN(N,I,M) = IO(I,M)
      GO TO 140
30    INN(N,1,M) = IO(3,M)
      INN(N,2,M) = IO(2,M)
      INN(N,3,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      GO TO 140
40    INN(N,1,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      INN(N,2,M) = IO(2,M)
      INN(N,3,M) = IO(1,M)
      GO TO 140
50    INN(N,1,M) = IO(2,M)
      INN(N,2,M) = IO(1,M)
      INN(N,3,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      GO TO 140
60    INN(N,1,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      INN(N,2,M) = IO(1,M)
      INN(N,3,M) = IO(3,M)
      GO TO 140
70    INN(N,1,M) = IO(3,M)
      INN(N,2,M) = IO(1,M)
      INN(N,3,M) = IO(2,M)
      GO TO 140
80    INN(N,1,M) = IO(2,M)
      INN(N,2,M) = IO(3,M)
      INN(N,3,M) = IO(1,M)
      GO TO 140
90    INN(N,1,M) = IO(1,M)
      INN(N,2,M) = IO(3,M)
      INN(N,3,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      GO TO 140
100   INN(N,1,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      INN(N,2,M) = IO(3,M)
      INN(N,3,M) = IO(2,M)
      GO TO 140
110   INN(N,1,M) = IO(3,M)
      INN(N,2,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      INN(N,3,M) = IO(1,M)
      GO TO 140
120   INN(N,1,M) = IO(1,M)
      INN(N,2,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      INN(N,3,M) = IO(2,M)
      GO TO 140
130   INN(N,1,M) = IO(2,M)
      INN(N,2,M) =-IO(1,M) - IO(2,M) - IO(3,M)
      INN(N,3,M) = IO(3,M)
140   CONTINUE
      RETURN
      END
      SUBROUTINE CRYDA
C       TRANSFORMS CELLS OF TRICLINIC AND SOME MONOCLINIC AND
C       ORTHORHOMBIC SYSTEMS TO 'CRYSTAL DATA' CONVENTIONS.  CALLED
C       BY REDUC IN DELRED.
      REAL CEL(6), CEX(3)
      INTEGER IO(3,3), ION(3,3), FACT(4)
      COMMON CEL,A,B,C,DELTA,DELT1,IO,IF,LT,LP,LZ
#if defined(_HOL_)
      DATA FACT/4H(*0., 4H5)  , 4H    , 4H    /
#else
      DATA FACT/'(*0.', '5)', '    ', '  '/
#endif
      PIF = 180./3.1415927
      IF (IF - 10)10,370,170
C       TRICLINIC SYSTEMS, FROM ARBITRARY PRIMITIVE CELL
10    IF (IF)140,370,20
20    J1 = 1
      IF (CEL(5))40,40,30
30    J1 = J1+1
40    IF (CEL(6))60,60,50
50    J1 = J1+2
60    CE = CEL(1)
      CEL(1) = CEL(2)
      CEL(2) = CEL(3)
      CEL(3) = CE
      DO 70 M=1,3
      J2 = IO(1,M)
      IO(1,M) = IO(2,M)
      IO(2,M) = IO(3,M)
70    IO(3,M) = J2
      CE = CEL(4)
      CEL(4) = CEL(5)
      CEL(5) = CEL(6)
      CEL(6) = CE
      DO 80 I=4,6
80    CEL(I) = ARCOS(CEL(I))*PIF
      GO TO (350,90,100,110),J1
90    J1 = 1
      J2 = 3
      GO TO 120
100   J1 = 2
      J2 = 3
      GO TO 120
110   J1 = 1
      J2 = 2
120   DO 130 M=1,3
      IO(J1,M) = -IO(J1,M)
130   IO(J2,M) = -IO(J2,M)
      J1 = J1+3
      J2 = J2+3
      CEL(J1) = 180. - CEL(J1)
      CEL(J2) = 180. - CEL(J2)
      GO TO 350
C       MONOCLINIC P CELLS
140   IF = -IF
      IF (CEL(1) - CEL(3))150,350,350
150   CE = CEL(1)
      CEL(1) = CEL(3)
      CEL(3) = CE
      DO 160 M=1,3
      J2 = IO(1,M)
      IO(1,M) = IO(3,M)
      IO(3,M) = J2
160   IO(2,M) =-IO(2,M)
      GO TO 350
C       ORTHORHOMBIC P, I AND F CELLS
170   IF = IF - 10
      J1= 1
      IF (CEL(2) - CEL(1))190,190,180
180   J1 = J1+2
190   IF (CEL(2) - CEL(3))210,210,200
200   J1 = J1+2
210   IF (CEL(1) - CEL(3))230,230,220
220   J1 = J1+1
230   GO TO (240,250,260,270,280,350),J1
240   J2 = 132
      GO TO 290
250   J2 = 312
      GO TO 290
260   J2 = 231
      GO TO 290
270   J2 = 213
      GO TO 290
280   J2 = 321
290   K = J2/100
      L = (J2 - K*100)/10
      M = J2 - K*100 - L*10
      CEX(1) = CEL(K)
      CEX(2) = CEL(L)
      CEX(3) = CEL(M)
      DO 300 N=1,3
      ION(1,N) = IO(K,N)
      ION(2,N) = IO(L,N)
300   ION(3,N) = IO(M,N)
      GO TO (310,330,330,310,310),J1
310   DO 320 N=1,3
320   ION(3,N) = -ION(3,N)
330   DO 340 N=1,3
      CEL(N) = CEX(N)
      DO 340 M=1,3
340   IO(M,N) = ION(M,N)
350   RAB = CEL(1)/CEL(2)
      RCB = CEL(3)/CEL(2)
      J1 = IF
      J2 = J1+1
      DO 360 I=1,3
      CEL(I) = CEL(I) + 0.0005
360   CEL(I+3) = CEL(I+3) + 0.005
      WRITE (LP,900) CEL, RAB, RCB, ((IO(M,N),N=1,3),M=1,3), (FACT(N),N=
     * J1,J2)
370   RETURN
900   FORMAT (' Cell in CRYSTAL DATA convention'/5X, 3F10.3, 3F9.2/
     * '     A/B =', F7.4, ',   C/B =', F7.4/'     Overall transforma',
     * 'tion matrix is ', 3(2X, 3I3), 3X, 2A4//)
      END
      SUBROUTINE FAILD(R,DELT1,LT,LP)
C       EXAMINES SELLING PARAMETERS OF INVALID CELL.  CALLED BY
C       REDUC, IN DELRED.
      REAL R(6), RD(15)
      DO 10 I=1,6
      IF (R(I) + DELT1)30,10,10
10    CONTINUE
20    WRITE (LT,900)
      WRITE (LP,900)
      RETURN
30    RM = R(I)
      I = I+1
      DO 60 J=I,6
      IF (R(J) + DELT1)40,60,60
40    IF (RM - R(J))50,60,60
50    RM = R(J)
60    CONTINUE
      N = 0
      DO 70 I=1,5
      I1 = I+ 1
      DO 70 J=I1,6
      N = N+1
70    RD(N) = ABS(R(I) - R(J))
      DO 80 I=1,15
      IF (RD(I) - DELT1)80,80,90
80    CONTINUE
      GO TO 20
90    RE = RD(I)
      I = I+1
      DO 120 J=I,15
      IF (RD(J) - DELT1)120,120,100
100   IF (RE - RD(J))120,120,110
110   RE = RD(J)
120   CONTINUE
      RM = RM-0.005
      RE = RE+0.005
      WRITE (LT,901) RM, RE
      RETURN
900   FORMAT (' DELT1 too large')
901   FORMAT (' .....check (1) input cell and lattice data'/12X,
     * '(2) DELT1.  check for zero or equal Selling parameters outside'/
     * 18X,'present limits.  Value next nearest zero is',F7.2,'.  Next'/
     * 18X, 'smallest difference between possibly equal parameters'/
     * 18X, 'is', F8.2//)
      END
      SUBROUTINE ROHEX
C       CALCULATES HEXAGONAL CELL DIMENSIONS FOR RHOMBOHEDRAL LATTICE.
C       CALLED BY REDUC IN DELRED.
      INTEGER ION(3,3), IO(3,3)
      INTEGER FACT(4)
      COMMON CEL(6),A,B,C,DELTA,DELT1,IO,IF,LT,LP,LZ
#if defined(_HOL_)
      DATA FACT/4H(*0., 4H5)  , 4H    , 4H    /
#else
      DATA FACT/'(*0.', '5)', '    ', '  '/
#endif
      ALP = SIN(CEL(4)*3.1415927/360.)
      SAL = SQRT(1. - ALP*ALP*1.33333)
      CEL(1) = ALP*CEL(1)*2.0
      CEL(2) = CEL(1)
      CEL(3) = 3.*CEL(3)*SAL
      CEL(4) = 90.005
      CEL(5) = CEL(4)
      CEL(6) = 120.005
      VOL = CEL(1)*CEL(1)*0.866025*CEL(3) + 0.05
      DO 10 M=1,3
      ION(1,M) = IO(1,M) - IO(2,M)
      ION(2,M) = IO(2,M) - IO(3,M)
10    ION(3,M) = IO(1,M) + IO(2,M) + IO(3,M)
      DO 20 I=1,3
20    CEL(I) = CEL(I) + 0.0005
      N1 = IF
      N2 = IF+1
      WRITE (LT,900) CEL, VOL
      WRITE (LT,901) ((ION(M,N),N=1,3),M=1,3), (FACT(N),N=N1,N2)
      WRITE (LP,900) CEL, VOL
      WRITE (LP,901) ((ION(M,N),N=1,3),M=1,3), (FACT(N),N=N1,N2)
      RETURN
900   FORMAT (' Corresponding hexagonal cell has dimensions'/5X, 3F10.3,
     * 3F9.2/'     Volume =', F8.1)
901   FORMAT ('     Overall transformation matrix is ',3(2X,3I3), 3X,
     * 2A4//)
      END
      FUNCTION VOLE(CP)
C       CALCULATES CELL VOLUME.  CALLED BY DLPRE IN DELRED.
      DIMENSION CP(6)
      CV = 1.0-CP(4)**2-CP(5)**2-CP(6)**2+2.0*CP(4)*CP(5)*CP(6)
      V = CP(1)*CP(2)*CP(3)*SQRT(ABS(CV))
      VOLE=V
      RETURN
      END
      SUBROUTINE CALCK(D1,D2,D3)
C       BRAVAIS LATTICE PARAMETER ASSIGNMENT.  CALLED BY REDUC
C       IN DELRED.
      COMMON CEL(6),A,B,C,DELTA,DELT1,IO(3,3),IF,LT,LP,LZ
      CEL(1)=SQRT(-1.*D1)+0.00005
      CEL(2)=SQRT(-1.*D2)+0.00005
      CEL(3)=SQRT(-1.*D3)+0.00005
      A=CEL(1)
      B=CEL(2)
      C=CEL(3)
      RETURN
      END
      SUBROUTINE CCP(CP)
C       REAL/RECIPROCAL CELL CONVERSION.  CALLED BY DLPRE
C       IN DELRED.
      DIMENSION CP(6),RCP(6)
      V=VOLE(CP)
      RCP(1)=CP(2)*CP(3)*SIN(ARCOS(CP(4)))/V
      RCP(2)=CP(1)*CP(3)*SIN(ARCOS(CP(5)))/V
      RCP(3)=CP(2)*CP(1)*SIN(ARCOS(CP(6)))/V
      RCP(4)=(CP(5)*CP(6)-CP(4))/(SIN(ARCOS(CP(5)))*SIN(ARCOS(CP(6))))
      RCP(5)=(CP(4)*CP(6)-CP(5))/(SIN(ARCOS(CP(4)))*SIN(ARCOS(CP(6))))
      RCP(6)=(CP(4)*CP(5)-CP(6))/(SIN(ARCOS(CP(4)))*SIN(ARCOS(CP(5))))
      DO 10 I=1,6
10    CP(I)=RCP(I)
      RETURN
      END
      SUBROUTINE PERM3(Z,Y,K)
C       OBTAIN A SEQUENCE OF 3 SELLING PARAMETER PERMUTATIONS.
C       CALLED BY DSHORT IN DELRED.
      DIMENSION Z(6),Y(7,12)
      Y(7,K  )=ABS(Z(1))+ABS(Z(2))+ABS(Z(3))
      CALL SAVE(Z,Y,K)
      CALL SR2(Z)
      Y(7,K+1)=ABS(Z(1))+ABS(Z(2))+ABS(Z(3))
      CALL SAVE(Z,Y,K+1)
      CALL SR2(Z)
      Y(7,K+2)=ABS(Z(1))+ABS(Z(2))+ABS(Z(3))
      CALL SAVE(Z,Y,K+2)
      RETURN
      END
      SUBROUTINE SAVE(Z,Y,K)
C       CALLED BY PERM3 IN DELRED.
      DIMENSION Z(6),Y(7,12)
      DO 10 I=1,6
10    Y(I,K)=Z(I)
      RETURN
      END
      SUBROUTINE SR2(Z)
C       SHIFT VECTOR Z TO THE RIGHT TWO PLACES.
C       CALLED BY PERM3 IN DELRED.
      DIMENSION Z(6)
      T1=Z(5)
      T2=Z(6)
      DO 10 I=1,4
      I1=7-I
      I2=5-I
10    Z(I1)=Z(I2)
      Z(1)=T1
      Z(2)=T2
      RETURN
      END
      FUNCTION NINT(X)
      IF (X) 10, 30, 20
10    X = X-0.5
      GO TO 30
20    X = X+0.5
30    NINT = X
      RETURN
      END
      FUNCTION ARCOS(X)
C       RETURNS ARCOSINE OF X, BETWEEN 0.0 AND PI.
C       IF ABS(X) > 1.0, ARCOS SET TO 0 OR PI.
      IF (ABS(X).GT.1.001) WRITE (1,100) X
100   FORMAT ('*** COSINE VALUE =', F8.5, ', OUTSIDE NORMAL LIMITS ***')
      IF (ABS(X).LT.1.0) GO TO 20
      ARCOS = 0.0
      IF (X.LT.0.0) ARCOS = 3.1415927
      RETURN
20    IF (ABS(X).GT.0.000001) GO TO 40
      ARCOS=1.5707964
      RETURN
40    ARCOS=ATAN(SQRT(1.-X*X)/X)
      IF (ARCOS.GE.0.0) GO TO 60
      ARCOS=ARCOS+3.1415927
60    RETURN
      END
      SUBROUTINE ALTRIX
C   Subroutine called by REDUC (in DELRED) and ALTRI, to find best
C       triclinic cell.
C       David L. Hughes,  October, 1982.
C
      INTEGER LMP(3,3), LMX(3,3), LO(3,3), AP(4)
      INTEGER LM(49,3), IY(4), IA(3), IQ(3), LN(3,3), IP(7)
      REAL SA(3), CA(3), A(3), AN(3), XT(3), XX(3,3), TITLE(20)
      REAL XR(3), X(49,3), XD(49,3), XM(49), CM(3), SM(3), AM(3)
      REAL AND(49,49), XMX(3), AMX(3), XMP(3), AMP(3)
      COMMON A, AN, AB(5), LO, IF, LT, LP,LZ
      DATA DR/57.2958/
#if defined(_HOL_)
      DATA IP/2HPr, 2HI-, 2HC-, 2HB-, 2HF-, 2H  , 2HA-/
      DATA AP/4Himit, 4Hive , 4Hcent, 4Hred /
#else
      DATA IP/'Pr', 'I-', 'C-', 'B-', 'F-', '  ', 'A-'/
      DATA AP/'imit', 'ive ', 'cent', 'red '/
#endif
      WRITE (LP,906)
      IM = 1
   8  SAPP = 0.
      SAPQ = 1.
      SAPX = 0.
C
C   Calculate cell volume and limits.
C
      SMIN = 1.
      DO 10 I=1,3
      SA(I) = SIN(AN(I)/DR)
      SAPQ = SAPQ*SA(I)
      IF (SA(I).LT.SMIN) SMIN=SA(I)
  10  CA(I) = COS(AN(I)/DR)
      SMIN = SMIN * 0.99
      SAPQ = SAPQ+0.0002
      SG = SA(3)
      W = SQRT(1. - CA(1)**2 - CA(2)**2 - CA(3)**2 + 2.*CA(1)*CA(2)*
     *  CA(3))
      VX = A(1) * A(2) * A(3) * W
      VMN = VX/10.
      VMX = VX*2.1
      VMF = VX*4.1
      WRITE (LP,916) VX
      IF (IF.NE.1) GO TO 15
      WRITE (LT,916) VX
  15  WRITE (LP,909)
      DO 30 I=1,3
      DO 20 J=1,3
  20  XT(J) = 0.
      XT(I) = 1.
      XX(I,1) = XT(1)*A(1) + XT(2)*A(2)*CA(3) + XT(3)*A(3)*CA(2)
      XX(I,2) = XT(2)*A(2)*SG + XT(3)*A(3)*(CA(1)-CA(2)*CA(3))/SG
      XX(I,3) = XT(3)*A(3)*W/SG
      WRITE (LP,914) (XX(I,J),J=1,3)
  30  CONTINUE
C
C   Check indices of lattice points.
C
      M = 0
      DO 60 II=1,3
      I = II-1
      IL = I/2
      IL = I-(IL*2)
      DO 50 JJ=1,5
      J = JJ-3
      IF (I.EQ.0.AND.J.LT.0) GO TO 50
      JL = J/2
      JL = J-(JL*2)
      DO 40 KK=1,5
      K = KK-3
      IF (I.EQ.0.AND.J.EQ.0.AND.K.LE.0) GO TO 40
      KL = K/2
      KL = K-(KL*2)
      IF (IL.EQ.0.AND.JL.EQ.0.AND.KL.EQ.0) GO TO 40
      M = M+1
      LM(M,1) = K
      LM(M,2) = J
      LM(M,3) = I
  40  CONTINUE
  50  CONTINUE
  60  CONTINUE
C
C   Calculate coordinates, direction cosines and distance from origin
C       of accepted lattice points.
C
      DO 100 M=1,49
      DO 70 L=1,3
  70  XR(L) = LM(M,L)
      DO 80 L=1,3
  80  X(M,L) = XR(1)*XX(1,L) + XR(2)*XX(2,L) + XR(3)*XX(3,L)
      XM(M) = SQRT(X(M,1)**2 + X(M,2)**2 + X(M,3)**2)
      DO 90 L=1,3
  90  XD(M,L) = X(M,L)/XM(M)
C     WRITE (6,701) M, (LM(M,L),L=1,3), (X(M,L),L=1,3), (XD(M,L),L=1,3),
C    *  XM(M)
C701  FORMAT (1H , 4I4, 3F7.2, 5X, 3F7.3, F11.3)
 100  CONTINUE
C
C   Calculate angles between all pairs of lattice vectors.
C
      DO 130 I=1,48
      II = I+1
      DO 120 J=II,49
      CX = XD(I,1)*XD(J,1) + XD(I,2)*XD(J,2) + XD(I,3)*XD(J,3)
      ANG = ARCOS(CX)
      AND(I,J) = ANG*DR
      SAN = SIN(ANG)
      IF (SAN.LT.SMIN) AND(I,J)=0.0
 120  CONTINUE
 130  CONTINUE
      WRITE (LP,910)
C     WRITE (LT,912)
C
C   Check all triplets of lattice vectors w.r.t. indices and cell
C       volumes.  Identify type of new cell and check for
C       right-handedness.
C
      IW = 0
      DO 220 I=1,47
      II = I+1
      IA(1) = I
      DO 210 J=II,48
      IA(2) = J
      AM(3) = AND(I,J)
      IF (ABS(AM(3)).LT.0.01) GO TO 210
      JJ = J+1
      DO 200 K=JJ,49
      IA(3) = K
      AM(2) = AND(I,K)
      AM(1) = AND(J,K)
      DO 140 L=1,2
      IF (ABS(AM(L)).LT.0.01) GO TO 200
 140  CONTINUE
      GO TO (141,143),IM
 143  DO 145 MM=1,3
      M = IA(MM)
      DO 145 L=1,3
 145  LN(MM,L) = LM(M,1)*LMP(1,L) + LM(M,2)*LMP(2,L) + LM(M,3)*LMP(3,L)
      GO TO 149
 141  DO 148 MM=1,3
      M = IA(MM)
      DO 148 L=1,3
 148  LN(MM,L) = LM(M,1)*LO(1,L) + LM(M,2)*LO(2,L) + LM(M,3)*LO(3,L)
 149  ID = LM(I,1)*(LM(J,2)*LM(K,3)-LM(K,2)*LM(J,3)) - LM(I,2)*(LM(J,1)
     *  *LM(K,3)-LM(K,1)*LM(J,3)) + LM(I,3)*(LM(J,1)*LM(K,2)-LM(K,1)
     *  *LM(J,2))
      IF (ID.GT.0) GO TO 146
      DO 142 L=1,3
 142  LN(3,L) = -LN(3,L)
      DO 144 L=1,2
 144  AM(L) = 180.-AM(L)
 146  IS = 0
C
C   Test for Face-centres.
C
      DO 160 M=1,2
      MM = M+1
      DO 160 N=MM,3
      DO 150 L=1,3
      LS = LN(M,L) + LN(N,L)
      IQ(L) = LS/2
 150  IQ(L) = LS - (IQ(L)*2)
      IF (IQ(1).EQ.0.AND.IQ(2).EQ.0.AND.IQ(3).EQ.0) IS=IS+(M*N)
 160  CONTINUE
      IF (IS.EQ.11) IS=4
      IF (IS.GT.1) GO TO 175
C
C   Test for Body-centres.
C
      DO 170 L=1,3
      LS = LN(1,L) + LN(2,L) + LN(3,L)
      IQ(L) = LS/2
 170  IQ(L) = LS - (IQ(L)*2)
      IF (IQ(1).EQ.0.AND.IQ(2).EQ.0.AND.IQ(3).EQ.0) IS=1
 175  DO 180 L=1,3
 180  CM(L) = COS(AM(L)/DR)
      W = SQRT(1.-CM(1)**2 - CM(2)**2 - CM(3)**2 + 2.*CM(1)*CM(2)*CM(3))
      V = XM(I) * XM(J) * XM(K) * W
      IF (IS.EQ.4.AND.V.LT.VMF) GO TO 185
      IF (V.LT.VMN.OR.V.GT.VMX) GO TO 200
C
C   Calculate triple-sine-product.  Value closest to 1.0 shows
C       most orthogonal combination.
C
 185  SAP = 1.
      DO 190 L=1,3
      SM(L) = SIN(AM(L)/DR)
 190  SAP = SAP * SM(L)
      IS = IS+1
      IF (IS.GE.2) GO TO 197
      IT = 1
      IW = IW+1
      GO TO 199
 197  IT = 3
 199  IU = IT+1
C
C   Record best cell.
C
      IF (SAP.LE.SAPX) GO TO 193
      DO 192 L=1,3
      DO 194 M=1,3
 194  LMX(M,L) = LN(M,L)
      XMX(L) = XM(IA(L))
 192  AMX(L) = AM(L)
      SAPX = SAP
      VXX = V
      ISX = IS
C
C   Record best primitive cell.
C
 193  IF (IS.GE.2) GO TO 198
      IF (SAP.LE.SAPP) GO TO 198
      DO 196 L=1,3
      DO 195 M=1,3
 195  LMP(M,L) = LN(M,L)
      XMP(L) = XM(IA(L))
 196  AMP(L) = AM(L)
      SAPP = SAP
C
C   Write out results.
C
 198  WRITE (LP,917) ((LN(M,L),L=1,3),M=1,3),
     *   XM(I), XM(J), XM(K), AM, V, IP(IS), AP(IT), AP(IU), SAP
C     WRITE (LT,913) XM(I), XM(J), XM(K), AM, IP(IS), SAP
 200  CONTINUE
 210  CONTINUE
 220  CONTINUE
      IF (IW.LE.1) GO TO 330
C
C   Check for better primitive cell for recycling.
C
      IF (SAPP.LE.SAPQ) GO TO 330
C     WRITE (LT,915)
C     WRITE (LT,913) XMP, AMP, IP(1), SAPP
      WRITE (LP,915)
      WRITE (LP,913) XMP, AMP
      IM = 2
      DO 320 L=1,3
      A(L) = XMP(L)
 320  AN(L) = AMP(L)
      GO TO 8
C
C   Write best triclinic cell.
C
 330  IF (ISX.GE.2) GO TO 230
      IT = 1
      GO TO 240
 230  IT = 3
 240  IU = IT+1
      WRITE (LT,925)
      WRITE (LT,913) XMX, AMX, IP(ISX), AP(IT), AP(IU)
      WRITE (LT,919) ((LMX(M,L),L=1,3),M=1,3)
      WRITE (LT,916) VXX
      WRITE (LP,925)
      WRITE (LP,917) ((LMX(M,L),L=1,3),M=1,3), XMX, AMX, VXX,
     *  IP(ISX), AP(IT), AP(IU), SAPX
      WRITE (LP,918)
      RETURN
 906  FORMAT (/' Subroutine ALTRIX, for best triclinic cell.')
 907  FORMAT (/' Input cell dimensions : ',
     . / 3F8.3,' Angstroms.'
     *  , 3F8.2, ' Degrees.')
 909  FORMAT (/' Orthogonalised coordinates of input cell : ')
 910  FORMAT (/'     Transformation matrix         New a     b       c',
     *  '        Alpha   Beta    Gamma  Volume   Cell type  Sine P',
     *  'roduct'/)
 912  FORMAT (/'   New a     b       c        Alpha   Beta    Gamma',
     *  '  Cell  Sin.prod.'/)
 913  FORMAT (1H , 3F8.3, 2X, 3F8.2, 3X, A2, 2A4)
 914  FORMAT (1H , 20X, 3F10.3)
 915  FORMAT (/' Recycling with better primitive cell : ')
 916  FORMAT (/' Volume =', F10.1, ' cubic Angstroms.')
 917  FORMAT (1H , 3(3I3,2X), 3F8.3, 2X, 3F8.2, F8.1, 3X, A2, 2A4, F9.3)
 918  FORMAT (/'     ********************          *********************
     ****************************',//)
 919  FORMAT (/' Transformation matrix is', 3(2X, 3I3))
 925  FORMAT (/,' Best cell is : ')
      END
