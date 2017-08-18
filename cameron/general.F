CRYSTALS CODE FOR GENERAL.FOR                                                   
CAMERON CODE FOR GENERAL
CODE FOR ZEIGEN
      SUBROUTINE ZEIGEN(A,R)
C THIS CODE IS TAKEN FROM SNOOPI
      REAL A(3,3),R(3,3)
      R(1,1)=1.
      R(1,2)=0.
      R(1,3)=0.
      R(2,1)=0.
      R(2,2)=1.
      R(2,3)=0.
      R(3,1)=0.
      R(3,2)=0.
      R(3,3)=1.
      NCOUNT=0
      THR=1.414*SQRT(A(1,2)*A(1,2)+A(1,3)*A(1,3)+A(2,3)*A(2,3))
      IF(THR.LT..0001)GOTO 55
      THRLMT=THR*0.333E-6
10      THR=THR/3
      DO 50 N=1,2
      K=3
      DO 40 I=1,2
      DO 30 J=2,3
      IF(J .LE. I) GO TO 30
      IF(ABS(A(I,J)).LT.THRLMT)GOTO 29
      Y=A(I,J)+A(J,I)
      X=A(J,J)-A(I,I)
      RR =SQRT(X*X+Y*Y)
      COZ=SQRT((X/RR+1)/2)
      COZSQ=COZ*COZ
      ZIN=SQRT(1-COZSQ)
      IF(Y .LT. 0)COZ=-COZ
      ZINSQ=ZIN*ZIN
      ZINCOZ=ZIN*COZ
      AKI=A(K,I)*COZ-A(K,J)*ZIN
      A(K,J)=A(K,I)*ZIN+A(K,J)*COZ
      A(K,I)=AKI
      A(J,K)=A(K,J)
      A(I,K)=AKI
      AIJ=(A(I,I)-A(J,J))*ZINCOZ-A(J,I)*ZINSQ+A(I,J)*COZSQ
      AII=A(I,I)*COZSQ+A(J,J)*ZINSQ-(A(I,J)+A(J,I))*ZINCOZ
      A(J,J)=A(I,I)+A(J,J)-AII
      A(I,I)=AII
      A(I,J)=AIJ
      A(J,I)=AIJ
      RIK=R(I,K)*COZ-R(J,K)*ZIN
      R(J,K)=R(I,K)*ZIN+R(J,K)*COZ
      R(I,K)=RIK
      RII=R(I,I)*COZ-R(J,I)*ZIN
      RIJ=R(I,J)*COZ-R(J,J)*ZIN
      R(J,J)=R(I,J)*ZIN+R(J,J)*COZ
      R(J,I)=R(I,I)*ZIN+R(J,I)*COZ
      R(I,J)=RIJ
      R(I,I)=RII
29    K=K-1
30      CONTINUE
40      CONTINUE
50      CONTINUE
      IF(THR.GT.THRLMT)GOTO 10
55      MLT=3
      IF(A(2,2).LT.A(3,3))MLT=2
      IF(A(1,1).LT.A(MLT,MLT))MLT=1
      IF(MLT.EQ.3)GOTO 65
      DO 60 N=1,3
      TEMP=R(3,N)
      R(3,N)=R(MLT,N)
60      R(MLT,N)=TEMP
      TEMP=A(3,3)
      A(3,3)=A(MLT,MLT)
      A(MLT,MLT)=TEMP
65      MGT=1
      IF(A(2,2).GT.A(1,1))MGT=2
      IF(A(3,3).GT.A(MGT,MGT))MGT=3
      IF(MGT .EQ.1)GOTO 100
      DO 70 N=1,3
      TEMP=R(1,N)
      R(1,N)=R(MGT,N)
70      R(MGT,N)=TEMP
      TEMP=A(MGT,MGT)
      A(MGT,MGT)=A(1,1)
      A(1,1)=TEMP
100     DO 101 N1=1,3
      FNORM=R(N1,1)*R(N1,1)+R(N1,2)*R(N1,2)+R(N1,3)*R(N1,3)
      FNORM=SQRT(FNORM)
      DO 101 N2=1,3
101     R(N1,N2)=R(N1,N2)/FNORM
      DET=R(1,1)*(R(2,2)*R(3,3)-R(3,2)*R(2,3))
     1+R(1,2)*(R(2,3)*R(3,1)-R(3,3)*R(2,1))
     1+R(1,3)*(R(2,1)*R(3,2)-R(3,1)*R(2,2))
      IF(DET .GT. 0.)RETURN
