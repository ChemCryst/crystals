CRYSTALS CODE FOR GRAPHICS.FOR                                                  
CODE FOR ZHOME
      SUBROUTINE ZHOME
C This routine returns the cursor to the top left hand corner
C of the screen. Only used for TEK mode.
      
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

      INTEGER ITEK(4)
      INTEGER IX(2),IY(2)
      GOTO (999,999,999,400,999,999,999,999) ISCRN
400   CONTINUE
      IF (ITEKFG.EQ.1) THEN
        CALL ZTEKXY (0,760,ITEK)
      WRITE (IGOUT,111) CGRAPH(27),CGRAPH(104),CGRAPH(29)
      WRITE (IGOUT,112) CGRAPH(ITEK(1)),CGRAPH(ITEK(2)),CGRAPH(ITEK(3)),
     +   CGRAPH(ITEK(4))
111   FORMAT (3A1,$)
112   FORMAT (4A1,$)
      ELSE
        IX(1) = -XCEN + XOFF
        IX(2) = IX(1)
        IY(1) = YCEN + YOFF
        IY(2) = IY(1)
        CALL ZDRLIN(4,IX,IY,2,0,0)
      ENDIF
      INLINE = 1
999   CONTINUE
      RETURN
      END
 
CODE FOR ZCLEAR
      SUBROUTINE ZCLEAR
C This routine clears the screen.
      
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

      CHARACTER*1 CESC,CHX,CHY,CLX,CLY, CGS,CFF
      INTEGER ITEK(4)
      INTEGER IX,IY
      GOTO (100,200,300,400,500,500,700,500) ISCRN
100   CONTINUE
C VGA
      CALL ZVGA
      CALL ZSTCOL
      INLINE = 1
      GOTO 9999
200   CONTINUE
C SIGMA
C     WRITE (11,'('' +-*/FC'')')
      WRITE (11,'('' +-*/DA'')')
      INLINE = 1
      GOTO 9999
300   CONTINUE
C HP LASERJET III
      IF (IPOST.NE.0) THEN
        WRITE (IFOUT,302) CGRAPH(27)
302     FORMAT ('SP0;PU0,0;',A1,'E')
      ELSE
        WRITE (IFOUT,301) CGRAPH(27)
301     FORMAT (A1,'%0B;IN;DF;SC;')
        IPOST = 1
      ENDIF
      GOTO 9999
400   CONTINUE
C TEK
      INLINE = 1
      CESC = CGRAPH(27)
      CFF = CGRAPH(12)
      CGS = CGRAPH(29)
      IX = 0
      IY = 760
      CALL ZTEKXY (IX,IY,ITEK)
      CHY = CGRAPH(ITEK(1))
      CLY = CGRAPH(ITEK(2))
      CHX = CGRAPH(ITEK(3))
      CLX = CGRAPH(ITEK(4))
      WRITE (IGOUT,401) CGS,CHY,CLY,CHX,CLX,CESC,CFF
C      WRITE (IGOUT,'(2I5)') IX,IY,ITEK
401   FORMAT (7A1,$)
      GOTO 9999
500   CONTINUE
C POSTSCRIPT
      IF (IPOST.EQ.0) THEN
C CLEAR IS AT BEGINNING OF DEVICE
        IF (IENCAP.EQ.1) THEN
          WRITE (IFOUT,'(23A)') '%!PS-Adobe-2.0 EPSF-1.2'
C NOTE THAT THE PAGE SIZE WAS SCALED UP BY A FACTOR OF 10 TO
C ALLOW FOR BETTER RESOLUTION.
CDJW - CALL ZESCAL ENSURE THAT THE CORRECT SCALE IS IN THE HEADER
C- CAUSING PROBLEMS REMOVED AGAIN MAR97 -          CALL ZESCAL
          WRITE (IFOUT,503) XEMIN*0.1*RES,YEMIN*0.1*RES
     c    ,XEMAX*0.1*RES,YEMAX*0.1*RES
CDJW
          WRITE (IFOUT,'(13A)') '%%EndComments'
        ENDIF
        WRITE (IFOUT,'(2A)') '%!PS'
        WRITE (IFOUT,'(12A)') '/Ellipse'
        WRITE (IFOUT,'(41A)')
     c  '{gsave x y translate rot rotate 1.0 s scale'
        WRITE (IFOUT,'(19A)') '0 0 rad beg endarc arc'
        WRITE (IFOUT,'(10A)') 'endarc beg sub 360 eq'
        IF (ICPOST.EQ.1) THEN
          WRITE (IFOUT,'(38A)')
     +    '{ gsave r1 g1 b1 setrgbcolor fill grestore } if'
          WRITE (IFOUT,'(33A)')
     +    'r g b setrgbcolor stroke grestore } def'
        ELSE
          WRITE (IFOUT,'(38A)') '{ gsave g setgray fill grestore } if'
          WRITE (IFOUT,'(33A)') '0.0 setgray stroke grestore } def'
        ENDIF
        IPOST = 1
      ENDIF
      IF (IPOST.EQ.1) THEN
        IF (IENCAP.EQ.0) THEN
          WRITE (IFOUT,'(47A)')
     C   '300 420 translate 90 rotate -420 -300 translate'
          WRITE (IFOUT,501) 1.0/RES, 1.0/RES
CDJWMAR97 ENDIF MOVED UP 2 LINES
        ENDIF
C SET LINE WIDTH
          WRITE (IFOUT,502) 0.5*RES
      ENDIF
      IF (IPOST.EQ.2) THEN
C CLEAR IF AT END OF PAGE
        IF (IENCAP.EQ.0)  WRITE (IFOUT,'(8A)') 'showpage'
        IPOST = 1
      ENDIF
501   FORMAT (F4.2,2X,F4.2,' scale')
502   FORMAT (F4.2,' setlinewidth')
503   FORMAT ('%%BoundingBox: ',4F8.0)
      GOTO 9999
700   CONTINUE
C EGA
      CALL ZEGA
      CALL ZSTCOL
      INLINE = 1
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR
      SUBROUTINE ZCLARE (IBORD,ICOL)
C This routine clears an area of the screen to colour ICOL with a border of
C width IBORD.
      
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

      INTEGER ICOL,IX1,IY1,IX2,IY2
C      CHARACTER*1 HEX(16),A
C      DATA HEX/'0','1','2','3','4','5','6','7','8','9','A',
C     c 'B','C','D','E','F'/
      IX1 = IBORD + XOFF
      IY1 = IBORD + YOFF
      IX2 = (2*INT(XCEN)) - IBORD + XOFF
      IY2 = (2*INT(YCEN)) - IBORD + YOFF
      GOTO (100,200,300,400,500,500,100,500) ISCRN
100   CONTINUE
C VGA
      CALL ZCLRA(IX1,IY1,IX2,IY2,ICOL)
      GOTO 9999
200   CONTINUE
C SIGMA
      IX1 = IX1 + 100
      IY1 = IY1 + 100
      IX2 = IX2 + 100
      IY2 = IY2 + 100
C CHANGE COLOUR
C      WRITE (11,'('' +-*/HI'',A1)') HEX(ICOL+1)
C MOVE CURSOR TO IX1,IY1
C      WRITE (11,'('' +-*/GI'',2I3)') IX1,IY1
C DRAW A SOLID BLOCK TO IX2,IY2
C      WRITE (11,'('' +-*/GJFHBG'',2I3)') IX2,IY2
      GOTO 9999
300   CONTINUE
      GOTO 9999
400   CONTINUE
C TEK
C THIS IS ONLY USED FOR TEK WHILE IN CURSOR MODE
      IF (ICURS.EQ.1) CALL ZCLEAR
      GOTO 9999
500   CONTINUE
C POSTSCRIPT
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZDRBND [ DRAW BOND ]
      SUBROUTINE ZDRBND (ISTYL,IX,IY,N,IBCL,IATNO,IATNO1,ITYPE)
C This routine sets up the bond drawing routine.
C ISTYL = 0 full line (default)
C ISTYL = 1 dashed line
C ISTYL = 2 dotted line
C ITYPE = 0 normal bond
C ITYPE = 1 single line split bond
      
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

      INTEGER IX(N),IY(N),IRAD
      INTEGER IXX(4),IYY(4),IBCL
C Do full bonds
      IF (ISTYL.EQ.0) THEN
        IF (ITYPE.EQ.0) THEN
          CALL ZDRLIN (4,IX,IY,N,IDEVCL(IBCL+1),IATNO)
          RETURN
        ELSE
C WE HAVE A COLOUR SPLIT BOND - UNLESS THIS IS A DUMMY OR CELL ATOM
          IF (NINT(RSTORE(IATNO)).LT.4) THEN
            IBCL = NINT (RSTORE ( IATNO + IATTYP + 1 ))
          ENDIF
C FIND THE CENTRE POINT
          IXX(1) = IX(1)
          IYY(1) = IY(1)
          IXX(2) = (IX(1)+IX(2))/2
          IYY(2) = (IY(1)+IY(2))/2
          CALL ZDRLIN (4,IXX,IYY,2,IDEVCL(IBCL+1),IATNO)
          IF (NINT(RSTORE(IATNO)).LT.4) THEN
            IBCL = NINT ( RSTORE (IATNO1 + IATTYP + 1 ))
          ENDIF
          IXX(1) = IX(2)
          IYY(1) = IY(2)
          CALL ZDRLIN (4,IXX,IYY,2,IDEVCL(IBCL+1),IATNO)
          RETURN
        ENDIF
      ENDIF
      IF (ISTYL.EQ.2) THEN
C FIND LENGTH
        D = SQRT (FLOAT((IX(1)-IX(2))**2 + (IY(1)-IY(2))**2))
        NSTEP = D/(0.2*SCALE)
        IRAD = NINT ( RTHICK * SCALE )
C LOOP ALONG THE LINE
        DO 30 I = 0,NSTEP-1
          IXX(1) = IX(1) + (IX(2)-IX(1))*I/NSTEP
          IYY(1) = IY(1) + (IY(2)-IY(1))*I/NSTEP
          IF (IRAD.EQ.0) THEN
            IXX(2) = IXX(1)
            IYY(2) = IYY(1)
            CALL ZDRLIN(4,IXX,IYY,2,IDEVCL(IBCL+1),IATNO)
          ELSE
           CALL ZDRELL(2,IXX(1),IYY(1),IRAD,IRAD,IDEVCL(IBCL+1),1,IATNO)
          ENDIF
30      CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZDRLIN
      SUBROUTINE ZDRLIN(ITYPE,IX,IY,N,ICOL,IATNO)
C THIS ROUTINE DRAWS A POLYGON WITH N POINTS
C IT FILLS THE POLYGON IF ITYPE=2
C IF ITYPE=3 WE HAVE TO DIVIDE UP THE LINE
C IF ITYPE =4 JUST DRAW WITHOUT CHECKING FOR OVERLAP.
C IF ITYPE = 5 THEN POLYGON FOR HPGL (1ST ONE)
C IF ITYPE = 6 THEN POLYGON FOR HPGL (2ND +  ONE)
C IF ITYPE = 7 THEN POLYGON CLOSE FOR HPGL
C          = 8 ONLY ONE POLYGON IN THIS LIST
      
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

      INTEGER IX1,IY1,IX2,IY2,IX(N),IY(N),ICOL
      INTEGER ITEK(4)
      CHARACTER*1 CHY,CLY,CHX,CLX
      CHARACTER*1 CGS, CESC, CH
      CHARACTER*1 HEX(16)
      DATA HEX/'0','1','2','3','4','5','6','7','8','9','A',
     c 'B','C','D','E','F'/
C SET UP CHARACTERS FOR TEK DRIVER
      CH = CGRAPH(104)
      CGS = CGRAPH(29)
      CESC = CGRAPH(27)
      IXX = 2
      IXX = IXX * 4
      NN = N
      DO 20 IXX= 1,NN
      IX(IXX) = IX(IXX) + INT(XCEN + XOFF)
      IY(IXX) = IY(IXX) + INT(YCEN + YOFF)
20    CONTINUE
      GOTO (100,200,300,400,500,500,100,500) ISCRN
100   CONTINUE
C VGA
C FOR VGA ALL TYPES EXCEPT 2 (FILL POLYGON) ARE THE SAME AS
C THE DEVICE IS A RASTER ONE.
      IF (ITYPE.NE.2) THEN
        IF (N.GT.2) THEN
          IF (N.LT.6) THEN
            CALL ZPLINE(IX,IY,N,IFORE)
          ELSE
            CALL ZPLINE(IX,IY,N,ICOL)
          ENDIF
        ELSE
          CALL ZDLINE(IX(1),IY(1),IX(2),IY(2),ICOL)
        ENDIF
      ELSE
        CALL ZPOLGN (IX,IY,N,ICOL)
C        CALL ZCPLGN(IX,IY,N,HANDLE,ERROR)
C        CALL ZFPLGN(HANDLE,ICOL,ERROR)
C        CALL ZDPLGN(HANDLE,ERROR)
      ENDIF
      GOTO 9999
200   CONTINUE
C SIGMA
      WRITE (11,'('' +-*/FC'')')
      WRITE (11,'('' +-*/GI'',2I3)') IX(1)+100,IY(1)+100
      WRITE (11,'('' +-*/HI'',A1)') HEX(ICOL+1)
      DO 10 I = 2,N
        WRITE (11,'('' +-*/GJ'',2I3)') IX(I)+100,IY(I)+100
10    CONTINUE
      IF (ITYPE.EQ.2) THEN
C FILL THE POLYGON - PLACE THE SEED
C THE SEED LIES ON THE LINE BETWEEN POINTS 1 AND 4
        IXS = (IX(1)+IX(4))/2
        IYS = (IY(1)+IY(4))/2
        WRITE (11,'('' +-*/GI'',2I3)') IXS,IYS
        WRITE (11,'('' +-*/JK'',A1)') HEX(ICOL+1)
      ENDIF
      GOTO 9999
300   CONTINUE
C NON RASTER
C FOR A POLYLINE WE HAVE TO CHECK EACH POINT IN TURN.
      IF (ITYPE.EQ.2) GOTO 9999
      IF (ITYPE.EQ.5.OR.ITYPE.EQ.8) THEN
        WRITE (IFOUT,301) (16 - ICOL )  * 100 / 16
301     FORMAT ('FT10,',I3,';')
       IF ((IOVER.EQ.0).OR.(ITYPE.GE.4)) THEN
