CRYSTALS CODE FOR MATHS2.FOR                                                    
CAMERON CODE FOR MATHS2
CODE FOR ZPRELS
      SUBROUTINE ZPRELS(EIGS,AXES,ELROT,MROT1,E1,E2,PP)
C This is a test program for the ellipse drawing routines.
      REAL AXES(3,3),T(3,3),EIGS(3),V1(3),V2(3)
      REAL T1(3,3),T2(3,3)
      REAL ELROT(3,3),MROT1(3,3),E1(4),E2(4),PP(4)
      INTEGER A(3),B(3)
      INCLUDE 'COMMON.INC'
      DATA A/1,1,2/
      DATA B/2,3,3/
C THIS IS AN ISOTROPIC ATOM!
      IF (EIGS(1).LT.0.0) RETURN
      CALL ZZEROF (T2,9)
C Now we need to set up the ellipsoids.
      DO 30 K = 1,3
        DO 40 I = 1,3
          T2(I,1) = AXES(I,A(K))
          T2(I,2) = AXES(I,B(K))
          T2(I,3) = 0.0
40      CONTINUE
        DO 50 I = 1,3
          DO 50 J = 1,3
            T1(I,J) = T2(J,I)
50      CONTINUE
C NOW SET UP THE TENSOR
        CALL ZMATR3(T2,T1,T)
        CALL ZDIAG2 (T,V1,V2,EIG1,EIG2,P)
        E1(K+1) = SQRT(EIG1)
        E2(K+1) = SQRT(EIG2)
        PP(K+1) = P
C Now find out which half we should be drawing
30    CONTINUE
      RETURN
      END
 
CODE FOR ZBOUEL
      SUBROUTINE ZBOUEL (EIGS,AXES,E1,E2,PP,IARC)
C This routine calculates the bounding ELLIPSE.
      REAL AXES(3,3),EIGS(3),V2(3),V3(3)
      REAL VEC1(3),VEC2(3),VEC3(3),WORK(3,3),ELROT(3,3)
      REAL M1(3,3),M2(3,3),VECV(3),MROT1(3,3)
      REAL E1(4),E2(4),PP(4),T1(3,3),T2(3,3),T(3,3)
      INTEGER IARC(4)
      INCLUDE 'COMMON.INC'
C CALCULATE THE BOUNDING ELLIPSE
C Obtain the temperature factor in quadratic form.
      DO 40 I = 1,3
        DO 50 J = 1,3
      M1(I,J) = AXES(J,I)/ABS(EIGS(I))
50    M2(J,I) = M1(I,J)
40    CONTINUE
      CALL ZMATR3(M2,M1,WORK)
C The ELLIPSE is now represented by the matrix WORK.
C We are viewing the ELLIPSE by looking along the z axis
      VECV(1) = 0.0
      VECV(2) = 0.0
      VECV(3) = 1.0
C Find the vector perpendicular to the polar plane - VEC1
      CALL ZMATV (WORK,VECV,VEC1)
C Get the rotation matrix needed to rotate VEC1 so that it lies along
C the view vector.
      CALL ZORIEN (VEC1,MROT1,ELROT)
C ROTATE THE ELLIPSE
      CALL ZMATR3(MROT1,WORK,WORK)
      CALL ZMATR3(WORK,ELROT,WORK)
C The polar plane is now in the z=0 plane.
C Find the principal axes of this ELLIPSE.
      CALL ZDIAG2 (WORK,VEC2,VEC3,EIG1,EIG2,P)
C ROTATE BACK INTO VIEW SPACE
      CALL ZMATV (ELROT,VEC2,VEC2)
      CALL ZMATV (ELROT,VEC3,VEC3)
C SAVE THESE FOR LATER USE
      CALL ZMOVE (VEC2,V2,3)
      CALL ZMOVE (VEC3,V3,3)
C NOW GENERATE THE ELLIPSE TENSORS
      DO 2 I = 1 , 3
        T2(I,1) = VEC3(I)
        T2(I,2) = VEC2(I)
        T2(I,3) = 0.0
2     CONTINUE
      DO 1 I = 1 , 3
        DO 1 J = 1 , 3
        T1(I,J) = T2(J,I)
1     CONTINUE
C FORM THE TENSOR
      CALL ZMATR3(T2,T1,T)
      CALL ZDIAG2 (T,VEC2,VEC3,EIG1,EIG2,P)
      E1(1) = SQRT(EIG1)
      E2(1) = SQRT(EIG2)
      PP(1) = P
C GET THE PRINCIPAL ELLIPSES
      CALL ZPRELS (EIGS,AXES,ELROT,MROT1,E1,E2,PP)
C FIND OUT WHERE THE PRINCIPAL ELLIPSES INTERSECT WITH THE BOUNDING
C ELLIPSE.
      CALL ZELINT (E1,E2,PP,AXES,V2,V3,IARC)
      RETURN
      END
 
CODE FOR ZANISO
      SUBROUTINE ZANISO (TENSOR,AXES,EIGS,AXESC)
C This routine takes in the thermal ellipsoid tensor produces the
C coords of the principal axes and the eigenvalues to be used for
C drawing.
C TENSOR - this is the input thermal ellipsoid in crystal coordinates
C AXES - the end points of the axes in orthogonal coords
C EIGS - the eigenvalues
C AXESC - the end points of the axes in crystal coords
      INCLUDE 'COMMON.INC'
      REAL TENSOR(3,3),AXES(3,3),EIGS(3),AXESC(3,3),ROTN(3,3)
      REAL ELOR(3,3),ELORT(3,3),ORTHI(3,3)
      REAL ORTH(3,3)
C GET THE ORTHOGONALISATION MATRICES
      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
      CALL ZMOVE (RSTORE(ICRYST+15),ORTHI,9)
      CALL ZMOVE (RSTORE(ICRYST+24),ELOR,9)
      CALL ZMOVE (RSTORE(ICRYST+33),ELORT,9)
C Now obtain the eigenvectors/values
      CALL ZEIGEN(TENSOR,ROTN)
C-DJW- FILTER OUT TINY AXES
      IF (TENSOR(2,2)*100. .LT. TENSOR(1,1)) THEN
            WRITE (CLINE,12) TENSOR(1,1), TENSOR(2,2), TENSOR(3,3)
            CALL ZMORE(CLINE,0)
12          FORMAT ('Unrealistic Uiis',3F10.4)
            TENSOR(2,2) = TENSOR(1,1) * .01
            TENSOR(3,3) = TENSOR(1,1) * .01
            WRITE (CLINE,13) TENSOR(1,1), TENSOR(2,2), TENSOR(3,3)
            CALL ZMORE(CLINE,0)
13          FORMAT ('Reset to        ',3F10.4)
      ELSE IF (TENSOR(3,3)*100. .LT. TENSOR(2,2)) THEN
            WRITE (CLINE,12) TENSOR(1,1), TENSOR(2,2), TENSOR(3,3)
            CALL ZMORE(CLINE,0)
            TENSOR(3,3) = TENSOR(2,2) * .01
            WRITE (CLINE,13) TENSOR(1,1), TENSOR(2,2), TENSOR(3,3)
            CALL ZMORE(CLINE,0)
      ENDIF
      DO 10 I = 1,3
      EIGS(I) = TENSOR(I,I)
10    CONTINUE
      DO 20  I = 1,3
        DO 30 J = 1,3
      AXES(I,J) = ROTN(J,I)*SQRT(ABS(EIGS(J)))
30    CONTINUE
20    CONTINUE
C Now deorthogonalise the axes coordinates
      CALL ZMATR3(ORTHI,AXES,AXESC)
C CHECK THIS
      CALL ZMATR3(ORTH,AXESC,AXES)
