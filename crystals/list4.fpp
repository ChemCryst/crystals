C $Log: not supported by cvs2svn $
C Revision 1.43  2003/02/14 17:09:02  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.42  2003/01/14 10:18:26  rich
C Replace CEILING F90 intrinsic with algorithm that does the job. g77 not happy.
C
C Revision 1.41  2002/06/25 11:55:29  richard
C New commands to output to the GUI: (a) wDelSq during agreement analysis, and (b) number
C of outliers during chebychev weighting.
C
C Revision 1.40  2002/06/24 15:32:44  richard
C Add new auto-statistical weighting (Scheme 17).
C Removed old XNAP04 subroutine. (17&18).
C
C Revision 1.39  2002/06/19 10:44:19  richard
C Reformatted most of XAPP04 - go rid of most computed gotos and other such nonsense.
C This version has been thoroughly tested so I'm checking it in before committing some
C real changes. Note that scheme 16 now works on scale of Fc or Fc^2, so backwards compatibility
C is lost. However, compatibility with SHELXL is gained!
C
C Revision 1.38  2002/06/05 16:06:12  richard
C Change header of agreement analysis from /Fo/ to /Fc/.
C Change SHELX weighting scheme so that parameters refer to data on scale
C of FC.
C
C Revision 1.37  2002/05/09 13:12:29  richard
C RIC: Swap red/blue bars for the class, parity and layer agreement
C analyses, to match the Fc/rho plots, which in turn match the
C calculated weighting scheme.
C
C Revision 1.36  2002/04/30 20:24:07  richard
C RIC: Reverse colours of weighted and unweighted agreement plots. (Only
C done for Fc and rho plots so far - the others should be changed for consistency.)
C
C Revision 1.35  2002/03/16 19:07:47  richard
C Removed #VISUALISE command - originally present as prototype for Steve, but
C now graphs are built into other commands.
C
C Revision 1.34  2002/03/12 16:57:44  ckp2
C Changed syntax of analysis/plot command added RFACTOR output as opposed to delta.
C Added index option for plotting analysis by layer in h k and l.
C
C Revision 1.33  2002/03/09 08:43:44  ckp2
C RIC: Correct series name labels.
C
C Revision 1.32  2002/03/01 11:33:42  Administrator
C Correct and improve presntation of weighting scheme in .cif file
C
C Revision 1.31  2002/02/19 16:45:17  ckp2
C Fix _FO graph output when no data in given bin.
C
C Revision 1.29  2002/01/14 12:21:37  ckpgroup
C SH: Added Fo vs. Fc scatter graph (use xfovsfc.ssc).
C
C Revision 1.28  2002/01/08 12:42:43  ckpgroup
C SH: Added Key value to Analyse command. Using '#Analyse Plot FO=KEY' displays a key in the FO Plot.
C
C Revision 1.27  2001/12/12 15:57:52  ckpgroup
C Changed to the new script layout. See Plot.man.
C
C Revision 1.26  2001/11/29 15:45:09  ckpgroup
C SH: Update to reflect script changes.
C
C Revision 1.25  2001/11/23 09:01:21  ckp2
C Zero-value bars were missing from output of reciprocal weights graph in XApp04.
C
C Revision 1.24  2001/11/16 15:39:53  ckp2
C Only output graphs when required. Extinction graph in ANALYSE <Fo>-<Fc> against
C Fo range.
C
C Revision 1.23  2001/11/13 14:52:31  ckp2
C Output reciprocal weights vs /FO/ from XAPP04.
C
C Revision 1.22  2001/11/13 14:08:47  ckp2
C RIC: Swapped weak/strong labels in FO graph. Oops.
C RIC: Increased initial memory allocated to FO and SINt graphs.
C
C Revision 1.21  2001/11/13 13:22:16  ckp2
C New titles for graphs.
C
C Revision 1.20  2001/11/13 12:16:13  ckp2
C RC: Fix graphical output when there is no data for a given bin.
C
C Revision 1.19  2001/11/13 10:53:51  ckpgroup
C SH: Log axis scaling fixed.
C
C Revision 1.18  2001/11/12 16:23:45  ckpgroup
C SH: Graphical agreement analysis
C
C Revision 1.17  2001/11/08 10:52:38  ckp2
C New graphical analyses output - parity group and sin theta/lambda.
C Trim text labels before passing to the GUI.
C
C Revision 1.16  2001/10/17 14:48:53  ckpgroup
C Fix some errors.
C
C Revision 1.15  2001/10/17 13:06:51  ckp2
C Test plot things.
C
C Revision 1.14  2001/09/19 08:50:09  ckp2
C Template #VISUALISE command for Steven's project.
C
C Revision 1.13  2001/07/19 08:02:23  ckp2
C Output /FO/ and Delta**2 headers above the weights analysis.
C
C Revision 1.12  2001/07/13 15:01:53  ckp2
C Bugfix: Line about outliers from chebychev weighting schemes had been lost
C since GUI edits.
C
C Revision 1.11  2001/02/26 10:28:02  richard
C RIC: Added changelog to top of file
C
C
CODE FOR XAPP04
      SUBROUTINE XAPP04(IPROC4,NPROC4)
C--CALCULATE THE WEIGHTS AND STORE THEM
C
C--VARIABLES USED :
C
C  JTYPE   THE TYPE OF /FO/ AND /FC/ TO BE USED :
C
C          0  USE /FO/, /FC/ AND UNIT WEIGHT MODIFIER.
C          1  USE /FO/, /FC/ AND 1/FO AS WEIGHT MODIFIER.
C          2  USE /FO/ **2, /FC/ **2 AS  WEIGHT MODIFIER.
C          3  FIND SUITABLE VALUE OF JTYPE FROM LIST 23
C
C  NW      CONTROL FLAG FOR THE CHEBYSHEV WEIGHTING
C
C          0  APPLY THE PARAMETERS IN LIST 4, WEIGHTING SCHEME TYPE 11.
C          1  CALCULATE THE PARAMETERS, WEIGHTING SCHEME TYPE 10.
C
C  NGW     THE NUMBER OF REFLECTIONS WITH NEGATIVE WEIGHTS.
C  WMX      MAXIMUM WEIHT TO BE APPLIED
C  NMX      NUMBER OF REFLECTIONS WITH MAXIMUM WEIGHT
C  IFTYPE   0 FOR FITTING CHEBYCHEV TO FO
C                 IN THIS CASE, THE FIT IS TO FO AND (DELTA)SQ
C           1 FOR FITTING TO FC (SCHEMES 14 & 15)
C                 IN THIS CASE, THE FIT IS TO LOG(FC) AND SQRT(DELTA)SQ
C
C  A       THE SCALE FACTOR FOR /FC/.
C  H       THE MINIMISATION FUNCTION FOR CHEBYSHEV WEIGHTS.
C  ADW     THE MAXIMUM CHEBYSHEV WEIGHT FOUND.
C  CS      CHEBYSHEV WEIGHTING SCHEME PARAMETER (POWER OF /FO/)
C  AM      MULTILPIER FOR EACH WEIGHT THAT IS PRODUCED :
C
C          1     FOR NORMAL WEIGHTS
C          1/FO  FOR ADDITIVE MODE 1000
C
C  FO      /FO/, OR /FO/ **2 FOR ADDITIVE MODE 2000
C  RFO     THE RECIPROCAL OF 'FO', UNLESS 'FO' IS ZERO, WHEN ZERO IS ASS
C  FC      /FC/, OR /FC/ **2 FOR ADDITIVE MODE 2000
C  AW      THE FINAL WEIGHT
C  WWT      WEIGHT MODIFIER FOR TUKEY ALGORITHM
C  RAW     THE RECIPROCAL OF THE E.S.D. IN LIST 6,  OR ZERO.
C  E       1/F!MAX, OR 1/(F!MAX*F!MAX) FOR ADDITIVE MODE 2000
C          WHERE ! IS O OR C
C  ITL     TYPE LABEL :
C
C                FOR /FO/
C          **2   FOR /FO/ **2, UNDER ADDITIVE MODE 2000.
C
C  NR      ADDRESS OF THE L.H.S. FOR THE CHEBYSHEV ACCUMULATION
C  NS      ADDRESS OF THE R.H.S. FOR THE CHEBYSHEV ACCUMULATION
C  NT      THE ADDRESS OF THE ANSWERS.
C  NU      ADDRESS OF THE DERIVATIVES BEFORE THEY ARE ADDED IN
C  NV      ADDRESS OF THE LAST DERIVATIVE
C
C--
\TYPE11
\ISTORE
\ICOM04
\ICOM30
C
      DIMENSION NPARAM(18)
      CHARACTER*16 IFMT1
      CHARACTER*12 IFMT2
      CHARACTER*4 ITL,  CSQUAR, IBL
      DIMENSION IPROC4(NPROC4)
      DIMENSION IGUI4(2)
C
\STORE
\XSTR11
\XUNITS
\XSSVAL
\XLISTI
\XCHARS
\XCONST
\XLST01
\XLST04
\XLST05
\XLST06
\XLST13
\XLST11
\XLST12
\XLST23
\XLST30
\XERVAL
\XOPVAL
\XIOBUF

C RIC & SH 2002 F90 feature widely supported in F77 - dynamic arrays. These
C               arrays will hold the whole of L6, and could be used by
C               every scheme eventually. It would save a lot of complex
C               looping around down there:

      DIMENSION SHFO(N6D), SHFC(N6D), SIG(N6D)
C Space for automatic determination of Scheme 16 parameters.
      DIMENSION WD(-4:4,-4:4,20), SGF(-4:4,-4:4)
      DIMENSION RWD(20), BMEAN(20)

      FPSX(FOBS,FCALC)      = AMAX1(0.,0.333*FOBS)+0.667*FCALC
      DELSQ(FOBS,FCALC)     = (FOBS-FCALC)**2
      WGHT(SIGS,FP,SXA,SXB) = 1./(SIGS+(SXA*FP)**2+SXB*FP)


\QSTORE
\QLST04
\QSTR11
\QLST30

      DATA CSQUAR / '**2 ' /, IBL / '    ' /
      DATA SMALL / .01 /

C----- NO OF PARAMETERS EXPECTED FOR EACH SCHEME. 0 = UNDEFINED
      DATA NPARAM / 1, 1, 2, 1, 0, 0, 0, 0, 0, 0,
     1              0, 1, 3, 0, 0, 6, 0, 0 /

      DATA IFMT1 / '(I6,2X,20F7.3)  '/
      DATA IFMT2 / '(/7X,20I7)  '/
      DATA MINSCM /1/, MAXSCM /17/

      DATA IVERSN / 530 /

      JPRINT = 0                           ! ENABLE PRINTING OF OUTLIERS
      CALL XTIME1(2)                       ! CLEAR THE TIME

      CALL XCSAE                           ! CLEAR THE CORE
      CALL XRSL

      CALL XFAL01                          ! LOAD LIST 1
      CALL XFAL13                          ! LOAD LIST 13
      CALL XFAL23                          ! LOAD LIST 23
      IF (IERFLG .LT. 0) GOTO 9990

C---- SORT OUT THE INPUT
      CALL XMOVEI(IPROC4, IGUI4, 2)
      IULN06 = KTYP06(IPROC4(3))
C
      IF (ISTORE(L13CD+1) .LE. -1) THEN    ! F = FO
            ITWIN = 3
      ELSE                                 ! F = FOT
            ITWIN = 10
      ENDIF

      IF (ISTORE(L23MN+3) .GE. 0) THEN     ! We are using reflections
        CALL XFAL04                        ! BRING DOWN LIST 4
        IF ( IERFLG .LT. 0 ) GO TO 9900

        IULN=4                             ! SET THE LIST 4 TYPE
        ITYPEO = ITYPE4                    ! STORE ORIGINAL TYPE

        JTYPE=ICON41                 ! FIND THE TYPE OF THIS WEIGHTING SCHEME

        IF (JTYPE .EQ. 3) THEN     ! Auto Fo or FoSqrd set JTYPE automatically.
          IF (ISTORE(L23MN+1) .GE. 0) THEN 
C--FSQ REFINEMENT CHECK IF WE MUST USE 1/2FO, OR /FO/SQ
            IF (  (ITYPE4 .EQ. 10) .OR. (ITYPE4 .EQ. 11) .OR.
     1            (ITYPE4 .EQ. 14) .OR. (ITYPE4 .EQ. 15) .OR.
     1            (ITYPE4 .EQ. 17) .OR. (ITYPE4 .EQ. 16) )    THEN
               JTYPE = 2
               IF (ISSPRT .EQ. 0) WRITE(NCWU,100) '/FO/ **2'
100    FORMAT( 20X, ' LIST 4 weighting type is ', A)
            ELSE
               JTYPE = 1
               IF (ISSPRT .EQ. 0) WRITE(NCWU,100) '1/FO'
            ENDIF
          ELSE                                         ! NORMAL REFINEMENT
            JTYPE = 0
            IF (ISSPRT .EQ. 0) WRITE(NCWU,100) 'NORMAL'
          ENDIF
        ENDIF

        WMX = STORE(L4F+1)               ! SET THE MAXIMUM WEIGHT
        WMXINV = 1./ AMAX1( WMX, ZERO)   ! SET THE RECIPROCAL MAXIMUM WEIGHT
        NMX = 0                          ! COUNT NO. WITH MAXIMUM WEIGHT
        WWT = 1.0                        ! SET A UNIT WEIGHT MODIFIER

        LTEMPR = NFL
        NTEMPR = 6
        NFL = KCHNFL(NTEMPR)  ! GET BUFFER FOR 1 REFELCTION AND -VE WEIGHT
        JSORT = -5
        MDSORT = NTEMPR
        NSORT = 30
        CALL SRTDWN(LSORT,MSORT,MDSORT,NSORT, JSORT, LTEMPR, XVALUR,
     1   -1, DEF)             ! INITIALISE THE BUFFER
        JSORT = 5

        LTEMPE = NFL
        NTEMPE = 7
        NFL = KCHNFL(NTEMPE)  ! GET BUFFER FOR 1 REFLECTION AND ITS MODIFIER
        JENAN = -6
        MDENAN = NTEMPE
        NENAN = 30
        CALL SRTDWN(LENAN,MENAN,MDENAN,NENAN, JENAN, LTEMPE, XVALUE,
     1   -1, DEF2)            ! INITIALISE THE BUFFER
        JENAN = 6

        IF ( ITYPE4 .LT. MINSCM ) GO TO 9930         ! CHECK SCHEME EXISTS
        IF ( ITYPE4 .GT. MAXSCM ) GO TO 9930         ! CHECK SCHEME EXISTS
        IF ((ITYPE4 .EQ. 14) .OR. (ITYPE4 .EQ. 15)) THEN  ! WEIGHT AGAINST FC
          IFTYPE = 1
        ELSE                                              ! WEIGHT ACAINST FO
          IFTYPE = 0   
        ENDIF

        A=1.  ! SET UP THE DEFAULT SCALE FACTOR
        NGW=0 ! SET THE NUMBER OF NEGATIVE WEIGHTS FOUND TO ZERO

        IF(KEXIST(5).GE.1)THEN             ! THERE IS A LIST 5  -  LOAD IT
          CALL XFAL05
          IF ( IERFLG .LT. 0 ) GO TO 9900
          A=STORE(L5O)                     ! GET THE SCALE FACTOR
        END IF

C--CHECK IF LIST 6 EXISTS
        IF (KEXIST(IULN06) .LE. 0) GOTO 9990

        SELECT CASE ( ITYPE4 )  ! JUMP ON THE SORT OF WEIGHTING SCHEME


        CASE (4)       ! SCHEME 4

          IF ( MD4 .LT. NPARAM(ITYPE4) ) GO TO 9940 ! CHECK ENOUGH PARAMETERS GIVEN

        CASE (1:3,5:9,16) ! MOST OTHER WEIGHTING SCHEMES (1,2,3,5,6,7,8,9,16)

          IF ( MD4 .NE. NPARAM(ITYPE4) ) GO TO 9940

          IF (ITYPE4.LE.3) THEN     ! ONE OF FIRST THREE WEIGHTING SCHEMES
            IF ( ABS(STORE(L4)) .LE. ZERO ) GOTO 9950 ! P1 IS A DIVISOR LATER ON
          END IF

        CASE (17) ! Work out parameters for SHELX scheme 16.
        CALL XFAL06(IULN06, 1)
        IF ( IERFLG .LT. 0 ) GO TO 9900

          CALL XFAL06(IULN06, 1)
          IF ( IERFLG .LT. 0 ) GO TO 9900

          IFSQ = ISTORE(L23MN+1)
          RPARS = 1
          IF ( KEXIST(30).GE.1) THEN
           RPARS = STORE(L30RF+2)
          END IF
          N6ACC = 0
          FCMAX = 0.1
          DO WHILE ( KFNR ( 0 ) .GE. 0 )
            N6ACC = N6ACC + 1
            IF (IFSQ .GE. 0) THEN
              CALL XSQRF(FOS, STORE(M6+3), FABS, SIGMAS, STORE(M6+12))
              SHFO(N6ACC) = FOS/MAX(.0001,A**2)
              SHFC(N6ACC) = STORE(M6+5)**2
              SIG(N6ACC) =SIGMAS / MAX(.0001,A**2)
            ELSE
              SHFO(N6ACC) = STORE(M6+3) / MAX(.0001,A)
              SHFC(N6ACC) = STORE(M6+5)
              SIG(N6ACC) = STORE(M6+12) / MAX(.0001,A)
            END IF
            FCMAX = MAX ( FCMAX, SHFC(N6ACC) )
          END DO
C Make up some starting values of A and B:
          SXA = 0.1
          SXB = 0.1
          SXAG = .2 * SXA
          SXBG = .4 * SXB
          DO WHILE ( .TRUE. ) ! Ensure grid doesn't extend below 0:
             SXA = MAX(SXA,4.*SXAG)
             SXB = MAX(SXB,4.*SXBG)
             IF ( SXA .GT. 0.3 ) THEN
               SXA = 0.2
               SXB = 0.0
               EXIT
             END IF
