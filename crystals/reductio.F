C $Log: reductio.F,v $
C Revision 1.55  2013/12/06 12:44:52  djw
C Problem spooed by Arie.  RATIO was rouinded to 1 sig fig during packing with JCODE, so that filtering
C by LIST 28 was not compatible with JANA (or any code using more precision).  Also noted that no special
C care was taken if sigmas not input (see SLANT.OUT) In the absence of sigma, RATIO is set to 3.01, ie
C all reflections accepted at 3 sigma level
C
C Revision 1.54  2013/09/19 21:35:39  rich
C Change precision of listing output where not important to reduce differences across platforms.
C Important changes - SFLS now uses builtin cos() and sin() functions rather than Chebyshev
C approximations.
C
C Revision 1.53  2012/10/25 11:19:45  djw
C Only write histogram summary statistics for LIST 6 (not 7)
C
C Revision 1.52  2012/08/09 11:04:09  djw
C A few more bins for the Histogram plotting
C
C Revision 1.51  2012/07/27 15:57:29  djw
C Don't output sums - totals could be very large for a centred cell
C
C Revision 1.50  2012/07/26 14:08:15  djw
C Create file "histogram.dat" containing details of the systematic absences
C
C Revision 1.49  2012/03/20 11:39:46  rich
C Ensure avfc is set if only one contributor during merge.
C
C Revision 1.48  2012/02/17 15:20:24  djw
C Merge Fc with the same weights as Fo and save in output merged list.
C Phase is taken from the root reflection because I dont know how to merge phases
C123
C Revision 1.47  2012/01/04 14:31:25  rich
C Fix some uninitialized variables, and output format mistakes.
C
C Revision 1.46  2011/05/13 11:16:51  djw
C Calls to Kallow now return a key to the test which failed and a value to indicate if it was Max or Min. The argument of KALLOW must be a variable
C
C Revision 1.45  2011/05/03 15:37:24  rich
C Changed calculation of Fo**2 and s(Fo**2) from Fo and s(Fo) to use usual method. Avoid bug where Fo=0.0
C
C Revision 1.44  2011/04/04 09:20:16  djw
C In SYST, load LIST 25 if it exists, else set n25 locally to zero
C
C Revision 1.43  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.42  2010/07/21 16:11:10  djw
C Watch out for twinned centred cells. Originally Fc was obtained by doubling the contributio from the unique operators. This works for the 'presences', but gives non-zero results for the absences.  These must be kept incase a twin element contribution overlaps it.   Treat the left-most element as the parent. However, his leads to problems if the key is, for example, 21. because 2,1 are used to identify the twin scale factor (correclty) but the twin matix (incorreclty).
C
C TO BE SORTED OUT.
C
C Revision 1.41  2010/04/09 16:32:17  djw
C Dont update list 30 Rint if current list is LIST 7 and Rint is already set
C
C Revision 1.40  2008/12/14 17:03:17  djw
C Enable the centric reflections to be identified and counted
C
C Revision 1.39  2009/07/24 14:00:20  djw
C Un-fix patch to avoid controlled warnings - can be done in the script
C
C Revision 1.38  2009/07/22 16:20:11  djw
C Add 0.1 to Rmerge% to avoid totally empty bins, which cause CController warnings
C
C Revision 1.37  2009/07/20 10:41:46  djw
C Restore previous version (without ABS in computing ratio/Jcode).  The recovered RATIO
C  is correct with the original code for +/- Fo values, but JCODE is fouled up for -ve
C  Fos.  Does not look as it it can be fixed retrospectively since values stored in
C  DSC files are invalid
C
C Revision 1.36  2009/07/13 08:35:48  djw
C watch out for -ve Fo values when computing RATIO
C
C Revision 1.35  2009/06/17 13:46:47  djw
C Sort out storage og merge info in LIST 30. Updating only done in MERGE itself
C
C Revision 1.34  2008/12/18 16:36:01  djw
C Don't fiddle with MERGED totals, jus note removed systematic absences
C
C Revision 1.33  2008/03/31 14:54:08  djw
C Move the Friedel flag in SYST into the JCODE slot. Previously (in corrections or phase) it zapped Fourier maps
C
C Revision 1.32  2008/03/07 16:09:48  djw
C changes to help with the correct computation of Fourier maps from twinned crystals.  THe old COPY67 subroutine did not pack the data properly unless the keys were the default keys.  The job is now done
C
C Revision 1.31  2007/11/06 14:38:28  djw
C Connected with #TON
C
C Revision 1.30  2007/11/01 11:05:53  djw
C Store Friedel flag in phase slot in list 7 for Ton
C
C Revision 1.29  2007/10/09 06:59:40  djw
C Adjust calculation of sigmas in merge
C
C Revision 1.28  2006/04/24 13:12:33  djw
C Update Rint etc from LIST 7 for total with Friedels Law
C
C Revision 1.27  2005/11/29 17:59:14  djw
C Add code to permit use of data from multi-batch samples
C
C Revision 1.26  2005/09/08 13:10:56  djw
C Store Rmerge as cif item Rint  (spotted by Andrew)
C
C Revision 1.25  2005/09/08 13:08:37  djw
C Store Rmerge as cif item Rint - spotted by Andrew)
C
C Revision 1.24  2005/06/28 12:59:03  djw
C Enable MERGE to handle twins withiut changing LIST 13
C
C Revision 1.23  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:08  rich
C New CRYSTALS repository
C
C Revision 1.22  2004/10/27 14:42:07  djw
C Supress twinelement flags if the generated reflection is systematically absent
C
C Revision 1.21  2004/06/01 08:01:23  rich
C Still calculate some stats, even if not printing sigma threshold histogram.
C Removed all writes to NCAWU.
C
C Revision 1.20  2004/05/13 13:06:13  rich
C Don't print merging histogram if MERGE/REF LIST=OFF/END is given.
C
C Revision 1.19  2004/05/11 13:15:08  rich
C If merging or 'syst'ing a list 7, don't write new 'mergingr.dat' and 'absences.dat'
C
C Revision 1.18  2004/05/10 11:02:41  rich
C #SYST 7 FRIEDEL=YES FILTER=YES. The new FILTER option removes reflections
C which are not allowed by the List 28 filters. This is important for filters
C which use HKL range or specific OMIT directives, since the FRIEDEL option
C may shift the reflections by symmetry to different indices.
C
C Revision 1.17  2003/09/05 20:09:58  djw
C Gather WORK comments together
C
C Revision 1.16  2003/02/14 17:09:02  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.15  2002/03/12 18:03:13  ckp2
C Fix bug in absences output.
C
C Revision 1.14  2002/03/06 13:50:22  ckp2
C Updated to check6 stuff.
C
C Revision 1.13  2002/03/04 21:57:57  ckp2
C During #SYST, output all absences to a file, absences.dat
C
C Revision 1.12  2002/03/04 13:47:25  ckp2
C During merge, output a file called mergingr.dat for later use.
C
C Revision 1.11  2001/02/26 10:29:09  richard
C Added changelog to top of file
C     H              K              L              /FO/           SQRTW
C     /FC/           PHASE          A-PART         B-PART         TBAR
C     /FOT/          ELEMENTS       SIGMA(/FO/)    BATCH          INDICES
C     BATCH/PHASE    SINTH/L**2     FO/FC          JCODE          SERIAL
C     RATIO          THETA          OMEGA          CHI            PHI
C     KAPPA          PSI            CORRECTIONS    FACTOR1        FACTOR2
C     FACTOR3        RATIO/JCODE    NOTHING
C
C
CODE FOR XLP
      SUBROUTINE XLP
C--APPLICATION OF THE LP CORRECTION
C
C--VARIABLES IN USE :
C
C  A  1/(L CORRECTION)**2 AND THEN 1/LP CORRECTION
C  B  ZETA(N) SQUARED/4
C  C  POLARISATION CORRECTION
C  O  BRAGG ANGLE OF MONOCHROMATOR AND FIRST TERM IN P CORRECTION
C  P  INCIDENT ANGLE OF MONOCHROMATOR AND SECOND TERM IN P CORRECTION
C  T  SIN(THETA) SQUARED
C  U  SIN(THETA)**4
C  W  WAVELENGTH
C  Z  ZETA(1) SQUARED/4
C
C--
      INCLUDE 'ISTORE.INC'
C
      DIMENSION PROCS(3)
      DIMENSION AXIS(3)
      CHARACTER*24 CCAPT(3)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XWORK.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (PROCS(1),ITYP06),(PROCS(2),MEDIUM),(PROCS(3),ISQ)
C
C
      DATA CCAPT / 'Sin(theta) > 1.0' , 'Impossible LP term' ,
     2 'Sin(theta) < (or =) 0.0' /
C
C--SET THE TIMING
      CALL XTIME1(2)
C--READ THE CONTROL DATA
      IF ( KRDDPV ( PROCS , 3 )  .LT. 0 ) GO TO 9910
C--FIND THE TYPE OF LIST 6
      IULN=KTYP06(ITYP06)
C--CLEAR THE STORE
      CALL XRSL
      CALL XCSAE
C--LOAD LIST 1
      CALL XFAL01
C--LOAD LIST 13
      CALL XFAL13
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--SET THE /FO/ SLOT
      IFO=3
      IF(ISTORE(L13CD+1))1150,1100,1100
C--THIS STRUCTURE IS TWINNED
1100  CONTINUE
      IFO=10
C--FIND THE DIFFRACTION TYPE
1150  CONTINUE
      IT=ISTORE(L13DT)
C--FIND THE WAVELENGTH AND MONOCHROMATOR DETAILS
      W=STORE(L13DC)
      O=STORE(L13DC+1)
      P=STORE(L13DC+2)
C--SET UP LIST 6 FOR PROCESSING
      CALL XFLT06(IULN,0)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--CHECK THE TYPE OF OUTPUT MEDIUM
      IF(MEDIUM)1300,1250,1300
C--SAME AS BEFORE  -  SET THE 'MEDIUM' FLAG
1250  CONTINUE
      MEDIUM=ISIGN(1,L6D)
C--SET UP THE OUTPUT PROCESSING
1300  CONTINUE
      CALL XSTR06(IULN,-1,0,1,0)
C--SET THE NUMBER OF REJECTED REFLECTIONS
      N=0
C--SET THE REFLECTION DETAILS INFORMATION
      DO 1350 I=1,MD6
      CALL XIRTAC(I)
1350  CONTINUE
C
C--COMPUTE THE SIN(THETA)/LAMBDA SQUARED TERMS
      X=W*W
      J=L1S+5
      DO 1400 I=L1S,J
      STORE(I)=STORE(I)*X
1400  CONTINUE
C--CHECK IF THIS IS WEISSENBERG GEOMETRY
      IF(IT-4)1450,1500,1500
C--SET THE AXIS DATA
1450  CONTINUE
      CALL XMOVE(STORE(L13AX),AXIS(1),3)
