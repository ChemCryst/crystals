C $Log: not supported by cvs2svn $
C Revision 1.31  2002/02/27 19:30:18  ckp2
C RIC: Increase lengths of lots of strings to 256 chars to allow much longer paths.
C RIC: Ensure consistent use of backslash after CRYSDIR:
C
C Revision 1.30  2001/11/23 08:58:08  Administrator
C Patches to facilitate link to SQUEEZE
C
C Revision 1.29  2001/10/10 16:03:57  Administrator
C Add FVAR line to PLATON output to satisfy ORTEP-3 users
C
C Revision 1.28  2001/06/18 08:27:55  richard
C Comment out the sir input file comments (which are jumped around anyway), because
C the linux compiler doesn't like the format statements (lots of missing commas, I think).
C
C Revision 1.27  2001/04/11 15:27:15  CKP2
C Fix xsymop so that .CIF entries tally
C
C Revision 1.26  2001/03/26 16:40:57  richard
C Increased possible path length from 32 to 64 chars in KLNKIO.
C
C Revision 1.25  2001/02/06 15:35:05  CKP2
C Atom-only output in PCH
C
C Revision 1.24  2001/01/12 15:09:59  CKP2
C enable CAMERON to use old lists
C
C Revision 1.23  2001/01/11 15:56:43  CKP2
C Enable CAMERON to use old files
C
C Revision 1.22  2000/11/01 09:19:05  ckp2
C RIC: Changes to compile with DVF6.5
C
C Revision 1.21  2000/10/05 10:17:17  CKP2
C  Fix SHELX output
C
C Revision 1.20  2000/09/20 12:27:33  ckp2
C FOREIGN New options for SIR92, and a PLATON directive.
C
C Revision 1.19  1999/10/07 14:34:53  ckp2
C djw MORE sir97 bits!
C
C Revision 1.18  1999/10/06 14:30:59  ckp2
C djw pdates to SIR97 difficult jobs
C
C Revision 1.17  1999/10/01 12:30:49  ckp2
C djw  patch to fix 'difficult' SIR92 files
C
C Revision 1.16  1999/09/16 17:00:31  ckp2
C djw Add nonstandard comments to .ini files, and SIR97
C
C Revision 1.15  1999/08/23 13:24:48  dosuser
C djw  Increase permitted number of atom types to 16 for SIR92
C
C Revision 1.14  1999/07/16 16:42:35  dosuser
C djw       restore SHEXS reflection scaling.
C
C Revision 1.13  1999/06/06 19:34:45  dosuser
C RIC: Added call to GUWAIT() after commands for creation of a Cameron
C chartdoc are sent to the interface. This blocks until the GUI has
C processed the pending commands.
C
C Revision 1.12  1999/06/03 17:25:58  dosuser
C RIC: Added linux graphical interface support (GIL)
C
C Revision 1.11  1999/05/25 19:10:04  dosuser
C RIC: Added write to CAMERON.INI for linux version.
C TITLE changed to KTITL. Only used in write statements.
C
C Revision 1.10  1999/04/09 10:37:13  dosuser
C djw apr99 change format statement for sigma in SIR92
C
C Revision 1.9  1999/03/29 13:26:02  dosuser
C djw mar99 XSQRT and XSQRR  used
C
C Revision 1.8  1999/03/24 17:51:33  dosuser
C open/append changes
C
C Revision 1.7  1999/02/23 19:51:09  dosuser
C RIC: Changed the Cameron linkage. Allow scripts to be used in Cameron.
C      Simply: Cameron gets input from KRDREC, which allows SCRIPTS
C      to be used. Also #USE, $ and other system commands.
C
C Revision 1.6  1999/02/16 11:14:05  dosuser
C RIC: Commented out 'END' checking for GID version when running Cameron
C

CODE FOR XLNKFP
      SUBROUTINE XLNKFP
C
C -- THIS SUBROUTINE IMPLEMENTS THE CRYSTALS INSTRUCTION 'FOREIGN'. A
C    DIRECTIVE GIVEN TO THIS INSTRUCTION DISPATCHES CONTROL TO THE
C    APPROPRIATE LINK ROUTINE TO THE PROGRAM.
C
C
C
\ISTORE
C
\STORE
\XOPVAL
\XUNITS
\XIOBUF
C
\QSTORE
C
      DATA ICOMSZ / 3 /
C
C----- ALLOCATE ROOM FOR INPUT VALUES
CMAR98
      ICOMBF = KSTALL( ICOMSZ)
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
C
      ISTAT = KRDDPV( ISTORE(ICOMBF), ICOMSZ)
      IF ( ISTAT .LT. 0 ) GO TO 9910
      ITYPE = ISTORE(ICOMBF + 1)
      IMETH = ISTORE(ICOMBF + 2)
C
C-     LINKS ARE  1:SNOOPI, 2:CAMERON, 3:SHELXS86, 4:MULTAN81
C-                5:SIR88, 6:SIR92, 7:SIR97, 8:PLATON
      CALL XLNK (ISTORE(ICOMBF), ITYPE, IMETH)
C
C
9000  CONTINUE
C
      RETURN
C
C
9900  CONTINUE
      CALL XOPMSG ( IOPFPL , IOPABN , 0 )
      GO TO 9000