C      WRITE (ISTOUT,*) 'AXES , AXESC '
C      WRITE (ISTOUT,*) AXES
C      WRITE (ISTOUT,*) AXESC
      RETURN
      END
 
CODE FOR ZFIDSG [FIND SEGMENT]
      SUBROUTINE ZFIDSG (RCOS,DY,IS)
      INTEGER IS
      REAL RCOS,DY
C WHICH SEGMENT IS THE ATOM IN?
      IS = 0
      IF (RCOS.LT.-1.0) RCOS = -1.0
      IF (RCOS.GT.1.0) RCOS = 1.0
      IF ((RCOS.GT.0.707).AND.(RCOS.LE.1.00)) THEN
        IF (DY.GT.0.0) THEN
          IS = 8
        ELSE
          IS = 1
        ENDIF
      ENDIF
      IF ((RCOS.GT.0.0).AND.(RCOS.LE.0.707)) THEN
        IF (DY.GT.0.0) THEN
          IS = 7
        ELSE
          IS = 2
        ENDIF
      ENDIF
      IF ((RCOS.GT.-0.707).AND.(RCOS.LE.0.0)) THEN
        IF (DY.GT.0.0) THEN
          IS = 6
        ELSE
          IS = 3
        ENDIF
      ENDIF
      IF ((RCOS.GT.-1.01).AND.(RCOS.LE.-0.707)) THEN
        IF (DY.GT.0.0) THEN
          IS = 5
        ELSE
          IS = 4
        ENDIF
      ENDIF
      RETURN
      END
 
 
CODE FOR ZLABEL
      SUBROUTINE ZLABEL
C THIS ROUTINE PLACES THE LABELS ON THE DRAWING
C THE LABELS ARE TREATED AS DUMMY ATOMS.
      INCLUDE 'COMMON.INC'
      REAL R(8),LABLN,LX(8),LY(8),XCENT(3)
      CHARACTER*20 CLAB
      INTEGER ISEG(8)
      INTEGER IX,IY,KK
      INTEGER IACAP,IALOW
      REAL XMIN,XMAX,YMIN,YMAX
C CALCULATE THE BOUNDARIES OF THE SCREEN. THE PICTURE IS SCALED DOWN
C SO THAT IT ONLY FITS ON 90% OF THE SCREEN.
      IACAP = ICHAR('A')
      IALOW = ICHAR('a')
      XMIN = (-0.9*XCEN)/SCALE + XCP
      XMAX = (0.9*XCEN)/SCALE + XCP
      YMIN = (-0.9*YCEN)/SCALE + YCP
CDJWMAR97      YMAX = (0.9*XCEN)/SCALE + YCP
      YMAX = (0.9*YCEN)/SCALE + YCP
      IDLAB = 0
      TENPIX = REAL(ILSIZE)/SCALE
      IF (ICURS.EQ.1) RETURN
      ICOL = 0
C LOOP OVER THE ATOMS - CHECK TO SEE IF THEY ARE TO BE LABELLED.
        DO 10 I = ISVIEW,IFVIEW-1,IPACKT
          IF (MOD((I-ISVIEW)/IPACKT,10).EQ.0) THEN
            J = LBUFF()
            IF (J.EQ.0) THEN
              CALL ZHOME
              CALL ZMORE('ESCAPE',0)
              CALL ZMORE(' ',0)
              IPROC = 0
              RETURN
            ENDIF
          ENDIF
C VIEW MATRIX HAS CHANGED - NEED TO RECALCULATE LABELS
          IF (IVCHAN.EQ.1) THEN
            RSTORE (I+ILAB) = 0.0
            RSTORE (I+ILAB+1) = 0.0
            RSTORE (I+ILAB+2) = 0.0
          ENDIF
          IF ((NINT(RSTORE(I+IATTYP+2)).LT.1).OR.
     c        (NINT(RSTORE(I+IPCK+1)).LT.0))
     c     GOTO 10
          C1 = RSTORE(I+IATTYP + 5)
          XCENT(1) = RSTORE(I+IXYZO)
          XCENT(2) = RSTORE(I+IXYZO+1)
C HOW LONG IS THE LABEL?
          KK = (I-ISINIT)/IPACKT + ICATOM
          IL = INDEX (CSTORE(KK),' ') - 1
          IF (IL.LT.1) GOTO 10
C CHECK FOR PACK LABELLING
          IF (((IPACK.GT.0).AND.(IPLAB.EQ.1)).AND.
     c       (NINT(RSTORE(I)).NE.5)) THEN
               CALL ZPLABL (I,CLAB,IL)
          ELSE
             CLAB = CSTORE(KK)
          ENDIF
C CONVERT THE SECOND LETTER TO LOWER CASE IF NECESSARY
          III = ICHAR(CLAB(2:2))
          IF (CLAB(2:2).GE.'A'.AND. CLAB(2:2).LE. 'Z') THEN
            III = III + IALOW - IACAP
            CLAB(2:2) = CHAR(III)
          ENDIF
C THE FACTOR OF 0.8 ALLOWS FOR THE CHARACTERS NOT BEING SQUARE.
          LABLN = TENPIX*REAL(IL)*0.8
C CHECK IF WE HAVE A PREVIOUS LABEL
          IF ((IVCHAN.EQ.0).AND.(ABS(RSTORE(I+ILAB+2)-0.0).GT.0.0001))
     c    THEN
            IX = NINT ( ( RSTORE(I+ILAB) - XCP ) * SCALE )
            IY = NINT ( ( RSTORE(I+ILAB+1) - YCP ) * SCALE )
            CALL ZDRTEX(IX,IY,CLAB(1:IL),IDEVCL(ILABCL+1))
            GOTO 10
          ENDIF
            IF (NINT(RSTORE(I)).EQ.3) THEN
            IF (RSTORE(I+IXYZO+12).LT.0.0) THEN
C WE HAVE AN ISOTROPIC ATOM
              EIG1 = SQRT(ABS(RSTORE(I+IXYZO+12)))
              EIG2 = EIG1
              P = 0.0
              GOTO 2
            ENDIF
            NEL = NINT (RSTORE (I + IXYZO + 15 ))
            EIG1 = RSTORE(NEL)
            EIG2 = RSTORE(NEL+1)
            P = RSTORE(NEL+2)
          ELSE IF (NINT(RSTORE(I)).EQ.2) THEN
C SPHERE
            R1 = RSTORE(I+IATTYP+4)
            EIG1 = R1
            EIG2 = R1
            P = 0.0
        ELSE
C LINE
            EIG1 = 0
            EIG2 = 0
            P = 0.0
          ENDIF
C CALCULATE THE ATOMS RADIUS IN EACH OF THE SEGMENT DIRECTIONS.
2         CONTINUE
C THE DIRECTIONS ALONG THE 8 SEGMENT LINES ARE FOUND BY ROTATING THE
C ELLIPSE THROUGH THE ANGLE P.
          DO 5 K = 0,315,45
            IF (NINT(RSTORE(I)).EQ.3) THEN
              RK = K*PI/180.0
              R(K/45+1) = SQRT( ( EIG1*COS(RK-P))**2 +
     c                    (EIG2*SIN(RK-P))**2  )
            ELSE
              R(K/45+1) = EIG1
            ENDIF
5         CONTINUE
C FIND THE EFFECTIVE RADIUS OF THE ATOM IN THIS DIRECTION.
C NOW FIND THE MAXIMIUM RANGE OF THE LABEL IN X,Y COORDS
C        D(1) = SQRT((TENPIX*1.5)**2 + (R(1)+LABLN)**2)
          LY(1) = -TENPIX+XCENT(2)
          LX(1) = R(1)+LABLN+XCENT(1)
          IF (R(3).GT.0.707*R(2)) THEN
