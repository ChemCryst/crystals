C $Log: not supported by cvs2svn $
C Revision 1.12  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.11  2002/10/16 11:47:51  rich
C
C This is a good one: Added SORT directive to GENERALEDIT.
C SORT OFFSET=n MODE=[REAL,INT] direction=[ASCEN,DESCE]. It sorts
C a group of a list in memory - no changes unless you write back
C to disk. e.g. #GENER 5/LOCA RECO=101/SORT 2 REAL DESC/....
C sorts L5 into descending order of serial.
C
C Revision 1.10  2002/10/01 14:09:12  rich
C DISPLAY KEYS was causing problems if CMON buffer not emptied first.
C
C Revision 1.9  2002/08/29 15:16:07  richard
C OVERWRITE and NEW parameters added to GeneralEdit's WRITE directive.
C
C Revision 1.8  2002/02/20 14:15:28  ckp2
C RIC: Fixed ancient bug in GENERALEDIT 'INSERT' which, as far as I can see will
C have always prevented it from working, unless you happen to be extrememly lucky.
C RIC: Don't write "END" into log files as if the user doesn't issue 'end' then
C it appears after the next instruction making the log fairly useless.
C
C Revision 1.7  2001/09/11 08:23:17  ckp2
C Small fix. Only log "Generaledit cannot be logged" comments, if logging
C is turned on in the first place.
C
C Revision 1.6  2001/09/07 14:27:47  ckp2
C Turn off logging when running the GENERALEDIT command. The log file will now look
C something like this:
C
C #GENERALEDIT 30
C # generaledit commands can not be logged.
C END
C
C or, if a WRITE is performed:
C
C #GENERALEDIT 30
C # generaledit commands can not be logged
C # This list was updated during this generaledit
C END
C
C Revision 1.5  2001/06/18 13:36:08  richard
C Replace explicit 131072 with ISIZST from /XSIZES/
C
C Revision 1.4  2000/12/08 16:02:33  richard
C RIC: Modify generaledit so that it can be passed a record length, in
C order to copy data in long text strings into list records.
C
CODE FOR XGENED
      SUBROUTINE XGENED
C
C -- SUBROUTINE TO READ AND MODIFY DSC DATA DIRECTLY
C
C REMEMBER
C            DATA IS STORED IN RECORD NUMBER n, DEFINED IN 'COMMANDS'
C            A RECORD CONSISTS OF NGRP GROUPS
C            A GROUP CONTAINS LENGRP ITEMS
C
C      IF A RECORD CAN BE LOCATED, NGRP IS GT 0 AND
C      THE RECORD BEGINS AT IRCADR
C
C
C      VERSION
C      1.00      JANUARY 1985          PWB   INITIAL VERSION
C      1.01      FEBRUARY 1985         PWB   ADD 'OPERATE' DIRECTIVE
C      1.02      FEBRUARY 1985         PWB   CHANGE 'ERROR' DIRECTIVE
C      1.03      JANUARY 1991          DJW   ADD 'TOP, NEXT, LAST, BOTTO
C
      CHARACTER*80 CFORM(3) , CIFORM
      CHARACTER*12 CEVARI , CTVARI
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSIZES.INC'
      INCLUDE 'UFILE.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA IVERSN / 103 /
C
      DATA ICOMSZ / 5 /
      DATA LLSTCM / 512 /
      DIMENSION ID(2)
      
      character, dimension(18), parameter :: numbers=
     1     (/'0','1','2','3','4','5','6','7','8','9',
     2       '+','-','.',' ','e','E','d','D'/)
      logical found, isanumber
C
C
C -- SET THE TIMING AND READ THE CONSTANTS
C
      CALL XTIME1 ( 2 )
C
C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
CMAR98
      ICOMBL = KSTALL ( ICOMSZ )
      CALL XZEROF (STORE(ICOMBL), ICOMSZ)
C
C -- ALLOCATE SPACE FOR 'COMMON BLOCK' AREA
      ILSTCM = KSTALL ( LLSTCM )
