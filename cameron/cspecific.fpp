C ---- changes to this file
C 1. include 'common1.inc' for rescaling pixel values
C 2. most mouse routines commented out - not required under Windows
C 3. see cljf for many other changes (mostly in lower case)

CRYSTALS CODE FOR SPECIFIC.FOR
CAMERON CODE FOR SPECIFIC
CODE FOR ZVGA

      SUBROUTINE ZVGA
C      INCLUDE 'COMMON.INC'
C cljf
C      CALL VGA@
C      WRITE (ISTOUT,'(A1,A6)') CHAR(27),'[37;1m'
C      RETURN
      END
 
CODE FOR ZEGA
      SUBROUTINE ZEGA
C      INCLUDE 'COMMON.INC'
C cljf
C      CALL EGA@
C      WRITE (ISTOUT,'(2A)') CHAR(27),'[37;1m'
C      RETURN
      END
 
CODE FOR ZCLRA
      SUBROUTINE ZCLRA (IX1,IY1,IX2,IY2,ICOL)
      INCLUDE 'COMMON1.INC'
      INTEGER IX1,IY1,IX2,IY2,ICOL
      INTEGER*2 IXX1,IYY1,IXX2,IYY2,ICOL1
C cljf
      ixx1 = nint(float(ix1)*scale_X)
      iyy1 = nint(float(iy1)*scale_Y)
      ixx2 = nint(float(ix2)*scale_X) - 1
      iyy2 = nint(float(iy2)*scale_Y) - 1

      ICOL1 = ICOL
      CALL CLEAR_SCREEN_AREA@(IXX1,IYY1,IXX2,IYY2,ICOL1)
      RETURN
      END
 
CODE FOR ZDLINE
      SUBROUTINE ZDLINE (IX1,IY1,IX2,IY2,ICOL)
      INCLUDE 'COMMON1.INC'
      INTEGER IX1,IY1,IX2,IY2,ICOL
      INTEGER*2 IXX1,IYY1,IXX2,IYY2,ICOL1
C cljf
      ixx1 = nint(float(ix1)*scale_X)
      iyy1 = nint(float(iy1)*scale_Y)
      ixx2 = nint(float(ix2)*scale_X) 
      iyy2 = nint(float(iy2)*scale_Y)

      ICOL1 = ICOL
      CALL DRAW_LINE@ (IXX1,IYY1,IXX2,IYY2,ICOL1)
      RETURN
      END
 
CODE FOR ZDTEXT
      SUBROUTINE ZDTEXT (TEXT,IX,IY,ICOL)
      INCLUDE 'COMMON1.INC'
      CHARACTER*(*) TEXT
      INTEGER ICOL
      INTEGER*2 ICOL1,IXX,IYY
C cljf
      increment=10
      if(xwin .eq. 800)  increment=15
      if(xwin .eq. 1024) increment=20
      if(xwin .gt. 1024) increment=25
      ixx = nint(float(ix)*scale_X)
      iyy = nint(float(iy)*scale_Y) + increment
      call set_text_attribute@(font,size,rotation,italic)
      if(xwin .gt. 800) call BoldFont(1)

      ICOL1 = ICOL
      CALL DRAW_TEXT@( TEXT,IXX,IYY,ICOL1)
      RETURN
      END
 
CODE FOR ZFILEL
      SUBROUTINE ZFILEL (IXC,IYC,IMAJ,IMIN,ICOL)
      INCLUDE 'COMMON1.INC'
      INTEGER IMAJ,IMIN,ICOL
      INTEGER*2 IMAJ1,IMIN1,ICOL1,ixc1,iyc1
C cljf
      ixc1  = nint(float(ixc)*scale_X)
      iyc1  = nint(float(iyc)*scale_Y)
      imaj1 = nint(float(imaj)*scale_X)
      imin1 = nint(float(imin)*scale_Y)

      ICOL1 = ICOL
      CALL FILL_ELLIPSE@( IXC1,IYC1,IMAJ1,IMIN1,ICOL1)
      RETURN
      END
 
