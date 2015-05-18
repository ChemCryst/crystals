C $Log: not supported by cvs2svn $
C Revision 1.30  2009/07/02 09:24:50  djw
C Simplify encapsulated postscript printing.  Diagrams are now in landscape mode (as
C  normal PS) and do not need re-scalling. Bounding box is the full A4 sheet so does
C  not need recalculating.
C Add a few useful comments into PS header region.
C Output each picture to a separate file
C
C Revision 1.29  2006/12/05 12:42:58  arie
C Bug fix in archiving and retrieving with labels; closing archive files correctly
C 
C Revision 1.28  2006/12/04 15:17:52  arie
C *** empty log message ***
C
C Revision 1.27  2006/11/27 16:49:01  djw
C INFO PACKNO shows the complete symmetry operator in the listing file
C
C Revision 1.26  2006/03/16 11:36:38  arie
C Archive and Retrieve option improved for labels
C
C Revision 1.25  2006/03/13 15:59:47  arie
C Added functionalities (archive and retrieve)
C These are FILE commands
C
C Revision 1.24  2005/02/08 15:59:47  stefan
C 1. Added precompiler if's for the mac source
C
C Revision 1.23  2005/01/23 09:52:52  rich
C Reinstate old history for Cameron files. History for changes since Dec 23 is
C lost, but changes are not!
C
C Revision 1.2  2004/12/13 16:16:48  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:12  rich
C New CRYSTALS repository
C
C Revision 1.22  2004/02/04 16:58:11  stefan
C Changes for Mac command line version
C
C Revision 1.21  2003/11/10 10:17:53  djw
C Set fontface to Arial and point size 20
C
C Revision 1.20  2003/05/07 12:18:53  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.19  2003/01/14 10:28:15  rich
C g77 spotted undeclard logical variable.
C
C Revision 1.18  2002/06/28 16:20:56  Administrator
C Enable NEW to be stored in LIST 5, try to fix postscript line thickness and boundingbox
C
C Revision 1.17  2001/11/06 12:42:34  Administrator
C Create proper bounding box for EPS
C
C Revision 1.16  2001/06/18 08:17:24  richard
C Set proper resolution for screen device in GIL version.
C
C Revision 1.15  2000/12/22 12:15:05  CKP2
C Add common block XUNITS, change ipage to jpage
C
C Revision 1.14  2000/12/13 19:15:00  richard
C Bug fix - Return value of logical function LFILES was being assigned to an INTEGER
C value.
C
C Revision 1.13  2000/07/17 13:55:03  CKP2
C fix up stereo
C
C Revision 1.12  2000/02/23 12:18:09  ckp2
C djw  Add .XYZ (Chime) output, fix bug with setunit
C
C Revision 1.11  2000/02/08 20:27:18  ckp2
C djw fix bug so that 'dist range value value' now works
C
C Revision 1.10  1999/12/23 12:29:17  ckp2
C djw  Close postscript file once figure is written
C
C Revision 1.9  1999/11/18 17:59:04  ckp2
C djw  enable printing from within CAMERON
C
C Revision 1.8  1999/07/22 11:29:49  richard
C RIC: Setting scale for postscript: Cameron multiplied the fixed scale by
C 10.0 to get the post script value. For the GID version this should be 2.0
C
C Revision 1.7  1999/06/13 16:10:10  dosuser
C RIC: Use common block to store device.cmn information.
C Device.cmn no longer needed.
C
C Revision 1.6  1999/06/04 11:43:08  dosuser
C RIC: Added support for linux graphical interface version (GIL)
C
C Revision 1.5  1999/05/11 11:56:38  dosuser
C RIC: Calling ZMORE with wrong # of args. Fixed.
C
C Revision 1.4  1999/05/07 15:26:19  dosuser
C RIC: Added support for cursor rotation in the GID version.
C      Changed label size (ILSIZE) by a factor of ~6 for GID version.
C      (Makes it much easier to click on the labels with the mouse.
C

CRYSTALS CODE FOR COMM.FOR
CAMERON CODE FOR COMMAND
CODE FOR ZCMD1
      SUBROUTINE ZCMD1 (ID)
C This is the code for the VIEW group of commands.
      SAVE OLDSCL

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

      INTEGER K
      CHARACTER*60 FILENM
      LOGICAL LEXIST, IDJW
      LOGICAL LFILES
      LOGICAL LITEMP
      CHARACTER*72 CTEXT
      CHARACTER*1 CANS
      CHARACTER*80 CFORT
      INTEGER IFACE(3)
      REAL MATDUM (4,4)
      REAL SCLSAV
      INTEGER IAXDAT(3)
      DATA IAXDAT /1,4,3/

      ID = ID - (ID/100)*100 + 1
c      write(cline,'('' jump to '',i5)')id
c      call zmore(cline,0)
      GOTO (100,101,1222,103,104,105,106,122,108,109,110,111,112,113,
     c 114,115,116,117,118,119,120,121,122,123,124,125,112,113,
     c 128,129,130) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
1222   CONTINUE
      RETURN
100   CONTINUE
C VIEW
C LOAD IN THE DEVICE PARAMETERS IF THEY HAVE CHANGED
      IF (IDEV.EQ.-1) THEN
       CALL ZMORE('Error you have not chosen a screen device.',0)
        CALL ZBEEP
        IPROC = 0
        RETURN
      ENDIF
      RES = 1.0
      IF (IDEV.NE.ISCRN) THEN
        XCEN = XCENS
        YCEN = YCENS
        SCLLIM = SCLIMS
C        ISCAL = ISCALS
        IBACK = IBACKS
        IFORE = IFORES
        ILABCL = ILABCS
        IBNDCL = IBNDCS
        ICLDEF = ICLDES
C        IFONT = 12 (changed from IFSIZE by DJW)
#if defined(_DOS_)
        ILSIZE = 8
#else
        ILSIZE = 60
#endif
C MOVE OVER THE COLOUR NUMBERS
        DO 1000 I = 1 , ICLMAX
C          IDEVCL(I) = IDEVCS(I)
          IDEVCL(I) = I-1
1000    CONTINUE
        ISCRN = IDEV
        CALL ZCLEAR
      ENDIF
      IHOLD = IHAND
      IF (ISCRN.EQ.1 .OR. ISCRN.EQ.7) THEN
        IHAND = 1
      ELSE
        IHAND = 0
      ENDIF
C LOOK FOR HAND CHANGES - THIS ALTERS THE VALUE OF LABEL Y COORDINATES
      IF ((IHOLD.NE.IHAND).AND.(IRATOM.GT.0)) THEN
        DO 1110 I = IRATOM , IFVIEW-1, IPACKT
          RSTORE(I+ILAB+1) = -RSTORE(I+ILAB+1)
1110      CONTINUE
      ENDIF
C SET THE SCALE IF REQUIRED
      IF (ISLCNT.EQ.0) SCALE = SCLFIX
c      ivchan = 1
      xoff = 0.
      yoff = 0.
C CHECK FOR STEREO PAIRS
      IF (ISTREO.EQ.1) THEN
        CALL ZCLEAR
        CALL ZCLARE(0,IDEVCL(IBACK+1))
        XCEN = XCEN * 0.45
        IVCHAN = 1
c----- half rotation left and right
        ang = strang * pi / (2. * 180.0)
cmay2000        call zrot(-ang,2)
        call zrot(ang,2)
        call zatmul(0,0,0)
        call zdovi
      else
        call zatmul(0,0,0)
        call zdovi
      endif
C CHECK FOR THE OTHER STEREO PAIR
      IF (ISTREO.EQ.1) THEN
        IVCHAN = 1
        XOFF = XCEN / 0.45
        YOFF = 0.0
c----- full rotation  right
        ang = strang * pi / (2. * 180.0)
cmay2000        CALL ZROT(2.* ANG,2)
        CALL ZROT(-2.* ANG,2)
C SAVE THE SCALE SO THAT BOTH PICTURES ARE DONE ON THE SAME SCALE
        SCLSAV = SCALE
        CALL ZATMUL (0,0,0)
        SCALE = SCLSAV
        CALL ZDOVI
        IVCHAN = 1
c------ restore orientation and centre
cmay2000        CALL ZROT(-ANG,2)
        CALL ZROT(ANG,2)
        CALL ZATMUL(0,0,0)
        XCEN = XCEN / 0.45
        XOFF = 0.0
        YOFF = 0.0
      ENDIF
            GOTO 9999
101   CONTINUE
C
C COPY
C LOAD IN THE DEVICE PARAMETERS IF THEY HAVE CHANGED
C NEED TO CHECK THE FILE - IS IT OPEN?
      IF (IHARD.EQ.-1) THEN
        CALL ZBEEP
        CALL ZMORE ('Error you have not chosen a hardcopy device.',0)
        CALL ZMORE1 ('Error you have not chosen a hardcopy device.',0)
        IPROC = 0
        RETURN
      ENDIF
      NPOS = ICCMMD (ICCNT)
      CALL ZGTTXT ( FILENM , 60 , NPOS)
1010  CONTINUE
      INQUIRE (FILE=FILENM,EXIST=LEXIST,NUMBER=NUM)
      IF (LEXIST) THEN
        CALL ZBEEP
        IF (NUM.EQ.IFOUT) THEN
C IS IT CONNECTED TO THE CORRECT CHANNEL
          CALL ZMORE(
     + 'The file is already in use, do you want to append to it (y/n)?'
     + ,0)
          CALL ZMORE1(
     + 'The file is already in use, do you want to append to it (y/n)?'
     + ,0)
1020      CONTINUE
          READ (ISTOUT,'(A1)') CANS
          IF ((CANS.EQ.'N').OR.(CANS.EQ.'n')) THEN
            CALL ZMORE('Enter the name of the output file.',0)
            CALL ZMORE1('Enter the name of the output file.',0)
            READ (ISTOUT,'(A60)') FILENM
            GOTO 1010
          ELSE IF ((CANS.NE.'y').AND.(CANS.NE.'Y')) THEN
            CALL ZBEEP
            call zmore1('Reply not recognised',0)
            GOTO 1020
          ENDIF
        ELSE
C          WRITE (ISTOUT,'(A)')
          CALL ZMORE(
     1   'The file already exists please choose another filename',0)
          CALL ZMORE1(
     1   'The file already exists please choose another filename',0)
          IPROC = 0
          RETURN
         ENDIF
      ELSE
C CHECK THE FILENAME
        CALL ZFORTF (FILENM,CFORT,IERR)
        IF (IERR.EQ.1) THEN
          IPROC = 0
          RETURN
        ENDIF
        CALL ZMORE ('File created as :',0)
        CALL ZMORE (CFORT,0)
        CALL ZMORE1 ('File created as :'//cfort ,0)
        IPOST = 0
C OPEN THE FILE
CDJWNOV2001 HOOK IN SCRATCH FILE FOR EPS WORKFILE
cdjwjul09 - output encap same as normal
cdjwjul09         if (iencap .ne. 0) then
c        open IFOUT as scratchfile (not normal see below)
cdjwjul09          idjw = LFILES ( 9 , CFORT , IFOUT )
cdjwjul09         else
         idjw = LFILES ( 5 , CFORT , IFOUT )
cdjwjul09         endif
        IF (.NOT. idjw) THEN
          IPROC = 0
          CALL ZMORE ('Error on file open:',0)
          CALL ZMORE (CFORT,0)
          CALL ZMORE1 ('Error on file open:'// cfort ,0)
          RETURN
        ENDIF
      ENDIF
c
C start "copy" work here
      IF (ISCRN.NE.IHARD) THEN
        XCEN = XCENH
        YCEN = YCENH
        SCLLIM = SCLIMH
c      IF (ISCRN.NE.IHARD) THEN
        IBACK = IBACKH
        IFORE = IFOREH
        ILABCL = ILABCH
        IBNDCL = IBNDCH
        ICLDEF = ICLDEH
C MOVE OVER THE COLOUR NUMBERS
        DO 1001 I = 1 , ICLMAX
C          IDEVCL(I) = IDEVCH(I)
          IDEVCL(I) = I-1
1001    CONTINUE
        ISCRN = IHARD
      ENDIF
C LOOK FOR HAND CHANGES - THIS ALTERS THE VALUE OF LABEL Y COORDINATES
      IF ((IHAND.EQ.1).AND.(IRATOM.GT.0)) THEN
        DO 1111 I = IRATOM , IFVIEW-1, IPACKT
          RSTORE(I+ILAB+1) = -RSTORE(I+ILAB+1)
1111      CONTINUE
      ENDIF
      IHAND = 0
C
      RES = 1.
      XOFF = 0.
      YOFF = 0.0
C SAVE THE SCALE and centre
      OLDSCL = SCALE
      XCENOL = XCEN
c- note that this changes scale
      CALL ZATMUL(0,0,0)
c
      IF (ISTREO.EQ.1) THEN
        CALL ZCLEAR
        CALL ZCLARE(0,IDEVCL(IBACK+1))
C       THIS IS 3.5 CM IN POINTS
C----- SET CENTRE SO THAT FIGURE FITS IN 2* DXOFF BOX
        DXOFF = 3.5 *  720 / 2.58
        XCEN =  DXOFF
c- note that this changes scale
        CALL ZATMUL(0,0,0)
c       restore xcen
        XCEN = XCENOL
      ELSE
C SCALE DOWN FURTHER TO PRODUCE A BORDER
        IF (ISLCNT.EQ.1) THEN
          SCALE = SCALE * 0.9
        ELSE
          IF (ISCRN.EQ.6 .OR. ISCRN.EQ.5
     +   .OR. ISCRN.EQ.8 ) THEN
#ifdef CRY_NOGUI
            SCALE = SCLFIX * 10.0
#else
            SCALE = SCLFIX * 2.0
#endif
          ELSE
            SCALE = SCLFIX
          ENDIF
        ENDIF
       IF (SCALE.LT.SCLLIM) THEN
C NEED TO UP THE RESOLUTION
         IF ((ISCRN.EQ.6).OR.(ISCRN.EQ.5).OR.(ISCRN.EQ.8)) THEN
           RES = SCLLIM / SCALE
         ENDIF
         XOFF = XCEN * (RES - 1.)
         YOFF = YCEN * (RES - 1.)
       ENDIF
      ENDIF
c
      SCALE = SCALE * RES
#if defined(_DOS_)
      ILSIZE = NINT (8 * RES)
#else
      ILSIZE = NINT (60 * RES)
#endif
      SCLSAV = SCALE
      IF (ISTREO .EQ. 1) THEN
C----- SET LEFT VIEW
        IVCHAN = 1
        ANG = STRANG * PI /(2.0 * 180.)
cmay2000        CALL ZROT (-ANG,2)
        CALL ZROT (ANG,2)
        XOFF = -DXOFF
        YOFF = 0.0
        CALL ZATMUL(0,0,0)
        SCALE  = SCLSAV
       ENDIF
C
      CALL ZDOVI
C
C CHECK FOR THE OTHER STEREO PAIR
      IF (ISTREO.EQ.1) THEN
        XCEN = XCENOL
        XOFF = 0.
        YOFF = 0.0
C----- ROTATE RIGHT
cmay2000        CALL ZROT(2.*ANG,2)
        CALL ZROT(-2.*ANG,2)
        XOFF = DXOFF
        CALL ZATMUL (0,0,0)
        SCALE = SCLSAV
        XCEN = XCENOL
        CALL ZDOVI
        IVCHAN = 1
C----- RESTORE VIEW AND ORIGIN
cmay2000        CALL ZROT(-ANG,2)
        CALL ZROT(ANG,2)
        CALL ZATMUL(0,0,0)
        XOFF = 0.0
        YOFF = 0.0
      ENDIF
      IPOST = 2
C      RESET THE SCALE
cdjwjun2002
      write(cline,'(a,2f10.3)') ' scale', scale, oldscl
      call zmore(cline,0)
      SCALE  = OLDSCL
      ares = 1./res
      res = 1.
      CALL ZCLEAR
cdjwnov2001 - post-process encapsulated postscript
cdjwjul09  encap reteated as normal PS
cdjwjul09       if (iencap .gt. 0) then
c        open real file on scratchfile unit not normal!
cdjwjul09          idjw = LFILES ( 5 , CFORT , ISCRAT )
cdjwjul09         IF (.NOT. idjw) THEN
cdjwjul09           IPROC = 0
cdjwjul09           CALL ZMORE ('Error on file open:',0)
cdjwjul09           CALL ZMORE (CFORT,0)
cdjwjul09           CALL ZMORE1 ('Error on file open:'// cfort ,0)
cdjwjul09           RETURN
cdjwjul09         ENDIF
cdjwjul09        call xpostp (IFOUT, ISCRAT, IFONT, ares)
cdjwjul09       endif
cdjwdec99
c 'copy' finished - close the files
      LITEMP = LFILES ( 0 , CFORT , IFOUT )
      LITEMP = LFILES ( 0 , CFORT , ISCRAT )
      GOTO 9999
103   CONTINUE
C XROT
C Ref: Mathematical Elements for Computer Graphics p119
C This calculates the matrix for rotation about a point XC,YC,ZC.
C NB : XC,YC,ZC must be in orthogonal coordinates!
      IVCHAN = 1
      ANG = RCOMMD (IRCNT)*PI/180.0
      CALL ZROT(ANG,1)
      GOTO 9999
104   CONTINUE
C YROT
      IVCHAN = 1
      ANG = RCOMMD (IRCNT)*PI/180.0
      CALL ZROT(ANG,2)
      GOTO 9999
105   CONTINUE
C ZROT
      IVCHAN = 1
      ANG = RCOMMD (IRCNT)*PI/180.0
      CALL ZROT(ANG,3)
      GOTO 9999
106   CONTINUE
C ROTATE
      IVCHAN = 1
      ANG = RCOMMD (IRCNT)*PI/180.0
      CALL ZROT (ANG,1)
      ANG = RCOMMD (IRCNT+1)*PI/180.0
      CALL ZROT (ANG,2)
      ANG = RCOMMD (IRCNT+2)*PI/180.0
      CALL ZROT (ANG,3)
      call zmore(' rotation matrix after rotate',0)
      write(cline,'(4f9.4)')(mat1(1,i),i=1,4)
      call zmore(cline,0)
      write(cline,'(4f9.4)')(mat1(2,i),i=1,4)
      call zmore(cline,0)
      write(cline,'(4f9.4)')(mat1(3,i),i=1,4)
      call zmore(cline,0)
      write(cline,'(4f9.4)')(mat1(4,i),i=1,4)
      call zmore(cline,0)
      GOTO 9999
108   CONTINUE
C PLANE
C CHECK FOR PLANE ALL
      IF (ICC.EQ.0) GOTO 9999
C MOVE THE INFO INTO THE WORK SPACE AT THE CENTRE OF THE RSTORE ARRAY
      IVCHAN = 1
      NROOM = ICC * 4
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.LT.0) THEN
        IPROC = 0
        CALL ZMORE('Cannot calculate PLANE - no room in RSTORE.',0)
        CALL ZMORE1('Cannot calculate PLANE - no room in RSTORE.',0)
        RETURN
      ENDIF
      DO 10 I = ICCNT,ICCNT+ICC-1
C GET THE COORDS
        DO 20 J = 0,2
          N = ISINIT + (ICCMMD(I) - ICATOM)*IPACKT
          RSTORE (IRLAST+(I-ICCNT)*4+J) = RSTORE(N+1+J)
20      CONTINUE
        RSTORE (IRLAST+(I-ICCNT)*4+3) = 1.0
10    CONTINUE
C CALCULATE THE MATRIX TO ROTATE AND VIEW ONTO THE PLANE
      CALL ZDOPLN (ICC,1)
C      IF (IMAXIM.EQ.1) CALL ZMAXIM (3)
      GOTO 9999
109   CONTINUE
C FACE
      IVCHAN = 1
      NZERO = 0
      DO 50 I = 0,2
        IFACE(I+1) = NCOMMD (INCNT+I)
        IF (IFACE(I+1).EQ.0) NZERO = NZERO + 1
50    CONTINUE
      IF (NZERO.EQ.3) THEN
       CALL ZMORE( 'Cannot project onto a 0 0 0 plane!',0)
       CALL ZMORE1( 'Cannot project onto a 0 0 0 plane!',0)
        RETURN
      ENDIF
      NROOM = 12
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.LT.0) THEN
        IPROC = 0
        CALL ZMORE( 'Cannot calculate FACE - no room in RSTORE.',0)
        CALL ZMORE1( 'Cannot calculate FACE - no room in RSTORE.',0)
        RETURN
      ENDIF
      CALL ZZEROF (RSTORE(IRLAST),12)
      IF (NZERO.EQ.0) THEN
C GENERAL H K L CASE
        DO 60 I = 0,2
          RSTORE (IRLAST+I*4+I) = 1.0/IFACE(I+1)
60      CONTINUE
      ELSE IF (NZERO.EQ.1) THEN
        DO 70 I = 0,2
          IF (IFACE(I+1).EQ.0) THEN
            RSTORE(IRLAST+I*4+I) = 1.0
C IF WE HAVE A PARALLEL SIDE, MAKE THE EQUIVALENT
C COORDINATE 1.0 AND USE THE 1/N FROM ONE OF THE OTHERS
            J = MOD(I+1,3)
            RSTORE(IRLAST+I*4+J) = 1.0/IFACE(J+1)
          ELSE
            RSTORE(IRLAST+I*4+I) = 1.0/IFACE(I+1)
          ENDIF
70      CONTINUE
      ELSE IF (NZERO.EQ.2) THEN
C FIND THE NON ZERO INDEX
        DO 80 I = 0,2
          IF (IFACE(I+1).NE.0) NZERO = I
80      CONTINUE
C SET UP COORDS
        DO 90 I = 0,2
          IF (I.EQ.NZERO) THEN
            RSTORE(IRLAST+I*4+I) = 1.0/IFACE(I+1)
          ELSE
            RSTORE(IRLAST+I*4+NZERO) = 1.0/IFACE(NZERO+1)
            RSTORE(IRLAST+I*4+I) = 1.0
          ENDIF
90      CONTINUE
      ENDIF
      DO 94 I = 3,11,4
        RSTORE (IRLAST+I) = 1.0
94    CONTINUE
      CALL ZDOPLN (3,1)
C      IF (IMAXIM.EQ.1) CALL ZMAXIM (3)
      GOTO 9999
110   CONTINUE
C ALONG
C SET UP THE COORDS
      IVCHAN = 1
      IF (ICC.EQ.0) GOTO 9999
      NROOM = ICC * 4
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.LT.0) THEN
        IPROC = 0
        CALL ZMORE( 'Cannot calculate ALONG - no room in RSTORE.',0)
        CALL ZMORE1( 'Cannot calculate ALONG - no room in RSTORE.',0)
        RETURN
      ENDIF
      DO 1101 I = ICCNT,ICCNT+ICC-1
        N = ISINIT + (ICCMMD(I) - ICATOM)*IPACKT
        DO 1102 J = 0,2
          RSTORE (IRLAST+J+(I-ICCNT)*4) = RSTORE(N+J+1)
1102    CONTINUE
          RSTORE (IRLAST+(I-ICCNT)*4+3) = 1.0
1101    CONTINUE
      CALL ZDOPLN (2,2)
C      IF (IMAXIM.EQ.1) CALL ZMAXIM (3)
      GOTO 9999
111   CONTINUE
C AXIS
      IVCHAN = 1
      IAXIS = ICCMMD(ICCNT)-1
      NROOM = 8
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.LT.0) THEN
        IPROC = 0
        CALL ZMORE( 'Cannot calculate AXIS - no room in RSTORE.',0)
        CALL ZMORE1( 'Cannot calculate AXIS - no room in RSTORE.',0)
        RETURN
      ENDIF
      CALL ZZEROF (RSTORE(IRLAST),8)
      RSTORE (IRLAST+IAXIS) = 1.0
      RSTORE (IRLAST+3) = 1.0
      RSTORE (IRLAST+7) = 1.0
      CALL ZDOPLN (-2,2)
C      IF (IMAXIM.EQ.1) CALL ZMAXIM (3)
      IAXIS = IAXIS + 1
      GOTO 9999
112   CONTINUE
C VERTICAL / VERTICAL AXIS
C GET THE COORDS
      IVCHAN = 1
      IF (ICC.EQ.0) RETURN
      IF (ICC.EQ.1) THEN
C THIS IS AXIS
        N = ISVIEW + IAXDAT(ICCMMD(ICCNT))*IPACKT
        N1 = ISVIEW
      ELSE
        N = ISVIEW + (ICCMMD(ICCNT) - ICATOM)*IPACKT
        N1 = ISVIEW + (ICCMMD(ICCNT+1) - ICATOM)*IPACKT
      ENDIF
      IF (ABS(RSTORE(N1+IXYZO)-RSTORE(N+IXYZO)).LT.0.0001) RETURN
      ANG = ( RSTORE(N1+IXYZO+1) - RSTORE(N+IXYZO+1) ) /
     +      ( RSTORE(N1+IXYZO)   - RSTORE(N+IXYZO) )
      ANG = ATAN(ANG)
      IF (RSTORE(N1+IXYZO)-RSTORE(N+IXYZO) .LT.0) THEN
        ANG = PI + ANG
      ENDIF
      ANG = PI/2.0 - ANG
C STORE THE ORIGINAL CENTRE OF ROTATION
      XC1 = XC
      YC1 = YC
      ZC1 = ZC
      XC = RSTORE(N+IXYZO)
      YC = RSTORE(N+IXYZO+1)
      ZC = RSTORE(N+IXYZO+2)
      CALL ZROT(ANG,3)
      XC = XC1
      YC = YC1
      ZC = ZC1
      GOTO 9999
113   CONTINUE
C HORIZONTAL
C GET THE COORDS
      IVCHAN = 1
      IF (ICC.EQ.0) RETURN
      IF (ICC.EQ.1) THEN
C THIS IS AXIS
        N = ISVIEW + IAXDAT(ICCMMD(ICCNT))*IPACKT
        N1 = ISVIEW
      ELSE
        N = ISVIEW + (ICCMMD(ICCNT) - ICATOM)*IPACKT
        N1 = ISVIEW + (ICCMMD(ICCNT+1) - ICATOM)*IPACKT
      ENDIF
      IF (ABS(RSTORE(N1+IXYZO+1)-RSTORE(N+IXYZO+1)).LT.0.0001) RETURN
      IF (ABS(RSTORE(N1+IXYZO)-RSTORE(N+IXYZO)).LT.0.0001) THEN
        ANG = PI*0.5
      ELSE
        ANG = ( RSTORE(N1+IXYZO+1) - RSTORE(N+IXYZO+1) ) /
     +        ( RSTORE(N1+IXYZO)   - RSTORE(N+IXYZO) )
        ANG = ATAN(ANG)
      ENDIF
      IF (RSTORE(N1+IXYZO)-RSTORE(N+IXYZO) .LT.0) THEN
        ANG = PI + ANG
      ENDIF
      ANG = -ANG
C STORE THE ORIGINAL CENTRE OF ROTATION
      XC1 = XC
      YC1 = YC
      ZC1 = ZC
      XC = RSTORE(N+IXYZO)
      YC = RSTORE(N+IXYZO+1)
      ZC = RSTORE(N+IXYZO+2)
      CALL ZROT(ANG,3)
      XC = XC1
      YC = YC1
      ZC = ZC1
      GOTO 9999
114   CONTINUE
C BISECT
C GET THE COORDS OF THE POINT BETWEEN ATOMS 1 AND 3.
      IVCHAN = 1
      NROOM = 8
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.LT.0) THEN
        IPROC = 0
        CALL ZMORE( 'Cannot calculate BISECT - no room in RSTORE.',0)
        CALL ZMORE1( 'Cannot calculate BISECT - no room in RSTORE.',0)
        RETURN
      ENDIF
      CALL ZZEROF (RSTORE(IRLAST),8)
      DO 1141 I = ICCNT,ICCNT+2,2
        N = ISINIT + (ICCMMD(I) - ICATOM)*IPACKT
        DO 1142 J = 0,2
          RSTORE(IRLAST+J) = RSTORE(IRLAST+J) + RSTORE (N+1+J)
