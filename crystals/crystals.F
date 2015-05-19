C $Log: not supported by cvs2svn $
C Revision 1.16  2011/03/22 14:40:38  rich
C Added extra file unit 'SCP2' which may be read by new script command EXTRACT2
C
C Revision 1.15  2005/02/08 14:46:14  stefan
C 1. Added some precompiler if's for the mac version
C
C Revision 1.14  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:07  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.13  2003/05/07 12:18:53  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.12  2002/07/22 10:47:32  richard
C Save and restore IERFLG around XGUIUP call, otherwise the error contingency
C in SCRIPTS is never activated.
C
C Revision 1.11  2002/03/13 12:33:28  richard
C Call XGUIUP in between EVERY instruction.
C
C Revision 1.10  2001/10/08 12:25:58  ckp2
C
C All program sub-units now RETURN to the main CRYSTL() function inbetween commands.
C The changes made are: in every sub-program the GOTO's that used to loop back for
C the next KNXTOP command have been changed to RETURN's. In the main program KNXTOP is now
C called at the top of the loop, but first the current ProgramName (KPRGNM) array is cleared
C to ensure the KNXTOP knows that it is not in the correct sub-program already. (This
C is the way KNXTOP worked on the very first call within CRYSTALS).
C
C We now have one location (CRYSTL()) where the program flow returns between every command. I will
C put this to good use soon.
C
C Revision 1.9  2001/02/26 10:24:14  richard
C Added changelog to top of file
C
C
CODE FOR CRYSTL
C Entry point for GUI C++ routines.
#ifdef CRY_FORTDIGITAL
      SUBROUTINE CRYSTL()
#elif defined(CRY_NOGUI)
      PROGRAM CRYSTL
#else
      SUBROUTINE CRYSTL() bind (c)
#endif
      CALL CRYSTAL()
      END

C Entry point for command line and library use.
      SUBROUTINE CRYSTAL()
C
C
C     ******************************************************
C     * THIS IS THE MAIN PROGRAM FOR THE 'CRYSTALS' SYSTEM *
C     ******************************************************
C
C BY DEFAULT, TERMINAL INPUT IS FROM UNIT 5 - NCUFU(1)
C             TERMINAL OUTPUT IS TO UNIT  6 - NCAWU
C             AND THE STARTUP FILE IS OPENED ON UNIT 20 - NCRU
C
C             THE NAME OF THE STARTUP FILE MAY EITHER BE SET AS
C             DATA IN PRESETS, OR IN AN ASSIGNMENT BELOW.
C
      INCLUDE 'ISTORE.INC'
      DIMENSION PROGLS(4,18)
C--
C
      INCLUDE 'STORE.INC'
      INCLUDE 'TSSCHR.INC'
      INCLUDE 'XDRIVE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XPRGNM.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XDISC.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'QSTORE.INC'

      INTEGER PROGLS
C
C
C -- DECLARE EXTERNAL REFERENCES TO BLOCK DATA SEGMENTS
C
      EXTERNAL CRYBLK, SYNBLK, UTIBLK
C
C -- DECLARE LIST 11 REFERENCES TO RESERVE EXTENSIBLE COMMON
C
      EXTERNAL XFAL11,KADD11,XIN11
#ifdef _DOS_ 
      EXTERNAL MYDRIV
C
C -- SET UP AVAILABLE PROGRAM LIST.
C    NAMES RESTRICTED TO FIRST 16 CHARACTERS OF THOSE IN COMMANDFILE
C
#endif
      DATA NPROG / 18 /
