      PROGRAM DOCUMENT
C This program analyses the old paginate style documents and creates a
C Postscript document that can then be laser printed.
C UNLIKE DOC, EACH CHAPTER IS IN A SEPARATE FILE.
      CHARACTER * 20 INFILE
      CHARACTER * 2 CPAPER
      INTEGER IWID, IHEI
      REAL RNUMS(7)
      REAL PRATIO
C The data below is the width in points of each character related to
C the 12 pt font Times - Roman.
      INCLUDE 'paginate.inc'
       open (98,file='lincount.lis', status='unknown')
c      WRITE ( * ,  * ) 'Debug  -  1 for yes,  0 for no'
c      READ ( * ,  * ) IDEBUG
c----- count the file numbers
      ichapn = 1
50    CONTINUE
      WRITE (IUNIT6, '(A)') 'Please input the name of the file to be    
     1 processed ( * to end)'
      READ (IUNIT5, '(20A)') INFILE
      i = index (infile, ' ')
      IF (INFILE(1:1) .EQ. '*') STOP 'Documentation ends OK'
      OPEN (UNIT = IUNIT1, FILE = INFILE(1:i-1)//'.man', 
     1 STATUS = 'OLD',ERR=50)
      WRITE (IUNIT6, '(A)') 'Please input the name of the output file'
      READ (IUNIT5, '(20A)') PFILE
      iplen = index (pfile, ' ')
      OPEN (UNIT = IUNIT2, FILE = PFILE(1:iplen-1)//'.ps', 
     1 STATUS = 'UNKNOWN')
      OPEN (UNIT = IUNIT3, FILE = 'INDEX.TMP', STATUS = 'UNKNOWN')
C NOW START TO READ THE FILE
C      READ (IUNIT1, 3)
C     1 IPAGE, ICHAP, ISECTION, 
C     2 IMPNT, ITOP, IBOTTOM, INDENT, ILNGAP, ILEFTM, IRIGHT, ITITLE
C3     FORMAT (16X,  3I5,  8I5)
      READ (IUNIT1, 100, ERR=9876) CPAPER, impnt, IPAGE, ICHAP, ijpnt
      READ (IUNIT1, 150, ERR=9876) (RNUMS(I), I = 1, 7) 
C----- NO LINES READ THIS FILE
      INLINE = 0
100   FORMAT (A2, 5I3)
150   FORMAT (7F7.2)
      if (ijpnt .le. 0) ijpnt = impnt
C NOW CONVERT THE INFORMATION FROM INCHES INTO POINTS ( * 72)
      IF (CPAPER .EQ. 'A4') THEN
           WRITE(IUNIT6,*) 'A4 paper'
           IWID = 594
           IHEI = 846
      ELSE IF (CPAPER .EQ. 'US') THEN
C----- ACTUALLY MINIMA OF A4/US LETTER
           WRITE(IUNIT6,*) 'US paper'
           IWID = 594
           IHEI = 792
      ELSE IF (CPAPER .EQ. 'A5') THEN
           WRITE(IUNIT6,*) 'A5 paper'
           IWID = 423
           IHEI = 594
      ELSE
           WRITE (IUNIT6,  * ) 'ERROR PAPER SIZE NOT RECOGNISED'
           STOP
      ENDIF
      ILEFTM = RNUMS(1) * 72.0
      IRIGHT = IWID - RNUMS(2) * 72.0
      ITOP = IHEI - RNUMS(3) * 72
      IBOTTOM = RNUMS(4) * 72
      ILNGAP = RNUMS(5) * 72
      INDENT = RNUMS(6) * 72
      ITITLE = IHEI - RNUMS(7) * 72
      ibannr = ( ihei ) / 3
c      ISECTION = 0
      WRITE (IUNIT2, '(''%!PS'')')
      WRITE (IUNIT2, 200) ITOP, IBOTTOM, INDENT, ILNGAP, ILEFTM, IRIGHT,
     1ITITLE, ibannr
      WRITE (IUNIT2, 250) IPAGE, ICHAP, ISECTION, IMPNT
      PRATIO = REAL(IMPNT) / 12.0
      POINT = IMPNT
200   FORMAT ('/top ',I4,' def /bottom ',I4,' def /indent ',I4,' def '
     c ,/,'/linegap ',I4, ' def /leftmargin ',I4,' def /right ',I4,
     c ' def ',/,'/ytitle ',I4,' def ' ,'/ybanner ',I4,' def ')
