CRYSTALS CODE FOR OUTER.FOR                                                     
CAMERON CODE FOR OUTER
CODE FOR ZCAMER
C      SUBROUTINE ZCAMER ( ITYPE , RCRYST, NSTORE , IDEVIC)
      SUBROUTINE ZCAMER ( ITYPE , ICAMS, ICAMF, IDEVIC)
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

C      REAL RCRYST(NSTORE)
CDJW99 this upsets FTN95      EXTERNAL ZBLOCK
      LOGICAL LEXIST
\CAMWIN
      character*80 caption

C ---- some initialisation
      ikeym(1)=0
      ikeym(2)=0
      ikeym(3)=0
      ikeym(4)=0
      font=1
      italic=0.
      rotation=0.
      Status$Text=' '
      Cursor$Number=1
      call GetWindowSize(xwin,ywin)
      size=0.9*float(xwin)/640.
      iy=ywin-65

C ---- CAMERON still functions internally in the VGA graphics space of
C      640x480. scale_X/scale_Y are the scaling values corresponding to
C      the current Windows resolution. The parameters for all graphics
C      primitive are scaled up when drawing, conversely the reported
C      coordinates from mouse clicks are scaled down when returned to
C      program. This provides a simple but effective way of coping with
C      different screen resolutions. The scaling is done in the routines
C      in SPECIFIC.FOR

      scale_X=float(iy)/480.
      scale_Y=scale_X
      ix=nint(640.0*scale_X)

C ---- open I/O and graphics windows
      caption='CAMERON Dialog Window'
C      call CreateIOWindow(caption,DialogHandle)
      call CreateGraphicsWindow(ix,iy)


      ICAMER = ITYPE
      CALL ZOINIT
      IF (ICAMER.LT.2) THEN
C SET UP FLAG POSITIONS FOR LARGE VERSION OF CAMERON
        IXYZO = 16
        IPCK = 14
        IATTYP = 32
        ILAB = 43
        IBOND = 41
        ISYM = 48
        IPACKT = 49
      ELSE
C SET UP FLAG POSITIONS FOR SMALL VERSION OF CAMERON
        IXYZO = 4
        IPCK = 12
        IATTYP = 7
        ILAB = 16
        IBOND = 14
        ISYM = 0
        IPACKT = 19
      ENDIF
      CALL ZMINIT
      IRLAST = 1
      CALL ZINIT
      IF (ICAMER.LT.2) THEN
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
      ELSE
        CALL ZSMALL (RCRYST , NSTORE , IDEVIC)
      ENDIF
      call zmore1('CAMERON finished !!',0)
      GraphicsHandle = 0
      call window_update@(GraphicsHandle)

      END
C
CODE FOR ZCANAL
C THIS IS THE COMMAND ANALYSIS
      SUBROUTINE ZCANAL
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

C IPROC = 1 - process so far
C       = 0 - abandon line
C       = 2 - delete rest of line, process so far.
C       = 3 - get next line
C IT IS DIRECTLY CODED FROM THE FLOW CHART - HENCE THE 'BOX' NOTATION.
C BOX 1
C READ IN THE NEXT WORD
100   CONTINUE
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
 
CODE FOR ZMNCOM [ COMMUNICATION ]
C THIS ROUTINE CREATES THE STRING THAT WILL BE USED TO COMMUNICATE WITH
C THE MAIN PROGRAM.
      SUBROUTINE ZMNCOM(CTEXT,ITYPE)
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      INTEGER IX1,IY1,IX2,IY2
      INTEGER ERROR
      CHARACTER*(ICLEN) CDUMP
      CHARACTER*(ICLEN) CTEXT
