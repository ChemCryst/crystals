C $Log: not supported by cvs2svn $
C Revision 1.22  2006/03/14 18:02:34  arie
C SLight cosmetic change for archive and retrieve option
C
C Revision 1.22  2006/03/14 17:59:29  arie
C SLight cosmetic change for Archive and Retrieve
C
CRYSTALS CODE FOR OUTER.FOR
CAMERON CODE FOR OUTER
CODE FOR ZCAMER
C      SUBROUTINE ZCAMER ( ITYPE , RCRYST, NSTORE , IDEVIC)
      SUBROUTINE ZCAMER ( ITYPE , ICAMS, ICAMF, IDEVIC)

      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'CAMIMN.INC'
C      REAL RCRYST(NSTORE)
CDJW99 this upsets FTN95      EXTERNAL ZBLOCK
      LOGICAL LEXIST
#if defined(_DOS_)
      INCLUDE 'CAMWIN.INC'
      character*80 caption
C ---- some initialisation
      ikeym(1)=0
      ikeym(2)=0
      ikeym(3)=0
      ikeym(4)=0
      font=1
      italic=0.
      rotation=0.
C Not used anymore.
C&DOS      Status$Text=' '
      Cursor$Number=1
      call GetWindowSize(xwin,ywin)
      size=0.9*float(xwin)/640.
      iy=ywin-65
C ---- CAMERON still functions internally in the VGA graphics
C      space of 640x480. scale_X/scale_Y are the scaling values
C      corresponding to the current Windows resolution. The
C      parameters for all graphics primitive are scaled up when
C      drawing, conversely the reported coordinates from mouse
C      clicks are scaled down when returned to program. This
C      provides a simple but effective way of coping with
C      different screen resolutions. The scaling is done in the
C      routines in SPECIFIC.FOR
      scale_X=float(iy)/480.
      scale_Y=scale_X
      ix=nint(640.0*scale_X)
C ---- open I/O and graphics windows
      caption='CAMERON Dialog Window'
C      call CreateIOWindow(caption,DialogHandle)
      call CreateGraphicsWindow(ix,iy)

#endif
      LINPMN = .FALSE.     
      ICAMER = ITYPE
c      IF (ICAMER.LT.2) THEN
C SET UP FLAG POSITIONS FOR LARGE VERSION OF CAMERON
CDJWSEP2000  SET UP DATA SIZES SO THAT POINTERS CAN BE
C      MORE EASILY UPDATED.
C        JCOORD = 13
C   INCREASE TO MAKE ROOM FOR GROUP AND NAME VALUES
C        JCOORD = 15
CNOV2000   INCREASE AGAIN FOR RICHARDS WORK
        JCOORD = 19
        JPCK = 2
        JXYZO = 16
        JATTYP = 9
        JBOND = 2
        JLAB = 5
        JSYM = 2
C
C        IPCK = 14
C        IXYZO = 16
C        IATTYP = 32
C        IBOND = 41
C        ILAB = 43
C        ISYM = 48
cdjwjan99 - make room for the shape flag
c        IPACKT = 49 + 1
C  COMPUTE THE ADDRESSES INSTEAD
        IPCK = 1+JCOORD
        IXYZO = IPCK + JPCK
        IATTYP = IXYZO + JXYZO
        IBOND = IATTYP + JATTYP
        ILAB = IBOND + JBOND
        ISYM = ILAB + JLAB
        IPACKT = ISYM + JSYM
c      ELSE
C SET UP FLAG POSITIONS FOR SMALL VERSION OF CAMERON
CDJW SEP 2000 NOT YET UPDATED - MAY BE OBSOLETE?
c        IXYZO = 4
c        IPCK = 12
c        IATTYP = 7
c        ILAB = 16
c        IBOND = 14
c        ISYM = 0
c        IPACKT = 19
c      ENDIF
      IRLAST = 1
      CALL ZINIT
c      IF (ICAMER.LT.2) THEN
C        CALL ZMNINI
        IF (IPCX.EQ.1) THEN
          ID = 1
          CALL ZCMD11 ( ID )
          CALL ZMORE('Setting SCREEN to VGA',0)
          IPCX = 0
        ENDIF
C CHECK IF THERE IS A CAMERON.INI
        INQUIRE (FILE='CAMERON.INI',EXIST=LEXIST)
        IF (LEXIST) THEN
          CALL ZMORE('Reading from CAMERON.INI',0)
          CALL ZMORE1('Reading from CAMERON.INI',0)
          CTCOMD(1) = 'CAMERON.INI'
          ICCMMD(1) = 1
          IPROC = 1
          ID = 0
          CALL ZCMD10(ID)
          CALL ZABAND(2)
          ITCNT = 1
          ICCNT = 1
        ELSE
          CALL ZMORE('There is no CAMERON.INI',0)
          CALL ZMORE1('There is no CAMERON.INI',0)
        ENDIF
        CALL ZCONTR
c      ELSE
c        CALL ZSMALL (RCRYST , NSTORE , IDEVIC)
c      ENDIF
      RETURN
      END
C
CODE FOR ZCANAL
C THIS IS THE COMMAND ANALYSIS
      SUBROUTINE ZCANAL

      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

C IPROC = 1 - process so far
C       = 0 - abandon line
C       = 2 - delete rest of line, process so far.
C       = 3 - get next line
C IT IS DIRECTLY CODED FROM THE FLOW CHART - HENCE THE 'BOX' NOTATION.
C BOX 1
C READ IN THE NEXT WORD
100   CONTINUE
c      write(CLINE,'('' in outer, before zword'')')
c      call zmore(cline,0)
      CALL ZWORD (IERR)
      IF (IERR.EQ.3) THEN
