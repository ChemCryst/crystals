CODE FOR HKLF52CRY
      PROGRAM HKL52CRY
C----- BASED UPON SIMON PARSONS ctwin.f90
C      IO BASED UPON RICHARD COOPERS cif2cry.fpp
c      Extraction of twin matrix by Bruce FOxman, 2017
c      Updated to include input of inversion twinning
c      by Bruce Foxman, 2020, this version 04 April 2021
c
c      removal of clusters of reflections where more than one
c      reflections have the same element ID, e.g. -2, -2, 1
c      Reflections are also omited from a scratch copy of the
c      hklf5 file before passing to TLAW2
C      latest patch to hklf52cry by djw, Sept 2022 (fix abnormal
C      termination on readin of hklf5 files)
C      latest patches to TLAW2 by bmf, Oct 2022 and March 2023,
C      to add symmetry determination of twin law matrices (Giacovazzo)
C      and additional explanatory text.
c 
      DIMENSION INDEX(3), VALUE(2), PARENT(3,3)
      CHARACTER *80 CLINE(9)
      CHARACTER *9  CELEM
      CHARACTER*256 PROGNM,INFIL,OUTFIL,OPTION
      DATA NINF    /10/
      DATA NOUTF   /11/
      DATA INFIL /' '/
      DATA OUTFIL /' '/
      DATA PARENT/1.,0.,0.,0.,1.,0.,0.,0.,1./
      COMMON/MAT/R(3,3,7),RSV(3,3,7),JJMAX

cdjw open a file for errors since DOS window closes too fast
c    lots of writes to 17 later
      open(17,file='HKL5.lis',status='unknown')
      ICAPTION=0
C Open a scratch file to write a new HKLF5 without repeated elements
      OPEN(14,STATUS='SCRATCH',FORM='FORMATTED')


      I =  IO(NINF,NOUTF,INFIL, OUTFIL)
      IF (I .LE. 0) STOP 'ERROR IN io UNITS'

      WRITE(11,"('\LIST 6')")
      WRITE(11,"('READ NCOEFF=6 TYPE=FIXED F''S=FSQ', 
     1 ' UNIT=DATAFILE CHECK=NO L30=YES ARCH=YES')")
      WRITE(11,"('FORMAT (3F4.0,2F16.4,F9.0)')")
      WRITE(11,"('STORE NCOEFF=12')")
      WRITE(11,"('OUTPUT INDICE /FO/ SQRT /FC/ PHAS BATCH RATIO ',
     1 'SIGMA CORRECT JCODE /FOT/ ELEM')")
      WRITE(11,"('INPUT H K L /FOT/ SIGMA(/FO/) ELEMENTS')")
      WRITE(11,"('END')")
C
C SAVE THE INPUT REFLECTION IN A CHARACTER LINE BUFFER.
C IF THE -N...1 BLOCK OF REFLECTIONS CONTAINS DUPLICATE KEYS
C DELETE THE BLOCK, OTHERWISE OUTPUT IT
      JELEM = 0
      LINE=1
      kdjw = 0
100   CONTINUE
      if (mod(kdjw,1000) .eq. 0) then
       write(6,*)'Working, Line number', kdjw
       write(17,*)'Working, Line number', kdjw
      endif 
      READ(10,'(A)',ERR=9000,END=9000)CLINE(LINE)
      kdjw = kdjw + 1
      READ(CLINE(LINE),'(3I4,2F8.2,I4)', err=9000,end=9000)
     1  INDEX,VALUE,KEY
C       BRUKER FILES END WITH H, K, L ALL = 0; SKIP THAT & LOOK FOR EOF
      IF(INDEX(1).EQ.0.AND.INDEX(2).EQ.0.AND.INDEX(3).EQ.0) GO TO 100
      LINE=LINE+1
C
      IF (KEY .LT.0) THEN
         DO 
           JELEM = KKEY(KEY,JELEM)
           READ(10,'(A)',ERR=9999,END=9000)CLINE(LINE)
           kdjw = kdjw + 1
           READ(CLINE(LINE),'(3I4,2F8.2,I4)') 
     1     INDEX,VALUE,KEY
           LINE=LINE+1
           IF (KEY .GT. 0) THEN
             JELEM = KKEY(KEY,JELEM)
             WRITE(CELEM,'(I9)') JELEM
             IFAIL=0
             DO I1=1,8
               IF(CELEM(I1:I1).EQ. ' ') CYCLE
               DO I2=I1+1,9
                 IF(CELEM(I1:I1).EQ.CELEM(I2:I2)) THEN 
C  DUPLICATE KEY - FAIL
                  IFAIL=1
                 ENDIF
               ENDDO
             ENDDO
             IF(IFAIL.EQ.1)THEN 
             IF(ICAPTION.EQ.0) THEN 
             WRITE(17,'(A)')' Duplicate element Keys'
             ICAPTION=ICAPTION+1
             ENDIF
      WRITE(17,'((A))')(CLINE(IDJW),IDJW=1,LINE-1)
             ELSE
      WRITE(14,'((A))')(CLINE(IDJW),IDJW=1,LINE-1)
             WRITE(11,'(3I4,2F16.4,I9)') 
     1       INDEX,VALUE,JELEM
             ENDIF
             JELEM = 0
             LINE=1
             GOTO 800
           ENDIF
         ENDDO
800      CONTINUE
      ELSE
         JELEM = ABS(KEY)
         WRITE(11,'(3I4,2F16.4,I9)') 
     1   INDEX,VALUE,JELEM
      WRITE(14,'((A))')(CLINE(IDJW),IDJW=1,LINE-1)
         JELEM = 0
         LINE=1
      ENDIF
      GOTO 100
C
C
9000  CONTINUE
      WRITE(11,"('-512')")
      write(6,*)'Working out twin laws'
      write(17,*)'Working out twin laws'
      CALL TLAW2(iout)
      IF (IOUT.GE.1) THEN
         OPEN(14,STATUS='UNKNOWN',FILE='l25.cry')
         IF(JJMAX.LT.1) THEN
            WRITE(14,'(A)')'# Twin Laws could not be determined'
         ELSE
          WRITE(14,'(/A/)') 
     1 '# CRYSTALS thinks the twin laws are:'
          WRITE(14,"('\LIST 25')")
          WRITE(14,9050) JJMAX+1
          WRITE(14,9100) PARENT
