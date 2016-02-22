C $Log: not supported by cvs2svn $
C Revision 1.10  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.9  2009/07/08 14:18:16  djw
C Improve creation of format statement to handle FP numbers over a wide range of values
C
C Revision 1.8  2009/07/02 09:18:11  djw
C New subroutine DFORM which tries to create a suitable format statement to cover large
C  range of values taking intomaccount the limited precission of 32bit floats
C
C Revision 1.7  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:07  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.6  2002/02/20 14:32:02  ckp2
C New function KCLNEQ searches a string for last occurence of a string that doesn't
C match. KCLNEQ(STRING,47,' ') returns the last non-space before position 47 in STRING.
C
C Revision 1.5  2000/12/05 12:36:42  CKP2
C Reformat FORMAT statements
C
C Revision 1.4  1999/05/13 17:54:58  dosuser
C RIC: Added new function KCLEQL to find the last occurence of
C      a substring in a string. Complements KCCEQL.
C

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

CODE FOR KCLEQL
      FUNCTION KCLEQL ( CDATA , CMATCH )
C
C -- LOCATE LAST SUBSTRING IN STRING
C
C -- THIS FUNCTION IS SIMILAR TO FORTRAN 'INDEX' BUT BACKWARDS
C
C      CDATA       STRING IN WHICH TO SEARCH
C      CMATCH      STRING TO SEARCH FOR
C
C      KCLEQL      -1      NO MATCH
C                  +VE     POSITION IN 'CDATA' OF CMATCH
C
C
      CHARACTER*(*) CDATA , CMATCH
C
C
      KCLEQL = -1
C
      LENMAT = LEN ( CMATCH )
      LENDAT = LEN ( CDATA )
      IFINSH = LENDAT - LENMAT

100   CONTINUE
      IF ( IFINSH .GT. 0 ) THEN
         IPOS = INDEX ( CDATA(IFINSH:IFINSH+LENMAT), CMATCH )
         IF ( IPOS .GT. 0 ) THEN
            KCLEQL = IPOS + IFINSH - 1
            RETURN
         END IF
         IFINSH = IFINSH - 1
         GOTO 100
      ENDIF

      RETURN
      END
C
C
C
C
C
CODE FOR KCCNEQ
      FUNCTION KCCNEQ ( CDATA , ISTART , CMATCH )
C
C -- FIND FIRST POSITION IN STRING NOT CORRESPONDING TO SUBSTRING
C
C -- THIS FUNCTION IS SIMILAR TO FORTRAN 'INDEX'
C
C      CDATA       STRING IN WHICH TO SEARCH
C      ISTART      STARTING POSITION IN 'CDATA'
C      CMATCH      STRING TO SEARCH FOR ( USUALLY LENGTH = 1 )
C
C      KCCNEQ      -1      NO MATCH
C                  +VE     POSITION IN 'CDATA' OF FIRST MISMATCH
C
C
      CHARACTER*(*) CDATA , CMATCH
C
C
      KCCNEQ = -1
C
      LENMAT = LEN ( CMATCH )
      LENDAT = LEN ( CDATA )
      IFINSH = LENDAT - LENMAT + 1
C
      IF ( ISTART .LE. 0 ) RETURN
      IF ( ISTART .GT. IFINSH ) RETURN
C
      DO 1100 I = ISTART , IFINSH
        IF ( CDATA(I:I+LENMAT-1) .EQ. CMATCH ) GO TO 1100
        KCCNEQ = I
        RETURN
1100  CONTINUE
C
      RETURN
      END
C
C
CODE FOR KCLNEQ
      FUNCTION KCLNEQ ( CDATA , ISTART , CMATCH )
C
C -- FIND LAST POSITION IN STRING NOT CORRESPONDING TO CHARACTER
C
C -- THIS FUNCTION IS SIMILAR TO FORTRAN 'INDEX' BUT BACKWARDS
C
C      CDATA       STRING IN WHICH TO SEARCH
C      ISTART      STARTING POSITION IN 'CDATA' (near end), or -ve for END.
C      CMATCH      STRING TO SEARCH FOR ( ALWAYS LENGTH = 1 )
C
C      KCLNEQ      -1      NO MATCH
C                  +VE     POSITION IN 'CDATA' OF LAST MISMATCH
C
C
      CHARACTER*(*) CDATA
      CHARACTER*1   CMATCH
