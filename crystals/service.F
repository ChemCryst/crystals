C $Log: not supported by cvs2svn $
C Revision 1.50  2012/07/12 08:14:24  rich
C Save CRC lookup table after it is initialised.
C
C Revision 1.49  2012/03/23 13:50:32  rich
C INW (Intel) compiler support.
C
C Revision 1.48  2012/01/04 14:31:25  rich
C Fix some uninitialized variables, and output format mistakes.
C
C Revision 1.47  2011/09/30 09:37:26  djw
C Remove diagnostic print
C
C Revision 1.46  2011/09/07 09:44:41  djw
C Change format of #SET OPENMESSAGE text so that columns line up across actions
C Add #SET CACHEMESSAGE (off/on) to inhibit caching information at termination
C Remove disc extension messages
C
C Revision 1.45  2011/03/21 13:57:22  rich
C Update files to work with gfortran compiler.
C
C Revision 1.44  2011/02/25 08:35:17  djw
C Show name of SCRIPT if it is abandoned
C
C Revision 1.43  2010/07/16 11:35:31  djw
C Enable XPCHLX to output lists 12 and 16 to the cif file.  This means carrying the I/O chanel (as NODEV)
C in XPCHLX,XPCHLH,PPCHND and XPCHUS.
C Fixed oversight in distangle for esds of H-bonds
C
C Revision 1.42  2010/06/17 15:33:52  djw
C Remove old Interactive mode header from NCAWU
C
C Revision 1.41  2010/03/04 15:12:44  djw
C Enable tracking of work
C
C Revision 1.40  2009/11/30 18:01:20  djw
C Enable path names with spaces, eg "My Files"
C
C Revision 1.39  2009/07/23 14:16:37  rich
C Removed some Fortran90-isms, so that g77 can still cope.
C
C Revision 1.38  2009/03/03 09:59:27  djw
C Save old CAMERON Roman numeral code ad oldroman, introduce new Roman Numeral code based on ar2rom. This permits proper labeling on packing diagrams with lots of symmetry equivalints
C
C Revision 1.37  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:09  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:07  rich
C New CRYSTALS repository
C
C Revision 1.36  2004/08/09 11:22:12  rich
C For the Windows command line only version: re-introduce the old text
C output colour scheme.
C
C Revision 1.35  2004/02/18 12:08:23  rich
C Added option \SET TIME SLOW which prevents output of DATE and TIME strings.
C This is to be used by the new test_suite so that runs at different times
C generate no significant differences. Also supresses timing functions, as
C for \SET TIME OFF.
C
C Revision 1.34  2003/08/05 11:11:12  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.33  2003/07/09 16:58:49  rich
C Shrink header printed on startup (less blank lines).
C
C Revision 1.32  2003/06/30 17:58:38  rich
C On abandoning script due to CRYSTALS error, or due to a script syntax error,
C print out the script source file line number where the failure occurred.
C
C Revision 1.31  2003/06/09 11:38:19  rich
C Add bond calculation as a recognised error generating routine in XOPMSG.
C
C Revision 1.30  2003/05/07 12:18:56  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.29  2002/02/27 19:40:10  ckp2
C RIC: Increased input line length to 256 chars. HOWEVER - only a few modules know about
C this extra length. In general the program continues to ignore everything beyond
C column 80. The "system" commands (OPEN, RELEASE, etc.) do know about the extra length
C and can take extra long filenames as a result. The script processor also knows: lines
C in script files, the script input buffer and text output may now run up to 256 chars.
C RIC: THe system commands respect double-quotes around arguments, so that filenames can be
C given which contain spaces.
C
C Revision 1.28  2002/02/20 14:35:39  ckp2
C Don't remove spaces from files names when generating names.
C
C Revision 1.27  2001/12/18 13:08:36  ckp2
C Code for getting and setting errors from List 39.
C
C Revision 1.26  2001/09/28 10:25:56  ckp2
C New function KCRCHK( IPTR,ILEN ) returns a 16-bit CRC checksum for the
C data of length ILEN at store address IPTR.
C Not used yet, but I will use it to generate a unique 16-bit number representing
C the labels, serials and part numbers of list 5 so that List 41 can tell if
C they've changed.
C
C Revision 1.25  2001/06/18 12:24:34  richard
C Missing comma in format statement
C
C Revision 1.24  2001/03/08 14:38:36  richard
C Two new colours for the rainbow.
C
C Revision 1.23  2001/02/06 15:35:09  CKP2
C Atom-only output in PCH
C
C Revision 1.22  2000/10/31 15:20:21  ckp2
C Added log entries
C
CODE FOR XERHDR
      SUBROUTINE XERHDR(IN)
C--PRINT THE ERROR MESSAGE HEADING THAT PRECEDES EACH ERROR MESSAGE
C
C--
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1000)
      ENDIF
1000  FORMAT(//1X,17('  ERROR')/17('  ERROR')/17(' ERROR ')/)
C--CHECK THE TYPE OF ERROR
      IF(IN)1050,1150,1250
C--SYSTEM TYPE ERROR, PRODUCED BY A PROGRAMMING MISTAKE
1050  CONTINUE
      CALL OUTCOL(3)
      WRITE ( CMON,1100)
      CALL XPRVDU(NCEROR, 3,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1100)
      WRITE(NCAWU,1100)
1100  FORMAT(/,
     1 ' Programming error, not a user error.',
     2 ' Consult a CRYSTALS expert '/)
      CALL OUTCOL(1)
      GOTO 1350
C--USER ERROR
1150  CONTINUE
      CALL OUTCOL(3)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1200)
      WRITE ( CMON,1200)
      CALL XPRVDU(NCEROR, 2,0)
      WRITE(NCAWU,1200)
1200  FORMAT(' User error ', / 'Check your',
     2 ' input data and your job control cards and parameters')
      CALL OUTCOL(1)
      GOTO 1350
C--UNDETERMINED TYPE OF ERROR
1250  CONTINUE
      CALL OUTCOL(3)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1300)
      WRITE ( CMON,1300)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE(NCAWU,1300)
1300  FORMAT(' Probably a user error -',
     2 ' Possibly a programming error')
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1200)
      ENDIF
      CALL OUTCOL(1)
C--AND NOW RETURN
1350  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1400)
      ENDIF
      WRITE(NCAWU,1400)
1400  FORMAT(1X)
      RETURN
      END
C
C
CODE FOR XOPMSG
      SUBROUTINE XOPMSG ( IFAC , IMSG , IPARAM )
C -- A SUBROUTINE TO OUTPUT VARIOUS COMMON MESSAGES
C
C -- PARAMETERS :-
C
C    IFAC    FACILITY NUMBER
C    IMSG    MESSAGE NUMBER.
C
C    IPARAM  A PARANETER THAT MAY BE REQUIRED FOR THE MESSAGE
C
C -- FACILITY NUMBERS :-
C
C      1      CRYSTALS
C      2      PURGE
C      3      LP CORRECTION
C      4      SYSTEMATIC
C      5      MERGE
C      6      ABSORPTION
C      7      CORRECTION DATA
C      8      REFORMING
C      9      FOURIER
C     10      CALCULATION OF WEIGHTS
C     11      AGREEMENT ANALYSIS
C     12      TEMPERATURE FACTOR CONVERSION
C     13      MODIFICATION ( OF LIST N )
C     14      LIST EDITING ( 'EDIT' )
C     15      HYDROGEN PLACING
C     16      INPUT ( OF LIST N )
C     17      CREATION ( OF LIST N )
C     18      LEXICAL SCANNER
C     19      LIST 12 PROCESSING
C     20      CREATION OF LIST 26
C     21      RESTRAINTS CHECKING
C     22      RESTRAINTS PROCESSING
C     23      SORT
C     24      REORDERING OF LIST 6
C     25      SFLS CALCULATIONS
C     26      PUNCHING ( OF LIST N )
C     27      DISTANCES AND ANGLES
C     28      TORSION ANGLES CALCULATION
C     29      CALCULATION OF PRINCIPAL AXES
C     30      T.L.S. CALCULATION
C     31      MOLECULAR AXES CALCULATIONS
C     32      PUBLICATION PRINTING ( OF LIST N )
C     33      REGULARISATION OF GROUPS
C     34      SIMULATE
C     35      TRIAL MAP CALCULATION
C     36      SLANT FOURIER CALCULATION
C     37      FOREIGN PROGRAM LINK
C     38      DIFABS
C     39      PARAMETER DISPLAY
C     40      MATRIX INVERSION
C     41      GENERATION OF NEW PARAMETERS
C     42      PRINTING OF LIST TYPE 22
C     43      SCRIPT PROCESSOR
C     44      SPACE GROUP INPUT
C     47      BOND CALCULATION
C
C -- MESSAGE NUMBERS :-
C
C    NUMBER            MESSAGE                    ERROR STATUS
C    ------            -------                    ----- ------
C      1      'ABANDONED'
C      2      'COMMAND INPUT ERROR'                  ERROR
C      3      'ENDS    VERSION' -
C      4      'ERROR DURING ' - ' PROCESSING '       ERROR
C      5      'INSUFFICIENT SPACE'                   ERROR
C      6      - 'OF LIST ' - ' ABANDONED'
C      7      'INTERNAL CONSISTENCY CHECK ERROR'     PROG. ERROR
C      8      - 'OF LIST ' - ' ENDS'
C      9      'VERSION' -
C
C
      CHARACTER*30 NAME
      PARAMETER ( NFAC = 47 )
C
      CHARACTER*30 FACNAM(NFAC)
      DIMENSION    IFACLN(NFAC)
      INCLUDE 'TLISTC.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      DATA FACNAM(1)  / 'CRYSTALS                      ' /
      DATA FACNAM(2)  / 'Disc purging                  ' /
      DATA FACNAM(3)  / 'LP correction                 ' /
      DATA FACNAM(4)  / 'Systematic absences           ' /
      DATA FACNAM(5)  / 'Data merging                  ' /
      DATA FACNAM(6)  / 'Absorption correction         ' /
      DATA FACNAM(7)  / 'Correction data               ' /
      DATA FACNAM(8)  / 'Reforming                     ' /
      DATA FACNAM(9)  / 'Fourier calculation           ' /
      DATA FACNAM(10) / 'Calculation of the weights    ' /
      DATA FACNAM(11) / 'Agreement analysis            ' /
      DATA FACNAM(12) / 'Temperature factor conversion ' /
      DATA FACNAM(13) / 'Modification                  ' /
      DATA FACNAM(14) / 'List editing                  ' /
      DATA FACNAM(15) / 'Hydrogen placing              ' /
      DATA FACNAM(16) / 'Input                         ' /
      DATA FACNAM(17) / 'Creation                      ' /
      DATA FACNAM(18) / 'Lexical scanner               ' /
      DATA FACNAM(19) / 'Creation of new list 22       ' /
      DATA FACNAM(20) / 'Creation of new list 26       ' /
      DATA FACNAM(21) / 'Restraints checking           ' /
      DATA FACNAM(22) / 'Restraints processing         ' /
      DATA FACNAM(23) / 'Sort                          ' /
      DATA FACNAM(24) / 'Reordering of list 6          ' /
      DATA FACNAM(25) / 'SFLS calculation              ' /
      DATA FACNAM(26) / 'Punching                      ' /
      DATA FACNAM(27) / 'Distances and angles          ' /
      DATA FACNAM(28) / 'Torsion angles calculation    ' /
      DATA FACNAM(29) / 'Calculation of principal axes ' /
      DATA FACNAM(30) / 'T.L.S. calculation            ' /
      DATA FACNAM(31) / 'Molecular axes calculation    ' /
      DATA FACNAM(32) / 'Publication printing          ' /
      DATA FACNAM(33) / 'Regularisation of groups      ' /
      DATA FACNAM(34) / 'SIMULATE                      ' /
      DATA FACNAM(35) / 'Trial map calculation         ' /
      DATA FACNAM(36) / 'Slant fourier calculation     ' /
      DATA FACNAM(37) / 'Foreign program link          ' /
      DATA FACNAM(38) / 'DIFABS                        ' /
      DATA FACNAM(39) / 'Parameter display             ' /
      DATA FACNAM(40) / 'Matrix inversion              ' /
      DATA FACNAM(41) / 'Generation of new parameters  ' /
      DATA FACNAM(42) / 'Printing of list type 22      ' /
      DATA FACNAM(43) / 'CRYSTALS script processor     ' /
      DATA FACNAM(44) / 'Space Group Symbol input      ' /
      DATA FACNAM(45) / 'Quick startup                 ' /
      DATA FACNAM(46) / 'Molecular formula input       ' /
      DATA FACNAM(47) / 'Bond calculation              ' /
