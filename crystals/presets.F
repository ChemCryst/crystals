C $Log: not supported by cvs2svn $
C Revision 1.26  2000/12/01 17:06:51  richard
C RIC: Change default release year to 2000
C
CODE FOR DATA
      BLOCK DATA CRYBLK
C--PRESETS FOR THE CRYSTALS SYSTEM
C
\PLSTHN
C
\TLISTC
\TDVNAM
\TSSCHR
C
C
\UFILE
\XDISC
\XDISCB
\XDISCS
\XUNITS
\XTIMES
\XNWPGE
\XUNTNM
\XFILEC
\XFILE
\XLISTS
\XCNTRL
C----- THE SCRIPT STACK
\PSCSTI
      PARAMETER (IDMSTK = LSTACK*NSTACK)
\XSCSTK
\XCOMPD
\XCHARS
\XCONST
\XLISTI
\XLIMIT
\XCARDS
\XSYSHF
\XSYSDR
\XDIRTP
\XLEXIC
\XTAPES
\XTAPED
\XLST50
\XPRGNM
\XLEXCH
\XAPK
\XOPK
\XSCALE
\XSHORT
\XSTATS
\XFIRST
\XPCK06
C
C
\XDVNAM
C
\XLSTHN
C
\XSSCHR
C
\XSIZES
C
\XRGRP
C
\XERVAL
\XERCNT
\XLSVAL
\XOPVAL
\XSSVAL
\XDAVAL
\XCBVAL
C
\XSCCNT
\XSCCHR
\XSCGBL
\XSCMSG
C
\XMENUI
C
\XDRIVE
C
\OUTCOL
C LOAD THE LIST NAMES
C      
       DATA CLISTS(1)     /'Cell parameters'/
       DATA CLISTS(2)     /'Unit cell symmetry'/
       DATA CLISTS(3)     /'Atomic scattering factors'/
       DATA CLISTS(4)     /'SLQ Weighting scheme'/
       DATA CLISTS(5)     /'Atomic parameters'/
       DATA CLISTS(6)     /'Reflections'/
       DATA CLISTS(7)     /'Internal use'/
       DATA CLISTS(8)     /'Internal use'/
       DATA CLISTS(9)     /'Internal use'/
       DATA CLISTS(10)    /'Peak coordinates from Fourier'/
       DATA CLISTS(11)    /'Least squares normal matrix'/
       DATA CLISTS(12)    /'Refinement directives'/
       DATA CLISTS(13)    /'Crystal and collection data'/
       DATA CLISTS(14)    /'Fourier directives'/
       DATA CLISTS(15)    /'Internal use'/
       DATA CLISTS(16)    /'General Restraint instructions'/
       DATA CLISTS(17)    /'Special Restraint instructions'/
       DATA CLISTS(18)    /'Internal use'/
       DATA CLISTS(19)    /'Internal use'/
       DATA CLISTS(20)    /'Rotation and other matrices'/
       DATA CLISTS(21)    /'Internal use'/
       DATA CLISTS(22)    /'Refinement directives in internal format'/
       DATA CLISTS(23)    /'Structure factor calculation control list'/
       DATA CLISTS(24)    /'Least squares shift list'/
       DATA CLISTS(25)    /'Twin component operators'/
       DATA CLISTS(26)    /'Constraints in internal format'/
       DATA CLISTS(27)    /'Diffractometer batch scales'/
       DATA CLISTS(28)    /'Reflection exclusion limits'/
       DATA CLISTS(29)    /'Asymmetric unit and elemental properties'/
       DATA CLISTS(30)    /'Internal use'/
       DATA CLISTS(31)    /'Cell parameter E.S.D.s'/
       DATA CLISTS(32)    /'Internal use'/
       DATA CLISTS(33)    /'Internal use'/
       DATA CLISTS(34)    /'Internal use'/
       DATA CLISTS(35)    /'Internal use'/
       DATA CLISTS(36)    /'Internal use'/
C
C
C------ INITIALISE THE LINE COUNTER FOR PAGINATED OUTPUT
      DATA LDRV77 /0/, MDRV77 /22/, JNL77 /1/, JPMT77 /0/
C----- INITIALISE THE VMS SCREEN MANAGER
      DATA IMNFLG / 0 /, NPBR /24/, NPBCOL /80/
C
      DATA IACC/-1/,MLSS/15/
C
      DATA ISIZST / 131072 /, ISIZ11 / 1048576 /
C
&PPCC      SET INTERACTIVE UNDER MAC OS
&PPC      DATA IQUN /2/, JQUN/2/
&H-PC      INITIALISE THE ENVIRONMENT TO BATCH
&H-P      DATA IQUN /2/, JQUN/0/
&DOSC      SET INTERACTIVE UNDER DOS
&DOS      DATA IQUN /2/, JQUN/2/
&&DVFGIDC      SET INTERACTIVE UNDER WINDOWS
&&DVFGID      DATA IQUN /2/, JQUN/2/
&&GILLINC      SET INTERACTIVE UNDER LINUX
&&GILLIN      DATA IQUN /2/, JQUN/2/
&VAXC      INITIALISE THE ENVIRONMENT TO BATCH
&VAX      DATA IQUN /2/, JQUN/0/
C
C      INITIALISE THE TAPE USE STACK
      DATA NMTR /0/
C      INITIALISE THE DISK INDEX
      DATA INDEXF/424*0/, LIST/424*0/
C      INITIALISE THE LEXICAL COMMON BLOCK
      DATA LK,LK1,LK2,NWCARD,LARG,MARG,MDARG,NARG,
     2 LCRD,MCRD,MDCRD,NCRD,MA,MB,MC,MD,ME,MF,MG,MH,
     3 MI,MJ,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,Z
     4 /38*0/
C      INITIALISE THE PRINT LEVEL TO BE LOWEST
      DATA ISTAT2 /0/
C
C      INITIALISE THE SCRIPT STACK
      DATA ILEVEL/NFILVL*0/, ISTACK/IDMSTK*0/
C
 
C In this table, the CAPITAL characters in FORLOGNAM are used to identif
C unit in STORE instructions.
C        Keywords used in ATTATCH instructions to change the above values
C
C           Value
C
C             1                       SEQU   OLD    FORM   READ     FREE
C             2                       DIRE   NEW    UNFO   WRIT     LOCK
C             3                              CIF
C             4                              SCRA
C
C IFLUNI FORNU  FORLOGNAM     KEYFIL   IFLACC IFLSTA  IFLFRM IFLREA IFLO
C
C  1     1   NCDFu,NCRRu    DISCFILE    2      3      2      2      0
C  2     2   NCARu          HKLI        1      1      1      1      0
C  3     5   ncufu(1)       CONTROL     1      1      1      1      0
C  4     6   NCWU           PRINTER     1      2      1      2      0
C  5     7   NCPU           PUNCH       1      2      1      2      0
C  6     8   NCLU           LOG         1      2      1      2      0
C  7     3   NCAWu          MONITOR     1      2      1      2      0
C  8    11   NCSU           SPY         1      2      1      2      0
C  9    12   NCNDu          NEWDISC     2      2      2      2      0
C 10    14   NCCBu          EXCOMMON    1      4      1      2      0
C 11    15   NCIFu,NCLDu    COMMANDS    2      1      2      1      0
C 12    20   ncufu(2)(NCRU) USE1        1      1      1      1      0
C 13    21   ncufu(3)       USE2        1      1      1      1      0
C 14    22   ncufu(4)       USE3        1      1      1      1      0
C 15    23   ncufu(5)       USE4        1      1      1      1      0
C 16    52   MTA            M32         1      4      2      2      0
C 17    53   MTB            M33         1      4      2      2      0
C 18    48   MT1            MT1         1      4      2      2      0
C 19    49   MT2            MT2         1      4      2      2      0
C 20    50   MT3            MT3         1      4      2      2      0
C 21    51   MTE            MTE         1      4      2      2      0
C 22    63   NUSRQ          SRQ         1      4      1      2      0
C 23    71   NCFpu1         FORN1       1      3      1      2      0
C 24    72   NCFpu2         FORN2       1      3      1      2      0
C 25    88   NCeXTr         SCPDATA     1      1      1      1      0
C 26    89   NCQUe          SCPQUEUE    1      3      1      2      0
C 27     4   NUCoM          COMSRC      1      1      1      1      0
C 28    24   ncufu(6)       USE5        1      1      1      1      0
C 29    25   ncufu(7)       USE6        1      1      1      1      0
C 30    26   ncufu(8)       USE7        1      1      1      1      0
C 31    27   ncufu(9)       USE8        1      1      1      1      0
C 32    28   ncufu(10)      USE9        1      1      1      1      0
C 33     6   NcVDU          VDU         1      2      1      2      0
C 34     6   NCERor         ERROR       1      2      1      2      0
C 35    29   ncufu(11)      USE10       1      1      1      1      0
C 36    30   ncufu(12)      USE11       1      1      1      1      0
C 37    31   ncufu(13)      USE12       1      1      1      1      0
C 38    32   ncufu(14)      USE13       1      1      1      1      0
C 39    33   ncufu(15)      USE14       1      1      1      1      0
C 40    34   ncufu(16)      USE15       1      1      1      1      0
C 41    35   ncufu(17)      USE16       1      1      1      1      0
C 42    36   ncufu(18)      USE17       1      1      1      1      0
C 43    37   ncufu(19)      USE18       1      1      1      1      0
C 44    38   ncufu(20)      USE19       1      1      1      1      0
C 45    40   NCADu          ATOMS       1      2      1      2      0
C 46    41   NCMU           MENUE       1      2      1      2      0
C 47    42   NCCHw          CHART       1      2      1      2      0
C 48    43   NCPDu          PROGRESS    1      2      1      2      0
C 49    44   NCDBu          DIALOGUE    1      2      1      2      0
C
C
C
C----- ASSOCIATE  UNIT NUMBERS WITH NAMES TO BE USED IN DISK MESSAGES
C                   UNKNOWN , DATA,   COMMAND,  NEW DATA, COMMAND
      DATA IUNITN /       0,     1,         9,        12,      15 /
C----- ASSIGN I/O UNIT NUMBERS TO LOGICAL UNITS
C      THE DIRECT ACCESS DEVICES
C           DISCFILE,  DISCFILE,    NEWDISC,   COMMANDS,  COMMANDS
      DATA NCDFU /1/, NCRRU /1/, NCNDU /12/, NCIFU /15/, NCLDU /15/
C      THE COMMAND FILE SOURCE
      DATA NUCOM /4/
C      THE OUTPUT DEVICES
C       VDU, MONITOR, PRINTER, PUNCH, LOG, ERROR
&PPCC      PRINTER ASSIGNED IN JOB CONTROL LANGUAGE
&PPC      DATA NCVDU/6/, NCAWU/3/, NCWU/9/, NCPU/7/, NCLU/8/, NCEROR/6/
&H-PC      REASSIGN PRINTER IN STARTUP FILE
&H-P      DATA NCVDU/6/, NCAWU/6/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
&DOSC      REASSIGN PRINTER IN STARTUP FILE
&DOS      DATA NCVDU/6/, NCAWU/3/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
&&DVFGIDC      REASSIGN PRINTER IN STARTUP FILE
&GID      DATA NCVDU/6/, NCAWU/3/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
&DVF      DATA NCVDU/6/, NCAWU/3/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
&GIL      DATA NCVDU/6/, NCAWU/3/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
&LIN      DATA NCVDU/6/, NCAWU/3/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
&VAXC      PRINTER ASSIGNED IN JOB CONTROL LANGUAGE
&VAX      DATA NCVDU/6/, NCAWU/3/, NCWU/9/, NCPU/7/, NCLU/8/, NCEROR/6/
&DOS      DATA NCADU/40/, NCMU/41/, NCCHW/42/, NCPDU/43/, NCDBU/44/
&&DVFGID      DATA NCADU/40/, NCMU/41/, NCCHW/42/, NCPDU/43/, NCDBU/44/
&&GILLIN      DATA NCADU/40/, NCMU/41/, NCCHW/42/, NCPDU/43/, NCDBU/44/
&VAX      DATA NCADU/40/, NCMU/41/, NCCHW/42/, NCPDU/43/, NCDBU/44/
&PPC      DATA NCADU/40/, NCMU/41/, NCCHW/42/, NCPDU/43/, NCDBU/44/
C      THE AUXILLIARY INPUT DEVICE (REFLECTIONS)
      DATA NCARU /2/
C      THE SYSTEM SPY FILE
      DATA NCSU /11/
C      SYSTEM REQUEST QUEUE AND SEGMENTED SYSTEM COMMON BLOCK FILE
      DATA NUSRQ /63/, NCCBU /14/
C      INTERMEDIATE RESULT AND WORK FILES
      DATA MT1/48/, MT2/49/, MT3/50/, MTE/51/, MTA/52/, MTB/53/
C      THE SCRIPT QUEUE AND EXTRACT FILES
      DATA NCQUE /89/, NCEXTR /88/
C      THE FOREIGN PROGRAM LINKS
      DATA NCFPU1 /71/, NCFPU2 /72/
C
C -- SET INITIAL PARAMETERS FOR 'READ', AND FILE HANDLING IN GENERAL
C      THE CONTROL FILE PROPERTIES  - HELD IN COMMON BLOCK /UFILE/
C      THE MAXIMUM NO. OF CONTROL FILES IS SET IN IFLMAX
C----- ACTUAL I/O UNIT NUMBERS
      DATA NCUFU /5, 20, 21, 22, 23, 24, 25, 26, 27, 28,
     1     29, 30, 31, 32, 33, 34, 35, 36, 37, 38 /
C    INITIAL READ IS FROM SECOND LEVEL (NCUFU(2)) SO THAT WE CAN DROP
C    BACK TO CONTROL.
      DATA IFLIND / 2 /
C    NOTE THAT NCRU SHOULD BE THE SAME AS NCUFU(IFLIND) - SEE IMPLEMENT
      DATA NCRU /20/
C
      DATA IRDPAG / 20 / , IRDLIN / 0 /, IUSFLG / 0 /
      DATA IFLCHR / 1 , 2 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDCPY / 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDLOG / 1 , 0 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1,
     1  1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 /
      DATA IRDCAT / 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDCMS / 1 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDSRQ / 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDINC / 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1,
     1  1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 /
      DATA IRDFND / 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDREC / 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDHGH / 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
      DATA IRDSCR / 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0,
     1  0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 /
C
C
C     THE VALUES SET HERE SHOULD BE THE SAME AS THOSE DEFINED FOR THE
C     SYMBOLIC I/O UNITS ABOVE, AND ARE USED IN XRDSTR FOR REASSIGNING
C     UNITS
C
C      DISCFILE,  HKLI    ,  CONTROL ,  PRINTER ,  PUNCH
C      LOG     ,  MONITOR ,  SPY     ,  NEWDISC ,  EXCOMMON
C      COMMANDS,  USE1    ,  USE2    ,  USE3    ,  USE4
C      M32     ,  M33     ,  MT1     ,  MT2     ,  MT3
C      MTE     ,  SRQ     ,  FRN1DATA,  FRN2DATA,  SCPDATA
C      SCPQUEUE,  COMMSRC ,  USE5    ,  USE6    ,  USE7
C      USE8    ,  USE9    ,  VDU     , ERROR
C      USE10, USE11, USE12, USE13, USE14,
C      USE15, USE16, USE17, USE18, USE19
C      NCADU, NCMU, NCCHW, NCPDU, NCDBU
C
 
C
      DATA NFLUSD / 49 /
C
      DATA IFLUNI(1)  /  1 / , IFLUNI(2)  /  2 / , IFLUNI(3)  /  5 /
