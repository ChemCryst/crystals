Cavdlmay29-fixed problem in trigonal groups
C $Log: link.fpp
C Revision 1.53  2005/02/25 17:25:20  stefan
C 1. Added some preprocessor if defined lines for the mac version.
C
C Revision 1.52  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.3  2005/01/07 11:56:53  rich
C Add some blank lines between some #if and #endifs.
C
C Revision 1.2  2004/12/13 16:16:08  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.51  2004/11/23 15:12:21  stefan
C 1. A crysedit directied had one more & and # than it should have had.
C
C Revision 1.50  2004/11/11 15:54:14  rich
C Add ZERR line to PLATON output.
C
C Revision 1.49  2004/10/06 13:57:13  rich
C Fix for WXS version.
C
C Revision 1.48  2003/10/31 17:25:31  rich
C Don't output reflections to SHELXS.INS when using
C #FOREIGN SHELX SPECIAL
C
C Revision 1.47  2003/08/13 12:30:12  rich
C Avoid calling XMOVE with zero length arrays to move, it fails.
C
C Revision 1.46  2003/08/05 11:11:11  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.45  2003/07/16 21:59:39  rich
C Zero L12 prior to KDIST4 call. (It may remain set from a previous
C instruction, causing crashes).
C
C Revision 1.44  2003/06/09 13:47:03  rich
C Preserve original bond types when expanding the network by symmetry (this is
C a MOGUL issue.)
C
C Revision 1.43  2003/05/14 13:02:45  rich
C Ensure correct bond indices for TRIPOS mol2 file.
C
C Ensure additional symmetry atoms are not duplicates of
C existing atoms (even in the first level of expansion - the
C atom may be on a special position.)
C
C Revision 1.42  2003/05/07 12:18:54  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.41  2003/03/20 16:10:11  rich
C
C Moved SYMMETRY expansion code into a subroutine so it can be applied
C identically whether in LINK or in DISTANCES. Commented out some debugging.
C
C Revision 1.40  2003/02/14 17:09:02  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.39  2003/01/14 10:17:16  rich
C Don't prefix filenames with a space (empty path), as on Unix the space
C gets put into the filename. Urgh.
C
C Revision 1.38  2002/12/16 18:21:58  rich
C Now only outputs 'main' part of molecule.
C
C Revision 1.37  2002/10/31 13:21:17  rich
C Changes to #FORE/MOL2 format for MOGUL.
C
C Revision 1.36  2002/10/02 13:39:32  rich
C MOL2 format support.
C
C Revision 1.35  2002/05/31 14:41:09  Administrator
C Update SHELX SPECIAL output
C
C Revision 1.34  2002/03/28 17:04:02  richard
C REmoved obsolete GUWAIT, used ^^CW instead.
C
C Revision 1.33  2002/03/13 12:42:01  richard
C Support for writing MOL2 and CSD file formats. PUNCH MOGUL option for distances.
C Changed default colour in L28 to UNKNOWN.
C
C Revision 1.32  2002/03/08 16:01:00  ckp2
C Second parameter for #FOREIGN. METHOD = NORMAL, METHOD = FILTERED. Controls
C output of reflections for Sir92 only.
C
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA ICOMSZ / 4 /
C
C----- ALLOCATE ROOM FOR INPUT VALUES
CMAR98

CRIC11 - Store limits were not set.
      CALL XRSL
      CALL XCSAE

      ICOMBF = KSTALL( ICOMSZ)
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
C
      ISTAT = KRDDPV( ISTORE(ICOMBF), ICOMSZ)
      IF ( ISTAT .LT. 0 ) GO TO 9910
      ITYPE = ISTORE(ICOMBF + 1)
      IMETH = ISTORE(ICOMBF + 2)
      ITYP06= ISTORE(ICOMBF + 3)
c      IULN6 = KTYP06(ITYP06)
C
C-     LINKS ARE  1:SNOOPI, 2:CAMERON, 3:SHELXS86, 4:MULTAN81
C-                5:SIR88, 6:SIR92, 7:SIR97, 8:PLATON 9:CSD 10:MOL2
C                 11:SUPERFLIP         12:SIR02    13:SIR11
      CALL XLNK (ISTORE(ICOMBF), ITYPE, IMETH, ityp06)
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
      SUBROUTINE XLNK (ILINK, IEFORT, IMETHD, ityp06)
C
C      PREPARE DATA FOR FOREIGN PROGRAMS
C      ILINK  SELECTS THE SORT OF OUTPUT TO PRODUCE
C-     ILINKS ARE  1:SNOOPI, 2:CAMERON, 3:SHELXS86, 4:MULTAN81
C-                 5:SIR88,  6:SIR92,   7:SIR97,    8:PLATON,  9:CSD 10:MOL2 
C                 11:SUPERFLIP         12:SIR02    13:SIR11
C      IEFORT SELECTS POWER SETTING OF FOREIGN CALL
C           FOR SHELXS86     IEFORT = 1, NORMAL
C                                     2, DIFFICULT
C                                     3, SPECIAL - PUNCH ATOMS
C                                     4, PATTERSON
C
C           FOR SIR92,97,02  IEFORT = 1, NORMAL
C                        11           2, DIFFICULT
C                                     3, SPECIAL - PUNCH ATOMS
C                                     4, PATTERSON
C                                     5, HARD
C                                     6, LONG

CavdLdec06  FOR SUPERFLIP    IEFORT = 1, NORMAL
C                            IEFORT = 2, DIFFICULT (weak data)
c           for cameron      iefort = 1, normal
c                                     2, dont create new cameron files
C           FOR CSD          IEFORT = 1, normal - 2d structure
C                                     2, special - just cell search
c      ITYP06                6 OR 7
C
Cavdldec06 - now THIRTEEN links (NLINK=13)
C     ADD SIR02, SIR11
      PARAMETER (NLINK=13, NLIST=8)
      PARAMETER ( NWORK = 1000 )
C      IMETHD SELECTS SOME SORT OF ALTERNATIVE METHOD FOR THE
C      FOREIGN CALL.
C           FOR SIR92 (only)  IMETHD = 0, NORMAL
C                             IMETHD = 1, FILTERED (check refl with L28)
C
C---- FOR EACH TYPE OF LINK, INDICATE WHICH LISTS MUST BE LOADED
      DIMENSION LISTS(NLIST, NLINK)
C
C----- FOR SHELXS86
      CHARACTER *32 OPERAT
      CHARACTER *32 DECML,DECMT
C
C----- FOR SIR**
cdjw aug99
      CHARACTER *1 CARROW
      CHARACTER *160 CSOURC, CSPACE, CL29, CRESLT, CHARTC
      CHARACTER *16 CTEMP
C----- FOR Superflip**
cavdl dec06
      INTEGER IMAXIND(3),IVOXEL(3)
      CHARACTER *1 CBLANK
      CHARACTER *4 CATOM(15)
      CHARACTER *21 CDUMF
      CHARACTER *10 CSPG
      character *32 CLINE
      CHARACTER LOCASE*(200)
      REAL*8 XCEN,YCEN,ZCEN, ACELL(6)
      DIMENSION   TEMP(10), ITEMP(10),CBUFF1(10)
      EQUIVALENCE (TEMP(1), ITEMP(1))
C
      REAL MAT(3)
C----- FOR CSD & MOL2
      CHARACTER *18 CLAB, CLAB2
      REAL ANGV(3)
      CHARACTER*2 CBONDS(9)

C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM31.INC'
      INCLUDE 'ICOM02.INC'
      INCLUDE 'ICOM14.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCOMPD.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XLST31.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'QLST02.INC'

C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST31.INC'
C
C- ILINKS ARE  1:SNOOPI, 2:CAMERON, 3:SHELXS86, 4:MULTAN81
C-                 5:SIR88,  6:SIR92,   7:SIR97,    8:PLATON,  9:CSD 10:MOL2
C                 11:SUPERFLIP         12:SIR02    13:SIR11
C- POINTER TO LIST
      DATA LISTS /1, 2, 5, 0, 0,  0,  0,  0,
     2            1, 2, 5, 0, 0,  0,  0,  0,
     3            1, 2, 3, 0, 6, 13, 29, 31,
     4            1, 2, 3, 0, 6, 13, 29,  0,
     5            1, 2, 3, 0, 6, 13, 29,  0,
     6            1, 2, 3, 0, 6, 13, 29,  0,
     7            1, 2, 3, 0, 6, 13, 29,  0,
     8            1, 2, 3, 5, 6, 13, 29, 31,
     9            1, 3, 5,29,41,  0,  0,  0,
     1            1, 2, 3, 5, 0, 29, 40, 41,
     2            1, 2, 3,30, 6, 13, 29, 31,
     7            1, 2, 3, 0, 6, 13, 29,  0,
     8            1, 2, 3, 0, 6, 13, 29,  0/
C
#if defined (_HOL_)
      DATA KHYD,KDET,CBLANK /4HH   ,4HD   ,' '/
#else
      DATA KHYD,KDET,CBLANK /'H   ','D   ',' '/
#endif

      DATA CBONDS / '1','2','3','4','ar','un','de','un','pi'/
c      DATA IDIMBF / 2 /
      INCLUDE 'IDIM02.INC'
c      ICOMBF = KSTALL ( IDIMBF )
c      CALL XZEROF (STORE(ICOMBF), IDIMBF)
c      INCLUDE 'IDIM02.INC'
c      INCLUDE 'IDIM14.INC'
C
cdjwsep07      IULN6 = 6
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
            CALL XFAL06(IULN6,0)
        ELSE IF (LSTNUM .EQ. 13) THEN
            CALL XFAL13
        ELSE IF (LSTNUM .EQ. 29) THEN
            CALL XFAL29
        ELSE IF (LSTNUM .EQ. 30) THEN
            CALL XFAL30
        ELSE IF (LSTNUM .EQ. 31) THEN
C--         LOAD LIST 31 FROM DISC
      INCLUDE 'IDIM31.INC'
            CALL XLDLST(31,ICOM31,IDIM31,0)
            IF ( IERFLG .LT. 0 ) GO TO 9900
C-----      SCALE DOWN THE ELEMENTS OF THE V/CV MATRIX
            A = STORE(L31K)
            M31 = L31
            M31L = M31 + MD31 -1
            DO 900 I = M31, M31L
              STORE(I)  =  SQRT (STORE(I) * A)
900         CONTINUE
        ELSE IF (LSTNUM .EQ. 40) THEN
            CALL XFAL40
        ELSE IF (LSTNUM .EQ. 41) THEN
            CALL XFAL41
        ENDIF
1300  CONTINUE
      IF ( IERROR .LE. 0 ) GOTO 9900
C
1400  CONTINUE
C----- OPEN THE OUTPUT DEVICES
#if defined(_PPC_)
      CALL stuser
#endif

      IF (KLNKIO (ILINK) .LE. 0 ) GOTO 9900

#if defined(_PPC_)
      CALL stcrys
C
C
C            SNOOPI, CAMERON, SHELXS86,
C            MULTAN, SIR88,   SIR92, SIR97
C            PLATON,  CSD,   MOL2 , SUPERFLIP, SIR02, SIR11
CAVDLdec06 added superflip
#endif
      GOTO ( 1600,   1700,    1800,
     1       2000,   1900,    1900,   1900,   
     2       1860,   1870,    1880,   1890, 
     3       1900,   1900,    9900), ILINK
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
#if defined(_PPC_)
      WRITE ( NCFPU1 ,  '(''CRUSE:SNOOPI.L5'')' )
#endif
#if defined(_VAX_)
      WRITE ( NCFPU1 ,  '(''USER:SNOOPI.L5'')' )
#endif
#if defined(_DOS_)
      WRITE ( NCFPU1 ,  '(''SNOOPI.L5'')' )
#endif
#if defined(_H_P_)
      WRITE ( NCFPU1 ,  '(''SNOOPI.L5'')' )
#endif
#if defined(_CYB_)
      WRITE ( NCFPU1 ,  '(''SNOOPI.L5'')' )
#endif
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
#if defined(_PPC_)
      WRITE ( NCFPU1 ,  '(''CRUSE:CAMERON.L5I'')' )
#endif
#if defined(_VAX_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_DOS_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_DVF_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_LIN_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_GIL_)  || defined(_MAC_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_WXS_) || defined(_INW_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_GID_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_H_P_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
#if defined(_CYB_)
      WRITE ( NCFPU1 ,  '(''CAMERON.L5I'')' )