CODE FOR ZGTBUT
      SUBROUTINE ZGTBUT (N,IB)
      INTEGER IB,N
C cljf
C      INTEGER*2 IBB,NN
      CALL GET_MOUSE_BUTTON_PRESS_COUNT(N,IB)
      RETURN
      END

CODE FOR ZMDISP
      SUBROUTINE ZMDISP
C cljf
C      CALL DISPLAY_MOUSE_CURSOR@
C      RETURN
      END
 
CODE FOR ZMREST
      SUBROUTINE ZMREST
C cljf
C      LOGICAL LRESET
C      CALL MOUSE_SOFT_RESET@(LRESET)
C      IF (.NOT.RESET) THEN
C        WRITE (6,*) 'Warning MOUSE driver not installed.'
C      ENDIF
C      CALL INITIALISE_MOUSE@
C      RETURN
      END
 
CODE FOR ZMHIDE
      SUBROUTINE ZMHIDE
C cljf
C      CALL HIDE_MOUSE_CURSOR@
C      RETURN
      END
 
CODE FOR ZMINIT
      SUBROUTINE ZMINIT
C cljf
C      CALL INITIALISE_MOUSE@
C      CALL SET_MOUSE_BOUNDS@(0,0,639,479)
C      RETURN
      END
 
CODE FOR ZPLINE
      SUBROUTINE ZPLINE (IX,IY,N,ICOL)
      INTEGER IX(N),IY(N),ICOL
      INCLUDE 'COMMON.INC'
      INCLUDE 'COMMON1.INC'
      INTEGER*2 ICOL1
      IF (N.GT.1000) N = 1000
      DO 10 I = 1 , N
C cljf
        ixx2(i) = nint(float(ix(i))*scale_X)
        iyy2(i) = nint(float(iy(i))*scale_Y)

10    CONTINUE
      ICOL1 = ICOL
      CALL POLYLINE@(IXX2,IYY2,N,ICOL1)
      RETURN
      END
 
CODE FOR ZTMODE
      SUBROUTINE ZTMODE
C cljf
C      CALL TEXT_MODE@
C      RETURN
      END
 
CODE FOR ZVGAEL
      SUBROUTINE ZVGAEL (IXC,IYC,IMAJ,IMIN,ICOL)
      INCLUDE 'COMMON1.INC'
      INTEGER IMAJ,IMIN,ICOL
      INTEGER*2 IMAJ1,IMIN1,ICOL1,ixc1,iyc1
C cljf
      ixc1  = nint(float(ixc)*scale_X)
      iyc1  = nint(float(iyc)*scale_Y)
      imaj1 = nint(float(imaj)*scale_X)
      imin1 = nint(float(imin)*scale_X)

      ICOL1 = ICOL
      CALL ELLIPSE@( IXC1,IYC1,IMAJ1,IMIN1,ICOL1)
      RETURN
      END
 
CODE FOR ZRETST
      SUBROUTINE ZRETST (IBUFF)
      INTEGER IBUFF
C cljf
C      CALL RETURN_STORAGE@(IBUFF)
      call release_screen_block@
      RETURN
      END
 
CODE FOR ZGTSCN
      SUBROUTINE ZGTSCN (IX1,IY1,IX2,IY2,IBUFF)
      INCLUDE 'COMMON1.INC'
      INTEGER IX1,IY1,IX2,IY2
      INTEGER*2 IXX1,IYY1,IXX2,IYY2
      INTEGER IBUFF
C cljf
      ixx1 = nint(float(ix1)*scale_X)
      iyy1 = nint(float(iy1)*scale_Y)
      ixx2 = nint(float(ix2)*scale_X)
      iyy2 = nint(float(iy2)*scale_Y)

      CALL GET_SCREEN_BLOCK@(IXX1,IYY1,IXX2,IYY2,IBUFF)
      RETURN
      END
 
CODE FOR ZRTSBL
      SUBROUTINE ZRTSBL (IX,IY,IBUFF,IFLAG,ERROR)
      INCLUDE 'COMMON1.INC'
      INTEGER IX,IY
      INTEGER*2 IXX,IYY
      INTEGER IFLAG,ERROR
      INTEGER IBUFF