250   FORMAT ('/pageno ',I4,' def /chapno ',I4,' def /sectno ',I4,'
     C def /point ',I4,' def ')
C NOW READ IN AND OUTPUT THE POSTSCRIPT HEADER FILE
      OPEN (UNIT = IUNIT4, FILE = 'DOCPST.HED', STATUS
     *  = 'OLD')
300   CONTINUE
      READ (IUNIT4, '(A80)', END = 350) CINLIN
      WRITE (IUNIT2, '(A80)') CINLIN
      GO TO 300
350   CONTINUE
      CLOSE (IUNIT4)
      INFLAG = 0
      ILEFT = ILEFTM
      IYPOS = 0
      CHASH = '#'
C HOW MANY LINES PER PAGE?
      RLINE = 0.0
C IGNORE THE TOP LINE FOR NOW
400   CONTINUE
C THIS IS THE OUTER LOOP
      LINES = 1 + (ITOP - IBOTTOM) / ILNGAP
      IF (INFLAG .EQ. 0) THEN
           READ (IUNIT1, '(A80)', END = 450) CINLIN
      INLINE = INLINE + 1
      WRITE(98,'(I15)') INLINE
      ELSE
           INFLAG = 0
      ENDIF
cdjwdec07
      call rtidy(cinlin)
c
      CTEXT = CINLIN(2:2)
      CTEXT2= CINLIN(2:3)
      IF (CINLIN(1:1).NE.CHASH) THEN
           IPFLAG = 0
           CALL XJUST (IPFLAG, INFLAG, PRATIO)
      ELSE IF (CTEXT .EQ. 'T') THEN
C #T replaced by dual function of #Z
C           CALL XTITLE
           CALL XSKIP
      ELSE IF (CTEXT .EQ. 'Z') THEN
           ctext = 'T'
      write(*,*) cinlin
           CALL XTITLE
      write(*,*) cinlin
           ctext = 'Z'
           CALL XCHAP
      write(*,*) cinlin
      ELSE IF (CTEXT .EQ. 'Y') THEN
           CALL XSECT
      ELSE IF ((CTEXT .EQ. 'P') .OR. (CTEXT2 .EQ. 'HP')) THEN
           IPFLAG = 1
           CALL XJUST (IPFLAG, INFLAG, PRATIO)
      ELSE IF (CTEXT .EQ. 'I') THEN
           CALL XINSTR (INFLAG, PRATIO)
      ELSE IF (CTEXT .EQ. 'D') THEN
           CALL XINSTR (INFLAG, PRATIO)
      ELSE IF (CTEXT .EQ. 'K') THEN
           CALL XINSTR (INFLAG, PRATIO)
      ELSE IF ((CTEXT .EQ. 'J') .OR. (CTEXT2 .EQ. 'HJ')) THEN
           CALL XLITER (PRATIO)
      ELSE IF (CTEXT .EQ. 'Q') THEN
           CALL XBLANK (INFLAG, PRATIO)
      ELSE IF (CTEXT .EQ. ' ') THEN
           CALL XBLANK (INFLAG, PRATIO)
      ELSE IF (CTEXT .EQ. 'N') THEN
           CALL XNEWP (2)
      ELSE IF (CTEXT .EQ. 'C') THEN
           CALL XSKIP
      ELSE IF (CTEXT .EQ. 'U') THEN
           CALL XSKIP
      ELSE IF (CTEXT .EQ. 'X') THEN
           CALL XSKIP
      ELSE IF (CTEXT .EQ. 'A') THEN
           CALL XSKIP
      ELSE IF (CTEXT .EQ. 'H') THEN
           CALL XSKIP
      ELSE IF (CTEXT .EQ. 'I') THEN
           CALL XSKIP
      ELSE IF (CTEXT .EQ. 'R') THEN
           CALL XSKIP
C      ELSE IF (CTEXT .EQ. 'F') THEN
C        CALL XFIGS
      ENDIF
      GO TO 400
450   CONTINUE
      CLOSE (IUNIT1)
451   CONTINUE
      WRITE (IUNIT6, '(A)') 'Another file to be processed ( * to end)'
      READ (IUNIT5, '(20A)') INFILE
      IF (INFILE(1:1) .NE. '*') THEN
      OPEN (UNIT = IUNIT1, FILE = INFILE//'.man', STATUS = 'OLD',ERR=50)
        READ(IUNIT1,'(A)') CINLIN
        READ(IUNIT1,'(A)') CINLIN
        GOTO 400 
      ENDIF
      WRITE (IUNIT2, '(25A)') 'ypos top ne {showpage} if'
      WRITE (IUNIT7, '(25A)') 'ypos top ne {showpage} if'
      CLOSE (IUNIT3)
C NOW WORK OUT THE CONTENTS AND INDEX PAGES
      CALL XDOIND
      STOP 'END OK'
9876  CONTINUE
      STOP 'FORMATTING DATA INCORRECT'
      END
c
      subroutine newchp
c^^output the manual chapter by chapter
      LOGICAL LOPEN
      character *80 ctemp
      character *24 cfile
      character *2 chapn
      include 'paginate.inc'
      iplen = index (pfile, ' ')
c      if (ichapn .le. 9) then
c      write (chapn(1:1),'(i1)') ichapn
c      else
      write (chapn(1:2),'(i2.2)') ichapn
c      endif
      write(cfile,'(a)') pfile(1:iplen-1)//chapn//'.ps'
      write(*,*)  cfile
      ichapn = ichapn + 1
      INQUIRE(IUNIT7, OPENED=LOPEN)
      IF (LOPEN ) WRITE(IUNIT7,99)
99    FORMAT('showpage')
      OPEN (UNIT = IUNIT7, FILE = cfile, STATUS = 'UNKNOWN')
      WRITE (IUNIT7, '(''%!PS'')')
      WRITE (IUNIT7, 200) ITOP, IBOTTOM, INDENT, ILNGAP, ILEFTM, IRIGHT,
     1ITITLE, ibannr
      WRITE (IUNIT7, 250) IPAGE, ICHAP, ISECTION, IMPNT
      PRATIO = REAL(IMPNT) / 12.0
      POINT = IMPNT
200   FORMAT ('/top ',I4,' def /bottom ',I4,' def /indent ',I4,' def '
     c ,/,'/linegap ',I4, ' def /leftmargin ',I4,' def /right ',I4,
     c ' def ',/,'/ytitle ',I4,' def ' ,'/ybanner ',I4,' def ')
250   FORMAT ('/pageno ',I4,' def /chapno ',I4,' def /sectno ',I4,'
     C def /point ',I4,' def ')
C NOW READ IN AND OUTPUT THE POSTSCRIPT HEADER FILE
      OPEN (UNIT = IUNIT4, FILE = 'DOCPST.HED', STATUS
     *  = 'OLD')
300   CONTINUE
      READ (IUNIT4, '(A80)', END = 350) Ctemp
      WRITE (IUNIT7, '(A80)') Ctemp
      GO TO 300
350   CONTINUE
      CLOSE (IUNIT4)
      return
      end
CODE FOR XTITLE
      SUBROUTINE XTITLE
      INCLUDE 'paginate.inc'
c      CHARACTER * 8 CDATE, EDATE@
      dimension idate(3)
c      CHARACTER * 8 CDATE
      CHARACTER * 9 CDATE
      CHARACTER * 300 CL
      CHARACTER *80 CSAVE
      CSAVE = CINLIN
      call newchp
C -  -  -  -  -  get the date
c      CDATE = EDATE@()
      CDATE = ' '
      call date(cdate)
C The title will be found after (2:2) and up to the # symbol.
      DO 50 I = 80, 3,  - 1
           IF (CINLIN(I:I).NE.' ') GO TO 100
50    CONTINUE
100   CONTINUE
      K = I
      IF (CINLIN(K:K) .EQ. CHASH) K = K - 1
      IF (K.LE.60) THEN
           DO 150 I = K, 3,  - 1
                J = I + 15
                CINLIN(J:J) = CINLIN(I:I)
150        CONTINUE
           K = K + 15
           CINLIN(3:11) = CDATE
           CINLIN(12:17) = ' '
      ENDIF
C NOW WRITE OUT THE COMMANDS
C CHECK FOR SPECIAL CHARACTERS
      CALL XCCHECK (CINLIN, CL, 3, K)
      COUTLN = '/title ('//CL(1:K)//') def'
      WRITE (IUNIT2, '(A)') COUTLN
      WRITE (IUNIT7, '(A)') COUTLN
      do 151 j = 11,k
      if (cl(j:j) .ne. ' ') goto 152
151   continue
      j = k
152   continue
      COUTLN = '/banner ('//CL(j:K)//') def'
      WRITE (IUNIT2, '(A)') COUTLN
      WRITE (IUNIT7, '(A)') COUTLN
      call XCTRIM( CSave, NCHAR)
      cinlin= csave(1:3)
      call XCCLWC ( Csave(4:nchar), Cinlin(4:nchar) )
      do 1000 i = 4,max(4,nchar-1)
      if (cinlin(I:I) .eq. ' ') cinlin(i+1:i+1) = csave(I+1:i+1)
1000  continue
      RETURN
      END
CODE FOR XCHAP
      SUBROUTINE XCHAP
      INCLUDE 'paginate.inc'
      CHARACTER * 300 CL
C The chapter text will be found after 2:2 and before the #
      ICHAP = ICHAP + 1
C FIND THE END OF THE LINE
      DO 50 I = 80, 3,  - 1
           IF (CINLIN(I:I).NE.' ') GO TO 100
50    CONTINUE
      I = 0
100   CONTINUE
      K = I
C NOW WRITE THE COMMANDS
      IPAGE = IPAGE + 1
      CALL XNEWP (1)
      WRITE (IUNIT3, 150) IPAGE, ICHAP
150   FORMAT ('C', 2I4)
      IF (K.NE.0) THEN
           IF (CINLIN(K:K) .EQ. CHASH) K = K - 1
           CALL XCCHECK (CINLIN, CL, 3, K)
           COUTLN = '/chaptext ('//CL(1:K)//') def'
           WRITE (IUNIT3, '(A)') CL(1:K)
           WRITE (IUNIT3, '(''I'',I4)' ) IPAGE
           WRITE (IUNIT3, '(A)') CL(1:K)
           WRITE (IUNIT2, '(A)') COUTLN
           WRITE (IUNIT7, '(A)') COUTLN
           COUTLN = '/ichap 1 def'
           RLINE = 4.0
           WRITE (IUNIT2, '(A)') COUTLN
           WRITE (IUNIT7, '(A)') COUTLN
      ELSE
           COUTLN = '/ichap 0 def'
           WRITE (IUNIT2, '(A)') COUTLN
           WRITE (IUNIT7, '(A)') COUTLN
           RLINE = 3.0
           WRITE (IUNIT3,  * )
           WRITE (IUNIT3, '(''I'',I4)' ) IPAGE
           WRITE (IUNIT3,  * )
      ENDIF
      ILEFT = ILEFTM
      WRITE (IUNIT2, '(A)') 'Chapter '
      WRITE (IUNIT2,'(A)') '/left leftmargin def '
      WRITE (IUNIT7, '(A)') 'Chapter '
      WRITE (IUNIT7,'(A)') '/left leftmargin def '
      RETURN
      END
CODE FOR XSECT
      SUBROUTINE XSECT
      INCLUDE 'paginate.inc'
      CHARACTER * 300 CL
C FIND THE SECTION TEXT
      DO 50 I = 80, 3,  - 1
           IF (CINLIN(I:I).NE.' ') GO TO 100
50    CONTINUE
      I = 0
100   CONTINUE
      K = I
      IF (CINLIN(K:K) .EQ. CHASH) K = K - 1
      RLINE = RLINE + 1.0
C DON'T HAVE A SECTION HEADING ON ITS OWN AT THE BOTTOM OF A PAGE
      IF (RLINE .GE. LINES - 1) THEN
           IPAGE = IPAGE + 1
           RLINE = 1.0
           CALL XNEWP (1)
      ENDIF
      WRITE (IUNIT3, 150) IPAGE
150   FORMAT ('S', I4)
      WRITE (IUNIT3, '(A)') CINLIN(3:K)
      WRITE (IUNIT3, '(''I'',I4)' ) IPAGE
      WRITE (IUNIT3, '(A)') CINLIN(3:K)
      CALL XCCHECK (CINLIN, CL, 3, K)
      COUTLN = '/secttext ('//CL(1:K)//') def Section'
      WRITE (IUNIT2, '(A)') COUTLN
      WRITE (IUNIT7, '(A)') COUTLN
      ILEFT = ILEFTM
      RETURN
      END
CODE FOR XSKIP
      SUBROUTINE XSKIP
      INCLUDE 'paginate.inc'
      CHARACTER * 300 CL
C The identified text will be found after 2:2 and before the #
c      and removed
C FIND THE END OF THE LINE
      DO 50 I = 80, 3,  - 1
           IF (CINLIN(I:I).NE.' ') GO TO 100
50    CONTINUE
      I = 0
100   CONTINUE
      K = I
      RETURN
      END
CODE FOR XJUST
      SUBROUTINE XJUST (IPFLAG, INFLAG, PRATIO)
      INCLUDE 'paginate.inc'
      CHARACTER * 300 CL
      CHARACTER * 80 CTEMP
      REAL PRATIO
      INTEGER ITSTAR, ITEND
C THE ARRAY WORDS CONTAINS POINTERS TO THE BEGINNING AND END OF
C EMBOLDENED AND ITALICISED TEXT.
      DO 50 I = 1, 100
           WORDS(1, I) = 0
           WORDS(2, I) = 0
50    CONTINUE
      IWPOS = 0
      IWFLAG = 0
      IA = 1
      IB = 1
      R = 0.0
100   CONTINUE
      IF (IPFLAG .EQ. 1) THEN
           IL = ILEFT + INDENT
      ELSE
           IL = ILEFT
      ENDIF
C FIND THE LENGTH OF THE LINE
      RLEN = IRIGHT - IL
C WE NEED TO SPLIT THE LINE UP INTO WORDS
C FIND THE LAST NON BLANK CHARACTER
      iend = 0
      DO 150 I = 80, 1,  - 1
           IF (CINLIN(I:I).NE.' ') GO TO 200
150   CONTINUE
C      nothing to do
      GO TO 850
200   CONTINUE
      IEND = I
C 
      K = 0
      IF (CINLIN(1:1) .EQ. CHASH) THEN
           IS = 3
      ELSE
           IS = 1
      ENDIF
C 
C 
C -  -  -  -  -  -  WE RETURN HERE FOR NEXT WORD
350   CONTINUE
      IFIN = 0
      IF (IS .Ge. IEND) GO TO 850
C     FIND START OF CURRENT WORD
      DO 400 I = IS, IEND
           IF (CINLIN(I:I).NE.' ') GO TO 450
400   CONTINUE
C     nothing found
      GO TO 850
450   CONTINUE
C----SET 'IS' TO FIRST CHARACTER CURRENT WORD in input buffer
      IS = I
C 
C     find end of current word
      DO 500 I = IS, IEND
           IF (CINLIN(I:I) .EQ. ' ') GO TO 550
500   CONTINUE
      I = IEND + 1
550   CONTINUE
C -  -  -  -  -  SET ifin TO FIRST SPACE AFTER CURRENT WORD
      IFIN = I
C THE WORD NOW LIES BETWEEN IS AND ifin - 1. FIND ITS TRUE LENGTH
C FIRST LOOK FOR CONTROL SEQUENCES
C WE ARE LOOKING FOR AN 'ON' CODE
      IF ((CINLIN(IS:IS) .EQ. '_').AND.(CINLIN(IS + 2:IS + 2) .EQ. '{'))
     *  THEN
           IF (CINLIN(IS + 1:IS + 1) .EQ. 'B') IWFLAG = 1
           IF (CINLIN(IS + 1:IS + 1) .EQ. 'b') IWFLAG = 1
           IF (CINLIN(IS + 1:IS + 1) .EQ. 'I') IWFLAG = 2
           IF (CINLIN(IS + 1:IS + 1) .EQ. 'i') IWFLAG = 2
           IF (IS .EQ. 1) THEN
            CTEMP = CINLIN(4:80)
           ELSE
            CTEMP = CINLIN(1:IS-1) // CINLIN(IS+3:80)
           ENDIF
           CINLIN = CTEMP
C       reset end of word and end of line
           IFIN = IFIN - 3
           iend = iend - 3 
      ENDIF
C STORE THE CODE POSITION
      RL = 0.0
      DO 600 I = IS, IFIN - 1
           J = ICHAR(CINLIN(I:I))
C       convert spurious characters to 'space'
           IF ((J .LT. 32).OR.(J .GT. 126)) J = 35
C       SET TO A CHAR WITH WIDTH 6.0
           RR = ABS(CWIDTH(J - 31)) * PRATIO
           RL = RL + RR
600   CONTINUE
C DOES THIS GO OVER THE LINE LENGTH?
      IF (R + RL .LT. RLEN) THEN
C       ADD IN LINE PLUS SPACE
C       ib is end of line
           IB = IA + IFIN - IS
           IF (IFIN .LT. 80) THEN
                COUTLN(IA:IB) = CINLIN(IS:IFIN)
           ELSE
                COUTLN(IA:IB) = CINLIN(IS:IFIN - 1) // ' '
           ENDIF
C WE NEED TO STORE THE WORD POSITIONS  -  STORE  - IA FOR ITALICS
           IF (IWFLAG .GT. 0) THEN
                IWPOS = IWPOS + 1
                WORDS(2, IWPOS) = IB
                IF (IWFLAG .EQ. 1) THEN
                     WORDS(1, IWPOS) = IA
                ELSE
                     WORDS(1, IWPOS) =  - IA
                ENDIF
                IWFLAG = 0
           ENDIF
C      add in a space
           R = R + RL + CWIDTH(1) * PRATIO
           IA = IB + 1
      ELSE
C       WE NEED TO WRITE OUT THIS LINE
C       HOW MANY SPACES ARE THERE?
C      strip off spurious spaces
           IF (COUTLN(IB:IB) .EQ. ' ') THEN
                IB = IB - 1
           ENDIF
           IN = 0
           DO 650 I = 1, IB
                IF (COUTLN(I:I) .EQ. ' ') IN = IN + 1
650        CONTINUE
           RLINE = RLINE + 1.0
           IF (RLINE .GE. LINES) THEN
                IPAGE = IPAGE + 1
                RLINE = 1
                CALL XNEWP (1)
           ENDIF
           WRITE (IUNIT2, 700) IL, IPFLAG, IN
           WRITE (IUNIT7, 700) IL, IPFLAG, IN
700        FORMAT ('/left ',I4,' def /ipflag ',I4,' def /numspace ',
     c  I4,' def')
           IPFLAG = 0
C NOW BEGIN TO LOOP OVER THE LINE
           ITSTAR = 1
           ITEND = IB
           CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)

           WRITE (IUNIT2,'(3A)') '/textstring (', CL(1:ITEND),') def'

           WRITE (IUNIT2,'(A)') '/last 0 def '

           WRITE (IUNIT7,'(3A)') '/textstring (', CL(1:ITEND),') def'

           WRITE (IUNIT7,'(A)') '/last 0 def '
           IF (IWPOS .EQ. 0) THEN
                WRITE (IUNIT2, '(A)') 'Write'
                WRITE (IUNIT7, '(A)') 'Write'
           ELSE
                WRITE (IUNIT2, '(A)') 'WriteCalc'
                WRITE (IUNIT7, '(A)') 'WriteCalc'
           ENDIF
           IF (IWPOS .GT. 0) THEN
                INPOS = 1
                IAPOS = 1
C 
750             CONTINUE
C FIND THE FIRST 'ON' CODE
                ISTART = ABS(WORDS(1, INPOS))
                IFIN2 = WORDS(2, INPOS)
                IF (ISTART .GT. IAPOS) THEN
C WRITE OUT THE NORMAL TEXT FIRST
C DO THE CHECK
                     ITSTAR = IAPOS
                     ITEND = ISTART - 1
                     CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)
                     WRITE (IUNIT2, '(3A)') '/textstring (',
     *               CL(1:ITEND), ') def WritePart'
                     WRITE (IUNIT7, '(3A)') '/textstring (',
     *               CL(1:ITEND), ') def WritePart'
                endif
                  ITSTAR = ISTART
                  ITEND = IFIN2
                  CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)
                  WRITE (IUNIT2, '(3A)') '/textstring (', CL(1:ITEND),
     *            ') def'
                  WRITE (IUNIT7, '(3A)') '/textstring (', CL(1:ITEND),
     *            ') def'
                  IF (WORDS(1, INPOS) .LT. 0) THEN
                       WRITE (IUNIT2, '(A)') 'WriteItalic'
                       WRITE (IUNIT7, '(A)') 'WriteItalic'
                  ELSE
                       WRITE (IUNIT2, '(A)') 'WriteBold'
                       WRITE (IUNIT7, '(A)') 'WriteBold'
                  ENDIF
