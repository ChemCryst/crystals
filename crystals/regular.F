c $Log: not supported by cvs2svn $
c Revision 1.24  2003/11/20 13:01:03  rich
c Initialise variable in search for pseudo-symmetry to nonsense
c value, rather than zero. Prevents incorrect diagnosis of pseudo-
c symmetry.
c
c Revision 1.23  2003/11/11 15:08:01  rich
c Added OUTPUT PUNCH=RESULTS option to #MATCH to output results in tab delimited
c format to the PUNCH file.
c
c Revision 1.22  2003/09/24 09:44:25  rich
c Added routine XMXUIJ to matrix.src to apply a transformation to
c a vector of Uijs. Added new vector to store Uijs for the "new"
c list of atoms in \REGULARISE, and apply rotation at appropriate
c point.
c
c Revision 1.21  2003/09/16 19:52:38  rich
c Fixed bug in #MATCH/RENAME. No idea how it worked before. Now fixed.
c
c Revision 1.20  2003/09/16 13:30:22  rich
c Remove unneeded array.
c
c Revision 1.19  2003/09/15 18:13:02  rich
c Oops. Don't meddle with the Uij's if this isn't an anisotropic atom.
c
c Revision 1.18  2003/09/15 17:57:35  rich
c
c When outputing #REGULARISE COMPARE diagrams for Cameron, convert
c the Uij's to the best plane coordinate system, the maths is like
c this: Unew = inv(M) R N U trans(N) trans(R) trans(inv(M)),
c where U is the original tensor, N is a diagonal matrix containing the
c reciprocal unit cell lengths, R is the matrix converting crystal
c fractions to best plane coordinate system, M is a diagonal matrix
c containing the reciprocal best plance cell lengths (ie. the unit matrix).
c
c Revision 1.17  2003/07/17 01:03:30  rich
c Character buffer was too short.
c
c Revision 1.16  2003/07/15 09:32:52  rich
c When doing #MATCH output atom lists to regular.dat for use by scripts (if
c they want).
c
c Revision 1.15  2003/04/04 09:05:51  rich
c Changes for #MATCH: (1) directive EQUALATOMS makes it treat all atoms
c as equal so that you can match structures onto Q peaks, or wrongly assigned
c peaks. (2) directive RENAME 100, makes the ONTO atoms take the type and
c serial+100 of the MAP atoms.
c
c Revision 1.14  2003/03/26 10:36:09  rich
c Prototype #MATCH code. Syntax: #MATCH/MAP atoms/ONTO atoms/END
c It does the match, refines it, prints stats and writes a cameron.ini
c and regular.l5i which can be viewed by choosing "Graphics"->"Special"->"existing input files".
c
c Revision 1.13  2003/01/10 15:39:33  rich
c Some enhancements to \REGULARISE:
c 1) When using the RENAME facility, the program can no longer match the same
c atom twice. Therefore you get unique serials even if the match is horrifically
c bad.
c
c 2) Added "CAMERON" directive: this does the mapping as RENAME, but doesn't
c rename the atoms, just outputs CAMERON input files showing the two molecules
c superimposed. Use as follows:
c   \REGULARISE
c   target C(10) until C(16)
c   ideal  C(60) until C(76)
c   cameron
c   map    C(51) until C(99)
c   onto   C(1) until C(49)
c   end
c This produces a cameron.ini, regular.l5i and regular.oby which may be viewed
c by choosing Graphics->Special->Cameron (use existing...) from the menu.
c Then type "obey regular.oby" in Cameron to colour the molecules nicely.
c The TARGET and IDEAL are used to obtain the mapping. The atoms in MAP and ONTO
c are just the ones you want to be included.
c Don't read the atoms back into CRYSTALS when closing CAMERON - they're in
c orthogonal coordinates.
c
c Revision 1.12  2002/11/06 12:02:49  rich
c Regularise replace was putting weird values into PART, REFINE, NEW and HYBRID as
c its new atoms array wasn't big enough.
c
c Revision 1.11  2001/10/10 16:05:11  Administrator
c Remove excessive output from screen
c
c Revision 1.10  2001/06/18 12:24:03  richard
c Missing comma.
c
c Revision 1.9  2001/06/08 15:08:21  ckpgroup
c reinstate updated re-naming code
c
C Revision 1.7  2001/04/30 11:50:31  ckpgroup
C fix-up omitted rflections when re-indexing matrix has non-integral results' read6.src
C
C Revision 1.6  2001/02/26 10:30:23  richard
C Added changelog to top of file
C
C
CODE FOR XREGUL
      SUBROUTINE XREGUL
C
C -- THESE ROUTINES IMPLEMENT THE FUNCTIONS OF THE CRYSTALS INSTRUCTION
C    'REGULARISE'
C
C -- THEY ALLOW A GROUP OF ATOMS IN THE LIST 5 STORED ON THE DISC TO BE
C    COMPARED WITH ANOTHER GROUP OF ATOMS. THE SECOND GROUP MAY ALSO BE
C    IN LIST 5. ALTERNATIVELY IT MAY BE SPECIFIED BY DIRECTIVES FOLLOW-
C    ING 'REGULARISE', WHICH EITHER EXPLICITLY GIVE THE CO-ORDINATES OF
C    THE ATOMS IN SOME CO-ORDINATE SYSTEM, OR SPECIFY A GROUP PRE-DEF-
C    INED BY THE PROGRAM.
C
C -- THE MAIN ROUTINE XREGUL BEHAVES AS FOLLOWS :-
C
C            INITIALISATION         READ INPUT ( LEXICAL SCANNER ), SET
C                                   INITIAL VALUES, LOAD LISTS ETC.
C
C            SETTING UP OF GROUPS   CONTROLLED BY DIRECTIVES.
C
C            CALCULATION            INITIATED BY BEGINNING OF NEXT
C                                   GROUP OR END OF DIRECTIVES.
C
C            COMPLETION             WRITE NEW LIST 5 ( IF REQUIRED ),
C                                   RELEASE STORAGE, ETC.
C
C -- REFERENCES TO CRYSTALS SYSTEM FEATURES :-
C
C            ERROR HANDLING         USES XERHND
C
C            SPACE IN STORE ETC.    CLAIMED USING XSTALL ETC.
C
C            COMMAND INPUT          USES LEXICAL SCANNER. THIS IS USED
C                                   TO ALLOW ATOM SPECIFICATIONS TO BE
C                                   PROCESSED READILY.
C
C -- VALUES SET IN THIS MODULE - INITIAL OR DEFAULT VALUES,OR CONSTANT
C    PARAMETERS PASSED TO SUBROUTINES
C
C            MDATMD                 SPACE FOR EACH ATOM IN THE INTERNAL
C                                   COPY OF LIST 5.
C            VALUE (VARIABLE)    : MD5
C
C            ATOM (NATOMP)        : DUMMY ATOM WITH NATOMP COORDINATES
C
C
C
C            MDOLD,MDNEW            SPACE REQUIRED FOR EACH SET OF OLD
C                                   AND NEW CO-ORDINATES. ( X,Y,Z, AND
C                                   A WEIGHT )
C                  VALUE ( FIXED ) : 4
C
C
C            IMETHD                 CALCULATION METHOD.A NUMBER BETWEEN
C                                   1 AND 3. DEFAULT VALUE SET IS 1.
C                                   UPPER LIMIT IS CHECKED BY ROUTINE
C                                   XRGSMD
C                  VALUE ( ONE OF ) : 1/2/3 ( SEE XRGCLC FOR MEANINGS )
C
C
C            ICMPDF         SETS COMPARE/REPLACE/KEEP FLAG FOR
C                           GROUP, UNLESS EXPLICIT DIRECTIVE
C                           GIVEN. THE VALUE OF ICMPDF IF DETERMINED BY
C                           PARAMETER TO 'REGULARISE' . THIS IS AT
C                           OFFSET 35 IN THE LEXICAL SCANNER COMMON
C                           BLOCK
C                  VALUE ( ONE OF ) : 1          2          3
C                                     (REPLACE)  (COMPARE)  (KEEP)
C                                    4           5          6
C                                    (AUGMENT)   (RENAME)   (CAMERON)
C
C
C            IFLCMP         THE FLAG WHICH DETERMINES WHETHER THE
C                           CURRENT GROUP IS THE SUBJECT OF A COMP-
C                           ARE/REPLACE/KEEP OPERATION. ITS DEFAULT
C                           VALUE IS 'ICMPDF'
C                  VALUE ( ONE OF ) : THOSE FOR ICMPDF
C                           THE VALUE 5 CAN ONLY BE SET BY A 'RENAME' 
C                           COMMAND
C                           THE VALUE 5 CAN ONLY BE SET BY A 'CAMERON' 
C                           COMMAND
C
C
C            NEWLIS         NEW LIST 5 TO BE CREATED. DEFAULT 'NO'
C                  VALUE ( ONE OF ) :  0              1
C                                     (NO NEW LIST)  (NEW LIST)
C
C
C            SIZE OF PHENYL GROUP
C                           DETERMINES THE SIZE OF HEXAGON PRODUCED
C                           BY THE 'PHENYL' DIRECTIVE. SET IN
C                                   CALL TO XRGPLG
C                  VALUE ( FIXED ) : 1.39
C
C
C            CALLS TO XRGRDS
C                           2 OF THESE. THE PARAMETER PASSED DETER-
C                           MINES WHETHER THE INPUT IS TREATED AS
C                           SPECIFYING 'OLD' OR 'NEW' ATOMS.
C                  VALUE ( ONE OF ) :  1       2
C                                     (OLD)   (NEW)
C
C
C            CALLS TO XRGPLG
C                           NUMEROUS. THE NUMBER OF ATOMS IN THE GROUP
C                           IS A PARAMETER.
C                  VALUE ( TYPE ) : INTEGER    ( THE RIGHT ONE ! )
C
C
C            CALLS TO XLXRDV
C                           NUMEROUS. THESE CONTAIN E.G. DEFAULT SCALES
C                           FOR PRE-DEFINED GROUPS.
C                  VALUE ( TYPE ) : REAL    ( IN GENERAL = 1.0 )
C
C
C
C
C -- THE FOLLOWING PARTS OF THIS PROGRAM COULD WELL BE IMPROVED.
C
C            COMMAND PROCESSING
C                           THIS WAS DONE WITH THE LEXICAL SCANNER
C                           TO ALLOW EASY PROCESSING OF ATOMIC SPEC-
C                           IFICATIONS IN THE STANDARD CRYSTALS FOR-
C                           MAT. HOWEVER IT WOULD BE USEFUL TO SET
C                           SCALE FACTORS ETC. IN THE COMMAND FILE.
C                           THE SPECIFICATION OF PRE-DEFINED GROUPS
C                           WOULD ALSO BE IMPROVED BY NOT USING THE
C                           LEXICAL SCANNER.
C
C            PRE-DEFINED GROUPS
C                           THE STORAGE AND INTERNAL GENERATION OF
C                           THESE MIGHT BE IMPROVED.
C
C            ** FIX **      THE LEXICAL SCANNER PROCESSOR IS 'NON-
C                           MODULAR' IN THE WAY IT USES THE ARRAY
C                           'STORE' . A GAP OF 400 LOACATIONS IS LEFT
C                           FOR IT.
C
C
C            CONSTANTS      USE SYMBOLS. SET VALUES IN 'DATA'
C
C
      DIMENSION OTEMP(3)
      DIMENSION UNITMX(9)
      DIMENSION ZEROSH(3)
\ICOM12
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XLISTI
\XCARDS
\XLST01
\XLST02
\XLST05
\XLST12
\XLST50
\XLEXIC
\XPDS
\XCONST
\XRGCOM
\XRGLST
\XRGRP
\XERVAL
\XOPVAL
\XIOBUF
\XCHARS
C
\QSTORE
\QLST12
C --
C --
C -- THE ARRAY 'GRPATM' OF CO-ORDINATES IS USED TO DEFINE GROUPS.
C    THE INDEX OF THE REQUIRED CO-ORDINATE TRIPLET IS AN ELEMENT IN AN
C    ARRAY, WHICH IS PASSED TO THE ROUTINE XRGPLG.
C
C          E.G. IHEX, A 6 ELEMENT ARRAY, IS INITIALISED
C                         WITH THE VALUES /1/ /2/ /3/ /4/ /5/ /6/
C                         WHICH CORRESPOND TO THE CO-ORDINATES :-
C
C    / 0.0 , 0.0 , 0.0 /  / 0.5 , 0.86603 , 0.0 /  ...
C
C    THE VALUE N REPRESENTS THE CO-ORDINATES IN : -
C         GRPATM(1,N) GRPATM(2,N) GRPATM(3,N)
C
C -- UNIT MATRIX AND ZERO SHIFT FOR GROUP PLACEMENT
      DATA UNITMX(1) /1./ UNITMX(2) /0./ UNITMX(3) /0./
      DATA UNITMX(4) /0./ UNITMX(5) /1./ UNITMX(6) /0./
      DATA UNITMX(7) /0./ UNITMX(8) /0./ UNITMX(9) /1./
      DATA ZEROSH(1) /0./ ZEROSH(2) /0./ ZEROSH(3) /0./
C --
      DATA IVERS /220/
      CALL XTIME1(2)
C --
C----- INDICATE THAT A MATRIX HAS NOT BEEN COMPUTED YET
      IMATRIX = -1
C----- INITIALISE THE POOR-FIT COUNTER
      NUMDEV = 0
      IPCHRE = -1
C -- READ THE INPUT DATA
      I=KLEXAN(IULN,IFIRST,LENGTH)
      IF (I) 9500,1000,1000
1000  CONTINUE
C -- SET THE INPUT LIST TYPE TO LIST 5
      LA=KTYP05(1)
C -- SET THE OUTPUT LIST TYPE TO LIST 5
      LB=KTYP05(1)
C -- CLEAR THE STORE
      CALL XRSL
      CALL XCSAE
C -- LOAD LISTS 1 AND 2
      CALL XFAL01
      CALL XFAL02
C -- LOAD LIST 50
      CALL XFAL50
C -- LOAD LIST 5
      CALL XLDRO5(LA)
      IF ( IERFLG .LT. 0 ) GO TO 9250
C -- INITIALISE VALUES FOR REGULARISE
C -- INDICATE THAT LIST 12 IS NOT TO BE USED
\IDIM12
      DO 1100 I = 1,IDIM12
      ICOM12(I) = NOWT
1100  CONTINUE
C -- SAVE LAST CARD IMAGE READ IN AND THE REST OF THE COMMON BLOCK
      CALL XMOVEI(IMAGE(1),ISAVE,99)
C -- SET INITIAL VALUES IN COMMON
      MDATMD = MD5
CDJWNOV99      NATOMP = 14
      NATOMP = MDATMD
      NATMD = 0
      MDOLD = 4
      NOLD = 0
      MDNEW = 4
      MDUIJ = 7
      NNEW = 0
C -- DEFAULT METHOD IS 1 (ROTATION COMPONENT OF ROTATION-DILATION
C    MATRIX ONLY)
      IMETHD=1
C -- SET GROUP SERIAL NUMBER TO ZERO
      IGRPNO=0
C
C -- SET THE DEFAULT VALUE OF THE 'DEFAULT COMPARE/REPLACE/KEEP' FLAG
C
      ICMPDF=MW
C -- SET REPLACE/COMPARE FLAG TO DEFAULT VALUE
      IFLCMP=ICMPDF
C
C -- SET THE DEFAULT VALUE OF THE 'NEW LIST' FLAG
C
      NEWLIS=0
C -- SET DEFAULT COORDINATES SYSTEM TO (1. 1. 1. 90. 90. 90.)
      CALL XMOVE(STORE(L1O2),RGOM(1,1),9)
C -- ZERO ORIGIN
      CALL XZEROF(ORIGIN(1),3)
C -- SET TO ZERO ROTATION
      CALL XUNTM3(RGMAT(1,1))
C -- SET UNIT MATRIX AND ZERO SHIFT
      CALL XUNTM3(UNITMX(1))
      CALL XZEROF(ZEROSH(1),3)
C----- ALLOCATE SPACE FOR RENAMING
      MDRENM = 6
      LRENM = KSTALL(MDRENM*N5)
c     CALL XZEROF(STORE(LRENM),MDRENM*N5)
C Allocate space for new space group closed set testing 
      MLTPLY = 2 * N2 * N2P * ( IC + 1 ) ! Twice current multiplicity.
C Space for upper triangle, each matrix has 16 entries. (N(N-1)/2 ops)
      MSGT = 8*MLTPLY*(MLTPLY+1)
      LSGT = KSTALL(MSGT)
      CALL XZEROF(STORE(LSGT),MSGT)

C -- ALLOCATE SPACE FOR A BUFFER FOR LEXICAL SCANNER
      LLXSPC = KSTALL(4000)
C -- SET VALUES IN ATOM
C -- OCCUPANCY=1.
      ATOM(3)=1.
CDJWNOV99
C----- FLAG
      ATOM(4)=1.0
C----- U'S and SPARE 
      CALL XZEROF(ATOM(8), NATOMP-11 )
C----- SET UISO
      ATOM(8) = 0.05
C----- SET PART, REF, HYB, NEW
      IATOM(15) = 0
      IATOM(16) = 0
      IATOM(17) = 0
      IATOM(18) = IB
C -- PREPARE FOR PROCESSING OF THE LEXICAL SCANNER OUTPUT
      CALL XILEXP(IULN,IFIRST)
C
C -- THE LOOP THAT FOLLOWS IS THE MAIN LOOP OF THIS SUBROUTINE. EACH
C    DIRECTIVE IS RECOVERED FROM THE LEXICAL SCANNER IN TURN, AND THE
C    APPROPRIATE ACTION IS TAKEN. ( THIS IS USUALLY A SUBROUTINE
C    CALL . ) AFTER THE DIRECTIVE HAS BEEN FULLY PROCESSED, THE ERROR
C    FLAG IS CHECKED, AND PROCESSING IS ABORTED IF AN ERROR HAS
C    OCCURED. OTHERWISE, THE NEXT DIRECTIVE IS PROCESSED, UNTIL THE
C    CYCLE IS BROKEN BY THE END OF THE DIRECTIVES.
C
C----  MAKE A COPY OF LIST 5 ATOMS AFTER THE LEXICAL WORK AREA
      LNEWL5 = KSTALL (N5 * MD5)
      CALL XMOVE (STORE(L5), STORE(LNEWL5), N5*MD5)
C      RESET THE ADDRESSES
      L5 = LNEWL5
      NL5 = 5
      IREC = 101
C----- LOCATE RECORD 101 AND UPDATE
      I = KHUNTR (NL5, IREC, IADDL, IADDR, IADDD, 0)
      ISTORE(IADDR+3) = L5
      CALL XUDRH (NL5, IREC, 0 , N5)
C
1200  CONTINUE
C
C -- SAVE VALUE OF NFL AND GIVE POSITION TO STORE LEXICAL
C    SCANNER OUTPUT
      ISVNFL=NFL
      MD=LLXSPC
      IF(KLDNLR(I))9000,1250,1200
1250  CONTINUE
C -- RESTORE NFL
      NFL=ISVNFL
C -- BRANCH ON THE FUNCTION
C>DJWOCT96
      GO TO (
     1 2100,2200,2300,2400,2500,2600,2700,2800,2900,3000,
     2 3100,3200,3300,3400,3500,3600,3700,3800,3900,2200,
     3 2300,2000,2050,2350,2250,2051,2000), MG
2000  CONTINUE
      CALL XERHND ( IERPRG )
      GOTO 8000
C
C<DJWOCT96/01
2050  CONTINUE
C----- 'RENAME'
CDJWAPR01 - COMPUTE TRANSFORMATION FOR GROUP
      IF (IERFLG.LT.0) GOTO 9250
      IF (NATMD .GT. 0) THEN
            CALL XRGCLC(IMATRIX,0)
            IMATRIX = +1
      ENDIF
C     RE-INITIALISE THINGS
      NATMD=0
      NOLD=0
      NNEW=0
C -- IF ERROR DURING CALCULATION THEN END
      IF (IERFLG.LT.0) GOTO 9250
C -- SET ORIGIN FOR RE-NUMBERING
      ZORIG=XLXRDV(100.)
      CALL XRGGRP(2)
C----- SET FLAG TO RENAME
      IFLCMP = 5
      GOTO 8000

2051  CONTINUE
C----- 'CAMERON'
CRICJAN03 - COMPUTE TRANSFORMATION FOR GROUP
      IF (IERFLG.LT.0) GOTO 9250
      IF (NATMD .GT. 0) THEN
            CALL XRGCLC(IMATRIX,0)
            IMATRIX = +2
      ENDIF
C     RE-INITIALISE THINGS
      NATMD=0
      NOLD=0
      NNEW=0
C -- IF ERROR DURING CALCULATION THEN END
      IF (IERFLG.LT.0) GOTO 9250
      CALL XRGGRP(2)
C----- SET FLAG TO CAMERON
      IFLCMP = 6
      GOTO 8000
C
2100  CONTINUE
C -- 'GROUP' DIRECTIVE
C -- DO CALCULATION FOR PREVIOUS GROUP IF NECESSARY
CDJWAPR2001
      IF (NATMD .GT. 0) THEN
             CALL XRGCLC(IMATRIX,0)
      ENDIF
C     RE-INITIALISE THINGS
      IMATRIX = -1
      NATMD=0
      NOLD=0
      NNEW=0
C -- IF ERROR DURING CALCULATION THEN END
      IF (IERFLG.LT.0) GOTO 9250
      CALL XRGGRP(1)
      GO TO 8000
C
2250  CONTINUE
C -- 'ONTO' DIRECTIVE
      IF (IMATRIX .LT. 0) GOTO 8100
2200  CONTINUE
C -- 'OLD' DIRECTIVE
      CALL XRGRDS ( 1 )
      GO TO 8000
C
2350  CONTINUE
C -- 'MAP' DIRECTIVE
      IF (IMATRIX .LT. 0) GOTO 8100
2300  CONTINUE
C -- 'NEW' DIRECTIVE
      CALL XRGRDS ( 2 )
      GO TO 8000
2400  CONTINUE

C -- 'SYSTEM' DIRECTIVE
      CALL XRGRCS
      GO TO 8000
2500  CONTINUE
C -- 'ATOM' DIRECTIVE
      CALL XRGRDA
      GO TO 8000
2600  CONTINUE
C -- 'ORIGIN' DIRECTIVE
      DO 2620 I=1,3
      OTEMP(I)=XLXRDV(0.)
2620  CONTINUE
C -- CONVERT ORIGIN TO CRYSTAL FRACTIONS
      CALL XMLTMM(RGOM(1,1),OTEMP(1),ORIGIN(1),3,3,1)
      GO TO 8000
