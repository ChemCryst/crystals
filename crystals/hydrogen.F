C $Log: not supported by cvs2svn $
C Revision 1.40  2011/04/18 11:26:57  rich
C Reinstate ctemp
C
C Revision 1.39  2011/04/08 12:54:35  djw
C Just add a few comments
C
C Revision 1.38  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.37  2011/03/07 13:41:53  djw
C Fix bug affecting phenyl hydrogen - buffer was too small
C
C Revision 1.36  2009/06/08 14:25:26  djw
C Remove debugging lines
C
C Revision 1.35  2009/05/19 14:35:52  djw
C More lower case filename changes
C
C Revision 1.34  2009/04/08 07:35:38  djw
C Use covalent radii to refine hydrogen placement of pi ligands near metals
C
C Revision 1.33  2008/10/01 11:11:54  djw
C Support for treatment of Deuterium as hydrogen
C
C Revision 1.32  2008/09/22 15:23:24  djw
C Output U-prime in AXES and fix long standing bug in calls rom XEQUIV - turned out NFL was mis-set
C
C Revision 1.31  2007/10/09 06:50:37  djw
C reset C-H distance to 0.95, add autorenumbering
C
C Revision 1.30  2006/09/22 08:20:51  djw
C use bondtable for perhydro generation
C
C Revision 1.29  2006/05/08 16:11:37  djw
C new DELH and PERH file system
C
C Revision 1.28  2006/05/08 13:23:45  djw
C Create a delete file for hydrogens  created by perhydro
C
C Revision 1.27  2006/05/03 14:23:40  djw
C Write names of created hydrogens to a delete hydrogens file on unit NCCBU (the old common block file). Set attributes to CIF and unlocked
C
C Revision 1.26  2006/04/28 16:39:38  djw
C Tune Sp3 hydrogen detection
C
C Revision 1.25  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.24  2004/05/18 12:38:09  djw
C Reinstate Spagna's code as an (unused) option in case it turns out useful later. Code now commented and explained.  Remove writes to NCAWU, and tidy writes to NCWU
C
C Revision 1.23  2004/05/18 10:28:03  djw
C More robust H13 action in response to comments by Alison Edwards
C
C Revision 1.22  2003/10/31 17:21:27  rich
C Remove debugging prints.
C
C Pass the OUTPUTLIST parameter of \PERHYDRO onto the command-line of
C the generated \HYDROGEN commands.
C
C Revision 1.21  2003/08/18 12:26:00  rich
C Filter list of distances returned by KDIST1 to prevent 2nd and 3rd atom
C being on the same site when it is a special position. Still to be done:
C set occupancies of H's when this occurs.
C
C Revision 1.20  2003/08/05 11:11:11  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.19  2003/01/14 10:16:06  rich
C Use XPROCC common block from macro file.
C
C Revision 1.18  2002/12/16 18:25:01  rich
C Change call to KDIST1.
C
C Create H's with same part number as parent atom.
C
C Revision 1.17  2002/10/02 13:39:51  rich
C KDIST1 call requires extra param.
C
C Revision 1.16  2002/06/28 16:13:10  Administrator
C ensure that the field NEW can hold characters
C
C Revision 1.15  2002/03/13 12:35:22  richard
C Added extra argument to calls to KDIST1.
C
C Revision 1.14  2002/02/27 19:30:18  ckp2
C RIC: Increase lengths of lots of strings to 256 chars to allow much longer paths.
C RIC: Ensure consistent use of backslash after CRYSDIR:
C
C Revision 1.13  2002/02/12 12:47:13  Administrator
C Set the 'PART' flag
C
C Revision 1.12  2001/08/23 15:18:43  Administrator
C Evade singulrities
C
C Revision 1.11  2001/06/18 08:26:44  richard
C Replace XPROCC common blocks with macro references. Two common block variables
C (TOLER and ITRANS) were being set in two separate data statements. Fixed.
C
C Revision 1.10  2001/03/28 12:49:43  richard
C Fixed call to KDIST1 that had an 'O' instead of a '0' in the argument list.
C This is the sort of thing that crashes spacecraft and gives Fortran a bad name.
C
C Revision 1.9  2001/03/26 16:40:26  richard
C Increased possible path length from 32 to 64 for RIDEH.DAT output.
C
C Revision 1.8  2001/02/26 10:24:13  richard
C Added changelog to top of file
C
C
CODE FOR SYDROG
      SUBROUTINE SYDROG
C--SUBROUTINE TO CALCULATE THE POSITIONS OF HYDROGEN ATOMS
C - djw
C--CONTROL VARIABLES
C
C  JA  = LFL LAST FREE LOCATION  -  USED FOR THE ATOM STACK
C  JB  CURRENT VALUE OF JA
C  JC  NUMBER OF ATOMS
C  JD  = NFL NEXT FREE LOCATION  -  USED FOR THE ORTHOGONAL COORDS.
C  JE  CURRENT VALUE OF JD
C  JF  NEXT FREE LOCATION AFTER THE COORDINATES
C  JG  CURRENT VALUE OF JF
C  JS  NUMBER OF HYDROGEN ATOMS
C  JTA ADDRESS OF THE FIRST HYDROGEN ATOMS
C  JT  CURRENT VALUE OF JTA
Cdjwsep08  JU  5 WORD WORK AREA
c  IEQUIV ADDRESS OF 5 word work area (IN XWORKH)
C
C- -OTHER IMPORTANT VARIABLES
C
C  SY  VALUE OF U(ISO) FOR THE HYDROGENS
C  JZ  CONTROL LINKED TO U(ISO)
C      0  USE THE VALUE INPUT FOR U[ISO]
C      1  USE THE VALUE FROM THE ADJACENT ATOM
C  SX  DISTANCE C-H TO USE
C  SW  SERIAL NUMBER START FOR THE HYDROGENS
C  SV  VALUE OF OCC FOR THE HYDROGENS
C  KPR VALUE OF PART FOR THE HYDROGENS
C  KRES VALUE OF THE RESIDUE (IN XWORKH)
C
C--
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM12.INC'
C
      DIMENSION INEXT(1)
C1
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST12.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
C
#ifdef _HOL_
      DATA INEXT(1) / 4HNEXT /
#else
      DATA INEXT(1) / 'NEXT' /
#endif
C
C--SET THE INITIAL TIMING
      CALL XTIME1(2)
C--READ THE INPUT DATA
      IF ( KLEXAN(IULN,IFIRST,LENGTH) .LT. 0 ) GO TO 9910
C--DATA INPUT  -  CLEAR THE STORE
      CALL XRSL
      CALL XCSAE
C----- CLEAR A BUFFER
      IEQUIV = NFL
      NFL = NFL + 5
C----- SET THE DEFAULT TEMPERATURE FACTOR MULTIPLIER
      UMULT = 1.0
C
C--LOAD LISTS 1 AND 2
      CALL XFAL01
      CALL XFAL02
C--SORT OUT THE INPUT LIST
      LA=KTYP05(MX)
      CALL XLDRO5(LA)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--WORK THE TYPE OF THE OUTPUT LIST
      LB=KTYP05(MY)
      INCLUDE 'IDIM12.INC'
C--INDICATE THAT LIST 12 IS NOT TO BE USED
      DO 1050 I=1,IDIM12
      ICOM12(I)=NOWT
1050  CONTINUE
C--PREPARE FOR PROCESSING OF THE LEXICAL SCANNER OUTPUT
      CALL XILEXP(IULN,IFIRST)
C--SET UP THE CORE AREA TO HOLD THE GENERATED HYDROGEN ATOMS
      LFL=LFL-100
      JTA=LFL+1
C--SET THE SYSTEM DEFAULT CONSTANTS
      SY=0.05
      JZ = 1
      UDEF = 1.2
      UMULT = udef
      SDEF=0.95
      SX = SDEF
      SW=1.0
      SV=1.0
      KPR = 0
      KRES = 0
      JS=0
C
C--MAIN INSTRUCTION CYCLING LOOP  -  SET THE BUFFER ADDRESS AFTER THE LA
1100  CONTINUE
      MD=MD+JS*MD5
C--SET THE POINTER TO THE ADDRESS OF THE GENERATED HYDROGEN ATOMS
      JT=JTA
      IDWZAP = 0
      IF(KLDNLR(IDWZAP))3450,1150,4200
C--SET THE POINTER TO THE ATOM STACK
1150  CONTINUE
      JA=LFL-MD5A
      JB=JA
      JC=0
C--SET THE POINTER TO THE TOP OF THE ORTHOGONAL COORDS. STACK
      JD=NFL
      JE=JD
cdjwsep08
c  set nfl beyond 6 sets of atoms (6*3)
cdjwmar2011 increase from 4 (1 sp3) to 6 (phenyl)
      nfl = nfl + 18
      ASSIGN 4250 TO NRET
      GOTO(1250,1600,1750,2050,2050,2050,2050,2050,2050,2050,2050,
     2 3700,1200),MG
C1200  STOP346
1200  CALL GUEXIT(346)
C
C--'DISTANCE' INSTRUCTION
1250  CONTINUE
      SX = SDEF
      IF(ME)1300,1300,1400
1300  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1350)
      WRITE ( CMON, 1350)
      CALL XPRVDU(NCVDU, 1,0)
1350  FORMAT(' No arguments found')
      GOTO 4200
C--READ THE DISTANCE
1400  CONTINUE
      IF(KSYNUM(Z))1450,1550,1450
1450  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1500)ISTORE(MF+1)
      WRITE ( CMON, 1500) ISTORE(MF+1)
      CALL XPRVDU(NCVDU, 1,0)
1500  FORMAT(' New value of wrong type or missing',
     2 ' at about column',I5)
      GOTO 4200
1550  CONTINUE
      SX=Z
      GOTO 4250
C
C--'SERIAL' INSTRUCTION
1600  CONTINUE
      IF(ME)1300,1300,1650
1650  CONTINUE
      IF(KSYNUM(Z))1450,1700,1450
1700  CONTINUE
      SW=Z
      GOTO 4250
C
C--'UISO' INSTRUCTION
1750  CONTINUE
      IF(ME)1300,1300,1800
C--CHECK THE TYPE OF ARGUMENT
1800  CONTINUE
      IF(ISTORE(MF))1850,1950,1450
C--CHECK IF THIS IS A 'CARB' DIRECTIVE
1850  CONTINUE
      J = KCOMP(1, ISTORE(MF+2), INEXT, 1, 1)
      IF(J)1450,1450,1900
1900  JZ=1
C----- GET THE U MULTIPLIER
      ME = ME - 1
C----- RE-SET THE DEFAULT TEMPERATURE FACTOR MULTIPLIER
      UMULT = udef
      IF (ME .LE. 0) GOTO 4250
      MF = MF + LK2
      IF (ISTORE(MF) .NE. 0) GOTO 1450
      IF (KSYNUM(Z) .NE. 0) GOTO 1450
      UMULT = Z
      GOTO 4250
C--READ THE NUMBER OFF THE CARD
1950  CONTINUE
      IF(KSYNUM(Z))1450,2000,1450
C--STORE THE NUMBER AND RESET THE FLAG
2000  CONTINUE
      JZ=0
      SY=Z
      GOTO 4250
C
C--GEOMETRICAL INSTRUCTIONS
2050  CONTINUE
      M5A=L5+MD5*(N5-1)
      ASSIGN 2100 TO NRET
C--CHECK IF THERE ARE ANY HYDROGENS TO OUTPUT
      IF(JS)2100,2100,4000
2100  CONTINUE
      JS=0
      IF(ME)1300,1300,2200
C--CHECK IF THERE MORE ARGUMENTS TO PROCESS
2150  CONTINUE
      IF(KOP(8))2600,2200,2200
C--READ THE NEXT ATOM(S)
2200  CONTINUE
      IF(KATOMU(LN))4200,4200,2250
C--CHECK THAT NO COORDINATES HAVE BEEN GIVEN
2250  CONTINUE
      IF(ISTORE(MQ+5))2300,2400,2300
2300  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2350)
      WRITE ( CMON, 2350)
      CALL XPRVDU(NCVDU, 1,0)
2350  FORMAT(' Parameters are illegal for this instruction')
      GOTO 4200
C--TRANSFER THE ATOMS TO THE ATOM STACK
2400  CONTINUE
      DO 2550 I=1,N5A
C--CHECK THAT THERE IS ENOUGH ROOM
      IF ( JB - NFL - 100 ) 9930 , 9930 , 2450
C--GENERATE THE TRANSFORMED COORDINATES
2450  CONTINUE
      JC=JC+1
      IF(KATOMS(MQ,M5A,JB))4200,4200,2500
2500  CONTINUE
      JB=JB-MD5A
      M5A=M5A+MD5A
2550  CONTINUE
      GOTO 2150
2600  CONTINUE
      JI=MG-3
C--CHECK THE NUMBER OF ATOMS
CDJW2000>
C      JK=JI-2
C      JJ=3
C      IF(JK)2650,2700,2750
C2650  JJ=6
C      GOTO 2850
C2700  JJ=4
C      GOTO 2850
C2750  JK=JK-5
C      IF(JK)2850,2800,2900
C2800  JJ=2
C2850  CONTINUE
C      IF(JC-JJ)2900,3000,2900
C2900  CONTINUE
      IF (JI .EQ. 1) THEN
            JJ = 6
      ELSE IF (JI .EQ. 2) THEN
            JJ = 4
      ELSE IF (JI .LE. 6) THEN
            JJ = 3
      ELSE IF (JI .LE. 8) THEN
            JJ = 2
      ELSE
            JJ = -1
      ENDIF
      IF (JC .EQ. JJ) GOTO 3000
CDJW2000<
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2950)
      WRITE ( CMON, 2950)
      CALL XPRVDU(NCVDU, 1,0)
2950  FORMAT(' The number of atoms is wrong')
      GOTO 4200
C
C--INSTRUCTION LOOP
3000  CONTINUE
      JK=JI
      CALL SAORT
      CALL SAPRT
      STORE(IEQUIV+4) = UMULT
      GOTO(3100,3150,3200,3250,3300,3350,3400,3420,3050),JI
C3050  STOP347
3050  CALL GUEXIT(347)
C--'PHEN' INSTRUCTION
3100  CONTINUE
      CALL SPHEN
      GOTO 4250
C--'H13' INSTRUCTION
3150  CONTINUE
      CALL SH13
      GOTO 4250
C--'H33' INSTRUCTION
3200  CONTINUE
      CALL SH33
      GOTO 4250
C--'H23' INSTRUCTION
3250  CONTINUE
      CALL SH23
      GOTO 4250
C--'H22' INSTRUCTION
3300  CONTINUE
      CALL SH22
      GOTO 4250
C--'H12' INSTRUCTION
3350  CONTINUE
      CALL SH12
      GOTO 4250
C--'H11' INSTRUCTION
3400  CONTINUE
      CALL SH11
      GOTO 4250
C--'HBOND' INSTRUCTION
3420  CONTINUE
      CALL SHB
      GOTO 4250
C
C--MAIN TERMINATION ROUTINES
3450  CONTINUE
      M5A=L5+MD5*(N5-1)
      ASSIGN 3500 TO NRET
C--CHECK IF THERE ARE ANY HYDROGENS TO INSERT
      IF(JS)3500,3500,4000
C--CHECK FOR ANY ERRORS
3500  CONTINUE
      IF ( LEF .NE. 0 ) GO TO 9920
C--FORM AND OUTPUT THE RESULTANT LIST
      IF (ISSPRT .EQ. 0) WRITE(NCWU,3600)N5
      WRITE ( CMON, 3600) N5
      CALL XPRVDU(NCVDU, 1,0)
3600  FORMAT (1X , 'List now contains' , I6 , ' atoms' )
      N=N5
      NEW=1
      CALL XCPYL5(LA,LB,N,NEW)
      CALL XSTR05(LB,0,NEW)
C -- END ROUTINE
      GO TO 9000
C
C--'AFTER' INSTRUCTION
3700  CONTINUE
      IF(JS)3750,3750,3850
3750  CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,3800)
      WRITE ( CMON, 3800)
      CALL XPRVDU(NCVDU, 1,0)
3800  FORMAT(' No hydrogen atom(s) have been placed')
      GOTO 4200