C
C
      KCLNEQ = -1
      ISTR = ISTART
C
      LENDAT = LEN ( CDATA )
      IFINSH = LENDAT
C
      IF ( ISTR .EQ. 0 ) RETURN
      IF ( ISTR .LT. 0 ) ISTR = IFINSH
      IF ( ISTR .GT. IFINSH ) RETURN
C
      DO 1100 I = ISTR, 1, -1
        IF ( CDATA(I:I) .NE. CMATCH ) THEN
          KCLNEQ = I
          RETURN
        END IF
1100  CONTINUE
C
      RETURN
      END
C
C
C
C
C
CODE FOR KCCARG
      FUNCTION KCCARG ( CINPUT , ISTART , IFUNC , IPOS1 , IPOS2 )
C
C -- IDENTIFY NEXT ARGUMENT FROM CHARACTER INPUT
C
C      CINPUT      INPUT STRING
C      ISTART      STARTING POSITION IN CINPUT ( ISTART IS UPDATED BY
C                  THIS ROUTINE TO POINT TO NEXT NON-SPACE CHARACTER
C                  AFTER ARGUMENT FOUND )
C      IFUNC       FUNCTION REQUIRED
C                    1      ARGUMENT DELIMITTED BY SPACES
C                    2      ARGUMENT DELIMITTED BY NEXT NON-SPACE
C                           CHARACTER
C                    3      ARGUMENT DELIMITTED BY SPACE, OR COMMA
C                           FOLLOWED BY NON-SPACE CHARACTER
C
C      IPOS1       STARTING POSITION OF ARGUMENT FOUND
C      IPOS2       END OF ARGUMENT FOUND
C
C      KCCARG      -VE      NO ARGUMENT
C                  +VE      LENGTH OF ARGUMENT FOUND
C
C
C
      CHARACTER*(*) CINPUT
      CHARACTER*1 CDEL2
C
      KCCARG = -1
      IF ( ISTART .GT. LEN ( CINPUT ) ) RETURN
C
      IPOS1 = KCCNEQ ( CINPUT , ISTART , ' ' )
      IF ( IPOS1 .LE. 0 ) RETURN
C
      IF ( IFUNC .EQ. 1 ) THEN
        IPOS2 = KCCEQL ( CINPUT , IPOS1 , ' ' )
      ELSE IF ( IFUNC .EQ. 2 ) THEN
        CDEL2 = CINPUT(IPOS1:IPOS1)
        IPOS2 = KCCEQL ( CINPUT , IPOS1 + 1 , CDEL2 )
        IPOS1 = IPOS1 + 1
      ELSE IF ( IFUNC .EQ. 3 ) THEN
      ICOMMA = KCCEQL ( CINPUT , IPOS1 , ',' )
      IF ( ICOMMA .LE. 0 ) ICOMMA = LEN ( CINPUT ) + 1
      ISPACE = KCCEQL ( CINPUT , IPOS1 , ' ' )
      IF ( ISPACE .LE. 0 ) ISPACE = LEN ( CINPUT ) + 1
        IPOS2 = MIN0 ( ICOMMA , ISPACE )
C -- IF ',' WAS THE DELIMITTER, CHECK THAT IT IS FOLLOWED BY ANOTHER
C    ARGUMENT
        IF ( IPOS2 .EQ. ICOMMA ) THEN
          IF ( KCCNEQ ( CINPUT , IPOS2 + 1 , ' ' ) .LE. 0 ) RETURN
        ENDIF
      ENDIF
C
      IF ( IPOS2 .LE. 0 ) RETURN
C
      ISTART = KCCNEQ ( CINPUT , IPOS2 + 1 , ' ' )
      IPOS2 = IPOS2 - 1
C
C
      KCCARG = IPOS2 - IPOS1 + 1
      RETURN
      END
C
C
C
C
C
CODE FOR KCCOMP
      FUNCTION KCCOMP ( CMATCH , CKEYS , NKEYS , IEXACT )
C
C -- MATCH CHARACTER STRINGS
C
C      CMATCH      STRING TO BE MATCHED
C      CKEYS       CHARACTER ARRAY OF STRINGS TO BE MATCHED WITH
C      NKEYS       NUMBER OF KEYS
C      IEXACT      MATCH TYPE
C                    1      EXACT MATCH
C                    2      FIRST ABBREVIATED MATCH
C                    3      UNAMBIGUOUS ABBREVIATED MATCH
C
C
C      KCCOMP      +VE      POSITION IN 'CKEYS' OF MATCHED STRING
C                  -VE      NO MATCH
C
C
      CHARACTER*(*) CMATCH
      CHARACTER*(*) CKEYS(NKEYS)