9050      FORMAT('READ NELEMENT=',I1)
          WRITE(14,9100) (((R(I,J,JJ),J=1,3),I=1,3),JJ=1,JJMAX)
          WRITE(14,"('END')")
9100      FORMAT(('MATRIX  ',(6F9.5),/,'CONT    ',3F9.5))
         ENDIF
      ENDIF
      STOP 'FINISHED'
C
9999  CONTINUE
      STOP 'ERROR'
      END
C
CODE FOR KKEY
      FUNCTION KKEY(KEY,JELEM)
      L = 0
      KKEY = 0
        IF (JELEM .EQ. 0) THEN
          KKEY = ABS(KEY)
        ELSE
          kkey = JELEM + ABS(KEY)*10**(INT(1.+LOG10(FLOAT(JELEM))))
        ENDIF
c      write(123,*) '   KKey=', kkey, jelem
      RETURN
      END      
c
CODE FOR IO
      function  io(ninf,noutf,infil, outfil)
C<ric02>
#if defined(CRY_FORTDIGITAL)
      use dflib
      interface
        subroutine no_stdout_buffer
        !dec$ attributes c :: no_stdout_buffer
        end subroutine
      end interface
#else
      interface
        subroutine no_stdout_buffer() bind(c)
          use, intrinsic :: ISO_C_BINDING
          implicit none
        end subroutine
      end interface
#endif      
      parameter (oddchr = 29)    !Number of chars to look out for.
      character*256 prognm,infil,outfil,option
      logical lfirst,namebl,allbl,linfl,loutfl
      integer optlen
C<ric02/>
C      data ninf    /10/
C      data noutf    /11/
C      data infil /' '/
C      data outfil /' '/
      io = -1

c      call no_stdout_buffer()


C<ric02>
C Read data from the commandline:
      optlen=132
#if defined(CRY_FORTDIGITAL)
      CALL GetArg(0,prognm,optlen)
#else
      call get_command_argument (0, prognm, optlen)
#endif
      lfirst = .FALSE.
      namebl = .FALSE.
      allbl = .FALSE.
      linfl = .FALSE.
      loutfl = .FALSE.

      N = 1
#if defined(CRY_FORTDIGITAL)
      NARG = IARGC()
#else
      NARG = command_argument_count ()+1
#endif

      DO WHILE ( N .LT. NARG )
#if defined(CRY_FORTDIGITAL)
        CALL GetArg(N,option,optlen) 
#else
        call get_command_argument (N,option,optlen) 
#endif
        IF (option.eq.'-f') THEN
          IF ( allbl ) GOTO 8000
          lfirst = .TRUE.
        ELSE IF (option.eq.'-a') THEN
          IF ( lfirst ) GOTO 8000
          allbl = .TRUE.
        ELSE IF (option.eq.'-n') THEN
          if ( loutfl ) GOTO 8000
          N = N + 1
          IF ( N .GE. NARG ) GOTO 8000
          namebl=.TRUE.
#if defined(CRY_FORTDIGITAL)
          CALL GetArg(N,outfil,optlen)
#else
          call get_command_argument (N,outfil,optlen)
#endif
          IF (outfil(1:1).eq.'-') GOTO 8000
        ELSE IF (option.eq.'-o') THEN
          if ( namebl ) GOTO 8000
          N = N + 1
          IF ( N .GE. NARG ) GOTO 8000
          loutfl=.TRUE.
#if defined(CRY_FORTDIGITAL)
          CALL GetArg(N,outfil,optlen)
#else
          call get_command_argument (N,outfil,optlen)
#endif
          IF (outfil(1:1).eq.'-') GOTO 8000
        ELSE IF (option(1:1).eq.'-') THEN
          GOTO 8000
        ELSE
          IF (linfl) GOTO 8000
          IF ( N .GE. NARG ) GOTO 8000
          linfl=.TRUE.
#if defined(CRY_FORTDIGITAL)
          CALL GetArg(N,infil,optlen)
#else
          call get_command_argument (N,infil,optlen)
#endif
        END IF
        N = N + 1
      END DO
C<ric02/>

C<ric02>
      if ( .not. linfl ) then
C</ric02>
           
C.......  Enter the name of input file
        write (6, '(1x,a)') 
     *      "Enter name of the input file (e.g. hklf5.dat):  "
        write (17, '(1x,a)') 
     *      "Enter name of the input file (e.g. hklf5.dat):  "

C<ric02>
        read (*, '(a)') infil
      end if
C</ric02>
      open (ninf, file=infil, status='old',err=9999)
      open (noutf, file=outfil, status='unknown',err=9999)      
      io = +1
      return
C<ric02>
8000  CONTINUE    !Usage error
      write(6,'(/3a/)')  'Usage: ',prognm(1:LEN_TRIM(prognm)),
     1 ' [-f|a] [[-n blockname]�[-o outputfile]] [inputfile]'

      write(17,'(/3a/)')  'Usage: ',prognm(1:LEN_TRIM(prognm)),
     1 ' [-f|a] [[-n blockname]�[-o outputfile]] [inputfile]'


9999  CONTINUE 
      if ( .not. linfl ) then   !Only print quit message in interactive mode.
        write (6,'(a)') 'Press ENTER to quit'
        read (*, '(a)') response
      end if
      write(17,*) 'Ends in error  ', infil, outfil

      stop 'error in I/O'
      end
c
CODE FOR XCREMS
      SUBROUTINE XCREMS( CSOURC, COUT, LENFIL)
C
C----- REMOVE EXTRA SPACES BY LEFT ADJUSTING STRING
C----- ROUTINE EXITS WHEN OUT STRING FULL
C      LENFIL      USEFUL LENGTH OF RETURNED STRING
C
      CHARACTER *(*) CSOURC, COUT
      CHARACTER *1 CBUF
