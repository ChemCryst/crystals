C $Log: not supported by cvs2svn $
C Revision 1.73  2012/05/31 15:20:12  rich
C Don't use address lookup to determine vectorised loop or not in XMOVE. LOC result is in bytes -
C but N is in words. Needs a portable solution if this optimisation is to be used.
C
C Revision 1.72  2012/05/11 12:52:14  rich
C Fix date order on Intel platform. Expand year to four digits in CIF output on all platforms.
C
C Revision 1.71  2012/03/23 15:53:59  rich
C Avoid vectorised loops in XMOVE.
C
C Revision 1.70  2012/03/23 14:29:04  rich
C Fix
C
C Revision 1.69  2012/03/23 13:51:00  rich
C Intel compiler support.
C
C Revision 1.68  2011/09/13 14:35:26  rich
C Move message about new D/A file on unit whatever inside the new file if block.
C
C Revision 1.67  2011/09/07 09:44:41  djw
C Change format of #SET OPENMESSAGE text so that columns line up across actions
C Add #SET CACHEMESSAGE (off/on) to inhibit caching information at termination
C Remove disc extension messages
C
C Revision 1.66  2011/09/01 12:08:54  djw
C unify file open/close messages
C
C Revision 1.65  2011/05/04 11:47:43  rich
C Added TODO comment.
C
C Revision 1.64  2011/03/30 16:07:41  rich
C More time issues on WXS.
C
C Revision 1.63  2011/03/30 15:55:36  rich
C Fix time on WXS platform.
C
C Revision 1.62  2011/03/22 11:29:56  rich
C Double slashes dealt with properly. Fixed squashed CIF format.
C
C Revision 1.61  2011/03/21 13:57:22  rich
C Update files to work with gfortran compiler.
C
C Revision 1.60  2011/03/04 05:46:45  rich
C Now building WXS version with digital compiler on windows, therefore introduce
C _DIGITALF77_ and _GNUF77_ to distinguish compiler differences, while keeping __WXS__ and __GID__ etc to distinguish library differences.
C
C Revision 1.59  2009/01/21 17:01:59  djw
C Use - rather than # for higher generations of dsc files because of clash with (incomplete) treatment of # in html links
C
C Revision 1.58  2008/05/09 11:09:12  djw
C Enable generation Nos for dsc files
C
C Revision 1.57  2007/10/09 07:05:48  djw
C Get script name for output
C
C Revision 1.56  2005/02/25 17:25:21  stefan
C 1. Added some preprocessor if defined lines for the mac version.
C
C Revision 1.55  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.3  2005/01/17 09:39:17  rich
C Remove MTRNLG debugging output
C
C Revision 1.2  2004/12/13 16:16:09  rich
C Changed GIL to __GIL__ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:06  rich
C New CRYSTALS repository
C
C Revision 1.54  2004/06/25 11:54:19  rich
C Fixed crash due to assigning value to passed in argument.
C
C Revision 1.53  2004/06/24 08:57:05  rich
C Append null character to strings when passing to GUI.
C Reduces numbers of passes of string required.
C
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
#if defined(CRY_FORTDIGITAL)
      USE DFPORT
#elif defined(__INTEL_COMPILER)
      use ifcore
#endif

      CHARACTER*80 REASON
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
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

      WRITE(REASON, '(A,I4)') 'File I/O Error: ', IOS
      CALL XCTRIM( REASON, MSGEND )
#if !defined(CRY_GUI) && defined(_WIN32)
      CALL PERROR (' perror message ')
#endif

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
C                    'READ' IMPLIES READONLY,SHARED IS IGNORED - on VAX
C                    THIS PARAMETER IS IGNORED - other platforms
C                    'READ' IMPLIES READONLY,SHARED
C      IFFORM      FORMATTED/UNFORMATTED FILE
C                    ISSFRM      FORMATTED FILE
C                    ISSUFM      UNFORMATTED FILE
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
      CHARACTER *(*) CFNAME
      CHARACTER *256  CLCNAM, FILNAM
C
      PARAMETER (NFLSTT=5)
      CHARACTER*7 FLSTAT(NFLSTT)
      CHARACTER*7 ACSTAT,TESTAT
      CHARACTER *11 FLFORM(2), CFORM
      CHARACTER *11 FLSQDA(2)
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      DATA FLSTAT(1) / 'OLD    ' / , FLSTAT(2) / 'NEW    ' /
      DATA FLSTAT(3) / 'CIF    ' / , FLSTAT(4) / 'SCRATCH' /
      DATA FLSTAT(5) / 'UNKNOWN' /
      DATA FLFORM(1) / 'FORMATTED  ' / , FLFORM(2) / 'UNFORMATTED' /
      DATA FLSQDA(1) / 'SEQUENTIAL ' / , FLSQDA(2) / 'DIRECT     ' /
C
C
C
C
C -- CHECK DATA TO SOME EXTENT

      IF ( IFSTAT .GT. NFLSTT) GOTO 9910
      IF ( IFMODE .GT. ISSAPP ) GO TO 9910
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
       IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
        WRITE(NCWU,1006) IUNIT, filnam
1006    FORMAT('SPECIFIC  Closing File       ',8x, ': Unit =',I8,1X,A)
       ENDIF
      ENDIF