C
      CFORM(1) = '(1X,F15.5)'
      CFORM(2) = '(1X,F15.5)'
      CFORM(3) = '(1X,F15.5)'
C
      CEVARI = ' '
      CTVARI = ' '
      ILEVEL = 1
      IERROR = IERWRN
      ILVACT = 0
C
      IRTYPE = 0
      LDATA = 0
      MDATA = 0
      NMAX = 0
C
C Turn logging off, temporarily, as logged GENERALEDITS are worse
C than useless.

      INLOG = IRDLOG(IFLIND)
      IRDLOG(IFLIND) = 0
      IF(INLOG.NE.0)WRITE(NCLU,'(A)')'# GENERALEDIT can not be logged'
C
C
C -- ENSURE THAT THE ALL THE DIRECTIVES APPEAR TO HAVE BEEN READ ONCE
      MR61 = LR61
      DO 1000 I = 1 , NR60
      ISTORE(MR61+8) = 1
      MR61 = MR61 + MDR61
1000  CONTINUE
C
1050  CONTINUE
C -- READ NEXT DIRECTIVE
      IDIR = KRDNDC ( ISTORE(ICOMBL) , ICOMSZ )
C -- CHECK IF THE DIRECTIVE JUST READ IN IS 'END' OR 'CONTINUE'
      IF ( IDIR .LT. 0 ) GO TO 9000
      IF ( IDIR .EQ. 0 ) GO TO 8920
C
1100  CONTINUE
C -- PROCESS THE KEYWORDS AND PARAMETERS
      IDWZAP = 0
      IF (  KFNDNP ( IDWZAP )  .LE.  0  ) GO TO 1200
C
      ISTAT = KRDPV ( ISTORE(ICOMBL) , ICOMSZ )
      IF ( ISTAT .LT. 0 ) GO TO 1200
      IF ( ISTAT .EQ. 0 ) GO TO 1100
C
C -- SPECIAL VALUE TO BE READ
      WRITE ( CIFORM , '(80A1)' ) ( LCMAGE(I) , I = NC , LASTCH )
      NC = LASTCH
      GO TO 1100
C
C
1200  CONTINUE
C -- CHECK INPUT OF DIRECTIVE COMPLETE AND BRANCH ON THE FUNCTION
      ISTAT = KCHKPV ( IDIR , ISTORE(ICOMBL) , ICOMSZ , -1 )
      IF ( ISTAT .LT. 0 ) GO TO 8900
      IF ( LEF .GT. 0 ) GO TO 8900
C -- DISPLAY DIRECTIVE
      CALL XMONTR ( -1 )
C
C      LOCATE      KEY         DISPLAY     FORMAT      SEARCH
C      GROUP       ERROR       INSERT      DELETE      WRITE
C      TRANSFER    CHANGE      RECORD      CHECK       OPERATE
C      TOP         NEXT        PREVIOUS    BOTTOM
C      TRANSHEAD   GETSERIAL   SORT        GENERALEDIT
C
      GO TO ( 2100 , 2200 , 2300 , 2400 , 2500 ,
     2 2600 , 2700 , 2800 , 2900 , 3000 ,
     3 3100 , 3200 , 3300 , 3400 , 3500 ,
     4 2420,  2440 , 2460 , 2480 , 
     5 3150 , 3160,  3170,  1500 , 9920 ) , IDIR
      GO TO 9920
C
1500  CONTINUE
C -- 'GENERALEDIT' DIRECTIVE
      ILTYPE = ISTORE(ICOMBL)
C
C -- LOAD LIST
      CALL XLDLST ( ILTYPE , ISTORE(ILSTCM) , LLSTCM , -1 )
      IF ( IERFLG .LE. 0 ) GO TO 9900
C
      GO TO 8000
C
C
C
2100  CONTINUE
C -- 'LOCATE' DIRECTIVE
C
      IRTYPE = ISTORE(ICOMBL)