C--COMPUTE THE HEIGHT OF THE FIRST LAYER
      Z=(STORE(L1S)*STORE(L1S+1)*STORE(L1S+2)-(STORE(L1S)*STORE(L1S+3)
     2 *STORE(L1S+3)+STORE(L1S+1)*STORE(L1S+4)*STORE(L1S+4)
     3 +STORE(L1S+2)*STORE(L1S+5)*STORE(L1S+5)-STORE(L1S+3)
     4 *STORE(L1S+4)*STORE(L1S+5))*0.25)
      A=AXIS(1)*AXIS(1)*(STORE(L1S+1)*STORE(L1S+2)-STORE(L1S+3)
     2 *STORE(L1S+3)*0.25)+AXIS(2)*AXIS(2)*(STORE(L1S)*STORE(L1S+2)
     3 -STORE(L1S+4)*STORE(L1S+4)*0.25)
      B=AXIS(3)*AXIS(3)*(STORE(L1S)*STORE(L1S+1)-STORE(L1S+5)
     2 *STORE(L1S+5)*0.25)+AXIS(2)*AXIS(3)*(STORE(L1S+4)*STORE(L1S+5)
     3 *0.5-STORE(L1S)*STORE(L1S+3))
      C=AXIS(1)*AXIS(3)*(STORE(L1S+3)*STORE(L1S+5)*0.5-STORE(L1S+1)
     2 *STORE(L1S+4))+AXIS(1)*AXIS(2)*(STORE(L1S+3)*STORE(L1S+4)
     3 *0.5-STORE(L1S+2)*STORE(L1S+5))
      Z=Z/(A+B+C)
C--SET UP THE POLARISATION CONSTANTS
1500  CONTINUE
      O=O*PI/180.
      P=P*PI/180.
      A=COS(2.*O)
      A=A*A
      B=COS(P)
      B=B*B
      C=SIN(P)
      C=C*C
      D=1./(1.+A)
      O=D*(A*B+C)
      P=D*(A*C+B)
C
C--FETCH THE NEXT REFLECTION
1550  CONTINUE
      IF(KLDRNR(I))2500,1600,1600
C--CHECK IF THIS IS WEISSENBERG DATA
1600  CONTINUE
      IF(IT-4)1650,1700,1700
C--COMPUTE THE LAYER HEIGHT FOR THIS REFLECTION
1650  CONTINUE
      B=AXIS(1)*STORE(M6)+AXIS(2)*STORE(M6+1)+AXIS(3)*STORE(M6+2)
      B=B*B*Z
C--COMPUTE SIN(THETA)**2
1700  CONTINUE
      T=STORE(L1S)*STORE(M6)*STORE(M6)+STORE(L1S+1)*STORE(M6+1)
     2 *STORE(M6+1)+STORE(L1S+2)*STORE(M6+2)*STORE(M6+2)+STORE(L1S+3)
     3 *STORE(M6+1)*STORE(M6+2)+STORE(L1S+4)*STORE(M6)*STORE(M6+2)
     4 +STORE(L1S+5)*STORE(M6)*STORE(M6+1)
C--CHECK THE VALUE OF SIN(THETA)**2
      JFO=IFO+M6
      L=3
      IF(T)1800,1800,1750
1750  CONTINUE
      L=1
      IF(T-1.)1850,1850,1800
C--PRINT OUT THE ERROR MESSAGE
1800  CONTINUE
      CALL XL6RRP ( N , 100 , IFO , CCAPT(L) )
      GOTO  1550
C
C--BRANCH ON THE TYPE OF CORRECTION
1850  CONTINUE
      U=T*T
      GO TO (2300, 2350, 2400, 9915, 2450,
     1 2450 , 2450 , 2450 , 2450 , 9920 ) , IT
      CALL XERHND ( IERPRG )
C
C--COMPUTE THE POLARISATION CORRECTION AND STORE THE REFLECTION
2050  CONTINUE
      C=1.-2.*T
      C=O*C*C+P
      A=A/(C*C)
      L=2
C--CHECK THE LP TERM
      IF(A)1800,1800,2100
C--CHECK IF WE HAVE F'S STORED
2100  CONTINUE
      IF(ISQ)2200,2150,2150
C--F'S ARE STORED  -  TAKE AN INITIAL SQUARE ROOT
2150  CONTINUE
      A=SQRT(A)
C--COMPUTE THE TERMS AND STORE THEM
2200  CONTINUE
      A=SQRT(A)
      STORE(JFO)=STORE(JFO)*A
      STORE(M6+12)=STORE(M6+12)*A
C--STORE THE REFLECTION
      CALL XSLR(1)
C--SET THE REFLECTION DETAILS DATA
      DO 2250 I=1,MD6
      CALL XACRT(I)
2250  CONTINUE
      GOTO 1550
C
C--NORMAL BEAM WEISSENBERG GEOMETRY
2300  CONTINUE
      A=T-U-B
      GOTO 2050
C
C--EQUI-INCLINATION WEISSENBERG GEOMETRY
2350  CONTINUE
      A=T-U-B*(1.-T)
      GOTO 2050
C
C--ANTI-EQUI-INCLINATION GEOMETRY
2400  CONTINUE
      A=T-U-B*T
      GOTO 2050
C
C--4-CIRCLE GEOMETRY
2450  CONTINUE
      A=4.*T*(1.-T)
      GOTO 2050
C
C--END OF THE TAPE  -  TERMINATE THE WRITE
2500  CONTINUE
      DO 2550 I=1,MD6
      CALL XCRD(I)
2550  CONTINUE
      N6D=N6W
      CALL XERT(IULN)
C--SWAP THE OUTPUT
      CALL XSWP06(IULN,MEDIUM)
C -- TERMINATION MESSAGES
      WRITE ( CMON , 2600) N6W, N
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(A)' ) CMON(1)(:)
2600  FORMAT ( 1X , I6 , ' reflections accepted' , 10X , I6 ,
     2 ' reflections rejected' )
C
2610  CONTINUE
      CALL XOPMSG ( IOPLPC , IOPEND , 200 )
      CALL XTIME2(2)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPLPC , IOPABN , 0 )
      GO TO 2610
9910  CONTINUE
C -- INPUT ERROR
      CALL XOPMSG ( IOPLPC , IOPCMI , 0 )
      GO TO 9900
9915  CONTINUE
      WRITE ( CMON ,9916)
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(A)' ) CMON(1)(:)
9916  FORMAT(1X, ' Precession geometry not supported')
9920  CONTINUE
C -- ILLEGAL DIFFRACTION GEOMETRY
      WRITE ( CMON, 9925) IT
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(A)' ) CMON(1)(:)
9925  FORMAT ( 1X , 'Illegal diffraction geometry flag ' , I5 )
      CALL XERHND ( IERERR )
      GO TO 9900
      END
C
CODE FOR XSYST
      SUBROUTINE XSYST
C--CHECK LIST 6 FOR SYSTEMATIC ABSENCES AND COMPUTE A UNIQUE SET OF
C
C--VARIABLES USED BY THIS ROUTINE ARE :
C
C  INDICES FOR EACH REFLECTION, IF REQUIRED.
C
C  ITYP06    THE LIST TYPE BEING PROCESSED.
C  MEDIUM  THE OUTPUT MEDIUM FLAG :
C
C          -1  M/T
C           0  AS INPUT.
C          +1  DISC.
C
C  INDEX   FLAG TO CONTROL THE GENERATION OF UNIQUE INDICES :
C
C          -1  DO NOT GENERATE ANY NEW INDICES.
C           0  GENERATE NEW INDICES.
C
C--
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM30.INC'
C
C
      PARAMETER (NTOT1=7)
      DIMENSION ATOT1(NTOT1), ITOT1(NTOT1), RANGE(NTOT1)
      DIMENSION ATOT2(NTOT1), ITOT2(NTOT1)
CDJW EXTENDED RANGE FOR GRAPHICAL OUTPUT
      PARAMETER (NTOT3=17)
      DIMENSION ATOT3(NTOT3), ITOT3(NTOT3), RANGE3(NTOT3)
      DIMENSION ATOT4(NTOT3), ITOT4(NTOT3)
C
      PARAMETER (NPROCS=5)
      DIMENSION PROCS(NPROCS)
      CHARACTER*24 CCAPT
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST25.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      CHARACTER *12 CFILE
      CHARACTER *13 CFILE2
      DIMENSION JFRN(4), JFRN2(4)
      DATA CFILE / 'absences.dat' /
      DATA CFILE2/ 'histogram.dat' /
#if defined (_HOL_)
      DATA JFRN  /1HF, 1HR, 1HN, 1H1/
      DATA JFRN2 /1HF, 1HR, 1HN, 1H2/
#else
      DATA JFRN  /'F', 'R', 'N', '1'/
      DATA JFRN2 /'F', 'R', 'N', '2'/
#endif
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST30.INC'
C
      EQUIVALENCE (PROCS(1),ITYP06), (PROCS(2),MEDIUM),(PROCS(3),INDEX)
      EQUIVALENCE (PROCS(4), IFRIED),(PROCS(5),IL28)
C
C
C     FIX MAXIMA FROM /FO/MAX
      DATA RANGE /0.,1.,2.,4.,8.,16.,32./
      DATA RANGE3 /-128.,-64.,-32., -16.,-8.,-4.,-2.,-1.,0.,
     1  1.,2.,4.,8.,16.,32.,64.,128./
      DATA CCAPT / 'Systematic absence' /
C
C--SET THE TIMING
      CALL XTIME1(2)
C--READ THE CONTROL DATA
      IF ( KRDDPV ( PROCS , NPROCS )  .LT. 0 ) GO TO 9910
C--FIND THE TYPE OF LIST 6
      IULN=KTYP06(ITYP06)
C--CLEAR THE STORE
      CALL XRSL
      CALL XCSAE
C--SET UP LIST 2 FOR SYSTEMATIC ABSENCE CHECKING
      CALL XFAL02
      IF ( IERFLG .LT. 0 ) GO TO 9900
      M2I=L2I+(N2I-1)*MD2I
C--SET THE /FO/ SLOT
      IFO=3
C--LOAD LIST 13 FOR THE TWIN AND FRIEDEL FLAGS
      CALL XFAL13
      IF (KHUNTR (13,0, IADDL,IADDR,IADDD, -1) . LT. 0) CALL XFAL13
      IF ( IERFLG .LT. 0 ) GO TO 9900
      IF(ISTORE(L13CD+1))1150,1100,1100
C--THIS STRUCTURE IS TWINNED
1100  CONTINUE
      IFO=10
1150  CONTINUE
C--CHECK IF WE SHOULD GENERATE A NEW SET OF INDICES HERE
      IF(INDEX .LT. 0) THEN
            IN = -1
      ELSE
C         WE SHOULD GENERATE A NEW SET OF INDICES
            IF (IFRIED .EQ. 0) THEN
                  IN=ISTORE(L13CD)+2
            ELSE 
                  IN = IFRIED
            ENDIF
      ENDIF
C--SET UP LIST 6 FOR PROCESSING
1250  CONTINUE
      CALL XFLT06(IULN,0)
      CALL XFAL01
      CALL XFAL28
cdjwapr2011
      if (kexist(25) .le. 0) then
        n25 = 0
      else
        call xfal25
      endif 
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--CHECK THE TYPE OF OUTPUT MEDIUM
      IF(MEDIUM)1350,1300,1350
C--SAME AS BEFORE  -  SET THE 'MEDIUM' FLAG
1300  CONTINUE
      MEDIUM=ISIGN(1,L6D)
C--SET UP THE OUTPUT PROCESSING
1350  CONTINUE
      CALL XSTR06(IULN,-1,0,1,0)
      N=0
C--INITIALISE THE INDEX COLLECTION
      DO 1400 I=1,MD6
      CALL XIRTAC(I)
1400  CONTINUE
C----- ACCUMULATORS
      NABSNT = 0
      SUMI = 0.
      SUMSTN = 0.
      DO 1410 I = 1, NTOT1
      ATOT1(I) = 0.0
      ATOT2(I) = 0.0
      ITOT1(I) = 0
      ITOT2(I) = 0
