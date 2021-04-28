CODE FOR TLAW2
      PROGRAM TLAW2
C      SUBROUTINE TLAW2(iout)
C
C
C WRITTEN BY BRUCE FOXMAN, 2017, 2020 (-ve DETERMINANT HANDLING)
C 2021 (AUTODETECTION OF TWINABS' SETTING "2" AS THE MAJOR
C COMPONENT).  
C SOLVE THE EQUATION H(TWIN)= [TWIN_LAW]*H(PARENT)
C SHELX HKLF 5 uses a decision about reflection overlap made during
C data reduction.  
C If the MERGE routine has transformed the indices of the minor reflections
C using Space Group Symmety, the equation above cannot be used.
C After extraction of a twin law, it is applied to every main reflection
C in the HKLF5 file to ensure that the generated indices coincide with 
C the input minor ones. 
C The determinant of the twin law should be Unity. If it is negative or
C substantially different from unity, a warning that the input data has
C probably been merged is passed to the user.  If the user has included
C inversion twinning in the twin laws, then this will be flagged, the user
C informed, but no action will be taken: the file will be processed 
C with the 'regular' and the inversion twin laws.
c
      REAL HKLP(100000,3),HKLT(100000,3,7),
     1HT(3,3,7),HP(3,3,7),HTINV(3,3,7),R(3,3,7),
     2HT1,KT1,LT1,HP1,KP1,LP1
      REAL DJWT(3,7),RSV(3,3,7),DJWD(3,7),A(3,3),B(3,3),C(3,3),CI(3,3)
      INTEGER DJWI(3,7),DJWSUM(7),JTEST(7),NREF3(7),NREJ2(7)
      COMMON/MAT/R,RSV,JJMAX
      CHARACTER*1 CDJW
      DIMENSION INDX(3)
      CHARACTER*32 FILIN
C
C
      DO 90 K=1,3
      DO 90 L=1,100000
      HKLP(L,K)=0.0
      DO 90 JJ=1,7
   90 HKLT(L,K,JJ)=0.0  
      DO 92 JJ=1,7
      JTEST(JJ)=0
      NREJ2(JJ)=0
      NREF3(JJ)=0
      DO 92 J=1,3
      DO 92 I=1,3
      HP(I,J,JJ) = 0.0
   92 HT(I,J,JJ) = 0.0 
      OPEN(13,STATUS='UNKNOWN',FILE='TLAW_OUT.LIS')
*     FOLLOWING FOR STANDALONE VERSION ONLY
93    WRITE(*,490) 
      READ(*,'(A32)') FILIN
      OPEN(14,STATUS='OLD',FILE=FILIN,ACCESS='SEQUENTIAL',
     1FORM='FORMATTED')
*
C     DO AUTO-DETECT TO SEE WHETHER THIS IS WHAT WE MIGHT CALL
C     A 'NORMAL' TWIN ASSIGNMENT, I.E. MAJOR COMPONENT IS "1"
C     OR, E.G., A 'TWINABS-CHOSEN' OR ANY OTHER SITUATION WHERE
C     THE MAJOR COMPONENT IS "2" INSTEAD OF "1".  TO AVOID MESSY
C     CODE, WE DO THS IN A SEPARATE SUBROUTINE, 'DETECT'.  IF
C     IDETECT=1 IT'S NORMAL (1) AND IF IDETECT=2, IT'S 'OTHER' (2).
C     TLAW3 ONLY CONSIDERS (A) TWINS WITH UP TO 8 COMPONENTS WHEN
C     "1" IS THE MAJOR, AND (B) TWINS WITH **ONLY** TWO COMPONENTS
C     WHEN "2" IS THE MAJOR.
      IDETECT=1
      CALL DETECT(IDETECT)
      IF(IDETECT.EQ.2) WRITE (*,*) ' MAJOR COMPONENT 2 DETECTED'
      NREF=1