C
      ISTAT = KHUNTR ( ILTYPE , IRTYPE , IADDL , IADDR , IADDD , -1 )
      IF ( ISTAT .NE. 0 ) THEN
cdjwapr2011        IRTYPE = 0
        GO TO 8910
      ENDIF
C
      LENGRP = ISTORE(IADDR+4)
      NGRP = ISTORE(IADDR+5)
      LDATA = ISTORE(IADDR+3)
      ICMADR = ILSTCM + ISTORE(IADDR+7) + 2
C
      MDATA = LDATA + ( NGRP - 1 ) * LENGRP
      NMAX = NGRP
C
      IKYOFF = 0
      IKYLEN = 1
      IKYTYP = 1
C
      IGROFF = 0
      IGRLEN = LENGRP
      IGRTYP = 1
C
      IRCOFF = 0
      IRCLEN = LENGRP
      IRCTYP = 1
C
C
      IRCADR = LDATA
C
      GO TO 8000
C
2200  CONTINUE
C -- 'KEY' DIRECTIVE
      IF ( IRTYPE .GT. 0 ) THEN
        IKYOFF = ISTORE(ICOMBL)
        IKYLEN = ISTORE(ICOMBL+1)
        IKYTYP = ISTORE(ICOMBL+2)
      ENDIF
      GO TO 8000
C
2300  CONTINUE
C
C -- 'DISPLAY' DIRECTIVE
C
      IF ( IRTYPE .LT. 0 ) GO TO 8930
      IF ( NGRP .LE. 0 ) GO TO 8960
C
      ITYPE = ISTORE(ICOMBL)
      idjwtype = istore(icombl+1)
      idjwlines = istore(icombl+2)
C
      IF ( ITYPE .EQ. 1 ) THEN
        IDTYPE = IKYTYP
        IOFF = IKYOFF
        IEND = IKYOFF + IKYLEN - 1
        LIM1 = LDATA
        LIM2 = MDATA
      ELSE IF ( ITYPE .EQ. 2 ) THEN
        IDTYPE = IGRTYP
        IOFF = 0
        IEND = LENGRP - 1
        LIM1 = IRCADR
        LIM2 = IRCADR
      ELSE IF ( ITYPE .EQ. 3 ) THEN
        IDTYPE = IRCTYP
        IOFF = 0
        IEND = LENGRP - 1
        LIM1 = LDATA
        LIM2 = MDATA
      ENDIF
C
C RICJUN99 - The XPRVDU call was only outputting one line.
C This does not allow for format statements with linefeeds in.
C I don't see how we can handle that really.
      NLINES = 1 + ( LIM2 - LIM1 ) / LENGRP
c overall, integer and reals all have ITYPE =3, IDTYPE = 1
c the correct format statement is loaded, but for reals
c the first two items must be output as integer

c      write(cmon,*)'ITYPE',itype, idtype, idjwtype, nlines,
c     1 IDJWLINES
c      call xprvdu(ncvdu, 1 ,0)
c      write(cmon,*)'LIM1',lim1, lim2, lengrp, iof, iend
c      call xprvdu(ncvdu, 1 ,0)
c      write(cmon,'(a)') cform(itype)
c      call xprvdu(ncvdu, 1 ,0)


      DO I = 1,NLINES
        WRITE(CMON(I),'(A)')' ' !Clear CMON, just in case.
      END DO
      IF ( ( IDjwTYPE .EQ. 1 ) .OR. ( IDjwTYPE .EQ. 3 ) ) THEN
        WRITE ( NCAWU , CFORM(ITYPE) , ERR = 8950 ) ( ( ISTORE(J) ,
     2                              J = I + IOFF , I + IEND ) ,
     3                              I = LIM1 , LIM2 , LENGRP )
        WRITE ( CMON, CFORM(ITYPE) , ERR = 8950 ) ( ( ISTORE(J) ,
     2                              J = I + IOFF , I + IEND ) ,
     3                              I = LIM1 , LIM2 , LENGRP )
        CALL XPRVDU(NCVDU, NLINES ,0)

      ELSE IF ( IDjwTYPE .EQ. 2 ) THEN
        do I = LIM1 , LIM2 , LENGRP
        WRITE ( NCAWU , CFORM(ITYPE) , ERR = 8950 ) 
     2  istore(i+ioff),istore(i+ioff+1),(STORE(J), J=I+IOFF+2,I+IEND)
        WRITE ( CMON , CFORM(ITYPE) , ERR = 8950 ) 
     2  istore(i+ioff),istore(i+ioff+1),(STORE(J), J=I+IOFF+2,I+IEND)
        CALL XPRVDU(NCVDU, IDJWLINES ,0)
        enddo

      ENDIF
      GO TO 8000