C NEED TO MOVE TO START POINT AND THEN LOOP OVER REMAINING POINTS
        WRITE (IFOUT,302) IX(1),IY(1)
302     FORMAT ('SP0;PA',I6,',',I6,';')
       ENDIF
        IF (ITYPE.EQ.5.OR.ITYPE.EQ.8) THEN
          WRITE (IFOUT,'(A)') 'PM0;'
        ENDIF
        WRITE (IFOUT,303) IX(2),IY(2)
303     FORMAT ('PD',I6,',',I6)
        WRITE (IFOUT,304) (IX(I),IY(I),I=3,N-1)
304     FORMAT (',',I6,',',I6)
        WRITE (IFOUT,305) IX(N),IY(N)
305     FORMAT (',',I6,',',I6,';')
        IF (ITYPE.LT.7) THEN
          WRITE (IFOUT,'(A)') 'PM1;'
        ELSE
          WRITE (IFOUT,'(A)') 'PM2;FP;'
        ENDIF
        GOTO 9999
      ENDIF
      IF (ITYPE.EQ.3) THEN
        DO 40 I = 2,N
C IF ITYPE=3 DIVIDE UP THE LINE FURTHER
C FIND LINE LENGTH
          RL = SQRT(FLOAT((IX(I-1)-IX(I))**2+(IY(I-1)-IY(I))**2))
          IL = NINT(RL)
          RLX =  (IX(I)-IX(I-1)) / RL
          RLY =  (IY(I)-IY(I-1)) / RL
          DO 50 J = 1,IL
            X1 = FLOAT(IX(I-1))+RLX*J-XCEN-XOFF
            Y1 = FLOAT(IY(I-1))+RLY*J-YCEN-YOFF
            CALL ZOLAP (X1,Y1,IDRAW,IATNO)
            IF (IDRAW.NE.0) THEN
              IX2 = X1 + XCEN + XOFF
              IY2 = Y1 + YCEN + YOFF
              IX1 = X1 + XCEN + XOFF - RLX
              IY1 = Y1 + YCEN + YOFF - RLY
306           FORMAT ('SP0;PU',I8,',',I8,';SP1;LT;PD',I8,',',I8,';'
     c        ,'SP0;')
              WRITE (IFOUT,306) IX1,IY1,IX2,IY2
            ENDIF
50        CONTINUE
40      CONTINUE
      ELSE
        DO 60 I = 2,N
          X = FLOAT(IX(I)) - XCEN - XOFF
          Y = FLOAT(IY(I)) - YCEN - YOFF
          CALL ZOLAP (X,Y,IDRAW,IATNO)
          IF (IDRAW.NE.0) THEN
            WRITE (IFOUT,306) IX(I),IY(I),IX(I-1),IY(I-1)
            CALL ZDLINE(IX(I),IY(I),IX(I-1),IY(I-1),ICOL)
          ENDIF
60      CONTINUE
      ENDIF
      GOTO 9999
400   CONTINUE
C TEK
C NON RASTER
C FOR A POLYLINE WE HAVE TO CHECK EACH POINT IN TURN.
      IF (ITYPE.EQ.2) GOTO 9999
C ITYPE =4 OCCURS WHEN DRAWING BOND LINES AS THE OVERLAP
C FOR THESE HAS ALREADY BEEN DONE.
      IF ((IOVER.EQ.0).OR.(ITYPE.EQ.4)) THEN
401     FORMAT (A,$)
403     FORMAT (2A,$)
402     FORMAT (4A,$)
        IDRAWN = 0
        III = 1
        DO 410 I = 1 , N
C CHECK THAT THE POINT LIES ON THE SCREEN
C THE POINTS MAY GO OFF THE SCREEN FOR CURSOR ROTATION OR FIXED SCALING
C          III = LPCHCK(IX,IY,I,N,IXX,IYY)
          IF (III.NE.0) THEN
C          CALL ZTEKXY (IXX,IYY,ITEK)
            CALL ZTEKXY (IX(I),IY(I),ITEK)
            CHY = CGRAPH(ITEK(1))
            CLY = CGRAPH(ITEK(2))
            CHX = CGRAPH(ITEK(3))
            CLX = CGRAPH(ITEK(4))
C DID WE DRAW TO THE PREVIOUS POINT?
C SEND MOVE COMMAND IF NOT
            IF (IDRAWN.EQ.0) THEN
              WRITE (IGOUT,403) CESC,CH
              WRITE (IGOUT,401) CGS
            ENDIF
           WRITE (IGOUT,402) CHY,CLY,CHX,CLX
            IF (III.EQ.-1) THEN
C WE HAVE DRAWN A MOVED POINT - NOT THE ORIGINAL POINT.
              IDRAWN = 0
            ELSE
              IDRAWN = 1
            ENDIF
          ELSE
            IDRAWN = 0
          ENDIF
410     CONTINUE
      ELSE IF (ITYPE.EQ.3) THEN
        DO 440 I = 2,N
C IF ITYPE=3 DIVIDE UP THE LINE FURTHER
C FIND LINE LENGTH
          RL = SQRT(FLOAT((IX(I-1)-IX(I))**2+(IY(I-1)-IY(I))**2))
          IL = NINT(RL)
          RLX =  (IX(I)-IX(I-1)) / RL
          RLY =  (IY(I)-IY(I-1)) / RL
          DO  450 J = 1,IL
            X1 = FLOAT(IX(I-1))+RLX*J-XCEN - XOFF
            Y1 = FLOAT(IY(I-1))+RLY*J-YCEN - YOFF
            IF (X1.LT.-XCEN .OR. X1 .GT. XCEN .OR.
     +      Y1 .LT. -YCEN .OR. Y1 .GT. YCEN) THEN
              IDRAW = 0
            ELSE
              CALL ZOLAP (X1,Y1,IDRAW,IATNO)
            ENDIF
            IF (IDRAW.NE.0) THEN
              IX2 = X1 + XCEN + XOFF
              IY2 = Y1 + YCEN + YOFF
              IX1 = X1 + XCEN + XOFF - RLX
              IY1 = Y1 + YCEN + YOFF - RLY
             IF (IX1.NE.IX2.AND.IY1.NE.IY2) THEN
                WRITE (IGOUT,403) CESC,CH
                WRITE (IGOUT,401) CGS
                CALL ZTEKXY (IX1,IY1,ITEK)
              CHY = CGRAPH(ITEK(1))
               CLY = CGRAPH(ITEK(2))
               CHX = CGRAPH(ITEK(3))
               CLX = CGRAPH(ITEK(4))
                WRITE (IGOUT,402) CHY,CLY,CHX,CLX
                CALL ZTEKXY (IX2,IY2,ITEK)
              CHY = CGRAPH(ITEK(1))
               CLY = CGRAPH(ITEK(2))
               CHX = CGRAPH(ITEK(3))
               CLX = CGRAPH(ITEK(4))
                WRITE (IGOUT,402) CHY,CLY,CHX,CLX
              ENDIF
            ENDIF
450       CONTINUE
440     CONTINUE
      ELSE
C WE NEED TO DO THE OVERLAP CALCULATIONS POINT BY POINT.
C THE CURRENT START POINT WILL BE ISP AND THE CURRENT END POINT
C WILL BE IEP
       IF20 = 0
       ISP = 0
       IEP = 0
       DO 420 I = 1 , N
         X = IX(I) - XCEN - XOFF
          Y = IY(I) - YCEN - YOFF
C        CALL ZOLAP (X,Y,IDRAW,IATNO)
          IF (X.LT.-XCEN .OR. X .GT. XCEN .OR. Y .LT. -YCEN
     +    .OR. Y .GT. YCEN) THEN
             IDRAW = 0
          ELSE
            CALL ZOLAP (X,Y,IDRAW,IATNO)
          ENDIF
         IF (IDRAW.NE.0) THEN
C WE CAN DRAW THIS POINT
           IF (ISP.EQ.0) THEN
             ISP = I
           ELSE IF (I.EQ.N) THEN
             IEP = I
           ENDIF
         ELSE IF ((I.GT.1).AND.(ISP.GT.0)) THEN
           IEP = I-1
         ENDIF
C THE FLAG IF20 IS USED SO THAT NOT MORE THAN 20 LINES ARE
C OUTPUT AT ONCE (THIS SEEMS TO MESS UP THE PICTURE)
C AND SO THAT THE FINAL POINT OF THE 20 IS USED AS THE START
C POINT OF THE NEXT LINE.
         IF ((I-ISP.GT.10).AND.(ISP.GT.0)) THEN
           IEP = I
           IF20 = 1
         ENDIF
          IF (IEP.NE.0) THEN
C NOW WE CAN DRAW THE LINE BETWEEN THE POINTS ISP AND IEP
           WRITE (IGOUT,403) CESC,CH
           WRITE (IGOUT,401) CGS
           DO 430 J = ISP , IEP
             CALL ZTEKXY (IX(J),IY(J),ITEK)
             CHY = CGRAPH(ITEK(1))
             CLY = CGRAPH(ITEK(2))
             CHX = CGRAPH(ITEK(3))
             CLX = CGRAPH(ITEK(4))
             WRITE (IGOUT,402) CHY,CLY,CHX,CLX
430         CONTINUE
           IEP = 0
           ISP = 0
         ENDIF
         IF (IF20.EQ.1) THEN
           ISP = I
           IF20 = 0
         ENDIF
420     CONTINUE
      ENDIF
      GOTO 9999
500   CONTINUE
C POSTSCRIPT
      WRITE (IFOUT,'(7A)') 'newpath'
      WRITE (IFOUT,501) IX(1)/10.0,IY(1)/10.0, ' moveto'
      DO 510 I = 2,N
      IF ( (IX(I).EQ.IX(I-1) ) .AND. (IY(I).EQ.IY(I-1) ) ) GOTO 510
      WRITE (IFOUT,501) IX(I)/10.0,IY(I)/10.0, ' lineto'
510   CONTINUE
      WRITE (IFOUT,'(9A)') 'closepath'
 
      IF (ITYPE.EQ.2) THEN
        WRITE (IFOUT,'(A)') 'gsave'
        IF (ICPOST.EQ.1) THEN
C SEND THE COLOURS
          WRITE (IFOUT,511) IPSTCL(1,ICOL+1)/100.0,
     +    IPSTCL(2,ICOL+1)/100.0, IPSTCL(3,ICOL+1)/100.0
511       FORMAT (F5.3,' ',F5.3,' ',F5.3,' setrgbcolor')
        ELSE
          C = (ICOL+1)/16.0
          WRITE (IFOUT,502) C
502       FORMAT (F3.1,' setgray')
        ENDIF
        WRITE (IFOUT,'(4A)') 'fill'
        WRITE (IFOUT,'(A)') 'grestore'
      ENDIF
      IF (ICPOST.EQ.1) THEN
C FOR SINGLE LINES DRAW IN COLOUR
        IF (N.EQ.2) THEN
          WRITE (IFOUT,511) IPSTCL(1,ICOL+1)/100.0,
     +    IPSTCL(2,ICOL+1)/100.0, IPSTCL(3,ICOL+1)/100.0
        ELSE
          WRITE (IFOUT,'(14A)') '0 0 0 setrgbcolor'
        ENDIF
      ELSE
        WRITE (IFOUT,'(9A)') '0 setgray'
      ENDIF
      WRITE (IFOUT,'(6A)') 'stroke'
501   FORMAT (F7.2,2X,F7.2,6A)
      GOTO 9999
9999  CONTINUE
      DO 30 I = 1,N
      IX(I) = IX(I) - INT(XCEN+XOFF)
      IY(I) = IY(I) - INT(YCEN+YOFF)
30    CONTINUE
      RETURN
      END
 
CODE FOR ZDRTEX
      SUBROUTINE ZDRTEX(IX,IY,TEXT,ICOL)
      
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

      INTEGER IX,IY,ICOL
      INTEGER ITEK(4)
      CHARACTER*(*) TEXT
      CHARACTER*1 HEX(16),CGS,CHY,CLY,CLX,CHX,CUS
      SAVE HEX
      DATA HEX/'0','1','2','3','4','5','6','7','8','9','A',
     c 'B','C','D','E','F'/
      GOTO (100,200,300,400,500,500,100,500) ISCRN
100   CONTINUE
C VGA
      CALL ZDTEXT(TEXT,IX+INT(XCEN+XOFF),IY+INT(YCEN+YOFF),ICOL)
      GOTO 9999
200   CONTINUE
C SIGMA
      WRITE (11,'('' +-*/HI'',A1)') HEX(ICOL+1)
      WRITE (11,'('' +-*/GI'',2I3)') IX+INT(XCEN+XOFF)+100,
     c IY+INT(YCEN+YOFF)+100
      WRITE (11,'('' +-*/BA'',A6)') TEXT
      GOTO 9999
300   CONTINUE
C HPGL
      WRITE (IFOUT,301) IX+INT(XCEN+XOFF), IY+INT(YCEN+YOFF)
301   FORMAT ('SP1;SI;PA',I8,',',I8,';LO3;')
      WRITE (IFOUT,302) TEXT, CGRAPH(3)
302   FORMAT ('LB',A)
      GOTO 9999
400   CONTINUE
C TEK
      CGS = CHAR(29)
      CUS = CHAR(31)
      WRITE (IGOUT,401) CGS
      CALL ZTEKXY (IX+INT(XCEN+XOFF),IY+INT(YCEN+YOFF),ITEK)
      CHY = CGRAPH (ITEK(1))
      CLY = CGRAPH (ITEK(2))
      CHX = CGRAPH (ITEK(3))
      CLX = CGRAPH (ITEK(4))
      WRITE (IGOUT,402) CHY,CLY,CHX,CLX
      WRITE (IGOUT,401) CUS
      WRITE (IGOUT,403) TEXT
401   FORMAT (A1,$)
402   FORMAT (4A1,$)
403   FORMAT (A,$)
      GOTO 9999
500   CONTINUE
C POSTSCRIPT
      IF (ISCRN.EQ.8) THEN
        WRITE (IFOUT,'(14A)') '0 0 0 setrgbcolor'
      ELSE
        WRITE (IFOUT,'(A)') '0 setgray'
      ENDIF
