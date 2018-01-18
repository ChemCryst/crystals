
c $Log: not supported by cvs2svn $
c Revision 1.71  2013/03/28 12:27:23  djw
c Increase field width for torsion angle differences
c
c Revision 1.70  2012/07/12 08:38:20  rich
c Ensure min/max values are initialised for torsion angle calc.
c
c Revision 1.69  2012/07/11 13:51:44  djw
c Add comparison of Uij.
c Remove losts of output from listing file.
c
c Revision 1.68  2012/05/08 11:16:25  djw
c Add code to transform and compare Uij values if present.  If either of corresponding atoms is isotropic, comparison is skipped
c
c Revision 1.67  2012/03/21 13:15:39  djw
c Fix (?) kabsch method 4 so that it more or less agrees with Diamond method 2, clarify some captions, 
c and comments about sources of methods
c
c Revision 1.66  2012/03/08 09:35:07  djw
c Fiddle with tabs to get .pch output from MATCH to lign up better.  Use correct name in Abandon messages
c
c Revision 1.65  2012/02/20 13:48:36  rich
c Warn if fragment contains elements with unknown scattering factors. The match might not work as you expect it.
c
c Revision 1.64  2012/01/04 14:31:25  rich
c Fix some uninitialized variables, and output format mistakes.
c
c Revision 1.63  2011/03/21 13:57:21  rich
c Update files to work with gfortran compiler.
c
c Revision 1.62  2011/02/07 16:03:04  djw
c Dave the determinat in the common block, invert the torsion angles in the secong molecule if DET is negative
c
c Revision 1.61  2010/11/03 15:19:05  djw
c In MATCH, change computation of torsion angle deviations.
c IN REGULAR.OBY. make colours green and purple (were red and blue), then reset o to reb, n to blue, s to yellow
c
c Revision 1.60  2010/04/26 15:53:34  djw
c Set Uiso to 0.0501 for tracking purposes
c
c Revision 1.59  2010/04/26 15:05:02  djw
c Update group occupancy, Uiso and FLAG for dummy atoms.  Lots of bits cleared out of XRGRDS, XRGPLA XRGPLG and a small bit added to XRGCLC.
c
c Revision 1.58  2009/06/03 10:33:01  djw
c Preserve the original occupation number etc in REPLACE, KEEP, AUGMENT
c
c Revision 1.57  2009/05/19 14:35:52  djw
c More lower case filename changes
c
c Revision 1.56  2008/06/27 14:42:05  djw
c minor bugfix
c
c Revision 1.55  2008/05/30 12:28:43  djw
c Enable copying of partial occupancies to defined groups during replace/augment
c
c Revision 1.54  2008/04/30 10:51:46  djw
c Enable copying of partial occupancies to defined groups during replexe/augment
c
c Revision 1.53  2008/03/07 16:09:48  djw
c changes to help with the correct computation of Fourier maps from twinned crystals.  THe old COPY67 subroutine did not pack the data properly unless the keys were the default keys.  The job is now done
c
c Revision 1.52  2008/02/14 10:28:09  djw
c Simplify output to PCH file
c
c Revision 1.51  2008/02/08 14:26:36  djw
c Enable improper rotation in Kabsch method
c
c Revision 1.50  2008/01/25 15:03:28  djw
c correct initialisation of cmon
c
c Revision 1.49  2007/12/17 17:31:20  djw
c Inhibit distance and torsion comparisons for external matches, add offset to KEEP directive
c
c Revision 1.48  2007/11/06 14:39:01  djw
c Tidy up automatic matching
c
c Revision 1.47  2006/07/12 09:59:30  djw
c Inhibit bond length, angle and torsion calculations if the second group is simply a shape
c
c Revision 1.46  2005/12/07 10:29:20  djw
c New code to control near-singularities for planar/linear/circular groups
c
c Revision 1.45  2005/06/22 12:48:29  rich
c Oops. SG op used in #MATCH pseudo-sg measure had rotational part transposed.
c
c Revision 1.44  2005/04/29 09:04:47  djw
c Move some CMON output to NCWU
c
c Revision 1.43  2005/04/28 17:14:16  djw
c Ensure that LIST 41 loads
c
c Revision 1.42  2005/03/15 09:51:24  rich
c Fix bug in regular's #MATCH when: (a) more than two molecules in asym unit
c and (b) each molecule contains additional symmetry and (c) the molecules being
c matched are not at the top of list 5. Use proper LATVC pointers to address list
c 5.
c
c Revision 1.41  2005/03/01 21:45:20  rich
c Fix renumbering of alike molecules. I'd commented out one line too many
c at some recent point. R.
c
c Revision 1.40  2005/01/23 08:29:11  rich
c Reinstated CVS change history for all FPP files.
c History for very recent (January) changes may be lost.
c
c Revision 1.2  2005/01/17 13:21:08  rich
c Bring new cvs repository into line with old.
c
c Revision 1.39  2004/12/14 10:06:44  rich
c Fix tiny bug when renumbering structures and the new serials clashed with
c the old.
c
c Revision 1.38  2004/12/10 11:06:13  rich
c Get rid of warnings when matching two molecules and there are
c extra molecular species in the model.
c
c Revision 1.37  2004/12/09 13:09:01  rich
c Fixed #match renumbering code after breaking it while improving
c the match robustness.
c
c Revision 1.36  2004/11/24 11:41:00  rich
c Improved molecule matching in #MATCH (regularise). Now bonding is considered
c during the extension to a 3D match forcing a valid 2D match on the structures.
c
c Revision 1.35  2004/08/25 08:50:40  rich
c Just some comments about the maths.
c
c Revision 1.34  2004/08/09 14:41:08  rich
c Now EQUALATOM *forces* equal atom types during #MATCH. If not specified,
c the program will attempt to use atom types unless it discovers Q atoms
c amongst the fragments, which causes it to switch into EQUALATOM mode.
c
c Revision 1.33  2004/08/09 12:06:23  rich
c Output #MATCH error status to a script variable.
c
c Revision 1.32  2004/03/16 12:02:06  rich
c Latest pseudo-symm for Anna.
c
c Revision 1.31  2004/03/09 13:28:17  rich
c New pseudo-op space group deviation measure.
c
c Revision 1.30  2004/02/26 09:47:55  rich
c Add three new closed set testing measures for Anna.
c
c Revision 1.29  2004/02/24 16:28:08  rich
c Anna: Fix generation of potential pseudo-operators in space groups
c containing lattice centerings.
c
c Revision 1.28  2004/02/24 14:41:14  rich
c Anna: Bug fix. Compute correct translation vector for transformations during #MATCH.
c
c Revision 1.27  2004/02/23 19:16:13  rich
c Change CMPMAT function from cross-correlation to 1 - rmsdeviation.
c
c Revision 1.26  2004/02/13 12:15:35  rich
c Re-written closed set symmetry testing for Anna's project.
c
c Revision 1.25  2004/02/11 09:04:14  rich
c Output of stuff for anna. (Closed set testing).
c
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
C                                   1 AND 5. DEFAULT VALUE SET IS 1.
C                                   UPPER LIMIT IS CHECKED BY ROUTINE
C                                   XRGSMD
C                  VALUE ( ONE OF ) : 1/2/3/4/5 ( SEE XRGCLC FOR MEANINGS )
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
C                  VALUE ( ONE OF ) : 1          2          3
C                                     (REPLACE)  (COMPARE)  (KEEP)
C                                    4           5          6
C                                    (AUGMENT)   (RENAME)   (CAMERON)
C                           THE VALUE 5 CAN ONLY BE SET BY A 'RENAME' 
C                           COMMAND
C                           THE VALUE 6 CAN ONLY BE SET BY A 'CAMERON' 
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
      INCLUDE 'ICOM12.INC'
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCOMPD.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XRGRP.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCHARS.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST12.INC'
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
c  initialise call counter for xrgclc
      icallno = 0
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
      WRITE (CPCH,'(15A4,a)') (KTITL(I),I=1,15),CHAR(9)
C -- LOAD LISTS 1 AND 2
      CALL XFAL01
      CALL XFAL02
C -- LOAD LIST 50
      CALL XFAL50
C -- LOAD LIST 5
      CALL XLDRO5(LA)
      IF ( IERFLG .LT. 0 ) GO TO 9250
      IF (KHUNTR (41,0,IADDL,IADDR,IADDD,-1).LT. 0) CALL XFAL41
C -- INITIALISE VALUES FOR REGULARISE
C -- INDICATE THAT LIST 12 IS NOT TO BE USED
      INCLUDE 'IDIM12.INC'
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
      MDOUIJ = 7
      MDOCC = 2
      NNEW = 0
cdjwdec07
c      allow geometrical deviations
      nogeom = 1
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
C----- CLEAR ATOM INFO  
      CALL XZEROF(ATOM(1), NATOMP )
      IATOM(1)= IH
C -- OCCUPANCY= 1.
      ATOM(3)=1.0
C----- FLAG
      ATOM(4)=1.0
C----- SET UISO
      ATOM(8) = 0.051
C----- U'S and SPARE 
      CALL XZEROF(ATOM(9), 6 )
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
cdjwjul06
      ishape = 0
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
      IF (IMATRIX .LE. 0) GOTO 8100
2200  CONTINUE
C -- 'OLD' DIRECTIVE
      CALL XRGRDS ( 1 )
      GO TO 8000
C
2350  CONTINUE
C -- 'MAP' DIRECTIVE
      IF (IMATRIX .LE. 0) GOTO 8100
2300  CONTINUE
C -- 'NEW' DIRECTIVE
      CALL XRGRDS ( 2 )
      GO TO 8000
2400  CONTINUE

C -- 'SYSTEM' DIRECTIVE
      CALL XRGRCS
c      inhibit geometrical deviations
      nogeom = -1
      write(cmon,'(a,a)')
     1'Distance and torsion deviations are not computed if one',
     2 ' of the fragments is from a different unit cell'
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
      GO TO 8000
c
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
cdjwjul06
      ishape = 1
      CALL XRGPLG (IHEX(1),6,1.39,1.39,0.0,ZEROSH(1),UNITMX(1))
      GO TO 8000
2800  CONTINUE
C -- 'HEXAGON' DIRECTIVE
cdjwjul06
      ishape = 1
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
cdjwjul06
      ishape = 1
C -- READ SCALE FACTOR
      XSCAL = XLXRDV( 1.)
      YSCAL = XLXRDV( XSCAL)
C -- PLACE GROUP. SCALE FACTOR IS APPLIED TO X AND Y
      CALL XRGPLG(ISQR(1),4,XSCAL, YSCAL,0.0,ZEROSH(1),UNITMX(1))
      GO TO 8000
3100  CONTINUE
C -- 'OCTAHEDRON' DIRECTIVE
cdjwjul06
      ishape = 1
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
cdjwjul06
      ishape = 1
C -- SEE COMMENTS AFTER 'OCTAHEDRON'
      XSCAL = XLXRDV( 1.)
      YSCAL = XLXRDV( XSCAL)
      ZSCAL = XLXRDV( YSCAL)
      CALL XRGPLG(IOCT(1),6,XSCAL, YSCAL, ZSCAL,ZEROSH(1),UNITMX(1))
      GO TO 8000
3300  CONTINUE
C -- TRIGONAL BIPYRAMID
cdjwjul06
      ishape = 1
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
C -- SET SERIAL OFFsET OF ATOMS
      dkeep=XLXRDV(0.)
      GO TO 8000
3700  CONTINUE
C----- AUGMENT
      IFLCMP = 4
      GO TO 8000
C TETRAHEDRON -  LISA PEARCE
3800  CONTINUE
cdjwjul06
      ishape = 1
      SCALE=XLXRDV(1.)
      CALL XRGPLG(ITET(1),5,SCALE,SCALE,SCALE,ZEROSH(1),UNITMX(1))
      GOTO 8000
3900  CONTINUE
C CP RING -  LISA PEARCE
cdjwjul06
      ishape = 1
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
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
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
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
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
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') (trim(CMON(II)),II=1,2)
9155  FORMAT (' List 5 now contains ',I4,' atoms  ',/,
     2 ' list modification complete  ')
C -- FINISH ROUTINE
9200  CONTINUE
      IF (NUMDEV .GT. 0) THEN
       write(cmon,'(/)')
       CALL XPRVDU(NCVDU, 1,0)
       WRITE ( CMON,'(I5,A)') NUMDEV, ' Poorly mapping groups'
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU, 1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(/A//)') trim(CMON(1))
       write(cmon,'(/)')
       CALL XPRVDU(NCVDU, 1,0)
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
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
9510  FORMAT (' Errors detected by lexical scanner  ')
      CALL XERHND ( IERERR )
C
C -- EXIT THIS R OUTINE,PRINTING ONLY THE FINAL MESSAGE AND ELAPSED
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
C               0 INITIAL CALL WITHOUT REFERENCE TO XRGPCS (OUTPUT)
C              +1 SECOND CALL IF RENUMBERING REQUIRED
C              +2 SECOND CALL REQUIRING CAMERON OUTPUT
C              +3 SECOND CALL REORDERS ATOMS IN JNEW TO MATCH JOLD
C
C      LSPARE   0 Normal operation
C               1 'Spare' value must be same for matched atoms.
C 
c     ICALLNO   CALL NUMBER, INCREMENTED HERE.
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
C -- THERE ARE 4 WAYS coded for CALCULATING THE BEST FIT MATRIX.
C    THE PARTICULAR ONE OF THESE USED IN EACH CASE DEPENDS ON THE
C    VALUE OF THE VARIABLE 'IMETHD'.

c      imethd 1 Rotation part of general transformation
c      imethd 2 for general rotation-dilation
c      imethd 3 for Kabsch pure rotation
c      imethd 4 for Kabsch permitting -ve rotation
c      imethd 5 for a UNIT matrix
c
C    THIS IS USED IN THIS SUBROUTINE TO SELECT ONE OF THE POSSIBLE
C    CALLS WHICH WILL CALCULATE A MATRIX.
C 
C 
      DIMENSION ITEMP(3), ATEMP(3), RTEMP1(3,3), RTEMP2(3,3)
      DIMENSION OPM(4,4), OPN(4,4), OTEMP(4), IBMA(16)
      DIMENSION TEMP1(3,3), TEMP2(3,3), TEMP3(3,3), DMATRIX(3,3)
C 
Cdjwnov99      DIMENSION CENTO(3),CENTN(3)
      INCLUDE 'REGTMP.INC'
C 
      CHARACTER*6 CELEMT
      CHARACTER*2 CSYM
      CHARACTER*1 CAXIS(3)
      CHARACTER*12 CFUNC(3)
      CHARACTER*2 CTEMP(3)
C 
C 
      INCLUDE 'XCOMPD.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C 
      INCLUDE 'QSTORE.INC'
C 
      DATA CELEMT/'23461m'/
      DATA CAXIS/'X','Y','Z'/
      DATA CFUNC/'Replacement','Comparison','Renaming'/
C
      icallno = icallno + 1
C
C
CDJWAPR2001
C----- CHECK THE NUMBER OF NEW AND OLD ATOMS
        WRITE(CMON,'(A,I4,A,I4)') 'Input: mapping ', NNEW ,
     1 ' atoms onto ', nold 
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
        IF (NOLD.EQ.NNEW) NATMD=NNEW
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
c
      cmon(1) =' '
      if (imethd .eq. 1) then
            write(cmon,'(a)')
     1 'Matching by Rotation/inversion (Method 1)'
      else if (imethd .eq. 2) then
            write(cmon,'(a)')
     1 'Matching by Rotation/dilation (Method 2)'
      else if (imethd .eq. 3) then
            write(cmon,'(a)')
     1 'Matching by Pure Rotation (Method 3, Kabsch)'
      else if (imethd .eq. 4) then
            write(cmon,'(a)')
     1 'Matching Permitting Improper Rotation (Method 4, Kabsch)'
      else if (imethd .eq. 5) then
            write(cmon,'(a)')
     1 'Matching using a UNIT matrix (Method 5)'
      endif
      call xprvdu(ncvdu,1,0)
      if (issprt .eq. 0) write(ncwu, '(a)') trim(CMON(1))
c
c
c
C----- COPY OLD WEIGHT TO NEW
      MOLD=LOLD
      MNEW=LNEW
      DO 50 I=1,NOLD
         STORE(MNEW+3)=STORE(MOLD+3)
         MOLD=MOLD+MDOLD
         MNEW=MNEW+MDNEW
50    CONTINUE
c
c      mold=lold
c      mnew=lnew
c      write(123,*)'MDOLD=',mdold,mdnew
12301  format(i6,20f12.3)
c      do i=1,nold
c       write(123,12301)i,(store(j),j=mold,mold+mdold-1)
c       write(123,12301)i,(store(j),j=mnew,mnew+mdnew-1)
c       mold=mold+mdold
c       mnew=mnew+mdnew
c      enddo
C 
C 
C -- PRINT HEADER TEXT
      NFUNC=1
      IF (IFLCMP.EQ.2) NFUNC=2
      IF (IFLCMP.EQ.5) NFUNC=3
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,100) CFUNC(NFUNC),IGRPNO,ICALLNO, imatrix
      END IF
100   FORMAT (//,1X,50X,A,' of group number ',I3,
     1 '. Cycle no',i3,'  Call type',i3//)
C 
Cdjwapr2001
      IF (IMATRIX.LE.0) THEN
C----- INITIALISE THE DEVIATIONS TO MASSIVE
      SUMDEV = 1000000.
C -- CALCULATE THE CENTROIDS, USING WEIGHTS OF 1. AND 0. TO REPRESENT
C    ATOMS WHICH ARE AND ARE NOT DEFINED IN THE 'OLD' GROUP.
C 
         CALL XRGCNT (CENTO,STORE(LOLD),STORE(LOLD),MDOLD,MDOLD,NOLD)
         CALL XRGCNT (CENTN,STORE(LNEW),STORE(LOLD),MDNEW,MDOLD,NOLD)
C         IF(IMETHD.EQ.5) THEN
C           CALL XRGCNT (CENTO,STORE(LNEW),STORE(LOLD),MDNEW,MDOLD,NOLD)
C         ENDIF
C 
C -- PRINT CENTROIDS AVERAGE, AND THE DIFFERENCE BETWEEN THEM
         CALL XSUBTR (CENTN,CENTO,DELCNT,3)
         CALL XADDR (CENTN,CENTO,ROOTO,3)
         CALL XMULTR (ROOTO,0.5,AVCNT,3)
         IF (IMATRIX .LT. 0) THEN
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
         ENDIF
c
         IF (IPCHRE.GE.0)THEN
          IF (INTSYM.EQ.0) THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1    'Asymmetric'
          END IF
c
         WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,6(A,F9.4))')
     1   char(9),':Centroids ',
     1   (CHAR(9),CENTO(I),I=1,3),(CHAR(9),CENTN(I),I=1,3)
         CALL XCREMS(CPCH,CPCH,LENFIL)
        END IF
cdjwfeb08
C 
C -- CALCULATE THE BEST PLANE THROUGH THE ATOMS IN EACH GROUP
c    wspac1 amd 2 are just work space
C 
         I=KMOLAX(STORE(LOLD),NOLD,MDOLD,WSPAC1(1,1),ROOTO(1),VECTO(1,1)
     1    ,COSNO(1,1),WSPAC2(1,1))
C 
         I=KMOLAX(STORE(LNEW),NNEW,MDNEW,WSPAC1(1,1),ROOTN(1),VECTN(1,1)
     1    ,COSNN(1,1),WSPAC2(1,1))
C-----

         IF (IMATRIX .LT. 0) THEN
          IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,250) ROOTO,ROOTN
          END IF
250       FORMAT (/1X,' Principal moments of inertia of old and new',
     1    ' groups',//1X,2(10X,3F8.3),//)
          WRITE (CMON,300) ROOTO,ROOTN
          CALL XPRVDU (NCVDU,2,0)
300       FORMAT (1X,'Principal moments of inertia of old and new',
     1    ' groups',/1X,2(3F8.3,3X))
         ENDIF
c
c
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,6(A,F9.2))')
     1    Char(9),':Axes of Inertia ',
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
Cdjwapr2001
      IF (IMATRIX.LE.0) THEN
C -- CALCULATE BEST FIT MATRIX BY CALLING THE APPROPRIATE ROUTINE
         GO TO (400,450,500,500,600,2250),IMETHD
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
         CALL XRGCKB (imethd,RESULT(1,1))
         GO TO 550