&PPC      DATA IFLUNI(4)  /  9 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
&H-P      DATA IFLUNI(4)  /  6 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
&DOS      DATA IFLUNI(4)  /  6 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
&GID      DATA IFLUNI(4)  /  6 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
&DVF      DATA IFLUNI(4)  /  6 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
&LIN      DATA IFLUNI(4)  /  6 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
&GIL      DATA IFLUNI(4)  /  6 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
&VAX      DATA IFLUNI(4)  /  9 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
C----- CHANGE IFLUNI(7) TO 3 LATER
      DATA IFLUNI(7)  /  6 / , IFLUNI(8)  / 11 / , IFLUNI(9)  / 12 /
      DATA IFLUNI(10) / 14 / , IFLUNI(11) / 15 / , IFLUNI(12) / 20 /
      DATA IFLUNI(13) / 21 / , IFLUNI(14) / 22 / , IFLUNI(15) / 23 /
      DATA IFLUNI(16) / 52 / , IFLUNI(17) / 53 / , IFLUNI(18) / 48 /
      DATA IFLUNI(19) / 49 / , IFLUNI(20) / 50 / , IFLUNI(21) / 51 /
      DATA IFLUNI(22) / 63 / , IFLUNI(23) / 71 / , IFLUNI(24) / 72 /
      DATA IFLUNI(25) / 88 / , IFLUNI(26) / 89 / , IFLUNI(27) /  4 /
      DATA IFLUNI(28) / 24 / , IFLUNI(29) / 25 / , IFLUNI(30) / 26 /
      DATA IFLUNI(31) / 27 / , IFLUNI(32) / 28 / , IFLUNI(33) / 6 /
      DATA IFLUNI(34) /  6 /
      DATA IFLUNI(35) / 29 / , IFLUNI(36) / 30 / , IFLUNI(37) / 31 /
      DATA IFLUNI(38) / 32 / , IFLUNI(39) / 33 / , IFLUNI(40) / 34 /
      DATA IFLUNI(41) / 35 / , IFLUNI(42) / 36 / , IFLUNI(43) / 37 /
      DATA IFLUNI(44) / 38 /
C---- THE GUI UNITS
      DATA IFLUNI(45) / 40 / , IFLUNI(46) / 41 / , IFLUNI(47) / 42 /
      DATA IFLUNI(48) / 43 / , IFLUNI(49) / 44 /
C
C
      DATA KEYFIL(1,1)  / 'D' / , KEYFIL(2,1)  / 'I' /
      DATA KEYFIL(3,1)  / 'S' / , KEYFIL(4,1)  / 'C' /
      DATA KEYFIL(5,1)  / 'F' / , KEYFIL(6,1)  / 'I' /
      DATA KEYFIL(7,1)  / 'L' / , KEYFIL(8,1)  / 'E' /
      DATA KEYFIL(1,2)  / 'H' / , KEYFIL(2,2)  / 'K' /
      DATA KEYFIL(3,2)  / 'L' / , KEYFIL(4,2)  / 'I' /
      DATA KEYFIL(5,2)  / ' ' / , KEYFIL(6,2)  / ' ' /
      DATA KEYFIL(7,2)  / ' ' / , KEYFIL(8,2)  / ' ' /
      DATA KEYFIL(1,3)  / 'C' / , KEYFIL(2,3)  / 'O' /
      DATA KEYFIL(3,3)  / 'N' / , KEYFIL(4,3)  / 'T' /
      DATA KEYFIL(5,3)  / 'R' / , KEYFIL(6,3)  / 'O' /
      DATA KEYFIL(7,3)  / 'L' / , KEYFIL(8,3)  / ' ' /
      DATA KEYFIL(1,4)  / 'P' / , KEYFIL(2,4)  / 'R' /
      DATA KEYFIL(3,4)  / 'I' / , KEYFIL(4,4)  / 'N' /
      DATA KEYFIL(5,4)  / 'T' / , KEYFIL(6,4)  / 'E' /
      DATA KEYFIL(7,4)  / 'R' / , KEYFIL(8,4)  / ' ' /
      DATA KEYFIL(1,5)  / 'P' / , KEYFIL(2,5)  / 'U' /
      DATA KEYFIL(3,5)  / 'N' / , KEYFIL(4,5)  / 'C' /
      DATA KEYFIL(5,5)  / 'H' / , KEYFIL(6,5)  / ' ' /
      DATA KEYFIL(7,5)  / ' ' / , KEYFIL(8,5)  / ' ' /
      DATA KEYFIL(1,6)  / 'L' / , KEYFIL(2,6)  / 'O' /
      DATA KEYFIL(3,6)  / 'G' / , KEYFIL(4,6)  / ' ' /
      DATA KEYFIL(5,6)  / ' ' / , KEYFIL(6,6)  / ' ' /
      DATA KEYFIL(7,6)  / ' ' / , KEYFIL(8,6)  / ' ' /
      DATA KEYFIL(1,7)  / 'M' / , KEYFIL(2,7)  / 'O' /
      DATA KEYFIL(3,7)  / 'N' / , KEYFIL(4,7)  / 'I' /
      DATA KEYFIL(5,7)  / 'T' / , KEYFIL(6,7)  / 'O' /
      DATA KEYFIL(7,7)  / 'R' / , KEYFIL(8,7)  / ' ' /
      DATA KEYFIL(1,8)  / 'S' / , KEYFIL(2,8)  / 'P' /
      DATA KEYFIL(3,8)  / 'Y' / , KEYFIL(4,8)  / ' ' /
      DATA KEYFIL(5,8)  / ' ' / , KEYFIL(6,8)  / ' ' /
      DATA KEYFIL(7,8)  / ' ' / , KEYFIL(8,8)  / ' ' /
      DATA KEYFIL(1,9)  / 'N' / , KEYFIL(2,9)  / 'E' /
      DATA KEYFIL(3,9)  / 'W' / , KEYFIL(4,9)  / 'D' /
      DATA KEYFIL(5,9)  / 'I' / , KEYFIL(6,9)  / 'S' /
      DATA KEYFIL(7,9)  / 'C' / , KEYFIL(8,9)  / ' ' /
      DATA KEYFIL(1,10) / 'E' / , KEYFIL(2,10) / 'X' /
      DATA KEYFIL(3,10) / 'C' / , KEYFIL(4,10) / 'O' /
      DATA KEYFIL(5,10) / 'M' / , KEYFIL(6,10) / 'M' /
      DATA KEYFIL(7,10) / 'O' / , KEYFIL(8,10) / 'N' /
      DATA KEYFIL(1,11) / 'C' / , KEYFIL(2,11) / 'O' /
      DATA KEYFIL(3,11) / 'M' / , KEYFIL(4,11) / 'M' /
      DATA KEYFIL(5,11) / 'A' / , KEYFIL(6,11) / 'N' /
      DATA KEYFIL(7,11) / 'D' / , KEYFIL(8,11) / 'S' /
      DATA KEYFIL(1,12) / 'U' / , KEYFIL(2,12) / 'S' /
      DATA KEYFIL(3,12) / 'E' / , KEYFIL(4,12) / '1' /
      DATA KEYFIL(5,12) / ' ' / , KEYFIL(6,12) / ' ' /
      DATA KEYFIL(7,12) / ' ' / , KEYFIL(8,12) / ' ' /
      DATA KEYFIL(1,13) / 'U' / , KEYFIL(2,13) / 'S' /
      DATA KEYFIL(3,13) / 'E' / , KEYFIL(4,13) / '2' /
      DATA KEYFIL(5,13) / ' ' / , KEYFIL(6,13) / ' ' /
      DATA KEYFIL(7,13) / ' ' / , KEYFIL(8,13) / ' ' /
      DATA KEYFIL(1,14) / 'U' / , KEYFIL(2,14) / 'S' /
      DATA KEYFIL(3,14) / 'E' / , KEYFIL(4,14) / '3' /
      DATA KEYFIL(5,14) / ' ' / , KEYFIL(6,14) / ' ' /
      DATA KEYFIL(7,14) / ' ' / , KEYFIL(8,14) / ' ' /
      DATA KEYFIL(1,15) / 'U' / , KEYFIL(2,15) / 'S' /
      DATA KEYFIL(3,15) / 'E' / , KEYFIL(4,15) / '4' /
      DATA KEYFIL(5,15) / ' ' / , KEYFIL(6,15) / ' ' /
      DATA KEYFIL(7,15) / ' ' / , KEYFIL(8,15) / ' ' /
      DATA KEYFIL(1,16) / 'M' / , KEYFIL(2,16) / '3' /
      DATA KEYFIL(3,16) / '2' / , KEYFIL(4,16) / ' ' /
      DATA KEYFIL(5,16) / ' ' / , KEYFIL(6,16) / ' ' /
      DATA KEYFIL(7,16) / ' ' / , KEYFIL(8,16) / ' ' /
      DATA KEYFIL(1,17) / 'M' / , KEYFIL(2,17) / '3' /
      DATA KEYFIL(3,17) / '3' / , KEYFIL(4,17) / ' ' /
      DATA KEYFIL(5,17) / ' ' / , KEYFIL(6,17) / ' ' /
      DATA KEYFIL(7,17) / ' ' / , KEYFIL(8,17) / ' ' /
      DATA KEYFIL(1,18) / 'M' / , KEYFIL(2,18) / 'T' /
      DATA KEYFIL(3,18) / '1' / , KEYFIL(4,18) / ' ' /
      DATA KEYFIL(5,18) / ' ' / , KEYFIL(6,18) / ' ' /
      DATA KEYFIL(7,18) / ' ' / , KEYFIL(8,18) / ' ' /
      DATA KEYFIL(1,19) / 'M' / , KEYFIL(2,19) / 'T' /
      DATA KEYFIL(3,19) / '2' / , KEYFIL(4,19) / ' ' /
      DATA KEYFIL(5,19) / ' ' / , KEYFIL(6,19) / ' ' /
      DATA KEYFIL(7,19) / ' ' / , KEYFIL(8,19) / ' ' /
      DATA KEYFIL(1,20) / 'M' / , KEYFIL(2,20) / 'T' /
      DATA KEYFIL(3,20) / '3' / , KEYFIL(4,20) / ' ' /
      DATA KEYFIL(5,20) / ' ' / , KEYFIL(6,20) / ' ' /
      DATA KEYFIL(7,20) / ' ' / , KEYFIL(8,20) / ' ' /
      DATA KEYFIL(1,21) / 'M' / , KEYFIL(2,21) / 'T' /
      DATA KEYFIL(3,21) / 'E' / , KEYFIL(4,21) / ' ' /
      DATA KEYFIL(5,21) / ' ' / , KEYFIL(6,21) / ' ' /
      DATA KEYFIL(7,21) / ' ' / , KEYFIL(8,21) / ' ' /
      DATA KEYFIL(1,22) / 'S' / , KEYFIL(2,22) / 'R' /
      DATA KEYFIL(3,22) / 'Q' / , KEYFIL(4,22) / ' ' /
      DATA KEYFIL(5,22) / ' ' / , KEYFIL(6,22) / ' ' /
      DATA KEYFIL(7,22) / ' ' / , KEYFIL(8,22) / ' ' /
      DATA KEYFIL(1,23) / 'F' / , KEYFIL(2,23) / 'R' /
      DATA KEYFIL(3,23) / 'N' / , KEYFIL(4,23) / '1' /
      DATA KEYFIL(5,23) / 'D' / , KEYFIL(6,23) / 'A' /
      DATA KEYFIL(7,23) / 'T' / , KEYFIL(8,23) / 'A' /
      DATA KEYFIL(1,24) / 'F' / , KEYFIL(2,24) / 'R' /
      DATA KEYFIL(3,24) / 'N' / , KEYFIL(4,24) / '2' /
      DATA KEYFIL(5,24) / 'D' / , KEYFIL(6,24) / 'A' /
      DATA KEYFIL(7,24) / 'T' / , KEYFIL(8,24) / 'A' /
      DATA KEYFIL(1,25) / 'S' / , KEYFIL(2,25) / 'C' /
      DATA KEYFIL(3,25) / 'P' / , KEYFIL(4,25) / 'D' /
      DATA KEYFIL(5,25) / 'A' / , KEYFIL(6,25) / 'T' /
      DATA KEYFIL(7,25) / 'A' / , KEYFIL(8,25) / ' ' /
      DATA KEYFIL(1,26) / 'S' / , KEYFIL(2,26) / 'C' /
      DATA KEYFIL(3,26) / 'P' / , KEYFIL(4,26) / 'Q' /
      DATA KEYFIL(5,26) / 'U' / , KEYFIL(6,26) / 'E' /
      DATA KEYFIL(7,26) / 'U' / , KEYFIL(8,26) / 'E' /
      DATA KEYFIL(1,27) / 'C' / , KEYFIL(2,27) / 'O' /
      DATA KEYFIL(3,27) / 'M' / , KEYFIL(4,27) / 'S' /
      DATA KEYFIL(5,27) / 'R' / , KEYFIL(6,27) / 'C' /
      DATA KEYFIL(7,27) / ' ' / , KEYFIL(8,27) / ' ' /
      DATA KEYFIL(1,28) / 'U' / , KEYFIL(2,28) / 'S' /
      DATA KEYFIL(3,28) / 'E' / , KEYFIL(4,28) / '5' /
      DATA KEYFIL(5,28) / ' ' / , KEYFIL(6,28) / ' ' /
      DATA KEYFIL(7,28) / ' ' / , KEYFIL(8,28) / ' ' /
      DATA KEYFIL(1,29) / 'U' / , KEYFIL(2,29) / 'S' /
      DATA KEYFIL(3,29) / 'E' / , KEYFIL(4,29) / '6' /
      DATA KEYFIL(5,29) / ' ' / , KEYFIL(6,29) / ' ' /
      DATA KEYFIL(7,29) / ' ' / , KEYFIL(8,29) / ' ' /
      DATA KEYFIL(1,30) / 'U' / , KEYFIL(2,30) / 'S' /
      DATA KEYFIL(3,30) / 'E' / , KEYFIL(4,30) / '7' /
      DATA KEYFIL(5,30) / ' ' / , KEYFIL(6,30) / ' ' /
      DATA KEYFIL(7,30) / ' ' / , KEYFIL(8,30) / ' ' /
      DATA KEYFIL(1,31) / 'U' / , KEYFIL(2,31) / 'S' /
      DATA KEYFIL(3,31) / 'E' / , KEYFIL(4,31) / '8' /
      DATA KEYFIL(5,31) / ' ' / , KEYFIL(6,31) / ' ' /
      DATA KEYFIL(7,31) / ' ' / , KEYFIL(8,31) / ' ' /
      DATA KEYFIL(1,32) / 'U' / , KEYFIL(2,32) / 'S' /
      DATA KEYFIL(3,32) / 'E' / , KEYFIL(4,32) / '9' /
      DATA KEYFIL(5,32) / ' ' / , KEYFIL(6,32) / ' ' /
      DATA KEYFIL(7,32) / ' ' / , KEYFIL(8,32) / ' ' /
      DATA KEYFIL(1,33) / 'V' / , KEYFIL(2,33) / 'D' /
      DATA KEYFIL(3,33) / 'U' / , KEYFIL(4,33) / ' ' /
      DATA KEYFIL(5,33) / ' ' / , KEYFIL(6,33) / ' ' /
      DATA KEYFIL(7,33) / ' ' / , KEYFIL(8,33) / ' ' /
      DATA KEYFIL(1,34) / 'E' / , KEYFIL(2,34) / 'R' /
      DATA KEYFIL(3,34) / 'R' / , KEYFIL(4,34) / 'O' /
      DATA KEYFIL(5,34) / 'R' / , KEYFIL(6,34) / ' ' /
      DATA KEYFIL(7,34) / ' ' / , KEYFIL(8,34) / ' ' /
      DATA KEYFIL(1,35) / 'U' / , KEYFIL(2,35) / 'S' /
      DATA KEYFIL(3,35) / 'E' / , KEYFIL(4,35) / '1' /
      DATA KEYFIL(5,35) / '0' / , KEYFIL(6,35) / ' ' /
      DATA KEYFIL(7,35) / ' ' / , KEYFIL(8,35) / ' ' /
      DATA KEYFIL(1,36) / 'U' / , KEYFIL(2,36) / 'S' /
      DATA KEYFIL(3,36) / 'E' / , KEYFIL(4,36) / '1' /
      DATA KEYFIL(5,36) / '1' / , KEYFIL(6,36) / ' ' /
      DATA KEYFIL(7,36) / ' ' / , KEYFIL(8,36) / ' ' /
      DATA KEYFIL(1,37) / 'U' / , KEYFIL(2,37) / 'S' /
      DATA KEYFIL(3,37) / 'E' / , KEYFIL(4,37) / '1' /
      DATA KEYFIL(5,37) / '2' / , KEYFIL(6,37) / ' ' /
      DATA KEYFIL(7,37) / ' ' / , KEYFIL(8,37) / ' ' /
      DATA KEYFIL(1,38) / 'U' / , KEYFIL(2,38) / 'S' /
      DATA KEYFIL(3,38) / 'E' / , KEYFIL(4,38) / '1' /
      DATA KEYFIL(5,38) / '3' / , KEYFIL(6,38) / ' ' /
      DATA KEYFIL(7,38) / ' ' / , KEYFIL(8,38) / ' ' /
      DATA KEYFIL(1,39) / 'U' / , KEYFIL(2,39) / 'S' /
      DATA KEYFIL(3,39) / 'E' / , KEYFIL(4,39) / '1' /
      DATA KEYFIL(5,39) / '4' / , KEYFIL(6,39) / ' ' /
      DATA KEYFIL(7,39) / ' ' / , KEYFIL(8,39) / ' ' /
      DATA KEYFIL(1,40) / 'U' / , KEYFIL(2,40) / 'S' /
      DATA KEYFIL(3,40) / 'E' / , KEYFIL(4,40) / '1' /
      DATA KEYFIL(5,40) / '5' / , KEYFIL(6,40) / ' ' /
      DATA KEYFIL(7,40) / ' ' / , KEYFIL(8,40) / ' ' /
      DATA KEYFIL(1,41) / 'U' / , KEYFIL(2,41) / 'S' /
      DATA KEYFIL(3,41) / 'E' / , KEYFIL(4,41) / '1' /
      DATA KEYFIL(5,41) / '6' / , KEYFIL(6,41) / ' ' /
      DATA KEYFIL(7,41) / ' ' / , KEYFIL(8,41) / ' ' /
      DATA KEYFIL(1,42) / 'U' / , KEYFIL(2,42) / 'S' /
      DATA KEYFIL(3,42) / 'E' / , KEYFIL(4,42) / '1' /
      DATA KEYFIL(5,42) / '7' / , KEYFIL(6,42) / ' ' /
      DATA KEYFIL(7,42) / ' ' / , KEYFIL(8,42) / ' ' /
      DATA KEYFIL(1,43) / 'U' / , KEYFIL(2,43) / 'S' /
      DATA KEYFIL(3,43) / 'E' / , KEYFIL(4,43) / '1' /
      DATA KEYFIL(5,43) / '8' / , KEYFIL(6,43) / ' ' /
      DATA KEYFIL(7,43) / ' ' / , KEYFIL(8,43) / ' ' /
      DATA KEYFIL(1,44) / 'U' / , KEYFIL(2,44) / 'S' /
      DATA KEYFIL(3,44) / 'E' / , KEYFIL(4,44) / '1' /
      DATA KEYFIL(5,44) / '9' / , KEYFIL(6,44) / ' ' /
      DATA KEYFIL(7,44) / ' ' / , KEYFIL(8,44) / ' ' /
