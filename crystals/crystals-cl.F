      PROGRAM CRYSTAL
#ifndef _NOHDF5_
      use hdf5_dsc
#endif
      INTERFACE
       SUBROUTINE CRYSTL() BIND(C)
         USE, INTRINSIC :: ISO_C_BINDING
         IMPLICIT NONE
       END SUBROUTINE CRYSTL
      END INTERFACE

 
#ifndef _NOHDF5_
      character(len=256) :: args_value
      integer :: args_count, i, found

C Look for arguments from the command line
      args_count = command_argument_count()
      if(args_count>0) then
        ! Search for hdf5 switch
        do i=1, args_count
          call get_command_argument(i , args_value)
          found = index(args_value, '--hdf5')
          if(found>0) then
            hdf5_in_use = .true.
            print *, 'Experimental use of hdf5 files'
          end if
        end do
      end if
#endif
      CALL CRYSTL()
      END


C Entry point for command line and library use.
#ifdef CRY_FORTDIGITAL
      SUBROUTINE CRYSTL()
      !dec$ attributes c :: crystl
#else
      SUBROUTINE CRYSTL() bind (c)
#endif
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
      EXTERNAL CRYBLK, SYNBLK, UTIBLK, ZBLOCK
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

      CALL CRESET   !These routines reinitialise SOME of the COMMON block variables, but
      CALL CAMSET   !they also ensure those object files (presets and block) are linked.
C
C----- INITIALISE THE CARRIAGE CONTROL VARIABLES
      CALL FBCINI
#ifdef _DOS_
      call suppress_argument_type_checks@
#endif
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
         if (issmon.ne.1) CALL SETISSMON(0) ! Turn monitoring back on
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
      if (issmon.ne.1) CALL SETISSMON(0) ! Turn monitoring back on
      CALL GUEXIT (2004)
      END

CODE FOR GETCOM
      SUBROUTINE GETCOM(CLINE)
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      CHARACTER *(*) CLINE

      READ( NCUFU(1), '(A)') CLINE

      END SUBROUTINE

CODE FOR GUEXIT
      SUBROUTINE GUEXIT(IVAR)
      INTEGER IVAR
      INCLUDE 'UFILE.INC'
C Meanings of IVAR.
C 0    Ok
C 1    Error
C 2    Serious error
C 3-1999 unspecified.
C 2001 Zero length vector
C 2002 SPECLIB - XDEPAC
C 2003 ERROR OPENING STARTUP FILE
C 2004 CRYSTALS START ERROR
C 2005 CANNOT CREATE FILE
C 2006 WRITE ERROR
C 2007 XFETCH
C 2008 XSTORE
C 2009 INPUT
C 2010 LABEL NOT IMPLEMENTED
C 2011 XFINDE
C 2012 XLDCBL
C 2013 XFCFI
C 2014 XDSMSG
C 2015 XLINES
c 2016 KCHNCB
c 2017 XINERT
c 2018 PO1AAF (NAG)
c 2019 LIST 6 ERROR
c 2020 ERROR HANDLING
c 2021 SPYERROR
c 2022 KEQUAT
c 2023 KFORM
c 2024 KFUNCT
c 2025 XABS
c 2026 XCONOP ERROR
c 2027 ROUTINE NOT IMPLEMENTED
cdjwapr99 moved from out of XFINAL to prevent error messages in FTN77 
c version
C----- CLOSE ALL THE FILES
      DO 2001 I = 1,NFLUSD
            J = KFLCLS(IFLUNI(I))
2001  CONTINUE
      CALL EXIT(IVAR)
      RETURN
      END
      
      SUBROUTINE GETVAR(CKEY, CVAL)
      CHARACTER*(*) CKEY, CVAL
      call GET_ENVIRONMENT_VARIABLE(CKEY,CVAL)
      end            

      SUBROUTINE GUEXEC(CC)
      CHARACTER*(*) CC
      RETURN
      END      

      SUBROUTINE CALLCCODE(CC)
      CHARACTER*(*) CC
      RETURN
      END
