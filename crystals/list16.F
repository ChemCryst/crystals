C $Log: not supported by cvs2svn $
C Revision 1.19  2011/10/13 14:41:31  djw
C Add asymmetric distacne restraint
C
C Revision 1.18  2011/09/30 11:18:37  djw
C Add asymmetric vib and Uij restraints
C
C Revision 1.17  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.16  2011/02/07 16:59:07  djw
C Put IDIM09 as a parameter in ICOM09 so that we can use it to declare work space
C
C Revision 1.15  2011/02/04 17:31:10  djw
C Fix problem when no AND on DELU/SIMU
C
C Revision 1.14  2010/10/26 09:51:24  djw
C Sort out more writes to NCAWU, provide more output from EXEC directive
C
C Revision 1.13  2009/10/28 16:27:56  djw
C Add error print to .LIS as well as screen. Correct base address for parameters in DELU (was mistakenly changed in last update) list16.fpp
C
C Revision 1.12  2009/06/17 13:41:49  djw
C Fix #CHECK HI crash.  Actual error was in wrong values for idjw1 & idjw2 for DELU
C  restraint in LIST 16.  Several messages cleaned up, more diagnostics for error conditions.
C
C Revision 1.11  2006/09/25 12:31:50  djw
C Remove some output statements
C
C Revision 1.10  2006/09/25 09:53:23  djw
C Add SIMU and improve DELU commands
C
C Revision 1.9  2005/11/01 16:22:00  djw
C Improve conditioning of Normal Matrix by using a softer restraint for floating origins
C
C Revision 1.8  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2005/01/17 14:05:28  rich
C Bring new repository into line up-to-date with old. (Highlight SAME
C restraint error message).
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.6  2003/07/01 16:43:34  rich
C Change IOR intrinsics to OR, similarly: IAND -> AND, INOT -> NOT. The "I"
C prefix is for INTEGER*2 (16 bit) types only, so could overflow when fed
C data from CRYSTALS' store. The unprefixed versions take any type and return
C the same type.
C
C Revision 1.5  2003/06/27 11:53:39  rich
C
C Set appropriate bit flags in L5's REF key depending on the types of
C restraint being created. Used later for CIF generation.
C
C Revision 1.4  2003/06/24 12:48:38  rich
C
C RIC: The implementation of the SAME restraint. The first group on the card is the 'target'
C all following groups are mapped onto it (in order specified) and the distances and
C angles restrained - using the connectivity of the first group.
C
C The first two arguments are the e.s.d for bond length restraints and the e.s.d
C for angle restraints. Groups are seperated by the word 'AND'.
C I.E:
C
C SAME 0.01, 0.1 FOR RESI(1) AND RESI(2)
C   maps all atoms in resi(1) onto all the atoms in resi(2) - note that
C   although this shorthand is appealing, the order of resi(1) and resi(2)
C   must be identical in List 5, although the residues may interpenetrate.
C
C SAME 0.01 , 0.1 CONT C(17)  C(18)  H(183) H(182) H(181) AND
C CONT                 C(17)  C(18)  H(182) H(181) H(183)
C   imposes 3-fold symmetry on a single methyl group.
C
C SAME 0.01 , 0.1 CONT C(17)  C(18)  H(183) H(182) H(181) AND
C CONT                 C(17)  C(19)  H(193) H(192) H(191) AND
C CONT                 C(8)   C(9)   H(93)  H(92)  H(91) AND
C CONT                 C(8)   C(10)  H(103) H(102) H(101) AND
C CONT                 C(14)  C(15)  H(153) H(152) H(151) AND
C CONT                 C(14)  C(16)  H(163) H(162) H(161)
C   restrains six methyl groups to have the same geometry as each
C   other. Combining the last two restraints would make all the
C   methyls have 3 fold symmetry, and all be the same.
C
C Errors are generated if
C   1) the size of any of the groups on the SAME card is not the
C      same as the first group.
C   2) the element type in a group does not match the corresponding
C      element type in the first group.
C
C Warnings are printed if there are zero bonds to any of the atoms
C in the first group.
C
C The comma separating the e.s.d arguments, and the 'FOR' separating the
C e.s.d.s from the atom specifications are optional.
C The second e.s.d is optional, the default is 0.1 degrees.
C The first e.s.d is optional unless you wish to specify the second, the
C default is 0.01 Angstroms.
C
C List 41 (bonds) is loaded by the restraint generating routine, if it
C does not exist an error will occur. (By default L41 is kept up to date
C with the current model.)
C
C Revision 1.3  2003/06/19 13:22:15  rich
C
C To List 16, the directive 'REM' has been added. Anything following
C this directive is ignored, but it still stored in list 16.
C
C Revision 1.2  2001/02/26 10:28:01  richard
C RIC: Added changelog to top of file
C
C
CODE FOR XPRC16
      SUBROUTINE XPRC16
