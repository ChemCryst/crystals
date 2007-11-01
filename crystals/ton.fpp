CODE FOR TONSPK
      SUBROUTINE TONSPK(iplot, itemp, ITYP06)
C
C     TON SPEK'S ENANTIOPOLE
c seriously based on ton's own code with his permission and help
C
C
      INCLUDE 'ISTORE.INC'
C
      DIMENSION LISTS( 6 )
      dimension datc(401)
      character *80 line
      character *20 form
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCOMPD.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA NLISTS / 3 /
      DATA LISTS(1)/5/, LISTS(2)/6/, LISTS(3)/30/
C
c      set packing constants
      parameter(npak=256)
      parameter(n2=npak/2)

      IERROR = 1
C
      call xrsl
      call xcsae
C--FIND OUT IF LISTS EXIST
      IERROR = 1
      DO 1300 N=1 , NLISTS
       LSTNUM = LISTS(N)
cdjwsep07 check the type of reflections
       if (lstnum .eq. 6) then
          IULN6 = KTYP06(ITYP06)
       endif
c
       IF (LSTNUM .EQ. 0 ) GOTO 1300
        IF (  KEXIST ( LSTNUM )  ) 1210 , 1200 , 1220
1200    CONTINUE
          WRITE ( NCAWU , 1205 ) LSTNUM
          IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1205) LSTNUM
          WRITE ( CMON, 1205 ) LSTNUM
          CALL XPRVDU(NCEROR, 1,0)
1205      FORMAT ( 1X , 'List ' , I2 , ' contains errors')
          IERROR = -1
          GOTO 1300
1210    CONTINUE
          WRITE ( NCAWU , 1215 ) LSTNUM
          IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1215) LSTNUM
          WRITE ( CMON, 1215 ) LSTNUM
          CALL XPRVDU(NCEROR, 1,0)
1215      FORMAT ( 1X , 'List' , I2 , ' does not exist' )
          IERROR = -1
          GOTO 1300
1220    CONTINUE
        IF (LSTNUM .EQ.  5) THEN
            CALL XFAL05
        else IF (LSTNUM .EQ. 30) THEN
            CALL XFAL30
        ELSE IF (LSTNUM .EQ. 6) THEN
            CALL XFAL06(IULN6,0)
        ENDIF
1300  CONTINUE
      IF ( IERROR .LE. 0 ) GOTO 9900
C
C----- OUTPUT A TITLE, FIRST 20 CHARACTERS ONLY
C      WRITE(NCFPU1,1320) (KTITL(I),I=1,20)
1320  FORMAT(' ',20A4)
C
C--- LOAD LIST 5
      CALL XFAL05
      SCALE = STORE(L5O)
      SCALE = 1./(SCALE*SCALE)
C
C----- LOAD LIST 6
      CALL XFAL06(IULN6,0)
C
c----- initialise tons accumulators etc
c      accumulators 
        RCT  = 0.0
        RCN  = 0.0
c      plus and minus accumulators
        NPLS = 0
        NMIN = 0
        sum = 0.
        sumw = 0.
        STEP = 0.025
        NSP1 = NINT (1.0 / STEP)
        nstp_401 = 10 * NSP1 + 1
        nspt_201 = 5  * NSP1 + 1
        nspm_161 = nspt_201 - NSP1 
        nspp_241 = nspt_201 + NSP1 
        CALL xzerof (DATC, nstp_401)
c yslope is gradient of normal probability plot
c should be about unity anyway
        yslope = 1.
c
      IN = 0
C----- GET FIRST REFLECTION
      ISTAT = KLDRNR (IN)
      IF (ISTAT .LT. 0) GOTO 2000
      IF (KALLOW(IN) .LT. 0) THEN
            JCODE = 1
      ELSE
            JCODE = 0
      ENDIF
      I = NINT(STORE(M6))
      J = NINT(STORE(M6+1))
      K = NINT(STORE(M6+2))
c       pack into h1
      h1 = npak*npak*(i+n2) +npak*(j+n2) +k+n2
      FSIGN = STORE(M6+3)
      SIG = STORE(M6+12)
C----- RETURN THE SIGNED STRUCTURE AMPLITUDE AND THE CORRESPONDING SIGMA
C      FROM A SIGNED STRUCTURE FACTOR
      CALL XSQRF (FSQ,FSIGN,FABS,SIGSQ,SIG)
      FOK1 = FSQ*SCALE
      SIG1 = SIGSQ*SCALE
      FCK1 = STORE(M6+5)*STORE(M6+5)
      FRIED1 = STORE(M6+6)
      nfried = 0
C----- LOOP OVER REST OF DATA
1800  CONTINUE
      ISTAT = KLDRNR (IN)
      IF (ISTAT .LT. 0) GOTO 2000
      IF (KALLOW(IN) .LT. 0) THEN
            JCODE = 1
      ELSE
            JCODE = 0
      ENDIF
      I = NINT(STORE(M6))
      J = NINT(STORE(M6+1))
      K = NINT(STORE(M6+2))
