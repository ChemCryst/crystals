SUBROUTINE XROTOR (NORD, M5ARI, M2T, RHOSQ, AT, BT) !, DSIZE, DDECLINA, DAZIMUTH)
    use xconst_mod, only : twopi
    use xlst01_mod
    COMMON/BESS/DBJB(20), LM(6), TD, TE, MODE, RIRA, BR, BEA, BDD
    COMMON/ROTOR/ ACAL, BCAL, KSEL(100)
    INCLUDE 'ISTORE.INC'
    INTEGER NORD, QW, NK, PNA, INV1, NAA, NAD, K
    REAL REFLH, REFLK, REFLL, HT
    REAL Q1, Q2, Q3, Q4, Q5, Q6
    REAL XC, YC, ZC, GP, BD, CC, DD
    REAL XETA, ANGLE, ANGLEDD, ANGLEED, ANGLEE, ANGLED, TCOM, BIO, ANGLEXID, ANGLEXI
    REAL DA(180), DB(180), BIA(20)
    REAL BDTERM, RTERM, DTERM, ETERM, GTERM, MTERM !, LTERM
    REAL AP, CD, SD, CE, SE, CW, CU, SU
    REAL XK1, XK2, XK3
    REAL DELCE, DELDE, DELDD, DELAPD, DELAPE, DXETA, DXETAD, DXETAE
    REAL DMD, DME, AT, BT, SUM(6)
    DOUBLE PRECISION CLIMIT
    REAL DELMC(2, 6), DELMS(2, 6) !, DELC(2, 3), DELS(2, 3)

    INCLUDE 'STORE.INC'
    INCLUDE 'QSTORE.INC'
    !todo: are these all of the correct type?

    !todo: I've just initiated these arbitrarily
    INV1 = 0.
    NAD = 0.
    BR = 0.
    BDD = 0.
    BEA = 0.
    MODE = 0
    K = 6
    REFLH = STORE(M2T) / TWOPI      ! Wasteful, but required.
    REFLK = STORE(M2T + 1) / TWOPI
    REFLL = STORE(M2T + 2) / TWOPI
    HT = STORE(M2T + 3) !/ TWOPI !this is only used here
    RIRA = STORE(M5ARI + 8)
    CLIMIT = 0.001
    XC = STORE(M5ARI + 4)
    YC = STORE(M5ARI + 5)
    ZC = STORE(M5ARI + 6)
    GP = STORE(M5ARI + 2)
    BB = STORE(M5ARI + 7) !(never used)
    BD = STORE(M5ARI + 12)
    !POLAR ANGLES IN UNITS OF 100 DEGREES
    ANGLEDD = STORE(M5ARI + 9)
    ANGLEED = STORE(M5ARI + 10)
    ANGLEXID = STORE(M5ARI + 11) !angle xi in 100 degrees
    !TRANSFORM TO RADIANS
    ANGLED = ANGLEDD * TWOPI / 3.6
    ANGLEE = ANGLEED * TWOPI / 3.6
    ANGLEXI = ANGLEXID * TWOPI / 3.6
    !GET THE MATRIC ELEMENTS (Q1-Q6)
    Q1 = STORE(L1O2 + 0)
    Q2 = STORE(L1O2 + 1)
    Q3 = STORE(L1O2 + 2)
    Q4 = STORE(L1O2 + 4)
    Q5 = STORE(L1O2 + 5)
    Q6 = STORE(L1O2 + 8)
    write(888,*) "Q1-6", Q1, Q2, Q3, Q4, Q5, Q6
    !SET I0 (BIO)
    call BESSEL(BSUM, 0, BD, 1.0)
    BIO = bsum
    !SET Ip FROM 1 TO 20 (BIA)
    DO JP = 1, 20
        call BESSEL(BSUM, JP, BD, 1.0)
        BIA(JP) = bsum
    END DO
    DBIB = BIA(1)
    TE = 0.
    TD = 0.
    QW = 0.
    NK = MOD(NORD, 2) + 1
    CD = COS(ANGLED)
    SD = SIN(ANGLED)
    CE = COS(ANGLEE)
    SE = SIN(ANGLEE)
    DO IWA = 1, 2
        DO IW = 1, 6
            DELMC(IWA, IW) = 0.0
            DELMS(IWA, IW) = 0.0
        end do
    end do
    CODE = 0
    ICODE = 0 !todo: get rid of ICODE completely

    CP = cos(HT)
    SP = sin(HT)

    !calculate c and d and then a'
    XK1 = REFLH * Q1 + REFLK * Q2 + REFLL * Q3
    XK2 = REFLL * Q6
    XK3 = REFLK * Q4 + REFLL * Q5
    CC = TWOPI * RIRA * (XK1 * CD * CE + XK3 * CD * SE - XK2 * SD)
    DD = TWOPI * RIRA * (-XK1 * SE + XK3 * CE)
    AP = SQRT(CC**2 + DD**2)
    !    XETA = ACOS(CC / AP)
    XETA = ATAN2(DD, CC)
    !    IF (DD<0.0) XETA = -XETA
    ANGLE = NORD * (ANGLEXI - XETA)
    IF (MODE==1) GO TO 2
    DELCE = TWOPI * RIRA * (-XK1 * CD * SE + XK3 * CD * CE)
    DELDE = -TWOPI * RIRA * (XK1 * CE + XK3 * SE)
    DELDD = 0
    DELCD = -TWOPI * RIRA * (XK1 * SD * CE + XK2 * CD + XK3 * SD * SE)
    DELAPD = CC * DELCD / AP
    DELAPE = (CC * DELCE / AP) + (DD * DELDE / AP)

    TE = DELAPE / AP
    TD = DELAPD / AP

    CW = 1 / (AP * CC)

    IF (ABS(CW)<0.00001) GO TO 1 !TO AVOID /0 ERROR?

    DXETAD = - DD * CW * DELAPD
    DXETAE = CW * (AP * DELDE - DD * DELAPE)

    GO TO 2
    1     ICODE = 1
    2     IF (NK==2) GO TO 3
    !!!CALCULATION OF REAL TERMS
    15    NPRIME = NK * NORD / 2
    NAA = 1
    GO TO 21
    22    E = SNGL(AP)
    CALL BESSEL(BJ, QW, E, -1.0)
    SUM(1) = DBIB * BJ
    SUM(2) = BR
    SUM(3) = BDD
    SUM(4) = BEA
    SUM(5) = 0.
    SUM(6) = BJ
    GO TO 5
    !!!CALCULATION OF IMAGINARY TERMS
    3     NPRIME = (NORD - 1) / 2
    DO IA = 1, 6
        SUM(IA) = 0.
    end do
    NAA = 2
    21    DO IA = 1, 6
        LM(IA) = 1
    end do
    IF(NAA==1) GO TO 22
    5     PSIGN = 1.
    IF (ICODE==0) GO TO 16 !i.e. if there isn't a divide by 0 error, go to 16 and skip setting these to 0
    SUM(3) = 0. !instead of BDD
    SUM(4) = 0. !instead of BEA
    LM(3) = 0
    LM(4) = 0
    16    DO IA = 1, NPRIME
        PSIGN = PSIGN * (-1)
    end do
    SIGN = PSIGN
    IF (NK==2) PSIGN = -1.
    NL = 1
    IF (NAA/=NK) NL = 2
    !!!CALCULATION OF M AND DERIVATIVES
    DO JP = NL, 20, NK
        PNA = JP * NORD
        CU = COS(JP * ANGLE)
        SU = SIN(JP * ANGLE)
        TCOM = 2. * SIGN * BIA(JP) / BIO
        E = SNGL(AP)
        CALL BESSEL (BJ, PNA, E, -1.0)
        IF (MODE==1) GO TO 34 !i.e. skip a load of derivation bits
        IF (LM(1)==0) GO TO 30
        !!!CALCULATION OF dM/d(Bd) [42]
        BDTERM = 2. * SIGN * CU * DBJB(JP) * BJ
        SUM(1) = SUM(1) + BDTERM
        IF (ABS(BDTERM / SUM(1))<CLIMIT) LM(1) = 0
        30      IF(LM(2)==0) GO TO 31
        !!!CALCULATION OF dM/dR [45] (DSIZE)
        RTERM = TCOM * BR * CU
        SUM(2) = SUM(2) + RTERM
        IF (ABS(RTERM / SUM(2))<CLIMIT) LM(2) = 0
        31      IF (LM(3)==0) GO TO 32
        !!!CALCULATION OF DELMD [48] (this is DDECLINA)
        DMD = SU * PNA * DXETAD
        DTERM = TCOM * (BDD * CU + BJ * DMD)
        SUM(3) = SUM(3) + DTERM
        IF (ABS(DTERM / SUM(3))<CLIMIT) LM(3) = 0
        32      IF(LM(4)==0) GO TO 33
        !!!CALCULATION OF dM/dE [50] (this is DAZIMUTH)
        DME = SU * PNA * DXETAE
        ETERM = TCOM * (BEA * CU + BJ * DME)
        SUM(4) = SUM(4) + ETERM
        IF (ABS(ETERM / SUM(4))<CLIMIT) LM(4) = 0
        33      IF (LM(5)==0) GO TO 34
        !!!CALCULATION OF dM/dG [47]
        GTERM = -PNA * TCOM * SU * BJ
        SUM(5) = SUM(5) + GTERM
        IF (ABS(GTERM / SUM(5))<CLIMIT) LM(5) = 0
        34      IF(LM(6)==0) GO TO 35
        !!!CALCULATION OF M [33]
        MTERM = TCOM * CU * BJ
        SUM(6) = SUM(6) + MTERM
        IF(ABS(MTERM / SUM(6))<CLIMIT) LM(5) = 0
        35      LSUM = LM(1) + LM(2) + LM(3) + LM(4) + LM(5) + LM(6)
        IF (MODE==1) LSUM = LM(6)
        IF (LSUM==0) GO TO 12
        SIGN = SIGN * PSIGN
    end do
    12    IF (MODE==1) GO TO 7
    SUM(1) = (SUM(1) - SUM(6) * DBIB) / BIO
    DO IA = 1, 5
        DELMC(NAA, IA) = DELMC(NAA, IA) + SUM(IA) * CP
        DELMS(NAA, IA) = DELMS(NAA, IA) + SUM(IA) * SP
    end do
    7     DELMC(NAA, 6) = DELMC(NAA, 6) + SUM(6) * CP
    DELMS(NAA, 6) = DELMS(NAA, 6) + SUM(6) * SP

    IF(NAA==2) GO TO 15

    AT = DELMC(1, 6) - DELMS(2, 6)

    IF (NAD==2) GO TO 40

    BT = DELMC(2, 6) + DELMS(1, 6)

    40    IF(MODE==1) GO TO 9

    !!!CALCULATION OF DELFD TO DFLF3
    DO IA = 1, 5
        DA(K) = DELMC(1, IA) - DELMS(2, IA)
        IF(INV1==1) GO TO 52
        DB(K) = DELMC(2, IA) + DELMS(1, IA)
        if (K==9) THEN
            WRITE(999, *) "E", anglee, REFLH, REFLK, REFLL, AT, BT, DA(K), DB(K)
        end if
        52      K = K + 1
    end do
    9     RETURN