C--FORM THE RELOCATABLE VERSION OF LIST 16  -  LIST 26 ON THE DISC.
C
C--THIS ROUTINE USES AND SETS WHERE NECESSARY THE FOLLOWING VARIABLES :
C
C  LK      THE LENGTH OF THE STORED ARGUMENT DETAILS IN WORDS.
C  LK1     THE LENGTH OF THE COMPLETE ARGUMENT IN WORDS MINUS ONE.
C  LK2     THE LENGTH OF THE COMPLETE ARGUMENT PRODUCED BY THE LEXICAL
C          SCANNER. THE FORMAT OF THIS IS AS FOLLOWS :
C
C          0  THE ARGUMENT TYPE :
C
C             -1  A VARIABLE, STORED AS 'LK' WORDS OF A4 CHARACTER DATA.
C              0  A NUMBER, WHOSE VALUE IS GIVEN IN WORD 2.
C             >0  AN OPERATOR, WHOSE TYPE IS GIVEN BY THE NUMBER IN THIS
C                 LOCATION. ALLOWED VALUES ARE :
C
C                 1  +
C                 2  -
C                 3  *
C                 4  /
C                 5  **
C                 6  (
C                 7  )
C                 8  ,
C                 9  =
C
C          1  THE CHARACTER NUMBER ON THE CARD WHERE THIS ARGUMENT ENDED
C          2  THE FIRST WORD OF THE ARGUMENT. FOR A NUMBER THIS IS THE
C             VALUE, WHILE FOR THE OTHERS IT IS THE START OF OF 'LK' WOR
C             CONTAINING THE ARGUMENT IN CHARACTER FORM.
C          3  THE SECOND WORD OF THE ARGUMENT.
C
C  NWCARD  THE NUMBER OF WORDS PER CARD WHEN IT IS STORED IN A4 FORMAT.
C  LARG    THE DISC ADDRESS OF THENEXT DATA RECORD HEADER BLOCK TO
C          BE PROCESSED.
C  MARG    THE DISC ADDRESS OF THE LAST DATA RECORD HEADER BLOCK
C          LOOKED AT BY 'KLDNLR'.
C  MDARG   THE NUMBER OF WORDS PER ARGUMENT, EQUAL TO 'LK2'.
C  NARG    THE NUMBER OF ARGUMENTS CURRENTLY IN CORE, EQUAL TO 'ME'.
C  MA      THE DISC ADDRESS OF THE NEXT DATA RECORD HEADER BLOCK TO
C          BE PROCESSED BY THE PRINT ROUTINE 'XPCLNN'.
C  MB      THE DISC ADDRESS OF THE LAST DATA RECORD HEADER BLOCK
C          PROCESSED BY THE PRINT ROUTINE 'XPCLNN'.
C  MC      THE NUMBER OF CARDS PRINTED MINUS ONE.
C  MD      THE ADDRESS IN CORE OF THE CURRENT SET OF ARGUMENTS.
C  ME      THE NUMBER OF ARGUMENTS ON THE CURRENT CARD.
C  MF      THE ADDRESS IN CORE OF THE CURREN ARGUMENT.
C  MG      THE FUNCTION OF THIS CARD, IN THE RANGE 1 TO N.
C
C  MQ      THE ADDRESS IN CORE AT WHICH ATOM AND PARAMETER HEADER BLOCKS
C          ARE SET UP.
C
C--THE COMMON BLOCK 'XLST26' CONTROLS THE OUTPUT OF DATA TO
C  THE DISC. THE VARIABLES ARE USED AS FOLLOWS :
C
C  L26D    THE ADDRESS OF THE LAST DATA RECORD OUTPUT TO THE DISC.
C  M26D    THE ADDRESS OF THE NEXT DATA RECORD TO BE OUTPUT.
C  MD26D   THE ADDRESS OF THE FIRST DATA RECORD OUTPUT FOR THIS LIST.
C  N26D    THE CURRENT LENGTH OF THE LIST ON DISC.
C
C  L26IR   THIS GROUP OF VARIABLES CONTROL THE INTERDEPENDENCIES
C          RECORD.
C
C  L26CB   THIS GROUP OF VARIABLES CONTROL THE DATA RECORD USED TO
C          HOLD THE CONTROL BLOCK 'XCNTRL' ON DISC. THE RECORD
C          ASSOCIATED WITH THIS SET OF POINTERS IS -101.
C          ONLY THE VARIABLES FROM 'LCG' TO 'NCS' ARE OUTPUT TO THE
C          DISC, AS 'LC' IS DETERMINED DYNAMICALLY AT EXECUTION TIME.
C
C  L26CA   THIS GROUP OF VARIABLES CONTROLS THE DATA RECORD THAT
C          CONTAINS GENERATED CODE ON THE DISC. THE RECORD
C          ASSOCIATED WITH THIS SET OF POINTERS IS -102.
C
C--THE COMMON BLOCK 'XCNTRL' CONTROLS THE FORMAT OF THE
C  INFORMATION OUTPUT TO THE DISC. WHILE THE LIST IS STILL IN
C  CORE, THE VARIABLES HAVE THE FOLLOWING SIGNIFICANCE :
C
C  LC      BASE ADDRESS OF THE WORK STACK, WHICH HOLDS CONSTANTS
C          AND VARIABLES GENERATED BY THE CODE.
C          THIS VARIABLE SET UP DYNAMICALLY BOTH DURING SYNTAX
C          ANALYSIS AND DURING EXECUTION, AND IS THUS NOT OUTPUT TO
C          DISC.
C  ISTAT2  THIS IS A PRINT CONTROL FLAG :
C
C          -1  PRINT THE CARD IMAGES AS THEY ARE PROCESSED.
C           0  NO PRINTING.
C          +1  PRINT THE CARD IMAGES AND THE GENERATED CODE.
C
C--THE REMAINING 12 WORDS OF THIS COMMON BLOCK ARE OUTPUT TO THE
C  DISC AND DEFINE THE LOCATIONS AND LENGTH OF THE REMAINING BLOCKS
C  ASSOCIATED WITH THIS INSTRUCTION. IN CORE THE FORMAT OF THIS CONTROL
C  BLOCK IS :
C
C  LCG   ADDRESS IN CORE OF THE HEADER BLOCK FOR THE GENERAL CHAIN.
C        FOR OUTPUT PRODUCED BY THE PARSE ROUTINES, THIS CHAIN CONTAINS
C        ONLY INSTRUCTIONS OR CODE. IN OTHER CASES THE CONTENTS
C        OF THE CHAIN ARE DEFINED BY THE FUNCTION OF THE ROUTINE
C        THAT SET IT UP.
C        (ON THE DISC, THIS VARIABLE IS STORED RELATIVE TO 'LCG',
C        THAT IS AS ZERO).
C  MCG   CURRENT ADDRESS IN CORE OF THE NEXT FREE WORD FOR THE GENERAL,
C        PARAMETER HEADER AND CONSTANT CHAINS. THESE CHAINS MOVE UP THE
C        STORE AND MUST UPDATE 'MCG' AS THEY DO SO.
C  MDCG  CURRENT ADDRESS IN CORE OF THE LAST GENERAL (OR INSTRUCTION)
C        BLOCK INSERTED.
C  NCG   NOT DEFINED.
C        (ON THE DISC, THIS VARIABLE IS SET TO THE TOTAL LENGTH
C        OF ALL THE CHAINS FORMED AT THE BOTTOM OF CORE  -  THE
C        GENERAL, PARAMETER AND CONSTANT CHAINS).
C
C  LCA   ADDRESS IN CORE OF THE FIRST BLOCK ON THE PARAMETER HEADER
C        BLOCK CHAIN.
C        (ON THE DISC, THIS VARIABLE IS STORED WITH ITS ADDRESS
C        SET RELATIVE TO 'LCG').
C  MCA   USED TO PROCESS THE PARAMETER HEADER BLOCK CHAIN.
C  MDCA  USED TO PROCESS THE PARAMETER HEADER BLOCK CHAIN.
C  NCA   NUMBER OF PARAMETER HEADER BLOCKS ON THE CHAIN.
C
C  LCS   ADDRESS IN CORE OF THE CONSTANT AND WORK STACK HEADER BLOCK.
C        (ON THE DISC, THIS VARIABLE IS STORED WITH ITS ADDRESS
C        SET RELATIVE TO 'LCG').
C  MCS   CURRENT ADDRESS OF THE LAST BLOCK INSERTED ON THE CONSTANT
C        CHAIN. THIS MUST BE UPDATED WHEN A NEW BLOCK IS ADDED.
C  MDCS  NEXT FREE ADDRESS IN THE WORK STACK. THIS STACK STARTS AT
C        'LC' AND COMES DOWN THE STORE.
C        (THIS PARAMETER SHOULD BE UPDATED WHENEVER SPACE IS
C        ALLOCATED IN THE WORK STACK).
C
C--DURING ALL OPERATIONS EXCEPT PARSING BY 'KPARSE', THE NEXT FREE
C  LOCATION IS STORED IN 'MCG' AND THE LAST FREE LOCATION IS HELD IN 'LF
C
C--FORMAT OF THE GENERAL CHAIN HEADER BLOCK IS :
C
C  0  ADDRESS OF THE FIRST BLOCK ON THE CHAIN REL. TO 'LCG' OR 'NOWT'.
C  1  TYPE OF OPERATION DESCRIBED BY THIS HEADER BLOCK AND ALL THE
C     OTHER HEADER BLOCKS DEFINED BY THE CONTROL BLOCK.
C  2  NOT DEFINED  -  FOR RESTRAINTS MAY BE A WORK STACK ADDRESS REL.
C                     TO 'LC'..
C  3  NOT DEFINED  -  FOR RESTRAINTS THE WEIGHT.
C  4  NOT DEFINED  -  FOR RESTRAINTS THE INPUT OR OBSERVED VALUE.
C  5  The index of the restraint in the user list `list 16` starting from zero
C
C--THE FORMAT OF THE INSTRUCTION BLOCKS ON THE CHAIN IS :
C
C  0  ADDRESS OF THE NEXT BLOCK RELATIVE TO 'LCG' OR 'NOWT'.
C  1  FUNCTION OF THIS BLOCK.
C  2  ADDRESS IN THE WORK STACK RELATIVE TO 'LC'  -  OPERAND 1.
C  3  ADDRESS IN THE WORK STACK RELATIVE TO 'LC'  -  OPERAND 2.
C  4  ADDRESS IN THE WORK STACK RELATIVE TO 'LC'  -  THE RESULT.
C
C--THE TERMS IN WORDS 2, 3 AND 4 ARE THOSE SET UP BY THE PARSE ROUTINES,
C  AND THE ADDRESSES ARE CONVERTED TO ABSOLUTE VALUES BY 'KLOADR' WHEN
C  THE INFORMATION IS READ BACK FROM THE DISC.
C  THE FORMAT OF THE BLOCK BEYOND WORD 4 IS NOT DEFINED, AND THESE
C  LOCATIONS MAY BE USED AS REQUIRED.
C
C--THE PARAMETER HEADER BLOCKS ARE DIVIDED INTO THOSE FOR ATOMS
C  AND THOSE FOR OVERALL PARAMETERS. THE FORMAT OF THE FORMER IS
C  AS FOLLOWS :
C
C  0   ADDR. OF NEXT HEADER BLOCK REL. TO LCG OR 'NOWT'
C  1   TYPE OF HEADER BLOCK :
C         0  HEADER BLOCK FOR ONE ATOM
C      1024  HEADER BLOCK FOR THE FIRST ATOM OF AN 'UNTIL' SEQUENCE
C  2   ATOM TYPE
C  3   ATOM SERIAL
C  4   NOT USED
C  5   NUMBER OF PARAMETERS
C  6   ADDR. OF FIRST PARAMETER ENTRY REL. TO 'LCG'
C  7   S
C  8   L
C  9   T(X)
C  10  T(Y)
C  11  T(Z)
C  12  ADDR. OF THIS ATOM IN LIST 5 (NOT SET HERE)
C  13  ADDR. OF THIS ATOM IN LIST 12 (NOT SET HERE)
C  14  NOT USED
C  15  ADDR. OF GENERATED PARAMETERS IN WORK STACK REL. TO 'LC'
C  16  ADDR. OF PARAMETERS TO BE USED IN WORK STACK REL. TO 'LC'
C
C--FOR EACH PARAMETER :
C
C  0   LINK TO NEXT PARAMETER REL. TO 'LCG' OR 'NOWT'.
C  1   REL. ADDR. IN LIST 5 (U[ISO]=4, FOR EXAMPLE). 
c                           Bad example: 4 is now a flag
C  2   PARTIAL DERIVATIVE WHEN CALCULATED.
C  .
C
C--THE INFORMATION FOR EACH OVERALL PARAMETER ALSO CONSISTS OF A HEADER
C  WITH THE SPECIFIED PARAMETER GIVEN AS THE COORDINATE ON THE CHAIN AT
C  WORD 6.
C
C  0   ADDR. OF NEXT HEADER BLOCK REL. TO 'LCG' OR 'NOWT'.
C  1   TYPE :
C      1  OVERALL PARAMETER
C      2  LAYER SCALE
C      3  ELEMENT SCALE
C  2   THE POSITION OF THE PARAMETER IN ITS GROUP
C  3   0.0
C  4   NOT USED
C  5   THE NUMBER OF PARAMETERS ON THE CHAIN GIVEN AT WORD 6.
C  6   ADDRESS OF THE PARAMETER CHAIN REL. TO 'LCG' (STARTS AT WORD 7).
C  7   'NOWT'  LINK TO THE NEXT PARAMETER ON THE CHAIN
C  8   THE POSITION OF THE PARAMETER IN ITS GROUP (STARTING FROM 1).
C  9   NOT USED
C  10  'NOWT'
C  11  'NOWT'
C  12  ADDR. OF THE GROUP CONTAINING THIS PARAMETER IN LIST 5 ('NOWT')
C  13  ADDR. OF THE GROUP CONTAINING THIS PARAMETER IN LIST 12 ('NOWT'
C  14  NOT USED
C  15  ADDR. OF THE PARAMETER IN THE WORK STACK REL. TO 'LC'
C  16  ADDR. OF THE SPACE TO BE USED IN THE WORK STACK REL. TO 'LC'
C
C--THE FORMAT OF THE CONSTANT AND WORK STACK HEADER IS :
C
C  0  ADDRESS OF THE NEXT CONSTANT OR WORK STACK HEADER RELATIVE
C     TO 'LCG' OR 'NOWT'.
C  1  LENGTH OF THIS BLOCK (=6)
C  2  ADDRESS AT WHICH THE WORK STACK BEGINS REL. TO 'LC' OR 'NOWT'
C  3  NUMBER OF WORDS REQUIRED FOR THE WORK STACK.
C  4  ADDRESS OF THE FIRST CONSTANT BLOCK ON THE CONSTANT CHAIN REL. TO
C     'LCG' OR 'NOWT'.
C  5  NUMBER OF CONSTANTS ON THE CONSTANT CHAIN.
C
C--THE FORMAT OF THE CONSTANT CHAIN IS :
C
C  0  ADDRESS OF THE NEXT CONSTANT BLOCK RELATIVE TO 'LCG' OR 'NOWT'
C  1  ADDRESS OF THIS CONSTANT IN THE WORK STACK RELATIVE TO 'LC'.
C  2  THE VALUE TO BE PLACED IN THE WORK STACK.
C
C--
C----- COMMAND FILE SWITCHES (MG)
C
C   1.DEFINE         2.RESTRAIN       3.DISTANCES      4.ANGLES
C   5.VIBRATIONS     6.COMPILER       7.EXECUTION      8.NO
C   9.FUNCTION      10.U(IJ)'S       11.TERM          12.EQUATE
C  13.PLANAR        14.SUM           15.FORM          16.AVERAGE
C  17.LIMIT         18.ENERGY        19.ORIGIN        20.REM
C  21.SAME          22.DELU          23.SIMU          24.A-VIB
C  25.A-U(IJ)'S     26. A-DIST       27.UXZBAR        28.UYZBAR
C  29.UZZBAR        30. UPERP        31.UPERP2        32.ULIJ          
C  33.UALIGN        34.URIGU         35.UPLANE        36.UXXQIV        
C  37.UXYQIV        38.UXZQIV        39.UYYQIV        40.UYZQIV        
C  41.UZZQIV        42.UEIG          43.UQISO         44.UVOL
C  45.UEQIV         46.UTLS
C
C----- ISTORE (LCG+1) OPERATIONS 
c      Note that some correspond to several MG values.
C      1  DEFINE    2  RESTRAIN  3  DISTANCE 4  mean D
C      5  diff D    6  ANGLE     7  mean A   8  diff D
C      9  VIBRATION 10 EXECUTION 11 NOLIST   12 UIJ
C      13 EQUATE    14 PLANAR    15 SUM      16 FORM
C      17 AVERAGE   18 LIMIT     19 ENERGY   20 ORIGIN
C Hmmm.
C      21 REM       22 SAME      23 DELU     24 SIMU 
C      21 UXZBAR    22 UYZBAR    23 UZZBAR   24 UPERP
C      25 UPERP2    26 UALIGN    27 URIGU    28 ULIJ
C      29 UPLANE    30 UXXQIV    31 UXYQIV   32 UXZQIV   
C      33 UYYQIV    34 UYZQIV    35 UZZQIV   36 UEIG
C      37 UQISO     38 UVOL      39 UEQIV    40 UTLS
C
C Don't forget to chage coperation in preset.F !!
C
      INCLUDE 'ICOM05.INC'
      INCLUDE 'ICOM12.INC'
      INCLUDE 'ICOM26.INC'
      INCLUDE 'ISTORE.INC'
C
      DIMENSION IEQU(10)
      DIMENSION INMD(4)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCNTRL.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XLST26.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XFLAGS.INC'
C
      CHARACTER *32 CATOM1, CATOM2, CATOM3

      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (Z,MZ)
      INCLUDE 'QLST05.INC'
      INCLUDE 'QLST12.INC'
      INCLUDE 'QLST26.INC'
C
C
      DATA IVERSN /421/
C
#ifdef _HOL_
      DATA IEQU(1)/4HDIST /,IEQU(2)/4HANGL /,IEQU(3)/4HFROM /
      DATA IEQU(4)/4HTO   /,IEQU(5)/4HFOR  /,IEQU(6)/4HAND  /
      DATA INMD(1)/4Hst   /,INMD(2)/4Hnd   /,INMD(3)/4Hrd   /,
     1     INMD(4)/4Hth   /
#else
      DATA IEQU(1)/'DIST'/,IEQU(2)/'ANGL'/,IEQU(3)/'FROM'/
      DATA IEQU(4)/'TO  '/,IEQU(5)/'FOR '/,IEQU(6)/'AND '/
      DATA INMD(1)/'st  '/,INMD(2)/'nd  '/,INMD(3)/'rd  '/,
     1     INMD(4)/'th  '/
#endif
C
C--SET THE TIMING FUNCTION
      CALL XTIME1(2)
C----- SET PRINTING OFF
      ISTAT2 = 0
      INCLUDE 'IDIM26.INC'
C--READ THE REMAINDER OF THE INPUT DATA
      IF (  KRDDPV ( ICOM26 , IDIM26 )  .LT.  0 ) GO TO 9910
C--RESET THE CORE LIMITS
      KA=NFL
      CALL XRSL
      NFL=KA
C--SET UP THE OUTPUT LIST
      KE=26
      CALL XFCOLS(KE)
C--SET UP THE REQUIRED LISTS FOR THE PARSING ROUTINES
      CALL XLSV
      IF ( IERFLG .LT. 0 ) GO TO 9900
C NOW A PARAMETER      INCLUDE 'IDIM05.INC'
cC--INDICATE THAT LIST 5 IS NOT IN CORE
c      DO 1050 I=1,IDIM05
c      ICOM05(I)=NOWT
c1050  CONTINUE
C Load list 5 into core (allows checking during processing).
       CALL XFAL05
       IF(IERFLG .LT. 0) GOTO 9900
       
C - Clear all the bits that restraints could possibly set.
      IMASK = NOT ( OR ( KBREFB(4), KBREFB(6) ))
      DO I = 0, N5-1
          ISTORE(L5+MD5*I+15) = AND ( ISTORE(L5+MD5*I+15), IMASK )
      END DO

C Grab some space for three atom list vectors (for SAME restraint).
       MDATVC = 3
       LATVC = KSTALL (N5*MDATVC)
C Load list 41 into core (for SAME restraint).
       CALL XFAL41
      INCLUDE 'IDIM12.INC'
C--INDICATE THAT LIST 12 IS NOT IN CORE
      DO 1100 I=1,IDIM12
      ICOM12(I)=NOWT
1100  CONTINUE
      irestraintcpt=-1
C--SET THE INPUT LIST TYPE
      KD=16
C----- INDICATE LIST 17 NOT YET USED
      L17USD = 0
1120  CONTINUE
C--SET UP THE INPUT LIST FOR PROCESSING
      CALL XLDLST(-KD,ISTORE(NFL),1,0)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--INITIALISE THE LEXICAL SCANNER
      CALL XILEXP(KD,ISTORE(NFL))
C--SET THE INITIAL 'ABORT' LIMIT
      ABORT=0.5
C--SET THE ERROR COUNT TO ZERO
      LEF=0
C
C--FETCH THE NEXT RECORD PROCESSED BY THE LEXICAL SCANNER
1150  CONTINUE
      IDWZAP = 0
      IF(KLDNLR(IDWZAP))5950,1200,1150
C--INITIALISE THE CONTROL VARIABLES
1200  CONTINUE
      CALL XSETCC
C--RECORD THE NUMBER OF ERRORS SO FAR
      LSTLEF=LEF
      MZ=0      
c----- indicate a normal directive
      iasym = 0
      irestraintcpt=irestraintcpt+1
      istore(lcg+5)=irestraintcpt ! store the index of the restraint
C--JUMP ON THE FUNCTION OF THE CARD
      GOTO(1300,1350,1500,1800,1850,2050,2100,2150,2200,2250,
     2     2300,2450,4050,4550,5400,5650,5660,7000,7200,1150,
     3     1810,1810,1810,1851,2251,1510,2258,2259,2257,2255,
     4     2256,2260,2261,2262,2263,2264,2265,2266,2267,2268,
     5     2269,2270,2271,2272,2273,2274,1250)MG
1250  CONTINUE
      CALL XOPMSG (IOPL16, IOPINT, 0)
      GOTO 9900
C
C--'DEFINE' CARD  -  RESET MO AND MP
1300  CONTINUE
      ISTORE(LCG+1)=1
      IF(KFMDEF(KD))5850,5700,5850
C
C--'RESTRAIN' CARD
1350  CONTINUE
      ISTORE(LCG+1)=2
      IF(KRCI(LN))5850,1450,1400
1400  CONTINUE
      CALL XCFE
      GOTO 5850
C--PRODUCE THE CODE
1450  CONTINUE
      IF(KPARSE(LN))5850,5700,5850
C
C--'DISTANCE' CARD
1500  CONTINUE
      ISTORE(LCG+1)=3
      goto 1520
1510  continue
c     asymmetric distance. Dont allow MEAN or DIFFERENCE
      istore(lcg+1) = -3
      iasym = 1
1520  continue
      K=1 ! one connector TO
1550  CONTINUE
      L=3 ! 3 parameters
      M=5 ! address
      I=KRCI(LN)  ! Check for normal, mean, or difference format.
      IF(I)5850,1700,1650
1650  CONTINUE    ! A Diff or Mean distance.
c     check if asymmetric restraint - cannot use with mean or diff
      if (iasym .eq. 0) then
       ISTORE(LCG+1)=ISTORE(LCG+1)+I
       I=1
      else
       goto 5850
      endif
1700  CONTINUE
      J=KGCAS(K,L,M,1)
      IF(J)5850,5850,1750
1750  CONTINUE
      MDCS=MDCS-I*J
      ISTORE(LCG+2)=MDCS
      GOTO 5700
C
C--'ANGLE' CARD
1800  CONTINUE
      ISTORE(LCG+1)=6
      K=2
      GOTO 1550

C
C--'SAME', 'DELU' or SIMU CARD
1810  CONTINUE
cdjw sep06
c The same syntax can be used for SAME, DELU and SIMU, except that there
c is no need for a second atom list for the adps
c
C This restraint is going to generate a lot of distance and
C angle constraints.
C The syntax is SAME At1 At2 At3 At4 and At5 At6 At7 At8 and ... etc
C The 1,2 connectivity matrix for At1-4 is computed. The corresponding
C distances in At5-8 and At9-12 etc are restrained.
C Sim. for the 1,3 connectivity and Angles.
C
C We need to know in advance how many atoms are in each group. We need
C to check at this time whether the number match (essential) and
C whether the element types match (warn).
C
C      OME = ME ! Save the current lexical pointers.
C      OMF = MF ! Not used
C
      IF (MG .EQ. 21) THEN
            IDJW = 1
      ELSE IF (MG .EQ. 22) THEN
            IDJW = 2
      ELSE IF (MG .EQ. 23) THEN
            IDJW = 3
      ELSE
      WRITE(CMON,'(A)') 'MG MIS-SET'
           CALL XPRVDU(NCVDU,1,0)
      ENDIF
        DISTW = 0.01
        ANGLW = 0.1
        DELUW = 0.01
        SIMUW = 0.04
C
      I = KSYNUM(Z)
      IF (I.GT.0) GOTO 2700
      IF (I .EQ. 0 ) THEN
        ME=ME-1
        MF=MF+LK2
        IF (MG .EQ. 21) THEN
          DISTW = Z       ! The weight for distance restraints.
        ELSE IF (MG .EQ. 22) THEN
          DELUW = Z       ! The weight for delu restraints.
        ELSE IF (MG .EQ. 23) THEN
          SIMUW = Z       ! The weight for simu restraints.
        END IF
        IF(KOP(8).LT.0) THEN   ! CHECK FOR OPTIONAL ',' SIGN
           WRITE(CMON,'(A)') 'End of SAME directive found too soon.'
           CALL XPRVDU(NCVDU,1,0)
           CALL XCFE    ! End of card found.
           GOTO 5850
        END IF
        I = KSYNUM(Z)
        IF (I.GT.0) THEN
           WRITE(CMON,'(A)') 'Operator found instead of number.'
           CALL XPRVDU(NCVDU,1,0)
           GOTO 2700
        END IF
        IF (I.EQ.0) THEN
          ME=ME-1
          MF=MF+LK2
          ANGLW = Z       ! The weight for angle restraints.
        END IF
      END IF

      IF ( ( DISTW.LE.0.0 ) .OR. ( ANGLW.LE.0.0 ) ) THEN
        CALL XPCLNN(LN)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,1815)