9910  CONTINUE
      CALL XOPMSG ( IOPFPL , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XOPMSG ( IOPFPL , IOPINT , 0 )
      GO TO 9900
      END
C
CODE FOR XLNK
      SUBROUTINE XLNK (ILINK, IEFORT, IMETHD)
C
C      PREPARE DATA FOR FOREIGN PROGRAMS
C      ILINK  SELECTS THE SORT OF OUTPUT TO PRODUCE
C-     ILINKS ARE  1:SNOOPI, 2:CAMERON, 3:SHELXS86, 4:MULTAN81
C-                 5:SIR88,  6:SIR92,   7:SIR97,    8:PLATON
C      IEFORT SELECTS POWER SETTING OF FOREIGN CALL
C           FOR SHELXS86     IEFORT = 1, NORMAL
C                                     2, DIFFICULT
C                                     3, SPECIAL - PUNCH ATOMS
C                                     4, PATTERSON
C
C           FOR SIR**        IEFORT = 1, NORMAL
C                                     2, DIFFICULT
c           for cameron      iefort = 1, normal
c                                     2, dont create new cameron files
C
C      IMETHD SELECTS SOME SORT OF ALTERNATIVE METHOD FOR THE
C      FOREIGN CALL.
C           FOR SIR92 (only)  IMETHD = 0, NORMAL
C                             IMETHD = 1, FILTERED (check refl with L28)
C
      PARAMETER (NLINK=8, NLIST=7)
C---- FOR EACH TYPE OF LINK, INDICATE WHICH LISTS MUST BE LOADED
      DIMENSION LISTS(NLIST, NLINK)
C
C----- FOR SHELXS86
      CHARACTER *32 OPERAT
      CHARACTER *32 DECML
C
C----- FOR SIR**
cdjw aug99
      CHARACTER *1 CARROW
      CHARACTER *160 CSOURC, CSPACE, CL29, CRESLT, CHARTC
C
      REAL MAT(3)
C
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XCOMPD
\XCONST
\XLST01
\XLST02
\XLST03
\XLST05
\XLST06
\XLST13
\XLST29
\XOPVAL
\XERVAL
\XIOBUF
\XCARDS
\CAMBLK
C
\QSTORE
C
C- ILINKS ARE  1:SNOOPI, 2:CAMERON, 3:SHELXS86, 4:MULTAN81
C-             5:SIR88,  6:SIR92,   7:SIR97,    8:PLATON
C- POINTER TO LIST
      DATA LISTS /1, 2, 5, 0, 0,  0,  0,
     2            1, 2, 5, 0, 0,  0,  0,
     3            1, 2, 3, 0, 6, 13, 29,
     4            1, 2, 3, 0, 6, 13, 29,
     5            1, 2, 3, 0, 6, 13, 29,
     6            1, 2, 3, 0, 6, 13, 29,
     7            1, 2, 3, 0, 6, 13, 29,
     8            1, 2, 3, 5, 6, 13, 29/
C
C
      IF ((ILINK .LE. 0) .OR. (ILINK .GT. NLINK)) GOTO 9100
      IF ((ILINK .EQ. 1) .OR. (ILINK .EQ. 2)) THEN
C -- CHECK THAT OPERATION IS BEING PERFORMED IN INTERACTIVE MODE
C      FOR GRAPHICS LINKS
        IF ( IQUN .NE. JQUN ) GOTO 9200
      END IF
C
C--FIND OUT IF LISTS EXIST
      IERROR = 1
      DO 1300 N=1 , NLIST
        LSTNUM = LISTS(N,ILINK)
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
        IF (LSTNUM .EQ. 1 ) THEN
            CALL XFAL01
C --        CONVERT ANGLES TO DEGREES.
            STORE(L1P1+3) = RTD * STORE(L1P1+3)
            STORE(L1P1+4) = RTD * STORE(L1P1+4)
            STORE(L1P1+5) = RTD * STORE(L1P1+5)
        ELSE IF (LSTNUM .EQ. 2) THEN
            CALL XFAL02
        ELSE IF (LSTNUM .EQ. 3) THEN
            CALL XFAL03
        ELSE IF (LSTNUM .EQ. 5) THEN
            CALL XFAL05
        ELSE IF (LSTNUM .EQ. 6) THEN
            CALL XFAL06(0)
        ELSE IF (LSTNUM .EQ. 13) THEN
            CALL XFAL13
        ELSE IF (LSTNUM .EQ. 29) THEN
            CALL XFAL29
        ENDIF
1300  CONTINUE
      IF ( IERROR .LE. 0 ) GOTO 9900
C
1400  CONTINUE
C----- OPEN THE OUTPUT DEVICES
&PPC      CALL stuser
      IF (KLNKIO (ILINK) .LE. 0 ) GOTO 9900
&PPC      CALL stcrys
C
C
C     SNOOPI, CAMERON, SHELXS86, MULTAN, SIR88, SIR92, SIR97, PLATON
      GOTO (1600, 1700, 1800, 2000, 1900, 1900, 1900, 1860), ILINK
C
1600  CONTINUE
C
C----- SNOOPI ------------------------------------------------
C
      WRITE (NCFPU1, '( ''$DATA'')')
      WRITE ( NCFPU1 ,' (''CELL  '' , 3(F8.4,2X), 3(F8.3,2X ))' )
     1 ( STORE(J) , J = L1P1 , L1P1+5 )
     2
C--WRITE THE PARAMETER FILE TYPE
        WRITE ( NCFPU1 ,  '(''LIST5'')' )
&PPC      WRITE ( NCFPU1 ,  '(''CRUSE:SNOOPI.L5'')' )
&VAX      WRITE ( NCFPU1 ,  '(''USER:SNOOPI.L5'')' )
&DOS      WRITE ( NCFPU1 ,  '(''SNOOPI.L5'')' )
&H-P      WRITE ( NCFPU1 ,  '(''SNOOPI.L5'')' )
&CYB      WRITE ( NCFPU1 ,  '(''SNOOPI.L5'')' )
      WRITE ( NCFPU1 ,' ( ''$SYMM'' )' )
      DO 16190 IND1=L2P,M2P,3
        DO 16180 IND2=L2,M2,MD2
C--COMBINE T(I) & P(K) VECTORS
          MAT(1)=STORE(IND2+9)+STORE(IND1)
          MAT(2)=STORE(IND2+10)+STORE(IND1+1)
          MAT(3)=STORE(IND2+11)+STORE(IND1+2)
          DO 16101 N = 1 , 3
             MAT(N) = MAT(N) - INT(MAT(N))
16101      CONTINUE
C--DO NOT PRINT UNIT MATRIX. SNOOPI HAS THIS MATRIX BY DEFAULT
          IF (STORE(IND2) .NE. 1.0 ) GOTO 16105
          IF (STORE(IND2+4) .NE. 1.0 ) GOTO 16105
          IF (STORE(IND2+8) .NE. 1.0 ) GOTO 16105
          IF ( ( MAT(1) + MAT(2) + MAT(3) )  .NE.  0.0 ) GOTO 16105
          GO TO 16180
16105     CONTINUE
          WRITE ( NCFPU1 , '( ''MAT'' )')
          IND4=0
          DO 16170 IND3=IND2,IND2+6,3
            IND4=IND4+1
            WRITE (NCFPU1,16110) STORE(IND3),STORE(IND3+1),
     1                          STORE(IND3+2),MAT(IND4)
16110        FORMAT (10X,F7.3,2X,F7.3,2X,F7.3,2X,F7.3)
16170      CONTINUE
16180   CONTINUE
16190 CONTINUE
C--FIND OUT IF THE STRUCTURE IS CENTRIC
      IF ( STORE(L2C) .LT. 0.5 ) WRITE ( NCFPU1 , '(''NOCEN'')' )
      WRITE ( NCFPU1 , '(''$'')' )
C
C----- WRITE LIST 5 TO A SEPARATE UNIT
C--SAVE THE PUNCH UNIT
        NSAV = NCPU
        NCPU = NCFPU2
        CALL XPCH5S(1)
C--SWAP THE UNITS BACK
        NCPU = NSAV
      GOTO 8000
C
1700  CONTINUE
C************* THIS IS ONLY A PATCH ***********************************
C----- LINK TO CAMERON -------------------------------------
C
cdjwjan2000
          CALL XPRVDU(NCEROR, 1,0)
      if (iefort .ne. 1) goto 8000
C
      WRITE (NCFPU1, '( ''$DATA'')')
      WRITE ( NCFPU1 ,' (''CELL  '' , 3(F8.4,2X), 3(F8.3,2X ))' )
     1 ( STORE(J) , J = L1P1 , L1P1+5 )
     2
C--WRITE THE PARAMETER FILE TYPE
        WRITE ( NCFPU1 ,  '(''LIST5'')' )
&PPC      WRITE ( NCFPU1 ,  '(''CRUSE:CAMERON.L5I'')' )
&VAX      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
&DOS      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
&DVF      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
&LIN      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
&GIL      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
&GID      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
&H-P      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
&CYB      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
      WRITE ( NCFPU1 ,' ( ''$SYMM'' )' )
      DO 26190 IND1=L2P,M2P,3
        DO 26180 IND2=L2,M2,MD2
C--COMBINE T(I) & P(K) VECTORS
          MAT(1)=STORE(IND2+9)+STORE(IND1)
          MAT(2)=STORE(IND2+10)+STORE(IND1+1)
          MAT(3)=STORE(IND2+11)+STORE(IND1+2)
          DO 26101 N = 1 , 3
             MAT(N) = MAT(N) - INT(MAT(N))
26101      CONTINUE
C--DO NOT PRINT UNIT MATRIX. SNOOPI HAS THIS MATRIX BY DEFAULT
          IF (STORE(IND2) .NE. 1.0 ) GOTO 26105
          IF (STORE(IND2+4) .NE. 1.0 ) GOTO 26105
          IF (STORE(IND2+8) .NE. 1.0 ) GOTO 26105
          IF ( ( MAT(1) + MAT(2) + MAT(3) )  .NE.  0.0 ) GOTO 26105
          GO TO 26180
26105     CONTINUE
          WRITE ( NCFPU1 , '( ''MAT'' )')
          IND4=0
          DO 26170 IND3=IND2,IND2+6,3
            IND4=IND4+1
            WRITE (NCFPU1,26110) STORE(IND3),STORE(IND3+1),
     1                          STORE(IND3+2),MAT(IND4)
26110        FORMAT (10X,F7.3,2X,F7.3,2X,F7.3,2X,F7.3)
26170      CONTINUE
26180   CONTINUE
26190 CONTINUE
C--FIND OUT IF THE STRUCTURE IS CENTRIC
      IF ( STORE(L2C) .LT. 0.5 ) WRITE ( NCFPU1 , '(''NOCEN'')' )
      WRITE ( NCFPU1 , '(''$'')' )
C
C----- WRITE LIST 5 TO A SEPARATE UNIT
C--SAVE THE PUNCH UNIT
        NSAV = NCPU
        NCPU = NCFPU2
        CALL XPCH5S(1)
C--SWAP THE UNITS BACK
        NCPU = NSAV
      GOTO 8000
C
C**********************************************************
C*******      GOTO 9000
C
1800  CONTINUE
C     LINK TO WRITE OUTPUT FOR SHELXS86 ---------------------
C
C      IEFORT = 1, NORMAL
C               2, DIFFICULT
C               3, SPECIAL - WRITE ATOMS
C               4, PATTERSON
C
C----- OUTPUT A TITLE, FIRST 40 CHARACTERS ONLY
      WRITE(NCFPU1,'(''TITL '',10A4)') (KTITL(I),I=1,10)
      WRITE(NCFPU1, '(''CELL '', F8.5, 3F7.3, 3F8.3)')
     1 STORE(L13DC), (STORE(I),I=L1P1,L1P1+5)
C----- FIND LATTICE TYPE
      LATTYP = ((2*IC) -1) * IL
      WRITE (NCFPU1,'( ''LATT '', I3)') LATTYP
      DO 1820 I = L2,M2,MD2
            CALL XSUMOP( STORE(I), STORE(L2P), OPERAT, LENGTH,0)
C--DO NOT PRINT UNIT MATRIX.
            IF ( OPERAT(1:LENGTH) .EQ. 'X,Y,Z') GOTO 1820
            CALL XCONOP (OPERAT, LENGTH, DECML, LDEC)
            WRITE(NCFPU1,'(''SYMM  '', A)') DECML(1:LDEC)
1820   CONTINUE
C---- GET MULTIPLICITY
      F = T2
      IF ( N29 .LE. 0 ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1830 )
        WRITE ( NCAWU , 1830 )
        WRITE ( CMON, 1830 )
        CALL XPRVDU(NCVDU, 1,0)
1830    FORMAT ( 1X , 'No atom details stored in list 29' )
        GOTO 9900
      ELSE
C----- WRITE SFAC CARDS
        M29 = L29 + (N29-1)*MD29
        M3 = L3 + (N3-1)*MD3
        DO 1839 J = L29, M29, MD29
          DO 1832 K = L3, M3, MD3
           IF (ISTORE(J) .EQ. ISTORE(K)) GOTO 1838
1832      CONTINUE
        IF (ISSPRT .EQ. 0) WRITE(NCAWU,1833) ISTORE(J)
        WRITE(NCAWU,1833) ISTORE(J)
        WRITE ( CMON, 1833) ISTORE(J)
        CALL XPRVDU(NCVDU, 1,0)
1833    FORMAT (' No formfactors stored for ', A4)
        GOTO 9900
1838    CONTINUE
        WRITE ( NCFPU1 , 1837 ) ISTORE(J), (STORE(M), M=K+3, K+11),
     1  STORE(K+1), STORE(K+2), STORE(J+5), STORE(J+1), STORE(J+6)
1837    FORMAT ('SFAC ' , A4, 7F9.4,' = '/, 9X,4F9.4,F9.2,2F9.4 )
1839    CONTINUE
C----- UNIT CARDS
        WRITE (NCFPU1, ' (''UNIT '', 15F5.0)')
     1  (F*STORE(J+4), J = L29, M29, MD29)
      ENDIF
C
      IF (IEFORT .EQ. 3) THEN
C----- JUST WRITING ATOMS - SAVE AND RESTORE IO UNITS
        J = NCPU
        NCPU = NCFPU1
        CALL XPCH5C(1)
        NCPU = J
        GOTO 1850
      ENDIF
C----- REQUEST STRUCTURE SOLUTION
      IF (IEFORT .EQ. 4) THEN
            WRITE (NCFPU1,' (''PATT '')')
      ELSE IF (IEFORT .EQ. 2) THEN
            WRITE(NCFPU1, '(''TREF 250'', / , ''FMAP 10'')')
      ELSE
            WRITE(NCFPU1, '(''TREF '')')
      ENDIF
C----- OUTPUT ON ACTUAL SCALE
C
      WRITE(NCFPU1, '(''HKLF  -4'' )')
C----- LOOP OVER DATA
      IN = 0
1840  CONTINUE
      ISTAT = KLDRNR (IN)
      IF (ISTAT .LT. 0) GOTO 1850
      I = NINT(STORE(M6))
      J = NINT(STORE(M6+1))
      K = NINT(STORE(M6+2))
CDJWMAR99[
      CALL XSQRF(FS, STORE(M6+3), FABS, S, STORE(M6+12))
      IF ((S .LE. ZERO) .AND. (STORE(M6+20) .GT. ZERO))
     1 S = ABS(FS) / STORE(M6+20)
CDJWMAR99]
      IF (FS.LE.9999.) THEN
       WRITE(NCFPU1, '(3I4, 2F8.3)') I, J, K, FS, S
      ELSE IF (FS.LE.99999.) THEN
       WRITE(NCFPU1, '(3I4, 2F8.2)') I, J, K, FS, S
      ELSE IF (FS.LE.999999.) THEN
       WRITE(NCFPU1, '(3I4, 2F8.1)') I, J, K, FS, S
      ELSE
       WRITE(NCFPU1, '(3I4, 2F8.0)') I, J, K, FS, S
      END IF
      GOTO 1840
1850  CONTINUE
C----- END OF DATA - WRITE A BLANK LINE
      WRITE (NCFPU1,'(/)')
      GOTO 8000

1860  CONTINUE
C     LINK TO WRITE OUTPUT FOR PLATON ---------------------
C
C  NCFPU1 will be a SHELX format RES file with atoms.
C  NCFPU2 will be a SHELX HKLF-4 reflection file.
C
C----- OUTPUT A TITLE, FIRST 40 CHARACTERS ONLY
      WRITE(NCFPU1,'(''TITL '',10A4)') (KTITL(I),I=1,10)
      WRITE(NCFPU1, '(''CELL '', F8.5, 3F7.3, 3F8.3)')
     1 STORE(L13DC), (STORE(I),I=L1P1,L1P1+5)
C----- FIND LATTICE TYPE
      LATTYP = ((2*IC) -1) * IL
      WRITE (NCFPU1,'( ''LATT '', I3)') LATTYP
      DO I = L2,M2,MD2
            CALL XSUMOP( STORE(I), STORE(L2P), OPERAT, LENGTH,0)
C--DO NOT PRINT UNIT MATRIX.
            IF ( OPERAT(1:LENGTH) .NE. 'X,Y,Z') THEN
               CALL XCONOP (OPERAT, LENGTH, DECML, LDEC)
               WRITE(NCFPU1,'(''SYMM  '', A)') DECML(1:LDEC)
            END IF
      END DO
C---- GET MULTIPLICITY
      F = T2
      IF ( N29 .LE. 0 ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1830 )
        WRITE ( NCAWU , 1830 )
        WRITE ( CMON, 1830 )
        CALL XPRVDU(NCVDU, 1,0)
        GOTO 9900
      ELSE
C----- WRITE SFAC CARDS
        M29 = L29 + (N29-1)*MD29
        M3 = L3 + (N3-1)*MD3
        DO J = L29, M29, MD29
          DO K = L3, M3, MD3
           IF (ISTORE(J) .EQ. ISTORE(K)) GOTO 1861
          END DO
        IF (ISSPRT .EQ. 0) WRITE(NCAWU,1833) ISTORE(J)
        WRITE(NCAWU,1833) ISTORE(J)
        WRITE ( CMON, 1833) ISTORE(J)
        CALL XPRVDU(NCVDU, 1,0)
        GOTO 9900
1861    CONTINUE
        WRITE ( NCFPU1 , 1837 ) ISTORE(J), (STORE(M), M=K+3, K+11),
     1  STORE(K+1), STORE(K+2), STORE(J+5), STORE(J+1), STORE(J+6)
       END DO

C----- UNIT CARDS
        WRITE (NCFPU1, ' (''UNIT '', 15F5.0)')
     1  (F*STORE(J+4), J = L29, M29, MD29)
      ENDIF
C----- FVAR CARD - the SHELX scale is 1/Crystals scale
        WRITE (NCFPU1, ' (''FVAR '', F10.4)') 1./STORE(L5O)
C
C----- WRITING ATOMS - SAVE AND RESTORE IO UNITS
        J = NCPU
        NCPU = NCFPU1
        CALL XPCH5C(1)
        NCPU = J
C----- END OF DATA - WRITE A BLANK LINE
      WRITE (NCFPU1,'(/)')
C
C
C      WRITE(NCFPU1, '(''HKLF  -4'' )')

C----- LOOP OVER DATA
      IN = 0
1862  CONTINUE
      ISTAT = KLDRNR (IN)
      IF (ISTAT .LT. 0) GOTO 1863
      I = NINT(STORE(M6))
      J = NINT(STORE(M6+1))
      K = NINT(STORE(M6+2))
CDJWMAR99[
      CALL XSQRF(FS, STORE(M6+3), FABS, S, STORE(M6+12))
      IF ((S .LE. ZERO) .AND. (STORE(M6+20) .GT. ZERO))
     1 S = ABS(FS) / STORE(M6+20)
CDJWMAR99]
      IF (FS.LE.9999.) THEN
       WRITE(NCFPU2, '(3I4, 2F8.3)') I, J, K, FS, S
      ELSE IF (FS.LE.99999.) THEN
       WRITE(NCFPU2, '(3I4, 2F8.2)') I, J, K, FS, S
      ELSE IF (FS.LE.999999.) THEN
       WRITE(NCFPU2, '(3I4, 2F8.1)') I, J, K, FS, S
      ELSE
       WRITE(NCFPU2, '(3I4, 2F8.0)') I, J, K, FS, S
      END IF
      GOTO 1862
1863  CONTINUE
C----- END OF DATA - WRITE A BLANK LINE
      WRITE (NCFPU2,'(/)') 
      GOTO 8000
C
1900  CONTINUE
C---- LINK TO WRITE OUTPUT FOR SIR%% ------------------------
C
C----- GET SYMBOL AND MULTIPLICITY
C----- DISPLAY SPACE GROUP SYMBOL
      J  = L2SG + MD2SG - 1
      CSOURC = ' '
      WRITE(CSOURC, '(4(A4,1X) )') (ISTORE(I), I = L2SG, J)
      IF (ILINK .EQ. 5 ) THEN
            CRESLT = CSOURC
      ELSE
            CALL XCCLWC (CSOURC, CRESLT )
      ENDIF
      CALL XCREMS (CRESLT, CSPACE, ISP )
C
      IF (N29 .GT. 16) THEN
        WRITE(NCAWU,1910)
        IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU, 1910)
        ENDIF
        WRITE ( CMON, 1910)
        CALL XPRVDU(NCVDU, 1,0)