3850  CONTINUE
      IF(ME)1300,1300,3900
3900  CONTINUE
      IF(KATOMU(LN))4200,4200,3950
C--CHECK THAT NO COORDINATES HAVE BEEN GIVEN
3950  CONTINUE
      IF(ISTORE(MQ+5))2300,4000,2300
C--COMPUTE THE ADDRESS FOR INSERTING THE HYDROGEN ATOM(S)
4000  CONTINUE
      JR=M5A+MD5A
C--COMPUTE THE ADDRESS FROM WHICH ATOMS MUST BE MOVED
      JR1=L5+(N5-1)*MD5
C--COMPUTE THE ADDRESS TO WHICH ATOMS MUST BE MOVED
      JR2=JR1+JS*MD5A
C--CHECK IF THERE ARE ANY ATOMS TO MOVE
      IF(JR-JR1)4050,4050,4150
C--MOVE THE ATOMS BEFORE THE INSERTING
4050  CONTINUE
      JR3=JR1
      DO 4100 J=JR,JR1,MD5
      CALL XMOVE(STORE(JR3),STORE(JR2),MD5)
      JR3=JR3-MD5
      JR2=JR2-MD5
4100  CONTINUE
C--INSERT THE HYDROGEN ATOMS
4150  CONTINUE
      CALL XMOVE(STORE(JT),STORE(JR),JS*MD5)
C--ADJUST THE NUMBER OF ATOMS IN THE LIST 5
      N5=N5+JS
      JS=0
      JT=JTA
      GOTONRET,(4250,2100,3500)
C
C--ERROR EXIT FOR THESE ROUTINES
4200  CONTINUE
      CALL XPCA(ISTORE(MD+4))
      LEF=LEF+1
4250  CONTINUE
      GOTO 1100
C
C
9000  CONTINUE
C -- FINAL TIDY UP
      CALL XOPMSG ( IOPHYD , IOPEND , 300 )
      CALL XTIME2 ( 2 )
      CALL XRSL
      CALL XCSAE
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPHYD , IOPABN , 0 )
      GO TO 9000
9910  CONTINUE
C -- COMMAND INPUT ERRORS
      CALL XOPMSG ( IOPHYD , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
C -- GENERAL ERRORS
      CALL XERHND ( IERERR )
      GO TO 9900
9930  CONTINUE
C -- INSUFF. CORE
      CALL XOPMSG ( IOPHYD , IOPSPC , 0 )
      GO TO 9900
      END
C
CODE FOR XPERHY
      SUBROUTINE XPERHY
C------ CODE DEVISED AND PRODUCED BY DAVID KINNA AS A PART II PROJECT
C----- PERHYDROGENATE THE CARBON ATOMS
C
C----- THIS ROUTINE SEARCHES FOR BONDED CARBON ATOMS, ASSESSES THEIR
C      HYBRIDISATION FROM A LOOK UP TABLE OF COMMON BOND LENGTHS,
C      AND THEN GENERATES INTERNAL COMMANDS IN THE SYSTEM REQUEST QUEUE
C      OF THE FORM USED BY #HYDROGEN .
C
C  LN1    INPUT LIST TYPE
C  LN2    OUTPUT LIST TYPE
C  ILIST   THE LIST CONTROL FLAG :
C          -1  DO NOT LIST THE HYDROGENATED ATOMS.
C           0  LIST THE HYDROGENATED ATOMS.
C  TOLER   CURRENTLY A DUMMY
C  ITYPEF   CURRENTLY C OR C&N
C--THE COMMON BLOCK /XWORKA/ IS USED :
C
C  JB  ADDRESS OF THE TEMP. STORAGE FOR ATOMS
C  JC  ADDRESS OF THE ATOM HEADER FOR MOVING ATOMS FROM 'JB'
C  JD  WORK SPACE FOR 'KATOMS'
C  JE  START OF DISTANCE STACK.
C  JF  NUMBER OF ATOMS LEFT TO SCAN
C  JG  CURRENT LAST ENTRY IN LIST 5 OR 10
C  JH  MD5-1
C  JI  MD5+MD5
C  JK  ADDRESS OF LAST ATOM ON PRINCIPAL DISTANCE STACK
C  JL  NEXT FREE ADDRESS AFTER PRINCIPAL DISTANCE STACK
C  JT  WORDS PER ENTRY IN THE STACK
C--
Cdjwsep08  JU  5 WORD WORK AREA
c  iequiv 5 word work area
C  JZ  CONTROL LINKED TO U(ISO)
C      0  USE THE VALUE INPUT FOR U[ISO]
C      1  USE THE VALUE FROM THE ADJACENT ATOM
C  SX  DISTANCE C-H TO USE
C  JACT ACTION FLAG (1=SRQ, 2=BOTH, 3=PUNCH)
C
C--THE FOLLOWING VARIABLES MUST BE SET ON ENTRY TO KDIST1:-
C
C  AT     MINIMUM ALLOWED DISTANCE FOR DISTANCES
C  AC     MAXIMUM ALLOWED DISTANCE FOR DISTANCES
C  BT     MINIMUM ALLOWED DISTANCE FOR ANGLES
C  BC     MAXIMUM ALLOWED DISTANCE FOR ANGLES
C  AO     MAXIMUM ALLOWED DISTANCE OVERALL
C  AP     MAXIMUM ALLOWED DISTANCES SQUARED OVERALL
C  BP     MINIMUM ALLOWED DISTANCE SQUARED OVERALL
C  M5A    ADDRESS OF THE CURRENT TARGET ATOM IN LIST 5
C  M5     ADDRESS OF THE FIRST ATOM TO MOVE AROUND IN LIST 5
C
C
C--ATOMS WHICH FORM ACCEPTABLE CONTACTS ARE STORED IN A STACK
C  WHICH HAS THE FOLLOWING FORMAT :
C
C   0  ADDRESS OF THE ATOM IN LIST 5
C   1  ACCEPTANCE FLAG
C
C      1  ACCEPTABLE TO NONE
C      2  DISTANCES ONLY
C      3  ANGLES ONLY
C      4  ACCEPTABLE TO BOTH
C
C   2  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CENTRE OF SYM.)
C   3  NON-PRIMITIVE LATTICE INDICATOR
C   4  T(X)
C   5  T(Y)
C   6  T(Z)
C   7  TRANSFORMED X
C   8  TRANSFORMED Y
C   9  TRANSFORMED Z
C  10  DISTANCE
C  11  DISTANCE SQUARED
C  12  ADDRESS IN LIST 12  (IF USED).
C  13  TARGET CONTACT DISTANCE FOR RESTRAINTS (OPTIONAL)
C
C
      CHARACTER *80 CSRQ
      CHARACTER *12 CTEMP
      CHARACTER *80 CLINE
C----- PATH AND FILENAME FOR RIDING CONSTRAINTS
      CHARACTER *256 CPATH, CPATH2
      DIMENSION JFRN(4), KFRN(4), LFRN(4)
C--
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM12.INC'
C
      DIMENSION INEXT(1), IACT(3), IADD(4)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST12.INC'
C
C
CC
C----- SET THE SYMBOL FOR CARBON AND NITROGEN
#ifdef _HOL_
      DATA JFRN /4HF   , 4HR   , 4HN   , 4H1   /
      DATA KFRN /4HF   , 4HR   , 4HN   , 4H2   /
CAPR06 USE THE OLD COMMON BLOCK FILE AS A WORK FILE
      DATA LFRN /4HE   , 4HX   , 4HC   , 4HO   /
      DATA ICARB /4HC      /, INTRO/4HN    /
      DATA INEXT(1) / 4HNEXT /
      DATA IACT / 4HNORM, 4HBOTH, 4HPUNC /
#else
      DATA JFRN /'F', 'R', 'N', '1'/
      DATA KFRN /'F', 'R', 'N', '2'/
CAPR06 USE THE OLD COMMON BLOCK FILE AS A WORK FILE
      DATA LFRN /'E', 'X', 'C', 'O'/
      DATA ICARB /'C   '/, INTRO/'N   '/
      DATA INEXT(1) / 'NEXT' /
      DATA IACT / 'NORM', 'BOTH', 'PUNC' /
#endif
C----- MAXIMUM DISTANCE FOR A 1-3 CONTACT, AND ITS SQUARE
      DATA D13/3.5/,D13S/12.25/
      DATA TOLER/0.6/,ITRANS/0/
C
C--SET THE INITIAL TIMING
      CALL XTIME1 (2)
C--READ THE INPUT DATA
      IF (KLEXAN(IULN,IFIRST,LENGTH).LT.0) GO TO 2600
C--DATA INPUT  -  CLEAR THE STORE
      CALL XRSL
      CALL XCSAE
C----- CLEAR A BUFFER
      IEQUIV=NFL
      NFL=NFL+5
C
      IF (ISSPRT.EQ.0) WRITE (NCWU,50)
      WRITE (CMON,50)
      CALL XPRVDU (NCVDU,2,1)
50    FORMAT (10X,' Per-hydrogenation of Carbon atoms')
      WRITE (CMON,'(10x,a)') ' Including Nitrogen'
      CALL XPRVDU (NCVDU,2,1)
C--LOAD THE INPUT LIST
      LN1=KTYP05(MX)
      CALL XLDR05 (LN1)
      IF (IERFLG.LT.0) GO TO 2550