C 
600      CONTINUE
C -- ROTATION MATRIX SET TO UNIT (IDENTITY) MATRIX
         CALL XUNTM(RESULT,3)
         GOTO 550
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
C -- PREMULT FOR ORTHOGONALISATION MATRIX FOR Uij
            CALL DMATRX(DMATRIX)
C -- GET ROTATION MATRIX FOR OLD Uij IN BP SYSTEM
            CALL XMLTMM(CFBPOL, DMATRIX, TEMP1, 3,3,3)            
C -- GET ROTATION MATRIX FOR NEW UiJ IN OLD BP SYSTEM
            CALL XMLTMM(CFBPNE, DMATRIX, TEMP3, 3,3,3)            
            CALL XMLTMM(RESULT, TEMP3, TEMP2, 3,3,3)            

C   U(bp,old) = temp1. U, temp1(T)
c   U(bp,new) = temp2, U, temp2(T)
c
C 
C -- COMPLETE CALCULATION
C -- BEFORE APPLYING THE CALCULATED MATRIX TO THE 'NEW' COORDINATES, A
C    CHECK MUST BE DONE , IN CASE THE MATRIX WILL LEAVE THE ROTATION OF
C    SOME ATOMIC COORDINATES UNDEFINED.
C 
         MNEW=LNEW+(NNEW-1)*MDNEW
         IDEFIN=1
         DO 700 I=1,3
            DEFIND=RESULT(1,I)+RESULT(2,I)+RESULT(3,I)
            IF (ABS(DEFIND).GT.(3*ZERO)) GO TO 700
C --        ROTATION FOR THIS COORDINATE IS UNDEFINED. THIS IS HOWEVER OK
C           IF THERE ARE NO NON-ZERO VALUES FOR THIS COORDINATE
            DO 650 J=LNEW,MNEW,MDNEW
               INDNEW=J+I
               IF (ABS(STORE(INDNEW)).GT.ZERO) GO TO 650
C -- ERROR
               NUMATM=((J-LNEW)/MDNEW)+1
               WRITE (CMON,630) CAXIS(I),NUMATM
               CALL XPRVDU (NCVDU,1,0)
               IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') trim(CMON(1))
630            FORMAT (1X,'Rotation of ',A1,' coordinate is undefined ',
     1          ' for atom number ',I5)
               IDEFIN=-1
650         CONTINUE
700      CONTINUE
         IF (IDEFIN.LT.0) GO TO 2300
      END IF
C 
CDJWAPR2012
c      MOLD=LOLD
c      MNEW=LNEW
c      MUIJ=LUIJ+1
c      MOUIJ=LOUIJ+1
c      write(123,'(/a)') 'before'
c      write(123,*) nold, lold, lnew, louij, luij
c      DO I=1,NOLD
c      write(123,1230)
c     1 store(mold),store(mold+1),store(mold+2),
c     2 store(mouij),store(mouij+1),store(mouij+2),
c     3 store(mouij+3),store(mouij+4),store(mouij+5),
c     1 store(mnew),store(mnew+1),store(mnew+2),
c     2 store(muij),store(muij+1),store(muij+2),
c     3 store(muij+3),store(muij+4),store(muij+5)
c      MOLD=MOLD+MDOLD
c      MNEW=MNEW+MDNEW
c      MUIJ=MUIJ+MDUIJ
c      MOUIJ=MOUIJ+MDOUIJ
c      ENDDO
1230  format(2(3f6.3,3x,6f6.3,3x))

comments djwapr2010
C -- MATRIX CHECKED. APPLY MATRIX TO COORDINATES
C -- APPLIES XMATR TO ATOMS(MDATM,NATM)
c    ATOMS(1,j) is X etc, are overwritten
      CALL XMXRTI (STORE(LNEW),RESULT,MDNEW,NNEW)
c  now do Uij
C   U(bp,old) = temp2. U, temp2(T)
c   U(bp,new) = temp1, U, temp1(T)
      call rmxuij (temp1, louij,  mdouij,  nold)
      call rmxuij (temp2, luij, mduij, nold)
C 
CDJWAPR2012
c      MOLD=LOLD
c      MNEW=LNEW
c      MUIJ=LUIJ+1
c      MOUIJ=LOUIJ+1
c      write(123,'(/a)') 'after'
c      write(123,*) nold, lold, lnew, louij, luij
c      DO I=1,NOLD
c      write(123,1230)
c     1 store(mold),store(mold+1),store(mold+2),
c     2 store(mouij),store(mouij+1),store(mouij+2),
c     3 store(mouij+3),store(mouij+4),store(mouij+5),
c     1 store(mnew),store(mnew+1),store(mnew+2),
c     2 store(muij),store(muij+1),store(muij+2),
c     3 store(muij+3),store(muij+4),store(muij+5)
c      MOLD=MOLD+MDOLD
c      MNEW=MNEW+MDNEW
c      MUIJ=MUIJ+MDUIJ
c      MOUIJ=MOUIJ+MDOUIJ
c      ENDDO
c
C find the determinant
         DETMAT=XDETR3(WSPAC3)
Cdjwapr2001
C -- PRINT COORDINATES AFTER FITTING AND THE DEVIATIONS BETWEEN THEM
C 
      IF (IMATRIX.LE.0) then
      CALL XRGPCS(IMATRIX)
C 
C----- WRITE THE IMPORTANT MATRICES AND VECTORS
         IF (IMATRIX.LT.0) THEN
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
         ENDIF
C
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,6(A,F9.4))')
     1    char(9),':Mean & Delta Centroids', 
     1    (CHAR(9),AVCNT(I),I=1,3),(CHAR(9),DELCNT(I),I=1,3)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF
C 
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,9(A,F9.3))')
     1    char(9),':Transformation ',
     1    ((CHAR(9),WSPAC3(I,J),I=1,3),J=1,3)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF

CDJWMAR2000
C FIND PSEUDO OPERATOR - GIACOVAZZO, Section 1.d
C      GET THE DETERMINANT AND TRACE
         DET = DETMAT
         TRACE=WSPAC3(1,1)+WSPAC3(2,2)+WSPAC3(3,3)
C Output determinant and trace
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,2(A,F7.4))')
     1    char(9), ':Det and trace ',
     1    CHAR(9),DET,CHAR(9),TRACE
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF
         DETTRC=DET+TRACE


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
     
C Work out closeness to a group operator.
          CALL XMLTMM(WSPAC3,DELCNT,ATEMP,3,3,1)
          CALL XADDR(DELCNT,ATEMP,ATEMP,3)
C ATEMP should be some kind of unit translation.
          CLOSEN = 0.0
          DO IJ = 1,3
           CLOSEN = CLOSEN + ( ATEMP(IJ) - NINT(ATEMP(IJ)))**2 
          END DO
          CLOSEN = SQRT(CLOSEN/3.0)
c
         IF (IPCHRE.GE.0)THEN

          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,A,F13.5)')
     1    char(9), ':Closeness to ideal rotation', 
     1    CHAR(9),SQRT(CLOSEX/9.0)
          CALL XCREMS(CPCH,CPCH,LENFIL)
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,A,F13.5)')
     1    char(9), ':Closeness to group operator', 
     1    CHAR(9),CLOSEN
          CALL XCREMS(CPCH,CPCH,LENFIL)
         endif

C Output the atemp vector for inspection:
         if ((ilstre .eq. 3) .and. (ipchre .ge. 0)) then
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,3(F8.3))')
     1    'Atemp vector',
     1    (ATEMP(IJ),IJ=1,3)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         endif

C Combine both measures above
          DO IJ = 1,3
           CLOSEX = CLOSEX + (   ATEMP(IJ) - NINT( ATEMP(IJ) )   )**2
          END DO

         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(a,a,A,F13.5)')
     1    CHAR(9), ':Combined measure of closeness',
     1    CHAR(9),SQRT(CLOSEX/12.0)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         endif

C THIS IS IT. See how well operator fits into current space group.

C 1) Fill in the first half of the  array at LSGT
C    with all the operators of the current space group.
C
C    Fill in the second half of the array with the current operators
C    times the 'new' potential operator.

          MSGT = LSGT  ! Currect matrix to fill in.
          MLTPLY = 2 * N2 * N2P * ( IC + 1 ) ! Twice current multiplicity.
          NMSGT = LSGT + MLTPLY * 8         ! Offset for 2nd half of array

C Store potential new operator in OPN
          DO K2 = 1,3
           DO K3 = 1,3
            OPN(K3,K2) = NINT(WSPAC3(K3,K2))
           END DO
           OPN(4,K2) = 0.0
          END DO
c
C Anna: Work out translation part by applying rotation to the NEW centroid
C (CENTN) and then subtracting from the OLD centroid (CENTO).
C WSPAC3, or R, transforms from NEW to OLD, but is missing the translation part
C if we call Co the old centroid and Cn the new centroid, then the transform
C must be  Xold - Cold = R * ( Xnew - Cnew )
C thus, Xold = ( R * Xnew ) - ( R * Cnew ) + Cold
C Co - ( R * Cnew ) 

          CALL XMLTMM(WSPAC3,CENTN,ATEMP,3,3,1)
          CALL XSUBTR (CENTO,ATEMP,OPN(1,4),3)
          OPN(4,4) = 1.0

C Use OPM for building existing ops
          DO K2=1,3
            OPM(4,K2) = 0.0
          END DO
          OPM(4,4) = 1.0

          DO M2 = L2,L2+MD2*(N2-1),MD2 ! Loop over each symmetry matrix
C Get the matrix, the rotation is stored transposed!
            DO K4=0,2
              DO K5 = 0,2
                OPM(K5+1,K4+1) = STORE(M2+3*K5+K4)
              END DO
            END DO
C Copy the translation part into row 1 col 4
            CALL XMOVE(STORE(M2+9),OPM(1,4),3)

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
C Multiply new op by old one, and store in 2nd half of LSGT array.
                CALL XMLTMM(STORE(MSGT),OPN(1,1),STORE(NMSGT),4,4,4)
                MSGT =  MSGT + 16  ! Advance to next matrix.
                NMSGT = NMSGT + 16 ! Advance to next matrix.
              END DO
            END DO
          END DO


C Debug: Print out the generators.

          if (ilstre .ge. 3) then
          DO K1 = 0, (MLTPLY/2) - 1
            K2 = LSGT + K1 * 16
            K3 = LSGT + ( K1+(MLTPLY/2) ) * 16 
            WRITE(NCWU,'(/2X,2(I4,'':'',42X))'),K1, K1 + (MLTPLY/2)
            WRITE(NCWU,'(4(2(4F9.3,8X)/))')
     1          ( (STORE(K2+J2+J3),J2=0,12,4),
     1            (STORE(K3+J2+J3),J2=0,12,4), J3=0,3)
          END DO
          endif
C 2) We now have N operators. We know that the first N/2, multiplied
C    by themselves will give only existing ops, so they can be ignored.
C    We loop through doing the product of all new generators with
C    all generators.
C 3) For each product, find the best match among all the generators,
C    store the worst of the best matches so far.

C Store potential new operator in OPN
          DO K2 = 1,3
            CALL XMOVE(WSPAC3(1,K2),OPN(1,K2),3)
            OPN(4,K2) = 0.0
          END DO
C Anna: Work out translation part by applying rotation to the NEW centroid
C (CENTN) and then subtracting from the OLD centroid (CENTO).

          CALL XMLTMM(WSPAC3,CENTN,ATEMP,3,3,1)
          CALL XSUBTR (CENTO,ATEMP,OPN(1,4),3)
          OPN(4,4) = 1.0


          RWORST = -9999999.0
          RAVERAGE = 0.0
          NRCOMP = 0
          CALL XFILL (-1,IBMA(1),16)

          DO K1 = 1,2  ! Once for the new gen (OPN), once for its inverse

C Form product (OPM) of new OP (OPN) with all generators (LSGT 1-N):

            DO K2 = LSGT,LSGT+(MLTPLY-1)*16,16            ! All generators
              CALL XMLTMM(OPN(1,1),STORE(K2),OPM(1,1),4,4,4) ! Product


C Find best match for product (OPM) with all generators (LSGT 1-N)

              BEST = 9999999.0
              DO K3 = LSGT,LSGT+(MLTPLY-1)*16,16             ! All generators

C Shift translations of matrix in OPM so that they are as close as
C poss to the entries at K3. (e.g. 0.01 and 0.98 *should* be close)
C The largest possible delta in a periodic function like this is 0.5.

                  DO K4 = 1,3
                    DO WHILE ( OPM(K4,4) - STORE(K3+11+K4) .LT. -0.5 )
                      OPM(K4,4) = OPM(K4,4) + 1.0
                    END DO
                    DO WHILE ( OPM(K4,4) - STORE(K3+11+K4) .GT. 0.5 )
                      OPM(K4,4) = OPM(K4,4) - 1.0
                    END DO
                  END DO

C Do the comparison.
                  RMAT = CMPMAT(STORE(K3),OPM(1,1),16)
                  IF ( RMAT .LT. BEST ) THEN
                    BEST = RMAT
                    IF ( NRCOMP .LT. 16 ) THEN       !Store match
                      IBMA(NRCOMP+1) = (K3-LSGT)/16
                    END IF
                  END IF
              END DO
              if (ilstre .ge. 3) then
              WRITE(NCWU,'(A,I2,A,F9.4)')'Best match for ( OP#',
     1        (K2-LSGT)/16,' ) x OPN is:',BEST
CDJWNOV07              CALL XPRVDU(NCVDU,1,0)
              endif
              IF ( BEST .GT. RWORST ) THEN
                RWORST = BEST
                IWORS = NRCOMP
              END IF

              RAVERAGE = RAVERAGE + BEST  ! Average of best for row
              NRCOMP = NRCOMP + 1

            END DO



C Invert new op (OPN) ready for second loop.
            CALL XMOVE ( OPN(1,1), OPM(1,1), 16 )
c            CALL XMXMPI ( OPM(1,1), OPN(1,1), 4 )
            I=KINV2(4,OPM(1,1),OPN(1,1),16,0,OTEMP,OTEMP,4)

            if (ilstre .ge. 3) then
            WRITE(NCWU,'(/2X,''OPN:'',42X,''inv(OPN):'')')
CDJWNOV07            CALL XPRVDU(NCVDU,2,0)
            WRITE(NCWU,'(4(2(4F9.3,8X)/))')
     1            ( (OPM(J2,J3),J3=1,4),
     1              (OPN(J2,J4),J4=1,4), J2=1,4)
CDJWNOV07            CALL XPRVDU(NCVDU,4,0)
            endif

            IF ( I .GT. 0 ) THEN
              WRITE(CMON,'(/''Singular operator matrix found'')')
              CALL XPRVDU(NCVDU,2,0)
              IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(2))

              IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A,A)') 
     1    CHAR(9),'Singular_operator_cannot_be_inverted'
              WRITE(CPCH(LENFIL+1:),'(2A)')
     1    CHAR(9),'Singular_operator_cannot_be_inverted'
              CALL XCREMS(CPCH,CPCH,LENFIL)
              EXIT
            END IF
          END DO


          RAVERAGE = RAVERAGE / FLOAT(NRCOMP)

        if (ipchre .ge. 0)  then
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1    CHAR(9),':Rworst & Raverage'
          CALL XCREMS(CPCH,CPCH,LENFIL)

          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,F13.9)')
     1    CHAR(9),RWORST
          CALL XCREMS(CPCH,CPCH,LENFIL)

          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,F13.9)')
     1    CHAR(9),RAVERAGE
          CALL XCREMS(CPCH,CPCH,LENFIL)

          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,I3)')
     1    CHAR(9),IWORS
          CALL XCREMS(CPCH,CPCH,LENFIL)

c          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(16(A,I3))')
c     1    (CHAR(9),IBMA(K3),K3=1,16)
c          CALL XCREMS(CPCH,CPCH,LENFIL)
        endif
        if ((ilstre .ge. 3) .AND. (ISSPRT .EQ. 0)) then
          WRITE(NCWU,'(A,F9.4,A,I3)')'Lowest best match in last row: ',
     1     RWORST, ' to op# ', IWORS
CDJWNOV07          CALL XPRVDU(NCVDU,1,0)
          WRITE(NCWU,'(A,F9.4)')'Average best in last row: ',RAVERAGE
CDJWNOV07          CALL XPRVDU(NCVDU,1,0)
        endif
c
cdjwmay09
         IF (IMATRIX.LT.0) THEN
          write(cmon,1049) trace, det, dettrc
1049      format(/' Trace =',f6.3,' Determinant =',f6.3,
     1    ' Tr+Det =',f6.3/' see Giacovazzo, Sect 1.D',/
     2    ' Element:  1  2  3  4  6 -1 -2 -3 -4 -6'/
     3    ' Tr_det:   4  0  1  2  3 -4  0 -1 -2 -3')
          IF ((IFLCMP .EQ. 2).OR.(IFLCMP .EQ. 5).OR.
     1    (IFLCMP .EQ. 6))  THEN
            CALL XPRVDU (NCVDU,5,0)
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') trim(CMON(1)),
     1      trim(CMON(2)),trim(CMON(3)), trim(CMON(4)),trim(CMON(5))
          ENDIF
         ENDIF
c
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1    CHAR(9),':Symmetry'
          CALL XCREMS(CPCH,CPCH,LENFIL)

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
c         
cdjwmay09         IF (ABS(1.-ABS(DET)).LE..05) THEN
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
            IF (IMATRIX.LT.0) THEN
             WRITE(CMON,'(1X/A,15A4)') '{I', (KTITL(I),I=1,15)
             CALL XPRVDU(NCVDU,2,0)
             CMON(1) = ' '
             WRITE (CMON(2),1050) CSYM(1:2)
1050         FORMAT ('{I  Pseudo-symmetry element ',A2,' detected')
             IF ((IFLCMP .EQ. 2).OR.(IFLCMP .EQ. 5).OR.
     1      (IFLCMP .EQ. 6))  THEN
               CALL XPRVDU (NCVDU,2,0)
               IF (ISSPRT.EQ.0) WRITE (NCWU,'(/A/)') 
     1            CMON(2)(3:len_trim(CMON(2)))
             ENDIF
            ENDIF
c
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':Pseudo'
             CALL XCREMS(CPCH,CPCH,LENFIL)
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(2A)')
     1       CHAR(9),CSYM(1:2)
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
c
         ELSE
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(4A)')
     1       CHAR(9),':Pseudo',CHAR(9), 'none'
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
         END IF
C 
C 
         DO 1150 J=1,3
            ITEMP(J)=10
            DO 1100 I=1,3
               IF (ABS(1.-ABS(WSPAC3(I,J))).LE.0.05) ITEMP(J)=I*
     1          INT(SIGN(1.,WSPAC3(I,J)))
1100        CONTINUE
1150     CONTINUE
         IF ((IFLCMP .EQ. 2).OR.(IFLCMP .EQ. 5).OR.
     1   (IFLCMP .EQ. 6))  THEN
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
            IF (IMATRIX.LT.0) THEN
              WRITE (CMON,1250) (ATEMP(J),CTEMP(J),J=1,3)
              CALL XPRVDU (NCVDU,1,0)
1250          FORMAT ('{I  Pseudo-symmetry operator of form :-  ',
     1        3(F6.2,A2,2X))
              IF (ISSPRT.EQ.0) WRITE (NCWU,'(/A/)') 
     1          CMON(1)(3:len_trim(CMON(1)))
            ENDIF
            IF (IPCHRE.GE.0)THEN

             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':Operator'
             CALL XCREMS(CPCH,CPCH,LENFIL)

             WRITE(CPCH(LEN_TRIM(CPCH)+1:),
     1       '(A,3(F6.2,A2,2X))') CHAR(9),(ATEMP(J),CTEMP(J),J=1,3)
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
          ELSE
            IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(4A)')
     1       CHAR(9),':Operator', CHAR(9),'none'
             CALL XCREMS(CPCH,CPCH,LENFIL)
            END IF
          END IF
         ENDIF

C Output number of atoms.
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1    CHAR(9),':No_Atoms'
          CALL XCREMS(CPCH,CPCH,LENFIL)
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,I6)')
     1    CHAR(9),NOLD
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF

C Output space group symbol.
         IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':S.G.'
             CALL XCREMS(CPCH,CPCH,LENFIL)

          J  = L2SG + MD2SG - 1
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,4(1X,A4))')
     1    CHAR(9),(ISTORE(I), I = L2SG, J)
          CALL XCREMS(CPCH,CPCH,LENFIL)
         END IF