C      WRITE (IFOUT,'(17A)') '/Times-Roman findfont '
      WRITE (IFOUT,'(17A)') '/Helvetica-Bold findfont '
      WRITE (IFOUT,503) IFONT
      WRITE (IFOUT,'(7A)') 'setfont'
      WRITE (IFOUT,504) IFONT
      WRITE (IFOUT,501) (IX+INT(XCEN+XOFF))/10.0,
     + (IY+INT(YCEN+YOFF))/10.0
      WRITE (IFOUT,502) TEXT
501   FORMAT (F7.2,2X,F7.2,' ywid sub moveto')
502   FORMAT ('(',A,') show')
503   FORMAT (I5,' scalefont ')
504   FORMAT ('/ywid ',I5,' def')
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZDRELL
      SUBROUTINE ZDRELL (ITYPE,IXC,IYC,IMAJ,IMIN,ICOL,IFTYPE,IATNO)
C This routines draws an ELLIPSE with major/minor axes IMAJ/IMIN
C in colour ICOL.
C ITYPE = 1 - outline of ELLIPSE
C ITYPE = 2 - solid ELLIPSE
C IFTYPE = 2 -SMALL CIRCLE
C IATNO = number of atom we are drawing
      
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

      INTEGER IXC,IYC,IMAJ,IMIN,ICOL
      CHARACTER*1 HEX(16)
      INTEGER IX(91),IY(91)
      DATA HEX/'0','1','2','3','4','5','6','7','8','9','A',
     c 'B','C','D','E','F'/
      GOTO (100,200,300,300,500,500,100,500) ISCRN
100   CONTINUE
C VGA
      IF (ITYPE.EQ.1) THEN
        CALL ZVGAEL(IXC+INT(XCEN+XOFF),IYC+INT(YCEN+YOFF)
     +,IMAJ,IMIN,ICOL)
      ELSE
        CALL ZFILEL(IXC+INT(XCEN+XOFF),IYC+INT(YCEN+YOFF)
     + ,IMAJ,IMIN,ICOL)
      ENDIF
      GOTO 9999
200   CONTINUE
C SIGMA
      IELL = (256 * IMAJ / IMIN) + 100
      IELL1 = (IMAJ+100)*10
C MOVE CURSOR
      WRITE (11,'('' +-*/GI'',2I3)') IXC+100+INT(XCEN+XOFF)
     c ,IYC+100+INT(YCEN+YOFF)
C CHANGE COLOUR TO ICOL
      WRITE (11,'('' +-*/HI'',A1)') HEX(ICOL+1)
C SET UP SHAPE OF ELLIPSE
      WRITE (11,'('' +-*/JO'',I3)') IELL
C DRAW THE ELLIPSE
      IF (ITYPE.EQ.1) THEN
        WRITE (11,'('' +-*/JM'',I4)') IELL1
            ELSE
        WRITE (11,'('' +-*/JN'',I4)') IELL1
            ENDIF
      GOTO 9999
300   CONTINUE
C CANNOT DO SOLID CIRCLES FOR THIS TYPE OF DEVICE
      IF (ITYPE.EQ.2) RETURN
      ISTEP = 4 + 250/IMAJ
C NON RASTER GENERATE CIRCLE AND CHECK FOR OVERLAP
      K = 1
      DO 310 I = 1 , 361 , ISTEP
      IX(K) = IMAJ * XCOS(I) + IXC
      IY(K) = IMAJ * XSIN(I) + IYC
      K = K + 1
310   CONTINUE
      IX(K) = IX(1)
      IY(K) = IY(1)
      CALL ZDRLIN(1,IX,IY,K,IDEVCL(ICOL+1),IATNO)
      GOTO 9999
500   CONTINUE
C POSTSCRIPT
      IF (ITYPE.EQ.1) RETURN
C DONT NEED TO DO OUTLINE SEPERATELY
      WRITE (IFOUT,'(7A)') 'newpath'
      WRITE (IFOUT,501) (IXC+INT(XCEN+XOFF))/10.0
     + ,(IYC+INT(YCEN+YOFF))/10.0
     + ,IMAJ/10.0
501   FORMAT ( 3(F7.2,2X),' 0 360 arc' )
      WRITE (IFOUT,'(9A)') 'closepath'
      IF (IFTYPE.NE.2) WRITE (IFOUT,'(5A)') 'gsave'
      IF (IFILL.EQ.0 .AND. ICPOST.EQ.0) THEN
        WRITE (IFOUT,'(9A)') '1 setgray'
      ELSE
C NEED TO DO COLOUR
        IF (ICPOST.EQ.1) THEN
          IF (IFILL.EQ.0) THEN
            WRITE (IFOUT,'(14A)') '1 1 1 setrgbcolor'
          ELSE
          WRITE (IFOUT,511) IPSTCL(1,ICOL+1)/100.0,
     +    IPSTCL(2,ICOL+1)/100.0,IPSTCL(3,ICOL+1)/100.0
511       FORMAT (F5.2,' ',F5.2,' ',F5.2,' setrgbcolor')
          ENDIF
        ELSE
          C = ICOL/15.0
          WRITE (IFOUT,502) C
502       FORMAT (F3.1,' setgray')
        ENDIF
      ENDIF
      WRITE (IFOUT,'(4A)') 'fill'
      IF (IFTYPE.NE.2) THEN
        WRITE (IFOUT,'(7A)') 'grestore'
        IF (ICPOST.EQ.1) THEN
          IF (IFILL.GE.1) THEN
            WRITE (IFOUT,'(14A)') '0 0 0 setrgbcolor'
          ELSE
            WRITE (IFOUT,511) IPSTCL(1,ICOL+1)/100.0,
     +      IPSTCL(2,ICOL+1)/100.0,IPSTCL(3,ICOL+1)/100.0
          ENDIF
        ELSE
          WRITE (IFOUT,'(9A)') '0 setgray'
        ENDIF
        WRITE (IFOUT,'(6A)') 'stroke'
      ENDIF
9999  CONTINUE
      RETURN
      END
 
 
CODE FOR ZDRELL
      SUBROUTINE ZZDRELL (ITYPE,IXC,IYC,IMAJ,IMIN,ICOL,IFTYPE,IATNO)
C This routines draws an ELLIPSE with major/minor axes IMAJ/IMIN
C in colour ICOL.
C ITYPE = 1 - outline of ELLIPSE
C ITYPE = 2 - solid ELLIPSE
C IFTYPE = 2 -SMALL CIRCLE
C IATNO = number of atom we are drawing
      
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

      INTEGER IXC,IYC,IMAJ,IMIN,ICOL
      CHARACTER*1 HEX(16)
      INTEGER IX(90),IY(90)
      DATA HEX/'0','1','2','3','4','5','6','7','8','9','A',
     c 'B','C','D','E','F'/
      GOTO (100,200,300,300,500,500,100,500) ISCRN
100   CONTINUE
C VGA
      IF (ITYPE.EQ.1) THEN
        CALL ZVGAEL(IXC+INT(XCEN+XOFF),IYC+INT(YCEN+YOFF)
     + ,IMAJ,IMIN,ICOL)
      ELSE
        CALL ZFILEL(IXC+INT(XCEN+XOFF),IYC+INT(YCEN+YOFF)
     + ,IMAJ,IMIN,ICOL)
      ENDIF
      GOTO 9999
200   CONTINUE
C SIGMA
      IELL = (256 * IMAJ / IMIN) + 100
      IELL1 = (IMAJ+100)*10
C MOVE CURSOR
      WRITE (11,'('' +-*/GI'',2I3)') IXC+100+INT(XCEN+XOFF)
     c ,IYC+100+INT(YCEN+YOFF)
C CHANGE COLOUR TO ICOL
      WRITE (11,'('' +-*/HI'',A1)') HEX(ICOL+1)
C SET UP SHAPE OF ELLIPSE
      WRITE (11,'('' +-*/JO'',I3)') IELL
C DRAW THE ELLIPSE
      IF (ITYPE.EQ.1) THEN
        WRITE (11,'('' +-*/JM'',I4)') IELL1
            ELSE
        WRITE (11,'('' +-*/JN'',I4)') IELL1
            ENDIF
      GOTO 9999
300   CONTINUE
C CANNOT DO SOLID CIRCLES FOR THIS TYPE OF DEVICE
      IF (ITYPE.EQ.2) RETURN
      ISTEP = 4 + 250/IMAJ
C NON RASTER GENERATE CIRCLE AND CHECK FOR OVERLAP
      K = 1
      DO 310 I = 1 , 361 , ISTEP
      IX(K) = IMAJ * XCOS(I) + IXC
      IY(K) = IMAJ * XSIN(I) + IYC
      K = K + 1
310   CONTINUE
      CALL ZDRLIN(1,IX,IY,K-1,IDEVCL(ICOL+1),IATNO)
      GOTO 9999
500   CONTINUE
C POSTSCRIPT
      IF (ITYPE.EQ.1) RETURN
C DONT NEED TO DO OUTLINE SEPERATELY
      WRITE (IFOUT,'(7A)') 'newpath'
      WRITE (IFOUT,501) (IXC+INT(XCEN+XOFF))/10.0,
     + (IYC+INT(YCEN+YOFF))/10.0
     + ,IMAJ/10.0
501   FORMAT ( 3(F7.2,2X),' 0 360 arc' )
      WRITE (IFOUT,'(9A)') 'closepath'
      WRITE (IFOUT,'(5A)') 'gsave'
      IF (IFILL.EQ.0) THEN
        WRITE (IFOUT,'(9A)') '1 setgray'
      ELSE
        IF (ICPOST.EQ.0) THEN
C NEED TO DO COLOUR
          C = ICOL/15.0
          WRITE (IFOUT,502) C
502     FORMAT (F3.1,' setgray')
        ELSE
          WRITE (IFOUT,503) IPSTCL(1,ICOL+1),IPSTCL(2,ICOL+1),
     +    IPSTCL(3,ICOL+1)
503       FORMAT (F5.2,' ',F5.2,' ',F5.2,' setrgbcolor')
        ENDIF
      ENDIF
      WRITE (IFOUT,'(4A)') 'fill'
      WRITE (IFOUT,'(7A)') 'grestore'
      WRITE (IFOUT,'(9A)') '0 setgray'
      WRITE (IFOUT,'(6A)') 'stroke'
9999  CONTINUE
      RETURN
      END
 
 
CODE FOR ZGETKY
      SUBROUTINE ZGETKY(K)
C THIS ROUTINE WAITS FOR A KEY PRESS
      
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

      INTEGER K
      GOTO (100,200,100,100,100,100,100,100) ISCRN
100   CONTINUE
C VGA
      CALL ZGTKEY(K)
      GOTO 9999
200   CONTINUE
C SIGMA/VAX
      GOTO 9999
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZTXTMD
      SUBROUTINE ZTXTMD
C THIS ROUTINE RETURNS THE SCREEN TO TEXT MODE
      logical lopen
      
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

      GOTO (100,200,300,400,500,500,100,500) ISCRN
100   CONTINUE
C VGA
      CALL ZTMODE
      GOTO 9999
200   GOTO 9999
300   CONTINUE
      WRITE (IFOUT,301) CGRAPH(27) ,CGRAPH(27)
301   FORMAT ('SP0;PU0,0;',A1,'%0A',A1,'E')
      GOTO 9999
400   CONTINUE
      CALL ZTMODE
C RETURN TO TEXT MODE
      WRITE (IGOUT,'(A1,$)') CGRAPH(24)
      GOTO 9999
C PLOTTER
500   CONTINUE
C POSTSCRIPT
      inquire(unit=ifout, opened=lopen)
      if (lopen ) WRITE (IFOUT,'(A8)') 'showpage'
9999  CONTINUE
      RETURN
      END
 
CODE FOR ZCHARW [ CHECK ARROW ]
      SUBROUTINE ZCHARW(A,B)
      
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

C SETS THE VALUE OF IMENAR
      IMENAR = 0
      IF (A.GT.IMENU(1,1)) THEN
        IMENAR = 1
      ENDIF
      IF (B.LT.IMENU(1,2)) THEN
        IMENAR = IMENAR + 2
      ENDIF
      RETURN
      END
 
CODE FOR ZCIRCL
      SUBROUTINE ZCIRCL(I,ITYPE)
C I is the number of the atom to be drawn.
C ITYPE = 1 draw circle radius R
C       = 2 draw circle radius R/2
C ITYPE = 3 draw circle with eigenvalue radius
      
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

      INTEGER IX,IY,IRAD,IRRAD,ICOL,IXX(3),IYY(3),IWHITE
      IF ((ITYPE.EQ.2).AND.(ISCRN.NE.1 .AND. ISCRN.NE.7
     + .AND. ICPOST.EQ.0)) RETURN
      IWHITE = 15
      IF (ISCRN.EQ.1 .OR. ISCRN.EQ.7 .OR. ICPOST.EQ.1) THEN
        IDOT = 1
      ELSE
        IDOT = 0
      ENDIF
C IF IDOT = 1 THEN WE DRAW THE HIGHLIGHT DOT.
      ISTEP = 1.0
      ICOL = NINT(RSTORE(I+IATTYP+1))
      IF (ITYPE.EQ.1) THEN
        R = RSTORE (I+IATTYP+4)
      ELSE IF (ITYPE.EQ.2) THEN
        R = RSTORE (I+IATTYP+4)/2.0
      ELSE
        R = SQRT(ABS(RSTORE(I+IXYZO+12)))
      ENDIF
C GET ATOM COORDINATES
      X = RSTORE (I+IXYZO)
      Y = RSTORE (I+IXYZO+1)
C SCALE COORDINATES
      IX = NINT((X-XCP)*SCALE)
      IY = NINT((Y-YCP)*SCALE)
      IRAD = INT(R*SCALE)
      IF (IFILL.GE.1) THEN
         CALL ZDRELL(2,IX,IY,IRAD,IRAD,IDEVCL(ICOL+1),ITYPE,I)
           IF (IDOT.EQ.1.AND.(ITYPE.EQ.1 .AND. IFILL .EQ. 1)) THEN
C CALCULATE THE POSITION OF THE WHITE CIRCLE
           IXX(1) = IX + IRAD*0.4
           IF (IHAND.EQ.0) THEN
             IYY(1) = IY + IRAD*0.25
           ELSE
             IYY(1) = IY - IRAD*0.25
           ENDIF
           IRRAD = IRAD*0.25
           IF (IRRAD.LT.1) RETURN
           CALL ZDRELL(2,IXX(1),IYY(1),IRRAD,IRRAD,IDEVCL(IWHITE+1)
     c     ,2,I)
