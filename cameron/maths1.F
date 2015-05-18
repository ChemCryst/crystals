CRYSTALS CODE FOR MATHS1.FOR                                                    
CAMERON CODE FOR MATHS1
CODE FOR LNCHCK [ NEXT COMMAND CHECKER ]
      FUNCTION LNCHCK (I)
C THIS FUNCTION CHECKS THE GROUP OF THE CURRENT COMMAND AND THE
C FOLLOWING COMMAND. IT RETURNS
C LNCHCK = 1 IF THEY ARE THE SAME
C LNCHCK = -1 IF THEY ARE DIFFERENT OR IF THERE IS NO FOLLOWING
C COMMAND.
C THE COMMAND ICOM IS NOT CONSIDERED TO BE OF THE SAME GROUP
C THIS IS USED SO THAT MULTIPLE SETS OF THE SAME
C GROUP OF COMMANDS WILL EXECUTE PROPERLY.
      
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

      IF (ICOMMD(ICNT+1).LT. ICOM) THEN
      LNCHCK = -1
      RETURN
      ENDIF
      ID = NINT (RSTORE (ICOM + (ICOMMD(ICNT) - ICOM)
     c * ISRCOM/ISCOM) )
      ID1 = NINT (RSTORE( ICOM + (ICOMMD(ICNT+1) - ICOM )
     c   * ISRCOM/ISCOM ) )
      IF (ABS(ID/100).NE.ABS(ID1/100)) THEN
       LNCHCK = -1
      ELSE IF (ID1.EQ.I) THEN
       LNCHCK = -1
      ELSE
       LNCHCK = 1
      ENDIF
      RETURN
      END
 
 
CODE FOR LRANGE
      FUNCTION LRANGE (IMX1,IMX,K,SYMM,ITYPE,ORTH,ORTHI)
C This routine checks whether the min/max edges of an ass unit are
C within the limits set for the packing.
C PCMIN/PCMAX - these are the min/max coords they are in orth or
C frac coords depending on the type of Pack being done.
C IMX1,IMX together these are the no of unit cell increments for the
C required packing. For orthog coords these will be treated as the
C d(100) etc of Rollett p 27.
C K is the axis concerned.
C ITYPE = 1 check that max is less than max limit PKMAX(K).
C       = 2 check that min is greater than min limit PKMIN(K).
C The coords used are taken from ISVIEW -> IFVIEW
C The central point of the calculation is held in PKCNF, PKCNA
C if required.
      
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

      REAL SYMM(4,4),PCENT(3),ORTH(3,3),ORTHI(3,3)
      REAL PMAX(3),PMIN(3),PMN(3),PMX(3),D(3)
      INTEGER IMX1(3),IMX(3)
      LRANGE = 0
      IF (IPPCK.EQ.1) THEN
      CALL ZMOVE (PKCNF,PCENT,3)
      CALL ZMOVE (PCMAX,PMX,3)
      CALL ZMOVE (PCMIN,PMN,3)
      DO 10 I = 1 ,3
        D(I) = 1.0
10      CONTINUE
      ELSE
      DO 20 I = 1 ,3
        D(I) = D000(I)
20      CONTINUE
      CALL ZMOVE (PKCNA,PCENT,3)
C NEED TO DEORTHOG PCMAX AND PCMIN
      CALL ZMATV (ORTHI,PCMAX,PMX)
      CALL ZMATV (ORTHI,PCMIN,PMN)
      ENDIF
      DO 7 J = 1,3
      PMAX(J) = PMX(J) + IMX(J) + IMX1(J)
      PMIN(J) = PMN(J) + IMX(J) + IMX1(J)
7     CONTINUE
C REORTHOG IF NEEDED
      IF (IPPCK.NE.1) THEN
      CALL ZMATV (ORTH,PMAX,PMAX)
      CALL ZMATV (ORTH,PMIN,PMIN)
      ENDIF
      IF (ITYPE.EQ.1) THEN
C CHECK MAX
      IF (PMAX(K).GE.(PKMIN(K)+PCENT(K))) THEN
        LRANGE = 1
      ELSE IF ((PMAX(K).LE.(PKMIN(K)+PCENT(K))).AND.
     c    ((PMIN(K)+D(K)).GE.(PKMAX(K)+PCENT(K)))) THEN
        LRANGE = -1
      ENDIF
      ELSE
C CHECK MIN
      IF (PMIN(K).LE.(PKMAX(K)+PCENT(K))) THEN
        LRANGE = 1
      ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZACALC
      SUBROUTINE ZACALC (N)
      
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

      INTEGER N(3)
      CHARACTER*12 CALAB1, CBLAB1, CCLAB1
      REAL VPA(3),VPB(3)
C GET THE COORDINATES OF THE ATOMS INVOLVED
      ITA = ( N(1) - ICATOM ) * IPACKT + IRATOM
      ITB = ( N(2) - ICATOM ) * IPACKT + IRATOM
      ITC = ( N(3) - ICATOM ) * IPACKT + IRATOM
      DO 10 L = 1,3
      VPA (L) = RSTORE(ITA+IXYZO+L-1) - RSTORE(ITB+IXYZO+L-1)
      VPB (L) = RSTORE(ITC+IXYZO+L-1) - RSTORE(ITB+IXYZO+L-1)
10    CONTINUE
C CALCULATE THE ANGLE
      CALL ZDTPRD (VPA,VPB,ANG)
      IF (ANG.GT.180.0) ANG = ANG - 180.0
C GET THE LABELS
      IF (IPACK.GT.0) THEN
      IL = INDEX ( CSTORE(N(1)) ,' ') - 1
      CALL ZPLABL ( ITA, CALAB1 , IL )
      IL = INDEX ( CSTORE(N(2)) ,' ') - 1
      CALL ZPLABL ( ITB, CBLAB1 , IL )
      IL = INDEX ( CSTORE(N(3)) ,' ') - 1
      CALL ZPLABL ( ITC, CCLAB1 , IL )
      ELSE
      CALAB1 = CSTORE(N(1))//'      '
      CBLAB1 = CSTORE(N(2))//'      '
      CCLAB1 = CSTORE(N(3))//'      '
      ENDIF
C OUTPUT THE RESULT
      WRITE (CLINE,20) CALAB1,CBLAB1,CCLAB1,ANG
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
20    FORMAT (3(A12,1X),'Angle ',F6.2)
      RETURN
      END
 
CODE FOR ZTCALC
      SUBROUTINE ZTCALC (N)
C THIS ROUTINE CALCULATES THE TORSION ANGLE INVOLVING FOUR ATOMS
      
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

      INTEGER N(4)
      REAL VAB(3),VBC(3),VCB(3),VCD(3),V1(3),V2(3)
      CHARACTER*12 CALAB1, CBLAB1 , CCLAB1 , CDLAB1
      ITA = ( N(1) - ICATOM )*IPACKT + IRATOM
      ITB = ( N(2) - ICATOM )*IPACKT + IRATOM
      ITC = ( N(3) - ICATOM )*IPACKT + IRATOM
      ITD = ( N(4) - ICATOM )*IPACKT + IRATOM
      DO 10 I = 1 , 3
      VAB(I) = RSTORE ( ITA + IXYZO + I - 1 )
     c         - RSTORE ( ITB + IXYZO + I - 1 )
      VBC(I) = RSTORE ( ITB + IXYZO + I - 1 )
     c         - RSTORE ( ITC + IXYZO + I - 1 )
      VCB(I) = - VBC(I)
      VCD(I) = RSTORE ( ITD + IXYZO + I - 1 )
     c         - RSTORE ( ITC + IXYZO + I - 1 )
10    CONTINUE
C GET THE AB x BC AND BC x CD
      I = NCROP3 ( VAB , VCB , V1 )
      IF (I.EQ.-1) THEN
      ANG = 0.0
      GOTO 1000
      ENDIF
      I = NCROP3 ( VBC , VCD , V2 )
      IF (I.EQ.-1) THEN
      ANG = 0.0
      GOTO 1000
      ENDIF
C THE DOT PRODUCT OF V1 AND V2 GIVES THE ANGLE WE NEED.
      CALL ZDTPRD ( V1 , V2 , ANG )
1000  CONTINUE
C GET THE LABELS
      IF (IPACK.GT.0) THEN
      IL = INDEX ( CSTORE(N(1)) ,' ') - 1
      CALL ZPLABL ( ITA, CALAB1 , IL )
      IL = INDEX ( CSTORE(N(2)) ,' ') - 1
      CALL ZPLABL ( ITB, CBLAB1 , IL )
      IL = INDEX ( CSTORE(N(3)) ,' ') - 1
      CALL ZPLABL ( ITC, CCLAB1 , IL )
      IL = INDEX ( CSTORE(N(4)) ,' ') - 1
      CALL ZPLABL ( ITD, CDLAB1 , IL )
      ELSE
      CALAB1 = CSTORE(N(1))//'      '
      CBLAB1 = CSTORE(N(2))//'      '
      CCLAB1 = CSTORE(N(3))//'      '
      CDLAB1 = CSTORE(N(4))//'      '
      ENDIF
      WRITE (CLINE,20) CALAB1, CBLAB1, CCLAB1, CDLAB1 , ANG
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
20    FORMAT (4(A12,1X),' angle ',F6.2)
      RETURN
      END
 
CODE FOR ZBNUM
      SUBROUTINE ZBNUM (N,INUMB,ISET)
      IBS = MOD(N,10)
      IBC = N/10
      IF (INUMB.EQ.1) IBC=ISET
      IF (INUMB.EQ.2) IBS=ISET
C RECOMBINE THE NUMBER
      N = IBC*10 + IBS
      RETURN
      END
 
 
 
CODE FOR ZDCALC
      SUBROUTINE ZDCALC
C This routine calculates the distances between the atoms held in the
C workspace
C the FROM atoms are held IRLAST -> IRLAST+NDIST1-1,
C the TO atoms are held IRLAST + NDIST1 -> IRLAST + NDIST2 - 1
      
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

      REAL X1(3),X2(3),SYMM(4,4),X3(3),X4(3),X5(3)
      REAL ORTH(3,3)
      INTEGER IMX(3), IMX1(3)
      CHARACTER*50 SWORD
      CHARACTER*12 CLAB , CLAB1
      CALL ZMOVE(RSTORE(ICRYST+6), ORTH , 9)
      IPL = 0
      DMAX = DISEND**2
      DMIN = DISBEG**2
      IF (NDIST1.EQ.0) THEN
      CALL ZMORE(
     C 'You have not defined any atoms for this calculation!',0)
      CALL ZMORE1(
     C 'You have not defined any atoms for this calculation!',0)
      IPROC = 0
      RETURN
      ENDIF
      IF (NDIST1.EQ.NDIST2) THEN
      CALL ZMORE(
     c 'You have not defined any TO atoms for this calculation!',0)
      CALL ZMORE1(
     c 'You have not defined any TO atoms for this calculation!',0)
      IPROC = 0
      RETURN
      ENDIF
C OUTPUT THE CURRENT RANGE
cdjwfeb2000
      if ((ndist1 .ne.2) .and. (ndist2 .ne. 4)) then
        WRITE (CLINE,1) DISBEG,DISEND
        CALL ZMORE(CLINE,1)
1       FORMAT ('Distances in range ',
     c   F5.2 ,' to ', F5.2, ' A')
      endif
C IDOUT WILL BE SET ONCE A DISTANCE HAS BEEN OUTPUTTED
      IDOUT = 0
      INPOS = IRLAST + NDIST2*4
      DO 30 I = 1,NDIST1
        II = IRLAST + (I-1)*4
        DO 40 J = NDIST1+1,NDIST2
          JJ =  IRLAST + (J-1)*4
          NAT = 0
C DONT CALCULATE DISTANCES BETWEEN THE SAME ATOMS.
C        IF (NINT(RSTORE(II)).EQ.NINT(RSTORE(JJ))) GOTO 40
C GET COORDINATES
          DO 50 K = 1,3
            X1(K) = RSTORE (II + K)
            X2(K) = RSTORE (JJ + K)
50        CONTINUE

c          WRITE(CLINE,'(A,6F8.3)')'CRDs: ',(X1(K),K=1,3),(X2(K),K=1,3)
c          CALL ZMORE(CLINE,1)

          CALL ZMATV (ORTH,X1,X1)
          DO 60 ISYMM = 1 , NSYMM
            IF (IPACK.EQ.0) THEN
              CALL ZMOVE (RSTORE(ITOT-(ISYMM*16)),SYMM,16)
              DO 70 L = 1 , 3
                X3(L) = SYMM(L,1) * X2(1) + SYMM(L,2)*X2(2) +
     c                  SYMM(L,3) * X2(3) + SYMM(L,4)
70            CONTINUE

c              WRITE(CLINE,'(A,3F8.3,I4)')'Trn2: ',(X3(K),K=1,3),ISYMM
c              CALL ZMORE(CLINE,1)

C WE ALSO NEED TO TRANSLATE THE ATOM.
C FIND THE START POINT
            ELSE
              CALL ZMOVE (X2,X3,3)
            ENDIF
            CALL ZZEROI (IMX,3)
            CALL ZZEROI (IMX1,3)
            K = 1
80          CONTINUE
            X4(1) = X3(1) + IMX(1)
            X4(2) = X3(2) + IMX(2)
            X4(3) = X3(3) + IMX(3)
C CALCULATE THE ORTHOGONAL COORDINATES
            CALL ZMATV (ORTH,X4,X5)

c            WRITE(CLINE,'(A,6F8.3,1x,I4)')'ORTs: ',(X1(KRC),KRC=1,3),
c     1       (X5(KRC),KRC=1,3),K
c            CALL ZMORE(CLINE,1)

C Work out distance between atoms in direction of current axis, k,
C in fractional coords.
            FRCDIF = RSTORE (II+K) - X4(K)
C Work out what this fractional distance is in Angstroms (keeping sign)
            ANGDIF = FRCDIF * RSTORE(ICRYST+K-1)

c            WRITE(CLINE,'(A,I4,3F9.4)')'K, FRC, ANGs, CELL: ',
c     1       K, FRCDIF, ANGDIF, RSTORE(ICRYST+K-1)
c            CALL ZMORE(CLINE,1)


C            IF (X1(K)-X5(K).LT.DISEND) THEN !If X5 too large, move back one cell
            IF ( ANGDIF .LT. DISEND ) THEN
              IMX(K) = IMX(K) - 1
              GOTO 80
            ENDIF
C LOOK AT NEXT AXIS
            K = K + 1
            IF (K.LT.4) GOTO 80
            IMX(1) = IMX(1) + 1
            IMX(2) = IMX(2) + 1
            IMX(3) = IMX(3) + 1
C CALCULATE THE DISTANCE AT THE START POINT
            X4(1) = X3(1) + IMX(1)
            X4(2) = X3(2) + IMX(2)
            X4(3) = X3(3) + IMX(3)

c            WRITE(CLINE,'(A,3F8.3,1x,3I4)')'FCRD: ',(X4(KRC),KRC=1,3),
c     1      (IMX(KRC),KRC=1,3)
c            CALL ZMORE(CLINE,1)

            CALL ZMATV (ORTH,X4,X5)

c            WRITE(CLINE,'(A,3F8.3)')'FORT: ',(X5(KRC),KRC=1,3)
c            CALL ZMORE(CLINE,1)

            D = (X1(1)-X5(1))**2 + (X1(2)-X5(2))**2 + (X1(3)-X5(3))**2

c            WRITE(CLINE,'(A,3F9.3)')'D,DMIN,DMAX: ',D,DMIN,DMAX
c            CALL ZMORE(CLINE,1)

            IF ((D.LE.DMAX).AND.(D.GE.DMIN)) THEN
C GET THE LABELS
              ILAB1 = (NINT(RSTORE(II))-ISINIT)/IPACKT + ICATOM
              IL = INDEX ( CSTORE(ILAB1) , ' ') - 1
              CALL ZPLABL (NINT(RSTORE(II)),CLAB,IL)
              ILAB2 = (NINT(RSTORE(JJ))-ISINIT)/IPACKT + ICATOM
C IS THIS A ZERO DISTANCE?
              IF (ABS(D).LT.0.00001) THEN
                IF (CSTORE(ILAB1).EQ.CSTORE(ILAB2)) GOTO 140
              ENDIF
C HAVE WE USED THIS ATOM IN THIS POSITION BEFORE -
C CHECK SPECIAL POSITIONS
              IF (IPACK.EQ.0) THEN
                IF (NINT(RSTORE(NINT(RSTORE(JJ))+ISYM)).EQ.1) THEN
                  DO 120 JJJ = 0 , NAT-1
                      NN = 0
                      DO 130 JJJJ = 0,2
                        IF (ABS(RSTORE(INPOS+JJJ*3+JJJJ)-X4(JJJJ+1))
     c                    .LT.0.00001) NN = NN + 1
130                   CONTINUE
C THIS ATOM HAS ALREADY BEEN USED
                      IF (NN.EQ.3) GOTO 140
120               CONTINUE
C OTHERWISE STORE THE INFO
                  DO 150 JJJJ = 0 , 2
                      RSTORE(INPOS+NAT*3+JJJJ) = X4(JJJJ+1)
150               CONTINUE
                  NAT = NAT + 1
                ENDIF
C NOW SEE IF THE ATOM EXISTS ALREADY
                DO 90 LL = ISVIEW+IPACKT*8, IFVIEW-1, IPACKT
                    IF (ABS(RSTORE(LL+IXYZO)-X5(1)).LT.0.0001) THEN
                      IF (((IHAND.EQ.0)
     c       .AND.(ABS(RSTORE(LL+IXYZO+1)-X5(2)).LT.0.0001)).OR.
     c   ((IHAND.EQ.1).AND.(ABS(-RSTORE(LL+IXYZO+1)-X5(2)).LT.0.0001)))
     c              THEN
                        IF(ABS(RSTORE(LL+IXYZO+2)-X5(3)).LT.0.0001)THEN
C CHECK THE ATOM NAME IS THE SAME
                          LLL = (LL-ISINIT)/IPACKT + ICATOM
                          IF (CSTORE(LLL).EQ.CSTORE(ILAB2)) THEN
C WE HAVE FOUND THE ATOM!
                            IL = INDEX ( CSTORE(LLL),' ') - 1
                            CALL ZPLABL (LL,CLAB1,IL)
                            GOTO 91
                          ENDIF
                        ENDIF
                      ENDIF
                    ENDIF
90              CONTINUE
                CLAB1 = CSTORE(ILAB2)
91              CONTINUE
              ELSE
C WORK OUT THE PACK LABEL FROM THE ATOM POSITION
                LLL = (RSTORE(JJ)-IRATOM)/IPACKT + ICATOM
                IL = INDEX(CSTORE(LLL),' ')-1
                CALL ZPLABL (NINT(RSTORE(JJ)),CLAB1,IL)
              ENDIF
              D = SQRT (D)
              IF (IPACK.EQ.0) THEN
                CALL ZSOUT (SYMM,SWORD,ISLEN)
CRIC99 ISLEN is one char too long.
                  ISLEN=ISLEN-1
              ENDIF
cdjwfeb2000 ------------------------------------------------------
              IF (IPACK.EQ.0) THEN
                  WRITE (CLINE,12) CLAB,CLAB1,D,' ',SWORD(1:ISLEN),IMX
              else
                  WRITE (CLINE,12) CLAB,CLAB1,D
              ENDIF
              CALL ZMORE(CLINE,2)
              CALL ZMORE1(CLINE,2)