C NO NEXT WORD ON THIS LINE
        IPROC = 3
        RETURN
      ELSE IF (IERR.EQ.1) THEN
C Found a blank line - is all the info supplied?
        IERRH = -1
        CALL ZCICNT(4,IERR)
        IF ((IERR.GE.1).AND.(IERR.LE.3)) THEN
          CALL ZERROR (3,IERRH,'More arguments are required')
        ELSE IF (IERR.EQ.7) THEN
          CALL ZERROR (4,IERRH,
     c  'Incorrect multiple, we need more numbers')
        ELSE IF (IERR.EQ.8) THEN
          CALL ZERROR (4,IERRH,
     c 'Incorrect multiple, we need more characters')
        ELSE IF  (IERR.EQ.4) THEN
          CALL ZERROR (2,IERRH,'Too many numeric arguments')
        ELSE IF (IERR.EQ.5) THEN
          CALL ZERROR (2,IERRH,'Too many numeric arguments')
        ELSE IF (IERR.EQ.6) THEN
          CALL ZERROR (2,IERRH,'Too many character arguments')
        ELSE IF ((IERR.EQ.0).AND.(IN.EQ.0).AND.(IR.EQ.0).AND.
     c (ICTYPE(1,1).EQ.-4).AND.(IC.EQ.0)) THEN
          CALL ZERROR (6,IERRH,'We need a sub command here!')
        ELSE IF ((IERR.EQ.9).OR.(IERR.EQ.0)) THEN
          IPROC = 1
          IF (ISTORE.EQ.0) THEN
            INFCMD(ICINPS) = (IC*100) + (IN*10) + IR
            ICINPS = ICINPS + 1
            IHEAD = 1
            ISTORE = 1
          ENDIF
          RETURN
        ENDIF
        IF (IERRH.EQ.0) GOTO 100
        IF (IERRH.EQ.2) THEN
          IPROC = 2
          IHEAD = 1
          RETURN
        ENDIF
        IF (IERRH.EQ.1) THEN
          CALL ZABAND(2)
          ILINE = 1
          IEND = 0
          IPROC = 0
          RETURN
        ENDIF
      ELSE IF (IERR.EQ.2) THEN
        CALL ZQUERY(1)
        RETURN
      ENDIF
C CHECK FOR 'HE (LP)'
      IF (LINE(ILINE)(IBEG:IBEG+1).EQ.'HE') THEN
        CALL ZQUERY (2)
        RETURN
      ENDIF
C BOX 2
C DO WE HAVE A NUMBER?
      I = YCCREA (LINE(ILINE)(IBEG:IEND),RNUM)
      IF (I.EQ.-1) GOTO 500
C DO WE HAVE A NUMBER THAT IS ACTUALLY GENERAL TEXT?
C THIS ARISES WHEN INPUTTING SPACEGROUPS THE "21" IN P 21 21 21 SHOULD
C BE TREATED AS TEXT AND NOT AS A NUMBER
      IF (ICTYPE(2,1).EQ.9) GOTO 500
C GO TO CHARACTER INPUT
      IF ((ICTYPE(2,1).EQ.-7).AND.(LINE(ILINE)(IBEG:IEND).EQ.'0'))
     c  GOTO 500
C
C GOTO BOX 5 IF WE DONT HAVE A NUMBER!

C BOX 3
C DO WE WANT A NUMBER?
       CALL ZCICNT (2,IERR)
      IERRH = -1
      IF (IERR.EQ.4) THEN
         CALL ZERROR (2,IERRH,'Too many numeric arguments')
      ELSE IF (IERR.EQ.5) THEN
         CALL ZERROR (2,IERRH,'Too many numeric arguments')
       ENDIF
         IF (IERRH.EQ.0) GOTO 100
         IF (IERRH.EQ.1) THEN
           IPROC = 0
           RETURN
         ENDIF
         IF (IERRH.EQ.2) THEN
           IPROC = 2
           RETURN
         ENDIF

C BOX 4
C YES WE DO WANT A NUMBER - WHICH ONE?
       IF (IINT(2).NE.0) THEN
C INTEGER
        NCOMMD (ICNPOS) = NINT(RNUM)
        IN = IN + 1
        ICNPOS = ICNPOS + 1
      ELSE
C REAL
        RCOMMD (ICRPOS) = RNUM
        IR = IR + 1
        ICRPOS = ICRPOS + 1
      ENDIF
      GOTO 100
C RETURN TO THE START

C BOX 5
C DO WE HAVE A PREVIOUS COMMAND?
500    CONTINUE
        IF (ICPOS.EQ.1) GOTO 1300
C       IF (IHEAD.EQ.1) GOTO 1300
C NO - LOOK FOR A HEADER COMMAND AT BOX 13

C BOX 6
C DO WE HAVE A SUB COMMAND?
      ID = ICOMMD (ICPOS-1)
      CALL ZCOMSH (ID,ICNUM,2)
      IF (ICNUM.NE.-1) GOTO 700
      IF (ICTYPE(2,1).EQ.9) THEN
C THIS IS GENERAL TEXT. IT IS FINISHED WHEN A COMMAND NAME IS INPUT
C IF A COMMAND NAME IS REQUIRED IN GENERAL TEXT THEN IT MUST
C BE SURROUNDED WITH QUOTES.
        CALL ZCOMSH (ID,ICNUM,1)
        IF (ICNUM.NE.-1) GOTO 1301
      ENDIF
      IF (ICNUM.EQ.-1) GOTO 1000