C cljf
      ixx = nint(float(ix)*scale_X)
      iyy = nint(float(iy)*scale_Y)

      CALL RESTORE_SCREEN_BLOCK@(IXX,IYY,IBUFF,IFLAG,ERROR)
      RETURN
      END
 
CODE FOR ZBEEP
      SUBROUTINE ZBEEP
      CALL BEEP@
      RETURN
      END
 
 
CODE FOR ZGTMPS
      SUBROUTINE ZGTMPS (IMX,IMY)
      INCLUDE 'COMMON.INC'
      INCLUDE 'COMMON1.INC'
      INTEGER IMX,IMY
C cljf
C      INTEGER*2 IMMX,IMMY,BUTTON_STATUS
      call get_mouse_position (immx,immy)
      imx = nint(float(immx)/scale_X)
      imy = nint(float(immy)/scale_Y)

      RETURN
      END
 
CODE FOR ZCOLCH
      SUBROUTINE ZCOLCH (IREG,IR,IG,IB)
      INTEGER IREG,IR,IG,IB
      INTEGER*2 IRREG,IRR,IGG,IBB
      IRREG = IREG
      IRR = IR
      IGG = IG
      IBB = IB
      CALL SET_VIDEO_DAC@(IRREG,IRR,IGG,IBB)
      CALL SET_PALETTE@(IRREG,IRREG)
      RETURN
      END
 
CODE FOR ZUPCAS
      SUBROUTINE ZUPCAS (CTEXT)
      CHARACTER*(*) CTEXT
CVAX      CHARACTER*80 CTEXT1
CVAX      CALL STR$UPCASE(CTEXT1,CTEXT)
CVAX      CTEXT = CTEXT1
      CALL UPCASE@ (CTEXT)
      RETURN
      END
 
 
CODE FOR ZPCX
      SUBROUTINE ZPCX
C  cljf
C      INTEGER BUFFER
C      INTEGER*2  ERROR
C      CALL GET_SCREEN_BLOCK@(0,0,639,479,BUFFER)
C      CALL SCREEN_BLOCK_TO_PCX@('TITLE.PCX',BUFFER,ERROR)
C      CALL RETURN_STORAGE@(BUFFER)
      RETURN
      END
 
CODE FOR ZISSUE
      SUBROUTINE ZISSUE (CTEXT,IFAIL)
      CHARACTER*(*) CTEXT
      INTEGER*2 IFF
CVAX      INCLUDE '($LIBDEF)'
CVAX      I = LIB$SPAWN (CTEXT)
      CALL CISSUE(CTEXT,IFF)
      IFAIL = IFF
      RETURN
      END
 
CODE FOR ZPCXT ( IERR )
      SUBROUTINE ZPCXT ( IERR )
C TITLE PAGE LOADING FOR  VGA TERMINALS
      CHARACTER*17 PALETTE
      CHARACTER*80 FILENM
      INTEGER*2 IX,IX1,IY,ICOL,IVAL,ICOUNT
      LOGICAL LFILES
      INTEGER IFIN
C TEMP DISABLE TITLE
C----- enable by djw 11 jan 95
C      RETURN
      IFIN = 12
      FILENM = 'CAMERON.LJP'
      IERR = 0
      IF (.NOT.LFILES(-4,FILENM,IFIN)) THEN
        IERR = 1
        RETURN
      ENDIF
      IX = 1
      IY = 1
      READ (IFIN) PALETTE
      CALL SET_ALL_PALETTE_REGS@(PALETTE)
10    CONTINUE
      READ (IFIN) IVAL
      ICOL = MOD(IVAL,20)
      ICOUNT = IVAL/20
      IX1 = IX + ICOUNT - 1
      CALL FILL_RECTANGLE@(IX,IY,IX1,IY,ICOL)
      IX = IX + ICOUNT
      IF (IX.EQ.641) THEN
        IX = 1
        IY = IY + 1
      ENDIF
      IF (IY.LE.480) GOTO 10
      IF (.NOT.LFILES(0,' ',IFIN)) THEN
        IERR= 1
        RETURN
      ENDIF
      CALL ZSLEEP(3.0)
      RETURN
      END
 