C Output cell.
         IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':Cell'
             CALL XCREMS(CPCH,CPCH,LENFIL)

          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(3(A,F9.4))')
     1    (CHAR(9),STORE(I), I = L1P1, L1P1+2)
          CALL XCREMS(CPCH,CPCH,LENFIL)
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(3(A,F9.4))')
     1    (CHAR(9),STORE(I)*rtd, I = L1P1+3, L1P1+5)
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
         IF (IMATRIX.LT.0) THEN
          IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,1350)
          END IF
1350      FORMAT (/' New atom coordinates in crystal fractions ')
          DO 1450 I=1,NNEW
            INDATM=LATMD+(I-1)*MDATMD
            INDNEW=LNEW+(I-1)*MDNEW
            IF (ISSPRT.EQ.0) THEN
               WRITE (NCWU,1400) STORE(INDATM),STORE(INDATM+1),
     1          STORE(INDNEW),STORE(INDNEW+1),STORE(INDNEW+2)
            END IF
1400        FORMAT (1X,A4,3X,F5.0,5X,3(F8.4,5X))
1450      CONTINUE
         ENDIF
Cdjwapr2001
      ELSE IF ( IMATRIX .EQ. 1 ) THEN
            CALL XRGRNM
      ELSE IF ( IMATRIX .EQ. 2 ) THEN
            CALL XRGCAM
      ELSE
            CALL XRGMAT(LSPARE)
      END IF

C -- CHECK REPLACE/COMPARE/KEEP FLAG, TO DETERMINE WHETHER LIST 5
C    SHOULD BE CHANGED.
C    1          2          3          4           5          6
C    (REPLACE)  (COMPARE)  (KEEP)    (AUGMENT)   (RENAME)   (CAMERON)
C
      GO TO (1500,1750,1500,1500,1740,1741),IFLCMP
1500  CONTINUE
C    SOME KIND OF UPDATING (REPLACE, KEEP, AUGMENT)
      IF (NOccIN .GT. 0) THEN
        GPOCC = SUMOCC/FLOAT(NOccIN)
      ELSE
        GPOCC = 1.1
      ENDIF
C -- COPY COORDINATES BACK TO ATOM DEFINTION BLOCK
      DO I=1,NATMD
C -- CALCULATE THE POSITIONS TO MOVE THE COORDINATES BETWEEN
        INDATM=LATMD+(I-1)*MDATMD  
        INDNEW=LNEW+(I-1)*MDNEW
        CALL XMOVE (STORE(INDNEW),STORE(INDATM+4),3)
c
        INDUIJ=LUIJ+(I-1)*MDUIJ
c        CALL XMOVE (STORE(INDUIJ+1),STORE(INDATM+7),6)
        IF(STORE(INDATM+13) .LE. ZERO) THEN
            STORE(INDATM+2) = GPOCC
            STORE(INDATM+3) = 1
            STORE(INDATM+7) = 0.0501
        ENDIF
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
CDJWDEC07
cdjwapr2010
c - Add offset to serial
         KDJW = IADDR
         DO IDJW = 1,NATMD
          STORE(KDJW+1) = STORE(KDJW+1) + DKEEP
          KDJW = KDJW + MDATMD
         ENDDO
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

      DO 1748 I = 1,N5
        KTYPE = ISTORE(L5+(I-1)*MD5)
        KSERIL = NINT(STORE(L5+(I-1)*MD5+1))
        DO J = 1, NATMD
         IF( KTYPE .NE. ISTORE(LRENM+(J-1)*MDRENM) ) CYCLE
         IF( KSERIL.NE. NINT(STORE(LRENM+(J-1)*MDRENM+1)) ) CYCLE
c         WRITE(CMON,'(A,2I5,A,I5,A,I5)') 'Changing: ',I,J,
c     1    KTYPE,KSERIL,
c     2    STORE(LRENM+(J-1)*MDRENM+4),NINT(STORE(LRENM+(J-1)*MDRENM+5))
c          CALL XPRVDU(NCVDU,1,0)
         CALL XMOVE (STORE(LRENM+(J-1)*MDRENM+4), STORE(L5+(I-1)*MD5),2)
         ISTORE(LRENM+(J-1)*MDRENM) = 0
         ISTORE(LRENM+(J-1)*MDRENM+1) = 0 
         GOTO 1748                         !Only match once.
        END DO
1748  CONTINUE
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
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') trim(CMON(1))
2000  FORMAT (' Too few old atom positions have been given -',I5)
      CALL XERHND (4)
      RETURN
2050  CONTINUE
      WRITE (CMON,2100) NNEW
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') trim(CMON(1))
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
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') trim(CMON(1))
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
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') trim(CMON(1))
2350  FORMAT (1X,'Attempt to change undefined coordinates')
      CALL XERHND (IERERR)
      GO TO 2150
C 
      END


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
      dimension djwa(3),djwb(3),djwc(3)
C --
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCONST.INC'
C --
C --
      IF (ISSPRT .EQ. 0) WRITE (NCWU,1100)
1100  FORMAT ( 1X , 'Calculation of rotation-dilation matrix ' ,
     2 'and decomposition into component parts' , / )
C --
C -- CALCULATE ROTATION DILATION MATRIX
C --

C
C
C   Xold = RD * Xnew
C   Xold * XnewT = RD * Xnew * XnewT
C   Xold * XnewT * ( Xnew * XnewT )^-1 = RD

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
c

c      goto 11111

cdjw-nov05
      toler=0.1
      if (abs(det3) .le. toler) then
        write(cmon,'(a,f12.6)') 
     1  ' Excessive contraction. Determinant =', det3
        call xprvdu(ncvdu,1,0)
        if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
            djwa(1)=rotdil(1,1)
            djwa(2)=rotdil(1,2)
            djwa(3)=rotdil(1,3)
c
            djwb(1)=rotdil(2,1)
            djwb(2)=rotdil(2,2)
            djwb(3)=rotdil(2,3)
c
            if (ncrop3(djwa, djwb, djwc) .lt. 0) then
             djwc(1)=0.
             djwc(2)=0.
             djwc(3)=1.
            endif
        write(cmon,'(a,3(/12x,3f12.6))')' Original matrix',rotdil
        call xprvdu(ncvdu,4,0)
        if (issprt .eq. 0) write (ncwu,'(a)') (trim(CMON(i)),i=1,4)
            rotdil(3,1)=djwc(1)
            rotdil(3,2)=djwc(2)
            rotdil(3,3)=djwc(3)
        write(cmon,'(a,3(/12x,3f12.6))')' Modified matrix',rotdil
        call xprvdu(ncvdu,4,0)
        if (issprt .eq. 0) write (ncwu,'(a)') (trim(CMON(i)),i=1,4)
      endif
      det3 = xdetr3(rotdil)
c djwdec05 These are not always fixing the problem. Skip round them
c jan08      goto 12345
c      The December 05 fix had the repercussion of distorting the
c      rotation matrix, leading to distorsions in the model. The
c      orignal 1988 code has been restored for the moment.  The
c      problem remains of preventing instability when invertng the 
c      dilation matrix in order to extract the rotation matrix
c
c      The old fix assumes that the main dilations will be roughly
c      along the inertial axes. This is not always true.
c
11111  continue

      IF (ABS(ROTDIL(1,1)) .LE. 0.0001*NNEW) then 
       write(cmon,'(a,f12.6)') 'Fixing Rotdil(1,1) - old value =',
     1 rotdil(1,1) 
       call xprvdu(ncvdu,1,0)
       if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
       ROTDIL(1,1)=
     1 SQRT(1.-ROTDIL(1,2)*ROTDIL(1,2)-ROTDIL(1,3)*ROTDIL(1,3))
      endif
C
      IF (ABS(ROTDIL(2,2)) .LE. 0.0001*NNEW) THEN
        WRITE(CMON,1300) ROTDIL(2,2)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
1300    FORMAT(1X, 'One group is almost colinear - sigma(Y**2) = '
     1  ,F12.8)
       write(cmon,'(a,f12.6)') 'Fixing Rotdil(2,2) - old value =',
     1 rotdil(2,2) 
       call xprvdu(ncvdu,1,0)
       if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
c
C Sqrt may be negative above, try this instead:
        ROTDIL(2,2)=SIGN( SQRT(ABS(1.-ROTDIL(2,1)*ROTDIL(2,1)-
     1  ROTDIL(2,3)*ROTDIL(2,3))), ROTDIL(2,2))
      END IF
C
      IF (ABS(ROTDIL(3,3)) .LE. 0.0001*NNEW) THEN
        WRITE(CMON,1200) ROTDIL(3,3)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
1200    FORMAT(1X, 'One group is almost coplanar - sigma(Z**2) = '
     1  ,F12.8)
       write(cmon,'(a,f12.6)') 'Fixing Rotdil(3,3) - old value =',
     1 rotdil(3,3) 
       call xprvdu(ncvdu,1,0)
       if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
c Sqrt may be negative, try this:
        ROTDIL(3,3)= SQRT(ABS(1.-ROTDIL(3,1)*ROTDIL(3,1)-
     1  ROTDIL(3,2)*ROTDIL(3,2)))
        DETR = XDETR3(ROTDIL)
        IF ( SIGN(1., DET3*DETR) .LT. 0.) ROTDIL(3,3) = -ROTDIL(3,3)
      END IF
12345  continue
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
      IF (UVEC(I) .gt. zero)  UVEC(I)=SQRT(UVEC(I))
c
cjan08 - move fixing problem until after rotation found.
c
7100  CONTINUE
c
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
cdjwdec05. Try to fix the problem via the eigenvalues
cjan08 now try to fix up dilation
c
c      This all needs a re-think.  We need an algorithm which finds a
c      proper or improper rotation directly, without any implied 
c      dilation.
Cdone - feb08 - Kabsch method 4
c
c      if(uvec(i) .gt. 1.2)  then
c         write(cmon,'(a,i2,f12.6,a )') 
c     1   ' Excessive dilation. Eigenvalue',i,uvec(i),' reset to unity'
c          call xprvdu(ncvdu,1,0)
c          if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
c         uvec(i)=1.0
c      elseif (uvec(i) .lt. 0.8) then
c         write(cmon,'(a,i2,f12.6,a )') 
c     1   ' Excessive contraction. Eigenvalue',
c     2     i,uvec(i),' reset to unity'
c          call xprvdu(ncvdu,1,0)
c          if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
c         uvec(i)=1.0
c      endif
c
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
      SUBROUTINE XRGCKB(imethd, RESULT)
c
C   Find transformation by Kabsch Method, Acta Cryst 1976, A32, 922-923
c                                         Acta Cryst 1978, A43, 828-829
c
c      imethd 3 = pure rotation
c      imethd 4 = permit rotary inversion
c
      DIMENSION RESULT(3,3)
      DIMENSION WSPAC1(3,3),WSPAC2(3,3),WSPAC3(3,3)
      DIMENSION VMAT(3,3),UVEC(3)
      DIMENSION SIG(3)
C --
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
C --
        write(cmon,1500) 
        call xprvdu(ncvdu,1,0)
        if (issprt .eq. 0) write (ncwu,'(a//)') trim(CMON(1))
1500  FORMAT (' Calculation of rotation matrix by Kabsch method  ')
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
      CALL XMLTMM (WSPAC3(1,1),WSPAC1(1,1),WSPAC2(1,1),3,3,3)

C -- U,V = EIGENVALUES,VECTORS OF T
      CALL XMXEGV(WSPAC2(1,1),VMAT(1,1),UVEC(1))
C -- INTERCHANGE COLUMNS 1 AND 3 SO THAT EIGENVALUES
C    ARE IN DESCENDING ORDER
      CALL XINT2 (3,VMAT(1,1),9,UVEC(1),3,1,3,1)
c -- ENSURE RIGHTHANDED SYSTEM
      DET=XDETR3(VMAT)
C -- SET THIRD VECTOR TO CROSS PRODUCT OF OTHER TWO
      I=NCROP3 (VMAT(1,1),VMAT(1,2),VMAT(1,3))
c
c
c
C -- B=RV
      CALL XMLTMM(WSPAC1(1,1),VMAT(1,1),WSPAC3(1,1),3,3,3)
C -- NORMALISE B VECTORS AND FORM CROSS PRODUCT
      J=NORM3(WSPAC3(1,1))
      J=NORM3(WSPAC3(1,2))
      VLEN=
     1 WSPAC3(1,3)*WSPAC3(1,3)+WSPAC3(2,3)*WSPAC3(2,3)+
     2 WSPAC3(3,3)*WSPAC3(3,3)
c -- check not co-planar
      if(vlen .le. zerosq) 
     1 I=NCROP3 (WSPAC3(1,1),WSPAC3(1,2),WSPAC3(1,3))
      J=NORM3(WSPAC3(1,3))
      DETB=XDETR3(WSPAC3(1,1))

      if (detb .le. 0.0) then
         write(cmon,'(a,f12.6)') 
     1  '{I Best match involves inversion, determinant  =', detb
         call xprvdu(ncvdu,1,0)
         if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
      endif
      IF ((DETB.LT.0) .AND. (IMETHD .EQ.3)) THEN
         SIG(3)=-1.
         write(cmon,'(a)') 
     1  ' Ensuring pure rotation'
         call xprvdu(ncvdu,1,0)
         if (issprt .eq. 0) write (ncwu,'(a)') trim(CMON(1))
         I=NCROP3 (WSPAC3(1,1),WSPAC3(1,2),WSPAC3(1,3))
      ENDIF

C -- U=B*TRANSPOSE(V)
      CALL XMLTMT (WSPAC3(1,1),VMAT(1,1),RESULT(1,1),3,3,3)
C -- CALCULATE E
      E=E0
      DO 2050 I=1,3
      IF (UVEC(I) .LT. 0.0001) GO TO 2050
      E=E-SIG(I)*UVEC(I)
2050  CONTINUE
c
cdjw 2012 it looks as if Kabsch gives the reanspose of the matrix we 
c         need

      CALL MTRANS(RESULT)

      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 2105 ) RESULT
      ENDIF
2105  FORMAT ( 1X , 'Rotation Matrix' , / ,
     2 3 ( 1X , 3F10.5 , / ) )
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
c
c    for short-term convenience, the UIJ and the OCC values are saved
c    in separate blocks.
C
C----- ICODE 1 = GROUP
C            2 = COMPUTE
C --
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
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
      LOUIJ=KSTALL(NATMD*MDOUIJ)
      LOCC=KSTALL(NATMD*MDOCC)
cdjwapr2010 CLEAR OUT AREA
      CALL XZEROF(STORE(LATMD),NATMD*MDATMD)
      CALL XZEROF(STORE(LOLD),NATMD*MDOLD)
      CALL XZEROF(STORE(LNEW),NATMD*MDNEW)
      CALL XZEROF(STORE(LUIJ),NATMD*MDUIJ)
      CALL XZEROF(STORE(LOUIJ),NATMD*MDOUIJ)
      CALL XZEROF(STORE(Locc),NATMD*MDOCC)
C
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
      SUBROUTINE XRGPLA( PLATOM, NLATOM, XMATR,ITYPE)
C -- SET UP AN ENTRY FOR EACH NEW ATOM IN THE GROUP
C    PLATOM( ) CONTAINS THE DETAILS OF THE ATOM IN THE USUAL LIST 5
C    FORMAT. THE ROTATION MATRIX XMATR(9) IS APPLIED TO THE COORDINATES
C    A ORIGIN SHIFT AND GENERAL ROTATION MATRIX ARE ALSO APPLIED
CDJWJUN09
C    ITYPE - 0 = OLD ATOMS
C            1 = NEW ATOMS
      DIMENSION XMATR(9), PLATOM(NLATOM)
      DIMENSION TEMP(3)
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XIOBUF.INC'
c
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
C --
c    platom are 'new'atoms (1)=type, (3)=occ, (4)=flag, (8)=u11
c
C -- INCREMENT NEW ATOM COUNT
      NNEW=NNEW+1
      IF ((NATMD.NE.0) .AND. (NNEW.GT.NATMD)) GO TO 9500
C -- SET (TEMPORARILY) ORIGIN TO ZERO
      CALL XZEROF(ORIGIN(1),3)
C -- CALCULATE WHERE THIS ATOM IS GOING TO GO
      INDATM=LATMD+(NNEW-1)*MDATMD
      INDNEW=LNEW+(NNEW-1)*MDNEW
      INDUIJ=LUIJ+(NNEW-1)*MDUIJ
      INDOCC=LOCC+(NNEW-1)*MDOCC
C    FIRST, SET UP NEW COORDINATES
C -- APPLY REQUIRED MATRIX TO COORDINATES
      CALL XMLTMM (XMATR(1),PLATOM(5),TEMP(1),3,3,1)
C -- APPLY OFFSET TO COORDINATES
      CALL XSUBTR (TEMP(1),ORIGIN(1),STORE(INDATM+4),3)
C -- COPY COORDINATES TO APPROPRIATE PLACE
      CALL XMOVE (STORE(INDATM+4),STORE(INDNEW),3)
c Uij?
c                   what about the matrix transformation to Uij (DJW-2017)
      call xmove (platom(8),store(induij+1),6) 
      call xmove (platom(4),store(induij),1)
C -- SET WEIGHT FOR THIS ATOM TO 1
      STORE(INDNEW+3)=1.
cdjw-17
c      write(123,'(a,2i6,17f10.3)') 
c     1 'Lnew',lnew, induij, (store(i),i=induij+1,induij+7)
c
      RETURN
c
c
c
9500  CONTINUE
C -- ERROR
        WRITE(CMON,9510) NNEW
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9510  FORMAT ( ' Too many new atom positions have been given -',I5 )
      CALL XERHND(4)
      RETURN
      END
C
C --
C
CODE FOR XRGPLG
      SUBROUTINE XRGPLG(IATOMS,NATOMS,XSCALE,YSCALE,ZSCALE,SHIFT,ROTN)
C -- SUBROUTINE TO PLACE A PRE-DEFINED GROUP OF NEW ATOMS
C    IATOMS CONTAINS LIST OF THE ATOM INDEXES REFERING TO
C    AN ARRAY GRPATM(3,NNNNN) IN COMMON BLOCK XRGGRP
C    NATOMS IS THE NUMBER OF ATOMS IN THE GROUP
C    XSCALE,YSCALE,ZSCALE ARE THE SCALE FACTORS APPLIED TO
C    X,Y,Z COORDINATES
C --
      DIMENSION IATOMS(NATOMS)
      DIMENSION SHIFT(3)
      DIMENSION ROTN(3)
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGRP.INC'
      INCLUDE 'XRGLST.INC'
C --
      ITYPE=1
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
C
      CALL XRGPLA (ATOM(1), NATOMP, STORE(L1O2), ITYPE )
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
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
C --
      ATOM(5)=XLXRVN(98765.)
      ATOM(6)=XLXRVN(98765.)
      ATOM(7)=XLXRVN(98765.)
C -- PLACE THIS ATOM USING CURRENT COORDINATE SYSTEM
      CALL XRGPLA (ATOM(1), NATOMP, RGOM(1,1), 1 )
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
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
c
      IF (ICODE .EQ. 1) THEN
       noCCin = 0
       sumocc = 0.0
      ENDIF
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
C
C
CPUT GOODIES BACK HERE
      NATOMA=NLST5A-NLST5B+1          !CALCULATE NUMBER OF ATOMS IN SEQUENCE
      IF (IA) 3500,3700,3450          !BRANCH ON PRESENCE OF ATOMS IN LIST 5
C
3450  CONTINUE
       CALL XERHND(7)
C
3500  CONTINUE                           
C       FIRST ATOM NOT IN LIST 5
        IF (ICODE.NE.1) GO TO 9820         !ERROR IF NOT CONSIDERING OLD ATOMS
C --    IF SECOND ATOM IS IN LIST 5 THEN ERROR-MIXED SEQUENCES OF
C       ABSENT AND PRESENT ATOMS ARE NOT ALLOWED
        IF (IB) 3520,9810,3510
3510      CONTINUE
          CALL XERHND(7)
3520      CONTINUE
C -- IF TYPES OF FIRST AND SECOND ATOM ARE DIFFERENT THEN ERROR
C
        IF (ABS(STORE(IHEADA+2)-STORE(IHEADB+2)) .GT. 0.01 ) GO TO 9830
