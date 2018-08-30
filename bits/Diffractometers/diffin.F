C $Log: not supported by cvs2svn $
C Revision 1.12  2012/10/18 12:04:11  djw
C Code from cif2cry merged with difin/datain.  Hundreds of changes.  cif2cry may become obsolete once debugged
C
C Revision 1.11  2012/07/12 08:56:10  rich
C Move loop start to avoid resetting user input.
C
C Revision 1.10  2012/03/23 15:50:26  rich
C Avoid infinite loop if no option specified on command line.
C
C Revision 1.9  2012/01/05 16:10:24  djw
C Add a new I/O chanel with info about missing data
C Try to select most probable SG which does not involve a permutation of axes.
C The full details are still sent to SPACE.OUT
C
C Revision 1.8  2012/01/03 14:24:18  rich
C Allow longer filenames and filenames with spaces in.
C
C Revision 1.7  2011/09/22 19:49:34  rich
C Some fixes to make this compile with gfortran and align a common block.
C
C Revision 1.6  2011/06/13 13:32:59  djw
C remove old comments, set output file extension t .cry, add captions to table, ensure most probable SG is found,
C
C Revision 1.5  2011/06/08 11:19:40  djw
C Reorganise code to remove excessive output, remove most interactive questions (some remain), set up input filename and instrument type in popup browse window.
C
C Revision 1.4  2011/05/17 16:00:16  djw
C Enable long lines, up to 512 characters
C

      program diffin
      implicit none
c---------------------------------------------------------------------
c General program for reading all cif files
c
c Reflections and fcf files:
c Reflections embeded in a normal .cif file are output to a .hkl file
c and the .cry file contains all the lists found .
c Reflections in an .fcf file are output to a .hkl file, together with
c a dummy .cry file to process the hkl file.
c---------------------------------------------------------------------
c
c USAGE:
c programname
c -f/a  First/all blocks
C
c       -n    block-file extension (with .) 
c or
c       -o    output file name
C
c -d    Diffractometer name
c -b    batch, do not ask questions during processing
c       input filename
c

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
#include "ciftbx.cmn"
#include "cifin.cmn"
c
      character*4096 file_root
      character*4096 prognm,outfil,device,extbl
      logical lfirst,namebl,allbl,linfl,loutfl
      character*4096  cspace, output_name
      character*4096  output_hkl
      character*32  response
      character*256 option
      CHARACTER*12  cdiff, ctemp
      character*132 carg2
      
      integer i, ldiff, lfr, n, narg, ndata, nglob
      logical namdev, interactive
      
      integer, external :: igdat, nctrim
c
      data noutf    /10/
      data nhkl     /11/
      data ncif     /12/
      data ntext    /13/
      data noutr    /14/
      data nglob    /15/

      call no_stdout_buffer()
      
c
C----- GET DATE
      I=IGDAT(CDATE)
c
cdjw open a file for errors since DOS window closes too fast
c    lots of writes to ntext later
      open(ntext,file='cif2cry.log',status='unknown')
      write(6,'(/a)')' Unified Version Feb 2011'
      write(NTEXT,'(/a)')' Unified Version Feb 2011'
      write(6,'(a)')' Long input line version, May 2011'
      write(NTEXT,'(a)')' Long input line version, May 2011'
c
c open a file for all the bits and pieces
      open (ncif,file='from-cif.cif', status ='unknown')
C
c-----------------------------------------------------------------
C Read data from the commandline:
      call inarg(0,prognm)
c     Make CCDC files the default
      lfirst = .FALSE.
      namebl = .FALSE.
      allbl  = .FALSE.
      linfl  = .FALSE.
      loutfl = .FALSE.
      namdev = .TRUE.
      prognm = 'null'
      infil  = 'null'
      outfil = 'null'
      option = 'null'
      device = 'CSD'
      extbl  = '.cry'
      interactive=.true.
      
c
      N = 1
#if defined(CRY_FORTDIGITAL)
      NARG = IARGC() + 1
#else
      NARG = COMMAND_ARGUMENT_COUNT() + 1