C
      DATA KEYFIL(1,45) / 'A' / , KEYFIL(2,45) / 'T' /
      DATA KEYFIL(3,45) / 'O' / , KEYFIL(4,45) / 'M' /
      DATA KEYFIL(5,45) / 'S' / , KEYFIL(6,45) / ' ' /
      DATA KEYFIL(7,45) / ' ' / , KEYFIL(8,45) / ' ' /
      DATA KEYFIL(1,46) / 'M' / , KEYFIL(2,46) / 'E' /
      DATA KEYFIL(3,46) / 'N' / , KEYFIL(4,46) / 'U' /
      DATA KEYFIL(5,46) / 'E' / , KEYFIL(6,46) / ' ' /
      DATA KEYFIL(7,46) / ' ' / , KEYFIL(8,46) / ' ' /
      DATA KEYFIL(1,47) / 'C' / , KEYFIL(2,47) / 'H' /
      DATA KEYFIL(3,47) / 'A' / , KEYFIL(4,47) / 'R' /
      DATA KEYFIL(5,47) / 'T' / , KEYFIL(6,47) / ' ' /
      DATA KEYFIL(7,47) / ' ' / , KEYFIL(8,47) / ' ' /
      DATA KEYFIL(1,48) / 'P' / , KEYFIL(2,48) / 'R' /
      DATA KEYFIL(3,48) / 'O' / , KEYFIL(4,48) / 'G' /
      DATA KEYFIL(5,48) / 'R' / , KEYFIL(6,48) / 'E' /
      DATA KEYFIL(7,48) / 'S' / , KEYFIL(8,48) / 'S' /
      DATA KEYFIL(1,49) / 'D' / , KEYFIL(2,49) / 'I' /
      DATA KEYFIL(3,49) / 'A' / , KEYFIL(4,49) / 'L' /
      DATA KEYFIL(5,49) / 'O' / , KEYFIL(6,49) / 'G' /
      DATA KEYFIL(7,49) / 'U' / , KEYFIL(8,49) / 'E' /
C
      DATA IFLACC(1)  / 2 / , IFLACC(2)  / 1 / , IFLACC(3)  / 1 /
      DATA IFLACC(4)  / 1 / , IFLACC(5)  / 1 / , IFLACC(6)  / 1 /
      DATA IFLACC(7)  / 1 / , IFLACC(8)  / 1 / , IFLACC(9)  / 2 /
      DATA IFLACC(10) / 1 / , IFLACC(11) / 2 / , IFLACC(12) / 1 /
      DATA IFLACC(13) / 1 / , IFLACC(14) / 1 / , IFLACC(15) / 1 /
      DATA IFLACC(16) / 1 / , IFLACC(17) / 1 / , IFLACC(18) / 1 /
      DATA IFLACC(19) / 1 / , IFLACC(20) / 1 / , IFLACC(21) / 1 /
      DATA IFLACC(22) / 1 / , IFLACC(23) / 1 / , IFLACC(24) / 1 /
      DATA IFLACC(25) / 1 / , IFLACC(26) / 1 / , IFLACC(27) / 1 /
      DATA IFLACC(28) / 1 / , IFLACC(29) / 1 / , IFLACC(30) / 1 /
      DATA IFLACC(31) / 1 / , IFLACC(32) / 1 / , IFLACC(33) / 1 /
      DATA IFLACC(34) / 1 /
      DATA IFLACC(35) / 1 / , IFLACC(36) / 1 / , IFLACC(37) / 1 /
      DATA IFLACC(38) / 1 / , IFLACC(39) / 1 / , IFLACC(40) / 1 /
      DATA IFLACC(41) / 1 / , IFLACC(42) / 1 / , IFLACC(43) / 1 /
      DATA IFLACC(44) / 1 /
      DATA IFLACC(45) / 1 / , IFLACC(46) / 1 / , IFLACC(47) / 1 /
      DATA IFLACC(48) / 1 / , IFLACC(49) / 1 /
C
      DATA IFLSTA(1)  / 3 / , IFLSTA(2)  / 1 / , IFLSTA(3)  / 1 /
      DATA IFLSTA(4)  / 2 / , IFLSTA(5)  / 2 / , IFLSTA(6)  / 2 /
      DATA IFLSTA(7)  / 2 / , IFLSTA(8)  / 2 / , IFLSTA(9)  / 2 /
      DATA IFLSTA(10) / 4 / , IFLSTA(11) / 1 / , IFLSTA(12) / 1 /
      DATA IFLSTA(13) / 1 / , IFLSTA(14) / 1 / , IFLSTA(15) / 1 /
      DATA IFLSTA(16) / 4 / , IFLSTA(17) / 4 / , IFLSTA(18) / 4 /
      DATA IFLSTA(19) / 4 / , IFLSTA(20) / 4 / , IFLSTA(21) / 4 /
      DATA IFLSTA(22) / 4 / , IFLSTA(23) / 3 / , IFLSTA(24) / 3 /
      DATA IFLSTA(25) / 1 / , IFLSTA(26) / 4 / , IFLSTA(27) / 1 /
      DATA IFLSTA(28) / 1 / , IFLSTA(29) / 1 / , IFLSTA(30) / 1 /
      DATA IFLSTA(31) / 1 / , IFLSTA(32) / 1 / , IFLSTA(33) / 3 /
      DATA IFLSTA(34) / 1 /
      DATA IFLSTA(35) / 1 / , IFLSTA(36) / 1 / , IFLSTA(37) / 1 /
      DATA IFLSTA(38) / 1 / , IFLSTA(39) / 1 / , IFLSTA(40) / 1 /
      DATA IFLSTA(41) / 1 / , IFLSTA(42) / 1 / , IFLSTA(43) / 1 /
      DATA IFLSTA(44) / 1 /
      DATA IFLSTA(45) / 1 / , IFLSTA(46) / 1 / , IFLSTA(47) / 1 /
      DATA IFLSTA(48) / 1 / , IFLSTA(49) / 1 /
C
      DATA IFLFRM(1)  / 2 / , IFLFRM(2)  / 1 / , IFLFRM(3)  / 1 /
      DATA IFLFRM(4)  / 1 / , IFLFRM(5)  / 1 / , IFLFRM(6)  / 1 /
      DATA IFLFRM(7)  / 1 / , IFLFRM(8)  / 1 / , IFLFRM(9)  / 2 /
      DATA IFLFRM(10) / 1 / , IFLFRM(11) / 2 / , IFLFRM(12) / 1 /
      DATA IFLFRM(13) / 1 / , IFLFRM(14) / 1 / , IFLFRM(15) / 1 /
      DATA IFLFRM(16) / 2 / , IFLFRM(17) / 2 / , IFLFRM(18) / 2 /
      DATA IFLFRM(19) / 2 / , IFLFRM(20) / 2 / , IFLFRM(21) / 2 /
      DATA IFLFRM(22) / 1 / , IFLFRM(23) / 1 / , IFLFRM(24) / 1 /
      DATA IFLFRM(25) / 1 / , IFLFRM(26) / 1 / , IFLFRM(27) / 1 /
      DATA IFLFRM(28) / 1 / , IFLFRM(29) / 1 / , IFLFRM(30) / 1 /
      DATA IFLFRM(31) / 1 / , IFLFRM(32) / 1 / , IFLFRM(33) / 1 /
      DATA IFLFRM(34) / 1 /
      DATA IFLFRM(35) / 1 / , IFLFRM(36) / 1 / , IFLFRM(37) / 1 /
      DATA IFLFRM(38) / 1 / , IFLFRM(39) / 1 / , IFLFRM(40) / 1 /
      DATA IFLFRM(41) / 1 / , IFLFRM(42) / 1 / , IFLFRM(43) / 1 /
      DATA IFLFRM(44) / 1 /
      DATA IFLFRM(45) / 1 / , IFLFRM(46) / 1 / , IFLFRM(47) / 1 /
      DATA IFLFRM(48) / 1 / , IFLFRM(49) / 1 /
C
      DATA IFLREA(1)  / 2 / , IFLREA(2)  / 1 / , IFLREA(3)  / 1 /
      DATA IFLREA(4)  / 2 / , IFLREA(5)  / 2 / , IFLREA(6)  / 2 /
      DATA IFLREA(7)  / 2 / , IFLREA(8)  / 2 / , IFLREA(9)  / 2 /
      DATA IFLREA(10) / 2 / , IFLREA(11) / 1 / , IFLREA(12) / 1 /
      DATA IFLREA(13) / 1 / , IFLREA(14) / 1 / , IFLREA(15) / 1 /
      DATA IFLREA(16) / 2 / , IFLREA(17) / 2 / , IFLREA(18) / 2 /
      DATA IFLREA(19) / 2 / , IFLREA(20) / 2 / , IFLREA(21) / 2 /
      DATA IFLREA(22) / 2 / , IFLREA(23) / 2 / , IFLREA(24) / 2 /
      DATA IFLREA(25) / 1 / , IFLREA(26) / 2 / , IFLREA(27) / 1 /
      DATA IFLREA(28) / 1 / , IFLREA(29) / 1 / , IFLREA(30) / 1 /
      DATA IFLREA(31) / 1 / , IFLREA(32) / 1 / , IFLREA(33) / 2 /
      DATA IFLREA(34) / 1 /
      DATA IFLREA(35) / 1 / , IFLREA(36) / 1 / , IFLREA(37) / 1 /
      DATA IFLREA(38) / 1 / , IFLREA(39) / 1 / , IFLREA(40) / 1 /
      DATA IFLREA(41) / 1 / , IFLREA(42) / 1 / , IFLREA(43) / 1 /
      DATA IFLREA(44) / 1 /
      DATA IFLREA(45) / 1 / , IFLREA(46) / 1 / , IFLREA(47) / 1 /
      DATA IFLREA(48) / 1 / , IFLREA(49) / 1 /
C
      DATA IFLOPN(1)  / 0 / , IFLOPN(2)  / 0 / , IFLOPN(3)  / 0 /
      DATA IFLOPN(4)  / 0 / , IFLOPN(5)  / 0 / , IFLOPN(6)  / 0 /
      DATA IFLOPN(7)  / 0 / , IFLOPN(8)  / 0 / , IFLOPN(9)  / 0 /
      DATA IFLOPN(10) / 0 / , IFLOPN(11) / 0 / , IFLOPN(12) / 0 /
      DATA IFLOPN(13) / 0 / , IFLOPN(14) / 0 / , IFLOPN(15) / 0 /
      DATA IFLOPN(16) / 0 / , IFLOPN(17) / 0 / , IFLOPN(18) / 0 /
      DATA IFLOPN(19) / 0 / , IFLOPN(20) / 0 / , IFLOPN(21) / 0 /
      DATA IFLOPN(22) / 0 / , IFLOPN(23) / 0 / , IFLOPN(24) / 0 /
      DATA IFLOPN(25) / 0 / , IFLOPN(26) / 0 / , IFLOPN(27) / 0 /
      DATA IFLOPN(28) / 0 / , IFLOPN(29) / 0 / , IFLOPN(30) / 0 /
      DATA IFLOPN(31) / 0 / , IFLOPN(32) / 0 / , IFLOPN(33) / 0 /
      DATA IFLOPN(34) / 0 /
      DATA IFLOPN(35) / 0 / , IFLOPN(36) / 0 / , IFLOPN(37) / 0 /
      DATA IFLOPN(38) / 0 / , IFLOPN(39) / 0 / , IFLOPN(40) / 0 /
      DATA IFLOPN(41) / 0 / , IFLOPN(42) / 0 / , IFLOPN(43) / 0 /
      DATA IFLOPN(44) / 0 /
      DATA IFLOPN(45) / 0 / , IFLOPN(46) / 0 / , IFLOPN(47) / 0 /
      DATA IFLOPN(48) / 0 / , IFLOPN(49) / 0 /