C        WRITE(NCAWU,1815)
        WRITE ( CMON ,1815)
        CALL XPRVDU(NCVDU, 1,0)
1815    FORMAT(' Negative or zero e.s.d.')
        LEF=LEF+1
        GOTO 5850
      END IF

      IF(ISTORE(MF).LT.0)THEN   ! Remove optional 'FOR' argument.
        IF(KCOMP(1,ISTORE(MF+2),IEQU(5),1,1).GT.0)THEN
          ME=ME-1    ! UPDATE THE POINTERS AFTER A 'FOR'
          MF=MF+LK2
        END IF
      END IF

C Scan the whole line, work out number of groups, number of atoms, and
C check that the number of atoms is constant across groups. Also check
C that the element type is equivalent for the same index in each group.
C Also fill in the include/exclude vector (LATVC) for KDIST4.
      NATOMS = 0
      JATOMS = 0
      NGROUP = 1
      IATD = LFL - 10*N5
      JATD = IATD
      CALL XFILL (-1, ISTORE(LATVC), N5*MDATVC) ! Exclude all by default.

      DO WHILE (.TRUE.)
        IF ( ME .LE. 0 ) EXIT
        I = KCOMP (1, ISTORE(MF+2), IEQU(6), 1,1) ! CHECK FOR 'AND'
        IF ( I .GT. 0 ) THEN    ! IT IS AN 'AND'
          IF ( NGROUP .GT. 1 ) THEN   ! It is not the first group.
            IF ( NATOMS .NE. JATOMS ) THEN  ! Check number atoms matches first group.
              WRITE (CMON,'(A)') 'A group is different size from first'
              if (issprt.eq.0) write(ncwu,'(a)') trim(CMON(1))
              CALL XPRVDU(NCVDU,1,0)
              GOTO 5850
            END IF
          END IF
          NATOMS = JATOMS ! Store the number of atoms in a group.
          JATOMS = 0
          NGROUP = NGROUP + 1
          ME = ME - 1
          MF = MF + LK2
          CYCLE
        END IF
        MS=KATOMU(IRCZAP)
        IF ( MS .LE. 0 ) THEN
          WRITE (CMON,'(A)') 'Error reading atom from SAME directive.'
          CALL XPRVDU(NCVDU,1,0)
          if (issprt.eq.0) write(ncwu,'(a)') trim(CMON(1))
          GOTO 5850
        END IF
        INDATM = ( M5A - L5 ) / MD5
        DO J = 0 , N5A-1
          IF ( NGROUP .EQ. 1 ) THEN   ! It is the first group.
C Fill in the distance/angle include vectors for this atom.
            ISTORE(LATVC+(J+INDATM*MDATVC)) = 0
            ISTORE(LATVC+(J+INDATM*MDATVC)+1) = 0
            ISTORE(LATVC+(J+INDATM*MDATVC)+2) = 0
          ELSE  ! It is another group.
C Check types match.
            IF ( ISTORE(M5A+J*MD5) .NE.
     1           ISTORE(L5+MD5*ISTORE(JATD+(NGROUP-1)*NATOMS)) ) THEN
              IATI = JATOMS + 1 + J
              IATD = MIN(4,MOD(IATI,10))
              CALL CATSTR(STORE(M5A+J*MD5),STORE(M5A+J*MD5+1),1,1,0,0,0,
     2        CATOM1,LATOM1)
              CALL CATSTR (STORE(L5+MD5*ISTORE(JATD+(NGROUP-1)*NATOMS)),
     1        STORE(L5+MD5*ISTORE(JATD+(NGROUP-1)*NATOMS)+1),1,1,0,0,0,
     2        CATOM2, LATOM2)
              LATOM1 = MIN(10, LATOM1)
              WRITE(CMON,'(A,I4,A3,A,I4,A3,A,/,4A)')
     1         'SAME restraint error: the ',
     1         IATI,INMD(IATD),'atom in the 1st and ',NGROUP,
     1         INMD(MIN(4,MOD(NGROUP,10))),'fragments',
     1         'have different element types: ',CATOM1(1:LATOM1),
     1         ' and ', CATOM2(1:LATOM2)
              CALL OUTCOL(9)
              if (issprt.eq.0) write(ncwu,'(a)') trim(CMON(1))
              if (issprt.eq.0) write(ncwu,'(a)') trim(cmon(2))
              CALL XPRVDU(NCVDU,2,0)
              CALL OUTCOL(1)
              GOTO 5850
            END IF
          END IF
C Store this result.
          ISTORE(JATD) = INDATM+J
C Set the relevant REF bit.
          ISTORE(M5A+J*MD5+15) = OR ( ISTORE(M5A+J*MD5+15), KBREFB(4) )
          JATD = JATD - 1
        END DO
        JATOMS = JATOMS + N5A
      END DO
c
c
CDJW-AUG06
c      write(cmon,'(i5,a,2i5)')  ngroup, ' Groups', natoms, jatoms
c      call xprvdu(ncvdu,1,0)

      IF ((MG .EQ.21) .AND. ( NGROUP .LE. 1 )) THEN
        WRITE (CMON,'(A)') 'Only one group given on SAME card.'
        if (issprt.eq.0) write(ncwu,'(a)') trim(CMON(1))
        CALL XPRVDU(NCVDU,1,0)
        GOTO 5850
      ELSE IF (((MG .EQ.22) .or.(mg.eq.23))
     1  .AND. ( NGROUP .LE. 0 )) THEN
        WRITE (CMON,'(A)') '{I Not enough atoms for DELU/SIMU'
        if (issprt.eq.0) write(ncwu,'(a)') 
     1    cmon(1)(3:len_trim(cmon(1)))
        CALL XPRVDU(NCVDU,1,0)
        GOTO 5850
      END IF
        IF ((ngroup .gt. 1) .and. ( NATOMS .NE. JATOMS )) THEN
         WRITE (CMON,'(A)')'{E Last group different size from first.'
         if (issprt.eq.0) write(ncwu,'(a)') 
     1     cmon(1)(3:len_trim(cmon(1)))
         CALL XPRVDU(NCVDU,1,0)
         GOTO 5850
        END IF