C
2400  CONTINUE
C
C -- 'FORMAT' DIRECTIVE
      IFORM = ISTORE(ICOMBL)
      CFORM(IFORM) = CIFORM
      GO TO 8000
C
2420  CONTINUE
C----- 'TOP' DIRECTIVE
      IF ( NGRP .LE. 0 ) GO TO 8960
      IRCADR = LDATA
      GOTO 8000
C
2440  CONTINUE
C----- 'NEXT' DIRECTIVE
      IF ( NGRP .LE. 0 ) GO TO 8960
      IRCADR = IRCADR + LENGRP
      IF ( IRCADR .GE. LDATA + (LENGRP * NGRP) ) GOTO 8970
      GOTO 8000
C
2460  CONTINUE
C----- 'PREVIOUS' DIRECTIVE
      IF ( NGRP .LE. 0 ) GO TO 8960
      IRCADR = IRCADR - LENGRP
      IF ( IRCADR .LT. LDATA ) GOTO 8970
      GOTO 8000
C
2480  CONTINUE
C----- 'BOTTOM' DIRECTIVE
      IF ( NGRP .LE. 0 ) GO TO 8960
      IRCADR = LDATA + (LENGRP * (NGRP-1)  )
      GOTO 8000
C
C
2500  CONTINUE
C -- 'SEARCH' DIRECTIVE
C
      IF ( NGRP .LE. 0 ) GO TO 8960
C
      CALL XMOVE ( ISTORE(ICOMBL+IKYTYP-1) , ISRKEY , 1 )
C
      ISTAT = KCOMP ( 1 , ISRKEY , ISTORE(LDATA+IKYOFF) , NGRP, LENGRP)
      IF ( ISTAT .LE. 0 ) GO TO 8940
C
      IRCADR = LDATA + ( ISTAT - 1 ) * LENGRP
      GO TO 8000
C
2600  CONTINUE
C -- 'GROUP' DIRECTIVE
      IGROFF = ISTORE(ICOMBL)
      IGRLEN = ISTORE(ICOMBL+1)
      IGRTYP = ISTORE(ICOMBL+2)
      GO TO 8000
C
2700  CONTINUE
C -- 'ERROR' DIRECTIVE
      ILEVEL = ISTORE(ICOMBL)
      ILVSEL = ISTORE(ICOMBL+1)
      ILVACT = ISTORE(ICOMBL+2)
      CEVARI = CIFORM
      IF ( CEVARI .EQ. 'NONE' ) CEVARI = ' '
C
      IF ( ILVSEL .EQ. 1 ) THEN
        IERROR = IERNOP
      ELSE IF ( ILVSEL .EQ. 2 ) THEN
        IERROR = IERWRN
      ELSE IF ( ILVSEL .EQ. 3 ) THEN
        IERROR = IERERR
      ENDIF
C
      GO TO 8000
C
2800  CONTINUE
C -- 'INSERT' DIRECTIVE
C -- IF THERE IS NO MORE ROME HERE, CREATE SOME SPACE
      IF ( NGRP .GE. NMAX ) THEN
        NMAX = NMAX + 10
        ISPACE = NMAX * LENGRP
        NEWDAT = KSTALL ( ISPACE )