C       ROTATORY INVERSION CORRECTION
      DO 110 N1=1,3
      DO 110 N2=1,3
110     R(N1,N2)=-R(N1,N2)
      RETURN
      END
 
CODE FOR LROOM
      FUNCTION LROOM ( IEND1, IEND2 , NROOM )
C This function checks to see whether or not suffiecient space is
C available in the STORE array to accomadate NROOM pieces of info.
C IEND1, IEND2 are the first and last free addresses in STORE.
      IF (IEND2-IEND1.GE.NROOM) THEN
      LROOM = 1
      ELSE
      LROOM = -1
      ENDIF
      RETURN
      END
 
CODE FOR ZORIEN
      SUBROUTINE ZORIEN(VEC,MT1,MT2)
      REAL VEC(3),MT1(3,3),MT2(3,3),M1(3,3),M2(3,3),VECZ(3),VEC1(3)
      REAL VECTES(3)
      VECZ(1)=0.
      VECZ(2)=0.
      VECZ(3)=1.
      IF(ABS(VEC(1)-0.0) .GT. 0.000001) GO TO 5
      AN2=0.
      IF(VEC(3) .LT. 0.)AN2=180.
      GO TO 10
5     VEC1(1)=VEC(1)
      VEC1(2)=0.
      VEC1(3)=VEC(3)
      CALL ZDTPRD(VEC1,VECZ,AN2)
      IF(VEC(1) .LT. 0.) AN2=-AN2
10    VEC1(1)=0.
      VEC1(2)=VEC(2)
      ARG=(VEC(1)*VEC(1)+VEC(3)*VEC(3))
      VEC1(3)=SQRT(ARG)
      CALL ZDTPRD(VEC1,VECZ,AN1)
      IF(VEC(2) .LT. 0.)AN1=-AN1
      CALL ZROTY(M2,-AN2)
      CALL ZROTX(M1,AN1)
      CALL ZMATR3(M1,M2,MT1)
      M1(2,3)=-M1(2,3)
      M1(3,2)=-M1(3,2)
      M2(1,3)=-M2(1,3)
      M2(3,1)=-M2(3,1)
      CALL ZMATR3(M2,M1,MT2)
C TEST THE VECTORS
      CALL ZMATV (MT1,VEC,VECTES)
      CALL ZMATV (MT2,VEC,VECTES)
      RETURN
      END
CODE FOR ZROTX
      SUBROUTINE ZROTX(MAT,RX)
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      REAL MAT(3,3)
      R = RX * PI / 180.0
      MAT(2,3)=-SIN(R)
      MAT(2,2)=COS(R)
      MAT(3,3)=MAT(2,2)
      MAT(3,2)=-MAT(2,3)
      MAT(1,1)=1.
      MAT(1,2)=0.
      MAT(1,3)=0.
      MAT(2,1)=0.
      MAT(3,1)=0.
      RETURN
      END
 
CODE FOR ZROTY
      SUBROUTINE ZROTY(MAT,RY)
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      REAL MAT(3,3)
      R = RY * PI / 180.0
      MAT(1,1)=COS(R)
      MAT(1,3)=SIN(R)
      MAT(3,3)=MAT(1,1)
      MAT(3,1)=-MAT(1,3)
      MAT(2,2)=1.
      MAT(2,1)=0.
      MAT(2,3)=0.
      MAT(1,2)=0.
      MAT(3,2)=0.
      RETURN
      END
CODE FOR ZBLANK (N,L,M)
      SUBROUTINE ZBLANK (N,L,M)
      CHARACTER*(*) N(M)
      DO 10 I = 1,M
      DO 10 J = 1,L
      N(I)(J:J) = ' '
10    CONTINUE
      RETURN
      END
 
 
CODE FOR ZCOSIN
      SUBROUTINE ZCOSIN
C This routine calculates SIN and COS for integral angles and stores
C the answers in XSIN and XCOS.
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      PI = ACOS(-1.0)
      DO 10 I = 0,360
      ANG = (I)*PI/180.0
      XCOS(I+1) = COS(ANG)
      XSIN(I+1) = SIN(ANG)
10    CONTINUE
      RETURN
      END
 
 
CODE FOR ZDIAG2 (WORK,VEC2,VEC3,EIG1,EIG2,P)
      SUBROUTINE ZDIAG2 (WORK,VEC2,VEC3,EIG1,EIG2,P)
      REAL WORK(3,3),VEC2(3),VEC3(3),EIG1,EIG2,P
