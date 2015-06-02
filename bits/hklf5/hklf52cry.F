CODE FOR HKLF52CRY
      PROGRAM HKL52CRY
C----- BASED UPON SIMON PARSONS ctwin.t90
C      IO BASED UPON rICHARD cOOPERS cif2cry.fpp
c
      DIMENSION INDEX(3), VALUE(2)
      CHARACTER*256 PROGNM,INFIL,OUTFIL,OPTION
      DATA NINF    /10/
      DATA NOUTF   /11/
      DATA INFIL /' '/
      DATA OUTFIL /' '/

      I =  IO(NINF,NOUTF,INFIL, OUTFIL)
      IF (I .LE. 0) STOP 'ERROR IN io UNITS'

      WRITE(11,"('\LIST 6')")
      WRITE(11,"('READ NCOEFF=6 TYPE=FIXED F''S=FSQ', 
     1 ' UNIT=DATAFILE CHECK=NO')")
      WRITE(11,"('FORMAT (3F4.0,2F16.4,F9.0)')")
      WRITE(11,"('STORE NCOEFF=11')")
      WRITE(11,"('OUTPUT INDICES /FO/ SQRT /FC/ PHASE BATCH RATIO ',
     1 'SIGMA CORRECT /FOT/ ELEMENTS')")
      WRITE(11,"('INPUT H K L /FOT/ SIGMA(/FO/) ELEMENTS')")
      WRITE(11,"('END')")
C
      JELEM = 0
100   CONTINUE
      READ(10,'(3I4,2F8.2,I4)',ERR=9000,END=9000) INDEX,VALUE,KEY
      IF (KEY .LT.0) THEN
            DO 
                   JELEM = KKEY(KEY,JELEM)
                  READ(10,'(3I4,2F8.2,I4)',ERR=9000,END=9000) 
     1            INDEX,VALUE,KEY
                  IF (KEY .GT. 0) THEN
                      JELEM = KKEY(KEY,JELEM)
                     WRITE(11,'(3I4,2F16.4,I9)') 
     1               INDEX,VALUE,JELEM
                     JELEM = 0
                     GOTO 800
                   ENDIF
            ENDDO
800         CONTINUE
      ELSE
            JELEM = ABS(KEY)
            WRITE(11,'(3I4,2F16.4,I9)') 
     1      INDEX,VALUE,JELEM
            JELEM = 0
      ENDIF
      GOTO 100
9000  CONTINUE
      WRITE(11,"('-512')")
      STOP 'FINISHED'
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

      call no_stdout_buffer()

cdjw open a file for errors since DOS window closes too fast
c    lots of writes to 17 later
      open(17,file='HKL5.lis',status='unknown')

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
     1 ' [-f|a] [[-n blockname]Ý[-o outputfile]] [inputfile]'

      write(17,'(/3a/)')  'Usage: ',prognm(1:LEN_TRIM(prognm)),
     1 ' [-f|a] [[-n blockname]Ý[-o outputfile]] [inputfile]'


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