12            FORMAT(A12,1X,A12,1X,F7.4,a,'Operator ',A,' trans',3I3)
cdjwfeb2000 -------------------------------------------------------
              IDOUT = 1
            ENDIF
140         CONTINUE
C NOW WE HAVE TO MOVE AROUND RELATIVE TO THE START POINT
            K = 3
100         CONTINUE
            IMX1(K) = IMX1(K) + 1
            X4(1) = X3(1) + IMX(1) + IMX1(1)
            X4(2) = X3(2) + IMX(2) + IMX1(2)
            X4(3) = X3(3) + IMX(3) + IMX1(3)

c            WRITE(CLINE,'(A,3F8.3,1x,6I4)')'MOVF: ',(X4(KRC),KRC=1,3),
c     1      (IMX(KRC),KRC=1,3),(IMX1(KRC),KRC=1,3)
c            CALL ZMORE(CLINE,1)

            CALL ZMATV (ORTH,X4,X5)

c            WRITE(CLINE,'(A,3F8.3)')'MOVO: ',(X5(KRC),KRC=1,3)
c            CALL ZMORE(CLINE,1)

            D = (X1(1)-X5(1))**2 + (X1(2)-X5(2))**2 + (X1(3)-X5(3))**2


c            WRITE(CLINE,'(A,3F9.3)')'D2,DMIN,DMAX:',D,DMIN,DMAX
c            CALL ZMORE(CLINE,1)

            IF ((D.LE.DMAX).AND.(D.GE.DMIN)) THEN
C GET THE LABELS
              ILAB1 = (NINT(RSTORE(II))-ISINIT)/IPACKT + ICATOM
              IL = INDEX ( CSTORE(ILAB1),' ') - 1
              CALL ZPLABL (NINT(RSTORE(II)),CLAB,IL)
              ILAB2 = (NINT(RSTORE(JJ))-ISINIT)/IPACKT + ICATOM
C CHECK FOR ZERO DISTANCES
              IF (ABS(D).LT.0.00001) THEN
                IF (CSTORE(ILAB1).EQ.CSTORE(ILAB2)) GOTO 100
              ENDIF
C HAVE WE USED THIS ATOM IN THIS POSITION BEFORE -
C CHECK SPECIAL POSITIONS
              IF (IPACK.EQ.0) THEN
                IF (NINT(RSTORE(NINT(RSTORE(JJ))+ISYM)).EQ.1) THEN
                  DO 160 JJJ = 0 , NAT-1
                    NN = 0
                    DO 170 JJJJ = 0,2
                      IF (ABS(RSTORE(INPOS+JJJ*3+JJJJ)-X4(JJJJ+1))
     c                .LT.0.00001) NN = NN + 1
170                 CONTINUE
C THIS ATOM HAS ALREADY BEEN USED
                    IF (NN.EQ.3) GOTO 100
160               CONTINUE
C OTHERWISE STORE THE INFO
                  DO 180 JJJJ = 0 , 2
                    RSTORE(INPOS+NAT*3+JJJJ) = X4(JJJJ+1)
180               CONTINUE
                  NAT = NAT + 1
                ENDIF
C NOW SEE IF THE ATOM EXISTS ALREADY
                DO 92 LL = ISVIEW+IPACKT*8, IFVIEW-1, IPACKT
                  IF (ABS(RSTORE(LL+IXYZO)-X5(1)).LT.0.0001) THEN
                    IF (((IHAND.EQ.0)
     c .AND.(ABS(RSTORE(LL+IXYZO+1)-X5(2)).LT.0.0001)).OR.
     c ((IHAND.EQ.1).AND.(ABS(-RSTORE(LL+IXYZO+1)-X5(2)).LT.0.0001)))
     c  THEN
                      IF (ABS(RSTORE(LL+IXYZO+2)-X5(3)).LT.0.0001) THEN
C CHECK THE ATOM NAME IS THE SAME
                        LLL = (LL-ISINIT)/IPACKT + ICATOM
                        IF (CSTORE(LLL).EQ.CSTORE(ILAB2)) THEN
C WE HAVE FOUND THE ATOM!
                          IL = INDEX ( CSTORE(LLL),' ') -1
                          CALL ZPLABL (LL,CLAB1,IL)
                          GOTO 93
                        ENDIF
                      ENDIF
                    ENDIF
                  ENDIF
92              CONTINUE
                CLAB1 = CSTORE(ILAB2)
93              CONTINUE
              ELSE
                LLL = (RSTORE(JJ)-IRATOM)/IPACKT+ICATOM
                IL = INDEX(CSTORE(LLL),' ') - 1
                CALL ZPLABL (NINT(RSTORE(JJ)),CLAB1,IL)
              ENDIF
              D = SQRT (D)
              IF (IPACK.EQ.0) THEN
                CALL ZSOUT (SYMM,SWORD,ISLEN)
CRIC99 ISLEN is one char too long.
                ISLEN=ISLEN-1
              ENDIF
cdjwfeb2000 ------------------------------------------------------
              IF (IPACK.EQ.0) THEN
                WRITE (CLINE,12) CLAB,CLAB1,D,':',SWORD(1:ISLEN),
     1          IMX(1)+IMX1(1),IMX(2)+IMX1(2),IMX(3)+IMX1(3)
              else
                WRITE (CLINE,12) CLAB,CLAB1,D
              ENDIF
              CALL ZMORE(CLINE,2)
              CALL ZMORE1(CLINE,2)
cdjwfeb2000 -------------------------------------------------------
c            WRITE (CLINE,11) CLAB,CLAB1,D
c            CALL ZMORE(CLINE,2)
c            CALL ZMORE1(CLINE,2)
c            IF (IPACK.EQ.0) THEN
c            WRITE (CLINE,12) SWORD(1:ISLEN),
c     c      IMX(1)+IMX1(1),IMX(2)+IMX1(2),IMX(3)+IMX1(3)
c            CALL ZMORE(CLINE,2)
c            ENDIF
cdjwfeb2000 -------------------------------------------------------
c
              IDOUT = 1
              K = 3
              GOTO 100
            ELSE
C Work out distance between atoms in direction of current axis, k,
C in fractional coords.
              FRCDIF = X4(K) - RSTORE (II+K)
C Work out what this fractional distance is in Angstroms (keeping sign)
              ANGDIF = FRCDIF * RSTORE(ICRYST+K-1)
C              IF (X5(K)-X1(K).LT.DISEND) THEN
              IF (ANGDIF.LT.DISEND) THEN
C POSSIBLE VALUES FURTHER ON
                K = 3
                GOTO 100
              ELSE
C NOT IN RANGE LOOK AT THE AXIS BELOW
                IMX1(K) = 0
                K = K - 1
                IF (K.NE.0) GOTO 100
              ENDIF
            ENDIF
            IF (IPACK.GT.0) GOTO 62
60        CONTINUE
C JUMP OUT TO HERE IF DOING DISTANCES ON A PACKED STRUCTURE
62        CONTINUE
40      CONTINUE
30    CONTINUE

      IF (IDOUT.EQ.0) THEN
C CHECK TO SEE IF WE HAVE ONLY TWO ATOMS
      IF ( (NDIST2.EQ.2).OR.
     c  ((NDIST2.EQ.4).AND.
     c  (NINT(RSTORE(IRLAST)).EQ.NINT(RSTORE(IRLAST+8))).AND.
     c  (NINT(RSTORE(IRLAST+4)).EQ.NINT(RSTORE(IRLAST+12))) ) )
     c  THEN
C WE ONLY HAVE TWO ATOMS - CALCULATE THE DISTANCE AND OUTPUT IT ANYWAY
        DO 110 I = 1 , 3
          X1(I) = RSTORE (IRLAST+I)
          X2(I) = RSTORE (IRLAST+I+4)
110       CONTINUE
        CALL ZMATV (ORTH,X1,X1)
        CALL ZMATV (ORTH,X2,X2)
        D = SQRT ( (X1(1)-X2(1))**2 + (X1(2)-X2(2))**2 +
     c        (X1(3)-X2(3))**2 )
C GET  THE LABELS
        LLL = (NINT(RSTORE(IRLAST))-IRATOM) / IPACKT + ICATOM
        IL = INDEX ( CSTORE(LLL),' ') -1
        CALL ZPLABL (NINT(RSTORE(IRLAST)),CLAB,IL)
        LLL = (NINT(RSTORE(IRLAST+4))-IRATOM) / IPACKT + ICATOM
        IL = INDEX ( CSTORE(LLL),' ') -1
        CALL ZPLABL (NINT(RSTORE(IRLAST+4)),CLAB1,IL)
        WRITE (CLINE,12) CLAB , CLAB1 , D
cdjw2000        FORMAT (A12,' to ',A12,F7.4 , ' A')
        CALL ZMORE(CLINE,2)
        WRITE (CLINE,12) CLAB , CLAB1 , D,'*'
        CALL ZMORE1(CLINE,0)
      ELSE
C NO DISTANCES WERE FOUND
        WRITE (CLINE,99) DISBEG , DISEND
        CALL ZMORE(CLINE,0)
99        FORMAT ('No distances in the range ',F5.2,
     c ' to ',F5.2,' angstroms.')
      ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZDOCON
      SUBROUTINE ZDOCON (IFTYPE,N,ICFN)
C This routine calculates the connectivity. Note : connectivity is only
C recalculated when a conn radius is altered or an atom is added.
C INCLUDE,EXCLUDE do not require a new calculation as the presence of an atom
C is checked during the drawing process.
C IFF is a flag set to determine the type of connectivity calculation.
C IFF = 0 calculate for all atoms (-3 is the equivalent negative value)
C IFF = 1 calculate for atom N only.
C IFF = 2 calculate only for atoms lying between ICST and ICFN.
C IFF = -VE calculate as about but don't overwrite the current info.
C IFF = 4/-4 just do cell corners
      
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

      DIMENSION LSTORE(ITOT)
      EQUIVALENCE (RSTORE(1),LSTORE(1))
      CHARACTER*1 CANS
      REAL RAD1,RAD2,DIST
      REAL TOL
      INTEGER ICONN(8,3)
      DATA ICONN/2,1,2,1,1,2,3,4,5,3,4,3,6,5,6,5,4,6,7,8,8,7,8,7/
      DBDMAX = 0.0
      TOL = 1.10
      IFF = IFTYPE
1000  CONTINUE
      IF (IFF.EQ.0) THEN
      ICONBG = ISYMED - IGMAX
      IBPOS = ICONBG
      ELSE IF ((IFF.EQ.-3).OR.(IFF.EQ.-4)) THEN
      IF (ICONBG.EQ.ISYMED-IGMAX) THEN
        ICONBG = ICONED
      ENDIF
      IF (IFF.EQ.-3) IFF = 0
      IBPOS = ICONBG
      ELSE
      IBPOS = ICONED
      ENDIF
      IREND = IBPOS
      INBOND = 0
      IFF = ABS (IFF)
      IF (((IFF.EQ.4).OR.(IFF.EQ.0)).AND.(ICAMER.LT.2)) THEN
C DO THE CELL CORNERS - UNLESS THIS IS THE SMALL VERSION OF CAMERON
C CHECK FOR ROOM
      NROOM = 8 * 6
      IRM = LROOM ( IRLAST , IBPOS , NROOM )
      IF (IRM.EQ.-1) THEN
        CALL ZMORE('Not enough room for connectivity calc!',0)
        IPROC = 0
        RETURN
      ENDIF
      DO 2 I = 1,8
        DO 3 J = 1,3
          RSTORE (IBPOS-J*2+2) = (ISVIEW+((ICONN(I,J)-1)*IPACKT))
          RSTORE (IBPOS-J*2+1) = ICELLC*10
3         CONTINUE
        RSTORE (ISVIEW+(I-1)*IPACKT+IBOND) = IBPOS
        RSTORE (ISVIEW+(I-1)*IPACKT+IBOND+1) = 3.0
        IBPOS = IBPOS - 6
2       CONTINUE
      IREND = IREND - 6 * 8
      ICONED = IREND
      ENDIF
      IF (IFF.EQ.4) RETURN
C RAD1,RAD2 are the connectivity radii of the two atoms in question.
      IF (IFF.EQ.0) THEN
      CALL ZMORE('Calculating connectivity',0)
      ENDIF
      IF ((IFVIEW-ISVIEW)/IPACKT.GT.100) THEN
      ISTEP = (IFVIEW-ISVIEW)/(IPACKT*10)
      ISS = 1
      ELSE
      ISTEP = -1
      ENDIF
      IF (IFF.EQ.0) THEN
      IS = ISVIEW + 8*IPACKT
      IF = IFVIEW
      ELSE IF (IFF.EQ.1) THEN
      IS = N
      IF = N+1
      ELSE
      IS = N
      IF = ICFN
      ENDIF
C CHECK TO SEE IF WE HAVE ROOM FOR MAX NUMBER OF BONDS
      NROOM = 2 * NBDMAX * ( IF - IS ) / IPACKT
      IRM = LROOM ( IRLAST , IBPOS , NROOM)
      IF (IRM.EQ.-1) THEN
      IROK = 0
      ELSE
      IROK = 1
      ENDIF
      DO 10 I = IS,IF-1,IPACKT
      IF (NINT(RSTORE(I)).EQ.4) GOTO 10
C DONT CALC CONNECTIVITY FOR DUMMY ATOMS
      IF (ISTEP.GE.1) THEN
        IF ((I-IS)/IPACKT.EQ.ISTEP*ISS) THEN
          WRITE (CLINE,1111) ISS*10,'%'
1111        FORMAT (I2,1A1)
          CALL ZMORE1(CLINE,0)
          ISS = ISS + 1
        ENDIF
      ENDIF
      RAD1 = RSTORE(I+IATTYP+5)
      X1 = RSTORE(I+IXYZO)
      Y1 = RSTORE(I+IXYZO+1)
      Z1 = RSTORE(I+IXYZO+2)
      IP1 = LSTORE( I + 15 )
      INBOND = 0
      IF (IFF.NE.2) THEN
        IS1 = ISVIEW + 8*IPACKT
        IF1 = IFVIEW
      ELSE
        IS1 = N
        IF1 = ICFN
      ENDIF
      DO 20 J = IS1,IF1-1,IPACKT
        IF (J.EQ.I) GOTO 20
        IF (NINT(RSTORE(J)).EQ.4) GOTO 20
C IGNORE DUMMY ATOMS
        RAD2 = RSTORE(J+IATTYP+5)
        X2 = RSTORE(J+IXYZO)
        Y2 = RSTORE(J+IXYZO+1)
        Z2 = RSTORE(J+IXYZO+2)
        IP2 = LSTORE( J + 15 )
C ATOMS MUST BE IN SAME PART, OR ONE OF THEM IN PART 0.
        IF ( (IP1.EQ.0) .OR. (IP2.EQ.0) .OR. (IP1.EQ.IP2) ) THEN
C CALCULATE THE DISTANCE
         DIST = (X2-X1)**2 + (Y2-Y1)**2 + (Z2-Z1)**2
C THE ATOMS MUST BE WITHIN BONDING DISTANCE
         IF ((DIST.LT.((RAD1+RAD2)*TOL)**2)
     1           .AND.(ABS(DIST).GT.0.001)) THEN
C YES WE HAVE A BOND!
C NEED TO STORE LONGEST BOND
          IF (DIST.GT.DBDMAX) DBDMAX = DIST
          IF (INBOND.EQ.NBDMAX) GOTO 21
          INBOND = INBOND + 1
C CHECK ROOM
          IF (IROK.EQ.0) THEN
            IRM = LROOM ( IRLAST , IBPOS - INBOND*2+2 , 2)
            IF (IRM.EQ.-1) THEN
            IF (ICONBG.NE.ISYMED-IGMAX) THEN
              CALL ZBEEP
              WRITE (CLINE,'(A)')
     c 'Insufficient room - do you want to overwrite '
     c ,'initial connectivity information Y/N ? '
              CALL ZMORE(CLINE,0)
              CALL ZGTANS(CANS,0)
              IF ((CANS.EQ.'Y').OR.(CANS.EQ.'y')) THEN
                ICONBG = ISYMED - IGMAX
                IBPOS = ICONBG
                GOTO 1000
              ENDIF
            ENDIF
            IPROC = 0
            CALL ZMORE(
     c 'Connectivity calc has failed due to lack of room avaialable.',0)
            RETURN
            ENDIF
          ENDIF
          RSTORE (IBPOS-(INBOND*2)+2) = J
          RSTORE (IBPOS-(INBOND*2)+1) = IBNDCL*10
         ENDIF
        ENDIF
20      CONTINUE
C STORE THIS ATOMS BOND CHAIN NUMBERS
21      RSTORE (I+IBOND) = IBPOS
      RSTORE (I+IBOND+1) = INBOND
      IBPOS = IBPOS - INBOND*2
10    CONTINUE
      ICONED = IBPOS
      IREND = IBPOS
      RETURN
      END
 
 
CODE FOR ZDOJN
      SUBROUTINE ZDOJN (IAT1,IAT2,ISTYL,ITYPE)
      
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

C This routine modifies the bond information for each of the atoms
C IAT1 and IAT2.
C GET THE BOND NUMBERS
C CHECK FOR ROOM FOR NEW BOND INFORMATION
C ITYPE = 0 join all bonds or alter style
C       = 1 do not alter style for already existent bonds.
      NROOM = 4
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.EQ.-1) THEN
      CALL ZMORE('JOIN has failed - no room in RSTORE.',0)
      IPROC = 0
      RETURN
      ENDIF
      IAT = IAT1
      IAT3 = IAT2
      DO 40 J = 1,2
      IB1 = NINT(RSTORE(IAT+IBOND))
      NB1 = NINT(RSTORE(IAT+IBOND+1))
C IS THERE ANY SPACE AVAILABLE IN THE LISTS?
C SPACE WOULD BE PRESENT IF A REMOVE OR DISCONNECT HAS BEEN DONE.
      II = 0
      DO 10 I = IB1,IB1-NB1*2+2,-2
        IF ((NINT(RSTORE(I)).EQ.0).OR.(NINT(RSTORE(I)).EQ.IAT3))
     c    II = I
        IF ((NINT(RSTORE(I)).EQ.IAT3).AND.(ITYPE.EQ.1)) RETURN
C BOND IS ALREADY PRESENT
10      CONTINUE
C II IS SET IF AN EMPTY SPACE IS PRESENT - PUT THE INFO INTO THAT SPACE.
      NBND = IBNDCL*10 + ISTYL
      IF (II.NE.0) THEN
        RSTORE(II) = IAT3
        RSTORE(II-1) = NBND
      ELSE IF (IREND.NE.IB1-NB1) THEN
C NEED TO MOVE THE INFO
        DO 20 I = 0,(NB1-1)*2+1
          RSTORE(IREND-I) = RSTORE(IB1-I)
20        CONTINUE
        RSTORE(IREND-(NB1*2)) = IAT3
        RSTORE(IREND-(NB1*2)-1) = NBND
        RSTORE(IAT+IBOND) = IREND
        RSTORE(IAT+IBOND+1) = RSTORE(IAT+IBOND+1) + 1
        IREND = IREND - (NB1*2) - 2
      ELSE