#endif
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
      WRITE(NCFPU1, '(''CELL '', F8.5, 6f10.5)')
     1 STORE(L13DC), (STORE(I),I=L1P1,L1P1+5)
      WRITE(NCFPU1,1810) NINT(T2),
     1 STORE(L31), STORE(L31+6), STORE(L31+11),
     2 RTD*STORE(L31+15),RTD*STORE(L31+18),RTD*STORE(L31+20)
1810  FORMAT ('ZERR ', I4, 6F7.4)
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
        WRITE (NCFPU1, ' (''UNIT '', 12F6.0)')
     1  (F*STORE(J+4), J = L29, M29, MD29)
      ENDIF
C
      IF (IEFORT .EQ. 3) THEN
C----- WRITING ATOMS - SAVE AND RESTORE IO UNITS
        J = NCPU
        NCPU = NCFPU1
        CALL XPCH5C(1)
        NCPU = J
        WRITE(NCFPU1,'(A)') 'HKLF 4'
        WRITE(NCFPU1,'(A)') 'END'
        WRITE(CMON,'(A)') 'Shelx ins written: {&SHELXS.INS{&'
        CALL XPRVDU(NCVDU,1,0)
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
cdjwoct08
c----- rescale incase there are any very big numbers
C----- FIND SCALE FROM MAXIMUM FO (ITEM 3)
      IN = L6DTL + MD6DTL * 3
      IF (STORE(IN+3) .LE. ZERO) THEN
      SCALE = 1.0
      ELSE
      SCALE =  99998./(STORE(IN+1)*store(in+1)) 
      ENDIF
      write(ncwu,*) store(in+1),store(in+2),store(in+3)
      write(ncwu,'(a,f12.5)') 'Scale', scale
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
      CALL XSQRF
     1 (FS, STORE(M6+3), FABS, S, STORE(M6+12))
      IF ((S .LE. ZERO) .AND. (STORE(M6+20) .GT. ZERO))
     1 S = ABS(FS) / STORE(M6+20)
cdjwoct08
      fs = scale*fs
      s  = scale*s
CDJWMAR99]
      IF (FS.LE.-1000.) THEN
       WRITE(NCFPU1, '(3I4, 2F8.1)') I, J, K, FS, S
      ELSE IF (FS.LE.0.) THEN
       WRITE(NCFPU1, '(3I4, 2F8.2)') I, J, K, FS, S
      ELSE IF (FS.LE.9999.) THEN
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
C----- END OF SHELXS DATA
      GOTO 8000
CAVDLdec06 continue with superflip data
1890  CONTINUE
C     LINK TO WRITE OUTPUT FOR SUPERFLIP ---------------------
C----- OUTPUT A TITLE, FIRST 72 CHARACTERS ONLY
      WRITE(NCFPU1,'(''title '',18A4)') (KTITL(I),I=1,18)
      WRITE(NCFPU1,'(''perform CF'')')
      WRITE(NCFPU1,'(''outputfile sflip.m81 sflip.m80 sflip_sym.ins'')')
      WRITE(NCFPU1,'(''outputformat jana'')')
      WRITE(NCFPU1,'(''dataformat intensity'')')
      WRITE(NCFPU1,'(''dimension  3'')')
C---- voxel calculation, needed information hmax, kmax, lmax and crystal system
C----- DISPLAY SPACE GROUP SYMBOL
Cavdl do a check on the symbol (script sometimes creates a 'wrong' symbol)
c      CALL XSPCGR
cavdl-- pick up the cell parameters
      J=L1P1
      DO I=1,6
        ACELL(I)=STORE(J)
        J=J+1
      ENDDO
c      WRITE ( CTEMP , '(4A4)') (ISTORE(I),I=L2CC,J)
c      WRITE(CMON,4351) CTEMP(1:4)
c      CALL XPRVDU(NCVDU, 1,0)
      J  = L2SG + MD2SG - 1
      CSOURC = ' '
      CSPACE = ' '
      WRITE(CSOURC, '(4(A4,1X) )') (ISTORE(I), I = L2SG, J)
      CALL XCREMS (CSOURC, CSPACE, ISP )
      READ ( CSPACE(1:10), '(10A1)' ) (ITEMP(J), J = 1,10)
c      write(ncwu,'(a)') cspace(1:10)
c      write(ncwu,'(10a1)') itemp
C
c djw declare workspace
c
       jxt1 = KSTALL ( 288 )
       xt2  = KSTALL ( 12 )
       xt3  = KSTALL ( 500 )
       CALL XZEROF (STORE(jxt1), 228)
       CALL XZEROF (STORE(xt2), 12)
       CALL XZEROF (STORE(xt3), 500)
c
       CALL SGROUP ( temp ,
     2  LAUENO , NAXIS , NCENT , LCENT ,
     3  N2 , NPOL , istore(JXT1),
     4  store(XT2) , N2P ,
     5  NCAWU , NCAWU , store(XT3) )
       WRITE(NCWU,4359) LAUENO
4359   FORMAT ('Laue number',I5)
      ILAUE=1
C----- CRYSTAL CLASS - FROM LIST 2
cavdlmay08 set the crystal class here in case a change was made by Superflip
      J=L2CC+MD2CC-1
c      WRITE(CMON,4351) (ISTORE(I),I=L2CC,J)
c      CALL XPRVDU(NCVDU, 1,0)
4351  FORMAT (4(A4))
c4351  FORMAT ('Laue group',A4)
      IF (LAUENO.EQ.1) THEN
         ILAUE=1
         CTEMP(1:16)='triclinic       '
      ENDIF
      IF (LAUENO.EQ.2) THEN
         ILAUE=2
         ACELL(4)=90.000d0
         ACELL(6)=90.000d0
         CTEMP(1:16)='monoclinic      '
      ENDIF
      IF (LAUENO.EQ.3) THEN
         ILAUE=4
         ACELL(4)=90.000d0
         ACELL(5)=90.000d0
         ACELL(6)=90.000d0
         CTEMP(1:16)='orthorhombic    '
      ENDIF
      IF ((LAUENO.EQ.4).OR.(LAUENO.EQ.5)) THEN
         ILAUE=4
         ACELL(2)=ACELL(1)
         ACELL(4)=90.000d0
         ACELL(5)=90.000d0
         ACELL(6)=90.000d0
         CTEMP(1:16)='tetragonal      '
      ENDIF
      IF ((LAUENO.EQ.6).OR.(LAUENO.EQ.7)) THEN
         ILAUE=2
         ACELL(2)=ACELL(1)
         ACELL(3)=ACELL(1)
         ACELL(5)=ACELL(4)
         ACELL(6)=ACELL(4)
         CTEMP(1:16)='rhombohedral    '
      ENDIF
      IF ((LAUENO.GE.8).AND.(LAUENO.LE.10)) THEN
cavdlmay08: there may be 1/2 components along the c-axis (P31c) so the multiplier
c           is rather 3*2
         ILAUE=3*2
         ACELL(2)=ACELL(1)
         ACELL(4)=90.000d0
         ACELL(5)=90.000d0
         ACELL(6)=120.000d0
         CTEMP(1:16)='trigonal        '
      ENDIF
      IF ((LAUENO.GE.11).AND.(LAUENO.LE.12)) THEN
         ILAUE=6
         ACELL(2)=ACELL(1)
         ACELL(4)=90.000d0
         ACELL(5)=90.000d0
         ACELL(6)=120.000d0
         CTEMP(1:16)='hexagonal       '
      ENDIF

      IF ((LAUENO.EQ.13).OR.(LAUENO.EQ.14)) THEN
         ILAUE=4
         ACELL(2)=ACELL(1)
         ACELL(3)=ACELL(2)
         ACELL(4)=90.000d0
         ACELL(5)=90.000d0
         ACELL(6)=90.000d0
         CTEMP(1:16)='cubic           '
      ENDIF
       READ ( CTEMP(1:16), '(4A4)' )(ISTORE(I), I = L2CC,J)
c     WRITE(CMON,4351) (ISTORE(I),I=L2CC,J)
c     CALL XPRVDU(NCVDU, 1,0)
cavdlmay08 - store crystals class on disk
      CALL XWLSTD(2,ICOM02,IDIM02,-1,1)
C----- RELECTION LIMITS IN DATA COLLECTION
       K=0
        DO I=1,3
         IMAXIND(I)=0
             DO J=1,3,2
               IMAXIND(I)=MAX(IMAXIND(I),ABS(NINT(STORE(L30IX+K))))
             K=K+1
           END DO
         END DO
         DO I=1,3
c         IDUM=IMAXIND(I)*2/ILAUE
c         IVOXEL(I)=(IDUM+1)*ILAUE
          IVOXEL(I)=(NINT(IMAXIND(I)*1.10)+3)*2
c         WRITE ( CMON, '('' voxel '',2i5)') IVOXEL(I),ILAUE
c         CALL XPRVDU(NCVDU, 1,0)

      END DO
      IF (LAUENO.EQ.1) THEN
       DO I=1,3
         IDUM=IVOXEL(I)
         IVOXEL(I)=IDUM+1
       END DO
      ENDIF
      IF ((LAUENO.EQ.2).OR.(LAUENO.EQ.3)) THEN
       DO I=1,3
         IDUM=IVOXEL(I)/ILAUE
         IVOXEL(I)=(IDUM+1)*ILAUE
       END DO
      ENDIF
      IF ((LAUENO.EQ.4).OR.(LAUENO.EQ.5)) THEN
         IDUM=IVOXEL(3)/ILAUE
         IVOXEL(3)=(IDUM+1)*ILAUE
         IDUM=IVOXEL(1)/2
         IVOXEL(1)=(IDUM+1)*ILAUE
         IDUM=IVOXEL(2)/2
         IVOXEL(2)=(IDUM+1)*ILAUE
      ENDIF
      IF ((LAUENO.EQ.6).OR.(LAUENO.EQ.7)) THEN
         IDUM=IVOXEL(3)/ILAUE
         IVOXEL(3)=(IDUM+1)*ILAUE
         IDUM=IVOXEL(1)/2
         IVOXEL(1)=(IDUM+1)*2
         IDUM=IVOXEL(2)/2
         IVOXEL(2)=(IDUM+1)*2
      ENDIF
      IF ((LAUENO.GE.8).AND.(LAUENO.LE.12)) THEN
         IDUM=IVOXEL(3)/ILAUE
         IVOXEL(3)=(IDUM+1)*ILAUE
         IDUM=IVOXEL(1)/2
         IVOXEL(1)=(IDUM+1)*2
         IDUM=IVOXEL(2)/2
         IVOXEL(2)=(IDUM+1)*2
      ENDIF
      IF ((LAUENO.GE.13).AND.(LAUENO.LE.14)) THEN
         DO I=1,3
           IDUM=IVOXEL(I)/ILAUE
           IVOXEL(I)=(IDUM+1)*ILAUE
         END DO
      ENDIF
CavdL voxel division should also be compatible with cell metrics
Cavdl this is not said in the manual! MAXIND need not to be compatable with that
CavdL take the maximum value
      IF ((LAUENO.GE.4).AND.(LAUENO.LE.12))THEN
        IVOXEL(1)=MAX(IVOXEL(1),IVOXEL(2))
        IVOXEL(2)=MAX(IVOXEL(1),IVOXEL(2))
      ENDIF
      IF((LAUENO.GE.13).AND.(LAUENO.LE.14))THEN
        IVOXEL(1)=MAX(IVOXEL(1),IVOXEL(2))
        IVOXEL(1)=MAX(IVOXEL(1),IVOXEL(3))
        IVOXEL(2)=MAX(IVOXEL(1),IVOXEL(2))
        IVOXEL(2)=MAX(IVOXEL(2),IVOXEL(3))
        IVOXEL(3)=MAX(IVOXEL(1),IVOXEL(3))
        IVOXEL(3)=MAX(IVOXEL(2),IVOXEL(3))
      ENDIF
c      WRITE(CMON,'('' voxel'',3i5,2i6)')(ivoxel(i),i=1,3),laueno
c     &,ilaue
c        CALL XPRVDU(NCVDU, 1,0)
cavdlsep07 new Superflip version (sep2007) gives the possibility for
c---- voxel calculation inside Superflip. If this works correctly than
c---- the foregoing voxel calculation can be skipped
c---- use AUTO suggested by AvdL April 2011
c      WRITE(NCFPU1, '(''voxel '', 3i6)')(ivoxel(i),i=1,3)
      WRITE(NCFPU1, '(''voxel AUTO'')')
      WRITE(NCFPU1, '(''cell '', 3F7.3, 3F8.3)')