CODE FOR ZGTKEY
      SUBROUTINE ZGTKEY (KK)
      INTEGER KK
      INTEGER*2 KKK,get_wkey@
C cljf
C      CALL GET_KEY@(KKK)
      kkk=0
      kkk=get_wkey@()

      KK = KKK
      RETURN
      END
 
 
CODE FOR ZFLUSH
      SUBROUTINE ZFLUSH
C THIS ROUTINE FLUSHES THE KEYBOARD BUFFER
C cljf
C      INTEGER*2 K
C      LOGICAL KEY_WAITING@
C10    CONTINUE
C      IF (KEY_WAITING@()) THEN
C        CALL GET_KEY@(K)
C        GOTO 10
C      ENDIF
      integer*2 k,get_wkey1@
10    k=get_wkey1@()
      if(k .ne. 0) goto 10

      END
 
CODE FOR ZPRNT
      SUBROUTINE ZPRNT (CTEXT)
C THIS PRINTS OUT ON THE SCREEN WITHOUT PUTTING A RETURN AT THE END
      INCLUDE 'COMMON.INC'
      CHARACTER*(*) CTEXT
      CALL ZMHIDE
CVAX      WRITE (IGOUT,'(A,$)') CTEXT
      CALL COUA@(CTEXT)
      CALL ZMDISP
      RETURN
      END
 
CODE FOR ZGTKY1
      SUBROUTINE ZGTKY1 (KK)
      INTEGER KK
      INCLUDE 'COMMON.INC'
      integer*2 kkk,get_wkey1@
C cljf
C      CALL GET_KEY1@(KKK)
      kkk=0
      kkk = get_wkey1@()
      KK = KKK
CDJWNOV98
      IF (KK .EQ. ICRET) CALL ZMORE1(' ',0)
      END
 
CODE FOR ZOINIT
      SUBROUTINE ZOINIT
      INCLUDE 'COMMON.INC'
CVAX      COMMON /SMG/ IKEYBD
CVAX      INTEGER SMG$CREATE_VIRTUAL_KEYBOARD
CVAX      INCLUDE '($SMGDEF)'
CVAX      I = SMG$CREATE_VIRTUAL_KEYBOARD (IKEYBD,'TT:')
CVAX      OPEN (UNIT=IGOUT,FILE='TT:',FORM='FORMATTED',STATUS='UNKNOWN'
CVAX     + , CARRIAGECONTROL='NONE')
CVAX      OPEN (UNIT=ISTOUT,FILE='TT:',FORM='FORMATTED', STATUS='UNKNOWN',
CVAX     + CARRIAGECONTROL = 'LIST')
      RETURN
      END
 
CODE FOR ZINCH
      SUBROUTINE ZINCH (CL)
C THIS ROUTINE READS IN THE COMMAND LINE - CHECKING FOR MOUSE PRESSES AS
C IT GOES!
      INCLUDE 'COMMON.INC'
      CHARACTER*(ICLEN) CL
      CHARACTER*20 CC
      CHARACTER*1 C
      INTEGER KK,IB
      ICP = 0
      ICL = 0
      CALL ZPRNT('=>')
C cljf
      call zmore1('Type commands in Dialog Window',0)
      read (istin,'(a)') cl
      call zmore1(' ',0)
      call upcase(cl)
      return

C  The rest of this code cannot be used for Windows I/O since
C  the ClearWin Window does not behave exactly as a terminal -
C  backspace characters etc are not interpreted as such ...
C  Therefore the "pick'n'mix" input (mouse+keyboard) available
C  under MSDOS is not available under Windows.

CVAX      READ (ISTIN,'(A)') CL
CVAX      RETURN
      IF (IBUFF.GT.0) THEN
        CALL ZPRNT (CBUFF(1:IBUFF))
        ICL = IBUFF
        CL = CBUFF
        IBUFF = 0
      ENDIF
      IB = 0