C WE ARE AT THE END OF THE LIST
        RSTORE (IREND) = IAT3
        RSTORE (IREND-1) = NBND
        RSTORE (IAT+IBOND+1) = RSTORE(IAT+IBOND+1) + 1
        IREND = IREND - 2
      ENDIF
      IAT = IAT2
      IAT3 = IAT1
C SWAP AND DO THE OTHER ATOM
40    CONTINUE
      ICONED = IREND
      RETURN
      END
 
CODE FOR ZDOPCK
      SUBROUTINE ZDOPCK (IMX,IMX1,SYMM,IPCKN,ISYMM,ORTH)
C This routine carries out the actual packing subject to the ITYPCK
C flag :-
C ITYPCK = 1 CUT
C        = 2 COMPLETE
C        = 3 CENTROID.
      
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

      REAL C(3),C1(3),PMIN(3),PMAX(3),SYMM(4,4)
      REAL D(3,3),D1(3,3),PCENT(3),ORTH(3,3)
      REAL DTEMP(3)
      INTEGER IMX(3),IMX1(3)
      CHARACTER*50 SWORD
C
C CHECK FOR 0 0 0 TRANSLATION AND IDENTITITY MATRIX
      IF ((IMX(1).EQ.-IMX1(1)).AND.(IMX(2).EQ.-IMX1(2)).AND.
     c (IMX(3).EQ.-IMX1(3)).AND.(ISYMM.EQ.1)) THEN
      IORIG = 1
      ELSE
      IORIG = 0
      ENDIF
      IST = IFVIEW + IPCKN*IPACKT
      ICON = IST + IFINIT - ISINIT - 8*IPACKT
      ICONN = 0
      IF (IPCOLL.EQ.2) THEN
      NROOM = IFINIT - ISINIT + 2 * ( IFINIT - ISINIT - 8*IPACKT
     c  ) / IPACKT
      IRM = LROOM ( IST , IREND , NROOM )
      IF (IRM.EQ.1) THEN
        IROK = 1
      ELSE
        IROK = 0
      ENDIF
      ELSE
C DO WE HAVE ENOUGH ROOM TO DO THIS PACK?
      NROOM = IFINIT - ISINIT - 8*IPACKT
      IRM = LROOM ( IST , IREND , NROOM )
      IF (IRM.EQ.1) THEN
        IROK = 1
      ELSE
        IROK = 0
      ENDIF
      ENDIF
      ILPACK = IPACK
      IDOPCK = 0
      CALL ZMOVE (PKMAX,PMAX,3)
      CALL ZMOVE (PKMIN,PMIN,3)
      IF (IPPCK.EQ.1) THEN
      CALL ZMOVE (PKCNF,PCENT,3)
      ELSE
      CALL ZMOVE(PKCNA,PCENT,3)
      ENDIF
      IF (ITYPCK.EQ.3) THEN
C IS THE CENTROID INSIDE THE LIMIT?
C APPLY THE SYMMETRY OPERATORS AND THE TRANSLATIONS.
      DO 10 I = 1,3
        C(I) = SYMM(I,1)*CENTR(1) + SYMM(I,2)*CENTR(2) +
     c   SYMM(I,3)*CENTR(3) + SYMM(I,4) + IMX(I) + IMX1(I)
10      CONTINUE
      IF (IPPCK.NE.1) THEN
        CALL ZMATV (ORTH,C,C)
      ENDIF
C CHECK FOR BOX
      IF (IPPCK.NE.3) THEN
        DO 20 I = 1,3
          IF ((C(I).LE.(PMAX(I)+PCENT(I))).AND.
     c        (C(I).GE.(PMIN(I)+PCENT(I)))) THEN
            IDOPCK = IDOPCK + 1
          ENDIF
20        CONTINUE
      ELSE
C CHECK FOR SPHERE
        DIST = (C(1)-PCENT(1))**2 + (C(2)-PCENT(2))**2 +
     c    (C(3)-PCENT(3))**2
        IF (DIST.LE.PMAX(1)**2) IDOPCK = 3
      ENDIF
      ELSE IF (ITYPCK.EQ.2) THEN
C NEED TO CHECK THAT AT LEAST ONE ATOM IS IN THE LIMITS.
      IPP = 0
      DO 40 I = ISINIT + 8*IPACKT ,IFINIT-1,IPACKT
        IF (IPP.EQ.1) GOTO 41
        IF ((RSTORE(I+IPCK+1).LT.0.0).OR.(RSTORE(I+IPCK).LT.0.0))
     c    GOTO 40
        DO 44 J = 1,3
          C(J) = SYMM(J,1)*RSTORE(I+1) + SYMM(J,2)*RSTORE(I+2) +
     c      SYMM(J,3)*RSTORE(I+3) + SYMM(J,4) + IMX(J) + IMX1(J)
44        CONTINUE
        IF (IPPCK.NE.1) THEN
          CALL ZMATV (ORTH,C,C)
        ENDIF
        IF (IPPCK.NE.3) THEN
          DO 46 J = 1,3
            IF ( (C(J).GE.(PMIN(J)+PCENT(J))).AND.
     c          (C(J).LE.(PMAX(J)+PCENT(J)))) IPP = IPP + 1
46          CONTINUE
          IF (IPP.EQ.3) THEN
            IPP = 1
          ELSE
            IPP = 0
          ENDIF
        ELSE
          DIST = (C(1)-PCENT(1))**2 + (C(2)-PCENT(2))**2 +
     c      (C(3)-PCENT(3))**2
          IF (DIST.LE.PMAX(1)**2) IPP = 1
        ENDIF
40      CONTINUE
41      CONTINUE
      IF (IPP.EQ.1) IDOPCK = 3
      ENDIF
      IF ((ITYPCK.NE.1).AND.(IDOPCK.NE.3)) RETURN
C FAIL IF CENTRE OR ANY PART OF MOL IS IN NOT CELL.
C OTHERWISE GENERATE WHOLE NEW MOLECULE.
      IF (ITYPCK.NE.1) THEN
      IPFLAG = 0
      DO 50 I = ISINIT + 8*IPACKT,IFINIT-1,IPACKT
C DO NOT PACK EXCLUDED ATOMS
        IF ((RSTORE(I+IPCK+1).LT.0.0).OR.(RSTORE(I+IPCK).LT.0.0))
     c  GOTO 50
        DO 60 J = 1,3
          C(J) = SYMM(J,1)*RSTORE(I+1) + SYMM(J,2)*RSTORE(I+2) +
     c    SYMM(J,3)*RSTORE(I+3) + SYMM(J,4) + IMX(J) + IMX1(J)
60        CONTINUE
        DO 71 J = 1,3
          DO 72 K = 1,3
            D1(J,K) = RSTORE(I+J+K*3)
72          CONTINUE
71        CONTINUE
        DO 70 J = 1,3
          DO 80 K = 1,3
            D(J,K) = SYMM(K,1)*D1(J,1) + SYMM(K,2)*D1(J,2)
     c       + SYMM(K,3)*D1(J,3)
80          CONTINUE
70        CONTINUE
C MOVE OVER THE ATOMS INFO
        IF (IROK.NE.1) THEN
          IF (IPCOLL.EQ.2) THEN
            NROOM = ICONN*2 + 2
            IRM = LROOM ( ICON , IREND , NROOM)
          ELSE
            NROOM = IPACKT
            IRM = LROOM ( IRLAST , IREND , NROOM)
          ENDIF
          IF (IRM.EQ.-1) THEN
            IPROC = 0
            CALL ZMORE('Not enough room to do PACK',0)
            RETURN
          ENDIF
        ENDIF
C CHECK FOR SPECIAL POSITIONS
        IF (NINT(RSTORE(I+ISYM)).EQ.1) THEN
          ISPEC = LSPEC (C,I,ISVIEW,IFVIEW+(IPCKN-1)*IPACKT)
          IF (ISPEC.EQ.1) THEN
            IPCKN = IPCKN + 1
            CALL ZIMOVE (C,D,I,IFVIEW+(IPCKN-1)*IPACKT,IORIG)
            IPFLAG = 1
          ELSE
            GOTO 50
          ENDIF
        ELSE
          IPCKN = IPCKN + 1
          CALL ZIMOVE (C,D,I,IFVIEW+(IPCKN-1)*IPACKT,IORIG)
          IPFLAG = 1
        ENDIF
        IF (IORIG.EQ.1) ILPACK = -1
        IRLAST = IFVIEW+IPCKN*IPACKT
        IF (IPCOLL.EQ.2) THEN
C STORE THE CONNECTIVITY NUMBERS FOR LATER USE
          RSTORE(ICON+ICONN*2) = I
          RSTORE(ICON+ICONN*2+1) = IFVIEW+(IPCKN-1)*IPACKT
          ICONN = ICONN + 1
        ENDIF
50      CONTINUE
      IF (IPFLAG.EQ.1) IPACK = IPACK + 1
      ELSE
C NEED TO DO THE PACK EXPLICITLY
      IPFLAG = 0
      DO 90 I = ISINIT + 8*IPACKT,IFINIT-1,IPACKT
C DO NOT PACK EXCLUDED ATOMS
        IF ((RSTORE(I+IPCK+1).LT.0.0).OR.(RSTORE(I+IPCK).LT.0.0))
     c  GOTO 90
        DO 100 J = 1,3
          C1(J) = SYMM(J,1)*RSTORE(I+1) + SYMM(J,2)*RSTORE(I+2) +
     c      SYMM(J,3)*RSTORE(I+3) + SYMM(J,4) + IMX(J) + IMX1(J)
100       CONTINUE
C ORTHOG IF NEEDED.
        IF (IPPCK.NE.1) THEN
          CALL ZMATV (ORTH,C1,C)
        ELSE
          CALL ZMOVE(C1,C,3)
        ENDIF
C IS THE POINT WITHIN THE LIMITS?
        IDOPCK = 0
        IF (IPPCK.NE.3) THEN
C BOX
          DO 110 J = 1,3
            IF ((C(J).LE.(PMAX(J)+PCENT(J))).AND.
     c          (C(J).GE.(PMIN(J)+PCENT(J)))) THEN
            IDOPCK = IDOPCK + 1
            ENDIF
110         CONTINUE
        ELSE
C SPHERE
          DIST = (C(1)-PCENT(1))**2 + (C(2)-PCENT(2))**2 +
     c      (C(3)-PCENT(3))**2
          IF (DIST.LE.PMAX(1)**2) IDOPCK = 3
        ENDIF
        IF (IDOPCK.EQ.3) THEN
C YES WITHIN THE LIMITS
           DO 73 L = 1,3
             DO 74 M = 1,3
             D1(L,M) = RSTORE(I+M*3+L)
74             CONTINUE
73          CONTINUE
          DO 120 J = 1,3
            DO 130 K = 1,3
            D(J,K) = SYMM(K,1)*D1(J,1) + SYMM(K,2)*D1(J,2)
     c         + SYMM(K,3)*D1(J,3)
130           CONTINUE
120         CONTINUE
          IF (IROK.NE.1) THEN
            IF (IPCOLL.EQ.2) THEN
            NROOM = ICONN*2+2
            IRM = LROOM ( ICON , IREND , NROOM)
            ELSE
            NROOM = IPACKT
            IRM = LROOM ( IRLAST, IREND , NROOM)
            ENDIF
            IF (IRM.EQ.-1) THEN
            IPROC = 0
            CALL ZMORE('Not enough room to do PACK',0)
            RETURN
            ENDIF
          ENDIF
C CHECK FOR SPECIAL POSITIONS
          IF (NINT(RSTORE(I+ISYM)).EQ.1) THEN
            ISPEC = LSPEC(C1,I,ISVIEW,IFVIEW+(IPCKN-1)*IPACKT)
            IF (ISPEC.EQ.1) THEN
            IPCKN = IPCKN + 1
            CALL ZIMOVE (C1,D,I,IFVIEW+(IPCKN-1)*IPACKT,IORIG)
            IPFLAG = 1
            ELSE
            GOTO 90
            ENDIF
          ELSE
            IPCKN = IPCKN + 1
            CALL ZIMOVE (C1,D,I,IFVIEW+(IPCKN-1)*IPACKT,IORIG)
            IPFLAG = 1
          ENDIF
          IF (IORIG.EQ.1) ILPACK = -1
          IRLAST = IFVIEW+IPCKN*IPACKT
          IF (IPCOLL.EQ.2) THEN
C STORE THE CONNECTIVITY NUMBERS FOR LATER USE
            RSTORE(ICON+ICONN*2) = I
            RSTORE(ICON+ICONN*2+1) = IFVIEW+(IPCKN-1)*IPACKT
            ICONN = ICONN + 1
          ENDIF
        ENDIF
90      CONTINUE
      IF (IPFLAG.EQ.1) IPACK = IPACK + 1
      ENDIF
C NOW UPDATE THE CONNECTIVITY INFORMATION
C OUTPUT THE MESSAGES
      IF (ILPACK.EQ.IPACK) RETURN
C THE DATA OUTPUT HAD A PACK VALUE OF 0 SO PACK SHOULD NOT HAVE BEEN
C INCREMENTED
      IF (IORIG.EQ.1) THEN
      IPACK = IPACK - 1
      CALL ZMORE(
     + 'Initial atoms are within PACK range. They are labelled 0.',0)
      ENDIF
      CALL ZSOUT (SYMM,SWORD,ISLEN)
CRIC99 ISLEN is one char too long.
      ISLEN=ISLEN-1
      IF (IORIG.NE.1) THEN
      NSCRAT = NSCRAT + 1
      DTEMP(1) = REAL(IMX(1)+IMX1(1))
      DTEMP(2) = REAL(IMX(2)+IMX1(2))
      DTEMP(3) = REAL(IMX(3)+IMX1(3))
      WRITE (ISCRAT,REC=NSCRAT) SYMM, DTEMP
      CALL ZPRTPK(NSCRAT, SYMM, DTEMP)
      ENDIF
      IF (IPCOLL.EQ.0) THEN
C CALCULATE THE CONNECTIVITY HERE - INTRA MOLECULAR CONTACTS ONLY
      CALL ZATMUL (2,IST,IFVIEW+IPCKN*IPACKT)
      CALL ZDOCON (-2,IST,IFVIEW+IPCKN*IPACKT)
      ENDIF
      IF (IPCOLL.EQ.2) THEN
      CALL ZSCONN (ICON , ICONN , IPCKN)
      ENDIF
      RETURN
      END
 
CODE FOR ZDOVI
      SUBROUTINE ZDOVI
C This routines carries out the drawing procedure
C Atoms are drawn between ISVIEW and IFVIEW.
      
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

      INTEGER KK
      CHARACTER*80 CHARTC
      IF (ISCRN.EQ.-1) THEN
      CALL ZMORE('You have not specified an output device!',0)
      RETURN
      ENDIF
C The atoms are drawn out 'front to back'
C Atoms are flagged once drawn.
      IF (ICURS.EQ.0.AND.ISTREO.EQ.0) THEN
        CALL ZCLEAR
        CALL ZCLARE(0,IDEVCL(IBACK+1))
      ENDIF
      IF (ICURS.NE.0) THEN
C CURSOR CONTROL
      DO 7 I = ISVIEW , IFVIEW-1,IPACKT
        CALL ZBONDS(I,0,0)
7     CONTINUE
      IF (IMENCN.EQ.2) CALL ZMENUS
#ifdef CRY_GUI
      CALL ZMORE('^^CH SHOW',0)
      CALL ZMORE('^^CR',0)
#endif
      RETURN
      ENDIF
C WORK OUT THE NUMBER OF LINES PER BOND AND ANGULAR STEP.
      IF (ISCRN.EQ.4) THEN
      NLINES = 5.0 * SCALE / SCLLIM - 4.0
      IF (NLINES.GT.6) NLINES = 6
      IF (NLINES.LT.2) NLINES = 2
      NANGST = 180 / (NLINES-1)
      ELSE
      NLINES = 6
      NANGST = 36
      ENDIF
C LOOP DOWN THE PLOT STACK
      IPPOS = 1
      DO 10 I = ISVIEW , IFVIEW-1 , IPACKT
C THIS USED TO CHECK FOR ESCAPE KEY EVERY 10 ATOMS.
C IT DOESN'T NOW.
C      IF (MOD((I-ISVIEW)/IPACKT,10).EQ.0) THEN
C        J = LBUFF()
C        IF (J.EQ.0) THEN
C          CALL ZHOME
C          CALL ZMORE('ESCAPE',0)
C          CALL ZMORE(' ',0)
C          IPROC = 0
C          RETURN
C        ENDIF
C      ENDIF
      IPPOS = ISTACK(IPPOS)
      IATNO = ISVIEW + (IPPOS-2)*IPACKT
      ICCC = (IATNO-IRATOM)/IPACKT + ICATOM
C        WRITE (6,*)' DRAWING ATOM ',CSTORE(ICCC),RSTORE(IATNO+IPCK+1)
      CALL ZBONDS(IATNO,NLINES,NANGST)
      RSTORE(IATNO) = -RSTORE(IATNO)
10    CONTINUE
C RESET DRAW FLAGS
      DO 30 I = ISVIEW,IFVIEW-1,IPACKT
      RSTORE (I) = ABS(RSTORE(I))
30    CONTINUE
C DO LABELS
      CALL ZLABEL
      IF (IDOKEY.EQ.1) CALL ZDOKEY
      CALL ZDOTXT
C WE NEED TO RESCALE THE DEVICE SIZE FOR ISCRN = 5 ( POSTSCRIPT )
      IF (ISCRN.EQ.5 .OR. ISCRN.EQ.6 .OR. ISCRN.EQ.8) THEN
      XCEN = XCEN / RES
      YCEN = YCEN / RES
      ENDIF
C      WRITE (ISTOUT,*) 'FINISHED'
      IF (IPHOTO.EQ.1) CALL ZGETKY(KK)
      CALL ZHOME
      IF (ISTREO.EQ.0.AND.(IPCX.EQ.0).AND.(IPHOTO.EQ.0)) THEN
      IF (ISCRN.EQ.5 .OR. ISCRN.EQ.6 .OR. ISCRN.EQ.8) THEN
        WRITE (CLINE,11) SCALE/(RES*10.0), SCALE,RES
      ELSE
        WRITE (CLINE,11) SCALE/RES, SCALE,RES
      ENDIF
cdjwjan00      INLINE = 2
      CALL ZMORE(CLINE,0)
      ENDIF
11    FORMAT (' Scale is ',F9.2, ' (',2F9.2,')')
C ---- GET A TITLE
      IF (ITITLE.GT.0) CALL ZCAPT
      IF (IMENCN.EQ.2) CALL ZMENUS
#ifdef CRY_GUI
      CALL ZMORE('^^CH SHOW',0)
      CALL ZMORE('^^CR',0)
#endif
      RETURN
      END
 
 
CODE FOR ZDLIST
      SUBROUTINE ZDLIST (N,IMULT,ITYPE)
C This routine sets up the distances list.
C ITYPE = 1 add atoms to FROM position
C ITYPE = 2 add atom to TO position
      
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

C      IF (ITYPE.EQ.1) THEN
C         IS = ISVIEW + IPACKT*8
C         IF = IFVIEW
C      ELSE
C         IS = ISINIT + IPACKT*8
C         IF = IFINIT
C      ENDIF
      IS = ISVIEW + IPACKT*8
      IF = IFVIEW