#if !defined(_HOL_) 
      DATA PROGLS(1,1)  / 'CRYS' / , PROGLS(2,1)  / 'TALS' /
      DATA PROGLS(3,1)  / 'INPU' / , PROGLS(4,1)  / 'T   ' /
      DATA PROGLS(1,2)  / 'CRYS' / , PROGLS(2,2)  / 'TALS' /
      DATA PROGLS(3,2)  / 'FIDD' / , PROGLS(4,2)  / 'LE  ' /
      DATA PROGLS(1,3)  / 'CRYS' / , PROGLS(2,3)  / 'TALS' /
      DATA PROGLS(3,3)  / 'CALC' / , PROGLS(4,3)  / 'ULAT' /
      DATA PROGLS(1,4)  / 'CRYS' / , PROGLS(2,4)  / 'TALS' /
      DATA PROGLS(3,4)  / 'INVE' / , PROGLS(4,4)  / 'RT  ' /
      DATA PROGLS(1,5)  / 'CRYS' / , PROGLS(2,5)  / 'TALS' /
      DATA PROGLS(3,5)  / 'REST' / , PROGLS(4,5)  / 'RAIN' /
      DATA PROGLS(1,6)  / 'CRYS' / , PROGLS(2,6)  / 'TALS' /
      DATA PROGLS(3,6)  / 'GEOM' / , PROGLS(4,6)  / 'ETRY' /
      DATA PROGLS(1,7)  / 'CRYS' / , PROGLS(2,7)  / 'TALS' /
      DATA PROGLS(3,7)  / 'ANIS' / , PROGLS(4,7)  / 'O   ' /
      DATA PROGLS(1,8)  / 'CRYS' / , PROGLS(2,8)  / 'TALS' /
      DATA PROGLS(3,8)  / 'ALTE' / , PROGLS(4,8)  / 'R5  ' /
      DATA PROGLS(1,9)  / 'CRYS' / , PROGLS(2,9)  / 'TALS' /
      DATA PROGLS(3,9)  / 'WEIG' / , PROGLS(4,9)  / 'HT  ' /
      DATA PROGLS(1,10) / 'CRYS' / , PROGLS(2,10) / 'TALS' /
      DATA PROGLS(3,10) / 'DIST' / , PROGLS(4,10) / 'ANCE' /
      DATA PROGLS(1,11) / 'CRYS' / , PROGLS(2,11) / 'TALS' /
      DATA PROGLS(3,11) / 'FOUR' / , PROGLS(4,11) / 'IER ' /
      DATA PROGLS(1,12) / 'CRYS' / , PROGLS(2,12) / 'TALS' /
      DATA PROGLS(3,12) / 'INPU' / , PROGLS(4,12) / 'T6  ' /
      DATA PROGLS(1,13) / 'CRYS' / , PROGLS(2,13) / 'TALS' /
      DATA PROGLS(3,13) / 'PROC' / , PROGLS(4,13) / 'ESS6' /
      DATA PROGLS(1,14) / 'CRYS' / , PROGLS(2,14) / 'TALS' /
      DATA PROGLS(3,14) / 'TRIA' / , PROGLS(4,14) / 'L   ' /
      DATA PROGLS(1,15) / 'CRYS' / , PROGLS(2,15) / 'TALS' /
      DATA PROGLS(3,15) / 'PROC' / , PROGLS(4,15) / 'ESS ' /
      DATA PROGLS(1,16) / 'CRYS' / , PROGLS(2,16) / 'TALS' /
      DATA PROGLS(3,16) / 'PUBL' / , PROGLS(4,16) / 'ISH ' /
      DATA PROGLS(1,17) / 'CRYS' / , PROGLS(2,17) / 'TALS' /
      DATA PROGLS(3,17) / 'FORE' / , PROGLS(4,17) / 'IGN ' /
      DATA PROGLS(1,18) / 'CRYS' / , PROGLS(2,18) / 'TALS' /
      DATA PROGLS(3,18) / 'DIFA' / , PROGLS(4,18) / 'BS  ' /
#else
      DATA PROGLS(1,1)  / 4HCRYS / , PROGLS(2,1)  / 4HTALS /