C IS THERE A WORD AFTER THIS?
                IF (WORDS(1, INPOS + 1) .EQ. 0) THEN
C NO MORE BOLD / ITALIC WORDS ON THIS LINE
C WRITE OUT THE REMAINDER
                     IF (WORDS(2, INPOS) .LT. IB) THEN
                          ITSTAR = WORDS(2, INPOS) + 1
                          ITEND = IB
                          CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)
                          WRITE (IUNIT2, '(3A)') '/textstring (', 
     1                    CL(1:ITEND), ') def WritePart'
                          WRITE (IUNIT7, '(3A)') '/textstring (', 
     1                    CL(1:ITEND), ') def WritePart'
                     ENDIF
                     WRITE (IUNIT2, '(A)') 
     *               '/ypos ypos linegap sub def'
                     WRITE (IUNIT7, '(A)') 
     *               '/ypos ypos linegap sub def'
                ELSE IF (IFIN2 .LT. IB) THEN
C MOVE THE START UP
                     IAPOS = IFIN2 + 1
                     INPOS = INPOS + 1
                     GO TO 750
                ENDIF
           ENDIF
C RESET THE CODES
           DO 800 I = 1, 100
                WORDS(1, I) = 0
                WORDS(2, I) = 0
800        CONTINUE
           IWPOS = 0
           IA = 1
           IB = IFIN - IS + 1
           IN = 0