C
C -     CREATION OF DUMMY ATOMS
C
C --    CALCULATE NUMBER OF ATOMS TO BE CREATED
        NATOMA=NINT(STORE(IHEADB+3))-NINT(STORE(IHEADA+3))+1
        IF (NATOMA .LE. 0) GO TO 9840    !ERROR IF THIS NUMBER IS ZERO OR LESS
C --    CREATE ATOM NAME DETAILS
        CALL XSTRLL(IADR)                    !RELEASE PREVIOUS WORK SPACE
        IADR=KSTALL(NATOMA*2)                !GET NEW SPACE
        CALL XZEROF (STORE(IADR), 2*NATOMA)
        SERIAL=STORE(IHEADA+3)
        DO 3530 I=1,NATOMA
           INDEXF=IADR+(I-1)*2
           STORE(INDEXF)=STORE(IHEADA+2)
           STORE(INDEXF+1)=SERIAL
           SERIAL=SERIAL+1.
3530    CONTINUE
C --    SET DETAILS FOR CREATION OF ATOMS
        IADATM=IADR
        INCR=2
        WEIGHT=0.
        GO TO 4000                           !GO TO CREATE ATOMS
C
C
3700  CONTINUE
C --    FIRST ATOM FOUND IN LIST 5 - REAL ATOMS
C --    IF SECOND NOT FOUND THEN ERROR
        IF (IB) 9810,3720,3710
3710      CONTINUE
          CALL XERHND(7)
3720    CONTINUE
        IF (NATOMA.LE.0) GO TO 9840
C --    SET ADDRESSES
        IADATM=MLST5A
        INCR=MD5
        WEIGHT=1.
C
4000  CONTINUE                              !
C       CREATE ATOMS
        IF (NATOMA .LE. 0) GO TO 9840         !CHECK FOR ONE OR MORE ATOMS
      DO 4900 I=1,NATOMA
C -- CHECK IF A VALID HEADER IS AVAILIBLE
         IF (NINT(WEIGHT)) 4030,4030,4020
4020     CONTINUE
           J=KATOMS(IHEADA,IADATM,LATMP)      !APPLY SYMMETRY
           IF (J) 9870,4030,4030
4030     CONTINUE
C
C

         GO TO (4400,4600), ICODE           !BRANCH ON OLD(1) OR NEW(2) ATOMS
         CALL XERHND(7)
C
C
4400     CONTINUE                           
C        OLD ATOMS
c       write(123,'(a,2x,a4,17f10.3)')
c     1                   'Old-latmp ',(store(j),j=latmp,latmp+13)
c       write(123,'(a,2x,a4,17f10.3)')
c     2                   'Old-iadatm',(store(j),j=iadatm,iadatm+13)
C        FOR EACH OLD ATOM CREATE AND ENTRY IN TWO LISTS:
C        CURRENT INPUT ATOM (OR DUMMY) IS AT IADATM
C        INCR IS MD5 FOR REAL ATOMS, 2 FOR DUMMIES
C        LIST AT INDATM IS A FULL LIST-5 TYPE ATOM SPEC
C        LIST AT INDOLD IS A SHORT LIST OF 4 ITEMS, WEIGHTED POSITON AND W
          NOLD=NOLD+1                        !INCREASE COUNT OF OLD ATOMS
C --      CHECK COUNT OF OLD ATOMS
          IF ((NATMD.NE.0) .AND. (NOLD.GT.NATMD)) GO TO 9850
C --      CALCULATE DESTINATIONS FOR THIS ATOM
          INDATM=LATMD+(NOLD-1)*MDATMD
          INDOLD=LOLD+(NOLD-1)*MDOLD
c
C --      CHECK IF AN ATOM WITH THIS SERIAL AND TYPE IS ALREADY IN THE LIST
C         IF NO ATOMS HAVE BEEN GIVEN BEFORE, SKIP THIS CHECK TO AVOID THE
C         CONSEQUENCES (I.E. FINDING ATOMS BELONGING TO PREVIOUS GROUP)
          IF (NOLD.LE.1) GO TO 4420
          MLST5=LATMD
          MDLST5 = MDATMD
C --      CHECK FOR EACH OLD ATOM SPECIFICATION GIVEN SO FAR
          NLST5=NOLD-1
          J=KATOMF(STORE(IADATM),MLST5,NLST5,MDLST5,0)
          IF (J) 4420,9860,4410
4410      CONTINUE
            CALL XERHND(7)
4420      CONTINUE                               
C         ATOM IS NOT IN LIST ALREADY SO CREATE NEW ONE
          CALL XZEROF(STORE(INDATM+4), MDATMD-4)     !CLEAR THE AREA
          CALL XMOVE(STORE(IADATM),STORE(INDATM),2)  !COPY TYPE, SERIAL
          IF (NINT(WEIGHT) .GT. 0) THEN
C           REAL ATOM - COPY OCC AND FLAG
            CALL XMOVE(STORE(IADATM+2),STORE(INDATM+2),2)  
C           COPY uij etc
            CALL XMOVE(STORE(IADATM+7),STORE(INDATM+7),MDATMD-7)  
C           ONLY ADD IN OCCUPATION NUMBERS FOR REAL ATOMS
            noCCin = noCCin + 1
            SUMOCC = SUMOCC + STORE(INDATM+2)
          ELSE
C           DUMMY ATOM - SET OCC, FLAG AND U[ISO]
            STORE(INDATM+2) = 0.0
            STORE(INDATM+3) = 1.0
            STORE(INDATM+7) = 0.051
          ENDIF
          STORE(INDATM+13) = WEIGHT                     ! SET WEIGHT IN SPARE
C
          CALL XMOVE(STORE(IADATM),STORE(MRENM),2)   !TYPE AND SERIAL No
          ISTORE(MRENM+4) = IADATM
          MRENM = MRENM + MDRENM
C --      COPY COORDINATES*WEIGHT
          CALL XMULTR(STORE(LATMP+4),WEIGHT,STORE(INDOLD),3)
          STORE(INDOLD+3)=WEIGHT             !SET WEIGHT
cdjwapr2012
          inouij = louij +(nold-1)*mdouij
          call xmove(store(iadatm+3), store(inouij), 1)     ! Uiso in U11
          call xmove(store(iadatm+7), store(inouij+1), 6)
c
          GO TO 4800
c
c
4600     CONTINUE             
C              
C        NEW ATOMS
c       write(123,'(a,2x,a4,17f10.3)')
c     1                   'New-latmp ',(store(j),j=latmp,latmp+13)
c       write(123,'(a,2x,a4,17f10.3)')
c     2                   'New-iadatm',(store(j),j=iadatm,iadatm+13)
C
          CALL XMOVE(STORE(IADATM),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = IADATM
          MRENM = MRENM + MDRENM
          ITYPE=1
c Nov 2017 x's and Uij are set in XRGPLA
          CALL XRGPLA (STORE(LATMP), MDATMD, UNIT(1,1), ITYPE ) !NEW ATOMS
c
4800     CONTINUE
         IADATM=IADATM+INCR               !SET ADDRESS OF NEXT ATOM
4900  CONTINUE
CPUT GOODIES BACK HERE
C
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
C- COMPUTATION OF AVERAGE OCC REMOVED APR2010
      RETURN
C
C
C
9800  CONTINUE
        WRITE(CMON,9801)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9801  FORMAT (' Error -- not an valid atom specification')
      CALL XERHND(4)
      RETURN
9810  CONTINUE
        WRITE(CMON,9811)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
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
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9831  FORMAT (' Atoms have different types')
      CALL XERHND(4)
      RETURN
9840  CONTINUE
        WRITE(CMON,9841)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9841  FORMAT (' Atoms appear to be out of sequence')
      CALL XERHND(4)
      RETURN
9850  CONTINUE
        WRITE(CMON,9851) NOLD
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9851  FORMAT (' Too many old atoms have been given -',I6)
      CALL XERHND(4)
      RETURN
9860  CONTINUE
        WRITE(CMON,9861)ISTORE(IADATM),NINT(STORE(IADATM+1))
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9861  FORMAT (' An atom with this type and serial already given - ',
     1 A4,I6)
      CALL XERHND(4)
      RETURN
9870  CONTINUE
        WRITE(CMON,9871)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9871  FORMAT (' Error in applying symmetry operation')
      CALL XERHND(4)
      RETURN
      END
C
C --
C
CODE FOR XRGPCS
      SUBROUTINE XRGPCS(IMATRIX) 
C
C -- PRINT THE STORED COORDINATED DATA POINTED TO BY LOLD AND LNEW
C
C
      DIMENSION DELTA(5)
      DIMENSION SUM(4)
      DIMENSION RMSDEV(4)
      DIMENSION XVEC(3)
C Our torsion is C-A-B-D
      DIMENSION ACVEC(3), ABVEC(3), BDVEC(3)
      DIMENSION TEMPO(3), ROMAT(9)
      DIMENSION DELUIJ(6), UOUT(3,3), UAXIS(3), UOAXIS(3), DELAX(3)
      DIMENSION UTYPE(2), USERIAL(2)

      CHARACTER *36 COLD, CNEW
      CHARACTER *32 CATOM1
      CHARACTER *8 COLDU,CNEWU

      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XCOMPD.INC'
      INCLUDE 'QSTORE.INC'
c
C      data cnull/'    '/
      EQUIVALENCE (ANULL,INULL)
      INULL = IB
C
      CALL XZEROF ( SUM(1) , 4 )
      RADIUS = 0.0
c
      MISMAT = 0
      NUMT = 0
      TDEVP = 0.0
      TDEVN = 0.0
      TORMAX = 0.0
      TORMIN = 1000.0
      TOR1MAX = 0.0
      TOR1MIN = 1000.0
      TOR2MAX = 0.0
      TOR2MIN = 1000.0
c
CDJWAPR2012
C    ONLY PRINT GOODIES IF IMATRIX IS -1
       IF (IMATRIX .LT. 0) THEN
C -- PRINT HEADER
        WRITE ( CMON , 1305 )
        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
1305  FORMAT ( 1X , 'Deviations  in best plane system after fitting' ,
     1 ' ( Angstrom )           ' )
C
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)')
     1 '"Angle" is the angular separation of the atoms as seen from',
     2 ' the centre of gravity'
        IF (ISSPRT .EQ. 0)  WRITE ( NCWU , 1725 )
1725  FORMAT ( /,1X , 'Position' , 2X , 'Type  Serial' ,4X,
     2 'old(x)',2X,'old(y)',2X, 'old(z)',7X, 'new(x)',2X,
     3 'new(y)',2X,'new(z)', 8X,'d(x)',4X,'d(y)',4X,'d(z)',
     4 7X,'Distance',4X,'Angle',/)
       ENDIF
cdjwnov07
      dismax=0.
      dtype=anull
      dser =0.0
      angmax=0.
      atype=anull
      aser =0.0
      utype(1) = anull
      utype(2) = anull
      userial(1) = 0.0
      userial(2) = 0.0
c
c Coordinate deviations.
c
      COORDINATES: DO I=1,NOLD
        INDOLD=LOLD+MDOLD*(I-1)
        INDNEW=LNEW+MDNEW*(I-1)
        INDATM=LATMD+MDATMD*(I-1)
c
C -- PRINT APPROPRIATE DATA
        IF ( ABS ( STORE(INDOLD+3) ) .LE. ZERO ) THEN
          IF (IMATRIX .LT. 0) THEN
            IF (ISSPRT .EQ. 0) THEN
               WRITE ( NCWU , 2015 ) I, (STORE(J), J=INDATM,INDATM+1),
     2         (STORE(J),J=INDOLD,INDOLD+2),(STORE(J),J=INDNEW,INDNEW+2)
            ENDIF
          ENDIF
        ELSE
            DISTSQ = 0.
            DO J = 1 , 3
               DELTA(J) = STORE(INDNEW+J-1) - STORE(INDOLD+J-1)
               DELTSQ = DELTA(J) ** 2
               SUM(J) = SUM(J) + DELTSQ
               DISTSQ = DISTSQ + DELTSQ
               RBAR=0.5*(STORE(INDNEW+J-1)+STORE(INDOLD+J-1))
               RADIUS=RADIUS+RBAR*RBAR
            END DO
            DELTA(4) = SQRT ( DISTSQ )
            RADIUS=SQRT(RADIUS)
            DELTA(5)=RTD*ATAN2(DELTA(4),RADIUS)
            IF (IMATRIX .LT. 0) THEN
             IF (ISSPRT .EQ. 0) THEN
               WRITE ( NCWU , 2015 ) I ,(STORE(J),J=INDATM,INDATM+1),
     2         (STORE(J),J=INDOLD,INDOLD+2),
     3         (STORE(J),J=INDNEW,INDNEW+2), DELTA
             ENDIF
            ENDIF
            if (delta(4) .gt. dismax) then
                  dismax=delta(4)
                  dtype = store(indatm)
                  dser  = store(indatm+1)
            endif
c
            if (delta(5) .gt. angmax) then
                  angmax=delta(5)
                  atype = store(indatm)
                  aser  = store(indatm+1)
            ENDIF
        ENDIF
2015     FORMAT ( 1X,2X,I4, 4X,A4,2X, F6.0,2X, 4(3F8.3,5X))
      ENDDO COORDINATES

C -- CALCULATE TOTAL SQUARED DEVIATION AND RMS DEVIATIONS

      SUM(4) = SUM(1) + SUM(2) + SUM(3)
      SUMDEV  = SUM(4)/FLOAT(NATMD)
      DO I = 1,4
            RMSDEV(I) = SQRT ( SUM(I)/FLOAT(NATMD) )
      END DO
      
       IF (ISSPRT .EQ. 0) WRITE ( NCWU , 2505 ) SUM , RMSDEV
2505  FORMAT ( // ,
     1 87X,' x', 7x,' y', 7x,'z',7x,'over-all'/
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

        IF (ISSPRT .EQ. 0) THEN
            write(ncwu,25061)dtype, nint(dser), 
     1      dismax, atype, nint(aser), angmax
25061  format(54x, 'Maximum distance',3x, a4,i4,f10.3,/
     1 54x,'Maximum angle   ',3x,a4,i4,f10.3)
        endif
c
c
C INITIALISE STORAGE
c  delta U and Uprime max
       DUPMAX = 0.0
       DUMAX = 0.0
c  New and old Uprime max
       UPMAX = 0.0
       UOPMAX = 0.0
c  New and old Ugeometric max
       UOGMAX = 0.0
       UGMAX = 0.0
c  Number of aniso Uijs
       NUIJ = 0
c
CDJWAPR2012  UIJ DEVIATIONS
c
c -- only do if not using pre-formed shapes
      if (ishape .eq. 0) then
c       MOLD=LOLD
c       MNEW=LNEW
c       MUIJ=LUIJ+1
c       MOUIJ=LOUIJ+1
c       write(123,*) nold, lold, lnew, louij, luij
c       DO I=1,NOLD
c       write(123,1230)
c     1 store(mold),store(mold+1),store(mold+2),store(mouij-1),
c     2 store(mouij),store(mouij+1),store(mouij+2),
c     3 store(mouij+3),store(mouij+4),store(mouij+5),
c
c     1 store(mnew),store(mnew+1),store(mnew+2),store(muij-1),
c     2 store(muij),store(muij+1),store(muij+2),
c     3 store(muij+3),store(muij+4),store(muij+5)
c
c       MOLD=MOLD+MDOLD
c       MNEW=MNEW+MDNEW
c       MUIJ=MUIJ+MDUIJ
c       MOUIJ=MOUIJ+MDOUIJ
c       ENDDO
1230  format(2(3f6.3,3x,f5.2,3x,6f6.3,3x))
c
       IF (IMATRIX .LT. 0) THEN
        IF (ISSPRT .EQ.0) THEN 
         WRITE(NCWU,'(/A/A,A/)') 'Uij in Best Match Coordinate System',
     1   'Uprime = U(med).U(max)/U(min), Watkin, Acta Cryst (2000)',
     2   ' B56 747-749'
         WRITE(NCWU,20153)
20153    FORMAT( 1X , 'Position' , 2X , 'Type  Serial' ,4X,
     1   17X,'Old U[ij]',23X,'Old Principal Axes',3X,
     1   'Uprime',3x,'Ugeom'/
     2   44X,'New U[ij]',23X,'New Principal Axes',/
     3   39X,'delta U[ij]',24X,'delta Principal Axes', 
     1   /)
        ENDIF
       ENDIF
c
c
C
       muij  = luij+1
       mouij = louij+1
c
       UIJLOOP:  DO I=1,NOLD
         INDATM=LATMD+MDATMD*(I-1)
         INDR = LRENM+MDRENM*(I-1)
         MOPIV = ISTORE(INDR+4)  ! atom in old list.
         MNPIV = ISTORE(INDR+5)  ! corresponding atom in new list.
c
         IF ((nint( STORE(muij-1) ) .ne. 0 ) .or. 
     1  (nint( STORE(mouij-1) ) .ne. 0 )) THEN
          IF (IMATRIX .LT. 0) THEN
             IF (ISSPRT .EQ. 0) THEN
                WRITE ( NCWU , 20154 ) I, (STORE(J), 
     2          J=INDATM,INDATM+1),'Isotropic'
20154          FORMAT ( 1X,2X,I4, 4X,A4,2X, F5.0,2X, A )
             ENDIF
           ENDIF
         ELSE
c
c            an aniso atom. Increment counter
             nuij = nuij + 1
             call xdia(store(mouij), UOUT, UOAXIS)
             call xdia(store(muij), UOUT, UAXIS)
c
             UOPRIME =
     1       SIGN(1.,UOAXIS(1))*ABS(UOAXIS(2)*UOAXIS(3))/
     2      ABS(UOAXIS(1))
             UPRIME =
     1       SIGN(1.,UAXIS(1))*ABS(UAXIS(2)*UAXIS(3))/
     2      ABS(UAXIS(1))
c
             DUP = UOPRIME-UPRIME
             DUPMAX = MAX(DUPMAX, ABS(DUP))
             UOPMAX = MAX(UOPMAX, UOPRIME)
             UPMAX = MAX(UPMAX, UPRIME)
C
C      
             UGEOM = 1.
             UOGEOM = 1.
             DO J = 1,3
                 UOGEOM=UOGEOM*UOAXIS(j)
                 UGEOM=UGEOM*UAXIS(j)
             ENDDO
             UGEOM = UGEOM**(1./3.)
             UOGEOM = UOGEOM**(1./3.)
             DUGEOM = UOGEOM-UGEOM
             UGMAX = MAX(UGMAX, UGEOM)
             UOGMAX = MAX(UOGMAX, UOGEOM)
C
             DO J = 1,3
                DELAX(J) = UOAXIS(J)-UAXIS(J)
                if (abs(delax(j)) .gt. dumax) then
                 DUMAX = MAX(DUMAX,ABS(DELAX(J)))
                 utype(1) = store(mopiv)
                 utype(2) = store(mnpiv)
                 userial(1) = store(mopiv+1)                 
                 userial(2) = store(mnpiv+1)
                endif
             ENDDO
c
             DO J = 0,5
                deluij(j+1)= store(mouij+j)-store(muij+j)
             END DO
c
             IF (IMATRIX .LT. 0) THEN
              IF (ISSPRT .EQ. 0) THEN
                WRITE ( NCWU , 20155 ) I ,(STORE(J),J=MOPIV,MOPIV+1),
     2         (STORE(J),J=MOUIJ,MOUIJ+5),UOAXIS,UOPRIME,UOGEOM, 
     3         (STORE(J),J=MNPIV,MNPIV+1),
     4         (STORE(J),J=MUIJ,MUIJ+5),UAXIS,UPRIME,UGEOM,
     5         DELUIJ, DELAX, DUP, DUGEOM
             ENDIF
            ENDIF    
         ENDIF
20155    FORMAT(1X,2X,I4,4X,A4,2X,F5.0,2X,6F8.3,3X,3F6.3,2(3X,F6.3)/
     1          1X,2X,4X,4X,A4,2X,F5.0,2X,6F8.3,3X,3F6.3,2(3X,F6.3)/
     2          1X,2X,4X,4X,4X,2X,5X  ,2X,6F8.3,3X,3F6.3,2(3X,F6.3)/ )
         MUIJ=MUIJ+MDUIJ
         MOUIJ=MOUIJ+MDOUIJ
       ENDDO UIJLOOP
      endif
C
C
CDJWDEC07
      IF (NOGEOM .LE. 0) GOTO 9000
C
C RMS deviation of bonds
C
      JT = 12 ! Number of words per returned distance
      BDEV = 0.0
      NUMBR = 0
      BNDMAX = 0.0
      BNDMIN = 1000.0

cdjwjul06
       if (ishape .eq. 0) then
       IF (NOLD .GE. 1) THEN
        IF (IMATRIX .LT. 0) THEN
         IF (ISSPRT .EQ. 0) 
     C  WRITE(NCWU,'(/,A)')'Bond length deviations'
        ENDIF
       outerloop: DO I=1,NOLD
        INDOLD=LOLD+MDOLD*(I-1)
        INDNEW=LNEW+MDNEW*(I-1)
        INDATM=LATMD+MDATMD*(I-1)
        INDR = LRENM+MDRENM*(I-1)
        MOPIV = ISTORE(INDR+4)  ! atom in old list.
        MNPIV = ISTORE(INDR+5)  ! corresponding atom in new list.
c
c        WRITE(CMON,'(A,2I10)')'Adrss: ',ISTORE(INDR+4),ISTORE(INDR+5)
c        CALL XPRVDU(NCVDU,1,0)
        M5A = MOPIV
        M5=M5A  ! Find each bond once.
c
        NFLORIG = NFL           ! SAVE THE NEXT FREE ADDRESS
        MASTCK = NFL + 10*N5*JT ! Keep well clear 
        NFL = MASTCK            ! Temp change NFL.
        K = KDIST4( JS, JT, 0, 0)   ! Find the distances
        NFL = NFLORIG       ! RESET NFL 

        IF ( K .LT. 0 ) THEN
           WRITE (CMON,'(A)')'"KDIST4" returned an error.'
           CALL XPRVDU(NCVDU,1,0)
           IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
           CYCLE
        END IF
c
C There is a stack at MASTCK of all the bonded contacts around the atom at M5A.
C Find the pivot atom (M5A) in the first group.
c
        DISTLOOP: DO J = MASTCK, JS-JT, JT
          MOBND = ISTORE(J)  ! Get the address in L5 of this atom.
          MNBND = -1
          DO L=1,NOLD  !  Find the bonded atom in the old list.
            LINDR = LRENM+MDRENM*(L-1)
            IF ( ISTORE(LINDR+4) .EQ. MOBND ) THEN
              MNBND = ISTORE(LINDR+5)
              EXIT
            END IF
          END DO
          IF ( MNBND .LT. 0 ) CYCLE
          D1 = XDSTN2(STORE(MOPIV+4),STORE(MOBND+4))
          D2 = XDSTN2(STORE(MNPIV+4),STORE(MNBND+4))
          DEV = ABS(SQRT(D1)-SQRT(D2))
          BDEV = BDEV + DEV**2
          BNDMIN = MIN(BNDMIN, DEV)
          BNDMAX = MAX(BNDMAX, DEV)
          NUMBR = NUMBR + 1
C
        IF (IMATRIX .LT. 0) THEN
        WRITE(COLD(1:),'(A4,I4)')  ISTORE(MOPIV),NINT(STORE(MOPIV+1))
        WRITE(COLD(10:),'(A4,I4)')  ISTORE(MOBNd),NINT(STORE(MOBND+1))
        WRITE(CNEW(1:),'(A4,I4)')  ISTORE(MNPIV),NINT(STORE(MNPIV+1))
        WRITE(CNEW(10:),'(A4,I4)')  ISTORE(MNBND),NINT(STORE(MNBND+1))
        COLD(9:9)='-'
        CNEW(9:9)='-'
        CALL XCRAS(COLD,LOS)
        CALL XCRAS(CNEW,LNS)
C
C
        IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU,'(A,2X,A,F8.3)')
     1     COLD(1:18), CNEW(1:18), DEV
        ENDIF
        ENDIF