C
      LINEL = LEN (CSOURC)
      LOUT = LEN (COUT)
      J = 0
      IFLAG = 0
      DO 1500 I = 1, LINEL
      CBUF = CSOURC(I:I)
      IF (CBUF .EQ. ' ') THEN
            IF (IFLAG .EQ. 1) THEN
                  GOTO 1500
            ELSE
                  IFLAG = 1
            ENDIF
      ELSE
            IFLAG = 0
      ENDIF
      IF (J .LT. LOUT) THEN
            J = J + 1
            COUT(J:J) = CBUF
      ELSE
            GOTO 1600
      ENDIF
1500  CONTINUE
1600  CONTINUE
      LENFIL = J
      IF (LENFIL .LT. LOUT) COUT(LENFIL+1:LOUT) = ' '
C
      RETURN
      END
C
CODE FOR TLAW2
      SUBROUTINE TLAW2(iout)
C      CODE FOR TLAW2
C      THIS ROUTINE IS DERIVED FROM THE
C      USEFUL SUBROUTINE TLAW2(iout) IN HKLF52CRY.F
C
C  IOUT = -1 FOR FAILURE
C         +1 FOR SUCCESS
C
C WRITTEN BY BRUCE FOXMAN, 2017, 2020 (-ve DETERMINANT
C HANDLING) APRIL 2021 (AUTODETECTION OF TWINABS' SETTING
C "2" AS THE MAJOR COMPONENT).  2023 (INCLUSION OF 
C GIACOVAZZO ANALYSIS OF TWIN LAW SYMMETRY), AND
C (B) DAVID WATKIN 2020 (MULTI-PASS REFLECTION EVALUATION
C AND REJECTION). 
c
      REAL HKLP(100000,3),HKLT(100000,3,7),
     1HT(3,3,7),HP(3,3,7),HTINV(3,3,7),R(3,3,7),
     2HT1,KT1,LT1,HP1,KP1,LP1
      REAL DJWT(3,7),RSV(3,3,7),DJWD(3,7),A(3,3),B(3,3),C(3,3),CI(3,3),
     1CMINIMUM(10),TRTEST(10),ACMINIMUM(10)
      INTEGER DJWI(3,7),DJWSUM(7),JTEST(7),NREF3(7),NREJ2(7)
      COMMON/MAT/R,RSV,JJMAX
      CHARACTER*1 CDJW
      DIMENSION INDX(3)
      CHARACTER*32 FILIN
      CHARACTER*2 SYMELEMENT(10)/' 1',' 2',' 3',' 4',' 6','-1',' m',
     1'-3','-4','-6'/
      CHARACTER*2 SYMSAVE
      DATA TRTEST    /4.,  0.,  1.,  2.,  3., -4.,  0., -1., -2., -3./
      DATA CMIN /0.0/
C
C     INDICATE SUCCESS
      IOUT = 1
      OPEN(13,STATUS='UNKNOWN',FILE='TLAW_OUT.LIS')
      WRITE(13,508)
      WRITE(*,508)
C
      DO 90 K=1,3
      DO 90 L=1,100000
      HKLP(L,K)=0.0
      DO 90 JJ=1,7
   90 HKLT(L,K,JJ)=0.0  
      DO 92 JJ=1,7
      JTEST(JJ)=0
      NREJ2(JJ)=0
      NREF3(JJ)=0
      DO 92 J=1,3
      DO 92 I=1,3
      HP(I,J,JJ) = 0.0
   92 HT(I,J,JJ) = 0.0 
*     FOLLOWING FOR STANDALONE VERSION ONLY
*93    WRITE(*,490) 
*      READ(*,'(A32)') FILIN
*      OPEN(14,STATUS='OLD',FILE=FILIN,ACCESS='SEQUENTIAL',
*     1FORM='FORMATTED')
      WRITE (*,97)
      WRITE (13,97)
   97 FORMAT(/,' First pass - determining initial twin law'/)
*
C     DO AUTO-DETECT TO SEE WHETHER THIS IS WHAT WE MIGHT CALL
C     A 'NORMAL' TWIN ASSIGNMENT, I.E. MAJOR COMPONENT IS "1"
C     OR, E.G., A 'TWINABS-CHOSEN' OR ANY OTHER SITUATION WHERE
C     THE MAJOR COMPONENT IS "2" INSTEAD OF "1".  TO AVOID MESSY
C     CODE, WE DO THS IN A SEPARATE SUBROUTINE, 'DETECT'.  IF
C     IDETECT=1 IT'S NORMAL (1) AND IF IDETECT=2, IT'S 'OTHER' (2).
C     TLAW3 ONLY CONSIDERS (A) TWINS WITH UP TO 8 COMPONENTS WHEN
C     "1" IS THE MAJOR, AND (B) TWINS WITH **ONLY** TWO COMPONENTS
C     WHEN "2" IS THE MAJOR.
      IDETECT=1
      CALL DETECT(IDETECT)
      IF(IDETECT.EQ.2) WRITE (*,*) ' MAJOR COMPONENT 2 DETECTED'
      NREF=1
C     READ IN AND CHECK FOR -VE/+VE SET SEQUENCE IN HKLF5 FILE
C     & DETERMINE THE NUMBER OF COMPONENTS (JJMAX)
      REWIND 14
      IF(IDETECT.EQ.2) GO TO 20
      IF(IDETECT.EQ.3) STOP 
     1'IF MAJOR COMP IS 2, MINOR MUST BE 1'
   10 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE
      IF(HT1.EQ.0.AND.KT1.EQ.0.AND.LT1.EQ.0) GO TO 10
      IF(JCODE.LT.0) GO TO 11
      GO TO 10
   11 JJ=IABS(JCODE)-1
      JTEST(JJ)=JJ
      HKLT(NREF,1,JJ)=HT1
      HKLT(NREF,2,JJ)=KT1
      HKLT(NREF,3,JJ)=LT1
   12 READ (14,500) HP1,KP1,LP1,FO2,SIGMA,JCODE2
      IF(HP1.EQ.0.AND.KP1.EQ.0.AND.LP1.EQ.0) GO TO 10
      IF(JCODE2) 14,13,13
   13 IF(JCODE2.NE.1) STOP ' MAJOR COMPONENT MUST BE 1'
      HKLP(NREF,1)=HP1
      HKLP(NREF,2)=KP1
      HKLP(NREF,3)=LP1
      NREF=NREF+1
      GO TO 10
   14 JJ=IABS(JCODE2)-1
      JTEST(JJ)=JJ
      HKLT(NREF,1,JJ)=HP1
      HKLT(NREF,2,JJ)=KP1
      HKLT(NREF,3,JJ)=LP1
      GO TO 12