C IS THE MATRIX SYMMETRIC AND REAL?
C Diagonalise the xy components of the matrix to find out the principal
C axes of this new ELLIPSE.
C This is done by forming and solving a quadratic eqn in the eigenvalues
C FIRST CHECK FOR ZERO OFF DIAGONAL TERMS
C OFF DIAGONAL TERMS THAT ARE SMALL RELATIVE TO THE ON
C DIAGONAL TERMS SHOULD BE IGNORED AS THEY WILL HAVE
C ARISEN DUE TO ROUNDING PROBLEMS.
      REAL RLARG
      RLARG = MAX(ABS(WORK(1,1)),ABS(WORK(2,2)))
      IF (RLARG.LT.0.000001) THEN
      EIG1 = 0.0
      EIG2 = 0.0
        VEC2(1) = 0.0
        VEC2(2) = 0.0
        VEC3(1) = 0.0
        VEC3(2) = - 1.0 / SQRT ( EIG2 )
        P = 0.0
        VEC2(1) = -1.0 / SQRT ( EIG1 )
        VEC2(2) = 0.0
        VEC3(1) = 0.0
        VEC3(2) = 0.0
        RETURN
      ENDIF
      IF (ABS(WORK(1,2)/RLARG).LT.0.00001) THEN
      EIG1 = WORK(1,1)
      EIG2 = WORK(2,2)
C NOW CHECK FOR ZERO EIGENVALUES
      IF (ABS(EIG2).LT.0.000001) THEN
        VEC2(1) = -1.0 / SQRT ( EIG1 )
        VEC2(2) = 0.0
        VEC3(1) = 0.0
        VEC3(2) = 0.0
        P = 0.0
      ELSE IF (ABS(EIG1).LT.0.0001) THEN
C WE NEED TO SWAP OVER THE EIGENVALUES
        TEMP = EIG1
        EIG1 = EIG2
        EIG2 = TEMP
        VEC3(1) = 0.0
        VEC3(2) = 0.0
        VEC2(1) = -1.0/SQRT(EIG1)
        VEC2(2) = 0.0
        P = 3.14156/2.0
      ELSE
        VEC2(1) = 1.0 / SQRT ( EIG1 )
        VEC2(2) = 0.0
        VEC3(1) = 0.0
        VEC3(2) = 1.0 / SQRT ( EIG2 )
        P = 0.0
      ENDIF
      VEC2(3) = 0.0
      VEC3(3) = 0.0
      RETURN
      ENDIF
C OTHERWISE CALCULATE THE EIGENVALUES AND VECTORS AS NORMAL
      B = WORK(1,1) + WORK(2,2)
      C = B*B - 4*(WORK(1,1)*WORK(2,2) - WORK(1,2)*WORK(2,1))
      IF (C.LT.0.0) C = 0.0
      C = SQRT (C)
      EIG1 = ABS((B+C)/2)
      EIG2 = ABS((B-C)/2)
      V =  ( EIG1-WORK(1,1) ) / WORK(2,1)
      V1 = 1.0/(EIG1*(V*V+1))
      VEC2(1) = SQRT(V1)
      VEC2(2) = V*VEC2(1)
      VEC2(3) = 0.0
      IF (ABS(EIG2).LT.0.0000001) THEN
      VEC3(1) = 0.0
      VEC3(2) = 0.0
      VEC3(3) = 0.0
      ELSE
      V = ( EIG2 - WORK ( 1,1) ) / WORK ( 2,1 )
      V1 = 1.0/(EIG2*(V*V+1))
      VEC3(1) = SQRT(V1)
      VEC3(2) = V*VEC3(1)
      VEC3(3) = 0.0
      ENDIF
      P = ATAN2 ( VEC2(2) , VEC2(1) )
      RETURN
      END

 
CODE FOR ZDTPRD
      SUBROUTINE ZDTPRD(VEC1,VEC2,PHI)
      REAL VEC1(3),VEC2(3)
      DS1=SQRT(VEC1(1)*VEC1(1)+VEC1(2)*VEC1(2)+VEC1(3)*VEC1(3))
      DS2=SQRT(VEC2(1)*VEC2(1)+VEC2(2)*VEC2(2)+VEC2(3)*VEC2(3))
      ARG=(VEC1(1)*VEC2(1)+VEC1(2)*VEC2(2)+VEC1(3)*VEC2(3))/(DS1*DS2)
      IF(ARG .LT.-1.)ARG=-1.
      IF(ARG .GT. 1.)ARG=1.
      PHI=57.29578*ACOS(ARG)
      RETURN
      END
 