C STORE THE CURRENT WORD IF REQUIRED
           IF (IWFLAG .EQ. 1) THEN
                WORDS(1, 1) = IA
                WORDS(2, 1) = IB
                IWPOS = 1
           ELSE IF (IWFLAG .EQ. 2) THEN
                WORDS(1, 1) =  - IA
                WORDS(2, 1) = IB
                IWPOS = 1
           ENDIF
           IWFLAG = 0
C MOVE OVER THE WORD
           IF (IFIN .GT. 80) THEN
                COUTLN(IA:IB) = CINLIN(IS:IFIN - 1) // ' '
           ELSE
                COUTLN(IA:IB) = CINLIN(IS:IFIN)
           ENDIF
           IA = IB + 1
           R = RL
      ENDIF
Cdjw      IS  =  ifin  +  1
      IS = IFIN
      IF (IPFLAG .EQ. 1) THEN
           IL = ILEFT + INDENT
      ELSE
           IL = ILEFT
      ENDIF
      RL = IRIGHT - IL
      GO TO 350
850   CONTINUE
C WE HAVE REACHED THE END OF THE LINE  -  READ IN THE NEXT ONE
      IF (RLINE .GE. LINES) THEN
      ENDIF
      READ (IUNIT1, '(A80)', IOSTAT=IOS) CINLIN