C Really check if the bond MNBND - MNPIV is in the bond list.
          
          IFBND = 0
          DO M41B = L41B+(N41B-1)*MD41B, L41B, -MD41B
            I51 = L5 + ISTORE(M41B) * MD5
            I52 = L5 + ISTORE(M41B+6) * MD5
            IF ((( I51 .EQ. MNBND ) .AND. ( I52 .EQ. MNPIV )) .OR.
     1          (( I52 .EQ. MNBND ) .AND. ( I51 .EQ. MNPIV ))) THEN
               IFBND = 1
               EXIT
            END IF
          END DO
          IF ( IFBND .EQ. 0 ) THEN !  BOND not FOUND !
            IF ((ilstre.GE.0) .and. (issprt .eq. 0)) THEN
             IF ( MISMAT .EQ. 0 ) THEN
              WRITE(ncwu,'(15A4,2A,4(1X,A,I4))')(KTITL(II),II=1,15),
     1        CHAR(9),'Bond mismatch',
     4                            ISTORE(MOPIV),NINT(STORE(MOPIV+1)),
     2                            ISTORE(MOBNd),NINT(STORE(MOBND+1)),
     1                            ISTORE(MNPIV),NINT(STORE(MNPIV+1)),
     3                            ISTORE(MNBND),NINT(STORE(MNBND+1))
              MISMAT = 1
             END IF
            END IF
            WRITE (CMON,'(A)')'{E Warning: bond mismatch'
            CALL XPRVDU(NCVDU,1,0)
            IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
          END IF
        END DO    DISTLOOP
       END DO  outerloop
C
C
CTORSION ANGLE DEVIATIONS
C
C
        IF (NOLD .GE. 1) THEN
         IF (IMATRIX .LT. 0) THEN
         IF (ISSPRT .EQ. 0) 
     1  WRITE(NCWU,'(/,A,57x,a)')'Torsion angle deviations',
     2  'Angles & Difference'
        ENDIF
        ENDIF
C RMS deviation of torsions.
C 1. Find next bond (a1-a2) in LOLD.
C 2. Find equiv bond in LNEW (a1'-a2')
C   3. Find another bond from atom 1 (a1-a3)
C   4. Find equiv bond (a1'-a3')
C     5. Find bond from a2 != a1 (a2-a4)
C     6. Find equiv bond (a2'-a4')

C Torsion will be MNC - MNA - MNB - MND
C Old one will be MOC - MOA - MOB - MOD
c
c If the determinant is -ve, invert the torsion angles for the second 
c molecule

      JT = 12 ! Number of words per returned distance
      TDEVP = 0.0
      TDEVN = 0.0
      TORMAX = 0.0
      TORMIN = 1000.0
      TOR1MAX = 0.0
      TOR1MIN = 1000.0
      TOR2MAX = 0.0
      TOR2MIN = 1000.0

       outer2: DO I=1,NOLD
        INDOLD=LOLD+MDOLD*(I-1)
        INDNEW=LNEW+MDNEW*(I-1)
        INDATM=LATMD+MDATMD*(I-1)
        INDR = LRENM+MDRENM*(I-1)

c        WRITE(CMON,'(A,2I10)')'Adrss: ',ISTORE(INDR+4),ISTORE(INDR+5)
c        CALL XPRVDU(NCVDU,1,0)

        MOA = ISTORE(INDR+4)  ! atom A in old list.
        MNA = ISTORE(INDR+5)  ! corresponding atom A' in new list.

        M5A = MOA        ! Atom A
        M5  = L5A        ! Find all bonds to Atom A.
        NFLORIG = NFL           ! SAVE THE NEXT FREE ADDRESS
        MASTCK = NFL + 10*N5*JT ! Keep well clear 
        NFL = MASTCK            ! Temp change NFL.
        K = KDIST4( MAENDS, JT, 0, 0)   ! Find the distances
        NFL = NFLORIG       ! RESET NFL 

        IF ( K .LT. 0 ) THEN
           WRITE (CMON,'(A)')'"KDIST4" returned an error.'
           CALL XPRVDU(NCVDU,1,0)
           CYCLE
        END IF
        IF ( K .LE. 1 ) CYCLE ! No torsions here.

C There is a stack at MASTCK of all the bonded contacts around the atom at M5A.
C Find the pivot atom (M5A) in the first group.

        DLOOP: DO J = MASTCK, MAENDS-JT, JT
          MOB = ISTORE(J)           ! Get the address in L5 of this atom.
          IF ( MOB .LE. MOA ) CYCLE ! Only consider inner atoms once.
          MNB = -1
          DO L=1,NOLD  !  Find the bonded atom in the old list.
            LINDR = LRENM+MDRENM*(L-1)
            IF ( ISTORE(LINDR+4) .EQ. MOB ) THEN
              MNB = ISTORE(LINDR+5)
              EXIT
            END IF
          END DO
          IF ( MNB .LT. 0 ) CYCLE  ! Atom not in new list. Err?

C Find list of bonds around atom B. Keep well clear of current list.
          M5A = MOB       ! Atom B
          M5  = L5        ! Find each bond many times.
          NFLORIG = NFL                 ! SAVE THE NEXT FREE ADDRESS
          MBSTCK  = MAENDS + JT                 ! Keep well clear 
          NFL     = MBSTCK                      ! Temp change NFL.
          K       = KDIST4( MBENDS, JT, 0, 0)   ! Find the distances
          NFL     = NFLORIG                     ! RESET NFL 

          IF ( K .LT. 0 ) THEN
           WRITE (CMON,'(A)')'"KDIST4" returned an error. In DLOOP.'
           CALL XPRVDU(NCVDU,1,0)
           CYCLE
          END IF
          IF ( K .LE. 1 ) CYCLE ! No torsions here.

          ATOMALOOP: DO K = MASTCK, MAENDS-JT, JT

            IF ( K .EQ. J ) CYCLE  ! MOC must not be MOB.
            MOC = ISTORE(K)  ! Get the address in L5 of this atom.
            MNC = -1
            DO L=1,NOLD  !  Find the bonded atom in the old list.
              LINDR = LRENM+MDRENM*(L-1)
              IF ( ISTORE(LINDR+4) .EQ. MOC ) THEN
                MNC = ISTORE(LINDR+5)
                EXIT
              END IF
            END DO
            IF ( MNC .LT. 0 ) CYCLE  ! Atom not in new list. Err?

            ATOMBLOOP: DO KB = MBSTCK, MBENDS-JT, JT

              MOD = ISTORE(KB)  ! Get the address in L5 of this atom.
              IF ( MOD .EQ. MOA ) CYCLE  ! MOD must not be MOA.
              MND = -1
               DO L=1,NOLD  !  Find the bonded atom in the old list.
                LINDR = LRENM+MDRENM*(L-1)
                IF ( ISTORE(LINDR+4) .EQ. MOD ) THEN
                  MND = ISTORE(LINDR+5)
                  EXIT
                END IF
              END DO
              IF ( MND .LT. 0 ) CYCLE  ! Atom not in new list. Err?

C Vectors
              CALL XSUBTR(STORE(MOC+4),STORE(MOA+4),ACVEC,3)
              CALL XSUBTR(STORE(MOB+4),STORE(MOA+4),ABVEC,3)
              CALL XSUBTR(STORE(MOD+4),STORE(MOB+4),BDVEC,3)
C Orthogonal
              CALL XMLTTM(STORE(L1O1),ACVEC,TEMPO,3,3,1)
              CALL XMOVE(TEMPO,ACVEC,3)
              CALL XMLTTM(STORE(L1O1),ABVEC,TEMPO,3,3,1)
              CALL XMOVE(TEMPO,ABVEC,3)
              CALL XMLTTM(STORE(L1O1),BDVEC,TEMPO,3,3,1)
              CALL XMOVE(TEMPO,BDVEC,3)
C Normalise
              IF(NORM3(ACVEC).LT.0) CYCLE
              IF(NORM3(ABVEC).LT.0) CYCLE
              IF(NORM3(BDVEC).LT.0) CYCLE
              
C Axis system for torsion C-A-B-D
C Construct an orthogonal set of axes so that the 'z' direction points
C along the AB bond, the 'y' direction is perpendicular to the CAB plane,
C and the 'x' direction lies in the CAB plane, perpendicul to y and z.
C NB Matrix transpose is formed for easy memory access.
              CALL XMOVE(ABVEC,ROMAT(7),3)       ! z-direction
              IF(NCROP3(ABVEC,ACVEC,ROMAT(4)).LT.0) CYCLE  ! y-direction
              IF(NCROP3(ROMAT(4),ROMAT(7),ROMAT(1)).LT.0) CYCLE  ! x-direction
C Transform BD vector to this new system
              CALL XMLTTM(ROMAT,BDVEC,TEMPO,3,3,1)

C Angle - imagine looking down the z direction (the BA bond):
C
C
C       D
C  y   /
C     /
C    /
C   AB-----C
C       x
C
C the sin of the angle between AC and BD is given by the y component of BD
C and the cos by the x component.
c
c watch out for components very close to zero
              if(abs(tempo(1)) .le. zero) tempo(1) = 0.0
              if(abs(tempo(2)) .le. zero) tempo(2) = 0.0
c

              T1 = ATAN2( TEMPO(2), TEMPO(1) ) * RTD  ! Ta-da.

C The new atoms.
C Vectors
              CALL XSUBTR(STORE(MNC+4),STORE(MNA+4),ACVEC,3)
              CALL XSUBTR(STORE(MNB+4),STORE(MNA+4),ABVEC,3)
              CALL XSUBTR(STORE(MND+4),STORE(MNB+4),BDVEC,3)
C Orthogonal
              CALL XMLTTM(STORE(L1O1),ACVEC,TEMPO,3,3,1)
              CALL XMOVE(TEMPO,ACVEC,3)
              CALL XMLTTM(STORE(L1O1),ABVEC,TEMPO,3,3,1)
              CALL XMOVE(TEMPO,ABVEC,3)
              CALL XMLTTM(STORE(L1O1),BDVEC,TEMPO,3,3,1)
              CALL XMOVE(TEMPO,BDVEC,3)
C Normalise
              IF(NORM3(ACVEC).LT.0) CYCLE
              IF(NORM3(ABVEC).LT.0) CYCLE
              IF(NORM3(BDVEC).LT.0) CYCLE
C Axis system for torsion C-A-B-D
              CALL XMOVE(ABVEC,ROMAT(7),3)             ! z-direction
              IF( NCROP3(ABVEC,ACVEC,ROMAT(4)).LT.0) CYCLE        ! y-direction
              IF(NCROP3(ROMAT(4),ROMAT(7),ROMAT(1)).LT.0) CYCLE  ! x-direction
C Transform BD vector to this new system
              CALL XMLTTM(ROMAT,BDVEC,TEMPO,3,3,1)

c watch out for components very close to zero
              if(abs(tempo(1)) .le. zero) tempo(1) = 0.0
              if(abs(tempo(2)) .le. zero) tempo(2) = 0.0
              T2 = ATAN2( TEMPO(2), TEMPO(1) ) * RTD  ! Ta-da.
c
c
C If angles differ by more than 180, take 360 - diff.
CDJW OCT2010 Sometimes gives large unreasonable values.
c probably trying to account for a change of hand.
C              TP = T1 - T2
C              IF ( TP .GT. 180.0 ) TP = 360. - TP
C              IF ( TP .LT. -180.0 ) TP = -360. - TP
C              TDEVP = TDEVP + TP**2
C              TOR1MAX = MAX(TOR1MAX,ABS(TP))
C              TOR1MIN = MIN(TOR1MIN,ABS(TP))
c
C              TN = T1 + T2
C              IF ( TN .GT. 180 ) TN = 360. - TN
C              IF ( TN .LT. -180 ) TN = -360. - TN
C              TDEVN = TDEVN + TN**2
C              TOR2MAX = MAX(TOR2MAX,ABS(TN))
C              TOR2MIN = MIN(TOR2MIN,ABS(TN))
c
cdjwfeb11 Watch out for inversion
               if (detmat .le. 0) t2 = -t2
               if (t1 .lt. -180.0) then 
                  t1 = t1 + 360.
               else if (t1 .gt. 180.) then
                  t1 = t1 - 360.
               endif
               if (t2 .lt. -180.0) then 
                  t2 = t2 + 360.
               else if (t2 .gt. 180.) then
                  t2 = t2 - 360.
               endif

               tp = t1 - t2
               if (tp .gt. 180.) then
                  tp = tp - 360.
               else if (tp .lt. -180.) then
                  tp = tp + 360.
               endif

               tdevp = tdevp + tp*tp
               tormax = max(tormax, abs(tp))
               tormin = min(tormin, abs(tp))
CDJW OCT2010
              NUMT = NUMT + 1

              IF (IMATRIX .LT. 0) THEN
              IF (ISSPRT .EQ. 0) THEN

        WRITE(COLD(1:),'(A4,I4)') ISTORE(MOC),NINT(STORE(MOC+1))
        WRITE(COLD(10:),'(A4,I4)') ISTORE(MOA),NINT(STORE(MOA+1))
        WRITE(COLD(19:),'(A4,I4)') ISTORE(MOB),NINT(STORE(MOB+1))
        WRITE(COLD(28:),'(A4,I4)') ISTORE(MOD),NINT(STORE(MOD+1))

        WRITE(CNEW(1:),'(A4,I4)') ISTORE(MNC),NINT(STORE(MNC+1))
        WRITE(CNEW(10:),'(A4,I4)') ISTORE(MNA),NINT(STORE(MNA+1))
        WRITE(CNEW(19:),'(A4,I4)') ISTORE(MNB),NINT(STORE(MNB+1))
        WRITE(CNEW(28:),'(A4,I4)') ISTORE(MND),NINT(STORE(MND+1))
        COLD(9:9)='-'
        COLD(18:18)='-'
        COLD(27:27)='-'
        CNEW(9:9)='-'
        CNEW(18:18)='-'
        CNEW(27:27)='-'
        CALL XCRAS(COLD,LOS)
        CALL XCRAS(CNEW,LNS)
        IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU,'(A,2X,A,4x,3F8.2)')
     1     COLD(1:36), CNEW(1:36), T1,T2,TP
        ENDIF

              ENDIF
              ENDIF
            END DO ATOMBLOOP
          END DO ATOMALOOP
        END DO DLOOP
       END DO outer2
      endif
      endif


      IF (NUMBR .GT. 0) THEN
       SBDEV = SQRT(BDEV / NUMBR)
      ELSE
       SBDEV = 0.
      ENDIF
      IF (NUMT .GT.0) THEN
c       STDEV = SQRT(MIN(TDEVP,TDEVN) / NUMT)
       STDEV = SQRT(TDEVP / NUMT)
      ELSE
       STDEV = 0.
      ENDIF

cdjw oct2010      done in loop above
c      IF ( TDEVP .GT. TDEVN ) THEN
c        TORMAX = TOR2MAX
c        TORMIN = TOR2MIN
c      ELSE
c        TORMAX = EDTTOR1MAX
c        TORMIN = TOR1MIN
c      END IF
c
      if (detmat .le. 0) then
       write(cmon,'(1x,/,a)')
     1 '{I Hand of the second molecule has been inverted'
       call xprvdu(ncvdu,2,0)
       if (issprt .eq. 0) then
         write (ncwu,'(a)') trim(CMON(1)), CMON(2)(3:len_trim(cmon(2)))
       end if
      endif
c
c
      WRITE(CMON,'(//A/)')'{I Summary of deviations'
      CALL XPRVDU(NCVDU,4,0)
      if(issprt.eq.0) Write(ncwu,'(//a/)') 'Summary of Deviations'
C
      WRITE(CMON,'(A,17X,A/A,A,3F12.4/A,A,5F12.4/)')'{I',
     1 '      position    bond        torsion',
     1 '{I',
     2 ' rms deviations  ',RMSDEV(4), SBDEV, STDEV,'{I',
     4 ' max deviations  ',dismax, bndmax, tormax
      CALL XPRVDU(NCVDU,4,0)

      IF (ISSPRT .EQ. 0) 
     1  WRITE(ncwu,'(17X,A/A,3F12.4/A,5F12.4/)')
     1 '      position    bond        torsion',
     2 ' rms deviations  ',RMSDEV(4), SBDEV, STDEV,
     4 ' max deviations  ',dismax, bndmax, tormax
c
c
      if(nuij.gt.0) then
