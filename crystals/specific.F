C $Log: not supported by cvs2svn $
C Revision 1.52  2004/05/17 15:40:04  rich
C Linux: Ending thread from FORTRAN failed due to a wrongly placed
C STOP statement.
C
C Revision 1.51  2004/02/27 12:55:06  rich
C Supress output of dates from \DISK/PRINT if TIME is \SET to SLOW. (For
C test_suite tests).
C
C Revision 1.50  2004/02/25 10:03:24  stefan
C Removed GUI output for Linux/Unix version
C
C Revision 1.49  2004/02/24 15:51:22  rich
C Don't try to substitute HTTP: as an evironment variable.
C Don't try to substitute C: as an environment variable.
C Replace forward slashes with backward ones on Win32 platforms - allows
C consistent file and path naming across platforms.
C
C Revision 1.48  2004/02/18 14:20:21  rich
C In XDATER, change order from American to UK (reqd to get CIF audit_creation_date
C in the correct order).
C Use current version number to add a version suffix to the audit_creation_method
C key in the CIF.
C
C Revision 1.47  2004/02/18 12:08:23  rich
C Added option \SET TIME SLOW which prevents output of DATE and TIME strings.
C This is to be used by the new test_suite so that runs at different times
C generate no significant differences. Also supresses timing functions, as
C for \SET TIME OFF.
C
C Revision 1.46  2004/02/09 20:26:08  rich
C Correct order of statements in XTIMER for compilation on WXS platform.
C
C Revision 1.45  2004/02/06 16:58:28  rich
C Make #SET TIME OFF turn off all time routines.
C
C Revision 1.44  2003/11/19 15:17:21  rich
C Linux ver: call C++ routine to spawn other programs.
C
C Revision 1.43  2003/09/24 08:35:23  rich
C Modified KDAOPN so that it will open direct-access scratch files.
C
C Revision 1.42  2003/08/05 11:11:12  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.41  2003/07/03 10:41:04  rich
C Bug fixed: When top level scripts were called, the status bar shows them
C as being called from the last top level script that was run. Fix: Clear
C variables in between script runs.
C
C Revision 1.40  2003/05/07 12:18:56  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.39  2002/10/14 12:33:25  rich
C Support for DVF command line version.
C
C Revision 1.38  2002/08/23 11:25:30  richard
C Output script names to progress bar.
C
C Revision 1.37  2002/05/15 17:16:48  richard
C Removed out of place subroutine header comment.
C
C Revision 1.36  2002/03/12 17:45:40  ckp2
C In MTRNLG, special case filenames with #'s in. Trim back to before the hash before
C inquiring whether they exist.
C
C Revision 1.35  2002/02/28 11:19:04  ckp2
C RIC: 1st bugfix related to long filenames - output trimmed filename when closing file.
C
C Revision 1.34  2002/02/27 19:53:45  ckp2
C Comment out debugging output.
C
C Revision 1.33  2002/02/27 19:40:10  ckp2
C RIC: Increased input line length to 256 chars. HOWEVER - only a few modules know about
C this extra length. In general the program continues to ignore everything beyond
C column 80. The "system" commands (OPEN, RELEASE, etc.) do know about the extra length
C and can take extra long filenames as a result. The script processor also knows: lines
C in script files, the script input buffer and text output may now run up to 256 chars.
C RIC: THe system commands respect double-quotes around arguments, so that filenames can be
C given which contain spaces.
C
C Revision 1.32  2002/02/20 14:37:56  ckp2
C RIC: Changes to XDETCH to do with allowing quotes around filenames.
C RIC: Do not remove spaces from filenames in MTRNLG.
C
C Revision 1.31  2001/09/07 14:21:36  ckp2
C Fiddled around with #DISK to allow time and date to be stored for each entry.
C There is a year 2038 problems with the date format, it'll seem like 1970 again.
C Also added a punch directive which will allow scripts to get hold of the DSC
C info in a script readable format. Will write some scripts soon.
C
C Revision 1.30  2001/06/18 13:01:03  richard
C Removed SNGL(x) function in RAND() because it now gets its value from FRAND
C which returns a single anyway.
C
C Revision 1.29  2001/03/15 11:02:36  richard
C Comment out some old gui instructions fom XPRTDEV
C
C Revision 1.28  2001/03/08 14:40:43  richard
C Split the random function up so that it is possible to obtain a random
C number with uniform distribution for scripts. The original function gives
C a gaussian, and now uses the new function FRAND to access the compiler
C library random number function.
C
C Revision 1.27  2000/10/31 14:36:54  ckp2
C Log changes
C
CODE FOR XERIOM
      SUBROUTINE XERIOM ( IUNIT , IOS )
C -- THIS SUBROUTINE SHOULD OUTPUT A MESSAGE ABOUT THE I/O ERROR THAT JU
C    OCCURED, ON UNIT 'IUNIT'
C
&&DVFGID      USE DFPORT
      CHARACTER*80 REASON
&VAX      INTEGER RMSSTS , RMSSTV
\XUNITS
\XSSVAL
\XIOBUF
C
C
C
      WRITE ( CMON,1015) IUNIT, IOS
      CALL XPRVDU(NCEROR, 1, 0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1015 ) IUNIT , IOS
1015  FORMAT ( 1X , 'I/O error on unit ' , I5 ,
     2 ' with status code ' , I6 )
1005  FORMAT ( 1X , 'Reason -- ' , A )
C
      REASON = ' '
      MSGST = 1
      MSGEND = 1
&PPCC -- DETERMINE REASON FOR ERROR, USING CUSTOM ROUTINE GETERR
&PPC      CALL GETERR( IOS, REASON, MSGEND )
&H-PC -- OUTPUT OF THE REASON WITH ROUTINE PERROR
&H-P      CALL PERROR (' UNIX - perror message ')
&DOSC -- DETERMINE REASON WITH ENVIRONMENT ROUTINE
&DOS      CALL FORTRAN_ERROR_MESSAGE@ (-IOS, REASON)
&DOS      CALL XCTRIM( REASON, MSGEND )
&&DVFGID      WRITE(REASON, '(A,I4)') 'File I/O Error: ', IOS
&&DVFGID      CALL XCTRIM( REASON, MSGEND )
&DVF      CALL PERROR (' perror message ')
&GIL      WRITE(REASON, '(A,I4)') 'File I/O Error: ', IOS
&GIL      CALL XCTRIM( REASON, MSGEND )
&GIL      CALL PERROR (' perror message ')
&WXS      WRITE(REASON, '(A,I4)') 'File I/O Error: ', IOS
&WXS      CALL XCTRIM( REASON, MSGEND )
&WXS      CALL PERROR (' perror message ')
&LIN      WRITE(REASON, '(A,I4)') 'File I/O Error: ', IOS
&LIN      CALL XCTRIM( REASON, MSGEND )
&LIN      CALL PERROR (' perror message ')
&VAXC -- DETERMINE REASON FOR ERROR, USING SYSTEM ROUTINE
&VAX      CALL ERRSNS ( I1,RMSSTS,RMSSTV,I4,I5 )
&VAX      CALL LIB$SYS_GETMSG ( RMSSTS , MSGEND , REASON )
&VAX      MSGST = INDEX ( REASON , ',' ) + 1
C
      WRITE ( CMON,1005) REASON(MSGST:MSGEND)
      CALL XPRVDU(NCEROR, 1, 0)
      IF (ISSPRT .EQ. 0) WRITE (NCWU, '(a)' ) cmon(1)
C
      RETURN
      END
C
CODE FOR KFLOPN
      FUNCTION KFLOPN( IUNIT, CFNAME, IFSTAT, IFMODE, IFFORM, ISEQDA)
C
C -- OPEN A SEQUENTIAL FILE
C
C  INPUT :-
C      IUNIT       UNIT NUMBER ON WHICH FILE IS TO BE OPENED
C      FILNAM      NAME OF FILE TO BE OPENED. IF THIS STRING IS
C                    EMPTY, THE FILE IS NOT OPENED BY NAME.
C      IFSTAT      STATUS OF FILE
C                    ISSOLD      OLD FILE
C                    ISSNEW      NEW FILE
C                    ISSCIF      CREATE IF OLD FILE CANNOT BE OPENED
C                    ISSSCR      SCRATCH FILE
C                    ISSUNK      UNKNOWN
C      IFMODE      ACCESS REQUIRED
C                    ISSREA      READ ONLY
C                    ISSWRI      READ/WRITE ACCESS
C                    ISSAPP      WRITE/APPEND
&PPCC                    'READ' IMPLIES READONLY,SHARED IS IGNORED
&H-PC                    THIS PARAMETER IS IGNORED
&DOSC                    THIS PARAMETER IS IGNORED
&VAXC                    'READ' IMPLIES READONLY,SHARED
C      IFFORM      FORMATTED/UNFORMATTED FILE
C                    ISSFRM      FORMATTED FILE
C                    ISSUFM      UNFORMATTED FILE
CRICJUL00
C      ISEQDA      SEQUENTIAL/DIRECT ACCESS FILE
C                    ISSSEQ      SEQUENTIAL ACCESS
C                    ISSDAF      DIRECT ACCESS
C
C
C  RETURN VALUES :-
C      -1          ERROR OPENING FILE
C      +1          SUCCESS
C
C  THIS ROUTINE DOES NOT OUTPUT MESSAGES DESCRIBING ANY ERRORS THAT
C  OCCUR DURING FILE OPENING. THE CALLING ROUTINE IS LEFT TO PROVIDE
C  MESSAGES WHEN IT DETECTS THE RETURN VALUE 'KFLOPN' = -1, USING
C  'XERIOM' IF REQUIRED TO PROVIDE MORE INFORMATION.
C
C
C
      CHARACTER *8 CCONT
      CHARACTER *(*) CFNAME
      CHARACTER *256  CLCNAM, FILNAM
C
      PARAMETER (NFLSTT=5)
      CHARACTER*7 FLSTAT(NFLSTT)
      CHARACTER*7 ACSTAT,TESTAT
      CHARACTER *11 FLFORM(2), CFORM
      CHARACTER *11 FLSQDA(2)
C
\XUNITS
\XSSVAL
\XOPVAL
\XIOBUF
C
C
      DATA FLSTAT(1) / 'OLD    ' / , FLSTAT(2) / 'NEW    ' /
      DATA FLSTAT(3) / 'CIF    ' / , FLSTAT(4) / 'SCRATCH' /
      DATA FLSTAT(5) / 'UNKNOWN' /
      DATA FLFORM(1) / 'FORMATTED  ' / , FLFORM(2) / 'UNFORMATTED' /
CRICJUL00
      DATA FLSQDA(1) / 'SEQUENTIAL ' / , FLSQDA(2) / 'DIRECT     ' /
C
C
C
C
C -- CHECK DATA TO SOME EXTENT

      IF ( IFSTAT .GT. NFLSTT) GOTO 9910
CDJWMAR99
      IF ( IFMODE .GT. ISSAPP ) GO TO 9910
CRICJUL00
      IF ( ISEQDA .GT. ISSDAF ) GO TO 9910
      IF ( IFFORM .GT. 2 ) GO TO 9910
      CLCNAM = ' '
      FILNAM = CFNAME
      IF (FILNAM .EQ. ' ') THEN
C-----  MAKE SURE AN UNNAMED FILE IS REWOUND
        REWIND (UNIT = IUNIT, IOSTAT = IOS, ERR = 1000)
      ELSE
C------ MAKE SURE THE UNIT IS CLOSED IF A FILE NAME IS GIVEN
        CLOSE(UNIT = IUNIT, IOSTAT = IOS, ERR = 1000)
      ENDIF
1000    CONTINUE
C
c      NAMLEN = MAX (INDEX( FILNAM, ' ')-1, 0)
      NAMLEN = KCLNEQ(FILNAM,-1,' ')
C----- SET FILE NAME LOWER/UPPER/MIXED CASE
      IF (NAMLEN .GT. 0) THEN
        IF (ISSFLC .EQ. 0) THEN
C----- CONVERT NAME TO LOWER CASE
           CALL XCCLWC (FILNAM, CLCNAM(1:NAMLEN) )
        ELSE IF (ISSFLC .EQ. 1) THEN
C----- CONVERT NAME TO UPPER CASE
           CALL XCCUPC (FILNAM, CLCNAM(1:NAMLEN) )
        ELSE
           CLCNAM(1:NAMLEN) = FILNAM(1:NAMLEN)
        ENDIF
      ENDIF

C
C -- SET REQUIRED STATUS TO THAT SPECIFIED
      CFORM = FLFORM(IFFORM)
      ACSTAT = FLSTAT(IFSTAT)
C
C -- IF REQUEST IS 'CIF' SET STATUS TO 'OLD'
C
      IF ( ACSTAT .EQ. 'CIF' ) ACSTAT = 'OLD'
C
&PPCCS***
&PPC      CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN,IUNIT)
&PPCCE***
C
2000  CONTINUE
C
      IF ( IFMODE .EQ. ISSREA ) GO TO 2500