c
C Get the distances and angles. One at a time.
      M5A=L5
      MATVCA = LATVC
      JATVC = 1
      JFNVC = -1
      JT = 12 ! Number of words per returned distance

      MAINLOOP: DO I=1,N5

        IF ( I .GT. 1 ) THEN
          M5A=M5A+MD5A
          MFNVCA = MFNVCA + MDFNVC
          MATVCA = MATVCA + MDATVC
        END IF
        IF (ISTORE(MATVCA).LE.-1) CYCLE MAINLOOP ! CAN WE USE THIS ATOM ?
        M5=L5  ! Find each bond twice.
        MATVC = LATVC

        NFLORIG = NFL           ! SAVE THE NEXT FREE ADDRESS
        NFLBAS = NFL + 10*N5*JT ! Keep well clear of the retraint chains.
        NFL = NFLBAS            ! Temp change NFL.

        K = KDIST4( JS, JT, JATVC, 0)

        NFL = NFLORIG       ! RESET NFL 

        IF ( K .LT. 0 ) THEN
           WRITE (CMON,'(A)')'{E "KDIST4" returned an error.'
           CALL XPRVDU(NCVDU,1,0)
           if (issprt.eq.0) then
             write(ncwu,'(a)') cmon(1)(3:len_trim(cmon(1)))
           end if
           GOTO 5850
        ELSE IF ( K .EQ. 0 ) THEN
           CALL CATSTR(STORE(M5A),STORE(M5A+1),1,1,0,0,0,
     2     CATOM1,LATOM1)
           IF ( MG .EQ. 21) THEN
           WRITE (CMON,'(3A)')'{E SAME restraint warning: Atom ',
     2      CATOM1(1:LATOM1), ' has no bonded contacts.'
           ELSE
           WRITE (CMON,'(3A)')'{E DELU/SIMU restraint warning: Atom ',
     2      CATOM1(1:LATOM1), ' has no bonded contacts.'
           END IF
           if (issprt.eq.0) then
             write(ncwu,'(a)') cmon(1)(3:len_trim(cmon(1)))
          end if
          CALL XPRVDU(NCVDU,1,0)
          CYCLE MAINLOOP
        END IF

C There is a stack at NFLBAS of all the bonded contacts around the
C atom at M5A.

C Find the pivot atom (M5A) in the first group.
        IND1 = ( M5A - L5 ) / MD5
        DO K = 1,NATOMS
          INDC = ISTORE(JATD+K+(NGROUP-1)*NATOMS)
          IF ( INDC .EQ. IND1 ) THEN
             IND1 = - K
             EXIT
          END IF
        END DO
cdjwfeb11 delu and simu can have more than one argument string
        IF (( IND1 .GE. 0 ) .and. (mg .eq. 21))  THEN
          WRITE (CMON,'(A,i5,a)')'Programming error [1]',
     1    mg,' in XPRC16.'
          if (issprt.eq.0) write(ncwu,'(a)') trim(CMON(1))
          CALL XPRVDU(NCVDU,1,0)  
          GOTO 5850
        END IF
        IND1 = -IND1 ! This are now index into the JATD vector.


        DISTLOOP: DO J = NFLBAS, JS-JT, JT

          L=ISTORE(J)  ! Get the address in L5 of this atom.
CDJW DEBUGGING
          if (istat2 .eq. 1) then
           IF ( L .GE. M5A ) THEN
             CALL CATSTR(STORE(M5A),STORE(M5A+1),1,1,0,0,0,
     1       CATOM1,LATOM1)
             CALL CATSTR (STORE(L), STORE(L+1),
     1       ISTORE(J+2), ISTORE(J+3), ISTORE(J+4), ISTORE(J+5),
     2       ISTORE(J+6), CATOM2, LATOM2)
             LATOM1 = MIN(10, LATOM1)
             WRITE ( CMON ,2804) CATOM1(1:LATOM1),STORE(J+10),
     1       CATOM2(1:25)
             CALL XPRVDU(NCVDU, 1,0)
2804         FORMAT ( 6x, A,' ',F6.3,'A from ',A)
             IF (ISSPRT.EQ.0) WRITE(NCWU,'(A)') trim(CMON(1))
             WRITE(NCAWU,'(A)') trim(CMON(1))
           END IF
          endif
CDJW DEBUGGING

C Find the second atom in the first group.
          IND2 = ( L - L5 ) / MD5
          DO K = 1,NATOMS
            INDC = ISTORE(JATD+K+(NGROUP-1)*NATOMS)
            IF ( INDC .EQ. IND2 ) THEN
               IND2 = - K
               EXIT
            END IF
          END DO
cdjwfeb11 delu and simu can have more than one argument string
        IF (( IND2 .GE. 0 ) .and. (mg .eq. 21))  THEN
          WRITE (CMON,'(A,i5,a)')'Programming error [2]',
     1    mg,' in XPRC16.'
            if (issprt.eq.0) write(ncwu,'(a)') trim(CMON(1))
            CALL XPRVDU(NCVDU,1,0)  
            GOTO 5850
          END IF
          IND2 = -IND2 ! groups vectors at JATD.
          IF ( L .GE. M5A ) THEN
C
            IF (MG .EQ. 21) THEN
C             SAME
              idjw1=3      !3 parameters starting at 5 (x)
              idjw2=5
cdjwSep2011 - should this be =4 for mean?
              ISTORE(LCG+1)=5                             ! Mean
              STORE(LCG+3)=1./(DISTW*DISTW)  ! Weight (1/variance)
            ELSE if (MG .eq. 22) THEN
C             DELU
              idjw1=9      !9 parameters starting at 5 (X) 
              idjw2=5
              ISTORE(LCG+1)=9                             ! Vibration
              STORE(LCG+3)=1./(DELUW*DELUW)  ! Weight (1/variance)
            ELSE IF (MG .EQ. 23) THEN
C             SIMU
              idjw1=6      !6 parameters starting at 8 (U11)
              idjw2=8
              ISTORE(LCG+1)=12                            ! U[IJ]
              STORE(LCG+3)=1./(SIMUW*SIMUW)  ! Weight (1/variance)
            ENDIF
C
            STORE(LCG+4)=0.0    ! Target (difference).
