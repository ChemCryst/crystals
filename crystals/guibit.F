C $Log: not supported by cvs2svn $
C Revision 1.32  2001/03/08 14:30:58  richard
C
C Remove "Too many contacts" message - failing silently is much much faster.
C XGDBUP is now called with common block address and length allowing
C all lists to be passed through this routine.
C Included calculations for drawing thermal ellipsoids. Speeded up
C bond search. Added atoms labels to bond info passed to GUI.
C Info extracted from LIST 1, LIST 2, LIST 29, LIST 30 and passed
C to the GUI.
C
C Revision 1.31  2001/01/22 16:48:26  richard
C Pass peak height (spare) as value*1000.
C
C Revision 1.30  2001/01/15 12:12:54  richard
C RIC: Prevent array overflow if too many contacts are found to an atom during
C a bond search. (More than 500)
C
C Revision 1.29  2000/12/13 17:47:38  richard
C Support for LINUX.
C
C Revision 1.28  2000/09/19 14:13:16  CKP2
C find colour table in SCRIPT
C
C Revision 1.27  2000/07/19 11:56:56  ckp2
C RIC: Fixed bug where GUI hangs when structure explodes...
C      I think.
C
C Revision 1.26  2000/07/11 11:04:08  ckp2
C Extra argument to KFLOPN, for specifying SEQUENTIAL or DIRECT access
C
C Revision 1.25  2000/07/04 13:43:32  ckp2
C RIC: Better colours for bond deviations using csd checks.
C
C Revision 1.24  2000/02/23 12:22:06  ckp2
C djw abortive attempt to trap NaN values
C
C Revision 1.23  2000/01/20 16:57:58  ckp2
C ric  fix square root problem
C
C Revision 1.22  1999/12/15 14:54:49  ckp2
C djw  Add set autoupdate on/off, force ON in summary.
C
C Revision 1.21  1999/09/22 16:11:37  ckp2
C RIC: Modified bond length tolerances to match Cameron, except that
C bonds shorter than 0.5*(sum of cov radii) will not be drawn.
C
C Revision 1.20  1999/08/03 09:17:18  richard
C RIC: Pass the SPARE value to the GUI (if available), otherwise pass the
C covalent radii. Spare is scaled by 0.01 to display on an angstrom scale.
C
C Revision 1.19  1999/07/30 20:30:13  richard
C RIC: If atoms have negative covalent radii, then don't bond them to
C anything, but still use the absolute value for the radius.
C
C Revision 1.18  1999/07/21 18:11:06  richard
C RIC: Remove defunct code. Fix setting of QSINL5 flag. (Don't set FALSE, if
C not updating list.)
C
C Revision 1.17  1999/07/20 17:58:44  richard
C RIC: There was a problem where any element without a colour assigned
C in propwin.dat, was getting assigned a default radius aswell as a
C default colour. Fixed.
C
C Revision 1.16  1999/07/02 17:53:36  richard
C RIC: Changed bond determining routine to ignore bonds shorter than
C      0.7 * (sum of covalent radii). This makes things a little clearer
C      when there are lots of atoms.
C
C Revision 1.15  1999/07/01 18:09:41  dosuser
C RIC: Changed the largest possible bonding distance of two atoms
C to (COVALENT(1) + COVALENT(2)) * 1.1 to
C    (COVALENT(1) + COVALENT(2)) * 1.3. Should solve problems with
C    metal atoms not bonding to anything.
C
C Revision 1.14  1999/06/22 13:51:27  dosuser
C RIC: Temporarily commented out the eigen vector and axes calculation as
C it doesn't seem to work.
C
C Revision 1.13  1999/06/13 16:18:23  dosuser
C RIC: Centre the molecule on 0,0,0 as it is updated.
C
C Revision 1.12  1999/06/01 13:00:05  dosuser
C RIC: Added commented out debugging code for checking which bonds
C have been found.
C RIC: Commented out some unused variables.
C
C Revision 1.11  1999/05/25 16:03:31  dosuser
C RIC: Changes for UNIX filenames for LIN and GIL targets.
C
C Revision 1.10  1999/05/21 11:18:59  dosuser
C RIC: When drawing bonds colour them according to the deviation from
C the CSD mean, if this info has already been computed.
C
C Revision 1.9  1999/05/10 19:48:44  dosuser
C RIC: It turns out that LGUIL1 and LGUIL5 were a bit useless as they
C     were only set when you call XWININ() from #SET TERM WIN. So I changed
C     things around a bit:
C     There is now no LGUIL5 because XGDBUP can only be called from places
C     which are altering list 5 anyway. Instead there is now an LGUIL2
C     instead, which was a bit overdue. LGUIL1 and LGUIL2 are set in
C     XFAL01 and XFAL02 respectively as the XGUIOV and PERM02 common blocks
C     are filled in. The result: Structure appears when it is supposed to
C     and no crashes in the mean time.
C
C Revision 1.8  1999/05/10 16:53:58  dosuser
C RIC: Removed unused routine GUI()
C
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