1142    CONTINUE
1141  CONTINUE
      DO 1143 I = 0,2
      RSTORE (IRLAST+I) = RSTORE(IRLAST+I)/2.0
1143  CONTINUE
C GET COORDS OF THE APEX ATOM
      N1 = ISINIT + (ICCMMD(ICCNT+1) - ICATOM)*IPACKT
      RSTORE (IRLAST+3) = 1.0
      DO 1144 I = 4,6
      RSTORE (IRLAST+I) = RSTORE(N1+I-3)
1144  CONTINUE
      RSTORE (IRLAST+7) = 1.0
      CALL ZDOPLN (2,2)
C NOW ROTATE SO THAT THE LINE IS HORIZONTAL
      XC1 = XC
      YC1 = YC
      ZC1 = ZC
      XC = RSTORE(N1+IXYZO)
      YC = RSTORE(N1+IXYZO+1)
      ZC = RSTORE(N1+IXYZO+2)
      IF (ABS(RSTORE(N1+IXYZO)-RSTORE(N+IXYZO)).LT.0.0001) RETURN
      ANG = ( RSTORE(N+IXYZO+1) - RSTORE(N1+IXYZO+1) ) /
     +      ( RSTORE(N+IXYZO)   - RSTORE(N1+IXYZO) )
      ANG = ATAN(ANG)
      IF (RSTORE(N1+IXYZO)-RSTORE(N+IXYZO) .LT.0) THEN
        ANG = PI + ANG
      ENDIF
      ANG = -ANG
      CALL ZROT(ANG,3)
      XC = XC1
      YC = YC1
      ZC = ZC1
      GOTO 9999
115   CONTINUE
C CURSOR ROTATION
C CHANGE OUTPUT BACK TO THE SCREEN
      IF (IDEV.EQ.-1) THEN
        CALL ZMORE( 'Error you have not chosen a screen device.',0)
        CALL ZBEEP
        IPROC =0
        RETURN
      ENDIF
      IF (IDEV.NE.ISCRN) THEN
        XCEN = XCENS
        YCEN = YCENS
        SCLLIM = SCLIMS
C        ISCAL = ISCALS
        IBACK = IBACKS
        IFORE = IFORES
        ILABCL = ILABCS
        IBNDCL = IBNDCS
        ICLDEF = ICLDES
C        IFSIZE = 12
#if defined(_DOS_)
        ILSIZE = 8
#else
        ILSIZE = 60
#endif
C MOVE OVER THE COLOUR NUMBERS
        DO 1152 I = 1 , ICLMAX
          IDEVCL(I) = IDEVCS(I)
1152    CONTINUE
        ISCRN = IDEV
        CALL ZCLEAR
        IHOLD = IHAND
        IF (ISCRN.EQ.1 .OR. ISCRN. EQ. 7) THEN
          IHAND = 1
        ELSE
          IHAND = 0
        ENDIF
C LOOK FOR HAND CHANGES - THIS ALTERS THE VALUE OF LABEL Y COORDINATES
        IF ((IHOLD.NE.IHAND).AND.(IRATOM.GT.0)) THEN
          DO 1151 I = IRATOM , IFVIEW-1, IPACKT
            RSTORE(I+ILAB+1) = -RSTORE(I+ILAB+1)
1151        CONTINUE
        ENDIF
        CALL ZATMUL(0,0,0)
      ENDIF
      IVCHAN = 1
      ICURS = 1
      CALL ZCLEAR
      CALL ZCLARE(0,IDEVCL(IBACK+1))
      CALL ZMORE( 'Use cursor keys to rotate the molecule',0)
      CALL ZMORE1( 'Use cursor keys to rotate the molecule',0)
C      CALL ZATMUL(0,0,0)
      CALL ZDOVI
      ANG = -5.0*PI/180.0

#ifdef CRY_GUI
      CALL ZMORE('^^CO SET _CAMERONVIEW CURSORKEYS=YES',0)
      IUNIT = 5
#endif
1150  CONTINUE
#if defined(_DOS_)
      CALL ZGETKY(K)
      IF (K.EQ.0) GOTO 1150
#else
      K = KRDLIN ( IUNIT, CLINE, LENUSE )
#endif
      CALL ZCLARE(0,IDEVCL(IBACK+1))
      ICURS = 1
#if defined(_DOS_) 
        IF (K.EQ.ICLEFT) THEN
#else
        IF (CLINE(1:1).EQ.'L') THEN
C LEFT
#endif
        ANG = ABS(ANG)
        CALL ZROT(ANG,2)
#if defined(_DOS_) 
      ELSE IF (K.EQ.ICRGHT) THEN
#else
      ELSE IF (CLINE(1:1).EQ.'R') THEN
C RIGHT
#endif
        ANG = -ABS(ANG)
        CALL ZROT(ANG,2)
C UP
#if defined(_DOS_) 
      ELSE IF (K.EQ.ICUP) THEN
#else
      ELSE IF (CLINE(1:1).EQ.'U') THEN
#endif
        ANG = ABS(ANG)
        CALL ZROT(ANG,1)
C DOWN
#if defined(_DOS_) 
      ELSE IF (K.EQ.ICDOWN) THEN
#else
      ELSE IF (CLINE(1:1).EQ.'D') THEN
#endif
        ANG = -ABS(ANG)
        CALL ZROT(ANG,1)
C ANTICLOCKWISE
#if defined(_DOS_)
      ELSE IF (K.EQ.ICANTI) THEN
#else
      ELSE IF (CLINE(1:1).EQ.'A') THEN
#endif
        ANG = -ABS(ANG)
        CALL ZROT(ANG,3)
C CLOCKWISE
#if defined(_DOS_)
      ELSE IF (K.EQ.ICCLCK) THEN
#else
      ELSE IF (CLINE(1:1).EQ.'C') THEN
#endif
        ANG = ABS(ANG)
        CALL ZROT(ANG,3)
#if defined(_DOS_)
      ELSE IF (K.NE.0) THEN
#else
      ELSE
#endif
        ICURS = 0
        CALL ZATMUL(0,0,0)
        CALL ZDOVI
        GOTO 9999
      ENDIF
      CALL ZATMUL(0,0,0)
      CALL ZDOVI
      GOTO 1150
116   CONTINUE
C PLANE ALL
      IVCHAN = 1
      NROOM = ((IFVIEW - ISVIEW) / IPACKT  - 8 ) * 4
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.LT.0) THEN
        IPROC = 0
        CALL ZMORE( 'Cannot calculate PLANE - no room in RSTORE.',0)
        CALL ZMORE1( 'Cannot calculate PLANE - no room in RSTORE.',0)
        RETURN
      ENDIF
      N = 0
      DO 1160 I = ISVIEW + IPACKT * 8 , IFVIEW - 1 , IPACKT
C GET THE COORDS
        IF (RSTORE(I+IPCK+1).LT.0) GOTO 1160
        DO 1162 J = 0,2
          RSTORE (IRLAST+N*4+J) = RSTORE(I+1+J)
1162    CONTINUE
        RSTORE (IRLAST+N*4+3) = 1.0
        N = N + 1
1160  CONTINUE
C CALCULATE THE MATRIX TO ROTATE AND VIEW ONTO THE PLANE
      CALL ZDOPLN (N,1)
C      IF (IMAXIM.EQ.1) CALL ZMAXIM (3)
      GOTO 9999
117   CONTINUE
      IPCX = 1
      GOTO 9999
118   CONTINUE
C PHOTO
      GOTO 9999
119   CONTINUE
C ON
      IPHOTO = 1
      GOTO 9999
120   CONTINUE
C OFF
      IPHOTO = 0
      GOTO 9999
121   CONTINUE
C MATRIX
      GOTO 9999
122   CONTINUE
C FILE
C OPEN THE FILE
      FILENM = CTCOMD ( ITCNT )
      ITCNT = ITCNT + 1
C CHECK WHETHER IT EXISTS
      INQUIRE (FILE=FILENM , EXIST=LEXIST)
      ILENGTE=4*16+4*(IRLAST-IRELM+1+ITOT-IREND+1)+
     &ILEN*(ICLAST-ICELM+1+ITOT-(IGRP-NGRP*2-1)+1)
c      call zmore(cline,0)
      IF (LEXIST) THEN
C IS THERE A FILE OPEN ALREADY?
        INQUIRE (UNIT=IVOUT, OPENED=LEXIST)
        IF (LEXIST) THEN
          CLOSE(IVOUT)
        ENDIF
        OPEN (UNIT=IVOUT, FILE=FILENM, ACCESS='SEQUENTIAL',
     c  FORM = 'UNFORMATTED',STATUS='OLD',ERR=1220)
C OPEN THE FILE AND READ THE NUMBER OF RECORDS
        IVNUM = 0
1210    CONTINUE
        IVNUM = IVNUM + 1
        READ ( IVOUT , REC=IVNUM, ERR = 1211) CTEXT, MATDUM
        GOTO 1210
1211    CONTINUE
        IVNUM = IVNUM - 1
      ELSE
        OPEN (UNIT=IVOUT, FILE=FILENM, ACCESS='SEQUENTIAL',
     c  FORM = 'UNFORMATTED',STATUS='NEW')
        IVNUM = 0
      ENDIF
C      GOTO 9999
       GOTO 123
1220  CONTINUE
C ERROR IN FILE OPEN
      CALL ZBEEP
      WRITE (CLINE,1221) FILENM
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
1221  FORMAT (A12 ,' is not a file of the correct type.')
      IPROC = 0
      GOTO 123
123   CONTINUE
C STORE   will be essentially skipped (avdl)
C GET THE TEXT
       goto 1229
      IF (ICCMMD(ICCNT).GT.6) ICCMMD(ICCNT) = 6
      CTEXT = '                                                  '//
     c '                      '
      DO 1230 I = 1 , ICCMMD ( ICCNT )
        CTEXT((I-1)*12 + 1:(I-1)*12 + 12) = CTCOMD ( ITCNT + I - 1 )
1230  CONTINUE
cavdl WRITE ( IVOUT,REC=IVNUM) CTEXT , MAT1
cavdl check whether labels are present, if so change ILABFG to -1
 1229 IF (IABS(ILABFG).EQ.1)ILABFG=-1
      WRITE (IVOUT)
C COMMON BLOCK /ZCOMAN/ (CAMANA.INC) (35*4)
     c IPROC,IMENCN,ILINE,IBEG,IEND,IN,IR,IC,IINT
     c ,IRL,ICHARS,ICTYPE,INCOM,IPREV,IHEAD,ICC,ICN,ICR,ISTORE,IFOBEY,
     c ICABAN ,ICLOG, IVNUM,
C COMMON BLOCKS /ZSTORI/ AND /ZSTORZ/ (CAMCOM.INC) (2*10000*4)
     c ISTACK,ZSTACK,
C COMMON BLOCK /ZSTORA/ (CAMCOM.INC) (19*4+7*INARGS*4)
     c ICPOS,ICCPOS,ICRPOS,ICTPOS,ICNT,ICCNT,IRCNT,
     c INCNT,ITCNT,ICOMMD,RCOMMD,NCOMMD,INFCMD,ICCMMD,ICNPOS,
     c ICINPS, ICMULT, IXYZO , IATTYP, IPCK , IBOND , ILAB, ISYM,
     c IPACKT , NSCRAT , NELM ,
C COMMON BLOCK /ZDATAC/ (CAMDAT.INC) (32*4)
     c ICOM,IRELM,ICELM,ICATOM,IRATOM,IRLAST,ICLAST,IREND,
     c ICRYST,NSYMM,ISVIEW,ISYMED,ICELLC,IPACK,INATOM,IELROT,
     c IFVIEW,ISINIT,IFINIT,NGRP,IGRP,IKEY,ITEXT,INTXT,ITNUMB,IGG,ICTXT,
     c IGPCK, ICLST5, ICONBG, ICONED, IFIRST ,
C COMMON BLOCK /ZCALCU/ (CAMCAL.INC) (830*4+NBDMAX*3*4)
     c DISEND,DISBEG,ANGEND,ANGBEG,CENTR,NDIST1,PKMIN,
     c PKMAX,PCMIN,PCMAX,PKCNF,PKCNA,D000,AMSYMM,AMTRAN,MAT1,MAT2,
     c ROT,XC,YC,ZC,XCOS,XSIN,PI,ISSPRT,IBDORD,IORD,ISFLAG,ITFLAG,NDIST2
     c ,RSTOL, ISPECL,IENCAT ,
C COMMON BLOCK /ZMCONT/ (CAMMSE.INC) (2*4)
     c IMOUSE,NMOUSE,
C COMMON BLOCK/ZMNUSS/ (CAMMEN.INC) (81*4)
     c IMENU,IMENX,IMENY,IMENAR,IMNTOP,IMPOS,IMENVT,NITEM,
     c IMCHAR,ICHEAD,ISHEAD,IHMAX,IHNUM,IMENWD,IMOLD,INFOLL,
C COMMON BLOCK /ZCHARA/ (CAMCHR.INC) (3587*4+21*ICLEN4+80*IMENCL*4)
     c LINE,CHELP,CSUB,CTCOMD,LLINE,CGRAPH,
     c CMENUS , CBUFF , CLINE, CTITLE ,
C COMMON BLOCK /ZCOLOU/ (CAMCHR.INC)  (2*ICLMAX*6)
     c COLNAM, COLGRY,