c^^
       write(coldu(1:),'(a4,i4)')UTYPE(1),nint(USERIAL(1))
       write(cnewu(1:),'(a4,i4)')UTYPE(2),nint(USERIAL(2))
       call xcras(coldu,los)
       call xcras(cnewu,lns)
       write(CMON,2020)uogmax, uopmax, ugmax, upmax, dupmax, dumax,
     1 coldu(1:8),cnewu(1:8)
2020  format(/9x,'Ugeom(max)'6x,'Uprime(max)',4x,'U[ij](old-new)',/
     1 'Old',2(6x,f8.3),/ 'New',2(6x,f8.3),/ 
     2 'Individual Delta', 1x, 2(6x,f8.3),
     3  3x,a,' - ',a)
       CALL XPRVDU(NCVDU,4,0)
       IF (ISSPRT.EQ.0)
     1 write(NCWU,2020)uogmax, uopmax, ugmax, upmax, dupmax, dumax,
     2 coldu(1:8),cnewu(1:8)
      endif
c
      IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':Sum dev sq'
             CALL XCREMS(CPCH,CPCH,LENFIL)
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(14(A,F9.4))')
     2       (CHAR(9),SUM(I),I=1,4)
c
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':RMS dev'
             CALL XCREMS(CPCH,CPCH,LENFIL)
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(14(A,F9.4))')
     2       (CHAR(9),RMSDEV(I),I=1,4)
c
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':RMS bond and tors dev'
             CALL XCREMS(CPCH,CPCH,LENFIL)
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(14(A,F9.4))')
     1       CHAR(9),SBDEV,CHAR(9),STDEV
c
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':Min and Max bond dev'
             CALL XCREMS(CPCH,CPCH,LENFIL)
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(14(A,F9.4))')
     2       CHAR(9),BNDMIN,CHAR(9),BNDMAX
c
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':Min and Max tors dev'
             CALL XCREMS(CPCH,CPCH,LENFIL)
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(14(A,F9.4))')
     2       CHAR(9),TORMIN,CHAR(9),TORMAX
             CALL XCREMS(CPCH,CPCH,LENFIL)
c
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A,A)')
     1       CHAR(9),':Max U & Uprime dev'
             CALL XCREMS(CPCH,CPCH,LENFIL)
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(14(A,F9.4))')
     2       CHAR(9),DUMAX,CHAR(9),DUPMAX
             CALL XCREMS(CPCH,CPCH,LENFIL)
c
c             IF ( MISMAT .EQ. 0 )
c     1        WRITE(123,'(15A4,3(A,F12.5))')(KTITL(I),I=1,15),
c     1       CHAR(9),RMSDEV(4),CHAR(9),SBDEV,CHAR(9),STDEV
      END IF
9000  CONTINUE
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9010 )
9010  FORMAT (//)
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
      INCLUDE 'STORE.INC'
      INCLUDE 'XRGLST.INC'
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
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
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
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XIOBUF.INC'
C --
      IMETHD=IVALUE
      IF ( IMETHD.LT.0 ) GO TO 9800
      IF ( IMETHD.EQ.0 ) GO TO 9900
      IF ( IMETHD.GT.5 ) GO TO 9800
      RETURN
9800  CONTINUE
        WRITE(CMON,9810) IVALUE
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9810  FORMAT ( ' Method number',I3,' is not in allowed range ')
9900  CONTINUE
C -- SET DEFAULT METHOD NUMBER
      IMETHD = 1
        WRITE(CMON,9910)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU,'(A)') trim(CMON(1))
9910  FORMAT (' Method set to default value, 1')
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
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C 
      INCLUDE 'QSTORE.INC'

      WRITE(CMON,'(A)') 'Renaming atoms'
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
c
      WRITE(CMON,'(A,f6.1)') 'Offset = ', zorig
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
      IF(SUMDEV .GE. 0.1)THEN
       NUMDEV =NUMDEV +1
       WRITE(CMON,'(A)') 'WARNING - poor initial fit' 
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU,1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
      ENDIF

      WRITE(CMON,'(1X,A,7X,A,8X,A,6X,A)')
     1 'Mapping','onto','giving', 'distance'
      IF(SUMDEV .GE. 0.1) CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
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
         IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
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
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XMATCH.INC'
      INCLUDE 'XDSTNC.INC'
C
      INCLUDE 'QSTORE.INC'
c
      WRITE(CMON,'(A)') 'Matching atoms'
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
c
      
      IF(SUMDEV .GE. 0.1)THEN
       NUMDEV =NUMDEV +1
       WRITE(CMON,'(A)') 'WARNING - poor initial fit' 
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU,1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
      ENDIF

      LMBUF = KSTALL ( MDATVC )
      LNBUF = KSTALL ( MDNEW )
      NMATCHED = 0
c
c 
      IF (NOLD.LE.0) GO TO 200
c
c
      WRITE(CMON,'(A)') 'Improving match'
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
c
c      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,'(A,7x,A,3X,A,5X,A)')
     1 'Improving:','Mapping ','onto','distance'
c      ENDIF
c
C * Optionally only match atoms with matching SPARE values (though
C   I think this info is lost by now.)

      DO I=0,NOLD-1                     !Loop over old atoms.
         INDOLD=LOLD+MDOLD*I            !Address of XYZold
         IOLD5 = L5 + (ISTORE(LONTO+I*MDATVC)) * MD5
         IONTO = LONTO+I*MDATVC
         DISMIN=1000000.            !Initialise
         INDDIS=-1

         IF ( ( LSPARE .EQ. 0 ) .OR.
     1        ( ISTORE(IONTO+4) .EQ. 1 ) .OR.
     2        ( I .EQ. 0 ) ) THEN              !Just match it.
cdjwnov07
        IF(ILSTRE.GE.3) THEN
           IF (ISSPRT .EQ. 0) THEN
           WRITE(NCWU,'(A,A4,7I9)')'Old atom: ',ISTORE(IOLD5),
     1     NINT(STORE(IOLD5+1)),NINT(STORE(IOLD5+13)), LSPARE,
     2     ISTORE(IONTO+1),ISTORE(IONTO+2),
     3     ISTORE(IONTO+3),ISTORE(IONTO+4)
           ENDIF
        ENDIF
cdjwnov07
           DO J=I,NNEW-1           !Loop over unmatched new atoms.
             INDNEW=LNEW+MDNEW*J         !Address of XYZnew
             INEW5 = L5 + (ISTORE(LMAP+J*MDATVC)) * MD5

        IF(ILSTRE.GE.3) THEN
             WRITE(NCWU,'(A,A4,2I9)')'New atom: ',ISTORE(INEW5),
     1       NINT(STORE(INEW5+1)),NINT(STORE(INEW5+13))
        ENDIF
             DISTSQ=0.
C Only consider atom if spare matches when LSPARE is one.
             IF ( (LSPARE.EQ.0) .OR. ( (LSPARE.EQ.1) .AND.
     1          (NINT(STORE(INEW5+13)).EQ.NINT(STORE(IOLD5+13)))))THEN
               DO K=1,3
                 DELTA=STORE(INDNEW+K-1)-STORE(INDOLD+K-1)
                 DELTSQ=DELTA**2
                 DISTSQ=DISTSQ+DELTSQ
               END DO

cdjwnov07
             IF(ILSTRE.GE.3) THEN
               IF (ISSPRT .EQ. 0) THEN
               WRITE(NCWU,'(A,A4,2I9,F15.8)')'Match: ',ISTORE(INEW5),
     1         NINT(STORE(INEW5+1)), J, DISTSQ
               ENDIF
             ENDIF
cdjwnov07
c             
               IF (DISTSQ.LT.DISMIN) THEN
                 DISMIN=DISTSQ
                 INDDIS=J
               END IF
             END IF
           END DO

         ELSE   ! This is not a unique atom. Use bonding.

           EXIT

         END IF

         J = INDDIS

C Swap atoms at LNEW(I) and LNEW(J)
C Swap atoms at LMAP(I) and LMAP(J)

         IF ( J .GE. 0 ) THEN

          CALL XMOVE(STORE(LNEW+MDNEW*I),STORE(LNBUF),MDNEW)
          CALL XMOVE(STORE(LNEW+MDNEW*J),STORE(LNEW+MDNEW*I),MDNEW)
          CALL XMOVE(STORE(LNBUF),STORE(LNEW+MDNEW*J),MDNEW)

          CALL XMOVE(STORE(LMAP+MDATVC*I),STORE(LMBUF),MDATVC)
          CALL XMOVE(STORE(LMAP+MDATVC*J),STORE(LMAP+MDATVC*I),MDATVC)
          CALL XMOVE(STORE(LMBUF),STORE(LMAP+MDATVC*J),MDATVC)

          IOLD5 = L5 + (ISTORE(LONTO+I*MDATVC)) * MD5
          INEW5 = L5 + (ISTORE(LMAP+I*MDATVC)) * MD5

          STORE(LRENM+NMATCHED*MDRENM)   = STORE(IOLD5)
          STORE(LRENM+NMATCHED*MDRENM+1) = STORE(IOLD5+1)
          STORE(LRENM+NMATCHED*MDRENM+4) = STORE(INEW5)
          STORE(LRENM+NMATCHED*MDRENM+5) = STORE(INEW5+1)+ZORIG

          NMATCHED = NMATCHED + 1
1234      format(A,A4,I4,' - ',A4,I4,F8.3)
          IF(ILSTRE.GE.3) THEN
          IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU,1234)
     1    'Matching:       ',
     2    STORE(IOLD5),NINT(STORE(IOLD5+1)),
     3    STORE(INEW5),NINT(STORE(INEW5+1)),DISMIN
          ENDIF
          ENDIF

         ELSE

          WRITE(CMON,'(A)') '{E Programming error. No match found for:'
          CALL XPRVDU(NCVDU,1,0)
          WRITE(CMON,'( A4,2F6.1)')
     1    STORE(IOLD5),STORE(IOLD5+1),STORE(IOLD5+13)
          CALL XPRVDU(NCVDU,1,0)
          GOTO 200
         END IF
      END DO

      WRITE(CMON,'(A)')'All unique atoms matched. Matching rest'
      CALL XPRVDU(NCVDU,1,0)

      JT = 12 ! Number of words per returned distance

      DO WHILE ( NMATCHED .LT. NOLD )   ! Keep on looping.

c        WRITE(CMON,'(A)')'Matching rest '
c        CALL XPRVDU(NCVDU,1,0)


        UNMLOOP: DO I=NMATCHED-1,0,-1     !Loop over old matched atoms.

C Create a list of bond to this atom. (A)
          IOLDP = L5 + (ISTORE(LONTO+I*MDATVC)) * MD5


          M5A = IOLDP
          M5=L5  ! Find all bonds.

          NFLORIG = NFL           ! SAVE THE NEXT FREE ADDRESS
          MASTCK = NFL + 10*N5*JT ! Keep well clear 
          NFL = MASTCK            ! Temp change NFL.
          K = KDIST4( JS, JT, 0, 0)   ! Find the distances
          NFL = NFLORIG       ! RESET NFL 

          IF ( K .LT. 0 ) THEN
           WRITE (CMON,'(A)')'"KDIST4" returned an error.'
           CALL XPRVDU(NCVDU,1,0)
           CYCLE
          END IF

C There is a stack at MASTCK of all the bonded contacts around the atom at M5A.


          DISTLOOP: DO J = MASTCK, JS-JT, JT
            MOBND = ISTORE(J)    ! Get the address in L5 of this atom.
            MOFND = 0
            DO L=0,NOLD-1        !  Find the bonded atom in the old list.
              IOLDB = L5 + (ISTORE(LONTO+L*MDATVC)) * MD5
              IF ( IOLDB .EQ. MOBND ) THEN
                MOFND = 1
                IF ( L .GE. NMATCHED ) THEN          ! This atom is not matched.
                  INDOLD=LOLD+MDOLD*L            !Address of XYZold
C Find the corresponding matched atom.
                  INEWP = L5 + (ISTORE(LMAP+I*MDATVC)) * MD5

C Find list of bonds to this atom.
                  M5A = INEWP
                  NFLORIG = NFL           ! SAVE THE NEXT FREE ADDRESS
                  MBSTCK = JS + JT ! Keep well clear 
                  NFL = MBSTCK            ! Temp change NFL.
                  K = KDIST4( JS2, JT, 0, 0)   ! Find the distances
                  NFL = NFLORIG       ! RESET NFL 

                  IF ( K .LT. 0 ) THEN
                   WRITE (CMON,'(A)')'"KDIST4" returned an error.'
                   CALL XPRVDU(NCVDU,1,0)
                   CYCLE
                  END IF

C There is a stack at MBSTCK of all the bonded contacts around the atom at M5A.

                  DISMIN = 999999.0
                  INDDIS = -1

                  DISTWOLOOP: DO JJ = MBSTCK, JS2-JT, JT
                    MNBND = ISTORE(JJ)  ! Get the address in L5 of this atom.
                    DO LL=NMATCHED,NNEW-1  !  Find the bonded atom in the new list.
                     INEWB = L5 + (ISTORE(LMAP+LL*MDATVC)) * MD5
                     IF ( INEWB .EQ. MNBND ) THEN
c                       WRITE(CMON,'(2(A,A4,I5))')'Matched atom: ',
c     1                   ISTORE(IOLDP), NINT(STORE(IOLDP+1)),
c     1                   ' is bonded to: ',ISTORE(IOLDB),
c     1                   NINT(STORE(IOLDB+1))
c                CALL XPRVDU(NCVDU,1,0)

c                       WRITE(CMON,'(2(A,A4,I5))')'and matches: ',
c     1                  ISTORE(INEWP), NINT(STORE(INEWP+1)),
c     1                  ' which is in turn bonded to: ',
c     1                  ISTORE(INEWB), NINT(STORE(INEWB+1))
c                       CALL XPRVDU(NCVDU,1,0)
                       IF ( NINT( STORE(INEWB+13) ).EQ.
     1                      NINT( STORE(IOLDB+13) )    ) THEN
                         INDNEW=LNEW+MDNEW*LL   !Address of XYZnew
                         DISTSQ = 0.0
                         DO KK=1,3
                          DELTA=STORE(INDNEW+KK-1)-STORE(INDOLD+KK-1)
                          DELTSQ=DELTA**2
                          DISTSQ=DISTSQ+DELTSQ
                         END DO

                         IF (ILSTRE.GE.3) THEN
                         IF (ISSPRT .EQ. 0) THEN
                         WRITE(NCWU,1234)
     1                    'Possible match: ',
     1                   ISTORE(INEWB), NINT(STORE(INEWB+1)),
     1                   ISTORE(IOLDB), NINT(STORE(IOLDB+1)), DISTSQ
                         ENDIF
                         ENDIF
             
                         IF (DISTSQ.LT.DISMIN) THEN
                           DISMIN=DISTSQ
                           INDDIS=LL
                         END IF
c                       ELSE
c                         WRITE(CMON,'(A,A4,I5)')
c     1                    'which has different SPARE.'
c                         CALL XPRVDU(NCVDU,1,0)
                       END IF
                     END IF
                    END DO
                  END DO DISTWOLOOP

                  IF ( INDDIS .GE. 0 ) THEN

C Rearrange the 'new' vectors:
                    CALL XMOVE(STORE(LNEW+MDNEW*NMATCHED),
     1                         STORE(LNBUF),MDNEW)
                    CALL XMOVE(STORE(LNEW+MDNEW*INDDIS),
     1               STORE(LNEW+MDNEW*NMATCHED), MDNEW)
                    CALL XMOVE(STORE(LNBUF),
     1               STORE(LNEW+MDNEW*INDDIS),MDNEW)

                    CALL XMOVE(STORE(LMAP+MDATVC*NMATCHED),
     1               STORE(LMBUF),MDATVC)
                    CALL XMOVE(STORE(LMAP+MDATVC*INDDIS),
     1               STORE(LMAP+MDATVC*NMATCHED),MDATVC)
                    CALL XMOVE(STORE(LMBUF),
     1               STORE(LMAP+MDATVC*INDDIS),MDATVC)

C Rearrange the 'old' vectors:

                    CALL XMOVE(STORE(LOLD+MDOLD*NMATCHED),
     1                         STORE(LNBUF),MDOLD)
                    CALL XMOVE(STORE(LOLD+MDOLD*L),
     1               STORE(LOLD+MDOLD*NMATCHED), MDOLD)
                    CALL XMOVE(STORE(LNBUF),
     1               STORE(LOLD+MDOLD*L),MDOLD)

                    CALL XMOVE(STORE(LONTO+MDATVC*NMATCHED),
     1               STORE(LMBUF),MDATVC)
                    CALL XMOVE(STORE(LONTO+MDATVC*L),
     1               STORE(LONTO+MDATVC*NMATCHED),MDATVC)
                    CALL XMOVE(STORE(LMBUF),
     1               STORE(LONTO+MDATVC*L),MDATVC)


                    IOLD5 = L5 + (ISTORE(LONTO+NMATCHED*MDATVC)) * MD5
                    INEW5 = L5 + (ISTORE(LMAP+NMATCHED*MDATVC)) * MD5

                    STORE(LRENM+NMATCHED*MDRENM)   = STORE(IOLD5)
                    STORE(LRENM+NMATCHED*MDRENM+1) = STORE(IOLD5+1)
                    STORE(LRENM+NMATCHED*MDRENM+4)=STORE(INEW5)
                    STORE(LRENM+NMATCHED*MDRENM+5)=STORE(INEW5+1)+ZORIG
c
                    IF (ISSPRT .EQ. 0) THEN
                    WRITE(NCWU,1234)
     2              'Matched:        ',
     1              STORE(IOLD5),NINT(STORE(IOLD5+1)),
     3              STORE(INEW5),NINT(STORE(INEW5+1)),DISMIN
                    ENDIF


c                    WRITE(CMON, '(2(A,A4,I4,3X))'),
c     1               'Atom ', STORE(LRENM+NMATCHED*MDRENM),
c     1               NINT(STORE(LRENM+NMATCHED*MDRENM+1)),
c     1               ' will become ', STORE(LRENM+NMATCHED*MDRENM+4),
c     1               NINT(STORE(LRENM+NMATCHED*MDRENM+5))
c                    CALL XPRVDU(NCVDU,1,0)

                    NMATCHED = NMATCHED + 1


                    EXIT UNMLOOP

                  ELSE

                    WRITE(CMON,'(A)')
     1                '{E Programming error. No match found for:'
                    CALL XPRVDU(NCVDU,1,0)
                    WRITE(CMON,'( A4,2F6.1)')
     1              STORE(IOLD5),STORE(IOLD5+1),STORE(IOLD5+13)
                    CALL XPRVDU(NCVDU,1,0)
                    GOTO 200
                  END IF
                END IF
              END IF
            END DO
            IF ( MOFND .EQ. 0 ) THEN
              WRITE(CMON,'(A)') '{E Pththerror. No match found for:'
              CALL XPRVDU(NCVDU,1,0)
              WRITE(CMON,'( A4,2F6.1)')
     1        STORE(MOBND),STORE(MOBND+1),STORE(MOBND+13)
              CALL XPRVDU(NCVDU,1,0)
              GOTO 200
            END IF
          END DO DISTLOOP

        END DO UNMLOOP

      END DO

      RETURN
 
200   CONTINUE
      CALL XOPMSG (IOPREG,IOPINT,0)
      RETURN
      END

CODE FOR XRGCAM
      SUBROUTINE XRGCAM
C
C    CREATE CAMERON FILES 
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
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'REGTMP.INC'

      CHARACTER*21 CAMATM
      DIMENSION JFRN(4,2)
      DIMENSION RTEMP(9), STEMP(9)
C 
      INCLUDE 'QSTORE.INC'
#ifdef _HOL_
      DATA JFRN /1HF, 1HR, 1HN, 1H1, 1HF, 1HR, 1HN, 1H2 /
#else
      DATA JFRN /'F', 'R', 'N', '1', 'F', 'R', 'N', '2'/
#endif

C
       write(cmon,'(a)') 'Writing CAMERON files'
       CALL XPRVDU(NCVDU,1,0)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