C     READ IN AND CHECK FOR -VE/+VE SET SEQUENCE IN HKLF5 FILE
C     & DETERMINE THE NUMBER OF COMPONENTS (JJMAX)
      REWIND 14
      IF(IDETECT.EQ.2) GO TO 20
      IF(IDETECT.EQ.3) STOP 
     1'IF MAJOR COMP IS 2, MINOR MUST BE 1'
   10 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE
      IF(HT1.EQ.0.AND.KT1.EQ.0.AND.LT1.EQ.0) GO TO 10
      IF(JCODE.LT.0) GO TO 11
      GO TO 10
   11 JJ=IABS(JCODE)-1
      JTEST(JJ)=JJ
      HKLT(NREF,1,JJ)=HT1
      HKLT(NREF,2,JJ)=KT1
      HKLT(NREF,3,JJ)=LT1
   12 READ (14,500) HP1,KP1,LP1,FO2,SIGMA,JCODE2
      IF(HP1.EQ.0.AND.KP1.EQ.0.AND.LP1.EQ.0) GO TO 10
      IF(JCODE2) 14,13,13
   13 IF(JCODE2.NE.1) STOP ' MAJOR COMPONENT MUST BE 1'
      HKLP(NREF,1)=HP1
      HKLP(NREF,2)=KP1
      HKLP(NREF,3)=LP1
      NREF=NREF+1
      GO TO 10
   14 JJ=IABS(JCODE2)-1
      JTEST(JJ)=JJ
      HKLT(NREF,1,JJ)=HP1
      HKLT(NREF,2,JJ)=KP1
      HKLT(NREF,3,JJ)=LP1
      GO TO 12
C
C     READ IN AND CHECK FOR -1, 2 PAIR SEQUENCE IN HKLF5 FILE
   20 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE
      IF(JCODE.eq.-1) GO TO 22
      GO TO 20
   22 READ (14,500) HP1,KP1,LP1,FO2,SIGMA,JCODE2
      IF(JCODE2) 24,23,23
   23 jj=1
      HKLP(NREF,1)=HP1
      HKLP(NREF,2)=KP1
      HKLP(NREF,3)=LP1
      HKLT(NREF,1,JJ)=HT1
      HKLT(NREF,2,JJ)=KT1
      HKLT(NREF,3,JJ)=LT1
      if(nref.le.4) write(*,*) hp1,kp1,lp1,ht1,kt1,lt1
      NREF=NREF+1
      GO TO 20
   24 JJ=IABS(JCODE2)-1
      JTEST(JJ)=JJ
      HKLT(NREF,1,JJ)=HP1
      HKLT(NREF,2,JJ)=KP1
      HKLT(NREF,3,JJ)=LP1
      GO TO 22

C
C     ACCUMULATE H(TWIN) X H(TWIN)^T  (I.E., HT) 
C
C     ... AND  H(PRIN) X H(TWIN)^T (I.E., HP)
C
  100 JJMAX=MAXVAL(JTEST)
      IF(iDETECT.EQ.2) JJMAX=1
      DO 150 JJ=1,JJMAX
      DO 150 J=1,NREF-1
      HT(1,1,JJ)=HT(1,1,JJ)+HKLT(J,1,JJ)**2
      HT(1,2,JJ)=HT(1,2,JJ)+HKLT(J,1,JJ)*HKLT(J,2,JJ)
      HT(1,3,JJ)=HT(1,3,JJ)+HKLT(J,1,JJ)*HKLT(J,3,JJ)
      HT(2,2,JJ)=HT(2,2,JJ)+HKLT(J,2,JJ)**2
      HT(2,3,JJ)=HT(2,3,JJ)+HKLT(J,2,JJ)*HKLT(J,3,JJ)
      HT(3,3,JJ)=HT(3,3,JJ)+HKLT(J,3,JJ)**2
C
      HP(1,1,JJ)=HP(1,1,JJ)+HKLP(J,1)*HKLT(J,1,JJ)
      HP(1,2,JJ)=HP(1,2,JJ)+HKLP(J,1)*HKLT(J,2,JJ)
      HP(1,3,JJ)=HP(1,3,JJ)+HKLP(J,1)*HKLT(J,3,JJ)
      HP(2,2,JJ)=HP(2,2,JJ)+HKLP(J,2)*HKLT(J,2,JJ)
      HP(2,3,JJ)=HP(2,3,JJ)+HKLP(J,2)*HKLT(J,3,JJ)
      HP(3,3,JJ)=HP(3,3,JJ)+HKLP(J,3)*HKLT(J,3,JJ)
      HP(2,1,JJ)=HP(2,1,JJ)+HKLP(J,2)*HKLT(J,1,JJ)
      HP(3,1,JJ)=HP(3,1,JJ)+HKLP(J,3)*HKLT(J,1,JJ)
      HP(3,2,JJ)=HP(3,2,JJ)+HKLP(J,3)*HKLT(J,2,JJ)
  150 CONTINUE