C For each grid point (9x9) calculate 10 wD^2 values corresponding to Fc range.
             DO J = -4,4
                DO K = -4,4
                   DO I = 1,20
                      WD(J,K,I) = 0.0
                      RWD(I) = 0
                      BMEAN(I) = 0.0
                   END DO
                END DO
             END DO
             DO I = 1, N6ACC
                FRACC = MAX(.0000001, SHFC(I)/FCMAX )
                IF (IFSQ .GE. 0) THEN
                   KDIV = MIN(20,INT(20.*SQRT(SQRT(FRACC)))+1)
                ELSE
                   KDIV = MIN(20,INT(20.*SQRT(FRACC))+1)
                END IF
                RWD(KDIV) = RWD(KDIV) + 1.0
                BMEAN(KDIV) = BMEAN(KDIV) + SHFC(I)
                DO J = -4,4
                   DO K = -4,4
                      WD(J,K,KDIV) =  WD(J,K,KDIV)
     1                                + ( DELSQ(SHFO(I),SHFC(I))
     2                                  * WGHT( SIG(I)**2,
     3                                          FPSX(SHFO(I),SHFC(I)),
     4                                          SXA+(REAL(J)*SXAG),
     5                                          SXB+(REAL(K)*SXBG) ) )
                   END DO
                END DO
             END DO                                
             GOOFIT = 999999999
             KBESA = -4
             KBESB = -4
             DO J = -4,4
                DO K = -4,4
                   SUMGF = 0.0
                   DO I = 1,20
                      AWD = WD(J,K,I) *(REAL(N6ACC)/(REAL(N6ACC)-RPARS))
                      AWD = MAX ( 0.000001, AWD )
                      SUMGF = SUMGF + RWD(I) * (
     1                                 LOG  (
     2                                    MAX( .0001,
     3                                    SQRT(
     4                                         AWD / MAX( 0.01, RWD(I) )
     5                                   ))))**2
                   END DO

                   SGF(J,K) = SUMGF
          
                   IF ( SUMGF .LT. GOOFIT ) THEN
                      GOOFIT = SUMGF
                      KBESA = J
                      KBESB = K
                   END IF
                END DO
             END DO
             SXA = SXA + (REAL(KBESA)*SXAG)
             SXB = SXB + (REAL(KBESB)*SXBG)
             WRITE(CMON,'(/A,2F10.4,A)')' Best fit this cycle: ',
     1       SXA,SXB, ' .0 .0 .0 .333'
             CALL XPRVDU(NCVDU,2,0)
             WDTO = 0.0
             DO I = 1,N6ACC
               WDTO = WDTO + ( DELSQ(SHFO(I),SHFC(I))
     2                                * WGHT( SIG(I)**2,
     3                                        FPSX(SHFO(I),SHFC(I)),
     4                                        SXA,
     5                                        SXB ) )
             END DO
             SGOF = SQRT(MAX(.001,WDTO / (REAL (N6ACC) - RPARS )))
             WDTO = WDTO / REAL ( N6ACC )
             WRITE ( CMON, '(2(A,F10.4),/)')
     1        '           <wdelsq> : ', WDTO,
     2        '          S : ', SGOF
             CALL XPRVDU(NCVDU,2,0)
C Best fit at a high edge of the grid: increase spacing.
             IF ( KBESA .EQ. 4 ) SXAG = SXAG * 2.0
             IF ( KBESB .EQ. 4 ) SXBG = SXBG * 2.0
             IF ( ( KBESA .EQ. 4 ) .OR. ( KBESB .EQ. 4 ) ) CYCLE
C Best fit at a low edge, or very small parameters:
             IF ((SXA.LT.0.0001).OR.(KBESA .NE. -4)) SXAG = SXAG * .25
             IF ((SXB.LT.0.001 ).OR.(KBESB .NE. -4)) SXBG = SXBG * .25
C Check for convergence:
             IF ( SXAG .GT. 0.0001 ) CYCLE
             IF ( SXBG .GT. 0.005  ) CYCLE
C Converged!
             IF ( SXA .GE. 0.2 ) THEN
                SXA = 0.2
                SXB = 0.0
             END IF
             EXIT
          END DO
          WRITE ( CMON,'(A,2F10.4,A)') '     Weights applied: ',SXA,SXB,
     1                             ' .0 .0 .0 .333'
          CALL XPRVDU(NCVDU,1,0)
          CALL XCSAE                     ! CLEAR THE LIST ENTRIES
          IRCZAP = 0
\IDIM04
          CALL XFILL (IRCZAP, ICOM04, IDIM04)
          N4 = 6
          N4C = 4
          N4F = 5
          CALL XCELST ( 4, ICOM04, IDIM04 )
C--MOVE THE PARAMETERS TO LIST 4
          STORE(L4) = SXA
          STORE(L4+1) = SXB
          STORE(L4+2) = 0.0
          STORE(L4+3) = 0.0
          STORE(L4+4) = 0.0
          STORE(L4+5) = 0.33333
          ITYPE4 = 16
          ISTORE(L4C) = ITYPE4
          ISTORE(L4C+1) = 3
          STORE(L4F) = 2.0
          STORE(L4F+1) = 10000.0
          MD4=6
C--WRITE THE NEW LIST OUT TO DISC
          CALL XWLSTD(IULN,ICOM04,IDIM04,-1,-1)

        CASE (10:11,14:15)  ! CHEBYSHEV TYPE WEIGHTING  - 10,11,14,15

          NX=0      ! SET THE NUMBER OF REFLECTIONS USED TO ZERO
          ADW=0.    ! SET THE MAXIMUM CHEBYSHEV WEIGHT AS ZERO INITIALLY
          H=0.      !SET THE CHEBYSHEV MINIMISATION FUNCTION AS ZERO INITIALLY
          IF ( MD4 .LE. 1 ) GO TO 9910 !NEED AT LEAST TWO COEFFICIENTS

C--CHECK IF WE CALCULATING OR JUST APPLYING CHEBYSHEV WEIGHTS
          IF ((ITYPE4 .EQ. 11).OR.(ITYPE4 .EQ. 15)) THEN ! APPLY WEIGHTS - SET UP LIST 6
            CALL XFAL06(IULN06, 1)
            IF ( IERFLG .LT. 0 ) GO TO 9900
            CALL XIRTAC(5)
            NW=0           ! INDICATES ONLY AN APPLICATION
          ELSE             ! CALCULATING WEIGHTS, SET UP INITIAL PASS OF L6.
            CALL XFAL06(IULN06, 1)
            IF ( IERFLG .LT. 0 ) GO TO 9900
            NW=1 ! SET CHEBYSHEV POINTER FOR THE CALCULATION OF THE PARAMETERS
            LN=12  ! SET UP A DUMMY LIST 12 (so we can use SFLS matrix area)
            IREC=8001
            N12=MD4
            MD12B=2
            N12B=1
            L12B=KCHLFL(MD12B)
            ISTORE(L12B)=1
            ISTORE(L12B+1)=MD4
            IOLD=-1
            CALL XSET11 (IOLD,1,1)           ! SET UP THE MATRIX AREA
            IF ( IERFLG .LT. 0 ) GO TO 9900
C--ASSIGN A FEW POINTERS
            NR=L11
            NS=L11R
            LN=IULN
            NT=KADD11(1001,MD11,MD4)         ! SET UP THE ANSWERS AREA
            IF ( IERFLG .LT. 0 ) GO TO 9900
            IREC=1002
            NU=NFL
            NV=KCHNFL(MD4)-1                 ! SET THE PARTIAL DERIVATIVE AREA
          ENDIF


          CS=0.
          EW=1.0
          IF (IFTYPE .EQ. 0) THEN
            M6DTL=L6DTL+3*MD6DTL  
            E=STORE(M6DTL+1)       ! FETCH THE MAXIMUM VALUE OF /FO/
          ELSE
            M6DTL = L6DTL + 5*MD6DTL
            E = A* STORE(M6DTL+1)  ! FETCH THE MAXIMUM VALUE OF /FC/
          ENDIF

          IF(JTYPE .EQ. 2 ) THEN    ! CHECK TYPE OF REFINEMENT
            ITL = CSQUAR    ! THIS IS REFINEMENT AGAINST /FO/ **2
            E=E*E
          ELSE
            ITL = '    '    ! SET /FO/ TYPE AS NOT THE SQUARED VARIETY
          ENDIF
          IF (IFTYPE .NE. 0)      E = LOG(E)  ! FC FITTING AGAINST LOG(FC)
          E=1.0/E  ! SET UP THE CORRECT DIVISOR

          IF ((ITYPE4 .EQ. 11).OR.(ITYPE4 .EQ. 15)) GOTO 5100  ! APPLY WEIGHTS
          CS = STORE(L4F)  ! SET UP THE WEIGHTING PARAMETER
          EW=(1.0/E)**CS

          IF(KFNR(0).GE.0) GOTO 2450
          GOTO 9980 !An error, no reflections.

        CASE (12)     ! WEIGHTING SCHEME 12 ON SIN(THETA)

          AP=-1.0
          IF(MD4.LE.0) THEN   ! CHECK FOR A PARAMETER
            IF ( MD4 .NE. NPARAM(ITYPE4) ) GO TO 9940
          ELSE                ! A PARAMETER HAS BEEN GIVEN
            AP=STORE(L4)
          END IF

        CASE (13)        ! MODIFY EXISTING WEIGHTS (DUNITZ-SEILER)

          AP=-1
          IF(MD4.LE.0) THEN
            IF ( MD4 .NE. NPARAM(ITYPE4) ) GO TO 9940
          ELSE  ! CHECK SECOND IS NON ZERO
            AP=STORE(L4)
            APP=STORE(L4+1)
            IF ( ABS ( APP ) .LE. ZERO ) GO TO 9940
          END IF

        CASE DEFAULT ! ERROR

          GOTO 9980 

        END SELECT

        CALL XFAL06(IULN06,1)
        IF ( IERFLG .LT. 0 ) GO TO 9900
        CALL XIRTAC(5)       ! CLEAR THE ACCUMULATION AREA FOR THE WEIGHT
        GOTO 5100            ! START APPLYING WEIGHTS



C                                                                       C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                       C


C - Jump back here from bottom of loop (5100), after loading next
C - reflection.
C - OR, jump back from Chebychev solve(10&14), after loading next
C - allowed reflection.

C--PROCESS THE NEXT REFLECTION  -  CHECK THAT THE CURRENT /FO/ IS NOT ZE

2450    CONTINUE
        FO= ABS(STORE(M6+ITWIN))
        AW=STORE(M6+12)  ! SET WEIGHT TO THE SIGMA VALUED STORED IN LIST 6
        FC=STORE(M6+5)*A ! CONVERT TO SCALE of Fo.
        AM=1.0
C--SET UP THE INVERSE VALUES
        RFO=0.
        RAW=0.

C----------- CHECK THAT /FO/ IS LARGE ENOUGH
cdjw aug99 - try to controll weighting of Fsq refinenent for small Fs

        IF((FO).GT.aw)THEN ! /FO/ IS LARGE ENOUGH - COMPUTE ITS INVERSE
           RFO=1./FO
        ELSE               ! /FO/ IS ZERO - SET TO SMALL VALUE TO AVOID 0**0
           rfo = 1. /max(fo, fc, aw, 2.)
           FO=ZEROSQ
        ENDIF

        IF(ABS(AW).GT.ZERO) THEN  ! CHECK THE SIZE OF THE SIGMA TERM
          RAW=1./AW               ! WEIGHT LARGE ENOUGH- COMPUTE ITS INVERSE
        END IF

C--CHECK IF WE ARE REFINING AGAINST /FO/ **2

        IF(JTYPE.EQ.1) THEN      ! WGHTS FRM /FO/, MODIFD TO BE AGAINST FO**2
          am = 0.5 / max(fo, fc, aw, 2.)
        ELSE IF ( JTYPE .GE. 2 ) THEN    ! WEIGHTS COMPUTED FROM /FO/ **2,
          if (fo .le. aw) then           ! SO COMPUTE SIGMA**2
            AW=2.0*AW*max(FO,fc,aw,2.)   
          else
            AW=2.0*AW*FO
          endif
          FO=FO*FO
          FC=FC*FC
        END IF



        SELECT CASE (ITYPE4)   ! BRANCH ON THE TYPE OF WEIGHTING SCHEME

        CASE DEFAULT 
           CALL GUEXIT(377)

        CASE (1)               ! SQRT(W) = FO/P(1), OR P(1) IF FO>P(1)

          IF(FO.LE.STORE(L4)) THEN
            AW=FO/STORE(L4)
          ELSE
            AW=STORE(L4)*RFO
          END IF

          IF(AW .LT. 0.0) THEN
              AW = ZERO
              NGW = NGW+1
          ENDIF

          AW = AW*AW

        CASE (2)               ! SQRT(W) = 1, OR P(1)/FO IF FO>P(1)

          AW=1.
          IF(FO.GT.STORE(L4)) AW = STORE(L4)*RFO
          IF(AW .LT. 0.0) THEN
              AW = ZERO
              NGW = NGW+1
          ENDIF

          AW = AW*AW

        CASE (3)               ! W = 1/(1+[(FO-P(2))/P(1)]**2)

          AW= 1./ (1.+((FO-STORE(L4+1))*(FO-STORE(L4+1)))/
     1        (STORE(L4)*STORE(L4)  ))


        CASE (4)               ! 1/(P(1)+FO+P(2)*FO**2+. . . )

          AW=STORE(L4)+FO
          F=FO
          M=L4
          IF (MD4.GT.1) THEN    ! CHECK IF THE SERIES HAS MORE THAN ONE TERM
            DO L=2,MD4            !ADD IN THE REMAINING TERMS
              F=F*FO
              M=M+1
              AW=AW+F*STORE(M)
            END DO
            AW = 1. / AW
          END IF
                               
        CASE (5)               ! W = STORE(M6+4)

          AW=STORE(M6+4)

        CASE (6)               ! SQRT(W) = STORE(M6+4)

          AW=STORE(M6+4)
          IF(AW .LT. 0.0) THEN
              AW = ZERO
              NGW = NGW+1
          ENDIF
          AW = AW*AW

        CASE (7)               ! W = 1/SIGMA(/FO/)

          AW=RAW

        CASE (8)               ! W = 1/SIGMA(/FO/)**2

          AW=RAW
          IF(AW .LT. 0.0) THEN
              AW = ZERO
              NGW = NGW+1
          ENDIF

          AW = AW*AW

        CASE (9)               !UNIT WEIGHTS

          AW=1.

        CASE (10,14)           !CALCULATE THE CHEBYSHEV COEFFICIENTS

          B = (FO - FC) * (FO - FC)
          IF (IFTYPE .EQ. 0) THEN
            G=2.*FO*E-1.
          ELSE
            G = 2. * (LOG(AMAX1(1.,FC))*E) -1.
            B = SQRT(B)
          ENDIF
          STORE(NU)=1.
          STORE(NU+1)=G
          IF(MD4.GT.1)THEN  ! ACCUMULATE TERMS HIGHER THAN 2
            NQ=NU+2
            DO L=3,MD4
              STORE(NQ)=2.*G*STORE(NQ-1)-STORE(NQ-2)
              NQ=NQ+1
            END DO
          END IF
          W=EW/(1.+Fc**CS)  !COMPUTE THE WEIGHTS FOR THIS REFLECTION
          NQ=NR
          NP=NS
          DO L=NU,NV          !ACCUMULATE THE LEAST SQUARES MATRIX
            DO M=L,NV         !THE LEFT HAND SIDE
              STR11(NQ)=STR11(NQ)+STORE(L)*STORE(M)*W
              NQ=NQ+1
            END DO
            STR11(NP)=STR11(NP)+STORE(L)*B*W !THE RIGHT HAND SIDE
            NP=NP+1
          END DO

C--Not applying weights for 10 or 14, so FETCH THE NEXT REFLECTION
          IF(KFNR(0).GE.0) GOTO 2450

C--No more reflections.

          CALL XCHOLS(MD4,NR,NT)  !SOLVE THE CHEBYSHEV CASE
          CALL XSOLVE(MD4,NR,NS,NT)
    
          CALL XCSAE              !CLEAR THE LIST ENTRIES
          CALL XFAL04             !RELOAD LIST 4
          IF ((ITYPE4 .EQ. 10) .OR. (ITYPE4 .EQ. 14)) THEN
            NP=NT                           !MOVE THE PARAMETERS TO LIST 4
            NQ=L4
            DO L=1,MD4
              STORE(NQ)=STR11(NP)
              NP=NP+1
              NQ=NQ+1
            END DO
            IF (ITYPE4 .EQ. 10) THEN !ALTER TYPE TO 11, APPLY THE PARAMETERS
              ITYPE4=11
            ELSE IF (ITYPE4 .EQ. 14) THEN  !ALTER TYPE TO 15
              ITYPE4 = 15
            ENDIF
          ELSE
              GOTO 9980  !PROGRAMMING ERROR
          ENDIF
          NX=0   !SET THE NUMBER OF REFLECTIONS USED TO ZERO
          ADW=0. !SET THE MAXIMUM CHEBYSHEV WEIGHT AS ZERO INITIALLY
          H=0.   !SET THE CHEBYSHEV MINIMISATION FUNCTION AS ZERO INITIALLY
C--Start again as 11 or 15, this time apply the weights:
          CALL XFAL06(IULN06,1)
          IF ( IERFLG .LT. 0 ) GO TO 9900
          CALL XIRTAC(5) ! CLEAR THE ACCUMULATION AREA FOR THE WEIGHT
          GOTO 5100

        CASE (11,15)           ! APPLY CHEBYCHEV WEIGHTS

          F=FO-FC
          F=F*F
          FSQ = F
          IF (IFTYPE .EQ. 0) THEN
            G=2.*FO*E-1.
          ELSE
            F = SQRT(F)
            G = 2. * (LOG(AMAX1(1.,FC))*E) -1.
          ENDIF
          B=1.                  
          C=G
          AW=B*STORE(L4)
          IF ( MD4 .GE. 3 ) THEN    ! MORE THAN TWO TERMS
            M=L4+2
            DO L=3,MD4
              D=2.*G*C-B
              AW=AW+D*STORE(M)
              M=M+1
              B=C
              C=D
            END DO
          END IF
          IF ( MD4 .GE. 2 ) THEN ! TWO OR MORE TERMS - ADD IN THE SECOND TERM
            AW=AW+G*STORE(L4+1)
          END IF
          IF ( NW .GE. 1 ) THEN   !CHECK IF WE SHOULD ACCUMULATE THE VARIANCE
            IF( KALLOW(I) .GE. 0 ) THEN ! REFLECTION TOOK PART IN FORMING COEFFICIENTS
              NX=NX+1         
              F=AW-F