c1910  FORMAT ( ' Maximum of 8 atom types permitted for SIR link')
cdjwaug99
1910  FORMAT ( ' Maximum of 16 atom types permitted for SIR link')
        GOTO 9900
      END IF
      IF ( N29 .GT. 0 ) THEN
        CSOURC = ' '
        WRITE ( CSOURC , 1920 ) ( STORE(J), NINT(T2*STORE(J+4)),
     1  J = L29 , M29 , MD29 )
1920    FORMAT(16(1X, A4, I4))
      IF (ILINK .EQ. 5 ) THEN
            CRESLT = CSOURC
      ELSE
            CALL XCCLWC (CSOURC, CRESLT )
      ENDIF
        CALL XCREMS (CRESLT, CL29, I29 )
      ELSE
        IF (ISSPRT .EQ. 0) THEN
          WRITE ( NCWU , 1930 )
        ENDIF
        WRITE ( NCAWU , 1930 )
        WRITE ( CMON, 1930 )
        CALL XPRVDU(NCVDU, 1,0)
1930    FORMAT ( 1X , 'No atom details stored in list 29' )
        GOTO 9900
      ENDIF
C
      IF (ILINK .EQ. 5) THEN
C----- WRITE THIS LINE FOR GRAPHICAL RUN
        WRITE(NCFPU1, '(''%WINDOW 960 700 '')')
