CODE FOR CHINIT
      SUBROUTINE CHINIT(N,M,IR,IG,IB)
\XCHTAP
\XUNITS
\XIOBUF
            NCHART = N
            MCHART = M
            IBGRED = IR
            IBGGRE = IG
            IBGBLU = IB
            WRITE ( CMON, '(A)')'^^CH NEWCHART ANISO ^^EN'
            CALL XPRVDU(NCVDU, 1,0)
            RETURN
      END
C
C
CODE FOR CHPLOT
      SUBROUTINE CHPLOT(IREGX,IREGY,X,Y,CLAB,IEND,IR,IG,IB,LLAB,
     1                                LJOIN,N,M,CXAX,CYAX,CTITL)
\XCHTAP
\XUNITS
\XIOBUF
      INTEGER*4 IREGX,IREGY          !The chart region to draw to.
      REAL*4 X(N,M), Y(N,M)          !The data in M series.
      INTEGER*4 IEND(M)              !The end of the data in each series
      CHARACTER*10 CLAB(N,M)         !Labels in M series.
      INTEGER*4 IR(M), IG(M), IB(M)  !Series colours
      INTEGER*4 LLAB(M), LJOIN(M)    !Series label and style flags
      INTEGER*4 N,M                  !The size of the data
      CHARACTER*32 CXAX,CYAX,CTITL   !Labelling
      INTEGER*4 X1,X2,Y1,Y2
      INTEGER*4 XAXISY, XAXISX1, XAXISX2
      INTEGER*4 YAXISX, YAXISY1, YAXISY2
      INTEGER*4 XLABX,XLABY, YLABX,YLABY, TLABX,TLABY
C
C
C Get coords for this chart region.
C
      X1 = (10000/NCHART) * (IREGX-1)
      X2 = (10000/NCHART) * IREGX
      Y1 = (10000/MCHART) * (IREGY-1)
      Y2 = (10000/MCHART) * IREGY
C
C Calculate where the axes should be.
C
      XAXISY = Y2 - 0.1*(Y2-Y1)
      XAXISX1= X1 + 0.1*(X2-X1)
      XAXISX2= X2 - 0.1*(X2-X1)
C
      YAXISX = X1 + 0.1*(X2-X1)
      YAXISY1= Y1 + 0.1*(Y2-Y1)
      YAXISY2= Y2 - 0.1*(Y2-Y1)
C
C      WRITE(NCAWU,'(A,I6)')'N = ',N
C      WRITE(NCAWU,'(A,I6)')'M = ',M
C      WRITE(NCAWU,'(A,I6)')'IEND(1) = ',IEND(1)
C      WRITE(NCAWU,'(A,I6)')'IEND(2) = ',IEND(2)
C
C
C Draw the axes.
C
      WRITE ( CMON, '(A)')'^^CH PENCOLOUR 0 0 0 ^^EN'
      CALL XPRVDU(NCVDU, 1,0)
      WRITE ( CMON, '(A,4I6,A)')'^^CHLINE', XAXISX1, XAXISY,
     1 XAXISX2, XAXISY, '^^EN'
      CALL XPRVDU(NCVDU, 1,0)
      WRITE ( CMON, '(A,4I6,A)')'^^CHLINE', YAXISX, YAXISY1,
     1 YAXISX, YAXISY2, '^^EN'
      CALL XPRVDU(NCVDU, 1,0)
C
C Label the chart.
      XLABX = XAXISX1+(X2-X1)/3
      XLABY = XAXISY -(Y2-Y1)/20
      YLABX = YAXISX -(X2-X1)/10
      YLABY = YAXISY1+(Y2-Y1)/10
      TLABX = X1+(X2-X1)/3
      TLABY = Y1+(Y2-Y1)/20
C
C
      WRITE (CMON,'(A,2I6,1X,2A)') '^^CHTEXT',XLABX,XLABY,CXAX,'^^EN'
      CALL XPRVDU(NCVDU, 1,0)
      WRITE (CMON,'(A,2I6,1X,2A)') '^^CHTEXT',YLABX,YLABY,CYAX,'^^EN'
      CALL XPRVDU(NCVDU, 1,0)
      WRITE (CMON,'(A,2I6,1X,2A)') '^^CHTEXT',TLABX,TLABY,CTITL,'^^EN'
      CALL XPRVDU(NCVDU, 1,0)
C
C
C Find min and max X and Y data.
C
      XMAX = -100000.
      YMAX = -100000.
      XMIN = 100000.
      YMIN = 100000.
C
      DO 100 ISER = 1,M
         DO 90 IDAT = 1,IEND(ISER)
            XMAX = MAX ( XMAX, X(IDAT,ISER) )
            XMIN = MIN ( XMIN, X(IDAT,ISER) )
C            WRITE(NCAWU,'(A,F15.2,A)')'^^TXX=',X(IDAT,ISER),'^^EN'
C            IF(ISER.EQ.1)
C     1      WRITE(NCAWU,'(3(A,F15.2),A,I4,A)')
C     1                               '^^TX X=',X(IDAT,ISER),
C     2                               ' Y(1)=',Y(IDAT,1),
C     3                               ' Y(2)=',Y(IDAT,2),
C     4                               ' IDAT=',IDAT,'^^EN'
            YMAX = MAX ( YMAX, Y(IDAT,ISER) )
            YMIN = MIN ( YMIN, Y(IDAT,ISER) )
90       CONTINUE
100   CONTINUE
C
C Work out scaling for axes
C
      XRANGE = XMAX - XMIN
      YRANGE = YMAX - YMIN
C
      XMIN = XMIN - XRANGE/10
      YMIN = YMIN - YRANGE/10
      XMAX = XMAX + XRANGE/10
      YMAX = YMAX + YRANGE/10