C
C -- SET LENGTHS OF FACILITY NAMES
      DATA IFACLN(1)  /  8 /      ,    IFACLN(2)  / 12 /
      DATA IFACLN(3)  / 13 /      ,    IFACLN(4)  / 19 /
      DATA IFACLN(5)  / 12 /      ,    IFACLN(6)  / 21 /
      DATA IFACLN(7)  / 15 /      ,    IFACLN(8)  /  9 /
      DATA IFACLN(9)  / 19 /      ,    IFACLN(10) / 26 /
      DATA IFACLN(11) / 18 /      ,    IFACLN(12) / 29 /
      DATA IFACLN(13) / 12 /      ,    IFACLN(14) / 12 /
      DATA IFACLN(15) / 16 /      ,    IFACLN(16) /  5 /
      DATA IFACLN(17) /  8 /      ,    IFACLN(18) / 15 /
      DATA IFACLN(19) / 23 /      ,    IFACLN(20) / 23 /
      DATA IFACLN(21) / 19 /      ,    IFACLN(22) / 21 /
      DATA IFACLN(23) /  4 /      ,    IFACLN(24) / 20 /
      DATA IFACLN(25) / 17 /      ,    IFACLN(26) /  8 /
      DATA IFACLN(27) / 20 /      ,    IFACLN(28) / 26 /
      DATA IFACLN(29) / 29 /      ,    IFACLN(30) / 18 /
      DATA IFACLN(31) / 26 /      ,    IFACLN(32) / 20 /
      DATA IFACLN(33) / 24 /      ,    IFACLN(34) /  8 /
      DATA IFACLN(35) / 21 /      ,    IFACLN(36) / 25 /
      DATA IFACLN(37) / 20 /      ,    IFACLN(38) /  6 /
      DATA IFACLN(39) / 17 /      ,    IFACLN(40) / 16 /
      DATA IFACLN(41) / 28 /      ,    IFACLN(42) / 24 /
      DATA IFACLN(43) / 25 /      ,    IFACLN(44) / 24 /
      DATA IFACLN(45) / 13 /      ,    IFACLN(46) / 23 /
      DATA IFACLN(47) / 16 / 
C
C -- SET NUMBER OF FACILITIES AND NUMBER OF MESSAGES
      DATA IFANUM / NFAC /
      DATA ISYMSG  / 9 /
C
C
      MSGNUM = IABS ( IMSG )
C
C -- CHECK VALID FACILTIY NUMBER
      IF ( IFAC .LE. 0 ) GO TO 9920
      IF ( IFAC .GT. IFANUM ) GO TO 9920
C
      LENGTH = IFACLN(IFAC)
      NAME = FACNAM(IFAC)
C
C -- CHECK WITHIN RANGE
C
      IF ( MSGNUM .LE. 0 ) GO TO 9910
      IF ( MSGNUM .GT. ISYMSG ) GO TO 9910
C
C----- CHECK IF WE ARE OUTPUTTING NON FATAL MESSAGES
      IF (ISSMSG .EQ. 0) THEN
          GO TO ( 1010 , 1020 , 8000 , 1040 , 1050 ,
     1    8000 , 1070 , 8000 , 8000 , 9910 ) , MSGNUM
      ELSE
      GO TO ( 1010 , 1020 , 1030 , 1040 , 1050 ,
     1 1060 , 1070 , 1080 , 1090 , 9910 ) , MSGNUM
      ENDIF
      GO TO 9910
C
1010  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1015 ) NAME(1:LENGTH)
      ENDIF
      WRITE ( CMON,1015) NAME(1:LENGTH)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1015 ) NAME(1:LENGTH)
1015  FORMAT ( 1X , A , ' abandoned' )
      GO TO 8000
C
1020  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1025 ) NAME(1:LENGTH)
      ENDIF
      WRITE ( CMON,1025) NAME(1:LENGTH)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1025 ) NAME(1:LENGTH)
1025  FORMAT ( 1X , A , ' command input error ' )
      CALL XERHND ( IERERR )
      GO TO 8000
1030  CONTINUE
      IV1 = IPARAM / 100
      IV2 = IPARAM - ( 100 * IV1 )
      IV3 = IV2 / 10
      IV4 = IV2 - ( IV3 * 10 )
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1035 ) NAME(1:LENGTH) , IV1 , IV3 , IV4
      ENDIF
      WRITE ( CMON,1035) NAME(1:LENGTH), IV1, IV2, IV3,IV4
      CALL XPRVDU(NCEROR, 2,0)
      WRITE ( NCAWU , 1035 ) NAME(1:LENGTH) , IV1 , IV3 , IV4
1035  FORMAT ( /,1X,A,' ends ' , 10X , ' Version ' , I2 , '.' , I1,I1)
      GO TO 8000
1040  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1045 ) NAME(1:LENGTH)
      ENDIF
      WRITE ( CMON,1045) NAME(1:LENGTH)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1045 ) NAME(1:LENGTH)
1045  FORMAT ( 1X , 'Error during ' , A , ' processing' )
      CALL XERHND ( IERERR )
      GO TO 8000
1050  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1055 ) NAME(1:LENGTH)
      ENDIF
      WRITE ( CMON,1055) NAME(1:LENGTH)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1055 ) NAME(1:LENGTH)
1055  FORMAT ( 1X , A , ' requires more store' )
      CALL XERHND ( IERERR )
      GO TO 8000
1060  CONTINUE
      CALL OUTCOL(3)
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1065 ) NAME(1:LENGTH) , IPARAM, CLISTS(IPARAM)
      ENDIF
      WRITE ( CMON,1065) NAME(1:LENGTH), IPARAM, CLISTS(IPARAM)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1065 ) NAME(1:LENGTH) , IPARAM, CLISTS(IPARAM)
1065  FORMAT ( 1X , A , ' of list type ' , I5 ,
     1 ' (',A,') abandoned' )
      CALL OUTCOL(1)
      GO TO 8000
1070  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1075 ) NAME(1:LENGTH)
      ENDIF
      WRITE ( CMON,1075) NAME(1:LENGTH)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1075 ) NAME(1:LENGTH)
1075  FORMAT ( 1X , A , ' -- Internal consistency check failed' )
      CALL XERHND ( IERPRG )
      GO TO 8000
1080  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1085 ) NAME(1:LENGTH) , IPARAM
      ENDIF
      WRITE ( CMON,1085) NAME(1:LENGTH), IPARAM
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1085 ) NAME(1:LENGTH) , IPARAM
1085  FORMAT ( 1X , A , ' of list type ' , I5 , ' ends' )
      GO TO 8000
1090  CONTINUE
      IV1 = IPARAM / 100
      IV2 = IPARAM - ( 100 * IV1 )
      IV3 = IV2 / 10
      IV4 = IV2 - ( IV3 * 10 )
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1095 ) NAME(1:LENGTH) , IV1 , IV3 , IV4
      ENDIF
      WRITE ( CMON,1095) NAME(1:LENGTH), IV1, IV3, IV4
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 1095 ) NAME(1:LENGTH) , IV1 , IV3 , IV4
1095  FORMAT ( 1X , A , ' version ' , I2 , '.' , I1,I1)
      GO TO 8000
C
C
8000  CONTINUE
C
      RETURN
C
9900  CONTINUE
C -- ERRORS
      GO TO 8000
9910  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9915 ) IMSG
      ENDIF
      WRITE ( CMON,9915) IMSG
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 9915 ) IMSG
9915  FORMAT ( 1X , 'Illegal message number : ' , I8 )
      CALL XERHND ( IERPRG )
      GO TO 9900
9920  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9925 ) IFAC
      ENDIF
      WRITE ( CMON,9925) IFAC
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 9925 ) IFAC
9925  FORMAT ( 1X , 'Illegal facility number : ' , I8 )
      CALL XERHND ( IERPRG )
      GO TO 9900
C
      END
C
CODE FOR XERHND
      SUBROUTINE XERHND(ICODE)
C -- GENERAL ERROR HANDLING ROUTINE FOR CRYSTALS
C --
C
C
C
C      THIS ERROR HANDLING SYSTEM WAS WRITTEN BY PAUL BETTERIDGE
C
C      THIS IS VERSION 2 OF 'XERHND' - JUNE 1983
C
C
C
C                  ERROR HANDLING IN 'CRYSTALS'
C
C      THERE ARE TWO METHODS IN USE IN CRYSTALS FOR DEALING WITH ERROR
C    CONDITIONS , WHETHER CAUSED BY AN ERROR IN THE USERS DATA/INSTRUCT-
C    IONS, OR BY INCORRECT PROGRAMMING.
C
C      THE FIRST METHOD USES THE RETURN VALUE FROM A FUNCTION TO INDIC-
C    ATE THAT AN ERROR HAS OCCURED. THIS METHOD IS APPROPRIATE IF AN
C    'ERROR' CONDITION IS NOT IN FACT AN ERROR , FOR INSTANCE IF AN
C    OPTIONAL PIECE OF DATA HAS BEEN OMITTED , OR A LIST THAT MIGHT BE
C    USED BUT IS NOT NECESSARY IS ABSENT ( E.G. 'KEXIST' ) . THIS
C    METHOD SHOULD ALSO BE USED IF THE SECOND IS NOT AVAILABLE, FOR
C    INSTANCE IF CALLING THE ERROR HANDLING ROUTINE MIGHT LEAD TO RECUR-
C    SIVE PROCEDURE CALLS. FOR THIS REASON THE BASIC DISC ROUTINES RETUR
C    A VALUE ( E.G. 'KSTORE' , 'KFETCH' )
C
C      THE SECOND METHOD USED IS TO CALL THE ROUTINE 'XERHND' WITH A
C    VALUE INDICATING THE SEVERITY OF THE ERROR. THE ERROR HANDLING
C    ROUTINE ACTS ACCORDING TO THE VALUE , DISPLAYING MESSAGES , SAVING
C    DATA IN DISC BUFFERS AND TERMINATING THE PROGRAM , AS APPROPRIATE.
C    ALL THESE FUNCTIONS ARE CONTROLLED BY VALUES IN A COMMON BLOCK SO
C    GREAT FLEXIBLITY CAN BE ACHIEVED ( 9 POSSIBLE COMBINATIONS ARE PRO-
C    VIDED, WITH DIFFERENT MEANINGS IF APPROPRIATE IN INTERACTIVE OR
C    BATCH JOBS ). ONE POSSIBLE ACTION OF 'XERHND' IS TO RETURN CONTROL
C    TO THE CALLING ROUTINE AFTER SETTING THE VALUE OF THE VARIABLE
C    'IERFLG' IN THE COMMON BLOCK 'XUNITS' NEGATIVE. BY CHECKING THIS
C    VALUE IT IS POSSIBLE FOR ROUTINES TO KNOW THAT AN ERROR HAS BEEN
C    DETECTED AND TO TERMINATE ACCORDINGLY. IN THIS WAY , CONTROL CAN
C    PASSED BACK TO THE MAIN LEVEL AND NEW COMMANDS PROCESSED. THIS
C    ALLOWS INTERACTIVE JOBS TO CONTINUE EVEN AFTER AN OPERATION HAS
C    BEEN ABANDONED IN ERROR.
C
C      IN EARLIER VERSIONS, IT WAS NECESSARY TO RECOVER FROM ERRORS
C    BY CALLING SYSTEM ROUTINES , TO PERFORM OPERATIONS LIKE UNWINDING
C    THE CALL STACK , TO RETURN CONTROL TO THE MAIN ROUTINES. THIS
C    ABILITY SHOULD NOT BE NEEDED NOW , BUT THE CODE HAS BEEN LEFT.
C
C
C
C                  THE OPERATION OF THIS ROUTINE
C
C  --  AN ERROR CODE 'ICODE' , PASSED TO THIS ROUTINE,
C      DETERMINES WHAT MESSAGE IS PRINTED, WHAT DUMPS ARE
C      PRODUCED AND WHAT STEPS ARE TAKEN TO CONTINUE THE PROGRAM OR
C      TERMINATE EXECUTION
C        IF THE SYSTEM INITIALISATION FLAG 'ISSINI' IS SET, ALL ERRORS
C      ARE TREATED AS FATAL, AND ABORT THE PROGRAM
C
C  --  ALL RESTARTABLE ERRORS SHOULD BE HANDLED BY FOLLOWING
C      NORMAL RETURNS BACK TO A SUITABLE POINT, AFTER THE ERROR FLAG
C      'IERFLG' HAS BEEN SET BY THIS ROUTINE. THIS IS A GENERAL METHOD
C      OF DEALING WITH ERROR CONDITIONS.
C
C  --  CONTROL VARIABLES USED BY THE ERROR HANDLING ROUTINES. (  THESE
C      ARE SET IN 'CRYBLK'. ) :-
C
C            DUMP FLAG               'IERDMP(ICODE)'
C            1            NO DUMP
C            2            INTERACTIVE LEVEL DUMP
C            3            BATCH LEVEL DUMP
C
C            STOP/CONTINUE FLAG      'IERCNT(ICODE)'
C            1            IMMEDIATE RETURN
C            2            ERROR FLAG SET, PROGRAM CONTINUES
C            3            PROGRAM ABORTED,
C                               WITH SYSTEM ERROR REPORT/TRACEBACK
C            4            PROGRAM ABORTED QUIETLY.
C                               NO ERROR REPORTING, TRACEBACK ETC.
C
C            MESSAGE FLAG            'IERMSG(ICODE)'
C            1            NO MESSAGE
C            2            WARNING
C            3            ERROR
C            4            SEVERE ERROR
C            5            CATASTOPHE
C            6            PROGRAMMING ERROR
C
C            MAXIMUM NUMBER OF OCCURENCES      'IERLIM(ICODE)'
C            0            INFINITE NUMBER
C            +N           THE NTH OCCURENCE WILL CAUSE TERMINATION
C
C            'ERROR FLAG SET'      'IERSTF(ICODE)'
C            -1           ERROR FLAG IS SET
C            0            ERROR FLAG IS NOT CHANGED
C
C -- THE FOLLOWING ERROR CODES ARE HANDLED BY THIS ROUTINE. THE SYMBOL
C    NAMES REFER TO VARIABLES IN THE COMMON BLOCK /XERVAL/ . THE VALUES
C    FOR EACH SYMBOL ARE SET IN BLOCK DATA 'CRYBLK' .
C
C    SYMBOL      VALUE      ACTION
C    ------      -----      ------
C
C    IERNOP        1        < NO ACTION >
C    IERSFL        2        SET ERROR FLAG ONLY
C    IERWRN        3        WARNING -- ERROR FLAG NOT SET
C    IERERR        4        ERROR
C    IERSEV        5        SEVERE ERROR
C    IERCAT        6        CATASTROPHE
C    IERPRG        7        PROGRAMMING ERROR
C    IERABO        8        ABORT PROGRAM, NO MESSAGE
C    IERUNW        9        CALL ROUTINE XERUNW TO RECOVER FROM ERROR
C
C
C            THE HIGHEST POSSIBLE ERROR CODE IS CONTROLLED BY THE VALUE
C      OF 'IERMAX' IN THE COMMON BLOCK 'XERCNT'
C
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XERCNT.INC'
      INCLUDE 'XIOBUF.INC'