C The first group's atom1:
            MQ=MCG ! Next free word (we'll store atom header here)
            CALL XFILL(NOWT,ISTORE(MQ),17)
            ISTORE(MQ+1) = 0    ! Length of entry
            ISTORE(MQ+2) = ISTORE(M5A)    ! Type
            ISTORE(MQ+3) = ISTORE(M5A+1)  ! Serial
            ISTORE(MQ+5) = 0    ! Number of parameters
            ISTORE(MQ+7) = 1    ! S
            ISTORE(MQ+8) = 1    ! L
            ISTORE(MQ+9) = 0    ! T
            ISTORE(MQ+10) = 0   ! T
            ISTORE(MQ+11) = 0   ! T
            MS = MCG + 18 ! Next free address.
            MDCG=MCG ! Last added parameter
            IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
            ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
            MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
            ISTORE(MCA)=NOWT
            IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
C The first group's atom2:
            MQ=MCG ! Next free word (we'll store atom header here)
            CALL XFILL(NOWT,ISTORE(MQ),17)
            ISTORE(MQ+1) = 0    ! Length of entry
            ISTORE(MQ+2) = ISTORE(L)    ! Type
            ISTORE(MQ+3) = ISTORE(L+1)  ! Serial
            ISTORE(MQ+5) = 0    ! Number of parameters
            CALL XMOVEI(ISTORE(J+2),ISTORE(MQ+7),5)
            MS = MCG + 18 ! Next free address.
            MDCG=MCG ! Last added parameter
            IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
            ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
            MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
            ISTORE(MCA)=NOWT
            IDUM=KPARIN(MQ,idjw1,idjw2,LFL)

            DO K = 0,NGROUP-2
              M5P = L5 + MD5 * ISTORE(JATD+IND1+K*NATOMS)
              M5Q = L5 + MD5 * ISTORE(JATD+IND2+K*NATOMS)
CDJW - DEBUGGING
              if(istat2 .eq.1) then
               write(cmon,'(a,i5)') ' Processing group ',K+1
               CALL XPRVDU(NCVDU,1,0)
               if (issprt.eq.0) WRITE(NCWU,'(A)') trim(CMON(1))
               WRITE(NCAWU,'(A)') trim(CMON(1))
               CALL CATSTR(STORE(M5P),STORE(M5P+1),1,1,0,0,0,
     1         CATOM1,LATOM1)
               CALL CATSTR (STORE(M5Q), STORE(M5Q+1),
     1         ISTORE(J+2), ISTORE(J+3), ISTORE(J+4), ISTORE(J+5),
     2         ISTORE(J+6), CATOM2, LATOM2)
               LATOM1 = MIN(10, LATOM1)
               WRITE(CMON,2804)CATOM1(1:LATOM1),STORE(J+10),
     2         CATOM2(1:25)
               CALL XPRVDU(NCVDU,1,0)
               if (issprt .eq.0) WRITE(NCWU,'(A)') trim(CMON(1))
               WRITE(NCAWU,'(A)') trim(CMON(1))
              endif
CDJW - DEBUGGING
              MQ=MCG ! Next free word (we'll store atom1 header here)
              CALL XFILL(NOWT,ISTORE(MQ),17)
              ISTORE(MQ+1) = 0    ! Length of entry
              ISTORE(MQ+2) = ISTORE(M5P)    ! Type
              ISTORE(MQ+3) = ISTORE(M5P+1)  ! Serial
              ISTORE(MQ+5) = 0    ! Number of parameters
              ISTORE(MQ+7) = 1    ! S
              ISTORE(MQ+8) = 1    ! L
              ISTORE(MQ+9) = 0    ! T
              ISTORE(MQ+10) = 0   ! T
              ISTORE(MQ+11) = 0   ! T
              MS = MCG + 18 ! Next free address.
              MDCG=MCG ! Last added parameter
              IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
              ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
              MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
              ISTORE(MCA)=NOWT
              IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
              MQ=MCG ! Next free word (we'll store atom2 header here)
              CALL XFILL(NOWT,ISTORE(MQ),17)
              ISTORE(MQ+1) = 0    ! Length of entry
              ISTORE(MQ+2) = ISTORE(M5Q)    ! Type
              ISTORE(MQ+3) = ISTORE(M5Q+1)  ! Serial
              ISTORE(MQ+5) = 0    ! Number of parameters
              CALL XMOVEI(ISTORE(J+2),ISTORE(MQ+7),5)
              MS = MCG + 18 ! Next free address.
              MDCG=MCG ! Last added parameter
              IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
              ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
              MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
              ISTORE(MCA)=NOWT
              IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
            END DO

            MDCS = MDCS - NGROUP
            ISTORE(LCG+2) = MDCS
            CALL XOGCTD(KE)
            CALL XSETCC
            LSTLEF=LEF   ! RECORD THE NUMBER OF ERRORS SO FAR
            MZ=0
          END IF

          IF (MG .EQ. 21) THEN
C Given this bond, loop through rest of atoms to make angles:
          ANGLELOOP: DO JAN = J+JT, JS-JT, JT

            LAN=ISTORE(JAN)
cdjwdebugging
            if (istat2 .eq. 1) then             
             CALL CATSTR(STORE(M5A),STORE(M5A+1),1,1,0,0,0,
     1       CATOM1,LATOM1)
             CALL CATSTR (STORE(L), STORE(L+1),
     1       ISTORE(J+2), ISTORE(J+3), ISTORE(J+4), ISTORE(J+5),
     2       ISTORE(J+6), CATOM2, LATOM2)
             LATOM1 = MIN(10, LATOM1)
             LATOM2 = MIN(10, LATOM2)
             CALL CATSTR (STORE(LAN), STORE(LAN+1),
     1       ISTORE(JAN+2), ISTORE(JAN+3), ISTORE(JAN+4),
     2       ISTORE(JAN+5), ISTORE(JAN+6), CATOM3, LATOM3)
             WRITE(CMON,2805)CATOM2(1:LATOM2),CATOM1(1:LATOM1),
     1       CATOM3(1:25)
             CALL XPRVDU(NCVDU, 1,0)
2805         FORMAT ( 6x, A, ' to ', A, ' to ', A)
             if(issprt.eq.0) WRITE(NCWU,'(A)') trim(CMON(1))
             WRITE(NCAWU,'(A)') trim(CMON(1))
            endif
cdjwdebugging
C Find third atom of angle in the first group of SAME.
            IND3 = ( LAN - L5 ) / MD5
            DO K = 1,NATOMS
              INDC = ISTORE(JATD+K+(NGROUP-1)*NATOMS)
              IF ( INDC .EQ. IND3 ) THEN
                 IND3 = - K
                 EXIT
              END IF
            END DO
            IF ( IND3 .GE. 0 ) THEN
              WRITE (CMON,'(A)') 'Programming error [3] in XPRC16.'
              CALL XPRVDU(NCVDU,1,0)  
            if (issprt.eq.0) write(ncwu,'(a)') trim(CMON(1))
              GOTO 5850
            END IF
            IND3 = -IND3 ! Now index into the vector at JATD

            ISTORE(LCG+1)=8     ! Mean
            STORE(LCG+3)=1./(ANGLW*ANGLW)  ! Weight (1/variance)
            STORE(LCG+4)=0.0    ! Target (difference).
C The first group's atom2:
            MQ=MCG ! Next free word (we'll store atom header here)
            CALL XFILL(NOWT,ISTORE(MQ),17)
            ISTORE(MQ+1) = 0    ! Length of entry
            ISTORE(MQ+2) = ISTORE(L)    ! Type
            ISTORE(MQ+3) = ISTORE(L+1)  ! Serial
            ISTORE(MQ+5) = 0    ! Number of parameters
            CALL XMOVEI(ISTORE(J+2),ISTORE(MQ+7),5)
            MS = MCG + 18 ! Next free address.
            MDCG=MCG ! Last added parameter
            IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
            ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
            MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
            ISTORE(MCA)=NOWT
            IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
C The first group's atom1:
            MQ=MCG ! Next free word (we'll store atom header here)
            CALL XFILL(NOWT,ISTORE(MQ),17)
            ISTORE(MQ+1) = 0    ! Length of entry
            ISTORE(MQ+2) = ISTORE(M5A)    ! Type
            ISTORE(MQ+3) = ISTORE(M5A+1)  ! Serial
            ISTORE(MQ+5) = 0    ! Number of parameters
            ISTORE(MQ+7) = 1    ! S
            ISTORE(MQ+8) = 1    ! L
            ISTORE(MQ+9) = 0    ! T
            ISTORE(MQ+10) = 0   ! T
            ISTORE(MQ+11) = 0   ! T
            MS = MCG + 18 ! Next free address.
            MDCG=MCG ! Last added parameter
            IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
            ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
            MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
            ISTORE(MCA)=NOWT
            IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
C The first group's atom3:
            MQ=MCG ! Next free word (we'll store atom header here)
            CALL XFILL(NOWT,ISTORE(MQ),17)
            ISTORE(MQ+1) = 0    ! Length of entry
            ISTORE(MQ+2) = ISTORE(LAN)    ! Type
            ISTORE(MQ+3) = ISTORE(LAN+1)  ! Serial
            ISTORE(MQ+5) = 0    ! Number of parameters
            CALL XMOVEI(ISTORE(JAN+2),ISTORE(MQ+7),5)
            MS = MCG + 18 ! Next free address.
            MDCG=MCG ! Last added parameter
            IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
            ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
            MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
            ISTORE(MCA)=NOWT
            IDUM=KPARIN(MQ,idjw1,idjw2,LFL)

            DO K = 0,NGROUP-2
              M5P = L5 + MD5 * ISTORE(JATD+IND1+K*NATOMS)
              M5Q = L5 + MD5 * ISTORE(JATD+IND2+K*NATOMS)
              M5R = L5 + MD5 * ISTORE(JATD+IND3+K*NATOMS)
cdjwdebugging
              if (istat2 .eq.1) then
               CALL CATSTR(STORE(M5P),STORE(M5P+1),1,1,0,0,0,
     1         CATOM1,LATOM1)
               LATOM1 = MIN(10, LATOM1)
               CALL CATSTR (STORE(M5Q), STORE(M5Q+1),
     1         ISTORE(J+2), ISTORE(J+3), ISTORE(J+4), ISTORE(J+5),
     2         ISTORE(J+6), CATOM2, LATOM2)
               LATOM2 = MIN(25, LATOM2)
               CALL CATSTR (STORE(M5R), STORE(M5R+1),
     1         ISTORE(J+2), ISTORE(J+3), ISTORE(J+4), ISTORE(J+5),
     2         ISTORE(J+6), CATOM3, LATOM3)
               WRITE(CMON,2805)CATOM2(1:LATOM2),CATOM1(1:LATOM1),
     1         CATOM3(1:25)
               CALL XPRVDU(NCVDU,1,0)
               WRITE(NCAWU,'(A)') trim(CMON(1))
              endif
cdjwdebugging

              MQ=MCG ! Next free word (we'll store atom2 header here)
              CALL XFILL(NOWT,ISTORE(MQ),17)
              ISTORE(MQ+1) = 0    ! Length of entry
              ISTORE(MQ+2) = ISTORE(M5Q)    ! Type
              ISTORE(MQ+3) = ISTORE(M5Q+1)  ! Serial
              ISTORE(MQ+5) = 0    ! Number of parameters
              CALL XMOVEI(ISTORE(J+2),ISTORE(MQ+7),5)
              MS = MCG + 18 ! Next free address.
              MDCG=MCG ! Last added parameter
              IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
              ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
              MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
              ISTORE(MCA)=NOWT
              IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
              MQ=MCG ! Next free word (we'll store atom1 header here)
              CALL XFILL(NOWT,ISTORE(MQ),17)
              ISTORE(MQ+1) = 0    ! Length of entry
              ISTORE(MQ+2) = ISTORE(M5P)    ! Type
              ISTORE(MQ+3) = ISTORE(M5P+1)  ! Serial
              ISTORE(MQ+5) = 0    ! Number of parameters
              ISTORE(MQ+7) = 1    ! S
              ISTORE(MQ+8) = 1    ! L
              ISTORE(MQ+9) = 0    ! T
              ISTORE(MQ+10) = 0   ! T
              ISTORE(MQ+11) = 0   ! T
              MS = MCG + 18 ! Next free address.
              MDCG=MCG ! Last added parameter
              IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
              ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
              MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
              ISTORE(MCA)=NOWT
              IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
              MQ=MCG ! Next free word (we'll store atom3 header here)
              CALL XFILL(NOWT,ISTORE(MQ),17)
              ISTORE(MQ+1) = 0    ! Length of entry
              ISTORE(MQ+2) = ISTORE(M5R)    ! Type
              ISTORE(MQ+3) = ISTORE(M5R+1)  ! Serial
              ISTORE(MQ+5) = 0    ! Number of parameters
              CALL XMOVEI(ISTORE(JAN+2),ISTORE(MQ+7),5)
              MS = MCG + 18 ! Next free address.
              MDCG=MCG ! Last added parameter
              IDUM=KPARCH(MCA,MS,LFL,NKA) ! ADD ATOM HEADER BLOCK ONTO CORRECT CHAIN
              ISTORE(MCA+6)=NOWT          ! SET UP THE PARAMETER BLOCKS
              MCA=MDCG                    ! UPDATE 'MCA' TO ITS TRUE VALUE
              ISTORE(MCA)=NOWT
              IDUM=KPARIN(MQ,idjw1,idjw2,LFL)
            END DO
            MDCS = MDCS - NGROUP
            ISTORE(LCG+2) = MDCS
            CALL XOGCTD(KE)
            CALL XSETCC
            LSTLEF=LEF   ! RECORD THE NUMBER OF ERRORS SO FAR
            MZ=0
          END DO ANGLELOOP
          ENDIF
        END DO DISTLOOP
      END DO MAINLOOP
C     END OF 'SAME' OR 'DELU' INSTRUCTION
      GOTO 1150
C
1850  CONTINUE
C--'VIBRATION' CARD
      ISTORE(LCG+1)=9
      GOTO 1852
1851  CONTINUE
C--'A-VIBRATION CARD
      ISTORE(LCG+1)=-9
1852  CONTINUE
      K=1
      L=9
      M=5
1900  CONTINUE
      IF(KRCI(LN))5850,2000,1950
1950  CONTINUE
      CALL XCFE
      GOTO 5850
2000  CONTINUE
      IF(KGCAS(K,L,M,2))5850,5850,5700
C
C--'COMPILER LISTING' CARD
2050  CONTINUE
      ISTAT2=1
      GOTO 5800
C
C--'EXECUTION LISTING' CARD
2100  CONTINUE
      ISTORE(LCG+1)=10
      GOTO 5700
C
C--'NO LISTING' CARD
2150  CONTINUE
      ISTORE(LCG+1)=11
      ISTAT2=0
      GOTO 5700
C
C--'FUNCTION' CARD
2200  CONTINUE
      IF(KFUNCT(LN))5850,5700,5850
C
C--'U(IJ)' RESTRAINT
2250  CONTINUE
C--'U(IJ)' RESTRAINT
      ISTORE(LCG+1)=12
      GOTO 2252
2251  CONTINUE
C--'A-U(IJ)' RESTRAINT
      ISTORE(LCG+1)=-12
2252  CONTINUE
      K=1
      L=6
      M=8
      GOTO 1900

C--'UXZBAR' RESTRAINT
2258  CONTINUE
      ISTORE(LCG+1)=21
      K=1    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900
C--'UYZBAR' RESTRAINT
2259  CONTINUE
      ISTORE(LCG+1)=22
      K=1    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900
C--'UZZBAR' RESTRAINT
2257  CONTINUE
      ISTORE(LCG+1)=23
      K=1    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900

C--'UPERP' RESTRAINT
2255  CONTINUE
      ISTORE(LCG+1)=24
      K=1    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900

C--'UPERP2' RESTRAINT
2256  CONTINUE
      ISTORE(LCG+1)=25
      K=2    ! Allow five 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900
	  
C--'UALIGN' RESTRAINT
2260  CONTINUE
      ISTORE(LCG+1)=26
      K=1    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900	  

C--'URIGU' RESTRAINT
2261  CONTINUE
      ISTORE(LCG+1)=27
      K=1    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900	  

C--'ULIJ' RESTRAINT
2262  CONTINUE
      ISTORE(LCG+1)=28     

C--INSERT THE DEFAULT VALUES
      STORE(LCG+4)=0.
      STORE(LCG+3)=10000.
      ESD=0.01
      J=LCG+3
C--CHECK FOR AN ARGUMENT
      IF(ME)2550,2550,22621
C--SEE IF WE CAN READ A NUMBER
22621 CONTINUE
      IF(KSYNUM(Z))22624,22622,2700
C--A NUMBER HAS BEEN READ  -  IT MUST BE THE E.S.D.
22622 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--COMPUTE  AND STORE THE WEIGHT
      STORE(J)=1./(Z*Z)
C--CHECK FOR MORE ARGUMENTS
      IF(ME)2550,2550,22623
C--CHECK THE TYPE OF THE NEXT ARGUMENT  -  IT SHOULD 'FOR'
22623 CONTINUE
      IF(ISTORE(MF))22624,2650,2700
C--IT IS AN ALPHA-NUMERIC ARGUMENT  -  CHECK IF IT IS 'FOR'
22624 CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(5),1,1))22626,22626,22625
C--UPDATE THE POINTERS AFTER A 'FOR'
22625 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE ATOMS ON THE CARD
22626  CONTINUE
      IF(KGCAS(2,6,8,0))5850,5850,5700
C-- END UEQIV


      K=2 ! one connector TO
      L=6 ! 3 parameters
      M=8 ! address
      goto 1900

C--'UPLANE' RESTRAINT
2263  CONTINUE
      ISTORE(LCG+1)=29
      K=2    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900	  

C--'UXXQIV' RESTRAINT
2264  CONTINUE
      ISTORE(LCG+1)=30
      K=5    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900

C--'UXYQIV' RESTRAINT
2265  CONTINUE
      ISTORE(LCG+1)=31
      K=5    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900	  

C--'UXZQIV' RESTRAINT
2266  CONTINUE
      ISTORE(LCG+1)=32
      K=5    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900

C--'UYYQIV' RESTRAINT
2267  CONTINUE
      ISTORE(LCG+1)=33
      K=5    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900
	  
C--'UYZQIV' RESTRAINT
2268  CONTINUE
      ISTORE(LCG+1)=34
      K=5    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900
	  
C--'UZZQIV' RESTRAINT
2269  CONTINUE
      ISTORE(LCG+1)=35
      K=5    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900

C--'UEIG' RESTRAINT
2270  CONTINUE
      ISTORE(LCG+1)=36
      K=0    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900

C--'UQISO' RESTRAINT Near isotropic restraint
2271  CONTINUE
      ISTORE(LCG+1)=37
      K=0    ! Allow one 'TO' connector
      L=6    ! Six parameters involved
      M=8    ! First parameter at slot '8' (U11).
      GOTO 1900

C--'UVOL' RESTRAINT Restraint the volume to be equal
2272  CONTINUE
      ISTORE(LCG+1)=38
C--INSERT THE DEFAULT VALUES
      STORE(LCG+4)=0.
      STORE(LCG+3)=10000.
      ESD=0.01
      J=LCG+3
C--CHECK FOR AN ARGUMENT
      IF(ME)2550,2550,22721
C--SEE IF WE CAN READ A NUMBER
22721 CONTINUE
      IF(KSYNUM(Z))22724,22722,2700
C--A NUMBER HAS BEEN READ  -  IT MUST BE THE E.S.D.
22722 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--COMPUTE  AND STORE THE WEIGHT
      STORE(J)=1./(Z*Z)
C--CHECK FOR MORE ARGUMENTS
      IF(ME)2550,2550,22723
C--CHECK THE TYPE OF THE NEXT ARGUMENT  -  IT SHOULD 'FOR'
22723 CONTINUE
      IF(ISTORE(MF))22724,2650,2700
C--IT IS AN ALPHA-NUMERIC ARGUMENT  -  CHECK IF IT IS 'FOR'
22724 CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(5),1,1))22726,22726,22725
C--UPDATE THE POINTERS AFTER A 'FOR'
22725 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE ATOMS ON THE CARD
22726  CONTINUE
      IF(KGCAS(0,6,8,0))5850,5850,5700
C-- END UVOL

C--'UEQIV' RESTRAINT Restraint Ueq to be equal
2273  CONTINUE
      ISTORE(LCG+1)=39
C--INSERT THE DEFAULT VALUES
      STORE(LCG+4)=0.
      STORE(LCG+3)=10000.
      ESD=0.01
      J=LCG+3
C--CHECK FOR AN ARGUMENT
      IF(ME)2550,2550,22731
C--SEE IF WE CAN READ A NUMBER
22731 CONTINUE
      IF(KSYNUM(Z))22734,22732,2700
C--A NUMBER HAS BEEN READ  -  IT MUST BE THE E.S.D.
22732 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--COMPUTE  AND STORE THE WEIGHT
      STORE(J)=1./(Z*Z)
C--CHECK FOR MORE ARGUMENTS
      IF(ME)2550,2550,22733
C--CHECK THE TYPE OF THE NEXT ARGUMENT  -  IT SHOULD 'FOR'
22733 CONTINUE
      IF(ISTORE(MF))22734,2650,2700
C--IT IS AN ALPHA-NUMERIC ARGUMENT  -  CHECK IF IT IS 'FOR'
22734 CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(5),1,1))22736,22736,22735
C--UPDATE THE POINTERS AFTER A 'FOR'
22735 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE ATOMS ON THE CARD
22736  CONTINUE
      IF(KGCAS(0,6,8,0))5850,5850,5700
C-- END UEQIV
      
C--'UTLS' RESTRAINT
2274  CONTINUE
      ISTORE(LCG+1)=40
C--INSERT THE DEFAULT VALUES
      STORE(LCG+4)=0.
      STORE(LCG+3)=10000.
      ESD=0.01
      J=LCG+3
C--CHECK FOR AN ARGUMENT
      IF(ME)2550,2550,22741
C--SEE IF WE CAN READ A NUMBER
22741 CONTINUE
      IF(KSYNUM(Z))22744,22742,2700
C--A NUMBER HAS BEEN READ  -  IT MUST BE THE E.S.D.
22742 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--COMPUTE  AND STORE THE WEIGHT
      STORE(J)=1./(Z*Z)
C--CHECK FOR MORE ARGUMENTS
      IF(ME)2550,2550,22743
C--CHECK THE TYPE OF THE NEXT ARGUMENT  -  IT SHOULD 'FOR'
22743 CONTINUE
      IF(ISTORE(MF))22744,2650,2700
C--IT IS AN ALPHA-NUMERIC ARGUMENT  -  CHECK IF IT IS 'FOR'
22744 CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(5),1,1))22746,22746,22745
C--UPDATE THE POINTERS AFTER A 'FOR'
22745 CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE ATOMS ON THE CARD
22746  CONTINUE
      IF(KGCAS(0,6,8,0))5850,5850,5700
C-- END UTLS
C
C--'ABORT' CARD  -  RESET THE ABORTION LIMIT FOR 'EQUATE'
2300  CONTINUE
      IF(KNUMBR(ABORT))2350,5750,2350
C--ERROR BECAUSE THERE IS NO ARGUMENT
2350  CONTINUE
      CALL XPCL16
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2400)
C      WRITE(NCAWU,2400)
      WRITE ( CMON ,2400)
      CALL XPRVDU(NCVDU, 1,0)
2400  FORMAT(' This instruction requires one numeric argument')
      GOTO 5850
C
C--AN 'EQUATE' CARD  -  SET UP THE INITIAL D/A LIMITS
2450  CONTINUE
      ESD=0.0001
      ISTORE(LCG+1)=13
      STORE(LCG+2)=ABORT
C--CHECK IF THERE IS MORE INFORMATION ON THE CARD
2500  CONTINUE
      IF(ME)2550,2550,2600
C--FORMAT ERROR IN THE DEFINITION OF A RESTRAINT
2550  CONTINUE
      CALL XCFE
      GOTO 5850
C--CHECK THE TYPE OF THE NEXT ARGUMENT
2600  CONTINUE
      IF(ISTORE(MF))2750,2650,2700
C--NUMERIC ARGUMENT  -  NOT ALLOWED
2650  CONTINUE
      CALL XILNUM(ISTORE(MF+1))
      GOTO 5850
C--AN OPERATOR  -  ALSO ILLEGAL
2700  CONTINUE
      CALL XILOP(ISTORE(MF+1))
      GOTO 5850
C--CHECK THE ALPHA-NUMERIC STRING THAT HAS BEEN GIVEN
2750  CONTINUE
      I=KCOMP(1,ISTORE(MF+2),IEQU(1),5,1)
      IF(I)4000,4000,2800
C--UPDATE THE CARD POINTERS
2800  CONTINUE
      ME=ME-1
      MF=MF+LK2
C--CHECK FOR END OF CARD
      IF(ME)2550,2550,2850
C--BRANCH ON THE INPUT DIRECTIVE
2850  CONTINUE
      J=1
      GOTO(3000,2950,2550,2550,4000,2900),I
2900  CONTINUE
      CALL XOPMSG (IOPL16, IOPINT, 0)
      GOTO 9900
C--THE WORD 'ANGLES' HAS BEEN FOUND  -  ALTER THE POINTER
2950  CONTINUE
      J=2
C--SET UP THE CONTROL BLOCK FOR THIS CONDITION
3000  CONTINUE
      ISTORE(MDCG)=MCG-LCG
      MDCG=MCG
      ISTORE(MCG)=NOWT
      ISTORE(MCG+1)=J
      MCG=MCG+6
      J=MDCG+2
      IF(MCG-LFL)3050,3050,6150
C--FETCH THE REMAINING THREE NUMBERS FOR THIS RESTRAINT
3050  CONTINUE
      IF(ISTORE(MF))3100,3200,2650
C--AN ALPHA-NUMERIC STRING  -  ONLY 'FROM' IS ALLOWED HERE
3100  CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(3),1,1))2550,2550,3150
C--UPDATE THE CARD POINTERS
3150  CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE MINIMUM COMPARISON DISTANCE
3200  CONTINUE
      IF(KNUMBR(Z))2550,3250,2550