C
C
      LENMAT = LEN ( CMATCH )
      LENKEY = LEN ( CKEYS(1) )
C
C
      IF ( IEXACT .EQ. 1 ) THEN
        IF ( LENMAT .GT. LENKEY ) GO TO 9900
        LENMAT = MIN0 ( LENMAT , LENKEY )
      ELSE IF ( ( IEXACT .EQ. 2 ) .OR. ( IEXACT .EQ. 3 ) ) THEN
        IF ( LENMAT .GT. LENKEY ) GO TO 9900
        LENKEY = MIN0 ( LENMAT , LENKEY )
      ENDIF
C
      NMATCH = 0
      LMATCH = 0
C
      DO 2000 I = 1 , NKEYS
        IF ( CMATCH(1:LENMAT) .NE. CKEYS(I)(1:LENKEY) ) GO TO 2000
C
        LMATCH = I
        IF ( IEXACT .EQ. 3 ) THEN
          IF ( NMATCH .GT. 0 ) GO TO 9910
        ELSE
          GO TO 9000
        ENDIF
        NMATCH = NMATCH + 1
2000  CONTINUE
C
      IF ( NMATCH .EQ. 1 ) GO TO 9000
      GO TO 9900
C
C
9000  CONTINUE
      KCCOMP = LMATCH
      RETURN
C
C
9900  CONTINUE
9910  CONTINUE
      KCCOMP = -1
      RETURN
C
C
      END
C
C
C
C
C
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
      LENGTH = MIN0 ( LEN ( CLOWER ) , LEN ( CUPPER ) )

      IF ( LENGTH .LE. 0 ) THEN
        RETURN
      END IF
      
      READ(CLOWER,'(A)') CUPPER
C
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
C
C
C
C
C
C
CODE FOR XCCLWC
      SUBROUTINE XCCLWC ( CSOURC, CLOWER )
C
C -- CONVERT STRING TO LOWERCASE
C
C      CSOURC      SOURCE STRING TO BE CONVERTED
C      CLOWER      RESULTANT STRING
C
C
      CHARACTER*(*) CSOURC,  CLOWER
C
      CHARACTER*26 CALPHA , CEQUIV
C
      DATA CALPHA / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
      DATA CEQUIV / 'abcdefghijklmnopqrstuvwxyz' /
C
C
C -- MOVE WHOLE STRING.
C-ASSIGNING LOWER TO UPPER IS FORMALLY INVALID
C      CLOWER = CSOURC
      READ(CSOURC,'(A)') CLOWER
C
      LENGTH = MIN0 ( LEN ( CSOURC) , LEN ( CLOWER ) )
C
C -- SEARCH FOR UPPERCASE CHARACTERS AND CONVERT TO LOWERCASE
      DO 2000 I = 1 , LENGTH
        IPOS = INDEX ( CALPHA , CSOURC(I:I) )
        IF ( IPOS .GT. 0 ) CLOWER(I:I) = CEQUIV(IPOS:IPOS)
2000  CONTINUE
C
C
      RETURN
      END
C
CODE FOR KHKIBM
      FUNCTION KHKIBM (CSOURC)
C----- REMOVE ANY NULL CHARACTERS AND LEFT ADJUST THE REMAINDER
      CHARACTER *1 CNULL, CBUFF
      CHARACTER *(*) CSOURC
      KHKIBM = 0
      CNULL = CHAR(0)
      K = LEN (CSOURC)
      IF (K .GE. 1 ) THEN
        J = 0
        DO 20 I = 1,K
          CBUFF = CSOURC(I:I)
          IF ( CBUFF .NE. CNULL) THEN
            J = J + 1
            CSOURC(J:J) = CBUFF
          ENDIF
20      CONTINUE
        IF (J+1 .LE. K) CSOURC(J+1:K) = ' '
      ENDIF
      RETURN
      END
C
C
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
C
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
CODE FOR XCSHR 
      SUBROUTINE XHSHR (A, COUT)