C IF NO SUB COMMAND GOTO BOX 10

C BOX 7
C IS IT A DIRECT SUB COMMAND?
C DO WE HAVE ALL THE INFO FOR THE PREVIOUS COMMAND?
700    CONTINUE
        IERRH = -1
        CALL ZCICNT (4,IERR)
       IF ((IERR.GE.1).AND.(IERR.LE.3)) THEN
          CALL ZERROR (3,IERRH,'More arguments required')
        ELSE IF (IERR.EQ.7) THEN
          CALL ZERROR (4,IERRH,
     c   'Incorrect multiple, more numbers required')
        ELSE IF (IERR.EQ.8) THEN
          CALL ZERROR (4,IERRH,
     c   'Incorrect multiple, more characters required')
        ELSE IF  (IERR.EQ.4) THEN
          CALL ZERROR (2,IERRH,'Too many numeric arguments')
        ELSE IF (IERR.EQ.5) THEN
          CALL ZERROR (2,IERRH,'Too many numeric arguments')
        ELSE IF (IERR.EQ.6) THEN
          CALL ZERROR (2,IERRH,'Too many character arguments')
        ENDIF
        IF (IERRH.EQ.0) GOTO 100
        IF (IERRH.EQ.1) THEN
          IPROC = 0
          IHEAD = 1
          RETURN
        ENDIF
        IF (IERRH.EQ.2) THEN
          IPROC = 2
          RETURN
        ENDIF

C BOX 8
C IS THE SUB COMMAND VALID?
      CALL ZCILD (2,ICNUM)
      CALL ZSUBCH (IERR)
      IF (IERR.EQ.1) THEN
        CALL ZERROR (1,IERRH,'This sub command is not valid here')
C NEED TO RESET USING XCILD
        CALL ZCILD (2,ICOMMD(ICPOS-1))
        IF (IERRH.EQ.0) GOTO 100
        IF (IERRH.EQ.1) THEN
          IPROC = 0
          IHEAD = 1
          RETURN
        ENDIF
        IF (IERRH.EQ.2) THEN
          IPROC = 2
          RETURN
        ENDIF
      ENDIF

C BOX 9
C UPDATE COMMAND INFO ,COUNTS ETC
C STORE INFO FOR PREVIOUS COMMAND
      IF (ISTORE.EQ.0) THEN
        INFCMD(ICINPS) = (IC*100) + (IN*10) + IR
        ICINPS = ICINPS + 1
        ISTORE = 1
      ENDIF
      CALL ZCIUDT
      ICOMMD (ICPOS) = ICNUM
      ICPOS = ICPOS + 1
      IHEAD = 0
      ISTORE = 0
      ICPROC = IBEG - 1
      GOTO 100
C RETURN TO THE START

C BOX 10
C DO WE NEED CHARACTER INPUT?
1000  CONTINUE
      CALL ZCICNT (1,IERR)
      IF (IERR.EQ.6) THEN
C IS IT A MISTAKE IN A SUB COMMAND?
        CALL ZCISCH (IERR)
        IF (IERR.EQ.1) GOTO 1300
C TOO MANY CHARACTERS!
        CALL ZERROR (2,IERRH,'Too many character arguments')
        IF (IERRH.EQ.0) GOTO 100
        IF (IERRH.EQ.1) THEN
          IPROC = 0
          IHEAD = 1
          RETURN
        ENDIF
        IF (IERRH.EQ.2) THEN
          IPROC = 2
          RETURN
        ENDIF
      ENDIF
 
C BOX 11
C YES - IS IT OF THE CORRECT TYPE?
      CALL ZCISCH (IERR)
      IF (IERR.EQ.1) THEN
      GOTO 1300
      ENDIF
 
C BOX 12
C STORE CHARACTER INPUT
C THIS CODE IS NEEDED BECAUSE IF AN UNTIL WAS USED THEN ALL THE ATOMS
C ADDED BEFORE THE XCICNT TEST IS CARRIED OUT
       IF (IERR.EQ.3) IC = IC + 1
       GOTO 100
C RETURN TO THE START

C BOX 13
C SEARCH FOR A NEW HEADER COMMAND
1300  CONTINUE
      CALL ZCOMSH (ID,ICNUM,1)
1301  CONTINUE
      IERRH = -1
      IF (ICNUM.EQ.-1) THEN
        IF (ABS(ICTYPE(1,1)).NE.8) THEN
          CALL ZERROR (1,IERRH,'Word not recognised')
        ELSE
          CALL ZERROR (5,IERRH,'File does not exist')
        ENDIF
      ENDIF
      IF (IERRH.EQ.0) THEN
       GOTO 100
      ENDIF
C GOTO BOX 1 AND RE PROCESS
      IF (IERRH.EQ.1) THEN
        IHEAD = 1
        IPROC = 0
        RETURN
      ENDIF
      IF (IERRH.EQ.2) THEN
           IPROC = 2
           RETURN
         ENDIF
C BOX 14
C IS PREVIOUS COMMAND FINISHED?
      CALL ZCICNT (4,IERR)
      IERRH = -1
       IF ((IERR.GE.1).AND.(IERR.LE.3)) THEN
          CALL ZERROR (3,IERRH,'More arguments required')
        ELSE IF (IERR.EQ.7) THEN
          CALL ZERROR (4,IERRH,
     c 'Incorrect multiple, more numbers required')
        ELSE IF (IERR.EQ.8) THEN
          CALL ZERROR (4,IERRH,
     c   'Incorrect multiple, more character arguments required')
        ELSE IF  (IERR.EQ.4) THEN
          CALL ZERROR (2,IERRH,'Too many numeric arguments')
        ELSE IF (IERR.EQ.5) THEN
          CALL ZERROR (2,IERRH,'Too many numeric arguments')
        ELSE IF (IERR.EQ.6) THEN
          CALL ZERROR (2,IERRH,'Too many character arguments')