C----- SET UP THE FILE SPECIFICATIONS
        WRITE(NCFPU1, '(''%FILE SIRDATA.BIN  SIR.CRY '')')
C----- OUTPUT A TITLE, FIRST 20 WORDS ONLY
        WRITE(NCFPU1, '(''%INITIALISE'', /, ''%JOB '',20A4)')
     1 (KTITL(I),I=1,20)
        WRITE(NCFPU1, '(''%NORMAL '',/,''CELL '', 3F7.3, 3F8.3)')
     1 (STORE(I),I=L1P1,L1P1+5)
       WRITE(NCFPU1, '(''SPACE '', A )') CSPACE(1:ISP)
       WRITE ( NCFPU1 , '(''CONTENT '', A)' ) CL29(1:I29)
       WRITE(NCFPU1,1940)
1940  FORMAT( 'FORMAT (3I4, F10.3, I2)',/, 'REFLECTION FOLLOW')
       IF (IEFORT .EQ. 2) WRITE(NCFPU1, '(''PSEUDO'')')
       IF (IEFORT .EQ. 2) WRITE(NCFPU1, '(''%INVARIANT'',/''PTEN'')' )
       WRITE(NCFPU1, '(''%CONTINUE'')' )
      ELSE IF ((ILINK .EQ. 6) .OR. (ILINK .EQ. 7)) THEN
C
C
C SIR92, SIR97
C
C----- SET UP THE FILE SPECIFICATIONS
      WRITE(NCFPU1, '(''%Window '')')
        WRITE(NCFPU1, '(''%structure  SIR9x '')')
C----- OUTPUT A TITLE, FIRST 20 WORDS ONLY
        WRITE(NCFPU1, '(''%init'', /, ''%job '',20A4)')
     1 (KTITL(I),I=1,20)
cdjw1999------ List the commands as comments
      GOTO 19400