1000    CONTINUE
C
c      NAMLEN = MAX (INDEX( FILNAM, ' ')-1, 0)
      NAMLEN = len_trim(FILNAM)
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
2000  CONTINUE
C

      IF ( IFMODE .EQ. ISSREA ) GO TO 2500

      IF ( FILNAM .EQ. ' ' ) THEN
        OPEN ( UNIT   = IUNIT ,
     1         STATUS = ACSTAT ,
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
       IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
        WRITE(NCWU,1007) IUNIT
1007    FORMAT('SPECIFIC  Openinging File    ',8x, ': Unit =',I8,1X,A)
       ENDIF
      ELSE
        CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)
        OPEN ( UNIT   = IUNIT ,
     1         FILE   = CLCNAM(1:NAMLEN),
     1         STATUS = ACSTAT ,
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
       IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
        WRITE(NCWU,1007) IUNIT, clcnam(1:namlen)
       ENDIF
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
      IF ( FILNAM .EQ. ' ' ) THEN
        OPEN ( UNIT   = IUNIT ,
     1         STATUS = ACSTAT ,
     1         ACTION ='READ',
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
       IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
        WRITE(NCWU,1007) IUNIT
       ENDIF
      ELSE
        CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)
        OPEN ( UNIT   = IUNIT ,
     1         FILE   = CLCNAM(1:NAMLEN),
     1         STATUS = ACSTAT ,
     1         ACTION ='READ',
     1         FORM   = CFORM ,
     1         ACCESS = FLSQDA(ISEQDA) ,
     1         IOSTAT = IOS ,
     1         ERR    = 3000 )
       IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
        WRITE(NCWU,1007) IUNIT, clcnam(1:namlen)
       ENDIF
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
      IF ( IOS .NE. ISSFNF ) GO TO 9900
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
C    BE OPENED . 
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
C                    'READ' IMPLIES READONLY,SHARED IS IGNORED
C
C -- RETURN VALUES :-
C
C            -VE         FAILURE ( RETURNS IOSTAT VALUE )
C            +VE         SUCCESS
C
      use hdf5_dsc
      
      logical lexist, ierr
C
      INTEGER IDUNIT , IFSTAT , IFMODE
      CHARACTER*(*) CFNAME
      CHARACTER *256 CLCNAM, FILNAM
      character *10 cnumber
C
C
      CHARACTER*7 FLSTAT(4)
      CHARACTER*7 ACSTAT
      character(len=9) :: faction 
      integer recordsize, iposition
      integer     ::   error ! error flag
      type(t_dsc_hdf5), pointer :: crfile

      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'


      DATA FLSTAT / 'OLD    ' , 'NEW    ' , 'CIF    ','SCRATCH' /
      data cnumber/'0123456789'/
      CLCNAM =  ' '
      FILNAM = CFNAME
      ! inquire the physical i/o record length, this values is specific to compilers
      ! Used with ISSDAR
      inquire(iolength=recordsize) 1.0

      NAMLEN = len_trim(FILNAM) 
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
      IF ( IFSTAT .GT. ISSSCR .or. IFMODE .GT. ISSWRI ) then
        CALL XOPMSG ( IOPCRY , IOPcmi , 0 )
      !GO TO 9900
        KDAOPN = ISIGN ( IOS , -1 )
        RETURN
      end if

C -- SET REQUIRED STATUS TO THAT SPECIFIED
      ACSTAT = FLSTAT(IFSTAT)
C -- IF REQUEST IS 'CIF' SET STATUS TO 'OLD'
      IF ( ACSTAT .EQ. 'CIF' ) ACSTAT = 'OLD'

      ! expand file name to full path
      IF ( IFSTAT .NE. ISSSCR ) CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)

C      if a 'new' file already exists, increment file number if possible
C      if not return a error message
      IF ((FLSTAT(IFSTAT) .EQ. 'NEW' ) .AND. (FILNAM .NE. ' '))THEN
        lexist = .false.
        inquire(file=clcnam(1:namlen), exist=lexist)
c
cdjwapr08 - autoincrement file root
!2010   continue
        do while(lexist) !if (lexist) then
       
          write(cmon,'(a,a,a)')
     1      ' The D/A file ( ', clcnam(1:namlen) ,
     2      ' )already exists'
          call xprvdu(nceror, 1, 0)
          if (issprt .eq. 0) write (ncwu, '(A)' ) CMON(1)
c
          ierr=.false.
          i =index(clcnam(1:namlen),'.')-1
          if (i > 0) then
            j =index(cnumber, clcnam(i:i))
            if (j .eq. 10) then
              write(cmon,'(a)')
     1        ' Only 9 generations permitted'
              call xprvdu(nceror, 1, 0)
              if (issprt .eq. 0) write (ncwu, '(A)' ) CMON(1)
              ierr=.true. !goto 9920
            else            
              if (j .le. 0) then ! no number in name, inserting one
                do k  = namlen, namlen-3, -1
                  clcnam(k+2:k+2)= clcnam(k:k)
                enddo
cdjwjan09 - replace # with -
                clcnam(i+1:i+2)='-0'
                namlen=namlen+2
              else ! incrementing file number
                clcnam(i:i)=cnumber(j+1:j+1)
              endif          
            endif
          else ! Cannot find ".", not a valid file name
            ierr=.true. !goto 9920
          end if
        
          if(ierr) then
            CALL XCTRIM(CLCNAM, ILEN)
            write(cmon,'(a,a,a)')
     1        ' The D/A file ( ', clcnam(1:ILEN) ,
     2        ' )already exists and cannot be overwritten'
            CALL XPRVDU(NCEROR, 1, 0)
            IF (ISSPRT .EQ. 0) WRITE (NCWU, '(a)' ) cmon(1)
C -- INTERNAL ERROR DETECTED
            CALL XOPMSG ( IOPCRY , IOPcmi , 0 )
            !GO TO 9900
            KDAOPN = ISIGN ( IOS , -1 )
            RETURN
          end if
        
          inquire(file=clcnam(1:namlen), exist=lexist) ! Is the new file exist?
          
        end do !if (lexist ) goto 2010
        
        write(cmon,'(a,a,a)')
     1    ' A new D/A file ( ', clcnam(1:namlen) ,
     2    ' )will be created'
        CALL XPRVDU(NCEROR, 1, 0)
        IF (ISSPRT .EQ. 0) WRITE (NCWU, '(a)' ) cmon(1)
      endif ! end check for non existent 'new' file