1410  CONTINUE
      DO I=1,NTOT3
      ATOT3(I) = 0.0
      ITOT3(I) = 0
      ATOT4(I) = 0.0
      ITOT4(I) = 0
      ENDDO
C
      IF ( IULN .EQ. 6 ) THEN
        CALL XRDOPN ( 5 , JFRN(1) , CFILE, 12 )
        CALL XRDOPN ( 5 , JFRN2(1) , CFILE2, 13 )
        IF (IERFLG .LE. 0) GOTO 9900               !EXIT ON ERROR
        WRITE(NCFPU1,'(A)')'   H   K   L   Fobs^2/Sigma      Fobs^2'
      END IF
C
C--MAIN REFLECTION READING LOOP
1450  CONTINUE
      IF(KLDRNR(I))1700,1500,1500
1500  CONTINUE
C IF IL28 is zero process normally, otherwise filter using L28 conditions.
      IF ( ( IL28 .NE. 0 ) .AND. ( KALLOW(IALLOW) .LT. 0 ) ) GOTO 1450
C--CHECK IF THIS REFLECTION IS SYSTEMATICALLY ABSENT
      IF(KSYSAB(IN))1550,1600,1600
c
1550  CONTINUE
C--index if systematic absence.   
c  reject it if there is only one component
c^      if (store(l6+11) .le. 9) then
c  CHECK IF IT IS THE FIRST
       NABSNT = NABSNT + 1
       FO = STORE(L6+3)
       SUMI = SUMI + FO
       DO 1560 I = 1,NTOT1-1
         IF (FO .LT. RANGE(I)) THEN
            ATOT1(I) = ATOT1(I) + FO
            ITOT1(I) = ITOT1(I) + 1
            GOTO 1561
         ENDIF
1560   CONTINUE
       ATOT1(NTOT1) = ATOT1(NTOT1) + FO
       ITOT1(NTOT1) = ITOT1(NTOT1) + 1
1561   CONTINUE
C
      DO I=1,NTOT3-1
         IF (FO .LT. RANGE3(I)) THEN
            ATOT3(I) = ATOT3(I) + FO
            ITOT3(I) = ITOT3(I) + 1
            GOTO 1562
         ENDIF
      ENDDO
       ATOT3(NTOT3) = ATOT3(NTOT3) + FO
       ITOT3(NTOT3) = ITOT3(NTOT3) + 1
1562   CONTINUE

c
       CALL XSQRF(FOS, FO, FABS, SIGMAS, STORE(M6+12))
C
       IF(SIGMAS.GT.2.*ZERO) THEN
         SIGRAT = FOS/SIGMAS
       ELSE 
         SIGRAT = FOS/2.*ZERO
       END IF
       IF ( IULN .EQ. 6 ) THEN
        WRITE(NCFPU1,'(3I4,2(1X,F12.3))') (NINT(STORE(L6+I)),I=0,2),
     1                                  SIGRAT,FOS
       END IF
C
       IF (STORE(L6+12) .GE. 2.*ZERO) THEN
         RATIO = FO / STORE(L6+12)
       ELSE
         RATIO = FO / 2. * ZERO
       ENDIF
       SUMSTN = SUMSTN + RATIO*RATIO
       DO  I = 1,NTOT1-1
       IF (RATIO .LT. RANGE(I)) THEN
            ATOT2(I) = ATOT2(I) + RATIO*RATIO
            ITOT2(I) = ITOT2(I) + 1
            GOTO 1563
       ENDIF
      ENDDO
       ATOT2(NTOT1) = ATOT2(NTOT1) + RATIO*RATIO
       ITOT2(NTOT1) = ITOT2(NTOT1) + 1
1563   CONTINUE
C
       DO  I = 1,NTOT3-1
       IF (RATIO .LT. RANGE3(I)) THEN
            ATOT4(I) = ATOT4(I) + RATIO*RATIO
            ITOT4(I) = ITOT4(I) + 1
            GOTO 1564
       ENDIF
      ENDDO
       ATOT4(NTOT3) = ATOT4(NTOT3) + RATIO*RATIO
       ITOT4(NTOT3) = ITOT4(NTOT3) + 1
1564   CONTINUE
C
       CALL XL6RRP(N,1000,IFO,CCAPT)
       GOTO 1450
c^      endif
1600  CONTINUE
C--STORE THE REFLECTION
      CALL XSLR(1)
C--ACCUMULATE THE DETAILS
      DO 1650 I=1,MD6
      CALL XACRT(I)
1650  CONTINUE
      GOTO 1450
C
C--LAST REFLECTION READ
1700  CONTINUE
      DO 1750 I=1,MD6
      CALL XCRD(I)
1750  CONTINUE
      N6D=N6W
      CALL XERT(IULN)
      CALL XSWP06(IULN,MEDIUM)
C
cdjwjul2012
       if (iuln .eq. 6) then
c       write the summary statistics to histogram.dat
        WRITE(NCFPU2,'(A,A)')
     1' Range    number    mean(Fo)    ',
     2'number   Mean(ratio)'

        DO I=1,NTOT3
         if(itot3(i) .gt. 0) then
           avfo = ATOT3(I)/ITOT3(I)
         else 
           avfo = 0.
         endif
         if(itot4(i) .gt. 0) then
           rms = sqrt(ATOT4(I)/ITOT4(I))
         else 
           rms = 0.
         endif
           WRITE(NCFPU2,1755)
     1     RANGE3(I), float(itot3(i)),  AVFO,
     2     FLOAT(itot4(i)),  rms
        enddo
1755  FORMAT(f5.0, 3(f6.0,f10.2))
        I = KFLCLS(NCFPU1)
        I = KFLCLS(NCFPU2)
       endif
C
      CALL XLINES
      IF (NABSNT .GT. 0) THEN
        IF (ISSPRT .EQ.0 )
     1  WRITE(NCWU,1790) NABSNT , SUMI/NABSNT, SQRT(SUMSTN/NABSNT)
1790  FORMAT(I7,' absences, ',
     1 '  mean Fo =', F8.3,',   rms Fo/sigma(Fo)=', F8.3)
CDJWJUL99[
      WRITE(CMON,1790)  NABSNT , SUMI/NABSNT, SQRT(SUMSTN/NABSNT)
      CALL XPRVDU(NCVDU, 1,0)
CDJWJUL99]
      DO 1770 I = 1,NTOT1
      IF (ITOT1(I) .GT. 0) THEN
            ATOT1(I) = ATOT1(I) /ITOT1(I)
      ELSE
            ATOT1(I) = 0.0
      ENDIF
      IF (ITOT2(I) .GT. 0) THEN
            ATOT2(I) = SQRT(ATOT2(I) /ITOT2(I))
      ELSE
            ATOT2(I) = 0.0
      ENDIF
1770  CONTINUE
C
C
      WRITE(CMON,1760) (RANGE(I),I=2,NTOT1-1),
     1 ATOT1, ITOT1,   (RANGE(I),I=2,NTOT1-1), ATOT2, ITOT2
      CALL XPRVDU(NCVDU, 9,0)
      IF (ISSPRT .EQ. 0)  WRITE(NCWU,'(A)') (CMON(I)(:),I=1,9)
1760  FORMAT(/
     1'Fo range       ', '     -ve', 5F8.3,  '  Remainder',/
     2'Mean Fo        ', 7F8.3,/
     3'Number         ', 7I8,//
     *'Fo/sigma range ', '     -ve', 5F8.3,  '  Remainder',/
     4'rms (Fo/sigma) ', 7F8.3,/
     5'Number         ', 7I8,//
     6 )
      ENDIF
      WRITE ( CMON , 1800 ) N6W , N
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU ,'(A)') CMON(1)(:)
1800  FORMAT ( 1X , I6 , ' reflections accepted' , 10X , I6 ,
     2 ' reflections rejected' )
C
CDJWAPR99 UPDATE LIST 30
cdjwjun09 - only for LIST type 6
      if (iuln .eq. 6) then
        IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) . LT. 0) CALL XFAL30
cdjw dec08
c              STORE(L30DR) = max(FLOAT(N6W),STORE(L30DR))
c              STORE(L30DR+2) = min(FLOAT(N6W),STORE(L30DR+2))
c Dont fiddle with the merged totals, just account for systematic 
c absences
CDJWJUN09
              STORE(L30DR) = FLOAT(N6W)
        CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
      ENDIF       
1810  CONTINUE
      CALL XOPMSG ( IOPSSM , IOPEND , 200 )
      CALL XTIME2(2)
      CALL XRSL
      CALL XCSAE
      RETURN

9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPSSM , IOPABN , 0 )
      GO TO 1810
9910  CONTINUE
C -- INPUT ERROR
      CALL XOPMSG ( IOPSSM , IOPCMI , 0 )
      GO TO 9900
C
      END
C
CODE FOR KSYSAB
      FUNCTION KSYSAB(IN)
C--DETECT SYSTEMATIC ABSENCES AND COLLECT CORRECT EQUIVALENTS
C
C  IN  IF 'IN' IS LESS THAN 1, A NEW SET OF INDICES IS NOT COMPUTED.
C      IF 'IN' IS 1, A NEW SET OF INDICES IS COMPUTED, BUT FRIEDEL'S
C      LAW IS NOT USED.
C      IF 'IN' IS 2, A NEW SET OF INDICES IS COMPUTED USING FRIEDEL'S LA
C
cdjw-oct07  Store the Friedel flag in the JCODE slot
C
C--THE NEW SET OF INDICES HAS THE MAXIMUM VALUE OF 'L' FROM AMONGST THE
C  SYMMETRY EQUIVALENT SET. FROM THE REFLECTIONS WITH THIS VALUE OF 'L',
C  THOSE WITH THE MAXIMUM VALUE OF 'K' ARE CHOSEN. FROM AMONGST THESE
C  REFLECTIONS, THE ONE WITH THE LARGEST VALUE FOR 'H' IS CHOSEN.
C
C--THE NEW UNIQUE INDICES ARE PUT BACK AT 'M6', WHERE THE OLD INDICES
C  ARE FOUND ON INPUT.
C
C--
      INCLUDE 'ISTORE.INC'
C
      DIMENSION H(3),HG(3),HMAX(3)
      logical labsent
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST25.INC'
      INCLUDE 'XUNITS.INC'
C
      INCLUDE 'QSTORE.INC'
C
C--CHECK IF THERE ARE ANY NON-PRIMITIVE TRANSLATIONS TO LOOK FOR
c----- store the friedel flag in the JCODE slot
cdjwdec09
c      0 = not part of a pair
c      1 = original index
c      2 = Friedel pair
      store(m6+18) = 0.0
      fried=1.
      afried=fried
      labsent = .false.
      IF(N2P-1)1150,1150,1000
C--CHECK NON-PRIMITIVE CONDITIONS
1000  CONTINUE
      M2P=L2P
      DO 1100 I=1,N2P
       A=ABS(STORE(M2P)*STORE(M6)+STORE(M2P+1)*STORE(M6+1)+STORE(M2P+2)
     2 *STORE(M6+2))
       K=INT(A+0.01)
       IF(A-FLOAT(K) .ge. 0.01)  then
c----- absence
        labsent  = .true.
c
c  for a twinned crystal, we must accept the reflection if any of the 
c  tranformed indices is acceptable
        if (n25 .gt. 0) then
          NJ=NINT(STORE(M6+11))