2700  CONTINUE
C -- 'PHENYL' DIRECTIVE
      CALL XRGPLG (IHEX(1),6,1.39,1.39,0.0,ZEROSH(1),UNITMX(1))
      GO TO 8000
2800  CONTINUE
C -- 'HEXAGON' DIRECTIVE
      SCALE=XLXRDV(1.)
      CALL XRGPLG (IHEX(1),6,SCALE,SCALE,0.0,ZEROSH(1),UNITMX(1))
      GO TO 8000
2900  CONTINUE
C -- 'METHOD' DIRECTIVE
C -- READ METHOD NUMBER
      ZMETHD=XLXRDV(0.)
C -- CONVERT TO NEAREST INTEGER
      IMETH=NINT(ZMETHD)
C -- SET METHOD TO THIS VALUE
      CALL XRGSMD(IMETH)
      GO TO 8000
3000  CONTINUE
C -- 'SQUARE' DIRECTIVE
C -- READ SCALE FACTOR
      XSCAL = XLXRDV( 1.)
      YSCAL = XLXRDV( XSCAL)
C -- PLACE GROUP. SCALE FACTOR IS APPLIED TO X AND Y
      CALL XRGPLG(ISQR(1),4,XSCAL, YSCAL,0.0,ZEROSH(1),UNITMX(1))
      GO TO 8000
3100  CONTINUE
C -- 'OCTAHEDRON' DIRECTIVE
C -- READ SCALE FACTOR FOR X AND Y
      XSCAL = XLXRDV( 1.)
      YSCAL = XLXRDV( XSCAL)
C -- READ SCALE FACTOR FOR Z. THE DEFAULT VALUE FOR THIS IS WHATEVER
C    HAS BEEN SPECIFIED FOR X AND Y
      ZSCAL = XLXRDV( YSCAL)
C -- PLACE GROUP, USING SCALE FACTORS
      CALL XRGPLG(IOCT(1),7,XSCAL, YSCAL, ZSCAL,ZEROSH(1),UNITMX(1))
      GO TO 8000
3200  CONTINUE
C -- 'SQP' = 'SQUARE PYRAMID' DIRECTIVE
C -- SEE COMMENTS AFTER 'OCTAHEDRON'
      XSCAL = XLXRDV( 1.)
      YSCAL = XLXRDV( XSCAL)
      ZSCAL = XLXRDV( YSCAL)
      CALL XRGPLG(IOCT(1),6,XSCAL, YSCAL, ZSCAL,ZEROSH(1),UNITMX(1))
      GO TO 8000
3300  CONTINUE
C -- TRIGONAL BIPYRAMID
C -- SEE COMMENTS AFTER 'OCTAHEDRON'
      XYSCAL=XLXRDV(1.)
      ZSCAL=XLXRDV(XYSCAL)
      CALL XRGPLG(ITBP(1),6,XYSCAL,XYSCAL,ZSCAL,ZEROSH(1),UNITMX(1))
      GO TO 8000
3400  CONTINUE
C -- COMPARE DIRECTIVE
C    SET FLAG TO COMPARE
      IFLCMP=2
      GO TO 8000
3500  CONTINUE
C -- REPLACE DIRECTIVE
C    SET FLAG TO REPLACE
      IFLCMP=1
      GO TO 8000
3600  CONTINUE
C -- KEEP DIRECTIVE
C    SET FLAG
      IFLCMP=3
      GO TO 8000
3700  CONTINUE
C----- AUGMENT
      IFLCMP = 4
      GO TO 8000
C TETRAHEDRON -  LISA PEARCE
3800  CONTINUE
      SCALE=XLXRDV(1.)
      CALL XRGPLG(ITET(1),5,SCALE,SCALE,SCALE,ZEROSH(1),UNITMX(1))
      GOTO 8000
3900  CONTINUE
C CP RING -  LISA PEARCE
      SCALE=XLXRDV(1.4)
C 1.17557 IS 2* SIN OF 36 DEGREES
      SCALE=SCALE/1.17557
      CALL XRGPLG(ICPR(1),5,SCALE,SCALE,0.0,ZEROSH(1),UNITMX(1))
      GOTO 8000
C
8000  CONTINUE
C -- CHECK FOR ERRORS AND ABANDON THIS ROUTINE IF AN ERROR
C    HAS OCCURED
      IF (IERFLG.GT.0) GO TO 1200
C -- SET FLAG TO PRODUCE NO NEW LIST
      NEWLIS=0
      GOTO 9000
8100  CONTINUE
      WRITE(CMON,'(A)') 'No Matrix to use for renumbering'
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      IERFLG = -1
      GOTO 9000
9000  CONTINUE
C -- END OF DIRECTIVES
C -- THERE MAY BE A CALCULATION OUTSTANDING WHICH SHOULD BE PERFORMED
C    IF THERE HAS BEEN NO ERROR
      IF (NATMD .GT. 0) THEN
        IF (IERFLG.GE.0) CALL XRGCLC(IMATRIX,0)
      ENDIF
C -- CHECK IF A NEW LIST 5 IS TO BE PRODUCED
      IF (NEWLIS) 9050,9100,9150
9050  CONTINUE
      CALL XERHND ( IERPRG )
9100  CONTINUE
C -- NO NEW LIST TO BE PRODUCED
      WRITE ( CMON,9110)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
9110  FORMAT (' No new list 5 will be created ')
      GO TO 9200
9150  CONTINUE
C -- WRITE OUT NEW LIST
C --
C --  MODIFY LIST 5
      LN=5
      IREC=101
C -- LOCATE RECORD 101
      I=KHUNTR(LN,IREC,IADDL,IADDR,IADDD,0)
C -- CHANGE ADDRESS
      ISTORE(IADDR+3)=L5
C -- UPDATE RECORD HEADER
      CALL XUDRH(LN,IREC,0,N5)
C -- STORE LIST 5
      CALL XSTR05(5,0,1)
C -- WRITE FINAL MESSAGES
      WRITE ( CMON,9155) N5
      CALL XPRVDU(NCVDU, 2,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') (CMON(II)(:),II=1,2)
9155  FORMAT (' List 5 now contains ',I4,' atoms  ',/,
     2 ' list modification complete  ')
C -- FINISH ROUTINE
9200  CONTINUE
      IF (NUMDEV .GT. 0) THEN
       WRITE ( CMON,'(I5,A)') NUMDEV, ' Poorly mapping groups'
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU, 1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      ENDIF
C -- RESTORE LAST CARD IMAGE READ IN
      CALL XMOVEI(ISAVE(1),IMAGE(1),99)
C -- RELEASE STORE ALLOCATED
      CALL XSTRLL (LLXSPC)
      GOTO 9300
C
9250  CONTINUE
      CALL XOPMSG( IOPREG, 2, IVERS)
C
9300  CONTINUE
C -- THIS IS THE ONLY WAY OUT OF THE ROUTINE
C -- WRITE FINAL MESSAGE
      CALL XOPMSG( IOPREG, IOPEND, IVERS)
      CALL XTIME2(2)
      RETURN
C
C -- THE FOLLOWING SECTION DEALS WITH ERRORS DETECTED IN THIS
C    SUBROUTINE
9500  CONTINUE
      WRITE ( CMON,9510)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
9510  FORMAT (' Errors detected by lexical scanner  ')
      CALL XERHND ( IERERR )
C
C -- EXIT THIS ROUTINE,PRINTING ONLY THE FINAL MESSAGE AND ELAPSED
C    TIME.
      GO TO 9250
      END
C
C --
C
CODE FOR XRGCLC
      SUBROUTINE XRGCLC (IMATRIX,LSPARE)
C 
C -- THIS SUBROUTINE CONTROLS THE ACTUAL CALCULATION PERFORMED BY
C    REGULARISE.
C 
C      IMATRIX -1 INITIAL CALL TO COMPUTE MATRICES
C              +1 SECOND CALL IF RENUMBERING REQUIRED
C              +2 SECOND CALL REQUIRING CAMERON OUTPUT
C              +3 SECOND CALL REORDERS ATOMS IN JNEW TO MATCH JOLD
C
C      LSPARE   0 Normal operation
C               1 'Spare' value must be same for matched atoms.
C 
C 
C    DATA SHOULD HAVE BEEN STORED BY THE OTHER ROUTINES, AND THE BEST
C    FIT MATRIX WILL NOW BE CALCULATED BY THE CHOSEN METHOD.
C 
C 
C -- THIS PROCEDURE DOES THE FOLLOWING
C 
C          DATA CHECK       CHECK THAT ALL DATA REQUIRED IS PRESENT.
C                           INSUFFICIENT DATA IS AN ERROR.
C 
C          TRANSFORM CO-ORDINATES
C                           CO-ORDINATES ARE CONVERTED TO ORTHOGONAL
C                           SYSTEM. THE CENTROIDS OF THE GROUPS ARE
C                           MADE TO CO-INCIDE, AND THEY ARE ROTATED
C                           TO THEIR 'BEST PLANES' .
C 
C          CALCULATION USING 'XRGCRD' OR 'XRGCKB'
C                           THE BEST-FIT MATRIX IS CALCULATED
C 
C          CHECK MATRIX AND APPLY TO 'NEW' COORDINATES
C                           CHECK MATRIX DEFINES ALL ROTATIONS THAT
C                           WILL BE REQUIRED TO TRANSFORM CO-ORDIN-
C                           ATES. MATRIX APPLIED TO COORDINATES WHICH
C                           ARE THEN RETURNED TO ORIGINAL SYSTEM.
C 
C          FORM NEW LIST 5
C                           THE INTERNAL COPY OF LIST 5 IS UPDATED.
C                           THIS WILL BE WRITTEN TO DISC IF THIS HAS
C                           BEEN REQUESTED.
C 
C -- THERE ARE 3 WAYS, AT PRESENT, OF CALCULATING THE BEST FIT MATRIX.
C    THE PARTICULAR ONE OF THESE USED IN EACH CASE DEPENDS ON THE
C    VALUE OF THE VARIABLE 'IMETHD'.
C    THIS IS USED IN THIS SUBROUTINE TO SELECT ONE OF THE POSSIBLE
C    CALLS WHICH WILL CALCULATE A MATRIX.
C 
C 
      DIMENSION ITEMP(3), ATEMP(3), RTEMP1(3,3), RTEMP2(3,3), OPM(4,4)
C 
Cdjwnov99      DIMENSION CENTO(3),CENTN(3)
      COMMON/REGTMP/ 
     1CENTO(4), CENTN(4),WSPAC1(3,3), WSPAC2(3,3), WSPAC3(3,3),
     2ROOTO(3), ROOTN(3),VECTO(3,3),VECTN(3,3),COSNO(3,3),COSNN(3,3),
     3RESULT(3,3),DELCNT(3), AVCNT(3),CFBPOL(3,3), CFBPNE(3,3),
     4BPCFOL(3,3), BPCFNE(3,3)
C 
      CHARACTER*6 CELEMT
      CHARACTER*2 CSYM
      CHARACTER*1 CAXIS(3)
      CHARACTER*12 CFUNC(3)
      CHARACTER*2 CTEMP(3)
C 
C 
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XLST01
\XLST02
\XLST05
\XRGCOM
\XRGLST
\XCONST
\XERVAL
\XOPVAL
\XIOBUF
C 
\QSTORE
C 
      DATA CELEMT/'23461m'/
      DATA CAXIS/'X','Y','Z'/
      DATA CFUNC/'Replacement','Comparison','Renaming'/
C
C
C
CDJWAPR2001
C----- CHECK THE NUMBER OF NEW AND OLD ATOMS
      IF (IMATRIX.GE.1) THEN
        WRITE(CMON,'(A,I4,A,I4)') 'Input: mapping ', NNEW ,
     1 ' atoms onto ', nold 
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
        IF (NOLD.EQ.NNEW) NATMD=NNEW
      END IF
C -- IF THERE ARE NO ATOM DEFINITIONS THEN THERE IS NO CALCULATION
      IF (NATMD.EQ.0) RETURN
C 
C -- CHECK DATA FOR COMPLETENESS.
C    THE NUMBER OF 'OLD' AND 'NEW' ATOMS SHOULD NOT BE LESS THAN THE
C    NUMBER STATED TO BE IN THE GROUP. ANY EXCESS WILL ALREADY HAVE
C    CAUSED AN ERROR.
C

      IF (NOLD.LT.NATMD) GO TO 1950
      IF (NNEW.LT.NATMD) GO TO 2050
C----- COPY OLD WEIGHT TO NEW
      MOLD=LOLD
      MNEW=LNEW
      DO 50 I=1,NOLD
         STORE(MNEW+3)=STORE(MOLD+3)
         MOLD=MOLD+MDOLD
         MNEW=MNEW+MDNEW
50    CONTINUE
C 
C 
C -- PRINT HEADER TEXT
      NFUNC=1
      IF (IFLCMP.EQ.2) NFUNC=2
      IF (IFLCMP.EQ.5) NFUNC=3
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,100) CFUNC(NFUNC),IGRPNO
      END IF
100   FORMAT (//,1X,50X,A,' of group number ',I3,//)
C 
Cdjwapr2001
      IF (IMATRIX.EQ.-1) THEN
C----- INITIALISE THE DEVIATIONS TO MASSIVE
      SUMDEV = 1000000.
C -- CALCULATE THE CENTROIDS, USING WEIGHTS OF 1. AND 0. TO REPRESENT
C    ATOMS WHICH ARE AND ARE NOT DEFINED IN THE 'OLD' GROUP.
C 
         CALL XRGCNT (CENTO,STORE(LOLD),STORE(LOLD),MDOLD,MDOLD,NOLD)
         CALL XRGCNT (CENTN,STORE(LNEW),STORE(LOLD),MDNEW,MDOLD,NOLD)
C 
C -- PRINT CENTROIDS AVERAGE, AND THE DIFFERENCE BETWEEN THEM
         CALL XSUBTR (CENTN,CENTO,DELCNT,3)
         CALL XADDR (CENTN,CENTO,ROOTO,3)
         CALL XMULTR (ROOTO,0.5,AVCNT,3)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,150) (CENTO(I),I=1,3),(CENTN(I),I=1,3)
150         FORMAT (1X,15X,'Centroids of old and new groups ',
     1 '( in crystal fractions ) ',/,1X,2(9X,3F9.5))
         END IF
Cdjwnov99      WRITE ( CMON , 2006 ) CENTO , CENTN
         WRITE (CMON,200) (CENTO(I),I=1,3),(CENTN(I),I=1,3)
         CALL XPRVDU (NCVDU,2,0)
200      FORMAT (1X,'Centroids of old and new groups ',
     1 '( in crystal fractions ) ',/,1X,2(3F8.4,3X))
        IF (IPCHRE.GE.0)THEN
         WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(6(A,F9.4))')
     1   (CHAR(9),CENTO(I),I=1,3),(CHAR(9),CENTN(I),I=1,3)
         CALL XCREMS(CPCH,CPCH,LENFIL)
        END IF

C 
C -- CALCULATE THE BEST PLANE THROUGH THE ATOMS IN EACH GROUP
C 
         I=KMOLAX(STORE(LOLD),NOLD,MDOLD,WSPAC1(1,1),ROOTO(1),VECTO(1,1)
     1    ,COSNO(1,1),WSPAC2(1,1))
C 
         I=KMOLAX(STORE(LNEW),NNEW,MDNEW,WSPAC1(1,1),ROOTN(1),VECTN(1,1)
     1    ,COSNN(1,1),WSPAC2(1,1))
C-----
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,250) ROOTO,ROOTN
         END IF
250      FORMAT (1X,' Principal moments of inertia of old and new groups
     1',//1X,2(10X,3F8.3),//)
         WRITE (CMON,300) ROOTO,ROOTN
         CALL XPRVDU (NCVDU,2,0)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') (CMON(II)(:),II=1,2)
300      FORMAT (1X,'Principal moments of inertia of old and new groups'
     1    ,/1X,2(3F8.3,3X))
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(6(A,F9.4))')
     1    (CHAR(9),ROOTO(I),I=1,3),(CHAR(9),ROOTN(I),I=1,3)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF

C -- CALCULATE MATRIX TRANSFORMING FROM CRYSTAL SYSTEM TO BEST PLANE
C    AND BACK
         CALL XMLTMT (VECTO,STORE(L1O1),CFBPOL,3,3,3)
         CALL XMLTMT (VECTN,STORE(L1O1),CFBPNE,3,3,3)
C 
         CALL XMLTMM (STORE(L1O2),COSNO,BPCFOL,3,3,3)
         CALL XMLTMM (STORE(L1O2),COSNN,BPCFNE,3,3,3)
Cdjwapr2001
      END IF
C 
C 
C----- RESTORE 'NEW' WEIGHTS TO UNITY
      MNEW=LNEW
      DO 350 I=1,NNEW
         STORE(MNEW+3)=1.
         MNEW=MNEW+MDNEW
350   CONTINUE
C 
C -- NOW TRANSFORM CO-ORDINATES
C    TRANSLATE CO-ORDINATES TO PLACE CENTROIDS AT ORIGIN.
      CALL XMXTRL (STORE(LOLD),CENTO,MDOLD,NOLD)
      CALL XMXTRL (STORE(LNEW),CENTN,MDNEW,NNEW)
C 
C -- ROTATE GROUPS TO THEIR BEST PLANE AXES.
      CALL XMXRTI (STORE(LOLD),CFBPOL,MDOLD,NOLD)
      CALL XMXRTI (STORE(LNEW),CFBPNE,MDNEW,NNEW)
C 
C 
Cdjwapr2001
      IF (IMATRIX.LE.-1) THEN
C -- CALCULATE BEST FIT MATRIX BY CALLING THE APPROPRIATE ROUTINE
         GO TO (400,450,500,2250),IMETHD
         GO TO 2250
400      CONTINUE
C 
C -- CALCULATE ROTATION COMPONENT OF ROTATION-DILATION MATRIX
         CALL XRGCRD (RESULT,1)
         GO TO 550
C 
450      CONTINUE
C -- CALCULATE FULL ROTATION-DILATION MATRIX
         CALL XRGCRD (RESULT,2)
         GO TO 550
C 
500      CONTINUE
C -- CALCULATE ROTATION MATRIX BY KABSCH METHOD
         CALL XRGCKB (RESULT(1,1))
         GO TO 550
C 
550      CONTINUE
C -- CHECK FOR ERRORS IN CALCULATION
         IF (IERFLG.LT.0) GO TO 1900
C 
C -- CALCULATE TRANSFORMATION MATRIX IN OTHER COORDINATE SYSTEMS
C    ORTHOGONAL SYSTEM IN (W2)
         CALL XMLTMM (RESULT,VECTN,WSPAC1,3,3,3)
         CALL XMLTMM (COSNO,WSPAC1,WSPAC2,3,3,3)
C    CRYSTAL SYSTEM IN (W3)
         CALL XMLTMM (RESULT,CFBPNE,WSPAC1,3,3,3)
         CALL XMLTMM (BPCFOL,WSPAC1,WSPAC3,3,3,3)
C 
C -- COMPLETE CALCULATION
C -- BEFORE APPLYING THE CALCULATED MATRIX TO THE 'NEW' COORDINATES, A
C    CHECK MUST BE DONE , IN CASE THE MATRIX WILL LEAVE THE ROTATION OF
C    SOME ATOMIC COORDINATES UNDEFINED.
C 
         MNEW=LNEW+(NNEW-1)*MDNEW
         MUIJ=LUIJ+(NNEW-1)*MDUIJ
         IDEFIN=1
C 
         DO 700 I=1,3
            DEFIND=RESULT(1,I)+RESULT(2,I)+RESULT(3,I)
            IF (ABS(DEFIND).GT.(3*ZERO)) GO TO 700
C -- ROTATION FOR THIS COORDINATE IS UNDEFINED. THIS IS HOWEVER OK
C    IF THERE ARE NO NON-ZERO VALUES FOR THIS COORDINATE
            DO 650 J=LNEW,MNEW,MDNEW
               INDNEW=J+I
               IF (ABS(STORE(INDNEW)).GT.ZERO) GO TO 650
C -- ERROR
               NUMATM=((J-LNEW)/MDNEW)+1
               WRITE (CMON,600) CAXIS(I),NUMATM
               CALL XPRVDU (NCVDU,1,0)
               IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)(:)
600            FORMAT (1X,'Rotation of ',A1,' coordinate is undefined ',
     1          ' for atom number ',I5)
               IDEFIN=-1
650         CONTINUE
700      CONTINUE
         IF (IDEFIN.LT.0) GO TO 2300
Cdjwapr2001
      END IF
C 
C -- MATRIX CHECKED. APPLY MATRIX TO OLD COORDINATES
      CALL XMXRTI (STORE(LNEW),RESULT,MDNEW,NNEW)
      CALL XMXUIJ (STORE(LUIJ),WSPAC3,MDUIJ,NNEW,STORE(L1P2))
C 
Cdjwapr2001
      IF (IMATRIX.LE.-1) THEN
C -- PRINT COORDINATES AFTER FITTING AND THE DEVIATIONS BETWEEN THEM
C 
         CALL XRGPCS (2,3)
C 
C----- WRITE THE IMPORTANT MATRICES AND VECTORS
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,750) AVCNT,DELCNT
750         FORMAT (/1X,15X,'Average and difference of centroids ',
     1 '( in crystal fractions ) ',/,7X,2(9X,3F9.5))
C 
            WRITE (NCWU,800)
800         FORMAT (/,1X,'Transformation matrix relating new and old',
     1' coordinates',/,1X,15X,'In best plane system                ',
     2'In orthogonal system                ','In crystal system '/)
C 
            WRITE (NCWU,850) ((RESULT(I,J),I=1,3),(WSPAC2(I,J),I=1,3),
     1       (WSPAC3(I,J),I=1,3),J=1,3)
850         FORMAT (3(1X,15X,3(3F10.6,5X),/))
         END IF
C 
         WRITE (CMON,900) AVCNT,DELCNT
         CALL XPRVDU (NCVDU,2,0)
900      FORMAT (1X,'Average and difference of centroids ',
     1 '( in crystal fractions ) ',/,1X,2(3F8.4,3X))
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(6(A,F9.4))')
     1    (CHAR(9),AVCNT(I),I=1,3),(CHAR(9),DELCNT(I),I=1,3)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF
C 
         WRITE (NCAWU,950)
950      FORMAT (/1X,'Tranformation matrix between new and old ',
     1 'coordinates',/' in crystal system'/)
         WRITE (NCAWU,1000) ((WSPAC3(I,J),I=1,3),J=1,3)