C
      DO 120 ISER = 1,M
            WRITE ( CMON, '(A,3I4,A)')    '^^CH PENCOLOUR ',
     1      IR(ISER),IG(ISER),IB(ISER),'^^EN'
            CALL XPRVDU(NCVDU, 1,0)
            IF (LJOIN(ISER).EQ.0) THEN
                  DO 110 IDAT = 1,IEND(ISER)
                        IXOUT = XAXISX1+ (XAXISX2-XAXISX1)
     1                  *(X(IDAT,ISER)-XMIN)/MAX(0.01,(XMAX-XMIN))
                        IYOUT = YAXISY2- (YAXISY2-YAXISY1)
     1                  *(Y(IDAT,ISER)-YMIN)/MAX(0.01,(YMAX-YMIN))
                        WRITE ( CMON, '(A,4I6,A)')'^^CH FCIRCLE',
     1                  IXOUT-30,IYOUT-30,IXOUT+30,IYOUT+30,'^^EN'
                        CALL XPRVDU(NCVDU, 1,0)
110               CONTINUE
            ELSEIF(LJOIN(ISER).EQ.1) THEN
                  IOXOUT = -1
                  IOYOUT = -1
                  DO 115 IDAT = 1,IEND(ISER)
C            WRITE(NCAWU,'(A)')'Entered loop'
C            WRITE(NCAWU,'(A,I4)')'XAXISX1 = ',XAXISX1
C            WRITE(NCAWU,'(A,I4)')'XAXISX2 = ',XAXISX2
C            WRITE(NCAWU,'(A,I4)')'IDAT = ',IDAT
C            WRITE(NCAWU,'(A,I4)')'ISER = ',ISER
C            WRITE(NCAWU,'(A,F12.3)')'X(IDAT,ISER) = ',X(IDAT,ISER)
C            WRITE(NCAWU,'(A,F12.3)')'XMIN = ',XMIN
C            WRITE(NCAWU,'(A,F12.3)')'XMAX = ',XMAX
                        IXOUT = XAXISX1+ (XAXISX2-XAXISX1)
     1                  *(X(IDAT,ISER)-XMIN)/MAX(0.01,(XMAX-XMIN))
C            WRITE(NCAWU,'(A)')'Calced points'
                        IYOUT = YAXISY2- (YAXISY2-YAXISY1)
     1                  *(Y(IDAT,ISER)-YMIN)/MAX(0.01,(YMAX-YMIN))
C            WRITE(NCAWU,'(A)')'Calced points2'
                        IF(IOXOUT.GT.0) THEN
                              WRITE ( CMON, '(A,4I6,A)')'^^CH LINE',
     1                        IOXOUT,IOYOUT,IXOUT,IYOUT,'^^EN'
                              CALL XPRVDU(NCVDU, 1,0)
                        ENDIF
                        IOXOUT = IXOUT
                        IOYOUT = IYOUT
115               CONTINUE
            ENDIF
120   CONTINUE
C
      WRITE ( CMON, '(A)')'^^CHUPDATE^^EN'
      CALL XPRVDU(NCVDU, 1,0)
C
      RETURN
      END
C
CODE FOR CHANAL
      SUBROUTINE CHANAL(IR, N, IFO, IFC, delsq, wdelsq, R, RW)
C
      COMMON /CHDATA/ X, YFOFC, YDELS, YRS, NSOFAR, NUMS
      REAL X(100,2),YFOFC(100,2),YDELS(100,2),YRS(100,2),NUMS(100)
      REAL IR, IFO, IFC
      INTEGER IRD(2), IGR(2), IBL(2),LLAB(2),LJOIN(2),IEND(2)
      CHARACTER*10 CLAB(100,2)
      CHARACTER*32 CXAX,CYAX,CTITL   !Labelling
\XUNITS
\XIOBUF
      IF((IR.EQ.0.).AND.(N.EQ.0).AND.(IFO.EQ.0.).AND.(R.EQ.0.))THEN
C Update the chart
         IRD(1) = 255
         IGR(1) = 0
         IBL(1) = 0
         IRD(2) = 0
         IGR(2) = 0
         IBL(2) = 255
         LLAB(1) = 0
         LLAB(2) = 0
         LJOIN(1)= 1
         LJOIN(2)= 1
         IEND(1) = NSOFAR
         IEND(2) = NSOFAR
C
         CALL CHINIT(2,2,255,255,255)
C
         CXAX = 'Sqrt Range'
         CYAX = 'FO, FC'
         CTITL = 'Fo and Fc'
         CALL CHPLOT(1,1,X,YFOFC,CLAB,IEND,IRD,IGR,IBL,LLAB,LJOIN,
     1   100,2,CXAX,CYAX,CTITL)
C      SUBROUTINE CHPLOT(IREGX,IREGY,X,Y,CLAB,IEND,IR,IG,IB,LLAB,
C     1                                LJOIN,N,M,CXAX,CYAX,CTITL)
C
         CXAX = 'Sqrt Range'
         CYAX = 'delsq, wdelsq'
         CTITL = 'delsquared'
         CALL CHPLOT(1,2,X,YDELS,CLAB,IEND,IRD,IGR,IBL,LLAB,LJOIN,
     1   100,2,CXAX,CYAX,CTITL)
C
         CXAX = 'Sqrt Range'
         CYAX = 'R, Rw'
         CTITL = 'R and weighted R'
         CALL CHPLOT(2,1,X,YRS,CLAB,IEND,IRD,IGR,IBL,LLAB,LJOIN,
     1   100,2,CXAX,CYAX,CTITL)
C
         CXAX = 'Sqrt Range'
         CYAX = 'n'
         CTITL = 'Number of reflections'
         LJOIN(1) = 0
         CALL CHPLOT(2,2,X,NUMS,CLAB,IEND,IRD,IGR,IBL,LLAB,LJOIN,
     1   100,1,CXAX,CYAX,CTITL)
C
         NSOFAR = 0
C
      ELSE
         IF (N.EQ.0) RETURN
C
         NSOFAR = NSOFAR+1
         X(NSOFAR,1) = SQRT(IR)
         X(NSOFAR,2) = X(NSOFAR,1)
         YFOFC(NSOFAR,1) = IFO
         YFOFC(NSOFAR,2) = IFC