C--CHECK FOR A COMMA
3250  CONTINUE
      IF(KOP(8))2550,3450,3300
C--NOT A COMMA  -  CHECK FOR 'TO'
3300  CONTINUE
      IF(ISTORE(MF))3350,2650,2700
C--IT IS ALPHA-NUMERIC
3350  CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(4),1,1))2550,2550,3400
C--UPDATE THE CARD POINTERS
3400  CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE MAXIMUM ALLOWED VALUE FOR THIS RESTRAINT
3450  CONTINUE
      ISTORE(J)=KACTWS(Z)
      J=J+1
      IF(KNUMBR(Z))2550,3500,2550
C--CHECK FOR THE OPTIONAL COMMA THAT CAN FOLLOW THE SECOND VALUE
3500  CONTINUE
      IF(KOP(8))2550,3550,3550
C--READ THE E.S.D. WHICH IS THE THIRD PARAMETER
3550  CONTINUE
      ISTORE(J)=KACTWS(Z)
      J=J+1
      IF(KNUMBR(Z))2550,3600,2550
C--CHECK THAT THE E.S.D. IS VALID
3600  CONTINUE
      IF(Z-ESD)3650,3650,3750
C--E.S.D. IS NOT CORRECT
3650  CONTINUE
      CALL XPCL16
      IF (ISSPRT .EQ. 0) WRITE(NCWU,3700)
C      WRITE(NCAWU,3700)
      WRITE ( CMON ,3700)
      CALL XPRVDU(NCVDU, 1,0)
3700  FORMAT(' Negative or zero e.s.d.')
      GOTO 5850
C--CONVERT TO A WEIGHT
3750  CONTINUE
      Z=1./(Z*Z)
      ISTORE(J)=KACTWS(Z)
      IF(MCG-LFL)3800,3800,6150
C--CHECK FOR END OF CARD
3800  CONTINUE
      IF(ME)2550,2550,3850
C--CHECK THE TYPE OF THE NEXT ARGUMENT
3850  CONTINUE
      IF(ISTORE(MF))3900,2500,2500
C--ALPHA-NUMERIC ARGUMENT  -  CHECK FOR 'AND'
3900  CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(6),1,1))2500,2500,3950
C--IT IS AN 'AND'  -  UPDATE THE POINTERS
3950  CONTINUE
      ME=ME-1
      MF=MF+LK2
      GOTO 2500
C--ALL THE LIMITS ARE PROCESSED  -  NOW READ THE ATOMS
4000  CONTINUE
      IF(KGCAS(-1,3,5,0))5850,5850,5700
C
C--A 'PLANAR' CARD  -  DEFINING A MEAN PLANE OF ATOMS
4050  CONTINUE
      ISTORE(LCG+1)=14
C--INSERT THE DEFAULT VALUES
      STORE(LCG+4)=0.
      STORE(LCG+3)=10000.
      ESD=0.0001
      J=LCG+3
C--CHECK FOR AN ARGUMENT
      IF(ME)2550,2550,4100
C--SEE IF WE CAN READ A NUMBER
4100  CONTINUE
      IF(KSYNUM(Z))4400,4150,2700
C--A NUMBER HAS BEEN READ  -  IT MUST BE THE E.S.D.
4150  CONTINUE
      ME=ME-1
      MF=MF+LK2
C--CHECK THE VALUE OF THE ESD
      IF(Z-ESD)3650,3650,4250
C--COMPUTE  AND STORE THE WEIGHT
4250  CONTINUE
      STORE(J)=1./(Z*Z)
C--CHECK FOR MORE ARGUMENTS
      IF(ME)2550,2550,4350
C--CHECK THE TYPE OF THE NEXT ARGUMENT  -  IT SHOULD 'FOR'
4350  CONTINUE
      IF(ISTORE(MF))4400,2650,2700
C--IT IS AN ALPHA-NUMERIC ARGUMENT  -  CHECK IF IT IS 'FOR'
4400  CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(5),1,1))4500,4500,4450
C--UPDATE THE POINTERS AFTER A 'FOR'
4450  CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE ATOMS ON THE CARD
4500  CONTINUE
      IF(KGCAS(0,3,5,0))5850,5850,5700
C
C--'SUM' DIRECTIVE FOR FLOATING ORIGINS
4550  CONTINUE
      ISTORE(LCG+1)=15
C--SET UP THE DEFAULT VALUES FOR THIS RESTRAINT
4600  CONTINUE
c      STORE(LCG+3)=1 00 00 00 00.
      STORE(LCG+3)=1 00 00.
4610  CONTINUE
      STORE(LCG+4) = 0.
      J=LCG+3
c      ESD=0.00 00 01
      ESD=0.00 01
C--CHECK FOR SOME ARGUMENTS
      IF(ME)2550,2550,4650
C--CHECK THE TYPE OF THE FIRST ARGUMENT  -  IT MAY NOT BE AN OPERATOR
4650  CONTINUE
      IF(KSYNUM(Z))4850,4700,2700
C--WE HAVE FOUND A NUMBER WHICH MUST BE THE E.S.D.
4700  CONTINUE
C      IF(Z-ESD)3650,3650,4750
cdjw Aug 2014. Just abandoning card with a brief message not useful in
c modern environment - message is not noticed and absence of restraint
c may not be recognised
      if(z .le. zero) z = esd
C--STORE THE E.S.D.
4750  CONTINUE
      STORE(J)=1./(Z*Z)
      ME=ME-1
      MF=MF+LK2
C--CHECK FOR MORE ARGUMENTS ON THE CARD
      IF(ME)2550,2550,4800