c
c IF THERE IS NO ELEMENT KEY, SET IT TO MOROHEDRAL TWINNING
          IF (NJ .EQ. 0) NJ = 12 
c 
          NK=NJ  ! FIND THE ELEMENT FOR WHICH THE INDICES ARE GIVEN
          DO WHILE ( NK .GT. 0 ) 
             NL=NK
             NK=NK/10
             LJX=NL-NK*10
             IF ( LJX .LE. 0 ) GO TO 19910    ! CHECK THAT THIS IS A 
             IF ( LJX .GT. N25 ) GO TO 19910  ! VALID ELEMENT NUMBER
          END DO
c
C CHECK IF 'NL' HOLDS THE ELEMENT NUMBER OF THE GIVEN INDICES.
c  Generate the principal indices
c COMPUTE THE INDICES IN THE STANDARD REFERENCE SYSTEM
          M25I=L25I+(NL-1)*MD25I  
          SH=STORE(M25I)*store(m6)+STORE(M25I+1)*store(m6+1)+
     1    STORE(M25I+2)*store(m6+2)
          SK=STORE(M25I+3)*store(m6)+STORE(M25I+4)*store(m6+1)+
     1    STORE(M25I+5)*store(m6+2)
          SL=STORE(M25I+6)*store(m6)+STORE(M25I+7)*store(m6+1)+
     1    STORE(M25I+8)*store(m6+2)
          ish = nint(sh)
          isk = nint(sk)
          isl = nint(sl)
          sh = float(ish)
          sk = float(isk)
          sl = float(isl)
c      write(ncpu,1111) 'Given ', store(m6), store(m6+1), store(m6+2),
c     1 ' Parent', sh,sk,sl, ' Element', nj
1111  format(a,3f8.1,a,3f8.1, a,i4)
c
          NK=NJ  ! RESET THE FLAGS FOR THIS GROUP OF TWIN ELEMENTS, e.g. 1234
c          CHECK IF THERE ARE ANY MORE ELEMENTS TO PROCESS
          DO WHILE ( NK .GT. 0 ) 
             LJX=NK      ! FETCH THE NEXT ELEMENT
             NK=NK/10                                           ! e.g. 123
             NL=LJX-NK*10                                        ! e.g. 1234-1230 = 4
             M25=L25+(NL-1)*MD25   ! COMPUTE THE INDICES FOR THIS COMPONENT
             ph=FLOAT(NINT(STORE(M25)*SH
     2                    +STORE(M25+1)*SK+STORE(M25+2)*SL))
             pk=FLOAT(NINT(STORE(M25+3)*SH
     2                      +STORE(M25+4)*SK+STORE(M25+5)*SL))
             pl=FLOAT(NINT(STORE(M25+6)*SH
     2                      +STORE(M25+7)*SK+STORE(M25+8)*SL))
c
c  check if the current reflection is a centring absence
             IF(N2P .gt. 1)then
C  CHECK NON-PRIMITIVE CONDITIONS, skipping the identity
              MM2P=L2P+3
              sysabs: DO II=2,N2P
               qh = store(mm2p+0)*ph
               qk = store(mm2p+1)*pk
               ql = store(mm2p+2)*pl
               A=ABS(qh+qk+ql)
               K=INT(A+0.01)
               IF(A-FLOAT(K) .lt.0.01) then
                  labsent = .false.
c even just one 'present' absence means we have to keep the reflection
                  goto 1150
               else
               endif
               mm2p=mm2p+3
              enddo sysabs
             endif
          END DO  
          endif
        endif
1050  CONTINUE
       M2P=M2P+3
1100  CONTINUE
      if (labsent) then
            goto 2100        
      endif
c
c
c  no centring conditions
1150  CONTINUE
c
c
C--SET DEFAULT VALUES FOR THE INDICES AND TRANSFORMED INDICES
      K=M6
      DO 1200 I=1,3
      H(I)=STORE(K)
      HMAX(I)=H(I)
      K=K+1
1200  CONTINUE
C--PASS THROUGH THE DIFFERENT SYMMETRY POSITIONS
      DO 1950 I=L2I,M2I,MD2I
C--CALCULATE THE TRANFORMED INDICES
      HG(1)=H(1)*STORE(I)+H(2)*STORE(I+3)+H(3)*STORE(I+6)
      HG(2)=H(1)*STORE(I+1)+H(2)*STORE(I+4)+H(3)*STORE(I+7)
      HG(3)=H(1)*STORE(I+2)+H(2)*STORE(I+5)+H(3)*STORE(I+8)
C--CHECK IF THE INDICES ARE THE SAME
      J=IC
      DO 1250 K=1,3
      IF(NINT(H(K)-HG(K)))1350,1250,1350
1250  CONTINUE
C--THE INDICES ARE THE SAME  -  CHECK THE PHASE SHIFT
1300  CONTINUE
      A=ABS(H(1)*STORE(I+9)+H(2)*STORE(I+10)+H(3)*STORE(I+11))
      K=INT(A+0.01)
      IF(A-FLOAT(K)-0.01)1350,2100,2100
C--THIS REFLECTION IS ALLOWED  -  CHECK FOR ANOTHER TEST
1350  CONTINUE
      IF(J)1500,1500,1400
C--CENTRE OF SYMMETRY  -  CHECK THE INVERTED INDICES
1400  CONTINUE
      J=J-1
      DO 1450 K=1,3
      IF(NINT(H(K)+HG(K)))1500,1450,1500
1450  CONTINUE
      GOTO 1300
C--CHECK IF WE SHOULD GENERATE A NEW SET OF INDICES
1500  CONTINUE
      IF(IN)1950,1950,1550
C--CHECK IF THESE ARE GOOD TRANSFORMS FOR OUTPUT
1550  CONTINUE
      DO 1900 J=1,IN
      IF(NINT(HG(3)-HMAX(3)))1800,1600,1700
1600  CONTINUE
      IF(NINT(HG(2)-HMAX(2)))1800,1650,1700
1650  CONTINUE
      IF(NINT(HG(1)-HMAX(1)))1800,1800,1700
1700  CONTINUE
C--THIS SET IS A BETTER SET  -  STORE THEM
      isav = i
      DO 1750 K=1,3
      HMAX(K)=HG(K)
1750  CONTINUE
      fried=2.
C--INVERT THE INDICES FOR THE NEXT POSSIBLE PASS
1800  CONTINUE
      DO 1850 K=1,3
      HG(K)=-HG(K)
1850  CONTINUE
1900  CONTINUE
1950  CONTINUE
      afried=fried
cdjwmar2011
c---- transform phase, A and B parts
c     seems to be OK for orthorhombic. Needs checking
c     for hexagonal etc.
c       determ = xdetr3(store(isav))
c       parity = hmax(1)+hmax(2)+hmax(3)
c       parity = sign(1.,parity)
c      write(ncawu,'(3f5.0,3x,3f5.0, 2f6.3,3f8.3 )') 
c     1 hmax(1),hmax(2),hmax(3), store(m6),store(m6+1),store(m6+2),
c     2 determ,parity, store(m6+6), store(m6+7),store(m6+8)
c       if (determ .lt. 0) then
c         store(m6+6) = -1.*store(m6+6)
c         if(parity .gt. 0) then
c             store(m6+7) = -store(m6+7)
c         else
c             store(m6+8) = -store(m6+8)
c         endif
c       endif
c      write(ncawu,'(3f5.0,3x,3f5.0, 2f6.3,3f8.3 )') 
c     1 hmax(1),hmax(2),hmax(3), store(m6),store(m6+1),store(m6+2),
c     2 determ,parity, store(m6+6), store(m6+7),store(m6+8)
cdjwmar2011
C--WRITE THE NEW INDICES BACK IN LIST 6
      K=M6
      DO 2000 I=1,3
      STORE(K)=HMAX(I)
      K=K+1
2000  CONTINUE
c      write(ncwu,'(3f4.0, 4f10.4,2i6)') hmax, store(m6+6),
c     1 store(m6+13), store(m6+15), afried, ic, in
c----- store the friedel flag in the JCODE slot
c      0 = not part of a pair
c      1 = original index
c      2 = Friedel pair
      store(m6+18) = afried
      KSYSAB=0
2050  CONTINUE
      RETURN
C
C--THIS IS A REJECTED REFLECTION
2100  CONTINUE
      KSYSAB=-1
      GOTO 2050
19910 continue
      stop 'panic'
      END
C
CODE FOR KCENTR
      FUNCTION KCENTR(IN)
C--DETECT SYSTEMATIC ABSENCES DUE TO CENTRING OPERATORS
C      RETURNS -1 FOR AN ABSENT REFLECTION AT M6 ETC
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'QSTORE.INC'
C
      KCENTR=0
C--CHECK IF THERE ARE ANY NON-PRIMITIVE TRANSLATIONS TO LOOK FOR
      IF(N2P-1)1150,1150,1000
C--CHECK NON-PRIMITIVE CONDITIONS
1000  CONTINUE
      M2P=L2P
      DO 1100 I=1,N2P
        A=ABS(STORE(M2P)*STORE(M6)+STORE(M2P+1)*STORE(M6+1)+
     2                             STORE(M2P+2)*STORE(M6+2))
        K=INT(A+0.01)
        IF(A-FLOAT(K)-0.01)1050,2100,2100
1050    CONTINUE
        M2P=M2P+3
1100  CONTINUE
1150  CONTINUE
      RETURN
C
C--THIS IS A REJECTED REFLECTION
2100  CONTINUE
      KCENTR=-1
      GOTO 1150
      END
C
C
CODE FOR WMERGE
      SUBROUTINE WMERGE
C--MAIN MERGING ROUTINES  -  READS FROM 6 AND OUTPUTS TO M/T
C  INITIALLY.
C
C  NBUF   NUMBER OF WORDS PER REFLECTION IN THE INPUT BUFFER (=MD6)
C  NTERM  NUMBER OF WORDS PER REFLECTION IN THE CORE AREA (=MD6+4)
C
C--THE FORMAT OF THE CORE AREA ENTRIES IS :
C
C  0 TO (MD6-1) CONTAIN THE INPUT VALUES FROM M/T OR TAPE. THE WORDS
C               FROM 'MD6' ONWARDS ARE ARRANGED AS FOLLOWS :
C
C  NTERM-4 JCODE AS AN INTEGER
C  NTERM-3 SERIAL NUMBER AS AN INTEGER
C  NTERM-2 'E' PARAMETER
C  NTERM-1 WEIGHT FOR THIS REFLECTION
C
C
C  DATE            VERSION     BY    CHANGE
C  ----            -------     --    ------
C  DECEMEBER 1984  4.01        PWB   CHANGE STATISTICS PRINTING, TO
C                                    INCLUDE MONITOR OUTPUT
C  MAY       1987  4.03        DJW   OUT PUT SHELDRICK MERGING R
C  MAY       1988  4.54        DJW   CHECK FINAL SUMS
C  SEPT      1995     5.00         DJW   TREATMENT UF -VE REFLECTIONS
C
C--
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM30.INC'
C
      DIMENSION PROCS(18)
C
      INCLUDE 'STORE.INC'