cdjw99              H=H+F*F*EW/(1.+FO**CS)
              H=H+F*F*EW/(1.+Fc**CS)
            END IF
          END IF

          IF (IFTYPE .EQ. 1) AW = AW * AW   ! FIND MAX INVERSE WEIGHT
          ADW=AMAX1(ADW,AW)

          AWI = AW                          ! SAVE INVERSE WEIGHT
          IF (AW .LT. WMXINV) THEN          ! INVERSE WEIGHT TOO SMALL
            AW = WMXINV
          ENDIF
          AW = 1. / AW                      !GET ACTUAL WEIGHT

          IF (ITYPE4 .EQ. 15)  THEN         !TUKEY-PRINCE SCHEME (SCHEME 15)
            CALL XMODWT (FSQ, AWI, WWT, JPRINT, jtype, 36.0) !APPLY WEIGHT MODIFIERS
            IF (WWT .LT. XVALUE) THEN        !WRITE TO OUTLIER BUFFER
              CALL XMOVE(STORE(M6), STORE(LTEMPE), 3)  !H,K,L,FO,FC,WWT
              STORE(LTEMPE+3) = FO
              STORE(LTEMPE+4) = FC
              STORE(LTEMPE+5) = SQRT(FSQ/(AWI+ZEROSQ))
              STORE(LTEMPE+6) = WWT
              CALL SRTDWN(LENAN,MENAN,MDENAN,NENAN,
     1           JENAN, LTEMPE, XVALUE, -1, DEF2)
            ENDIF
          ENDIF

        CASE (12)               !A FUNCTION OF SIN(THETA)/LAMBDA

          AW=SQRT(SNTHL2(L))**AP

        CASE (13)               ! DUNITZ-SEILER MODIFY EXISTING WEIGHTS
          A=SNTHL2(L)
          AW=STORE(M6+4)*STORE(M6+4)*EXP(4.*TWOPIS*A*AP/APP)

        CASE (16)              ! SHELXL WEIGHTS

C -- Convert everything to scale of FC: (for SHELX compatibility).
          IF ( JTYPE .EQ. 2 ) THEN   ! Fo**2 refinement
            SFCSIG = AW / A**2
            SFCFO  = FO / A**2
            SFCFC  = FC / A**2
          ELSE                       ! Fo refinement
            SFCSIG = AW / A
            SFCFO  = FO / A
            SFCFC  = FC / A
          END IF
          STHOLS = SNTHL2(L)
          STH = SQRT(STHOLS)*STORE(L13DC)
          Q = EXP (STORE(L4+2) * STHOLS)
          IF ( ABS(STORE(L4+2)) .LE. ZERO) THEN
            Q = 1.
          ELSE IF (STORE(L4+2) .LT. ZERO ) THEN
            Q =  1. - Q
          ENDIF
          P = STORE(L4+5) * MAX(0., SFCFO) + (1-STORE(L4+5))*SFCFC
          AW = Q / 
     1     (SFCSIG*SFCSIG + (P*STORE(L4))*(P*STORE(L4)) +
     2     STORE(L4+1)*P + STORE(L4+3) + STORE(L4+4)*STH) 
C -- Convert weight back onto scale of FO:
          IF ( JTYPE .EQ. 2 ) THEN
            AW = AW / A**4
          ELSE
            AW = AW / A**2
          END IF

        END SELECT
c
c
c
c
c


C--APPLY ROBUST-RESISTANT TO ANY WEIGHTING SCHEME (except 15!)
        IF ((IROBUS .EQ. 1) .AND. (ITYPE4.NE.15)) THEN
           FSQ = (FO-FC)**2
           IF (AW .LE. ZERO) THEN         !WEIGHT TOO SMALL
             AWI = WMX                    !SET INV W TO WMX.
           ELSE
             AWI = 1./AW                  !GET ACTUAL INVERSE
           ENDIF

           CALL XMODWT (FSQ, AWI, WWT, JPRINT, jtype, ROBTOL**2)

           IF (WWT .LT. XVALUE) THEN       ! WRITE TO OUTLIER BUFFER
              CALL XMOVE(STORE(M6), STORE(LTEMPE), 3) ! H,K,L,FO,FC,WWT
              STORE(LTEMPE+3) = FO
              STORE(LTEMPE+4) = FC
              STORE(LTEMPE+5) = SQRT(FSQ/(AWI+ZEROSQ))
              STORE(LTEMPE+6) = WWT
              CALL SRTDWN(LENAN,MENAN,MDENAN,NENAN,
     1           JENAN, LTEMPE, XVALUE, -1, DEF2)
           ENDIF
        ENDIF

C--APPLY DUNITZ-SEILER TO ANY WEIGHTING SCHEME (except 13!)
        IF ((IDUNIT .EQ. 1) .AND. (ITYPE4.NE.13)) THEN
           A=SNTHL2(L)
           AW=AW*EXP(4.*TWOPIS*A*DUN01/DUN02)
        END IF

        IF (WWT .LE. 0.0) THEN             ! WRITE OUTLIERS TO LISTING FILE
          IF (JPRINT .EQ. 1) THEN
            IF (ISSPRT .EQ. 0) WRITE(NCWU,  '( '' Outliers '',
     1    3X,''h'',3X, ''k'',3X, ''l'',4X, ''F obs'', 4X,
     2    ''F calc'', 3X, ''Delta sq'', 1X, ''Est delta sq'')' )
          ENDIF
          IF ((JPRINT .GT. 0) .AND. (JPRINT .LT. 60)) THEN
            IF (ISSPRT .EQ. 0) WRITE(NCWU,'(10X, 3I4,2F10.2,2G10.2)')
     1      NINT(STORE(M6)), NINT(STORE(M6+1)), NINT(STORE(M6+2)),
     2      FO, FC, FSQ, AWI
          ELSE IF (JPRINT .EQ. 60 ) THEN
            IF (ISSPRT .EQ. 0)WRITE(NCWU, '(1X,'' And so on .......'')')
          ELSE
            CONTINUE
          ENDIF
        ENDIF

        IF(AW .LT. 0.0) THEN
            AW = ZEROSQ
            NGW = NGW+1
        ENDIF

        IF (AW .LT. XVALUR) THEN     ! WRITE TO SMALL WEIGHT BUFFER
           CALL XMOVE(STORE(M6), STORE(LTEMPR), 3) ! H,K,L,FO,FC,AW
           STORE(LTEMPR+3) = FO
           STORE(LTEMPR+4) = FC
           STORE(LTEMPR+5) = AW
           CALL SRTDWN(LSORT,MSORT,MDSORT,NSORT, JSORT,
     1       LTEMPR, XVALUR, -1, DEF)
        ENDIF

        AW = AW * WWT   ! Modify for robust-resistantness.

        IF (AW .GT. WMX) THEN   ! CHECK IF TOO LARGE
          AW  = WMX
          NMX = NMX + 1
        END IF


        AW=SQRT(AW)             ! STORE THE SQUARE ROOT OF THE WEIGHT


        STORE(M6+4)=AM*AW   !STORE THE LAST REFLECTION
        CALL XSLR(1)
        CALL XACRT(5)

5100    CONTINUE
        IF(KLDRNR(1).GE.0) GOTO 2450  !FETCH THE NEXT REFLECTION


C                                                                       C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C                                                                       C

5150    CONTINUE  ! TIDY UP AND END

        IF (( ITYPE4 .EQ. 10 ) .OR. ( ITYPE4 .EQ. 14 ) ) GOTO 9975
        IF ( ITYPE4 .GT. 17 ) GOTO 9930

        IF ((( ITYPE4 .EQ. 11 ) .OR. ( ITYPE4 .EQ. 15 )) .AND.
     1     ( NW .EQ. 1 )) THEN !PRINT RESULTS OF CHEBYSHEV SOLUTION FOR /FO/

          B=H/FLOAT(NX-MD4)
          CALL XPRTCN
          F=1./E
C-- RESTORE 'E' (AS F!)
          IF (IFTYPE .EQ. 1)      F =  EXP(F)
          IF (ISSPRT .EQ. 0) WRITE(NCWU,5800) MD4, ITL, F, B, IBL, CS
5800      FORMAT(33H Chebyshev weighting scheme for  ,I2,7H  terms//
     2    13H Maximum /FO/,A3,4H =  ,G11.2,10X,21H Estimated variance =,
     3    G14.5, A4, /, 9X, 14H/Fo/ weight = , F6.2)
          IF (ISSPRT .EQ. 0) WRITE(NCWU,5850)
5850      FORMAT(//,' Terms',7X,'Coefficients',11X,'E.S.D.''S',4X,
     1    'Ratios',//)
          NQ=NT   ! SET THE POINTERS 
          NP=NR   ! TO PRINT THE RESULTS
          DO L=1,MD4    ! PRINT THE RESULTS
            C=STR11(NP)
            C=SQRT(C*B)
            D=0.
            DD=STR11(NQ)
            IF(C.GT.0.0000001) THEN   ! CHECK FOR A SINGULARITY
              D=DD/C                  ! NOT SINGULAR  -  COMPUTE THE RATIO
            END IF
            IF (ISSPRT .EQ. 0) WRITE(NCWU,6000)L,DD,C,D
6000        FORMAT(I4,2F20.5,F10.2)
            NQ=NQ+1
            NP=NP+MD4-L+1
          END DO        !END PRINT RES

          STORE(L11P+16)=FLOAT(NX-MD4) !SET THE DETAILS FOR LIST 11
          STORE(L11P+17)=H
          CALL XFCM
          IF (ISSPRT .EQ. 0) WRITE(NCWU,6100)
6100      FORMAT(//,' Correlation matrix')
          CALL XPRTNM ( 16 , IFMT1 , IFMT2 )
          ISTORE(L4C)=ITYPE4 ! SET THE NEW WEIGHTING SCHEME TYPE
\IDIM04
          CALL XWLSTD(IULN,ICOM04,IDIM04,-1,-1) ! WRITE NEW LIST OUT TO DISC

C--PRINT THE PLOT OF PREDICTED W*DELTA**2 AGAINST /FO/
          CALL XPRTCN
          CALL XLINES
          IF (ISSPRT .EQ. 0) WRITE(NCWU,6150)ITL,ITL
          WRITE(CMON,6150)ITL,ITL
          CALL XPRVDU(NCVDU, 5,0)
          WRITE(CMON,6160) ITL
          CALL XPRVDU(NCVDU, 1,0)

          IF ( IGUI4(1) .EQ. 1 ) THEN
            WRITE(CMON,'(A,/,A,/,A)')
     1      '^^PL PLOTDATA _CLASS BARGRAPH ATTACH _RWGHT',
     1      '^^PL XAXIS TITLE ''Reciprocal weights vs /FO/''',
     1   '^^PL NSERIES=1 LENGTH=20 YAXIS TITLE ''estimated <Fo-Fc>**2'''
          CALL XPRVDU(NCVDU, 3,0)
          END IF

6160      FORMAT( ' Reciprocal weights versus /FO/' ,A3)
6150      FORMAT(40H Plot of estimated delta**2 against /FO/,A3///9X,4H/
     2FO/ ,A3,2X,8HDelta**2/)
          CDW=0. 
          F=SQRT(F)/40.   ! SET INTERVAL IN FSQ
          IF (JTYPE .EQ. 2) ADW = SQRT(ADW) ! WATCH OUT FOR FSQ FITTING
          IMXWID = 56       ! SET MAX WIDTH
          ADW= FLOAT(IMXWID)/ADW
          DO NDW=1,10000  ! PASS OVER EACH RANGE OF /FO/
C--COMPUTE WEIGHT
            CDW=CDW+F
            EDW=CDW*CDW
            IF (IFTYPE .EQ. 0) THEN
                BDW=EDW*E
            ELSE
                BDW = LOG(AMAX1(1.,EDW))*E
            ENDIF

            IF(BDW-1.)6200,6200,6750 ! CHECK FOR THE END OF THE RANGE
6200        CONTINUE
            G=2.*BDW-1.
            B=1.
            C=G
            WDW=B*STORE(L4)
            IF(MD4-2)6400,6350,6250 ! CHECK THE NUMBER OF TERMS INVOLVED
6250        CONTINUE
            M=L4+2
            DO L=3,MD4    ! LLOOP
              D=2.*G*C-B
              WDW=WDW+D*STORE(M)
              M=M+1
              B=C
              C=D
            END DO        ! LLOOP
6350        CONTINUE
            WDW=WDW+G*STORE(L4+1)
            IF (JTYPE .EQ. 2) THEN
              EDW = SQRT(EDW) ! FITTING TO FSQ, TAKE ROOT TO GET NICE GRAPH
              IF (WDW .GT. ZERO) THEN
                    WDW = SQRT(WDW)
              ELSE
                    WDW = ZERO
              ENDIF
            ENDIF
C--FIND THE POINT ON THE PAGE
6400        CONTINUE
            IF (IFTYPE .EQ. 1)       WDW = WDW * WDW
            JDW=NINT(ADW*WDW)
C--CHECK THAT THE POINT IS ON THE PAGE
            IF(JDW)6650,6650,6450
6450        CONTINUE
            L=MINUS
C--CHECK THAT THE POINT IS NOT OFF THE PAGE
            IF(JDW-IMXWID)6550,6550,6500
6500        CONTINUE
            L=IPLUS
            JDW=IMXWID
C--PRINT THE LINE FOR THIS /FO/
6550        CONTINUE
            IF (ISSPRT .EQ. 0)WRITE(NCWU,6600)EDW,WDW,(L,JJ=1,JDW)
6600        FORMAT(1H ,E12.4,E13.2,2H I,101A1)
            JDW=MIN0(JDW,57)
            WRITE(CMON,6630)EDW ,WDW, (L,JJ=1,JDW)
            CALL XPRVDU(NCVDU, 1,0)
            IF ( IGUI4(1) .EQ. 1 ) THEN
              WRITE(CMON,'(A,F7.2,A,F15.7)')'^^PL LABEL ',
     2         EDW,' DATA ', WDW
              CALL XPRVDU(NCVDU, 1,0)
            ENDIF
6630        FORMAT(1X,E10.3,E10.3,2X,60A1)
            CYCLE
6650        CONTINUE
            IF (ISSPRT .EQ. 0) WRITE(NCWU,6600)EDW,WDW
            WRITE(CMON,6630) EDW,WDW
            CALL XPRVDU(NCVDU, 1,0)
            IF ( IGUI4(1) .EQ. 1 ) THEN
              WRITE(CMON,'(A,F7.2,A,F15.7)')'^^PL LABEL ',
     2         EDW,' DATA ', WDW
            CALL XPRVDU(NCVDU, 1,0)
            ENDIF
          END DO
6750      CONTINUE
          IF ( IGUI4(1) .EQ. 1 ) THEN
            WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
            CALL XPRVDU(NCVDU, 2,0)                                          
          ENDIF
          CALL XLINES
        END IF

        CALL XCRD(5)
        CALL XERT(IULN06)

        IF (ITYPE4 .EQ. 5) ITYPE4 = 6 ! HAVING TAKEN ROOT W ONCE, NOW KEEP W
        IF (ITYPE4 .NE. ITYPEO) THEN  ! CHANGES FROM 5, 10, 14- REWRITE LIST 4
\IDIM04
          CALL XWLSTD(4, ICOM04, IDIM04,-1,-1) ! WRITE THE NEW LIST OUT TO DISC
      ENDIF

      ENDIF


C--FORM LIST 36 AND OUTPUT IT
5560  CONTINUE
      CALL XCELST(36,ICOM04,4)
      CALL XWLSTD(36,ICOM04,4,-1,0)
C--PRINT THE FINAL CAPTION
C----- WARN USER IF ANY WEIGHTS ARE NEGATIVE
c----- write the buffers
      WRITE ( NCAWU ,'(/I6, '' Low weights'')') NGW
      IF (NGW .GT. 0) THEN
       WRITE(NCAWU,11)
11     FORMAT(2('   h   k  l       Fo        Fc     Wt',2X))
         DO 5565 MSORT = LSORT, LSORT+(NSORT-1)*MDSORT, 2*MDSORT
         WRITE ( NCAWU ,
     *  '(3I4, 2F9.1, F7.2, 2X,3I4, 2F9.1, F7.2)')
     1  ( (NINT(STORE(IXAP)), IXAP=JXAP, JXAP+2),
     2  (STORE(IXAP), IXAP= JXAP+3,JXAP+5),
     3  JXAP= MSORT, MSORT+MDSORT, MDSORT)
5565    CONTINUE
      ENDIF

C--For SCHEME 15 print outliers etc.
      IF (((ITYPE4.EQ.15).OR.(IROBUS.EQ.1)) .AND. (JPRINT .GT .0)) THEN
6110      FORMAT(/I6,' Outliers,      N= Abs(delta)/Estimated(delta)')
          WRITE ( CMON, 6110) JPRINT
          CALL XPRVDU(NCVDU, 2,0)
          WRITE(CMON,6111)
6111      FORMAT (2('   h   k   l      Fo       Fc     N    '))
          CALL XPRVDU(NCVDU, 1,0)
          DO MENAN = LENAN, LENAN+(NENAN-1)*MDENAN, 2*MDENAN
             IF (STORE(MENAN+13) .GT. ZERO) CYCLE
             WRITE ( CMON,'(3I4, 2F9.1, F7.2, 2X,3I4, 2F9.1, F7.2 )')
     1         ( (NINT(STORE(IXAP)), IXAP=JXAP, JXAP+2),
     2         (STORE(IXAP), IXAP= JXAP+3,JXAP+5),
     3         JXAP= MENAN, MENAN+MDENAN, MDENAN)
             CALL XPRVDU(NCVDU, 1,0)
          END DO
      ENDIF

      IF (NGW .GT. 0) GOTO 9920
5570  CONTINUE
C--CHECK IF ANY REFLECTIONS HAVE BEEN FOUND WITH NEGATIVE WEIGHTS
      IF(NGW)5450,5450,5200
C--CHECK IF ALL THE REFLECTIONS HAVE NEGATIVE OR ZERO WEIGHTS
5200  CONTINUE
      IF ( NGW .GE. N6D ) GO TO 9960
C--PRINT OUT THE NUMBER OF REFLECTIONS WITH NEGATIVE WEIGHTS
      IF (ISSPRT .EQ. 0) WRITE(NCWU,5400)NGW,N6D
5400  FORMAT(/,I6,' Reflections with small or negative weights',
     2 ' out of a total of ',I6/)
5450  CONTINUE
C----- WARN OF MAXIMAL WEIGHTS
      IF (NMX .GT. 0) THEN
            IF (ISSPRT .EQ. 0) WRITE(NCWU,5580) NMX,WMX
            WRITE(CMON,5580) NMX, WMX
            CALL XPRVDU(NCVDU, 1,0)
5580  FORMAT(1X, I6, ' Reflections have been given the maximum',
     1 ' weight of ', F10.2)
      ENDIF
C----- WARN OF OUTLIERS
      IF(JPRINT .GT. 0) THEN
            WRITE(CMON,5585) JPRINT
            CALL XPRVDU(NCVDU, 2,0)
            IF (ISSPRT .EQ. 0) WRITE(NCWU ,'(/A/) ') CMON(1)(:)
5585  FORMAT(1X,/, I6, ' Reflections down-weighted as Outliers',/)
      ENDIF
      IF (IGUI4(2) .EQ. 1 ) THEN
            WRITE(CMON,'(''^^CO SET _COUT TEXT '',I6)') JPRINT
            CALL XPRVDU(NCVDU, 1,0)
      END IF

5590  CONTINUE
C----- IF THE TYPE WAS TO TAKE ROOT W, CHANGE TO SAVE W
9000  CONTINUE
      CALL XOPMSG ( IOPWEI , IOPEND , IVERSN )
      CALL XTIME2(2)
      RETURN
C


9900  CONTINUE
C -- ERRORS
      CALL XALTES (4,-1)
      CALL XOPMSG ( IOPWEI , IOPABN , IVERSN )
      GO TO 5590
9910  CONTINUE
C -- TOO FEW COEFFICIENTS
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
      WRITE ( CMON , 9915 )
      CALL XPRVDU(NCVDU, 1,0)
9915  FORMAT ( 1X , 'Too few Chebyshev coefficients' )
      CALL XERHND ( IERERR )
      GO TO 9900
9920  CONTINUE
C -- NEGATIVE WEIGHTS
      CALL XERHND (IERWRN)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9925 )
      WRITE ( CMON , 9925 )
      CALL XPRVDU(NCVDU, 1,0)
9925  FORMAT(1X, 'List 4 is generating small or negative weights')
      GOTO 5570
9930  CONTINUE
C -- ILLEGAL WEIGHTING SCHEME
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9935 ) ITYPE4
      WRITE ( CMON , 9935 ) ITYPE4
      CALL XPRVDU(NCVDU, 1,0)