c     1 , (STORE(I),I=L1P1,L1P1+5)
     1  (ACELL(I),I=1,6)
c
       CSPACE(2:ISP)=LOCASE(CSPACE(2:ISP),isp-2+1)
cavdlmay08--- for monoclinic space groups do not export the '1's in the space group symbol
       IF (LAUENO.EQ.2)THEN
           I0=INDEX(CSPACE(1:ISP),'1')
cavdl-- normally I0 should be 3, but it could be that the 1's are not anymore there
           IF ((I0.EQ.3).OR.(I0.EQ.7))THEN
             I0=3
             I1=INDEX(CSPACE(I0+2:ISP),' ')+I0+1
             IDUM=I1-(I0+2)
             CTEMP(1:IDUM)=CSPACE(I0+2:I1-1)
             CSPACE(3:3+IDUM-1)=CTEMP(1:IDUM)
             ISP=3+IDUM-1
           ENDIF
       ENDIF
cavdltest --- do not export spaces in symbol to allow for a clearer comparaison with Superflip
4965   I0=INDEX(CSPACE(1:ISP),' ')
       IF (I0.GE.1)THEN
         CSPACE(I0:ISP-1)=CSPACE(I0+1:ISP)
         ISP=ISP-1
         GOTO 4965
       ENDIF

       WRITE(NCFPU1, '(''spacegroup '', A )') CSPACE(1:ISP)
c
       LATTYP = ((2*IC) -1) * IL
c       write(CMON, '('' LATTYP'',i5)') LATTYP
c       CALL XPRVDU(NCVDU, 1,0)
       IF (LATTYP.GT.0)THEN
         WRITE(NCFPU1, '(''centro yes'')')
       ELSE
         WRITE(NCFPU1, '(''centro no'')')
       ENDIF
cavdlsep07- change to absolute value of lattyp for writing translation vectors for non-centro as well
       WRITE(NCFPU1, '(''centers'')')
       XCEN=0.000000d0
       YCEN=0.000000d0
       ZCEN=0.000000d0
       WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
       IF (ABS(LATTYP).EQ.2)THEN
           XCEN=0.500000d0
           YCEN=0.500000d0
           ZCEN=0.500000d0
           WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
       ENDIF
       IF (ABS(LATTYP).EQ.3)THEN
           XCEN=2.0d0/3.0d0
           YCEN=1.0d0/3.0d0
           ZCEN=1.0d0/3.0d0
           WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
           XCEN=1.0/3.0d0
           YCEN=2.0/3.0d0
           ZCEN=2.0/3.0d0
           WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
       ENDIF
       IF (ABS(LATTYP).EQ.4)THEN
           XCEN=0.500000d0
           YCEN=0.500000d0
           ZCEN=0.000000d0
           WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
           XCEN=0.500000d0
           YCEN=0.000000d0
           ZCEN=0.500000d0
           WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
           XCEN=0.000000d0
           YCEN=0.500000d0
           ZCEN=0.500000d0
           WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
       ENDIF
       IF (ABS(LATTYP).EQ.5)THEN
          XCEN=0.000000d0
          YCEN=0.500000d0
          ZCEN=0.500000d0
          WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
       ENDIF
       IF (ABS(LATTYP).EQ.6)THEN
          XCEN=0.500000d0
          YCEN=0.000000d0
          ZCEN=0.500000d0
          WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
       ENDIF
       IF (ABS(LATTYP).EQ.7)THEN
          XCEN=0.500000d0
          YCEN=0.500000d0
          ZCEN=0.000000d0
          WRITE(NCFPU1, '(3F14.10)')XCEN,YCEN,ZCEN
       ENDIF
       WRITE(NCFPU1, '(''endcenters'')')
      WRITE(NCFPU1, '(''symmetry'')')
       DO 1821 I = L2,M2,MD2
            CALL XSUMOP( STORE(I), STORE(L2P), OPERAT, LENGTH,0)
            DO J=1,2
               IU=INDEX(OPERAT(1:LENGTH),',')
               WRITE(OPERAT(IU:IU),'(A1)')CBLANK
            END DO
            CALL XCONFLIP (OPERAT, LENGTH, DECML, LDEC, DECMT,
     &                     LDEC2, LATTYP)
            WRITE(NCFPU1,'(A)')DECML(1:LDEC)
            IF (LATTYP.GT.0)WRITE(NCFPU1,'(A)')DECMT(1:LDEC2)
1821   CONTINUE
      WRITE(NCFPU1, '(''endsymmetry'')')
cavdlmay08 - the alternative Superflip options (IEFORT.EQ.1) used to be RWEAK=0.00 and RBISO=0.0
cavdlmay08 - change now to normalize local, combined with RWEAK=0.2 and RBISO=0.0
      IF (IEFORT.EQ.1)THEN
         RWEAK=0.2
         RBISO=0.0
      ELSE
        RWEAK=0.2
        RBISO=2.5
      ENDIF
      WRITE(NCFPU1, '(/,''# Keywords for charge flipping'',/,
     &                  ''delta AUTO'',/,
     &                  ''weakratio'',f12.3,/,
     &                  ''Biso  '',f12.3,/,
     &                  ''randomseed AUTO'',/,
     &                  ''searchsymmetry average'',/,
cavdlsep07
     &                  ''derivesymmetry use'')')
     &                    RWEAK,RBISO
cavdlmay05
      IF (IEFORT.EQ.1)WRITE(NCFPU1, '(''normalize local'')')
      WRITE(NCFPU1, '(''# End of keywords for charge flipping'')')
      WRITE(NCFPU1, '(/,''# EDMA-specific keywords'',/,
     &                  ''inputfile sflip.m81'',/,
     &                  ''outputbase sflip'',/,
     &                  ''export sflip.ins'',/,
     &                  ''numberofatoms  0'')')
      IF ( N29 .LE. 0 ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 18300 )
        WRITE ( NCAWU , 18300 )
        WRITE ( CMON, 18300 )
        CALL XPRVDU(NCVDU, 1,0)
18300    FORMAT ( 1X , 'No atom details stored in list 29' )
        GOTO 9900
      ELSE
C----- WRITE ATOM INFORMATION
        IAT=1
        M29 = L29 + (N29-1)*MD29
        M3 = L3 + (N3-1)*MD3
        DO 18390 J = L29, M29, MD29
          DO 18320 K = L3, M3, MD3
           IF (ISTORE(J) .EQ. ISTORE(K)) GOTO 18380
18320      CONTINUE
18380    CONTINUE
        WRITE ( CATOM(IAT) , '(A4)') ISTORE(J)
CAvdLdec06 EDMA wants the second character of an element symbol in lower case
        CALL XCCLWC ( CATOM(IAT)(2:2), CSOURC(2:2))
        WRITE(CATOM(IAT)(2:2),'(A1)')CSOURC(2:2)
        IAT=IAT+1
18390   CONTINUE
       IAT=IAT-1
c       IHYD=0
CAVDLdec06 Don't use hydrogens, because EDMA gets confused
cavdljun08 This is not true anymore, so leave H-atoms
       cdumf='(''composition '',3A4)'
c       DO I=1,IAT
c       IF (IHYD.EQ.1)CATOM(I-1)=CATOM(I)
c       IF (CATOM(I)(1:1).EQ.'H')IHYD=1
c       END DO
c       IF (IHYD.EQ.1)IAT=IAT-1
       WRITE(CDUMF(17:17),'(I1)')IAT