C
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      COMMON /XMRG/WORK(30),ISTAT(100), RINT(6), RINTF(400)
      COMMON /XMRGA/ITYP06,MEDIUM,NSCH,NCYC,ICT,JCT,NCT,ITEMP1,ICODE,
     2 JCODE,MDCODE,NCODE,CHOP,NCHOP,IPRINT,APRINT,ISQ,IMTWIN,IBUF,
     3 JBUF,NBUF,ITEMP2,IREF,JREF,NTERM,NREF,NEND,IFO,JFO,ITWIN,
     4 N6DEAD,N6CTMP,N6RTMP,JPRINT,NPRINT
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      CHARACTER *12 CFILE
      DIMENSION JFRN(4)
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST30.INC'
      EQUIVALENCE (PROCS(1),ITYP06)
      SAVE
C
      DATA IVERSN / 500 /
      DATA CFILE / 'mergingr.dat' /
#if defined (_HOL_)
      DATA JFRN /1HF, 1HR, 1HN, 1H1/
#else
      DATA JFRN /'F', 'R', 'N', '1'/
#endif
C
C
C
C
C--SET THE TIMING
      CALL XTIME1(2)
C--READ THE CONTROL DATA
      IF ( KRDDPV ( PROCS,18 )   .LT.   0 ) GO TO 9910
C--FIND THE TYPE OF LIST 6
      IULN=KTYP06(ITYP06)
C--SET THE END OF THE JCODE ARRAY
      JCODE=ICODE+(NCODE-1)*MDCODE
C--SET UP LIST 6 FOR THE I/O OPERATIONS
      CALL XFLT06(IULN,0)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--CHECK THE TYPE OF OUTPUT MEDIUM
cdjwmay99
c      write(ncawu,*) 'medium=',medium,'iuln=',iuln
      IF(MEDIUM)1150,1100,1150
C--SAME AS BEFORE  -  SET THE 'MEDIUM' FLAG
1100  CONTINUE
      MEDIUM=ISIGN(1,L6D)
C--SET UP THE OUTPUT PROCESSING
1150  CONTINUE
      CALL XSTR06(IULN,-1,0,1,0)
C--PRESERVE THE NUMBER OF INPUT CONTRIBUTORS
      N6RTMP=N6R
C--ZERO THE NUMBER OF REJECTED CONTRIBUTORS
      N6CTMP=0
C--SET THE NUMBER OF REJECTED REFLECTIONS
      N6DEAD=0
C--SET THE REFLECTION DETAILS INFORMATION
      DO 1200 I=1,MD6
      CALL XIRTAC(I)
1200  CONTINUE
C--SET THE NUMBER OF PRINTED REFLECTIONS TO ZERO
      NPRINT=0
C--SET UP THE DEFAULT CONSTANTS
      NBUF=MD6
      IBUF=NFL
C--ALLOCATE SPACE FOR THE INPUT BUFFER
      LN=6
      IREC=4001
      JBUF=KCHNFL(NBUF)
C--SET UP THE LENGTH OF EACH EQUIVALENT WHILE IT IS IN CORE
      NTERM=MD6+4
C--LOAD LIST 13
      CALL XFAL13
      IF ( IERFLG .LT. 0 ) GO TO 9900


cdjwjun05
C IMTWIN INDICATES IF THE DATA ARE TO BE REGARDED AS TWINNED DURING
C THE MERGE
C -1 = NOT TWINNED, 0 USE LIST 13 VALUE, +1 = TWINNED
      if (imtwin .eq. 0) then 
            imtwin=ISTORE(L13CD+1)
      else
            if (imtwin .eq. 1) imtwin = 0
      endif
C--SET THE /FO/ SLOT
      IFO=3
      ITWIN=-1
cdjwnov05
c----- try to sort out batch scales
c
c----- CHECK IF BATCH KEYS ARE SET
      IBCH=KCOMP(1,M6+13,ISTORE(L6DMP),MD6DMP,1)
      IF ((IMTWIN .EQ. 0) .AND. (IBCH .NE. 0))THEN
        WRITE(CMON,'(A)') 'Multi-batch twinned data cannot be handled'
        CALL XPRVDU(NCVDU, 1,0)
        GOTO 9900
      ENDIF
      IF(IBCH .NE. 0) THEN
C----- SET UP BATCH SCALES TO LOOK LIKE ELEMENT SCALES
        ITWIN = IBCH
        IREC=4002
        ITWINL=KCHLFL(NTERM)
      ENDIF
      IF(IMTWIN)1300,1250,1250
C--THIS STRUCTURE IS TWINNED
1250  CONTINUE
      IFO=10
      ITWIN=11
      IREC=4002
      ITWINL=KCHLFL(NTERM)
1300  CONTINUE

C--CLEAR THE INTENSITY STATISTICS AREA
      CALL XZEROF(RINT,6)
      CALL XZEROF(RINTF,400)
      DO 1350 I=1,100
      ISTAT(I)=0
1350  CONTINUE
      DO 1400 I=1,30
      WORK(I)=0.
1400  CONTINUE
C--SET UP THE CORRECT WEIGHTING PARAMETERS INTERNALLY
      CALL WWT
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--SET UP THE INPUT BUFFER KEYS
      KA=IBUF+NBUF-1
      KB=IBUF+2
C--SET UP THE CORE BUFFER FLAGS
      IREF=NFL
      JREF=IREF
      NREF=0
      NEND=0
      IF(IPRINT)1550,1450,1450
C--PRINT THE CAPTIONS
1450  CONTINUE
      CALL XPRTCN
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1500)
1500  FORMAT(4X,'H',3X,'K',3X,'L',2X,'F-squared',4X,'rmsdev',4X,
     2 '<sigma>',7X,'F-squared',5X,'Sigma',5X,'Delta',3X,'E-param',4X,
     3 'Weight',3X,'JCODE',4X,'Serial'/)
C
C--CHECK IF THERE ARE ANY REFLECTIONS
1550  CONTINUE
      IF(KLDRNR(I))3800,1700,1700
C--FETCH THE NEXT REFLECTION
1600  CONTINUE
      IF(KLDRNR(I))1650,1700,1700
C--END LIST 6 INPUT
1650  CONTINUE
      NEND=1
      GOTO 2250
C--CHECK THAT TOO MANY REFLECTIONS HAVE NOT BEEN READ
1700  CONTINUE
      IF(JREF+NTERM-LFL)1850,1850,1750
1750  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1800)
      ENDIF