C--CHECK THE TYPE OF THE NEXT ARGUMENT
4800  CONTINUE
      IF(ISTORE(MF))4850,2650,2700
C--THIS ARGUMENT IS ALPHA-NUMERIC  -  CHECK FOR 'FOR'
4850  CONTINUE
      IF(KCOMP(1,ISTORE(MF+2),IEQU(5),1,1))4950,4950,4900
C--WE HAVE FOUND 'FOR'  -  UPDATE THE POINTERS
4900  CONTINUE
      ME=ME-1
      MF=MF+LK2
      IF(ME)2550,2550,4950
C--SET UP THE HEADER BLOCK POINTER
4950  CONTINUE
      MQ=MCG
C--CHECK FOR AN OVERALL PARAMETER
      IDWZAP = 0
      I=KOVPMU(IDWZAP)
C--CHECK THE REPLY
      IF(I)5850,5000,5150
C--NOT AN OVERALL PARAMETER  -  CHECK FOR AN ATOMIC COORDINATE
5000  CONTINUE
      J=NKA
      IDWZAP = 0
      I=KCORCH(IDWZAP)
C--AGAIN CHECK THE REPLY
      IF(I)2550,5050,5100
C--NOT AN ATOMIC PARAMETER EITHER  -  MUST BE AN ATOM WITH A PARAMETER
5050  CONTINUE
      IDWZAP = 0
      I=KATOMU(IDWZAP)
      IF(I)2550,5850,5100
C--WE HAVE FOUND ONE OR MORE ATOMS  -  CHECK FOR ONE PARAMETER AS WELL
5100  CONTINUE
      IF(ISTORE(MQ+5)-1)2550,5150,2550
C--LINK THE HEADER INTO THE CHAIN
5150  CONTINUE
      IF(KPARCH(MCA,I,LFL,J))6150,5200,5200
C--INSERT THE PARAMETERS GROUPS AS NECESSARY
5200  CONTINUE
      J=ISTORE(MCA+6)+MCA
      IF(KPARIN(MCA,1,ISTORE(J+1),LFL))6150,5250,5250
C--CHECK FOR AN 'UNTIL' SEQUENCE
5250  CONTINUE
      IF(ISTORE(MCA+1)/1024)5350,5350,5300
C--THIS IS AN 'UNTIL' SEQUENCE  -  ADJUST THE ADDRESSES
5300  CONTINUE
      J=MCA
      MCA=ISTORE(MCA)
      ISTORE(J)=ISTORE(J)-LCG
C--CHECK FOR THE END OF THE CARD
5350  CONTINUE
      IF(ME)5700,5700,4950
C
C--A 'FORM' MACRO COMMAND
5400  CONTINUE
      ISTORE(LCG+1)=16
C--SET UP THE MULTIPLIER IN THE LAST WORD OF THE CONTROL BLOCK
      STORE(LCG+4)=1.
      J=LCG+4
C--CHECK FOR AN ARGUMENT OR TWO
      IF(ME)2550,2550,5450
C--CHECK THE TYPE OF THE ARGUMENT  -  MUST DEFINE THE ATOMIC GROUP NAME
5450  CONTINUE
      IF(ISTORE(MF))5600,5500,5500
C--THIS DOES NOT DEFINE THE GROUP
5500  CONTINUE
      CALL XPCL16
      IF (ISSPRT .EQ. 0) WRITE(NCWU,5550)
C      WRITE(NCAWU,5550)
      WRITE ( CMON ,5550)
      CALL XPRVDU(NCVDU, 1,0)
5550  FORMAT(' The atomic group has not been defined')
      GOTO 5850
C--STORE THE GROUP NAME IN THE SECOND AND THIRD WORDS OF THE BLOCK
5600  CONTINUE
      N=MIN0(LK,2)
      CALL XMOVE(STORE(MF+2),STORE(LCG+2),N)
      ME=ME-1
      MF=MF+LK2
      ESD=0.001
C--CHECK FOR THE OPTIONAL COMMA
      IF(KOP(8))2550,4100,4100
C
C--'AVERAGE' DIRECTIVE  -  RESTRAIN THE PARAMETERS TO THEIR MEAN
5650  CONTINUE
      ISTORE(LCG+1)=17
      GOTO 4600
C
C
C----- 'LIMIT'  -  RESTRAIN PARAMETER SHIFTS
5660  CONTINUE
      ISTORE(LCG+1) = 18
C----- SET ESD TO .001
      STORE(LCG+3) = 1 00 00 00.
      GOTO 4610
C
C--'ENERGY' CARD
7000  CONTINUE
      ISTORE(LCG+1) = 19
C----- SET POWER FACTOR TO UNITY
      STORE (LCG+3) = 1
      K=1
      L=3
      M=5
      I=KRCI(LN)
      IF(I)5850,1700,5850
C
C--'ORIGIN' CARD
7200  CONTINUE
      ISTORE(LCG+1) = 20
      GOTO 4600


C--SUNDRY TERMINATION OPERATIONS FOR EACH CARD
5700  CONTINUE
      CALL XOGCTD(KE)
C--CHECK THE PRINT FLAG
5750  CONTINUE
      IF(ISTAT2)5900,5900,5800
5800  CONTINUE
      CALL XPCL16
      GOTO 5900
C--ERROR RETURN  -  PRINT THE CARD ABANDONED MESSAGE
5850  CONTINUE
      if (issprt.eq.0)
     1 write(ncwu,'(a)') 'Error label 5850. Card abandoned'
      write(cmon,'(a)') 'Error label 5850. Card abandoned'
      CALL XPRVDU(NCVDU, 1,0)
      CALL XPCA(ISTORE(MD+4))
      LEF=LEF+1
C--AND NOW GO BACK FOR THE NEXT CARD
5900  CONTINUE
      GOTO 1150
C
5950  CONTINUE
C---- CHECK IF WE NEED OR CAN USE LIST 17
C      IF (L23???) GOTO 5970
      IF (L17USD .NE. 0) GOTO 5970
      IF (KEXIST(17) .LE. 0) GOTO 5970
C----- WE CAN USE LIST 17 - DISABLE IT FOR NEXT TIME
      L17USD = 1
C----- SET UP INPUT LIST AND RECYCLE
      KD = 17
      GOTO 1120
C
5970  CONTINUE
C--END OF THE INPUT LIST  -  CHECK FOR ERRORS
      IF(LEF)6200,6000,6200
C--TERMINATE THE COMPILER OUTPUT SEQUENCE
6000  CONTINUE
      CALL XTCO(KE)

CRICJUN03 - store the list 5, with modified Spare values.
      CALL XSTR05 (5,-1,-1)
6020  CONTINUE


      CALL XOPMSG (IOPL16, IOPEND, IVERSN)
C--AND NOW RETURN
      CALL XTIME2(2)
      LEF=0
      LSTLEF=0
      RETURN
C
C--CORE OVERFLOW
6150  CONTINUE
      CALL XOPMSG ( IOPL16 , IOPSPC , 0 )
      GO TO 9900
C
C--ERRORS FOUND
6200  CONTINUE
      CALL XALTES ( KE , -1 )
      CALL XERHND ( IERERR )
      GO TO 9900
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPLSC , IOPLSP , KE )
      GO TO 6020
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPL16 , IOPCMI , 0 )
      GO TO 9900
      END
C
CODE FOR KRCI
      FUNCTION KRCI(IN)
C--READ THE RESTRAINTS INFORMATION
C
C--THIS LINK FIXES THE FORMAT OF THE INPUT FOR A RESTRAINT CARD
C
C--RETURN VALUES ARE :
C
C -1  AN ERROR HAS BEEN FOUND
C  0  A NORMAL RESTRAINT CARD
C  1  A 'DIFFERENCE' RESTRAINT CARD
C  2  A 'MEAN' RESTRAINT CARD
C
C--
      INCLUDE 'ISTORE.INC'
      INCLUDE 'KCHAR.INC'
C
      DIMENSION ICV(2)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XCNTRL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QCHAR.INC'
C
      EQUIVALENCE (Z,MZ)
C
C
#ifdef _HOL_
      DATA NWCV/1/, NCV/2/, LCV/1/, ICV(1)/ 4HDIFF/, ICV(2)/ 4HMEAN/
#else
      DATA NWCV/1/, NCV/2/, LCV/1/, ICV(1)/ 'DIFF'/, ICV(2)/ 'MEAN'/
#endif
      IDWZAP = IN
C--CHECK THAT THE CARD CONTAINS SOME INFORMATION
      IF(ME)1000,1000,1050
1000  CONTINUE
      CALL XCFE
      GOTO 1750
1050  CONTINUE
      KRCI=0
C--READ THE OBSERVED VALUE
      IF(KSYNUM(Z))1000,1150,1100
1100  CONTINUE
      CALL XILOP(ISTORE(MF+1))
      GOTO 1750
C--STORE THE OBSERVED VALUE
1150  CONTINUE
      STORE(LCG+4)=Z
      ME=ME-1
      MF=MF+LK2
C--CHECK FOR THE OPTIONAL ','
      IF(KOP(8))1000,1200,1200
1200  CONTINUE
      IF(KSYNUM(Z))1000,1250,1100
C--STORE THE 'WEIGHT'
1250  CONTINUE
C--CHECK THAT THE E.S.D. IS NOT ZERO
      IF(Z)1300,1300,1400
1300  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1350)
C      WRITE(NCAWU,1350)
      WRITE ( CMON ,1350)
      CALL XPRVDU(NCVDU, 1,0)
1350  FORMAT(' Negative or zero e.s.d.')
      LEF=LEF+1
      GOTO 1750
1400  CONTINUE
      STORE(LCG+3)=1./(Z*Z)
      ME=ME-1
      MF=MF+LK2
C--CHECK FOR THE '=' SIGN
      IF(KOP(9))1450,1550,1500
1450  CONTINUE
      MF=MF-LK2
1500  CONTINUE
      CALL XMISOP(KCHAR(9),ISTORE(MF+1))
      GOTO 1750
C--BEGIN SEARCHING  FOR THE 'DIFFERENCE' FUNCTION
1550  CONTINUE
      IF(ME)1000,1000,1600
1600  CONTINUE
      IF(ISTORE(MF))1650,1800,1800
C--CHECK AGAINST THE LIST
1650  CONTINUE
      I = KCOMP(NWCV, ISTORE(MF+2), ICV, NCV, LCV)
      IF(I)1800,1800,1700
1700  CONTINUE
      ME=ME-1
      MF=MF+LK2
      KRCI=I
      IF(ME)1000,1000,1800
1750  CONTINUE
      KRCI=-1
1800  CONTINUE
      RETURN
      END
C
CODE FOR KGCAS
      FUNCTION KGCAS(IN,IM,IL,KBFLAG)
C--GENERATE THE RESTRAINED ATOM STACK
C
C  IN  CONNECTOR CONTROL FLAG :
C
C      >0  THE NUMBER OF 'TO' CONNECTORS EXPECTED FOR EACH INDIVIDUAL
C          RESTRAINT  -  BONDS AND ANGLES ARE FOUND THIS WAY
C          IN = 1  THE RESTRAINT REQUIRES A BOND TO BE DEFINED.
C          IN = 2  THE RESTRAINT REQUIRES AN ANGLE TO BE DEFINED.
C      <1  MINUS THE NUMBER OF 'WITH' CONNECTORS ALLOWED BETWEEN
C          SUCCESSIVE GROUPS OF ATOMS. IN THIS CASE, THE GROUPS OF
C          ATOMS MAY BE DEFINED USING 'UNTIL'.
C          EACH GROUP OF ATOMS THAT IS PRECEDED BY 'WITH' HAS 2048
C          ADDED TO WORD 1 OF THE FIRST ATOM HEADER BLOCK IN THE GROUP.
C
C  IM  THE NUMBER OF PARAMETERS TO PROVIDE SLOTS FOR
C  IL  NUMBER OF THE FIRST PARAMETER TO INCLUDE
C      ('TYPE' IS 1, 'X' 5, ETC.)
C  KBFLAG:
C      0 = Not a distance restraint.
C      1 = Dist restraint, set relevant bit of REF parameter in L5.
C
C--RETURNS SET EQUAL TO THE NUMBER OF RESTRAINTS UNLESS THERE IS
C  AN ERROR
C
C--
      INCLUDE 'ISTORE.INC'
C
      DIMENSION IAS(2)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XCNTRL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XFLAGS.INC'
      INCLUDE 'XLST05.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (MZ,Z)
C
C
#ifdef _HOL_
      DATA NWAS/1/, IAS(1)/ 4HTO  /, IAS(2)/ 4HWITH/