cdjwmar09
      IF (KHUNTR (29,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL29
cricapr15
      IF (KHUNTR (41,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL41
C--FIND THE OUTPUT LIST TYPE
      LN2=KTYP05(MY)
C----- SET THE DEFAULT TEMPERATURE FACTOR OR MULTIPLIER
      UFACT=1.2
      CHECK = VALUE + ZERO
cdjwjan01 -make default 'both'
      JACT=2
      JNEXT=INEXT(1)
      JT=12
      BMAX=D13
      AT=0.5
      AC=D13
C----- NO ANGLES TO BE LOOKED FOR
      BT=0.
      BC=0.
C--SET THE INPUT PARAMETER DEFAULTS
      JS=0
      JZ=0
      UDEF = 1.2
      UMULT = udef
      SDEF=0.95
      SX = SDEF
C----- SET THE TYPE TO C (2 = C & N)
      ITYPEF=1
C----- LOAD LISTS 1 AND 2, AND SET UP SOME CONSTANTS
      CALL XDIST2
      IF (IERFLG.LT.0) GO TO 2550
C
      CALL XBCALC(1)
C--SET THE DIMENSION OF THE COMMON BLOCK FOR LIST 12
      IDIM12=40
C--INDICATE THAT LIST 12 IS NOT TO BE USED
      DO 100 I=1,IDIM12
         ICOM12(I)=NOWT
100   CONTINUE
      L12=-1
      M12=-1
C----- SET UP A BUFFER FOR A POSSIBLE MOLAX CALCULATION
      IMOLAX=NFL
      NFL=KCHNFL(44)
C--SET UP A FEW STACK CONSTANTS
      JB=NFL
      JC=JB+MD5
      JD=JC+20
      JE=JD+30
C--CHECK THE STORE AREA
      IF (JE-LFL) 150,2650,2650
150   CONTINUE
C
C--PREPARE FOR PROCESSING OF THE LEXICAL SCANNER OUTPUT
      CALL XILEXP (IULN,IFIRST)
C
C--MAIN INSTRUCTION CYCLING LOOP  -  SET THE BUFFER ADDRESS AFTER THE LA
200   CONTINUE
      IDWZAP=0
      IF (KLDNLR(IDWZAP)) 1400,250,2400
C--SET THE POINTER TO THE ATOM STACK
250   CONTINUE
      GO TO (350,700,1100,900,300),MG
C1200  STOP346
300   CALL GUEXIT (346)
C
C--'DISTANCE' INSTRUCTION
350   CONTINUE
      IF (ME) 400,400,500
400   CONTINUE
      CALL XPCLNN (LN)
      IF (ISSPRT.EQ.0) WRITE (NCWU,450)
      WRITE (CMON,450)
      CALL XPRVDU (NCVDU,1,0)
450   FORMAT (' No arguments found')
      GO TO 2400
C--READ THE DISTANCE
500   CONTINUE
      IF (KSYNUM(Z)) 550,650,550
550   CONTINUE
      CALL XPCLNN (LN)
      IF (ISSPRT.EQ.0) WRITE (NCWU,600) ISTORE(MF+1)
      WRITE (CMON,600) ISTORE(MF+1)
      CALL XPRVDU (NCVDU,1,0)
600   FORMAT (' New value of wrong type or missing',' at about column',
     1I5)
      GO TO 2400
650   CONTINUE
      SX=Z
      GO TO 2450
C
C--'ACTION' INSTRUCTION
700   CONTINUE
      IF (ME) 400,400,750
750   CONTINUE
C--CHECK THE TYPE OF ARGUMENT
      IF (ISTORE(MF)) 800,550,550
C--CHECK IF THIS IS A 'ACTION' DIRECTIVE
800   CONTINUE
      J=KCOMP(1,ISTORE(MF+2),IACT,3,1)
      IF (J) 550,550,850
850   CONTINUE
      JACT=J
      GO TO 2450
C
C------ 'TYPE' INSTRUCTION
900   CONTINUE
      IF (ME) 400,400,950
C--CHECK THE TYPE OF ARGUMENT
950   CONTINUE
      IF (ISTORE(MF)) 1000,550,550
C--CHECK IF THIS IS A 'N    ' DIRECTIVE
1000  CONTINUE
      J=KCOMP(1,ISTORE(MF+2),INTRO,1,1)
      IF (J) 2450,2450,1050
1050  CONTINUE
      ITYPEF=2
      GO TO 2450
C
C
C--'UISO' INSTRUCTION
1100  CONTINUE
      IF (ME) 400,400,1150
C--CHECK THE TYPE OF ARGUMENT
1150  CONTINUE
      IF (ISTORE(MF)) 1200,1300,550
C--CHECK IF THIS IS A 'NEXT' DIRECTIVE
1200  CONTINUE
      J=KCOMP(1,ISTORE(MF+2),INEXT,1,1)
      IF (J) 550,550,1250
1250  CONTINUE
      JNEXT=INEXT(1)
      JZ=1
C----- GET THE U MULTIPLIER
      ME=ME-1
C----- RE-SET THE DEFAULT TEMPERATURE FACTOR MULTIPLIER
      UFACT=1.0
      IF (ME.LE.0) GO TO 2450
      MF=MF+LK2
      IF (ISTORE(MF).NE.0) GO TO 550
      IF (KSYNUM(Z).NE.0) GO TO 550
      UFACT=Z
      GO TO 2450
C--NOT 'NEXT' - READ U[ISO] OFF THE CARD
1300  CONTINUE
      IF (KSYNUM(Z)) 550,1350,550
C--STORE THE NUMBER AND RESET THE FLAG
1350  CONTINUE
C----- BLANK OUT THE 'NEXT'
      JNEXT=IB
      JZ=0
      UFACT=Z
      GO TO 2450
C
C
C--MAIN TERMINATION ROUTINES
1400  CONTINUE
C
C
C----- SET NUMBER OF HYDROGENS ADDED
      NHADD = 0
C----- OPEN A FILE FOR THE RIDING RESTRAINTS
      IF (JACT.GE.2) THEN
         WRITE (CMON,'(11X,A)') 'Putting Perhydro commands in PERH.TMP'
         CALL XPRVDU (NCVDU,1,1)
         CPATH2='perh.tmp'
         LPATH2=KPATH(CPATH2)
         CALL XRDOPN (6,KFRN(1),CPATH2(1:LPATH2)//'perh.tmp',LPATH2+8)
         WRITE (CMON,'(11X,A)') 'Putting delete H commands in DELH.TMP'
         CALL XPRVDU (NCVDU,1,1)
         CPATH2='delh.tmp'
         LPATH2=KPATH(CPATH2)
         CALL XRDOPN (6,LFRN(1),CPATH2(1:LPATH2)//'delh.tmp',LPATH2+8)
      END IF
      WRITE (CMON,'(11X,A)') 'Putting riding Constraints in RIDEH.DAT'
      CALL XPRVDU (NCVDU,1,1)
      CPATH='rideh.dat'
      LPATH=KPATH(CPATH)
      CALL XRDOPN (6,JFRN(1),CPATH(1:LPATH)//'rideh.dat',LPATH+9)
      IF (JACT.LE.2) THEN
         CSRQ=' '
         WRITE (CSRQ,'(A10,1X,I2,1X,I2)') '#HYDROGENS',
     1    KTYP05(MX),KTYP05(MY)
         CALL XISRC (CSRQ)
         CSRQ=' '
         WRITE (CSRQ,'(A5,F6.3)') 'DIST ',SX
         CALL XISRC (CSRQ)
         CSRQ=' '
         WRITE (CSRQ,'(A7, A4, F6.3)') 'U[ISO] ',JNEXT,UFACT
         CALL XISRC (CSRQ)
      END IF
      IF (JACT.GE.2) THEN
         WRITE (NCCBU,'(A)') '#EDIT'
         WRITE (NCFPU2,'(A10,1X,I2,1X,I2)') '#HYDROGENS',
     1    KTYP05(MX),KTYP05(MY)
         WRITE (NCFPU2,'(A5,F6.3)') 'DIST ',SX
         WRITE (NCFPU2,'(A7, A4, F6.3)') 'U[ISO] ',JNEXT,UFACT
      END IF
C
C SET UP THE CONTROL VARIABLES FOR THIS PASS
C
C SAVE THE VALUE FOR 1-2 CONTACT, AND ITS SQUARE
      AOTEMP=AO
      APTEMP=AP
C
C----- SET THE TARGET ATOM ADDRESSES
      MATOM=0
      M5A=L5
C
C     LOOPS BACK TO 2500 UNTIL MATOM=N5
1450  CONTINUE
C
      JPART = 1
      PARTLOOP: DO WHILE ( JPART .GE. 1 ) 
C----- FIX THE RADII FOR 1-3 CONTACTS
      AC=D13
      AO=D13
      AP=D13S
C
C----- RESET THE CONTACT ATOM AND FUNCTION VECTOR ADDRESSES
      M5=L5
C
C----RESET BEGINNING OF DISTANCE STACK TO JE EVERY TIME
      NFL=JE
C
C
C----END OF LOOP ?
      IF (MATOM.GE.N5) GO TO 2300
C
C----IS THE CURRENT ATOM CARBON ?
      IF (ISTORE(M5A).EQ.ICARB) GO TO 1500
C --- CHECK NITROGEN ALLOWED
      IF ((ISTORE(M5A).EQ.INTRO).AND.(ITYPEF.EQ.2)) GO TO 1500
      GO TO 2250
1500  CONTINUE
      NHYB=0
      NBONDS=0
C --  COMPUTE DISTANCE STACK TO A TWO BOND MAXIMUM
cdjwaug06
c      NDIST=KDIST1(N5,JL,JT,0,TOLER,ITRANS,0,4,0)
c      NDIST=KDIST1(N5,JL,JT,0,TOLER,ITRANS,0,4,1)
       NDIST = KDIST4( JL, JT, 0, JPART)
C---- JK IS CURRENT NEXT FREE ADDRESS - SAVE AND SET LAST ENTRY
      NFL=JL
      JK=JL-JT
C
C-------- CHECK FOR ERRORS AND ISOLATED ATOMS
      IF (NDIST.LE.0) THEN
         IF (ISSPRT.EQ.0) WRITE (NCWU,1601) STORE(M5A),NINT(STORE(M5A+1)
     1    )
         WRITE (CMON,1601) STORE(M5A),NINT(STORE(M5A+1))
         CALL XPRVDU (NCVDU,1,0)
         GO TO 2250
      END IF
1601     FORMAT (10X,' Non-bonded ',A4,I5)

C TODO: Check for bonding to more than one non-zero part. If this happens,
C each part should be treated independently.
cdjwmar09
c       if (issprt .eq. 0) then

c         WRITE(ncwu,'(A,I3,6X,A4,I4)')'Bonds found: ',NDIST,
c     1   ISTORE(M5A),NINT(STORE(M5A+1))
c         DO MMMI=JE,JE+JT*(NDIST-1),JT
c          WRITE(ncwu,'(A,A4,I4,f6.3)')'Found bond to:',
c     1    ISTORE(ISTORE(MMMI)),NINT(STORE(ISTORE(MMMI)+1)),
c     2    STORE(MMMI+10)
c         END DO
c      endif

      IF (NDIST .GE. 2) THEN   !If there are more than two atoms found:
        L = JE     ! 1st atom
1960    CONTINUE
        LV = L+JT  ! Next atom
        NREJ = 0
        DO M =  LV, JK, JT !Go from atom after L, to the end of the stack:
C ARE ATOM ADDRESSES SAME?
          IF   (ISTORE(L) .EQ. ISTORE(M))  THEN
C ARE DISTANCES SAME?
            IF (ABS(STORE(L+10) - STORE(M+10)) .LE. CHECK) THEN
C ARE ATOMS COINCIDENT?
              IF ( XDSTN2 (STORE(L+7), STORE(M+7)) .LE. CHECK) THEN
                NREJ = NREJ + 1
                CYCLE
              ENDIF
            ENDIF
          ENDIF
          IF (LV .NE. M) THEN
C SHUFFLE ITEMS UP IF ADDRESSES DIFFERENT
             CALL XMOVE (STORE(M), STORE(LV), JT)
          ENDIF
          LV = LV + JT
        END DO
        L = L + JT        !Increment L atom pointer (pivot).
        JL = JL - NREJ*JT !Shorten stack if atoms were rejected.
        NDIST = NDIST - NREJ      !Reduce number of finds.
        IF (L .LT. JL-JT) GOTO 1960

        JK=JL-JT
      ENDIF

cdjwmar09
c      if (issprt .eq. 0) then
c         WRITE(ncwu,'(/A,I3,6X,A4,I4)')'Filtered bonds found: ',NDIST,
c     1   ISTORE(M5A),NINT(STORE(M5A+1))
c       DO MMMI=JE,JE+JT*(NDIST-1),JT
c         WRITE(ncwu,'(A,A4,I4,f6.3)')'Found bond to:',
c     1   ISTORE(ISTORE(MMMI)),NINT(STORE(ISTORE(MMMI)+1)),
c     2    STORE(MMMI+10)
c       END DO
c      endif
c
C
C
C----CALCULATE THE NUMBER OF BONDED ATOMS AND THEIR ADDRESSES IN
C----THE FIRST STACK.
cdjwmar09
c----- get the pivot atom id
      write (ctemp,'(a4,''('',i4,'')'')') store(m5a),nint(store(m5a+1))
      call xcras (ctemp,ltemp)
c      if (issprt .eq. 0) then
c       write(ncwu,'(a,a)') 'Atoms bonded to ', ctemp(1:ltemp)
c      endif
      NBONDS=KBNDED(JE,JK,JT,IADD,DIST)
cdjwmar09
c         if ((issprt .eq. 0) .and. (nbonds .gt. 0)) then
c          do idjw=1,nbonds
c            jdjw=iadd(idjw)
c            write(ncwu,'(10x, a4,i2,f6.2)') istore(istore(jdjw)),
c     1       nint(store(istore(jdjw)+1)),store(jdjw+10)
c          enddo
c         endif
C
C-------- CHECK FOR ERRORS AND ISOLATED ATOMS

      IF (NBONDS.GT.4) THEN
         IF (ISSPRT.EQ.0) WRITE (NCWU,1550) NBONDS,ISTORE(M5A),
     1    CTEMP(1:LTEMP)
         WRITE (CMON,1550) NBONDS,ISTORE(M5A),CTEMP(1:LTEMP)
         CALL XPRVDU (NCVDU,1,0)
1550     FORMAT (10X,I3,' valent',A4,' - ',A)
      ELSE IF (NBONDS.LE.0) THEN
         IF (ISSPRT.EQ.0) WRITE (NCWU,1600) ISTORE(M5A),CTEMP(1:LTEMP)
         WRITE (CMON,1600) ISTORE(M5A),CTEMP(1:LTEMP)
         CALL XPRVDU (NCVDU,1,0)
1600     FORMAT (10X,' Non-bonded ',A4,' - ',A)
      ELSE IF (ISTORE(M5A).EQ.ICARB) THEN
C----   WE HAVE CONTACTS.
C       CALCULATE THE HYBRIDISATION BASED ON SHORTEST BOND
         NHYB=KHYB(IADD(1),DIST,DELTA)
         MHYB=0
         DELTA2=0.
         IF (NBONDS.GE.2) THEN
C           GET THE NEXT SHORTEST BOND
            MHYB=KHYB(IADD(2),STORE(IADD(2)+10),DELTA2)
         END IF
C-----  LOOK FOR SECONDARY CONTACTS
c         ISEC=KSEC(AOTEMP,APTEMP,NDTEMP,IADD,NBONDS,IZ)
         ISEC=KSEC2(AOTEMP,APTEMP,NDTEMP,IADD,NBONDS,IZ)
         LHYB=0
         DELTAA=999.
         DEV=999.
         IF (NBONDS.EQ.3) THEN
C         1 ON SP3 OR 0 ON SP2
C         COMPUTE A PLANE
            CALL XMOVE (STORE(M5A+4),STORE(IMOLAX),3)
            CALL XMOVE (STORE(IADD(1)+7),STORE(IMOLAX+4),3)
            CALL XMOVE (STORE(IADD(2)+7),STORE(IMOLAX+8),3)
            CALL XMOVE (STORE(IADD(3)+7),STORE(IMOLAX+12),3)
            STORE(IMOLAX+3)=1.
            STORE(IMOLAX+7)=1.
            STORE(IMOLAX+11)=1.
            STORE(IMOLAX+15)=1.
            I=KMOLAX(STORE(IMOLAX),4,4,STORE(IMOLAX+16),STORE(IMOLAX+19)
     1       ,STORE(IMOLAX+2),STORE(IMOLAX+31),STORE(IMOLAX+40))
            DEV=STORE(IMOLAX+21)
            IF (DEV.GE.0.1) THEN
               LHYB=3
            ELSE
               LHYB=2
            END IF
         ELSE IF (NBONDS.EQ.2) THEN
C         2 ON SP3 , 1 ON SP2 OR 0 ON SP1
            SOP=XDSTN2(STORE(IADD(1)+7),STORE(IADD(2)+7))
            SOP=SQRT(SOP)
            ANG=XANG(STORE(IADD(1)+10),STORE(IADD(2)+10),SOP)
            IF (ANG.GT.160.) THEN
               LHYB=1
               DELTAA=180.-ANG
            ELSE
               IF (DELTA.GE..05) THEN
                  LHYB=NHYB
               ELSE
                  LHYB=MIN(NHYB,MHYB)
               END IF
            END IF
         ELSE IF (NBONDS.EQ.1) THEN
C         3 ON SP3 , 2 ON SP2 OR 1 ON SP1
cdjwapr06            IF (DELTA.GE..05) THEN
            IF (DELTA.GE. .01) THEN    !Pretty certain of hybridisation from distance
               LHYB=NHYB
            ELSE                       !Not certain - check angles
               SOP=XDSTN2(STORE(IADD(1)+7),STORE(ISEC+7))   !First use of ISEC - if 1 bond to target =CH2 or -CH3 or ==CH
               SOP=SQRT(SOP)
               ANG=XANG(STORE(IADD(1)+10),SOP,STORE(ISEC+10))
               IF (ANG.GT.160.) THEN    ! >160 - SP1
                  LHYB=1
                  DELTAA=180.-ANG
               ELSE IF (ANG.GT.113) THEN    ! 113-160 - SP2
                  LHYB=2
                  DELTAA=113.-ANG
               ELSE                         ! 0-113 - SP3
                  DELTAA=109.-ANG 
                  LHYB=3
               END IF
            END IF
         END IF
         IF (LHYB.NE.NHYB) THEN
            IF (NHYB.NE.0) THEN
               WRITE (CMON,1700) CTEMP(1:LTEMP),NHYB,LHYB,NBONDS,LHYB
               CALL XPRVDU (NCVDU,1,0)
               IF (ISSPRT.EQ.0) THEN
                  WRITE (NCWU,1650) CTEMP(1:LTEMP),NHYB,DELTA,MHYB,
     1             DELTA2,DEV,DELTAA
                  WRITE (NCWU,'(A)') CMON(1)(:)
               END IF
            END IF
1650        FORMAT (A,1X,' sp',I1,' delta ',F6.2,' sp',I1,' delta',F6.2,
     1' planarity ',F7.2,' angle delta ',F7.2)
1700        FORMAT (A,' hybridisation uncertain (',I1,'/',I1,')',I3,
     1' Bonds,',' sp',I1,' used')
            NHYB=LHYB
         END IF
         IF (NHYB.GT.0) THEN
C----   WRITE COMMAND TO FILE.
            CALL HPLACE (NBONDS,NHYB,M5A,IADD,AOTEMP,APTEMP,NDTEMP,JACT,
     1       ISEC, NHADD)
         ELSE
            IF (ISSPRT.EQ.0) WRITE (NCWU,1750) CTEMP(1:LTEMP)
            WRITE (CMON,1750) CTEMP(1:LTEMP)
            CALL XPRVDU (NCVDU,1,0)
1750        FORMAT (' Unassignable carbon - ',A)
         END IF
C
C
C Start of main body of Part II Project
C
C
      ELSE IF ((ISTORE(M5A).EQ.INTRO).AND.(ITYPEF.EQ.2)) THEN
        WRITE (CMON,3261) istore(m5a), store(m5a+1)
        CALL XPRVDU (NCVDU,1,0)
3261    FORMAT ('NITROGEN H-PLACEMENT ', a4, f6.0)
         IF (NBONDS.EQ.1) THEN
            IF (STORE(IADD(1)+10).GT.1.43) THEN
C       NH3+ WITH +VE CHARGE- USES SAME H PLACING ROUTINE AS CARBON
               NHYB=3
               WRITE (CMON,1800) CTEMP(1:LTEMP)
               CALL XPRVDU (NCVDU,1,0)
1800           FORMAT (' NH3 WITH +VE CHARGE ',A)
            ELSE IF (STORE(IADD(1)+10).LE.1.24) THEN
               WRITE (CMON,1850) CTEMP(1:LTEMP)
               CALL XPRVDU (NCVDU,1,0)
1850           FORMAT (A,' No H on Nitrogen, (Cyanide) -')
C THIS IS CASE 1--no hydrogens to place
            ELSE
               AOTEMP=1.9
               APTEMP=AOTEMP*AOTEMP
               NNEW=KNICK(AOTEMP,APTEMP,IADD(1))
               ISEC=KSEC(AOTEMP,APTEMP,NDTEMP,IADD,NBONDS,IZ)
               IF (NNEW.EQ.4) THEN
                  NHYB=3
C---MUST BE A FULLY SATURATED CARBON. THEREFORE N IS STANDARD NH2
                  WRITE (CMON,1900) CTEMP(1:LTEMP)
                  CALL XPRVDU (NCVDU,1,0)
1900              FORMAT (A,' has two hydrogens & 1 lone pair. ','Delete
     1 one h')
C  THIS IS CASE 2- two hydrogens, one lone pair
               ELSE IF (NNEW.EQ.3) THEN
C                    DMIN = 1.4
                  AOTEMP=1.9
                  APTEMP=AOTEMP*AOTEMP
                  INICK=KNICK2(AOTEMP,APTEMP,IADD(1),DMIN)
                  ISEC=KSEC(AOTEMP,APTEMP,NDTEMP,IADD,NBONDS,IZ)
                  IF (DMIN.LT.STORE(IADD(1)+10)) THEN
                     WRITE (CMON,1900) CTEMP(1:LTEMP)
                     CALL XPRVDU (NCVDU,1,0)
                     NHYB=3
                     WRITE (CMON,1900) CTEMP(1:LTEMP)
                     CALL XPRVDU (NCVDU,1,0)
C AGAIN CASE 2 - 2 hydrogens, one lone pair
                  ELSE
                     NHYB=2
                     WRITE (CMON,1950) CTEMP(1:LTEMP)
                     CALL XPRVDU (NCVDU,1,0)
1950                 FORMAT ('1Hydrogen, 1 lone pair or aromatic ',A)
                  END IF
               ELSE IF (NNEW.EQ.2) THEN
                  NHYB=3
                  WRITE (CMON,1900) CTEMP(1:LTEMP)
                  CALL XPRVDU (NCVDU,1,0)
               END IF
            END IF
         ELSE IF (NBONDS.EQ.3) THEN
C       NEED TO LOOK AT BOND ANGLES TO DECIDE WHETHER OR NOT N IS +VE
C       MUST COMPUTE AVERAGE OF THE THREE BOND ANGLES
                WRITE (CMON, 3281) CTEMP(1:LTEMP)
                CALL XPRVDU (NCVDU,1,0)
3281            FORMAT (A, ' hybridisation uncertain. ',
     1           'Calculate some angles for Nitrogen ')
            SOP1=XDSTN2(STORE(IADD(1)+7),STORE(IADD(2)+7))
            SOP1=SQRT(SOP1)
            ANG1=XANG(STORE(IADD(1)+10),STORE(IADD(2)+10),SOP1)
            SOP2=XDSTN2(STORE(IADD(2)+7),STORE(IADD(3)+7))
            SOP2=SQRT(SOP2)
            ANG2=XANG(STORE(IADD(2)+10),STORE(IADD(3)+10),SOP2)
            SOP3=XDSTN2(STORE(IADD(1)+7),STORE(IADD(3)+7))
            SOP3=SQRT(SOP3)
            ANG3=XANG(STORE(IADD(1)+10),STORE(IADD(3)+10),SOP3)
            AVANG=(ANG1+ANG2+ANG3)/3
            IF (AVANG.GT.118) THEN
               WRITE (CMON,2050) CTEMP(1:LTEMP)
               CALL XPRVDU (NCVDU,1,0)
C                  NHYB=2
C IN THIS CASE THERE ARE NO HYDROGENS TO PLACE - PLANAR
            ELSE
               NHYB=3
               WRITE (CMON,2050) CTEMP(1:LTEMP)
               CALL XPRVDU (NCVDU,1,0)
2000           FORMAT ('Hydrogen may or may not be present')
2050           FORMAT (A,' No hydrogens, one lone pair but planar')
C CASE 1 AGAIN. NO HYDROGENS TO PLACE
            END IF
         ELSE IF (NBONDS.EQ.2) THEN
C               NEED TO CALC THIS BOND ANGLE
            SOP=XDSTN2(STORE(IADD(1)+7),STORE(IADD(2)+7))
            SOP=SQRT(SOP)
            ANG=XANG(STORE(IADD(1)+10),STORE(IADD(2)+10),SOP)
            DIF=STORE(IADD(1)+10)-STORE(IADD(2)+10)
            IF (DIF.LT.0) THEN
               DIF=(DIF*(-1))
            END IF
            IF ((ANG.LT.190).AND.(ANG.GT.155)) THEN
               NHYB=1
               WRITE (CMON,2100) CTEMP(1:LTEMP)
               CALL XPRVDU (NCVDU,1,0)
2100           FORMAT (A,' Linear nitrogen no H to be placed')
C THIS IS A LINEAR NITROGEN WITH A DOUBLE BOND EITHER SIDE
C THEREFORE NO HYDROGENS NEED BE PLACED (CASE 0)
C       NOW NEED TO SEE IF SHORTEST BOND IS APPROX EQUAL TO SECOND SHORT
            ELSE IF (DIF.LT.0.19) THEN
C                        IF (ANG .GT. 115) THEN
               AVV=STORE(IADD(1)+10)+STORE(IADD(2)+10)
               AV=AVV/2
C                         IF (AV. LT. 1.37) THEN
C THE N IS AROMATIC/DELOCALISED. THEREFORE PLANAR AND DOESNT HAVE ANY H.
C                         NHYB = 1
C                         ELSE
               NHYB=3
               WRITE (CMON,2150) CTEMP(1:LTEMP)
               CALL XPRVDU (NCVDU,1,0)
C                         END IF
C EXACTLY THE SAME AS FULLY SATURATED CARBON  (CASE 0)
C                        ELSE IF (ANG.LT.115) THEN
C                        WRITE (CMON,3282) CTEMP(1:LTEMP)
C                        CALL XPRVDU (NCVDU,1,0)
2150           FORMAT (A,' has one hydrogen, 1 lone pair. Delete one H')
C                  CRYSTALS HAS ADDED 2 HYDROGENS USER MUST DELETE
C                  ONE HYDROGEN WHERE LP IS THOUGHT TO EXIST')
C                        NHYB=3
C CASE 3 ONE HYDROGEN TO PLACE BUT ALSO ONE LP
C                        END IF
            ELSE IF (DIF.GT.0.19) THEN
C                        IF (ANG .GT. 115) THEN
               NHYB=2
C 1 HYDROGEN TO PLACE NO LONE PAIRS. (CASE 0). IE +VE CHARGE. SP2
C                        ELSE IF (ANG .LT. 115) THEN
               WRITE (CMON,2200) CTEMP(1:LTEMP)
               CALL XPRVDU (NCVDU,1,0)
2200           FORMAT (A,' Probably has no hydrogens, 1 lone pair-',
     1         ' delete H')
C CASE 1  NO H TO PLACE
C                        END IF
            END IF
         END IF
C
        IF (NHYB.GT.0) THEN
C----   WRITE COMMAND TO FILE.
           CALL HPLACE (NBONDS,NHYB,M5A,IADD,AOTEMP,
     1      APTEMP,NDTEMP,JACT,ISEC,NHADD)
        ELSE
        END IF
      END IF

      END DO PARTLOOP
C
C--UPDATE FOR THE NEXT TARGET ATOM.
2250  CONTINUE
      M5A=M5A+MD5
      MATOM=MATOM+1
      GO TO 1450
C
C
2300  CONTINUE
2350  CONTINUE
C
      IF (JACT.LE.2) THEN
         CSRQ=' '
         WRITE (CSRQ,'(A3)') 'END'
         CALL XISRC (CSRQ)
      END IF
      IF (JACT.GE.2) THEN
         WRITE (NCFPU2,'(A3)') 'END'
         WRITE (NCCBU, '(A)') 'END'
      END IF
C
C -- END ROUTINE
      GO TO 2500
C
C
C--ERROR EXIT FOR THESE ROUTINES
2400  CONTINUE
      CALL XPCA (ISTORE(MD+4))
      LEF=LEF+1
2450  CONTINUE
      GO TO 200
C
C -- FINAL MESSAGES
2500  CONTINUE
C
C----- CLOSE THE RIDING RESTRAINT FILE
      CALL XRDOPN (7,JFRN(1),CPATH(1:LPATH)//'rideh.dat',LPATH+9)
C^MAY06
      IF (JACT.GE.2) THEN
            CALL XRDOPN (7,KFRN(1),CPATH2(1:LPATH2)//'perh.tmp'
     1        ,LPATH+8)
            ISTAT = KSCTRN ( 1 , 'PERH:NHADD' , nhadd, 1 )
            CALL XRDOPN (7,LFRN(1),CPATH2(1:LPATH2)//'delh.tmp'
     1        ,LPATH+8)
            WRITE(CMON,'(I9,A)') NHADD,' Hydrogen atoms added'
            CALL XPRVDU (NCVDU,1,0)
C----- IF SOME HATOMS CREATED, COPY TEMP FILES TO DAT FILES
        IF (NHADD .GT. 0) THEN
            REWIND (NCFPU2)
            REWIND (NCCBU)
            CALL XRDOPN (6,KFRN(1),CPATH2(1:LPATH2)//'delh.tmp'
     1        ,LPATH+8)
            CALL XRDOPN (6,LFRN(1),CPATH2(1:LPATH2)//'delh.dat'
     1        ,LPATH+8)
         WRITE (CMON,'(11X,A)') 'Copying DELH.TMP to DELH.DAT'
         CALL XPRVDU (NCVDU,1,1)
            DO  
              READ(NCFPU2, '(A)', END=2) CLINE
              CALL XCTRIM(CLINE,NCHAR)
              WRITE(NCCBU, '(A)') CLINE(1:NCHAR)
            ENDDO
2           CONTINUE
            CALL XRDOPN (7,KFRN(1),CPATH2(1:LPATH2)//'delh.tmp'
     1        ,LPATH+8)
            CALL XRDOPN (7,LFRN(1),CPATH2(1:LPATH2)//'delh.dat'
     1        ,LPATH+8)
C^
            REWIND (NCFPU2)
            REWIND (NCCBU)
            CALL XRDOPN (6,KFRN(1),CPATH2(1:LPATH2)//'perh.tmp'
     1        ,LPATH+8)
            CALL XRDOPN (6,LFRN(1),CPATH2(1:LPATH2)//'perh.dat'
     1        ,LPATH+8)
         WRITE (CMON,'(11X,A)') 'Copying PERH.TMP to PERH.DAT'
         CALL XPRVDU (NCVDU,1,1)
            DO  
              READ(NCFPU2, '(A)', END=3) CLINE
              CALL XCTRIM(CLINE,NCHAR)
              WRITE(NCCBU, '(A)') CLINE(1:NCHAR)
            ENDDO
3           CONTINUE
            CALL XRDOPN (7,KFRN(1),CPATH2(1:LPATH2)//'perh.tmp'
     1        ,LPATH+8)
            CALL XRDOPN (7,LFRN(1),CPATH2(1:LPATH2)//'perh.dat'
     1        ,LPATH+8)

        ENDIF
      ENDIF
C
      CALL XOPMSG (IOPHYD,IOPEND,410)
C
      CALL XTIME2 (2)
      CALL XCSAE
      CALL XRSL
      RETURN
2550  CONTINUE
C -- ERRORS
      CALL XOPMSG (IOPHYD,IOPABN,0)
      GO TO 2350
2600  CONTINUE
C
C -- INPUT ERRORS
      CALL XOPMSG (IOPHYD,IOPCMI,0)
      GO TO 2550
2650  CONTINUE
C -- INSUFFICIENT SPACE
      CALL XOPMSG (IOPHYD,IOPSPC,0)
      GO TO 2550
C
      END
C
CODE FOR KNICK
        FUNCTION KNICK(AOTEMP, APTEMP, IADD)
C
C       FIND NUMBER OF BONDS TO NEW PIVOT AT M5
C
C       IADD IS ADDRESS IN FIST STACK TO NEW PIVOT
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XPROCC.INC'
C      COMMON /XPROCC/DISTS(4),LN1,LN2,ITYPE,NATOM,ILIST,ISEQ,D3,AMULT,
C     2 IACT, ISYMOD, ITRANS
c        COMMON /XDISTW/A,BB,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,
c     2  W,X,Y
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
        EQUIVALENCE (TOLER, DISTS(4))
C
#ifdef _HOL_
        DATA KHYD / 4HH   /
        DATA KDET / 4HD   /
#else
        DATA KHYD / 'H  ' /
        DATA KDET / 'D  ' /
#endif
C---USE THE SPECIFIED CONTACT FROM THE FIRST DISTANCE STACK
C---AS A PIVOT FOR A NEW STACK AND FIND ALL CONTACTS
C
        ISEC = -1000
C--- SAVE OLD TARGET
        M5B=M5A
C--- ONLY LOOK FOR SHORT CONTACTS
        AO = AOTEMP
        AC = AOTEMP
        AP = APTEMP
C
C--- SET UP A LOOP TO TRY ALL THE SHORT CONTACTS IN IADD
        JADD=-1
C--- THE ADDRESS OF THE NEW PIVOT IS IN ISTORE(IADD(I))
        M5S = IADD
        M5A = ISTORE (M5S)
C
C--- ENSURE THAT NFL POINTS TO THE END OF THE OLD DISTANCE STACK
        NFL = JL
C--- THE START OF THE NEW STACK
        JJE = JL
        M5 = L5
C
        NDTEMP = KDIST1 (N5, JJE, JT, 0, TOLER, ITRANS, 0, 4, 0)
C   NOT TOO SURE IF THIS NEXT CONTINUE IS REQUIRED
        CONTINUE
C       RESTORE OLD TARGET
        M5A =M5B
        KSEC = ISEC
        KNICK = NDTEMP
        RETURN
        END
C
CODE FOR KNICK2
        FUNCTION KNICK2(AOTEMP, APTEMP, IADD, DMIN)
C
C       RETURNS THE ADDRESS IN ISTORE OF THE SHORTEST SECOND CONTACT
C       FOR THE TARGET ATOM AT IADD
C
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XPROCC.INC'
C      COMMON /XPROCC/DISTS(4),LN1,LN2,ITYPE,NATOM,ILIST,ISEQ,D3,AMULT,
C     2 IACT, ISYMOD, ITRANS
C        COMMON /XDISTW/A,BB,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,
C     2  W,X,Y
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
C        EQUIVALENCE (TOLER, DISTS(4))
#ifdef _HOL_
        DATA ICARB / 4HC   /
#else
        DATA ICARB / 'C  ' /
#endif
C       USE THE SHORTEST CONTACT FROM THE FIRST DISTANCE STACK
C       AS A PIVOT FOR A NEW STACK. SEARCH THIS NEW STACK FOR
C       AN ATOM IN COMMON WITH THE FIRST. CHOOSE A NON-H ATOM
C       IF POSSIBLE. THIS COMMON ATOM IS 'R2' IN THE H22 OR
C       H33 COMMAND.
        TOLER = 0.6
        ITRANS = 0
        ISEC = -1000
C----SAVE OLD TARGET
        M5B=M5A
C--- ONLY LOOK FOR SHORT CONTACTS
        AO = AOTEMP
        AC=AOTEMP
        AP=APTEMP
        DCURT=STORE(JE+10)
C--SET UP A DAFT DISTANCE
        DMIN=1000
C
C---SET UP A LOOP TO TRY ALL THE SHORT CONTACTS IN IADD
C-- THE ADDRESS OF THE NEW PIVOT IS IN ISTORE(IADD(I))
        M5S = IADD
        M5A=ISTORE(M5S)
C
C CONSIDER ONLY THOSE ATOMS WITHIN 1.9 ANGSTROM WHEN DECIDING A PIVOT
C FOR THE SECOND STACK
21       FORMAT ('M5S+10=', F10.3)
        IF (STORE(M5S+10) . LT. 1.9) THEN
31      FORMAT ('ATOM',A4, F10.2)
C
C   ------ENSURE THAT NFL POINTS TO THE END OF THE OLD DISTANCE STACK
        NFL=JL
C    THE START OF THE NEW STACK
        JJE=JL
        M5=L5
C
        NDTEMP = KDIST1(N5, JJE, JT, 0, TOLER, ITRANS, 0, 4, 0)
        IF (NDTEMP .LT. 2) GOTO 1631
C
C
        DO 1580 IJJE=JJE, JJE-JT, JT
CHECK WE DONT HAVE THE REVERSE DISTANCE
        IF (ISTORE(IJJE) .EQ. ISTORE(JE)) GOTO 1580
CHECK IT IS A CARBON
        IF (ISTORE(ISTORE(IJJE)) .NE. ICARB) GOTO 1580
CHECK ITS THE CURRENT SMALLEST
        IF (STORE(IJJE+10) .LT. DMIN) THEN
        DMIN=STORE(IJJE+10)
25       FORMAT ('DMIN=', F10.3)
        ISEC=IJJE
        ENDIF
1580    CONTINUE
        ENDIF
1631    CONTINUE
1701    CONTINUE
C       RESTORE OLD TARGET
        M5A=M5B
C DO SOME TESTS ON DMIN AND DCURRENT
        KNICK2=ISEC
        RETURN
        END
C
C
C
CODE FOR XANG
      FUNCTION XANG (A,B,C)
C----- FIND THE ANGLE GAMMA, OPPOSITE SIDE C
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      COSG = (A*A + B*B - C*C) / (2.*A*B)
      IF (COSG .GE. 1.0 ) THEN
            XANG = 0.0
      ELSE IF (COSG .LE. -1.0) THEN
            XANG = 180.0
      ELSE
            XANG = RTD* ACOS (COSG)
      ENDIF
      RETURN
      END
C
C
C
CODE FOR KBNDED
      FUNCTION KBNDED (JE, JK, JT, IADD, DIST)
C
      DIMENSION IADD(4)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
c
C      DATA RADIUS/2.2/
C
C KBNDED - THE NUMBER OF ATOMS WITHIN 'RADIUS' ANGSTROM OF THE TARGET
C
C IADD   - AN ARRAY STORING THE STACK ADDRESSES OF THE BOUND ATOMS.
C          SORTED BY INCREASING LENGTH
C
C DIST   - THE SHORTEST DISTANCE
C
C RADIUS - UPPER LIMIT ON ATOMIC SEPARATION - CURRENTLY SET TO 2.0 A
C
      CALL XFILL(-10000, IADD, 4)
      NBONDS=0
      DO 1000 I=JE,JK,JT
       COV = 0.771
       DIST = STORE(I+10)
       itype = istore(istore(i))
C Look for properties in L29:
       DO M29 = L29, L29+(N29-1)*MD29, MD29
                 IF ( ISTORE(M29) .EQ. itype ) THEN
                    COV = STORE(M29+1)
                    EXIT
                 ENDIF
       END DO
       RADIUS = 1.1*(0.77+COV)
       IF (DIST .LT. RADIUS) THEN
         IF (NBONDS .EQ. 0) THEN
            NBONDS = 1
            IADD(1) = I
         ELSE
            DO 300 J = 1, NBONDS
              IF (DIST .LT. STORE(IADD(J)+10)) THEN
                IF (J .LE. 3) THEN
                  DO 200 K = MIN(3,NBONDS), J, -1
                    IADD(K+1) = IADD(K)
200               CONTINUE
                ENDIF
                IADD(J) = I
                NBONDS = MIN(NBONDS+1, 4)
                GOTO 320
              ENDIF
300         CONTINUE
              NBONDS = MIN(NBONDS+1,4)
              IADD(NBONDS) = I
320         CONTINUE
         ENDIF
       ENDIF
1000  CONTINUE
      IF (NBONDS .GT. 0) DIST = STORE(IADD(1)+10)
      KBNDED = NBONDS
      RETURN
      END
C
C
CODE FOR KHYB
      FUNCTION KHYB (IADD, DIST, DELTA)
C
C IADD - ADDRESS IN DISTANCE STACK OF ATOM TO BE TESTED
C DIST - BONDLENGTH TO TESTED ATOM
C DELTA - SMALLEST DIFFERENCE FROM THRESHOLD
C
C RETURNS A VALUE OF THE HYBRIDISATION STATE OF THE TARGET
C ATOM BY COMPARING DIST  WITH THRESHOLD VALUES FOR THE
C CONTACT ATOM TYPE, MMIN,(= ISTORE(ISTORE(IADD))).
C NHYB = 0 IF IT CANNOT BE ASSIGNED BY THE RULES HERE, I.E. IF
C THE SHORTEST BOUND ATOM TYPE IS NOT RECOGNISED.
C
      PARAMETER (NTYPE=8)
      CHARACTER *(NTYPE*4) CATOMS, CTARG*4
      DIMENSION THRESH (2,NTYPE)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
C
C----- KNOWN ATOM SYMBOL LIST
      DATA CATOMS
     1   / 'C   N   O   F   SI  P   CL  S   '/
C
C THRESHOLD VALUES FOR BOND LENGTHS FOR COMPARISON WITH SHORTEST BOND.
C       3/2, 2/1 THRESHOLD PAIRS
      DATA THRESH
     2   / 1.43, 1.23, 1.41, 1.22, 1.35, 1.17, 1.34, 1.15,
     3     1.82, 1.60, 1.60, 1.40, 1.50, 1.40, 1.78, 1.70 /
C
      KHYB = 0
      DELTA= 1000.
      MMIN=ISTORE(ISTORE(IADD))
      WRITE(CTARG,'(A4)') MMIN
      I = INDEX (CATOMS, CTARG)
      IF (I .LE. 0) RETURN
C
      I = (I+3)/4
      D1 = DIST - THRESH(1,I)
      D2 = DIST - THRESH(2,I)
capr06      IF (ABS(D1) .LT. ABS(D2)) THEN
C----- SP2/SP3 INTERFACE
            IF (D1 .GT. 0.) THEN
                  KHYB = 3
                  DELTA = D1
            ELSE if (d2 .le. 0) then
C----- SP1/SP2 INTERFACE
                  KHYB = 1
                  DELTA = D2
            else 
                  khyb = 2
                  delta = min(abs(d1), abs(d2))
            ENDIF
capr06      ELSE
capr06            IF (D2 .GT. 0.) THEN
capr06                  KHYB = 2
capr06            ELSE
capr06                  KHYB = 1
capr06            ENDIF
capr06            DELTA = D2
capr06      ENDIF
      RETURN
      END
C
C
CODE FOR HPLACE
      SUBROUTINE HPLACE
     1 (NBONDS,NHYB,M5A,IADD,AOTEMP,APTEMP,NDTEMP,JACT,ISEC,NHADD)
C
C USING NHYB AND NBONDS, WRITE THE APPROPRIATE HYDROGEN PLACING
C COMMAND USING ONE OF THE WRITNM ROUTINES.
C
      DIMENSION IADD(4)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
C
C      NO OF HYDROGENS REQUIRED = N
       N=NHYB+1-NBONDS
C
      IF (NHYB .EQ. 3) THEN
C SP3
             IF (NBONDS .EQ. 1) THEN
C
C
                IF (ISEC .GT. 0) THEN
C
                   CALL XWRT03(M5A,IADD(1),ISEC,1,'33', JACT)
                   NHADD = NHADD + 3
                ELSE
                   CALL XERWH (M5A,'33')
                ENDIF
C
             ELSE IF (NBONDS .EQ. 2) THEN
                CALL XWRT03(M5A,IADD(1),IADD(2),1,'23', JACT)
                NHADD = NHADD + 2
             ELSE IF (NBONDS .EQ. 3) THEN
                CALL XWRT13(IADD,M5A, JACT)
C
             ENDIF
C
      ELSE IF (NHYB .EQ. 2) THEN
C SP2
               IF (NBONDS .EQ. 1) THEN
C
C
                  IF (ISEC .GT. 0) THEN
C
                     CALL XWRT03 (M5A,IADD(1),ISEC,1,'22', JACT)
                     NHADD = NHADD + 2
                  ELSE
                     CALL XERWH (M5A,'22')
                  ENDIF
C
               ELSE IF (NBONDS .EQ. 2) THEN
C
                  CALL XWRT03 (M5A, IADD(1), IADD(2), 1, '12', JACT)
                  NHADD = NHADD + 1
C
               ENDIF
C
      ELSE
C SP1
       IF (NBONDS .EQ. 1) THEN
C
                     CALL XWRT11 (IADD, M5A, JACT)
                     NHADD = NHADD + 1
C
       ENDIF
C
C
      ENDIF
      RETURN
      END
C
C
CODE FOR KSEC
       FUNCTION KSEC(AOTEMP,APTEMP,NDTEMP, IADD, NBONDS, JADD)
C
C RETURNS THE ADDRESS IN ISTORE OF A USABLE SECOND CONTACT FOR THE
C TARGET ATOM AT M5.
C
      DIMENSION IADD(4)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XPROCC.INC'
C      COMMON /XPROCC/DISTS(4),LN1,LN2,ITYPE,NATOM,ILIST,ISEQ,D3,AMULT,
C     2 IACT, ISYMOD, ITRANS
C      COMMON /XDISTW/A,BB,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
c      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C      EQUIVALENCE (TOLER,DISTS(4))
      DATA TOLER /0.6/, ITRANS / 0 /
C
#ifdef _HOL_
      DATA KHYD / 4HH    /
      DATA KDET / 4HD    /
#else
      DATA KHYD / 'H   ' /
      DATA KDET / 'D   ' /
#endif
C----- USE THE SHORTEST CONTACT FROM THE FIRST DISTANCE STACK
C      AS A PIVOT FOR A NEW STACK. SEARCH THIS NEW STACK FOR
C      AN ATOM IN COMMON WITH THE FIRST. CHOOSE A NON-H ATOM
C      IF POSSIBLE. THIS COMMON ATOM IS 'R2' IN THE H22 OR H33
C      COMMAND.
C
      ISEC = -1000
C----- SAVE OLD TARGET
      M5B=M5A
C----- ONLY LOOK FOR SHORT CONTACTS
      AO = AOTEMP
      AC = AOTEMP
      AP = APTEMP

c      WRITE ( CMON, 101) ' Ksec: NBONDS ',NBONDS 
c      CALL XPRVDU(NCVDU, 1,0)
c101   FORMAT(10X, A, I5)

C
C----- SET UP A LOOP TO TRY ALL THE SHORT CONTACTS IN IADD
      DO 1650 I = 1, NBONDS

        JADD = I
C----- THE ADDRESS OF THE NEW PIVOT IS IN ISTORE(IADD(I))
        M5S = IADD(I)
        M5A = ISTORE(M5S)

c        WRITE ( CMON, 100) ' Searching around ', 
c     1 STORE(M5A), NINT(STORE(M5A+1)),STORE(M5S+10)
c        CALL XPRVDU(NCVDU, 1,0)
c100     FORMAT(10X, A, A, I5, F8.3)


C
C CONSIDER ONLY THOSE ATOMS ON THIS STACK WITHIN 1.9 ANGSTROM
C WHEN DECIDING A PIVOT FOR THE SECOND STACK.
C
        IF (STORE(M5S+10) .LT. 1.9) THEN
C
C----- ENSURE THAT NFL POINTS TO THE END OF THE OLD DISTANCE STACK
          NFL=JL
C        THE START OF THE NEW STACK
          JJE=JL
          M5=L5
C
cdjwaug06
c         NDTEMP = KDIST1( N5, JJJE, JT, 0, TOLER, ITRANS, 0, 4, 0)
         NDTEMP = KDIST1( N5, JJJE, JT, 0, TOLER, ITRANS, 0, 4, 1)
c          NDTEMP = KDIST4( JJJE, JT, 0, 0 ) !Assume 3rd contact has little relevance to H geometry (for now).

c          WRITE ( CMON, 102) ' NDTemp ', NDTEMP
c          CALL XPRVDU(NCVDU, 1,0)
c102       FORMAT(10X, A, I6)


          IF (NDTEMP .LT. 2)    GOTO 1630 ! No good - need at least one other contact
C
C
C SCAN BOTH STACKS LOOKING FOR A 1-3 CONTACT FOR THE TARGET ATOM,
C      AND A 1-2 CONTACT FOR THE AUXILLIARY ATOM
C
          DO 1600 IJE=JE, JK, JT          ! The original list of bonds around the target atom
            DO 1590 IJJE=JJE,JJJE-JT,JT    ! List of bonds around secondary contact

 
c              WRITE ( CMON, 104) ' KSEC: ',STORE(ISTORE(IJJE)), 
c     1 NINT(STORE(ISTORE(IJJE)+1)),
c     1  STORE(ISTORE(IJE)), NINT(STORE(ISTORE(IJE)+1))
c              CALL XPRVDU(NCVDU, 1,0)
c104           FORMAT(10X, A, A, I5, A, I5 )


C----- CHECK THE ATOM ADDRESSES IN LIST 5 AGREE (IE SAME ATOM),
C      AND THAT THE NEW ATOM IS A 1 - 3 CONTACT WITH THE TARGET
C      AND A 1 - 2 CONTACT WITH THE INTERMEDIATE.
! Old stack contains long (1-3) contacts (not any more) therefore this will fail.
! We just need shortest secondary contact, pref not H.

              IF (  (ISTORE(IJJE) .EQ. ISTORE(IJE)) .AND.
     1             (STORE(IJE +10) .GT. 1.9)     .AND. 
     1             (STORE(IJJE+10) .LE. 1.9)   ) THEN
                ISEC = IJE                                  !Store this one it might do
                IF( (ISTORE(ISTORE(ISEC)) .NE. KHYD) .AND. 
     1          (ISTORE(ISTORE(ISEC)) .NE. KDET)) GOTO 1700 !That'll do.
              ENDIF

1590        CONTINUE
1600      CONTINUE
1630      CONTINUE
        ENDIF
1650  CONTINUE !End of loop over first atom contacts

1700  CONTINUE
C     RESTORE OLD TARGET
      M5A = M5B
      KSEC = ISEC
c      WRITE ( CMON, 103) ' KSEC ret ',KSEC 
c      CALL XPRVDU(NCVDU, 1,0)
c103   FORMAT(10X, A, I5 )

      RETURN
      END
C
CODE FOR KSEC2
       FUNCTION KSEC2(AOTEMP,APTEMP,NDTEMP, IADD, NBONDS, JADD)
C
C RETURNS THE ADDRESS IN ISTORE OF A USABLE SECOND CONTACT FOR THE
C TARGET ATOM AT M5.
C
      DIMENSION IADD(4)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XPROCC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
c      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA TOLER /0.6/, ITRANS / 0 /
C
#ifdef _HOL_
      DATA KHYD / 4HH    /
      DATA KDET / 4HD    /
#else
      DATA KHYD / 'H   ' /
      DATA KDET / 'D   ' /
#endif

C Use shortest contact from primary atom as secondary atom. Find shortest contact to a different atom
C that preferably isn't H or D.

      ISEC = -1000
C----- SAVE OLD TARGET
      M5B=M5A
C----- ONLY LOOK FOR SHORT CONTACTS
      AO = AOTEMP
      AC = AOTEMP
      AP = APTEMP

C----- SET UP A LOOP TO TRY ALL THE SHORT CONTACTS IN IADD
      DO 1650 I = 1, NBONDS

          JADD = I
C----- THE ADDRESS OF THE NEW PIVOT IS IN ISTORE(IADD(I))
          M5S = IADD(I)
          M5A = ISTORE(M5S)

C----- ENSURE THAT NFL POINTS TO THE END OF THE OLD DISTANCE STACK
          NFL=JL
C        THE START OF THE NEW STACK
          JJE=JL
          M5=L5

c          NDTEMP = KDIST1( N5, JJJE, JT, 0, TOLER, ITRANS, 0, 4, 1)
          NDTEMP = KDIST4( JJJE, JT, 0, 0 ) 

          IF (NDTEMP .LT. 2)    GOTO 1630 ! No good - need at least one other contact

          DO 1590 IJJE=JJE,JJJE-JT,JT    ! List of bonds around secondary contact
             IF ( (ISTORE(IJJE) .NE. M5B )) THEN    ! Not back to self. Good.
                ISEC = IJJE
                IF( (ISTORE(ISTORE(ISEC)) .NE. KHYD) .AND. 
     1          (ISTORE(ISTORE(ISEC)) .NE. KDET)) GOTO 1700 !That'll do.
             ENDIF
1590      CONTINUE

1630      CONTINUE
1650  CONTINUE !End of loop over first atom contacts

1700  CONTINUE
C     RESTORE OLD TARGET
      M5A = M5B
      KSEC2 = ISEC

      RETURN
      END
C
CODE FOR XERWH
      SUBROUTINE XERWH (M5A,CTYPE)
C
C----- WRITE WARNINGS IF CRYSTALS CANNOT PLACE HYDROGENS
C
      CHARACTER *16 CWRITE
      CHARACTER *2 CTYPE
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
C
       WRITE(CWRITE(1:4), '(A4)') STORE(M5A)
       NCCTRM=KCCTRM(1,CWRITE(1:4),ISTART,IEND)
       CWRITE(IEND+1:IEND+1)='('
       IEND=IEND+1
C
       CALL CIAPP(CWRITE,INT(STORE(M5A+1)),IEND)
C
       CWRITE(IEND:IEND+1)=') '
C
      IF (ISSPRT .EQ. 0) WRITE(NCWU,100) CWRITE(1:IEND)
      WRITE ( CMON, 100) CWRITE(1:IEND)
      CALL XPRVDU(NCVDU, 1,0)
100   FORMAT(10X, ' CRYSTALS cannot place Hydrogen atoms on ',A)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,200) CTYPE
      WRITE ( CMON, 200) CTYPE
      CALL XPRVDU(NCVDU, 1,0)
200   FORMAT(10X,' - no suitable third atom for H',A2,' card.')
      RETURN
      END
C
C
CODE FOR XWRT11
       SUBROUTINE XWRT11 (IADD,M5A, JACT)
C
C WRITES A H11 COMMAND
C
      CHARACTER CSRQ *80
      CHARACTER*27 CATOM
      CHARACTER*80 CWRITE
      CHARACTER*6 CFORM
C
      DIMENSION IADD(4)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
C
       CWRITE=' '
       CSRQ = ' '
C
C WRITE SERIAL NUMBER (= PIVOT ATOM LABEL * 10)
C
      ISER = NINT (STORE (M5A+1) * 10.) +1
      IF (JACT .LE. 2) THEN
       WRITE (CSRQ,'(''SERIAL '', I7)') ISER
       CALL XISRC (CSRQ)
      ENDIF
      IF (JACT .GE. 2) THEN
       WRITE (NCFPU2,'(''SERIAL '', I7)') ISER
      write(nCCBU,'(a,i5,a)') 'delete h(',iser,')'
      ENDIF
C
C START WRITING COMMAND TO CWRITE
C
       CWRITE(1:4)='H11 '
       WRITE(CWRITE(5:8), '(A4)') STORE(M5A)
       NCCTRM=KCCTRM(1,CWRITE(5:8),ISTART,ITEMP)
C
       IF (NCCTRM .LT. 0) THEN
            CALL XIVHT('H11')
            RETURN
       ENDIF
C
       IEND=ITEMP+4
       CWRITE(IEND+1:IEND+1)='('
       IEND=IEND+1
C
       CALL CIAPP(CWRITE,NINT(STORE(M5A+1)),IEND)
C
       CWRITE(IEND:IEND+1)=') '
       IEND=IEND+1
C
C WRITE ATTACHED ATOM SPECIFICATIONS TO CATOM(1:LCATOM)
C
       CALL CATSTR(STORE(ISTORE(IADD(1))),
     +             STORE(ISTORE(IADD(1))+1),
     +             ISTORE(IADD(1)+2), ISTORE(IADD(1)+3),
     +             ISTORE(IADD(1)+4), ISTORE(IADD(1)+5),
     +             ISTORE(IADD(1)+6), CATOM, LCATOM)
C
       LCWRIT=IEND+LCATOM+1
C
C ADD THESE ATOM SPECS TO THE COMMAND IN CWRITE
C
       CWRITE(IEND+1:LCWRIT)=' '//CATOM(1:LCATOM)
C
C WRITE A FORMAT SPECIFIER FOR CWRITE
C
       CFORM='(A    '
       NEND=2
       CALL CIAPP(CFORM,LCWRIT,NEND)
       CFORM(NEND:NEND)=')'
C
C WRITE CWRITE TO SRQ
C
      IF (JACT .LE. 2) THEN
       CSRQ = ' '
       WRITE(CSRQ,FMT=CFORM) CWRITE(1:LCWRIT)
       CALL XISRC (CSRQ)
      ENDIF
      IF (JACT .GE. 2) THEN
       WRITE(NCFPU2,FMT=CFORM) CWRITE(1:LCWRIT)
      ENDIF
cdjwmar09
c      write to list file
      if (issprt.eq. 0) then
            write(ncwu,fmt=cform)cwrite(1:lcwrit)
      endif
C
C----- WRITE A RIDE INSTRUCTION
      WRITE(CWRITE,1000) STORE(M5A), NINT(STORE(M5A+1)), ISER
1000  FORMAT('RIDE ', A4, '(',I4, ',X''S) H(',I4,',X''S)')
      CALL XCREMS (CWRITE, CWRITE, LCWRIT)
      WRITE(NCFPU1,'(A)') CWRITE(1:LCWRIT)
       RETURN
       END
C
C
CODE FOR XWRT13
       SUBROUTINE XWRT13 (IADD,M5A, JACT)
C
C WRITE AN H13 COMMAND
C     M5A    - PIVOT ATOM
C     IADD   - INTEGER ARRAY OF CONTACTS
C     CATOM  - CHARACTER ARRAY HOLDING THREE SINGLE ATOM SPECS.
C     LCATOM - INTEGER ARRAY HOLDING CORRESPONDING LENGTHS
C     CFORM  - FORMAT SPECIFIER
C     CWRITE - COMMAND
C     LCWRIT - LENGTH
C
      CHARACTER CSRQ *80
      CHARACTER*27 CATOM(3)
      CHARACTER*80 CWRITE
      CHARACTER*6 CFORM
C
      DIMENSION IADD(4), LCATOM(3)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
C
       CWRITE =' '
       CSRQ = ' '
C
C WRITE SERIAL NUMBER (= PIVOT ATOM LABEL * 10)
C
      ISER = NINT (STORE (M5A+1) * 10.) +1
      IF (JACT .LE. 2) THEN
       WRITE (CSRQ,'(''SERIAL '', I7)') ISER
       CALL XISRC (CSRQ)
      ENDIF
      IF (JACT .GE. 2) THEN
       WRITE (NCFPU2,'(''SERIAL '', I7)') ISER
      write(ncCBU,'(a,i5,a)') 'delete h(',iser,')'
      ENDIF
C
C WRITE ATOM SPECIFICATIONS TO CATOM(N)(1:LCATOM(N)) (N = 1 TO 3)
C
       CALL CATSTR(STORE(ISTORE(IADD(1))),
     +             STORE(ISTORE(IADD(1))+1),
     +             ISTORE(IADD(1)+2), ISTORE(IADD(1)+3),
     +             ISTORE(IADD(1)+4), ISTORE(IADD(1)+5),
     +             ISTORE(IADD(1)+6), CATOM(1),
     +             LCATOM(1))
C
       CALL CATSTR(STORE(ISTORE(IADD(2))),
     +             STORE(ISTORE(IADD(2))+1),
     +             ISTORE(IADD(2)+2), ISTORE(IADD(2)+3),
     +             ISTORE(IADD(2)+4), ISTORE(IADD(2)+5),
     +             ISTORE(IADD(2)+6), CATOM(2),
     +             LCATOM(2))
C
       CALL CATSTR(STORE(ISTORE(IADD(3))),
     +             STORE(ISTORE(IADD(3))+1),
     +             ISTORE(IADD(3)+2), ISTORE(IADD(3)+3),
     +             ISTORE(IADD(3)+4), ISTORE(IADD(3)+5),
     +             ISTORE(IADD(3)+6), CATOM(3),
     +             LCATOM(3))
C
C WRITE PIVOT ATOM SPECS TO CWRITE
C
       CWRITE(1:4)='H13 '
       WRITE(CWRITE(5:8), '(A4)') STORE(M5A)
       NCCTRM = KCCTRM(1,CWRITE(5:8), ISTART, ITEMP)
C
       IF (NCCTRM .LT. 0) THEN
            CALL XIVHT('H13')
            RETURN
       ENDIF
C
       IEND=4+ITEMP
       CWRITE(IEND+1:IEND+1)='('
       IEND=IEND+1
       CALL CIAPP(CWRITE,INT(STORE(M5A+1)),IEND)
       LCWRIT=IEND+LCATOM(1)+LCATOM(2)+LCATOM(3)+4
C
C WRITE ATTACHED ATOM SPECS TO CWRITE
C
       CWRITE(IEND:LCWRIT)=') '//CATOM(1)(1:LCATOM(1))//' '
     +//CATOM(2)(1:LCATOM(2))//' '//CATOM(3)(1:LCATOM(3))
C
C WRITE A FORMAT SPECIFIER FOR CWRITE
C
       CFORM='(A    '
       NEND=2
       CALL CIAPP(CFORM,LCWRIT,NEND)
       CFORM(NEND:NEND)=')'
C
C WRITE CWRITE TO SRQ
C
      IF (JACT .LE. 2) THEN
       CSRQ = ' '
       WRITE(CSRQ,FMT=CFORM) CWRITE(1:LCWRIT)
       CALL XISRC (CSRQ)
      ENDIF
      IF (JACT .GE. 2) THEN
       WRITE (NCFPU2,FMT=CFORM) CWRITE(1:LCWRIT)
      ENDIF
cdjwmar09
c      write to list file
      if (issprt.eq. 0) then
            write(ncwu,fmt=cform)cwrite(1:lcwrit)
      endif
C
C----- WRITE A RIDE INSTRUCTION
      WRITE(CWRITE,1000) STORE(M5A), NINT(STORE(M5A+1)), ISER
1000  FORMAT('RIDE ', A4, '(',I4, ',X''S) H(',I4,',X''S)')
      CALL XCREMS (CWRITE, CWRITE, LCWRIT)
      WRITE(NCFPU1,'(A)') CWRITE(1:LCWRIT)
       RETURN
       END
C
C
C
CODE FOR XWRT03
       SUBROUTINE XWRT03 (IATOM1, IATOM2, IATOM3, ITARG, CTYPE, JACT)
C
C------ WRITE AN INSTRUCTION INVOLVING 3 ATOMS, AT ADDRESSES
C       IATOM1, IATOM2, IATOM3
C
C     ITARG  - THE POSITION IN THE COMMAND (1 OR 2) OF THE TARGET ATOM
C     CTYPE  - TYPE OF H PLACING COMMAND REQUIRED (E.G. 22, 23,)
C     IATOM1 - ADDRESS IN LIST 5 OF THE PIVOT ATOM - THIS ATOM MUST
C               COME FIRST.
C     IATOM2 - ADDRESS IN STACK OF SECOND ATOM
C     IATOM3 - ADDRESS IN STACK OF THIRD ATOM - BOTH OF THESE ARE
C               ADDRESSES IN THE STACK GENERATED BY KDIST.
C
C     ISI    - 1    DEFAULT SYMMETRY FLAGS USED AS
C     NPLII  - 1      ARGUMENTS TO CATSTR FOR THE
C     ITXI   - 0          PIVOT ATOM (ATOM 1)
C     ITYI   - 0
C     ITZI   - 0
C     CATOM  - CHARACTER ARRAY HOLDING THREE SINGLE ATOM SPECS.
C     LCATOM - INTEGER ARRAY HOLDING CORRESPONDING LENGTHS
C     CFORM  - FORMAT SPECIFIER
C     CWRITE - COMMAND
C     LCWRIT - LENGTH
C
      CHARACTER CSRQ *80
      CHARACTER*27 CATOM(3)
      CHARACTER*80 CWRITE
      CHARACTER*6 CFORM
      CHARACTER*2 CTYPE
C
      DIMENSION LCATOM(3)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
      ISI = 1
      NPLII = 1
      ITXI = 0
      ITYI = 0
      ITZI = 0
C
       CWRITE=' '
       CSRQ = ' '
C
C WRITE SERIAL NUMBER (= PIVOT ATOM LABEL * 10)
C
      ISER = NINT( STORE(IATOM1+1) * 10.) +1
      IF (JACT .LE. 2) THEN
       WRITE (CSRQ,'(''SERIAL '', I7)') ISER
       CALL XISRC (CSRQ)
      ENDIF
      IF (JACT .GE. 2) THEN
       WRITE (NCFPU2,'(''SERIAL '', I7)') ISER
      if (ctype .eq. '12') then
        write(ncCBU,'(a,i5,a)') 'delete h(',iser,')'
      else if (ctype .eq. '33') then
        write(ncCBU,'(a,i5,a)') 'delete h(',iser,')'
        write(ncCBU,'(a,i5,a)') 'delete h(',iser+1,')'
        write(ncCBu,'(a,i5,a)') 'delete h(',iser+2,')'
      else
        write(ncCBu,'(a,i5,a)') 'delete h(',iser,')'
        write(ncCBu,'(a,i5,a)') 'delete h(',iser+1,')'
      endif
      ENDIF
C
C WRITE ATOM SPECIFICATIONS TO CATOM(N)(1:LCATOM(N)), N = 1 TO 3
C
       CALL CATSTR (STORE(IATOM1),
     +              STORE(IATOM1+1), ISI, NPLII,
     +              ITXI, ITYI, ITZI, CATOM(1), LCATOM(1))
C
       CALL CATSTR(STORE(ISTORE(IATOM2)),
     +             STORE(ISTORE(IATOM2)+1), ISTORE(IATOM2+2),
     +             ISTORE(IATOM2+3), ISTORE(IATOM2+4),
     +             ISTORE(IATOM2+5), ISTORE(IATOM2+6), CATOM(2),
     +             LCATOM(2))
C
       CALL CATSTR(STORE(ISTORE(IATOM3)),
     +             STORE(ISTORE(IATOM3)+1), ISTORE(IATOM3+2),
     +             ISTORE(IATOM3+3), ISTORE(IATOM3+4),
     +             ISTORE(IATOM3+5), ISTORE(IATOM3+6), CATOM(3),
     +             LCATOM(3))
C
C WRITE COMMAND TO CWRITE IN ORDER ACCORDING TO ITARG
C
       IF (ITARG .EQ. 1) THEN
       CWRITE = 'H'//CTYPE//' '//CATOM(1)(1:LCATOM(1))
     +//' '//CATOM(2)(1:LCATOM(2))//' '//CATOM(3)(1:LCATOM(3))
       ELSE
       CWRITE = 'H'//CTYPE//' '//CATOM(2)(1:LCATOM(2))
     +//' '//CATOM(1)(1:LCATOM(1))//' '//CATOM(3)(1:LCATOM(3))
       END IF
C
       LCWRIT = LCATOM(1) + LCATOM(2) + LCATOM(3) + 7
C
C WRITE A FORMAT SPECIFIER FOR CWRITE
C
       CFORM='(A    '
       NEND=2
       CALL CIAPP(CFORM,LCWRIT,NEND)
       CFORM(NEND:NEND)=')'
C
C WRITE COMMAND TO SRQ
C
      IF (JACT .LE. 2) THEN
       CSRQ = ' '
       WRITE(CSRQ,FMT=CFORM) CWRITE(1:LCWRIT)
       CALL XISRC (CSRQ)
      ENDIF
      IF (JACT .GE. 2) THEN
       WRITE (NCFPU2,FMT=CFORM) CWRITE(1:LCWRIT)
      ENDIF
cdjwmar09
c      write to list file
      if (issprt.eq. 0) then
            write(ncwu,fmt=cform)cwrite(1:lcwrit)
      endif
C
C----- WRITE A RIDE INSTRUCTION
      IF (CTYPE(1:1) .EQ. '1') THEN
      WRITE(CWRITE,1000) STORE(IATOM1), NINT(STORE(IATOM1+1)),
     1  ISER
      ELSE IF (CTYPE(1:1) .EQ. '2') THEN
      WRITE(CWRITE,1000) STORE(IATOM1), NINT(STORE(IATOM1+1)),
     1  ISER,' ',ISER+1
      ELSE
      WRITE(CWRITE,1000) STORE(IATOM1), NINT(STORE(IATOM1+1)),
     1  ISER,' ',ISER+1,' ',ISER+2
      ENDIF
cdjwsep08
cc      write(ncpu,'(3(a,i6))') 
cc     1 store(iatom1),nint(store(iatom1+1)),
cc     2 store(iatom2),nint(store(iatom2+1)),
cc     3 store(iatom3),nint(store(iatom3+1))
c
cdjwsep08
1000  FORMAT('RIDE ', A4,'(', I4, ',X''S)',
     1 ' H(',I4,',X''S)', A,'H(',I4,',X''S)',
     2  A,'H(',I4,',X''S)')
      CALL XCREMS (CWRITE, CWRITE, LCWRIT)
      WRITE(NCFPU1,'(A)') CWRITE(1:LCWRIT)
       RETURN
       END
C
C
C
CODE FOR SPHEN
      SUBROUTINE SPHEN
C--FORM THE HYDROGENS OF A PHENYL GROUP
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JB=JA
      JE=JD
      CALL SVET(STORE(JE),STORE(JF))
      JF=JF+3
      LADDU = JB-MD5A
      DO 1000 I=1,5
      CALL SH12S(1, LADDU)
      LADDU = LADDU - MD5A
      JE=JE+3
1000  CONTINUE
      RETURN
      END
C
CODE FOR SH12
      SUBROUTINE SH12
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JB=JA
      JE=JD
      CALL SH12S(2, JB)
      RETURN
      END
C
CODE FOR SH33
      SUBROUTINE SH33
C
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
C
      JR=0
      CALL SH3322
      RETURN
      END
C
CODE FOR SH23
      SUBROUTINE SH23

C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
cdjwsep08
c      je is start of orthogonal positions (3n locations)
c      jb is start of whole atoms (jb+4==x)
      JB=JA
      JE=JD
      JG=JF+9
      JH=JG+9
      JI=JH+9
      JO=JI+9
      JP=JO+3
      JQ=JP+3
      JN=JQ+3
C----- WORKSPACE FOR SWOPPING ATOMS
      ITMP = JN + 9
C----- REORDER ATOMS 1 AND 2 FOR H12 AND H23 DIRECTIVES
       CALL XMOVE (STORE(JE), STORE(ITMP), 3)
       CALL XMOVE (STORE(JE+3), STORE(JE), 3)
       CALL XMOVE (STORE(ITMP), STORE(JE+3), 3)
C--CHECK IF WE SHOULD USE THE T.F. OF THE BONDED ATOM
      IF(JZ)1050,1050,1000
C--USE THE T.F. OF THE BONDED ATOM
1000  CONTINUE
      I = JB
      CALL XEQUIV(1, I, MD5A, IEQUIV)
      SV = STORE(I+2)
      IF ( STORE(JB+2-MD5A) .LT. SV ) SV = STORE(JB+2-MD5A)
      IF ( STORE(JB+2-MD5A*2) .LT. SV ) SV = STORE(JB+2-MD5A*2)
      KPR = ISTORE(I+14)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A*2)
      KRES = ISTORE(I+16)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A*2)
      SY = STORE(IEQUIV) * STORE(IEQUIV+4)
c      WRITE(CMON,'(A,3(A,I4))')'23: ',STORE(JB),NINT(STORE(JB+1)), 
c     1 STORE(JB-MD5A),NINT(STORE(JB+1-MD5A)),
c     1 STORE(JB-MD5A*2),NINT(STORE(JB+1-MD5A*2))
c      CALL XPRVDU(NCVDU, 1,0)
1050  CONTINUE
      CALL SETV(STORE(JO),1.0)
      CALL XTRANS(STORE(JE),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      IF (I .NE. 0) THEN
C----- EVADE OCCASIONAL INEXPLICABLE SINGULARITIES
       CALL XTRANS(STORE(JE),STORE(JN),3,3)
       DO 98 IK = 0,6,3
       STORE(JN+IK)   = STORE(JN+IK)  -STORE(JN+IK+1) +.1
       STORE(JN+IK+2) = STORE(JN+IK+2)-STORE(JN+IK+1) +.1  
       STORE(JN+IK+1) = STORE(JN+IK+1)-STORE(JN+IK+1) +.1
98     CONTINUE
       I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      ENDIF
      IF(I)1100,1200,1100
1100  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1150)
      WRITE ( CMON, 1150)
      CALL XPRVDU(NCVDU, 1,0)
1150  FORMAT(' Given atoms do not define a unique plane')
      LEF=LEF+1
      JS=0
      RETURN
1200  CONTINUE
      E0=SNOR(STORE(JP))
      CALL SVETC(STORE(JP),STORE(JH),E0)
      CALL SDIFV(STORE(JE+3),STORE(JE),STORE(JP))
      E3=SNOR(STORE(JP))
      CALL SDIFV(STORE(JE+3),STORE(JE+6),STORE(JQ))
      E4=SNOR(STORE(JQ))
      JP1=JP
      JE1=JE+3
      JQ1=JQ
      DO 1250 N=1,3
      E1=STORE(JE1)+STORE(JP1)*SX*E3
      E2=STORE(JE1)+STORE(JQ1)*SX*E4
      STORE(JP1)=(E1+E2)*0.5
      STORE(JQ1)=STORE(JE1)*2.0-STORE(JP1)
      JP1=JP1+1
      JE1=JE1+1
      JQ1=JQ1+1
1250  CONTINUE
      CALL SDIFV(STORE(JE+3),STORE(JQ),STORE(JN))
      EE=SNOR(STORE(JN))
      JQ1=JQ
      JE1=JE+3
      JN1=JN
      DO 1300 N=1,3
      STORE(JQ1)=STORE(JE1)+STORE(JN1)*SX*EE*0.57738
      JQ1=JQ1+1
      JE1=JE1+1
      JN1=JN1+1
1300  CONTINUE
      STORE(JO)=0.0
      CALL SVET(STORE(JE+3),STORE(JH+3))
      CALL SVET(STORE(JP),STORE(JH+6))
      CALL XTRANS(STORE(JH),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      IF(I)1100,1350,1100
1350  CONTINUE
      E1=SNOR(STORE(JP))
      CALL SVETC(STORE(JP),STORE(JH+3),E1)
      STORE(JO+1)=0.0
      CALL SVET(STORE(JQ),STORE(JH+6))
      CALL XTRANS(STORE(JH),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      IF(I)1100,1400,1100
1400  CONTINUE
      E2=SNOR(STORE(JP))
      CALL SVETC(STORE(JP),STORE(JH+6),E2)
      DH1=SX*0.81647
      STORE(JO)=E0+DH1
      STORE(JO+1)=E1
      STORE(JO+2)=E2
      CALL XTRANS(STORE(JH),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JI),3)
      IF(I)1100,1450,1100
1450  CONTINUE
      STORE(JO)=E0-DH1
      CALL XMLTMM(STORE(JF),STORE(JO),STORE(JI+3),3,3,1)
      DO 1500 N=1,2
      CALL XMLTMM(STORE(L1O2),STORE(JI),STORE(JG),3,3,1)
      CALL SAPR
      JI=JI+3
      JG=JG+3
1500  CONTINUE
      RETURN
      END
C
CODE FOR SH13
      SUBROUTINE SH13
c----- mostly re-written by DJW May 2004 in response to 
c      problems noted by Alison Edwards
c
c      MODE  1 FOR ORIGINAL SPAGNA CENTROID METHOD
C            2 FOR ROLLETT EQUAL-ANGLE METHOD
      PARAMETER(MODE=2)
c
      dimension ACC(3,3)
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JB=JA
      JE=JD
      JG=JF+9
      JH=JG+9
      JI=JH+9
      JO=JI+9
      JP=JO+3
      JQ=JP+3
      JN=JQ+3
C--CHECK IF WE SHOULD USE THE T.F. OF THE BONDED ATOM
      IF(JZ)1050,1050,1000
C--WE USE THE T.F. OF THE BONDED ATOM
1000  CONTINUE
      CALL XEQUIV(1, JB, MD5A, IEQUIV)
      SV = STORE(JB+2)
      IF ( STORE(JB+2-MD5A) .LT. SV ) SV = STORE(JB+2-MD5A)
      IF ( STORE(JB+2-MD5A*2) .LT. SV ) SV = STORE(JB+2-MD5A*2)
      IF ( STORE(JB+2-MD5A*3) .LT. SV ) SV = STORE(JB+2-MD5A*3)
      KPR = ISTORE(JB+14)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A*2)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A*3)
      KRES = ISTORE(JB+16)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A*2)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A*3)
      SY = STORE(IEQUIV) * STORE(IEQUIV+4)
1050  CONTINUE

      IF (MODE .EQ. 1) THEN
C----- SPAGNA CENTROID METHOD.  FINDS CENTROID OF 3 ADJACENT ATOMS AND 
C      PROJECTS A LINE THROUGH THE PIVOT ATOM.  
C----- NORMALISE THE ATOMIC DISTANCES
        DO 100 I = 0,2
          STORE(JE+3+I) = STORE(JE+3+I) - STORE(JE+I)
          STORE(JE+6+I) = STORE(JE+6+I) - STORE(JE+I)
          STORE(JE+9+I) = STORE(JE+9+I) - STORE(JE+I)
100     CONTINUE
        I = NORM3(STORE(JE+3))
        I = NORM3(STORE(JE+6))
        I = NORM3(STORE(JE+9))
        CALL SETV(STORE(JP),0.0)
C-----  FIND THE CENTROID
        DO 210 N = 3,9,3
          DO 200 I = 0,2
            STORE(JP+I) = STORE(JP+I) + STORE(JE+N+I)
200       CONTINUE
210     CONTINUE
        I = NORM3(STORE(JP))
        IF (I .LT. 0) THEN
          IF (ISSPRT .EQ. 0) WRITE(NCWU,1150)
          WRITE ( CMON, 1150)
          CALL XPRVDU(NCVDU, 1,0)
1150      FORMAT(' The 4 atoms are co-planar')
C-----    TRY TO FORM A CROSS PRODUCT
          I = NCROP3(STORE(JE+3), STORE(JE+6), STORE(JP))
          IF (I .LT. 0) THEN
C           TRY ANOTHER PAIR
            I = NCROP3(STORE(JE+3), STORE(JE+9), STORE(JP))
              IF (I .LT. 0) THEN
                LEF=LEF+1
                JS=0
                RETURN
              ENDIF
          ENDIF
        ENDIF
        DO 300 N=0,2
          STORE(JQ+N)=STORE(JE+n)-STORE(JP+N)*SX
300     CONTINUE
      ELSE
C-----  ROLLETT METHOD
c-----  find the vectors
        DO 2100 I = 0,2
          STORE(JE+3+I) = STORE(JE+I) - STORE(JE+3+I)
          STORE(JE+6+I) = STORE(JE+I) - STORE(JE+6+I)
          STORE(JE+9+I) = STORE(JE+I) - STORE(JE+9+I)
2100    CONTINUE
C-----  NORMALISE THE ATOMIC DISTANCES
        I = NORM3(STORE(JE+3))
        I = NORM3(STORE(JE+6))
        I = NORM3(STORE(JE+9))
c-----  invert the matrix of coordinates
        call matinv(store(je+3), acc, det)
        IF (abs(det) .Le. zero) THEN
          IF (ISSPRT .EQ. 0) WRITE(NCWU,1150)
          WRITE ( CMON, 1150)
          CALL XPRVDU(NCVDU, 1,0)
          LEF=LEF+1
          JS=0
          RETURN
        ENDIF
c-----  mutliply matrix onto unit vector
        store(jp  )= acc(1,1)+acc(2,1)+acc(3,1)
        store(jp+1)= acc(1,2)+acc(2,2)+acc(3,2)
        store(jp+2)= acc(1,3)+acc(2,3)+acc(3,3)
        i = norm3(store(jp))
        DO 2200 N=0,2
          STORE(JQ+N)=STORE(JE+n)+STORE(JP+N)*SX
2200    CONTINUE
      ENDIF
      CALL XMLTMM(STORE(L1O2),STORE(JQ),STORE(JG),3,3,1)
      CALL SAPR
      RETURN
      END
C
CODE FOR SH22
      SUBROUTINE SH22
C
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
C
      JR=1
      CALL SH3322
      RETURN
      END
C
CODE FOR SH11
      SUBROUTINE SH11
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JB=JA
      JE=JD
      JG=JF+9
      JH=JG+9
      JI=JH+9
      JO=JI+9
      JP=JO+3
      JQ=JP+3
      JN=JQ+3
C--CHECK IF WE SHOULD THE T.F. OF THE BONDED ATOM
      IF(JZ)1050,1050,1000
C--WE USE THE T.F. OF THE BONDED ATOM
1000  CONTINUE
      CALL XEQUIV(1, JB, MD5A, IEQUIV)
      SY = STORE(IEQUIV) * STORE(IEQUIV+4)
      SV = STORE(JB+2)
      IF ( STORE(JB+2-MD5A) .LT. SV ) SV = STORE(JB+2-MD5A)
      IF ( STORE(JB+2-MD5A*2) .LT. SV ) SV = STORE(JB+2-MD5A*2)
      KPR = ISTORE(JB+14)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A*2)
      KRES = ISTORE(JB+16)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A*2)
1050  CONTINUE
      CALL SDIFV(STORE(JE+3),STORE(JE),STORE(JN))
      EE=SNOR(STORE(JN))
      JQ1=JQ
      JE1=JE
      JN1=JN
      DO 1100 N=1,3
      STORE(JQ1)=STORE(JE1)+STORE(JN1)*SX*EE
      JQ1=JQ1+1
      JE1=JE1+1
      JN1=JN1+1
1100  CONTINUE
      CALL XMLTMM(STORE(L1O2),STORE(JQ),STORE(JG),3,3,1)
      CALL SAPR
      RETURN
      END
C
C
CODE FOR SHB
      SUBROUTINE SHB
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JB=JA
      JE=JD
      JG=JF+9
      JH=JG+9
      JI=JH+9
      JO=JI+9
      JP=JO+3
      JQ=JP+3
      JN=JQ+3
C--CHECK IF WE SHOULD THE T.F. OF THE BONDED ATOM
      IF(JZ)1050,1050,1000
C--WE USE THE T.F. OF THE BONDED ATOM
1000  CONTINUE
      CALL XEQUIV(1, JB, MD5A, IEQUIV)
      SY = STORE(IEQUIV) * STORE(IEQUIV+4)
      SV = STORE(JB+2)
      IF ( STORE(JB+2-MD5A) .LT. SV ) SV = STORE(JB+2-MD5A)
      KPR = ISTORE(JB+14)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A)
      KRES = ISTORE(JB+16)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A)