CODE FOR GUIBLK
      BLOCK DATA GUIBLK
\XGUIOV
      DATA ISERIA/0/, NATINF/0/
      DATA LGUIL1/.FALSE./
      DATA LGUIL2/.FALSE./
     1 LUPDAT/.FALSE./, QSINL5/.FALSE./
      END


CODE FOR MENUUP (Updates the flags for the menus)
      SUBROUTINE MENUUP
\XUNITS
\XIOBUF
      INTEGER FLAG
\XGUIOV

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
                      IF (JS.GT.500) THEN
                          JS=JS-JT
C                          CALL ZMORE('Too many contacts in ICRDIST1',0)
                          NJ=NJ-1
                          J=JS-4
                      END IF
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
C--JUMP THE ATOM TO AT LEAST JUST BEFORE THE REQUIRED VOLUME
      APD(NOC+6)=MAX(APD(NOC+6),MOD(APD(NOC+6),1.)+NINT(BPD(NOC+3))-1)
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
c      SUBROUTINE XGDBUP(CTXT,L5,N5,MD5,ISERI,LDOFOU,IOFF)
      SUBROUTINE XGDBUP(CTXT,IULN,LSN,ICOMMN,IDIMN)
C----- UPDATE THE GRAPHICS DATA BASE
C      PREPARE FOR GUI
C
C Can't claim any store as some calling routines have claimed it all
C (They are using buffers to copy data to or from disk).
C

\ISTORE
\STORE
\XUNITS
\UFILE
\XIOBUF
\XSSVAL
\XOPVAL
\XGUIOV
\QSTORE
\QGUIOV
\XCONST 

      CHARACTER CTXT*(*)
      DIMENSION ICOMMN(IDIMN)
      LOGICAL LDOFOU, LSPARE, LISNAN
      DIMENSION JDEV(4)
      REAL TENSOR(3,3), TEMPOR(3,3), ROTN(3,3), AXES(3,3)
      CHARACTER CCOL*6, WCLINE*80, CFILEN*80, CATTYP*4,CLAB*10,CLAB2*10
      LOGICAL WEXIST
      REAL STACK(500)     !Space for 100 contacts.
      LOGICAL LNOUPD
      CHARACTER*8 CINST(6)
      SAVE    LNOUPD
      DATA    LNOUPD /.FALSE./
      DATA    CINST /'Unknown','CAD4','Mach3','KappaCCD','Dip','Smart'/

C
C The QSINl5 flag is set here, if there are Q atoms in list 5.
C It is used by the menu update routine.
C
C LUPDAT flag prevents the data from being sent to the GUI.
C LGUIL1 IS SET IF LIST 1 IS AVAILABLE
C LGUIL2 IS SET IF LIST 2 IS AVAILABLE
C LUPDAT IS SET WHEN MTRX IS INITIALISED AND GUI IS ENABLED
C MTRX IS INITIALISED
C      1 WHEN LIST 1 IS FORMED
C      2 WHEN THE GUI IS INITIALISED
C (For example, the graphics window may be closed or even unimplemented)
C
CDJWDEC99 'ISSUPD' CAN  BE RESET BY '#SET AUTO = OFF/ON (VALUE 0/1)
C
C
      IF (ISSUPD .EQ. 0 ) RETURN
      IF (.NOT.LUPDAT) RETURN
      IF (LNOUPD) THEN
             LNOUPD = .FALSE.
             RETURN
      ENDIF
 

C Branch on type of list that has been sent:

      IF ( IULN .EQ. 5 ) THEN   ! atom coordinates - update model

C NB. L5 common block is not present, this just substitutes the
C     values into familiar looking variables.
        L5 = ICOMMN(1)
        MD5= ICOMMN(3)
        N5 = ICOMMN(4)