C IF IERR = 0 DOES THE COMMAND NEED A SUB?
        ELSE IF ((IERR.EQ.0).AND.(IN.EQ.0).AND.(IR.EQ.0).AND.
     c (ICTYPE(1,1).EQ.-4).AND.(IC.EQ.0)) THEN
          CALL ZERROR (6,IERRH,'We need a sub command here!')
        ENDIF
        IF (IERRH.EQ.0) GOTO 100
        IF (IERRH.EQ.1) THEN
          IHEAD = 1
          IPROC = 0
          RETURN
        ENDIF
        IF (IERRH.EQ.2) THEN
            IPROC = 2
            RETURN
        ENDIF
C IF WE HAVE A PREVIOUS COMMD ,STORE ITS INFO
        IF ((ICPOS.GT.1).AND.(ISTORE.EQ.0)) THEN
          INFCMD(ICINPS) = (IC*100) + (IN*10) + IR
          ICINPS = ICINPS + 1
          ISTORE = 1
        ENDIF
 
C BOX 15
C IS THIS THE START OF A NEW SET OF COMMANDS?
       IF (IHEAD.EQ.1) THEN
         ICOMMD (ICPOS) = NINT(RSTORE(ICNUM))
         ICPOS = ICPOS + 1
         CALL ZCILD (2,NINT(RSTORE(ICNUM)))
         CALL ZCIUDT
         ISTORE = 0
         IHEAD = 0
         GOTO 100
       ENDIF
C NO - RESET IEND SO THAT NEXT ENTRY INTO XWORD WILL FIND THIS
c HEADER COMMAND
C       ICABAN = ICABAN - IEND + IBEG - 2
       IEND = IBEG - 1
       IPROC = 1
       IHEAD = 1
       RETURN
C GO BACK AND PROCESS COMMAND
       END



CODE FOR ZCOMDO [ COMMAND DO ! ]
      SUBROUTINE ZCOMDO
C This routine unpicks the command line.
C VARIABLES :
C       ICOMMD - this array contains the command numbers
C       INFCMD - this array contains the numbers of arguments supplied
C       ICCMMD - array stores the character info
C       NCOMMD - contains integer arguments
C       RCOMMD - contains real arguments
C
C       INFCMD is a three figure number abc where
C       a = number of character arguments
C       b = number of integer arguments
C       c = number of real arguments
C       ie INFCMD = IC*100 + IN*10 + IR
C
C     ICNT is used to count along the command array
C     INCNT,IRCNT,ICCNT - count along the argument arrays.
C     IPROC is passed in so that its value can be altered to zero
C     this causes all commands on the line to be abandoned after an
C     error.

      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
C
#if defined(_DOS_)
      INCLUDE 'CAMWIN.INC'
#endif
      LOGICAL LFILES
      IF (ICNT.GE.ICPOS) RETURN
10    ICC = INFCMD(ICNT)/100
      ICN = (MOD(INFCMD(ICNT),100))/10
      ICR = INFCMD(ICNT) - ICC*100 - ICN*10
C OBTAIN THE COMMAND NUMBER
      IF (IPROC.EQ.0) GOTO 9999
      ID = ABS(NINT(RSTORE(ICOM+((ICOMMD(ICNT)-ICOM)/ISCOM)*ISRCOM)))
C USE AN 'ON GOTO' TO ANALYSE THE COMMANDS
c      write(CLINE,'('' command number'',i5)')ID
c      call zmore(cline,0)
      GOTO (100,200,300,400,400,600,700,800,900,1000,1100,1200,
     c 1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,
     c 2400) ID/100
      GOTO 9999
100   CONTINUE
C VIEW GROUP
      CALL ZCMD1 (ID)
      GOTO 9999
200   CONTINUE
C LINE GROUP
      CALL ZCMD2 (ID)
      GOTO 9999
300   CONTINUE
C CONNECT GROUP
      CALL ZCMD3 (ID)
      GOTO 9999
400   CONTINUE
C ADD/MOVE GROUP
      CALL ZCMD4 (ID)
      GOTO 9999
600   CONTINUE
C ENCLOSURE GROUP
      CALL ZCMD6 (ID)
      GOTO 9999
700   CONTINUE
C PICTURE GROUP
      CALL ZCMD7 (ID)
      GOTO 9999
800   CONTINUE
C LABEL GROUP
      CALL ZCMD8 (ID)
      GOTO 9999
900   CONTINUE
C INPUT GROUP
      CALL ZCMD9 (ID)
      GOTO 9999
1000  CONTINUE
C OBEY
      CALL ZCMD10 (ID)
      GOTO  9999
1100  CONTINUE
C DEVICE GROUP
      CALL ZCMD11 (ID)
      GOTO 9999
1200  CONTINUE
C SYMMETRY GROUP
      CALL ZCMD12 (ID)
      GOTO 9999
1300  CONTINUE
C COLOUR GROUP
      CALL ZCMD13 (ID)
      GOTO 9999
1400  CONTINUE
C INCLUDE/EXCLUDE GROUP
      CALL ZCMD14 (ID)
      GOTO 9999
1500  CONTINUE
C DISTANCES
      CALL ZCMD15 (ID)
      GOTO 9999
1600  CONTINUE
C ANGLES
      CALL ZCMD16
      GOTO 9999