cdjwdec07
      call rtidy(cinlin)
c
      IF (IOS .NE. 0) CINLIN=' '
      IF (CINLIN(1:1) .EQ. CHASH) THEN
C END OF THIS PIECE OF TEXT
           INFLAG = 1
C AND WRITE OUT THE LAST BIT OF LINE
           IF (IB .GT. 1) THEN
                RLINE = RLINE + 1.0
                IF (RLINE .GE. LINES) THEN
                     RLINE = 1
                     IPAGE = IPAGE + 1
                     CALL XNEWP (1)
                ENDIF
                WRITE (IUNIT2, 900) IPFLAG, IL
                WRITE (IUNIT7, 900) IPFLAG, IL
900             FORMAT ('/ipflag ', I4, ' def /left ', I4, ' def')
                IPFLAG = 0
                WRITE (IUNIT2, '(A)') '/last 1 def '
                WRITE (IUNIT7, '(A)') '/last 1 def '
C NOW LOOP OVER THE LINE
C NOW BEGIN TO LOOP OVER THE LINE
           ITSTAR = 1
           ITEND = IB
           CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)
           WRITE (IUNIT2,'(3A)') '/textstring (', CL(1:ITEND), ') def'

           WRITE (IUNIT7,'(3A)') '/textstring (', CL(1:ITEND),') def'
           IF (IWPOS .EQ. 0) THEN
                WRITE (IUNIT2, '(A)') 'Write'
                WRITE (IUNIT7, '(A)') 'Write'
                return
           ELSE
                WRITE (IUNIT2, '(A)') 'WriteCalc'
                WRITE (IUNIT7, '(A)') 'WriteCalc'
           ENDIF
           IF (IWPOS .GT. 0) THEN
                INPOS = 1
                IAPOS = 1
C 
950             CONTINUE
C FIND THE FIRST 'ON' CODE
                ISTART = ABS(WORDS(1, INPOS))
                IFIN2 = WORDS(2, INPOS)
                IF (ISTART .GT. IAPOS) THEN
C WRITE OUT THE NORMAL TEXT FIRST
                     ITSTAR = IAPOS
                     ITEND = ISTART - 1
                     CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)
                     WRITE (IUNIT2, '(3A)') '/textstring (',
     *               CL(1:ITEND), ') def WritePart'
                     WRITE (IUNIT7, '(3A)') '/textstring (',
     *               CL(1:ITEND), ') def WritePart'
                endif
                  ITSTAR = ISTART
                  ITEND = IFIN2
                  CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)
                  WRITE (IUNIT2, '(3A)') '/textstring (', CL(1:ITEND),
     *            ') def'
                  WRITE (IUNIT7, '(3A)') '/textstring (', CL(1:ITEND),
     *            ') def'
                  IF (WORDS(1, INPOS) .LT. 0) THEN
                       WRITE (IUNIT2, '(A)') 'WriteItalic'
                       WRITE (IUNIT7, '(A)') 'WriteItalic'
                  ELSE
                       WRITE (IUNIT2, '(A)') 'WriteBold'
                       WRITE (IUNIT7, '(A)') 'WriteBold'
                  ENDIF
C IS THERE A WORD AFTER THIS?
                IF (WORDS(1, INPOS + 1) .EQ. 0) THEN
C NO MORE BOLD / ITALIC WORDS ON THIS LINE
C WRITE OUT THE REMAINDER
                     IF (WORDS(2, INPOS) .LT. IB) THEN
                          ITSTAR = WORDS(2, INPOS) + 1
                          ITEND = IB
                          CALL XCCHECK (COUTLN, CL, ITSTAR, ITEND)
                          WRITE (IUNIT2, '(3A)') '/textstring (', 
     1                    CL(1:ITEND), ') def WritePart'
                          WRITE (IUNIT7, '(3A)') '/textstring (', 
     1                    CL(1:ITEND), ') def WritePart'
                     ENDIF
                     WRITE (IUNIT2, '(A)') 
     *               '/ypos ypos linegap sub def'
                     WRITE (IUNIT7, '(A)') 
     *               '/ypos ypos linegap sub def'
                ELSE IF (IFIN2 .LT. IB) THEN
C MOVE THE START UP
                     IAPOS = IFIN2 + 1
                     INPOS = INPOS + 1
                     GO TO 950
                ENDIF
           ENDIF
         endif
        RETURN
      ENDIF
C DO NEXT LINE
      GO TO 100
      END
CODE FOR XINSTR
      SUBROUTINE XINSTR (INFLAG, PRATIO)
C What type of instruction depends on the current level.
C FIND THE WORD LENGTH
      INCLUDE 'paginate.inc'
      CHARACTER * 80 C
      CHARACTER * 300 CL
      K = 0
      DO 50 I = 80, 3,  - 1
           IF ((CINLIN(I:I).NE.' ').AND.(K .EQ. 0)) K = I
50    CONTINUE
      IF (CTEXT .EQ. 'I') THEN
C TOP LEVEL  -  INSTRUCTION
           WRITE (IUNIT2, '(A)') '/left leftmargin def '
           WRITE (IUNIT7, '(A)') '/left leftmargin def '
           ILEFT = ILEFTM + INDENT
      ELSE IF (CTEXT .EQ. 'D') THEN
           WRITE (IUNIT2, '(A)') '/left leftmargin indent add def '
           WRITE (IUNIT7, '(A)') '/left leftmargin indent add def '
           ILEFT = ILEFTM + INDENT * 2
      ELSE IF (CTEXT .EQ. 'K') THEN
           WRITE (IUNIT2, '(A)') '/left leftmargin indent add indent'
     1     //' add def'
           WRITE (IUNIT7, '(A)') '/left leftmargin indent add indent'
     1     //' add def'
           ILEFT = ILEFTM + INDENT * 3
      ELSE IF (CTEXT .EQ. 'Q') THEN
           WRITE (IUNIT2, '(A)') '/left leftmargin indent add'//
     *  ' indent'
           WRITE (IUNIT7, '(A)') '/left leftmargin indent add'//
     *  ' indent'
           WRITE (IUNIT2, '(A)') 'add indent add def'
           WRITE (IUNIT7, '(A)') 'add indent add def'
           ILEFT = ILEFTM + INDENT * 4
      ENDIF
      IF (CINLIN(K:K) .EQ. CHASH) K = K - 1
      CALL XCCHECK (CINLIN, CL, 3, K)
      RLINE = RLINE + 1
      IF (RLINE .GE. LINES) THEN
           RLINE = 1
           IPAGE = IPAGE + 1
           CALL XNEWP (1)
      ENDIF
      WRITE (IUNIT3, 100) IPAGE
      WRITE (IUNIT3, '(A)') CL(1:K)
100   FORMAT ('I', I4)
      COUTLN = '/instr (' // CL(1:K) // ') def Instruction'
      WRITE (IUNIT2, '(A)') COUTLN
      WRITE (IUNIT7, '(A)') COUTLN
C CHECK NEXT LINE FOR PARAGRAPHS
      READ (IUNIT1, '(A80)',IOSTAT=IOS) CINLIN