c
c
      ! setting up action mode, read or read/write
      IF ( IFMODE .EQ. ISSREA ) then !GO TO 2500
      ! open file for read only (action='read')
        faction='READ'
      else
        faction='READWRITE'
      end if
      
      !print *, 'Opening unit ', idunit, ' filename ', trim(clcnam)
      
      !2500  CONTINUE
      IF ( FILNAM .EQ. ' ' ) THEN
        ! read only scratch file, surely this must be a mistake?
        OPEN ( UNIT   = IDUNIT ,
     1         ACTION = faction, 
     1         STATUS = ACSTAT ,
     1         ACCESS = 'DIRECT' ,
     1         FORM   = 'UNFORMATTED' ,
     1         RECL   = ISSDAR*recordsize ,
     1         IOSTAT = IOS )

      ELSE
        CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)
        !print *, 'idunit ', idunit, trim(clcnam)
        
        ! dsc filename is not always specified
        ! hack to do part of the job of mtrnlg before mtrlng refactoring
        iposition=index(CLCNAM, 'CRDSC:')
        if(iposition>0) then
          CLCNAM=CLCNAM(1:iposition-1)//'crfilev2.dsc'//
     1      CLCNAM(iposition+6:len_trim(clcnam))
        end if
        
        if(hdf5_in_use) then
          iposition=index(CLCNAM, '.dsc')
          if(iposition==0) iposition=index(CLCNAM, '.DSC')
          if(iposition>1) then
            CLCNAM(iposition:iposition+3)='.h5 '
          end if
        end if
        
        ! check if an 'old' file do exist, otherwise open it as 'new'
        ! only if the file is "create if not exist"
        if (trim(CLCNAM)/='' .and. FLSTAT(IFSTAT)=='CIF') then         
          inquire(file=trim(CLCNAM), exist=lexist)
          if(.not. lexist) then
            ACSTAT = FLSTAT(ISSNEW)
            IF (IFSTAT .NE. ISSSCR) CALL MTRNLG(CLCNAM,ACSTAT,NAMLEN)
          end if
        end if

        if(hdf5_in_use .and. iposition>1) then
          !print *, 'kdaopn: in hdf5 backend ', trim(CLCNAM)

          call hdf5_dsc_open(crfile, trim(CLCNAM), ios)
          crfile%idunit=idunit
          !call printdic()
          !if(ios/=0) then
          !  print *, 'Error in hdf5_dsc_open'
          !end if
        else          
          OPEN ( UNIT   = IDUNIT ,
     1         FILE   = CLCNAM ,
     1         ACTION = faction,
     1         STATUS = ACSTAT ,
     1         ACCESS = 'DIRECT' ,
     1         FORM   = 'UNFORMATTED' ,
     1         RECL   = ISSDAR*recordsize ,
     1         IOSTAT = IOS )
        end if
     
      ENDIF

      IF (IOS/=0) then !GOTO 3000
c3000  CONTINUE
C
C -- OPEN FAILED -- 
C
        KDAOPN = ISIGN ( IOS , -1 )
        RETURN          
      end if
C -- SUCCESS

C -- IF A NEW FILE HAS BEEN CREATED, SOME INITIALISATION TASKS
C    MUST BE PERFORMED IMMEDIATELY

      IF ((ACSTAT.EQ.'NEW').OR.(ACSTAT.EQ.'SCRATCH')) then
        !print *, 'init ', acstat
        call XDAINI(IDUNIT)
      end if
    
      KDAOPN = 1
      END function
C
CODE FOR KFLCLS
      FUNCTION KFLCLS ( IUNIT )
      use hdf5_dsc
C
C -- CLOSE THE FILE OPEN ON UNIT 'IUNIT'. THIS ROUTINE IGNORES ERRORS
C    AND ALWAYS RETURNS THE VALUE 1
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      CHARACTER*31 FNAME
      LOGICAL LNAME

      integer error
      type(t_dsc_hdf5), pointer :: crfile
      
C

      call hdf5_dic_get(crfile, IUNIT, error)
      !print *, 'hdf5 search dic', error
      if(error/=0) then
        CLOSE ( UNIT = IUNIT , ERR = 2000 )
        IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
          INQUIRE ( UNIT = IUNIT, NAME = FNAME, NAMED = LNAME)
          IF (.NOT. LNAME) FNAME = ' '
          WRITE(NCWU,1006) IUNIT, fname
1006      FORMAT('SPECIFIC  Closing File       ',8x, ': Unit =',I8,1X,A)
        ENDIF

2000    CONTINUE
      else
        call hdf5_dsc_close(crfile, error)  
      end if
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
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XIOBUF.INC'
C
      DATA ACTION(1) / '          ' /
      DATA ACTION(2) / 'abandoned ' /
      DATA ACTION(3) / 'closed    ' /
C
      IF ( IFUNC .EQ. 1 ) THEN
        ILSTLV = 1
#ifdef _PRI_ 
      ISSSTA = 0
#endif
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
1006   FORMAT('SPECIFIC  Closing File index=',I8, ': Unit =',I8,1X,A)
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
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'CAMBLK.INC'
C
C>DJWOCT96
      IF (IUNIT .EQ. NCVDU) THEN
        WRITE ( CMON,1005) TEXT
        CALL XPRVDU(NCVDU, 1, 0)
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
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XDRIVE.INC'
      INCLUDE 'XIOBUF.INC'
#ifdef __MAC__ 
      DATA CLOCK / '|', '/', '-', '\\' /
#else
      DATA CLOCK / '|', '/', '-', '\' /

#endif
       ICLOCK = 1 + MOD (J,4)
C
      RETURN
      END

CODE FOR SLIDER
      SUBROUTINE SLIDER (IVALUE, MAXVAL)
C----- DRAW A SLIDER TO IVALUE % OF MAXVAL
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      PARAMETER(NINTER = 50)
      CHARACTER*(NINTER) CDISPL
C
      IPERCN = MIN0 ( 100 , ( 100 * IVALUE ) / MAXVAL )
      IF (ISSTML .EQ. 4) THEN