1700  CONTINUE
C PACK
      CALL ZCMD17 (ID)
      GOTO 9999
1800  CONTINUE
C MENUS
      CALL ZCMD18 (ID)
      GOTO 9999
1900  CONTINUE
C END
C REMOVE THE 'END' FROM THE LOG FILE
      IF (ILOG.EQ.1) THEN
        BACKSPACE (IFLOG)
        BACKSPACE (IFLOG)
        WRITE (IFLOG,'(A)') ' '
        WRITE (IFLOG,'(A)') ' '
        IF (.NOT.LFILES (0,' ' ,IFLOG) .OR.
     +  .NOT. LFILES (0, ' ',ISCRAT) .OR.
     +  .NOT.L FILES (0,' ',ISCRLG)) THEN
         CALL ZMORE('Error on closing log and scratch files.',0)
         ENDIF
      ENDIF
CRIC99
      LCLOSE = .TRUE.
      IF (ICAMER.EQ.1) THEN
C END WILL RETURN TO CRYSTALS
        ID = 920
        CALL ZCMD9(ID)
        ICAMER = -1
#if defined(_DOS_)
      GraphicsHandle = 0
      call window_update@(GraphicsHandle)
#endif
        RETURN
      ELSE
        IF (IDEV.NE.-1) THEN
          ISCRN = IDEV
          CALL ZTXTMD
        ENDIF
        CALL ZMORE('CAMERON FINISHES!',0)
C cljf
        CALL ZMORE1('CAMERON FINISHES !!',0)
        STOP
      ENDIF
2000  CONTINUE
C INFO
      CALL ZCMD20 (ID)
      GOTO 9999
2100  CONTINUE
C DEFGROUP
      CALL ZCMD21 (ID)
      GOTO 9999
2200  CONTINUE
C TORSION
      CALL ZCMD22
      GOTO 9999
2300  CONTINUE
C RENAME
      CALL ZCMD23 (ID)
      GOTO 9999
2400  CONTINUE
C LIST12
      CALL ZCMD24
      GOTO 9999
9999  ICNT = ICNT + 1
      ICCNT = ICCNT + ICC
      IRCNT = IRCNT + ICR
      INCNT = INCNT + ICN
      IF (ICAMER.EQ.-1) RETURN
      IF (ICNT.LT.ICPOS) THEN
        GOTO 10
      ENDIF
      RETURN
      END

CODE FOR ZCONTR
      SUBROUTINE ZCONTR

      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'CAMIMN.INC'
C
CC THIS ACTS UPON THE VALUE OF IMENCN
CC = 0 keyboard input
CC = 1 first time menu input
CC = 2 further menu input
C
C
10    CONTINUE
C CHECK FOR CRYSTALS ENTRY
      IF (ICAMER.EQ.-1) RETURN
C
C
C Get a command from the right place (user or obey file)
      IF(IFOBEY.EQ.-1) THEN
            CALL ZINCH(LLINE(ILINE))
      ELSE
C   Read the line from the file
            READ (IFOBEY,'(A)',END=9999) LLINE(ILINE)
C            CALL ZMORE(LLINE(ILINE),0)
      ENDIF
C
C
      CALL ZMORE(LLINE(ILINE),0)
C
      IF (LINPMN) THEN
C Initialising menus, pass line to ZMNINI
            CALL ZMNLOD
      ELSE
C
C Normal use, interpret the line
            LT = MAX(1,LEN_TRIM(LLINE(ILINE)))
            IF (LLINE(ILINE)(LT:LT) .EQ. '+') THEN
              KMORE = 1
              WRITE(LLINE(ILINE)(LT:LT),'(A)')' '
            ELSE
              KMORE = 0
            END IF
            CALL ZOBEY
            IF(IFOBEY.EQ.-1) THEN
C    Force execution of line unless last char is '+'
               IF (KMORE.EQ.0) THEN
                  LLINE(ILINE) = ' '
                  CALL ZOBEY
C   Clear the status line
                  IF(.NOT.LCLOSE)CALL ZMORE1('Cameron - ready',0)
               ELSE
C   Clear the status line
                  IF(.NOT.LCLOSE)CALL ZMORE1('Cameron - continue',0)
               END IF
C    Clear buffer
               CHRBUF = ' '
C    Clear the input box.
#if !defined(__GID__) 
               IF(.NOT.LCLOSE)CALL ZMNINP
#endif
            ENDIF
      ENDIF
C
C
C
C Initialise the menus (read in data)
      IF (IMENCN.EQ.1) CALL ZMNINI
C
      IF (IFOBEY.NE.-1) GOTO 10 !Reading from file. Don't return.
C
      RETURN
9999  CONTINUE
C END OF OBEY FILE
      CLOSE(IFOBEY)
      IF (IFOBEY.GT.IFSTAR) THEN
        IFOBEY = IFOBEY - 1
      ELSE
        IFOBEY = -1
      ENDIF
      RETURN
      END
C 
C 
C 
C 
CODE FOR ZINIT
      SUBROUTINE ZINIT
C This routine initialises the variables to their starting values.
C NOTE THAT SOME OF THE COMMON BLOCKS ARE INITIALISED USING A BLOCK DATA
C ROUTINE.
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      LOGICAL LFILES
C OPEN THE SCRATCH FILE FOR THE LOG INFORMATION
      IF (.NOT.LFILES (9,' ',ISCRLG))
     + CALL ZMORE('Error - cannot create log scratch file.',0)