10    CONTINUE
      CALL ZGTBUT(0,IB)
      IF (IB.NE.0) THEN
        I = LMOUSE(CC)
        IB = 0
        IF (I.NE.-1) THEN
C WE HAVE AN ATOM NAME TO ADD INTO THE LINE
          J = INDEX (CC ,' ')
          IF (ICL+J.GE.ICLEN) THEN
            CALL ZBEEP
            GOTO 10
          ENDIF
          CALL ZPRNT(' ')
          CALL ZPRNT (CC(1:J))
          CL(ICL+1:ICL+J+1) = ' '//CC(1:J)
          ICL = ICL + J + 1
        ENDIF
        GOTO 10
      ENDIF
      CALL ZGTKY1(KK)
      IF (KK.EQ.0) GOTO 10
      IF (KK.EQ.ICRET) GOTO 20
      IF ((KK.LT.ICHMIN).OR.(KK.GT.ICHMAX)) GOTO 10
      C = CHAR(KK)
      IF (KK.EQ.ICDEL.OR.KK.EQ.ICBCK) THEN
C DELETE A CHARACTER
        IF (ICL.EQ.0) GOTO 10
        CALL ZPRNT(CGRAPH(ICDEL))
        CALL ZPRNT(' ')
        CALL ZPRNT(CGRAPH(ICDEL))
        ICL = ICL - 1
        GOTO 10
      ENDIF
      CALL ZPRNT(C)
      ICL = ICL + 1
      IF (ICL.GT.ICLEN) THEN
        CALL ZBEEP
        ICL = ICLEN
        ICP = ICLEN
        GOTO 10
      ENDIF
      IF (KK.NE.ICDEL.AND.KK.NE.ICBCK) THEN
        CL(ICL:ICL) = C
      ENDIF
      GOTO 10
20    CONTINUE
C BLANK OFF THE END OF THE LINE
      DO 30 I = ICL+1 , ICLEN
        CL(I:I) = ' '
30    CONTINUE
      CALL ZMORE(' ',0)
      RETURN
      END
 
 
CODE FOR LFILES
      LOGICAL FUNCTION LFILES (ITYPIN,FILEN,ID)
C THIS ROUTINE HANDLES THE FILE OPEN/CLOSE STATEMENTS
C VARIABLES :
C ITYPIN =  0 Close file
C          1+ these specify the different types of file opening
C NOTE THAT THE EXISTENCE OF THE FILE AND ITS FORMAT SHOULD
C ALREADY HAVE BEEN CHECKED BEFORE CALLING THIS ROUTINE.
C ID         This is the unit number of the device
C NEGATIVE NUMBERS ARE RELATED TO THE ENVIRONMENT VARIABLE
CNOV98 CRCAMER.
C CRYSDIR.
      INCLUDE 'COMMON.INC'
      CHARACTER*(*) FILEN
      CHARACTER*80 FILENM
      LOGICAL LOPEN
      LFILES = .TRUE.
      ITYPE = ITYPIN
      FILENM = FILEN
C FILE OPEN
      IF (ITYPE.LT.0) THEN
        CALL ZFPATH (FILENM)
        ITYPE = -ITYPE
      ENDIF
10    CONTINUE
      IF (ITYPE.EQ.1) THEN
C WE NEED TO CHECK WHETHER THE FILE EXISTS ALREADY
        OPEN (UNIT=ID,FILE=FILENM,STATUS='OLD',ERR=999)
      ELSE IF (ITYPE.EQ.2) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='UNKNOWN',
     + ERR=999)
        REWIND ID
      ELSE IF (ITYPE.EQ.3) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='UNKNOWN',FORM='UNFORMATTED'
     + ,ERR=999)
      ELSE IF (ITYPE.EQ.4) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='OLD',FORM='UNFORMATTED',
     +  ERR=999)
      ELSE IF (ITYPE.EQ.5) THEN
       OPEN (UNIT=ID, FILE=FILENM, STATUS='NEW')
