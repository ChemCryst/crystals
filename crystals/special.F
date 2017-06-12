C $Log: not supported by cvs2svn $
C Revision 1.13  2011/03/21 13:57:22  rich
C Update files to work with gfortran compiler.
C
C Revision 1.12  2011/02/10 09:44:46  djw
C Add an explantion to FLORIG while I remember how it works
C
C Revision 1.11  2011/02/03 10:59:15  djw
C Correct a comment
C
C Revision 1.10  2008/04/29 15:33:07  djw
C Reduce tolerance for 'snapping' coodrinates from ZERO to ZEROSQ
C
C Revision 1.9  2005/05/20 13:49:01  djw
C Output special position into to GUI in 'TEST' mode
C
C Revision 1.8  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:06  rich
C New CRYSTALS repository
C
C Revision 1.7  2003/01/15 15:26:39  rich
C Removal of NCAWU calls throught the standard SFLS refinement instruction. If
C anywhere will benefit from less IO, it's here.
C
C Revision 1.6  2002/11/12 15:12:51  rich
C Fixed bug in special position code. U[iso] value was corrupted if atom was moved
C by KSPECB because it thought it was a U[ij] value.
C
C Revision 1.5  2002/02/13 15:32:20  Administrator
C Reduce calls to SPECIAL in multicycle SFLS, enable shift reversal monitoring, and fix Lachlans shift bounding
C
C Revision 1.4  2001/02/26 10:36:09  richard
C Added changelog to top of file
C
C
CODE FOR XSPECM
      SUBROUTINE XSPECM
C
C----- THIS IS THE MASTER SUBROUTINE FOR HANDLING SPECIAL POSITIONS
C-
C      FOR THE MOMENT, THIS CODE INCORPORATES BOTH THE GOMM AND THE
C      BARI ALGORITHMS.
C            ONE WILL BE REMOVED ONCE THEY ARE FOUND TO BE CONSISTENT
C - DONE
C
C----- THE CALL HAS THE THREE PARAMETERS
C      ACTION  CONTROLS THE OPERATION
C      UPDATE  CONTROLS UPDATING IF LIST 5
C      TOLERANCE CONTROLS THE COINCIEDNCE NEEDED FOR IDENTITY
C
C      LIST 23 IS LOADED IF NECESSARY TO SEE WHAT SPECIAL CONDITIONS
C      SET THERE.
C
      CHARACTER *80 CLINE
      CHARACTER CEND*3
C
      INCLUDE 'ISTORE.INC'
      DIMENSION IPROC(3)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (IPROC(1), IACTN)
      EQUIVALENCE (IPROC(2), IUPDAT)
      EQUIVALENCE (IPROC(3), TOLER)
C
        DATA  CEND /'END'/
C
C----- FORMAT FOR INTERNAL READS
885   FORMAT(A1,A)
C----- READ ANY REMAINING  CARDS TO FIND ACTION
      IF ( KRDDPV( IPROC, 3) .LT. 0) GOTO  9000
C----- CHECK IF NO THING TO DO
      IF ((IACTN .EQ. -1).AND. (IUPDAT .EQ. -1)) GOTO 9999
C----- CHECK IF LIST 23 IS TO BE CHECKED
      IF ((IACTN .EQ. 4) .OR. (IUPDAT .EQ. 2)) THEN
        CALL XFAL23
      IF (IACTN .EQ. 4) THEN
        IACTN = ISTORE(L23SP)
        TOLER = STORE(L23SP+5)
      ENDIF
        IF (IUPDAT .EQ. 2) IUPDAT = ISTORE(L23SP+1)
      END IF
      IF (IUPDAT .GE. 0) IACTN=MAX0(0,IACTN)
      WRITE ( CMON,886) TOLER
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
886   FORMAT(5X,' Checking SPECIAL positions subject to tolerance of ',
     1 G10.5, ' Angstrom')
C
      IF (IACTN .EQ. 3) THEN
cdjw0202
      goto 9999
C----- WE MUST TRY FOR CONSTRAINTS
C----- SEND 'LIST22' TO SYSTEM REQUEST QUEUE - THIS WILL ACTION CONSTRAI
          WRITE (CLINE,885) IH, 'LIST 22 '
C-----    WRITE A LIST 22 HEADER
          CALL XSSRQ (IADSRQ, NSRQ)
          CALL XISRC (CLINE)
          CALL XISRC( CEND )
          WRITE ( CMON,1000)
CNOV98          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') 
     1    CMON(1 )(:nctrim(cmon(1)))