C INITIALISE THE COMMON BLOCK VARIABLES
C COMMON BLOCK ZSTORA
      ICPOS = 1
      ICCPOS = 1
      ICRPOS = 1
      ICTPOS = 1
      ICNT = 1
      ICCNT = 1
      IRCNT = 1
      INCNT = 1
      ITCNT = 1
      ICNPOS = 1
      ICINPS = 1
      NSCRAT = 0
 
C COMMON BLOCK ZCOMAN
      IPROC = 0
      IMENCN = 0
C----- LIGHT BLUE, BLACK & BLACK
      IBBACK = 9
      IBTEXT = 16
      IBBORD = 16
      ILINE = 1
      IBEG = 0
      IEND = 0
      IN = 0
      IR = 0
      IC = 0
      IINT (1) = 0
      IRL (1) = 0
      ICHARS (1) = 0
      CALL ZZEROI (ICTYPE,8)
      IHEAD = 1
      ICC = 0
      ICN = 0
      ICR = 0
      ISTORE = 0
      IFOBEY = -1
C      ICABAN = 1
      ICLOG = 1
      IVNUM = 1.0
C COMMON BLOCK ZDATAC
      ICOM = 0
      IRELM = 0
      ICLEM = 0
      ICATOM = -1
      IRATOM = -1
      ICLAST = 1
      IREND = ITOT
      ICRYST = 0
      NSYMM = 0
      ISVIEW = 0
      ISYMED = ITOT
      ICELLC = 0
      IPACK = 0
      INATOM = 0
      IELROT = 0
      IFVIEW = 0
      ISINIT = 0
      IFINIT = 0
      NGRP = 0
      IGRP = ITOT - ITMAX**2
      IKEY = 0
      ITEXT = 0
      INTXT = 0
      ITNUMB = 0
      IGG = 0
      ICTXT = ITOT
      IGPCK = 0
      ICLST5 = -1
      ICONBG = ITOT
      ICONED = ITOT
C COMMON BLOCK ZCALCU
      DISEND = 1.7
      DISBEG = 0.0
      ANGEND = 180.0
      ANGBEG = 0.0
      NDIST1 = 0
      XC = 0.5
      YC = 0.5
      ZC = 0.5
      PI = ACOS(-1.0)
      CALL ZZEROF (ROT,16)
      CALL ZZEROF (MAT1,16)
      ROT (1,1) = 1.0
      ROT (2,2) = 1.0
      ROT (3,3) = 1.0
      ROT (4,4) = 1.0
      ISSPRT = 1
      ISFLAG = 0
      ITFLAG = 0
      NDIST2 = 0
      RSTOL = 0.00001
      ISPECL = 0
C COMMON BLOCK ZMCONT
      IMOUSE = 0
      NMOUSE = 0
C COMMON BLOCK ZMNUSS
      IMENAR = 0
      IMNTOP = 0
      IMENVT = 0
      NITEM = 0
      IMCHAR = 0
      ICHEAD = 0
      ISHEAD = 0
      IHMAX = 0
      IHNUM = 0
      IMENWD = 0
      INFOLL = 0
C COMMON BLOCK XCHARA
C INITIALISE THE CGRAPH ASCII VARIABLES
      DO 30 I = 1 , 127
        CGRAPH(I) = CHAR(I)
30    CONTINUE
      CTITLE = ' '
C COMMON BLOCK ZCOLOU
C COMMON BLOCK ZGRAPH
      YCEN = 0
      XCEN = 0
      SCLLIM = 0
      JPAGE = 28
      RES = 0
      IPOST = 0
C-DJW      IFSIZE = 12
c-djw Nov03
      IFONT = 20
      NCWU = 6
      IHAND = 0
      XCP = 0
      YCP = 0
      SCALE = 0
      IVCHAN = 1
      ISLCNT = 1
      P = 0.5
      CALL ZERF (P,RELSCL)
      PSCAL = 0.4
      IBUFF = 0
      XCENS = 0
      YCENS = 0
      XCENH = 0
      YCENH = 0
      SCLIMS = 0
      SCLIMH = 0
      IBACKS = 0
      IBACKH = 0
      IFOREH = 0
      IFORES = 0
      ILABCS = 0
      ILABCH = 0
      IBNDCS = 0
      IBNDCH = 0
      ICLDES = 0
      ICLDEH = 0
      ISCALS = 0
      ISCALH = 0
      INLINE = 1
      XOFF = 0.0
      YOFF = 0.0
      ISTREO = 0
      STRANG = 5.0
C COMMON ZCOLNU
C COMMON ZFLGSS
      ISCRN = -1
      IELTYP = 2
      IOVER = 0
      IDEV = -1
      IHARD = -1
      ISQR = 0
      IDOKEY = 0
      NKEY = 0
      ICOLL = 0
      IPPCK = 0
      ITYPCK = 1
      IAXIS = 0
      IMAXIM = 0
      DBDMAX = 0
      RNUISO = 0.01
      IPLAB = 0
      ILSEC = 0
      ILSIZE = 0
      RTAPER = 2.0
      RTHICK = 0.02
      IMTFLG = 0
      IFILL = 0
      IEXFLG = 1
      IFRAME = 1
      ICURS = 0
      ILABFG = 0
      IPCOLL = 2
      COLTOL = 0.2
      ICELL = 0
      IFOLAP = 0
      ITCOL = 1
      ITITLE = 0
C LOAD IN THE COLOUR TABLES
      CALL ZCOLOT
C COPY IVGACL INTO ICOLS
      DO 10 I = 1 , ICLMAX
        DO 20 J = 1 , 3
          ICOLS(J,I) = IVGACL(J,I)