9935  FORMAT ( 1X , I5 , ' is an unknown weighting scheme' )
      CALL XERHND ( IERERR )
      GO TO 9900
9940  CONTINUE
C -- INSUFFICIENT PARAMETERS
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9945 )
      WRITE ( CMON , 9945 )
      CALL XPRVDU(NCVDU, 1,0)
9945  FORMAT ( 1X , 'Insufficient parameters given in list 4' )
      CALL XERHND ( IERERR )
      GO TO 9900
9950  CONTINUE
C -- FIRST PARAMETER ZERO
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9955 ) ITYPE4
      WRITE ( CMON , 9955 ) ITYPE4
      CALL XPRVDU(NCVDU, 1,0)
9955  FORMAT ( 1X , 'The first parameter for weighting scheme ' , I3 ,
     1 ' may not be zero' )
      CALL XERHND ( IERERR )
      GO TO 9900
9960  CONTINUE
C -- ALL HAVE BAD WEIGHTS
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9965 )
      WRITE ( CMON , 9965 )
      CALL XPRVDU(NCVDU, 1,0)
9965  FORMAT ( 1X , 'All reflections have a negative or zero weight' )
      CALL XERHND ( IERERR )
      GO TO 9900
9970  CONTINUE
      CALL XOPMSG ( IOPWEI , IOPCMI , IVERSN )
      GO TO 9900
9975  CONTINUE
C----- PROGRAMMING ERROR
      CALL XERHND ( IERPRG)
      GOTO 9900
C
9980  CONTINUE
      CALL XOPMSG ( IOPWEI , IOPINT , IVERSN )
      GO TO 9900
9990  CONTINUE
      IF (ISSPRT .EQ. 0) WRITE(NCWU,9991)
      WRITE(CMON,9991)
      CALL XPRVDU(NCVDU, 1,0)
9991  FORMAT(7X ,'Reflections (LIST 6/7) not on disk',
     1 7X , 'Weighting abandoned' )
      GOTO 5560
C
      END
C
C
CODE FOR KHIST
      FUNCTION KHIST( icall, val, point, pmin)
c
c      plot a histogram of val as a funtion of point
c----- icall = 0 initialisation
c              1 real data
c              2 termination
c              3 Evaluation of coefficients
c      val      observed value
c      point    point of observation or max for initialisation
c      pmin
c
\TYPE11
\ISTORE
\ICOM04
C
\STORE
\XSTR11
\XUNITS
\XCHARS
\XCONST
\XLST04
\XLST11
\XLST12
\XERVAL
\XOPVAL
C
      parameter (ncol = 80)
      parameter (line = 50)
      common /xhist1/ itot(line), sum(line), tval(line), scale
\XSSVAL
\XIOBUF
C
\QSTORE
\QLST04
\QSTR11
c
      KHIST = 1
      if (icall .eq. 0) then
c     initialisation
c            ensure minimum value is 1, maximum is LINE
             scale = float(line-1) / sqrt(point-pmin)
             do 50 i = 1, line
               itot(i) = 0
               sum(i) = 0.0
               tval(i) = 0.0
               e = point
50           continue
c--set up a dummy list 12
            ln=12
            irec=8001
            n12=md4
            md12b=2
            n12b=1
            l12b=kchlfl(md12b)
            istore(l12b)=1
            istore(l12b+1)=md4
c--set up the matrix area
            iold=-1
            call xset11 (iold,1,1)
            if ( ierflg .lt. 0 ) go to 9900
c--assign a few pointers
            nr=l11
            ns=l11r
c--set up the answers area
            ln=4
            nt=kadd11(1001,md11,md4)
            if ( ierflg .lt. 0 ) go to 9900
c--set the partial derivative area
            irec=1002
            nu=nfl
            nv=kchnfl(md4)-1
      else if (icall .eq. 1) then
c           real values
            ibin = nint (scale * sqrt(point-pmin))  +1
            if ((ibin .lt. 1) .or. (ibin .gt. line)) then
                write ( CMON ,'(A)') ' Out of range'
                CALL XPRVDU(NCVDU, 1,0)
                IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)
                WRITE(NCWU, '(A)') CMON(1)
            endif
            itot(ibin) = itot(ibin) + 1
            sum(ibin) = sum(ibin) + val
            tval(ibin) = tval(ibin) + point
      else if (icall .eq. 2) then
c           print and analysis
      WRITE ( CMON,'(I6,2F10.2 )') (ITOT(I),SUM(I),TVAL(I),I=1,LINE)
      CALL XPRVDU(NCVDU, 1,0)
            write ( cMON ,60)
            CALL XPRVDU(NCVDU, 1,0)
60          format (1x,
     1      '        Range      No         <Delta>     <Fvalue>')
            do 100 i = 1, line
            if (itot(i) .gt. 0) then
              write ( cMON,'( f16.0, i6, 3f16.2)')
     1        (float(i)/scale)**2, itot(i), sum(i)/itot(i),
     2        tval(i)/itot(i)
              CALL XPRVDU(NCVDU, 1,0)
              B = sum(i)/itot(i)
              b = b * b
              fo = tval(i)/itot(i)
              g=2.* fo /e-1.
              store(nu)=1.
              store(nu+1)=g
              if(md4-2)3750,3750,3650
c--accumulate terms higher than 2
3650  continue
                  nq=nu+2
                  do 3700 l=3,md4
                        store(nq)=2.*g*store(nq-1)-store(nq-2)
                        nq=nq+1
3700              continue
c--compute the weights for this reflection
3750          continue
              w= itot(i)
              nq=nr
              np=ns
c--accumulate the least squares matrix
              do 3850 l=nu,nv
c--the left hand side
                  do 3800 m=l,nv
                    str11(nq)=str11(nq)+store(l)*store(m)*w
                    nq=nq+1
3800              continue
c--the right hand side
                  str11(np)=str11(np)+store(l)*b*w
                  np=np+1
3850          continue
            else
                  write ( cMON,'(1x)')
                  CALL XPRVDU(NCVDU, 1,0)
            endif
100         continue
c--solve the chebyshev case
            call xchols (md4,nr,nt)
            call xsolve (md4,nr,ns,nt)
c--clear the list entries
c^            call xcsae
c--reload list 4
c^            call xfal04
c--move the parameters to list 4
            if (itype4.eq.17) then
                       np=nt
                       nq=l4
                       do 2050 l=1,md4
                                  store(nq)=str11(np)
                                  np=np+1
                                  nq=nq+1
2050                   continue
c--alter the scheme type to 18, and apply the parameters
                 itype4=18
            endif
c----- now try computing deltas
            do 200 i = 1, line
            if (itot(i) .gt. 0) then
              B = sum(i)/itot(i)
              b = b * b
              fo = tval(i)/itot(i)
              g = 2.* fo / e-1.
              a = 1.
              c = g
              delf = a * store(l4)
c--check the number of terms involved
              if(md4-2)6400,6350,6250
6250  continue
                  m = l4+2
                  do 6300 l = 3, md4
                  d =2.* g * c - a
                  delf = delf + d * store(m)
                  m = m + 1
                  a = c
                  c = d
6300            continue
6350            continue
              delf =delf + g * store(l4+1)
              write ( cMON,'( f16.0, i6, 4f16.2)')
     1        (float(i)/scale)**2, itot(i), sum(i)/itot(i),
     2        tval(i)/itot(i), delf, b
              CALL XPRVDU(NCVDU, 1,0)
            else
                  write ( cMON,'(1x)')
                  CALL XPRVDU(NCVDU, 1,0)
            endif
200         continue
6400        continue
      else if (icall .eq. 3) then
c---- Just a dummy for the moment
            val = 1.0
      endif
      return
9900  KHIST = -1
      RETURN
      end
CODE FOR XMODWT
      SUBROUTINE XMODWT (DELF, DELEST, AWT, IPRINT, jtype, tolsq)
C----- COMPUTE THE MODIFICATION TO BE APPLIED TO THE EXISTING WEIGHTS
C
C      DELF - DELTA FSQ
C      DELEST - ESTIMATED DELTASQ, ON SAME SCALE
C      AWT WEIGHT MODIFIER
C      IPRINT IS .GE. 0 INCREMENTED HERE BY OUTLIERS
C     JTYPE = 0 FOR FO, 2 FOR FSQ
C
\ISTORE
\STORE
\XUNITS
\XSSVAL
\QSTORE
C
      A = DELF
      B = DELEST
      IF (JTYPE .EQ. 2) THEN
            A = SQRT(A)
            B = SQRT(B)
      ENDIF
      IF (A .GT. TOLSQ * B) THEN
            AWT = 0.
            IF ( IPRINT .GE. 0) IPRINT = IPRINT + 1
      ELSE
            AWT = (1. - A / (TOLSQ * B)) **2
      ENDIF
      IF (JTYPE .EQ. 2) AWT = 0.5 * AWT
      RETURN
      END
CODE FOR XANAL
      SUBROUTINE XANAL
C--AGREEMENT ANALYSIS AND LAYER SCALING SUBROUTINE
C
C--ALLOCATION OF THE CORE :
C
C  ICLS  LOCATION OF THE REFLECTION CLASS STACK, WITH ENTRIES FOR :
C
C        0  H=2N
C        1  H=2N+1
C        2  K=2N
C        3  K=2N+1
C        4  L=2N
C        5  L=2N+1
C        6  K+L=2N
C        7  K+L=2N+1
C        8  H+L=2N
C        9  H+L=2N+1
C       10  H+K=2N
C       11  H+K=2N+1
C       12  H+K+L=2N
C       13  H+K+L=2N+1
C       14 -H+K+L=3N
C       15 -H+K+L=3N+1
C
C  IPAR  LOCATION OF THE INDEX PARITY GROUP STACK, WITH ENTRIES :
C
C        0  GGG
C        1  UGG
C        2  GUG
C        3  UUG
C        4  GGU
C        5  UGU
C        6  GUU
C        7  UUU
C
C  IGEN  LOCATION OF THE GENERAL STACK, WITH ENTRIES FOR :
C
C        0  /FO/
C        1  SIN(THETA)/LAMBDA
C        2 -H
C        3 /H/
C        4 +H
C        5 -K
C        6 /K/
C        7 +K
C        8 -L
C        9 /L/
C       10 +L
C
C--THE GENERAL STACK CONTAINS ONE ENTRY FOR EACH RANGE FOR EACH VALUE,
C  STARTING AT THE FIRST VALUE. FOR H, K AND L THE FIRST RANGE CONTAINS
C  THE ENTRIES FOR AN INDEX OF ZERO, THE SECOND RANGE  THE ENTRIES FOR
C  AND INDEX OF 1, ETC..
C  FOR /FO/ AND SIN(THETA)/LAMBDA THE FIRST RANGE CONTAINS THE ENTRIES F
C  REFLECTIONS WITH THE VALUES IN THE FIRST INTERVAL, AND SO ON.
C
C--THE FORMAT OF EACH ENTRY IS :
C
C  0  SCALE FOR THIS GROUP (IF NEC.)
C  1  NUMBER OF OBSERVATIONS
C  2  SUM OF /FO/
C  3  SUM OF /FC/
C  4  SUM OF /DF/
C  5  SUM OF W* /FO/ **2
C  6  SUM OF W* /DF/ **2
C  7  SUM OF W* /FO/ * /FC/
C  8  SUM OF /DF/ **2
C
C--THE 'APD' ARRAY HOLDS THE SAME INFORMATION AS AN ENTRY, EXCEPT
C  THAT THE INFORMATION APPLIES TO ALL THE REFLECTIONS AND THERE IS NO
C  SCALE FACTOR STORED. (APD(1) IS EQUIVALENT TO ENTRY 1, ETC.).
C
C--THE 'BPD' ARRAY HOLDS :
C
C  BPD(1)  SUM OF W* /FO/ **2 FOR ALL REFLECTIONS
C  BPD(2)  SUM OF W* DELTA**2 FOR ALL REFLECTIONS
C  BPD(3)  SUM OF W* /FO/ * /FC/ FOR ALL REFLECTIONS
C
C--OTHER USEFUL VARIABLES ARE :
C  DVF     DIVISION SIZE FOR /FO/
C  MM4     IF NOT GREATER THAN 0, /FO/ DIVISIONS ARE BASED ON
C          SQRT(/FO/)
C          IF GREATER THAN 0, /FO/ IS USED
C  MM5     SET TO ZERO IF THE ANALYSIS IS TO BE DONE ON THE SCALE
C          OF /FO/, ELSE TO 1
C  DVS     DIVISION SIZES FOR SIN(THETA)/LAMBDA
C  MM1     AXIS UP WHICH TO LAYER SCALE  -  DEFAULT IS 1
C  MM2     WRITE/OVERWRITE MODE AFTER LAYER SCALING
C  MM3     FLAG FOR A SECOND AGREEMENT ANALYSIS
C
C  JA      THE TYPE OF /F/ INTERVAL :
C  JAA     TYPE OF /F/ : 0=FO, 1=FC
C          0  BASED ON SQRT(/F/)
C          1  BASED ON /F/
C
C  VV      STEP BETWEEN SUCCESSIVE /FO/ RANGES
C  WW      STEP BETWEEN SUCCESSIVE SIN(THETA)/LAMBDA RANGES
C  SCALF   SCALE FACTOR FOR /FO/
C  SCALC   SCALE FACTOR FOR /FC/
C  E       MAX. SIN(THETA)/LAMBDA VALUE
C  F       MAX. /FO/ VALUE
C  HMIN(3) MIN. INDICES OBSERVED
C  HMAX(3) MAX. INDICES OBSERVED
C  NW      NUMBER OF WORDS PER ENTRY  -  THE FORMAT IS GIVEN ABOVE
C  ISTEP   NUMBER OF WORDS PER RANGE IN THE GENERAL STACK (=11*NW)
C  IBASE(3) THE STEP TO GET FROM THE START OF A RANGE TO THE ENTRY FOR
C           THE MODULUS OF AN INDEX.
C  NR      THE LAYER SCALE INDEX  -  DEFAULT IS 1.
C  MAXADD  THE MAXIMUM CORE ADDRESS USED DURING A SCAN.
C
C--DURING EACH SCAN FOR A REFLECTION, THE FOLLOWING VARIABLES ARE USED :
C
C  H(3)    THE INDICES
C  FO      SCALED /FO/
C  FC      SCALED /FC/
C  S       THE CURRENT WEIGHT
C  DF      /FO/-/FC/
C  ACI     W* /FO/ **2
C  ACT     DELTA**2
C  BCI     W*DELTA**2
C  AP      W* /FO/ * /FC/
C
C--DURING THE PRINTING OF A RANGE, THE FOLLOWING VARIABLES ARE SET :
C
C  L       ADDRESS OF THE ENTRY
C  M       PRINT LIMIT FOR THIS ENTRY  -  SET ON RETURN
C  R       R-FACTOR THAT HAS BEEN COMPUTED
C  RW      WEIGHTED R-FACTOR
C
C--ALL THE CALCULATIONS ARE DONE AT ONE PLACE, WHICH IS ENTERED WITH 'L'
C
C--VARIABLES TO CONTROL THE PLOTTING OF THE W*DELTA**2'S ARE :
C
C  NCHAR   LENGTH OF THE PLOT ARRAY
C  ADIV    NUMBER OF DIVISIONS FOR EACH LOG UNIT
C  NDIV     NINT(ADIV)
C  BMAX    MAXIMUM RATIO ALLOWED
C  BMIN    MINIMUM RATIO ALLOWED
C  ICE     CENTRAL LINE CHARACTER
C  ICENT   POSITION OF THE CENTRAL LINE IN 'IOUT'
C
C--
      CHARACTER *12 CTEMP
      CHARACTER *16 CNNN, COUT
      CHARACTER *4  CSHK(2)
\ICOM30
\ISTORE
      DIMENSION NOPE(4,30),KN(5),KM(5)
C----- FOR LIST 30 UPDATING
      DIMENSION TEMP30(4)
      CHARACTER *4 CFY(16),CFYY(16),CFN(16),CFH(6),CFC(6),CFO(6),CFS(6)
      CHARACTER *1 CH(3)