cdjwfeb2011
      INCLUDE 'XSCCHK.INC'
      INCLUDE 'XMENUC.INC'
C
C -- GIVE INITIAL VALUES TO A FEW VARIABLES
      DATA I / 0 /
C
C
C -- CHECK FOR A VALID ERROR CODE
      IF ( ICODE .LE. 0 ) GO TO 9910
      IF ( ICODE .GT. IERMAX ) GO TO 9910
C -- SET ERROR FLAG IF REQUIRED
      IF ( IERSTF(ICODE) .LT. 0 ) IERFLG = -1
C -- SET INTERNAL FLAGS
      IDUMP = IERDMP(ICODE)
      ICONT = IERCNT(ICODE)
C -- SET ABORT IF SYSTEM INITIALISATION IS IN PROGRESS
      IF ( ISSINI .GT. 0 ) ICONT = 4
C -- CALL THE 'SPY'
      IF ( IERFLG .LT. 0 ) CALL XSPY ( 4 )
C -- INCREMENT COUNT FOR THIS TYPE OF ERROR
      IERCOU(ICODE) = IERCOU(ICODE) + 1
C -- APPLY LIMITS TO VARIOUS TYPES OF ERROR CODE
      IF ( IERLIM(ICODE) .LE. 0 ) GO TO 2000
      IF ( ICONT .GT. 2 ) GO TO 2000
      IF ( IERCOU(ICODE) .GE. IERLIM(ICODE) ) ICONT = 4
C
2000  CONTINUE
C
C -- PRODUCE REQUIRED MESSAGES.
      if (iermsg(icode) .gt. 1) CALL OUTCOL(9)
      GO TO ( 4100 , 4200 , 4300 , 4400 , 4500 ,
     2 4600 , 9920 ) , IERMSG(ICODE)
      GO TO 9920
C
4100  CONTINUE
      GO TO 6000
4200  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 4205 )
      ENDIF
      WRITE ( CMON,4205)
      CALL XPRVDU(NCEROR, 3,0)
      WRITE ( NCAWU , 4205 )
4205  FORMAT ( / , ' CRYSTALS - WARNING' , / )
      GO TO 6000
4300  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 4305 )
      ENDIF
      WRITE ( CMON,4305)
      CALL XPRVDU(NCEROR, 3,0)
      WRITE ( NCAWU , 4305 )
4305  FORMAT ( / , ' CRYSTALS -- ERROR' , / )
      GO TO 6000
4400  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 4405 )
      ENDIF
      WRITE ( CMON,4405)
      CALL XPRVDU(NCEROR, 3,0)
      WRITE ( NCAWU , 4405 )
4405  FORMAT ( / , ' CRYSTALS -- SEVERE ERROR' , / )
      GO TO 6000
4500  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 4505 )
      ENDIF
      WRITE ( CMON,4505)
      CALL XPRVDU(NCEROR, 3,0)
      WRITE ( NCAWU , 4505 )
4505  FORMAT ( / , ' CRYSTALS -- CATASTROPHE' , / )
      GO TO 6000
4600  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 4605 )
      ENDIF
      WRITE ( CMON,4605)
      CALL XPRVDU(NCEROR, 3,0)
      WRITE ( NCAWU , 4605 )
4605  FORMAT ( / , ' CRYSTALS -- PROGRAMMING ERROR' , / )
      GO TO 6000
C
6000  CONTINUE
c     restore normal colours
      if (iermsg(icode) .gt. 1) CALL OUTCOL(1)
C -- DUMP INFORMATION AND DISC BUFFERS IF REQUIRED. THE ROUTINE 'KDUMP'
C    IS CALLED , SO THAT NO RECURSIVE ERROR CALLS CAN OCCUR
C
      GO TO ( 6100 , 6200 , 6300 , 9920 ) , IDUMP
      GO TO 9920
C
6100  CONTINUE
      GO TO 8000
6200  CONTINUE
      ISTAT = KDUMP ( I )
      CALL XSYSDC ( 0 , 0 )
      GO TO 8000
6300  CONTINUE
      ISTAT = KDUMP ( I )
      GO TO 8000
C
8000  CONTINUE
C -- STOP PROGRAM/CONTINUE AS REQUIRED
      GO TO ( 8100 , 8200 , 8300 , 8400 , 9920 ) , ICONT
      GO TO 9920
C
8100  CONTINUE
C -- IMMEDIATE RETURN
      RETURN
8200  CONTINUE
C -- CONTINUE PROGRAM
C -- RESET FLAGS TO ENSURE CORRECT CONTINUATION
C -- UNLOAD SYSTEM REQUEST QUEUE
      IPOSRQ = 0
      NREC = 0
      CALL XRPSRQ
      IEOF = 0
C -- RESET CARD SERIAL NUMBER INCREMENT
      NS = 1
C -- IF A '#USE' FILE IS OPEN, ABANDON IT.
      IF ( IUSFLG .EQ. 2 ) THEN
C
C If in a SCRIPT, print line number to help debug.
C
        IF ( IRDSCR(IFLIND) .GT. 0 ) THEN
cdjwfeb2011
C-----  RECOVER SCRIPT NAME
        ISTAT = KSCIDN (2, 3, 'SCRIPTNAME', 1, IS, IDSCP, ISCPNM, 1)
        ISTAT = KSCSDC ( ISCPNM, CSCPNM, LENNM)
        IF (CSCPNM .NE. CLSTNM) CPRVNM = CLSTNM
        CLSTNM = CSCPNM(1:LENNM)
        WRITE(CMON,'(A,A,A,I6)')'Script ', cscpnm(1:lennm),
     1  ' abandoned at line ',IRDREC(IFLIND)
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(A)' ) trim(CMON(1))
        END IF

        CALL XFLUNW ( 3 , 2 )
      ENDIF
      RETURN

8300  CONTINUE
C -- ABORT PROGRAM WITH REPORT
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 8305 )
      ENDIF
      WRITE ( CMON,8305)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 8305 )
8305  FORMAT ( 1X , 'Program aborted' )
      CALL XFINAL ( 3 )
8400  CONTINUE
C -- ABORT PROGRAM
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 8305 )
      ENDIF
      WRITE ( CMON,8305)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 8305 )
      CALL XFINAL ( 2 )
C
9910  CONTINUE
C -- ERROR CODE GIVEN WAS ILLEGAL.
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9915 ) ICODE
      ENDIF
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 2,0)
      WRITE ( NCAWU , 9915 ) ICODE
9915  FORMAT ( / , ' An illegal error code found -- ' , I8 ,
     2 ' -- Programming error'   )
      CALL XFINAL ( 2 )
9920  CONTINUE
C -- INTERNAL ERROR
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9925 )
      ENDIF
      WRITE ( CMON,9925)
      CALL XPRVDU(NCEROR, 1,0)
      WRITE ( NCAWU , 9925 )
9925  FORMAT ( 1X , 'An illegal code has been found in ' ,
     2 'the error routine -- Programming error' )
      CALL XFINAL ( 2 )
C      STOP 'ERROR HANDLING'
      CALL GUEXIT(2020)
      END
C
C --
C
CODE FOR XERINI
      SUBROUTINE XERINI
C -- RUN TIME INITIALISATION OF ERROR HANDLING.
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XERCNT.INC'
C
C
C -- IF NOT INTERACTIVE, ONLY ONE 'ERROR' IS ALLOWED
      IF ( IQUN .NE. 1 ) IERLIM(IERERR) = 1
C
      RETURN
      END
C
C --
C
CODE FOR XEND
      SUBROUTINE XEND
C--STANDARD TERMINATION SUBROUTINE
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      IF (ISSEXP .GE. 1) THEN
       CALL XRSL
       CALL XCSAE
       CALL XMOVEI(KEYFIL(1,5), ISTORE(NFL), 4)
       CALL XRDOPN (5, ISTORE(NFL), 'export.dat', 10)
       IF (KEXIST(5) .EQ. 1) CALL XPCH5S(1)
       IF (KEXIST(12) .EQ. 1) CALL XPRTLX (12, 1,NCPU)
       IF (KEXIST(16) .EQ. 1) CALL XPRTLX (16, 1,NCPU)
       CALL XRDOPN (6, ISTORE(NFL), 'export.dat', 10)
      ENDIF
CDJW99 SET TERMINAL UNKNOWN
C       IF TERMINAL CURRENTLY VGA, SWITCH TO BLACK AND WHITE
        IF (ISSTML .EQ. 3 ) THEN
C              CALL VGACOL ( 'OFF', 'WHI', 'BLA' )
              CALL OUTCOL(5)
              WRITE ( CMON,'(80X)')
              CALL XPRVDU(NCVDU, 1,0)
              ISSTML = 0
        END IF
      CALL XFINAL ( 1 )
C -- DUMMY RETURN
      RETURN
      END
C
C --
C
CODE FOR XFINAL
      SUBROUTINE XFINAL ( ICODE )
#ifdef CRY_OSLINUX
      use iso_fortran_env, only: error_unit
#endif
C -- THIS IS THE LAST SUBROUTINE TO BE CALLED, FOR ALL CONTROLLED
C    TERMINATIONS.
C
C  'ICODE' IS A FLAG WHICH DETERMINES THE WAY IN WHICH TERMINATION WILL
C  OCCUR.
C
C            ICODE        RESULT
C            1            NORMAL END 'OK'
C            2            ERROR END ( QUIET )
C            3            ERROR END ( PRODUCES REPORTS ETC. )
C
      CHARACTER*8 RESULT(3)
      CHARACTER*1 WARNPL,ERRPL
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XERCNT.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XSTATS.INC'
      INCLUDE 'XIOBUF.INC'
      DATA RESULT(1) / 'ok      ' /
      DATA RESULT(2) / 'in error' /
      DATA RESULT(3) / 'in error' /
      DATA WARNPL / 's' / , ERRPL / 's' /
      DATA I / 0 / , J / 1 /