1050  CONTINUE
      CALL SDIFV(STORE(JE+3),STORE(JE),STORE(JN))
      EE=SNOR(STORE(JN))
      JQ1=JQ
      JE1=JE
      JN1=JN
      DO 1100 N=1,3
COCT2000 NOTE - SIGN
      STORE(JQ1)=STORE(JE1)-STORE(JN1)*SX*EE
      JQ1=JQ1+1
      JE1=JE1+1
      JN1=JN1+1
1100  CONTINUE
      CALL XMLTMM(STORE(L1O2),STORE(JQ),STORE(JG),3,3,1)
      CALL SAPR
      RETURN
      END
C
CODE FOR SH12S
      SUBROUTINE SH12S(ITYPE, LADDU)
C----- ITYPE = 1 FOR PIVOT IN SECOND PLACE
C              2 FOR PIVOT FIRST
C----- LADDU   ADDRESS IN LIST 5A OF ATOM
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JG=JF+6
C----- WORKSPACE FOR SWOPPING ATOMS
      ITMP = JG + 9
      IF (ITYPE .EQ. 2) THEN
C----- REORDER ATOMS 1 AND 2 FOR H12 AND H23 DIRECTIVES
       CALL XMOVE (STORE(JE), STORE(ITMP), 3)
       CALL XMOVE (STORE(JE+3), STORE(JE), 3)
       CALL XMOVE (STORE(ITMP), STORE(JE+3), 3)
      ENDIF