C----- FOR THE VAX, SET THE CARRIAGE CONTROL ATTRIBUTES
&PPCC**** Carriage Control set permanently to LIST for Mac Version
&PPCC**** Ludwig Macko, 1.2.1995
&PPCC****
#VAX      CCONT = 'LIST'
&VAX      IF ((IUNIT .EQ. NCAWU) .OR. (IUNIT .EQ. NCWU)) THEN
&VAX        CCONT = 'FORTRAN'
&VAX      ELSE
&VAX        CCONT = 'LIST'
&VAX      ENDIF
C
&PPCC**** We better check on the variable CLCNAM, because MTRNLG might
&PPCC**** set a name unknown before
&PPCC**** 12.11.1995 Ludwig Macko
&PPCC****
&PPC      IF ( CLCNAM .EQ. ' ' ) THEN
#PPC      IF ( FILNAM .EQ. ' ' ) THEN
        OPEN ( UNIT   = IUNIT ,
     1         STATUS = ACSTAT ,
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
&VAX     1         CARRIAGECONTROL = CCONT,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
      ELSE
&PPCCS***
&PPC        IF ( ACSTAT .EQ. 'NEW' ) THEN
&PPC           CALL SFINFO( CLCNAM(1:NAMLEN), 1 )
&PPC           TESTAT = 'OLD'
&PPC        ELSE
&PPC           TESTAT = ACSTAT
&PPC        ENDIF
&PPCCE***

#PPC      CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)
        OPEN ( UNIT   = IUNIT ,
     1         FILE   = CLCNAM(1:NAMLEN),
&PPC     1         STATUS = TESTAT ,
#PPC     1         STATUS = ACSTAT ,
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
&VAX     1         CARRIAGECONTROL = CCONT,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
      ENDIF
C
      IF (IOS .NE. ISSOKF) GOTO 3000
C
C -- SUCCESS - SEE IF WE SHOULD WIND TO THE END
      IF (IFMODE .EQ. ISSAPP) THEN
2100   CONTINUE
        READ (IUNIT, '(A)', END=2200) 
        GOTO 2100
2200   CONTINUE
       BACKSPACE(IUNIT)
      ENDIF
C
C
C
      GO TO 9000
C
C
2500  CONTINUE
&VAXC -- SPECIAL 'READONLY' , 'SHARED' OPEN FOR VAX/VMS
C
&PPCC**** We better check on the variable CLCNAM, because MTRNLG might
&PPCC**** set a name unknown before
&PPCC**** 12.11.1995 Ludwig Macko
&PPCC****
&PPC      IF ( CLCNAM .EQ. ' ' ) THEN
#PPC      IF ( FILNAM .EQ. ' ' ) THEN
        OPEN ( UNIT   = IUNIT ,
&VAX     1         SHARED ,
&VAX     1         READONLY ,
&PPC     1         READONLY ,
&&DVFGID     1         READONLY ,
#DOS     1         STATUS = ACSTAT ,
&DOS     1         STATUS ='READONLY' ,
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
      ELSE
&PPCCS***
&PPC        IF ( ACSTAT .EQ. 'NEW' ) THEN
&PPC           CALL SFINFO( CLCNAM(1:NAMLEN), 1 )
&PPC           TESTAT = 'OLD'
&PPC        ELSE
&PPC           TESTAT = ACSTAT
&PPC        ENDIF
&PPCCE***
#PPC      CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)
        OPEN ( UNIT   = IUNIT ,
     1         FILE   = CLCNAM(1:NAMLEN),
&VAX     1         SHARED ,
&VAX     1         READONLY ,
&&DVFGID     1         READONLY ,
&PPC     1         READONLY ,
&PPC     1         STATUS = TESTAT ,
&VAX     1         STATUS = ACSTAT ,
#DOS     1         STATUS = ACSTAT ,
&DOS     1         STATUS = 'READONLY' ,
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
      ENDIF
C
      IF (IOS .NE. ISSOKF) GOTO 3000
C
C------ MAKE SURE WE ARE AT THE BEGINNING
C------ DONT FAIL EVEN IF ITS NOT A REWINDABLE FILE (EG TTY)
      REWIND (UNIT = IUNIT, ERR = 9000)
C
      GO TO 9000
C
C
3000  CONTINUE
C
C -- OPEN FAILED -- IF IT SHOULD HAVE SUCCEEDED THEN THIS IS AN ERROR
C
      IF ( ACSTAT .EQ. FLSTAT(ISSNEW) ) GO TO 9900
      IF ( IFSTAT .EQ. ISSSCR ) GO TO 9900
      IF ( IFSTAT .EQ. ISSUNK ) GO TO 9900
      IF ( IFSTAT .EQ. ISSOLD ) GO TO 9900
CRICJUL00
C NT returns a BADFILENAME error instead of file not found, if
C it is passed a string like "CRDSC:", so we must either check
C for FNF and BADFILENAME, or better still, just let the system
C try again with a NEW file, if that still fails, then there is an
C error.
##GIDWXS      IF ( IOS .NE. ISSFNF ) GO TO 9900
C
C -- WE HAVE THEREFORE TRIED TO OPEN A NON-EXISTANT FILE WITH STATUS
C    'OLD' . TRY AGAIN WITH STATUS = 'NEW'
C
      ACSTAT = FLSTAT(ISSNEW)
      GO TO 2000
C
C
9000  CONTINUE
C
C
      KFLOPN = 1
      RETURN
C
C
9900  CONTINUE
C
C -- ERROR EXIT
C
      KFLOPN = ISIGN ( IOS , -1 )
      RETURN
C
9910  CONTINUE
C -- INTERNAL ERROR DETECTED
CS*** The following line has been changed out causing compiling error
C**** A third parameter has been added (0)
C**** Ludwig Macko, 23.11.1994
C****
      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
CE*** instead of CALL XOPMSG ( IOPCRY , IOPINT )
      GO TO 9900
C
      END
C
CODE FOR KDAOPN
      FUNCTION KDAOPN ( IDUNIT , CFNAME , IFSTAT , IFMODE )
C
C -- OPEN A D/A ( DIRECT ACCESS ) FILE ON UNIT 'IDUNIT' .
C    THIS ROUTINE MAY BE USED TO OPEN EITHER A DATA DISC FILE OR A
C    COMMAND FILE .
C
C      **** MACHINE SPECIFIC ****
C
C    THIS ROUTINE WILL ATTEMPT TO CREATE A NEW DISC FILE IF THE
C    PARAMETER 'IFSTAT' HAS THE VALUE 'ISSCIF' AND AN OLD FILE CANNOT
C    BE OPENED . IN THE VAX/VMS VERSION THE ERROR STATUS
C    'FILE NOT FOUND' IS EXPLICITLY CHECKED.
C
C       IF IT IS NOT POSSIBLE ON ANY PARTICULAR SYSTEM TO CREATE A NEW
C    DIRECT ACCESS FILE IN THE WAY THIS ROUTINE DOES IT,
C    A SEPARATE PROGRAM WILL HAVE TO BE WRITTEN TO CREATE THE FILE
C    AND INITIALISE IT WITH :-
C
C         A SUITABLE NUMBER OF RECORDS
C
C         VALID FILE AND CURRENT LIST INDEXES, WRITTEN WITH THE
C         ROUTINES XSETFI AND XSETLI
C
C
C    THE PARAMETER 'IFMODE' CAN HAVE THE VALUE 'ISSREA'. ON SYSTEMS
C    WHERE SUITABLE FACILITIES ARE AVAILABLE, THE FILE SHOULD BE
C    OPENED READ-ONLY AND/OR SHARED. IF THIS IS NOT POSSIBLE, PROGRAM
C    OPERATION WILL NOT BE AFFECTED, BUT THE POSSIBILITY OF ACCESS
C    CONFLICTS MUST BE CONSIDERED.
C
C -- PARAMETERS :-
C
C    IDUNIT       UNIT ON WHICH FILE IS TO BE OPENED
C
C      CFNAME      NAME OF FILE ( IF THIS STRING IS EMPTY, THE FILE NAME
C                  IS NOT USED TO OPEN THE FILE )
C      CLCNAM      LOWER CASE VERSION OF NAME FOR UNIX MACHINES
C    IFSTAT       FILE STATUS 'ISSOLD' , 'ISSNEW' , 'ISSCIF'
C                      'CIF' IS 'CREATE IF FILE CANNOT BE OPENED'
C
C    IFMODE       MODE OF ACCESS REQUIRED : - 'ISSREA' OR 'ISSWRI'
C
&PPCC                    'READ' IMPLIES READONLY,SHARED IS IGNORED
&H-PC                    THIS PARAMETER IS IGNORED
&DOSC                    THIS PARAMETER IS IGNORED
&VAXC                    'READ' IMPLIES READONLY,SHARED
C
C
C -- RETURN VALUES :-
C
C            -VE         FAILURE ( RETURNS IOSTAT VALUE )
C            +VE         SUCCESS
C
cdjwapr99
      logical lexist
C
      INTEGER IDUNIT , IFSTAT , IFMODE
      CHARACTER*(*) CFNAME
      CHARACTER *256 CLCNAM, FILNAM
C
C
      CHARACTER*7 FLSTAT(4)
      CHARACTER*7 ACSTAT

\XOPVAL
\XSSVAL
\XUNITS
\XIOBUF


      DATA FLSTAT / 'OLD    ' , 'NEW    ' , 'CIF    ','SCRATCH' /
      CLCNAM =  ' '
      FILNAM = CFNAME

&CYBC THE 'DISK' FILE WAS A SCRATCH, CREATED FROM NEW EACH RUN
&CYB      IF (FILNAM .EQ. ' ') THEN
&CYB            IF(IUNIT .GE. 10)THEN
&CYB            WRITE(FILNAM,100) IUNIT
&CYB100         FORMAT('TAPE',I2.2)
&CYB            ELSE
&CYB            WRITE(FILNAM,101) IUNIT
&CYB101         FORMAT('TAPE',I1.1)
&CYB      ENDIF

      NAMLEN = MAX (INDEX( FILNAM, ' ')-1, 0)
      IF (ISSFLC .EQ. 0) THEN
C----- CONVERT NAME TO LOWER CASE
            IF (NAMLEN .GT. 0) CALL XCCLWC (FILNAM, CLCNAM(1:NAMLEN) )
      ELSE IF (ISSFLC .EQ. 1) THEN
C----- CONVERT NAME TO UPPER CASE
            IF (NAMLEN .GT. 0) CALL XCCUPC (FILNAM, CLCNAM(1:NAMLEN) )
      ELSE
            IF (NAMLEN .GT. 0) CLCNAM(1:NAMLEN) = FILNAM(1:NAMLEN)
      ENDIF


C -- CHECK DATA TO SOME EXTENT
      IF ( IFSTAT .GT. ISSSCR ) GO TO 9910
      IF ( IFMODE .GT. ISSWRI ) GO TO 9910

C -- SET REQUIRED STATUS TO THAT SPECIFIED
      ACSTAT = FLSTAT(IFSTAT)

C -- IF REQUEST IS 'CIF' SET STATUS TO 'OLD'

      IF ( ACSTAT .EQ. 'CIF' ) ACSTAT = 'OLD'


2000  CONTINUE
C
      IF ( IFSTAT .NE. ISSSCR ) CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)

C      if a 'new' file already exists, return a proper message
      IF ((FLSTAT(IFSTAT) .EQ. 'NEW' ) .AND. (FILNAM .NE. ' '))THEN
       lexist = .false.
       inquire(file=clcnam(1:namlen), exist=lexist)
       if (lexist ) goto 9920
      endif

      IF ( IFMODE .EQ. ISSREA ) GO TO 2500

      IF ( FILNAM .EQ. ' ' ) THEN
        OPEN ( UNIT   = IDUNIT ,
     1         STATUS = ACSTAT ,
     1         ACCESS = 'DIRECT' ,
     1         FORM   = 'UNFORMATTED' ,
     1         RECL   = ISSDAR ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )

      ELSE

        OPEN ( UNIT   = IDUNIT ,
     1         FILE   = CLCNAM ,
     1         STATUS = ACSTAT ,
     1         ACCESS = 'DIRECT' ,
     1         FORM   = 'UNFORMATTED' ,
     1         RECL   = ISSDAR ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
      ENDIF

      IF (IOS .NE. ISSOKF) GOTO 3000

C -- SUCCESS

C -- IF A NEW FILE HAS BEEN CREATED, SOME INITIALISATION TASKS
C    MUST BE PERFORMED IMMEDIATELY

      IF ((ACSTAT.EQ.'NEW').OR.(ACSTAT.EQ.'SCRATCH'))CALL XDAINI(IDUNIT)

      GO TO 9000

2500  CONTINUE
&VAXC -- SPECIAL 'READONLY' , 'SHARED' OPEN FOR VAX/VMS

      IF ( FILNAM .EQ. ' ' ) THEN
        OPEN ( UNIT   = IDUNIT ,
&VAX     1         SHARED ,
&&&VAXDVFGID     1         READONLY ,
#DOS     1         STATUS = ACSTAT ,
&DOS     1         STATUS = 'READONLY',
     1         ACCESS = 'DIRECT' ,
     1         FORM   = 'UNFORMATTED' ,
     1         RECL   = ISSDAR ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )

      ELSE
        CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)
        OPEN ( UNIT   = IDUNIT ,
     1         FILE   = CLCNAM ,
&VAX     1         SHARED ,
&&&VAXDVFGID     1         READONLY ,
#DOS     1         STATUS = ACSTAT ,
&DOS     1         STATUS = 'READONLY',
     1         ACCESS = 'DIRECT' ,
     1         FORM   = 'UNFORMATTED' ,
     1         RECL   = ISSDAR ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
      ENDIF

      IF (IOS .NE. ISSOKF) GOTO 3000

      GO TO 9000


3000  CONTINUE
C
C -- OPEN FAILED -- IF IT SHOULD HAVE SUCCEEDED THEN THIS IS AN ERROR
C
      IF ( ACSTAT .EQ. FLSTAT(ISSNEW) ) GO TO 9900
      IF ( IFSTAT .EQ. ISSOLD ) GO TO 9900

CRICJUL00
C NT returns a BADFILENAME error instead of file not found, if
C it is passed a string like "CRDSC:", so we must either check
C for FNF and BADFILENAME, or better still, just let the system
C try again with a NEW file, if that still fails, then there is an
C error.
##GIDWXS      IF ( IOS .NE. ISSFNF ) GO TO 9900

C -- WE HAVE THEREFORE TRIED TO OPEN A NON-EXISTANT FILE WITH STATUS
C    'OLD' . TRY AGAIN WITH STATUS = 'NEW'

      ACSTAT = FLSTAT(ISSNEW)
      GO TO 2000


9000  CONTINUE

C -- NORMAL EXIT FROM ROUTINE

C    SET FLAG

      KDAOPN = 1
      RETURN


9900  CONTINUE

C -- ERROR EXIT FROM ROUTINE

C    SET FLAG

      KDAOPN = ISIGN ( IOS , -1 )
      RETURN

9910  CONTINUE
C -- INTERNAL ERROR DETECTED
CS*** The following line has been changed out causing compiling error
C**** A third parameter has been added (0)
C**** Ludwig Macko, 23.11.1994
C****
cdjw      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
      CALL XOPMSG ( IOPCRY , IOPcmi , 0 )
CE*** instead of CALL XOPMSG ( IOPCRY , IOPINT )
      GO TO 9900
cdjwapr99
9920  continue
      CALL XCTRIM(CLCNAM, ILEN)
      write(cmon,'(a,a,a)')
     1 ' The D/A file ( ', clcnam(1:ILEN) ,
     2 ' )already exists and cannot be overwritten'
      CALL XPRVDU(NCEROR, 1, 0)
      IF (ISSPRT .EQ. 0) WRITE (NCWU, '(a)' ) cmon(1)
      goto 9910
      END
C
CODE FOR KFLCLS
      FUNCTION KFLCLS ( IUNIT )
C
C -- CLOSE THE FILE OPEN ON UNIT 'IUNIT'. THIS ROUTINE IGNORES ERRORS
C    AND ALWAYS RETURNS THE VALUE 1
C
&PPCCS***
&PPC      CHARACTER*31 FNAME
&PPCC
&PPC      INQUIRE ( UNIT = IUNIT, NAME = FNAME )
&PPC      IF ( IUNIT .EQ. 20 .AND. FNAME .EQ. 'CRYSTALS.SRT' ) THEN
&PPC         CALL killsplash
&PPC      ENDIF
&PPCCE***
      CLOSE ( UNIT = IUNIT , ERR = 2000 )
2000  CONTINUE
C
      KFLCLS = 1
      RETURN
      END
C
CODE FOR XFLUNW
      SUBROUTINE XFLUNW ( IFUNC , IMSG )
C
C -- CLOSE CONTROL FILE(S)
C
C  INPUT :-
C      IFUNC       SELECT UNWIND FUNCTION
C                    1      CLOSE ALL FILES BACK TO MAIN LEVEL
C                    2      CLOSE CURRENT FILE ONLY
C                    3      CLOSE ALL FILES BACK TO A TERMINAL
C                    4      DO NOT CLOSE ANY FILES. SET CHARACTERISTICS
C                             ONLY
C      IMSG        MESSAGE LEVEL
C                    1      DO NOT LOG FILES AS THEY ARE CLOSED
C                    2      LOG FILES AS THEY ARE CLOSED AS 'ABANDONED'
C                    3      LOG FILES AS THEY ARE CLOSED AS 'CLOSED'
C
C -- MESSAGE TYPE REQUESTED IS OVERRIDDEN BY VALUE OF IRDCMS STORED
C    FOR THIS UNIT NUMBER
C
      CHARACTER*256 NAME
      CHARACTER*10 ACTION(3)
C
\UFILE
\XUNITS
\XSSVAL
\XCARDS
\XIOBUF
C
      DATA ACTION(1) / '          ' /
      DATA ACTION(2) / 'abandoned ' /
      DATA ACTION(3) / 'closed    ' /
C
      IF ( IFUNC .EQ. 1 ) THEN
        ILSTLV = 1
&PRI      ISSSTA = 0
      ELSE IF ( IFUNC .EQ. 2 ) THEN
        ILSTLV = IFLIND - 1
      ELSE IF ( IFUNC .EQ. 3 ) THEN
        ILSTLV = 1
      ELSE IF ( IFUNC .EQ. 4 ) THEN
        ILSTLV = IFLIND
      ENDIF
      IF ( ILSTLV .LE. 0 ) GO TO 9910
C
C
1000  CONTINUE
      IF ( IFLIND .LE. ILSTLV ) GO TO 2000
      IF ( IFUNC .EQ. 3 ) THEN
        IF ( IFLCHR(IFLIND) .EQ. 1 ) GO TO 2000
        IF ( IRDSCR(IFLIND) .GT. 0 ) GO TO 2000
      ENDIF
C
      IUNIT = NCUFU(IFLIND)
      I = KFLNAM ( IUNIT , NAME )
      CALL XCTRIM( NAME, NCHARS )
      IF ( ( IMSG .GT. 1 ) .AND. ( IRDCMS(IFLIND) .GT. 0 ) ) THEN
        IF ( I .GT. 0 ) THEN
          WRITE ( CMON,1005) ACTION(IMSG) , NAME(1:NCHARS)
          CALL XPRVDU(NCEROR, 2, 0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU, 1005 )ACTION(IMSG),NAME(1:NCHARS)
1005      FORMAT ( 1X, 'The following file has been ' , A, ' :- ' , / ,
     2 11X , A )
        ENDIF
      ENDIF
C
      ISTAT = KFLCLS ( IUNIT )
      IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
       WRITE(NCWU,1006) IFLIND, IUNIT, NAME(1:NCHARS)
1006   FORMAT(' Closing File index=',I3, ' Unit =',I4,A)
      ENDIF
      IFLIND = IFLIND - 1
      GO TO 1000
C
C
2000  CONTINUE
C
C -- SET CURRENT READ FILE UNIT AND CHARACTERISTICS
C
      NCRU = NCUFU(IFLIND)
      IF ( IFLCHR(IFLIND) .LE. 0 ) IFLCHR(IFLIND) = KFLCHR ( NCRU )
C
      ICAT = IRDCAT(IFLIND)
      IUSFLG = IFLCHR(IFLIND)
C
C
      RETURN
C
9910  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1, 0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
9915  FORMAT ( 1X , 'Attempt to close main control file' )
      RETURN
      END
C
CODE FOR XPRMPT
      SUBROUTINE XPRMPT ( IUNIT , TEXT )
C
C -- OUTPUT PROMPT STRING FOR SUBSEQUENT INPUT OPERATION
C
C      IUNIT       UNIT NUMBER ON WHICH TEXT IS TO BE DISPLAYED
C      TEXT        CHARACTER VARIABLE CONTAINING TEXT
C
C -- A MACHINE SPECIFIC ROUTINE TO STOP A CARRIAGE RETURN/LINE FEED
C    AFTER THE PROMPT TEXT HAS BEE OUTPUT CAN BE USED HERE.
C
C
      CHARACTER*(*) TEXT
\XUNITS
\XIOBUF
\CAMBLK
C
C>DJWOCT96
      IF (IUNIT .EQ. NCVDU) THEN
        WRITE ( CMON,1005) TEXT
        CALL XPRVDU(NCVDU, 1, 0)
&DOS       IF(.NOT.LCLOSE) CALL ZPRMPT(TEXT)
C        WRITE ( NCVDU,1005) TEXT
      ELSE
         WRITE ( IUNIT , 1005 ) TEXT
      ENDIF
C1005  FORMAT ( 1X, A , $)
1005  FORMAT ( 1X, A )
C
C<DJWOCT96
C
      RETURN
      END
C
CODE FOR XWHIZZ
      SUBROUTINE XWHIZZ (CTEXT, J)
C
C      PRODUCE SOME SORT OF DISPLAY TO SHOW THAT THE COMPUTER IS WORKING
C      CTEXT - SOME TEXT TO OUTPUT
C      J SOME MEASURE OF PROGRESS
      CHARACTER *(*) CTEXT
      CHARACTER *1 CLOCK(4)
\XUNITS
\XDRIVE
\XIOBUF
&&DOSDVF      DATA CLOCK / '|', '/', '-', '\' /
&&GIDVAX      DATA CLOCK / '|', '/', '-', '\' /
&&LINGIL      DATA CLOCK / '|', '/', '-', '\\' /
&WXS      DATA CLOCK / '|', '/', '-', '\\' /
C
       ICLOCK = 1 + MOD (J,4)
C
#PPCC       WRITE ( CMON, '(''+'',A,1X,A1,A1)')  CTEXT, CLOCK(ICLOCK),
#PPCC     1     CHAR(13)
#PPCC       CALL XPRVDU(NCVDU, 1, 0)
&PPCCS***
&PPC       IF ( LEN(CTEXT) .GT. 2 ) THEN
&PPCCE***
&PCC       WRITE ( CIOBUF, '(1X,A,1X,A1)')  CTEXT, CLOCK(ICLOCK)
&PPC       CALL FLBUFF( LEN(CTEXT)+3, 0, -1 )
&PPCCS***
&PPC       ELSE
&PPC            CALL nextmatrixcursor
&PPC       ENDIF
&PPCCE***
&XXXC------ DO NOTHING
      RETURN
      END
CODE FOR SLIDER
      SUBROUTINE SLIDER (IVALUE, MAXVAL)
C----- DRAW A SLIDER TO IVALUE % OF MAXVAL
\XUNITS
\XIOBUF
\XSSVAL
\XCHARS
      PARAMETER(NINTER = 50)
      CHARACTER*(NINTER) CDISPL
C
      IPERCN = MIN0 ( 100 , ( 100 * IVALUE ) / MAXVAL )
CDJWJAN99<
      IF (ISSTML .EQ. 4) THEN
&&&GILGIDWXS       WRITE (CMON,1505) IPERCN
&&&GILGIDWXS1505   FORMAT ('^^CO SET PROGOUTPUT COMPLETE = ',I3)
       CALL XPRVDU (NCVDU,1,0)
       RETURN
      ENDIF
      NSTAR = MIN0 ( NINTER, (NINTER * IVALUE ) / MAXVAL)
&XXX      STOP 'ROUTINE NOT IMPLEMENTED'
C
C----- LOAD THERMOMETER INTO CLEARED CHARACTER BUFFER
#PPC          CDISPL = ' '
#PPC          WRITE (CDISPL, 1510)  (IA , J = 1, NSTAR )
#PPC1510      FORMAT (50A1)
      IF (ISSTML .EQ. 3) THEN
#PPC        WRITE(NCVDU,'(A1,$)') IA
#PPC        RETURN
      ELSE
C----- GET A CARRIAGE RETURN, WITHOUT LINEFEED
#PPC        WRITE ( CMON,1515) IPERCN, CDISPL(1:NINTER) ,CHAR(13)
#PPC        CALL XPRVDU(NCVDU, 1, 0)
#PPC1515   FORMAT( '+', 10X, I4, 1X, A50,12X,A1)
C
C&H-P          WRITE ( NCAWU , 1515 ) IPERCN , ( IA , J = 1 , NSTAR )
C&H-P1515      FORMAT (  10X , I4 , 1X , 60A1 )
C&H-PC 27 = ESC, 65=A
C&H-P          WRITE ( NCAWU, 1516 ) CHAR(27),CHAR(65)
C&H-P1516      FORMAT ( 2A1 , NN )
C
&PPCC**** For the Macintosh version with Motorola compiler we need a
&PPCC**** special implementation of the thermometer.
&PPCC**** This has by the way the advantage of less IO
&PPCC**** 29.9.1995 Ludwig Macko
&PPCCS***
&PPC          IF ( IPERCN .EQ. 2 ) THEN
&PPC              WRITE ( CIOBUF , 1514 ) IA
&PPC              CALL FLBUFF( 22, 1, ISSPRT )
&PPC          ELSE
&PPC              IF ( IPERCN .EQ. 100 ) THEN
&PPC                  WRITE ( CIOBUF , 1516 ) IA
&PPC                  CALL FLBUFF( 1, 0, ISSPRT )
&PPC              ELSE
&PPC                  WRITE ( CIOBUF , 1515 ) IA
&PPC                  CALL FLBUFF( 1, 1, ISSPRT )
&PPC              ENDIF
&PPC          ENDIF
&PPC1514      FORMAT ( 15X, A1 )
&PPC1515      FORMAT ( A1 )
&PPC1516      FORMAT ( A1 )
&PPCCE***
      ENDIF
      RETURN
      END
C
CODE FOR XDAEND
      SUBROUTINE XDAEND ( IUNIT , LAST )
C
C -- RETURNS NUMBER OF RECORD THAT WOULD FOLLOW THE LAST ACTUALLY
C    PRESENT IN A DISC FILE
C
C -- READS EACH RECORD FROM THE FILE UNTIL ONE READ FAILS. THIS IS
C    ASSUMED TO BE THE FIRST NON-EXISTANT RECORD.
C
&DGV      CHARACTER*64 CFILE
      PARAMETER (NMXREC = 100 000)
\XUNITS
\XSSVAL
\XERVAL
C
C
&DGVC
&DGVC -- IN THE DATA GENERAL IMPLEMENTATION THE DIRECT ACCESS FILE IS
&DGVC    REOPENED AS SEQUENTIAL, THE END FOUND, AND THE FILE IS REOPENED
&DGVC    USING DIRECT ACCESS. ( DIRECT ACCESS READ SUCCEEDS WITH ANY
&DGVC    POSITIVE RECORD NUMBER )
&DGVC
&DGV      INQUIRE ( UNIT = IUNIT , NAME = CFILE , RECL = IRECL )
&DGV      CLOSE ( IUNIT )
&DGVC
&DGV      OPEN ( IUNIT , FILE = CFILE , ACCESS = 'SEQUENTIAL' ,
&DGV     2      FORM = 'UNFORMATTED' , STATUS = 'OLD' )
&DGVC
C
      J = NMXREC
      DO 2000 I = 1, J
C
      LAST = I
C
&PPC      READ ( IUNIT , REC = I , ERR = 3000, END=3000, IOSTAT=IOS ) J
&68K      READ ( IUNIT , REC = I , ERR = 3000,IOSTAT=IOS) J
&68K      IF (IOS .EQ. -1) GOTO 3000
&H-P      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS ) J
&DGV      READ ( IUNIT , END = 3000 ) J
&DOS      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS) J
&DOS      IF (IOS .EQ. -1) GOTO 3000
&LIN      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS) J
&LIN      IF (IOS .EQ. -1) GOTO 3000
&GIL      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS) J
&GIL      IF (IOS .EQ. -1) GOTO 3000
&WXS      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS) J
&WXS      IF (IOS .EQ. -1) GOTO 3000
&&DVFGID      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS) J
&&DVFGID      IF (IOS .EQ. -1) GOTO 3000
&VAX      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS) J
&VAX      IF (IOS .EQ. -1) GOTO 3000
C
2000  CONTINUE
C
      WRITE(NCWU,2010) J
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2010) J
      ENDIF
2010  FORMAT (1X, 'File is too long -- more than ', I6,' records' , / )
 
      CALL XERHND ( IERCAT )