C     SHIFT A HOLLERITH REPRESENTAION TO RIGHT OF WORD
      CHARACTER *4 COUT, CTEMP
            WRITE(CTEMP(1:4) ,'(A4)') A
            COUT = ' '
            J = INDEX (CTEMP(1:4), ' ')
            IF (J .GT. 1 )THEN
                  COUT(6-J:4) = CTEMP(1:J-1)
            ELSE
                  COUT = CTEMP
            ENDIF
            READ(COUT, '(A4)') A
      RETURN
      END
C
CODE FOR KGTNUM
      FUNCTION KGTNUM( CTEXT, CTERM, NCHAR)
C
C----- GET AN INTEGER NUMBER FROM A TEXT STRING
C
C      CTEXT TEXT STRING
C      CTERM TERMINATOR FOUND
C      NCHAR NUMBER OF CHARACTERS IN NUMBER
C
      CHARACTER *(*) CTEXT
      CHARACTER *1 CTERM
C      CHARACTER *9 CNUM
      CHARACTER *10 CNUM
      INCLUDE 'XUNITS.INC'
C
C      DATA CNUM / '123456789' /
      DATA CNUM / '0123456789' /
C
      LENGTH = LEN (CTEXT)
      KGTNUM = 0
      NCHAR = 0
      CTERM = ' '
C
      DO 1000 I = 1, LENGTH
C      IVAL = INDEX (CNUM, CTEXT(I:I))
      IVAL = INDEX (CNUM, CTEXT(I:I)) - 1
C      IF (IVAL .GT. 0) THEN
      IF (IVAL .GE. 0) THEN
            KGTNUM = 10 * KGTNUM + IVAL
            NCHAR = NCHAR + 1
      ELSE
            CTERM = CTEXT(I:I)
            GOTO 1200
      ENDIF
1000  CONTINUE
1200  CONTINUE
      RETURN
      END
C
C
CODE FOR KCCNUM
      FUNCTION KCCNUM ( CINPUT , IRESLT , ITYPE )
C
C -- CONVERT STRING TO NUMERIC VALUE IF POSSIBLE
C
C      CINPUT      STRING TO BE CONVERTED
C      IRESLT      RESULT OF CONVERSION ( MAY BE REAL OR INTEGER )
C      ITYPE       TYPE OF NUMBER
C                    1      INTEGER
C                    2      REAL
C
C      KCCNUM      SUCCESS/FAILURE
C                    -1      FAILURE
C                    +1      SUCCESS
C
      CHARACTER*(*) CINPUT
      CHARACTER*11 CNUMER
      CHARACTER *1 CDOT
      CHARACTER*12 CBUFF1
      CHARACTER*20 CBUFF2
C
      PARAMETER (CDOT = '.')
      PARAMETER ( CNUMER = '0123456789.' )
C
      EQUIVALENCE ( XVALUE , IVALUE )
C
      KCCNUM = -1
      LENC = LEN (CINPUT)
C
C----- LOOK FOR A DECIMAL POINT, SINCE IBM COMPILERS STILL DONT STOP
C      EXECUTION ON A READ ERROR
      IF ( INDEX ( CNUMER , CINPUT(1:1) ) .LE. 0 ) RETURN
      IF ( INDEX ( CINPUT , CDOT ) .GT. 0 ) GOTO 1100
C
C----- TRY AS INTEGER
      ITYPE = 1
      CBUFF1 = CINPUT
      READ ( CBUFF1 , '(BN,I12)' , ERR = 1100 ) IVALUE
C
      IRESLT = IVALUE
      KCCNUM = 1
      RETURN
C
C----- TRY AS REAL
1100  CONTINUE
      ITYPE = 2
      CBUFF2 = CINPUT
      READ ( CBUFF2 , '(BN,F20.0)' , ERR = 1200 ) XVALUE
      CALL XMOVEI ( IVALUE , IRESLT , 1 )
      KCCNUM = 1
      RETURN
C
1200  CONTINUE
      RETURN
C
C
      END
C
C
C
C
C
CODE FOR KCCINT
      FUNCTION    KCCINT (CTEXT, IVALUE)
C
C -- CONVERT TEXT TO INTEGER VALUE
C
C*************** MACHINE OR COMPILER SENSITIVE ********************
C
C      CTEXT       TEXT TO BE CONVERTED ( UP TO 20 CHARACTERS )
C      IVALUE      RESULTANT VALUE
C
C      KCCINT      -1      FAILURE
C                  +1      SUCCESS
C
C THE PARTIAL PRE-CHECKING BEFORE LABEL 100 IS NECESSARY FOR THOSE
C COMPILERS (EG IBM) WHICH DO NOT USE THE ERROR LABEL FOR TYPE
C MIS-MATCHES DURING INTERNAL READS.
C
      CHARACTER*(*) CTEXT
