C $Log: not supported by cvs2svn $
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
c General program for reading diffractometer cif files
#include "ciftbx.cmn"
#include "cifin.cmn"
      CHARACTER*12 CDIFF, CTEMP
      character *132 carg1, carg2
      DATA NOUTF/10/,NHKL/11/,NCIF/12/, NTEXT/13/

#if defined(_GNUF77_)
      call no_stdout_buffer_()
#endif
c
C----- GET DATE
      I=IGDAT(CDATE)
C 
C....... Call the CIFTBX code to INITialise read/WRITE units
      F1=INIT_(1,2,3,6)
c
c
      write(6,'(/a)')' Unified Version Feb 2011'
      write(NTEXT,'(/a)')' Unified Version Feb 2011'
      write(6,'(a)')' Long input line version, May 2011'
      write(NTEXT,'(a)')' Long input line version, May 2011'
c
      write(6,'(a/)')' Get file and instrument from command line'
      write(NTEXT,'(a/)')' Get file and instrument from command line'
      call inarg(carg1, carg2)
      write(6,'(a)') carg1
      write(NTEXT,'(a)') carg1
      write(6,'(a)') carg2
      write(NTEXT,'(a)') carg2

      if ( nctrim(carg1) .eq. 0 ) then
         write(6,'(a/)')' Usage: diffin <file> <instrument code letter>'
         write(6,'(a/)')' A(gilent), N(onius), R(igaku), W(inGX)'
        stop
      end if

1      CONTINUE
c       write(6,*) 'Choose from A(gilent), N(onius), R(igaku), W(inGX)'
c       READ(5,'(A)') CTEMP
       ctemp = carg2(1:12)
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
       ELSE
          GOTO 1
       ENDIF
       LDIFF = NCTRIM(CDIFF)

C set default output filename - generalised to ease input
	filename= 'from-cif'
        lfn=8

c
        creduct = '?'
        cinst = '?'
        chkl = 'from-cif.hkl'
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
C....... Open our files for writing
      OPEN (NOUTF,FILE=filename(1:lfn)//'.cry',STATUS='UNKNOWN')
      OPEN (NCIF,FILE=filename(1:lfn)//'.cif',STATUS='UNKNOWN')
      OPEN (NTEXT,FILE=filename(1:lfn)//'.txt',STATUS='UNKNOWN')
c
c     get the name of the input file
      name = carg1
c
105   continue
      WRITE(6,'(/2a/)') ' Read DATA from input Cif  ',NAME
      WRITE(NTEXT,'(/2a/)') ' Read DATA from input Cif  ',NAME
      write(6,'(a/a)') ' Loading the ciftbx database.',
     1 ' This may take a while if there are a lot of reflections'
      write(6,'(//)')
      IF (.NOT.(OPEN_(NAME))) THEN
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
         if (name .eq. ' ') NAME='XX.cif'
         GO TO 105
      END IF
c
C 
	call datain
	end

C=======================================================================
#include "datain.for"
C=======================================================================
