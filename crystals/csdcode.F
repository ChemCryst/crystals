C234567890C234567890C234567890C234567890C234567890C234567890C234567890123
C $Log: csdcode.F,v $
C Revision 1.25  2012/07/12 08:12:02  rich
C Fix uninit variable when disconnected carbon atom.
C
C Revision 1.24  2011/08/31 15:44:04  rich
C Added initialisation of KOXY variable
C
C Revision 1.23  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.22  2008/10/01 11:11:54  djw
C Support for treatment of Deuterium as hydrogen
C
C Revision 1.21  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.20  2003/03/12 18:28:27  rich
C Limit aromatic ring size (stored in L41S) to first six atoms found - only space for this
C in L41. This data is used to actually draw the rings, so rings >7 will be
C a bit weird. Ideally we could store parameters defining the ring instead
C of the atoms making up the ring, thus allowing any size.
C
C Revision 1.19  2003/02/27 11:23:59  rich
C Some commented out code, exploring what to do with hybridisation.
C
C Revision 1.18  2003/01/21 12:54:11  rich
C Commented out swathes of unused code in order to shrink
C the executable a bit.
C
C Revision 1.17  2002/06/26 10:30:08  richard
C Remove debugging statement about unbalanced charge sums.
C Suppress warning message if forced bond type is same as calculated
C bond type. Convert QH to H internally before processing.
C
C Revision 1.16  2002/03/15 11:30:09  richard
C Fix problem where bond types are not calculated on opening a new structure.
C
C Revision 1.15  2002/03/12 18:01:13  ckp2
C Comment out debugging. Treat planar sp2 N's as possibly aromatic.
C
C Revision 1.14  2002/02/27 19:30:18  ckp2
C RIC: Increase lengths of lots of strings to 256 chars to allow much longer paths.
C RIC: Ensure consistent use of backslash after CRYSDIR:
C
C Revision 1.13  2001/12/18 13:06:47  ckp2
C Overhauled the CSD bond typing routine to use CRYSTALS' store.
C Got rid of all big arrays.
C
C Revision 1.12  2000/12/11 10:21:59  richard
C RIC: Commented line for writing out stuff for THOMAS.EXE, the Windows version
C of Quest.
C
C Revision 1.11  2000/09/20 12:21:56  ckp2
C No more debugging output. Ignore H atoms.
C
C Revision 1.10  2000/07/11 11:04:03  ckp2
C Extra argument to KFLOPN, for specifying SEQUENTIAL or DIRECT access
C
C Revision 1.9  2000/07/04 13:42:16  ckp2
C Better formatting of output. Angle checks included. Bug with ordering of
C descriptors fixed.
C
C Revision 1.8  1999/06/03 17:26:09  dosuser
C RIC: Added linux graphical interface support (GIL)
C
C Revision 1.7  1999/05/25 17:56:14  dosuser
C RIC: Expanded all tabs to 6 spaces. g77 doens't like tabs.
C
C Revision 1.6  1999/05/25 15:59:31  dosuser
C RIC: Added LIN and GIL specific UNIX file paths.
C      Added APPEND hack for LINUX version.
C
C Revision 1.5  1999/05/21 11:16:26  dosuser
C RIC: Masses of changes to allow angle checks on the structure and
C to bring code up to date with the test version. Still not linked from
C the main crystals code. EMAP2D needs work to use the angle FOM to
C make decisions. Code needs rationalising into subroutines.
C
C Revision 1.4  1999/05/10 19:48:21  dosuser
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
C Revision 1.3  1999/05/04 17:46:20  dosuser
C RIC: Begin to implement angle checking code.
C
C Revision 1.2  1999/04/26 10:59:23  dosuser
C RIC: Removed unneccesary brackets in I/O list.
C      Comment starting ! on a line with no Fortran code wasn't liked
C      by the Salford compiler.
C      HYBR was zeroed as a scalar, instead of an array.
C
C Revision 1.1  1999/03/20 20:30:11  dosuser
C RIC: 2D searching code provided by CCDC from the PLUTO program,
C      plus a couple of subroutines to fill in the PLUTO data
C      structure using CRYSTALS list 5 info.
C      Also a couple of subroutines for doing bond fragment validation
C      against CSD data. None of this code is linked with the current
C      repository version of CRYSTALS. (Yet).
C


