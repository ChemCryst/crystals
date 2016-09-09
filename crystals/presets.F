C $Log: presets.F,v $ 
C Revision 1.66  2012/03/23 13:54:08  rich
C Changed some common block variables into constants.
C
C Revision 1.65  2011/11/03 09:20:35  rich
C Initialise buffer for linearized error function.
C
C Revision 1.64  2011/09/20 13:15:46  rich
C Some new hollerith problems crept in.
C
C Revision 1.63  2011/09/07 09:44:41  djw
C Change format of #SET OPENMESSAGE text so that columns line up across actions
C Add #SET CACHEMESSAGE (off/on) to inhibit caching information at termination
C Remove disc extension messages
C
C Revision 1.62  2011/07/06 10:40:00  rich
C Added HPART and NHPART atom selection keywords to the lexical scanner. They select hydrogen atoms in a specific PART, or non-hydrogen atoms (respectively).
C
C Revision 1.61  2011/03/23 10:14:25  rich
C Fix and catch case where CRYSTALS runs out of pre-defined file units.
C
C Revision 1.60  2011/03/22 14:40:38  rich
C Added extra file unit 'SCP2' which may be read by new script command EXTRACT2
C
C Revision 1.59  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.58  2011/03/04 05:47:15  rich
C DVF to DIGITALF77 defines.
C
C Revision 1.57  2011/02/04 17:34:41  djw
C Enable LIST 9 operations
C
C Revision 1.56  2009/11/03 11:16:00  djw
C set Version to 14
C
C Revision 1.55  2009/10/28 16:27:56  djw
C Add error print to .LIS as well as screen. Correct base address for parameters in DELU (was mistakenly changed in last update) list16.fpp
C
C Revision 1.54  2009/06/24 07:23:14  djw
C Turn global logging back off - it causes writes to FORT.8 before a file is assigned
C  to the chanel. Rats.
C
C Revision 1.53  2009/06/08 14:23:19  djw
C Re-enable loggin of the primary input file so that the detailed action of SCRIPTS can be followed
C
C Revision 1.52  2007/10/09 06:54:09  djw
C Indicate avalable wiht Win XP
C
C Revision 1.51  2006/05/03 14:23:40  djw
C Write names of created hydrogens to a delete hydrogens file on unit NCCBU (the old common block file). Set attributes to CIF and unlocked
C
C Revision 1.50  2005/02/25 17:25:20  stefan
C 1. Added some preprocessor if defined lines for the mac version.
C
C Revision 1.49  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:08  rich
C Changed GIL to __GIL__ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:08  rich
C New CRYSTALS repository
C
C Revision 1.48  2004/03/16 12:19:00  rich
C Double size of store arrays to 64Mb.
C
C If a directive has a maximum count of >= 9999, then treat this as a
C special case, allowing an infinite number of directives of this
C type to be issued. (Suggest that if any directives really do
C need a maximum count to prevent, e.g. a runaway loop somewhere, then
C they be set to 9998).
C
C Revision 1.47  2003/09/29 15:38:34  rich
C Added \DEFINE system instruction for building the command file. No
C need for separate executable anymore. This command is \REMOVEd in
C the normal startup file to prevent accidents.
C
C Revision 1.46  2003/06/27 11:59:04  rich
C Globally replace FRAGMENT (slot in L5) and FRAGMENT(...) lexical keyword
C with RESIDUE. This should reduce confusion about what it is, and as FRAGMENT
C is only months old, no-one should notice the change anyway. So now it is
C #EDIT
C DELETE RESI(1) RESIDUE(2)
C END
C to delete residues 1 and 2.
C
C Revision 1.45  2003/06/27 09:19:52  rich
C Common block XFLAGS to hold bit-masks for information (RIDE,RIGID,DIST/ANGLE
C RESTRAINT/OCC CONSTRAINT etc) which is to be stored in L5, and later output
C to CIF to meet Acta requirements.
C
C Revision 1.44  2003/06/09 11:33:09  rich
C Set value of IOPBND.
C
C Revision 1.43  2003/05/07 12:18:54  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.42  2003/02/27 12:48:03  rich
C Change keyword for identifying slot 17 from "HYBRID" to "FRAGMENT".
C
C Revision 1.41  2003/02/27 11:49:50  rich
C
C Two BRAND NEW lexical things:
C
C  You can now use, wherever appropriate, REISDUE(1,X's) syntax to
C  select all atoms whose fragment number (slot 17 in L5) matches. This
C  works in EDIT, LIST 12, DIST, REGULARISE etc.
C
C  You can now use, wherever appropriate, TYPE(H,X's) syntax to
C  select all atoms whose type matches that given. This
C  works in EDIT, LIST 12, DIST, REGULARISE etc. Main use I can think
C  of is to quickly FIX all H positions (especially if using RESI to specify
C  bits to refine) or to special case a few heavy atoms: TYPE(AU,U'S).
C
C  If you say FULL U[ISO] TYPE(PB,U's) - it causes an error - this is better
C  than going silently crazy I suppose, but It would be nice if it just
C  overrode the iso setting, like FIX does: i.e. ALL(X'S) followed
C  by FIX(H,X'S) works as expected.
C
C Revision 1.40  2003/01/15 14:04:47  rich
C Add a character variable BLANKS to XCONST common block. Initialise it with
C spaces.
C
C Revision 1.39  2003/01/14 18:31:35  rich
C Right - this is a useful one and I'm quite pleased with it.
C
C Added a new lexical token PART to the scanner. The following
C examples show what you might do with it:
C ----
C Get distances between all atoms in part 1:
C   #DIST
C   INCLUDE PART(1)
C   END
C ----
C Competitively refine the occupancy of two parts, e.g. in disorder:
C   #LIST 12
C   FULL X'S U'S
C   EQUIV PART(1,OCC) PART(2,OCC)
C   WEIGHT -1 PART(1,OCC)
C   END
C ----
C Quickly id whole fragments in regularise:
C   #REGUL
C   target c(1) to c(6)
C   ideal c(11) to c(16)
C   cameron
C   map part(2)
C   onto part(1)
C   END
C ----
C Move a part of the structure:
C   #EDIT
C   ADD 0.2 PART(3,X)
C   END
C ----
C Have different regimes for refining e.g. a host and a guest molecule:
C   #LIST 12
C   FULL PART(0,X'S,U'S) PART(1,X'S,U[ISO])
C   END
C ----
C So it's quite handy. Part numbers are stored in the 15th slot of LIST 5, and
C are defined as follows:
C   ( 1000 * GROUPNUMBER ) + COMPONENTNUMBER.
C     e.g. 123456 is group 123 and component 456.
C   The same syntax is used to select a part in the lexical input:
C     e.g. PART(123456) selects atoms in group 123, component 456.
C   BUT, if the value of the group or component is 999, all atoms in that
C   group or component are selected.
C     e.g. PART(999003) selects all atoms with component 3 in their partnumber and
C     PART(4999) selects all atoms in group 4.
C
C The reason for having groups and parts is to enable logical grouping of, for example
C a disorder where all affected atoms are group 1, with each component being part 0,1,2 etc.
C
C NB. #script xparts runs a useful tool for defining part numbers.
C
C Revision 1.38  2002/12/04 14:31:11  rich
C Reformat output during refinement.
C
C Allow punching to MATLAB files, including restraints.
C
C Tidy some routines.
C
C Revision 1.37  2002/11/29 15:25:38  rich
C Add a variable MATLAB to XSFW common block, and zero it in presets. Keeps
C track of open files.
C
C Revision 1.36  2002/08/23 11:20:26  richard
C Increase STR11 and SORT to 32Mb each (8-fold increase), to allow refinement of
C bigger structures.
C
C Revision 1.35  2002/03/15 16:50:01  richard
C Type #SET BONDTYPE OFF to suppress bond type calculation.
C
C Revision 1.34  2002/03/12 18:02:50  ckp2
C GUIUP stores list serial numbers in a saved array. Moved it into common, clear out
C every re-start in presets.
C
C Revision 1.33  2002/02/27 19:24:55  ckp2
C RIC: Increase store to 32Mb. (The released versions have had this much store
C for over a year, I'd just never dared to check it in before.)
C
C Revision 1.32  2002/01/09 14:59:47  Administrator
C bound shifts, abandon ill-conditioned problem
C
C Revision 1.31  2001/10/05 13:31:52  ckp2
C
C Implementation of Lists 40 and 41.
C ===================================
C New commands:
C #LIST 41 - contains a list of bonds and bondtypes. It is generated by typing
C #BONDCALC which calculates bonds from LIST1,2,5,29 and 40.
C 40 contains info about how to do the bond calculation and can override
C covalent radii, force or break specific bonds and set limits for pairs
C of elements.
C #PUNCH 40 A - produces a LIST 40, #PUNCH 40 B - produces a #BONDING command
C which may be used to input a list 40 in a more user friendy manner (no READ
C card). #BONDING may also be used to EXTEND an existing list 40.
C #SUM L 40 - summary of bonding building info. #SUM L 41 - the bonds.
C #BONDCALC creates a L40 if there is none, and also only carries out calculation
C if significant change has occured to L5. (unless "#BONDCALC FORCE").
C See manual for more details.
C
C Revision 1.30  2001/09/11 08:27:43  ckp2
C Cut down GUI traffic by only sending status updates for flags that have
C actually changed (Flags: L1, L2, L3, L5, L6, QS, IN)
C
C Revision 1.29  2001/06/19 08:19:19  richard
C Increased store limits as two people have now hit the barrier for LIST 16
C size. A complete recompilation of all fortran sources is required for consitency.
C Do at least a "code fortran", or a "buildall" to be really sure.
C
C Revision 1.28  2001/01/17 11:04:11  richard
C Default to logging everything. Initialisation doesn't log anyway.
C
C Revision 1.27  2001/01/11 17:36:41  richard
C Initialise IOFORE and IOBACK, or no text appears to start with.
C
C Revision 1.26  2000/12/01 17:06:51  richard
C RIC: Change default release year to 2000
C
CODE FOR DATA
      BLOCK DATA CRYBLK
C--PRESETS FOR THE CRYSTALS SYSTEM
C
      INCLUDE 'PLSTHN.INC'
C
      INCLUDE 'TLISTC.INC'
      INCLUDE 'TDVNAM.INC'
      INCLUDE 'TSSCHR.INC'
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XDISC.INC'
      INCLUDE 'XDISCB.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XTIMES.INC'
      INCLUDE 'XNWPGE.INC'
      INCLUDE 'XUNTNM.INC'
      INCLUDE 'XFILEC.INC'
      INCLUDE 'XFILE.INC'
      INCLUDE 'XLISTS.INC'
      INCLUDE 'XCNTRL.INC'
C----- THE SCRIPT STACK
      INCLUDE 'PSCSTI.INC'
      PARAMETER (IDMSTK = LSTACK*NSTACK)
      INCLUDE 'XSCSTK.INC'
      INCLUDE 'XCOMPD.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLIMIT.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XSYSHF.INC'
      INCLUDE 'XSYSDR.INC'
      INCLUDE 'XDIRTP.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XTAPED.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XPRGNM.INC'
      INCLUDE 'XLEXCH.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XOPK.INC'
      INCLUDE 'XSCALE.INC'
      INCLUDE 'XSHORT.INC'
      INCLUDE 'XSTATS.INC'
      INCLUDE 'XFIRST.INC'
      INCLUDE 'XPCK06.INC'
C
C
      INCLUDE 'XDVNAM.INC'
C
      INCLUDE 'XLSTHN.INC'
C
      INCLUDE 'XSSCHR.INC'
C
      INCLUDE 'XSIZES.INC'
C
      INCLUDE 'XRGRP.INC'
C
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XERCNT.INC'
      INCLUDE 'XLSVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XDAVAL.INC'
      INCLUDE 'XCBVAL.INC'
C
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XSCMSG.INC'
      INCLUDE 'XERRRS.INC'
C
      INCLUDE 'XMENUI.INC'
C
      INCLUDE 'XDRIVE.INC'
C
      INCLUDE 'XL26WK.INC'
      INCLUDE 'OUTCOL.INC'
      INCLUDE 'XFLAGS.INC'
      DIMENSION VCVVEC(8192)
      REAL VCVVSZ
	  COMMON /VCVTMP/ VCVVSZ, VCVVEC

	  DATA VCVVSZ/0/
	  DATA VCVVEC/8192*0.0/
	  
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
      DATA ISIZST / 16777216 /, ISIZ11 / 33554432 /
C
#ifdef __VAX__
C      INITIALISE THE ENVIRONMENT TO BATCH
      DATA IQUN /2/, JQUN/0/
#else
C      SET INTERACTIVE UNDER ALL MODERN OSes
      DATA IQUN /2/, JQUN/2/
#endif
C      INITIALISE THE TAPE USE STACK
      DATA NMTR /0/
C      INITIALISE THE DISK INDEX
      DATA INDEXF/424*0/, LIST/424*0/
C      INITIALISE THE LEXICAL COMMON BLOCK
      DATA LK/2/,LK1/3/,LK2/4/,NWCARD/20/
      DATA LARG,MARG,MDARG,NARG,
     2 LCRD,MCRD,MDCRD,NCRD,MA,MB,MC,MD,ME,MF,MG,MH,
     3 MI,MJ,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,Z
     4 /34*0/
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
C 50    87   NCeXTr2        SCP2        1      1      1      1      0
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
#ifdef _H_P_ 
C      REASSIGN PRINTER IN STARTUP FILE
      DATA NCVDU/6/, NCAWU/6/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
#elif defined (__VAX__)
C      PRINTER ASSIGNED IN JOB CONTROL LANGUAGE
      DATA NCVDU/6/, NCAWU/3/, NCWU/9/, NCPU/7/, NCLU/8/, NCEROR/6/
#else
C      REASSIGN PRINTER IN STARTUP FILE
      DATA NCVDU/6/, NCAWU/3/, NCWU/6/, NCPU/7/, NCLU/8/, NCEROR/6/
#endif

      DATA NCADU/40/, NCMU/41/, NCCHW/42/, NCPDU/43/, NCDBU/44/
	  
C      THE AUXILLIARY INPUT DEVICE (REFLECTIONS)
      DATA NCARU /2/
C      THE SYSTEM SPY FILE
      DATA NCSU /11/
C      SYSTEM REQUEST QUEUE AND SEGMENTED SYSTEM COMMON BLOCK FILE
      DATA NUSRQ /63/, NCCBU /14/
C      INTERMEDIATE RESULT AND WORK FILES
      DATA MT1/48/, MT2/49/, MT3/50/, MTE/51/, MTA/52/, MTB/53/
C      THE SCRIPT QUEUE AND EXTRACT FILES
      DATA NCQUE /89/, NCEXTR /88/, NCEXTR2 /87/
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
      DATA IRDLOG / 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1 , 1,
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
C      NCADU, NCMU, NCCHW, NCPDU, NCDBU, SCP2
C
 
C
      DATA NFLUSD / 50 /
C
      DATA IFLUNI(1)  /  1 / , IFLUNI(2)  /  2 / , IFLUNI(3)  /  5 /
#ifdef __VAX__ 
      DATA IFLUNI(4)  /  9 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
#else
      DATA IFLUNI(4)  /  6 / , IFLUNI(5)  /  7 / , IFLUNI(6)  /  8 /
#endif
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
      DATA IFLUNI(48) / 43 / , IFLUNI(49) / 44 / , IFLUNI(50) / 87 /
C
C
#ifdef _HOL_
      DATA KEYFIL(1,1)  / 1HD / , KEYFIL(2,1)  / 1HI /
      DATA KEYFIL(3,1)  / 1HS / , KEYFIL(4,1)  / 1HC /
      DATA KEYFIL(5,1)  / 1HF / , KEYFIL(6,1)  / 1HI /
      DATA KEYFIL(7,1)  / 1HL / , KEYFIL(8,1)  / 1HE /
      DATA KEYFIL(1,2)  / 1HH / , KEYFIL(2,2)  / 1HK /
      DATA KEYFIL(3,2)  / 1HL / , KEYFIL(4,2)  / 1HI /
      DATA KEYFIL(5,2)  / 1H  / , KEYFIL(6,2)  / 1H  /
      DATA KEYFIL(7,2)  / 1H  / , KEYFIL(8,2)  / 1H  /
      DATA KEYFIL(1,3)  / 1HC / , KEYFIL(2,3)  / 1HO /
      DATA KEYFIL(3,3)  / 1HN / , KEYFIL(4,3)  / 1HT /
      DATA KEYFIL(5,3)  / 1HR / , KEYFIL(6,3)  / 1HO /
      DATA KEYFIL(7,3)  / 1HL / , KEYFIL(8,3)  / 1H  /
      DATA KEYFIL(1,4)  / 1HP / , KEYFIL(2,4)  / 1HR /
      DATA KEYFIL(3,4)  / 1HI / , KEYFIL(4,4)  / 1HN /
      DATA KEYFIL(5,4)  / 1HT / , KEYFIL(6,4)  / 1HE /
      DATA KEYFIL(7,4)  / 1HR / , KEYFIL(8,4)  / 1H  /
      DATA KEYFIL(1,5)  / 1HP / , KEYFIL(2,5)  / 1HU /
      DATA KEYFIL(3,5)  / 1HN / , KEYFIL(4,5)  / 1HC /
      DATA KEYFIL(5,5)  / 1HH / , KEYFIL(6,5)  / 1H  /
      DATA KEYFIL(7,5)  / 1H  / , KEYFIL(8,5)  / 1H  /
      DATA KEYFIL(1,6)  / 1HL / , KEYFIL(2,6)  / 1HO /
      DATA KEYFIL(3,6)  / 1HG / , KEYFIL(4,6)  / 1H  /
      DATA KEYFIL(5,6)  / 1H  / , KEYFIL(6,6)  / 1H  /
      DATA KEYFIL(7,6)  / 1H  / , KEYFIL(8,6)  / 1H  /
      DATA KEYFIL(1,7)  / 1HM / , KEYFIL(2,7)  / 1HO /
      DATA KEYFIL(3,7)  / 1HN / , KEYFIL(4,7)  / 1HI /
      DATA KEYFIL(5,7)  / 1HT / , KEYFIL(6,7)  / 1HO /
      DATA KEYFIL(7,7)  / 1HR / , KEYFIL(8,7)  / 1H  /
      DATA KEYFIL(1,8)  / 1HS / , KEYFIL(2,8)  / 1HP /
      DATA KEYFIL(3,8)  / 1HY / , KEYFIL(4,8)  / 1H  /
      DATA KEYFIL(5,8)  / 1H  / , KEYFIL(6,8)  / 1H  /
      DATA KEYFIL(7,8)  / 1H  / , KEYFIL(8,8)  / 1H  /
      DATA KEYFIL(1,9)  / 1HN / , KEYFIL(2,9)  / 1HE /
      DATA KEYFIL(3,9)  / 1HW / , KEYFIL(4,9)  / 1HD /
      DATA KEYFIL(5,9)  / 1HI / , KEYFIL(6,9)  / 1HS /
      DATA KEYFIL(7,9)  / 1HC / , KEYFIL(8,9)  / 1H  /
      DATA KEYFIL(1,10) / 1HE / , KEYFIL(2,10) / 1HX /
      DATA KEYFIL(3,10) / 1HC / , KEYFIL(4,10) / 1HO /
      DATA KEYFIL(5,10) / 1HM / , KEYFIL(6,10) / 1HM /
      DATA KEYFIL(7,10) / 1HO / , KEYFIL(8,10) / 1HN /
      DATA KEYFIL(1,11) / 1HC / , KEYFIL(2,11) / 1HO /
      DATA KEYFIL(3,11) / 1HM / , KEYFIL(4,11) / 1HM /
      DATA KEYFIL(5,11) / 1HA / , KEYFIL(6,11) / 1HN /
      DATA KEYFIL(7,11) / 1HD / , KEYFIL(8,11) / 1HS /
      DATA KEYFIL(1,12) / 1HU / , KEYFIL(2,12) / 1HS /
      DATA KEYFIL(3,12) / 1HE / , KEYFIL(4,12) / 1H1 /
      DATA KEYFIL(5,12) / 1H  / , KEYFIL(6,12) / 1H  /
      DATA KEYFIL(7,12) / 1H  / , KEYFIL(8,12) / 1H  /
      DATA KEYFIL(1,13) / 1HU / , KEYFIL(2,13) / 1HS /
      DATA KEYFIL(3,13) / 1HE / , KEYFIL(4,13) / 1H2 /
      DATA KEYFIL(5,13) / 1H  / , KEYFIL(6,13) / 1H  /
      DATA KEYFIL(7,13) / 1H  / , KEYFIL(8,13) / 1H  /
      DATA KEYFIL(1,14) / 1HU / , KEYFIL(2,14) / 1HS /
      DATA KEYFIL(3,14) / 1HE / , KEYFIL(4,14) / 1H3 /
      DATA KEYFIL(5,14) / 1H  / , KEYFIL(6,14) / 1H  /
      DATA KEYFIL(7,14) / 1H  / , KEYFIL(8,14) / 1H  /
      DATA KEYFIL(1,15) / 1HU / , KEYFIL(2,15) / 1HS /
      DATA KEYFIL(3,15) / 1HE / , KEYFIL(4,15) / 1H4 /
      DATA KEYFIL(5,15) / 1H  / , KEYFIL(6,15) / 1H  /
      DATA KEYFIL(7,15) / 1H  / , KEYFIL(8,15) / 1H  /
      DATA KEYFIL(1,16) / 1HM / , KEYFIL(2,16) / 1H3 /
      DATA KEYFIL(3,16) / 1H2 / , KEYFIL(4,16) / 1H  /
      DATA KEYFIL(5,16) / 1H  / , KEYFIL(6,16) / 1H  /
      DATA KEYFIL(7,16) / 1H  / , KEYFIL(8,16) / 1H  /
      DATA KEYFIL(1,17) / 1HM / , KEYFIL(2,17) / 1H3 /
      DATA KEYFIL(3,17) / 1H3 / , KEYFIL(4,17) / 1H  /
      DATA KEYFIL(5,17) / 1H  / , KEYFIL(6,17) / 1H  /
      DATA KEYFIL(7,17) / 1H  / , KEYFIL(8,17) / 1H  /
      DATA KEYFIL(1,18) / 1HM / , KEYFIL(2,18) / 1HT /
      DATA KEYFIL(3,18) / 1H1 / , KEYFIL(4,18) / 1H  /
      DATA KEYFIL(5,18) / 1H  / , KEYFIL(6,18) / 1H  /
      DATA KEYFIL(7,18) / 1H  / , KEYFIL(8,18) / 1H  /
      DATA KEYFIL(1,19) / 1HM / , KEYFIL(2,19) / 1HT /
      DATA KEYFIL(3,19) / 1H2 / , KEYFIL(4,19) / 1H  /
      DATA KEYFIL(5,19) / 1H  / , KEYFIL(6,19) / 1H  /
      DATA KEYFIL(7,19) / 1H  / , KEYFIL(8,19) / 1H  /
      DATA KEYFIL(1,20) / 1HM / , KEYFIL(2,20) / 1HT /
      DATA KEYFIL(3,20) / 1H3 / , KEYFIL(4,20) / 1H  /
      DATA KEYFIL(5,20) / 1H  / , KEYFIL(6,20) / 1H  /
      DATA KEYFIL(7,20) / 1H  / , KEYFIL(8,20) / 1H  /
      DATA KEYFIL(1,21) / 1HM / , KEYFIL(2,21) / 1HT /
      DATA KEYFIL(3,21) / 1HE / , KEYFIL(4,21) / 1H  /
      DATA KEYFIL(5,21) / 1H  / , KEYFIL(6,21) / 1H  /
      DATA KEYFIL(7,21) / 1H  / , KEYFIL(8,21) / 1H  /
      DATA KEYFIL(1,22) / 1HS / , KEYFIL(2,22) / 1HR /
      DATA KEYFIL(3,22) / 1HQ / , KEYFIL(4,22) / 1H  /
      DATA KEYFIL(5,22) / 1H  / , KEYFIL(6,22) / 1H  /
      DATA KEYFIL(7,22) / 1H  / , KEYFIL(8,22) / 1H  /
      DATA KEYFIL(1,23) / 1HF / , KEYFIL(2,23) / 1HR /
      DATA KEYFIL(3,23) / 1HN / , KEYFIL(4,23) / 1H1 /
      DATA KEYFIL(5,23) / 1HD / , KEYFIL(6,23) / 1HA /
      DATA KEYFIL(7,23) / 1HT / , KEYFIL(8,23) / 1HA /
      DATA KEYFIL(1,24) / 1HF / , KEYFIL(2,24) / 1HR /
      DATA KEYFIL(3,24) / 1HN / , KEYFIL(4,24) / 1H2 /
      DATA KEYFIL(5,24) / 1HD / , KEYFIL(6,24) / 1HA /
      DATA KEYFIL(7,24) / 1HT / , KEYFIL(8,24) / 1HA /
      DATA KEYFIL(1,25) / 1HS / , KEYFIL(2,25) / 1HC /
      DATA KEYFIL(3,25) / 1HP / , KEYFIL(4,25) / 1HD /
      DATA KEYFIL(5,25) / 1HA / , KEYFIL(6,25) / 1HT /
      DATA KEYFIL(7,25) / 1HA / , KEYFIL(8,25) / 1H  /
      DATA KEYFIL(1,26) / 1HS / , KEYFIL(2,26) / 1HC /
      DATA KEYFIL(3,26) / 1HP / , KEYFIL(4,26) / 1HQ /
      DATA KEYFIL(5,26) / 1HU / , KEYFIL(6,26) / 1HE /
      DATA KEYFIL(7,26) / 1HU / , KEYFIL(8,26) / 1HE /
      DATA KEYFIL(1,27) / 1HC / , KEYFIL(2,27) / 1HO /
      DATA KEYFIL(3,27) / 1HM / , KEYFIL(4,27) / 1HS /
      DATA KEYFIL(5,27) / 1HR / , KEYFIL(6,27) / 1HC /
      DATA KEYFIL(7,27) / 1H  / , KEYFIL(8,27) / 1H  /
      DATA KEYFIL(1,28) / 1HU / , KEYFIL(2,28) / 1HS /
      DATA KEYFIL(3,28) / 1HE / , KEYFIL(4,28) / 1H5 /
      DATA KEYFIL(5,28) / 1H  / , KEYFIL(6,28) / 1H  /
      DATA KEYFIL(7,28) / 1H  / , KEYFIL(8,28) / 1H  /
      DATA KEYFIL(1,29) / 1HU / , KEYFIL(2,29) / 1HS /
      DATA KEYFIL(3,29) / 1HE / , KEYFIL(4,29) / 1H6 /
      DATA KEYFIL(5,29) / 1H  / , KEYFIL(6,29) / 1H  /
      DATA KEYFIL(7,29) / 1H  / , KEYFIL(8,29) / 1H  /
      DATA KEYFIL(1,30) / 1HU / , KEYFIL(2,30) / 1HS /
      DATA KEYFIL(3,30) / 1HE / , KEYFIL(4,30) / 1H7 /
      DATA KEYFIL(5,30) / 1H  / , KEYFIL(6,30) / 1H  /
      DATA KEYFIL(7,30) / 1H  / , KEYFIL(8,30) / 1H  /
      DATA KEYFIL(1,31) / 1HU / , KEYFIL(2,31) / 1HS /
      DATA KEYFIL(3,31) / 1HE / , KEYFIL(4,31) / 1H8 /
      DATA KEYFIL(5,31) / 1H  / , KEYFIL(6,31) / 1H  /
      DATA KEYFIL(7,31) / 1H  / , KEYFIL(8,31) / 1H  /
      DATA KEYFIL(1,32) / 1HU / , KEYFIL(2,32) / 1HS /
      DATA KEYFIL(3,32) / 1HE / , KEYFIL(4,32) / 1H9 /
      DATA KEYFIL(5,32) / 1H  / , KEYFIL(6,32) / 1H  /
      DATA KEYFIL(7,32) / 1H  / , KEYFIL(8,32) / 1H  /
      DATA KEYFIL(1,33) / 1HV / , KEYFIL(2,33) / 1HD /
      DATA KEYFIL(3,33) / 1HU / , KEYFIL(4,33) / 1H  /
      DATA KEYFIL(5,33) / 1H  / , KEYFIL(6,33) / 1H  /
      DATA KEYFIL(7,33) / 1H  / , KEYFIL(8,33) / 1H  /
      DATA KEYFIL(1,34) / 1HE / , KEYFIL(2,34) / 1HR /
      DATA KEYFIL(3,34) / 1HR / , KEYFIL(4,34) / 1HO /
      DATA KEYFIL(5,34) / 1HR / , KEYFIL(6,34) / 1H  /
      DATA KEYFIL(7,34) / 1H  / , KEYFIL(8,34) / 1H  /
      DATA KEYFIL(1,35) / 1HU / , KEYFIL(2,35) / 1HS /
      DATA KEYFIL(3,35) / 1HE / , KEYFIL(4,35) / 1H1 /
      DATA KEYFIL(5,35) / 1H0 / , KEYFIL(6,35) / 1H  /
      DATA KEYFIL(7,35) / 1H  / , KEYFIL(8,35) / 1H  /
      DATA KEYFIL(1,36) / 1HU / , KEYFIL(2,36) / 1HS /
      DATA KEYFIL(3,36) / 1HE / , KEYFIL(4,36) / 1H1 /
      DATA KEYFIL(5,36) / 1H1 / , KEYFIL(6,36) / 1H  /
      DATA KEYFIL(7,36) / 1H  / , KEYFIL(8,36) / 1H  /
      DATA KEYFIL(1,37) / 1HU / , KEYFIL(2,37) / 1HS /
      DATA KEYFIL(3,37) / 1HE / , KEYFIL(4,37) / 1H1 /
      DATA KEYFIL(5,37) / 1H2 / , KEYFIL(6,37) / 1H  /
      DATA KEYFIL(7,37) / 1H  / , KEYFIL(8,37) / 1H  /
      DATA KEYFIL(1,38) / 1HU / , KEYFIL(2,38) / 1HS /
      DATA KEYFIL(3,38) / 1HE / , KEYFIL(4,38) / 1H1 /
      DATA KEYFIL(5,38) / 1H3 / , KEYFIL(6,38) / 1H  /
      DATA KEYFIL(7,38) / 1H  / , KEYFIL(8,38) / 1H  /
      DATA KEYFIL(1,39) / 1HU / , KEYFIL(2,39) / 1HS /
      DATA KEYFIL(3,39) / 1HE / , KEYFIL(4,39) / 1H1 /
      DATA KEYFIL(5,39) / 1H4 / , KEYFIL(6,39) / 1H  /
      DATA KEYFIL(7,39) / 1H  / , KEYFIL(8,39) / 1H  /
      DATA KEYFIL(1,40) / 1HU / , KEYFIL(2,40) / 1HS /
      DATA KEYFIL(3,40) / 1HE / , KEYFIL(4,40) / 1H1 /
      DATA KEYFIL(5,40) / 1H5 / , KEYFIL(6,40) / 1H  /
      DATA KEYFIL(7,40) / 1H  / , KEYFIL(8,40) / 1H  /
      DATA KEYFIL(1,41) / 1HU / , KEYFIL(2,41) / 1HS /
      DATA KEYFIL(3,41) / 1HE / , KEYFIL(4,41) / 1H1 /
      DATA KEYFIL(5,41) / 1H6 / , KEYFIL(6,41) / 1H  /
      DATA KEYFIL(7,41) / 1H  / , KEYFIL(8,41) / 1H  /
      DATA KEYFIL(1,42) / 1HU / , KEYFIL(2,42) / 1HS /
      DATA KEYFIL(3,42) / 1HE / , KEYFIL(4,42) / 1H1 /
      DATA KEYFIL(5,42) / 1H7 / , KEYFIL(6,42) / 1H  /
      DATA KEYFIL(7,42) / 1H  / , KEYFIL(8,42) / 1H  /
      DATA KEYFIL(1,43) / 1HU / , KEYFIL(2,43) / 1HS /
      DATA KEYFIL(3,43) / 1HE / , KEYFIL(4,43) / 1H1 /
      DATA KEYFIL(5,43) / 1H8 / , KEYFIL(6,43) / 1H  /
      DATA KEYFIL(7,43) / 1H  / , KEYFIL(8,43) / 1H  /
      DATA KEYFIL(1,44) / 1HU / , KEYFIL(2,44) / 1HS /
      DATA KEYFIL(3,44) / 1HE / , KEYFIL(4,44) / 1H1 /
      DATA KEYFIL(5,44) / 1H9 / , KEYFIL(6,44) / 1H  /
      DATA KEYFIL(7,44) / 1H  / , KEYFIL(8,44) / 1H  /
C
      DATA KEYFIL(1,45) / 1HA / , KEYFIL(2,45) / 1HT /
      DATA KEYFIL(3,45) / 1HO / , KEYFIL(4,45) / 1HM /
      DATA KEYFIL(5,45) / 1HS / , KEYFIL(6,45) / 1H  /
      DATA KEYFIL(7,45) / 1H  / , KEYFIL(8,45) / 1H  /
      DATA KEYFIL(1,46) / 1HM / , KEYFIL(2,46) / 1HE /
      DATA KEYFIL(3,46) / 1HN / , KEYFIL(4,46) / 1HU /
      DATA KEYFIL(5,46) / 1HE / , KEYFIL(6,46) / 1H  /
      DATA KEYFIL(7,46) / 1H  / , KEYFIL(8,46) / 1H  /
      DATA KEYFIL(1,47) / 1HC / , KEYFIL(2,47) / 1HH /
      DATA KEYFIL(3,47) / 1HA / , KEYFIL(4,47) / 1HR /
      DATA KEYFIL(5,47) / 1HT / , KEYFIL(6,47) / 1H  /
      DATA KEYFIL(7,47) / 1H  / , KEYFIL(8,47) / 1H  /
      DATA KEYFIL(1,48) / 1HP / , KEYFIL(2,48) / 1HR /
      DATA KEYFIL(3,48) / 1HO / , KEYFIL(4,48) / 1HG /
      DATA KEYFIL(5,48) / 1HR / , KEYFIL(6,48) / 1HE /
      DATA KEYFIL(7,48) / 1HS / , KEYFIL(8,48) / 1HS /
      DATA KEYFIL(1,49) / 1HD / , KEYFIL(2,49) / 1HI /
      DATA KEYFIL(3,49) / 1HA / , KEYFIL(4,49) / 1HL /
      DATA KEYFIL(5,49) / 1HO / , KEYFIL(6,49) / 1HG /
      DATA KEYFIL(7,49) / 1HU / , KEYFIL(8,49) / 1HE /
      DATA KEYFIL(1,50) / 1HS / , KEYFIL(2,50) / 1HC /
      DATA KEYFIL(3,50) / 1HP / , KEYFIL(4,50) / 1H2 /
      DATA KEYFIL(5,50) / 1H  / , KEYFIL(6,50) / 1H  /
      DATA KEYFIL(7,50) / 1H  / , KEYFIL(8,50) / 1H  /
#else
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
      DATA KEYFIL(1,50) / 'S' / , KEYFIL(2,50) / 'C' /
      DATA KEYFIL(3,50) / 'P' / , KEYFIL(4,50) / '2' /
      DATA KEYFIL(5,50) / ' ' / , KEYFIL(6,50) / ' ' /
      DATA KEYFIL(7,50) / ' ' / , KEYFIL(8,50) / ' ' /
#endif
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
      DATA IFLACC(48) / 1 / , IFLACC(49) / 1 / , IFLACC(50) / 1 /
C
      DATA IFLSTA(1)  / 3 / , IFLSTA(2)  / 1 / , IFLSTA(3)  / 1 /
      DATA IFLSTA(4)  / 2 / , IFLSTA(5)  / 2 / , IFLSTA(6)  / 2 /
      DATA IFLSTA(7)  / 2 / , IFLSTA(8)  / 2 / , IFLSTA(9)  / 2 /
      DATA IFLSTA(10) / 3 / , IFLSTA(11) / 1 / , IFLSTA(12) / 1 /
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
      DATA IFLSTA(48) / 1 / , IFLSTA(49) / 1 / , IFLSTA(50) / 1 /
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
      DATA IFLFRM(48) / 1 / , IFLFRM(49) / 1 / , IFLFRM(50) / 1 /
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
      DATA IFLREA(48) / 1 / , IFLREA(49) / 1 / , IFLREA(50) / 1 /
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
      DATA IFLOPN(48) / 0 / , IFLOPN(49) / 0 / , IFLOPN(50) / 0 /
C
      DATA IFLLCK(1)  / 2 / , IFLLCK(2)  / 1 / , IFLLCK(3)  / 2 /
      DATA IFLLCK(4)  / 1 / , IFLLCK(5)  / 1 / , IFLLCK(6)  / 1 /
      DATA IFLLCK(7)  / 1 / , IFLLCK(8)  / 2 / , IFLLCK(9)  / 1 /
      DATA IFLLCK(10) / 1 / , IFLLCK(11) / 2 / , IFLLCK(12) / 1 /
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
      DATA IFLLCK(48) / 1 / , IFLLCK(49) / 1 / , IFLLCK(50) / 1 /
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
#ifdef _HOL_ 
      DATA KTITL( 1)/4HTHIS/,KTITL( 2)/4H IS /,KTITL( 3)/4HTHE /
      DATA KTITL( 4)/4HDEFA/,KTITL( 5)/4HULT /,KTITL( 6)/4HSETT/
      DATA KTITL( 7)/4HING /,KTITL( 8)/4HFOR /,KTITL( 9)/4HTHE /
      DATA KTITL(10)/4HTITL/,KTITL(11)/4HE, P/,KTITL(12)/4HROVI/
      DATA KTITL(13)/4HDED /,KTITL(14)/4HWHEN/,KTITL(15)/4H NO /
      DATA KTITL(16)/4HUSER/,KTITL(17)/4H TIT/,KTITL(18)/4HLE I/
      DATA KTITL(19)/4HS GI/,KTITL(20)/4HVEN./
C
      DATA NUMB( 1)/1H0/,NUMB( 2)/1H1/,NUMB( 3)/1H2/,NUMB( 4)/1H3/
      DATA NUMB( 5)/1H4/,NUMB( 6)/1H5/,NUMB( 7)/1H6/,NUMB( 8)/1H7/
      DATA NUMB( 9)/1H8/,NUMB(10)/1H9/
      DATA IPLUS/1H+/,MINUS/1H-/,IA/1H*/,ISLASH/1H//,IEXP/2H**/
      DATA ILB/1H(/,IRB/1H)/,ICOMMA/1H,/,IEQUAL/1H=/,IPOINT/1H./
      DATA ISEMIC/1H;/,IQ/1H?/,IX(1)/1HX/,IX(2)/1HY/,IX(3)/1HZ/
      DATA IB / 1H  /
      DATA IH / 1H# /
C
C      'PAUS'      'HELP'      'SET '      'ATTA'      'OPEN'
C      'RELE'      'USE '      'MANU'      'TYPE'      'REMO'
C      'STOR'      'STAR'      'SCRI'      'COMM'      'CLOS'
C      'SPAW'      '$   '      'APPE'      'BENC'      'DEFI'
C
C
      DATA IHF / 1HP, 1HA, 1HU, 1HS, 1HH, 1HE, 1HL, 1HP,
     2           1HS, 1HE, 1HT, 1H , 1HA, 1HT, 1HT, 1HA,
     3           1HO, 1HP, 1HE, 1HN, 1HR, 1HE, 1HL, 1HE,
     4           1HU, 1HS, 1HE, 1H , 1HM, 1HA, 1HN, 1HU,
     5           1HT, 1HY, 1HP, 1HE, 1HR, 1HE, 1HM, 1HO,
     6           1HS, 1HT, 1HO, 1HR, 1HS, 1HT, 1HA, 1HR,
     7           1HS, 1HC, 1HR, 1HI, 1HC, 1HO, 1HM, 1HM,
     8           1HC, 1HL, 1HO, 1HS, 1HS, 1HP, 1HA, 1HW,
     9           1H$, 1H , 1H , 1H , 1HA, 1HP, 1HP, 1HE,
     1           1HB, 1HE, 1HN, 1HC, 1HD, 1HE, 1HF, 1HI  /

#else
      DATA KTITL( 1)/'THIS'/,KTITL( 2)/' IS '/,KTITL( 3)/'THE '/
      DATA KTITL( 4)/'DEFA'/,KTITL( 5)/'ULT '/,KTITL( 6)/'SETT'/
      DATA KTITL( 7)/'ING '/,KTITL( 8)/'FOR '/,KTITL( 9)/'THE '/
      DATA KTITL(10)/'TITL'/,KTITL(11)/'E, P'/,KTITL(12)/'ROVI'/
      DATA KTITL(13)/'DED '/,KTITL(14)/'WHEN'/,KTITL(15)/' NO '/
      DATA KTITL(16)/'USER'/,KTITL(17)/' TIT'/,KTITL(18)/'LE I'/
      DATA KTITL(19)/'S GI'/,KTITL(20)/'VEN.'/
C
      DATA NUMB( 1)/'0'/,NUMB( 2)/'1'/,NUMB( 3)/'2'/,NUMB( 4)/'3'/
      DATA NUMB( 5)/'4'/,NUMB( 6)/'5'/,NUMB( 7)/'6'/,NUMB( 8)/'7'/
      DATA NUMB( 9)/'8'/,NUMB(10)/'9'/
      DATA IPLUS/'+'/,MINUS/'-'/,IA/'*'/,ISLASH/'/'/,IEXP/'**'/
      DATA ILB/'('/,IRB/')'/,ICOMMA/','/,IEQUAL/'='/,IPOINT/'.'/
      DATA ISEMIC/';'/,IQ/'?'/,IX(1)/'X'/,IX(2)/'Y'/,IX(3)/'Z'/
C
      DATA IB / ' ' /
      DATA IH / '#' /
C
C      'PAUS'      'HELP'      'SET '      'ATTA'      'OPEN'
C      'RELE'      'USE '      'MANU'      'TYPE'      'REMO'
C      'STOR'      'STAR'      'SCRI'      'COMM'      'CLOS'
C      'SPAW'      '$   '      'APPE'      'BENC'      'DEFI'
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
     1           'B', 'E', 'N', 'C', 'D', 'E', 'F', 'I'  /
#endif
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
      DATA NWHF / 4 / , NHF / 20 / , LHF / 4 /
C
C
C
      DATA NWSPD/12/,NSPD/2/,LSPD/13/
      DATA ISPD(1,1)/8/
      DATA ISPD(1,2)/3/
#ifdef _HOL_
      DATA ISPD( 2,1)/1HC/,ISPD( 3,1)/1HO/,ISPD( 4,1)/1HN/
      DATA ISPD( 5,1)/1HT/,ISPD( 6,1)/1HI/,ISPD( 7,1)/1HN/
      DATA ISPD( 8,1)/1HU/,ISPD( 9,1)/1HE/,ISPD(10,1)/1H /
      DATA ISPD(11,1)/1H /,ISPD(12,1)/1H /,ISPD(13,1)/1H /
      DATA ISPD( 2,2)/1HE/,ISPD( 3,2)/1HN/,ISPD( 4,2)/1HD/
      DATA ISPD( 5,2)/1H /,ISPD( 6,2)/1H /,ISPD( 7,2)/1H /
      DATA ISPD( 8,2)/1H /,ISPD( 9,2)/1H /,ISPD(10,2)/1H /
      DATA ISPD(11,2)/1H /,ISPD(12,2)/1H /,ISPD(13,2)/1H /
#else
      DATA ISPD( 2,1)/'C'/,ISPD( 3,1)/'O'/,ISPD( 4,1)/'N'/
      DATA ISPD( 5,1)/'T'/,ISPD( 6,1)/'I'/,ISPD( 7,1)/'N'/
      DATA ISPD( 8,1)/'U'/,ISPD( 9,1)/'E'/,ISPD(10,1)/' '/
      DATA ISPD(11,1)/' '/,ISPD(12,1)/' '/,ISPD(13,1)/' '/
      DATA ISPD( 2,2)/'E'/,ISPD( 3,2)/'N'/,ISPD( 4,2)/'D'/
      DATA ISPD( 5,2)/' '/,ISPD( 6,2)/' '/,ISPD( 7,2)/' '/
      DATA ISPD( 8,2)/' '/,ISPD( 9,2)/' '/,ISPD(10,2)/' '/
      DATA ISPD(11,2)/' '/,ISPD(12,2)/' '/,ISPD(13,2)/' '/
#endif
C
C
C
C
      DATA LCOM/13/,MCOM/29/,MDCOM/4/,NCOM/5/
      DATA MULT50/10000/,IDIM50/32/,LSTOFF/3/
C
#ifdef _HOL_ 
      DATA KPRGNM( 1)/4H    /,KPRGNM( 2)/4H    /,KPRGNM( 3)/4H    /
      DATA KPRGNM( 4)/4H    /,KPRGNM( 5)/4H    /,KPRGNM( 6)/4H    /
      DATA KPRGNM( 7)/4H    /,KPRGNM( 8)/4H    /,KPRGNM( 9)/4H    /
      DATA KPRGNM(10)/4H    /,KPRGNM(11)/4H    /,KPRGNM(12)/4H    /
      DATA KPRGNM(13)/4H    /,KPRGNM(14)/4H    /,KPRGNM(15)/4H    /
      DATA KPRGNM(16)/4H    /,KPRGNM(17)/4H    /
C
      DATA IDTYPE(1,1)/4HINST/,IDTYPE(2,1)/4HRUCT/,IDTYPE(3,1)/4HION /
      DATA IDTYPE(1,2)/4H DIR/,IDTYPE(2,2)/4HECTI/,IDTYPE(3,2)/4HVE  /
      DATA IDTYPE(1,3)/4H PAR/,IDTYPE(2,3)/4HAMET/,IDTYPE(3,3)/4HER  /
      DATA IDTYPE(1,4)/4HINPU/,IDTYPE(2,4)/4HT VA/,IDTYPE(3,4)/4HLUE /
#else
      DATA KPRGNM( 1)/'    '/,KPRGNM( 2)/'    '/,KPRGNM( 3)/'    '/
      DATA KPRGNM( 4)/'    '/,KPRGNM( 5)/'    '/,KPRGNM( 6)/'    '/
      DATA KPRGNM( 7)/'    '/,KPRGNM( 8)/'    '/,KPRGNM( 9)/'    '/
      DATA KPRGNM(10)/'    '/,KPRGNM(11)/'    '/,KPRGNM(12)/'    '/
      DATA KPRGNM(13)/'    '/,KPRGNM(14)/'    '/,KPRGNM(15)/'    '/
      DATA KPRGNM(16)/'    '/,KPRGNM(17)/'    '/
C
      DATA IDTYPE(1,1)/'INST'/,IDTYPE(2,1)/'RUCT'/,IDTYPE(3,1)/'ION '/
      DATA IDTYPE(1,2)/' DIR'/,IDTYPE(2,2)/'ECTI'/,IDTYPE(3,2)/'VE  '/
      DATA IDTYPE(1,3)/' PAR'/,IDTYPE(2,3)/'AMET'/,IDTYPE(3,3)/'ER  '/
      DATA IDTYPE(1,4)/'INPU'/,IDTYPE(2,4)/'T VA'/,IDTYPE(3,4)/'LUE '/
C
#endif
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
C    JAN01 NKAV IS THE NUMBER OF REFINABLE PARAMETERS PER ATOM
CDJWSEP2000      DATA NWKA/2/, NKA/18/, LKA/2/, NKAS/15/, NKAO/7/
CDJWNOV2000      DATA NWKA/2/, NKA/20/, LKA/2/, NKAS/17/, NKAO/9/
CDJWJAN2001      DATA NWKA/2/, NKA/22/, LKA/2/, NKAS/19/, NKAO/11/
      DATA NWKA/2/, NKA/22/, LKA/2/, NKAS/19/, NKAO/11/, NKAV/11/
#ifdef _HOL_ 
      DATA ICOORD(1, 1)/4HTYPE/,ICOORD(2, 1)/4H    /
      DATA ICOORD(1, 2)/4HSERI/,ICOORD(2, 2)/4HAL  /
      DATA ICOORD(1, 3)/4HOCC /,ICOORD(2, 3)/4H    /
C      DATA ICOORD(1, 4)/4HU[IS/,ICOORD(2, 4)/4HO]  /
C-C-C-PARAM. FOR DISTINCT. BETW. ATOM (AN-/ISO.), SPHERE, LINE, RING
      DATA ICOORD(1, 4)/4HFLAG/,ICOORD(2, 4)/4H    /
      DATA ICOORD(1, 5)/4HX   /,ICOORD(2, 5)/4H    /
      DATA ICOORD(1, 6)/4HY   /,ICOORD(2, 6)/4H    /
      DATA ICOORD(1, 7)/4HZ   /,ICOORD(2, 7)/4H    /
      DATA ICOORD(1, 8)/4HU[11/,ICOORD(2, 8)/4H]   /
      DATA ICOORD(1, 9)/4HU[22/,ICOORD(2, 9)/4H]   /
      DATA ICOORD(1,10)/4HU[33/,ICOORD(2,10)/4H]   /
      DATA ICOORD(1,11)/4HU[23/,ICOORD(2,11)/4H]   /
      DATA ICOORD(1,12)/4HU[13/,ICOORD(2,12)/4H]   /
      DATA ICOORD(1,13)/4HU[12/,ICOORD(2,13)/4H]   /
      DATA ICOORD(1,14)/4HSPAR/, ICOORD(2,14)/4HE   /
C
CSEP2000  NEW NAMES
      DATA ICOORD(1,15)/4HPART/,ICOORD(2,15)/4H    /
      DATA ICOORD(1,16)/4HREF /,ICOORD(2,16)/4H    /
CNOV2000  MORE NEW NAMES
      DATA ICOORD(1,17)/4HRESI/,ICOORD(2,17)/4HDUE /
      DATA ICOORD(1,18)/4HNEW /,ICOORD(2,18)/4H    /
C
C----- THE EXTENDED PARAMETER NAMES
      DATA ICOORD(1,19)/4HU[IS/,ICOORD(2,19)/4HO]  /
      DATA ICOORD(1,20)/4HSIZE/,ICOORD(2,20)/4H    /
      DATA ICOORD(1,21)/4HDECL/,ICOORD(2,21)/4HINAT/
      DATA ICOORD(1,22)/4HAZIM/,ICOORD(2,22)/4HUTH /
C
#else
      DATA ICOORD(1, 1)/'TYPE'/,ICOORD(2, 1)/'    '/
#endif
#if !defined(_HOL_) 
      DATA ICOORD(1, 2)/'SERI'/,ICOORD(2, 2)/'AL  '/
      DATA ICOORD(1, 3)/'OCC '/,ICOORD(2, 3)/'    '/
C      DATA ICOORD(1, 4)/'U[IS'/,ICOORD(2, 4)/'O]  '/
C-C-C-PARAM. FOR DISTINCT. BETW. ATOM (AN-/ISO.), SPHERE, LINE, RING
      DATA ICOORD(1, 4)/'FLAG'/,ICOORD(2, 4)/'    '/
      DATA ICOORD(1, 5)/'X   '/,ICOORD(2, 5)/'    '/
      DATA ICOORD(1, 6)/'Y   '/,ICOORD(2, 6)/'    '/
      DATA ICOORD(1, 7)/'Z   '/,ICOORD(2, 7)/'    '/
      DATA ICOORD(1, 8)/'U[11'/,ICOORD(2, 8)/']   '/
      DATA ICOORD(1, 9)/'U[22'/,ICOORD(2, 9)/']   '/
      DATA ICOORD(1,10)/'U[33'/,ICOORD(2,10)/']   '/
      DATA ICOORD(1,11)/'U[23'/,ICOORD(2,11)/']   '/
      DATA ICOORD(1,12)/'U[13'/,ICOORD(2,12)/']   '/
      DATA ICOORD(1,13)/'U[12'/,ICOORD(2,13)/']   '/
      DATA ICOORD(1,14)/'SPAR'/, ICOORD(2,14)/'E   '/
CSEP2000  NEW NAMES
      DATA ICOORD(1,15)/'PART'/,ICOORD(2,15)/'    '/
      DATA ICOORD(1,16)/'REF '/,ICOORD(2,16)/'    '/
CSEP2000  MORE NEW NAMES
      DATA ICOORD(1,17)/'RESI'/,ICOORD(2,17)/'DUE '/
      DATA ICOORD(1,18)/'NEW '/,ICOORD(2,18)/'    '/
C
C-C-C-ADDITIONAL KEYWORDS FOR SPHERE, LINE, RING
C-C-C-(ATTENTION: IT MIGHT BE REASONABLE NOT TO SUMMARIZE SPHERE-RADIUS,
C-C-C-            LINE-LENGTH, RING-RADIUS IN SIZE, BECAUSE THERE MIGHT
C-C-C-            MORE FIGURES BE ADDED TO THE PROGRAM WITH MORE THAN
C-C-C-            ONE PARAMETER FOR THE SIZE !?)
C
      DATA ICOORD(1,19)/'U[IS'/,ICOORD(2,19)/'O]  '/
      DATA ICOORD(1,20)/'SIZE'/,ICOORD(2,20)/'    '/
      DATA ICOORD(1,21)/'DECL'/,ICOORD(2,21)/'INAT'/
      DATA ICOORD(1,22)/'AZIM'/,ICOORD(2,22)/'UTH '/
C
C
#endif
      DATA NWKO/2/,NKO/6/,LKO/2/
#ifdef _HOL_ 
      DATA KVP(1,1)/4HSCAL/,KVP(2,1)/4HE   /
      DATA KVP(1,2)/4HDU[I/,KVP(2,2)/4HSO] /
      DATA KVP(1,3)/4HOU[I/,KVP(2,3)/4HSO] /
      DATA KVP(1,4)/4HPOLA/,KVP(2,4)/4HRITY/
      DATA KVP(1,5)/4HENAN/,KVP(2,5)/4HTIO /
      DATA KVP(1,6)/4HEXTP/,KVP(2,6)/4HARAM/
C
#else
      DATA KVP(1,1)/'SCAL'/,KVP(2,1)/'E   '/
#endif
#if !defined(_HOL_) 
      DATA KVP(1,2)/'DU[I'/,KVP(2,2)/'SO] '/
      DATA KVP(1,3)/'OU[I'/,KVP(2,3)/'SO] '/
      DATA KVP(1,4)/'POLA'/,KVP(2,4)/'RITY'/
      DATA KVP(1,5)/'ENAN'/,KVP(2,5)/'TIO '/
      DATA KVP(1,6)/'EXTP'/,KVP(2,6)/'ARAM'/
C
C
#endif
      DATA NWSC/2/,NSC/6/,LSC/2/
C
#ifdef _HOL_ 
      DATA KSCAL(1,1)/4HSCAL/,KSCAL(2,1)/4HES  /
      DATA KSCAL(1,2)/4HPARA/,KSCAL(2,2)/4HMETE/
      DATA KSCAL(1,3)/4HLAYE/,KSCAL(2,3)/4HR   /
      DATA KSCAL(1,4)/4HELEM/,KSCAL(2,4)/4HENT /
      DATA KSCAL(1,5)/4HBATC/,KSCAL(2,5)/4HH   /
      DATA KSCAL(1,6)/4HCELL/,KSCAL(2,6)/4H    /
      DATA KSCAL(1,7)/4HPROF/,KSCAL(2,7)/4HILE /
      DATA KSCAL(1,8)/4HEXTI/,KSCAL(2,8)/4HNCTI/
C
      DATA MXS(1,1)/4HU'S  /,MXS(2,1)/4H    /
      DATA MXS(1,2)/4HUII'/,MXS(2,2)/4HS   /
      DATA MXS(1,3)/4HUIJ'/,MXS(2,3)/4HS   /
      DATA MXS(1,4)/4HX'S /,MXS(2,4)/4H    /
      DATA MXS(1,5)/4HORIE/,MXS(2,5)/4HNTAT/
C
      DATA IFIRST(1)/4HFIRS/,IFIRST(2)/4HLAST/,IFIRST(3)/4HPART/
     1     IFIRST(4)/4HRESI/,IFIRST(5)/4HTYPE/,
     2     IFIRST(6)/4HHPAR/,IFIRST(7)/4HNHPA/
#else
      DATA KSCAL(1,1)/'SCAL'/,KSCAL(2,1)/'ES  '/
      DATA KSCAL(1,2)/'PARA'/,KSCAL(2,2)/'METE'/
      DATA KSCAL(1,3)/'LAYE'/,KSCAL(2,3)/'R   '/
      DATA KSCAL(1,4)/'ELEM'/,KSCAL(2,4)/'ENT '/
      DATA KSCAL(1,5)/'BATC'/,KSCAL(2,5)/'H   '/
      DATA KSCAL(1,6)/'CELL'/,KSCAL(2,6)/'    '/
      DATA KSCAL(1,7)/'PROF'/,KSCAL(2,7)/'ILE '/
      DATA KSCAL(1,8)/'EXTI'/,KSCAL(2,8)/'NCTI'/
C
      DATA MXS(1,1)/'U''S '/,MXS(2,1)/'    '/
      DATA MXS(1,2)/'UII'''/,MXS(2,2)/'S   '/
      DATA MXS(1,3)/'UIJ'''/,MXS(2,3)/'S   '/
      DATA MXS(1,4)/'X''S '/,MXS(2,4)/'    '/
      DATA MXS(1,5)/'ORIE'/,MXS(2,5)/'NTAT'/
C
      DATA IFIRST(1)/'FIRS'/,IFIRST(2)/'LAST'/,IFIRST(3)/'PART'/
     1     IFIRST(4)/'RESI'/,IFIRST(5)/'TYPE'/,IFIRST(6)/'HPAR'/,
     2     IFIRST(7)/'NHPA'/
#endif
      DATA NWXS/2/,NXS/5/,LXS/2/
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
C      ISSBND      BOND TYPING FOR MODEL WINDOW
C      ISSCSH      CASHING MESSAGES (OFF/ON)
C      ISSRAT      RATIO = (IO OR IC)/SIGMA (0/1) 
C
C (THE FOLLOWING 4 DEFINITIONS ARE REDUNDANT, AND ARE REPLACED BY
C  THE CHARACTER DEFINITIONS 'CSS***)
#if defined(_DOS_) 
      DATA ISSMAC(1) / ' 486' / , ISSMAC(2) / '  PC' /
      DATA ISSOPS(1) / ' DOS' / , ISSOPS(2) / '6.22' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Feb' /
      DATA ISSDAT(3) / '  19' / , ISSDAT(4) / '97  ' /
 
#elif defined(__DVF__) || defined(__GID__) 
      DATA ISSMAC(1) / 'Pent' / , ISSMAC(2) / 'ium ' /
      DATA ISSOPS(1) / ' WIN' / , ISSOPS(2) / '32  ' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Dec' /
      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '13  ' /
#elif defined(__GIL__) || defined(__LIN__)
#ifdef _HOL_
      DATA ISSMAC(1) / 4HInte / , ISSMAC(2) / 4Hl    /
      DATA ISSOPS(1) / 4HLinu / , ISSOPS(2) / 4Hx    /
      DATA ISSDAT(1) / 4H     / , ISSDAT(2) / 4H Dec /
      DATA ISSDAT(3) / 4H  20 / , ISSDAT(4) / 4H13   /
#else
      DATA ISSMAC(1) / 'Inte' / , ISSMAC(2) / 'l ' /
      DATA ISSOPS(1) / 'Linu' / , ISSOPS(2) / 'x   ' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Jun' /
      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '00  ' /
#endif
#elif defined(__MAC__)
#ifdef _HOL_
      DATA ISSMAC(1) / 4HInte / , ISSMAC(2) / 4Hl    /
      DATA ISSOPS(1) / 4HMacO / , ISSOPS(2) / 4HS    /
      DATA ISSDAT(1) / 4H     / , ISSDAT(2) / 4H Dec /
      DATA ISSDAT(3) / 4H  20 / , ISSDAT(4) / 4H13   /
#else
      DATA ISSMAC(1) / 'Inte' / , ISSMAC(2) / 'l ' /
      DATA ISSOPS(1) / 'MacO' / , ISSOPS(2) / 's   ' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Jun' /
      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '00  ' /
#endif
#elif defined(__WXS__)  || defined (__INW__)
#ifdef _HOL_
      DATA ISSMAC(1) / 4HInte / , ISSMAC(2) / 4Hl    /
      DATA ISSOPS(1) / 4HMacO / , ISSOPS(2) / 4HS    /
      DATA ISSDAT(1) / 4H     / , ISSDAT(2) / 4H Dec /
      DATA ISSDAT(3) / 4H  20 / , ISSDAT(4) / 4H13   /
#else
      DATA ISSMAC(1) / 'Inte' / , ISSMAC(2) / 'l   ' /
      DATA ISSOPS(1) / 'Win3' / , ISSOPS(2) / '2   ' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Dec' /
      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '13  ' /
#endif
#elif defined(__VAX__) 
      DATA ISSMAC(1) / ' DEC' / , ISSMAC(2) / ' VAX' /
      DATA ISSOPS(1) / ' VMS' / , ISSOPS(2) / ' 5.0' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / ' Feb' /
      DATA ISSDAT(3) / '  19' / , ISSDAT(4) / '90  ' /
#elif defined(__MIN__)
#ifdef _HOL_
      DATA ISSMAC(1) / 4HMinG / , ISSMAC(2) / 4HW    /
      DATA ISSOPS(1) / 4HWin3 / , ISSOPS(2) / 4H3    /
      DATA ISSDAT(1) / 4H     / , ISSDAT(2) / 4H     /
      DATA ISSDAT(3) / 4H  20 / , ISSDAT(4) / 4H14   /
#else
      DATA ISSMAC(1) / 'MinG' / , ISSMAC(2) / 'W ' /
      DATA ISSOPS(1) / 'Win3' / , ISSOPS(2) / '3 ' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / '    ' /
      DATA ISSDAT(3) / '  20' / , ISSDAT(4) / '14  ' /
#endif
#else
#ifdef _HOL_
      DATA ISSMAC(1) / 4HUnkn / , ISSMAC(2) / 4Hown  /
      DATA ISSOPS(1) / 4HUnkn / , ISSOPS(2) / 4Hown  /
      DATA ISSDAT(1) / 4H     / , ISSDAT(2) / 4H     /
      DATA ISSDAT(3) / 4H  19 / , ISSDAT(4) / 4H63   /
#else
      DATA ISSMAC(1) / 'Unkn' / , ISSMAC(2) / 'own ' /
      DATA ISSOPS(1) / 'Unkn' / , ISSOPS(2) / 'own ' /
      DATA ISSDAT(1) / '    ' / , ISSDAT(2) / '    ' /
      DATA ISSDAT(3) / '  19' / , ISSDAT(4) / '63  ' /
#endif
#endif

      DATA ISSISS     / 14 / ,     ISSVER     / 1400 /
      DATA ISSSEG / -1 /
C
      DATA ISSOLD / 1 / , ISSNEW / 2 / , ISSCIF / 3 /
      DATA ISSSCR / 4 / , ISSUNK / 5 / , ISSGEN / 0 /
      DATA ISSFLM / 0 / , ISSPAS / 0 /
C RICJUL00
      DATA ISSSEQ / 1 / , ISSDAF / 2 /
C
      DATA ISSREA / 1 /, ISSWRI / 2 /, ISSAPP /3/
#if defined(__INTEL_COMPILER) || defined(CRY_FORTDIGITAL)
      DATA ISSFNF /  29 /
#elif defined(CRY_OSMAC)
      DATA ISSFNF /  2 /
#else
      DATA ISSFNF /  2 /
#endif
      DATA ISSOKF / 0 /
      DATA ISSEOF /-1 /
      DATA ISSERF / 1 /
C
C  BUFFERS INCREASED TO 24, SEPT 1998 - DONT FORGET XLINK
C^      DATA ISSNBF / 6 / , ISSBFS / 3200 /
      DATA ISSNBF / 24 / , ISSBFS / 12928 /
C
      DATA ISSPAG / 128 /
#if !defined(_H_P_) 
      DATA ISSRLI / 512 / , ISSBLI / 128 / , ISSWLI / 4 /
      DATA ISSRLF / 512 / , ISSBLF / 128 / , ISSWLF / 4 /
#else
      DATA ISSRLI / 512 / , ISSBLI / 512 / , ISSWLI / 4 /
      DATA ISSRLF / 512 / , ISSBLF / 512 / , ISSWLF / 4 /
#endif
C
C----- THE DIRECT ACCESS FILE PHYSICAL RECORD LENGTH IS MACINE SPECIFIC
C      ISSDAR specifies the number of logical records, ie the number of single precision real numbers
C      The final value passed to recl is calculated using inquire(iolength) times ISSDAR
C      This allow to take into account different compilers and platform and keep the pysicial record constant.
      DATA ISSDAR / 512 /

#ifdef _HOL_
      DATA ISSPRG(1) / 4HCRYS / , ISSPRG(2) / 4HTALS /
#else
      DATA ISSPRG(1) / 'CRYS' / , ISSPRG(2) / 'TALS' /
#endif
C
      DATA ISSLSM / 3 / , ISSSPD / 2 / , ISSTIM / 1 /
C
      DATA ISSL11 / 1 /
      DATA ISSLNM / 5 /
#if !defined(_H_P_) 
      DATA ISSINI / 1 / , ISSSTA / 1 / , ISSBAN / 0 /
#else
      DATA ISSINI / 1 / , ISSSTA / 1 / , ISSBAN / 1 /
#endif
      DATA ISSSFI / 1 /, ISSTML /0/, ISSFLC /2/, ISSMSG /1/
      DATA ISSPRT / -1/, ISSEXP /1/,   ISSUEQ /1/, ISSUPD /0/, ISSBND/1/
      DATA ISSCSH /0/, ISSRAT /0/
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
      DATA CSSDAT / 'February  2000' /
      DATA LSSDAT / 14 /
      DATA CSSSVN / '5555' /
      DATA LSSSVN / 4 /
#ifdef _H_P_ 
      DATA CSSMAC / 'HP UNIX' /
      DATA LSSMAC / 7 /
      DATA CSSOPS / 'Version X.X' /
      DATA LSSOPS / 11 /
#elif defined(_DOS_) 
      DATA CSSMAC / 'Intel 80X86' /
      DATA LSSMAC / 11 /
      DATA CSSOPS / 'DOS 7.0' /
      DATA LSSOPS / 7 /
#elif defined(CRY_OSWIN32)
      DATA CSSMAC / 'Intel' /
      DATA LSSMAC / 5 /
      DATA CSSOPS / 'Win32' /
      DATA LSSOPS / 5 /
#elif defined(CRY_OSLINUX)
      DATA CSSMAC / 'Intel' /
      DATA LSSMAC / 5 /
      DATA CSSOPS / 'Linux' /
      DATA LSSOPS / 5 /
#elif defined (CRY_OSMAC)
      DATA CSSMAC / 'Intel' /
      DATA LSSMAC / 5 /
      DATA CSSOPS / 'MacOS' /
      DATA LSSOPS / 5 /
#elif defined(__VAX__) 
      DATA CSSMAC / 'DEC VAX' /
      DATA LSSMAC / 7 /
      DATA CSSOPS / 'VMS 5' /
      DATA LSSOPS / 5 /
#else 
      DATA CSSMAC / 'Unknown' /
      DATA LSSMAC / 7 /
      DATA CSSOPS / 'None' /
      DATA LSSOPS / 4 /
#endif

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
      DATA LSSDST / 19 /
C
#ifdef _H_P_ 
      DATA CSSSCT / '/users/oxford/scatt.dat' /
      DATA LSSSCT / 23 /
      DATA CSSELE / '/users/oxford/propwin.dat' /
      DATA LSSELE / 24 /
#elif defined(__VAX__) 
      DATA CSSSCT / 'CRSCP:scatt.dat' /
      DATA LSSSCT / 15 /
      DATA CSSELE / 'CRSCP:propwin.dat' /
      DATA LSSELE / 17 /
#else
      DATA CSSSCT / ' ' /
      DATA LSSSCT / 1 /
      DATA CSSELE / ' ' /
      DATA LSSELE / 1 /
#endif
#ifdef _H_P_ 
      DATA CSSVDU  / 'VDU' /
      DATA LSSVDU / 3 /
#elif defined(__VAX__) 
      DATA CSSVDU  / 'SYS$COMMAND' /
      DATA LSSVDU / 11 /
#else
      DATA CSSVDU  / 'CON' /
      DATA LSSVDU / 3 /
#endif
C
#ifdef _H_P_ 
      DATA CSSLPT  / 'LPT' /
      DATA LSSLPT / 3 /
#elif defined(__VAX__) 
      DATA CSSLPT  / 'SYS$PRINT' /
      DATA LSSLPT / 9 /
#else
      DATA CSSLPT  / 'PRN' /
      DATA LSSLPT / 3 /
#endif

      DATA CSSCIF / 'publish.cif' /
      DATA LSSCIF / 11 /

      DATA CSSMAP / 'fourier.map' /
      DATA LSSMAP / 11 /
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
c - now in parameter statement
c      DATA ILSCLN / 1 / , ILSCLS / 2 / , ILSCLV / 3 /
c      DATA ILSEXI / 4 / , ILSAVI / 5 / , ILSRFI / 6 /
cC    REQUEST CODES FOR 'KLSCHK'
c      DATA ILSMSG / 1 / , ILSNMS / -1 /
cC    FUNCTION CODES FOR 'XLSALT'
c      DATA ILSERF / 1 / , ILSPUF / 2 / , ILSDLF / 3 /
c      DATA ILSOWF / 4 / , ILSCUR / 5 / , ILSRTF / 2 /
cC    FLAG CODES FOR 'XLSALT'
c      DATA ILSSET / -1 / , ILSCLR / 1 /
c      DATA ILSOVR / -1 / , ILSRDY / 0 / , ILSUPD / 1 /
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
      DATA IOPCMP / 46 / , IOPBND / 47 /
C -- SYMBOLIC CODES FOR MESSAGE TYPES
      DATA IOPABN / 1 / , IOPCMI / 2 / , IOPEND / 3 /
      DATA IOPPRC / 4 / , IOPSPC / 5 / , IOPLSP / 6 /
      DATA IOPINT / 7 / , IOPLSE / 8 / , IOPVER / 9 /
C -- VALUES FOR ERRORS STORED IN LIST 39
      DATA NXWAVE / 1 /

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
      DATA ILSTHN / 1 , 2 , 3 , 3 , 4 , 7 , 6 , 6 , 4 , 4 ,
     2              3 , 5 , 3 , 3 , 6 , 5 , 5 , 5 , 6 , 3 ,
     3              6 , 6 , 3 , 3 , 3 , 7 , 3 , 3 , 3 , 4 ,
     4              3 , 6 , 7 , 6 , 6 , 6 , 6 , 3 , 3 , 3 ,
     5              3 , 6 , 6 , 6 , 6 , 6 , 6 , 6 , 6 , 6 /
C
C
      DATA IOLDC / 0 /
      DATA IOFORE / -1 /
      DATA IOBACK / -1 /

C Bits set in the REF parameter of list 5 depending on refinement.
C Will be used to set the _atom_site_refinement_flags CIF item.
      DATA KBREFB(1) / 65536 /   ! S 'special position constraint'
      DATA KBREFB(2) / 131072 /  ! G 'rigid group'
      DATA KBREFB(3) / 262144 /  ! R 'riding atom attached to non-riding atom' (?)
      DATA KBREFB(4) / 524288 /  ! D 'dist or angle restraint'
      DATA KBREFB(5) / 1048576 / ! T 'thermal displacement constraints'
      DATA KBREFB(6) / 2097152 / ! U 'Uiso or Uij restraint (rigid bond)'
      DATA KBREFB(7) / 4194304 / ! P 'partial occupancy constraint'
      DATA KBCIFF / 'SGRDTUP' /

C Will be used to set the _atom_site_calc_flag and the
C _refine_ls_hydrogen_treatment CIF items.
      DATA KBREFX / 8388608 / ! X,Y, or Z refined.
      DATA KBREFU / 16777216 / ! Any temp factor refined.

C NB cif dictionary makes no allowance for:
C     Thermal displacement restraints (SIMU, DELU etc.)
C     Non-distance or angle restraints
C Implemented so far: G,R,D,U,P   To do: S,T
C
C
C      THE NAMES OF THE VARIOUS RESTRAINTS
      DATA 
     1 coperation(1  ) /'DEFINE'/,
     1 coperation(2  ) /'RESTRAIN'/,
     1 coperation(3  ) /'DISTANCE'/,
     1 coperation(4  ) /'DIFFERENCE DIST'/,
     1 coperation(5  ) /'MEAN DIST'/,
     1 coperation(6  ) /'ANGLE'/,
     1 coperation(7  ) /'DIFFERENCE ANGLE'/,
     1 coperation(8  ) /'MEAN ANGLE'/,
     1 coperation(9  ) /'VIBRATION'/,
     1 coperation(10 ) /'EXECUTION'/,
     1 coperation(11 ) /'NOLIST'/,
     1 coperation(12 ) /'UIJ'/,
     1 coperation(13 ) /'EQUATE'/,
     1 coperation(14 ) /'PLANAR'/,
     1 coperation(15 ) /'SUM'/,
     1 coperation(16 ) /'FORM'/,
     1 coperation(17 ) /'AVERAGE'/,
     1 coperation(18 ) /'LIMIT'/,
     1 coperation(19 ) /'ENERGY'/,
     1 coperation(20 ) /'ORIGIN'/
C
C

      END
C
C
CODE FOR SYNBLK
      BLOCK DATA SYNBLK
      INCLUDE 'XPARSE.INC'
C
C--CONTROL VALUES FOR THE SYSTEM VARIABLES
      DATA NWSV/1/,NSV/20/,LSV/3/
C--THE SYSTEM VARIABLES
#ifdef _HOL_
      DATA KSV(2, 1)/4/,KSV(3, 1)/4HA   /
      DATA KSV(2, 2)/1/,KSV(3, 2)/4HCV  /
      DATA KSV(2, 3)/4/,KSV(3, 3)/4HAR  /
      DATA KSV(2, 4)/1/,KSV(3, 4)/4HRCV /
      DATA KSV(2, 5)/6/,KSV(3, 5)/4HG   /
      DATA KSV(2, 6)/6/,KSV(3, 6)/4HGR  /
      DATA KSV(2, 7)/6/,KSV(3, 7)/4HL   /
      DATA KSV(2, 8)/6/,KSV(3, 8)/4HLR  /
      DATA KSV(2, 9)/2/,KSV(3, 9)/4HCONV/
      DATA KSV(2,10)/4/,KSV(3,10)/4HRIJ /
      DATA KSV(2,11)/4/,KSV(3,11)/4HANIS/
      DATA KSV(2,12)/12/,KSV(3,12)/4HSM  /
      DATA KSV(2,13)/12/,KSV(3,13)/4HSMI /
      DATA KSV(2,14)/9/,KSV(3,14)/4HNPLT/
      DATA KSV(2,15)/1/,KSV(3,15)/4HPI  /
      DATA KSV(2,16)/1/,KSV(3,16)/4HTPI /
      DATA KSV(2,17)/1/,KSV(3,17)/4HTPIS/
      DATA KSV(2,18)/1/,KSV(3,18)/4HDTR /
      DATA KSV(2,19)/1/,KSV(3,19)/4HRTD /
      DATA KSV(2,20)/1/,KSV(3,20)/4HZERO/
#else
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
#endif
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

#ifdef _HOL_
      DATA KSYSF( 1)/4HSQRT/
      DATA KSYSF( 2)/4HEXP /
      DATA KSYSF( 3)/4HSIN /
      DATA KSYSF( 4)/4HCOS /
      DATA KSYSF( 5)/4HTAN /
      DATA KSYSF( 6)/4HASIN/
      DATA KSYSF( 7)/4HACOS/
      DATA KSYSF( 8)/4HATAN/
#else
      DATA KSYSF( 1)/'SQRT'/
      DATA KSYSF( 2)/'EXP '/
      DATA KSYSF( 3)/'SIN '/
      DATA KSYSF( 4)/'COS '/
      DATA KSYSF( 5)/'TAN '/
      DATA KSYSF( 6)/'ASIN'/
      DATA KSYSF( 7)/'ACOS'/
      DATA KSYSF( 8)/'ATAN'/
#endif
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

      SUBROUTINE CRESET

      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XTAPED.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XDAVAL.INC'
      INCLUDE 'XCBVAL.INC'
      INCLUDE 'XUNTNM.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XFILE.INC'
      INCLUDE 'XLISTS.INC'
      INCLUDE 'XCNTRL.INC'
      INCLUDE 'PSCSTI.INC'
      INCLUDE 'XSCSTK.INC'
      INCLUDE 'XFILEC.INC'
      INCLUDE 'XGUIOV.INC'

      EQUIVALENCE ( IRIC,ZRIC )

C --- XSSVAL ---
      ISSLSM = 3
      ISSSPD = 2
      ISSTIM = 1
      ISSL11 = 1 
      ISSLNM = 5
      ISSINI = 1
      ISSSTA = 1
#if !defined(_H_P_) 
      ISSBAN = 0 
#else
      ISSBAN = 1
#endif
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

      NFLUSD = 50



      IFLUNI(1)  =  1  
      IFLUNI(2)  =  2
      IFLUNI(3)  =  5  
#ifdef __VAX__ 
      IFLUNI(4)  =  9
#else
      IFLUNI(4)  =  6
#endif
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
      IFLUNI(50)= 87

      DO I=1,50
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
#ifdef __VAX__ 
      NCWU=9
#else
      NCWU=6
#endif
      NCPU=7
      IPAGE(1)=10
      IPAGE(2)=8
      IPAGE(3)=120
      IPAGE(4)=88
      IPAGE(5)=20
      NCARU=2
      NCAWU=3
#ifdef __VAX__ 
      IQUN=2
      JQUN=0
#else
      IQUN=2
      JQUN=2
#endif
      IUSFLG = 0 
      NCSU = 11
      NCEXTR = 88
      NCEXTR2 = 87
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

      LK1 = 3
      LK2 = 4
      NWCARD = 20
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
      KSTAT1 = 0
      KSTAT2 = 0
      KSTAT3 = 0
      KSTAT5 = 0
      KSTAT6 = 0
      KSTATQ = 0
      KSTATI = 0

      DO I = 1,50
        ISERNN(I)=0
      END DO

      RETURN
      END