C         WRITE(NCAWU,'(A,2I7,2F18.3,A)')'^^TX',IFO,IFC,
C     1           YFOFC(NSOFAR,1),YFOFC(NSOFAR,2),'^^EN'
         YDELS(NSOFAR,1) = LOG(MAX(0.00000001,DELSQ))
         YDELS(NSOFAR,2) = LOG(MAX(0.00000001,WDELSQ))
         YRS  (NSOFAR,1) = R
         YRS  (NSOFAR,2) = RW
         NUMS(NSOFAR) = N
      ENDIF
      RETURN
      END
C
CODE FOR GUI
      SUBROUTINE GUI(CLINE)
C Handle the commands from the GUI, and from the SCRIPTS.
\STORE
\ISTORE
\XUNITS
\XIOBUF
\XLST01
\XLST05
\XCONST
C
      CHARACTER*512 CUSTOR
      CHARACTER*80 CLINE
\GUISAV
\XGUIOV
\QSTORE
C
      CALL XCTRIM (CLINE,ILEN)
C
C If this line is continued store it and process later.
      IF(CLINE(ILEN-2:ILEN-1).EQ.'++') THEN
            CSTORE(PSTORE:PSTORE+ILEN-3) = CLINE(1:ILEN-3)
            PSTORE = PSTORE + ILEN - 3
            WRITE ( CMON, '(A)')'Storing data'
            CALL XPRVDU(NCVDU, 1,0)
            RETURN
      ELSE
            CSTORE(PSTORE:PSTORE+ILEN) = CLINE(1:ILEN)
            PSTORE = PSTORE + ILEN
            WRITE ( CMON, '(A)') CLINE(ILEN-2:ILEN-1)
            CALL XPRVDU(NCVDU, 1,0)
            WRITE ( CMON, '(A)')'Processing data'
            CALL XPRVDU(NCVDU, 1,0)
            CALL XCCUPC ( CSTORE, CUSTOR )
      ENDIF
C
C Branch on the type of operation
C
      IF(CUSTOR(1:5).EQ.'LOAD1') THEN
            WRITE ( CMON, '(A)')'^^TX Calling XFAL01^^EN'
            CALL XPRVDU(NCVDU, 1,0)
            CALL XFAL01
      ELSE IF (CUSTOR(1:5).EQ.'LOAD5') THEN
            WRITE ( CMON, '(A)')'^^TX Calling XFAL05^^EN'
            CALL XPRVDU(NCVDU, 1,0)
            LUPDAT = .TRUE.
            CALL XFAL05
      ELSE IF (CUSTOR(1:4).EQ.'MENU') THEN
C For now just copy the rest of the line to the menu channel.
C It would be nice to integrate the commands with script commands.
            WRITE ( CMON, '(3A)')'^^MN',CSTORE(6:PSTORE),'^^EN'
            CALL XPRVDU(NCVDU, 1,0)
      ELSE IF (CUSTOR(1:10).EQ.'NOGRUPDATE') THEN
            LUPDAT = .FALSE.
      ENDIF
C
      PSTORE = 1
      CSTORE = ' '
      CLINE = ' '
      RETURN
      END
C
CODE FOR GUIBLK
      BLOCK DATA GUIBLK
\GUISAV
\XGUIOV
      DATA PSTORE /1/
      DATA ISERIA/0/, NATINF/0/
      DATA LGUIL1/.FALSE./, LGUIL5/.FALSE./,
     1 LUPDAT/.FALSE./, QSINL5/.FALSE./
      END
C
C
CODE FOR MENUUP (Updates the flags for the menus)
      SUBROUTINE MENUUP
\XUNITS
\XIOBUF
C
      INTEGER FLAG
\XGUIOV
C
      IF(KEXIST(1).EQ.1) THEN
          WRITE(CMON(1),'(A)')'^^ST STATSET   L1'
      ELSE
          WRITE(CMON(1),'(A)')'^^ST STATUNSET L1'
      ENDIF
      IF(KEXIST(2).EQ.1) THEN
          WRITE(CMON(2),'(A)')'^^ST STATSET   L2'
      ELSE
          WRITE(CMON(2),'(A)')'^^ST STATUNSET L2'
      ENDIF
      IF(KEXIST(3).EQ.1) THEN
          WRITE(CMON(3),'(A)')'^^ST STATSET   L3'
      ELSE
          WRITE(CMON(3),'(A)')'^^ST STATUNSET L3'
      ENDIF
      IF(KEXIST(5).EQ.1) THEN
          WRITE(CMON(4),'(A)')'^^ST STATSET   L5'
      ELSE
          WRITE(CMON(4),'(A)')'^^ST STATUNSET L5'
      ENDIF
      IF(KEXIST(6).EQ.1) THEN
          WRITE(CMON(5),'(A)')'^^ST STATSET   L6'
      ELSE
          WRITE(CMON(5),'(A)')'^^ST STATUNSET L6'
      ENDIF
      IF(QSINL5) THEN
          WRITE(CMON(6),'(A)')'^^ST STATSET   QS'
      ELSE
          WRITE(CMON(6),'(A)')'^^ST STATUNSET QS'
      ENDIF
      IF (INSTRC) THEN
          WRITE(CMON(7),'(A)')'^^ST STATSET   IN'
      ELSE
          WRITE(CMON(7),'(A)')'^^ST STATUNSET IN'
      ENDIF
C
C
      WRITE ( CMON(8), '(A)')'^^CR'
      CALL XPRVDU(NCVDU, 8,0)
C
      RETURN
      END
C
 
 
 
 
 
 
CODE FOR ICRDIST1
      FUNCTION ICRDIST1( IN, STACK, M5X, M5A, MD5, IOFF)