C          D(2) = SQRT((R(3)+TENPIX)**2 + LABLN**2)
            LY(2) = -R(3) - TENPIX + XCENT(2)
            LX(2) = LABLN + XCENT(1)
          ELSE
C          D(2) = SQRT((0.707*R(2)+TENPIX)**2 + LABLN**2)
            LY(2) = -0.707*R(2) - TENPIX + XCENT(2)
            LX(2) = LABLN + XCENT(1)
          ENDIF
          IF (R(3).GT.0.707*R(4)) THEN
C          D(3) = SQRT((R(3)+TENPIX)**2 + LABLN**2)
            LY(3) = -R(3) - TENPIX + XCENT(2)
            LX(3) = -LABLN + XCENT(1)
          ELSE
C          D(3) = SQRT((0.707*R(4)+TENPIX)**2 + LABLN**2)
            LY(3) = -0.707*R(4) - TENPIX + XCENT(2)
            LX(3) = -LABLN + XCENT(1)
          ENDIF
C        D(4) = SQRT(TENPIX**2 + (R(5)+LABLN)**2)
           LX(4) = -R(5) - LABLN + XCENT(1)
           LY(4) = -TENPIX + XCENT(2)
           LX(5) = LX(4)
           LY(5) = TENPIX + XCENT(2)
C        D(5) = D(4)
          IF (R(7).GT.0.707*R(6)) THEN
C          D(6) = SQRT((R(7)+TENPIX)**2 + LABLN**2)
            LX(6) = -LABLN + XCENT(1)
            LY(6) = R(7) + TENPIX + XCENT(2)
          ELSE
C          D(6) = SQRT((0.707*R(6)+TENPIX)**2  + LABLN**2)
           LX(6) = - LABLN + XCENT(1)
           LY(6) = 0.707*R(6) + TENPIX + XCENT(2)
          ENDIF
          LX(7) = LABLN + XCENT(1)
          IF (R(7).GT.0.707*R(8)) THEN
C          D(7) = SQRT((R(7)+TENPIX)**2 + LABLN**2)
            LY(7) = R(7) + TENPIX + XCENT(2)
          ELSE
C           D(7) = SQRT((0.707*R(8)+TENPIX)**2 + LABLN**2)
            LY(7) = 0.707*R(8) + TENPIX + XCENT(2)
          ENDIF
C        D(8) = D(1)
          LX(8) = LABLN + XCENT(1) + R(8)
          LY(8) = TENPIX + XCENT(2)
C THE SPACE AROUND THE ATOM IS DIVIDED INTO 8 45 DEGREE SEGMENTS.
C THESE ARE FLAGGED AS OCCUPIED WHEN ANY ATOM IS FOUND WITHIN THEM.
          DO 20 J = 1,8
            ISEG(J) = 0
C CHECK THAT THE LABEL FALLS WITHIN THE BOUNDARIES
            IF (LX(J).LT.XMIN .OR. LX(J).GT.XMAX
     +      .OR. LY(J).LT.YMIN .OR. LY(J).GT. YMAX )
     +      ISEG(J) = 0
20        CONTINUE
          DO 30 J = ISVIEW,IFVIEW-1,IPACKT
            IF ((I.EQ.J).OR.(NINT(RSTORE(J+IPCK+1)).LT.0)) GOTO 30
            X2 = RSTORE(J+IXYZO)
            Y2 = RSTORE(J+IXYZO+1)
            Z2 = RSTORE(J+IXYZO+2)
            C2 = RSTORE(J+IATTYP+5)
            IF (NINT(RSTORE(J)).EQ.1) THEN
              R2 = 0.0
            ELSE IF (NINT(RSTORE(J)).EQ.2) THEN
              R2 = RSTORE(J+IATTYP+4)
            ELSE
              R2 = SQRT (ABS ( RSTORE (J+IXYZO+12) ) )
            ENDIF
            CALL ZRCOS (XCENT(1),XCENT(2),X2,Y2,RCOS,DY,DIST)
            IF (DIST.LT.0.0) THEN
C OVERLAPPING ATOMS - LABEL THE FRONT ONE
              IF (RSTORE(J+IXYZO+2).GT.RSTORE(I+IXYZO+2)) GOTO 13
            ENDIF
            CALL ZFIDSG (RCOS,DY,IS)
C NEED TO KNOW THE SEGMENT FOR BOND CHECKING LATER
            IF (DIST.GT.TENPIX*REAL(ILEN)*1.5) GOTO 60
            CALL ZLABCH (IS,X2,Y2,R2,IPT,LX(IS),LY(IS),TENPIX,LABLN)
            IF (IPT.EQ.1) THEN
C YES - FLAG SECTOR
              ISEG (IS) = 1.0
              ISS = IS
C DECREMENT THE SEGMENT NUMBER UNTIL WE ARE SURE THAT THE ATOM IS NOT
C IN A SEGMENT
55            CONTINUE
              ISS = ISS - 1
C JUMP OUT IF ALL OF THE ATOM IS OBSCURED
              IF (ISS.EQ.0) ISS = 8
              IF (ISS.EQ.IS) GOTO 59
              CALL ZLABCH (ISS,X2,Y2,R2,IPT,LX(ISS),LY(ISS),
     c                     TENPIX,LABLN)
              IF (IPT.EQ.1) THEN
                ISEG(ISS)=1.0
                GOTO 55
              ENDIF
              ISS = IS
57            CONTINUE
              ISS = ISS + 1
              IF (ISS.GT.8) ISS = ISS - 8
C JUMP OUT ONCE YOU HAVE GONE ROUND ONCE
              IF (ISS.EQ.IS) GOTO 59
              CALL ZLABCH (ISS,X2,Y2,R2,IPT,LX(ISS),LY(ISS),
     c                     TENPIX,LABLN)
              IF (IPT.EQ.1) THEN
                ISEG(ISS)=1.0
                GOTO 57
              ENDIF
            ENDIF
59          CONTINUE
C IS THERE A BOND?
60          CONTINUE
            M = 0
            IBNDST = NINT(RSTORE(I+IBOND))
            NBONDS = NINT(RSTORE(I+IBOND+1))
            DO 80 K = 0,NBONDS*2-1,2
              N = NINT(RSTORE(IBNDST-K))
              IF (N.EQ.J) M = 1
80          CONTINUE
            IF (M.EQ.1) THEN
              ISEG(IS) = 1.0
            ENDIF
            IF (ILSEC.EQ.1) THEN
C NOW LOOK FOR A SECONDARY BOND
              IBNDST = NINT(RSTORE(J+IBOND))
              NBONDS = NINT(RSTORE(J+IBOND+1))
              DO 110 K = 0,NBONDS*2-1,2
                N = NINT(RSTORE(IBNDST-K))
                IF (N.EQ.I) GOTO 110
C BOND DOESN'T COUNT IF ATOM IS EXCLUDED
                IF (RSTORE(J+IPCK+1).LT.0.0) GOTO 110
C FIND THE EQUATION OF THE LINE OF THE BOND
                RM1 = ( RSTORE (N+IXYZO+1) - RSTORE(J+IXYZO+1) ) /
     c             ( RSTORE (N+IXYZO)   - RSTORE(J+IXYZO )  )
                C1 = RSTORE(N+IXYZO+1) - RM1*RSTORE(N+IXYZO)
                X3 = RSTORE(N+IXYZO)
                Y3 = RSTORE(N+IXYZO+1)
                RM1 = ( Y2 - Y3 ) / ( X2 - X3 )
                C1 = Y2 - RM1*X2