C      STOP 100
      CALL GUEXIT(100)
C
3000  CONTINUE
C
&DGVC
&DGVC -- CLOSE AND REOPEN FILE
&DGVC
&DGV      CLOSE ( IUNIT )
&DGV      OPEN ( IUNIT , FILE = CFILE , ACCESS = 'DIRECT' ,
&DGV     2       RECL = IRECL ,
&DGV     2       FORM = 'UNFORMATTED' , STATUS = 'OLD' )
&DGVC
C
C
      RETURN
      END
C
CODE FOR KPATH
      FUNCTION KPATH( CPATH)
C----- THIS ROUTINE RETURNS THE PATH TO THE USERS FILES BY UNPICKING THE
C      DISC FILE NAME.
C----- A NULL STRING IS A PERMITTED RETURN VALUE IF THE PROGRAM IS RUN
C      FROM THE DIRECTORY CONTAINING THE FILES
C
C -- RETURN VALUES :-
C      1      NULL STRING
C      ELSE    LENGTH
C
      CHARACTER*(*) CPATH
      CHARACTER*256 CNAME
C
\XUNITS
\XSSVAL
\XDISCS
C
      KPATH = 1
      CPATH = ' '
      IF (KFLNAM( NCDFU, CNAME) .GT. 0) THEN
C----- UNDER MAC OS, LOOK FOR THE ':'
&PPC            I = INDEX (CNAME, ':' )
C----- UNDER UNIX, LOOK FOR THE '/'
&H-P            I = INDEX (CNAME, '/' )
C----- UNDER DOS, LOOK FOR THE LAST BACKSLASH - CHAR(92)
&DOS            J = LEN (CNAME)
&DOS            DO 10 K = J, 1, -1
&DOS              IF (CNAME(K:K) .EQ. CHAR(92)) GOTO 20
&DOS10          CONTINUE
&DOS            K = 0
&DOS20          CONTINUE
&DOS            I = K
C----- UNDER LINUX, LOOK FOR THE LAST FORWARDSLASH - CHAR(?)
&&GILLIN            J = LEN (CNAME)
&&GILLIN            DO 10 K = J, 1, -1
&&GILLIN              IF (CNAME(K:K) .EQ. '/') GOTO 20
&&GILLIN10          CONTINUE
&&GILLIN            K = 0
&&GILLIN20          CONTINUE
&&GILLIN            I = K
&WXS            J = LEN (CNAME)
&WXS            DO 10 K = J, 1, -1
&WXS              IF (CNAME(K:K) .EQ. '/') GOTO 20
&WXS10          CONTINUE
&WXS            K = 0
&WXS20          CONTINUE
&WXS            I = K
C----- UNDER WIN, LOOK FOR THE LAST BACKSLASH - CHAR(92)
&&DVFGID            J = LEN (CNAME)
&&DVFGID            I = KCLEQL ( CNAME, CHAR(92))
&VAXC----- UNDER VMS, LOOK FOR THE ']'
&VAX            I = INDEX (CNAME, ']' )
&XXX            I = 0
            IF (I .GT. 0) THEN
              CPATH(1:I) = CNAME(1:I)
              KPATH = I
            ENDIF
      ENDIF
      RETURN
      END
C
CODE FOR XQUEN
      SUBROUTINE XQUEN
C -- THIS SUBROUTINE DETERMINES THE 'USER ENVIRONMENT'
C
C -- IT IS REQUIRED TO SET VALUES FOR THE VARIABLES 'IQUN' AND 'JQUN'
C    IN THE COMMON BLOCK 'XUNITS' TO INDICATE THE ENVIRONMENT IN WHICH
C    THE CURRENT JOB IS BEING PROCESSED
C
C -- THE MAIN PROBLEM THAT WILL OCCUR IF THE ROUTINE IS NOT IMPLEMENTED
C    IN FULL WILL BE IN THE 'CRYSTALS' ERROR HANDLING FACILITY. THIS
C    TREATS ERRORS DIFFERENTLY DEPENDING ON WHETHER OR NOT USER
C    INTERVENTION IS POSSIBLE TO CORRECT ANY UNTOWARD CONSEQUENCES OF
C    THE ERROR. THIS BEHAVIOUR IS ESTABLISHED IN THE ROUTINE 'XERINI'
C    WHICH IS CALLED ONCE AT THE BEGINNING OF EACH RUN.
C
C
C  VALUES OF IQUN :-
C
C  VALUE       PROCESS TYPE      MAIN COMMAND LEVEL      INTERNAL NAME
C  -----       ------- ----      ---- ------- -----      -------- ----
C  1           INTERACTIVE       TERMINAL                'INTERACTIVE'
C  2           INTERACTIVE       A FILE                  'ONLINE'
C  3           BATCH             A FILE                  'BATCH'
C
C  THE VALUE OF 'JQUN' SHOULD BE EQUAL TO 'IQUN' WHEN THE PROCESS TYPE
C  IS INTERACTIVE, AND NOT OTHERWISE
C
C
&VAXC
&VAXC -- THE TECHNIQUE USED ON THE VAX IS TO FIND THE VALUE OF THE DCL
&VAXC    SYMBOL 'CRYSTALS_MODE' SET BY THE COMMAND PROCEDURE. THE WILL
&VAXC    WILL BE A STRING WITH THE VALUE 'BATCH','ONLINE', OR
&VAXC    'INTERACTIVE'.
&VAXC
&VAXC -- PREVIOUSLY, THE METHOD USED WAS :-
&VAXC
&VAXC      (1)         THE PROCESS TYPE ( BATCH/INTERACTIVE ) IS
&VAXC                  DETERMINED BY TRANSLATING THE LOGICAL NAME 'TT'
&VAXC                  IF THE TRANSLATION IS '_NLA0:' THE PROCESS IS
&VAXC                  ASSUMED TO BE OPERATING IN BATCH MODE
&VAXC      (2)         FOR INTERACTIVE PROCESSES, THE LOGICAL NAME
&VAXC                  'FOR005' IS TRANSLATED. FOR PROCESSES WHOSE MAIN
&VAXC                  COMMAND LEVEL IS THE TERMINAL, THE TRANSLATION
&VAXC                  IS 'TT'
&VAXC
&VAXC    THIS MIGHT BE IMPROVED BY USING '$GETJPI' TO DETERMINE (1),
&VAXC    AND 'KFLCHR' TO DETERMINE (2).
&VAXC
C
&PRI      PARAMETER ( KEY = 1 )
&PRI      PARAMETER ( NCHAR = 16 )
&PRI      CHARACTER*(NCHAR) CRESLT
&PRI      INTEGER*2 INFO(8) , ICODE
&H-P      INTEGER SYSTEM
C
#PPC      CHARACTER*32 CMODE
#PPC      CHARACTER*64 CSUBTX(3)
C
#PPC      COMMON /XSUBTX/ CSUBTX
#PPC      COMMON /XSUBLN/ LSUBTX(3)
C
C
&ICL      INTEGER *8 IQN
\XUNITS
\XSSVAL
\XCHARS
C
#PPC      CMODE = ' '
C
&VAX      ISTAT = LIB$GET_SYMBOL ( 'CRYSTALS_MODE' , CMODE )
&VAX      IF ( .NOT. ISTAT ) CALL LIB$STOP ( %VAL(ISTAT) )
C
&PRI      CALL RDTK$$ ( INTS(KEY), INFO, CRESLT, INTS(NCHAR/2), ICODE )
&PRI      CMODE = CRESLT
C
&DGV      CALL XRDKEY ( 1 , CMODE , LMODE )
C
&H-P      IER = SYSTEM('tty -s')
&H-P      IF ( IER .EQ. 0) THEN
&H-P        CMODE = 'INTERACTIVE'
&H-P      ELSE
&H-P        CMODE = 'BATCH'
&H-P      END IF
C
&ICL      CALL READSCLINT('USAGE',IQN,IRES)
&ICL      IF ( IQN .EQ. 1 ) THEN
&ICL        CMODE = 'BATCH'
&ICL      ELSE
&ICL        CMODE = 'INTERACTIVE'
&ICL      ENDIF
C
#PPC      IF ( CMODE .EQ. 'BATCH' ) THEN
#PPC        IQUN = 3
#PPC        JQUN = 0
#PPC      ELSE IF ( CMODE .EQ. 'ONLINE' ) THEN
#PPC        IQUN = 2
#PPC        JQUN = 2
#PPC      ELSE
#PPC        IQUN = 1
#PPC        JQUN = 1
#PPC      ENDIF
C
C----- READ OTHER PARAMETERS OFF COMMAND LINE (DGV ONLY)
&PPCCS*** Inserted
&PPCC**** Ludwig Macko, 5.12.1994
&PPC      IQUN = 1
&PPC      JQUN = 1
&PPCCE*** Inserted
&VAX      DO 2000 I = 1 , 3
&VAX        CALL XRDKEY ( I + 1 , CSUBTX(I) , LSUBTX(I) )
&VAX2000  CONTINUE
      RETURN
      END
C
CODE FOR XRDKEY
&&VAXDGV      SUBROUTINE XRDKEY ( IKEY , CTEXT , LENGTH )
&&VAXDGV      IMPLICIT INTEGER ( A - Z )
C
C -- READ DATA FROM CURRENT CLI.
C
C -- THIS ROUTINE IS USED TO PASS INFORMATION INTO CRYSTALS FROM OUTSIDE
C    FOR USE WITH 'XRDSUB'.
C
C -- THIS ROUTINE IS CURRENTLY ONLY IMPLEMENTED FOR THE 'DATA GENERAL'
C    VERSION OF 'CRYSTALS'
C
C      IKEY        REFERENCE NUMBER OF ITEM
C
C      CTEXT       TEXT FOUND
C      LENGTH      LENGTH OF TEXT FOUND
C
C
&&VAXDGV      CHARACTER*(*) CTEXT

&VAX      LENGTH = 0
&VAX      CTEXT = ' '

&DGV      CHARACTER*80 CBUFFR
&DGVC
&DGV      INTEGER*4 ISYS_GTMES
&DGVC
&DGVC -- ?.GTMES = 307K , ?GARG = 3K
&DGV      PARAMETER ( ISYS_GTMES = 199 )
&DGV      PARAMETER ( ISYS_GARG = 3 )
&DGVC
&DGV      PARAMETER ( IGTLTH = 6 )
&DGV      INTEGER*2 IPACKT(0:IGTLTH-1)
&DGVC
&DGV      EQUIVALENCE ( IPACKT(4) , ADDRESS_OF_BUFFER )
&DGVC
&DGVC
&DGV      IPACKT(0) = ISYS_GARG
&DGV      IPACKT(1) = IKEY
&DGV      IPACKT(2) = 0
&DGV      IPACKT(3) = 0
&DGV      ADDRESS_OF_BUFFER = BYTEADDR ( CBUFFR )
&DGVC
&DGV      IAC0 = 0
&DGV      IAC1 = 0
&DGV      IAC2 = WORDADDR ( IPACKT )
&DGVC
&DGV      IER = ISYS ( ISYS_GTMES , IAC0 , IAC1 , IAC2 )
&DGVC
&DGV      IF ( IER .NE. 0 ) THEN
&DGV        LENGTH = 0
&DGV        CTEXT = ' '
&DGV      ELSE
&DGV        LENGTH = INDEX ( CBUFFR , CHAR ( 0 ) ) - 1
&DGV        CTEXT = CBUFFR(1:LENGTH)
&DGV      ENDIF
&&VAXDGV      RETURN
&&VAXDGV      END
C
CODE FOR XRDSUB
      SUBROUTINE XRDSUB ( CTEXT )
C
C -- THIS ROUTINE SCANS THE INPUT TEXT FOR POSSIBLE SUBSTITUTION MARKERS
C    AND IF ONE IS FOUND, REPLACES THE TEXT.
C
C      CTEXT       TEXT TO BE SCANNED AND MODIFIED
C
      CHARACTER*(*) CTEXT
C
      PARAMETER ( MAXSUB = 3 )
      CHARACTER*80 CBUFFR
C
      CHARACTER*64 CSUBTX(MAXSUB)
C
      CHARACTER*1 CSUBST
      CHARACTER*4 CCOUNT
C
      COMMON /XSUBTX/ CSUBTX
      COMMON /XSUBLN/ LSUBTX(MAXSUB)
C
      DATA CSUBST / '+' /
C
C
C -- CHECK IF SUPPLIED TEXT HAS TWO SUBSTITUTION MARKERS IN IT, WITH AT
C    LEAST ONE CHARACTER BETWEEN THEM
C
      IPOS = INDEX ( CTEXT , CSUBST )
      IF ( IPOS .LE. 0 ) RETURN
C
      IPOS2 = INDEX ( CTEXT(IPOS+1:) , CSUBST ) + IPOS
      IF ( IPOS2 .LE. IPOS + 1 ) RETURN
C
C -- GET IDENTIFYING NUMBER
C
      CCOUNT = CTEXT(IPOS+1:IPOS2-1)
      READ ( CCOUNT , '(BN,I4)' , ERR = 9900 ) ICOUNT
C
C -- CHECK IF VALUE IS IN RANGE, AND THAT THERE IS SOME TEXT
C    CORRESPONDING TO IT.
C
      IF ( ICOUNT .LE. 0 ) RETURN
      IF ( ICOUNT .GT. MAXSUB ) RETURN
C
      IF ( LSUBTX(ICOUNT) .LE. 0 ) RETURN
C
C -- FORM NEW STRING
C
      CBUFFR = CTEXT(1:IPOS-1)
      CBUFFR(IPOS:) = CSUBTX(ICOUNT)
      CBUFFR(IPOS+LSUBTX(ICOUNT):) = CTEXT(IPOS2+1:)
C
      CTEXT = CBUFFR
C
      RETURN
C
9900  CONTINUE
      RETURN
C
      END
C
CODE FOR MTIME
      SUBROUTINE MTIME(RTIME)
C
C -- DETERMINE THE PROCESSOR TIME (SECONDS) USED SO FAR
C
C -- THE VALUE RETURNED BY THIS ROUTINE IS USED IN THE MESSAGES
C    PRODUCED AFTER THE COMPLETION OF EACH FACILITY WHICH SHOW THE
C    PROCESSOR TIME USED SO FAR. A PATCH WOULD BE
C    TO ALWAYS RETURN THE VALUE 0.0 FROM THIS ROUTINE
C    THE VARIABLE 'ISSTIM' IN THE 
C    COMMON BLOCK 'XSSVAL' CAN BE USED TO DISABLE THESE MESSAGES.
C
&&DVFGID      USE DFPORT
      REAL RTIME
&VAX      IMPLICIT INTEGER  (A-Z)
C&&DVFGID      RTIME = RTC()
&&DVFGID      CALL CPU_TIME(RTIME)
&WXS      CALL CPU_TIME(RTIME)
&VAXC
&VAXC -- ON THE VAX THE FUNCTION IS IMPLEMENTED BY USING THE SYSTEM
&VAXC    SERVICE ROUTINE '$GETJPI'.
&VAXC    A REQUEST BLOCK IS SET UP IN THE ARRAY 'I2BLK', INCLUDING THE
&VAXC    ADDRESS OF A LOCAL VARIABLE TO RECIEVE THE TIME VALUE, AS AN
&VAXC    INTEGRAL NUMBER OF 10 MILLISECOND UNITS. THIS IS CONVERTED TO
&VAXC    A REAL VALUE IN SECONDS BEFORE RETURN.
&VAXC
&VAXC
&VAXC -- DEFINE PARAMETERS REPRESENTING CONSTANTS REQUIRED FOR $GETJPI
&VAX      PARAMETER JPI$C_LISTEND = '00000000'X
&VAX      PARAMETER JPI$_CPUTIM = '00000407'X
&VAXC
&VAX      INTEGER*4 I4BLK(4)
&VAX      INTEGER*2 I2BLK(8)
&VAX      EQUIVALENCE ( I4BLK(1) , I2BLK(1) )
&VAXC
&VAXC -- $GETJPI REQUEST BLOCK
&VAXC    SEE VAX/VMS SYSTEM SERVICES REFERENCE MANUAL FOR FORMAT
&VAXC
&VAX      DATA I2BLK / 4, JPI$_CPUTIM, 0, 0, 0, 0, JPI$C_LISTEND, 0  /
&VAXC
&VAXC -- INSERT ADDRESS OF VARIABLE TO RECEIVE CPUTIME IN REQUEST BLOCK
&VAXC
&VAX      I4BLK(2) = %LOC ( CPU )
&VAXC
&VAXC -- CALL SYSTEM SERVICE AND CHECK RESULT
&VAXC
&VAX      ISTAT = SYS$GETJPI ( , , ,  I2BLK , , ,  )
&VAX      IF ( .NOT. ISTAT ) CALL LIB$STOP ( %VAL ( ISTAT ) )
&VAXC
&VAXC -- CONVERT CPU TIME RETURNED TO SECONDS
&VAXC
&VAX      RTIME = FLOAT ( CPU ) / 100.
C
C
C
&PRIC
&PRI      PARAMETER ( NDATA = 28 )
&PRI      INTEGER*2 ISDATA(NDATA)
&PRIC
&PRI      CALL TIMDAT ( ISDATA , INTS(NDATA) )
&PRI      RTIME = REAL ( ISDATA(7) )
&PRIC
C
&DGVC
&DGV      IMPLICIT INTEGER ( A - Z )
&DGVC
&DGV      PARAMETER ( GRLTH = 4 )
&DGV      PARAMETER ( ISYS_RUNTM = 30K )
&DGVC
&DGV      DIMENSION IPACKT(GRLTH)
&DGVC
&DGV      IAC0 = -1
&DGV      IAC1 = 0
&DGV      IAC2 = WORDADDR ( IPACKT )
&DGVC
&DGV      IER = ISYS ( ISYS_RUNTM , IAC0 , IAC1 , IAC2 )
&DGV      IF ( IER .NE. 0 ) THEN
&DGV        RTIME = 0.0
&DGV      ELSE
&DGV        RTIME = REAL ( IPACKT(2) ) / 1000.0
&DGV      ENDIF
&DGVC
C
&H-P      INTEGER TIMES
&H-P      DIMENSION IBUF(8)
&H-P      ILAPS1 = TIMES(IBUF)
&H-P      RTIME = FLOAT(IBUF(1)) / 60.0
C
&DOS      CALL CLOCK@ (RTIME)
C
C
&PPCC -- FOR MAC OS, WE WILL RETURN 0
&PPC      RTIME = 0.0
&XXXC -- FOR UNIDENTIFIED APPLICATIONS, ALWAYS RETURN THE VALUE '0.0'
&XXX      RTIME = 0.0
C
      RETURN
      END
C
CODE FOR JTIME
C RICMAY99 ITIME is an intrinsic on some systems. Renamed JTIME.
      SUBROUTINE JTIME ( I )
C
C -- RETURN , AS INTEGER VALUE , THE NUMBER OF SECONDS SINCE MIDNIGHT
&&DVFGID      USE DFPORT
C
C&&DVFGID      A = RTC()
C&&DVFGID      I = NINT (A)
CDJW&&DVFGID      I = TIME()
&&DVFGID      I = NINT ( SECNDS ( 0.0 ) )
&&GILLIN      CALL CPU_TIME(A)
&&GILLIN      I = NINT ( A )
&WXS      CALL CPU_TIME(A)
&WXS      I = NINT ( A )
C
&VAX      I = NINT ( SECNDS ( 0.0 ) )
C
&PRI      PARAMETER ( NDATA = 28 )
&PRI      INTEGER*2 ISDATA(NDATA)
&PRIC
&PRI      CALL TIMDAT ( ISDATA , INTS(NDATA) )
&PRI      I = ( 60 * ISDATA(4) ) + ISDATA(5)
C
C
&DGV      DIMENSION ITIME(3)
&DGVC
&DGV      CALL TIME ( ITIME )
&DGV      I = 3600 * ITIME(1) + 60 * ITIME(2) + ITIME(3)
C
&H-P      INTEGER TIMES
&H-P      DIMENSION IBUF(8)
&H-P      I = TIMES(IBUF)
&H-P      I = NINT(FLOAT(I)/60.)
C
&DOS      CALL CLOCK@ (A)
&DOS      I = NINT (A)
C
&PPC      I = getlssecnds()
C
&XXX      I = 0
C
      RETURN
      END
