      program edscript
      character *132 cbuff, cline, kline
      character *24 cfile, dfile


      write(*,*)'Input file - no extension'
      read(*,'(a)') cbuff
      call xcrems( cbuff, cfile, lenfil)
      write(*,'(a,a)') cfile(1:lenfil-1),' '
      dfile = cfile
      open(10, file=cfile(1:lenfil-1)//'.ssc', status='old',err=9999)
      open(11, file=cfile(1:lenfil-1)//'.out', 
     1 status='unknown',err=9999)
      open(12, file=cfile(1:lenfil-1)//'.lis', 
     1 status='unknown',err=9999)
      open(13, file=cfile(1:lenfil-1)//'.log', 
     1 status='unknown',err=9999)

      nspace = 0
      nline = 0
      idown = 0
100   continue
101   format(a)
      read(10,101,end=8888) cbuff
      nline = nline + 1
      call xcrems( cbuff, cline, lenlin)
      call xccupc ( cline , kline )
c add a space to the end of the line
      lenlin = lenlin +1
	cbuff(lenlin:lenlin) = ' '
	  write(*,'(2i5,a)')nspace, nline, cline
	  write(12,'(2i5,3x,a)')nspace, nline, cline
      if((cbuff(1:2) .eq. '%%').or. (cbuff(1:1).eq.'^')) then
        call linout(-1, cline, lenlin)
	else if (cbuff(1:1) .ne. '%') then
        call linout(-1, cline, lenlin)
	else
	  cline(1:1) = ' '
	  itext = index(kline,'ON END')
  	  if (itext .ne. 0) then
          call linout(nspace, cline, lenlin)
	  else
	    idown = 0
          idown = max(idown, index(kline,' ELSE '))
          idown = max(idown, index(kline,' END '))
          if (idown .gt. 0) then
            if (index(kline,' END ') .ne. 0) then
c             must be END -  decrement
              nspace = nspace-1
	      endif
            if (nspace .lt. 0) then
                  if (index(kline,'SCRIPT') .eq. 0) then
                    write(*,*)'Error in line', nline, nspace
                    stop
                  endif
            endif
            call linout(nspace, cline, lenlin)
            call logout(nline, nspace, cline, lenlin)
          else
            iup = 0
            iup = max(iup, index(kline,' BLOCK '))
            iup = max(iup, index(kline,' CASE '))
            iup = max(iup, index(kline,' IF '))
            iup = max(iup, index(kline,' LOOP '))
            if (iup .gt. 0) then
                  call linout(nspace, cline, lenlin)
                  call logout(nline, nspace, cline, lenlin)
                  nspace = nspace + 1
            else
             call linout(nspace, cline, lenlin)
            endif
          endif
	  endif
	endif
      goto 100
8888  continue
      stop 'OK'
9999  continue
      stop 'file error'
      end
c
c
      subroutine linout(n,cline,lenlin)
      character *(*) cline
      character *24 cspace
      cspace = ' '
	if (n .lt. 0) then
c  comment or GUI line
        write(11,'(a)') cline(1:lenlin)
	else
        write(11,'(3a)') '%',cspace(1:2*n),cline(1:lenlin)
	endif
      return
      end
c
      subroutine logout(nline, n,cline,lenlin)
      character *(*) cline
      character *24 cspace
      cspace = ' '
	if (n .lt. 0) then
c  comment or GUI line
        write(11,'(a)') cline(1:lenlin)
	else
        write(13,'(i5,3x,3a)') nline,'%',cspace(1:2*n),cline(1:lenlin)
	endif
      return
      end


CODE FOR KCCEQL
      FUNCTION KCCEQL ( CDATA , ISTART , CMATCH )
C
C -- LOCATE SUBSTRING IN STRING
C
C -- THIS FUNCTION IS SIMILAR TO FORTRAN 'INDEX'
C
C      CDATA       STRING IN WHICH TO SEARCH
C      ISTART      STARTING POSITION IN 'CDATA'
C      CMATCH      STRING TO SEARCH FOR
C
C      KCCEQL      -1      NO MATCH
C                  +VE     POSITION IN 'CDATA' OF CMATCH
C
C
      CHARACTER*(*) CDATA , CMATCH
C
C
      KCCEQL = -1
C
      LENMAT = LEN ( CMATCH )
      LENDAT = LEN ( CDATA )
      IFINSH = LENDAT - LENMAT + 1
C
      IF ( ISTART .LE. 0 ) RETURN
      IF ( ISTART .GT. IFINSH ) RETURN
C
      IPOS = INDEX ( CDATA(ISTART:) , CMATCH )
      IF ( IPOS .LE. 0 ) RETURN
C
      KCCEQL = ISTART + IPOS - 1
      RETURN
      END

CODE FOR XCCUPC
      SUBROUTINE XCCUPC ( CLOWER , CUPPER )
C
C -- CONVERT STRING TO UPPERCASE
C
C      CLOWER      SOURCE STRING TO BE CONVERTED
C      CUPPER      RESULTANT STRING
C
C
      CHARACTER*(*) CLOWER , CUPPER
C
      CHARACTER*26 CALPHA , CEQUIV
C
      DATA CALPHA / 'abcdefghijklmnopqrstuvwxyz' /
      DATA CEQUIV / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
C
C
C -- MOVE WHOLE STRING.
C-ASSIGNING LOWER TO UPPER IS FORMALLY INVALID
C      CUPPER = CLOWER
      READ(CLOWER,'(A)') CUPPER
C
      LENGTH = MIN0 ( LEN ( CLOWER ) , LEN ( CUPPER ) )
C
C -- SEARCH FOR LOWERCASE CHARACTERS AND CONVERT TO UPPERCASE
      DO 2000 I = 1 , LENGTH
        IPOS = INDEX ( CALPHA , CLOWER(I:I) )
        IF ( IPOS .GT. 0 ) CUPPER(I:I) = CEQUIV(IPOS:IPOS)
2000  CONTINUE
C
C
      RETURN
      END
CODE FOR XCTRIM
      SUBROUTINE XCTRIM( CSOURC, NCHAR)
C------ TRIM OFF TRAILING SPACES
C      CSOURC - SOURCE STRING
C      NCHAR   - LAST NON-SPACE CHARACTER
      CHARACTER *(*) CSOURC
      CHARACTER *1 CBLANK
      DATA CBLANK /' '/
C
      LENGTH = LEN (CSOURC)
      IF (CSOURC(LENGTH:LENGTH) .NE. CBLANK) THEN
            NCHAR = LENGTH
            RETURN
      ENDIF
      DO 100 I = LENGTH, 1, -1
      IF (CSOURC(I:I) .NE. CBLANK) GOTO 200
100   CONTINUE
      I = 0
200   CONTINUE
      NCHAR = I + 1
      RETURN
      END
C
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
CODE FOR XCRAS
      SUBROUTINE XCRAS ( CSOURC, LENNAM )
C
C----- REMOVE ALL SPACES BY LEFT ADJUSTING STRING
C
C      CSOURC      SOURCE STRING TO BE CONVERTED
C      LENNAM      USEFUL LENGTH
C
C
      CHARACTER *(*) CSOURC
      CHARACTER *1  CBUF
C
      LENFIL=  LEN(CSOURC)
      K = 1
      DO 100 I = 1 , LENFIL
       CBUF = CSOURC(I:I)
       IF (CBUF .NE. ' ') THEN
           CSOURC(K:K) = CBUF
         K = K + 1
       ENDIF
100   CONTINUE
      LENNAM = MAX (1, K-1)
      IF (LENNAM .LT. LENFIL) CSOURC(LENNAM+1:LENFIL) = ' '
      RETURN
      END
C
