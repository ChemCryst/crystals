      PROGRAM REINDX
      DIMENSION R(3,3), IND(3), NIND(3), AIND(3), OHKL(3), AHKL(3)
      dimension NREJ(3),SUMI(3),SUMSIG(3),SUMRAT(3)
      CHARACTER*4 TYPE (4),INPUT
      CHARACTER *32 CFILE, COUT
      CHARACTER*80 JUNK,CFORM
      CHARACTER*1 TEST(2),TESTER
      DATA TYPE(1)/'HKLI'/,TYPE(2)/'PCH6'/,TYPE(3)/'SHEL'/
     1 ,TYPE(4)/'SIR9'/
      DATA TEST(1)/'Y'/,TEST(2)/'N'/
C 
C      TO REINDEX REFLECTION DATA
c      more bodges to accumulate statistics.
C      BODGED BY DJW TO ACCEPT PUNCH 6 C FILES
C 
C      MODIFIED TO ACCEPT SHELXS SEPT 1995
C      Modified May 91 because of erors with I/O by DJW
C      Modified 3/88 for non-integer transformations by JAH
C      Modified 3/88 for correct orientation of matrices by PDB
C      Modified 10/88 for better input of orientation matrix
C                     and matrix testing by JAH
C 
C               The transformation matrix should be of the form
C               DELRED produces, and is multiplied on the right
C               side by a 3X1 matrix consisting of hkl:
C 
C                  |D11 D12 D13|   |h|   |h'|
C                  |D21 D22 D23| X |k| = |k'|
C                  |D31 D32 D33|   |l|   |l'|
C 
C               This reproduces transforms from the CAD4
C                                                           JAH
C 
#if defined(CRY_GNU)
      call no_stdout_buffer_()
#endif
      do 1 i=1,3
      NREJ(i) = 0
      SUMI(i)  = 0.
      SUMSIG(i)  = 0.
      SUMRAT(i)  = 0.
1     continue
50    WRITE (6,100)
100   FORMAT (/,1X,' Reindex matrix from DELRED')
      WRITE (6,150)
150   FORMAT (1X,' D11, D12, D13: ')
      READ (5,*) R(1,1),R(1,2),R(1,3)
      WRITE (6,200)
200   FORMAT (/,1X,' D21, D22, D23: ')
      READ (5,*) R(2,1),R(2,2),R(2,3)
      WRITE (6,250)
250   FORMAT (/,1X,' D31, D32, D33: ')
      READ (5,*) R(3,1),R(3,2),R(3,3)
C 
C ------- Matrix test
C 
      WRITE (6,300)
300   FORMAT (/,1X,' Do you want to test this matrix (Y/N)?')
      READ (5,350) TESTER
350   FORMAT (A1)
      IF (TESTER.EQ.TEST(2)) GO TO 800
      DO 600 I=1,100
           WRITE (6,400)
400        FORMAT (/,1X,' Input h,k,l - terminate with 0,0,0 ',/)
           READ (5,*) OHKL
           IF ((OHKL(1).EQ.0).AND.(OHKL(2).EQ.0).AND.(OHKL(3).EQ.0)) GO
     1      TO 650
           DO 450 J=1,3
                AHKL(J)=OHKL(1)*R(J,1)+OHKL(2)*R(J,2)+OHKL(3)*R(J,3)
450        CONTINUE
           WRITE (6,500) OHKL
500        FORMAT (/,1X,' Old indices: ',F6.2,',',F6.2,',',F6.2)
           WRITE (6,550) AHKL
550        FORMAT (1X,' New indices: ',F6.2,',',F6.2,',',F6.2)
600   CONTINUE
650   WRITE (6,700)
700   FORMAT (/,1X,' Change the matrix (Y/N)?')
      READ (5,750) TESTER
750   FORMAT (A1)
      IF (TESTER.EQ.TEST(1)) GO TO 50
C 
C ------- HKL input
C 
800   CONTINUE
      WRITE (6,850)