CODE FOR ZINVER
      SUBROUTINE ZINVER (A,B)
C This routine inverts the 3x3 matrix A and puts the result into B.
      REAL A(3,3),B(3,3),DET
      INTEGER L,M,N,O
Calculate the determinant first
      DET = A(1,1)*(A(2,2)*A(3,3)-A(2,3)*A(3,2))
     c    - A(1,2)*(A(2,1)*A(3,3)-A(2,3)*A(3,1))
     c    + A(1,3)*(A(2,1)*A(3,2)-A(3,1)*A(2,2))
C Now obtain the inverse matrix
      DO 10 I = 1,3
      DO 20 J = 1,3
        L = I+1 - 3*((I)/3)
        M = I+2 - 3*((I+1)/3)
        N = J+1 - 3*((J)/3)
        O = J+2 - 3*((J+1)/3)
        B(I,J) = (A(N,L)*A(O,M) - A(N,M)*A(O,L))/DET
20      CONTINUE
10    CONTINUE
      RETURN
      END
 
CODE FOR ZMATV4
      SUBROUTINE ZMATV4 (MAT,V,V1)
      REAL MAT(4,4),V(3),V1(3),V2(3)
      DO 10 I = 1,3
      V2(I) = MAT(I,1)*V(1) + MAT(I,2)*V(2) + MAT(I,3)*V(3)
     c  + MAT(I,4)
10      CONTINUE
      CALL ZMOVE (V2,V1,3)
      RETURN
      END
 
CODE FOR ZMOVE
      SUBROUTINE ZMOVE (A,B,N)
C This routine performs B = A
      REAL A(N),B(N)
      DO 10 I = 1,N
      B(I) = A(I)
10    CONTINUE
      RETURN
      END
 
CODE FOR ZPTMAT
      SUBROUTINE ZPTMAT (A,B)
C This routine puts a 3x3 matrix A into the top left hand corner of the
C 4x4 matrix B
      REAL A(3,3),B(4,4)
      DO 10 I = 1,3
      DO 20 J = 1,3
        B(I,J) = A(I,J)
20      CONTINUE
10    CONTINUE
      RETURN
      END
 
CODE FOR ZROT
      SUBROUTINE ZROT(ANG,ITYPE)
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      REAL ANG
C REFERENCE : Mathematical Elements for Computer Graphics p 119
      GOTO (10,20,30) ITYPE
10    CONTINUE
C XROT
      ROT (1,1) = 1.0
      ROT (2,1) = 0.0
      ROT (3,1) = 0.0
      ROT (4,1) = 0.0
      ROT (1,2) = 0.0
      ROT (2,2) = COS(ANG)
      ROT (3,2) = -SIN(ANG)
      ROT (4,2) = YC*(1-COS(ANG)) + ZC*SIN(ANG)
      ROT (1,3) = 0.0
      ROT (2,3) = SIN(ANG)
      ROT (3,3) = COS(ANG)
      ROT (4,3) = ZC*(1-COS(ANG)) - YC*SIN(ANG)
      ROT (1,4) = 0.0
      ROT (2,4) = 0.0
      ROT (3,4) = 0.0
      ROT (4,4) = 1.0
      GOTO 40
20    CONTINUE
C YROT
      ROT (1,1) = COS(ANG)
      ROT (2,1) = 0.0
      ROT (3,1) = -SIN(ANG)
      ROT (4,1) = XC*(1-COS(ANG)) + ZC*SIN(ANG)
      ROT (1,2) = 0.0
      ROT (2,2) = 1.0
      ROT (3,2) = 0.0
      ROT (4,2) = 0.0
      ROT (1,3) = SIN(ANG)
      ROT (2,3) = 0.0
      ROT (3,3) = COS(ANG)
      ROT (4,3) = ZC*(1-COS(ANG)) - XC*SIN(ANG)
      ROT (1,4) = 0.0
      ROT (2,4) = 0.0
      ROT (3,4) = 0.0
      ROT (4,4) = 1.0
      GOTO 40
30    CONTINUE
C ZROT
      ROT (1,1) = COS(ANG)
      ROT (2,1) = -SIN(ANG)
      ROT (3,1) = 0.0
      ROT (4,1) = XC*(1-COS(ANG)) + YC*SIN(ANG)
      ROT (1,2) = SIN(ANG)
      ROT (2,2) = COS(ANG)
      ROT (3,2) = 0.0
      ROT (4,2) = YC*(1-COS(ANG)) - XC*SIN(ANG)
      ROT (1,3) = 0.0
      ROT (2,3) = 0.0
      ROT (3,3) = 1.0
      ROT (4,3) = 0.0
      ROT (1,4) = 0.0
      ROT (2,4) = 0.0
      ROT (3,4) = 0.0
      ROT (4,4) = 1.0