c
      IF(SUMDEV .GE. 0.1)THEN
       NUMDEV =NUMDEV +1
       WRITE(CMON,'(A)') 'WARNING - poor initial fit' 
       CALL OUTCOL(9)
       CALL XPRVDU(NCVDU,1,0)
       CALL OUTCOL(1)
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
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
      WRITE(NCFPU2,
     1 '(''COLO GROUP REG1 GREEN VIEW'')')
      WRITE(NCFPU2,
     1 '(''COLO GROUP REG2 LBLUE VIEW'')')

      WRITE(NCFPU2,'(''COLO O RED VIEW'')')
      WRITE(NCFPU2,'(''COLO N BLUE VIEW'')')
      WRITE(NCFPU2,'(''COLO S YELLOW VIEW'')')

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
c
      DO I=1,NOLD
       INDOLD=LOLD+MDOLD*(I-1)
       INDNEW=LNEW+MDNEW*(I-1)
       inouij=louij+mdouij*(i-1)+1
       inuij=luij+mduij*(i-1)+1
       JOLD=ISTORE(LRENM+(MDRENM*(I-1))+4)
       JNEW=ISTORE(LRENM+(MDRENM*(I-1))+5)
c
c
c      WRITE(123,'(A,(3f6.3,3x,3F6.3,2X,3F6.3))') 'old', 
c     1(STORE(J),J=INDOLD,INDOLD+2),(store(idjw),idjw=inouij,inouij+5)
c
       WRITE(NCFPU1,2016) (STORE(J),J=JOLD,JOLD+3), !Type,ser,occ,flag
     1    (STORE(J),J=INDOLD,INDOLD+2),             !X,Y,Z
     2    (store(idjw),idjw=inouij,inouij+5),       !U's
     2    STORE(JOLD+13),                           !Spare
     3    1,(ISTORE(J),J=JOLD+15,JOLD+17)           !Extras
c
c      WRITE(123,'(A,(3f6.3,3x,3F6.3,2X,3F6.3))') 'new', 
c     1(STORE(J),J=INDNEW,INDNEW+2),(store(idjw),idjw=inuij,inuij+5)
c
c
c
       WRITE(NCFPU1,2016) (STORE(J),J=JNEW,JNEW+3), 
     1   (STORE(J),J=INDNEW,INDNEW+2),
     2   (store(idjw),idjw=inuij,inuij+5),
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
c
      RETURN
 
200   CONTINUE
      CALL XOPMSG (IOPREG,IOPINT,0)
      RETURN
      END
c
c
c
c
c
CODE FOR XMATCH
      SUBROUTINE XMATCH
C   IMPLEMENTS #MATCH
C
C-- CALCULATE A MATCH OR MATCHES BETWEEN TWO FRAGMENTS, AND RUN REGU COMPARE
C-- TO FIND THE BEST ONE.
C
C      LIST - ILSTRE
C      -1 OFF          
C       0 LOW              Default value         
C       1 MEDIUM       
C       2 HIGH
C       3 DEBUG        

C      PUNCH
C      -1 OFF           Default value
C       0 RESULTS      
C
c
c       Structure matching: measures of similarity and pseudosymmetry
c       A.  Collins, R. I.  Cooper and D. J.  Watkin
c       Journal of Applied Crystallography 2006;39(6):842-849
c
      INCLUDE 'ISTORE.INC'
      DIMENSION PROCS(1)
      DIMENSION KATV(5)
      INCLUDE 'STORE.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'XDSTNC.INC'
c      COMMON /XPROCM/ILISTL
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XMATCH.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XCOMPD.INC'
C
      INCLUDE 'QSTORE.INC'
C
c      EQUIVALENCE (ILISTL,PROCS(1))
C
      DATA IDIMN /3/
#ifdef _HOL_
      DATA IPEAK/4HQ   /
#else
      DATA IPEAK/'Q   '/
#endif
C
      DATA IVERSN /101/
c
c     CPCH is a character buffer for punched output
c
      CALL XTIME1(2)                       ! SET THE TIMING FUNCTION
      CALL XCSAE
c  initialise call counter for xrgclc
      icallno = 0
c
      write(cmon,'(a/a/a)')
     1 'Structure matching: measures of similarity and pseudosymmetry',
     2 'A.  Collins, R. I.  Cooper and D. J.  Watkin',
     3 'Journal of Applied Crystallography 2006;39,842-849'
       CALL XPRVDU(NCVDU,3,0)
      if (issprt.eq.0) 
     1 write(ncwu,'(a/a/a)') trim(CMON(1)),trim(CMON(2)),trim(cmon(3))
C
c
      METH = 4    !SET DEFAULT TO KABSCH ROTARY/INVERSION
      CALL XRGSMD(METH)

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
C -- SET MATCHING METHOD TO ROTATION/INVERSION
      CALL XRGSMD(4)
      WRITE (CPCH,'(15A4,a)') (KTITL(I),I=1,15),CHAR(9)
      WRITE(CMON,'(1X/A,15A4)') '{I', (KTITL(I),I=1,15)
      CALL XPRVDU(NCVDU,2,0)
c----- enable printing of Torsions etc
      nogeom = 1      
C--PRINT THE INITIAL CAPTIONS
        CALL XPRTCN

C INSTRUCTION READING LOOP
      DO WHILE (.TRUE.)
C        WRITE (CMON,'(A)') ' Reading instruction '
C        CALL XPRVDU(NCVDU,1,0)
        IDIRNM = KLXSNG(ISTORE(ICOMBF),IDIMBF,INEXTD) ! READ A DIRECTIVE
        IF (IDIRNM .LT. 0) CYCLE
        IF (IDIRNM .EQ. 0) EXIT

        ILSTRE = ISTORE(JCOMBF+0)
        IPCHRE = ISTORE(JCOMBF+2)

        SELECT CASE (IDIRNM)

        CASE(1)     ! 'OUTPUT'


        CASE(7)     ! 'MATCH'
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

cdjwapr2012 
c      The function vector ISTORE(LATVC, NDATVC, NATVC) contains
c      1 in column 2 for MAPPING atoms
c      1 in column 3 for ONTO atoms
c      
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

        CASE (6)    ! 'METHOD'
          METH=NINT(XLXRDV(4.))
C -- SET METHOD TO THIS VALUE
         CALL XRGSMD(METH)

        CASE DEFAULT   !ERROR
          GOTO 9910

        END SELECT
      END DO              ! COMMAND INPUT COMPLETE. CHECK FOR ERRORS:
c
      IF ( LEF .GT. 0 ) GO TO 9910
      IF ( IEQATM .EQ. 0 ) THEN
        IF (KELECN().LT.0) GO TO 9900    ! Put electron count into SPARE
C Check for Q atoms amongst the fragments, if present, the use
C the EQUALATOM approach.
        DO I = 0, N5-1         ! Loop over all the atoms, check for Q
          IF ( ( ISTORE(1+LATVC+I*MDATVC) .EQ. 1 ) .OR.  
     1         ( ISTORE(2+LATVC+I*MDATVC) .EQ. 1 ) ) THEN
            
            IF ( ISTORE(L5+ISTORE(LATVC+I*MDATVC)*MD5) .EQ. IPEAK ) THEN
              IEQATM = 1
            END IF
          ELSE ! Atom not included in fragment
            STORE(L5+13+ISTORE(LATVC+I*MDATVC)*MD5) = 0.0
          END IF
        END DO
      END IF

C EQUALATOM. Don't use element types.
      IF ( IEQATM .NE. 0 ) THEN
        DO I = 0,N5-1
          IF ( ( ISTORE(1+LATVC+I*MDATVC) .EQ. 1 ) .OR.  
     1         ( ISTORE(2+LATVC+I*MDATVC) .EQ. 1 ) ) THEN
            STORE(L5+13+I*MD5) = 10
          ELSE
            STORE(L5+13+I*MD5) = 0  ! Atom not part of fragments
          ENDIF
        END DO
      END IF
C 1ST CALL
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
      INTSYM = 0
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

C Sort each set of atoms into order of uniqueness.
      CALL SSORTI(LMAP, NMAP, MDATVC,5)
      CALL SSORTI(LONTO,NONTO,MDATVC,5)


C Ensure fragments are 2D identical.
      IF ( ( NMAP .EQ. 0 ) .OR. ( NMAP .NE. NONTO ) ) THEN
        WRITE (CMON,'(A)') '{E Fragments are different sizes.'
        CALL XPRVDU(NCVDU,1,0)
        IF (IPCHRE.GE.0)THEN
         WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Residues_different_sizes'
        END IF
        ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 1, 1 )
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
          ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 2, 1 )
          GOTO 9900
        END IF
      END DO

      WRITE (CMON,'(/A,I5)') 'Matches that are unique: ',IUNIQ
      CALL XPRVDU(NCVDU,2,0)

      JOBDON = 0

      IF ( IUNIQ .GE. 3 ) THEN   ! Need three matches to proceed simply.
        IF ( KNONLN() .EQ. 1 ) THEN  ! They must be nonlinear?
          JOBDON = 1
C
C-----------DO QUICK REGULARISATION
C
C 1ST CALL
          CALL XREGQK
C
          ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 0, 1 )
        ELSE IF (IPCHRE.GE.0)THEN
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     'Linear_matching_fragments'
        END IF
      END IF

      IF ( JOBDON .EQ. 0 ) THEN


       IF ( IDOUB .GE. 1 ) THEN ! Try to break sym. Twice.
         INTSYM = INTSYM + 1
         IF (IPCHRE.GE.0)THEN
          WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1    'Internal_symmetry_2'
         END IF

C Sort each set of atoms into index order.
         CALL SSORTI(LMAP, NMAP, MDATVC,1)
         CALL SSORTI(LONTO,NONTO,MDATVC,1)

         IRS1AT = -1

C Find first atom in residue 1 with uniqueness of 2.
         IRS1AT = 0
         DO I = 0, NMAP-1         ! Loop over all the residue 1 atoms

          IF(ILSTRE.GE.3) THEN
           WRITE(NCWU,'(A,5I6,A4,I6)')'1: ',
     2     ISTORE(LMAP+I*MDATVC),ISTORE(1+LMAP+I*MDATVC),
     2     ISTORE(2+LMAP+I*MDATVC),ISTORE(3+LMAP+I*MDATVC),
     3     ISTORE(4+LMAP+I*MDATVC),
     1     ISTORE(L5+MD5*ISTORE(LMAP+I*MDATVC)),
     1     NINT(STORE(1+L5+MD5*ISTORE(LMAP+I*MDATVC)))
          ENDIF
           IF (ISTORE(4+LMAP+I*MDATVC).EQ.2) THEN
             IRS1AT = L5 + ISTORE(LMAP+I*MDATVC) * MD5
             EXIT 
           END IF
         END DO

         IF ( IRS1AT .EQ. -1 ) THEN
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     CHAR(9)//'Uniqueness 2 in residue 1 not found'
           ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 3, 1 )
           GOTO 9900
         END IF


         CRDAT=STORE(13+IRS1AT)

         IF(ILSTRE.GE.3) THEN
          WRITE(NCWU,'(2A,I5)')'Boost one:',STORE(IRS1AT),
     1    NINT(STORE(IRS1AT+1))
         ENDIF

C Find two atoms in residue 2 with uniqueness of 2 of same CARDINALITY
C as IRS1AT
         IRS2A1 = -1
         IRS2A2 = -1
         DO I = 0, NONTO-1         ! Loop over all the residue 2 atoms.

          IF(ILSTRE.GE.3) THEN
           WRITE(NCWU,'(A,5I6,A4,I6)')'2: ' ,
     2     ISTORE(LONTO+I*MDATVC),ISTORE(1+LONTO+I*MDATVC),
     2     ISTORE(2+LONTO+I*MDATVC),ISTORE(3+LONTO+I*MDATVC),
     3     ISTORE(4+LONTO+I*MDATVC),
     1     ISTORE(L5+MD5*ISTORE(LONTO+I*MDATVC)),
     1     NINT(STORE(1+L5+MD5*ISTORE(LONTO+I*MDATVC)))
          ENDIF

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
           ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 4, 1 )
           GOTO 9900
         END IF
         IF ( IRS2A2 .EQ. -1 ) THEN
           WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1     CHAR(9)//'Second Uniqueness 2 in residue 2 not found'
           ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 5, 1 )
           GOTO 9900
         END IF


         DO ISYMBK = 1,2


C Sort each set of atoms into index order.
           CALL SSORTI(LMAP, NMAP, MDATVC,1)
           CALL SSORTI(LONTO,NONTO,MDATVC,1)


           IF ( IEQATM .EQ. 0 ) THEN
             IF (KELECN().LT.0) THEN ! Put electron count into SPARE
               ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 6, 1 )
               GO TO 9900    
             END IF
           ELSE
             DO I = 0,N5-1
               STORE(L5+13+I*MD5) = 10
             END DO
           END IF

           DO I = 0, N5-1         ! Loop over all the atoms
             IF ( ( ISTORE(1+LATVC+I*MDATVC) .NE. 1 ) .AND.  
     1            ( ISTORE(2+LATVC+I*MDATVC) .NE. 1 ) ) THEN
               STORE(L5+13+ISTORE(LATVC+I*MDATVC)*MD5) = 0.0 ! Atom not included in fragments.
             END IF
           END DO

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
C 2ND CALL
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
            ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 7, 1 )
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
              ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 8, 1 )
              GOTO 9900
            END IF
           END DO

           WRITE (CMON,'(/A,I5)') 'Unique matches: ',IUNIQ
           CALL XPRVDU(NCVDU,2,0)

           JOBDON = 0
    
           IF ( IUNIQ .GE. 3 ) THEN   ! Need three matches to proceed simply.
            IF ( KNONLN() .EQ. 1 ) THEN  ! They must be nonlinear?
C 2ND CALL
              JOBDON = 1
              CALL XREGQK
C
              ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 0, 1 )
            ELSE IF (IPCHRE.GE.0)THEN
              WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1        CHAR(9)//'Linear_matching_fragments'
              ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 10, 1 )
              GOTO 9900
            END IF
           ELSE IF (IPCHRE.GE.0)THEN
             WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1       CHAR(9)//'Still_not_enough_unique_matches'
             ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 11, 1 )
           END IF

           IF (JOBDON.EQ.0) THEN
            IF ( IDOUB .GE. 1 ) THEN 
               INTSYM = INTSYM + 2
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'More_Internal_symmetry_2'
               ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 12, 1 )
               GOTO 9900
            ELSE IF ( ITRIP .GE. 1 ) THEN 
               INTSYM = INTSYM + 3
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'More_Internal_symmetry_3'
               ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 13, 1 )
               GOTO 9900
            ELSE IF ( IQUAD .GE. 1 ) THEN
               INTSYM = INTSYM + 4
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'More_Internal_symmetry_4'
               ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 14, 1 )
               GOTO 9900
            ELSE
               INTSYM = INTSYM + 5
               IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1         CHAR(9)//'Internal_symmetry_lots'
               ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 15, 1 )
               GOTO 9900
            END IF
           END IF
         END DO

       ELSE IF ( ITRIP .GE. 1 ) THEN ! Try to break sym. Three times.
        INTSYM = INTSYM + 1
        IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Internal_symmetry_3'
        ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 16, 1 )
          GOTO 9900

       ELSE IF ( IQUAD .GE. 1 ) THEN ! Try to break sym. Four times.
       INTSYM = INTSYM + 1
        IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Internal_symmetry_4'
        ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 17, 1 )
          GOTO 9900

       ELSE
        INTSYM = INTSYM + 1
        IF (IPCHRE.GE.0)WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1   CHAR(9)//'Internal_symmetry_lots'
        ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 18, 1 )
          GOTO 9900

       END IF
      ELSE
c
      END IF
c
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
      CALL XOPMSG ( IOPREG , IOPABN , 0 )
      IF ( IPCHRE .GE. 0 ) WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1 CHAR(9)//'errors'
      IF ( IPCHRE .GE. 0 ) WRITE(CMON,'(1X/A,A)')
     1 '{I', CPCH(1:LEN_TRIM(CPCH))
      CALL XPRVDU(NCVDU,2,0)
      
      GO TO 6050
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDIS , IOPCMI , 0 )
      IF ( IPCHRE .GE. 0 ) WRITE(CPCH(LEN_TRIM(CPCH)+1:),'(A)')
     1 CHAR(9)//'command_input_error'
c      IF ( IPCHRE .GE. 0 ) WRITE(123,'(A)')CPCH(1:LEN_TRIM(CPCH))
      ISTAT = KSCTRN ( 1 , 'MATCH:ERROR' , 9, 1 )
      GO TO 9900
      END
c
c
CODE FOR KNONLN
      FUNCTION KNONLN()
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XMATCH.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
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
c C Changed 20/2/12 - use 2^M3+1 to make an ID that might remain unique under addition operations.
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
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
c - use this for (2^N)+1 -                 STORE(M5+13)=(2**J)+1
               GO TO 100
            END IF
            M3=M3+MD3
         END DO
C No match
         STORE(M5+13)=0.0
         write(cmon,'(a,a)') 
     1  '{E Scattering factors not known for element ', ISTORE(M5)
         call xprvdu(ncvdu,1,0)
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
C
C  This routine currently assumes it is looking at two identical molecules
C  and fragments, and optimises the search speed by freezing out pairs
C  of unique atoms once they have unique IDs. It will still work for
C  multiple fragments, but not as efficiently.
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'

      LTEMP=KSTALL(N5*3)                     ! Get some workspace
      LORIG=LTEMP+N5
      LBEST=LTEMP+N5*2
      MBEST = 0

      DO I = 0, N5-1    ! Copy original SPARE into STORE(LORIG)
        STORE(LORIG+I) = REAL(NINT( STORE(L5+13+I*MD5) ))
        STORE(L5+13+I*MD5) = 1.0
      END DO

      DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B ! Propagate values.
          J51 = ISTORE(M41B)
          J52 = ISTORE(M41B+6)
          I51 = L5 + J51 * MD5
          I52 = L5 + J52 * MD5
          STORE(I51+13) = STORE(I51+13) * 2.0
          STORE(I52+13) = STORE(I52+13) * 2.0
      END DO

      DO I = 0, N5-1    ! Copy original SPARE into STORE(LORIG)
        STORE(L5+13+I*MD5) = STORE(L5+13+I*MD5) * STORE(LORIG+I)
      END DO


      IDOCNT = -1
      NOIMPR = 0
      IMAXSP = 0
      NCYCLE = 0


C Once a pair of atoms have unique ID's, those ID's are set negative and
C are not touched again.

      DO WHILE ( .TRUE. )

        NCYCLE = NCYCLE + 1

        DO I = 0, N5-1    ! Copy existing SPARE into STORE(LTEMP)
          IF ( IMAXSP .GT. 999999 ) THEN   ! Scale down the large values
            I51 = L5 + I * MD5
            IF ( STORE(I51+13) .GT. 9999 )
     1         STORE(I51+13) = NINT(STORE(I51+13) / 10.0)
          END IF
          STORE(LTEMP+I) = ABS(REAL(NINT( STORE(L5+13+I*MD5) )))
        END DO

        DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B ! Propagate values.
          J51 = ISTORE(M41B)
          J52 = ISTORE(M41B+6)
          I51 = L5 + J51 * MD5
          I52 = L5 + J52 * MD5
          IF ( STORE(I51+13) .GE. 0.0 )
     1       STORE(I51+13) = REAL(NINT(STORE(I51+13)+STORE(LTEMP+J52)))
          IF ( STORE(I52+13) .GE. 0.0 )
     1       STORE(I52+13) = REAL(NINT(STORE(I52+13)+STORE(LTEMP+J51)))
        END DO

        IMAXSP = 0
        DO I = 0, N5-1               ! Copy new SPARE into ISTORE(LTEMP)
          ISTORE(LTEMP+I) = ABS(NINT( STORE(L5+13+I*MD5) ))
          IMAXSP = MAX ( IMAXSP, ISTORE(LTEMP+I) )
c          WRITE(CMON,'(A,I5,F16.2))')ISTORE(L5+I*MD5),
c     1        NINT(STORE(L5+I*MD5+1)),STORE(L5+I*MD5+13)
c          CALL XPRVDU(NCVDU,1,0)
        END DO