c       write(*,'('' format: '',a21)')cdumf(1:21)
       WRITE(NCFPU1,CDUMF)(CATOM(I),I=1,IAT)
      ENDIF
      WRITE(NCFPU1, '(''maxima all'',/,
     &                ''fullcell no'',/,
     &                ''scale fractional'',/,
cavdljan08 -- change to new default 1.5 sigma
     &                  ''plimit    1.5 sigma '',/,
     &                  ''centerofcharge yes'',/,
     &                  ''chlimit    0.2500'',/,
     &                  ''# End of EDMA-specific keywords'')')
       WRITE(NCFPU1, '(/,''electrons 0.0000'',/)')
       WRITE(NCFPU1, '(''fbegin'')')
       I = 0
       J= 0
       K=0
       FS=0.00000
       S=0.100000
       WRITE(NCFPU1, '(3I5, 2F20.3)') I, J, K, FS, S
C----- LOOP OVER DATA
      IN = 0
18409 CONTINUE
      ISTAT = KLDRNR (IN)
      IF (ISTAT .LT. 0) GOTO 18509
      I = NINT(STORE(M6))
      J = NINT(STORE(M6+1))
      K = NINT(STORE(M6+2))
CDJWMAR99[
      CALL XSQRF(FS, STORE(M6+3), FABS, S, STORE(M6+12))
      IF ((S .LE. ZERO) .AND. (STORE(M6+20) .GT. ZERO))
     1 S = ABS(FS) / STORE(M6+20)
CDJWMAR99]
       WRITE(NCFPU1, '(3I5, 2F15.3)') I, J, K, FS, S
      GOTO 18409
18509 CONTINUE
       WRITE(NCFPU1, '(''endf'')')
       GOTO 8000
CAVDLdec06 --- end superflip input file

C
C
1860  CONTINUE
CAVDLdec06 continue with superflip data
C     LINK TO WRITE OUTPUT FOR PLATON ---------------------
C
C  NCFPU1 will be a SHELX format RES file with atoms.
C  NCFPU2 will be a SHELX HKLF-4 reflection file.
C
C----- OUTPUT A TITLE, FIRST 40 CHARACTERS ONLY
      WRITE(NCFPU1,'(''TITL '',10A4)') (KTITL(I),I=1,10)
      WRITE(NCFPU1, '(''CELL '', F8.5, 3F7.3, 3F8.3)')
     1 STORE(L13DC), (STORE(I),I=L1P1,L1P1+5)
      WRITE(NCFPU1,1810) NINT(T2),
     1 STORE(L31), STORE(L31+6), STORE(L31+11),
     2 RTD*STORE(L31+15),RTD*STORE(L31+18),RTD*STORE(L31+20)
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


1870  CONTINUE
C     LINK TO WRITE OUTPUT FOR CSD ---------------------
C
C  NCFPU1 will be a CSD format input file with 2D structure.
C
      WRITE(NCFPU1,'(''rem '',10A4)') (KTITL(I),I=1,10)
      WRITE(NCFPU1,'(A/A)') 'T1 *CONN','NFRAG 1'
C Work out best plane projection for all non-H
      KNFREE = KSTALL(N5*4)
      NNH = 0
      DO I = 0,N5-1
         IAP = L5 + I * MD5
         IF( (ISTORE(IAP) .NE. KHYD).AND.(ISTORE(IAP) .NE. KDET)) THEN
           CALL XMOVE(STORE(IAP+4),STORE(KNFREE + NNH * 4),4)
           STORE(KNFREE+3+NNH*4) = 1.0
           NNH = NNH + 1
         ENDIF
      ENDDO

      ICENT = KSTALL(3)
      IROOT = KSTALL(3)
      IVECT = KSTALL(9)
      ICSNE = KSTALL(9)
      IWORK = KSTALL(4)
      ICF2BP = KSTALL(9)

      I = KMOLAX(STORE(KNFREE),NNH,4,STORE(ICENT),STORE(IROOT),
     1           STORE(IVECT),STORE(ICSNE),STORE(IWORK))


C CALCULATE MATRIX TRANSFORMING FROM CRYSTAL SYSTEM TO BEST PLANE AND BACK

      CALL XMLTMT (STORE(IVECT),STORE(L1O1),STORE(ICF2BP),3,3,3)


C TRANSLATE CO-ORDINATES TO PLACE CENTROIDS AT ORIGIN.

      CALL XMXTRL (STORE(KNFREE),STORE(ICENT),4,NNH)

C ROTATE GROUPS TO THEIR BEST PLANE AXES.

      CALL XMXRTI (STORE(KNFREE),STORE(ICF2BP),4,NNH)

C Find the min and max x and y values of the best plane:

      XMIN = STORE(KNFREE)
      XMAX = XMIN
      YMIN = STORE(KNFREE+1)
      YMAX = YMIN
      DO I = 0, NNH-1
         XMiN = MIN (XMiN, STORE(KNFREE+I*4))
         XMaX = MAX (XMaX, STORE(KNFREE+I*4))
         YMiN = MIN (YMiN, STORE(KNFREE+1+I*4))
         YMaX = MAX (YMaX, STORE(KNFREE+1+I*4))
      ENDDO
C Apply an offset so that the minimum X and Y is zero.
      SCA = 500.0 / MAX(XMAX-XMIN,YMAX-YMIN)
      STORE(ICENT)   = XMIN - 30.0/SCA
      STORE(ICENT+1) = YMIN - 30.0/SCA
      STORE(ICENT+2) = 0.0
      CALL XMXTRL (STORE(KNFREE),STORE(ICENT),4,NNH)

C Apply a scale so that the maximum X and Y are ~500
      CALL XZEROF (STORE(ICF2BP), 9)
      STORE(ICF2BP) = SCA
      STORE(ICF2BP+4) = SCA
      STORE(ICF2BP+9) = SCA
      CALL XMXRTI (STORE(KNFREE),STORE(ICF2BP),4,NNH)

C Work out number of connected atoms and H atoms...
      INCA = KSTALL(N5)
      INHY = KSTALL(N5)

      CALL XFILL(0,ISTORE(INCA),N5)
      CALL XFILL(0,ISTORE(INHY),N5)

      DO I = 0, N41B-1
         IA1 = ISTORE(L41B+I*MD41B)
         IA2 = ISTORE(L41B+6+I*MD41B)
         IAT1P = L5 + IA1 * MD5
         IAT2P = L5 + IA2 * MD5
         IF((ISTORE(IAT2P).EQ.KHYD) .OR. (ISTORE(IAT2P).EQ.KDET))THEN
            ISTORE(INHY+IA1) = ISTORE(INHY+IA1) + 1
            ISTORE(L41B+I*MD41B) = -1    !Flag not to be included
         ELSE
            ISTORE(INCA+IA1) = ISTORE(INCA+IA1) + 1
         ENDIF
         IF( (ISTORE(IAT1P).EQ.KHYD) .OR. (ISTORE(IAT1P).EQ.KHYD))THEN
            ISTORE(INHY+IA2) = ISTORE(INHY+IA2) + 1
            ISTORE(L41B+I*MD41B) = -1    !Flag not to be included
         ELSE
            ISTORE(INCA+IA2) = ISTORE(INCA+IA2) + 1
         ENDIF
      ENDDO

      J = 0
      DO I = 0, N5-1
        IF( 
     1  (ISTORE(L5+I*MD5).EQ.KHYD).OR.(ISTORE(L5+I*MD5).EQ.KDET))CYCLE
        WRITE(CLAB,'(A,I4)') 'AT',J+1
        CALL XCRAS(CLAB,LLAB)
        WRITE(NCFPU1,'(A,A,2I4,A,2I5)')
     1  CLAB,ISTORE(L5+I*MD5),ISTORE(INCA+I),ISTORE(INHY+I),
     2  ' :XY ',NINT(STORE(KNFREE+J*4)),NINT(STORE(KNFREE+1+J*4))
        J = J + 1
      END DO

      DO I = 0,N41B-1
        IF ( ISTORE(L41B+I*MD41B) .GE. 0 ) THEN
          WRITE(NCFPU1,'(A,3I5)') 'BO ',ISTORE(L41B+I*MD41B)+1,
     1    ISTORE(L41B+6+I*MD41B)+1, ISTORE(L41B+12+I*MD41B)
        END IF
      END DO

      WRITE(NCFPU1,'(A)')'END'
      GOTO 8000


1880  CONTINUE
C     LINK TO WRITE OUTPUT IN MOL2 format ---------------------
C
C  NCFPU1 will be a MOL2 format file.
C
c              WRITE ( CMON,'(A)') 'Start of MOL2 format routine'
c              CALL XPRVDU(NCVDU, 1,0)

C Grow list 5 to a depth of 4 symmetry related atoms. (This will only
C affect polymeric and Z'<1 structures.

       NORIG5 = N5
       CALL GROWFR
c       WRITE (CMON,'(A4,2I6)') 'LkGrown: ',NORIG5,N5
c       CALL XPRVDU(NCVDU,1,0)

c      WRITE ( 99,'(A,3I5)') 'N41B, L41B, MD41B: ',N41B,L41B,MD41B
c      WRITE ( 99,'(A)') 'New bonds(2): Bonding now looks like this:'
c      DO I = 0,N41B-1
c        IF ( ISTORE(L41B+I*MD41B) .GE. 0 ) THEN
c          WRITE(99,'(2I5)')
c     1    ISTORE(L41B+I*MD41B)+1,ISTORE(L41B+6+I*MD41B)+1
c        END IF
c      END DO


C Count the number of bonds (excluding across sym ops):
      IBI = 0
      DO I = 0,N41B-1
        M41B = L41B+I*MD41B
        IF ( ISTORE(L41B+I*MD41B) .GE. 0 ) THEN
         IF ( ( ISTORE(M41B+1) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+2) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+3) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+4) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+5) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+7) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+8) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+9) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+10) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+11) .EQ. 0 ) ) THEN
          IBI = IBI + 1
         END IF
        END IF
      END DO


C Write the header

      WRITE(NCFPU1,'(//,''@<TRIPOS>MOLECULE'',/,10A4)')(KTITL(I),I=1,10)
      WRITE(NCFPU1,'(2I5)') N5, IBI
      WRITE(NCFPU1,'(''SMALL'',/,''NO CHARGES'',/,
     1               ''****'',/,''No Comment'',/,''@<TRIPOS>ATOM'')')

C Write out the atoms

      DO I = 0, N5-1
        CALL XMLTTM(STORE(L1O1),STORE(L5+I*MD5+4),ANGV,3,3,1)
        WRITE(CLAB,'(A,I4)') ISTORE(L5+I*MD5),NINT(STORE(L5+I*MD5+1))
        CALL XCRAS(CLAB,LLAB)
        WRITE(CLAB2,'(2A)') ISTORE(L5+I*MD5),'.1'
        CALL XCRAS(CLAB2,LLAB2)
        WRITE(NCFPU1,'(I4,1X,A,3F8.4,1X,A,'' <1>'')')
     1  I+1, CLAB, ANGV, CLAB2
      END DO

C Write out the bonds

      WRITE(NCFPU1,'(''@<TRIPOS>BOND'')')

      IBI = 0
      DO I = 0,N41B-1
        M41B = L41B+I*MD41B
        IBT = MAX(1,ISTORE(L41B+12+I*MD41B))
        IBT = MIN(IBT,9)
        IF ( ISTORE(L41B+I*MD41B) .GE. 0 ) THEN
         IF ( ( ISTORE(M41B+1) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+2) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+3) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+4) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+5) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+7) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+8) .EQ. 1 ) .AND.
     1        ( ISTORE(M41B+9) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+10) .EQ. 0 ) .AND.
     1        ( ISTORE(M41B+11) .EQ. 0 ) ) THEN
          IBI = IBI + 1
          WRITE(NCFPU1,'(3I5,1X,A)') IBI,ISTORE(L41B+I*MD41B)+1,
     1    ISTORE(L41B+6+I*MD41B)+1, CBONDS(IBT)
         END IF
        END IF
      END DO


c      JDISTS = NFL
c
c      DO I = 0,ININ5-1
c           M5A = L5+I*MD5
c           M5 = L5
c           JT = 14
c           NFL = JDISTS
c           JS = JDISTS
c
c           IPART = 1
c           K = KDIST4(JS,JT,0,IPART)
c
c           NFL = JDISTS
c
cC Go through results
c           DO J=JDISTS,JDISTS+(K-1)*14,14
c             I5 = ISTORE(J)
c
c               WRITE(CMON,'(2A,I4,2A,I4)')
c     1      'QF Piv:',  ISTORE(M5A),NINT(STORE(M5A+1)),
c     1      'Bonded:',  ISTORE(I5),NINT(STORE(I5+1))
c               CALL XPRVDU(NCVDU, 1,0)
c           END DO
c      END DO



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
      IF (ILINK .EQ. 5) THEN                                  !SIR88
C----- WRITE THIS LINE FOR GRAPHICAL RUN
        WRITE(NCFPU1, '(''%WINDOW 960 700 '')')
C----- SET UP THE FILE SPECIFICATIONS
        WRITE(NCFPU1, '(''%FILE sirdata.bin  sir.cry '')')
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
C
C
      ELSE IF 
     1 ((ILINK .EQ. 6) .OR. (ILINK .EQ. 7) .OR. (ILINK .EQ. 12)
     2  .OR. (ILINK .EQ. 13)) THEN