C
      IF ( ICODE .GT. 3 ) ICODE = 3
      IF ( ICODE .LE. 0 ) ICODE = 3
      
#ifdef CRY_OSLINUX
#ifdef __GNUC__
      if(icode/=1) then
        write(error_unit, *) ''
        write(error_unit, *) 
     1    'Crystals just crashed, here is a backtrace:'
        call backtrace
        write(error_unit, *) ''
      end if
#endif
#endif
C
C -- DISPLAY DISC EFFICIENCY STATISTICS
C
      IF ((ISSPRT .EQ. 0) .and. (ISSCSH .EQ.1)) THEN
      WRITE ( NCWU , 1105 ) IPREAD , IPWRIT , ICACHE
1105  FORMAT ( 1X , 'Physical reads ' , I10 , ' Physical writes ', I10,
     1 ' Cache hits ' , I10 )
      WRITE ( NCWU , 1115 ) NCACHE
      ENDIF
1115  FORMAT ( 1X , 'Cache hit distribution ' , 6I8 )
C
      NWARN = IERCOU(IERWRN)
      NERR = IERCOU(IERERR) + IERCOU(IERSEV) + IERCOU(IERCAT)
      IF ( NWARN .EQ. 1 ) WARNPL = ' '
      IF ( NERR .EQ. 1 ) ERRPL = ' '
C
      CALL XTIME ( IA , IB )
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1005 ) IA , IB , RESULT(ICODE) , NWARN , WARNPL ,
     2 NERR , ERRPL
      ENDIF
      WRITE ( NCAWU , 1005 ) IA , IB , RESULT(ICODE) , NWARN , WARNPL ,
     2 NERR , ERRPL
      WRITE ( CMON,1005)   IA , IB ,
     2                        RESULT(ICODE), NWARN, WARNPL, NERR, ERRPL
      CALL XPRVDU(NCVDU, 3,0)
1005  FORMAT ( // , 1X , 2A4 , ' : Job ends ' , A8 , ' with ' ,
     2 I5 , ' warning' , A1 , ' and ' , I5 , ' error' , A1 )
C
C -- FINAL CALL TO THE SPY
      CALL XSPY ( 3 )
      ISTAT = KDUMP ( I )
      CALL XTIME2 ( 0 )
C
      GO TO ( 8100 , 8200 , 8300 ) , ICODE
8100  CONTINUE
      CALL GUEXIT(0)

8200  CONTINUE
#ifdef CRY_NOGUI
      write(*,*) ' Ending in error'
#endif
#ifdef _VAX_ 
      WRITE ( NCVDU , 8305 ) J/(icode-2)
#endif
      CALL GUEXIT(1)
8300  CONTINUE
C
C VAX -- CAUSE PROG. TO CRASH TO GET TRACEBACK
C----WRITE STATEMENT IS NECESSARY TO FOOL  VAX FORTRAN OPTIMISER.
C
#ifdef CRY_NOGUI
      write(*,*) ' Ending in serious error'
#endif
#ifdef _VAX_ 
      WRITE ( NCVDU , 8305 ) J/(icode-3)
#endif
8305  FORMAT ( 1X , I10 )
C
        CALL GUEXIT(2)
      END
C
C --
C
C
CODE FOR XSYINI
      SUBROUTINE XSYINI
C
C  --  THIS SUBROUTINE PRINTS THE INITIAL MESSAGES / HEADERS FOR THE
C      MAIN  PROGRAM. THE MACHINE SPECIFIC PARTS ARE SUPPLIED FROM
C      THE COMMON BLOCK 'XSSVAL'
C
C    THE HEADING 'CRYSTALS' IN LARGE LETTERS IS OPTIONAL. IT CAN BE
C    ENABLED BY SETTING THE VARIABLE 'ISSBAN' IN COMMON BLOCK
C    'XSSVAL' TO 1.
      CHARACTER*8 CTIME , CDATE
C
      INCLUDE 'TSSCHR.INC'
C
C
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'XIOBUF.INC'
C
C
C
      CALL XTIMER ( CTIME )
      CALL XDATER ( CDATE )
C
C----- SET SCREEN ATRIBUTES UNDER DOS - BOLD
      IF (ISSTML .EQ. 3) THEN
C      CALL VGACOL ( 'BOL', 'BLU', 'BLA' )
      CALL OUTCOL(1)
      WRITE ( NCVDU, '(/,79A1)') (CHAR(42),I=1,79)
      ENDIF
C
      IF ( ISSBAN .GT. 0 ) THEN
      IF (ISSPRT .EQ. 0) THEN
        WRITE(NCWU,1000)
1000  FORMAT(//,
     2 '   CCCCCCCC   RRRRRRRRRR  YY      YY   SSSSSSSS   TTTTTTTTTT',
     3 '   AAAAAAAA   LL           SSSSSSSS ',/,
     4 '  CCCCCCCCCC  RRRRRRRRRR   YY    YY   SSSSSSSSSS  TTTTTTTTTT',
     5 '  AAAAAAAAAA  LL          SSSSSSSSSS',/,
     6 '  CC          RR      RR    YY  YY    SS              TT    ',
     7 '  AA      AA  LL          SS        ',/,
     8 '  CC          RR      RR     YYYY     SS              TT    ',
     9 '  AA      AA  LL          SS        ')
        WRITE(NCWU,1050)
1050  FORMAT(
     2 '  CC          RR      RR      YY      SS              TT    ',
     3 '  AA      AA  LL          SS        ',/,
     4 '  CC          RRRRRRRRRR      YY      SS              TT    ',
     5 '  AA      AA  LL          SS        ',/,
     6 '  CC          RRRRRRRRRR      YY      SSSSSSSSSS      TT    ',
     7 '  AA      AA  LL          SSSSSSSSSS',/,
     8 '  CC          RRRR            YY      SSSSSSSSSS      TT    ',
     9 '  AAAAAAAAAA  LL          SSSSSSSSSS')
        WRITE(NCWU,1100)
1100  FORMAT(
     2 '  CC          RR RR           YY              SS      TT    ',
     3 '  AAAAAAAAAA  LL                  SS',/,
     4 '  CC          RR  RR          YY              SS      TT    ',
     5 '  AA      AA  LL                  SS',/,
     6 '  CC          RR   RR         YY              SS      TT    ',
     7 '  AA      AA  LL                  SS',/,
     8 '  CC          RR    RR        YY              SS      TT    ',
     9 '  AA      AA  LL                  SS')
        WRITE(NCWU,1150)
1150  FORMAT(
     2 '  CCCCCCCCCC  RR     RR       YY      SSSSSSSSSS      TT    ',
     3 '  AA      AA  LLLLLLLLLL  SSSSSSSSSS',/,
     4 '   CCCCCCCC   RR      RR      YY       SSSSSSSS       TT    ',
     5 '  AA      AA  LLLLLLLLLL   SSSSSSSS ')