C--CHECK IF WE SHOULD THE T.F. OF THE BONDED ATOM
      IF(JZ)1050,1050,1000
C--WE USE THE T.F. OF THE BONDED ATOM
1000  CONTINUE
      CALL XEQUIV(1, LADDU, MD5A, IEQUIV)
      SY = STORE(IEQUIV) * STORE(IEQUIV+4)
      SV = STORE(JB+2)
      IF ( STORE(JB+2-MD5A) .LT. SV ) SV = STORE(JB+2-MD5A)
      IF ( STORE(JB+2-MD5A*2) .LT. SV ) SV = STORE(JB+2-MD5A*2)
      KPR = ISTORE(JB+14)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A*2)
      KRES = ISTORE(JB+16)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A*2)
1050  CONTINUE
      CALL SDIFV(STORE(JE+3),STORE(JE),STORE(JF))
      CALL SDIFV(STORE(JE+3),STORE(JE+6),STORE(JF+3))
      D1=SNOR(STORE(JF))
      D2=SNOR(STORE(JF+3))
      JG1=JG
      JF1=JF
      DO 1100 N=1,3
      T1=STORE(JF1)*D1*SX
      T2=STORE(JF1+3)*D2*SX
      STORE(JG1)=(T1+T2)*0.5
      JG1=JG1+1
      JF1=JF1+1