1800  FORMAT(//,' Too many equivalents for the given core')
      GOTO 4300
C--TRANSFER THE REFLECTION TO THE FIRST INPUT BUFFER
1850  CONTINUE
      CALL XMOVE(STORE(M6),STORE(IBUF),NBUF)
C--FIX THE INDICES
      DO 1900 I=IBUF,KB
      ISTORE(I)=NINT(STORE(I))
1900  CONTINUE
C--FIRST REFLECTION THIS INDEX ?
      IF(NREF)1950,1950,2100
C--MOVE THE REFLECTION FROM THE INPUT TO THE CORE BUFFER
1950  CONTINUE
      KREF=JREF
      CALL XMOVE(STORE(IBUF),STORE(JREF),NBUF)
      JREF=JREF+NTERM
      NREF=NREF+1
C--CHECK IF WE HAVE /FO/ OR /FO/ **2 STORED
      IF(ISQ)2050,2000,2000
C--/FO/ STORED  -  CONVERT TO /FO/ **2
2000  CONTINUE
cdjwmay99 - we should use the proper routine for this! ^
      JFO=KREF+IFO
      TEMPFO = STORE(JFO)
c      TEMP = ABS(STORE(JFO))
c      STORE(KREF+12)=2.*TEMP*STORE(KREF+12)
c      STORE(JFO)=STORE(JFO)*TEMP
CRICmay11 - let's use the proper routine now!
      TEMPFOS = STORE(KREF+12)
      CALL XSQRF(STORE(JFO), TEMPFO, FABS, STORE(KREF+12), TEMPFOS)
C--FIX THE SERIAL AND JCODE
2050  CONTINUE
      ISTORE(JREF-4)=NINT(STORE(IBUF+18))
      ISTORE(JREF-3)=NINT(STORE(IBUF+19))
C--SET THE 'E' PARAMETER
      STORE(JREF-2)=0.
C--DEFAULT THE WEIGHT TO UNITY
      STORE(JREF-1)=1.
      GOTO 1600
C--NOT THE FIRST REFLECTION  -  CHECK IF IT HAS THE SAME INDICES
2100  CONTINUE
      IF(ISTORE(IBUF)-ISTORE(IREF))2250,2150,2250
2150  CONTINUE
      IF(ISTORE(IBUF+1)-ISTORE(IREF+1))2250,2200,2250
2200  CONTINUE
      IF(ISTORE(IBUF+2)-ISTORE(IREF+2))2250,1950,2250
C
C--ALL THE REFLECTIONS WITH COMMON INDICES ARE IN CORE  -  CHECK THE JCO
2250  CONTINUE
      IF(NCODE)2700,2700,2300
C--ELIMINATE ANY REFLECTIONS WITH ZERO WEIGHT ASSIGNED TO THEIR JCODES
2300  CONTINUE
      I=IREF
      J=IREF
      K=NREF
      N6CTMP=N6CTMP+NREF
      NREF=0
C--CHECK THE NEXT CONTRIBUTING REFLECTION
2350  CONTINUE
      DO 2450 N=ICODE,JCODE,MDCODE
      L=I+NTERM
      IF(ISTORE(L-4)-ISTORE(N))2450,2400,2450
C--CHECK IF THIS JCODE HAS ZERO WEIGHT
2400  CONTINUE
      IF(STORE(N+1)-0.0001)2600,2450,2450
2450  CONTINUE
C--THIS REFLECTION IS ALLOWED  -  MOVE IT UP
      IF(I-J)2500,2550,2500
C--MOVEMENT IS NECESSARY
2500  CONTINUE
      CALL XMOVE(STORE(I),STORE(J),NTERM)
C--UPDATE THE POINTERS
2550  CONTINUE
      I=I+NTERM
      J=J+NTERM
      NREF=NREF+1
      N6CTMP=N6CTMP-1
      GOTO 2650
C--INCREMENT THE ADDRESS FOR A REJECTED REFLECTION
2600  CONTINUE
      I=I+NTERM
C--CHECK IF THERE ARE MORE REFLECTIONS TO PROCESS
2650  CONTINUE
      K=K-1
      IF(K)2700,2700,2350
C--CHECK IF THERE ARE ANY REFLECTIONS LEFT TO CONTRIBUTE
2700  CONTINUE
      IF(NREF)3700,3700,2750
C
C--ONE OR MORE THAN ONE CONTRIBUTOR
2750  CONTINUE
      KD=0
      EE=-1.
C--CHECK IF THIS IS TWINNED DATA
      IF(ITWIN)3350,2800,2800
C--REARRANGE THE DATA IN THE STACK
2800  CONTINUE
      KD=NREF
      K=IREF+ITWIN
      EE=STORE(K)
      GOTO 2950
C--MARK THE LAST LOT OF REFLECTIONS AS USED
2850  CONTINUE
      J=IREF+ITWIN
      DO 2900 I=1,NREF
      STORE(J)=-1.
      J=J+NTERM
2900  CONTINUE
      K=IREF+ITWIN
C--SEARCH FOR ANY OTHER UNUSED REFLECTIONS
2950  CONTINUE
      L=K
      NREF=0
      FE=EE
      EE=-1.
      DO 3300 I=1,KD
      IF(ABS(FE-STORE(K))-.5)3000,3150,3150
C--WE HAVE ANOTHER TO MATCH THE ORIGINAL
3000  CONTINUE
      NREF=NREF+1
C--CHECK IF THE REFLECTION NEEDS MOVING TO THE TOP
      IF(L-K)3100,3050,3100

3050  CONTINUE
      L=L+NTERM
      GOTO 3250

C--MOVE THE REFLECTION
3100  CONTINUE
      K=K-ITWIN
      L=L-ITWIN
      CALL XMOVE(STORE(L),STORE(ITWINL),NTERM)
      CALL XMOVE(STORE(K),STORE(L),NTERM)
      CALL XMOVE(STORE(ITWINL),STORE(K),NTERM)
      K=K+ITWIN+NTERM
      L=L+ITWIN+NTERM
      GOTO 3300

C--CHECK IF THIS REFLECTION HAS ALREADY BEEN MERGED
3150  CONTINUE
      IF(STORE(K))3250,3250,3200
C--RECORD ITS VALUE
3200  CONTINUE
      EE=STORE(K)

3250  CONTINUE
      K=K+NTERM
3300  CONTINUE

C--CALL THE MERGE ROUTINES
3350  CONTINUE
      IF(KMERGE(I))3700,3400,3400

C--OUTPUT THE REFLECTION
3400  CONTINUE
      CALL XMOVE(STORE(IREF),STORE(M6),NBUF)
      ITEMP1=M6+2
      DO I=M6,ITEMP1
         STORE(I)=FLOAT(ISTORE(I))
      END DO
C--ASSIGN THE NEW VALUES OF /FO/ **2 AND SIGMA
      JFO=M6+IFO
      STORE(JFO)=WORK(5)
      STORE(M6+12)=WORK(NCHOP+8)
cdjw2012
      STORE(M6+5) = WORK(7)
      STORE(M6+6) = WORK(8)

      JRINTF = 100
      IF ( ABS ( STORE(M6+12) ) .GE. 0.0005 ) 
     1           JRINTF = 1+ NINT(2.*STORE(JFO)/STORE(M6+12))
      JRINTF = MIN ( 100, JRINTF )
      JRINTF = MAX ( 1 , JRINTF )
      RINTF(JRINTF+300)= RINTF(JRINTF+300)+ 1.0

C--CHECK IF THIS IS ONLY ONE CONTRIBUTOR
      IF(NREF-1)3500,3500,3450

C--MORE THAN ONE CONTRIBUTOR  -  ZERO THE WEIGHT AND BATCH
3450  CONTINUE
      STORE(M6+4)=0.
      IF (IBCH .EQ. 0) STORE(M6+13)=0.
C----- STORE THE MINIMUM JCODE
      STORE(M6+18) = WORK(29)
C--ZERO THE REMAINING CONSTANTS
      CALL XZEROF(STORE(M6+17),N6DTL-17)
C----- ENSURE CORRECTIONS ARE UNITY
      STORE(M6+27) = 1.0

C--CHECK IF WE MUST TAKE THE SQUARE ROOT
3500  CONTINUE
      IF(ISQ)3600,3550,3550
3550  CONTINUE
      CALL XSQRT(STORE(JFO), FSIGN, FABS, STORE(M6+12), SIG)
      STORE(JFO) = FSIGN
      STORE(M6+12) = SIG
cdjwmay99 - store the goodie in /FO/ as well for twinned
      if (itwin .EQ. 11) store(m6+3) = store(jfo)
C--STORE THE REFLECTION
3600  CONTINUE
C----- COMPUTE NEW 'RATIO'
c Oct 2013  Compute RATIO on F^2
       call xsqrf(fdjw,store(jfo),adjw,sdjw,store(m6+12))
       store(m6+20) = min(128., (fdjw/sdjw))
      CALL XSLR(1)
C--ACCUMULATE THE REFLECTION DETAILS INFORMATION
      DO 3650 I=1,MD6
      CALL XACRT(I)
3650  CONTINUE

C--CHECK FOR ANOTHER TWIN ELEMENT
3700  CONTINUE
      IF(EE)3750,3750,2850
C--RESET THE POINTERS AND CHECK FOR THE END OF THE DATA
3750  CONTINUE
      NREF=0
      JREF=IREF
      IF(NEND)1950,1950,3800
C
C--END OF THE TAPE  -  TERMINATE THE WRITE
3800  CONTINUE
      DO 3850 I=1,MD6
      CALL XCRD(I)
3850  CONTINUE
      N6D=N6W
      CALL XERT(IULN)
C--AND NOW GENERATE THE OUTPUT FILE IF NECESSARY
cdjwmay99
      call xswp06(iuln,medium)
C--PRINT THE REFLECTION STATISTICS PROFILE
      CALL WSTAT(N3SIG, PC3SIG)
C
C
C--PRINT THE REFLECTION TOTALS
      IF (ISSPRT .EQ. 0)
     1 WRITE(NCWU,3900)N6RTMP,N6CTMP,N6W,N6DEAD,NPRINT,APRINT
3900   FORMAT(
     * I6,' Contributors input       ',
     2 I6,' Contributors rejected'/
     3 I6,' Merged reflections output',
     4 I6,' Merged reflections rejected'/
     5 I6,' Contributors deviating from',
     6 ' the average by more than ',
     7 F5.1, 'e.s.ds' )
      WRITE ( CMON , 3905 ) N6W , N6DEAD
      CALL XPRVDU(NCVDU, 1,0)
3905  FORMAT ( 1X , I6 , ' merged reflections output' , 5X , I6 ,
     2 ' merged reflections rejected' )
      WRITE ( CMON , 4048) N3SIG, PC3SIG
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') CMON(1)(:)
4048  FORMAT(I6,' Reflections greater than 3 sigma(i),',
     1 F8.3, ' percent of data')
C
C----- COMPUTE AVERAGES
C
      IF ((WORK(26)) .LE. ZERO) THEN
            WORK(25)= 0.
      ELSE
            WORK(25)= WORK(25)/WORK(26)
      ENDIF
      IF ((WORK(27)) .LE. ZERO) THEN
            WORK(28)=0.
      ELSE
            WORK(28)= SQRT(WORK(28)/WORK(27) )
      END IF
C
      WRITE(CMON,4049) WORK(25),WORK(28)
      CALL XPRVDU(NCVDU, 2,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') (CMON(I)(:),I=1,2)
4049  FORMAT(
     1 ' Rint = [Sum(/Fsq-<Fsq>/)/sum(Fsq)]                  = '
     1  ,F6.3/
     1 ' Rmerge   = SQRT[ sum[w(Fsq-<Fsq>)**2] / sum[w<Fsq>**2]] = '
     1  ,F6.3)
C
      DO 4100 I = 1,3
      IF (ABS(RINT(I)) .GT. ZERO) RINT(I) = (RINT(I+3)/RINT(I))
4100  CONTINUE
      WRITE(CMON, 4104) (RINT(I),I=1,3)
      CALL XPRVDU(NCVDU, 2,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') (CMON(I)(:),I=1,2)
4104  FORMAT(
     1 ' Rint for I>10sigma,  10sigma>I>2sigma,    I<2sigma'/
     2 2X,F18.3, F16.3, F15.3)

      IF ( IULN .EQ. 6 ) THEN
        CALL XRDOPN ( 5 , JFRN(1) , CFILE, 12 )
        IF (IERFLG .LE. 0) GOTO 9900               !EXIT ON ERROR
        WRITE(NCFPU1,'(A)')'Rmerge%  Rint%'
        WRITE(NCFPU1,'(2F8.2)')WORK(25)*100.,WORK(28)*100.
        WRITE(NCFPU1,'(A)')'F2/sigma(F2)  Rmerge%    Observations'

        NTOT = 0
        DO I = 301,400
          NTOT = NTOT + NINT(RINTF(I))
        END DO
        DO I = 1,100
          IF(ABS(RINTF(I)) .GT. ZERO) RINTF(I) = (RINTF(I+100)/RINTF(I))
cdjwjul09 DO NOT add a bit to Rint to avoid zero entries in the graphs.
c  jul09  Now fixed in the SCRIPTS XCHECK6 and XRMERGE
          WRITE (NCFPU1,'(F4.1,3X,F15.7,3X,2I8)')
     1    (I-1)/2.0, RINTF(I)*100., NINT(RINTF(I+200)), NTOT
          NTOT = NTOT - NINT(RINTF(I+300))
        END DO
        I = KFLCLS(NCFPU1)
      END IF
C
C----- LOAD DATA IF LIST 30 NOT ALREADY IN CORE
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL30
      IF (KHUNTR (13,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL13
      IF (IERFLG .LT. 0) GOTO 6520
cdjwjun09 do for list 6
      if (iuln .eq. 6) then
c----Sep05  Store Rmerge (25) as Rint for cif compatibility
         IF (ISTORE(L13CD) .EQ. -1) THEN
C------- FRIEDEL NOT USED
            STORE(L30DR+2) = FLOAT(N6W)
            STORE(L30DR+3) = WORK(25)
         ELSE
            STORE(L30DR+4) = FLOAT(N6W)
            STORE(L30DR+5) = WORK(25)
         ENDIF
      endif
cdjwjun09 assume Friedel used if list is type 7 (we dont
c have access to the IFRIED variable on SYST)
cdjwapr2010 - dont fiddle with List 30 if values already set
      if ((iuln .eq. 7) .and. (store(l30dr+4) .le. zero)) then
            STORE(L30DR+4) = FLOAT(N6W)
            STORE(L30DR+5) = WORK(25)
      endif
      CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
 6520 CONTINUE
      IF(N6D)4200,4200,4150
4150  CONTINUE
C--AND NOW THE TERMINATION MESSAGES
4200  CONTINUE
      CALL XOPMSG ( IOPMER , IOPEND , IVERSN )
      CALL XTIME2(2)
      RETURN
C
C--TERMINATE BECAUSE OF ERRORS
4300  CONTINUE
      CALL XERHND ( IERERR )
      GO TO 9900
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPMER , IOPABN , 0 )
      GO TO 4200
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPMER , IOPCMI , 0 )
      GO TO 9900
C
      END
C
CODE FOR WWT
      SUBROUTINE WWT
C--SET UP THE WEIGHTING SCHEME
C
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
C
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      COMMON /XMRG/WORK(30),ISTAT(100), RINT(6), RINTF(400)
      COMMON /XMRGA/ITYP06,MEDIUM,NSCH,NCYC,ICT,JCT,NCT,ITEMP1,ICODE,
     2 JCODE,MDCODE,NCODE,CHOP,NCHOP,IPRINT,APRINT,ISQ,IMTWIN,IBUF,
     3 JBUF,NBUF,ITEMP2,IREF,JREF,NTERM,NREF,NEND,IFO,JFO,ITWIN,
     4 N6DEAD,N6CTMP,N6RTMP,JPRINT,NPRINT
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C--BRANCH ON THE WEIGHTING SCHEME TYPE
      GOTO(1050,1100,1050,1000),NSCH
C1000  STOP 225
1000  CALL GUEXIT(225)
1050  CONTINUE
      NCYC=1
      GOTO 1300
C--GAUSSIAN WEIGHTING SCHEME
1100  CONTINUE
      IF ( NCT .NE. 6 ) GO TO 9910
      STORE(ICT)=(ALOG(STORE(ICT)))/(STORE(ICT+1)*STORE(ICT+1))
1300  CONTINUE
      RETURN
9910  CONTINUE
C -- WRONG NO. OF PARAMS.
      WRITE ( CMON , 9915 ) NCT , NSCH
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') CMON(1)(:)
9915  FORMAT ( 1X , I5 , ' is the wrong number of parameters for ' ,
     1 'weighting scheme ' , I4 )
      CALL XERHND ( IERERR )
      RETURN
      END
C
CODE FOR KMERGE
      FUNCTION KMERGE(IN)
C--ROUTINE TO COMBINE THE CONTRIBUTORS FOR ONE REFLECTION
C  TOGETHER.
C
C  IN  A DUMMY ARGUMENT.
C
C--RETURN VALUES OF 'KMERGE' ARE :
C
C  -1  REFLECTION HAS BEEN REJECTED/
C   0  REFLECTION IS READY TO OUTPUT.
C
C--WORK5 = FO
C--WORK9 = SIGMA
C--WORK3 = SIGMA W* /FO/ **2
C--WORK4 = SIGMA W
C--WORK8 = WEIGHTED VARIANCE
C--WORK7 = DELTA
C--WORK6 = SIGMA W*DEL.SQ
C--WORK8 = SIGMA W*VAR
C--WORK25 =21= SIGMA /DELTA/
C--WORK26 = 22 = SIGMA AVERAGE
C--WORK27 = 23 = SIGMA W AV SQ
C--WORK29 IS MINIMUM JCODE
C--WORK28 = 24 = SIGMA W DELTA SQ
C--WORK28 = 24 = SIGMA W DELTA SQ
C--WORK28=WORK(28)+WORK(6)
C--WEIGHTED AVERAGE
C--WORK9=WEIGHTED AVERAGE=WORK(6)/WORK(4)
C--WORK10=WEIGHTED AVERAGE=WORK(8)/WORK(4)
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
C
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XCHARS.INC'
      COMMON /XMRG/WORK(30),ISTAT(100), RINT(6), RINTF(400)
      COMMON /XMRGA/ITYP06,MEDIUM,NSCH,NCYC,ICT,JCT,NCT,ITEMP1,ICODE,
     2 JCODE,MDCODE,NCODE,CHOP,NCHOP,IPRINT,APRINT,ISQ,IMTWIN,IBUF,
     3 JBUF,NBUF,ITEMP2,IREF,JREF,NTERM,NREF,NEND,IFO,JFO,ITWIN,
     4 N6DEAD,N6CTMP,N6RTMP,JPRINT,NPRINT
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
C
      INCLUDE 'QSTORE.INC'
C
C      write(123,'(a)') ' '
C      write(123,'(i6, 3f3.0, 4f12.2)') iref,
C     1 store(iref),store(iref+1),store(iref+2), 
C     2 store(iref+3),store(iref+12),store(iref+5),
C     3 rtd*store(iref+6)
c
cdjwfeb12 save initial Fc and phase
      fc = store(iref+5)
      phase = store(iref+6)
c      
      IDWZAP = IN
C--CHECK FOR ONLY ONE REFLECTION
      IF(NREF-1)1000,1000,1050
C--ONLY ONE CONTRIBUTOR
1000  CONTINUE
      JFO=IFO+IREF
C--WORK(5) = FO
C--WORK(9) = SIGMA
      WORK(5)=STORE(JFO)
      WORK(9)=AMAX1(0.01,STORE(IREF+12))
      WORK(10)=WORK(9)
      work(7) = fc
      avfc = fc
      work(8) = phase
C----- SET THE PRINT LEVEL FOR SINGLE REFLECTIONS
      JPRINT = IPRINT
      GOTO 2500

C--MORE THAN ONE REFLCTION  -  INITIAL PREPARATION
1050  CONTINUE
      GOTO(1150,1200,1250,1100),NSCH
C1100  STOP 225
1100  CALL GUEXIT(225)
C--UNIT WEIGHTS
1150  CONTINUE
      ASSIGN 1700 TO LABEL
      GOTO 1350
C--GAUSSIAN WEIGHTS
1200  CONTINUE
      ASSIGN 1800 TO LABEL
      GOTO 1350
C--STATISTICAL WEIGHTS
1250  CONTINUE
      ASSIGN 1750 TO LABEL
      JREF=IREF
      DO 1300 J=1,NREF
      KREF=JREF+NTERM
      STORE(KREF-1)=1./(STORE(JREF+12)*STORE(JREF+12)+1.)
      STORE(KREF-2)=0.
      JREF=JREF+NTERM
1300  CONTINUE
      GOTO 1350
C
C--ASSIGN WEIGHTS  -  ALL CALCULATIONS ARE DONE ON THE SCALE OF /FO/ **2
1350  CONTINUE
      DO 1950 L=1,NCYC
C--WORK3 = SIGMA W* /FO/ **2
      WORK(3)=0.
C--WORK4 = SIGMA W
      WORK(4)=0.
C--WORK8 = WEIGHTED VARIANCE
      WORK(8)=0.
cdjw2012 Prepare to average Fc
      sumfc = 0.
      JREF=IREF
c
c
      DO 1600 J=1,NREF
c
C      write(123,'(i6, 3f3.0, 4f12.2)') jref,
C     1 store(jref),store(jref+1),store(jref+2), 
C     2 store(jref+3),store(jref+12),store(jref+5),
C     3 rtd*store(jref+6)
c
      KREF=JREF+NTERM
      JFO=JREF+IFO
C--CHECK IF ANY JCODES ARE TO BE SPECIALLY WEIGHTED
      IF(NCODE)1550,1550,1400
C--CHECK IF THIS REFLECTION IS ONE OF THE SPECIAL JCODES
1400  CONTINUE
      DO 1500 K=ICODE,JCODE,MDCODE
      IF(ISTORE(KREF-4)-ISTORE(K))1500,1450,1500
C--APPLY THE SPECIAL WEIGHT FOR THIS JCODE
1450  CONTINUE
      STORE(KREF-1)=STORE(K+1)
1500  CONTINUE
C--SIGMA[X(I)*W(I)]
1550  CONTINUE
      WORK(3)=WORK(3)+STORE(JFO)*STORE(KREF-1)
      sumfc = sumfc+store(jref+5)*STORE(KREF-1)
C--SIGMA [W(I)]
      WORK(4)=WORK(4)+STORE(KREF-1)
      WORK(8)=WORK(8)+STORE(JREF+12)*STORE(JREF+12)*STORE(KREF-1)
      JREF=KREF
1600  CONTINUE
C--WEIGHTED AVERAGE
      IF (WORK(4) .GT. ZERO) THEN
      WORK(5)=WORK(3)/WORK(4)
      avfc=sumfc/work(4)
      WORK(10)=SQRT(WORK(8)/WORK(4))
      ELSE
            WORK(5) = WORK(3) / FLOAT(NREF)
            WORK(10) = WORK(8) / FLOAT(NREF)
            avfc = sumfc / float(nref)
      ENDIF
C--CHECK IF THIS IS THE LAST CYCLE  -  EXIT IF IT IS
      IF(L-NCYC)1650,1900,1900
1650  CONTINUE
      GOTOLABEL,(1700,1800,1750)
C--UNIT WEIGHTS
1700  GOTO 1900
C--STATISTICAL WTS
1750  GOTO 1900
C--EXPONENTIAL WEIGHTS
1800  JREF=IREF
      DO 1850 J=1,NREF
      KREF=JREF+NTERM
      JFO=JREF+IFO
C--COMPUTE THE DELTA'S
      WORK(3)=WORK(5)-STORE(JFO)
C--COMPUTE THE GAUSSIAN WEIGHT - AN ESTIMATE OF THE REAL VARIABILITY
CDJWMAP99[
      CALL XSQRT(STORE(JFO), FSIGN, FABS, STORE(jref+12), SIG)
CDJWMAP99]
      BTEMP=STORE(ICT+2)+(STORE(ICT+3)*STORE(JREF+12)+STORE(ICT+4)
     2 *STORE(JREF+12)*FABS+STORE(ICT+5)
     3 *STORE(JFO)*STORE(JREF+12))
C--KREF-2='E'
      STORE(KREF-2)=BTEMP
C
C
C--    -1=WT
      STORE(KREF-1)= ZERO
      ATEMP=WORK(3)*WORK(3)*STORE(ICT)/(STORE(KREF-2)*STORE(KREF-2))
C--CHECK IF THIS VALUE IS TOO SMALL TO 'EXP'
      IF(ATEMP+170.)1840,1810,1810
C--TAKE THE EXPONENTIAL
1810  CONTINUE
      STORE(KREF-1)=EXP(ATEMP)
C--UPDATE FOR THE NEXT REFLECTION
1840  CONTINUE
      JREF=KREF
1850  CONTINUE
1900  CONTINUE
1950  CONTINUE
C
C--CHECK THE NUMBER OF BAD AGREEMENTS AFTER THE FINAL CYCLE
      JPRINT=IPRINT
      JREF=IREF
      DO 2100 J=1,NREF
      JFO=JREF+IFO
      KREF=JREF+NTERM
C--CHECK THE DISCREPANCY FOR THIS CONTRIBUTOR
      IF(ABS(STORE(JFO)-WORK(5))-APRINT*WORK(10))2100,2100,2000
C--DISCREPANCY EXCEEDS 'APRINT'*E.S.D.
2000  CONTINUE
      NPRINT=NPRINT+1
C--CHECK IF THIS IS A PARTIAL PRINT
      IF(IPRINT)2100,2050,2100
C--COMPLETE PRINT REQUIRED
2050  CONTINUE
      JPRINT=1
2100  CONTINUE
      JREF=KREF
C--ACCUMULATE THE TOTALS AND DO THE PRINTING IF NECESSARY
      WORK(6)=0.
      WORK(8)=0.
C----- SET A MAXIMUM JCODE
      WORK(29) = 9.
      JREF=IREF
      DO 2450 J=1,NREF
      KREF=JREF+NTERM
      JFO=JREF+IFO
C--WORK7 = DELTA
      WORK(7) = STORE(JFO) - WORK(5)
C--WORK6 = SIGMA W*DEL.SQ
      WORK(6)=WORK(6)+WORK(7)*WORK(7)*STORE(KREF-1)
C--WORK 8 = SIGMA W*VAR
      WORK(8)=STORE(JREF+12)*STORE(JREF+12)*STORE(KREF-1)+WORK(8)
C--WORK25=21= SIGMA /DELTA/
      WORK(25)=WORK(25)+ABS(WORK(7))
C--WORK26 = 22 = SIGMA AVERAGE
      WORK(26)=WORK(26)+WORK(5)
C--WORK27 = 23 = SIGMA W AV SQ
      WORK(27)=WORK(27)+WORK(5)*WORK(5)*STORE(KREF-1)
C----- COMPUTE TOTALS FOR PARTIAL RINT
C - Scale up to six digit integers before compare for robustness of binning.
      IF (NINT(100000.*STORE(JFO)) .GE.
     1    NINT(1000000.*STORE(JREF+12)))THEN
            IRINT = 1
      ELSE IF (NINT(100000.*STORE(JFO)) .GE.
     1         NINT(200000.*STORE(JREF+12))) THEN
            IRINT = 2
      ELSE
            IRINT = 3
      ENDIF
c      WRITE(NCWU,'(I1,3(1X,F15.9))') IRINT, STORE(JFO), STORE(JREF+12),
c     1  10. * STORE(JREF+12)
c      WRITE(NCWU,'(I1,3(1X,Z0))') IRINT, STORE(JFO), STORE(JREF+12),
c     1  10. * STORE(JREF+12)
      RINT(IRINT) = RINT(IRINT) + STORE(JFO)
      RINT(IRINT+3) = RINT(IRINT+3) + ABS(WORK(7))
C----- COMPUTE TOTALS FOR FINER GRAINED RINT
      JRINTF = 100
      IF ( ABS ( STORE(JREF+12) ) .GE. 0.0005 ) 
     1           JRINTF = 1+ NINT(2.*STORE(JFO)/STORE(JREF+12))
      JRINTF = MIN ( 100, JRINTF )
      JRINTF = MAX ( 1 , JRINTF )
      RINTF(JRINTF)    = RINTF(JRINTF)    + STORE(JFO)
      RINTF(JRINTF+100)= RINTF(JRINTF+100)+ ABS(WORK(7))
      RINTF(JRINTF+200)= RINTF(JRINTF+200)+ 1.0
C--CHECK IF A PRINT IS REQUIRED OF THE CONTRIBUTORS
      IF(JPRINT)2400,2400,2200
C--PRINT THE RESULTS  - PARTIAL CONTRIBUTIONS
2200  CONTINUE
      KKK=IB
      IF(ABS(STORE(JFO)-WORK(5))-APRINT*WORK(10))2300,2300,2250
C--OUTSIDE THE LIMTS
2250  CONTINUE
      KKK=IA
C--PRINT THIS CONTRIBUTOR
2300  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2350)STORE(JFO),KKK,STORE(JREF+12),WORK(7),
     2 STORE(KREF-2),STORE(KREF-1),ISTORE(KREF-4),ISTORE(KREF-3)
      ENDIF
2350  FORMAT(51X,F10.1,A1,F9.1,2F10.1,E11.2,I6,I10)
2400  CONTINUE
C----- WORK(29) IS MINIMUM JCODE
      WORK(29) = AMIN1( WORK(20), STORE(JREF+18) )
      JREF=KREF
2450  CONTINUE
C--WORK 28 = 24 = SIGMA W DELTA SQ
      WORK(28)=WORK(28)+WORK(6)
C--WEIGHTED AVERAGE
cdjwsep07
c      IF (WORK(4) .GT. ZERO) THEN
c        WORK(9)=WORK(6)/WORK(4)
c        WORK(10)=WORK(8)/WORK(4)
c      ELSE
c        WORK(9)=WORK(6)/FLOAT(NREF)
c        WORK(10)=WORK(8)/FLOAT(NREF)
c      ENDIF

      IF (WORK(4) .LE. ZERO) work(4) = FLOAT(NREF)
      WORK(9)=WORK(6)/WORK(4)
      WORK(10)=WORK(8)/WORK(4)
C
c adjust sigmas - An Intro to Error Analysis, Taylor, pp89
      WORK(9)=SQRT(WORK(9))/SQRT(FLOAT(NREF))
      WORK(10)=SQRT(WORK(10))/SQRT(FLOAT(NREF))
      WORK(9)=AMAX1(0.01,WORK(9))
      WORK(10)=AMAX1(0.01,WORK(10))

C--ALL THE DETAILS HAVE BEEN SET UP
2500  CONTINUE
      J=1
      KMERGE=0
C--CHECK FOR AN ACCEPTED REFLECTION
      IF(CHOP*WORK(NCHOP+8)-WORK(5))2550,2550,2700
C--THIS REFLECTION IS OKAY  -  ADD IN THE DEVIATION DETAILS
2550  CONTINUE
      IF(NREF-1)2750,2750,2600
C--MORE THAN ONE REFLECTION  -  ADD IN THE DEVIATION DETAILS
2600  CONTINUE
      IF (WORK(4) .LE. ZERO) GOTO 2700
      JREF=IREF
      DO 2650 I=1,NREF
      JFO=JREF+IFO
      KREF=JREF+NTERM
      WORK(20)=WORK(5)-STORE(JFO)
      WORK(21)=WORK(21)+ABS(WORK(20))
      WORK(22)=WORK(22)+WORK(5)
      WORK(23)=WORK(23)+WORK(5)*WORK(5)*STORE(KREF-1)
      WORK(24)=WORK(24)+WORK(20)*WORK(20)*STORE(KREF-1)
      JREF=KREF
2650  CONTINUE
      GOTO 2750
C--REJECTED REFLECTION
2700  CONTINUE
      J=2
      N6DEAD=N6DEAD+1
      KMERGE=-1
C--PRINT THE TOTALS FOR THE NEW REFLECTION
2750  CONTINUE
      IF(JPRINT)2900,2900,2800
C--PRINT THE REFLECTION
2800  CONTINUE
      K=IREF+2
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,2850)(ISTORE(I),I=IREF,K),WORK(5),(WORK(I),I=9,10),
     2 (IB,I=1,J)
      ENDIF
2850  FORMAT(1X,3I4,1X,3F10.1,2A1,1X,'Unobserved  -  rejected')
C--FIND THE STATISTICS IF NECESSARY
2900  CONTINUE
      IF(J-2)2950,3000,3000
C--COMPUTE THE POINT
2950  CONTINUE
      J=INT(AMIN1(2.*WORK(5)/WORK(NCHOP+8)+1.,100.)+.001)
      J = MAX0(1,J)
      J = MIN0(100,J)
      ISTAT(J)=ISTAT(J)+1
C--AND NOW RETURN
3000  CONTINUE
cdjw2012 save <fc> and phase
      work(7) = avfc
      work(8) = phase
c
      RETURN
      END
C
CODE FOR WSTAT
      SUBROUTINE WSTAT(N3SIG, PC3SIG)
C
C--
C
      DIMENSION JSTAT(100)
C
C
      COMMON /XMRG/WORK(30),ISTAT(100), RINT(6), RINTF(400)
      COMMON /XMRGA/ITYP06,MEDIUM,NSCH,NCYC,ICT,JCT,NCT,ITEMP1,ICODE,
     2 JCODE,MDCODE,NCODE,CHOP,NCHOP,IPRINT,APRINT,ISQ,IMTWIN,IBUF,
     3 JBUF,NBUF,ITEMP2,IREF,JREF,NTERM,NREF,NEND,IFO,JFO,ITWIN,
     4 N6DEAD,N6CTMP,N6RTMP,JPRINT,NPRINT
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XIOBUF.INC'
C
C -- 'NMONIT' IS NUMBER OF CHANNELS TO DISPLAY ON MONITOR OUTPUT.
C    'MONWID' IS WIDTH OF MONITOR BAR DISPLAY
C    'IMONIT' CONTROLS WHETHER A DISPLAY IS PRODUCED ( 1 = YES, 0 = NO)
C
      DATA NCHANL / 100 / , LISWID / 80 /
      DATA NMONIT / 20 / , MONWID / 40 / , IMONIT / 1 /
C
C
C
C -- ACCUMULATE TOTAL NUMBER OF REFLECTIONS, AND REMAINDER INFORMATION
C
      ND=0
      IAMAX = 0
      NTOT = 0
C
      DO 1050 J=1, NCHANL
         ND=ND+ISTAT(J)
         IAMAX=MAX0(IAMAX,ISTAT(J))
         IF ( J .GT. NMONIT ) NTOT = NTOT + ISTAT(J)
         JSTAT(J)=ND
1050  CONTINUE
      IF (IAMAX .LE. 0) GOTO 1200

      ND=MAX0(ND,1)
      MONMAX = MAX0 ( IAMAX , NTOT )
C----- ACCUMULATE 3 SIGMA DATA
      N3SIG = ND - JSTAT(6)
      PC3SIG= 100. * FLOAT(N3SIG)/ FLOAT(ND)
C
C--PRINT THE HEADING
      CALL XPRTCN
      WRITE ( CMON ,1000)
      IF ( IPRINT .GE. 0 ) CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') CMON(1)(:)
1000  FORMAT('Fsq/sigma(Fsq)  No.  %  Total',
     2 ' Remainder         Distribution of sigma levels.',A2)
C
C
      DO J=1,100
        X=0.5*FLOAT(J)
        Y=X-0.5
        K = ( (ISTAT(J)*LISWID) / IAMAX )  + 1
        NZ=ND-JSTAT(J)
        IPER=NINT(FLOAT(ISTAT(J))*100./FLOAT(ND))
C
C
        IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU,1150)Y,X,ISTAT(J),IPER,JSTAT(J),NZ,(MINUS,L=1,K)
        ENDIF
        IF ( IPRINT .GE. 0 ) THEN
          IF ( J .LE. NMONIT ) THEN
            K = ( ( ISTAT(J) * MONWID ) / MONMAX ) + 1
            WRITE ( CMON , 1150 ) Y , X , ISTAT(J) , IPER , JSTAT(J) ,
     2      NZ , ( MINUS , L = 1 , K )
            CALL XPRVDU(NCVDU, 1,0)
          ELSE IF ( J .EQ. NCHANL ) THEN
            Y = FLOAT ( NMONIT + 1 ) * 0.5
            K = ( ( MONWID * NTOT ) / MONMAX ) + 1