1000      FORMAT(5X,' Refinement directives (LIST 12) ',
     1 'processed to activate constraints')
          CALL XRSRQ (IADSRQ, NSRQ)
      ELSE
C----- EITHER SOME RESTRAINTS, OR JUST TESTING
         CALL XPRC17 (IACTN, IUPDAT, TOLER, +1)
      ENDIF
      GOTO 9999
C
9000  CONTINUE
C-----  ERROR CONDITIONS
      CALL XOPMSG (IOPCRY, IOPCMI, 17)
C
9999  CONTINUE
      RETURN
      END
C
C
CODE FOR XPRC17
        SUBROUTINE XPRC17 (IACTN, IUPDAT, ABTOL, IOUT)
C
C----- DETERMINATION OF POLAR DIRECTIONS AND RELATIONSHIPS BETWEEN
C      PARAMETERS OF ATOMS ON SPECIAL POSITIONS, AND CREATE LIST 17
C
C      BASED ON ALGORITHMS DUE TO MARTIN GOMM, WITH HIS PERMISSION.
C
C      IACTN      ACTION TO BE TAKEN BY ROUTINE
C                 0      INFORMATION ONLY
C                 1      ONLY ORIGIN RESTRAINTS
C                 2      GENERAL RESTRAINTS
C
C      IUPDAT     UPDATE OF LIST 5 ACTION
C                -1      DO NOTHING
C                 0      UPDATE OCCUPANCY
C                 1      UPDATE ALL PARAMETERS
C
C      IOUT       -1 NO MESSAGES
C                  1 MESSAGES
C
C----- X     ACTUAL COORDS,       X Y Z U11 U22 U33 U23 U13 U12 OCC
C      XO    UPDATED COORDS
C      MGOM  GOMMS MULTIPLICITY
C      KEY    INDEX (1-9) OF PARAMETER, OR RELATED PARAMETER
C      K1    SIGN
C      K2    MULTIPLIER
C      K3    REFINEMENT CODE FOR EACH PARAMETER
C      K3  = K1* (FACT(K2+1) + K3)
C      COEF  K1*K2
C
C      XG    GIANLUCA COORDS    X Y Z OCC U11 U22 U33 U12 U13 U23 C-OCC
C      XN    MODIFIED COORDS
C      KEYG  GIANLUCA KEYS - NOTE NO KEY FOR OCC
C-----
C
C
      CHARACTER *5 COORD(10)
      CHARACTER *3 PRE(3)
      CHARACTER *1 PLM(3)
      CHARACTER *80 CLINE
      CHARACTER CEND*3
C
      INCLUDE 'ISTORE.INC'
C
C
      DIMENSION X(10), XO(10), KEY(9), COEF(9)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XSPECC.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA IVERSN /121/
C
C
C
        DATA COORD /'*    ', 'x    ', 'y    ', 'z    ',
     1  'U[11]', 'U[22]', 'U[33]', 'U[23]', 'U[13]', 'U[12]'/
        DATA PRE / '   ', '1/2', ' 2 ' /
        DATA PLM / '-', ' ', ' '/
        DATA CEND /'END'/
