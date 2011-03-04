      PROGRAM READOD
c restored v 14 from cvs
#include "ciftbx.cmn"
#include "cifin.cmn"

      DATA NOUTF/10/,NHKL/11/,NCIF/12/

#if defined(_GNUF77_)
      call no_stdout_buffer()
#endif
C set default output filename - also used as instrument ID
	filename='od-out'
        lfn=6 
C----- GET DATE

      I=IGDAT(CDATE)
c
        creduct = 'CrySalis'
        cinst = 'SuperNova'
        chkl = 'od-out.hkl'
C 
C....... Open our files for writing
      OPEN (NOUTF,FILE='od-out.ins',STATUS='UNKNOWN')
c      OPEN (NHKL,FILE=filename(1:lfn)//'.hkl', STATUS='UNKNOWN')
      OPEN (NCIF,FILE='od-out.cif',STATUS='UNKNOWN')
C 
C....... Call the CIFTBX code to INITialise read/WRITE units
      F1=INIT_(1,2,3,6)

      write(6,'(/a/)')' Version Feb 2011'
C 
C....... Open the cif file for input
      NAME='od-import.cif'
105   continue
      WRITE (6,'(/2a/)') ' Read DATA from Cif  ',NAME
      IF (.NOT.(OPEN_(NAME))) THEN
         WRITE (6,'(A,A///)') Name, ' does not exist'
         write(6,'(a)') 'Filename for Agilent cif file?'
         read(5,'(a)') name
         if (name .eq. ' ') NAME='od-import.cif'
         GO TO 105
      END IF

C 
	call datain
	stop
	end

C=======================================================================
#include "datain.for"
C=======================================================================
clist 30

c         WRITE (NOUTF,'(a)') 'DATRED REDUCTION=CrysAlis'
c         WRITE (NOUTF,'(a)') 'ABSORPTION ABSTYPE=multi-scan'
c         WRITE (NOUTF,'(a,f8.3)') 'cont empmin=',atn
c         WRITE (NOUTF,'(a,f8.3)') 'cont empmax=',atxc

c         WRITE (NOUTF,'(a)') '#OPEN HKLI od-out.hkl'



