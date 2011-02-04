c outstanding:
c only accepts atom names.
c returns inverse matrix for named atom positions only
c needs to ne scaled by degrees-of-freedom/minimisation-function
c
CODE FOR VCV
      SUBROUTINE VCV
C 
C     CREATE THE vCv MATRIX FOR THE SPECIFIED ATOMS
C--
      INCLUDE 'ICOM12.INC'
C 
      INCLUDE 'ISTORE.INC'
      INCLUDE 'TYPE11.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XSTR11.INC'
C 
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCNTRL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XFLAGS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XWORKA.INC'
C 
      INCLUDE 'QLST12.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QSTR11.INC'
C 
C 
      DATA IVERSN/001/
C 
C--SET UP THE TIMING CONTROL
      CALL XTIME1 (2)
C--PRINT THE PAGE HEADING
      CALL XPRTCN
C--CLEAR THE CORE
      CALL XCSAE
C----- SPACE FOR ATOM HEADERS
      MQ=KSTALL(100)
C----- COMMAND BUFFER
      IDIMBF=50
      ICOMBF=KSTALL(IDIMBF)
C----- ZERO THE BUFFER
      CALL XZEROF (ISTORE(ICOMBF),IDIMBF)
C----- COMMON BLOCK OFFSET(-1) FOR INPUT LIST
      IMDINP=35
C----- INITIALSE LEXICAL PROCESSING
      ICHNG=1
      CALL XLXINI (INEXTD,ICHNG)
      INCLUDE 'IDIM12.INC'
C 
C--MAIN INSTRUCTION CYCLING LOOP
100   CONTINUE
      IDIRNM=KLXSNG(ISTORE(ICOMBF),IDIMBF,INEXTD)
      IF (IDIRNM.LT.0) GO TO 100
      IF (IDIRNM.EQ.0) GO TO 1550
C--NEXT RECORD HAS BEEN LOADED  -  BRANCH ON THE TYPE
C   1.ATOMS  2.execute 3.This Program
      GO TO (250,900,200,150),IDIRNM
150   CONTINUE
      GO TO 1800
C 
200   CONTINUE
c
C--LOAD THE RELEVANT LISTS
      CALL XFAL01
      CALL XFAL02
      IF (IERFLG.LT.0) GO TO 1750
      IULN5=KTYP05(ISTORE(ICOMBF+IMDINP))
      CALL XLDR05 (IULN5)
      IF (IERFLG.LT.0) GO TO 1750
C--LIST READ IN OKAY  -  SET UP THE INITIAL CONTROL FLAGS
C--SET THE FLAG TO INDICATE NO ATOMS STORED AT PRESENT
      NATOM=0
C----- LOAD LIST 12
      JQ=0
      JS=1
C--LOAD LIST 12
      CALL XFAL12 (JS,JQ,JU,JV)
C--LOAD LIST 11
      CALL XFAL11 (1,1)
      IF (IERFLG.LT.0) THEN
         GO TO 1700
      END IF

c      write(ncwu,'(a/,(4i10))') 'List 5',
c     1 L5,M5,MD5,N5, L5A,M5A,MD5A,N5A, 
c     2 L5LSC,M5LSC,MD5LSC,N5LSC, L5O,M5O,MD5O,N5O, 
c     3 L5LS,M5LS,MD5LS,N5LS, L5ES,M5ES,MD5ES,N5ES, 
c     4 L5BS,M5BS,MD5BS,N5BS, L5CL,M5CL,MD5CL,N5CL,
c     5 L5PR,M5PR,MD5PR,N5PR, L5EX,M5EX,MD5EX,N5EX


c      write(ncwu,'(a/,(4i10))') 'List 12',
c     1 L12,M12,MD12,N12, L12A,M12A,MD12A,N12A, 
c     2 L12B,M12B,MD12B,N12B, L12O,M12O,MD12O,N12O, 
c     3 L12LS,M12LS,MD12LS,N12LS, L12ES,M12ES,MD12ES,N12ES, 
c     4 L12BS,M12BS,MD12BS,N12BS, L12CL,M12CL,MD12CL,N12CL,
c     5 L12PR,M12PR,MD12PR,N12PR, L12EX,M12EX,MD12EX,N12EX