20      CONTINUE
10    CONTINUE
      IENCL = 0
      IPCX = 0
      ILOG = 0
      IPHOTO = 0
      ICLDEF = 0
      IEDIT = 1
      ICBUFF = 0
      ITEKFG = 0
      IBACK = 0
      IFORE = 0
      ILABCL = 0
      IBNDCL = 0
      ISVGA = 0
C COMMON ZVERSI
      VERS = 0.1
C COMMON ZCKEYS
      IF (IRLAST.EQ.1) THEN
        IF (ICAMER.LT.2) THEN
          CALL ZTITLE
          CALL ZCOMIN
        ENDIF
        CALL ZINELP
        CALL ZCOSIN
      ENDIF
C LEAVE SPACE FOR THE ELEMENT COLOUR KEY.
      IKEY = IRLAST
      IRLAST = IRLAST + NELM*2
C LEAVE SPACE TO STORE 20 PIECES OF TEXT.
      ITEXT = IRLAST
      IRLAST = IRLAST + 20 * 5
C INITIALISE THE OUTPUT CHANNELS
      RETURN
      END
 

 
 
CODE FOR ZTITLE
      SUBROUTINE ZTITLE
C THIS LOADS IN AND OUTPUTS THE TITLE SCREEN
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      CHARACTER*80 CC
      LOGICAL LEXIST,LFILES
      CHARACTER*80 FILENM
C LOOK FOR THE CAMERON.LJP TITLE FILE
      FILENM = 'CAMERON.LJP'
      CALL ZFPATH(FILENM)
      INQUIRE (FILE=FILENM,EXIST=LEXIST)
5     CONTINUE
      IF (.NOT.LEXIST) THEN
        IF (IFIRST.EQ.1) RETURN
        IFIRST = 1
        IPCX = 0
c        IF (.NOT.LFILES (-1,'TITLE.CMN',IINPT)) THEN
          CALL ZMORE('CAMERON',0)
          CALL ZMORE('L.J. Pearce, Dr. D.J. Watkin.',0)
          CALL ZMORE('Chemical Crystallography Lab., Oxford.',0)
