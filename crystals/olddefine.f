C $Log: not supported by cvs2svn $
C Revision 1.17  2003/05/07 12:18:53  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.16  2003/01/16 11:32:07  rich
C Cosmetic changes - more useful output during DSC building, and pauses at
C the end.
C
C Revision 1.15  2001/02/26 10:25:31  richard
C Added changelog to top of file
C
C
CODE FOR DEFINE
#if !defined(GID) && !defined(GIL) && !defined(WXS) 
      PROGRAM DEFINE
#else
      SUBROUTINE CRYSTL
C
C      ***************************************************************
C
C      THIS IS THE MASTER FOR 'DEFINE'. IT CONVERTS THE ASCII FILE
C      COMMANDS.SRC INTO THE SYSTEM DATA BASE COMMANDS.DSC
C
C      ***************************************************************
C
C
C             THE NAME OF THE STARTUP FILE MAY EITHER BE SET AS
C             DATA IN PRESETS, OR IN AN ASSIGNMENT BELOW.
C
#endif
      INCLUDE 'TSSCHR.INC'
C
      INCLUDE 'XDISC.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XDRIVE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSSCHR.INC'
C
      INCLUDE 'XIOBUF.INC'
#if defined(PPC) 
\XGSTOP
\CFLDAT
C**** Commented out for Mac OS, COMMON must be in the same module
C**** 13.11.1995 Ludwig Macko
C****
#else
      EXTERNAL CRYBLK
C
#endif
      DATA IN / 0 /
C
#if defined(VAX) 
      CCRCHR(1:1) = CHAR(13)
      CCRCHR(2:2) = CHAR(10)
#endif
#if defined(PPC) 
      CCRCHR(1:1) = CHAR(32)
      CCRCHR(2:2) = CHAR(13)
      CALL envini
      CALL cabout
      DISKOP = 0
      GLSTOP = 0
C -- ASSIGN AND OPEN STARTUP CONTROL FILE - CSSCST AND LSSCST
C    ARE SET IN BLOCK DATA IN PRESETS. THE LOGICAL NAME MAT BE
C    EXPANDED
#else
      CALL MTRNLG ( CSSDST, 'OLD', LSSDST)
C----- ALTERNATIVELY, THAY CAN BE SET HERE
C      CSSDST = '\CRYSTALS\SRT\DEFINE.SRT'
C      LSSDST = 24
C
C---- NOV98 - MYDRIVE NOT PERMITTED WITH WINDOWS

C
#endif
      IF ( ISSSFI .GT. 0 ) THEN
        ISTAT = KFLOPN ( NCRU ,CSSDST(1:LSSDST),ISSOLD,ISSREA,1,ISSSEQ)
        IF ( ISTAT .LE. 0 ) THEN
            CALL XERIOM ( NCRU , ISTAT )
            WRITE(*,*) 'UNIT =', NCRU, 'FILE =', CSSDST
C            STOP 'ERROR OPENING STARTUP FILE'
            CALL GUEXIT(2003)
        ENDIF
      ENDIF
C
C----- IF A STARTUP FILE IS USED, THIS WILL CREATE A DISK ON UNUT NCDFU
      NCDFU = NCIFU
      ISTAT = KRDREC ( IN )
C
C -- ALL REFERENCES ARE TO THE NEW COMMAND FILE
C
      NU = NCIFU
C
C -- CREATE NEW FILE, AND EXTEND TO 125 RECORDS
C----- CREATE A NEW FILE
C
      ISTAT = KDAOPN ( NCIFU , CSSCMD(1:LSSCMD) , ISSNEW , ISSWRI )
      IF ( ISTAT .LT. 0 ) THEN
        CALL XERIOM ( NCIFU , ISTAT )
C        STOP 'CANNOT CREATE FILE'
         CALL GUEXIT (2005)
      ENDIF
C --
      CALL XDAXTN ( NCIFU, -1, 120)
C
      WRITE ( CMON, 1000 )
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
1000  FORMAT(' Create command file')
      CALL XSYSDC(-1,-1)