#endif
#ifdef _HOL_ 
      DATA PROGLS(3,1)  / 4HINPU / , PROGLS(4,1)  / 4HT    /
      DATA PROGLS(1,2)  / 4HCRYS / , PROGLS(2,2)  / 4HTALS /
      DATA PROGLS(3,2)  / 4HFIDD / , PROGLS(4,2)  / 4HLE   /
      DATA PROGLS(1,3)  / 4HCRYS / , PROGLS(2,3)  / 4HTALS /
      DATA PROGLS(3,3)  / 4HCALC / , PROGLS(4,3)  / 4HULAT /
      DATA PROGLS(1,4)  / 4HCRYS / , PROGLS(2,4)  / 4HTALS /
      DATA PROGLS(3,4)  / 4HINVE / , PROGLS(4,4)  / 4HRT   /
      DATA PROGLS(1,5)  / 4HCRYS / , PROGLS(2,5)  / 4HTALS /
      DATA PROGLS(3,5)  / 4HREST / , PROGLS(4,5)  / 4HRAIN /
      DATA PROGLS(1,6)  / 4HCRYS / , PROGLS(2,6)  / 4HTALS /
      DATA PROGLS(3,6)  / 4HGEOM / , PROGLS(4,6)  / 4HETRY /
      DATA PROGLS(1,7)  / 4HCRYS / , PROGLS(2,7)  / 4HTALS /
      DATA PROGLS(3,7)  / 4HANIS / , PROGLS(4,7)  / 4HO    /
      DATA PROGLS(1,8)  / 4HCRYS / , PROGLS(2,8)  / 4HTALS /
      DATA PROGLS(3,8)  / 4HALTE / , PROGLS(4,8)  / 4HR5   /
      DATA PROGLS(1,9)  / 4HCRYS / , PROGLS(2,9)  / 4HTALS /
      DATA PROGLS(3,9)  / 4HWEIG / , PROGLS(4,9)  / 4HHT   /
      DATA PROGLS(1,10) / 4HCRYS / , PROGLS(2,10) / 4HTALS /
      DATA PROGLS(3,10) / 4HDIST / , PROGLS(4,10) / 4HANCE /
      DATA PROGLS(1,11) / 4HCRYS / , PROGLS(2,11) / 4HTALS /
      DATA PROGLS(3,11) / 4HFOUR / , PROGLS(4,11) / 4HIER  /
      DATA PROGLS(1,12) / 4HCRYS / , PROGLS(2,12) / 4HTALS /
      DATA PROGLS(3,12) / 4HINPU / , PROGLS(4,12) / 4HT6   /
      DATA PROGLS(1,13) / 4HCRYS / , PROGLS(2,13) / 4HTALS /
      DATA PROGLS(3,13) / 4HPROC / , PROGLS(4,13) / 4HESS6 /
      DATA PROGLS(1,14) / 4HCRYS / , PROGLS(2,14) / 4HTALS /
      DATA PROGLS(3,14) / 4HTRIA / , PROGLS(4,14) / 4HL    /
      DATA PROGLS(1,15) / 4HCRYS / , PROGLS(2,15) / 4HTALS /
      DATA PROGLS(3,15) / 4HPROC / , PROGLS(4,15) / 4HESS  /
      DATA PROGLS(1,16) / 4HCRYS / , PROGLS(2,16) / 4HTALS /
      DATA PROGLS(3,16) / 4HPUBL / , PROGLS(4,16) / 4HISH  /
      DATA PROGLS(1,17) / 4HCRYS / , PROGLS(2,17) / 4HTALS /
      DATA PROGLS(3,17) / 4HFORE / , PROGLS(4,17) / 4HIGN  /
      DATA PROGLS(1,18) / 4HCRYS / , PROGLS(2,18) / 4HTALS /
      DATA PROGLS(3,18) / 4HDIFA / , PROGLS(4,18) / 4HBS   /
C
C Re-initialise system variables in case starting again.
#endif
      CALL CRESET
C
C----- INITIALISE THE CARRIAGE CONTROL VARIABLES
      CALL FBCINI