C
\STORE
C
      COMMON /XWTWK/SCALF,R,RW,FOT,FCT,DFT,WDFT,E,F,AP,BP,AT,BT,AC,BC,
     2 ACI,BCI,ACT,BCT,FO,FC,VV,WW,DF,WDF,TC,T,NOCC,TFOCC,SS,S,H(3),
     3 INDEXA(3),MAXADD
      COMMON /XWTWKA/SCALC,IBASE(3),NW,ISTEP,NR,HMIN(3),HMAX(3),ITYPE,
     2 IPAR,IGEN,ICLS,JA,I,J,K,L,M,N,NX,NY,NZ,K1,K2,K3,NC,N1,JAA
\XUNITS
\XSSVAL
\XLISTI
\XCONST
\XCHARS
\XPDS
\XLST01
\XLST04
\XLST05
\XLST06
\XLST28
\XLST30
C
\XERVAL
\XOPVAL
      COMMON/EXPLOT/NCHAR,ICE,ICENT,BMIN,BMAX,ADIV,IOUT(13)
\QLST30
\XIOBUF
\QSTORE
C
C--HEADING FOR THE LAYER SCALING PART
C
#HOL      DATA KN(1)/'  SC'/,KN(2)/'ALE '/,KN(3)/'    '/,KN(4)/'    '/
#HOL      DATA KN(5)/'    '/
#HOLC--HEADING FOR THE NORMAL PLOT TYPE ENTRIES
#HOL      DATA KM(1)/'LOG('/,KM(2)/'<W*D'/,KM(3)/'ELTA'/,KM(4)/'**2>'/
#HOL      DATA KM(5)/')   '/
&HOL      DATA KN(1)/4H  SC/,KN(2)/4HALE /,KN(3)/4H    /,KN(4)/4H    /
&HOL      DATA KN(5)/4H    /
&HOLC--HEADING FOR THE NORMAL PLOT TYPE ENTRIES
&HOL      DATA KM(1)/4HLOG(/,KM(2)/4H<W*D/,KM(3)/4HELTA/,KM(4)/4H**2>/
&HOL      DATA KM(5)/4H)   /
C--DATA FOR THE VAIOUS CLASSES OF REFLECTION GROUPS
      DATA NOPE(1,1)/'    '/,NOPE(2,1)/' /FO'/,NOPE(3,1)/'/ RA'/
      DATA NOPE(4,1)/'NGE '/
      DATA NOPE(1,2)/'  SI'/,NOPE(2,2)/'NTH/'/,NOPE(3,2)/'L RA'/
      DATA NOPE(4,2)/'NGE '/
      DATA NOPE(1,3)/'    '/,NOPE(2,3)/'   L'/,NOPE(3,3)/'AYER'/
      DATA NOPE(4,3)/'    '/
      DATA NOPE(1,4)/'  PA'/,NOPE(2,4)/'RITY'/,NOPE(3,4)/' GRO'/
      DATA NOPE(4,4)/'UP  '/
      DATA NOPE(1,5)/'    '/,NOPE(2,5)/' TOT'/,NOPE(3,5)/'ALS '/
      DATA NOPE(4,5)/'    '/
      DATA NOPE(1,6)/'    '/,NOPE(2,6)/'H   '/,NOPE(3,6)/'= 2N'/
      DATA NOPE(4,6)/'    '/
      DATA NOPE(1,7)/'    '/,NOPE(2,7)/'H   '/,NOPE(3,7)/'= 2N'/
      DATA NOPE(4,7)/'+1  '/
      DATA NOPE(1,8)/'    '/,NOPE(2,8)/'K   '/,NOPE(3,8)/'= 2N'/
      DATA NOPE(4,8)/'    '/
      DATA NOPE(1,9)/'    '/,NOPE(2,9)/'K   '/,NOPE(3,9)/'= 2N'/
      DATA NOPE(4,9)/'+1  '/
      DATA NOPE(1,10)/'    '/,NOPE(2,10)/'L   '/,NOPE(3,10)/'= 2N'/
      DATA NOPE(4,10)/'    '/
      DATA NOPE(1,11)/'    '/,NOPE(2,11)/'L   '/,NOPE(3,11)/'= 2N'/
      DATA NOPE(4,11)/'+1  '/
      DATA NOPE(1,12)/'   K'/,NOPE(2,12)/'+L  '/,NOPE(3,12)/'= 2N'/
      DATA NOPE(4,12)/'    '/
      DATA NOPE(1,13)/'   K'/,NOPE(2,13)/'+L  '/,NOPE(3,13)/'= 2N'/
      DATA NOPE(4,13)/'+1  '/
      DATA NOPE(1,14)/'   H'/,NOPE(2,14)/'+L  '/,NOPE(3,14)/'= 2N'/
      DATA NOPE(4,14)/'    '/
      DATA NOPE(1,15)/'   H'/,NOPE(2,15)/'+L  '/,NOPE(3,15)/'= 2N'/
      DATA NOPE(4,15)/'+1  '/
      DATA NOPE(1,16)/'   H'/,NOPE(2,16)/'+K  '/,NOPE(3,16)/'= 2N'/
      DATA NOPE(4,16)/'    '/
      DATA NOPE(1,17)/'   H'/,NOPE(2,17)/'+K  '/,NOPE(3,17)/'= 2N'/
      DATA NOPE(4,17)/'+1  '/
      DATA NOPE(1,18)/'  H+'/,NOPE(2,18)/'K+L '/,NOPE(3,18)/'= 2N'/
      DATA NOPE(4,18)/'    '/
      DATA NOPE(1,19)/'  H+'/,NOPE(2,19)/'K+L '/,NOPE(3,19)/'= 2N'/
      DATA NOPE(4,19)/'+1  '/
      DATA NOPE(1,20)/' -H+'/,NOPE(2,20)/'K+L '/,NOPE(3,20)/'= 3N'/
      DATA NOPE(4,20)/'    '/
      DATA NOPE(1,21)/' -H+'/,NOPE(2,21)/'K+L '/,NOPE(3,21)/'# 3N'/
      DATA NOPE(4,21)/'    '/
      DATA NOPE(1,22)/'    '/,NOPE(2,22)/'   G'/,NOPE(3,22)/'GG  '/
      DATA NOPE(4,22)/'    '/
      DATA NOPE(1,23)/'    '/,NOPE(2,23)/'   U'/,NOPE(3,23)/'GG  '/
      DATA NOPE(4,23)/'    '/
      DATA NOPE(1,24)/'    '/,NOPE(2,24)/'   G'/,NOPE(3,24)/'UG  '/
      DATA NOPE(4,24)/'    '/
      DATA NOPE(1,25)/'    '/,NOPE(2,25)/'   U'/,NOPE(3,25)/'UG  '/
      DATA NOPE(4,25)/'    '/
      DATA NOPE(1,26)/'    '/,NOPE(2,26)/'   G'/,NOPE(3,26)/'GU  '/
      DATA NOPE(4,26)/'    '/
      DATA NOPE(1,27)/'    '/,NOPE(2,27)/'   U'/,NOPE(3,27)/'GU  '/
      DATA NOPE(4,27)/'    '/
      DATA NOPE(1,28)/'    '/,NOPE(2,28)/'   G'/,NOPE(3,28)/'UU  '/
      DATA NOPE(4,28)/'    '/
      DATA NOPE(1,29)/'    '/,NOPE(2,29)/'   U'/,NOPE(3,29)/'UU  '/
      DATA NOPE(4,29)/'    '/
      DATA NOPE(1,30)/'    '/,NOPE(2,30)/'  CL'/,NOPE(3,30)/'ASS '/
      DATA NOPE(4,30)/'    '/
C
C----- THE AXIS NAMES
      DATA CH /'h','k','l'/
C--FORMAT WHEN THERE ARE SOME REFLECTIONS
      DATA CFY /6*'    ','I9,F','13.2',',F12',
     2'.1,2','E16.','4,F9','.2,F','8.2,','5X,1','3A1)'/
C--FORMAT WHEN THERE ARE NO REFLECTIONS
      DATA CFN/6*'    ','I9, ','85X,','A1) ',7*'    '/
C--FORMAT FOR THE LAYER SCALING ENTRIES
      DATA CFYY/14*'    ','F10.','5)  '/
C--INITIAL FORMAT FOR INDEX GROUPS
      DATA CFH(1)/'(1X' /,CFH(2)/',I9,'/,CFH(3)/'6X, '/
      DATA CFH(4)/'    '/,CFH(5)/'    '/,CFH(6)/'    '/
C--INITIAL FORMAT FOR THE REFLECTION CLASSES
      DATA CFC(1)/'(4A4'/,CFC(2)/',   '/,CFC(3)/'    '/
      DATA CFC(4)/'    '/,CFC(5)/'    '/,CFC(6)/'    '/
C--INITIAL FORMAT FOR THE /FO/ RANGES
      DATA CFO(1)/'(1X' /,CFO(2)/',F13'/,CFO(3)/'.2, '/
      DATA CFO(4)/'96X,'/,CFO(5)/'2A1/'/,CFO(6)/'16X,'/
C--INITIAL FORMAT FOR THE SIN(THETA)/LAMBDA RANGES
      DATA CFS(1)/'(1X'/, CFS(2)/',F12'/,CFS(3)/'.5, '/
      DATA CFS(4)/'97X,'/,CFS(5)/'2A1/'/,CFS(6)/'16X,'/
C--VARIABLE USED TO CONTROL THE KEY DRAWING
      DATA CSHK /'    ',' KEY'/
C
C--A FEW COMMONLY USED FORMAT STATEMENTS
1000  FORMAT(//4A4,1X,'No. of data',3X,'  </Fo/>',4X,'  </Fc/>',5X,
     2 '<Delta**2>',5X,'<W*Delta**2>',4X,'R(%)',3X,'RW(%)',2X,4A4,
     3 A1/)
1050  FORMAT(103X,'-2 -1  0  1  2')
1100  FORMAT(110X,A1)
C
C--CLEAR THE CLOCK CONTROL AND FETCH THE INPUT PARAMETERS
      CALL XTIME1(2)
      IF (  KRDDPV ( ISTORE(NFL) , 23 )  .LT.  0  ) GO TO 9930
C
C      SET THE REFLECTION LIST TYPE 
      ITYP06 = ISTORE(NFL+22)
      IULN06 = KTYP06(ITYP06)
C
C--SET THE ORIGINAL VARIABLES FROM THE NEW INPUT ROUTINE
      DVF=STORE(NFL)
      DVS=STORE(NFL+3)
      MM4=ISTORE(NFL+1)
      MM5=ISTORE(NFL+2)
      MM1=ISTORE(NFL+4)
      MM2=ISTORE(NFL+5)
      MM3=ISTORE(NFL+6)
      LEVEL=ISTORE(NFL+7)
      MONIT=ISTORE(NFL+8)
      PLCLS=ISTORE(NFL+9)
      PKCLS=ISTORE(NFL+10)
      PLPAR=ISTORE(NFL+11)
      PKPAR=ISTORE(NFL+12)
      PLFOR=ISTORE(NFL+13)
      PKFOR=ISTORE(NFL+14)
      PLTHE=ISTORE(NFL+15)
      PKTHE=ISTORE(NFL+16)
      PLEXT=ISTORE(NFL+17)
      PKEXT=ISTORE(NFL+18)
      PLHKL=ISTORE(NFL+19)
      PKHKL=ISTORE(NFL+20)
      PWDSQ=ISTORE(NFL+21)
C      CLEAR THE LIST 30 VARIABLES
      CALL XZEROF(TEMP30,4)
C--SET UP THE PLOT CONSTANTS
      NCHAR = 13
      ICENT=(NCHAR+1)/2
      ICE=IPOINT
      ADIV=3.0
      NDIV=NINT(ADIV)
      BMAX=FLOAT(NCHAR-ICENT)/ADIV
      BMIN=10.0**(-BMAX)
      BMAX=10.0**(BMAX)
C--TRANSFER THE INPUT DATA TO THE WORKING VARIABLES
      WW=DVS
      VV=DVF
      JA=MM4
CDJWJAN01 sort of F analysis type
      if ((mm4.eq. 0) .or. (mm4.eq.2)) then
            ja = 0
      else
            ja = 1
      endif
      jaa = 0
      if (mm4 .ge. 2) jaa=1
      NR=MM1
C--SET UP THE DEFAULT /FO/ RANGE VARIABLE IF NECESSARY
      IF(VV-ZERO)1200,1200,1350
1200  CONTINUE
C--CHECK THE TYPE OF /FO/ RANGE TO BE USED
      IF(JA)1250,1250,1300
C--BASED ON THE SQUARE ROOT OF /F/
1250  CONTINUE
      VV=1.
      GOTO 1350
C--BASED ON /F/
1300  CONTINUE
      VV=2.5
C--CHECK IF ANY LAYER SCALING IS REQUIRED
1350  CONTINUE
      IF(NR)1400,1400,1450
C--NONE REQUIRED  -  USE 'H' FOR THE SCAN
1400  CONTINUE
      NR=1
      GOTO 1500
C--CHECK THAT THE INDEX IS NOT TOO LARGE
1450  CONTINUE
      IF(NR-4)1500,1400,1400
C--SET UP THE DEFAULT SIN(THETA)/LAMBDA RANGE VARIABLE
1500  CONTINUE
      IF(WW-0.0001)1550,1550,1600
1550  CONTINUE
      WW=0.04
C--SCAN ALL THE REFLECTIONS
1600  CONTINUE
      CALL XSUAA(MM5, IULN06)
      IF ( IERFLG .LT. 0 ) GO TO 9900
      IF (VV .EQ. 1.) THEN
C----- RESET INTERVAL TO GIVE 20 VALUES
        VV = SQRT(SCALF*STORE(L6DTL+3*MD6DTL+1)) /20.
        WRITE(NCAWU,'(''Resetting interval '', 2F10.3)') VV
      ENDIF
      CALL XSCAN(-1)
C--SET UP THE RETURN VALUES FOR THE AGREEMENT ANALYSIS PRINT
      ASSIGN 1800 TO NCT
      ASSIGN 3250 TO K2T
C--CHECK IF ALL THE REFLECTIONS HAVE BEEN PROCESSED
      IF ( NOCC .GT. 0 ) GO TO 9910
      GO TO 6100
C
C--RETURN ADDRESS AFTER PRINTING THE FIRST AGREEMENT ANAYSIS
C  CHECK IF WE SHOULD PRINT THE CALCULATED LAYER SCALES
1800  CONTINUE
      IF(MM1)3150,3150,1850
C--PRINT RESULTS OF LAYER SCALING
1850  CONTINUE
      APD(9)=0.
      APD(10)=0.
      CALL XPRTCN
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1900)
      ENDIF
1900  FORMAT(' Results of layer scaling')
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1950) CH(NR)
      ENDIF
1950  FORMAT(///2X,A1,' axis')
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1000)(NOPE(I,4),I=1,4),KN
      ENDIF
      BP=AMAX1(HMAX(NR),-HMIN(NR))
      J=NINT(BP)+1
      L=IGEN+IBASE(NR)
C**   ASSIGN 2150 TO K3 ! MARKUS NEUBURGER
C--TRANSFER THE FORMAT TO THE PROPER ARRAY FOR LAYER SCALING
      DO 2000 K=7,14
      CFYY(K) = CFY(K)
2000  CONTINUE
C--SET UP THE RESET OF THE FORMAT
      CALL XSUFS(CFYY,CFN,CFH)
C--COMPUTE THE NEW LAYER SCALE FACTORS
      DO 2250 K=1,J
      I=K-1
C--CHECK THE NUMBER OF REFLS. IN THIS GROUP AND CALC. THE TOTALS IF NECE
      IF(ISTORE(L+1))2050,2050,2100
C--NO REFLECTIONS IN THIS GROUP  -  PRINT ONLY THE RANGE
2050  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFN)I,ISTORE(L+1)
      ENDIF
      GOTO 2200
C--COMPUTE THE NEW SCALE FACTOR FOR THIS INDEX VALUE
2100  CONTINUE
      STORE(L)=STORE(L)*STORE(L+7)/STORE(L+5)
      APD(9)=APD(9)+STORE(L+7)*STORE(L)
      APD(10)=APD(10)+STORE(L+5)*STORE(L)*STORE(L)
CNEW      GOTO 6150
      CALL GCOMPL
C--PRINT THE TOTALS FOR THIS GROUP OF REFLECTIONS
2150  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFYY)I,ISTORE(L+1),(STORE(I+2),I=L,M),STORE(L)
      ENDIF
2200  CONTINUE
      L=L+ISTEP
2250  CONTINUE
C--PRINT THE OVERALL TOTALS
      ASSIGN 2350 TO K1T
C--SET UP THE DATA FORMAT IN 'IOUT'
      DO 2300 II=1,NCHAR
      IOUT(II)=IB
2300  CONTINUE
      ICEE=IB
      GOTO 6050
C--COMPUTE THE CORRECTION TO RETAIN THE OVERALL SCALE FACTOR CONSTANT
2350  CONTINUE
      FR=APD(9)/APD(10)*BPD(1)/BPD(3)
      L=IGEN+IBASE(NR)
C--MODIFY THE SCALES TO KEEP THE OVERALL SCALE FACTOR CONSTANT
      DO 2400 I=1,J
      STORE(L)=STORE(L)*FR
      L=L+ISTEP
2400  CONTINUE
C--SET UP THE SECOND PASS
      I=NFL
      NFL=MAXADD
      CALL XFAL06(IULN06, MM2)
      IF ( IERFLG .LT. 0 ) GO TO 9900
      CALL XIRTAC(4)
      NFL=I
C--MAKE THE SECOND PASS
      CALL XSCAN(MM2)
      ASSIGN 2450 TO K2T
C--CHECK IF ALL THE REFLECTIONS WERE PROCESSED
      IF ( NOCC .GT. 0 ) GO TO 9910
C
C--RETURN FROM COMPUTING THE OVERALL TOTALS AFTER THE SECOND AGREEMENT A
C  CHECK IF THE LAYER SCALES HAVE BEEN APPLIED
2450  CONTINUE
      IF(MM2)2600,2600,2500
C--TERMINATE THE REFLECTION OUTPUT
2500  CONTINUE
      CALL XLINES
      CALL XCRD(4)
      CALL XERT(IULN06)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2550)
      ENDIF
2550  FORMAT(///' New scales applied to the data - results')
      GOTO 2700
2600  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2650)
      ENDIF
2650  FORMAT(///' New scales not applied to the data',
     2 ' - results if they had been applied')