C
C     READ IN AND CHECK FOR -1, 2 PAIR SEQUENCE IN HKLF5 FILE
   20 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE
      IF(JCODE.eq.-1) GO TO 22
      GO TO 20
   22 READ (14,500) HP1,KP1,LP1,FO2,SIGMA,JCODE2
      IF(JCODE2) 24,23,23
   23 jj=1
      HKLP(NREF,1)=HP1
      HKLP(NREF,2)=KP1
      HKLP(NREF,3)=LP1
      HKLT(NREF,1,JJ)=HT1
      HKLT(NREF,2,JJ)=KT1
      HKLT(NREF,3,JJ)=LT1
      if(nref.le.4) write(*,*) hp1,kp1,lp1,ht1,kt1,lt1
      NREF=NREF+1
      GO TO 20
   24 JJ=IABS(JCODE2)-1
      JTEST(JJ)=JJ
      HKLT(NREF,1,JJ)=HP1
      HKLT(NREF,2,JJ)=KP1
      HKLT(NREF,3,JJ)=LP1
      GO TO 22

C
C     ACCUMULATE H(TWIN) X H(TWIN)^T  (I.E., HT) 
C
C     ... AND  H(PRIN) X H(TWIN)^T (I.E., HP)
C
  100 continue
      JJMAX=MAXVAL(JTEST)
      IF(iDETECT.EQ.2) JJMAX=1
      DO 150 JJ=1,JJMAX
      DO 150 J=1,NREF-1
      HT(1,1,JJ)=HT(1,1,JJ)+HKLT(J,1,JJ)**2
      HT(1,2,JJ)=HT(1,2,JJ)+HKLT(J,1,JJ)*HKLT(J,2,JJ)
      HT(1,3,JJ)=HT(1,3,JJ)+HKLT(J,1,JJ)*HKLT(J,3,JJ)
      HT(2,2,JJ)=HT(2,2,JJ)+HKLT(J,2,JJ)**2
      HT(2,3,JJ)=HT(2,3,JJ)+HKLT(J,2,JJ)*HKLT(J,3,JJ)
      HT(3,3,JJ)=HT(3,3,JJ)+HKLT(J,3,JJ)**2
C
      HP(1,1,JJ)=HP(1,1,JJ)+HKLP(J,1)*HKLT(J,1,JJ)
      HP(1,2,JJ)=HP(1,2,JJ)+HKLP(J,1)*HKLT(J,2,JJ)
      HP(1,3,JJ)=HP(1,3,JJ)+HKLP(J,1)*HKLT(J,3,JJ)
      HP(2,2,JJ)=HP(2,2,JJ)+HKLP(J,2)*HKLT(J,2,JJ)
      HP(2,3,JJ)=HP(2,3,JJ)+HKLP(J,2)*HKLT(J,3,JJ)
      HP(3,3,JJ)=HP(3,3,JJ)+HKLP(J,3)*HKLT(J,3,JJ)
      HP(2,1,JJ)=HP(2,1,JJ)+HKLP(J,2)*HKLT(J,1,JJ)
      HP(3,1,JJ)=HP(3,1,JJ)+HKLP(J,3)*HKLT(J,1,JJ)
      HP(3,2,JJ)=HP(3,2,JJ)+HKLP(J,3)*HKLT(J,2,JJ)
  150 CONTINUE
C
C     GENERATE REMAINDER OF HT SYMMETRIC MATRIX
C
      DO 160 JJ=1,JJMAX
      HT(2,1,JJ)=HT(1,2,JJ)
      HT(3,1,JJ)=HT(1,3,JJ)
  160 HT(3,2,JJ)=HT(2,3,JJ)           
C
      NTOT=NREF-1
      WRITE(13,501)NTOT
      WRITE(*,501)NTOT
C
C     INVERT H(TWIN) X H(TWIN)^T (I.E., HT)
C
      DO 170 JJ=1,JJMAX
      DO 161 I=1,3
      DO 161 J=1,3
      C(I,J)=HP(I,J,JJ)
      A(I,J)=HT(I,J,JJ)
      CALL MATINV(C,CI,D)
  161 HTINV(I,J,JJ)=CI(I,J)
C
      IF(D.EQ.0.0) GO TO 400