C
      CHARACTER *11 CNUMER
      CHARACTER *20 CBUFF1
C
      PARAMETER ( CNUMER = '0123456789.' )
C
      KCCINT = 1
C
      CBUFF1 = CTEXT
C
C
      DO 10 I = 1,20
        IF ((CBUFF1(I:I) .EQ. ' ') .OR. (CBUFF1(I:I) .EQ. '+')
     1      .OR. (CBUFF1(I:I) .EQ. '-') ) GOTO 5
        GOTO 15
5       CONTINUE
10    CONTINUE
C---- TREAT ALL SPACES AS AN INTEGER
      IF (CBUFF1(20:20) .EQ. ' ') GOTO 100
      GOTO 9900
C
15    CONTINUE
      DO 30 I = 1,20
        IF (INDEX(CNUMER, CBUFF1(I:I)) .LE. 0) GOTO 9900
30    CONTINUE
C
C----- NO CHARACTERS FOUND, TRY TO READ AS INTEGER
100   CONTINUE
      READ ( CBUFF1 ,'(BN,I20)', ERR=9900) IVALUE
      RETURN
C
9900  IVALUE = 0
      KCCINT = -1
      RETURN
C
      END
CODE FOR KCCREA
      FUNCTION KCCREA ( CTEXT , VALUE )
C
C -- CONVERT TEXT TO REAL VALUE
C
C      CTEXT       TEXT TO BE CONVERTED ( UP TO 20 CHARACTERS )
C      VALUE       RESULTANT VALUE
C
C      KCCREA      -1      FAILURE
C                  +1      SUCCESS
C
      CHARACTER*(*) CTEXT
C
      CHARACTER*20 CBUFF1
C
      KCCREA = 1
C
      CBUFF1 = CTEXT
      READ ( CBUFF1 , '(BN,F20.0)' , ERR = 9900 ) VALUE
      RETURN
C
9900  CONTINUE
      VALUE = 0
      KCCREA = -1
      RETURN
C
      END
CODE FOR KCCTRM
      FUNCTION KCCTRM ( IFUNC , CTEXT , ISTART , IEND )
C
C -- TRIM TEXT
C
C -- FIND, USING THE METHOD SPECIFIED, THE USEFUL PART OF 'CTEXT'
C
C
C      INPUTS :-
C
C            IFUNC       FUNCTION REQUIRED
C                        0      NO TRIMMING. ISTART AND IEND SET TO
C                               LIMITS OF 'CTEXT'
C                        1      TRIM TO ONE WORD. ISTART IS FIRST
C                               NON-SPACE CHARACTER. IEND IS AT END OF
C                               FIRST WORD
C
C            CTEXT       INPUT TEXT TO BE TRIMMED
C
C      OUTPUTS :-
C            ISTART      START OF USEFUL TEXT IN 'CTEXT'
C            IEND        END OF USEFUL TEXT IN 'CTEXT'
C
C      RETURN VALUE :-
C            -VE         FAILURE. THERE IS NOT ENOUGH TEXT TO TRIM
C            +VE         SUCCESS
C
      CHARACTER*(*) CTEXT
C
C
      ISTART = 1
      IEND = LEN ( CTEXT )
      KCCTRM = 1
C
      IF ( IFUNC .LE. 0 ) THEN
      ELSE IF ( IFUNC .EQ. 1 ) THEN
        ISTART = KCCNEQ ( CTEXT , ISTART , ' ' )
        IF ( ISTART .LE. 0 ) GO TO 9900
        IEND = KCCEQL ( CTEXT , ISTART , ' ' ) - 1
        IF ( IEND .LE. 0 ) IEND = LEN ( CTEXT )
      ENDIF
C
C
      RETURN
C
C
9900  CONTINUE
      KSCTRM = -1
      RETURN
C
C
      END
CODE FOR KCCAPP
      FUNCTION KCCAPP ( CTEXT , IPOS, CNEW )