1000     FORMAT (3(6X,3F10.6,/))
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(9(A,F9.4))')
     1    ((CHAR(9),WSPAC3(I,J),I=1,3),J=1,3)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF

CDJWMAR2000
C FIND PSEUDO OPERATOR - GIACOVAZZO, PAGE 43
C      GET THE DETERMINANT AND TRACE
         DET=XDETR3(WSPAC3)
         TRACE=WSPAC3(1,1)+WSPAC3(2,2)+WSPAC3(3,3)
C Output determinant and trace
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(2(A,F7.4))')
     1    CHAR(9),DET,CHAR(9),TRACE
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF
         DETTRC=DET+TRACE

         IF (IPCHRE.GE.0)THEN

C Transform rotation matrix onto a primitive lattice.
c
c         DATA LTTYP /  1,  0,  0,    0,  1,  0,    0,  0,  1,   !P
c     2               -.5, .5, .5,   .5,-.5, .5,   .5, .5,-.5,   !I
c     4 .6667,-.3333,-.3333, .3333,.3333,-.6667, .3333,.3333,.3333, !R
c     3                 0, .5, .5,   .5,  0, .5,   .5, .5,  0,   !F
c     5                 1,  0,  0,    0, .5, .5,    0,-.5, .5,   !A
c     6                 0, .5, .5,    1,  0,  0,    0,-.5, .5,   !B
c     7                 0, .5, .5,    0,-.5, .5,    1,  0,  0    !C




C Work out closeness to an ideal space group rotation.
          CLOSEX =   ( WSPAC3(1,1)-NINT(WSPAC3(1,1)) )**2
     3             + ( WSPAC3(1,2)-NINT(WSPAC3(1,2)) )**2
     6             + ( WSPAC3(1,3)-NINT(WSPAC3(1,3)) )**2
     9             + ( WSPAC3(2,1)-NINT(WSPAC3(2,1)) )**2
     3             + ( WSPAC3(2,2)-NINT(WSPAC3(2,2)) )**2
     6             + ( WSPAC3(2,3)-NINT(WSPAC3(2,3)) )**2
     9             + ( WSPAC3(3,1)-NINT(WSPAC3(3,1)) )**2
     3             + ( WSPAC3(3,2)-NINT(WSPAC3(3,2)) )**2
     6             + ( WSPAC3(3,3)-NINT(WSPAC3(3,3)) )**2
     
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,F13.5)')
     1    CHAR(9),SQRT(CLOSEX/9.0)
          CALL XCREMS(CPCH,CPCH,LENFIL)

C Work out closeness to a group operator.
          CALL XMLTMM(WSPAC3,DELCNT,ATEMP,3,3,1)
          CALL XADDR(DELCNT,ATEMP,ATEMP,3)
C ATEMP should be some kind of unit translation.
          CLOSEN = 0.0
          DO IJ = 1,3
           CLOSEN = CLOSEN + ( ATEMP(IJ) - NINT(ATEMP(IJ)))**2 
          END DO
          CLOSEN = SQRT(CLOSEN/3.0)
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,F13.5)')
     1    CHAR(9),CLOSEN
          CALL XCREMS(CPCH,CPCH,LENFIL)

C Output the atemp vector for inspection:
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(3(A,F8.3))')
     1    (CHAR(9),ATEMP(IJ),IJ=1,3)
          CALL XCREMS(CPCH,CPCH,LENFIL)

C Combine both measures above
          DO IJ = 1,3
           CLOSEX = CLOSEX + (   ATEMP(IJ) - NINT( ATEMP(IJ) )   )**2
          END DO
           
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,F13.5)')
     1    CHAR(9),SQRT(CLOSEX/12.0)
          CALL XCREMS(CPCH,CPCH,LENFIL)


C THIS IS IT. See how well operator fits into current space group.
C 1) Fill in the first half of the column of the array at LSGT
C    with all the operators of the current space group.
C
C LSGT stores enough 4x4 operators to fit all the symmetry operators
C of the current space group if an extra order 2 operator is added.
C It is stored as a lower triangular array, the first element being
C the unit matrix, and the first column listing each operator.
C Lower triangle storage is sufficient to store all combinations of
C these operators.
C These formulae may come in handy:
C
C Amount of storage for a lower triangle of side N = N(N+1)/2
C
C Address of element Aij = i+(2n-j)(j-1)/2    ( j < i )
C

          MSGT = LSGT  ! Currect matrix to fill in.
          MLTPLY = 2 * N2 * N2P * ( IC + 1 ) ! Twice current multiplicity.
          NMATR = 0.5*MLTPLY*(MLTPLY+1)

          DO K2=1,3
            OPM(4,K2) = 0.0
          END DO
          OPM(4,4) = 1.0

          DO M2 = L2,L2+MD2*(N2-1),MD2 ! Loop over each symmetry matrix
C Get the matrix.
            DO K4=0,3
              CALL XMOVE(STORE(M2+3*K4),OPM(1,1+K4),3)
            END DO

            DO M2C = 0, IC                   ! IC is 1 for inversion centre.
              IF ( M2C .EQ. 1 ) THEN         ! Apply inversion on second loop.
                DO K3=1,4
                 DO K2=1,3
                  OPM(K2,K3) = - OPM(K2,K3)
                 END DO
                END DO
              END IF

              DO M2P = L2P,L2P+MD2P*(N2P-1),MD2P         ! Add in centerings
                CALL XMOVE(OPM(1,1),STORE(MSGT),16)
                CALL XADDR(STORE(MSGT+12),STORE(M2P),STORE(MSGT+12),3)
                MSGT = MSGT + 16 ! Advance to next matrix.
              END DO
            END DO
          END DO

C Put the new found transformation into the next space.
          DO K2 = 0,2
            CALL XMOVE(WSPAC3(1,K2+1),STORE(MSGT+K2*4),3)
          END DO
          CALL XMOVE(DELCNT(1),STORE(MSGT+12),3)
          DO K2 = 3,11,4
            STORE(MSGT+K2) = 0.0
          END DO
          STORE(MSGT+15) = 1.0

          NPWORS = MSGT

          DO K1 = MLTPLY/2+1, MLTPLY     !Loop over remaining empty rows.

C Add the transform that we've just found (no-op the 1st time round)
            CALL XMOVE(STORE(NPWORS),STORE(MSGT),16)

C Using the first column as untransformed operators (ie. 1,1 must be unit matrix)
C generate all the other columns. (Note lower triangle storage). See KSGTEX
C for a better explanation.

            CALL KSGTEX(NMATR,STORE(LSGT))

C Now find which operator in the last row added is most UNLIKE any other
C operator in the set so far.
C Compare each matrix in the ROW to every matrix so far,
C store the best match each time. Then choose the worst of these 'best'
C matches.
            WORST = 9999999.0 
            NPWORS = LSGT

            DO K2 = 2,K1   ! Loop over that row (K1) from the 2nd column

C For each new matrix in the new row.
C Consider this matrix. At JSGT

              JSGT = LSGT + 16*( (K1-1) + ((2*MLTPLY - K2) * (K2-1) /2))

              WRITE(CMON,'(A,I4,A,I8)')
     1         'Considering col ',K2,' at ',JSGT
              CALL XPRVDU(NCVDU,1,0)

      WRITE(CMON,'(/4(4F9.3/))') ((STORE(JSGT+J2+J3),J2=0,12,4),J3=0,3)
      CALL XPRVDU(NCVDU,5,0)

C Test it against all matrices so far and store the BEST
C match.
              BEST = -9999999.0
              DO KRW = 1,K1-1
                DO KCL = 1,KRW
                  KSGT = LSGT + 16*((KRW-1)+((2*MLTPLY-KCL)*(KCL-1)/2))
  
      WRITE(CMON,'(/4(4F9.3/))') ((STORE(KSGT+J2+J3),J2=0,12,4),J3=0,3)
      CALL XPRVDU(NCVDU,5,0)

C Shift trans bits of matrix at KSGT so that they are as close as
C poss to the entries at JSGT. (ie. All values are 0<t<1 to start with,
C but 0.01 and 0.98 *should* be close)

                  CALL XMOVE(STORE(KSGT),OPM(1,1),16)
    
                  DO K4 = 1,3
                    DELTA = OPM(K4,4) - STORE(JSGT+11+K4)
                    IF ( DELTA .LT. -0.5 ) THEN
                      OPM(K4,4) = OPM(K4,4) + 1
                    ELSE IF ( DELTA .GT. 0.5 ) THEN
                      OPM(K4,4) = OPM(K4,4) - 1
                    END IF
                  END DO


                  R = CMPMAT(STORE(JSGT),OPM(1,1),16)  ! Compare them
                  WRITE(CMON,'(A,2I2,A,I2,A,F18.3)')
     1            'R at:',K1,K2, ' with ',KRW,' 1 is ',R
                  CALL XPRVDU(NCVDU,1,0)
                  BEST = MAX(BEST, R)       ! The best found
                END DO
              END DO

              WRITE(CMON,'(A,I4,A,F18.3)')
     1         'Best col ',K2,' match is ',BEST
              CALL XPRVDU(NCVDU,1,0)

C Store the worst of the best matches, and the corresponding op.
              IF ( WORST .GT. BEST ) THEN
                WORST  =  BEST
                NPWORS =  JSGT
              END IF
            END DO
            WRITE(CMON,'(A,F15.3,A,I8)')
     1         'Worst close match is ',WORST, ' at ', NPWORS
            CALL XPRVDU(NCVDU,1,0)


            MSGT = MSGT + 16

          END DO
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,F13.9)')
     1    CHAR(9),WORST
          CALL XCREMS(CPCH,CPCH,LENFIL)

         ENDIF

         IF (IPCHRE.GE.0)THEN
           IF ( (ABS(1.-ABS(DET)).LE..05) .AND.
     1        (ABS(TRACE - NINT(TRACE)).LE..1)) THEN
             I=1+NINT(ABS(DETTRC))
             CSYM=' '
             CSYM(2:2)=CELEMT(I:I)
             IF ((NINT(TRACE).EQ.1).AND.(NINT(DET).EQ.-1)) THEN
               CSYM=' m'
             ELSE
               IF (DET.LT.ZERO) CSYM(1:1)='-'
             END IF
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(2A)')
     1       CHAR(9),CSYM(1:2)
             CALL XCREMS(CPCH,CPCH,LENFIL)
           ELSE
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(2A)')
     1       CHAR(9),'none'
             CALL XCREMS(CPCH,CPCH,LENFIL)
           END IF
         END IF


         IF (ABS(1.-ABS(DET)).LE..05) THEN
            I=1+NINT(ABS(DETTRC))
            CSYM=' '
            CSYM(2:2)=CELEMT(I:I)
            IF ((NINT(TRACE).EQ.1).AND.(NINT(DET).EQ.-1)) THEN
               CSYM=' m'
            ELSE
               IF (DET.LT.ZERO) CSYM(1:1)='-'
            END IF
            WRITE (CMON,1050) CSYM(1:2)
            CALL XPRVDU (NCVDU,1,0)
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(2A)')
     1       CHAR(9),CSYM(1:2)
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(/A/)') CMON(1)(:)
1050        FORMAT (' Pseudo-symmetry element ',A2,' detected')
         ELSE
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(2A)')
     1       CHAR(9),'none'
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
         END IF
C 
         DO 1150 J=1,3
            ITEMP(J)=10
            DO 1100 I=1,3
               IF (ABS(1.-ABS(WSPAC3(I,J))).LE.0.05) ITEMP(J)=I*
     1          INT(SIGN(1.,WSPAC3(I,J)))
1100        CONTINUE
1150     CONTINUE
         IF (IABS(ITEMP(1))+IABS(ITEMP(2))+IABS(ITEMP(3)).EQ.6) THEN
            DO 1200 J=1,3
               CTEMP(J)=' '
               IF (ITEMP(J).LE.0) THEN
                  ATEMP(J)=2.*AVCNT(J)
                  CTEMP(J)(1:2)='-'//CAXIS(IABS(ITEMP(J)))
               ELSE
                  ATEMP(J)=DELCNT(J)
                  CTEMP(J)(1:2)='+'//CAXIS(IABS(ITEMP(J)))
               END IF
1200        CONTINUE
            WRITE (CMON,1250) (ATEMP(J),CTEMP(J),J=1,3)
            CALL XPRVDU (NCVDU,1,0)
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),
     1       '(A,3(F6.2,A2,2X))') CHAR(9),(ATEMP(J),CTEMP(J),J=1,3)
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(/A/)') CMON(1)(:)
1250        FORMAT (' Pseudo-symmetry operator of form :-  ',
     1       3(F6.2,A2,2X))
         ELSE
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(2A)')
     1       CHAR(9),'none'
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
         END IF

C Output number of atoms.
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,I6)')
     1    CHAR(9),NOLD
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF

C Output space group symbol.
         IF (IPCHRE.GE.0)THEN
          J  = L2SG + MD2SG - 1
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,4(1X,A4))')
     1    CHAR(9),(ISTORE(I), I = L2SG, J)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF

C Output cell.
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(6(A,F9.4))')
     1    (CHAR(9),ISTORE(I), I = L1P1, L1P1+5)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF


C -- ROTATE COORDINATES BACK TO ORTHOGONAL SYSTEM DEFINED BY
C    CRYSTAL
C 
         CALL XMXRTI (STORE(LNEW),BPCFOL,MDNEW,NNEW)
C 
C -- CALCULATE TRANSLATION TO RETURN COORDINATES TO CORRECT
C    ORIGIN. THIS IS MINUS THE CENTROID OF THE OLD GROUP
         DO 1300 I=1,3
            CENTO(I)=-CENTO(I)
1300     CONTINUE
C -- TRANSLATE TO RETURN TO THE CRYSTAL SYSTEM
         CALL XMXTRL (STORE(LNEW),CENTO(1),MDNEW,NNEW)
c----- AND NOW RESTORE CENTROID
         DO 1310 I=1,3
            CENTO(I)=-CENTO(I)
1310     CONTINUE
C
C -- PRINT THESE COORDINATES
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,1350)
         END IF
1350     FORMAT (/' Final new atom coordinates in crystal fractions ')
         DO 1450 I=1,NNEW
            INDATM=LATMD+(I-1)*MDATMD
            INDNEW=LNEW+(I-1)*MDNEW
            IF (ISSPRT.EQ.0) THEN
               WRITE (NCWU,1400) STORE(INDATM),STORE(INDATM+1),
     1          STORE(INDNEW),STORE(INDNEW+1),STORE(INDNEW+2)
            END IF
1400        FORMAT (1X,A4,3X,F5.0,5X,3(F8.4,5X))
1450     CONTINUE
Cdjwapr2001
      ELSE IF ( IMATRIX .EQ. 1 ) THEN
            CALL XRGRNM 
      ELSE IF ( IMATRIX .EQ. 2 ) THEN
            CALL XRGCAM
      ELSE
            CALL XRGMAT(LSPARE)
      END IF
C -- CHECK REPLACE/COMPARE FLAG, TO DETERMINE WHETHER LIST 5
C    SHOULD BE CHANGED.
      GO TO (1500,1750,1500,1500,1740,1741),IFLCMP
1500  CONTINUE
C -- COPY COORDINATES BACK TO ATOM DEFINTION BLOCK
      DO I=1,NATMD
C -- CALCULATE THE POSITIONS TO MOVE THE COORDINATES BETWEEN
        INDATM=LATMD+(I-1)*MDATMD+4
        INDNEW=LNEW+(I-1)*MDNEW
        INDUIJ=LUIJ+(I-1)*MDUIJ
        CALL XMOVE (STORE(INDNEW),STORE(INDATM),3)
        CALL XMOVE (STORE(INDUIJ+1),STORE(INDATM+3),6)
      END DO
 
C -- FORM NEW LIST 5
C -- SET COUNT OF ATOMS IN THIS LIST TO 0
      NNEWL5=0
C -- REMEMBER WHERE THE LIST STARTS
      LNEWL5=NFL
      DO 1700 I=1,N5
C -- FOR EACH ATOM IN THE OLD LIST 5
C    CALCULATE ITS POSITION IN THE LIST
         INDL5=L5+(I-1)*MD5
C -- IF IFLCMP=3 THEN COPY COMPLETE OLD LIST
         IF (IFLCMP.EQ.3) GO TO 1650
C -- CHECK IF THE ATOM IN LIST 5 IS ONE OF THOSE IN THE GROUP
C    JUST PROCESSED
C -- SET POINTERS FOR SEARCHING FOR ATOMS IN THE CURRENT GROUP
         MLST=LATMD
         NLST=NATMD
         MDLST=MDATMD
         IATOMF=KATOMF(STORE(INDL5),MLST,NLST,MDLST,-1)
C----- IF ATOM NOT IN GROUP, KEEP IT
         IF (IATOMF.NE.0) GO TO 1650
         IF (IFLCMP.EQ.4) THEN
C----- FLAG IS 'AUGMENT', SO REMOVE FOUND ATOMS FROM GROUP
            IF (NLST.NE.0) THEN
               LL5=MLST
               DO 1600 J=1,NLST
                  LL5N=LL5+MDLST
                  CALL XMOVE (STORE(LL5N),STORE(LL5),MDLST)
                  LL5=LL5+MDLST
1600           CONTINUE
               NATMD=NATMD-1
            END IF
         ELSE
            GO TO 1700
         END IF
1650     CONTINUE
C -- COPY THE ATOM TO THE NEW LIST
         IADDR=KSTALL(MD5)
         CALL XMOVE (STORE(INDL5),STORE(IADDR),MD5)
C -- INCREMENT ATOM COUNT
         NNEWL5=NNEWL5+1
1700  CONTINUE
C --
C -- COPY ATOMS IN GROUP TO THE END OF THE NEW LIST 5
      IF (NATMD.GT.0) THEN
         ISIZE=MDATMD*NATMD
         IADDR=KSTALL(ISIZE)
         CALL XMOVE (STORE(LATMD),STORE(IADDR),ISIZE)
      END IF
C -- INCREASE NUMBER OF ATOMS
      NNEWL5=NNEWL5+NATMD
C----   COPY NEW LIST 5 OVER ORIGINAL LIST 5
      L5ITEM=NNEWL5*MDATMD
      CALL XMOVE (STORE(LNEWL5),STORE(L5),L5ITEM)
      NFL=L5+L5ITEM+1
      N5=NNEWL5
C 
C --  MODIFY LIST 5 DETAILS
      LN=5
      IREC=101
C -- LOCATE RECORD 101
      I=KHUNTR(LN,IREC,IADDL,IADDR,IADDD,0)
C -- CHANGE ADDRESS
      ISTORE(IADDR+3)=L5
C -- UPDATE RECORD HEADER
      CALL XUDRH (LN,IREC,0,N5)
C -- SET FLAG TO SHOW NEW LIST 5 IS TO BE PRODUCED
      NEWLIS=1
      GO TO 1800
1740  CONTINUE
CDJWMAY2001
C----- RENAME - NOTE OFFSET OF 4 ABOVE
c      DO  J = 1, NATMD
c         WRITE(CMON,'(2A,I5,A,I5)') 'In RENM: ',
c     1    STORE(LRENM+(J-1)*MDRENM),NINT(STORE(LRENM+(J-1)*MDRENM+1)),
c     2    STORE(LRENM+(J-1)*MDRENM+4),NINT(STORE(LRENM+(J-1)*MDRENM+5))
c          CALL XPRVDU(NCVDU,1,0)
c      END DO

      DO 1520 J = 1, NATMD
       DO 1748 I = 1,N5
         KTYPE = ISTORE(L5+(I-1)*MD5)
         KSERIL = NINT(STORE(L5+(I-1)*MD5+1))
         IF( KTYPE .NE. ISTORE(LRENM+(J-1)*MDRENM) ) GOTO 1748
         IF( KSERIL.NE. NINT(STORE(LRENM+(J-1)*MDRENM+1)) ) GOTO 1748
         CALL XMOVE (STORE(LRENM+(J-1)*MDRENM+4), STORE(L5+(I-1)*MD5),2)
         GOTO 1520 !Only match once.
1748    CONTINUE
1520  CONTINUE
C -- SET FLAG TO SHOW NEW LIST 5 IS TO BE PRODUCED
      NEWLIS=1
      GOTO 1800
1741  CONTINUE
C----- CAMERON - DO NOTHING
      GOTO 1800
C
1750  CONTINUE
C -- COMPARE ONLY
      GO TO 1800
1800  CONTINUE
C 
C -- FINISHED CALCULATION
      CALL XLINES
      WRITE (CMON,1850) CFUNC(NFUNC),IGRPNO
1850  FORMAT (1X,A,' of group number ',I3,' completed',/)
      CALL XPRVDU (NCVDU,2,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,1850) CFUNC(NFUNC),IGRPNO
1900  CONTINUE
C -- FINAL TIDY UP
C -- SET COUNTS TO ZERO
      NOLD=0
      NNEW=0
C----- DJWAPR01 - INDICATE THAT ATOMS HAVE BEEN PROCESSED
      NATMD=0
      RETURN
C 
C 
1950  CONTINUE
      WRITE (CMON,2000) NOLD
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
2000  FORMAT (' Too few old atom positions have been given -',I5)
      CALL XERHND (4)
      RETURN
2050  CONTINUE
      WRITE (CMON,2100) NNEW
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
2100  FORMAT (' Too few new atom positions have been given -',I5)
      CALL XERHND (4)
      RETURN
2150  CONTINUE
C 
C -- **** ERRORS ****
C 
      CALL XLINES
      WRITE (CMON,2200) IGRPNO
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
2200  FORMAT (1X,'Calculation abandoned for group number ',I3)
      GO TO 1800
C 
2250  CONTINUE
C -- INTERNAL ERROR
      CALL XOPMSG (IOPREG,IOPINT,0)
      GO TO 2150
C 
2300  CONTINUE
      WRITE (CMON,2350)
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
2350  FORMAT (1X,'Attempt to change undefined coordinates')
      CALL XERHND (IERERR)
      GO TO 2150
C 
      END
C
C
CODE FOR XRGCRD
      SUBROUTINE XRGCRD(RESULT,METHOD)
C -- SUBROUTINE TO CALCULATE A ROTATION DILATION MATRIX TO
C    MATCH THE COORDINATES (IN ORTHOGONAL COORDINATES ROTATED
C    TO INERTIAL SYSTEMS) AT STORE(LOLD) AND STORE(LNEW)
C    RESULT IS :-
C
C    ROTATION COMPONENT OF MATRIX, IF METHOD=1
C    ROTATION-DILATION MATRIX,     IF METHOD=2
C --
      DIMENSION RESULT(3,3)
      DIMENSION WSPAC1(3,3),WSPAC2(3,3),WSPAC3(3,3)
      DIMENSION ROTDIL(3,3),DILATN(3,3),ROTATN(3,3)
      DIMENSION VMAT(3,3),UMAT(3,3),UVEC(3)
      DIMENSION DILNEV(3), DETERM(3)