#ifdef CRY_GUI
         WRITE (CMON,1505) IPERCN
1505     FORMAT ('^^CO SET PROGOUTPUT COMPLETE = ',I3)
#endif
         CALL XPRVDU (NCVDU,1,0)
         RETURN
      ENDIF
      NSTAR = MIN0 ( NINTER, (NINTER * IVALUE ) / MAXVAL)
      CDISPL = ' '
      WRITE (CDISPL, 1510)  (IA , J = 1, NSTAR )
1510  FORMAT (50A1)
      IF (ISSTML .EQ. 3) THEN
          WRITE(NCVDU,'(A1,$)') IA
          RETURN
      ELSE
C----- GET A CARRIAGE RETURN, WITHOUT LINEFEED
          WRITE ( CMON,1515) IPERCN, CDISPL(1:NINTER) ,CHAR(13)
          CALL XPRVDU(NCVDU, 1, 0)
1515      FORMAT( '+', 10X, I4, 1X, A50,12X,A1)
C
      ENDIF
      RETURN
      END
C
CODE FOR XDAEND
      SUBROUTINE XDAEND ( IUNIT , LAST )
      use hdf5_dsc
C
C -- RETURNS NUMBER OF RECORD THAT WOULD FOLLOW THE LAST ACTUALLY
C    PRESENT IN A DISC FILE
C
C -- READS EACH RECORD FROM THE FILE UNTIL ONE READ FAILS. THIS IS
C    ASSUMED TO BE THE FIRST NON-EXISTANT RECORD.
C
      PARAMETER (NMXREC = 1 000 000)
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      
      type(t_dsc_hdf5), pointer :: crfile   
      integer error
C
C
      call hdf5_dic_get(crfile, IUNIT, error)
      !print *, 'xdaend hdf5 search dic: iunit, error', iunit, error
      if(error==0) then
          !print *, 'xdaend, hdf5 extending'
          call xdaend_hdf5 (crfile, last)
          !print *, 'last hdf5', last
      else

      J = NMXREC
      DO 2000 I = 1, J
C
      LAST = I
C
      READ ( IUNIT , REC = I , ERR = 3000, IOSTAT=IOS ) J
      IF (IOS .EQ. -1) GOTO 3000

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

      end if

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
C      0      NULL STRING
C      ELSE    LENGTH
C
      CHARACTER*(*) CPATH
      CHARACTER*256 CNAME
#ifdef _WIN32      
      character(len=2), parameter :: delimiter = '/\'
#else
      character, parameter :: delimiter = '/'
#endif
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XDISCS.INC'
C
      KPATH = 0
      CPATH = ' '
      
      IF (KFLNAM( NCDFU, CNAME) .GT. 0) THEN
        KPATH = scan(cname, delimiter, .true.)
        if(kpath>0) then
          CPATH(1:KPATH) = CNAME(1:KPATH)
        end if
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
      CHARACTER*32 CMODE
      CHARACTER*64 CSUBTX(3)
C
      COMMON /XSUBTX/ CSUBTX
      COMMON /XSUBLN/ LSUBTX(3)
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
C
      CMODE = ' '
C
      IF ( CMODE .EQ. 'BATCH' ) THEN
        IQUN = 3
        JQUN = 0
      ELSE IF ( CMODE .EQ. 'ONLINE' ) THEN
        IQUN = 2
        JQUN = 2
      ELSE
        IQUN = 1
        JQUN = 1
      ENDIF
      RETURN
      END
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
#ifdef CRY_FORTDIGITAL
      USE DFPORT
#endif
#ifdef CRY_FORTINTEL
      USE IFPORT
#endif
      REAL RTIME
      CALL CPU_TIME(RTIME)
      RETURN
      END
C
CODE FOR JTIME
C RICMAY99 ITIME is an intrinsic on some systems. Renamed JTIME.
      SUBROUTINE JTIME ( I )
      !! jtime returns the number of seconds since midnight
      implicit none
      integer, intent(out) :: i
      integer, dimension(8) :: values
      
      call date_and_time(values=values)
      I=values(5)*3600+values(6)*60+values(7)
      END
C
CODE FOR XTIMER
      SUBROUTINE XTIMER ( CTIME2 )
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
      INCLUDE 'XSSVAL.INC'
C
      CHARACTER*8 CTIME2
      integer, DIMENSION(8) :: ITIM

      IF ( ISSTIM .EQ. 2 ) THEN
        CTIME2=' '
        RETURN
      END IF
                      
      CALL date_and_time(values=ITIM)
      WRITE ( CTIME2, '(I2.2,'':'',I2.2,'':'',I2.2)' ) ITIM(5:7)
      END
C
CODE FOR XDATER
      SUBROUTINE XDATER ( CDATE )
C
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
      INCLUDE 'XSSVAL.INC'
C
      CHARACTER*8 CDATE
      DIMENSION IDAT(8)
      
      IF ( ISSTIM .EQ. 2 ) THEN
         CDATE = ' '
         RETURN
      END IF

      call date_and_time(values=idat)
      WRITE ( CDATE , '(I2.2,''/'',I2.2,''/'',I2.2)' ) IDAT(3) ,
     2      IDAT(2) , MOD ( IDAT(1) , 100 )
      END
C
CODE FOR KOR
      FUNCTION KOR ( I , J )
C
C -- THIS ROUTINE SHOULD PERFORM AN 'INCLUSIVE OR' OF 'I' AND 'J'
C
      KOR = IOR ( I , J )
      END
C
CODE FOR KAND
      FUNCTION KAND ( I , J )
C
C -- THIS ROUTINE PERFORMS AN 'AND' OF 'I' AND 'J'
C
      KAND = IAND ( I , J )
      END
C
CODE FOR XMOVE 
      SUBROUTINE XMOVE ( ISRCE , IRESLT , N )
      implicit none