C
C -- APPEND 'CNEW' TO 'CTEXT', STARTING AT POSITION IPOS+1, AND CHECKING
C    FOR EXCESSIVE LENGTH. IPOS IS UPDATED BY THIS ROUTINE
C
C
      CHARACTER*(*) CTEXT , CNEW
C
C
      MAXLEN = LEN ( CTEXT )
      NEWLEN = IPOS + LEN ( CNEW )
C
      IF ( IPOS .LT. MAXLEN ) THEN
        CTEXT(IPOS+1:) = CNEW
      ENDIF
C
      IF ( NEWLEN .GT. MAXLEN ) THEN
        IPOS = MAXLEN
        KCCAPP = -1
      ELSE
        IPOS = NEWLEN
        KCCAPP = 1
      ENDIF
C
C
      RETURN
      END
C
CODE FOR KCRVAL
      FUNCTION KCRVAL (CBUFF, ISIZE,  ISTART, IPOS1, IPOS2, VALUE)
C
C----- TRY TO PROCESS  THE NEXT ARGUMENT AS A REAL NUMBER
C
C       CBUFF   - INPUT STRING
C       ISIZE   - USED PART OF CBUFF
C       ISTART  - STARTING POSITION FOR SEARCH
C-----  RETURN VALUES:
C            +1 SUCESS, VALUE RETURNED IN 'VALUE'
C            -1 NOT A NUMBER
C       IPOS1   - START OF ARGUMENT
C       IPOS2   - END OF ARGUMENT
C
      CHARACTER CBUFF *(*)
      EQUIVALENCE (IRESLT, RESLT)
C
      VALUE = 0.0
      KCRVAL = -1
      IF(KCCARG (CBUFF(1:ISIZE), ISTART,1, IPOS1, IPOS2) .LE. 0)THEN
        IPOS2 = ISIZE
      END IF
C----- TRY TO PROCESS AS NUMBER
      IF (KCCNUM(CBUFF(IPOS1:IPOS2), IRESLT, ITYPE) .LE. 0) THEN
C----- NOT A NUMBER
        RETURN
      ELSE
C      A NUMBER
        IF (ITYPE .EQ. 1) THEN
            VALUE = FLOAT(IRESLT)
        ELSE
            CALL XMOVE ( RESLT, VALUE, 1)
        END IF
      END IF
      KCRVAL = +1
      RETURN
      END
C
C
CODE FOR CIAPP
       SUBROUTINE CIAPP (CVAR,IVAR,IEND)
C
C APPENDS AN INTEGER, IVAR, FOLLOWED BY A COMMA, TO A
C CHARACTER VARIABLE, CVAR, FROM THE POSITION IEND+1
C ONWARDS.  IEND IS UPDATED TO THE LAST OCCUPIED POSITION
C IN CVAR (I.E. THE POSITION OF THE COMMA).
C
       CHARACTER*(*) CVAR
C
C SAVE IVAR
       ITEMP = IVAR
C
C ACCOUNT FOR NEGATIVE OR ZERO ITEMP.
C
       IF (ITEMP .LT. 0) THEN
        CVAR(IEND+1:IEND+1) = '-'
        IEND = IEND+1
        ITEMP = (-ITEMP)
       ELSE IF (ITEMP .EQ. 0) THEN
        CVAR(IEND+1:IEND+2) = CHAR(48)//','
        IEND = IEND+2
        RETURN
       ENDIF
C
C
       LITEMP = INT(LOG10(REAL(ITEMP)))+1
C
       I = LITEMP
C
100       CONTINUE
       IF (I .EQ. 0) GOTO 200
       IFIRST = ITEMP/(10**(I-1))
       CVAR(IEND+1:IEND+1) = CHAR(IFIRST+48)
       IEND = IEND+1
       ITEMP = ITEMP-(IFIRST*(10**(I-1)))
       I=I-1
       GOTO 100
C
200       CONTINUE
C
       CVAR(IEND+1:IEND+1)=','
       IEND = IEND+1
C
       RETURN
       END
C
CODE FOR CATSTR
       SUBROUTINE CATSTR (ATOM, SERIAL, IS, NPLI, ITX, ITY, ITZ,
     +                    CASTR, LASTR)