cdjwdec07
      call rtidy(cinlin)
c
      IF (IOS .NE. 0) CINLIN=' '
      INFLAG = 1
      IF (CINLIN(1:2) .EQ. '#P') THEN
           C = ' ' // CINLIN(3:80) // ' '
           CINLIN = C
           IPFLAG = 0
           CALL XJUST (IPFLAG, INFLAG, PRATIO)
      ENDIF
      RETURN
      END
CODE FOR XLITER
      SUBROUTINE XLITER (PRATIO)
C This means that we do not justify these lines.
      INCLUDE 'paginate.inc'
      CHARACTER * 300 CL
C WE NEED TO GET THE POINT SIZE
      ICPT = IJPNT
      IF (CINLIN(1:5).NE.'#J   ') THEN
           READ (CINLIN(3:5),  '(I3)', ERR = 50) IDJW
50         CONTINUE
       IF ((IDJW .LE. 0 ) .OR. (IDJW .GE. 20)) THEN
       WRITE(* ,'(A,i6)') 'Unreasonable font size on #J line',
     1  IDJW
       ELSE
        ICAPT = IDJW
       ENDIF
      ENDIF
      WRITE (IUNIT2, '(A)') '/left leftmargin def '
      WRITE (IUNIT7, '(A)') '/left leftmargin def '
C--- SAVE LEFT MARGIN
      ILEFTS = ILEFT
      ILEFT = ILEFTM
C WE NEED TO CHANGE THE LINEGAP
C----- SAVE THE LINEGAP ETC
      LGAPS = LLNGAP
      RLSAV = RLSTEP
      LLNGAP = ILNGAP * ICPT / IMPNT
      RLSTEP = REAL(ICPT) / IMPNT
C SET THE LITERAL POINT SIZE
      WRITE (IUNIT2, '(A, I5, A)') '/litpoint ', ICPT, ' def '
      WRITE (IUNIT2, '(A, I5, A)') '/litgap ', LLNGAP, ' def '
      WRITE (IUNIT7, '(A, I5, A)') '/litpoint ', ICPT, ' def '
      WRITE (IUNIT7, '(A, I5, A)') '/litgap ', LLNGAP, ' def '
C      NN  =  (IRIGHT - ILEFT)  /  7.2  *  (ICPT / IMPNT)
      IF (RLINE .GT. 0) THEN
           RLINE = RLINE + RLSTEP
           WRITE (IUNIT2, '(5A)') 'LitBlank'
           WRITE (IUNIT7, '(5A)') 'LitBlank'
      ENDIF
      READ (IUNIT1, '(A80)',IOSTAT=IOS) CINLIN
cdjwdec07
      call rtidy(cinlin)
c
      IF (IOS .NE. 0) CINLIN=' '
C Reset the x position
C NEED TO FIT ALL THE LINES ON THE SAME PAGE  -  WE NEED TO FIND OUT HOW
C MANY LINES THERE ARE
C      N  =  0
C50    N  =  N  +  1
C      READ (IUNIT1, '(A80)',IOSTAT=IOS) CINLIN
C      IF (IOS .NE. 0) CINLIN=' '
C      IF (CINLIN(1:1).NE.CHASH) GOTO 50
C NOW BACKSPACE TO THE BEGINNING
C      DO 30 I  =  1 ,  N
C        BACKSPACE (UNIT = 1)
C30    CONTINUE
C      IF ((rline + N .GT. LINES).AND.(N .LT. LINES)) THEN
C DO A PAGE THROW
C        WRITE (IUNIT2, '(8A)') 'Newpage'
C        WRITE (IUNIT7, '(8A)') 'Newpage'
C        rline  =  0
C      ENDIF
100   CONTINUE
C Find the last non blank character
      K = 0
      DO 150 I = 80, 1,  - 1
           IF ((CINLIN(I:I).NE.' ').AND.(K .EQ. 0)) K = I
150   CONTINUE
C      IF (K .GT. NN) THEN
C        WRITE (IUNIT6, 21) NN
C21      FORMAT ('WARNING : LITERAL EXCEEDS PAGE WIDTH ', I4)
C        WRITE (IUNIT6,  * ) CINLIN
C      ENDIF
      IF (CINLIN(1:1).NE.CHASH) THEN
           IF (K.NE.0) THEN
                RLINE = RLINE + RLSTEP
                IF (RLINE .GE. LINES) THEN
                     IPAGE = IPAGE + 1
                     RLINE = 1.0
                     CALL XNEWP (1)
                ENDIF
                WRITE (IUNIT2, '(A)') '/litstring '
                WRITE (IUNIT7, '(A)') '/litstring '
                CALL XCCHECK (CINLIN, CL, 1, K)
                WRITE (COUTLN, '(3A)') '(', CL(1:K), ') def Literal'
                WRITE (IUNIT2, '(A)') COUTLN
                WRITE (IUNIT7, '(A)') COUTLN
           ELSE
                CALL XBLANK (INFLAG, PRATIO)
           ENDIF
      ENDIF
      READ (IUNIT1, '(A80)',IOSTAT=IOS) CINLIN
cdjwdec07
      call rtidy(cinlin)
c
      IF (IOS .NE. 0) CINLIN=' '
      IF (CINLIN(1:1).NE.CHASH) GO TO 100
      IF (RLINE.LE.LINES) THEN
           RLINE = RLINE + 1
           WRITE (IUNIT2, '(5A)') 'LitBlank'
           WRITE (IUNIT7, '(5A)') 'LitBlank'
      ENDIF
C----- RESTORE THE GOODIES
      ILEFT = ILEFTS
      LLNGAP = LGAPS
      RLSTEP = RLSAV
      RETURN
      END
CODE FOR BLANK
      SUBROUTINE XBLANK (INFLAG, PRATIO)
      INCLUDE 'paginate.inc'
      CHARACTER * 80 C
C ARE THERE ANY OTHER CHARACTERS ON THE LINEC
      K = 0
      DO 50 I = 80, 3,  - 1
           IF (CINLIN(I:I).NE.' ') K = 1
50    CONTINUE
      IF (K .EQ. 1) THEN
C WE HAVE A LINE
           C = ' ' // CINLIN(3:80) // ' '
           CINLIN = C
           IPFLAG = 0
           CALL XJUST (IPFLAG, INFLAG, PRATIO)
      ELSE
           RLINE = RLINE + 1
           IF (RLINE .GE. LINES) THEN
                RETURN
           ENDIF
           WRITE (IUNIT2, '(A)') 'Blank'
           WRITE (IUNIT7, '(A)') 'Blank'
      ENDIF
      RETURN
      END
CODE FOR XCCHECK
      SUBROUTINE XCCHECK (CIN, COUT, IA, IB)
C----- REMOVE SPURIOUS CHARACTERS, AND INSERT MARKER FOR SPECIALS
      INCLUDE 'paginate.inc'
      CHARACTER * ( * ) CIN
      CHARACTER * 300 COUT
C LOOP OVER THE LINE
      N = 0
      COUT = ' '
      DO 50 I = IA, IB
           IC = ICHAR(CIN(I:I))