c          CALL ZMORE('TITLE.CMN not available.',0)
          CALL ZMORE('Archive and retrieve option added (13-03-2006):
     & A. van der Lee',0)
          RETURN
c        ENDIF
10      CONTINUE
        READ (IINPT,'(A80)',END=11) CC
        CALL ZMORE(CC,0)
        GOTO 10
11      CONTINUE
        IF (.NOT.LFILES (0,' ',IINPT)) THEN
          CALL ZMORE('Error on closing TITLE.CMN.',0)
        ENDIF
      ELSE
C THIS IS DEVICE VGA
        IPCX = 1
        ID = 1
        IF (IFIRST.EQ.1) RETURN
        IFIRST = 1
cdjwjan00        IF (IERR.EQ.1) THEN
          LEXIST = .FALSE.
cdjwjan00          GOTO 5
cdjwjan00        ENDIF
      ENDIF
      RETURN
      END
 
 
 
CODE FOR ZOBEY
      SUBROUTINE ZOBEY
C This routine reads the OBEYed file and sends it to the XCANAL routine
      
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

      CHARACTER*(ICLEN) CTEMP
      CHARACTER*20 CC


C CONVERT TO UPPERCASE FOR ANALYSIS
      CTEMP = LLINE(ILINE)
      CALL ZUPCAS (CTEMP)
      LINE(ILINE) = CTEMP
      IF(CTEMP(1:6).EQ.'LCLICK')THEN
            READ(CTEMP(7:),*) MXPOS, MYPOS
            II=LMOUSE(CC,MXPOS,MYPOS)
            CALL XCTRIM(CC,IIILEN)
            IF(IIILEN.GT.1) THEN

#ifdef CRY_GUI
              CALL ZMORE('^^CO SET TEXTINPUT APPEND='' '//
     1 CC(1:IIILEN) // '''',0)
#else
              CALL ZMORE('Append atom '//CC(1:IIILEN),0)
#endif
            ENDIF
            LLINE(ILINE)=' '
            CTEMP=' '
            RETURN
      ENDIF

13    CALL ZCANAL
      IF (IPROC.EQ.1) THEN
        CALL ZLOGWT(1)
        CALL ZCOMDO
        CALL ZABAND(2)
        IF (ICAMER.EQ.-1) RETURN
      ENDIF
      IF (IPROC.EQ.2) THEN

C REMOVE THE LAST (INCOMPLETE) COMMAND.
        IF (INCOM(1).NE.INCOM(2)) THEN
          ICPOS = ICPOS - 1
          ICCPOS = ICCPOS - IC
          ICNPOS = ICNPOS - IN
          ICRPOS = ICRPOS - IR
        ENDIF
        CALL ZABAND(1)
        CALL ZCOMDO
        CALL ZABAND(2)
        IF (ICAMER.EQ.-1) RETURN
        IBEG = -1
      ENDIF
      IF (IPROC.EQ.0) THEN
C ABANDON
        ILINE = 1
        CALL ZLOGWT(0)
        CALL ZABAND(2)
        IBEG = -1
        IHEAD = 1
      ENDIF
      IF ((ILINE.LT.10).AND.(IBEG.EQ.-1)) THEN
        ILINE = ILINE + 1
        IEND = 0
      ELSE IF ((ILINE.EQ.10).AND.(IBEG.EQ.-1)) THEN
        DO 30 I = 1 , 10
          DO 40 J = 1 , ICLEN
40        LINE(I)(J:J) = ' '
30      CONTINUE
        ILINE = 1
        IEND = 0
      ENDIF
      IF (IBEG.NE.-1) GOTO 13
C      GOTO 10
      RETURN
      END
C
CODE FOR ZSMALL
      SUBROUTINE ZSMALL ( RCRYST, NSTORE, IDEVIC )

      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'

C RCRYST IS THE STORE ARRAY PASSED DOWN FROM CRYSTALS.
      REAL RCRYST (NSTORE)
      CHARACTER*6 CELM,CNUM,CLABEL
      INTEGER INSTAR,IELFIN
C INSTAR - START OF THE NUMBER IN CNUM
C IELFIN - END OF THE ELEMENT INFORMATION IN CELM
C This is the code for running a small version of cameron. ie one that
C will simply produce a ball and stick picture on the screen.
C Info will have been set up in STORE between positions ICAMS and ICAMF.
C IDEVIC is the device number (VGA=1)
C The first 6 numbers are a,b,c,alpha,beta,gamma for the
C unit cell.
C The info required by CAMERON is :-
C 0 - style (2.0 = ball)
C 1 - x **
C 2 - y **
C 3 - z **
C 4 - x orth
C 5 - y orth
C 6 - z orth
C 7 - atom type (number) **
C 8 - colour
C 9 - label status
C 10 - blank
C 11 - drawing radius
C 12 - connectivity radius
C 13 - INCLUDE FLAG
C 14 - bond info start position
C 15 - number of bonds
C 16 - label x position
C 17 - label y position
C 18 - label length
C items marked ** must exist before the user enters CAMERON.
C Held in the order
C x , y , z , atom serial, element number.
C First set up the info in the main array.
C LEAVE ROOM FOR CELL CORNERS
      ICRYST = IRLAST
      CALL ZCRYST ( RCRYST(1), RCRYST(2),RCRYST(3),
     c RCRYST(4),RCRYST(5),RCRYST(6))
C CALL ZCMD11 TO SET UP THE DEVICE
      RES = 1.0
      IDEV = IDEVIC
      CALL ZCMD11 ( IDEVIC)
      CALL ZVIMAT
C FIRST SET UP THE INCLUDE FLAGS FOR THE CELL CORNERS
      DO 30 I = 0 , 7
        RSTORE ( IRLAST - (8-I)*IPACKT + IPCK + 1 ) = -1.0
30    CONTINUE
      J = IRLAST
      ISVIEW = IRLAST
      IRATOM = IRLAST
      ICATOM = ICLAST
      JC = ICATOM + 8
      DO 10 I = 7 , NSTORE-1 , 5
C WE ARE DOING A BALL DRAWING
        RSTORE(J) = 2.0
        RSTORE(J+1) = RCRYST(I)
        RSTORE(J+2) = RCRYST(I+1)
        RSTORE(J+3) = RCRYST(I+2)
        CALL ZZEROF (RSTORE (J+4),3)
        RSTORE(J+IPCK+1) = 1.0
        RSTORE(J+IATTYP) = RCRYST(I+4)
C WORK OUT THE ATOM LABEL
C FIRST FIND THE ELEMENT NAME
        INELM = NINT(RCRYST(I+4))+ICELM-1
        CELM = CSTORE(INELM)
        IELFIN = INDEX(CELM,' ')-1
        IF (IELFIN.EQ.-1) IELFIN = 6
C WRITE THE NUMBER INTO A CHARACTER STRING
        WRITE (CNUM,'(I6)') NINT(RCRYST(I+3))
C NOW FIND THE START OF THE NUMBER
        INSTAR = 1
        DO 100 K = 2 , 5
          IF (CNUM(K:K).EQ.' ') INSTAR = K
100     CONTINUE
C BUILD UP THE LABEL
        CLABEL = CELM(1:IELFIN)//CNUM(INSTAR+1:6)
        CSTORE(JC) = CLABEL
C        CALL ZZEROF ( RSTORE(J+IATTYP+1) , IPACKT-IATTYP )
C SET LABEL FLAG
        RSTORE(J+IATTYP+2) = 1.0
        J = J + IPACKT
        JC = JC + 1
10    CONTINUE
      IFVIEW = J
C NOW GET THE ATOM INFO WE NEED.
      DO 20 I = ISVIEW , IFVIEW - 1, IPACKT
        N = NINT ( RSTORE (I +IATTYP) )
        N = IRELM + (N-1)*4
        RSTORE(I+IATTYP+1) = RSTORE(N+3)
        RSTORE(I+IATTYP+4) = RSTORE(N)*0.25
        RSTORE(I+IATTYP+5) = RSTORE(N)
C SET INCLUDE/EXCLUDE FLAG TO INCLUDE
        RSTORE(I+IPCK+1) = 1.0
20    CONTINUE
C CHANGE THE START NUMBERS TO ALLOW FOR THE CELL EDGES
      ISVIEW = ISVIEW - IPACKT*8
      IRATOM = ISVIEW
      ICATOM = ICATOM - 8
C RESET THE SIZE OF THE PICTURE TO ALLOW FOR THE GRAPHICS MENUS
      XCENS = XCENS - 50
      YCENS = YCENS - 50
      XCEN = XCENS
      YCEN = YCENS
C USE ZATMUL TO ORTHOGONALISE THE COORDINATES
      CALL ZATMUL (0,0,0)
C THE CALCULATE THE CONNECTIVITY
      CALL ZDOCON (0,0,0)
C NOW DO THE VIEW
      IFILL = 1
      ID = 0
      CALL ZCMD1 (ID)
C CALL THE GRAPHICS INPUT ROUTINE
C      CALL ZGINPT
      RETURN
      END
 
 