#else
      DATA NWAS/1/, IAS(1)/ 'TO  '/, IAS(2)/ 'WITH'/
#endif
C
C--COMPUTE THE LENGTH OF EACH RESTRAINT
      NW=(3*IM+17)*(MAX0(1,IN)+1)
      LCA=NOWT
      MO=0
C--CHECK THAT THERE ARE SOME ARGUMENTS
      KA=IN
      KB=0
1000  CONTINUE
      IF(ME)1200,1200,1050
C--START ON THE NEXT GROUP OF ATOMS
1050  CONTINUE
      MP=IN
      GOTO 1500
C
C--PICK UP THE NEXT ATOM
1100  CONTINUE
      KB=0
      MP=MP-1
C--CHECK IF THERE ARE MORE ATOMS TO BE CONNECTED
      IF(MP)2000,1150,1150
C--CHECK FOR END OF CARD
1150  CONTINUE
      IF(ME)1200,1200,1250
C--RESTRAINT FORMAT ERROR
1200  CONTINUE
      CALL XCFE
      GOTO 2300
C--CHECK THE TYPE OF THE NEXT ARGUMENT
1250  CONTINUE
      IF(ISTORE(MF))1400,1300,1350
1300  CONTINUE
      CALL XILNUM(ISTORE(MF+1))
      GOTO 2300
1350  CONTINUE
      CALL XILOP(ISTORE(MF+1))
      GOTO 2300
C--SEARCH FOR THE CONNECTIVE ELEMENT
1400  CONTINUE
      IF (KCOMP (NWAS, ISTORE(MF+2), IAS(1), 1, 1)) 1200, 1200, 1450
1450  CONTINUE
      ME=ME-1
      MF=MF+LK2
      IF(ME)1200,1200,1500
C--PICK UP THE NEXT ATOM AFTER THE CONNECTOR
1500  CONTINUE
      MQ=MCG
C--CHECK THAT THERE IS ENOUGH CORE FOR THIS RESTRAINT
      IF(MQ+NW-LFL)1600,1600,1550
C--NOT ENOUGH CORE
1550  CONTINUE
      CALL XCSO(ISTORE(MF+1))
      GOTO 2300
C--READ THE ATOM(S) OFF THE CARD
1600  CONTINUE
      IDWZAP = 0
      MS=KATOMU(IDWZAP)
C--CHECK THE REPLY
      IF(MS)2300,2300,1650
C--PRESERVE THE ADDRESS OF THE FIRST ATOM AND CHECK THE LINK
1650  CONTINUE
      MDCG=MCG
      IF(ISTORE(MCG))1850,1700,1700
C--MORE THAN ONE ATOM HAS BEEN DEFINED  -  CHECK IF THIS IS ALLOWED
1700  CONTINUE
      IF(IN)1750,1750,1800
C--AN 'UNTIL' SEQUENCE THAT IS ALLOWED  -  ADJUST THE LINK ADDRESS
1750  CONTINUE
      MDCG=ISTORE(MCG)
      ISTORE(MCG)=ISTORE(MCG)-LCG
      GOTO 1850
C--ATOM DEFINITION ERROR
1800  CONTINUE
      MF=MF-LK2
      CALL XADE(ISTORE(MF+1))
      GOTO 2300
C--CHECK THAT THERE ARE NO PARAMETERS SPECIFIED
1850  CONTINUE
C If this is a DIST/ANGLE or VIB restraint, the set the relevant REF bit.
      IF ( KBFLAG .EQ. 1 ) THEN
        ISTORE(M5A+15) = OR ( ISTORE(M5A+15), KBREFB(4) )
      ELSE IF ( KBFLAG .EQ. 2 ) THEN
        ISTORE(M5A+15) = OR ( ISTORE(M5A+15), KBREFB(6) )
      END IF
      IF(ISTORE(MCG+5))1800,1900,1800
C--CHECK IF THIS IS THE FIRST ATOM
1900  CONTINUE
      ISTORE(MCG+1)=ISTORE(MCG+1)+KB
      IF(KPARCH(MCA,MS,LFL,NKA))1550,1950,1950
C--SET UP THE PARAMETER BLOCKS
1950  CONTINUE
      ISTORE(MCA+6)=NOWT
C--UPDATE 'MCA' TO ITS TRUE VALUE
      MCA=MDCG
      ISTORE(MCA)=NOWT
      IF(KPARIN(MQ,IM,IL,LFL))1550,1100,1100
C
C--END OF A CONNECTED GROUP
2000  CONTINUE
      MO=MO+1
C--LOOK FOR THE OPTIONAL ','
      IF(KOP(8))2200,2050,2050
C--NOT END OF CARD  -  CHECK THE TYPE OF THE NEXT ARGUMENT
2050  CONTINUE
      IF(ISTORE(MF))2100,1300,1350
C--ALPHA-NUMERIC  -  CHECK IF IT 'WITH'
2100  CONTINUE
      IF (KCOMP(1,ISTORE(MF+2), IAS(2), 1, 1)) 1000, 1000, 2150
C--A 'WITH' HAS BEEN FOUND
2150  CONTINUE
      KA=KA+1
      KB=2048
      ME=ME-1
      MF=MF+LK2
C--CHECK IF THIS 'WITH' IS ALLOWED
      IF(KA)1000,1000,1200
2200  CONTINUE
      KGCAS=MO
2250  CONTINUE
      RETURN
C
2300  CONTINUE
      KGCAS=-1
      GOTO 2250
      END
C
CODE FOR XCFE
      SUBROUTINE XCFE
C--RESTRAINT FORMAT ERROR
C
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      CALL XPCL16
C--CHECK IF WE CAN PRINT THE CARD POSITION
      IF(ME)1000,1000,1100
C--NO CARD POSITION
1000  CONTINUE
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1050)
C      WRITE(NCAWU,1050)
      WRITE ( CMON ,1050)
      CALL XPRVDU(NCVDU, 1,0)
1050  FORMAT(' '' RESTRAINT'' format error',A1,
     2 'at or before column', I4)
      GOTO 1150
C--PRINT THE CARD POSITION
1100  CONTINUE
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1050)IB,ISTORE(MF+1)
C      WRITE(NCAWU,1050)IB,ISTORE(MF+1)
      WRITE ( CMON ,1050)IB,ISTORE(MF+1)
      CALL XPRVDU(NCVDU, 1,0)
C--UPDATE THE ERROR COUNTER
1150  CONTINUE
      LEF=LEF+1
      RETURN
      END
C
CODE FOR XPCL16
      SUBROUTINE XPCL16
C--PRINT LIST 16  -  THIS SUBROUTINE PRINTS UP TO AND INCLUDING THE
C  PRESENT CARD.
C
C--
      INCLUDE 'XLISTI.INC'
C
      CALL XPCLNN(LN)
      RETURN
      END

c Evidence for setting Origin restraint SU to 1.0
c 7 cycles starting from the same model
c
C   0. The sum is restrained to be   439.35      with an E.S.D. of   1.0000    
C               x        y        z                  x A      y A      z A                 x        y         z
C
C Maximum     0.0000   0.0003   0.0000               0.0002   0.0056   0.0003 Reversals   20.45    48.86    30.68  
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0001   0.0000 Reversals    0.00     0.00     0.00  
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0001   0.0000 Reversals   65.91   100.00    77.27   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0000   0.0000 Reversals   81.82   100.00    88.64   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0000   0.0000 Reversals   79.55   100.00    77.27   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0000   0.0000 Reversals   78.41   100.00    54.55   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0000   0.0000 Reversals   56.82    98.86    38.64   
C
C
C   0. The sum is restrained to be   439.35      with an E.S.D. of  0.10000    
C Maximum     0.0000   0.0002   0.0000               0.0002   0.0034   0.0002 Reversals    0.00     0.00     0.00   
C Maximum     0.0000   0.0001   0.0000               0.0000   0.0013   0.0001 Reversals    0.00     0.00     0.00   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0005   0.0000 Reversals   32.95     0.00    28.41   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0002   0.0000 Reversals   27.27     0.00    19.32   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0001   0.0000 Reversals   28.41     0.00    20.45   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0000   0.0000 Reversals   36.36     0.00    26.14   
C Maximum     0.0000   0.0000   0.0000               0.0000   0.0000   0.0000 Reversals   40.91     0.00    34.09   
C
C
C   0. The sum is restrained to be   439.35      with an E.S.D. of  0.10000E-01
C Maximum    0.0000   0.0000   0.0000              0.0001   0.0001   0.0002 Reversals   0.00     0.00     0.00   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0001   0.0000 Reversals   0.00     0.00     0.00   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0001   0.0000 Reversals  77.27     0.00    81.82   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0001   0.0000 Reversals  60.23     0.00    56.82   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0001   0.0000 Reversals  37.50     0.00    32.95   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0001   0.0000 Reversals  18.18     0.00    22.73   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0001   0.0000 Reversals  12.50     0.00    13.64   
C
C
C   0. The sum is restrained to be   439.35      with an E.S.D. of  0.10000E-02
C Maximum     0.0000   0.0000   0.0000              0.0001   0.0001   0.0002 Reversals    0.00     0.00     0.00  
C Maximum     0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals    0.00     0.00     0.00  
C Maximum     0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals   78.41    60.23    89.77  
C Maximum     0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals   82.95    26.14    78.41  
C Maximum     0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals   72.73     7.95    48.86  
C Maximum     0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals   46.59     4.55    28.41  
C Maximum     0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals   38.64     1.14    19.32  
C
C
C   0. The sum is restrained to be   439.35      with an E.S.D. of  0.10000E-03
C Maximum    0.0000   0.0000   0.0000              0.0001   0.0001   0.0002 Reversals   0.00     0.00     0.00   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals   0.00     0.00     0.00   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals  80.68    76.14    87.50   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals  86.36    64.77    79.55   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals  77.27    46.59    51.14   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals  56.82    29.55    30.68   
C Maximum    0.0000   0.0000   0.0000              0.0000   0.0000   0.0000 Reversals  42.05    22.73    27.27   
C
C
C   0. The sum is restrained to be   439.35   with an E.S.D. of   1.0000 
C         The rms (shift/su)  =     0.544         The mean abs(shift/su) =     0.204
C         The rms (shift/su)  =     0.011         The mean abs(shift/su) =     0.008
C         The rms (shift/su)  =     0.005         The mean abs(shift/su) =     0.003
C         The rms (shift/su)  =     0.001         The mean abs(shift/su) =     0.001
C         The rms (shift/su)  =     0.001         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C   0. The sum is restrained to be   439.35   with an E.S.D. of  0.10000 
C         The rms (shift/su)  =     0.388         The mean abs(shift/su) =     0.145
C         The rms (shift/su)  =     0.151         The mean abs(shift/su) =     0.055
C         The rms (shift/su)  =     0.061         The mean abs(shift/su) =     0.022
C         The rms (shift/su)  =     0.024         The mean abs(shift/su) =     0.009
C         The rms (shift/su)  =     0.010         The mean abs(shift/su) =     0.004
C         The rms (shift/su)  =     0.004         The mean abs(shift/su) =     0.001
C         The rms (shift/su)  =     0.002         The mean abs(shift/su) =     0.001
C   0. The sum is restrained to be   439.35   with an E.S.D. of  0.10000E-01
C         The rms (shift/su)  =     0.022         The mean abs(shift/su) =     0.015
C         The rms (shift/su)  =     0.017         The mean abs(shift/su) =     0.007
C         The rms (shift/su)  =     0.016         The mean abs(shift/su) =     0.006
C         The rms (shift/su)  =     0.016         The mean abs(shift/su) =     0.005
C         The rms (shift/su)  =     0.016         The mean abs(shift/su) =     0.005
C         The rms (shift/su)  =     0.015         The mean abs(shift/su) =     0.005
C         The rms (shift/su)  =     0.015         The mean abs(shift/su) =     0.005
C   0. The sum is restrained to be   439.35   with an E.S.D. of  0.10000E-02
C         The rms (shift/su)  =     0.014         The mean abs(shift/su) =     0.010
C         The rms (shift/su)  =     0.003         The mean abs(shift/su) =     0.002
C         The rms (shift/su)  =     0.001         The mean abs(shift/su) =     0.001
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C   0. The sum is restrained to be   439.35   with an E.S.D. of  0.10000E-03
C         The rms (shift/su)  =     0.014         The mean abs(shift/su) =     0.010
C         The rms (shift/su)  =     0.003         The mean abs(shift/su) =     0.002
C         The rms (shift/su)  =     0.001         The mean abs(shift/su) =     0.001
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C         The rms (shift/su)  =     0.000         The mean abs(shift/su) =     0.000
C
