	program kccdin
#include "ciftbx.cmn"
#include "cifin.cmn"

      DATA NOUTF/10/,NHKL/11/,NCIF/12/
#if defined(_GIL_) || defined (_MAC_) || defined (_LIN_) || defined (_WXS_)
      call no_stdout_buffer()
#endif
C set default output filename - also used as instrument ID
	filename='kccd'
        lfn = 4 
C----- GET DATE

      I=IGDAT(CDATE)
c
      cinst = 'Kappaccd'
      creduct = 'Denzo'
      chkl = 'kccd.hkl'
C 
C....... Open our files for writing
      OPEN (NOUTF,FILE='kccd.ins',STATUS='UNKNOWN')
      OPEN (NCIF,FILE='kccd.cif',STATUS='UNKNOWN')
C 
C....... Call the CIFTBX code to INITialise read/WRITE units
      F1=INIT_(1,2,3,6)
      write(6,'(/a/)')' Version Feb 2011'
C 
C....... Open the cif file for input
      NAME='import.cif'
105   continue
      WRITE (6,'(/2a/)') ' Read DATA from Cif  ',NAME
      IF (.NOT.(OPEN_(NAME))) THEN
         WRITE (6,'(A,A///)') Name, ' does not exist'
         write(6,'(a)') 'Filename for Kccd cif file?'
         read(5,'(a)') name
         if (name .eq. ' ') NAME='import.cif'
         GO TO 105
      END IF
C 
	call datain
	stop
	end

C=======================================================================
#include "datain.for"
C=======================================================================
C- LIST 6
c      GOTO 1050
c      IF (FL6) THEN
c         WRITE (NOUTF,'(a)') '#OPEN HKLI kccd.hkl'
c         WRITE (NOUTF,'(a)') '#LIST 6'
c         WRITE (NOUTF,'(a)') 'READ F''S=FSQ UNIT=HKLI'
c         WRITE (NOUTF,'(a)') 'END'
c      END IF
c         WRITE (NOUTF,'(a)') '#syst'
c         WRITE (NOUTF,'(a)') 'END'
c         WRITE (NOUTF,'(a)') '#sort'
c         WRITE (NOUTF,'(a)') 'END'
clist 30

c         WRITE (NOUTF,'(a)') 'DATRED REDUCTION=CrysAlis'
c         WRITE (NOUTF,'(a)') 'ABSORPTION ABSTYPE=multi-scan'
c         WRITE (NOUTF,'(a,f8.3)') 'cont empmin=',atn
c         WRITE (NOUTF,'(a,f8.3)') 'cont empmax=',atxc

c         WRITE (NOUTF,'(a)') '#OPEN HKLI od-out.hkl'