850   FORMAT (/,1X,
     1 ' Input type please , (HKLI or PCH6C, SHELX, SIR92) ')
      READ (5,900) INPUT
900   FORMAT (A4)
      WRITE (6,950) 
950   FORMAT (/,1X,' Allowed error for rounding please  ')
      READ (5,*) ERROR
      IF (INPUT.EQ.TYPE(1)) GO TO 1150
      IF (INPUT.EQ.TYPE(2)) GO TO 1150
      IF (INPUT.EQ.TYPE(3)) GO TO 1150
      IF (INPUT.EQ.TYPE(4)) GO TO 1150
      WRITE (6,*) ' Invalid input file type (note - UPPER CASE) '
      GO TO 800
C 
C 
1150  CONTINUE
      WRITE (6,1000)
1000  FORMAT (/,1X,' Thank you ')
      WRITE (6,1050)
1050  FORMAT (//,25X,' LISTING OF NON-INTEGER REFLECTIONS ')
      WRITE (6,1100)
1100  FORMAT (24X,'**************************************',/)
C
C
1155  CONTINUE
      WRITE(6,'('' File to be processed'')') 
      READ(5,'(A)') CFILE
      OPEN(10,FILE=CFILE,ERR=1155,STATUS='OLD')
1156  CONTINUE
      WRITE(6,'('' File to be CREATED'')') 
      READ(5,'(A)') COUT
      OPEN(11,FILE=COUT,ERR=1156,STATUS='UNKNOWN')
C
      IF (INPUT.EQ.TYPE(2)) THEN
C----- READ AND REOUTPUT THE FIRST 8 LINES
           DO 1250 I=1,7
                READ (10,1200) JUNK
                WRITE (11,1200) JUNK
1200            FORMAT (A80)
1250       CONTINUE
C----- SAVE THE FORMAT
           CFORM=JUNK
           DO 1300 I=1,80
                IF (CFORM(I:I).EQ.'G') CFORM(I:I)='E'
1300       CONTINUE
           CFORM(1:7)=' '
           I=INDEX(CFORM(1:80),'F4.0')
           IF (I.NE.0) CFORM(I:I+3)='I4  '
           WRITE (6,*) ' Writing file with format'
           WRITE (6,'(1X,A)') CFORM
           READ (10,1200) JUNK
           WRITE (11,1200) JUNK
      END IF
C 
C----- LOOP HERE OVER REFLECTIONS
1350  CONTINUE
      IF (INPUT.EQ.TYPE(1)) THEN
C----- HKLI FORMAT INPUT
           READ (10,1400,END=1750) IND,VINT,SIG,JCODE,IXT2,IBATCH,T,P,W,
     1      AK
1400       FORMAT (5X,3I4,F9.0,F7.0,I4,I9,I4,4F7.2)
      ELSE IF (INPUT.EQ.TYPE(2)) THEN
C----- PUNCH 6 'C' FORMAT
C-----  format modified 31/1/89 by JAH
CDJWMAR2001
C           READ (10,CFORM,END=1750,ERR=1700) IND,VINT,SIG,FC,PHASE,
C     1      RATIO,FOT,ELEMENTS,WEIGHT
            READ(10,'(3I4,F10.2,F8.2,A)',END=1750,ERR=1700)
     1      IND,VINT,SIG,JUNK(1:50)
      ELSE IF (INPUT.EQ.TYPE(3)) THEN
           READ (10,1450,END=1750) IND,VINT,SIG
1450       FORMAT (3I4,2F8.2)
      ELSE IF (INPUT.EQ.TYPE(4)) THEN
           READ (10,1455,END=1750) IND,VINT,SIG
1455       format (3i4, f10.3, f8.1)
      ELSE
           WRITE (*,'(A)') 'UNKNOWN FORMAT'
           STOP
      END IF
C 
      IF (IND(1).LE.-512) THEN
           WRITE (11,'(A)') '-512'
           GO TO 1750
      END IF
      DO 1500 I=1,3
           AIND(I)=IND(1)*R(I,1)+IND(2)*R(I,2)+IND(3)*R(I,3)
1500  CONTINUE
C 
      DO 1600 I=1,3
           EXTRA=0
           EXTRA=ABS(AIND(I)-FLOAT(NINT(AIND(I))))
           IF (EXTRA.LE.ERROR) GO TO 1600
           WRITE (6,1550) AIND,VINT,SIG
1550       FORMAT 
     1     (3(2X,F6.3),3X,'Intensity = ',F12.3,3X,'Sigma = ',F9.3)
           if (vint .le. 0.0) then
            NREJ(1) = NREJ(1)  + 1
            SUMI(1)  = SUMI(1)  + VINT
            SUMSIG(1)  = SUMSIG(1)  + SIG
            SUMRAT(1)  = SUMRAT(1)  + VINT/SIG
           else if (vint .gt. 0.0) then
            NREJ(2) = NREJ(2)  + 1
            SUMI(2)  = SUMI(2)  + VINT
            SUMSIG(2)  = SUMSIG(2)  + SIG
            SUMRAT(2)  = SUMRAT(2)  + VINT/SIG
           endif
           NREJ(3) = NREJ(3)  + 1
           SUMI(3)  = SUMI(3)  + VINT
           SUMSIG(3)  = SUMSIG(3)  + SIG
           SUMRAT(3)  = SUMRAT(3)  + VINT/SIG
           GO TO 1350
1600  CONTINUE
C 
      DO 1650 I=1,3
           NIND(I)=NINT(AIND(I))
1650  CONTINUE
C 
      IF (INPUT.EQ.TYPE(1)) THEN
           WRITE (11,1400) NIND,VINT,SIG,JCODE,IXT2,IBATCH,T,P,W,AK
      ELSE IF (INPUT.EQ.TYPE(2)) THEN
CDJWMAR2110
C           WRITE (11,CFORM) NIND,VINT,SIG,FC,PHASE,RATIO,FOT,ELEMENTS,
C     1      WEIGHT
            WRITE(11,'(3I4,F10.2,F8.2,A)')
     1      NIND,VINT,SIG,JUNK(1:50)
      ELSE IF (INPUT.EQ.TYPE(3)) THEN
           IF (VINT.LE.99990) THEN
                WRITE (11,1450) NIND,VINT,SIG
           ELSE
                WRITE (11,'(3I4,2F8.0)') NIND,VINT,SIG
           END IF
      ELSE IF (INPUT.EQ.TYPE(4)) THEN
           IF (VINT.LE.9999990) THEN
                WRITE (11,1455) NIND,VINT,SIG
           ELSE
                WRITE (11,'(3i4, f10.0, f8.1)') NIND,VINT,SIG
           END IF
      ELSE
           WRITE (*,'(A)') 'UNKNOWN FORMAT'
           STOP
      END IF
      GO TO 1350
C 
1700  CONTINUE
      READ (10,1200,END=1750) JUNK
      WRITE (11,1200) JUNK
      GO TO 1700
1750  CONTINUE
      do 1760 i = 1,3
       if(nrej(i) .ne. 0) then
            sumi(i) = sumi(i)/nrej(i)
            sumsig(i) = sumsig(i)/nrej(i)
            sumrat(i) = sumrat(i)/nrej(i)
      else
            sumi(i) = 0.
            sumsig(i) = 0.
            sumrat(i) = 0.
      endif
1760  continue
      IF (NREJ(3) .GT. 0) THEN
      WRITE(*,'(A)') ' Statistics for the rejected reflections'
      WRITE(*,'(A,3I6,/A,3F12.3,/A,3F12.3,/A,3F12.3)')
     1 ' Number rejected =', NREJ(1),nrej(2),nrej(3),
     2 ' Mean value      =', SUMI(1),sumi(2),sumi(3),
     3 ' Mean sigma      =', SUMSIG(1),sumsig(2),sumsig(3),
     4 ' Mean ratio      =', SUMRAT(1),sumrat(2),sumrat(3)
      ENDIF
      WRITE (*,'(A)') 'end '
      STOP
      END