C DO WE HAVE AN ELEMENT?
      IF (N.EQ.0) THEN
      DO 10 I = IS , IF-1 ,IPACKT
        IF (NINT(RSTORE(I+IPCK)).EQ.IMULT-1) THEN
          CALL ZMVDIS ( I , ITYPE  )
          IF (IPROC.EQ.0) RETURN
        ENDIF
10      CONTINUE
      ELSE IF (N.EQ.-1) THEN
      DO 11 I = IS , IF-1, IPACKT
        CALL ZMVDIS (I,ITYPE)
        IF (IPROC.EQ.0) RETURN
11      CONTINUE
      ELSE IF (ABS(N).LT.ICATOM) THEN
      NUM = ABS(N) - ICELM + 1
C LOOP OVER THE ATOMS TO FIND THE CORRECT ELEMENTS
      DO 40 I = IS+IATTYP,IF-1,IPACKT
        IF (IMULT.GT.0 .AND. NINT(RSTORE(I+IPCK)).NE.IMULT-1) GOTO 40
        IF (NINT(RSTORE(I)).EQ.NUM) THEN
          CALL ZMVDIS ((I-IATTYP),ITYPE)
          IF (IPROC.EQ.0) RETURN
        ENDIF
40      CONTINUE
      ELSE
C LOOK FOR MULTIPLE ATOMS
      IF (IMULT.EQ.0) THEN
        NUM = (ABS(N)-ICATOM)*IPACKT + ISINIT
        CALL ZMVDIS (NUM,ITYPE)
        IF (IPROC.EQ.0) RETURN
      ELSE
        IPOS = -1
        DO 60 I = 0 , IPACK
          CALL ZGTATM (N,I,IPOS)
          IF (IPOS.GT.-1) THEN
C STORE THE INFORMATION
            CALL ZMVDIS (IPOS,ITYPE)
            IF (IPROC.EQ.0) RETURN
          ENDIF
60        CONTINUE
      ENDIF
      ENDIF
      RETURN
      END
 
 
CODE FOR ZIMOVE
      SUBROUTINE ZIMOVE (C,D,IOLD,INEW,IORIG)
C This routine is used to copy information about the parent atom onto
C the position of the generated atom in eg PACK.
C C(3) contains the new coordinates
C IOLD contains the start point of the parent atom
C INEW contains the position of the data relevant to the new atom.
      
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

      REAL C(3),D(3,3)
      DO 27 L = 1,3
27    RSTORE(INEW+L) = C(L)
      DO 29 L = 1,3
      DO 31 M = 1,3
31    RSTORE(INEW+M*3+L) = D(L,M)
29    CONTINUE
C MOVE OVER THE OTHER INFO
      RSTORE(INEW) = RSTORE(IOLD)
      DO 35 L = 13,IPACKT-1
      RSTORE (INEW+L) = RSTORE(IOLD+L)
35    CONTINUE
C ZERO LABEL INFO
      RSTORE(INEW+ILAB) = 0.0
      RSTORE(INEW+ILAB+1) = 0.0
      RSTORE(INEW+ILAB+2) = 0.0
C FLAG AS PACK CREATED
      IF (IORIG.EQ.1) THEN
       RSTORE(INEW+IPCK) = 0.0
      ELSE
      RSTORE (INEW+IPCK) = IPACK
      ENDIF
C MOVE LABEL
      KK = (IOLD-IRATOM)/IPACKT + ICATOM
      KL = (INEW-IRATOM)/IPACKT + ICATOM
      CSTORE(KL) = CSTORE(KK)
      ICLAST = ICLAST + 1
      RETURN
      END
 
 
CODE FOR ZJNBND
      SUBROUTINE ZJNBND (DMAX,DMIN,ISB,ISTYL,ITYPE,IFLAG)
      
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
      INTEGER LSTORE(ITOT)
      EQUIVALENCE (RSTORE(1),LSTORE(1))
      REAL DMAX,DMIN
      INTEGER ISB(2)
C ITYPE = 0 join or alter all bonds
C       = 1 do not alter bonds that already exist - this is used for H
C bonds. Any bonds that are full are assumed to be 'normal' bonds and
C are not converted to dotted.
C This routine calculates any bonds that exist between two sets of
C atoms held at ISB(1) and ISB(2) respectively.
      INATOM1 = ISB(2)-ISB(1)
      INATOM2 = INATOM
      DO 10 I = ISB(1),ISB(1)+INATOM1-1
C GET THE COORDS
      IAT1 = NINT(RSTORE(I))
      X1 = RSTORE(  IAT1 + IXYZO)
      Y1 = RSTORE( IAT1 + IXYZO + 1)
      Z1 = RSTORE( IAT1 + IXYZO + 2)
      IP1 = LSTORE( IAT1 + 15 )
      DO 20 J = ISB(2),ISB(2)+INATOM2-1
C GET THE COORDS
        IAT2 = NINT(RSTORE(J))
        IF (IAT1.EQ.IAT2) GOTO 20
        IF (NINT(RSTORE(IAT1+IPCK)).EQ.NINT(RSTORE(IAT2+IPCK)).AND.
     c    IFLAG.EQ.1) GOTO 20
        X2 = RSTORE( IAT2 + IXYZO)
        Y2 = RSTORE( IAT2  + IXYZO +1)
        Z2 = RSTORE( IAT2  + IXYZO +2)
        IP2 = LSTORE( IAT2 + 15 )
C ATOMS MUST BE IN SAME PART, OR ONE OF THEM IN PART 0.
        IF ( (IP1.EQ.0) .OR. (IP2.EQ.0) .OR. (IP1.EQ.IP2) ) THEN
C CALCULATE THE DISTANCE
          DIST = (X1-X2)**2 + (Y1-Y2)**2 + (Z1-Z2)**2
          IF ((DIST.LT.DMAX).AND.(DIST.GT.DMIN)) THEN
C WE HAVE A BOND
            CALL ZDOJN (NINT(RSTORE(I)),NINT(RSTORE(J)),ISTYL,ITYPE)
            IF (IPROC.EQ.0) RETURN
          ENDIF
        ENDIF
20      CONTINUE
10    CONTINUE
      RETURN
      END
 
CODE FOR ZCOLKY
      SUBROUTINE ZCOLKY
C This routine works out the colour key for the default
C colours of the elements. These colours will be changed by a COLOUR x
C command if required.
      
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

      NKEY = 0
      CALL ZZEROF (RSTORE(IKEY),NELM*2)
      DO 10 I = ISVIEW+IATTYP,IFVIEW-1,IPACKT
      II = NINT(RSTORE(I))
C CELL CORNERS AND DUMMY ATOMS DONT HAVE AN ENTRY IN THE KEY
      IF (II.EQ.0) GOTO 10
      K = 0
      DO 20 J = IKEY,IKEY+NKEY*2-2,2
        IF (II.EQ.NINT(RSTORE(J))) K = 1
20      CONTINUE
      IF (K.EQ.0) THEN
C ELEMENT COLOUR NOT IN LIST YET!
        NKEY = NKEY + 1
        RSTORE (IKEY+(NKEY-1)*2) = II
        RSTORE (IKEY+NKEY*2 - 1) = RSTORE(I+1)
      ENDIF
10    CONTINUE
      IRLAST = IRLAST + NELM*2
      RETURN
      END
 
 
CODE FOR ZMODGP [ MODIFY A WHOLE GROUPS INFO ]
      SUBROUTINE ZMODGP (IG,N,VAL)
C IG - group number
C N position of info to be altered if group is found
C VAL - new info to be put into position N.
      
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

      DO 10 I = ISINIT,IFVIEW-1,IPACKT
      DO 20 J = I+IATTYP+6,I+IATTYP+9
        IF (NINT(RSTORE(J)).EQ.IG) THEN
C YES FOUND GROUP
          RSTORE(I+N) = VAL
          GOTO 10
        ENDIF
20      CONTINUE
10    CONTINUE
      RETURN
      END
 
CODE FOR ZMVDIS
      SUBROUTINE ZMVDIS (N,ITYPE)
      
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

C This routine moves over the distance info.
C ITYPE = 1 add to list at IRLAST+NDIST1
C ITYPE = 2 add to list at IRLAST+NDIST2
C CHECK FOR ROOM
      IF (ITYPE.EQ.1) THEN
      NDIST = NDIST1
      ELSE
      NDIST = NDIST2
      ENDIF
      NROOM = NDIST * 4 + 4
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.EQ.-1) THEN
      CALL ZMORE('No room for distance lists',0)
      IPROC = 0
      RETURN
      ENDIF
      RSTORE (IRLAST + NDIST*4     ) = N
      RSTORE (IRLAST + NDIST*4 + 1 ) = RSTORE(N+1)
      RSTORE (IRLAST + NDIST*4 + 2 ) = RSTORE(N+2)
      RSTORE (IRLAST + NDIST*4 + 3 ) = RSTORE(N+3)
      NDIST = NDIST + 1
      IF (ITYPE.EQ.1) THEN
      NDIST1 = NDIST
      ELSE
      NDIST2 = NDIST
      ENDIF
      RETURN
      END
 
 
CODE FOR ZPACK
      SUBROUTINE ZPACK
C This routine controls the symmetry generation of atoms and is called
C via the ENCLOSURE and PACK commands.
C The following flags control the packing operation.
C ITYPCK = 1 - cut pack dead at limits.
C        = 2 - include all of an ass. unit if any is inside limits.
C        = 3 - include all of an ass. unit it its centroid is inside.
C
C IPPCK   = 1 - box in fractional coords sides parallel to crystal axes.
C        = 2 - box in angstroms sides parallel to current view axes.
C        = 3 - sphere with radius in angstroms.
C
C PKMIN/PKMAX - define limits in the three axis directions. (or radius).
C PKMINF/PKMAXF - define limits in the three axis directions. (FRACTIONAL)
C PKCNF,PKCNA - centre point coords in fractional and orthogonal space.
C CENTR      - ASS UNIT centroid.
C PCMIN/PCMAX - the min/max points of the ass unit in fractional coords.
C
C IMX1, SYMM are used to generate the symmetry equivalent sets of atoms.
      
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
      INCLUDE 'XUNITS.INC'
      REAL SYMM(4,4),C(3),C1(3),ORTH(3,3),ORTHI(3,3),PKMAXF(3),PKMINF(3)
      INTEGER IMX(3),IMX1(3)
      INTEGER IPKOLD
      LOGICAL LOPEN,LFILES
      IF (NSYMM.EQ.0) THEN
      CALL ZMORE('No symmetry operators!',0)
      IPROC = 0
      RETURN
      ENDIF
C ZERO PACK NUMBER FOR "ALL" PACKING
      IF (IENCL.NE.1.OR.IGPCK.EQ.0) THEN
      ICONBG = ICONED
      IREND = ICONBG
      IPACK = 0
      ENDIF
      IPKOLD = IPACK
      IF (IPKOLD.EQ.0) IPKOLD=1
      CALL ZMORE('Packing',0)
      CALL ZZEROF (SYMM,16)
      DO 1 I = 1 , 4
      SYMM(I,I) = 1.0
1     CONTINUE
C IS THE PACK SCRATCH FILE OPEN
      INQUIRE (UNIT=ISCRAT,OPENED=LOPEN)
      IF (LOPEN) THEN
C ARE WE CONTINUING WITH A PACK OR RESTARTING
      IF (IPACK.EQ.0) THEN
        IF (.NOT.LFILES (0,' ',ISCRAT))
     +    CALL ZMORE('Error on closing pack no scratch file.',0)
        NSCRAT=1
        IF (.NOT.LFILES (8,' ',ISCRAT)) THEN
          CALL ZMORE('Error on opening pack no scratch file.',0)
          IPROC= 0
          RETURN
        ENDIF
C THIS IS PACKNO=0, OPERATOR=1 , TRANSLATIONS ARE ALL ZERO
        WRITE (ISCRAT,REC=1) SYMM,0.0,0.0,0.0
      ENDIF
      ELSE
      IF (.NOT.LFILES(8,' ',ISCRAT)) THEN
        CALL ZMORE('Error on opening pack no scratch file.',0)
        IPROC = 0
        RETURN
      ENDIF
C THIS IS PACKNO=0, OPERATOR=1 , TRANSLATIONS ARE ALL ZERO
      WRITE (ISCRAT,REC=1) SYMM,0.0,0.0,0.0
      NSCRAT=1
      ENDIF
C GET THE ORTHOGONALISATION MATRICES
      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
      CALL ZMOVE (RSTORE(ICRYST+15),ORTHI,9)
C MOVE OVER THE UNIT CELL COORDINATES
      IF (IPACK.EQ.0) THEN
      CALL ZMOVE (RSTORE(ISINIT),RSTORE(IFINIT),8*IPACKT)
C ALSO MOVE OVER THE CELL LABELS
      ICCC = (IFINIT-IRATOM)/IPACKT + ICATOM
      DO 3000 ICL = 0 , 7
        CSTORE (ICCC+ICL) = CSTORE (ICATOM+ICL)
3000    CONTINUE
C MODIFY CONNECTIVITY INFO
      IFVIEW = IFINIT + 8*IPACKT
      ISVIEW = IFINIT
      IF (IPCOLL.NE.1) THEN
        CALL ZDOCON (-4,0,0)
      ENDIF
      ENDIF
      IG = 0
      IF (IGPCK.NE.0) IG = 1
      IPCKN = 0
C SET THE INITIAL PACK NUMBER TO 1
      IF (ISSPRT .GE. 0) WRITE(NCWU,'(/A/)') 'Starting Packing'
      IF (IPACK.EQ.0) IPACK = 1
C CHECK TO MAKE SURE THAT THE ATOM AT THE CENTRE IS INCLUDED IN THE
C ENCLOSURE
      IF (IGPCK.NE.0 .AND .IENCAT.NE.0) THEN
C STORE THE CENTRE
      K = 0
      DO 1001 I = 0 , IGPCK - 1
        IGGENC = NINT(RSTORE(ISYMED-I))
        DO 1002 J = IENCAT+IATTYP+6,IENCAT+IATTYP+9
          IF (J.EQ.IGGENC) K = 1
1002      CONTINUE
1001    CONTINUE
CHECK THE RESULT
      IF (K.EQ.0) THEN
C THIS ATOM MUST BE ADDED INTO THE PACK
        CALL ZMOVE (RSTORE(IENCAT),RSTORE(IFVIEW),IPACKT)
        ICCC = (IENCAT-IRATOM)/IPACKT + ICATOM
        ICC1 = (IFVIEW-IRATOM)/IPACKT+ICATOM
        CSTORE(ICC1) = CSTORE(ICCC)
C GET RID OF ANY CONNECTIVITY
        RSTORE(IFVIEW+IBOND) =0
        RSTORE(IFVIEW+IBOND+1) = 0
        IFVIEW = IFVIEW + IPACKT
      ENDIF
      ENDIF
1000  CONTINUE
C WE NOW NEED TO LOOP OVER THE GROUPS - IF THEY EXIST
      IF (IGPCK.EQ.0) THEN
C ALL OF THE ATOMS ARE INCLUDED IN THE PACK
      DO 9 I = ISINIT + IPACKT*8 , IFINIT -1 , IPACKT
        RSTORE(I+IPCK) = 1.0
9       CONTINUE
      ELSE
C ONLY INCLUDE THE ONES FOR THIS GROUP
      DO 8 I = ISINIT +IPACKT*8 , IFINIT-1 , IPACKT
        RSTORE(I+IPCK) = -1.0
8       CONTINUE
       CALL ZMODGP (NINT(RSTORE(ISYMED-IG+1)),IPCK,1.0)
      ENDIF
C CALCULATE THE CENTROID
      CALL ZZEROF (CENTR,3)
      CALL ZZEROI (IMX,3)
      N = 0
      DO 10 I = ISINIT+IPACKT*8,IFINIT-1,IPACKT
C DO NOT INCLUDE EXCLUDED ATOMS IN THE CENTROID CALCULATION
      IF ((RSTORE(I+IPCK+1).LT.0.0).OR.(RSTORE(I+IPCK).LT.0.0))
     c  GOTO 10
      DO 20 J = 1,3
        CENTR (J) = CENTR(J) + RSTORE(I+J)
20      CONTINUE
      N = N + 1
10    CONTINUE
      DO 30 J = 1,3
      CENTR(J) = CENTR(J)/N
30    CONTINUE
      CALL ZMATV (ORTH,PKCNF,PKCNA)
CDJW>
C----- FIND THE MOST NEGATIVE CORNER OF AN ORTHOGONAL BOX
      CALL ZZEROI (IMX,3)
      IF ((IENCL .EQ. 1) .AND. (IPPCK .NE. 1)) THEN
         CALL ZMATV(ORTHI, PKMIN, PKMINF)
         DO 65 I = 1,3
            IMX(I) = NINT(PKMINF(I))-1
65       CONTINUE
      ENDIF
CDJW<
C LOOP OVER THE SYMMETRY OPERATORS.
      DO 70 ISYMM = 1,NSYMM
      CALL ZMOVE (RSTORE(ITOT-(ISYMM*16)),SYMM,16)
C CHECK IF THIS OPERATOR IS TO BE USED
      IF (NINT(SYMM(4,4)).EQ.-1) GOTO 70
C WE NEED TO FIND AN INITIAL START POINT
      DO 90 I = 1,3
      PCMAX(I) = -1.0E20
      PCMIN(I) =  1.0E20
90    CONTINUE
C FIND THE MIN/MAX POINTS
C NEED TO APPLY THE SYMMETRY OPERATORS.
      DO 60 I = ISINIT+IPACKT*8,IFINIT-1,IPACKT
C DO NOT COUNT EXCLUDED ATOMS
      IF ((RSTORE(I+IPCK+1).LT.0.0).OR.(RSTORE(I+IPCK).LT.0.0))
     c  GOTO 60
      DO 100 J = 1,3
        C1(J) = RSTORE(I+J)
100     CONTINUE
      DO 105 J = 1,3
        C(J) = SYMM(J,1)*C1(1) + SYMM(J,2)*C1(2) + SYMM(J,3)*C1(3)
     c    + SYMM(J,4)
105     CONTINUE
      IF (IPPCK.NE.1) THEN
        CALL ZMATV (ORTH,C,C)
      ENDIF
       DO 106 J = 1,3
        IF (C(J).LT.PCMIN(J)) PCMIN(J) = C(J)
        IF (C(J).GT.PCMAX(J)) PCMAX(J) = C(J)
106     CONTINUE
60    CONTINUE
CDJW>
       K = 1
       CALL ZZEROI (IMX1, 3)
C----- ONLY FOR A FRACTIONAL BOX
        IF ((IPPCK .EQ. 1)) THEN
      CALL ZZEROI (IMX,3)
80      CONTINUE
      IRANGE = LRANGE(IMX,IMX1,K,SYMM,1,ORTH,ORTHI)
C LRANGE RETURNS 0 = OUT OF RANGE; 1 = IN RANGE;-1 NEVER IN RANGE
      IF (IRANGE.EQ.1) THEN
        IMX(K) = IMX(K) - 1
        GOTO 80
      ELSE IF (IRANGE.EQ.-1) THEN
        GOTO 70
      ENDIF
      K = K + 1
      IF (K.LT.4) GOTO 80
      DO 110 I = 1,3
        IMX(I) = IMX(I) + 1
110     CONTINUE
      ENDIF
