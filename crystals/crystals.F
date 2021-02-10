C $Log: not supported by cvs2svn $
C Revision 1.16  2011/03/22 14:40:38  rich
C Added extra file unit 'SCP2' which may be read by new script command EXTRACT2
C
C Revision 1.15  2005/02/08 14:46:14  stefan
C 1. Added some precompiler if's for the mac version
C
C Revision 1.14  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:07  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.13  2003/05/07 12:18:53  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.12  2002/07/22 10:47:32  richard
C Save and restore IERFLG around XGUIUP call, otherwise the error contingency
C in SCRIPTS is never activated.
C
C Revision 1.11  2002/03/13 12:33:28  richard
C Call XGUIUP in between EVERY instruction.
C
C Revision 1.10  2001/10/08 12:25:58  ckp2
C
C All program sub-units now RETURN to the main CRYSTL() function inbetween commands.
C The changes made are: in every sub-program the GOTO's that used to loop back for
C the next KNXTOP command have been changed to RETURN's. In the main program KNXTOP is now
C called at the top of the loop, but first the current ProgramName (KPRGNM) array is cleared
C to ensure the KNXTOP knows that it is not in the correct sub-program already. (This
C is the way KNXTOP worked on the very first call within CRYSTALS).
C
C We now have one location (CRYSTL()) where the program flow returns between every command. I will
C put this to good use soon.
C
C Revision 1.9  2001/02/26 10:24:14  richard
C Added changelog to top of file
C
C
#if defined(CRY_NOGUI)
      PROGRAM CRYSTAL
#ifndef _NOHDF5_
      use hdf5_dsc
#endif
      INTERFACE
       SUBROUTINE CRYSTL() BIND(C)
         USE, INTRINSIC :: ISO_C_BINDING
         IMPLICIT NONE
       END SUBROUTINE CRYSTL
      END INTERFACE

 
#ifndef _NOHDF5_
      character(len=256) :: args_value
      integer :: args_count, i, found

C Look for arguments from the command line
      args_count = command_argument_count()
      if(args_count>0) then
        ! Search for hdf5 switch
        do i=1, args_count
          call get_command_argument(i , args_value)
          found = index(args_value, '--hdf5')
          if(found>0) then
            hdf5_in_use = .true.
!            print *, 'Experimental use of hdf5 files'
          end if
        end do
      end if
#endif
      CALL CRYSTL()
      END
#endif


C Entry point for command line and library use.
#ifdef CRY_FORTDIGITAL
      SUBROUTINE CRYSTL()
      !dec$ attributes c :: crystl
#else
      SUBROUTINE CRYSTL() bind (c)
#endif
C
C
C     ******************************************************
C     * THIS IS THE MAIN PROGRAM FOR THE 'CRYSTALS' SYSTEM *
C     ******************************************************
C
C BY DEFAULT, TERMINAL INPUT IS FROM UNIT 5 - NCUFU(1)
C             TERMINAL OUTPUT IS TO UNIT  6 - NCAWU
C             AND THE STARTUP FILE IS OPENED ON UNIT 20 - NCRU
C
C             THE NAME OF THE STARTUP FILE MAY EITHER BE SET AS
C             DATA IN PRESETS, OR IN AN ASSIGNMENT BELOW.
C
      INCLUDE 'ISTORE.INC'
C--
C
      INCLUDE 'STORE.INC'
      INCLUDE 'TSSCHR.INC'
      INCLUDE 'XDRIVE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XPRGNM.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XDISC.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'QSTORE.INC'

C
C
C -- DECLARE EXTERNAL REFERENCES TO BLOCK DATA SEGMENTS
C
      EXTERNAL CRYBLK, SYNBLK, UTIBLK, ZBLOCK
C
C -- DECLARE LIST 11 REFERENCES TO RESERVE EXTENSIBLE COMMON
C
      EXTERNAL XFAL11,KADD11,XIN11
#ifdef _DOS_
      EXTERNAL MYDRIV
C
C
#endif

      INPYTH = 0    !Not currently in a python script, if entering via this subroutine.
      CALL CRESET   !These routines reinitialise SOME of the COMMON block variables, but
      CALL CAMSET   !they also ensure those object files (presets and block) are linked.
C
C----- INITIALISE THE CARRIAGE CONTROL VARIABLES
      CALL FBCINI
#ifdef _DOS_
      call suppress_argument_type_checks@
#endif
C
C -- ASSIGN AND OPEN STARTUP CONTROL FILE - CSSCST AND LSSCST
C    ARE SET IN BLOCK DATA IN PRESETS. THE LOGICAL NAME MAT BE
C    EXPANDED
      CALL MTRNLG ( CSSCST, 'OLD', LSSCST)