C THE FIRST ATOM LIES AT IS. FIND THE VALUE OF THE SECOND ATOM
                CALL ZRCOS (XCENT(1),XCENT(2),X3,Y3,RCOS,DY,DIST)
                CALL ZFIDSG (RCOS,DY,IS1)
CIF BOND IS ON THE SAME SEGMENT IT WILL ALREADY HAVE BEEN BLOCKED OFF
                IF (IS.EQ.IS1) GOTO 110
C WE WILL CHECK BOTH OF THESE ATOMS AT SOME POINT SO WE ONLY NEED TO
C CHECK IS+1 TO IS1-1.
                ISTP = 1
                IF (IS.GT.IS1) ISTP = -1
                DO 90 M = IS+ISTP,IS1-ISTP,ISTP
C NOW FIND THE EQUATION OF THE LINE JOINING THE ATOM CENTRE WITH THE
C POINTS LX(M) AND LY(M)
                  RM = ( XCENT(2) - LY(M) ) / ( XCENT(1) - LX(M) )
                  C = XCENT(2) - RM*XCENT(1)
C THESE LINES WILL INTERSECT AT X4 AND Y4.
                  X4 = ( C1 - C ) / ( RM - RM1 )
                  Y4 = X4 * RM + C
C FIND THE DISTANCES
                  D = ( LX(M) - XCENT(1) )**2 +
     c            ( LY(M) - XCENT(2) )**2
                  D1 = ( X4 - XCENT(1) )**2 +
     c            ( Y4 - XCENT(2) )**2
                  IF (D1.LT.D) ISEG(M) = 1.0
90              CONTINUE
110           CONTINUE
            ENDIF
C LOOK FOR ANY LABELS ALREADY DRAWN
            IF ((I.GT.J).AND.(NINT(RSTORE(J+IATTYP+2)).GT.0.0)) THEN
C FIND THE LABEL POSITION
              XPS = RSTORE(J+ILAB)
              YPS = RSTORE(J+ILAB+1)
              RLL = RSTORE(J+ILAB+2)
              IF (RLL.LE.0.0) GOTO 30
C ATOM NOT LABELLED
C FIRST CHECK FOR OVERLAP IN THE X DIRECTION
C NEED TO CHECK ALL FOUR CORNERS OF THE LABEL.
              CALL ZLABO (XCENT,LX,LY,LABLN,XPS,YPS,RLL,ISEG,TENPIX)
            ENDIF
C THE TENPIX*0.5 IN THE ABOVE CODE IS ADDED SO THAT LABELS DO NOT
C COME TOO CLOSE TO EACH OTHER.
30        CONTINUE
          CALL ZLABSP (ISEG,IS)
          IF (IS.EQ.0) GOTO 13
          IF ((IS.LE.2).OR.(IS.GE.7)) THEN
C NEED TO DECREMENT X
            LX(IS) = LX(IS) - LABLN
          ENDIF
          IF (IS.GT.4) THEN
C NEED TO ALTER Y
            LY(IS) = LY(IS) - TENPIX
          ENDIF
          IX = NINT (( LX(IS) - XCP ) *SCALE )
          IY = NINT (( LY(IS) - YCP ) *SCALE )
          IF ((IS.NE.4).AND.(IS.NE.5)) THEN
C NEED EXTRA CHECKING. THESE CAN GO INTO MORE THAN ONE REGION.
            XX = LX(IS) + LABLN
            YY = LY(IS)
            CALL ZRCOS (XCENT(1),XCENT(2),XX,YY,RCOS,DY,DIST)
            CALL ZFIDSG(RCOS,DY,ISS)
            IF (ISEG(ISS).EQ.1) THEN
C FAIL - GOES INTO OCCUPIED SECTOR
              GOTO 13
            ENDIF
            ISSTEP = 1
            IF (IS.LT.ISS) ISSTEP = -1
            DO 70 JJ = IS , ISS , ISSTEP
              IF (ISEG(JJ).EQ.1) GOTO 13
70          CONTINUE
          ENDIF
          RSTORE(I+ILAB) = LX(IS)
          RSTORE(I+ILAB+1) = LY(IS)
          RSTORE(I+ILAB+2) = LABLN
          CALL ZDRTEX(IX,IY,CLAB(1:IL),IDEVCL(ILABCL+1))
          IDLAB = 1
13        CONTINUE
C          IF ((II.EQ.1).AND.(ABS(RSTORE(I+ILAB+2)-0.0).LT.0.01).AND.
C     c      (NINT(RSTORE(I+IATTYP+2)).EQ.2)) THEN
C           WRITE (ISTOUT,12) CSTORE(KK)
C12         FORMAT ('Priority labelling of ',A6,' has failed.')
C FORCE LABELLING
          IF (IDLAB.EQ.0) THEN
            RSTORE(I+ILAB) = XCENT(1)
            RSTORE(I+ILAB+1) = XCENT(2)
            RSTORE(I+ILAB+2) = LABLN
            IX = NINT (( XCENT(1) - XCP ) *SCALE )
            IY = NINT (( XCENT(2) - YCP ) *SCALE )
            CALL ZDRTEX (IX,IY,CLAB(1:IL),IDEVCL(ILABCL+1))
          ENDIF
        IDLAB = 0
10      CONTINUE
        IVCHAN = 0
        RETURN
        END
 
CODE FOR ZLABO [ LABEL OVERLAP ]
      SUBROUTINE ZLABO (XCENT,LX,LY,LABLN,XL,YL,RLL,ISEG,TENPIX)
C THIS SUBROUTINE CHECKS TO SEE WHETHER OR NOT TWO LABELS OVERLAP.
C FIRST FIND THE SEGMENT OF THE LABEL
C LX,LY ARE ARRAYS CONTAINING THE PROSPECTIVE LABEL POSTIONS
CIN ALL 8 SEGMENTS
C XL, YL ARE THE COORDS OF THE LABEL BEING EXAMINED.
      INCLUDE 'COMMON.INC'
      REAL XCENT(2),LX(8),LY(8),XL,YL,RLL,LABLN
      INTEGER ISEG(8)
      CALL ZRCOS (XCENT(1),XCENT(2),XL,YL,RCOS,DY,DIST)
cdjw      CALL ZFIDSG (ROCS,DY,IS)
      CALL ZFIDSG (RCOS,DY,IS)
C IS THIS SEGMENT ALREADY OCCUPIED?
      IF (ISEG(IS).EQ.1) THEN
C YES
        RETURN
      ENDIF
C CHECK THE LABEL IN THE X AND Y DIRECTIONS
      IF ((IS.LE.2).OR.(IS.GE.7)) THEN
        XRIGHT = LX(IS)
        XLEFT = LX(IS) - LABLN
      ELSE
        XRIGHT = LX(IS) + LABLN
        XLEFT = LX(IS)
      ENDIF
      IF ( ( (XL.LT.XLEFT).AND.(XL+RLL.GT.XLEFT)).OR.
     c     ( (XL.LT.XRIGHT).AND.(XL+RLL.GT.XRIGHT)) .OR.
     c     ( (XL.LT.XLEFT).AND.(XL+RLL.GT.XRIGHT)) ) THEN
C NOW WE HAVE TO CHECK THE Y DIRECTION
C GIVE IT AN EXTRA 10% GAP
        IF (IS.LE.4) THEN
          YTOP = LY(IS)
          YBOT = LY(IS) + TENPIX*1.1
        ELSE
          YTOP = LY(IS) - TENPIX*1.1
          YBOT = LY(IS)
        ENDIF
        IF ( ( ( YL.LT.YBOT).AND.(YL+TENPIX*1.1.GT.YBOT)) .OR.
     c       ( ( YL.LT.YTOP).AND.(YL+TENPIX*1.1.GT.YBOT)) .OR.
     c       ( ( YL.LT.YTOP).AND.(YL+TENPIX*1.1.LT.YTOP)) ) THEN
          ISEG (IS) = 1
        ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZOVERL
      SUBROUTINE ZOVERL
      INCLUDE 'COMMON.INC'