c       write(ncfpu1,'('
c     1'>%JOB               a caption is printed in the output '
c     2')')
c       write(ncfpu1,'('
c     1'>%STRUCTURE string  this command is used to  specify the  name'
c     2')')
c       write(ncfpu1,'('
c     1'>                   of  the  structure  to  investigate.   The '
c     2')')
c       write(ncfpu1,'('
c     1'>                   program creates  the  name  of  the  files '
c     2')')
c       write(ncfpu1,'('
c     1'>                   needed by adding the appropriate extension '
c     2')')
c       write(ncfpu1,'('
c     1'>                   to the structure name. The file names are: '
c     2')')
c       write(ncfpu1,'('
c     1'>                      string.bin -> direct access file'
c     2')')
c       write(ncfpu1,'('
c     1'>                      string.ins -> final coordinates file'
c     2')')
c       write(ncfpu1,'('
c     1'>                      string.plt -> file for graphics'
c     2')')
c       write(ncfpu1,'('
c     1'>                   If this command  is  not  used the default '
c     2')')
c       write(ncfpu1,'('
c     1'>                   string "STRUCT" (instead of the name of the'
c     2')')
c       write(ncfpu1,'('
c     1'>                   structure) is used to create file names. '
c     2')')
c       write(ncfpu1,'('
c     1'>%WINDOW [ x y ]    graphic window is required.  Optionally '
c     2')')
c       write(ncfpu1,'('
c     1'>                   it is possible  to increase the dimensions '
c     2')')
c       write(ncfpu1,'('
c     1'>                   using x and y. Default values are 720,500.'
c     2')')
c       write(ncfpu1,'('
c     1'>%NOWINDOW          graphic window is suppressed'
c     2')')
c       write(ncfpu1,'('
c     1'>%INITIALIZE        initialize the direct access file '
c     2')')
c       write(ncfpu1,'('
c     1'>                   (to override previous results and data)'
c     2')')
c       write(ncfpu1,'('
c     1'>%END               end of the input file'
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>%CONTINUE          the  program  runs  in  default conditions'
c     2')')
c       write(ncfpu1,'('
c     1'>                   from the last given command up to the end '
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>        Preparation  of  data  for  DATA   routine           '
c     2')')
c       write(ncfpu1,'('
c     1'> ----------------------------------------------------------- '
c     2')')
c       write(ncfpu1,'('
c     1'>%DATA              Data input routine'
c     2')')
c       write(ncfpu1,'('
c     1'>CELL  a  b  c  alpha  beta  gamma'
c     2')')
c       write(ncfpu1,'('
c     1'>SPACEGROUP string'
c     2')')
c       write(ncfpu1,'('
c     1'>SHIFT  sx sy sz  '
c     2')')
c       write(ncfpu1,'('
c     1'>CONTENTS  El1  n1  El2   n2   El3  n3   .........'
c     2')')
c       write(ncfpu1,'('
c     1'>RHOMAX x  '
c     2')')
c       write(ncfpu1,'('
c     1'>RECORD n'
c     2')')
c       write(ncfpu1,'('
c     1'>FORMAT string '
c     2')')
c       write(ncfpu1,'('
c     1'>GENER  '
c     2')')
c       write(ncfpu1,'('
c     1'>NOSIGMA'
c     2')')
c       write(ncfpu1,'('
c     1'>REFLECTIONS string '
c     2')')
c       write(ncfpcu1,'('
c     1'>FOSQUARE'
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>        Preparation  of  data  for  NORMAL routine            '
c     2')')
c       write(ncfpu1,'('
c     1'> ------------------------------------------------------------ '
c     2')')
c       write(ncfpu1,'('
c     1'>%NORMAL            normalization routine'
c     2')')
c       write(ncfpu1,'('
c     1'>NREF n'
c     2')')
c       write(ncfpu1,'('
c     1'>NZRO n'
c     2')')
c       write(ncfpu1,'('
c     1'>BFAC x  '
c     2')')
c       write(ncfpu1,'('
c     1'>PSEUDO n(1,1) n(2,1) n(3,1) n(4,1) n(1,2)  . . .  n(4,3)'
c     2')')
c       write(ncfpu1,'('
c     1'>PARTIAL'
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>       Preparation  of  data  for  SEMINVARIANTS  routine     '
c     2')')
c       write(ncfpu1,'('
c     1'> ------------------------------------------------------------ '
c     2')')
c       write(ncfpu1,'('
c     1'>%SEMINV            seminvariants routine'
c     2')')
c       write(ncfpu1,'('
c     1'>FIRST '
c     2')')
c       write(ncfpu1,'('
c     1'>NRS1 n '
c     2')')
c       write(ncfpu1,'('
c     1'>LIST     '
c     2')')
c       write(ncfpu1,'('
c     1'>NUMK n  '
c     2')')
c       write(ncfpu1,'('
c     1'>NRS2 n  '
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>         Preparation  of  data  for  INVARIANTS  routine    '
c     2')')
c       write(ncfpu1,'('
c     1'> -----------------------------------------------------------'
c     2')')
c       write(ncfpu1,'('
c     1'>%INVARIANTS        invariants routine'
c     2')')
c       write(ncfpu1,'('
c     1'>NRTRIPLETS n   '
c     2')')
c       write(ncfpu1,'('
c     1'>GMIN  x    '
c     2')')
c       write(ncfpu1,'('
c     1'>EMIN x   '
c     2')')
c       write(ncfpu1,'('
c     1'>NRPSIZERO n '
c     2')')
c       write(ncfpu1,'('
c     1'>EMAX x    '
c     2')')
c       write(ncfpu1,'('
c     1'>COCHRAN '
c     2')')
c       write(ncfpu1,'('
c     1'>NUMK n  '
c     2')')
c       write(ncfpu1,'('
c     1'>CORRECTION x  '
c     2')')
c       write(ncfpu1,'('
c     1'>BIG n'
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>           Preparation  of  data  for  PHASE  routine       '
c     2')')
c       write(ncfpu1,'('
c     1'> -----------------------------------------------------------'
c     2')')
c       write(ncfpu1,'('
c     1'>%PHASE             converge-tangent routine'
c     2')')
c       write(ncfpu1,'('
c     1'>LIST n     '
c     2')')
c       write(ncfpu1,'('
c     1'>TWOPHASE x   '
c     2')')
c       write(ncfpu1,'('
c     1'>ONEPHASE n     '
c     2')')
c       write(ncfpu1,'('
c     1'>ORIGIN n(i) phi(i)'
c     2')')
c       write(ncfpu1,'('
c     1'>ENANTIOMORPH n '
c     2')')
c       write(ncfpu1,'('
c     1'>SYMBOLS n   '
c     2')')
c       write(ncfpu1,'('
c     1'>PERMUTE n(i)'
c     2')')
c       write(ncfpu1,'('
c     1'>SPECIALS n     '
c     2')')
c       write(ncfpu1,'('
c     1'>PHASE n(i) phi(i) wt(i)'
c     2')')
c       write(ncfpu1,'('
c     1'>TABLE'
c     2')')
c       write(ncfpu1,'('
c     1'>TRIALS n(i) '
c     2')')
c       write(ncfpu1,'('
c     1'>MINFOM  x n  '
c     2')')
c       write(ncfpu1,'('
c     1'>RANDOM n '
c     2')')
c       write(ncfpu1,'('
c     1'>SEED n'
c     2')')
c       write(ncfpu1,'('
c     1'>NOREJECT'
c     2')')
c       write(ncfpu1,'('
c     1'>TEST'
c     2')')
c       write(ncfpu1,'('
c     1'>MAXTRIALS'
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>   Preparation  of  data  for  FOURIER/LEAST-SQUARES  routine'
c     2')')
c       write(ncfpu1,'('
c     1'> ------------------------------------------------------------'
c     2')')
c       write(ncfpu1,'('
c     1'>%FOURIER           Fourier/Least-Squares routine'
c     2')')
c       write(ncfpu1,'('
c     1'>SET n      '
c     2')')
c       write(ncfpu1,'('
c     1'>MAP '
c     2')')
c       write(ncfpu1,'('
c     1'>LEVEL n   '
c     2')')
c       write(ncfpu1,'('
c     1'>GRID x       '
c     2')')
c      write(ncfpu1,'('
c     1'>LIMITS  l1  l2  l3  '
c     2')')
c      write(ncfpu1,'('
c     1'>PEAKS n   '
c     2')')
c       write(ncfpu1,'('
c     1'>LAYX'
c     2')')
c       write(ncfpu1,'('
c     1'>LAYY'
c     2')')
c       write(ncfpu1,'('
c     1'>LAYZ'
c     2')')
c       write(ncfpu1,'('
c     1'>RADIUS El x'
c     2')')
c       write(ncfpu1,'('
c     1'>COORDINATION El  dmin  dmax  [n]'
c     2')')
c       write(ncfpu1,'('
c     1'>FOMIN x'
c     2')')
c       write(ncfpu1,'('
c     1'>SIGMA x'
c     2')')
c       write(ncfpu1,'('
c     1'>DMAX x'
c     2')')
c       write(ncfpu1,'('
c     1'>RECYCLE n'
c     2')')
c       write(ncfpu1,'('
c     1'>FRAGMENT string'
c     2')')
c       write(ncfpu1,'('
c     1'>     '
c     2')')
c       write(ncfpu1,'('
c     1'>          Preparation  of  data  for  EXPORT   routine       '
c     2')')
c       write(ncfpu1,'('
c     1'> ------------------------------------------------------------'
c     2')')
c       write(ncfpu1,'('
c     1'>%EXPORT'
c     2')')
c       write(ncfpu1,'('
c     1'>CRYSTALS string'
c     2')')
c       write(ncfpu1,'('
c     1'>COMPLETE'
c     2')')
c       write(ncfpu1,'('
c     1'>SHELX string'
c     2')')
c       write(ncfpu1,'('
c     1'>MOLDRAW string'
c     2')')
c       write(ncfpu1,'('
c     1'>SCHAKAL string'
c     2')')
c       write(ncfpu1,'('
c     1'>MOLPLOT string'
c     2')')
c       write(ncfpu1,'('
c     1'>XYZ string'
c     2')')
c       write(ncfpu1,'('
c     1'>'
c     2')')
c       write(ncfpu1,'('
c     1'>          Preparation  of  data  for  RESTART  routine       '
c     2')')
c       write(ncfpu1,'('
c     1'> ------------------------------------------------------------'
c     2')')
c       write(ncfpu1,'('
c     1'>%RESTART           Fourier/Least-Squares restart routine'
c     2')')
c       write(ncfpu1,'('
c     1'>COMPLETE'
c     2')')
c       write(ncfpu1,'('
c     1'>RELABEL string species (or RENAME string species)'
c     2')')
c       write(ncfpu1,'('
c     1'>DELETE string'
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
c       write(ncfpu1,'('
c     1'>          Preparation  of  data  for  PATTERSON routine      '
c     2')')
c       write(ncfpu1,'('
c     1'> ------------------------------------------------------------'
c     2')')
c       write(ncfpu1,'('
c      1'>%PATTERSON'
c      2')')
c       write(ncfpu1,'('
c     1'>LAYX, LAYY, LAYZ, MAP, PEAKS, LIMIT, GRID: See Fourier '
c     2')')
c      write(ncfpu1,'('
c     1'>E**2 (or E*E)'
c     2')')
c       write(ncfpu1,'('
c     1'>F**2 (or F*F)'
c     2')')
c       write(ncfpu1,'('
c     1'>E*F  (or F*E)'
c     2')')
c       write(ncfpu1,'('
c     1'>  '
c     2')')
c       write(ncfpu1,'('
c     1'> '
c     2')')
19400  CONTINUE
cdjw1999
        WRITE(NCFPU1, '(''%data '',/,8X,''cell '', 3F7.3, 3F8.3)')
     1 (STORE(I),I=L1P1,L1P1+5)
       WRITE(NCFPU1, '(8X,''space '', A )') CSPACE(1:ISP)
       WRITE ( NCFPU1 , '(8X,''content '', A)' ) CL29(1:I29)
      WRITE(NCFPU1,1945)
1945  FORMAT( 8X,'reflection follow',/,
     1 8X, 'format (3i4, f10.3, f7.2)')
1941  FORMAT('>  rhomax 0.33'/
     1 A,'%normal'/
     2 A,'  pseudo'/
     3   '>  bfac 4.'/
     4 A,'%seminv'/
     5 A,'%invariant'/
     6 A,'%phase'/
     7 A,'  random'/
     8 A,'%fourier'/
     9   '>  recycle  n')
1942  FORMAT('>  rhomax 0.33'/
     1 '%normal'/
     2 '  pseudo'/
     3 '>  bfac 4.'/
     4 '%seminv'/
     5 '%invariant'/
     6 '%phase'/
     7 '  symbols 12'/
     8 '%fourier'/
     9 '>  recycle  n')
1943  FORMAT('>  rhomax 0.33'/
     1 '%normal'/
     2 '  pseudo'/
     3 '>  bfac 4.'/
     4 '%seminv'/
     5 '%invariant'/
     6 '%phase'/
     7 '  random'/
     8 '  maxtrials 2000'/
     8 '  seed 8823'/
     8 '%fourier'/
     9 '>  recycle  n')
            CARROW = '>'
       IF (ILINK .EQ. 6) THEN
       IF (IEFORT .EQ. 1) THEN
      WRITE(NCFPU1,1941) CARROW,CARROW,CARROW,CARROW,
     1 CARROW,CARROW,CARROW
      ELSE IF (IEFORT .EQ. 2) then 
       WRITE(NCFPU1, 1941) ' ', ' ',' ',
     1 ' ',' ',' ',' '
      ELSE IF (IEFORT .EQ. 5) THEN
       WRITE(NCFPU1, 1942)
      ELSE IF (IEFORT .EQ. 6) THEN
       WRITE(NCFPU1, 1943)
      ENDIF
       ELSE IF (ILINK .EQ. 7) THEN
       WRITE(NCFPU1, 1941) ' ', CARROW,' ',
     1 ' ',' ',carrow,' '
          write(ncfpu1,'(''%menu''/''  crystals sir97.cry'')')
       endif
      WRITE(NCFPU1, '(''%continue'')' )
C
      SCALE = 1.0
C----- LOOP OVER DATA
      IN = 0
1950  CONTINUE
      ISTAT = KLDRNR (IN)
      IF (ISTAT .LT. 0) GOTO 1960
      I = NINT(STORE(M6))
      J = NINT(STORE(M6+1))
      K = NINT(STORE(M6+2))
      FS =  STORE(M6+3) * SCALE
      IF (STORE(M6+20) .LE. ZERO) THEN
      S = 0.0
      ELSE
      S = FS / STORE(M6+20)
      ENDIF
      IF (ILINK .EQ. 5) THEN
         JCODE = 0
         IF (KALLOW(IN) .LT. 0) JCODE = 1
         WRITE(NCFPU1,'( 3I4, F10.3, I2)') I, J, K, FS, JCODE
      ELSE IF ((ILINK .EQ. 6) .AND. (IMETHD .EQ. 1)) THEN
         IF (KALLOW(IN) .GE. 0) THEN
           WRITE(NCFPU1,'(3I4, F10.3, F7.2)') I, J, K, FS, S
         END IF
      ELSE
         WRITE(NCFPU1,'(3I4, F10.3, F7.2)') I, J, K, FS, S
      ENDIF
      GOTO 1950
1960  CONTINUE
        WRITE(NCFPU1,1961)
1961    FORMAT('   0   0   0   -.00001  0.0')
      IF (ILINK .EQ. 6) THEN
      write(ncfpu1,'(''%export''/8X,''crystals sir92.cry''/''%end'')')
      else
        continue
      endif
      ENDIF
      GOTO 8000
C
2000  CONTINUE
C----- LINK TO MULTAN ------------------------------------
C
      CALL XLNKMN
      GOTO 9000
C
8000  CONTINUE
C----- TIDY UP
C
C     SNOOPI, CAMERON, SHELXS86, MULTAN, SIRxx
      GOTO ( 8010, 8020, 8030, 9000, 8030, 8030, 8030, 8040), ILINK
      GOTO 9100
C
8010  CONTINUE
C----- SNOOPI - 2 FILES TO CLOSE AND START PROGRAM
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)
C -- SPAWN SNOOPI
&PPCCS***
&PPC      CALL stsnpi
&PPCCE***
      CALL XDETCH ( '$ @ CRSNOOPI:SNOOPI' )
      GOTO 9000