C       SIR92, SIR97, SIR02
C
C----- SET UP THE FILE SPECIFICATIONS
        WRITE(NCFPU1, '(''%Window '')')
        if (ilink .eq. 12) then
          WRITE(NCFPU1, '(''%structure  sir02 ''/''%init'', / )')
        else if (ilink .eq. 13) then
          WRITE(NCFPU1, '(''%structure  sir11 '')')
        else
          WRITE(NCFPU1, '(''%structure  sir9X ''''%init'', / )')
        endif
C----- OUTPUT A TITLE, FIRST 20 WORDS ONLY
        WRITE(NCFPU1, '(''%job '',20A4)')
     1 (KTITL(I),I=1,20)
cdjw1999
        WRITE(NCFPU1, '(''%data '',/,8X,''cell '', 3F7.3, 3F8.3)')
     1 (STORE(I),I=L1P1,L1P1+5)
       WRITE(NCFPU1, '(8X,''space '', A )') CSPACE(1:ISP)
       WRITE ( NCFPU1 , '(8X,''content '', A)' ) CL29(1:I29)
CDJWJAN08
      IF ((ILINK .EQ. 12).or.(ILINK .EQ. 13))
     1    WRITE(NCFPU1,'(8X,''fobs'')')
      if (ilink .NE. 13) WRITE(NCFPU1,1945)
1945  FORMAT( 8X,'reflection follow')
      write(ncfpu1,19400)
19400 format( 8X, 'format (3i4, f10.3, f7.2)')
C
C
       CARROW = '>'
       IF (ILINK .EQ. 6) THEN
         IF (IEFORT .EQ. 1) THEN
           WRITE(NCFPU1,1941) CARROW,CARROW,CARROW,CARROW,
     1     CARROW,CARROW,CARROW
         ELSE IF (IEFORT .EQ. 2) then
           WRITE(NCFPU1, 1941) ' ', ' ',' ',
     1     ' ',' ',' ',' '
         ELSE IF (IEFORT .EQ. 3) THEN
           WRITE(NCFPU1, 1944)
         ELSE IF (IEFORT .EQ. 5) THEN
           WRITE(NCFPU1, 1942) ' '
         ELSE IF (IEFORT .EQ. 6) THEN
           WRITE(NCFPU1, 1943) ' '
         ENDIF
       ELSE IF (ILINK .EQ. 7) THEN
         WRITE(NCFPU1, 1941) ' ', CARROW,' ',
     1   ' ',' ',carrow,' '
         write(ncfpu1,'(''%menu''/''  crystals sir97.cry'')')
       ELSE IF (ILINK .EQ. 12) THEN
         WRITE(NCFPU1, 1941) ' ', CARROW,CARROW,
     1   ' ',' ',carrow,' '
         write(ncfpu1,'(''%menu''/''  crystals sir02.cry'')')

       ELSE IF (ILINK .EQ. 13) THEN
        if(iefort .eq.1) then
         WRITE(NCFPU1, 19411)
19411 format('    reflections sir11.hkl'/
     1'>   rhomax 0.33'/
     2'>   bfac 4.'/ 
     3'%phase'/
     4'   vld'/
     5'>   tangent')
        else if (iefort.eq.2) then
         WRITE(NCFPU1, 19412)
19412 format('    reflections sir11.hkl'/
     1'>   rhomax 0.33'/
     2'>   bfac 4.'/ 
     3'%phase'/
     4'    vld')
        else if (iefort.eq.5) then
         WRITE(NCFPU1, 19413)
19413 format('    reflections sir11.hkl'/
     1'>   rhomax 0.33'/
     2'>   bfac 4.'/ 
     2'    size m '/
     2'    resm 0.9'/
     3'%phase'/
     4'    tangent')

        endif
        write(ncfpu1,'(''  crystals sir11.cry'')')
       ENDIF
      if (ilink .eq. 13) then
       WRITE(NCFPU1, '(''%continue'')' )
       WRITE(NCFPU1, '(''%end'')' )
      else
       WRITE(NCFPU1, '(''%continue'')' )
      endif
C
C
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
     4 A,'%seminv'/
     5 '%invariant'/
     6 '%phase'/
     7 '  symbols 12'/
     8 '%fourier'/
     9 '>  recycle  n')
1943  FORMAT('>  rhomax 0.33'/
     1 '%normal'/
     2 '  pseudo'/
     3 '>  bfac 4.'/
     4 A,'%seminv'/
     5 '%invariant'/
     5 '  cochran'/
     6 '%phase'/
     7 '  random'/
     8 '  maxtrials 2000'/
     8 '  seed 8823'/
     8 '%fourier'/
     9 '>  recycle  n')
1944  FORMAT(
     1 '%normal'/
     8 '%fourier'/
     9 'fragment frag.dat')
C
      IF ((ILINK .EQ. 6) .AND. (IEFORT .EQ. 3 )) THEN
C----- OUTPUT ATOMS FOR SUPERFLIP RECYCLING
      IF (KHUNTR (5,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL05
      M5=L5
      DO 1949, I=1,N5
            WRITE(NCFPU2,'(A4,3F12.6)') ISTORE(M5), 
     1      STORE(M5+4), STORE(M5+5), STORE(M5+6)
            M5 = M5+MD5
1949  CONTINUE
      ENDIF
C
      NHKLI = NCFPU1
      IF (ILINK.EQ.13) NHKLI = NCFPU2
c
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
      if (store(m6+12) .ge. zero) then
            s = store(m6+12)
      else
            IF (STORE(M6+20) .LE. ZERO) THEN
            S = 0.0
            ELSE
            S = abs(FS / STORE(M6+20))
            ENDIF
      endif
      IF (ILINK .EQ. 5) THEN
         JCODE = 0
         IF (KALLOW(IALLOW) .LT. 0) JCODE = 1
         WRITE(NCFPU1,'( 3I4, F10.3, I2)') I, J, K, FS, JCODE
      ELSE IF ((ILINK .EQ. 6) .AND. (IMETHD .EQ. 1)) THEN
         IF (KALLOW(IALLOW) .GE. 0) THEN
           WRITE(NCFPU1,'(3I4, F10.3, F7.2)') I, J, K, FS, S
         END IF
      ELSE
         WRITE(NHKLI,'(3I4, F10.3, F7.2)') I, J, K, FS, S
      ENDIF
      GOTO 1950
1960  CONTINUE
        IF (ILINK .NE. 13)   WRITE(NCFPU1,1961)
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
      CALL XLNKMN(ITYP06)
      GOTO 9000
C
8000  CONTINUE
C----- TIDY UP
C
C     SNOOPI, CAMERON, SHELXS86, MULTAN, SIRxx
      GOTO (8010,8020,8030,9000,8030,8030,8030,8040,8030,8030,8030,
     1 8030,8030),ILINK
      GOTO 9100
C
8010  CONTINUE
C----- SNOOPI - 2 FILES TO CLOSE AND START PROGRAM
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)
C -- SPAWN SNOOPI
#if defined(_PPC_)
CS***
      CALL stsnpi
CE***
#endif
      CALL XDETCH ( '$ @ CRSNOOPI:SNOOPI' )
      GOTO 9000
C
8020  CONTINUE
C----- CAMERON - 2 FILES TO CLOSE AND START PROGRAM
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)
C - Only GID, GIL and DOS support Cameron's graphics.
#if !defined(_DOS_) && !defined(_GID_) && !defined(_GIL_) && !defined(_WXS_)  && !defined(_MAC_) && !defined(_INW_)
        GOTO 9000 !Skip this Cameron part.

C -- START CAMERON - ONLY TWO ELEMENT OF STORE (CURRENTLY A DUMMY) USED
C      IF (ISSTML .EQ. 4) THEN
#endif
        LCLOSE = .FALSE.
C - Only GID needs funny text strings to initialise the graphics.
C - Could move these to ZCAMER.

#if defined(_GID_) || defined(_GIL_) || defined(_WXS_)  || defined(_MAC_) || defined(_INW_)
        WRITE(CHARTC,'(A)') '^^CH CHART _CAMERONCHART'
        CALL ZMORE(CHARTC,0)
        WRITE(CHARTC,'(A)') '^^CH ATTACH _CAMERONVIEW'
        CALL ZMORE(CHARTC,0)
        WRITE(CHARTC,'(A)') '^^CW'
        CALL ZMORE(CHARTC,0)
#endif
#if defined(_GID_) || defined(_GIL_)  || defined(_MAC_)
        CALL ZCAMER ( 1, 0 , 0 , 0)
#endif
#if defined(_DOS_) || defined(_WXS_) || defined(_INW_)
        CALL ZCAMER ( 1, 0 , 0 , 0)

#endif
8025  CONTINUE
        IF (LCLOSE) THEN
            GOTO 9000 !Cameron has shutdown
        ENDIF
        IIIIIN = 1
        ISTAT = KRDREC(IIIIIN)
        WRITE(CHRBUF,'(256A1)')LCMAGE
#if defined(_GID_) || defined(_GIL_)  || defined(_MAC_)
         CALL ZCONTR
#endif
#if defined(_DOS_) || defined(_WXS_)|| defined(_INW_)
         CALL ZCONTR
#endif
      GOTO 8025

8030  CONTINUE
C----- ENSURE THE UNITS ARE CLOSED
      I = KFLCLS(NCFPU1)
      I = KFLCLS(NCFPU2)

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
#if defined(_PPC_)
      CALL stcrys
#endif
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
C      ILINK - TYPE OF FOREIGN PROGRAM
      CHARACTER *256 CPATH
CDJWJAN08
      PARAMETER (NFILE = 17)
      CHARACTER *16 CFILE(NFILE)
C
      DIMENSION JFRN(4,2),  LFILE(NFILE)
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      DATA CFILE / 
     1  'snoopi.ini' ,
     2  'snoopi.l5' ,
     3  'shelxs.ins' ,
     4  'sirdata.dat',
     5  'cameron.ini' ,
     6  'cameron.l5i',
     7  'sir92.ini',
     8  'FRAG.DAT', 
     9  'sir97.ini',
     C  'platon.res',
     1  'platon.hkl',
     2  'crystals.con',
     3  'crystals.mol2' ,
     4  'sflip.inflip',
     5  'sir02.sir',
     6  'sir11.sir' ,
     7  'sir11.hkl' /
C
      DATA LFILE / 10,  9,  10,  11, 11, 11, 9, 8, 9, 10, 10, 12, 13 ,
     1             12,  9,  9,   9  /
C
#if defined (_HOL_)
      DATA JFRN /1HF , 1HR , 1HN , 1H1 ,
     1           1HF , 1HR , 1HN , 1H2 /
#else
      DATA JFRN /'F', 'R', 'N', '1',
     1           'F', 'R', 'N', '2'/
#endif
C
100   CONTINUE
      JLOOP = 1
      KLOOP = 1
      KLNKIO = -1
      LPATH  = KPATH( CPATH)
C     SNOOPI, CAMERON, SHELXS86, MULTAN, SIR88, SIR92, SIR97, PLATON, 
c     CSD, MOL2, superflip, SIR02, SIR11
C
C----- OPEN THE FIRST FILE
      JFILE = 1

      GOTO ( 110, 120, 130, 140, 150, 160, 170, 180, 190, 195 , 196,
     & 200, 210, 9900), ILINK

C
110   CONTINUE
c      snoopi
      IFILE = 1
c      and 2
      KLOOP = 2
      GOTO 1000
120   CONTINUE
c      cameron
      IFILE = 5
c      and 6
      KLOOP = 2
      GOTO 1000
130   CONTINUE
c      shelxs86
      IFILE=3
      GOTO 1000
140   CONTINUE
c      multan
      IFILE=0
      GOTO 9000
150   CONTINUE
c      sir88
      IFILE=4
      GOTO 1000
160   CONTINUE
c      sir92
      KLOOP = 2
      IFILE=7
c      and 8
      GOTO 1000
170   CONTINUE
c      sir97
      IFILE=9
      GOTO 1000
180   CONTINUE
c      platon
      IFILE=10
c      and 11
      KLOOP = 2
      GOTO 1000
190   CONTINUE
c     CSD
      IFILE=12
      GOTO 1000
195   CONTINUE
c       MOL2
      IFILE=13
      GOTO 1000
Cavdldec06 added superflip file
196   CONTINUE
c       superflip
      IFILE=14
      GOTO 1000
200   CONTINUE
C sir02 djwJAN08
      IFILE=15
      GOTO 1000
210   CONTINUE
C sir11 djwsep11
      IFILE=16
c      and 17
      KLOOP = 2
      GOTO 1000
C
C
1000  CONTINUE

      CALL XRDOPN ( 5 , JFRN(1,JFILE) ,

#if !defined(_GIL_) && !defined(_WXS_) && !defined(_MAC_)&& !defined(_INW_)

     1 CPATH(1:LPATH)// CFILE(IFILE)(1:LFILE(IFILE)),
     2 LPATH+LFILE(IFILE))

#else

     1 CFILE(IFILE)(1:LFILE(IFILE)),
     2 LFILE(IFILE))

#endif

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
cCODE FOR XLNKCM
c      SUBROUTINE XLNKCM
cC
cC     THIS SUBROUTINE READS INFOMATION FROM LISTS 1,2 & 5
cC     AND PREPARES DATRA FOR CAMERON
cC----- FORMAT IN 'STORE' IS:
cC      0   NUMBER OF ITEMS IN HEADER
cC      1-6 CELL, ANGSTROM AND RADIANS
cC      7   CENTRED FLAG 0.0 = ACENTRIC
cC      8   No OF SYMMETRY MATRICES
cC      9   NO OF CENTRING VECTORS
cC      10  START OF ATOMS
cC      11  NO OF ATOMS
cC      12  NO OF ITEMS PER ATOM
cC
cC      ..      SYMMETRY MATRICES 3X4, BY COLUMNS
cC      ..      CENTRING VECTORS, AS ROWS
cC      ..      ATOMS (TYPE, SERIAL,OCC, UISO,X'S,U'S, SPARE)
cC
c      DIMENSION LISTS(3)
cC
c\ISTORE
cC
c\STORE
c\XUNITS
c\XSSVAL
c\XCONST
c\XLST01
c\XLST02
c\XLST05
c\XOPVAL
c\XERVAL
c\XIOBUF
cC
c\QSTORE
cC
c      DATA NLISTS / 3 /
c      DATA LISTS(1) / 1 / , LISTS(2) / 2 / , LISTS(3) / 5 /
cC
cC -- CHECK THAT OPERATION IS BEING PERFORMED IN INTERACTIVE MODE
c      IF ( IQUN .NE. JQUN ) GO TO 9920
cC
cC--FIND OUT WHICH LISTS EXIST
c      IERROR = 1
c      DO 1300 N=1 , NLISTS
c        LSTNUM = LISTS(N)
c        IF (  KEXIST ( LSTNUM )  ) 1210 , 1200 , 1220
c1200    CONTINUE
c        WRITE ( NCAWU , 1205 ) LSTNUM
c        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1205) LSTNUM
c        WRITE ( CMON, 1205 ) LSTNUM
c        CALL XPRVDU(NCVDU, 1,0)
c1205    FORMAT ( 1X , 'List ' , I2 , ' contains errors')
c        IERROR = -1
c        GOTO 1300
c1210    CONTINUE
c        WRITE ( NCAWU , 1215 ) LSTNUM
c        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1215) LSTNUM
c        WRITE ( CMON, 1215 ) LSTNUM
c        CALL XPRVDU(NCVDU, 1,0)
c1215    FORMAT ( 1X , 'List' , I2 , ' does not exist' )
c        IERROR = -1
c        GOTO 1300
c1220    CONTINUE
c1300  CONTINUE
c      IF ( IERROR .LE. 0 ) GOTO 9900
cC
cC
cC -- LOAD LISTS
cC
c      CALL XFAL01
c      CALL XFAL02
cC
cC----- NO OF ITMES IN HEADER
c      NITEM = 13
c      ISTART = KSTALL(NITEM)
c      STORE(ISTART) = FLOAT(NITEM)
cC----- CELL
c      CALL XMOVE (STORE(L1P1), STORE(ISTART+1), 6)
cC----- CONVERT TO DEGREES
c      STORE(ISTART+3) = RTD * STORE(ISTART+4)
c      STORE(ISTART+4) = RTD * STORE(ISTART+5)
c      STORE(ISTART+5) = RTD * STORE(ISTART+6)
cC----- CENTRIC/ACENTRIC
c      STORE(ISTART+7) = STORE(L2C)
cC----- NO OF MATRICES
c      STORE(ISTART+8) = N2
cC----- NO OF CENTRING VECTORS
c      STORE(ISTART+9) = N2P
cC
cC
cC----- THE SYMMETRY MATRICES AND VECTORS
c      M2 = L2 + (N2-1)*MD2
c      DO 1400 IND2=L2,M2,MD2
c      I = KSTALL(MD2)
c      CALL XMOVE (STORE(IND2), STORE(I), MD2)
c1400  CONTINUE
cC----- THE CENTRING VECTORS
c      DO 1500 IND1=L2P,M2P,3
c      I = KSTALL(3)
c      CALL XMOVE (STORE(IND1), STORE(I), 3)
c1500  CONTINUE
cC
cC----- LOAD LIST 5
cC      CALL XFAL05
c      LN5 = 1
c      LN5 = KTYP05(LN5)
c      CALL XLDR05(LN5)
cC
c      STORE(ISTART+10) = FLOAT (L5)
c      STORE(ISTART+11) = FLOAT (N5)
c      STORE(ISTART+12 ) = FLOAT (MD5)
cC
cC---- INITIALISATION
c      CALL XCAMER( 1, ISTART, IEND, -1)
cC----- REAL WORK
c      CALL XCAMER( 2, ISTART, IEND, -1)
cC
cC----- HAS CAMERON CHANGED THE ATOMS?
c      NN5 = NINT(STORE(ISTART+11))
c      IF (NN5 .LT. 0) THEN
c        N5 = -NN5
c        N = N5
c        NEW = 1
c        CALL XSTR05(LN5, 0, NEW)
c        IF ( ISSPRT .EQ. 0) WRITE(NCWU, 1520) N5
c        WRITE ( NCAWU, 1520 ) N5
c        WRITE ( CMON, 1520 ) N5
c        CALL XPRVDU(NCVDU, 1,0)
c1520    FORMAT (' LIST 5 now contains ', I6, ' atoms')
c      ENDIF
c      RETURN
cC
cC
c9900  CONTINUE
cC -- ERRORS DETECTED
c      CALL XERHND ( IERWRN )
c      RETURN
cC
c9920  CONTINUE
c      IF (ISSPRT .EQ. 0) THEN
c      WRITE ( NCWU , 9925 )
c      ENDIF
c      WRITE ( NCAWU , 9925 )
c      WRITE ( CMON, 9925 )
c      CALL XPRVDU(NCVDU, 1,0)
c9925  FORMAT ( 1X , 'CAMERON can only be used in interactive mode' )
c      GO TO 9900
cC
c      END

cCODE FOR XCAMER
c      SUBROUTINE XCAMER( ICALL, ISTART, IEND, IDEV)
c\XUNITS
c\STORE
c\XIOBUF
c      IF (ICALL .GE. 2) RETURN
cC----- DUMMY ROUTINE FOR INTERNAL LINK TO CAMERON
c      WRITE ( CMON, '('' Test link to CAMERON - not used now '')')
c      CALL XPRVDU(NCEROR, 1,0)
c      WRITE (NCAWU, '(1X,6F8.2)') (STORE(I), I=ISTART,ISTART+5)
c      WRITE (NCAWU, '(1X,6I6)') (NINT(STORE(I)), I=ISTART+6, ISTART+11)
cC----- START OF GOODIES
c      IBASE = ISTART + NINT(STORE(ISTART))
cC----- SYMMETRY MATRICES
c      J = IBASE
c      L = 12
c      K = J+NINT(STORE(ISTART+8)-1) * L
c      WRITE(NCAWU,'(1X,'' Matrices '')')
c      DO 1000 I = J,K,L
c        WRITE(NCAWU,'(1X,3F8.2)') (STORE(M), M=I,I+L-1)
c        WRITE(NCAWU, '(1X)')
c1000  CONTINUE
cC
cC----- CENTRING VECTORS
c      J = J +12*NINT(STORE(ISTART+8))
c      L = 3
c      K = J+NINT(STORE(ISTART+9)-1) * L
c      WRITE(NCAWU,'(1X,'' Vectors '')')
c      DO 1100 I = J,K,L
c        WRITE(NCAWU,'(1X,3F8.2)') (STORE(M), M=I,I+L-1)
c        WRITE(NCAWU, '(1X)')
c1100  CONTINUE
cC
cC----- ATOMS
c      J = NINT(STORE(ISTART+10))
c      L = NINT(STORE(ISTART+12))
c      K = J+NINT(STORE(ISTART+11)-1) * L
c      WRITE(NCAWU,'(1X,I6, '' Atoms '')') NINT(STORE(ISTART+11))
c      DO 1200 I = J,K,L
c        WRITE(NCAWU,'(1X,A4,F8.0,5F8.4/13X,7F8.4)')
c     1 (STORE(M), M=I,I+L-1)
c1200  CONTINUE
cC^^^^^ a patch to test re-writing
c      STORE(ISTART+11) = -STORE(ISTART+11)
c      RETURN
c      END

C---- OLD LINK TO SHELX REMOVED
C   *XLNKSX
C
C
C
CODE FOR XLNKMN
      SUBROUTINE XLNKMN(ITYP06)
C
C     LINK TO WRITE OUTPUT FOR MULTAN84
C
      CHARACTER *32 OPERAT, CPATH
      CHARACTER *1  LATTYP(7)
C
C
      INCLUDE 'ISTORE.INC'
C
      DIMENSION LISTS( 6 ), JFRN1(4), JFRN2(4)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCOMPD.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA NLISTS / 6 /
      DATA LISTS(1) / 1 /, LISTS(2) / 2 /, LISTS(3) / 3 /,
     1     LISTS(4) / 6 /, LISTS(5) / 13/, LISTS(6) / 29/
      DATA LATTYP /'P','I','R','F','A','B','C'/
#if defined (_HOL_)
      DATA JFRN1 /1HF , 1HR , 1HN , 1H1 /
      DATA JFRN2 /1HF , 1HR , 1HN , 1H2 /
#else
      DATA JFRN1 /'F', 'R', 'N', '1'/
      DATA JFRN2 /'F', 'R', 'N', '2'/
#endif

C
C      IULN6 = ITYP06
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
cdjwsep07 check the type of reflections
        if (lstnum .eq. 6) then
          IULN6 = KTYP06(ITYP06)
        endif
c
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
      CALL XFAL06(IULN6,0)
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
      IF (KALLOW(IALLOW) .LT. 0) THEN
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

CODE FOR GROWFR
      SUBROUTINE GROWFR
C To be called from a routine that has L5 already loaded, and doesn't
C care if we extend it. L40 should also be loaded as bonds will be calculated.
      CHARACTER *18 CLAB, CLAB2
      INCLUDE 'XLST05.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'QSTORE.INC'

      LLATVC = LATVC
      NNATVC = NATVC

      JNEWAT = 0
      JBASAT = NFL
      ININ5 = N5
      L12 = NOWT   ! KDIST4 mustn't use L12.



C Allocate space at top of store for whole of L41B three times over,
C plus at least space for twenty more bonds.
       L41MAX = LFL
       L41BSV = KCHLFL( ( 20 + ( N41B * 3 ) ) * MD41B )
       N41BSV = 0
       L41BEX = L41BSV

C Copy L41B, but remove sym bonds:
       DO M41B = L41B, L41B + MD41B * ( N41B - 1 )
         IF (( ISTORE(M41B+7) .NE. 1 ) .OR.
     1       ( ISTORE(M41B+8) .NE. 1 ) .OR.
     2       ( ISTORE(M41B+9) .NE. 0 ) .OR.
     3       ( ISTORE(M41B+10).NE. 0 ) .OR.
     4       ( ISTORE(M41B+11).NE. 0 ) ) CYCLE
         IF (( ISTORE(M41B+1) .NE. 1 ) .OR.
     1       ( ISTORE(M41B+2) .NE. 1 ) .OR.
     2       ( ISTORE(M41B+3) .NE. 0 ) .OR.
     3       ( ISTORE(M41B+4) .NE. 0 ) .OR.
     4       ( ISTORE(M41B+5) .NE. 0 ) ) CYCLE
         CALL XMOVE( STORE(M41B), STORE(L41BEX), MD41B )
         L41BEX = L41BEX + MD41B
         N41BSV = N41BSV + 1
       END DO


C Put L5 index into SPARE.
       DO I = 0, N5-1
        M5 = L5 + MD5 * I
        ISTORE(M5+13) = I
       END DO

c      write(99,'(A,2I8)')'N41B, N41BSV: ', N41B, N41BSV

c      WRITE ( CMON,'(A)') 'Seeking bonds across sym ops.'
c      CALL XPRVDU(NCVDU, 1,0)  
c
c      WRITE ( CMON,'(A)') 'Bonding originally looks like this:'
c      CALL XPRVDU(NCVDU, 1,0)
c      DO I = 0,N41B-1
c        IF ( ISTORE(L41B+I*MD41B) .GE. 0 ) THEN
c          WRITE(CMON,'(2I5)')
c     1    ISTORE(L41B+I*MD41B)+1,ISTORE(L41B+6+I*MD41B)+1
c          CALL XPRVDU(NCVDU, 1,0)
c        END IF
c      END DO

      TOPSER = 0
 
      DO I = 0,N5-1             !Find the highest serial number.
        M5A = L5+I*MD5
        TOPSER = MAX(TOPSER,STORE(M5A+1))
      END DO
      TOPSER = TOPSER + 3


      DO I = 0,N5-1            !Loop over atoms. Each atom becomes pivot.

        M5A = L5+I*MD5
        M5 = L5
        JT = 14


        JDISTS = JBASAT + JNEWAT*MD5 + 1400   !Leave space for 100 atoms.
        NFL = JDISTS
        JS = JDISTS


        IPART = 1  ! If disorder, output set 1 (lowest part # of each group).
        JATVC = 0  ! There is no atom vector.
        K = KDIST4(JS,JT,JATVC,IPART)

        NFL = JDISTS

C Go through results (K is -ve if stack overflow: ignore)
        DO J=JDISTS,JDISTS+(K-1)*14,14
          I5 = ISTORE(J)
C Find entries where sym ops are applied
          IF ((ISTORE(J+2).NE.1).OR.(ISTORE(J+3).NE.1).OR.
     1        (ISTORE(J+4).NE.0).OR.(ISTORE(J+5).NE.0).OR.
     1                              (ISTORE(J+6).NE.0)    ) THEN
              ICOINC = 0
              DO K = 0,N5-1
                IF ( ABS(STORE(J+7)-STORE(L5+K*MD5+4))
     1              +ABS(STORE(J+8)-STORE(L5+K*MD5+5))
     1              +ABS(STORE(J+9)-STORE(L5+K*MD5+6)).LT. 0.0001)
     1               THEN
                  ICOINC = -K-1
                  EXIT
                END IF
              END DO
              DO K = 0,JNEWAT-1
                IF ( ABS(STORE(J+7)-STORE(JBASAT+K*MD5+4))
     1              +ABS(STORE(J+8)-STORE(JBASAT+K*MD5+5))
     1              +ABS(STORE(J+9)-STORE(JBASAT+K*MD5+6)).LT.0.0001)
     1               THEN
                  ICOINC = K+1
                  EXIT
                END IF
              END DO
              IF ( ICOINC .EQ. 0 ) THEN

C Add entry to our "new L5 in memory". Copy original atom:
                CALL XMOVE (STORE(I5), STORE(JBASAT+MD5*JNEWAT), MD5)
C Change its coords:
                CALL XMOVE (STORE(J+7),STORE(JBASAT+MD5*JNEWAT+4), 3)
C Change its serial:                
                STORE(JBASAT+1+MD5*JNEWAT)=TOPSER

C Find new bond I5 to M5A in L41. Add new entry
C for this atom onto the end.


                IF ( L41BEX + MD41B .LE. L41MAX  ) THEN
                 ISVI1 = ISTORE(I5+13)  ! Index of found atom
                 ISVI2 = ISTORE(M5A+13) ! Index of pivot atom

                 write (CMON,'(A,4I8)') 'Checking for ',ISVI1,ISVI2,
     1           (I5-L5)/MD5,I
                 CALL XPRVDU(NCVDU,1,0)

                 DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B
                  I51 = ISTORE(M41B)
                  I52 = ISTORE(M41B+6)
                  IF ( ( ISVI1.NE.I51 ) .AND. ( ISVI2.NE.I51 ) ) CYCLE
                  IF ( ( ISVI1.NE.I52 ) .AND. ( ISVI2.NE.I52 ) ) CYCLE



                  CALL XMOVE(STORE(M41B),STORE(L41BEX),MD41B)


                 write (CMON,'(A,12I5)') 'Made it ',
     1 (ISTORE(L41BEX+NN),NN=0,11)
                 CALL XPRVDU(NCVDU,1,0)


C Remove the symmetry operator from the bond

                  CALL XMOVE(STORE(L41BEX+7),STORE(L41BEX+1),5)

                 write (CMON,'(A,12I5)') 'Made it ',
     1 (ISTORE(L41BEX+NN),NN=0,11)
                 CALL XPRVDU(NCVDU,1,0)
                  

                  IF ( ISTORE(L41BEX) .EQ. ISVI1 ) THEN
                    ISTORE(L41BEX) = N5 + JNEWAT
                    ISTORE(L41BEX+6) = I
                  ELSE
                    ISTORE(L41BEX+6) = N5 + JNEWAT
                    ISTORE(L41BEX) = I
                  END IF
                  L41BEX = L41BEX + MD41B
                  N41BSV = N41BSV + 1
      write(CMON,'(A,2I15)')'new bond (1) ', I, N5+JNEWAT
      CALL XPRVDU(NCVDU,1,0)
                  EXIT
                 END DO
                END IF

                TOPSER=TOPSER+1
                JNEWAT = JNEWAT + 1

                WRITE ( CMON,'(2A,6I4,3F9.3)')'new atom (1) ',
     1                 ISTORE(I5),NINT(STORE(I5+1)),
     1                 (ISTORE(J+L),L=2,6),
     1                 (STORE(J+L),L=7,9)  
                CALL XPRVDU(NCVDU, 1,0)

              ELSE

C The atom is coincident, but check if a bond exists already.
C Could be a bond looping back.
                 ISVI1 = N5+ICOINC-1     ! Index of the coincident atom
                 IF ( ICOINC .LT. 0 ) ISVI1 = -ICOINC-1
                 ISVI2 = I            ! Index of pivot atom
                 IBDEXI = 0
                 DO M41SV = L41BSV, L41BSV+(N41BSV-1)*MD41B, MD41B
                  I51 = ISTORE(M41SV)
                  I52 = ISTORE(M41SV+6)
                  IF ( ( ISVI1.NE.I51 ) .AND. ( ISVI2.NE.I51 ) ) CYCLE
                  IF ( ( ISVI1.NE.I52 ) .AND. ( ISVI2.NE.I52 ) ) CYCLE
C                  IF ( ISVI1 .EQ. ISVI2 ) CYCLE
                  IBDEXI = 1
                 END DO
                 IF ( IBDEXI .EQ. 0 ) THEN
C Now find original index of these two atoms.
                  IF ( ISVI1 .GE. N5 ) THEN
                     IORG1 = ISTORE(JBASAT+(ISVI1-N5)*MD5+13)
                  ELSE
                     IORG1 = ISTORE(L5+ISVI1*MD5+13)
                  END IF
                  IORG2 = ISTORE(L5+ISVI2*MD5+13)
C Find bond IORG1 to IORG2 in 'safe' bit of L41. Add new entry for this
C bond onto the end.
                  IF ( L41BEX + MD41B .LE. L41MAX ) THEN
                    DO M41SV = L41BSV, L41BSV+(N41BSV-1)*MD41B, MD41B
                     I51 = ISTORE(M41SV)
                     I52 = ISTORE(M41SV+6)
c                     write (99,'(A,2I6)') '3:Test ',I51,I52
                     IF ( ( IORG1.NE.I51 ) .AND. ( IORG2.NE.I51 ) )CYCLE
                     IF ( ( IORG1.NE.I52 ) .AND. ( IORG2.NE.I52 ) )CYCLE
C                     IF ( ISVI1 .EQ. ISVI2 ) CYCLE
c                     write (99,'(A)') '3:Made it'
                     CALL XMOVE(STORE(M41SV),STORE(L41BEX),MD41B)
                     IF ( ISTORE(L41BEX) .EQ. IORG1 ) THEN
                       ISTORE(L41BEX) = ISVI1
                       ISTORE(L41BEX+6) = ISVI2
                     ELSE
                      ISTORE(L41BEX+6) = ISVI1
                      ISTORE(L41BEX) = ISVI2
                     END IF
                     L41BEX = L41BEX + MD41B
                     N41BSV = N41BSV + 1
                     EXIT
                    END DO
                  END IF
                 END IF
              END IF
          END IF
        END DO
      END DO

c      WRITE ( CMON,'(A)') 'Done.'
      TOPSER = TOPSER + 3 !Leave a gap for debugging analysis

      IF ( JNEWAT .GT. 0 ) THEN
C Layer 1 of sym atoms complete. Start on layer 2.

c         WRITE ( CMON,'(A)') 'Seeking 2nd level bonds across sym ops.'
c         CALL XPRVDU(NCVDU, 1,0)

C Move new atoms up and insert existing L5 block.
         IF ( JNEWAT .GT. 0 ) 
     1    CALL XMOVE (STORE(JBASAT),STORE(JBASAT+MD5*N5),JNEWAT*MD5)
         CALL XMOVE (STORE(L5),STORE(JBASAT),N5*MD5)
         L5 = JBASAT
         LASTN5 = N5
         N5 = N5+JNEWAT
         NFL = L5+MD5*N5



c         WRITE ( CMON,'(A,3I5)') 'New atoms: N5, L5, MD5: ',N5,L5,MD5
c         CALL XPRVDU(NCVDU, 1,0)
c         WRITE ( CMON,'(A)') 'Model look like this:'
c         CALL XPRVDU(NCVDU, 1,0)
c         DO I = 0, N5-1
c           WRITE(CLAB,'(A,I4,A,I4)') ISTORE(L5+I*MD5),I+1,':',
c     1     NINT(STORE(L5+1+I*MD5))
c           CALL XCRAS(CLAB,LLAB)
c           WRITE(CMON,'(A,3F8.4)')CLAB, (STORE(L5+I*MD5+J),J=4,6)
c           CALL XPRVDU(NCVDU, 1,0)
c         END DO

C Recalculate bonds.
         CALL XBCALC(2) !Force bondcalc, but no loading of lists allowed.

c         WRITE ( CMON,'(A,3I5)') 'New bonds(1): N41B, L41B, MD41B: ',
c     1     N41B,L41B,MD41B
c         CALL XPRVDU(NCVDU, 1,0)
c         WRITE ( CMON,'(A)') 'Bonding now looks like this:'
c         CALL XPRVDU(NCVDU, 1,0)
c         DO I = 0,N41B-1
c           IF ( ISTORE(L41B+I*MD41B) .GE. 0 ) THEN
c             WRITE(CMON,'(2I5)')
c     1       ISTORE(L41B+I*MD41B)+1,ISTORE(L41B+6+I*MD41B)+1
c             CALL XPRVDU(NCVDU, 1,0)
c           END IF
c         END DO

       DO LSY = 1,3

         TOPSER = TOPSER + 3 !Leave a gap for debugging analysis
C Call KDIST4 again, this time pivot/bonded atom vectors are required.
         MDATVC = 3
         NATVC = N5
         I=N5*MDATVC
         LATVC = KSTALL (I)
         CALL XZEROF ( ISTORE(LATVC) , I ) !Include all by default.
C Mark all new atoms not to be BONDED type
         DO I = NATVC-JNEWAT,NATVC-1
            ISTORE(LATVC+1+MDATVC*I) = -1
            ISTORE(LATVC+2+MDATVC*I) = -1
         END DO

         JNEWAT = 0
         JBASAT = NFL

         DO I = LASTN5,N5-1

           M5A = L5+I*MD5
           M5 = L5
           JT = 14

           JDISTS = JBASAT + JNEWAT*MD5 + 1400
           NFL = JDISTS
           JS = JDISTS

           IPART = 1
           K = KDIST4(JS,JT,1, IPART)

           NFL = JDISTS

C Go through results (K is -ve if stack overflow: ignore)
           DO J=JDISTS,JDISTS+(K-1)*14,14
             I5 = ISTORE(J)

c                 WRITE(CMON,'(2A,I4,2A,I4)')
c     1      'Pivot:',  ISTORE(M5A),NINT(STORE(M5A+1)),
c     1      'Bonded:',  ISTORE(I5),NINT(STORE(I5+1))
c                   CALL XPRVDU(NCVDU, 1,0)  

C Find entries where sym ops are applied
             IF ((ISTORE(J+2).NE.1).OR.(ISTORE(J+3).NE.1).OR.
     1           (ISTORE(J+4).NE.0).OR.(ISTORE(J+5).NE.0).OR.
     1                              (ISTORE(J+6).NE.0)    ) THEN


C Ignore entries that coincide with existing atoms:

                 ICOINC = 0
                 DO K = 0,N5-1
                   IF ( ABS(STORE(J+7)-STORE(L5+K*MD5+4))
     1                 +ABS(STORE(J+8)-STORE(L5+K*MD5+5))
     1                 +ABS(STORE(J+9)-STORE(L5+K*MD5+6)).LT. 0.0001)
     1                  THEN
                     ICOINC = -K-1
                     EXIT
                   END IF
                 END DO
                 DO K = 0,JNEWAT-1
                   IF ( ABS(STORE(J+7)-STORE(JBASAT+K*MD5+4))
     1                 +ABS(STORE(J+8)-STORE(JBASAT+K*MD5+5))
     1                 +ABS(STORE(J+9)-STORE(JBASAT+K*MD5+6)).LT.0.0001)
     1                  THEN
                     ICOINC = K+1
                     EXIT
                   END IF
                 END DO


                 IF ( ICOINC .EQ. 0 ) THEN

C Add entry to our "new L5 in memory".

                   CALL XMOVE (STORE(I5), STORE(JBASAT+MD5*JNEWAT), MD5)
                   CALL XMOVE (STORE(J+7),STORE(JBASAT+MD5*JNEWAT+4), 3)
                   STORE(JBASAT+1+MD5*JNEWAT)=TOPSER

                   WRITE ( CMON,'(A,I4,1X,A,6I4,3F9.3)')'new atom (2) ',
     1               LSY,
     1               ISTORE(I5),NINT(STORE(I5+1)),
     1               (ISTORE(J+L),L=2,6),
     1               (STORE(J+L),L=7,9)  
                   CALL XPRVDU(NCVDU, 1,0)


C Find bond I5 to M5A in 'safe' bit of L41. Add new entry for this
C atom onto the end.
                   IF ( L41BEX + MD41B .LE. L41MAX ) THEN
                    ISVI1 = ISTORE(I5+13)  ! Index of found atom
                    ISVI2 = ISTORE(M5A+13) ! Index of pivot atom
c                    write (99,'(A,2I6)') 'Checking for ',ISVI1,ISVI2
                    DO M41SV = L41BSV, L41BSV+(N41BSV-1)*MD41B, MD41B
                     I51 = ISTORE(M41SV)
                     I52 = ISTORE(M41SV+6)
c                     write (99,'(A,2I6)') 'Test ',I51,I52
                     IF ( ( ISVI1.NE.I51 ) .AND. ( ISVI2.NE.I51 ) )CYCLE
                     IF ( ( ISVI1.NE.I52 ) .AND. ( ISVI2.NE.I52 ) )CYCLE
C                     IF ( ISVI1 .EQ. ISVI2 ) CYCLE
c                     write (99,'(A)') 'Made it'
   
                     CALL XMOVE(STORE(M41SV),STORE(L41BEX),MD41B)

                     IF ( ISTORE(L41BEX) .EQ. ISVI1 ) THEN
                       ISTORE(L41BEX) = N5 + JNEWAT
                       ISTORE(L41BEX+6) = I
                     ELSE
                      ISTORE(L41BEX+6) = N5 + JNEWAT
                      ISTORE(L41BEX) = I
                     END IF
                     L41BEX = L41BEX + MD41B
                     N41BSV = N41BSV + 1
c      write(99,'(A,2I15)')'2: Added bond ', L41BEX, N5+JNEWAT
                     EXIT
                    END DO
                   END IF

                   TOPSER=TOPSER+1
                   JNEWAT = JNEWAT + 1
                 ELSE

C The atom is coincident, but check if a bond exists already.
C Could be a bond looping back.
                 ISVI1 = N5+ICOINC-1     ! Index of the coincident atom
                 IF ( ICOINC .LT. 0 ) ISVI1 = -ICOINC-1
                 ISVI2 = I            ! Index of pivot atom
                 IBDEXI = 0
                 DO M41SV = L41BSV, L41BSV+(N41BSV-1)*MD41B, MD41B
                  I51 = ISTORE(M41SV)
                  I52 = ISTORE(M41SV+6)
                  IF ( ( ISVI1.NE.I51 ) .AND. ( ISVI2.NE.I51 ) ) CYCLE
                  IF ( ( ISVI1.NE.I52 ) .AND. ( ISVI2.NE.I52 ) ) CYCLE
C                  IF ( ISVI1 .EQ. ISVI2 ) CYCLE
                  IBDEXI = 1
                 END DO
                 IF ( IBDEXI .EQ. 0 ) THEN
C Now find original index of these two atoms.
                  IF ( ISVI1 .GE. N5 ) THEN
                     IORG1 = ISTORE(JBASAT+(ISVI1-N5)*MD5+13)
                  ELSE
                     IORG1 = ISTORE(L5+ISVI1*MD5+13)
                  END IF
                  IORG2 = ISTORE(L5+ISVI2*MD5+13)
C Find bond IORG1 to IORG2 in 'safe' bit of L41. Add new entry for this
C bond onto the end.
                  IF ( L41BEX + MD41B .LE. L41MAX ) THEN
                    DO M41SV = L41BSV, L41BSV+(N41BSV-1)*MD41B, MD41B
                     I51 = ISTORE(M41SV)
                     I52 = ISTORE(M41SV+6)
c                     write (99,'(A,2I6)') '3:Test ',I51,I52
                     IF ( ( IORG1.NE.I51 ) .AND. ( IORG2.NE.I51 ) )CYCLE
                     IF ( ( IORG1.NE.I52 ) .AND. ( IORG2.NE.I52 ) )CYCLE
C                     IF ( ISVI1 .EQ. ISVI2 ) CYCLE
c                     write (99,'(A)') '3:Made it'
                     CALL XMOVE(STORE(M41SV),STORE(L41BEX),MD41B)
                     IF ( ISTORE(L41BEX) .EQ. IORG1 ) THEN
                       ISTORE(L41BEX) = ISVI1
                       ISTORE(L41BEX+6) = ISVI2
                     ELSE
                      ISTORE(L41BEX+6) = ISVI1
                      ISTORE(L41BEX) = ISVI2
                     END IF
                     L41BEX = L41BEX + MD41B
                     N41BSV = N41BSV + 1
                     EXIT
                    END DO
                   END IF


                 END IF
                 END IF
             END IF
           END DO
         END DO

C Move new atoms and insert existing L5 block.
         IF ( JNEWAT .GT. 0 ) 
     1    CALL XMOVE (STORE(JBASAT),STORE(JBASAT+MD5*N5),JNEWAT*MD5)
         CALL XMOVE (STORE(L5),STORE(JBASAT),N5*MD5)
         L5 = JBASAT
         LASTN5 = N5
         N5 = N5+JNEWAT
         NFL = L5+MD5*N5

c         WRITE ( CMON,'(A,3I5)') 'N5, L5, MD5: ',N5,L5,MD5
c         CALL XPRVDU(NCVDU, 1,0)
c         WRITE ( CMON,'(A,i4)') 'Atoms now look like this: ',LSY
c         CALL XPRVDU(NCVDU, 1,0)

c         DO I = 0, N5-1
c           WRITE(CLAB,'(A,I4,A,I4)') ISTORE(L5+I*MD5),I+1,':',
c     1     NINT(STORE(L5+1+I*MD5))
c           CALL XCRAS(CLAB,LLAB)
c           WRITE(CMON,'(A,3F8.4)')CLAB, (STORE(L5+I*MD5+J),J=4,6)
c           CALL XPRVDU(NCVDU, 1,0)
c         END DO

         IF(LSY.EQ.3) THEN !Last time around - don't look for SYM atoms.
             ISTORE(L40T+3) = 1
         END IF
        

         CALL XBCALC(2)

       END DO
      END IF

C TODO - change L41 pointers.


      L41B = L41BSV
      N41B = N41BSV


      LATVC = LLATVC
      NATVC = NNATVC

      RETURN
      END



      SUBROUTINE XCONFLIP (TXTIN,LIN,TXTOUT1,LOUT1,TXTOUT2,LOUT2,ICEN)
C
C-----CONVERT X, Y, Z to x1, x2, x3 and add inversion centre related operations
C
C      TXTIN      TEXT OF FRACTIONAL OPERATOR (FROM XSUMOP)
C      LIN        LENGTH OF TEXT
C      TXTOUT     TEXT OF DECIMAL OPERATOR
C      LOUT       LENGTH OF TEXT
C
      CHARACTER *(*) TXTIN
      CHARACTER *(*) TXTOUT1,TXTOUT2
      CHARACTER *50 CBUFFER
      CHARACTER *3 CXYZ
      CHARACTER *6 CX1X2X3
      CHARACTER *1 CBLANK
      CHARACTER *10 CNUM
C
C
      DATA CNUM / '1234567890' /
      DATA CXYZ / 'XYZ'/
      DATA CX1X2X3 / 'x1x2x3'/
      DATA CBLANK /' '/
C
C----- CLEAR BUFFER
      TXTOUT1 = ' '
      TXTOUT2 = ' '
      LOUT1 = LIN
      CBUFFER=TXTIN
      I=1
C
1000  CONTINUE
        JSIGN = INDEX(CBUFFER,CXYZ(I:I))
        IF (JSIGN.EQ.0) THEN
         GOTO 1001
        ENDIF
        IF (JSIGN.GT.1)THEN
          WRITE(TXTOUT1(1:JSIGN-1),'(A)')CBUFFER(1:JSIGN-1)
        ENDIF
        WRITE(TXTOUT1(JSIGN:JSIGN+1),'(A2)')CX1X2X3(I*2-1:I*2)
        IF (JSIGN.LT.LIN+I-1)THEN
         WRITE(TXTOUT1(JSIGN+2:LOUT1+I),'(A)')
     &         CBUFFER(JSIGN+1:LOUT1+I-1)
        ENDIF
        CBUFFER=TXTOUT1
        LOUT1=LOUT1+1
c        write(*,'(3x,a)')txtout1(1:LOUT1)
       GOTO 1000
C- the centrosymmetric part if it exists
 1001 I=I+1
      IF (I.LT.4) GOTO 1000
      IU=1
      LOUT2=LOUT1
      CBUFFER=TXTOUT1
      IF (ICEN.GT.0)THEN
 1002    JSIGN = INDEX(CBUFFER(IU:LOUT2),'x')+IU-1
         ITEL=1
         IF (JSIGN.EQ.IU-1) GOTO 1003
           IF (JSIGN.EQ.1) THEN
             TXTOUT2(1:2)='-x'
             TXTOUT2(3:LOUT2+1)=CBUFFER(JSIGN+1:LOUT2)
             LOUT2=LOUT2+1
             ITEL=2
           ELSE
             IF (CBUFFER(JSIGN-1:JSIGN-1).EQ.'+')THEN
               TXTOUT2(1:JSIGN)=CBUFFER(1:JSIGN)
               TXTOUT2(JSIGN-1:JSIGN-1)='-'
               TXTOUT2(JSIGN+1:LOUT2)=CBUFFER(JSIGN+1:LOUT2)
             ENDIF
             IF (CBUFFER(JSIGN-1:JSIGN-1).EQ.'-')THEN
               TXTOUT2(1:JSIGN)=CBUFFER(1:JSIGN)
               TXTOUT2(JSIGN-1:JSIGN-1)='+'
               TXTOUT2(JSIGN+1:LOUT1)=CBUFFER(JSIGN+1:LOUT2)
             ENDIF
             IF (CBUFFER(JSIGN-1:JSIGN-1).EQ.CBLANK)THEN
               TXTOUT2(1:JSIGN-1)=CBUFFER(1:JSIGN-1)
               TXTOUT2(JSIGN:JSIGN)='-'
               TXTOUT2(JSIGN+1:LOUT2+1)=CBUFFER(JSIGN:LOUT2)
               LOUT2=LOUT2+1
               ITEL=2
             ENDIF
          ENDIF
          IU=JSIGN+ITEL
          CBUFFER=TXTOUT2
c          write(*,'(3x,a)')txtout2(1:LOUT2)
          IF (IU.LT.LOUT2) GOTO 1002
 1003 CONTINUE

C---- CHeck for fractions which have to be inverted
      IU=1
 1004  JSIGN = INDEX(CBUFFER(IU:LOUT2),'/')+IU-1
        IF (JSIGN.EQ.IU-1) GOTO 1005
        IF((CBUFFER(JSIGN+1:JSIGN+1).EQ.'3').AND.
     &     (CBUFFER(JSIGN-1:JSIGN-1).EQ.'1'))
     &   WRITE(TXTOUT2(JSIGN-1:JSIGN-1),'(A1)')
     &         CNUM(2:2)
        IF((CBUFFER(JSIGN+1:JSIGN+1).EQ.'3').AND.
     &     (CBUFFER(JSIGN-1:JSIGN-1).EQ.'2'))
     &   WRITE(TXTOUT2(JSIGN-1:JSIGN-1),'(A1)')
     &         CNUM(1:1)
        IF((CBUFFER(JSIGN+1:JSIGN+1).EQ.'4').AND.
     &     (CBUFFER(JSIGN-1:JSIGN-1).EQ.'1'))
     &   WRITE(TXTOUT2(JSIGN-1:JSIGN-1),'(A1)')
     &         CNUM(3:3)
        IF((CBUFFER(JSIGN+1:JSIGN+1).EQ.'4').AND.
     &     (CBUFFER(JSIGN-1:JSIGN-1).EQ.'3'))
     &   WRITE(TXTOUT2(JSIGN-1:JSIGN-1),'(A1)')
     &         CNUM(1:1)
        IF((CBUFFER(JSIGN+1:JSIGN+1).EQ.'6').AND.
     &     (CBUFFER(JSIGN-1:JSIGN-1).EQ.'1'))
     &   WRITE(TXTOUT2(JSIGN-1:JSIGN-1),'(A1)')
     &         CNUM(5:5)
        IF((CBUFFER(JSIGN+1:JSIGN+1).EQ.'6').AND.
     &     (CBUFFER(JSIGN-1:JSIGN-1).EQ.'5'))
     &   WRITE(TXTOUT2(JSIGN-1:JSIGN-1),'(A1)')
     &         CNUM(1:1)
       IU=JSIGN+1
       IF (IU.LT.LOUT2) GOTO 1004
      ENDIF
 1005 CONTINUE
c      write(*,'(3x,a)')txtout2(1:LOUT2)
      RETURN
      END

C >>>>> Convert name string to lower case
C
         function locase(name,isp)
C
c      INCLUDE 'CIF1.INC'
c      INCLUDE 'CIFSYS.INC'
         character    locase*(200)
         character    temp*(200),name*(*)
         character    low*26,cap*26,c*1
         integer i,j
         data  cap /'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
         data  low /'abcdefghijklmnopqrstuvwxyz'/
C
         temp(1:isp)=name(1:isp)
         do 100 i=1,isp
         c=temp(i:i)
         if(c.eq.' ') goto 100
c         if(c.eq.tab) goto 100
         j=index(cap,c)
         if(j.ne.0) temp(i:i)=low(j:j)
100      continue
200      locase=temp
         return
         end