C------ ENSURE THAT ALL TRANSFERS ARE TO THE COMMAND FILE DISC
      NU=NCIFU


      CALL XRDHI(IFIRST)

      WRITE ( CMON, 1001 )
      CALL XPRVDU(NCVDU,6,0)
1001  FORMAT(//' Command file created successfully.'/
     1         'Closing in 4 seconds'/)
      CALL XPAUSE (4000)


C----- PRINT EVERYTHING
      ISTOP =-1
CNOV98 - COMMENT OUT NEXT LINE TO PREVENT I/O
C      CALL  XPRTHI(-1,IFIRST,ISTOP)
      CALL XEND
C----- DUMMY STOP TO INCLUDE VARIOUS ENTRIES
      I=KNXTOP(I,J,K)
C      STOP 'WRITE ERROR'
      CALL GUEXIT(2006)
      END
#if defined(PPC) 
C
C**** **************************************************************
C
C     MACINTOSH SPECIFIC CODE FOR CRYSTALS
C
C**** **************************************************************
C
      SUBROUTINE SETNAM ( theName, MYLENGTH )
C
      CHARACTER*31 theName
      INTEGER    MYLENGTH
C
      INCLUDE 'CFLDAT.CMN'
C
      LFNAME(1) = MYLENGTH
      FLNAME(1) = theName(1:MYLENGTH)
C
      LFNAME(9) = MYLENGTH + 4
      FLNAME(9) = theName(1:MYLENGTH)
      FLNAME(9)(MYLENGTH+1:MYLENGTH+4) = ' new'
C
      LFNAME(2) = LFNAME(1)
      FLNAME(2) = FLNAME(1)
C
      LFNAME(4) = LFNAME(1)
      FLNAME(4) = FLNAME(1)
C
      LFNAME(5) = LFNAME(1)
      FLNAME(5) = FLNAME(1)
C
      LFNAME(6) = LFNAME(1)
      FLNAME(6) = FLNAME(1)
C
      LFNAME(7) = LFNAME(1)
      FLNAME(7) = FLNAME(1)
C
      LFNAME(23) = LFNAME(1)
      FLNAME(23) = FLNAME(1)
C
      LFNAME(24) = LFNAME(1)
      FLNAME(24) = FLNAME(1)
C
      RETURN
      END
C
C
CODE FOR GDKIND
C      SUBROUTINE GDKIND (IUNIT, IDKIND )
      SUBROUTINE GDKIND (IUNIT, IDKIND, LENNAM, FILNAM )
C
      CHARACTER*64 CSSCST
C
\UFILE
\XDISCS
\XUNITS
\XCARDS
\XTAPES
C
\XSSCHR
C
      INTEGER   IUNIT, IDKIND, FL, CUTPOS, LENNAM
      CHARACTER*64 FILNAM, TEMP
C
C      1    for the Crystals folder within the preferences folder
C
C      2    for the home directory of the Crystals application
C
C      3    for the home directory of the structure DISK file
C
C      4    for the temporary directory while using a file input,
C           which has been prevously determined
C
C      5    for the scripts directory usually called CRSCP
C
C      6    for the help and manual directory usually called CRMAN
C
      IDKIND = 4
      CUTPOS = 0
C
      IF ( (IUNIT .EQ. NCSU)  .OR. ! SYSTEM SPY FILE
     1     (IUNIT .EQ. NUSRQ) .OR. ! SYSTEM REQUEST QUEUE
     1     (IUNIT .EQ. NCCBU) .OR. ! SEGM. SYS COMMON BLOCK FILE
     1     (IUNIT .EQ. NCQUE) .OR. ! SCRIPT QUEUE
     1     (IUNIT .EQ. NCEXTR).OR. ! EXTRACT FILE
     1     (IUNIT .EQ. MTA)   .OR. ! INTERMEDIATE AND WORK FILES
     1     (IUNIT .EQ. MTB)   .OR. ! INTERMEDIATE AND WORK FILES
     1     (IUNIT .EQ. MTE)   .OR. ! INTERMEDIATE AND WORK FILES
     1     (IUNIT .EQ. MT1)   .OR. ! INTERMEDIATE AND WORK FILES
     1     (IUNIT .EQ. MT2)   .OR. ! INTERMEDIATE AND WORK FILES
     1     (IUNIT .EQ. MT3)    )   ! INTERMEDIATE AND WORK FILES
     1      THEN
             IDKIND = 1
      ENDIF