#endif
6     format(a,3x,i3,3x,a)
      write(6,'(a,i6)') 'Narg', narg
      write(NTEXT,'(a,i6)') 'Narg', narg
      call inarg(0,option)
      write(6,6)'Option',0,  option
      write(ntext,6)'Option',0,  option
      prognm = option(1:LEN_TRIM(option))
c
      DO WHILE ( N .LT. NARG )
        call inarg(n,option)
        write(6,6)'Option',n,  option
        write(ntext,6)'Option',n,  option
        IF (option.eq.'-f') THEN                  !first
                IF ( allbl ) GOTO 8000
                lfirst = .TRUE.
        ELSE IF (option.eq.'-b') THEN             !batch (non-interactive)
                IF ( lfirst ) GOTO 8000
                interactive=.false.
        ELSE IF (option.eq.'-a') THEN             !all
                IF ( lfirst ) GOTO 8000
                allbl = .TRUE.
        ELSE IF (option .eq. '-d') THEN           !device
                N = N + 1
                IF ( N .GE. NARG ) GOTO 8000
                namdev=.TRUE.
                call inarg(N,device)
                write(6,6)'Device',n, device
                write(ntext,6)'Device',n, device
                IF (device(1:1).eq.'-') GOTO 8000
        ELSE IF (option.eq.'-n') THEN             !block n
                if ( loutfl ) GOTO 8000
                N = N + 1
                IF ( N .GE. NARG ) GOTO 8000
                namebl=.TRUE.
                call inarg(n,extbl)
                write(6,6)'Block extention',n,  extbl
                write(ntext,6)'Block extention',n,  extbl
                IF (outfil(1:1).eq.'-') GOTO 8000
        ELSE IF (option.eq.'-o') THEN              !output
                if ( namebl ) GOTO 8000
                N = N + 1
                IF ( N .GE. NARG ) GOTO 8000
                loutfl=.TRUE.
                call inarg(n,outfil)
                write(6,6)'Outfil',n,  outfil
                write(ntext,6)'Outfil',n,  outfil
                IF (outfil(1:1).eq.'-') GOTO 8000
        ELSE IF (option(1:1).eq.'-') THEN
                GOTO 8000
        ELSE                                        !input
                IF (linfl) GOTO 8000
                IF ( N .GE. NARG ) goto 8000
                linfl=.TRUE.
                call inarg(n,infil)
                write(6,6)'Infil ',n,  infil
                write(ntext,6)'Infil ',n,  infil
        END IF
        N = N + 1
      END DO
c
c
c
c
      write(ntext,'(//a/(6x,a,a))') 'Units',
     1 'Program ', prognm(1:LEN_TRIM(prognm)),
     1 'Input ', infil(1:LEN_TRIM(infil)),
     1 'Output ',outfil(1:LEN_TRIM(outfil)),
     1 'Device ',device(1:LEN_TRIM(device)),
     1 'extbl ',extbl(1:LEN_TRIM(extbl))
c
      write(ntext,'(a/6x,5(a,l2,3x))')'Logicals',
     1 'lfirst',lfirst,
     2 'namebl',namebl,
     3 'allbl',allbl,
     4 'linfl',linfl,
     5 'loutfl',loutfl
c
c
c set device/source type flag
c
      carg2 = device(1:LEN_TRIM(device))
      ctemp = carg2(1:12)
1     CONTINUE
      CALL XCCUPC(CTEMP,CDIFF)
      idiff = 0
      IF(CDIFF(1:1) .EQ. 'A') THEN
          CDIFF='agilent'
          idiff = 1
      ELSE IF(CDIFF(1:1) .EQ. 'N') THEN
          CDIFF='kccd'
          idiff = 2
      ELSE IF(CDIFF(1:1) .EQ. 'R') THEN
          CDIFF='rigaku'
          idiff = 3
      ELSE IF(CDIFF(1:1) .EQ. 'W') THEN
          CDIFF='wingx'
          idiff = 4
      ELSE IF(CDIFF(1:1) .EQ. 'C') THEN
          CDIFF='csd'
          idiff = 5
      ELSE
        write(6,*) 
     1 'Choose from A(gilent), N(onius), R(igaku), W(inGX), C(sd)'
        READ(5,'(A)') CTEMP
        GOTO 1
       ENDIF
       LDIFF = NCTRIM(CDIFF)