C -- MOVE EXISTING DATA
        NMOVE = LENGRP * NGRP
        IF ( NMOVE .GT. 0 ) THEN
          CALL XMOVE ( ISTORE(LDATA) , ISTORE(NEWDAT) , NMOVE )
        ENDIF
        ISHIFT = NEWDAT - LDATA
        LDATA = NEWDAT
        MDATA = MDATA + ISHIFT
        IRCADR = IRCADR + ISHIFT
C -- CHANGE POINTER TO DATA
        ISTORE(IADDR+3) = LDATA
C
        ENDIF
C
      NGRP = NGRP + 1
      MDATA = MDATA + LENGRP
      IRCADR = MDATA
C
      ISTORE(ICMADR) = NGRP
C
      GO TO 8000
C
2900  CONTINUE
C -- 'DELETE' DIRECTIVE
      IF ( IRCADR .LE. 0 ) GO TO 8930
C
      IF ( NGRP .LE. 0 ) GO TO 8960
C
      IF ( IRCADR .LT. MDATA ) THEN
        CALL XMOVE ( ISTORE(IRCADR+LENGRP) , ISTORE(IRCADR) ,
     2 MDATA-IRCADR )
      ENDIF
      MDATA = MDATA - LENGRP
      NGRP = NGRP - 1
C
      ISTORE(ICMADR) = NGRP
C
      GO TO 8000
C
3000  CONTINUE
C -- 'WRITE' DIRECTIVE
      IF(INLOG.NE.0)WRITE(NCLU,'(A)')'# An update (WRITE) occured'
      IOWF = ISTORE(ICOMBL)
      INEW = ISTORE(ICOMBL+1)
C      IOWF = 0
C      INEW = 1
      CALL XWLSTD ( ILTYPE , ISTORE(ILSTCM) , LLSTCM , IOWF , INEW )
      GO TO 8000
C
3100  CONTINUE
C -- 'TRANSFER' DIRECTIVE
      IDIREC = ISTORE(ICOMBL)
      IOFF   = ISTORE(ICOMBL+1)
      ILGTH  = ISTORE(ICOMBL+2)

      CTVARI = CIFORM
C
      IF ( IRCADR .LE. 0 ) GO TO 8930
C
      ! Checking if the transfer is a variable name or a constant
      isanumber=.true.
      do j=1, len_trim(ctvari)
          found=.false.
          do i=1, size(numbers)
              if(ctvari(j:j)==numbers(i)) then  
                  found=.true.
                  exit
              end if
          end do
          if(.not. found) then
              isanumber=.false.
              exit
          end if
      end do
      ! Further check if a number: e or d can't be the first character
      if(isanumber) then
          do i=11, size(numbers)
              if(index(ctvari, numbers(i))==1) then
                  isanumber=.false.
                  exit
              end if
          end do
      end if
      
      if(isanumber .and. idirec==2) then
          ! A constant, read in the value directly
          read(ctvari, *, iostat=ISTAT) STORE(IRCADR+IOFF)
          if(istat/=0) then
            istat=-1
          end if
      else
          ! A variable from script, fetching the value
          ISTAT = KSCTRN ( IDIREC , CTVARI , ISTORE(IRCADR+IOFF), ILGTH)
      end if
C
      GO TO 8000
C
C RICAUG00 -- Get info from the list header (common block)
3150  CONTINUE
C -- 'TRANSHEAD' DIRECTIVE
      IDIREC = ISTORE(ICOMBL)
      IOFF = ISTORE(ICOMBL+1)
      CTVARI = CIFORM
C
      IF ( ILSTCM + IOFF .LE. 0 ) GO TO 8930
      IF ( ILSTCM + IOFF .GT. ISIZST ) GO TO 8930

	  
      ! Checking if the transfer is a variable name or a constant
      isanumber=.true.
      do j=1, len_trim(ctvari)
          found=.false.
          do i=1, size(numbers)
              if(ctvari(j:j)==numbers(i)) then  
                  found=.true.
                  exit
              end if
          end do
          if(.not. found) then
              isanumber=.false.
              exit
          end if
      end do
      
      if(isanumber .and. idirec==2) then
          ! A constant, read in the value directly
          read(ctvari, *) ISTORE(ILSTCM+IOFF)