C --
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XRGLST
\QSTORE
\XIOBUF
C --
C --
      IF (ISSPRT .EQ. 0) WRITE (NCWU,1100)
1100  FORMAT ( 1X , 'Calculation of rotation-dilation matrix ' ,
     2 'and decomposition into component parts' , / )
C --
C -- CALCULATE ROTATION DILATION MATRIX
C --
C -- W1 = (NEW) * TRANSPOSE (NEW)
      CALL XRGMMT (STORE(LNEW),STORE(LNEW),WSPAC1(1,1),MDOLD,MDOLD,NOLD)
C -- W3 = (OLD) * TRANSPOSE (NEW)
      CALL XRGMMT (STORE(LOLD),STORE(LNEW),WSPAC3(1,1),MDOLD,MDNEW,NOLD)
C -- W2 = INVERSE (W1)
      CALL XMXMPI(WSPAC1(1,1),WSPAC2(1,1),3)
      IF (IERFLG.LT.0) RETURN
C------ ROTATION-DILATION MATRIX D = (W3) * (W2)
      CALL XMLTMM ( WSPAC3(1,1),WSPAC2(1,1),ROTDIL(1,1) , 3,3,3 )
C----- CHECK THAT THIS MATRIX IS PROPERLY DEFINED
C
      DET3 = XDETR3(ROTDIL)
      IF (ABS(ROTDIL(1,1)) .LE. 0.0001*NNEW) ROTDIL(1,1)=
     1 SQRT(1.-ROTDIL(1,2)*ROTDIL(1,2)-ROTDIL(1,3)*ROTDIL(1,3))
C
      IF (ABS(ROTDIL(2,2)) .LE. 0.0001*NNEW) THEN
        WRITE(CMON,1300) ROTDIL(2,2)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
1300    FORMAT(1X, 'One group is almost colinear - sigma(Y**2) = '
     1  ,F12.8)

c        ROTDIL(2,2)=SIGN( SQRT(1.-ROTDIL(2,1)*ROTDIL(2,1)-
c     1  ROTDIL(2,3)*ROTDIL(2,3)), ROTDIL(2,2))
C Sqrt may be negative above, try this instead:
        ROTDIL(2,2)=SIGN( SQRT(ABS(1.-ROTDIL(2,1)*ROTDIL(2,1)-
     1  ROTDIL(2,3)*ROTDIL(2,3))), ROTDIL(2,2))
      END IF
C
      IF (ABS(ROTDIL(3,3)) .LE. 0.0001*NNEW) THEN
        WRITE(CMON,1200) ROTDIL(3,3)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
1200    FORMAT(1X, 'One group is almost coplanar - sigma(Z**2) = '
     1  ,F12.8)
c        ROTDIL(3,3)= SQRT(1.-ROTDIL(3,1)*ROTDIL(3,1)-
c     1  ROTDIL(3,2)*ROTDIL(3,2))
c Sqrt may be negative, try this:
        ROTDIL(3,3)= SQRT(ABS(1.-ROTDIL(3,1)*ROTDIL(3,1)-
     1  ROTDIL(3,2)*ROTDIL(3,2)))
        DETR = XDETR3(ROTDIL)
        IF ( SIGN(1., DET3*DETR) .LT. 0.) ROTDIL(3,3) = -ROTDIL(3,3)
      END IF
C
C -- DECOMPOSE ROTATION-DILATION MATRIX INTO DILATION AND ROTATION
C    COMPONENTS
C
C --
C------ FORM D'D
      CALL XMLTTM ( ROTDIL(1,1),ROTDIL(1,1),WSPAC1(1,1) , 3,3,3 )
C----- EXTRACT U AND V
      CALL XMXEGV (WSPAC1(1,1),VMAT(1,1),UVEC(1))
C -- CHANGE ORDER
C -- INTERCHANGE COLUMNS 1 AND 3 SO THAT EIGENVALUES
C    ARE IN DESCENDING ORDER
      CALL XINT2 (3,VMAT(1,1),9,UVEC(1),3,1,3,1)
C -- CALCULATE SQUARE ROOTS OF EIGENVALUES
      DO 7100 I=1,3
C -- IF UVEC(I) IS CLOSE TO ZERO THEN DO NOT ATTEMPT SQUARE ROOT
      IF (UVEC(I)) 7100,7100,7050
7050  CONTINUE
      UVEC(I)=SQRT(UVEC(I))
7100  CONTINUE
      CALL XMXMFV (UVEC(1),UMAT(1,1),3)
C----- CALCULATE DILATION MATRIX (T)
C    DILATION MATRIX = V*U*TRANSPOSE(V)
      CALL XMLTMT (UMAT(1,1),VMAT(1,1),WSPAC2(1,1),3,3,3)
      CALL XMLTMM (VMAT(1,1),WSPAC2(1,1),DILATN(1,1),3,3,3)
C
C
C -- CALCULATE ROTATION COMPONENT
C
C    (W3) = INVERSE ( DILATION )
C    ( ROTATION ) = ( ROTATION-DILATION ) * ( W3 )
      CALL XMXMPI ( DILATN(1,1) , WSPAC3(1,1) , 3 )
      IF ( IERFLG .LT. 0 ) RETURN
      CALL XMLTMM ( ROTDIL(1,1),WSPAC3(1,1),ROTATN(1,1) , 3,3,3 )
C
C
C -- CALCULATE EIGENVALUES AND VECTORS OF CALCULATED MATRICES
      CALL XMXEGV ( DILATN(1,1) , WSPAC1(1,1) , DILNEV(1) )
C
C -- DISPLAY RESULTS OF CALCULATION
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 3005 )
      ENDIF
3005  FORMAT ( 1X , /18X ,
     2 'Rotation dilation matrix            ' ,
     3 'Dilation component                  ' ,
     4 'Rotation component                  '/ )
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 3015 ) (
     2 ( ROTDIL(I,J) , I=1,3 ) ,
     3 ( DILATN(I,J) , I=1,3 ) ,
     4 ( ROTATN(I,J) , I=1,3 ) , J=1,3 )
      ENDIF
3015  FORMAT ( 3 ( 1X , 15X , 3 ( 3F10.5 , 5X ) , / ) )
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 3025 )
      ENDIF
3025  FORMAT (1X , 'Eigenvalues' )
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3030) DILNEV
      ENDIF
3030  FORMAT(1X,15X , 35X, 3F10.5  )
      CALL XTRANS(WSPAC1(1,1),WSPAC2(1,1),3,3)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3040)
      ENDIF
3040  FORMAT(1X, 'Eigenvectors')
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3030) WSPAC2
      ENDIF
C----- DETERMINANTS
      DETERM(1)=XDETR3(ROTDIL)
      DETERM(2)=XDETR3(DILATN)
      DETERM(3)=XDETR3(ROTATN)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3050)
      ENDIF
3050  FORMAT(1X, 'Determinants')
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3060) DETERM
      ENDIF
3060  FORMAT(1X,15X,3(10X,F10.5,15X),//)
C
C
C -- COPY RESULT MATRIX TO APPROPRIATE PLACE
C
      IF ( METHOD .EQ. 1 ) CALL XMOVE ( ROTATN(1,1) , RESULT(1,1) ,9 )
      IF ( METHOD .EQ. 2 ) CALL XMOVE ( ROTDIL(1,1) , RESULT(1,1) ,9 )
C
C -- FINISHED
      RETURN
      END
C
C --
C
CODE FOR XRGCKB
      SUBROUTINE XRGCKB(RESULT)
      DIMENSION RESULT(3,3)
      DIMENSION WSPAC1(3,3),WSPAC2(3,3),WSPAC3(3,3)
      DIMENSION VMAT(3,3),UVEC(3)
      DIMENSION SIG(3)
C --
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XRGLST
\QSTORE
C --
      IF (ISSPRT .EQ. 0) THEN
      WRITE (NCWU,1500)
      ENDIF
1500  FORMAT (' Calculation of rotation matrix by Kabsch method  ',//)
C --
      DO 1600 I=1,3
      SIG(I)=1.0
1600  CONTINUE
      E0=0.
      DO 2000 I=1,NATMD
      INDOLD=LOLD+(I-1)*MDOLD
      INDNEW=LNEW+(I-1)*MDNEW
      W=STORE(INDOLD+3)
      E0=E0+W*(STORE(INDOLD)**2+STORE(INDOLD+1)**2+STORE(INDOLD+2)**2)
      E0=E0+W*(STORE(INDNEW)**2+STORE(INDNEW+1)**2+STORE(INDNEW+2)**2)
2000  CONTINUE
      CALL XRGMMT(STORE(LOLD),STORE(LNEW),WSPAC3(1,1),MDOLD,MDNEW,NOLD)
C -- R=TRANSPOSE OF THIS
      CALL XTRANS(WSPAC3(1,1),WSPAC1(1,1),3,3)
C -- T=TRANSPOSE(R)*R
      CALL XMLTTM (WSPAC1(1,1),WSPAC1(1,1),WSPAC2(1,1),3,3,3)
C -- U,V = EIGENVALUES,VECTORS OF T
      CALL XMXEGV(WSPAC2(1,1),VMAT(1,1),UVEC(1))
C -- CHANGE ORDER
C -- INTERCHANGE COLUMNS 1 AND 3 SO THAT EIGENVALUES
C    ARE IN DESCENDING ORDER
      CALL XINT2 (3,VMAT(1,1),9,UVEC(1),3,1,3,1)
C -- SET THIRD VECTOR TO CROSS PRODUCT OF OTHER TWO
      I=NCROP3 (VMAT(1,1),VMAT(1,2),VMAT(1,3))
C -- B=RV
      CALL XMLTMM(WSPAC1(1,1),VMAT(1,1),WSPAC3(1,1),3,3,3)
C -- NORMALISE B VECTORS AND FORM CROSS PRODUCT
      J=NORM3(WSPAC3(1,1))
      J=NORM3(WSPAC3(1,2))
      DETB=XDETR3(WSPAC3(1,1))
      IF (DETB.LT.0) SIG(3)=-1.
      I=NCROP3 (WSPAC3(1,1),WSPAC3(1,2),WSPAC3(1,3))
C -- U=B*TRANSPOSE(V)
      CALL XMLTMT (WSPAC3(1,1),VMAT(1,1),RESULT(1,1),3,3,3)
C -- CALCULATE E
      E=E0
      DO 2050 I=1,3
      IF (UVEC(I) .LT. 0.0001) GO TO 2050
      E=E-SIG(I)*UVEC(I)
2050  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 2105 ) RESULT
      ENDIF
2105  FORMAT ( 1X , 'Pure rotation matrix' , / ,
     2 3 ( 1X , 3F10.5 , / ) )
C
C
      RETURN
      END
C
C --
C
CODE FOR XRGGRP
      SUBROUTINE XRGGRP(ICODE)
C -- THIS SUBROUTINE PROCESSES A GROUP DIRECTIVE, SETTING THE NUMBER
C    OF ATOMS IN THE GROUP.
C    IT ALSO ALLOCATES SPACE IN STORE FOR THE NECESSARY BLOCKS
C    CONTAINING THE ATOM DEFINITIONS AND THE OLD AND NEW
C    COORDINATES.
C
C----- ICODE 1 = GROUP
C            2 = COMPUTE
C --
\XUNITS
\XSSVAL
\XRGCOM
\XRGLST
C --
C -- SET NUMBER OF ATOMS
      ZGRP=XLXRDV(100.)
C -- FIX THE NUMBER OF ATOMS TO BE READ
      NATMD=NINT(ZGRP)
C -- SET CURRENT NUMBER OF OLD AND NEW ATOMS TO 0
      NOLD=0
      NNEW=0
C -- SET UP BLOCKS
      LATMD=KSTALL(NATMD*MDATMD)
      LOLD=KSTALL(NATMD*MDOLD)
      LNEW=KSTALL(NATMD*MDNEW)
      LUIJ=KSTALL(NATMD*MDUIJ)
C -- INCREMENT GROUP SERIAL NUMBER
      IF (ICODE .EQ. 1) IGRPNO=IGRPNO+1
C -- SET REPLACE/COMPARE FLAG TO DEFAULT VALUE
      IFLCMP=ICMPDF
      RETURN
      END
C
C --
C
CODE FOR XRGPLA
      SUBROUTINE XRGPLA( PLATOM, NLATOM, XMATR)
C -- THIS SUBROUTINE IS USED TO DEFINE EACH NEW ATOM IN THE GROUP
C    PLATOM( ) CONTAINS THE DETAILS OF THE ATOM IN THE USUAL LIST 5
C    FORMAT. THE ROTATION MATRIX XMATR(9) IS APPLIED TO THE COORDINATES
C    A ORIGIN SHIFT AND GENERAL ROTATION MATRIX ARE ALSO APPLIED
      DIMENSION XMATR(9), PLATOM(NLATOM)
      DIMENSION TEMP(3)
\STORE
\XUNITS
\XSSVAL
\XRGCOM
\XRGLST
\XIOBUF
C --
C -- INCREMENT NEW ATOM COUNT
      NNEW=NNEW+1
CDJWAPR2001
      IF ((NATMD.NE.0) .AND. (NNEW.GT.NATMD)) GO TO 9500
C -- SET (TEMPORARILY) ORIGIN TO ZERO
      CALL XZEROF(ORIGIN(1),3)
C -- CALCULATE WHERE THIS ATOM IS GOING TO GO
      INDATM=LATMD+(NNEW-1)*MDATMD
      INDNEW=LNEW+(NNEW-1)*MDNEW
      INDUIJ=LUIJ+(NNEW-1)*MDUIJ
C -- COPY ATOM EXCEPT TYPE AND SERIAL
      CALL XMOVE( PLATOM(3), STORE(INDATM+2), NLATOM-2)
      CALL XMOVE( PLATOM(4), STORE(INDUIJ), 1)
      CALL XMOVE( PLATOM(8), STORE(INDUIJ+1), 6)
C -- APPLY REQUIRED MATRIX TO COORDINATES
      CALL XMLTMM (XMATR(1),PLATOM(5),TEMP(1),3,3,1)
C -- APPLY OFFSET TO COORDINATES
cdjwnov99      CALL XSUBTR (TEMP(1),ORIGIN(1),STORE(INDATM+5),3)
      CALL XSUBTR (TEMP(1),ORIGIN(1),STORE(INDATM+4),3)
C -- COPY COORDINATES TO APPROPRIATE PLACE
cdjwnov99      CALL XMOVE (STORE(INDATM+5),STORE(INDNEW),3)
      CALL XMOVE (STORE(INDATM+4),STORE(INDNEW),3)
C -- SET WEIGHT FOR THIS ATOM TO 1
      STORE(INDNEW+3)=1.
      RETURN
9500  CONTINUE
C -- ERROR
        WRITE(CMON,9510) NNEW
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9510  FORMAT ( ' Too many new atom positions have been given -',I5 )
      CALL XERHND(4)
      RETURN
      END
C
C --
C
CODE FOR XRGPLG
      SUBROUTINE XRGPLG(IATOMS,NATOMS,XSCALE,YSCALE,ZSCALE,SHIFT,ROTN)
C -- SUBROUTINE TO PLACE A GROUP OF NEW ATOMS
C    IATOMS CONTAINS LIST OF THE ATOM INDEXES REFERING TO
C    AN ARRAY GRPATM(3,NNNNN) IN COMMON BLOCK XRGGRP
C    NATOMS IS THE NUMBER OF ATOMS IN THE GROUP
C    XSCALE,YSCALE,ZSCALE ARE THE SCALE FACTORS APPLIED TO
C    X,Y,Z COORDINATES
C --
      DIMENSION IATOMS(NATOMS)
      DIMENSION SHIFT(3)
      DIMENSION ROTN(3)
\STORE
\XUNITS
\XSSVAL
\XLST01
\XRGCOM
\XRGRP
C --
C -- CALCULATE ROTATION MATRIX
      ITMP1=KSTALL(9)
      CALL XMXCRM(ROTN(1),STORE(ITMP1))
C -- ALLOCATE WORK SPACE FOR ATOM COORDINATES
      ITMP2=KSTALL(3)
      ITMP3=KSTALL(3)
cdjw nov99
      DO 4000 I=1,NATOMS
C -- MOVE COORDINATES FOR EACH ATOM AND THEN CREATE THE ATOM
      INDEXF=IATOMS(I)
C -- FOR EACH ATOM CALCULATE EACH COORDINATE IN TURN
      STORE(ITMP2) = GRPATM(1,INDEXF) * XSCALE
      STORE(ITMP2+1) = GRPATM(2,INDEXF) * YSCALE
      STORE(ITMP2+2) = GRPATM(3,INDEXF) * ZSCALE
C -- APPLY ROTATION TO ATOMS
      CALL XMLTMM(STORE(ITMP1),STORE(ITMP2),STORE(ITMP3),3,3,1)
C -- APPLY SHIFT
      CALL XADDR(STORE(ITMP3),SHIFT(1),ATOM(5),3)
      CALL XRGPLA (ATOM(1), NATOMP, STORE(L1O2) )
C -- CHECK FOR ERROR
      IF (IERFLG.LT.0) RETURN
4000  CONTINUE
C -- RELEASE SPACE
      CALL XSTRLL(ITMP1)
      RETURN
      END
C
C --
C
CODE FOR XRGRDA
      SUBROUTINE XRGRDA
C -- READ X,Y,Z COORDINATES. NO DEFAULTS ARE ALLOWED
\XUNITS
\XSSVAL
\XRGCOM
C --
      ATOM(5)=XLXRVN(98765.)
      ATOM(6)=XLXRVN(98765.)
      ATOM(7)=XLXRVN(98765.)
C -- PLACE THIS ATOM USING CURRENT COORDINATE SYSTEM
      CALL XRGPLA (ATOM(1), NATOMP, RGOM(1,1) )
      RETURN
      END
C
C --
C
CODE FOR XRGRDS
      SUBROUTINE XRGRDS (ICODE)
C -- SUBROUTINE TO READ ATOM SPECIFICATIONS
C -- ICODE    1    OLD ATOM SPECIFICATIONS ARE TO BE READ
C             2    NEW ATOM SPECIFICATIONS ARE TO BE READ
C --
C LRENM,MDRENM will contain the old atoms (MAP) followed by the
C new atoms (ONTO). In this routine, the type and serial are set.
C Form is:  0  TYPE  of old (ONTO) atom       NB. These aren't paired 
C           1  SERIAL of old (ONTO) atom          yet. Just two lists
C           2  TYPE of new (MAP) atom             held in the same 
C           3  SERIAL of new (MAP) atom.          vector.
C           4  L5 address of OLD, overwritten later if using for RENAME
C           5  L5 address of NEW, overwritten later if using for RENAME
C
      DIMENSION UNIT(3,3)
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XLISTI
\XLST05
\XLEXIC
\XRGCOM
\XRGLST
\QSTORE
\XIOBUF
CDJWapr2001
      MRENM = LRENM
      CALL XUNTM3 (UNIT(1,1)) !SET UNIT MATRIX
      LATMP=KSTALL(MD5)       !ALLOCATE WORK SPACE TO TEMPORARILY HOLD ATOMS
      L5SAVE=L5               !SAVE L5
      IADR=0     !SET ADDRESS FOR TEMPORARY STORAGE OF OLD ATOMS TO ZERO

1500  CONTINUE
      IF ( KOP(4).LE.0) GO TO 9000             !CHECK FOR END OF CARD OR '*'
      L5=0                  !SET L5 TO ZERO TO INHIBIT SEARCHES OF LIST 5
      I=KATOMU(LN)          !READ THE NEXT ITEM OF DATA AS AN UNTIL SEQUENCE
      IF (I) 9000,9800,3100 !CHECK FOR ERRORS IN ATOM SPECIFICATIONS

3100  CONTINUE                                !SPECIFICATION IS OK
      L5=L5SAVE                               !RESTORE L5
C -- SET ADDRESSES OF ATOM HEADERS
      IHEADA=MQ                               !FIRST ATOM HEADER IS AT MQ
C -- ASSUME NO UNTIL SEQUENCE, THEN SECOND ATOM HEADER IS THE SAME
C    AS FIRST
      IHEADB=IHEADA
C -- IF AN UNTIL SEQUENCE HAS BEEN GIVEN THEN SET SECOND ATOM HEADER
C    ADDRESS
      IF (ISTORE(IHEADA) .GT. 0) IHEADB=ISTORE(IHEADA)
C -- SET POINTERS TO LIST 5
      MLST5A=L5SAVE
      MLST5B=L5SAVE
      NLST5A=N5
      NLST5B=N5
C -- SEARCH FOR FIRST AND SECOND ATOMS IN LIST 5
      IA=KATOMF(STORE(IHEADA+2),MLST5A,NLST5A,MD5,0)
      IB=KATOMF(STORE(IHEADB+2),MLST5B,NLST5B,MD5,0)
      NATOMA=NLST5A-NLST5B+1          !CALCULATE NUMBER OF ATOMS IN SEQUENCE
      IF (IA) 3500,3700,3450          !BRANCH ON PRESENCE OF ATOMS IN LIST 5

3450  CONTINUE
      CALL XERHND(7)

3500  CONTINUE                           !FIRST ATOM NOT IN LIST 5
      IF (ICODE.NE.1) GO TO 9820         !ERROR IF NOT CONSIDERING OLD ATOMS
C -- IF SECOND ATOM IS IN LIST 5 THEN ERROR-MIXED SEQUENCES OF
C    ABSENT AND PRESENT ATOMS ARE NOT ALLOWED
      IF (IB) 3520,9810,3510
3510  CONTINUE
      CALL XERHND(7)
C -- IF TYPES OF FIRST AND SECOND ATOM ARE DIFFERENT THEN ERROR
3520  CONTINUE
      IF (ABS(STORE(IHEADA+2)-STORE(IHEADB+2)) .GT. 0.01 ) GO TO 9830
C -- CALCULATE NUMBER OF ATOMS TO BE CREATED
      NATOMA=NINT(STORE(IHEADB+3))-NINT(STORE(IHEADA+3))+1
      IF (NATOMA .LE. 0) GO TO 9840    !ERROR IF THIS NUMBER IS ZERO OR LESS
C -- CREATE ATOM NAME DETAILS
      CALL XSTRLL(IADR)                    !RELEASE PREVIOUS WORK SPACE
      IADR=KSTALL(NATOMA*2)                !GET NEW SPACE
CDJWMAY2001
      CALL XZEROF (STORE(IADR), 2*NATOMA)
      SERIAL=STORE(IHEADA+3)
      DO 3530 I=1,NATOMA
         INDEXF=IADR+(I-1)*2
         STORE(INDEXF)=STORE(IHEADA+2)
         STORE(INDEXF+1)=SERIAL
         SERIAL=SERIAL+1.
3530  CONTINUE
C -- SET DETAILS FOR CREATION OF ATOMS
      IADATM=IADR
      INCR=2
      WEIGHT=0.
      GO TO 4000                           !CREATE ATOMS

3700  CONTINUE
C -- FIRST ATOM FOUND IN LIST 5
C -- IF SECOND NOT FOUND THEN ERROR
      IF (IB) 9810,3720,3710
3710  CONTINUE
      CALL XERHND(7)
3720  CONTINUE
      IF (NATOMA.LE.0) GO TO 9840
C -- SET ADDRESSES
      IADATM=MLST5A
      INCR=MD5
      WEIGHT=1.
4000  CONTINUE                              !CREATE ATOMS
C -- ATOM CREATION
      IF (NATOMA .LE. 0) GO TO 9840         !CHECK FOR ONE OR MORE ATOMS

      DO 4900 I=1,NATOMA
C -- CHECK IF A VALID HEADER IS AVAILIBLE
         IF (NINT(WEIGHT)) 4030,4030,4020
4020     CONTINUE
         J=KATOMS(IHEADA,IADATM,LATMP)      !APPLY SYMMETRY
         IF (J) 9870,4030,4030
4030     CONTINUE
         GO TO (4400,4600), ICODE           !BRANCH ON OLD OR NEW ATOMS
         CALL XERHND(7)


4400     CONTINUE                           !OLD ATOMS
         NOLD=NOLD+1                        !INCREASE COUNT OF OLD ATOMS
CDHWAPR2001
C -- CHECK COUNT OF OLD ATOMS
         IF ((NATMD.NE.0) .AND. (NOLD.GT.NATMD)) GO TO 9850
C -- CALCULATE DESTINATIONS FOR THIS ATOM
         INDATM=LATMD+(NOLD-1)*MDATMD
         INDOLD=LOLD+(NOLD-1)*MDOLD
C -- CHECK IF AN ATOM WITH THIS SERIAL AND TYPE IS ALREADY IN THE LIST
C    IF NO ATOMS HAVE BEEN GIVEN BEFORE, SKIP THIS CHECK TO AVOID THE
C    CONSEQUENCES (I.E. FINDING ATOMS BELONGING TO PREVIOUS GROUP)
         IF (NOLD.LE.1) GO TO 4420
         MLST5=LATMD
         MDLST5 = MDATMD
C -- CHECK FOR EACH OLD ATOM SPECIFICATION GIVEN SO FAR
         NLST5=NOLD-1
         J=KATOMF(STORE(IADATM),MLST5,NLST5,MDLST5,0)
         IF (J) 4420,9860,4410
4410     CONTINUE
         CALL XERHND(7)

4420     CONTINUE                               !ATOM IS NOT IN LIST ALREADY
         CALL XZEROF(STORE(INDATM+4), MDATMD-4)     !CLEAR THE AREA
         CALL XMOVE(STORE(IADATM),STORE(INDATM),2)  !COPY SERIAL AND TYPE
CDJWAPR2001
         CALL XMOVE(STORE(IADATM),STORE(MRENM),2)
CRICJAN2003
         ISTORE(MRENM+4) = IADATM
         MRENM = MRENM + MDRENM
C -- COPY COORDINATES*WEIGHT
         CALL XMULTR(STORE(LATMP+4),WEIGHT,STORE(INDOLD),3)
         STORE(INDOLD+3)=WEIGHT             !SET WEIGHT
         GO TO 4800


4600     CONTINUE                           !NEW ATOMS
CDJWAPR2001
         CALL XMOVE(STORE(IADATM),STORE(MRENM+2),2)
         ISTORE(MRENM+5) = IADATM
         MRENM = MRENM + MDRENM
         CALL XRGPLA (STORE(LATMP), MDATMD, UNIT(1,1) ) !NEW ATOMS


4800     CONTINUE
         IADATM=IADATM+INCR               !SET ADDRESS OF NEXT ATOM
4900  CONTINUE

C -- REPEAT OPERATION FOR ANY SUBSEQUENT ATOM SPECIFICATIONS
      GOTO 1500

9000  CONTINUE
C -- THE NEXT ARGUMENT IS A STAR OR THIS IS THE END OF THE CARD
C    RELEASE WORK SPACE
      CALL XSTRLL(LATMP)
C -- RELEASE OLD ATOM SPACE
      CALL XSTRLL(IADR)
C -- RESTORE LIST 5
      L5=L5SAVE
      RETURN
9800  CONTINUE
        WRITE(CMON,9801)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9801  FORMAT (' Error -- not an valid atom specification')
      CALL XERHND(4)
      RETURN
9810  CONTINUE
        WRITE(CMON,9811)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9811  FORMAT (' Until specification mixes atoms in and not in list 5')
      CALL XERHND(4)
      RETURN
9820  CONTINUE
      CALL XMISL5 (1,0,IHEADA+2)
      CALL XERHND(4)
      RETURN
9830  CONTINUE
        WRITE(CMON,9831)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9831  FORMAT (' Atoms have different types')
      CALL XERHND(4)
      RETURN
9840  CONTINUE
        WRITE(CMON,9841)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9841  FORMAT (' Atoms appear to be out of sequence')
      CALL XERHND(4)
      RETURN
9850  CONTINUE
        WRITE(CMON,9851) NOLD
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9851  FORMAT (' Too many old atoms have been given -',I6)
      CALL XERHND(4)
      RETURN
9860  CONTINUE
        WRITE(CMON,9861)ISTORE(IADATM),NINT(STORE(IADATM+1))
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9861  FORMAT (' An atom with this type and serial already given - ',
     1 A4,I6)
      CALL XERHND(4)
      RETURN
9870  CONTINUE
        WRITE(CMON,9871)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9871  FORMAT (' Error in applying symmetry operation')
      CALL XERHND(4)
      RETURN
      END
C
C --
C
CODE FOR XRGPCS
      SUBROUTINE XRGPCS ( ICODE , IHDR )
C
C -- PRINT THE STORED COORDINATED DATA POINTED TO BY LOLD AND LNEW
C
C      VALUES FOR ICODE :-
C
C            1            PRINT COORDINATES
C            2            PRINT DEVIATIONS ( FOR ATOMS FOR WHICH THIS
C                           QUANTITY IS DEFINED )
C
C      VALUES FOR IHDR :-
C
C            0            NO HEADER
C            1            ORIGINAL COORDINATES
C            2            COORDINATES IN BEST PLANES FOR GROUP
C            3            FITTED COORDINATES
C            4            FINAL COORDINATES
C
C
      CHARACTER*12 PRTTYP(2)
      CHARACTER*24 PRTUNT(2)
c      CHARACTER*21 CAMATM
C
      DIMENSION DELTA(5)
      DIMENSION SUM(4)
      DIMENSION RMSDEV(4)
      DIMENSION JFRN(4,2)
C
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XRGCOM
\XRGLST
\XCONST
\XERVAL
\XOPVAL
\XIOBUF
\XLST05
C
\QSTORE
C
      DATA MAXCOD / 2 / , MAXHDR / 4 /
      DATA PRTTYP(1) / 'Coordinates ' / , PRTTYP(2) / 'Deviations  ' /
      DATA PRTUNT(1) / ' ( Crystal fractions )  ' /
      DATA PRTUNT(2) / ' ( Angstrom )           ' /
      DATA JFRN /'F', 'R', 'N', '1', 'F', 'R', 'N', '2'/
C
C
C -- CHECK INPUT VALUES
C
      IF ( ICODE .LE. 0 ) GO TO 9910
      IF ( ICODE .GT. MAXCOD ) GO TO 9910
      IF ( IHDR .LT. 0 ) GO TO 9910
      IF ( IHDR .GT. MAXHDR ) GO TO 9910
C
      CALL XZEROF ( SUM(1) , 4 )
      RADIUS = 0.0
C
C -- PRINT HEADER
C
      IF ( IHDR .LE. 0 ) GO TO 1900
C
      GO TO ( 1100 , 1200 , 1300 , 1400 , 9910 ) , IHDR
      GO TO 9910
C
1100  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1105 ) PRTTYP(ICODE) , PRTUNT(1)
      ENDIF