C--PRINT THE HEADER CAPTION
2700  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1000)(NOPE(I,3),I=1,4),KN
      ENDIF
      L=IGEN+IBASE(NR)
C**   ASSIGN 2800 TO K3 ! MARKUS NEUBURGER
      CALL XSUFS(CFYY,CFN,CFH)
C--PASS OVER EACH GROUP
      DO 2900 K=1,J
      I=K-1
C--CHECK THE NUMBER OF REFLS. IN THIS GROUP AND CALC. THE TOTALS IF NECE
      IF(ISTORE(L+1))2750,2750,2730
CNEW                           6150
2730  CONTINUE
      CALL GCOMPL
      GO TO 2800
C--NO REFLECTIONS IN THIS GROUP  -  PRINT ONLY THE RANGE
2750  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFN)I,ISTORE(L+1)
      ENDIF
      GOTO 2850
C--PRINT THE TOTALS FOR THIS GROUP OF REFLECTIONS
2800  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFYY)I,ISTORE(L+1),(STORE(I+2),I=L,M),STORE(L)
      ENDIF
2850  CONTINUE
      L=L+ISTEP
2900  CONTINUE
C--PRINT THE TOTALS FOR ALL THE REFLECTIONS
      ASSIGN 3000 TO K1T
      DO 2950 II=1,NCHAR
      IOUT(II)=IB
2950  CONTINUE
      ICEE=IB
      GOTO 6050
C--CHECK IF A SECOND AGREEMENT ANALYSIS IS TO BE PRINTED
3000  CONTINUE
      IF(MM3)3100,3100,3050
C--PRINT THE SECOND AGREEMENT ANALYSIS
3050  CONTINUE
      ASSIGN 3100 TO NCT
      GOTO 3250
3100  CONTINUE
C
C--EXIT ROUTINES
3150  CONTINUE
CNOV98----- SIGMA THRESHOLD
         TEMP30(4) = 0.0
         IF ( N28MN .GT. 0 ) THEN
          INDNAM = L28CN
          DO 1702 I = L28MN , M28MN , MD28MN
            WRITE ( CTEMP , '(3A4)')
     1      (ISTORE(J), J = INDNAM, INDNAM + 2 )
            IF (INDEX(CTEMP,'RATIO') .GT. 0) THEN
             TEMP30(4) = STORE(I+1)
             ENDIF
            INDNAM = INDNAM + MD28CN
1702      CONTINUE
         ENDIF
C
CNOV98----- LOAD LIST 30 FOR UPDATING
      IF (TEMP30(1) .GE. ZERO) THEN
        CALL XFAL30
        STORE(L30GE+8) = TEMP30(4)
        STORE(L30GE+9) = TEMP30(1)
        STORE(L30GE+10) = TEMP30(2)
        STORE(L30GE+11) = TEMP30(3)
        CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
      ENDIF
      CALL XOPMSG ( IOPANA , IOPEND , 610 )
      CALL XTIME2(2)
      RETURN
C
C--PRINT THE RESULTS OF A FULL AGREEMENT ANALYSIS
3250  CONTINUE
      CALL XPRTCN
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3300)
      ENDIF
3300  FORMAT(' Full agreement analysis',
     2 '  -  with plots of mean w*Delta**2 divided by',
     3 ' its overall average value')
C--CHECK IF THIS IS ON THE SCALE OF /FO/ OR /FC/
      IF(MM5)3350,3350,3450
3350  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3400)
      ENDIF
3400  FORMAT(/,' on scale of /FO/')
      ACI=SCALC
      GOTO 3550
3450  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3500)
      ENDIF
3500  FORMAT(/,' on scale of /FC/')
      ACI=1./SCALF
C--PRINT THE CURRENT SCALE FACTOR
3550  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3600)ACI
      ENDIF
3600  FORMAT(/,' Scale factor  =',F10.5)
C--WRITE OUT LIST 4
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3650)ITYPE4
      ENDIF
3650  FORMAT(//,' Weighting scheme type ',I4)
      IF(MD4)3800,3800,3700
C--PRINT THE PARAMETERS
3700  CONTINUE
      M4=L4+MD4-1
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3750)(STORE(I),I=L4,M4)
      ENDIF
3750  FORMAT(/,' With parameter(s) : ',6E15.6/(1X,20X,6E15.6))
C--AGREEMENT ANALYSIS ON INDICES  -  PASS OVER H, K AND L
3800  CONTINUE
      IF(LEVEL)3820,3820,4870
3820  CONTINUE
      DO 4250 I=1,3
C--PRINT THE CURRENT INDEX TYPE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3850) CH(I)
      ENDIF
3850  FORMAT(///' Agreement analysis on ', A1,' index')

      IF ( PLHKL .EQ. 1 ) THEN
        WRITE(CMON,'(A,A1,A,A1,A/A,A1,A/A/A/A/A/A)')
     1  '^^PL PLOTDATA _INDEX',CH(I),' BARGRAPH ATTACH _VINDEX', CH(I),
     1  CSHK(PKHKL),
     1  '^^PL XAXIS TITLE ''Layers by ',CH(I),' index ''',
     1  '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1  '^^PL NSERIES=3 LENGTH=30 YAXIS LOG TITLE <Fo-Fc>**2',
     1  '^^PL SERIES 1 SERIESNAME ''<( |Fo| - |Fc| )**2>''',
     1  '^^PL SERIES 2 SERIESNAME ''<w * ( |Fo| - |Fc| )**2>''',
     1  '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1  '^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 8,0)
        PKHKL = 1
        HKLMX = 0.0
      ELSE IF ( PLHKL .EQ. 2 ) THEN
        WRITE(CMON,'(A,A1,A,A1,A/A,A1,A/A/A/A/A/A)')
     1  '^^PL PLOTDATA _INDEXR',CH(I),' BARGRAPH ATTACH _VINDEXR',CH(I),
     1  CSHK(PKHKL),
     1  '^^PL XAXIS TITLE ''Layers by ',CH(I),' index ''',
     1  '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1  '^^PL NSERIES=3 LENGTH=30 YAXIS TITLE ''R factor %''',
     1  '^^PL SERIES 1 SERIESNAME ''R %''',
     1  '^^PL SERIES 2 SERIESNAME ''Rw %''',
     1  '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1  '^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 8,0)
        PKHKL = 1
      END IF

      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1000)(NOPE(J,3),J=1,4),KM
      ENDIF
C--FIND THE MAX. AND MIN. VALUES FOR THIS INDEX
      NX=NINT(HMIN(I))
      NY=NINT(HMAX(I))
      NZ=NY-NX+1
C--SET UP THE SWITCH FLAGS FOR THE ACCUMULATION
C**   ASSIGN 4100 TO K3 ! MARKUS NEUBURGER
C--SET UP THE FORMAT SPECIFICATIONS
      CALL XSUFS(CFY,CFN,CFH)
C--PASS OVER EACH VALUE OF THIS INDEX
      DO 4200 J=1,NZ
C--CHECK IF THIS VALUE IS POSITIVE OR NEGATIVE
      IF(NX)3900,3950,3950
3900  CONTINUE
      L=IGEN+ISTEP*IABS(NX)+IBASE(I)-NW
      GOTO 4000
3950  CONTINUE
      L=IGEN+ISTEP*NX+IBASE(I)+NW
C--CHECK THE NUMBER OF REFLS. IN THIS GROUP AND CALC. THE TOTALS IF NECE
4000  CONTINUE
      IF(ISTORE(L+1))4050,4050,4030
CNEW                           6150
4030  CONTINUE
      CALL GCOMPL
      GOTO 4100
C--NO REFLECTIONS IN THIS GROUP  -  PRINT ONLY THE RANGE
4050  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFN)NX,ISTORE(L+1),ICE
      ENDIF

      IF ( PLHKL .EQ. 1 ) THEN
        WRITE(CMON,'(A,I4,A,2F15.7,I8)')'^^PL LABEL ',NX,
     2   ' DATA ', 1.0,1.0,0
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( PLHKL .EQ. 2 ) THEN
        WRITE(CMON,'(A,I4,A,2F15.7,I8)')'^^PL LABEL ',NX,
     2   ' DATA ', 0.0,0.0,0
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF

      GOTO 4150
C--PRINT THE TOTALS FOR THIS GROUP OF REFLECTIONS
4100  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)NX,ISTORE(L+1),(STORE(K+2),K=L,M),IOUT
      ENDIF

      IF ( PLHKL .EQ. 1 ) THEN
        WRITE(CMON,'(A,I4,A,2F15.7,I8)')'^^PL LABEL ',NX,
     2   ' DATA ', STORE(L+4), STORE(L+5), ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
        HKLMX = MAX (HKLMX, STORE(L+5), STORE(L+6) )
      ELSE IF ( PLHKL .EQ. 2 ) THEN
        WRITE(CMON,'(A,I4,A,2F15.7,I8)')'^^PL LABEL ',NX,
     2   ' DATA ', STORE(L+6), STORE(L+7), ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF

4150  CONTINUE
      NX=NX+1
C--THIS PIECE OF CODE IS DO THE JUMP BACK TO THE INNER LOOP
      IF ( NZ .EQ. J ) THEN
C
C--WRITE OUT THE TOTALS FOR EACH GROUP
        DO 4160 II=1,NCHAR
          IOUT(II)=IB
4160    CONTINUE
C--SET UP THE POINTS TO MARK
        DO 4170 II=1,NCHAR,NDIV
          IOUT(II)=ICE
4170    CONTINUE
        IOUT(ICENT)=IA
        ICEE=ICE
C--SET UP THE FORMATS
        CALL OVERFL(II)
        CALL XSUFS(CFY,CFN,CFC)
C--WRITE OUT THE BLANK LINE
      IF (ISSPRT .EQ. 0) THEN
        WRITE(NCWU,1100)ICEE
        WRITE(NCWU,CFY)(NOPE(N2,5),N2=1,4),N,(APD(N2),N2=1,6),IOUT
      ENDIF
      ENDIF
C
C
4200  CONTINUE
C--PRINT THE FINAL CAPTION FOR THIS GROUP
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1050)
      ENDIF

      IF ( PLHKL .EQ. 1 ) THEN
        HKLMX = MAX(1.0,HKLMX)
        HKLMX = LOG10(HKLMX)
        IHKLMX = NINT(HKLMX)
        IF(FLOAT(IHKLMX).LT.HKLMX)IHKLMX=IHKLMX+1
        IHKLMX = 10**HKLMX
        WRITE(CMON,'(A,I10,A/A)')'^^PL YAXIS ZOOM 0.01 ',IHKLMX,' SHOW',
     1   '^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ELSE IF ( PLHKL .EQ. 2 ) THEN
        WRITE(CMON,'(A/A)')'^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF

4250  CONTINUE
C
C--AGREEEMNT ANALYSIS ON REFLECTION CLASSES
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,4300)
4300  FORMAT(///' Agreement analysis on reflection classes')
      WRITE(NCWU,1000)(NOPE(J,30),J=1,4),KM
      ENDIF

c--PLCLS IS EITHER 0 (OFF), 1 (DELTA) OR 2 (RFAC). PLOT GRAPH IF 1 OR 2.
      IF ( PLCLS .EQ. 1 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A)')
     1  '^^PL PLOTDATA _CLASS BARGRAPH ATTACH _VCLASS', CSHK(PKCLS),
     1  '^^PL XAXIS TITLE ''HKL Class''',
     1  '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1  '^^PL NSERIES=3 LENGTH=16 YAXIS LOG TITLE <Fo-Fc>**2',
     1  '^^PL SERIES 1 SERIESNAME ''<( |Fo| - |Fc| )**2>''',
     1  '^^PL SERIES 2 SERIESNAME ''<w * ( |Fo| - |Fc| )**2>''',
     1  '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1  '^^PL ZOOM 0.01 100 SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 8,0)
      ELSE IF ( PLCLS .EQ. 2 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A)')
     1  '^^PL PLOTDATA _CLASSR BARGRAPH ATTACH _VCLASSR', CSHK(PKCLS),
     1  '^^PL XAXIS TITLE ''HKL Class''',
     1  '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1  '^^PL NSERIES=3 LENGTH=16 YAXIS TITLE ''R factor %''',
     1  '^^PL SERIES 1 SERIESNAME ''R % ''',
     1  '^^PL SERIES 2 SERIESNAME ''Rw %''',
     1  '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1  '^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 8,0)
      END IF

      L=ICLS
C**   ASSIGN 4400 TO K3 ! MARKUS NEUBURGER
      CALL XSUFS(CFY,CFN,CFC)
C--PASS OVER EACH GROUP
      DO 4500 I=1,16
C--CHECK THE NUMBER OF REFLS. IN THIS GROUP AND CALC. THE TOTALS IF NECE
      IF(ISTORE(L+1))4350,4350,4330
CNEW                           6150
4330  CONTINUE
      CALL GCOMPL
      GOTO 4400
C--NO REFLECTIONS IN THIS GROUP  -  PRINT ONLY THE RANGE
4350  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFN)(NOPE(J,I+5),J=1,4),ISTORE(L+1),ICE
      ENDIF
      GOTO 4450
C--PRINT THE TOTALS FOR THIS GROUP OF REFLECTIONS
4400  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)(NOPE(J,I+5),J=1,4),ISTORE(L+1),
     2 (STORE(K+2),K=L,M),IOUT
      ENDIF

      WRITE(CNNN,'(4A4)') (NOPE(J,I+5),J=1,4)
      CALL XCREMS(CNNN,COUT,LNNN)

      IF ( PLCLS .EQ. 1 ) THEN
        WRITE(CMON,'(3A,2F15.7,I8)')'^^PL LABEL ''',
     2   COUT(2:LNNN-1),''' DATA ', STORE(L+4), STORE(L+5), ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( PLCLS .EQ. 2 ) THEN
        WRITE(CMON,'(3A,2F15.7,I8)')'^^PL LABEL ''',
     2   COUT(2:LNNN-1),''' DATA ', STORE(L+6), STORE(L+7), ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF

4450  CONTINUE
      L=L+NW
4500  CONTINUE
      ASSIGN 4550 TO K1T
      GOTO 5900
C--PRINT THE FINAL CAPTION FOR THIS GROUP
4550  CONTINUE

      IF ( PLCLS .GT. 0 ) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF

C--AGREEEMNT ANALYSIS ON PARITY GROUPS
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1050)
      WRITE(NCWU,4600)
      ENDIF
4600  FORMAT(///,' Agreement analysis on parity groups')
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1000)(NOPE(J,4),J=1,4),KM
      ENDIF

      IF ( PLPAR .EQ. 1 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A)')
     1 '^^PL PLOTDATA _PAR BARGRAPH ATTACH _VPAR', CSHK(PKPAR),
     1 '^^PL NSERIES=3 LENGTH=8 XAXIS TITLE ''Parity Group''',
     1 '^^PL YAXIS LOG TITLE <Fo-Fc>**2 ZOOM 0.01 100',
     1 '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1  '^^PL SERIES 1 SERIESNAME ''<( |Fo| - |Fc| )**2>''',
     1  '^^PL SERIES 2 SERIESNAME ''<w * ( |Fo| - |Fc| )**2>''',
     1  '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1 '^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 8,0)
      ELSE IF ( PLPAR .EQ. 2 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A)')
     1 '^^PL PLOTDATA _PARR BARGRAPH ATTACH _VPARR', CSHK(PKPAR),
     1 '^^PL NSERIES=3 LENGTH=8 XAXIS TITLE ''Parity Group''',
     1 '^^PL YAXIS TITLE ''R factor %''',
     1 '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1 '^^PL SERIES 1 SERIESNAME ''R %''',
     1 '^^PL SERIES 2 SERIESNAME ''Rw %''',
     1 '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1 '^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 8,0)
      ENDIF

      L=IPAR
C**   ASSIGN 4700 TO K3 ! MARKUS NEUBURGER
      CALL XSUFS(CFY,CFN,CFC)
C--PASS OVER EACH GROUP
      DO 4800 I=1,8
C--CHECK THE NUMBER OF REFLS. IN THIS GROUP AND CALC. THE TOTALS IF NECE
      IF(ISTORE(L+1))4650,4650,4630
CNEW                           6150
4630  CONTINUE
      CALL GCOMPL
      GOTO 4700
C--NO REFLECTIONS IN THIS GROUP  -  PRINT ONLY THE RANGE
4650  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFN)(NOPE(J,I+21),J=1,4),ISTORE(L+1),ICE
      ENDIF
      GOTO 4750
C--PRINT THE TOTALS FOR THIS GROUP OF REFLECTIONS
4700  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)(NOPE(J,I+21),J=1,4),ISTORE(L+1),(STORE(K+2),K=L,
     2 M),IOUT
      ENDIF

      WRITE(CNNN,'(4A4)') (NOPE(J,I+21),J=1,4)
      CALL XCREMS(CNNN,COUT,LNNN)

      IF ( PLPAR .EQ. 1 ) THEN
        WRITE(CMON,'(3A,2F15.7,I8)')'^^PL LABEL ''',
     2   COUT(2:LNNN-1),''' DATA ', STORE(L+4), STORE(L+5), ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( PLPAR .EQ. 2 ) THEN
        WRITE(CMON,'(3A,2F15.7,I8)')'^^PL LABEL ''',
     2   COUT(2:LNNN-1),''' DATA ',STORE(L+6),  STORE(L+7), ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF

4750  CONTINUE
      L=L+NW
4800  CONTINUE
      ASSIGN 4850 TO K1T
      GOTO 5900
C--PRINT THE FINAL CAPTION FOR THIS GROUP
4850  CONTINUE

      IF ( PLPAR .GT. 0 ) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF

      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1050)
      ENDIF
C
C--AGREEMENT ANALYSIS ON /FO/
4870  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
         WRITE(NCWU,4900)
        WRITE(NCWU,1000)(NOPE(J,1),J=1,4),KM
      ENDIF
4900  FORMAT(' Agreement analysis on /FC/')
C--- OUTPUT TO SCREEN
      IF (MONIT .NE. 2) THEN
        WRITE(CMON,4910)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF

      IF ( PLFOR .EQ. 1 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A,/,A)') 
     1 '^^PL PLOTDATA _FO BARGRAPH ATTACH _VFO', CSHK(PKFOR),
     1 '^^PL NSERIES=3 LENGTH=20 XAXIS TITLE',
     1 '^^PL  ''<- Weak           Fc Range            Strong ->''',
     1 '^^PL YAXIS LOG TITLE <Fo-Fc>**2 ZOOM 0.01 100',
     1 '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1 '^^PL SERIES 1 SERIESNAME ''<( |Fo| - |Fc| )**2>''',
     1 '^^PL SERIES 2 SERIESNAME ''<w * ( |Fo| - |Fc| )**2>''',
     1 '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1 '^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 9,0)
      ELSE IF ( PLFOR .EQ. 2 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A,/,A)') 
     1 '^^PL PLOTDATA _FOR BARGRAPH ATTACH _VFOR', CSHK(PLFOR),
     1 '^^PL NSERIES=3 LENGTH=20 XAXIS TITLE',
     1 '^^PL  ''<- Weak           Fo Range            Strong ->''',
     1 '^^PL YAXIS TITLE ''R factor %''',
     1 '^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1 '^^PL SERIES 1 SERIESNAME ''R %''',
     1 '^^PL SERIES 2 SERIESNAME ''Rw %''',
     1 '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1 '^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 9,0)
      ENDIF

      IF ( PLEXT .GE. 1 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A)')
     1 '^^PL PLOTDATA _EXT BARGRAPH ATTACH _VEXT', CSHK(PKEXT),
     1 '^^PL NSERIES=1 LENGTH=20 XAXIS TITLE',
     1 '^^PL ''<- Weak           Fo Range            Strong ->''',
     1 '^^PL YAXIS TITLE <Fo>-<Fc>',
     1 '^^PL SERIES 1 SERIESNAME ''<Fo> - <Fc>'''
        CALL XPRVDU(NCVDU, 5,0)
      ENDIF