C THIS ROUTINE CALCULATES THE OVERLAPPING ATOMS FOR NON RASTER DEVICES.
      DO 100 I = ISVIEW , IFVIEW - 1 , IPACKT
        IF (NINT(RSTORE(I+IPCK+1)).LT.0) GOTO 100
C FIND THE FURTHEST DISTANCE
        NOVER = 0
        DMAX2 = 2.0
C LOOP OVER THE BONDS
C WE NEED THE ATOMS AT THE ENDS OF THE BONDS TO BE INCLUDED IN THE CALC.
        IBNDST = NINT ( RSTORE ( I + IBOND ) )
        NBONDS = NINT ( RSTORE ( I + IBOND + 1 ) )
        IF (NBONDS.EQ.0) GOTO 100
        DO 110 J = 0, NBONDS
          NN = NINT (RSTORE ( IBNDST - J*2 ) )
          IF (NN.EQ.0) GOTO 110
          IF (NINT(RSTORE(NN+IPCK+1)).LT.0) GOTO 110
          D = ( RSTORE ( I + IXYZO ) - RSTORE ( NN + IXYZO ) ) **2
     c      + ( RSTORE ( I + IXYZO + 1 ) - RSTORE (NN + IXYZO + 1 )) **2
          IF (D.GT.DMAX2) DMAX2 = D
110     CONTINUE
        DMAX = SQRT(DMAX2)
        DO 120 J = ISVIEW , IFVIEW - 1 , IPACKT
          IF (I.EQ.J) GOTO 120
C ATOM MUST BE INCLUDED!
          IF (NINT(RSTORE(J+IPCK+1)).LT.0) GOTO 120
C ONLY COUNT OVERLAP BETWEEN ATOMS OF HIGHER Z
          IF (RSTORE(I+IXYZO+2).GT.RSTORE(J+IXYZO+2)) GOTO 120
          IF (ABS( RSTORE(I+IXYZO) - RSTORE(J+IXYZO)).GT.DMAX) GOTO 120
          IF (ABS( RSTORE(I+IXYZO+1)-RSTORE(J+IXYZO+1)).GT.DMAX)
     c GOTO 120
C COULD BE WITHIN RANGE
          D = ( RSTORE(I+IXYZO)-RSTORE(J+IXYZO))**2 +
     c        ( RSTORE(I+IXYZO+1)-RSTORE(J+IXYZO+1))**2
          IF (D.GT.DMAX2) GOTO 120
C IS WITHIN RANGE - STORE
          RSTORE (IREND-NOVER) = J
          NOVER = NOVER + 1
120     CONTINUE
C STORE THE LOCATION AND NUMBER OF OVERLAPPED ATOMS
        RSTORE ( I + ILAB + 3 ) = IREND
        RSTORE ( I + ILAB + 4 ) = NOVER
        IREND = IREND - NOVER
100   CONTINUE
      RETURN
      END
 
CODE FOR ZOVERL
      SUBROUTINE ZZOVERL
      INCLUDE 'COMMON.INC'
C THIS ROUTINE CALCULATES THE OVERLAPPING ATOMS FOR NON RASTER DEVICES.
      DO 100 I = ISVIEW , IFVIEW - 1 , IPACKT
C FIND THE FURTHEST DISTANCE
        NOVER = 0
        DMAX2 = 2.0
C LOOP OVER THE BONDS
C WE NEED THE ATOMS AT THE ENDS OF THE BONDS TO BE INCLUDED IN THE CALC.
        IBNDST = NINT ( RSTORE ( I + IBOND ) )
        NBONDS = NINT ( RSTORE ( I + IBOND + 1 ) )
        IF (NBONDS.EQ.0) GOTO 100
        DO 110 J = 0, NBONDS
          NN = NINT (RSTORE ( IBNDST - J*2 ) )
          IF (NN.EQ.0) GOTO 110
          D = ( RSTORE ( I + IXYZO ) - RSTORE ( NN + IXYZO ) ) **2
     c      + ( RSTORE ( I + IXYZO + 1 ) - RSTORE (NN + IXYZO + 1 )) **2
          IF (D.GT.DMAX2) DMAX2 = D
110     CONTINUE
        DMAX = SQRT(DMAX2)
        DO 120 J = ISVIEW , IFVIEW - 1 , IPACKT
          IF (I.EQ.J) GOTO 120
C ATOM MUST BE INCLUDED!
          IF (NINT(RSTORE(J+IPCK+1)).LT.0) GOTO 120
C ONLY COUNT OVERLAP BETWEEN ATOMS OF HIGHER Z
          IF (RSTORE(I+IXYZO+2).GT.RSTORE(J+IXYZO+2)) GOTO 120
          IF (ABS( RSTORE(I+IXYZO) - RSTORE(J+IXYZO)).GT.DMAX) GOTO 120
          IF (ABS( RSTORE(I+IXYZO+1)-RSTORE(J+IXYZO+1)).GT.DMAX)
     c GOTO 120
C COULD BE WITHIN RANGE
          D = ( RSTORE(I+IXYZO)-RSTORE(J+IXYZO))**2 +
     c        ( RSTORE(I+IXYZO+1)-RSTORE(J+IXYZO+1))**2
          IF (D.GT.DMAX2) GOTO 120
C IS WITHIN RANGE - STORE
          RSTORE (IREND-NOVER) = J
          NOVER = NOVER + 1
120     CONTINUE
C STORE THE LOCATION AND NUMBER OF OVERLAPPED ATOMS
        RSTORE ( I + ILAB + 3 ) = IREND
        RSTORE ( I + ILAB + 4 ) = NOVER
        IREND = IREND - NOVER
100   CONTINUE
      RETURN
      END
 
 
CODE FOR ZLABCH
      SUBROUTINE ZLABCH (IS,XC,YC,R2,IPT,XL,YL,TENPIX,LABLN)
      REAL XL,YL,LABLN
C THIS SUBROUTINE CHECKS WHETHER AN ATOM LIES OVER THE LABEL POSITION
      IPT = 0
C SET UP THE TOP AND BOTTOM LABEL NUMBERS
      IF (IS.LE.4) THEN
        YTOP = YL
        YBOT = YL + TENPIX
      ELSE
        YTOP = YL - TENPIX
        YBOT = YL
      ENDIF
      IF ((YC+R2.GT.YTOP).AND.(YC-R2.LT.YTOP)) THEN
        ITOP = 1
      ELSE IF ((YC+R2.GT.YBOT).AND.(YC-R2.LT.YBOT)) THEN
        ITOP = 2
      ELSE
        RETURN
      ENDIF
C NOW SET THE LEFT AND RIGHT MARKERS - RELATIVE TO XC
      IF ((IS.LE.2).OR.(IS.GE.7)) THEN
        XLEFT = XL - XC - LABLN
        XRIGHT = XL - XC
      ELSE
        XLEFT = XL - XC
        XRIGHT = XL - XC + LABLN
      ENDIF
C FIND THE RELATIVE INTERSECTION
      IF (ITOP.EQ.1) THEN
        XX = SQRT ( R2**2 - ( YTOP - YC ) ** 2 )
      ELSE
        XX = SQRT ( R2**2 - ( YBOT - YC ) ** 2 )
      ENDIF
      IF ((XX.GT.XLEFT).AND.(XX.LT.XRIGHT)) THEN
        IPT = 1
      ELSE IF ((-XX.GT.XLEFT).AND.(-XX.LT.XRIGHT)) THEN
        IPT = 1
      ELSE IF ((-XX.LT.XLEFT).AND.(XX.GT.XRIGHT)) THEN
        IPT = 1
      ENDIF
      RETURN
      END
 