1105  FORMAT ( 1X , A12 , 'in crystal system' , A24 )
      GO TO 1700
1200  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1205 ) PRTTYP(ICODE) , PRTUNT(2)
      ENDIF
1205  FORMAT ( 1X , A12 , 'in best plane system before fitting' , A24 )
      GO TO 1700
1300  CONTINUE
      WRITE ( CMON , 1305 ) PRTTYP(ICODE) , PRTUNT(2)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
1305  FORMAT ( 1X , A12 , 'in best plane system after fitting' , A24 )
      GO TO 1700
1400  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1405 ) PRTTYP(ICODE) , PRTUNT(1)
      ENDIF
1405  FORMAT ( 1X , A12 , 'in crystal system after fitting' , A24 )
      GO TO 1700
C
C
1700  CONTINUE
C -- WRITE NEXT LINE FOR EITHER COORDINATES OR DEVIATIONS
      GO TO ( 1710 , 1720 , 9910 ) , ICODE
      GO TO 9910
C
1710  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1715 )
      ENDIF
1715  FORMAT ( 1X , 44X , 'Old' , 35X , 'New'  , / ,
     2 1X ,'Position' , 5X ,'Type   Serial   ' ,
     3 2 ( 5X , 'x' , 9X , 'y' , 9X , 'z' , 9X ) )
      GO TO 1900
C
1720  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1725 )
      ENDIF
1725  FORMAT ( /,1X , 'Position' , 2X , 'Type  Serial' ,4X,
     2 'old(x)',2X,'old(y)',2X, 'old(z)',7X, 'new(x)',2X,
     3 'new(y)',2X,'new(z)', 8X,'d(x)',4X,'d(y)',4X,'d(z)',
     4 7X,'Distance',4X,'Angle',/)
      GO TO 1900
C
1900  CONTINUE
C

c      IPUNCH = 1
c
c      IF ( IPUNCH .EQ. 1 ) THEN
c        CALL XRDOPN ( 5 , JFRN(1,1) , 'CAMERON.INI', 11)
c        WRITE(NCFPU1,1002)
c1002    FORMAT('$DATA'/'CELL    1.0000    1.0000    1.0000    90.000
c     1 90.000    90.000'/'LIST5'/'REGULAR.L5I'/'$SYMM'/'NOCEN'/'$')
c        CALL XRDOPN ( 7 , JFRN(1,1) , 'CAMERON.INI', 11)
c        CALL XRDOPN ( 5 , JFRN(1,1) , 'REGULAR.L5I', 11)
c        WRITE(NCFPU1,1003)
c1003    FORMAT('#'/'#  Written out from REGULARISE COMPARE'/'#'/
c     1  '#LIST      5')
c        WRITE(NCFPU1,1000)NOLD*2,0,0,0
c1000    FORMAT(13HREAD NATOM = ,I6,11H, NLAYER = ,I4,13H, NELEMENT = ,
c     2  I4, 11H, NBATCH = ,I4)
c        WRITE(NCFPU1,1050) STORE(L5O),STORE(L5O+1),STORE(L5O+2),
c     1  STORE(L5O+3),STORE(L5O+4),STORE(L5O+5)
c1050    FORMAT(8HOVERALL ,F11.6,4(1X,F9.6),1X,F17.7)
c        CALL XRDOPN ( 5 , JFRN(1,2) , 'REGULAR.OBY', 11)
c        WRITE(NCFPU2,'(''DEFGROUP REG1 ATOMS'')')
c        DO I=1,NOLD
c         INDATM=LATMD+MDATMD*(I-1)
c         WRITE(CAMATM,'(A,I5)')ISTORE(INDATM),NINT(STORE(INDATM+1))
c         CALL XCRAS(CAMATM,LCAMA)
c         WRITE(NCFPU2,'(A)')CAMATM
c        END DO
c        WRITE(NCFPU2,'(''DEFGROUP REG2 ATOMS'')')
c        DO I=1,NOLD
c         INDATM=LATMD+MDATMD*(I-1)
c         WRITE(CAMATM,'(A,I5)')ISTORE(INDATM),1000+NINT(STORE(INDATM+1))
c         CALL XCRAS(CAMATM,LCAMA)
c         WRITE(NCFPU2,'(A)')CAMATM
c        END DO
c        WRITE(NCFPU2,'(''COLO GROUP REG1 BLUE COLO GROUP REG2 RED'')')
c        CALL XRDOPN ( 7 , JFRN(1,2) , 'REGULAR.OBY', 11)
c      ENDIF


      DO 2000 I=1,NOLD
        INDOLD=LOLD+MDOLD*(I-1)
        INDNEW=LNEW+MDNEW*(I-1)
        INDATM=LATMD+MDATMD*(I-1)

C -- PRINT APPROPRIATE DATA
        IF ( ICODE .EQ. 1 ) THEN
          IF (ISSPRT .EQ. 0) THEN
            WRITE ( NCWU , 2005 ) I, (STORE(J),J=INDATM,INDATM+1),
     2      (STORE(J),J=INDOLD,INDOLD+2),(STORE(J),J=INDNEW,INDNEW+2)
          ENDIF
2005      FORMAT ( 1X, I8, 5X, A4, 3X, F6.0, 3X, 3F10.4, 5X, 3F10.4 )
        ELSE IF ( ICODE .EQ. 2 ) THEN
          IF ( ABS ( STORE(INDOLD+3) ) .LE. ZERO ) THEN
            IF (ISSPRT .EQ. 0) THEN
               WRITE ( NCWU , 2015 ) I, (STORE(J), J=INDATM,INDATM+1),
     2         (STORE(J),J=INDOLD,INDOLD+2),(STORE(J),J=INDNEW,INDNEW+2)
            ENDIF
            GO TO 2020
          ELSE
            DISTSQ = 0.
            DO 2010 J = 1 , 3
               DELTA(J) = STORE(INDNEW+J-1) - STORE(INDOLD+J-1)
               DELTSQ = DELTA(J) ** 2
               SUM(J) = SUM(J) + DELTSQ
               DISTSQ = DISTSQ + DELTSQ
               RBAR=0.5*(STORE(INDNEW+J-1)+STORE(INDOLD+J-1))
               RADIUS=RADIUS+RBAR*RBAR
2010        CONTINUE
            DELTA(4) = SQRT ( DISTSQ )
            RADIUS=SQRT(RADIUS)
            DELTA(5)=RTD*ATAN2(DELTA(4),RADIUS)
            IF (ISSPRT .EQ. 0) THEN
               WRITE ( NCWU , 2015 ) I ,(STORE(J),J=INDATM,INDATM+1),
     2         (STORE(J),J=INDOLD,INDOLD+2),
     3         (STORE(J),J=INDNEW,INDNEW+2), DELTA
            ENDIF
          ENDIF

c          IF ( IPUNCH .EQ. 1 ) THEN
c            WRITE(NCFPU1,2016) (STORE(J),J=INDATM,INDATM+3),
c     1      (STORE(J),J=INDOLD,INDOLD+2),
c     2      (STORE(J),J=INDATM+7,INDATM+13),
c     3      1,(ISTORE(J),J=INDATM+15,INDATM+17)
c            WRITE(NCFPU1,2016) STORE(INDATM),STORE(INDATM+1)+1000.0,
c     1      STORE(INDATM+2),STORE(INDATM+3),
c     2      (STORE(J),J=INDNEW,INDNEW+2),
c     3      (STORE(J),J=INDATM+7,INDATM+13),
c     4      2,(ISTORE(J),J=INDATM+15,INDATM+17)
c         END IF

2015     FORMAT ( 1X,2X,I4, 4X,A4,2X, F6.0,2X, 4(3F8.3,5X))
2016     FORMAT
     1   ('ATOM ',A4,1X,6F11.6/
     2    'CON U[11]=',6F11.6/
     3    'CON SPARE=',F11.2,3I11,7X,A4)
2020     CONTINUE
      ELSE
            GO TO 9910
      ENDIF
C
C
2000  CONTINUE


c      IF ( IPUNCH .EQ. 1 ) THEN
cC Don't bother with element, layer scales etc. Punch End:
c        WRITE(NCFPU1,'(''END''/''#USE LAST'')')
c        CALL XRDOPN ( 7 , JFRN(1,1) , 'regular.l5i', 11)
c      END IF

C -- CHECK IF PRINT OF DEVIATIONS IS REQUIRED
C
      IF ( ICODE .EQ. 2 ) THEN
C
C -- CALCULATE TOTAL SQUARED DEVIATION AND RMS DEVIATIONS
C
            SUM(4) = SUM(1) + SUM(2) + SUM(3)
            SUMDEV  = SUM(4)/FLOAT(NATMD)
C
            DO 2500 I = 1,4
            RMSDEV(I) = SQRT ( SUM(I)/FLOAT(NATMD) )
2500        CONTINUE
C
      IF (ISSPRT .EQ. 0) THEN
            WRITE ( NCWU , 2505 ) SUM , RMSDEV
      ENDIF
2505  FORMAT ( // ,
     2 1X,53X , 'Total squared deviations     ' , 3F8.3 ,
     3 1X , 'Total' , F8.3 , / ,
     4 1X,53X , 'RMS deviations               ' , 3F8.3 ,
     5 2X , 'Mean' , F8.3 )
            WRITE ( CMON , 1727 )
            CALL XPRVDU(NCVDU, 1,0)
1727        FORMAT ( 23X ,
     2      6X,'d(x)',4X,'d(y)',4X,'d(z)',
     4      9X,'Distance')
            WRITE ( CMON , 2506 ) SUM , RMSDEV
            CALL XPRVDU(NCVDU, 2,0)
2506  FORMAT (
     2 1X , 'Total squared deviations' , 3F8.3 ,
     3 1X , 'Total' , F8.3 , / ,
     4 1X , 'RMS deviations          ' , 3F8.3 ,
     5 2X , 'Mean' , F8.3 )

            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(8(A,F9.4))')
     1       (CHAR(9),SUM(I),I=1,4),(CHAR(9),RMSDEV(I),I=1,4)
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
C
      ENDIF
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9010 )
      ENDIF