CDJW<
C NOW WE HAVE THE START POINT.
C APPLY PACK TO THESE COORDS.
      CALL ZDOPCK (IMX,IMX1,SYMM,IPCKN,ISYMM,ORTH)
      IF (IPROC.EQ.0) RETURN
C WE NOW HAVE TO MOVE THE ASS UNIT AROUND BY UNIT CELLS IN ALL
COMBINATIONS SO THAT WE HAVE A COMPLETELY FILLED PACKED REGION.
      K = 3
        CALL ZZEROI (IMX1, 3)
120     CONTINUE
C INCREMENT POSITION ALONG AXIS K.
      IMX1(K) = IMX1(K) + 1
      IRANGE = LRANGE (IMX1,IMX,K,SYMM,2,ORTH,ORTHI)
      IF (IRANGE.EQ.1) THEN
        CALL ZDOPCK (IMX,IMX1,SYMM,IPCKN,ISYMM,ORTH)
        IF (IPROC.EQ.0) RETURN
        K = 3
        GOTO 120
      ELSE
C NOT IN RANGE, LOOK AT AXIS BELOW.
        IMX1(K) = 0
        K = K - 1
        IF (K.EQ.0) GOTO 70
        GOTO 120
      ENDIF
70    CONTINUE
C NEED TO CHECK IF OTHER GROUPS ARE TO BE PACKED
      IF ((IGPCK.NE.0).AND.(IG.LT.IGPCK)) THEN
      IG = IG + 1
      GOTO 1000
      ENDIF
C SET FLAG TO SHOW THAT A PACK HAS OCCURED
      IENCL = 1
C UPDATE THE VIEW INFORMATION
      ISPACK = IFINIT
      IFPACK = IFVIEW + (IPCKN)*IPACKT
      ISVIEW = ISPACK
      IFVIEW = IFPACK
      IRLAST = IFPACK
      IF (IPCOLL.EQ.1) THEN
      CALL ZMORE('UPDATING ATOM INFORMATION',0)
      CALL ZATMUL (0,0,0)
      CALL ZDOCON (-3,0,0)
      ENDIF
C RESET INITIAL PACK NUMBERS TO ZERO
      DO 1100 I = ISINIT + IPACKT*8 , IFINIT-1 ,IPACKT
      RSTORE(I+IPCK) = 0.0
1100  CONTINUE
C OUTPUT COMPLETION MESSAGE
      WRITE (CLINE,1101) IPACK-IPKOLD
      CALL ZMORE(CLINE,0)
1101  FORMAT (I5 , ' additional symmetry generated units.')
      CALL ZMORE('Key to packing codes is in CRYSTALS listing file',0)
      RETURN
      END
 
CODE FOR ZSADD
      SUBROUTINE ZSADD
      
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

      REAL C(3),D(3,3),C1(3),D1(3,3)
      REAL SYMM(4,4),TRAN(3),WORK(4,4)
      LOGICAL LOPEN,LFILES
C The atoms used to generate the new atoms are held in RSTORE starting
C from IREND , there are INATOM of them.
C Is there enough room to do this?
      NROOM = INATOM * IPACKT
      IRM = LROOM ( IRLAST , IREND - INATOM , NROOM )
      IF (IRM.EQ.-1) THEN
      IPROC = 0
      CALL ZMORE('No room to do this ADD instruction.',0)
      RETURN
      ENDIF
C CHECK THE SCRATCH FILE
      INQUIRE (UNIT=ISCRAT,OPENED=LOPEN)
      IF (.NOT. LOPEN) THEN
      IF (.NOT.LFILES(8,' ',ISCRAT)) THEN
        CALL ZMORE('Error on opening pack no scratch file.',0)
        IPROC = 0
        RETURN
      ENDIF
C WRITE OUT THE IDENTITY OPERATOR
      WRITE (ISCRAT,REC=1) 1.0,0.0,0.0,0.0,
     +                       0.0,1.0,0.0,0.0,
     +                       0.0,0.0,1.0,0.0,
     +                       0.0,0.0,0.0,1.0,
     +                       0.0,0.0,0.0
      NSCRAT = 1
      ENDIF
      IFST = IFVIEW
      IPACK = IPACK + 1
C STORE THE INITIAL PACKNUMBER
      IPKOLD = RSTORE(NINT(RSTORE(IREND))+IPCK)
      DO 10 I = IREND , IREND - INATOM + 1 , -1
      N = NINT(RSTORE(I))
C CHECK THE PACK NUMBER
      IF (NINT(RSTORE(N+IPCK)).NE.IPKOLD) THEN
C NEED TO STORE THE INFORMATION AND MOVE TO THE NEXT PACKNUMBER
        IF (IPKOLD.EQ.0) THEN
          CALL ZZEROF (SYMM,16)
          DO 160 K = 1 , 3
            SYMM(K,K) = 1.0
            TRAN(K) = 0.0
160          CONTINUE
          SYMM(K,K) = 1.0
        ELSE
          READ (ISCRAT,REC=IPKOLD+1) SYMM , TRAN
        ENDIF
C GENERATE THE NEW SYMMETRY OPERATOR
        CALL ZMLTMM (AMSYMM,SYMM,WORK,4,4,4)
        DO 170 K = 1, 3
          TRAN(K) = TRAN(K) + AMTRAN(K)
170        CONTINUE
C OUTPUT THE RESULT
        NSCRAT = NSCRAT + 1
        WRITE (ISCRAT,REC=IPACK+1) WORK,TRAN
        CALL ZPRTPK(IPACK+1, WORK, TRAN)
        WRITE (CLINE,111) IPKOLD, IPACK
        CALL ZMORE(CLINE,0)
111       FORMAT ('Atoms with old pack number ',I4
     +    ,' have been assigned the new pack number ', I4,'.')
        IPKOLD = RSTORE(N+IPCK)
        IPACK = IPACK + 1
      ENDIF
C GET THE COORDS
      DO 20 J = 1,3
        C1(J) = RSTORE(N+J)
20      CONTINUE
      DO 30 J = 1,3
        DO 40 K = 1,3
          D1(J,K) = RSTORE (N+J+K*3)
40        CONTINUE
30      CONTINUE
C APPLY THE SYMM OP AND TRANSLATIONS
      DO 50 J = 1,3
        DO 60 K = 1,3
          D(J,K) = AMSYMM(K,1)*D1(J,1) + AMSYMM(K,2)*D1(J,2)
     c      + AMSYMM (K,3)*D1(J,3)
60        CONTINUE
          C(J) = AMSYMM(J,1)*C1(1) + AMSYMM(J,2)*C1(2) +
     c       AMSYMM(J,3)*C1(3) + AMSYMM(J,4) + AMTRAN(J)
50      CONTINUE
C MOVE THE INFO TO THE NEXT FREE PLACE
      CALL ZIMOVE (C,D,N,IFVIEW,0)
C WE NEED TO INCLUDE THESE ATOMS
      RSTORE(IFVIEW+IPCK) = IPACK
      RSTORE(IFVIEW+IPCK+1) = 1.0
      IFVIEW = IFVIEW + IPACKT
10    CONTINUE
C WE NEED TO STORE THE SYMMETRY INFORMATION IN THE SCRATCH FILE
      IF (IPKOLD.EQ.0) THEN
      CALL ZZEROF (SYMM,16)
      DO 80 I = 1 , 3
        SYMM(I,I) = 1.0
        TRAN(I) = 0.0
80      CONTINUE
      SYMM(I,I) = 1.0
      ELSE
      READ (ISCRAT,REC=IPKOLD+1) SYMM , TRAN
      ENDIF
C GENERATE THE NEW SYMMETRY OPERATOR
      CALL ZMLTMM (AMSYMM,SYMM,WORK,4,4,4)
      DO 90 I = 1, 3
      TRAN(I) = TRAN(I) + AMTRAN(I)
90    CONTINUE
C OUTPUT THE RESULT
      NSCRAT = NSCRAT + 1
      WRITE (ISCRAT,REC=IPACK+1) WORK,TRAN
      CALL ZPRTPK(IPACK+1, WORK, TRAN)
      WRITE (CLINE,111) IPKOLD, IPACK
      CALL ZMORE(CLINE,0)
      IRLAST = IFVIEW
      CALL ZATMUL (2,IFST,IFVIEW)
      CALL ZDOCON (2,IFST,IFVIEW)
      RETURN
      END
 
CODE FOR ZSCONN [ SYMMETRY CONNECTIVITY MODIFICATION ]
      SUBROUTINE ZSCONN (ICON,ICONN,IPCKN)
C This routine takes the list of the old and new numbers of the atoms
C that have been packed and modifies the connectivity info as required.
      
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

      IF (ICONN.EQ.0) RETURN
C NO ATOMS HAVE BEEN ADDED.
C OTHERWISE LOOP OVER THE NEWLY ADDED ATOMS.
      DO 10 I = IFVIEW+(IPCKN-ICONN)*IPACKT,
     c          IFVIEW+(IPCKN-1)*IPACKT , IPACKT
C GET THE CONNECTIVITY INFO POSITION
      INBOND = 0
      NBNDST = NINT (RSTORE(I+IBOND))
      NBONDS = NINT (RSTORE(I+IBOND+1))
C NOW LOOP OVER THE BONDS
      DO 20 J = NBNDST, NBNDST-NBONDS*2+2 ,-2
C GET THE BOND NUMBER
        NN = NINT (RSTORE(J))
C LOOP OVER THE STORED ATOM NUMBERS
        DO 30 K = ICON , ICON+(ICONN-1)*2 , 2
          IF (NN.EQ.NINT(RSTORE(K))) THEN
C WE HAVE FOUND A BOND TO INCLUDE IN THE NEW ATOMS BOND LIST.
            RSTORE(IREND-INBOND*2) = RSTORE(K+1)
            RSTORE(IREND-1-INBOND*2) = RSTORE(J-1)
            INBOND = INBOND + 1
            GOTO 20
          ENDIF
30        CONTINUE
20      CONTINUE
C NOW UPDATE THIS ATOMS BOND INFO
      RSTORE(I+IBOND) = IREND
      RSTORE(I+IBOND+1) = INBOND
      IREND = IREND - INBOND*2
10    CONTINUE
      RETURN
      END
 
CODE FOR ZSMOVE
      SUBROUTINE ZSMOVE
      
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

      REAL C1(3),D1(3,3)
      CHARACTER*1 ANS
      REAL SYMM(4,4)
      REAL WORK(4,4)
      REAL TRAN(3)
      INTEGER IBPOS
      LOGICAL LOPEN,LFILES
C This routine 'moves' the atoms specified relative to their initial
C position.
C Move all of the atoms first - if we would be working on the initial
C set
C CHECK THE SCRATCH FILE
      INQUIRE (UNIT=ISCRAT,OPENED=LOPEN)
      IF (.NOT. LOPEN) THEN
      IF (.NOT.LFILES(8,' ',ISCRAT)) THEN
        CALL ZMORE('Error on opening pack no scratch file.',0)
        IPROC = 0
        RETURN
      ENDIF
C WRITE OUT THE IDENTITY OPERATOR
      WRITE (ISCRAT,REC=1) 1.0,0.0,0.0,0.0,
     +                       0.0,1.0,0.0,0.0,
     +                       0.0,0.0,1.0,0.0,
     +                       0.0,0.0,0.0,1.0,
     +                       0.0,0.0,0.0
      NSCRAT = 1
      ENDIF
      IBPOS = ISYMED - IGMAX
      IVCHAN = 1
      ISOVER = 1
      IF (ISVIEW.EQ.ISINIT .AND. IFVIEW.GT.IFINIT) THEN
C CHECK WHETHER WE ARE MOVING SOMETHING THAT HAS BEEN GENERATED
C USING ADD
      DO 120 I = IREND , IREND-INATOM+1 , -1
        IF (RSTORE(I).LT.IFINIT) THEN
          ISOVER = 0
          GOTO 130
        ENDIF
120     CONTINUE
130     CONTINUE
      ENDIF
      IF (ISOVER.EQ.0 .AND. ISVIEW .EQ. ISINIT ) THEN
C CHECK FOR ROOM
      NROOM = ( IFVIEW - ISVIEW ) / IPACKT
      IRM = LROOM ( IRLAST , IREND - INATOM , NROOM)
      IF (IRM.EQ.-1) THEN
        WRITE (CLINE,'(2A)')
     C 'No room to do this move - do you want to alter the initial
     C coordinates? (Y/N)'
        CALL ZMORE(CLINE,0)
        CALL ZGTANS(ANS,0)
        IF ((ANS.NE.'Y').AND.(ANS.NE.'y')) THEN
          CALL ZMORE('OK - move has failed ',0)
          IPROC = 0
          RETURN
        ENDIF
      ENDIF
      ENDIF
      IF (ISOVER.EQ.0) THEN
      CALL ZMOVE (RSTORE(ISVIEW),RSTORE(IFVIEW),(IFVIEW-ISVIEW))
C NEED TO MOVE THE LABELS TOO!
      KK1 = (ISVIEW-IRATOM)/IPACKT + ICATOM
      KK2 = (IFVIEW-IRATOM)/IPACKT + ICATOM - 1
      KKN = (IFVIEW-ISVIEW)/IPACKT
      DO 5 I = KK1 , KK2
        CSTORE(I+KKN) = CSTORE(I)
5       CONTINUE
      ENDIF
C GET THE FIRST PACKNUMBER
      IPKOLD = RSTORE(NINT(RSTORE(IREND))+IPCK)
      IPACK = IPACK + 1
C Now alter the specified atoms
      DO 10 I = IREND,IREND-INATOM+1,-1
      IF ((ISVIEW.EQ.ISINIT).AND.(ISOVER.EQ.0)) THEN
        N = NINT(RSTORE(I)) + IFVIEW - ISVIEW
      ELSE
        N = NINT(RSTORE(I))
      ENDIF
C GET THE PACK NUMBER
      IF (NINT(RSTORE(N+IPCK)).NE.IPKOLD) THEN
C WE HAVE FOUND A DIFFERENT PACK NUMBER - OUTPUT THE INFORMATION
C FOR THE PREVIOUS PACK NUMBER
        IF (IPKOLD.EQ.0) THEN
          CALL ZZEROF (SYMM,16)
          DO 60 K = 1 , 3
            SYMM(K,K) = 1.0
            TRAN(K) = 0.0
60          CONTINUE
          SYMM(K,K) = 1.0
        ELSE
          READ (ISCRAT,REC=IPKOLD+1) SYMM , TRAN
        ENDIF
C GENERATE THE NEW SYMMETRY OPERATOR
        CALL ZMLTMM (AMSYMM,SYMM,WORK,4,4,4)
        DO 70 K = 1, 3
          TRAN(K) = TRAN(K) + AMTRAN(K)
70        CONTINUE
C OUTPUT THE RESULT
        NSCRAT = NSCRAT + 1
        WRITE (ISCRAT,REC=IPACK+1) WORK,TRAN
        CALL ZPRTPK(IPACK+1, WORK, TRAN)
        WRITE (CLINE,111) IPKOLD, IPACK
        CALL ZMORE(CLINE,0)
111       FORMAT ('Atoms with old pack number ',I4
     +    ,' have been assigned the new pack number ', I4,'.')
        IPKOLD = RSTORE(N+IPCK)
        IPACK = IPACK + 1
      ENDIF
C GET THE INITIAL COORDS ETC
      DO 20 J = 1,3
        DO 30 K = 1,3
          D1(J,K) = RSTORE(N+K+J*3)
30        CONTINUE
        C1(J) = RSTORE(N+J)
20      CONTINUE
C APPLY THE OPERATORS
      DO 40 J = 1,3
        DO 50 K = 1,3
          RSTORE(N+K+J*3) = AMSYMM(J,1)*D1(1,K) + AMSYMM(J,2)*D1(2,K)
     c      + AMSYMM(J,3)*D1(3,K)
50        CONTINUE
        RSTORE (N+J) = AMSYMM(J,1)*C1(1) + AMSYMM(J,2)*C1(2)
     c    + AMSYMM(J,3)*C1(3) + AMSYMM(J,4) + AMTRAN(J)
40      CONTINUE
C ALTER THE PACK INFORMATION
      RSTORE(N+IPCK) = IPACK
10    CONTINUE
C OUTPUT THE FINAL PACK INFORMATION
      IF (IPKOLD.EQ.0) THEN
      CALL ZZEROF (SYMM,16)
      DO 80 I = 1 , 3
        SYMM(I,I) = 1.0
        TRAN(I) = 0.0
80      CONTINUE
      SYMM(I,I) = 1.0
      ELSE
      READ (ISCRAT,REC=IPKOLD+1) SYMM , TRAN
      ENDIF
C GENERATE THE NEW SYMMETRY OPERATOR
      CALL ZMLTMM (AMSYMM,SYMM,WORK,4,4,4)
      DO 90 I = 1, 3
      TRAN(I) = TRAN(I) + AMTRAN(I)
90    CONTINUE
C OUTPUT THE RESULT
      NSCRAT = NSCRAT + 1
      WRITE (ISCRAT,REC=IPACK+1) WORK,TRAN
      CALL ZPRTPK(IPACK+1, WORK, TRAN)
      WRITE (CLINE,111) IPKOLD, IPACK
      CALL ZMORE(CLINE,0)
      IF ((ISVIEW.EQ.ISINIT).AND.(ISOVER.EQ.0)) THEN
      NAT = IFVIEW - ISVIEW
      ISVIEW = IFVIEW
      IFVIEW = IFVIEW + NAT
      ENDIF
      IRLAST = IFVIEW
      CALL ZATMUL(0,0,0)
      IF (ISOVER.EQ.0) THEN
      CALL ZDOCON (-3,0,0)
      ELSE
      CALL ZDOCON (0,0,0)
      ENDIF
      RETURN
      END
 
CODE FOR ZSOUT [ SYMMETRY OPERATOR OUTPUT ]
      SUBROUTINE ZSOUT (SYMM,SWORD,ISLEN)
C THIS ROUTINE TAKES THE MATRIX AND CONVERTS IT INTO CONVENTIONAL FORM.
      
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

      REAL SYMM(4,4),TRAN(8)
      CHARACTER*3 CTRAN(8)
      CHARACTER*1 SX(3)
      CHARACTER*50 SWORD
      INTEGER IS
      DATA TRAN /0.0,0.5,0.3333,0.25,0.66667,0.75,0.166667,0.8333333/
      DATA CTRAN /'0  ','1/2','1/3','1/4','2/3','3/4','1/6','5/6'/
      DATA SX /'x','y','z'/
C BEGIN TO LOOP OVER THE MATRIX
      IS = 1
      DO 10 I = 1 , 3
      DO 20 J = 1 , 3
C CHECK - IS THIS A NON ZERO ENTRY
        IF (SYMM(I,J).GT.0.1) THEN
          SWORD(IS:IS+1) = '+'//SX(J)
          IS = IS + 2
        ELSE IF (SYMM(I,J).LT.-0.1) THEN
          SWORD(IS:IS+1) = '-'//SX(J)
          IS = IS + 2
        ENDIF
20      CONTINUE
C NOW LOOK AT THE NUMBER
      IF (ABS(SYMM(I,4)).GT.0.1) THEN
        ITRAN = 0
        DO 30 K = 2 , 7
          IF (ABS(ABS(SYMM(I,4))-TRAN(K)).LT.0.01) ITRAN = K