C
C WRITES THE INFORMATION ON THE ATOM CATOM(ILABEL) TO THE CHARACTER
C VARIABLE CASTR OF LENGTH LASTR IN THE FORM ATOM(LABEL,IS,NPLI,ITX,
C ITY,ITZ).  THIS IS THEN ABBREVIATED TO THE LAST NON-DEFAULT SYMMETRY
C OPERATOR, E.G. C(9,1,1,0,0,0) IS TRIMMED TO C(9); N(2,1,1,2,0,0) IS
C TRIMMED TO N(2,1,1,2).
C---------------------------------------------------------------------
C        IS...ITX - SYMMETRY OPERATORS (MAY BE FOUND AT POSITIONS
C                   J+2...J+6 OF A DISTANCE STACK CREATED BY KDIST).
C                   (J = ADDRESS OF THE FIRST ENTRY OF AN ATOM IN THE
C                    STACK)
C        ATOM     - ATOM TYPE HELD AS REAL VARIABLE
C        SERIAL   - ATOM SERIAL NUMBER
C        CASTR    - CHARACTER - OUTPUT AS ABOVE
C        ILAST    - POSITION IN CASTR OF THE MOST RECENT NON-DEFAULT
C                   SYMMETRY OPERATOR.
C
       CHARACTER*(*) CASTR
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
C
C CLEAN OUT CASTR.
       CASTR =' '
C
C PLACE THE ATOM TYPE IN CASTR
C
       WRITE(CASTR(1:4), '(A4)') ATOM
C
C TRIM CASTR TO THE LAST NON-SPACE CHARACTER (POSITION IEND).
C
       NCCTRM=KCCTRM(1, CASTR(1:4),ISTART,IEND)
       IF (NCCTRM .LT. 0) THEN
       CALL XIVHT ('CATSTR')
       RETURN
       ENDIF
C
       CASTR(IEND+1:IEND+1)='('
       IEND=IEND+1
C
C APPEND SERIAL
C
       CALL CIAPP (CASTR, NINT(SERIAL), IEND)
       ILAST=IEND
C
C APPEND SYMMETRY OPERATORS
C
       CALL CIAPP (CASTR,IS,IEND)
       IF (IS .NE. 1) THEN
       ILAST=IEND
       ENDIF
C
       CALL CIAPP (CASTR,NPLI,IEND)
             IF (NPLI .NE. 1) THEN
       ILAST=IEND
       ENDIF
C
       CALL CIAPP (CASTR,ITX,IEND)
       IF (ITX .NE. 0) THEN
       ILAST=IEND
       ENDIF
C
       CALL CIAPP (CASTR,ITY,IEND)
       IF (ITY .NE. 0) THEN
       ILAST=IEND
       ENDIF
C
       CALL CIAPP (CASTR,ITZ,IEND)
       IF (ITZ .NE. 0) THEN
       ILAST=IEND
       ENDIF
C
C ONLY USE CASTR UP TO THE LAST NON-DEFAULT SYMMETRY OPERATOR.
C
       IEND=ILAST
       CASTR(IEND:IEND)=')'
C
C FILL UP REST OF CASTR WITH SPACES.
       LENSTR = LEN (CASTR)
       CASTR(IEND+1:LENSTR)=' '
       LASTR=IEND
       IEND=0
       RETURN
       END
C
C
CODE FOR XIVHT
      SUBROUTINE XIVHT (CTYPE)
C
C----- ERROR MESSAGE FROM HNN WRITER
      CHARACTER *(*) CTYPE
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,100) 'Unable to get atom type in routine', CTYPE
      ENDIF
      WRITE(NCAWU,100) 'Unable to get atom type in routine', CTYPE
      WRITE ( CMON, 100) 'Unable to get atom type in routine', CTYPE
      CALL XPRVDU(NCVDU, 1,0)
100   FORMAT( 3X,A,A)
      RETURN
      END
C
C
CODE FOR KCITOF
      FUNCTION KCITOF (CFORM)
C----- CHANGE ALL INTEGER REFERENCES TO FLOATING 
C      RETURN >0 IF ALL OK
C      IN FORMAT STATEMENTS
      CHARACTER *(*) CFORM
      CHARACTER *1 CTERM
      CHARACTER *10 CNUM
      INCLUDE 'XUNITS.INC'
      DATA CNUM/'0123456789'/
      KCITOF = 1
      LFORM = LEN(CFORM)
