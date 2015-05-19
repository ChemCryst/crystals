      PROGRAM DIPIN
      DIMENSION IND(3), F(4), INDRNG(6), scalei(2)
      PARAMETER (NSCALE=360)
      CHARACTER *132 CLINE
      CHARACTER *64 CCOMP
      CHARACTER *16 CTEXT
      DIMENSION SCALE(NSCALE), ISCALE(NSCALE), BFACT(NSCALE),
     1 IBFACT(NSCALE), COMBIN(NSCALE)
      DIMENSION CELL(7), ESD(7), ITEMP(7)

      DATA NINFIL/20/, NHKLFL/21/, NLIST/22/, NSCFFL/23/
C
c DENZO produces a table of frame scale factors and B values.
c DIPIN combines them to find the overall correction per frame, 
c in an attempt to determine the 'absorption' correction inplied if the
c thecrystal is not really decomposing.

#if defined(CRY_GNU)
      call no_stdout_buffer_()
#endif

      DO 1, I = 1,NSCALE
            SCALE(I) = 0.
            ISCALE(I) = 0
            BFACT(I) = 0.
            IBFACT(I) = 0
1     CONTINUE
      DO 2, I = 1,7
            CELL (I) = 0.
            ESD(I) = 0.
            ITEMP(I) = 0
2     CONTINUE
      DO 3, I= 1,5,2
      INDRNG(I) = 10000
      INDRNG(I+1) = -10000
3     CONTINUE      
      NREFIN = 0
      NREFOP = 0
      NFILM = 0
      NMAX = 0
      CHISQ = 0.
      RLIN = 0.
      RSQ = 0.
      pdist = 75.
c
      RTD = 180. / ACOS(-1.)
      DTR = 1. / RTD
      NREF = 0