c          print *,' Read const: ', STORE(ILSTcM+ioff), ILSTCM, IOFF
      else
          ! A variable from script, fetching the value
          ISTAT = KSCTRN ( IDIREC , CTVARI , ISTORE(ILSTCM+IOFF), 1)
      end if

C      ISTAT = KSCTRN ( IDIREC , CTVARI , ISTORE(ILSTCM+IOFF), 1 )
C              
      GO TO 8000
C
C RICAUG00 -- Get the list serial number...
3160  CONTINUE
C -- 'GETSERIAL' DIRECTIVE
      IDIREC = 1
      CTVARI = CIFORM
C
      CALL XRLIND ( ILTYPE, ILSERI, NFW, LL, IOW, NOS, ID)
C
      ISTAT = KSCTRN ( IDIREC , CTVARI , ILSERI, 1 )
C              
      GO TO 8000
C RICOCT02 -- Sort the records in the current recordtype
3170  CONTINUE
C -- 'SORT' DIRECTIVE
      IOFF = ISTORE(ICOMBL)
      IMODE = ISTORE(ICOMBL+1) 
      IDIREC = 3 - 2 * ISTORE(ICOMBL+2)

      IF ( ( NGRP .LE. 1 ) .OR. ( LDATA .LE. 0 ) ) GOTO 8000

        IF ( IMODE .EQ. 1 ) THEN
            CALL SSORTI ( LDATA, NGRP, LENGRP, IOFF * IDIREC )
        ELSE
            CALL SSORT ( LDATA, NGRP, LENGRP, IOFF * IDIREC )
        END IF

      GO TO 8000
C
3200  CONTINUE
C -- 'CHANGE' DIRECTIVE
      IOFF = ISTORE(ICOMBL)
      IMODE = ISTORE(ICOMBL+1)
C
      IF ( IRCADR .LE. 0 ) GO TO 8930
C
      CALL XMOVE ( ISTORE(ICOMBL+IMODE) , ISTORE(IRCADR+IOFF) , 1 )
      GO TO 8000
C
3300  CONTINUE
C -- 'RECORD' DIRECTIVE
      IF ( IRTYPE .GT. 0 ) THEN
        IRCOFF = ISTORE(ICOMBL)
        IRCLEN = ISTORE(ICOMBL+1)
        IRCTYP = ISTORE(ICOMBL+2)
      ENDIF
      GO TO 8000
C
3400  CONTINUE
C -- 'CHECK' DIRECTIVE
      IF ( NGRP .LE. 0 ) GO TO 8960
      GO TO 8000
C
3500  CONTINUE
C
C -- 'OPERATE' DIRECTIVE
C
C      IOPER       OPERATION
C      1           ADD
C      2           SUBTRACT
C      3           MULTIPLY
C      4           DIVIDE
C
      IOPER = ISTORE(ICOMBL)
      IOFF = ISTORE(ICOMBL+1)
      IMODE = ISTORE(ICOMBL+2)
C
      IF ( IRCADR .LE. 0 ) GO TO 8930
C
C
      IF ( IMODE .EQ. 3 ) THEN
C
        IOLD = ISTORE(IRCADR+IOFF)
        IVALUE = ISTORE(ICOMBL+IMODE)
C
        IF ( IOPER .EQ. 1 ) THEN
          INEW = IOLD + IVALUE
        ELSE IF ( IOPER .EQ. 2 ) THEN
          INEW = IOLD - IVALUE
        ELSE IF ( IOPER .EQ. 3 ) THEN
          INEW = IOLD * IVALUE
        ELSE IF ( IOPER .EQ. 4 ) THEN
          INEW = IOLD / IVALUE
        ENDIF