1100  CONTINUE
      D3=SNOR(STORE(JG))
      JG1=JG
      JF1=JF
      JE1=JE+3
      DO 1150 N=1,3
      STORE(JF1)=-STORE(JG1)*D3*SX+STORE(JE1)
      JF1=JF1+1
      JG1=JG1+1
      JE1=JE1+1
1150  CONTINUE
      CALL XMLTMM(STORE(L1O2),STORE(JF),STORE(JG),3,3,1)
      CALL SAPR
C----- RESTORE ATOMS
      IF (ITYPE .EQ. 2) THEN
       CALL XMOVE (STORE(JE), STORE(ITMP), 3)
       CALL XMOVE (STORE(JE+3), STORE(JE), 3)
       CALL XMOVE (STORE(ITMP), STORE(JE+3), 3)
      ENDIF
      RETURN
      END
C
CODE FOR SH3322
      SUBROUTINE SH3322
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JB=JA
      JE=JD
      NFL=JF
C -- ALLOCATE WORK SPACE
      JG=KSTALL(9)
      JH=KSTALL(9)
      JI=KSTALL(9)
      JO=KSTALL(9)
      JP=KSTALL(3)
      JQ=KSTALL(3)
      JN=KSTALL(3)
C --
C
      IF(JR)1000,1000,1050