CODE FOR ZRCOS
      SUBROUTINE ZRCOS (X1,Y1,X2,Y2,RCOS,DY,DIST)
C This routine finds the angle at which the at1-at2 vector lies.
      DX = X2-X1
      DY = Y2-Y1
      DIST = SQRT ((X1-X2)**2 + (Y1-Y2)**2)
      IF ((DIST-0.0).LT.0.0001) THEN
        DIST = -1.0
        RCOS = 0.0
        RETURN
      ENDIF
      RCOS = DX/DIST
      RETURN
      END
 
 
 
CODE FOR ZLABSP
      SUBROUTINE ZLABSP (ISEG,IS)
C THIS ROUTINE FINDS THE BEST FREE SECTOR IN WHICH TO PLACE THE LABEL.
      INTEGER ISEG(8),IS
      NMAX = 0
      IFREE = -1
      ICOUNT = 0
      DO 10 I = 1,2
        DO 20 J = 1,8
          IF (ISEG(J).NE.1) THEN
            ICOUNT = ICOUNT + 1
          ELSE
            IF (ICOUNT.GT.NMAX) THEN
              NMAX = ICOUNT
              IF (J.GT.1) THEN
                IFREE = J-1
              ELSE
                IFREE = 8
              ENDIF
            ENDIF
            ICOUNT = 0
          ENDIF
20      CONTINUE
10    CONTINUE
      IF (IFREE.EQ.-1) THEN
        IS = 1
        RETURN
      ENDIF
      IS = IFREE - NMAX/2
C      IF (NMAX.EQ.2) THEN
C         IF ((IS.EQ.3).AND.(ISEG(4).EQ.1)) THEN
C           IS = 2
C         ENDIF
C         IF ((IS.EQ.7).AND.(ISEG(8).EQ.1)) THEN
C           IS = 6
C         ENDIF
C      ENDIF
      IF ((IS.LE.0).AND.(NMAX.NE.0)) IS = IS + 8
      RETURN
      END
 
CODE FOR ZELINT
      SUBROUTINE ZELINT (E1,E2,PP,AXES,VEC2,VEC3,IARC)
      INCLUDE 'COMMON.INC'
      REAL E1(3),E2(3),PP(4),AXES(3,3),VEC2(3),VEC3(3),VL(3)
      REAL VB(3),V1E(3),V2E(3),V3E(3),VLOLD(3,2)
      INTEGER A(3),B(3),IARC(4)
      DATA A/1,1,2/
      DATA B/2,3,3/
      IARC(1) = 0
C This subroutine finds out where the principal ellipse intersects with
C the bounding ellipse.
C VEC2 and VEC3 define the bounding ellipse in 3 dimensions
C AXES contain the principal ellipse info in 3 dimensions
C E1 , E2 , PP contain the principal ellipse info once projected.
C The vector perpendicular to a plane is found from the cross product of
C the two vectors that define the plane.
C See Bostok and Chandler, Pure Maths 2 , p229.
C Find the vector to be perpendicular to the bounding ellipse.
      II = NCROP3 (VEC2,VEC3,VB)
      DO 10 K = 1 , 3
C Get the principal ellipse vectors
        DO 20 J = 1 , 3
          V1E(J) = AXES (J,A(K))
          V2E(J) = AXES (J,B(K))
20      CONTINUE
C Now find the perpendicular vector
        II = NCROP3 (V1E,V2E,V3E)
C Now find the vector perpendicular to both of these which will be
C parallel to the line of intersection.
        II = NCROP3 (VB,V3E,VL)
C STORE THE OLD VL VECTOR
        IF (K.LT.3) THEN
          DO 30 KK = 1 , 3
            VLOLD(KK,K) = VL(KK)
30        CONTINUE
        ENDIF
        IF (II.EQ.-1) THEN
C THE TWO PLANES ARE PARALLEL
          IARC(K+1) = 0
          GOTO 10
        ENDIF
        ANG = ATAN2 ( VL(2) , VL(1) )
C CHECK TO SEE WHETHER WE HAVE HAD THIS VL VECTOR BEFORE
        IF (K.NE.1) THEN
          DO 40 KK = 1 , K-1
            IF ((ABS(VLOLD(1,KK)-VL(1)).LT.0.0000001).AND.
     c          (ABS(VLOLD(2,KK)-VL(2)).LT.0.0000001).AND.
     c          (ABS(VLOLD(3,KK)-VL(3)).LT.0.0000001)) THEN
              ANG = ANG - PI
              GOTO 44
            ENDIF
40        CONTINUE
44        CONTINUE
        ENDIF
        IF (ANG.LT.0.0) ANG = ANG + 2.0*PI
        IARC (K+1) = ( ANG - PP(K+1) ) * 180.0 / PI
C FIND OUT WHERE THE AXES INTERSECT WITH THE ELLIPSE
C WHAT IS THE ANGLE OF V2E?
        IF ((ABS(V2E(2)).LT.0.0000001).AND.(ABS(V2E(1)).LT.0.0000001))
     c  THEN
          ANG1 = ATAN2 ( V1E(2) , V1E(1) ) - PI/2.0
        ELSE
          ANG1 =  ATAN2 ( V2E(2) , V2E(1) )
        ENDIF
        IF (ANG1.LT.0.0) ANG1 = ANG1 + 2.0*PI
C CHECK THAT ANG1 IS IN RANGE
        IF (ANG1.LT.ANG) THEN
          IF (ANG.GT.PI) THEN
C WE NEED TO FIND THE OTHER END IF THE VALUES HAVE 'LOOPED ROUND'.
C For example if ANG is 350 degrees and ANG1 is 20 degrees this is
C needed. Since 350+180 > 20+360.
            IF (ANG-PI.LT.ANG1) THEN
              IARC(K+1) = IARC(K+1) - 180
            ENDIF
          ELSE
            IARC(K+1) = IARC(K+1) - 180
          ENDIF
        ELSE IF (ANG1-ANG.GT.PI) THEN
          IARC(K+1) = IARC(K+1) + 180
        ENDIF
        IF (IARC(K+1).LT.-359) IARC(K+1) = IARC(K+1) + 360
        IF (IARC(K+1).GT.360) IARC(K+1) = IARC(K+1) - 360
10    CONTINUE
      RETURN
      END
 
CODE FOR ZPLABL
      SUBROUTINE ZPLABL (I,CLAB,IL)
      INCLUDE 'COMMON.INC'
      CHARACTER*(*) CLAB
      CHARACTER*10 CLNUM
      CHARACTER*1 CNUMS(10)
      SAVE CNUMS
      DATA CNUMS/'0','1','2','3','4','5','6','7','8','9'/
      CLAB = '                    '
C CONVERT THE PACK NUMBER
      KK = (I-ISINIT)/IPACKT + ICATOM
      IPPACK = NINT(RSTORE(I+IPCK))
      ICLP = 1
1000  CONTINUE
      IPN = MOD (IPPACK,10)
      CLNUM(ICLP:ICLP) = CNUMS(IPN+1)
      IPPACK = IPPACK/10
      IF (IPPACK.GT.0) THEN
        ICLP = ICLP + 1
        GOTO 1000
      ENDIF
C MOVE OVER THE NUMBER
      CLAB(1:IL+1) = CSTORE(KK)(1:IL)//'_'
      DO 1100 J = ICLP , 1 , -1
        CLAB(IL+2+ICLP-J:IL+2+ICLP-J) = CLNUM(J:J)