C
      DATA IFLLCK(1)  / 2 / , IFLLCK(2)  / 1 / , IFLLCK(3)  / 2 /
      DATA IFLLCK(4)  / 1 / , IFLLCK(5)  / 1 / , IFLLCK(6)  / 1 /
      DATA IFLLCK(7)  / 1 / , IFLLCK(8)  / 2 / , IFLLCK(9)  / 1 /
      DATA IFLLCK(10) / 2 / , IFLLCK(11) / 2 / , IFLLCK(12) / 1 /
      DATA IFLLCK(13) / 1 / , IFLLCK(14) / 1 / , IFLLCK(15) / 1 /
      DATA IFLLCK(16) / 1 / , IFLLCK(17) / 1 / , IFLLCK(18) / 1 /
      DATA IFLLCK(19) / 1 / , IFLLCK(20) / 1 / , IFLLCK(21) / 1 /
      DATA IFLLCK(22) / 2 / , IFLLCK(23) / 1 / , IFLLCK(24) / 1 /
      DATA IFLLCK(25) / 1 / , IFLLCK(26) / 1 / , IFLLCK(27) / 1 /
      DATA IFLLCK(28) / 1 / , IFLLCK(29) / 1 / , IFLLCK(30) / 1 /
      DATA IFLLCK(31) / 1 / , IFLLCK(32) / 1 / , IFLLCK(33) / 1 /
      DATA IFLLCK(34) / 1 /
      DATA IFLLCK(35) / 1 / , IFLLCK(36) / 1 / , IFLLCK(37) / 1 /
      DATA IFLLCK(38) / 1 / , IFLLCK(39) / 1 / , IFLLCK(40) / 1 /
      DATA IFLLCK(41) / 1 / , IFLLCK(42) / 1 / , IFLLCK(43) / 1 /
      DATA IFLLCK(44) / 1 /
      DATA IFLLCK(45) / 1 / , IFLLCK(46) / 1 / , IFLLCK(47) / 1 /
      DATA IFLLCK(48) / 1 / , IFLLCK(49) / 1 /
C
C
      DATA IPAGE(1)/10/,IPAGE(2)/8/,IPAGE(3)/120/,IPAGE(4)/88/
      DATA IPAGE(5)/20/
C
      DATA Q(1)/0.0/,Q(2)/0.0/,Q(3)/0.0/,Q(4)/0.0/
      DATA QQ(1)/0.0/,QQ(2)/0.0/,QQ(3)/0.0/,QQ(4)/0.0/
C
      DATA NWPAGE/-1/
C
      DATA IFILE/1000000/,ILIST/1100000/,IEND/1111111/
      DATA LNFLE/416/,LNLST/416/,IACCL/-1/
C
&HOL      DATA KTITL( 1)/4HTHIS/,KTITL( 2)/4H IS /,KTITL( 3)/4HTHE /
&HOL      DATA KTITL( 4)/4HDEFA/,KTITL( 5)/4HULT /,KTITL( 6)/4HSETT/
&HOL      DATA KTITL( 7)/4HING /,KTITL( 8)/4HFOR /,KTITL( 9)/4HTHE /
&HOL      DATA KTITL(10)/4HTITL/,KTITL(11)/4HE, P/,KTITL(12)/4HROVI/
&HOL      DATA KTITL(13)/4HDED /,KTITL(14)/4HWHEN/,KTITL(15)/4H NO /
&HOL      DATA KTITL(16)/4HUSER/,KTITL(17)/4H TIT/,KTITL(18)/4HLE I/
&HOL      DATA KTITL(19)/4HS GI/,KTITL(20)/4HVEN./
C
#HOL      DATA KTITL( 1)/'THIS'/,KTITL( 2)/' IS '/,KTITL( 3)/'THE '/
#HOL      DATA KTITL( 4)/'DEFA'/,KTITL( 5)/'ULT '/,KTITL( 6)/'SETT'/
#HOL      DATA KTITL( 7)/'ING '/,KTITL( 8)/'FOR '/,KTITL( 9)/'THE '/
#HOL      DATA KTITL(10)/'TITL'/,KTITL(11)/'E, P'/,KTITL(12)/'ROVI'/
#HOL      DATA KTITL(13)/'DED '/,KTITL(14)/'WHEN'/,KTITL(15)/' NO '/
#HOL      DATA KTITL(16)/'USER'/,KTITL(17)/' TIT'/,KTITL(18)/'LE I'/
#HOL      DATA KTITL(19)/'S GI'/,KTITL(20)/'VEN.'/
C
C
      DATA IB / ' ' /
      DATA IH / '#' /
      DATA NUMB( 1)/'0'/,NUMB( 2)/'1'/,NUMB( 3)/'2'/,NUMB( 4)/'3'/
      DATA NUMB( 5)/'4'/,NUMB( 6)/'5'/,NUMB( 7)/'6'/,NUMB( 8)/'7'/
      DATA NUMB( 9)/'8'/,NUMB(10)/'9'/
      DATA IPLUS/'+'/,MINUS/'-'/,IA/'*'/,ISLASH/'/'/,IEXP/'**'/
      DATA ILB/'('/,IRB/')'/,ICOMMA/','/,IEQUAL/'='/,IPOINT/'.'/
      DATA ISEMIC/';'/,IQ/'?'/,IX(1)/'X'/,IX(2)/'Y'/,IX(3)/'Z'/
C
      DATA NOWT/-1000000/
      DATA UISO/0.0000005/,ZERO/0.00005/,VALUE/0.0001/
C
      DATA MD0/8/,N0/0/,LN/0/,LSN/0/,IREC/0/,LEF/0/,LSTLEF/0/,MAPS/0/
C
      DATA IENDC/-1111111/
C
      DATA NC/-1/,ND/-1/,LASTCH/80/,NI/0/,NILAST/-2/,NS/1/,MON/0/
      DATA ICAT/1/,IEOF/0/,IHFLAG/-1/,NREC/0/,IPOSRQ/0/,IMNSRQ/0/
      DATA ITYPFL/1/,INSTR/0/,IDIRFL/-1/,IPARAM/-1/,IPARAD/-1/
      DATA NWCHAR/4/
C
C -- DEFINE SYSTEM INSTRUCTIONS
cdjwmar99
      DATA NWHF / 4 / , NHF / 19 / , LHF / 4 /
C
C      'PAUS'      'HELP'      'SET '      'ATTA'      'OPEN'
C      'RELE'      'USE '      'MANU'      'TYPE'      'REMO'
C      'STOR'      'STAR'      'SCRI'      'COMM'      'CLOS'
C      'SPAW'      '$   '      'APPE'      'BENC'
C
C
      DATA IHF / 'P', 'A', 'U', 'S', 'H', 'E', 'L', 'P',
     2           'S', 'E', 'T', ' ', 'A', 'T', 'T', 'A',
     3           'O', 'P', 'E', 'N', 'R', 'E', 'L', 'E',
     4           'U', 'S', 'E', ' ', 'M', 'A', 'N', 'U',
     5           'T', 'Y', 'P', 'E', 'R', 'E', 'M', 'O',
     6           'S', 'T', 'O', 'R', 'S', 'T', 'A', 'R',
     7           'S', 'C', 'R', 'I', 'C', 'O', 'M', 'M',
     8           'C', 'L', 'O', 'S', 'S', 'P', 'A', 'W',
     9           '$', ' ', ' ', ' ', 'A', 'P', 'P', 'E',
     1           'B', 'E', 'N', 'C'  /
C
C
C
      DATA NWSPD/12/,NSPD/2/,LSPD/13/
      DATA ISPD(1,1)/8/
      DATA ISPD( 2,1)/'C'/,ISPD( 3,1)/'O'/,ISPD( 4,1)/'N'/
      DATA ISPD( 5,1)/'T'/,ISPD( 6,1)/'I'/,ISPD( 7,1)/'N'/
      DATA ISPD( 8,1)/'U'/,ISPD( 9,1)/'E'/,ISPD(10,1)/' '/
      DATA ISPD(11,1)/' '/,ISPD(12,1)/' '/,ISPD(13,1)/' '/
      DATA ISPD(1,2)/3/
      DATA ISPD( 2,2)/'E'/,ISPD( 3,2)/'N'/,ISPD( 4,2)/'D'/
      DATA ISPD( 5,2)/' '/,ISPD( 6,2)/' '/,ISPD( 7,2)/' '/
      DATA ISPD( 8,2)/' '/,ISPD( 9,2)/' '/,ISPD(10,2)/' '/
      DATA ISPD(11,2)/' '/,ISPD(12,2)/' '/,ISPD(13,2)/' '/
C
      DATA IDTYPE(1,1)/'INST'/,IDTYPE(2,1)/'RUCT'/,IDTYPE(3,1)/'ION '/
      DATA IDTYPE(1,2)/' DIR'/,IDTYPE(2,2)/'ECTI'/,IDTYPE(3,2)/'VE  '/
      DATA IDTYPE(1,3)/' PAR'/,IDTYPE(2,3)/'AMET'/,IDTYPE(3,3)/'ER  '/
      DATA IDTYPE(1,4)/'INPU'/,IDTYPE(2,4)/'T VA'/,IDTYPE(3,4)/'LUE '/
C
      DATA LK/2/,LK1/3/,LK2/4/,NWCARD/20/
C
C
      DATA LCOM/13/,MCOM/29/,MDCOM/4/,NCOM/5/
      DATA MULT50/10000/,IDIM50/32/,LSTOFF/3/
C
&HOL      DATA KPRGNM( 1)/4H    /,KPRGNM( 2)/4H    /,KPRGNM( 3)/4H    /
&HOL      DATA KPRGNM( 4)/4H    /,KPRGNM( 5)/4H    /,KPRGNM( 6)/4H    /
&HOL      DATA KPRGNM( 7)/4H    /,KPRGNM( 8)/4H    /,KPRGNM( 9)/4H    /
&HOL      DATA KPRGNM(10)/4H    /,KPRGNM(11)/4H    /,KPRGNM(12)/4H    /
&HOL      DATA KPRGNM(13)/4H    /,KPRGNM(14)/4H    /,KPRGNM(15)/4H    /
&HOL      DATA KPRGNM(16)/4H    /,KPRGNM(17)/4H    /
C
#HOL      DATA KPRGNM( 1)/'    '/,KPRGNM( 2)/'    '/,KPRGNM( 3)/'    '/
#HOL      DATA KPRGNM( 4)/'    '/,KPRGNM( 5)/'    '/,KPRGNM( 6)/'    '/
#HOL      DATA KPRGNM( 7)/'    '/,KPRGNM( 8)/'    '/,KPRGNM( 9)/'    '/
#HOL      DATA KPRGNM(10)/'    '/,KPRGNM(11)/'    '/,KPRGNM(12)/'    '/
#HOL      DATA KPRGNM(13)/'    '/,KPRGNM(14)/'    '/,KPRGNM(15)/'    '/
#HOL      DATA KPRGNM(16)/'    '/,KPRGNM(17)/'    '/
C
C
      DATA KS/13/,KE/10/,KN/11/,KV/12/
      DATA KB(1)/  1/,KB(2)/  2/,KB(3)/  4/,KB(4)/  8/,KB(5)/ 16/
      DATA KB(6)/ 32/,KB(7)/ 64/,KB(8)/128/,KB(9)/1024/,KB(10)/512/
      DATA KB(11)/2097152/,KB(12)/4194304/,KB(13)/256/
      DATA KC( 1)/2015/,KC( 2)/2015/,KC( 3)/2015/,KC( 4)/2015/
      DATA KC( 5)/2015/,KC( 6)/1884/,KC( 7)/ 288/,KC( 8)/1852/
      DATA KC( 9)/2012/,KC(10)/6292991/,KC(11)/256/,KC(12)/256/
      DATA KC(13)/1500/
C
CDJW JAN00 NKAS IS THE START OF THE ALTERNATIVE PARAMETER NAMES
C          NKAO IS THE OFFSET WHICH MAPS NKAS ONTO U[11]
CDJWSEP2000      DATA NWKA/2/, NKA/18/, LKA/2/, NKAS/15/, NKAO/7/
CDJWNOV2000      DATA NWKA/2/, NKA/20/, LKA/2/, NKAS/17/, NKAO/9/
      DATA NWKA/2/, NKA/22/, LKA/2/, NKAS/19/, NKAO/11/
&HOL      DATA ICOORD(1, 1)/4HTYPE/,ICOORD(2, 1)/4H    /
&HOL      DATA ICOORD(1, 2)/4HSERI/,ICOORD(2, 2)/4HAL  /
&HOL      DATA ICOORD(1, 3)/4HOCC /,ICOORD(2, 3)/4H    /
&HOLC      DATA ICOORD(1, 4)/4HU[IS/,ICOORD(2, 4)/4HO]  /
&HOLC-C-C-PARAM. FOR DISTINCT. BETW. ATOM (AN-/ISO.), SPHERE, LINE, RING
&HOL      DATA ICOORD(1, 4)/4HFLAG/,ICOORD(2, 4)/4H    /
&HOL      DATA ICOORD(1, 5)/4HX   /,ICOORD(2, 5)/4H    /
&HOL      DATA ICOORD(1, 6)/4HY   /,ICOORD(2, 6)/4H    /
&HOL      DATA ICOORD(1, 7)/4HZ   /,ICOORD(2, 7)/4H    /
&HOL      DATA ICOORD(1, 8)/4HU[11/,ICOORD(2, 8)/4H]   /
&HOL      DATA ICOORD(1, 9)/4HU[22/,ICOORD(2, 9)/4H]   /
&HOL      DATA ICOORD(1,10)/4HU[33/,ICOORD(2,10)/4H]   /
&HOL      DATA ICOORD(1,11)/4HU[23/,ICOORD(2,11)/4H]   /
&HOL      DATA ICOORD(1,12)/4HU[13/,ICOORD(2,12)/4H]   /
&HOL      DATA ICOORD(1,13)/4HU[12/,ICOORD(2,13)/4H]   /
&HOL      DATA ICOORD(1,14)/4HSPAR/, ICOORD(2,14)/4HE   /
C
CSEP2000  NEW NAMES
&HOL      DATA ICOORD(1,15)/4HPART/,ICOORD(2,15)/4H    /
&HOL      DATA ICOORD(1,16)/4HREF /,ICOORD(2,16)/4H    /
CNOV2000  MORE NEW NAMES
&HOL      DATA ICOORD(1,17)/4HHYBR/,ICOORD(2,17)/4HID  /
&HOL      DATA ICOORD(1,18)/4HNEW /,ICOORD(2,18)/4H    /
C
C----- THE EXTENDED PARAMETER NAMES
&HOL      DATA ICOORD(1,19)/4HU[IS/,ICOORD(2,19)/4HO]  /
&HOL      DATA ICOORD(1,20)/4HSIZE/,ICOORD(2,20)/4H    /
&HOL      DATA ICOORD(1,21)/4HDECL/,ICOORD(2,21)/4HINAT/
&HOL      DATA ICOORD(1,22)/4HAZIM/,ICOORD(2,22)/4HUTH /
C
#HOL      DATA ICOORD(1, 1)/'TYPE'/,ICOORD(2, 1)/'    '/
#HOL      DATA ICOORD(1, 2)/'SERI'/,ICOORD(2, 2)/'AL  '/
#HOL      DATA ICOORD(1, 3)/'OCC '/,ICOORD(2, 3)/'    '/
#HOLC      DATA ICOORD(1, 4)/'U[IS'/,ICOORD(2, 4)/'O]  '/
#HOLC-C-C-PARAM. FOR DISTINCT. BETW. ATOM (AN-/ISO.), SPHERE, LINE, RING
#HOL      DATA ICOORD(1, 4)/'FLAG'/,ICOORD(2, 4)/'    '/
#HOL      DATA ICOORD(1, 5)/'X   '/,ICOORD(2, 5)/'    '/
#HOL      DATA ICOORD(1, 6)/'Y   '/,ICOORD(2, 6)/'    '/
#HOL      DATA ICOORD(1, 7)/'Z   '/,ICOORD(2, 7)/'    '/
#HOL      DATA ICOORD(1, 8)/'U[11'/,ICOORD(2, 8)/']   '/
#HOL      DATA ICOORD(1, 9)/'U[22'/,ICOORD(2, 9)/']   '/
#HOL      DATA ICOORD(1,10)/'U[33'/,ICOORD(2,10)/']   '/
#HOL      DATA ICOORD(1,11)/'U[23'/,ICOORD(2,11)/']   '/
#HOL      DATA ICOORD(1,12)/'U[13'/,ICOORD(2,12)/']   '/
#HOL      DATA ICOORD(1,13)/'U[12'/,ICOORD(2,13)/']   '/
#HOL      DATA ICOORD(1,14)/'SPAR'/, ICOORD(2,14)/'E   '/
CSEP2000  NEW NAMES
#HOL      DATA ICOORD(1,15)/'PART'/,ICOORD(2,15)/'    '/
#HOL      DATA ICOORD(1,16)/'REF '/,ICOORD(2,16)/'    '/
CSEP2000  MORE NEW NAMES
#HOL      DATA ICOORD(1,17)/'HYBR'/,ICOORD(2,17)/'ID  '/
#HOL      DATA ICOORD(1,18)/'NEW '/,ICOORD(2,18)/'    '/
C
C-C-C-ADDITIONAL KEYWORDS FOR SPHERE, LINE, RING
C-C-C-(ATTENTION: IT MIGHT BE REASONABLE NOT TO SUMMARIZE SPHERE-RADIUS,
C-C-C-            LINE-LENGTH, RING-RADIUS IN SIZE, BECAUSE THERE MIGHT
C-C-C-            MORE FIGURES BE ADDED TO THE PROGRAM WITH MORE THAN
C-C-C-            ONE PARAMETER FOR THE SIZE !?)
C
#HOL      DATA ICOORD(1,19)/'U[IS'/,ICOORD(2,19)/'O]  '/
#HOL      DATA ICOORD(1,20)/'SIZE'/,ICOORD(2,20)/'    '/
#HOL      DATA ICOORD(1,21)/'DECL'/,ICOORD(2,21)/'INAT'/
#HOL      DATA ICOORD(1,22)/'AZIM'/,ICOORD(2,22)/'UTH '/
C
C
      DATA NWKO/2/,NKO/6/,LKO/2/