C If the current list is is the same as one sent before the
C don't update the GUI... (unless LSN is zero).

        IF((LSN.EQ.ISERIA).AND.(LSN.NE.0)) RETURN

C Check for valid pointers to lists.

        IF ((.NOT.LGUIL1).OR.(.NOT.LGUIL2)) RETURN

C Set old list number to current list number.
        ISERIA = LSN
        QSINL5 = .FALSE.
        LSPARE = .FALSE.
C
C Calculate and store orthogonal coords....
C Calculate sum of x, y and z as we go.
        XTOT = 0
        YTOT = 0
        ZTOT = 0
        IPLACE = 1
        J = L5
        DO I = 1, N5
             TSTORE(IPLACE)  = GUMTRX(1) * STORE(J+4)
     1                       + GUMTRX(2) * STORE(J+5)
     2                       + GUMTRX(3) * STORE(J+6)
             TSTORE(IPLACE+1) = GUMTRX(4) * STORE(J+4)
     1                       + GUMTRX(5) * STORE(J+5)
     2                       + GUMTRX(6) * STORE(J+6)
             TSTORE(IPLACE+2) = GUMTRX(7) * STORE(J+4)
     1                       + GUMTRX(8) * STORE(J+5)
     2                       + GUMTRX(9) * STORE(J+6)
             XTOT = XTOT + TSTORE(IPLACE)
             YTOT = YTOT + TSTORE(IPLACE+1)
             ZTOT = ZTOT + TSTORE(IPLACE+2)
             IF ( STORE ( J + 13 ) .GT. 0.0001 ) LSPARE = .TRUE.
             IPLACE = IPLACE + 3
             J = J + MD5
        END DO
C
C Calculate the centre of the molecule
        GCENTX = XTOT / N5
        GCENTY = YTOT / N5
        GCENTZ = ZTOT / N5
C
C Find atom furthest from the center to set scaling.
C NB, it is quicker to find the center and longest distance from it
C (two loops through the list), than to find the longest distance
C between all pairs of atoms (n squared / 2 loops through the list...)
C
C Centre the molecule on 0,0,0 at the same time!

        IPLACE = 1
        RLENTH = 0
        DO I = 1, N5
             TSTORE(IPLACE)   = TSTORE(IPLACE)   - GCENTX
             TSTORE(IPLACE+1) = TSTORE(IPLACE+1) - GCENTY
             TSTORE(IPLACE+2) = TSTORE(IPLACE+2) - GCENTZ
             TMPLEN =  ( (TSTORE(IPLACE  )**2)
     1                 + (TSTORE(IPLACE+1)**2)
     2                 + (TSTORE(IPLACE+2)**2) )
             RLENTH = MAX (TMPLEN,RLENTH)
             IPLACE = IPLACE + 3
        END DO

        IF (RLENTH.LT.0.1)THEN
          GSCALE = 5000.0
        ELSE
           GSCALE = 5000.0 / (SQRT (RLENTH) + 2)
        ENDIF

        WRITE ( CMON, '(A)')'^^GR MODEL L5'
        CALL XPRVDU(NCVDU, 1,0)

        IPLACE = 1
        J = L5

        DO 100 I = 1, N5

C Get atom type.

             IATTYP = ISTORE(J)
             WRITE(CATTYP,'(A4)')IATTYP
             IF((.NOT.QSINL5).AND.(CATTYP(1:1).EQ.'Q')) THEN
                       QSINL5 = .TRUE.
             END IF
             DO 80 K = 1, NATINF * 6, 6
                   IF(IATINF(K).EQ.IATTYP) THEN
                        VDW  = ATINF(K+1)
                        COV  = ABS(ATINF(K+2))
                        IRED = IATINF(K+3)
                        IGRE = IATINF(K+4)
                        IBLU = IATINF(K+5)
                        GOTO 90
                   ENDIF