CVAX      OPEN (UNIT=ID, FILE=FILENM, STATUS='NEW',
CVAX     + CARRIAGECONTROL='LIST')
      ELSE IF (ITYPE.EQ.6) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='OLD',FORM='FORMATTED',
     c ACCESS='DIRECT',RECL=80,ERR=999)
      ELSE IF (ITYPE.EQ.7) THEN
        OPEN (UNIT=ID,FILE=FILENM,STATUS='NEW',FORM='FORMATTED',
     c ACCESS='DIRECT',RECL=80)
      ELSE IF (ITYPE.EQ.8) THEN
        OPEN (UNIT=ID,STATUS='SCRATCH',ACCESS='DIRECT',
     + FORM='UNFORMATTED',RECL=160,ERR=999)
      ELSE IF (ITYPE.EQ.9) THEN
        OPEN (UNIT=ID, STATUS='SCRATCH', ACCESS='SEQUENTIAL',
     + FORM='FORMATTED',ERR=999)
      ELSE IF (ITYPE.EQ.0) THEN
        CLOSE(ID)
      ENDIF
      RETURN
999   CONTINUE
C ERROR - IS THE FILE ALREADY OPEN?
      INQUIRE (UNIT=ID,OPENED=LOPEN)
      IF (LOPEN) THEN
        CLOSE(ID)
        GOTO 10
      ENDIF
      CALL ZMORE ('Error opening file '// FILENM, 0)
      CALL ZMORE1 ('Error opening file '// FILENM, 0)
      LFILES = .FALSE.
      END
 
 
CODE FOR ZFPATH
      SUBROUTINE ZFPATH (CFNAME)
      CHARACTER*(*) CFNAME
      CHARACTER*80 CNPATH
      INTEGER LENNAM
C THIS ROUTINE CALLS THE CRYSTALS ROUTINE FOR FILENAME DETERMINATION
C WHICH IS IN DUPLICAT.FOR
CNOV98      CNPATH = 'CRCAMER:'//CFNAME
      CNPATH = 'CRYSDIR:'//CFNAME
      CALL MTRNLG (CNPATH,'OLD',LENNAM)
      CFNAME = CNPATH
      RETURN
      END
 
CODE FOR RRAND
      REAL FUNCTION RRAND ( )
      DOUBLE PRECISION RANVAL
      RANVAL = RANDOM()
      RRAND = REAL(RANVAL)
      RETURN
      END
 
CODE FOR ZPOLGN
      SUBROUTINE ZPOLGN ( IX,IY,N,ICOL)
      INTEGER IX(N),IY(N),ICOL
      INCLUDE 'COMMON.INC'
      INCLUDE 'COMMON1.INC'
      INTEGER*2 ICOL2,HANDLE,ERROR
      ICOL2 = ICOL
      DO 10 I = 1 , N
C cljf
        ixx2(i) = nint(float(ix(i))*scale_X)
        iyy2(i) = nint(float(iy(i))*scale_Y)

10    CONTINUE
      CALL CREATE_POLYGON@(IXX2,IYY2,N,HANDLE,ERROR)
      CALL FILL_POLYGON@(HANDLE,ICOL2,ERROR)
      CALL DELETE_POLYGON_DEFINITION@(HANDLE,ERROR)
      RETURN
      END
 
CODE FOR ZCURSR
      SUBROUTINE ZCURSR (IX,IY)
C cljf
C      INTEGER*2 IXX,IYY
C      IXX = IX
C      IYY = IY
C      CALL SET_CURSOR_POS@(IXX,IYY)
C      RETURN
      END
 

CODE FOR ZGTARA
C THIS SUBROUTINE GETS THE POLYGONAL AREA FOR THE INCLUDE/EXCLUDE
C COMMANDS
      SUBROUTINE ZGTARA (IX,IY,N,IPPOS)
      INCLUDE 'COMMON1.INC'
      INTEGER IX(N),IY(N)
      INTEGER*4 IXX,IYY,IXPOS,IYPOS,IXOLD,IYOLD,IXINIT,IYINIT
      INTEGER*4 IB
      LOGICAL LCROSS
      INTEGER IPPOS
      IPPOS = -1

C cljf
      icol = 14
      call SetGraphicsCursor(2)
      call graphics_write_mode@(3)

      CALL ZMDISP
C NOW BEGIN TO LOOP
      IXOLD = -1
      IYOLD = -1
      IXINIT = -1
      IYINIT = -1
      LCROSS = .TRUE.
      IPPOS = 0
30    CONTINUE

C cljf
C      CALL GET_KEY1@(KK)
      call zgtky1(kk)

      IB = 0
      IC = 1
      CALL GET_MOUSE_BUTTON_PRESS_COUNT(IC,IB)
      IF (IB.NE.0 .OR. KK.EQ.13) THEN
C WE NEED TO DELETE THE POLYGON
        CALL ZMHIDE
        IF (IXOLD.NE.-1) THEN
          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
        ENDIF
        IF (IPPOS.GT.1) THEN
          DO 80 I = IPPOS-1, 1, -1
            IXOLD = IX(I)
            IYOLD = IY(I)
            IXPOS = IX(I+1)
            IYPOS = IY(I+1)
            CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
80        CONTINUE
        ENDIF
        CALL ZMINIT
        IPPOS = 0

C  cljf
        call SetGraphicsCursor(1)
        call graphics_write_mode@(1)
        return
      ENDIF
      IC=0
      CALL GET_MOUSE_BUTTON_PRESS_COUNT(IC,IB)

      IF (IB.NE.0) THEN
C DRAW TO THE NEW POSITION
        CALL GET_MOUSE_POSITION(IXPOS,IYPOS)
        IXOLD = IXPOS
        IYOLD = IYPOS
        IF (IXINIT.EQ.-1) THEN
          IXINIT = IXPOS
          IYINIT = IYPOS
        ENDIF
        IPPOS = IPPOS + 1
        IX(IPPOS) = IXPOS
        IY(IPPOS) = IYPOS
C CHECK FOR INITIAL POINT
        IF (.NOT.LCROSS) THEN
          CALL ZMINIT
C SET THE FIRST AND LAST POINTS TO BE EQUAL
          IX(IPPOS) = IX(1)
          IY(IPPOS) = IY(1)

C cljf - reset cursor and return values in ix,iy scaled correctly
          call SetGraphicsCursor(1)
          do i=1,ippos
             ix(i)=nint(float(ix(i))/scale_X)
             iy(i)=nint(float(iy(i))/scale_Y)
          enddo
          call zmore1(' ',0)
          call graphics_write_mode@(1)
          RETURN
        ENDIF
      ELSE IF (IXOLD.NE.-1) THEN
C CHECK FOR MOVEMENT
        CALL GET_MOUSE_POSITION(IXX,IYY)
        IF (ABS(IXX-IXPOS).NE.0 .OR. ABS(IYY-IYPOS).NE.0) THEN
C THE MOUSE HAS MOVED
          CALL ZMHIDE
          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
          IXPOS = IXX
          IYPOS = IYY
          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,ICOL)
          CALL ZMDISP
        ENDIF
C DO WE NEED TO CHANGE THE CURSOR ?
        IF (ABS(IXX-IXINIT).LT.4.AND.ABS(IYY-IYINIT).LT.4) THEN
          IF (LCROSS) THEN
            call SetGraphicsCursor(3)
            LCROSS = .FALSE.
          ENDIF
        ELSE IF (.NOT.LCROSS) THEN
            call SetGraphicsCursor(2)
            LCROSS = .TRUE.
        ENDIF
      ENDIF
      GOTO 30
      END





CCCC This routine replaced by the one above, to fix it. CCCC
cCODE FOR ZGTARA
cC THIS SUBROUTINE GETS THE POLYGONAL AREA FOR THE INCLUDE/EXCLUDE
cC COMMANDS
c      SUBROUTINE ZGTARA (IX,IY,N,IPPOS)
c      INCLUDE 'COMMON1.INC'
c      INTEGER IX(N),IY(N)
c      INTEGER*2 IXX,IYY,IXPOS,IYPOS,IXOLD,IYOLD,IXINIT,IYINIT
c      INTEGER*4 IB
c      LOGICAL LCROSS
c      INTEGER IPPOS
c      IPPOS = -1
cC cljf
c      call SetGraphicsCursor(2)
c
c      CALL ZMDISP
cC NOW BEGIN TO LOOP
c      IXOLD = -1
c      IYOLD = -1
c      IXINIT = -1
c      IYINIT = -1
c      LCROSS = .TRUE.
c      IPPOS = 0
c30    CONTINUE
c
cC cljf
cC      CALL GET_KEY1@(KK)
c      call zgtky1(kk)
cc
c      IB = 0
c      IC = 1
c      CALL GET_MOUSE_BUTTON_PRESS_COUNT(IC,IB)
c      IF (IB.NE.0 .OR. KK.EQ.13) THEN
cC WE NEED TO DELETE THE POLYGON
c        CALL ZMHIDE
c        IF (IXOLD.NE.-1) THEN
c          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,14+128)
c        ENDIF
c        IF (IPPOS.GT.1) THEN
c          DO 80 I = IPPOS-1, 1, -1
c            IXOLD = IX(I)
c            IYOLD = IY(I)
c            IXPOS = IX(I+1)
c            IYPOS = IY(I+1)
c            CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,14+128)
c80        CONTINUE
c        ENDIF
c        CALL ZMINIT
c        IPPOS = 0
c
cC  cljf
c        call SetGraphicsCursor(1)
c        RETURN
c      ENDIF
c      IC=0
c      CALL GET_MOUSE_BUTTON_PRESS_COUNT(IC,IB)
c
c      IF (IB.NE.0) THEN
cC DRAW TO THE NEW POSITION
c        CALL GET_MOUSE_POSITION(IXPOS,IYPOS)
c        IXOLD = IXPOS
c        IYOLD = IYPOS
c        IF (IXINIT.EQ.-1) THEN
c          IXINIT = IXPOS
c          IYINIT = IYPOS
c        ENDIF
c        IPPOS = IPPOS + 1
c        IX(IPPOS) = IXPOS
c        IY(IPPOS) = IYPOS
cC CHECK FOR INITIAL POINT
c        IF (.NOT.LCROSS) THEN
c          CALL ZMINIT
cC SET THE FIRST AND LAST POINTS TO BE EQUAL
c          IX(IPPOS) = IX(1)
c          IY(IPPOS) = IY(1)
c
cC cljf - reset cursor and return values in ix,iy scaled correctly
c          call SetGraphicsCursor(1)
c          do i=1,ippos
c             ix(i)=nint(float(ix(i))/scale_X)
c             iy(i)=nint(float(iy(i))/scale_Y)
c          enddo
c          call zmore1(' ',0)
c
c          RETURN
c        ENDIF
c      ELSE IF (IXOLD.NE.-1) THEN
cC CHECK FOR MOVEMENT
c        CALL GET_MOUSE_POSITION(IXX,IYY)
c        IF (ABS(IXX-IXPOS).NE.0 .OR. ABS(IYY-IYPOS).NE.0) THEN
cC THE MOUSE HAS MOVED
c          CALL ZMHIDE
c          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,14+128)
cc          IXPOS = IXX
c          IYPOS = IYY
c          CALL DRAW_LINE@(IXOLD,IYOLD,IXPOS,IYPOS,14+128)
c          CALL ZMDISP
c        ENDIF
cC DO WE NEED TO CHANGE THE CURSOR ?
c        IF (ABS(IXX-IXINIT).LT.4.AND.ABS(IYY-IYINIT).LT.4) THEN
c          IF (LCROSS) THEN
c            call SetGraphicsCursor(3)
c            LCROSS = .FALSE.
c          ENDIF
c        ELSE IF (.NOT.LCROSS) THEN
c            call SetGraphicsCursor(2)
c            LCROSS = .TRUE.
c        ENDIF
c      ENDIF
c      GOTO 30
c      END

