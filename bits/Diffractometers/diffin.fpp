	program diffin
c General program for reading diffractometer cif files
#include "ciftbx.cmn"
#include "cifin.cmn"
      CHARACTER*12 CDIFF, CTEMP

      DATA NOUTF/10/,NHKL/11/,NCIF/12/

#if defined(_GIL_) || defined (_MAC_) || defined (_LIN_) || defined (_WXS_)
      call no_stdout_buffer()
#endif
c
C----- GET DATE
      I=IGDAT(CDATE)
C 
C....... Call the CIFTBX code to INITialise read/WRITE units
      F1=INIT_(1,2,3,6)
c
c
      write(6,'(/a/)')' Unified Version Feb 2011'
c
1      CONTINUE
       write(6,*) 'Choose from Agilent, Nonius, Rigaku, WinGX'
       READ(5,'(A)') CTEMP
       CALL XCCUPC(CTEMP,CDIFF)
       IF(CDIFF(1:4) .EQ. 'AGIL') THEN
          CDIFF='agilent'
          idiff = 1
       ELSE IF(CDIFF(1:4) .EQ. 'NONI') THEN
          CDIFF='kccd'
          idiff = 2
       ELSE IF(CDIFF(1:4) .EQ. 'RIGA') THEN
          CDIFF='rigaku'
          idiff = 3
       ELSE IF(CDIFF(1:4) .EQ. 'WING') THEN
          CDIFF='wingx'
          idiff = 4
       ELSE
          GOTO 1
       ENDIF
       CALL XCTRIM(CDIFF,LDIFF)
C--    REMOVE FINAL SPACE
       LDIFF = LDIFF-1
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
      OPEN (NOUTF,FILE=filename(1:lfn)//'.ins',STATUS='UNKNOWN')
      OPEN (NCIF,FILE=filename(1:lfn)//'.cif',STATUS='UNKNOWN')
c
C 
C....... Open the cif file for input
      if (idiff .eq. 2) then
          name='import.cif'
      else
          name = 'XX.cif'
      endif
c
105   continue
      WRITE (6,'(/2a/)') ' Read DATA from Cif  ',NAME
      IF (.NOT.(OPEN_(NAME))) THEN
         WRITE (6,'(A,A,A///)') 'File ', Name, ' does not exist'
         write(6,'(a)') 'Name of input cif file?'
         read(5,'(a)') name
         if (name(1:4) .eq. 'quit') then
            write(6,*)'Quitting now'
            stop
         endif
         if (name .eq. ' ') NAME='XX.cif'
         GO TO 105
      END IF

C 
	call datain
	stop
	end

C=======================================================================
#include "datain.for"
C=======================================================================