C
CODE FOR XTIMER
&&DVFGID      SUBROUTINE XTIMER ( CTIME2 )
&&LINGIL      SUBROUTINE XTIMER ( CTIME2 )
&WXS      SUBROUTINE XTIMER ( CTIME2 )
&&DOSVAX      SUBROUTINE XTIMER ( CTIME )
C
&&DVFGID      USE DFPORT
C -- GET SYSTEM TIME IN CHARACTER FORM
C
C -- THIS ROUTINE SHOULD RETURN THE CURRENT TIME IN THE CHARACTER*8
C    VARIABLE 'CTIME'
C
C -- IF THIS ROUTINE CANNOT BE IMPLEMENTED, THE VARIABLE CAN BE SET TO
C    SPACES.
C
C -- TIME FORMATS RETURNED BY SYSTEM ROUTINES
C
C      ROUTINE           FORMAT
C      -------           ------
C      ICL9LGGTIME       HHMMSS.DDD      ( DDD=DECIMAL PART OF SECONDS )
C      TIME              HH-MM-SS
C      TIME$A            HH-MM-SS
C      TIME              INTEGER ARRAY :- HOURS, MINUTES, SECONDS
C
\XSSVAL
C
&&DOSVAX      CHARACTER*8 CTIME
C
&ICL      CHARACTER*10 CTIME2
&DOS      CHARACTER*8 TIME@
&&DVFGID      CHARACTER*8 CTIME2
&&LINGIL      CHARACTER*8 CTIME2
&WXS      CHARACTER*8 CTIME2
&&LINGIL      DIMENSION ITIM(3)
&WXS      DIMENSION ITIM(3)

      IF ( ISSTIM .EQ. 2 ) THEN
&&DOSVAX        CTIME=' '
##DOSVAX        CTIME2=' '
        RETURN
      END IF


&ICL      CALL ICL9LGGTIME ( CTIME2 )
&ICL      CTIME = CTIME2(1:2)//'.'//CTIME2(3:4)//'.'//CTIME2(5:6)
C
&68K      CALL TIME ( CTIME )
&PPC      CALL getlstime( %loc(CTIME) )
C
&VAX      CALL TIME ( CTIME )
C
&PRI      CALL TIME$A ( CTIME )
C
&DGV      DIMENSION ITIME(3)
&DGVC
&DGV      CALL TIME ( ITIME )
&DGV      WRITE ( CTIME , '(I2,'':'',I2,'':'',I2)' ) ITIME
&DGVC
&DGV      IF ( CTIME(1:1) .EQ. ' ' ) CTIME(1:1) = '0'
&DGV      IF ( CTIME(4:4) .EQ. ' ' ) CTIME(4:4) = '0'
&DGV      IF ( CTIME(7:7) .EQ. ' ' ) CTIME(7:7) = '0'
C
&DOS      CTIME = TIME@()
C
&&DVFGID      CTIME2 = CLOCK()

&&LINGIL      CALL ITIME(ITIM)
&&LINGIL      WRITE ( CTIME2, '(I2,'':'',I2,'':'',I2)' ) ITIM
&WXS      CALL ITIME(ITIM)
&WXS      WRITE ( CTIME2, '(I2,'':'',I2,'':'',I2)' ) ITIM
C
&XXX      CTIME = ' '
C
      RETURN
      END
C
CODE FOR XDATER
      SUBROUTINE XDATER ( CDATE )
C
&&DVFGID      USE DFPORT
C -- THIS ROUTINE SHOULD RETURN THE CURRENT DATE IN THE CHARACTER*8
C    VARIABLE 'CDATE'.
C
C -- IF THIS ROUTINE CANNOT BE IMPLEMENTED, THE DATE CAN BE FILLED WITH
C    SPACES.
C
C -- THE DATE IS WRITTEN TO THE DISC FILE INDEX, AND CAN BE
C    USED TO DISTINGUISH LISTS. HOWEVER, THIS EXACT FORM IS NOT CHANGED
C    AND SPACES CAN BE USED SATISFACTORILY.
C
C -- DATE FORMATS RETURNED BY SYSTEM ROUTINES
C
C      ROUTINE           FORMAT
C      -------           ------
C      ICL9LGGDATE       YYYYMMDD       ( MM = '01' ETC. )
C      DATE              DD-MMM-YY      ( MMM = 'JAN' ETC. )
C      DATE$A            DAY, MMM DD YYYY ( MMM = 'JAN' ETC. ,
C                                           DAY = 'MON', 'TUE', ETC. )
C      DATE              INTEGER ARRAY :- YEAR, MONTH, DAY
C
\XSSVAL
C
&H-P$alias get_time = 'time' (%ref)
&H-P$alias format_time = 'ctime' (%ref)
&H-P$alias copy_time = 'sprintf' (%ref,%ref,%val)
&H-Pchp***
&H-P      integer format_time
&H-P      character*26 buf
&H-P      character*3 mese,mesi(12)
&H-P      integer char_ptr,itime(15)
&H-P      real*8 tmbuf
C
      CHARACTER*8 CDATE
C
&&DVFGID      CHARACTER*8 CDATE2
&ICL      CHARACTER*8 CDATE2
&VAX      CHARACTER*9 CDATE2
&VAX      CHARACTER*36 CMONTH
&VAX      DATA CMONTH /'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC'/
&PPC      CHARACTER*9 CDATE2
&PPC      CHARACTER*36 CMONTH
&PPC      DATA CMONTH /'JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC'/
&PRI      CHARACTER*16 CDATE2
&DGV      DIMENSION IDATE(3)
&DOS      CHARACTER*8 EDATE@
&&LINGIL      DIMENSION IDAT(3)
&WXS      DIMENSION IDAT(3)


      IF ( ISSTIM .EQ. 2 ) THEN
         CDATE = ' '
         RETURN
      END IF

&ICL      CALL ICL9LGGDATE ( CDATE2 )
&ICL      CDATE = CDATE2(7:8)//'.'//CDATE2(5:6)//'.'//CDATE2(3:4)
&PPC      CALL getlsdate( %loc(CDATE2) )
&PPC      CDATE = CDATE2(1:6)//CDATE2(8:9)
&PPC      I = INDEX (CMONTH, CDATE(4:6))
&PPC      I = (I+2)/3
&PPC      WRITE(CDATE(4:6),'(I2.2,A1)') I,'-'
&PPC      I = INDEX(CDATE(1:8), ' ')
&PPC      IF (I .NE. 0) CDATE(I:I) = '0'
C
C
&VAX      CALL DATE ( CDATE2 )
&VAX      CDATE = CDATE2(1:6)//CDATE2(8:9)
&VAX      I = INDEX (CMONTH, CDATE(4:6))
&VAX      I = (I+2)/3
&VAX      WRITE(CDATE(4:6),'(I2.2,A1)') I,'-'
&VAX      I = INDEX(CDATE(1:8), ' ')
&VAX      IF (I .NE. 0) CDATE(I:I) = '0'
C
&PRI      CALL DATE$A ( CDATE2 )
&PRI      CDATE = CDATE2(10:11)//'-'//CDATE2(6:8)//CDATE2(15:16)
C
&DGV      CALL DATE ( IDATE )
&DGV      WRITE ( CDATE , '(I2,''/'',I2,''/'',I2)' ) IDATE(3) ,
&DGV     2      IDATE(2) , MOD ( IDATE(1) , 100 )
&DGV      IF ( CDATE(1:1) .EQ. ' ' ) CDATE(1:1) = '0'
&DGV      IF ( CDATE(4:4) .EQ. ' ' ) CDATE(4:4) = '0'

&&LINGIL      CALL IDATE ( IDAT )
&&LINGIL      WRITE ( CDATE , '(I2,''/'',I2,''/'',I2)' ) IDAT(1) ,
&&LINGIL     2      IDAT(2) , MOD ( IDAT(3) , 100 )
&&LINGIL      IF ( CDATE(1:1) .EQ. ' ' ) CDATE(1:1) = '0'
&&LINGIL      IF ( CDATE(4:4) .EQ. ' ' ) CDATE(4:4) = '0'
&WXS      CALL IDATE ( IDAT )
&WXS      WRITE ( CDATE , '(I2,''/'',I2,''/'',I2)' ) IDAT(1) ,
&WXS     2      IDAT(2) , MOD ( IDAT(3) , 100 )
&WXS      IF ( CDATE(1:1) .EQ. ' ' ) CDATE(1:1) = '0'
&WXS      IF ( CDATE(4:4) .EQ. ' ' ) CDATE(4:4) = '0'
C
&H-P      call get_time (tmbuf)
&H-P      char_ptr=format_time(tmbuf)
&H-P      call copy_time(buf,'%s'//char(0),char_ptr)
&H-P      CDATE=buf(9:10)//'-'//buf(5:7)//buf(23:24)
C
&DOS      CDATE = EDATE@()
&&DVFGID      CDATE2 = DATE()
&&DVFGID      WRITE(CDATE,'(A,2(''/'',A))')
&&DVFGID     1    CDATE2(4:5),CDATE2(1:2),CDATE2(7:8)
C
&XXX      CDATE = ' '
C
      RETURN
      END
C
CODE FOR KOR
      FUNCTION KOR ( I , J )
C
C -- THIS ROUTINE SHOULD PERFORM AN 'INCLUSIVE OR' OF 'I' AND 'J'
C
&DOS      KOR = IOR ( I , J )
&PPC      KOR = JIOR ( I , J )
&&DVFGID      KOR = IOR ( I , J )
&&LINGIL      KOR = IOR ( I , J )
&WXS      KOR = IOR ( I , J )
&VAX      KOR = JIOR ( I , J )
&PRI      KOR = OR ( I , J )
&DGV      KOR = IOR ( I , J )
&IBM      KOR = IOR ( I , J )
&ORI      KOR = OR (I, J)
&H-P      KOR = IOR ( I , J )
&XXX      STOP 'KOR NOT IMPLEMENTED'
      RETURN
      END
C
CODE FOR KAND
      FUNCTION KAND ( I , J )
C
C -- THIS ROUTINE PERFORMS AN 'AND' OF 'I' AND 'J'
C
&DOS      KAND = IAND ( I , J )
&PPC      KAND = JIAND ( I , J )
&&DVFGID      KAND = IAND ( I , J )
&&LINGIL      KAND = IAND ( I , J )
&WXS      KAND = IAND ( I , J )
&VAX      KAND = JIAND ( I , J )
&PRI      KAND = AND ( I , J )
&DGV      KAND = IAND ( I , J )
&IBM      KAND = IAND ( I , J )
&ORI      KAND = AND (I, J)
&H-P      KAND = IAND ( I , J )
&XXX      STOP 'KAND NOT IMPLEMENTED'
      RETURN
      END
C
CODE FOR XMOVE
      SUBROUTINE XMOVE ( ISRCE , IRESLT , N )
C
C -- MOVES REALS, INTEGERS OR HOLERITHS FROM 'ISRCE'
C    TO 'IRESLT' WITHOUT TYPE CHECKING OR CONVERSION.
C
C -- MOVE N WORDS FROM 'ISRCE' TO 'IRESLT' . DIRECT FORTRAN WILL
C    FAIL IF TWO OVERLAPPING ARRAYS ARE INVOLVED UNLESS THE
C    SENSE OF THE MOVE CAN BE DETERMINED.
C
      DIMENSION ISRCE(N) , IRESLT(N)
C
&PPCC -- USE MOTO FORTRAN BUILT-IN FUNCTIONS TO FIND THE DIRECTION THE
&PPCC    DATA WILL BE MOVED
&PPC      I = %LOC ( ISRCE(1) )
&PPC      J = %LOC ( IRESLT(1) )
C
&&DVFGID      I = LOC ( ISRCE(1))
&&DVFGID      J = LOC ( IRESLT(1))
&&LINGIL      I = LOC ( ISRCE(1))
&&LINGIL      J = LOC ( IRESLT(1))
&WXS      I = LOC ( ISRCE(1))
&WXS      J = LOC ( IRESLT(1))
C
&VAXC -- USE VAX FORTRAN BUILT-IN FUNCTIONS TO FIND THE DIRECTION THE
&VAXC    DATA WILL BE MOVED
&VAX      I = %LOC ( ISRCE(1) )
&VAX      J = %LOC ( IRESLT(1) )
C
&DGVC -- USE D.G. SPECIFIC FORTRAN FUNCTIONS TO FIND THE DIRECTION THE
&DGVC    DATA WILL BE MOVED
&DGV      I = WORDADDR ( ISRCE(1) )
&DGV      J = WORDADDR ( IRESLT(1) )
C
&IBMC -- USE IBM  MACHINE CODE TO FIND THE DIRECTION THE
&IBMC    DATA WILL BE MOVED
&IBM      I = KLOCN ( ISRCE(1) )
&IBM      J = KLOCN ( IRESLT(1) )
C
&H-PC---- USE HEWLET PACKARD 'C' CODE TO FIND DIRECTION
&H-P      I = LOC ( ISRCE(1))
&H-P      J = LOC ( IRESLT(1))
C
&DOS      I = LOC ( ISRCE(1))
&DOS      J = LOC ( IRESLT(1))
C
&UNX      I = LOC ( ISRCE(1))
&UNX      J = LOC ( IRESLT(1))
C
      IF ( I .LT. J ) THEN
        DO 1000 I = N , 1 , -1
          IRESLT(I) = ISRCE(I)
1000    CONTINUE
      ELSE
        DO 1010 I = 1 , N
          IRESLT(I) = ISRCE(I)
1010    CONTINUE
      ENDIF
C
&XXX      STOP 'XMOVE NOT IMPLEMENTED'
C
      RETURN
      END
CODE FOR XMOVEI
      SUBROUTINE XMOVEI ( ISRCE , IRESLT , N )
C
C -- MOVES REALS, INTEGERS OR HOLERITHS FROM 'ISRCE'
C    TO 'IRESLT' WITHOUT TYPE CHECKING OR CONVERSION.
C
C -- MOVE N WORDS FROM 'ISRCE' TO 'IRESLT' . DIRECT FORTRAN WILL
C    FAIL IF TWO OVERLAPPING ARRAYS ARE INVOLVED UNLESS THE
C    SENSE OF THE MOVE CAN BE DETERMINED.
C
      DIMENSION ISRCE(N) , IRESLT(N)
C
&PPCC -- USE MOTO FORTRAN BUILT-IN FUNCTIONS TO FIND THE DIRECTION THE
&PPCC    DATA WILL BE MOVED
&PPC      I = %LOC ( ISRCE(1) )
&PPC      J = %LOC ( IRESLT(1) )
C
&VAXC -- USE VAX FORTRAN BUILT-IN FUNCTIONS TO FIND THE DIRECTION THE
&VAXC    DATA WILL BE MOVED
&VAX      I = %LOC ( ISRCE(1) )
&VAX      J = %LOC ( IRESLT(1) )
C
&DGVC -- USE D.G. SPECIFIC FORTRAN FUNCTIONS TO FIND THE DIRECTION THE
&DGVC    DATA WILL BE MOVED
&DGV      I = WORDADDR ( ISRCE(1) )
&DGV      J = WORDADDR ( IRESLT(1) )
C
&IBMC -- USE IBM  MACHINE CODE TO FIND THE DIRECTION THE
&IBMC    DATA WILL BE MOVED
&IBM      I = KLOCN ( ISRCE(1) )
&IBM      J = KLOCN ( IRESLT(1) )
C
&H-PC---- USE HEWLET PACKARD 'C' CODE TO FIND DIRECTION
&H-P      I = LOC ( ISRCE(1))
&H-P      J = LOC ( IRESLT(1))
C
&DOS      I = LOC ( ISRCE(1))
&DOS      J = LOC ( IRESLT(1))
C
&&DVFGID      I = LOC ( ISRCE(1))
&&DVFGID      J = LOC ( IRESLT(1))
&&LINGIL      I = LOC ( ISRCE(1))
&&LINGIL      J = LOC ( IRESLT(1))
&WXS      I = LOC ( ISRCE(1))
&WXS      J = LOC ( IRESLT(1))
C
&&DVFGID      I = LOC ( ISRCE(1))
&&DVFGID      J = LOC ( IRESLT(1))
&&LINGIL      I = LOC ( ISRCE(1))
&&LINGIL      J = LOC ( IRESLT(1))
&WXS      I = LOC ( ISRCE(1))
&WXS      J = LOC ( IRESLT(1))
C
&UNX      I = LOC ( ISRCE(1))
&UNX      J = LOC ( IRESLT(1))
C
      IF ( I .LT. J ) THEN
        DO 1000 I = N , 1 , -1
          IRESLT(I) = ISRCE(I)
1000    CONTINUE
      ELSE
        DO 1010 I = 1 , N
          IRESLT(I) = ISRCE(I)
1010    CONTINUE
      ENDIF
C
&XXX      STOP 'XMOVEI NOT IMPLEMENTED'
C
      RETURN
      END
C
C
CODE FOR XPAUSE
      SUBROUTINE XPAUSE ( INTERV )
C
C -- A GENERAL INTERVAL TIMER. THIS ROUTINE WAITS FOR THE SPECIFIED
C    TIME AND THEN RETURNS
C
C    'INTERV' IS THE TIME INTERVAL REQUIRED IN MILLISECONDS
C
C    THIS ROUTINE IS USED BY THE 'PAUSE' SYSTEM INSTRUCTION AND
C    THE PROGRAM 'CRYSPY'. IT IS NOT ESSENTIAL TO THE OPERATION OF THE
C    PROGRAM, AND COULD BE REPLACED BY A DUMMY, EXCEPT THAT THE 'PAUSE'
C    INSTRUCTION WOULD NO LONGER WORK.
C
&&DVFGID      USE DFPORT
C
\XUNITS
\XSSVAL
C
C
&VAX      DIMENSION ITIMVL(2)
&VAX      INTEGER SYS$SETIMR , SYS$WAITFR
&VAX      DATA ICONFC / -10000 /
C
C
      IF ( INTERV .LE. 0 ) RETURN
C
&VAXC    THE TECHNIQUE USED FOR THIS TIMER IN VAX SYSTEMS IS :-
&VAXC
&VAXC      1 ) CONVERT TIME VALUE TO INTERNAL DELTA TIME FORMAT ( I.E.
&VAXC      NEGATIVE NUMBER OF 100 NANOSECOND UNITS REQUIRED )
&VAXC      2 ) SET TIMER WITH THIS VALUE
&VAXC      3 ) WAIT FOR EVENT FLAG INDICATING THAT INTERVAL HAS ELAPSED
&VAXC
&VAXC -- USE RUN TIME LIBRARY TO CALCULATE QUADWORD TIME VALUE
&VAXC
&VAX      CALL LIB$EMUL ( INTERV , ICONFC , 0 , ITIMVL(1) )
&VAX      ISTAT = SYS$SETIMR ( , ITIMVL(1) , , )
&VAX      IF ( ISTAT .NE. 1 ) GO TO 9900
&VAX      ISTAT = SYS$WAITFR  ( %VAL(0) )
&VAX      IF ( ISTAT .NE. 1 ) GO TO 9900
&VAX      RETURN
&VAX9900  CONTINUE
&VAX      CALL LIB$STOP ( %VAL(ISTAT) )
C
&DOSC     DOS TIMES ARE IN SECONDS
&DOS      TIME = FLOAT(INTERV) *.001
&DOS      CALL SLEEP@ ( TIME)
&&DVFGID        KTIME = FLOAT(INTERV) *.001
&&DVFGID        CALL SLEEP (KTIME)
C
&PRIC
&PRI      CALL SLEEP$ ( INTERV )
&PRIC
C
&DGV      PARAMETER ( ISYS_WDELAY = 263K )
&DGV      IAC0 = INTERV
&DGV      IAC1 = 0
&DGV      IAC2 = 0
&DGV      IER = ISYS ( ISYS_WDELAY , IAC0 , IAC1 , IAC2 )
C
      RETURN
      END
C
CODE FOR KFLCHR
      FUNCTION KFLCHR ( IUNIT )
C -- THIS ROUTINE RETURNS A VALUE INDICATING WHETHER THE FILE ON UNIT
C    'IUNIT' IS CAPABLE OF INTERACTIVE USE.
C
C      RETURN VALUES :-
C      0      UNKNOWN
C      1      TERMINAL ( INTERACTIVE DEVICE )
C      2      DISK FILE
C
C      ***** MACHINE SPECIFIC *****
C
C -- POSSIBLE REPLACEMENT FOR THE VAX/VMS CODE IN THIS ROUTINE :-
C
C    RETURN THE VALUE '1' WHEN THE UNIT NUMBER IS THAT CHOSEN FOR
C    THE MAIN CONTROL FILE, AND THE MODE IS 'INTERACTIVE'
C    OTHERWISE RETURN THE VALUE '2'. THIS SHOULD GIVE ACCEPTABLE
C    PERFORMANCE.
C
C
C
      IMPLICIT INTEGER ( D , S )
      CHARACTER*63 FNAME
C
C
\UFILE
\XUNITS
\XSSVAL
C
&VAX      PARAMETER ( DC$_DISK = '00000001'X )
&VAX      PARAMETER ( DC$_TERM = '00000042'X )
&VAX      PARAMETER ( DVI$_DEVCLASS = 4 )
&VAX      INTEGER*2 WREQ(8)
&VAX      INTEGER*4 LREQ(4)
&VAX      EQUIVALENCE ( WREQ(1) , LREQ(1) )
&VAX      DATA WREQ(1) / 4 /
&VAX      DATA WREQ(2) / DVI$_DEVCLASS /
&VAX      DATA LREQ(2) / 0 /
&VAX      DATA LREQ(3) / 0 /
&VAX      DATA LREQ(4) / 0 /
&VAX      LREQ(2) = %LOC ( ICLASS )
C
      KFLCHR = 0