C
C -- MOVES REALS, INTEGERS OR HOLERITHS FROM 'ISRCE'
C    TO 'IRESLT' WITHOUT TYPE CHECKING OR CONVERSION.
C
C    ISRCE and IRESLT are actually part of the same memory space 
C    through equivalence so the use of a temporary variable is compulsory
      integer, intent(in) :: N
      integer, dimension(N), intent(in) :: ISRCE 
      integer, dimension(N), intent(out) :: IRESLT
      integer, dimension(N) :: temp
      integer i
C
      temp=ISRCE
      IRESLT=temp
      END

C
CODE FOR XMOVEI (modern replacement)
      SUBROUTINE XMOVEI ( ISRCE , IRESLT , N )
      implicit none
C
C -- MOVES REALS, INTEGERS OR HOLERITHS FROM 'ISRCE'
C    TO 'IRESLT' WITHOUT TYPE CHECKING OR CONVERSION.
C    Code identical to XMOVE, different subroutine for historical reasons
C
C    ISRCE and IRESLT are actually part of the same memory space 
C    through equivalence so the use of a temporary variable is compulsory
      integer, intent(in) :: N
      integer, dimension(N), intent(in) :: ISRCE 
      integer, dimension(N), intent(out) :: IRESLT
      integer, dimension(N) :: temp
      integer i
C
      call XMOVE ( ISRCE , IRESLT , N )
      END
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
#ifdef CRY_FORTDIGITAL
      USE DFPORT
#endif
#ifdef CRY_FORTINTEL
      USE IFPORT
#endif
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
C
      IF ( INTERV .LE. 0 ) RETURN
C
      KTIME = FLOAT(INTERV) *.001
      CALL SLEEP (KTIME)
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
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      KFLCHR = 2
      IF ( IUNIT .NE. NCUFU(1) ) GO TO 9000
      IF ( IQUN .NE. JQUN ) GO TO 9000
      KFLCHR = 1
9000  CONTINUE
      RETURN
      END
C
CODE FOR XDETCH
      SUBROUTINE XDETCH ( COMMND )
#ifdef CRY_FORTDIGITAL
      USE DFPORT
#endif
C
C -- THIS SUBROUTINE EXECUTES A SYSTEM COMMAND IN A SEPARATE PROCESS.
C
C -- THIS ROUTINE IS ONLY REQUIRED BY THE 'FOREIGN PROGRAM LINK'
C    ROUTINES, WHICH ARE NOT ESSENTIAL TO THE PROPER OPERATION OF
C    THE PROGRAM. IT WOULD BE SUFFICIENT TO REPLACE THIS ROUTINE WITH
C    A DUMMY THAT IMMEDIATELY RETURNS CONTROL.
C
C
C -- ON THE VAX, THIS FUNCTION IS IMPLEMENTED USING THE 'SPAWN'
C    FACILITY, ACCESSED VIA THE RUN-TIME LIBRARY ENTRY-POINT
C    'LIB$SPAWN'. BEFORE THE SUBPROCESS IS CREATED, THE WORKING SET
C    OF THE PARENT IS 'PURGED' USING THE '$PURGWS' SYSTEM SERVICE
C    TO REDUCE PHYSICAL MEMORY USAGE.
C
C
C
      IMPLICIT INTEGER ( S )
      DIMENSION ILIMIT(2)
C
      CHARACTER*(*) COMMND
      CHARACTER*256 ACTUAL
      CHARACTER*256 CTEMP
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
C
C Pick out each word in COMMND (space separated) and pass it to MTRNLG,
C to check for environment labels.
C Add the returned string onto ACTUAL.
C ICS keeps track of position in COMMND, and ICA the position in ACTUAL

C Find last non-space.
      ICL = KCLNEQ ( COMMND, -1, ' ' )
      ICS = 1
      IAS = 1
      DO WHILE ( .TRUE. )
C Find next non-space.
         ICS = KCCNEQ ( COMMND, ICS, ' ' )
         IF ( ICS .LE. 0 ) GOTO 35
         IF ( COMMND(ICS:ICS) .EQ. '"' ) THEN !Find end quote
            ICE = KCCEQL ( COMMND, ICS+1, '"')
            IF (ICE.LE.0) THEN     !Handle unpaired quote.
              COMMND (ICS:ICS) = ' '
              ICS = ICS + 1
              ICE = KCCEQL ( COMMND, ICS, ' ' )
            END IF
            ICS = MAX(1,ICS)
            ICE = MAX(ICE,ICS+2)
            CTEMP = COMMND(ICS+1:ICE-1)
            ICS = ICE + 1
            CALL MTRNLG(CTEMP,'UNKNOWN',ILENG)
            ITM = KCLNEQ( CTEMP, -1, ' ' )
            IF (ITM.LE.0) GOTO 35
            ACTUAL (IAS:) = '"' // CTEMP(1:ITM) // '"'
            IF ( ICS.GT.ICL ) GOTO 35
            IAS = IAS + ITM + 3
         ELSE                         !Find end space
            ICE = KCCEQL ( COMMND, ICS, ' ' )
            IF (ICE.LE.0) GOTO 35
            CTEMP = COMMND(ICS:ICE-1)
            ICS = ICE + 1
            CALL MTRNLG(CTEMP,'UNKNOWN',ILENG)
            ITM = KCLNEQ( CTEMP, -1, ' ' )
            IF (ITM.LE.0) GOTO 35
            ACTUAL (IAS:) = CTEMP(1:ITM)
            IF ( ICS.GT.ICL ) GOTO 35
            IAS = IAS + ITM + 1
         END IF
      END DO
35    CONTINUE
      COMMND = ACTUAL

C Now run command

#if defined(CRY_GUI)
      CALL GDETCH(COMMND)
      RETURN
#elif defined(__DVF__) 
      IFAIL = SYSTEM(COMMND)
      IF (IFAIL .EQ. 0 ) RETURN
#elif defined(__LIN__) 
      CALL SYSTEM(COMMND,IFAIL)
      IF (IFAIL .EQ. 0 ) RETURN