C OFFSET COLOURED CIRCLE
        ENDIF
      ELSE
         CALL ZDRELL(2,IX,IY,IRAD,IRAD,IDEVCL(IBACK+1),ITYPE,I)
      ENDIF
C      IF (IFILL.EQ.0 .AND. ITYPE.NE.2) THEN
C      IF (((ITYPE.EQ.1).AND.(IFILL.EQ.0)).OR.(ITYPE.EQ.3)) THEN
C        CALL ZDRELL(1,IX,IY,IRAD,IRAD,IDEVCL(ICOL+1),ITYPE,I)
C      ELSE IF (IFILL.EQ.1.AND.ITYPE.EQ.3) THEN
C        CALL ZDRELL(1,IX,IY,IRAD,IRAD,IDEVCL(IFORE+1),ITYPE,I)
C      ENDIF
      IF (ISCRN.EQ.4 .OR. (IFILL.EQ.0 .AND. ITYPE.NE.2)) THEN
        CALL ZDRELL(1,IX,IY,IRAD,IRAD,IDEVCL(ICOL+1),ITYPE,I)
      ELSE IF (IFILL.EQ.1 .AND. ITYPE.EQ.3) THEN
        CALL ZDRELL(1,IX,IY,IRAD,IRAD,IDEVCL(IFORE+1),ITYPE,I)
      ENDIF
      RETURN
      END
 
CODE FOR ZMNARR [ DO ARROW ]
      SUBROUTINE ZMNARR
      
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

      INTEGER IX1(4),IY1(4),IX2(4),IX,IY,ICOL,IXX,IYY
      DATA IX1 /0 , 5 , 5 , 0/
      DATA IY1 /10 , 5 , 15 , 10 /
      DATA IX2 /640 , 635 , 635 , 640 /
      IF ((IMENAR.EQ.1).OR.(IMENAR.EQ.3)) THEN
C LEFT ARROW
        IX = 0
        IXX = 20
        IY = 10
        IYY = 10
        ICOL = 14
        CALL ZDLINE(IX,IY,IXX,IYY,ICOL)
C        CALL ZCPLGN(IX1,IY1,4,HANDLE,ERROR)
C        CALL ZFPLGN(HANDLE,ICOL,ERROR)
C        CALL ZDPLGN(HANDLE,ERROR)
        CALL ZPOLGN (IX1,IY1,4,ICOL)
      ENDIF
      IF (IMENAR.GE.2) THEN
C RIGHT ARROW
        IX = 640
        IY = 10
        IXX = 620
        IYY = 10
        ICOL = 14
        CALL ZDLINE(IX,IY,IXX,IYY,ICOL)
C        CALL ZCPLGN(IX2,IY1,4,HANDLE,ERROR)
C        CALL ZFPLGN(HANDLE,ICOL,ERROR)
C        CALL ZDPLGN(HANDLE,ERROR)
        CALL ZPOLGN (IX2,IY1,4,ICOL)
      ENDIF
      RETURN
      END
 
 
CODE FOR ZDOELL [ DO BOUNDING ELLIPSE ]
      SUBROUTINE ZDOELL (ITYPE,EIG1,EIG2,P,XCENT,ICOL,IATNO,IARC)
      INTEGER ICOL
      REAL EIG1,EIG2,P,XCENT(3),X(361),Y(361),XX(361),YY(361)
      INTEGER IX(361),IY(361)
C itype = 1 bounding ellipse
C itype = 2 principal ellipse (only draw half)
      
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

C FIRST GENERATE THE ELLIPSE
      IF (ITYPE.GT.1) THEN
        IETYP = 1
      ELSE
        IETYP = 0
      ENDIF
      INCMAX = 15
      INCMIN = 2
      ESCL = (INCMAX - INCMIN)/90.0
C RESET COLOUR TO IFORE IF WE ARE USING GREYSCALE
      IF (ITCOL.EQ.0.OR.(IFILL.EQ.1.AND.ITYPE.GE.2)) THEN
        ICOL = IFORE
      ENDIF
Calculate the points on the ELLIPSE at varying intervals. The intervals
C are set to INCMIN when T = 0,180,360 and to INCMAX when T = 90,270.
      N = 1
      IF (IETYP.EQ.0) THEN
        ITHET = 0
        ITEND = 360
      ELSE IF (IETYP.EQ.1) THEN
          ITHET = IARC
          ITEND = IARC+180
      ENDIF
      IF( (ISCRN.EQ.5).OR.(ISCRN.EQ.6) .OR. (ISCRN.EQ.8)) THEN
C WE CAN USE THE POSTSCRIPT LANGUAGE TO GENERATE THE ELLIPSE
        IXP = NINT ( ( XCENT(1) - XCP )*SCALE + XCEN + XOFF)
        IYP = NINT ( ( XCENT(2) - YCP )*SCALE + YCEN + YOFF)
        IRP = P * 180.0 / 3.141
        IRAD = EIG1 * SCALE
C----- AVOID ZERO DIVIDE OR MASSIVE SCALE
        IF (EIG1 .LE. .0001* EIG2) EIG1 = .0001 * EIG2
        SP = EIG2 / EIG1
C CANNOT DRAW ELLIPSES WITH ZERO SCALING
        IF (SP.LT.0.001) SP = 0.001
        IF (ICPOST.EQ.1) THEN
C NEED TO DO THE COLOURS
          IF (IFILL.EQ.0) THEN
            WRITE (IFOUT,3) IPSTCL(1,ICOL+1)/100.0,
     +      IPSTCL(2,ICOL+1)/100.0,
     +      IPSTCL(3,ICOL+1)/100.0
            WRITE (IFOUT,4) IPSTCL(1,IBACK+1)/100.0,
     +      IPSTCL(2,IBACK+1)/100.0,IPSTCL(3,IBACK+1)/100.0
          ELSE
            WRITE (IFOUT,3) IPSTCL(1,IFORE+1)/100.0,
     +      IPSTCL(2,IFORE+1)/100.0,
     +      IPSTCL(3,IFORE+1)/100.0
            WRITE (IFOUT,4) IPSTCL(1,ICOL+1)/100.0,
     +      IPSTCL(2,ICOL+1)/100.0,IPSTCL(3,ICOL+1)/100.0
          ENDIF
        ELSE
          IF (ITYPE.EQ.1) THEN
            IF (IFILL.EQ.0) THEN
              WRITE (IFOUT,5)  1.0
            ELSE
              WRITE (IFOUT,5) ICOL/16.0
            ENDIF
          ENDIF
        ENDIF
        WRITE (IFOUT,1) IXP/10.0,IYP/10.0,SP,IRP
        WRITE (IFOUT,2) IRAD/10.0,ITHET,ITEND
1       FORMAT ('/x ',F7.2,' def /y ',F7.2,' def /s ',F8.4
     c  ,' def /rot ',I4,' def')