C
8020  CONTINUE
C----- CAMERON - 2 FILES TO CLOSE AND START PROGRAM
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)
C - Only GID, GIL and DOS support Cameron's graphics.
###GILGIDDOS        GOTO 9000 !Skip this Cameron part.

C -- START CAMERON - ONLY TWO ELEMENT OF STORE (CURRENTLY A DUMMY) USED
C      IF (ISSTML .EQ. 4) THEN
        LCLOSE = .FALSE.
C - Only GID needs funny text strings to initialise the graphics.
C - Could move these to ZCAMER.

&&GIDGIL        WRITE(CHARTC,'(A)') '^^CH CHART _CAMERONCHART'
&&GIDGIL        CALL ZMORE(CHARTC,0)
&&GIDGIL        WRITE(CHARTC,'(A)') '^^CH ATTACH _CAMERONVIEW'
&&GIDGIL        CALL ZMORE(CHARTC,0)
&&GIDGIL        WRITE(CHARTC,'(A)') '^^CR'
&&GIDGIL        CALL ZMORE(CHARTC,0)
&&GIDGIL        CALL GUWAIT()
&&&GIDDOSGIL        CALL ZCAMER ( 1, 0 , 0 , 0)

8025  CONTINUE
        IF (LCLOSE) THEN
            GOTO 9000 !Cameron has shutdown
        ENDIF
        IIIIIN = 1
        ISTAT = KRDREC(IIIIIN)
        WRITE(CHRBUF,'(256A1)')LCMAGE
&&&GIDDOSGIL         CALL ZCONTR
      GOTO 8025

8030  CONTINUE
C----- ENSURE THE UNITS ARE CLOSED
      I = KFLCLS(NCFPU1)
      GOTO 9000

8040  CONTINUE
C----- ENSURE THE UNITS ARE CLOSED
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)
      GOTO 9000
C
9000  CONTINUE
      RETURN
9100  CONTINUE
      WRITE ( CMON, 9150 ) ILINK
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) THEN
            WRITE ( NCWU , 9150 ) ILINK
      ENDIF
      WRITE ( NCAWU , 9150 ) ILINK
9150  FORMAT ( 1X , 'Function ', I4, ' not available' )
      GO TO 9900
C
9200  CONTINUE
      WRITE ( CMON, 9250 )
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) THEN
            WRITE ( NCWU , 9250 )
      ENDIF
      WRITE ( NCAWU , 9250 )
9250  FORMAT ( 1X , 'GRAPHICS can only be used in interactive mode' )
      GO TO 9900
C
9900  CONTINUE
C -- ERRORS DETECTED
&PPC      CALL stcrys
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)
      CALL XERHND ( IERWRN )
      RETURN
      END
C
CODE FOR KLNKIO
      FUNCTION KLNKIO (ILINK)
C
C----- RETURNS NEGATIVE IF FAILURE
C      ILINK - THPE OF FOREIGN PROGRAM
      CHARACTER *256 CPATH
      PARAMETER (NFILE = 10)
      CHARACTER *16 CFILE(NFILE)
C
      DIMENSION JFRN(4,2),  LFILE(NFILE)
C
\XUNITS
\XSSVAL
\XOPVAL
\XERVAL
C
      DATA CFILE / 'SNOOPI.INI' ,  'SNOOPI.L5' ,
     1             'SHELXS.INS' ,  'SIRDATA.DAT',
     2             'CAMERON.INI' ,  'CAMERON.L5I',
     3             'SIR92.INI', 'SIR97.INI',
     4             'PLATON.RES','PLATON.HKL' /
      DATA LFILE / 10,  9,  10,  11, 11, 11, 9, 9, 10, 10 /
C
      DATA JFRN /'F', 'R', 'N', '1',
     1           'F', 'R', 'N', '2'/