30        CONTINUE
        IF (ITRAN.NE.0) THEN
          IF (SYMM(I,4).LT.0.0) THEN
            SWORD(IS:IS+3) = '-'//CTRAN(ITRAN)
            IS = IS + 4
          ELSE
            SWORD(IS:IS+3) = '+'//CTRAN(ITRAN)
            IS = IS + 4
          ENDIF
        ENDIF
      ENDIF
      SWORD(IS:IS) = ' '
      IS = IS + 1
10    CONTINUE
      ISLEN = IS
      RETURN
      END
 
 
CODE FOR LMOLAX
      FUNCTION LMOLAX(POINTS,NPOINT,ISTEP,CENT,ROOTS,VECTOR,COSINE,
     2 WORK)
C--COMPUTE THE MEAN PLANE THROUGH A SET OF POINTS.
C
C  POINTS  THE ARRAY CONTAINING THE POINTS TO BE FITTED. THE FIRST FOUR
C          LOCATIONS FOR EACH POINT MUST BE SET AS FOLLOWS :
C
C          1  X.
C          2  Y.
C          3  Z.
C          4  THE WEIGHT OF THIS POINT.
C
C  NPOINT  THE NUMBER OF POINTS TO BE FITTED.
C  ISTEP   THE NUMBER OF WORDS PER POINT.
C  CENT    AN ARRAY WHICH CONTAINS THE CENTROID IN CRYSTALS FRACTIONS ON
C          EXIT.
C  ROOTS   THE LATENT ROOTS IN DESCENDING ORDER.
C  VECTOR  THE LATENT VECTORS, STORED BY ROWS. (VECTOR(I,J),J=1,3) IS
C          THE VECTOR CORRESPONDING TO LATENT ROOT 'ROOT(I)'.
C          THIS MATRIX IS SUITABLE FOR TRANFORMING ORTHOGONAL COORDINATE
C          INTO BEST PLANE COORDINATES.
C  COSINE  THE LATENT VECTORS, STORED BY COLUMNS. THIS MATRIX IS
C          SUITABLE FOR TRANSFORMING BEST PLANE COORDINATES INTO ORTHOGO
C          COORDINATES.
C  WORK    SOME WORK SPACE.
C
C--THE RETURN VALUES OF 'LMOLAX' ARE :
C
C  -1  NOT ENOUGH POINTS TO DEFINE A PLANE.
C   0  OKAY.
C
C--
      DOUBLE PRECISION DVECTR,DROOTS,DCOSIN,DWORK,DPOINT
C
      DIMENSION POINTS(ISTEP,NPOINT),CENT(3),ROOTS(3),VECTOR(3,3),
     2 COSINE(3,3),WORK(4)
C     THIS IS ADDED FOR NOW!
      REAL ORTH (3,3)
      DIMENSION DVECTR(3,3),DROOTS(3),DCOSIN(3,3),DWORK(10)
C Alterations have been made so that this will stand free from CRYSTALS.
      
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

      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
C
C\STORE
C\XLST01
C
C--CHECK THAT THERE ARE AT LEAST 2 POINTS
      IF(NPOINT-2)1000,1100,1100
C--NOT ENOUGH POINTS
1000  CONTINUE
      LMOLAX=-1
1050  CONTINUE
      RETURN
C--ZERO SOME ARRAYS
1100  CONTINUE
      CALL ZZEROF(CENT(1),3)
      DO 1120 I=1,3
      DO 1110 J=1,3
      DVECTR(J,I)=0.0D0
1110  CONTINUE
1120  CONTINUE
C--COMPUTE THE CENTROID
      A=0.
      DO 1200 I=1,NPOINT
      A=A+POINTS(4,I)
      DO 1150 J=1,3
      CENT(J)=CENT(J)+POINTS(J,I)*POINTS(4,I)
1150  CONTINUE
1200  CONTINUE
C--COMPUTE THE WEIGHTED CENTROID VALUES
      DO 1250 I=1,3
      CENT(I)=CENT(I)/A
1250  CONTINUE
C--ACCUMULATE THE NORMAL EQUATIONS
      DO 1450 I=1,NPOINT
      DO 1300 J=1,3
      WORK(J)=POINTS(J,I)-CENT(J)
1300  CONTINUE
C--ORTHOGONALISE THE RESULT
C      CALL ZMLTTM(RSTORE(L1O1),WORK(1),ROOTS(1),3,3,1)
C      CALL ZMLTTM (RSTORE(ICRYST+6),WORK(1),ROOTS(1),3,3,1)
       CALL ZMATV (ORTH,WORK,ROOTS)
C      CALL ZMLTTM (ORTH , WORK(1) , ROOTS(1) , 3 , 3 , 1)
C--CONVERT THE RESULTS TO DOUBLE PRECISION
      DO 1310 J=1,3
      DROOTS(J)=DBLE(ROOTS(J))
1310  CONTINUE
      DPOINT=DBLE(POINTS(4,I))
C--ADD INTO THE NORMAL EQUATIONS
      DO 1400 J=1,3
      DO 1350 K=J,3
      DVECTR(K,J)=DVECTR(K,J)+DPOINT*DROOTS(K)*DROOTS(J)
      DVECTR(J,K)=DVECTR(K,J)
1350  CONTINUE
1400  CONTINUE
1450  CONTINUE
C--COMPUTE THE LATENT ROOTS AND VECTORS
c      I=0
c      CALL F02ABF(DVECTR,3,3,DROOTS,DCOSIN,3,DWORK,I)
      INFO = 0
      CALL DSYEV('V','L',3,DVECTR,3,DROOTS,DWORK,10,INFO)

C--TRANSFORM THE RESULT INTO THE CORRECT ORDER
      DO 1470 I=1,3
      ROOTS(I)=SNGL(DROOTS(4-I))
      DO 1460 J=1,3
c      COSINE(I,J)=SNGL(DCOSIN(I,4-J))
      COSINE(I,J)=SNGL(DVECTR(I,4-J))
1460  CONTINUE
1470  CONTINUE
C--CHECK THAT THE MATRIX IS RIGHT HANDED
      IF(XDETR3(COSINE))1550,1000,1650
C--MATRIX IS LEFT HANDED
1550  CONTINUE
      DO 1600 I=1,3
      COSINE(I,3)=-COSINE(I,3)
1600  CONTINUE
C--NORMALISE THE LATENT VECTORS
1650  CONTINUE
      DO 1800 I=1,3
      A=0.
      DO 1700 J=1,3
      A=A+COSINE(J,I)*COSINE(J,I)
1700  CONTINUE
      A=1./SQRT(A)
      DO 1750 J=1,3
      COSINE(J,I)=COSINE(J,I)*A
      VECTOR(I,J)=COSINE(J,I)
1750  CONTINUE
1800  CONTINUE
      LMOLAX=0
      GOTO 1050
      END
C
 
CODE FOR ZATMUL [ ATOM MATRIX MULTIPLIER ]
      SUBROUTINE ZATMUL(IFF,IST,IFN)
C This routine multiplies the atomic coordinates by the matrix MAT1
C The atomic coords begin at ISVIEW and end at IFVIEW with step IPACKT.
C The actual coords are held at ISVIEW + 1 and the result is put into
C ISVIEW + IXYZO.
C It also calculates the picture centre XCP,YCP.
C Unless we are doing fast drawing.
C IHAND specifies the 'hand' of the coordinate system if this is 1 then
C we have a left handed coordinate system in the output device and the
C program has to allow for this by inverting the Y coordinates.
C IFF is a control flag
C IFF = 0 do atoms between IFVIEW and ISVIEW.
C IFF = 2 do atoms between IST and IFN only.
      
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

      REAL PMIN(3),PMAX(3),EIGS(3),E1(4),E2(4),PP(4)
      REAL V(3),VECV(3),V1(3),V2(3),V3(3),AXX(3,3)
      INTEGER IARC(4)
      INTEGER IPPOS
      IF (ISTREO.EQ.0.AND.ICURS.NE.1.AND.IFF.EQ.0) THEN
cdjwjan00      CALL ZMORE('Calculating View information',0)
cdjwjan00      CALL ZMORE(' ',0)
      ENDIF
      IPPOS = 0
      VECV(1) = 0.0
      VECV(2) = 0.0
      VECV(3) = 1.0
      IELROT = IRLAST
      IOVER = IREND
      IF (IFF.EQ.0) THEN
      IS = ISVIEW
      IF = IFVIEW
      ELSE
      IS = IST
      IF = IFN
      ENDIF
      DO 30 I = 1,3
      PMIN (I) = 100.0
30      PMAX (I) = -100.0
      DO 10 I = IS,IF-1,IPACKT
      IF (MOD((I-IS)/IPACKT,100).EQ.0.AND.IFF.EQ.0
     + .AND.ICURS.EQ.0.AND.ISTREO.EQ.0) CALL ZPRNT ('.')
      V(1) = RSTORE (I+1)
      V(2) = RSTORE (I+2)
      V(3) = RSTORE (I+3)
      CALL ZMATV4 (MAT1,V,V)
      IF (ICURS.NE.1.AND.IVCHAN.EQ.1) THEN
C UPDATE THE PLOT STACK
      CALL ZPSTCK(V(3),IPPOS)
      ENDIF
      IF (RSTORE(I+IPCK+1).LT.0.0) GOTO 10
      DO 20 J = 1,3
C WORK OUT SCALE IF ATOM IS IN VIEW RANGE
      RSTORE(I+J+IXYZO-1) = V(J)
      IF ((J.EQ.2).AND.(IHAND.EQ.1)) THEN
        RSTORE(I+J+IXYZO-1) = -V(J)
      ENDIF
      IF (PMIN(J).GT.RSTORE(I+J+IXYZO-1))
     c  PMIN(J)=RSTORE(I+J+IXYZO-1)
      IF (PMAX(J).LT.RSTORE(I+J+IXYZO-1))
     c  PMAX(J)=RSTORE(I+J+IXYZO-1)
20    CONTINUE
C Change the coordinates of the ellipsoid end points.
C JUMP OUT IF DOING THE CELL CORNERS
      IF (NINT(RSTORE(I)).EQ.5) GOTO 10
      IF (NINT(RSTORE(I)).EQ.2.OR.NINT(RSTORE(I)).EQ.6) THEN
C NEED TO INCLUDE THE ATOMIC RADIUS IN THE SCALE CALC
      IF (RSTORE(I).GT.5.5) THEN
        R= RSTORE(NINT(IRELM+(RSTORE(I+IATTYP)-1)*4.0+2))
      ELSE
        R = RSTORE (I+IATTYP+4)
      ENDIF
      DO 21 J = 1 , 3
        IF (PMIN(J).GT.RSTORE(I+J+IXYZO-1)-R)
     c      PMIN(J) = RSTORE(I+J+IXYZO-1) - R
        IF (PMAX(J).LT.RSTORE(I+J+IXYZO-1)+R)
     c      PMAX(J) = RSTORE(I+J+IXYZO-1) + R
21      CONTINUE
      GOTO 10
      ENDIF
C GET THE EIGENVALUES
      IF (NINT(RSTORE(I)).NE.3) GOTO 10
      DO 60 J = 1,3
      EIGS(J) = RSTORE(I+J+IXYZO+11) * RELSCL
60    CONTINUE
      IF (EIGS(1).LT.0.0) THEN
C ISO ATOM
C NEED TO INCLUDE THE ATOMIC RADIUS IN THE SCALE CALC
      R = SQRT ( ABS ( EIGS(1) ) )
      DO 22 J = 1 , 3
        IF (PMIN(J).GT.RSTORE(I+J+IXYZO-1)-R)
     c      PMIN(J) = RSTORE(I+J+IXYZO-1) - R
        IF (PMAX(J).LT.RSTORE(I+J+IXYZO-1)+R)
     c      PMAX(J) = RSTORE(I+J+IXYZO-1) + R
22      CONTINUE
      GOTO 10
      ENDIF
C WE NEED TO ADD THE CENTRE OF THE ATOM TO THE COORDS SO THAT THE
C ROTATION IS CORRECT.
      DO 40 J = 1,3
      V1(J) = RSTORE (I+J*3+1) + RSTORE(I+J)
      V2(J) = RSTORE(I+J*3+2) + RSTORE(I+J)
      V3(J) = RSTORE (I+J*3+3) + RSTORE(I+J)
40    CONTINUE
C MULTIPLY
      CALL ZMATV4 (MAT1,V1,V1)
      CALL ZMATV4 (MAT1,V2,V2)
      CALL ZMATV4 (MAT1,V3,V3)
      DO 50 J = 1,3
      RSTORE(I+IXYZO-1+J*3+1) = (V1(J) - V(J))*SQRT(RELSCL)
      RSTORE(I+IXYZO-1+J*3+2) = (V2(J) - V(J))*SQRT(RELSCL)
      RSTORE(I+IXYZO-1+J*3+3) = (V3(J) - V(J))*SQRT(RELSCL)
      IF ((J.EQ.2).AND.(IHAND.EQ.1)) THEN
        RSTORE(I+IXYZO-1+J*3+1) = - RSTORE(I+IXYZO-1+J*3+1)
        RSTORE(I+IXYZO-1+J*3+2) = - RSTORE(I+IXYZO-1+J*3+2)
        RSTORE(I+IXYZO-1+J*3+3) = - RSTORE(I+IXYZO-1+J*3+3)
      ENDIF
      V1(J) = RSTORE(I+IXYZO-1+J*3+1)
      V2(J) = RSTORE(I+IXYZO-1+J*3+2)
      V3(J) = RSTORE(I+IXYZO-1+J*3+3)
50    CONTINUE
C CHECK THE SCALE
      DO 42 J = 1,3
      IF (ABS(V1(J))+RSTORE(I+IXYZO+J-1).GT.PMAX(J))
     c     PMAX(J)=ABS(V1(J))+RSTORE(I+IXYZO+J-1)
      IF (-ABS(V1(J))+RSTORE(I+IXYZO+J-1).LT.PMIN(J))
     c     PMIN(J)=-ABS(V1(J))+RSTORE(I+IXYZO+J-1)
      IF (ABS(V2(J))+RSTORE(I+IXYZO+J-1).GT.PMAX(J))
     c     PMAX(J)=ABS(V2(J))+RSTORE(I+IXYZO+J-1)
      IF (-ABS(V2(J))+RSTORE(I+IXYZO+J-1).LT.PMIN(J))
     c     PMIN(J)=-ABS(V2(J))+RSTORE(I+IXYZO+J-1)
      IF (ABS(V3(J))+RSTORE(I+IXYZO+J-1).GT.PMAX(J))
     c     PMAX(J)=ABS(V3(J))+RSTORE(I+IXYZO+J-1)
      IF (-ABS(V3(J))+RSTORE(I+IXYZO+J-1).LT.PMIN(J))
     c     PMIN(J)=-ABS(V3(J))+RSTORE(I+IXYZO+J-1)
42    CONTINUE
C check that the axes are perpendicular
      CALL ZDTPRD (V1,V2,R)
      CALL ZDTPRD (V1,V3,R)
      CALL ZDTPRD (V2,V3,R)
C CHECK THAT AXES POINT TOWARDS THE VIEWER
      CALL ZDTPRD (V1,VECV,R)
      IF (R.GT.90.0) THEN
      DO 140 J = 1, 3
        RSTORE(I+IXYZO-1+J*3+1) = -V1(J)
140     CONTINUE
      ENDIF
      CALL ZDTPRD (V2,VECV,R)
      IF (R.GT.90.0) THEN
      DO 150 J = 1,3
        RSTORE(I+IXYZO-1+J*3+2) = -V2(J)
150     CONTINUE
      ENDIF
      CALL ZDTPRD (V3,VECV,R)
      IF (R.GT.90.0) THEN
      DO 160 J = 1,3
        RSTORE(I+IXYZO-1+J*3+3) = -V3(J)
160     CONTINUE
      ENDIF
C GET THE NEW AXES
      DO 70 J = 1,3
       AXX(J,1) = RSTORE(I+IXYZO-1+J*3+1)
       AXX(J,2) = RSTORE(I+IXYZO-1+J*3+2)
       AXX(J,3) = RSTORE(I+IXYZO-1+J*3+3)
70    CONTINUE
C GET THE BOUNDING ELLIPSE ATTRIBUTES
      CALL ZBOUEL (EIGS,AXX,E1,E2,PP,IARC)
C STORE THIS INFO
      DO 90 J = 1,4
      RSTORE(IELROT+(J-1)*4) = E1(J)
      RSTORE(IELROT+(J-1)*4+1) = E2(J)
      RSTORE(IELROT+(J-1)*4+2) = PP(J)
      RSTORE(IELROT+(J-1)*4+3) = IARC(J)
90    CONTINUE
      RSTORE ( I + IXYZO + 15 ) = IELROT
      IELROT = IELROT + 16
10    CONTINUE
      XCP = (PMIN(1)+PMAX(1))/2
      YCP = (PMIN(2)+PMAX(2))/2
      PMAXX = PMAX(1)
      PMAXY = PMAX(2)
      IF (ICURS.EQ.0) THEN
C WORK OUT THE TWO SCALES
      IF (ISLCNT.EQ.1) THEN
         IF (ABS(PMAX(1)-XCP).LT.0.00001) THEN
           SCALE1 = 10000000
         ELSE
           SCALE1 = XCEN/(PMAX(1)-XCP)
         ENDIF
         IF (ABS(PMAX(2)-YCP).LT.0.00001) THEN
           SCALE2 = 10000000
         ELSE
C WE MAY NEED TO ALTER THE Y SCALE DUE TO THE PRESENCE OF MENUS
           IF (IDEV.EQ.1.AND.IMENCN.NE.0) THEN
             SCALE2 = (YCEN-30)/(PMAX(2)-YCP)
           ELSE
             SCALE2 =YCEN/(PMAX(2)-YCP)
           ENDIF
         ENDIF
C THE ACTUAL SCALE IS THE SMALLEST OF THESE TWO.
           SCALE = MIN( SCALE1, SCALE2)
C SCALE DOWN SO THAT IT FITS ON THE PAGE PROPERLY
        SCALE = 0.9 * SCALE
      ENDIF
CDJW MOVED OUTSIDE PREVIOUS ENDIF MAY 96
C       IF ENCAPSULATED POSTSCRIPT CALCULATE THE TRUE PAGE SIZE
cdjwjul09 - encap and normal are same except for PS header
cdjwjul09         IF (IENCAP.EQ.1 .AND. ISCRN.EQ.IHARD) THEN
cdjwjul09             CALL ZESCAL
cdjwjul09         ENDIF
      ENDIF
C NOW CALCULATE THE OVERLAP (IF WE HAVE A NON RASTER DEVICE)
      IF (ISCRN.EQ.4) CALL ZOVERL
cdjwfeb2000      IF (ICURS.EQ.0) CALL ZMORE(' ',0)
      RETURN
      END
C
CODE FOR ZESCAL
      SUBROUTINE ZESCAL
C----- COMPUE THE SCALE FACTORS FOR ENCAPSULATED POSTSCRIPT
C*** NOTE THAT THERE IS SIMILAR CODE IN COMM.FOR AT LABEL 101
      
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