1100  CONTINUE
      IL = INDEX (CLAB,' ') - 1
      RETURN
      END
 
CODE FOR ZCOLL
C COLLECT ROUTINE
C THIS COLLECT ROUTINE WORKS ON THE BASIS OF THE CURRENT CONNECITIVITY.
C THE ASSYMETRIC UNIT IS DIVIDED ACCORDING TO ITS FRAGMENTS
C AND THESE ARE THEN CONNECTED.
      SUBROUTINE ZCOLL
      INCLUDE 'COMMON.INC'
C THE ATOMS CONTAINED IN THE FRAGMENTS ARE HELD AT RSTORE(IRLAST)
C UPWARDS, CURRENT POSITION IS IFRAGP
C THE NUMBER OF ATOMS IN EACH FRAGMENT IS HELD AT RSTORE(IREND)
C DOWNWARDS. NO OF FRAGMENTS IS INFRAG.
C FIRST WORK OUT THE FRAGMENTS
      IF (ISINIT.NE.ISVIEW) THEN
        CALL ZMORE('COLLECT works with initial data only.',0)
        IPROC = 0
        RETURN
      ENDIF
      IAT = ISINIT + IPACKT * 8
      IFRAGP = IRLAST
      INFRAG = 0
5     CONTINUE
      IFOLD = IFRAGP
      RSTORE(IFRAGP) = IAT
      RSTORE(IAT) = -RSTORE(IAT)
      RSTORE(IREND-INFRAG) = 1
10    CONTINUE
C LOOP OVER THE CONNECTIVITY OF ATOM IAT
      NBNDST = NINT(RSTORE(IAT+IBOND))
      NBONDS = NINT(RSTORE(IAT+IBOND+1))
      DO 20 I = NBNDST , NBNDST - (NBONDS-1)*2 , -2
        K = NINT(RSTORE(I))
        IF (K.EQ.0) GOTO 20
C NOW WE HAVE A NEW ATOM - HAS IT ALREADY BEEN FOUND?
        IF (RSTORE(K).LT.0) GOTO 20
C OTHERWISE STORE IT
        IFRAGP = IFRAGP + 1
        RSTORE(IFRAGP) = K
        RSTORE(K) = -RSTORE(K)
        RSTORE(IREND-INFRAG) = RSTORE(IREND-INFRAG) + 1
20    CONTINUE
C NOW UPDATE IAT
      IF (IFOLD.NE.IFRAGP) THEN
C GET NEXT ATOM IN THIS FRAGMENT
        IAT = RSTORE(IFOLD+1)
        IFOLD = IFOLD + 1
        GOTO 10
      ENDIF
C LOOK TO SEE IF THERE ARE ANY UNUSED ATOMS
      DO 30 I = ISINIT+IPACKT * 8 , IFINIT - 1, IPACKT
        IF (RSTORE(I).GT.0) THEN
          IAT = I
          INFRAG = INFRAG + 1
          GOTO 5
        ENDIF
30    CONTINUE
      RETURN
      END
 
CODE FOR LGNDST [ GENERAL DISTANCE ROUTINE - INCLUDES SYMMETRY ]
      FUNCTION LGNDST (X,X1,C,NS,DIST)
C This is a general distance routine which incorporates the use of
C symmetry operators.
C X is the crystal coords of the pivot atom, C is its connectivity
C radius, X1 is the coords of the other atom.
C DIST IS THE MINIMUM CONNECTION RADIUS IF A BOND DISTANCE
C IS NOT FOUND
      INCLUDE 'COMMON.INC'
      REAL X(3),X1(3),X2(3),C,ORTH(3,3),SYMM(4,4),DX(3),DX1(3)
      REAL XD(3)
C The distance routine is based on that in Rollett p27.
C However, this routine assumes that, since C is the connectivity radius
C and is therefore small there will not be more than one connecting
C distance possible for each symmetry operator.
C Also, as this routine does not generate more atoms, once one
C connection is found the routine is ended.
      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
      DD = -1.0
C Loop over the symmetry operators.
      DO 5 II = 1,NSYMM
        NS = II
        CALL ZMOVE (RSTORE(ITOT-(II*16)),SYMM,16)
        DO 7 K = 1,3
          X2(K) = SYMM(K,1)*X1(1) + SYMM(K,2)*X1(2) + SYMM(K,3)*X1(3)
     c  + SYMM(K,4)
7       CONTINUE
        DO 10 K = 1,3
20        CONTINUE
          DIST = (X(K)-X2(K))*D000(K)
          IF (DIST.LE.C) THEN
            X2(K) = X2(K) - 1.0
            GOTO 20
          ENDIF
          X2(K) = X2(K) + 1.0
          DIST = (X(K)-X2(K))*D000(K)
          IF ((DIST.GE.-C).AND.(DIST.LE.C)) THEN
C FOUND DISTANCE MOVE TO NEXT  AXIS.
            GOTO 10
          ELSE
C DISTANCE NOT FOUND. DO NEXT SYMMETRY OPERATOR.
            GOTO 5
          ENDIF
10      CONTINUE
C NOW CALCULATE THE ACTUAL DISTANCE.
        DO 40 K = 1,3
         DX(K) = X2(K) - X(K)
40      CONTINUE
        CALL ZMATV (ORTH,DX,DX1)
        DIST = DX1(1)**2 + DX1(2)**2 + DX1(3)**2
        IF (DIST.LT.C**2) THEN
C YES WE HAVE A CONNECTION.
          CALL ZMOVE (X2,X1,3)
          LGNDST = 1
          RETURN
        ENDIF
        IF (DIST.LT.DD) THEN
          DD = DIST
          ND = NS
          CALL ZMOVE(X2,XD,3)
        ENDIF
C NO CONNECTION - GET NEXT SYMMETRY OPERATOR.
5     CONTINUE
      LGNDST = 0
      RETURN
      END
 
CODE FOR LPCHCK
C      FUNCTION LPCHCK (IX,IY,I,N,IXX,IYY)
C THIS FUNCTION CHECKS WHETHER A POINT LIES OUTSIDE THE SCREEN BORDER
C AND RETURNS
C    LPCHCK = 1      DRAW POINT AS NORMAL (IXX,IYY)
C           = 0      DRAW NOTHING
C THE ARRAYS IX AND IY CONTAIN THE ORIGINAL POINTS.
C WE ARE DRAWING POINT I IN AN ARRAY OF SIZE N.
C      INTEGER IX(N),IY(N),I,N,IXX,IYY
C      REAL RM,C
C      INCLUDE 'COMMON.INC'
C      IXX = IX(I)
C      IYY = IY(I)
C      LPCHCK = 1
C      RETURN
C      IF (IX(I).GE.0 .AND. IX(I).LE.2.0*XCEN
C     +.AND. IY(I) .GE. 0.0 .AND. IY(I) .LE. 2.0*YCEN) THEN
C        IXX = IX(I)
C        IYY = IY(I)
C        LPCHCK = 1
C        RETURN
C      ENDIF
C ARE WE DRAWING A LINE FROM THE PREVIOUS POINT?
C      IVERT = 0
C      IF (IDRAWN.EQ.1) THEN
C YES WE ARE - WE NEED TO FIND WHERE THE LINE HITS THE SCREEN BOUNDARY
C        IF (IX(I).NE.IX(I-1)) THEN
C          RM = ( IY(I)-IY(I-1)) / (IX(I)-IX(I-1))
C          C = IY(I) - IX(I)*RM
C          YLEFT = C
C          YRIGHT = 2.0*XCEN*RM + C
C          XTOP = (2.0*YCEN-C)/RM
C          XBOTM = -C/RM
C        ELSE
C          IVERT = 1
C        ENDIF
C      ENDIF
C ALL THE ABOVE IS RUBBISH PLEASE IGNORE!!!
C      RETURN
C      END
 