4910  FORMAT ( 1X , '  Range  Number  <FO>     <FC>    ' ,
     2 ' <delsq>  <wdelsq>  R    RW Log<wdelsq>' )
4920  FORMAT(1H ,F7.0,I6,2F9.0,2E10.2,2F5.0,13A1)
4921  FORMAT(' Totals ' ,I6,2F9.0,2E10.2,2F5.0)
      L=IGEN
      AC=0.
      NZ=0
C**   ASSIGN 5200 TO K3 ! MARKUS NEUBURGER
      CALL XSUFS(CFY,CFN,CFO)
C--PASS OVER EACH GROUP
      DO 5300 I=1,10000
C--COMPUTE THE CURRENT VALUE OF /F/ TO BE PRINTED
      ACI=AC
      IF(JA)4950,4950,5000
4950  CONTINUE
      ACI=AC*AC
C--CHECK IF WE ARE AT THE END OF THE /F/ VALUES
5000  CONTINUE
      IF(AC-F)5050,5050,5350
C--CHECK THE NUMBER OF REFLS. IN THIS GROUP AND CALC. THE TOTALS IF NECE
5050  CONTINUE
      IF(ISTORE(L+1))5100,5100,5080
CNEW                           6150
5080  CONTINUE
      CALL GCOMPL
      GOTO 5200
C--CHECK IF THIS IS THE FIRST RANGE WITH NO REFLECTIONS IN IT
5100  CONTINUE
      IF(NZ)5250,5150,5250
C--NO REFLECTIONS IN THIS GROUP  -  PRINT ONLY THE RANGE
5150  CONTINUE
      NZ=1
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFN)ACI,ICE,IB,ISTORE(L+1),ICE
      ENDIF
C--- OUTPUT TO SCREEN
      IF (MONIT .NE. 2) THEN
      WRITE(CMON,4920)ACI,ISTORE(L+1)
      CALL XPRVDU(NCVDU, 1,0)
      ENDIF

      IF ( PLFOR .EQ. 1 ) THEN
        WRITE(CMON,'(A,F7.0,1X,A)')'^^PL SET _FO LABEL ',ACI,
     1                           ' DATA  1.0 1.0 0.0'
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( PLFOR .EQ. 2 ) THEN
        WRITE(CMON,'(A,F7.0,1X,A)')'^^PL SET _FOR LABEL ',ACI,
     1                           ' DATA  0.0 0.0 0.0'
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      IF ( PLEXT .GT. 0 ) THEN
        WRITE(CMON,'(A,F7.0,1X,A)')'^^PL SET _EXT LABEL ',ACI,
     1                           ' DATA  0.0'
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      GOTO 5250
C--PRINT THE TOTALS FOR THIS GROUP OF REFLECTIONS
5200  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)ACI,ICE,IB,ISTORE(L+1),(STORE(K+2),K=L,M),IOUT
      ENDIF
C--- OUTPUT TO SCREEN
      IF (MONIT .NE. 2) THEN
      WRITE(CMON,4920)ACI,ISTORE(L+1), STORE(L+2), STORE(L+3),
     2 (STORE(K+2),K=L+2,M) , IOUT
      CALL XPRVDU(NCVDU, 1,0)
      ENDIF

      IF ( PLFOR .EQ. 1 ) THEN
        WRITE(CMON,'(A,F7.0,A,2(1X,F15.7),I8)')'^^PL SET _FO LABEL ',
     1    ACI,' DATA ',STORE(L+4),STORE(L+5),ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( PLFOR .EQ. 2 ) THEN
        WRITE(CMON,'(A,F7.0,A,2(1X,F15.7),I8)')'^^PL SET _FOR LABEL ',
     1    ACI,' DATA ',STORE(L+6),STORE(L+7),ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      IF ( PLEXT .GT. 0 ) THEN
        WRITE(CMON,'(A,F7.0,A,1X,F15.7)')'^^PL SET _EXT LABEL ',ACI,
     1                                  ' DATA ',STORE(L+2)-STORE(L+3)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      NZ=0
5250  CONTINUE
      AC=AC+VV
      L=L+ISTEP
5300  CONTINUE
C--PRINT THE FINAL VALUE
5350  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)ACI,ICE
      ENDIF
C--- OUTPUT TO SCREEN
      IF (MONIT .NE. 2) THEN
      WRITE(CMON,4920)ACI
      CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      ASSIGN 5400 TO K1T
      GOTO 5900
C--PRINT THE LAST CAPTION FOR THIS GROUP
5400  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1050)
      ENDIF
      IF ( PLFOR .EQ. 1 ) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SET _FO SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ELSE IF ( PLFOR .EQ. 2 ) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SET _FOR SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF
      IF ( PLEXT .GT. 0 ) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SET _EXT SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF
C--- OUTPUT TO SCREEN
      IF (MONIT .NE. 2) THEN
        WRITE(CMON,4921)N,(APD(N2),N2=1,6)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      IF ( PWDSQ .EQ. 1 ) THEN
        WRITE(CMON,'(''^^CO SET _WDSQ TEXT '',F7.3)') APD(4)
        CALL XPRVDU(NCVDU, 1,0)
      END IF
C----- NOV98 - UPDATE LIST 30 TEMP VARIABLES
      TEMP30(1) = FLOAT(N)
      TEMP30(2) = APD(5)
      TEMP30(3) = APD(6)
C
C--AGREEMENT ANALYSIS ON SIN(THETA)/LAMBDA RANGES
      IF (ISSPRT .EQ. 0) THEN
        WRITE(NCWU,5450)
5450    FORMAT(///,' Agreement analysis on [sin(theta)/lambda]sq')
        WRITE(NCWU,1000)(NOPE(J,2),J=1,4),KM
      ENDIF

      IF ( PLTHE .EQ. 1 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A,/,A)')
     1'^^PL PLOTDATA _THETA BARGRAPH ATTACH _VSINT ', CSHK(PKTHE),
     1'^^PL YAXIS ZOOM 0.01 100 TITLE',
     1'^^PL  <Fo-Fc>**2 LOG NSERIES=3 LENGTH=10 XAXIS TITLE',
     1'^^PL ''<-Low angle    Sin(theta)/lambda   High angle->''',
     1'^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1 '^^PL SERIES 1 SERIESNAME ''<( |Fo| - |Fc| )**2>''',
     1 '^^PL SERIES 2 SERIESNAME ''<w * ( |Fo| - |Fc| )**2>''',
     1 '^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1'^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 9,0)
      ELSE IF ( PLTHE .EQ. 2 ) THEN
        WRITE(CMON,'(A,A,/,A,/,A,/,A,/,A,/,A,/,A,/,A)')
     1'^^PL PLOTDATA _INTR BARGRAPH ATTACH _VSINTR ', CSHK(PKTHE),
     1'^^PL YAXIS TITLE ''R factor %''',
     1'^^PL NSERIES=3 LENGTH=10 XAXIS TITLE',
     1'^^PL ''<-Low angle    Sin(theta)/lambda   High angle->''',
     1'^^PL YAXISRIGHT TITLE ''Number Of Reflections''',
     1'^^PL SERIES 1 SERIESNAME ''R %''',
     1'^^PL SERIES 2 SERIESNAME ''Rw %''',
     1'^^PL SERIES 3 SERIESNAME ''Number Of Reflections''',
     1'^^PL SERIES 3 TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 9,0)
      ENDIF

      IF (MONIT .NE. 1) THEN
      WRITE(CMON,'(A)')' Agreement analysis on [sin(theta)/lambda]sq'
      CALL XPRVDU(NCVDU,1,0)
      WRITE(CMON,4910)
      CALL XPRVDU(NCVDU,1,0)
      ENDIF
      AC=0.
      L=IGEN+NW
      NZ=0
C**   ASSIGN 5650 TO K3 ! MARKUS NEUBURGER
      CALL XSUFS(CFY,CFN,CFS)
C--PASS OVER EACH GROUP
      DO 5750 I=1,10000
      ACI=SQRT(AC)
C--CHECK IF WE HAVE REACHED THE END OF THE RANGES
      IF(AC-E)5500,5500,5800
C--CHECK THE NUMBER OF REFLS. IN THIS GROUP AND CALC. THE TOTALS IF NECE
5500  CONTINUE
      IF(ISTORE(L+1))5550,5550,5530
CNEW                           6150
5530  CONTINUE
      CALL GCOMPL
      GOTO 5650
C--CHECK IF THIS IS THE FIRST RANGE WITH NO INFORMATION IN IT
5550  CONTINUE
      IF(NZ)5700,5600,5700
C--NO REFLECTIONS IN THIS GROUP  -  PRINT ONLY THE RANGE
5600  CONTINUE
      NZ=1
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFN)AC,ICE,IB,ISTORE(L+1),ICE
      ENDIF
      IF ( PLTHE .EQ. 1 ) THEN
        WRITE(CMON,'(A,F7.3,1X,A)')'^^PL LABEL ',AC,' DATA 1.0 1.0'
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( PLTHE .EQ. 2 ) THEN
        WRITE(CMON,'(A,F7.3,1X,A)')'^^PL LABEL ',AC,' DATA 0.0 0.0'
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF

5610  FORMAT(1H ,F7.4,I6,2F9.0,2E10.2,2F5.0,13A1)
      IF (MONIT .NE. 1) THEN
      WRITE(CMON,5610)AC,ISTORE(L+1)
      CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      GOTO 5700
C--PRINT THE TOTALS FOR THIS GROUP OF REFLECTIONS
5650  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)AC,ICE,IB,ISTORE(L+1),(STORE(K+2),K=L,M),IOUT
      ENDIF
      IF ( PLTHE .EQ. 1 ) THEN
        WRITE(CMON,'(A,F7.3,A,2(1X,F15.7),I8)') '^^PL LABEL ',AC,
     1               ' DATA ',STORE(L+4),STORE(L+5),ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ELSE IF ( PLTHE .EQ. 2 ) THEN
        WRITE(CMON,'(A,F7.3,A,2(1X,F15.7),I8)') '^^PL LABEL ',AC,
     1               ' DATA ',STORE(L+6),STORE(L+7),ISTORE(L+1)
        CALL XPRVDU(NCVDU, 1,0)
      ENDIF
C--- OUTPUT TO SCREEN
      IF (MONIT .NE. 1) THEN
      WRITE(CMON,5610)AC,ISTORE(L+1), STORE(L+2), STORE(L+3),
     2 (STORE(K+2),K=L+2,M) , IOUT
      CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      NZ=0
5700  CONTINUE
      AC=AC+WW
      L=L+ISTEP
5750  CONTINUE
C--PRINT THE FINAL VALUE
5800  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)AC,ICE
      ENDIF
      IF ( PLTHE .GT. 0 ) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF
C--- OUTPUT TO SCREEN
      IF (MONIT .NE. 2) THEN
      WRITE(CMON,5610)AC
      CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      ASSIGN 5850 TO K1T
      GOTO 5900
C
C--RETURN FROM THE AGREEMENT ANALYSIS PRINT ROUTINES
5850  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1050)
      ENDIF
      GOTO NCT,(1800,3100)
C
C
C--WRITE OUT THE TOTALS FOR EACH GROUP
5900  CONTINUE
      DO 5950 II=1,NCHAR
      IOUT(II)=IB
5950  CONTINUE
C--SET UP THE POINTS TO MARK
      DO 6000 II=1,NCHAR,NDIV
      IOUT(II)=ICE
6000  CONTINUE
      IOUT(ICENT)=IA
      ICEE=ICE
C--SET UP THE FORMATS
6050  CONTINUE
      CALL OVERFL(II)
      CALL XSUFS(CFY,CFN,CFC)
C--WRITE OUT THE BLANK LINE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1100)ICEE
      ENDIF
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,CFY)(NOPE(N2,5),N2=1,4),N,(APD(N2),N2=1,6),IOUT
      ENDIF
      GOTO K1T,(2350,3000,4550,4850,5400,5850)
C
C--COMPUTE THE TOTALS FOR ALL THE REFLECTIONS
6100  CONTINUE
      IF (N .EQ. 0) THEN
        R = 0.
        RW = 0.
        SS = 0.
        APD(3) = 0.
        APD(4) = 0.
        APD(5) = 0.
        APD(6) = 0.
      ENDIF
      R=1./FLOAT(N)
      RW=SQRT(APD(5)/APD(4))*100.
      SS=APD(3)/APD(12)*100.
      APD(3)=APD(7)*R
      APD(4)=APD(5)*R
      APD(5)=SS
      APD(6)=RW
      GOTO K2T,(3250,2450)
C
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPANA , IOPABN , 0 )
      GO TO 3100
9910  CONTINUE
C -- NOT ALL REFLECTIONS PROCESSED
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 ) NOCC
9915  FORMAT ( 1X , I5 , ' reflections left unprocessed' )
      ISTAT = IERWRN
C -- IF A NEW LIST 6 WAS TO HAVE BEEN PRODUCED , THIS IS AN ERROR
      IF ( MM2 .GT. 0 ) ISTAT = IERERR
      CALL XERHND ( ISTAT )
      GO TO 9900
9930  CONTINUE
      CALL XOPMSG ( IOPANA , IOPCMI , 0 )
      GO TO 9900
C
C
      END
C
CODE FOR GCOMPL
      SUBROUTINE GCOMPL
C--COMPUTE THE VALUES FOR A GROUP STORED AT 'L'
C
\ISTORE
C
\STORE
C
      COMMON /XWTWK/SCALF,R,RW,FOT,FCT,DFT,WDFT,E,F,AP,BP,AT,BT,AC,BC,
     2 ACI,BCI,ACT,BCT,FO,FC,VV,WW,DF,WDF,TC,T,NOCC,TFOCC,SS,S,H(3),
     3 INDEXA(3),MAXADD
      COMMON /XWTWKA/SCALC,IBASE(3),NW,ISTEP,NR,HMIN(3),HMAX(3),ITYPE,
     2 IPAR,IGEN,ICLS,JA,I,J,K,L,M,N,NX,NY,NZ,K1,K2,K3,NC,N1,JAA
\XUNITS
\XSSVAL
\XLISTI
\XCONST
\XCHARS
\XPDS
C
      COMMON/EXPLOT/NCHAR,ICE,ICENT,BMIN,BMAX,ADIV,IOUT(13)
C
\QSTORE
C
C
      R=1./FLOAT(ISTORE(L+1))
      SS=0.
      RW=0.
C----- CHECK IF W* /FO/ NOT TO SMALL
C--CALCULATE THE SIMPLE AND WEIGHTED R-FACTORS
      IF (STORE(L+9) .GE. .001) SS=STORE(L+4)/STORE(L+9)*100.
      IF (STORE(L+5) .GE. .001) RW=SQRT(STORE(L+6)/STORE(L+5))*100.
C--COMPUTE THE OTHER AVERAGES
      STORE(L+2)=STORE(L+2)*R
      STORE(L+3)=STORE(L+3)*R
      STORE(L+4)=STORE(L+8)*R
      STORE(L+5)=STORE(L+6)*R
      STORE(L+6)=SS
      STORE(L+7)=RW
C--SET THE PRINT LIMIT
      M=L+5
C--SET UP THE PLOT ARRAY
      DO 6300 II=1,NCHAR
      IOUT(II)=IB
6300  CONTINUE
      IOUT(ICENT)=ICE
C--COMPUTE THE POSITION OF THIS ENTRY
      SS=STORE(L+5)/APD(4)
C--CHECK FOR A ZERO VALUE
      IF(SS)6350,6600,6350
C--CHECK IF THE NUMBER IS TOO LARGE
6350  CONTINUE
      IF(SS-BMAX)6450,6450,6400
C--THIS NUMBER IS TOO LARGE  -  OUTPUT IT AS A '+'
6400  CONTINUE
      IOUT(NCHAR)=IPLUS
      GOTO 6600
C--CHECK IF THE NUMBER IS TOO SMALL
6450  CONTINUE
      IF(SS-BMIN)6500,6550,6550
C--THIS NUMBER IS TOO SMALL  -  OUTPUT IT AS A '-'
6500  CONTINUE
      IOUT(1)=MINUS
      GOTO 6600
C--THIS NUMBER IS IN RANGE  -  OUTPUT IT AS AN '*'
6550  CONTINUE
      II=INT(ALOG10(SS)*ADIV)+ICENT
      IOUT(II)=IA
C--RETURN TO THE CALLING ROUTINE
6600  CONTINUE
      CALL OVERFL(II)
      RETURN
      END
C
CODE FOR XSUFS
      SUBROUTINE XSUFS(CF1,CF2,CF3)
C
      CHARACTER *4 CF1(16),CF2(16),CF3(6)
C
      DO 100 I = 1, 6
        CF1(I) = CF3(I)
        CF2(I) = CF3(I)
100   CONTINUE
      RETURN
      END
C
CODE FOR XSUAA
      SUBROUTINE XSUAA(MM5, IULN06)