40    CALL ZMOVE(MAT1,MAT2,16)
      CALL ZMATM4 (ROT,MAT1)
      RETURN
      END
 
 
CODE FOR ZMATM4 [4X4 MATRIX MULTIPLER]
      SUBROUTINE ZMATM4 (A,B)
C This routine performs AxB and puts answer in B
      REAL A(4,4),B(4,4),C(4,4)
      DO 20 I = 1,4
      DO 30 J = 1,4
      C(I,J) = A(I,1)*B(1,J) + A(I,2)*B(2,J) + A(I,3)*B(3,J)
     c + A(I,4)*B(4,J)
30    CONTINUE
20    CONTINUE
C MOVE ANSWER INTO B
      DO 40 I = 1,4
      DO 50 J = 1,4
50    B(I,J) = C(I,J)
40    CONTINUE
      RETURN
      END
 
 
CODE FOR ZZEROF
      SUBROUTINE ZZEROF(A,N)
C--SET THE 'N' ELEMENTS OF THE ARRAY 'A' TO FLOATING POINT ZERO
C
C  A  THE ARRAY TO BE ZEROED
C  N  THE NUMBER OF ELEMENTS TO ZERO
C
C--
C
      DIMENSION A(N)
C
C--ZERO THE LEMENTS
      DO 1050 I=1,N
      A(I)=0.0
1050  CONTINUE
      RETURN
      END
C
C
CODE FOR ZZEROI
      SUBROUTINE ZZEROI (A,N)
      INTEGER A(N)
      DO 10 I = 1,N
      A(I) = 0
10    CONTINUE
      RETURN
      END
 
CODE FOR LMOUSE
      FUNCTION LMOUSE (CC,IX,IY)
C This routine calculates which atom
C this position corresponds to. There is also an element key which can
C be clicked on in order to specify an element.
C IMOUSE = 1 means that the mouse is deactivated.
C NMOUSE is the current position on the input line.
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      CHARACTER*20 CC
      CHARACTER*20 CLNUM
      CHARACTER*1 CNUMS(10)
      INTEGER IMX,IMY
      REAL DSMALL
      INTEGER ISMALL
      DATA CNUMS /'0','1','2','3','4','5','6','7','8','9'/
      CLNUM = '                    '
      CC = CLNUM
      LMOUSE = -1
C      CALL ZGTMPS(IMX,IMY)
      IMX = IX
      IMY = IY
C FIRST CHECK THE MENUS
      IF (IMENCN.EQ.2) THEN
      DO 1010 I = 1 , IBUTNO
        IF (IMX.LT.IBUTTS(1,I)) GOTO 1010
        IF (IMY.LT.IBUTTS(2,I)) GOTO 1010
        IF (IMX.GT.IBUTTS(3,I)) GOTO 1010
        IF (IMY.GT.IBUTTS(4,I)) GOTO 1010
        LMOUSE = I
        RETURN
1010    CONTINUE
      ENDIF
      IF (IDOKEY.EQ.1) THEN
C CALCULATE THE CUT OFF POINT FOR THE KEY
      IKMX = XCEN*2 - (NKEY/20)*ISQR - ISQR - 10
      IF (IMX.GT.IKMX) THEN
C POSSIBILITY OF KEY
        IM = 0
        IMM = 0
        IDIFF = IMX - IKMX
C IS THE ELEMENT ON THE SECOND ROW?
        IF (IDIFF.GT.ISQR) THEN
          IMM = 1
        ENDIF
C WHERE IS IT IN THE Y DIRECTION
        IM = (IMY-ISQR)/(ISQR*2)
C WORK OUT THE CENTRE COORDS OF THIS ELEMENT
        IXEL = IKMX + IMM*ISQR + ISQR/2
        IYEL = ISQR + IM*ISQR*2 + ISQR/2
        IF ( ((ABS(IMX-IXEL)).LT.ISQR) .AND.
     c      ((ABS(IMY-IYEL)).LT.ISQR) ) THEN
C YES!! PUT ELEMENT INTO COMMAND LINE!
          N = IM+1 + IMM*20
          IF (N.GT.NKEY) RETURN
          N = RSTORE (IKEY+(N-1)*2)
          N = N + ICELM - 1
          CC(1:ILEN) = CSTORE(N)
          LMOUSE = 0
          RETURN
        ENDIF
      ENDIF
      ENDIF