50    CONTINUE
      CALL XCRAS(CFORM,LUSED)
      I = INDEX (CFORM ,'I')
      K = INDEX (CFORM ,'i')
      I = 1 + MAX(I,K)
      IF (I .LE. 1) GOTO 300
      J = INDEX (CFORM(I:LUSED), ',')      
      IF (J .LE. 0) THEN
            J = INDEX (CFORM(I:LUSED), ')')      
            IF (J .LE. 0) THEN
                  GOTO 250
            ENDIF
      ENDIF
      J = I + J -1
      K = KGTNUM( CFORM(I:I+J), CTERM, NCHAR)
      CFORM(I-1:I-1)='F'
      IF (LUSED+2 .LE. LFORM) THEN
       DO 100 N=LUSED+2,J+2,-1
        CFORM(N:N)=CFORM(N-2:N-2)
100    CONTINUE
       CFORM(I+NCHAR:I+NCHAR+1) = '.0'
      ELSE
        GOTO 250
      ENDIF
200   CONTINUE
C----- LOOP UNTIL NO MORE INTEGERS
      GOTO 50
250   CONTINUE
C----- ERROR CONDITION
      KCITOF = -1
C      WRITE(*,*) 'ERROR CONDITION'
300   CONTINUE
      RETURN
      END
C
CODE FOR DFORM
      SUBROUTINE DFORM(VALUE,CFORM)
C----- TRY TO FIND A SUITABLE FORMAT STATEMENT FOR THE INPUT
C      VALUE.  REMEMBER THAT 32BIT FLOATING ONLY HAS 6-7 SIGNIFICANT
C      PLACES
C----- DJW JUL 09
      double precision dvalue, avalue, asign
      character *1 cmatch
      character*64 cvalue
      character *(*) cform
      data cmatch /'0'/
      parameter (ndp=7)
c
c
      write(cvalue,'(f64.32)') value
      dvalue = value
c      write(*,'(a)') cvalue
c
      do k=1,64
            if(
     1      (cvalue(k:k) .ne. ' ' ) .and.
     2      (cvalue(k:k) .ne. '0' ) .and.
     2      (cvalue(k:k) .ne. '-' ) .and.
     3      (cvalue(k:k) .ne. '.' ) ) goto 300
      enddo
      k=64
300   continue
c
      i = index  (cvalue,'.')
      j = i-k
      if (j .ge. ndp) then
c very large number - no fractional part
            n=j+1
            m=0
c--------------------------------------
c      horrid kludge to make least significant parts zero
       mdp = n-ndp
       if (mdp .gt. 0) then
        avalue = abs(dvalue)
        asign = sign(1.0D0, dvalue)
        nvalue = nint ( dvalue * (10. ** (-mdp)))
        if ( dvalue .ge. 10. ** mdp) then
             dvalue = asign*float(nvalue)*10.**mdp
c             write(*,*) avalue, asign*float(nvalue)*10.**mdp
c             write(*,*)  dvalue
             value = dvalue
        endif
       end if
c--------------------------------------
      else
        if(j .gt. 0) then
c middling number greater than unity
            m=k+ndp
            do nn = m,i+1,-1
                if (cvalue(nn:nn) .ne. '0') goto 200
            enddo
            nn = i
200         continue
            m = nn-i
            n = j+1+m
        else
c  number less than unity
            k = i
            m = ndp-j
            n = 2+m
        endif
      endif            
c
      if (value .lt. 0.) n=n+1
c  leave room for minus sign
      write(cform,99)n+1,m
99    format ('(F',i2,'.'i2,')')
      return
      end
C
CODE FOR NCTRIM (to be replaced by len_trim() )
      INTEGER FUNCTION NCTRIM( CSOURC )
C-- LENGTH OF ARGUMENT EXCLUDING TRAINING SPACES.
C CODE COPIED FROM \BITS\CHARACT.FOR
C------ TRIM OFF TRAILING SPACES
C      CSOURC - SOURCE STRING
C      NCHAR   - LAST NON-SPACE CHARACTER
      CHARACTER *(*) CSOURC
      CHARACTER *1 CBLANK
      DATA CBLANK /' '/
C
      LENGTH = LEN (CSOURC)
      IF (CSOURC(LENGTH:LENGTH) .NE. CBLANK) THEN
          NCTRIM = LENGTH
          RETURN
      ENDIF
      DO 100 I = LENGTH, 1, -1
        IF (CSOURC(I:I) .NE. CBLANK) GOTO 200
100   CONTINUE

      I = 0

200   CONTINUE
      NCTRIM = I
      RETURN
      END
c