C ITYPE = 0 NO ARGUMENTS (PROCESS)
C ITYPE = 1 ARGUMENTS (DON'T PROCESS)
C ITYPE = -1 SECOND CLICK ON ARGUMENT COMMAND (PROCESS).
C ITYPE = 3 VIEW
       IF (ITYPE.EQ.3) THEN
         CALL ZCOMDO
         CALL ZABAND(2)
         LINE(ILINE)(1:4) = 'VIEW'
         IEND = 0
         CALL ZCANAL
         CALL ZCANAL
         CALL ZCOMDO
         CALL ZABAND(2)
         CALL ZRETST(IBUFF)
         IX1 = 0
         IY1 = 0
         IX2 = 2*XCEN - 1
         IY2 = 2*YCEN - 1
         CALL ZGTSCN(IX1,IY1,IX2,IY2,IBUFF)
         CALL ZABAND(2)
         CALL ZMNRED(1)
         RETURN
       ENDIF
        IF (ITYPE.EQ.-1) THEN
        IX1 = 0
        IY1 = 0
        CALL ZRTSBL(IX1,IY1,IBUFF,0,ERROR)
        CALL ZCOMDO
        CALL ZABAND(2)
        IF (ICAMER.EQ.-1) RETURN
C RESET FLAGS
C ALSO LOOP ALONG IMOLD TO RESET FLAGS
          DO 40 I = 1 , 10
            IF (IMOLD(I).GT.1) THEN
              RSTORE(IMOLD(I)+3) = ABS(RSTORE(IMOLD(I)+3))
            ENDIF
40        CONTINUE
        RSTORE(IMENU(IMENVT,3)+3) = ABS(RSTORE(IMENU(IMENVT,3)+3))
        CALL ZRETST(IBUFF)
        IX1 = 0
        IY1 = 0
        IX2 = 2*XCEN - 1
        IY2 = 2*YCEN - 1
        CALL ZGTSCN(IX1,IY1,IX2,IY2,IBUFF)
        CALL ZABAND(2)
        RETURN
      ENDIF
C CHECK THAT THE OLD PATHS MEET PROPERLY
      IX = 0
      DO 5 I = 2 , IMENVT-1
C JUMP OUT IF WE HAVE REACHED THE END OF THE OLD PATH
C BRANCHING ONLY ALLOWED AT THE CURRENT MENU LEVEL.
        IF (IMOLD(I).EQ.0) GOTO 7
        IF (IMOLD(I).NE.IMENU(I,3)) IX = 1
5     CONTINUE
7     CONTINUE
      IF ((IX.EQ.0).AND.(IMOLD(IMENVT).NE.IMENU(IMENVT,3)).AND.
     c  (IMOLD(IMENVT).NE.0)) IX = 2
C IF WE HAVE MOVED TO ANOTHER COMMAND - RESET FLAGS FOR THE LAST ONE.
      IF (IX.EQ.2) THEN
        RSTORE(IMOLD(IMENVT)+3) = ABS(RSTORE(IMOLD(IMENVT)+3))
      ENDIF
C WE NEED TO LOOP DOWN THE CURRENT MENU 'PATH'
      IL = 1
      DO 10 I = 2 , IMENVT-1
        IF (NINT(RSTORE(IMENU(I,3)+3)).EQ.-3) IL = I
10    CONTINUE
C THE -3 WILL ONLY OCCUR IF A PREVIOUS MENU ITEM HAS HAD INFO ENTERED
C FOR IT.
C SEND THE INFO FROM IL DOWN TO THE CURRENT VALUE OF IMENVT-1.
      IF (IX.EQ.1) IL = 1
      IF (IX.EQ.2) IL = IMENVT-1
      IIC = 1
      ILINE = ILINE + 1
      IF (ILINE.GE.8) ILINE=1
      DO 20 I = IL+1 , IMENVT
        N = NINT(RSTORE(IMENU(I,3)))
C DO NOT OUTPUT A DUMMY NAME
        IF (NINT(RSTORE(IMENU(I,3)+3)).EQ.-2) GOTO 20
        IF (IIC.EQ.1) THEN
          LINE(ILINE) = CSTORE(N)//CSTORE(N+1)
        ELSE
          CDUMP = LINE(ILINE)(1:IIC)//CSTORE(N)//CSTORE(N+1)
          LINE(ILINE) = CDUMP
        ENDIF
        IIC = IIC + 2*ILEN
20    CONTINUE
C NOW WE NEED TO PASS THIS INFO TO CAMERON
      IEND = 0
      CALL ZCANAL
C SEND DOWN THE ARGUMENTS IF THEY EXIST.
      IF (ITYPE.EQ.1) THEN
        LINE(ILINE+1) = CTEXT
        ILINE = ILINE + 1
        IEND = 0
        CALL ZCANAL
        IF (IPROC.EQ.3) THEN
C FORCE STORAGE OF INFO
          INFCMD(ICINPS) = IC*100 + IN*10 + IR
          ICINPS = ICINPS + 1
          ISTORE = 1
        ENDIF
      ENDIF
      IF (ITYPE.EQ.0) THEN
C NEED TO FORCE PROCESSING OF THE COMMAND
        IF (IPROC.EQ.3) THEN
          CALL ZCANAL
        ENDIF
        IF (IBEG.NE.-1) THEN
          IEND = 0
          CALL ZCANAL
        ENDIF
        IF (IPROC.EQ.3) THEN
C FORCE STORAGE OF INFO
          INFCMD(ICINPS) = IC*100 + IN*10 + IR
          ICINPS = ICINPS + 1
          ISTORE = 1
        ENDIF
        IX1 = 0
        IY1 = 0
        CALL ZRTSBL(IX1,IY1,IBUFF,0,ERROR)
        CALL ZCOMDO
        CALL ZABAND(2)
        IF (ICAMER.EQ.-1) RETURN
C RESET THE FLAGS
        CALL ZABAND(2)
C ALSO LOOP ALONG IMOLD TO RESET FLAGS
          DO 50 I = 1 , 10
            IF (IMOLD(I).GT.1) THEN
              RSTORE(IMOLD(I)+3) = ABS(RSTORE(IMOLD(I)+3))
            ENDIF
50        CONTINUE
        CALL ZRETST(IBUFF)
        IX1 = 0
        IY1 = 0
        IX2 = 2*XCEN - 1
        IY2 = 2*YCEN - 1
        CALL ZGTSCN(IX1,IY1,IX2,IY2,IBUFF)
        RETURN
      ENDIF
      IF ((IPROC.EQ.0).OR.(IPROC.EQ.2)) THEN
C THERE IS AN ERROR - ABANDON
C ALSO LOOP ALONG IMOLD TO RESET FLAGS
          DO 30 I = 1 , 10
            IF (IMOLD(I).GT.1) THEN
              RSTORE(IMOLD(I)+3) = ABS(RSTORE(IMOLD(I)+3))
            ENDIF
30        CONTINUE
          RSTORE(IMENU(IMENVT,3)+3) = ABS(RSTORE(IMENU(IMENVT,3)+3))
          CALL ZABAND(2)
        RETURN
      ENDIF
      RETURN
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
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF
C
\CAMWIN
CDJW99      INCLUDE <WINDOWS.INS>
      LOGICAL LFILES
      IF (ICNT.GE.ICPOS) RETURN
10    ICC = INFCMD(ICNT)/100
      ICN = (MOD(INFCMD(ICNT),100))/10
      ICR = INFCMD(ICNT) - ICC*100 - ICN*10
C OBTAIN THE COMMAND NUMBER
      IF (IPROC.EQ.0) GOTO 9999
      ID = ABS(NINT(RSTORE(ICOM+((ICOMMD(ICNT)-ICOM)/ISCOM)*ISRCOM)))
C USE AN 'ON GOTO' TO ANALYSE THE COMMANDS
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
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

CC THIS ACTS UPON THE VALUE OF IMENCN
CC = 0 keyboard input
CC = 1 first time menu input
CC = 2 further menu input
10    CONTINUE
C CHECK FOR CRYSTALS ENTRY
      IF (ICAMER.EQ.-1) RETURN
      IF (IFOBEY.NE.-1) THEN
        CALL ZOBEY
      ELSE IF (IMENCN.EQ.0) THEN
        CALL ZINPUT
      ELSE IF (IMENCN.EQ.1) THEN
        CALL ZMNINI
      ELSE IF (IMENCN.EQ.2) THEN
        CALL ZMENUS
      ENDIF
      GOTO 10
      END
 
 
CODE FOR ZZMNINI [ DO MENU - NOW A DUMMY - SEE BUTTON 1996 ]
      SUBROUTINE ZZMNINI
C THIS ROUTINE SETS UP THE MENU CONTROL DATA AND ALSO THE NAMES OF
C THE COMMANDS - SUB-COMMANDS IN THE RELEVANT MENUS.
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

C      INTEGER IMENU (10,3)
C IMENU IS THE CONTROLLING ARRAY FOR GENERATING THE MENU LISTS.
      ISMEN = IRLAST
      CALL ZZEROI (IMENU,30)
      IMST = ISMEN
      IMFIN = ISMEN
      ISTEP = 4
      IMEN = 1
C SET UP THE LIST FOR THE TOP MENU BAR.
      DO 10 I = ISHEAD , ISHEAD + (IHNUM-1)*IHMAX , IHMAX
        RSTORE(IMFIN) = NINT (RSTORE (I))
        IMFIN = IMFIN + 4
10    CONTINUE
      IMENU ( IMEN , 1) = IMST
      IMENU ( IMEN , 2 ) = IMFIN - 4
      IMENU ( IMEN , 3) = IMST
      IMST = IMFIN
      IMEN = 2
      IMENU (IMEN,1 ) = IMST
      IMENU (IMEN,3 ) = IMST
C SET UP THE DATA FOR THE TOP MENU BAR
      DO 20 I = ISHEAD, ISHEAD + (IHNUM - 1)*IHMAX , IHMAX
C GET THE NUMBER OF COMMANDS IN THIS GROUP
      IS = IMENU (IMEN-1,1)
C      IP = IMENU (IMEN-1,3)
        RSTORE (IS + (I-ISHEAD)*ISTEP/IHMAX + 1 ) = IMST
        IH = NINT ( RSTORE ( I + 1 ))
        DO 30 L = 2 , IH + 1
C GET THE NUMBER OF THE COMMAND GROUP
          IGCOM = NINT (RSTORE (I+L) )
C LOOK FOR THIS GROUP IN THE MAIN LIST
          DO 40 J = ICOM , ISHEAD-1 , ISRCOM
            IF (ABS(NINT(RSTORE(J))).EQ.IGCOM) GOTO 50
40        CONTINUE
50        CONTINUE
C NOW SEARCH TO FIND ALL HEADER COMMANDS IN THIS LIST.
          DO 60 K = J , J+30*ISRCOM , ISRCOM
            IF (K.GE.ISHEAD) GOTO 61
            ID = ABS(NINT ( RSTORE ( K ) ))
            IF (ID/100.EQ.IGCOM/100) THEN
C WE HAVE A COMMAND IN THE SAME GROUP - IS IT A HEADER COMMAND?
              IF (NINT(RSTORE(K+1)).EQ.0) THEN
C YES IT IS - STORE IT IN THE ARRAY
                IMNPOS = ICOM + ( K - ICOM )*ISCOM/ISRCOM
                RSTORE(IMFIN) = IMNPOS
                IMFIN = IMFIN + ISTEP
              ENDIF
            ENDIF
60        CONTINUE
61        CONTINUE
30      CONTINUE
        RSTORE ( IS + (I-ISHEAD)*ISTEP/IHMAX + 2 ) = (IMFIN-IMST)/ISTEP
        RSTORE ( IS + (I-ISHEAD)*ISTEP/IHMAX + 3 ) = 0
        IMST = IMFIN
20    CONTINUE
C NOW WE HAVE SET UP THE LIST - WE NEED TO GENERATE THE REMAINING
C MENUS
      IMENU (IMEN , 2) = IMFIN - 4
C      IMENU ( IMEN , 3) = IMST
70    CONTINUE
C LOOP OVER THE LEVEL OF MENU THAT WE ARE CURRENTLY ON.
      IFIND = 0
      IMENU (IMEN+1,1) = IMST
      IMENU (IMEN+1, 3 ) = IMST
      DO 80 I = IMENU (IMEN,1) , IMENU (IMEN,2) , ISTEP
C CHECK THAT WE HAVE A 'REAL' COMMAND
        IF (NINT(RSTORE(I+3)).EQ.2) GOTO 80
C GET THE COMMAND NUMBER
        ICP = ICOM + (NINT(RSTORE(I))-ICOM)*ISRCOM/ISCOM
        ICNO = NINT (RSTORE (ICP))
C GET THE SUB-COMMAND INFO
        ICSUB = NINT (RSTORE (ICP + 5) )
C WE CAN HAVE FOLLOWING INFO
        ISS = RSTORE(ICP+2)+RSTORE(ICP+3)+RSTORE(ICP+4)
        IF ((ABS(ICSUB).LT.10).AND.(ISS.GT.0)) RSTORE(I+3) = 1.0
        IF ((MOD(ABS(ICSUB),10).EQ.4).OR.(ICNO.LT.0)) THEN
C WE MAY HAVE TO ADD IN AN ADDITIONAL MENU ITEM FOR THE CHARACTER INPUT.
          IF (ABS(ICSUB).GT.9) THEN
C GET THE CHARACTER EQUIVALENT
            IF (ABS(ICSUB).GT.9) N = ABS(ICSUB)/10
C            IF (ICNO.LT.0) N = ICSUB
            IMNPOS = IMCHAR + (N-1)*2
            RSTORE(IMFIN) = IMNPOS
C SET FLAG FOR INFO CREATED
C            IF (ICNO.LT.0) THEN
C              RSTORE(IMFIN+3) = 3.0
C            ELSE
              RSTORE(IMFIN+3) = 2.0
C            ENDIF
            IMFIN = IMFIN + ISTEP
            IFIND = 1
          ELSE
            ISS = RSTORE(ICP+2)+RSTORE(ICP+3)+RSTORE(ICP+4)
C SET THE COMMAND SO THAT WE HAVE INFO BEFORE THE SUB-COMMAND.
            IF (ISS.GT.0.0) RSTORE(I+3)=3.0
          ENDIF
C WE HAVE A SUB-COMMAND POSSIBLE.
C LOOP OVER THE SUB-COMMANDS
          IST = ICP - 20*ISRCOM
          IF (IST.LT.ICOM) IST=ICOM
          IFN = ICP + 20*ISRCOM
          DO 90 J = IST , IFN , ISRCOM
C GET THE NUMBER OF THE COMMAND
            ICSNO = ABS(NINT (RSTORE(J)))
            IF (ICSNO/100.NE.ABS(ICNO/100)) GOTO 90
C MUST BE OF THE SAME GROUP
C GET THE PREVIOUS COMMAND NUMBER
            ISPR = NINT (RSTORE (J+1))
            IF (ICSUB.GT.0) THEN
C 4 type sub-command n, -n and 1 valid.
              IF (ISPR.EQ.1) THEN
C THIS IS 'SPECIAL' - NEED TO GET PREVIOUS NUMBER FOR ABOVE COMMAND.
                IF (IMEN.GT.3) GOTO 90
                ICPR = NINT (RSTORE (ICP+1))
                IF (ABS(ICPR).GT.1) THEN
C WE HAVE A n or -n COMMAND AT LEVEL 2 PUT 1'S HERE
                  IF (IMEN.EQ.3) THEN
C SUB-COMMAND IS VALID
                    IMNPOS = ICOM + (J-ICOM)*ISCOM/ISRCOM
                    RSTORE(IMFIN) = IMNPOS
                    IMFIN = IMFIN + ISTEP
                    IFIND = 1
                  ENDIF
                ELSE
                  IF (IMEN.EQ.2) THEN
C SUB-COMMAND IS VALID
                    IMNPOS = ICOM + (J-ICOM)*ISCOM/ISRCOM
                    RSTORE(IMFIN) = IMNPOS
                    IMFIN = IMFIN + ISTEP
                    IFIND = 1
                  ENDIF
                ENDIF
              ELSE IF (ABS(ISPR).EQ.ABS(ICNO)) THEN
C SUB-COMMAND IS VALID
                IMNPOS = ICOM + (J-ICOM)*ISCOM/ISRCOM
                RSTORE(IMFIN) = IMNPOS
                IMFIN = IMFIN + ISTEP
                IFIND = 1
              ENDIF
            ELSE
C -4 type sub-command n and -n are valid
              IF (ABS(ISPR).EQ.ABS(ICNO)) THEN
                IMNPOS = ICOM + (J-ICOM)*ISCOM/ISRCOM
                RSTORE(IMFIN) = IMNPOS
                IMFIN = IMFIN + ISTEP
                IFIND = 1
              ENDIF
            ENDIF
90        CONTINUE
C IF ANY COMMANDS HAVE BEEN FOUND - STORE THE INFO
          IF (IMFIN.NE.IMST) THEN
            RSTORE(I+1) = IMST
            RSTORE(I+2) = (IMFIN - IMST) / ISTEP
            IMST = IMFIN
          ENDIF
        ENDIF
80    CONTINUE
C IFIND WILL HAVE BEEN SET IF WE HAVE FOUND A SUB-COMMAND MENU
      IF (IFIND.EQ.1) THEN
        IMEN = IMEN + 1
        IMENU (IMEN , 2 ) = IMFIN - 4
C        IMENU (IMEN , 3 ) = IMENU (IMEN,1)
        GOTO 70
      ENDIF
      IRLAST = IMFIN
      CALL ZMENU
      RETURN
      END
 
CODE FOR ZDOWN
      SUBROUTINE ZDOWN
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

C FIRST OF ALL - ARE WE WITHIN A VERTICAL MENU?
      IF (IMENVT.EQ.1) THEN
C NO WE AREN'T
        IMENX(2) = IMPOS(IMNTOP)
        IMENY(2) = 20
        IMENVT = 2
        CALL ZMNVET(1)
        RETURN
      ENDIF
C OTHERWISE - WE MUST BE ALREADY IN A MENU - DO DOWN WITHIN THIS.
      N = IMENU ( IMENVT,3 )
      M = N + 4
C      IVERT(IMENVT) = IVERT(IMENVT) + 1
      IMENU (IMENVT,3) = IMENU (IMENVT,3) + 4
      IF (M.GT.IMENU(IMENVT,2)) THEN
        M = IMENU(IMENVT,2)
C        IVERT(IMENVT) = IVITEM
        IMENU(IMENVT,3) = IMENU(IMENVT,2)
      ENDIF
      CALL ZMNVHI (N , M)
      RETURN
      END
 
CODE FOR ZESCP
C ESCAPE KEY PRESSED
      SUBROUTINE ZESCP
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      IMENVT = 1
      CALL ZMNRED(1)
      RETURN
      END
 
 
CODE FOR ZINIT
      SUBROUTINE ZINIT
C This routine initialises the variables to their starting values.
C NOTE THAT SOME OF THE COMMON BLOCKS ARE INITIALISED USING A BLOCK DATA
C ROUTINE.
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

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
      IPAGE = 28
      RES = 0
      IPOST = 0
C-DJW      IFSIZE = 12
      IFONT = 12
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
      DO 10 I = 1 , 16
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
C      CALL ZOINIT
      RETURN
      END
 
CODE FOR ZINPUT [COMMAND INPUT]
      SUBROUTINE ZINPUT
C This routine reads the input and sends it to the XCANAL routine
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      CHARACTER*(ICLEN) CTEMP
C TURN ON THE MOUSE
      IF (IDEV.EQ.1) CALL ZMDISP
      CALL ZINCH(LLINE(ILINE))
C TURN IT OFF AGAIN
      IF (IDEV.EQ.1) CALL ZMHIDE
C NEED TO GET THE UPPERCASE VERSION FOR ANALYSIS
      CTEMP = LLINE(ILINE)
      CALL ZUPCAS (CTEMP)
      LINE(ILINE) = CTEMP
C      IL = 0
C FIND THE LENGTH OF THE LINE
C      DO 10 I = ICLEN , 1 , -1
C        IF (LINE(ILINE)(I:I).NE.' ') GOTO 9
C10    CONTINUE
C      IL = -1
C9     CONTINUE
C AT THE LINE END THERE IS NO SPACE
C      IF (IL.NE.-1) THEN
C        IF (I.EQ.ICLEN) THEN
C          CLOG(ICLOG:ICLOG+I) = LINE(ILINE)(1:I)//' '
C        ELSE
C          CLOG(ICLOG:ICLOG+I) = LINE(ILINE)(1:I+1)
C        ENDIF
C        ICLOG = ICLOG + I + 1
C      ENDIF
C ADD THIS LINE TO THE LOG FILE
13    CALL ZCANAL
      IF (IPROC.EQ.1) THEN
C SEND THE LINE TO THE LOG FILE
         CALL ZLOGWT(1)
C        IF (ICABAN.GT.1) THEN
C            IF (ILOG.EQ.1) THEN
C              WRITE (IFLOG,'(A)') CLOG (1:ICABAN-1)
C            ENDIF
C RESET THE FLAGS AND MOVE OVER THE REST OF THE LINE
C            IF (ICABAN.NE.ICLOG) THEN
C              CTEMP = CLOG(ICABAN:ICLOG-1)
C              CLOG (1:ICLOG-ICABAN) = CTEMP(1:ICLOG-ICABAN)
C              ICLOG = ICLOG - ICABAN + 1
C            ELSE
C              ICLOG = 1
C            ENDIF
C            ICABAN = 1
C        ENDIF
C PROCESS THE COMMANDS SO FAR
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
C RESET FLAGS FOR LOG FILE
        ICLOG = 1
        ICABAN = 1
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
 
CODE FOR ZMNKEY [ KEY CONTROL OF MENUS ]
      SUBROUTINE ZMNKEY
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      INTEGER KK
C10    CONTINUE
      CALL ZGETKY(KK)
      IF (KK.EQ.ICRGHT) THEN
        CALL ZRIGHT
      ELSE IF (KK.EQ.ICLEFT) THEN
        CALL ZLEFT
      ELSE IF (KK.EQ.ICDOWN) THEN
        CALL ZDOWN
      ELSE IF (KK.EQ.ICUP) THEN
        CALL ZUP
      ELSE IF (KK.EQ.ICESP) THEN
        CALL ZESCP
      ELSE IF (KK.EQ.ICRET) THEN
        CALL ZRET
      ELSE IF ((KK.EQ.ICLV).OR.(KK.EQ.ICUV)) THEN
        CALL ZV
      ENDIF
C CLEAR SCREEN WE HAVE LEFT MENUS
      IF (IMENCN.EQ.0) CALL ZVGA
      RETURN
      END
 
CODE FOR ZLEFT
      SUBROUTINE ZLEFT
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

C THIS ROUTINE ACTS UPON A LEFT CURSOR.
      IF (IMENVT.GT.1) THEN
C DO WE HAVE AN ARROW
        IF (IMNTOP.GT.NITEM/2) THEN
C YES THERE ARE RIGHT ARROWS POSSIBLE
          ILAR = IMENU(IMENVT,3)
          ILAR = NINT (RSTORE (ILAR+2) )
          IF (ILAR.GT.0) THEN
C YES THERE IS AN ARROW - GET THE NEXT ROUTINE
C WHERE ARE WE IN THE CURRENT ROUTINE?
            N = ( IMENU(IMENVT,3) - IMENU(IMENVT,1) ) /4
            IMENVT = IMENVT + 1
            IMENX(IMENVT) = IMENX(IMENVT-1) - IMENWD/2
            IMENY(IMENVT) = IMENY(IMENVT-1) + 15*N
            CALL ZMNVET(1)
          ENDIF
        ELSE
C LEFT ARROW - GOES BACK UP A MENU
          CALL ZMNVET(-1)
          IMENVT = IMENVT - 1
          CALL ZMNRED(2)
        ENDIF
        RETURN
C NO ARROW - IGNORE THIS
      ENDIF
      N = IMENU(1,3)
      M = N - 4
      IMNTOP = IMNTOP - 1
      IMENU(1,3) = IMENU(1,3) - 4
      IF (M.LT.IMENU(1,1)) THEN
C CAN'T GO LEFT
        IMENU(1,3) = IMENU(1,1)
        IMNTOP = 1
        RETURN
      ENDIF
      IF (IMNTOP.EQ.0) THEN
C        IF (M.GE.IMENU(1,1)) THEN
C        IF (IMENU(IMENVT,3).GT.IMENU(IMENVT,1)) THEN
C NEED TO MOVE OVER THE MENU BAR
C          IMENU(IMENVT,3) = IMENU(IMENVT,3) - 4
C          M = IMENU(1,3)
C        ELSE
C          M = IMENU(1,1)
C        ENDIF
        IMNTOP = 1
        A = IMENU(1,3)
        B = IMENU(1,3) + NITEM*4 - 4
        CALL ZCHARW(A,B)
        CALL ZMNTOP(A,B)
      ENDIF
      CALL ZMNHI (N,M)
      RETURN
      END
 
CODE FOR ZMENU
      SUBROUTINE ZMENU
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      INTEGER IX1,IY1,IX2,IY2
      CALL ZVGA
      IX1 = 0
      IY1 = 0
      IX2 = 639
      IY2 = 479
      CALL ZGTSCN(IX1,IY1,IX2,IY2,IBUFF)
      IMNTOP = 1
      IMENVT = 1
      NITEM = 6
      ICONTR = 2
      A= IMENU(1,1)
      B = IMENU(1,1)+NITEM*4 -4
      CALL ZCHARW(A,B)
      CALL ZMNTOP(A,B)
C NOW DO THE HIGHLIGHT ROUTINE
      CALL ZMNHI (IMENU(1,1),IMENU(1,1))
      IMENCN = 2
      RETURN
      END
 
CODE FOR ZRET
      SUBROUTINE ZRET
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      CHARACTER*(ICLEN) CTEXT
      CHARACTER*12 CNAME
      INTEGER IPOS
      INTEGER IX1,IY1,IX2,IY2
      INTEGER IERROR,IMNOLD,ICLFLG
C This routine acts upon the return keystroke.
      ICLFLG = 0
      IPOS = 1
      IESCP = 0
      IF (IMENVT.EQ.1) THEN
C DO NOTHING IF WE IN THE TOP BAR.
        RETURN
      ENDIF
C RETURN IS NOT ALLOWED FOR COMMANDS IN THE MIDDLE OF A SUB
C MENU STACK.
      ILINE = 0
      IF (RSTORE(IMENU(IMENVT,3)+1).GT.0) RETURN
C SET HEADER COMMAND FLAG
      IHEAD = 1
      IMNOLD = IMENVT
C WE NEED TO LOOP OVER THE ITEMS ABOVE
      DO 10 I = 2 , IMNOLD
        II = IMENU(I,3)
C GET THE COMMAND NAME
        IF (NINT(RSTORE(II+3)).NE.2) THEN
          CNAME = CSTORE(NINT(RSTORE(II)))
     +    //CSTORE(NINT(RSTORE(II))+1)
          ILINE = ILINE + 1
          IF (ILINE.EQ.10) ILINE=1
          IEND = 0
          LINE(ILINE) = CNAME
C PASS DOWN THE NAME
          CALL ZCANAL
          IF (IPROC.EQ.0) THEN
            CALL ZABAND(2)
            GOTO 11
          ENDIF
        ENDIF
C ARE WE WAITING FOR INPUT?
        IINP = NINT ( RSTORE ( IMENU ( I,3 ) + 3) )
        IF (IINP.GT.0.AND.ICLFLG.EQ.0) THEN
          IX1 = 0
          IY1 = 0
          IERROR = 0
          IF (IBUFF.EQ.0) THEN
            CALL ZCLEAR
          ELSE
            CALL ZRTSBL (IX1,IY1,IBUFF,0,IERROR)
          ENDIF
          IMENVT = 1
          CALL ZMNRED(1)
          IMENVT = IMNOLD
          ICLFLG = 1
        ENDIF
        IF (IINP.GT.0) THEN
          CALL ZMNINL(CTEXT,IESCP,I)
          IF (IESCP.EQ.1) THEN
            CALL ZABAND(2)
            GOTO 11
          ENDIF
C ADD THE TEXT INTO THE LINE
          ILINE = ILINE + 1
          IF (ILINE.EQ.10) ILINE=1
          LINE(ILINE) = CTEXT
          IEND = 0
          CALL ZCANAL
          IF (IPROC.EQ.0) THEN
            CALL ZABAND(2)
            GOTO 11
          ENDIF
        ENDIF
10    CONTINUE
      IF (IPROC.EQ.3) THEN
C FORCE STORAGE OF INFO
        INFCMD(ICINPS) = IC*100 + IN*10 + IR
        ICINPS = ICINPS + 1
        ISTORE = 1
      ENDIF
11    CONTINUE
      IX1 = 0
      IY1 = 0
      IERROR = 0
      IF (IBUFF.EQ.0) THEN
        CALL ZCLEAR
      ELSE
        CALL ZRTSBL (IX1,IY1,IBUFF,0,IERROR)
      ENDIF
      CALL ZCOMDO
      CALL ZABAND(2)
      IF (ICAMER.EQ.-1) RETURN
      CALL ZRETST(IBUFF)
      IX1 = 0
      IY1 = 0
      IX2 = 2*XCEN - 1
      IY2 = 2*YCEN - 1
      CALL ZGTSCN(IX1,IY1,IX2,IY2,IBUFF)
      IMENVT = 1
      CALL ZMNRED(1)
      RETURN
      END
 
 
CODE FOR ZRIGHT
      SUBROUTINE ZRIGHT
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

C THIS ROUTINE ACTS UPON A RIGHT CURSOR PRESS.
      IF (IMENVT.GT.1) THEN
C DO WE HAVE AN ARROW
        IF (IMNTOP.LE.NITEM/2) THEN
C YES THERE ARE RIGHT ARROWS POSSIBLE
          ILAR = IMENU(IMENVT,3)
          ILAR = NINT (RSTORE (ILAR+2) )
          IF (ILAR.GT.0) THEN
C YES THERE IS AN ARROW - GET THE NEXT ROUTINE
C WHERE ARE WE IN THE PREVIOUS ROUTINE?
            N = ( IMENU(IMENVT,3) - IMENU(IMENVT,1) ) / 4
            IMENVT = IMENVT + 1
            IMENX(IMENVT) = IMENX(IMENVT-1) + IMENWD/2
            IMENY(IMENVT) = IMENY(IMENVT-1) + 15*N
            CALL ZMNVET(1)
          ENDIF
        ELSE
C GO BACK UP A MENU
          CALL ZMNVET(-1)
          IMENVT = IMENVT - 1
          CALL ZMNRED(2)
        ENDIF
        RETURN
C NO ARROW - IGNORE THIS
      ENDIF
      N = IMENU(1,3)
      M = IMENU(1,3) + 4
      IMENU(IMENVT,3) = IMENU (IMENVT,3) + 4
      IMNTOP = IMNTOP + 1
      IF (IMENU(IMENVT,3).GT.IMENU(IMENVT,2)) THEN
C CAN'T GO RIGHT
        IMENU(IMENVT,3) = IMENU(IMENVT,2)
        M = M - 4
        IMNTOP = IMNTOP - 1
        RETURN
      ENDIF
      IF (IMNTOP.GT.NITEM) THEN
C WE NEED TO MOVE OVER THE TOP MENU BAR
C      IF (M.LE.IMENU(1,2)) THEN
C        IF (IMENU(IMENVT,2)-IMENU(IMENVT,3).GT.NITEM*4) THEN
C MOVE THE MENU BAR
C        ELSE
C          M = IMENU(1,2)
C        ENDIF
        A = IMENU(1,3) - NITEM*4 + 4
        B = IMENU(1,3)
        CALL ZCHARW(A,B)
        CALL ZMNTOP(A,B)
        IMNTOP = NITEM
      ENDIF
      CALL ZMNHI (N,M)
      RETURN
      END
 
CODE FOR ZTITLE
      SUBROUTINE ZTITLE
C THIS LOADS IN AND OUTPUTS THE TITLE SCREEN
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

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
        IF (.NOT.LFILES (-1,'TITLE.CMN',IINPT)) THEN
          CALL ZMORE('CAMERON',0)
          CALL ZMORE('L.J. Pearce, Dr. D.J. Watkin.',0)
          CALL ZMORE('Chemical Crystallography Lab., Oxford.',0)
          CALL ZMORE('TITLE.CMN not available.',0)
          RETURN
        ENDIF
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
        CALL ZVGA
        IF (IFIRST.EQ.1) RETURN
        IFIRST = 1
        CALL ZPCXT ( IERR )
        IF (IERR.EQ.1) THEN
          LEXIST = .FALSE.
          GOTO 5
        ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZUP
      SUBROUTINE ZUP
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

C FIRST OF ALL - ARE WE WITHIN A VERTICAL MENU?
      IF (IMENVT.EQ.1) THEN
C NO WE AREN'T
        RETURN
      ENDIF
C OTHERWISE - WE MUST BE ALREADY IN A MENU - DO UP WITHIN THIS.
      N = IMENU(IMENVT,3)
      M = N - 4
C      IVERT(IMENVT) = IVERT(IMENVT) - 1
      IMENU(IMENVT,3) = IMENU(IMENVT,3) - 4
      IF (M.LT.IMENU(IMENVT,1)) THEN
C        M = 1
C        IVERT(IMENVT) = 1
C GO UP A MENU
      IMENVT = IMENVT - 1
      M = IMENU(IMENVT,3)
      N = IMENU(IMENVT,3)
      CALL ZMNRED(1)
C      M = IMENU(IMENVT,1)
C      IMENU(IMENVT,3) = M
      ENDIF
      IF (IMENVT.EQ.1) THEN
        CALL ZMNHI(N,M)
      ELSE
        CALL ZMNVHI (N , M)
      ENDIF
      RETURN
      END
 
CODE FOR ZV
      SUBROUTINE ZV
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      CHARACTER*80 CTEXT
C THIS CAUSES A VIEW TO BE EXECUTED.
      IF (IMENVT.EQ.1) THEN
        CALL ZMNCOM (CTEXT,3)
      ENDIF
      RETURN
      END
 
 
CODE FOR ZOBEY
      SUBROUTINE ZOBEY
C This routine reads the OBEYed file and sends it to the XCANAL routine
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

      CHARACTER*(ICLEN) CTEMP
C READ THE LINE FROM THE FILE
      READ (IFOBEY,'(A)',END=9999) LLINE(ILINE)
      CALL ZMORE(LLINE(ILINE),0)
C CONVERT TO UPPERCASE FOR ANALYSIS
      CTEMP = LLINE(ILINE)
      CALL ZUPCAS (CTEMP)
      LINE(ILINE) = CTEMP
C      IL = 0
C FIND THE LENGTH OF THE LINE
C      DO 10 I = ICLEN , 1 , -1
C        IF (LINE(ILINE)(I:I).NE.' ') GOTO 9
C10    CONTINUE
C      IL = -1
C9     CONTINUE
C      IF (IL.NE.-1) THEN
C        IF (I.EQ.ICLEN) THEN
C          CLOG(ICLOG:ICLOG+I) = LINE(ILINE)(1:I)//' '
C        ELSE
C          CLOG(ICLOG:ICLOG+I) = LINE(ILINE)(1:I+1)
C        ENDIF
C        ICLOG = ICLOG + I + 1
C      ENDIF
C ADD THIS LINE TO THE LOG FILE
13    CALL ZCANAL
      IF (IPROC.EQ.1) THEN
C PROCESS THE COMMANDS SO FAR
C SEND THE LINE TO THE LOG FILE
C        IF (ICABAN.GT.1) THEN
C            IF (ILOG.EQ.1) THEN
C              WRITE (IFLOG,'(A)') CLOG (1:ICABAN-1)
C            ENDIF
C RESET THE FLAGS AND MOVE OVER THE REST OF THE LINE
C            IF (ICABAN.NE.ICLOG) THEN
C              CTEMP = CLOG(ICABAN:ICLOG-1)
C              CLOG (1:ICLOG-ICABAN) = CTEMP(1:ICLOG-ICABAN)
C              ICLOG = ICLOG - ICABAN + 1
C            ELSE
C              ICLOG = 1
C            ENDIF
C            ICABAN = 1
C        ENDIF
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
CODE FOR ZSMALL
      SUBROUTINE ZSMALL ( RCRYST, NSTORE, IDEVIC )
      
\CAMPAR
\CAMCOM
\CAMANA
\CAMDAT
\CAMCAL
\CAMMSE
\CAMMEN
\CAMCHR
\CAMGRP
\CAMCOL
\CAMFLG
\CAMSHR
\CAMVER
\CAMKEY
\CAMBTN
\CAMBLK
\XIOBUF

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
 
 