CODE FOR LSPECH
      FUNCTION LSPECH (IATNO)
C This function checks to see if the atom is on a special position.
      INCLUDE 'COMMON.INC'
      REAL X(3),X1(3),SYMM(4,4)
      LSPECH = 0
C GET THE COORDS
      DO 10 I = 1 , 3
        X(I) = RSTORE(IATNO+I)
10    CONTINUE
      DO 20 I = 2 , NSYMM
C LOAD IN THE SYMMETRY OPERATOR
        CALL ZMOVE (RSTORE(ITOT-I*16),SYMM,16)
C DO THE MULTIPLICATION
        CALL ZMATV4 (SYMM,X,X1)
        N = 0
        DO 30 J = 1 , 3
          IF (ABS(X(J)-X1(J)).LT.0.00001) THEN
            N = N + 1
          ELSE IF (ABS(X(J)-X1(J)).GT.0.9999.AND.
     c      ABS(X(J)-X1(J)).LE.1.0001) THEN
            N = N + 1
          ENDIF
30      CONTINUE
        IF (N.EQ.3) THEN
C This lies on a special position
          LSPECH = 1
          RETURN
        ENDIF
20    CONTINUE
      RETURN
      END
 
CODE FOR LSPEC
      FUNCTION LSPEC (X,IATNO,IS,IF)
C This function checks for the existence of an atom at the
C X coordinates in the current list
      INCLUDE 'COMMON.INC'
      CHARACTER*(ICLEN) CLAB
      REAL X(3)
C GET THE LABEL
      LSPEC = 1
      II = (IATNO-ISINIT)/IPACKT + ICATOM
      CLAB = CSTORE(II)
C NOW DO THE LOOP
      ISC = (IS-ISINIT)/IPACKT + ICATOM
      IFC = (IF-IFINIT)/IPACKT + ICATOM
      DO 10 I = ISC , IFC - 1
        IF (CSTORE(I).NE.CLAB) GOTO 10
        N = 0
C CHECK THE COORDS
        II = (I-ICATOM)*IPACKT + ISINIT
        DO 20 J = 1 , 3
          IF (ABS(RSTORE(II+J)-X(J)).LT.0.00001) N = N + 1
20      CONTINUE
        IF (N.EQ.3) THEN
          LSPEC = 0
          RETURN
        ENDIF
10    CONTINUE
      RETURN
      END
 
CODE FOR ZDOOPS
      SUBROUTINE ZDOOPS(JRT,CEN,NCV,TRAN,NCENT)
      INCLUDE 'COMMON.INC'
      INTEGER JRT(3,4,25)
      REAL CEN(3,4)
      REAL TRAN(11)
      REAL SYMM(4,4)
C This works out the symmetry operators from the information
C passed back from YGROUP.
C WORK OUT THE SYMMETRY OPERATORS
      DO 10 II = 1 , NSYMM
        DO 20 J = 1 , 3
          DO 30 K = 1 , 3
            SYMM (J,K) = REAL (JRT (J,K,II) )
30        CONTINUE
C NOW WORK OUT THE TRANSLATIONAL BITS
          SYMM (J,4) = TRAN ( JRT(J,4,II ) + 1 )
          SYMM (4,J) = 0.0
20      CONTINUE
        SYMM (4,4) = 1.0
        CALL ZMOVE (SYMM,RSTORE(ITOT-II*16),16)
10    CONTINUE
      ISYMED = ITOT - NSYMM*16
C CHECK FOR CENTERING
      IF (NCENT.EQ.1) THEN
C CENTRIC CENTRE THE MATRICES.
        DO 40 II = 1 , NSYMM
          CALL ZMOVE (RSTORE(ITOT-II*16),SYMM,16)
          DO 50 J = 1,3
            DO 60 K = 1,3
              SYMM (J,K) = - SYMM (J,K)
60          CONTINUE
50       CONTINUE
C STORE THESE NEW MATRICES
          CALL ZMOVE (SYMM,RSTORE(ISYMED-II*16),16)
40      CONTINUE
      ISYMED = ITOT - NSYMM*32
      ENDIF
C NOW CHECK FOR CENTRING VECTORS
      IF (NCV.NE.1) THEN
C YES CENTRING VECTORS
        DO 70 L = 2 , NCV
          DO 80 II = 1 , NSYMM*(NCENT+1)
C GET THE MATRIX
            CALL ZMOVE (RSTORE(ITOT-II*16),SYMM,16)
            DO 90 J = 1,3
              SYMM (J,4) = SYMM (J,4) + CEN (J,L)
              IF (SYMM(4,J).GT.1.0) SYMM(4,J) = SYMM(4,J) - 1.0
              IF (SYMM(4,J).LT.0.0) SYMM(4,J) = SYMM(4,J) + 1.0
90          CONTINUE
C STORE IT
            CALL ZMOVE (SYMM,RSTORE(ISYMED-II*16),16)
80        CONTINUE
C NEED TO MODIFY ISYMED
        ISYMED = ITOT - NSYMM*16*(NCENT+1)*L
70      CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZRING
      SUBROUTINE ZRING(IATNO)
C This subroutine draws the filled ring representation.
      INCLUDE 'COMMON.INC'
C FIRST WE HAVE TO WORK OUT THE ATOMS IN THE RING
      INTEGER IX(50),IY(50)
      INTEGER IPOS
      INTEGER IAT
      LOGICAL LFOUND
      IPOS = IRLAST
      RSTORE(IRLAST) = IATNO
      IAT = IATNO
      ZPOS = RSTORE(IATNO+IXYZO+2)
10    CONTINUE
C GET THE CONNECTIVITY
      LFOUND = .FALSE.
      NBNDST = NINT(RSTORE(IAT+IBOND))
      NBONDS = NINT(RSTORE(IAT+IBOND+1))
      DO 20 I = NBNDST , NBNDST - (NBONDS-1)*2 , -2
        J = NINT(RSTORE(I))
        IF (NINT(RSTORE(J)).NE.6) GOTO 20
C DO WE HAVE THIS ATOM ALREADY?
        KKK = 0
        DO 30 K = IRLAST , IPOS
          IF (NINT(RSTORE(K)).EQ.J) KKK = 1
30      CONTINUE
        IF (KKK.EQ.0) THEN
C STORE THE ATOM
C CHECK THE ATOMS Z COORDINATE
          IF (RSTORE(J+IXYZO+2).LT.ZPOS) RETURN
          IPOS = IPOS + 1
          RSTORE(IPOS) = J
          IAT = J
          LFOUND = .TRUE.
          GOTO 40
        ENDIF
20    CONTINUE
40    CONTINUE
C NOTE THAT WE ARE ONLY GOING TO STORE ONE NEW ATOM SO THAT WE MOVE
C AROUND THE RING
      IF (LFOUND) GOTO 10
C NOW BUILD UP THE POLYHEDRON
      DO 50 I = 1 , IPOS-IRLAST+1
        J = NINT(RSTORE(I+IRLAST-1))
        IX(I) =  NINT((RSTORE(J+IXYZO)-XCP)*SCALE)
        IY(I) = NINT((RSTORE(J+IXYZO+1)-YCP)*SCALE)
50    CONTINUE
      IX(IPOS-IRLAST+2) = IX(1)
      IY(IPOS-IRLAST+2) = IY(1)
C DRAW THE POLYGON
      ICOL = NINT(RSTORE(IATNO+IATTYP+1))
      CALL ZDRLIN (2,IX,IY,IPOS-IRLAST+2,ICOL,0)
      RETURN
      END