1000  CONTINUE
      JR1=3
      DHC=0.33326
      DHS=0.94284
      GOTO 1100
1050  CONTINUE
      JR1=2
      DHC=0.5
      DHS=0.86603
C--CHECK IF WE SHOULD THE T.F. OF THE BONDED ATOM
1100  CONTINUE
      IF(JZ)1200,1200,1150
C--WE SHOULD THE USE THE T.F. OF THE BONDED ATOM
1150  CONTINUE
      CALL XEQUIV(1, JB, MD5A, IEQUIV)
      SY = STORE(IEQUIV) * STORE(IEQUIV+4)
      SV = STORE(JB+2)
      IF ( STORE(JB+2-MD5A) .LT. SV ) SV = STORE(JB+2-MD5A)
      IF ( STORE(JB+2-MD5A*2) .LT. SV ) SV = STORE(JB+2-MD5A*2)
      KPR = ISTORE(JB+14)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A)
      IF ( KPR .EQ. 0 ) KPR = ISTORE(JB+14-MD5A*2)
      KRES = ISTORE(JB+16)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A)
      IF ( KRES .EQ. 0 ) KRES = ISTORE(JB+16-MD5A*2)
c      WRITE(CMON,'(A,3(A,I4))')'3322: ',STORE(JB),NINT(STORE(JB+1)), 
c     1 STORE(JB-MD5A),NINT(STORE(JB+1-MD5A)),
c     1 STORE(JB-MD5A*2),NINT(STORE(JB+1-MD5A*2))
c      CALL XPRVDU(NCVDU, 1,0)
1200  CONTINUE
      CALL SETV(STORE(JO),1.0)
      CALL XTRANS(STORE(JE),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      IF (I .NE. 0) THEN
C----- EVADE OCCASIONAL INEXPLICABLE SINGULARITIES
       CALL XTRANS(STORE(JE),STORE(JN),3,3)
       DO 98 IK = 0,6,3
       STORE(JN+IK)   = STORE(JN+IK)  -STORE(JN+IK+1) +.1
       STORE(JN+IK+2) = STORE(JN+IK+2)-STORE(JN+IK+1) +.1  
       STORE(JN+IK+1) = STORE(JN+IK+1)-STORE(JN+IK+1) +.1
98    CONTINUE
       I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      ENDIF
      IF(I)1250,1350,1250
1250  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1300)
      WRITE ( CMON, 1300)
      CALL XPRVDU(NCVDU, 1,0)