c       pack into h1
      h2 = npak*npak*(i+n2) +npak*(j+n2) +k+n2
      FSIGN = STORE(M6+3)
      SIG = STORE(M6+12)
C----- RETURN THE SIGNED STRUCTURE AMPLITUDE AND THE CORRESPONDING SIGMA
C      FROM A SIGNED STRUCTURE FACTOR
      CALL XSQRF (FSQ,FSIGN,FABS,SIGSQ,SIG)
      FOK2 = FSQ*SCALE
      SIG2 = SIGSQ*SCALE
      FCK2 = STORE(M6+5)*STORE(M6+5)
      FRIED2 = STORE(M6+6)
C
      IF (H1 .EQ. H2) THEN
      nfried = nfried + 1
      fokd = fok1-fok2
      fckd = fck1-fck2
      sigm = sqrt(sig1*sig1+sig2*sig2)
      zh = (fckd-fokd)/sigm
      qh = (-fckd-fokd)/sigm


C COLLECT PROBABILITY DISTRIBUTION DATA FOR FLEQ (SFLEQ)
c DATC is x(gamma), YK is gamma
      DO 50 J = 1, nstp_401 
       YK = (J - nspt_201) * STEP 
       DATC(J) = DATC(J) - (((YK * FCKD - FOKD) / SIGM)**2) / 2
   50 CONTINUE
      RCT   = RCT + FOKD * FCKD / SIGM
      RCN   = RCN + FCKD**2 / SIGM
      IF (FOKD * FCKD .GT. 0.0) THEN
c  same sign
       NPLS = NPLS + 1
      ELSE
c  opposite sign
       NMIN = NMIN + 1
      ENDIF
      IF (ABS(FOKD) .LT. 3.0 * ABS(FCKD)) THEN
              XMAX  = MAX (XMAX, ABS(FCKD))
              YMAX  = MAX (YMAX, ABS(FOKD))
      ENDIF
      IF (FCKD .NE. 0.0) THEN
              RATIO = FOKD / FCKD
              RATIO1 = ABS(FCKD) / (FCK1 + FCK2)
              DCDOS = (FCKD - FOKD) / SIGM
              DDP   = MAX (DDP, DCDOS)
              DDM   = MIN (DDM, DCDOS)
              IF (SIGM .GT. 0.0) THEN
                WGHT  = ABS(FCKD) / SIGM
                SUM   = SUM  + WGHT * RATIO
                SUMW  = SUMW + WGHT
              ENDIF
      ENDIF
   70     CONTINUE
c 
c
      end if
      h1 = h2
      FOK1 = FOK2
      sig1 = sig2
      fck1 = fck2
C      GET NEXT REFLECTION
      GOTO 1800
2000  CONTINUE
c---- all refelctions processed.
c---- compute goodies
          SUM = SUM / SUMW 
c  yslope is the gradient of the normal probability plot
          IF (nfried .NE. 0) THEN
            DO 75 J = 1, nstp_401 
              DATC(J) = DATC(J) / YSLOPE**2 
   75       CONTINUE
          ENDIF
C DETERMINE LARGEST LOG-PROBABILITY FOR SCALING
          DATCM = DATC(1)
          DO 80 J = 2, nstp_401 
            IF (DATC(J) .GT. DATCM) DATCM = DATC(J)
   80     CONTINUE
C CALCULATE G, SIGMA(G), FLEQ AND SIGMA(FLEQ) WITH BAYESIAN STATISTICS
          XG0 = 0.0
          XG1 = 0.0
          XG2 = 0.0
c equation 23 and 24
          DO 90 J = 1, nstp_401 
            YK  = (J - nspt_201) * STEP 
            XG1 = XG1 + YK * EXP (DATC(J) - DATCM)
            XG0 = XG0 +      EXP (DATC(J) - DATCM)
   90     CONTINUE
c  'G' parameter
          XG  = XG1 / XG0
c  su 'G' parameter
          DO 100 J = 1, nstp_401 
            YK  = (J - nspt_201) * STEP 
            XG2 = XG2 + (YK - XG)**2 * EXP (DATC(J) - DATCM)
  100     CONTINUE
          XGS = SQRT(XG2/XG0)