END

SUBROUTINE BESSEL(BSUM, PP, XZ, BSIGN)
    COMMON/BESS/DBJB(20), LM(6), TD, TE, MODE, RIRA, BR, BEA, BDD
    REAL BTERM, BRTERM, ERTERM, DRTERM, BJTERM, BSIGN
    INTEGER LB(5), PP
    REAL CLIMIT

    JP = 0
    BTERM = 1.
    BRTERM = 0.
    ERTERM = 0.
    DRTERM = 0.
    BJTERM = 0.
    CLIMIT = 0.0001
    XM = 1

    LB(5) = 1
    IF(PP==0) then
        JP = 1
        GO TO 17
    else
        jp = pp
    END IF
    FACP = 1.

    DO M = 1, JP
        XM = FLOAT(M)
        BTERM = BTERM * XZ / (2. * XM)
    end do
    17    IF (BSIGN<0.) GO TO 22 !if calculating a J term (rather than I)
    !!!CALCULATION OF I TERMS (only hits this bit if doing I not J)
    LB(1) = 1
    DO M = 2, 4
        LB(M) = 0
    end do
    IF(PP/=0) BJTERM = PP * BTERM / XZ
    DBJB(JP) = BJTERM
    GO TO 5
    !!!CALCULATION OF M TERMS
    22    LB(1) = 0
    DO M = 2, 4
        LB(M) = LM(M)
    end do
    IF (PP==0) GO TO 5
    BRTERM = BTERM * PP / RIRA
    ERTERM = PP * BTERM * TE
    DRTERM = PP * BTERM * TD
    5     BSUM = BTERM
    BR = BRTERM
    BEA = ERTERM
    BDD = DRTERM
    IF(BSIGN>0) DBJB(JP) = BJTERM
    DO M = 1, 30
        BTERM = (BSIGN * BTERM * XZ * XZ) / (4. * M * (M + PP))
        IF(MODE==1) GO TO 11
        IF(LB(1)==0) GO TO 6
        !!!CALCULATION OF dM/dBd TERM [42]
        BJTERM = (2. * M + PP) * BTERM / XZ ![43]
        DBJB(JP) = DBJB(JP) + BJTERM
        IF(ABS(BJTERM / DBJB(JP))<CLIMIT) LB(1) = 0
        6     IF (LB(2)==0) GO TO 7
        !!!CALCULATION OF dM/dR TERM [45]
        BRTERM = BTERM * (2. * M + PP) / RIRA
        BR = BR + BRTERM
        IF(ABS(BRTERM / BR)<CLIMIT) LB(2) = 0
        7     IF (LB(3)==0) GO TO 8
        !!!CALCULATION OF dM/dD TERM [48]
        DRTERM = BTERM * (2. * M + PP) * TD
        BDD = BDD + DRTERM
        IF(ABS(DRTERM / BDD)<CLIMIT) LB(3) = 0
        8     IF (LB(4)==0) GO TO 11
        !!!CALCULATION OF dM/dE TERM [50]
        ERTERM = BTERM * (2. * M + PP) * TE
        BEA = BEA + ERTERM
        IF(ABS(ERTERM / BEA)<CLIMIT) LB(4) = 0
        11    IF (LB(5)==0) GO TO 12
        !!!CALCULATION OF BESSEL SUMMATION
        BSUM = BSUM + BTERM
        IF (ABS(BTERM / BSUM)<CLIMIT) LB(5) = 0
        12    LSUM = LB(1) + LB(2) + LB(3) + LB(4) + LB(5)
        IF (MODE==1) LSUM = LB(5)
        IF (LSUM==0) GO TO 3
    end do
    3     RETURN
END