2       FORMAT ('/rad ',F7.2,' def /beg ',I5,' def /endarc ',I5,' def
     c  Ellipse')
3       FORMAT ('/r ',F5.3,' def /g ',F5.3,' def /b ',F5.3,' def')
4       FORMAT ('/r1 ',F5.3,' def /g1 ',F5.3,' def /b1 ',F5.3,' def')
5       FORMAT ('/g ',F5.3,' def')
        IF (IETYP.EQ.1) RETURN
        RETURN
      ENDIF
      IELEND = 0
10    CONTINUE
      THETA = ABS ( 90.0 - ABS(MOD (ITHET,180)) )
      INC = ESCL*(90.0-THETA) + INCMIN
      IF (ITHET.LT.0) THEN
        X(N) = EIG1 * XCOS (ITHET+1+360) * SCALE
        Y(N) = EIG2 * XSIN (ITHET+1+360) * SCALE
      ELSE IF (ITHET+1.GT.361) THEN
        X(N) = EIG1 * XCOS (ITHET+1-360) * SCALE
        Y(N) = EIG2 * XSIN (ITHET+1-360) * SCALE
      ELSE
        X(N) = EIG1 * XCOS (ITHET+1) * SCALE
        Y(N) = EIG2 * XSIN (ITHET+1) * SCALE
      ENDIF
      ITHET = ITHET + INC
      N = N + 1
      IF ((ITHET.GT.ITEND).AND.(IELEND.EQ.0)) THEN
        ITHET = ITEND
        IELEND = 1
        GOTO 10
      ELSE IF (ITHET.LT.ITEND) THEN
        GOTO 10
      ENDIF
C NOW ROTATE ABOUT THE CENTRE
      DO 20 I = 1 , N-1
        XX(I) = X(I) * COS(P) - Y(I) * SIN(P)
        YY(I) = X(I) * SIN(P) + Y(I) * COS(P)
20    CONTINUE
C FINALLY CONVERT TO DRAWING COORDINATES
      DO 30 I = 1 , N-1
        IX(I) = NINT ( XX(I) + ( XCENT(1) - XCP )*SCALE)
        IY(I) = NINT ( YY(I) + ( XCENT(2) - YCP )*SCALE)
30    CONTINUE
      IF (ITYPE.EQ.1) THEN
        IF (IFILL.EQ.0) THEN
          CALL ZDRLIN (2,IX,IY,N-1,IDEVCL(IBACK+1),IATNO)
          CALL ZDRLIN (1,IX,IY,N-1,IDEVCL(ICOL+1),IATNO)
        ELSE
          CALL ZDRLIN (2,IX,IY,N-1,IDEVCL(ICOL+1),IATNO)
          CALL ZDRLIN (1,IX,IY,N-1,IDEVCL(IFORE+1),IATNO)
        ENDIF
      ELSE
        CALL ZDRLIN (1,IX,IY,N-1,IDEVCL(ICOL+1),IATNO)
      ENDIF
C      IF (ITYPE.EQ.1) RETURN
C DRAW IN THE MAJOR AXES
C      IX(2) = NINT (( XCENT(1) - XCP)*SCALE + XCEN + XOFF )
C      IY(2) = NINT (( XCENT(2) - YCP)*SCALE + YCEN + YOFF )
C      IX(1) = IX(1) + XCEN + XOFF
C      IY(1) = IY(1) + YCEN + YOFF
C      CALL ZDLINE(IX(1),IY(1),IX(2),IY(2),1)
      RETURN
      END
CODE FOR ZDOKEY
      SUBROUTINE ZDOKEY
C This subroutine draws an atom colour key at the RHS of the screen
C each colour block is a 5x5 pixel square.
      
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

      INTEGER IX(5),IY(5),ICK,ICTXT
      CHARACTER*6 TEXT
      IF (ISCRN.NE.5) THEN
        RES = 1.0
      ENDIF
      ISQR = 20*RES
C The squares are listed in blocks of 20.
      X = XCEN - (NKEY/10)*ISQR - ISQR - 10*RES
      IF (IHAND.EQ.0) THEN
        Y = YCEN + YOFF - ISQR
      ELSE
        Y = ISQR - YCEN - YOFF
      ENDIF
      DO 10 I = 0,NKEY-1
      ICK = NINT(RSTORE(IKEY+I*2+1))
        IX(1) = X
        IX(2) = X
        IX(3) = X + ISQR
        IX(4) = X + ISQR
        IY(1) = Y
        IF (IHAND.EQ.0) THEN
          IY(2) = Y - ISQR
          IY(3) = Y - ISQR
        ELSE
          IY(2) = Y + ISQR
          IY(3) = Y + ISQR
        ENDIF
        IY(4) = Y
        IX(5) = IX(1)
        IY(5) = IY(1)
        CALL ZDRLIN (2,IX,IY,5,IDEVCL(ICK+1),1)
        ICK = 0
        CALL ZDRLIN (1,IX,IY,5,IDEVCL(ICK+1),1)
        ITXT = NINT(RSTORE(IKEY+I*2))
        ITXT = ITXT + ICELM - 1
        TEXT = CSTORE(ITXT)
        IX(1) = IX(1) - ISQR
        ICTXT = 0
        CALL ZDRTEX (IX(1),IY(1),TEXT,IDEVCL(ILABCL+1))
        IF (IHAND.EQ.0) THEN
          Y = Y - (ISQR*2)
        ELSE
          Y = Y + (ISQR*2)
        ENDIF
        IF (MOD(I+1,10).EQ.0) THEN
          IF (IHAND.EQ.1) THEN
            Y = YCEN + YOFF - ISQR
          ELSE
            Y = ISQR - YCEN - YOFF
          ENDIF
          X = X + ISQR
        ENDIF
10    CONTINUE
      RETURN
      END
 
 
CODE FOR ZDOTXT [ DO TEXT ]
      SUBROUTINE ZDOTXT
      
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

C This routine calculates the position of the text for the given device.
      CHARACTER*120 CTEMP,CCHAR
      INTEGER IX , IY , ICOL
      ICOL = ILABCL
C Get the text information
      DO 10 I = 1 , INTXT
        ITP = NINT(RSTORE(ITEXT+(I-1)*4))
        ITN = NINT(RSTORE(ITEXT+(I-1)*4+1))
        X =   RSTORE(ITEXT+(I-1)*4+2)
        Y =   RSTORE(ITEXT+(I-1)*4+3)
        IF (IHAND.EQ.1) THEN
          Y = 1.0 - Y
        ENDIF
C Get the text string
        DO 20 J = ITP , ITP - ITN , -1
          IF (J.EQ.ITP) THEN
            CCHAR = CSTORE(J)
          ELSE
            CTEMP = CCHAR(1:(ITP-J)*6)//CSTORE(J)
            CCHAR = CTEMP
          ENDIF
20      CONTINUE
C Work out the coordinates
        IX = NINT ( X * 2.0 * XCEN ) - XCEN - XOFF
        IY = NINT ( Y * 2.0 * YCEN ) - YCEN - YOFF
        CALL ZDRTEX (IX,IY,CCHAR(1:ITN*6),IDEVCL(ICOL+1))
10    CONTINUE
      RETURN
      END
 
CODE FOR ZMNHI [ HIGHLIGHTING ]
      SUBROUTINE ZMNHI (N , M )
C THIS ROUTINE DRAWS A BLUE BOX AROUND THE OLD ITEM - IE REMOVES THE BOX
C AND DRAWS A RED BOX AROUND THE ONE THAT IS CURRENTLY BEING
C HIGHLIGHTED.
      
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

      INTEGER ICOL
      CHARACTER*12 CNAME
      IWID = IMENWD / 8
      IF (IWID.EQ.12) IWID = 12
      J = N
      IF (N.LT.M) THEN
        IT = IMNTOP - 1
      ELSE IF (N.EQ.M) THEN
        IT = IMNTOP
      ELSE
        IT = IMNTOP + 1
      ENDIF
      IF (IT.EQ.0) IT=IMNTOP
      IF (IT.GT.NITEM) IT=NITEM
10    CONTINUE
C THIS DRAWS THE HIGHLIGHTED WORD IN RED AND THE OLD WORD IN WHITE.
C      JJ = ( J - IMENU(1,1) ) / 4 + 1
      IX = IMPOS (IT)
      IY = 2
      CNAME = CSTORE (NINT(RSTORE(J)))//CSTORE(NINT(RSTORE(J)+1))
      IF ((J.EQ.N).AND.(N.NE.M)) THEN
        ICOL = 15
        CALL ZDTEXT(CNAME(1:IWID),IX,IY,ICOL)
      ELSE
        ICOL = 4
        CALL ZDTEXT(CNAME(1:IWID),IX,IY,ICOL)
      ENDIF
      IF ((J.EQ.N).AND.(N.NE.M)) THEN
        J = M
        IT = IMNTOP
        GOTO 10
      ENDIF
      RETURN
      END
 
CODE FOR ZMNINL [ INPUT LINE ]
      SUBROUTINE ZMNINL (CTEXT,IESCP,IMNNUM)
      
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

      INTEGER IX(5),IY(5),ICOL
      CHARACTER*80 CH
      CHARACTER*(ICLEN) CTEXT
      LOGICAL LFILES
      IESCP = 0
C      CH = 'This is the line of HELP text that is to be used!'
C This routine writes a box on the screen into which the user types
C text.
C First get the text.
C Load in the appropriate error message
      IF (ABS(NINT(RSTORE(IMENU(IMNNUM,3)+3))).EQ.2) THEN
C THE ID WE WANT IS THAT OF THE PREVIOUS COMMAND
        ID = NINT(RSTORE(IMENU(IMNNUM-1,3)))
      ELSE
        ID = NINT (RSTORE( IMENU(IMNNUM,3) ))
      ENDIF
      IF (.NOT.LFILES (-1,'COMMAND.CMN',IINPT)) THEN
        CALL ZMORE('Error - COMMAND.CMN cannout be accessed.',0)
        CH = 'Help unavailable.'
      ELSE
        ID = (ID - ICOM)/ISCOM
        DO 210 I = 1 , ID
          READ (IINPT,'(//)')
210     CONTINUE
        READ (IINPT,220) CH
220     FORMAT (//,A80,/)
        IF (.NOT.LFILES (0,' ',IINPT)) THEN
          CALL ZMORE('Error on closing COMMAND.CMN.',0)
        ENDIF
      ENDIF
C Do the text box.
      IX(1) = 0
      IX(2) = 639
      IX(3) = 639
      IX(4) = 0
      IX(5) = 0
      IY(1) = 440
      IY(2) = 440
      IY(3) = 480
      IY(4) = IY(3)
      IY(5) = IY(4)
      ICOL = 1
C      CALL ZCPLGN(IX,IY,4,HANDLE,ERROR)
C      CALL ZFPLGN(HANDLE,ICOL,ERROR)
      CALL ZPOLGN (IX,IY,4,ICOL)
      ICOL = 8
      CALL ZPLINE(IX,IY,5,ICOL)
C NOW WRITE OUT THE HELP TEXT
      IXX = 2
      IYY = 442
      ICOL = 14
      CALL ZDTEXT(CH,IXX,IYY,ICOL)
      IX(1) = 2
      IY(1) = 462
      CALL ZTXT (IX(1),IY(1), CTEXT, IESCP)
C CLOSE DOWN THE BOX
C      CALL ZDPLGN(HANDLE,ERROR)
C REDRAW THE MENUS
C      CALL ZMNRED(1)
      RETURN
      END
 
 
CODE FOR ZLINEC
      SUBROUTINE ZLINEC (X1,X2,ICOL,IATNO,NPOINT,IFLAG,ITYPE)
C This code will find out which parts of a line are obscured by
C circles/ellipses and will draw the unobscured part.
C The routine operates on either the X or Y coords of the line
C depending on whether or not DX is small.
C This is because rounding errors occur when the line is close to
C vertical.
C NPOINT is used only for HPGL devices where the endpoints of the
C lines are later used to generate an equivalent polygon.
      
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

      INTEGER ICOL,IX(2),IY(2)
      REAL X1(2),X2(2)
C THE ITYPE FLAG IS USED FOR TEKTRONIC ONLY SINCE THIS DEVICE HAS
C A DOTTED LINE CAPABILITY.
      IF (ITYPE.NE.0) THEN
        WRITE (1,*) 'SETTING DOTTED MODE'
        WRITE (IGOUT,'(2A1,$)') CGRAPH(27), CGRAPH(97)
      ENDIF
      DX = ABS (X1(1) - X2(1))
      IF (DX.LT.0.1) THEN
        IX1 = 2
      ELSE
        IX1 = 1
      ENDIF
C NEED TO HAVE THE LINE SO THAT X1 < X2
      IF (X1(IX1).GT.X2(IX1)) THEN
        RJUNK = X1(1)
        X1(1) = X2(1)
        X2(1) = RJUNK
        RJUNK = X1(2)
        X1(2) = X2(2)
        X2(2) = RJUNK
      ENDIF
C IELROT IS THE NEXT FREE LOCATION IN THE RSTORE ARRAY.
      IOSTART = NINT (RSTORE (IATNO + ILAB + 3 ))
      NOVER = NINT (RSTORE (IATNO + ILAB + 4 ))
      IF (NOVER.EQ.0) THEN
C WE CAN DRAW THE WHOLE LINE!
        IX(1) = NINT ( ( X1(1) - XCP ) *SCALE )
        IY(1) = NINT ( ( X1(2) - YCP ) *SCALE )
        IX(2) = NINT ( ( X2(1) - XCP ) *SCALE )
        IY(2) = NINT ( ( X2(2) - YCP ) *SCALE )
        IF ((ISCRN.NE.3).OR.(IFLAG.EQ.2)) THEN
C DRAW LINES
          CALL ZDRLIN(4,IX,IY,2,IDEVCL(ICOL+1),IATNO)
        ELSE
C STORE POINTS FOR USE WITH HPGL DEVICES
          RSTORE (IREND - NPOINT*3) = IX(1)
          RSTORE (IREND - NPOINT*3 - 1) = IY(1)
          RSTORE (IREND - NPOINT*3 - 3) = IX(2)
          RSTORE (IREND - NPOINT*3 - 4) = IY(2)
          NPOINT = NPOINT + 2
        ENDIF
        GOTO 9999
      ENDIF
C WE NEED TO FIND OUT THE EQUATION OF THE LINE.
      IF (ABS(X2(1)-X1(1)).LT.0.0001) X2(1) = X1(1) + 0.0001
      IF (ABS(X2(2)-X1(2)).LT.0.0001) X2(2) = X1(2) + 0.0001
      RM = ( X2(2) - X1(2) ) / ( X2(1) - X1(1) )
      C = X1(2) - RM * X1(1)
C LOOP OVER THE OVERLAPPING ATOMS
      DO 10 I = 0, NOVER - 1
        NN = NINT (RSTORE ( IOSTART - I ) )
        IF (NINT (RSTORE(NN)).NE.2 .AND. NINT(RSTORE(NN)).NE.3) THEN
          XP1 = X1(IX1)
          XP2 = X2(IX1)
          XP3 = X2(IX1)
          XP4 = X2(IX1)
          GOTO 20
        ENDIF
C DO NOT CALC IF LINE
        XC = RSTORE (NN+IXYZO)
        YC = RSTORE (NN+IXYZO+1)
        IF ((NINT (RSTORE(NN)).EQ.2).OR.((NINT(RSTORE(NN)).EQ.3).AND.
     c    (RSTORE(NN+IXYZO+12).LT.0.0)) ) THEN
C CIRCLE
          IF (NINT(RSTORE(NN)).EQ.2) THEN
            R = RSTORE ( NN + IATTYP + 4 )
          ELSE
            R = SQRT (ABS ( RSTORE (NN+IXYZO+12) ) )
          ENDIF
C THE POINT OF INTERSECTION IS FOUND BY SOLVING
C Y = MX + C AND
C (X - XC)**2 + (Y-YC)**2 - R**2 = 0
          A = (1 + RM**2)
          B = 2*RM*C - 2*XC - 2*YC*RM
          CC = XC**2 + C**2 - 2*C*YC +YC**2 - R**2
          IF (B**2.LT.4*A*CC) THEN
            XP1 = X1(IX1)
            XP2 = X2(IX1)
            XP3 = X2(IX1)
            XP4 = X2(IX1)
            GOTO 20
          ENDIF
C NO OVERLAP
          XX1 = ( -B - SQRT ( B**2 - 4*A*CC ) ) / ( 2*A )
          XX2   = ( -B + SQRT ( B**2 - 4*A*CC ) ) / ( 2*A )
        ELSE
C ELLIPSE - GET THE INFO
          IELS = NINT (RSTORE ( NN + IXYZO + 15 ))
C NOTE EIG1,EIG2 ARE SQUARED HERE!!
          EIG1 = RSTORE (IELS)**2
          EIG2 = RSTORE (IELS+1 )**2
          P = RSTORE (IELS+2)
C NEED TO ROTATE BY THE ANGLE P ABOUT THE ELLIPSOID CENTRE.
          XA = (X1(1)-XC) * COS (P) + (X1(2)-YC) * SIN (P) + XC
          YA = - (X1(1)-XC) * SIN (P) + (X1(2)-YC) * COS(P) + YC
          XB = (X2(1)-XC) * COS (P) + (X2(2)-YC)*SIN (P) + XC
          YB = - (X2(1)-XC)* SIN(P) + (X2(2)-YC)*COS(P)  + YC
C FIND THE NEW GRADIENT ETC
          RM1 = ( YB - YA ) / ( XB - XA )
          C1 = YA - RM1 * XA
C THE POINT OF INTERSECTION IS GIVEN BY :-
C A =  1/EIG1 + RM1**2 / EIG2
C B = -2*XC/EIG1 + 2*RM1*C1/EIG2  - 2*YC*RM1/EIG2
C CC = XC**2/EIG1 + C1**2/EIG2 - 2*YC*C1/EIG2 + YC**2/EIG - 1
          A = (1.0/EIG1) + (RM1**2/EIG2)
          B = ((-2.0*XC)/EIG1) + ((2*RM1*C1)/EIG2) - ((2.0*YC*RM1)/EIG2)
          CC = (XC**2/EIG1) + (C1**2/EIG2) - ((2*YC*C1)/EIG2)
     c       + (YC**2/EIG2) - 1.0
          IF (B**2.LT.4*A*CC) THEN
C NO-OVERLAP
            XP1 = X1(IX1)
            XP2 = X2(IX1)
            XP3 = XP2
            XP4 = XP2
            GOTO 20
          ENDIF
C OVERLAP
          XXX1 = ( - B + SQRT ( B**2 - 4*A*CC ) ) / ( 2*A )
          XXX2 = ( - B - SQRT ( B**2 - 4*A*CC ) ) / ( 2*A )
C FIND THE Y COORDINATES
          YYY1 = XXX1 * RM1 + C1
          YYY2 = XXX2 * RM1 + C1
C NOW NEED TO ROTATE THESE BACK.
          XX1 = (XXX1-XC)*COS(P) - (YYY1-YC)*SIN(P) + XC
          XX2 = (XXX2-XC)*COS(P) - (YYY2-YC)*SIN(P) + XC
        ENDIF
        IF (IX1.EQ.2) THEN
          XX1 = RM* XX1 + C
          XX2 = RM * XX2 + C
        ENDIF
        IF (XX1.GT.XX2) THEN
          RJUNK = XX1
          XX1 = XX2
          XX2 = RJUNK
        ENDIF
C DO THESE LIE ON THE LINE?
        IF ((XX1.GT.X2(IX1)).OR.(XX2.LT.X1(IX1))) THEN
C THE LINE IS NOT OBSCURED.
          XP1 = X1(IX1)
          XP2 = X2(IX1)
          XP3 = X2(IX1)
          XP4 = X2(IX1)
          GOTO 20
        ENDIF
        IF ((XX1.LT.X1(IX1)).AND.(XX2.GT.X2(IX1))) THEN
C WHOLE LINE OBSCURED
          GOTO 9999
        ENDIF
C X1 END OF LINE OBSCURED - JUST DRAW ONE LINE
        IF (XX1.LT.X1(IX1)) THEN
          XP1 = XX2
          XP2 = X2(IX1)
          XP3 = X2(IX1)
          XP4 = X2(IX1)
          GOTO 20
        ENDIF
C X2 END OF LINE OBSCURED
        IF (XX2.GT.X2(IX1)) THEN
          XP1 = X1(IX1)
          XP2 = XX1
          XP3 = XX1
          XP4 = XX1
          GOTO 20
        ENDIF
C MIDDLE OF LINE OBSCURED, NEED TO DRAW TWO LINES
        XP1 = X1(IX1)
        XP2 = XX1
        XP3 = XX2
        XP4 = X2(IX1)
C WE WILL DRAW THE LINES XP1 -> XP2 AND XP3 -> XP4
20      CONTINUE
        RSTORE ( IELROT + I*4 ) = XP1
        RSTORE ( IELROT + I*4 + 1 ) = XP2
        RSTORE ( IELROT + I*4 + 2 ) = XP3
        RSTORE ( IELROT + I*4 + 3 ) = XP4
10    CONTINUE
C NOW WE NEED TO FIND THE INTERSECTION OF ALL THESE DRAWN LINES TO
C FIND THE FINAL, UNOBSCURED SECTIONS.
C FIND THE START POINT FURTHEST FROM XS
      XS = X1(IX1)
      DO 40 I = 0 , NOVER - 1
        XP1 = RSTORE (IELROT + I*4)
        IF (XP1.GT.XS) THEN
          XS = XP1
        ENDIF
40    CONTINUE
C WE NEED THE NEXT ENDPOINT (XP2) AFTER THIS.
      XF = X2(IX1)
      DO 60 I = 0 , NOVER - 1
        XP2 = RSTORE (IELROT + I*4 + 1)
        IF (XP2.LE.XF) THEN
          XF = XP2
          N = I
        ENDIF
60    CONTINUE
      IXP4 = 0
50    CONTINUE
C WE CAN NOW DRAW THE LINE  XS -> XF
      IF (ABS(XS-XF).LT.0.001) GOTO 9999
C THERE ARE CIRCUMSTANCES WHERE XF IS LOWER THAN XS - DO NOT
C DRAW THE LINE BUT CARRY ON AS NORMAL TO FIND THE OTHER POINTS.
        IF (XF.GT.XS) THEN
C CALCULATE THE OTHER COORDINATES
        IF (IX1.EQ.1) THEN
          YS1 = XS * RM + C
          YF1 = XF * RM + C
         XS1 = XS
          XF1 = XF
        ELSE
          YS1 = XS
          YF1 = XF
          XS1 = ( XS - C ) /RM
          XF1 = ( XF - C ) /RM
        ENDIF
C CONVERT TO DRAWING COORDS
        IX(1) = NINT ( ( XS1 - XCP ) * SCALE )
        IY(1) = NINT ( ( YS1 - YCP ) * SCALE )
        IX(2) = NINT ( ( XF1 - XCP ) * SCALE )
        IY(2) = NINT ( ( YF1 - YCP ) * SCALE )
C DRAW
        IF (ISCRN.NE.3) THEN
          CALL ZDRLIN (4,IX,IY,2,IDEVCL(ICOL+1),IATNO)
        ELSE
C STORE POINTS FOR USE WITH HPGL DEVICES
          RSTORE (IREND - NPOINT*3) = IX(1)
          RSTORE (IREND - NPOINT*3 - 1) = IY(1)
          RSTORE (IREND - NPOINT*3 - 3) = IX(2)
          RSTORE (IREND - NPOINT*3 - 4) = IY(2)
          NPOINT = NPOINT + 2
        ENDIF
      ENDIF
C NOW FIND THE NEXT START POINT ON THE SAME LINE AS THE CURRENT END
C POINT.
      IF (IXP4.EQ.1 .OR. N .EQ. -1 ) GOTO 9999
C IF WE HAVE JUST DRAWN A LINE TO THE LAST END POINT OF THE
C CURRENT SEGMENT - RETURN
      IF (ABS(RSTORE(IELROT+N*4+3)-XF).LT.0.0001) GOTO 9999
      XS = RSTORE (IELROT + N*4 + 2 )
      IF (XS.GE.X2(IX1)) THEN
C WE HAVE GONE OFF THE END OF THE LINE
        GOTO 9999
      ENDIF
30    CONTINUE
C ARE THERE ANY END POINTS THAT COME IN BETWEEN XF AND XS?
      M = -1
      XX = XF
      DO 70 I = 0 , NOVER - 1
        IF (I.EQ.N) GOTO 70
        XF1 = RSTORE (IELROT + I*4 + 1 )
        XF2 = RSTORE (IELROT + I*4 + 3 )
        IF (XF2.LE.XS) GOTO 9999
        IF ((XF1.GT.XF).AND.(XF1.LT.XS)) THEN
C YES LIES IN BETWEEN
          IF (XF1.GT.XX) THEN
            M = I
            XX = XF1
          ENDIF
        ENDIF
70    CONTINUE
      IF (M.NE.-1) THEN
C NEED TO RESET XS
        XF = XS
        XS = RSTORE (IELROT + M*4 + 2 )
        GOTO 30
      ELSE
C LOOK FOR THE NEXT END POINT
        XF = X2(IX1)
        N = -1
        IXP4 = 0
        DO 80 I = 0 , NOVER - 1
          XP2 = RSTORE (IELROT + I*4 + 1)
          XP4 = RSTORE (IELROT + I*4 + 3)
          IF ((XP2.LT.XF).AND.(XP2.GT.XS)) THEN
            IXP4 = 0
            XF = XP2
            N = I
          ENDIF
          IF (XP4.LT.XF) THEN
            IXP4 = 1
            XF = XP4
          ENDIF
80      CONTINUE
        GOTO 50
      ENDIF
9999  CONTINUE
      IF (ITYPE.NE.0) THEN
        WRITE (1,*) 'OUTPUTTING LINES'
        WRITE (IGOUT,'(2A1,$)') CGRAPH(27), CGRAPH(96)
      ENDIF
      RETURN
      END
 
CODE FOR ZMNTOP [ MENU TOP BAR ]
      SUBROUTINE ZMNTOP(A,B)
      
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

C WRITE OUT THE TOP BAR
      CHARACTER*80 CL
      CHARACTER*80 CBLANK
      CHARACTER*12 CNAME
      INTEGER IXBOX(5),IYBOX(5),IX1,IY1,IX2,IY2,ICOL
      DO 5 I = 1 , 80
        CBLANK(I:I) = ' '
5     CONTINUE
C HOW MUCH SPACE ARE WE ALLOCATED PER ITEM?
      IMENWD = 600 / NITEM
C WORK OUT HOW MUCH FRONT SPACE THERE IS
      ISATT = IMENWD/8
      IF (ISATT.GT.12) ISATT = 12
      IFRONT = 20 + ( 600 - IMENWD * NITEM ) / 2
C NOW SET UP THE STRING
      IXBOX(1) = 0
      IYBOX(1) = 0
      IXBOX(2) = 639
      IYBOX(2) = 0
      IXBOX(3) = IXBOX(2)
      IYBOX(3) = 20
      IXBOX(4) = IXBOX(1)
      IYBOX(4) = IYBOX(3)
      IXBOX(5) = IXBOX(1)
      IYBOX(5) = IYBOX(1)
      IX1 = 0
      IY1 = 0
      IX2 = 639
      IY2 = 20
      ICOL = 1
      CALL ZCLRA(IX1,IY1,IX2,IY2,ICOL)
      ICOL = 7
      CALL ZPLINE(IXBOX,IYBOX,5,ICOL)
      CL = CBLANK
      IMNPOS = IFRONT
      CALL ZMNARR
C LOOP OVER THE INFO
      K = 0
C       DO 10 I = IMENU ( 1, 3) , IMENU (1,3)+(NITEM-1)*4 , 4
      DO 10 I = A , B , 4
      K = K + 1
C      DO 10 I = 1 , NITEM
C GET THE NAME
C        CNAME = CSTORE((ISTART-1)*2+1+(I-1)*2)//
C     c  CSTORE((ISTART-1)*2+1+(I-1)*2+1)
        CNAME = CSTORE(NINT(RSTORE(I)))//CSTORE(NINT(RSTORE(I)+1))
        IY = 2
        ICOL = 15
        CALL ZDTEXT(CNAME(1:ISATT),IMNPOS,IY,ICOL)
        IMPOS(K) = IMNPOS
        IMNPOS = IMNPOS + IMENWD
10    CONTINUE
      RETURN
      END
 
CODE FOR ZMNVET [ VERTICAL MENU ]
      SUBROUTINE ZMNVET (ITYPE)
      
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

      INTEGER IXBOX(5), IYBOX(5),ICOL,IHPOS,IVPOS
      CHARACTER*12 CNAME
C ITYPE = 1 CREATE MENU
C ITYPE = -1 DELETE MENU
C ITYPE = 2 REDRAW MENU - DO NOT RESET IVERT VALUES
C FIRST SET UP THE MENU LISTS
      IF (ITYPE.EQ.1) THEN
        II = NINT ( RSTORE ( IMENU ( IMENVT-1,3) + 1) )
C GET START POSITION
        IMENU(IMENVT,1) = II
        IMENU(IMENVT,3) = II
C GET NO OF ITEMS
        II = NINT ( RSTORE ( IMENU ( IMENVT-1,3) + 2) )
        IMENU(IMENVT,2) = IMENU(IMENVT,1) + (II-1)*4
      ENDIF
C CHECK FOR BLANKING OFF OF MENUS
C THIS HAS BEEN REPLACED BY ADDING AN * AT THE END OF COMMANDS NEEDING
C INPUT
C        IBLANK = 0
C      DO 5 I = IMENVT-1 , 2 , -1
C        IJ = NINT(RSTORE ( IMENU (I,3) + 3) )
C        IF (IJ.EQ.3) IBLANK = 1
C5     CONTINUE
C FIRST CALCULATE THE BOX SIZE
      IVITEM = NINT (RSTORE ( IMENU (IMENVT-1,3 ) + 2 ) )
      ISBOX = 15 * IVITEM
C LOOP TO SEE IF THERE ARE ANY FOLLOWING COMMANDS.
      IP = IMENU (IMENVT-1,3 )
      IST = NINT ( RSTORE (IP + 1 ))
      IFN = IST + NINT (RSTORE (IP+2))*4
      INFOLL = 0
      DO 10 I = IST , IFN-1 , 4
        IF (NINT(RSTORE(I+2)).NE.0) INFOLL = 1
10    CONTINUE
C THE BOX WIDTH IS IMENWD
C NOW CALCULATE THE CORNER POSITIONS
      IF (INFOLL.EQ.0) THEN
        IXBOX(1) = IMENX(IMENVT) - 2
        IXBOX(2) = IMENX(IMENVT) + IMENWD - 4
      ELSE
        IF (IMNTOP.GT.NITEM/2) THEN
C OTHER MENUS WILL GO TO THE LEFT
          IXBOX(1) = IMENX(IMENVT) - 2 - 10
          IXBOX(2) = IMENX(IMENVT) + IMENWD - 4
        ELSE
          IXBOX(1) = IMENX(IMENVT) - 2
          IXBOX(2) = IMENX(IMENVT) + IMENWD - 4 + 10
        ENDIF
      ENDIF
      IYBOX(1) = IMENY(IMENVT)
      IYBOX(2) = IMENY(IMENVT)
      IXBOX(3) = IXBOX(2)
      IYBOX(3) = IMENY(IMENVT) + ISBOX
      IXBOX(4) = IXBOX(1)
      IYBOX(4) = IYBOX(3)
      IXBOX(5) = IXBOX(1)
      IYBOX(5) = IYBOX(1)
C FILL IT IN
C      CALL ZCPLGN(IXBOX,IYBOX,5,HANDLE,ERROR)
      IF (ITYPE.EQ.-1) THEN
        ICOL = 0
        CALL ZPOLGN (IXBOX,IYBOX,5,ICOL)
C        CALL ZFPLGN(HANDLE,ICOL,ERROR)
        RETURN
      ENDIF
      ICOL = 1
C      CALL ZFPLGN(HANDLE,ICOL,ERROR)
C      CALL ZDPLGN(HANDLE,ERROR)
      CALL ZPOLGN (IXBOX,IYBOX,5,ICOL)
      ICOL = 7
      CALL ZPLINE(IXBOX,IYBOX,5,ICOL)
C NOW WE NEED TO ADD IN THE MENU ITEMS
C GET THE NAME
      DO 20 I = IST , IFN-1 , 4
        CNAME = ' '//CSTORE(NINT(RSTORE(I)))//CSTORE(NINT(RSTORE(I)+1))
C CHECK IF THIS NEEDS ARGUMENTS
        IF (NINT(RSTORE(I+3)).GT.0) CNAME(1:1)='*'
C GET THE POSITION
        IVPOS = IMENY(IMENVT) + (I-IST)* 15/4
        IF ((INFOLL.EQ.1).AND.(IMNTOP.LE.NITEM/2)) THEN
          IHPOS = IMENX(IMENVT)
        ELSE IF (INFOLL.EQ.0) THEN
          IHPOS = IMENX(IMENVT)
        ELSE
          IHPOS = IMENX(IMENVT) + 10
        ENDIF
        IH = IHPOS
        IV = IVPOS
C        IF (IBLANK.EQ.0) THEN
          ICOL = 15
          CALL ZDTEXT(CNAME,IH,IV,ICOL)
C        ELSE
C          ICOL = 8
C          CALL ZDTEXT(CNAME,IH,IV,ICOL)
C        ENDIF
        IF (RSTORE(I+2).GT.0.0) THEN
C          IF (IBLANK.EQ.1) THEN
C            CALL ZMNARV (IHPOS,IVPOS,2)
C          ELSE IF (NINT(RSTORE(I+3)).EQ.3) THEN
C            CALL ZMNARV (IHPOS,IVPOS,2)
C          ELSE
            CALL ZMNARV (IHPOS,IVPOS,1)
C          ENDIF
        ENDIF
20    CONTINUE
      IF (ITYPE.NE.2) THEN
         IMENU (IMENVT,3) = IMENU (IMENVT,1)
      ENDIF
      N = IMENU(IMENVT,3)
C      IF (IBLANK.EQ.0) THEN
        CALL ZMNVHI (N,N)
C      ENDIF
      RETURN
      END
 
CODE FOR ZOLAP
      SUBROUTINE ZOLAP (X,Y,IDRAW,I)
C This routine checks whether the point about to be drawn is obscured by
C another atom.
C I is the atom we are drawing at the moment
      
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

      IDRAW = 1
C FIND THE START OF THE INFO
      IOSTART = NINT (RSTORE ( I + ILAB + 3 ))
      NOVER = NINT (RSTORE ( I + ILAB + 4 ))
      DO 10 J = 0, NOVER - 1
        NN = NINT (RSTORE ( IOSTART - J ) )
C WHAT STYLE IS THIS ATOM?
        IF (NINT (RSTORE (NN)).EQ.2) THEN
C CIRCLE
          XX = (X - (RSTORE(NN+IXYZO) - XCP)*SCALE)**2
     c       + (Y- (RSTORE(NN+IXYZO+1) - YCP)*SCALE)**2
          IF (XX.LT.(RSTORE(NN+IATTYP+4)*SCALE)**2) THEN
            IDRAW = 0
          ENDIF
        ELSE IF (NINT (RSTORE(NN)).NE.3) THEN
          GOTO 10
        ELSE
C ELLIPSE
C XX AND YY ARE THE POINTS OF THE ELLIPSE ROTATED ABOUT THE CENTRE OF
C THE OVERLAPPING ELLIPSE SO THAT IT CAN BE TREATED AS THOUGHT IT HAD
C MAJ/MINOR AXES LYING ALONG THE X,Y DIRECTIONS.
C GET THE ELLIPSE INFO
C WE HAVE A UISO ATOM
          IF (RSTORE(NN+IXYZO+12).LT.0.0) THEN
C WE HAVE A UISO ATOM
            XX = (X - (RSTORE(NN+IXYZO) -XCP)*SCALE)**2
     c         + (Y - (RSTORE(NN+IXYZO+1) - YCP)*SCALE)**2
            IF (XX.LT.(SQRT(ABS(RSTORE(NN+IXYZO+12)))*SCALE)**2) THEN
              IDRAW = 0
            ENDIF
          ELSE
            NEL = NINT (RSTORE (NN+IXYZO+15))
            P = RSTORE (NEL+2)
            EIG1 = RSTORE (NEL)*SCALE
            EIG2 = RSTORE (NEL+1)*SCALE
            XX =  (X-(RSTORE(NN+IXYZO)-XCP)*SCALE)*COS(P)
     c       + (Y-(RSTORE(NN+IXYZO+1)-YCP)*SCALE)*SIN(P)
            YY = - (X-(RSTORE(NN+IXYZO)-XCP)*SCALE)*SIN(P)
     c       + (Y-(RSTORE(NN+IXYZO+1)-YCP)*SCALE)*COS(P)
C NOW CALCULATE OVERLAP
            AA = ((XX)**2/EIG1**2) + ((YY)**2/EIG2**2)
            IF (AA.LT.1.0) THEN
              IDRAW = 0
            ENDIF
          ENDIF
        ENDIF
10    CONTINUE
      RETURN
      END
 
 
CODE FOR ZOLAP
      SUBROUTINE ZZOLAP (X,Y,IDRAW,I)
C This routine checks whether the point about to be drawn is obscured by
C another atom.
C I is the atom we are drawing at the moment
      
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

      IDRAW = 1
C FIND THE START OF THE INFO
      IOSTART = NINT (RSTORE ( I + ILAB + 3 ))
      NOVER = NINT (RSTORE ( I + ILAB + 4 ))
      DO 10 J = 0, NOVER - 1
        NN = NINT (RSTORE ( IOSTART - J ) )
C WHAT STYLE IS THIS ATOM?
        IF (NINT (RSTORE (NN)).EQ.2) THEN
C CIRCLE
          XX = (X - (RSTORE(NN+IXYZO) - XCP)*SCALE)**2
     c       + (Y- (RSTORE(NN+IXYZO+1) - YCP)*SCALE)**2
          IF (XX.LT.(RSTORE(NN+IATTYP+4)*SCALE)**2) THEN
            IDRAW = 0
          ENDIF
        ELSE IF (NINT (RSTORE(NN)).EQ.1) THEN
          GOTO 10
        ELSE
C ELLIPSE
C XX AND YY ARE THE POINTS OF THE ELLIPSE ROTATED ABOUT THE CENTRE OF
C THE OVERLAPPING ELLIPSE SO THAT IT CAN BE TREATED AS THOUGHT IT HAD
C MAJ/MINOR AXES LYING ALONG THE X,Y DIRECTIONS.
C GET THE ELLIPSE INFO
C WE HAVE A UISO ATOM
          IF (RSTORE(NN+IXYZO+12).LT.0.0) THEN
C WE HAVE A UISO ATOM
            XX = (X - (RSTORE(NN+IXYZO) -XCP)*SCALE)**2
     c         + (Y - (RSTORE(NN+IXYZO+1) - YCP)*SCALE)**2
            IF (XX.LT.(SQRT(ABS(RSTORE(NN+IXYZO+12)))*SCALE)**2) THEN
              IDRAW = 0
            ENDIF
          ELSE
            NEL = NINT (RSTORE (NN+IXYZO+15))
            P = RSTORE (NEL+2)
            EIG1 = RSTORE (NEL)*SCALE
            EIG2 = RSTORE (NEL+1)*SCALE
            XX =  (X-(RSTORE(NN+IXYZO)-XCP)*SCALE)*COS(P)
     c       + (Y-(RSTORE(NN+IXYZO+1)-YCP)*SCALE)*SIN(P)
            YY = - (X-(RSTORE(NN+IXYZO)-XCP)*SCALE)*SIN(P)
     c       + (Y-(RSTORE(NN+IXYZO+1)-YCP)*SCALE)*COS(P)
C NOW CALCULATE OVERLAP
            AA = ((XX)**2/EIG1**2) + ((YY)**2/EIG2**2)
            IF (AA.LT.1.0) THEN
              IDRAW = 0
            ENDIF
          ENDIF
        ENDIF
10    CONTINUE
      RETURN
      END
 
CODE FOR ZMNRED
      SUBROUTINE ZMNRED(ITYPE)
      
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

      INTEGER IX,IY
      INTEGER ERROR,IFUNCT
C ITYPE = 1
C THIS REDRAWS THE MENUS AT THEIR CURRENT STAGES
C ITYPE = 2
C THIS REDRAWS THE PREVIOUS MENU ONLY
C      IF (ITYPE.EQ.2) THEN
C        IF (IMENVT.EQ.1) THEN
C WORK OUT THE START OF THE MENU
C          IF (IMNTOP.EQ.1) THEN
C            A = IMENU(1,3)
C            B = IMENU(1,3) + (NITEM-1)*4
C          ELSE IF (IMNTOP.EQ.NITEM) THEN
C            B = IMENU(1,3)
C            A = IMENU(1,3) - ( NITEM-1)*4
C          ELSE
C            A = IMENU(1,3) - (IMNTOP-1)*4
C            B = IMENU(1,3) + (NITEM-IMNTOP)*4
C          ENDIF
C          CALL ZMNTOP (A,B)
C          CALL ZMNHI (IMENU(1,3),IMENU(1,3))
C        ELSE
C          CALL ZMNVET(2)
C          RETURN
C        ENDIF
C      ENDIF
C      IF (ITYPE.EQ.1) THEN
C         CALL VGA@
C      ENDIF
      IFUNCT = 0
      IX = 0
      IY = 0
      CALL ZRTSBL(IX,IY,IBUFF,IFUNCT,ERROR)
      IVMEN = IMENVT
      DO 10 IMENVT = 1 , IVMEN
      IF (IMENVT.EQ.1) THEN
C WORK OUT THE START OF THE MENU
        IF (IMNTOP.EQ.1) THEN
          A = IMENU(1,3)
          B = IMENU(1,3) + (NITEM-1)*4
        ELSE IF (IMNTOP.EQ.NITEM) THEN
          B = IMENU(1,3)
          A = IMENU(1,3) - ( NITEM-1)*4
        ELSE
          A = IMENU(1,3) - (IMNTOP-1)*4
          B = IMENU(1,3) + (NITEM-IMNTOP)*4
        ENDIF
        CALL ZMNTOP (A,B)
        CALL ZMNHI (IMENU(1,3),IMENU(1,3))
      ELSE
        CALL ZMNVET(2)
      ENDIF
10    CONTINUE
      IMENVT = IVMEN
      RETURN
      END
 
CODE FOR ZSOLID
      SUBROUTINE ZSOLID (IATNO)
C This routine calls the circle or ELLIPSE subroutines depending on which
C option has been selected for the particular atom.
C IATNO - is the reference number for the atom being drawn.
      
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

      REAL AXES(3,3),EIGS(3),XCENT(3)
      INTEGER ICOL,IX(2),IY(2)
      REAL VECV(3)
      ICODE = NINT (RSTORE(IATNO))
      IF (ICODE.EQ.2) THEN
C SOLID
        CALL ZCIRCL(IATNO,1)
        RETURN
      ENDIF
C ELLIPSE
C Get the atom's information
      ITYPE = NINT (RSTORE(IATNO)*10.0-30.0)
      ICOL = NINT (RSTORE(IATNO+IATTYP+1))
      DO 10 I = 1,3
        DO 20 J = 1,3
          AXES(I,J) = RSTORE(IATNO+IXYZO-1+J+I*3)
20      CONTINUE
10    CONTINUE
      DO 30 I = 1,3
      EIGS(I) = RSTORE(IATNO+IXYZO+11+I)
30    CONTINUE
      DO 40 I = 1,3
        XCENT(I) = RSTORE(IATNO+IXYZO-1+I)
40    CONTINUE
      IF (EIGS(1).LT.0.0) THEN
C WE HAVE ISOTROPIC ATOM - DRAW AS A SCALED CIRCLE
        CALL ZCIRCL ( IATNO ,3 )
        RETURN
      ENDIF
C DRAW THE ELLIPSES
      NEL = NINT (RSTORE ( IATNO + IXYZO + 15 ))
CDJW - DRAW A ZERO-LENGT LINE AT CENTRE OF ELLIPS TO HELP SOME EPS
C      DRAWING PACKAGES
      IX(1) = (XCENT(1)-XCP)*SCALE
      IY(1) = (XCENT(2)-YCP)*SCALE
      IX(2) = IX(1)
      IY(2) = IY(1)
      CALL ZDRLIN (1,IX,IY,2,IDEVCL(IFORE+1),IATNO)
      IF (ITYPE.EQ.1) THEN
        J = 1
      ELSE
        J = 4
      ENDIF
      DO 60 I = 1,J
        EIG1 = RSTORE (NEL+(I-1)*4)
        EIG2 = RSTORE (NEL+(I-1)*4+1)
        P = RSTORE (NEL+(I-1)*4 + 2)
        IARC = NINT (RSTORE (NEL+(I-1)*4 + 3))
        CALL ZDOELL (I,EIG1,EIG2,P,XCENT,ICOL,IATNO,IARC)
60    CONTINUE
      IF (ITYPE.LT.3) RETURN
      IX(1) = (XCENT(1)-XCP)*SCALE
      IY(1) = (XCENT(2)-YCP)*SCALE
      VECV(1) = 0.0
      VECV(2) = 0.0
      VECV(3) = 1.0
      DO 70 I = 1,3
        IX(2) = NINT ( (AXES(1,I) + XCENT(1)-XCP)*SCALE)
        IY(2) = NINT ( (AXES(2,I) + XCENT(2)-YCP)*SCALE)
        IF (IFILL.EQ.0) THEN
          CALL ZDRLIN(1,IX,IY,2,IDEVCL(ICOL+1),IATNO)
        ELSE
          CALL ZDRLIN (1,IX,IY,2,IDEVCL(IFORE+1),IATNO)
        ENDIF
70    CONTINUE
      IF (ITYPE.LT.4) RETURN
      CALL ZDOSHD (IATNO,XCENT,AXES)
      RETURN
      END
 
CODE FOR ZTXT
      SUBROUTINE ZTXT ( IX , IY , CTEXT , IMESSG)
C THIS ROUTINE READS IN THE TEXT ONE CHARACTER AT A TIME AND WRITES IT
C OUT IN AN APPROPRIATE PLACE. DELETION IS ALSO ALLOWED
      
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

      INTEGER KK,IX,IY,IX1,IX2(5),IY2(5),ICOL,IB
      CHARACTER*(ICLEN) CTEXT
      CHARACTER*20 CC
C BLANK OFF CTEXT
      DO 5 I = 1 , ICLEN
        CTEXT(I:I) = ' '
5     CONTINUE
      CALL ZMDISP
      ISTEP = 8
      ITC = 0
      IX1 = IX - ISTEP 
10    CONTINUE
      CALL ZGTBUT(0,IB)
      IF (IB.NE.0) THEN
        I = LMOUSE(CC)
        IF (I.EQ.0) THEN
C WE HAVE AN ATOM NAME TO ADD INTO THE LINE
CDJWNOV98 - CHECK WE END WITH A SPACE
          IF (ITC .GT. 0) THEN
            IF (CTEXT(ITC:ITC) .NE. ' ') then
                  ITC = ITC +1
                  ix1 = ix1 + istep
            endif
          ENDIF
CDJWNOV98
          J = INDEX (CC ,' ')
          IF (ITC+J.GT.ICLEN) THEN
            CALL ZBEEP
            CALL ZMORE1 ( ' Line too long', 0)
            GOTO 10
          ENDIF
          ITC = ITC + 1
          CTEXT(ITC:ITC+J-1) = CC(1:J)
C AND WRITE IT OUT
          IX1 = IX1 + ISTEP
          IYY = IY
          IXX = IX1
          CALL ZMHIDE
          CALL ZDTEXT(CTEXT(ITC:ITC+J-1),IXX,IYY,IBTEXT)
          CALL ZMDISP
          IX1 = IX1 + ISTEP*(J-1)
          ITC = ITC + J - 1
          GOTO 10
        ELSE IF (I.GT.0) THEN
C THIS IS A MESSAGE
          CALL ZMHIDE
          CTEXT = CBUTTX (I)
          RETURN
        ENDIF
      ENDIF
      CALL ZGTKY1(KK)
C CHECK FOR SPECIAL KEYS
      IF (KK.EQ.13) THEN
C THIS IS RETURN
        CALL ZMHIDE
        RETURN
      ELSE IF (KK.EQ.27) THEN
C THIS IS ESCAPE
        IESCP = 1
        CALL ZMHIDE
        RETURN
      ELSE IF (KK.EQ.8) THEN
C THIS IS DELETE
        IF (ITC.GT.0) THEN
C WE HAVE TO DRAW A BLANK SPACE OVER THE PREVIOUS LETTER
          IX2(1) = IX1
          IX2(2) = IX1 + 8
          IX2(3) = IX2(2)
          IX2(4) = IX2(1)
          IX2(5) = IX2(1)
          IY2(1) = IY
          IY2(2) = IY
          IY2(3) = IY + 15
          IY2(4) = IY2(3)
          IY2(5) = IY2(1)
          ICOL = 1
          CALL ZMHIDE
          CALL ZPOLGN (IX2,IY2,5,IBBACK)
          CALL ZMDISP
C AND REMOVE IT FROM THE LINE
          CTEXT(ITC:ITC) = ' '
          ITC = ITC - 1
          IX1 = IX1 - ISTEP
        ENDIF
        GOTO 10
      ELSE IF ((KK.LE.0).OR.(KK.GT.255)) THEN
        GOTO 10
      ELSE
C NOT SPECIAL JUST ADD IT INTO THE LINE
        IF (ITC.GT.78) THEN
C THIS IS THE LIMIT - PUT OUT  A BEEP
          CALL ZBEEP
          GOTO 10
        ENDIF
        ITC = ITC + 1
        CTEXT(ITC:ITC) = CHAR(KK)
C AND WRITE IT OUT
        IX1 = IX1 + ISTEP
        ICOL = 15
        IYY = IY
        IXX = IX1
        CALL ZMHIDE
        CALL ZDTEXT(CTEXT(ITC:ITC),IXX,IYY,IBTEXT)
        CALL ZMDISP
        GOTO 10
      ENDIF
      END
 
 
CODE FOR ZMNARV [ VERTICAL MENU ARROWS ]
      SUBROUTINE ZMNARV ( IHPOS , IVPOS ,ITYPE)
      INTEGER IHPOS , IVPOS , IX(4), IY(4), ICOL,ID
      
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

      IF (ITYPE.EQ.2) THEN
        ICOL = 8
      ELSE
        ICOL = 14
      ENDIF
C WORK OUT THE ARROW COORDS
      IF (IMNTOP.LE.NITEM/2) THEN
C LEFT ARROW
        IX(1) = IHPOS + IMENWD -5
        IX(2) = IHPOS + IMENWD
      ELSE
C RIGHT ARROW
        IX(1) = IHPOS -15
        IX(2) = IHPOS - 20
      ENDIF
      IX(3) = IX(1)
      IX(4) = IX(1)
      IY(1) = IVPOS
      IY(2) = IVPOS + 5
      IY(3) = IVPOS + 10
      IY(4) = IY(1)
C DRAW THE ARROW
C      CALL ZCPLGN(IX,IY,4,HANDLE,ERROR)
C      CALL ZFPLGN(HANDLE,ICOL,ERROR)
C      CALL ZDPLGN(HANDLE,ERROR)
      CALL ZPOLGN (IX,IY,4,ICOL)
      ID = 20
      IF (IMNTOP.LE.NITEM/2) THEN
C ADD IN THE LINE
        CALL ZDLINE(IX(2),IY(2),IX(2)-ID,IY(2),ICOL)
      ELSE
        CALL ZDLINE(IX(2),IY(2),IX(2)+ID,IY(2),ICOL)
      ENDIF
      RETURN
      END
 
 
CODE FOR ZMNVHI [ VERTICAL HIGHTLIGHTING ]
      SUBROUTINE ZMNVHI ( N , M )
      
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

      CHARACTER*12 CNAME
      INTEGER ICOL
C THIS ROUTINE DRAWS THE OLD OPTION (N) IN WHITE AND THE NEW OPTION (M)
C IN RED.
C CHECK FOR BLANKING OFF OF MENUS
C        IBLANK = 0
C      DO 5 I = IMENVT-1 , 2 , -1
C        IJ = NINT(RSTORE ( IMENU (I,3) + 3) )
C        IF (IJ.EQ.3) IBLANK = 1
C5     CONTINUE
C      IF (IBLANK.EQ.1) RETURN
      J = N
      IF ((INFOLL.EQ.1).AND.(IMNTOP.LE.NITEM/2)) THEN
        IX = IMENX(IMENVT)
      ELSE IF (INFOLL.EQ.0) THEN
        IX = IMENX(IMENVT)
      ELSE
        IX = IMENX(IMENVT) + 10
      ENDIF
      IY = IMENY(IMENVT)
10    CONTINUE
C GET THE NAME
C      CNAME = CSTORE((IVST-1)*2+(J-1)*2+1)//
C     c CSTORE((IVST-1)*2+(J-1)*2+2)
      JJ = NINT ( RSTORE ( J ) )
      CNAME = ' '//CSTORE(JJ)//CSTORE(JJ+1)
C ADD A STAR FOR FOLLOWING ASTERIX
      IF (RSTORE(J+3).GT.0) CNAME(1:1) = '*'
C GET THE POSITIONS
      IVPOS = IY + (J-IMENU(IMENVT,1))*15/4
      IF ((N.EQ.J).AND.(N.NE.M)) THEN
        ICOL = 15
        CALL ZDTEXT(CNAME,IX,IVPOS,ICOL)
      ELSE
        ICOL = 4
        CALL ZDTEXT(CNAME,IX,IVPOS,ICOL)
      ENDIF
      IF ((N.EQ.J).AND.(N.NE.M)) THEN
        J = M
        GOTO 10
      ENDIF
      RETURN
      END
 
CODE FOR ZSTCOL
      SUBROUTINE ZSTCOL
C This subroutine sets the colours of the 16 palette registers
      
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

      INTEGER IRED,IG,IB,IREG
      IF (ITCOL.EQ.1) THEN
C SET COLOURS TO NORMAL
        DO 10 I = 1 , 16
          IRED = IVGACL(1,I)
          IG = IVGACL(2,I)
          IB = IVGACL(3,I)
          IREG = I-1
          CALL ZCOLCH (IREG,IRED,IG,IB)
10      CONTINUE
      ELSE
C SET COLOURS TO GREY
        DO 20 I = 1 , 16
          IRED = IGREYC (1,I)
          IG = IGREYC (2,I)
          IB = IGREYC (3,I)
          IREG = I-1
          CALL ZCOLCH (IREG,IRED,IG,IB)
20      CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZCROSS
      SUBROUTINE ZCROSS (IATNO)
C THIS DRAWS A CROSS OF SIDE 0.05 ANGSTROMS TO REPRESENT ATOMS THAT
C HAVE NO BONDS JOINED TO THEM WHILE THEY ARE BEING DRAWN IN LINE
C STYLE.
      
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

      INTEGER IX(2), IY(2),ICOL
      X = RSTORE (IATNO+IXYZO)
      Y = RSTORE (IATNO+IXYZO+1)
      ISIDE = 0.05 * SCALE
C SET MINIMUM VALUE FOR CROSS SIDE.
      IF (ISIDE.LT.1) ISIDE=1
      IXX = NINT ( ( X - XCP ) * SCALE )
      IYY = NINT ( ( Y - YCP ) * SCALE )
C DO HORIZONTAL PART OF CROSS
      IX(1) = IXX - ISIDE
      IY(1) = IYY
      IX(2) = IXX + ISIDE
      IY(2) = IYY
      ICOL = NINT (RSTORE (IATNO+IATTYP+1))
      CALL ZDRLIN (3,IX,IY,2,IDEVCL(ICOL+1),IATNO)
C AND THEN VERTICAL PART
      IX(1) = IXX
      IY(1) = IYY - ISIDE
      IX(2) = IXX
      IY(2) = IYY + ISIDE
      CALL ZDRLIN (3,IX,IY,2,IDEVCL(ICOL+1),IATNO)
      RETURN
      END
 
CODE FOR ZDOSHD
C THIS ROUTINE CALCULATES AND DRAWS THE SHADING LINES FOR
C THERMAL ELLIPSOIDS
      SUBROUTINE ZDOSHD ( IATNO , XCENT , AXES1 )
      
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

      INTEGER IATNO
      REAL XCENT(3)
      REAL AXES(3,3)
      REAL AXES1(3,3)
      REAL WIDPIX
      REAL X1,X2,Y1,Y2
      DOUBLE PRECISION M1,M2
      INTEGER IX(2),IY(2),ICOL
      INTEGER IAXX1(3)
      INTEGER IAX1,IAX2
      DOUBLE PRECISION RDIR,CS,SN
      DOUBLE PRECISION AA,BB,CC
C IAXX1 contains the number of the principle ellipse bounding each of
C the segments in turn. The ellipses were drawn in the order
C 1,2 : 1,3 : 2,3
C the values of IAX1 and IAX2 are 1,2 : 2,3 : 3,1 and therefore we
C have to consider the ellipse bounds in the order 1,3,2.
      DATA IAXX1/1,3,2/
C MULTIPLY BY SCALE
      DO 5 I = 1 ,3
        DO 5 J = 1 ,3
C          AXES(I,J) = AXES1(I,J)*SCALE
          AXES(I,J) = AXES1(I,J)
5     CONTINUE
C      WIDPIX = 4.0*RES
      WIDPIX = 4.0/SCALE
      IF (ISCRN.EQ.5) THEN
        WIDPIX = WIDPIX * 10.0
      ENDIF
      IELP = RSTORE(IATNO+IXYZO+15)
      DO 10 I = 1 , 3
        IAX1 = I
        IAX2 = IAX1 + 1
        IF (IAX2.EQ.4) IAX2 = 1
C FIND OUT THE LENGTH OF AXIS 2 PROJECTED ONTO THE DIRECTION
C PERPENDICULAR TO AXIS1.
        IAXFLG = 0
        IF (ABS(AXES(1,IAX1)).LT.1.0E-6) THEN
C VERTICAL AXIS 1
           IAXFLG = 1
        ELSE
          M1 = AXES(2,IAX1)/AXES(1,IAX1)
        ENDIF
        IF (ABS(AXES(1,IAX2)).LT.1.0E-6) THEN
C VERTICAL AXIS 2
          IAXFLG = 2
        ELSE
          M2 = AXES(2,IAX2)/AXES(1,IAX2)
        ENDIF
        D = SQRT(AXES(2,IAX2)**2 + AXES(1,IAX2)**2)
        IF (IAXFLG.EQ.1) THEN
          P = ATAN2 ( AXES(2,IAX2), AXES(1,IAX2) )
          D = D * COS (P)
        ELSE IF (IAXFLG.EQ.0) THEN
          P = ATAN2 ( ( M1 - M2 ) , ( 1 + M1*M2 ) )
          D = SQRT ( AXES(2,IAX2)**2 + AXES(1,IAX2)**2)
          D = D * COS ( P - PI/2.0 )
        ELSE
          P = ATAN2 ( AXES(2,IAX1), AXES(1,IAX1) )
          D = AXES(2,IAX2)*COS(P)
        ENDIF
        NLINES = ABS(D / WIDPIX)
C WORK OUT THE LINE SPACING
        IF (IAXFLG.NE.1) THEN
          C = ATAN2(AXES(2,IAX1),AXES(1,IAX1))
          C = WIDPIX / COS (C)
        ELSE
          C = WIDPIX
        ENDIF
C        A = RSTORE(IELP + IAXX1(I)*4)**2*SCALE*SCALE
C        B = RSTORE(IELP+ IAXX1(I)*4+1)**2*SCALE*SCALE
        A = RSTORE(IELP + IAXX1(I)*4)**2
        B = RSTORE(IELP+ IAXX1(I)*4+1)**2
CDJW99 what is this(1994)!IF (A.LT.1.0E-5 .OR. B .LT. 1.0E-5) CONTINUE 
        PP = RSTORE(IELP + IAXX1(I)*4 + 2)
C WORK OUT THE COEFFICIENTS OF THE ELLIPSE
        CS = COS(PP)
        SN = SIN(PP)
        IF (IAXFLG.EQ.1) THEN
C EQUATION OF THE LINES ARE X = C
          AA = B*SN*SN + A*CS*CS
          BB = 2.0*CS*SN*(B-A)
          CC = B*CS*CS + A*SN*SN
        ELSE
          AA  = B*CS*CS + A*SN*SN + M1*M1*B*SN*SN + M1*M1*A*CS*CS
     +        + 2.0*M1*CS*SN*(B-A)
          BB = 2.0*M1*B*SN*SN + 2.0*M1*A*CS*CS + 2.0*CS*SN*(B-A)
          CC = B*SN*SN + A*CS*CS
        ENDIF
        RDIR = 1.0
        DO 30 J = 1 , NLINES
          C1 = C*J
          IF (IAXFLG.EQ.1) THEN
            X1 = C1
          ELSE IF (IAXFLG.EQ.2) THEN
            X1 = 0
          ELSE IF (IAXFLG.EQ.0) THEN
            X1 = C1/(M2-M1)
          ENDIF
          IF (IAXFLG.NE.2) THEN
            Y1 = M2*X1
          ELSE
            Y1 = C1
          ENDIF
C CHECK THE DIRECTION OF MOVEMENT
          IF (J.EQ.1) THEN
            IF (X1*AXES(1,IAX2)+Y1*AXES(2,IAX2).LT.0.0) THEN
              C1 = -C1
              C = -C
              X1 = -X1
              Y1 = -Y1
            ENDIF
          ENDIF
C SOLVE THE EQUATION
          TMP1 = C1*BB
          TMP2 = TMP1*TMP1 - 4.0* AA* (CC* C1*C1 - A*B)
          TMP3 = 2.0 * AA
          IF (TMP2 .LT. 0.0) THEN 
            TMP2 = 0.0
          ELSE
            TMP2 = SQRT(TMP2)
          ENDIF
          IF (IAXFLG.NE.1) THEN
            X2 = (- TMP1 + RDIR *  TMP2)/TMP3
            Y2 = M1*X2 + C1
          ELSE
            X2 = C1
            Y2 = (- TMP1 + RDIR *  TMP2)/TMP3
          ENDIF
C CHECK THE DIRECTION OF THE LINE HERE!
          IF (J.EQ.1) THEN
          IF (X2*AXES(1,IAX1) + Y2*AXES(2,IAX1) .LT. 0) THEN
            RDIR = -1.0
            IF (IAXFLG.NE.1) THEN
            X2 = (- TMP1 + RDIR *  TMP2)/TMP3
            Y2 = M1*X2 + C1
          ELSE
            X2 = C1
            Y2 = (- TMP1 + RDIR *  TMP2)/TMP3
            ENDIF
          ENDIF
          ENDIF
C          IX(1) = (XCENT(1)+X1-XCP)*SCALE
C          IY(1) = (XCENT(2)+Y1-YCP)*SCALE
C          IX(2) = (XCENT(1)+X2-XCP)*SCALE
C          IY(2) = (XCENT(2)+Y2-YCP)*SCALE
          IX(1) = (X1 +XCENT(1)-XCP)*SCALE
          IY(1) = (Y1 + XCENT(2)-YCP)*SCALE
          IX(2) = (X2 + XCENT(1)-XCP)*SCALE
          IY(2) = (Y2 + XCENT(2) - YCP)*SCALE
          ICOL = RSTORE(IATNO+IATTYP+1)
          IF (IFILL.EQ.0) THEN
            CALL ZDRLIN (1,IX,IY,2,IDEVCL(ICOL+1),IATNO)
          ELSE
            CALL ZDRLIN (1,IX,IY,2,IDEVCL(IFORE+1),IATNO)
          ENDIF
30      CONTINUE
10    CONTINUE
      RETURN
      END
 
CODE FOR ZCAPT
      SUBROUTINE ZCAPT
      
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

C --- WRITE TITIE (CAPTION) NEAR BOTTOM LEFT HAND CORNER
      IX = -NINT(.90 *XCEN)
      IF (IHAND.EQ.0) THEN
            IY = NINT (.90 * YCEN)
      ELSE
            IY = - NINT ( .90 * YCEN)
      ENDIF
      ICOL = ILABCL
      CALL ZDRTEX(IX,IY,CTITLE,ICOL)
      RETURN
      END