C
C....... Call the CIFTBX code to INITialise read/WRITE units
      F1=INIT_(1, 2, 3, 6)
c
c get input file extension to use later in connection with list 6
      if (linfl) then
       i = index(infil(1:LEN_TRIM(infil)),'.')
       if(i.gt.0) ctemp = infil(i+1:)
       if (ctemp(1:3) .eq. 'fcf') then
            fcf = .true.
c      2018. SHELX has started calling fcf files hkl!! Rats!!
       else if (ctemp(1:3) .eq. 'hkl') then
            fcf = .true.
       else
            fcf = .false.
       endif
      endif
c
c     In interactive mode get an input file name 
      if ( .not. linfl ) then
C.......  Enter the name of Cif file
        write (6, '(1x,a)') 
     *      "Enter name of the Cif file (e.g. test.cif):  "
        write (ntext, '(1x,a)') 
     *      "Enter name of the Cif file (e.g. test.cif):  "
        read (*, '(a)') infil
      end if
C 
c
C      if(.not.(open_(infil)))then
C        write(6,'(a///)')  ' >>>>> CIF cannot be opened'
C        write(ntext,'(a///)')  ' >>>>> CIF cannot be opened'
C        goto 9999
C      endif
C
c     get the name of the input file
      NAME = infil(1:LEN_TRIM(infil))
105   continue
      WRITE(6,'(/2a/)') 'Read DATA from input Cif:  ',NAME
      WRITE(NTEXT,'(/2a/)') 'Read DATA from input Cif  ',NAME
      write(6,'(////)')
      write(6,'(a)') 
     1 '              Loading the ciftbx database.'
      write(6,'(a)')
     1 ' This may take a while if there are a lot of reflections'
      IF (.NOT.(OPEN_(NAME(1:LEN_TRIM(NAME))))) THEN
         WRITE (6,'(A,A,A///)') 'File ', Name, ' does not exist'
         WRITE (NTEXT,'(A,A,A///)') 'File ', Name, ' does not exist'
         write(6,'(a)') 'Name of input cif file?'
         write(NTEXT,'(a)') 'Name of input cif file?'
         read(5,'(a)') name
         if (name(1:4) .eq. 'quit') then
            write(6,*)'Quitting now'
            write(NTEXT,*)'Quitting now'
            stop
         endif
         GO TO 105
      END IF
C
C
C....... Assign the data block to be accessed
C - NOTE that data_ looks for the start of a new block

10    if(.not.(data_(' '))) then
        write(6,    '(/a/)')   ' >>>>> No data_ statement found'
        write(ntext,'(/a/)')   ' >>>>> No data_ statement found'
        goto 9999
      else
        block_name = bloc_
        if (bloc_ =="global" .or. bloc_ =="General") then ! General is produced by TEXSAN refinement packahe (rigaku)
        write(6,'(/a,a/)')   ' >>>>> data_global statement found -',
     1  ' now looking for block_'
        write(ntext,'(/a,a/)') ' >>>>> data_global statement found -',
     1  ' now looking for block_'
        open(nglob,file='cif_global.lis',status='unknown')
        write(nglob,'(/a,a/)') ' >>>>> data_global statement found -',
     1  ' now looking for block_'
          goto 10
        else
          write(6    ,'(/a,3x,a)') 'The first crystal data is',bloc_
          write(ntext,'(/a,3x,a)') 'The first crystal data is',bloc_
        endif 
      endif
        
      ndata = 1
      write(ntext,'(/a,i5,3x,a,a/)') 'Ndata =',ndata,'block = ', 
     1 block_name(1:len_trim(block_name))
      write(ncif,'(a,a)') 'data_',block_name
c
c
c     in interactive 'block' mode, get output filename 
120   continue
c
      if ( ( .not. loutfl ) .and. ( .not. namebl ) ) then