C----- ALTERNATIVELY, THAY CAN BE SET HERE
C      CSSCST = '\CRYSTALS\SRT\CRYSTALS.SRT'
C      LSSCST =  26
C
#ifdef _DOS_
C----- HOOK IN THE SALFORD DOS DRIVER TO COUNT LINES
CWIN_32&DOS      OPEN ( NCVDU, STATUS = 'UNKNOWN', DRIVER = MYDRIV)
C
#endif
      IF ( ISSSFI .GT. 0 ) THEN
        ISTAT = KFLOPN ( NCRU ,CSSCST(1:LSSCST),ISSOLD,ISSREA,1,ISSSEQ)
        IF ( ISTAT .LE. 0 ) THEN
         if (issmon.ne.1) CALL SETISSMON(0) ! Turn monitoring back on
            WRITE(6,*) 'UNIT =', NCRU, 'FILE =', CSSCST
            CALL XERIOM ( NCRU, ISTAT)
C            STOP 'ERROR OPENING STARTUP FILE'
            CALL GUEXIT (2003)
        ENDIF
      ENDIF
C
1210  CONTINUE
	  CALL COMPROC()
	  GOTO 1210
	  END
	  
	  
	  
C This can be called by PYTHON process after it has setup a queue of commands to be processed.

#ifdef CRY_FORTDIGITAL
      SUBROUTINE cryproc()
      !dec$ attributes c :: cryproc
#else
      SUBROUTINE cryproc() bind (c)
#endif
	  CALL COMPROC()
	  END
	  
C If you're here looking for the main program branching (calls to KNXTOP) they've been moved to the end of control.F
	  

CODE FOR GETCOM
      SUBROUTINE GETCOM(CLINE)
#ifdef CRY_GUI
      use fwrappergui_mod, only: cinextcommand, getcommand
      INTEGER ISTAT
      CHARACTER*256 CALINE
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      CHARACTER *(*) CLINE

C Check if we have been called by python script.
      IF ( INPYTH .GT. 0 ) THEN 
	    INPYTH = 0
        call  getcommand( len(caline), caline )
        READ(CALINE,'(A)') CLINE
	    INPYTH = 1   ! If we didn't longjmp out of getcommand, then we're here and still in a python script.
      ELSE
		
        CALINE=' '
        ISTAT = 0
        CALL cinextcommand(ISTAT,CALINE)
        READ(CALINE,'(A)') CLINE
	
      END IF

      IF ( LCLOSE ) THEN
          WRITE(CMON,'(A)') '^^WI SET PROGOUTPUT TEXT = '
          CALL XPRVDU (NCVDU,1,0)
          WRITE(CMON,'(A)') '^^WI ''Working. Please Wait.'''
          CALL XPRVDU (NCVDU,1,0)
          WRITE(CMON,'(A)')  '^^CR '
          CALL XPRVDU (NCVDU,1,0)
      ENDIF

#else
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      CHARACTER *(*) CLINE

      IF ( INPYTH .GT. 0 ) THEN 
	    INPYTH = 0
        call getcommand( len(caline), caline )
        READ(CALINE,'(A)') CLINE
	    INPYTH = 1   ! If we didn't longjmp out of getcommand, then we're here and still in a python script.
      ELSE
        READ( NCUFU(1), '(A)') CLINE
	  END IF

#endif
      END SUBROUTINE

CODE FOR GUEXIT
      SUBROUTINE GUEXIT(IVAR)
#ifdef CRY_GUI
      use fwrappergui_mod, only: ciendthread
#endif
      INTEGER IVAR
      INCLUDE 'UFILE.INC'
C Meanings of IVAR.
C 0    Ok
C 1    Error
C 2    Serious error
C 3-1999 unspecified.
C 2001 Zero length vector
C 2002 SPECLIB - XDEPAC
C 2003 ERROR OPENING STARTUP FILE
C 2004 CRYSTALS START ERROR
C 2005 CANNOT CREATE FILE
C 2006 WRITE ERROR
C 2007 XFETCH
C 2008 XSTORE
C 2009 INPUT
C 2010 LABEL NOT IMPLEMENTED
C 2011 XFINDE
C 2012 XLDCBL
C 2013 XFCFI
C 2014 XDSMSG
C 2015 XLINES
c 2016 KCHNCB
c 2017 XINERT
c 2018 PO1AAF (NAG)
c 2019 LIST 6 ERROR
c 2020 ERROR HANDLING
c 2021 SPYERROR
c 2022 KEQUAT
c 2023 KFORM
c 2024 KFUNCT
c 2025 XABS
c 2026 XCONOP ERROR
c 2027 ROUTINE NOT IMPLEMENTED
cdjwapr99 moved from out of XFINAL to prevent error messages in FTN77 
c version
C----- CLOSE ALL THE FILES
      DO 2001 I = 1,NFLUSD
            J = KFLCLS(IFLUNI(I))
2001  CONTINUE
#ifdef CRY_NOGUI
      CALL EXIT(IVAR)
      RETURN
#else
      CALL CIENDTHREAD(IVAR)
      RETURN
#endif
      END
      
      SUBROUTINE GETVAR(CKEY, CVAL)
      CHARACTER*(*) CKEY, CVAL
      call GET_ENVIRONMENT_VARIABLE(CKEY,CVAL)
      end            