C
C     GET R = (H(TWIN) X H(TWIN)^T) X (H(PRIN) X H(TWIN)^T)^-1  
C     
C
      CALL MATMULT(A,CI,3,B)
      DO 162 I=1,3
      DO 162 J=1,3
  162 R(I,J,JJ)=B(I,J)
      CALL DTRM(B,3,D1,INDX)
      WRITE(13,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
      WRITE(*,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
C     (2020 edit) Test determinant only for 5% dev from +/- 1.0
      IF(abs(D1).LT.0.95.OR.abs(D1).GT.1.05) WRITE(13,505)
      IF(abs(D1).LT.0.95.OR.abs(D1).GT.1.05) WRITE(*,505)
      if(d1.lt.0) then
        write(13,503) d1
        write(13,5051)
        write(*,503) d1
        write(*,5051)
      endif
  170 CONTINUE

C     DJW: SAVE THE MATRIX BEFORE IT IS OVERWRITTEN 
C     (SIGNS WERE LOST FROM LAST ROW) 
C     AND CLEAR THE ACCUMULATORS
      DO JJ=1,7
       DOJ=1,3
        DOI=1,3
         RSV(I,J,JJ)=R(I,J,JJ)
         HP(I,J,JJ) = 0.0
         HT(I,J,JJ) = 0.0 
        ENDDO
       ENDDO
      ENDDO
c
      WRITE(*,197)
      WRITE(13,197)
  197 FORMAT(/,' Second pass - flagging unwanted (error) reflections',/)      
C     DJW  GO THROUGH THE DATA AGAIN REJECTING REFLECTIONS WHICH 
C     DO NOT PREDICT C CORRECTLY.  THUS CAN OCCUR WHEN THE MINOR 
C     COMPONENT IS TOO FAR (IN RECIPROCAL SPACE) FROM THE PRINCIPAL.

      NREF2 = 0
      NREJ = 0
      DO 199 JJ=1,JJMAX
      DO 199 J=1,NREF-1
      CDJW = ' '

C     TRANSFORM THE PRINCIPAL
C
      DJWT(1,JJ)=HKLP(J,1)*RSV(1,1,JJ)+HKLP(J,2)*RSV(1,2,JJ)+HKLP(J,3)*
     1RSV(1,3,JJ)
      DJWT(2,JJ)=HKLP(J,1)*RSV(2,1,JJ)+HKLP(J,2)*RSV(2,2,JJ)+HKLP(J,3)*
     1RSV(2,3,JJ)
      DJWT(3,JJ)=HKLP(J,1)*RSV(3,1,JJ)+HKLP(J,2)*RSV(3,2,JJ)+HKLP(J,3)*
     1RSV(3,3,JJ)
C
C     SKIP ENTRY IF THIS IS A MULTICOMPONENT TWIN AND THERE IS 
C     NO ENTRY FOR THIS COMPONENT
C
      IF(HKLT(J,1,JJ).EQ.0.0.AND.HKLT(J,2,JJ).EQ.0.0.AND.
     1HKLT(J,3,JJ).EQ.0.0) GO TO 199
C     FIND THE ACTUAL DISCREPANCY
      DJWD(1,JJ) = ABS(DJWT(1,JJ)-HKLT(J,1,JJ))
      DJWD(2,JJ) = ABS(DJWT(2,JJ)-HKLT(J,2,JJ))
      DJWD(3,JJ) = ABS(DJWT(3,JJ)-HKLT(J,3,JJ))

C      FIND THE NEAREST INTEGER DISCREPANCY (AS IS DONE IN CRYSTALS)
C
      DJWI(1,JJ) = NINT(DJWT(1,JJ)-HKLT(J,1,JJ))
      DJWI(2,JJ) = NINT(DJWT(2,JJ)-HKLT(J,2,JJ))
      DJWI(3,JJ) = NINT(DJWT(3,JJ)-HKLT(J,3,JJ))
C
C     FIND THE TOTAL INTEGER DISCREPANCY
C
180   DJWSUM(JJ) = ABS(DJWI(1,JJ))+ABS(DJWI(2,JJ))+ABS(DJWI(3,JJ))
      IF (DJWSUM(JJ) .GT. 0) CDJW='*'
      IF(DJWD(1,JJ).GE.0.4.OR.DJWD(2,JJ).GE.0.4.OR.DJWD(3,JJ).GE.0.4)
     1 then
       write(13,'(7x,a,11x,a,17x,a,16x,a,6x,a)')
     1 'Transformed','Minor','Error','NINT error','Total error'
       write(*,'(7x,a,11x,a,17x,a,16x,a,6x,a)')
     1 'Transformed','Minor','Error','NINT error','Total error'

      WRITE(13,'(A,2X,3F6.2,3X, 3F6.2, 3X, 3F7.3,3I6, 3X, I6)') 
     2 CDJW, (DJWT(K,JJ),K=1,3), HKLT(J,1,JJ),HKLT(J,2,JJ),HKLT(J,3,JJ),
     3 (DJWD(K,JJ),K=1,3), (DJWI(K,JJ),K=1,3), DJWSUM(JJ)
c
      WRITE(*,'(A,2X,3F6.2,3X, 3F6.2, 3X, 3F7.3,3I6, 3X, I6)') 
     2 CDJW, (DJWT(K,JJ),K=1,3), HKLT(J,1,JJ),HKLT(J,2,JJ),HKLT(J,3,JJ),
     3 (DJWD(K,JJ),K=1,3), (DJWI(K,JJ),K=1,3), DJWSUM(JJ)
      endif
C
C     DON'T USE THE REFLECTION IF IT DOESNT MATCH.
C     THIS SHOULD ALSO BE DONE WHEN GENERATING A CRYSTALS FILE FROM
C     AN HKLF5 FILE
C
      IF(DJWSUM(JJ).GT.0) THEN
            NREJ = NREJ + 1
            NREJ2(JJ)=NREJ2(JJ)+1
            GOTO 199
      ENDIF
C
      NREF2 = NREF2 +1
      NREF3(JJ) = NREF3(JJ)+1
      HT(1,1,JJ)=HT(1,1,JJ)+HKLT(J,1,JJ)**2
      HT(1,2,JJ)=HT(1,2,JJ)+HKLT(J,1,JJ)*HKLT(J,2,JJ)
      HT(1,3,JJ)=HT(1,3,JJ)+HKLT(J,1,JJ)*HKLT(J,3,JJ)
      HT(2,2,JJ)=HT(2,2,JJ)+HKLT(J,2,JJ)**2
      HT(2,3,JJ)=HT(2,3,JJ)+HKLT(J,2,JJ)*HKLT(J,3,JJ)
      HT(3,3,JJ)=HT(3,3,JJ)+HKLT(J,3,JJ)**2
C
      HP(1,1,JJ)=HP(1,1,JJ)+HKLP(J,1)*HKLT(J,1,JJ)
      HP(1,2,JJ)=HP(1,2,JJ)+HKLP(J,1)*HKLT(J,2,JJ)
      HP(1,3,JJ)=HP(1,3,JJ)+HKLP(J,1)*HKLT(J,3,JJ)
      HP(2,2,JJ)=HP(2,2,JJ)+HKLP(J,2)*HKLT(J,2,JJ)
      HP(2,3,JJ)=HP(2,3,JJ)+HKLP(J,2)*HKLT(J,3,JJ)
      HP(3,3,JJ)=HP(3,3,JJ)+HKLP(J,3)*HKLT(J,3,JJ)
      HP(2,1,JJ)=HP(2,1,JJ)+HKLP(J,2)*HKLT(J,1,JJ)
      HP(3,1,JJ)=HP(3,1,JJ)+HKLP(J,3)*HKLT(J,1,JJ)
      HP(3,2,JJ)=HP(3,2,JJ)+HKLP(J,3)*HKLT(J,2,JJ)
199    CONTINUE
      write(*,203)
      write(13,203)
  203 FORMAT (/,' Third pass - determining improved twin law')
C     REPEAT THE WORK
C
C     GENERATE REMAINDER OF HT SYMMETRIC MATRIX
C
      DO 205 JJ=1,JJMAX
      HT(2,1,JJ)=HT(1,2,JJ)
      HT(3,1,JJ)=HT(1,3,JJ)
  205 HT(3,2,JJ)=HT(2,3,JJ)           

C 210   CONTINUE
      WRITE(13,510)
      WRITE(13,509)NREF2
      WRITE(*,510)
      WRITE(*,509)NREF2
      IF(JJMAX.EQ.1) GO TO 215
      WRITE(13,506) (K+1,NREF3(K), K=1,JJMAX)
      WRITE(*,506) (K+1,NREF3(K), K=1,JJMAX)
  215 WRITE(13,'(/, A,I7//)')' Number of non-matching reflections = ',
     1NREJ      
      WRITE(*,'(/, A,I7/)')' Number of non-matching reflections = ',
     1NREJ
      IF (NREJ.EQ.0) WRITE(13,5061)
      IF (NREJ.EQ.0) WRITE(*,5061)
      IF(JJMAX.EQ.1) GO TO 220
      WRITE(13,507) (K+1,NREJ2(K), K=1,JJMAX)
      WRITE(*,507) (K+1,NREJ2(K), K=1,JJMAX)
C
C     INVERT H(TWIN) X H(TWIN)^T (I.E., HT)
C
C
  220 DO 280 JJ=1,JJMAX
      DO 261 I=1,3
      DO 261 J=1,3
      C(I,J)=HP(I,J,JJ)
      A(I,J)=HT(I,J,JJ)
      CALL MATINV(C,CI,D)
  261 HTINV(I,J,JJ)=CI(I,J)
C
      IF(D.EQ.0.0) GO TO 400
C
C     GET R = (H(TWIN) X H(TWIN)^T) X (H(PRIN) X H(TWIN)^T)^-1  
C
      CALL MATMULT(A,CI,3,B)
      DO 262 I=1,3
      DO 262 J=1,3
  262 R(I,J,JJ)=B(I,J)
      CALL DTRM(B,3,D1,INDX)
      WRITE(13,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
      WRITE(*,502) JJ+1,((R(I,J,JJ),J=1,3),I=1,3)
C     (2020 edit) Test determinant only for 5% dev from +/- 1.0
      IF(abs(D1).LT.0.95.OR.abs(D1).GT.1.05) THEN
            WRITE(13,505)
            WRITE(*,505)
            IOUT= -1                !INDICATE FAILURE
      ENDIF
      WRITE(13,503) D1
      WRITE(*,503) D1
270   CONTINUE
      TRACE=R(1,1,JJ)+R(2,2,JJ)+R(3,3,JJ)
      CARMELO=D1+TRACE
      IF(CARMELO.GT.-0.05.AND.CARMELO.LT.0.05) GO TO 277
      DO 274 I=1,10
      CMINIMUM(I)=CARMELO-TRTEST(I)
274   ACMINIMUM(I)=ABS(CMINIMUM(I))
275   CMIN=MINVAL(ACMINIMUM)
      DO 276 I=1,10
276   IF(ACMINIMUM(I).EQ.CMIN) ISAVE=I
      SYMSAVE=SYMELEMENT(ISAVE)
      GO TO 278
277   SYMSAVE=SYMELEMENT(2)
      IF (D1.LT.-0.95.AND.D1.GT.-1.05) SYMSAVE=SYMELEMENT(7)
278   WRITE(*,512) TRACE,CARMELO,SYMSAVE
      WRITE(13,512) TRACE,CARMELO,SYMSAVE
280   CONTINUE
C     DJW: SAVE THE MATRIX BEFORE IT IS OVERWRITTEN 
C     (SIGNS WERE LOST FROM LAST ROW)
C     AND CLEAR THE ACCUMULATORS
      DO JJ=1,7
       DOJ=1,3
        DOI=1,3
         RSV(I,J,JJ)=R(I,J,JJ)
         HP(I,J,JJ) = 0.0
         HT(I,J,JJ) = 0.0 
        ENDDO
       ENDDO
      ENDDO
      WRITE(*,397)
      WRITE(13,397)
  397 FORMAT (/,' Fourth pass - creating CRYSTALS LIST 6')
      RETURN
  400 WRITE(13,504) D
      WRITE(*,504) D
      STOP
  490 FORMAT(//' ENTER FILE NAME, WITH EXTENSION, FOR SHELX-STYLE'
     1,' HKLF5 FILE: ',$)
  500 FORMAT(3F4.0,2F8.2,I4)
  501 FORMAT(//,' Extraction Of Twin Laws From HKLF5 File ',
     1' (Using all Reflections)',//,
     2' Number Of Twinned Reflection = ', I7)
  502 FORMAT(//' DERIVED TWIN LAW FOR COMPONENT 1 -->',I2,' :', /,
     1 3(/,3F10.6))
  503 FORMAT(/' DETERMINANT = ',F8.3)
  504 FORMAT(/' DETERMINANT = ',F8.3, ' ERROR: ENTER TWIN LAW BY HAND '
     1,/,' AND/OR CHECK INPUT DATA')
  505 FORMAT(/
     1 'Determinant is quite far from 1.0.',
     2 ' Inspect TLAW_OUT.LIS for errors')
5051  format(/
     1 'The determinant is negative. If inversion twin laws have been',
     2/,'included, this is expected and no user action is required.',/
     3 /'Otherwise, please reprocess data without averaging')
  506 FORMAT((/' NO. OF SETS FOR COMPONENT ',I4, ' = ',I7))
 5061 FORMAT(/' All Reflections Were Accepted; The Twin Law(s) Below',
     1' Do Not Differ From Results Presented Above')
  507 FORMAT((/' No. unmatched for component ',I4, ' = ', I5))

  508 FORMAT(//
     *  ' WRITTEN BY BRUCE FOXMAN, 2017, 2020 (-ve DETERMINANT'/,
     *  ' HANDLING) APRIL 2021 (AUTODETECTION OF TWINABS SETTING'/,
     *  ' 2 AS THE MAJOR COMPONENT).  2023 (INCLUSION OF '/,
     *  ' GIACOVAZZO ANALYSIS OF TWIN LAW SYMMETRY), AND '/,
     *  ' (B) DAVID WATKIN 2017, (ORIGINAL CASTING OF THE ',/
     *  ' DERIVATION, 2020 (MULTI-PASS REFLECTION EVALUATION ',/
     *  ' AND REJECTION). '/,
     *  ' '/,
     *  ' '/,
     *  ' This program processes a SHELX hklf5 format file of'/,
     *  ' twinned data in order to determine the twin laws and hence'/,
     *  ' the indices of the contributors to the observed intensity.'/,
     *  ' '/,
     *  ' In a twinned crystal the reflections from the components'/,
     *  ' may overlap completely (TLS or meroheral) or more-or-less'/,
     *  ' coincide (TLQS or non-merohedral). If we have a TLQS twin'/,
     *  ' with an obliquity significantly different from zero, the'/,
     *  ' positions of the minor components in reciprocal space'/,
     *  ' will deviate from those of the major component.  When the'/,
     *  ' frames are processed, a threshold is set for the maximum'/,
     *  ' separation acceptable for the components of a twinned'/,
     *  ' reflection.'/,
     *  ' '/,
     *  ' '/,
     *  ' The twin law is determined by solving these simultaneous'/,
     *  ' equations for all twinned reflections.'/,
     *  ' '/,
     *  ' H(TWIN)= (TWIN_LAW)*H(PARENT)'/,
     *  ' '/,
     *  ' '/,
     *  ' If the data processing routine has transformed the indices'/,
     *  ' of the minor reflections using Space Group Symmety (as may'/,
     *  ' happen if the data is merged), the equation above cannot'/,
     *  ' be used. If the determinant of the twin law is'/,
     *  ' substantially different from unity, a warning that the'/,
     *  ' input data has probably been merged previously is passed '/,
     *  ' to the user.'/,
     *  ' '/,
     *  ' After extraction of a twin law, ithat law is applied to '/,
     *  ' every main reflection in the HKLF5 file to generate the '/,
     *  ' indices of the minor components. Because the twin law is '/,
     *  ' derivedfrom experimental data, the generated indices may '/,
     *  ' be non-integral.'/,
     *  ' '/,
     *  ' If the absolute value of the deviation between the input'/,
     *  ' and generated indices exceeds 0.5 for any index pair, the'/,
     *  ' minor component is regarded as unreliable and flagged as'/,
     *  ' unacceptable.'/,
     *  ' '/,
     *  ' The computed indices must be rounded to integers for the'/,
     *  ' structure factor calculation. If the rounded index exceeds'/,
     * ' a user-defined deviation from the  observed index, then the'/,
     *  ' indexing is unsound and the whole reflection (principal'/,
     *  ' and minor components) will be eliminated from the final'/,
     *  ' CRYSTALS data set.'/,
     *  ' '/,
     *  ' These very unreliable reflections are marked with an "*"'/,
     *  ' in the list below.'/,
     *  ' '/,
     *  ' The twin law is then redetermined without these unreliable'/,
     *  ' reflections.'/,
     *  ' '/,
     *  ' If the user has included inversion twinning in the twin'/,
     *  ' laws, then this will be flagged, the user informed, but no'/,
     *  ' action will be taken: the file will be processed with the'/,
     *  ' regular and the inversion twin laws.'/,
     *  ' '/,
     *  ' The input file is finally re-processed to a CRYSTALS LIST'/,
     *  ' 6 with this final matrix, omitting deviant reflections.'/,
     *  ' See the bottom of TLAW_OUT.LIS for the final results'/,
     *  ' '/,
     *  ' '/,
     *  ' '/,
     *  '   The acceptable amount of deviation is set by the'/,
     *  ' criteria for overlapping reciprocal lattice points when '/,
     *  ' the data is collected.  In CRYSTALS, the indices of the'/,
     *  ' minor components  are generated from the indices of the'/,
     *  ' principal component and the twin law. If we have  a TLS'/,
     *  ' (meroheral) twin the generated reflections will be (within'/,
     *  ' computational errors)  integral.'/,
     *  ' '/,
     *  ' Note that a normal structure factor calculation requires'/,
     *  ' integer  indices. If TLAW finds non-integral indices it'/,
     *  ' means that the data integration volume has included two'/,
     *  ' reflections accidentally close to each other in reciprocal'/,
     *  ' space, rather than being related by the twin law.  Without'/,
     *  ' access to the original observed frames, the software and'/,
     *  ' the user-defined criteria used in analysing the frames,'/,
     *  ' CRYSTALS takes the soft option of rejecting the fractional'/,
     *  ' integer data.'/,
     *  ' '/,
     *  '  See Donnay, G.; Donnay, J. D. H. Canadian Mineralogist,'/,
     *  ' 1974, 12, 422-425,  and in Giacovazzo, C., ed.;'/,
     *  ' Fundamentals of Crystallography, 2nd Ed.; Oxford  Science'/,
     *  ' Publications, 2002, pp. 229-236 & 278-285.'/,
     *  ' '/,
     *  ' '/,
     1 //)

  509 FORMAT(//,
     1 'Analysis of twin laws from hklf5 file (selected ',
     1 'reflections rejected)',//,
     2 'Number of reflection twin sets = ', I7,//
     3 'In the following analysis, the symmetry of each twin law is ',
     4 'listed.',
     5 //'The relationship used to obtain the symmetry operation from',
     6 ' a given twin law is: '//,
     7 '                     Trace+det:  4  0  1  2  3 -4  0 -1 -2 -3',/
     8 '                       Element:  1  2  3  4  6 -1 -2 -3 -4 -6'
     9 ,//' See Giacovazzo, C., ed.; Fundamentals of ',
     A'Crystallography, 2nd Ed.; Oxford'/' Science Publications, 2002,',
     B' Appendix 1.D, pp. 44-47.')
  510 FORMAT(//' ***** Recalculation with non-matching reflections ',
     1'(if any) deleted *****')

  512 FORMAT(//' TRACE = ', F5.2// ' TRACE+DETERMINANT = ', F5.2,//
     1' SYMMETRY ELEMENT = ', 3X,A2)
      END

      SUBROUTINE DETECT(IDETECT)
      REAL HKLP(100000,3),HKLT(100000,3,7),
     1HT(3,3,7),HP(3,3,7),HTINV(3,3,7),R(3,3,7),
     2HT1,KT1,LT1,HP1,KP1,LP1
C
      IDETECT2=0
      IDETECT3=0
      REWIND 14
   10 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE
      IF(JCODE.GT.0) GO TO 10
      IF(JCODE.EQ.-1) GO TO 20
      GO TO 10
   20 READ (14,500,END=100) HT1,KT1,LT1,FO,SIGMA,JCODE2
      IF (JCODE2.EQ.2) IDETECT2=2
      IF (JCODE2.GE.3) IDETECT3=3
      GO TO 10
  100 IDETECT=MAX(IDETECT2,IDETECT3)
      RETURN
C     WRITE (*,*) ' EOF REACHED; CHECK FILE FOR ERRORS'
  500 FORMAT(3F4.0,2F8.2,I4)
      END

      SUBROUTINE MATINV(A,B,D)
      IMPLICIT  NONE
      INTEGER*2 K,N
      REAL*4    A,B,D
      DIMENSION A(3,3),B(3,3)
      CALL VMULT(A(1,2),A(1,3),B(1,1))
      CALL VMULT(A(1,3),A(1,1),B(1,2))
      CALL VMULT(A(1,1),A(1,2),B(1,3))
      D=A(1,1)*B(1,1)+A(2,1)*B(2,1)+A(3,1)*B(3,1)
      IF(D.EQ.0.0)RETURN
      N=1
10    K=1
15    B(K,N)=B(K,N)/D
      K=K+1
      IF(K.LE.3)GOTO 15
      N=N+1
      IF(N.LE.3)GOTO 10
      CALL MACOL(B)
      RETURN
      END

      SUBROUTINE VMULT(A,B,C)
      IMPLICIT  NONE
      REAL*4    A,B,C
      DIMENSION A(3),B(3),C(3)
      C(1)=A(2)*B(3)-A(3)*B(2)
      C(2)=A(3)*B(1)-A(1)*B(3)
      C(3)=A(1)*B(2)-A(2)*B(1)
      RETURN
      END

      SUBROUTINE MACOL(A)
      IMPLICIT  NONE
      INTEGER*2 K,N
      REAL*4    A,T
      DIMENSION A(3,3)
      N=1
 5    K=2
10    T=A(K,N)
      A(K,N)=A(N,K)
      A(N,K)=T
      IF(N.EQ.3)RETURN
      K=K+1
      IF(K.LE.3)GOTO 10
      N=3
      GOTO 5
      END

      SUBROUTINE MATMULT(A,B,N,C)
      DIMENSION A(N,N),B(N,N),C(N,N)
      DO 100 I=1,N
      DO 100 J=1,N
      C(I,J)=0.
      DO 100 K=1,N
  100 C(I,J)=C(I,J)+A(I,K)*B(K,J)
      RETURN
      END
      SUBROUTINE DTRM(A,N,D,INDX)
C
C SUBROUTINE FOR EVALUATING THE DETERMINANT OF A MATRIX USING 
C THE PARTIAL-PIVOTING GAUSSIAN ELIMINATION SCHEME.
C
      DIMENSION A(N,N),INDX(N)
C
      CALL ELGS(A,N,INDX)
C
      D    = 1.0
      DO     100 I = 1, N
         D = D*A(INDX(I),I)
  100 CONTINUE
C
      MSGN = 1
      DO     200 I = 1, N
        DO   150 WHILE (I.NE.INDX(I))
          MSGN = -MSGN
          J = INDX(I)
          INDX(I) = INDX(J)
          INDX(J) = J
  150   END DO
  200 CONTINUE
      D = MSGN*D
C
      RETURN
      END
C
      SUBROUTINE ELGS(A,N,INDX)
C
C SUBROUTINE TO PERFORM THE PARTIAL-PIVOTING GAUSSIAN ELIMINATION.
C A(N,N) IS THE ORIGINAL MATRIX IN THE INPUT AND TRANSFORMED
C MATRIX PLUS THE PIVOTING ELEMENT RATIOS BELOW THE DIAGONAL IN
C THE OUTPUT.  INDX(N) RECORDS THE PIVOTING ORDER.

C
      DIMENSION A(N,N),INDX(N),C(N)
C
C INITIALIZE THE INDEX
C
      DO     50    I = 1, N
        INDX(I) = I
   50 CONTINUE
C
C FIND THE RESCALING FACTORS, ONE FROM EACH ROW
C
        DO     100   I = 1, N
          C1= 0.0
          DO    90   J = 1, N
            C1 = AMAX1(C1,ABS(A(I,J)))
   90     CONTINUE
          C(I) = C1
  100   CONTINUE
C
C SEARCH THE PIVOTING (LARGEST) ELEMENT FROM EACH COLUMN
C
      DO     200   J = 1, N-1
        PI1 = 0.0
        DO   150   I = J, N
          PI = ABS(A(INDX(I),J))/C(INDX(I))
          IF (PI.GT.PI1) THEN
            PI1 = PI
            K   = I
          ELSE
          ENDIF
  150   CONTINUE
C
C INTERCHANGE THE ROWS VIA INDX(N) TO RECORD PIVOTING ORDER
C
        ITMP    = INDX(J)
        INDX(J) = INDX(K)
        INDX(K) = ITMP
        DO   170   I = J+1, N
          PJ  = A(INDX(I),J)/A(INDX(J),J)
C
C RECORD PIVOTING RATIOS BELOW THE DIAGONAL
C
          A(INDX(I),J) = PJ
C
C MODIFY OTHER ELEMENTS ACCORDINGLY
C
          DO 160   K = J+1, N
            A(INDX(I),K) = A(INDX(I),K)-PJ*A(INDX(J),K)
  160     CONTINUE
  170   CONTINUE
  200 CONTINUE
C
      RETURN
      END