C--SET UP THE AGREEMENT ANALYSIS ROUTINES
C
C  MM5   SET TO ZERO IF THE ANALYSIS IS TO BE DONE ON THE SCALE
C        OF /FO/, ELSE TO 1
C
C--
\ISTORE
C
\STORE
C
      COMMON /XWTWK/SCALF,R,RW,FOT,FCT,DFT,WDFT,E,F,AP,BP,AT,BT,AC,BC,
     2 ACI,BCI,ACT,BCT,FO,FC,VV,WW,DF,WDF,TC,T,NOCC,TFOCC,SS,S,H(3),
     3 INDEXA(3),MAXADD
      COMMON /XWTWKA/SCALC,IBASE(3),NW,ISTEP,NR,HMIN(3),HMAX(3),ITYPE,
     2 IPAR,IGEN,ICLS,JA,I,J,K,L,M,N,NX,NY,NZ,K1,K2,K3,NC,N1,JAA
\XLISTI
\XCONST
\XUNITS
\XSSVAL
\XPDS
\XLST01
\XLST04
\XLST05
\XLST06
\XLST23
C
\QSTORE
C
C--SET UP THE LISTS FOR PROCESSING
      CALL XRSL
      CALL XCSAE
C--SET UP THE SCALE FACTORS
      SCALC=1.0
      SCALF=1.
C--CHECK IF THERE IS A LIST 5 STORED
      IF(KEXIST(5))1100,1100,1000
C--FETCH LIST 5 AND THEN USE THE SCALE FACTOR STORED THERE
1000  CONTINUE
      CALL XFAL05
      IF ( IERFLG .LT. 0 ) GO TO 9900
      SCALC=STORE(L5O)
      SCALF=1.
C--CHECK WHICH SCALE WE ARE TO USE
      IF(MM5)1100,1100,1050
C--SCALE OF /FC/
1050  CONTINUE
      SCALC=1.
      SCALF=1./STORE(L5O)
C--CHECK IF A LIST 23 IS ALREADY STORED
1100  CONTINUE
      ITYPE=-1
      IF(KEXIST(23))1200,1200,1150
C--LOAD LIST 23 AND FIND THE TYPE OF REFINEMENT WE ARE DOING
1150  CONTINUE
      CALL XFAL23
      IF ( IERFLG .LT. 0 ) GO TO 9900
      ITYPE=ISTORE(L23MN+1)
C--RESET THE CORE LIMTS
1200  CONTINUE
      CALL XRSL
      CALL XCSAE
C--LOAD A FEW LISTS
      CALL XFAL01
      CALL XFAL04
C
      CALL XFAL06(IULN06, 0)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--SET UP THE NUMBER OF WORDS PER STACK ENTRY
      NW = 10
C--SET UP THE NUMBER OF WORDS BETWEEN SUCCESSIVE RANGES
      ISTEP=11*NW
C--SET UP THE STEPS TO THE VARIOUS INDICES WITHIN A RANGE
      IBASE(1)=3*NW
      IBASE(2)=6*NW
      IBASE(3)=9*NW
C--SET UP THE PARITY STACK POINTER
      IPAR=NFL
C--SET UP THE REFLECTION CLASS STACK
      ICLS=IPAR+8*NW
C--SET UP THE GENERAL STACK POINTER
      IGEN=ICLS+16*NW
C--SET THE CURRENT MAXIMUM ADDRESS
      MAXADD=NFL
9900  CONTINUE
C -- NORMAL AND ERROR RETURN
      RETURN
      END
C
CODE FOR XSCAN
      SUBROUTINE XSCAN(MM2)
C--SCANS THE REFLECTIONS AND ACCUMMULATES THE NECESSARY TOTALS
C
C  MM2  THIS CONTROLS THE OUTPUT OF REFLECTIONS TO THE DISC AND THE
C       VALUES USED FOR THE LAYER SCALES
C
C       -1  LAYER SCALE FOR EACH GROUP IS 1.0
C        0  LAYER SCALE FOR EACH GROUP IS STORED, WHERE NECESSARY
C        1  LAYER SCALE FOR EACH GROUP IS STORED, WHERE NECESSARY,
C           AND SHOULD BE APPLIED TO THE STORED REFLECTIONS
C
C--
\ISTORE
C
\STORE
C
      COMMON /XWTWK/SCALF,R,RW,FOT,FCT,DFT,WDFT,E,F,AP,BP,AT,BT,AC,BC,
     2 ACI,BCI,ACT,BCT,FO,FC,VV,WW,DF,WDF,TC,T,NOCC,TFOCC,SS,S,H(3),
     3 INDEXA(3),MAXADD
      COMMON /XWTWKA/SCALC,IBASE(3),NW,ISTEP,NR,HMIN(3),HMAX(3),ITYPE,
     2 IPAR,IGEN,ICLS,JA,I,J,K,L,M,N,NX,NY,NZ,K1,K2,K3,NC,N1,JAA
\XUNITS
\XSSVAL
\XLISTI
\XCONST
\XPDS
\XLST01
\XLST05
\XLST06
C
\QSTORE
C
      NX=NW+NW
C----- READ/WRITE FLAG FOR KFNR
      IRWF = MAX0 ( 0 , MM2 )
      NOCC=0
C--SET THE FLAGS FOR MAX. AND MIN. /FO/ AND SIN(THETA)/LAMBDA
      E=-1000000.0
      F=-1000000.0
C--SET THE FLAGS FOR THE MAX. AND MIN. INDICES
      DO 1000 J=1,3
      HMIN(J)=1000000.0
      HMAX(J)=-1000000.0
1000  CONTINUE
C--SET UP THE GENERAL STACK IN THE REST OF THE CORE
      L=NFL
      I=(LFL-NFL)/NW
      LFL=LFL-NW
      DO 1200 J=1,I
C--CHECK IF WE SHOULD PRESET THE LAYER SCALE OR LEAVE IT ALONE
      IF(MM2)1050,1100,1100
C--SET THE LAYER SCALE FACTORS TO 1.0
1050  CONTINUE
      STORE(L)=1.
1100  CONTINUE
      L=L+1
C--ZERO THE REMAINING WORDS OF THIS ENTRY
      DO 1150 K=2,NW
      STORE(L)=0.
      L=L+1
1150  CONTINUE
1200  CONTINUE
C--CLEAR THE OVERALL TOTAL ENTRIES
C------ 12 ADDED MAY 97
      APD(12) = 0.0
      DO 1250 J=1,NW
      APD(J)=0.
      BPD(J)=0.
1250  CONTINUE
      APD(12) = 0.
      N=0
      GOTO 2100
C
C--PROCESS THE LAYER SCALE INFORMATION FOR THE NEXT REFLECTION  -  FETCH
1300  CONTINUE
      H(1)=STORE(M6)
      H(2)=STORE(M6+1)
      H(3)=STORE(M6+2)
      BP=ABS(H(NR))
C--COMPUTE THE ADDRESS FOR THIS INDEX
      L=IGEN+NINT(BP)*ISTEP+IBASE(NR)
C--APPLY THE SCALE FACTOR
      STORE(M6+3)=STORE(M6+3)*STORE(L)
C--COMPUTE /FO/, /FC/ AND THE WEIGHT FOR LAYER SCALING
      FO=STORE(M6+3)*SCALF
      S=XWEIGH(STORE(M6+3),STORE(M6+4))
      FC=STORE(M6+5)*SCALC
cdjwjan01
      if (jaa .le. 0) then
            fff = fo
      else
            fff = fc
      endif
C----- COMPUTE THE RANGE IN F
      IF (JA .LE. 0) THEN
        IF (fff .GE. ZERO) THEN
            BP = SQRT(fff)
        ELSE
            BP = ZERO
        ENDIF
      ELSE
            BP = fff
      ENDIF
C--COMPUTE VARIOUS DELTA FUNCTIONS
      DF=FO-FC
      N=N+1
      ACI=S*FO*FO
      ACT=DF*DF
      BCI=S*ACT
      AP=ABS(S*FO*FC)
C--ADD IN THE CONTRIBUTIONS FOR THIS REFLECTION
      CALL XSUM(L)
C--ADD IN THE CONTRIBUTIONS TO THE TOTALS
      BPD(1)=BPD(1)+ACI
      BPD(2)=BPD(2)+BCI
      BPD(3)=BPD(3)+AP
C--COMPUTE THE NORMAL WEIGHT AND THE ASSOCIATED DELTAS
      S=STORE(M6+4)*STORE(M6+4)
      ACI=S*FO*FO
      ACT=DF*DF
C--CHECK IF WE ARE REFINING AGAINST /FO/ **2
      IF(ITYPE)1400,1350,1350
C--WE ARE REFINING AGINST /FO/ **2
1350  CONTINUE
      ACI=ACI*FO*FO
      ACT=ABS(FO)*FO-FC*FC
      ACT=ACT*ACT
C--COMPUTE THE WEIGHTED DELTA SQUARED
1400  CONTINUE
      BCI=S*ACT
      AP=S*FO*FC
C--ADD IN OVERALL TOTALS
      APD(1)=APD(1)+FO
      APD(2)=APD(2)+FC
      APD(3)=APD(3)+ABS(ABS(FO) - FC)
      APD(4)=APD(4)+ACI
      APD(5)=APD(5)+BCI
      APD(6)=APD(6)+AP
      APD(7)=APD(7)+ACT
      APD(12)=APD(12)+ABS(FO)
C--ADD IN THE TOTALS FOR THE INDICES
      L=KPOSN(1)
      CALL XSUM(L)
      L=KPOSN(2)
      CALL XSUM(L)
      L=KPOSN(3)
      CALL XSUM(L)
C--ADD IN THE TOTAL FOR THE /FO/ RANGES
C--COMPUTE THE RANGE ADDRESS
1500  CONTINUE
      L=IGEN+IFIX(BP/VV)*ISTEP
C--COMPUTE THE MAX. /FO/ VALUE
      F=AMAX1(F,BP)
      CALL XSUM(L)
C--SIN(THETA)/LAMBDA RANGES  -  COMPUTE SIN(THETA)/LAMBDA
      SS=H(1)*H(1)*STORE(L1S)+H(2)*H(2)*STORE(L1S+1)+H(3)*H(3)
     2 *STORE(L1S+2)+H(2)*H(3)*STORE(L1S+3)+H(1)*H(3)*STORE(L1S+4)+H(1)
     3 *H(2)*STORE(L1S+5)
      L=IGEN+NW+IFIX(SS/WW)*ISTEP
C--COMPUTE THE MAX. VALUE OF SIN(THETA)/LAMBDA
      E=AMAX1(E,SS)
      CALL XSUM(L)
C--TOTALS FOR THE DIFFERENT PARITY GROUPS
      L=ICLS
C--BASED ON THE PARITY OF THE INDIVIDUAL INDICES
      DO 1650 I=1,3
      M=L
C--COMPUTE THE PARITY OF THE INDEX
      J=NINT(H(I))
      INDEXA(I)=IABS(J)
      IF(J/2*2-J)1550,1600,1550
1550  CONTINUE
      M=M+NW
1600  CONTINUE
      CALL XSUM(M)
      L=L+NX
1650  CONTINUE
      J=NINT(H(1)+H(2)+H(3))
C--COMPUTE THE TOTALS BASED ON THE PARITY OF K+L, H+L AND H+K
      DO 1800 I=1,3
C--COMPUTE THE MAX. AND MIN. VALUES OF THE INDEICES
      HMAX(I)=AMAX1(H(I),HMAX(I))
      HMIN(I)=AMIN1(H(I),HMIN(I))
      K=J-NINT(H(I))
      M=L
C--COMPUTE THE PARITY OF THE REQUIRED COMBINATION
      IF(K/2*2-K)1700,1750,1700
1700  CONTINUE
      M=M+NW
1750  CONTINUE
      CALL XSUM(M)
      L=L+NX
1800  CONTINUE
      M=L
C--COMPUTE THE PARITY OF H+K+L AND ADD IN THE CONTRIBUTION
      IF(J/2*2-J)1850,1900,1850
1850  CONTINUE
      M=M+NW
1900  CONTINUE
      CALL XSUM(M)
      L=L+NX
      M=L
C--COMPUTE THE VALUE OF -H+K+L, AND THEN CHECK IF IT IS 3N
      J=J-2*NINT(H(1))
      IF(J/3*3-J)1950,2000,1950
1950  CONTINUE
      M=M+NW
2000  CONTINUE
      CALL XSUM(M)
C--TOTALS FOR THE PARITY GROUP OF THIS REFLECTION
      M=IPAR+NW*(INDEXA(1)-INDEXA(1)/2*2+(INDEXA(2)-INDEXA(2)/2*2)
     2 *2+(INDEXA(3)-INDEXA(3)/2*2)*4)
      CALL XSUM(M)
C--CHECK IF WE MUST STORE THE INFORMATION FOR THIS REFLECTION
      IF(MM2)2100,2100,2050
C--STORE THE MODIFIED REFLECTION
2050  CONTINUE
      CALL XSLR(1)
      CALL XACRT(4)
C--FETCH THE NEXT REFLECTION
2100  CONTINUE
      IF(KFNR(IRWF))2150,1300,1300
C
C--EXIT
2150  CONTINUE
      RETURN
      END
C
CODE FOR XSUM
      SUBROUTINE XSUM(NOC)
C--SUBROUTINE FOR ACCUMMULATING THE TOTALS
C
C  NOC  LOCATION OF THE ENTRY TO BE INCREMENTED
C
C--FORMAT OF THE ENTRY AT NOC :
C
C  0  LAYER SCALE FOR THIS GROUP (IF NEC.)
C  1  NUMBER OF OBSERVATIONS
C  2  SUM OF /FO/
C  3  SUM OF /FC/
C  4  SUM OF /DF/
C  5  SUM OF W* /FO/ **2
C  6  SUM OF W* /DF/ **2
C  7  SUM OF W* /FO/ * /FC/
C  8  SUM OF /DF/ **2
C
C--
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
C
      COMMON /XWTWK/SCALF,R,RW,FOT,FCT,DFT,WDFT,E,F,AP,BP,AT,BT,AC,BC,
     2 ACI,BCI,ACT,BCT,FO,FC,VV,WW,DF,WDF,TC,T,NOCC,TFOCC,SS,S,H(3),
     3 INDEXA(3),MAXADD
      COMMON /XWTWKA/SCALC,IBASE(3),NW,ISTEP,NR,HMIN(3),HMAX(3),ITYPE,
     2 IPAR,IGEN,ICLS,JA,I,J,K,L,M,N,NX,NY,NZ,K1,K2,K3,NC,N1,JAA
C
\QSTORE
C
C--CHECK FOR A CORE OVERFLOW
      IF(NOC-LFL)1250,1000,1000
1000  CONTINUE
      NOCC=NOCC+1
C--CHECK IF WE HAVE PRINTED SUFFICIENT REFLECTIONS
      IF(NOCC-25)1050,1150,1300
C--PRINT THIS REFLECTION
1050  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1100)(H(I),I=1,3),FO
      ENDIF
1100  FORMAT(/3F5.0,F10.1,'  Reflection out of range')
      GOTO 1300
C--TERMINATE THE REFLECTION PRINT
1150  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1200)
      ENDIF
1200  FORMAT(//,' and so on . . . . .')
      GOTO 1300
C--ADD IN THE TOTALS
1250  CONTINUE
      ISTORE(NOC+1)=ISTORE(NOC+1)+1
      STORE(NOC+2)=STORE(NOC+2)+FO
      STORE(NOC+3)=STORE(NOC+3)+FC
      STORE(NOC+4)=STORE(NOC+4)+ABS(ABS(FO)-FC)
      STORE(NOC+5)=STORE(NOC+5)+ACI
      STORE(NOC+6)=STORE(NOC+6)+BCI
      STORE(NOC+7)=STORE(NOC+7)+AP
      STORE(NOC+8)=STORE(NOC+8)+ACT
      STORE(NOC+9)=STORE(NOC+9)+ABS(FO)
C--UPDATE THE MAXIMUM CORE ADDRESS
      MAXADD=MAX0(MAXADD,NOC+9)
1300  CONTINUE
      RETURN
      END
C
C
CODE FOR XWEIGH
      FUNCTION XWEIGH(A,B)
C
      A = A
      XWEIGH=B*B
      RETURN
      END
C
CODE FOR KPOSN
      FUNCTION KPOSN(NDJW)
C--CALCULATE THE INDEX POSITION IN THE STACK
C
\ISTORE
C
\STORE
C
      COMMON /XWTWK/SCALF,R,RW,FOT,FCT,DFT,WDFT,E,F,AP,BP,AT,BT,AC,BC,
     2 ACI,BCI,ACT,BCT,FO,FC,VV,WW,DF,WDF,TC,T,NOCC,TFOCC,SS,S,H(3),
     3 INDEXA(3),MAXADD
      COMMON /XWTWKA/SCALC,IBASE(3),NW,ISTEP,NR,HMIN(3),HMAX(3),ITYPE,
     2 IPAR,IGEN,ICLS,JA,I,J,K,L,M,N,NX,NY,NZ,K1,K2,K3,NC,N1,JAA
C
\QSTORE
C
      NI=NINT(H(NDJW))
      NJ=NW
      IF(NI)1000,1050,1050
1000  CONTINUE
      NJ=-NW
      NI=IABS(NI)
1050  CONTINUE
      KPOSN=IGEN+NI*ISTEP+IBASE(NDJW)+NJ
      RETURN
      END
C
CODE FOR XFAL04
      SUBROUTINE XFAL04
C--ROUTINE TO LOAD LIST 4 FROM THE DISC
C
C--
\ISTORE
\ICOM04
C
\STORE
\XLST04
\XUNITS
\XSSVAL
C
\QSTORE
\QLST04
C
\IDIM04
C--LOAD THE LIST
      CALL XLDLST(4,ICOM04,IDIM04,-1)
      IF ( IERFLG .LT. 0 ) RETURN

      ITYPE4=ISTORE(L4C) ! SET THE TYPE OF WEIGHTING SCHEME
      ICON41=ISTORE(L4C+1) ! SET THE TYPE OF WEIGHT MODIFICATION TO BE DONE
      IROBUS=ISTORE(L4C+2) !SET THE ROBUST FLAG
      IDUNIT=ISTORE(L4C+3) !SET THE DUNITZ-SEILER FLAG
      ROBTOL=STORE(L4F+2)  !SET THE ROBUST TOLERANCE
      DUN01 =STORE(L4F+3)  !SET DUN-SEI PARAM 1
      DUN02 =STORE(L4F+4)  !SET DUN-SEI PARAM 2

      RETURN
      END