C
C     GENERATE REMAINDER OF HT SYMMETRIC MATRIX
C
      DO 160 JJ=1,JJMAX
      HT(2,1,JJ)=HT(1,2,JJ)
      HT(3,1,JJ)=HT(1,3,JJ)
  160 HT(3,2,JJ)=HT(2,3,JJ)           
C
      NTOT=NREF-1
      WRITE(13,501)NTOT
      WRITE(*,501)NTOT
C
C     INVERT H(TWIN) X H(TWIN)^T (I.E., HT)
C
      DO 170 JJ=1,JJMAX
      DO 161 I=1,3
      DO 161 J=1,3
      C(I,J)=HP(I,J,JJ)
      A(I,J)=HT(I,J,JJ)
      CALL MATINV(C,CI,D)
  161 HTINV(I,J,JJ)=CI(I,J)
C
      IF(D.EQ.0.0) GO TO 400
C
C     GET R = (H(TWIN) X H(TWIN)^T) X (H(PRIN) X H(TWIN)^T)^-1  
C     
C
      CALL MATMULT(A,CI,3,B)
      DO 162 I=1,3
      DO 162 J=1,3
  162 R(I,J,JJ)=B(I,J)
      CALL DTRM(B,3,D1,INDX)
      WRITE(13,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
      WRITE(*,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
C     (2020 edit) Test determinant only for 5% dev from +/- 1.0
      IF(abs(D1).LT.0.95.OR.abs(D1).GT.1.05) WRITE(13,505)
      IF(abs(D1).LT.0.95.OR.abs(D1).GT.1.05) WRITE(*,505)
      if(d1.lt.0) then
        write(13,503) d1
        write(13,5051)
        write(*,503) d1
        write(*,5051)
      endif
  170 CONTINUE

C     DJW: SAVE THE MATRIX BEFORE IT IS OVERWRITTEN 
C     (SIGNS WERE LOST FROM LAST ROW) 
C     AND CLEAR THE ACCUMULATORS
      DO JJ=1,7
       DOJ=1,3
        DOI=1,3
         RSV(I,J,JJ)=R(I,J,JJ)
         HP(I,J,JJ) = 0.0
         HT(I,J,JJ) = 0.0 
        ENDDO
       ENDDO
      ENDDO
c
      write(13,508)
      write(13,511)
      write(13,'(7x,a,11x,a,17x,a,16x,a,6x,a)')
     1 'Transformed','Minor','Error','NINT error','Total error'
      write(*,508)
      write(*,511)
      write(*,'(7x,a,11x,a,17x,a,16x,a,6x,a)')
     1 'Transformed','Minor','Error','NINT error','Total error'
      
C     DJW  GO THROUGH THE DATA AGAIN REJECTING REFLECTIONS WHICH 
C     DO NOT PREDICT C CORRECTLY.  THUS CAN OCCUR WHEN THE MINOR 
C     COMPONENT IS TOO FAR (IN RECIPROCAL SPACE) FROM THE PRINCIPAL.

      NREF2 = 0
      NREJ = 0
      DO 199 JJ=1,JJMAX
      DO 199 J=1,NREF-1
      CDJW = ' '

C     TRANSFORM THE PRINCIPAL
C
      DJWT(1,JJ)=HKLP(J,1)*RSV(1,1,JJ)+HKLP(J,2)*RSV(1,2,JJ)+HKLP(J,3)*
     1RSV(1,3,JJ)
      DJWT(2,JJ)=HKLP(J,1)*RSV(2,1,JJ)+HKLP(J,2)*RSV(2,2,JJ)+HKLP(J,3)*
     1RSV(2,3,JJ)
      DJWT(3,JJ)=HKLP(J,1)*RSV(3,1,JJ)+HKLP(J,2)*RSV(3,2,JJ)+HKLP(J,3)*
     1RSV(3,3,JJ)
C
C     SKIP ENTRY IF THIS IS A MULTICOMPONENT TWIN AND THERE IS 
C     NO ENTRY FOR THIS COMPONENT
C
      IF(HKLT(J,1,JJ).EQ.0.0.AND.HKLT(J,2,JJ).EQ.0.0.AND.
     1HKLT(J,3,JJ).EQ.0.0) GO TO 199
C     FIND THE ACTUAL DISCREPANCY
      DJWD(1,JJ) = ABS(DJWT(1,JJ)-HKLT(J,1,JJ))
      DJWD(2,JJ) = ABS(DJWT(2,JJ)-HKLT(J,2,JJ))
      DJWD(3,JJ) = ABS(DJWT(3,JJ)-HKLT(J,3,JJ))

C      FIND THE NEAREST INTEGER DISCREPANCY (AS IS DONE IN CRYSTALS)
C
      DJWI(1,JJ) = NINT(DJWT(1,JJ)-HKLT(J,1,JJ))
      DJWI(2,JJ) = NINT(DJWT(2,JJ)-HKLT(J,2,JJ))
      DJWI(3,JJ) = NINT(DJWT(3,JJ)-HKLT(J,3,JJ))
C
C     FIND THE TOTAL INTEGER DISCREPANCY
C
180   DJWSUM(JJ) = ABS(DJWI(1,JJ))+ABS(DJWI(2,JJ))+ABS(DJWI(3,JJ))
      IF (DJWSUM(JJ) .GT. 0) CDJW='*'
      IF(DJWD(1,JJ).GE.0.4.OR.DJWD(2,JJ).GE.0.4.OR.DJWD(3,JJ).GE.0.4)
     1WRITE(13,'(A,2X,3F6.2,3X, 3F6.2, 3X, 3F6.3,3X,3I6, 3X, I6)') 
     2 CDJW, (DJWT(K,JJ),K=1,3), HKLT(J,1,JJ),HKLT(J,2,JJ),HKLT(J,3,JJ),
     3 (DJWD(K,JJ),K=1,3), (DJWI(K,JJ),K=1,3), DJWSUM(JJ)
      IF(DJWD(1,JJ).GE.0.4.OR.DJWD(2,JJ).GE.0.4.OR.DJWD(3,JJ).GE.0.4)
     1WRITE(*,'(A,2X,3F6.2,3X, 3F6.2, 3X, 3F6.3,3X,3I6, 3X, I6)') 
     2 CDJW, (DJWT(K,JJ),K=1,3), HKLT(J,1,JJ),HKLT(J,2,JJ),HKLT(J,3,JJ),
     3 (DJWD(K,JJ),K=1,3), (DJWI(K,JJ),K=1,3), DJWSUM(JJ)
C
C     DON'T USE THE REFLECTION IF IT DOESNT MATCH.
C     THIS SHOULD ALSO BE DONE WHEN GENERATING A CRYSTALS FILE FROM
C     AN HKLF5 FILE
C
      IF(DJWSUM(JJ).GT.0) THEN
            NREJ = NREJ + 1
            NREJ2(JJ)=NREJ2(JJ)+1
            GOTO 199
      ENDIF
C
      NREF2 = NREF2 +1
      NREF3(JJ) = NREF3(JJ)+1
      HT(1,1,JJ)=HT(1,1,JJ)+HKLT(J,1,JJ)**2
      HT(1,2,JJ)=HT(1,2,JJ)+HKLT(J,1,JJ)*HKLT(J,2,JJ)
      HT(1,3,JJ)=HT(1,3,JJ)+HKLT(J,1,JJ)*HKLT(J,3,JJ)
      HT(2,2,JJ)=HT(2,2,JJ)+HKLT(J,2,JJ)**2
      HT(2,3,JJ)=HT(2,3,JJ)+HKLT(J,2,JJ)*HKLT(J,3,JJ)
      HT(3,3,JJ)=HT(3,3,JJ)+HKLT(J,3,JJ)**2
C
      HP(1,1,JJ)=HP(1,1,JJ)+HKLP(J,1)*HKLT(J,1,JJ)
      HP(1,2,JJ)=HP(1,2,JJ)+HKLP(J,1)*HKLT(J,2,JJ)
      HP(1,3,JJ)=HP(1,3,JJ)+HKLP(J,1)*HKLT(J,3,JJ)
      HP(2,2,JJ)=HP(2,2,JJ)+HKLP(J,2)*HKLT(J,2,JJ)
      HP(2,3,JJ)=HP(2,3,JJ)+HKLP(J,2)*HKLT(J,3,JJ)
      HP(3,3,JJ)=HP(3,3,JJ)+HKLP(J,3)*HKLT(J,3,JJ)
      HP(2,1,JJ)=HP(2,1,JJ)+HKLP(J,2)*HKLT(J,1,JJ)
      HP(3,1,JJ)=HP(3,1,JJ)+HKLP(J,3)*HKLT(J,1,JJ)
      HP(3,2,JJ)=HP(3,2,JJ)+HKLP(J,3)*HKLT(J,2,JJ)
199    CONTINUE
      

C     REPEAT THE WORK
C
C     GENERATE REMAINDER OF HT SYMMETRIC MATRIX
C
      DO 205 JJ=1,JJMAX
      HT(2,1,JJ)=HT(1,2,JJ)
      HT(3,1,JJ)=HT(1,3,JJ)
  205 HT(3,2,JJ)=HT(2,3,JJ)           

C 210   CONTINUE
      WRITE(13,510)
      WRITE(13,509)NREF2
      WRITE(*,510)
      WRITE(*,509)NREF2
      IF(JJMAX.EQ.1) GO TO 215
      WRITE(13,506) (K+1,NREF3(K), K=1,JJMAX)
      WRITE(*,506) (K+1,NREF3(K), K=1,JJMAX)
  215 WRITE(13,'(/, A,I7//)')' Number of non-matching reflections = ',
     1NREJ      
      WRITE(*,'(/, A,I7//)')' Number of non-matching reflections = ',
     1NREJ
      IF (NREJ.EQ.0) WRITE(13,5061)
      IF (NREJ.EQ.0) WRITE(*,5061)
      IF(JJMAX.EQ.1) GO TO 220
      WRITE(13,507) (K+1,NREJ2(K), K=1,JJMAX)
      WRITE(*,507) (K+1,NREJ2(K), K=1,JJMAX)
C
C     INVERT H(TWIN) X H(TWIN)^T (I.E., HT)
C
C
  220 DO 270 JJ=1,JJMAX
      DO 261 I=1,3
      DO 261 J=1,3
      C(I,J)=HP(I,J,JJ)
      A(I,J)=HT(I,J,JJ)
      CALL MATINV(C,CI,D)
  261 HTINV(I,J,JJ)=CI(I,J)
C
      IF(D.EQ.0.0) GO TO 400
C
C     GET R = (H(TWIN) X H(TWIN)^T) X (H(PRIN) X H(TWIN)^T)^-1  
C
      CALL MATMULT(A,CI,3,B)
      DO 262 I=1,3
      DO 262 J=1,3
  262 R(I,J,JJ)=B(I,J)
      CALL DTRM(B,3,D1,INDX)
      WRITE(13,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
      WRITE(*,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
C     (2020 edit) Test determinant only for 5% dev from +/- 1.0
      IF(abs(D1).LT.0.95.OR.abs(D1).GT.1.05) THEN
            WRITE(13,505)
            WRITE(*,505)
      ENDIF
      WRITE(13,503) D1
      WRITE(*,503) D1
270   CONTINUE

C     DJW: SAVE THE MATRIX BEFORE IT IS OVERWRITTEN 
C     (SIGNS WERE LOST FROM LAST ROW)
C     AND CLEAR THE ACCUMULATORS
      DO JJ=1,7
       DOJ=1,3
        DOI=1,3
         RSV(I,J,JJ)=R(I,J,JJ)
         HP(I,J,JJ) = 0.0
         HT(I,J,JJ) = 0.0 
        ENDDO
       ENDDO
      ENDDO
	  CALL EXIT()

  400 WRITE(13,504) D
      WRITE(*,504) D
      STOP
  490 FORMAT(//' ENTER FILE NAME, WITH EXTENSION, FOR SHELX-STYLE'
     1,' HKLF5 FILE: ',$)
  500 FORMAT(3F4.0,2F8.2,I4)
  501 FORMAT(//,' ANALYSIS OF TWIN LAWS FROM HKLF5 FILE (NO ',
     1'REFLECTIONS REJECTED)',//,
     2' NUMBER OF REFLECTION TWIN SETS = ', I7)
  502 FORMAT(//' DERIVED TWIN LAW FOR COMPONENT 1 -->',I2,' :', /,
     1 3(/,3F10.6))
  503 FORMAT(/' DETERMINANT = ',F8.3)
  504 FORMAT(/' DETERMINANT = ',F8.3, ' ERROR: ENTER TWIN LAW BY HAND '
     1,/,' AND/OR CHECK INPUT DATA')
  505 FORMAT(/
     1 'Determinant is quite far from 1.0.',
     2 ' Inspect TLAW_OUT.LIS for errors')
5051  format(/
     1 'The determinant is negative. If inversion twin laws have been',
     2/,'included, this is expected and no user action is required.',/
     3 /'Otherwise, please reprocess data without averaging')
  506 FORMAT((/' NO. OF SETS FOR COMPONENT ',I4, ' = ',I7))
 5061 FORMAT(/' ALL REFLECTIONS WERE ACCEPTED; THE TWIN LAW(S) BELOW '
     1'DO NOT DIFFER FROM RESULTS PRESENTED EARLIER ABOVE')
  507 FORMAT((/' No. unmatched for component ',I4, ' = ', I5))

  508 FORMAT(//
     1 'The twin law tansforms the primary component into a minor'/
     2 'component.  The transformed primary index is compared with'/
     3 'the minor index from the HKLF5 file.'/
     3 'If the absolute value of the deviation exceeds 0.5 for'/
     4 'any index, the minor component is regarded as unreliable'/
     5 'and not accepted.'/
     6 'The twin law is redetermined without these unreliable'/
     7 'reflections.' //
     8 'The very unreliable reflections are marked with an "*" in'/
     9 'the list below'/
     1 'CRYSTALS will re-process the data omitting these reflections'/
     2 'See the bottom of TLAW_OUT.LIS for the final results'
     1 //)

  509 FORMAT(//,
     1 'Analysis of twin laws from hklf5 file (selected ',
     1 'reflections rejected)',//,
     2 'Number of reflection twin sets = ', I7)
  510 FORMAT(//' ***** Recalculation with non-matching reflections ',
     1'deleted *****')
  511 FORMAT(//' If we have a TLQS twin with an obliquity significantl' 
     1,'y different from zero, the positions',/' of the minor component'
     2,'s in reciprocal space will deviate from those of the major ',
     3'component.'/' The acceptable amount of deviation is set by the',
     4' criteria for overlapping reciprocal lattice',/' points when ',
     5' the data is collected.  In CRYSTALS, the indices of the minor ',
     6'components',/' are generated from the twin law and the indices ',
     7'of the principal component. If we have'/' a TLS (meroheral) twin' 
     8,' the generated reflections will be (within computational ',
     9'errors)'/' integral.  When we have a TLQS twin as above (best ',
     A'referred to as non-merohedral),'/' the generated indices *may* '
     B,'be non-integral.  These must be rounded to integers for the ',
     C/' structure factor calculation. If this rounding exceeds a ',
     D'pre-set deviation from the'/' observed index, the reflection',
     E' will be eliminated from the CRYSTALS data set.'//' See ',
     F'Donnay, G.; Donnay, J. D. H. Canadian Mineralogist, 1974, ',
     G'12, 422-425,',/' and in Giacovazzo, C., ed.; Fundamentals of ',
     H'Crystallography, 2nd Ed.; Oxford'/' Science Publications, 2002,',
     J' pp. 229-236 & 278-285.'//)
      END

      SUBROUTINE DETECT(IDETECT)
      REAL HKLP(100000,3),HKLT(100000,3,7),
     1HT(3,3,7),HP(3,3,7),HTINV(3,3,7),R(3,3,7),
     2HT1,KT1,LT1,HP1,KP1,LP1
C
      IDETECT2=0
      IDETECT3=0
      REWIND 14
   10 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE
      IF(JCODE.GT.0) GO TO 10
      IF(JCODE.EQ.-1) GO TO 20
      GO TO 10
   20 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE2
      IF (JCODE2.EQ.2) IDETECT2=2
      IF (JCODE2.GE.3) IDETECT3=3
      GO TO 10
  100 IDETECT=MAX(IDETECT2,IDETECT3)
      RETURN
C     WRITE (*,*) ' EOF REACHED; CHECK FILE FOR ERRORS'
  500 FORMAT(3F4.0,2F8.2,I4)
      END

      SUBROUTINE MATINV(A,B,D)
      IMPLICIT  NONE
      INTEGER*2 K,N
      REAL*4    A,B,D
      DIMENSION A(3,3),B(3,3)
      CALL VMULT(A(1,2),A(1,3),B(1,1))
      CALL VMULT(A(1,3),A(1,1),B(1,2))
      CALL VMULT(A(1,1),A(1,2),B(1,3))
      D=A(1,1)*B(1,1)+A(2,1)*B(2,1)+A(3,1)*B(3,1)
      IF(D.EQ.0.0)RETURN
      N=1
10    K=1
15    B(K,N)=B(K,N)/D
      K=K+1
      IF(K.LE.3)GOTO 15
      N=N+1
      IF(N.LE.3)GOTO 10
      CALL MACOL(B)
      RETURN
      END

      SUBROUTINE VMULT(A,B,C)
      IMPLICIT  NONE
      REAL*4    A,B,C
      DIMENSION A(3),B(3),C(3)
      C(1)=A(2)*B(3)-A(3)*B(2)
      C(2)=A(3)*B(1)-A(1)*B(3)
      C(3)=A(1)*B(2)-A(2)*B(1)
      RETURN
      END

      SUBROUTINE MACOL(A)
      IMPLICIT  NONE
      INTEGER*2 K,N
      REAL*4    A,T
      DIMENSION A(3,3)
      N=1
 5    K=2
10    T=A(K,N)
      A(K,N)=A(N,K)
      A(N,K)=T
      IF(N.EQ.3)RETURN
      K=K+1
      IF(K.LE.3)GOTO 10
      N=3
      GOTO 5
      END

      SUBROUTINE MATMULT(A,B,N,C)
      DIMENSION A(N,N),B(N,N),C(N,N)
      DO 100 I=1,N
      DO 100 J=1,N
      C(I,J)=0.
      DO 100 K=1,N
  100 C(I,J)=C(I,J)+A(I,K)*B(K,J)
      RETURN
      END
      SUBROUTINE DTRM(A,N,D,INDX)
C
C SUBROUTINE FOR EVALUATING THE DETERMINANT OF A MATRIX USING 
C THE PARTIAL-PIVOTING GAUSSIAN ELIMINATION SCHEME.
C
      DIMENSION A(N,N),INDX(N)
C
      CALL ELGS(A,N,INDX)
C
      D    = 1.0
      DO     100 I = 1, N
         D = D*A(INDX(I),I)
  100 CONTINUE
C
      MSGN = 1
      DO     200 I = 1, N
        DO   150 WHILE (I.NE.INDX(I))
          MSGN = -MSGN
          J = INDX(I)
          INDX(I) = INDX(J)
          INDX(J) = J
  150   END DO
  200 CONTINUE
      D = MSGN*D
C
      RETURN
      END
C
      SUBROUTINE ELGS(A,N,INDX)
C
C SUBROUTINE TO PERFORM THE PARTIAL-PIVOTING GAUSSIAN ELIMINATION.
C A(N,N) IS THE ORIGINAL MATRIX IN THE INPUT AND TRANSFORMED
C MATRIX PLUS THE PIVOTING ELEMENT RATIOS BELOW THE DIAGONAL IN
C THE OUTPUT.  INDX(N) RECORDS THE PIVOTING ORDER.

C
      DIMENSION A(N,N),INDX(N),C(N)
C
C INITIALIZE THE INDEX
C
      DO     50    I = 1, N
        INDX(I) = I
   50 CONTINUE
C
C FIND THE RESCALING FACTORS, ONE FROM EACH ROW
C
        DO     100   I = 1, N
          C1= 0.0
          DO    90   J = 1, N
            C1 = AMAX1(C1,ABS(A(I,J)))
   90     CONTINUE
          C(I) = C1
  100   CONTINUE
C
C SEARCH THE PIVOTING (LARGEST) ELEMENT FROM EACH COLUMN
C
      DO     200   J = 1, N-1
        PI1 = 0.0
        DO   150   I = J, N
          PI = ABS(A(INDX(I),J))/C(INDX(I))
          IF (PI.GT.PI1) THEN
            PI1 = PI
            K   = I
          ELSE
          ENDIF
  150   CONTINUE
C
C INTERCHANGE THE ROWS VIA INDX(N) TO RECORD PIVOTING ORDER
C
        ITMP    = INDX(J)
        INDX(J) = INDX(K)
        INDX(K) = ITMP
        DO   170   I = J+1, N
          PJ  = A(INDX(I),J)/A(INDX(J),J)
C
C RECORD PIVOTING RATIOS BELOW THE DIAGONAL
C
          A(INDX(I),J) = PJ
C
C MODIFY OTHER ELEMENTS ACCORDINGLY
C
          DO 160   K = J+1, N
            A(INDX(I),K) = A(INDX(I),K)-PJ*A(INDX(J),K)
  160     CONTINUE
  170   CONTINUE
  200 CONTINUE
C
      RETURN
      END
