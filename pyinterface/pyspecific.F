CODE   FOR GETCOM
      SUBROUTINE GETCOM(CLINE)

      interface
!> interface to C function getCommand (iso_c_bindings)
        integer function getcommand (caline) bind(c)
          use, intrinsic :: ISO_C_BINDING
          implicit none
          character caline
        end function getcommand
      end interface

      INTEGER ISTAT
      CHARACTER*256 CALINE
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
      CHARACTER *(*) CLINE

      CALINE=' '
      ISTAT = 0
      ISTAT = getcommand(caline)

      READ(CALINE,'(A)') CLINE

      END SUBROUTINE

      
CODE FOR GUEXIT
      SUBROUTINE GUEXIT(IVAR)
      interface
!> interface to C function exitpythread (iso_c_bindings)
        subroutine exitpythread (icode) bind(c)
          use, intrinsic :: ISO_C_BINDING
          implicit none
          integer icode
        end subroutine exitpythread
      end interface
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
C----- DON'T CLOSE ALL THE FILES
c      DO 2001 I = 1,NFLUSD
c            J = KFLCLS(IFLUNI(I))
c2001  CONTINUE
      CALL exitpythread(IVAR)
      RETURN
      END

      SUBROUTINE GETVAR(CKEY, CVAL)
      interface
!> interface to C function getCommand (iso_c_bindings)
        integer function getcrysdir (crd) bind(c)
          use, intrinsic :: ISO_C_BINDING
          implicit none
          character crd
        end function getcrysdir
      end interface

      CHARACTER*(*) CKEY, CVAL
      integer i

      i = -1
      
      if (ckey .eq. 'CRYSDIR') then
          i = getcrysdir(cval)
      endif
      
      if ( i .ne. 0 ) then
         call GET_ENVIRONMENT_VARIABLE(CKEY,CVAL)
      endif 
      end      