C.......  Enter the name of the output file
        write (6, '(/a)')
     *         " Enter name of the output file [from-cif.dat]: "
        write (ntext, '(/a)')
     *         " Enter name of the output file [from-cif.dat]: "
        read (*, '(a)' ) output_name
        if (output_name == ' ') then
          output_name="interactive-cif.dat"
        endif
        outfil = output_name
      end if
      output_name = outfil
      i = index(output_name,'.')
      if (i .le. 0) i=len_trim(output_name)+1
      lfr = i-1
      file_root = outfil(1:lfr)
      output_hkl  = outfil(1:lfr)//'.hkl'
c
c
C....... Open our file for output of CRYSTALS instructions:
      if ( namebl ) then
C       Name formed from blockname and extbl is used as extension:
        option = bloc_
        call noillegal(option)    !remove illegal characters
        output_name = option(1:LEN_TRIM(option))//extbl
        outfil = output_name
        output_hkl  = option(1:LEN_TRIM(option))//'.hkl'
        OPEN (NOUTF,FILE=output_name,STATUS='UNKNOWN')
        OPEN (NCIF,FILE=output_name(1:len_trim(output_name))//'.cif',
     1  STATUS='UNKNOWN')
      else if ( allbl ) then
C       All blocks into one file. Only open once:
        if ( ndata .eq. 1 ) then
          OPEN (NOUTF,FILE=outfil, STATUS='UNKNOWN')
c          OPEN (NCIF,FILE=file_root(1:lfr)//'.cif',
c     1    STATUS='UNKNOWN')
        end if
        output_hkl = file_root(1:lfr)
        output_hkl(lfr+1:lfr+9) ='00000.hkl'
        write(output_hkl(lfr+1:lfr+5),  '(i5.5)') ndata
        write(ntext,'(a,a)')'HKL-file= ', output_hkl
      else
C       Any other case, just open it:           
C       set default output filename - generalised to ease input
        lfn = len_trim(output_name)
        if(.not. loutfl) then 
            if (cdiff(1:1) .eq. 'c') then
             output_name= 'cif2cry.cry'
             lfn=11
            else
             output_name= 'from-cif.cry'
             lfn=12
            endif
         endif
         output_hkl = output_name(1:lfn-4)//'.hkl'
         OPEN (NOUTF,FILE=output_name(1:lfn),STATUS='UNKNOWN')