#else
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1005 ) COMMND
      ENDIF
      WRITE ( NCAWU , 1005 ) COMMND
1005  FORMAT ( 1X , 'The following command line cannot be ' ,
     2 'executed in this implementation' , / ,
     3 1X , A , / )
#endif

      RETURN
      END
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
      PARAMETER (IIS = 4)
      INCLUDE 'XSCCHK.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'XMENUC.INC'
C
      INCLUDE 'XMENUI.INC'
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
      IMNFLG = 1
      JMNFLG = IMNFLG
      RETURN
      END
C
CODE FOR XMNINV
      SUBROUTINE XMNINV ( COLD, IOROW, IOCOL, CNEW, INROW, INCOL,
     1 MNISL, CDUM, IVD, IOFSET)
C----- RESTORE OLD ITEM TO NORMAL, HIGHLIGHT NEW
C
      CHARACTER *(*) COLD, CNEW, CDUM
      INCLUDE 'XSSVAL.INC'
C
      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) RETURN
      CDUM = CNEW
      RETURN
      END
C
CODE FOR XMENUR
      SUBROUTINE XMENUR (CPRMPT, MENPMT, CLINPB, LENLIN,
     1 CDEFLT, LDEFBF, IINPLN)
C
C----- DRAW A MENU BOX AND RETURN USERS SELECTION
C
      CHARACTER *(*) CDEFLT
      CHARACTER *(*) CLINPB
      CHARACTER *(*) CPRMPT
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XSCCHK.INC'
C
      INCLUDE 'XMENUC.INC'
      INCLUDE 'XMENUI.INC'
      INCLUDE 'XIOBUF.INC'
C
C
CRIC02      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) RETURN
C----- FIND NO LINES IN CURRENT MENU
      CALL XMNCR (NCHKUS, MNLICM, I, MNISL, MNWID)
C      FIND THE LINE AND COLUMN ADDRESSES
      CALL XMNADD ( MNLICM)
C
C----- RECOVER SCRIPT NAME
      ISTAT = KSCIDN (2, 3, 'SCRIPTNAME', 1, IS, IDSCP, ISCPNM, 1)
      ISTAT = KSCSDC ( ISCPNM, CSCPNM, LENNM)
      IF (CSCPNM .NE. CLSTNM) CPRVNM = CLSTNM
      CLSTNM = CSCPNM(1:LENNM)