80           CONTINUE
C Atom info not found. Load it and cache it. The info is stored
C in common, so only needs loading once.
C             WRITE(NCAWU,'(A)')'^^TXLoading properties^^EN'
&DOS             CFILEN = 'CRYSDIR:\script\propwin.dat'
&DVF             CFILEN = 'CRYSDIR:\script\propwin.dat'
&GID             CFILEN = 'CRYSDIR:\script\propwin.dat'
&VAX             CFILEN = 'CRYSDIR:\script\propwin.dat'
&LIN             CFILEN = 'CRYSDIR:/script/propwin.dat'
&GIL             CFILEN = 'CRYSDIR:/script/propwin.dat'
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
             CALL XMOVEI(KEYFIL(1,2), JDEV, 4)
             CALL XRDOPN (6, JDEV, CFILEN(1:ILENG), ILENG)
             IF ( IERFLG .LT. 0) GOTO 9900
C Read the properties file and extract cov, vdw and colour.
85           CONTINUE
             READ(NCARU,'(A80)',END=89) WCLINE
             IF((WCLINE(1:3).EQ.'CON').OR.(WCLINE(1:3).EQ.'   '))
     1                                                    GOTO 85
               IF(WCLINE(1:2).EQ.CATTYP) THEN
                  CCOL = WCLINE(62:67)
                  READ(WCLINE(35:38),'(F4.2)') VDW
                  READ(WCLINE(13:16),'(F4.2)') COV
                  CLOSE(NCARU)
C Now get the colour definition for this colour from colour.cmn
##GILLIN                  CFILEN = 'CRYSDIR:SCRIPT\COLOUR.CMN'
&&GILLIN                  CFILEN = 'CRYSDIR:script/colour.cmn'
                  CFILEN = 'CRYSDIR:SCRIPT\COLOUR.CMN'
                  CALL MTRNLG(CFILEN,'OLD',ILENG)
                  INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
                  IF(.NOT.WEXIST) GOTO 88
                  IF (KFLOPN (NCARU, CFILEN(1:ILENG), ISSOLD, ISSREA,
     1            1, ISSSEQ) .EQ. -1) GOTO 9900
95                CONTINUE
                  READ(NCARU,'(A21)',END=88) WCLINE
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

88           CONTINUE !Reached end of colour file with no success.
                         IRED = 0
                         IGRE = 0
                         IBLU = 0
                         IATINF((NATINF*6)+1) = IATTYP
                         ATINF((NATINF*6)+2)  = VDW
                         ATINF((NATINF*6)+3)  = COV
                         IATINF((NATINF*6)+4) = IRED
                         IATINF((NATINF*6)+5) = IGRE
                         IATINF((NATINF*6)+6) = IBLU
                         NATINF = NATINF + 1
                         GOTO 90
89           CONTINUE !Reached end of properties file with no success
C Add a black atom...
C                  WRITE(99,'(2A)') 'Not Found ', CATTYP
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


             IF ( NINT(STORE(J+3)) .EQ. 0 ) THEN

               TENSOR(1,1) = STORE(J+7)
               TENSOR(2,2) = STORE(J+8)
               TENSOR(3,3) = STORE(J+9)
               TENSOR(2,3) = STORE(J+10)
               TENSOR(1,3) = STORE(J+11)
               TENSOR(1,2) = STORE(J+12)
               TENSOR(3,2) = TENSOR(2,3)
               TENSOR(3,1) = TENSOR(1,3)
               TENSOR(2,1) = TENSOR(1,2)
      
c             WRITE(99,'(A)') 'CRY: TENSOR, ORTHTENSOR, AXES, ELOR: '
c             WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)
                     
               CALL XMLTMM(GUMTRX(19), TENSOR,     TEMPOR,3,3,3)
               CALL XMLTMT(TEMPOR,     GUMTRX(19), TENSOR,3,3,3)
C We now have an orthogonal tensor in TENSOR(3,3).

c             WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)

##DVFLIN               CALL ZEIGEN(TENSOR,ROTN)

C Filter out tiny axes
               TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(2,2)/100 )
               TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(3,3)/100 )
               TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(1,1)/100 )
               TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(3,3)/100 )
               TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(1,1)/100 )
               TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(2,2)/100 )
            
               DO KI=1,3
                DO KJ=1,3
                 AXES(KI,KJ) =   ROTN(KJ,KI)
     1                         * SQRT(ABS(TENSOR(KJ,KJ)))
     2                         * GSCALE
     3                         * 1.5
                END DO
               END DO