C
C   IN     THE NUMBER OF ATOMS TO BE MOVED AROUND.
C   STACK THE STACK TO PUT THE ATOMS ON. CURRENTLY 500 WORDS. ie. 100 at
C   M5X     ADDRESS OF THE FIRST ATOM TO MOVE AROUND IN LIST 5
C   M5A    ADDRESS OF THE CURRENT PIVOT ATOM IN LIST 5
C   MD5    STEP SIZE OF ATOM ENTRY IN LIST 5
C   IOFF   OFFSET of X-coord from L5. (Normally 4, but 2 during fourier
C
C--THE RETURN VALUES OF 'ICRDIST1' ARE :
C   0  NO SUITABLE CONTACTS HAVE BEEN FOUND.
C  >0  THE NUMBER OF ENTRIES IN THE DISTANCES STACK.
C
C--THE FOLLOWING VARIABLES MAY BE ADJUSTED
C  AP     MAXIMUM ALLOWED DISTANCES SQUARED OVERALL
C  BP     MINIMUM ALLOWED DISTANCE SQUARED OVERALL
C
C--ATOMS WHICH FORM ACCEPTABLE CONTACTS ARE STORED IN A STACK
C  WHICH HAS THE FOLLOWING FORMAT :
C   0  ADDRESS OF THE ATOM IN LIST 5
C   1  TRANSFORMED X
C   2  TRANSFORMED Y
C   3  TRANSFORMED Z
C   4  DISTANCE
C
C--THE COMMON BLOCK /XAPD/ IS USED AS :
C  APD(1-3)  SYMMETRY RELATED X, Y AND Z, WITH TRANSLATION PART OMITTED.
C  APD(4-6)  INITIAL SYMMETRY RELATED X, Y AND Z.
C  APD(7-9)  FINAL SYMMETRY RELATED X, Y AND Z AFTER A SUCCESSFUL FIND.
C
C--
\ISTORE
\STORE
\XCONST
\XPDS
        REAL STACK(500)
        COMMON /PERM02/ RLIST2(1000),ICFLAG,LSYM,NSYM,MDSYM,LNONP,NNONP
      EQUIVALENCE (STORE(1),ISTORE(1))
C
        CALL CRDIST2     !Set up BPD.
        JT= 5            !Size of atom info on stack
        AO = 3.0
        AP = AO * AO   !Max dist squared
        BP = 0.5 * 0.5   !Min dist squared
C
C--SET UP A FEW INITIAL POINTERS
      NJ=0             !Return value. Number of atoms found
      JS=1             !Stack pointer in STACK(n). Starts at 1.
        I5A=M5A
C--SET UP THE MAXIMUM AND MINIMUM VALUES FOR EACH DIRECTION FOR A DISTAN
      DO 1050 J=1,3
        BPD(J+3)=STORE(I5A+IOFF)-AO/BPD(J)
        BPD(J+6)=STORE(I5A+IOFF)+AO/BPD(J)
        I5A=I5A+1
1050  CONTINUE
C
C--LOOP OVER THE ATOMS FROM CURRENT PIVOT TO CURRENT + IN.
        DO 2800 M5= M5X,M5X+(MD5*(IN-1)),MD5
C--LOOP OVER EACH SYMMETRY OPERATOR COMBINATION FOR THIS ATOM
        M2=LSYM
        DO 2700 NE=1,NSYM
C--APPLY THIS SYMMETRY OPERATOR
          CALL XMLTTM(RLIST2(M2),STORE(M5+IOFF),APD(1),3,3,1)
C--LOOP OVER EACH REQUIRED SIGN FOR THE CENTRE OF SYMMETRY FLAG
          DO 2650 NF=1,2*ICFLAG+1,2
            M2P=LNONP
C--LOOP OVER EACH OF THE NON-PRIMITIVE LATTICE TRANSLATIONS
            DO 2600 NG=1,NNONP
              NH=M2
C--ADD IN THE VARIOUS TRANSLATION PARTS
              DO 1250 NI=1,3
                APD(NI+3)=APD(NI)+RLIST2(M2P)+RLIST2(NH+9)
                APD(NI+6)=APD(NI+3)
                M2P=M2P+1
                NH=NH+1
1250          CONTINUE
C--MOVE THE X COORDINATE SO THAT IT IS OUT OF THE REQUIRED VOLUME
              CALL XSHIFT2(1)
C--ADVANCE THE X COORDINATE BY ONE OR MORE UNIT CELLS
1300          CONTINUE
              IF(KDIST2(1).GE.0) THEN
C--MOVE THE Y COORDINATE SO THAT IT IS OUT OF THE REQUIRED VOLUME
                CALL XSHIFT2(2)
C--ADVANCE THE Y COORDINATE BY ONE OR MORE UNIT CELLS
1400            CONTINUE
                IF(KDIST2(2).LT.0) GOTO 1300
C--MOVE THE Z COORDINATE SO THAT IT IS OUT OF THE REQUIRED VOLUME
                CALL XSHIFT2(3)
C--ADVANCE THE Z COORDINATE BY ONE OR MORE UNIT CELLS
                IF(KDIST2(3).LT.0) GOTO 1400
C--A SUCCESSFUL FIND
C----- CHECK FOR SELF-SELF CONTACT
                IF (     (M5-M5A .NE. 0)
     1              .OR. (ABS(STORE(M5A+IOFF)-APD(7))-ZERO .GT. 0)
     2              .OR. (ABS(STORE(M5A+IOFF+1)-APD(8))-ZERO .GT. 0)
     3            .OR. (ABS(STORE(M5A+IOFF+2)-APD(9))-ZERO .GT. 0) )THEN
C--THIS IS NOT A SELF-SELF CONTACT WITH NO OPERATORS  -  CALC. DIST.
                  F=XDSTNCR(STORE(M5A+IOFF),APD(7))
                  IF(F .GE. BP) THEN
C--CHECK THE DISTANCE AGAINST THE MAXIMUM ALLOWED VALUE SQUARED
                    IF(F .LE. AP) THEN
C--COMPUTE THE DISTANCE
                      E=SQRT(F)
C----- SET THE FLAGS
                      STACK(JS)=M5             !0 = Pointer to atom
                      NJ=NJ+1                   !Atom Counter.
                      J=JS+4
                      DO 2550 I=1,3             !1,2,3 = transformed x,y
                        STACK(I+JS)=APD(I+6)
2550                  CONTINUE                  !
                      STACK(JS+4)=E             !4 = Dist
                      JS=JS+JT
                    END IF
                  END IF
                END IF
              END IF
2600        CONTINUE
            CALL XNEGTR(APD(1),APD(1),3)        !Centre of symmetry.
2650      CONTINUE
          M2=M2+MDSYM
2700    CONTINUE
2800  CONTINUE
      ICRDIST1=NJ
      RETURN
      END
C
C
CODE FOR CRDIST2
      SUBROUTINE CRDIST2
C--SET UP A BPD VALUES
\XCONST
\XPDS
\XGUIOV
C--SET UP THE SHIFT DATA
      DO 1050 I=1,3
           K=9+I
         BPD(I)=0.
         DO 1000 J=1,I
            BPD(I)=BPD(I)+GUMTRX(K)*GUMTRX(K)
                  K=K+3
1000     CONTINUE
         BPD(I)=1./SQRT(BPD(I))
1050  CONTINUE
      RETURN
      END
C
CODE FOR XDSTNCR2
      FUNCTION XDSTNCR(A,B)
C--COMPUTE THE DISTANCE SQUARED BETWEEN TWO POINTS
C
C  A  VECTOR CONTAINING THE COORDINATES OF THE FIRST POINT.
C  B  VECTOR CONTAINING THE COORDINATES OF THE SECOND POINT.
C
C--THE RETURN VALUE OF 'XDSTN2' IS THE DISTANCE SQUARED.
C
      DIMENSION A(3),B(3),C(3),D(3)
\XCONST
\XGUIOV
C
C--SUBTRACT THE VECTORS
      CALL XSUBTR(A(1),B(1),C(1),3)
C--ORTHOGONALISE THE DIFFERENCE VECTOR
      CALL XMLTTM(GUMTRX(1),C(1),D(1),3,3,1)
C--COMPUTE THE DISTANCE
      C(1)=D(1)*D(1)+D(2)*D(2)+D(3)*D(3)
C--CHECK THE VALUE
      IF(C(1)-ZEROSQ .LT. 0) C(1)=VALUSQ
C
      XDSTNCR=C(1)
      RETURN
      END
 
CODE FOR KDIST2
      FUNCTION KDIST2(NOC)
C--MOVES AN ATOM POSITIVELY FORWARD ONE UNIT CELL, AND CHECKS IF
C  THE ATOM IS STILL WITHIN THE SEARCH VOLUME FOR THE GIVEN AXIAL DIRECT
C
C  NOC  THE AXIAL DIRECTION ALONG WHICH TO MOVE.
C
C--THE RETURN VALUES OF 'KDIST' ARE :
C
C  -1  ATOM CANNOT BE FITTED IN THE REQUIRED VOLUME ANY MORE.
C   0  ATOM IS STILL WITHIN THE REQUIRED VOLUME FOR THIS DIRECTION.
C
C--THE ATOM IS ASSUMED TO HAVE BEEN POSITIONED OUTSIDE THE VOLUME BY
C  'XSHIFT', AND IT IS ALWAYS MOVED AT LEAST ONE UNIT CELL FOR EACH CALL
C  OF THIS ROUTINE.
C
C--THE COMMON BLOCK 'XPDS' IS USED AS :
C
C  APD(7-9)  CURRENT SET OF ATOMIC COORDINATES TO ALTER.
C  BPD(4-6)  MIINIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C  BPD(7-9)  MAXIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C
C--
\XPDS
C
      KDIST2=-1
C--MOVE FORWARD ONE UNIT CELL
1000  CONTINUE
      APD(NOC+6)=APD(NOC+6)+1.
C--CHECK IF WE HAVE ARRIVED IN THE REQUIRED VOLUME
      IF(APD(NOC+6)-BPD(NOC+3))1000,1050,1050
C--CHECK IF WE HAVE GONE TOO FAR ALONG THIS AXIAL DIRECTION
1050  CONTINUE
      IF(APD(NOC+6)-BPD(NOC+6))1100,1100,1150
C--WE ARE IN THE REQUIRED VOLUME
1100  CONTINUE
      KDIST2=0
1150  CONTINUE
      RETURN
      END
C
CODE FOR XSHIFT2
      SUBROUTINE XSHIFT2(NOC)
C--SHIFTS THE ATOM OUT OF RANGE SO THAT IT CAN START COMING BACK
C
C  NOC  THE NUMBER OF THE PARAMETER TO MOVE, IN THE RANGE 1 TO 3.
C
C--THE COMMON BLOCK 'XPDS' IS USED AS :
C
C  APD(7-9)  CURRENT SET OF ATOMIC COORDINATES TO ALTER.
C  BPD(4-6)  MIINIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C  BPD(7-9)  MAXIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C
C--
\XPDS
C
C--CHECK IF WE GONE FAR ENOUGH BACKWARDS
1000  CONTINUE
      IF(APD(NOC+6)-BPD(NOC+3))1050,1100,1100
C--SUCCESS  -  NOW RETURN
1050  CONTINUE
      RETURN
C--MOVE BACK ONE MORE UNIT CELL
1100  CONTINUE
      APD(NOC+6)=APD(NOC+6)-1.
      GOTO 1000
      END
C
CODE FOR XGDBUP
      SUBROUTINE XGDBUP(CTXT,L5,N5,MD5,ISERI,LDOFOU,IOFF)
C----- UPDATE THE GRAPHICS DATA BASE
C      PREPARE FOR GUI
      CHARACTER CTXT*(*)
      LOGICAL LDOFOU
      DIMENSION JDEV(4)
      REAL TENSOR(3,3), TEMPOR(3,3), ROTN(3,3), AXES(3,3)
\ISTORE
\STORE
\XUNITS
\UFILE
\XIOBUF
\XSSVAL
\XOPVAL
C Can't use store as some calling routines have claimed it all
C (They are using buffers to copy data to or from disk).
\XGUIOV
C
\QSTORE
\QGUIOV
      CHARACTER CCOL*6, WCLINE*80, CFILEN*80, CATTYP*4,CLAB*10
      LOGICAL WEXIST
        REAL STACK(500)     !Space for 100 contacts.
        LOGICAL LNOUPD
        SAVE    LNOUPD
        DATA    LNOUPD /.FALSE./
C
C The QSINl5 flag is set here, if there are Q atoms in list 5.
C It is used by the menu update routine.
C The LUPDAT flag prevents the data from being sent to the GUI.
C LGUIL1 IS SET IF LIST 1 IS AVAILABLE
C LGUIL5 IS SET IF LIST 5 IS AVAILABLE
C LUPDAT IS SET WHEN MTRX IS INITIALISED AND GUI IS ENABLED
C MTRX IS INITIALISED
C      1 WHEN LIST 1 IS FORMED
C      2 WHEN THE GUI IS INITIALISED
C (For example, the graphics window may be closed or even unimplemented)
C
C
C
      IF (.NOT.LUPDAT) RETURN
        IF (LNOUPD) THEN
                LNOUPD = .FALSE.
                RETURN
        ENDIF
C
        IF(LDOFOU) LNOUPD = .TRUE.
 
      QSINL5 = .FALSE.
C
C<DEBUG>
C      WRITE(NCAWU,'(A,3I8,1X,2A)')'^^TX# L5,N5,MD5 ',
C     1L5,N5,MD5,CTXT,'^^EN'
C      WRITE(NCAWU,'(3(A,I6),A)')'^^TX No. of atoms ',N5,
C     1                          ' List serial ',ISERI,
C     2                          ' Old serial ',ISERIA,
C     3                          '^^EN'
C</DEBUG>
C
C Initial checks.....
C If the current list is is the same as one sent before the
C don't send it again...
      IF((ISERI.EQ.ISERIA).AND.(ISERI.NE.0)) RETURN
      ISERIA = ISERI
C Check for valid pointers to lists.
      IF ((.NOT.LGUIL5) .AND. (.NOT.LGUIL1)) THEN
               GOTO 9900
      ENDIF
C
C Calculate and store orthogonal coords....
C Calculate sum of x, y and z as we go.
         XTOT = 0
         YTOT = 0
         ZTOT = 0
         IPLACE = 1
         J = L5
         DO 30 I = 1, N5
             TSTORE(IPLACE)   = GUMTRX(1) * STORE(J+IOFF)
     1                       + GUMTRX(2) * STORE(J+IOFF+1)
     2                       + GUMTRX(3) * STORE(J+IOFF+2)
             TSTORE(IPLACE+1) = GUMTRX(4) * STORE(J+IOFF)
     1                       + GUMTRX(5) * STORE(J+IOFF+1)
     2                       + GUMTRX(6) * STORE(J+IOFF+2)
             TSTORE(IPLACE+2) = GUMTRX(7) * STORE(J+IOFF)
     1                       + GUMTRX(8) * STORE(J+IOFF+1)
     2                       + GUMTRX(9) * STORE(J+IOFF+2)

C
C            WRITE(6,'(A,3F8.3,A)')'^^TXOrtho coords ',TSTORE(IPLACE),
C     1      TSTORE(IPLACE+1),TSTORE(IPLACE+2),'^^EN'
             XTOT = XTOT + TSTORE(IPLACE)
             YTOT = YTOT + TSTORE(IPLACE+1)
             ZTOT = ZTOT + TSTORE(IPLACE+2)
             IPLACE = IPLACE + 3
             J = J + MD5
30       CONTINUE
C
C Calculate the centre of the molecule
         XCENT = XTOT / N5
         YCENT = YTOT / N5
         ZCENT = ZTOT / N5
C
C Find atom furthest from the center to set scaling.
C NB, it is quicker to find the center and longest distance from it
C (two loops through the list), than to find the longest distance
C between all pairs of atoms (n squared / 2 loops through the list...)
C
C
         IPLACE = 1
         RLENTH = 0
         DO 40 I = 1, N5
             TMPLEN = SQRT ( ((TSTORE(IPLACE)  -XCENT)**2)
     1                     + ((TSTORE(IPLACE+1)-YCENT)**2)
     2                     + ((TSTORE(IPLACE+2)-ZCENT)**2) )
             RLENTH = MAX (TMPLEN + 2,RLENTH)
             IPLACE = IPLACE + 3
40       CONTINUE
C
         IF (RLENTH.LT.0.1)THEN
            GSCALE = 5000.0
         ELSE
            GSCALE = 5000.0 / RLENTH
         ENDIF
C
C         WRITE(6,'(A,F15.3,A)')'^^TXScale is ',GSCALE,'^^EN'
C
C         WRITE ( CMON,'(A,F15.4,A)')'^^GR SCALE ',GSCALE,'^^EN'
C         CALL XPRVDU(NCVDU, 1,0)
         WRITE ( CMON, '(A)')'^^GR MODEL L5'
         CALL XPRVDU(NCVDU, 1,0)
C

         IPLACE = 1
         J = L5
C         WRITE(NCAWU,'(A)')'^^TXMain loop^^EN'
         DO 100 I = 1, N5
C Get atom type.
             IATTYP = ISTORE(J)
             WRITE(CATTYP,'(A4)')IATTYP
             IF((.NOT.QSINL5).AND.(CATTYP(1:1).EQ.'Q'))
     1                  QSINL5 = .TRUE.
             DO 80 K = 1, NATINF * 6, 6
                   IF(IATINF(K).EQ.IATTYP) THEN
                        VDW  = ATINF(K+1)
                        COV  = ATINF(K+2)
                        IRED = IATINF(K+3)
                        IGRE = IATINF(K+4)
                        IBLU = IATINF(K+5)
                        GOTO 90
                   ENDIF
80           CONTINUE
C Atom info not found. Load it and cache it. The info is stored
C in common, so only needs loading once.
C             WRITE(NCAWU,'(A)')'^^TXLoading properties^^EN'
             CFILEN = 'CRYSDIR:\SCRIPT\PROPWIN.DAT'
             CALL MTRNLG(CFILEN,'OLD',ILENG)
             INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
             IF(.NOT.WEXIST) THEN              !use default values
                 IATINF((NATINF*6)+1) = IATTYP
                 ATINF((NATINF*6)+2)  = 1
                 ATINF((NATINF*6)+3)  = 1
                 IATINF((NATINF*6)+4) = 0
                 IATINF((NATINF*6)+5) = 0
                 IATINF((NATINF*6)+6) = 0
                 NATINF = NATINF + 6
                 GOTO 90
             ENDIF
C             OPEN (UNIT=87,FILE=CFILEN(1:ILENG),STATUS='OLD')
CDJWMAR99[
C             IF (KFLOPN (NCARU, CFILEN(1:ILENG), ISSOLD, ISSREA,
C     1       1) .EQ. -1) GOTO 9900
              CALL XMOVEI(KEYFIL(1,2), JDEV, 4)
              CALL XRDOPN (6, JDEV, CFILEN(1:ILENG), ILENG)
              IF ( IERFLG .LT. 0) GOTO 9900
CDJWMAR99]
85           CONTINUE
               READ(NCARU,'(A80)',END=89) WCLINE
             IF((WCLINE(1:3).EQ.'CON').OR.(WCLINE(1:3).EQ.'   '))
     1                                                    GOTO 85
               IF(WCLINE(1:2).EQ.CATTYP) THEN
                  CCOL = WCLINE(62:67)
                  READ(WCLINE(35:38),'(F4.2)') VDW
                  READ(WCLINE(13:16),'(F4.2)') COV
                  CLOSE(NCARU)
C                  WRITE(6,'(A)')'^^TXLoading colours^^EN'
                  CFILEN = 'CRYSDIR:COLOUR.CMN'
                  CALL MTRNLG(CFILEN,'OLD',ILENG)
                  INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
                  IF(.NOT.WEXIST) GOTO 89
C                  OPEN (UNIT=87,FILE=CFILEN(1:ILENG),STATUS='OLD')
                  IF (KFLOPN (NCARU, CFILEN(1:ILENG), ISSOLD, ISSREA,
     1            1) .EQ. -1) GOTO 9900
95                CONTINUE
                  READ(NCARU,'(A21)',END=89) WCLINE
                        IF(CCOL.EQ.WCLINE(1:6))THEN
                              READ(WCLINE(7:21),'(3I5)')IRED,IGRE,IBLU
                              IATINF((NATINF*6)+1) = IATTYP
                              ATINF((NATINF*6)+2)  = VDW
                              ATINF((NATINF*6)+3)  = COV
                              IATINF((NATINF*6)+4) = IRED
                              IATINF((NATINF*6)+5) = IGRE
                              IATINF((NATINF*6)+6) = IBLU
                              NATINF = NATINF + 6
                              GOTO 90
                        ENDIF
                  GOTO 95
               ENDIF
               GOTO 85
C
89           CONTINUE !Reached end of file with no success
C Add a black atom...
                         IRED = 0
                         IGRE = 0
                         IBLU = 0
                         COV = 0.8
                         VDW = 1.8
                         IATINF((NATINF*6)+1) = IATTYP
                         ATINF((NATINF*6)+2)  = VDW
                         ATINF((NATINF*6)+3)  = COV
                         IATINF((NATINF*6)+4) = IRED
                         IATINF((NATINF*6)+5) = IGRE
                         IATINF((NATINF*6)+6) = IBLU
                         NATINF = NATINF + 1
                         GOTO 90
90           CONTINUE
             CLOSE(NCARU)
C
C     WRITE(NCAWU,'(A)')'^^TXProperties OK^^EN'
C     WRITE(NCAWU,'(A,F15.3)')'^^TXTSTORE(X) ',TSTORE(IPLACE),'^^EN'
C     WRITE(NCAWU,'(A,F15.3)')'^^TXTSTORE(Y) ',TSTORE(IPLACE+1),'^^EN'
C     WRITE(NCAWU,'(A,F15.3)')'^^TXTSTORE(Z) ',TSTORE(IPLACE+2),'^^EN'
C     WRITE(NCAWU,'(A,F15.3)')'^^TXSTORE(J+1) ',STORE(J+1),'^^EN'
C     WRITE(NCAWU,'(A,F15.3)')'^^TXSTORE(J+2) ',STORE(J+2),'^^EN'
C     WRITE(NCAWU,'(A,F15.3)')'^^TXSTORE(J+3) ',STORE(J+3),'^^EN'
C
             WRITE(CLAB,'(A)')STORE(J)
             CALL XCTRIM(CLAB,ILEN)
             ISER = NINT(STORE(J+1))
             IF(ISER.LT.10) THEN
                 WRITE(CLAB(ILEN:),'(A1,I1,A1)')
     1           '(', NINT(STORE(J+1)), ')'
             ELSEIF(ISER.LT.100)THEN
                 WRITE(CLAB(ILEN:),'(A1,I2,A1)')
     1           '(', NINT(STORE(J+1)), ')'
             ELSEIF(ISER.LT.1000)THEN
                 WRITE(CLAB(ILEN:),'(A1,I3,A1)')
     1           '(', NINT(STORE(J+1)), ')'
             ELSE
                 WRITE(CLAB(ILEN:),'(A1,I4,A1)')
     1           '(', NINT(STORE(J+1)), ')'
             ENDIF



             TENSOR(1,1) = STORE(J+IOFF+3)
             TENSOR(2,2) = STORE(J+IOFF+4)
             TENSOR(3,3) = STORE(J+IOFF+5)
             TENSOR(2,3) = STORE(J+IOFF+6)
             TENSOR(1,3) = STORE(J+IOFF+7)
             TENSOR(1,2) = STORE(J+IOFF+8)
             TENSOR(3,2) = TENSOR(2,3)
             TENSOR(3,1) = TENSOR(1,3)
             TENSOR(2,1) = TENSOR(1,2)

C             WRITE(99,'(A)') 'CRY: TENSOR, ORTHTENSOR, AXES, ELOR: '
C             WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)
                     
             CALL XMLTMM(GUMTRX(19), TENSOR,     TEMPOR,3,3,3)

             CALL XMLTMT(TEMPOR,     GUMTRX(19), TENSOR,3,3,3)