c      write(ncwu,'(a/,(4i10))') 'List 11',
c     1 L11,M11,MD11,N11,L11R,M11R,MD11R,N11R, 
c     2 L11P,M11P,MD11P,N11P,L11IR,M11IR,MD11IR,N11IR 


      IF (ISTORE(L11P+15).GE.0) THEN
         IF (ISSPRT.EQ.0) WRITE (NCWU,950)
         WRITE (CMON,950)
         CALL XPRVDU (NCVDU,3,0)
950      FORMAT (' Matrix is wrong type for e.s.d.''s')
         CALL XERHND (IERWRN)
         IESD=-1
         GO TO 1750
      END IF
C--APPLY THE CORRECT MULTIPLICATION FACTOR TO THE MATRIX
      C=STORE(L11P+17)/STORE(L11P+16)
      M11=L11+N11-1
      DO 1000 I=L11,M11
         STR11(I)=STR11(I)*C
1000  CONTINUE
      GO TO 100
C 
C 
C--'ATOM' INSTRUCTION
250   CONTINUE
      LEF1=-1
      LEF=0
      Z=1.
      NATOM=0
      IERR=+1
cdjwdec09 Create an atom stack similar to the D/A stack
      JSTACK = LFL
      ISTACK = JSTACK
      LSTACK = 14   !SHOULD THIS BE THE SAME AS NW LATER?
C--CHECK FOR SOME ARGUMENTS
      IF (KFDARG(I)) 300,400,400
C--ERROR(S)  -  INCREMENT THE ATOM ERROR COUNT
300   CONTINUE
      LEF2=LEF2+1
      IERR=-1
      GO TO 100
C--CHECK IF THERE ARE MORE ARGUMENTS ON THIS CARD
350   CONTINUE
      IF (KOP(8)) 800,400,400
C--CHECK IF NEXT ARGUMENT IS A NUMBER
400   CONTINUE
      IF (KSYNUM(Z)) 500,450,500
450   CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE NEXT GROUP OF ATOMS
500   CONTINUE
C--PROCESS THE OUTPUT FROM THE LEXICAL SCANNER TO FIND
       IF (KATOMU(LN)) 550,550,600
C--ERRORS  -  INCREMENT THE ATOM ERROR COUNT
550   CONTINUE
      LEF2=LEF2+1
      IERR=-1
      GO TO 1500
c
C--MOVE ATOMS TO STACK WITH CORRECT L5 and L12 addresses
600   CONTINUE
      mstart = mq
c      write(ncwu,*) ' '
c      write(ncwu,*) 'm5a=',m5a, ' md5a ', md5a, ' n5a', n5a
c      write(ncwu,*) 'm11a=',m11a, ' md11a ', md11a, ' n11a', n11a
c      write(ncwu,*) 'm12a=',m12a, ' md12a ', md12a, ' n12a', n12a
      m5tmp = m5a
      l12tmp = l12a
620   continue
c      write(ncwu,*) ' '
c      write(ncwu,*) 'Atom stack at mstart=',mstart
c      write(ncwu,*) (istore(mstart+itemp),itemp=0,16)
            istack = istack - lstack
            lfl = lfl - lstack
            istore(istack) = m5tmp
            istore(istack+12) = l12tmp
            call xmovei(istore(mstart+7), istore(istack+2),5)
c      write(ncwu,*)'Dist stack '
c      write(ncwu,*) (istore(istack+itemp),itemp=0,13)

            natom = natom + 1
            mstart = istore(mstart)
            m5tmp = m5tmp + md5a
            l12tmp = l12tmp + md12a
      if (mstart .gt. 0) then
            goto 620
      endif
      GO TO 350
c
800   CONTINUE
      LEF2=LEF2+LEF
C--CHECK THAT THERE IS AT LEAST ONE ATOM ON THIS CARD
      write(ncwu,*) 'natom=', natom
c----- save the start of the stack
      jstack = istack
      lfl = lfl - 1
      IF (NATOM.GE.1) GO TO 100
C--NO ATOMS ON THIS CARD
      CALL XPCLNN (LN)
      IF (ISSPRT.EQ.0) WRITE (NCWU,850)
      WRITE (NCAWU,850)
      WRITE (CMON,850)
      CALL XPRVDU (NCVDU,1,0)
850   FORMAT (' No atoms found')
      GO TO 300
c
c
c
900   CONTINUE
C      'EXECUTE'
      write(ncwu,*) 'Execute.  Natom=', natom
      IF (NATOM.LE.0) GO TO 100
C----- SET NPARAM PER ATOM (3 for x,y,z)
      NPARAM=3