C           WRITE(99,'(9(1X,F7.4))') ((AXES(KI,KJ)/GSCALE,KI=1,3),KJ=1,3)
C               WRITE(99,'(9(1X,F7.4))') (GUMTRX(KI),KI=19,27)

            ELSE
               DO KI=1,3
                DO KJ=1,3
                 AXES(KI,KJ) = 0
                END DO
               END DO
               AXES(1,1) = SQRT(ABS(STORE(J+7))) * GSCALE
            END IF


            IF ( LSPARE ) THEN
                  ISPARE = NINT(1000 * STORE(J+13))
            ELSE
                  ISPARE = NINT(COV*GSCALE)
            END IF

96           FORMAT (A,I4,1X,A,/,A,8(1X,I6),/,A,3(1X,I6),/,A,9(1X,I6))
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
     2       NINT(VDW*GSCALE),ISPARE,NINT(STORE(J+3)),
     1       '^^GR',
     3       ((NINT(AXES(KI,KJ)),KI=1,3),KJ=1,3)
C#SOO     3       0,0,0, 0,0,0, 0,0,0

             CALL XPRVDU(NCVDU, 4,0)
C       WRITE(NCAWU,'(A)') (CMON(IDJW),IDJW=1,3)
C
             J = J + MD5
             IPLACE = IPLACE + 3
100     CONTINUE


C Find bonds:

        DO 130 I = 1, N5-1
            IAT1P = L5+((I-1)*MD5)
            NFOUND=ICRDIST1(N5,STACK,L5,IAT1P,MD5,4)
            IAT1P = L5+((I-1)*MD5)


            DO 120 J = 1, NFOUND
               IAT2P = NINT(STACK((J*5)-4))
               ACTDST= STACK(J*5)
               IAT1 = ISTORE(IAT1P)
               IAT2 = ISTORE(IAT2P)

               DO K = 1, NATINF * 6, 6
                  IF(IATINF(K).EQ.IAT1) THEN
                     COV1  = ATINF(K+2)
                  ENDIF
                  IF(IATINF(K).EQ.IAT2) THEN
                     COV2  = ATINF(K+2)
                  ENDIF
               ENDDO

               IF (COV1 .LT. 0.00) GOTO 130
C First atom is not to be bonded.
               IF (COV2 .LT. 0.00) GOTO 120
C Second atom is not to be bonded.

C NB 1.21 (1.1)^2 is the tolerance used by Lisa.
C Cameron has no lower limit. I do. It is 0.5 * sum of cov.
               REQDSX = (COV1 + COV2) * 1.21
               REQDSN = (COV1 + COV2) * 0.5
               IF ( ACTDST.LT.REQDSX ) THEN


                  XX   = GUMTRX(1) * STACK((J*5)-3)
     1                 + GUMTRX(2) * STACK((J*5)-2)
     2                 + GUMTRX(3) * STACK((J*5)-1)
     3                 - GCENTX
                  XY   = GUMTRX(4) * STACK((J*5)-3)
     1                 + GUMTRX(5) * STACK((J*5)-2)
     2                 + GUMTRX(6) * STACK((J*5)-1)
     3                 - GCENTY
                  XZ   = GUMTRX(7) * STACK((J*5)-3)
     1                 + GUMTRX(8) * STACK((J*5)-2)
     2                 + GUMTRX(9) * STACK((J*5)-1)
     3                 - GCENTZ

CCDEBUG{
c                  WRITE ( 99, '(A,2F8.4,2(A4,I4,3F8.5))')
c     1                  'BOND FOUND ',ACTDST, REQDSX,
c     1                  ISTORE(IAT1P),NINT(STORE(IAT1P+1)),
c     1                  STORE(IAT1P+4),STORE(IAT1P+5),STORE(IAT1P+6),
c     1                  ISTORE(IAT2P),NINT(STORE(IAT2P+1)),
c     1                  STORE(IAT2P+4),STORE(IAT2P+5),STORE(IAT2P+6)
cCDEBUG}      

C Set colour to black:
                  KR = 0
                  KG = 0
                  KB = 0
C If far too short, colour RED.
                  IF (ACTDST.LT.REQDSN) KR = 255

C If a symm related atom, colour bond grey.
                  IF ((ABS(STORE(IAT2P+4)-STACK(J*5-3)).GT.0.001).OR.
     1                (ABS(STORE(IAT2P+5)-STACK(J*5-2)).GT.0.001).OR.
     2                (ABS(STORE(IAT2P+6)-STACK(J*5-1)).GT.0.001))THEN
                    KR = 192
                    KG = 192
                    KB = 192
                  END IF