C
      ENDIF
      ENDIF
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 2005 ) CSSPRG(1:LSSPRG) , CTIME , CDATE
2005  FORMAT ( // , 1X , A , ' initialised at ' , A , ' on ' , A )
      WRITE ( NCWU , 2015 ) 0.01*FLOAT(ISSVER), CSSSVN(1:LSSSVN),
     1 CSSMAC(1:LSSMAC),
     2 CSSOPS(1:LSSOPS), CSSDAT(1:LSSDAT)
      ENDIF
C
      WRITE ( NCAWU, 2015 ) 0.01*FLOAT(ISSVER), CSSSVN(1:LSSSVN),
     1 CSSMAC(1:LSSMAC),
     2 CSSOPS(1:LSSOPS), CSSDAT(1:LSSDAT)
      WRITE ( CMON,2015)  0.01*FLOAT(ISSVER), CSSSVN(1:LSSSVN),
     1 CSSMAC(1:LSSMAC),
     2 CSSOPS(1:LSSOPS), CSSDAT(1:LSSDAT)
      CALL XPRVDU(NCVDU, 3,0)
2015  FORMAT (  2X , 'Version' , F7.2 , ' build ', A, ' for ' , 
     1 A , ' under '
     2 , A, 3X , A , / , 10X ,
     3 'Copyright Chemical Crystallogaphy Laboratory, Oxford' , / )
C
C -- THIS NEXT HEADER IS ONLY APPROPRIATE FOR INTERACTIVE JOBS
c      IF ( IQUN .EQ. JQUN ) WRITE ( NCAWU , 2110 )  IH , IH
2110  FORMAT(
     5 9X , 'To get help, type ' , A1 , 'HELP HELP', /
     6 9X , 'To end, type      ' , A1 , 'FINISH' , / )
C
C
      CALL OUTCOL(1)
      IF ( ISSTML .EQ. 3) THEN
C            CALL VGACOL ( 'BOL', 'WHI', 'BLU' )
            WRITE ( NCVDU, '(79A1)') (CHAR(42),I=1,79)
            WRITE ( NCVDU, '(79A1)') (' ' ,I=1,79)
            WRITE ( NCVDU, '(/)')
      ENDIF
C
C
      RETURN
      END
C
CODE FOR XTIME1
      SUBROUTINE XTIME1(N)
C--INITIATE THE TIMING OF A GIVEN OPERATION
C
C  N  THE NUMBER THAT IDENTIFIES THIS OPERATION (1-3)
C     ENTRY WITH N=0 IS RESERVED FOR OVERALL TIMING
C
C--
      INCLUDE 'XTIMES.INC'
C
C**MACHINE SPECIFIC - GET THE PROCESSOR TIME.
      CALL MTIME(Q(N+1))
      CALL JTIME(I)
      QQ(N+1)=FLOAT(I)
      RETURN
      END
C
CODE FOR XTIME2
      SUBROUTINE XTIME2(N)
C--THIS ENTRY CALCULATES AND PRINTS THE TIME TAKEN TO DO AN OPERATION
C
C  N  IDENTIFIES THE OPERATION AND SHOULD TAKE THE SAME VALUE
C     AS 'N' GIVEN TO 'XTIME1' AT THE START.
C
C--
      INCLUDE 'XTIMES.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      DATA A/0.0/,I/0/,J/0/,K/0/,L/0/
C
C -- IF TIMING IS DISABLED, RETURN IMMEDIATELY
      IF ( ISSTIM .NE. 1 ) RETURN
C
C**MACHINE SPECIFIC
C--CALCULATE THE MILL TIME
      A=Q(N+1)
      CALL MTIME(Q(N+1))
      A=Q(N+1)-A
      I=INT(A/60.)
      J=NINT(A-FLOAT(I)*60.)
C--CALCULATE THE ELAPSED TIME
      L=NINT(QQ(N+1))
      CALL JTIME(K)
      QQ(N+1)=FLOAT(K)
C--CHECK IF THE DAY HAS CHANGED
      IF(K-L)1000,1050,1050
C--DAY HAS CHANGED
1000  CONTINUE
      L=K+86400-L
      GOTO 1100
1050  CONTINUE
      L=K-L
1100  CONTINUE
      K=L/60
      L=L-K*60
      CALL XTIME(IA,IB)
      WRITE ( CMON,1150) IA,IB,I,J,K,L
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') trim(CMON(1))
      WRITE(NCAWU,'(A)') trim(CMON(1))
1150  FORMAT(1X,2A4,' : Processor time ',I4,' min',I4,
     2 ' sec : Elapsed time ',I4,' min',I4,' sec')
      RETURN
      END
C
CODE FOR XTIME
      SUBROUTINE XTIME(IPART1,IPART2)
C--SET THE TIME IN IPART1 AND IPART2.
C
C--THE FORMAT IS A4, AND IS SET AS :
C
C  IPART1  NN/M
C  IPART2  M/PP
C
C--FOR THE TIME NN/MM/PP
C
      CHARACTER*8 CTIME
      CALL XTIMER ( CTIME )
      READ ( CTIME(1:4) , '(A4)' ) IPART1
      READ ( CTIME(5:8) , '(A4)' ) IPART2
      RETURN
      END
C
CODE FOR XDATE
      SUBROUTINE XDATE(IPART1,IPART2)
C--SET THE DATE IN IPART1 AND IPART2.
C
C--THE FORMAT IS A4, AND IS SET AS :
C
C  IPART1  NN/M
C  IPART2  M/PP
C
C--FOR THE DATE NN/MM/PP
C
      CHARACTER*8 CDATE
      CALL XDATER ( CDATE )
      READ ( CDATE(1:4) , '(A4)' ) IPART1
      READ ( CDATE(5:8) , '(A4)' ) IPART2
      RETURN
      END
C
CODE FOR OVERFL
      SUBROUTINE OVERFL(IN)
C--CLEAR THE OVERFLOW MARKER ON 1900 RANGE MACHINES
C
      IN=2
      RETURN
      END
C
CODE FOR XFCCS
      SUBROUTINE XFCCS(A,B,N)
C
C THE ROUTINES WHICH FOLLOW ARE DONE IN S3 OR JCL ON THE ICL 2980
C
C----- CONVERT AN A4 STRING INTO A 'COMPRESSED' STRING.
C      BY PACKING THE BITS OF A INTO THE BITS OF B
C     ON THE 32 BIT MACHINES  THESE ARE USUALLY THE SAME.
      DIMENSION A(N), B(N)
      CALL XMOVE(A(1),B(1),N)
      RETURN
      END
C
CODE FOR XFLPCK
      SUBROUTINE XFLPCK ( NAME, LENGTH, PREFIX, SUFFIX, RESULT, LENRES)
C
      CHARACTER*(*) PREFIX , SUFFIX , RESULT
      DIMENSION NAME(LENGTH)
C
      ISTART = 1
      RESULT = ' '
C
      IF ( PREFIX .NE. ' ' ) THEN
        IEND = ISTART + LEN ( PREFIX ) - 1
        RESULT(ISTART:IEND) = PREFIX
        ISTART = IEND + 1
      ENDIF
C
      IEND = ISTART + LENGTH - 1
      WRITE ( RESULT(ISTART:IEND) , 1005 ) NAME
1005  FORMAT ( 256A1 )
      ISTART = IEND + 1
C
      IF ( SUFFIX .NE. ' ' ) THEN
        IEND = ISTART + LEN ( SUFFIX ) - 1
        RESULT(ISTART:IEND) = SUFFIX
        ISTART = IEND + 1
      ENDIF
C
      LENRES = ISTART - 1
C
      RETURN
      END
C
CODE FOR XGENNM
      SUBROUTINE XGENNM ( IDEV, NEWFIL, OLDFIL, IRDWRI, ISTTUS)
C----- UNDER VMS, FILES ARE GENERATED, NAMED AND NEW GENERATIONS
C      FORMED IN A VERY USEFUL WAY.
C      THIS CODE IS A CHEAP EMULATION FOR UNIX OR DOS MACHINES.
C
C      IDEV   THE FORTRAN IO UNIT
C      NEWFIL THE FILE BEING GENERATED OR RENAMED
C
      LOGICAL LEXIST, LOPEND, LNAMED
      CHARACTER *3 CDEV
      CHARACTER *(*) NEWFIL, OLDFIL
C
      INCLUDE 'TSSCHR.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'XSSVAL.INC'
      LENFIL = LEN (NEWFIL)
C
C----- RETURN IF THE FILE IS 'SCRATCH, 'READ' OR 'OLD'
      IF ((ISTTUS .EQ. ISSSCR) .OR. (IRDWRI .EQ. ISSREA) .OR.
     1    (ISTTUS .EQ. ISSOLD)) RETURN

C
C----- IF OUT PUT TO PRINTER OR SCREEN, SET DEVICE AND RETURN
      LENNAM = 1
      CDEV = '   '

      IF (NEWFIL .NE. ' ') THEN
         CALL XCTRIM( NEWFIL, LENNAM)
         LENNAM=LENNAM-1
         I = MIN (3,LENNAM)
         CALL XCCUPC (NEWFIL(1:I), CDEV(1:I))
      END IF

      IF (( CDEV(1:2) .EQ. 'TT') .OR. ( CDEV(1:3) .EQ. 'TT:')) THEN
            NEWFIL=' '
            NEWFIL(1:LSSVDU) = CSSVDU(1:LSSVDU)
            ISTTUS = ISSCIF
      ELSE IF(( CDEV(1:2) .EQ. 'LP').OR.( CDEV(1:3) .EQ. 'LP:')) THEN
            NEWFIL=' '
            NEWFIL(1:LSSLPT) = CSSLPT(1:LSSLPT)
            ISTTUS = ISSCIF
      ENDIF

C----- RETURN IF A PHYSICAL DEVICE
      IF ((NEWFIL(1:LSSLPT) .EQ. CSSLPT(1:LSSLPT)) .OR.
     1 (NEWFIL(1:LSSVDU) .EQ. CSSVDU(1:LSSVDU))) RETURN
C
      IF (NEWFIL .EQ. ' ') THEN
C----- SEE IF THERE WAS A NAMED FILE ON THE UNIT
       IF (OLDFIL .NE. ' ') THEN
            NEWFIL = OLDFIL
       ELSE
       CALL XMAKNM (IDEV, NEWFIL, ISTTUS)
       ENDIF
      ENDIF
C     IF THE FILE EXISTS AND STATUS IS CIF,
C     CHANGE THE STATUS TO OLD, OTHERWISE NEW
      CALL MTRNLG(NEWFIL,'OLD',LENNAM)
      INQUIRE (FILE = NEWFIL, EXIST = LEXIST)
      IF (ISTTUS .EQ. ISSCIF) THEN
C            IF (LEXIST .EQV. .TRUE.) THEN  NOT PROCESSED CORRECTLY BY F
            IF (LEXIST ) THEN
               ISTTUS = ISSOLD
            ELSE
               ISTTUS = ISSNEW
            ENDIF
      ENDIF
C----- IF THE STATUS IN NEW AND THE FILE EXISTS, INCREMENT GENERATION
      IF ((ISTTUS.EQ.ISSNEW) .AND. (LEXIST) ) THEN
            CALL XINCNM ( NEWFIL,ISTTUS)
      ENDIF

C RIC2002: Do not
C----- REMOVEANYEMBEDDEDBLANKS
c      CALL XCRAS ( NEWFIL, LENNAM)
      RETURN
C
      END
CODE FOR XMAKNM
      SUBROUTINE XMAKNM (IUNIT, CNAME,ISTTUS)
C----- IF THE OPERATING SYSTEM DOES NOT INVENT NAMES FOR
C      UNNAMED FILES, THIS ROUTINE CAN BE USED TO GENERATE
C      NAMES BASED ON THE I/O UNIT
C
C----- BUILD UP A FILENAME FROM THE UNIT NUMBER AND A
C      NUMERIC EXTENSION
C
      CHARACTER *(*) CNAME
      CHARACTER CPATH*32, CUNIT*4
      DIMENSION JUNIT(3)
      CNAME = ' '
      LPATH = KPATH(CPATH)
      WRITE(CUNIT, '(I3)') IUNIT
      READ (CUNIT, '(3I1)') JUNIT
      IF (LPATH .GE. 1) THEN
        WRITE(CNAME, '(A,A3,3I1,A2)')
     1  CPATH(1:LPATH),  'FOR', JUNIT, '.0'
      ELSE
        WRITE(CNAME, '(A3,3I1,A2)') 'FOR', JUNIT, '.0'
      ENDIF
      RETURN
      END
C
CODE FOR XINCNM
      SUBROUTINE XINCNM (CNAME,ISTTUS)
C----- IF THE OPERATING SYSTEM DOES NOT SUPPORT GENERATION NUMBERS,
C      THIS ROUTINE CAN BE CALLED TO MODIFY FILENAMES IN A
C      SYSTEMATIC WAY
C
      LOGICAL LEXIST
      CHARACTER *(*) CNAME
      CHARACTER *10 CDIGIT
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      DATA CDIGIT /'0123456789'/
      LEXIST = .FALSE.
            CALL MTRNLG(CNAME,'OLD',LENNAM)
      LENGTH = LEN (CNAME)
C----- FIND THE ACTUAL FILENAME
CDJW-NOV-09  Try to spot paths with spaces in them
      I = KCCTRM ( 1, CNAME, ISTART, IEND)
      iend = istart
      do i = length,istart,-1
            if (cname(I:I) .ne. ' ') then
                  iend = i
                  exit
            end if
      end do
c
C----- IF GENERATION NUMBER INDICATED BY ';' HACK OFF THE GENERATION
C      NUMBER AND RETURN - PROBABLY VAX
      I = INDEX (CNAME(1:IEND) , ';' )
      IF (I .GT. 0) THEN
        CNAME(I:IEND) = ' '
        RETURN
      ENDIF
CDJWOCT2000
C------ REORGANISE SO THET ROOT IS EXTENDED
C----- ADD A '.' IF NECESSARY
      I = INDEX (CNAME(1:IEND) , '.')
      IF (I .LE. 0) THEN
            IF (IEND+1 .LE. LENGTH) THEN
                  IEND = IEND +1
            ELSE
                  IEND = LENGTH
            ENDIF
            I = IEND
            CNAME(I:I) = '.'
      ENDIF
C----- MAKE SPACE FOR #NM IF POSSIBLE
      IF (CNAME(I-3:I-3) .NE. '#') THEN
            IF (IEND+3 .LE. LENGTH) THEN
              IEND = IEND+3
              I = I+3
            ELSE
              J = LENGTH - IEND
              IEND = LENGTH
              I = I + J
            ENDIF
            DO 50 J = IEND, I, -1
             CNAME(J:J) = CNAME(J-3:J-3)
50          CONTINUE
            CNAME(I-3:I-1) = '#00'
      ENDIF
      K = I-2
C       LOOK FOR THE HIGHEST GENERATION. IF GENERATION 99 EXISTS,
C       RESET STATUS TO UNKNOWN TO ENABLE FUTURE OVERWRITES
      DO 100 J = 0, 98
            WRITE(CNAME(K:K+1),'(I2.2)') J
            INQUIRE (FILE = CNAME(1:IEND), EXIST = LEXIST)
            IF (.not. LEXIST ) THEN
                  I = J
                  GOTO 200
            ENDIF
100     CONTINUE
C----- RUN OFF TOP - SET MAXIMUM
      I = 99
      ISTTUS = ISSUNK
200   CONTINUE
      WRITE(CNAME(K:K+1),'(I2.2)') I
      RETURN
      END
C
CODE FOR KFLNAM
      FUNCTION KFLNAM ( IUNIT , FNAME )
C -- THIS FUNCTION SHOULD RETURN THE NAME OF THE FILE ON UNIT 'IUNIT'
C
C -- RETURN VALUES :-
C      -1      FAILURE
C      +1      SUCCESS
C
      CHARACTER*(*) FNAME
C
      CHARACTER*256 CNAME
      LOGICAL LNAMED, LOPEN
C
      FNAME = ' '
      KFLNAM = -1
C
      INQUIRE (UNIT = IUNIT, NAME=CNAME, NAMED=LNAMED,
     1 OPENED = LOPEN, ERR = 9900)
C      IF (LOPEN .NEQV. .TRUE. ) RETURN NOT PROCESSED CORRECTLY BY FTN77
C      IF (LNAMED .EQV. .TRUE. ) FNAME = CNAME
      IF ( .NOT. LOPEN ) RETURN
      IF (LNAMED) FNAME = CNAME
C
      KFLNAM = 1
      RETURN
9900  CONTINUE
      RETURN
      END
CODE FOR XMNADD
      SUBROUTINE XMNADD (MNLINE)
C----- SET UP THE VIRTUAL DISPLAY ADDRESSES
C
C      MNLINE    NUMBER OF LINES IN MENU
C
C      NBFR      BOTTOM FRAME
C      NPRMPT    PROMPT ADDRESS
C      NBL1      IST BLANK LINE
C      NMENU1    TOP LINR OF MENU
C      NBL2      2ND BLANK LINE
C      NSCPPR    SCRIPT NAMES
C      NTPFR     TOP OF FRAME
C      NLNFR     LINES IN FRAME
C
      INCLUDE 'XMENUI.INC'
C
C
      NTPFR = 1
      NSCPPR = NTPFR + 1
      NBL2 = NSCPPR + 1
      NMENU1 = NBL2 + 1
      NBL1 = NMENU1 + MNLINE
      NPRMPT = NBL1 + 1
      NBFR = NPRMPT + 1
      NLNFR =  NBFR - NTPFR + 1
      RETURN
      END
C
C
CODE FOR XMNCR
      SUBROUTINE XMNCR ( ID, IROW, ICOL, MNISL, MNWID)
C
C----- FIND THE COLUMN AND ROW ADDRESS OF THE ID'TH MENU ITEM
C
C----- ABSOLUTE CHARACTER ADDRESS
      IACA = (ID - 1) * MNISL
      IROW = (IACA/MNWID) + 1
      ICOL = IACA - (IROW - 1) * MNWID + 1
      RETURN
      END
C
CODE FOR VGACOL
      SUBROUTINE  VGACOL( CATRIB, CFOR, CBACK)
C----- SET THE ATTRIBUTES AND COLOURS FOR VGA SCREENS
      CHARACTER *3 CATRIB, CFOR, CBACK
      CHARACTER *24 CCOL
      CHARACTER *27 CFUN
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
CGUI{
        CHARACTER*80 GUICOL(8)
        CHARACTER*80 GUIFUN(3)
      DATA GUICOL(1) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 128 255 255'/     BLA
      DATA GUICOL(2) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 255 128  64'/     RED
      DATA GUICOL(3) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 0   255 0'/       GRE
      DATA GUICOL(4) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 0   255 0'/       YEL
      DATA GUICOL(5) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 0   0   0  '/     BLU
      DATA GUICOL(6) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 255 0   255'/     MAG
      DATA GUICOL(7) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 255 255 0'/       CYA
      DATA GUICOL(8) /'^^CO SET TEXTOUTPUT TEXTCOLOUR 255 0   0'/       WHI
      DATA GUIFUN(1) /'^^CO SET TEXTOUTPUT TEXTBOLD=NO TEXTUNDERLINE=NO
     1TEXTITALIC=NO'/
      DATA GUIFUN(2) /'^^CO SET TEXTOUTPUT TEXTBOLD=YES'/
      DATA GUIFUN(3) /'^^CO SET TEXTOUTPUT TEXTUNDERLINE=YES'/
CGUI}
C        N0+      0  1  2  3  4  5  6  7
      DATA CCOL /'BLAREDGREYELBLUMAGCYAWHI'/
C                 0  1  2  3  4  5  6  7  8
      DATA CFUN /'OFFBOLXXXXXXUNDBLIXXXREVCON'/
C
      IF (ISSTML .LE. 2) THEN
            RETURN
      ELSEIF (ISSTML .EQ.3) THEN
C------ SWITCH OFF LINE FEEDS
        JNL77 = 0
        I = INDEX (CCOL, CFOR(1:3))
        IF ( I .LE. 0) THEN
          IFOR = 37
        ELSE
          IFOR = (I+89)/3
        END IF
C
        I = INDEX (CCOL, CBACK(1:3))
        IF ( I .LE. 0) THEN
          IBACK = 40
        ELSE
          IBACK = (I+119)/3
        END IF
C
        I = INDEX (CFUN, CATRIB(1:3))
        IF ( I .LE. 0) THEN
C-----    NO ATTRIBUTE SET
          WRITE(NCVDU,100) CHAR(27), '[', IFOR, 'm',
     1                   CHAR(27), '[', IBACK, 'm' ,CHAR(13)
100       FORMAT (1X, A, A, I2, A, A, A, I2, A, A)
        ELSE
          IATRIB = (I-1)/3
C-----    ATTRIBUTE SET
          WRITE(NCVDU,101) CHAR(27), '[', IATRIB, 'm',
     1                   CHAR(27), '[', IFOR, 'm',
     2                   CHAR(27), '[', IBACK, 'm' ,CHAR(13)
101     FORMAT (1X, A, A, I1, A, A, A, I2, A, A, A, I2, A, A)
        END IF
        WRITE( NCVDU,'(79X,A)') CHAR(13)
C------ SWITCH ON LINE FEEDS
        JNL77 = 1
        RETURN
      ELSEIF (ISSTML .EQ. 4) THEN
        I = INDEX (CCOL, CFOR(1:3))
        IF ( I .LE. 0) THEN
          IFOR = 1
        ELSE
          IFOR = (I+2)/3
        END IF
        WRITE ( CMON,'(A)') GUICOL(IFOR)
        CALL XPRVDU(NCVDU, 1,0)
        I = INDEX (CFUN,CATRIB(1:3))
        IF (I.EQ.4)THEN
                IFUN=2
        ELSEIF (I.EQ.13)THEN
                IFUN=3
        ELSE
                IFUN=1
        ENDIF
        WRITE ( CMON,'(A)') GUIFUN(IFUN)
        CALL XPRVDU(NCVDU,1,0)
        RETURN
      ENDIF
      RETURN
      END

CODE FOR OUTCOL
      SUBROUTINE  OUTCOL( ICOL )
C----- SET THE ATTRIBUTES AND COLOURS FOR TEXT OUTPUT
#ifdef _DVF_ 
       USE DFWIN
       INTEGER HC,IC,B
#endif
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'OUTCOL.INC'

C     ICOL  Meaning           WinColour   VGAColour
C     ----  -------           ---------   ---------
C     1     NORMAL            Black       Bold White on Blue
C     2     DIAGRAM           Blue        Black on Cyan
C     3     SCRIPT QUESTION   Red         Bold White on Blue
C     4     SCRIPT MENU       Green       Bold Yellow on Cyan
C     5     TERM UNKNOWN      Black       White on Black
C     6     PROCESSING REFS   Black       Bold Yellow on Black
C     7     SPARE             Green       Bold White on Blue
C     8     COMMAND ECHO      Green       Black on LGrey
C     9     ERROR             Red         White on Red
C    10     SCRIPT OUTPUT     Blue        Blue on LGrey
c gui colour description added by djw
C     ICOL  Meaning           GuiColour          
C     ----  -------           ---------          
C     1     NORMAL            Black/white        
C     2     DIAGRAM           Black/cyan        
C     3     SCRIPT QUESTION   white/blue         
C     4     SCRIPT MENU       yellow/cyan        
C     5     TERM UNKNOWN      white/black        
C     6     PROCESSING REFS   yellow/black       
C     7     SPARE             Green/white        
C     8     COMMAND ECHO      black/lgrey        
C     9     ERROR             white/Red          
C    10     SCRIPT OUTPUT     Blue/Dgrey         
C
      CHARACTER*16 VGACOL(10)
      INTEGER IGUICL(2,10) /-1,-1, 1,10, 0,2, 8,10, 0,1,
     1                       8, 1,  3,0, 1,15, 0,4, 2,14 /
C
100   FORMAT (A)
101   FORMAT (1X, 7A)

      IF (ISSTML .LE. 2) RETURN

      IF ((ICOL .GT. 10).OR.(ICOL.LE.0)) RETURN

      IF (ICOL .EQ. IOLDC) RETURN

      IOLDC = ICOL

      IF (ISSTML .EQ.3) THEN
#if !defined(_DVF_) 
          WRITE(VGACOL(1),101) CHAR(27),'[1m', CHAR(27),'[37m',
     2                         CHAR(27),'[44m',CHAR(13)
          WRITE(VGACOL(2),101) CHAR(27),'[0m', CHAR(27),'[30m',
     2                         CHAR(27),'[46m',CHAR(13)
          WRITE(VGACOL(3),101) CHAR(27),'[1m', CHAR(27),'[37m',
     2                         CHAR(27),'[44m',CHAR(13)
          WRITE(VGACOL(4),101) CHAR(27),'[1m', CHAR(27),'[33m',
     2                         CHAR(27),'[46m',CHAR(13)
          WRITE(VGACOL(5),101) CHAR(27),'[0m', CHAR(27),'[37m',
     2                         CHAR(27),'[40m',CHAR(13)
          WRITE(VGACOL(6),101) CHAR(27),'[1m', CHAR(27),'[33m',
     2                         CHAR(27),'[40m',CHAR(13)
          WRITE(VGACOL(7),101) CHAR(27),'[1m', CHAR(27),'[37m',
     2                         CHAR(27),'[44m',CHAR(13)
          WRITE(VGACOL(8),101) CHAR(27),'[1m', CHAR(27),'[37m',
     2                         CHAR(27),'[44m',CHAR(13)
          WRITE(VGACOL(9),101) CHAR(27),'[1m', CHAR(27),'[37m',
     2                         CHAR(27),'[44m',CHAR(13)
          WRITE(VGACOL(10),101) CHAR(27),'[1m', CHAR(27),'[37m',
     2                         CHAR(27),'[44m',CHAR(13)
          WRITE(NCVDU,100) VGACOL(ICOL)
#else
          HC = GetStdHandle(STD_OUTPUT_HANDLE)
#endif
#ifdef _DVF_ 
          SELECT CASE ( ICOL )
          CASE (1)
           IC = BACKGROUND_BLUE+FOREGROUND_BLUE+
     1          FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_INTENSITY
          CASE (2)
           IC = BACKGROUND_BLUE+BACKGROUND_GREEN
          CASE (3)
           IC = BACKGROUND_BLUE+FOREGROUND_BLUE+
     1          FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_INTENSITY
          CASE (4)
           IC = FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_INTENSITY
     1         +BACKGROUND_BLUE+BACKGROUND_GREEN
          CASE (5)
           IC = FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_BLUE
          CASE (6)
           IC = FOREGROUND_RED+
     1          FOREGROUND_GREEN+FOREGROUND_INTENSITY
          CASE (7)
           IC = BACKGROUND_BLUE+FOREGROUND_BLUE+
     1          FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_INTENSITY
          CASE (8)
           IC = BACKGROUND_INTENSITY
          CASE (9)
           IC = FOREGROUND_RED+FOREGROUND_GREEN+FOREGROUND_BLUE+
     1          BACKGROUND_RED
          CASE (10)
           IC = FOREGROUND_BLUE+BACKGROUND_INTENSITY
          END SELECT
          b = SetConsoleTextAttribute(HC,IC)
#endif
      ELSEIF (ISSTML .EQ. 4) THEN
          IOFORE = IGUICL(1,ICOL)
          IOBACK = IGUICL(2,ICOL)
      ENDIF
      RETURN
      END
C
C
C     THE FOLLOWING SUBROUTINES ARE PROBABLY BEST
C     WRITTEN IN A LOW LEVEL LANGUAGE, ESPACIALLY THE 'MOVES'
C     WHICH ARE FREQUENTLY NEEDED TO MOVE LARGE AMOUNTS OF DATA
C
CODE FOR XZEROF
      SUBROUTINE XZEROF(A,N)
C--SET THE 'N' ELEMENTS OF THE ARRAY 'A' TO FLOATING POINT ZERO
C
C  A  THE ARRAY TO BE ZEROED
C  N  THE NUMBER OF ELEMENTS TO ZERO
C
C--
C
      DIMENSION A(N)
C
C--ZERO THE LEMENTS
      DO 1050 I=1,N
      A(I)=0.0
1050  CONTINUE
      RETURN
      END
C
C
CODE FOR XSRA
      SUBROUTINE XSRA(ARRAY,A4)
C----- PACKS THE A1 CHARACTERS IN THE 4 ADJACENT ELEMENTS
C     OF 'ARRAY' INTO A SINGLE A4 CHARACTER IN 'A4'
      CHARACTER *4 CHABUF
      DIMENSION ARRAY(4)
      WRITE(CHABUF,1)ARRAY
1     FORMAT(4A1)
      READ (CHABUF,2)A4
2     FORMAT(A4)
      RETURN
      END
C
CODE FOR XARS
      SUBROUTINE XARS(A4,ARRAY)
C----- UNPACKS THE A4 CHARACTERS IN 'A4' INTO 4 A1
C     CHARACTERS IN ADJACENT ELEMENTS OF 'ARRAY'
      CHARACTER *4 CHABUF
      DIMENSION ARRAY(4)
      WRITE(CHABUF,1)A4
1     FORMAT(A4)
      READ (CHABUF,2) ARRAY
2     FORMAT(4A1)
      RETURN
      END
C
CODE FOR XFA4CS
      SUBROUTINE XFA4CS(AONE,AFOUR,N)
C
C----- PACK 'N' A1 WORDS INTO (N+3)/4 A4 WORDS
      DIMENSION AONE(N), AFOUR((N+3)/4)
c123      CHARACTER *80 BUFFER
      CHARACTER *(N) BUFFER
C
C----- CLEAR BUFFER
      BUFFER=' '
      WRITE(BUFFER,100) AONE
100   FORMAT(256A1)
      M=(N+3)/4
      READ(BUFFER,200) (AFOUR(I),I=1,M)
200   FORMAT(64A4)
      RETURN
      END
CODE FOR XFILL
      SUBROUTINE XFILL(ICONST,IRESLT,ITEMS)
C----- FILLS 'ITEMS' ELEMENTS OF 'IRESLT' WITH 'ICONST'
      DIMENSION IRESLT(ITEMS)
      DO 100 I=1,ITEMS
      IRESLT(I)=ICONST
100   CONTINUE
      RETURN
      END
C
CODE FOR XSPY
      SUBROUTINE XSPY(IOP)
C-----
C     PROCEDURE FOR MONITORING USE OF THE SYSTEM
C     WRITES DETAILS OF USAGE TO SPYFILE
C
C     IOP = 1 FOR STARTUP
C           2     INSTRUCTION
C           3     END
C           4     ERROR
C
      CHARACTER*64 DISK
      CHARACTER*32 ANAME
      CHARACTER*8 IBUF , JBUF
      DIMENSION IHASH(12),MODE(3),MERROR(12)
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XSTATS.INC'
      INCLUDE 'XERCNT.INC'
      INCLUDE 'XERVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
#ifdef _HOL_
      DATA MODE(1)/1HI/ , MODE(2)/1HB/ , MODE(3)/1HO/
C     START UP
      DATA IHASH(1)/1HS/,IHASH(2)/1HT/,IHASH(3)/1HA/
      DATA IHASH(4)/1HR/,IHASH(5)/1HT/,IHASH(6)/1H /
      DATA IHASH(7)/1HU/,IHASH(8)/1HP/,IHASH(9)/1H /
      DATA IHASH(10)/1H /,IHASH(11)/1H /,IHASH(12)/1H /
CDJWFEB10
C     INCREASE I AND JHASH BUFFER TO 12 CHARACTERS
C     ERROR
      DATA MERROR(1)/1HE/,MERROR(2)/1HR/,MERROR(3)/1HR/
      DATA MERROR(4)/1HO/,MERROR(5)/1HR/,MERROR(6)/1H /
      DATA MERROR(7)/1H /,MERROR(8)/1H /,MERROR(9)/1H /
      DATA MERROR(10)/1H /,MERROR(11)/1H /,MERROR(12)/1H /
#else
      DATA MODE(1)/'I'/ , MODE(2)/'B'/ , MODE(3)/'O'/
C     START UP
      DATA IHASH(1)/'S'/,IHASH(2)/'T'/,IHASH(3)/'A'/
      DATA IHASH(4)/'R'/,IHASH(5)/'T'/,IHASH(6)/' '/
      DATA IHASH(7)/'U'/,IHASH(8)/'P'/,IHASH(9)/' '/
      DATA IHASH(10)/' '/,IHASH(11)/' '/,IHASH(12)/' '/
CDJWFEB10
C     INCREASE I AND JHASH BUFFER TO 12 CHARACTERS
C     ERROR
      DATA MERROR(1)/'E'/,MERROR(2)/'R'/,MERROR(3)/'R'/
      DATA MERROR(4)/'O'/,MERROR(5)/'R'/,MERROR(6)/' '/
      DATA MERROR(7)/' '/,MERROR(8)/' '/,MERROR(9)/' '/
      DATA MERROR(10)/' '/,MERROR(11)/' '/,MERROR(12)/' '/
#endif
C
C----- INDICATE WE HAVENT STARTED YET
      DATA ISPYST /0/
C
C
C----- CHECK IF WE CAN START
      IF ((ISPYST .EQ. 0) .AND. (IOP .NE. 1)) RETURN
C
      GOTO (1000,2000,2000,2000,100),IOP
100   CONTINUE
C      STOP 'SPYERROR'
      CALL GUEXIT(2021)
C
1000  CONTINUE
C----- INITIAL CALL
C----- GET DISKFILE ANAME
      NSTART = INDEX ( DISK , ':' ) + 1
      NEND   = INDEX ( DISK , '.DSC' ) - 1
      NEND=NSTART+MIN0(31,(NEND-NSTART))
      ANAME=DISK(NSTART:NEND)
      DISK(1:32)=ANAME
C----- GET USERNAME
      NEND=MIN0(9,(INDEX(DISK,'.')-1))
      ANAME=DISK(2:NEND)
C----- GET START TIME OF DAY
      CALL XTIMER ( JBUF )
      CALL XDATER ( IBUF )
C----- GET CPU AND ELLAPSED START TIME
      CALL MTIME(CPUTIM)
      CALL JTIME(I)
      ELPTIM=FLOAT(I)
C----- SET MODE
      JMODE=MODE(IQUN)
C----- SET START TIME IN MINUTES
      OLDCPU=CPUTIM/60.
      OLDELP=ELPTIM/60.
      FSTCPU=OLDCPU
      WRITE(NCSU,1100) ANAME,JBUF,IBUF
1100  FORMAT ( 1X , 'USER ' , A8 , ' Starts at ' , A8 , ' on ' , A8 )
      WRITE(NCSU,1200) DISK
1200  FORMAT(1X,'DISKFILE is ',A32)
C
      CALL XMOVE(IHASH,JHASH,12)
cdjwfeb10
      ispyst = 1
      GOTO 9000
C
2000  CONTINUE
C     SUBSEQUENT CALLS
      CALL MTIME(CPUTIM)
      CALL JTIME(I)
      ELPTIM=FLOAT(I)
      NCALL=NCALL+1
      CPUTIM=CPUTIM/60.
      ELPTIM=ELPTIM/60.
      DELCPU=CPUTIM-OLDCPU
      DELELP=ELPTIM-OLDELP
C -- IF THE END OF THE DAY HAS GONE BY, ADD 1440 MINUTES TO TIME
      IF ( DELELP .LT. 0. ) DELELP = DELELP + 1440.
      TOTCPU=CPUTIM-FSTCPU
      WRITE(NCSU,2600)JHASH,JMODE,NCALL,
     2 DELCPU,DELELP,TOTCPU
2600  FORMAT(1X,'INSTRUCTION ', 12A1, 1X, A1, 1X, I6, 1X, 3F10.2)
C----- UPDATE VALUES
      OLDCPU=CPUTIM
      OLDELP=ELPTIM
C----- BRANCH TO SET MESSAGE
      GOTO(9000,3000,6000,4000)IOP
      GOTO 100
C
C
3000  CONTINUE
C----- INSTRUCTION
      I=LR50+(MDR50)*(INSTR-1)+1
      CALL XMOVE(IMAGE(2),JHASH,12)
C      CALL XMOVE(ISTORE(I),JHASH,8)
      GOTO 9000
C
4000  CONTINUE
C----- ERROR
      WRITE(NCSU,4100)JHASH
4100  FORMAT(1X,'ERROR during ',12A1,' instruction')
      CALL XMOVE(MERROR,JHASH,12)
      GOTO 9000
C
C
C----- FINAL CALL
6000  CONTINUE
      WRITE(NCSU,6100) ICACHE,IPREAD,IPWRIT
6100  FORMAT(1X,'CACHE     hits ',I10,', reads',I10,', writes',
     2 I10)
      WRITE(NCSU,6200) (IERCOU(I),I=1,IERMAX)
6200  FORMAT(1X,'ENDS with error-counts ',10I3)
9000  RETURN
      END
C
C THE FOLLOWING ARE DUMMIES
C
CODE FOR KEQUAT
      FUNCTION KEQUAT(IN)
      KEQUAT = 0
C      STOP 'KEQUAT'
      CALL GUEXIT(2022)
100   RETURN
      END
CODE FOR KFORM
      FUNCTION KFORM(IN)
      KFORM = 0
C      STOP 'KFORM'
      CALL GUEXIT (2023)
100   RETURN
      END
CODE FOR KFUNCT
      FUNCTION KFUNCT(IN)
      KFUNCT = 0
C      STOP 'KFUNCT'
      CALL GUEXIT (2024)
100   RETURN
      END
CODE FOR XABS
      SUBROUTINE XABS
C      STOP 'XABS'
      CALL GUEXIT(2025)
100   RETURN
      END
CODE FOR FCASE
      SUBROUTINE FCASE(FILNAM, CLCNAM, ICASE)
C---- ENSURES CLCNAM HAS THE CORRECT CASE
C      ICASE
C      0 = ALL LOWER CASE
C      1 = ALL UPPERCASE
C      2 = PRESERVE ORIGINAL CASE
C      SET ICASE EQUAL TO ISSFLC 
C      TO USE THE SYSTEM VARIABLE SET WITH #SET FILECASE
      CHARACTER *(*) FILNAM, CLCNAM
      CHARACTER *256 CTEMP
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      NAMLEN = MIN (LEN(FILNAM), LEN(CLCNAM))
      IF (NAMLEN .GT. 0) THEN
        IF (NAMLEN .GT. 256) THEN
         NAMLEN = MIN (256, NAMLEN)
         WRITE ( CMON,100)FILNAM(1:NAMLEN)
100      FORMAT ( 'Filename truncated to 256 characters',A )
         CALL XPRVDU(NCEROR, 3,0)
         WRITE ( NCAWU , '(A)' ) trim(CMON(1))
         IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(A)' ) trim(CMON(1))
        ENDIF
        IF (ICASE .EQ. 0) THEN
C----- CONVERT NAME TO LOWER CASE
           CALL XCCLWC (FILNAM, CTEMP(1:NAMLEN) )
        ELSE IF (ICASE .EQ. 1) THEN
C----- CONVERT NAME TO UPPER CASE
           CALL XCCUPC (FILNAM, CTEMP(1:NAMLEN) )
        ELSE
           CTEMP(1:NAMLEN) = FILNAM(1:NAMLEN)
        ENDIF
        CLCNAM(1:NAMLEN) = CTEMP(1:NAMLEN)
      ELSE
        CLCNAM(:) = ' '
      ENDIF
      RETURN
      END

CODE FOR KCRCHK
      FUNCTION KCRCHK( IPTR, ILEN )
      CHARACTER*1 CBUFF, CRC(2), CREG(4), CIN(4), RCHR(0:255)
      DIMENSION CBUFF(ILEN)
      DIMENSION ICRCTB(0:255),IT(0:15)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      EQUIVALENCE (CREG,IREG)
      EQUIVALENCE (CIN,IIN)

      SAVE INICRC
	  SAVE ICRCTB
      DATA INICRC /0/

      IF ( INICRC .EQ. 0 ) THEN
         INICRC = 1
         DO J=0,255
            IREG=J*256
            ICRCTB(J)=KCRCTB(CREG,CHAR(0))
            ICH = IT(MOD(J,16))*16+IT(J/16)
            RCHR(J) = CHAR(ICH)
         END DO
      END IF

      CRC(1) = CHAR(0)
      CRC(2) = CHAR(0)

      DO J = 0,ILEN-1
         IIN = ISTORE(IPTR+J)
         DO K = 1,4
            ICH=ICHAR(CIN(K))
            IREG = ICRCTB( IEOR( ICH,            ICHAR( CRC(2) ) ) )
            CRC(2) = CHAR( IEOR( ICHAR(CREG(2)), ICHAR( CRC(1) ) ) )
            CRC(1) = CREG(1)
         END DO
      END DO

      CREG(1) = CRC(1)
      CREG(2) = CRC(2)

      KCRCHK = IREG
      RETURN
      END

CODE FOR KCRCTB
      FUNCTION KCRCTB( CRC, CH )
      CHARACTER*1 CH, CRC(4), CREG(4)
      EQUIVALENCE ( CREG, IREG)
      IREG = 0
      CREG(1)=CRC(1)
      CREG(2)=CHAR( IEOR( ICHAR(CRC(2)), ICHAR(CH) ) )

      DO I = 1,8
         ICHR = ICHAR(CREG(2))
         IREG = IREG+IREG
         CREG(3)=CHAR(0)
         IF(ICHR.GT.127)IREG=IEOR(IREG,4129)
      END DO
      KCRCTB = IREG
      RETURN
      END

cCODE FOR XADDER
c      SUBROUTINE XADDER ( KERRNO, KREPT, KDATA )
cC  STORE AN 'ERRR' RECORD IN LIST39.
cC  KERRNO - NUMBER IDENTIFYING TYPE OF ERROR
cC  KREPT  = 0  DON'T REPEAT - OVERWRITE EXISTING KERRNO IF PRESENT
cC         = 1  REPEAT - ADD A NEW ERROR RECORD
cC  KDATA  - 9 WORDS OF ADDITIONAL (OPTIONAL) ERROR INFORMATION.
cC
c      DIMENSION KDATA(9)
c\ISTORE
c\STORE
c\UFILE
c\XSSVAL
c\QSTORE
c\XIOBUF
c\XUNITS
c\XLST39
c\ICOM39
c\QLST39
c      DATA ICER /'ERRR'/
c\IDIM39
c
cC -- If List 39 exists, load it.
c      IF ( KEXIST(39) .GE. 1 ) THEN
c         IF (KHUNTR (39,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL39
c         IF ( IERFLG .LT. 0 ) GO TO 9900
c      ELSE
cC -- CREATE  A  NEW  LIST  THIRTY - NINE:
c         IDWZAP = 0
c         CALL XFILL (IDWZAP, ICOM39, IDIM39)
c         N39O = 1
c         N39I = 1
c         N39F = 0
c         CALL XCELST ( 39, ICOM439, IDIM39 )
c         ISTORE(L39I) = ICER
c         ISTORE(L39I+1) = KERRNO
c         CALL XNDATE(ISTORE(L39I+2))
c         CALL XMOVEI(KDATA(1),ISTORE(L39I+3),9)
c         ISTORE(L39O)   = 1
c         CALL XWLSTD ( 39, ICOM39, IDIM39, 0, 1)
c         GOTO 9000
c      ENDIF
c
cC -- If the repeat flag is 0, then we can overwrite this error:
c      KOWEXS = 0
c      IF ( KREPT .EQ. 0 ) THEN
cC -- if it exists:
c        DO M39I = L39I, L39I+(N39I-1)*MD39I, MD39I
c          IF ((ICER.EQ.ISTORE(M39I)).AND.(KERRNO.EQ.ISTORE(M39I+1)))THEN
c             KOWEXS = M39I
c             EXIT
c          ENDIF
c        ENDDO
c      END IF     
c
c      IF ( ( KREPT .EQ. 0 ) .AND. ( KOWEXS .GT. 0 ) ) THEN
c        CALL XNDATE(ISTORE(M39I+2))
c        CALL XMOVEI(KDATA(1),ISTORE(M39I+3),9)
c      ELSE
cC -- otherwise, need to extend the list.
c        IF (KHUNTR (39,101,IADDL,IADDR,IADDD,-1) .NE. 0) GOTO 9900
c        IF ( IERFLG .LT. 0 ) GO TO 9900
c
c        NEWL39 = KSTALL( (N39I+1) * MD39I )
c        CALL XMOVEI(ISTORE(L39I),ISTORE(NEWL39),N39I*MD39I)
c        M39I = NEWL39 + N39I * MD39I
c        ISTORE(M39I) = ICER
c        ISTORE(M39I+1) = KERRNO
c        CALL XNDATE(ISTORE(M39I+2))
c        CALL XMOVEI(KDATA(1),ISTORE(M39I+3),9)
c        ISTORE(L39O)   = ISTORE(L39O)+1
c        ISTORE(IADDR+3) = NEWL39  ! Change header pointer to new data
c        N39I = N39I + 1
c      ENDIF
c
cC -- Write data back to disk.
c      CALL XWLSTD ( 39, ICOM39, IDIM39, 0, 1)
c
c9000  CONTINUE ! All ok
c      RETURN
c
c9900  CONTINUE ! Something bad. (No list 39).
c      CALL XOPMSG ( IOPSLA , IOPABN , 0 )
c      GOTO 9000
c      
c      END

cCODE FOR KGETER
c      FUNCTION KGETER ( KERRNO, KNEXT, KDATE, KDATA )
cC Retrieve error information from list 39.
cC     KERRNO - set to the error type that you seek, or 0 for any error.
cC              if set to zero, it will be set to the error type on return.
cC     KNEXT - record index to start search from, when calling set to zero
cC             initially, then afterwards to the return value of the previous
cC             call.
cC     KDATE - the number of seconds since 1970 when the error occurred.
cC     KDATA - 9 words of extra error information (specific to the error).
cC   RETURN VALUE index of next record. (Not necessarily an 'ERRR' card).
c
c      DIMENSION KDATA(9)
c\ISTORE
c\STORE
c\UFILE
c\XSSVAL
c\QSTORE
c\XIOBUF
c\XUNITS
c\XLST39
c\ICOM39
c\QLST39
c      DATA ICER /'ERRR'/
c\IDIM39
c      KGETER = -1
c
c      IF ( KEXIST(39) .GE. 1 ) THEN
c         IF (KHUNTR (39,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL39
c         IF ( IERFLG .LT. 0 ) GO TO 9900
c      ELSE
c         RETURN
c      END IF
c
c      IF ( ( KNEXT .LT. 0 ) .OR. ( KNEXT .GE. N39I ) ) THEN
c         RETURN
c      ENDIF
c
cC Find next error:
c      KNE = 0
c      DO J = KNEXT, N39I-1
c      M39I = L39I + J*MD39I
c        IF ((ICER.EQ.ISTORE(M39I)) .AND. 
c     1      ((KERRNO.EQ.0) .OR. (KERRNO.EQ.ISTORE(M39I+1)))) THEN
c           KNE = M39I
c           KGETER = J + 1
c           KERRNO = ISTORE(M39I+1)
c           EXIT
c        ENDIF
c      ENDDO
c
c      IF ( KNE.EQ.0 ) RETURN
c
c      KDATE = ISTORE(KNE+2)
c      CALL XMOVEI(ISTORE(KNE+3),KDATA(1),9)
c
c      RETURN
c
c9000  CONTINUE ! All ok
c      RETURN
c
c9900  CONTINUE ! Something bad. (No list 39).
c      CALL XOPMSG ( IOPSLA , IOPABN , 0 )
c      GOTO 9000
c      END

cCODE FOR XCLRER
c      SUBROUTINE XCLRER ( KERRNO )
cC Clear error information from list 39.
cC     KERRNO - set to the error type that you seek, or 0 for all errors.
c\ISTORE
c\STORE
c\UFILE
c\XSSVAL
c\QSTORE
c\XIOBUF
c\XUNITS
c\XLST39
c\ICOM39
c\QLST39
c      DATA ICER /'ERRR'/
c\IDIM39
c      IF ( KEXIST(39) .GE. 1 ) THEN
c         IF (KHUNTR (39,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL39
c         IF ( IERFLG .LT. 0 ) GO TO 9900
c      ELSE
c         RETURN
c      END IF
c
cC Find next error:
c      NEWN = N39I
c      M39I = L39I
c      DO J = 0, N39I-1
c        IF ((ICER.EQ.ISTORE(M39I)) .AND. 
c     1      ((KERRNO.EQ.0) .OR. (KERRNO.EQ.ISTORE(M39I+1)))) THEN
cC Clear this error by moving rest of records down one.
c            NEWN = NEWN - 1
c            CALL XMOVEI(ISTORE(M39I+MD39I),ISTORE(M39I),(NEWN-J)*MD39I)
c        ELSE
c            M39I = M39I + MD39I
c        ENDIF
c      ENDDO
c      N39I = NEWN
c
cC -- Write data back to disk.
c      CALL XWLSTD ( 39, ICOM39, IDIM39, 0, 1)
c
c9000  CONTINUE ! All ok
c      RETURN
c
c9900  CONTINUE ! Something bad. (No list 39).
c      CALL XOPMSG ( IOPSLA , IOPABN , 0 )
c      GOTO 9000
c      END
code for oldroman
C      subroutine oldroman(idecimal,croman)
c---- return roman character representation of integer number
C      parameter (nromtxt = 10)
C      character *4 croman, cromtxt(nromtxt)
C      data cromtxt/'i','ii','iii','iv','v','vi','vii',
C     1 'viii','ix','x'/
cdjw convert to roman
C      if ((idecimal .gt. 0) .and. (idecimal .le. nromtxt)) then
C       croman = cromtxt(idecimal)
C      else
C       croman = ' '
C      endif
C      write(ncwu, '(i4,3x,a)') ippack, croman
C      return
C      end
CODE FOR REFOUT
      SUBROUTINE REFOUT(IDEV, I,J,K,F,S)
C TRY TO PRESERVE SIGNIFICANCE IN HKLI FORMAT FILES
      BIGGEST=MAX(F,S)
      IF (BIGGEST.LE.9999.) THEN
       WRITE(IDEV, '(3I4, 2F8.2)') I, J, K, F, S
      ELSE IF (BIGGEST.LE.99999.) THEN
       WRITE(IDEV, '(3I4, 2F8.1)') I, J, K, F, S
      ELSE IF (BIGGEST.LE.999999.) THEN
       WRITE(IDEV, '(3I4, 2F8.0)') I, J, K, F, S
      ELSE
       WRITE(IDEV, '(3I4, 2F10.0, A)') I, J, K, F, S, ' *'
      END IF
      RETURN
      END
C
CRYSTALS CODE FOR ZROMAN
      SUBROUTINE ZROMAN(ARB, ROM)
!***********************************************************************************************************************************
!  AR2ROM
!
!  This function converts an Arabic numeral to a Roman numeral.
!
!  Author:       Dr. David G. Simpson
!                Laurel, Maryland
!  Input:
!     ARB    -  Arabic numeral (integer)
!  Outputs:
!     ROM    -  Roman numeral (character string)
!     VALID  -  Returns .TRUE. if input was valid, .FALSE. if invalid
!
!   This function will set the VALID flag to .FALSE. if the input Arabic numeral is negative or zero.
!***********************************************************************************************************************************
C      SUBROUTINE AR2ROM (ARB, ROM, VALID)

      IMPLICIT NONE

c      INTEGER, INTENT(IN) :: ARB                                                    ! input Arabic numeral
       INTEGER ARB
c      CHARACTER(LEN=*), INTENT(OUT) :: ROM                                          ! output Roman numeral string
      CHARACTER*(*) ROM                                          ! output Roman numeral string
C      LOGICAL, INTENT(OUT) :: VALID                                                 ! output valid flag
       LOGICAL VALID
      INTEGER :: I, J, LEFT
!
!     Start of code.
!     Check for invalid Arabic numeral (non-positive).
!     If invalid, set VALID flag to .FALSE. and exit.
!
      ROM = ' '
      IF (ARB .LE. 0) THEN
C         VALID = .FALSE.
         RETURN
      END IF
!
!     Initialize variables.
!
C      VALID = .TRUE.
      LEFT = ARB
      J = 1
!
!     Begin successive subtractions from Arabic numeral to find corresponding Roman numerals.
!     Note that multiple I, X, C, or M may occur, but only (at most) one each of:  IV, V, IX, XL, L, XC, CD, D, CM.
!
!     Account for 1000's (M).
!
      DO WHILE (LEFT .GE. 1000)
         LEFT = LEFT - 1000
         ROM(J:J) = 'M'
         J = J + 1
      END DO
!
!     Account for 900 (CM).
!
      IF (LEFT .GE. 900) THEN
         LEFT = LEFT - 900
         ROM(J:J+1) = 'CM'
         J = J + 2
      END IF
!
!     Account for 500 (D).
!
      IF (LEFT .GE. 500) THEN
         LEFT = LEFT - 500
         ROM(J:J) = 'D'
         J = J + 1
      END IF
!
!     Account for 400 (CD).
!
      IF (LEFT .GE. 400) THEN
         LEFT = LEFT - 400
         ROM(J:J+1) = 'CD'
         J = J + 2
      END IF
!
!     Account for 100's (C).
!
      DO WHILE (LEFT .GE. 100)
         LEFT = LEFT - 100
         ROM(J:J) = 'C'
         J = J + 1
      END DO
!
!     Account for 90 (XC).
!
      IF (LEFT .GE. 90) THEN
      LEFT = LEFT - 90
         ROM(J:J+1) = 'XC'
         J = J + 2
      END IF
!
!     Account for 50 (L).
!
      IF (LEFT .GE. 50) THEN
         LEFT = LEFT - 50
         ROM(J:J) = 'L'
         J = J + 1
      END IF
!
!     Account for 40 (XL).
!
      IF (LEFT .GE. 40) THEN
         LEFT = LEFT - 40
         ROM(J:J+1) = 'XL'
         J = J + 2
      END IF
!
!     Account for 10's (X).
!
      DO WHILE (LEFT .GE. 10)
         LEFT = LEFT - 10
         ROM(J:J) = 'X'
         J = J + 1
      END DO
!
!     Account for 9 (IX).
!
      IF (LEFT .GE. 9) THEN
         LEFT = LEFT - 9
         ROM(J:J+1) = 'IX'
         J = J + 2
      END IF
!
!     Account for 5 (V).
!
      IF (LEFT .GE. 5) THEN
         LEFT = LEFT - 5
         ROM(J:J) = 'V'
         J = J + 1
      END IF
!
!     Account for 4 (IV).
!
      IF (LEFT .GE. 4) THEN
         LEFT = LEFT - 4
         ROM(J:J+1) = 'IV'
         J = J + 2
      END IF
!
!     Account for 1's (I).
!
      DO WHILE (LEFT .GE. 1)
         LEFT = LEFT - 1
         ROM(J:J) = 'I'
         J = J + 1
      END DO
!
!     End of code - return Roman numeral string and VALID flag.
!
      RETURN
      END SUBROUTINE ZROMAN