1300  FORMAT(' Given atoms do not define a unique plane')
      LEF=LEF+1
      JS=0
      RETURN
1350  CONTINUE
      E0=SNOR(STORE(JP))
      CALL SVETC(STORE(JP),STORE(JH),E0)
      CALL SDIFV(STORE(JE),STORE(JE+3),STORE(JP))
      E3=SNOR(STORE(JP))
      JP1=JP
      JE1=JE
      JQ1=JQ
      DO 1400 N=1,3
      STORE(JQ1)=STORE(JE1)-STORE(JP1)*SX*DHC*E3
      JP1=JP1+1
      JE1=JE1+1
      JQ1=JQ1+1
1400  CONTINUE
      STORE(JO)=0.0
      CALL SVET(STORE(JE),STORE(JH+3))
      CALL SVET(STORE(JE+3),STORE(JH+6))
      CALL XTRANS(STORE(JH),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      IF(I)1250,1450,1250
1450  CONTINUE
      E1=SNOR(STORE(JP))
      CALL SVETC(STORE(JP),STORE(JH+3),E1)
      STORE(JO+1)=0.0
      CALL SVET(STORE(JQ),STORE(JH+6))
      CALL XTRANS(STORE(JH),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JP),3)
      IF(I)1250,1500,1250
1500  CONTINUE
      E2=SNOR(STORE(JP))
      CALL SVETC(STORE(JP),STORE(JH+6),E2)
      STORE(JO)=E0
      STORE(JO+1)=E1+SX*DHS
      STORE(JO+2)=E2
      CALL XTRANS(STORE(JH),STORE(JN),3,3)
      I=KINV2(3,STORE(JN),STORE(JF),9,1,STORE(JO),STORE(JI),3)
      IF(I)1250,1550,1250
1550  CONTINUE
      STORE(JO+1)=E1-SX*DHS
      CALL XMLTMM(STORE(JF),STORE(JO),STORE(JI+3),3,3,1)
      IF(JR)1600,1600,1850
1600  CONTINUE
      CALL SDIFV(STORE(JE+6),STORE(JI),STORE(JP))
      E3=SNOR(STORE(JP))
      CALL SDIFV(STORE(JE+6),STORE(JI+3),STORE(JP))
      E4=SNOR(STORE(JP))
      IB=0
      IF(E3-E4)1700,1700,1650
1650  CONTINUE
      IB=1
      CALL SVET(STORE(JI+3),STORE(JI))
1700  CONTINUE
      DH1=SX*DHS*0.86603
      STORE(JO)=E0+DH1
      F=1.0
      IF(IB)1800,1800,1750
1750  CONTINUE
      F=-1.0
1800  CONTINUE
      STORE(JO+1)=E1-F*SX*DHS*0.5
      CALL XMLTMM(STORE(JF),STORE(JO),STORE(JI+3),3,3,1)
      STORE(JO)=E0-DH1
      CALL XMLTMM(STORE(JF),STORE(JO),STORE(JI+6),3,3,1)
C
1850  CONTINUE
      DO 1900 N=1,JR1
      CALL XMLTMM(STORE(L1O2),STORE(JI),STORE(JG),3,3,1)
      CALL SAPR
      JI=JI+3
      JG=JG+3
1900  CONTINUE
C -- RELEASE WORK SPACE
      CALL XSTRLL(JG)
      RETURN
      END
C
CODE FOR SAPR
      SUBROUTINE SAPR
C
C----- BUILD VALID ATOM LINE
      DIMENSION IHH(1)
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
C
#ifdef _HOL_
      DATA IHH(1)/4HH   /
#else
      DATA IHH(1)/'H   '/
#endif
C
C Check for clashing serial numebr

      DO ISW = 1,999
         ICLASH = 0
         DO K5 = L5,JT,MD5
           IF ( ( ISTORE(K5)        .EQ. IHH(1) ) .AND.
     1         ( NINT(STORE(K5+1)) .EQ. SW )     ) THEN
              SW = SW + 1
              ICLASH = 1
           END IF
         END DO
         IF ( ICLASH .EQ. 0) EXIT  ! No clash found
      END DO !Give up after 999 tries - we will have a clash.

      CALL XMOVE(IHH(1),STORE(JT),1)
      STORE(JT+1)=SW
      STORE(JT+2)=SV
C      STORE(JT+3)=SY
C-C-C-SET FLAG TO ISOTROPIC
      STORE(JT+3)=1.0
      STORE(JT+4)=STORE(JG)
      STORE(JT+5)=STORE(JG+1)
      STORE(JT+6)=STORE(JG+2)
C-C-C-PUT U[ISO] RESP. UEQUIV ON NEW PLACE
      STORE(JT+7)=SY
C--ZERO THE ANISO T.F.'S AND OTHER BITS
C      CALL XZEROF(STORE(JT+7),6)
      CALL XZEROF(STORE(JT+8),MD5-8)
      CALL XMOVE(IB,ISTORE(JT+17),1)
      ISTORE(JT+14)=KPR
      ISTORE(JT+16)=KRES
C--PRINT THE RESULT
cdjwsep08
      JTEMP=JT+7
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1000)(STORE(I),I=JT,JTEMP)
cRIC13:1000  FORMAT(11X,A4,F10.1,F11.5,F10.0,4F10.5)
1000  FORMAT(11X,A4,F10.1,F11.5,F10.0,4F10.4)
      JT=JT+MD5
C--UPDATE THE REMAINING POINTERS
      JS=JS+1
      SW=SW+1
      RETURN
      END
C
CODE FOR SAPRT
      SUBROUTINE SAPRT
C
C
      CHARACTER*8 CTYPES(8)
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
C
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW)
C
C
      DATA CTYPES / 'phenyl  ' , 'C(sp3)H1' , 'C(sp3)H1' , 'C(sp3)H3' ,
     2              'C(sp3)H2' , 'C(sp2)H2' , 'C(sp2)H1' , 'C(sp1)H1' /
C
C
C
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1100 ) CTYPES(JK)
1100  FORMAT ( // 1X , 'Hydrogen atom(s) calculated for the ' , A ,
     2 ' group :' , // ,
     3 10X , 'Type      Serial    Occ         Flag      ' ,
     4 'X         Y         Z     ',3x,'U[iso]' , / )
C
C
      RETURN
      END
C
CODE FOR SAORT
      SUBROUTINE SAORT
C--ORTHOGONALISE THE INPUT ATOMIC COORDINATES
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XWORKH.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
C
      JB=JA
      DO 1000 I=1,JC
      CALL XMLTTM(STORE(L1O1),STORE(JB+4),STORE(JE),3,3,1)
      JB=JB-MD5A
      JE=JE+3
1000  CONTINUE
      JF=JE
      RETURN
      END
C
cCODE FOR SPRV
c      SUBROUTINE SPRV(N)
cC
c\ISTORE
cC
c\STORE
c\XWORKA
c\XLISTI
c\XLST01
c\XLST05
c\XUNITS
c\XSSVAL
cC
c\QSTORE
cC
c      EQUIVALENCE (SY,JY),(SX,JX),(SW,JW),(SV,JV),(KPR,JM)
cC
c      IF (ISSPRT .EQ. 0) WRITE(NCWU,1000)STORE(N),STORE(N+1),STORE(N+2)
c1000  FORMAT(10X,3F10.5)
c      RETURN
c      END

CODE FOR SVET
      SUBROUTINE SVET(TN,TP)
C--TRANSFER A VECTOR OF ORDER 3
C
C  TP  OUTPUT VECTOR
C  TN  INPUT  VECTOR
C
C--
C
      DIMENSION TN(3),TP(3)
C
      DO 1000 I=1,3
1000  TP(I)=TN(I)
      RETURN
      END
C
CODE FOR SDIFV
      SUBROUTINE SDIFV(TM,TN,TP)
C--COMPUTE THE DIFFERENCE BETWEEN TWO VECTORS
C
C  TP  OUTPUT VECTOR
C  TN  FIRST INPUT VECTOR
C  TM  SECOND INPUT VECTOR  -  SUBTRACT FROM THE FIRST
C
C--
C
      DIMENSION TM(3),TN(3),TP(3)
C
      DO 1000 I=1,3
1000  TP(I)=TN(I)-TM(I)
      RETURN
      END
C
CODE FOR SNOR
      FUNCTION SNOR(TM)
C--COMPUTE THE VECTOR NORMALISATION CONSTANT
C
C--THE RESULT IS GIVEN AS THE RETURN VALUE
C
C  TM  THE VECTOR OF ORDER 3
C
C--
      INCLUDE 'XCONST.INC'
C
      DIMENSION TM(3)
C
      SNOR=SQRT(TM(1)*TM(1)+TM(2)*TM(2)+TM(3)*TM(3))
      IF (SNOR .GE. VALUE) THEN
            SNOR = 1. / SNOR
      ELSE
            SNOR = 1
      END IF
      RETURN
      END
C
CODE FOR SETV
      SUBROUTINE SETV(TN,C)
C--SET A VECTOR
C
C--
C
      DIMENSION TN(3)
C
      DO 1000 I=1,3
1000  TN(I)=C
      RETURN
      END
C
CODE FOR SVETC
      SUBROUTINE SVETC(TN,TP,C)
C
C
      DIMENSION TN(3),TP(3)
C
      DO 1000 I=1,3
1000  TP(I)=TN(I)*C
      RETURN
      END

CODE FOR XSYSTH
      SUBROUTINE XSYSTH
c----- HNAME INSTRUCTION. NUMBERS H ATOM AFTER THE PARENT
C      HETRO ATOM

      INCLUDE 'ISTORE.INC'
c
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XOPVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DIMENSION ID(2)
#ifdef _HOL_
      DATA KHYD/4HH   /
      DATA KDET/4HD   /
#else
      DATA KHYD/'H   '/
      DATA KDET/'D   '/
#endif
c
C--SET THE TIMING
      CALL XTIME1 (2)
C--READ THE REMAINING DATA
      IF (KRDDPV(ISTORE(NFL),2).LT.0) GO TO 550
      IULN=KTYP05(ISTORE(NFL))
      LNOUT=KTYP05(ISTORE(NFL+1))
C--CLEAR THE STORE
      CALL XCSAE
      CALL XRSL
C--LOAD THE LISTS
      IF (KHUNTR (41,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL41
      CALL XLDR05 (IULN)
      IF (IERFLG.LT.0) GO TO 500
      m5 = l5
C
      LBUF=NFL
      NBUF=2
      NHB=0
      M41B=L41B
c
C----- CREATE A LIST OF BONDS TO HYDROGEN, WITH HETRO ATOM FIRST
      DO 1000 I = 1,N41B
            IAT1 = ISTORE(M5+md5*ISTORE(M41B))
            IAT2 = ISTORE(M5+md5*ISTORE(M41B+6))
            IF( (IAT1 .EQ. KHYD) .OR. (IAT1 .EQ. KDET)) THEN
                  ISTORE(NFL)=ISTORE(M41B+6)
                  ISTORE(NFL+1)=ISTORE(M41B)
                  NFL=NFL+2
                  NHB=NHB+1
            ELSE IF( (IAT2 .EQ. KHYD) .OR. (IAT2 .EQ. KDET)) THEN
                  ISTORE(NFL)=ISTORE(M41B)
                  ISTORE(NFL+1)=ISTORE(M41B+6)
                  NFL=NFL+2
                  NHB=NHB+1
            ENDIF
            M41B=M41B+MD41B
1000  CONTINUE
C
      MBUF=LBUF
      CALL SSORTI(MBUF, NHB, NBUF, 1)
C
      IAT=-1
      DO 3000, I=0,NHB-1
        IBUF1=MBUF + I*NBUF
        IAT1=ISTORE(IBUF1)
        IF (IAT .EQ. IAT1) CYCLE
        SER=STORE(1+M5+MD5*IAT1)
        SER=10.*SER+1
        STORE(1+M5+MD5*ISTORE(IBUF1+1))=SER
C
        
        DO 3500 J=I+1,NHB-1
            IBUF2=MBUF + J*NBUF
            IAT2=ISTORE(IBUF2)
            IF (IAT2 .EQ.IAT1) THEN
              SER = SER + 1
              STORE(1+M5+MD5*ISTORE(IBUF2+1))=SER
              IAT = IAT2
            ENDIF
3500    CONTINUE
3000  CONTINUE
      NEW=-1
      IF (IULN-LNOUT) 350,400,350
350   CONTINUE
      NEW=1
400   CONTINUE
C--FINAL TERMINATION MESSAGES
      IF (ISSPRT .EQ. 0) WRITE(NCWU,50) nhb
      WRITE ( CMON, 50) nhb
      CALL XPRVDU(NCVDU, 1,0)
50    FORMAT(i6,' Hydrogen atoms relabelled ')
      CALL XSTR05 (LNOUT,0,NEW)
450   CONTINUE
      CALL XOPMSG (IOPHYD,IOPEND,410)
      CALL XTIME2 (2)
      RETURN
C
500   CONTINUE
      CALL XOPMSG (IOPHYD,IOPABN,0)
      GO TO 450
550   CONTINUE
C -- COMMAND INPUT ERRORS
      CALL XOPMSG (IOPHYD,IOPCMI,0)
      GO TO 500
      END