4     continue
      WRITE(*,*) 'Reflection file to be converted'
      READ(*,'(A)') CTEXT
      OPEN(NINFIL,FILE=CTEXT,STATUS='OLD',err=4)
      WRITE(*,*) 'File to be created (No extension)'
      READ(*,'(A)') CTEXT
      last = index(ctext, ' ')-1
      I = INDEX (CTEXT, '.')
      IF (I .GT. 0) last = i-1
      OPEN(NHKLFL,FILE=CTEXT(:last)//'.DIP',STATUS='UNKNOWN')
      OPEN(NLIST,FILE=CTEXT(:last)//'.LIS',STATUS='UNKNOWN')
      OPEN(NSCFFL,FILE=CTEXT(:last)//'.SCF',STATUS='UNKNOWN')
C----- 3 DUMMY READS to get rid of header information
      READ(NINFIL,'(a)',iostat=i ) CLINE
      READ(NINFIL,'(a)',iostat=i ) CLINE
      READ(NINFIL,'(a)',iostat=i ) CLINE
100   CONTINUE
      READ(NINFIL,50,END=200) IND, F
50    FORMAT(3I4,4F8.0)
c check Sigma
      IF (F(2) .GT. 0.000001) THEN
            NREF = NREF +1
c choose a format statement to preserve precision
            IF (F(2) .GE. 999999) THEN
              WRITE(NHKLFL,52) IND, NINT(F(1)), F(2)
52            FORMAT(3I4,I8,F8.0)
            ELSE
              WRITE(NHKLFL,51) IND, F(1), F(2)
51            FORMAT(3I4,4F8.1)
            ENDIF
            DO 54, I = 1,3
            IF (IND(I) .LT. INDRNG(2*I-1)) INDRNG(2*I-1) = IND(I)
            IF (IND(I) .GT. INDRNG(2*I)) INDRNG(2*I) = IND(I)
54          CONTINUE
      ENDIF
      IF (F(4) .GT. 0.000001) THEN
            NREF = NREF +1
            DO 55, I = 1,3
c generate indices for Friedel pairs. TAKE care - the 'hand' of the DIP 
c is reversed.
            IND(I) = -1* IND(I)
            IF (IND(I) .LT. INDRNG(2*I-1)) INDRNG(2*I-1) = IND(I)
            IF (IND(I) .GT. INDRNG(2*I)) INDRNG(2*I) = IND(I)
55          CONTINUE
            IF (F(4) .GE. 999999) THEN
              WRITE(NHKLFL,52)IND,NINT(F(3)),F(4)
            ELSE
              WRITE(NHKLFL,51) IND, F(3), F(4)
            ENDIF
      ENDIF
      GOTO 100
200   CONTINUE
      WRITE(*,*) ' reflection input ends.', nref, ' reflections output'
210   CONTINUE
C
5     continue
      WRITE(*,*) 'Scale file to be summarised'
      READ(*,'(A)') CTEXT
      OPEN(NINFIL,FILE=CTEXT,STATUS='OLD',err=5)
C

c this is all a bit of a mess because it is reading a text (rather
c than a data) file


1100   CONTINUE
      READ (NINFIL,'(A)',END=9000) CLINE
      IF (CLINE(2:10) .EQ. 'New scale') THEN
            J = 0
1400         CONTINUE
            READ(NINFIL,'(A)') CLINE
            READ(CLINE,'(I6)',ERR=1100) I
            IF (I .GT. 0) THEN
              READ(CLINE,'(5(I6,F9.2))')
     1        (ISCALE(I+J),SCALE(I+J),I=1,5)
              J = J + 5
              GOTO 1400
            ENDIF
      ELSEIF (CLINE(2:13) .EQ. 'New B factor') THEN
            J = 0
1500         CONTINUE
            READ(NINFIL,'(A)') CLINE
            READ(CLINE,'(I6)',ERR=1100) I
            IF (I .GT. 0) THEN
              READ(CLINE,'(5(I6,F9.2))')
     1        (IBFACT(I+J),BFACT(I+J),I=1,5)
              J = J + 5
              GOTO 1500
            ENDIF
      ELSEIF (CLINE(2:20) .EQ. 'Errors of the scale') THEN
1300         CONTINUE
            READ(NINFIL, '(A)') CLINE
            READ(CLINE,'(1X,I6)',ERR=1100) I
            IF (I .GT. 0) THEN
              READ(CLINE,'(1X,5(I6,9X))')  (ITEMP(I),I=1,5)
              DO 1310 I = 1,5
                  IF (ITEMP(I) .GT. 0) NMAX = ITEMP(I)
1310           CONTINUE
              GOTO 1300
            ELSE
            ENDIF
c trying to find out how many reflections were used for cell 
c determination
      ELSEIF (CLINE(2:15) .EQ. 'Hkl''s refined:') THEN
            READ(CLINE, '(15X,I7)') I
            NREFIN = MAX(I, NREFIN)
      ELSEIF (CLINE(2:7) .EQ. 'Film #') THEN
1200         CONTINUE
            READ(NINFIL,'(A)') CLINE
            READ(CLINE,'(I7,F8.3)',ERR=1100) I, A
            IF (I .GT. 0) THEN
              IF (I .EQ. NMAX) THEN
                IF (A .GT. 1.0) THEN
                  READ(CLINE,'(I7,6F8.3,24X,F8.3)') NFILM, CELL
                ELSE
                  READ(CLINE,'(I7,6F8.3,24X,F8.3)') NFILM, ESD
                ENDIF
              ENDIF
              GOTO 1200
            ELSE
                  GOTO 1100
            ENDIF
c trying to find final statistics

      ELSEIF (CLINE(2:8) .EQ. 'All hkl') THEN
            READ(CLINE, '(61X,I7)',ERR=1100) NREFOP
      ELSEIF (CLINE(3:17) .EQ. 'All reflections') THEN
            READ(CLINE,'(42X,3F7.3)') CHISQ, RLIN, RSQ
      ENDIF
      GOTO 1100
C
c combine B and Scale
9000  CONTINUE
      SX = 0.
      SXS = 0.
      DO 600 I=1,NMAX
      SX = SX + SCALE(I)
      SXS = SXS + SCALE(I)*SCALE(I)
600   CONTINUE
      SCALEM = SX/FLOAT(NMAX)
      SCALES = SQRT(( SXS + FLOAT(NMAX)*SCALEM*SCALEM -
     1 2.*SCALEM*SX)/FLOAT((NMAX-1)))
      scalei(1) = scalem
      scalei(2) = scales
C----- COMPUTE TOTAL CORRECTION
      A = 26.0 * 3.14159 / 180.0
      A = SIN(A) / 0.70169
      A = A * A * 2.
      SX = 0.
      SXS = 0.
      write(nlist,'(
     1 ''   Scale  1/f(bfact) Combined'')')
      mscale = 0
      DO 700 I = 1, NMAX
      bfact(i) = 1. / EXP(A * BFACT(I))
      COMBIN(I) = SCALE(I) * bfact(i)
      if (combin(i) .gt. 1.01) then
       SX = SX + COMBIN(I)
       SXS = SXS + COMBIN(I)*COMBIN(I)
       mscale = mscale + 1
      endif
      WRITE(NLIST,'(3F9.3)') SCALE(I), bfact(i), COMBIN(I)
700   CONTINUE
      SCALEM = SX/mscale
      SCALES = SQRT(( SXS + mscale*SCALEM*SCALEM -
     1 2.*SCALEM*SX)/(mscale-1))
      WRITE(NLIST ,9200) '        Mean scale  = ', scalei(1)
      WRITE(NLIST ,9200) 'Standard deviation  = ', SCalei(2)
      WRITE(NLIST ,9200) 'Combined scale     = ', SCALEM
      WRITE(NLIST ,9200) 'Standard deviation = ', SCALES
C
9100  FORMAT(A,I10)
      WRITE(NLIST,9100) 'No reflections used in SCALEPACK = ', NREFIN
      WRITE(NLIST,9100) 'No refelctions in HKL file =', nref
      WRITE(NLIST,9100) 'No reflections output = ', NREFOP
      if (nref .ne. nrefop) then
      write(nlist,9101) 
      write(*,9101) 
      endif
9101  format(/' The reflection and listing files don''t agree'/)
      WRITE(NLIST,9100) 'No of frames used = ', NFILM
      WRITE(NLIST,9100) 'No of useful frames = ', NMAX
9200  FORMAT(A,F12.4)

      WRITE(NLIST,9200) 'Chi sqaure = ', CHISQ
      WRITE(NLIST,9200) 'R linear = ', RLIN
      WRITE(NLIST,9200) 'R square = ', RSQ
      write(nlist, '(''Cell parameters and mosaicity'')')
      WRITE(NLIST,'(7F9.3)') CELL
      WRITE(NLIST,'(7F9.4)') ESD
C     V = 1 -cos**2(alpha) -cos**2(beta) -cos**2(gamma)
C           + 2cos(alpha)cos(beta)cos(gamma)
      CALP = COS (CELL(4) * DTR)
      CBET = COS (CELL(5) * DTR)
      CGAM = COS (CELL(6) * DTR)
      V = 1.0 -CALP*CALP -CBET*CBET -CGAM*CGAM
     +        + 2*CALP*CBET*CGAM
      V = CELL(1)*CELL(2)*CELL(3) *SQRT(V)
c
      write(*,*) ' Plate distance, mm'
      read(*,*) pdist
      write(nlist,*) ' Plate distance, mm', pdist

c try to estimate fraction of unique data measured.

      thmax = 0.5 * atan2(100., pdist)
      write(*,*) 'Estimated theta max = ', thmax/dtr
      tmp = (sin(thmax) * 2. /0.71069)
      tmp = tmp*tmp*tmp
      nest = nint (3.14159/6.)*v*tmp*8.
      write(*,*) ' Estimated theoretical No of reflections in sphere=', 
     1 nest
      write(nlist,*)' Estimated theoretical No of reflections',
     1 ' in sphere= ', nest
      fracm = min (1., float(nrefop)/float(nest))
c
C-LIST 1
220   CONTINUE
      WRITE(NSCFFL, '(A)')'#LIST 1'
      WRITE(NSCFFL,'(A4,1X,6F10.5)') 'REAL', (CELL(I),I=1,6)
      WRITE(NLIST, '(A)') 'END'
      ESD(4) = ESD(4) * DTR
      ESD(5) = ESD(5) * DTR
      ESD(6) = ESD(6) * DTR
      DO 221 I = 1,6
            ESD(I) = ESD(I)*ESD(I)
221   CONTINUE
C
C-LIST31
      WRITE(NSCFFL, '(A)')'#LIST 31'
      WRITE(NSCFFL, '(A)')'AMULT 1.0'
      WRITE(NSCFFL, 235) (ESD(I),I=1,6)
235   FORMAT('MATRIX V(11)=',F12.10, ' V(22)=',F12.10, ' V(33)=',F12.10
     1 /'CONTINUE V(44)=',F12.10, ' V(55)=',F12.10, ' V(66)=',F12.10)
      WRITE(NSCFFL, '(A)') 'END'
C
C-LIST 2
      WRITE(*,*) 'Space Group Symbol, e.g. P 21 21 21'
      READ(*,'(A)') CCOMP
      WRITE(NSCFFL, '(A)') '#SPACEGROUP'
      WRITE(NSCFFL,'(A,A)')'SYMBOL ', CCOMP
      WRITE(NSCFFL, '(A)') 'END'
C
C
C-LIST 13
      WRITE(NSCFFL, '(A)') '#LIST 13'
      WRITE(NSCFFL,'(A)') 'CONDITIONS WAVELENGTH = 0.71069'
      WRITE(NSCFFL, '(A)') 'END'
C
C-LIST 3
C-LIST 29
      WRITE(*,*) 'Cell Contents, eg C 16 H 10 O 2'
      WRITE(*,*) 'NOTE the spaces between each part of the formula'
      READ(*,'(A)') CCOMP
      WRITE(NSCFFL, '(A)') '#COMPOSITION'
      WRITE(NSCFFL,'(A,A)')'CONTENTS ', CCOMP
      WRITE(NSCFFL,'(A)') 'SCATTERING CRYSDIR:script/scatt.dat'
      WRITE(NSCFFL,'(A)') 'PROPERTIES CRYSDIR:script/propwin.dat'
      WRITE(NSCFFL, '(A)') 'END'
C
C-LIST 30
      WRITE(NSCFFL, '(A)') '#LIST 30'
      WRITE(NSCFFL, 9300) NREFIN, NREFOP, RLIN
9300  FORMAT('DATRED NREFMES= ',I9,' NREFMERG=',I9,' RMERGE= ',F12.4/
     1 'CONTINUE REDUCTION = DENZO ')
C
      WRITE(*,*) 'Crystal dimensions, mm - Min, Med, Max'
      READ(*,*) A,B,C
      WRITE(NSCFFL,240) A,B,C
240   FORMAT ('CONDITION MINSIZE=',F6.3, ' MEDSIZE=',F6.3,
     1 ' MAXSIZE=',F6.3)
      WRITE(NSCFFL,2401) NREFIN, thmax/dtr
2401  FORMAT('CONT NORIENT=',I6,' THORIENTMAX=',F8.2)
      WRITE(NSCFFL,241) 
241   FORMAT('CONT SCANMODE=OMEGA')
      WRITE(*,*) 'Temperature of experiment, Kelvin'
      READ(*,*) A
      WRITE(NSCFFL,242) A
242   FORMAT ('CONT TEMPERATURE=', F8.2)
      WRITE(NSCFFL,'(A)') 'CONT INSTRUMENT=DIP'
C
      WRITE(NSCFFL,244) INDRNG, thmax/dtr
244   FORMAT('INDEXRANGE ', 6I5,' THETAMAX=',F8.2)
C
      WRITE(*,*) 'No of formula units, Z'
      READ(*,*) A
      WRITE(NSCFFL,340) A
340   FORMAT ('GENERAL Z=',F6.3)
C
      WRITE(*,*) 'Crystal Colour'
      READ(*,'(A)') CCOMP
      WRITE(NSCFFL,'(A,A)')'COLOUR ', CCOMP

      WRITE(*,*) 'Crystal Shape'
      READ(*,'(A)') CCOMP
      WRITE(NSCFFL,'(A,A)')'SHAPE ', CCOMP


      WRITE(NSCFFL,'(A)') 'ABSORPTION ABSTYPE = multi-scan'


      WRITE(NSCFFL, '(A)') 'END'
C
      STOP 'Ends Ok'
9900  CONTINUE
      STOP 'Read Error'
      END