C
            IREM = ND - JSTAT(J)
            IPER = NINT(FLOAT(NTOT)*100./FLOAT(ND))
            WRITE ( CMON , 1150 ) Y , X , NTOT ,     IPER , JSTAT(J),
     2      IREM , ( MINUS , L = 1 , K )
            CALL XPRVDU(NCVDU, 1,0)
          ENDIF
        ENDIF
1150    FORMAT(1H ,F5.1,2H -,F5.1,I6,I3,2I6,1X,96A1)
      END DO

1200  CONTINUE
      CALL XLINES
      RETURN
      END
C
CODE FOR XL6RRP
      SUBROUTINE XL6RRP(N6DEAD,N6MAX,IFO,CCAPT)
C--REJECTED REFLECTION PRINT ROUTINE FOR LIST 6.
C
C  N6DEAD  THE NUMBER OF REFLECTIONS REJECTED SO FAR.
C  N6MAX   THE MAXIMUM NUMBER OF REJECTED REFLECTIONS TO BE PRINTED.
C  IFO     THE POSITION OF /FO/ IN THE LIST 6 BUFFER  -  RANGE 0 TO
C          'MD6'-1.
C  CCAPT   A CHARACTER CAPTION TO PRECEDE THE REFLECTION.
C
C--
C
      CHARACTER*(*) CCAPT
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST06.INC'
C
C--CHECK IF THIS IS THE FIRST REJECTED REFLECTION
      IF(N6DEAD)1000,1000,1100