C We now have an orthogonal tensor in TENSOR(3,3).

C             WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)

#DVF             CALL ZEIGEN(TENSOR,ROTN)

C Filter out tiny axes
             TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(2,2)/100 )
             TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(3,3)/100 )
             TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(1,1)/100 )
             TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(3,3)/100 )
             TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(1,1)/100 )
             TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(2,2)/100 )

             DO 93 KI=1,3
              DO 94 KJ=1,3
               AXES(KI,KJ) = ROTN(KJ,KI)*SQRT(ABS(TENSOR(KJ,KJ)))*GSCALE
94            CONTINUE
93           CONTINUE

C           WRITE(99,'(9(1X,F7.4))') ((AXES(KI,KJ)/GSCALE,KI=1,3),KJ=1,3)

C           WRITE(99,'(9(1X,F7.4))') (GUMTRX(KI),KI=19,27)


96           FORMAT (A,I4,1X,A,/,A,8(1X,I6),/,A,2(1X,I6),/,A,9(1X,I6))
             WRITE ( CMON,96 )
     1       '^^GR ATOM ',
     2       1,  CLAB,
     3       '^^GR ',
     4       NINT(TSTORE(IPLACE)*GSCALE),
     5       NINT(TSTORE(IPLACE+1)*GSCALE),
     6       NINT(TSTORE(IPLACE+2)*GSCALE),
     7       NINT(IRED*2.55),NINT(IGRE*2.55),NINT(IBLU*2.55),
     8       NINT(1000*STORE(J+2)), NINT(COV*GSCALE),
     1       '^^GR',
     2       NINT(VDW*GSCALE),1,
     1       '^^GR',
     3       ((NINT(AXES(KI,KJ)),KI=1,3),KJ=1,3)
             CALL XPRVDU(NCVDU, 4,0)