C--SET UP THE SYSTEM FOR E.S.D.'S
      NWPT= NATOM*NPARAM
      NWP = NATOM*NPARAM
      nws = 4
      NW=13
      JU=1
      JV=3
C--SET A FEW AREAS OF CORE FOR E.S.D. CALCLATION
      JA=NFL
      MXPPP=50! MAXIMUM NUMBER OF PARTS PER PARAMETER.
C        JD = JA + NWA * NWS * MXPPP
      JD=JA+NWP*NWS*MXPPP
      NZ=NWPT*NWPT  !NWPT 
      JE=JD+NZ
      JF=JE+NZ
      JG=JF+NZ
      JH=JG
      JJ=JG+NWP*NWP
      JK=JJ
      JM=JJ+NWP*NWP
      JN=JM
      JP=JM+NWPT*NWPT
      JQ=JP
      JPART= JP+NWPT*NWPT
C--COMPUTE THE LENGTH OF THE DATA AREA
      JS=JPART+MXPPP - NFL
C--ALLOCATE THE SPACE
      LN=9
      IREC=1001
      I=KCHNFL(JS)
C 
C--ZERO THE AREA INITIALLY
      CALL XZEROF (STORE(JA),JS)
C----- now loop over the stored atoms
      ISTACK = JSTACK + (natom-1)*lstack
      IPART = JPART
      JB = JA


      DO 1450 I=1,NATOM
      write(ncwu,'(//a,i4)')'Atom No', I
c      write(ncwu,'(7i10,3f12.4,3i10)') istore(istack),
c     1   istore(istack+1),(istore(istack+itmp),itmp=2,6),
c     2   (store(istack+itmp), itmp=7,9),
c     3   istore(istack+10),istore(istack+11),istore(istack+12)


         M12TMP = ISTORE(ISTACK+12)
         jtemp = jb


         CALL XFPCES (M12TMP,JB,NWS,ISTORE(IPART))

12345  format(i3,a,i12,2(a,i12),4x,4i12)

c      write(ncwu,'(a/,(3i10,f5.2))') 'FPCES stack', 
c     1 istore(jtemp),istore(jtemp+1),istore(jtemp+2),store(jtemp+3), 
c     2 istore(jtemp+4),istore(jtemp+5),istore(jtemp+6),store(jtemp+7), 
c     3istore(jtemp+8),istore(jtemp+9),istore(jtemp+10),store(jtemp+11)

1350     CONTINUE
         IPART = IPART + 1
         ISTACK = ISTACK - LSTACK
1450  CONTINUE



C--CALCULATE THE V/CV MATRIX FOR THE POSITIONAL ERRORS

         CALL XCOVAR (JA, NWP, NWS, JD,JE,ISTORE(JPART),NATOM)

      jdjw = jd
      do kdjw = 1, nwp
      write(ncwu,'(/)')
      write(ncwu,'(6G12.4)') 
     1 (store(idjw),idjw=jdjw,jdjw+nwp-1)
      jdjw = jdjw+nwp
      enddo
C 
C 
1500  CONTINUE
      LEF=LEF+1
      CALL XPCA (I)
      GO TO 100
C 
C--MAIN TERMINATION ROUTINES
C 
1550  CONTINUE
      GO TO 1950
C 
1600  CONTINUE
      GO TO 1950
C -- ERRORS
1650  CONTINUE
1700  CONTINUE
      CALL XOPMSG (IOPTLS,IOPABN,0)
      GO TO 1600
C -- INPUT ERRORS
      CALL XOPMSG (IOPTLS,IOPCMI,0)
      GO TO 1650
C 
1750  CONTINUE
C -- ERRORS
      CALL XOPMSG (IOPAXS,IOPABN,0)
      GO TO 1600
1800  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG (IOPAXS,IOPCMI,0)
      GO TO 1750
C 
1850  CONTINUE
C -- INSUFFICIENT SPACE
      CALL XOPMSG (IOPREF,IOPSPC,0)
      GO TO 1700
C--NOT ENOUGH CORE
1900  CONTINUE
      I=0
      J=0
      CALL XSTICA (I,J)
      GO TO 1600
C 
1950  CONTINUE
      CALL XOPMSG (IOPTLS,IOPEND,IVERSN)
      CALL XTIME2 (2)
      CALL XCSAE
      CALL XRSL
      RETURN
      END