C
100   CONTINUE
      JLOOP = 1
      KLOOP = 1
      KLNKIO = -1
      LPATH  = KPATH( CPATH)
C     SNOOPI, CAMERON, SHELXS86, MULTAN, SIR88, SIR92, SIR97, PLATON
C
C----- OPEN THE FIRST FILE
      JFILE = 1
      GOTO ( 110, 120, 130, 140, 150, 160, 170, 180 ), ILINK
C
110   CONTINUE
      IFILE = 1
      KLOOP = 2
      GOTO 1000
120   CONTINUE
      IFILE = 5
      KLOOP = 2
      GOTO 1000
130   CONTINUE
      IFILE=3
      GOTO 1000
140   CONTINUE
      IFILE=0
      GOTO 9000
150   CONTINUE
      IFILE=4
      GOTO 1000
160   CONTINUE
      IFILE=7
      GOTO 1000
170   CONTINUE
      IFILE=8
      GOTO 1000
180   CONTINUE
      IFILE=9
      KLOOP = 2
      GOTO 1000
C
C
1000  CONTINUE
      CALL XRDOPN ( 5 , JFRN(1,JFILE) ,
     1 CPATH(1:LPATH)// CFILE(IFILE)(1:LFILE(IFILE)),
     2 LPATH+LFILE(IFILE))
C------ EXIT ON ERROR
      IF (IERFLG .LE. 0) GOTO 9900
      IF (JLOOP .LT. KLOOP) THEN
C           PICK UP THE SECOND GRAPHICS FILE
            JFILE = 2
            IFILE = IFILE + 1
            JLOOP = JLOOP + 1
            GOTO 1000
      ENDIF
      GOTO 9000
C
9000  CONTINUE
C----- INDICATE IO OK
      KLNKIO = 1
9900  CONTINUE
      RETURN
      END
C
C - OLD SUBROUTINES FOR SNOOPI & CONTOUR REMOVED
C   *XLNKCN
C   *XLNKSN
C   -98,98
C   1410  FORMAT ('LIST5', /, 'SNOOPI.L5')
C   -194
C
C
CODE FOR XLNKCM
      SUBROUTINE XLNKCM
C
C     THIS SUBROUTINE READS INFOMATION FROM LISTS 1,2 & 5
C     AND PREPARES DATRA FOR CAMERON
C----- FORMAT IN 'STORE' IS:
C      0   NUMBER OF ITEMS IN HEADER
C      1-6 CELL, ANGSTROM AND RADIANS
C      7   CENTRED FLAG 0.0 = ACENTRIC
C      8   No OF SYMMETRY MATRICES
C      9   NO OF CENTRING VECTORS
C      10  START OF ATOMS
C      11  NO OF ATOMS
C      12  NO OF ITEMS PER ATOM
C
C      ..      SYMMETRY MATRICES 3X4, BY COLUMNS
C      ..      CENTRING VECTORS, AS ROWS
C      ..      ATOMS (TYPE, SERIAL,OCC, UISO,X'S,U'S, SPARE)
C
      DIMENSION LISTS(3)
C
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XCONST
\XLST01
\XLST02
\XLST05
\XOPVAL
\XERVAL
\XIOBUF
C
\QSTORE
C
      DATA NLISTS / 3 /
      DATA LISTS(1) / 1 / , LISTS(2) / 2 / , LISTS(3) / 5 /
C
C -- CHECK THAT OPERATION IS BEING PERFORMED IN INTERACTIVE MODE
      IF ( IQUN .NE. JQUN ) GO TO 9920
C
C--FIND OUT WHICH LISTS EXIST
      IERROR = 1
      DO 1300 N=1 , NLISTS
        LSTNUM = LISTS(N)
        IF (  KEXIST ( LSTNUM )  ) 1210 , 1200 , 1220
1200    CONTINUE
        WRITE ( NCAWU , 1205 ) LSTNUM
        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1205) LSTNUM
        WRITE ( CMON, 1205 ) LSTNUM
        CALL XPRVDU(NCVDU, 1,0)
1205    FORMAT ( 1X , 'List ' , I2 , ' contains errors')
        IERROR = -1
        GOTO 1300
1210    CONTINUE
        WRITE ( NCAWU , 1215 ) LSTNUM
        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1215) LSTNUM
        WRITE ( CMON, 1215 ) LSTNUM
        CALL XPRVDU(NCVDU, 1,0)
1215    FORMAT ( 1X , 'List' , I2 , ' does not exist' )
        IERROR = -1
        GOTO 1300
1220    CONTINUE
1300  CONTINUE
      IF ( IERROR .LE. 0 ) GOTO 9900
C
C
C -- LOAD LISTS
C
      CALL XFAL01
      CALL XFAL02
C
C----- NO OF ITMES IN HEADER
      NITEM = 13
      ISTART = KSTALL(NITEM)
      STORE(ISTART) = FLOAT(NITEM)
C----- CELL
      CALL XMOVE (STORE(L1P1), STORE(ISTART+1), 6)
C----- CONVERT TO DEGREES
      STORE(ISTART+3) = RTD * STORE(ISTART+4)
      STORE(ISTART+4) = RTD * STORE(ISTART+5)
      STORE(ISTART+5) = RTD * STORE(ISTART+6)
C----- CENTRIC/ACENTRIC
      STORE(ISTART+7) = STORE(L2C)
C----- NO OF MATRICES
      STORE(ISTART+8) = N2
C----- NO OF CENTRING VECTORS
      STORE(ISTART+9) = N2P
C
C
C----- THE SYMMETRY MATRICES AND VECTORS
      M2 = L2 + (N2-1)*MD2
      DO 1400 IND2=L2,M2,MD2
      I = KSTALL(MD2)
      CALL XMOVE (STORE(IND2), STORE(I), MD2)
1400  CONTINUE
C----- THE CENTRING VECTORS
      DO 1500 IND1=L2P,M2P,3
      I = KSTALL(3)
      CALL XMOVE (STORE(IND1), STORE(I), 3)
1500  CONTINUE
C
C----- LOAD LIST 5
C      CALL XFAL05
      LN5 = 1
      LN5 = KTYP05(LN5)
      CALL XLDR05(LN5)
C
      STORE(ISTART+10) = FLOAT (L5)
      STORE(ISTART+11) = FLOAT (N5)
      STORE(ISTART+12 ) = FLOAT (MD5)
C
C---- INITIALISATION
      CALL XCAMER( 1, ISTART, IEND, -1)
C----- REAL WORK
      CALL XCAMER( 2, ISTART, IEND, -1)
C
C----- HAS CAMERON CHANGED THE ATOMS?
      NN5 = NINT(STORE(ISTART+11))
      IF (NN5 .LT. 0) THEN
        N5 = -NN5
        N = N5
        NEW = 1
        CALL XSTR05(LN5, 0, NEW)
        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1520) N5
        WRITE ( NCAWU, 1520 ) N5
        WRITE ( CMON, 1520 ) N5
        CALL XPRVDU(NCVDU, 1,0)
1520    FORMAT (' LIST 5 now contains ', I6, ' atoms')
      ENDIF
      RETURN
C
C
9900  CONTINUE
C -- ERRORS DETECTED
      CALL XERHND ( IERWRN )
      RETURN
C
9920  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9925 )
      ENDIF
      WRITE ( NCAWU , 9925 )
      WRITE ( CMON, 9925 )
      CALL XPRVDU(NCVDU, 1,0)
9925  FORMAT ( 1X , 'CAMERON can only be used in interactive mode' )
      GO TO 9900
C
      END
C
CODE FOR XCAMER
      SUBROUTINE XCAMER( ICALL, ISTART, IEND, IDEV)
\XUNITS
\STORE
\XIOBUF
      IF (ICALL .GE. 2) RETURN
C----- DUMMY ROUTINE FOR INTERNAL LINK TO CAMERON
      WRITE ( CMON, '('' Test link to CAMERON - not used now '')')
      CALL XPRVDU(NCEROR, 1,0)
      WRITE (NCAWU, '(1X,6F8.2)') (STORE(I), I=ISTART,ISTART+5)
      WRITE (NCAWU, '(1X,6I6)') (NINT(STORE(I)), I=ISTART+6, ISTART+11)
C----- START OF GOODIES
      IBASE = ISTART + NINT(STORE(ISTART))