C QUART IS EQUIVALENT TO 0.25" IN POSTSCRIPT
          QUART = 720.0 * 0.25
          XTRUE = SCALE * (PMAXX-XCP)
          YTRUE = SCALE * (PMAXY-YCP)
          XEMIN = XCEN-XTRUE -QUART
          XEMAX = XCEN+XTRUE +QUART
          YEMIN = YCEN-YTRUE -QUART
          YEMAX = YCEN+YTRUE +QUART
      RETURN
      END
C 
CODE FOR ZCALBD
      SUBROUTINE ZCALBD
     c (X1,Y1,X2,Y2,Z1,Z2,A,B,C,ICOL,ISTYL,IATNO,ITYPE,NLINES,NANGST)
C This routine obtains the point of intersection of the bond with the
C sphere or ELLIPSE and then works out the coordinates of the bond
C itself.
C ITYPE = 1 siginifies a single line bond.
C ITYPE = 2 IS A THICK BOND
C NLINES = no of lines to make up the bond (max 6 min 1)
C NANGST = angular step around the bond cone.
      
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

      REAL V(3),XR1(6),YR1(6),XR2(6),YR2(6),VV(3)
      REAL XX1(2),XX2(2),M1(3,3),M2(3,3),V1(3)
      INTEGER ICOL,IX(200),IY(200)
      CALL ZZEROF (V1,3)
      CALL ZZEROF (V,3)
      V1(1) = X2 - X1
      V1(2) = Y2 - Y1
      V1(3) = Z2 - Z1
      IF (ABS(A-0.0).LT.0.001) THEN
      X = 0.0
      Y = 0.0
      V(1) = V1(1)
      V(2) = V1(2)
      V(3) = V1(3)
      GOTO 1111
      ENDIF
      IF (ABS(V1(1)).LT.0.0001.AND.ABS(V1(2)).LT.0.0001) RETURN
C FIRST WE NEED TO GET THE ROTATION MATRIX FOR THE ELLIPSE.
      IF (ABS(A-B).GT.0.00001) THEN
      DO 1 I = 1 , 3
        DO 2 J = 1 , 3
           M2(I,J) = RSTORE(IATNO+IXYZO-1+J*3+I)
     c     /  SQRT ( ABS( RSTORE(IATNO+IXYZO+11+I) ) * RELSCL)
           M1(J,I) = M2(I,J)
2         CONTINUE
1       CONTINUE
C NOW ROTATE THE VECTOR
      CALL ZMATV (M2,V1,V)
      ELSE
      V(1) = V1(1)
      V(2) = V1(2)
      V(3) = V1(3)
      ENDIF
      IF ((ABS(V(1)).LT.0.001).AND.(ABS(V(2)).LT.0.001)) THEN
C SOLVE THE EQUATION Z**2/C = 1
      VV(1) = 0.0
      VV(2) = 0.0
      VV(3) = SQRT(C)
      ELSE IF (ABS(V(1)).LT.0.0001) THEN
C MAKE THE X TERM ZERO AND SOLVE FOR Y
      D = ABS(V(3)/V(2))
      VV(2) = SQRT ( 1.0 / ( ( 1.0/B) + (D**2/C) ) )
      VV(1) = 0.0
      VV(3) = VV(1)*D
      ELSE IF (ABS(V(2)).LT.0.0001) THEN
C MAKE THE Y TERM ZERO AND SOLVE FOR X
        D = ABS(V(3)/V(1))
        VV(1) = SQRT ( 1.0 / ( (1.0/A) + (D**2/C) ) )
        VV(2) = 0.0
        VV(3) = VV(1)*D
      ELSE
C The vector is to be represented in the form x,dx,ex.
      D = V(2)/V(1)
      E = V(3)/V(1)
C The equation of the ELLIPSE/ sphere is :-
C x**2/a + d**2 x**2 / b + e**2 x**2 / c = 1
C for a sphere a = b = c = r**2
C Therefore the X,Y coordinates of the point of intersection of the
C vector with the sphere is :-
      VV(1) = SQRT ( 1.0 / ( 1.0/A + (D**2/B) + (E**2/C) ) )
      VV(2) = ABS(D) * VV(1)
      VV(3) = ABS(E) * VV(1)
      ENDIF
C We need to find out which side of the intersection we want.
      IF (V(1).LT.0.0) VV(1) = -VV(1)
      IF (V(2).LT.0.0) VV(2) = -VV(2)
      IF (V(3).LT.0.0) VV(3) = -VV(3)
      V(1) = VV(1)
      V(2) = VV(2)
      V(3) = VV(3)
      IF (ABS(A-B).GT.0.0001) THEN
      CALL ZMATV (M1,V,V1)
      CALL ZMOVE (V1,V,3)
      ENDIF
      X = V(1)
      Y = V(2)
1111  CONTINUE
      IF (ISTYL.NE.0 .AND. ISCRN .NE. 4) THEN
      IX(1) = NINT ( ( X1 + X - XCP) * SCALE )
      IY(1) = NINT ( ( Y1 + Y - YCP) * SCALE )
      IX(2) = NINT ( ( X2 - XCP) * SCALE)
      IY(2) = NINT ( ( Y2 - YCP) * SCALE)
      CALL ZDRBND (ISTYL,IX,IY,2,ICOL,IATNO,0,0)
      RETURN
      ENDIF
      IF (ITYPE.EQ.1 .OR. (ISTYL.EQ.2 .AND. ISCRN.EQ.4)) THEN
C WE ARE DOING A SINGLE LINE BOND
      IF (ISCRN.EQ.4) THEN
        XX1(1) = X1 + X
        XX1(2) = Y1 + Y
        XX2(1) = X2
        XX2(2) = Y2
        CALL ZLINEC (XX1,XX2,ICOL,IATNO,NPOINT,2,ISTYL)
        RETURN
      ELSE
        IX(1) = NINT ( (X1 + X - XCP )*SCALE)
        IX(2) = NINT ( ( X2 -XCP)*SCALE)
        IY(1) = NINT ( (Y1 + Y - YCP )*SCALE)
        IY(2) = NINT ( ( Y2 - YCP)*SCALE)
        CALL ZDRLIN (1,IX,IY,2,IDEVCL(ICOL+1),IATNO)
        RETURN
      ENDIF
      ENDIF
C Work out the coordinates of the circle, we need ten lines for the
C bond.
C THE ELLIPSE MAJOR AXIS IS PERPENDICULAR TO THE BOND DIRECTION
C----- TEST ADED BY DJW, MAY95
      IF ((ABS(V(1)).LT.0.001).AND.(ABS(V(2)).LT.0.001)) THEN
          P = PI
      ELSE
        P = ATAN2 ( V(1) , V(2) ) + PI
      ENDIF
C WORK OUT THE WIDTH OF THE ELLIPSE - THIS VARIES ACCORDING TO THE
C ELEVATION OF THE BOND.
      XPERSP = ABS ( 2.0 / PI
     c * ( ATAN2 ( V(3) , ( SQRT ( V(2)**2  + V(1)**2 ) ) ) ) )
C CALCULATE THE SIX POINTS ON THE HALF ELLIPSE SURFACE
C CHECK THE BOND TYPE
      IF (ITYPE.EQ.2) THEN
      RTHIC = RTHICK * 2.0
      RTAPE = 1.0
      ELSE
      IF (ISCRN.EQ.4) THEN
        RTHIC = RTHICK / 2.0
      ELSE
        RTHIC = RTHICK
      ENDIF
      RTAPE = RTAPER
      ENDIF
      DO 10 I = 0 , NLINES - 1
      XR1(I+1) = RTHIC * XCOS (I*NANGST+1)
      YR1(I+1) = RTHIC * XSIN (I*NANGST+1) * XPERSP
10    CONTINUE
C NOW ROTATE THESE AND ADD THESE RESULTS TO THE FINAL COORDS
      DO 20 I = 1, NLINES
       XX = XR1(I) * COS (P) + YR1(I) * SIN (P)
       YY = -XR1(I) * SIN (P) + YR1(I) * COS (P)
       XR1(I) = XX + X + X1
       YR1(I) = YY + Y + Y1
       XR2(I) = XX*RTAPE + X2
       YR2(I) = YY*RTAPE + Y2
20    CONTINUE
C Convert the coordinates into drawing coordinates
      IF (ISCRN.EQ.4) THEN
      NPOINT = 0
      DO 30 I = 1 , NLINES
        XX1(1) = XR1(I)
        XX1(2) = YR1(I)
        XX2(1) = XR2(I)
        XX2(2) = YR2(I)
        CALL ZLINEC (XX1,XX2,ICOL,IATNO,NPOINT,1,0)
30      CONTINUE
      ELSE IF ((ISCRN.EQ.1).OR.(ISCRN.EQ.5).OR.(ISCRN.EQ.6) .OR.
     + (ISCRN.EQ.7) .OR. (ISCRN.EQ.8) ) THEN
C DO THE OUTLINE OF THE BOND
      IX(1) = NINT (( XR2(1) - XCP )*SCALE)
      IY(1) = NINT (( YR2(1) - YCP )*SCALE)
      DO 40 I = 1 , 6
        IX(I+1) = NINT (( XR1(I) - XCP)*SCALE)
        IY(I+1) = NINT (( YR1(I) - YCP)*SCALE)
40      CONTINUE
      IX(8) = NINT (( XR2(6) - XCP)*SCALE)
      IY(8) = NINT (( YR2(6) - YCP)*SCALE)
      IX(9) = IX(1)
      IY(9) = IY(1)
      CALL ZDRLIN (2,IX,IY,9,IDEVCL(ICOL+1),IATNO)
      ELSE
C DO THE BONDS AS SIX LINES.
      DO 50 I = 1 , 6
        IX(1) = NINT (( XR1(I) - XCP) *SCALE)
        IY(1) = NINT (( YR1(I) - YCP )*SCALE)
        IX(2) = NINT (( XR2(I) - XCP)*SCALE)
        IY(2) = NINT (( YR2(I) - YCP)*SCALE)
        CALL ZDRLIN (1,IX,IY,2,IDEVCL(ICOL+1),IATNO)
50      CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZBDSRT
      SUBROUTINE ZBDSRT(IATNO,NBNDST,NBONDS)
C This routine sorts the bonds in order of ascending Z of the atoms to
C be bonded to.
      
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

C      INTEGER IBDORD(12,3),IORD(12,3)
       DO 10 I = 1,NBONDS
       IORD (I,1) = IBDORD(I,1)
       IORD (I,2) = IBDORD(I,2)
10      CONTINUE
C SORT IN TERMS OF Z
      DO 20 J = 1,NBONDS
      ZMIN = 100.0
      N = 0
        DO 30 L = 1,NBONDS
         IF (IORD(L,1).GT.0) THEN
            Z = RSTORE(IORD(L,1) + IXYZO + 2)
            IF (Z.LT.ZMIN) THEN
            ZMIN = Z
            N = L
            ENDIF
        ENDIF
30      CONTINUE
      IF (N.NE.0) THEN
        IBDORD(J,1) = IORD(N,1)
        IBDORD(J,2) = IORD(N,2)
        IORD(N,1) = -IORD(N,1)
      ENDIF
20    CONTINUE
      RETURN
      END
 
CODE FOR ZCENTR
      SUBROUTINE ZCENTR(MAX,MIN)
      
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

      REAL MIN(3),MAX(3)
C CALCULATE THE CENTRE
      XC = (MAX(1)+MIN(1))/2
      YC = (MAX(2)+MIN(2))/2
      ZC = (MAX(3)+MIN(3))/2
      RETURN
      END
 
CODE FOR ZCRYST [ CRYSTAL DATA INPUT ]
      SUBROUTINE ZCRYST(A,B,C,ALP,BET,GAM)
      
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

      CHARACTER*6 CELLAB (8)
      REAL CELLX(8),CELLY(8),CELLZ(8),D(3),V1(3),V(3)
      REAL ORTH(3,3),ORTHI(3,3),ELOR(3,3),ELORT(3,3)
      DATA CELLX/0.0,1.0,1.0,0.0,0.0,1.0,1.0,0.0/
      DATA CELLY/0.0,0.0,0.0,0.0,1.0,1.0,1.0,1.0/
      DATA CELLZ/0.0,0.0,1.0,1.0,0.0,0.0,1.0,1.0/
      DATA CELLAB /'0     ','a     ','      ','c     ',
     c 'b     ','     ','      ','      '/
C FOR THE TIME BEING CODE IN THE CRYSTAL DATA!
C The crystal data is stored in RSTORE at position ICRYST.
      ICRYST = IRLAST
C Convert to radians
      ALP1 = ALP * PI / 180.0
      BET1 = BET * PI / 180.0
      GAM1 = GAM * PI / 180.0
C EVENTUALLY THE ABOVE NUMBERS WILL COME FROM ANOTHER SOURCE!
C STORE THE NUMBERS
      RSTORE (ICRYST) = A
      RSTORE (ICRYST+1) = B
      RSTORE (ICRYST+2) = C
      RSTORE (ICRYST+3) = ALP
      RSTORE (ICRYST+4) = BET
      RSTORE (ICRYST+5) = GAM
C Calculate the orthogonalisation matrix.
C Ref : Computing in Crystallography ,Rollett, p23
Calculate the reciprocal lattice values
      RECIP1 = ((COS(ALP1)*COS(BET1))-COS(GAM1))/(SIN(ALP1)*SIN(BET1))
      RECIP2 = SQRT(1-(RECIP1*RECIP1))
      ORTH(1,1) = A*SIN(BET1)*RECIP2
      ORTH(1,2) = 0.0
      ORTH(1,3) = 0.0
      ORTH(2,1) = -A*SIN(BET1)*RECIP1
      ORTH(2,2) = B*SIN(ALP1)
      ORTH(2,3) = 0.0
      ORTH(3,1) = A*COS(BET1)
      ORTH(3,2) = B*COS(ALP1)
      ORTH(3,3) = C
C FIND THE INVERSE OF ORTH
       CALL ZINVER (ORTH,ORTHI)
C Calculate the orthogonalisation matrices for tensors
C These are ELOR and ELORT
C Ref : The Determination of Crystal Structures Vol 3 p302
C Lipsom and Cochran
      RN = SQRT (1.0 + 2.0*COS(ALP1)*COS(BET1)*COS(GAM1) -
     c COS(ALP1)**2 - COS(BET1)**2 - COS(GAM1)**2 )
      D(1) = SIN(ALP1)/(RN*A)
      D(2) = SIN(BET1)/(RN*B)
      D(3) = SIN(GAM1)/(RN*C)
      DO 40 I = 1,3
      DO 40 J = 1,3
      ELOR (I,J) = ORTH(I,J)*D(J)
      ELORT (J,I) = ELOR(I,J)
40    CONTINUE
C STORE THESE MATRICES IN RSTORE
      CALL ZMOVE (ORTH,RSTORE(ICRYST+6),9)
      CALL ZMOVE (ORTHI,RSTORE(ICRYST+15),9)
      CALL ZMOVE (ELOR,RSTORE(ICRYST+24),9)
      CALL ZMOVE (ELORT,RSTORE(ICRYST+33),9)
      IRLAST = ICRYST+42
      IMTFLG = 0
C WORK OUT THE CELL COORDINATES.
      ISINIT = IRLAST
      DO 10 I = 1,8
      RSTORE (ISINIT+(I-1)*IPACKT) = 5.0
      RSTORE (ISINIT+1+(I-1)*IPACKT) = CELLX(I)
      RSTORE (ISINIT+2+(I-1)*IPACKT) = CELLY(I)
      RSTORE (ISINIT+3+(I-1)*IPACKT) = CELLZ(I)
      RSTORE (ISINIT+IPCK+1+(I-1)*IPACKT) = -1.0
      RSTORE (ISINIT+IATTYP+2+(I-1)*IPACKT) = 1.0
      CSTORE (ICLAST+I-1) = CELLAB(I)
10    CONTINUE
      DO 4 I = 1,3
      CALL ZZEROF (V,3)
      V(I) = 1.0
      CALL ZMATV (ORTH,V,V1)
      D000(I) = V1(I)
4     CONTINUE
      IRLAST = IRLAST + IPACKT*8
      ICLAST = ICLAST + 8
      RETURN
      END
 
CODE FOR ZBONDS
      SUBROUTINE ZBONDS(IATNO,NLINES,NANGST)
C THIS ROUTINE DRAWS THE BONDS BETWEEN THE ATOMS
C It also draws the circle if we are in solid mode.
C We need to draw bonds between atoms with the same Z coordinate first.
      
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

      INTEGER IX(5),IY(5),IBCOL
      ICIRC = 0
      ICCCOL = 8
      CALL ZZEROI (IBDORD,NBDMAX*3)
C CHECK FOR RING ATOMS
      IF (NINT(RSTORE(IATNO)).EQ.6) THEN
      CALL ZVAND (IATNO)
      RETURN
      ENDIF
C GET THE COORDS
      IDRAW1 = NINT(RSTORE(IATNO+IPCK+1))
      IF (IDRAW1.LT.0) THEN
      RETURN
      ENDIF
      X1 = RSTORE(IATNO+IXYZO)
      Y1 = RSTORE(IATNO+IXYZO+1)
      Z1 = RSTORE(IATNO+IXYZO+2)
      IX(1) = NINT( ( X1 - XCP ) * SCALE )
      IY(1) = NINT( ( Y1 - YCP ) * SCALE )
C SORT BONDING ATOMS IN Z - UNLESS WE ARE DOING FAST DRAWING OR CELL.
C GET NUMBER OF BONDS AND STARTING POSITION
      NBONDS = NINT(RSTORE(IATNO+IBOND+1))
      NBNDST = NINT(RSTORE(IATNO+IBOND))
      DO 13 I = 1,NBONDS
      IBDORD (I,1) = NINT(RSTORE(NBNDST-(I-1)*2))
      IBDORD (I,2) = NINT(RSTORE(NBNDST-(I-1)*2-1))
13    CONTINUE
      IF ((ICURS.EQ.0).AND.(IATNO.GE.IRATOM)) THEN
      CALL ZBDSRT (IATNO,NBNDST,NBONDS)
      ENDIF
C NNBND IS USED AS A FLAG TO SEE IF ANY BONDS HAVE BEEN DRAWN FOR THIS
C ATOM
       NNBND = 0
       DO 11 I = 1,NBONDS
C UN PACK THE BOND INFO
C ATOM NUMBER
         IB = IBDORD(I,2)
C COLOUR
         IBDORD (I,2) = IB/10
C STYLE
         IBDORD (I,3) = MOD (IB,10)
11       CONTINUE
C LOOP OVER THE CONNECTIVITY
      DO 10 I = 1,NBONDS
      IATNO1 = IBDORD(I,1)
      IBCOL = IBDORD(I,2)
      ISTYL  = IBDORD(I,3)
      IF (IATNO1.GT.0) THEN
C GET COORDS
        IDRAW2 = NINT(RSTORE(IATNO1+IPCK+1))
        IF (IDRAW2.LT.0) GOTO 111
        NNBND = 1
        X2 = RSTORE(IATNO1 + IXYZO)
        Y2 = RSTORE(IATNO1 + IXYZO + 1)
        Z2 = RSTORE(IATNO1 + IXYZO + 2)
        IX(2) = NINT ((X2-XCP)*SCALE)
        IY(2) = NINT ((Y2-YCP)*SCALE)
C DON'T DRAW BOND IF ATOM 2 IS BEHIND ATOM 1
C OR IF ATOM ALREADY DRAWN!
        IF ((Z2.LT.Z1).OR.RSTORE(IATNO1).LT.0) GOTO 111