C
&VAXC
&VAX      I = KFLNAM ( IUNIT , FNAME )
&VAX      IF ( I .LE. 0 ) RETURN
&VAXC
&VAX      ISTAT = SYS$GETDVI ( , , FNAME , WREQ , , , , )
&VAXC
&VAX      IF ( ISTAT ) THEN
&VAX        IF ( ICLASS .EQ. DC$_TERM ) KFLCHR = 1
&VAX        IF ( ICLASS .EQ. DC$_DISK ) KFLCHR = 2
&VAX      ELSE
&VAXC -- WE ASSUME ERRORS WILL ONLY OCCUR WITH NETWORK FILES, IN WHICH
&VAXC    WE ARE USING A FILE
&VAX        KFLCHR = 2
&VAX      ENDIF
C
#VAX      KFLCHR = 2
#VAX      IF ( IUNIT .NE. NCUFU(1) ) GO TO 9000
#VAX      IF ( IQUN .NE. JQUN ) GO TO 9000
#VAX      KFLCHR = 1
C
C
9000  CONTINUE
      RETURN
      END
C
CODE FOR XDETCH
      SUBROUTINE XDETCH ( COMMND )
&&DVFGID      USE DFPORT
C
C -- THIS SUBROUTINE EXECUTES A SYSTEM COMMAND IN A SEPARATE PROCESS.
C
C -- THIS ROUTINE IS ONLY REQUIRED BY THE 'FOREIGN PROGRAM LINK'
C    ROUTINES, WHICH ARE NOT ESSENTIAL TO THE PROPER OPERATION OF
C    THE PROGRAM. IT WOULD BE SUFFICIENT TO REPLACE THIS ROUTINE WITH
C    A DUMMY THAT IMMEDIATELY RETURNS CONTROL.
C
&VAXC
&VAXC -- ON THE VAX, THIS FUNCTION IS IMPLEMENTED USING THE 'SPAWN'
&VAXC    FACILITY, ACCESSED VIA THE RUN-TIME LIBRARY ENTRY-POINT
&VAXC    'LIB$SPAWN'. BEFORE THE SUBPROCESS IS CREATED, THE WORKING SET
&VAXC    OF THE PARENT IS 'PURGED' USING THE '$PURGWS' SYSTEM SERVICE
&VAXC    TO REDUCE PHYSICAL MEMORY USAGE.
&VAXC
C
C
      IMPLICIT INTEGER ( S )
&H-P      INTEGER SYSTEM
C
      DIMENSION ILIMIT(2)
C
      CHARACTER*(*) COMMND
      CHARACTER*256 ACTUAL
      CHARACTER*256 CTEMP
C
\XUNITS
\XIOBUF
\XSSVAL
C
&VAX      DATA ILIMIT(1) / 0 / , ILIMIT(2) / '7FFFFFFF'X /

C Pick out each word in COMMND (space separated) and pass it to MTRNLG,
C to check for environment labels.
C Add the returned string onto ACTUAL.
C ICS keeps track of position in COMMND, and ICA the position in ACTUAL

C Find last non-space.
#VAX      ICL = KCLNEQ ( COMMND, -1, ' ' )
#VAX      ICS = 1
#VAX      IAS = 1
#VAX      DO WHILE ( .TRUE. )
C Find next non-space.
#VAX         ICS = KCCNEQ ( COMMND, ICS, ' ' )
#VAX         IF ( ICS .LE. 0 ) GOTO 35
#VAX         IF ( COMMND(ICS:ICS) .EQ. '"' ) THEN !Find end quote
#VAX            ICE = KCCEQL ( COMMND, ICS+1, '"')
#VAX            IF (ICE.LE.0) THEN     !Handle unpaired quote.
#VAX              COMMND (ICS:ICS) = ' '
#VAX              ICS = ICS + 1
#VAX              ICE = KCCEQL ( COMMND, ICS, ' ' )
#VAX            END IF
#VAX            ICS = MAX(1,ICS)
#VAX            ICE = MAX(ICE,ICS+2)
#VAX            CTEMP = COMMND(ICS+1:ICE-1)
#VAX            ICS = ICE + 1
#VAX            CALL MTRNLG(CTEMP,'UNKNOWN',ILENG)
#VAX            ITM = KCLNEQ( CTEMP, -1, ' ' )
#VAX            IF (ITM.LE.0) GOTO 35
#VAX            ACTUAL (IAS:) = '"' // CTEMP(1:ITM) // '"'
#VAX            IF ( ICS.GT.ICL ) GOTO 35
#VAX            IAS = IAS + ITM + 3
#VAX         ELSE                         !Find end space
#VAX            ICE = KCCEQL ( COMMND, ICS, ' ' )
#VAX            IF (ICE.LE.0) GOTO 35
#VAX            CTEMP = COMMND(ICS:ICE-1)
#VAX            ICS = ICE + 1
#VAX            CALL MTRNLG(CTEMP,'UNKNOWN',ILENG)
#VAX            ITM = KCLNEQ( CTEMP, -1, ' ' )
#VAX            IF (ITM.LE.0) GOTO 35
#VAX            ACTUAL (IAS:) = CTEMP(1:ITM)
#VAX            IF ( ICS.GT.ICL ) GOTO 35
#VAX            IAS = IAS + ITM + 1
#VAX         END IF
#VAX      END DO
#VAX35    CONTINUE
#VAX      COMMND = ACTUAL

&VAX      ISTAT = SYS$PURGWS ( ILIMIT )
&VAX      IF ( .NOT. ISTAT ) CALL LIB$SIGNAL ( %VAL(ISTAT) )
&VAXC
C----- LOOK FOR A PURE VMS COMMAND
&VAX      IF (  (INDEX ( COMMND, '@')) .EQ. 0) THEN
&VAX       ISTAT = LIB$SPAWN (  '@CRPROC:SPAWNCMD  "'//COMMND//'" ' ,
&VAX     1 'SYS$COMMAND' , 'SYS$ERROR' )
&VAX      ELSE
&VAX       ISTAT = LIB$SPAWN ( COMMND , 'SYS$COMMAND' , 'SYS$ERROR' )
&VAX      ENDIF
&VAX      IF ( .NOT. ISTAT ) CALL LIB$SIGNAL ( %VAL(ISTAT) )
C
&DGV      INTEGER PLTH , SNDLTH
&DGVC
&DGV      PARAMETER ( PLTH = 32 , SNDLTH = 8 )
&DGV      PARAMETER ( ISYS_PROC = 326K )
&DGV      PARAMETER ( ISYS_PFEX = 20000K )
&DGVC
&DGV      INTEGER*2 IPACKT(0:PLTH-1) , ISEND(0:SNDLTH-1)
&DGVC
&DGV      CHARACTER*256 TEMPORARY_CMMND
&DGVC
&DGV      EQUIVALENCE ( ADDRESS_OF_PROGRAM_NAME , IPACKT(2) )
&DGV      EQUIVALENCE ( ADDRESS_OF_MESSAGE_HEADER , IPACKT(4) )
&DGV      EQUIVALENCE ( ADDRESS_OF_COMMAND_STRING , ISEND(6) )
&DGVC
&DGV      SAVE IPACKT , ISEND
&DGVC
&DGV      DATA IPACKT / 32 * -1 /
&DGV      DATA ISEND / 8 * 0 /
&DGVC
&DGV      TEMPORARY_CMMND = COMMND
&DGVC
&DGV      ISEND(5) = 128
&DGV      ADDRESS_OF_COMMAND_STRING = WORDADDR ( TEMPORARY_CMMND )
&DGVC
&DGVC -- SET PFEX BIT. CLI WILL EXECUTE WITH FATHER BLOCKED
&DGVC
&DGV      IPACKT(0) = ISYS_PFEX
&DGV      ADDRESS_OF_PROGRAM_NAME = BYTEADDR ( ':CLI.PR<0>' )
&DGV      ADDRESS_OF_MESSAGE_HEADER = WORDADDR ( ISEND(0) )
&DGVC
&DGV      IAC2 = WORDADDR ( IPACKT )
&DGVC
&DGV      IER = ISYS ( ISYS_PROC , IAC0 , IAC1 , IAC2 )
&DGVC
C
&H-P                                       WRITE ( NCAWU , 1000 )
&H-P                                       j=system('sh')
&H-P1000  FORMAT (1X,'To go back in CRYSTALS environment',
&H-P     1 ' strike CTRL-d',/)
&H-P1005  FORMAT ( 1X , 'The following command line cannot be ' ,
&H-P     2 'executed in this implementation' , / ,
&H-P     3 1X , A , / )
&H-PC
C
&DOS      CALL CISSUE (COMMND, IFAIL)
&DOS      IF (IFAIL .EQ. 0) RETURN

&&&GIDGILWXS      CALL GDETCH(COMMND)
&&&GIDGILWXS      RETURN
&DVF      IFAIL = SYSTEM(COMMND)
&DVF      IF (IFAIL .EQ. 0 ) RETURN
&LIN      CALL SYSTEM(COMMND,IFAIL)
&LIN      IF (IFAIL .EQ. 0 ) RETURN

C
&XXX      IF (ISSPRT .EQ. 0) THEN
&XXX      WRITE ( NCWU , 1005 ) COMMND
&XXX      ENDIF
&XXX      WRITE ( NCAWU , 1005 ) COMMND
&XXX1005  FORMAT ( 1X , 'The following command line cannot be ' ,
&XXX     2 'executed in this implementation' , / ,
&XXX     3 1X , A , / )
C
      RETURN
      END
C
CODE FOR STCTLC
      SUBROUTINE STCTLC
C
C -- THIS ROUTINE SETS UP CONTROL-C HANDLING FOR CRYSTALS. ( VAX ONLY )
C
C    THIS ROUTINE IS NOT REQUIRED FOR THE OPERATION OF THE PROGRAM,AND
C    CAN BE REPLACED BY A DUMMY.
C
C -- IN THE VAX IMPLEMENTATION THIS ROUTINE TOGETHER WITH
C    'EXCTLC' AND 'XOUTPT' FORM A SUBSYSTEM ALLOWING THE USER TO
C    PERFORM CERTAIN OPERATIONS, SUCH A CREATING A SUBPROCESS,
C    ASYNCHRONOUSLY.
C
&VAXC -- CONTROL-C HANDLING FOR CRYSTALS ( VAX IMPLEMENTATION ONLY )
&VAXC
&VAXC    CONTROL-C PROCESSING UNDER VMS IS IMPLEMENTED BY MEANS OF THE
&VAXC    AST ( ASYNCHRONOUS SYSTEM TRAP ) MECHANISM. AN I/O REQUEST IS
&VAXC    SENT TO THE TERMINAL DRIVER REQUESTING THAT IF THE USER TYPES
&VAXC    CONTROL-C ON THE TERMINAL, CONTROL IS PASSED TO A SPECIFIED
&VAXC    ROUTINE. WHEN THIS ROUTINE HAS COMPLETED, THE CONTROL-C TRAP
&VAXC    CAN BE REENABLED, AND PROGRAM EXECUTION THEN CONTINUES. THE
&VAXC    OPERATION REQUIRES A MINIMUM OF TWO ROUTINES:- 'STCTLC' WHICH
&VAXC    SETS THE CONTROL-C TRAP INITIALLY AND RE-SETS IT EACH TIME IT
&VAXC    IS 'SPRUNG', AND 'EXCTLC' WHICH IS THE ROUTINE CALLED WHEN THE
&VAXC    CONTROL-C AST IS DELIVERED.
&VAXC
&VAXC    SINCE CONTROL-C HANDLING IS ASYNCHRONOUS, THE PROGRAM MAY BE
&VAXC    IN ANY STATE WHEN 'EXCTLC' IS CALLED. THIS MEANS THAT CHANGES
&VAXC    TO DATA AVAILABLE TO THE REST TO THE PROGRAM MUST BE MADE VERY
&VAXC    CAREFULLY, AND ALSO THAT THE NORMAL FORTRAN I/O SYSTEM CANNOT
&VAXC    BE USED SAFELY. FOR THIS REASON, THE ROUTINE 'XOUTPT' IS USED
&VAXC    TO PROVIDE FOR OUTPUT OF TEXT TO THE TERMINAL BY DIRECT QIO
&VAXC    CALLS. SIMILARLY 'LIB$GET_COMMAND' IS USED FOR INPUT.
&VAXC
&VAXC
&VAX      IMPLICIT INTEGER ( A - Z )
&VAXC
&VAX      INTEGER*2 ITTCHN
&VAXC
&VAX      COMMON / CONTROLC_DATA / ITTCHN
&VAXC
\XUNITS
&VAXC -- EXTERNALS ARE AST ADDRESS, FUNCTION SPECIFIER,
&VAXC    AND FUNCTION MODIFIER
&VAX      EXTERNAL EXCTLC
&VAX      EXTERNAL IO$_SETMODE , IO$M_CTRLCAST
&VAXC
&VAX      DATA ITTCHN / 0 /
&VAXC
&VAXC -- ONLY ENABLED IN INTERACTIVE MODE
&VAXC
&VAX      IF ( IQUN .EQ. JQUN ) THEN
&VAXC
&VAXC -- GET IO FUNCTION AND AST ADDRESS
&VAX        ISETFN = %LOC(IO$_SETMODE) + %LOC(IO$M_CTRLCAST)
&VAX        IAST = %LOC (EXCTLC)
&VAXC
&VAXC -- ASSIGN CHANNEL TO TERMINAL IF NOT ALREADY DONE
&VAX        IF ( ITTCHN .EQ. 0 ) THEN
&VAX              CALL SYS$ASSIGN ( 'TT' , ITTCHN , , )
&VAX        ENDIF
&VAXC
&VAXC -- QUEUE IO REQUEST
&VAX        ISTAT = SYS$QIOW ( , %VAL(ITTCHN) , %VAL(ISETFN) , , , ,
&VAX     1 %VAL(IAST) , , %VAL(3) , , , )
&VAXC
&VAX      ENDIF
C
      RETURN
      END
C
&VAXCODE FOR EXCTLC
&VAX      SUBROUTINE EXCTLC
&VAXC
&VAXC -- THIS ROUTINE HANDLES CONTROL-C INTERRUPTS ( VAX ONLY )
&VAXC
&VAXC    THIS ROUTINE IS NOT REQUIRED FOR THE OPERATION OF THE PROGRAM,AND
&VAXC    CAN BE REPLACED BY A DUMMY.
&VAXC
&VAXC -- FOR A DESCRIPTION OF CONTROL-C HANDLING SEE THE
&VAXC    ROUTINE 'STCTLC'
&VAXC
&VAX      IMPLICIT INTEGER ( A - Z )
&VAXC
&VAX      CHARACTER*1 IOPTCH
&VAXC
&VAX      DIMENSION ILIMIT(2)
&VAXC
&VAXC
&VAX\XUNITS
&VAX\XSSVAL
&VAXC
&VAXC -- WORKING SET LIMITS ARE PURGED BEFORE 'SPAWN'
&VAX      DATA ILIMIT(1) / 0 / , ILIMIT(2) / '7FFFFFFF'X /
&VAXC
&VAX1000  CONTINUE
&VAXC
&VAXC -- READ COMMAND AND CONVERT TO UPPERCASE
&VAX      CALL LIB$GET_COMMAND ( IOPTCH , 'Select break-in option : ' )
&VAXC
&VAX      CALL STR$UPCASE ( IOPTCH , IOPTCH )
&VAXC
&VAXC -- EXECUTE COMMAND ( SEE 'H' FOR DESCRIPTION OF COMAMNDS )
&VAX      IF ( IOPTCH .EQ. ' ' ) THEN
&VAX      ELSE IF ( IOPTCH .EQ. 'C' ) THEN
&VAX        CALL STCTLC
&VAX        RETURN
&VAX      ELSE IF ( IOPTCH .EQ. 'H' ) THEN
&VAX        CALL XOUTPT ( 'Select one of the following options :-')
&VAX        CALL XOUTPT ( 'C    Continue program execution' )
&VAX        CALL XOUTPT ( 'H    Display this help text' )
&VAX        CALL XOUTPT ( 'Q    Abandon current instruction at'//
&VAX     2 ' suitable point' )
&VAX        CALL XOUTPT ( 'S    Spawn a subprocess' )
&VAX        CALL XOUTPT ( 'T    Generate traceback' )
&VAX      ELSE IF ( IOPTCH .EQ. 'Q' ) THEN
&VAXC -- SET ERROR FLAG
&VAX        IERFLG = -1
&VAX        CALL STCTLC
&VAX        RETURN
&VAX      ELSE IF ( IOPTCH .EQ. 'S' ) THEN
&VAX        CALL LIB$DELETE_LOGICAL ( 'SYS$INPUT' )
&VAX        CALL SYS$PURGWS ( ILIMIT )
&VAX        CALL XOUTPT ( 'Creating spawned subprocess' )
&VAX        CALL LIB$SPAWN ( 'DEASSIGN SYS$OUTPUT' ,
&VAX     1 'SYS$COMMAND' , 'SYS$ERROR' )
&VAX      ELSE IF ( IOPTCH .EQ. 'T' ) THEN
&VAX        CALL LIB$SIGNAL ( %VAL(0) )
&VAX      ELSE
&VAX        CALL XOUTPT ( 'Illegal break-in option - Type H for help' )
&VAX      ENDIF
&VAXC
&VAX      GO TO 1000
C
C
&VAX      END
C
&VAXCODE FOR XOUTPT
&VAX      SUBROUTINE XOUTPT ( TEXT )
C
C -- THIS ROUTINE OUTPUTS TEXT FOR CONTROL-C HANDLING ( VAX ONLY )
C
C    THIS ROUTINE IS NOT REQUIRED FOR THE OPERATION OF THE PROGRAM,AND
C    CAN BE REPLACED BY A DUMMY.
C
&VAXC -- FOR A DESCRIPTION OF CONTROL-C HANDLING SEE THE
&VAXC    ROUTINE 'STCTLC'
&VAXC
&VAX      IMPLICIT INTEGER ( A - Z )
&VAXC
&VAX      CHARACTER*(*) TEXT
&VAXC
&VAX      INTEGER*2 ICHAN
&VAXC
&VAX      COMMON / CONTROLC_DATA / ICHAN
&VAXC
&VAXC -- I/O REQUEST CODE
&VAX      EXTERNAL IO$_WRITEVBLK
&VAXC
&VAXC
&VAX      IOUTFN = %LOC ( IO$_WRITEVBLK )
&VAX      LENGTH = LEN ( TEXT )
&VAXC
&VAX      ISTAT = SYS$QIOW ( , %VAL(ICHAN) , %VAL(IOUTFN) ,
&VAX     2                   ,             ,              ,
&VAX     3        %REF(TEXT) , %VAL(LENGTH) , %VAL(0)     ,
&VAX     4          %VAL(32) ,             ,              )
&VAX      IF ( .NOT. ISTAT ) CALL LIB$SIGNAL ( %VAL(ISTAT) )
&VAXC
C
&VAX      RETURN
&VAX      END
C
CODE FOR XMNINI
      SUBROUTINE XMNINI (JMNFLG)
C
C----- INITIALISE THE MENU VARIABLES, CREATE PASTEBOARD, VIRTUAL
C      DISPLAY AND VIRTUAL KEYBOARD FOR DEC VTn SERIES TERMINALS
C      THIS SUBROUTINE IS ACTIONED BY #SET TERM, IN KSCSCT
C
C----  JMNFLG   0 IF MENU NOT INITIALISED
C
C      IPB      PASTE BOARD ID
C      IVD      VIRTUAL DISPLAY ID
C      NPBR     NO. LINES IN PASTE BOARD
C      NPBCOL   NO. COLUMNS IN PASTE BOARD
C      MNILMX   MAXIMUM MENU ITEM LENGTH, = LCHK
C      MNIDMX   MAXIMUM NO OF MENU ITEMS, = NCHK
C      IIS      INTER ITEM SPACE
C      MNISL    LENGTH OF ITEM + SPACES
C      IFRML    ADDRESS OF FRAME LEFT MARGIN
C      IFRMR    ADDRESS OF FRAME RIGHT MARGIN
C      ITXTL    ADDRESS OF TEXT LEFT MARGIN
C      ITXTR    ADDRESS OF TEXT RIGHT MARGIN
C      NTXTW    AVAILABLE TEXT WIDTH
C      MNIPL    MAX NO. MENU ITEMS PER LINE
C      MNWID    MAXIMUM MENU WIDTH
C      MNLIP    LAST ITEM POSITION ON LINE
C      IAMAMX   MAXIMUM ABSOLUTE MENU ADDRESS (VIRTUAL COLUMNS)
C      MNLIMX   MAXIMUM NO LINES IN MENU
C      ITXTC    CENRE OF TEXT AREA
C      MXMNA    MAXIMUM MENU AREA (ITEMS)
C
C----- REMEMBER - PAST BOARD ADDRESSES ARE ABSOLUTE SCREEN ADDRESSES
C      VIRTUAL DISPLAY ADDRESSES ARE RELATIVE TO ORIGIN (1,1) OF V-D
&VAX      INTEGER
&VAX     1 SMG$CREATE_PASTEBOARD ,
&VAX     1 SMG$CREATE_VIRTUAL_DISPLAY ,
&VAX     1 SMG$CREATE_VIRTUAL_KEYBOARD ,
&VAX     1 SMG$PASTE_VIRTUAL_DISPLAY ,
&VAX     1 SMG$SET_PHYSICAL_CURSOR,
&VAX     1 SMG$PUT_CHARS
&VAX      INCLUDE '($SMGDEF)'
C
#PPC      PARAMETER (IIS = 4)
\XSCCHK
\XSSVAL
C
\XMENUC
C
\XMENUI
C
      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) RETURN