C----      SET WEIRD CHARACTERS TO 'SPACE'
           IF ((IC .LT. 32).OR.(IC .GT. 126)) IC = 35
C SPECIAL CHARACTERS HAVE -VE WIDTH
            IF (CWIDTH(IC - 31) .LT. 0.0) THEN
                  N = N+1
                  COUT(N:N) = '\'
            ENDIF
            N = N+1
            COUT(N:N) = CIN(I:I)
50    CONTINUE
      IB = N
      RETURN
      END
C
CODE FOR XNEWP
      SUBROUTINE XNEWP (ITYPE)
      INCLUDE 'paginate.inc'
C NEWPAGE FLAG
      IF (ITYPE .EQ. 2) THEN
           READ (CINLIN, '(2X, I4)') NUM
           IF (RLINE + NUM .GE. LINES) THEN
C FORCE A NEWPAGE
                IPAGE = IPAGE + 1
                RLINE = 0
                WRITE (IUNIT2, '(8A)') 'Newpage'
                WRITE (IUNIT7, '(8A)') 'Newpage'
           ENDIF
      ELSE
           WRITE (IUNIT2, '(8A)') 'Newpage'
           WRITE (IUNIT7, '(8A)') 'Newpage'
      ENDIF
      RETURN
      END
CODE FOR XDOIND
C THIS ROUTINE PROCESSES THE INDEX FILE TO GIVE AND INDEX AND A TABLE OF
C CONTENTS
      SUBROUTINE XDOIND
C FIRST READ IN THE NUMBERS AND THE ENTRY TEXT AND TYPES
CDJW   NUMBER OF COLUMNS IN INDEX
      PARAMETER(NINCOL = 2)
      PARAMETER (NINDEX = 2000)
CDJW      CHARACTER * 40 CINDEX(1000), CMIN, CIND
      PARAMETER (LINDEX=60)
      CHARACTER *60 CINDEX(2000), CMIN, CIND
      CHARACTER * 1 CTYPE, A, B
      INTEGER PINDEX(2000), ICTYPE(2000), PCHAP(2000)
      INCLUDE 'paginate.inc'
      OPEN (UNIT = IUNIT3, FILE = 'INDEX.TMP', STATUS = 'OLD')
      IIPOS = 0
      IPPAGE = 0
      IPNO = 0
50    CONTINUE
      IIPOS = IIPOS + 1
      IF (IIPOS .GE. NINDEX) STOP 'Index Overflow'
      READ (IUNIT3, 100, END = 250) CTYPE, PINDEX(IIPOS), PCHAP(IIPOS)
      READ (IUNIT3, 150) CINDEX(IIPOS)
100   FORMAT (A1, 2I4)
C----- FORMAT MUST BE A'LINDEX'
150   FORMAT (A60)
      IF (CTYPE .EQ. 'C') ICTYPE(IIPOS) = 1
      IF (CTYPE .EQ. 'S') ICTYPE(IIPOS) = 2
      IF (CTYPE .EQ. 'I') then
                          ICTYPE(IIPOS) = 3
C NEED TO CHECK FOR DUPLICATION WITHIN A PAGE
            IF (IPNO .LT. PINDEX(IIPOS)) THEN
                 IPPAGE = IIPOS
                 IPNO = PINDEX(IIPOS)
                 GO TO 50
            ENDIF
            IF (IPPAGE .EQ. IIPOS) GO TO 50
            DO 200 J = IPPAGE, IIPOS - 1
                 IF ((CINDEX(J) .EQ. CINDEX(IIPOS)) .and.
     1              (ictype(J) .EQ. ictype(IIPOS))) THEN
                      IIPOS = IIPOS - 1
                      IF (IIPOS .LE. 0) STOP 'Index Undeflow'
                      GO TO 50
                 ENDIF
200         CONTINUE
      endif
      GO TO 50
250   CONTINUE
C DO THE INDEX
      WRITE (IUNIT2, '(8A)') 'Doindex'
      WRITE (IUNIT7, '(8A)') 'Doindex'
C !!!! LJP need to write out /indexflag 3 def here for one column index
      IF (NINCOL .EQ. 1 ) WRITE (IUNIT2, '(A)') '/indexflag 3 def '
      IF (NINCOL .EQ. 1 ) WRITE (IUNIT7, '(A)') '/indexflag 3 def '
      IPREV = 0
C WE NEED TO LOOP OVER THE RESULTS
      DO 450 I = 1, IIPOS
           CMIN = 'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
           IIND = 0
           DO 300 J = 1, IIPOS
                IF (ICTYPE(J).NE.3) GO TO 300
                CIND = CINDEX(J)
c                CALL UPCASE@ (CIND)
                IF (CIND .LT. CMIN) THEN
                     CMIN = CIND
                     IIND = J
                ENDIF
300        CONTINUE
           IF (IIND .EQ. 0) GO TO 500
           WRITE (IUNIT2, 550) PINDEX(IIND)
           WRITE (IUNIT7, 550) PINDEX(IIND)
           JJ = 0
C FIND THE END OF THE WORD
           DO 350 J = LINDEX, 1,  - 1
                IF (CINDEX(IIND)(J:J).NE.' ') THEN
                     JJ = J
                     GO TO 400
                ENDIF
350        CONTINUE
400        CONTINUE
C-----   CHECK THE STRING LENGTH FOR 2 COLUMNS
           IF (NINCOL .EQ. 2) JJ = MIN0(40,JJ)