&HOL      DATA KVP(1,1)/4HSCAL/,KVP(2,1)/4HE   /
&HOL      DATA KVP(1,2)/4HDU[I/,KVP(2,2)/4HSO] /
&HOL      DATA KVP(1,3)/4HOU[I/,KVP(2,3)/4HSO] /
&HOL      DATA KVP(1,4)/4HPOLA/,KVP(2,4)/4HRITY/
&HOL      DATA KVP(1,5)/4HENAN/,KVP(2,5)/4HTIO /
&HOL      DATA KVP(1,6)/4HEXTP/,KVP(2,6)/4HARAM/
C
#HOL      DATA KVP(1,1)/'SCAL'/,KVP(2,1)/'E   '/
#HOL      DATA KVP(1,2)/'DU[I'/,KVP(2,2)/'SO] '/
#HOL      DATA KVP(1,3)/'OU[I'/,KVP(2,3)/'SO] '/
#HOL      DATA KVP(1,4)/'POLA'/,KVP(2,4)/'RITY'/
#HOL      DATA KVP(1,5)/'ENAN'/,KVP(2,5)/'TIO '/
#HOL      DATA KVP(1,6)/'EXTP'/,KVP(2,6)/'ARAM'/
C
C
      DATA NWSC/2/,NSC/6/,LSC/2/
C
&HOL      DATA KSCAL(1,1)/4HSCAL/,KSCAL(2,1)/4HES  /
&HOL      DATA KSCAL(1,2)/4HPARA/,KSCAL(2,2)/4HMETE/
&HOL      DATA KSCAL(1,3)/4HLAYE/,KSCAL(2,3)/4HR   /
&HOL      DATA KSCAL(1,4)/4HELEM/,KSCAL(2,4)/4HENT /
&HOL      DATA KSCAL(1,5)/4HBATC/,KSCAL(2,5)/4HH   /
&HOL      DATA KSCAL(1,6)/4HCELL/,KSCAL(2,6)/4H    /
&HOL      DATA KSCAL(1,7)/4HPROF/,KSCAL(2,7)/4HILE /
&HOL      DATA KSCAL(1,8)/4HEXTI/,KSCAL(2,8)/4HNCTI/
C
#HOL      DATA KSCAL(1,1)/'SCAL'/,KSCAL(2,1)/'ES  '/
#HOL      DATA KSCAL(1,2)/'PARA'/,KSCAL(2,2)/'METE'/
#HOL      DATA KSCAL(1,3)/'LAYE'/,KSCAL(2,3)/'R   '/
#HOL      DATA KSCAL(1,4)/'ELEM'/,KSCAL(2,4)/'ENT '/
#HOL      DATA KSCAL(1,5)/'BATC'/,KSCAL(2,5)/'H   '/
#HOL      DATA KSCAL(1,6)/'CELL'/,KSCAL(2,6)/'    '/
#HOL      DATA KSCAL(1,7)/'PROF'/,KSCAL(2,7)/'ILE '/
#HOL      DATA KSCAL(1,8)/'EXTI'/,KSCAL(2,8)/'NCTI'/
C
C
      DATA NWXS/2/,NXS/5/,LXS/2/
      DATA MXS(1,1)/'U''S '/,MXS(2,1)/'    '/
      DATA MXS(1,2)/'UII'''/,MXS(2,2)/'S   '/
      DATA MXS(1,3)/'UIJ'''/,MXS(2,3)/'S   '/
      DATA MXS(1,4)/'X''S '/,MXS(2,4)/'    '/
      DATA MXS(1,5)/'ORIE'/,MXS(2,5)/'NTAT'/
C -- INITIALISE DATA FOR EFFICIENCY STATISTICS
      DATA IPREAD / 0 / , IPWRIT / 0 / , ICACHE / 0 /
      DATA NCACHE(1) / 0 / ,  NCACHE(2) / 0 / , NCACHE(3) / 0 /
      DATA NCACHE(4) / 0 / ,  NCACHE(5) / 0 / , NCACHE(6) / 0 /
      DATA NCACHE(7) / 0 / ,  NCACHE(8) / 0 / , NCACHE(9) / 0 /
      DATA NCACHE(10) / 0 / ,  NCACHE(11) / 0 / , NCACHE(12) / 0 /
      DATA NCACHE(13) / 0 / ,  NCACHE(14) / 0 / , NCACHE(15) / 0 /
      DATA NCACHE(16) / 0 / ,  NCACHE(17) / 0 / , NCACHE(18) / 0 /
      DATA NCACHE(19) / 0 / ,  NCACHE(20) / 0 / , NCACHE(21) / 0 /
      DATA NCACHE(22) / 0 / ,  NCACHE(23) / 0 / , NCACHE(24) / 0 /
      DATA NCALL / 0 /
C
      DATA IFIRST(1)/'FIRS'/,IFIRST(2)/'LAST'/
C
C----- KEYS FOR COEFFICIENTS IN LIST 6
      DATA I14(1) / 14 / , I15(1) / 15 / , I31(1) / 31 /
C -- DATA USED TO CREATE PRE-DEFINED GROUPS FOR REGULARISE
C
      DATA GRPATM(1,1) /0. / GRPATM(2,1) / 0.     / GRPATM(3,1) /0./
      DATA GRPATM(1,2) /0.5/ GRPATM(2,2) / 0.86603/ GRPATM(3,2) /0./
      DATA GRPATM(1,3) /1.5/ GRPATM(2,3) / 0.86603/ GRPATM(3,3) /0./
      DATA GRPATM(1,4) /2.0/ GRPATM(2,4) / 0.     / GRPATM(3,4) /0./
      DATA GRPATM(1,5) /1.5/ GRPATM(2,5) /-0.86603/ GRPATM(3,5) /0./
      DATA GRPATM(1,6) /0.5/ GRPATM(2,6) /-0.86603/ GRPATM(3,6) /0./
      DATA GRPATM(1,7) /0.5/ GRPATM(2,7) / 1.86603/ GRPATM(3,7) /0./
      DATA GRPATM(1,8) /1.5/ GRPATM(2,8) / 1.86603/ GRPATM(3,8) /0./
      DATA GRPATM(1,9) /-1.0/ GRPATM(2,9) /0./ GRPATM(3,9) /0./
      DATA GRPATM(1,10) /0/ GRPATM(2,10) /1./ GRPATM(3,10) /0./
      DATA GRPATM(1,11) /1./ GRPATM(2,11) /0./ GRPATM(3,11) /0./
      DATA GRPATM(1,12) /0./ GRPATM(2,12) /-1./ GRPATM(3,12) /0./
      DATA GRPATM(1,13) /0./ GRPATM(2,13) /0./ GRPATM(3,13) /1.0/
      DATA GRPATM(1,14) /0./ GRPATM(2,14) /0./ GRPATM(3,14) /-1.0/
      DATA GRPATM(1,15) /0.57735/ GRPATM(2,15) /0.57735/
      DATA GRPATM(3,15) /0.57735/
      DATA GRPATM(1,16) /-0.57735/ GRPATM(2,16) /-0.57735/
      DATA GRPATM(3,16) /0.57735/
      DATA GRPATM(1,17) /0.57735/ GRPATM(2,17) /-0.57735/
      DATA GRPATM(3,17) /-0.57735/
      DATA GRPATM(1,18) /-0.57735/ GRPATM(2,18) /0.57735/
      DATA GRPATM(3,18) /-0.57735/
      DATA GRPATM(1,19) /0.30902/ GRPATM(2,19)/0.95106/
      DATA GRPATM(3,19) /0./
      DATA GRPATM(1,20) /-0.80902/ GRPATM(2,20) /0.58779/
      DATA GRPATM(3,20) /0./
      DATA GRPATM(1,21) /-0.80902/ GRPATM(2,21) /-0.58779/
      DATA GRPATM(3,21) /0./
      DATA GRPATM(1,22) /0.30902/ GRPATM (2,22) /-0.95106/
      DATA GRPATM(3,22) /0./
C
C -- DATA TO CREATE PRE-DEFINED GROUPS. EACH ARRAY CONTAINS THE SERIAL
C    NUMBERS OF THE REQUIRED ATOMS IN THE ARRAY GRPATM
C -- HEXAGON
      DATA IHEX(1) /1/ IHEX(2) /2/ IHEX(3) /3/
      DATA IHEX(4) /4/ IHEX(5) /5/ IHEX(6) /6/
C -- SQUARE
      DATA ISQR(1) /2/ ISQR(2) /7/ ISQR(3) /8/ ISQR(4) /3/
C -- OCTAHEDRON
      DATA IOCT(1) /1/ IOCT(2) /9/ IOCT(3) /10/ IOCT(4) /11/
      DATA IOCT(5) /12/ IOCT(6) /13/  IOCT(7) /14/
C -- TRIGONAL BIPYRAMID
      DATA ITBP(1) /1/ ITBP(2) /9/ ITBP(3) /2/
      DATA ITBP(4) /6/ ITBP(5) /13/ ITBP(6) /14/
C -- TETRAHEDRON
      DATA ITET(1) /1/ ITET(2) /15/ ITET(3) /16/
      DATA ITET(4) /17/ ITET(5) /18/
C -- CP RING
      DATA ICPR(1) /11/ ICPR(2) /19/ ICPR(3) /20/
      DATA ICPR(4) /21/ ICPR(5) /22/
