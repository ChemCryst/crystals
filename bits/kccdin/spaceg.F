      PROGRAM SPACEG
      LOGICAL FC,FV,FN,FF,FT,FW,FSG,FL6
      character *132 filename
      CHARACTER*256 PROGNM,INFIL,OUTFIL,OPTION
      DATA NINF    /10/
      DATA NOUTF   /11/
      DATA INFIL /' '/
      DATA OUTFIL /' '/

      i_value=0

      I =  IO(NINF,NOUTF,INFIL, OUTFIL)
      IF (I .LE. 0) STOP 'ERROR IN io UNITS'

300   CONTINUE
C----- reflections all read - check space group with Nonius code
      write(6,'(a)') 'Space Group Code provided by Enraf-Nonius'

      CALL SGROUP(filename, i-value)

      WRITE (6,'(A,a,a)') 'Input space group symbol',
     1' with spaces between the components',
     2 ' e.g. P n a 21'
      write(6,'(a)') 'For monoclinic systems, input the full symbol'
      READ (5,'(a)') CSPACE
 
C -SG
C 
      IF (FSG) THEN
         WRITE (NOUTF,'(a)') '#SPACEGROUP'
         WRITE (NOUTF,'(2a)') 'SYMBOL ',CSPACE
         WRITE (NOUTF,'(a)') 'END'
      END IF

      IF (FL6) THEN
         WRITE (NOUTF,'(a)') '#OPEN HKLI kccd.hkl'
         WRITE (NOUTF,'(a)') '#LIST 6'
         WRITE (NOUTF,'(a)') 'READ F''S=FSQ UNIT=HKLI'
         WRITE (NOUTF,'(a)') 'END'
      END IF
         WRITE (NOUTF,'(a)') '#syst'
         WRITE (NOUTF,'(a)') 'END'
         WRITE (NOUTF,'(a)') '#sort'
         WRITE (NOUTF,'(a)') 'END'
c
1050  CONTINUE
      STOP
      END
C=======================================================================
      INTEGER FUNCTION IGDAT(CFILE)
C      GET AN 8 BYTE CHARACTER REPRESENTATION OF DATE/TIME
      CHARACTER*(*) CFILE
      INTEGER IIDATE(8)
      CHARACTER (LEN=12)CLOCK(3)
      CALL DATE_AND_TIME (CLOCK(1),CLOCK(2),CLOCK(3),IIDATE)
      I=IIDATE(6)+100*IIDATE(5)+10000*IIDATE(3)+1000000*IIDATE(2)
      WRITE (CFILE,'(I8)') I
      IGDAT=I
      RETURN
      END
C=======================================================================
#include "xgroup.for"
#include "charact.for"
#include "ciftbx.for"
C=======================================================================

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
c      SUBROUTINE XCREMS( CSOURC, COUT, LENFIL)
C
C----- REMOVE EXTRA SPACES BY LEFT ADJUSTING STRING
C----- ROUTINE EXITS WHEN OUT STRING FULL
C      LENFIL      USEFUL LENGTH OF RETURNED STRING
C
c      CHARACTER *(*) CSOURC, COUT
c      CHARACTER *1 CBUF
C
c      LINEL = LEN (CSOURC)
c      LOUT = LEN (COUT)
c      J = 0
c      IFLAG = 0
c      DO 1500 I = 1, LINEL
c      CBUF = CSOURC(I:I)
c      IF (CBUF .EQ. ' ') THEN
c            IF (IFLAG .EQ. 1) THEN
c                  GOTO 1500
c            ELSE
c                  IFLAG = 1
c            ENDIF
c      ELSE
c            IFLAG = 0
c      ENDIF
c      IF (J .LT. LOUT) THEN
c            J = J + 1
c            COUT(J:J) = CBUF
c      ELSE
c            GOTO 1600
c      ENDIF
c1500  CONTINUE
c1600  CONTINUE
c      LENFIL = J
c      IF (LENFIL .LT. LOUT) COUT(LENFIL+1:LOUT) = ' '
cC
c      RETURN
c      END
C