C CONVERT THE COORDS TO ORTHOGONAL ONES WITHOUT SCALING ETC.
      X = (IMX-XCEN)/SCALE + XCP
      Y = (IMY-YCEN)/SCALE + YCP
C LOOP TO FIND THE COORDS - MUST LIE WITHIN A RADIUS DISTANCE OF THE
C ATOM.
C IF MORE THAN ONE ATOM IS POSSIBLE THEN CHOOSE THE CLOSEST ONE.
      X = IMX
      Y = IMY
      Z = -1000.0
      DSMALL = (2.0*XCEN)**2
      IM = 0
      DO 10 I = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
C DON'T DO EXCLUDED ATOMS!
      IF (RSTORE(I+IPCK+1).LT.0.0) GOTO 10
C GET THE COORDS
      ZZ = RSTORE(I+IXYZO+2)
      IF (ZZ.LT.Z) GOTO 10
      XX = (RSTORE(I+IXYZO)-XCP)*SCALE + XCEN + XOFF
      YY = (RSTORE(I+IXYZO+1)-YCP)*SCALE + YCEN + YOFF
      R = SCALE*RSTORE (I+IATTYP+4)
      D = (X-XX)**2 + (Y-YY)**2
      IF (D.LT.DSMALL) THEN
        DSMALL = D
        ISMALL = I
      ENDIF
      IF ((D.LT.R**2).AND.(ZZ.GT.Z)) THEN
C WE HAVE CONTACT!
        Z = ZZ
        IM = I
      ENDIF
10    CONTINUE
      IF (IM.EQ.0) THEN
C DO WE HAVE A CLOSEST ATOM? - POINT MUST BE WITHIN
C TWICE THE ATOMS RADIUS.
      R = SCALE*RSTORE(ISMALL+IATTYP+4)
      IF (DSMALL.LE.4.0*R**2) THEN
        IM = ISMALL
      ELSE
        RETURN
      ENDIF
      ENDIF
C HAVE FOUND AN ATOM - GET ITS CSTORE NUMBER
      IL = (IM-IRATOM)/IPACKT + ICATOM
C ADD IT INTO THE INPUT LINE
C CHECK FOR PACK LABELLING
      IF (IPACK.GT.0) THEN
C CONVERT THE PACK NUMBER
      IPPACK = NINT(RSTORE(IM+IPCK))
      ICLP = 1
C GET THE LABEL LENGTH
      ILL = INDEX(CSTORE(IL),' ') - 1
1000    CONTINUE
      IPN = MOD (IPPACK,10)
      CLNUM(ICLP:ICLP) = CNUMS(IPN+1)
      IPPACK = IPPACK/10
      IF (IPPACK.GT.0) THEN
        ICLP = ICLP + 1
        GOTO 1000
      ENDIF
C MOVE OVER THE NUMBER
      CC(1:ILL+1) = CSTORE(IL)(1:ILL)//'_'
      DO 1100 J = ICLP , 1 , -1
        CC(ILL+2+ICLP-J:ILL+2+ICLP-J) = CLNUM(J:J)
1100    CONTINUE
cdjw      ILL = ILL + ICLP+1
      ELSE
      CC = CSTORE(IL)
      ENDIF
cdjwnov06
      ill = index(cc,' ')
      LMOUSE = 0
      RETURN
      END
 
      SUBROUTINE ZERF (P,RELSCL)
C THIS ROUTINE CALCULATES THE SCALING VALUE FOR THE THERMAL ELLIPSOIDS
C FOR A GIVE PROBABILITY.
C THE EQUATION BELOW WAS FOUND BY FITTING A POLYNOMIAL TO THE
C VALUES OF P AND C IN THE ORTEP MANUAL USING KALIEDAGRAPH.
CDJW      RELSCL = 0.3328060 + 5.0924006 * P
CDJW     c -8.351354 * P**2
CDJW     c -10.34809338 * P**3
CDJW     c + 70.176713186 * P**4
CDJW     c - 96.9456016 * P**5
CDJW      c + 43.459642321 * P**6
C       REF DB OWEN HANDBOOK OF STATISTICAL TABLES 1962....
C       ORTEP MANUAL P75
      DIMENSION EPROB(20)
      DATA EPROB/
     1 0.593,.764,.893,1.00,1.10,1.19,1.28,1.37,1.45,1.54,
     1 1.63,1.72,1.81,1.91,2.02,2.15,2.31,2.5,2.8,6.00/
      IPOINT = MIN (MAX (1, NINT (20. * P)), 20)
      RELSCL = EPROB(IPOINT)
      RELSCL = RELSCL * RELSCL 
      RETURN
      END
 