C Single line drawing is used for LINE,CURSOR. and cell axes.
        IF ((ICURS.EQ.1).OR.
     c    (NINT(RSTORE(IATNO)).EQ.1).OR.(NINT(RSTORE(IATNO)).EQ.5)) THEN
           CALL ZDRBND(ISTYL,IX,IY,2,IBCOL,IATNO,IATNO1,1)
          GOTO 111
        ELSE IF (ICURS.EQ.2) THEN
          CALL ZDRBND(ISTYL,IX,IY,2,IBACK,IATNO,0,0)
          GOTO 111
        ENDIF
C IF WE HAVE PASSED REGION WHERE Z1=Z2 IS POSSIBLE, DRAW THE CIRCLE.
        IF ((Z2-Z1.GT.0.0005).AND.((NINT(RSTORE(IATNO)).EQ.2).OR.
     c (NINT(RSTORE(IATNO)).EQ.3))
     c      .AND.(ICIRC.EQ.0)) THEN
          CALL ZSOLID(IATNO)
          IF (NINT(RSTORE(IATNO)).EQ.2) CALL ZCIRCL(IATNO,2)
          ICIRC = 1
        ENDIF
C GET THE EIGENVALUES OR RADII FOR THE BOND DRAWING ROUTINE
        IF (NINT(RSTORE(IATNO)).EQ.3) THEN
C Get the eigenvalues.
          A = RSTORE(IATNO+IXYZO+12)
          IF (A.LT.0.0) THEN
C UISO ATOM
            A = -A
            B = A
            C = A
          ELSE
            B = RSTORE(IATNO+IXYZO+13)
            C = RSTORE(IATNO+IXYZO+14)
          ENDIF
        ELSE IF (NINT(RSTORE(IATNO)).EQ.6) THEN
          A = 0.0
          B = 0.0
          C = 0.0
        ELSE
          A = RSTORE(IATNO+IATTYP+4)**2
          B = A
          C = A
        ENDIF
        IF (((SCALE.LT.SCLLIM).OR.(NINT(RSTORE(IATNO1)).EQ.1)).AND.
     +  (NINT(RSTORE(IATNO)).NE.6) ) THEN
          CALL ZCALBD (X1,Y1,X2,Y2,Z1,Z2,A,B,C,IBCOL,ISTYL,IATNO,1
     +      ,NLINES,NANGST)
        ELSE IF (NINT(RSTORE(IATNO)).EQ.6) THEN
          CALL ZCALBD (X1,Y1,X2,Y2,Z1,Z2,A,B,C,IBCOL,ISTYL,IATNO,2,
     +      NLINES,NANGST)
        ELSE
          CALL ZCALBD (X1,Y1,X2,Y2,Z1,Z2,A,B,C,IBCOL,ISTYL,IATNO,0,
     +      NLINES,NANGST)
        ENDIF
      ENDIF
111   CONTINUE
10    CONTINUE
      IF (ICURS.EQ.0) THEN
      IF (((NINT(RSTORE(IATNO)).EQ.2).OR.(NINT(RSTORE(IATNO)).EQ.3))
     c .AND.(ICIRC.EQ.0)) THEN
        CALL ZSOLID(IATNO)
        IF (NINT(RSTORE(IATNO)).EQ.2) CALL ZCIRCL (IATNO,2)
      ENDIF
      ENDIF
C CROSSES ARE USED TO REPRESENT ISOLATED ATOMS IN LINE MODE
C EVEN DURING CURSOR ROTATION OTHERWISE THEY CANT BE SEEN.
C THE SAME APPLIES FOR DUMMY ATOMS
      IF (NNBND.EQ.0) THEN
      IF ((NINT(RSTORE(IATNO)).EQ.1).OR.(ICURS.NE.0).OR.
     c (NINT(RSTORE(IATNO)).EQ.4)) THEN
        CALL ZCROSS (IATNO)
      ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZDOPLN [ DO PLANE ]
      SUBROUTINE ZDOPLN (NN,ITYPE)
      
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

      REAL VECTOR(3,3),CENT(3),WORK1(3,3),ROOTS(3),COSINE(3,3),
     c WORK(4),ORTH(3,3)
C ITYPE = 1 MEANS VIEW ONTO BOND/PLANE
C ITYPE = 2 MEANS VIEW ALONG BOND
C This routine computes the rotation matrix onto the plane
C the coords that define the plane have been set up previously.
C N is the number of atoms defining the plane.
C Note that we don't check the return value of P as it is not
C - not quite. PLANE ALL if only one atom!
C possible to call this routine without having at least 2 atoms.
C A NEGATIVE VALUE OF N MEANS THAT THE FINAL CHECK IS NOT DONE
      N = ABS(NN)
C>DJW
      IP = LMOLAX (RSTORE(IRLAST),N,4,CENT,ROOTS,VECTOR,COSINE,WORK)
      IF (IP .EQ. -1) THEN
        CALL ZZEROF (VECTOR, 9)
        VECTOR(1,1) =1.
        VECTOR(2,2) =1.
        VECTOR(3,3) =1.
      ENDIF      
C<DJW
C NOW MULTIPLY THIS ONTO THE COORDS.
      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
      CALL ZMLTMM (VECTOR,ORTH,WORK1,3,3,3)
      CALL ZPTMAT (WORK1,MAT1)
      IF (ITYPE.EQ.2) THEN
C THIS VIEWS ONTO THE BOND, ROTATE BY PI/2 TO GET TO ALONG
      CALL ZROT (PI*0.5,2)
      CALL ZATMUL(0,0,0)
      IF (NN.GT.0) THEN
C CHECK THE FIRST ONE IS IN THE FRONT
        N1 = ISINIT + (ICCMMD(ICCNT) - ICATOM)*IPACKT
        N2 = ISINIT + (ICCMMD(ICCNT+1) - ICATOM)*IPACKT
        IF (RSTORE(N1+IXYZO+2).LT.RSTORE(N2+IXYZO+2)) THEN
          CALL ZROT (PI,2)
          CALL ZATMUL(0,0,0)
        ENDIF
      ENDIF
      ELSE
      CALL ZATMUL(0,0,0)
      ENDIF
      RETURN
      END
 
CODE FOR ZVIMAT [ VIEW MATRIX CALCULATION ]
      SUBROUTINE ZVIMAT
      
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

      REAL ORTH(3,3)
C This routine calculates the view matrix from the orthogonal matrix
C which is held in RSTORE at ICRYST and the rotation matrix ROT
C IMTFLG is set to 1 once the orthogonal matrix has been applied
C Need to multiply the orth. matrix by [a b c]
C Note that the matrices are 4x4 so that homogenous coords can be used.
      IF (IMTFLG.EQ.0) THEN
C GET THE ORTHOGONALISATION MATRIX
      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
      DO 10 I = 1,3
        DO 20 J = 1,3
      MAT1(I,J) = ORTH(I,J)
20      CONTINUE
10      CONTINUE
      MAT1(4,1) = 0.0
      MAT1(4,2) = 0.0
      MAT1(4,3) = 0.0
      MAT1(4,4) = 1.0
      MAT1(1,4) = 0.0
      MAT1(2,4) = 0.0
      MAT1(3,4) = 0.0
      IMTFLG = 1
C Transform the centre of rotation.
      XC = MAT1(1,1)*XC + MAT1(2,1)*YC + MAT1(3,1)*ZC
      YC = MAT1(1,2)*XC + MAT1(2,2)*YC + MAT1(3,2)*ZC
      ZC = MAT1(1,3)*XC + MAT1(2,3)*YC + MAT1(3,3)*ZC
      ENDIF
C MULTIPLY BY THE ROTATION MATRIX
      CALL ZMATM4 (ROT,MAT1)
      RETURN
      END
 
 
CODE FOR ZFRAG
      SUBROUTINE ZFRAG (I,IPOS,VAL,ITYPE)
C This subroutine allows the user to refer to groups of atoms as
C fragments. The required parameter alteration - position IPOS new value
C VAL is applied to all atoms attached to I. These atoms are found by
C doing a connectivity check.
C ITYPE = 1 normal substitution
C ITYPE = 2 group definition
      
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

      IS = IRLAST
      ISPOS = IS
      RSTORE(IS) = I
10    CONTINUE
C LOOP OVER THE CONNECTIVITY OF ATOM AT IS
      J = NINT(RSTORE(IS))
      NBNDST = NINT(RSTORE(J+IBOND))
      NBONDS = NINT(RSTORE(J+IBOND+1))
      DO 20 K = NBNDST , NBNDST - (NBONDS-1)*2 , -2
      L = NINT(RSTORE(K))
      IF (L.EQ.0) GOTO 20
C NOW WE HAVE A NEW ATOM - CHECK TO SEE IF IT HAS BEEN FOUND BEFORE
      DO 30 M = IRLAST, ISPOS
        IF (NINT(RSTORE(M)).EQ.L) GOTO 20
30      CONTINUE
C OTHERWISE STORE IT
      RSTORE(ISPOS+1) = L
      ISPOS = ISPOS + 1
20    CONTINUE
      IF (ISPOS.NE.IS) THEN
      IS = IS + 1
      GOTO 10
      ENDIF
C NOW ALTER ALL THE ATOMS WE HAVE FOUND
      IF (ITYPE.EQ.1) THEN
      DO 40 J = IRLAST , IS
        K = NINT(RSTORE(J))
        RSTORE(K+IPOS) = VAL
40      CONTINUE
      ELSE
C FRAGMENT GROUP DEFINITION
      DO 50 J = IRLAST, IS
        K = NINT(RSTORE(J))
C CHECK FOR VACANT POSITION IN GROUP INFO
        DO 60 L = K+IATTYP+6, K+IATTYP+9
          IF (NINT(RSTORE(L)).EQ.0) THEN
            RSTORE(L) = VAL
            GOTO 70
          ENDIF
          IF (NINT(RSTORE(L)).EQ.IGG) THEN
C DON'T DUPLICATE GROUP NUMBERS
            GOTO 70
          ENDIF
60        CONTINUE
70        CONTINUE
50      CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZBNDCK [ BOND CHECK AND UPDATE ]
      SUBROUTINE ZBNDCK (N,IMULTN,M,IMULTM,ISET,INUMB,IJN,ITYPE)
C This routine is used to check and update the bond colour/style
C information.
C All bonds from N to M (whether atoms or elements) and vice versa
C are set to ISET.
C INUMB = 1 colour
C INUMB = 2 bond style
C The routine returns IJN = 0 no bond found
C IJN = 1 successful join. These only apply to atom-atom joins.
C ITYPE = 0 atoms are referred to by their CSTORE position
C       = 1 atoms are referred to by their RSTORE position
C       = -1 atoms are referred to by their CSTORE position, delete
C bonds.
      
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

      IJN=0
C We need to generate two lists of atoms. IRLAST -> IRLAST+INAT1
C , IRLAST+ INAT1+1 -> IRLAST+INAT1+INAT2.
C The bond calculation is then carried out between all atoms
C in this list.
      INAT1 = 0
      INAT2 = 0
      L = N
      IMULT = IMULTN
      INATOM = 0
10    CONTINUE
C IS THIS AN ATOM OR AN ELEMENT?
      IF ((ITYPE.NE.1).AND.(L.GE.ICATOM)
     c .OR.(ITYPE.EQ.1).AND.(L.GE.IRATOM)) THEN
C N AND M MUST BE IN TERMS OF RSTORE
      IF (ITYPE.NE.1) THEN
        L = (L - ICATOM) * IPACKT + IRATOM
      ENDIF
C CHECK THE MULTIPLICITY
      IF (IMULT.EQ.0) THEN
        RSTORE(IRLAST+INAT1+INATOM) = L
        INATOM = INATOM + 1
      ELSE
C NEED TO GET THE OTHER ATOMS
        IPPACK = 0
        LC = (L-IRATOM)/IPACKT + ICATOM
20        CONTINUE
        CALL ZGTATM ( LC , IPPACK , IPOS )
        IPPACK = IPPACK + 1
        IF (IPOS.GT.0) THEN
C STORE THE ATOM
          RSTORE(IRLAST+INAT1+INATOM) = IPOS
          INATOM = INATOM + 1
        ENDIF
        IF (IPPACK.LE.IPACK) GOTO 20
      ENDIF
      ELSE IF (L.EQ.-1) THEN
C *
      DO 25 I = ISVIEW+IPACKT*8 , IFVIEW-1, IPACKT
        RSTORE(IRLAST+INATOM+INAT1) = I
        INATOM = INATOM + 1
25      CONTINUE
      ELSE IF (L.EQ.0) THEN
C CHECK FOR *_n
      DO 24 I = ISVIEW , IFVIEW-1 ,IPACKT
        IF (NINT(RSTORE(I+IPCK)).NE.IMULT-1) GOTO 24
        RSTORE(IRLAST+INATOM+INAT1) = I
        INATOM = INATOM + 1
24      CONTINUE
      ELSE
C THIS IS AN ELEMENT
      L = L - ICELM + 1
C LOOP OVER THE ATOMS TO CREATE THE LIST
      DO 30 I = ISVIEW , IFVIEW-1 , IPACKT
        IF (NINT(RSTORE(I+IATTYP)).EQ.L) THEN
          IF (IMULT.NE.0) THEN
C NEED TO CHECK THE PACK NUMBER
            IF (NINT(RSTORE(I+IPCK)).NE.IMULT-1) GOTO 30
          ENDIF
          RSTORE(IRLAST+INAT1+INATOM) = I
          INATOM = INATOM + 1
        ENDIF
30      CONTINUE
      ENDIF
      IF (INAT1.EQ.0) THEN
      INAT1 = INATOM
      INATOM = 0
      L = M
      IMULT = IMULTM
      GOTO 10
      ENDIF
      INAT2 = INATOM - 1
C NOW WE CAN LOOP OVER THE LISTS
      DO 40 I = IRLAST , IRLAST + INAT1 - 1
      NAT = NINT(RSTORE(I))
C LOOP OVER THE ATOMS STORAGE
      NBNDST = NINT(RSTORE(NAT+IBOND))
      NBONDS = NINT(RSTORE(NAT+IBOND+1))
      DO 50 J = NBNDST , NBNDST-(NBONDS-1)*2 , -2
        K = NINT(RSTORE(J))
C LOOP OVER THE ATOMS IN THE OTHER LIST
        DO 60 L = IRLAST + INAT1 , IRLAST+INAT1+INAT2
          IF (NINT(RSTORE(L)).NE.K) GOTO 60
C WE HAVE FOUND A BOND.
          IF (ITYPE.EQ.-1) THEN
C REMOVE THE BOND
            RSTORE(J) = 0.0
            RSTORE(J-1) = 0.0
          ELSE
C ALTER THE BONDS CHARACTERISTICS
            NUM = NINT(RSTORE(J-1))
            CALL ZBNUM ( NUM , INUMB , ISET )
            RSTORE(J-1) = NUM
          ENDIF
C FLAG THE FACT THAT A BOND HAS BEEN FOUND
          IJN = 1
C NEED TO GET THE BOND FROM THE OTHER END
          NBND = NINT ( RSTORE ( NINT ( RSTORE ( L )) + IBOND ))
          NBNDS = NINT ( RSTORE ( NINT ( RSTORE(L)) + IBOND + 1 ))
          DO 70 M = NBND , NBND - (NBNDS-1)*2 , -2
            IF (NINT(RSTORE(M)).NE.NAT) GOTO 70
            IF (ITYPE.EQ.-1) THEN
            RSTORE(M) = 0.0
            RSTORE(M-1) = 0.0
            ELSE
            NUM = RSTORE(M-1)
            CALL ZBNUM ( NUM , INUMB , ISET )
            RSTORE(M-1) = NUM
            ENDIF
            GOTO 80
70          CONTINUE
80          CONTINUE
60        CONTINUE
50      CONTINUE
40    CONTINUE
      RETURN
      END
C
CODE FOR ZPSTCK [ PLOT STACK ]
      SUBROUTINE ZPSTCK ( ZVAL , IPPOS )
C THIS ROUTINE CALCULATES THE PLOT STACK WHICH IS THEN USED
C FOR THE XDOVI ROUTINE.
C WE NEED TO MOVE DOWN THE CURRENT STACK UNTIL WE REACH A POINT WHERE
C THE VALUE EXCEEDS THE ONE IN ZVAL . WE THEN UPDATE THE STACK
C POINTERS.
      
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

      INTEGER IPPOS
      INTEGER ILAST
C IS THIS THE FIRST ENTRY?
      IF (IPPOS.EQ.0) THEN
      ISTACK(1) = 2
      ZSTACK(1) = 0.0
      ISTACK(2) = -1
      ZSTACK(2) = ZVAL
      IPPOS = 2
      RETURN
      ENDIF
C LOOP DOWN THE STACK
      IPOS = ISTACK(1)
      ILAST = 1
10    CONTINUE
      IF (ZVAL.GT.ZSTACK(IPOS)) THEN
      IF (ISTACK(IPOS).NE.-1) THEN
        ILAST = IPOS
        IPOS = ISTACK(IPOS)
        GOTO 10
      ELSE
C WE HAVE REACHED THE END OF THE LINE
        ISTACK(IPOS) = IPPOS+1
        ISTACK(IPPOS+1) = -1
        ZSTACK(IPPOS+1) = ZVAL
        IPPOS = IPPOS + 1
        RETURN
      ENDIF
      ELSE
C WE HAVE FOUND THE LOCATION OF THIS ATOM IN THE STACK
      ISTACK(ILAST) = IPPOS+1
      ISTACK(IPPOS+1) = IPOS
      ZSTACK(IPPOS+1) = ZVAL
      IPPOS = IPPOS + 1
      RETURN
      ENDIF
      END
CODE FOR ZSYMPK
      SUBROUTINE ZSYMPK(IPKNO, OPER, TRANS,CLINE)
C---- CONVERT PACKING OPERATORS 20 SYMBOLIC FORM
      DIMENSION OPER(4,4), TRANS(3)
      DIMENSION OPER3(3,4)
      CHARACTER *(*) CLINE
C      OPER 4X4 MATRIX OF OPERATOR
C      TRANS TRANSLATION/CENTRING VECTOR
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
        DO 2, I = 1,3
         DO 1, J=1,3
           OPER3(J,I)=OPER(I,J)
1        CONTINUE
         OPER3(I,4) = OPER(I,4)
2       CONTINUE  
        CALL XSUMOP(OPER3, TRANS, CLINE, LEN, 1)
        RETURN
      END

CODE FOR ZPRTPK
      SUBROUTINE ZPRTPK(IPKNO, OPER, TRANS)
C---- PRINT OUT PACKING OPERATORS IN SYMBOLIC FORM
      DIMENSION OPER(4,4), TRANS(3)
      DIMENSION OPER3(3,4)
      CHARACTER *80 CLINE
C      OPER 4X4 MATRIX OF OPERATOR
C      TRANS TRANSLATION/CENTRING VECTOR
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      CALL ZSYMPK (IPKNO, OPER, TRANS,CLINE)
      IF (ISSPRT.GE.0) THEN
        WRITE (NCWU,'(A, I4, 4X,A)') 'CAMERON packing Operator ', 
     1  IPKNO-1, CLINE(1:)
      ENDIF
      RETURN
      END