C See if this bond is in LIST 18. If so, use it's deviation to colour it.
                  IF ( KBDDEV(IAT1P,IAT2P,DEVN) .GT. 0 )THEN

C As deviation goes positive, KB and KG should decrease giving a red colour
C As deviation goes negative, KR and KG should decrease giving a blue colour
C i.e. +ve devn. KR 255, KB ->0  KG ->0
C      -ve devn  KR ->0, KB 255  KG ->0
C But, the deviation starts being coloured from 1.0, rather than 0.0
C DEVN = DEVN - 1
                      KR = MAX ( 0, MIN (255, NINT (383+128*DEVN) ) )
                      KG = MAX ( 0, MIN (255, NINT (383-128*ABS(DEVN))))
                      KB = MAX ( 0, MIN (255, NINT (383-128*DEVN) )  )
                  ENDIF

C Include Atom Labels in this info.
                  WRITE(CLAB,'(A)')STORE(IAT1P)
                  CALL XCTRIM(CLAB,ILEN)
                  ISER = NINT(STORE(IAT1P+1))
                  IF(ISER.LT.10) THEN
                     WRITE(CLAB(ILEN:),'(A1,I1,A1)')'(',ISER,')'
                  ELSEIF(ISER.LT.100)THEN
                     WRITE(CLAB(ILEN:),'(A1,I2,A1)')'(',ISER,')'
                  ELSEIF(ISER.LT.1000)THEN
                     WRITE(CLAB(ILEN:),'(A1,I3,A1)')'(',ISER,')'
                  ELSE
                     WRITE(CLAB(ILEN:),'(A1,I4,A1)')'(',ISER,')'
                  ENDIF
                  WRITE(CLAB2,'(A)')STORE(IAT2P)
                  CALL XCTRIM(CLAB2,ILEN)
                  ISER = NINT(STORE(IAT2P+1))
                  IF(ISER.LT.10) THEN
                     WRITE(CLAB2(ILEN:),'(A1,I1,A1)')'(',ISER,')'
                  ELSEIF(ISER.LT.100)THEN
                     WRITE(CLAB2(ILEN:),'(A1,I2,A1)')'(',ISER,')'
                  ELSEIF(ISER.LT.1000)THEN
                     WRITE(CLAB2(ILEN:),'(A1,I3,A1)')'(',ISER,')'
                  ELSE
                     WRITE(CLAB2(ILEN:),'(A1,I4,A1)')'(',ISER,')'
                  ENDIF

                  WRITE ( CMON,'(A,10(1X,I5),/,A,2(1X,A10),1X,F6.3)')
     1                  '^^GR BOND ',
     1                  NINT(TSTORE((I*3)-2)*GSCALE),
     1                  NINT(TSTORE((I*3)-1)*GSCALE),
     1                  NINT(TSTORE(I*3)*GSCALE),
     1                  NINT(XX*GSCALE),
     1                  NINT(XY*GSCALE),
     1                  NINT(XZ*GSCALE),
     3                  KR,KG,KB,
     1                  NINT(GSCALE*0.25),
     1                  '^^GR ',CLAB, CLAB2, ACTDST
                  CALL XPRVDU(NCVDU, 2,0)
               ENDIF
120         CONTINUE
130     CONTINUE
 
        WRITE ( CMON, '(A,/,A)')'^^GR SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)

      ELSE IF ( IULN .EQ. 1 ) THEN   ! cell params - update info tab.
        L1P1 = ICOMMN(1)
211     FORMAT ('^^WI SET _MT_CELL_A TEXT ',F8.4,/,
     1          '^^WI SET _MT_CELL_B TEXT ',F8.4,/,
     1          '^^WI SET _MT_CELL_C TEXT ',F8.4,/,
     1          '^^WI SET _MT_CELL_AL TEXT  ',F7.3,/,
     1          '^^WI SET _MT_CELL_BE TEXT  ',F7.3,/,
     1          '^^WI SET _MT_CELL_GA TEXT ',F7.3,/,
     1          '^^CR')
        WRITE ( CMON, 211 ) (STORE(L1P1+J),J=0,2),
     1                      (STORE(L1P1+J)*RTD,J=3,5)
        CALL XPRVDU(NCVDU, 7,0)

      ELSE IF ( IULN .EQ. 2 ) THEN   ! space group - update info tab.
        L2SG = ICOMMN(25)
        MD2SG = ICOMMN(27)