9010  FORMAT (//)
      RETURN
C
9910  CONTINUE
      CALL XOPMSG ( IOPREG , IOPINT , 0 )
      RETURN
      END
C
C --
C
CODE FOR XRGMMT
      SUBROUTINE XRGMMT(ATOMS1,ATOMS2,RESULT,MDATM1,MDATM2,NATM)
C -- FORMS ATOMS1 MULTIPLIED BY TRANSPOSE (ATOMS2)
C    ATOMSN(MNATMN,NATM) CONTAINS
C    ITEM 1: X
C    ITEM 2: Y
C    ITEM 3: Z
C    ITEM 4-MDATMN: ANYTHING
C    FOR EACH OF THE NATM ATOMS
C    EACH CONTRIBUTION IS WEIGHTED BY WEIGHT FOR OLD ATOM
C --
      DIMENSION ATOMS1(MDATM1,NATM)
      DIMENSION ATOMS2 (MDATM2,NATM)
      DIMENSION RESULT (3,3)
C --
\STORE
\XRGLST
      DO 1000 I=1,3
      DO 2000 J=1,3
      RESULT(I,J)=0.
      DO 3000 K=1,NATM
C -- CALCULATE EACH ITEM APPLYING APPROPRIATE WEIGHT TO OLD ATOM
C -- CALCULATE WEIGHTING TERM FOR THIS PAIR OF VECTORS
      INDOLD=LOLD+(K-1)*MDOLD
      WTERM=STORE(INDOLD+3)
C -- CALCULATE CONTRIBUTION FROM THIS PAIR OF VECTORS,APPROPRIATELY
C    WEIGHTED
      RESULT(I,J)=RESULT(I,J)+ATOMS1(I,K)*ATOMS2(J,K)*WTERM
3000  CONTINUE
2000  CONTINUE
1000  CONTINUE
      RETURN
      END
C
C --
C
CODE FOR XRGRCS
      SUBROUTINE XRGRCS
C -- SUBROUTINE TO READ COORDINATE SYSTEM
\STORE
\XLST01
\XRGCOM
\XCONST
\XUNITS
\XIOBUF
\XSSVAL
C --
C -- ALLOCATE SPACE TO READ IN DATA
      ITMP1=KSTALL(6)
C -- ALLOCATE SPACE TO HOLD INTERMEDIATE MATRIX
      ITMP2=KSTALL(9)
      DO 2000 I=ITMP1,ITMP1+2
      STORE(I)=XLXRDV(1.)
2000  CONTINUE
C -- READ ANGLES
      DO 2050 I=ITMP1+3,ITMP1+5
      STORE(I)=XLXRDV(90.)*DTR
2050  CONTINUE
C----- COMPUTE GAMMA*
      TEMP = (SIN(STORE(ITMP1+3))*SIN(STORE(ITMP1+4)))
      IF (TEMP .LE. ZERO) THEN
          WRITE ( CMON, 2052)
          CALL XPRVDU(NCVDU, 1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU,2052)
2052  FORMAT( ' Angles not correctly specified on SYSTEM card')
          GOTO 2060
      ENDIF
      TEMP = (COS(STORE(ITMP1+3))*COS(STORE(ITMP1+4)) -
     1 COS(STORE(ITMP1+5)))/ TEMP
      STORE(ITMP1+5) = ACOS(TEMP)
C -- CALCULATE ORTHOGONALISATION MATRIX
      CALL XMXCLO(STORE(ITMP1),STORE(ITMP2))
      CALL XMLTMT ( STORE(L1O2) , STORE(ITMP2) , RGOM , 3 , 3 , 3 )
2060  CONTINUE
C -- RELEASE WORK SPACE
      CALL XSTRLL(ITMP1)
      RETURN
      END
C
C --
C
CODE FOR XRGSMD
      SUBROUTINE XRGSMD(IVALUE)
\XUNITS
\XSSVAL
\XRGCOM
\XIOBUF
C --
      IMETHD=IVALUE
      IF ( IMETHD.LT.0 ) GO TO 9800
      IF ( IMETHD.EQ.0 ) GO TO 9900
      IF ( IMETHD.GT.3 ) GO TO 9800
      RETURN
9800  CONTINUE
        WRITE(CMON,9810)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9810  FORMAT ( ' Method number is not in allowed range ')
9900  CONTINUE
C -- SET DEFAULT METHOD NUMBER
      IMETHD = 1
        WRITE(CMON,9910)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') CMON(1)
9910  FORMAT (' Method set to default value')
      RETURN
      END
C
C --
C
CODE FOR XRGCNT
      SUBROUTINE XRGCNT (CENT,A,B,MDA,MDB,NAB )
      DIMENSION A(MDA,NAB)
      DIMENSION B(MDB,NAB)
      DIMENSION CENT(3)
C --
      CALL XZEROF(CENT(1),3)
      SW = 0
      DO 3000 I=1,NAB
      W=B(4,I)
      SW=SW+W
      DO 2500 J=1,3
      CENT(J)=CENT(J)+A(J,I)*W
2500  CONTINUE
3000  CONTINUE
      DO 4000 J=1,3
      CENT(J)=CENT(J)/SW
4000  CONTINUE
      RETURN
      END
C
CODE FOR XRGRNM
      SUBROUTINE XRGRNM
C 
C -- RENAME THE 'OLD' 'TARGET' 'ONTO' ATOMS BASED ON THE
C    MAMES OF THE 'NEW' 'IDEAL' 'MAP' ATOMS
C
C   LNEW, start of new or map atoms:  MDNEW = 4: X Y Z W
C   LOLD, start of old or onto atoms: MDOLD = 4: X Y Z W
C   LRENM, start of rename list: 0 onto type
C                                1 onto serial
C                                2 map type
C                                3 map serial
C                                4 renamed type
C                                5 renamed serial
C
C 
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XRGCOM
\XRGLST
\XCONST
\XERVAL
\XOPVAL
\XIOBUF
C 
\QSTORE
      WRITE(CMON,'(A,f6.1)') 'Offset = ', zorig
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      IF(SUMDEV .GE. 0.1)THEN
       NUMDEV =NUMDEV +1
       WRITE(CMON,'(A)') 'WARNING - poor initial fit' 
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU,1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      ENDIF

      WRITE(CMON,'(1X,A,7X,A,8X,A,6X,A)')
     1 'Mapping','onto','giving', 'distance'
      IF(SUMDEV .GE. 0.1) CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
C 
      IF (NOLD.LE.0) GO TO 200

C Could do better here:
C * Don't match same atom twice (use an N5 vector to store
C   ones that are already matched.
C * Give extra weight to matches of the same type of atom,
C   say a factor of 5 (may not be available.)
C * Optionally only match atoms with matching SPARE values (though
C   I think this info is lost by now.)
C We might be able to store an L5 pointer in LOLD and LATMD, or -1
C if they come from a SYSTEM / HEXAGON type directive.
      DO 150 I=1,NOLD
         INDOLD=LOLD+MDOLD*(I-1)
         INDATM=LATMD+MDATMD*(I-1)
         DISMIN=1000000.
         INDDIS=1
         DO J=1,NOLD
           INDNEW=LNEW+MDNEW*(J-1)
           DISTSQ=0.
C Only consider atom if it has not been matched already:
           IF ( STORE(LRENM+(J-1)*MDRENM+3) .NE. 0.0 ) THEN
             DO K=1,3
                DELTA=STORE(INDNEW+K-1)-STORE(INDOLD+K-1)
                DELTSQ=DELTA**2
                DISTSQ=DISTSQ+DELTSQ
             END DO
             IF (DISTSQ.LT.DISMIN) THEN
                DISMIN=DISTSQ
                INDDIS=J
             END IF
           END IF
         END DO
         J = INDDIS
         STORE(LRENM+(I-1)*MDRENM+4) = STORE(LRENM+(J-1)*MDRENM+2)
         STORE(LRENM+(I-1)*MDRENM+5) = STORE(LRENM+(J-1)*MDRENM+3)+ZORIG

        WRITE(CMON,
     1 '( A4,F6.1,3X,A4,F6.1,3X,A4,F6.1,3X,F7.4)')
     1   STORE(LRENM+(J-1)*MDRENM+2),STORE(LRENM+(J-1)*MDRENM+3),
     2   STORE(LRENM+(I-1)*MDRENM),  STORE(LRENM+(I-1)*MDRENM+1),
     3   STORE(LRENM+(I-1)*MDRENM+4),STORE(LRENM+(I-1)*MDRENM+5),
     4   DISMIN
         CALL XPRVDU(NCVDU,1,0)
         IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
C Indicate atom not to be matched again:
         STORE(LRENM+(J-1)*MDRENM+3) = 0.0 
150   CONTINUE
C 
      RETURN
C 
200   CONTINUE
      CALL XOPMSG (IOPREG,IOPINT,0)
      RETURN
      END

CODE FOR XRGMAT
      SUBROUTINE XRGMAT(LSPARE)
C 
C -- MATCH THE 'ONTO' TO 'MAP' ATOMS TO IMPROVE THE ACCURACY OF THE MATCH
C Reorder LMAP atoms.
C
C   LSPARE - 0=nothing, 1=match SPARE values as well.
C
C   LNEW, start of new or map atoms:  MDNEW = 4: X Y Z W
C   LOLD, start of old or onto atoms: MDOLD = 4: X Y Z W
C   LRENM, start of rename list: 0 onto type
C                                1 onto serial
C                                2 map type
C                                3 map serial
C                                4 renamed type
C                                5 renamed serial
C 
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XRGCOM
\XRGLST
\XCONST
\XLST05
\XERVAL
\XOPVAL
\XIOBUF
\XMATCH
\XDSTNC
C
\QSTORE
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      IF(SUMDEV .GE. 0.1)THEN
       NUMDEV =NUMDEV +1
       WRITE(CMON,'(A)') 'WARNING - poor initial fit' 
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU,1,0)
       CALL OUTCOL(1)

       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      ENDIF

      LMBUF = KSTALL ( MDATVC )
      LNBUF = KSTALL ( MDNEW )
c      LRBUF = KSTALL ( MDRENM )

      WRITE(CMON,'(1X,A,7X,A,8X,A,6X,A)')
     1 'Improving','onto','giving', 'distance'
      CALL XPRVDU(NCVDU,1,0)
 
      IF (NOLD.LE.0) GO TO 200

C * Optionally only match atoms with matching SPARE values (though
C   I think this info is lost by now.)

      DO I=0,NOLD-1                     !Loop over old atoms.
         INDOLD=LOLD+MDOLD*I            !Address of XYZold
         IOLD5 = L5 + (ISTORE(LONTO+I*MDATVC)) * MD5
         DISMIN=1000000.            !Initialise
         INDDIS=-1

c         WRITE(CMON,'(A,A4,3I9)')'Old atom: ',ISTORE(IOLD5),
c     1   NINT(STORE(IOLD5+1)),NINT(STORE(IOLD5+13)), LSPARE
c          CALL XPRVDU(NCVDU,1,0)

         DO J=I,NNEW-1                      !Loop over unmatched new atoms.
           INDNEW=LNEW+MDNEW*J            !Address of XYZnew
           INEW5 = L5 + (ISTORE(LMAP+J*MDATVC)) * MD5

c           WRITE(CMON,'(A,A4,2I9)')'New atom: ',ISTORE(INEW5),
c     1   NINT(STORE(INEW5+1)),NINT(STORE(INEW5+13))
c           CALL XPRVDU(NCVDU,1,0)

           DISTSQ=0.
C Only consider atom if spare matches when LSPARE is one.
           IF ( (LSPARE.EQ.0) .OR. ( (LSPARE.EQ.1) .AND.
     1          (NINT(STORE(INEW5+13)).EQ.NINT(STORE(IOLD5+13)))))THEN
             DO K=1,3
               DELTA=STORE(INDNEW+K-1)-STORE(INDOLD+K-1)
               DELTSQ=DELTA**2
               DISTSQ=DISTSQ+DELTSQ
             END DO

c           WRITE(CMON,'(A,A4,2I9,F15.8)')'Match: ',ISTORE(INEW5),
c     1   NINT(STORE(INEW5+1)), J, DISTSQ
c           CALL XPRVDU(NCVDU,1,0)

             IF (DISTSQ.LT.DISMIN) THEN
               DISMIN=DISTSQ
               INDDIS=J
             END IF
           END IF
         END DO

         J = INDDIS

C Swap atoms at LNEW(I) and LNEW(J)
C Swap atoms at LMAP(I) and LMAP(J)
C Swap atoms at LRENM(I) and LRENM(J)

         IF ( J .GE. 0 ) THEN

          CALL XMOVE(STORE(LNEW+MDNEW*I),STORE(LNBUF),MDNEW)
          CALL XMOVE(STORE(LNEW+MDNEW*J),STORE(LNEW+MDNEW*I),MDNEW)
          CALL XMOVE(STORE(LNBUF),STORE(LNEW+MDNEW*J),MDNEW)

          CALL XMOVE(STORE(LMAP+MDATVC*I),STORE(LMBUF),MDATVC)
          CALL XMOVE(STORE(LMAP+MDATVC*J),STORE(LMAP+MDATVC*I),MDATVC)
          CALL XMOVE(STORE(LMBUF),STORE(LMAP+MDATVC*J),MDATVC)

          IOLD5 = L5 + (ISTORE(LONTO+I*MDATVC)) * MD5
          INEW5 = L5 + (ISTORE(LMAP+I*MDATVC)) * MD5

          STORE(LRENM+I*MDRENM+4) = STORE(INEW5)
          STORE(LRENM+I*MDRENM+5) = STORE(INEW5+1)+ZORIG


          WRITE(CMON,
     1    '( A4,I4,I10,3X,A4,I4,I10,3X,F7.4)')
     1    STORE(IOLD5),NINT(STORE(IOLD5+1)),NINT(STORE(IOLD5+13)),
     2    STORE(INEW5),NINT(STORE(INEW5+1)),NINT(STORE(INEW5+13)),DISMIN
          CALL XPRVDU(NCVDU,1,0)

         ELSE

          WRITE(CMON,'(A)') '{E Programming error. No match found for:'
          CALL XPRVDU(NCVDU,1,0)
          WRITE(CMON,'( A4,2F6.1)')
     1    STORE(IOLD5),STORE(IOLD5+1),STORE(IOLD5+13)
          CALL XPRVDU(NCVDU,1,0)
          GOTO 200
         END IF
      END DO
      RETURN
 
200   CONTINUE
      CALL XOPMSG (IOPREG,IOPINT,0)
      RETURN
      END

CODE FOR XRGCAM
      SUBROUTINE XRGCAM
C 
C -- RENAME THE 'OLD' 'TARGET' 'ONTO' ATOMS BASED ON THE
C    MAMES OF THE 'NEW' 'IDEAL' 'MAP' ATOMS
C
C   LNEW, start of new or map atoms:  MDNEW = 4: X Y Z W
C   LOLD, start of old or onto atoms: MDOLD = 4: X Y Z W
C   LRENM, start of rename list: 0 onto type
C                                1 onto serial
C                                2 map type
C                                3 map serial
C                                4 renamed type
C                                5 renamed serial
C
C 
\ISTORE
\STORE
\XUNITS
\XSSVAL
\XRGCOM
\XRGLST
\XCONST
\XERVAL
\XOPVAL
\XIOBUF
\XLST05
\XLST01
      COMMON/REGTMP/ 
     1CENTO(4), CENTN(4),WSPAC1(3,3), WSPAC2(3,3), WSPAC3(3,3),
     2ROOTO(3), ROOTN(3),VECTO(3,3),VECTN(3,3),COSNO(3,3),COSNN(3,3),
     3RESULT(3,3),DELCNT(3), AVCNT(3),CFBPOL(3,3), CFBPNE(3,3),
     4BPCFOL(3,3), BPCFNE(3,3)

      CHARACTER*21 CAMATM
      DIMENSION JFRN(4,2)
      DIMENSION RCPD(9), RTEMP(9), STEMP(9)
C 
\QSTORE
      DATA JFRN /'F', 'R', 'N', '1', 'F', 'R', 'N', '2'/

      CALL XZEROF(RCPD,9)   
      RCPD(1) = STORE(L1P2)
      RCPD(5) = STORE(L1P2+1)
      RCPD(9) = STORE(L1P2+2)

      IF(SUMDEV .GE. 0.1)THEN
       NUMDEV =NUMDEV +1
       WRITE(CMON,'(A)') 'WARNING - poor initial fit' 
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU,1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      ENDIF

      IF (NOLD.LE.0) GO TO 200

C Write cameron.ini for orthogonal coords:
      CALL XRDOPN ( 5 , JFRN(1,1) , 'CAMERON.INI', 11)
      WRITE(NCFPU1,1002)