C
      IF ( (IUNIT .EQ. NCIFU) .OR. ! COMMANDS
     1     (IUNIT .EQ. NCLDU) .OR. ! COMMANDS
     1     (IUNIT .EQ. NUCOM)  )   ! COMMAND FILE SOURCE
     1      THEN
             IDKIND = 2
      ENDIF
C
      IF ( (IUNIT .EQ. NCDFU) .OR. ! DISCFILE
     1     (IUNIT .EQ. NCRRU) .OR. ! DISCFILE
     1     (IUNIT .EQ. NCNDU) .OR. ! NEWDISC
     1     (IUNIT .EQ. NCWU)  .OR. ! PRINTER
     1     (IUNIT .EQ. NCARU) .OR. ! AUXILLIARY INPUT DEVICE
     1     (IUNIT .EQ. NCPU)  .OR. ! PUNCH
     1     (IUNIT .EQ. NCLU)  .OR. ! LOG
     1     (IUNIT .EQ. NCFPU1).OR. ! FOREIGN PROGRAM LINKS
     1     (IUNIT .EQ. NCFPU2) )   ! FOREIGN PROGRAM LINKS
     1      THEN
             IDKIND = 3
      ENDIF
C
C Now we have to check, if there is a logical covered in the name,
C which will override the setting above
C
      FL = LENNAM
      IF ( FL .GT. 2 ) THEN
          DO 90 I=3,FL-1
              IF ( FILNAM(I:I) .EQ. ':' ) CUTPOS = I
90        CONTINUE
          IF ( CUTPOS .GT. 0 ) THEN
                IF ( FILNAM(1:CUTPOS) .EQ. 'CRSCP:'
     +          .OR. FILNAM(1:CUTPOS) .EQ. 'crscp:' ) THEN
                     IDKIND = 5
                     TEMP = FILNAM
                     FILNAM = TEMP(CUTPOS+1:FL)
CDEBUG       write(6,'(A)') '-- I will set the CRSCP directory..'
                ENDIF
                IF ( FILNAM(1:CUTPOS) .EQ. 'CRMAN:'
     +          .OR. FILNAM(1:CUTPOS) .EQ. 'crman:' ) THEN
                     IDKIND = 6
                     TEMP = FILNAM
                     FILNAM = TEMP(CUTPOS+1:FL)
CDEBUG       write(6,'(A)') '-- I will set the CRMAN directory..'
                ENDIF
          ENDIF
      ENDIF
C
C If its the startup file its a special directory
C
      IF ( FILNAM(1:12) .EQ. 'CRYSTALS.SRT' ) IDKIND = 2
C
      RETURN
C
      END
C
C
CODE FOR GINDEX (Get File Number from Unit number)
      SUBROUTINE GINDEX ( IUNIT, FILNUM )
C
      INTEGER IUNIT, FILNUM, I
C
\UFILE
C
      DO 100 I=1,35
         IF ( IFLUNI( I ) .EQ. IUNIT ) THEN
             FILNUM = I
         ENDIF
100   CONTINUE
      RETURN
C
      END
C
C
C
      SUBROUTINE SETSTA( theText )
C
      CHARACTER*(*)  theText
      CHARACTER*20   theStatus
      INTEGER        theLength
C
      theLength = LEN( theText )
      theStatus = theText(1:theLength)
      CALL setsta( theStatus )
C
      RETURN
      END
C
C
      SUBROUTINE SFINFO( theFile, theType )
C
      CHARACTER*(*)  theFile
      CHARACTER*32   theFName
      INTEGER        theLength, theType
C
      theLength = LEN( theFile )
      theFName = theFile(1:theLength)
      CALL sfinfo( theLength, theType, theFName )
C
      RETURN
      END

#endif