CODE FOR ZTEKXY
      SUBROUTINE Ztekxy (IX,IY,ITEK)
C THIS CONVERTS IX,IY PAIR OF COORDINATES INTO THE APPROPRIATE
C ASCII EQUIVALENT FOR THE TEKTRONIC DRIVER. char(itek(n)) are the
C characters that need to be sent. The order is:-
C hi y, lo y, hi x, lo x.
      INTEGER IX,IY
      INTEGER ITEK(4)
 
      ITEK(1) = (IY/32) + 32
      ITEK(2) = MOD (IY,32) + 96
      ITEK(3) = (IX/32) + 32
      ITEK(4) = MOD (IX,32) + 64
      RETURN
      END
 
CODE FOR ZGTCOL
      SUBROUTINE ZGTCOL (COLOUR, NUM)
C THIS ROUTINE GETS THE EQUIVALENT COLOUR NUMBER FOR THE COLOUR TABLE
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      CHARACTER*6 COLOUR
      NUM = 0
      DO 10 I = 1 , ICLMAX
      IF (COLNAM(I).EQ.COLOUR) THEN
        NUM = I-1
        GOTO 20
      ENDIF
10    CONTINUE
20    CONTINUE
      IF (NUM.EQ.0 .AND. COLOUR .NE. ' ') THEN
        CALL ZTXTMD
        WRITE (ISTOUT,'(3A)') 'Warning - element colour ',COLOUR,
     + ' not found in current colour list.'
        WRITE (ISTOUT,'(A)')
     +  'Need to check colour names in COLOUR.CMN and PROP.CMN.'
C cljf
        call zmore1(
     1'Need to check colour names in COLOUR.CMN and PROP.CMN.',0)
C NO WAY!        STOP
      ENDIF
      RETURN
      END
C
CODE FOR ZGTTXT
      SUBROUTINE ZGTTXT (CTEXT , N , NPOS)
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      CHARACTER*(*) CTEXT
C This routine gets the text from the array CTCOMD - NPOS items and
C puts it into CTEXT.
      DO 10 I = 1 , NPOS
      CTEXT((I-1)*12+1:I*12) = CTCOMD(ITCNT+I-1)
10    CONTINUE
C BLANK OFF THE END
      IF (N.GT.NPOS*12) THEN
      DO 20 I = NPOS*12+1,N
        CTEXT(I:I) = ' '
20      CONTINUE
      ENDIF
      ITCNT = ITCNT + NPOS
      RETURN
      END
C
CODE FOR ZMORE
C THIS ROUTINE HANDLES THE 'MORE' FACILITY FOR TEXT OUTPUT
      SUBROUTINE ZMORE (TEXT,IFLAG)
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
	  EXTERNAL CRYBLK
      CHARACTER*(*) TEXT
      CALL XCTRIM( TEXT, NCHAR)
      ILL = MIN (NCHAR,80)
      WRITE (CMON,'(A)') TEXT(1:ILL)
      CALL XPRVDU (6,1,0)
      RETURN
      END
 
CODE FOR ZLOGWT
      SUBROUTINE ZLOGWT (IWFLAG)
C IWFLAG = 1 - write out line to log file and clear file
C        = 0 - clear scratch file.
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      CHARACTER*80 LOGLIN
      CHARACTER*80 NEWLIN
      LOGICAL LFILES
      IF (IWFLAG.EQ.0 .OR. ILOG.NE.1 .OR. IFOBEY.NE.-1) THEN
      IF (.NOT.LFILES (0,' ',ISCRLG)) THEN
        CALL ZMORE('Error on closing LOG scratch file.',0)
      ENDIF
C THE EFFECTS OF THE LOG FILE NOT BEING OPENED MUST BE CHECKED.
      IF (.NOT.LFILES (9,' ',ISCRLG)) THEN
        CALL ZMORE('Error on opening LOG scratch file.',0)
        ILOG = 0
      ENDIF
      RETURN
      ENDIF
      BACKSPACE (ISCRLG)
      READ (ISCRLG,'(A)') NEWLIN
      BACKSPACE (ISCRLG)
      WRITE (ISCRLG,'(A)') ' '
      REWIND (ISCRLG)