c        DO I = 0, N5       ! Debug
c          IF ( ISTORE(LTEMP+I) .EQ. 0 ) THEN
c            WRITE(CMON,'(A,A4,I8)')
c     1          'Excluded atom ',ISTORE(L5+I*MD5),
c     2           NINT(STORE(L5+I*MD5+1))
c              CALL XPRVDU(NCVDU,1,0)
c            CYCLE  ! Don't consider excluded atoms
c          END IF
c          WRITE(CMON,'(A,A4,2I8)')
c     1          'Included atom ',ISTORE(L5+I*MD5),
c     2           NINT(STORE(L5+I*MD5+1)),ISTORE(LTEMP+I)
c          CALL XPRVDU(NCVDU,1,0)
c        END DO


        CALL SSORTI(LTEMP,N5,1,1) ! Sort data at LTEMP
 
        LASTID = -1
        NCONSE = 2
        IDCOUN = -1
        IDUNIQ = 0
        NATMS = N5

        DO I = 0, N5       ! Count number of unique ID's. (Over run by 1)

          IF ( ISTORE(LTEMP+I) .EQ. 0 ) THEN
            NATMS = NATMS - 1
            CYCLE  ! Don't consider excluded atoms
          END IF

          IF ((I.EQ.N5) .OR. ( ISTORE(LTEMP+I) .NE. LASTID)) THEN
            IF ( MOD(NCONSE,2) .EQ. 1 ) THEN
              WRITE(CMON,'(A,I8)')
     1          '{E Error. Odd # consecutive IDs',LASTID
              CALL XPRVDU(NCVDU,1,0)
            ELSE IF ( NCONSE .EQ. 2 ) THEN  ! Those were unique.
              IF ( LASTID .GT. 0 ) THEN  ! Not first time
                IDUNIQ = IDUNIQ + 1
                DO J = 0,N5-1
                  J51 = L5 + J * MD5
                  IF (ABS(NINT(STORE(J51+13))).EQ.LASTID) 
     1                STORE(J51+13) = - ABS(STORE(J51+13))
                END DO
              END IF
            END IF
            IDCOUN = IDCOUN + 1
            LASTID = ISTORE(LTEMP+I)
            NCONSE = 1
          ELSE
            NCONSE = NCONSE + 1
          END IF
        END DO

        IF (ISSPRT .EQ. 0) THEN
        WRITE(CMON,'(3(A,I6),A)')'ID Cycle ',NCYCLE,' has ',
     1  IDCOUN,' unique IDs and ',IDUNIQ,' unique pairs of atoms.'
        ENDIF

        IF ( IDCOUN*2 .EQ. NATMS ) THEN
          WRITE(CMON,'(A)') 'All pairs unique. Stopping.'
          CALL XPRVDU(NCVDU,1,0)
          IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
          DO I = 0, N5-1       ! Copy SPARE into BEST
            ISTORE(LBEST+I) = NINT( STORE(L5+13+I*MD5) )
          END DO
          EXIT
        END IF

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

        IF ( NOIMPR .GE. 10 ) EXIT  ! If # unique unimproved ten times then break.

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

      INCLUDE 'ICOM12.INC'
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XRGCOM.INC'
      INCLUDE 'XRGLST.INC'
      INCLUDE 'XMATCH.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XRGRP.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST12.INC'

      DATA IVERS /100/
      CALL XTIME1(2)

      NUMDEV = 0      ! INITIALISE THE POOR-FIT COUNTER
      IPCHSA = IPCHRE ! Hide IPCHRE counter
      IPCHRE = -1

      INCLUDE 'IDIM12.INC'
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
      MDOUIJ = 7
      MDOCC = 2
      NNEW = 0

cdjwjan08
c      IMETHD=1       ! DEFAULT METHOD 1 (ROTATION COMPONENT OF ROTATION-DILATION MATRIX ONLY)
C      IMETHD=4       ! DEFAULT METHOD 4 (Kabsch rotation/inversion)
C  IMETHD NOW FOUND FROM METHOD CARD
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
      LOUIJ=KSTALL(NMAP*MDOUIJ)
      LOCC=KSTALL(NMAP*MDOCC)
      LRENM = KSTALL(MDRENM*NMAP)  ! ALLOCATE SPACE FOR RENAMING
C Allocate space for new space group closed set testing 
      MLTPLY = 2 * N2 * N2P * ( IC + 1 ) ! Twice current multiplicity.
C Space for upper triangle, each matrix has 16 entries. (N(N-1)/2 ops)
      MSGT = 8*MLTPLY*(MLTPLY+1)
      LSGT = KSTALL(MSGT)
      CALL XZEROF(STORE(LSGT),MSGT)
c
C     SAVE NFL and LFL
      IRNFL = NFL
      IRLFL = LFL
c
C Tell it how big the unique group is.
c
      NATMD = IUNIQ
      NOLD = IUNIQ
      NNEW = IUNIQ
      IGRPNO=IGRPNO+1             ! INCREMENT GROUP SERIAL NUMBER
      IFLCMP=2                    ! SET REPLACE/COMPARE FLAG TO COMPARE
c
C LRENM,MDRENM will contain the old atoms (MAP) followed by the
C new atoms (ONTO). In this routine, the type and serial are set.
C Form is:  0  TYPE  of old (ONTO) atom       NB. These aren't paired 
C           1  SERIAL of old (ONTO) atom          yet. Just two lists
C           2  TYPE of new (MAP) atom             held in the same 
C           3  SERIAL of new (MAP) atom.          vector.
C           4  L5 address of OLD, overwritten later if using for RENAME
C           5  L5 address of NEW, overwritten later if using for RENAME
c
c      WRITE(CMON,'(A/3(3F10.3/))')'L1O1 XRG1:',(STORE(L1O1+I),I=0,8)
c      CALL XPRVDU(NCVDU,3,0)
c
      MNEW = LNEW
      MUIJ = LUIJ
      MOCC = LOCC
      MRENM = LRENM
      MATMD = LATMD
      DO I = 0, NMAP-1
        IF ( ISTORE(4+LMAP+I*MDATVC) .EQ. 1 ) THEN
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+2),STORE(MOCC),1)    ! OCC
          CALL XMOVE (STORE(I5+3),STORE(MOCC+1),1)  ! flag
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)    ! XYZ
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)    ! Flag
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)  ! Uijs
          CALL XMOVE (STORE(I5),STORE(MATMD),MDATMD)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5
cdjwapr2012
12300 format(2a4,f4.0, 2f4.1, 3f8.3, 3x, 6f8.3)
          MNEW = MNEW + 4
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
          MUIJ = MUIJ + MDUIJ
          MOCC = MOCC + MDOCC
        END IF
      END DO

      MOLD = LOLD
      MRENM = LRENM
cdjwapr2012
      mouij = louij
c
      DO I = 0, NONTO-1
        IF ( ISTORE(4+LONTO+I*MDATVC) .EQ. 1 ) THEN
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+4),STORE(MOLD),3)
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM),2)
cdjwapl2012
          call xmove(store(i5+3), store(mouij), 1) 
          call xmove(store(i5+7), store(mouij+1), 6) 
          mouij = mouij+mdouij
c
          ISTORE(MRENM+4) = I5
          MOLD = MOLD + 4
          MRENM = MRENM + 6
        END IF
      END DO

      WRITE ( CMON,'(A,I5,A)') 'Initially matching ', IUNIQ,' atoms.'
      CALL XPRVDU(NCVDU, 1,0)
c
c 1st call - SET IMATRIX TO ZERO TO SUPPRESS FULL LISTING
      IMATRIX = 0
      CALL XRGCLC(IMATRIX,0)

C     Restore NFL and LFL
      NFL = IRNFL
      LFL = IRLFL



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
      MOCC = LOCC
      DO I = 0, NMAP-1
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )

          CALL XMOVE (STORE(I5),  STORE(MATMD),MDATMD)
          CALL XMOVE (STORE(I5+2),STORE(MOCC),1)
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5
          MNEW = MNEW + 4
          MUIJ = MUIJ + MDUIJ
          MOCC = MOCC + MDOCC
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
      END DO

      MOLD = LOLD
      MOUIJ = LOUIJ
      MRENM = LRENM
      DO I = 0, NONTO-1
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5),   STORE(MRENM),2)
          CALL XMOVE (STORE(I5+3), STORE(MOUIJ),1) 
          CALL XMOVE (STORE(I5+4), STORE(MOLD),3)
          CALL XMOVE (STORE(I5+7), STORE(MOUIJ+1),6) 
          ISTORE(MRENM+4) = I5
          MOLD = MOLD + 4
          MRENM = MRENM + 6
          MOUIJ = MOUIJ + MDOUIJ
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

      WRITE ( CMON,'(A)') 'Matching the rest.'
      CALL XPRVDU(NCVDU, 1,0)
c
c 2nd call
      IMATRIX = 3
      CALL XRGCLC(IMATRIX,1)

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

c        IMETHD=1       ! DEFAULT METHOD 1 (ROTATION COMPONENT OF ROTATION-DILATION MATRIX ONLY)
C        IMETHD=4       ! DEFAULT METHOD 4 (Kabsch rotation/inversion)
C  IMETHD NOW FOUND FROM METHOD CARD
        CALL XZEROF(ORIGIN(1),3)   ! ZERO ORIGIN
        CALL XUNTM3(RGMAT(1,1))    ! SET TO ZERO ROTATION
        MDRENM = 6
        IFLCMP=2                    ! SET REPLACE/COMPARE FLAG TO COMPARE

        NATMD= NMAP
        NOLD = NMAP
        NNEW = NMAP
        MNEW = LNEW
        MUIJ = LUIJ
        MOCC = LOCC
        MRENM = LRENM
        MATMD = LATMD
        DO I = 0, NMAP-1
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+2),STORE(MOCC),1)
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)
          CALL XMOVE (STORE(I5  ),STORE(MATMD),MDATMD)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5

c          WRITE(CMON,'(A,3F10.3,I5)')'MAP: ',(STORE(MNEW+K),K=0,2),I5
c          CALL XPRVDU(NCVDU,1,0)

          MNEW = MNEW + 4
          MUIJ = MUIJ + MDUIJ
          MOCC = MOCC + MDOCC
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
        END DO


        MOLD = LOLD
        MOUIJ = LOUIJ
        MRENM = LRENM
        DO I = 0, NONTO-1
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
          CALL XMOVE (STORE(I5+3),STORE(MOUIJ),1)
          CALL XMOVE (STORE(I5+4),STORE(MOLD),3)
          CALL XMOVE (STORE(I5+7),STORE(MOUIJ+1),6)
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM),2)
          ISTORE(MRENM+4) = I5
          MOLD = MOLD + 4
          MOUIJ = MOUIJ + MDOUIJ
          MRENM = MRENM + 6
        END DO

        IPCHRE = IPCHSA ! Restore IPCHRE counter
c 3rd call
        IMATRIX = -1
        CALL XRGCLC(IMATRIX,0)

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
        MOCC = LOCC
        MATMD = LATMD
        MRENM = LRENM
        DO I = 0, NMAP-1
          I5 = L5 + ( (ISTORE(LMAP+I*MDATVC)) * MD5 )
cdjwapr2012
c  these are the original coordinates and Uij of set 1
C      write(123,12300)'D ', (store(idjw),idjw=i5,i5+12)
          CALL XMOVE (STORE(I5+2),STORE(MOCC),1)
          CALL XMOVE (STORE(I5+4),STORE(MNEW),3)
          CALL XMOVE (STORE(I5+3),STORE(MUIJ),1)
          CALL XMOVE (STORE(I5+7),STORE(MUIJ+1),6)
          CALL XMOVE (STORE(I5),STORE(MATMD),MDATMD)
          STORE(MNEW+3) = 1.0
          CALL XMOVE (STORE(I5),STORE(MRENM+2),2)
          ISTORE(MRENM+5) = I5
          MNEW = MNEW + 4
          MUIJ = MUIJ + MDUIJ
          MOCC = MOCC + MDOCC
          MRENM = MRENM + 6
          MATMD = MATMD + MDATMD
        END DO
c
        MOLD = LOLD
        MRENM = LRENM
        MOUIJ = LOUIJ
        DO I = 0, NONTO-1
          I5 = L5 + ( (ISTORE(LONTO+I*MDATVC)) * MD5 )
cdjwapr2012
c  these are the original coordinates and Uij of set 2
c  Note that the UIj are not copied
C      write(123,12300)'E ', (store(idjw),idjw=i5,i5+12)
          CALL XMOVE (STORE(I5+4),STORE(MOLD),3)
          CALL XMOVE (STORE(I5),STORE(MRENM),2)
          STORE(MOLD+3) = 1.0
          CALL XMOVE (STORE(I5+3),STORE(MOUIJ),1)
          CALL XMOVE (STORE(I5+7),STORE(MOUIJ+1),6)
          ISTORE(MRENM+4) = I5
          MOLD = MOLD + 4
          MRENM = MRENM + 6
          MOUIJ = MOUIJ + MDUIJ
        END DO
        IPCHRE = -1 ! Hide punch flag
c
c 4th and last call
        IMATRIX = 2
        CALL XRGCLC(IMATRIX,1)

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
       IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') trim(CMON(1))
      ENDIF

C -- THIS IS THE ONLY WAY OUT OF THE ROUTINE
C -- WRITE FINAL MESSAGE
      IPCHRE = IPCHSA ! Restore IPCHRE counter

      CALL XOPMSG( IOPREG, IOPEND, IVERS)
      CALL XTIME2(2)
      RETURN
      END




CODE FOR CMPMAT(A,B,N)
      FUNCTION CMPMAT(A,B,N)
      DIMENSION A(N)
      DIMENSION B(N)


CC Compare how close two matrices are. For now use cross-correlation:
CC
CC r = SUMi [(Ai-<A>)(Bi-<B>)] / sqrt(SUMi[(Ai-<A>)^2]*SUMi[(Bi-<B>)^2])
C
C FEB04: Change this to a simple RMS deviation type calculation, 
C subtract answer from 1 to get same sense of answer.
C
C 1 = perfect match, less for non-perfect matches.

C Get averages
c      AVA = 0.0
c      AVB = 0.0
c      DO I = 1,N
c        AVA = AVA + A(I)
c        AVB = AVB + B(I)
c      END DO
c      AVA = AVA / N
c      AVB = AVB / N
c
cC Do sum of prod of diffs
c      SUMAB = 0.0
cC and sum of diffs squared
c      SUMAA = 0.0
c      SUMBB = 0.0
c
c      DO I = 1,N
c        SUMAB = SUMAB + (A(I)-AVA) * (B(I)-AVB)
c        SUMAA = SUMAA + (A(I)-AVA)**2
c        SUMBB = SUMBB + (B(I)-AVB)**2
c      END DO
c
c      IF ( ABS(SUMAB) + ABS(SUMAA) + ABS(SUMBB) .LT. 0.00001 ) THEN
cC Perfect match. Answer tends to 1 as these numbers all tend to zero.
c        CMPMAT = 1.0
c      ELSE
cC Do the maths, but be mindful of divide by zero.
c        DENOM = MAX(0.00001,SQRT(SUMAA*SUMBB)) ! Ensure non-zero denominator
c        CMPMAT = SUMAB/DENOM
c      END IF


C R = SQRT( { SUMi ( [Ai-Bi]**2 ) } / N )

      DEVS = 0.0

      DO I = 1,N
        DEVS = DEVS + ( A(I)-B(I) )**2
      END DO

      CMPMAT = SQRT ( ABS ( DEVS / FLOAT(N) ) )

      RETURN
      END
C
CODE FOR TEMPRINT
      SUBROUTINE TEMPRINT(A,N)
      INCLUDE 'XUNITS.INC'
      DIMENSION A(N)
      WRITE(NCWU,'(A,4X,A4,20F8.4)') 'TMP    ', (A(I),I=1,N)      
      RETURN
      END

CODE FOR EXPUIJ
      SUBROUTINE EXPUIJ(UCRY,UTENS)
C      EXPAND THE 6 CRYSTALS UIJ TO A 3X3 TENSOR
       DIMENSION UCRY(6), UTENS(9)
c
       UTENS(1)=UCRY(1)  !U11
       UTENS(2)=UCRY(6)  !U12
       UTENS(3)=UCRY(5)  !U13
       UTENS(4)=UCRY(6)  !U21
       UTENS(5)=UCRY(2)  !U22
       UTENS(6)=UCRY(4)  !U23
       UTENS(7)=UCRY(5)  !U31
       UTENS(8)=UCRY(4)  !U32
       UTENS(9)=UCRY(3)  !U33
      RETURN
      END

CODE FOR CMPUIJ
      SUBROUTINE CMPUIJ(UTENS,UCRY)
C      COMPRESS THE 3X3 TENSOR TO 6 CRYSTALS UIJ
       DIMENSION UCRY(6), UTENS(9)

         UCRY(1) =UTENS(1)      !U11
         UCRY(2) =UTENS(5)      !U22
         UCRY(3) =UTENS(9)      !U33
         UCRY(4) =UTENS(6)      !U23
         UCRY(5) =UTENS(3)      !U31
         UCRY(6) =UTENS(2)      !U32
      RETURN
      END
CODE FOR DMATRX
      SUBROUTINE DMATRX (DMATRIX)
c  POST MULTIPLIER FOR ORTHOGONALISATION OF Uij
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      DIMENSION DMATRIX(9)
c
c      dmatrix is a digonal matrix based on cell angles - see
c      Lipson and Conhran, Second ediition, page 30
      dn = 1.+2.* 
     1 cos(store(l1p1+3))*cos(store(l1p1+4))*cos(store(l1p1+5))
     2 - cos(store(l1p1+3))*cos(store(l1p1+3))
     3 - cos(store(l1p1+4))*cos(store(l1p1+4))
     4 - cos(store(l1p1+5))*cos(store(l1p1+5))
      dn = sqrt(dn)
      call xzerof(dmatrix,9)
      dmatrix(1) = sin(store(l1p1+3))/(dn*store(l1p1))
      dmatrix(5) = sin(store(l1p1+4))/(dn*store(l1p1+1))
      dmatrix(9) = sin(store(l1p1+5))/(dn*store(l1p1+2))
      return
      end
C
C
CODE FOR ORTUIJ
      SUBROUTINE ORTUIJ (TEMP)
c  Matrix to ORTHOGONALISE THE uij
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      DIMENSION DMATRIX(9), TEMP(9)
c
      CALL DMATRX(DMATRIX)
c     form A.D       where A is the orthogonalisation matrix
c                      and D iS the L&C D matrix
      call xmlttm (store(l1o1), dmatrix, temp,3,3,3)
      return
      end
C
CODE FOR RMXUIJ
      SUBROUTINE RMXUIJ (rotate, LU,MDU,NU)
c  apply the transformation at ROTATE to the un-orthogonal Uij list at LUIJ
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      DIMENSION  rotate(9), RTEMP(9), STEMP(9)
c
c      see Lipson and Cochran, Second ediition, page 302
C
c     dont forget that first element is a flag
      DO I=1,NU
      MU=LU+MDU*(I-1)+1
c 
      if (nint(store(mu-1)) .eq. 0) then
c       aniso - transform it
       call rotuij(store(mu), rotate, store(mu))
      endif
c
      mu=mu+mdu
      ENDDO
      return
      end     
C
CODE FOR ROTUIJ
      SUBROUTINE ROTUIJ (UIN,ROTATE,UOUT)
c  rotate the uij
      DIMENSION UIN(6), UOUT(6), ROTATE(9)
      DIMENSION STEMP1(9), STEMP2(9), stemp3(9)
c
      call expuij(uin, stemp2)
      call xmltmm(rotate, stemp2, stemp3,3,3,3)
      call xmltmt(stemp3, rotate, stemp2,3,3,3)
      call cmpuij(stemp2, uout)
      return
      end
C
CODE FOR XDIA
      SUBROUTINE XDIA(UIN, UOUT, UAXIS)
C
C GET PRINCIPAL AXES OF AN ORTHOGONAL TENSOR
C
      DIMENSION UIN(6), TEMP(3,3), UAXIS(3), UOUT(3,3)
      DOUBLE PRECISION TENS(3,3),ROOTS(3),WORK(9)
C
C      EXPAND THE 6 CRYSTALS UIJ TO A 3X3 TENSOR
       CALL EXPUIJ(UIN,TEMP)
C--DIAGONALIZE THE TENSOR
            DO  ITEMP2=1,3
               DO  ITEMP3=1,3
                TENS(ITEMP3,ITEMP2)=TEMP(ITEMP3,ITEMP2)
               ENDDO
            ENDDO
            INFO = 0
            CALL DSYEV('V','L',3,TENS,3,ROOTS,WORK,9,INFO)
c
            DO  ITEMP3=1,3
               UAXIS(ITEMP3)=SNGL(ROOTS(ITEMP3))
               DO  ITEMP4=1,3
                UOUT(ITEMP4,ITEMP3)=SNGL(TENS(ITEMP4,ITEMP3))
               ENDDO
            ENDDO
            RETURN
            END