1002  FORMAT('$DATA'/'CELL    1.0000    1.0000    1.0000    90.000     9
     10.000    90.000'/'LIST5'/'REGULAR.L5I'/'$SYMM'/'NOCEN'/'$')
      CALL XRDOPN ( 7 , JFRN(1,1) , 'CAMERON.INI', 11)


C Write regular.oby - may be used in cameron to colour the two
C overlapping molecules separately.
      CALL XRDOPN ( 5 , JFRN(1,1) , 'regular.dat', 11)
      CALL XRDOPN ( 5 , JFRN(1,2) , 'REGULAR.OBY', 11)
      WRITE(NCFPU1,'(''Group1 '',I6)') NOLD
      WRITE(NCFPU2,'(''DEFGROUP REG1 ATOMS'')')
      DO I=1,NOLD
         INDATM=LATMD+MDATMD*(I-1)
         WRITE(CAMATM,'(A,I5)')ISTORE(LRENM+(I-1)*MDRENM),
     1                     NINT(STORE(LRENM+(I-1)*MDRENM+1))
         CALL XCRAS(CAMATM,LCAMA)
         WRITE(NCFPU2,'(A)')CAMATM
         CALL CATSTR (STORE(LRENM+(I-1)*MDRENM  ),
     1                STORE(LRENM+(I-1)*MDRENM+1), 1,1, 0,0,0,
     2                CAMATM,LCAMA)
         WRITE(NCFPU1,'(A)')CAMATM(1:LCAMA)
      END DO
      WRITE(NCFPU2,'(''DEFGROUP REG2 ATOMS'')')
      WRITE(NCFPU1,'(''Group2 '',I6)') NOLD
      DO I=1,NOLD
         INDATM=LATMD+MDATMD*(I-1)
         WRITE(CAMATM,'(A,I5)')ISTORE(LRENM+(I-1)*MDRENM+2),
     1                      NINT(STORE(LRENM+(I-1)*MDRENM+3))
         CALL XCRAS(CAMATM,LCAMA)
         WRITE(NCFPU2,'(A)')CAMATM
         CALL CATSTR (STORE(LRENM+(I-1)*MDRENM+2),
     1                STORE(LRENM+(I-1)*MDRENM+3), 1,1, 0,0,0,
     2                CAMATM,LCAMA)
         WRITE(NCFPU1,'(A)')CAMATM(1:LCAMA)
      END DO
      WRITE(NCFPU2,'(''COLO GROUP REG1 BLUE COLO GROUP REG2 RED'')')
      WRITE(NCFPU2,'(''VIEW''//)')
      CALL XRDOPN ( 7 , JFRN(1,2) , 'REGULAR.OBY', 11)
      CALL XRDOPN ( 7 , JFRN(1,1) , 'regular.dat', 11)

C Write header for superimposed orthogonal atom lists:
      CALL XRDOPN ( 5 , JFRN(1,1) , 'REGULAR.L5I', 11)
      WRITE(NCFPU1,1003)
1003  FORMAT('#'/'#  Written out from REGULARISE CAMERON'/'#'/
     1           '#LIST      5')
      WRITE(NCFPU1,1000)NOLD*2,0,0,0
1000  FORMAT(13HREAD NATOM = ,I6,11H, NLAYER = ,I4,13H, NELEMENT = ,
     2I4, 11H, NBATCH = ,I4)
      WRITE(NCFPU1,1050) STORE(L5O),STORE(L5O+1),STORE(L5O+2),
     1STORE(L5O+3),STORE(L5O+4),STORE(L5O+5)
1050  FORMAT(8HOVERALL ,F11.6,4(1X,F9.6),1X,F17.7)

      DO I=1,NOLD
       INDOLD=LOLD+MDOLD*(I-1)
       INDNEW=LNEW+MDNEW*(I-1)
       JOLD=ISTORE(LRENM+(MDRENM*(I-1))+4)
       JNEW=ISTORE(LRENM+(MDRENM*(I-1))+5)

C Get full tensor from upper diagonal storage:
       J=JOLD+7
       RTEMP(1)=STORE(J)    !U11
       RTEMP(2)=STORE(J+5)  !U12
       RTEMP(3)=STORE(J+4)  !U13
       RTEMP(4)=STORE(J+5)  !U21
       RTEMP(5)=STORE(J+1)  !U22
       RTEMP(6)=STORE(J+3)  !U23
       RTEMP(7)=STORE(J+4)  !U31
       RTEMP(8)=STORE(J+3)  !U32
       RTEMP(9)=STORE(J+2)  !U33

       IF ( NINT(STORE(JOLD+3)) .EQ. 0) THEN
C Transform = inv(M) * R * N * U * trans(N) * trans(R) * trans(inv(M))
C where N is a matrix with a*, b* and c* on the diagonal,
C and M is a matrix with a*, b* and c* of the best plane on
C the diagonal (ie. unit matrix).
C N == RCPD
C Start from the middle to the left:
         CALL XMLTMM (RCPD,RTEMP,STEMP,3,3,3)  ! N*U
         CALL XMLTMM (CFBPOL,STEMP,RTEMP,3,3,3)! R*RESULT
C Now to the right:
         CALL XMLTMM (RTEMP,RCPD,STEMP,3,3,3)  ! RESULT*N
         CALL XMLTMT (STEMP,CFBPOL,RTEMP,3,3,3)! RESULT*R'
       END IF

       WRITE(NCFPU1,2016) (STORE(J),J=JOLD,JOLD+3), !Type,ser,occ,flag
     1    (STORE(J),J=INDOLD,INDOLD+2),             !X,Y,Z
     2    RTEMP(1),RTEMP(5),RTEMP(9),RTEMP(6),RTEMP(3),RTEMP(2), !U's
     2    STORE(JOLD+13),                           !Spare
     3    1,(ISTORE(J),J=JOLD+15,JOLD+17)           !Extras


C Get full tensor from upper diagonal storage:
       J=JNEW+7
       RTEMP(1)=STORE(J)    !U11
       RTEMP(2)=STORE(J+5)  !U12
       RTEMP(3)=STORE(J+4)  !U13
       RTEMP(4)=STORE(J+5)  !U21
       RTEMP(5)=STORE(J+1)  !U22
       RTEMP(6)=STORE(J+3)  !U23
       RTEMP(7)=STORE(J+4)  !U31
       RTEMP(8)=STORE(J+3)  !U32
       RTEMP(9)=STORE(J+2)  !U33

       IF ( NINT(STORE(JNEW+3)) .EQ. 0) THEN
C Start from the middle to the left:
         CALL XMLTMM (RCPD,RTEMP,STEMP,3,3,3)  ! N*U
         CALL XMLTMM (CFBPNE,STEMP,RTEMP,3,3,3)! R*RESULT
C Now to the right:
         CALL XMLTMM (RTEMP,RCPD,STEMP,3,3,3)  ! RESULT*N
         CALL XMLTMT (STEMP,CFBPNE,RTEMP,3,3,3)! RESULT*R'
       END IF

       WRITE(NCFPU1,2016) (STORE(J),J=JNEW,JNEW+3), 
     1   (STORE(J),J=INDNEW,INDNEW+2),
     2   RTEMP(1),RTEMP(5),RTEMP(9),RTEMP(6),RTEMP(3),RTEMP(2),
     2   STORE(JNEW+13),                     
     3   2,(ISTORE(J),J=JNEW+15,JNEW+17)
      END DO

2016     FORMAT
     1   ('ATOM ',A4,1X,6F11.6/
     2    'CON U[11]=',6F11.6/
     3    'CON SPARE=',F11.2,3I11,7X,A4)

C Don't bother with element, layer scales etc. Punch End:
      WRITE(NCFPU1,'(''END''/''#USE LAST'')')
      CALL XRDOPN ( 7 , JFRN(1,1) , 'REGULAR.L5I', 11)

      RETURN
 
200   CONTINUE
      CALL XOPMSG (IOPREG,IOPINT,0)
      RETURN
      END





CODE FOR XMATCH
      SUBROUTINE XMATCH
C-- CALCULATE A MATCH OR MATCHES BETWEEN TWO FRAGMENTS, AND RUN REGU COMPARE
C-- TO FIND THE BEST ONE.
\ISTORE
      DIMENSION PROCS(1)
      DIMENSION KATV(5)
\STORE
\XSTR11
\XDSTNC
c      COMMON /XPROCM/ILISTL
\XLEXIC
\XPDS
\XLISTI
\XCONST
\XCHARS
\XUNITS
\XSSVAL
\XTAPES
\XLST01
\XLST02
\XLST03
\XLST05
\XLST41
\XMATCH
\XERVAL
\XOPVAL
\XIOBUF
\XRGCOM
\XCOMPD 
C
\QSTORE
C
c      EQUIVALENCE (ILISTL,PROCS(1))
C
      DATA IDIMN /3/
C
      DATA IVERSN /100/

      CALL XTIME1(2)                       ! SET THE TIMING FUNCTION
      CALL XCSAE

      MQ = KSTALL ( 100 )         ! ALLOCATE A BUFFER FOR COMMAND PROCESSING

      ICHNG=0
      CALL XLXINI (INEXTD, ICHNG) ! INITIALISE LEXICAL INPUT
      JDIMBF = 8                  ! RESERVE COMMAND LINE BUFFER OF 8 ELEMENTS
      IDIMBF=JDIMBF+IDIMN         ! ADD SPACE FOR ADDRESSED ARGUMENTS
      ICOMBF=KSTALL(IDIMBF)       ! GET THE SPACE
      JCOMBF = ICOMBF+JDIMBF      ! START OF ADDRESSED ARGS

      CALL XZEROF( ISTORE(ICOMBF), IDIMBF)  !  ZERO THE BUFFER
      ZORIG  = 0.0
      IPCHRE = -1
      IEQATM = 0
      WRITE (CPCH,'(15A4)') (KTITL(I),I=1,15)


C INSTRUCTION READING LOOP
      DO WHILE (.TRUE.)
C        WRITE (CMON,'(A)') ' Reading instruction '
C        CALL XPRVDU(NCVDU,1,0)
        IDIRNM = KLXSNG(ISTORE(ICOMBF),IDIMBF,INEXTD) ! READ A DIRECTIVE
        IF (IDIRNM .LT. 0) CYCLE
        IF (IDIRNM .EQ. 0) EXIT

        SELECT CASE (IDIRNM)

        CASE(1)     ! 'OUTPUT'

        CASE(6)     ! 'MATCH'
          IULN = ISTORE(JCOMBF+1)   
          IULN = KTYP05 (IULN)
          CALL XLDR05 (IULN)       ! LOAD LIST 5/10
          IF (IERFLG .LT. 0) GOTO 9900
          IF (KHUNTR (1,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL01
          IF (KHUNTR (2,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL02
          IF (KHUNTR (3,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL03
          IF (KHUNTR (29,0,IADDL,IADDR,IADDD,-1).LT. 0) CALL XFAL29
          IF (KHUNTR (40,0,IADDL,IADDR,IADDD,-1).LT. 0) CALL XFAL40
          IF (KHUNTR (41,0,IADDL,IADDR,IADDD,-1).LT. 0) CALL XFAL41
          IF (KHUNTR (5,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL05
          IF (IERFLG .LT. 0) GOTO 9900

          CALL XBCALC(2) ! Force a bondcalc, but don't allow loading of L5

          MDATVC = 5
          NATVC = N5
          I=(NATVC+1)*MDATVC   ! WORKSPACE + ONE BUFFER
          LATVC = KSTALL (I) ! ALLOCATE VECTORS - INDICATE SELECTED ATOMS
          CALL XZEROF ( ISTORE(LATVC) , I )             !Initialise
          DO I = 0,N5-1                             !Make first into an index.
            ISTORE(LATVC+I*MDATVC) = I
          END DO

        CASE (2)    ! 'MAP' DIRECTIVE
C          WRITE (CMON,'(A)') ' Processing MAP directive '
C          CALL XPRVDU(NCVDU,1,0)
          KATV(1) = 0
          KATV(2) = 1
          KATV(3) = 0
          KATV(4) = 0
          KATV(5) = 0
          CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , 1 , KATV)

        CASE (3)    ! 'ONTO' DIRECTIVE
C          WRITE (CMON,'(A)') ' Processing ONTO directive '
C          CALL XPRVDU(NCVDU,1,0)
          KATV(1) = 0
          KATV(2) = 0
          KATV(3) = 1
          KATV(4) = 0
          KATV(5) = 0
          CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , 1 , KATV)

        CASE (4)    ! 'RENAME'
          ZORIG=XLXRDV(100.)

        CASE (5)    ! 'EQUALATOM'
          IEQATM=1

        CASE DEFAULT   !ERROR
          GOTO 9910

        END SELECT
      END DO              ! COMMAND INPUT COMPLETE. CHECK FOR ERRORS:

      IPCHRE = ISTORE(JCOMBF+2)

      IF ( LEF .GT. 0 ) GO TO 9910

      IF ( IEQATM .EQ. 0 ) THEN
        IF (KELECN().LT.0) GO TO 9900    ! Put electron count into SPARE
      ELSE
        DO I = 0,N5-1
          STORE(L5+13+I*MD5) = 10
        END DO
      END IF

      CALL XRELAX      ! GET CARDINALITY OF ATOMS BASED ON BONDING NETWORK
       
c        WRITE (CMON,'(A)') ' Atom Serial  MAP ONTO SPARE'
c        CALL XPRVDU(NCVDU,1,0)
  
      DO I = 0, N5-1       ! Copy CARDINALITY to 4th vector.
          ISTORE(3+LATVC+I*MDATVC) = NINT(STORE(13+L5+I*MD5))
c          WRITE(CMON,'(1X,A4,2X,I5,4X,I1,4X,I1,1X,I15)')
c     1    ISTORE(L5+I*MD5),NINT(STORE(1+L5+I*MD5)),
c     2    ISTORE(1+LATVC+I*MDATVC),ISTORE(2+LATVC+I*MDATVC),
c     3    NINT(STORE(13+L5+I*MD5))
c        CALL XPRVDU(NCVDU,1,0)
      END DO

C Generate a vector for each fragment.

      LMAP = LATVC
      NMAP = 0

      DO I = 0, N5-1         ! Loop over all the atoms
        IF ( ISTORE(1+LATVC+I*MDATVC) .EQ. 1 ) THEN  ! MAP fragment
C Swap with atom at LMAP+NMAP.
          CALL XMOVEI(ISTORE(LATVC+I    *MDATVC),             ! I to END
     1                ISTORE(LATVC+NATVC*MDATVC), MDATVC)
          CALL XMOVEI(ISTORE(LMAP +NMAP *MDATVC),             ! NMAP to I
     1                ISTORE(LATVC+I    *MDATVC), MDATVC)
          CALL XMOVEI(ISTORE(LATVC+NATVC*MDATVC),             ! END to NMAP
     1                ISTORE(LMAP +NMAP *MDATVC), MDATVC)
          NMAP = NMAP + 1
        END IF
      END DO
          
      LONTO= LMAP+NMAP*MDATVC
      NONTO= 0

      DO I = 0, N5-1         ! Loop over all the atoms
        IF ( ISTORE(2+LATVC+I*MDATVC) .EQ. 1 ) THEN  ! ONTO fragment
C Swap with atom at LONTO+NONTO.
          CALL XMOVEI(ISTORE(LATVC+I    *MDATVC),             ! I to END
     1                ISTORE(LATVC+NATVC*MDATVC), MDATVC)
          CALL XMOVEI(ISTORE(LONTO+NONTO*MDATVC),             ! NONTO to I
     1                ISTORE(LATVC+I    *MDATVC), MDATVC)
          CALL XMOVEI(ISTORE(LATVC+NATVC*MDATVC),             ! END to NONTO
     1                ISTORE(LONTO+NONTO*MDATVC), MDATVC)
          NONTO = NONTO + 1
        END IF
      END DO

      NATVC = NMAP + NONTO   ! Can still use to address atoms of both frags.

C Sort each set of atoms into order of cardinality.
      CALL SSORTI(LMAP, NMAP, MDATVC,4)
      CALL SSORTI(LONTO,NONTO,MDATVC,4)

C Count to work out the uniqueness of each atom and store in 5th vector.
      ICUR = ISTORE(3+LATVC)
      INUM = 0
      IPREV= 0
      IUNIQ= 0
      IDOUB= 0
      ITRIP= 0
      IQUAD= 0

      DO I = 0, NATVC-1         ! Loop over all the atoms
        IF ( (I.EQ.NMAP).OR.(ISTORE(3+LATVC+I*MDATVC) .NE. ICUR) )THEN  ! Cardinality changed.
          DO J = I-1, IPREV, -1            ! Put uniqueness in 5th vector.
            ISTORE(4+LATVC+J*MDATVC) = INUM
          END DO
          IF (( INUM.EQ.1 ).AND.(I.LE.NMAP)) IUNIQ = IUNIQ+1
          IF (( INUM.EQ.2 ).AND.(I.LE.NMAP)) IDOUB = IDOUB+1
          IF (( INUM.EQ.3 ).AND.(I.LE.NMAP)) ITRIP = ITRIP+1
          IF (( INUM.EQ.4 ).AND.(I.LE.NMAP)) IQUAD = IQUAD+1
          IPREV = I
          ICUR = ISTORE(3+LATVC+I*MDATVC)
          INUM = 0
        END IF
        INUM = INUM + 1
      END DO

      DO J = NATVC-1, IPREV, -1            ! Finish off. Put uniqueness in 5th vector.
        ISTORE(4+LATVC+J*MDATVC) = INUM
      END DO

C Ensure fragments are 2D identical.
      IF ( ( NMAP .EQ. 0 ) .OR. ( NMAP .NE. NONTO ) ) THEN
        WRITE (CMON,'(A)') '{E Fragments are different sizes.'
        CALL XPRVDU(NCVDU,1,0)
        IF (IPCHRE.GE.0)THEN
         WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Residues_different_sizes'
        END IF
        GOTO 9900
      END IF

C Further ensure fragments are 2D identical.
      DO I = 0, NMAP-1
c        WRITE(CMON,'(7I6)')
c     2  ISTORE(LMAP+I*MDATVC),ISTORE(1+LMAP+I*MDATVC),
c     2  ISTORE(2+LMAP+I*MDATVC),ISTORE(3+LMAP+I*MDATVC),
c     3  ISTORE(4+LMAP+I*MDATVC),ISTORE(3+LONTO+I*MDATVC),
c     4  ISTORE(4+LONTO+I*MDATVC)
c        CALL XPRVDU(NCVDU,1,0)

        IF ((ISTORE(3+LMAP+I*MDATVC).NE. ISTORE(3+LONTO+I*MDATVC)).OR.
     1      (ISTORE(4+LMAP+I*MDATVC).NE. ISTORE(4+LONTO+I*MDATVC)))THEN
          WRITE (CMON,'(A)') '{E Fragment bonding is different.'
          CALL XPRVDU(NCVDU,1,0)
          IF (IPCHRE.GE.0)THEN
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     CHAR(9)//'Residues_bonding_different'
          END IF
          GOTO 9900
        END IF
      END DO

      WRITE (CMON,'(/A,I5)') 'Unique matches: ',IUNIQ
      CALL XPRVDU(NCVDU,2,0)

      JOBDON = 0

      IF ( IUNIQ .GE. 3 ) THEN   ! Need three matches to proceed simply.
        IF ( KNONLN() .EQ. 1 ) THEN  ! They must be nonlinear?
          JOBDON = 1
          CALL XREGQK
        ELSE IF (IPCHRE.GE.0)THEN
           JOBDON = 1
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     CHAR(9)//'Linear_matching_fragments'
        END IF
      END IF

      IF ( JOBDON .EQ. 0 ) THEN

       IF ( IDOUB .GE. 1 ) THEN ! Try to break sym. Twice.

         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1    CHAR(9)//'Internal_symmetry_2'
         END IF

C Sort each set of atoms into index order.
         CALL SSORTI(LMAP, NMAP, MDATVC,1)
         CALL SSORTI(LONTO,NONTO,MDATVC,1)

         IRS1AT = -1

C Find first atom in residue 1 with uniqueness of 2.
         IRS1AT = 0
         DO I = 0, NMAP-1         ! Loop over all the residue 1 atoms

           WRITE(CMON,'(A,5I6,A4,I6)')'1: ',
     2     ISTORE(LMAP+I*MDATVC),ISTORE(1+LMAP+I*MDATVC),
     2     ISTORE(2+LMAP+I*MDATVC),ISTORE(3+LMAP+I*MDATVC),
     3     ISTORE(4+LMAP+I*MDATVC),
     1     ISTORE(L5+MD5*ISTORE(LMAP+I*MDATVC)),
     1     NINT(STORE(1+L5+MD5*ISTORE(LMAP+I*MDATVC)))
           CALL XPRVDU(NCVDU,1,0)

           IF (ISTORE(4+LMAP+I*MDATVC).EQ.2) THEN
             IRS1AT = L5 + ISTORE(LMAP+I*MDATVC) * MD5
             EXIT 
           END IF
         END DO

         IF ( IRS1AT .EQ. -1 ) THEN
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     CHAR(9)//'Uniqueness 2 in residue 1 not found'
           GOTO 9900
         END IF


         CRDAT=STORE(13+IRS1AT)

         WRITE(CMON,'(2A,I5)')'Boost one:',STORE(IRS1AT),
     1    NINT(STORE(IRS1AT+1))
         CALL XPRVDU(NCVDU,1,0)

C Find two atoms in residue 2 with uniqueness of 2 of same CARDINALITY
C as IRS1AT
         IRS2A1 = -1
         IRS2A2 = -1
         DO I = 0, NONTO-1         ! Loop over all the residue 2 atoms.

           WRITE(CMON,'(A,5I6,A4,I6)')'2: ' ,
     2     ISTORE(LONTO+I*MDATVC),ISTORE(1+LONTO+I*MDATVC),
     2     ISTORE(2+LONTO+I*MDATVC),ISTORE(3+LONTO+I*MDATVC),
     3     ISTORE(4+LONTO+I*MDATVC),
     1     ISTORE(L5+MD5*ISTORE(LONTO+I*MDATVC)),
     1     NINT(STORE(1+L5+MD5*ISTORE(LONTO+I*MDATVC)))
           CALL XPRVDU(NCVDU,1,0)


           IF ((ISTORE(4+LONTO+I*MDATVC).EQ.2) .AND.
     1         ( ABS( CRDAT -
     2           STORE( 13+L5+MD5*ISTORE(LONTO+I*MDATVC) )
     3          ).LT. ZERO )) THEN
             IF ( IRS2A1 .GT. -1 ) THEN
               IRS2A2 = L5 + ISTORE(LONTO+I*MDATVC) * MD5
               EXIT
             ELSE
               IRS2A1 = L5 + ISTORE(LONTO+I*MDATVC) * MD5
             END IF
           END IF
         END DO

         IF ( IRS2A1 .EQ. -1 ) THEN
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     CHAR(9)//'Uniqueness 2 in residue 2 not found'
           GOTO 9900
         END IF
         IF ( IRS2A2 .EQ. -1 ) THEN
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     CHAR(9)//'Second Uniqueness 2 in residue 2 not found'
           GOTO 9900
         END IF


         DO ISYMBK = 1,2


C Sort each set of atoms into index order.
           CALL SSORTI(LMAP, NMAP, MDATVC,1)
           CALL SSORTI(LONTO,NONTO,MDATVC,1)


           IF ( IEQATM .EQ. 0 ) THEN
             IF (KELECN().LT.0) GO TO 9900    ! Put electron count into SPARE
           ELSE
             DO I = 0,N5-1
               STORE(L5+13+I*MD5) = 10
             END DO
           END IF


C Triple the cardinality of the two found atoms.

           STORE(13+IRS1AT) = STORE(13+IRS1AT) * 3.0
           IF ( ISYMBK .EQ. 1 ) THEN
             IRS2AT = IRS2A1
           ELSE
             IRS2AT = IRS2A2
           END IF
           STORE(13+IRS2AT) = STORE(13+IRS2AT) * 3.0

c           DO I = 0, NMAP-1    
c            WRITE(CMON,'(A,2(3X,5I5,1X,A4,I3,I6))')'111: ',
c     2      ISTORE(LMAP+I*MDATVC),ISTORE(1+LMAP+I*MDATVC),
c     2      ISTORE(2+LMAP+I*MDATVC),ISTORE(3+LMAP+I*MDATVC),
c     3      ISTORE(4+LMAP+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LMAP+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     2      ISTORE(LONTO+I*MDATVC),ISTORE(1+LONTO+I*MDATVC),
c     2      ISTORE(2+LONTO+I*MDATVC),ISTORE(3+LONTO+I*MDATVC),
c     3      ISTORE(4+LONTO+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LONTO+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LONTO+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LONTO+I*MDATVC)))
c            CALL XPRVDU(NCVDU,1,0)
c           END DO
c           WRITE(CMON,'(/)')
c           CALL XPRVDU(NCVDU,1,0)


           WRITE(CMON,'(2A,I5)')'Boost two:',STORE(IRS2AT),
     1      NINT(STORE(IRS2AT+1))
           CALL XPRVDU(NCVDU,1,0)

           CALL XRELAX      ! GET CARDINALITY OF ATOMS BASED ON BONDING NETWORK

           DO I = 0, NMAP-1       ! Copy CARDINALITY to 4th vector.
             ISTORE(3+LMAP+I*MDATVC) =
     1                NINT(STORE(13+L5+ISTORE(LMAP+I*MDATVC)*MD5))
             ISTORE(3+LONTO+I*MDATVC) =
     1                NINT(STORE(13+L5+ISTORE(LONTO+I*MDATVC)*MD5))
           END DO

c           DO I = 0, NMAP-1
c            WRITE(CMON,'(A,2(3X,5I5,1X,A4,I3,I6))')'Pre: ',
c     2      ISTORE(LMAP+I*MDATVC),ISTORE(1+LMAP+I*MDATVC),
c     2      ISTORE(2+LMAP+I*MDATVC),ISTORE(3+LMAP+I*MDATVC),
c     3      ISTORE(4+LMAP+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LMAP+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     2      ISTORE(LONTO+I*MDATVC),ISTORE(1+LONTO+I*MDATVC),
c     2      ISTORE(2+LONTO+I*MDATVC),ISTORE(3+LONTO+I*MDATVC),
c     3      ISTORE(4+LONTO+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LONTO+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LONTO+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LONTO+I*MDATVC)))
c            CALL XPRVDU(NCVDU,1,0)
c           END DO
c           WRITE(CMON,'(/)')
c           CALL XPRVDU(NCVDU,1,0)

C Sort each set of atoms into order of cardinality.
           CALL SSORTI(LMAP, NMAP, MDATVC,4)
           CALL SSORTI(LONTO,NONTO,MDATVC,4)

c           DO I = 0, NMAP-1
c            WRITE(CMON,'(A,2(3X,5I5,1X,A4,I3,I6))')'Post:',
c     2      ISTORE(LMAP+I*MDATVC),ISTORE(1+LMAP+I*MDATVC),
c     2      ISTORE(2+LMAP+I*MDATVC),ISTORE(3+LMAP+I*MDATVC),
c     3      ISTORE(4+LMAP+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LMAP+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     2      ISTORE(LONTO+I*MDATVC),ISTORE(1+LONTO+I*MDATVC),
c     2      ISTORE(2+LONTO+I*MDATVC),ISTORE(3+LONTO+I*MDATVC),
c     3      ISTORE(4+LONTO+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LONTO+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LONTO+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LONTO+I*MDATVC)))
c            CALL XPRVDU(NCVDU,1,0)
c           END DO
c           WRITE(CMON,'(/)')
c           CALL XPRVDU(NCVDU,1,0)

C Count to work out the uniqueness of each atom and store in 5th vector.
           ICUR = ISTORE(3+LATVC)
           INUM = 0
           IPREV= 0
           IUNIQ= 0
           IDOUB= 0
           ITRIP= 0
           IQUAD= 0

           DO I = 0, NATVC-1         ! Loop over all the atoms
            IF ( (I.EQ.NMAP).OR.(ISTORE(3+LATVC+I*MDATVC) .NE.ICUR))THEN  ! Cardinality changed.
              DO J = I-1, IPREV, -1            ! Put uniqueness in 5th vector.
                ISTORE(4+LATVC+J*MDATVC) = INUM
              END DO
              IF (( INUM.EQ.1 ).AND.(I.LE.NMAP)) IUNIQ = IUNIQ+1
              IF (( INUM.EQ.2 ).AND.(I.LE.NMAP)) IDOUB = IDOUB+1
              IF (( INUM.EQ.3 ).AND.(I.LE.NMAP)) ITRIP = ITRIP+1
              IF (( INUM.EQ.4 ).AND.(I.LE.NMAP)) IQUAD = IQUAD+1
              IPREV = I
              ICUR = ISTORE(3+LATVC+I*MDATVC)
              INUM = 0
            END IF
            INUM = INUM + 1
           END DO

           DO J = NATVC-1, IPREV, -1            ! Finish off. Put uniqueness in 5th vector.
            ISTORE(4+LATVC+J*MDATVC) = INUM
           END DO


c           DO I = 0, NMAP-1
c            WRITE(CMON,'(A,2(3X,5I5,1X,A4,I3,I6))')'Uniq:',
c     2      ISTORE(LMAP+I*MDATVC),ISTORE(1+LMAP+I*MDATVC),
c     2      ISTORE(2+LMAP+I*MDATVC),ISTORE(3+LMAP+I*MDATVC),
c     3      ISTORE(4+LMAP+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LMAP+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LMAP+I*MDATVC))),
c     2      ISTORE(LONTO+I*MDATVC),ISTORE(1+LONTO+I*MDATVC),
c     2      ISTORE(2+LONTO+I*MDATVC),ISTORE(3+LONTO+I*MDATVC),
c     3      ISTORE(4+LONTO+I*MDATVC),
c     1      ISTORE(L5+MD5*ISTORE(LONTO+I*MDATVC)),
c     1      NINT(STORE(1+L5+MD5*ISTORE(LONTO+I*MDATVC))),
c     1      NINT(STORE(13+L5+MD5*ISTORE(LONTO+I*MDATVC)))
c            CALL XPRVDU(NCVDU,1,0)
c           END DO

C Ensure fragments are 2D identical.
           IF ( ( NMAP .EQ. 0 ) .OR. ( NMAP .NE. NONTO ) ) THEN
            WRITE (CMON,'(A)') '{E Fragments are different sizes.'
            CALL XPRVDU(NCVDU,1,0)
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1       CHAR(9)//'Residues_different_sizes'
            END IF
            GOTO 9900
           END IF

C Further ensure fragments are 2D identical.
           DO I = 0, NMAP-1
            IF((ISTORE(3+LMAP+I*MDATVC).NE.ISTORE(3+LONTO+I*MDATVC)).OR.
     1        (ISTORE(4+LMAP+I*MDATVC).NE.ISTORE(4+LONTO+I*MDATVC)))THEN
              WRITE (CMON,'(A)') '{E Fragment bonding is different.'
              CALL XPRVDU(NCVDU,1,0)
              IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'Residues_bonding_different'
              GOTO 9900
            END IF
           END DO

           WRITE (CMON,'(/A,I5)') 'Unique matches: ',IUNIQ
           CALL XPRVDU(NCVDU,2,0)

           JOBDON = 0
    
           IF ( IUNIQ .GE. 3 ) THEN   ! Need three matches to proceed simply.
            IF ( KNONLN() .EQ. 1 ) THEN  ! They must be nonlinear?
              JOBDON = 1
              CALL XREGQK
            ELSE IF (IPCHRE.GE.0)THEN
              WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1        CHAR(9)//'Linear_matching_fragments'
              JOBDON = 1
            END IF
           ELSE IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1       CHAR(9)//'Still_not_enough_unique_matches'
           END IF

           IF (JOBDON.EQ.0) THEN
            IF ( IDOUB .GE. 1 ) THEN 
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'More_Internal_symmetry_2'
            ELSE IF ( ITRIP .GE. 1 ) THEN 
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'More_Internal_symmetry_3'
            ELSE IF ( IQUAD .GE. 1 ) THEN
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'More_Internal_symmetry_4'
            ELSE
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'Internal_symmetry_lots'
            END IF
           END IF
         END DO

       ELSE IF ( ITRIP .GE. 1 ) THEN ! Try to break sym. Three times.
        IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Internal_symmetry_3'

       ELSE IF ( IQUAD .GE. 1 ) THEN ! Try to break sym. Four times.
        IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Internal_symmetry_4'

       ELSE
        IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Internal_symmetry_lots'

       END IF
      END IF


      IF ( NEWLIS .GT. 0 ) THEN       ! WRITE OUT NEW LIST
         LN=5
         IREC=101
         I=KHUNTR(LN,IREC,IADDL,IADDR,IADDD,0) ! LOCATE RECORD 101
         ISTORE(IADDR+3)=L5                    ! CHANGE ADDRESS
         CALL XUDRH(LN,IREC,0,N5)              ! UPDATE RECORD HEADER
         CALL XSTR05(5,0,1)                    ! STORE LIST 5
         WRITE ( CMON,9155) N5
         CALL XPRVDU(NCVDU, 2,0)
9155  FORMAT (' List 5 now contains ',I4,' atoms  ',/,
     2 ' list modification complete  ')
      END IF



C--TERMINATION MESSAGES
6050  CONTINUE
      IF ( IPCHRE .GE. 0 ) WRITE(NCPU,'(A)')CPCH(1:LEN_TRIM(CPCH))
      CALL XOPMSG ( IOPDIS, IOPEND, IVERSN )
      CALL XTIME2(2)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDIS , IOPABN , 0 )
      IF ( IPCHRE .GE. 0 ) WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1 CHAR(9)//'errors'
      GO TO 6050
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDIS , IOPCMI , 0 )
      IF ( IPCHRE .GE. 0 ) WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1 CHAR(9)//'command_input_error'
      GO TO 9900
      END