C       WRITE(NCAWU,'(A)') (CMON(IDJW),IDJW=1,3)
C
             J = J + MD5
             IPLACE = IPLACE + 3
100      CONTINUE
 
         DO 130 I = 1, N5-1
            IAT1P = L5+((I-1)*MD5)
            NFOUND=ICRDIST1(N5,STACK,L5,IAT1P,MD5,IOFF)
            IAT1P = L5+((I-1)*MD5)
            DO 120 J = 1, NFOUND
               IAT2P = NINT(STACK((J*5)-4))
               ACTDST= STACK(J*5)
               IAT1 = ISTORE(IAT1P)
               IAT2 = ISTORE(IAT2P)
               DO 110 K = 1, NATINF * 6, 6
                  IF(IATINF(K).EQ.IAT1) THEN
                     COV1  = ATINF(K+2)
                  ENDIF
                  IF(IATINF(K).EQ.IAT2) THEN
                     COV2  = ATINF(K+2)
                  ENDIF
110            CONTINUE
               REQDST = (COV1 + COV2) * 1.1
               IF(ACTDST.LT.REQDST) THEN
                  XX   = GUMTRX(1) * STACK((J*5)-3)
     1                 + GUMTRX(2) * STACK((J*5)-2)
     2                 + GUMTRX(3) * STACK((J*5)-1)
                  XY   = GUMTRX(4) * STACK((J*5)-3)
     1                 + GUMTRX(5) * STACK((J*5)-2)
     2                 + GUMTRX(6) * STACK((J*5)-1)
                  XZ   = GUMTRX(7) * STACK((J*5)-3)
     1                 + GUMTRX(8) * STACK((J*5)-2)
     2                 + GUMTRX(9) * STACK((J*5)-1)
                  WRITE ( CMON, '(A,10(1X,I5))')
     1                  '^^GR BOND ',
     1                  NINT(TSTORE((I*3)-2)*GSCALE),
     1                  NINT(TSTORE((I*3)-1)*GSCALE),
     1                  NINT(TSTORE(I*3)*GSCALE),
     1                  NINT(XX*GSCALE),
     1                  NINT(XY*GSCALE),
     1                  NINT(XZ*GSCALE),
     3                  255,255,255,
     1                  NINT(GSCALE*0.25)
                  CALL XPRVDU(NCVDU, 1,0)
               ENDIF