C----- HAVE WE BEEN HERE BEFORE?
      IF (IMNFLG .NE. 0) THEN
        JMNFLG = IMNFLG
        RETURN
      ENDIF
C
C----- SET SOME CHARACTER VARIABLES
      CLSTNM = ' '
      CPRVNM = ' '
      CSPACE = ' '
C
      MNILMX = LCHK
      MNIDMX = NCHK
      MNISL = MNILMX + IIS
&VAX      ISMG = SMG$CREATE_PASTEBOARD (IPB, 'TT:', NPBR, NPBCOL)
      NPBCOL = MIN ( LTERMW, NPBCOL)
C
      IFRML = 1
      IFRMR = NPBCOL - 1
      ITXTL = IFRML + 1
      ITXTR = IFRMR - 1
      NTXTW = ITXTR - ITXTL + 1
      ITXTC = (ITXTL + ITXTR) / 2
C
      MNIPL = (NTXTW + IIS)/ MNISL
      MNWID = MNIPL * MNISL
      MNLIP = MNWID - MNISL +1
C----- FIND NO. OF LINES IN  BIGGEST POSSIBLE MENU
      CALL XMNCR( MNIDMX, MNLIMX, I, MNISL, MNWID)
      MXMNA = MNLIMX * MNIPL
C
      CALL XMNADD ( MNLIMX)
C
&VAX      ISMG = SMG$CREATE_VIRTUAL_DISPLAY (NLNFR, NPBCOL, IVD)
&VAX      ISMG = SMG$CREATE_VIRTUAL_KEYBOARD (IKB, 'TT:' )
&VAX      ISMG = SMG$PASTE_VIRTUAL_DISPLAY (IVD, IPB, NPBR - NLNFR, 1)
&VAX      ISMG = SMG$SET_PHYSICAL_CURSOR (IPB, NPBR, 1)
C
C----- INDICATE INITIALISATION COMPLETE
      IMNFLG = 1
      JMNFLG = IMNFLG
      RETURN
      END
C
CODE FOR XMNPMC
      SUBROUTINE XMNPMC (IVD, CITEM, IROW, ICOL, IOFSET)
C
C      INSERT A MENU ITEM AT SPECIFIED ROW, COLUMN AND ROW OFFSET
C
&PPCC**** This routine is a dummy for the MacOS
&VAX      INCLUDE '($SMGDEF)'
&VAX      INTEGER SMG$PUT_CHARS
#PPC      CHARACTER *(*) CITEM
&VAX      ISMG = SMG$PUT_CHARS (IVD, CITEM, IROW+IOFSET-1, ICOL+1)
      RETURN
      END
C
C
CODE FOR XMNINV
      SUBROUTINE XMNINV ( COLD, IOROW, IOCOL, CNEW, INROW, INCOL,
     1 MNISL, CDUM, IVD, IOFSET)
C----- RESTORE OLD ITEM TO NORMAL, HIGHLIGHT NEW
C
&VAX      INCLUDE '($SMGDEF)'
&VAX      INTEGER SMG$PUT_CHARS
&PPCC**** This routine is a dummy for the MacOS
      CHARACTER *(*) COLD, CNEW, CDUM
\XSSVAL
C
      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) RETURN
&VAX      ISMG = SMG$PUT_CHARS (IVD, COLD, IOROW+IOFSET-1, IOCOL+1 )
      CDUM = CNEW
&VAXC----- FOR VT52, INSERT A *
&VAX      IF (ISSTML .EQ. 1) CDUM = '*' // CNEW(1:MNISL-1)
&VAX      ISMG = SMG$PUT_CHARS (IVD, CDUM, INROW+IOFSET-1, INCOL+1, ,
&VAX     1       SMG$M_REVERSE)
      RETURN
      END
C
CODE FOR XMENUR
      SUBROUTINE XMENUR (CPRMPT, MENPMT, CLINPB, LENLIN,
     1 CDEFLT, LDEFBF, IINPLN)
C
C----- DRAW A MENU BOX AND RETURN USERS SELECTION
C
&VAX      INCLUDE '($SMGDEF)'
&VAX      INTEGER
&VAX     1  SMG$PUT_CHARS ,
&VAX     1  SMG$DRAW_RECTANGLE ,
&VAX     1  SMG$SET_PHYSICAL_CURSOR ,
&VAX     1  SMG$READ_KEYSTROKE ,
&VAX     1  STR$TRIM
C
      CHARACTER *(*) CDEFLT
      CHARACTER *(*) CLINPB
      CHARACTER *(*) CPRMPT
\XUNITS
\XSSVAL
C
\XSCCNT
\XSCCHK
C
\XMENUC
\XMENUI
\XIOBUF
C
C
CRIC02      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) RETURN
C----- FIND NO LINES IN CURRENT MENU
      CALL XMNCR (NCHKUS, MNLICM, I, MNISL, MNWID)
C      FIND THE LINE AND COLUMN ADDRESSES
      CALL XMNADD ( MNLICM)
C
C----- PUSH PLAIN TEXT UP TO MAKE ROOM FOR MENU
&VAX      DO  I = 1, NLNFR + 3
&VAX      WRITE( NCAWU, '(1X)')
&VAX      END DO
C
cC----- RECOVER SCRIPT NAME
c      ISTAT = KSCIDN (2, 3, 'SCRIPTNAME', 1, IS, IDSCP, ISCPNM, 1)
c      ISTAT = KSCSDC ( ISCPNM, CSCPNM, LENNM)
c      IF (CSCPNM .NE. CLSTNM) CPRVNM = CLSTNM
c      CLSTNM = CSCPNM(1:LENNM)
c
c&&&GILGIDWXS          WRITE(CMON(1),'(A)')
c&&&GILGIDWXS     1 '^^WI SET PROGOUTPUT TEXT = '
c&&&GILGIDWXS      IF ( CPRVNM(1:3) .NE. CSPACE(1:3) ) THEN
c&&&GILGIDWXS         WRITE(CMON(2),'(5A)')
c&&&GILGIDWXS     1'^^WI ''Script: ',CSCPNM(1:LENNM),
c&&&GILGIDWXS     1   ' called from:', CPRVNM, ''''
c&&&GILGIDWXS      ELSE
c&&&GILGIDWXS         WRITE(CMON(2),'(3A)')'^^WI ''Script: ',
c&&&GILGIDWXS     1  CSCPNM(1:LENNM), ''''
c&&&GILGIDWXS      ENDIF
c&&&GILGIDWXS          WRITE(CMON(3),'(A)') '^^CR'
c&&&GILGIDWXS      CALL XPRVDU(NCVDU,3,0)

      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) RETURN

C----- FIND THE DEFAULT MENU ITEM
      IDEF = 1
      DO 300 I = 1, NCHKUS
            IF( CDEFLT .EQ. CCHECK(I)) IDEF = I
300   CONTINUE
C
C---- FIND THE MENU ADDRESSES FOR THE DEFAULT, NEW, AND OLD ITEMS
      CALL XMNCR ( IDEF, INROW,  INCOL, MNISL, MNWID)
      INEW = IDEF
      IOLD = IDEF
      IOCOL = INCOL
      IOROW = INROW
C
C----- SET UP THE PICTURE FRAME
C      CLEAR THE SIDES
&VAX      DO 400 I = NTPFR, NBFR - 1
&VAX        ISMG = SMG$PUT_CHARS ( IVD, ' ', I, IFRML)
&VAX        ISMG = SMG$PUT_CHARS ( IVD, ' ', I, IFRMR)
&VAX400   CONTINUE
C      AND TOP AND BOTTOM
&VAX       ISMG = SMG$PUT_CHARS ( IVD, CSPACE, NTPFR, IFRML)
&VAX       ISMG = SMG$PUT_CHARS ( IVD, CSPACE, NBFR, IFRML)
C
&VAX      ISMG = SMG$DRAW_RECTANGLE (IVD, NTPFR, IFRML, NBFR, IFRMR)
C
C----- CLEAR THE MESSAGE AREAS
&VAX      ISMG = SMG$PUT_CHARS (IVD, CSPACE(1:NTXTW), NSCPPR, ITXTL)
&VAX      ISMG = SMG$PUT_CHARS (IVD, CSPACE(1:NTXTW), NBL1, ITXTL)
&VAX      ISMG = SMG$PUT_CHARS (IVD, CSPACE(1:NTXTW), NBL2, ITXTL)
&VAX      ISMG = SMG$PUT_CHARS (IVD, CSPACE(1:NTXTW), NPRMPT, ITXTL)
C
C----- INSERT THE SCRIPT NAMES
&VAX      ISMG = SMG$PUT_CHARS (IVD, 'Current SCRIPT is', NSCPPR,
&VAX     1 ITXTL )
&VAX      ISMG = SMG$PUT_CHARS (IVD, CSCPNM, NSCPPR, ITXTL +17+2, ,
&VAX     1       SMG$M_BOLD)
&VAX      IF ( CPRVNM(1:3) .NE. CSPACE(1:3) ) THEN
&VAX      ISMG = SMG$PUT_CHARS (IVD, 'Previous SCRIPT was', NSCPPR,
&VAX     1  ITXTC)
&VAX      ISMG = SMG$PUT_CHARS (IVD, CPRVNM, NSCPPR, ITXTC +19+2,  ,
&VAX     1       SMG$M_BOLD)
&VAX      ENDIF
C
C----- NOW INSERT PROMPT
&VAX      ISMG = SMG$PUT_CHARS (IVD, CPRMPT(1:MENPMT), NPRMPT, ITXTL,,
&VAX     1       SMG$M_BOLD)
CC----- INSERT THE MENU ITEMS
C
      DO 500 J = 1, MNLICM * MNIPL
        CALL XMNCR( J, IROW, ICOL, MNISL, MNWID)
C----- BLANK OUT THE MENU AND RE-WRITE IT
        CALL XMNPMC (IVD, CSPACE(1:MNILMX), IROW, ICOL, NMENU1)
        IF ( J .LE. NCHKUS)
     1  CALL XMNPMC (IVD, CCHECK(J)(1:MNILMX), IROW, ICOL, NMENU1)
500   CONTINUE
C
C----- HIGHLIGHT THE DEFAULT
      CALL XMNINV ( CCHECK(IOLD)(:), IOROW, IOCOL,
     1              CCHECK(INEW)(:), INROW, INCOL,
     2              MNISL, CDUM, IVD, NMENU1)
C----- CLEAR THE OUTPUT BUFFER
      CLINPB = ' '
      J = 0
C----- SET REPLY MESSAGE LINE ADDRESS
      IMESR = NPRMPT + 1
C
C----- NOW LOOP TO GET THE USERS SELECTION
600   CONTINUE
#VAX      MNKEY = 13
&VAX      ISMG = SMG$READ_KEYSTROKE (IKB, MNKEY)
C
      IF (MNKEY .EQ. 274) THEN
C UP
            INROW = MAX0( 1, INROW-1)
C
      ELSE IF (MNKEY .EQ. 275) THEN
C DOWN
            INROW = MIN0( MNLICM, INROW+1)
C
      ELSE IF (MNKEY .EQ. 276) THEN
C LEFT
            INCOL = MAX0 (1, INCOL-MNISL)
C
      ELSE IF (MNKEY .EQ. 277) THEN
C RIGHT
            INCOL = MIN0 (INCOL+MNISL, MNLIP)
C
      ELSE IF (MNKEY .EQ. 13) THEN
C RETURN KEY
C
           IF ( J .NE. 0 ) THEN
C----- REMOVE TRAILING BLANKS AND RETURN THE ANSWER
              CALL XCTRIM ( CLINPB, IINPLN)
            ELSE
&VAX            ISTAT = STR$TRIM (CLINPB, CCHECK(INEW), IINPLN)
            ENDIF
C           RESTORE CURSOR
&VAX            ISMG = SMG$SET_PHYSICAL_CURSOR ( IPB, NPBR, 1)
            RETURN
      ELSE
C----- NOT A CURSOR KEY - ADD INTO BUFFER - BEWARE NON-ASCII KEYS
C-----      BACKSPACE OR DELETE
            IF ( (MNKEY .EQ. 8) .OR. (MNKEY .EQ. 127))THEN
C             COMPUTE MESSAGE ADDRESS
              IMESC = ITXTR - 20 + J
              CLINPB(J:J) = ' '
C             DISPLAY CHOICE
&VAX             ISMG = SMG$PUT_CHARS (IVD, CLINPB(J:J), IMESR,
&VAX     1       IMESC,, SMG$M_BOLD)
              IF (J .GE. 1) J = J - 1
            ELSE
              J = J + 1
C             COMPUTE MESSAGE ADDRESS
              IMESC = ITXTR - 20 + J
              CLINPB(J:J) = CHAR(MNKEY)
C             DISPLAY CHOICE
&VAX             ISMG = SMG$PUT_CHARS (IVD, CLINPB(J:J), IMESR,
&VAX     1       IMESC,, SMG$M_BOLD)
            ENDIF
            GOTO 600
      END IF
C
C----- COMPUTE THE MENU ITEM ID
      INEW = (INCOL/MNISL + (INROW-1)*MNIPL) + 1
      IF (INEW .GT. NCHKUS) THEN
C----- RECOMPUTE ADDRESS IF OVER THE TOP
            INEW = NCHKUS
            CALL XMNCR ( INEW, INROW,  INCOL, MNISL, MNWID)
      ENDIF
C----- HIGHLIGHT NEW CHOICE
      CALL XMNINV ( CCHECK(IOLD)(:), IOROW, IOCOL,
     1              CCHECK(INEW)(:), INROW, INCOL,
     2              MNISL, CDUM, IVD, NMENU1)
C
C----- PREPARE FOR NEW SELECTION
      IOCOL = INCOL
      IOROW = INROW
      IOLD = INEW
      GO TO 600
C
      END
C
CODE FOR MTRNLG
#PPC      SUBROUTINE MTRNLG(FILNAM,STATUS,LENNAM)
&PPC      SUBROUTINE MTRNLG(FILNAM,STATUS,LENNAM,IUNIT)
&&DVFGID      USE DFPORT
C
C----- EXPAND LOGICAL NAMES (ENVIRONMENT VARIABLES) IF THEY
C      ARE PART OG THE FILE NAME.
C
C      CODE BY MARTIN KRETSCHMAR, TUBINGEN, 1991
C
C FILNAM CONTAINS THE OLD FILE NAME AND WILL PASS BACK THE NEW ONE.
C
C STATUS IS THE THE WAY THE FILE IS INTENDED TO BE OPENED. IF SEARCH-
C LISTS LIKE THE VAX/VMS LOGICAL NAMES ARE TO BE EMULATED, IT IS
C IMPORTANT TO KNOW THIS.
C
C LENNAM USEFUL LENGTH OF FILENAME
C
C      IMPLICIT NONE
#PPC      INTEGER MAXLVL
&PPC      INTEGER      theIndex, theKind, theStatus
&PPC      INTEGER      IUNIT,    LENNAM
#PPC      PARAMETER (MAXLVL=30)
      CHARACTER*(*) FILNAM,STATUS
#PPC      LOGICAL LEXIST
#PPC      INTEGER KSTRLN
#PPC      INTEGER I,J,K,LEVEL,IWHAT
#PPC      INTEGER NAMLEN(MAXLVL),COLPOS(MAXLVL)
#PPC      INTEGER LSTLEN(MAXLVL),LSTPOS(MAXLVL)
#PPC      CHARACTER*200 INQNAM,NAME(MAXLVL),LIST(MAXLVL)
C
\TDVNAM
\XDVNAM
\XUNITS
\XOPVAL
\XERVAL
\XIOBUF
C
C NOW WE SEARCH FOR THE LENGTH OF OUR FILE NAME AND REMOVE BLANKS.
C
C      WRITE(6,*) 'MTRNLG:  Input="',FILNAM(1:KSTRLN(FILNAM)),
C     & '":',LEN(FILNAM),', Status="',STATUS(1:KSTRLN(STATUS)),'"'
c      WRITE(CMON,*) 'MTRNLG:  Input="',FILNAM(1:KSTRLN(FILNAM)),
c     & '":',LEN(FILNAM),', Status="',STATUS(1:KSTRLN(STATUS)),'"'
c      CALL XPRVDU(NCVDU,1,0)
      LEVEL=1
c      J=0
c      DO 1 I=1,LEN(FILNAM)
c        IF(FILNAM(I:I).NE.' ') THEN
c          J=J+1
c          IF(J.LE.LEN(NAME(1))) NAME(1)(J:J)=FILNAM(I:I)
c        ENDIF
c1     CONTINUE

      J = MIN(LEN(NAME(1)),MAX(1,KCLNEQ(FILNAM,-1,' ')))
      NAME(1)(1:J)=FILNAM(1:J)

      NAMLEN(1)=J
      LSTPOS(1)=0
      LSTLEN(1)=-1

C Check for http: links.
      CALL XCCUPC(NAME(1),INQNAM)
      IF ( INQNAM(1:5) .EQ. 'HTTP:' ) GOTO 9999   !No need to subst variables.
      

C CHECK ON FILE NAME NAMLEN OVERFLOW

      IF(J.GT.LEN(NAME(LEVEL))) THEN
        WRITE ( cmon, '( '' MTRNLG: Filename too long '')')
        CALL XPRVDU(NCEROR, 1, 0)
        CALL XOPMSG (IOPCRY, IOPABN, 0 )
        CALL XERHND (IERSEV)
      ENDIF

      IWHAT=0
      IF(STATUS.EQ.'OLD') IWHAT=1
      IF(STATUS.EQ.'NEW') IWHAT=2
      IF(STATUS.EQ.'FRESH') IWHAT=2
      IF(STATUS.EQ.'UNKNOWN') IWHAT=3
      IF(IWHAT.EQ.0) THEN
        WRITE ( CMON, '( '' MTRNLG: Unknown status '')')
        CALL XPRVDU(NCEROR, 1, 0)
        CALL XOPMSG (IOPCRY, IOPABN, 0 )
        CALL XERHND (IERSEV)
      END IF

C HERE COMES THE BIG SEARCH LOOP. IT IS GUIDED BY THE LEVEL AND THE VARIABLE.
C SEARCH FOR THE FIRST ':' IF THERE IS ANY


C Don't subst things like C:\ - start search from third character.
2     COLPOS(LEVEL) =
     c    INDEX( NAME(LEVEL)(MIN(3,NAMLEN(LEVEL)):NAMLEN(LEVEL)),':' )
      COLPOS(LEVEL) = COLPOS(LEVEL)+2  !Correct for starting from 3rd char.

C FEB04: On Win32 platform, search for forward slashes and change
C to back slashes - this will allow consistent file and path naming
C on all platforms.
&&&&GIDDOSDVFWXS      DO WHILE(.TRUE.)
&&&&GIDDOSDVFWXS        ISLP = KCCEQL(NAME(LEVEL),1,'/')
&&&&GIDDOSDVFWXS        IF ( ISLP .GT. 0 ) THEN
&&&GIDDOSDVF          NAME(LEVEL)(ISLP:ISLP) = '\'
&WXS                  NAME(LEVEL)(ISLP:ISLP) = '\\'
&&&&GIDDOSDVFWXS        ELSE
&&&&GIDDOSDVFWXS          EXIT
&&&&GIDDOSDVFWXS        END IF
&&&&GIDDOSDVFWXS      END DO


C      WRITE(6,*) 'Looking for :', NAME(LEVEL)(1:NAMLEN(LEVEL))

C TEST IF SOMETHING CAN BE DONE

      IF(COLPOS(LEVEL).LT.3) THEN   

C        WRITE(6,*)'Inquiring: ',NAME(LEVEL)(1:NAMLEN(LEVEL))

        IF(IWHAT.EQ.2) GOTO 9999
        INQNAM=NAME(LEVEL)(1:NAMLEN(LEVEL))

c mar02 - trim back to last hash - allows html files to be opened with
c anchors specified after filename. e.g. myfile.html#sect1

        IHASH = INDEX(INQNAM,'#')
        IF (IHASH.LE.0) IHASH = NAMLEN(LEVEL)+1
        DO I=MIN(IHASH,NAMLEN(LEVEL)+1),LEN(INQNAM)
          INQNAM(I:I)=' '
        END DO

        INQUIRE(FILE=INQNAM,EXIST=LEXIST, iostat=iotest)
        if( (iotest .eq. 0) .and. (LEXIST))  GOTO 9999
        LEVEL=LEVEL-1
        IF(LEVEL.GE.1) GOTO 3
        LEVEL=1
        GOTO 9999
      ENDIF