C----- SYMMETRY MATRICES
      J = IBASE
      L = 12
      K = J+NINT(STORE(ISTART+8)-1) * L
      WRITE(NCAWU,'(1X,'' Matrices '')')
      DO 1000 I = J,K,L
        WRITE(NCAWU,'(1X,3F8.2)') (STORE(M), M=I,I+L-1)
        WRITE(NCAWU, '(1X)')
1000  CONTINUE
C
C----- CENTRING VECTORS
      J = J +12*NINT(STORE(ISTART+8))
      L = 3
      K = J+NINT(STORE(ISTART+9)-1) * L
      WRITE(NCAWU,'(1X,'' Vectors '')')
      DO 1100 I = J,K,L
        WRITE(NCAWU,'(1X,3F8.2)') (STORE(M), M=I,I+L-1)
        WRITE(NCAWU, '(1X)')
1100  CONTINUE
C
C----- ATOMS
      J = NINT(STORE(ISTART+10))
      L = NINT(STORE(ISTART+12))
      K = J+NINT(STORE(ISTART+11)-1) * L
      WRITE(NCAWU,'(1X,I6, '' Atoms '')') NINT(STORE(ISTART+11))
      DO 1200 I = J,K,L
        WRITE(NCAWU,'(1X,A4,F8.0,5F8.4/13X,7F8.4)')
     1 (STORE(M), M=I,I+L-1)
1200  CONTINUE
C^^^^^ a patch to test re-writing
      STORE(ISTART+11) = -STORE(ISTART+11)
      RETURN
      END
C
C---- OLD LINK TO SHELX REMOVED
C   *XLNKSX
C
C
C
CODE FOR XLNKMN
      SUBROUTINE XLNKMN
C
C     LINK TO WRITE OUTPUT FOR MULTAN84
C
      CHARACTER *32 OPERAT, CPATH
      CHARACTER *1  LATTYP(7)
C
C
\ISTORE
C
      DIMENSION LISTS( 6 ), JFRN1(4), JFRN2(4)
C
\STORE
\XUNITS
\XSSVAL
\XCOMPD
\XCONST
\XLST01
\XLST02
\XLST03
\XLST06
\XLST13
\XLST29
\XERVAL
\XOPVAL
\XIOBUF
C
\QSTORE
C
      DATA NLISTS / 6 /
      DATA LISTS(1) / 1 /, LISTS(2) / 2 /, LISTS(3) / 3 /,
     1     LISTS(4) / 6 /, LISTS(5) / 13/, LISTS(6) / 29/
      DATA LATTYP /'P','I','R','F','A','B','C'/
      DATA JFRN1 /'F', 'R', 'N', '1'/
      DATA JFRN2 /'F', 'R', 'N', '2'/
C
      IERROR = 1
C---- GET THE PATH NAME
      LPATH  = KPATH( CPATH)
C----- NOW OPEN THEM WITH THE MULTAN84 FILES
      CALL XRDOPN ( 5 , JFRN1 ,
     1 CPATH(1:LPATH)//'MULTAN.CDR ', LPATH+11)
      IDEV = NCFPU1
      IF (IERROR .LE. 0) GOTO 9930
      CALL XRDOPN ( 5 , JFRN2 ,
     1 CPATH(1:LPATH)//'MULTAN.RFL ', LPATH+11)
      IDEV = NCFPU2
      IF (IERROR .LE. 0) GOTO 9930
C
C--FIND OUT WHICH LISTS EXIST
C
      DO 1300 N=1 , NLISTS
        LSTNUM = LISTS(N)
        IF (  KEXIST ( LSTNUM )  ) 1210 , 1200 , 1220
C
1200    CONTINUE
        WRITE ( NCAWU , 1205 ) LSTNUM
        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1205) LSTNUM
        WRITE ( CMON, 1205 ) LSTNUM
        CALL XPRVDU(NCVDU, 1,0)
1205    FORMAT ( 1X , 'List ' , I2 , ' contains errors')
        IERROR = -1
        GOTO 1300
C
1210    CONTINUE
        WRITE ( NCAWU , 1215 ) LSTNUM
        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1215) LSTNUM
        WRITE ( CMON, 1215 ) LSTNUM
        CALL XPRVDU(NCVDU, 1,0)
1215    FORMAT ( 1X , 'List' , I2 , ' does not exist' )
        IERROR = -1
        GOTO 1300
C
1220    CONTINUE
1300  CONTINUE
      IF ( IERROR .LE. 0 ) GOTO 9900
C
C----- OUTPUT A TITLE, FIRST 20 CHARACTERS ONLY
      WRITE(NCFPU1,1320) (KTITL(I),I=1,20)
1320  FORMAT(' ',20A4)
C
C----- LOAD LIST 1 AND 13. CONVERT ANGLES TO DEGREES.
      CALL XFAL01
      CALL XFAL13
      ALPHA = RTD * STORE(L1P1+3)
      BETA  = RTD * STORE(L1P1+4)
      GAMMA = RTD * STORE(L1P1+5)
      WRITE(NCFPU1,1400) (STORE(I),I=L1P1,L1P1+2),
     1 ALPHA, BETA, GAMMA
1400  FORMAT ('CELL ', 3F7.3, 3F8.3)
C
C
C----- LOAD LIST 2 AND CONVERT TO CHARACTER
      CALL XFAL02
C----- FIND LATTICE TYPE
      IF (IC .GE. 1) WRITE(NCFPU1,1420)
1420  FORMAT('CENTRO')
      WRITE (NCFPU1,1450) LATTYP(IL)
1450  FORMAT( 'LATT ', A)
C
      DO 1550 I = L2,M2,MD2
            CALL XSUMOP( STORE(I), STORE(L2P), OPERAT, LENGTH,0)
            IF (I .EQ. L2) THEN
                  WRITE(NCFPU1,1500) OPERAT(1:LENGTH)
            ELSE
                  WRITE(NCFPU1,1510) OPERAT(1:LENGTH)
            END IF
1500        FORMAT('SYMM  ', A)
1510        FORMAT(' *  ', A)
1550   CONTINUE
C
C
C----- LOAD LIST 29
      CALL XFAL29
C
      IF ( N29 .GT. 0 ) THEN
        WRITE ( NCFPU1 , 1600 ) ( STORE(J), NINT(T2*STORE(J+4)),
     1  J = L29 , M29 , MD29 )
1600    FORMAT( 'CONTENT ',8(1X, A4, I4))
      ELSE
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 1700 )
      ENDIF
        WRITE ( NCAWU , 1700 )
        WRITE ( CMON, 1700 )
        CALL XPRVDU(NCVDU, 1,0)
1700    FORMAT ( 1X , 'No atom details stored in list 29' )
        GOTO 9900
      ENDIF
C
      WRITE(NCFPU1,1730)
1730  FORMAT( 'FORMAT 1  (3I4, F8.1, I2)' / 'END ')
C
C----- LOAD LIST 6
      CALL XFAL06(0)
C----- FIND SCALE FROM MAXIMUM FO (ITEM 3)
      IN = L6DTL + MD6DTL * 3
      IF (STORE(IN+3) .LE. ZERO) THEN
      SCALE = 1.0
      ELSE
      SCALE = 9999./ STORE(IN+1)
      ENDIF
C
C----- LOOP OVER DATA
      IN = 0
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
      FS =  STORE(M6+3) * SCALE
      WRITE(NCFPU2,1850) I, J, K, FS, JCODE
1850  FORMAT(3I4, F8.3, I2)
      GOTO 1800
2000  CONTINUE
C----- END OF DATA - WRITE A NEGATIVE INTENSITY
      WRITE (NCFPU2,1860)
1860  FORMAT('             -512      ')
C
C----- ENSURE THE UNITS ARE CLOSED
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)
C
      RETURN
C
9930      CONTINUE
      WRITE(NCAWU,9940)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,9940)
      ENDIF
      WRITE ( CMON, 9940)
      CALL XPRVDU(NCVDU, 1,0)
      CALL XERIOM (IDEV, IOS)
9940  FORMAT( ' Error opening MULTAN output file  ')
      GOTO 9900
C
9900  CONTINUE
C -- ERRORS DETECTED
      CALL XERHND ( IERWRN )
      RETURN
      END
C----- OLD LINK TO SIR AND UNIX REMOVED
C  *XLNKSR
C  -88,88
C        CALL XCREMS (CSOURC(1:20), CRESLT(1:20) , I)
C  -108,108
C          CALL XCREMS (CSOURC(1:72), CRESLT(1:72) , J)
C  *XUNIX
C