C !!!!! LJP
C Check for the final character being an escape \. This may happen
C because CINDEX is only LINDEX characters long but the LINDEX+1st character 
C could need escaping in the main document.
           IF (CINDEX(IIND)(JJ:JJ) .EQ. '\') THEN
CDJW                IF (JJ .GT. 1.AND.CINDEX(IIND)(JJ - 1:JJ - 1).NE.'\') 
CDJW     *          JJ = JJ - 1
                    CINDEX(IIND)(JJ:JJ) = ' '
           ENDIF
c           IF (JJ .GT.1)
c     1     CALL LCASE@(CINDEX(IIND)(2:JJ))
           WRITE (IUNIT2, 650) CINDEX(IIND)(1:JJ)
           WRITE (IUNIT7, 650) CINDEX(IIND)(1:JJ)
           IF (IPREV.NE.0) THEN
                A = CINDEX(IPREV)(1:1)
                B = CINDEX(IIND)(1:1)
c                CALL UPCASE@ (A)
c                CALL UPCASE@ (B)
                IF (A.NE.B) THEN
                     WRITE (IUNIT2, '(5A)') 'Blank'
                     WRITE (IUNIT7, '(5A)') 'Blank'
                ENDIF
           ENDIF
           IPREV = IIND
           WRITE (IUNIT2, '(5A)') 'Index'
           WRITE (IUNIT7, '(5A)') 'Index'
           ICTYPE(IIND) =  - ICTYPE(IIND)
450   CONTINUE
500   CONTINUE
C NOW DO THE banner and CONTENTS PAGE
      WRITE (IUNIT2, '(6A)') 'Banner'
      WRITE (IUNIT2, '(10A)') 'Docontents'
      WRITE (IUNIT7, '(6A)') 'Banner'
      WRITE (IUNIT7, '(10A)') 'Docontents'
C NOW LOOP TO FIND ENTRIES FOR THE CONTENTS PAGE
      DO 700 I = 1, IIPOS
           IF (ICTYPE(I) .EQ. 1) THEN
C CHAPTER ENTRY
550             FORMAT ('/Indexpage ', I4, ' def')
                WRITE (IUNIT2, 550) PINDEX(I)
                WRITE (IUNIT2, 600) PCHAP(I)
                WRITE (IUNIT7, 550) PINDEX(I)
                WRITE (IUNIT7, 600) PCHAP(I)
600             FORMAT ('/chapno ', I4, ' def')
                WRITE (IUNIT2, 650) CINDEX(I)
                WRITE (IUNIT2, '(A)') 'Indexchapter'
                WRITE (IUNIT7, 650) CINDEX(I)
                WRITE (IUNIT7, '(A)') 'Indexchapter'
           ELSE IF (ICTYPE(I) .EQ. 2) THEN
C SECTION ENTRY
                WRITE (IUNIT2, 550) PINDEX(I)
                WRITE (IUNIT7, 550) PINDEX(I)
650             FORMAT ('/Indextext (', A, ') def')
                WRITE (IUNIT2, 650) CINDEX(I)
                WRITE (IUNIT2, '(A)') 'Indexsection'
                WRITE (IUNIT7, 650) CINDEX(I)
                WRITE (IUNIT7, '(A)') 'Indexsection'
           ENDIF
700   CONTINUE
      WRITE (IUNIT2, '(11A)') 'Endcontents'
      WRITE (IUNIT7, '(11A)') 'Endcontents'
      RETURN
      END

      BLOCK DATA DOCBLK
      INCLUDE 'paginate.inc'
      DATA CWIDTH / 3.0,4.0,4.9,6.0,6.0,10.0,9.34,4.0,-4.0,-4.0,6.0
C                        !   "   #   $    %    &   '    (    )   *
     c             ,6.78,3.0,4.0,3.0,-3.34,6.0,6.0,6.0,6.0,6.0,6.0
C                    +    ,   -   .    /    0   1   2   3   4   5
     c             ,6.0,6.0,6.0,6.0,3.34,3.34,6.77,6.77,6.77
C                    6   7   8   9   :    ;    <    =    >
     c             ,5.33,11.05,8.66,8.0,8.0,8.66,7.33,6.67,8.66
C                    ?     @    A    B   C   D    E    F    G
     c             ,8.66,4.0,4.67,8.66,7.33,10.67,8.66,8.66,6.67
C                    H    I   J    K    L     M    N    O    P
     c             ,8.66,8.0,6.67,7.33,8.66,8.66,11.32,8.66,8.66
C                    Q    R   S    T    U    V     W    X    Y
     c             ,7.33,4.0,-3.34,4.0,5.63,6.0,3.0,5.33,6.0,5.33
C                    Z    [    \    ]   ^    _   '   a    b   c
     c             ,6.0,5.33,4.0,6.0,6.0,3.34,3.34,6.0,3.34,9.34
C                    d   e    f   g   h   i    j    k   l    m
     c             ,6.0,6.0,6.0,6.0,4.0,4.67,3.34,6.0,6.0,8.67
C                    n   o   p   q   r   s    t    u   v   w
     c             ,6.0,6.0,5.33,-5.76,3.34,-5.76,4.90/
C                    x   y   z     {          }    ~
      DATA IUNIT1 / 10 / , IUNIT2 / 12 / , IUNIT3 / 13 / , IUNIT4 / 14 /
     *  , IUNIT5 / 5 / , IUNIT6 / 6 / , iunit7 /7/, isection/0/
      END
CODE FOR XCCUPC
      SUBROUTINE XCCUPC ( CLOWER , CUPPER )
C -- CONVERT STRING TO UPPERCASE
C      CLOWER      SOURCE STRING TO BE CONVERTED
C      CUPPER      RESULTANT STRING
      CHARACTER*(*) CLOWER , CUPPER
      CHARACTER*26 CALPHA , CEQUIV
      DATA CALPHA / 'abcdefghijklmnopqrstuvwxyz' /
      DATA CEQUIV / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
C -- MOVE WHOLE STRING.
C-ASSIGNING LOWER TO UPPER IS FORMALLY INVALID
C      CUPPER = CLOWER
      READ(CLOWER,'(A)') CUPPER
      LENGTH = MIN0 ( LEN ( CLOWER ) , LEN ( CUPPER ) )
C -- SEARCH FOR LOWERCASE CHARACTERS AND CONVERT TO UPPERCASE
      DO 2000 I = 1 , LENGTH
        IPOS = INDEX ( CALPHA , CLOWER(I:I) )
        IF ( IPOS .GT. 0 ) CUPPER(I:I) = CEQUIV(IPOS:IPOS)
2000  CONTINUE
      RETURN
      END
C
CODE FOR XCCLWC
      SUBROUTINE XCCLWC ( CSOURC, CLOWER )
C -- CONVERT STRING TO LOWERCASE
C      CSOURC      SOURCE STRING TO BE CONVERTED
C      CLOWER      RESULTANT STRING
      CHARACTER*(*) CSOURC,  CLOWER
      CHARACTER*26 CALPHA , CEQUIV
      DATA CALPHA / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
      DATA CEQUIV / 'abcdefghijklmnopqrstuvwxyz' /
C -- MOVE WHOLE STRING.
C-ASSIGNING LOWER TO UPPER IS FORMALLY INVALID
C      CLOWER = CSOURC
      READ(CSOURC,'(A)') CLOWER
      LENGTH = MIN0 ( LEN ( CSOURC) , LEN ( CLOWER ) )
C -- SEARCH FOR UPPERCASE CHARACTERS AND CONVERT TO LOWERCASE
      DO 2000 I = 1 , LENGTH
        IPOS = INDEX ( CALPHA , CSOURC(I:I) )
        IF ( IPOS .GT. 0 ) CLOWER(I:I) = CEQUIV(IPOS:IPOS)
2000  CONTINUE
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
CODE FOR RTIDY
      SUBROUTINE RTIDY(CINLIN)
      CHARACTER*80 CINLIN
      DO 100 I=1,80
        IF (CINLIN(i:i) .eq. '#') then
            if(cinlin(i+1:i+1) .eq. 'R') then
            write(*,*)  cinlin
                  do 200 j =i+1,80
                        if(cinlin(j:j) .eq. '#') then 
                              goto 250
                        endif
200               continue
                  j = 80
250               continue
      write(*,*) 'index=', i, j
                  if (i .eq. 3) then
c                 clear whole string
                    do 300 k =i,j
                        cinlin(k:k) = ' '
300                 continue
                  else
c                 just remove markups
      write(*,*) 'remove markups'
                    cinlin(i:i) = ' '
                    cinlin(i+1:i+1) = ' '
                    cinlin(j:j) = ' '
                  endif
            write(*,*)  cinlin
            endif
        endif
100   continue
      return
      end