c         OPEN (NCIF,FILE=output_name(1:lfn-4)//'.cif',STATUS='UNKNOWN')
      end if

c open hkl in difin only if refelctions found
c
      write(6,'(''Output file: '',A)') output_name
      write(ntext,'(''Output file: '',A)') output_name
      call noillegal(block_name)
c
c
c-----------------------------------------------------------------
c
c
        creduct = 'Unknown'
        cinst = 'Unknown'
        chkl = output_hkl
        if (idiff .eq. 1) then
        creduct = 'CrySalis'
        cinst = 'SuperNova'
        else if (idiff .eq. 2) then
        creduct = 'Denzo'
        cinst = 'Kappaccd'
        else if (idiff .eq. 3) then
        creduct = 'Unknown'
        cinst = 'Unknown'
        else if (idiff .eq. 4) then
        creduct = 'Unknown'
        cinst = 'Unknown'
        end if

C 
c----------------------------------------------------------------
C 
      call datain(interactive)
c
c-- end.bit  --------------------------------------------------
c-- post-process CSD files
      if ((idiff .eq. 5) .and. (.not. namebl))
     1       write(NOUTF, '(a)') '#SCRIPT CIFPROC'

      write(6,'(/a, a/)') output_name, 
     *             'has been created.'
      write(ntext,'(/a, a/)') output_name, 
     *             'has been created.'
c
c
9900  write(6,'(a)') 'Check for more crystal data ... ...'
      write(ntext,'(a)') 'Check for more crystal data ... ...'
    
      if(.not.(data_(' '))) then
        write (6, '(a)') ' ---------------------------------' 
        write(6,'(a)')   ' *** No more structures found ***'
        write (6, '(a)') ' ---------------------------------' 
        write(6,'(/I4, 2x, a/, a)') ndata, 
     *        'structure(s) processed. Final message', 
     *          ' Program is finished.'  

        write (ntext, '(a)') ' ---------------------------------' 
        write(ntext,'(a)')   ' *** No more structures found ***'
        write (ntext, '(a)') ' ---------------------------------' 
        write(ntext,'(/I4, 2x, a/, a)') ndata, 
     *        'structure(s) processed. Final message', 
     *          ' Program is finished.'  

        goto 9999
      else 
        write (6, '(a)') ' -----------------------------------'
        write (6, '(2x,a,i5)') 'New structure found. Ndata =', ndata+1
        write (6, '(2x,a,a,a)') '(', bloc_, ')'
        write (6, '(a)') ' -----------------------------------' 
        write (ntext, '(a)') ' -----------------------------------'
        write (ntext,'(2x,a,i5)')'New structure found. Ndata =',ndata+1
        write (ntext, '(2x,a,a,a)') '(', bloc_, ')'
        write (ntext, '(a)') ' -----------------------------------' 
        block_name = bloc_
c
        if ( allbl ) then     !User has req. all blocks on cmd line.              
          ndata = ndata + 1
          goto 120
        end if
        if ( lfirst ) goto 9999  !User only wants first block.
c
          write (6, '(a)') ' Continue y/n? [y]'
          write (ntext, '(a)') ' Continue y/n? [y]'
          read (*, '(a)') response
          if (response == 'y' .or. response == 'Y' .or. 
     *                                    response == ' ') then
            ndata = ndata + 1
            goto 120
          else if (response == 'n'.or. response == 'N') then
            write (6, '(I4,2x,a)') ndata, 
     *          'structure(s) processed. Final message.' 
            write (ntext, '(I4,2x,a)') ndata, 
     *          'structure(s) processed. Final message.' 
            goto 9999
          endif                 
        endif
      goto 9999

c
c
8000  continue
8020  CONTINUE    !Usage error
      write(6,'(/3a/)')  'Usage: ',prognm(1:LEN_TRIM(prognm)),
     2 ' [-f|-a|-b] [-d device] [[-n blockextension]|[-o outputfile]]', 
     3 '[inputfile]'

      write(ntext,'(/3a/)')  'Usage: ',prognm(1:LEN_TRIM(prognm)),
     1 ' [-f|a|-b] [[-n blockextension]|[-o outputfile]] [inputfile]'
      goto 9999
c
9999  CONTINUE 
      if ( .not. linfl ) then   !Only print quit message in interactive mode.
        write (6,'(a)') 'Press ENTER to quit'
        read (*, '(a)') response
      end if
      STOP      
      end
c
      SUBROUTINE NOILLEGAL(OPTION)
        character*32 option
        DO N = 1,LEN_TRIM(option)    !Remove illegal chars
          IF ( option(N:N) .EQ. '\') option(N:N) = '_'
          IF ( option(N:N) .EQ. '/') option(N:N) = '_'
          IF ( option(N:N) .EQ. ':') option(N:N) = '_'
          IF ( option(N:N) .EQ. '*') option(N:N) = '_'
          IF ( option(N:N) .EQ. '?') option(N:N) = '_'
          IF ( option(N:N) .EQ. '>') option(N:N) = '_'
          IF ( option(N:N) .EQ. '<') option(N:N) = '_'
          IF ( option(N:N) .EQ. 'Ý') option(N:N) = '_'
          IF ( option(N:N) .EQ. '|') option(N:N) = '_'
        END DO
      RETURN
      END
C=======================================================================
#include "datain.for"
C=======================================================================
      SUBROUTINE INARG(N, CARG)
#if defined(CRY_FORTDIGITAL)
      USE DFPORT
#endif
      character*(*)  CARG
C--
      optlen=132
      carg = ' '
#if defined(CRY_FORTDIGITAL)
      CALL GetArg(N,carg,optlen)
#else
      call get_command_argument(n, carg)
#endif
      RETURN
      END