120         CONTINUE
130      CONTINUE
 
C         WRITE(NCAWU,'(A)')'^^TX UPDATING!^^EN'
C      WRITE(NCAWU,'(A)')'^^TXFin...^^EN'
 
C         DO 140 I = 1, N5-1
C            IAD = L5+((I-1)*MD5)
C            NFOUND=ICRDIST1(N5-I-1,STACK,IAD+MD5,IAD,MD5)
C            IAD = L5+((I-1)*MD5)
C            WRITE(CMON,'(A,I4,A,A4,I4)')'Found ',NFOUND,
C     1     ' contacts from  ',
C     1      STORE(IAD),NINT(STORE(IAD+1))
C            CALL XPRVDU(NCVDU, 1,0)
C            DO 135 J = 1, NFOUND
C               IAD = NINT(STACK((J*5)-4))
C               WRITE(CMON, '(A7,A4,I4,A4,3F5.2,A8,F5.3)')
C     1         'Atom = ',STORE(IAD),
C     1         NINT(STORE(IAD+1)),
C     2         ' at ', STACK((J*5)-3),STACK((J*5)-2)
C     3         , STACK((J*5)-1), ' Dist = ', STACK((J*5))
C               CALL XPRVDU(NCVDU, 1,0)
C135         CONTINUE
C140       CONTINUE
      IF(.NOT.LDOFOU) THEN
         WRITE ( CMON, '(A,/,A)')'^^GR SHOW','^^CR'
         CALL XPRVDU(NCVDU, 2,0)
      ENDIF
C If LDOFOU is true, the calling routine can add in objects
C of its own. It *must* then send ^^GR SHOW then ^^CR.
 
      RETURN
9900  CONTINUE
      WRITE (NCVDU,'(A)') 'ERROR IN GUIDRIVER'
      RETURN
      END