10    CONTINUE
      READ (ISCRLG,'(80A)',END=20) LOGLIN
      WRITE (IFLOG, '(80A)') LOGLIN
      GOTO 10
20    CONTINUE
      IF (.NOT.LFILES (0,' ',ISCRLG)) THEN
      CALL ZMORE('Error on closing log scratch file.',0)
      ENDIF
      IF (.NOT.LFILES (9,' ',ISCRLG)) THEN
      CALL ZMORE('Error - log scratch file cannot be opened.',0)
      ILOG = 0
      ENDIF
      RETURN
      END
 
 
CODE FOR ZGTANS
      SUBROUTINE ZGTANS (ANS,ITYPE)
      CHARACTER*(*) ANS
      INTEGER ITYPE
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      READ (ISTIN,'(A)') ANS
cdjwjan00      CALL ZMORE(' ',-1)
      RETURN
      END
 
CODE FOR ZFORTF

C RICaug2000
C This subroutine is vexatious. There is no need to limit
C the filename to DOS length, if the filename is bad, the
C Fortran OPEN instruction will spot the problem.
C I've changed it so it just returns the same filename.
      SUBROUTINE ZFORTF (FILENM,CBUILD,IERR)
      CHARACTER*(*) FILENM,CBUILD
      CBUILD = FILENM
      IERR = 0
      RETURN
      END
CC This routine takes the filename and converts it into the standard
CC form .ie. up to 8 characters in the main name and 3 characters in the
CC extension.
CC It looks for \ (DOS-UNIX) and ] (VAX) characters to find the
CC beginning of the true name. : characters are also allowed.
C      INTEGER ILEN
C      INTEGER INDDIR
C      INTEGER INDDOT
C      INTEGER INDEND
C      IERR = 0
C      ILEN = LEN(FILENM)
C      IPOS = 1
C      CBUILD = ' '
CC Find the end of the filename
C      DO 10 J = ILEN , 1 , -1
C      IF (FILENM(J:J).NE.' ') THEN
C       INDEND = J
C        GOTO 20
C      ENDIF
C10    CONTINUE
C20    CONTINUE
CC First look for the \ character - allow more than 1 of these.
C30    CONTINUE
C      INDDIR = INDEX (FILENM(IPOS:ILEN),'/')
C      IF (INDDIR.NE.0) THEN
C      IPOS = IPOS + INDDIR
C      GOTO 30
C      ENDIF
C      IF (IPOS.GE.2) THEN
CC WE HAVE FOUND A START POINT
C      INDDIR = IPOS-1
C      ELSE
CC LOOK FOR :
C      INDDIR = INDEX(FILENM,':')
C      IF (INDDIR.EQ.0) THEN
CC LOOK FOR ]
C        INDDIR = INDEX(FILENM,']')
C      ENDIF
C      ENDIF
CC Now look for the .
C      INDDOT = INDEX (FILENM,'.')
CC Begin to build the filename.
C      IPOS = 1
C      IF (INDDIR.GT.0) THEN
C      CBUILD = FILENM(IPOS:INDDIR)
C      IPOS = INDDIR+1
C      ENDIF
C      IF (INDDOT.LE.INDDIR+1 .AND. INDDOT.NE.0) THEN
CC THIS IS AN ERROR
C      IERR = 1
C      RETURN
C      ENDIF
CC Now find the length of the filename
C      IF (INDDOT-INDDIR.GE.9) THEN
C      CBUILD(IPOS:IPOS+8) = FILENM(INDDIR+1:INDDIR+9)
C      IPOS = IPOS + 8
C      ELSE IF (INDDOT.GT.0) THEN
C      CBUILD(IPOS:IPOS+8) = FILENM(INDDIR+1:INDDOT-1)
C      IPOS = IPOS + INDDOT - INDDIR -1
C      ELSE IF (INDEND-INDDIR.GE.8) THEN
C      CBUILD(IPOS:IPOS+8) = FILENM(INDDIR+1:INDDIR+8)
C      ELSE
C      CBUILD(IPOS:IPOS+8) = FILENM(INDDIR+1:INDEND)
C      ENDIF
CC NOW ADD ON THE EXTENSION
C      IF (INDDOT.GT.0) THEN
C      IF (INDEND-INDDOT.GE.3) THEN
C        CBUILD(IPOS:IPOS+4) = '.'//FILENM(INDDOT+1:INDDOT+3)
C      ELSE
C        CBUILD(IPOS:IPOS+4) = '.'//FILENM(INDDOT+1:INDEND)
C      ENDIF
C      ENDIF
C      RETURN
C      END
C