C--FIRST REFLECTION  -  OUTPUT THE REJECTED REFLECTIONS CAPTION
1000  CONTINUE
      N6DEAD=0
      CALL XPRTCN
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1050)
      ENDIF
1050  FORMAT(//21X,10X,'H',5X,'K',5X,'L',5X,
     2 'I or /FO/',5X,'Sigma',6X,'JCODE',4X,'Serial'/)
      GOTO 1250
C--CHECK IF TOO MANY REFLECTIONS HAVE BEEN REJECTED
1100  CONTINUE
      IF(N6DEAD-N6MAX)1250,1150,1350
1150  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1200)
      ENDIF
1200  FORMAT(/,' and so on . . . .')
      GOTO 1350
C--PRINT THE REJECTED REFLECTION
1250  CONTINUE
      JFO=IFO+M6
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1300)CCAPT,STORE(M6),STORE(M6+1),STORE(M6+2),
     2 STORE(JFO),STORE(M6+12),STORE(M6+18),STORE(M6+19)
      ENDIF
1300  FORMAT ( 1X, A, 2X, 3F6.0, F12.1, F11.1, F11.0, F10.0 )
C--UPDATE THE NUMBER OF REJECTED REFLECTIONS
1350  CONTINUE
      N6DEAD=N6DEAD+1
      RETURN
      END

