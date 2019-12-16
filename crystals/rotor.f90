SUBROUTINE XROTOR (NORD, M5ARI, M2T, RHOSQ, AT, BT) !, DSIZE, DDECLINA, DAZIMUTH)
    use xconst_mod, only : twopi
    use xlst01_mod
    COMMON/BESS/DBJB(20), DBIB, LM(6), TD, TE, MODE, RIRA
    COMMON/ROTOR/ ACAL, BCAL, KSEL(100)
    INCLUDE 'ISTORE.INC'
    INTEGER NORD, QW, NK, PNA, INV1, NAA, NAD
    REAL REFLH, REFLK, REFLL, HT
    REAL Q1, Q2, Q3, Q4, Q5, Q6
    REAL XC, YC, ZC, GP, BD, CC, DD
    REAL XETA, ANGLE, ANGLEDD, ANGLEED, ANGLEE, ANGLED, TCOM, BIO
    REAL DA(180), DB(180), BIA(20)
    REAL BDTERM, RTERM, DTERM, ETERM, GTERM, MTERM !, LTERM
    REAL AP, CD, SD, CE, SE, CW, TE, TD, CU, SU
    REAL XK1, XK2, XK3
    REAL DELCE, DELDE, DELDD, DELAPD, DELAPE, DXETA, DXETAD, DXETAE, XXI
    REAL DMD, DME, AT, BT, SUM(6)
    DOUBLE PRECISION CLIMIT
    REAL DELMC(2, 6), DELMS(2, 6), DELC(2, 3), DELS(2, 3)

    INCLUDE 'STORE.INC'
    INCLUDE 'QSTORE.INC'
    !todo: are these all of the correct type?

    !todo: I've just initiated these arbitrarily
    INV1 = 0.
    NAD = 0.
    BR = 0.
    BDD = 0.
    BEA = 0.
    MODE = 1
    LM(6) = 1
    REFLH = STORE(M2T) / TWOPI      ! Wasteful, but required.
    REFLK = STORE(M2T + 1) / TWOPI
    REFLL = STORE(M2T + 2) / TWOPI
    HT = STORE(M2T + 3) / TWOPI
    RIRA = STORE(M5ARI + 8)
    CLIMIT = 0.001
    !GET XC, YC, ZC
    XC = STORE(M5ARI + 4)
    YC = STORE(M5ARI + 5)
    ZC = STORE(M5ARI + 6)
    !GET OCCUPANCY
    GP = STORE(M5ARI + 2)
    !TEMPERATURE FACTOR
    !    BB = STORE(M5ARI + 7) (never used)
    BD = STORE(M5ARI + 12)
    !POLAR ANGLES IN UNITS OF 100 DEGREES
    ANGLEDD = STORE(M5ARI + 9)
    ANGLEED = STORE(M5ARI + 10)
    XXID = STORE(M5ARI + 11) !angle xi in 100 degrees
    !TRANSFORM TO RADIANS
    ANGLED = ANGLEDD * TWOPI / 3.6
    ANGLEE = ANGLEED * TWOPI / 3.6
    XXI = XXID * TWOPI / 3.6
    !GET THE MATRIC ELEMENTS (Q1-Q6)
    Q1 = STORE(L1O2 + 0)
    Q2 = STORE(L1O2 + 1)
    Q3 = STORE(L1O2 + 2)
    Q4 = STORE(L1O2 + 4)
    Q5 = STORE(L1O2 + 5)
    Q6 = STORE(L1O2 + 8)
    !SET I0 (BIO)
    !    call BESSELI(BSUM, 0, BD)
    call BESSEL(BSUM, 0, BD, 1.0)
    BIO = bsum
    !SET Ip FROM 1 TO 20 (BIA)
    DO JP = 1, 20
        !        call BESSELI(BSUM, JP, BD)
        call BESSEL(BSUM, JP, BD, 1.0)
        BIA(JP) = bsum
    END DO
    TE = 0.
    TD = 0.
    QW = 0.
    NK = MOD(NORD, 2) + 1 !ORDER OF RING EVEN, NK=1. ORDER ODD, NK=2
    CD = COS(ANGLED)
    SD = SIN(ANGLED)
    CE = COS(ANGLEE)
    SE = SIN(ANGLEE)
    !    TF = EXP(-BB * RHOSQ) * GP * ICENT * NSTEP !(TF is already accounted for in CRYSTALS)
    !    IF (NAD==2) TF = TF * 2 !todo: don't know what NAD is/for
    DO IWA = 1, 2 !do two loops
        DO IW = 1, 6 !do 6 loops
            DELMC(IWA, IW) = 0
            DELMS(IWA, IW) = 0.0
            IF (IW>3) GO TO 10
            DELC(IWA, IW) = 0.
            DELS(IWA, IW) = 0.
            10    CONTINUE
        end do
    end do
    CODE = 0

    ICODE = 0
    !calculate c(CC) and d(DD) and then a'
    XK1 = REFLH * Q1 + REFLK * Q2 + REFLL * Q3
    XK2 = REFLL * Q6
    XK3 = REFLK * Q4 + REFLL * Q5
    ! When angles are zero, CC = 2piR * xk1
    !                       DD = 0
    CC = TWOPI * RIRA * (XK1 * CD * CE + XK3 * CD * SE - XK2 * SD)
    DD = TWOPI * RIRA * (-XK1 * SE + XK3 * CE)
    AP = SQRT(CC**2 + DD**2)
    XETA = ACOS(CC / AP)
    IF (DD<0.0) XETA = -XETA
    ANGLE = NORD * (XXI - XETA) !THIS IS THE ANGLE n(xi - nu)
    IF (MODE==1) GO TO 2
    !    IF (KSEL(L + 7)==0.AND.KSEL(L + 8)==0) GO TO 2 !todo: KSEL?
    !calculate some derivative bits (AS WLH DOES)
    DELCE = TWOPI * RIRA * (-XK1 * CD * SE + XK3 * CD * CE) ![51]
    DELDE = TWOPI * RIRA * (-XK1 * CD * SE + XK3 * CD * CE) ![51]
    DELDD = -TWOPI * RIRA * (XK1 * SD * CE + XK2 * CD + XK3 * SD * SE) ![49]
    DELAPD = DD * DELDD / AP ![49]
    DELAPE = (CC * DELCE + DD * DELDE) / AP !todo: I can't find this in WLH
    TE = DELAPE / AP
    TD = DELAPD / AP
    !WLH then does this stuff (WHICH WILL CAUSE /0 ERRORS IF D OR E ARE 0/90/180/270 DEGREES)
    CW = AP * AP * SQRT(1. - CC * CC / (AP * AP)) !see [49]
    IF (ABS(CW)>0.00001) GO TO 1 !TO AVOID /0 ERROR?
    DXETA = 1. / CW !see [49]
    DXETAE = -DXETA * (AP * DELCE - CC * DELAPE) !todo: name suggests what it is but it doesn't seem to be in WLH?
    DXETAD = DXETA * CC * DELAPD !-[49] !todo:missing - ?
    GO TO 2
    1     ICODE = 1
    2     IF (NK==2) GO TO 3
    !!!CALCULATION OF REAL TERMS
    15    NPRIME = NK * NORD / 2 !so n'=n if n odd; n'=n/2 if n even
    NAA = 1
    !    GO TO 21 !sets LM(1-5)=KSEL(IA+L+4) and LM(6)=0 then comes straight back if NAA=1 (which it will be)
    22    E = SNGL(AP) !converts a' to real type for use in bessel
    !    CALL BESSELJ(BJ, QW, E)
    CALL BESSEL(BJ, QW, E, -1.0)
    write(1975, *) "bessel J", QW, E, BJ
    write(5678, *) "DBIB=", DBIB, "BD=", BD
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
    !    21    DO IA = 1, 5
    !!        LM(IA) = KSEL(IA + L + 4)
    !    end do
    LM(6) = 1
    IF(NAA==1) GO TO 22
    5     PSIGN = 1.
    IF (ICODE==0) GO TO 16 !i.e. if there isn't a divide by 0 error, go to 16 and skip setting these to 0
    SUM(3) = 0. !instead of BDD
    SUM(4) = 0. !instead of BEA
    LM(3) = 0 !instead of KSEL(3+L+4) (i think)
    LM(4) = 0 !instead of KSEL(4+L+4) (i think)
    16    DO IA = 1, NPRIME !n'=n if n odd; n'=n/2 if n even
        PSIGN = PSIGN * (-1)
    end do
    SIGN = PSIGN !sets SIGN based on value of n
    IF (NK==2) PSIGN = -1. !IF N IS ODD, PSIGN= -1
    NL = 1
    IF (NAA/=NK) NL = 2
    !!!CALCULATION OF M AND DERIVATIVES
    DO JP = NL, 20, NK !I.E. DO THE DO LOOP FROM NL (WHICH IS 1 IS N IS ODD, 2 OTHERWISE) TO 20, WITH INCREMENT OF NK
        PNA = JP * NORD
        CU = COS(JP * ANGLE) !cos(pn(xi-eta))
        SU = SIN(JP * ANGLE) !sin(pn(xi-eta))
        TCOM = 2. * SIGN * BIA(JP) / BIO
        E = SNGL(AP) !E=a' CONVERTED TO A REAL NUMBER
        !        CALL BESSELJ (BJ, PNA, E)
        CALL BESSEL (BJ, PNA, E, -1.0)
        write(1975, *) "pna= ", PNA, "a'=", E, "BJ= ", BJ
        write(1975, *) "****"
        write(5678, *) "JP=", JP, "DBJB=", DBJB(JP), "BD=", BD
        IF (MODE==1) GO TO 34 !i.e. skip a load of derivation bits
        IF (LM(1)==0) GO TO 30
        !!!CALCULATION OF dM/d(Bd) [42]
        BDTERM = 2. * SIGN * CU * DBJB(JP) * BJ
        SUM(1) = SUM(1) + BDTERM
        IF (ABS(BDTERM / SUM(1))<CLIMIT) LM(1) = 0
        30      IF(LM(2)==0) GO TO 31
        !!!CALCULATION OF dM/dR [45] todo: DSIZE
        RTERM = TCOM * BR * CU
        SUM(2) = SUM(2) + RTERM
        IF (ABS(RTERM / SUM(2))<CLIMIT) LM(2) = 0
        31      IF (LM(3)==0) GO TO 32
        !!!CALCULATION OF DELMD (I ASSUME THIS IS dM/dD [48]?) todo: this is DDECLINA
        DMD = SU * PNA * DXETAD
        DTERM = TCOM * (BDD * CU + BJ * DMD)
        SUM(3) = SUM(3) + DTERM
        IF (ABS(DTERM / SUM(3))<CLIMIT) LM(3) = 0
        32      IF(LM(4)==0) GO TO 33
        !!!CALCULATION OF dM/dE [50] todo: this is DAZIMUTH
        DME = SU * PNA * DXETAE
        ETERM = TCOM * (BEA * CU + BJ * DME)
        SUM(4) = SUM(4) + ETERM
        IF (ABS(ETERM / SUM(4))<CLIMIT) LM(4) = 0
        33      IF (LM(5)==0) GO TO 34
        !!!CALCULATION OF dM/dG [47]
        GTERM = -PNA * TCOM * SU * BJ
        SUM(5) = SUM(5) + GTERM
        IF (ABS(GTERM / SUM(5))<CLIMIT) LM(5) = 0
        !        34 GO TO 35
        34      IF(LM(6)==0) GO TO 35
        !!!CALCULATION OF M [33]
        MTERM = TCOM * CU * BJ
        SUM(6) = SUM(6) + MTERM
        IF(ABS(MTERM / SUM(6))<CLIMIT) LM(5) = 0
        35      LSUM = LM(1) + LM(2) + LM(3) + LM(4) + LM(5) + LM(6)
        IF (MODE==1) LSUM = LM(6)
        IF (LSUM==0) GO TO 12 !jump out of loop if contribution to all parts is really small (and their
        !markers (LM(I)) have been set to zero)
        SIGN = SIGN * PSIGN
    end do
    12    IF (MODE==1) GO TO 7
    SUM(1) = (SUM(1) - SUM(6) * DBIB) / BIO
    DO IA = 1, 5
        DELMC(NAA, IA) = SUM(IA) + DELMS(NAA, IA)
        DELMS(NAA, IA) = SUM(IA) + DELMS(NAA, IA)
    end do
    DELC(NAA, 1) = DELC(NAA, 1) + SUM(6) * REFLH
    DELC(NAA, 2) = DELC(NAA, 2) + SUM(6) * REFLK
    DELC(NAA, 3) = DELC(NAA, 3) + SUM(6) * REFLL
    DELS(NAA, 1) = DELS(NAA, 1) + SUM(6) * REFLH
    DELS(NAA, 2) = DELS(NAA, 2) + SUM(6) * REFLK
    DELS(NAA, 3) = DELS(NAA, 3) + SUM(6) * REFLL
    7     DELMC(NAA, 6) = SUM(6) + DELMC(NAA, 6)
    IF(NAA==2) GO TO 15

    AT = DELMC(1, 6) - DELMS(2, 6)
    IF (NAD==2) GO TO 40
    BT = DELMC(2, 6) + DELMS(1, 6)

    WRITE(12345, *) "AROTOR= ", AT
    WRITE(12345, *) "BROTOR= ", BT
    write(12345, *) "***********************"

    !    end do

    40    IF(MODE==1) GO TO 9
    !!!DERIVATIVES WRT CENTRE OF RING [40]
    DO IA = 1, 3 !I.E. GO THROUGH THE DO LOOP THREE TIMES
        !        IF(KSEL(L)==0) GO TO 55
        !        DA(K) = -TWOPI * (DELS(1, IA) + DELC(2, IA)) todo: taken out this line
        K = K + 1
        !        55      L = L + 1
    end do
    !!!CALCULATION OF DELF(TEMP) [41]
    DA(K) = -RHOSQ * (DELMC(1, 6) - DELMS(2, 6))
    IF(INV1==1) GO TO 54
    DB(K) = -RHOSQ * (DELMC(2, 6) - DELMS(2, 6))
    54    K = K + 1
    !    53    L = L + 1
    !!!CALCULATION OF DELFD TO DFLF3 todo: don't know what this is
    DO IA = 1, 5
        !        IF(KSEL(L)==0) GO TO 51
        DA(K) = DELMC(1, IA) - DELMS(2, IA)
        IF(INV1==1) GO TO 52
        DB(K) = DELMC(2, IA) + DELMS(1, IA)
        52      K = K + 1
        !        51      L = L + 1
    end do
    9     RETURN
END

SUBROUTINE BESSEL(BSUM, PP, XZ, BSIGN) !BSUM IS THE OUTPUT, PP IS P IN THE SUM. NOT SURE ABOUT THE OTHER TWO
    COMMON/BESS/DBJB(20), DBIB, LM(5), TD, TE, MODE, RIRA
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
        LB(M) = 0  !!this bit is setting all the markers to 0
    end do
    IF(PP/=0) BJTERM = PP * BTERM / XZ
    !    DBJB(JPA) = BJTERM
    DBJB(JP) = BJTERM
    GO TO 5
    !!!CALCULATION OF M TERMS
    22    LB(1) = 0
    DO M = 2, 4
        LB(M) = LM(M) !set the LB markers to same values as LM markers (don't calculate derivatives that are too small)
    end do
    IF (PP==0) GO TO 5
    BRTERM = BTERM * PP / RIRA
    ERTERM = PP * BTERM * TE !todo: TF or TE here
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
        !        DBJB(JPA) = DBJB(JPA) + BJTERM
        DBJB(JP) = DBJB(JP) + BJTERM
        !        IF(ABS(BJTERM / DBJB(JPA))<CLIMIT) LB(1) = 0
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