C
        ISTORE(IRCADR+IOFF) = INEW
C
      ELSE IF ( IMODE .EQ. 4 ) THEN
C
        XOLD = STORE(IRCADR+IOFF)
        XVALUG = STORE(ICOMBL+IMODE)
C
        IF ( IOPER .EQ. 1 ) THEN
          XNEW = XOLD + XVALUG
        ELSE IF ( IOPER .EQ. 2 ) THEN
          XNEW = XOLD - XVALUG
        ELSE IF ( IOPER .EQ. 3 ) THEN
          XNEW = XOLD * XVALUG
        ELSE IF ( IOPER .EQ. 4 ) THEN
          XNEW = XOLD / XVALUG
        ENDIF
C
        STORE(IRCADR+IOFF) = XNEW
C
      ENDIF
C
      GO TO 8000
C
C
C
C
8000  CONTINUE
      GO TO 1050
C
C
8900  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( NCAWU , 8905 )
         WRITE ( CMON, 8905 )
         CALL XPRVDU(NCVDU, 1,0)
8905     FORMAT ( 1X , 'The line above has been ignored' )
      ENDIF
C
      CALL XERHND ( IERROR )
C
      IF ( ILVACT .EQ. 1 ) THEN
        ISTAT = KSCTRN ( 1 , CEVARI , 1, 1 )
      ELSE IF ( ILVACT .EQ. 2 ) THEN
        ISTAT = KSCACT ( CEVARI )
      ENDIF
C
      GO TO 1050
C
C
8910  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( CMON, 8915 ) IRTYPE , ILTYPE
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCAWU ,  8915 ) IRTYPE , ILTYPE
8915    FORMAT ( 1X , 'Error searching for record type ' , I5 , ' in ',
     2 'list type ' , I5 )
      ENDIF
cdjw moved here from above so that record type can be output before 
c      being zeroed
        IRTYPE = 0
      GO TO 8900
C
8920  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( CMON, 8925 )
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCAWU , 8925 )
8925    FORMAT ( 1X , 'CONTINUE is not allowed in GENERALEDIT' )
      ENDIF
      GO TO 8900
C
8930  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( CMON, 8935 )
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCAWU , 8935 )
8935    FORMAT ( 1X , 'No current record selected' )
      ENDIF
      GO TO 8900
C
8940  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( CMON , 8945 )
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCAWU , 8945 )
8945    FORMAT ( 1X , 'Not found' )
      ENDIF
      GO TO 8900
C
8950  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( CMON, 8955 )
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCAWU , 8955 )
8955    FORMAT ( 1X , 'Error during write' )
        CALL XERIOM ( NCWU , 0 )
      ENDIF
      GO TO 8900
8960  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( CMON, 8965 )
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCAWU , 8965 )
8965    FORMAT ( 1X , 'No data stored at present' )
      ENDIF
      GO TO 8900
C
8970  CONTINUE
      IF ( ILEVEL .GT. 0 ) THEN
        WRITE ( CMON, 8975 )
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCAWU , 8975 )
8975    FORMAT ( 1X , 'There is no NEXT or PREVIOUS record' )
      ENDIF
      GO TO 8900
C
C
9000  CONTINUE
C
C -- RELEASE RESOURCES
      CALL XSTRLL ( ICOMBL )

Cric - do not write this END. Waste of space and often comes AFTER
Cthe next command.
c      IF(INLOG.NE.0)WRITE(NCLU,'(A)')'END'
      IRDLOG(IFLIND) = INLOG
C
C -- FINAL MESSAGE
      CALL XOPMSG ( IOPDSP , IOPEND , IVERSN )
      CALL XTIME2 ( 2 )
C
      RETURN
C
C
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDSP , IOPABN , 0 )
      GO TO 9000
9920  CONTINUE
C -- INTERNAL ERROR
      CALL XOPMSG ( IOPDSP , IOPINT , 0 )
      GO TO 9900
C
C
C
      END