CODE FOR KNONLN
      FUNCTION KNONLN()
\STORE
\ISTORE
\XUNITS
\XDSTNC 
\XLST05
\XMATCH
\XIOBUF
\QSTORE
      KNONLN = -1
      LMOLAX = KSTALL (28+IUNIQ*4)
      MMOLAX = LMOLAX+28

      DO I = 0, NMAP-1
        IF ( ISTORE(4+LMAP+I*MDATVC) .EQ. 1 ) THEN
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)-1) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MMOLAX),3)
          STORE(MMOLAX+3) = 1.0
          MMOLAX = MMOLAX + 4
        END IF
      END DO

      I=KMOLAX(STORE(LMOLAX+28),IUNIQ,4,
     1           STORE(LMOLAX),  STORE(LMOLAX+3),
     1           STORE(LMOLAX+6),STORE(LMOLAX+15),STORE(LMOLAX+24))

      DEV=STORE(LMOLAX+5)

      IF ( DEV .LT. 0.01 ) THEN
          WRITE (CMON,'(A)') 'Unique substructure is linear.'
          CALL XPRVDU(NCVDU,1,0)
          RETURN
      END IF

      KNONLN = 1
      RETURN
      END



CODE FOR KELECN
      FUNCTION KELECN()
C Put the electron count for an element into SPARE.
\ISTORE
\STORE
\XLST03
\XLST05
\QSTORE
      KELECN=-1
      IF (KHUNTR(3,0,I,K,J,-1).LT.0) RETURN   ! L3 LOADED ?
      IF (MD5.LE.14)                 RETURN   ! MODERN LIST 5 ?
      KELECN=1
      M5=L5
      DO I=1,N5
         M3=L3
         DO J=1,N3
            IF (ISTORE(M5).EQ.ISTORE(M3)) THEN
                  STORE(M5+13)=STORE(M3+1)+STORE(M3+3)+
     1                         STORE(M3+5)+STORE(M3+7)+STORE(M3+9)+
     1                         STORE(M3+11)
               GO TO 100
            END IF
            M3=M3+MD3
         END DO
         STORE(M5+13)=0.0
100      CONTINUE
         M5=M5+MD5
      END DO
      RETURN
      END



CODE FOR XRELAX
      SUBROUTINE XRELAX
C GET CARDINALITY OF ATOMS BASED ON BONDING NETWORK
C  Assign each atom the sum of all its neighbours' values of SPARE +
C  its original value.
C  Repeat until number of unique atoms stops increasing.
C  A good initial value for SPARE would be the electron count.
\STORE
\ISTORE
\XLST05
\XLST41
\QSTORE
\XUNITS
\XIOBUF

      LTEMP=KSTALL(N5*3)                     ! Get some workspace
      LORIG=LTEMP+N5
      LBEST=LTEMP+N5*2
      MBEST = 0

      DO I = 0, N5-1    ! Copy original SPARE into STORE(LORIG)
        STORE(LORIG+I) = REAL(NINT( STORE(L5+13+I*MD5) ))
      END DO

      IDOCNT = -1
      NOIMPR = 0
      IMAXSP = 0

      DO WHILE ( .TRUE. )

        DO I = 0, N5-1    ! Copy existing SPARE into STORE(LTEMP)
          STORE(LTEMP+I) = REAL(NINT( STORE(L5+13+I*MD5) ))
          IF ( IMAXSP .GT. 9999 ) STORE(LTEMP+I) = STORE(LTEMP+I) / 10.0
          STORE(L5+13+I*MD5) = STORE(LORIG+I) * 2.0
        END DO

        DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B ! Propagate values.
          J51 = ISTORE(M41B)
          J52 = ISTORE(M41B+6)
          I51 = L5 + J51 * MD5
          I52 = L5 + J52 * MD5
          STORE(I51+13) = REAL(NINT( STORE(I51+13) + STORE(LTEMP+J52) ))
          STORE(I52+13) = REAL(NINT( STORE(I52+13) + STORE(LTEMP+J51) ))
c          WRITE(CMON,'(2(I6,F16.2))')J51,STORE(I51+13),J52,STORE(I52+13)
c          CALL XPRVDU(NCVDU,1,0)
        END DO

        IMAXSP = 0
        DO I = 0, N5-1               ! Copy new SPARE into ISTORE(LTEMP)
          ISTORE(LTEMP+I) = NINT( STORE(L5+13+I*MD5) )
          IMAXSP = MAX ( IMAXSP, ISTORE(LTEMP+I) )
        END DO
        CALL SSORTI(LTEMP,N5,1,1) ! Sort data at LTEMP
 
        LASTID = -1
        IDCOUN = 0
        DO I = 0, N5-1       ! Count number of unique ID's.
          IF ( ISTORE(LTEMP+I) .NE. LASTID) THEN
            IDCOUN = IDCOUN + 1
            LASTID = ISTORE(LTEMP+I)
          END IF
        END DO

        WRITE(CMON,'(A,I6)') 'Unique count: ',IDCOUN
        CALL XPRVDU(NCVDU,1,0)

        IF ( IDCOUN .LE. IDOCNT ) THEN
           NOIMPR = NOIMPR + 1 ! No improvement.
        ELSE
           NOIMPR = 0          ! Improvement.
           IF ( IDCOUN .GT. MBEST ) THEN
             MBEST = IDCOUN
             DO I = 0, N5-1       ! Copy SPARE into BEST
               ISTORE(LBEST+I) = NINT( STORE(L5+13+I*MD5) )
             END DO
           END IF
        END IF

        IF ( NOIMPR .GE. 3 ) EXIT  ! If # unique unimproved twice then break.

        IDOCNT = MAX ( IDOCNT, IDCOUN ) ! Best # unique found so far.
      END DO

      DO I = 0, N5-1       ! Copy BEST back into SPARE
          STORE(L5+13+I*MD5) = ISTORE(LBEST+I)
      END DO

      CALL XSTRLL (LTEMP)                   ! RETURN WORKSPACE
      RETURN
      END

CODE FOR XREGQK
      SUBROUTINE XREGQK
C    'REGULARISE' mini implementation, lists already loaded, just do the maths.
C List 1,2,5/10 must already be loaded.
C
C LMAP, LONTO, N..., and IUNIQ are required to be passed in through common.

\ICOM12
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XLISTI
\XCARDS
\XLST01
\XLST02
\XLST05
\XLST12
\XPDS
\XCONST
\XRGCOM
\XRGLST
\XMATCH
\XDSTNC 
\XRGRP
\XERVAL
\XOPVAL
\XIOBUF
\XCHARS
\QSTORE
\QLST12

      DATA IVERS /100/
      CALL XTIME1(2)

      NUMDEV = 0      ! INITIALISE THE POOR-FIT COUNTER
      IPCHSA = IPCHRE ! Hide IPCHRE counter
      IPCHRE = -1

\IDIM12
      DO I = 1,IDIM12     
        ICOM12(I) = NOWT   ! Don't use L12.
      END DO

C -- SET INITIAL VALUES IN COMMON
      MDATMD = MD5
      NATMD = 0
      MDOLD = 4
      NOLD = 0
      MDNEW = 4
      MDUIJ = 7
      NNEW = 0

      IMETHD=1       ! DEFAULT METHOD 1 (ROTATION COMPONENT OF ROTATION-DILATION MATRIX ONLY)
      IGRPNO=0       ! SET GROUP SERIAL NUMBER TO ZERO
      ICMPDF=2       ! DEFAULT VALUE OF THE 'COMPARE/REPLACE/KEEP' FLAG
      IFLCMP=ICMPDF  ! SET REPLACE/COMPARE FLAG TO DEFAULT VALUE

      CALL XMOVE(STORE(L1O2),RGOM(1,1),9) ! SET DEFAULT COORDINATES SYSTEM TO (1. 1. 1. 90. 90. 90.)
      CALL XZEROF(ORIGIN(1),3)   ! ZERO ORIGIN
      CALL XUNTM3(RGMAT(1,1))    ! SET TO ZERO ROTATION
      MDRENM = 6
C -- SET UP BLOCKS
      LATMD=KSTALL(NMAP*MDATMD)
      LOLD=KSTALL(NMAP*MDOLD)
      LNEW=KSTALL(NMAP*MDNEW)
      LUIJ=KSTALL(NMAP*MDUIJ)
      LRENM = KSTALL(MDRENM*NMAP)  ! ALLOCATE SPACE FOR RENAMING
C Allocate space for new space group closed set testing 
      MLTPLY = 2 * N2 * N2P * ( IC + 1 ) ! Twice current multiplicity.
C Space for upper triangle, each matrix has 16 entries. (N(N-1)/2 ops)
      MSGT = 8*MLTPLY*(MLTPLY+1)
      LSGT = KSTALL(MSGT)
      CALL XZEROF(STORE(LSGT),MSGT)


C     SAVE NFL and LFL
      IRNFL = NFL
      IRLFL = LFL

C Tell it how big the unique group is.

      NATMD = IUNIQ
      NOLD = IUNIQ
      NNEW = IUNIQ
      IGRPNO=IGRPNO+1             ! INCREMENT GROUP SERIAL NUMBER
      IFLCMP=2                    ! SET REPLACE/COMPARE FLAG TO COMPARE

C LRENM,MDRENM will contain the old atoms (MAP) followed by the
C new atoms (ONTO). In this routine, the type and serial are set.
C Form is:  0  TYPE  of old (ONTO) atom       NB. These aren't paired 
C           1  SERIAL of old (ONTO) atom          yet. Just two lists
C           2  TYPE of new (MAP) atom             held in the same 
C           3  SERIAL of new (MAP) atom.          vector.
C           4  L5 address of OLD, overwritten later if using for RENAME
C           5  L5 address of NEW, overwritten later if using for RENAME

      WRITE ( CMON,'(A,I5,A)') 'Initially matching ', IUNIQ,' atoms.'
      CALL XPRVDU(NCVDU, 1,0)
c      WRITE(CMON,'(A/3(3F10.3/))')'L1O1 XRG1:',(STORE(L1O1+I),I=0,8)
c      CALL XPRVDU(NCVDU,3,0)


      MNEW = LNEW
      MUIJ = LUIJ
      MRENM = LRENM
      MATMD = LATMD
      DO I = 0, NMAP-1
        IF ( ISTORE(4+LMAP+I*MDATVC) .EQ. 1 ) THEN
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)    ! XYZ
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)    ! Flag
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)  ! Uijs
          CALL XMOVE (STORE(I5),STORE(MATMD),MDATMD)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5
          MNEW = MNEW + 4
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
          MUIJ = MUIJ + MDUIJ
        END IF
      END DO

      MOLD = LOLD
      MRENM = LRENM
      DO I = 0, NONTO-1
        IF ( ISTORE(4+LONTO+I*MDATVC) .EQ. 1 ) THEN
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MOLD),3)
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM),2)
          ISTORE(MRENM+4) = I5
          MOLD = MOLD + 4
          MRENM = MRENM + 6
        END IF
      END DO


      IMAT = -1
      CALL XRGCLC(IMAT,0)

C     Restore NFL and LFL
      NFL = IRNFL
      LFL = IRLFL


      WRITE ( CMON,'(A)') 'Matching the rest.'
      CALL XPRVDU(NCVDU, 1,0)

c      WRITE(CMON,'(A/3(3F10.3/))')'L1O1 XRG2:',(STORE(L1O1+I),I=0,8)
c      CALL XPRVDU(NCVDU,4,0)

C This time put all atoms in (blocks are already big enough - we
C saw to that earlier).

      IFLCMP = 6
      NATMD= NMAP
      NOLD = NMAP
      NNEW = NMAP

      MNEW = LNEW
      MRENM = LRENM
      MATMD = LATMD
      MUIJ = LUIJ
      DO I = 0, NMAP-1
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )
c          WRITE(CMON,'(2(A,I7))')'I5MAP:',I5,STORE(I5),NINT(STORE(I5+1))
c          CALL XPRVDU(NCVDU,1,0)
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)
          CALL XMOVE (STORE(I5),STORE(MATMD),MDATMD)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5
c          WRITE(CMON,'(A,I10)')'MRENM+5: ',ISTORE(MRENM+5)
c          CALL XPRVDU(NCVDU,1,0)
          MNEW = MNEW + 4
          MUIJ = MUIJ + MDUIJ
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
      END DO

      MOLD = LOLD
      MRENM = LRENM
      DO I = 0, NONTO-1
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
c          WRITE(CMON,'(2(A,I7))')'I5MAP:',I5,STORE(I5),NINT(STORE(I5+1))
c          CALL XPRVDU(NCVDU,1,0)
          CALL XMOVE (STORE(I5+4),STORE(MOLD),3)
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM),2)
          ISTORE(MRENM+4) = I5
c          WRITE(CMON,'(A,I10)')'MRENM+5: ',ISTORE(MRENM+5)
c          CALL XPRVDU(NCVDU,1,0)
          MOLD = MOLD + 4
          MRENM = MRENM + 6
      END DO


c      DO I = 0, NMAP-1
c        MIRN = ISTORE(LRENM+5+I*6)
c        WRITE(CMON,'(A,I10)')'RENM:',MIRN
c        CALL XPRVDU(NCVDU,1,0)
c        WRITE(CMON,'(A4,I5)')ISTORE(MIRN),NINT(STORE(MIRN+1))
c        CALL XPRVDU(NCVDU,1,0)
c      END DO                                  

c      WRITE(CMON,'(A,I8)') 'XRGQCK, LRENM: ',LRENM
c      CALL XPRVDU(NCVDU,1,0)

C Improve the match:
      IF ( ZORIG .NE. 0 ) IFLCMP = 5
      IMAT = 3
      CALL XRGCLC(IMAT,1)

C     Restore NFL and LFL
      NFL = IRNFL
      LFL = IRLFL

      IF ( ZORIG .EQ. 0 ) THEN

        WRITE ( CMON,'(A)') 'Improving the matrix.'
        CALL XPRVDU(NCVDU, 1,0)
c      WRITE(CMON,'(A/3(3F10.3/))')'L1O1 XRG3:',(STORE(L1O1+I),I=0,8)
c      CALL XPRVDU(NCVDU,3,0)



C Use the better match to get a better matrix.
        MDATMD = MD5
        MDOLD = 4
        MDNEW = 4

        IMETHD=1       ! DEFAULT METHOD 1 (ROTATION COMPONENT OF ROTATION-DILATION MATRIX ONLY)
        CALL XMOVE(STORE(L1O2),RGOM(1,1),9) ! SET DEFAULT COORDINATES SYSTEM TO (1. 1. 1. 90. 90. 90.)
        CALL XZEROF(ORIGIN(1),3)   ! ZERO ORIGIN
        CALL XUNTM3(RGMAT(1,1))    ! SET TO ZERO ROTATION
        MDRENM = 6
        IFLCMP=2                    ! SET REPLACE/COMPARE FLAG TO COMPARE

        NATMD= NMAP
        NOLD = NMAP
        NNEW = NMAP
        MNEW = LNEW
        MUIJ = LUIJ
        MRENM = LRENM
        MATMD = LATMD
        DO I = 0, NMAP-1
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)
          CALL XMOVE (STORE(I5),STORE(MATMD),MDATMD)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5

c          WRITE(CMON,'(A,3F10.3,I5)')'MAP: ',(STORE(MNEW+K),K=0,2),I5
c          CALL XPRVDU(NCVDU,1,0)

          MNEW = MNEW + 4
          MUIJ = MUIJ + MDUIJ
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
        END DO


        MOLD = LOLD
        MRENM = LRENM
        DO I = 0, NONTO-1
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MOLD),3)
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM),2)
          ISTORE(MRENM+4) = I5
          MOLD = MOLD + 4
          MRENM = MRENM + 6
        END DO

        IPCHRE = IPCHSA ! Restore IPCHRE counter

        IMAT = -1
        CALL XRGCLC(IMAT,0)

C     Restore NFL and LFL
        NFL = IRNFL
        LFL = IRLFL


        WRITE ( CMON,'(A)') 'Do final mapping.'
        CALL XPRVDU(NCVDU, 1,0)


C Use the better matrix to do a final mapping:
        NATMD= NMAP
        NOLD = NMAP
        NNEW = NMAP
        MNEW = LNEW
        MUIJ = LUIJ
        MATMD = LATMD
        MRENM = LRENM
        DO I = 0, NMAP-1
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)
          CALL XMOVE (STORE(I5),STORE(MATMD),MDATMD)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5
          MNEW = MNEW + 4
          MUIJ = MUIJ + MDUIJ
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
        END DO
        MOLD = LOLD
        MRENM = LRENM
        DO I = 0, NONTO-1
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MOLD),3)
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM),2)
          ISTORE(MRENM+4) = I5
          MOLD = MOLD + 4
          MRENM = MRENM + 6
        END DO
        IMAT = 2


        IPCHRE = -1 ! Hide punch flag

        CALL XRGCLC(IMAT,1)

      END IF

C     Restore NFL and LFL
      NFL = IRNFL
      LFL = IRLFL

9200  CONTINUE
      IF (NUMDEV .GT. 0) THEN
       WRITE ( CMON,'(I5,A)') NUMDEV, ' Poorly mapping groups'
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU, 1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1)(:)
      ENDIF

C -- THIS IS THE ONLY WAY OUT OF THE ROUTINE
C -- WRITE FINAL MESSAGE
      IPCHRE = IPCHSA ! Restore IPCHRE counter

      CALL XOPMSG( IOPREG, IOPEND, IVERS)
      CALL XTIME2(2)
      RETURN
      END



CODE FOR KSGTEX
      SUBROUTINE KSGTEX(NMATS,ADDR)
C
C ADDR(16,NMATS)  - A lower triangular array of 4x4 matrices (column first).
C NMATS - The number of matrices in ADDR.
C
C
C The first matrix should always be the unit matrix.
C
C This subroutine takes the first column of matrix operators and
C fills in the rest of the array by imagining that the first row
C contains the same operators. Each filled in result is the
C product of the operator in the first column of the same row and
C the first row of the same column
C
C E.g. where each operator symbol below represents a 4x4 matrix:
C
C         1: 1
C
C         2: 21  5: 1
C
C         3: -1  6: m   8: 1
C
C         4: m   7: -1  9: 21  10: 1
C
C The first column is passed in, the rest is generated.

C DEBUG only:
\XIOBUF
\XUNITS
C END Debug

      DIMENSION ADDR(16,NMATS)

C Work out some properties of the matrix array
      NROWS = (SQRT(1.+8.*MAX(0,NMATS))-1)/2  ! Just quadratic soln of N(N+1)/2

      M = NROWS ! Address of current matrix (starting from 2nd column)

      DO I = 2,NROWS ! Loop over each column except the first.
        DO J = I,NROWS    ! Loop over each row that is stored.

C Set this matrix to the product of the first matrix in row J and the
C first matrix in row I (eqv to the 1st in column I)

          M = M + 1      ! Address for this matrix
          CALL XMLTMM(ADDR(1,J),ADDR(1,I),ADDR(1,M),4,4,4)

        END DO   ! End of loop over columns
      END DO   ! End of loop over rows

      M = 0
      DO I = 1, NROWS
        WRITE(CMON,'(/A,I4)') 'Col: ',I
        CALL XPRVDU(NCVDU,2,0)
        DO J = I, NROWS
          M = M + 1
          WRITE(CMON,'(/4(4F9.3/))') ((ADDR(K+K2,M),K=0,12,4),K2=1,4)
          CALL XPRVDU(NCVDU,5,0)
        END DO
      END DO


C Set all translation components to be in the range 0<t<1

      DO I = 1,NMATS
        DO J = 1,3
          ADDR(12+J,I) = MOD(ADDR(12+J,I),1.0)    ! Take remainder
          IF ( ADDR(12+J,I) .LT. 0.0 ) THEN
            ADDR(12+J,I) = ADDR(12+J,I) + 1       ! Add 1 if -ve
          END IF
        END DO
      END DO


      RETURN
      END

CODE FOR CMPMAT(A,B,N)
      FUNCTION CMPMAT(A,B,N)
      DIMENSION A(N)
      DIMENSION B(N)
C Compare how close two matrices are. For now use cross-correlation:
C
C r = SUMi [(Ai-<A>)(Bi-<B>)] / sqrt(SUMi[(Ai-<A>)^2]*SUMi[(Bi-<B>)^2])
C
C 1 = perfect match, less for non-perfect matches.


C Get averages
      AVA = 0.0
      AVB = 0.0
      DO I = 1,N
        AVA = AVA + A(I)
        AVB = AVB + B(I)
      END DO
      AVA = AVA / N
      AVB = AVB / N

C Do sum of prod of diffs
      SUMAB = 0.0
C and sum of diffs squared
      SUMAA = 0.0
      SUMBB = 0.0

      DO I = 1,N
        SUMAB = SUMAB + (A(I)-AVA) * (B(I)-AVB)
        SUMAA = SUMAA + (A(I)-AVA)**2
        SUMBB = SUMBB + (B(I)-AVB)**2
      END DO

      IF ( ABS(SUMAB) + ABS(SUMAA) + ABS(SUMBB) .LT. 0.00001 ) THEN
C Perfect match. Answer tends to 1 as these numbers all tend to zero.
        CMPMAT = 1.0
      ELSE
C Do the maths, but be mindful of divide by zero.
        DENOM = MAX(0.00001,SQRT(SUMAA*SUMBB)) ! Ensure non-zero denominator
        CMPMAT = SUMAB/DENOM
      END IF
      RETURN
      END

      