C
C
C -- SYMBOLIC CODE DEFINITIONS FOR SYSTEM CONTROL VALUES
C    THESE ARE HELD IN INTEGER VARIABLES, BUT ALSO HAVE CHARACTER
C    VERSIONS WHICH MAY BE MODIFIED BY #STORE COMMANDS.
C
C      ISSISS      ISSUE NUMBER
C      ISSVER      VERSION NUMBER
C      ISSMAC      MACHINE TYPE
C      ISSOPS      OPERATING SYSTEM
C      ISSDAT      DATE OF THIS VERSION
C      ISSSEG      SEGMENTED PROGRAM FLAG ( 1 = YES , -1 = MONOLITHIC )
C
C      ISSOLD      OPEN OLD FILE
C      ISSNEW      CREATE NEW FILE
C      ISSCIF      OPEN OLD FILE IF POSSIBLE, OTHERWISE CREATE FILE
C      ISSOKF      IOSTAT INDICATING NO ERRORS
C      ISSEOF      IOSTAT INDICATING END OF FILE
C      ISSFNF      IOSTAT INDICATING FILE NOT FOUND
C      ISSERF      IOSTAT INDICATING OTHER ERROR (NOT USED)
C      ISSREA      OPEN FILE FOR READ
C      ISSWRI      OPEN FILE FOR WRITE
C      ISSAPP      OPEN FILE FOR APPEND
C
C RICJUL00
C      ISSSEQ      SEQUENTIAL ACCESS FILE
C      ISSDAF      DIRECT ACCESS FILE
C
C      ISSNBF      NUMBER OF DISC BUFFERS
C      ISSBFS      SPACE AVAILABLE FOR DISC BUFFERS ( SIZE OF 'LINK' )
C
C      ISSPAG      SYSTEM PAGE LENGTH ( INTEGER WORDS )
C      ISSRLI      RECORD LENGTH IN INTEGER WORDS
C      ISSBLI      DISK BLOCK LENGTH IN INTEGER WORDS
C      ISSWLI      INTEGER LENGTH IN BYTES
C      ISSRLF,ISSBLF,ISSWLF      FLOATING POINT EQUIVALENTS
C      ISSPRG      PROGRAM NAME ( DIMENSION = 2 )
C      ISSLSM      MONITOR LIST OPERATIONS ( 1 = NO , 2 = READ ,
C                  3 = WRITE , 4 = BOTH )
C      ISSSPD      TERMINAL SPEED INDICATOR ( 1 = SLOW , 2 = FAST )
C      ISSTIM      TIMING MESSAGE INDICATOR ( 0 = DISABLE , 1 = ENABLE)
C      ISSL11      LENGTH OF WORD IN LIST 11 ( 1 = SINGLE PRECISION,
C                  2 = DOUBLE PRECISION )
C      ISSLNM      LIST NUMBER TO MONITOR ( 0 = ALL LISTS )
C      ISSINI      SYSTEM INITIALISATION IN PROGRESS ( 0 = NO, 1 = YES)
C      ISSSTA      STARTUP FILE EXECUTION IN PROGRESS ( 0 = NO,1 = YES)
C      ISSBAN      PRINT INITIAL BANNER HEADING ( 0 = NO , 1 = YES )
C      ISSSFI      STARTUP FILE FLAG ( 0 = NO , 1 = YES )
C      ISSDAR      LENGTH OF DIRECT ACCESS FILE RECORD IN
C                  'STORAGE UNITS', WHOSE SIZE IS MACHINE DEPENDENT
C                  ( E.G. IN VAX FORTRAN , 1 STORAGE UNIT = 1 LONGWORD )
C                  NOTE THAT TOO SHORT A RECORD (E.G. 1024 ON THE HOL)
C                  LEADS TO DATA LOSS DURING '#PURGE'
C      ISSTML      TERMINAL TYPE (UNKNOWN, VT52, VT100)
C      ISSFLC      FILE NAME CHARACTERISTICS (LOWER, UPPER, MIXED CASE)
C      ISSMSG      SET TERMINATION MESSAGES (OFF, ON)
C      ISSPRT      SET PRINTER (OFF, ON)
C      ISSGEN      GENERATE
C      ISSFLM      OPENMESSAGE
C      ISSPAS      PAUSE
C      ISSEXP      EXPORT
C      ISSUEQ      UEQUIV
C      ISSUPD      UPDATE OF MODEL WINDOW
C
C (THE FOLLOWING 4 DEFINITIONS ARE REDUNDANT, AND ARE REPLACED BY
C  THE CHARACTER DEFINITIONS 'CSS***)
&PPC      DATA ISSMAC(1) / ' Pwr' / , ISSMAC(2) / ' Mac' /
&PPC      DATA ISSOPS(1) / ' Mac' / , ISSOPS(2) / ' OS ' /
&PPC      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Oct' /
&PPC      DATA ISSDAT(3) / '  19' / , ISSDAT(4) / '95  ' /
&H-P      DATA ISSMAC(1) / ' H-P' / , ISSMAC(2) / '    ' /
&H-P      DATA ISSOPS(1) / 'UNIX' / , ISSOPS(2) / ' X.X' /
&H-P      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Feb' /
&H-P      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '00  ' /
&DOS      DATA ISSMAC(1) / ' 486' / , ISSMAC(2) / '  PC' /
&DOS      DATA ISSOPS(1) / ' DOS' / , ISSOPS(2) / '6.22' /
&DOS      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Feb' /
&DOS      DATA ISSDAT(3) / '  19' / , ISSDAT(4) / '97  ' /
 
&&DVFGID      DATA ISSMAC(1) / 'Pent' / , ISSMAC(2) / 'ium ' /
&&DVFGID      DATA ISSOPS(1) / ' WIN' / , ISSOPS(2) / '95  ' /
&&DVFGID      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Dec' /
&&DVFGID      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '00  ' /
&&GILLIN      DATA ISSMAC(1) / 'Pent' / , ISSMAC(2) / 'ium ' /
&&GILLIN      DATA ISSOPS(1) / 'Linu' / , ISSOPS(2) / 'x   ' /
&&GILLIN      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Jun' /
&&GILLIN      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '00  ' /
&VAX      DATA ISSMAC(1) / ' DEC' / , ISSMAC(2) / ' VAX' /
&VAX      DATA ISSOPS(1) / ' VMS' / , ISSOPS(2) / ' 5.0' /
&VAX      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Feb' /
&VAX      DATA ISSDAT(3) / '  19' / , ISSDAT(4) / '90  ' /
C
C
      DATA ISSISS     / 9 / ,     ISSVER     / 910 /
      DATA ISSSEG / -1 /
C
      DATA ISSOLD / 1 / , ISSNEW / 2 / , ISSCIF / 3 /
      DATA ISSSCR / 4 / , ISSUNK / 5 / , ISSGEN / 0 /
      DATA ISSFLM / 0 / , ISSPAS / 0 /
C RICJUL00
      DATA ISSSEQ / 1 / , ISSDAF / 2 /
C
      DATA ISSREA / 1 /, ISSWRI / 2 /, ISSAPP /3/
&PPC      DATA ISSFNF /  29 /
&H-P      DATA ISSFNF / 940 /
&DOS      DATA ISSFNF / 128 /
&&DVFGID      DATA ISSFNF /  29 /
&VAX      DATA ISSFNF /  29 /
&&GILLIN      DATA ISSFNF /  2 /
      DATA ISSOKF / 0 /
      DATA ISSEOF /-1 /
      DATA ISSERF / 1 /
C
C  BUFFERS INCREASED TO 24, SEPT 1998 - DONT FORGET XLINK
C^      DATA ISSNBF / 6 / , ISSBFS / 3200 /
      DATA ISSNBF / 24 / , ISSBFS / 12928 /
C
      DATA ISSPAG / 128 /
#H-P      DATA ISSRLI / 512 / , ISSBLI / 128 / , ISSWLI / 4 /
#H-P      DATA ISSRLF / 512 / , ISSBLF / 128 / , ISSWLF / 4 /
&H-P      DATA ISSRLI / 512 / , ISSBLI / 512 / , ISSWLI / 4 /
&H-P      DATA ISSRLF / 512 / , ISSBLF / 512 / , ISSWLF / 4 /
C
C----- THE DIRECT ACCESS FILE PHYSICAL RECORD LENGTH IS MACINE SPECIFIC
C      ON THE VAX, THE RECORD LENGTH IS GIVEN IN LONGWORDS, SO THAT
C                  ISSDAR = ISSRLI
C      ON THE HEWLET PACKARD, IT IS IN BYTES, SO THAT
C                  ISSDAR = 4 * ISSRLI
&VAX      DATA ISSDAR / 512 /
&DVF      DATA ISSDAR / 512 /
&&GILLIN      DATA ISSDAR / 2048 /
&GID      DATA ISSDAR / 512 /
&DOS      DATA ISSDAR /2048 /
C
C
      DATA ISSPRG(1) / 'CRYS' / , ISSPRG(2) / 'TALS' /
C
      DATA ISSLSM / 3 / , ISSSPD / 2 / , ISSTIM / 1 /
C
      DATA ISSL11 / 1 /
      DATA ISSLNM / 5 /
#H-P      DATA ISSINI / 1 / , ISSSTA / 1 / , ISSBAN / 0 /
&H-P      DATA ISSINI / 1 / , ISSSTA / 1 / , ISSBAN / 1 /
      DATA ISSSFI / 1 /, ISSTML /0/, ISSFLC /2/, ISSMSG /1/
      DATA ISSPRT / -1/, ISSEXP /1/,   ISSUEQ /1/, ISSUPD /1/
C
C
C -- THE FOLLOWING VARIABLES ARE USED TO STORE IN CHARACTER FORM CERTAIN
C    SYSTEM CONSTANTS. ( THEIR LENGTHS ARE STORED IN VARIABLES CALLED
C    L..... )
C
C C*16 CSSMAC      TARGET MACHINE TYPE
C C*16 CSSOPS      TARGET OPERATING SYSTEM
C C*16 CSSDAT      ISSUE DATE
C C*16 CSSPRG      PROGRAM NAME
C C*32 CSSCMD      COMMAND FILE NAME FOR USE IN 'DEFINE'
C C*32 CSSNDA      NEW DISCFILE NAME FOR USE IN 'PURGE NEW'
C C*32 CSSCST      'CRYSTALS' STARTUP FILE NAME
C C*32 CSSDST      'DEFINE' STARTUP FILE NAME
C C*32 CSSSCT      SCATTERING FACTOR FILE NAME
C C*32 CSSELE      ELEMENTAL PROPERTIES FILE NAME
C C*32 CSSVDU      LOCAL NAME FOR TERMINAL
C C*32 CSSLPT      LOCAL NAME FOR PRINTER
cdjwmay99 - PS SHOULD THE ITEMS ABOVE BE *64?
C C*64 CSSCIF      CIF OUTPUT FILE
cRICjul99
C C*64 CSSMAP      MAP OUTPUT FILE
C
&PPC      DATA CSSMAC / 'PowerMacintosh' /
&PPC      DATA LSSMAC / 14 /
&PPC      DATA CSSOPS / 'MacOS' /
&PPC      DATA LSSOPS / 5 /
&PPC      DATA CSSDAT / 'October 1995' /
&PPC      DATA LSSDAT / 12 /
&H-P      DATA CSSMAC / 'HP UNIX' /
&H-P      DATA LSSMAC / 7 /
&H-P      DATA CSSOPS / 'Version X.X' /
&H-P      DATA LSSOPS / 11 /
&H-P      DATA CSSDAT / 'February  2000' /
&H-P      DATA LSSDAT / 14 /
&DOS      DATA CSSMAC / 'Intel 80X86' /
&DOS      DATA LSSMAC / 11 /
&DOS      DATA CSSOPS / 'DOS 7.0' /
&DOS      DATA LSSOPS / 7 /
&DOS      DATA CSSDAT / 'February  1996' /
&DOS      DATA LSSDAT / 14 /
&&DVFGID      DATA CSSMAC / 'Intel Pentium' /
&&DVFGID      DATA LSSMAC / 13 /
&&DVFGID      DATA CSSOPS / 'WIN 95' /
&&DVFGID      DATA LSSOPS / 6 /
&&DVFGID      DATA CSSDAT / 'December 1998' /
&&DVFGID      DATA LSSDAT / 13 /
&&GILLIN      DATA CSSMAC / 'Intel Pentium' /
&&GILLIN      DATA LSSMAC / 13 /
&&GILLIN      DATA CSSOPS / 'Linux' /
&&GILLIN      DATA LSSOPS / 5 /
&&GILLIN      DATA CSSDAT / 'May 1999' /
&&GILLIN      DATA LSSDAT / 8 /
&VAX      DATA CSSMAC / 'DEC VAX' /
&VAX      DATA LSSMAC / 7 /
&VAX      DATA CSSOPS / 'VMS 5' /
&VAX      DATA LSSOPS / 5 /
&VAX      DATA CSSDAT / 'February  1990' /
&VAX      DATA LSSDAT / 14 /
      DATA CSSPRG / 'CRYSTALS' /
      DATA LSSPRG / 8 /
      DATA CSSCMD / ' ' /
      DATA LSSCMD / 1 /
      DATA CSSNDA / ' ' /
      DATA LSSNDA / 1 /
C
      DATA CSSCST / 'CRYSDIR:crystals.srt' /
      DATA LSSCST / 20 /
C
      DATA CSSDST / 'CRYSDIR:crysdef.srt' /
      DATA LSSDST / ' 19 ' /
C
&PPC      DATA CSSSCT / 'CRSCP:scatt.dat' /
&PPC      DATA LSSSCT / 15 /
&H-P      DATA CSSSCT / '/users/oxford/scatt.dat' /
&H-P      DATA LSSSCT / 23 /
&DOS      DATA CSSSCT / ' ' /
&DOS      DATA LSSSCT / 1 /
&&DVFGID      DATA CSSSCT / ' ' /
&&DVFGID      DATA LSSSCT / 1 /
&&GILLIN      DATA CSSSCT / ' ' /
&&GILLIN      DATA LSSSCT / 1 /
&VAX      DATA CSSSCT / 'CRSCP:scatt.dat' /
&VAX      DATA LSSSCT / 15 /
C
&PPC      DATA CSSELE / 'CRSCP:propwin.dat' /
&PPC      DATA LSSELE / 17 /
&H-P      DATA CSSELE / '/users/oxford/propwin.dat' /
&H-P      DATA LSSELE / 24 /
&DOS      DATA CSSELE / ' ' /
&DOS      DATA LSSELE / 1 /
&&DVFGID      DATA CSSELE / ' ' /
&&DVFGID      DATA LSSELE / 1 /
&&GILLIN      DATA CSSELE / ' ' /
&&GILLIN      DATA LSSELE / 1 /
&VAX      DATA CSSELE / 'CRSCP:propwin.dat' /
&VAX      DATA LSSELE / 17 /
C
&PPC      DATA CSSVDU  / 'SYS$COMMAND' /
&PPC      DATA LSSVDU / 11 /
&H-P      DATA CSSVDU  / 'VDU' /
&H-P      DATA LSSVDU / 3 /
&DOS      DATA CSSVDU  / 'CON' /
&DOS      DATA LSSVDU / 3 /
&&DVFGID      DATA CSSVDU  / 'CON' /
&&DVFGID      DATA LSSVDU / 3 /
&&GILLIN      DATA CSSVDU  / 'CON' /
&&GILLIN      DATA LSSVDU / 3 /
&VAX      DATA CSSVDU  / 'SYS$COMMAND' /
&VAX      DATA LSSVDU / 11 /
C
&PPC      DATA CSSLPT  / 'SYS$PRINT' /
&PPC      DATA LSSLPT / 9 /
&H-P      DATA CSSLPT  / 'LPT' /
&H-P      DATA LSSLPT / 3 /
&DOS      DATA CSSLPT  / 'PRN' /
&DOS      DATA LSSLPT / 3 /
&&DVFGID      DATA CSSLPT  / 'PRN' /
&&DVFGID      DATA LSSLPT / 3 /
&&GILLIN      DATA CSSLPT  / 'PRN' /
&&GILLIN      DATA LSSLPT / 3 /
&VAX      DATA CSSLPT  / 'SYS$PRINT' /
&VAX      DATA LSSLPT / 9 /
C
cdjwmay99
&PPC      DATA CSSCIF / 'publish.cif' /
&PPC      DATA LSSCIF / 11 /
&H-P      DATA CSSCIF / 'publish.cif' /
&H-P      DATA LSSCIF / 11 /
&DOS      DATA CSSCIF / 'publish.cif' /
&DOS      DATA LSSCIF / 11 /
&&DVFGID      DATA CSSCIF / 'publish.cif' /
&&DVFGID      DATA LSSCIF / 11 /
&&GILLIN      DATA CSSCIF / 'publish.cif' /
&&GILLIN      DATA LSSCIF / 11 /
&VAX      DATA CSSCIF / 'publish.cif' /
&VAX      DATA LSSCIF / 11 /
cRICjul99
&&&PPCH-PDOS      DATA CSSMAP / 'fourier.map' /
&&&PPCH-PDOS      DATA LSSMAP / 11 /
&&&DVFGIDVAX      DATA CSSMAP / 'fourier.map' /
&&&DVFGIDVAX      DATA LSSMAP / 11 /
&&GILLIN      DATA CSSMAP / 'fourier.map' /
&&GILLIN      DATA LSSMAP / 11 /
C
C -- 'DEVICE' AND 'EXTENSION' REQUIRED FOR 'HELP' , 'MANUAL' , AND
C    'SCRIPT' INSTRUCTIONS
C
C    CHLPDV  CHLPEX      'HELP'
C    CINDDV  CINDEX      'MANUAL'
C    CSCPDV  CSCPEX      'SCRIPT
C
      DATA CHLPDV / ' ' / , CHLPEX / ' ' /
      DATA LHLPDV / 1 / ,        LHLPEX / 1 /
C
      DATA CINDDV / ' ' / , CINDEX / ' ' /
      DATA LINDDV / 1 / ,        LINDEX / 1 /
C
      DATA CSCPDV / ' ' / , CSCPEX / ' ' /
      DATA LSCPDV / 1 / ,        LSCPEX / 1 /
C
C
C
C
C -- SYMBOLIC CODES FOR ERROR HANDLING. SEE 'XERHND' FOR DETAILS
C
      DATA IERNOP / 1 / , IERSFL / 2 / , IERWRN / 3 /
      DATA IERERR / 4 / , IERSEV / 5 / , IERCAT / 6 /
      DATA IERPRG / 7 / , IERABO / 8 / , IERUNW / 9 /
C
C -- CONTROL VALUES FOR ERROR PROCESSING
C -- 'DUMP' FLAG
      DATA IERDMP(1) / 1 / , IERDMP(2) / 1 / , IERDMP(3) / 1 /
      DATA IERDMP(4) / 2 / , IERDMP(5) / 3 / , IERDMP(6) / 3 /
      DATA IERDMP(7) / 3 / , IERDMP(8) / 1 / , IERDMP(9) / 2 /
C -- 'STOP/CONTINUE' FLAG
      DATA IERCNT(1) / 1 / , IERCNT(2) / 1 / , IERCNT(3) / 1 /
      DATA IERCNT(4) / 2 / , IERCNT(5) / 4 / , IERCNT(6) / 4 /
      DATA IERCNT(7) / 3 / , IERCNT(8) / 4 / , IERCNT(9) / 2 /
C -- 'MESSAGE' FLAG
      DATA IERMSG(1) / 1 / , IERMSG(2) / 1 / , IERMSG(3) / 2 /
      DATA IERMSG(4) / 3 / , IERMSG(5) / 4 / , IERMSG(6) / 5 /
      DATA IERMSG(7) / 6 / , IERMSG(8) / 1 / , IERMSG(9) / 3 /
C -- MAXIMUM NUMBER OF OCCURENCES
      DATA IERLIM(1) / 0 / , IERLIM(2) / 0 / , IERLIM(3) / 0 /
      DATA IERLIM(4) / 0 / , IERLIM(5) / 1 / , IERLIM(6) / 1 /
      DATA IERLIM(7) / 1 / , IERLIM(8) / 1 / , IERLIM(9) / 0 /
C -- 'SET ERROR' FLAG
      DATA IERSTF(1) /  0 / , IERSTF(2) / -1 / , IERSTF(3) /  0 /
      DATA IERSTF(4) / -1 / , IERSTF(5) / -1 / , IERSTF(6) / -1 /
      DATA IERSTF(7) / -1 / , IERSTF(8) / -1 / , IERSTF(9) / -1 /
C -- INITIAL ERROR COUNTS
      DATA IERCOU(1) / 0 / , IERCOU(2) / 0 / , IERCOU(3) / 0 /
      DATA IERCOU(4) / 0 / , IERCOU(5) / 0 / , IERCOU(6) / 0 /
      DATA IERCOU(7) / 0 / , IERCOU(8) / 0 / , IERCOU(9) / 0 /
C -- HIGHEST POSSIBLE ERROR CODE NUMBER
      DATA IERMAX / 9 /
C
C -- SYMBOLIC CODES FOR LIST CHECKING.
C    FUNCTION CODES FOR 'KLSCHK'
      DATA ILSCLN / 1 / , ILSCLS / 2 / , ILSCLV / 3 /
      DATA ILSEXI / 4 / , ILSAVI / 5 / , ILSRFI / 6 /
C    REQUEST CODES FOR 'KLSCHK'
      DATA ILSMSG / 1 / , ILSNMS / -1 /
C    FUNCTION CODES FOR 'XLSALT'
      DATA ILSERF / 1 / , ILSPUF / 2 / , ILSDLF / 3 /
      DATA ILSOWF / 4 / , ILSCUR / 5 / , ILSRTF / 2 /
C    FLAG CODES FOR 'XLSALT'
      DATA ILSSET / -1 / , ILSCLR / 1 /
      DATA ILSOVR / -1 / , ILSRDY / 0 / , ILSUPD / 1 /
C
C -- SYMBOLIC CODES FOR FACILITY NAMES - SYSTEM MESSAGES
      DATA IOPCRY / 1 / , IOPPUR / 2 / , IOPLPC / 3 /
      DATA IOPSSM / 4 / , IOPMER / 5 / , IOPABS / 6 /
      DATA IOPCOR / 7 / , IOPREF / 8 / , IOPFOU / 9 /
      DATA IOPWEI / 10 / , IOPANA / 11 / , IOPTFC / 12 /
      DATA IOPMOD / 13 / , IOPLSM / 14 / , IOPHYD / 15 /
      DATA IOPLSI / 16 / , IOPLSC / 17 / , IOPLEX / 18 /
      DATA IOPL12 / 19 / , IOPL16 / 20 / , IOPCHK / 21 /
      DATA IOPCPR / 22 / , IOPSOR / 23 / , IOPREO / 24 /
      DATA IOPSFS / 25 / , IOPPCH / 26 / , IOPDIS / 27 /
      DATA IOPTOR / 28 / , IOPPRA / 29 / , IOPTLS / 30 /
      DATA IOPAXS / 31 / , IOPPPR / 32 / , IOPREG / 33 /
      DATA IOPSIM / 34 / , IOPTRI / 35 / , IOPSLA / 36 /
      DATA IOPFPL / 37 / , IOPDAB / 38 / , IOPDSP / 39 /
      DATA IOPINV / 40 / , IOPGNP / 41 / , IOPP22 / 42 /
      DATA IOPSCP / 43 / , IOPSGP / 44 / , IOPQCK / 45 /
      DATA IOPCMP / 46 /
C -- SYMBOLIC CODES FOR MESSAGE TYPES
      DATA IOPABN / 1 / , IOPCMI / 2 / , IOPEND / 3 /
      DATA IOPPRC / 4 / , IOPSPC / 5 / , IOPLSP / 6 /
      DATA IOPINT / 7 / , IOPLSE / 8 / , IOPVER / 9 /
C -- INITIAL VALUES FOR DIRECT ACCESS FILE CONTROL
      DATA IDAINI / 0 / , IDATOT / -1 / , IDAMAX / 0 /
      DATA IDAMIN / 5 / , IDAAUT / 1 / , IDAQUA / 5 /
      DATA IDATRY / 1 /
C -- VALUES FOR FILE CONTROL BLOCK CONTROL
      DATA ICBDIM / 9 / , ICBLDD / -1 / , ICBDAD / 0 /
      DATA ICBNFL / 1 / , ICBMRN / 2 / , ICBFIN / 3 /
      DATA ICBDEQ / 4 / , ICBCIN / 5 / , ICBMAX / 6 /
      DATA ICBTTL / 7 / , ICBAUT / 8 / , ICBLNF / 9 /
C
C -- INITIAL DATA FOR SCRIPT PROCESSING.
C
C -- SCRIPT USER MESSAGES
C
      DATA CSCMSG(1)  / 'Too much data has been provided' /
      DATA CSCMSG(2)(1:31) / 'No default value is available. ' /
      DATA CSCMSG(2)(32:80) / 'Please give an appropriate answer' /
      DATA CSCMSG(3)  / 'An illegal real number has been given' /
      DATA CSCMSG(4)  / 'An illegal integer has been given' /
      DATA CSCMSG(5)  / 'The value given is not allowed' /
      DATA CSCMSG(6)  /'Processing of this section has been abandoned'/
      DATA CSCMSG(7)  / 'User message 1' /
      DATA CSCMSG(8)  / 'User message 2' /
      DATA CSCMSG(9)  / 'User message 3' /
      DATA CSCMSG(10) / 'User message 4' /
      DATA CSCMSG(11) / ' (integer)' /
      DATA CSCMSG(12) / ' (real number)' /
      DATA CSCMSG(13) / ' (text)' /
      DATA CSCMSG(14) / ' (text)' /
      DATA CSCMSG(15) / ' (keyword)' /
      DATA CSCMSG(16) / ' (file name)' /
      DATA CSCMSG(17) / ' (keyword)' /
      DATA CSCMSG(18) / ' (YES or NO)' /
      DATA CSCMSG(19)(1:31)  / 'The answer given is ambiguous. ' /
      DATA CSCMSG(19)(32:67) / 'Enter enough characters to identify ' /
      DATA CSCMSG(19)(68:80) / 'one keyword' /
      DATA CSCMSG(20) / 'The value given in not appropriate' /
      DATA LSCMSG / 31 , 64 , 37 , 33 , 30 , 45 , 14 , 14 , 14 , 14 ,
     2              10 , 14 ,  7 ,  7 , 10 , 12 , 10 , 12 , 78 , 34 /
C
C -- CHARACTER BUFFER POINTERS
      DATA IDIRPS / 0 / , IDIRLN / 0 /
      DATA ICOMPS / 0 / , ICOMLN / 0 /
      DATA IINPPS / 1 / , IINPLN / 0 /
C
C -- CONTROL FLAGS
      DATA ISCMSG / 1 / , ISCFST / 1 / , ISCCOM / 0 /
      DATA ISCSER / 0 / , ISCVAL / 0 / , ISCVLS / 0 /
      DATA ISCVLN / 0 / , ISCINI / 0 / , ISCEVE / 0 /
      DATA ISCVER / 0 / , ISCSVE / 0 / , ISCIVE / 0 /
C
C -- NUMBER OF ALLOWED VALUES
      DATA NCHKUS / 0 /
C
C
C -- LIST INPUT HANDLING FLAGS
C    THESE FLAGS CONTROL HOW 'LIST NNN' INSTRUCTIONS ARE HANDLED.
C
C -- FOR EACH POSSIBLE LIST NUMBER, NNN SAY, ILSTHN(NNN) INDICATES HOW
C    THE INPUT OF LIST NNN SHOULD BE DONE.
C
C      ILSTHN(NNN)       MEANING
C            1           USE 'XRD01'
C            2           USE 'XRD02'
C            3           USE 'XRDLN' ( ALLOW OVERWRITING )
C            4           USE 'XRDLN' ( NO OVERWRITING )
C            5           USE 'XRDLEX'
C            6           LIST OF THIS TYPE CANNOT BE INPUT.
C            7           PROGRAMMING ERROR. INPUT OF THIS LIST TYPE
C                        SHOULD NOT BE HANDLED BY 'XLNIOA'
C
      DATA ILSTHN / 1 , 2 , 3 , 3 , 4 , 7 , 6 , 6 , 6 , 4 ,
     2              3 , 5 , 3 , 3 , 6 , 5 , 5 , 6 , 6 , 3 ,
     3              6 , 6 , 3 , 3 , 3 , 7 , 3 , 3 , 3 , 4 ,
     4              3 , 6 , 7 , 6 , 6 , 6 , 6 , 3 , 3 , 6 ,
     5              6 , 6 , 6 , 6 , 6 , 6 , 6 , 6 , 6 , 6 /
C
C
      DATA IOLDC / 0 /
      DATA IOFORE / -1 /
      DATA IOBACK / -1 /
C
C
      END
C
C
CODE FOR SYNBLK
      BLOCK DATA SYNBLK
\XPARSE
C
C--CONTROL VALUES FOR THE SYSTEM VARIABLES
      DATA NWSV/1/,NSV/20/,LSV/3/
C--THE SYSTEM VARIABLES
      DATA KSV(2, 1)/4/,KSV(3, 1)/'A   '/
      DATA KSV(2, 2)/1/,KSV(3, 2)/'CV  '/
      DATA KSV(2, 3)/4/,KSV(3, 3)/'AR  '/
      DATA KSV(2, 4)/1/,KSV(3, 4)/'RCV '/
      DATA KSV(2, 5)/6/,KSV(3, 5)/'G   '/
      DATA KSV(2, 6)/6/,KSV(3, 6)/'GR  '/
      DATA KSV(2, 7)/6/,KSV(3, 7)/'L   '/
      DATA KSV(2, 8)/6/,KSV(3, 8)/'LR  '/
      DATA KSV(2, 9)/2/,KSV(3, 9)/'CONV'/
      DATA KSV(2,10)/4/,KSV(3,10)/'RIJ '/
      DATA KSV(2,11)/4/,KSV(3,11)/'ANIS'/
      DATA KSV(2,12)/12/,KSV(3,12)/'SM  '/
      DATA KSV(2,13)/12/,KSV(3,13)/'SMI '/
      DATA KSV(2,14)/9/,KSV(3,14)/'NPLT'/
      DATA KSV(2,15)/1/,KSV(3,15)/'PI  '/
      DATA KSV(2,16)/1/,KSV(3,16)/'TPI '/
      DATA KSV(2,17)/1/,KSV(3,17)/'TPIS'/
      DATA KSV(2,18)/1/,KSV(3,18)/'DTR '/
      DATA KSV(2,19)/1/,KSV(3,19)/'RTD '/
      DATA KSV(2,20)/1/,KSV(3,20)/'ZERO'/
C
C--THE SYSTEM VARAIBLE DIMENSIONS
C
C--NO DIMENSIONS
      DATA KSVD( 1)/0/
C--DIMENSION  A(3)
      DATA KSVD( 2)/1/
      DATA KSVD( 3)/3/
C--DIMENSION  A(6)
      DATA KSVD( 4)/1/
      DATA KSVD( 5)/6/
C--DIMENSION  A(3,3)
      DATA KSVD( 6)/2/
      DATA KSVD( 7)/3/
      DATA KSVD( 8)/3/
C--DIMENSION  A(3,4)
      DATA KSVD( 9)/2/
      DATA KSVD(10)/3/
      DATA KSVD(11)/4/
C--DIMENSION A(3,4,96)
      DATA KSVD(12)/3/
      DATA KSVD(13)/3/
      DATA KSVD(14)/4/
      DATA KSVD(15)/96/
C
C--DETAILS OF THE SYSTEM FUNCTIONS
      DATA NWSF/1/,NSF/8/,LSF/1/
C--NAMES OF THE SYSTEM FUNCTIONS
      DATA KSYSF( 1)/'SQRT'/
      DATA KSYSF( 2)/'EXP '/
      DATA KSYSF( 3)/'SIN '/
      DATA KSYSF( 4)/'COS '/
      DATA KSYSF( 5)/'TAN '/
      DATA KSYSF( 6)/'ASIN'/
      DATA KSYSF( 7)/'ACOS'/
      DATA KSYSF( 8)/'ATAN'/
C
C--OPERATOR PRECEDENCE TABLE FOR THE PARSING ROUTINES
C
C  1  CONTINUE FILLING
C  2  EQUALITY
C  3  START TO FORM STACK
C  4  ERROR
C  5  EXIT
C
C--THE FOLLOWING VARIABLES ARE USED :
C
C  IOPT        OPERATOR PRECEDENCE TABLE
C  IOPTS(+1)   ROW AND COLUMN OF 'START' SYMBOL
C  IOPTE(+1)   ROW AND COLUMN OF 'END' SYMBOL
C  IOPTSF(+1)  ROW AND COLUMN OF 'STANDARD FUNCTION' SYMBOL
C  LOPT        DIMENSION OF IOPT FOR EACH ROW OR COLUMN
C  IOPL        VALUE TO WHICH STANDARD FUNCTION POSITION IS ADDED
C              TO FIND ITS PLACE IN THE ACCUMULATION ROUTINES
C  ISTOP       POSITION OF EXIT IN ACCUMULATION ROUTINES
C
C--AS WRITTEN HERE THE FOLLOWING SYMBOL IS DOWN THE ARRAY
C  AND THE FIRST SYMBOL IS ALONG THE ARRAY.
C
      DATA IOPTS/7/,IOPTE/8/,IOPTSF/9/,LOPT/10/,IOPL/5/,ISTOP/14/
      DATA IOPT/3,3,3,3,3,1,3,1,4,3,
     2          3,3,3,3,3,1,3,1,4,3,
     3          1,1,3,3,3,1,3,1,4,3,
     4          1,1,3,3,3,1,3,1,4,3,
     5          1,1,1,1,3,1,3,1,4,3,
     6          1,1,1,1,1,1,4,1,4,1,
     7          3,3,3,3,3,2,3,4,4,3,
     8          4,4,4,4,4,4,4,4,4,4,
     9          3,3,3,3,3,4,3,5,4,3,
     *          1,1,1,1,1,1,4,1,4,4/
      END
C
CODE FOR UTIBLK
      BLOCK DATA UTIBLK
C
C--UTILITY TABLES INITIALIZATION
C
      COMMON/SPEC/ SOPER(3,4,24),CENTRT(7,12),AAA(6),NOPER,NCENTR,ICENT,
     *         KPOL,JSYS,LAT,INDV(32),MPV(64),JSPINI,DDMIN,NCAWU,NCWU
      DATA CENTRT/
     * .0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000
     *,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000
     *,.0000,.5000,.5000,.5000,.5000,.6666,.0000,.5000,.0000,.5000,.5000
     *,.5000,.3333,.0000,.5000,.5000,.0000,.0000,.5000,.0000,.0000,.0000
     *,.0000,.0000,.0000,.0000,.3333,.0000,.0000,.0000,.0000,.5000,.0000
     *,.6666,.0000,.0000,.0000,.0000,.5000,.0000,.0000,.0000,.0000,.0000
     *,.0000,.5000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000,.0000
     *,.0000,.0000,.0000,.0000,.5000,.0000,.0000/
      DATA MPV/
     *        273,139537,140563, 65697, 16545,131857,135961,  2132,
     *      32852,  8977,  9498,  4875,  1290,  4362,  1291,  4378,
     *     131338,136458,   673,  8276, 43092, 82593,   140,    98,
     *      33890,  6284, 17506, 69772, 49250, 67724,139545,131859,
     *     140049,   785,   787, 17057, 66209,  8465,  8473, 41044,
     *      10324,131345,135450,132363,135434,132362,135947,140570,
     *       5386,   266, 82081, 34900,    84,   161, 71820, 50274,
     *      16482, 65676, 32866,  2188,  1122,  4236,  4889,  9491/
      DATA INDV/1,2,2,4,4,2,2,4,4,2,3,3,4,4,6,6,
     *          2,2,2,2,2,2,3,3,3,3,3,3,3,3,2,2/
      DATA JSPINI,DDMIN / 0 , 0.6 /
      END
C
C
CODE FOR MACBLK
&PPC      BLOCK DATA MACBLK
&PPCC
&PPC\CFLDAT
&PPCC
&PPCC      DISCFILE,  HKLI    ,  CONTROL ,  PRINTER ,  PUNCH
&PPCC
&PPC      DATA LFNAME(1)  /  1 /, FLNAME(1)  /' '/
&PPC      DATA LFNAME(2)  /  1 /, FLNAME(2)  /' '/
&PPC      DATA LFNAME(3)  /  1 /, FLNAME(3)  /' '/
&PPC      DATA LFNAME(4)  /  1 /, FLNAME(4)  /' '/
&PPC      DATA LFNAME(5)  /  1 /, FLNAME(5)  /' '/
&PPCC
&PPCC      LOG     ,  MONITOR ,  SPY     ,  NEWDISC ,  EXCOMMON
&PPCC
&PPC      DATA LFNAME(6)  /  1 /, FLNAME(6)  /' '/
&PPC      DATA LFNAME(7)  /  1 /, FLNAME(7)  /' '/
&PPC      DATA LFNAME(8)  /  3 /, FLNAME(8)  /'Spy'/
&PPC      DATA LFNAME(9)  /  1 /, FLNAME(9)  /' '/
&PPC      DATA LFNAME(10) /  8 /, FLNAME(10) /'Excommon'/
&PPCC
&PPCC      COMMANDS,  USE1    ,  USE2    ,  USE3    ,  USE4
&PPCC
&PPC      DATA LFNAME(11) /  8 /, FLNAME(11) /'Commands'/
&PPC      DATA LFNAME(12) /  1 /, FLNAME(12) /' '/
&PPC      DATA LFNAME(13) /  1 /, FLNAME(13) /' '/
&PPC      DATA LFNAME(14) /  1 /, FLNAME(14) /' '/
&PPC      DATA LFNAME(15) /  1 /, FLNAME(15) /' '/
&PPCC
&PPCC      M32     ,  M33     ,  MT1     ,  MT2     ,  MT3
&PPCC
&PPC      DATA LFNAME(16) /  9 /, FLNAME(16) /'Scratch#1'/
&PPC      DATA LFNAME(17) /  9 /, FLNAME(17) /'Scratch#2'/
&PPC      DATA LFNAME(18) /  6 /, FLNAME(18) /'Tape#1'/
&PPC      DATA LFNAME(19) /  6 /, FLNAME(19) /'Tape#2'/
&PPC      DATA LFNAME(20) /  6 /, FLNAME(20) /'Tape#3'/
&PPCC
&PPCC      MTE     ,  SRQ     ,  FRN1DATA,  FRN2DATA,  SCPDATA
&PPCC
&PPC      DATA LFNAME(21) /  6 /, FLNAME(21) /'Tape#E'/
&PPC      DATA LFNAME(22) /  3 /, FLNAME(22) /'Srq'/
&PPC      DATA LFNAME(23) /  1 /, FLNAME(23) /' '/
&PPC      DATA LFNAME(24) /  1 /, FLNAME(24) /' '/
&PPC      DATA LFNAME(25) /  7 /, FLNAME(25) /'ScpData'/
&PPCC
&PPCC      SCPQUEUE,  COMMSRC ,  USE5    ,  USE6    ,  USE7
&PPCC
&PPC      DATA LFNAME(26) /  8 /, FLNAME(26) /'ScpQueue'/
&PPC      DATA LFNAME(27) /  7 /, FLNAME(27) /'CommSrc'/
&PPC      DATA LFNAME(28) /  1 /, FLNAME(28) /' '/
&PPC      DATA LFNAME(29) /  1 /, FLNAME(29) /' '/
&PPC      DATA LFNAME(30) /  1 /, FLNAME(30) /' '/
&PPCC
&PPCC      USE8    ,  USE9    ,
&PPCC
&PPC      DATA LFNAME(31) /  1 /, FLNAME(31) /' '/
&PPC      DATA LFNAME(32) /  1 /, FLNAME(32) /' '/
&PPCC
&PPC      DATA FLTYPE(1)  /'    '/,  FLTYPE(2)  /'.HKL'/
&PPC      DATA FLTYPE(3)  /'    '/,  FLTYPE(4)  /'.LIS'/
&PPC      DATA FLTYPE(5)  /'.PCH'/,  FLTYPE(6)  /'.LOG'/
&PPC      DATA FLTYPE(7)  /'.MON'/,  FLTYPE(8)  /'    '/
&PPC      DATA FLTYPE(9)  /'    '/,  FLTYPE(10) /'    '/
&PPC      DATA FLTYPE(11) /'    '/,  FLTYPE(12) /'    '/
&PPC      DATA FLTYPE(13) /'    '/,  FLTYPE(14) /'    '/
&PPC      DATA FLTYPE(15) /'    '/,  FLTYPE(16) /'    '/
&PPC      DATA FLTYPE(17) /'    '/,  FLTYPE(18) /'    '/
&PPC      DATA FLTYPE(19) /'    '/,  FLTYPE(20) /'    '/
&PPC      DATA FLTYPE(21) /'    '/,  FLTYPE(22) /'    '/
&PPC      DATA FLTYPE(23) /'.FN1'/,  FLTYPE(24) /'.FN2'/
&PPC      DATA FLTYPE(25) /'    '/,  FLTYPE(26) /'    '/
&PPC      DATA FLTYPE(27) /'    '/,  FLTYPE(28) /'    '/
&PPC      DATA FLTYPE(29) /'    '/,  FLTYPE(30) /'    '/
&PPC      DATA FLTYPE(31) /'    '/,  FLTYPE(32) /'    '/
&PPCC
&PPC      END
&PPCC
&PPCC

      SUBROUTINE CRESET

\XSSVAL
\XCARDS
\UFILE
\XUNITS
\XDISCS
\XTAPES
\XTAPED
\XLST50
\XDAVAL
\XCBVAL
\XUNTNM
c\XLEXIC
\XLISTI
\XFILE
\XLISTS
\XCNTRL
\PSCSTI
\XSCSTK
\XFILEC
\XGUIOV

      EQUIVALENCE ( IRIC,ZRIC )

C --- XSSVAL ---
      ISSLSM = 3
      ISSSPD = 2
      ISSTIM = 1
      ISSL11 = 1 
      ISSLNM = 5
      ISSINI = 1
      ISSSTA = 1
#H-P      ISSBAN = 0 
&H-P      ISSBAN = 1
      ISSSFI = 1
      ISSTML = 0
      ISSFLC = 2
      ISSMSG = 1
      ISSPRT = -1
      ISSEXP = 1
      ISSUEQ = 1 

C --- XCARDS ---
      NC=-1
      ND=-1
      LASTCH=80
      NI=0
      NILAST=-2
      NS=1
      MON=0
      ICAT=1
      IEOF=0
      IHFLAG=-1
      NUSRQ=63
      NREC=0
      IPOSRQ=0
      ITYPFL=1
      INSTR=0
      IDIRFL=-1
      IPARAM=-1
      IPARAD=-1
      NWCHAR=4
      IMNSRQ=0

C --- UFILE ---
      IFLIND = 2
      DO I=1,20
        IFLCHR(I)=0
        IRDLOG(I)=1
        IRDCPY(I)=0
        IRDCAT(I)=0
        IRDCMS(I)=0
        IRDINC(I)=1
        IRDSCR(I)=0
        IRDSRQ(I)=0
        IRDREC(I)=0
        IRDFND(I)=0
        IRDHGH(I)=0
      END DO
      IFLCHR(1) = 1 
      IFLCHR(2) = 2
      IRDLOG(2) = 0
      IRDCAT(1) = 1
      IRDCMS(1) = 1

      IRDPAG = 20
      IRDLIN = 0
      NCLU = 8

      NFLUSD = 49



      IFLUNI(1)  =  1  
      IFLUNI(2)  =  2
      IFLUNI(3)  =  5  
&&&DOSGIDDVF      IFLUNI(4)  =  6
&&GILLIN      IFLUNI(4)  =  6
&VAX      IFLUNI(4)  =  9
      IFLUNI(5) = 7
      IFLUNI(6) = 8
      IFLUNI(7) = 6
      IFLUNI(8) = 11
      IFLUNI(9) = 12
      IFLUNI(10)= 14
      IFLUNI(11)= 15
      IFLUNI(12)= 20
      IFLUNI(13)= 21
      IFLUNI(14)= 22
      IFLUNI(15)= 23
      IFLUNI(16)= 52
      IFLUNI(17)= 53
      IFLUNI(18)= 48
      IFLUNI(19)= 49
      IFLUNI(20)= 50
      IFLUNI(21)= 51
      IFLUNI(22)= 63
      IFLUNI(23)= 71
      IFLUNI(24)= 72
      IFLUNI(25)= 88
      IFLUNI(26)= 89
      IFLUNI(27)=  4
      IFLUNI(28)= 24
      IFLUNI(29)= 25
      IFLUNI(30)= 26
      IFLUNI(31)= 27
      IFLUNI(32)= 28
      IFLUNI(33)=  6
      IFLUNI(34)=  6             
      IFLUNI(35)= 29
      IFLUNI(36)= 30
      IFLUNI(37)= 31
      IFLUNI(38)= 32
      IFLUNI(39)= 33
      IFLUNI(40)= 34
      IFLUNI(41)= 35
      IFLUNI(42)= 36
      IFLUNI(43)= 37
      IFLUNI(44)= 38             
      IFLUNI(45)= 40
      IFLUNI(46)= 41
      IFLUNI(47)= 42
      IFLUNI(48)= 43
      IFLUNI(49)= 44

      DO I=1,49
            IFLOPN(I)=0
            IFLACC(I)=1
            IFLFRM(I)=1
      ENDDO

      IFLACC(1)=2
      IFLACC(9)=2
      IFLACC(11)=2

      IFLFRM(1)=2
      IFLFRM(9)=2
      IFLFRM(11)=2
      IFLFRM(16)=2
      IFLFRM(17)=2
      IFLFRM(18)=2
      IFLFRM(19)=2
      IFLFRM(20)=2
      IFLFRM(21)=2


C --- XUNITS ---
      NCRU =20
      NCRRU =1
&&&DOSDVFGID      NCWU=6
&&GILLIN      NCWU=6
&VAX      NCWU=9
      NCPU=7
      IPAGE(1)=10
      IPAGE(2)=8
      IPAGE(3)=120
      IPAGE(4)=88
      IPAGE(5)=20
      NCARU=2
      NCAWU=3
&&&DOSDVFGID      IQUN=2
&&&DOSDVFGID      JQUN=2
&&GILLIN      IQUN=2
&&GILLIN      JQUN=2
&VAX      IQUN=2
&VAX      JQUN=0
      IUSFLG = 0 
      NCSU = 11
      NCEXTR = 88
      NCQUE = 89
      NCCBU = 14
      NCFPU1 = 71
      NCFPU2 = 72
      NUCOM = 4
      NCVDU = 6
      NCEROR = 6
      NCADU = 40
      NCMU = 41
      NCCHW = 42
      NCPDU = 43
      NCDBU = 44


C --- XDISCS ---

      NCDFU =1
      NCNDU =12
      NCIFU =15
      NCLDU =15

C --- XTAPES ---

      MT1 = 48
      MT2 = 49
      MT3 = 50
      MTE = 51
      MTA = 52
      MTB = 53

C --- XTAPED ---

      NMTR =0

C --- XLST50 ---

      LCOM=13
      MCOM=29
      MDCOM=4
      NCOM=5
      MULT50=10000
      IDIM50=32
      LSTOFF=3

C --- XDAVAL ---

      IDAINI = 0
      IDATOT = -1
      IDAMAX = 0
      IDAMIN = 5
      IDAAUT = 1
      IDAQUA = 5
      IDATRY = 1

C --- XCBVAL ---

      ICBDIM = 9
      ICBLDD = -1
      ICBDAD = 0 
      ICBNFL = 1
      ICBMRN = 2
      ICBFIN = 3
      ICBDEQ = 4
      ICBCIN = 5
      ICBMAX = 6
      ICBTTL = 7
      ICBAUT = 8
      ICBLNF = 9

C --- XUNTNM ---

      IUNITN(1)= 0
      IUNITN(2)= 1
      IUNITN(3)= 9
      IUNITN(4)= 12
      IUNITN(5)= 15

C --- XLISTI ---

      MD0=8
      N0=0
      LN=0
      LSN=0
      IREC=0
      LEF=0
      LSTLEF=0
      MAPS=0

C --- XLEXIC ---

      LK=0
      LK1 = 0
      LK2 = 0
      NWCARD = 0
      LARG = 0
      MARG = 0
      MDARG = 0
      NARG = 0
      LCRD = 0
      MCRD = 0
      MDCRD = 0
      NCRD = 0
      MA = 0
      MB = 0
      MC = 0
      MD = 0
      ME = 0
      MF = 0
      MG = 0
      MH = 0
      MI = 0
      MJ = 0
      MK = 0
      ML = 0
      MM = 0
      MN = 0
      MO = 0
      MP = 0
      MQ = 0
      MR = 0
      MS = 0
      MT = 0
      MU = 0
      MV = 0
      MW = 0
      MX = 0
      MY = 0
      IRIC = 0
      Z  = ZRIC

C --- XFILE  ---
C --- XLISTS ---

      DO I=1,424
         INDEXF(I)=0
         LIST(I)=0
      ENDDO

C --- XCNTRL ---

      ISTAT2 = 0

C --- XSCSTK ---
C res PSCSTI

      DO I = 1,NFILVL
            ILEVEL(I)=0
      ENDDO
      DO I = 1,LSTACK
       DO J = 1,NSTACK
            ISTACK(I,J)=0
       ENDDO
      ENDDO

C --- XFILEC ---
      IFILE=1000000
      ILIST=1100000
      IEND=1111111
      LNFLE=416
      LNLST=416
      IACCL=-1

C --- XGUIOV ---
      ISERIA = 0
      LGUIL1 = .FALSE.
      LGUIL2 = .FALSE.
      LUPDAT = .FALSE.
      QSINL5 = .FALSE.
      RETURN
      END