CCCODE FOR KBNDCH
CC      INTEGER FUNCTION KBNDCH ( RFOM,  KBAD,           RBAD,
CC     1                          RAFOM, KABAD1, KABAD2, RABAD,
CC     2                          NFOM,  SFOM )
CC
CC
Cc Return values:
Cc
Cc    KBNDCH - Processing incomplete. Needs more CSD data.
Cc             Values in RFOM, KBAD and RBAD are to be ignored.
Cc
Cc     RFOM - OUT - An overall figure of merit (fit) for the whole
Cc            molecule. (Lower is better!)
CC     KBAD - OUT - Index (in list 18) of the worst bond.
CC     RBAD - OUT - Individual fit for the worst bond. (Lower is better).
CC
CC     NBAD - IN  - Bond to monitor.
CC     SBAD - OUT - Fit of bond NBAD.
CC
CC Things already set up at this point:
CC
CC     For the nth bond in the list:
CC           BBLK(n,1) ATOM1 element type
CC           BBLK(n,2) ATOM1 serial
CC           BBLK(n,3) ATOM2 element type
CC           BBLK(n,4) ATOM2 serial
CC           BBLK(n,5) bond length
CC           BBLK(n,6) csd bond type code. See CBONDS.
CC           BBLK(n,7) 0 = acyclic, 1 = cyclic
CC
CC           BBLK(n,9) Flag. Non-zero indicates that this bond is not to
CC                     be checked, but it is used to generate bond codes.
CC
CC     Things worked out in this subroutine.
CC           BBLK(n,8) (bond length - bond sample mean) / sample stddev
CC           i.e. How many stddev's the bond lies from its CSD average value.
CC
CC           A unique code for the bond.
CC           Bond mean and stddev are looked up from a file.
CC           If they are not present, they are read from a csd .TAB file
CC           in the current directory.
CC           If this file is not present a csd input file is written which
CC           may be used to generate the csd .TAB file.
CC
CC
CC Check bond lengths against know bond lengths from CSD
CC Require LIST 18 (temporarily common block) (BONDS -
CC generated by BONDTY or EMAP2D).
C
C\TLST18
C\XIOBUF
C\XUNITS
C\XSSVAL
C\XLST05
C\XGUIOV
C\QGUIOV
C\STORE
C\ISTORE
C\QSTORE
C
C
C      REAL    ABLK1(24), ABLK2(24), ABLK3(24), RBLK(72)
C      INTEGER IAT1N, IAT1S, IAT2N, IAT2S
C      INTEGER IANG1N, IANG2N, IANG3N
C      REAL     ANG1N,  ANG2N,  ANG3N
C      EQUIVALENCE ( IANG1N, ANG1N )
C      EQUIVALENCE ( IANG2N, ANG2N )
C      EQUIVALENCE ( IANG3N, ANG3N )
C      INTEGER ITYPE
C      CHARACTER*4 CCOMP, CTEMP, CDUM
C      CHARACTER*256 CFILEN
C      CHARACTER*78 CCODE, CLINE
C      DATA KHYD /'H   '/
C      PARAMETER (MAXNUM = 46300)
C
C      CHARACTER*11 CBONDS(9)
C      DATA CBONDS / 'single',    'double',      'triple',  'quadruple',
C     1  'aromatic', 'polymeric', 'delocalised', 'strange', 'pi-bond'/
C
C
Cc      WRITE (CMON,'(A)') 'BONDCK: Checking bonds:'
Cc      CALL XPRVDU(NCVDU, 1,0)
C
C
C      RFOM = 0.0
C      KBAD = 0
C      RBAD = 0.0
C      RAFOM = 0.0
C      KABAD1 = 0
C      KABAD2 = 0
C      RABAD = 0.0
C
C      KCOUNT = 0
C      KBNDCH = 0
C
C
C      IF ( KHUNTR ( 5, 0, IADDL, IADDR, IADDD, -1) .LT. 0 ) CALL XFAL05
C
C      IFIRST = 1
C      RZAVER = 0.0
C      IZAVER = 0
C
CC Check each bond once.
C      DO 800 I = 1, NB18
CC Bonds not to be checked are flagged non zero at offset 9.
CC Also, don't check bonds with hydrogen in!
C         IF ( ( IBLK (I,9) .EQ. 0 ) .AND. ( IBLK(I,1).NE.KHYD )
C     1                              .AND. ( IBLK(I,3).NE.KHYD ) ) THEN
CC            WRITE (CMON,'(A,I4)') 'BONDCK: Checking bond - ', I
CC            CALL XPRVDU(NCVDU, 1,0)
C            KCOUNT = KCOUNT + 1
C            IAT1N = IBLK(I,1)
C            IAT1S = NINT(BBLK(I,2))
C            IAT2N = IBLK(I,3)
C            IAT2S = NINT(BBLK(I,4))
C            BLEN = BBLK(I,5)
C            ITYPE = NINT(BBLK(I,6))
C            IRING = IBLK(I,7)
C
CC            WRITE(CMON,'(A4,I4,1X,A4,I4,1X,F8.3,I4,I4)')
CC     1      IAT1N,IAT1S,IAT2N,IAT2S,BLEN,ITYPE,IRING
CC            CALL XPRVDU(NCVDU, 1,0)
C
C            ABLK1(1) = BBLK(I,1)
C            ABLK2(1) = BBLK(I,3)
C            ABLK1(2) = 0.0
C            ABLK2(2) = 0.0
C
CC Search for contacts to AT1.
C            DO 100 J = 1, NB18
C              IF(I.NE.J) THEN
C                IF(       ( IAT1N.EQ.       IBLK(J,1)   )
C     1               .AND. ( IAT1S.EQ. NINT( BBLK(J,2) ) ) )THEN
C                    ABLK1(2)=NINT(ABLK1(2)) + 1.0
C                    ABLK1( 2 * NINT(ABLK1(2)) + 1 ) = BBLK(J,3)
C                    ABLK1( 2 * NINT(ABLK1(2)) + 2 ) = BBLK(J,6)
C                ELSE IF(  ( IAT1N.EQ.       IBLK(J,3)   )
C     1               .AND. ( IAT1S.EQ. NINT( BBLK(J,4) ) ) )THEN
C                    ABLK1(2)=NINT(ABLK1(2)) + 1.0
C                    ABLK1( 2 * NINT(ABLK1(2)) + 1 ) = BBLK(J,1)
C                    ABLK1( 2 * NINT(ABLK1(2)) + 2 ) = BBLK(J,6)
C                END IF
C            ENDIF
C100         CONTINUE
C
CC Search for contacts to AT2.
C            DO 200 J = 1, NB18
C              IF(I.NE.J) THEN
C                IF(       ( IAT2N.EQ.       IBLK(J,1)   )
C     1               .AND. ( IAT2S.EQ. NINT( BBLK(J,2) ) ) )THEN
C                    ABLK2(2)=NINT(ABLK2(2)) + 1.0
C                    ABLK2( 2 * NINT(ABLK2(2)) + 1 ) = BBLK(J,3)
C                    ABLK2( 2 * NINT(ABLK2(2)) + 2 ) = BBLK(J,6)
C                ELSE IF(  ( IAT2N.EQ.       IBLK(J,3)   )
C     1               .AND. ( IAT2S.EQ. NINT( BBLK(J,4) ) ) )THEN
C                    ABLK2(2)=NINT(ABLK2(2)) + 1.0
C                    ABLK2( 2 * NINT(ABLK2(2)) + 1 ) = BBLK(J,1)
C                    ABLK2( 2 * NINT(ABLK2(2)) + 2 ) = BBLK(J,6)
C                END IF
C            ENDIF
C200         CONTINUE
C
C
CC -- Generate unique name.
C
CC Sort ABLK1 into alphabetical order.
C            IF(NINT(ABLK1(2)).GE.2) THEN
C              DO 300 J = 2, NINT(ABLK1(2))
CC Pick out an element.
C                  WRITE(CTEMP,'(A4)')ABLK1(J*2+1)
C                  RTEMP = ABLK1(J*2+1)
C                  ITEMP = NINT(ABLK1(J*2+2))
CC Find place to insert.
C                  DO 280 K = J - 1, 1, -1
C                    WRITE(CCOMP,'(A4)')ABLK1(K*2+1)
C                    ICOMP = KCHCMP(CCOMP,CTEMP)
C                    IF(      ( ICOMP.LT.0 )
C     1                 .OR. (       ( ICOMP.EQ.0 )
C     1                     .AND. ( ITEMP.LT.(NINT(ABLK1(K*2+1))) )
C     1                          )
C     1                 ) GOTO 290
CC Otherwise shift the others along.
C                    ABLK1(K*2+3) = ABLK1(K*2+1)
C                    ABLK1(K*2+4) = ABLK1(K*2+2)
C280               CONTINUE
C                  K = 0
C290               CONTINUE
C                  ABLK1(K*2+3) = RTEMP
C                  ABLK1(K*2+4) = ITEMP
C300           CONTINUE
C            END IF
C
CC Sort ABLK2 into alphabetical order.
C            IF(NINT(ABLK2(2)).GE.2) THEN
C              DO 400 J = 2, NINT(ABLK2(2))
CC Pick out an element.
C                  WRITE(CTEMP,'(A4)')ABLK2(J*2+1)
C                  RTEMP = ABLK2(J*2+1)
C                  ITEMP = NINT(ABLK2(J*2+2))
CC Find place to insert.
C                  DO 380 K = J - 1, 1, -1
C                    WRITE(CCOMP,'(A4)')ABLK2(K*2+1)
C                    IF( KCHCMP(CCOMP,CTEMP) .LT. 0 ) GOTO 390 !Insert here
CC Shift the others along.
C                    ABLK2(K*2+3) = ABLK2(K*2+1)
C                    ABLK2(K*2+4) = ABLK2(K*2+2)
C380               CONTINUE
C                  K = 0
C390               CONTINUE
C                  ABLK2(K*2+3) = RTEMP
C                  ABLK2(K*2+4) = ITEMP
C400           CONTINUE
C            END IF
C
CC Work out which element has precedence:
CC  Compare element names
C            WRITE(CCOMP,'(A4)')IAT1N
C            WRITE(CTEMP,'(A4)')IAT2N
C            IF ( KCHCMP(CCOMP,CTEMP) .GT. 0 ) GOTO 500
C            IF ( KCHCMP(CCOMP,CTEMP) .LT. 0 ) GOTO 550
CC  Compare number of connections
C            IF ( NINT(ABLK1(2)) .GT. NINT(ABLK2(2)) ) GOTO 500
C            IF ( NINT(ABLK1(2)) .LT. NINT(ABLK2(2)) ) GOTO 550
C
CC  Compare each connection by name, and number of connections.
C            DO 450 K = 1,NINT(ABLK1(2))
C                  WRITE(CCOMP,'(A4)')ABLK1(K*2+1)
C                  WRITE(CTEMP,'(A4)')ABLK2(K*2+1)
C                  IF ( KCHCMP(CCOMP,CTEMP) .GT. 0 ) GOTO 500
C                  IF ( KCHCMP(CCOMP,CTEMP) .LT. 0 ) GOTO 550
C                 IF ( NINT(ABLK1(K*2+2)).GT.NINT(ABLK2(K*2+2)))GOTO 500
C                 IF ( NINT(ABLK1(K*2+2)).LT.NINT(ABLK2(K*2+2)))GOTO 550
C450         CONTINUE
C
C500         CONTINUE !ATOM 1 has precedence
C            RBLK(1) = ITYPE
C            IPL = 1
C            DO 510 K = 1, NINT(ABLK1(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL)   =  ABLK1(K)
C510         CONTINUE
C            DO 520 K = 1, NINT(ABLK2(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL)   =  ABLK2(K)
C520         CONTINUE
C            GOTO 600
C550         CONTINUE !ATOM 2 has precedence
C            RBLK(1) = ITYPE
C            IPL = 1
C            DO 560 K = 1, NINT(ABLK2(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL)   =  ABLK2(K)
C560         CONTINUE
C            DO 570 K = 1, NINT(ABLK1(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL)   =  ABLK1(K)
C570         CONTINUE
C600         CONTINUE
C
CC            WRITE(CMON,'(A4)')'BOND'
CC            CALL XPRVDU(NCVDU,1,0)
CC            WRITE(CMON,'(I2)')IRING
CC            CALL XPRVDU(NCVDU,1,0)
CC            WRITE(CMON,'(I2)')NINT(RBLK(1))
CC            CALL XPRVDU(NCVDU,1,0)
CC            DO K = 2, IPL, 2
CC                  WRITE(CMON,'(A2)')RBLK(K)
CC                  CALL XPRVDU(NCVDU,1,0)
CC                  WRITE(CMON,'(I2)')NINT(RBLK(K+1))
CC                  CALL XPRVDU(NCVDU,1,0)
CC            ENDDO
C
C
C            WRITE(CCODE,'(A4,2I2,18(A2,I2))') 'BOND',IRING,
C     1     NINT(RBLK(1)),(RBLK(K),NINT(RBLK(K+1)),K=2,IPL,2)
CC Remove spaces from CCODE.
C            CALL XCRAS(CCODE,NDUM)
C
CC Check for this bond type in the local database.
CC If it is present compare bond length to mean and stddev of data.
CC If it is not present write out a file for obtaining the data.
C##LINGIL            CFILEN = 'CRYSDIR:script\bonddata.cdb'
C&&LINGIL            CFILEN = 'CRYSDIR:script/bonddata.cdb'
C            CALL MTRNLG(CFILEN,'OLD',ILENG)
C            IF (KFLOPN (NCFPU1,CFILEN(1:ILENG),ISSOLD,ISSREA,1,ISSSEQ)
C     1        .LE. -1) GOTO 650
C
CC Search for this bond type in that file.
C610         CONTINUE
C              READ(NCFPU1,'(A)',END=650)CLINE
C              IF(CLINE.EQ.CCODE) GOTO 680
C            GOTO 610
C
CC Bond type not found in cdb file.
C650         CONTINUE
C            CLOSE(NCFPU1)
CC Check for a .tab file with information about this bond.
C            CALL XCTRIM(CCODE,NCHAR)
C            NCHAR = NCHAR - 1
C            CFILEN = CCODE(1:NCHAR)//'.tab'
C            CALL MTRNLG(CFILEN,'OLD',ILENG)
C            IF (KFLOPN (NCFPU1, CFILEN(1:ILENG),ISSOLD,ISSREA,1,ISSSEQ)
C     1        .LE. -1) GOTO 670
CC Starting from the 9th line, read value every 4 lines.
C            DO 660 K=1,8
C                READ(NCFPU1,'(A)',END=9910)CDUM
C660         CONTINUE
CC Accumulate X and X squared for mean and stddev in one pass.
C            NUMX  = 0
C            SUMX  = 0.0
C            SUMX2 = 0.0
C661         CONTINUE
C              READ(NCFPU1,'(F8.3)',END=663,ERR=9910) VAL
C              SUMX  = SUMX  + VAL
C              SUMX2 = SUMX2 + VAL**2
C              NUMX  = NUMX + 1
C              IF(SUMX.GT.MAXNUM) THEN
C                  WRITE(CMON,'(A/A,I5,A)')
C     1            'Accumulating values are almost too large.',
C     1            'Abandoning input file after ',NUMX,' data points.'
C                  GOTO 663
C              ENDIF
C              DO 662 K=1,3
C                READ(NCFPU1,'(A)',END=663)CDUM
C662           CONTINUE
C            GOTO 661
C663         CONTINUE
C            CLOSE (NCFPU1)
C            BMEAN  = SUMX / NUMX
C            BSTDEV = SQRT((NUMX*SUMX2 - SUMX**2)/(NUMX*(NUMX-1)))
CC Write this info to the cdb file for future use.
C##LINGIL            CFILEN = 'CRYSDIR:script\bonddata.cdb'
C&&LINGIL            CFILEN = 'CRYSDIR:script/bonddata.cdb'
C            CALL MTRNLG(CFILEN,'UNKNOWN',ILENG)
C            IF (KFLOPN (NCFPU1,CFILEN(1:ILENG),ISSCIF,ISSWRI,1,ISSSEQ)
C     1        .LE. -1) GOTO 9920
CC Read to the end.
C665       CONTINUE
C                  READ(NCFPU1,'(A)',END=666) CDUM
C            GOTO 665
C666         CONTINUE
CC Add the info.
C            WRITE(NCFPU1,'(A)')CCODE
C            WRITE(NCFPU1,'(2F10.5)')BMEAN,BSTDEV
C            CLOSE (NCFPU1)
C            GOTO 681 !Carry on with analysis.
C
CC There is no entry in .cdb file and no .tab file.
CC Write a quest input file to generate bond data.
C670         CONTINUE !No tab file, write out an .if for quest.
C            WRITE(CMON, '(A,/,5A)')'Bond type not found. Run quest.',
C     1   'quest -j ',CCODE(1:NCHAR),' -if ',CCODE(1:NCHAR),'.if'
C            CALL XPRVDU(NCVDU, 2,0)
C            CALL XCTRIM(CCODE,NCHAR)
C            NCHAR=NCHAR-1
C            CFILEN = CCODE(1:NCHAR)//'.if'
C            CALL MTRNLG(CFILEN,'UNKNOWN',ILENG)
C            IF (KFLOPN (NCFPU1,CFILEN(1:ILENG),ISSCIF,ISSWRI,1,ISSSEQ)
C     1        .LE. -1) GOTO 9920
CC Need this line for THOMAS.EXE to run on the PC, but it's my personal
CC serial number, so it's no good for release.
Cc            WRITE(NCFPU1,'(A)')
Cc     1              'COMM <0570-f173-00d1-f4d2 beb4-9530-f083-2635>'
C            WRITE(NCFPU1,'(A)')'T1 *CONN'
C            WRITE(NCFPU1,'(A)')'ELDEF Q= AA'
C            WRITE(NCFPU1,'(A,A2,I4,A)')
C     1                       'AT1 ',ABLK1(1),NINT(ABLK1(2)+1.0),' E'
C            WRITE(NCFPU1,'(A,A2,I4,A)')
C     1                       'AT2 ',ABLK2(1),NINT(ABLK2(2)+1.0),' E'
C            IATM=3
C            DO 671 K=1,NINT(ABLK1(2))
C              WRITE(CCOMP,'(I4)')IATM
C              CALL XCRAS(CCOMP,NLEN)
C              WRITE(NCFPU1,'(A2,A4,2X,A2)')'AT',CCOMP,ABLK1(K*2+1)
C              IATM = IATM + 1
C671         CONTINUE
C            DO 672 K=1,NINT(ABLK2(2))
C              WRITE(CCOMP,'(I4)')IATM
C              CALL XCRAS(CCOMP,NLEN)
C              WRITE(NCFPU1,'(A2,A4,2X,A2)')'AT',CCOMP,ABLK2(K*2+1)
C              IATM = IATM + 1
C672         CONTINUE
C            IF(IRING.EQ.1) THEN
C             WRITE(NCFPU1,'(A,I2,A)')'BO 1 2 ',NINT(RBLK(1)),' C'
C            ELSE
C             WRITE(NCFPU1,'(A,I2,A)')'BO 1 2 ',NINT(RBLK(1)),' A'
C            ENDIF
C            IATM = 3
C            DO 673 K=1,NINT(ABLK1(2))
C             WRITE(NCFPU1,'(A,I2,1X,I2)')'BO 1 ',IATM,NINT(ABLK1(K*2+2))
C              IATM = IATM + 1
C673         CONTINUE
C            DO 674 K=1,NINT(ABLK2(2))
C             WRITE(NCFPU1,'(A,I2,1X,I2)')'BO 2 ',IATM,NINT(ABLK2(K*2+2))
C              IATM = IATM + 1
C674         CONTINUE
C            WRITE(NCFPU1,'(A)')'GEOM'
C            WRITE(NCFPU1,'(A)')'DEFINE D1 1 2'
C            WRITE(NCFPU1,'(A)')'NFRAG -99'
C            WRITE(NCFPU1,'(A)')'SYMCHK ON'
C            WRITE(NCFPU1,'(A)')'ENANT NOIN'
C            WRITE(NCFPU1,'(A)')'END'
C            WRITE(NCFPU1,'(A)')'STOP 4000'
C            WRITE(NCFPU1,'(A)')'QUEST T1'
C            CLOSE (NCFPU1)
C            KBNDCH = 1    !Signal incomplete processing on return
C            GOTO 700
C
CC Bond type found print out data
C680         CONTINUE
C            READ(NCFPU1,'(A)',END=9900) CLINE
C            READ(CLINE,'(F10.0,F10.0)') BMEAN, BSTDEV
C            CLOSE(NCFPU1)
C681         CONTINUE
C
C            BBLK(I,8) = (BLEN-BMEAN)/BSTDEV
C            BOUT = ABS(BBLK(I,8))
C
C            IF (IFIRST .EQ. 1) THEN
C                IFIRST = 0
C                WRITE (CMON,'(A,/,A,/,A)')
C     1      ' Bond        From   To     Actual  Ideal  Sample Z-',
C     2      ' Type        atom   atom   length  length stddev score',
C     3      ' '
C            CALL XPRVDU(NCVDU, 3,0)
C            END IF
C
C            WRITE ( CMON, '(1X,A,2(1X,A2,I4),4(2X,F5.3))')
C     1       CBONDS(ITYPE),
C     2       IAT1N, IAT1S,
C     2       IAT2N, IAT2S,
C     4       BLEN,
C     5       BMEAN,
C     6       BSTDEV,
C     7       BOUT
C             CALL XPRVDU(NCVDU, 1,0)
C
C
Cc            WRITE ( CMON, '(A,2(A,A2,I4),A,F5.3,A,/,3(A,F5.3))')
Cc     1      CBONDS(ITYPE),
Cc     2       ' bond: ', IAT1N, IAT1S,
Cc     2       ' to ', IAT2N, IAT2S,
Cc     4       ' is ', BLEN, 'angstroms. ',
Cc     5       ' Mean is ', BMEAN,
Cc     6       ' Stddev is ',BSTDEV,
Cc     7       ' Devs out: ',BOUT
C
Cc             CALL XPRVDU(NCVDU, 2,0)
C
CC Update FOMS.
C
C            RFOM = RFOM + BOUT
C            IF ( BOUT .GT. RBAD ) THEN
C                  RBAD = BOUT
C                  KBAD = I
C            ENDIF
C            IF ( I .EQ. NFOM ) THEN
C                  SFOM = BOUT
C            ENDIF
C
C700         CONTINUE
C         END IF
C800   CONTINUE
C
C      RFOM = RFOM / KCOUNT
C
C      WRITE (CMON,'(/,A,F5.3/)')
C     2      '                                 Average Z-score ',
C     3      RFOM
C            CALL XPRVDU(NCVDU, 3,0)
C
C
CC Check angles.
C
C
C      WRITE (CMON,'(A)') 'BONDCK: Checking angles:'
C      CALL XPRVDU(NCVDU, 1,0)
C
C
C      RAFOM = 0.0
C      KABAD1 = 0
C      KABAD2 = 0
C      RABAD = 0.0
C
C      KCOUNT = 0
C
C      IFIRST=1
C
CC Check each angle once.
C      DO I = 1, NB18
CC Bonds not to be checked are flagged non zero at offset 9.
C         IF ( IBLK (I,9) .EQ. 0 ) THEN
C            IAT1N = IBLK(I,1)
C            IAT1S = NINT(BBLK(I,2))
C            IAT2N = IBLK(I,3)
C            IAT2S = NINT(BBLK(I,4))
C
CC Search for a bond with one atom in common.
C
C            DO II = I+1, NB18
C
C              IF ( IBLK (II,9).EQ.0) THEN
C                IAT3N = IBLK(II,1)
C                IAT3S = NINT(BBLK(II,2))
C                IAT4N = IBLK(II,3)
C                IAT4S = NINT(BBLK(II,4))
C
C                IF ( ( IAT1N .EQ. IAT3N ) .AND.
C     1               ( IAT1S .EQ. IAT3S ) ) THEN
C                  IANG1N=IAT1N
C                  IANG1S=IAT1S
C                  IANG2N=IAT2N
C                  IANG2S=IAT2S
C                  IANG3N=IAT4N
C                  IANG3S=IAT4S
C                ELSE IF ( ( IAT1N .EQ. IAT4N ) .AND.
C     1                    ( IAT1S .EQ. IAT4S ) ) THEN
C                  IANG1N=IAT1N
C                  IANG1S=IAT1S
C                  IANG2N=IAT2N
C                  IANG2S=IAT2S
C                  IANG3N=IAT3N
C                  IANG3S=IAT3S
C                ELSE IF ( ( IAT2N .EQ. IAT3N ) .AND.
C     1                    ( IAT2S .EQ. IAT3S ) ) THEN
C                  IANG1N=IAT2N
C                  IANG1S=IAT2S
C                  IANG2N=IAT1N
C                  IANG2S=IAT1S
C                  IANG3N=IAT4N
C                  IANG3S=IAT4S
C                ELSE IF ( ( IAT2N .EQ. IAT4N ) .AND.
C     1                    ( IAT2S .EQ. IAT4S ) ) THEN
C                  IANG1N=IAT2N
C                  IANG1S=IAT2S
C                  IANG2N=IAT1N
C                  IANG2S=IAT1S
C                  IANG3N=IAT3N
C                  IANG3S=IAT3S
C                ELSE
C                  GOTO 1900
C                END IF
C
CC Got an angle to test.
C
C                WRITE ( NCWU, '(3(A,A2,I4))')
C     2          ' angle: ', IANG2N, IANG2S,
C     2          ' to ', IANG1N, IANG1S,
C     2          ' to ', IANG3N, IANG3S
C
C
C                KCOUNT = KCOUNT + 1
C
CC Find this angle...
C                ANG1X = 0.0
C                ANG1Y = 0.0
C                ANG1Z = 0.0
C                ANG2X = 1.0
C                ANG2Y = 1.0
C                ANG2Z = 1.0
C                ANG3X = 2.0
C                ANG3Y = -2.0
C                ANG3Z = 2.0
C
C                DO J = L5,L5+((N5-1)*MD5),MD5
C
C                  IF ( (     ISTORE(J)    .EQ. IANG1N ) .AND.
C     1                 ( NINT(STORE(J+1)) .EQ. IANG1S ) ) THEN
C                    ANG1X = GUMTRX(1) * STORE(J+4)
C     1                    + GUMTRX(2) * STORE(J+5)
C     1                    + GUMTRX(3) * STORE(J+6)
C                    ANG1Y = GUMTRX(4) * STORE(J+4)
C     1                    + GUMTRX(5) * STORE(J+5)
C     1                    + GUMTRX(6) * STORE(J+6)
C                    ANG1Z = GUMTRX(7) * STORE(J+4)
C     1                    + GUMTRX(8) * STORE(J+5)
C     1                    + GUMTRX(9) * STORE(J+6)
C                    WRITE(NCWU,'(A)')'Got At1 coords'
C                  END IF
C                  IF ( (     ISTORE(J)    .EQ. IANG2N ) .AND.
C     1                 ( NINT(STORE(J+1)) .EQ. IANG2S ) ) THEN
C                    ANG2X = GUMTRX(1) * STORE(J+4)
C     1                    + GUMTRX(2) * STORE(J+5)
C     1                    + GUMTRX(3) * STORE(J+6)
C                    ANG2Y = GUMTRX(4) * STORE(J+4)
C     1                    + GUMTRX(5) * STORE(J+5)
C     1                    + GUMTRX(6) * STORE(J+6)
C                    ANG2Z = GUMTRX(7) * STORE(J+4)
C     1                    + GUMTRX(8) * STORE(J+5)
C     1                    + GUMTRX(9) * STORE(J+6)
C                    WRITE(NCWU,'(A)')'Got At2 coords'
C                  END IF
C                  IF ( (     ISTORE(J)    .EQ. IANG3N ) .AND.
C     1                 ( NINT(STORE(J+1)) .EQ. IANG3S ) ) THEN
C                    ANG3X = GUMTRX(1) * STORE(J+4)
C     1                    + GUMTRX(2) * STORE(J+5)
C     1                    + GUMTRX(3) * STORE(J+6)
C                    ANG3Y = GUMTRX(4) * STORE(J+4)
C     1                    + GUMTRX(5) * STORE(J+5)
C     1                    + GUMTRX(6) * STORE(J+6)
C                    ANG3Z = GUMTRX(7) * STORE(J+4)
C     1                    + GUMTRX(8) * STORE(J+5)
C     1                    + GUMTRX(9) * STORE(J+6)
C                    WRITE(NCWU,'(A)')'Got At3 coords'
C                  END IF
C                END DO
C                DST12S=((ANG1X-ANG2X)**2)
C     1                +((ANG1Y-ANG2Y)**2)
C     1                +((ANG1Z-ANG2Z)**2)
C                DST13S=((ANG1X-ANG3X)**2)
C     1                +((ANG1Y-ANG3Y)**2)
C     1                +((ANG1Z-ANG3Z)**2)
C                DST23S=((ANG3X-ANG2X)**2)
C     1                +((ANG3Y-ANG2Y)**2)
C     1                +((ANG3Z-ANG2Z)**2)
C                DST12=SQRT(DST12S)
C                DST13=SQRT(DST13S)
C
C                WRITE(NCWU,'(A,F10.5)')'DST12=',DST12
C                WRITE(NCWU,'(A,F10.5)')'DST13=',DST13
C
C                RANGLE=ACOS( (DST12S+DST13S-DST23S)/(2*DST12*DST13) )
C                ANGLE=RANGLE*180.0/3.141593
C                WRITE(NCWU,'(A,F10.5)')'ANGLE=',ANGLE
C
C                ABLK1(1) = ANG1N
C                ABLK2(1) = ANG2N
C                ABLK3(1) = ANG3N
C                ABLK1(2) = 0.0
C                ABLK2(2) = 0.0
C                ABLK3(2) = 0.0
C
CC Search for contacts to AT1.
C                DO J = 1, NB18
C                  IF((I.NE.J).AND.(II.NE.J)) THEN
C                    IF(    ( IANG1N.EQ.       IBLK(J,1)   )
C     1               .AND. ( IANG1S.EQ. NINT( BBLK(J,2) ) ) )THEN
C                      ABLK1(2)=NINT(ABLK1(2)) + 1.0
C                      ABLK1( 2 * NINT(ABLK1(2)) + 1 ) = BBLK(J,3)
C                      ABLK1( 2 * NINT(ABLK1(2)) + 2 ) = BBLK(J,6)
C                    ELSE IF(  ( IANG1N.EQ.       IBLK(J,3)   )
C     1               .AND. ( IANG1S.EQ. NINT( BBLK(J,4) ) ) )THEN
C                      ABLK1(2)=NINT(ABLK1(2)) + 1.0
C                      ABLK1( 2 * NINT(ABLK1(2)) + 1 ) = BBLK(J,1)
C                      ABLK1( 2 * NINT(ABLK1(2)) + 2 ) = BBLK(J,6)
C                    END IF
C                  ENDIF
C                END DO
C
CC Search for contacts to AT2.
C                DO J = 1, NB18
C                  IF((I.NE.J).AND.(II.NE.J)) THEN
C                    IF(       ( IANG2N.EQ.       IBLK(J,1)   )
C     1                  .AND. ( IANG2S.EQ. NINT( BBLK(J,2) ) ) )THEN
C                      ABLK2(2)=NINT(ABLK2(2)) + 1.0
C                      ABLK2( 2 * NINT(ABLK2(2)) + 1 ) = BBLK(J,3)
C                      ABLK2( 2 * NINT(ABLK2(2)) + 2 ) = BBLK(J,6)
C                    ELSE IF(  ( IANG2N.EQ.       IBLK(J,3)   )
C     1                  .AND. ( IANG2S.EQ. NINT( BBLK(J,4) ) ) )THEN
C                      ABLK2(2)=NINT(ABLK2(2)) + 1.0
C                      ABLK2( 2 * NINT(ABLK2(2)) + 1 ) = BBLK(J,1)
C                      ABLK2( 2 * NINT(ABLK2(2)) + 2 ) = BBLK(J,6)
C                    END IF
C                  ENDIF
C                END DO
C
CC Search for contacts to AT3.
C                DO J = 1, NB18
C                  IF((I.NE.J).AND.(II.NE.J)) THEN
C                    IF(       ( IANG3N.EQ.       IBLK(J,1)   )
C     1                  .AND. ( IANG3S.EQ. NINT( BBLK(J,2) ) ) )THEN
C                      ABLK3(2)=NINT(ABLK3(2)) + 1.0
C                      ABLK3( 2 * NINT(ABLK3(2)) + 1 ) = BBLK(J,3)
C                      ABLK3( 2 * NINT(ABLK3(2)) + 2 ) = BBLK(J,6)
C                    ELSE IF(  ( IANG3N.EQ.       IBLK(J,3)   )
C     1                  .AND. ( IANG3S.EQ. NINT( BBLK(J,4) ) ) )THEN
C                      ABLK3(2)=NINT(ABLK3(2)) + 1.0
C                      ABLK3( 2 * NINT(ABLK3(2)) + 1 ) = BBLK(J,1)
C                      ABLK3( 2 * NINT(ABLK3(2)) + 2 ) = BBLK(J,6)
C                    END IF
C                  ENDIF
C                END DO
C
CC Debugging{
C                WRITE(NCWU,'(A,27(A2,I2))')'ABLK1:',
C     1          (ABLK1(K),NINT(ABLK1(K+1)),K=1,NINT(ABLK1(2)+1.0)*2,2)
C                WRITE(NCWU,'(A,27(A2,I2))')'ABLK2:',
C     1          (ABLK2(K),NINT(ABLK2(K+1)),K=1,NINT(ABLK2(2)+1.0)*2,2)
C                WRITE(NCWU,'(A,27(A2,I2))')'ABLK3:',
C     1          (ABLK3(K),NINT(ABLK3(K+1)),K=1,NINT(ABLK3(2)+1.0)*2,2)
CC }Debugging
C
CC -- Generate unique name.
C
CC Sort ABLK1 into alphabetical order.
C                IF(NINT(ABLK1(2)).GE.2) THEN
C                  DO J = 2, NINT(ABLK1(2))
CC Pick out an element.
C                    WRITE(CTEMP,'(A4)')ABLK1(J*2+1)
C                    RTEMP = ABLK1(J*2+1)
C                    ITEMP = NINT(ABLK1(J*2+2))
CC Find place to insert.
C                    DO K = J - 1, 1, -1
C                      WRITE(CCOMP,'(A4)')ABLK1(K*2+1)
C                      ICOMP = KCHCMP(CCOMP,CTEMP)
C                      IF(      ( ICOMP.LT.0 )
C     1                 .OR. (  ( ICOMP.EQ.0 )
C     1                 .AND. (ITEMP.LT.(NINT(ABLK1(K*2+1))) )
C     1                   )
C     1                    ) GOTO 1290
CC Otherwise shift the others along.
C                      ABLK1(K*2+3) = ABLK1(K*2+1)
C                      ABLK1(K*2+4) = ABLK1(K*2+2)
C                    END DO
C                    K = 0
C1290                CONTINUE
C                    ABLK1(K*2+3) = RTEMP
C                    ABLK1(K*2+4) = ITEMP
C                  END DO
C                END IF
C
CC Sort ABLK2 into alphabetical order.
C                IF(NINT(ABLK2(2)).GE.2) THEN
C                  DO J = 2, NINT(ABLK2(2))
CC Pick out an element.
C                    WRITE(CTEMP,'(A4)')ABLK2(J*2+1)
C                    RTEMP = ABLK2(J*2+1)
C                    ITEMP = NINT(ABLK2(J*2+2))
CC Find place to insert.
C                    DO K = J - 1, 1, -1
C                      WRITE(CCOMP,'(A4)')ABLK2(K*2+1)
C                      IF( KCHCMP(CCOMP,CTEMP) .LT. 0 ) GOTO 1390 !Insert here
CC Shift the others along.
C                      ABLK2(K*2+3) = ABLK2(K*2+1)
C                      ABLK2(K*2+4) = ABLK2(K*2+2)
C                    END DO
C                    K = 0
C1390                CONTINUE
C                    ABLK2(K*2+3) = RTEMP
C                    ABLK2(K*2+4) = ITEMP
C                  END DO
C                END IF
C
C
CC Sort ABLK3 into alphabetical order.
C                IF(NINT(ABLK3(2)).GE.2) THEN
C                  DO J = 2, NINT(ABLK3(2))
CC Pick out an element.
C                    WRITE(CTEMP,'(A4)')ABLK3(J*2+1)
C                    RTEMP = ABLK3(J*2+1)
C                    ITEMP = NINT(ABLK3(J*2+2))
CC Find place to insert.
C                    DO K = J - 1, 1, -1
C                      WRITE(CCOMP,'(A4)')ABLK3(K*2+1)
C                      IF( KCHCMP(CCOMP,CTEMP) .LT. 0 ) GOTO 1440 !Insert here
CC Shift the others along.
C                      ABLK3(K*2+3) = ABLK3(K*2+1)
C                      ABLK3(K*2+4) = ABLK3(K*2+2)
C                    END DO
C                    K = 0
C1440                CONTINUE
C                    ABLK3(K*2+3) = RTEMP
C                    ABLK3(K*2+4) = ITEMP
C                  END DO
C                END IF
C
C
CC Work out which bond has precedence:
CC  Compare ring environent
C                IF ( IBLK(I,7) .GT. IBLK(II,7) ) GOTO 1500
C                IF ( IBLK(I,7) .LT. IBLK(II,7) ) GOTO 1550
CC  Compare element names
C                WRITE(CCOMP,'(A4)')IANG2N
C                WRITE(CTEMP,'(A4)')IANG3N
C                IF ( KCHCMP(CCOMP,CTEMP) .GT. 0 ) GOTO 1500
C                IF ( KCHCMP(CCOMP,CTEMP) .LT. 0 ) GOTO 1550
CC  Compare number of connections
C                IF ( NINT(ABLK2(2)) .GT. NINT(ABLK3(2)) ) GOTO 1500
C                IF ( NINT(ABLK2(2)) .LT. NINT(ABLK3(2)) ) GOTO 1550
CC  Compare each connection by name, and number of connections.
C                DO K = 1,NINT(ABLK2(2))
C                  WRITE(CCOMP,'(A4)')ABLK2(K*2+1)
C                  WRITE(CTEMP,'(A4)')ABLK3(K*2+1)
C                  IF ( KCHCMP(CCOMP,CTEMP) .GT. 0 ) GOTO 1500
C                  IF ( KCHCMP(CCOMP,CTEMP) .LT. 0 ) GOTO 1550
C                  IF (NINT(ABLK2(K*2+2)).GT.NINT(ABLK3(K*2+2)))GOTO 1500
C                  IF (NINT(ABLK2(K*2+2)).LT.NINT(ABLK3(K*2+2)))GOTO 1550
C                END DO
C
C1500            CONTINUE !BOND 1 (to ABLK2) has precedence
C                IRING1 = IBLK(I,7)
C                IRING2 = IBLK(II,7)
C                RBLK(1) = IRING1 + IRING2
C                RBLK(2) = BBLK(I,6)
C                RBLK(3) = BBLK(II,6)
C                IPL = 3
C                DO K = 1, NINT(ABLK1(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL) = ABLK1(K)
C                END DO
C                DO K = 1, NINT(ABLK2(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL) = ABLK2(K)
C                END DO
C                DO K = 1, NINT(ABLK3(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL) = ABLK3(K)
C                END DO
C                GOTO 1600
C1550            CONTINUE !BOND 2 (to ABLK3) has precedence
C                IRING1 = IBLK(I,7)
C                IRING2 = IBLK(II,7)
C                RBLK(1) = IRING1 + IRING2
C                RBLK(2) = BBLK(II,6)
C                RBLK(3) = BBLK(I,6)
C                IPL = 3
C                DO K = 1, NINT(ABLK1(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL) = ABLK1(K)
C                END DO
C                DO K = 1, NINT(ABLK3(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL) = ABLK3(K)
C                END DO
C                DO K = 1, NINT(ABLK2(2)*2)+2
C                  IPL=IPL+1
C                  RBLK(IPL) = ABLK2(K)
C                END DO
C                GOTO 1600
C1600            CONTINUE
C
C                WRITE(CCODE,'(A4,3I2,27(A2,I2))') 'ANGLE',
C     1          NINT(RBLK(1)),NINT(RBLK(2)),NINT(RBLK(3)),
C     1          ( RBLK(K),NINT(RBLK(K+1)), K=4,IPL,2)
CC Remove spaces from CCODE.
C                CALL XCRAS(CCODE,NDUM)
C
C
CC Debugging{
C            WRITE(NCWU,'(A)')CCODE
CC }Debugging
C
C
CC Check for this bond type in the local database.
CC If it is present compare bond length to mean and stddev of data.
CC If it is not present write out a file for obtaining the data.
C##LINGIL                CFILEN = 'CRYSDIR:script\angldata.cdb'
C&&LINGIL                CFILEN = 'CRYSDIR:script/angldata.cdb'
C                CALL MTRNLG(CFILEN,'OLD',ILENG)
C                IF(KFLOPN(NCFPU1,CFILEN(1:ILENG),ISSOLD,ISSREA,1,ISSSEQ)
C     1              .LE. -1) GOTO 1650
C
CC Search for this angle type in that file.
C1610            CONTINUE
C                  READ(NCFPU1,'(A)',END=1650)CLINE
C                  IF(CLINE.EQ.CCODE) GOTO 1680
C                GOTO 1610
C
CC Bond type not found in cdb file.
C1650            CONTINUE
C                CLOSE(NCFPU1)
CC Check for a .tab file with information about this bond.
C                CALL XCTRIM(CCODE,NCHAR)
C                NCHAR = NCHAR - 1
C                CFILEN = CCODE(1:NCHAR)//'.tab'
C                CALL MTRNLG(CFILEN,'OLD',ILENG)
C                IF(KFLOPN(NCFPU1,CFILEN(1:ILENG),ISSOLD,ISSREA,1,ISSSEQ)
C     1              .LE. -1) GOTO 1670
C1660            CONTINUE
CC Starting from the 9th line, read value every 4 lines.
C                DO K=1,8
C                  READ(NCFPU1,'(A)',END=1667)CDUM
C                END DO
CC Accumulate X for mean in first pass.
C                NUMX  = 0
C                SUMX  = 0.0
CC File might be empty. If an err now, skip to 1662
C                READ(NCFPU1,'(F8.3)',END=1662,ERR=1662) VAL
C1661            CONTINUE
C                  SUMX  = SUMX  + VAL
C                  NUMX  = NUMX + 1
C                  IF(NUMX.GE.4000)GOTO 1662
C                  DO K=1,3
C                    READ(NCFPU1,'(A)',END=1662)CDUM
C                  END DO
C                  READ(NCFPU1,'(F8.3)',END=1662,ERR=9910) VAL
C                GOTO 1661
C1662            CONTINUE
C                REWIND (NCFPU1)
CC Starting from the 9th line, read value every 4 lines.
C                DO K=1,8
C                  READ(NCFPU1,'(A)',END=1667)CDUM
C                END DO
CC Second pass to get first (absolute), second , third and fourth moments of deviation.
C                AMEAN  = SUMX / MAX(1,NUMX)
C                ADEV = 0.0
C                VARI = 0.0
C                SKEW = 0.0
C                CURT = 0.0
C                ASTDEV = 0.0
C                IF (NUMX .GE. 2) THEN
C                  NUMX = 0
C1663              CONTINUE
C                  READ(NCFPU1,'(F8.3)',END=1664,ERR=9910) VAL
C                    S = VAL - AMEAN
C                    ADEV = ADEV + ABS(S)
C                    P = S * S
C                    VARI = VARI + P
C                    P = P * S
C                    SKEW = SKEW + P
C                    P = P * S
C                    CURT = CURT + P
C                    NUMX = NUMX + 1
C                    IF ( NUMX .GE. 4000 ) GOTO 1664
C                    DO K=1,3
C                      READ(NCFPU1,'(A)',END=1664)CDUM
C                    END DO
C                  GOTO 1663
C1664              CONTINUE
C                  ADEV = ADEV / NUMX
C                  VARI = VARI / ( NUMX - 1 )
C                  ASTDEV = SQRT ( VARI )
C                  IF ( VARI .NE. 0 ) THEN
C                    SKEW = SKEW/(NUMX*ASTDEV**3)
C                    CURT = CURT/(NUMX*VARI**2)-3.0
C                  ELSE
C                    SKEW = 0
C                    CURT = 0
C                  END IF
C                END IF
C
C                GOTO 1668
C
C1667            CONTINUE
CC No results in .tab file.
C                AMEAN  = 0
C                SUMX =0.0
C                NUMX=0
C                ADEV = 0.0
C                VARI = 0.0
C                SKEW = 0.0
C                CURT = 0.0
C                ASTDEV = 0.0
C
C1668            CONTINUE
C
C                CLOSE ( NCFPU1 )
C
CC Write this info to the cdb file for future use.
C##LINGIL                CFILEN = 'CRYSDIR:script\angldata.cdb'
C&&LINGIL                CFILEN = 'CRYSDIR:script/angldata.cdb'
C                CALL MTRNLG(CFILEN,'UNKNOWN',ILENG)
C                IF(KFLOPN(NCFPU1,CFILEN(1:ILENG),ISSCIF,ISSWRI,1,ISSSEQ)
C     1              .LE. -1) GOTO 9920
CC Read to the end.
C1665            CONTINUE
C                  READ(NCFPU1,'(A)',END=1666) CDUM
C                GOTO 1665
C1666            CONTINUE
CC Add the info.
C                WRITE(NCFPU1,'(A)')CCODE
C                WRITE(NCFPU1,'(3F10.5,2G20.10,I10)')AMEAN,ASTDEV,ADEV,
C     1                                              SKEW, CURT, NUMX
C                CLOSE (NCFPU1)
C                GOTO 1681 !Carry on with analysis.
C
CC There is no entry in .cdb file and no .tab file.
CC Write a quest input file to generate bond data.
C1670            CONTINUE !No tab file, write out an .if for quest.
C                WRITE(CMON, '(A,/,5A)')'Angle not found. Run quest.',
C     1          'quest -j ',CCODE(1:NCHAR),' -if ',CCODE(1:NCHAR),'.if'
C                CALL XPRVDU(NCVDU, 2,0)
C                CALL XCTRIM(CCODE,NCHAR)
C                NCHAR=NCHAR-1
C                CFILEN = CCODE(1:NCHAR)//'.if'
C                CALL MTRNLG(CFILEN,'UNKNOWN',ILENG)
C                IF(KFLOPN(NCFPU1,CFILEN(1:ILENG),ISSCIF,ISSWRI,1,ISSSEQ)
C     1              .LE. -1) GOTO 9920
C                WRITE(NCFPU1,'(A)')'T1 *CONN'
C                WRITE(NCFPU1,'(A)')'ELDEF Q= AA'
C                WRITE(NCFPU1,'(A,A2,I4)')
C     1                             'AT1 ',ABLK1(1),NINT(ABLK1(2)+2.0)
C                WRITE(NCFPU1,'(A,A2,I4)')
C     1                             'AT2 ',ABLK2(1),NINT(ABLK2(2)+1.0)
C                WRITE(NCFPU1,'(A,A2,I4)')
C     1                             'AT3 ',ABLK3(1),NINT(ABLK3(2)+1.0)
C                IATM=4
C                DO K=1,NINT(ABLK1(2))
C                  WRITE(CCOMP,'(I4)')IATM
C                  CALL XCRAS(CCOMP,NLEN)
C                  WRITE(NCFPU1,'(A2,A4,2X,A2)')'AT',CCOMP,ABLK1(K*2+1)
C                  IATM = IATM + 1
C                END DO
C                DO K=1,NINT(ABLK2(2))
C                  WRITE(CCOMP,'(I4)')IATM
C                  CALL XCRAS(CCOMP,NLEN)
C                  WRITE(NCFPU1,'(A2,A4,2X,A2)')'AT',CCOMP,ABLK2(K*2+1)
C                  IATM = IATM + 1
C                END DO
C                DO K=1,NINT(ABLK3(2))
C                  WRITE(CCOMP,'(I4)')IATM
C                  CALL XCRAS(CCOMP,NLEN)
C                  WRITE(NCFPU1,'(A2,A4,2X,A2)')'AT',CCOMP,ABLK3(K*2+1)
C                  IATM = IATM + 1
C                END DO
C                IF(IRING1.EQ.1) THEN
C                  WRITE(NCFPU1,'(A,I2,A)')'BO 1 2 ',NINT(RBLK(2)),' C'
C                ELSE
C                  WRITE(NCFPU1,'(A,I2,A)')'BO 1 2 ',NINT(RBLK(2)),' A'
C                ENDIF
C                IF(IRING2.EQ.1) THEN
C                  WRITE(NCFPU1,'(A,I2,A)')'BO 1 3 ',NINT(RBLK(3)),' C'
C                ELSE
C                  WRITE(NCFPU1,'(A,I2,A)')'BO 1 3 ',NINT(RBLK(3)),' A'
C                ENDIF
C                IATM = 4
C                DO K=1,NINT(ABLK1(2))
C             WRITE(NCFPU1,'(A,I2,1X,I2)')'BO 1 ',IATM,NINT(ABLK1(K*2+2))
C                  IATM = IATM + 1
C                END DO
C                DO K=1,NINT(ABLK2(2))
C             WRITE(NCFPU1,'(A,I2,1X,I2)')'BO 2 ',IATM,NINT(ABLK2(K*2+2))
C                  IATM = IATM + 1
C                END DO
C                DO K=1,NINT(ABLK3(2))
C             WRITE(NCFPU1,'(A,I2,1X,I2)')'BO 3 ',IATM,NINT(ABLK3(K*2+2))
C                  IATM = IATM + 1
C                END DO
C                WRITE(NCFPU1,'(A)')'GEOM'
C                WRITE(NCFPU1,'(A)')'DEFINE A1 2 1 3'
C                WRITE(NCFPU1,'(A)')'NFRAG -99'
C                WRITE(NCFPU1,'(A)')'SYMCHK ON'
C                WRITE(NCFPU1,'(A)')'ENANT NOIN'
C                WRITE(NCFPU1,'(A)')'END'
C                WRITE(NCFPU1,'(A)')'STOP 4000'
C                WRITE(NCFPU1,'(A)')'QUEST T1'
C                CLOSE (NCFPU1)
C                KBNDCH = 1    !Signal incomplete processing on return
C                GOTO 1900
C
CC Bond type found print out data
C1680            CONTINUE
C                READ(NCFPU1,'(A)',END=9900) CLINE
C                READ(CLINE,'(F10.0,F10.0)') AMEAN, ASTDEV
C                CLOSE(NCFPU1)
C1681            CONTINUE
C
C                AOUT=MIN(ABS((ANGLE-AMEAN)/MAX(0.0001,ASTDEV)),1000.0)
C
C
C            IF (IFIRST .EQ. 1) THEN
C                IFIRST = 0
C                WRITE (CMON,'(A,/,A,/,A)')
C     1      ' Angle  with   and    Actual Ideal  Sample Z-',
C     2      ' about  atom   atom   angle  angle  stddev score',
C     3      ' '
C            CALL XPRVDU(NCVDU, 3,0)
C            END IF
C
C            WRITE ( CMON, '(3(1X,A2,I4),4(1X,F6.2))')
C
C     2          IANG2N, IANG2S,
C     2          IANG1N, IANG1S,
C     2          IANG3N, IANG3S,
C     4          ANGLE,  AMEAN,
C     6          ASTDEV, AOUT
C             CALL XPRVDU(NCVDU, 1,0)
C
Cc                WRITE ( CMON, '(A,3(A,A2,I4),A,F7.3,A,/,3(A,F7.3))')
Cc     1          CBONDS(ITYPE),
Cc     2          ' angle: ', IANG2N, IANG2S,
Cc     2          ' to ', IANG1N, IANG1S,
Cc     2          ' to ', IANG3N, IANG3S,
Cc     4          ' is ', ANGLE, 'degrees. ',
Cc     5          ' Mean is ', AMEAN,
Cc     6          ' Stddev is ',ASTDEV,
Cc     7          ' Devs out: ',AOUT
Cc                CALL XPRVDU(NCVDU, 2,0)
C
CC Update FOMS.
C
C                RAFOM = RAFOM + AOUT**2
C                WRITE(NCWU,'(A,F20.10)')'ANGLE = ',ANGLE
C                WRITE(NCWU,'(A,F20.10)')'AMEAN = ',AMEAN
C                WRITE(NCWU,'(A,F20.10)')'ASTDEV = ',ASTDEV
C                WRITE(NCWU,'(A,F20.10)')'AOUT = ',AOUT
C                WRITE(NCWU,'(A,F20.10)')'Rafom = ',RAFOM
C                IF ( AOUT .GT. RABAD ) THEN
C                  RABAD = AOUT
C                  KABAD1 = I
C                  KABAD2 = II
C                ENDIF
C
C              END IF
C1900          CONTINUE
C            END DO
C         END IF
C      END DO
C
C      IF(KCOUNT .GT. 0) RAFOM = RAFOM / KCOUNT
C      WRITE(NCWU,'(A,F20.10)')'Rafom = ',RAFOM
C
C      IF(RAFOM.GT.0.0)  RAFOM = SQRT ( RAFOM )
C      WRITE(NCWU,'(A,F20.10)')'Rafom = ',RAFOM
C
C      RETURN
C
C9900  CONTINUE
C      WRITE (CMON,'(A)')
C     1     'Bond checking requires valid bonddata.cbd file.'
C      CALL XPRVDU(NCVDU, 1,0)
C      RETURN
C
C9910  CONTINUE
C      WRITE(CMON,'(A)')
C     1     'ERROR Reading REAL value from .tab file.'
C      CALL XPRVDU(NCVDU, 1,0)
C      RETURN
C
C9920  CONTINUE
C      WRITE(CMON,'(A,/,A)')
C     1     'Could not open file for writing:',CFILEN
C      CALL XPRVDU(NCVDU, 2,0)
C      RETURN
C
C      END
C
C
C-----+--------+---------+---------+---------+---------+---------+-----+


C Move this to characte.src eventually? It is a function
C for comparing strings during a sort.

CCODE FOR XCCOMP
CC If the 1st arg is characterly less    than the 2nd return -1
CC If the 1st arg is characterly greater than the 2nd, return +1
CC If they are equal, return 0.
C      INTEGER FUNCTION KCHCMP(CHAR1, CHAR2)
C      CHARACTER*(*) CHAR1, CHAR2
C
C      ILM = MIN ( LEN(CHAR1), LEN(CHAR2) )
C
C      DO 100 I = 1, ILM
C            IF( ICHAR(CHAR1(I:I)) .GT. ICHAR(CHAR2(I:I)) ) THEN
C                  KCHCMP = 1
C                  RETURN
C            ELSE IF( ICHAR(CHAR1(I:I)) .LT. ICHAR(CHAR2(I:I)) ) THEN
C                  KCHCMP = -1
C                  RETURN
C            END IF
C100   CONTINUE
C      KCHCMP = 0
C      RETURN
C      END
C

C-----+--------+---------+---------+---------+---------+---------+-----+

CODE FOR BONDTY
      SUBROUTINE BONDTY(INEW41)

C     INEW41 - normally 0, set to 1 if caller is in process of creating
C              a new L41 from scratch.

C     Call CSD bond assignment routine.
C     Setup atom arrays from list 5
C     Calculate a bond list.
C     Need to expand fragment using symmetry - therfore need to
C     look out for POLYMERIC structures.

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

C ........... Molecule Viewer Atom DATa .............
C INT  TATOM             : total number of atoms to be displayed
C INT  AXYZO   : ptr to atom orthogonal Angstrom coordinates
C INT  AELEM   : ptr to element code array in store. (as given by MVELEM)  (set in GET3D)
C INT  ATRESN  : ptr to residue number of each atom            (set in GET3D)
      INTEGER TATOM, AELEM, AXYZO, ATRESN, HYBR
      COMMON /MVADAT/ TATOM,AXYZO,AELEM, ATRESN, HYBR
C..........................................................................
C
C ........... Molecule Viewer Bond DATa .............
C INT  TBOND          : total number of atoms to be displayed
C INT  BOND           : ptr to the atom numbers at either end of BOND number i
C INT  BTYPE          : ptr to CCDC bond type number                (set in GET3D)
       INTEGER TBOND, BOND, BTYPE
       COMMON /MVBDAT/ TBOND,BOND,BTYPE
C-- query connectivity
      INTEGER NHYC,NCAC
      INTEGER NATCRY,NBOCRY
      COMMON /PLUTQY/ NHYC,NCAC,NATCRY,NBOCRY
      INTEGER  ATCHG, AROMA, NAROMA
      COMMON /PLUTAC/ ATCHG, AROMA, NAROMA

C-- ILIST  controls output to listing file  (usually =0  off)
C-- IDEBUG controls output to listing file  (usually =0  off)
      INTEGER ILIST, IDEBUG
      COMMON /PLUTLI/ ILIST, IDEBUG
C
C-------------------- END CSDS COMMON --------------
C----------------- START CRYSTALS COMMON ----------

      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XGUIOV.INC'

      CHARACTER CCOL*6, WCLINE*80, CFILEN*256, CATTYP*4
      LOGICAL WEXIST

C\TLST18

      INTEGER IPLACE, I, J, IATTYP, K, KELT, NATINF
      INTEGER IRED, IGRE, IBLU, ILENG, IBCN, IAT1P, NFOUND, IAT2P
      INTEGER IAT1, IAT2, ISERIA
      INTEGER KFLOPN, ICRDIST1
      EXTERNAL KFLOPN, ICRDIST1
      REAL    VDW, COV, ACTDST, COV1, COV2, RMXDST, RMNDST, XX, XY, XZ
      REAL  RLENTH, TMPLEN

      DIMENSION TXYZ(3)

      REAL STACK(500)     !Space for 100 contacts.

      INCLUDE 'QGUIOV.INC'
      CHARACTER*2 EL(133)

      INTEGER IOFF
      DATA IOFF /4/    !Offset of positional parameters in LIST 5.
C                      !Needed when using a compressed L5 during FOURIER.
#if defined (_HOL_)
      DATA KHYD /4HH   /
      DATA KDET /4HD   /
#else
      DATA KHYD /'H   '/
      DATA KDET /'D   '/
#endif
      DATA EL/'C ','H ','AC','AG','AL','AM','AR','AS','AT','AU','B ',
     +     'BA','BE','BI','BK','BR','CA','CD','CE','CF','CL','CM','CO',
     +     'CR','CS','CU','D ','DY','ER','ES','EU','F ','FE','FM','FR',
     +     'GA','GD','GE','HE','HF','HG','HO','I ','IN','IR','K ','KR',
     +     'LA','LI','LU','LW','MD','MG','MN','MO','N ','NA','NB','ND',
     +     'NE','NI','NO','NP','O ','OS','P ','PA','PB','PD','PM','PO',
     +     'PR','PT','PU','RA','RB','RE','RH','RN','RU','S ','SB','SC',
     +     'SE','SI','SM','SN','SR','TA','TB','TC','TE','TH','TI','TL',
     +     'TM','U ','V ','W ','X ','XE','Y ','YB','Z ','ZN','ZR','ZZ',
     +     'PH','PY','CP','ET','BU','TF','TP','AY','XA','MA','AC','CO',
     +     'CN','TO','IO','NT','SU','PC','FB','OH','MP','PR','NM','SM',
     +     'PT','PS'/

      IDEBUG =0 !Set to zero for no debugging

      STDOUTTERM = 99


      IF(KEXIST(1).LE.0) GOTO 9910
      IF(KEXIST(2).LE.0) GOTO 9910
      IF(KEXIST(5).LE.0) GOTO 9910
      IF((INEW41.EQ.0).AND.(KEXIST(41).LE.0)) GOTO 9910
      IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL01
      IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL02
      IF(KHUNTR(5,0,IADDL,IADDR,IADDD,-1).NE.0)  CALL XFAL05
      IF((INEW41.EQ.0).AND.(KHUNTR(41,0,IADDL,IADDR,IADDD,-1).NE.0))
     1     CALL XFAL41
      IF ( IERFLG .LT. 0 ) GO TO 9920


C How many symm related atoms are in L41?

      NSYM = 0
      DO I = 0, N41B-1
        M41B = L41B + I * MD41B
        IF ( (ISTORE(M41B+1).NE.1 ).OR.(ISTORE(M41B+2 ).NE.1).OR.
     +       (ISTORE(M41B+3).NE.0 ).OR.(ISTORE(M41B+4 ).NE.0).OR.
     +       (ISTORE(M41B+5).NE.0 ) ) NSYM = NSYM + 1

        IF ( (ISTORE(M41B+7) .NE.1).OR.(ISTORE(M41B+8 ).NE.1).OR.
     +       (ISTORE(M41B+9) .NE.0).OR.(ISTORE(M41B+10).NE.0).OR.
     +       (ISTORE(M41B+11).NE.0) ) NSYM = NSYM + 1
      END DO

c      WRITE(CMON,'(A,I5)')'Sym atoms in L41: ', NSYM
c      CALL XPRVDU(NCVDU, 1,0)


      AELEM = KSTALL(N5+NSYM)
      NHYC  = KSTALL(N5+NSYM)
      NCAC  = KSTALL(N5+NSYM)
      ATRESN= KSTALL(N5+NSYM)
      HYBR  = KSTALL(N5+NSYM)
      ATCHG = KSTALL(N5+NSYM)
      AXYZO = KSTALL(3*(N5+NSYM))
      BOND  = KSTALL(2*N41B)
      BTYPE = KSTALL(N41B)
      AROMA = KSTALL(N41B*2) !Aromatic rings (can't be more than N41B/4!) need 7 bytes for each.
      NAROMA = 0


C Check for valid pointers to lists.
      IF ((.NOT.LGUIL1) .AND. (.NOT.LGUIL2)) THEN
               GOTO 9900
      ENDIF

C Fill in CSD atom data structures (for asymmetric unit atoms).
      DO I = 0, N5-1
         I5 = L5+I*MD5
         IA = AXYZO+I*3
         CALL XMLTTM(STORE(L1O1),STORE(I5+4),
     +               STORE(IA),3,3,1)               !Ortho coords.
         ISTORE(NCAC+I) = 0
         ISTORE(HYBR+I) = 0
         ISTORE(NHYC+I) = 0                         !H count - set later.
         ISTORE(ATRESN+I) = 1                       !Residue # (-ve to suppress)
         WRITE ( CATTYP,'(A4)') ISTORE(I5)          !Find element #
         ISTORE(AELEM+I) = 1                        !Default to carbon
         IF(CATTYP(1:2).EQ.'QH') CATTYP(1:2)='H '   !Remove QH's
         DO KELT = 1, 133
            IF(EL(KELT).EQ.CATTYP(1:2)) THEN
               ISTORE(AELEM+I) = KELT
               EXIT
            ENDIF
         ENDDO
      END DO


      NEXTRA = N5
C Fill in CSD bond data structures + any extra symm related atoms.
      DO I = 0,N41B-1
        M41B = L41B + I * MD41B
        ISTORE(BOND+2*I)   = ISTORE(L41B+MD41B*I)   + 1
        ISTORE(BOND+2*I+1) = ISTORE(L41B+MD41B*I+6) + 1
        ISTORE(BTYPE+I)    = - ISTORE(L41B+MD41B*I+12)
        IF ( (ISTORE(M41B+1).NE.1 ).OR.(ISTORE(M41B+2 ).NE.1).OR.
     +       (ISTORE(M41B+3).NE.0 ).OR.(ISTORE(M41B+4 ).NE.0).OR.
     +       (ISTORE(M41B+5).NE.0 ) ) THEN
            IAP = L5 + ISTORE(M41B) * MD5
            M2 = L2 + ( MIN(N2,ABS(ISTORE(M41B+1))) - 1) * MD2
            M2P =L2P+ ( MIN(N2P,ISTORE(M41B+2))     - 1) * MD2P
            CALL XMLTTM(STORE(M2),STORE(4+IAP),TXYZ(1),3,3,1)
            IF (ISTORE(M41B+1).LT.0)CALL XNEGTR(TXYZ(1),TXYZ(1),3)
            DO L = 0,2
              TXYZ(1+L) = TXYZ(1+L) +STORE(M2P+L) +STORE(M2+9+L)
     1                              +ISTORE(M41B+3+L)
            END DO
            CALL XMLTTM(STORE(L1O1),TXYZ(1),STORE(AXYZO+NEXTRA*3),3,3,1)
            ISTORE(NCAC+NEXTRA) = 0
            ISTORE(HYBR+NEXTRA) = 0
            ISTORE(NHYC+NEXTRA) = 0   
            ISTORE(ATRESN+NEXTRA) = 1
            ISTORE(AELEM+NEXTRA) = ISTORE(AELEM+ISTORE(M41B))
            ISTORE(BOND+2*I)   = NEXTRA + 1
            NEXTRA = NEXTRA + 1
        ENDIF
        IF ( (ISTORE(M41B+7) .NE.1 ).OR.(ISTORE(M41B+8 ).NE.1).OR.
     +       (ISTORE(M41B+9) .NE.0 ).OR.(ISTORE(M41B+10).NE.0).OR.
     +       (ISTORE(M41B+11).NE.0) ) THEN
            IAP = L5 + ISTORE(M41B+6) * MD5
            M2 = L2 + ( MIN(N2,ABS(ISTORE(M41B+7))) - 1) * MD2
            M2P =L2P+ ( MIN(N2P,ISTORE(M41B+8))     - 1) * MD2P
            CALL XMLTTM(STORE(M2),STORE(4+IAP),TXYZ(1),3,3,1)
            IF (ISTORE(M41B+7).LT.0)CALL XNEGTR(TXYZ(1),TXYZ(1),3)
            DO L = 0,2
              TXYZ(1+L) = TXYZ(1+L) +STORE(M2P+L) +STORE(M2+9+L)
     1                              +ISTORE(M41B+9+L)
            END DO
            CALL XMLTTM(STORE(L1O1),TXYZ(1),STORE(AXYZO+NEXTRA*3),3,3,1)
            ISTORE(NCAC+NEXTRA) = 0
            ISTORE(HYBR+NEXTRA) = 0
            ISTORE(NHYC+NEXTRA) = 0   
            ISTORE(ATRESN+NEXTRA) = 1
            ISTORE(AELEM+NEXTRA) = ISTORE(AELEM+ISTORE(M41B+6))
            ISTORE(BOND+2*I+1) = NEXTRA + 1
            NEXTRA = NEXTRA + 1
        END IF
      END DO
      NBOCRY = N41B
      TBOND  = N41B
      NATCRY = NEXTRA
      TATOM  = NEXTRA

Check:
c       WRITE (CMON,'(A,I4,A,I4)')'Atoms: ',NATCRY,' Bonds:',NBOCRY
c       CALL XPRVDU(NCVDU,1,0)

c      DO I = 1,NATCRY
c            WRITE(CMON,'(A3,3F15.8)')
c     1     EL(ISTORE(AELEM-1+I)),(STORE(AXYZO+3*I-4+J),J=1,3)
c            CALL XPRVDU(NCVDU, 1,0)
c      ENDDO
c      DO I = 0,NBOCRY-1
c            I1 = ISTORE(BOND+2*I) 
c            I2 = ISTORE(BOND+2*I+1)
c            WRITE(CMON,'(2(A3,3F8.4))')
c     1     EL(ISTORE(AELEM-1+I1)),(STORE(AXYZO+3*I1-4+J),J=1,3),
c     1     EL(ISTORE(AELEM-1+I2)),(STORE(AXYZO+3*I2-4+J),J=1,3)
c            CALL XPRVDU(NCVDU, 1,0)
c      ENDDO

Calculate bond types:
      CALL SAMABO

c      DO I = 1,NATCRY
c         I5 = L5+((I-1)*MD5)
c         ISTORE(I5+16) = ISTORE(HYBR+I-1)
c      END DO

Check:
c      DO I = 1,NATCRY
c            WRITE(CMON,'(A3,I6,3F15.8)')
c     1       EL(ISTORE(AELEM-1+I)), ISTORE(HYBR+I-1),
c     1      (STORE(AXYZO+3*I-4+J),J=1,3)
c            CALL XPRVDU(NCVDU, 1,0)
c      ENDDO


Copy the bond type into L41B, and write out a summary.
      DO I = 0,NBOCRY-1
         IAT1P = L5+((ISTORE(BOND+2*I  )-1)*MD5)
         IAT2P = L5+((ISTORE(BOND+2*I+1)-1)*MD5)
         ISTORE(L41B+I*MD41B+12) = ABS(ISTORE(BTYPE+I))

c         WRITE ( CMON, '(A,I4,2(1X,A,I4))')
c     1             ' BONDTYPE ', ABS(ISTORE(BTYPE+I)),
c     1                 STORE(IAT1P),NINT(STORE(IAT1P+1)),
c     1                 STORE(IAT2P),NINT(STORE(IAT2P+1))!,
c         CALL XPRVDU(NCVDU, 1,0)
      END DO

c         WRITE ( CMON, '(A,I4,A)')
c     1             ' Found ', NAROMA, ' aromatic rings'
c         CALL XPRVDU(NCVDU, 1,0)


Copy the aromatic rings into L41S
      L41S = AROMA
      N41S = NAROMA
      ISTAT = KHUNTR(41,104,IADDL,IADDR,IADDD,-1)
      IF ( ISTAT.NE.0 ) GOTO 9930
      ISTORE(IADDR+3) = L41S   ! Change header pointer to data

c      DO I = L41S, L41S+(N41S-1)*MD41S, MD41S
c         WRITE(CMON,'(6I7)') (ISTORE(J),J=I,I+6)
c         CALL XPRVDU(NCVDU,1,0)
c      END DO


      RETURN

9900  CONTINUE
c      WRITE (CMON,'(A)') 'BONDTY: No LGUIL1, or no LGUIL2.'
c     CALL XPRVDU(NCVDU, 1,0)
      RETURN

9910  CONTINUE
c      WRITE ( CMON, '(A)')
c     1 'GUI-UP: BONDTY:Some required lists not present.'
c      CALL XPRVDU(NCVDU, 1,0)
      RETURN
9920  CONTINUE
9930  CONTINUE
      WRITE ( CMON, '(A)')'GUI-UP: BONDTY: Err finding rec in list 41.'
      CALL XPRVDU(NCVDU, 1,0)
      RETURN

      END


C-----+-------+-------+-------+-------+-------+-------+-------+-------++

CCODE FOR EMAP2D
C      SUBROUTINE EMAP2D (ICODE)
C
CC     Goto appropriate stage.  Use ICODE.
CC
CC     Stage 0
CC        Read in users idea of their structure.
CC        Make a list 18 from this data.
CC        Decide what to search for.
CC        Goto Stage 1.
CC
CC     Stage 1
CC        Delete #FIND output file.
CC        Write #FIND input file.
CC        Add "Execute search" to SRQ.
CC        Add "EMAP2D Stage2" to SRQ.
CC        RETURN
CC
CC     Stage 2
CC        Read #FIND output file for matches.
CC        For each structure
CC        {
CC          Lookup each bond in list 18 and list 5 and store its length
CC          Call kbndch to get a FOM for structure and for worst atom.
CC        }
CC        Decide what to search for (or whether to finish).
CC
CC A list of the bonds in the current query structure.
C      INTEGER PCBNDS(1500), NCBNDS
CC A list of bonds which have been added, then rejected.
C      INTEGER PRBNDS(1500), NRBNDS
CC A list of bonds used as starting points.
C      INTEGER PSBNDS(1500), NSBNDS
C
C      SAVE PCBNDS, NCBNDS, PRBNDS, NRBNDS, PSBNDS, NSBNDS
C
C      REAL BESTSF
C      SAVE BESTSF
C
C\XLST05
C\STORE
C\ISTORE
C\QSTORE
C\XUNITS
C\XIOBUF
C\XSSVAL
C\XOPVAL
C\XGUIOV
C      DIMENSION ITSTORE(MAXAT)
C
C      CHARACTER CLINE*80, CUPPER*80, CT*1, CSRQ*80
C      CHARACTER CCOL*6, WCLINE*80, CFILEN*256, CATTYP*4
C      LOGICAL WEXIST
C
C\TLST18
C
C      INTEGER NATMS, IATMS(1500,2)
C      SAVE IATMS, NATMS
C
C      LOGICAL LMATCH, LOPEN
C
C      INTEGER IPLACE, I, J, IATTYP, K, KELT, NATINF
C      INTEGER IRED, IGRE, IBLU, ILENG, IBCN, IAT1P, NFOUND, IAT2P
C      INTEGER IAT1, IAT2, ISERIA, PAT1, PAT2
C      INTEGER KFLOPN, ICRDIST1
C      EXTERNAL KFLOPN, ICRDIST1
C      REAL    VDW, COV, ACTDST, COV1, COV2, RMXDST, RMNDST, XX, XY, XZ
C      REAL  RLENTH, TMPLEN
C
C      REAL X1(3),X2(3)
C
C      REAL STACK(500)     !Space for 100 contacts.
CC
C\QGUIOV
C      EQUIVALENCE (TSTORE(1),ITSTORE(1))
C
C
C      WRITE(CMON,'(A)')'EMAP: This is Emap.'
C      CALL XPRVDU(NCVDU,1,0)
C
C
C
C10    CONTINUE
C
CC Go to appropriate stage -- SWITCH on ICODE
C
C      IF ( ICODE .EQ. 0 ) THEN
C
CC STAGE 0 -- Read in users data and build a list 18 for them.
C
C          WRITE(CMON,'(A)')'EMAP: Stage 0. Initialisation.'
C          CALL XPRVDU(NCVDU,1,0)
CC         -- Zero the bond list.
C
C          NB18 = 0
C
CC         -- Zero the atom list.
C
C          NATMS = 0
C
CC         -- Zero the bond accept, reject lists.
C
C          NCBNDS = 0
C          NRBNDS = 0
C          NSBNDS = 0
C
CC         -- Empty best matches file.
C
C          OPEN (75,FILE='GUESS.BEST',STATUS='UNKNOWN')
C          WRITE(75,'(A)')
C          CLOSE(75)
C
CC         -- Read file from fixed location for now (!).
C          WRITE(CMON,'(A)')'EMAP: Reading GUESS.DAT.'
C          CALL XPRVDU(NCVDU,1,0)
C
C          CFILEN = 'guess.dat'
C          CALL MTRNLG(CFILEN,'OLD',ILENG)
C          IF (KFLOPN (NCFPU1, CFILEN(1:ILENG), ISSOLD, ISSREA,1,ISSSEQ)
C     1        .LE. -1) GOTO 9010
C
C100       CONTINUE
C            READ (NCFPU1, '(A)', END = 200) CLINE
C            CALL XCCUPC(CLINE,CUPPER)
C
C            IF(CUPPER(1:2) .EQ. 'AT') THEN
C               NATMS=NATMS+1
CC Get atom serial
C               KAS = KGTNUM ( CLINE(3:), CT, NL)
CC Get element type
C               NS = KCCNEQ( CLINE, NL + 3, ' ' )
C               IF ( NS .LE. 0 ) GOTO 9020
C               NE = KCCEQL( CLINE, NS + 1, ' ' ) - 1
C               IF ( NE .LT. NS ) GOTO 9020
C               READ ( CUPPER ( NS:NE ), '(A)') CATTYP
CC Get max no. of connections. ( May be ommitted, so check first... )
C               NS = KCCNEQ( CLINE, NE + 1, ' ' )
C               IF ( NS .LE. 0 ) THEN
C                  KMC = 0
C                  GOTO 110
C               ENDIF
C               KMC = KGTNUM ( CLINE(NS:), CT, NL)
C110            CONTINUE
CC Store the data.
C               READ(CATTYP,'(A4)')IATMS(KAS,1)
C               IATMS(KAS,2) = KMC
C               GOTO 100
C            ENDIF
C            IF(CUPPER(1:2) .EQ. 'BO') THEN
CC Get atom1 serial
C               NS = KCCNEQ( CLINE, 3, ' ' )
C               IF ( NS .LE. 0 ) GOTO 9020
C               KAS1 = KGTNUM ( CLINE(NS:), CT, NL)
CC Get atom2 serial
C               NS = KCCNEQ( CLINE, NS + NL, ' ' )
C               IF ( NS .LE. 0 ) GOTO 9020
C               KAS2 = KGTNUM ( CLINE(NS:), CT, NL)
CC If present, get bond type
C               NS = KCCNEQ( CLINE, NS + NL, ' ' )
C               IF ( NS .LE. 0 ) THEN
C                  KBTY = 99
C                  GOTO 120
C               ENDIF
C               KBTY = KGTNUM ( CLINE(NS:), CT, NL)
C120            CONTINUE
CC Store this information in LIST18.
C               NB18 = NB18 + 1
CC 1&3 Element names:
C               IBLK ( NB18 , 1 ) = IATMS ( KAS1, 1 )
C               IBLK ( NB18 , 3 ) = IATMS ( KAS2, 1 )
CC 2&4 Serial numbers.
C               BBLK ( NB18 , 2 ) = KAS1
C               BBLK ( NB18 , 4 ) = KAS2
CC 5 Bond length is not known yet.
CC 6 Bond type:
C               BBLK ( NB18, 6 ) = KBTY
CC 7 Cyclic/acyclic. Work out later, when we've got all the bonds.
CC 8 Deviation is not known yet.
CC 9 Include flag. Decided in next stage.
Cc               WRITE(CMON,'(A,/,2(A4,F3.0,1X),I3)')
Cc     1         'AT1 SER AT2 SER TYPE',
Cc     1         (IBLK(NB18,I),I=1,4),NINT(BBLK(NB18,6))
Cc               CALL XPRVDU(NCVDU,2,0)
C               GOTO 100
C            ENDIF
CC Unrecognized line, ignore!
C          GOTO 100
CC End of file.
C200       CONTINUE
C
CC Quickly determine if the bond is cyclic:
CC         For each bond in the list:
C          DO I = 1, NB18
CC           Use ITSTORE to hold the flags for each atom.
C            DO J = 1, NATMS
C              ITSTORE(J) = 0
C            END DO
CC           TSTORE pointers to atom flag:
C            IAT1TP= NINT(BBLK(I,2))
C            IAT2TP= NINT(BBLK(I,4))
CC           Flag atom IAT1.
C            ITSTORE(IAT1TP) = 1
CC           Loop 12 times
C            DO J = 1, 12
CC             Loop through the bond list flagging
CC             all atoms bonded to flagged atoms.
C              DO K = 1, NB18
CC               Ignore the AT1-AT2 bond
C                IF ( I .NE. K ) THEN
C                  IATXTP = NINT(BBLK (K,2))
C                  IATYTP = NINT(BBLK (K,4))
CC                 Propogate flags to neighbours:
C                  IF (ITSTORE (IATXTP) .EQ. 1) ITSTORE (IATYTP) = 1
C                  IF (ITSTORE (IATYTP) .EQ. 1) ITSTORE (IATXTP) = 1
C                ENDIF
C              ENDDO
C            ENDDO
CC           If AT2 is now flagged, the bond is cyclic.
CC           IBLK(I,7) is 1 if the bond is cyclic, otherwise it is 0.
C            IBLK(I,7) = ITSTORE ( IAT2TP )
C          ENDDO
C
C
CC Make sure that the required CSD information is extracted now.
CC It gets rather boring if each time a bond is added, we have
CC to go away and get another set of data from QUEST.
C
CC Put in some dummy values for length. (5)
CC Include all user-supplied bonds (9)
C          DO I = 1, NB18
C            BBLK(I,5) = 1.0
C            IBLK(I,9) = 0
C          END DO
C
Cc      INTEGER FUNCTION KBNDCH ( RFOM,  KBAD,           RBAD,
Cc     1                          RAFOM, KABAD1, KABAD2, RABAD,
Cc     2                          NFOM,  SFOM )
C
C          IF ( KBNDCH ( RDV,  IDV, RDV2,
C     1                 RDV3, IDV2, IDV3, RDV4,
C     1                 1,    RDV5 ) .NE. 0 ) THEN
CC Bond not found in database or .tab file. Require processing of .if files.
C             WRITE(CMON,'(A)')'+----------------------------------+'
C             CALL XPRVDU(NCVDU,1,0)
C             WRITE(CMON,'(A)')'| EMAP: User intervention required.|'
C             CALL XPRVDU(NCVDU,1,0)
C             WRITE(CMON,'(A)')'|      Process CSD files now.      |'
C             CALL XPRVDU(NCVDU,1,0)
C             WRITE(CMON,'(A)')'+----------------------------------+'
C             CALL XPRVDU(NCVDU,1,0)
C             RETURN
C          ENDIF
C
C
CC Jump to stage1 -- decisions.
C          ICODE = 1
C          GOTO 10
C
C      ELSE IF ( ICODE .EQ. 1 ) THEN
C
CC STAGE 1 -- Decision time.
C
CCDebug!
C&GID            CLOSE(76)
C&GID            OPEN(76,FILE='EMAP.LOG',POSITION='APPEND')
CCDebug!
C
C            WRITE(CMON,'(A)')'EMAP: Stage 1. Decisions.'
C            CALL XPRVDU(NCVDU,1,0)
C            IF ( NCBNDS .EQ. 0 ) THEN
C              WRITE(76,'(A,I4)')'New start. Previous tries = ',NSBNDS
C              WRITE(CMON,'(A)')'EMAP: Starting with new bond.'
C              CALL XPRVDU(NCVDU,1,0)
CC Start from scratch. Select a bond and start searching.
CC Choose a bond which has not been started from already.
C              DO I = 1, NB18
C
C                 IUSED = 0
C
C                 DO J = 1, NSBNDS
C                    IF ( I .EQ. PSBNDS(J) ) THEN
C                        IUSED = 1
C                        GOTO 205
C                    ENDIF
C                 END DO
C
CC If IUSED.EQ.1 here, then this bond has already been used.
C
C205              CONTINUE
C
C                 IF (IUSED.EQ.0) GOTO 210
C
CC Otherwise, try the next bond.
C
C              END DO
C
CC Search start points exhausted, abort.
C              WRITE(CMON,'(A)') 'Search start points exhausted.'
C              CALL XPRVDU(NCVDU,1,0)
C              RETURN
C
C210           CONTINUE !New search start point found.
C
CC Add this bond to PCBNDS list.
C              NCBNDS = NCBNDS + 1
C              PCBNDS(NCBNDS) = I
C
CC Add this bond to PSBNDS list.
C              NSBNDS = NSBNDS + 1
C              PSBNDS(NSBNDS) = I
C
CC Since we are starting from a new point, empty the
CC rejected bonds list.
C              NRBNDS = 0
C
CC Exclude all bonds from search.
C              DO I = 1, NB18
C                  IBLK(I,9) = 1
C              END DO
CC Include all current bonds.
C              DO I = 1, NCBNDS
C                  IBLK(PCBNDS(I),9) = 0
C              END DO
C
C              CALL WFNDFL (NATMS,NCBNDS,PCBNDS)
C
CC Add commands to SRQ and return.
C
CC Copy current SRQ to STORE.
C              CALL XSSRQ(IADSRQ,NSRQ)
C
CC Add commands to SRQ
C              CSRQ = '#FIND'
C              CALL XISRC(CSRQ)
C              CSRQ = 'QUERY OVERLAP=YES FILE=GUESS.INS'
C              CALL XISRC(CSRQ)
C              CSRQ = 'OUTFILE FILE=GUESS.RES'
C              CALL XISRC(CSRQ)
C              CSRQ = 'END'
C              CALL XISRC(CSRQ)
C              CSRQ = '#EMAP2'
C              CALL XISRC(CSRQ)
C
CC Restore SRQ to file from STORE..
C              CALL XRSRQ(IADSRQ,NSRQ)
C
C              RETURN
C
C
C            ELSE
C
C
CC Not the first time. Analyse results of previous search.
CC Did it fail? Was the FOM for the latest bond obscene?
C
C               IF (.NOT.LMATCH) THEN
CC There was no match. The last added bond was duff.
CC Add it to the reject list.
C                  WRITE(76,'(2(A,I4))')'No match. Structure size = ',
C     1            NCBNDS, ' Rejected bonds = ', NRBNDS
C
C                  NRBNDS = NRBNDS + 1
C                  PRBNDS(NRBNDS) = PCBNDS(NCBNDS)
CC Remove it from current bonds list.
C                  NCBNDS = NCBNDS - 1
C
C                  IF ( NCBNDS .EQ. 0 ) THEN
CC If this leaves no current bonds, start again.
C                        ICODE = 1
C                        GOTO 10
C                  END IF
C               ELSE
CC Check returned FOM values.
C
C                 IF ( BESTSF .GT. 15.0 ) THEN
C
C                   WRITE(76,'(2(A,I4))')'Bad bond. Structure size = ',
C     1             NCBNDS, ' Rejected bonds = ', NRBNDS
C
C                   NRBNDS = NRBNDS + 1
C                   PRBNDS(NRBNDS) = PCBNDS(NCBNDS)
CC Remove it from current bonds list.
C                   NCBNDS = NCBNDS - 1
C
C                   IF ( NCBNDS .EQ. 0 ) THEN
CC If this leaves no current bonds, start again.
C                        ICODE = 1
C                        GOTO 10
C                   END IF
C
C                 END IF
C
C               ENDIF
C
C
C
C
C
C
CC Find a new bond to add to the structure.
C
CC Criteria: Must not be in the structure already.
CC           Must not be rejected.
CC           Must be bonded to an atom in the current bonds list.
C
CC Loop through the bonds...
C
C               DO I = 1, NB18
Cc                  WRITE(CMON,'(A,I4,A)') 'Can I add bond - ', I, '?'
Cc                  CALL XPRVDU(NCVDU,1,0)
C                  IOK = 1
CC Check for already included.
C                  DO J = 1, NCBNDS
C                     IF ( I .EQ. PCBNDS(J) ) GOTO 250
C                  END DO
CC                  WRITE(CMON,'(A,I4,A)') 'Maybe, it isn''t added.'
CC                  CALL XPRVDU(NCVDU,1,0)
CC Check for rejected.
C                  DO J = 1, NRBNDS
C                     IF ( I .EQ. PRBNDS(J) ) GOTO 250
C                  END DO
CC                  WRITE(CMON,'(A,I4,A)') 'Maybe, it isn''t rejected.'
CC                  CALL XPRVDU(NCVDU,1,0)
CC Check for connection to current bonds list.
C                  IAT1 = NINT(BBLK(I,2))
C                  IAT2 = NINT(BBLK(I,4))
CC                  WRITE(CMON,'(2(A,I4))')'Looking for',IAT1,' or',IAT2
CC                  CALL XPRVDU(NCVDU,1,0)
C                  DO J = 1, NCBNDS
C                      NAT1 = NINT(BBLK(PCBNDS(J),2))
C                      NAT2 = NINT(BBLK(PCBNDS(J),4))
CC                      WRITE(CMON,'(A,2I4)')'Trying ',NAT1,NAT2
CC                      CALL XPRVDU(NCVDU,1,0)
C                      IF ( ( NAT1 .EQ. IAT1 ) .OR.
C     1                     ( NAT2 .EQ. IAT2 ) .OR.
C     2                     ( NAT1 .EQ. IAT2 ) .OR.
C     3                     ( NAT2 .EQ. IAT1 ) ) GOTO 240
C                  ENDDO
CC                  WRITE(CMON,'(A,I4,A)') 'No, it isn''t linked in.'
CC                  CALL XPRVDU(NCVDU,1,0)
C                  GOTO 250
C240               CONTINUE
CC Success. Use this bond.
CC                  WRITE(CMON,'(A,I4,A)') 'Yes.'
CC                  CALL XPRVDU(NCVDU,1,0)
CC Add this bond to PCBNDS list.
C                  NCBNDS = NCBNDS + 1
C                  PCBNDS(NCBNDS) = I
C                  GOTO 260
C
C250               CONTINUE
CC Failure for this bond. Keep looking.
C               END DO
CC Complete failure. No more bonds to add. This is as complete as
CC the structure is going to get.
C
C               IF ( NCBNDS .GE. NB18 ) THEN
CC We have matched all the bonds. We can't get better than this, no
CC matter where we start from. Stop searching.
C                 WRITE(CMON,'(A)') 'All bonds found. Stopping.'
C                 CALL XPRVDU(NCVDU,1,0)
C                 RETURN
C               ENDIF
C
C
C               WRITE(76,'(A,I4)')'End of branch pruning, size = ',NCBNDS
C               WRITE(CMON,'(A)') 'End of branch.'
C               CALL XPRVDU(NCVDU,1,0)
C
C
C               NRBNDS = NRBNDS + 1
C               PRBNDS(NRBNDS) = PCBNDS(NCBNDS)
CC Remove it from current bonds list.
C               NCBNDS = NCBNDS - 1
C
C               IF ( NCBNDS .EQ. 0 ) THEN
CC If this leaves no current bonds, start again.
C                   ICODE = 1
C                   GOTO 10
C               END IF
C
C
C260            CONTINUE
C
C
CC Exclude all bonds from search.
C               DO I = 1, NB18
C                  IBLK(I,9) = 1
C               END DO
CC Include all current bonds.
C               DO I = 1, NCBNDS
C                  IBLK(PCBNDS(I),9) = 0
C               END DO
C
C               WRITE(76,'(A,I4)')'Added new bond, size = ',NCBNDS
C
C               CALL WFNDFL (NATMS,NCBNDS,PCBNDS)
C
CC Add commands to SRQ and return.
C
CC Copy current SRQ to STORE.
C               CALL XSSRQ(IADSRQ,NSRQ)
C
CC Add commands to SRQ
C               CSRQ = '#FIND'
C               CALL XISRC(CSRQ)
C               CSRQ = 'QUERY OVERLAP=YES FILE=GUESS.INS'
C               CALL XISRC(CSRQ)
C               CSRQ = 'OUTFILE FILE=GUESS.RES'
C               CALL XISRC(CSRQ)
C               CSRQ = 'END'
C               CALL XISRC(CSRQ)
C               CSRQ = '#EMAP2'
C               CALL XISRC(CSRQ)
C
CC Restore SRQ to file from STORE..
C               CALL XRSRQ(IADSRQ,NSRQ)
C
C               RETURN
C
C            ENDIF
C
C
C      ELSE
C
CC STAGE 2 -- ANALYSIS
C
C        WRITE(CMON,'(A)')'EMAP: Stage 2. Analysis.'
C        CALL XPRVDU(NCVDU,1,0)
C
CC Re-Open the #FIND output file. (Close it first!)
C
C        INQUIRE (FILE='GUESS.RES',OPENED=LOPEN,NUMBER=NWRI)
C        IF (LOPEN) THEN
C             CLOSE ( NWRI )
C        ENDIF
C
C        OPEN (74, FILE='GUESS.RES')
C
CC For each match in the file we need to read NCBNDS of info.
CC The overall format is
CC MATCH <n>
CC <BO1-SER1-L18> <BO1-EL1-L5> <BO1-SER1-L5>
CC <BO1-SER2-L18> <BO1-EL2-L5> <BO1-SER2-L5>
CC <BO2-SER1-L18> <BO2-EL1-L5> <BO2-SER1-L5>
CC <BO2-SER3-L18> <BO2-EL2-L5> <BO2-SER2-L5>
CC .... etc.
CC i.e.
CC MATCH 1
CC 1 C 14
CC 2 N 54
CC 2 N 54
CC 3 C 12
CC .... etc.
C
Cc Clear store
C        WRITE(CMON,'(A)')'EMAP: Clearing store.'
C        CALL XPRVDU(NCVDU,1,0)
C        CALL XCSAE
C        CALL XRSL
CC Load list 5
C        WRITE(CMON,'(A)')'EMAP: Loading list 5.'
C        CALL XPRVDU(NCVDU,1,0)
C        IF (KHUNTR (5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
C
C        WRITE(CMON,'(A)')'EMAP: Reading FIND output.'
C        CALL XPRVDU(NCVDU,1,0)
C
CC Read the first line (blank).
C        READ (74,'(A)',END=499) CLINE
C
C        N = 0
C        MCOUNT = 0
C        LMATCH = .TRUE.
C        BESTF = 99999999.9
C        IBEST = 0
C
C400     CONTINUE
C
CC Read the 'MATCH' line
C        READ (74,'(A)',END=499) CLINE
C
C        MCOUNT = MCOUNT + 1
C        DO I = 1, NCBNDS
CC Get bond matches.
C         READ (74,'(A)',END=499) CLINE
C         NS = KCCNEQ(CLINE,1,' ')
C         IF ( NS .LE. 0 ) GOTO 9030
C         K1S18 = KGTNUM(CLINE(NS:),CT,NL)
C         NS = KCCNEQ(CLINE,NS+NL,' ')
C         NE = KCCEQL(CLINE,NS,' ') - 1
C         IF(NE.LT.NS) GOTO 9030
C         READ (CLINE(NS:NE),'(A)') CATTYP
C         READ (CATTYP,'(A4)') K1AT5
C         NS = KCCNEQ(CLINE,NE+1,' ')
C         IF ( NS .LE. 0 ) GOTO 9030
C         K1S5 = KGTNUM(CLINE(NS:),CT,NL)
C
C         READ (74,'(A)',END=499) CLINE
C         NS = KCCNEQ(CLINE,1,' ')
C         IF ( NS .LE. 0 ) GOTO 9030
C         K2S18 = KGTNUM(CLINE(NS:),CT,NL)
C         NS = KCCNEQ(CLINE,NS+NL,' ')
C         NE = KCCEQL(CLINE,NS,' ') - 1
C         IF(NE.LT.NS) GOTO 9030
C         READ (CLINE(NS:NE),'(A)') CATTYP
C         READ (CATTYP,'(A4)') K2AT5
C         NS = KCCNEQ(CLINE,NE+1,' ')
C         IF ( NS .LE. 0 ) GOTO 9030
C         K2S5 = KGTNUM(CLINE(NS:),CT,NL)
C
C
C
C
CC Find address of atom1 and 2 in list 5 in store.
C         PAT1 = 0
C         PAT2 = 0
C
C
C         DO J = L5, L5+(N5*MD5),MD5
C
C             IF ( ( ( ISTORE(J)   .EQ. K1AT5             ) .AND.
C     1              ( ABS (STORE(J+1) - K1S5) .LT. 0.5   ) ) .OR.
C     1            ( ( ISTORE(J)   .EQ. IBLK(PCBNDS(I),1) ) .AND.
C     1              ( ISTORE(J+1) .EQ. IBLK(PCBNDS(I),2) ) ) ) THEN
C                PAT1 = J
C                ISTORE(J) = IBLK(PCBNDS(I),1)
C                ISTORE(J+1) = IBLK(PCBNDS(I),2)
C             ENDIF
C
C             IF ( ( ( ISTORE(J)   .EQ. K2AT5             ) .AND.
C     1              ( ABS (STORE(J+1) - K2S5) .LT. 0.5   ) ) .OR.
C     1            ( ( ISTORE(J)   .EQ. IBLK(PCBNDS(I),3) ) .AND.
C     1              ( ISTORE(J+1) .EQ. IBLK(PCBNDS(I),4) ) ) ) THEN
C                PAT2 = J
C                ISTORE(J) = IBLK(PCBNDS(I),3)
C                ISTORE(J+1) = IBLK(PCBNDS(I),4)
C             ENDIF
C
C         END DO
C
CC Work out distance between these two atoms.
C
C         IF ( ( PAT1 .EQ. 0 ) .OR. ( PAT2 .EQ. 0 ) ) THEN
C         WRITE(CMON,'(A)')'Error atoms not found in L5.'
C         CALL XPRVDU(NCVDU,1,0)
C         RETURN
C         ENDIF
C
C         X1(1) = STORE(PAT1+4)
C         X1(2) = STORE(PAT1+5)
C         X1(3) = STORE(PAT1+6)
C         X2(1) = STORE(PAT2+4)
C         X2(2) = STORE(PAT2+5)
C         X2(3) = STORE(PAT2+6)
C
C
CC         WRITE(CMON,'(6F8.3)')(X1(NN),NN=1,3),(X2(NN),NN=1,3)
CC         CALL XPRVDU(NCVDU,1,0)
CC         WRITE(CMON,'(A)')'EMAP: Calculating interatomic distance.'
CC         CALL XPRVDU(NCVDU,1,0)
C
CC         DIST  = RXDIST(X1,X2)
CC For now assume the molecule is assembled and has no sym ops.
C
C          DIST = SQRT ( XDSTNCR(X1(1),X2(1)) )
C
Cc         WRITE(CMON,'(A,F15.3)')'RXDIST = ',DIST
Cc         CALL XPRVDU(NCVDU,1,0)
C
CC Set the distance in the L18 block.
C
C         BBLK ( PCBNDS(I), 5 ) = DIST
C
C        END DO
C
CC Check the bonds.
C
C        WRITE(CMON,'(A)')'EMAP: Checking interatomic distances.'
C        CALL XPRVDU(NCVDU,1,0)
C
C        N = MAX ( N, KBNDCH (RFOM,KBAD,RBAD,
C     1                       RAFOM,KABAD1,KABAD2,RABAD,
C     2                       PCBNDS(NCBNDS),SFOM ) )
C
C        WRITE(76,'(A,3F15.3)') 'FYI: BondFit = ',RFOM, RBAD, SFOM
C        WRITE(76,'(A,2F15.3)') 'FYI: AnglFit = ',RAFOM,RABAD
C
CC Generate a combined figure of merit. These are EMAPS, so weight
CC the angles more.
C
C         RFOM = RFOM + RAFOM*3.0
C
CC Store the best matching structure.
C
C        IF ( RFOM .LT. BESTF ) THEN
C            BESTF = RFOM
C            IBEST = MCOUNT
C            BESTSF = SFOM
C            RWORST= RBAD
C            KWORST= KBAD
C        ENDIF
C
C        GOTO 400
C499     CONTINUE
C
C
C        IF ( N .GT. 0 ) THEN
CC Bond not found in database or .tab file. Require processing of .if files.
C          WRITE(CMON,'(A)')'+----------------------------------+'
C          CALL XPRVDU(NCVDU,1,0)
C          WRITE(CMON,'(A)')'| EMAP: User intervention required.|'
C          CALL XPRVDU(NCVDU,1,0)
C          WRITE(CMON,'(A)')'|      Process CSD files now.      |'
C          CALL XPRVDU(NCVDU,1,0)
C          WRITE(CMON,'(A)')'+----------------------------------+'
C          CALL XPRVDU(NCVDU,1,0)
C          CLOSE(74)
C          RETURN
C        ENDIF
C
C        IF ( MCOUNT .EQ. 0 ) THEN
CC No matches.
CC Set the no matches flag.
C            LMATCH = .FALSE.
C
C        ELSE
C
CC Get the best match, and put it in the "BEST MATCH" file.
C
C        REWIND(74)
CC Read the blank line
C        READ (74,'(A)',END=9030) CLINE
C
CC Position the file ready for reading
C        DO I = 2,MCOUNT
C         READ (74,'(A)',END=9030) CLINE
C         DO J = 1, NCBNDS*2
C           READ (74,'(A)',END=9030) CLINE
C         END DO
C        END DO
C
CC Read the 'MATCH' line
C        READ (74,'(A)',END=9030) CLINE
C
C&&GIDDVF        OPEN (75,
C&&GIDDVF     1         FILE='GUESS.BEST',
C&&GIDDVF     1         STATUS='UNKNOWN',
C&&GIDDVF     1         POSITION='APPEND')
C&DOS        OPEN (75,
C&DOS     1         FILE='GUESS.BEST',
C&DOS     1         STATUS='UNKNOWN')
C&DOS510     CONTINUE
C&DOS        READ (75,'(A)',END=511)CLINE
C&DOS        GOTO 510
C&DOS511     CONTINUE
C&&GILLIN        OPEN (75,
C&&GILLIN     1         FILE='GUESS.BEST',
C&&GILLIN     1         STATUS='UNKNOWN')
C&&GILLIN510     CONTINUE
C&&GILLIN        READ (75,'(A)',END=511)CLINE
C&&GILLIN        GOTO 510
C&&GILLIN511     CONTINUE
C
CC Write header
C        WRITE(75,'(A)') ' TRY  CFOM  BOND BADFOM NMATCH'
C        WRITE(75,'(3(I4,F8.3))') NSBNDS, RFOM, KWORST, RWORST, NCBNDS
C        WRITE(76,'(A)') ' TRY  CFOM  BOND BADFOM NMATCH BESTSF'
C        WRITE(76,'(3(I4,F8.3))') NSBNDS, RFOM, KWORST, RWORST,
C     1                           NCBNDS, BESTSF
C        DO I = 1, NCBNDS
CC Copy bond matches.
C         READ (74,'(A)',END=9030) CLINE
C         WRITE(75,'(A)') CLINE
C         READ (74,'(A)',END=9030) CLINE
C         WRITE(75,'(A)') CLINE
C        END DO
C        ENDIF
C
C
C
C        CLOSE(75)
C        CLOSE(74)
C
C
CC Jump to stage1 -- decisions.
C        ICODE = 1
C        GOTO 10
C
C
C      END IF
C
C
C      RETURN
C
C
C9010  CONTINUE
C      WRITE (CMON,'(A/A)') 'File "guess.dat" must exist in your current'
C     1                    ,'directory, to use this sub-program.'
C      CALL XPRVDU(NCVDU, 2,0)
C      RETURN
C
C9020  CONTINUE
C      WRITE (CMON,'(A/A)') 'File "guess.dat" contains errors. Line is:',
C     1                     CLINE
C      CALL XPRVDU(NCVDU, 2,0)
C      RETURN
C
C9030  CONTINUE
C      WRITE (CMON,'(A/A)') 'File "guess.res" contains errors. Line is:',
C     1                     CLINE
C      CALL XPRVDU(NCVDU, 2,0)
C      RETURN
C
C9900  CONTINUE
C
C      WRITE (CMON,'(A)') 'Could not open file.'
C      CALL XPRVDU(NCVDU, 1,0)
C
C      RETURN
C      END
C

CCODE FOR WFNDFL
C      SUBROUTINE WFNDFL (NATS,NCBNDS,PCBNDS)
C      INTEGER NATS, NCBNDS, PCBNDS(1500)
C\TLST18
C\XIOBUF
C\XUNITS
C      LOGICAL LOPEN, LEXIST
C      CHARACTER CLINE*30
C      INTEGER IBNDTR(1500)
CC Write the #FIND input file using the current bond list.
C
C
CC Because FINDFRAG does its own file opening. We must close its
CC files for it, bypassing KFL routines.
C
CC Empty results file of any previous searches.
C      INQUIRE (FILE='GUESS.RES',OPENED=LOPEN,NUMBER=NWRI)
C      IF (LOPEN) THEN
CC It exists and is open. Empty and close it.
C            REWIND (NWRI)
C            WRITE (NWRI,'(A)')' '
C            CLOSE (NWRI)
C      ELSE
CC Open it, empty it and close it)
C            OPEN (74, FILE='GUESS.RES',STATUS='UNKNOWN')
C            WRITE(74,'(A)')' '
C            CLOSE(74)
C      ENDIF
C
CC Close input file, if open.
C      INQUIRE (FILE='GUESS.INS',OPENED=LOPEN,NUMBER=NWRI)
C      IF (LOPEN) CLOSE (NWRI)
C
CC Open input file.
C      OPEN ( 74, FILE='GUESS.INS')
C
C      MCOUNT = 1
C      DO I = 1, NATS
CC Find each atom, and plonk it into the query file.
CC Only atoms that are in bonds which are included, mind you.
C
C         WRITE(CLINE,'(A,I4)')'at',MCOUNT
C         CALL XCRAS(CLINE,NL)
C         ICOUNT = 0
C         INCLUD = 0
C         DO J = 1, NB18
C            IF ( NINT(BBLK(J,2)) .EQ. I ) THEN
C                  WRITE(CLINE(NL+2:),'(A4)')IBLK(J,1)
C                  ICOUNT = ICOUNT + 1
C                  IF ( IBLK (J,9) .EQ. 0 ) INCLUD = 1
C            ELSE IF ( NINT(BBLK(J,4)) .EQ. I ) THEN
C                  WRITE(CLINE(NL+2:),'(A4)')IBLK(J,3)
C                  ICOUNT = ICOUNT + 1
C                  IF ( IBLK (J,9) .EQ. 0 ) INCLUD = 1
C            END IF
C         END DO
C
C         IF (ICOUNT .EQ. 0) THEN
C            WRITE(CMON,'(A,I4,A)')'Atom ',I,' not found in bond list'//
C     1      '. Programming error.'
C
C            CALL XPRVDU(NCVDU,1,0)
C         ENDIF
C
CC Add the number of connections to the end of the line.
C
C         WRITE(CLINE(NL+7:),'(I4)') ICOUNT
C
C         IF( INCLUD .EQ. 1 ) THEN
C            WRITE(74, '(A)') CLINE
C            IBNDTR(I) = MCOUNT
C            MCOUNT = MCOUNT + 1
C         END IF
C      END DO
C
C
C      DO I = 1, NCBNDS
CC Add each bond to the query file.
C         WRITE(74,'(A,I6,I6,I6)')'bo ',
C     1   IBNDTR(NINT(BBLK(PCBNDS(I),2))),
C     2   IBNDTR(NINT(BBLK(PCBNDS(I),4))),
C     2   NINT(BBLK(PCBNDS(I),6))
C      END DO
C
CC Add the commands to write the output file.
C
C      WRITE(74,'(A)') 'end'
C      WRITE(74,'(A)') 'comm option'
C      WRITE(74,'(A)') 'comm MATCH *nocc'
C
C      DO I = 1, NCBNDS
C
C         WRITE(CLINE,'(I4)') IBNDTR(NINT(BBLK(PCBNDS(I),2)))
C         CALL XCRAS(CLINE,NL)
C         WRITE(74,'(A,I4,1X,4A)')'comm ', NINT(BBLK(PCBNDS(I),2)),
C     1                           ' *sp',  CLINE(1:NL),
C     2                           ' *se',  CLINE(1:NL)
C
C         WRITE(CLINE,'(I4)') IBNDTR(NINT(BBLK(PCBNDS(I),4)))
C         CALL XCRAS(CLINE,NL)
C         WRITE(74,'(A,I4,1X,4A)')'comm ', NINT(BBLK(PCBNDS(I),4)),
C     1                           ' *sp',  CLINE(1:NL),
C     2                           ' *se',  CLINE(1:NL)
C
C
C      END DO
C
C      CLOSE(74)
C
C      RETURN
C      END
C
C-----+-------+-------+-------+-------+-------+-------+-------+-------+C
C                                                                      C
C RIC: From here on, it's original CCDC code, except that I've         C
C      taken out codes which might confuse our CVS system, and         C
C      any writes directed at unit 6.                                  C
C
C Oct 2001: I've also taken out any unused common blocks and variables,
C and converted the code to use our STORE/ISTORE which removes the
C limitations on the number of atoms and bonds.
C
C                                                                      C
C-----+-------+-------+-------+-------+-------+-------+-------+-------+C


CODE FOR PLUDIJ
      SUBROUTINE PLUDIJ(IAT,JAT,AXYZO,DVAL)
C-- Function: Calculate the distance IAT - JAT  give othor coords XO
C-- Version:  23.5.94                  SAM MOTHERWELL 20.10.93
C-- Notes:
C-- 1. Iat , Jat are atom numbers inthe list of atoms with coords XO
C--   The distance is returned as DVAL
C      IMPLICIT NONE
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'

      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

C
C Maximum number of atoms in 3D (for both searching and display)
      INTEGER IAT,JAT, AXYZO
      REAL DVAL
      REAL DXO,DYO,DZO
C-- Assume the ortho coords are available!
      DXO=STORE(AXYZO+3*IAT-4+1)-STORE(AXYZO+3*JAT-4+1)
      DYO=STORE(AXYZO+3*IAT-4+2)-STORE(AXYZO+3*JAT-4+2)
      DZO=STORE(AXYZO+3*IAT-4+3)-STORE(AXYZO+3*JAT-4+3)
      DVAL=SQRT(DXO*DXO+DYO*DYO+DZO*DZO)
      RETURN
      END

CODE FOR SAMABO
      SUBROUTINE SAMABO
C-- Function: Assign bond types to a crystal connectivity with coordinates.
C-- Version:  29.9.94  27.4.95           Sam Motherwell     19.8.94
C-- Notes:
C-- 1. This makes a best guess at the bond types using standard ranges
C--    for various atom pairs between  C N O S P.  If a bond type can
C--    not be assigned with confidence the type is set in ISTORE(BTYPE+i-1)=0
C--    The CSD bond types are:  1 = single  2= double  3=triple  4=quadruple
C--                             5 = aromatic      6 = polymeric single
C--                             7 = delocalised   9 = pi-bond
C-- 2. The hybridisation state  1=linear sp1, 2= planar sp2, 3=tetrahed. sp3
C--    is assigned for each atom.  Normal valence states  (C = 4,  N = 3 etc)
C--    are used to guess at double single bonds.
C-- 3. Aromatic rings are detected by looking at torsion angles - the
C--    bond lengths are not as important here as the planarity of a
C--    5- or 6-membered ring.
C-- 4. Pi-bonds are detected by the Metal -C-C  triangle.
C-- 5. Experiments in progress as to best order of working.
C--    On the principle of doing the easiest first:
C--    1. detect pi-bonds
C--    2. detect aromatic (flat) rings
C--    3. assign double,triple bonds for O,S,P
C--    4. assign double bonds to satisfy valency on C, N
C--    5. final check over for valency problems & set highlight flag perhaps.
C--
C--
C-- 6. Input is the cryst. bond list BOND()
C--    This is processed into standard 3D connectivity arrays NHYC,NCAC, etc
C--    These define the crystal connectivity.
C--   AELEM   element code number  e.g. C=1 N=56 etc
C--   NHYC    number of terminal h
C--   NCAC    number of connections exclude term. hyd.
C--   ATRESN  number of cryst. residue
C--   BOND    array of bonds Iat, Jat
C--   BTYPE   bondtype
C--   NATCRY  number of atoms in cryst. arrays
C--   NBOCRY  number of bonds in BOND
C--   AXYZO   orthogonal coords in angstroms
C--
C-- 7. Output.   The bond types derived are set in ISTORE(BTYPE+-1)
C--


C      IMPLICIT NONE

      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

C ........... Molecule Viewer Atom DATa .............
C INT  TATOM             : total number of atoms to be displayed
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'

      INTEGER TATOM, AELEM, AXYZO, ATRESN, HYBR
      COMMON /MVADAT/ TATOM,AXYZO,AELEM, ATRESN, HYBR
C..........................................................................
C
C ........... Molecule Viewer Bond DATa .............
C INT  TBOND          : total number of atoms to be displayed
       INTEGER TBOND, BOND, BTYPE
       COMMON /MVBDAT/ TBOND,BOND,BTYPE
C..........................................................................
C-- 3D crystal connectivity (see also plutqz)
C-- query connectivity
      INTEGER NHYC,NCAC
      INTEGER NATCRY,NBOCRY
      COMMON /PLUTQY/ NHYC,NCAC,NATCRY,NBOCRY
      INTEGER  ATCHG, AROMA, NAROMA
      COMMON /PLUTAC/ ATCHG, AROMA, NAROMA
C-- ILIST  controls output to listing file  (usually =0  off)
C-- IDEBUG controls output to listing file  (usually =0  off)
      INTEGER ILIST, IDEBUG
      COMMON /PLUTLI/ ILIST, IDEBUG
C
C-- HYBR      estimate of hybridiation 1 = sp1 2=sp2 3=sp3  >100 = metal
C--


C--  LOCAL
      INTEGER  IAT,JAT,KAT,LAT,NCON,NCONA,
     +NHY,IEL,NZ,NCC
C--   HYPRES   H total in cryst.
C--   METTOT   metal total in cryst
C--   ICON list of atoms connected to Iat
C--   ICOB list of bondtypes for ICON
      INTEGER RINGAT(20),NRING,HYPRES,METTOT,NHETER,NMETAL
      INTEGER NNITRO,NSP3,IOK,NPIB,NPHOSP,NOXY,KMIN,NTOR
      INTEGER I,J,K,M,ICON(30),ICOB(30),IPIBON,NBT,I1,J1,NVAL,N1
      INTEGER IPASS,NNOT,NNOT1,LU,I9,J9,LTYPE(3),IPIB
      REAL AVAL,TORMAX,TORANG(30),TOR1,D1,V,DIJ(30)
      REAL DMIN,TORAVE,ANGMAX
      INTEGER LLIG(30), LMIG(30)

C-- Non-metals
      INTEGER NONMET(23),NNON
      DATA NNON/23/

C--               H  He B  C  N  O  F Ne Si P  S  Cl
      DATA NONMET/2,39,11,01,56,64,32,60,85,66,81,21,07,08,84,16,47,92,
     +     43,101,09,79,27/
C--               Ar As Se Br Kr Te I  Xe  At Rn D
C----------------------------------------------------------------------
      LU=stdoutterm
      IF(IDEBUG.GT.0) WRITE (LU,*) 'DEBUG IN SAMABO'
C--
C-- set up 3D connectivity arrays NHYC, NCAC etc in common
C-- using BOND() as input
      CALL SAMCC3

C-- Set all bond to type = 0.
C-- mark any bonds involving suppressed atoms with bt=99. Residue number < 0
C-- assign single bond to all H atoms  -element code = 2
C--
      DO 25 I=1,NBOCRY
        IF ( ISTORE(BTYPE+I-1) .EQ. 0 ) THEN
          IAT=ISTORE(BOND+2*I-3+1)
          JAT=ISTORE(BOND+2*I-3+2)
          IF (ISTORE(ATRESN+IAT-1).GT.0 .AND.
     1        ISTORE(ATRESN+JAT-1).GT.0) THEN
            ISTORE(BTYPE+I-1)=0
            IF (ISTORE(AELEM+IAT-1).EQ.2 .OR.
     1        ISTORE(AELEM+JAT-1).EQ.2) ISTORE(BTYPE+I-1)=1
          ELSE
            ISTORE(BTYPE+I-1)=99
          ENDIF
        ENDIF
 25   CONTINUE
C--
C-- scan to see if H present in cryst conn    &  identify metal atoms
C--
      HYPRES=0
      METTOT=0
      DO 55 I=1,NATCRY
        IF (ISTORE(ATRESN+I-1).LT.0) GOTO 55
        IF (ISTORE(AELEM+I-1).EQ.2) HYPRES=HYPRES+1
C-- count metals --  set hybridisation number = nc + 100
C--                  otherwise set hybr = 0
        DO 60 J=1,NNON
          IF (ISTORE(AELEM+I-1).EQ.NONMET(J)) GOTO 61
 60     CONTINUE
 61     CONTINUE
        IF (J.GT.NNON) THEN
          METTOT=METTOT+1
          ISTORE(HYBR+I-1)=ISTORE(NCAC+I-1)+100
        ELSE
          ISTORE(HYBR+I-1)=0
        ENDIF

 55   CONTINUE

C--
C-- Look for pi-bonds.   Only if metal present of course.
C--                      Metals are flagged with HYBR > 100
C--
      NPIB=0
      IF (METTOT.GT.0) THEN
        DO I=1,NBOCRY
         IF ( ISTORE(BTYPE+I-1) .EQ. 0 ) THEN
          IAT=ISTORE(BOND+2*I-3+1)
          JAT=ISTORE(BOND+2*I-3+2)
          IF (ISTORE(ATRESN+IAT-1).LT.0 .OR.
     1        ISTORE(ATRESN+JAT-1).LT.0) THEN
            ISTORE(BTYPE+I-1)=99
            CYCLE
          ENDIF
          CALL SAMPIQ(IAT,JAT,AELEM,BOND,BTYPE,NBOCRY,IPIBON)
          IF (IPIBON.GT.0) THEN
            ISTORE(BTYPE+I-1)=9
            IF(IDEBUG.GT.0) WRITE (STDOUTTERM,*)
     1           'pi-bond assigned ',IAT,JAT
            NPIB=NPIB+1
          END IF
         END IF
        END DO
      END IF

C--
C-- METAL - metal bonds all set to single b=1
C--
      IF(METTOT.GT.0) THEN
        DO I=1,NBOCRY
         IF ( ISTORE(BTYPE+I-1) .EQ. 0 ) THEN
          IAT=ISTORE(BOND+2*I-3+1)
          JAT=ISTORE(BOND+2*I-3+2)
          IF(ISTORE(HYBR+IAT-1).GT.100 .AND.
     1       ISTORE(HYBR+JAT-1).GT.100) ISTORE(BTYPE+I-1)=1
         END IF
        END DO
      ENDIF
C--
C-- set flag for SAMCON routine to ignore pi-bonds
C--
      IPIB=-1
C--

C--
C-- get hybridisation state for each atom
C--
      DO 100 I=1,NATCRY
        IF (ISTORE(HYBR+I-1).NE.0) GOTO 100
C-- skip suppressed atoms
        IF (ISTORE(ATRESN+I-1).LE.0) GOTO 100
C-- get number of connections NCONA - ignoring spuppressed atoms & pi-bonds
C-- These connections include any H-atoms.
        CALL SAMCON(I,BOND,BTYPE,NBOCRY,NCONA,ICON,ICOB,IPIB)
        NHY=ISTORE(NHYC+I-1)
C-- reset the number of connections to non-H atoms,  NCAC
        ISTORE(NCAC+I-1)=NCONA-NHY
        NCON=NCONA
C-- connection gt 4   just set HYBR to nc
        IF (ISTORE(NCAC+I-1).GT.4) THEN
          ISTORE(HYBR+I-1)=ISTORE(NCAC+I-1)
          GOTO 100
        ENDIF

C-- if 3 connections test planarity of 4-atoms          A
C-- use torsion angle     A-B-C-X                       |
C-- planar groups set hybr=2                            X
C--                                                    . .
C--                                                   B   C
C--
C-- Angle-max criterion is 12.5
C-- If a,b, or c are Hydrogen then relax criterion angle-max to 20
        IF (NCON.EQ.3) THEN
          IAT=ICON(1)
          JAT=ICON(2)
          KAT=ICON(3)
          LAT=I
          CALL SAMTOX(IAT,JAT,KAT,LAT,AXYZO,AVAL)
          ANGMAX=12.5
          IF (ISTORE(NHYC+I-1).GT.0) ANGMAX=20.0
          IF (ABS(AVAL).LT.ANGMAX) THEN
            IF(IDEBUG.GT.0) WRITE (LU,*) '    ',I,'= planar sp2'
            ISTORE(HYBR+I-1)=2
          ELSE
            ISTORE(HYBR+I-1)=3
          ENDIF
          IF(IDEBUG.GT.0) WRITE (LU,9101) I,NCON,AVAL,ISTORE(HYBR+I-1)
 9101     FORMAT (' plane test atom',I3,' ncon=',I2,' aval=',F6.1,
     +            ' set hybr=',I2)
          GOTO 100
        ENDIF
C--
C-- use terminal-H counts to identify hybridisation.
C-- No action if no H in cryst. conn.  HYPRES = 0
C-- This gives a working guess for hybridisation state.
C--
C-- Carbon
        IEL=ISTORE(AELEM+I-1)
        NCON=ISTORE(NCAC+I-1)
        IF (IEL.EQ.1 .AND. ISTORE(HYBR+I-1).EQ.0) THEN
          IF (NCON.EQ.1) THEN
            IF (NHY.EQ.1) ISTORE(HYBR+I-1)=1
            IF (NHY.EQ.2) ISTORE(HYBR+I-1)=2
            IF (NHY.GE.3) ISTORE(HYBR+I-1)=3
          ENDIF
          IF (NCON.EQ.2) THEN
            IF (NHY.EQ.1) ISTORE(HYBR+I-1)=2
            IF (NHY.EQ.2) ISTORE(HYBR+I-1)=3
          ENDIF
          IF (NCON.EQ.3) THEN
            IF (NHY.EQ.1) ISTORE(HYBR+I-1)=3
          ENDIF
          IF (NCON.EQ.4) ISTORE(HYBR+I-1)=3
        ENDIF
C-- Nitrogen
        IF (IEL.EQ.56) THEN
          IF (NCON.EQ.1) THEN
            IF (HYPRES.GT.0 .AND. NHY.EQ.0) ISTORE(HYBR+I-1)=1
            IF (NHY.EQ.1) ISTORE(HYBR+I-1)=2
            IF (NHY.GE.2) ISTORE(HYBR+I-1)=3
          ENDIF
          IF (NCON.EQ.2) THEN
            IF (HYPRES.GT.0 .AND. NHY.EQ.0) ISTORE(HYBR+I-1)=2
            IF (NHY.GE.2) ISTORE(HYBR+I-1)=3
          ENDIF
          IF (NCON.GE.3) ISTORE(HYBR+I-1)=3
        ENDIF
C-- Oxygen Sulfur
        IF (IEL.EQ.64 .OR. IEL.EQ.81) THEN
          IF (HYPRES.GT.0 .AND. NHY.EQ.0) ISTORE(HYBR+I-1)=2
          IF (NHY.GE.1) ISTORE(HYBR+I-1)=3
        ENDIF
 100  CONTINUE
C--
C-- First do the easy bits of the puzzle!
C--
C-- assign bonds which are unambiguous & commonly occurring
C--  H - A      single
C--  C = O      carboxyl
C--  C = O      carbonyl triple
C--  C - OH     single
C--  C - C      single terminal methyl
C--  C - O - C  singles
C--  C = S      double
C--  C - S      single
C--  C = N      triple terminal
C--  A - N - B  N with 3 bonds single
C--      |
C--      C
C--  Halogen-C  single
C--  O = N
C--  O = S
C--
C--

      DO 300 IAT=1,NATCRY
        CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,N1,LLIG,LMIG,IPIB)
C-- Hydrogen & Deuterium
        IF (ISTORE(AELEM+IAT-1).EQ.2 .OR.
     1      ISTORE(AELEM+IAT-1).EQ.27) THEN
          DO 305 J=1,N1
            JAT=LLIG(J)
            NBT=1
            CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 305      CONTINUE
        ENDIF

C-- Oxygen
        IF (ISTORE(AELEM+IAT-1).EQ.64) THEN
C--  O terminal.
C--   C = O         terminal O,  C nca=3,  dij < 1.30
C--   CO  carbonyl  terminal O,  C nca=2,  dij < 1.30
C--   N = O         terminal O,  dij < 1.30
C--   S = O         terminal O,  dij < 1.60
C--   P = O                      dij < 1.60
C--   if distances longer than limits set single bond
          IF (N1.EQ.1) THEN
            JAT=LLIG(1)
            CALL PLUDIJ(IAT,JAT,AXYZO,D1)
            NBT=1
            IF (ISTORE(AELEM-1+JAT).EQ.1 .AND. D1.LT.1.30) THEN
              IF (ISTORE(AELEM-1+JAT).EQ.1 .AND.
     1            ISTORE(NCAC+JAT-1).EQ.3) NBT=2
              IF (ISTORE(AELEM-1+JAT).EQ.1 .AND.
     1            ISTORE(NCAC+JAT-1).EQ.2 .AND.
     +            ISTORE(NHYC+JAT-1).EQ.1) NBT=2
              IF (ISTORE(AELEM-1+JAT).EQ.1 .AND.
     1            ISTORE(NCAC+JAT-1).EQ.2 .AND. ISTORE(NHYC+JAT-1)
     +            .EQ.0) THEN
C-- for carbonyl M-C.TRIPLE.O  bond we must have a metal attached to the C
C-- as   kat-jat-iat   M-C-O
C-- look at connections to JAT for metal KAT flagged with hybr > 100
C-- If no metal then must set as C=O as in aldehyde
              NBT=3
              M=0
              CALL SAMCON(JAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
              DO 307 K=1,NCON
              KAT=ICON(K)
              IF (ISTORE(HYBR+KAT-1).GT.100) M=M+1
 307          CONTINUE
              IF(M.EQ.0) NBT=2
              ENDIF
            ENDIF
            IF (ISTORE(AELEM-1+JAT).EQ.56 .AND. D1.LT.1.30) NBT=2
            IF (ISTORE(AELEM-1+JAT).EQ.81 .AND. D1.LT.1.60) NBT=2
            IF (ISTORE(AELEM-1+JAT).EQ.66 .AND. D1.LT.1.60) NBT=2
            IF (NBT.GT.0) CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
          ENDIF
C--     A - O - B       Single bonds
          IF (N1.GE.2) THEN
            DO 310 J=1,N1
              JAT=LLIG(J)
              NBT=1
              CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 310        CONTINUE
          ENDIF
        ENDIF
C-- Sulphur
C--  S = C
        IF (ISTORE(AELEM-1+IAT).EQ.81) THEN
C--  S terminal                  S=C,   S=P
          IF (N1.EQ.1) THEN
            JAT=LLIG(1)
            NBT=2
            IF (ISTORE(AELEM-1+JAT).EQ.1 .OR.
     1          ISTORE(AELEM-1+JAT).EQ.66)
     +          CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
          ENDIF
C--    a - S - b
          IF (N1.GE.2) THEN
            DO 315 J=1,N1
              JAT=LLIG(J)
              NBT=1
              CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 315        CONTINUE
          ENDIF
        ENDIF
C--
C-- Nitrogen -       the tricky one!
C--
        IF (ISTORE(AELEM-1+IAT).EQ.56) THEN
C--
C--  N  3 connections
C--  set  single bonds. Ignore if N - metal bonds present.
C--  If Nitro group  then code  O = N = O
C--

C--  RIC:Mar02: If hybr is 2 (planar), leave for now - poss aromatic.
         IF ( ISTORE(HYBR-1+IAT).NE.2.) THEN
C--
C--  Nitroso group code only     N - O   ,leave other bonds unset.

          IF (N1.GE.3) THEN
            NMETAL=0
            NOXY=0
            DO 3151 J=1,N1
              JAT=LLIG(J)
              IF (ISTORE(HYBR+JAT-1).GE.100) NMETAL=NMETAL+1
              IF (ISTORE(AELEM-1+JAT).EQ.64) NOXY=NOXY+1
 3151       CONTINUE
            IF (NMETAL.EQ.0) THEN
              DO 317 J=1,N1
                JAT=LLIG(J)
                IF (ISTORE(HYBR+JAT-1).GE.100) GOTO 317
                NBT=1
                IF (NOXY.EQ.1 .AND. ISTORE(AELEM-1+JAT).NE.64) GOTO 317
                IF (NOXY.GT.1 .AND. ISTORE(AELEM-1+JAT).EQ.64 .AND.
     1           ISTORE(NCAC+JAT-1).EQ.1) NBT=2
                CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 317          CONTINUE
            ENDIF
          ENDIF
         ENDIF
C--
C-- N  terminal     then  check for C triple N    < 1.25
C--                                 C  =  N       < 1.32
C--                                 N TRIPLE N    < 1.20
            IF(ISTORE(NCAC+IAT-1).EQ.1) THEN
             DO 3171 J=1,N1
             JAT=LLIG(J)
             CALL PLUDIJ(IAT,JAT,AXYZO,D1)
             IF(ISTORE(AELEM-1+JAT).EQ.1) THEN
               NBT=1
               IF (ISTORE(HYBR+IAT-1).EQ.2 .AND. D1.LT.1.32) NBT=2
               IF (D1.LT.1.25) NBT=3
               CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
               ENDIF
             IF(ISTORE(AELEM-1+JAT).EQ.56) THEN
               IF(D1.LT.1.20) THEN
                 NBT=3
                 CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
                 ISTORE(HYBR+IAT-1)=1
                 ENDIF
               ENDIF

3171         CONTINUE
             ENDIF

        ENDIF
C--
C-- Phosphorus
C-- Set single bonds.  Except if to Oxygen terminal dij < 1.50
        IF (ISTORE(AELEM-1+IAT).EQ.66) THEN
          DO 319 J=1,N1
            JAT=LLIG(J)
            CALL PLUDIJ(IAT,JAT,AXYZO,D1)
            NBT=1
            IF (ISTORE(AELEM-1+JAT).EQ.64 .AND. ISTORE(NCAC+JAT-1).EQ.1
     +      .AND. D1.LT.1.50) NBT=2
            IF(IDEBUG.GT.0) WRITE (LU,*) 'P debug',iat,jat,d1,nbt
            CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 319      CONTINUE
        ENDIF

C-- Halogen terminal
        IF (ISTORE(AELEM-1+IAT).EQ.32 .OR. ISTORE(AELEM-1+IAT).EQ.21
     + .OR. ISTORE(AELEM-1+IAT).EQ.16 .OR. ISTORE(AELEM-1+IAT).EQ.43
     + .OR. ISTORE(AELEM-1+IAT).EQ.9) THEN
          IF (N1.EQ.1) THEN
            JAT=LLIG(J)
            NBT=1
            CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
          ENDIF
        ENDIF

C-- Boron, Si, As, Se, Te
        IF (ISTORE(AELEM-1+IAT).EQ.11 .OR. ISTORE(AELEM-1+IAT).EQ.85
     + .OR. ISTORE(AELEM-1+IAT).EQ.8 .OR. ISTORE(AELEM-1+IAT).EQ.84
     + .OR. ISTORE(AELEM-1+IAT).EQ.92) THEN
          DO 320 J=1,N1
            JAT=LLIG(J)
            NBT=1
            CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 320      CONTINUE
        ENDIF

C-- Carbon
        IF (ISTORE(AELEM-1+IAT).EQ.1) THEN
          NVAL=ISTORE(NCAC+IAT-1)+ISTORE(NHYC+IAT-1)
          NCC=ISTORE(NCAC+IAT-1)
          NHY=ISTORE(NHYC+IAT-1)
          NBT=0
          JAT=LLIG(1)

          IF ( N1 .GT. 0 ) THEN !Not a disconnected carbon (methane)
C-- Only apply to terminal C - C         (others have been done e.g. C - O)
            IF (NCC.EQ.1 .AND. ISTORE(AELEM-1+JAT).NE.1) NCC=-1
C-- terminal C - C  check bond length.
            IF (NCC.EQ.1) THEN
              JAT=LLIG(1)
              CALL PLUDIJ(IAT,JAT,AXYZO,D1)
            ENDIF
C-- terminal C  and no hydrogen, Use the bond length
            IF (NCC.EQ.1 .AND. NHY.EQ.0) THEN
              NBT=1
              IF (D1.LT.1.30) NBT=3
              IF (D1.GE.1.30 .AND. D1.LT.1.44) NBT=2
            ENDIF
C-- terminal C and 1 hydrogen - probably triple bond
            IF (NCC.EQ.1 .AND. NHY.EQ.1 .AND. D1.LT.1.30) NBT=3
C-- terminal C and 2 hydrogens - probably double bond
            IF (NCC.EQ.1 .AND. NHY.EQ.2 .AND.
     +            ISTORE(HYBR+IAT-1).EQ.2) NBT=2
            IF (NBT.GT.0) CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
C-- carbon with 4 connections - set all to single bonds
            IF (NVAL.EQ.4) THEN
              DO 318 J=1,N1
                JAT=LLIG(J)
                NBT=1
                CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 318          CONTINUE
            ENDIF
          ENDIF
        ENDIF

 300  CONTINUE

C-- DEBUG LIST
      IF(IDEBUG.GT.0) THEN
      DO 105 I=1,NATCRY
        WRITE (LU,9105) I,ISTORE(AELEM-1+I),ISTORE(NHYC+I-1),
     +    ISTORE(NCAC+I-1),ISTORE(ATRESN+I-1),ISTORE(HYBR+I-1)
 9105   FORMAT (I5,4I3,' hybr=',I3)
 105  CONTINUE
      DO 106 I=1,NBOCRY
        WRITE (LU,9106) I,(ISTORE(BOND+2*I-3+K),K=1,2),ISTORE(BTYPE+I-1)
 9106   FORMAT (' bond ',I3,6X,3I3)
 106  CONTINUE
      ENDIF



C--
C-- If carboxyl groups detected, then set single bonds from carbon
C--
      DO 350 I=1,NBOCRY
        IAT=ISTORE(BOND+2*I-3+1)
        JAT=ISTORE(BOND+2*I-3+2)
        NBT=ISTORE(BTYPE+I-1)
        IF (NBT.NE.2) GOTO 350
        KAT=0
        IF (ISTORE(AELEM-1+IAT).EQ.64) KAT=JAT
        IF (ISTORE(AELEM-1+JAT).EQ.64) KAT=IAT
        IF (KAT.EQ.0) GOTO 350
        CALL SAMCON(KAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        IF (ISTORE(AELEM-1+KAT).NE.1 .OR. NCON.NE.3) GOTO 350
C-- selected Carbon with 3 connections   x
C--                                       .
C--                                        C = O
C--                                       .
C--                                      y
        DO 355 K=1,NCON
          IF (ICOB(K).EQ.0) THEN
            LAT=ICON(K)
            NBT=1
            CALL SAMSBT(KAT,LAT,NBT,BOND,BTYPE,NBOCRY)
          ENDIF
 355    CONTINUE

 350  CONTINUE

C--
C-- Look for flat rings.  Assign as aromatic or delocalised.
C-- Phenyls & cyclopenatdienyls  should be easy
C-- If just one N in ring then could be flagged aromatic.
C-- If other hetero-atoms or N > 1  then leave as single just now.
C--
C-- allow rings to contain unassigned and aromatic bonds (e.g. fused aromatics).
C-- First item in LTYPE array is no. of types
      LTYPE(1)=2
      LTYPE(2)=0
      LTYPE(3)=5
C--
      DO IAT=1,NATCRY
C-- search for rings which start on atoms with 2 conections.
C-- and with at least 2 bonds not yet assigned at type. NZ count zero btype.
        NZ=0
        IF (ISTORE(NCAC+IAT-1).GE.2) THEN
          CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
          DO K=1,NCON
            IF (ICOB(K).EQ.0) NZ=NZ+1
          END DO
        ENDIF
C-- look for ring starting on atom Iat - at least 2 connections with bond type 0
C-- SAMRIQ looks for a ring  restricted to bond type 0, max size 6
        TORMAX=999.
        TORAVE=999.
        IF (ISTORE(NCAC+IAT-1).GE.2 .AND. NZ.GE.2) THEN
          CALL SAMRIQ(IAT,BOND,BTYPE,NBOCRY,RINGAT,NRING,IDEBUG,LTYPE,6)
          IF(IDEBUG.GT.0) WRITE (LU,9225) IAT,(RINGAT(K),K=1,nring)
 9225     FORMAT (' samriq iat=',I3,' ring=',10I3)
          IF (NRING.GE.4 .AND. NRING.LE.8) THEN
            CALL SAMRIT(RINGAT,NRING,AXYZO,TORANG,TORMAX)
            AVAL=0.0
            DO K=1,NRING
              AVAL=AVAL+ABS(TORANG(K))
            END DO
            TORAVE=AVAL/FLOAT(NRING)
            IF(IDEBUG.GT.0) WRITE (LU,9226) TORMAX,TORAVE,
     +      (TORANG(K),K=1,NRING)
 9226       FORMAT (' ring tormax/av=',2F6.1,' torangs=',10F6.1)
C-- assess ring as candidate for aromatic.
C-- count hetero atoms, metals, Nitrogen, sp3 hybrid
            NHETER=0
            NMETAL=0
            NNITRO=0
            NPHOSP=0
            NSP3=0
            DO K=1,NRING
              KAT=RINGAT(K)
              IF (ISTORE(AELEM-1+KAT).NE.1 .AND.
     +            ISTORE(HYBR+KAT-1).LT.10) NHETER=NHETER+1
              IF (ISTORE(AELEM-1+KAT).EQ.56) NNITRO=NNITRO+1
              IF (ISTORE(AELEM-1+KAT).EQ.66) NPHOSP=NPHOSP+1
              IF (ISTORE(HYBR+KAT-1).GT.100) NMETAL=NMETAL+1
              IF (ISTORE(HYBR+KAT-1).EQ.3 .OR.
     +            ISTORE(HYBR+KAT-1).EQ.4) NSP3=NSP3+1
            END DO
          ENDIF
        ENDIF
C-- check if ring is flat   - TORAVE < 10 degrees
C-- if  hetero atoms 0 or 1  then assign aromatic bond type 5.
C-- if metal involved then skip!  do not assign delocalise bond type 7.
        IOK=0
        IF (TORAVE.LE.10.0 .AND. TORMAX.LT.20.0) THEN
          IF (NHETER.EQ.0) IOK=1
          IF (NNITRO.GT.0 .AND. NHETER.EQ.NNITRO) IOK=1
          IF (NPHOSP.GT.0 .AND. NHETER.EQ.NPHOSP) IOK=1
          IF (NSP3.GT.0) IOK=0
          IF (NMETAL.EQ.1) IOK=0
        ENDIF
        IF (IOK.EQ.1) THEN
          IF(IDEBUG.GT.0) WRITE (LU,*) '  = planar ring'
          NBT=5
          IF (NMETAL.GT.0) NBT=7
          DO K=1,NRING
            I1=RINGAT(K)
            J1=RINGAT(K+1)
            ISTORE(AROMA+MIN(6,K)+NAROMA*7) = I1 - 1
            IF (K.EQ.NRING) J1=RINGAT(1)
            IF(IDEBUG.GT.0) WRITE (LU,9235) I1,J1,NBT
 9235       FORMAT (' set bond ',2I3,' btype',I2)
            CALL SAMSBT(I1,J1,NBT,BOND,BTYPE,NBOCRY)
          END DO
          ISTORE(AROMA+NAROMA*7) = MIN(6,NRING) ! Type flag 5 for five, 6 for six.
          NAROMA = NAROMA + 1
        ENDIF

      END DO
C--
C-- Check pi-bond triangles             Tr
C--                                    .  .
C--                                   .    .
C--                                  .      .
C--                                 C ----- C
C--
C-- If the C---C bond has not been assigned as aromatic then set it as
C-- double bond.  Note that we do not test if both carbons pi-bond to same Tr.
C--
      IF(NPIB.GT.0) THEN
       DO I=1,NBOCRY
        IF(ISTORE(BTYPE+I-1).NE.0) CYCLE
        IAT=ISTORE(BOND+2*I-3+1)
        JAT=ISTORE(BOND+2*I-3+2)
        IF(ISTORE(AELEM-1+IAT).NE.1 .OR.
     +     ISTORE(AELEM-1+JAT).NE.1) CYCLE
C**        write(lu,*) 'TEST 240  C---C  pi to metal ',Iat,Jat
        I9=0
        J9=0
        DO J=1,NBOCRY
         IF(ISTORE(BTYPE+J-1).NE.9) CYCLE
         IF(ISTORE(BOND+2*J-3+1).EQ.IAT .OR.
     +      ISTORE(BOND+2*J-3+2).EQ.IAT) I9=1
         IF(ISTORE(BOND+2*J-3+1).EQ.JAT .OR.
     +      ISTORE(BOND+2*J-3+2).EQ.JAT) J9=1
        END DO
        IF(I9.GT.0 .AND.J9.GT.0) THEN
           NBT=2
           ISTORE(BTYPE+I-1)=NBT
           IF(IDEBUG.GT.0) WRITE(LU,*)
     +     'Pi-bond used to assign C = C at ',IAT,JAT,NBT
        ENDIF
       END DO
      ENDIF
C--
C-- check all atoms for unassigned bonds  code = 0
C-- make reasonable guess at bond.
C-- Allow several passes through the list, as assignment can sometimes
C-- not be complete at pass one through the atoms list
C--
      NNOT=0
      DO 700 IPASS=1,3
C-- count number of not-assigned bonds NNOT. Compare with previous pass, NNOT1.
        NNOT1=NNOT
        NNOT=0
        DO 690 K=1,NBOCRY
          IF (ISTORE(BTYPE+K-1).EQ.0) NNOT=NNOT+1
 690    CONTINUE
        IF (NNOT.EQ.0 .OR. NNOT.EQ.NNOT1) GOTO 701
C--
C-- loop on all atoms IAT  - get connection list for atom IAT in ICON, ICOB
C--
        DO 680 I=1,NATCRY
          IF (ISTORE(ATRESN+I-1).LT.0) GOTO 680
          IAT=I
          CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
C-- loop on bonds Iat - Jat
          DO 600 M=1,NCON
            IF (ICOB(M).NE.0) GOTO 600
            NNOT=NNOT+1
            JAT=ICON(M)
            I1=IAT
            J1=JAT

C-- unassigned bond to metal is set as single-bond
            IF (ISTORE(HYBR+I1-1).GT.100 .OR.
     +          ISTORE(HYBR+J1-1).GT.100) THEN
              NBT=1
              CALL SAMSBT(I1,J1,NBT,BOND,BTYPE,NBOCRY)
              GOTO 600
            ENDIF

            V=0.
            NZ=0
            NMETAL=0
            DO 605 K=1,NCON
              IF (ICOB(K).EQ.0) NZ=NZ+1
              IF (ICOB(K).GE.1 .AND. ICOB(K).LE.4) V=V+FLOAT(ICOB(K))
              IF (ICOB(K).EQ.5 .OR. ICOB(K).EQ.7) V=V+1.51
              IF (ICOB(K).EQ.6) V=V+1.0
              KAT=ICON(K)
              IF (ISTORE(HYBR+KAT-1).GT.100) NMETAL=NMETAL+1
              CALL PLUDIJ(IAT,KAT,AXYZO,DIJ(K))
 605        CONTINUE
Cdebug
            IF(IDEBUG.GT.0) WRITE (LU,9605)
     +      IAT,ISTORE(AELEM-1+IAT),ISTORE(HYBR+IAT-1),V,NZ,HYPRES
 9605       FORMAT (' iat',I3,' ielc',I3,' hybr=',I1,' v=',F5.1,
     +              ' nzero',I2,' hypres',I2)
            DO 606 K=1,NCON
              IF(IDEBUG.GT.0) WRITE (LU,9606) ICON(K),ICOB(K),DIJ(K)
 9606         FORMAT ('     jat=',I3,' icob',I2,' dij',F6.2)
 606        CONTINUE
C--                              .
C-- carbon valence check      - C         set single/double bonds
C--                              .
            IF (ISTORE(AELEM-1+IAT).EQ.1) THEN
              NBT=0
C-- if non-planar and 4 connections - then set single bonds
C-- if non-planar and 3 connections - set any zero bonds as single
              IF (ISTORE(HYBR+IAT-1).EQ.3) THEN
                DO 607 K=1,NCON
                IF(ICOB(K).EQ.0) THEN
                  JAT=ICON(K)
                  NBT=1
                  CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
                  ENDIF
 607            CONTINUE
                GOTO 600
              ENDIF
C-- if planar , v 2 or 3 or 4 ,  nz 1 or 2
C-- then we must have 1 double, 2 single
C-- set the zero-bonds with correct bondtype
C-- Do not allow b=2 if dij > 1.46
              IF (ISTORE(HYBR+IAT-1).EQ.2 .AND. NINT(V).GE.2) THEN
                NBT=0
                IF (NINT(V).GE.3 .AND. NZ.EQ.1) NBT=1
                IF (NINT(V).EQ.2 .AND. NZ.EQ.2) NBT=1
                IF (NINT(V).EQ.2 .AND. NZ.EQ.1) NBT=2
                DO 608 K=1,NCON
                  IF (ICOB(K).EQ.0 .AND. NBT.GT.0) THEN
                    JAT=ICON(K)
                    IF (NBT.EQ.2) THEN
                      CALL PLUDIJ(IAT,JAT,AXYZO,D1)
                      IF (D1.GT.1.46) NBT=1
                    ENDIF
                    CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
                  ENDIF
 608            CONTINUE
                GOTO 600
              ENDIF
C-- if planar, 1 single bond, 2 zero bonds.
C-- Assign double bond to shorter distance, single to longer
              IF (ISTORE(HYBR+IAT-1).EQ.2 .AND. NINT(V).EQ.1) THEN
                NBT=0
                DMIN=999.
                KMIN=0
                DO 609 K=1,NCON
                  IF (ICOB(K).EQ.0 .AND. DIJ(K).LT.DMIN) THEN
                    DMIN=DIJ(K)
                    KMIN=K
                  ENDIF
 609            CONTINUE
                DO 610 K=1,NCON
                  NBT=0
                  IF (ICOB(K).EQ.0 .AND. K.NE.KMIN) NBT=1
                  IF (ICOB(K).EQ.0 .AND. K.EQ.KMIN) NBT=2
                  JAT=ICON(K)
                  IF(NBT.GT.0)
     +            CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 610            CONTINUE
                GOTO 600
              ENDIF
C--
C-- if hybr not known and 2 connections     C -- C -- C
C--                                         j    i    k
C--
C--     Possible triple bond - get angle. Set triple if > 160
              IF (ISTORE(HYBR+IAT-1).EQ.0 .AND. NCON.EQ.2) THEN
                JAT=ICON(1)
                KAT=ICON(2)
                CALL SAMANF(JAT,IAT,KAT,AXYZO,AVAL)
                IF(IDEBUG.GT.0) WRITE (LU,*) ' angle',Jat,Iat,Kat,aval
C--
C--  linear  x -- C -- y
C--
                IF (AVAL.GT.160.0) THEN
C--  C = C = C            current V=2

                  IF (NINT(V).EQ.2) THEN
                    NBT=2
                    IF(ICOB(1).EQ.0)
     + CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
                    IF(ICOB(2).EQ.0)
     + CALL SAMSBT(IAT,KAT,NBT,BOND,BTYPE,NBOCRY)
                    GOTO 600
                  ENDIF
C--  C triple C           current V=1
                  NBT=3
                  IF (DIJ(1).LT.DIJ(2)) THEN
                    ICOB(1)=NBT
                    ICOB(2)=1
                  ELSE
                    ICOB(1)=1
                    ICOB(2)=NBT
                  ENDIF
                  DO 611 K=1,NCON
                    JAT=ICON(K)
                    NBT=ICOB(K)
                    CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
 611              CONTINUE
                  GOTO 600
                ENDIF
C--      j-i-k  angle < 160   test for double bond  i-j by looking
C--      at torsion angles   involving bond  i - j
                IF (ICOB(1).EQ.0) JAT=ICON(1)
                IF (ICOB(2).EQ.0) JAT=ICON(2)
                CALL SAMTOB(IAT,JAT,BOND,BTYPE,NBOCRY,
     +                      AXYZO,NTOR,TORANG)
                IF(IDEBUG.GT.0) WRITE (LU,9610) IAT,JAT,
     +          (TORANG(K),K=1,NTOR)
 9610           FORMAT ('   torsion angles bond=',2I3,' tors=',10F6.1)
C--   all torsion angles in range 0 - 20   or  160-180   then b=2
C--   Do not allow double bond assign if dij > 1.46
C--                                   or hybr atom j =3
                NBT=2
                CALL PLUDIJ(IAT,JAT,AXYZO,D1)
                IF (D1.GT.1.46) NBT=1
                IF (ISTORE(HYBR+JAT-1).EQ.3) NBT=1
                DO 615 K=1,NTOR
                  TOR1=ABS(TORANG(K))
                  IF (TOR1.GT.20.0 .AND. TOR1.LT.160.0) NBT=1
 615            CONTINUE
                CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
                GOTO 600
              ENDIF


              IF (NBT.EQ.0) THEN
                IF (V.LT.4.0 .AND. V.GE.3.0) NBT=1
                IF (ABS(V-2.0).LT.0.001) NBT=2
              ENDIF
C-- set the bond type if assigned
              IF (NBT.GT.0) THEN
                CALL SAMSBT(I1,J1,NBT,BOND,BTYPE,NBOCRY)
                GOTO 600
              ENDIF

            ENDIF
C-- nitrogen valence check = 3
C-- case of 2 connections.           x - N = y
            IF (ISTORE(AELEM-1+IAT).EQ.56 .AND. NMETAL.EQ.0 .AND.
     +           NCON.EQ.2) THEN
              NBT=0
              JAT=ICON(1)
              KAT=ICON(2)
C-- work out if linear (sp) or bent (sp2)
              CALL SAMANF(JAT,IAT,KAT,AXYZO,AVAL)
C-- do not attempt to assign if linear - not x-N=y
              IF(AVAL.GE.150.0) GOTO 600
C-- hydrogens present elsewhere - therefore  x-N=y
              IF (HYPRES.GT.0) THEN
                IF (ABS(V-2.0).LT.0.001) NBT=1
                IF (ABS(V-1.0).LT.0.001) NBT=2
                CALL SAMSBT(I1,J1,NBT,BOND,BTYPE,NBOCRY)
                IF(IDEBUG.GT.0) WRITE (STDOUTTERM,*) 'setting Nitrogen '
                IF(IDEBUG.GT.0) WRITE (STDOUTTERM,*)
     1                 'samsbt bond',I1,J1,NBT
                GOTO 600
              ENDIF
C-- hydrogens not present - therefore cannot tell if x-N-y  or  x-N=y
C-- if elements x y are the same and a significant difference in bond length
C-- assign double bond to shorter.
              IF (HYPRES.EQ.0) THEN
                IF (ISTORE(AELEM-1+JAT).EQ.ISTORE(AELEM-1+KAT) .AND.
     +              ABS(DIJ(1)-DIJ(2)).GT.0.05) THEN
                  IF (ICOB(1).EQ.0) THEN
                    NBT=1
                    IF (DIJ(1).LT.DIJ(2)) NBT=2
                    CALL SAMSBT(I1,JAT,NBT,BOND,BTYPE,NBOCRY)
                    IF(IDEBUG.GT.0) WRITE(STDOUTTERM,*)
     +              'samsbt N bond',I1,JAT,NBT

                  ENDIF
                  IF (ICOB(2).EQ.0) THEN
                    NBT=1
                    IF (DIJ(2).LT.DIJ(1)) NBT=2
                    CALL SAMSBT(I1,KAT,NBT,BOND,BTYPE,NBOCRY)
                    IF(IDEBUG.GT.0) WRITE (STDOUTTERM,*)
     +              'samsbt N bond',I1,KAT,NBT

                  ENDIF
                ENDIF
              ENDIF


            ENDIF
C-- end loop on bonds Iat-Jat
 600      CONTINUE

C-- end loop on atoms IAT
 680    CONTINUE
C-- end loop on pass of assignment
 700  CONTINUE
 701  CONTINUE
C--
C--
C--   Stage 2.    Tidying up.
C--
C--
C-- set any unassigned bond types to single  b=1
C--
      IF(IDEBUG.GT.0) WRITE(LU,*)'======= STAGE 2  tidy up ========='
      DO 710 I=1,NBOCRY
      IF(ISTORE(BTYPE+I-1).EQ.0) THEN
        ISTORE(BTYPE+I-1)=1
        IF(IDEBUG.GT.0) WRITE(LU,*)'Unassigned. Set b=1 ',
     +  ISTORE(BOND+2*I-3+1),ISTORE(BOND+2*I-3+2)
        ENDIF
710   CONTINUE

C--
C-- scan for functional groups and set CSD standard patterns
C-- This also assigns charges in simple cases like  Br-   Na+   ClO4-
C--
      CALL SAMBFG

C--
C-- Final check over for valence error on C N O S
C-- Tidy up by assigning double/single or delocalised
C--
C--
      DO 800 I=1,NATCRY
        CALL SAMCON(I,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        V=0.
        NZ=0
        NMETAL=0
        DO 805 K=1,NCON
          IF (ICOB(K).EQ.0) NZ=NZ+1
          IF (ICOB(K).GE.1 .AND. ICOB(K).LE.4) V=V+FLOAT(ICOB(K))
          IF (ICOB(K).EQ.5 .OR. ICOB(K).EQ.7) V=V+1.50
          IF (ICOB(K).EQ.6) V=V+1.0
          KAT=ICON(K)
          IF (ISTORE(HYBR+KAT-1).GT.100) NMETAL=NMETAL+1
C**      CALL PLUDIJ(IAT,KAT,XO,DIJ(K))
 805    CONTINUE
C-- valence check on elements  --  if problem set M=1
        M=0
C-- carbon
        IF (ISTORE(AELEM-1+I).EQ.1) THEN
          IF (ISTORE(HYBR+I-1).EQ.2 .AND. NINT(V).NE.4) M=1
          IF (NINT(V).GT.4) M=1
        ENDIF
C-- nitrogen
        IF (ISTORE(AELEM-1+I).EQ.56) THEN
          IF (ISTORE(HYBR+I-1).EQ.2 .AND. NINT(V).NE.3) M=1
          IF (NINT(V).GE.5) M=1
        ENDIF
C-- oxygen & sulphur
        IF (ISTORE(AELEM-1+I).EQ.64 .AND. NINT(V)-NMETAL.GT.2) M=1
        IF (ISTORE(AELEM-1+I).EQ.81 .AND. NINT(V)-NMETAL.GT.2) M=1
        IF (M.EQ.1) THEN
          IF(IDEBUG.GT.0) WRITE (LU,9805) I,ISTORE(AELEM-1+I),V
 9805     FORMAT (' Valence problem atom=',I3,' ielc',I3,' v=',F6.1)
        ENDIF
 800  CONTINUE

      IF(IDEBUG.GT.0) THEN
        DO 855 I=1,NBOCRY
          WRITE(LU,9855) ISTORE(BOND+2*I-3+1),ISTORE(BOND+2*I-3+2),
     +                   ISTORE(BTYPE+I-1)
9855      FORMAT(I5,' bond,bt=',3I4)
855     CONTINUE
      ENDIF

      RETURN
      END



CODE FOR SAMCON
      SUBROUTINE SAMCON(IAT,IBON,IBONT,NBONDS,NCON,ICON,ICOB,IPIB)
C-- Function: Get list of connected atoms for given atom Iat.
C-- Version:  27.9.94
C-- Notes:
C-- 1. This uses just the list of bonds (in any order) in IBON(*,3).
C--    Output atoms number in ICON(), count in NCON
C-- 2. Skip suppressed atoms   (bond type 99)
C-- 3. Skip pi-bonds           (bond type 9 ) if IPIB <=0
C--
C-- Arguments:
C-- IAT     given atom number
C-- IBON    list of bonds
C-- IBONT   bond type
C-- NBONDS  number of bonds given in IBON
C-- NCON    output number of connected atoms for Iat
C-- ICON    output list of atoms connected to IAT
C-- ICOB    output bond types for each connection in ICON
C-- IPIB    whether to include pi bonds
C      IMPLICIT NONE

      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'ISTORE.INC'

      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER IAT,IBON,IBONT,NBONDS,NCON,
     +        ICON(30),ICOB(30),IPIB
C-- local
      INTEGER I
C-----------------------------------------------------------
      NCON=0
      DO 100 I=1,NBONDS
        IF (ISTORE(IBONT+I-1).EQ.99) GOTO 100
        IF (IPIB.LE.0 .AND. ISTORE(IBONT+I-1).EQ.9) GOTO 100
        IF (ISTORE(IBON+I*2-3+1).EQ.IAT) THEN
          NCON=NCON+1
          ICON(NCON)=ISTORE(IBON+I*2-3+2)
          ICOB(NCON)=ISTORE(IBONT+I-1)
        ELSEIF (ISTORE(IBON+I*2-3+2).EQ.IAT) THEN
          NCON=NCON+1
          ICON(NCON)=ISTORE(IBON+I*2-3+1)
          ICOB(NCON)=ISTORE(IBONT+I-1)
        ENDIF
        IF (NCON.GE.30) GOTO 101
 100  CONTINUE
 101  CONTINUE
      RETURN
      END
**==samrit.spg  processed by SPAG 4.50F  at 09:04 on  8 Dec 1994


CODE FOR SAMRIT
      SUBROUTINE SAMRIT(RINGAT,NRING,AXYZO,TORANG,TORMAX)
C-- Function: Get torsion angles for atoms in ring given
C-- Version:  6.10.94
C-- Arguments:
C-- RINGAT   defines atom numbers for ring in sequence  1,2,3,4,5,...
C-- NRING    number of atoms in ring
C-- XO       orthogonal coords
C-- TORANG   output torsion angles for 1-2-3-4  2-3-4-5  etc
C-- TORMAX   output max. abs. torsion angle in ring
C--
C--             1 --- 2
C--            .       .
C--           6         3     Example of atoms for 6-membered ring
C--            .       .
C--             5 --- 4
C--
C      IMPLICIT NONE
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER RINGAT(30),NRING
      REAL TORANG(30),TORMAX
      INTEGER AXYZO

C-- local
      INTEGER IAT,JAT,KAT,LAT,I,J,K,L
      REAL AVAL
C-------------------------------------------
      TORMAX=0.0
      DO 50 I=1,NRING
        TORANG(I)=0.0
 50   CONTINUE
      IF (NRING.LT.4) RETURN
      IF (NRING.GT.30) NRING=30
      DO 100 I=1,NRING
        J=I+1
        K=I+2
        L=I+3
        IF (J.GT.NRING) J=MOD(J,NRING)
        IF (K.GT.NRING) K=MOD(K,NRING)
        IF (L.GT.NRING) L=MOD(L,NRING)
        IAT=RINGAT(I)
        JAT=RINGAT(J)
        KAT=RINGAT(K)
        LAT=RINGAT(L)
        CALL SAMTOX(IAT,JAT,KAT,LAT,AXYZO,AVAL)
        TORANG(I)=AVAL
        AVAL=ABS(AVAL)
        IF (AVAL.GT.TORMAX) TORMAX=AVAL
 100  CONTINUE
      END

CODE FOR SAMANF
      SUBROUTINE SAMANF(IAT,JAT,KAT,AXYZO,AVAL)
C--Function:  Get  angle for i-j-k in atom list coords XO.
C--Version:  21.10.94     Sam Motherwell
C--Arguments:
C-- IAT,JAT,KAT  define atom number for torsion anngle i-j-k
C-- XO     othogonal coords
C-- AVAL   returned angle in degrees
C      IMPLICIT NONE
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'

      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER IAT,JAT,KAT
      REAL AVAL
      INTEGER AXYZO

C--local
      REAL X1(3),X2(3),X3(3)
      INTEGER K
C-----------------------------------------------------
      AVAL=0.0
      IF (IAT.LE.0 .OR. JAT.LE.0 .OR. KAT.LE.0) RETURN
      DO 100 K=1,3
        X1(K)=STORE(AXYZO+3*IAT-4+K)
        X2(K)=STORE(AXYZO+3*JAT-4+K)
        X3(K)=STORE(AXYZO+3*KAT-4+K)
 100  CONTINUE
      CALL SAMANG(X1,X2,X3,AVAL)
      RETURN
      END


CODE FOR SAMTOB
      SUBROUTINE SAMTOB(IAT,JAT,IBOC,IBOT,NBOCRY,AXYZO,NTOR,TORANG)
C--Function:  Get torsion angles about bond Iat-Jat
C--Version:  24.10.94     Sam Motherwell
C--Arguments:
C-- IAT,JAT input define atom number for bond in IBOC
C-- XO      input orthogonal coords
C-- NTOR    output number of tor angles found
C-- TORANG  output list of tor angles
C      IMPLICIT NONE
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'

      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER IAT,JAT,IBOC,IBOT,NBOCRY,NTOR
      REAL TORANG(30)
      INTEGER AXYZO

C-- ILIST  controls output to listing file  (usually =0  off)
C-- IDEBUG controls output to listing file  (usually =0  off)
      INTEGER ILIST, IDEBUG
      COMMON /PLUTLI/ ILIST, IDEBUG
C--local
      REAL X1(3),X2(3),X3(3),X4(3),AVAL
      INTEGER K,KAT,LAT,N,M,IPIB
      INTEGER NCONK,ICONK(30),ICOBK(30)
      INTEGER NCONL,ICONL(30),ICOBL(30)
C--------------------------------------------------
      NTOR=0
      IPIB=-1
      IF (IAT.LE.0 .OR. JAT.LE.0) RETURN
C--  Iat - get list of connections  to atom Kat
C--  Jat - get list of connections  to atom Lat
      CALL SAMCON(IAT,IBOC,IBOT,NBOCRY,NCONK,ICONK,ICOBK,IPIB)
      CALL SAMCON(JAT,IBOC,IBOT,NBOCRY,NCONL,ICONL,ICOBL,IPIB)
C-- systematically generate torsion angles k-i-j-l
      DO 100 N=1,NCONK
        KAT=ICONK(N)
        IF (KAT.EQ.JAT) GOTO 100
        DO 150 M=1,NCONL
          LAT=ICONL(M)
          IF (LAT.EQ.IAT) GOTO 150
          IF (KAT.GT.0 .AND. LAT.GT.0) THEN
            DO 200 K=1,3
              X1(K)=STORE(AXYZO+3*KAT-4+K)
              X2(K)=STORE(AXYZO+3*IAT-4+K)
              X3(K)=STORE(AXYZO+3*JAT-4+K)
              X4(K)=STORE(AXYZO+3*LAT-4+K)
 200        CONTINUE
            CALL SAMTOR(X1,X2,X3,X4,AVAL)
            NTOR=NTOR+1
            TORANG(NTOR)=AVAL
            IF (NTOR.GE.30) GOTO 101
            IF(IDEBUG.GT.0) WRITE (STDOUTTERM,9100)
     +       kat,IAT,JAT,lat,aval
 9100       FORMAT (' samtob ',4I3,F6.1)
          ENDIF
 150    CONTINUE
 100  CONTINUE
 101  CONTINUE
      RETURN
      END


CODE FOR SAMTOX
      SUBROUTINE SAMTOX(IAT,JAT,KAT,LAT,AXYZO,AVAL)
C--Function:  Get torsion angle for i-j-k-l in atom list coords XO.
C--Version:  19.8.94     Sam Motherwell
C--Arguments:
C-- IAT,JAT,KAT,LAT  define atom number for torsion anngle i-j-k-l
C-- XO     othogonal coords
C-- AVAL   returned angle in degrees
C      IMPLICIT NONE
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER IAT,JAT,KAT,LAT
      REAL AVAL
      INTEGER AXYZO

C--local
      REAL X1(3),X2(3),X3(3),X4(3)
      INTEGER K

      IF (IAT.LE.0 .OR. JAT.LE.0 .OR. KAT.LE.0 .OR. LAT.LE.0) RETURN

      DO 100 K=1,3
        X1(K)=STORE(AXYZO+3*IAT-4+K)
        X2(K)=STORE(AXYZO+3*JAT-4+K)
        X3(K)=STORE(AXYZO+3*KAT-4+K)
        X4(K)=STORE(AXYZO+3*LAT-4+K)
 100  CONTINUE
      CALL SAMTOR(X1,X2,X3,X4,AVAL)
      RETURN
      END

CODE FOR SAMSBT
      SUBROUTINE SAMSBT(I1,J1,NBT,IBOC,IBOT,NBOCRY)
C-- Function: Set bond type code in list for given bond.
C-- Version:  4.10.94        Sam Motherwell
C-- Arguments:
C--  I1 J1   atom numbers for bond
C--  NBT     bond type code
C--  IBOC    bond list
C--  IBOT    bond type
C--  NBOCRY  number of bonds in list
C      IMPLICIT NONE
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER I1,J1,NBT,IBOC,IBOT,NBOCRY
C-- local
      INTEGER I
      DO 100 I=1,NBOCRY
        IF ((ISTORE(IBOC+I*2-3+1).EQ.I1 .AND.
     +       ISTORE(IBOC+I*2-3+2).EQ.J1) .OR.
     +      (ISTORE(IBOC+I*2-3+1).EQ.J1 .AND.
     +       ISTORE(IBOC+I*2-3+2).EQ.I1)) THEN
          IF ( ISTORE(IBOT+I-1) .GE. 0 ) THEN
            ISTORE(IBOT+I-1)=NBT
          ELSE IF ( NBT .NE. ABS ( ISTORE(IBOT+I-1) ) ) THEN
            WRITE(CMON,'(2(A,A2,I4),/,2(A,I2),A)')'Warning: Bond from ',
     1        ISTORE(L5+(I1-1)*MD5),NINT(STORE(L5+(I1-1)*MD5+1)),' to ',
     1        ISTORE(L5+(J1-1)*MD5),NINT(STORE(L5+(J1-1)*MD5+1)),
     1        'Fixed to: ',ABS(ISTORE(IBOT+I-1)),
     1        ' in L40, but looks like: ',NBT,' to me.'
            CALL XPRVDU(NCVDU,2,0)
          END IF
          GOTO 101
        ENDIF
 100  CONTINUE
 101  RETURN
      END

CODE FOR SAMANG
      SUBROUTINE SAMANG(X1,X2,X3,ANGLE)
C-- Function:   Get angle in degrees x1-x2-x3
C-- Version:    10.11.94   Sam Motherwell   8.12.93
C-- Arguments:
C-- X1      coords for point X1
C-- X2      coords for point X2
C-- X3      coords for point X3
C-- ANGLE   output angle in degrees, 0.0 <= ANGLE <= 180.0
C--         on error, return negative value
C--
C-- local
C-- V, U         unit vector
C--
C      IMPLICIT NONE
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      REAL X1(3),X2(3),X3(3),ANGLE
      REAL U(3),V(3),DU,DV,COSA
      REAL SAMARC, RTOL
      PARAMETER (RTOL=0.000001)
C------------------------------------
      CALL SAMVEC(X2,X1,U,DU)
      CALL SAMVEC(X2,X3,V,DV)
      IF(DU.LT.RTOL .OR. DV.LT.RTOL) THEN
        ANGLE=-360.0
      ELSE
        COSA=U(1)*V(1)+U(2)*V(2)+U(3)*V(3)
        ANGLE=SAMARC(COSA)
      ENDIF
      RETURN
      END

CODE FOR SAMARC
      FUNCTION SAMARC(XX)
C-- Function: Get the angle whose cosine is XX. Return angle in degrees.
C-- Version:   8.12.94     1.2.94               Sam Motherwell
C      IMPLICIT NONE
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      REAL SAMARC,XX

      IF (1.0-ABS(XX)) 10,20,20
 10   XX=SIGN(1.0,XX)
 20   IF (XX) 30,40,50
 30   SAMARC=180.0+ATAN(SQRT(1.0-XX*XX)/XX)*57.29577951
      GOTO 60
 40   SAMARC=90.0
      GOTO 60
 50   SAMARC=ATAN(SQRT(1.0-XX*XX)/XX)*57.29577951
 60   RETURN
      END

CODE FOR SAMBFG
      SUBROUTINE SAMBFG
C-- Function:  Bond assignment for groups. Assign standard patterns
C--            to  certain functional groups as in CSD
C-- Version:   29.9.95           Sam Motherwell   18.9.95
C-- Notes:
C-- 1. Auxiliary to SAMABO.  This is called in the stage 2 (Tidy Up)
C--    All connectivity has been set up in
C--    AELEM    element type
C--    NHYC     number of terminal H
C--    NCAC     number of connections other than terminal H
C--    ATRESN   residue number
C--    BOND     list of bonds Iat, Jat
C      BTYPE    nbt
C--    NATCRY   number of atoms
C--    NBOCRY   number of bonds
C--
C-- 2. scan is made for those functional groups known to give
C--    trouble with the automatic bond assignment in SAMABO. For
C--    example  carboxylate.  Also groups like perchlorate  ClO4- are
C--    explicity recognised and assigned a pattern of 3 double, one single bond
C--
C-- 3. Charges.  In some simple cases one can deduce an ionic change.
C--    For example,   Na +    Cl-   or  ClO4 -      NR4 +
C--    The charge is assigned to an array  ATCHG as output COMMON PLUTAC
C--
C      IMPLICIT NONE

      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

C ........... Molecule Viewer Atom DATa .............
C INT  TATOM             : total number of atoms to be displayed
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INTEGER TATOM, AELEM, AXYZO, ATRESN, HYBR
      COMMON /MVADAT/ TATOM,AXYZO,AELEM, ATRESN, HYBR
C..........................................................................
C
C ........... Molecule Viewer Bond DATa .............
C INT  TBOND          : total number of atoms to be displayed
       INTEGER TBOND, BOND, BTYPE
       COMMON /MVBDAT/ TBOND,BOND,BTYPE
C..........................................................................
C-- 3D crystal connectivity (see also plutqz)
C-- query connectivity
      INTEGER NHYC,NCAC
      INTEGER NATCRY,NBOCRY
      COMMON /PLUTQY/ NHYC,NCAC,NATCRY,NBOCRY
C
C ........... Molecule Viewer CHARacter data .............
C
C MVMXLB : Maximum number of characters stored for each 3D atom label
      INTEGER    MVMXLB
      PARAMETER (MVMXLB=10)
C Note: If you change this label length, please also change the
C       declaration of the funct NAME3D, and all places where
C       it is referenced. Thanks.
C..........................................................................
C-- ILIST  controls output to listing file  (usually =0  off)
C-- IDEBUG controls output to listing file  (usually =0  off)
      INTEGER ILIST, IDEBUG
      COMMON /PLUTLI/ ILIST, IDEBUG
      INTEGER  ATCHG, AROMA, NAROMA
      COMMON /PLUTAC/ ATCHG, AROMA, NAROMA

C-- ATVAL     atom valency - temporary use for checking
      INTEGER ATVAL

C-- local
      INTEGER  I,J,K,M,LU,CHGMIN,CHGPLU,IAT,JAT,KAT,KOXY,KMETAL
      INTEGER  JMIN,JMAX,NBT,ICASE,NZ

      INTEGER  ICON(30),JCON(30),ICOB(30),JCOB(30),NCON,MCON
      INTEGER  ATLIST(30),NLIST,KLIST,JLINK,IPIB
      REAL V,DMIN,DMAX,DIST(30),D1
C-------------------------------------------------------

C CFM 7-Oct-1995 Initialisation of LU moved, so that it occurs
C CCF            before the first potential use of LU.
      LU=STDOUTTERM

      CHGPLU=0
      CHGMIN=0
C--
C-- ignore pi-bonds
      IPIB=-1
C--
C-- look for single atom residues and assign charge if needed
C-- Skip suppressed atoms  which have iarc = -1
C--
      CHGMIN=0
      CHGPLU=0
      DO 100 I=1,NATCRY
      ISTORE(ATCHG+I-1)=0
      IF(ISTORE(ATRESN+I-1).LE.0) GOTO 100
      IF(ISTORE(NCAC+I-1).EQ.0) THEN
      K=ISTORE(AELEM-1+I)
C-- F  Cl Br I
      IF(K.EQ.32 .OR. K.EQ.21 .OR. K.EQ.16 .OR. K.EQ.43)THEN
        ISTORE(ATCHG+I-1)=-1
        CHGMIN=CHGMIN-1
        ENDIF
C-- Li Na K  Rb Cs     (+1)
      IF(K.EQ.49 .OR. K.EQ.57 .OR. K.EQ.46 .OR. K.EQ.76
     +  .OR. K.EQ.25)THEN
        ISTORE(ATCHG+I-1)=1
        CHGPLU=CHGPLU+1
        ENDIF
C-- Be Mg Ca Sr Ba Ra  (+2)
      IF(K.EQ.13 .OR. K.EQ.53 .OR. K.EQ.17 .OR. K.EQ.88
     +   .OR. K.EQ.12 .OR. K.EQ.75) THEN
        ISTORE(ATCHG+I-1)=2
        CHGPLU=CHGPLU+2
        ENDIF

       ENDIF
100    CONTINUE
C--
C--
C-- Loop through all atoms  --  look for specified groups
C--
C--
      DO 500 I=1,NATCRY
      IF(ISTORE(ATRESN+I-1).LE.0) GOTO 500
C--
C--  quaternary N      e.g    -NH3 +    NH4 +    c-NH2-c   HN- (C)3   N-(C)4
C--                    This does not apply if connected N - metal
C--
      IF(ISTORE(AELEM-1+I).EQ.56 .AND. ISTORE(HYBR+I-1).EQ.3) THEN
        IAT=I
        CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        KMETAL=0
        DO 110 J=1,NCON
        JAT=ICON(J)
        IF(ISTORE(HYBR+JAT-1).GT.100) KMETAL=KMETAL+1
110     CONTINUE

        IF(KMETAL.EQ.0 .AND. NCON.EQ.4)THEN
          ISTORE(ATCHG+I-1)=+1
          CHGPLU=CHGPLU+1
          ENDIF
        ENDIF
C--
C-- Planar nitrogen with 3 connections and valence 4       C = N (R)2
C--
C--                                                        C = NH2
C--

      IF( (ISTORE(AELEM-1+I).EQ.56 .AND. ISTORE(NCAC+I-1).EQ.3 .AND.
     +     ISTORE(HYBR+I-1).EQ.2)
     +.OR.(ISTORE(AELEM-1+I).EQ.56 .AND. ISTORE(NCAC+I-1).EQ.1 .AND.
     +     ISTORE(NHYC+I-1).EQ.2)) THEN

        IAT=I
        CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        KMETAL=0
        V=0.0
        DO 115 J=1,NCON
        JAT=ICON(J)
        IF(ISTORE(HYBR+JAT-1).GT.100) KMETAL=KMETAL+1
        IF(ICOB(J).EQ.7) THEN
          V=V+1.51
        ELSEIF(ICOB(J).EQ.5) THEN
          V=V+1.34
        ELSE
          V=V+FLOAT(ICOB(J))
        ENDIF
115     CONTINUE
        ICASE=0
        IF(KMETAL.EQ.0 .AND. NINT(V).EQ.4
     +  .AND. ISTORE(NCAC+JAT-1).EQ.3) ICASE=1
        IF(KMETAL.EQ.0 .AND. NINT(V).EQ.4
     +  .AND. ISTORE(NHYC+JAT-1).EQ.2) ICASE=2

        IF(ICASE.GT.0) THEN
          ISTORE(ATCHG+I-1)=+1
          CHGPLU=CHGPLU+1
          ENDIF
        ENDIF
C--
C-- Thiocyanate.
C--
      IF(ISTORE(AELEM-1+I).EQ.1 .AND. ISTORE(NCAC+I-1).EQ.2) THEN
        IAT=I
        CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        JAT=ICON(1)
        KAT=ICON(2)
        KOXY=0
C-- see if C bound to N and S alone
        IF(ISTORE(AELEM-1+JAT).EQ.56 .AND.
     +     ISTORE(AELEM-1+KAT).EQ.81) THEN
          KOXY=KAT
        ELSEIF(ISTORE(AELEM-1+KAT).EQ.56 .AND.
     +         ISTORE(AELEM-1+JAT).EQ.81) THEN
          KOXY=JAT
C-- swap KAT, JAT
          JAT=KAT
          KAT=KOXY
        ENDIF
C-- check N and S monocoordinate
        IF(KOXY.GT.0 .AND. ISTORE(NCAC+JAT-1).EQ.1 .AND.
     +                     ISTORE(NHYC+JAT-1).EQ.0
     +               .AND. ISTORE(NCAC+KAT-1).EQ.1 .AND.
     +                     ISTORE(NHYC+KAT-1).EQ.0) THEN
C-- set charge and standard bond patterns
          ISTORE(ATCHG+KAT-1)=-1
          CHGMIN=CHGMIN-1
C-- S-C bond single
          NBT=1
          CALL SAMSBT(IAT,KAT,NBT,BOND,BTYPE,NBOCRY)
C-- C-N bond triple
          NBT=3
          CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
        ENDIF
      ENDIF

C--
C-- Carboxylate.        detect    a - C - O        A - C - S
C-- Thiocarboxylate                   |                |
C--                                   O                S
C--
C--                  this can include carbonate   CO3--
C-- If C connected atoms not 3  , or not planar, then skip
C-- Check the valence of the carbon by counting bond type 1 & 2
      IF(ISTORE(AELEM-1+I).EQ.1 .AND. ISTORE(NCAC+I-1).EQ.3 .AND.
     +   ISTORE(HYBR+I-1).EQ.2)THEN
        IAT=I
        CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        V=0.0
        KOXY=0
        DO 155 J=1,NCON
        JAT=ICON(J)
        IF(ISTORE(AELEM-1+JAT).EQ.64 .OR.
     +     ISTORE(AELEM-1+JAT).EQ.81) KOXY=KOXY+1
        V=V+FLOAT(ICOB(J))
155     CONTINUE
        IF( KOXY.GE.2) THEN
C--   Carboxylate detected.
C--   Now look for a metal connected to either
C--   oxygen.  A metal is detected by the HYBR > 100.
          KMETAL=0
          DO 160 J=1,NCON
          JAT=ICON(J)
          CALL SAMCON(JAT,BOND,BTYPE,NBOCRY,MCON,JCON,JCOB,IPIB)
          DO 165 K=1,MCON
          KAT=JCON(K)
          IF(ISTORE(HYBR+KAT-1).GT.100) KMETAL=KMETAL+1
165       CONTINUE
160       CONTINUE
          ENDIF
      ICASE=0
      IF(KOXY.GE.2 .AND. NINT(V).NE.4 .AND. KMETAL.LE.1) ICASE=1
      IF(KOXY.GE.2 .AND. NINT(V).NE.4 .AND. KMETAL.GE.2) ICASE=2

C--
C-- carboxylate  case 1.    Metal-O  = 0   or  =1
C-- set carboxylate  as double/single bonds     O = C - O (- charge)
C-- with C=O assigned to the shortest bond.

      IF(ICASE.EQ.1) THEN
         IF(IDEBUG.GT.0)write(lu,*)'carboxylate case 1 kmetal=',kmetal
         DMIN=999.
         DMAX=-999.
         JMIN=1
         JMAX=1
         DO 170 J=1,NCON
         JAT=ICON(J)
         CALL PLUDIJ(IAT,JAT,AXYZO,DIST(J))
         IF(ISTORE(AELEM-1+JAT).EQ.64 .OR.
     +      ISTORE(AELEM-1+JAT).EQ.81) THEN
           IF(DIST(J).LT.DMIN) THEN
              JMIN=JAT
              DMIN=DIST(J)
              ENDIF
           IF(DIST(J).GT.DMAX) THEN
              JMAX=JAT
              DMAX=DIST(J)
              ENDIF
           ENDIF
170      CONTINUE
C-- set a double bond for shorter C-O
         NBT=2
         CALL SAMSBT(IAT,JMIN,NBT,BOND,BTYPE,NBOCRY)
C-- set single bond for longer C-O    and charge -1 on O
         NBT=1
         CALL SAMSBT(IAT,JMAX,NBT,BOND,BTYPE,NBOCRY)
         IF (ISTORE(NCAC+JMAX-1).LE.1 .AND.
     +       ISTORE(NHYC+JMAX-1).LE.0) THEN
            ISTORE(ATCHG+JMAX-1)=-1
            CHGMIN=CHGMIN-1
         ENDIF
C**         ATVAL(IAT)=4
         ENDIF

C--
C-- carboxylate case 2.    Metal connection at  both oxygens
C--                        Set delocalised bond b=7
C--
      IF(ICASE.EQ.2) THEN
        IF(IDEBUG.GT.0)write(lu,*) 'carboylate case 2 kmetal ',kmetal
        DO 175 J=1,NCON
        JAT=ICON(J)
        IF(ISTORE(AELEM-1+JAT).EQ.64 .OR.
     +     ISTORE(AELEM-1+JAT).EQ.81) THEN
          NBT=7
          CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
          ENDIF
175     CONTINUE
C**        ATVAL(IAT)=4
        ENDIF
C-- end of carboxylate section
       ENDIF
C--
C--
C-- CLO4 -    perchlorate.  Set 3 bonds double, one single with charge -1 on O
C--                         If there is an Oxygen with more than one
C--                         connection, give it the single bond,
C--                         and only apply a negative charge if exactly 1
C--                         connection.
C--
C--                         This whole code is actually still too selective,
C--                         as the assignment of charge is done only
C--                         if there is a valency error at the root atom.
C--                         In cases where bonds are assigned correctly,
C--                         the charge can never be set.
C--
      IF(ISTORE(AELEM-1+I).EQ.21 .AND. ISTORE(NCAC+I-1).EQ.4) THEN
        IAT=I
        KOXY=0
        CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        JLINK=0
        DO 180 J=1,NCON
        JAT=ICON(J)
        IF(ISTORE(AELEM-1+JAT).EQ.64) THEN
           KOXY=KOXY+1
           IF(ISTORE(NCAC+JAT-1).GT.1)JLINK=JAT
           IF(JLINK.EQ.0 .AND. J.EQ.NCON) JLINK=JAT
        ENDIF
180     CONTINUE
        IF(KOXY.EQ.4) THEN
          DO 185 J=1,NCON
          JAT=ICON(J)
          NBT=2
          IF(JAT.EQ.JLINK) NBT=1
          CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
          IF(JAT.EQ.JLINK .AND. ISTORE(NCAC+JAT-1).EQ.1 .AND.
     +       ISTORE(NHYC+JAT-1).EQ.0) THEN
             ISTORE(ATCHG+JAT-1)=-1
             CHGMIN=CHGMIN-1
             ENDIF
185       CONTINUE
          ENDIF
         ENDIF

C--
C-- BF4 -         set charge -1 on B
C--
      IF(ISTORE(AELEM-1+I).EQ.11 .AND. ISTORE(NCAC+I-1).EQ.4) THEN
         IAT=I
         CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
         K=0
         DO 190 J=1,NCON
         JAT=ICON(J)
         IF(ISTORE(AELEM-1+JAT).EQ.32) K=K+1
190      CONTINUE
         IF(K.EQ.4) THEN
            ISTORE(ATCHG+IAT-1)=-1
            CHGMIN=CHGMIN-1
            ENDIF
         ENDIF
C--
C-- NO3 -
C--        If there is an Oxygen with more than one
C--        connection, give it the single bond,
C--        and only apply a negative charge if exactly 1
C--        connection.
C--
C--        This whole code is actually still too selective,
C--        as the assignment of charge is done only
C--        if there is a valency error at the root atom.
C--        In cases where bonds are assigned correctly,
C--        the charge can never be set.
C--
      IF(ISTORE(AELEM-1+I).EQ.56 .AND. ISTORE(HYBR+I-1).EQ.2 .AND.
     +   ISTORE(NCAC+I-1).EQ.3) THEN
         IAT=I
         CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
         KOXY=0
         JLINK=0
         DO 195 J=1,NCON
         JAT=ICON(J)
         IF(ISTORE(AELEM-1+JAT).EQ.64) THEN
            KOXY=KOXY+1
            IF(ISTORE(NCAC+JAT-1).GT.1)JLINK=JAT
            IF(JLINK.EQ.0 .AND. J.EQ.NCON) JLINK=JAT
         ENDIF
195      CONTINUE
         IF(KOXY.EQ.3) THEN
           DO 196 J=1,NCON
           JAT=ICON(J)
           NBT=2
           IF(JAT.EQ.JLINK) NBT=1
           CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
           IF(JAT.EQ.JLINK .AND. ISTORE(NCAC+JAT-1).EQ.1 .AND.
     +        ISTORE(NHYC+JAT-1).EQ.0) THEN
             ISTORE(ATCHG+JAT-1)=-1
             CHGMIN=CHGMIN-1
             ENDIF
196        CONTINUE
           ENDIF
         ENDIF
C--
C-- SO3   AND SO4 --      Count terminal oxygens.
C--                       Assign S=O to first two,   S-O (minus) to rest
C--
C--                       Note that this is not selective enough, as the
C--                       order of bonds to S is arbitrary.
C--
      IF(ISTORE(AELEM-1+I).EQ.81 .AND. ISTORE(NCAC+I-1).EQ.4) THEN
         KOXY = 0
         IAT=I
         CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
         DO 200 J=1,NCON
         JAT=ICON(J)
         IF(ISTORE(AELEM-1+JAT).EQ.64  .AND.
     +      ISTORE(NCAC+JAT-1).EQ.1) KOXY=KOXY+1
200      CONTINUE
         IF(KOXY.GE.3) THEN
          DO 205 J=1,NCON
          JAT=ICON(J)
          IF(ISTORE(AELEM-1+JAT).NE.64) GOTO 205
          NBT=2
          IF(J.GE.3) NBT=1
          CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
C         (but we do not know if the first two were oxygens!)
          IF(J.GE.3 .AND. ISTORE(NHYC+JAT-1).EQ.0) THEN
              ISTORE(ATCHG+JAT-1)=-1
              CHGMIN=CHGMIN-1
              ENDIF
205       CONTINUE
          ENDIF
         ENDIF
C--
C-- PF6 (-)
C--
        IF(ISTORE(AELEM-1+I).EQ.66 .AND. ISTORE(NCAC+I-1).EQ.6) THEN
           ISTORE(ATCHG+I-1)=-1
           CHGMIN=CHGMIN-1
           ENDIF
C--
C-- diazo group          C - N (+) triple N         diazonium salt (case 1)
C--                      C = N (+) = N (-)          diazo          (case 2)
C--
        IF(ISTORE(AELEM-1+I).EQ.56 .AND. ISTORE(NCAC+I-1).EQ.1
     +    .AND. ISTORE(HYBR+I-1).EQ.1) THEN
         IAT=I
         CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
         K=0
         DO 206 J=1,NCON
         JAT=ICON(J)
         IF(ISTORE(AELEM-1+JAT).EQ.56 .AND. ICOB(J).EQ.3) K=1
206      CONTINUE
C-- we take a look at the bond to the Carbon (kat).  If this is
C-- a single bond then leave it - and set case 1
C-- if a double  then  set as case 2
         ICASE=0
         IF(K.EQ.1) THEN
           ICASE=1
           CALL SAMCON(JAT,BOND,BTYPE,NBOCRY,MCON,JCON,JCOB,IPIB)
           DO 207 J=1,MCON
           KAT=JCON(J)
           IF(JCOB(J).EQ.2)  ICASE=2
207        CONTINUE
           ENDIF

         IF(ICASE.EQ.1) THEN
            ISTORE(ATCHG+JAT-1)=1
            ISTORE(ATCHG+IAT-1)=0
            CHGPLU=CHGPLU+1
            ENDIF
         IF(ICASE.EQ.2) THEN
            ISTORE(ATCHG+JAT-1)=1
            ISTORE(ATCHG+IAT-1)=-1
            NBT=2
            CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
            ENDIF
         ENDIF

C-- end loop on all atoms -- fixing secified groups
500   CONTINUE
C--
C-- check over for valence error on C N O S
C--
C-- Fix up any delocalised C bonding problems
C--
      DO 550 I=1,NATCRY
        CALL SAMCON(I,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
        V=0.
        NZ=0
        KMETAL=0
        DO 805 K=1,NCON
          IF (ICOB(K).EQ.0) NZ=NZ+1
          IF (ICOB(K).GE.1 .AND. ICOB(K).LE.4) THEN
            V=V+FLOAT(ICOB(K))
C**          ELSEIF (ICOB(K).EQ.5) THEN
C**            V=V+1.34
          ELSEIF (ICOB(K).EQ.5 .OR. ICOB(K).EQ.7) THEN
            V=V+1.50
          ELSEIF (ICOB(K).EQ.6) THEN
            V=V+1.0
          ENDIF
          KAT=ICON(K)
          IF (ISTORE(HYBR+KAT-1).GT.100) KMETAL=KMETAL+1
C**      CALL PLUDIJ(IAT,KAT,XO,DIJ(K))
 805    CONTINUE
C-- save integer value for valence.  Ensure that 4.500   = 4 integer
        ATVAL=NINT(V - 0.001)
C-- valence check on elements  --  if problem set M=1
        M=0
C-- carbon
        IF (ISTORE(AELEM-1+I).EQ.1) THEN
          IF (ISTORE(HYBR+I-1).EQ.2 .AND. NINT(V).NE.4) M=1
          IF (NINT(V).GT.4) M=1
        ENDIF
C-- nitrogen
        IF (ISTORE(AELEM-1+I).EQ.56) THEN
          IF (ISTORE(HYBR+I-1).EQ.2 .AND. NINT(V).NE.3) M=1
          IF (NINT(V).GE.5) M=1
        ENDIF
C-- oxygen & sulphur
        IF (ISTORE(AELEM-1+I).EQ.64 .AND. NINT(V)-KMETAL.GT.2) M=1
        IF (ISTORE(AELEM-1+I).EQ.81 .AND. NINT(V)-KMETAL.GT.2) M=1
        IF (M.EQ.1) THEN
        ENDIF
        IF(ISTORE(ATRESN+I-1).LE.0) GOTO 550
C--
C-- detect Carbon valency problems.   These indicate delocalisation
C--
C-- One of the most common examples is acetylacetonate ligands. The
C-- principle is to fix the problem at the atom flagged by setting
C-- delocalised bonds type b=7  for bond dij < 1.40
C-- Then work outward to beta-atoms, and set any double bonds to delocalised
C-- and any to hetero atoms  O or N


C-- carbon only
        IF (ISTORE(AELEM-1+I).EQ.1) THEN
          ICASE=0
          IAT=I
C-- check for valence 3  on   planar C
          IF (ISTORE(HYBR+I-1).EQ.2 .AND. ATVAL.NE.4) ICASE=1
C-- check for valence 5
          IF (ATVAL.EQ.5) ICASE=2
C-- check for    C = C = C    and no hybridisation state known
C-- count the double bonds b=2
          IF (ISTORE(HYBR+I-1).EQ.0 .AND. ISTORE(NHYC+I-1).EQ.0
     +    .AND. ISTORE(NCAC+I-1).EQ.2) THEN
            K=0
            KMETAL=0
            CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
            DO 210 J=1,NCON
            JAT=ICON(J)
            IF(ISTORE(HYBR+JAT-1).GT.100) KMETAL=KMETAL+1
            IF(ICOB(J).EQ.2) K=K+1
210         CONTINUE
            IF(K.GT.1)  ICASE=3
            IF(KMETAL.GT.0) ICASE=0
            ENDIF
C-- if C valence > 5   then probably in a metal cluster. Leave alone
          IF(ATVAL.GT.5) ICASE=0

C-- first set delocalised b=7 for short bonds on this atom Iat
C-- Thus   C-C=C      or  C=C=C     becomes    C..C..C
C-- Make a note of the alpha-atoms in the list ATLIST
C-- Exclude H atoms    el=2 from any delocalised net.
C-- Stop delocalisation if C - N    el=56
C-- Stop delocalisation if C - Metal bond found
C-- Stop delocalise if aromatic bond found  b=5
          IF(ICASE.GT.0) THEN
            CALL SAMCON(IAT,BOND,BTYPE,NBOCRY,NCON,ICON,ICOB,IPIB)
            DO 218 J=1,NCON
            JAT=ICON(J)
            IF(ISTORE(AELEM-1+JAT).EQ.56 )  ICASE=-1
            IF(ISTORE(HYBR+JAT-1).GT.100)  ICASE=-1
            IF(ICOB(J).EQ.5)  ICASE=-1
218         CONTINUE

            NLIST=0
            KLIST=0
            IF(ICASE.GT.0) THEN
              DO 220 J=1,NCON
              JAT=ICON(J)
              CALL PLUDIJ(IAT,JAT,AXYZO,D1)
              IF(D1.LT. 1.450  .AND. ISTORE(AELEM-1+JAT).NE.2)  THEN
                NBT=7
                CALL SAMSBT(IAT,JAT,NBT,BOND,BTYPE,NBOCRY)
                NLIST=NLIST+1
                ATLIST(NLIST)=JAT
                ENDIF
220           CONTINUE
              ENDIF
C--
C-- now do the same for the alpha atoms, extending the b=7 network
C-- the only candidates are bonds with d<1.450
C-- This by good luck stops expansion to metal centres, or to non-conjugated
C-- bonds.  The distance 1.450  may need some experimental adjustment.
C--
            IF(NLIST.GT.0) THEN
              IF(IDEBUG.GT.0)WRITE(LU,*)'atlist=',(atlist(k),k=1,nlist)
               KLIST=0
               DO 230 J=1,NLIST
               JAT=ATLIST(J)
               CALL SAMCON(JAT,BOND,BTYPE,NBOCRY,MCON,JCON,JCOB,IPIB)
               DO 240 K=1,MCON
               IF(JCOB(K).EQ.7) GOTO 240
               KAT=JCON(K)
               CALL PLUDIJ(JAT,KAT,AXYZO,D1)

               IF(D1.LT. 1.450  .AND. ISTORE(AELEM-1+KAT).NE.2) THEN
                  NBT=7
                  CALL SAMSBT(JAT,KAT,NBT,BOND,BTYPE,NBOCRY)
                  KLIST=KLIST+1
                  ATLIST(NLIST+KLIST)=KAT
                  ENDIF
240            CONTINUE
230            CONTINUE
               ENDIF
C-- if beta atoms then repeat extension process ( and thats as far as we go)

            IF(KLIST.GT.0) THEN
               IF(IDEBUG.GT.0)write(lu,*) 'KLIST=', KLIST
               IF(IDEBUG.GT.0)WRITE(LU,*) 'atlist=',
     +            (atlist(k),k=1,nlist+klist)
               DO 250 J=1,KLIST
               JAT=ATLIST(J+NLIST)
               CALL SAMCON(JAT,BOND,BTYPE,NBOCRY,MCON,JCON,JCOB,IPIB)
               DO 260 K=1,MCON
               IF(JCOB(K).EQ.7) GOTO 260
               KAT=JCON(K)
               CALL PLUDIJ(JAT,KAT,AXYZO,D1)
               IF(D1.LT. 1.450 .AND. ISTORE(AELEM-1+KAT).NE.2) THEN
                  NBT=7
                  CALL SAMSBT(JAT,KAT,NBT,BOND,BTYPE,NBOCRY)
                  ENDIF
260            CONTINUE
250            CONTINUE
               ENDIF

            ENDIF

C-- end of section for Carbon delocalised
           ENDIF



550   CONTINUE


C--
C-- Final assignmemt of balancing charge to metal atom(s)
C--
C-- In cases with no metal  like  NR4(+)   Cl(-)   all OK
C-- Cases like    ClO4(-)   and Cu      assign  (+1) to the Cu
C--
C-- Count number of neutral metals, and split charge evenly among them.
C-- Do not allow balancing charge -ve on metals, must be +1 , +2, etc
C--
      K=CHGPLU+CHGMIN
      IF(IDEBUG.GT.0)WRITE(LU,*)
     +   ' chgplu ', chgplu, ' chgmin' , chgmin
      J=K
      IF(K.LT.0 ) THEN
        KMETAL=0
        J=IABS(K)
        DO 555 I=1,NATCRY
        IF(ISTORE(ATRESN+I-1).LE.0) GOTO 555
        IF(ISTORE(HYBR+I-1).GT.100 .AND.
     +     ISTORE(ATCHG+I-1).EQ.0) KMETAL=KMETAL+1
555     CONTINUE
        IF(KMETAL.GT.0) THEN
          M=J/KMETAL
          IF(M.EQ.0) M=1
          DO 560 I=1,NATCRY
          IF(ISTORE(HYBR+I-1).GT.100) THEN
            ISTORE(ATCHG+I-1)=M
            J=J-M
            IF(J.LE.0) GOTO 561
            ENDIF
560       CONTINUE
561       CONTINUE
          ENDIF
        ENDIF
c        IF(J.NE.0) THEN
c        WRITE(LU,*)'WARNING - unbalanced charge sum =', J
c        ENDIF



      RETURN
      END

CODE FOR SAMCC3
      SUBROUTINE SAMCC3
C-- Function:  set up 3D connectivity arrays in PLUTQY common
C--            using MV arrays as input
C-- Version:   26.9.95                 Sam Motherwell    26.9.95
C-- Notes:
C-- 1. This is useful in several places in Pluto / Prequest.  It works
C--    on the 3D crystallographic connectivity data.
C--    Input is the list of atoms   1 - Tatom
C--    and  list of bonds BOND(*,2) and bond-types ISTORE(BTYPE+-1).    1 - Tbond
C--    Output:
C--          NHYC    number of terminal hydrogens
C--          NCAC    number of connections (excluding terminal H)
C--
C      IMPLICIT NONE


C
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM
C ........... Molecule Viewer Bond DATa .............
C INT  TBOND          : total number of atoms to be displayed
       INTEGER TBOND, BOND, BTYPE
       COMMON /MVBDAT/ TBOND,BOND,BTYPE
C..........................................................................
C
C ........... Molecule Viewer Atom DATa .............
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INTEGER TATOM, AELEM, AXYZO, ATRESN, HYBR
      COMMON /MVADAT/ TATOM,AXYZO,AELEM, ATRESN, HYBR
C..........................................................................
C-- 3D crystal connectivity (see also plutqz)
C-- query connectivity
      INTEGER NHYC,NCAC
      INTEGER NATCRY,NBOCRY
      COMMON /PLUTQY/ NHYC,NCAC,NATCRY,NBOCRY
C-- local
      INTEGER I,IAT,JAT
C--------------------------------------------------------
C--
C-- set up arrays for 3D crystal connectivity
C--
C-- NATCRY  number of atoms,   NBOCRY  number of bonds
      NATCRY=TATOM
      NBOCRY=TBOND
C-- set element type IELC,  residue IARC,
C-- number of connections NCAC = 0,   number of terminal hyds NHYC = 0
      DO 20 I=1,NATCRY
        ISTORE(NCAC+I-1)=0
        ISTORE(NHYC+I-1)=0
 20   CONTINUE
C-- process the bonds, setting number of connections NCAC exclude terminal H
C-- Omit any bonds involving suppressed atoms with incl < 0
      DO 21 I=1,NBOCRY
        IAT=ISTORE(BOND+2*I-3+1)
        JAT=ISTORE(BOND+2*I-3+2)
        IF (ISTORE(AELEM-1+JAT).NE.2)
     +    ISTORE(NCAC+IAT-1)=ISTORE(NCAC+IAT-1)+1
        IF (ISTORE(AELEM-1+IAT).NE.2)
     +    ISTORE(NCAC+JAT-1)=ISTORE(NCAC+JAT-1)+1
 21   CONTINUE
C-- set number of terminal H ,  element code hydrogen = 2
C-- Detect bridge H here, and add this bond to the nca for the atoms bridged.

      DO 22 I=1,NBOCRY
        IAT=ISTORE(BOND+2*I-3+1)
        JAT=ISTORE(BOND+2*I-3+2)
        IF (ISTORE(AELEM-1+IAT).EQ.2 .AND. ISTORE(NCAC+IAT-1).EQ.1)
     +    ISTORE(NHYC+JAT-1)=ISTORE(NHYC+JAT-1)+1
        IF (ISTORE(AELEM-1+JAT).EQ.2 .AND. ISTORE(NCAC+JAT-1).EQ.1)
     +    ISTORE(NHYC+IAT-1)=ISTORE(NHYC+IAT-1)+1
        IF (ISTORE(AELEM-1+IAT).EQ.2 .AND. ISTORE(NCAC+IAT-1).GE.2)
     +    ISTORE(NCAC+JAT-1)=ISTORE(NCAC+JAT-1)+1
        IF (ISTORE(AELEM-1+JAT).EQ.2 .AND. ISTORE(NCAC+JAT-1).GE.2)
     +    ISTORE(NCAC+IAT-1)=ISTORE(NCAC+IAT-1)+1
 22   CONTINUE

      RETURN
      END



CODE FOR SAMPIQ
      SUBROUTINE SAMPIQ(IAT,JAT,IEL,IBON,IBONT,NBON,IPIBON)
C--
C-- Function: Pi-bond query - is bond Iat-Jat a pi-bond.
C-- Version:  24.2.95   8.12.94    Sam Motherwell
C-- Notes:
C--    jat  C -- C  kat
C--          \  /
C--           Tr
C--         iat
C--    The test is simply to find the above triangle
C--
C-- Arguments:
C-- IAT, JAT   definde the input query bond
C-- IEL        table of element codes
C-- IBON       bond list input for structure
C-- IBONT      bond type list
C-- NBON       number of bonds in list
C-- IPIBON     returned answer =0 not pi-bond,  =1 pibond
C      IMPLICIT NONE
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER IAT,JAT,IEL,IPIBON,NBON,IBON
      INTEGER IBONT
C-- local
      INTEGER NCX,NCK,K,L,KAT,I1,I2,IAT1,JAT1,IPIB
      INTEGER ILIG(30),LMIG(30),KLIG(30)
C-- NONTR   is a table of element numbers for non-transition metals
      INTEGER NONTR(31),NMTAB
      DATA NMTAB/31/
      DATA NONTR/1,2,8,11,12,13,14,16,17,21,27,32,36,38,39,43,46,49,53,
     +     56,57,60,64,66,81,82,84,85,87,92,101/
C--------------------------------------------------------------------
C--
C-- we assume that the connection table is correctly set up.
C-- each atom has a maximum of 29 connections.  (*,30) is the number of conn.
C--
C-- check that atom IAT is a transiton metal.
      IPIBON=0
      I1=0
      I2=0
      DO 50 K=1,NMTAB
        IF (ISTORE(IEL+IAT-1).EQ.NONTR(K)) I1=K
        IF (ISTORE(IEL+JAT-1).EQ.NONTR(K)) I2=K
 50   CONTINUE
      CONTINUE
C**         WRITE(6,*)'sampiq iat,jat ',IAT,JAT, ' no Tr metal'
      IF (I1.GT.0 .AND. I2.GT.0) RETURN

C-- swap so Tr metal is Iat
      IF (I1.EQ.0) THEN
        IAT1=IAT
        JAT1=JAT
      ELSE
        IAT1=JAT
        JAT1=IAT
      ENDIF
C**         WRITE(6,*)'sampiq iat,jat ',IAT,JAT,' no Tr-C'
      IF (ISTORE(IEL+JAT1-1).NE.1) RETURN

C-- NC is number of connections to Metal atom Iat. Search these for
C-- a Carbon   (istore(iel)=1)  which bonds to the carbon atom Jat.
C-- including bonds already assigned as pi-bonds
      IPIB=1
      CALL SAMCON(IAT1,IBON,IBONT,NBON,NCX,ILIG,LMIG,IPIB)
      DO 100 K=1,NCX
        KAT=ILIG(K)
        IF (KAT.EQ.JAT1) GOTO 100
        IF (ISTORE(IEL+KAT-1).NE.1) GOTO 100
        CALL SAMCON(KAT,IBON,IBONT,NBON,NCK,KLIG,LMIG,IPIB)
        DO 110 L=1,NCK
          IF(KLIG(L).EQ.JAT1) IPIBON=1
 110    CONTINUE
        IF (IPIBON.GT.0) GOTO 101
 100  CONTINUE
 101  CONTINUE
C**      WRITE(6,*)'sampiq iat,jat', iat,jat, ' ipibon=',ipibon
      RETURN
      END

CODE FOR SAMRIQ
      SUBROUTINE SAMRIQ(IAT1,IBOC,IBOT,NBOCRY,RINGAT,NRING,LDEBUG,
     +                  IBTYPE,MAXRNG)
C--
C-- Function: Find smallest ring starting from IAT, with bond type check.
C-- Version:  24.2.95  8.12.94   13.10.94       Sam Motherwell
C-- Notes:
C-- 1. Atom numbers of the ring are entered in RINGAT, count NRING.
C-- 2. MAXRNG  The routine will find rings up to maximum MAXRNG (input)
C-- 3. IBTYPE > 0 on input then restrict search to rings with
C--    given bondtype  e.g.  1,   5,    100  means bond type 0
C--
C-- Arguments:
C--  IAT1      start atom number for tree
C--  IBOC(,2) bond list
C--  IBOT     bond type
C--  NBOCRY   number of bonds in list
C--  RINGAT() output atom number for ring if found
C--  NRING    output number of atoms found in RINGAT
C--  IBTYPE control option. If (1) > 0 then restrict ring to this bond types
C--           in this array.
C--  MAXRNG   control option. restrict search to this max. ring size.
C      IMPLICIT NONE
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      INTEGER IAT1,IBOC,IBOT,NBOCRY,
     +        RINGAT(30),NRING,
     +        LDEBUG,IBTYPE(*),MAXRNG
C-- local
C-- IPT   pooint to connection in use for ringat(n)
C-- IFROM atom number from which we came to current ringat
      INTEGER IPT(30),IFROM(30),LLIG(30),LMIG(30)
      INTEGER L,N,NCX,IBACK,ITRY,IAT,JAT,NBTEST,CAT,IPIB
C--------------------------------------------------------------------
C--
C-- search through the table for ring starting from IAT - a ring is detected
C-- when a growth point atom = the start atom Iat.
C-- Max size of the ring is limited by the value MAXRNG
C-- RINGAT is set to the trial atoms for the ring
C-- IPT    points to the connection in use for current RINGAT
C-- IFROM  points to atom from which we reached current RINGAT
C-- N      is current number of atoms in RINGAT

      IF(LDEBUG.EQ.1) WRITE(STDOUTTERM,*)
     + 'samriq entered iat1=', IAT1
      NBTEST=IBTYPE(1)
      RINGAT(1)=IAT1
      IFROM(1)=0
      IPT(1)=0
      N=1
      CAT=0
C-- ignore pi-bonds
      IPIB=-1
C--
      DO 500 ITRY=1,999999
        IAT=RINGAT(N)
        IF(IAT.NE.CAT) THEN
          CALL SAMCON(IAT,IBOC,IBOT,NBOCRY,NCX,LLIG,LMIG,IPIB)
C-- record atom for which we have connections in LLIG array
          CAT=IAT
        ENDIF
        IPT(N)=IPT(N)+1
C**      WRITE(6,*) 'N=',N, 'IAT=', IAT, 'NC=',NC,' IPT=',IPT(n),
C**     + ' lig=', (LIG(IAT,L),L=1,NC)
        IF (IPT(N).GT.NCX) THEN
          IBACK=1
        ELSE
          JAT=LLIG(IPT(N))
          IF (JAT.EQ.IFROM(N)) GOTO 500
C-- reject if bond type not as required
          IF (NBTEST.GT.0) THEN
            DO 410 L=2,NBTEST+1
              IF(LMIG(IPT(N)).EQ.IBTYPE(L)) GOTO 420
  410       CONTINUE
C-- bond type does not match
            GOTO 500
  420       CONTINUE
          ENDIF
C-- reject if already in the ring list - this is a secondary ring closure.
          DO 450 L=2,N
            IF (JAT.EQ.RINGAT(L)) GOTO 500
 450      CONTINUE
C-- growth point JAT is rejected if a terminal atom
          CALL SAMCON(JAT,IBOC,IBOT,NBOCRY,NCX,LLIG,LMIG,IPIB)
C-- record atom for which we have connections stored
          CAT=JAT
          IF (NCX.LE.1) GOTO 500
C-- accept this as possible ring atom
          N=N+1
          RINGAT(N)=JAT
          IFROM(N)=IAT
          IPT(N)=0
          IBACK=0
C**       WRITE(6,*)'try n=',N,' iat',RINGAT(N),' Ifrom', IFROM(N)
C-- test from ring closure if growth atom Jat = start atom Iat1
          IF (JAT.EQ.IAT1) GOTO 501
        ENDIF
C-- if max ring size  is exceeded then backtrack
        IF (N.GT.MAXRNG+1) IBACK=1
C-- backtrack on trial atom N , so we can try next connect to Iat
C-- if N = 0 then stop process, no ring found
        IF (IBACK.EQ.1) THEN
          IAT=IFROM(N)
          IF (IAT.LE.0) GOTO 501
          N=N-1
C**         IPT(N)=0
        ENDIF
C--
C-- loop on trials
C--
 500  CONTINUE
 501  CONTINUE
C--
C--
      NRING=N-1
C**      WRITE(6,*) 'samriq start iat1=', Iat1,' Nring=',NRING
C**      WRITE(6,*) 'ringat=', (RINGAT(N),N=1,NRING)
      RETURN
      END

CODE FOR SAMTOR
      SUBROUTINE SAMTOR(XI,XJ,XK,XL,OMEGA)
C-- Function: Calculate torsion angle for a set of 4 atom coords.
C-- Version:  10.11.94  1.2.94        Sam Motherwell (based on TORANG)
C-- Notes:
C-- 1. The angle returned OMEGA is in degrees.
C--          I         L
C--           \       /
C--            J --- K
C--    When viewed in direction j > k, the angle omega is the rotation
C--    required to bring the projected line i-j to overlie k-l.
C--    Clockwise rotation gives +ve omega.
C--
C-- 2. If i-j-k or j-k-l  are colinear groups an indeterminate situation
C--    occurs.  A value of 0.0 is returned for Omega.
C--
C-- Arguments:
C-- XI,XJ,XK,XL   input orthog. coordinates for atoms i,j,k,l
C-- OMEGA         output torsion angle, in degrees
C      IMPLICIT NONE
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      REAL XI(3),XJ(3),XK(3),XL(3),OMEGA
      REAL VIJ(3),VJK(3),VKL(3),R(3),S(3),T(3),COSW,TP
      INTEGER N
      REAL SAMARC
C----------------------------------------------------
      DO 100 N=1,3
        VIJ(N)=XJ(N)-XI(N)
        VJK(N)=XK(N)-XJ(N)
        VKL(N)=XL(N)-XK(N)
 100  CONTINUE
      CALL VPPROD(VIJ,VJK,R)
      CALL VPPROD(VJK,VKL,S)
      CALL VPPROD(R,S,T)
      COSW=R(1)*S(1)+R(2)*S(2)+R(3)*S(3)
      TP=VJK(1)*T(1)+VJK(2)*T(2)+VJK(3)*T(3)
      IF (COSW.GT.1.00000) COSW=1.0
      IF (COSW.LT.-1.000000) COSW=-1.0
      OMEGA=SAMARC(COSW)
      IF (TP.LT.0.0) OMEGA=-OMEGA
      RETURN
      END



CODE FOR SAMVEC
      SUBROUTINE SAMVEC(X1,X2,V,D12)
C-- Function:   Get unit vector between points X1 and X2
C-- Version:    9.11.94          Sam Motherwell  8.12.93
C-- Arguments:
C-- X1      coords for point X1
C-- X2      coords for point X2
C-- V       output unit vector (in sense   X1  -->  X2)
C-- D12     output distance X1 - X2
C      IMPLICIT NONE
      INTEGER MAXLAB,LSFILE,TEKFILE,STDINTERM
      PARAMETER(LSFILE=7,TEKFILE=6,STDINTERM=5,MAXLAB=10)

      INTEGER         STDOUTTERM
      COMMON /PLUTRM/ STDOUTTERM

      REAL X1(3),X2(3),V(3)
      REAL D12
C------------------------------------
      V(1)=X2(1)-X1(1)
      V(2)=X2(2)-X1(2)
      V(3)=X2(3)-X1(3)
      D12=SQRT(V(1)*V(1)+V(2)*V(2)+V(3)*V(3))
      IF (D12.LE.0) THEN
        V(1)=1.
        V(2)=0.
        V(3)=0.
      ELSE
        V(1)=V(1)/D12
        V(2)=V(2)/D12
        V(3)=V(3)/D12
      ENDIF
      RETURN
      END

CODE FOR VPPROD
      SUBROUTINE VPPROD(A,B,C)
C Calculate C, the vector product of A & B normalised to unit length
C      IMPLICIT NONE
C     Passed arguments:
      REAL A(3),B(3),C(3)
      INTEGER I
      REAL D,DSQ
C
      C(1)=A(2)*B(3)-A(3)*B(2)
      C(2)=A(3)*B(1)-A(1)*B(3)
      C(3)=A(1)*B(2)-A(2)*B(1)
      DO 5 I=1,3
       IF(ABS(C(I)).LT.1.E-15)C(I)=0.0
    5 CONTINUE
      DSQ=C(1)*C(1)+C(2)*C(2)+C(3)*C(3)
      IF(DSQ.LT.0.00001)GOTO 10
      D=SQRT(DSQ)
      C(1)=C(1)/D
      C(2)=C(2)/D
      C(3)=C(3)/D
   10 RETURN
      END