#ifdef _DOS_ 
      call suppress_argument_type_checks@
#endif
      CALL STCTLC
C
C -- ASSIGN AND OPEN STARTUP CONTROL FILE - CSSCST AND LSSCST
C    ARE SET IN BLOCK DATA IN PRESETS. THE LOGICAL NAME MAT BE
C    EXPANDED
      CALL MTRNLG ( CSSCST, 'OLD', LSSCST)
C----- ALTERNATIVELY, THAY CAN BE SET HERE
C      CSSCST = '\CRYSTALS\SRT\CRYSTALS.SRT'
C      LSSCST =  26
C
#ifdef _DOS_ 
C----- HOOK IN THE SALFORD DOS DRIVER TO COUNT LINES
CWIN_32&DOS      OPEN ( NCVDU, STATUS = 'UNKNOWN', DRIVER = MYDRIV)
C
#endif
      IF ( ISSSFI .GT. 0 ) THEN
        ISTAT = KFLOPN ( NCRU ,CSSCST(1:LSSCST),ISSOLD,ISSREA,1,ISSSEQ)
        IF ( ISTAT .LE. 0 ) THEN
            WRITE(6,*) 'UNIT =', NCRU, 'FILE =', CSSCST
            CALL XERIOM ( NCRU, ISTAT)
C            STOP 'ERROR OPENING STARTUP FILE'
            CALL GUEXIT (2003)
        ENDIF
      ENDIF
C
1210  CONTINUE

      KOLDER = IERFLG

      CALL XGUIUP(0)

      IERFLG = KOLDER

      CALL XFILL(IB,KPRGNM,17) !No longer in a program sub-unit.
      I = KNXTOP ( LSTOP,LSTNO,ICLASS )
C----- CHECK IF THIS SEGMENT NAME IS AVAILABLE
      I=KCOMP(4,KPRGNM,PROGLS,NPROG,4)
      IF ( I .LE. 0 ) GO TO 9920
C----- GOTO THE APPROPRIATE SECTION
       GOTO(3010,3020,3030,3040,3050,3060,3070,3080,3090,
     2 3100 , 3110 , 3120 , 3130 , 3140 ,
     3 3150 , 3160 , 3170 , 3180 , 9920 ) , I
      GO TO 9920
C
C
3010  CONTINUE
      CALL INPUT
      GOTO 1210
3020  CONTINUE
      CALL FIDDLE
      GOTO 1210
3030  CONTINUE
      CALL CALCUL
      GOTO 1210
3040  CONTINUE
      CALL INVERT
      GOTO 1210
3050  CONTINUE
      CALL RESTR
      GOTO 1210
3060  CONTINUE
      CALL GEOMET
      GOTO 1210
3070  CONTINUE
      CALL ANISO
      GOTO 1210
3080  CONTINUE
      CALL ALTER5
      GOTO 1210
3090  CONTINUE
      CALL WEIGHT
      GOTO 1210
C
3100  CONTINUE
      CALL DISTAN
      GOTO 1210
3110  CONTINUE
      CALL FOURIE
      GOTO 1210
3120  CONTINUE
      CALL INPUT6
      GOTO 1210
3130  CONTINUE
      CALL PRCSS6
      GOTO 1210
3140  CONTINUE
      CALL TRIAL
      GOTO 1210
3150  CONTINUE
      CALL PRCSS
      GOTO 1210
3160  CONTINUE
      CALL PUBLSH
      GOTO 1210
3170  CONTINUE
      CALL FOREIG
      GO TO 1210
3180  CONTINUE
      CALL DIFABS
      GO TO 1210
C
C
C
9920  CONTINUE
      WRITE ( CMON, 9925)
      CALL XPRVDU(NCEROR, 1,0)
9925  FORMAT ( 1X , 'Illegal program name selected' )
      GO TO 9990
C
9990  CONTINUE
C      STOP 'CRYSTALS START ERROR'
      CALL GUEXIT (2004)
      END