C COMMON BLOCK /ZGRAPH/ (CAMGRP.INC (44*4+3*ICLMAX*4)
     c YCEN,XCEN,SCLLIM,JPAGE,RES,IPOST,IFONT,
     c IHAND,XCP,YCP,SCALE,IVCHAN,ISLCNT, RELSCL,IBUFF,SCLFIX,
     c IDEVCH,IDEVCS,IDEVCL,XCENS,XCENH,YCENS,YCENH,SCLIMS,SCLIMH,
     c IBACKS,IBACKH,IFOREH,IFORES,ILABCS,ILABCH,IBNDCS,IBNDCH,ICLDES,
     c ICLDEH,ISCALS,ISCALH, INLINE, XOFF, YOFF,XEMIN,XEMAX,YEMIN,
     c YEMAX, STRANG, PMAXX, PMAXY ,
C COMMON BLOCK /ZCOLNU/ (CAMCOL.INC) (4*3*ICLMAX*4)
     c IVGACL,IGREYC, ICOLS, IPSTCL,
C COMMON BLOCK /ZFLGSS/ (CAMFLG.INC) (49*4)
     c ISCRN,IELTYP,IOVER,IDEV,IHARD,
     c ISQR,IDOKEY,NKEY,ICOLL,IPPCK,ITYPCK,IAXIS,IMAXIM,DBDMAX,RNUISO,
     c IPLAB,ILSEC,ILSIZE,RTAPER,RTHICK,IMTFLG,IFILL,IEXFLG,
     c IFRAME,ICURS,ILABFG,IPCOLL,COLTOL,ICELL,IFOLAP,ITCOL,IENCL, IPCX
     c ,ILOG , IPHOTO, ICLDEF, ICAMER , IEDIT , ICBUFF, ITEKFG
     c , IBACK,IFORE,ILABCL,IBNDCL, ICPOST, IENCAP, ISTREO, ISVGA,
     c ITITLE ,
C COMMON BLOCK /ZINST2/ (CAMSHR.INC) (2000*2) integer*2
     c IXX2,IYY2 ,
C COMMON BLOCK /ZVERSI/  (CAMVER.INC) (1*4)
     c VERS,
C COMMON BLOCK /BUTTON/ (CAMBTN.INC) (8*MAXBUT*4+8*4+3*NBDMAX*4)
     c IBUTTS,IBBACK,IBTEXT,IBBORD,ICENTR,IBUTNO,IWIDTH,
     c IHEIGT,IBNWID,IBNHEI,
C COMMON BLOCK /BUTCHA/  (CAMBTN.INC) (100*MAXBUT)
     c CBUTTS,CBUTTX,
C COMMON  BLOCK /CAMBLK/ (CAMBLK.INC) (256)
     c CHRBUF,
C COMMON BLOCK /CAMLOG/ (CAMBLK.INC) (1)
     c LCLOSE,
C COMMON BLOCK /XIOBUF/ (XIOBUF.INC) (136)
     c CIOBUF, CCRCHR, MACDUM ,
C COMMON BLOCK /XCIOBF/ (XIOBUF.INC) (3*LINBUF*256)
     c CCVDU, CCEROR, CMON ,
C COMMON /XIIOBF/ (XIOBUF.INC) (4*4)
     c LVDU, MVDU, LEROR, MEROR,
C writing the relevant parts of RSTORE and CSTORE
C 4*16+4*(IRLAST-IRELM+1+ITOT-IREND+1)+ILEN*(ICLAST-ICELM+1+ITOT-(IGRP-NGRP*2-1)+1)
     c (RSTORE(I),I=IRELM,IRLAST),
     c (RSTORE(I),I=IREND,ITOT),
     c (CSTORE(I),I=ICELM,ICLAST),(CSTORE(I),I=IGRP-NGRP*2-1,ITOT)
      WRITE (CLINE,1231) FILENM
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
1231  FORMAT ('The current view has been saved in file ',A60)
cavdldec06 change back ILABFG to positive after file has been archived
      IF (IABS(ILABFG).EQ.1)ILABFG=1
      CLOSE(IVOUT)
      GOTO 9999
124   CONTINUE
cavdl** start old retrieve command, never used by Pearce
cavdl** start new retrieve command
C OPEN THE FILE
      FILENM = CTCOMD ( ITCNT )
      ITCNT = ITCNT + 1
C CHECK WHETHER IT EXISTS
      INQUIRE (FILE=FILENM , EXIST=LEXIST)
      IF (LEXIST) THEN
C IS THERE A FILE OPEN ALREADY?
        INQUIRE (UNIT=IVOUT, OPENED=LEXIST)
        IF (LEXIST) THEN
          CLOSE(IVOUT)
        ENDIF
        OPEN (UNIT=IVOUT, FILE=FILENM, ACCESS='SEQUENTIAL',
     c  FORM = 'UNFORMATTED',STATUS='OLD',ERR=1220)
      ELSE
         write(CLINE,'('' File does not exist, try again'')')
         call zmore(cline,0)
         return
      ENDIF
      READ (IVOUT)
C COMMON BLOCK /ZCOMAN/ (CAMANA.INC) (35*4)
     c IPROC,IMENCN,ILINE,IBEG,IEND,IN,IR,IC,IINT
     c ,IRL,ICHARS,ICTYPE,INCOM,IPREV,IHEAD,ICC,ICN,ICR,ISTORE,IFOBEY,
     c ICABAN ,ICLOG, IVNUM,
C COMMON BLOCKS /ZSTORI/ AND /ZSTORZ/ (CAMCOM.INC) (2*10000*4)
     c ISTACK,ZSTACK,
C COMMON BLOCK /ZSTORA/ (CAMCOM.INC) (19*4+7*INARGS*4)
     c ICPOS,ICCPOS,ICRPOS,ICTPOS,ICNT,ICCNT,IRCNT,
     c INCNT,ITCNT,ICOMMD,RCOMMD,NCOMMD,INFCMD,ICCMMD,ICNPOS,
     c ICINPS, ICMULT, IXYZO , IATTYP, IPCK , IBOND , ILAB, ISYM,
     c IPACKT , NSCRAT , NELM ,
C COMMON BLOCK /ZDATAC/ (CAMDAT.INC) (32*4)
     c ICOM,IRELM,ICELM,ICATOM,IRATOM,IRLAST,ICLAST,IREND,
     c ICRYST,NSYMM,ISVIEW,ISYMED,ICELLC,IPACK,INATOM,IELROT,
     c IFVIEW,ISINIT,IFINIT,NGRP,IGRP,IKEY,ITEXT,INTXT,ITNUMB,IGG,ICTXT,
     c IGPCK, ICLST5, ICONBG, ICONED, IFIRST ,
C COMMON BLOCK /ZCALCU/ (CAMCAL.INC) (830*4+NBDMAX*3*4)
     c DISEND,DISBEG,ANGEND,ANGBEG,CENTR,NDIST1,PKMIN,
     c PKMAX,PCMIN,PCMAX,PKCNF,PKCNA,D000,AMSYMM,AMTRAN,MAT1,MAT2,
     c ROT,XC,YC,ZC,XCOS,XSIN,PI,ISSPRT,IBDORD,IORD,ISFLAG,ITFLAG,NDIST2
     c ,RSTOL, ISPECL,IENCAT ,
C COMMON BLOCK /ZMCONT/ (CAMMSE.INC) (2*4)
     c IMOUSE,NMOUSE,
C COMMON BLOCK/ZMNUSS/ (CAMMEN.INC) (81*4)
     c IMENU,IMENX,IMENY,IMENAR,IMNTOP,IMPOS,IMENVT,NITEM,
     c IMCHAR,ICHEAD,ISHEAD,IHMAX,IHNUM,IMENWD,IMOLD,INFOLL,
C COMMON BLOCK /ZCHARA/ (CAMCHR.INC) (3587*4+21*ICLEN4+80*IMENCL*4)
     c LINE,CHELP,CSUB,CTCOMD,LLINE,CGRAPH,
     c CMENUS , CBUFF , CLINE, CTITLE ,
C COMMON BLOCK /ZCOLOU/ (CAMCHR.INC)  (2*ICLMAX*6)
     c COLNAM, COLGRY,
C COMMON BLOCK /ZGRAPH/ (CAMGRP.INC (44*4+3*ICLMAX*4)
     c YCEN,XCEN,SCLLIM,JPAGE,RES,IPOST,IFONT,
     c IHAND,XCP,YCP,SCALE,IVCHAN,ISLCNT, RELSCL,IBUFF,SCLFIX,
     c IDEVCH,IDEVCS,IDEVCL,XCENS,XCENH,YCENS,YCENH,SCLIMS,SCLIMH,
     c IBACKS,IBACKH,IFOREH,IFORES,ILABCS,ILABCH,IBNDCS,IBNDCH,ICLDES,
     c ICLDEH,ISCALS,ISCALH, INLINE, XOFF, YOFF,XEMIN,XEMAX,YEMIN,
     c YEMAX, STRANG, PMAXX, PMAXY ,
C COMMON BLOCK /ZCOLNU/ (CAMCOL.INC) (4*3*ICLMAX*4)
     c IVGACL,IGREYC, ICOLS, IPSTCL,
C COMMON BLOCK /ZFLGSS/ (CAMFLG.INC) (49*4)
     c ISCRN,IELTYP,IOVER,IDEV,IHARD,
     c ISQR,IDOKEY,NKEY,ICOLL,IPPCK,ITYPCK,IAXIS,IMAXIM,DBDMAX,RNUISO,
     c IPLAB,ILSEC,ILSIZE,RTAPER,RTHICK,IMTFLG,IFILL,IEXFLG,
     c IFRAME,ICURS,ILABFG,IPCOLL,COLTOL,ICELL,IFOLAP,ITCOL,IENCL, IPCX
     c ,ILOG , IPHOTO, ICLDEF, ICAMER , IEDIT , ICBUFF, ITEKFG
     c , IBACK,IFORE,ILABCL,IBNDCL, ICPOST, IENCAP, ISTREO, ISVGA,
     c ITITLE ,
C COMMON BLOCK /ZINST2/ (CAMSHR.INC) (2000*2) integer*2
     c IXX2,IYY2 ,
C COMMON BLOCK /ZVERSI/  (CAMVER.INC) (1*4)
     c VERS,
C COMMON BLOCK /BUTTON/ (CAMBTN.INC) (8*MAXBUT*4+8*4+3*NBDMAX*4)
     c IBUTTS,IBBACK,IBTEXT,IBBORD,ICENTR,IBUTNO,IWIDTH,
     c IHEIGT,IBNWID,IBNHEI,
C COMMON BLOCK /BUTCHA/  (CAMBTN.INC) (100*MAXBUT)
     c CBUTTS,CBUTTX,
C COMMON  BLOCK /CAMBLK/ (CAMBLK.INC) (256)
     c CHRBUF,
C COMMON BLOCK /CAMLOG/ (CAMBLK.INC) (1)
     c LCLOSE,
C COMMON BLOCK /XIOBUF/ (XIOBUF.INC) (136)
     c CIOBUF, CCRCHR, MACDUM ,
C COMMON BLOCK /XCIOBF/ (XIOBUF.INC) (3*LINBUF*256)
     c CCVDU, CCEROR, CMON ,
C COMMON /XIIOBF/ (XIOBUF.INC) (4*4)
     c LVDU, MVDU, LEROR, MEROR,
C writing the relevant parts of RSTORE and CSTORE
     c (RSTORE(I),I=IRELM,IRLAST),
     c (RSTORE(I),I=IREND,ITOT),
     c (CSTORE(I),I=ICELM,ICLAST),(CSTORE(I),I=IGRP-NGRP*2-1,ITOT)
      WRITE (CLINE,1233) FILENM
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
cavdl set ivchan = 1 because there is a new view matrix
      IVCHAN = 1
1233  FORMAT ('An archived  view was read from file ',A60)
      CLOSE(IVOUT)
      GOTO 9999
125   CONTINUE
c LIST THE MATRIX
      DO 1250 I = 1 , IVNUM
        READ ( IVOUT , REC=I) CTEXT  , MATDUM
        WRITE (CLINE,1251) I , CTEXT
        CALL ZMORE(CLINE,0)
1250  CONTINUE
1251  FORMAT ('Record number ',I4,' description :',/,A)
      GOTO 9999
c128   CONTINUE
128   CONTINUE
C STEREO
      ISTREO = 1
      GOTO 9999
129   CONTINUE
C NOSTEREO
      ISTREO = 0
      GOTO 9999
130   CONTINUE
C DEGREE
      STRANG = RCOMMD(IRCNT)
      GOTO 9999
9999  CONTINUE
      RETURN
      END


CODE FOR ZCMD2
      SUBROUTINE ZCMD2 (ID)
C This routine carries out the 200 group of commands ie LINE etc

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

      ID = ID - (ID/100)*100 + 1
      GOTO (200,201,202,200,204,201,202,207,207,200,201,202,212,213,
     c 214,215,215,215,218,218,218,221,221,221,224,225,226,200,215,
     c 201,230) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
200   CONTINUE
C LINE/BALL/ELLIPSE
      IF (ID.EQ.1) THEN
        VAL = 1.0
      ELSE IF (ID.EQ.4) THEN
        VAL = 2.0
      ELSE IF (ID.EQ.10) THEN
        VAL = 3.0 + 0.1*IELTYP
      ELSE
        VAL = 6.0
      ENDIF
      DO 10 I = ICCNT,ICCNT+ICC-1
        N = ICCMMD(I)
        IMULT = ICMULT (I)
        CALL ZPARAM (N,0,VAL,1,IMULT)
10    CONTINUE
      GOTO 9999
201   CONTINUE
C ELLIPSE/BALL/LINE ALL
      IF (ID.EQ.2) THEN
        VAL = 1.0
      ELSE IF (ID.EQ.6) THEN
        VAL = 2.0
      ELSE IF (ID.EQ.11) THEN
        VAL = 3.0 + 0.1*IELTYP
      ELSE
        VAL = 6.0
      ENDIF
      DO 30 I = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
        IF (NINT(RSTORE(I)).NE.4 .AND. NINT(RSTORE(I)).NE.5) THEN
          RSTORE(I) = VAL
        ENDIF
30    CONTINUE
      GOTO 9999
202   CONTINUE
C GROUP
      IF (ID.EQ.3) THEN
        VAL = 1.0
      ELSE IF (ID.EQ.7) THEN
        VAL = 2.0
      ELSE
        VAL = 3.0 + 0.1*IELTYP
      ENDIF
      IG = ICCMMD(ICCNT)
      CALL ZMODGP (IG,0,VAL)
      GOTO 9999
204   CONTINUE
C RADII
      J = ICCNT
      DO 40 I = IRCNT,IRCNT+ICR-1
      N = ICCMMD(J)
      RAD = RCOMMD(I)
      IMULT = ICMULT (I)
      IF (RAD.LT.0.05) RAD = 0.05
      CALL ZPARAM (N,IATTYP+4,RAD,1,IMULT)
      J = J + 1
40    CONTINUE
      GOTO 9999
207   CONTINUE
C FILL/UNFILL
      IF (ID.EQ.8) THEN
        IFILL = 1
      ELSE
        IFILL = 0
      ENDIF
      GOTO 9999
212   CONTINUE
C TYPE OF ELLIPSE
      NPOS = INCNT
      IPOS = 0
      DO 2120 I = ICCNT, ICCNT+ICC-1
        ITYPE = NCOMMD(NPOS)
        IF ((ITYPE.LT.1).OR.(ITYPE.GT.4)) ITYPE=4
        VAL = 3.0 + ITYPE*0.1
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        CALL ZPARAM (N,IPOS,VAL,1,IMULT)
        NPOS = NPOS + 1
2120  CONTINUE
C SET THE ELLIPSES
      GOTO 9999
230   CONTINUE
C ELLIPSE TYPE ALL
      IELTYP = NCOMMD(INCNT)
C check value of ieltyp entered
      IF (IELTYP.LT.1) IELTYP = 1
      IF (IELTYP.GT.4) IELTYP = 4
      VAL = 3.0 + IELTYP*0.1
      DO 2300 I = ISVIEW + IPACKT*8, IFVIEW-1, IPACKT
        RSTORE(I) = VAL
2300  CONTINUE
      GOTO 9999
213   CONTINUE
C NEGATIVE
      RNUISO = RCOMMD (IRCNT)
      GOTO 9999
214   CONTINUE
C DEFAULT
      DO 60 I = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
      RSTORE(I+IATTYP+4) = RSTORE( NINT (IRELM +
     c (RSTORE(I+IATTYP)-1) * 4.0 ) )*0.25
60    CONTINUE
      GOTO 9999
215   CONTINUE
C FRAGMENT
      IF (ID.EQ.16) THEN
        VAL = 1.0
      ELSE IF (ID.EQ.17) THEN
        VAL= 2.0
      ELSE IF (ID.EQ.18) THEN
        VAL = 3.0 + 0.1*IELTYP
      ELSE
        VAL = 6.0
      ENDIF
      DO 2150 I = ICCNT , ICCNT+ICC-1
        N = (ICCMMD(I)-ICATOM)*IPACKT + IRATOM
        CALL ZFRAG (N , 0 , VAL , 1)
2150  CONTINUE
      GOTO 9999
218   CONTINUE
C RADII COMMANDS - COVALENT, IONIC , VANDERWAALS
      IOFFST = ID - 19
      DO 2180 I = ICCNT , ICCNT+ICC-1
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        CALL ZPARAM (N,IATTYP+4,REAL(IOFFST),5,IMULT)
2180  CONTINUE
      GOTO 9999
221   CONTINUE
C COVALENT ETC ALL
      IOFFST = ID - 22
      DO 2210 I = ISVIEW + IPACKT*8 , IFVIEW - 1 , IPACKT
        RSTORE(I+IATTYP+4) = RSTORE (NINT(IRELM +
     + (RSTORE(I+IATTYP)-1)*4.0 + IOFFST) ) * 0.25
        IF (RSTORE(I+IATTYP+4).LT.0) THEN
          RSTORE(I+IATTYP+4) = 0.025
        ENDIF
2210  CONTINUE
      GOTO 9999
224   CONTINUE
C KEY
      IDOKEY = 1
      GOTO 9999
225   CONTINUE
C NOKEY
      IDOKEY = 0
      GOTO 9999
226   CONTINUE
C PROBABILITY
      P = RCOMMD (IRCNT) / 100.0
      CALL ZERF (P,RELSCL)
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD3 [ 300 GROUP CONNECT ]
      SUBROUTINE ZCMD3 (ID)
      
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

      INTEGER ISB(2)
      ID=ID-(ID/100)*100+1
      GO TO (10,60,130,150,490,490,490,180,200,270,300,390,420,440,460,
     1460,450,317,317,319,319,319,322,322,322,325,10) ID
C CONNECT
C set up the elements to be included in the list.
10    IF (ICC.EQ.0) GO TO 460
      ICFLAG = 0
      ISTYL = 0
      IF (ID.EQ.27) THEN
        ICFLAG = 1
        ISTYL = 2
      ENDIF
C FIRST CHECK FOR MAXIMUM LIST LENGTH
      NROOM=2*(IFVIEW-ISVIEW)/IPACKT
      IRM=LROOM(IRLAST,IREND,NROOM)
      IF (IRM.EQ.1) THEN
        IROK=1
      ELSE
        IROK=0
      END IF
C DONT DO THIS IF WE HAVE A DUMMY HEADER
      DMIN=RCOMMD(IRCNT)**2
      DMAX=RCOMMD(IRCNT+1)**2
      INATOM=0
      DO 50 J=0,1
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
        IF (IROK.NE.1) THEN
          IRM=LROOM(IRLAST,IREND,INATOM)
          IF (IRM.LT.0) THEN
            IPROC=0
            RETURN
          END IF
        END IF
        ISB(J+1)=IRLAST+INATOM
        INATOM=0
        N=ICCMMD(ICCNT+J)
        IMULT=ICMULT(ICCNT+J)
C Do we have an atom or an element?
        IF (N.GT.ICATOM) THEN
C ATOM
C IS THIS A MULTIPLE ATOM?
          IF (IMULT.EQ.1) THEN
C YES IT IS - WE NEED TO LOOP OVER ALL OF THE ATOMS
            DO 20 I=0,IPACK
              CALL ZGTATM (N,I,IPOS)
              IF (IPOS.EQ.-1) GO TO 20
              RSTORE(ISB(J+1)+INATOM)=IPOS
              INATOM=INATOM+1
20          CONTINUE
          ELSE
            N=(N-ICATOM)*IPACKT+IRATOM
            RSTORE(ISB(J+1)+INATOM)=N
            INATOM=INATOM+1
          END IF
        ELSE IF (N.EQ.0) THEN
C *_N
          DO 21 I = ISVIEW+IPACKT*8 , IFVIEW-1 , IPACKT
            IF (NINT(RSTORE(I+IPCK)).NE.IMULT-1) GOTO 21
            RSTORE(ISB(J+1)+INATOM) = I
            INATOM = INATOM + 1
21        CONTINUE
        ELSE IF (N.EQ.-1) THEN
C * ADD ALL ATOMS
          DO 22 I = ISVIEW+IPACKT*8 , IFVIEW-1 , IPACKT
            RSTORE(ISB(J+1)+INATOM) = I
            INATOM = INATOM + 1
22        CONTINUE
        ELSE
C ELEMENT - NEED TO LOOP
C IS THIS AN ELEMENT OF THE TYPE N_2 ?
          IF (IMULT.NE.0) THEN
            N=N-ICELM+1
            CALL ZGTPCK (IMULT-1,IS,IF)
            DO 30 I=IS,IF,IPACKT
              IF (NINT(RSTORE(I+IATTYP)).NE.N) GO TO 30
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM=LROOM(IRLAST,IREND,INATOM)
                IF (IRM.LT.0) THEN
                  IPROC=0
                  RETURN
                END IF
              END IF
              RSTORE(ISB(J+1)+INATOM)=I
              INATOM=INATOM+1
30          CONTINUE
          ELSE
            N=N-ICELM+1
            DO 40 K=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
              L=NINT(RSTORE(K+IATTYP))
              IF (L.NE.N) GO TO 40
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM=LROOM(IRLAST,IREND,INATOM)
                IF (IRM.LT.0) THEN
                  IPROC=0
                  RETURN
                END IF
              END IF
C FOUND AN ELEMENT MATCH
              RSTORE(ISB(J+1)+INATOM)=K
              INATOM=INATOM+1
40          CONTINUE
          END IF
        END IF
50    CONTINUE
C CALL THE BOND ROUTINE - MAKES A 'FULL' BOND (ISTYL=0)
      CALL ZJNBND (DMAX,DMIN,ISB,ISTYL,0,ICFLAG)
      GO TO 460
C H BONDS
C GET THE EXTRA ATOMS/ELEMENTS
C CHECK THE MAX LENGTH OF THE LIST
60    NROOM=(IFVIEW-ISVIEW)/IPACKT
      IRM=LROOM(IRLAST,IREND,NROOM)
      IF (IRM.EQ.1) THEN
        IROK=1
      ELSE
        IROK=0
      END IF
      ISB(1)=IRLAST
      INATOM=0
      DMAX=RCOMMD(IRCNT+1)**2
      DMIN=RCOMMD(IRCNT)**2
      DO 80 I=ICCNT,ICCNT+ICC-1
        N=ICCMMD(I)
        IMULT=ICMULT(I)
        IF (N.EQ.0) THEN
C *_N
          DO 81 J = ISVIEW+IPACKT*8 , IFVIEW-1 , IPACKT
            IF(NINT(RSTORE(J+IPCK)).NE.IMULT-1) GOTO 81
            RSTORE(ISB(1)+INATOM) = J
            INATOM = INATOM + 1
81        CONTINUE
        ELSE IF (N.EQ.-1) THEN
          DO 82 J = ISVIEW+IPACKT , IFVIEW-1, IPACKT
            RSTORE(ISB(1)+INATOM) = J
            INATOM = INATOM + 1
82        CONTINUE
C ATOM OR ELEMENT?
        ELSE IF (N.LT.ICATOM) THEN
C ELEMENT
C CHECK THE MULTIPLICITY
          N=N-ICELM+1
          IF (IMULT.EQ.0) THEN
             DO 70 J=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
              IF (NINT(RSTORE(J+IATTYP)).EQ.N) THEN
C MOVE OVER THE INFO
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
                IF (IROK.NE.1) THEN
                  IRM=LROOM(IRLAST,IREND,INATOM)
                  IF (IRM.LT.0) THEN
                    IPROC=0
                    RETURN
                  END IF
                END IF
                RSTORE(ISB(1)+INATOM)=J
                INATOM=INATOM+1
              END IF
70          CONTINUE
          ELSE
            CALL ZGTPCK (IMULT-1,IS,IF)
            DO 470 L = IS , IF , IPACKT
              IF (NINT(RSTORE(L+IATTYP)).EQ.N) THEN
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
                IF (IROK.NE.1) THEN
                  IRM=LROOM(IRLAST,IREND,INATOM)
                  IF (IRM.LT.0) THEN
                    IPROC=0
                    RETURN
                  END IF
                END IF
                RSTORE(ISB(1)+INATOM)=L
                INATOM = INATOM + 1
              ENDIF
470         CONTINUE
          ENDIF
        ELSE
C  ATOM
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
C CHECK FOR MULTIPLE ATOMS
          IF (IMULT.EQ.1) THEN
            DO 480 L = 0 , IPACK
              CALL ZGTATM ( N , L , IPOS)
              IF (IPOS.EQ.-1) GOTO 480
              IF (IROK.NE.1) THEN
                IRM=LROOM(IRLAST,IREND,INATOM)
                IF (IRM.LT.0) THEN
                  IPROC=0
                  RETURN
                END IF
              END IF
              RSTORE(ISB(1)+INATOM)=IPOS
480         CONTINUE
          ELSE
            N=(N-ICATOM)*IPACKT+IRATOM
            IF (IROK.NE.1) THEN
              IRM=LROOM(IRLAST,IREND,INATOM)
              IF (IRM.LT.0) THEN
                IPROC=0
                RETURN
              END IF
            END IF
            RSTORE(ISB(1)+INATOM)=N
            INATOM=INATOM+1
          END IF
        END IF
80    CONTINUE
C NOW FIND OUT THE VALID H ATOMS - THE VALID ATOMS MUST BE BONDED TO
C ATOMS IN THE ABOVE LIST.
C FIRST FIND IH
        ISB(2)=ISB(1)+INATOM
        INATOM=0
        NROOM=(IFVIEW-ISVIEW)/IPACKT
        IRM=LROOM(IRLAST,IREND,NROOM)
        IF (IRM.EQ.1) THEN
          IROK=1
        ELSE
          IROK=0
        END IF
        DO 90 I=ICELM,ICELM+NELM-1
          IF (CSTORE(I)(1:2).EQ.'H ') IH=I-ICELM+1
90      CONTINUE
C LOOP TO FIND THE H ATOMS
        DO 120 I=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
          IF (NINT(RSTORE(I+IATTYP)).NE.IH) GO TO 120
C FOUND AN H ATOM - IS IT BONDED
          IB1=NINT(RSTORE(I+IBOND))
          NB1=NINT(RSTORE(I+IBOND+1))
          II=0
          DO 110 J=IB1,IB1-NB1*2+2,-2
            IF (II.EQ.1) GO TO 110
            N=NINT(RSTORE(J))
C LOOP OTHER THE OTHER ATOMS
            DO 100 K=ISB(1),ISB(2)-1
              IF (NINT(RSTORE(K)).EQ.N) II=1
100         CONTINUE
110       CONTINUE
          IF (II.EQ.0) GO TO 120
C ATOM NOT VALID
C OTHERWISE STORE THE INFO
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
          IF (IROK.NE.1) THEN
            IRM=LROOM(IRLAST,IREND,INATOM)
            IF (IRM.LT.0) THEN
              IPROC=0
              RETURN
            END IF
          END IF
          RSTORE(ISB(2)+INATOM)=I
          INATOM=INATOM+1
120     CONTINUE
        IF (INATOM.EQ.0) RETURN
C NO POSSIBLE H ATOM RETURN
        CALL ZJNBND (DMAX,DMIN,ISB,2,1,0)
        GO TO 460
C JOIN
130   CONTINUE
C DUMMY HEADER COMMAND
      GOTO 460
317   CONTINUE
C FULL OR DOTTED
      IF (ID.EQ.18) THEN
        ISTYL = 0
      ELSE
        ISTYL = 2
      ENDIF
      DO 140 I=ICCNT,ICCNT+ICC-1,2
        IAT1=ISINIT+(ICCMMD(I)-ICATOM)*IPACKT
        IAT2=ISINIT+(ICCMMD(I+1)-ICATOM)*IPACKT
        CALL ZDOJN (IAT1,IAT2,ISTYL,0)
        IF (IPROC.EQ.0) RETURN
140   CONTINUE
      GO TO 460
C RADII
150     IIC=IRCNT
        DO 170 I=ICCNT,ICCNT+ICC-1
          RAD=RCOMMD(IIC)
          IMULT = ICMULT(I)
          IF (ICCMMD(I).EQ.-1) THEN
C *
            DO 151 J = ISVIEW+IPACKT*8 , IFVIEW-1, IPACKT
              RSTORE(J+IATTYP+5) = RAD
151         CONTINUE
C N IS THE NUMBER OF THE ATOM IN THE RSTORE ARRAY
          ELSE IF (ICCMMD(I).LT.ICATOM) THEN
C WE HAVE AN ELEMENT - NEED TO LOOP OVER ALL THESE ATOMS IN THE ARRAY
            N=ICCMMD(I)-ICELM+1
            DO 160 J=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
              IF (NINT(RSTORE(J+IATTYP)).EQ.N) THEN
                IF((IMULT.NE.0).AND.(NINT(RSTORE(J+IPCK)).NE.IMULT-1))
     c GOTO 160
C YES THIS ELEMENT AGREES
                RSTORE(J+IATTYP+5)=RAD
                CALL ZDOCON (1,J,0)
                IF (IPROC.EQ.0) RETURN
              END IF
160         CONTINUE
          ELSE
            IF (IMULT.EQ.1) THEN
              N = (ICCMMD(I)-ICATOM)*IPACKT + ISINIT
C CHECK FOR MULTIPLES
              IPPACK = 0
161           CONTINUE
              CALL ZGTATM ( N , IPPACK , IPOS)
              IF (IPOS.NE.-1) THEN
                RSTORE(IPOS+IATTYP+5)= RAD
                CALL ZDOCON (1 , IPOS, 0)
                IF (IPROC.EQ.0) RETURN
              ENDIF
              IPPACK = IPPACK + 1
              IF (IPPACK.LE.IPACK) GOTO 161
            ELSE
              N=ISINIT+(ICCMMD(I)-ICATOM)*IPACKT
              RSTORE(N+IATTYP+5)=RAD
              CALL ZDOCON (1,N,0)
              IF (IPROC.EQ.0) RETURN
            END IF
          ENDIF
          IIC=IIC+1
170     CONTINUE
        GO TO 460
490   CONTINUE
C FULL/DASHED/DOTTED
C GET THE STYLE
      IF (ID.EQ.5) THEN
        ISTYL = 0
      ELSE
        ISTYL = 2
      ENDIF
      DO 500 I = ICCNT , ICCNT + ICC - 1 , 2
          N=ICCMMD(I)
          IMULTN = ICMULT(I)
          M=ICCMMD(I+1)
          IMULTM = ICMULT(I+1)
          CALL ZBNDCK (N,IMULTN,M,IMULTM,ISTYL,2,IJN,0)
500   CONTINUE
      GOTO 460
C REMOVE
180     DO 190 I=ICCNT,ICCNT+ICC-1,2
          N=ICCMMD(I)
          IMULTN = ICMULT(I)
          M=ICCMMD(I+1)
          IMULTM = ICMULT(I+1)
          IJN=0
          ISET=0
          INUMB=0
          CALL ZBNDCK (N,IMULTN,M,IMULTM,ISET,INUMB,IJN,-1)
190     CONTINUE
        GO TO 460
C DISCONNECT
C GET THE RELEVANT ATOMS/ELEMENTS
200     IF (ICC.EQ.0) GO TO 460
        DMIN=RCOMMD(IRCNT)**2
        DMAX=RCOMMD(IRCNT+1)**2
        INATOM=0
C CHECK FOR MAX POSSIBLE NUMBER IN LIST
        NROOM=(IFVIEW-ISVIEW)/IPACKT
        IRM=LROOM(IRLAST,IREND,NROOM)
        IF (IRM.EQ.1) THEN
          IROK=1
        ELSE
          IROK=0
        END IF
        DO 220 J=0,1
          ISB(J+1)=IRLAST+INATOM
          INATOM=0
          N=ICCMMD(ICCNT+J)
          IMULT = ICMULT(ICCNT+J)
C Do we have an atom or an element?
          IF (N.EQ.0) THEN
C *_N
            DO 221 I = ISVIEW+IPACKT*8 , IFVIEW-1, IPACKT
              IF (NINT(RSTORE(I+IPCK)).NE.IMULT-1) GOTO 221
              RSTORE(ISB(J+1)+INATOM) = I
              INATOM = INATOM + 1
221         CONTINUE
          ELSE IF (N.EQ.-1) THEN
            DO 224 K = ISVIEW+IPACKT*8 , IFVIEW-1, IPACKT
              RSTORE(ISB(J+1)+INATOM) = K
              INATOM = INATOM + 1
224         CONTINUE
          ELSE IF (N.GT.ICATOM) THEN
C ATOM
            IF (IMULT.EQ.1) THEN
C GET THE MULTIPLES
              DO 222 K = 0 , IPACK
                CALL ZGTATM (K,N,IPOS)
                IF (IPOS.EQ.-1) GOTO 222
                IF (IROK.NE.1) THEN
                  IRM=LROOM(IRLAST,IREND,INATOM)
                  IF (IRM.LT.0) THEN
                    IPROC=0
                    RETURN
                  END IF
                END IF
                RSTORE(ISB(J+1)+INATOM) = IPOS
                INATOM = INATOM + 1
222           CONTINUE
            ELSE
              N=(N-ICATOM)*IPACKT+IRATOM
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM=LROOM(IRLAST,IREND,INATOM)
                IF (IRM.LT.0) THEN
                  IPROC=0
                  RETURN
                END IF
              END IF
              RSTORE(ISB(J+1)+INATOM)=N
              INATOM=INATOM+1
            ENDIF
          ELSE
C ELEMENT - NEED TO LOOP
            N=N-ICELM+1
            DO 210 K=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
              L=NINT(RSTORE(K+IATTYP))
              IF (L.NE.N) GO TO 210
C FOUND AN ELEMENT MATCH
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM=LROOM(IRLAST,IREND,INATOM)
                IF (IRM.LT.0) THEN
                  IPROC=0
                  RETURN
                END IF
              END IF
              RSTORE(ISB(J+1)+INATOM)=K
              INATOM=INATOM+1
210         CONTINUE
          END IF
220     CONTINUE
C THE TWO LISTS ARE NOW SET UP ISB(1)-ISB(2) AND
C ISB(2) - INATOM
        INATOM1=ISB(2)-ISB(1)
C LOOP OVER THE OUTER LIST
        DO 260 I=ISB(1),ISB(1)+INATOM1-1
          X1=RSTORE(NINT(RSTORE(I))+IXYZO)
          Y1=RSTORE(NINT(RSTORE(I))+IXYZO+1)
          Z1=RSTORE(NINT(RSTORE(I))+IXYZO+2)
C LOOP OVER THE INNER LIST
          DO 250 J=ISB(2),ISB(2)+INATOM-1
            IF (NINT(RSTORE(I)).EQ.NINT(RSTORE(J))) GO TO 250
            X2=RSTORE(NINT(RSTORE(J))+IXYZO)
            Y2=RSTORE(NINT(RSTORE(J))+IXYZO+1)
            Z2=RSTORE(NINT(RSTORE(J))+IXYZO+2)
C CHECK THE DISTANCE
            D=(X1-X2)**2+(Y1-Y2)**2+(Z1-Z2)**2
            IF ((D.LT.DMIN).OR.(D.GT.DMAX)) THEN
C DISCONNECT THIS BOND
              JJ=NINT(RSTORE(J))
              II=NINT(RSTORE(I))
C NEED TO FIND THE BOND POSITION IN THE INFO FOR BOTH ATOMS CONCERNED
              NBNDST=NINT(RSTORE(II+IBOND))
              NBONDS=NINT(RSTORE(II+IBOND+1))
              DO 240 K=0,NBONDS*2-2,2
                N=NINT(RSTORE(NBNDST-K))
                IF (N.EQ.JJ) THEN
C WE HAVE FOUND THE BOND
                  RSTORE(NBNDST-K)=0.0
                  RSTORE(NBNDST-K-1)=0.0
C GET RID OF THE BOND AT THE OTHER END
                  NBNDS1=NINT(RSTORE(JJ+IBOND))
                  NBOND=NINT(RSTORE(JJ+IBOND+1))
                  DO 230 KK=0,NBOND*2-2,2
                    NN=NINT(RSTORE(NBNDS1-KK))
                    IF (NN.EQ.II) THEN
C WE HAVE FOUND THE OTHER END
                      RSTORE(NBNDS1-KK)=0.0
                      RSTORE(NBNDS1-KK-1)=0.0
                      GO TO 240
C JUMP OUT OF BOTH LOOPS
                    END IF
230               CONTINUE
                END IF
240           CONTINUE
            END IF
250       CONTINUE
260     CONTINUE
        GO TO 460
C ALL
270     DMIN=RCOMMD(IRCNT)**2
        DMAX=RCOMMD(IRCNT+1)**2
        DO 290 I=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
          X1=RSTORE(I+IXYZO)
          Y1=RSTORE(I+IXYZO+1)
          Z1=RSTORE(I+IXYZO+2)
          IBNDST=NINT(RSTORE(I+IBOND))
          NBONDS=NINT(RSTORE(I+IBOND+1))
          DO 280 J=0,NBONDS-1
            K=NINT(RSTORE(IBNDST-J*2))
            X2=RSTORE(K+IXYZO)
            Y2=RSTORE(K+IXYZO+1)
            Z2=RSTORE(K+IXYZO+2)
            DIST=(X1-X2)**2+(Y1-Y2)**2+(Z1-Z2)**2
            IF ((DIST.LT.DMIN).OR.(DIST.GT.DMAX)) THEN
C BREAK THE BOND
              RSTORE(IBNDST-J*2)=0.0
              RSTORE(IBNDST-J*2-1)=0.0
            END IF
280       CONTINUE
290     CONTINUE
        GO TO 460
C GROUP - BREAK BONDS EXISTING BETWEEN GROUPS
C GET THE TWO GROUP NUMBERS
300     IG1=ICCMMD(ICCNT)
        IG2=ICCMMD(ICCNT+1)
        INATOM=0
        INATOM1=0
C CHECK FOR ROOM FOR MAX NUMBER OF ATOMS
        NROOM=2*(IFVIEW-ISVIEW)/IPACKT
        IRM=LROOM(IRLAST,IREND,NROOM)
        IF (IRM.EQ.1) THEN
          IROK=1
        ELSE
          IROK=0
        END IF
        ISAT=IRLAST
        DO 320 I=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
          DO 310 J=6,9
            IF (NINT(RSTORE(I+IATTYP+J)).EQ.IG1) THEN
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM=LROOM(IRLAST,IREND,INATOM)
                IF (IRM.LT.0) THEN
                  IPROC=0
                  RETURN
                END IF
              END IF
              RSTORE(ISAT+INATOM)=I
              INATOM=INATOM+1
              GO TO 320
            END IF
310       CONTINUE
320     CONTINUE
        DO 340 I=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
          DO 330 J=6,9
            IF (NINT(RSTORE(I+IATTYP+J)).EQ.IG2) THEN
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM=LROOM(IRLAST,IREND,INATOM)
                IF (IRM.LT.0) THEN
                  IPROC=0
                  RETURN
                END IF
              END IF
              RSTORE(ISAT+INATOM+INATOM1)=I
              INATOM1=INATOM1+1
              GO TO 340
            END IF
330       CONTINUE
340     CONTINUE
C Now we have two sets of atom numbers, those in IG1 are held in ISAT ->
C ISAT+INATOM-1 and IG2 are held in ISAT+INATOM -> ISAT+ INATOM +
C INATOM1 -1.
C Loop over the first atom list.
        DO 380 I=ISAT,ISAT+INATOM-1
          N=NINT(RSTORE(I))
          IBNDST=NINT(RSTORE(N+IBOND))
          NBONDS=NINT(RSTORE(N+IBOND+1))
          DO 370 J=0,NBONDS-1
            NN=NINT(RSTORE(IBNDST-J*2))
C Now we have a bonded atom - is it in list 2?
            DO 360 K=ISAT+INATOM,ISAT+INATOM+INATOM1-1
              L=NINT(RSTORE(K))
              IF (NN.NE.L) GO TO 360
C YES - NEED TO REMOVE BOND AT BOTH ENDS.
              RSTORE(IBNDST-J*2)=0.0
              RSTORE(IBNDST-J*2-1)=0.0
C FIND OTHER END
              IBNDS2=NINT(RSTORE(L+IBOND))
              NBOND2=NINT(RSTORE(L+IBOND+1))
              DO 350 JJ=0,NBOND2-1
                IF (NINT(RSTORE(IBNDS2-JJ*2)).EQ.N) THEN
                  RSTORE(IBNDS2-JJ*2)=0.0
                  RSTORE(IBNDS2-JJ*2-1)=0.0
                END IF
350           CONTINUE
360         CONTINUE
370       CONTINUE
380     CONTINUE
        GO TO 460
C CONNECT ALL
390     DMIN=RCOMMD(IRCNT)**2
        DMAX=RCOMMD(IRCNT+1)**2
        DO 410 I=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
          X1=RSTORE(I+IXYZO)
          Y1=RSTORE(I+IXYZO+1)
          Z1=RSTORE(I+IXYZO+2)
          DO 400 J=I+IPACKT,IFVIEW-1,IPACKT
            X2=RSTORE(J+IXYZO)
            Y2=RSTORE(J+IXYZO+1)
            Z2=RSTORE(J+IXYZO+2)
C GET THE DISTANCE
            D=(X1-X2)**2+(Y1-Y2)**2+(Z1-Z2)**2
            IF ((D.GT.DMIN).AND.(D.LT.DMAX)) THEN
              CALL ZDOJN (I,J,0,0)
              IF (IPROC.EQ.0) RETURN
C NOTE THAT XDOJN CHECKS THE BOND FROM EITHER END
            END IF
400       CONTINUE
410     CONTINUE
        GO TO 460
C CONNECT DEFAULT
C GET THE DEFAULT RADII
420     DO 430 I=ISVIEW+IPACKT*8,IFVIEW-1,IPACKT
          RSTORE(I+IATTYP+5)=RSTORE(NINT(IRELM+(RSTORE(I+IATTYP)-1)*4.0)
     1     )
430     CONTINUE
        IF (ICONBG.EQ.ISYMED-IGMAX) THEN
          CALL ZDOCON (0,0,0)
        ELSE
          CALL ZDOCON (-3,0,0)
        ENDIF
        GO TO 460
319     CONTINUE
C CONNECT RADII COVALENT ETC
      IOFFST = ID - 20
      DO 2180 I = ICCNT , ICCNT+ICC-1
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        CALL ZPARAM (N,IATTYP+5,REAL(IOFFST),5,IMULT)
2180  CONTINUE
      INXT = LNCHCK(300)
      IF (INXT.EQ.1) THEN
        INXT = LNCHCK (308)
        IF (INXT.EQ.-1) THEN
          IF (ICONBG.EQ.ISYMED-IGMAX) THEN
            CALL ZDOCON (0,0,0)
          ELSE
            CALL ZDOCON (-3,0,0)
          ENDIF
        ENDIF
      ELSE
        IF (ICONBG.EQ.ISYMED-IGMAX) THEN
          CALL ZDOCON (0,0,0)
        ELSE
          CALL ZDOCON (-3,0,0)
        ENDIF
      ENDIF
      GOTO 460
322   CONTINUE
C COVALENT ETC ALL
      IOFFST = ID - 23
      DO 2210 I = ISVIEW + IPACKT*8 , IFVIEW - 1 , IPACKT
        RSTORE(I+IATTYP+5) = RSTORE (NINT(IRELM +
     + (RSTORE(I+IATTYP)-1)*4.0 + IOFFST) )
        IF (RSTORE(I+IATTYP+5).LT.0) THEN
          RSTORE(I+IATTYP+5) = 0.0
        ENDIF
2210  CONTINUE
      IF (ICONBG.EQ.ISYMED-IGMAX) THEN
        CALL ZDOCON (0,0,0)
      ELSE
        CALL ZDOCON (-3,0,0)
      ENDIF
      GOTO 460
C TAPER
440     RTAPER=NINT(RCOMMD(IRCNT))
        IF (RTAPER.LE.0) RTAPER=1.0
        GO TO 460
C THICKNESS
450     RTHICK=RCOMMD(IRCNT)
        IF (RTHICK.LE.0.01) RTHICK=0.01
        GO TO 460
325   CONTINUE
C DISCONNECT ATOMS
      DO 3250 I = ICCNT , ICCNT+ICC-1
        N = (ICCMMD(I)-ICATOM)*IPACKT + ISINIT
C LOOP OVER THE CONNECTIVITY TO FIND THE BONDS
        NBNDST = RSTORE(N+IBOND)
        NBONDS = RSTORE(N+IBOND+1)
        DO 3252 J = NBNDST , NBNDST-(NBONDS-1)*2 , -2
          K = NINT(RSTORE(J))
C NOW REMOVE THE BOND FROM THE OTHER END
          NBNDS2 = RSTORE(K+IBOND)
          NBND2 = RSTORE(K+IBOND+1)
          DO 3254 L = NBNDS2 , NBNDS2 - (NBND2-1)*2 , -2
            IF (NINT(RSTORE(L)).EQ.N) THEN
              RSTORE(L) = 0
              RSTORE(L-1) = 0
            ENDIF
3254      CONTINUE
C REMOVE THE REFERENCE FROM THIS END
          RSTORE(J) = 0
          RSTORE(J-1) = 0
3252    CONTINUE
3250  CONTINUE
      GOTO 460
460   RETURN
      END

CODE FOR ZCMD4
      SUBROUTINE ZCMD4 (ID)
C This routine deals with the ADD and MOVE commands.

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

      REAL STRAN(8)
      DATA STRAN /0.0,0.5,0.33333333,0.25,0.666666667,0.75,0.16666667,
     c 0.83333333/
      IVCHAN = 1
      ID1 = ID
      ID = ID - (ID/100)*100 + 1
      GOTO (400,401,402,403,404,405,406) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
400   CONTINUE
      ITFLAG = 0
      ISFLAG = 0
C HEADER ADD/MOVE
      GOTO 9999
401   CONTINUE
C ATOMS/ELEMENTS
      INATOM = 0
C CHECK FOR MAX NUMBER OF ATOMS
      NROOM = ( IFVIEW - ISVIEW ) / IPACKT
      IRM = LROOM ( IRLAST , IREND , NROOM )
      IF (IRM.EQ.1) THEN
        IROK = 1
      ELSE
        IROK = 0
      ENDIF
      DO 10 I = ICCNT,ICCNT+ICC-1
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        IF (N.EQ.0) THEN
          DO 11 J = ISVIEW + IPACKT*8 , IFVIEW-1 , IPACKT
            IF (NINT(RSTORE(J+IPCK)).EQ.IMULT-1) THEN
              RSTORE(IREND-INATOM) = J
              INATOM = INATOM + 1
            ENDIF
11        CONTINUE
        ELSE IF (N.EQ.-1) THEN
C THIS IS *
          DO 15 J = ISVIEW +IPACKT*8 , IFVIEW-1, IPACKT
            RSTORE(IREND-INATOM) = J
            INATOM = INATOM + 1
15        CONTINUE
        ELSE IF (N.GE.ICATOM) THEN
C ATOM
          IF (IMULT.EQ.1) THEN
            DO 12 J = 0 , IPACK
              CALL ZGTATM (N , J , IPOS)
              IF (IPOS.EQ.-1) GOTO 12
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM = LROOM (IRLAST ,IREND , INATOM )
                IF (IRM.LT.0) THEN
                  IPROC = 0
                  RETURN
                ENDIF
              ENDIF
              RSTORE(IREND-INATOM) = IPOS
              INATOM = INATOM + 1
12          CONTINUE
          ELSE
            N = (N-ICATOM)*IPACKT + IRATOM
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
            IF (IROK.NE.1) THEN
               IRM = LROOM (IRLAST ,IREND , INATOM )
              IF (IRM.LT.0) THEN
                IPROC = 0
                RETURN
              ENDIF
            ENDIF
            RSTORE (IREND-INATOM) = N
            INATOM = INATOM + 1
          ENDIF
        ELSE IF (N.EQ.0) THEN
          DO 19 J = ISVIEW + IPACKT*8 , IFVIEW-1, IPACKT
            IF (NINT(RSTORE(J+IPCK)).NE.IMULT-1) GOTO 19
            RSTORE(IREND-INATOM) = J
            INATOM = INATOM + 1
19        CONTINUE
        ELSE
          N = N - ICELM + 1
          DO 20 J = ISVIEW + IPACKT*8,IFVIEW-1,IPACKT
            IF (NINT(RSTORE(J+IATTYP)).EQ.N) THEN
C IF NOT ROOM FOR MAX NUMBER IN LIST WE NEED TO CHECK AS EACH ONE IS
C ADDED.
              IF (IROK.NE.1) THEN
                IRM = LROOM (IRLAST ,IREND , INATOM )
                IF (IRM.LT.0) THEN
                  IPROC = 0
                  RETURN
                ENDIF
              ENDIF
              RSTORE (IREND-INATOM) = J
              INATOM = INATOM + 1
            ENDIF
20        CONTINUE
        ENDIF
10    CONTINUE
      GOTO 9999
402   CONTINUE
C ALL
      INATOM = 0
C CHECK FOR ROOM
      NROOM = ( IFVIEW - ISVIEW ) / IPACKT
      IRM = LROOM ( IRLAST , IREND , NROOM )
      IF (IRM.EQ.-1) THEN
        IPROC = 0
        CALL ZMORE( 'Not enough room to do ALL ',0)
        CALL ZMORE1( 'Not enough room to do ALL ',0)
        RETURN
      ENDIF
      DO 30 I = ISVIEW + IPACKT*8,IFVIEW-1,IPACKT
        RSTORE(IREND-INATOM) = I
        INATOM = INATOM + 1
30    CONTINUE
      GOTO 9999
403   CONTINUE
C GROUP
      INATOM = 0
C LOOP OVER THE ATOMS INVOLVED
      DO 4030 J = ISINIT+IPACKT*8 , IFINIT-1 , IPACKT
        DO 4031 K = J + IATTYP + 6 , J+IATTYP+9
          DO 4032 I = ICCNT , ICCNT + ICC - 1
            IF (NINT(RSTORE(K)).NE.ICCMMD(I)) GOTO 4032
C STORE THIS ATOM AND JUMP TO THE NEXT ONE
            RSTORE(IREND-INATOM) = J
            INATOM = INATOM + 1
            GOTO 4030
4032      CONTINUE
4031    CONTINUE
4030  CONTINUE
      GOTO 9999
404   CONTINUE
C OPERATORS
      CALL ZZEROF (AMSYMM,16)
      AMSYMM(4,4) = 1.0
      DO 70 J = 1 , 3
C UNPICK THE NUMBER IN ICCMMD
C SEE THE DESCRIPTION IN ZCISCH FOR THE EXPLANATION OF THE NUMBERS USED
         ISYMNO = ICCMMD(ICCNT+J-1)
         IPREVS = 0
         DO 77 II = 1 , 6
           IMOD = MOD(ISYMNO,10)
           ISYMNO = ISYMNO / 10
           IF (IMOD.EQ.0) GOTO 77
C WHAT SIGNIFICANCE DOES THIS HAVE
           IF (II.EQ.1.OR.II.EQ.4) THEN
C TRANSLATION
             AMSYMM(J,4) = STRAN(IMOD)
           ELSE IF (II.EQ.2.OR.II.EQ.5) THEN
             AMSYMM(J,IMOD) = 1.0
             IPREVS = IMOD
           ELSE IF (II.EQ.3.OR.II.EQ.6) THEN
             IF (IPREVS.EQ.0) THEN
               AMSYMM(J,4) = -AMSYMM(J,4)
             ELSE
               AMSYMM(J,IPREVS) = -AMSYMM(J,IPREVS)
             ENDIF
           ENDIF
77       CONTINUE
70     CONTINUE
       ISFLAG = 1
C RESET TRANSLATION IF NOT BEING USED
      IF (ITFLAG.EQ.0) THEN
        CALL ZZEROF (AMTRAN,3)
      ENDIF
      IF (ID1.LT.500) THEN
C ADD
C CHECK NEXT COMMAND
        INXT = LNCHCK (400)
        IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
          ISFLAG = 0
          CALL ZSADD
        ENDIF
      ELSE
C MOVE
C CHECK NEXT COMMAND
        INXT = LNCHCK (500)
        IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
          CALL ZSMOVE
          ISFLAG = 0
        ENDIF
      ENDIF
      GOTO 9999
405   CONTINUE
C TRANSLATION
      IF (ISFLAG.EQ.0) THEN
        CALL ZZEROF (AMSYMM,16)
        DO 40 I = 1,4
          AMSYMM (I,I) = 1.0
40      CONTINUE
      ENDIF
      DO 50 I = 1,3
        AMTRAN (I) = RCOMMD (IRCNT+I-1)
50    CONTINUE
      ITFLAG = 1
      IF (ID1.LT.500) THEN
C ADDC CHECK NEXT COMMAND
        INXT = LNCHCK (400)
        IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
          CALL ZSADD
          ITFLAG = 0
        ENDIF
      ELSE
C CHECK NEXT COMMAND
        INXT = LNCHCK (500)
        IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
          CALL ZSMOVE
          ITFLAG = 0
        ENDIF
      ENDIF
      GOTO 9999
406   CONTINUE
C INITIAL
      INATOM = 0
C CHECK FOR ROOM
      NROOM = ( IFINIT - ISINIT ) / IPACKT
      IRM = LROOM ( IFINIT , IREND , NROOM)
      IF (IRM.EQ.-1) THEN
        IPROC = 0
        CALL ZMORE( 'Not enough room to do this calculation',0)
        CALL ZMORE1( 'Not enough room to do this calculation',0)
        RETURN
      ENDIF
      IRLAST = IFINIT
      DO 60  I = ISINIT+IPACKT*8,IFINIT-1,IPACKT
        RSTORE (IREND-INATOM) = I
        INATOM = INATOM + 1
60    CONTINUE
      GOTO 9999
9999  CONTINUE
      RETURN
      END

CODE FOR ZCMD6
      SUBROUTINE ZCMD6 (ID)
C This routine does the ENCLOSURE commands.
      
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

      REAL ORTH(3,3)
      IVCHAN = 1
      ID = ID - (ID/100)*100 + 1
      GOTO (600,601,602,603,604,605,606,607,608,609,610,611,666,613) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
666   CONTINUE
      GOTO 9999
600   CONTINUE
C ENCLOSURE ITSELF
C THIS IS THE HEADER
      IGPCK = 0
      IENCL = 1
      GOTO 9999
601   CONTINUE
C POINT
C SET UP CENTRE COORDS
      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
      DO 20 I = 1,3
        PKCNF(I) = RCOMMD (IRCNT+I-1)
20    CONTINUE
      CALL ZMATV (ORTH,PKCNF,PKCNA)
      IENCAT = 0
      GOTO 9999
602   CONTINUE
C SPHERE
      IPPCK = 3
      CALL ZZEROF (PKMIN,3)
      CALL ZZEROF (PKMAX,3)
      DO 50 J = 1,3
        PKMAX (J) = ABS(RCOMMD (IRCNT))
        PKMIN (J) = -ABS(RCOMMD (IRCNT))
50    CONTINUE
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
603   CONTINUE
C ANORTHIC
      IPPCK = 1
C SET UP THE LIMITS
      DO 30 I = 1,3
        PKMIN(I) = -ABS(RCOMMD(IRCNT+(I-1)*2))
        PKMAX(I) = ABS(RCOMMD(IRCNT+(I-1)*2+1))
30    CONTINUE
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
604   CONTINUE
C ORTHOGONAL
      IPPCK = 2
      DO 40 I = 1,3
        PKMIN(I) = -ABS(RCOMMD(IRCNT+(I-1)*2))
        PKMAX(I) = ABS(RCOMMD(IRCNT+(I-1)*2+1))
40    CONTINUE
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
605   CONTINUE
C CUT
      ITYPCK = 1
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
606   CONTINUE
C COMPLETE
      ITYPCK = 2
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
607   CONTINUE
C CENTROID
      ITYPCK = 3
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
608   CONTINUE
C INTRA
      IPCOLL = 0
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
609   CONTINUE
C INTER
      IPCOLL = 1
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
610   CONTINUE
C KEEP
      IPCOLL = 2
C CHECK NEXT COMMAND
      INXT = LNCHCK (600)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
611   CONTINUE
C GROUP
      IENCL = 1
C STORE THE GROUP NUMBERS FOR LATER USE
      IF (ICC.NE.0) THEN
        DO 6110 I = ICCNT ,ICCNT + ICC - 1
          RSTORE(ISYMED - I + ICCNT) = ICCMMD(I)
6110    CONTINUE
        IGPCK = ICC
      ELSE
C IF NO GROUP NAME IS GIVEN THEN WE ARE DOING ALL THE GROUPS
        DO 6111 I = 1 , NGRP
          RSTORE(ISYMED-I+1) = I
6111    CONTINUE
        IGPCK = NGRP
      ENDIF
      GOTO 9999
613   CONTINUE
C ATOM
      IF (ICC.EQ.0) GOTO 9999
C ATOM IS ENTERED - SET UP COORDS.
      N = ISINIT+ (ICCMMD(ICCNT)-ICATOM)*IPACKT
      DO 10 I = 1,3
        PKCNF(I) = RSTORE(N+I)
10    CONTINUE
      IENCAT = N
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD7
      SUBROUTINE ZCMD7 (ID)
C This routine does the PICTURE group of commands.

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

      ID = ID - (ID/100)*100 + 1
      GOTO (700,700,702,703,704,705,706,707,708,709,710,711,712,
     c 713,714,715,716,111) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
111   CONTINUE
      GOTO 9999
700   CONTINUE
C FRAME/NOFRAME
      IF (ID.EQ.1) THEN
        IFRAME = 1
        IFORE = 0
        IBACK = 15
      ELSE
        IFRAME = -1
        IFORE = 15
        IBACK = 0
      ENDIF
      GOTO 9999
702   CONTINUE
C MAXIMISE
      GOTO 9999
703   CONTINUE
C ON
      IMAXIM = 1
      GOTO 9999
704   CONTINUE
C OFF
      IMAXIM = 0
      GOTO 9999
705   CONTINUE
C TEXT
      ITNUMB = 0
      IF (ICC.EQ.0) GOTO 9999
C NOW LOAD IN THE TEXT
      IF (ICCMMD(ICCNT).GT.ITMAX/2) ICCMMD(ICCNT) = ITMAX/2
C MAXIMUM NUMBER OF LETTERS IS 120.
      DO 20 I = 1 , ICCMMD(ICCNT)
        CSTORE(ICTXT-(I-1)*2) = CTCOMD(ITCNT+I-1)(1:6)
        CSTORE(ICTXT-(I-1)*2-1) = CTCOMD(ITCNT+I-1)(7:12)
20    CONTINUE
      ITCNT = ITCNT + ICCMMD(ICCNT)
C STORE THE TEXT POSITION
      RSTORE(ITEXT+INTXT*4) = ICTXT
C STORE THE NUMBER OF ARRAY ITEMS FOR THIS TEXT
      RSTORE(ITEXT+INTXT*4+1) = ICCMMD(ICCNT)*2
      INTXT = INTXT + 1
      WRITE (CLINE,30) INTXT
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      ITNUMB = INTXT
      ICTXT = ICTXT - ICCMMD(ICCNT)*2
30    FORMAT ('The TEXT has been assigned the number ',I2)
      GOTO 9999
706   CONTINUE
C NUMBER
      ITNUMB = NCOMMD (INCNT)
      GOTO 9999
707   CONTINUE
C POSITION
C ALTER THE TEXT POSITION
      RSTORE (ITEXT+(ITNUMB-1)*4+2) = RCOMMD(IRCNT)/100.0
      RSTORE (ITEXT+(ITNUMB-1)*4+3) = RCOMMD(IRCNT+1)/100.0
      IF (IHAND.EQ.1) THEN
        RSTORE (ITEXT+(ITNUMB-1)*4+3) =
     c 1.0 - RSTORE(ITEXT+(ITNUMB-1)*4+3)
      ENDIF
      GOTO 9999
708   CONTINUE
C ACTIVATE THE MOUSE
C      WRITE (ISTOUT,*) 'Use the mouse to position the TEXT.'
C      IMOUSE = 4
C      CALL ZMOUSE
C NOW LOOP UNTIL WE GET SOME MOUSE ACTION
C CONVER THE COORDS TO PERCENTAGE ONES.
        RSTORE(ITEXT+(ITNUMB-1)*4+2) =
     c RSTORE (ITEXT+(ITNUMB-1)*4+2) / (XCEN * 2.0 )
       RSTORE (ITEXT +(ITNUMB-1)*4+3) =
     c RSTORE(ITEXT+(ITNUMB-1)*4+3) / ( YCEN * 2.0 )
      IF (IHAND.EQ.1) THEN
        RSTORE(ITEXT+(ITNUMB-1)*4+3) =
     c1.0 - RSTORE(ITEXT+(ITNUMB-1)*4+3)
      ENDIF
      GOTO 9999
709   CONTINUE
C SCALE HEADER
      GOTO 9999
710   CONTINUE
C FIX
      ISLCNT = 0
      IF (ISCRN.EQ.5 .OR. ISCRN.EQ.6 .OR. ISCRN.EQ.8) THEN
        SCLFIX = SCALE / 10.0
      ELSE
        SCLFIX = SCALE
      ENDIF
      GOTO 9999
711   CONTINUE
C UNFIX
      ISLCNT = 1
      GOTO 9999
712   CONTINUE
C SET
      SCLFIX = RCOMMD(IRCNT)
      ISLCNT = 0
      GOTO 9999
713   CONTINUE
C FONT
C-DJW      IF (ICN.EQ.1) IFSIZE = MAX(2,NCOMMD(INCNT))
      IF (ICN.EQ.1) IFONT = MAX(2,NCOMMD(INCNT))
      GOTO 9999
714   CONTINUE
C DEFAULT FONT
C-DJW      IFSIZE = 12
c DJW Nov03
      IFONT = 20
      GOTO 9999
715   CONTINUE
C A TITLE
      IF (ICCMMD(ICCNT).GT.6) ICCMMD(ICCNT)= 6
      CTITLE = ' '
      ITITLE = 1
      DO 7150 I = 1 , ICCMMD(ICCNT)
        CTITLE((I-1)*12+1:(I-1)*12+12) = CTCOMD(ITCNT+I -1)
7150  CONTINUE
      GOTO 9999
716   CONTINUE
C MOUSE RESET
      GOTO 9999
9999  CONTINUE
      RETURN
      END

CODE FOR ZCMD8 [ COMMAND GROUP 800 ]
      SUBROUTINE ZCMD8 (ID)
C THIS IS THE CODE FOR THE 800 GROUP OF COMMANDS IE LABEL ETC
C

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

      ID = ID - (ID/100)*100 + 1
      GOTO (800,801,802,803,804,805,805,888,888,800,801,802,812,
     c 813,814,804) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
888   CONTINUE
      GOTO 9999
800   CONTINUE
C LABEL/NOLABEL
      IF (ID.EQ.1) THEN
        ILABFG = 1
      ELSE
        ILABFG = 0
      ENDIF
      DO 10 I = ICCNT,ICCNT+ICC-1
        N = ICCMMD(I)
        IMULT = ICMULT (I)
        CALL ZPARAM (N,IATTYP+2,REAL(ILABFG),1,IMULT)
10    CONTINUE
      GOTO 9999
801   CONTINUE
C ALL
      IF (ID.EQ.16) ILABFG = 2.0
      DO 30 I = ISVIEW ,IFVIEW-1,IPACKT
30    RSTORE(I+IATTYP+2) = ILABFG
      IF (ID.EQ.11) IPLAB = 0
      GOTO 9999
802   CONTINUE
C GROUP
      IG = ICCMMD(ICCNT)
      VAL = REAL(ILABFG)
      CALL ZMODGP (IG,IATTYP+2,VAL)
      GOTO 9999
803   CONTINUE
C MOUSE
      CALL ZMLAB
      GOTO 9999
804   CONTINUE
C CELL
      DO 8160 I = ISVIEW , ISVIEW + IPACKT*7 , IPACKT
        RSTORE(I+IATTYP+2) = ILABFG
8160  CONTINUE
      GOTO 9999
805   CONTINUE
C FRAGMENTS
      DO 8050 I = ICCNT , ICCNT+ICC-1
        N = (ICCMMD(I)-ICATOM)*IPACKT+IRATOM
        CALL ZFRAG (N , IATTYP+2 , REAL(ILABFG) , 1)
8050  CONTINUE
      GOTO 9999
812   CONTINUE
C GENERATED LABELS
      IPLAB = 1
      IVCHAN = 1
      GOTO 9999
813   CONTINUE
C INITIAL LABELS
      IPLAB = 0
      IVCHAN = 1
      GOTO 9999
814   CONTINUE
C ACTIVATE SECONDARY BOND CHECKING
      ILSEC = 1
      GOTO 9999
9999  CONTINUE
      RETURN
      END

CODE FOR ZCMD9 [ COMMAND GROUP 900 ]
      SUBROUTINE ZCMD9 (ID)
C THIS IS THE CODE FOR THE 900 GROUP OF COMMANDS IE INPUT ETC
C

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

      CHARACTER*60 FILENM
      CHARACTER*(ICLEN) CISSUX
      LOGICAL LOPEN,LFILES
      ID = ID - (ID/100)*100 + 1
      GOTO (900,901,902,903,904,905,906,907,908,909,
     c 910,911,912,913,914,915,916,917,918,919,920,921,922) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
900   CONTINUE
C INPUT COMMAND
      GOTO 9999
901   CONTINUE
C OUTPUT COMMAND
      IF (IRATOM.EQ.-1) THEN
       CALL ZMORE( 'Error - no data has been loaded!',0)
       CALL ZMORE1( 'Error - no data has been loaded!',0)
        IPROC = 0
        ITCNT = ICTPOS
      ENDIF
      GOTO 9999
902   CONTINUE
C LIST5
      CALL ZOUTL5
      GOTO 9999
903   CONTINUE
C CSSR
      GOTO 9999
904   CONTINUE
C ORTHOGONAL COORDS
      CALL ZOUTCS ( 1 )
      GOTO 9999
905   CONTINUE
C FRACTIONAL COORDS
      CALL ZOUTCS ( 0 )
      GOTO 9999
CDJWFEB99
922   CONTINUE
C OUTPUT .XYZ FILE
      CALL ZOUTCS( -1)
      GOTO 9999
906   CONTINUE
C DARREN XYZ FILE
      CALL ZXYZ
      CALL ZATMUL(0,0,0)
      CALL ZDOCON (0,0,0)
      GOTO 9999
907   CONTINUE
C LIST5
      IVCHAN = 1
      CALL ZINL5
      CALL ZATMUL(0,0,0)
      CALL ZDOCON (0,0,0)
      CALL ZABAND(2)
      CALL ZSTUP
      CALL ZABAND(2)
C LOSE THE INPUT LINE
      IEND = 0
      GOTO 9999
908   CONTINUE
C CELL
C This deals with the cell parameters
      IVCHAN = 1
      A = RCOMMD(IRCNT)
      B = RCOMMD(IRCNT+1)
      C = RCOMMD(IRCNT+2)
      ALP = RCOMMD(IRCNT+3)
      BET = RCOMMD(IRCNT+4)
      GAM = RCOMMD(IRCNT+5)
      CALL ZCRYST(A,B,C,ALP,BET,GAM)
      CALL ZVIMAT
      GOTO 9999
909   CONTINUE
C CSSR FORMAT
      IVCHAN = 1
      CALL ZINCSS
      CALL ZATMUL (0,0,0)
      CALL ZABAND(2)
      CALL ZSTUP
      CALL ZABAND(2)
C LOSE THE INPUT LINE
      IEND = 0
      GOTO 9999
910   CONTINUE
      IVCHAN = 1
      CALL ZFDAT
      CALL ZATMUL (0,0,0)
      CALL ZABAND(2)
      CALL ZSTUP
      CALL ZABAND (2)
      GOTO 9999
911   CONTINUE
C ARCHIVE
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT ( FILENM , 60 , NPOS)
      IF (.NOT.LFILES(3,FILENM,99)) THEN
        CALL ZMORE ('Error on file open:',0)
        CALL ZMORE(FILENM,0)
        CALL ZMORE1 ('Error on file open:'//filenm ,0)
        IPROC  = 0
        RETURN
       ENDIF
C THESE ARE THE COMMON BLOCKS
C VARIABLES USED WITH COMMAND STORAGE
       WRITE (99) VERS
        CALL ZMORE('START stroing:',0)
C VARIABLES USED WITH COMMAND STORAGE - BUT NOT RSTORE
       WRITE (99) ICPOS,ICCPOS,ICRPOS,ICTPOS,ICNT,ICCNT,IRCNT,
     c INCNT,ITCNT,ICOMMD,RCOMMD,NCOMMD,INFCMD,ICCMMD,ICNPOS,
     c ICINPS, ICMULT, IXYZO , IATTYP, IPCK , IBOND , ILAB, ISYM,
     c IPACKT , NSCRAT , ISTACK , ZSTACK
C VARIABLES USED FOR COMMAND LINE ANALYSIS
      WRITE (99) IPROC,IMENCN,ILINE,IBEG,IEND,IN,IR,IC,IINT
     c ,IRL,ICHARS,ICTYPE,INCOM,IPREV,IHEAD,ICC,ICN,ICR,ISTORE,IFOBEY,
     c ICABAN ,ICLOG, IVNUM
C VARIABLES FOR DATA CONTROL
      WRITE (99) ICOM,IRELM,ICELM,ICATOM,IRATOM,IRLAST,ICLAST,IREND,
     c ICRYST,NSYMM,ISVIEW,ISYMED,ICELLC,IPACK,INATOM,IELROT,
     c IFVIEW,ISINIT,IFINIT,NGRP,IGRP,IKEY,ITEXT,INTXT,ITNUMB,IGG,ICTXT,
     c IGPCK, ICLST5, ICONBG, ICONED
C VARIABLES USED FOR CALCULATIONS
       WRITE (99) DISEND,DISBEG,ANGEND,ANGBEG,CENTR,NDIST1,PKMIN,
     c PKMAX,PCMIN,PCMAX,PKCNF,PKCNA,D000,AMSYMM,AMTRAN,MAT1,MAT2,
     c ROT,XC,YC,ZC,XCOS,XSIN,PI,ISSPRT,IBDORD,IORD,ISFLAG,ITFLAG,NDIST2
     c ,RSTOL, ISPECL,IENCAT
C VARIABLES USED FOR MOUSE CONTROL
      WRITE (99) IMOUSE,NMOUSE
C CHARACTER VARIABLES - BUT NOT CSTORE
      WRITE (99) LINE,CHELP,CSUB,CTCOMD,LLINE,CGRAPH,
     c CMENUS , CBUFF , CLINE
     c ,COLNAM, COLGRY
C VARIABLE DEALING WITH GRAPHICS
      WRITE (99) YCEN,XCEN,SCLLIM,JPAGE,RES,IPOST,IFONT,NCAWU,NCWU,
     c IHAND,XCP,YCP,SCALE,IVCHAN,ISLCNT, RELSCL,IBUFF,SCLFIX,
     c IDEVCH,IDEVCS,IDEVCL,XCENS,XCENH,YCENS,YCENH,SCLIMS,SCLIMH,
     c IBACKS,IBACKH,IFOREH,IFORES,ILABCS,ILABCH,IBNDCS,IBNDCH,ICLDES,
     c ICLDEH,ISCALS,ISCALH, INLINE, XOFF, YOFF
C COLOUR NUMBERS
      WRITE (99) IVGACL,IGREYC, ICOLS
C COMMAND SET FLAGS
       WRITE (99) ISCRN,IELTYP,IOVER,IDEV,IHARD,
     c ISQR,IDOKEY,NKEY,ICOLL,IPPCK,ITYPCK,IAXIS,IMAXIM,DBDMAX,RNUISO,
     c IPLAB,ILSEC,ILSIZE,RTAPER,RTHICK,IMTFLG,IFILL,IEXFLG,
     c IFRAME,ICURS,ILABFG,IPCOLL,COLTOL,ICELL,IFOLAP,ITCOL,IENCL, IPCX
     c ,ILOG , IPHOTO, ICLDEF, ICAMER , IEDIT , ICBUFF, ITEKFG
     c , IBACK,IFORE,ILABCL,IBNDCL
C BLOCK FOR INTEGER*2 NUMBERS
      WRITE (99) IXX2,IYY2
      DO 9101 I = 1 , IRLAST
        WRITE (99) RSTORE(I)
9101  CONTINUE
      DO 9102 I = IREND , ITOT
        WRITE (99) RSTORE(I)
9102  CONTINUE
      DO 9103 I = 1 , ICLAST
        WRITE (99) CSTORE(I)
9103  CONTINUE
      DO 9104 I = IGRP-NGRP*2-1 , ITOT
        WRITE (99) CSTORE(I)
9104  CONTINUE
      IF (.NOT.LFILES(0,' ',99)) THEN
        CALL ZMORE('Error closing archive file.',0)
      ENDIF
      GOTO 9999
912   CONTINUE
C RESTORE
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT (FILENM , 60, NPOS)
      IF (.NOT.LFILES (4,FILENM,99)) THEN
        CALL ZMORE('Error opening file:',0)
        CALL ZMORE(FILENM,0)
        CALL ZMORE1('Error opening file:'//filenm,0)
        IPROC = 0
        RETURN
      ENDIF
      READ (99) VERS
      IF (NINT(VERS*10).EQ.1) THEN
C THESE ARE THE COMMON BLOCKS
C VARIABLES USED WITH COMMAND STORAGE (BUT NOT RSTORE)
        CALL ZMORE('START retrieving:',0)
       READ (99) ICPOS,ICCPOS,ICRPOS,ICTPOS,ICNT,ICCNT,IRCNT,
     c INCNT,ITCNT,ICOMMD,RCOMMD,NCOMMD,INFCMD,ICCMMD,ICNPOS,
     c ICINPS, ICMULT, IXYZO , IATTYP, IPCK , IBOND , ILAB, ISYM,
     c IPACKT , NSCRAT , ISTACK , ZSTACK
C VARIABLES USED FOR COMMAND LINE ANALYSIS
      READ (99) IPROC,IMENCN,ILINE,IBEG,IEND,IN,IR,IC,IINT
     c ,IRL,ICHARS,ICTYPE,INCOM,IPREV,IHEAD,ICC,ICN,ICR,ISTORE,IFOBEY,
     c ICABAN ,ICLOG, IVNUM
C VARIABLES FOR DATA CONTROL
      READ (99) ICOM,IRELM,ICELM,ICATOM,IRATOM,IRLAST,ICLAST,IREND,
     c ICRYST,NSYMM,ISVIEW,ISYMED,ICELLC,IPACK,INATOM,IELROT,
     c IFVIEW,ISINIT,IFINIT,NGRP,IGRP,IKEY,ITEXT,INTXT,ITNUMB,IGG,ICTXT,
     c IGPCK, ICLST5, ICONBG, ICONED
C VARIABLES USED FOR CALCULATIONS
       READ (99) DISEND,DISBEG,ANGEND,ANGBEG,CENTR,NDIST1,PKMIN,
     c PKMAX,PCMIN,PCMAX,PKCNF,PKCNA,D000,AMSYMM,AMTRAN,MAT1,MAT2,
     c ROT,XC,YC,ZC,XCOS,XSIN,PI,ISSPRT,IBDORD,IORD,ISFLAG,ITFLAG,NDIST2
     c ,RSTOL, ISPECL,IENCAT
C VARIABLES USED FOR MOUSE CONTROL
      READ (99) IMOUSE,NMOUSE
C CHARACTER VARIABLES - BUT NOT CSTORE
      READ (99) LINE,CHELP,CSUB,CTCOMD,LLINE,CGRAPH,
     c CMENUS , CBUFF , CLINE
     c ,COLNAM, COLGRY
C VARIABLE DEALING WITH GRAPHICS
      READ (99) YCEN,XCEN,SCLLIM,JPAGE,RES,IPOST,IFONT,NCAWU,NCWU,
     c IHAND,XCP,YCP,SCALE,IVCHAN,ISLCNT, RELSCL,IBUFF,SCLFIX,
     c IDEVCH,IDEVCS,IDEVCL,XCENS,XCENH,YCENS,YCENH,SCLIMS,SCLIMH,
     c IBACKS,IBACKH,IFOREH,IFORES,ILABCS,ILABCH,IBNDCS,IBNDCH,ICLDES,
     c ICLDEH,ISCALS,ISCALH, INLINE, XOFF, YOFF
C COLOUR NUMBERS
      READ (99) IVGACL,IGREYC, ICOLS
C COMMAND SET FLAGS
       READ (99) ISCRN,IELTYP,IOVER,IDEV,IHARD,
     c ISQR,IDOKEY,NKEY,ICOLL,IPPCK,ITYPCK,IAXIS,IMAXIM,DBDMAX,RNUISO,
     c IPLAB,ILSEC,ILSIZE,RTAPER,RTHICK,IMTFLG,IFILL,IEXFLG,
     c IFRAME,ICURS,ILABFG,IPCOLL,COLTOL,ICELL,IFOLAP,ITCOL,IENCL, IPCX
     c ,ILOG , IPHOTO, ICLDEF, ICAMER , IEDIT , ICBUFF, ITEKFG
     c , IBACK,IFORE,ILABCL,IBNDCL
C BLOCK FOR INTEGER*2 NUMBERS
      READ (99) IXX2,IYY2
      DO 9201 I = 1 , IRLAST
        READ (99) RSTORE(I)
9201  CONTINUE
      DO 9202 I = IREND , ITOT
        READ (99) RSTORE(I)
9202  CONTINUE
      DO 9203 I = 1 , ICLAST
        READ (99) CSTORE(I)
9203  CONTINUE
      DO 9204 I = IGRP-NGRP*2-1 , ITOT
        READ (99) CSTORE(I)
9204  CONTINUE
      ENDIF
      IF (.NOT.LFILES(0,' ',99)) THEN
        CALL ZMORE('Error on closing archive file',0)
        RETURN
      ENDIF
      GOTO 9999
913   CONTINUE
C ISSUE
C GET THE TEXT
      DO 9130 I = 1 , ICCMMD(ICCNT)
        CISSUX((I-1)*12+1:I*12) = CTCOMD(ITCNT+I-1)
9130  CONTINUE
      CALL ZISSUE(CISSUX(1:ICCMMD(ICCNT)*12),IFAIL)
      ITCNT = ITCNT + ICCMMD(ICCNT)
      GOTO 9999
914   CONTINUE
C LOG
      IF (ICC.EQ.0) RETURN
C DO WE HAVE A LOG FILE OPEN.
      IF (ILOG.EQ.1) THEN
        IF (.NOT.LFILES(0,' ',IFLOG)) THEN
          CALL ZMORE('Error on closing logfile',0)
          CALL ZMORE1('Error on closing logfile',0)
          IPROC = 0
          RETURN
        ENDIF
      ENDIF
C OPEN A NEW ONE
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT (FILENM , 60, NPOS)
      IF (.NOT.LFILES (2 , FILENM , IFLOG)) THEN
        CALL ZMORE('Error on opening logfile:',0)
        CALL ZMORE(FILENM,0)
        CALL ZMORE('Error on opening logfile:'//filenm,0)
        IPROC = 0
        RETURN
      ENDIF
      ILOG = 1
C CLEAR THE LOG INFORMATION
      CALL ZLOGWT(0)
      GOTO 9999
915   CONTINUE
C LOG STOP
      IF (ILOG.EQ.0) GOTO 9999
      ILOG = 0
      IF (.NOT.LFILES (0, ' ' , IFLOG)) THEN
        CALL ZMORE('Error on closing logfile.',0)
      ENDIF
      CALL ZLOGWT(0)
      GOTO 9999
916   CONTINUE
C PRINT
CDJWNOV99      CISSUX(1:) = 'PRINT '
      cissux(:) = ' '
      CISSUX(1:) = 'COPY '
9160  CONTINUE
      CALL ZGTTXT (FILENM , 60 , ICCMMD(ICCNT))
C IS THIS FILE CURRENTLY OPENED?
      INQUIRE (FILE=FILENM , NUMBER=IFNUM, OPENED=LOPEN)
      IF (LOPEN) THEN
        IF (.NOT.LFILES (0 , ' ' , IFNUM)) THEN
          CALL ZMORE('Error on closing hardcopy file.',0)
          IPROC = 0
          RETURN
        ENDIF
      ENDIF
      CISSUX(9:) = FILENM
CDJWNIV99
      j = len(cissux)
      do 1234 klen = j, 1 , -1
            if (cissux(klen:klen) .ne. ' ') goto 12345
1234  continue
      klen = 1
12345 continue
      CISSUX(kLEN+1:) = ' lpt1'
      call zmore(cissux(1:60),0)
      CALL ZISSUE (CISSUX,IFAIL)
      GOTO 9999
917   CONTINUE
C EDIT
      GOTO 9999
918   CONTINUE
C EDIT ON
      IEDIT = 1
      GOTO 9999
919   CONTINUE
C EDIT OFF
      IEDIT = 0
      GOTO 9999
920   CONTINUE
C CRYSTALS
C SET UP THE FILENAME IN THE CORRECT POSITION
      IF (IRATOM.EQ.-1) THEN
        CALL ZMORE( 'Entering CRYSTALS without data',0)
      ELSE
        CTCOMD(ITCNT) = 'CAMERON.L5'
        ICCMMD(ICCNT) = 1
        CALL ZOUTL5
        CALL ZTXTMD
      ENDIF
c      CALL ZSPROG('C:\CRYSTALS\IMAGES\CRYSTALS.EXE')
c      STOP
      IPROC = 0
      ICAMER = -1
      GOTO 9999
921   continue
C PCSEND
      CISSUX(1:) = 'PCSEND '
      GOTO 9160
      goto 9999
9999  CONTINUE
      RETURN
      END

CODE FOR ZCMD10 [ 1000 GROUP OBEY ]
      SUBROUTINE ZCMD10 (ID)
C This routines takes in a command file - either a .INI or a cameron
C file and tries to interpret it.
C OBEY AND USE ARE EQUIVALENT COMMANDS

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

      CHARACTER*60 FILENM,FILEN1
      CHARACTER*80 CL
      LOGICAL LEXIST,LFILES
      REAL SYMM(4,4)
      REAL A,B,C,ALP,BET,GAM
      ID = ID - (ID/100)*100 + 1
      GOTO (1000,1001) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
1000  CONTINUE
C OBEY
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT (FILENM , 60, NPOS)
C EXISTENCE OF FILE IS ALREADY CHECKED.
      IF (IFOBEY.EQ.-1) THEN
        IFOBEY = IFSTAR
      ELSE
        IFOBEY = IFOBEY + 1
      ENDIF
      IF (.NOT.LFILES (1,FILENM,IFOBEY)) THEN
        CALL ZMORE('Error on opening file:',0)
        CALL ZMORE(FILENM,0)
        CALL ZMORE1('Error on opening file:'//filenm,0)
        IPROC = 0
        RETURN
      ENDIF
C OPEN THE FILE
      READ (IFOBEY,'(A80)',ERR=9999) CL
      IF (CL(1:5).NE.'$DATA') THEN
C THIS MUST BE A CAMERON LOG FILE
        REWIND (IFOBEY)
C WE NEED TO JUNK ANYTHING ELSE ON THIS LINE
        IPROC = 0
        RETURN
      ENDIF
C OTHERWISE IT IS A SNOOPI.INI FILE
      READ (IFOBEY,100,ERR=9999) A,B,C,ALP,BET,GAM
100   FORMAT (4X,3F10.4,3F10.3)
      CALL ZCRYST (A,B,C,ALP,BET,GAM)
      CALL ZVIMAT
      READ (IFOBEY,'(A80)',ERR=9999) CL
      READ (IFOBEY,'(A60)') FILEN1
C THE NEW FILENAME CANNOT BE LONGER THAN THE OLD ONE
      ITCNT = ITCNT - NPOS
      DO 102 I = 1 , NPOS
        CTCOMD(ITCNT+I-1) = FILEN1((I-1)*12+1:I*12)
102   CONTINUE
C READ IN THE SYMMETRY OPERATORS
      READ (IFOBEY,'(A80)',ERR=9999) CL
      IF (CL(1:5).NE.'$SYMM') THEN
        GOTO 9999
      ENDIF
      NSYMM = 0
20    CONTINUE
C CHECK ROOM
      NROOM = 16
      IRM = LROOM ( IRLAST , ITOT-NSYMM*16 , NROOM)
      IF (IRM.EQ.-1) THEN
        CALL ZMORE( 'Symmetry input failed - not enough room.',0)
        IPROC = 0
        NSYMM = 0
        IF (.NOT.LFILES (0,' ',IFOBEY)) THEN
          CALL ZMORE('Error on closing input file.',0)
        ENDIF
        IF (IFOBEY.GT.IFSTAR) THEN
          IFOBEY = IFOBEY - 1
        ELSE
          IFOBEY = -1
        ENDIF
        RETURN
      ENDIF
      CALL ZZEROF (SYMM,16)
      IF (NSYMM.EQ.0) THEN
        DO 24 I = 1, 4
          SYMM(I,I) = 1.0
24      CONTINUE
        NSYMM = NSYMM + 1
        CALL ZMOVE (SYMM,RSTORE(ITOT-NSYMM*16),16)
      ENDIF
      READ (IFOBEY,'(A80)',ERR=9999) CL
      IF (CL(1:3).EQ.'MAT') THEN
C READ IN THE OPERATOR
        DO 30 I = 1 , 3
          READ (IFOBEY,101,ERR=9999) (SYMM(I,J), J=1,4)
101       FORMAT (8X,4F9.3)
30      CONTINUE
        SYMM(4,4) = 1.0
C STORE THE OPERATOR
        NSYMM = NSYMM + 1
        CALL ZMOVE (SYMM,RSTORE(ITOT-NSYMM*16),16)
        GOTO 20
      ENDIF
C DO WE HAVE A NOCEN?
      IF (CL(1:5).NE.'NOCEN') THEN
C NO - NEED TO APPLY CENTERING
C LOOP OVER THE OPERATORS
C CHECK ROOM AGAIN
        NROOM = NSYMM * 16
        IRM = LROOM ( IRLAST, ITOT - NSYMM*16 , NROOM)
        IF (IRM.EQ.-1) THEN
          CALL ZMORE( 'Symmetry input failed - not enough room.',0)
          IPROC = 0
          NSYMM = 0
          IF (.NOT.LFILES (0,' ',IFOBEY)) THEN
            CALL ZMORE('Error on closing input file.',0)
          ENDIF
          IF (IFOBEY.GT.IFSTAR) THEN
            IFOBEY = IFOBEY - 1
          ELSE
            IFOBEY = -1
          ENDIF
          RETURN
        ENDIF
        DO 40 II = 1 , NSYMM
          CALL ZMOVE (RSTORE(ITOT-II*16),SYMM,16)
C INVERT THE ROTATION PART
          DO 50 J = 1 , 3
            DO 50 K = 1,3
              SYMM(J,K) = -SYMM(J,K)
50        CONTINUE
C NOW STORE IT AGAIN
          CALL ZMOVE (SYMM,RSTORE(ITOT-II*16-NSYMM*16),16)
40      CONTINUE
        NSYMM = NSYMM * 2
      ENDIF
C UPDATE THE PARAMETERS
      ISYMED = ITOT - NSYMM*16 - 1
      IREND = ISYMED
      CALL ZMORE( 'Symmetry information is loaded.',0)
C NOW READ IN THE FILE
C CHECK THAT IT EXISTS
      INQUIRE (FILE=FILEN1,EXIST=LEXIST)
      IF (.NOT.LEXIST) GOTO 9990
      CALL ZINL5
      IF (IPROC.EQ.0) GOTO 9999
      CALL ZATMUL(0,0,0)
C      IF (ISPECL.EQ.1) CALL ZSPECL (1)
      CALL ZDOCON (0,0,0)
C CLOSE THE OBEYED FILE
      CLOSE(IFOBEY)
      IF (IFOBEY.GT.IFSTAR) THEN
        IFOBEY = IFOBEY - 1
      ELSE
        IFOBEY = -1
      ENDIF
      CALL ZABAND(2)
      CALL ZSTUP
C LOSE THE INPUT LINE
      IEND = 0
      RETURN
1001  CONTINUE
C RESET
      IRLAST = 1
      CALL ZINIT
      IF (IPCX.EQ.1) THEN
        ID = 1
        CALL ZCMD11(ID)
        CALL ZMORE ('Setting SCREEN to VGA.',0)
        IPCX = 0
      ENDIF
C CHECK FOR EXISTENCE OF CAMERON.INI
      INQUIRE (FILE='CAMERON.INI',EXIST=LEXIST)
      IF (LEXIST) THEN
        CALL ZMORE ('CAMERON.INI has not been loaded.',0)
        CALL ZMORE ('OBEY CAMERON.INI will execute it if required.',0)
      ENDIF
      RETURN
9990  CONTINUE
      CALL ZMORE( 'List5 file in Obey file does not exist.',0)
      CALL ZMORE1( 'List5 file in Obey file does not exist.',0)
9999  CONTINUE
      CALL ZMORE( 'All info is lost.',0)
      IPROC = 0
      WRITE (CLINE,9991) FILENM
      CALL ZMORE(CLINE,0)
9991  FORMAT ('File has incorrect format : ',A)
      IF (.NOT.LFILES (0,' ',IFOBEY)) THEN
        CALL ZMORE('Error on closing input file.',0)
      ENDIF
      IF (IFOBEY.GT.IFSTAR) THEN
        IFOBEY = IFOBEY - 1
      ELSE
        IFOBEY = -1
      ENDIF
      CALL ZABAND(2)
      RETURN
      END
 
CODE FOR ZCMD11 [ 1100 GROUP SCREEN/HARDCOPY ]
      SUBROUTINE ZCMD11 (ID)
      
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
      INCLUDE 'CAMDEV.INC'

C READ IN AND SET UP THE DEVICE SPECIFIERS - THIS ROUTINE IS
C CALLED FROM THE SMALL VERSION TO SET UP THE DEVICE.
      LOGICAL LFILES
      ID = ID - (ID/100)*100 + 1
      GOTO (1100,1101,1101,1101,1101,1101,1101,1101,1101,1101,1101,
     c1100) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
1100  CONTINUE
C DEVICE/HARDCOPY ITSELF - DUMMY HEAD COMMAND
      GOTO 9999
1101  CONTINUE
C RESET THE POSTSCRIPT FLAGS
      ICPOST = 0
      IENCAP = 0
      IF (ID.EQ.3) THEN
C SET THE ITEKFG IF REQUIRED
        ITEKFG = NCOMMD(INCNT)
        IF (ITEKFG.LT.1 .OR.ITEKFG.GT.2) ITEKFG = 1
      ELSE
        ITEKFG = 0
      ENDIF
C FIRST WE NEED TO SHUT DOWN THE OLD DEVICE IF REQUIRED.
      IF ((ID.EQ.2).OR.(ID.EQ.3).OR.(ID.EQ.5) .OR. (ID.EQ.8)
     c  .OR. (ID.EQ.11) ) THEN
        IF (ISCRN.EQ.1 .OR. ISCRN .EQ. 7) THEN
          CALL ZTXTMD
        ELSE IF (ISCRN.NE.-1) THEN
          CALL ZCLEAR
        ENDIF
      ENDIF
C LOAD IN THE DEVICE INFO
      ILSIZE = 10
cric99: Device.cmn removed. Parameters stored in CAMPRE in CAMDEV
c      IF (.NOT.LFILES (-1,'DEVICE.CMN',IINPT)) THEN
c        CALL ZTXTMD
c        CALL ZMORE('Error - file DEVICE.CMN cannot be found.',0)
c        CALL ZMORE('CAMERON cannot continue',0)
cC cljf
c        CALL ZMORE1('Error - file DEVICE.CMN cannot be found.',0)
c        STOP
c      ENDIF

c nb ID of 2 corresponds to the first item (VGA).
 
C      DO 1110 I = 1,(ID-2)*2+12
C        READ (IINPT,'(80X)')
C1110  CONTINUE
C LOAD IN THE SCREEN/HARDCOPY PARAMETERS
      IF ((ID.EQ.2).OR.(ID.EQ.3).OR.(ID.EQ.5).OR.(ID.EQ.8)
     c .OR. (ID.EQ.11) ) THEN

C        READ (IINPT,1111) XCENS,YCENS,SCLIMS,IBACKS,IFORES,ILABCS,
C     c IBNDCS,ICLDES

        KID = ID - 2
        XCENS = RCAMDV ( KID * 3 + 1 )
        YCENS = RCAMDV ( KID * 3 + 2 )
        SCLIMS= RCAMDV ( KID * 3 + 3 ) 
        IBACKS= ICAMDV ( KID * 5 + 1 )
        IFORES= ICAMDV ( KID * 5 + 2 )
        ILABCS= ICAMDV ( KID * 5 + 3 )
        IBNDCS= ICAMDV ( KID * 5 + 4 )
        ICLDES= ICAMDV ( KID * 5 + 5 )

        DO I = 1,16
            IDEVCS(I) = JCAMDV ( KID * 16 + I )
        END DO

C        READ (IINPT,1112) IDEVCS
        ICELLC = IBNDCS
        IF (XCENS.LT.YCENS) THEN
          ISCALS = XCENS
        ELSE
          ISCALS = YCENS
        ENDIF
        IF (ID.EQ.11) THEN
          ISVGA = 1
          ID = 2
        ENDIF
        IDEV = ID - 1
C COPY OVER THE DEFAULT BOND COLOUR
        IBNDCL = IBNDCS
      ELSE
        KID = ID - 2
        XCENH = RCAMDV ( KID * 3 + 1 )
        YCENH = RCAMDV ( KID * 3 + 2 ) 
        SCLIMH= RCAMDV ( KID * 3 + 3 ) 
        IBACKH= ICAMDV ( KID * 5 + 1 )
        IFOREH= ICAMDV ( KID * 5 + 2 )
        ILABCH= ICAMDV ( KID * 5 + 3 )
        IBNDCH= ICAMDV ( KID * 5 + 4 )
        ICLDEH= ICAMDV ( KID * 5 + 5 )
        DO I = 1,16
            IDEVCH(I) = JCAMDV ( KID * 16 + I )
        END DO

C        READ (IINPT,1111) XCENH,YCENH,SCLIMH,IBACKH,IFOREH,ILABCH,
C     c IBNDCH,ICLDEH
C        READ (IINPT,1112) IDEVCH


        ICELLC = IBNDCH
        IF (XCENH.LT.YCENH) THEN
          ISCALH = XCENH
        ELSE
          ISCALH = YCENH
        ENDIF
C SET THE POSTSCRIPT FLAGS IF APPRPROPRIATE
        IF (ID.EQ.9 .OR. ID.EQ.10) ICPOST = 1
        IF (ID.EQ.7 .OR. ID.EQ.10) IENCAP = 1
C SET THE POSTSCRIPT DEVICES TO BE A SINGLE DEVICE
        IF (ID.EQ.7 .OR. ID.EQ.9 .OR. ID .EQ. 10) ID = 6
        IHARD = ID - 1
      ENDIF
C CLEAR THE SCREEN
      IF (ID-1.EQ.IDEV) THEN
        CALL ZCLEAR
        XCEN = XCENS
        YCEN = YCENS
        SCLLIM = SCLIMS
      ENDIF
C1111  FORMAT (5X,3F8.1,5I4)
C1112  FORMAT (16(I2,2X))
C      IF (.NOT.LFILES (0,' ',IINPT)) THEN
C        CALL ZMORE('Error on closing DEVICE.CMN file.',0)
C      ENDIF
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD12 [ COMMAND GROUP 1200 - SYMMETRY INPUT ]
      SUBROUTINE ZCMD12 (ID)
      
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

      REAL SYMM(4,4),TRAN(11),STRAN(8)
C DIMENSION VARIABLES FOR USE IN THE SPACEGROUP THINGS
      REAL SPG(10),RT(5,4,25)
      REAL CEN(3,4),VTRAN(3)
      REAL VCENT(9,6)
      REAL VNUM(6)
C JRT REDIMENSIONED HERE!
      INTEGER JRT(3,4,25)
      CHARACTER*80 SNAME,STEMP
      CHARACTER*1 ANS
      DATA TRAN /0.0,0.0,0.166666667,0.25,0.33333333,0.0,0.5,0.0,
     c 0.666666667,0.75,0.83333333/
      DATA STRAN /0.0,0.5,0.3333333,0.25,0.67777777777,0.75,0.166666667,
     c 0.83333333/
C PRIMITIVE
      DATA VCENT /0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
C BODY CENTRED
     +            0.5,0.5,0.5,0.0,0.0,0.0,0.0,0.0,0.0,
C A CENTRED
     +            0.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
C B CENTRED
     +            0.0,0.5,0.0,0.0,0.0,0.0,0.0,0.0,0.0,
C CENTRED
     +            0.0,0.0,0.5,0.0,0.0,0.0,0.0,0.0,0.0,
C FACE CENTRED
     +            0.5,0.0,0.0,0.0,0.5,0.0,0.0,0.0,0.5/
      DATA VNUM/0,1,1,1,1,3/
      ID = ID - (ID/100)*100 + 1
      GOTO (1200,1201,111,1203,1204,1205,1206,1207,1208,1209,1210,
     c 1211,1212,1213,1214,111,1216,1217) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
111   CONTINUE
      GOTO 9999
1200  CONTINUE
C SYMMETRY
C DUMMY HEADER
      GOTO 9999
1201  CONTINUE
C COLLECT
      IF ((ICOMMD(ICNT+1)-ICOMMD(ICNT))/ISCOM.NE.8) THEN
        CALL ZCOLL
      ENDIF
      GOTO 9999
1203  CONTINUE
C CENTRE
C THIS INVERTS THE OPERATORS STORED BY COMMAND 1205
C CHECK FOR ROOM
      NROOM = NSYMM * 2 * 16
      IRM = LROOM ( IRLAST , ITOT , NROOM )
      IF (IRM.EQ.-1) THEN
        CALL ZMORE( 'Not enough room to store inverted operators',0)
        IPROC = 0
        RETURN
      ENDIF
      DO 30 I = 1 , NSYMM
        CALL ZMOVE (RSTORE(ITOT-I*16), SYMM , 16)
C INVERT THE ROTATION PART OF THE OPERATOR
        DO 40 J = 1 , 3
          DO 50 K = 1,3
            SYMM(J,K) = -SYMM(J,K)
50        CONTINUE
40      CONTINUE
C STORE THE INVERTED OPERATOR
        CALL ZMOVE (SYMM, RSTORE(ITOT-NSYMM*16-I*16) , 16)
30    CONTINUE
      NSYMM = NSYMM * 2
      ISYMED = ITOT - NSYMM * 16 - 1
C CALL THE CENTERING ROUTINE
      IF (ICC.EQ.1) GOTO 1218
      INXT = LNCHCK (1200)
      IF ((INXT.EQ.-1).AND.(IFVIEW.GT.ISVIEW)) CALL ZDOCON (0,0,0)
      GOTO 9999
1204  CONTINUE
      IF (ICC.EQ.1) GOTO 1218
      INXT = LNCHCK (1200)
      IF ((INXT.EQ.-1).AND.(IFVIEW.GT.ISVIEW)) CALL ZDOCON (0,0,0)
      GOTO 9999
1205  CONTINUE
C OPERATORS
      IF (NSYMM.GT.0) THEN
        CALL ZMORE(
     +'Warning! This will overwrite current symmetry operators.',0)
        CALL ZMORE('Do you want to continue? (Y/N)',0)
         READ (ISTOUT,'(A)') ANS
         IF (ANS.NE.'y' .AND. ANS .NE. 'Y') THEN
           IPROC = 0
           RETURN
        ENDIF
      ENDIF
      ISYMED = ITOT
      IREND = ITOT
      NSYMM = 0
      DO 10 I = ICCNT , ICCNT + ICC - 1 , 3
        CALL ZZEROF (SYMM,16)
        SYMM(4,4) = 1.0
        DO 20 J = 1 , 3
C UNPICK THE NUMBER IN ICCMMD
C SEE THE DESCRIPTION IN ZCISCH FOR THE EXPLANATION OF THE NUMBERS USED
          ISYMNO = ICCMMD(I+J-1)
          IPREVS = 0
          DO 77 II = 1 , 6
            IMOD = MOD(ISYMNO,10)
            ISYMNO = ISYMNO / 10
            IF (IMOD.EQ.0) GOTO 77
C WHAT SIGNIFICANCE DOES THIS HAVE
            IF (II.EQ.1.OR.II.EQ.4) THEN
C TRANSLATION
              SYMM(J,4) = STRAN(IMOD)
            ELSE IF (II.EQ.2.OR.II.EQ.5) THEN
              SYMM(J,IMOD) = 1.0
              IPREVS = IMOD
            ELSE IF (II.EQ.3.OR.II.EQ.6) THEN
              IF (IPREVS.EQ.0) THEN
                SYMM(J,4) = -SYMM(J,4)
              ELSE
                SYMM(J,IPREVS) = -SYMM(J,IPREVS)
              ENDIF
            ENDIF
77        CONTINUE
20      CONTINUE
C CHECK FOR ROOM
        NROOM = ICC * 16 / 3
        IRM = LROOM ( IRLAST , ITOT , NROOM)
        IF (IRM.EQ.-1) THEN
          CALL ZMORE( 'No room to input operators!',0)
          IPROC = 0
          RETURN
        ENDIF
C STORE THE OPERATOR
        CALL ZMOVE (SYMM, RSTORE (ITOT- ((I-ICCNT)/3+1)*16) , 16)
10    CONTINUE
      NSYMM = ICC/3
      ISYMED = ITOT - NSYMM*16 - 1
      INXT = LNCHCK (1200)
      IF ((INXT.EQ.-1).AND.(IFVIEW.GT.ISVIEW)) CALL ZDOCON (0,0,0)
      GOTO 9999
1206  CONTINUE
C SPACEGROUP
C GET THE NAME OF THE SPACEGROUP
      K = 0
      DO 150 I = 1 , ICC
C GET THE NEXT PART OF THE NAME
        IF (K.EQ.0) THEN
          SNAME = CTCOMD (ITCNT)
        ELSE
          STEMP = SNAME
          SNAME = STEMP (1:K)//CTCOMD (ITCNT)
        ENDIF
        ITCNT = ITCNT + 1
C WE MUST UPDATE ITCNT HERE BECAUSE ICCNT WILL BE UPDATED OUTSIDE THIS
C ROUTINE BUT NOT ITCNT.
C FIND THE END OF THE WORD
        KK = 0
        DO 160 J = 80 , K+1 , -1
          IF ((SNAME(J:J).NE.' ').AND.(KK.EQ.0)) KK = J + 1
160      CONTINUE
        K = KK
150    CONTINUE
C PUT NAME INTO SPG
      READ (SNAME ,'(10A1)') ( SPG(J),J=1,10 )
      CALL YGROUP (SPG,LAUENO,NAXIS,NCENT,LCENT,NSYMM,NPOL,
     c JRT,CEN,NCV,ISTOUT,NCWU,RT,IER)
C THESE THREE VARIABLES ARE RE-SET BECAUSE THEY ARE USED IN DIFFERENT
C CONTEXT IN YGROUP TO THE NORMAL CAMERON USAGE.
      IR = 0
      IN = 0
      IC = 0
      IF (IER.NE.0) THEN
C ERROR!
        CALL ZMORE(
     c 'All commands after and including SPACEGROUP have been lost.',0)
        IPROC = 0
C ALTERING IPROC HERE CAUSES AN ABANDON TO HAPPEN WHEN RETURNING TO
C XINPUT.
        RETURN
      ENDIF
C WORK OUT HOW MUCH SPACE WE NEED.
      NROOM = 16 * NSYMM * (NCENT+1) * NCV
      IRM = LROOM ( IRLAST , ITOT , NROOM )
      IF (IRM.LT.0) THEN
        CALL ZMORE(
     C  'Cannot load in symmetry operators - no room in RSTORE.',0)
        IPROC = 0
        RETURN
      ENDIF
C MOVE DOWN THE CONNECTIVITY INFORMATION IF IT IS PRESENT TOGETHER
C WITH THE GROUP INFORMATION
C      IF (ICONED.NE.ICONBG) THEN
C        CALL ZMOVE (RSTORE(ICONED),RSTORE(ICONED-NROOM-IGMAX),
C     +  ICONBG-ICONED+IGMAX)
C        ICONED = ICONED - NROOM - IGMAX
C        ICONBG = ICONBG - NROOM - IGMAX
C        DO 171 I = ISINIT , IFVIEW-1 , IPACKT
C          RSTORE(I+IBOND) = RSTORE(I+IBOND) - NROOM - IGMAX
C171     CONTINUE
C      ELSE
C        CALL ZMOVE(RSTORE(ITOT-IGMAX),RSTORE(ITOT-NROOM-IGMAX),IGMAX)
C      ENDIF
C WORK OUT THE OPERATORS
      CALL ZDOOPS(JRT,CEN,NCV,TRAN,NCENT)
      NSYMM = NSYMM * (NCENT+1) * NCV
      ISYMED = ITOT - NSYMM*16 - 1
      IREND = ISYMED - IGMAX
      IF (ISVIEW.GT.0) CALL ZDOCON(0,0,0)
      GOTO 9999
1207  CONTINUE
C CENTRING VECTORS
C CHECK FOR ROOM
      NROOM = NSYMM * 16 * ICC / 3
      IRM = LROOM ( IRLAST , ITOT , NROOM)
      IF (IRM.EQ.-1) THEN
        IPROC = 0
        CALL ZMORE( 'Not enough room to apply centering vectors',0)
        RETURN
      ENDIF
      IPLACE = 0
      DO 60 I = ICCNT , ICCNT + ICC - 1 , 3
C GET THE VECTOR
        IV = 0
        DO 70 J = 1 , 3
          VTRAN(J) = STRAN (ABS (ICCMMD (I+J-1) ) )
          IF (ICCMMD(I).LT.0.0) VTRAN(J) = -VTRAN(J)
          IF (ABS(VTRAN(J)).GT.0.0) IV = 1
70      CONTINUE
C IV WILL NOT HAVE BEEN SET IF THIS IS THE ZERO VECTOR - DONT APPLY IT.
        IF (IV.EQ.0) GOTO 60
C THIS IS INTRODUCED BECAUSE IF WE HAVE A 0 0 0 VECTOR WE MUST NOT LEAVE
C SPACE FOR IT IN THE ARRAY.
        IPLACE = IPLACE + 1
        DO 80 J = 1 , NSYMM
C GET THE OPERATOR
          CALL ZMOVE (RSTORE(ITOT-J*16),SYMM,16)
C APPLY THE CENTRING VECTOR
          DO 90 K = 1 , 3
            SYMM (K,4) = VTRAN(K) + SYMM (K,4)
90        CONTINUE
C STORE THE NEW OPERATOR
          CALL ZMOVE ( SYMM ,
     c    RSTORE (ITOT-NSYMM*16- (IPLACE-1)*NSYMM*16 - J*16) , 16)
80      CONTINUE
60    CONTINUE
        NSYMM = NSYMM * (IPLACE+1)
      ISYMED = ITOT - NSYMM * 16 - 1
      GOTO 9999
1218  CONTINUE
C CENTRING LETTERS
C CHECK FOR ROOM
      IV = ICCMMD(ICCNT)
      NROOM = NSYMM * 16 *  IV
      IRM = LROOM ( IRLAST , ITOT , NROOM)
      IF (IRM.EQ.-1) THEN
        IPROC = 0
        CALL ZMORE('Not enough room to apply centering vectors',0)
        RETURN
      ENDIF
      IPLACE = 0
      DO 12180 I = 1 , VNUM(IV)
C GET THE VECTOR
        DO 12181 J = 1 , 3
          VTRAN(J) = VCENT((I-1)*3+J,IV)
12181   CONTINUE
        IPLACE = IPLACE + 1
        DO 12182 J = 1 , NSYMM
C GET THE OPERATOR
          CALL ZMOVE (RSTORE(ITOT-J*16),SYMM,16)
C APPLY THE CENTRING VECTOR
          DO 12183 K = 1 , 3
            SYMM (K,4) = VTRAN(K) + SYMM (K,4)
12183     CONTINUE
C STORE THE NEW OPERATOR
          CALL ZMOVE ( SYMM ,
     c    RSTORE (ITOT-NSYMM*16- (IPLACE-1)*NSYMM*16 - J*16) , 16)
12182   CONTINUE
12180 CONTINUE
      NSYMM = NSYMM * (IPLACE+1)
      ISYMED = ITOT - NSYMM * 16 - 1
      INXT = LNCHCK (1200)
      IF ((INXT.EQ.-1).AND.(IFVIEW.GT.ISVIEW)) CALL ZDOCON (0,0,0)
      GOTO 9999
1208  CONTINUE
C TOLERANCE FOR COLLECT
      COLTOL = RCOMMD(IRCNT)
      CALL ZCOLL
      GOTO 9999
1209  CONTINUE
C SET UNIT
C SET UNIT
      WRITE (CLINE,'(2A)')
     c'This command replaces the initial input data with the atoms '
      CALL ZMORE(CLINE,0)
      WRITE (CLINE,'(2A)')
     c'currently on the screen.  These are then treated as the '
      CALL ZMORE(CLINE,0)
      WRITE (CLINE,'(2A)')
     c'asymmetric unit.'
      CALL ZMORE(CLINE,0)
cdjwfeb2000      READ (5,'(A)') ANS
c      READ (5,'(A)') ANS
c      IF ((ANS.NE.'Y').AND.(ANS.NE.'y')) THEN
c        IPROC = 0
c        CALL ZMORE(
c     c'All commands after and including SETUNIT have been lost.',0)
c        RETURN
c      ENDIF
C MOVE THE ATOMS IN THE CURRENT VIEW INTO THE ISINIT PLACE IN RSTORE.
      IPLACE = ISINIT
      LL = (IPLACE - IRATOM)/IPACKT + ICATOM
      DO 12090 I = ISVIEW, IFVIEW-1 , IPACKT
        IF ((RSTORE(I+IPCK+1).LT.0.0).AND.(NINT(RSTORE(I)).NE.5))
     c  GOTO 12090
C DO NOT MOVE IF EXCLUDED (UNLESS ITS A CELL CORNER)
        IF (I.NE.IPLACE) THEN
C DO NOT MOVE IF IT IS ALREADY IN THE RIGHT PLACE.
          CALL ZMOVE (RSTORE(I),RSTORE(IPLACE),IPACKT)
C MOVE OVER THE ATOM LABEL
          MM = (I - IRATOM)/IPACKT + ICATOM
          CSTORE(LL) = CSTORE(MM)
        ENDIF
        IPLACE = IPLACE + IPACKT
        LL = LL + 1
12090 CONTINUE
      IFINIT = IPLACE
      IRLAST = IFINIT
      ISVIEW = ISINIT
      IFVIEW = IFINIT
C DO THE SPECIAL POSITIONS CALC
      IPACK = 0
      IENCL = 0
C      CALL ZSPECL (2)
C CALCULATE THE CONNECTIVITY AGAIN
      CALL ZDOCON (0,0,0)
      GOTO 9999
1210  CONTINUE
C USE
      DO 12100 I =  INCNT, INCNT+ICN-1
         N = NCOMMD(I)-1
         RSTORE(ITOT-N*16-1) = ABS(RSTORE(ITOT-N*16-1))
12100 CONTINUE
      GOTO 9999
1211  CONTINUE
C USE ALL
      DO 12110 I = 0 , NSYMM-1
        RSTORE(ITOT-I*16-1) = ABS(RSTORE(ITOT-I*16-1))
12110 CONTINUE
      GOTO 9999
1212  CONTINUE
C NOUSE
      DO 12120 I = INCNT, INCNT+ICN-1
        N = NCOMMD(I) - 1
        RSTORE(ITOT-N*16-1) = -ABS(RSTORE(ITOT-N*16-1))
12120 CONTINUE
      GOTO 9999
1213  CONTINUE
C NOUSE ALL
      DO 12130 I = 0 , NSYMM-1
        RSTORE(ITOT-I*16-1) = -ABS(RSTORE(ITOT-I*16-1))
12130 CONTINUE
      GOTO 9999
1214  CONTINUE
C ENANTIO
      DO 12140 I = ISINIT + IPACKT*8 , IFVIEW-1 , IPACKT
        DO 12141 J = 1 , 3
          RSTORE(I+J) = -RSTORE(I+J)
12141   CONTINUE
12140 CONTINUE
      CALL ZATMUL (0,0,0)
      GOTO 9999
1216  CONTINUE
C SPECIAL ON
      ISPECL = 1
      GOTO 9999
1217  CONTINUE
C SPECIAL OFF
      ISPECL = 0
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD13 [ 1300 GROUP COLOUR ]
      SUBROUTINE ZCMD13 (ID)
      
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

      INTEGER IREG
C This routine controls the colour changes.
      ID = ID - (ID/100)*100 + 1
      GOTO (1300,1301,1302,1303,1304,1333,1306,1307,1308,1309,1310
     c ,1311,1312,1313,1314,1315,1316,1317) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
1333  CONTINUE
      GOTO 9999
1300  CONTINUE
C COLOUR
      DO 10 I = ICCNT , ICCNT + ICC - 1 , 2
        N = ICCMMD(I)
        IMULT = ICMULT (I)
        ICCOL = ICCMMD(I+1)
        CALL ZPARAM (N,IATTYP+1,REAL(ICCOL),1,IMULT)
C IF THIS IS AN ELEMENT WE NEED TO CHANGE THE KEY
        IF (ICCMMD(I).LT.ICATOM) THEN
          M = ICCMMD(I) - ICELM + 1
C FIND THE ELEMENT TYPE IN THE COLOUR KEY
          DO 20 J = 1 , NKEY
            IF (NINT(RSTORE(IKEY+(J-1)*2)).EQ.M)
     c      THEN
              RSTORE(IKEY+J*2-1) = ICCOL
            ENDIF
20        CONTINUE
        ENDIF
10    CONTINUE
      GOTO 9999
1301  CONTINUE
C CELL
      ICELLC = ICCMMD(ICCNT)
      DO 13010 I = 1 , 8
C GET THE INFO POSITION
        NBNDST = NINT(RSTORE(ISVIEW+(I-1)*IPACKT+IBOND))
        NBONDS = NINT(RSTORE(ISVIEW+(I-1)*IPACKT+IBOND+1))
        DO 13011 J = NBNDST , NBNDST - (NBONDS-1)*2 , -2
          N = NINT(RSTORE(J-1))
          CALL ZBNUM ( N,1,ICELLC)
          RSTORE(J-1) = N
13011   CONTINUE
13010 CONTINUE
      GOTO 9999
1302  CONTINUE
C LABEL COLOUR
      ILABCL = ICCMMD ( ICCNT )
      GOTO 9999
1303  CONTINUE
C BOND COLOUR
C GET THE BOND IDENTIFIERS
      IF (ICC.EQ.0) GOTO 9999
      DO 13030 I = ICCNT , ICCNT + ICC - 1 , 3
        N = ICCMMD(I)
        IMULTN = ICMULT(I)
        M = ICCMMD(I+1)
        IMULTM = ICMULT(I+1)
        IBCOL = ICCMMD (I+2)
        CALL ZBNDCK (N,IMULTN,M,IMULTM,IBCOL,1,IJN,0)
13030 CONTINUE
      GOTO 9999
1304  CONTINUE
C ALL
      IBCOL = ICCMMD (ICCNT)
      DO 13040 I = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
C FIND THE START OF THE CONNECTIVITY INFO
        IBNDST = NINT (RSTORE (I+IBOND))
        NBONDS = NINT (RSTORE (I+IBOND+1))
        DO 13041 J = IBNDST, IBNDST-NBONDS*2+2 , -2
          N = NINT (RSTORE(J-1))
          CALL ZBNUM (N,1,IBCOL)
          RSTORE(J-1) = N
13041   CONTINUE
13040 CONTINUE
C RESET THE BOND COLOUR
      IBNDCL = IBCOL
      IBNDCS = IBCOL
      IBNDCH = IBCOL
      GOTO 9999
1306  CONTINUE
C GROUP
C MAKE A LIST OF MEMBERS OF THE GROUP.
C CHECK THAT THERE IS SPACE
      NROOM = ICC * ( ISVIEW - IFVIEW ) / IPACKT
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.EQ.-1) THEN
        IPROC = 0
        CALL ZMORE('No room to do COLOUR BONDS GROUP.',0)
        CALL ZMORE1('No room to do COLOUR BONDS GROUP.',0)
        RETURN
      ENDIF
      DO 13000 II = ICCNT , ICCNT + ICC - 1 , 2
        ICOL = ICCMMD (II + 1)
        IGG = ICCMMD (II)
        INGROP = 0
        DO 13060 I = ISVIEW + IPACKT*8 , IFVIEW-1 , IPACKT
          DO 13061 J = I+IATTYP+6 , I+IATTYP+9
            IF (NINT(RSTORE(J)).EQ.IGG) THEN
              RSTORE(IRLAST+INGROP) = I
              INGROP = INGROP + 1
              GOTO 13060
            ENDIF
13061     CONTINUE
13060   CONTINUE
C NOW WE HAVE A LIST - LOOP OVER IT
C STORE THE OLD VALUE OF IRLAST
        IRLOLD = IRLAST
        IRLAST = IRLAST + INGROP
        DO 13062 I = IRLOLD , IRLOLD + INGROP - 1
          DO 13063 J = IRLOLD , IRLOLD + INGROP - 1
          IF (I.EQ.J) GOTO 13063
C ALTER THE BONDS - IF THEY EXIST
            N1 = NINT(RSTORE(I))
            N2 = NINT(RSTORE(J))
            CALL ZBNDCK (N1,0,N2,0,ICOL,1,IJN,1)
13063     CONTINUE
13062   CONTINUE
        IRLAST = IRLOLD
13000 CONTINUE
      GOTO 9999
1307  CONTINUE
C COLOUR GROUP
      DO 13070 I = ICCNT , ICCNT + ICC - 1 , 2
        ICOL = ICCMMD ( I+ 1)
        IGG = ICCMMD (I)
C LOOP TO FIND ATOMS IN THIS GROUP
C        DO 13071 J = ISVIEW, IFVIEW-1 , IPACKT
C          DO 13072 K = J+IATTYP+6,J+IATTYP+9
C            IF (NINT(RSTORE(K)).EQ.IGG) THEN
C              RSTORE(J+IATTYP+1) = ICOL
C              GOTO 13071
C            ENDIF
C13072     CONTINUE
C13071   CONTINUE
        CALL ZMODGP (IGG,IATTYP+1,REAL(ICOL))
13070 CONTINUE
      GOTO 9999
1308  CONTINUE
C NORMAL
      ITCOL = 1
      CALL ZSTCOL
      GOTO 9999
1309  CONTINUE
C GREYSCALE
      ITCOL = 2
      CALL ZSTCOL
      GOTO 9999
1310  CONTINUE
C NB THIS OPTION REMOVED
C SET
      IREG = ICCMMD(ICCNT) + 1
      IF (ITCOL.EQ.1) THEN
        ICOLS(1,IREG) = NCOMMD(INCNT+1)
        ICOLS(2,IREG) = NCOMMD(INCNT+2)
        ICOLS(3,IREG) = NCOMMD(INCNT+3)
      ENDIF
      CALL ZSTCOL
      GOTO 9999
1311  CONTINUE
C DEFAULT
C NB THIS OPTION REMOVED
C COPY IVGACL INTO ICOLS
      DO 13110 I = 1 , 16
        DO 13111 J = 1 , 3
          ICOLS(J,I) = IVGACL(J,I)
13111      CONTINUE
13110   CONTINUE
      ITCOL = 1
      CALL ZSTCOL
      GOTO 9999
1312  CONTINUE
C COLOUR FRAGMENT
      DO 13120 I = ICCNT , ICCNT+ICC-1 , 2
        N = (ICCMMD(I)-ICATOM)*IPACKT+IRATOM
        ICOL = ICCMMD(I+1)
        CALL ZFRAG (N,IATTYP+1,REAL(ICOL),1)
13120 CONTINUE
      GOTO 9999
1313  CONTINUE
C COLOUR DEFAULT
      DO 13130 I = ISINIT , IFVIEW-1 , IPACKT
        IF (NINT(RSTORE(I)).GT.3) GOTO 13130
        RSTORE(I+IATTYP+1) =
     +  RSTORE(NINT(IRELM+(RSTORE(I+IATTYP)-1)*4.0) + 3)
13130 CONTINUE
      GOTO 9999
1314  CONTINUE
C BACKGROUND
      IBACK = ICCMMD(ICCNT)
      IBACKS = IBACK
      IF (IBACK.EQ.ILABCL) THEN
        IF (IBACK.EQ.0) THEN
          ILABCL = ICLMAX-1
        ELSE IF (IBACK.EQ.ICLMAX-1) THEN
          ILABCL = 0
        ELSE
          ILABCL = ILABCL + 1
        ENDIF
      ENDIF
      ILABCS = ILABCL
      GOTO 9999
1315  CONTINUE
C MENU TEXT COLOUR
      IBTEXT = ICCMMD ( ICCNT )
      GOTO 9999
1316  CONTINUE
C MENU BUTTON COLOUR
      IBBACK = ICCMMD (ICCNT)
      GOTO 9999
1317  continue
c all - get the colour for all atoms
      WRITE (CLINE,'(A)') ' Colour all atoms'
      CALL ZMORE(CLINE,0)
      iallat = iccmmd(iccnt)
      n = -1
      imult = 0
      call zparam (n,iattyp+1,real(iallat),1,imult)
c change all elements in the colour key
          do 13171 j = 1 , nkey
              rstore(ikey+j*2-1) = iallat
13171     continue
c
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD14 [ 1400 GROUP INCLUDE/EXCLUDE]
      SUBROUTINE ZCMD14 (ID)
      
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

      CHARACTER*(ILEN) LABEL
      INTEGER IXAR(1000),IYAR(1000)
      REAL CAR(1000),MAR(1000)
C This routine carries out the include/exclude commands.
C IEXFLG = 1 include
C IEXFLG = -1 exclude
C IEXFLG = -2 mask
C IEXFLG =  1 unmask
      REAL XCENTR(3)
      ID = ID - (ID/100)*100 + 1
      GOTO (1400,1401,1402,1403,1404,1400,1401,1402,1403,1409,
     c      1410,1411,1400,1401,1402,1400,1401,1402,1418,1419,
     c      1420,1420,1422,9999) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
1400  CONTINUE
C INCLUDE/EXCLUDE
      IF (ID.EQ.1) IEXFLG = 1
      IF (ID.EQ.6) IEXFLG = -1
      IF (ID.EQ.13) IEXFLG = -2
      IF (ID.EQ.16) IEXFLG = 2
C LOOP OVER ATOMS
      IVCHAN = 1
      DO 10 I = ICCNT,ICCNT+ICC-1
        N = ICCMMD(I)
        IMULT = ICMULT(I)
C N IS THE NUMBER OF THE ATOM IN THE RSTORE ARRAY
        IF (N.EQ.0) THEN
C *_N
          DO 12 J = ISVIEW + IPACKT*8 , IFVIEW-1, IPACKT
            IF (NINT(RSTORE(J+IPCK)).NE.IMULT-1) GOTO 12
            M = NINT(RSTORE(J+IPCK+1))
            IF ((M.EQ.-2).AND.(IEXFLG.NE.2)) GOTO 12
            IF (IEXFLG.EQ.2) THEN
              RSTORE(J+IPCK+1) = 1.0
            ELSE
              RSTORE(J+IPCK+1) = IEXFLG
            ENDIF
12        CONTINUE
        ELSE IF (N.EQ.-1) THEN
          DO 13 J = ISVIEW + IPACKT*8 , IFVIEW-1, IPACKT
            M = NINT(RSTORE(J+IPCK+1))
            IF (M.EQ.-2.AND.IEXFLG.NE.2) GOTO 13
            IF (IEXFLG.EQ.2) THEN
              RSTORE(J+IPCK+1) = 1.0
            ELSE
              RSTORE(J+IPCK+1) = IEXFLG
            ENDIF
13        CONTINUE
        ELSE IF (ICCMMD(I).LT.ICATOM) THEN
C WE HAVE AN ELEMENT - NEED TO LOOP OVER ALL THESE ATOMS IN THE ARRAY
          N = ICCMMD(I) - ICELM + 1
         DO 20 J = ISVIEW + IPACKT*8,IFVIEW-1,IPACKT
           IF (NINT(RSTORE(J+IATTYP)).EQ.N) THEN
             IF ((IMULT.EQ.0).OR.(IMULT-1.EQ.NINT(RSTORE(J+IPCK))))
     c       THEN
C YES THIS ELEMENT AGREES
C WE NEED TO CHECK FOR MASK
               M = NINT(RSTORE(J+IPCK+1))
               IF ((M.EQ.-2).AND.(IEXFLG.NE.2)) GOTO 20
               IF (IEXFLG.EQ.2) THEN
                 RSTORE(J+IPCK+1) = 1.0
               ELSE
                 RSTORE(J+IPCK+1) = IEXFLG
               ENDIF
             ENDIF
           ENDIF
20        CONTINUE
        ELSE
          IF (IMULT.EQ.1) THEN
            DO 21 J = 0 , IPACK
              CALL ZGTATM ( N , J , IPOS)
              IF (IPOS.EQ.-1) GOTO 21
              M = NINT(RSTORE(IPOS+IPCK+1))
              IF ((M.EQ.-2).AND.(IEXFLG.NE.2)) GOTO 21
              IF (IEXFLG.EQ.2) THEN
                RSTORE(IPOS+IPCK+1) = 1.0
              ELSE
                RSTORE(IPOS+IPCK+1) = IEXFLG
              ENDIF
21          CONTINUE
          ELSE
            N = ISINIT + (ICCMMD(I)-ICATOM)*IPACKT
            M = NINT(RSTORE(N+IPCK+1))
            IF ((M.EQ.-2).AND.(IEXFLG.NE.2)) GOTO 10
            IF (IEXFLG.EQ.2) THEN
              RSTORE(N+IPCK+1) = 1.0
            ELSE
              RSTORE(N+IPCK+1) = IEXFLG
            ENDIF
          ENDIF
        ENDIF
10    CONTINUE
      GOTO 9999
1401  CONTINUE
C THIS IS THE ALL COMMAND
      DO 30 I = ISVIEW + IPACKT*8 ,IFVIEW,IPACKT
        M = NINT(RSTORE(I+IPCK+1))
        IF ((M.EQ.-2).AND.(IEXFLG.NE.2)) GOTO 30
        IF (IEXFLG.EQ.2) THEN
          RSTORE(I+IPCK+1) = 1.0
        ELSE
          RSTORE(I+IPCK+1) = IEXFLG
        ENDIF
30    CONTINUE
      GOTO 9999
1402  CONTINUE
C GROUP
      DO 34 K = ICCNT , ICCNT+ICC - 1
        IG = ICCMMD(K)
C LOOP OVER THE GROUP
        DO 40 I = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
C CHECK FOR MASK/UNMASK
          M = NINT(RSTORE(I+IPCK+1))
          IF ((M.EQ.-2).AND.(IEXFLG.NE.2)) GOTO 40
          DO 50 J = I+IATTYP+6,I+IATTYP+9
            IF (NINT(RSTORE(J)).EQ.IG) THEN
              IF (IEXFLG.EQ.2) THEN
                RSTORE(I+IPCK+1) = 1.0
              ELSE
                RSTORE(I+IPCK+1) = IEXFLG
              ENDIF
              GOTO 40
            ENDIF
50        CONTINUE
40      CONTINUE
34    CONTINUE
      GOTO 9999
1403  CONTINUE
C INCLUDE/EXCLUDE CELL
      DO 14030 I = ISVIEW , ISVIEW + IPACKT*7 , IPACKT
        RSTORE(I+IPCK+1) = IEXFLG
14030 CONTINUE
      GOTO 9999
1404  CONTINUE
C DUMMY ATOM
      LABEL = CTCOMD(ITCNT)(1:ILEN)
      CALL ZUPCAS (LABEL)
      ITCNT = ITCNT + 1
C SET THE FLAGS TO ZERO
      DO 14040 I = IFVIEW , IFVIEW + IPACKT - 1
        RSTORE (I) = 0.0
14040 CONTINUE
      RSTORE(IFVIEW) = 4.0
C STORE THE LABEL
      KL = (IFVIEW-IRATOM)/IPACKT+ICATOM
      CSTORE(KL) = LABEL
      ICLAST = ICLAST + 1
      GOTO 9999
1409  CONTINUE
C COORDS
      DO 14090 I = 1, 3
        RSTORE(IFVIEW+I) = RCOMMD(IRCNT+I-1)
14090 CONTINUE
      IFVIEW = IFVIEW + IPACKT
      IF (ISINIT.EQ.ISVIEW) IFINIT = IFVIEW
      IRLAST = IFVIEW
      GOTO 9999
1410  CONTINUE
C CENTROID
      IF (ICC.EQ.0) GOTO 9999
      CALL ZZEROF (XCENTR,3)
      NCENTR = 0
      DO 14100 I = ICCNT,ICCNT+ICC-1
        IMULT = ICMULT(I)
C N IS THE NUMBER OF THE ATOM IN THE RSTORE ARRAY
        IF (ICCMMD(I).EQ.0) THEN
          DO 14104 J = ISVIEW + IPACKT*8 , IFVIEW-1 , IPACKT
            IF (NINT(RSTORE(J+IPCK)).NE.IMULT-1) GOTO 14104
            XCENTR(1) = XCENTR(1) + RSTORE(J+1)
            XCENTR(2) = XCENTR(2) + RSTORE(J+2)
            XCENTR(3) = XCENTR(3) + RSTORE(J+3)
            NCENTR = NCENTR + 1
14104     CONTINUE
        ELSE IF (ICCMMD(I).LT.ICATOM) THEN
C WE HAVE AN ELEMENT - NEED TO LOOP OVER ALL THESE ATOMS IN THE ARRAY
          N = ICCMMD(I) - ICELM + 1
          DO 14101 J = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
            IF (NINT(RSTORE(J+IATTYP)).EQ.N) THEN
C YES THIS ELEMENT AGREES
              XCENTR(1) = XCENTR(1) + RSTORE(J+1)
              XCENTR(2) = XCENTR(2) + RSTORE(J+2)
              XCENTR(3) = XCENTR(3) + RSTORE(J+3)
              NCENTR = NCENTR + 1
            ENDIF
14101   CONTINUE
        ELSE
          IF (IMULT.EQ.1) THEN
            DO 14105 J = 0 , IPACK
              CALL ZGTATM (ICCMMD(I) , J , IPOS)
              IF (IPOS.EQ.-1) GOTO 14105
              XCENTR(1) = XCENTR(1) + RSTORE(IPOS+1)
              XCENTR(2) = XCENTR(2) + RSTORE(IPOS+2)
              XCENTR(3) = XCENTR(3) + RSTORE(IPOS+3)
              NCENTR = NCENTR + 1
14105       CONTINUE
          ELSE
            N = ISINIT + (ICCMMD(I)-ICATOM)*IPACKT
            XCENTR(1) = XCENTR(1) + RSTORE(N+1)
            XCENTR(2) = XCENTR(2) + RSTORE(N+2)
            XCENTR(3) = XCENTR(3) + RSTORE(N+3)
            NCENTR = NCENTR + 1
          ENDIF
        ENDIF
14100 CONTINUE
C NOW CALCULATE THE CENTROID
      DO 14102 I = 1 , 3
        XCENTR(I) = XCENTR(I) / NCENTR
14102 CONTINUE
      RSTORE (IFVIEW+1) = XCENTR(1)
      RSTORE (IFVIEW+2) = XCENTR(2)
      RSTORE (IFVIEW+3) = XCENTR(3)
C OUTPUT THE RESULT
      WRITE (CLINE,14103) XCENTR
      CALL ZMORE(CLINE,0)
14103 FORMAT ('The dummy atom is positioned at ',3F6.3)
      IFVIEW = IFVIEW + IPACKT
      IF (ISVIEW.EQ.ISINIT) IFINIT = IFVIEW
      IRLAST = IFVIEW
      GOTO 9999
1411  CONTINUE
C ALL
      CALL ZZEROF (XCENTR,3)
      NCENTR = 0
      DO 14110 I = ISVIEW + IPACKT*8 , IFVIEW , IPACKT
        DO 14111 J = 1 , 3
          XCENTR(J) = XCENTR(J) + RSTORE(I+J)
14111   CONTINUE
        NCENTR = NCENTR + 1
14110 CONTINUE
      DO 14112 J = 1 , 3
        RSTORE(IFVIEW+J) = XCENTR(J)/NCENTR
14112 CONTINUE
      IFVIEW = IFVIEW + IPACKT
      IF (ISINIT.EQ.ISVIEW) IFINIT = IFVIEW
      GOTO 9999
1418  CONTINUE
C SWITCH
      DO 14180 I = ISVIEW + IPACKT*8 , IFVIEW-1 , IPACKT
        IF (NINT(RSTORE(I+IPCK+1)).EQ.-1) THEN
          RSTORE(I+IPCK+1) = 1.0
        ELSE IF (NINT(RSTORE(I+IPCK+1)).EQ.1) THEN
          RSTORE(I+IPCK+1) = -1.0
        ENDIF
14180 CONTINUE
      GOTO 9999
1419  CONTINUE
C FRAGMENT
      DO 14190 I = ICCNT , ICCNT + ICC -1
        N = (ICCMMD(I)-ICATOM) * IPACKT + IRATOM
        CALL ZFRAG (N,IPCK+1,REAL(IEXFLG),1)
14190 CONTINUE
      GOTO 9999
1420  CONTINUE
C INCLUDE/EXCLUDE AREA
1422  CONTINUE
C SELECT AREA
      IF (ISCRN.NE.IDEV) THEN
C OUTPUT A MESSAGE
        CALL ZMORE ('Error - current device is not screen.',0)
        CALL ZMORE ('Use VIEW to redraw picture.',0)
        GOTO 9999
      ENDIF
      CALL ZMORE ('Polygon draw activated.',0)
      CALL ZMORE1 ('Polygon draw activated.',0)
C      CALL ZFLUSH
      CALL ZGTARA(IXAR,IYAR,1000,NAR)
C NEED AT LEAST FOUR POINTS TO DEFINE THE POLYGON
C IE THREE FOR A TRIANGLE PLUS THE CLOSING POINT
      IF (NAR.LE.3) GOTO 9999
C IF SELECT EXCLUDE ALL ATOMS INITIALLY
      IF (ID.EQ.23) THEN
        IEXFLG = 1
        DO 14206 I = ISVIEW + IPACKT *8 , IFVIEW-1, IPACKT
          RSTORE(I+IPCK+1) = -1
14206   CONTINUE
      ENDIF
C NOW BEGIN TO LOOP OVER THE LINES
C WORK OUT THE M AND C VALUES FOR ALL OF THE LINES
      DO 14200 I = 1 , NAR-1
        IF (IXAR(I+1).NE.IXAR(I)) THEN
          MAR(I) = (REAL(IYAR(I+1))-IYAR(I))/(IXAR(I+1)-IXAR(I))
          CAR(I) = IYAR(I) - MAR(I)*IXAR(I)
        ELSE
          MAR(I) = 1.0E+10
        ENDIF
14200 CONTINUE
C NOW LOOP OVER THE ATOMS
      DO 14201 I = ISVIEW+IPACKT*8, IFVIEW-1, IPACKT
        IF (NINT(RSTORE(I+IPCK+1)).EQ.IEXFLG .OR.
     c   NINT(RSTORE(I+IPCK+1)).EQ.IEXFLG*2) GOTO 14201
C GET THE COORDS IN SCREEN COORDS
         IXAT = NINT((RSTORE(I+IXYZO)-XCP)*SCALE) + XCEN
         IYAT = NINT((RSTORE(I+IXYZO+1)-YCP)*SCALE) + YCEN
C THE EQUATION OF THIS LINE IS Y = C
         NLINES = 0
         NVERTS = 0
C LOOP OVER THE LINES
         DO 14202 J = 1 , NAR-1
           NVERT = 0
           IF (ABS(MAR(J)).LT.0.001) GOTO 14202
           IF (IXAR(J).EQ.IXAR(J+1)) THEN
             IXINT = IXAR(J)
           ELSE
             IXINT = -(CAR(J)-IYAT)/MAR(J)
           ENDIF
C DOES THIS INTERSECTION LIE IN RANGE
           IF (IXINT.GT.IXAT) GOTO 14202
C CHECK VERTEX HITS BY LOOKING AT THE SIGNS OF THE DY VALUES
C ALLOW FOR WRAP AROUND TO IYAR(2) IF WE ARE SITTING ON THE LAST BUT
C ONE VERTEX.
           IF (IYAR(J+1).EQ.IYAT) THEN
             IF (J.LT.NAR-2) THEN
               K = J + 2
             ELSE
               K = 2
             ENDIF
             IVAL = NINT ( SIGN (1.0,REAL(IYAR(J)-IYAR(J+1))) *
     c       SIGN(1.0,REAL(IYAR(K)-IYAR(J+1))) )
             IF (IVAL.LT.0) THEN
C THIS IS A VERTEX HIT ON AN OBLIQUE ANGLE
                NVERT = 1
             ENDIF
           ELSE
             IF (IYAR(J+1).LT.IYAR(J)) THEN
               IF (IYAT.LT.IYAR(J+1) .OR. IYAT .GT. IYAR(J)) GOTO 14202
             ELSE
               IF (IYAT .LT.IYAR(J) .OR. IYAT .GT. IYAR(J+1)) GOTO 14202
             ENDIF
           ENDIF
           NLINES = NLINES + 1 + NVERT
14202    CONTINUE
         IF (MOD(NLINES,2).EQ.1) THEN
C SET THE FLAG FOR THIS ATOM
           RSTORE(I+IPCK+1) = IEXFLG
         ENDIF
14201 CONTINUE
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
 
CODE FOR ZCMD15
      SUBROUTINE ZCMD15 (ID)
C This routine sets up the contents of the workspace
C to contain the atom number and coordinates (orthog) of any atoms
C to be included in the distancle calculation.
      
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

      ID = ID - (ID/100)*100 + 1
      GOTO (1500,1501,1502,1503,1504,1555) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      RETURN
1555  CONTINUE
      RETURN
1500  CONTINUE
C DISTANCE HEADER
C ATOMS HERE ARE BOTH TO AND FROM!
      DO 10 I = ICCNT,ICCNT+ICC-1
C LOAD UP THE INFO INTO THE WORK SPACE
        N = ICCMMD(I)
        IMULT = ICMULT (I)
        CALL ZDLIST (N,IMULT,1)
        IF (IPROC.EQ.0) RETURN
10    CONTINUE
      NDIST2 = NDIST1
      DO 12 I = ICCNT,ICCNT+ICC-1
C LOAD UP THE INFO INTO THE WORK SPACE
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        CALL ZDLIST (N,IMULT,2)
        IF (IPROC.EQ.0) RETURN
12    CONTINUE
      GOTO 9999
1501  CONTINUE
C ALL
      DO 20 I = ISVIEW + IPACKT * 8,IFVIEW-1,IPACKT
        N = (I-ISVIEW)/IPACKT + ICATOM
        CALL ZDLIST (N,0,1)
        IF (IPROC.EQ.0) RETURN
20    CONTINUE
      NDIST2 = NDIST1
      DO 22 I = ISVIEW + IPACKT * 8,IFVIEW-1,IPACKT
        N = (I-ISVIEW)/IPACKT + ICATOM
        CALL ZDLIST (N,0,2)
        IF (IPROC.EQ.0) RETURN
22    CONTINUE
      GOTO 9999
1502  CONTINUE
C RANGE
      DISBEG = RCOMMD(IRCNT)
      DISEND = RCOMMD(IRCNT+1)
cdjwfeb2000      GOTO 9999
cdjwfeb2000      goto 1501
      goto 9999
1503  CONTINUE
C FROM
      IF (NDIST1.NE.0) RETURN
      DO 50 I = ICCNT,ICCNT+ICC-1
C LOAD UP THE INFO INTO THE WORK SPACE
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        CALL ZDLIST (N,IMULT,1)
        IF (IPROC.EQ.0) RETURN
50    CONTINUE
      NDIST2 = NDIST1
      GOTO 9999
1504  CONTINUE
C TO
      DO 60 I = ICCNT,ICCNT+ICC-1
C LOAD UP THE INFO INTO THE WORK SPACE
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        CALL ZDLIST (N,IMULT,2)
        IF (IPROC.EQ.0) RETURN
60    CONTINUE
      GOTO 9999
9999  CONTINUE
C CALCULATION
C CHECK NEXT COMMAND
      INX = LNCHCK (1500)
      IF ((ID.NE.6).AND.(INX.EQ.1)) RETURN
C IF NEXT COMMAND IS OF THIS GROUP RETURN
      CALL ZDCALC
      IF (INX.EQ.-1) THEN
C FREE THE WORKSPACE
        NDIST1 = 0
        NDIST2 = 0
      ENDIF
      RETURN
      END
 
CODE FOR ZCMD16 [ COMMAND GROUP 1600 - ANGLES ]
      SUBROUTINE ZCMD16
      
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

      INTEGER N(3)
C There is only one command in this group!
C GET THE THREE ATOMS
      DO 10 I = 1 , ICC , 3
        N ( 1 ) = ICCMMD ( ICCNT + I - 1 )
        N ( 2 ) = ICCMMD ( ICCNT + I )
        N ( 3 ) = ICCMMD ( ICCNT + I + 1 )
        CALL ZACALC (N)
10    CONTINUE
      RETURN
      END
 
CODE FOR ZCMD17 [ COMMAND GROUP 1700 - PACK]
      SUBROUTINE ZCMD17 (ID)
      
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
C This routine carries out the calculations for the PACK group of commands.
      ID = ID - (ID/100)*100 + 1
      GOTO (1700,1701,1702,1703,1704,1705,1706,1707,1708,1709,1710
     c ) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
1700  CONTINUE
C PACK COMMAND ITSELF - DUMMY HEADER
      IVCHAN = 1
      IGPCK = 0
      IENCL = 0
      GOTO 9999
1701  CONTINUE
C CELL - SET UP LIMITS
      DO 10 I = 1,3
        PKMIN (I) = -0.5
        PKMAX (I) = 0.5
        PKCNF (I) = 0.5
10    CONTINUE
      IPPCK = 1
C CHECK NEXT COMMAND
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1702  CONTINUE
C WINDOW - SET UP LIMITS
      DO 20 I = 1,3
        PKMIN (I) = RCOMMD(IRCNT+(I-1)*2)-0.5
        PKMAX (I) = RCOMMD(IRCNT+(I-1)*2+1)-0.5
        PKCNF (I) = 0.5
20    CONTINUE
      IPPCK = 1
C CHECK NEXT COMMAND
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1703  CONTINUE
C CUT
      ITYPCK = 1
C CHECK NEXT COMMAND
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1704  CONTINUE
C COMPLETE
      ITYPCK = 2
C CHECK NEXT COMMAND
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1705  CONTINUE
C CENTROID
      ITYPCK = 3
C CHECK NEXT COMMAND
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP - DO PACK
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1706  CONTINUE
C UNPACK
      ISVIEW = ISINIT
      IFVIEW = IFINIT
      ICOLL = 0
      IPACK = 0
C RESET THE SCRATCH FILE POINTER
      NSCRAT = 0
      IF (.NOT.LFILES(0,' ',ISCRAT)) THEN
        CALL ZMORE('Error on closing pack number scratch file.',0)
      ENDIF
      IRLAST = IFVIEW
C RESET PACK AND ENCLOSURE FLAGS
      IENCL = 0
      IPACK = 0
      ICONBG = ISYMED - IGMAX
      IVCHAN = 1
C      CALL ZDOCON (0,0,0)
      GOTO 9999
1707  CONTINUE
C INTRA
      IPCOLL = 0
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP
C CHECK TO SEE WHETHER OR NOT WE HAVE SET UP LIMITS
        DO 17070 I = 1 , 3
          IF (PKMAX(I)-PKMIN(I).GT.0.000) THEN
            II = 1
          ENDIF
17070   CONTINUE
        IF (II.EQ.0) THEN
C CELL - SET UP LIMITS
          DO 17071 I = 1,3
            PKMIN (I) = -0.5
            PKMAX (I) = 0.5
            PKCNF (I) = 0.5
17071     CONTINUE
          IPPCK = 1
        ENDIF
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1708  CONTINUE
C INTER
      IPCOLL = 1
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP
C CHECK TO SEE WHETHER OR NOT WE HAVE SET UP LIMITS
        DO 17002 I = 1 , 3
          IF (PKMAX(I)-PKMIN(I).GT.0.000) THEN
            II = 1
          ENDIF
17002   CONTINUE
        IF (II.EQ.0) THEN
C CELL - SET UP LIMITS
          DO 17003 I = 1,3
            PKMIN (I) = -0.5
            PKMAX (I) = 0.5
            PKCNF (I) = 0.5
17003     CONTINUE
          IPPCK = 1
        ENDIF
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1709  CONTINUE
C KEEP
      IPCOLL = 2
      INXT = LNCHCK (1700)
      IF (INXT.EQ.-1) THEN
C THE NEXT COMMAND IS NOT OF THIS GROUP
C CHECK TO SEE WHETHER OR NOT WE HAVE SET UP LIMITS
        DO 17012 I = 1 , 3
          IF (PKMAX(I)-PKMIN(I).GT.0.000) THEN
            II = 1
          ENDIF
17012   CONTINUE
        IF (II.EQ.0) THEN
C CELL - SET UP LIMITS
          DO 17013 I = 1,3
            PKMIN (I) = -0.5
            PKMAX (I) = 0.5
            PKCNF (I) = 0.5
17013     CONTINUE
          IPPCK = 1
        ENDIF
        CALL ZPACK
        CALL ZATMUL(0,0,0)
      ENDIF
      GOTO 9999
1710  CONTINUE
C GROUP
      IENCL = 1
      IF (ICC.NE.0) THEN
        DO 17101 I = ICCNT , ICCNT + ICC - 1
          RSTORE(ISYMED - I + ICCNT) = ICCMMD(I)
17101   CONTINUE
        IGPCK = ICC
      ELSE
C IF NO NAME WAS STORED THEN WE ARE DOING ALL OF THE GROUPS
        DO 17102 I = 1 , NGRP
          RSTORE(ISYMED - I + 1) = I
17102   CONTINUE
        IGPCK = NGRP
      ENDIF
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD18 [ COMMAND GROUP 1800 - MENUS]
      SUBROUTINE ZCMD18 (ID)
      
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

      ID = ID - (ID/100)*100 + 1
      GOTO (1800,1801,1802) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
1800  CONTINUE
C MENUS HEADER
      GOTO 9999
1801  CONTINUE
C MENUS ON
C CHECK DEVICE
      IF (IDEV.NE.1) THEN
        CALL ZMORE(
     c 'You must specify an appropriate graphics screen eg VGA/SILICON'
     c ,0)
        IPROC = 0
        RETURN
      ENDIF
      IF (IMENCN.EQ.0) THEN
        IMENCN = 1
        XCENS = XCENS - 70
        YCENS = YCENS - 24
        XCEN = XCENS
        YCEN = YCENS
      ENDIF
      IEDIT = 0
      GOTO 9999
1802  CONTINUE
C MENUS OFF
      IF (IMENCN.NE.0) THEN
        XCENS = XCENS + 70
        YCENS = YCENS + 24
        XCEN = XCENS
        YCEN = YCENS
      ENDIF
      IMENCN = 0
      ICABAN = 1
      ICLOG = 1
CNOV98      IEND = 0
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD20 [ COMMAND GROUP 2000 - INFO]
      SUBROUTINE ZCMD20 (ID)
      
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
      INCLUDE 'XUNITS.INC'

      CHARACTER*12 DUMP(6)
      CHARACTER*50 SWORD, cDLINE
      INTEGER K
      REAL SYMM(4,4), DSYMM(4,4)
      REAL RTX, RTY , RTZ, rtxyz(3)
      INTEGER ILNO
C This routine displays information on the data held within the program.
      ID = ID - (ID/100)*100 + 1
      GOTO (2000,2100,2200,2300,2400,2500,2600) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
2000  CONTINUE
C INFO ITSELF
C      CALL ZCLEAR
C INFO CAN BE FOLLOWED BY ATOM NAMES WHICH HAVE BEEN PICKED WITH THE
C MOUSE. THE MOUSE PICKING IS USED TO GET THE NAMES - THEY DON'T
C ACTUALLY DO ANYTHING!!
      GOTO 9999
2100  CONTINUE
C CELL
      CALL ZMORE('The cell parameters are :-',0)
      WRITE (CLINE,2011) (RSTORE(ICRYST+J),J=0,5)
      CALL ZMORE(' ',0)
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      CALL ZMORE(' ',0)
2011  FORMAT ('a ',F5.2,' b ',F5.2,' c ',F5.2,' Alpha ',F5.1,
     c ' Beta ',F5.1,' Gamma ',F5.1)
      GOTO 9999
2200  CONTINUE
C INCLUDE
      CALL ZMORE('The atoms included in the picture are:-',1)
      NN = 0
      NM = 0
      CALL ZBLANK (DUMP,12,6)
      DO 10 I = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
      IF (RSTORE(I+IPCK+1).LT.0) GOTO 10
      N = (I-ISINIT)/IPACKT + ICATOM
      NN = NN + 1
      NM = 1
      DUMP(NN) = CSTORE(N)
      IF (IPACK.GT.0) THEN
        ISLEN = INDEX(CSTORE(N),' ') - 1
        CALL ZPLABL (I,DUMP(NN),ISLEN)
      ENDIF
      IF (NN.LT.6) GOTO 10
      WRITE (CLINE,2012) DUMP
      CALL ZMORE(CLINE,2)
      NN = 0
      CALL ZBLANK (DUMP,12,6)
10    CONTINUE
      IF (NN.GT.0) WRITE (CLINE,2012) DUMP
      CALL ZMORE(CLINE,2)
      IF (NM.EQ.0) CALL ZMORE('None',2)
C EXCLUDED
      CALL ZMORE('The atoms excluded from the picture are :-',2)
      NN = 0
      NM = 0
      CALL ZBLANK (DUMP,12,6)
      DO 20 I = ISVIEW + IPACKT *8 ,IFVIEW-1,IPACKT
      IF (RSTORE(I+IPCK+1).GT.0) GOTO 20
      N = (I-ISINIT)/IPACKT + ICATOM
      NN = NN + 1
      NM = 1
      DUMP(NN) = CSTORE(N)
      IF (IPACK.GT.0) THEN
        ISLEN  = INDEX (DUMP(NN) , ' ') - 1
        CALL ZPLABL (I,DUMP(NN),ISLEN)
      ENDIF
      IF (NN.LT.6) GOTO 20
      WRITE (CLINE,2012) DUMP
      CALL ZMORE(CLINE,2)
      NN = 0
      CALL ZBLANK (DUMP,12,6)
20    CONTINUE
      IF (NN.GT.0) THEN
        WRITE (CLINE,2012) DUMP
        CALL ZMORE(CLINE,2)
      ENDIF
      IF (NM.EQ.0) CALL ZMORE('None',2)
      GOTO 9999
2300  CONTINUE
C COLOUR
      CALL ZMORE(
     c 'Available colour names are (normal/greyscale):-',0)
      DO 2301 I = 1 , ICLMAX
        WRITE (CLINE,'(A6,2X,A6)') COLNAM(I) , COLGRY(I)
        CALL ZMORE(CLINE,0)
2301  CONTINUE
      GOTO 9999
2400  CONTINUE
C SYMMETRY OPERATORS
      WRITE (CLINE,2401) NSYMM
      CALL ZMORE(CLINE,1)
2401  FORMAT ('There are ',I3,' symmetry operators.')
C LOOP OVER THE OPERATORS
      DO 2402 I = 1 , NSYMM
C GET THE OPERATOR
        CALL ZMOVE (RSTORE(ITOT-I*16),SYMM,16)
C WRITE OUT THE EQUIVALENT TEXT OPERATOR
        CALL ZSOUT (SYMM,SWORD,ISLEN)
        IF (SYMM(4,4).GT.0.0) THEN
          WRITE (CLINE,2403) I, SWORD(1:ISLEN),'   (in use).'
        ELSE
          WRITE (CLINE,2403) I, SWORD(1:ISLEN),'   (not in use).'
        ENDIF
        CALL ZMORE(CLINE,2)
2403    FORMAT ('Number ',I4,' :     Operator ',2A)
2402  CONTINUE
      GOTO 9999
2500  CONTINUE
C GROUPS
C GET THE GROUPS NAMES
      IF (NGRP.EQ.0) THEN
        CALL ZMORE('No groups currently defined.',0)
        GOTO 9999
      ENDIF
      CALL ZMORE('The following groups are defined',1)
      CALL ZBLANK (DUMP,12,6)
      DO 2501 I = IGRP , IGRP - (NGRP-1)*2 , -2
        IGG = (IGRP-I)/2 + 1
C GET THE GROUP NAME
        WRITE (CLINE,2013) CSTORE(I)//CSTORE(I-1)
        CALL ZMORE(CLINE,2)
2013    FORMAT ('Group Name : ',A12)
C THE GROUP MEMBERS
        NN = 0
        DO 2502 J = ISVIEW + IPACKT*8 , IFVIEW-1 , IPACKT
          DO 2503 K = J+IATTYP+6, J+IATTYP+8
            IF (NINT(RSTORE(K)).EQ.IGG) THEN
              KK = (J-IRATOM)/IPACKT+ICATOM
              NN = NN + 1
              DUMP(NN) = CSTORE(KK)
              IF (IPACK.GT.0) THEN
                ISLEN = INDEX (DUMP(NN) , ' ') - 1
                CALL ZPLABL (J,DUMP(NN),ISLEN)
              ENDIF
            ENDIF
2503      CONTINUE
          IF (NN.EQ.6) THEN
            WRITE (CLINE,2012) DUMP
            CALL ZMORE(CLINE,2)
            NN = 0
            CALL ZBLANK(DUMP,12,6)
          ENDIF
2502    CONTINUE
        IF (NN.NE.0) THEN
          WRITE (CLINE,2012) DUMP
          CALL ZMORE(CLINE,2)
        ENDIF
        CALL ZMORE(' ',2)
2501  CONTINUE
      GOTO 9999
2600  CONTINUE
C INFO PACKNUMBERS
      IF (NSCRAT.EQ.0) THEN
        CALL ZMORE('No pack numbers stored',0)
        RETURN
      ENDIF
      DO 2601 I = INCNT , INCNT+ICN-1
        ILNO = NCOMMD(I)
        IF (ILNO.GE.NSCRAT) THEN
          WRITE (CLINE,'(A,I3,A)') 'Pack number ',ILNO, ' not stored.'
          CALL ZMORE(CLINE,0)
          GOTO 2601
        ENDIF
C GET THE INFO FROM THE SCRATCH FILE
        READ (ISCRAT,REC=ILNO+1) SYMM, RTX, RTY , RTZ
c^^djwnov06
       RTXYZ(1) = RTX
       RTXYZ(2) = RTY
       RTXYZ(3) = RTZ
       do idjw = 1,4
        DSYMM(1,idjw) = SYMM(1,idjw)
        DSYMM(2,idjw) = SYMM(2,idjw)
        DSYMM(3,idjw) = SYMM(3,idjw)
        DSYMM(4,idjw) = SYMM(4,idjw)
       enddo
        CALL ZSOUT (SYMM,SWORD,ISLEN)
        WRITE (CLINE,2602) ILNO , SWORD(1:ISLEN-1), rtx,rty, rtz
2602   FORMAT ('Atoms labelled',I5 , ' use operator ', A,
     1  ' plus ',3f4.0 )
        CALL ZMORE(CLINE,0)
        call xctrim(cline,idjw)
        CALL ZSYMPK (ILNO+1, DSYMM, RTXYZ, cDLINE)
        call xctrim(cdline,Jdjw)
        if (issprt .GE. 0)
     1  write(ncwu,'(a,a,a)') cline(1:idjw),' = ', cdline(1:jdjw)
2601  CONTINUE
9999  CONTINUE
2012  FORMAT (6(A12,1X))
      RETURN
      END
C 
CODE FOR ZCMD21 [ COMMAND GROUP 2100 - DEFGROUP ]
      SUBROUTINE ZCMD21 (ID)
      
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

C This routine contains the code for the group defining commands.
      CHARACTER*12 GNAME,GNM
      ID = ID - (ID/100)*100 + 1
      GOTO (2100,2101,2102,2103,2104,2105) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
2100  CONTINUE
C NEWGROUP
C GET THE NEW NAME
      GNAME = CTCOMD (ITCNT)(1:12)
C USE THE UPPERCASE VERSION - THIS IS AUTOMATICALLY TESTED FOR IN
C XCISCH
      CALL ZUPCAS(GNAME)
C NEED TO UPDATE ITCNT
      ITCNT = ITCNT + 1
      IGG = 0
C IS IT AN EXISTING NAME?
      DO 10 I = IGRP,IGRP - (NGRP-1)*2,-2
        GNM = CSTORE(I)//CSTORE(I-1)
        IF (GNM.EQ.GNAME) THEN
          IGG = (IGRP - I)/2 + 1
        ENDIF
10    CONTINUE
C NOT ALREADY PRESENT GIVE IT A NEW NUMBER.
      IF (IGG.EQ.0) THEN
        IF (NGRP.LT.IGMAX) THEN
          IGG = NGRP + 1
          NGRP = NGRP + 1
C STORE NAME
          CSTORE(IGRP-(IGG-1)*2) = GNAME(1:6)
          CSTORE(IGRP-(IGG-1)*2-1) = GNAME(7:12)
        ELSE
          IPROC = 0
         WRITE (CLINE,11) IGMAX
          CALL ZMORE(CLINE,0)
          CALL ZMORE1(CLINE,0)
11        FORMAT ('You can only define ',I2,' groups at any one time.')
        ENDIF
      ENDIF
      GOTO 9999
2101  CONTINUE
C ATOMS
      DO 20 I = ICCNT,ICCNT+ICC-1
        N = ICCMMD(I)
        IMULT = ICMULT(I)
        CALL ZPARAM (N,0,REAL(IGG),3,IMULT)
C ADD THESE ATOMS INTO THE GROUP
C        IF (N.LT.ICATOM) THEN
C ELEMENT
C          N = N - ICELM + 1
C          DO 30 J = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
C            IF (NINT(RSTORE(J+IATTYP)).NE.N) GOTO 30
C LOOP OVER GROUP STORAGE NUMBER
C            DO 40 K = J+IATTYP+6,J+IATTYP+9
C DON'T ADD IT IF ITS ALREADY PRESENT
C              IF (NINT(RSTORE(K)).EQ.IGG) GOTO 50
C              IF (NINT(RSTORE(K)).EQ.0) THEN
C ADD ATOM INTO GROUP
C                RSTORE(K) = IGG
C                GOTO 50
C              ENDIF
C40          CONTINUE
C50          CONTINUE
C30        CONTINUE
C        ELSE
C ATOM
C          N = (N-ICATOM)*IPACKT + IRATOM
C          DO 60 K = N+IATTYP+6,N+IATTYP+9
C            IF (NINT(RSTORE(K)).EQ.IGG) GOTO 70
C            IF (NINT(RSTORE(K)).EQ.0) THEN
C              RSTORE(K) = IGG
C              GOTO 70
C            ENDIF
C60        CONTINUE
C70        CONTINUE
C        ENDIF
20    CONTINUE
      GOTO 9999
2102  CONTINUE
C GROUP
C This adds any atoms in the relevant sub group into the new group.
      DO 80 I = ISVIEW + IPACKT*8 ,IFVIEW-1,IPACKT
C LOOP OVER THE GROUP FLAGS
        DO 90 J = I+IATTYP+6,I+IATTYP+8
          IF (NINT(RSTORE(J)).EQ.0) GOTO 90
C FOUND A FLAG IS IT LISTED IN ICCMMD?
          DO 100 K = ICCNT,ICCNT+ICC-1
            IF (NINT(RSTORE(J)).EQ.ICCMMD(K)) THEN
C YES ADD THIS INTO THE NEW GROUP - IS THERE SPACE?
              IF (J.EQ.I+IATTYP+8) GOTO 80
C NO SPACE
C LOOP TO FIND SPACE
              DO 110 KK = J+1,I+IATTYP+8
                IF (NINT(RSTORE(KK)).EQ.0) THEN
                  RSTORE(KK) = IGG
                  GOTO 80
                ENDIF
110           CONTINUE
            ENDIF
100       CONTINUE
90      CONTINUE
80    CONTINUE
      GOTO 9999
2103  CONTINUE
C DELETE ATOMS FROM A GROUP
      DO 120 I = ICCNT,ICCNT+ICC-1
        N = ICCMMD(I)
        CALL ZPARAM (N,0,REAL(IGG),4,IMULT)
C        IF (N.LT.ICATOM) THEN
C ELEMENT
C          N = N - ICELM + 1
C          DO 130 J = ISVIEW + IPACKT*8 , IFVIEW - 1 , IPACKT
C            IF (N.EQ.NINT(RSTORE(J+IATTYP))) THEN
C FOUND ELEMENT - LOOP OVER STORAGE
C              DO 140 K = J+IATTYP+6,J+IATTYP+9
C                IF (NINT(RSTORE(K)).EQ.IGG) RSTORE(K) = 0.0
C140           CONTINUE
C            ENDIF
C130       CONTINUE
C        ELSE
C ATOM
C          N = (N-ICATOM)*IPACKT + IRATOM
C          DO 150 K = N+IATTYP+6,N+IATTYP+9
C            IF (NINT(RSTORE(K)).EQ.IGG) RSTORE(K) = 0.0
C150       CONTINUE
C        ENDIF
120   CONTINUE
      GOTO 9999
2104  CONTINUE
C (DELETE) ALL
      DO 160 I = ISVIEW + IPACKT*8 , IFVIEW-1,IPACKT
        DO 170 J = I+IATTYP+6,I+IATTYP+8
          IF (NINT(RSTORE(J)).EQ.IGG) RSTORE(J) = 0.0
170     CONTINUE
160   CONTINUE
C GET RID OF THE GROUP NAME
      CSTORE(IGRP+(IGG-1)*2) = '      '
      CSTORE(IGRP+(IGG-1)*2-1) = '      '
      GOTO 9999
2105  CONTINUE
C FRAGMENT
      DO 180 I = ICCNT, ICCNT+ICC-1
        N = (ICCMMD(I) - ICATOM )*IPACKT + IRATOM
        CALL ZFRAG (N,0,REAL(IGG),2)
180   CONTINUE
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCMD22 [ COMMAND GROUP 2200 - TORSION ]
      SUBROUTINE ZCMD22
C THERE IS ONLY ONE COMMAND IN THIS GROUP.
      
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

      INTEGER N(4)
      DO 10 I = 1 , ICC , 4
        N (1) = ICCMMD ( ICCNT + I - 1 )
        N (2) = ICCMMD ( ICCNT + I )
        N (3) = ICCMMD ( ICCNT + I + 1 )
        N (4) = ICCMMD ( ICCNT + I + 2 )
        CALL ZTCALC (N)
10    CONTINUE
      RETURN
      END
 
CODE FOR ZCMD23 [ COMMAND GROUP 2300 - RENAME
      SUBROUTINE ZCMD23 ( ID )
      
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

      CHARACTER*(ILEN) LABEL
      CHARACTER*(ILEN) CNEW , COLD , CBLANK, CSEARC
      ID = ID - (ID/100)*100 + 1
      GOTO (2300,2301,2302) ID
      WRITE (CLINE,'(A)')
     1 ' Command not recognised by this version of CAMERON'
      CALL ZMORE(CLINE,0)
      CALL ZMORE1(CLINE,0)
      GOTO 9999
2300  CONTINUE
C RENAME
      CBLANK = '      '
      DO 14200 I = ICCNT , ICCNT + ICC -1 , 2
        N = ICCMMD ( I )
        IMULT = ICMULT(I)
        COLD = CSTORE ( N )
        CNEW = CTCOMD ( ITCNT )(1:ILEN)
        CALL ZUPCAS(CNEW)
        ITCNT = ITCNT + 1
C LOOK FOR AN UNDERLINE IN THE NEW NAME - GET RID OF IT
        IND = INDEX ( CNEW , '_')
        IF (IND.NE.0) THEN
          CNEW(IND:ILEN) = CBLANK(IND:ILEN)
        ENDIF
C CHECK THE NEW DESCRIPTION - IS IT AN ELEMENT?
        IVAL = 0
C ASSUME THAT WE HAVE AT LEAST ONE ATOM NUMBER
        DO 14201 IL = ILEN-1 , 1 , -1
C FIND THE ELEMENT TYPE
          CSEARC = CNEW(1:IL)//CBLANK
          CALL ZCASCH (CSEARC,ICELM, ICATOM-1,1,IELM,IP,IN )
          IF (IELM.NE.-1) GOTO 14202
14201   CONTINUE
14202   CONTINUE
        IF (IELM.EQ.-1) THEN
          WRITE (CLINE,14203) CNEW
          CALL ZMORE(CLINE,0)
          CALL ZMORE1(CLINE,0)
14203     FORMAT ('The element type of the new atom name,',A6,
     c  ' is not known.')
          IPROC = 0
          RETURN
        ENDIF
C OTHERWISE WE HAVE THE NEW ELEMENT TYPE
C IS THIS ELEMENT TO ELEMENT?
        IFLAG = 0
        IF (CNEW(IL+1:ILEN).EQ.CBLANK(IL+1:ILEN)) THEN
          IFLAG = 1
C FIND THE TRUE LENGTH OF THE ELEMENT NAME
          IL = INDEX ( CNEW ,' ') - 1
        ENDIF
        IF ((IFLAG.EQ.1).AND.(N.GE.ICATOM)) THEN
          CALL ZMORE('You cannot rename an atom to an element',0)
          CALL ZMORE1('You cannot rename an atom to an element',0)
          CALL ZBEEP
          IPROC = 0
          RETURN
        ENDIF
C RENAME ELEMENT TO ELEMENT
        IF (IFLAG.EQ.1) THEN
C SEARCH LIST FOR THE GIVEN ELEMENT
          IELM = IELM - ICELM + 1
          N = N - ICELM + 1
          IF (IMULT.EQ.0) THEN
C UPDATE THE KEY INFORMATION
            DO 14206 J = 0 , NKEY-1
              IF (NINT(RSTORE(IKEY+J*2)).EQ.N) THEN
                RSTORE(IKEY+J*2)= IELM
                RSTORE(IKEY+J*2+1) =
     c          RSTORE ( IRELM + (IELM-1)*4 + 3 )
              ENDIF
14206       CONTINUE
          ENDIF
          DO 14204 J = ISINIT , IFVIEW-1 ,IPACKT
            IF (NINT(RSTORE(J+IATTYP)).NE.N) GOTO 14204
            IF ((NINT(RSTORE(J+IPCK)).NE.IMULT-1).AND.(IMULT.NE.0))
     c      GOTO 14204
            K = (J-IRATOM)/IPACKT + ICATOM
            RSTORE(J+IATTYP) = IELM
            RSTORE(J+IATTYP+5) =
     c      RSTORE ( IRELM + ( IELM - 1 ) * 4)
            RSTORE(J+IATTYP+4) = RSTORE(J+IATTYP+5)*0.25
            RSTORE(J+IATTYP+1) =
     c      RSTORE ( IRELM + (IELM -1 ) * 4 + 3 )
C NEED TO ALTER THE LABEL
C FIND THE LENGTH OF THE ORIGINAL ELEMENT LABEL
            ILO = INDEX ( CSTORE(N+ICELM-1) , ' ') - 1
            LABEL = CSTORE(IELM+ICELM-1)(1:IL)//
     c      CSTORE(K)(ILO+1:ILEN)
C STORE THE NEW LABEL
            CSTORE(K) = LABEL
14204     CONTINUE
        ELSE
C DO THE ATOM
          IELM = IELM - ICELM + 1
          IF (IMULT.EQ.1) THEN
            IFLAG = 0
            DO 14205 J = 0 , IPACK
              CALL ZGTATM ( N , J , IPOS)
              IF (IPOS.EQ.-1) GOTO 14205
C ALTER THE ELEMENT STATISTICS
              RSTORE(IPOS+IATTYP) = IELM
              RSTORE(IPOS+IATTYP+5) =
     c        RSTORE (   IRELM + ( IELM - 1 ) * 4)
              RSTORE(IPOS+IATTYP+4) = RSTORE(IPOS+IATTYP+5)*0.25
              RSTORE(IPOS+IATTYP+1) =
     c        RSTORE ( IRELM + (IELM -1 ) * 4 + 3 )
C ALTER THE LABEL
              K = (IPOS - IRATOM)/IPACKT + ICATOM
              IF (IFLAG.EQ.0) THEN
                IFLAG = K
              ELSE
C NEED TO ALTER THE LABEL
                CSTORE(K) = CNEW
              ENDIF
14205       CONTINUE
C YOU MUSTNT CHANGE THE FIRST ATOM IN THE LIST UNTIL THE END BECAUSE
C THIS NAME IS BEING USED IN THE SEARCH FOR ATOMS ABOVE
            IF (IFLAG.NE.0) THEN
              CSTORE(IFLAG) = CNEW
            ENDIF
          ELSE
            CSTORE(N) = CNEW
            N = (N-ICATOM)*IPACKT + IRATOM
            RSTORE(N+IATTYP+5) =
     c      RSTORE ( IRELM + ( IELM - 1 ) * 4)
            RSTORE(N+IATTYP+4) = RSTORE(N+IATTYP+5)*0.25
            RSTORE(N+IATTYP+1) =
     c      RSTORE (  IRELM + ( IELM -1 ) * 4 + 3 )
            RSTORE(N+IATTYP) = IELM
          ENDIF
        ENDIF
14200 CONTINUE
      GOTO 9999
2301  CONTINUE
C RETYPE IS NOT DONE HERE
      GOTO 9999
2302  CONTINUE
C RETYPE ATOMS
C THE NEW ELEMENT NAME WILL BE HELD IN THE PREVIOUS POSITION IN ICCMMD
      CNEW = CTCOMD ( ITCNT ) ( 1 : 6 )
      CALL ZUPCAS(CNEW)
      ITCNT = ITCNT + 1
C LOOK FOR THIS ELEMENT
      CALL ZCASCH (CNEW,ICELM,ICATOM-1,1,IELM,IP,IN)
      IF (IELM.EQ.-1) THEN
        CALL ZBEEP
        CALL ZMORE('For RETYPE you must specify an element.',0)
        CALL ZMORE1('For RETYPE you must specify an element.',0)
        IPROC = 0
        RETURN
      ENDIF
      IELM = IELM - ICELM + 1
C ADD NEW ELEMENT INTO THE KEY IF IT DOESNT EXIST
      II = 0
      DO 14222 I = 0 , NKEY-1
        IF (NINT(RSTORE(IKEY+I*2)).EQ.IELM) THEN
          II = 1
          GOTO 14223
        ENDIF
14222 CONTINUE
14223 CONTINUE
      IF (II.EQ.0) THEN
        RSTORE(IKEY+NKEY*2) = IELM
        RSTORE(IKEY+NKEY*2+1) = RSTORE(IRELM+(IELM-1)*4+3)
      ENDIF
      NKEY = NKEY + 1
      IL = INDEX ( CNEW ,' ') - 1
      DO 14220 I = ICCNT , ICCNT + ICC - 1
        N = ICCMMD(I)
        IMULT = ICMULT(I)
          IF (IMULT.EQ.1) THEN
C MULTIPLE RENAMING
          IFLAG = 0
          DO 14221 J = 0 , IPACK
            CALL ZGTATM ( N , J , IPOS)
            IF (IPOS.EQ.-1) GOTO 14221
C ALTER THE ELEMENT STATISTICS
            RSTORE(IPOS+IATTYP) = IELM
            RSTORE(IPOS+IATTYP+5) =
     c      RSTORE (   IRELM + ( IELM - 1 ) * 4)
            RSTORE(IPOS+IATTYP+4) = RSTORE(IPOS+IATTYP+5)*0.25
            RSTORE(IPOS+IATTYP+1) =
     c      RSTORE ( IRELM + (IELM -1 ) * 4 + 3 )
C ALTER THE LABEL
            K = (IPOS - IRATOM)/IPACKT + ICATOM
            IF (IFLAG.EQ.0) THEN
              IFLAG = K
            ELSE
C NEED TO ALTER THE LABEL
C FIND THE LENGTH OF THE ORIGINAL ELEMENT LABEL
              ILO = INDEX ( CSTORE(N+ICELM-1) , ' ') - 1
              LABEL = CSTORE(IELM+ICELM-1)(1:IL)//
     c        CSTORE(K)(ILO+1:ILEN)
C STORE THE NEW LABEL
              CSTORE(K) = LABEL
            ENDIF
14221     CONTINUE
C YOU MUSTNT CHANGE THE FIRST ATOM IN THE LIST UNTIL THE END BECAUSE
C THIS NAME IS BEING USED IN THE SEARCH FOR ATOMS ABOVE
          IF (IFLAG.NE.0) THEN
            K = (IFLAG-IRATOM)/IPACKT+ICATOM
C NEED TO ALTER THE LABEL
C FIND THE LENGTH OF THE ORIGINAL ELEMENT LABEL
            ILO = INDEX ( CSTORE(NINT(RSTORE(IFLAG+IATTYP))+ICELM-1)
     c      , ' ') - 1
            LABEL = CSTORE(IELM+ICELM-1)(1:IL)//
     c      CSTORE(K)(ILO+1:ILEN)
C STORE THE NEW LABEL
            CSTORE(K) = LABEL
          ENDIF
        ELSE
C NEED TO ALTER THE LABEL
C FIND THE LENGTH OF THE ORIGINAL ELEMENT LABEL
          K = N
          N = (N-ICATOM)*IPACKT + IRATOM
          ILO = INDEX ( CSTORE(NINT(RSTORE(N+IATTYP))+ICELM-1)
     c    , ' ') - 1
          LABEL = CSTORE(IELM+ICELM-1)(1:IL)//
     c    CSTORE(K)(ILO+1:ILEN)
C STORE THE NEW LABEL
          CSTORE(K) = LABEL
          RSTORE(N+IATTYP+5) =
     c    RSTORE ( IRELM + ( IELM - 1 ) * 4)
          RSTORE(N+IATTYP+4) = RSTORE(N+IATTYP+5)*0.25
          RSTORE(N+IATTYP+1) =
     c    RSTORE (  IRELM + ( IELM -1 ) * 4 + 3 )
          RSTORE(N+IATTYP) = IELM
        ENDIF
14220 CONTINUE
      GOTO 9999
9999  CONTINUE
      RETURN
      END

CODE FOR SUBROUTINE ZCMD24
      SUBROUTINE ZCMD24
C This initiates the input of a new set of menus.
      INCLUDE 'CAMIMN.INC'
      LINPMN = .TRUE.
      RETURN
      END


CODE FOR CAMPRESETS
      BLOCK DATA CAMPRE
      INCLUDE 'CAMDEV.INC'


      DATA CCAMDV / 'VGA',       'SIGMA',        'HPGL',
     1              'TEKT',      'POST',         'ENCAP',
     1              'VGA',       'CPOST',        'CENCA' /

#ifdef CRY_NOGUI
      DATA RCAMDV / 320.0, 240.0, 30.0,
#else
      DATA RCAMDV /1200.0,1200.0, 30.0,
#endif
     2                  480.0, 360.0, 50.0,
     3                 5200.0,3700.0,300.0,
     4                  550.0, 360.0, 40.0,
     5                 4100.0,3000.0,300.0,
c     6                 3000.0,3000.0,300.0,
     6                 4100.0,3000.0,300.0,
     7                  320.0, 240.0, 30.0,
     8                 4100.0,3000.0,300.0,
c     9                 3000.0,3000.0,300.0 /
     9                 4100.0,3000.0,300.0 /

      DATA ICAMDV / 15, 0, 0, 0, 0,
     2               0,15, 8, 0, 0,
     3              15, 0, 8, 0, 0,
     4               0, 0, 0, 1, 1,
     5              15, 1, 0, 1, 1, 
     6              15, 1, 0, 1, 1, 
     7              15, 0, 0, 0, 0,
     8              15, 0, 0, 0, 0,
     9              15, 0, 0, 0, 0 /

      DATA JCAMDV / 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     2              0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     3              0,1,1,1,1,1,1,1,1,1, 1, 1, 1, 1, 1, 1,
     4              0,1,1,1,1,1,1,1,1,1, 1, 1, 1, 1, 1, 1,
     5              0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     6              0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     7              0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     8              0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
     9              0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15/

      END
C
CODE FOR XPOSTP
      SUBROUTINE XPOSTP(IIN, IOUT, IFONT, SCALE)
C POST PROCESS A .PS FILE TO SET .EPS BOUNDING BOX
C IFONT  NEW FONT SIZE
C RE-ORGANIES JUNE 2002.  THE BOUNDINGBOX IS DETERMINED FROM THE
C POINTS TO BE PLOTTED, THEN SHIFTED TO AN 0,0 ORIGIN. THE PICTUE
C IS SCALED AND AN ORIGIN SHIFT APPLIED.
      CHARACTER *132 CLINE
      Allx=100000
      Ally=100000
      Urx =-100000
      Ury =-100000
      REWIND (IIN)
      REWIND (IOUT)
C
      NLIN=0
100   CONTINUE
      READ(IIN,'(A)', END=200) CLINE
      CONTINUE
      IF (CLINE(7:15) .EQ. 'scalefont') THEN
            READ(CLINE,'(I5)', ERR=100)  JFONT
      ENDIF
      READ(CLINE, '(F7.0,F9.0)', ERR=100) A,B
      IF (A .LT. Allx) Allx = A
      IF (A .GT. Urx) Urx = A

      IF (B .LT. Ally) Ally = B
      IF (B .GT. Ury) Ury = B
      NLIN=NLIN+1
      GOTO 100
200   CONTINUE
      WRITE(CLINE,*) 'Figure limits ' , Allx,Ally,Urx,Ury,NLIN,
     1 scale
      CALL ZMORE(CLINE,0)
      DELTAX = Urx-Allx
      DELTAY = Ury-Ally
C (18~1/4 INCH)
      Urx =  18. + DELTAX
      Ury =  18. + DELTAY
      WRITE(CLINE,*) 'Unscaled Bounding Box   0   0 ', Urx,Ury
      CALL ZMORE(CLINE,0)
      sx = 567./urx
      sy = 828./ury
      sc = min(sx,sy)
      Urx = sc * Urx
      Ury = sc * Ury
      WRITE(CLINE,*) 'Scaled Bounding Box     0   0 ', Urx,Ury
      CALL ZMORE(CLINE,0)
      SC = 0.95*sc
C
      REWIND (IIN)
      NLIN = 0
      READ(IIN, '(A)') CLINE
      IF (CLINE(1:10) .EQ. '%!PS-Adobe') THEN
            READ(IIN,'(15X,4F8.0)') OALlx,OALly,OUrx,OUry
            WRITE(CLINE,*) 'Original Bounding Box ',
     1                   OALlx,OALly,OUrx,OUry
            CALL ZMORE(CLINE,0)
            READ(IIN, '(A)') CLINE
            CALL ZMORE(CLINE,0)
            READ(IIN, '(A)') CLINE
            CALL ZMORE(CLINE,0)
      ENDIF
      WRITE(IOUT,'(A)') '%!PS-Adobe-2.0 EPSF-1.2'
      WRITE(IOUT,'(A,4I8)') '%%BoundingBox: ',
     1 0, 0, nint(Urx), nint(Ury)
      WRITE(IOUT,'(A)') '%%EndComments'
      WRITE(IOUT,'(A)') CLINE
300   CONTINUE
      NLIN = NLIN + 1
      READ(IIN, '(A)', ERR= 350, END=400) CLINE
      IF (CLINE(7:15) .EQ. 'scalefont') THEN
            WRITE(IOUT,'(I5,1X,A)') IFONT, 'scalefont'
      ELSE IF ( CLINE(1:5) .EQ. '/ywid') THEN
            WRITE(IOUT,'(A,I5,1X,A)')
     1 '/ywid  ', IFONT, 'def'
      ELSE
            IF (NLIN .LE. 12) THEN
                  IF(CLINE(6:17) .EQ. 'setlinewidth') THEN
                  write(iout,'(2f8.2,a)') sc, sc, ' scale' 
                  write(iout,'(f8.2,a)') 0.5/sc,  ' setlinewidth'
                  write(iout,'(2f8.2,a)') 18.-allx, 18.-ally, 
     1            '  translate'
                  goto 300
                  ENDIF
            ENDIF
            CALL XCTRIM( CLINE, NCHAR)
            WRITE(IOUT,'(A)') CLINE(1:NCHAR)
      ENDIF
      GOTO 300
350   CONTINUE
      WRITE(CLINE,*) 'Error while processing file at line', NLIN
      CALL ZMORE(CLINE,0)
400   CONTINUE
      RETURN
      END