cdjwjun07
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(a,a)' ) 
     1 'Testing',cscpnm(1:lennm)
      IF ( CPRVNM(1:3) .NE. CSPACE(1:3) ) THEN
      WRITE(CMON(1),'(5A)')
     1'Script: ',CSCPNM(1:LENNM),
     1   ' called from:', CPRVNM
      ELSE
      WRITE(CMON(1),'(3A)')'Script: ',
     1  CSCPNM(1:LENNM), ''''
      ENDIF
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(a)' ) cmon(1)(:)
cdjwjun07




C----- PUSH PLAIN TEXT UP TO MAKE ROOM FOR MENU
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
      DO 500 J = 1, MNLICM * MNIPL
        CALL XMNCR( J, IROW, ICOL, MNISL, MNWID)
C----- BLANK OUT THE MENU AND RE-WRITE IT
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
      MNKEY = 13
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
            ENDIF
C           RESTORE CURSOR
            RETURN
      ELSE
C----- NOT A CURSOR KEY - ADD INTO BUFFER - BEWARE NON-ASCII KEYS
C-----      BACKSPACE OR DELETE
            IF ( (MNKEY .EQ. 8) .OR. (MNKEY .EQ. 127))THEN
C             COMPUTE MESSAGE ADDRESS
              IMESC = ITXTR - 20 + J
              CLINPB(J:J) = ' '
C             DISPLAY CHOICE
              IF (J .GE. 1) J = J - 1
            ELSE
              J = J + 1
C             COMPUTE MESSAGE ADDRESS
              IMESC = ITXTR - 20 + J
              CLINPB(J:J) = CHAR(MNKEY)
C             DISPLAY CHOICE
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
      SUBROUTINE MTRNLG(FILNAM,STATUS,LENNAM)
#ifdef CRY_FORTDIGITAL
      USE DFPORT
#endif
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
      INTEGER MAXLVL
      PARAMETER (MAXLVL=30)
      CHARACTER*(*) FILNAM,STATUS
      LOGICAL LEXIST
      INTEGER KSTRLN
      INTEGER I,J,K,LEVEL,IWHAT
      INTEGER NAMLEN(MAXLVL),COLPOS(MAXLVL)
      INTEGER LSTLEN(MAXLVL),LSTPOS(MAXLVL)
      CHARACTER*200 INQNAM,NAME(MAXLVL),LIST(MAXLVL)
C
      INCLUDE 'TDVNAM.INC'
      INCLUDE 'XDVNAM.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
            
C
C NOW WE SEARCH FOR THE LENGTH OF OUR FILE NAME AND REMOVE BLANKS.
C
c      WRITE(6,*) 'MTRNLG:  Input="',FILNAM(1:KSTRLN(FILNAM)),
c     & '":',LEN(FILNAM),', Status="',STATUS(1:KSTRLN(STATUS)),'"'
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
#ifdef CRY_OSWIN32
      DO WHILE(.TRUE.)
        ISLP = KCCEQL(NAME(LEVEL),1,'/')
        IF ( ISLP .GT. 0 ) THEN
          NAME(LEVEL)(ISLP:ISLP) = '\'
        ELSE
          EXIT
        END IF
      END DO
#endif

c      WRITE(126,*) 'Looking for :', NAME(LEVEL)(1:NAMLEN(LEVEL))
C TEST IF SOMETHING CAN BE DONE

      IF(COLPOS(LEVEL).LT.3) THEN   

c        WRITE(126,*)'Inquiring: ',NAME(LEVEL)(1:NAMLEN(LEVEL))

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
c        write(126,*) 'File test ', LEXIST, IOTEST, INQNAM
        if( (iotest .eq. 0) .and. (LEXIST))  GOTO 9999
#ifdef __INW__ 
        INQUIRE(DIRECTORY=INQNAM,EXIST=LEXIST, iostat=iotest)
c        write(126,*) 'Dir test ', LEXIST, IOTEST, INQNAM
        if( (iotest .eq. 0) .and. (LEXIST))  GOTO 9999
#endif 
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
#if defined (CRY_FORTDIGITAL)
      CALL GETENV(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
#elif defined (CRY_FORTINTEL) && defined (CRY_GUI)
C The intel environment does not pick up changes made by _putenv in C++ code
C Therefore use this interface to the C++ to get values.
          CALL CGETENV(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
#else 
          call GETVAR(NAME(LEVEL)(1:COLPOS(LEVEL)-1), LIST(LEVEL))
c          call GET_ENVIRONMENT_VARIABLE(NAME(LEVEL)(1:COLPOS(LEVEL)-1),
c    &      LIST(LEVEL))
#endif
CNOV98 IF THERE IS NO ENVIRONMENT VARIABLE, CHECK THE PRESETS
        IF (LIST(LEVEL) .EQ. ' ') THEN
          IF (NAME(LEVEL)(1:COLPOS(LEVEL)-1) .EQ. 'CRMAN') THEN
            LIST(LEVEL) = CHLPDV(1:LHLPDV)
          ELSE IF (NAME(LEVEL)(1:COLPOS(LEVEL)-1) .EQ. 'CRSCP') THEN
            LIST(LEVEL) = CSCPDV(1:LSCPDV)
          ELSE IF (NAME(LEVEL)(1:COLPOS(LEVEL)-1) .EQ. 'CRDIR') THEN
#ifdef CRY_OSWIN32 
             LIST(LEVEL) = '.\'
#else
             LIST(LEVEL) = './'
#endif
          ENDIF
        ENDIF
        LSTPOS(LEVEL)=0
        LSTLEN(LEVEL)=KSTRLN(LIST(LEVEL))

c        WRITE(6,*) 'Environment ',LEVEL,'  "',
c     &    NAME(LEVEL)(1:COLPOS(LEVEL)-1),'"  = "',
c     &    LIST(LEVEL)(1:LSTLEN(LEVEL)),'"'
      ENDIF

C TEST LIST FOR SOMETHING TO PROCESS

3     CONTINUE

c      WRITE(6,*) 'Testing ',LEVEL,'  "',
c     &  NAME(LEVEL)(1:NAMLEN(LEVEL)),'"'

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

c         WRITE(6,*)
c     1 'Extracted     "',LIST(LEVEL)(J:LSTPOS(LEVEL)-1),'"'
        K=LSTPOS(LEVEL)-J
        NAME(LEVEL+1)(1:K)=LIST(LEVEL)(J:LSTPOS(LEVEL)-1)

c          WRITE(6,*)'Name="',NAME(LEVEL+1)(1:K),'"',J,K
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
c      WRITE(126,*) 'MTRNLG: Output="',FILNAM(1:LENNAM),'"'
c      WRITE(CMON,*) 'MTRNLG: Output="',FILNAM(1:LENNAM),'"'
c      CALL XPRVDU(NCVDU,1,0)
C
      RETURN
      END
C
CODE FOR KSTRLN
      FUNCTION KSTRLN(STRING)
      CHARACTER*(*) STRING
      INTEGER I,J
      J=0
      DO 1 I=1,LEN(STRING)
        IF((STRING(I:I).NE.CHAR(32)).AND.
     1     (STRING(I:I).NE.CHAR(0) ).AND.
     1     (STRING(I:I).NE.' '     ))  J=I
1     CONTINUE
      KSTRLN=J
      RETURN
      END
C      
CODE FOR FRAND
      real function frand()
c------ returns a value between 0 and 1 from the compiler library's
c       random number generator.

      call random_number(frand)
      end
          
CODE FOR XRAND
      real FUNCTION XRAND(REQVAR, ISEED)
C------ RETURNS A VALUE DISTRIBUTED ABOUT ZERO FROM A DISTRIBUTION
C       WITH VARIANCE REQVAR
C
C    REQVAR - REQUESTED VARIANCE OF RESULT
C    ISEED = 0 FOR REPEATED RANDOM NUMBERS
      integer n, i
      integer, dimension(:), allocatable :: seeds
      SAVE ISET, GSET

      DATA ISET /-1/

      IF (ISET .LE. -1) THEN
        ISET = 0

        call random_seed(size = n)
        allocate(seeds(n))
        IF (ISEED .EQ. 0) THEN
C----- REPEAT RANDOM SEQUENCE
          seeds=0
          call random_seed(put= seeds )
        ELSE
C----- CREATE NEW SEQUENCE
          do i=1, n
            ITIMEI = TIME()
            seeds(i) = MOD (ITIMEI,(2**30))
          end do
          call random_seed(put= seeds )
        ENDIF
        
      ENDIF
      
      
      IF (ISET .EQ. 0) THEN
1       V1 = 2. * FRAND() -1.
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
      INCLUDE 'XIOBUF.INC'
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
#ifdef _UNIX_ 
      CCRCHR(1:1) = CHAR(32)
      CCRCHR(2:2) = CHAR(10)
C
#endif
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
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
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

#if defined (CRY_FORTINTEL) && defined (CRY_GUI)
CODE FOR CGETENV
      SUBROUTINE CGETENV(CKEY, CVAL)
      INTERFACE
                SUBROUTINE GETCENV(CKEYA,CVALA)
					!DEC$ ATTRIBUTES C :: getcenv
                    CHARACTER*(*) CKEYA, CVALA
                    !DEC$ ATTRIBUTES REFERENCE :: CKEYA
                    !DEC$ ATTRIBUTES REFERENCE :: CVALA
                END SUBROUTINE GETCENV
      END INTERFACE
      CHARACTER*(*) CKEY, CVAL
      CHARACTER*262 CKA, CVA
      CKA=CKEY(1:LEN(CKEY))//CHAR(0)
      CVA=CVAL(1:LEN(CVAL))//CHAR(0)
      CALL GETCENV(CKA,CVA)
      CVAL = CVA
      END
#endif

CODE FOR XPRTDV
      SUBROUTINE XPRTDV(NCDEV, CBUF, LINBUF, NLINES)
C---- MACHINE SPECIFIC WRITE TO THE SCREEN
c#ifdef CRY_GUI
cC{
c      use fwrappergui_mod, only: CALLCCODE
cC}
c#endif
      INCLUDE 'XDRIVE.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'OUTCOL.INC'
      CHARACTER*(*) CBUF(LINBUF)
      CHARACTER*262 CEXTRA
      CHARACTER*1 CFIRST, CLAST
      CHARACTER*10 CFRMAT
      DATA CFRMAT /'(1X,A)'/

      CEXTRA = ' '
      LENBUF = LEN(CBUF(1))
#ifdef CRY_NOGUI
      IF ((ISSTML.NE.1) .AND. (ISSTML.NE.2)) THEN
         LENBUF = MIN(LENBUF,79)   !LINE LIMITED TO 79
      ENDIF
#endif

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
c         if defined(__GIL__)  || defined(__MAC__) ||defined (__INW__)
#ifdef CRY_GUI
               N = MIN(N,256)         ! SET N TO LAST NON-BLANK
               CBUF(J)(N+1:N+1) = CHAR(0) ! Make into a c string.
			   N = N + 1
c			   WRITE(123,*)'INW version', N
#endif

#ifdef CRY_GUI
       IF (CBUF(J)(2:2).NE.'^') THEN
          IF ((IOFORE.EQ.-1).OR.(IOBACK.EQ.-1)) THEN
             WRITE( CEXTRA,'(A)') CBUF(J)
          ELSE 
             WRITE( CEXTRA,'(2(A,I2.2),A)')
     1       '{', IOFORE, ',', IOBACK, CBUF(J)
	         N = N + 6
          ENDIF 
       ELSE 
          WRITE( CEXTRA,'(A)') CBUF(J) !Line not limited (^^ command)
       END IF
#endif

c       WRITE(123,'(2A)') 'Input:  ',CBUF(J)
c       WRITE(123,'(2A)') 'Output: ',CEXTRA
c       WRITE(123,'(A,I5)') 'N: ',N

       IF (CLAST .EQ. CHAR(13)) THEN !--- NO CR OR LF
#ifdef CRY_GUI
            CALL fcallc ( CEXTRA(1:N))
#else
            WRITE(NCDEV ,CFRMAT) CBUF(J)(1:N)
#endif
        ELSEIF ( CFIRST .EQ. '+' ) THEN !--FORTRAN CR WITHOUT LF
            CFRMAT = '(A)'
#ifdef CRY_NOGUI
            WRITE(NCDEV ,'(A,$)') char(13)
            WRITE(NCDEV ,'(A,$)') CBUF(J)(2:LENBUF)
#endif
        ELSEIF (CLAST .EQ. '$') THEN !--- LEAVE CURSOR AT CURRENT POSITION
                CFRMAT = '(A,A1)'
#ifdef CRY_GUI
            CALL fcallc ( CEXTRA(1:N) )
#endif
               ELSEIF ( CFIRST .EQ. '0' ) THEN
                    CFRMAT = '(/,A)'
#ifdef CRY_NOGUI
            WRITE(NCDEV ,CFRMAT) CBUF(J)(1:LENBUF)
#else 
            CALL fcallc ( CEXTRA(1:N))
#endif
               ELSE
                    CFRMAT = '(A)'
#ifdef CRY_NOGUI
            WRITE(NCDEV ,CFRMAT) CBUF(J)(1:LENBUF)
#else
            CALL fcallc ( CEXTRA(1:N))
#endif
               ENDIF
C
               CBUF(J) = ' '
100         CONTINUE
400         FORMAT(A)
      ENDIF
      RETURN
      END


#ifdef CRY_GUI
CODE FOR GDETCH
      SUBROUTINE GDETCH(CLINE)
c      use fwrappergui_mod, only: GUEXEC
      CHARACTER*(*) CLINE
      CHARACTER*262 CEXTRA
      INTEGER RET
      CEXTRA = ' '
      WRITE(CEXTRA,'(A)')CLINE
      RET = FWEXEC ( CEXTRA//CHAR(0) )
	  
      RETURN
      END
#endif



CODE FOR GETCWD
      SUBROUTINE GETCWD ( CWORK )
#if defined(CRY_FORTDIGITAL)  || defined (CRY_FORTINTEL)
      USE DFLIB
#endif
      CHARACTER*(*) CWORK

#if defined(CRY_FORTDIGITAL)  || defined (CRY_FORTINTEL)
      cwork = FILE$CURDRIVE
      K= GETDRIVEDIRQQ(cwork)
#else
      CWORK='.' !For now
#endif
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
#ifdef CRY_FORTDIGITAL
      USE DFPORT
#endif
#ifdef CRY_FORTINTEL
      USE IFPORT 
#endif
C--SET THE # SECS SINCE 1970 IN ISECS
      ISECS = TIME()
      RETURN
      END

CODE FOR XCDATE
      SUBROUTINE XCDATE(ISECS,CT)
#ifdef CRY_FORTDIGITAL 
      USE DFPORT
#endif
#ifdef CRY_FORTINTEL 
      USE IFPORT
#endif
C--CONVERT SECS SINCE 1970 INTO 24CHAR STRING
C e.g. "Fri Sep 07 04:37:23 2001"

      INCLUDE 'XSSVAL.INC'
      CHARACTER*24 CT
      IF (ISSTIM .EQ. 2 ) THEN
       CT = ' '
      ELSE
       CT = CTIME(ISECS)
      END IF

      RETURN
      END