221     FORMAT ('^^CO SET _MT_SPACEGROUP TEXT ''',4(A4,1X),'''')
        WRITE ( CMON, 221 ) (STORE(L2SG+J),J=0,MD2SG-1)
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( IULN .EQ. 29 ) THEN   ! asymm unit - update info tab.
        L29 = ICOMMN(1)
        M29 = ICOMMN(2)
        MD29 = ICOMMN(3)
        WRITE( CMON(1),'(A)')'^^WI SET _MT_FORMULA TEXT'
        WRITE( CMON(2),'(A)')'^^WI'''
        WRITE( CMON(3),'(A)')'^^CR'
231     FORMAT (A4,F7.3,'-')
        K = 6
        DO J=L29,M29,MD29
         WRITE (CMON(2)(K:),231) STORE(J), STORE(J+4)
         CALL XCRAS ( CMON(2),K )
         DO L = K-1,K-6,-1              !Remove trailing zeroes.
           IF (CMON(2)(L:L).EQ.'0') THEN
             CMON(2)(L:L)=' '
           ELSE
             EXIT
           END IF
         END DO
         K = K + 1
         IF ( K .GT. 70 ) EXIT
        END DO
        WRITE(CMON(2)(K:K),'(A)') ''''
        DO J = 1,K
          IF (CMON(2)(J:J).EQ.'-') CMON(2)(J:J)=' '
        END DO
        CALL XPRVDU(NCVDU, 3, 0)
      ELSE IF ( IULN .EQ. 30 ) THEN   ! goodies - update info tab.
        L30O   = ICOMMN(1)
        L30C   = ICOMMN(5)
        L30R   = ICOMMN(9)
        L30I   = ICOMMN(13)
        L30G   = ICOMMN(21)
        L30T1  = ICOMMN(25)
        MD30T1 = ICOMMN(27)
        L30T2  = ICOMMN(29)
        MD30T2 = ICOMMN(31)
241     FORMAT ('^^WI SET _MT_CR_MIN TEXT ',F8.4,
     1              ' SET _MT_CR_MED TEXT ',F8.4,/,
     1          '^^WI SET _MT_CR_MAX TEXT ',F8.4,
     1              ' SET _MT_CR_TEMP TEXT  ',F5.1,/,
     1          '^^WI SET _MT_CR_DCALC TEXT ',F7.3,
     1              ' SET _MT_CR_MOLWT TEXT  ',F7.2,/,
     1          '^^WI SET _MT_CR_CELLZ TEXT ',F4.0,/,
     1          '^^CR')
        WRITE ( CMON, 241 ) STORE(L30C), STORE(L30C+1), STORE(L30C+2),
     1       STORE(L30C+6), STORE(L30G+1),STORE(L30G+4), STORE(L30G+5)
        CALL XPRVDU(NCVDU, 5, 0)
242     FORMAT ('^^WI SET _MT_CR_SHAPE TEXT ''',8A4,'''',/,
     1          '^^WI SET _MT_CR_COLOUR TEXT ''',8A4,'''',/,
     1          '^^CR')
        WRITE ( CMON, 242 ) (ISTORE(K),K=L30T2,L30T2+MD30T2-1),
     1                      (ISTORE(K),K=L30T1,L30T1+MD30T1-1)
        CALL XPRVDU(NCVDU, 3, 0)
243     FORMAT ('^^WI SET _MT_OBS_MEAS TEXT ',F7.0,
     1              ' SET _MT_OBS_NMRG TEXT ',F7.0,/,
     1          '^^WI SET _MT_OBS_RMRG TEXT ',F8.5,
     1              ' SET _MT_OBS_NFMRG TEXT ',F7.0,/,
     1          '^^WI SET _MT_OBS_RFMRG TEXT ',F8.5,/,
     1          '^^CR')
        WRITE ( CMON, 243 ) STORE(L30O), STORE(L30O+2), STORE(L30O+3),
     1                                   STORE(L30O+4), STORE(L30O+5)
        CALL XPRVDU(NCVDU, 4, 0)
244     FORMAT ('^^WI SET _MT_OBS_HMIN TEXT ',F4.0,
     1              ' SET _MT_OBS_HMAX TEXT ',F4.0,/,
     1          '^^WI SET _MT_OBS_KMIN TEXT ',F4.0,
     1              ' SET _MT_OBS_KMAX TEXT ',F4.0,/,
     1          '^^WI SET _MT_OBS_LMIN TEXT ',F4.0,
     1              ' SET _MT_OBS_LMAX TEXT ',F4.0,/,
     1          '^^WI SET _MT_OBS_THMIN TEXT ',F4.0,
     1              ' SET _MT_OBS_THMAX TEXT ',F4.0,/,
     1          '^^CR')
        WRITE ( CMON, 244 ) ( STORE(L30I+J), J=0,7)
        CALL XPRVDU(NCVDU, 5, 0)
245     FORMAT ('^^CO SET _MT_OBS_INST TEXT ',A8)
        INS = ISTORE(L30C+12) + 1
        IF (( INS .GT. 0 ) .AND. (INS. LE. 6)) THEN
          WRITE ( CMON, 245 ) CINST(INS)
        ELSE
          WRITE ( CMON, 245 ) 'New Type'
        END IF
        CALL XPRVDU ( NCVDU, 1, 0 )
246     FORMAT ('^^WI SET _MT_REF_R TEXT ',F8.5,
     1              ' SET _MT_REF_RW TEXT ',F8.5,/,
     1          '^^WI SET _MT_REF_NPAR TEXT ',F5.0,
     1              ' SET _MT_REF_SCUT TEXT ',F5.2,/,
     1          '^^WI SET _MT_REF_GOOF TEXT ',F6.3,
     1              ' SET _MT_REF_MAXRMS TEXT ',F8.4,/,
     1          '^^WI SET _MT_REF_NREF TEXT ',F7.0,/,
     1          '^^CR')
        WRITE ( CMON, 246 ) STORE(L30R),   STORE(L30R+1), STORE(L30R+2),
     1      STORE(L30R+3),  STORE(L30R+4), STORE(L30R+7), STORE(L30R+8)
        CALL XPRVDU(NCVDU, 5, 0)
        IF ( ISTORE ( L30R + 12 ) .EQ. 1 ) THEN
          WRITE (CMON,'(A)') '^^CO SET _MT_REF_COEF TEXT ''F'''
        ELSE IF ( ISTORE ( L30R+12 ) .EQ. 2 ) THEN
          WRITE (CMON,'(A)') '^^CO SET _MT_REF_COEF TEXT ''F squared'''
        ELSE
          WRITE (CMON,'(A)') '^^CO SET _MT_REF_COEF TEXT ''Unknown'''
        END IF
        CALL XPRVDU(NCVDU, 1, 0)

      ENDIF



      RETURN
9900  CONTINUE
      WRITE ( CMON, '(A,/,A)')'Failed to open file : ',CFILEN(1:ILENG)
      CALL XPRVDU(NCVDU, 2,0)
      RETURN
      END



CODE FOR KBDDEV
      FUNCTION KBDDEV ( IAT1P, IAT2P, DEVN )

C Return bond type (1-9) if it is found in the list.
C Return number of stdev's of actual value from mean.

\STORE
\ISTORE
\QSTORE
\TLST18                           

      KBDDEV = 0
      DEVN = 0.0

      IAT1N = ISTORE(IAT1P)     
      IAT1S = NINT(STORE(IAT1P+1))     
      IAT2N = ISTORE(IAT2P)     
      IAT2S = NINT(STORE(IAT2P+1))     
      
        DO 800 I = 1, NB18
                        
            JAT1N = IBLK(I,1)
            JAT1S = NINT(BBLK(I,2))
            JAT2N = IBLK(I,3)
            JAT2S = NINT(BBLK(I,4))

            IF( ( (IAT1N.EQ.JAT1N) .AND. (IAT1S.EQ.JAT1S) .AND.
     1            (IAT2N.EQ.JAT2N) .AND. (IAT2S.EQ.JAT2S) ) .OR.
     2          ( (IAT1N.EQ.JAT2N) .AND. (IAT1S.EQ.JAT2S) .AND.
     3            (IAT2N.EQ.JAT1N) .AND. (IAT2S.EQ.JAT1S) ) ) THEN

               BLEN = BBLK(I,5)
               KBDDEV = NINT(BBLK(I,6))
               DEVN = BBLK(I,8)
               RETURN
            END IF
800   CONTINUE

      RETURN
      END