C LOOK FOR AN ENVIRONMENT STRING IF NONE WAS ASSIGNED UP TO NOW

      IF(LSTLEN(LEVEL).LT.0) THEN
        CALL XCCUPC(NAME(LEVEL)(1:COLPOS(LEVEL)-1),
     &              NAME(LEVEL)(1:COLPOS(LEVEL)-1))
        LIST(LEVEL) = ' '
&DOS          CALL DOSPARAM@(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
&&DVFGID      CALL GETENV(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
&&LINGIL      CALL GETENV(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
&WXS          CALL GETENV(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))

CNOV98 IF THERE IS NO ENVIRONMENT VARIABLE, CHECK THE PRESETS
        IF (LIST(LEVEL) .EQ. ' ') THEN
          IF (NAME(LEVEL)(1:COLPOS(LEVEL)-1) .EQ. 'CRMAN') THEN
            LIST(LEVEL) = CHLPDV(1:LHLPDV)
          ELSE IF (NAME(LEVEL)(1:COLPOS(LEVEL)-1) .EQ. 'CRSCP') THEN
            LIST(LEVEL) = CSCPDV(1:LSCPDV)
          ELSE IF (NAME(LEVEL)(1:COLPOS(LEVEL)-1) .EQ. 'CRDIR') THEN
&&DOSDVF         LIST(LEVEL) = '.\'
&&GIDVAX         LIST(LEVEL) = '.\'
&&LINGIL         LIST(LEVEL) = './'
&WXS             LIST(LEVEL) = './'
          ENDIF
        ENDIF
        LSTPOS(LEVEL)=0
        LSTLEN(LEVEL)=KSTRLN(LIST(LEVEL))

C        WRITE(6,*) 'Environment ',LEVEL,'  "',
C     &    NAME(LEVEL)(1:COLPOS(LEVEL)-1),'"  = "',
C     &    LIST(LEVEL)(1:LSTLEN(LEVEL)),'"'
      ENDIF

C TEST LIST FOR SOMETHING TO PROCESS

3     CONTINUE

C      WRITE(6,*) 'Testing ',LEVEL,'  "',
C     &  NAME(LEVEL)(1:NAMLEN(LEVEL)),'"'

      IF((LSTPOS(LEVEL).GE.LSTLEN(LEVEL))
     &  .OR.((LSTPOS(LEVEL).GT.0).AND.(IWHAT.EQ.2))) THEN
        LEVEL=LEVEL-1
        IF(LEVEL.GE.1) GOTO 3
        LEVEL=1
        IF(IWHAT.EQ.3) THEN
          IWHAT=2
          LEVEL=1
          LSTPOS(1)=0
          LSTLEN(1)=-1
          GOTO 2
        ENDIF
        GOTO 9999
      ELSE
        IF(LEVEL.GE.MAXLVL) THEN
          WRITE ( CMON, '( '' MTRNLG: Out of levels '')')
          CALL XPRVDU(NCEROR, 1, 0)
          CALL XOPMSG (IOPCRY, IOPABN, 0 )
          CALL XERHND (IERSEV)
        END IF
        J=LSTPOS(LEVEL)+1
        LSTPOS(LEVEL)=INDEX(LIST(LEVEL)(J:LSTLEN(LEVEL)),',')+J-1
        IF(LSTPOS(LEVEL).EQ.(J-1)) LSTPOS(LEVEL)=LSTLEN(LEVEL)+1

C         WRITE(6,*)
C     1 'Extracted     "',LIST(LEVEL)(J:LSTPOS(LEVEL)-1),'"'
        K=LSTPOS(LEVEL)-J
        NAME(LEVEL+1)(1:K)=LIST(LEVEL)(J:LSTPOS(LEVEL)-1)

C          WRITE(6,*)'Name="',NAME(LEVEL+1)(1:K),'"',J,K
        J=COLPOS(LEVEL)

C IF SOME 'REST' OF THE ORIGINAL FILE NAME REMAINDED
C
        IF(J.LT.NAMLEN(LEVEL)) THEN
C
C IF THE 'REST' CAN BE ADDED TO THE STRING WE GOT, DO SO
C
          IF((K+(NAMLEN(LEVEL)-J)).LE.LEN(NAME(LEVEL+1))) THEN
            NAME(LEVEL+1)(K+1:K+(NAMLEN(LEVEL)-J))
     &        =NAME(LEVEL)(J+1:NAMLEN(LEVEL))
            NAMLEN(LEVEL+1)=K+(NAMLEN(LEVEL)-J)
            DO 4 I=NAMLEN(LEVEL+1)+1,LEN(NAME(LEVEL+1))
              NAME(LEVEL+1)(I:I)=' '
4           CONTINUE
          ELSE
            NAME(LEVEL+1)(K+1:LEN(NAME(LEVEL+1)))
     &        =NAME(LEVEL)(J+1:J+(LEN(NAME(LEVEL+1))-K))
            NAMLEN(LEVEL+1)=LEN(NAME(LEVEL+1))
C           ...
          ENDIF
        ELSE
          NAMLEN(LEVEL+1)=K
        ENDIF
        LEVEL = LEVEL+1
        LSTPOS(LEVEL) = 0
        LSTLEN(LEVEL) = 0
CNOV98        LSTLEN(LEVEL) = -1
        GOTO 2
      ENDIF
9999  CONTINUE
      IF(LEN(FILNAM).LT.NAMLEN(LEVEL)) THEN
          WRITE ( CMON, '(// '' MTRNLG: Filename too small ''//)')
          CALL XPRVDU(NCEROR, 1, 0)
          CALL XOPMSG (IOPCRY, IOPABN, 0 )
          CALL XERHND (IERSEV)
       END IF
C
      FILNAM(1:NAMLEN(LEVEL))=NAME(LEVEL)(1:NAMLEN(LEVEL))
      DO 8888 I=NAMLEN(LEVEL)+1,LEN(FILNAM)
        FILNAM(I:I)=' '
8888  CONTINUE
      LENNAM = KSTRLN(FILNAM)
C      WRITE(6,*) 'MTRNLG: Output="',FILNAM(1:LENNAM),'"'
c      WRITE(CMON,*) 'MTRNLG: Output="',FILNAM(1:LENNAM),'"'
c      CALL XPRVDU(NCVDU,1,0)


C
C This is the PPC version of MTRNLG, preserved for future use:
&WINC----- I DONT KNOW WHERE THIS CAME FROM!
&WIN       WIN_FILER (FILNAM, LENNAM)
&PPC\CFLDAT
&PPC\XIOBUF
C
&PPCC**** First get the Filename, if we have none and are allowed to set
&PPCC****
&PPC      IF ( ( STATUS .NE. 'SCRATCH' ) .AND. ( FILNAM .EQ. ' ' ) ) THE
&PPC           CALL GINDEX( IUNIT, theIndex )
&PPC           FILNAM = FLNAME( theIndex )(1:LFNAME( theIndex ) )
&PPC           LENNAM = LFNAME( theIndex )
&PPC      ENDIF
&PPCC****
&PPCC**** Then we have to find out, if there is some kind of logical uni
&PPCC**** For that purpose, we will search for the directory separator a
&PPCC**** the text before is in our table of logicals. If not, we must a
&PPCC**** it is a real directory. If yes, we need to set the kind and cu
&PPCC**** logical.
&PPCC****
&PPC      CALL GDKIND ( IUNIT, theKind , LENNAM, FILNAM )
&PPCC****
&PPCC**** And finally lets set the directory as working directory
&PPCC****
&PPC      CALL setdir ( theKind , theStatus )
&PPCC      WRITE ( CIOBUF, '(A2,A,I2,A,A10,A,I2,A,I3,A2)' ) CCRCHR(1:2),
&PPCC     1 '-- Setting kind: ',theKind,
&PPCC     2 ' name: ',FILNAM(1:LENNAM),' unit: ',IUNIT,
&PPCC     3 ' with Status: ',theStatus, CCRCHR(1:2)
&PPCC      CALL FLBUFF( 66, 0, ISSPRT )
&PPCC
&PPCC****
&PPCC**** Lets do something, if we could not set the directory
&PPCC****
&PPCCE***
      RETURN
      END
C
CODE FOR KSTRLN
      FUNCTION KSTRLN(STRING)
      CHARACTER*(*) STRING
      INTEGER I,J
      J=0
      DO 1 I=1,LEN(STRING)
        IF((STRING(I:I).NE.CHAR(32)).AND.(STRING(I:I).NE.' ')) J=I
1     CONTINUE
      KSTRLN=J
      RETURN
      END
C
CODE FOR MYDRIV
&DOS      SUBROUTINE MYDRIV (B,NB,NCH,ACTION,IFAIL)
&DOSC
&DOSC                 CONTROL TERMINAL OUTPUT.
&DOSC      THE BUFFER B, OF NB INTEGER*2 ITEMS, HOLDS NCH CHARACTERS
&DOSC      IACTION IS THE TYPE OF CALL BEING MADE, AND IFAIL PASSES
&DOSC      A KEY BACK TO THE IOSTAT
&DOSC
&DOS      INTEGER*2 B(NB), NCH, ACTION, IFAIL
&DOS\XDRIVE
C
C      LDRV77      CURRENT LINE ON PAGE. MUST BE SET BEFORE ENTRY
C                  AND IS INCREMENTED OR SET TO ZERO BY MYDRIV
C      MDRV77      REQUIRED NUMBER OF LINES ON PAGE.
C      JNL77       1 FOR CRLF, ELSE 0
C      JPMT77      1 FOR PROMPT, ELSE 0
C      ISSPAS, DWT77       WAIT TIME, SECONDS
&DOS\XSSVAL
C
&DOSC     Just return on open
&DOS      IF(ACTION.EQ.6)RETURN
&DOSC
&DOSC     This routine only deals with formatted output
&DOS      IF(ACTION.NE.2)THEN
&DOS        IFAIL=999
&DOS        RETURN
&DOS      ENDIF
&DOSC
&DOS      DWT77 = ISSPAS
&DOSC
&DOSC----- PAGE FULL YET? - NOTE YOU CAN FORCE A PAUSE BY SETTING LDRV77
&DOSC      .GE. MDRV77 BEFORE YOU DO THE WRITE.
&DOS      IF (LDRV77 .GE. MDRV77 ) THEN
&DOSC----- NEED A PROMPT?
&DOS        IF (JPMT77 .EQ. 1) THEN
&DOS          CALL COU@ ( 'Press a key to continue' )
&DOS          CALL GET_KEY@ (KKZ)
&DOS        ELSE
&DOS          CALL SLEEP@ (DWT77)
&DOS        END IF
&DOS      LDRV77 = 0
&DOS      END IF
&DOSC
&DOSC     Call SOU@ with explicitly supplied dope vector
&DOS      MCH = MIN (79, INTL(NCH) )
&DOSC----- SUPPRESS A NEWLINE ? - OR AN ESCAPE SEQUENCE
&DOS      IF (( JNL77 .NE. 1 ) .OR. ( B(1) .EQ. 6944 )) THEN
&DOS        CALL SOUA@ (B, MCH)
&DOS      ELSE
&DOS        CALL SOU@ (B, MCH )
&DOS      END IF
&DOS      LDRV77 = LDRV77 + 1
&DOS      RETURN
&DOS      END
C
CODE FOR KORE
#ICL      FUNCTION KORE(ISIZE)
#ICLC -- RETURN SIZE OF ARRAY.IN THE ABSENCE OF A CLEVER METHOD
#ICLC    (ELASTIC DIMENSIONING) FOR
#ICLC    DOING THIS THE ARRAY SIZE MUST BE PASSED TO THIS ROUTINE
#ICLC    IN FIXED SIZE IMPLEMENTATIONS (ON PAGED MACHINES) THIS SIZE
#ICLC    WILL BE SET IN 'PRESETS' VIA THE MACROFILE.
#ICLC
#ICL      KORE=ISIZE
#ICL      RETURN
#ICL      END
CODE FOR KIGC
#ICL      FUNCTION KIGC(N,M)
C----- IN IMPLEMENTATIONS REQUIRING PROGRAM MODULES TO BE OVERLAID
C     BY THE JOB CONTROL LANGUAGE THIS SUBROUTINE LOADS THE NAME OF
C     THE MODULE INTO A JCL VARIABLE - E.G. ON THE ICL 1906 & 2980.
C-----
C     IN IMPLEMENTATIONS USING A SINGLE MONOLITHIC PROGRAM, THIS
C     SUBROUTINE IS A DUMMY.
C
#ICL      DIMENSION M(N)
#ICLC
#ICL      KIGC=1
#ICL      RETURN
#ICL      END
C
CODE FOR XQUIT
#ICL      SUBROUTINE XQUIT
C----- THIS SUBROUTINE COMPLEMENTS 'KIGC', AND EXITS
C     FROM THE CURRENT PROGRAM TO THE JCL STREAM,
C     WHICH IS RESPONSIBLE FOR LOADING THE NEXT MODULE.
C
C----- IN MONOLITHIC INPLEMENTATIONS THIS IS A DUMMY.
#ICL      RETURN
#ICL      END
CODE FOR XRDMSE
###DVFGIDWXS      SUBROUTINE XRDMSE (CMOUSE, NMOUSE)
C----- GET A STRING OF ATOM NAMES FROM THE MOUSE
C----- SHOULD BE REPLACED BY A MACHINE SPECIFIC ROUTINE
###DVFGIDWXS      CHARACTER*(*) CMOUSE
###DVFGIDWXS      CMOUSE = ' FIRST UNTIL LAST '
###DVFGIDWXS      NMOUSE = 18
###DVFGIDWXS      LMOUSE = 1
###DVFGIDWXS      MMOUSE = 1
###DVFGIDWXS      RETURN
###DVFGIDWXS      END

CODE FOR FRAND
      FUNCTION FRAND()
C------ RETURNS A VALUE BETWEEN 0 and 1 from the compiler library's
C       random number generator.
&&DVFGID      USE DFPORT
&&DVFGID      FRAND = RAND()
&DOS          FRAND = RANDOM()
&&LINGIL      FRAND = RAND()
&WXS      FRAND = RAND()
&VAX          FRAND = RAN (NINT(SECNDS(0.0)))
      RETURN
      END

CODE FOR XRAND
      FUNCTION XRAND(REQVAR, ISEED)
C------ RETURNS A VALUE DISTRIBUTED ABOUT ZERO FROM A DISTRIBUTION
C       WITH VARIANCE REQVAR
C
C    REQVAR - REQUESTED VARIANCE OF RESULT
C    ISEED = 0 FOR REPEATED RANDOM NUMBERS
&&DVFGID      USE DFPORT
&VAX      INTEGER*4 SEED
      DOUBLE PRECISION ZZZ
      DATA ISET /-1/
      IF (ISET .LE. -1) THEN
        ISET = 0
        IF (ISEED .EQ. 0) THEN
C----- REPEAT RANDOM SEQUENCE
&XXX          SEED = 0.0
&VAX          SEED = 7654321
&DOS          CALL SET_SEED@(SEED)
&&DVFGID          CALL SRAND(0)
&&LINGIL          CALL SRAND(0)
&WXS          CALL SRAND(0)
        ELSE
C----- CREATE NEW SEQUENCE
&XXX          SEED = 0
&VAX          SEED = NINT(SECNDS(0.0))
&DOS          CALL DATE_TIME_SEED@
&&DVFGID          CALL SRAND(RND$TIMESEED )
&&LINGIL          CALL SYSTEM_CLOCK(ISEED,IDV,IDV2)
&&LINGIL          CALL SRAND(ISEED)
&WXS          CALL SYSTEM_CLOCK(ISEED,IDV,IDV2)
&WXS          CALL SRAND(ISEED)
        ENDIF
      ENDIF
      IF (ISET .EQ. 0) THEN
&XXX      STOP 'NO RANDOM No GENERATOR'

1      V1 = 2. * FRAND() -1.
       V2 = 2. * FRAND() -1.
      R = V1**2 + V2**2
      IF (R .GE. 1.  .OR. R .EQ. 0. ) GOTO 1
      FAC = SQRT(-2. * LOG(R)/R)
      GSET = V1 * FAC
      GASDEV = V2 * FAC
      ISET = 1
      ELSE
      GASDEV = GSET
      ISET = 0
      ENDIF
      XRAND = GASDEV * REQVAR
      RETURN
      END
C
CDJW> WINDOWS SUBROUTINES
CODE FOR XWININ
      SUBROUTINE XWININ(IN)
cC----- INITIALISE THE WINDOWS ENVIRONMENT
cC      IN - RETURNED AS 0 IF INITIALISATION FAILS
c\XSSVAL
c\XGUIOV
c\XUNITS
cC LGUIL1 IS SET IF LIST 1 IS AVAILABLE
cC LUPDAT IS SET WHEN GUMTRX IS INITIALISED AND GUI IS ENABLED
c      IN = 0
c      IF (KEXIST(1) .GT. 0) THEN
c            CALL XFAL01
c            LGUIL1 = .TRUE.
c      ENDIF
c      IF (KEXIST(5) .GT. 0) THEN
c            CALL XFAL05
c      ENDIF
c      IF (IERFLG .GE. 0) THEN
c            IF (LGUIL1) THEN
c                  IN = +1
c                  LUPDAT = .TRUE.
c            ENDIF
c      ENDIF
      RETURN
      END
CODE FOR GETCOM
      SUBROUTINE GETCOM(CLINE)
&GID      INTERFACE
&GID                    SUBROUTINE CINEXTCOMMAND (istat, caline)
&GID                    !DEC$ ATTRIBUTES C :: cinextcommand
&GID                    INTEGER ISTAT
&GID                    CHARACTER*256 CALINE
&GID                    !DEC$ ATTRIBUTES REFERENCE :: CALINE
&GID                    END SUBROUTINE CINEXTCOMMAND
&GID            END INTERFACE
&GID      INTEGER ISTAT
&&GIDGIL      CHARACTER*256 CALINE
&WXS      CHARACTER*256 CALINE
\XSSVAL
\UFILE
\CAMPAR
\CAMBLK
&NEVER \CAMGRP
\XIOBUF
\XUNITS
      CHARACTER *(*) CLINE

&VAX      READ( NCUFU(1), 1) CLINE
&LIN      READ( NCUFU(1), 1) CLINE
&DVF      READ( NCUFU(1), 1) CLINE
&GIL      ISTAT = 0
&GIL      CALL CINEXTCOMMAND(ISTAT,CALINE)
&GIL      READ(CALINE,'(A)') CLINE
&WXS      ISTAT = 0
&WXS      CALL CINEXTCOMMAND(ISTAT,CALINE)
&WXS      READ(CALINE,'(A)') CLINE
C&GID      DATA CALINE(1:40) /'                                        '/
&GID      CALINE=' '
&GID      ISTAT = 0
&GID      CALL CINEXTCOMMAND(ISTAT,CALINE)
&GID      READ(CALINE,'(A)') CLINE
&&GILGID      IF ( LCLOSE ) THEN
&&GILGID          WRITE(CMON,'(A)') '^^WI SET PROGOUTPUT TEXT = '
&&GILGID          CALL XPRVDU (NCVDU,1,0)
&&GILGID          WRITE(CMON,'(A)') '^^WI ''Working. Please Wait.'''
&&GILGID          CALL XPRVDU (NCVDU,1,0)
&&GILGID          WRITE(CMON,'(A)')  '^^CR '
&&GILGID          CALL XPRVDU (NCVDU,1,0)
&&GILGID      ENDIF

&WXS      IF ( LCLOSE ) THEN
&WXS          WRITE(CMON,'(A)') '^^WI SET PROGOUTPUT TEXT = '
&WXS          CALL XPRVDU (NCVDU,1,0)
&WXS          WRITE(CMON,'(A)') '^^WI ''Working. Please Wait.'''
&WXS          CALL XPRVDU (NCVDU,1,0)
&WXS          WRITE(CMON,'(A)')  '^^CR '
&WXS          CALL XPRVDU (NCVDU,1,0)
&WXS      ENDIF
&DOS      IF ( LCLOSE ) THEN
&DOS         READ( NCUFU(1), 1) CLINE
&DOS      ELSE
&DOS         CALL ZTXT (CLINE)
&DOS      ENDIF
1     FORMAT ( A )
      RETURN
      END
C

cCODE FOR GUWAIT
c      SUBROUTINE GUWAIT()
c&GID      INTERFACE
c&GID          SUBROUTINE COMPLETE ()
c&GID          !DEC$ ATTRIBUTES C :: complete
c&GID          END SUBROUTINE COMPLETE
c&GID      END INTERFACE
c&&GIDGIL      CALL COMPLETE()
c&WXS      CALL COMPLETE()
c      END


CODE FOR GUEXIT
      SUBROUTINE GUEXIT(IVAR)
&GID      INTERFACE
&GID          SUBROUTINE CIENDTHREAD (IVAR)
&GID          !DEC$ ATTRIBUTES C :: ciendthread
&GID          INTEGER IVAR
&GID          END SUBROUTINE CIENDTHREAD
&GID      END INTERFACE
C
      INTEGER IVAR
\UFILE
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
&DVF      CALL EXIT(IVAR)
&LIN      CALL EXIT(IVAR)
####GIDGILDVFWXS      STOP
&GID      CALL CIENDTHREAD(IVAR)
&GIL      CALL CIENDTHREAD(IVAR)
&WXS      CALL CIENDTHREAD(IVAR)
&GID      RETURN
&GIL      RETURN
&WXS      RETURN
      END

ccode for dumio (keep the program going while we test it)
c      subroutine dumio(cline)
c      CHARACTER *(*) CLINE
c\XUNITS
c      cline = ' '
c      read(5,'(a)')cline
c      return
c      end
cC
cCODE FOR FLBUFF
c      SUBROUTINE FLBUFF( IBFLEN, IBFBEH, IBFPRT )
cC -- IBFLEN is   0, if the length of the buffer is unknown
cC -- IBFBEH is   0, when normal jump on next line is expected
cC           is   1, when we continue the next output on the same line
cC           is   2, when we output at the beginning of the same line
cC           is  -1, when we don't want output on screen
cC -- IBFPRT is   0, when listing has to be done
cC           is   1, when listing is off
cC -- IBFOFF **** not currently used ****
cC           is > 0, if the output needs the buffer from
cC                         1 + IBFOFF
cC           is < 0, if the output needs the buffer until
cC                         IBFLEN - IBFOFF
cC           is   0, if no difference exists for monitor and listing
c\XUNITS
cC
c\XIOBUF
cC
c      INTEGER        IBFLEN,IBFBEH,I,IBFPRT
c      CHARACTER*10 CFRMAT
cC
c&PPC      IF ( IBFLEN .EQ. 0 ) THEN
c&PPC         I = 1
c&PPC      ELSE
c&PPC         IF ( IBFLEN .LE. 132 ) THEN
c&PPC            I = IBFLEN
c&PPC         ELSE
c&PPC            I = 132
c&PPC         ENDIF
c&PPC      ENDIF
c&PPC      IF ( IBFBEH .EQ. 0) THEN
c&PPC         IF ( I .GT. 130) I = 130
c&PPC         I = I + 2
c&PPC         CIOBUF(I-1:I-1) = CCRCHR(1:1)
c&PPC         CIOBUF(I:I)     = CCRCHR(2:2)
c&PPC      ENDIF
c&PPC      CALL NBACUR
c&PPC      IF ( IBFBEH .GE. 0 ) THEN
c&PPC         LINS = 0
c&PPC         DO 100 k=1,I
c&PPC           IF ( CIOBUF(K:K) .EQ. CHAR(13) ) LINS = LINS + 1
c&PPC100      CONTINUE
c&PPC         CALL FLUSHB(  I, CIOBUF, LINS )
c&PPC       ENDIF
c&PPC       IF ( IBFPRT .EQ. 0) THEN
c&PPC          WRITE ( NCWU , '(A)' ) CIOBUF(1:I)
c&PPC       ENDIF
cC
c&VAX       IF ( IBFBEH .EQ. 1 ) THEN
c&VAX          CFRMAT = '(A,$)'
c&VAX       ELSEIF ( IBFBEH .EQ. 2 ) THEN
c&VAX          CFRMAT = '(''+'',A)'
c&VAX       ELSE
c&VAX          CFRMAT = '(A)'
c&VAX       ENDIF
c&VAX      IF (IBFLEN .LE. 0) THEN
c&VAX        IBFLEN = LEN(CIOBUF)
c&VAX        CALL XCTRIM(CIOBUF, IBFLEN)
c&VAX      ENDIF
c&VAX      J = 1
c&VAX100   CONTINUE
c&VAX      DO 200 I = J, IBFLEN
c&VAX        IF (CIOBUF(I:I) .EQ. CCRCHR(1:1)) THEN
c&VAX          K = MAX(J,I-1)
c&VAX       WRITE ( NCAWU , CFRMAT, IOSTAT = IOS ) CIOBUF(J:K)
c&VAX       IF ( IOS .NE. 0 ) WRITE ( NCAWU , '(1X,A,I4)' )
c&VAX     1  '*** OUTPUT ERROR! IOS = ',IOS
c&VAX          J = K + 3
c&VAX          IF (J .LT. IBFLEN ) GOTO 100
c&VAX        ENDIF
c&VAX200   CONTINUE
c&VAX      IF (J .LE. IBFLEN)  THEN
c&VAX       WRITE ( NCAWU , CFRMAT, IOSTAT = IOS ) CIOBUF(J:IBFLEN)
c&VAX       IF ( IOS .NE. 0 ) WRITE ( NCEROR , '(1X,A,I4)' )
c&VAX     1  '*** OUTPUT ERROR! IOS = ',IOS
c&VAX      ENDIF
c&VAX      CIOBUF = ' '
cC
c&DOS       IF ( IBFBEH .EQ. 1 ) THEN
c&DOS          CFRMAT = '(A,$)'
c&DOS       ELSEIF ( IBFBEH .EQ. 2 ) THEN
c&DOS          CFRMAT = '(''+'',A)'
c&DOS       ELSE
c&DOS          CFRMAT = '(1X,A)'
c&DOS       ENDIF
c&DOS      IF (IBFLEN .LE. 0) THEN
c&DOS        IBFLEN = LEN(CIOBUF)
c&DOS        CALL XCTRIM(CIOBUF, IBFLEN)
c&DOS      ENDIF
c&DOS      J = 1
c&DOS100   CONTINUE
c&DOS      DO 200 I = J, IBFLEN
c&DOS        IF (CIOBUF(I:I) .EQ. CCRCHR(1:1)) THEN
c&DOS          K = MAX(J,I-1)
c&DOS       WRITE ( NCAWU , CFRMAT, IOSTAT = IOS ) CIOBUF(J:K)
c&DOS       IF ( IOS .NE. 0 ) WRITE ( NCEROR , '(1X,A,I4)' )             
c&DOS     1  '*** OUTPUT ERROR! IOS = ',IOS
c&DOS          J = K + 3
c&DOS          IF (J .LT. IBFLEN ) GOTO 100
c&DOS        ENDIF
c&DOS200   CONTINUE
c&DOS      IF (J .LE. IBFLEN)  THEN
c&DOS       WRITE ( NCAWU , CFRMAT, IOSTAT = IOS ) CIOBUF(J:IBFLEN)
c&DOS       IF ( IOS .NE. 0 ) WRITE ( NCEROR , '(1X,A,I4)' )
c&DOS     1  '*** OUTPUT ERROR! IOS = ',IOS
c&DOS      ENDIF
c&DOS      CIOBUF = ' '
cC
c      RETURN
c      END
C
CODE FOR FBCINI
      SUBROUTINE FBCINI
C
C----- INITIALISE SOME GOODIES WHICH CANNOT BE SET IN PRESETS
\XIOBUF
C
C>DJWOCT96
C----- INITIALISE I/O BUFFERS
C
      LVDU = 1
      MVDU = 0
      LEROR = 1
      MEROR = 0
C
      DO 100, I = 1, LINBUF
      CCVDU(I) = ' '
      CCEROR(I) = ' '
      CMON(I) = ' '
100   CONTINUE
C
C---- SET CARRIAGE CONTROL SYMBOLS
C
&DOS      CCRCHR(1:1) = CHAR(10)
&DOS      CCRCHR(2:2) = CHAR(13)
C
&VAX      CCRCHR(1:1) = CHAR(10)
&VAX      CCRCHR(2:2) = CHAR(13)
C
&UNX      CCRCHR(1:1) = CHAR(32)
&UNX      CCRCHR(2:2) = CHAR(10)
C
&PPC      CCRCHR(1:1) = CHAR(32)
&PPC      CCRCHR(2:2) = CHAR(10)
C<DJWOCT96
C
      RETURN
      END
C
CODE FOR XPRVDU
      SUBROUTINE XPRVDU(NCDEV, NLINES, MODE)
C----- PROCESS THE VDU BUFFER
C      A CALL IS MADE AFTER THE FORTRAN WRITE TO SEE IF THERE IS
C      ENOUGH SPACE.
C      NCDEV IS THE PHYSICAL DEVICE THE TEXT SHOULD BE DISPLAYED ON
C      NLINES IS THE NUMBER OF LINES, INCLUDING BLANKS, TO
C            BE TRANSFERED.
C      MODE SETS THE ACTION.
C      THE BUFFER IS ONLY PROCESSED WHEN THERE IS NOT ENOUGH ROOM FOR
C      THE NEXT OUTPUT, UNLESS MODE IS ZERO, WHEN IT IS PROCESSED
C      IMMEDIATELY.
C EXAMPLE
C      WRITE(CMON,1234) 'LINE1', 'LINE2', 'LINE3'
C1234  FORMAT(1X,A/1X,A/1X,A)
C A FINAL CALL WILL FORCE PROCESSING
C      CALL XPRVDU(NCVDU,3,0)
C
C      CMON(LINBUF) IS SCREEN BUFFER
C      LMON IN NEXT FREE LINE IN BUFFER
C      MMON IS NUMBER OF LINES TO BE OUTPUT
C      NCDEV IS WHERE BUFFER WILL BE DISPLAYED
C            CURRENTLY SUPPORTED VALUES ARE:
C                  NCVDU      THE NORMAL TEXT AREA
C                  NCEROR     THE TEXT AREA FOR ERROR MESSAGES
C      MODE < 0 TO PROCESS BUFFER AND NOT CLEAR
C      MODE = 0 TO PROCESS BUFFER AND CLEAR
C      MODE > 0 CHECK IF ENOUGH ROOM FOR 'MODE' LINES, OTHERWISE PROCESS
C
\XUNITS
\XIOBUF
C----- THE VDU AND ERROR MONITOR BUFFERS
C      PARAMETER (LINBUF=24)
C      CHARACTER *80 CCVDU(LINBUF), CCEROR(LINBUF), CMON(LINBUF)
C      COMMON /XCIOBF/ CCVDU, CCEROR, CMON
C      COMMON /XIIOBF/ LVDU, MVDU, LEROR, MEROR
C
      CHARACTER*1 CTEMP
      CHARACTER*10 CFRMAT
C
C------ IF THE CURRENT DEVICE ISNT THE SAME AS THE PREVIOUS, PERHAPS WE
C       SHOULD FORCE A PRINT?
      DATA OLDDEV /0/, LMON /1/
C
      IF (NCDEV .EQ. NCVDU) THEN
        IF((LMON + NLINES) .GT. LINBUF) THEN
            CALL XPRTDV(NCDEV,CCVDU, LINBUF, LMON-1)
            LMON=1
        ENDIF
            DO 100 I = 1,NLINES
                  CCVDU(LMON) = CMON(I)
                  LMON=LMON + 1
100         CONTINUE
        IF (MODE .EQ. 0) THEN
            CALL XPRTDV(NCDEV, CCVDU, LINBUF, LMON-1)
            LMON = 1
        ENDIF
      ELSE IF(NCDEV .EQ. NCEROR) THEN
        IF((LEROR + NLINES) .GT. LINBUF) THEN
            CALL XPRTDV(NCDEV, CCEROR, LINBUF, LEROR-1)
            LEROR=1
        ENDIF
            DO 200 I = 1,NLINES
                  CCEROR(LEROR) = CMON(I)
                  LEROR=LEROR + 1
200         CONTINUE
        IF (MODE .EQ. 0) THEN
            CALL XPRTDV(NCDEV, CCEROR, LINBUF, LEROR-1)
            LEROR = 1
        ENDIF
      ELSE
            WRITE(*,*) 'Unrecognisd I/O device in XPRVDU'
      ENDIF
      RETURN
      END
CODE FOR XPRTDV
      SUBROUTINE XPRTDV(NCDEV, CBUF, LINBUF, NLINES)
C---- MACHINE SPECIFIC WRITE TO THE SCREEN
&GIDC{
&GID      INTERFACE
&GID                SUBROUTINE CALLCCODE (CALINE)
&GID                    !DEC$ ATTRIBUTES C :: CALLCCODE
&GID                    CHARACTER*(*) CALINE
&GID                    !DEC$ ATTRIBUTES REFERENCE :: CALINE
&GID                END SUBROUTINE CALLCCODE
&GID      END INTERFACE
&GIDC}
\XDRIVE
\XSSVAL
\CAMBLK
\OUTCOL
      CHARACTER*(*) CBUF(LINBUF)
      CHARACTER*262 CEXTRA
      CHARACTER*1 CFIRST, CLAST
      CHARACTER*10 CFRMAT
      DATA CFRMAT /'(1X,A)'/

      CEXTRA = ' '
      LENBUF = LEN(CBUF(1))
###GILGIDWXS      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) THEN
###GILGIDWXS         LENBUF = MIN(LENBUF,79)   !LINE LIMITED TO 79
###GILGIDWXS      ENDIF

      IF (NLINES .GE. 1) THEN
            IF (NLINES .GT. LINBUF) THEN
C- PRINT A WARNING SOMEWHERE
              WRITE(*,*) 'vdu buffer overflow'
              NLINES = LINBUF
            ENDIF

            DO 100 J = 1, NLINES

               CALL XCTRIM(CBUF(J),N)
               N = MAX(1,N)         ! SET N TO LAST NON-BLANK
               CFIRST = CBUF(J)(1:1)
               CLAST = CBUF(J)(N:N)
&GIL               N = MIN(N,261)         ! SET N TO LAST NON-BLANK
&GIL       CBUF(J)(N+1:N+1) = CHAR(0)  ! Make into a c string.

&&GIDGIL       IF (CBUF(J)(2:2).NE.'^') THEN
C&&GILGID          LENBUF = MIN(LENBUF,79)   !LINE LIMITED TO 79 (for output)
&&GIDGIL          IF ((IOFORE.EQ.-1).OR.(IOBACK.EQ.-1)) THEN
&&GIDGIL             WRITE( CEXTRA,'(A)') CBUF(J)
&&GIDGIL          ELSE 
&&GIDGIL             WRITE( CEXTRA,'(2(A,I2.2),A)')
&&GIDGIL     1       '{', IOFORE, ',', IOBACK, CBUF(J)
&&GIDGIL          ENDIF 
&&GIDGIL       ELSE 
&&GIDGIL          WRITE( CEXTRA,'(A)') CBUF(J) !Line not limited (^^ command)
&&GIDGIL       END IF

&WXS       IF (CBUF(J)(2:2).NE.'^') THEN
&WXS          IF ((IOFORE.EQ.-1).OR.(IOBACK.EQ.-1)) THEN
&WXS             WRITE( CEXTRA,'(A)') CBUF(J)
&WXS          ELSE 
&WXS             WRITE( CEXTRA,'(2(A,I2.2),A)')
&WXS     1       '{', IOFORE, ',', IOBACK, CBUF(J)
&WXS          ENDIF 
&WXS       ELSE 
&WXS          WRITE( CEXTRA,'(A)') CBUF(J) !Line not limited (^^ command)
&WXS       END IF

               IF (CLAST .EQ. CHAR(13)) THEN !--- NO CR OR LF
&DOS               JNL77 = 0                 !--- SWITCH OFF LINE FEEDS
###GIDGILWXS            CFRMAT = '(1X,A)'
&VAX                N = N - 1
&VAX                CFRMAT = '(''+'',A)'
&DOS                IF ( .NOT. LCLOSE ) CALL WINOUT(CBUF(J)(1:N))
###GIDGILWXS            WRITE(NCDEV ,CFRMAT) CBUF(J)(1:N)
&&GIDGIL            CALL CALLCCODE ( CEXTRA(1:N+6))
&WXS            CALL CALLCCODE ( CEXTRA(1:N+6))
&DOS                JNL77 = 1                   !--- SWITCH ON LINE FEEDS
               ELSEIF ( CFIRST .EQ. '+' ) THEN !--FORTRAN CR WITHOUT LF
&DOSC------             
&DOS                JNL77 = 0               !--- SWITCH OFF LINE FEEDS
                    CFRMAT = '(A)'
&DOS                IF ( .NOT. LCLOSE ) CALL WINOUT(CBUF(J)(1:N))
Cdjw:      enable thermometer etc in non-vga mode
###GIDGILWXS            WRITE(NCDEV ,'(A,$)') char(13)
###GIDGILWXS            WRITE(NCDEV ,'(A,$)') CBUF(J)(2:LENBUF)
&DOS                JNL77 = 1               !--- SWITCH ON LINE FEEDS
               ELSEIF (CLAST .EQ. '$') THEN !--- LEAVE CURSOR AT CURRENT POSITION
&DOS                JNL77 = 0           !--- SWITCH OFF LINE FEEDS
                    CFRMAT = '(A,A1)'
&DOS                IF ( .NOT. LCLOSE ) CALL WINOUT(CBUF(J)(1:N))
&DOS                WRITE(NCDEV ,CFRMAT) CBUF(J)(1:LENBUF),CHAR(13)
&&GIDGIL            CALL CALLCCODE ( CEXTRA(1:LENBUF))
&WXS            CALL CALLCCODE ( CEXTRA(1:LENBUF))
&VAX                CFRMAT = '(A,$)'
&VAX                WRITE(NCDEV ,CFRMAT) CBUF(J)(1:LENBUF)
&DOS                JNL77 = 1           !--- SWITCH ON LINE FEEDS
               ELSEIF ( CFIRST .EQ. '0' ) THEN
                    CFRMAT = '(/,A)'
&DOS                IF ( .NOT. LCLOSE ) CALL WINOUT(CBUF(J)(1:N))
###GIDGILWXS            WRITE(NCDEV ,CFRMAT) CBUF(J)(1:LENBUF)
&&GIDGIL            CALL CALLCCODE ( CEXTRA(1:LENBUF))
&WXS            CALL CALLCCODE ( CEXTRA(1:LENBUF))
               ELSE
                    CFRMAT = '(A)'
###GIDGILWXS            WRITE(NCDEV ,CFRMAT) CBUF(J)(1:LENBUF)
&DOS                IF ( .NOT. LCLOSE ) CALL WINOUT(CBUF(J)(1:N))
&&GIDGIL            CALL CALLCCODE ( CEXTRA(1:LENBUF))
&WXS            CALL CALLCCODE ( CEXTRA(1:LENBUF))
               ENDIF
C
               CBUF(J) = ' '
100         CONTINUE
400         FORMAT(A)
      ENDIF
      RETURN
      END


&&&GIDGILWXSCODE FOR GDETCH
&&&GIDGILWXS      SUBROUTINE GDETCH(CLINE)
&GID      INTERFACE
&GID                SUBROUTINE GUEXEC (CALINE)
&GID                    !DEC$ ATTRIBUTES C :: GUEXEC
&GID                    CHARACTER*(*) CALINE
&GID                    !DEC$ ATTRIBUTES REFERENCE :: CALINE
&GID                    END SUBROUTINE GUEXEC
&GID      END INTERFACE
&&&GIDGILWXS      CHARACTER*(*) CLINE
&&&GIDGILWXS      CHARACTER*262 CEXTRA
&&&GIDGILWXS      CEXTRA = ' '
&&&GIDGILWXS      WRITE(CEXTRA,'(A)')CLINE
&&&GIDGILWXS      CALL GUEXEC ( CEXTRA )
&&&GIDGILWXS      RETURN
&&&GIDGILWXS      END



CODE FOR GETCWD
      SUBROUTINE GETCWD ( CWORK )
&GID      USE DFLIB
      CHARACTER*(*) CWORK

&GID      cwork = FILE$CURDRIVE
&GID      K= GETDRIVEDIRQQ(cwork)
#GID      CWORK='.' !For now
      RETURN
      END
CODE FOR IGDAT
      INTEGER FUNCTION IGDAT(CFILE)
C      GET AN 8 BYTE CHARACTER REPRESENTATION OF DATE/TIME
      CHARACTER *(*) CFILE
      INTEGER IIDATE(8)
      CHARACTER (len=12) CLOCK(3)
      CALL DATE_AND_TIME (CLOCK(1),CLOCK(2),CLOCK(3),IIDATE)
      I = IIDATE(6) + 100*IIDATE(5)+10000*IIDATE(3)+
     1 1000000*IIDATE(2)
      WRITE(CFILE,'(I8)') I
      IGDAT = I
      RETURN
      END

CRIC2001:
CODE FOR XNDATE
      SUBROUTINE XNDATE(ISECS)
&&DVFGID      USE DFPORT
C--SET THE # SECS SINCE 1970 IN ISECS
      ISECS = TIME()
      RETURN
      END

CODE FOR XCDATE
      SUBROUTINE XCDATE(ISECS,CT)
&&DVFGID      USE DFPORT
C--CONVERT SECS SINCE 1970 INTO 24CHAR STRING
C e.g. "Fri Sep 07 04:37:23 2001"

\XSSVAL
      CHARACTER*24 CT
      IF (ISSTIM .EQ. 2 ) THEN
       CT = ' '
      ELSE
       CT = CTIME(ISECS)
      END IF

      RETURN
      END

