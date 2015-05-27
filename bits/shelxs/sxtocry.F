      PROGRAM  SHTOCA
#if defined(CRY_FORTDIGITAL)
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
C
C Program to convert shelx ".ins" file to crystals-type ".cam" file.
C The user must alter any local matters - e.g. "compound codes" that
C are not six characters long.  Shelx free variable codes are NOT
C treated, but "fixed" variables will have 10 subtracted from them.
C Output from Shelx-93 or 97 may be used. Temperature factors (usually
C for H-atoms of the form -1.50 etc are converted to 0.05. Atoms names
C which are not of the form atomsymbol plus integer will often give
C unacceptable results.  Check the output for any of these.
C
      DIMENSION A(10),B(12),C(6)
      CHARACTER*1 EQ
      CHARACTER*2 LATT,LATY(7),SYM
      CHARACTER*4 SHELWD(71),NAME,CENT
      CHARACTER*6 CPCODE
      CHARACTER*72 DATA,SYMM(24)
      DATA LATY/' P',' I',' R',' F',' A',' B',' C'/
      DATA SHELWD/'TITL','CELL','ZERR','LATT','SYMM','SFAC','UNIT', 
     &     'TEMP','SIZE','HKLF','OMIT','EXTI','MERG','MOVE','ANIS', 
     &     'AFIX','HFIX','FRAG','FEND','EQIV','CONN','PART','BIND', 
     &     'FREE','DFIX','SAME','FLAT','ISOR','L.S.','BLOC','DAMP', 
     &     'WGHT','FVAR','BOND','CONF','MPLA','LIST','FMAP','GRID', 
     &     'PLAN','MOLE','ACTA','END ','DISP','LAUE','REM ','MORE', 
     &     'TIME','SHEL','BASF','TWIN','SWAT','SPEC','RESI','RTAB', 
     &     'EXYZ','EADP','BUMP','SADI','CHIV','DELU','SIMU','DEFS', 
     &     'SUMP','CGLS','SLIM','WPDB','DANG','HTAB','    ','    '/
C get compound code from instruction line - UNIX specific! 
C      CALL SXNM(CPCODE,LN)
C general input - change this as needed.....

      call no_stdout_buffer()

      WRITE(6,'('' Compound code (filename without .INS) : A6'')') 
      READ(5,'(A6)') CPCODE
C set initial values of variables
      L1=0
      L2=0
      L5=0
      NWDS = 71
      CENT=' YES'
      LATT=' P'
      NSYM = 1
      NATS = 0
      SYMM(1)='  X, Y, Z'
C  file 4 is input, file 7 output and file 8 used only internally.
      OPEN(4, FILE=CPCODE//'.ins')
      OPEN(7, FILE=CPCODE//'.cam')
      OPEN(8, STATUS='SCRATCH')
      WRITE(6,'(''SXTOCA - CAMERON FILE FROM SHELX - VSN.12.1.98''/ 
     &''  R.O. Gould, The University of Edinburgh'')')
C  General read instruction - NAME is card type or atom name
    1 READ(4,2,END=50)NAME,DATA
    5 CONTINUE
    2 FORMAT(A4,A72)
      DO 3 I=1,NWDS
      IF(NAME.EQ.SHELWD(I)) GO TO 4
    3 CONTINUE
C  PROBABLY AN ATOM
      IF(L1*L2.EQ.0) THEN
      WRITE(6,15) NAME
   15 FORMAT(' ILLEGAL INSTRUCTION ',A4,' FOUND BEFORE CELL OR SYMM')
      STOP
      ENDIF
      IF(NAME(1:1).EQ.'Q') THEN
C  "Q-peak" from Fourier search
      READ(DATA,14) (A(I),I=1,5)
      EQ=' '
   14 FORMAT(4X,3F8.4,F10.5,F6.2)
      ELSE
C   Ordinary atom
C altered 3.12.97 and 12.1.98
      IF(DATA(42:42).EQ.'.') THEN
      READ(DATA,6) (A(I),I=1,6),EQ
    6 FORMAT(5X,3F10.5,2F12.5,F10.5,1X,A1)
      ELSE
      READ(DATA,66) (A(I),I=1,6),EQ
   66 FORMAT(5X,6F10.5,1X,A1)
      ENDIF
      ENDIF
      DO 8 I=1,12
    8 B(I)=0.0
      DO 9 I=1,3
    9 B(I+3)=A(I)
      N=0
C   Decode SHELX atom name into atom type and number
      SYM='  '
      SYM(1:1)= NAME(1:1)
      J=ICHAR(NAME(2:2))-ICHAR('A')+1
      IF(J.GE.1.AND.J.LE.26) THEN
      SYM(2:2)=NAME(2:2)
      ELSE
      IF(NAME(2:2).EQ.' ') GO TO 10
      N=ICHAR(NAME(2:2))-ICHAR('0')
      ENDIF
      IF(NAME(3:3).EQ.' ') GO TO 10
      N=10*N + ICHAR(NAME(3:3))-ICHAR('0')
      IF(NAME(4:4).EQ.' ') GO TO 10
      N=10*N + ICHAR(NAME(4:4))-ICHAR('0')
   10 B(1) = FLOAT(N)
      B(2) = A(4)
      IF(EQ.EQ.'=') THEN
C  Anisotropic atom
      READ(4,7)(A(I),I=7,10)
C altered 3.12.97
    7 FORMAT(5X,4F10.5)
      DO 11 I=5,10
   11 B(I+2)=A(I)
      ELSE
      B(3)=A(5)
      IF(B(3).LT.0.0) B(3)=0.05
      ENDIF
      NATS=NATS+1
C  Check for fixed values in SHELX file
      DO 12 I=2,12
      IF(B(I).GT.5.0) B(I)=B(I)-10.0
   12 CONTINUE
      WRITE(8,13) SYM,B
   13 FORMAT('ATOM ',A2,3X,6F11.6/'CONTINUE  ',6F11.6)
      GO TO 1
    4 CONTINUE
      IF(I.EQ.2) THEN
C     CELL INSTRUCTION
      L1=1
C   Crystals LIST 1 written
      READ(DATA,*) X,C
      WRITE(7,30) C
   30 FORMAT('#LIST      1'/'REAL',3F8.4,3F8.3/'END')
      GO TO 1
      ENDIF
      IF(I.NE.4) GO TO 61
C     LATT INSTRUCTION
      READ(DATA,*) ICENT
      IF (ICENT.LT.0) CENT='  NO'
      LATT=LATY(IABS(ICENT))
   31 READ(4,2) NAME,DATA
   32 CONTINUE
C  SYMM instruction after LATT
      IF(NAME.NE.'SYMM') GO TO 33
      NSYM=NSYM+1
      SYMM(NSYM)=DATA
      GO TO 31
   33 IF(L1.EQ.0) THEN
      WRITE(6,'(''NO CELL INSTRUCTION - STOP'')')
      STOP
      ENDIF
      L2=1
C   Crystals LIST 2 written
      WRITE(7,34) NSYM,LATT,CENT,(SYMM(I),I=1,NSYM)
   34 FORMAT('#LIST     2'/'CELL   NSYM=',I2,', LATTICE=',A2,  
     &', CENTRIC=',A4,/('SYM ',A72))
      WRITE(7,'(''END'')')
      GO TO 5
   61 IF(I.NE.5) GO TO 62
C   SYMM INSTRUCTION WITH NO LATT  -  lattice P and centric
      GO TO 32
C   SFAC instruction with no SYMM or LATT  -   spgr P-1
   62 IF(I.EQ.6.AND.L2.EQ.0) GO TO 33
      GO TO 1
C  Arrive here at end of data on SHELX file
   50 WRITE(7,51)NATS,0.25,0.05,0.05,1.0,0.0,0.0
   51 FORMAT('#LIST     5'/'READ NATOM =',I7,', NLAYER =     0,', 
     &'NELEMENT =     0, NBATCH =     0'/'OVERALL   ',6F11.6)
C  Copy atoms form scratch file to permanent file
      REWIND 8
      DO 52 I=1,2*NATS
      READ(8,2)NAME,DATA
   52 WRITE(7,2)NAME,DATA
      WRITE(7,'(''END''/''#CAMERON''/''END'')')
      STOP
      END
C
C      SUBROUTINE SXNM(CCODE,LN)
C
C Get generic filename (CCODE) and its length (LN) from the command
C line.  UNIX SPECIFIC ROUTINE.
C
C      CHARACTER*1 KS
C      CHARACTER*6 CCODE
C      CHARACTER*80 NM
C   1  FORMAT(/'   ** BAD COMMAND LINE **'/)
C
C      LN=0
C      NM=' '
C      CALL GETARG(IARGC(),NM)
C        DO 2 I=1,80
C        KS=NM(I:I)
C        NM(I:I)=' '
C        IF(KS.EQ.' ')GOTO 2
C        IF(KS.GE.'A'.AND.KS.LE.'Z')KS=CHAR(ICHAR(KS)+32)
C        LN=LN+1
C        CCODE(LN:LN) = KS
C   2    CONTINUE
C      IF(LN.GT.0)GOTO 3
C      WRITE(*,1)
C      STOP
C    3 RETURN
C      END