c  Pseudo-Flack Parameters
          tony = (1.0 - XG) / 2.0
          tonsy = SQRT (XG2 / XG0) / 2.0
          write(cmon,'(/)')
          CALL XPRVDU(NCVDU, 1,0)
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
          WRITE ( CMON,'(10(a,i7))')
     1 '       No of Friedel Pairs =', nfried
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(/A)') CMON(1 )(:)
          WRITE (CMON,'(A)') 
     1    'Flack parameter obtained from original refinement'
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
c
          WRITE (CMON,'(A)') 
     1    'Hooft parameter obtained with Flack x set to zero'
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
c
          WRITE (CMON,'(a,2f10.4)') 'Flack Parameter & su', 
     1    store(l30ge+6), store(l30ge+7)
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(/A)') CMON(1 )(:)

          if (store(l30ge+7) .ge. .3) then
            write(cmon,'(/a/a/)') 
     1 'The absolute configuration has not been reliably determined',
     1 'Flack & Bernardinelli., J. Appl. Cryst. (2000). 33, 1143-1148'
          CALL XPRVDU(NCVDU, 4,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(/A)') CMON(2 )(:)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(3 )(:)
          endif




          WRITE (CMON,'(a,2f10.4)') 'Hooft Parameter & su', tony,tonsy
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
          WRITE (CMON,'(a,4f10.4)') '          Ton G & su', xg,xgs
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
          write(cmon,'(/)')
          CALL XPRVDU(NCVDU, 1,0)
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
c
C CALCULATE P3(0),P3(TW),P3(1)  
          XPLLL = DATC(nspp_241) - DATCM 
          XMNLL = DATC(nspm_161) - DATCM
          XPLLL = EXP(XPLLL)
          XMNLL = EXP(XMNLL)
          IF (ABS(ABS(tony - 0.5) - 0.5) .LT.
     1        MAX (0.1, 3 * tonsy)) THEN
            XPLL2 = XPLLL / (XPLLL + XMNLL)
          ELSE
            XPLL2 = -1.0 
          ENDIF
          XTWLL = DATC(nspt_201) - DATCM 
          XTWLL = EXP(XTWLL)
          XSMLL = XPLLL + XTWLL + XMNLL
          XPLLL = XPLLL / XSMLL
          XMNLL = XMNLL / XSMLL
          XTWLL = XTWLL / XSMLL
          IF (RCN .NE. 0) THEN
            RCO = RCT / RCN
          ELSE
            RCO = 0.0
          ENDIF
C
          IF (ISSPRT .EQ. 0) then
99991 FORMAT ('Aver. Ratio', F10.3)
            WRITE (LINE, 99970) RCO 
99970 FORMAT ('RC .........', F9.3)
            WRITE (ncwu,  99968) LINE
          endif

C P2(True)
            IF (XPLL2 .GT. 0.001) THEN
              WRITE (FORM, 99961) XPLL2
99961 FORMAT (F9.3)
            ELSE IF (XPLL2 .LT. 0.0) THEN
              WRITE (FORM, 99955)
99955 FORMAT (6X, 'n/a')
            ELSE
              WRITE (FORM, 99962) XPLL2
99962 FORMAT (E9.1)
            ENDIF
            WRITE (LINE, 99956) FORM 
99956 FORMAT ('P2(true)    ', A)
          write(cmon,99968) line
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE
99968 FORMAT (A)

C P3(True)
            IF (XPLLL .GT. 0.001) THEN
              WRITE (FORM, 99961) XPLLL
            ELSE IF (XPLLL .LT. 0.0) THEN
              WRITE (FORM, 99955) 
            ELSE
              WRITE (FORM, 99962) XPLLL
            ENDIF
            WRITE (LINE, 99979) FORM 
99979 FORMAT ('P3(true)    ', A)
          write(cmon,99968) line
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE

C P3(Twin)
            IF (XTWLL .GT. 0.001) THEN
              WRITE (FORM, 99961) XTWLL
            ELSE IF (XTWLL .LT. 0.0) THEN
              WRITE (FORM, 99955)
            ELSE
              WRITE (FORM, 99962) XTWLL
            ENDIF
            WRITE (LINE, 99977) FORM  
99977 FORMAT ('P3(rac-twin)', A)
          write(cmon,99968) line
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE
C P3(False)
            IF (XMNLL .GT. 0.001) THEN
              WRITE (FORM, 99961) XMNLL
            ELSE IF (XMNLL .LT. 0.0) THEN
              WRITE (FORM, 99955)
            ELSE
              WRITE (FORM, 99962) XMNLL
            ENDIF
            WRITE (LINE, 99978) FORM 
99978 FORMAT ('P3(false)   ', A)
          write(cmon,99968) line
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE
            WRITE (LINE, 99972) XG    
99972 FORMAT ('G           ', F9.4)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE
             YUNK = SQRT (XG2 / XG0)
            IF (YUNK .GT. 0.0001) THEN
              WRITE (FORM, 99960) YUNK 
99960 FORMAT (F9.4)
            ELSE
              WRITE (FORM, 99962) YUNK 
            ENDIF
            WRITE (LINE, 99971) FORM 
99971 FORMAT ('G S.U.      ', A)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE
            WRITE (LINE, 99976) tony  
99976 FORMAT ('FLEQ        ', F9.3)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE
            IF (tonsy .GT. 0.001) THEN
              WRITE (FORM, 99961) tonsy 
            ELSE
              WRITE (FORM, 99962) tonsy
            ENDIF
            WRITE (LINE, 99975) FORM   
99975 FORMAT ('FLEQ S.U.   ', A)
          IF (ISSPRT .EQ. 0) WRITE (ncwu,  99968) LINE

          write(cmon,'(/)')
          CALL XPRVDU(NCVDU, 1,0)
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
C
      RETURN
C
9900  CONTINUE
C -- ERRORS DETECTED
      CALL XERHND ( IERWRN )
      RETURN
      END