C
C----- SET THE TIMER AND LOAD THE LISTS
      IF (KHUNTR (1,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL01
      IF (KHUNTR (2,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL02
      IF ((KHUNTR (5,0, IADDL,IADDR,IADDD, -1) .NE. 0) .AND.
     1  (KHUNTR (10,0, IADDL,IADDR,IADDD, -1) .NE. 0))CALL XFAL05
      IF (IERFLG .LT. 0) THEN
            WRITE ( CMON, '(A)' ) ' LIST 1, 2 or 5 not available '
            CALL XPRVDU(NCVDU, 1,0)
            IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') 
     1      CMON(1 )(:nctrim(cmon(1)))
            GOTO 9000
      ENDIF
      NRESTR = 0
      NUPDAT = 0
C
C
      IF (IACTN .GE. 0) THEN
        WRITE ( CMON,100)
c        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') 
     1  CMON(1 )(:nctrim(cmon(1)))
100     FORMAT(10X,' Notification of SPECIAL conditions ')
      ENDIF
      IF (IACTN .GE. 1) THEN
        WRITE ( CMON,110)
c        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') 
     1  CMON(1)(:nctrim(cmon(1)))
110     FORMAT(10X,' Fixing of floating origins')
      ENDIF
      IF (IACTN .GE. 2) THEN
        WRITE ( CMON,120)
c        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A/)') trim(CMON(1))
120     FORMAT(10X,' Restraining atomic parameters')
      ENDIF
C
C----- FORCE INITIALISATION OF THE SPECIAL POSITION VARIABLES
      IFORCE = -1
      IF (KSPINI (IFORCE, ABTOL ) .LE. 0) THEN
         WRITE ( CMON, '(A)') ' Error initialising special positions'
         CALL XPRVDU(NCVDU, 1,0)
         IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)')trim(CMON(1))
         GOTO 9000
      ENDIF
C
C----- FORMAT FOR INTERNAL READS
885   FORMAT(A1,A)
886   FORMAT(A)
      IF (IACTN .GE. 1) THEN
C-----  WRITE A LIST 17 HEADER
      CALL XL17H (IADSRQ, NSRQ)
      ENDIF
C
C----- CHECK FOR FLOATING ORIGIN
      CALL XFLORG ( N2, IACTN, NRESTR)
C
C
C
C----- FIND SPECIAL POSITIONS AND MULTIPLICITY
C----- BEGIN TO LOOP OVER THE ATOMS
        NUPDAT = 0
        M5 = L5
        DO 550 I5 = 1, N5
C
C----- GET SPECIAL POSITION INFORMATION
      IF ( KSPGET(X, XO, KEY, COEF, MGM, M5, IUPDAT, NUPDAT) .GT. 0 )
     1  GOTO 500
      MPOS = NGMULT / MGM
C
      IF (IOUT .GE. 1) THEN
C
          WRITE ( CMON,522) STORE(M5), NINT(STORE(M5+1)),
     2                        MPOS, NGMULT, 1./FLOAT(MGM)
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
522       FORMAT(1X,' Atom ', A4, I4, ',  Multiplicity =', I3,
     2    ',  Number of positions =', I3, ' Occ = ', F6.4)
          WRITE ( CMON,523) ( PLM(K1(IK)+2), PRE(K2(IK)+1),
     2                          COORD(KEY(IK)+1) ,IK =1,9    )
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
523       FORMAT (1X, 3(A1,A3,A2,1X), 6(A1,A3,A5,1X) )
      ENDIF
C
C
      IF (IACTN .EQ. 2) THEN
C------  WRITE OUT RESTRAINTS
      DO 540 K = 1, 9
        KK = KEY(K)
        IF (KK .EQ. K) THEN
C------  FREE REFINEMENT - DO NOTHING
            CONTINUE
        ELSE IF (KK .EQ. 0) THEN
C------  COORDINATE FIXED
                  NRESTR = NRESTR + 1
                  CALL XRESTF (K, XO(K), M5)
        ELSE
C------  SET UP RESTRAINT BETWEEN COORDS
            DO 530 J = 1,K-1
                  IF (KEY(J) .EQ. KK) THEN
                        CALL XRESTL ( K, COEF(K), XO(K),
     1                  J, COEF(J), XO(J), M5)
                        NRESTR = NRESTR + 1
                  ENDIF
530         CONTINUE
        ENDIF
540   CONTINUE
      ENDIF
C
500   CONTINUE
      M5 = M5 + MD5
550   CONTINUE
C
C----- BEGIN TO TIDY UP
        IF (IACTN .GE. 1) THEN
            CALL XISRC( CEND )
            IF (NRESTR .GT. 0) THEN
             WRITE ( CMON,560) NRESTR
             CALL XPRVDU(NCVDU, 1,0)
             IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') 
     1       CMON(1)(:nctrim(cmon(1)))
560    FORMAT (6X, I6, ' Symmetry restraints written to LIST 17')
C
C----- UPDATE LIST 23 TO INDICATE THAT RESTRAINTS HAVE BEEN GENERATED
C
             WRITE(CLINE,885) IH, 'GENERALEDIT 23'
             CALL XISRC( CLINE)
             WRITE(CLINE,886)  'LOCATE RECORDTYPE = 103 '
             CALL XISRC( CLINE)
             WRITE(CLINE,886)  'CHANGE OFFSET=2 MODE=INTEGER INTEGER=0 '
             CALL XISRC( CLINE)
             WRITE(CLINE,886)  'WRITE '
             CALL XISRC( CLINE)
             CALL XISRC( CEND )
             WRITE ( CMON,570)
             CALL XPRVDU(NCVDU, 1,0)
             IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') 
     1       CMON(1)(:nctrim(cmon(1)))
570          FORMAT(10X,' LIST 23 updated to include restraints')
            ELSE
C----- NO RESTRAINTS, SO WE CAN REWIND THE SRQ
            REWIND NUSRQ
            ENDIF
            IF (NSRQ .NE. 0) CALL XRSRQ (IADSRQ, NSRQ)
        ENDIF
        IF (NUPDAT .GT. 0) THEN
          WRITE ( CMON,580) NUPDAT
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') 
     1    CMON(1)(:nctrim(cmon(1)))
580   FORMAT(6X,I6, ' Atoms modified.',6X,'New LIST 5 written to DISK')
C-----    WRITE UPDATED LIST 5 TO DISK
          CALL XSTR05 (5, 0, -1)
        ENDIF
        GOTO 9900
C
9000    CONTINUE
C-----  ERROR CONDITIONS
        CALL XOPMSG (IOPCRY, IOPCMI, 17)
C
9900    CONTINUE
C----- FINAL MESSAGE AND CLEAN UP
        CALL XOPMSG (IOPLSC, IOPLSE, 17)
        CALL XOPMSG (IOPCPR, IOPEND, IVERSN)
        RETURN
        END
C
CODE FOR KSPINI
      FUNCTION KSPINI (IFORCE, ABTOL)
C
C----- INITIALISE THE SPECIAL POSITION VARIABLES FOR USE WITH GOMMS CODE
C      RETURN VALUES
C                        +1 SUCCESS
C                        -1 FAILURE
C
C      IFORCE -1      FORCE INITIALISATION
C             +1      ONLY IF NECESSARY
C      ABTOL  THE ABSOLUTE TOLERANCE, IN ANGSTROM, FOR IDENTITY
C
      INCLUDE 'ISTORE.INC'
      DIMENSION IBRVC(7), NBRV1(7), NBRV2(7)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSPECC.INC'
C
      INCLUDE 'QSTORE.INC'
C----- ON COMPILERS WITHOUT GLOBAL 'SAVING' JFORCE MUST BE SAVED
       DATA JFORCE      /-1/
C
C       TRANSLATION FROM CRYSTALS TO GOMM CENTRING
        DATA IBRVC / 1, 6, 7, 5, 2, 3, 4/
C        INDEX IN BRAVAIS CENTRINGS FOR 'P, A, B, C, F, I, R'
        DATA NBRV1 / 1, 1, 2, 3, 1, 4, 5/
        DATA NBRV2 / 1, 2, 3, 4, 4, 5, 7/
C
      KSPINI = 0
      IF ((IFORCE .EQ. 1) .AND. (JFORCE .EQ. 1)) RETURN
      KSPINI = -1
C      CALL XLC
      IF (ISSPRT .EQ. 0)
     1 WRITE (NCWU,'('' Initialising Special positions'')')
      IF (KHUNTR (1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR (2,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL02
C----- THERE IS NO NEED FOR LIST 5 AT THIS STAGE
      IF (KHUNTR (5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF (IERFLG .LE. 0) RETURN
C
C----- CONVERT TOLERANCES TO FRACTIONAL
      TOLER(1) = ABTOL / STORE(L1P1)
      TOLER(2) = ABTOL / STORE(L1P1 + 1)
      TOLER(3) = ABTOL / STORE(L1P1 + 2)
C----- REFORMAT THE SYMMETRY INFORMATION
      NGS = IC - 1
      M2 = L2
      DO 800, K=1,N2
        DO 810 I = 1,3
          DO 820 J=1,3
C---        ROTATIONAL SYMMETRY ELEMENTS
            ISELM(K,I,J) = NINT(STORE(M2))
            M2 = M2 + 1
820       CONTINUE
810     CONTINUE
        DO 830 I =  1,3
C--       TRANSLATIONAL ELEMENTS
          TRELM(K,I) = STORE(M2)
          M2 = M2 + 1
830     CONTINUE
800   CONTINUE
C----- REFORMAT CENTRINGS
      IGL = IBRVC(IL)
C----- NO OF OPERATORS
      IF (NGS .EQ. 0) THEN
          NGMULT = 2 * N2
      ELSE
          NGMULT = N2
      ENDIF
C
C----- NO OF CENTRINGS
      IF (IGL .EQ. 1) THEN
          NGCENT = 1
      ELSE IF (IGL .EQ. 5 ) THEN
          NGCENT = 4
      ELSE IF (IGL .EQ.7) THEN
          NGCENT = 3
      ELSE
          NGCENT = 2
      ENDIF
      NGMULT = NGMULT * NGCENT
C
C     NBR1, NBR2   KEYS FOR BRAVAIS CENTRINGS
      NBR1 = NBRV1(IGL)
      NBR2 = NBRV2(IGL)
      JFORCE = +1
      KSPINI = +1
      RETURN
      END
C
C
CODE FOR XFLORG
      SUBROUTINE XFLORG (N2, IACTN, NRESTR)
C
C----- CHECK FOR FLOATING ORIGIN
c for each row, sum the column entry for all symmetry operator matrices
c If the total is equal to the number of operators, the origin
c is floating in that direction.
C
      CHARACTER *2 AXIS(3)
      CHARACTER *80 CLINE
cdjwapr11      DIMENSION IHM(3)
c----- replace with IFLOR in XSPECC 
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSPECC.INC'
      INCLUDE 'XIOBUF.INC'
C
      DATA AXIS /' x', ' y', ' z'/
      NRESTR = 0
        IF (NGS .EQ. 0) THEN
C        CENTRIC, SO NO FLOATING ORIGIN
            DO 5, I = 1,3
                IFLOR(I) = 0
5           CONTINUE
            GOTO 20
        ENDIF
C
        DO 10 K = 1,3
            IFLOR(K) = 0
            DO 9 I = 1, N2
                DO 8 J = 1,3
                    IFLOR(K) = IFLOR(K) + ISELM(I,J,K)
8               CONTINUE
9           CONTINUE
            IF (IFLOR(K) .NE. N2) THEN
C               NON - FLOATING DIRECTION
                IFLOR(K) = 0
            ELSE
C               FLOATING DIRECTION
                IFLOR(K) = 1
C
                WRITE(CMON,13) AXIS(K)
c                CALL XPRVDU(NCVDU, 1,0)
                IF (ISSPRT .EQ. 0) WRITE(NCWU,13) AXIS(K)
13      FORMAT(' Floating origin in ', A2, ' direction')
                WRITE(CLINE,14) AXIS(K)
14              FORMAT('ORIGIN ', A)
                IF (IACTN .GE. 1) THEN
                  CALL XISRC( CLINE)
                ENDIF
                NRESTR = NRESTR + 1
            ENDIF
10      CONTINUE
20    CONTINUE
      RETURN
      END
C
CODE FOR KSPECA
      FUNCTION KSPECA (X, XO, KEY, COEF, MGM)
C
C----- RETURN VALUES
C                        +1 NOT SPECIAL POSITION
C                        -1     SPECIAL POSITION
C
C----- X    ORIGINAL COORDINATE
C      XO   CORRECTED COORDINATE
C      KEY  INDEX FOR PARAMETER, OR RELATED PARAMETER
C      COEF MULTIPLIER FOR PARAMETER WRTO RELATED PARAMETERS.
C      MGM  SITE MULTIPLICITY
C
      DIMENSION X(10), XO(10), KEY(9),  COEF(9)
      DIMENSION ISTMP(3,3), BRVCNT(6,3)
      DIMENSION FACT(3), PARITY(3), XY(3), XT(9)
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XSPECC.INC'
C
        DATA FACT   /  1.0, 0.5, 2.0 /
        DATA PARITY / -1.0, 1.0, 1.0/
C------  BRAVAIS CENTRINGS
        DATA BRVCNT / 0.0, 3*0.5, .3333333, .6666667, .5, 0.0, 2*0.5,
     1  0.6666667, 0.3333333, 2*0.5, 0.0, 0.5, 0.6666667, 0.3333333/
C
      MGM = 0
C        SET INITAL VALUES FOR KEYS
      DO 116 K = 1, 9
        K4(K)  = K
        K3(K) = K
116   CONTINUE
C
      DO 117 I = 1,3
C----- ZERO TOTALS FOR AVERAGE
        XT(I) = 0.0
117   CONTINUE
C
C        START LOOPING OVER ALL BRAVAIS LATTICE POSITIONS
      DO 500 II = NBR1, NBR2
        NYY = -1
490     CONTINUE
        NYY = -NYY
        DO 400 I = 1, N2
          DO 403 J = 1,3
            DO 401 K = 1,3
C        GET (INVERTED) ROTATION OPERATOR
              ISTMP(J,K) = ISELM(I, J, K) * NYY
401         CONTINUE
403       CONTINUE
C
C----- GET THE POSITIONS
         CALL XMOVE(X(1), XO(1), 3)
         DO 402 J = 1, 3
C          GET (INVERTED) TRANSLATION OPERATOR
           ZW = TRELM(I,J) * NYY
C          BRING IN BRAVAIS CENTRINGS
           IF (II .NE. NBR1) ZW = ZW + BRVCNT(II-1, J)
C----      GENERATE NEW ATOMIC POSITION
           XX = ISTMP(J,1)*XO(1) + ISTMP(J,2)*XO(2) +
     1     ISTMP(J,3)*XO(3) + ZW
C-----     BRING THE GENERATED COORD CLOSE TO ORIGINAL COORD
           DELX = XO(J) - XX
           XY(J) = XX + FLOAT(NINT(DELX))
C----      CHECK FOR EQUIVALENCE
           IF (ABS(XO(J) - XY(J)) .GT. TOLER(J)) GOTO 400
402      CONTINUE
C
C        ALL COORDINATES EQUIVALENT -  SPECIAL POSITION
C-----   ADD INTO TOTALS FOR AVERAGE COORD
         DO 404 J=1,3
           XT(J) = XT(J) + XY(J)
404      CONTINUE
C
C        INCREMENT MULTIPLICITY
         MGM = MGM + 1
         MSP = IABS(ISTMP(1,1)) + IABS(ISTMP(2,2)) +
     1   IABS(ISTMP(3,3))
         IF (MSP .EQ. 0) GOTO 410
         IF (ISTMP(3,3) .EQ. -1) K3(3) = 0
         IF (MSP .EQ. 2) GOTO 420
         IF (ISTMP(2,2) .EQ. -1) K3(2) = 0
         IF (ISTMP(1,1) .EQ .-1) K3(1) = 0
         IF (MSP .EQ. 3) GOTO 430
         IF (ISTMP(1,2) .NE. 0) K3(5) = 4
         IF (ISTMP(1,3) .NE. 0) K3(6) = 4
         IF (ISTMP(1,1) .NE. 0) K3(6) = 5
C
430      CONTINUE
         IF (ISTMP(1,2) + ISTMP(1,3) + ISTMP(2,3) + ISTMP(2,1)
     1   + ISTMP(3,1) + ISTMP(3,2) .NE. 0)  GOTO 440
         IF (ISTMP(1,1)*ISTMP(2,2) .LE. 0) K3(9) = 0
         IF (ISTMP(1,1)*ISTMP(3,3) .LE. 0) K3(8) = 0
         IF (ISTMP(2,2)*ISTMP(3,3) .LE. 0) K3(7) = 0
         IF (MSP .EQ. 3) GOTO 480
         IF (ISTMP(1,1) .EQ. 0) K3(1) = 0
         IF (ISTMP(2,2) .EQ. 0) K3(2) = 0
         IF (ISTMP(3,3) .EQ. 0) K3(3) = 0
         GOTO 480
C
440      CONTINUE
         IF (MSP .EQ. 3) GOTO 450
         IF (ISTMP(1,2) .NE. 0) K3(2) = ISTMP(1,2)
         IF (ISTMP(1,2) .NE. 0) K3(8) = 7*ISTMP(1,2)*ISTMP(3,3)
         IF (ISTMP(1,3) .NE. 0) K3(3) = ISTMP(1,3)
         IF (ISTMP(1,3) .NE. 0) K3(9) = 7*ISTMP(1,3)*ISTMP(2,2)
         IF (ISTMP(2,3) .NE. 0) K3(3) = ISTMP(2,3) + ISTMP(2,3)
         IF (ISTMP(2,3) .NE. 0) K3(9) = 8*ISTMP(2,3)*ISTMP(1,1)
         GOTO 480
C
450      CONTINUE
         K3(9) = 14
         IF (ISTMP(1,2) .NE. 0) K3(9) = 15
         IF (ISTMP(2,1) .EQ. 1) THEN
           K3(2) = 11
           IF (ISTMP(1,1) .NE. 0) K3(1) = 1
         END IF
         IF (ISTMP(1,2) .EQ. 1) THEN
           K3(2) = 21
           IF (ISTMP(1,1) .NE. 0) K3(1) = 1
         END IF
         IF (ISTMP(1,2) .EQ. -ISTMP(3,3)) K3(7) = 0
         IF (ISTMP(2,1) .EQ. -ISTMP(3,3)) K3(8) = 0
         IF (ISTMP(1,2) .EQ. ISTMP(3,3)) K3(8) = 17
         IF (ISTMP(2,1) .EQ. ISTMP(3,3)) K3(8) = 27
         GOTO 480
C
420      CONTINUE
         K3(1) = 0
         K3(2) = 0
         K3(5) = 4
         K3(7) = 0
         K3(8) = 0
         K3(9) = 14
         GOTO 480
C
410      CONTINUE
         K3(5) = 4
         K3(6) = 4
         MDET = ISTMP(1,2) * ISTMP(2,3) * ISTMP(3,1) +
     1   ISTMP(1,3) * ISTMP(2,1) * ISTMP(3,2)
         MQ = (MDET + 1) / 2
         K3(1) = MQ
         K3(2) = (ISTMP(1,2) + ISTMP(2,1)) * MQ
         K3(3) = (ISTMP(1,3) + ISTMP(3,1)) * MQ
         K3(8) = MDET * (ISTMP(1,2) + ISTMP(2,1)) * 7
         K3(9) = MDET * (ISTMP(1,3) + ISTMP(3,1)) * 7
C
480      CONTINUE
C
C        LOOP MOVING KEYS TO PERMANENT SLOTS. DO TWO PASSES
         DO 481 J = 1,9
           M = K3(J)
           IF (M .EQ. J) GOTO 481
           IF (M .NE. 0) GOTO 482
485        CONTINUE
           K4(J) = 0
482        CONTINUE
           IF (K4(J) .EQ. 0) GOTO 481
           MQ = 0
483        CONTINUE
           IF (M .LT. 10) GOTO 484
           MQ = MQ + 10
           M = M - 10
           GOTO 483
484        CONTINUE
           NSIG = 1
           IF ( M .LT. 0)  NSIG = -1
           K = K4(M*NSIG)
           IF (K .EQ. 0) GOTO 485
           K4(J) = MQ + K * NSIG
481      CONTINUE
C
400      CONTINUE
C        DO SECOND LOOP  FOR CENTROSYMMETRIC GROUPS
         IF (NGS .EQ. 0 .AND. NYY .EQ. 1) GOTO 490
C
500     CONTINUE
C
C        DECOMPOSE KEY INTO SIGN, MULTIPLICATON FACTOR AND ID
      DO 530 K = 1,9
        J = K4(K)
        K1(K) = ISIGN(1, J)
        J = IABS(J)
        K2(K) = (J / 10)
        KEY(K) = J - 10 * (J / 10)
        COEF(K) = PARITY(K1(K)+2) * FACT(K2(K)+1)
530   CONTINUE
C
      DO 535 K = 1,9
C----   COMPUTE AVERAGE COORDINATE
        IF (K .LE. 3) THEN
          XT(K) = XT(K)/FLOAT(MGM)
        ELSE
          XT(K) = X(K)
        ENDIF
535   CONTINUE
      DO 540 K = 1,9
        KK = KEY(K)
C---      TEST FOR FIXED COORDINATE - IDEALISE IF NECESSARY
          IF (KK .EQ. 0) THEN
            XO(K) = FLOAT ( NINT(XT(K)*24.0)) / 24.0
          ELSE
            IF ( K .LE. 3 ) THEN
C             POSITIONS
              J1 = 1
              J2 = 3
            ELSE
C             U'S
              J1 = 4
              J2 = 9
            ENDIF
            XX = 0.0
            NX = 0
            DO 510 J = J1,J2
              IF (KK .EQ. KEY(J)) THEN
C             WE HAVE A RELATED PARTAMETER - USE IN AVERAGE
                  XZ =  XT(J)*COEF(K) / COEF(J)
                  IF (J .LE. 3) THEN
                       DELX = XT(K) - XZ
                       DELX = FLOAT ( NINT(DELX*24.0)) / 24.0
                       XZ = XZ + DELX
                  ENDIF
                NX = NX + 1
                XX = XX + XZ
              END IF
510         CONTINUE
            XO(K) = XX / FLOAT(NX)
          ENDIF
520     CONTINUE
540   CONTINUE
C
      KSPECA = +1
      IF ( MGM .NE. 1) KSPECA = -1
C
      RETURN
      END
CODE FOR KSPGET
      FUNCTION  KSPGET (X, XO, KEY, COEF, MGM, M5, IUPDAT, NUPDAT)
C----- CHECK FOR A SPECIAL POSITION
C
C      RETURN VALUES      -1 = SPECIAL POSITION FOUND
C                         +1 = GENERAL POSITION
C
      DIMENSION X(10), XO(10), KEY(9), COEF(9)
      DIMENSION XN(11), KEYG(10), XG(11), NEWVET(48,3)
      DIMENSION KEYK(10)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSPECC.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
C
      NUPDAT = 0
      KSPGET = 1
C------ GOMMS METHOD
      CALL XMOVE (STORE(M5+4), X(1), 9)

CRIC02: Protect the Uiso value. KSPECA thinks it's an odd Uij.
      IF (STORE(M5+3) .EQ. 1.0) UISTMP = STORE(M5+7)

      IGSTAT = KSPECA (X, XO, KEY, COEF, MGM)

CRIC02: Protect the Uiso value. KSPECA thinks it's an odd Uij.
      IF (STORE(M5+3) .EQ. 1.0) XO(4) = UISTMP

C----- INSERT OCCUPATION NUMBER, AND SET UPDATED COUNTER
c      IF (IGSTAT .LE. 0 ) THEN
      MUPDAT = 0
      A  = 1./ FLOAT(MGM)
      IF (ABS( A - STORE(M5+13)) .GE. ZERO ) THEN
         MUPDAT = 1
          STORE(M5+13) = A
      ENDIF
C-C-C-JUMP OVER SPECIAL-CHECK FOR NON-ANISOTROPIC ATOMS
C-C-C-SHOULD WE LEAVE THE CHECK FOR ISOTROPICS ???
C-C-C-DISTINCTION BETWEEN ANISOTROPIC ATOMS AND OTHERS
      IF (STORE(M5+3) .EQ. 0.0) THEN
         KK=9
      ELSE
         KK=3
         DO 220, K=4,9
           KEY(K)=K
220      CONTINUE
      ENDIF
C------ RESET COUNTER IF UPDATING OF LIST 5 NOT REQUIRED
      IF (IUPDAT .LT. 0) MUPDAT = 0
      IF (IUPDAT .GE. 1) THEN
C          DO 545, K =1,9
C-C-C-FLEXIBILISATION OF SPECIAL-CHECK CORRESPONDING TO ATOM-TYPE
          DO 545, K =1,KK
            IF (ABS(XO(K) - STORE(M5+3+K)) .GE. ZEROSQ ) THEN
cdjw-apr-08
c              CALL XMOVE(XO(1), STORE(M5+4), 9)
              CALL XMOVE(XO(1), STORE(M5+4), kk)
              MUPDAT = MUPDAT + 1
              GOTO 546
            ENDIF
545       CONTINUE
546       CONTINUE
      ENDIF
      IF (MUPDAT .GT. 0 ) NUPDAT =NUPDAT + 1
      KSPGET = IGSTAT
      RETURN
      END

CODE FOR XL17H
      SUBROUTINE XL17H (IADSRQ, NSRQ)
C---- WRITE A LIST 17 HEADER
C
      CHARACTER *80 CLINE
      CHARACTER CHEAD1*2
      INCLUDE 'XCHARS.INC'
        DATA CHEAD1 /'NO'/
C-----  WRITE A LIST 17 HEADER
      WRITE (CLINE,885) IH, 'LIST 17 '
885   FORMAT(A1,A)
      CALL XSSRQ (IADSRQ, NSRQ)
      CALL XISRC (CLINE)
      CALL XISRC (CHEAD1)
      RETURN
      END
CODE FOR XRESTF
      SUBROUTINE XRESTF ( K, X1, M5)
C----- WRITE OUT A RESTRAINT FOR A FIXED PARAMETER
      CHARACTER *80 CLINE
      CHARACTER *5 COORD(10)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
        DATA COORD /'*    ', 'x    ', 'y    ', 'z    ',
     1  'U[11]', 'U[22]', 'U[33]', 'U[23]', 'U[13]', 'U[12]'/
C
      WRITE(CLINE,524) X1, STORE(M5), NINT(STORE(M5+1)),
     1 COORD(K+1)
524   FORMAT( 'RESTRAIN ', F7.4, ', .00001 = ',
     1 A4,'(',I4,',',A, ')')
      CALL XISRC( CLINE)
      RETURN
      END
CODE FOR XRESTL
      SUBROUTINE XRESTL (K, C1, X1, J, C2, X2, M5)
C----- WRITE OUT A RESTRAINT FOR LINKED PARAMETERS
      CHARACTER *80 CLINE
      CHARACTER *5 COORD(10)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
        DATA COORD /'*    ', 'x    ', 'y    ', 'z    ',
     1  'U[11]', 'U[22]', 'U[33]', 'U[23]', 'U[13]', 'U[12]'/
C
      COEFN = -C1/C2
      VALUE = X1 + X2*COEFN
      VALUE = FLOAT(NINT( VALUE*24. ))/24.
      WRITE(CLINE,525 ) VALUE,  STORE(M5), NINT(STORE(M5+1)),
     1 COORD(K+1), COEFN,  STORE(M5), NINT(STORE(M5+1)),
     2 COORD(J+1)
      CALL XISRC( CLINE)
525   FORMAT( 'RESTRAIN ', F7.4,', .00001 = ',A4,'(',I4,',', A, ')',
     1 SP, F5.1, S, ' * ', A4,'(',I4,',',A, ')' )
      RETURN
      END
C

