C $Log: not supported by cvs2svn $
C Revision 1.53  2003/12/10 09:12:40  rich
C CDD: change to summary.src in new XSUM42 code to get it to compile on Linux.
C
C Revision 1.52  2003/12/02 11:54:40  rich
C Code to output summary of LIST 42 figure field. (May produce
C excessive output for high resolution fields).
C
C Revision 1.51  2003/09/10 21:18:28  djw
C Correct mis-formatting of Sheldrick weighting formula in .cifs
C
C Revision 1.50  2003/09/03 21:03:09  rich
C Add key to space group analysis plot. Reduce sig figs on x-axis labels.
C
C Revision 1.49  2003/08/05 11:11:12  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.48  2003/07/15 09:46:21  rich
C New SGPLOT instruction. Takes a 3x3 matrix,A, to select reflection classes
C (if h == Ah, then the reflection is selected). Takes a 3x1 vector, B, and
C a value, N, to split the selected class into two conditions (if mod(B'h,N) is
C zero the reflection is 'allowed' if it is non-zero the reflection is
C 'dis-allowed'. These allowed and disallowed from the class are plotted as
C two series of a bar graph showing frequency vs. sqrt(Fo).
C
C Revision 1.47  2003/07/09 11:34:23  rich
C Ensure theta_full is always at least 3/4 of theta_max.
C
C Revision 1.46  2003/07/08 10:49:43  rich
C
C Completely changed the SIGMA vs RES graph - it takes far
C too long to load due to the sheer number of points.
C Instead, plot a line graph of number of reflections
C in one of three I/sigma(I) classes (<3,3-10,>10) vs
C resolution.
C
C Revision 1.45  2003/07/08 10:09:24  rich
C
C Two changes:
C 1) The implementation of the #TWINPLOT command.
C 2) Changed the completeness graph to output the full
C theta range for the data, and also the completeness in
C every shell. Interpret carefully, the graph uses two axes.
C
C Revision 1.44  2003/06/24 13:01:04  djw
C Change SHELX weighting text to keep Acta happy
C
C Revision 1.43  2003/06/19 16:29:50  rich
C
C Store, in L30, the number of restraints that L16 is generating.
C
C Output, to the CIF, the _refine_ls_number_restraints for info.
C
C Revision 1.42  2003/04/01 13:48:51  rich
C XTHLIM could go into an infinite loop in certain cases (certain cells?). Limit
C loops for optimising MAXH,K,L to 400 iterations.
C
C Revision 1.41  2003/03/25 14:02:35  rich
C Move DELRHOMIN/MAX back to their original locations in LIst 30.
C
C Revision 1.40  2003/02/25 15:32:50  rich
C Don't clear IERFLG on exit from summary routines - the script wants
C to know.
C
C Revision 1.39  2003/02/17 13:28:43  djw
C Remove writes to .mon from FOURIER, save Rho and positions in LIST 30 CIFEXTRA (was in REFINEMENT), adjust output of 30
C
C Revision 1.38  2003/02/14 17:09:02  djw
C Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
C recine have the parameter ityp06, which corresponds to the types
C pickedip for lists 6 and 7  from the command file
C
C Revision 1.37  2003/01/14 10:23:57  rich
C Replace tabs with spaces.
C
C Revision 1.36  2002/11/12 15:14:12  rich
C Extended plots from #SUM L 6 to include omitted reflections on the Fo vs Fc
C graph. They appear in blue.
C
C Revision 1.35  2002/11/07 17:35:12  rich
C THLIM upgraded so that it works. (With Friedel unmerged data and data
C that hasn't been SYSTEMATIC'd). It now also writes things to the listing
C file (missing reflection indices) and draws graphs.
C
C Revision 1.34  2002/11/06 12:58:22  rich
C If the theta_full value in L30 is negative, then the program will use its absolute
C value as theta_full and compute the completeness, rather than trying to find
C an optimum theta_full.
C
C Revision 1.33  2002/08/30 14:36:15  richard
C Added pressure to L30. Only appears in CIF if non-zero.
C
C Revision 1.32  2002/07/29 13:01:41  richard
C #THLIM calls completeness code, which inserts values into L30.
C
C Revision 1.31  2002/07/22 14:37:31  Administrator
C Try to fix LIST 4 in cif
C
C Revision 1.30  2002/07/18 17:02:29  richard
C Limit max theta value to 90, if ASIN is going to fail.
C
C Revision 1.29  2002/07/15 11:59:48  richard
C New routine XTHETA works out completeness and best theta value for
C fullish completeness. Probably doesn't belong is SUMMARY.
C
C Revision 1.28  2002/05/15 10:24:35  richard
C Output Rsigma during SUM L 6. This is sum(sigma)/sum(Fo) as opposed to
C sum(delta)/sum(Fo) and therefore if the sigmas are good estimates of error,
C it should be equal to the final R-factor. In reality sigmas are usually
C underestimated, so it's just something to aim for.
C
C Revision 1.27  2002/03/21 17:51:18  richard
C Extend I/sigma(I) frequency graph down to -5.
C
C Revision 1.26  2002/03/18 22:14:02  richard
C Enhance #SIGMADIST so it will output I/sigma(I) vs. resolution.
C
C Revision 1.25  2002/03/15 11:11:25  richard
C Ensure List 1 is loaded before calling KALLOW.
C
C Revision 1.24  2002/03/13 12:36:23  richard
C Removed calls to XGDBUP (now obsolete).
C
C Revision 1.23  2002/03/08 11:44:19  ckp2
C During #SIGMADIST, update L30 General, NAnalyse with the number of allowed reflections.
C
C Revision 1.22  2002/03/06 13:50:23  ckp2
C Updated to check6 stuff.
C
C Revision 1.21  2002/03/01 11:33:41  Administrator
C Correct and improve presntation of weighting scheme in .cif file
C
C Revision 1.20  2002/02/28 18:04:20  ckp2
C New command #SIGMADIST for producing sigma distribution graph. It doesn't
C do anything else.
C
C Revision 1.19  2002/02/18 15:17:16  DJWgroup
C SH: Added y=x line to Fo vs. Fc plot.
C
C Revision 1.18  2002/02/18 11:20:30  DJWgroup
C SH: Update to plot code.
C
C Revision 1.17  2002/02/13 12:12:13  ckp2
C Store extinction param su in List 30.
C
C Revision 1.16  2002/02/12 12:56:53  Administrator
C Fix problem with text version of symmetry operators - avoid /1 as a divisor
C
C Revision 1.15  2002/02/01 14:41:31  Administrator
C Enable CALC to get additional R factors and display them in SUMMARY
C
C Revision 1.14  2002/01/16 10:37:32  ckp2
C Remove all spaces in hkl label. Only pass Fo and Fc to 2 decimal places.
C
C Revision 1.13  2002/01/16 10:30:33  ckpgroup
C SH: Added labels to scatter plot of Fo vs. Fc.
C
C Revision 1.12  2002/01/14 12:21:40  ckpgroup
C SH: Added Fo vs. Fc scatter graph (use xfovsfc.ssc).
C
C Revision 1.11  2001/12/17 16:29:43  Administrator
C Fix translational components 9/4 -> 5/4. An old but forgotten errror may be re-introduced
C
C Revision 1.10  2001/10/05 13:31:53  ckp2
C
C Implementation of Lists 40 and 41.
C ===================================
C New commands:
C #LIST 41 - contains a list of bonds and bondtypes. It is generated by typing
C #BONDCALC which calculates bonds from LIST1,2,5,29 and 40.
C 40 contains info about how to do the bond calculation and can override
C covalent radii, force or break specific bonds and set limits for pairs
C of elements.
C #PUNCH 40 A - produces a LIST 40, #PUNCH 40 B - produces a #BONDING command
C which may be used to input a list 40 in a more user friendy manner (no READ
C card). #BONDING may also be used to EXTEND an existing list 40.
C #SUM L 40 - summary of bonding building info. #SUM L 41 - the bonds.
C #BONDCALC creates a L40 if there is none, and also only carries out calculation
C if significant change has occured to L5. (unless "#BONDCALC FORCE").
C See manual for more details.
C
C Revision 1.9  2001/05/31 16:40:20  richard
C Fixed bug in display of L28 SLICE records in listing file.
C
C Revision 1.8  2001/04/11 15:27:28  CKP2
C Fix xsymop so that .CIF entries tally
C
C Revision 1.7  2001/03/08 14:47:22  richard
C Changed style of call to XGDBUP.
C
C
CODE FOR XSMMRY
      SUBROUTINE XSMMRY
C
C -- SUBROUTINE TO SUMMARISE DATA
C
C -- THIS ROUTINE IMPLEMENTS THE CRYSTALS 'SUMMARY' AND 'DISPLAY'
C    INSTRUCTIONS
C
C      VERSION
C      1.00      NOVEMBER 1984         PWB   INITIAL VERSION FOR LISTS
C                                            5 AND 6
C      1.01      DECEMBER 1984         PWB   ADD LISTS 1, 2, 3, 4, 13,
C                                            14, 23, 27, 28, 29
C      1.02      JANUARY 1985          PWB   ADD LISTS 12 AND 16
C      2.00      JANUARY 1985          PWB   REORGANISE TO USE 'KSUMLN'
C      2.01      JANUARY 1985          PWB   ADD 'EVERYTHING'
C
C
      PARAMETER ( NSMTYP = 50 )
      DIMENSION ISMTYP(NSMTYP)
C --
\ISTORE
C
\STORE
\XUNITS
\XSSVAL
\XERVAL
\XOPVAL
C
\QSTORE
C
C----- SEE ALSO KSUMLN - FOR THE SAME DATA - SHOULD IT BE IN BLOCK DATA?
      DATA ISMTYP /  1 ,  2 ,  3 ,  4 ,  5 ,     6 ,  0 ,  0 ,  0 , 10 ,
     2               0 , 12 , 13 , 14 ,  0 ,    16 , 17 ,  0 ,  0 ,  0 ,
     3               0 ,  0 , 23 ,  0 , 25 ,     0 , 27 , 28 , 29 , 30 ,
     4               0 ,  0 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 , 40 ,
     5              41 , 42 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 ,  0 /
C
      DATA IVERSN / 201 /
C
      DATA ICOMSZ / 3 /
C
&PPCCS***
&PPC      CALL SETSTA( 'Summary ' )
&PPC      CALL NBACUR
&PPCCE***
C
C -- SET THE TIMING AND READ THE CONSTANTS
C
      CALL XTIME1 ( 2 )
      CALL XCSAE
C
C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
CMAR98
      ICOMBF = KSTALL( ICOMSZ)
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910
C
C -- SET LIST TYPE AND LISTING LEVEL FLAG
C
        ITYPE = ISTORE(ICOMBF)
        LEVEL = ISTORE(ICOMBF+1)
C
C -- CHECK REQUEST
      IF ( ISTORE(ICOMBF+2) .LE. 0 ) THEN
C
C -- SPECIFIC LIST SUMMARY REQUIRED.
        ISTAT = KSUMLN ( ITYPE , LEVEL , 1 )
        IF ( ISTAT .LE. 0 ) GO TO 9900
      ELSE
C -- 'EVERYTHING'
        DO 2100 I = 1 , NSMTYP
          IF ( ISMTYP(I)  .GT. 0 ) THEN
            IF ( KEXIST(I) .GT. 0 ) THEN
              ISTAT = KSUMLN ( I , LEVEL , 1 )
            ENDIF
          ENDIF
2100    CONTINUE
      ENDIF
C
C
9000  CONTINUE
C -- FINAL MESSAGE
      CALL XOPMSG ( IOPDSP , IOPEND , IVERSN )
      CALL XTIME2 ( 2 )
C
      CALL XRSL
      CALL XCSAE
C
      RETURN
C
C
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDSP , IOPABN , 0 )
      GO TO 9000
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDSP , IOPCMI , 0 )
      GO TO 9900
C
C
      END
C
C
C
C
C
CODE FOR KSUMLN
      FUNCTION KSUMLN ( LSTYPE , LEVEL , LOADLN )
C
C -- SUBROUTINE PRODIVING LINK TO SUMMARY CODE
C
C -- INPUT
C      LSTYPE      LIST TYPE TO SUMMARISE
C      LEVEL       LEVEL OF SUMMARY ( ONLY FOR TYPE = 5 )
C      LOADLN      LOAD LIST BEFORE PRODUCING SUMMARY
C                    0 DO NOT LOAD LIST. A SUITABLE LIST HAS ALREADY
C                      BEEN LOADED
C                    1 LOAD LIST
C
C -- RETURN VALUE :-
C      -VE      ERROR PRODUCING SUMMARY. THE LIST CANNOT BE
C               SUMMARISED
C      +VE      SUCCESS
C
      PARAMETER ( NSMTYP = 50 )
      DIMENSION ISMTYP(NSMTYP)
      
      PARAMETER (NLTYPE = 42)
      CHARACTER*32 CLTYPE(NLTYPE)
      DIMENSION LLTYPE(NLTYPE)
      character*80 ctext(4)
C
\XLST01
\XLST02
\XLST03
\XLST04
\XLST05
\XLST06
\XLST13
\XLST14
\XLST23
\XLST25
\XLST27
\XLST28
\XLST29
\XLST30
\XUNITS
\XSSVAL
\XERVAL
\XIOBUF
C
C
C -- THE ARRAY 'ISMTYP' INDICATES WHETHER A SUMMARY IS AVAILABLE, AND
C    WHICH STRING FROM 'CLTYPE' SHOULD BE USED TO DESCRIBE THE DATA
C
C      1 - 9 , 10 - 19 , 20 - 29 , 30 - 39 , 40 - 49 , 50
C
C----- SEE ALSO XSMMRY - FOR THE SAME DATA - SHOULD IT BE IN BLOCK DATA?
      DATA ISMTYP /  1 ,  2 ,  3 ,  4 ,  5 ,     6 ,  7 ,  0 ,  0 , 10 ,
     2               0 , 12 , 13 , 14 ,  0 ,    16 , 17 ,  0 ,  0 ,  0 ,
     3               0 ,  0 , 23 ,  0 , 25 ,     0 , 27 , 28 , 29 , 30 ,
     4               0 ,  0 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 , 40 ,
     5              41 , 42 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 ,  0 /
C
C
      DATA CLTYPE / 'Cell parameters', 'Symmetry',
     2 'Scattering factors', 'Weighting scheme', 'Parameters',
     3 'Reflection data', 
     * 'List 7', 2*'*', 'Peaks', '*', 'Refinement directives',
     4 'Diffraction conditions', 'Asymmetric section', '*',
     5 'Restraints', 'Special restraints', 5*'*',
     6 'S.F. modifications', '*', 'Twin Laws', '*',
     7 'Raw data scale factors',
     8 'Reflection selection conditions', 'Elemental properties',
     9 'General details', 9*'*','Bonding information', 'Bonds',
     1 'Fourier mask' /
C
      DATA LLTYPE / 15, 8,
     2 18, 16, 10,
     3 15, 6, 1, 1,  5, 1,  21,
     4 22, 18, 1,
     5 10, 18, 1, 1, 1, 1, 1,
     6 18, 1, 9, 1,
     7 22,
     8 31, 20,
     9 15,1,1,1,1,1,1,1,1,1,19,5,
     1 12 /
C
C
C
C -- CHECK TYPE NUMBER
C
      IF ( LSTYPE .LE. 0 ) GO TO 9910
      IF ( LSTYPE.GT. NSMTYP ) GO TO 9910
C
      INTLTP = ISMTYP(LSTYPE)
      IF ( INTLTP .LE. 0 ) GO TO 9920
C
C -- LOAD LIST IF REQUIRED
C
      IF ( LOADLN .GT. 0 ) THEN
C
        IF ( LSTYPE .EQ. 1 ) THEN
      IF (KHUNTR (1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
        ELSE IF ( LSTYPE .EQ. 2 ) THEN
      IF (KHUNTR (2,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL02
        ELSE IF ( LSTYPE .EQ. 3 ) THEN
      IF (KHUNTR (3,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL03
        ELSE IF ( LSTYPE .EQ. 4 ) THEN
      IF (KHUNTR (4,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL04
        ELSE IF ( LSTYPE .EQ. 5 ) THEN
      IF (KHUNTR (5,0, IADDL,IADDR,IADDD, -1) .LT. 0)
     1  CALL XLDR05 ( LSTYPE )
        ELSE IF ( LSTYPE .EQ. 6 ) THEN
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL30
          CALL XFAL06 (6, 0 )
        ELSE IF ( LSTYPE .EQ. 7 ) THEN
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL30
          CALL XFAL06 (7, 0 )
        ELSE IF ( LSTYPE .EQ. 10 ) THEN
      IF (KHUNTR (10,0, IADDL,IADDR,IADDD, -1) .LT. 0)
     1  CALL XLDR05 ( LSTYPE )
        ELSE IF ( LSTYPE .EQ. 13 ) THEN
      IF (KHUNTR (13,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL13
        ELSE IF ( LSTYPE .EQ. 14 ) THEN
      IF (KHUNTR (14,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL14
        ELSE IF ( LSTYPE .EQ. 23 ) THEN
      IF (KHUNTR (23,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL23
        ELSE IF ( LSTYPE .EQ. 25 ) THEN
      IF (KHUNTR (25,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL25
        ELSE IF ( LSTYPE .EQ. 27 ) THEN
      IF (KHUNTR (27,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL27
        ELSE IF ( LSTYPE .EQ. 28 ) THEN
      IF (KHUNTR (28,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL28
        ELSE IF ( LSTYPE .EQ. 29 ) THEN
      IF (KHUNTR (29,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL29
        ELSE IF ( LSTYPE .EQ. 30 ) THEN
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL30
        ELSE IF ( LSTYPE .EQ. 40 ) THEN
      IF (KHUNTR (40,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL40
        ELSE IF ( LSTYPE .EQ. 41 ) THEN
      IF (KHUNTR (41,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL41
        ELSE IF ( LSTYPE .EQ. 42 ) THEN
      IF (KHUNTR (42,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL42
        ENDIF
C
        IF ( IERFLG .LT. 0 ) GO TO 9900
      ENDIF
C
C -- PRODUCE SUMMARY
C
      IF (ISSPRT .EQ. 0)
     1 WRITE ( NCWU , 1005 ) LSTYPE , CLTYPE(INTLTP)(1:LLTYPE(INTLTP))
      WRITE ( CMON , 1005 ) LSTYPE , CLTYPE(INTLTP)(1:LLTYPE(INTLTP))
      CALL XPRVDU(NCVDU, 1,0)
1005  FORMAT (' Summary of contents of list' , I3 ,
     2 ' - ' , A )
C
C
      IF ( LSTYPE .EQ. 1 ) THEN
        CALL XSUM01
      ELSE IF ( LSTYPE .EQ. 2 ) THEN
        CALL XSUM02
      ELSE IF ( LSTYPE .EQ. 3 ) THEN
        CALL XSUM03
      ELSE IF ( LSTYPE .EQ. 4 ) THEN
        CALL XSUM04(1,ctext)
      ELSE IF ( LSTYPE .EQ. 5 ) THEN
        CALL XSUM05 ( LSTYPE , LEVEL )
      ELSE IF ( LSTYPE .EQ. 6 ) THEN
        CALL XSUM06 ( 6, LEVEL )
      ELSE IF ( LSTYPE .EQ. 7 ) THEN
        CALL XSUM06 ( 7, LEVEL )
      ELSE IF ( LSTYPE .EQ. 10 ) THEN
        CALL XSUM05 ( LSTYPE , LEVEL )
      ELSE IF ( LSTYPE .EQ. 12 ) THEN
        CALL XPRTLX ( LSTYPE , -1 )
      ELSE IF ( LSTYPE .EQ. 13 ) THEN
        CALL XSUM13
      ELSE IF ( LSTYPE .EQ. 14 ) THEN
        CALL XSUM14
      ELSE IF ( LSTYPE .EQ. 16 ) THEN
        CALL XPRTLX ( LSTYPE , -1 )
      ELSE IF ( LSTYPE .EQ. 17 ) THEN
        CALL XPRTLX ( LSTYPE , -1 )
      ELSE IF ( LSTYPE .EQ. 23 ) THEN
        CALL XSUM23
      ELSE IF ( LSTYPE .EQ. 25 ) THEN
        CALL XSUM25
      ELSE IF ( LSTYPE .EQ. 27 ) THEN
        CALL XSUM27
      ELSE IF ( LSTYPE .EQ. 28 ) THEN
        CALL XSUM28
      ELSE IF ( LSTYPE .EQ. 29 ) THEN
        CALL XSUM29
      ELSE IF ( LSTYPE .EQ. 30 ) THEN
        CALL XSUM30
      ELSE IF ( LSTYPE .EQ. 40 ) THEN
        CALL XSUM40
      ELSE IF ( LSTYPE .EQ. 41 ) THEN
        CALL XSUM41
      ELSE IF ( LSTYPE .EQ. 42 ) THEN
        CALL XSUM42
      ENDIF
C
c      IERFLG = 1
C
C
      KSUMLN = 1
      RETURN
C
C
9900  CONTINUE
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9905 ) LSTYPE
      WRITE ( CMON , 9905 ) LSTYPE
      CALL XPRVDU(NCVDU, 1,0)
9905  FORMAT (' Summary of list type' , I3 , ' abandoned' )
      KSUMLN = -1
      RETURN
9910  CONTINUE
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 ) LSTYPE
      WRITE ( CMON , 9915 ) LSTYPE
      CALL XPRVDU(NCVDU, 1,0)
9915  FORMAT (' Illegal list number for summary - ' , I12 )
      CALL XERHND ( IERWRN )
      GO TO 9900
9920  CONTINUE
C -- NO PROVISON FOR SUMMARY OF THIS LIST
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9925 ) LSTYPE
      WRITE ( CMON , 9925 ) LSTYPE
      CALL XPRVDU(NCVDU, 1,0)
9925  FORMAT (' No summary of list type ' , I5 , ' is available' )
      CALL XERHND ( IERWRN )
      GO TO 9900
C
      END
C
C
C
C
C
CODE FOR XSUM01
      SUBROUTINE XSUM01
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 1
C
\ISTORE
C
\STORE
\XLST01
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
C
C
C
C -- BEGIN OUTPUT
C
C -- CONVERT ANGLES TO DEGREES
C
      CALL XMULTR ( STORE(L1P1+3) , RTD , STORE(L1P1+3) , 3 )
C
      IF (ISSPRT .EQ. 0) WRITE ( NCWU,1015) ( STORE(J),J = L1P1,L1P1+6)
      WRITE ( CMON, 1015) ( STORE(J),J = L1P1,L1P1+6)
      CALL XPRVDU(NCVDU, 2,0)
1015  FORMAT (
     2 1X, 'a =     ',F9.4, '    b =    ',F9.4, '    c =     ',F9.4, /,
     3 1X, 'alpha = ',F9.4, '    beta = ',F9.4, '    gamma = ',F9.4,
     4 1x, 'Volume= ',F10.2)
C
C
      RETURN
      END
C
C
C
C
C
CODE FOR XSUM02
      SUBROUTINE XSUM02
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 2
C
      CHARACTER*32 OPERAT
      CHARACTER*16 LATTIC(7)
      CHARACTER *5 CNOT
      CHARACTER *2 CNO
      CHARACTER *80 CLINE, CLOW
C
\ISTORE
C
\STORE
\XLST01
\XLST02
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
      DATA LATTIC / 'primitive' , 'body centered' , 'rhombohedral' ,
     2 'face centered' , 'A centered' , 'B centered' , 'C centered' /
      DATA CNOT / ' non-' /, CNO / 'no' /
C
C
C----- FIND FLOATING ORIGINS - WE NEED LISTS 1 AND 5
      IORI = -1
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) THEN
       IF (KEXIST(1) .GT. 0) CALL XFAL01
      ENDIF
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0)  THEN
       IF (KEXIST(5) .GT. 0) CALL XFAL05
      ENDIF
C----- NOW SEE IF THEY ARE LOADED
      IF ((KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .GE. 0) .AND.
     1 (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .GE. 0)) THEN
            IORI = KSPINI( -1, .06)
            IF (IORI .GE. 0) CALL XFLORG( N2, 0, IORI)
      ENDIF
C -- BEGIN OUTPUT
C
C -- GET CENTRO AND LATTICE TYPE FLAGS
C
      ICENTR = NINT ( STORE(L2C) )
      LATTYP = NINT ( STORE(L2C+1) )
C
      CLOW = ' '
C----- DISPLAY SPACE GROUP SYMBOL
      J  = L2SG + MD2SG - 1
      WRITE(CLINE,2100) (ISTORE(I), I = L2SG, J)
2100  FORMAT('Space group symbol is ', 2X, 4(A4,1X))
      CALL XCREMS(CLINE, CLOW, ILAST)
C
C----- DISPLAY CRYSTAL CLASS
      WRITE(CLOW(40:),2200) (ISTORE(I), I = L2CC, L2CC+MD2CC-1)
2200  FORMAT('Crystal class is ', 1X, 4(A4))
      CALL XCTRIM (CLOW, ILAST)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2201) CLOW(1:ILAST)
      WRITE ( CMON, 2201) CLOW(1:ILAST)
      CALL XPRVDU(NCVDU, 1,0)
2201  FORMAT(1X,A)
C
      WRITE ( CLINE , 1025 ) LATTIC(LATTYP)
1025  FORMAT ('The lattice type is : ' , A )
      WRITE ( CLINE(40:) , 1035 ) N2
1035  FORMAT ('with ' , I3 , ' unique symmetry operators' )
      CALL XCTRIM (CLINE, ILAST)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2201) CLINE(1:ILAST)
      WRITE ( CMON, 2201) CLINE(1:ILAST)
      CALL XPRVDU(NCVDU, 1,0)
C
      LENCEN = 1
      IF ( ICENTR .LE. 0 ) LENCEN = 5
      WRITE ( CLINE , 1015 ) CNOT(1:LENCEN)
1015  FORMAT ('The space group is' , A , 'centrosymmetric' )
      CALL XCREMS(CLINE, CLOW, ILAST)
      IF (IORI .GE. 0)
     1 WRITE(CLOW(40:),'(A,I2,A)') 'with',IORI, ' floating origins'
      CALL XCTRIM (CLOW, ILAST)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2201) CLOW(1:ILAST)
      WRITE ( CMON, 2201) CLOW(1:ILAST)
      CALL XPRVDU(NCVDU, 1,0)
C
C
C -- DISPLAY EACH SYMMETRY OPERATOR
C
      M2 = L2 + (N2-1) * MD2
      J = 1
      DO 2000 I = L2 , M2 , MD2
        CALL XSUMOP ( STORE(I) , STORE(L2P) , CLINE , LENGTH, 0 )
        CALL XCCLWC(CLINE(1:LENGTH), OPERAT(1:LENGTH))
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1105 ) OPERAT(1:LENGTH)
1105    FORMAT ( 1X , A )
        LENGTH = MIN(19,LENGTH)
        IF (J .GT. 80) THEN
            CALL XPRVDU(NCVDU, 1,0)
            J = 1
        ENDIF
        WRITE(CMON(1)(J:),1106) OPERAT(1:LENGTH)
1106    FORMAT ( A )
        J = J + 20
2000  CONTINUE
      IF (J .NE. 1) CALL XPRVDU(NCVDU, 1,0)
C
      RETURN
      END
C
C
C
C
C
CODE FOR XSUM03
      SUBROUTINE XSUM03
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 3
C
\ISTORE
C
\STORE
\XLST03
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
C
C
C
C -- BEGIN OUTPUT
C
      IF ( N3 .GT. 0 ) THEN
        IF (ISSPRT .EQ. 0)WRITE ( NCWU , 1015 )
        WRITE ( CMON  , 1015 )
        CALL XPRVDU(NCVDU, 1,0)
1015    FORMAT ( ' Scattering factors are known for :- ' )
C
        IF (ISSPRT .EQ. 0)
     1  WRITE ( NCWU , 1025 ) ( STORE(J) , J = L3 , M3 , MD3 )
        WRITE ( CMON  , 1025 ) ( STORE(J) , J = L3 , M3 , MD3 )
        CALL XPRVDU(NCVDU, 1,0)
1025    FORMAT ( 1X , 19A4 )
      ELSE
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1035 )
        WRITE ( CMON , 1035 )
        CALL XPRVDU(NCVDU, 1,0)
1035    FORMAT (' No scattering factors stored in list 3' )
      ENDIF
C
C
      RETURN
      END
C
C
C
C
C
CODE FOR XSUM04
      SUBROUTINE XSUM04(imode, ctext)
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 4
C
c
c----- IMODE - 1 TO ENABLE PRINTING
c----- CTEXT - TEXT AVAILABLE TO CALLING ROUTINE
c
C -- THE EXPRESSIONS FOR THE WEIGHTS ARE CONSTRUCTED FROM THE
C    STRINGS CONTAINED IN 'CRESLT' AND 'CEXPRS' INDEXED BY
C    'IRESLT' AND 'IEXPRS'.
C
      PARAMETER ( MAXSCH = 17 )
      DIMENSION IEXPRS(2,MAXSCH)
      DIMENSION IRESLT(MAXSCH)
C
      character *(*)ctext(4)
      CHARACTER*40 CSNAME(MAXSCH)
      DIMENSION    LNNAME(MAXSCH)
C
      CHARACTER*64 CFORMS(14)
      CHARACTER*8 CRESLT(2)
      CHARACTER*11 CEXPRS
C
\ISTORE
C
\STORE
\XLST04
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
      DATA CFORMS /
     1 'FO/P(1), FO < P(1) or FO = P(1)' ,
     2 'P(1)/FO, FO > P(1)' ,
     3 '1.0 , FO < P(1) or FO = P(1)' ,
     4 'P(1)/FO, FO > P(1)' ,
     5 '1/(1 + [(FO - P(2))/P(1)]^2^)' ,
     6 '1/[P(1) + FO + P(2)*FO^2^ + . . + P(NP)*FO^NP^]' ,
     7 '(Data with the key WEIGHT in list 6)' ,
     8 '1/(Data with the key SIGMA(/FO/) in list 6)' ,
     9 '1.0 or 1./2F' ,
     + '1.0/[A[0]*T[0]''(X)+A[1]*T[1]''(X) ... +A[NP-1]*T[NP-1]''(X)]',
     1 '[SIN(theta)/lambda]^P(1)^' ,
     2 '[weight] * exp[8*(p(1)/p(2))*(pi*s)^2^]' ,
     3 '[weight] * [1-(deltaF/6*sigmaF)^2^]^2^ ' ,
     4 '1. / [Sigma^2^(F*)+(P(1)p)^2^+P(2)p+P(4)+P(5)Sin(theta) ]' /
C
      DATA IEXPRS / 1 , 2 , 3 , 4 , 5 , 0 , 6 , 0 , 7 , 0 ,
     2 7 , 0 , 8 , 0 , 8 , 0 , 9 , 0 , 10 , 0 , 10 , 0 , 11 , 0 ,
     3 12, 0, 13, 0, 13, 0, 14, 0, 14, 0 /
C
C
      DATA CRESLT / 'W' , 'SQRT(W)' /
      DATA IRESLT / 2 , 2 , 1 , 1 , 1 , 2 , 1 , 2 , 1 , 1 ,
     2 1, 1, 1, 1, 1, 1, 1 /
C
      DATA CSNAME / '( Modified Hughes )' ,
     1 '( Hughes )' , ' ' ,
     2 '( Cruickshank )' , ' ' ,
     3 ' ' , ' ' , ' ' ,
     9 '( Quasi-Unit weights )' ,
     * '( Chebychev polynomial )' , '( Chebychev polynomial )' ,
     2 ' ' ,
     3 '( Dunitz and Seiler )', 
     4 '( Prince & Tukey modified Chebyshev )',
     5 '( Prince & Tukey modified Chebyshev )',
     6  '( Modified Sheldrick )',
     7  '( Modified Sheldrick )' /
      DATA LNNAME / 19 , 10 , 1 ,
     2 15 , 1 ,
     3 1 , 1 , 1 , 22 ,
     4 24 , 24 ,
     5 1, 21, 40, 40, 22, 22 /
      DATA CEXPRS / 'expressions' /
      DATA LENEXP / 11 /
C
C
C
      ctext(1)=' '
      ctext(2)=' '
      ctext(3)=' '
      ctext(4)=' '
C
C -- BEGIN OUTPUT
C
      ITYPE = ISTORE(L4C)
      IFOTYP = ISTORE(L4C+1)
      LENGTH = LENEXP
C
      write(ctext(1),1014) CSNAME(ITYPE)(2:LNNAME(ITYPE)-1)
1014  format(1x,'Method=',a)
      if (imode .GE.1) then
       IF (ISSPRT .EQ. 0)
     1 WRITE ( NCWU , 1015 ) ITYPE , CSNAME(ITYPE)(1:LNNAME(ITYPE))
       WRITE ( CMON , 1015 ) ITYPE , CSNAME(ITYPE)(1:LNNAME(ITYPE))
       CALL XPRVDU(NCVDU, 1,0)
1015  FORMAT ( 1X , 'Weighting scheme type ' , I3 , 2X , A )
C
       IF ( IEXPRS(2,ITYPE) .LE. 0 ) LENGTH = LENGTH - 1
       IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1016 ) CEXPRS(1:LENGTH)
       WRITE ( CMON  , 1016 ) CEXPRS(1:LENGTH)
       CALL XPRVDU(NCVDU, 1,0)
1016  FORMAT ( 1X , 'Weights are calculated from ' ,
     2 'the following ' , A , ' :-' )
      endif
C
      DO 1018 I = 1 , 2
        ITEXT = IEXPRS(I,ITYPE)
        IF ( ITEXT .GT. 0 ) THEN
        if (imode .ge.1) then
          IF (ISSPRT .EQ. 0)
     1    WRITE ( NCWU , 1017 ) CRESLT(IRESLT(ITYPE)) , CFORMS(ITEXT)
          WRITE ( CMON , 1017 ) CRESLT(IRESLT(ITYPE)) , CFORMS(ITEXT)
          CALL XPRVDU(NCVDU, 1,0)
1017      FORMAT ( 1X , A , ' = ' , A )
        endif
        WRITE (ctext(i+1), 1017 ) CRESLT(IRESLT(ITYPE)), CFORMS(ITEXT)
        ENDIF
1018  CONTINUE
C
      IF (MD4 .GT. 0) THEN
        M4 = L4 + MD4 -1
        if (imode .ge.1) then
         IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1025 )
         WRITE ( CMON , 1025 )
         CALL XPRVDU(NCVDU, 1,0)
1025     FORMAT ( 1X , 'Using parameters :- ')
         IF (ISSPRT .EQ. 0) WRITE (NCWU, 1035) (STORE(J), J = L4, M4 )
         WRITE ( CMON , 1035 ) ( STORE(J) , J = L4 , M4 )
         CALL XPRVDU(NCVDU, 1,0)
1035     FORMAT ( 5X , 6G12.3 )
        endif
        WRITE ( ctext(4) , 1035 ) ( STORE(J) , J = L4 , M4 )
      ENDIF
C
      if (imode .ge.1) then
       IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1045 ) STORE(L4F+1)
       WRITE ( CMON , 1045 ) STORE(L4F+1)
       CALL XPRVDU(NCVDU, 1,0)
1045   FORMAT ( 1X , 'The maximum weight is ' , G12.5 )
      endif
C
      RETURN
      END
C
C
C
C
C
CODE FOR XSUM05
      SUBROUTINE XSUM05 ( ITYPE , LEVEL )
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 5 OR 10
C
\ISTORE
C
\STORE
\XLST05
\XUNITS
\XSSVAL
\XIOBUF
C
\QSTORE
C
\ICOM05
\QLST05
\IDIM05
C
C
      DATA ICNTSZ / 5 /
C
C
      JTYPE = ITYPE
C -- ALLOCATE MONITOR OUTPUT CONTROL AREA
      ICONTR = KSTALL ( ICNTSZ )
      CALL XZEROF ( ISTORE(ICONTR) , ICNTSZ )
C
C -- BEGIN OUTPUT
C
C     SUBROUTINE XMDMON ( ISTART , ISIZE , NDATA , IPOSIT , IPARTP ,
C    2 IFUNC , LEVEL , IMNLVL , IMNCNT , IFLAG , ICONTL )
C
C  ISTART  ADDRESS OF DATA IN 'STORE'
C  ISIZE   LENGTH OF EACH DATA ITEM
C  NDATA   NUMBER OF ITEMS
C  IPOSIT  POSITION OF FIRST ITEM IN ITS GROUP IN LIST 5, USED TO
C          CALCULATE NAMES OF SCALE FACTORS ETC.
C  IPARTP  PARAMETER TYPE
C            1  ATOMIC PARAMETERS
C            2  OVERALL PARAMETERS
C            3  LAYER SCALES
C            4  ELEMENT SCALES
C            5  BATCH SCALES
C            6  CELL PARAMETERS
C            7  PROFILE PARAMETERS
C            8  EXTINCTION PARAMETERS
C  IFUNC   REQUIRED HEADING
C  LEVEL   LEVEL OF LISTING
C  IMNLVL  ALTERNATIVE LEVEL OF LISTING
C            0  OFF     FORCE LIST LEVEL TO BE 0
C            1  LOW     FORCE LIST LEVEL TO BE < 2
C            2  MEDIUM  FORCE LIST LEVEL TO BE 'LEVEL'
C            3  HIGH    FORCE LIST LEVEL TO BE > 1
C  IMNCNT  MONITOR LEVEL CONTROL
C            0  USE SAVED LEVEL - USE WITH IFLAG = 1
C            1  USE 'LEVEL'
C            2  USE 'IMNLVL'
C  IFLAG   FORCE LISTING FLAG
C            0  LIST WHEN ON NEW VALUE OF IFUNC
C            1  FORCE LISTING NOW
C  ICONTL  CONTROL BLOCK ( ARRAY OF LENGTH 5 - SHOULD BE ZERO ON FIRST
C          CALL )
C            WORD 1  SAVED MONITOR LEVEL. THIS VALUE IS ACTUALLY USED
C                    TO CONTROL THE OUTPUT LEVEL
C                      0  NO LISTING
C                      1  LOW ATOMIC
C                      2  MEDIUM ATOMIC
C                      3  HIGH ATOMIC
C                      4  LOW OVERALL
C                      5  MEDIUM/HIGH OVERALL
C                      6  LOW LAYER/BATCH/ELEMENT
C                      7  MEDIUM/HIGH LAYER/BATCH/ELEMENT
C -- OUTPUT SCALE FACTORS OR A SUITABLE ALTERNATIVE MESSAGE IF THERE
C    ARE NONE
      IF ( ( MD5LS +MD5BS +MD5ES +MD5CL + MD5PR +MD5EX )
     1 .LE. 0 ) THEN
        WRITE ( CMON , 1065 )
        CALL XPRVDU(NCVDU, 2,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') (CMON(II)(:),II=1,2)
1065    FORMAT ( 1X , 'There are no layer, element, or batch scales',/,
     1 1X, 'There are no special overall parameters' )
      ELSE
        CALL XMDMON (L5LS,1,MD5LS,1,3, 1,LEVEL,0,1,1,ISTORE(ICONTR))
        CALL XMDMON (L5ES,1,MD5ES,1,4, 1,LEVEL,0,1,1,ISTORE(ICONTR))
        CALL XMDMON (L5BS,1,MD5BS,1,5, 1,LEVEL,0,1,1,ISTORE(ICONTR))
        CALL XMDMON (L5CL,1,MD5CL,1,6, 1,LEVEL,0,1,1,ISTORE(ICONTR))
        CALL XMDMON (L5PR,1,MD5PR,1,7, 1,LEVEL,0,1,1,ISTORE(ICONTR))
        CALL XMDMON (L5EX,1,MD5EX,1,8, 1,LEVEL,0,1,1,ISTORE(ICONTR))
      ENDIF
C -- OUTPUT OVERALL PARAMETERS
CNOV98      CALL XMDMON ( L5O,1,MD5O,1,2, 1,LEVEL,0,1,1,ISTORE(ICONTR) )
      CALL XMDMON ( L5O,1,MD5O,1,2, 1, 2 ,0,1,1,ISTORE(ICONTR) )
C
C -- OUTPUT ATOMS PARAMETERS
      CALL XMDMON ( L5,MD5,N5,1,1, 1,LEVEL,0,1,1,ISTORE(ICONTR) )
C
C----- UPDATE GUIMODEL
C----- SET ILOOP TO A DUMMY, SAVE AUTOUPDTE FLAG
      ILOOP = 0
      CALL XSTRLL ( ICONTR )
      RETURN
      END
C
C
C

CODE FOR XTHETA
      FUNCTION XTHETA(I)
\XLST13
\STORE
\XCONST
\XLST06
      ST = SQRT ( ABS ( SNTHL2(I) ) ) * STORE(L13DC)
      IF ( ST .GT. 1.0 ) THEN
        XTHETA = 90.0
      ELSE
        XTHETA = ASIN ( ST  ) * RTD
      END IF
      RETURN
      END
C
CODE FOR XTHLIM
      SUBROUTINE XTHLIM (THMIN,THMAX,THMCMP,THBEST,THBCMP,
     c                                         IPLOT,IULN,IGLST)
C
C -- ROUTINE WORK OUT COMPLETENESS OF DATA
C
\ISTORE
C
\STORE
\ICOM30
\XLST30
C
\XLST01
\XLST06
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
\QLST30
C
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 2,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL02
      IF (KHUNTR (13,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL13
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL30
      CALL XFAL06 (IULN, 0 )

C -- SCAN LIST 6 FOR ALL REFLECTIONS

      IKLAST = -99999
      ILLAST = -99999
      IHTOT = 0
      IKTOT = 0
      ILTOT = 0
      THMAX = 0.0
      THMIN = 999.0
      IMAXH = 0
      IMINH = 0
      IMAXK = 0
      IMINK = 0
      IMAXL = 0
      IMINL = 0

1100  CONTINUE
        ISTAT = KLDRNR ( 0 )
        IF ( ISTAT .LT. 0 ) GO TO 1200
        ISTAT = KSYSAB ( 2 )
        IMAXH = MAX( IMAXH, NINT (STORE(M6  )) )
        IMAXK = MAX( IMAXK, NINT (STORE(M6+1)) )
        IMAXL = MAX( IMAXL, NINT (STORE(M6+2)) )
        IMINH = MIN( IMINH, NINT (STORE(M6  )) )
        IMINK = MIN( IMINK, NINT (STORE(M6+1)) )
        IMINL = MIN( IMINL, NINT (STORE(M6+2)) )
        IHTOT = IHTOT + 1
        IF ( NINT ( STORE (M6+2) ) .NE. ILLAST ) THEN
          ILTOT = ILTOT + 1
          IKTOT = IKTOT + 1
          ILLAST = NINT(STORE(M6+2))
          IKLAST = NINT(STORE(M6+1))
        ELSE IF ( NINT ( STORE ( M6+1 ) ) .NE. IKLAST ) THEN
          IKTOT = IKTOT + 1
          IKLAST = NINT(STORE(M6+1))
        END IF
        THMAX = MAX ( THMAX, XTHETA(IKTOT) )
        THMIN = MIN ( THMIN, XTHETA(IKTOT) )
      GO TO 1100

1200  CONTINUE

C See if there is a higher possible IMAXH
      STORE(M6) = IMAXH
      STORE(M6+1) = 0.0
      STORE(M6+2) = 0.0
      ICHG = 1
      ICOUNT = 1
      DO WHILE ( ( ICHG .NE. 0 ) .AND. ( ICOUNT .LT. 400 ) )
        ICOUNT = ICOUNT + 1
        ICHG = 0
        STORE(M6) = STORE(M6) + 1.0
        IF ( XTHETA(ICHG) .LT. THMAX ) THEN
          ICHG = 1
          IMAXH = NINT ( STORE(M6) )
        ELSE
          STORE(M6) = STORE(M6) - 1.0
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+1) = STORE(M6+1) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+1) = STORE(M6+1) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+1) = STORE(M6+1) + 1.0
          END IF
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+2) = STORE(M6+2) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+2) = STORE(M6+2) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+2) = STORE(M6+2) + 1.0
          END IF
        END IF
      END DO

C See if there is a lower possible IMINH
      STORE(M6) = IMINH
      STORE(M6+1) = 0.0
      STORE(M6+2) = 0.0
      ICHG = 1
      ICOUNT = 1
      DO WHILE ( ( ICHG .NE. 0 ) .AND. ( ICOUNT .LT. 400 ) )
        ICOUNT = ICOUNT + 1
        ICHG = 0
        STORE(M6) = STORE(M6) - 1.0
        IF ( XTHETA(ICHG) .LT. THMAX ) THEN
          ICHG = 1
          IMINH = NINT ( STORE(M6) )
        ELSE
          STORE(M6) = STORE(M6) + 1.0
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+1) = STORE(M6+1) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+1) = STORE(M6+1) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+1) = STORE(M6+1) + 1.0
          END IF
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+2) = STORE(M6+2) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+2) = STORE(M6+2) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+2) = STORE(M6+2) + 1.0
          END IF
        END IF
      END DO

C See if there is a higher possible IMAXK
      STORE(M6  ) = 0.0
      STORE(M6+1) = IMAXK
      STORE(M6+2) = 0.0
      ICHG = 1
      ICOUNT = 1
      DO WHILE ( ( ICHG .NE. 0 ) .AND. ( ICOUNT .LT. 400 ) )
        ICOUNT = ICOUNT + 1
        ICHG = 0
        STORE(M6+1) = STORE(M6+1) + 1.0
        IF ( XTHETA(ICHG) .LT. THMAX ) THEN
          ICHG = 1
          IMAXK = NINT ( STORE(M6+1) )
        ELSE
          STORE(M6+1) = STORE(M6+1) - 1.0
        END IF

        STO = XTHETA(ICHG)
        STORE(M6) = STORE(M6) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6) = STORE(M6) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6) = STORE(M6) + 1.0
          END IF
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+2) = STORE(M6+2) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+2) = STORE(M6+2) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+2) = STORE(M6+2) + 1.0
          END IF
        END IF
      END DO

C See if there is a higher possible IMINK
      STORE(M6  ) = 0.0
      STORE(M6+1) = IMINK
      STORE(M6+2) = 0.0
      ICHG = 1
      ICOUNT = 1
      DO WHILE ( ( ICHG .NE. 0 ) .AND. ( ICOUNT .LT. 400 ) )
        ICOUNT = ICOUNT + 1
        ICHG = 0
        STORE(M6+1) = STORE(M6+1) - 1.0
        IF ( XTHETA(ICHG) .LT. THMAX ) THEN
          ICHG = 1
          IMINK = NINT ( STORE(M6+1) )
        ELSE
          STORE(M6+1) = STORE(M6+1) + 1.0
        END IF

        STO = XTHETA(ICHG)
        STORE(M6) = STORE(M6) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6) = STORE(M6) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6) = STORE(M6) + 1.0
          END IF
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+2) = STORE(M6+2) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+2) = STORE(M6+2) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+2) = STORE(M6+2) + 1.0
          END IF
        END IF
      END DO

C See if there is a higher possible IMAXL
      STORE(M6) = 0.0
      STORE(M6+1) = 0.0
      STORE(M6+2) = IMAXL
      ICHG = 1
      ICOUNT = 1
      DO WHILE ( ( ICHG .NE. 0 ) .AND. ( ICOUNT .LT. 400 ) )
        ICOUNT = ICOUNT + 1
        ICHG = 0
        STORE(M6+2) = STORE(M6+2) + 1.0
        IF ( XTHETA(ICHG) .LT. THMAX ) THEN
          ICHG = 1
          IMAXL = NINT ( STORE(M6+2) )
        ELSE
          STORE(M6+2) = STORE(M6+2) - 1.0
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+1) = STORE(M6+1) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+1) = STORE(M6+1) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+1) = STORE(M6+1) + 1.0
          END IF
        END IF

        STO = XTHETA(ICHG)
        STORE(M6) = STORE(M6) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6) = STORE(M6) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6) = STORE(M6) + 1.0
          END IF
        END IF
      END DO

C See if there is a lower possible IMINL
      STORE(M6) = 0.0
      STORE(M6+1) = 0.0
      STORE(M6+2) = IMINL
      ICHG = 1
      ICOUNT = 1
      DO WHILE ( ( ICHG .NE. 0 ) .AND. ( ICOUNT .LT. 400 ) )
        ICOUNT = ICOUNT + 1
        ICHG = 0
        STORE(M6+2) = STORE(M6+2) - 1.0
        IF ( XTHETA(ICHG) .LT. THMAX ) THEN
          ICHG = 1
          IMINL = NINT ( STORE(M6+2) )
        ELSE
          STORE(M6+2) = STORE(M6+2) + 1.0
        END IF

        STO = XTHETA(ICHG)
        STORE(M6+1) = STORE(M6+1) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6+1) = STORE(M6+1) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6+1) = STORE(M6+1) + 1.0
          END IF
        END IF

        STO = XTHETA(ICHG)
        STORE(M6) = STORE(M6) + 1.0
        IF ( XTHETA(ICHG) .LT. STO ) THEN
          ICHG = 1
        ELSE
          STORE(M6) = STORE(M6) - 2.0
          IF ( XTHETA(ICHG) .LT. STO ) THEN
            ICHG = 1
          ELSE
            STORE(M6) = STORE(M6) + 1.0
          END IF
        END IF
      END DO

c      ITRSZ = IHTOT + 3*IKTOT + 2*ILTOT
      ITRSZ = IHTOT


C If THBEST is -ve, its absolute value will be used, and it
C will not be optimised.


      IF(STORE(L30CF+10).LT.0.0) THEN
         STORE(L30CF+10)=MAX(STORE(L30CF+10),-THMAX)
         THBEST = -STORE(L30CF+10)

         CALL XCOMPL(ITRSZ,IMINH,IMINK,IMINL,IMAXH,IMAXK,IMAXL,
     1            THBEST, THBCMP, THDUM,THDUM2,-1,IULN,IGLST)
         STORE(L30CF+11)=THBCMP
         CALL XCOMPL(ITRSZ,IMINH,IMINK,IMINL,IMAXH,IMAXK,IMAXL,
     1            THMAX, THMCMP, THDUM,THDUM2,IPLOT,IULN,IGLST)

      ELSE

         CALL XCOMPL(ITRSZ,IMINH,IMINK,IMINL,IMAXH,IMAXK,IMAXL,
     1            THMAX, THMCMP, THBEST,THBCMP,IPLOT,IULN,IGLST)
         STORE(L30CF+10)=THBEST
         STORE(L30CF+11)=THBCMP

      END IF

      STORE(L30IX+6)=THMIN
      STORE(L30IX+7)=THMAX

      STORE(L30CF+9)=THMCMP


      CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)

      RETURN
      END

CODE FOR XCOMPL
      SUBROUTINE XCOMPL ( ITRSZ, JNH,JNK,JNL, JXH,JXK,JXL,
     1              THMAX,THMCMP, THBEST,THBCMP, IPLOT, IULN, IGLST )
\ISTORE
\STORE
\XLST06
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
\QSTORE
      DIMENSION IHKLTR ( 3, ITRSZ + 1 )
      DIMENSION ALLBIN ( 100 )
      DIMENSION FNDBIN ( 100 )
      DIMENSION ACTBIN ( 100 )


      DO I = 1, 100
        ALLBIN(I) = 0.0
        FNDBIN(I) = 0.0
      END DO

      CALL XFAL06(IULN, 0)

      NHKL = 0

      DO WHILE ( KLDRNR ( 0 ) .GE. 0 )
          NHKL = NHKL + 1
          ISTAT = KSYSAB ( 2 )
          DO I = 0,2
            IHKLTR(I+1, NHKL) = STORE(M6+I)
          END DO
      END DO

      CALL XSHELI ( IHKLTR, 3, 3, NHKL, NHKL*3, IHKLTR(1,NHKL+1))

c      DO I = 1,NHKL
c        WRITE(NCWU,'(3I4)') (IHKLTR(J,I),J=1,3)
c      END DO


      NALLWD = 0
      NFOUND = 0
      IMISSI = 0
      
      IF ( IGLST.GE.1 ) THEN
        WRITE (CMON,'(A)') '^^WI SET LMISSING ADDTOLIST'
        CALL XPRVDU(NCVDU,1,0)
      END IF

C Loop through ALL possible indices:
      DO IL = JNL, JXL
        DO IK = JNK, JXK
          DO IH = JNH, JXH
            IF ( ABS(IH) + ABS(IK) + ABS(IL) .EQ. 0 ) CYCLE
            STORE(M6) = IH
            STORE(M6+1) = IK
            STORE(M6+2) = IL
C Check refln is within theta range
            IF ( XTHETA(IH) .LE. THMAX ) THEN
C Check if it is systematically absent.
              IF ( KSYSAB(2) .GE. 0 ) THEN
C Only consider 'allowed' if indices were not changed by KSYSAB:
                IF (     ( NINT(STORE(M6  )) .EQ. IH )
     1              .AND.( NINT(STORE(M6+1)) .EQ. IK )
     2              .AND.( NINT(STORE(M6+2)) .EQ. IL ) ) THEN
                  NALLWD = NALLWD + 1
                  JID = ( ( XTHETA(NALLWD) / THMAX ) * 100.0 )
                  JID = MAX ( 1,  JID )
                  JID = MIN ( 100,JID )
                  ALLBIN(JID) = ALLBIN(JID) + 1.0
                  JP = 1
                  IFOUND = 0

                  DO WHILE ( IHKLTR(3,JP) .NE. IL )
                    JP = JP + 1
                    IF ( JP .GT. NHKL ) JP = -1
                    IF ( JP .LE. 0)  EXIT
                  END DO
                  IF ( JP .GT. 0 ) THEN
                    DO WHILE ( IHKLTR(3,JP) .EQ. IL )
                      IF ( ( IHKLTR(1,JP) .EQ. IH ) .AND.
     1                     ( IHKLTR(2,JP) .EQ. IK ) ) THEN
                           NFOUND = NFOUND + 1
                           IFOUND = 1
                           FNDBIN(JID) = FNDBIN(JID) + 1.0
                           EXIT
                      END IF
                      JP = JP + 1
                      IF ( JP .GT. NHKL ) EXIT
                    END DO
                  END IF
                  IF ( IFOUND .EQ. 0 ) THEN
                    IF ((IPLOT.GE.0 ).AND.( IMISSI .EQ. 0)) THEN
                      WRITE (NCWU,'(A,F5.2,A/A)')
     1 ' The following reflections ( < ',THMAX, ' theta ) are missing:',
     2 '   H    K    L   Theta '
                    END IF
                    IMISSI = IMISSI + 1
                    IF ( IPLOT.GE.0 ) THEN
                      WRITE (NCWU,'(3I5,F8.3)') IH,IK,IL,XTHETA(1)
                    END IF
                    IF ( IGLST.GE.1 ) THEN
                      WRITE (CMON,'(A,3I5,F8.3)')
     c                 '^^WI ',IH,IK,IL,XTHETA(1)
                      CALL XCREMS(CMON,CMON,LENF)
                      CALL XPRVDU(NCVDU,1,0)
                    END IF
                  END IF
                END IF
              END IF
            END IF
          END DO
        END DO
      END DO

      IF ( IGLST.GE.1 ) THEN
        WRITE (CMON,'(A/A)') '^^WI NULL','^^CR'
        CALL XPRVDU(NCVDU,2,0)
      END IF


      IF ( IPLOT .GE. 0 ) THEN
        WRITE(NCWU,'(/A/2(A,I9)/)') ' Completeness of hkl data.',
     1 ' Reflections expected: ', NALLWD, ' Reflections found: ', NFOUND
      END IF

      THMCMP = FLOAT( NFOUND ) / FLOAT ( NALLWD )

      DO I = 1, 100
        IF ( ALLBIN(I) .LE. 0.0) THEN
          ACTBIN(I) = 1.0
        ELSE
          ACTBIN(I) = FNDBIN(I) / ALLBIN(I)
        END IF
      END DO
      DO I = 2, 100
        FNDBIN(I) = FNDBIN(I) + FNDBIN(I-1)
        ALLBIN(I) = ALLBIN(I) + ALLBIN(I-1)
      END DO

      THBEST = 0.0
      THBCMP = 0.0
      CMPMIN  = 1.0

      IF ( IPLOT .GE. 0 ) THEN
        WRITE(NCWU,'(A)') ' Theta  Completeness% Expected  Found '
      ENDIF
      DO I = 1,100
        IF ( ALLBIN(I) .EQ. 0 ) THEN
          COMP = 1.0
        ELSE
          COMP = FNDBIN(I) / ALLBIN(I)
          CMPMIN = MIN (CMPMIN,COMP)
        END IF

        IF ( IPLOT .GE. 0 ) THEN
          WRITE(NCWU,'(F6.2,F11.2,I11,I9)') THMAX*((I)/100.0),
     1   COMP*100., NINT(ALLBIN(I)), NINT(FNDBIN(I))
        END IF

        IF ( I .GE. 75 ) THEN ! Theta_full shouldn't be too low
         IF ( (COMP .GE. THBCMP) .OR. (COMP .GT. 0.995) ) THEN
          THBEST = THMAX*(I/100.0)                       
          THBCMP = COMP
         END IF
        END IF
      END DO

      IF ( IPLOT .GE. 0 ) THEN
        WRITE(NCWU,'(/F6.2,F11.2,A)') THBEST, THBCMP,
     1   '< best theta_full'
      END IF


      IF ( IPLOT .EQ. 1 ) THEN
        CMPMIN = 100.0 * MIN(0.99,CMPMIN)
        WRITE(CMON,'(A/A/A,F7.2,A/A/A/A)')
     1  '^^PL PLOTDATA _COMPL SCATTER ATTACH _VCOMPL KEY',
     1  '^^PL XAXIS TITLE Theta NSERIES=2 LENGTH=100',
     1  '^^PL YAXIS ZOOM ', CMPMIN,
     1  ' 100.0 TITLE ''Cumulative Completeness''',
     1  '^^PL YAXISRIGHT ZOOM 0 100 TITLE ''Shell Completeness''',
     1 '^^PL SERIES 1 SERIESNAME ''Cumulative Completeness'' TYPE LINE',
     1  '^^PL SERIES 2 SERIESNAME ''Shell Completeness''',
     1  '^^PL USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 7,0)

        DO I = 1,100
          IF ( ALLBIN(I) .EQ. 0 ) THEN
            COMP = 1.0
          ELSE
            COMP = FNDBIN(I) / ALLBIN(I)
          END IF

          WRITE(CMON,'(A,F10.3,A,4F10.5)')
     1    '^^PL LABEL ', THMAX*(I/100.0),
     1    ' DATA ', THMAX*(I/100.0),100.0*COMP,
     1              THMAX*(I/100.0),100.0*ACTBIN(I)
          CALL XPRVDU(NCVDU, 1,0)
        END DO

        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)

      END IF


      RETURN
      END

CODE FOR XSUM06
      SUBROUTINE XSUM06 (iuln,  LEVEL )
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 6
C
      CHARACTER *8 CNAME(35)
      CHARACTER *15 HKLLAB

\ICOM30
      DIMENSION KEY(35)
\ISTORE
C
\STORE
\XLST05
\XLST23
\XLST30
C
\XLST01
\XLST06
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
\QLST30
C
C
      DATA KEY/ 1, 2, 3, 4, 5, 6, 0, 0, 0, 0,
     1          0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     1          0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
     1          0, 0, 0, 0, 0 /
C
      DATA CNAME/ 'H','K','L','Fo','Weight','Fc',6*' ',
     1 'Sigma',3*' ','Sth/L**2','Fo/Fc',17*' '/
C
C
      DIMENSION X(N6D)
      DIMENSION Y(N6D)
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF (KHUNTR (23,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL23
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL30

C--SETUP A GRAPH HERE
      IF ( LEVEL .EQ. 4 ) THEN
        WRITE(CMON,'(A,/,A,/,A)')
     1  '^^PL PLOTDATA _FOFC SCATTER ATTACH _VFOFC',
     1  '^^PL XAXIS TITLE Fc NSERIES=1 LENGTH=2000',
     1  '^^PL YAXIS TITLE Fo SERIES 1 TYPE SCATTER'
        CALL XPRVDU(NCVDU, 3,0)
      END IF

C----- PRINT SOME OVER-ALL DETAILS
C--PRINT THE DETAILS RECORD
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1550)
      WRITE ( CMON ,1550)
      CALL XPRVDU(NCVDU, 1,0)
1550  FORMAT(' Quantity',12X,'Minimum',8X,'Maximum')
C--LOOP OVER EACH DETAIL STORED
      M6DTL=L6DTL
      DO 1850 I=2,N6DTL
      IF (KEY(I-1) .EQ. 0) GOTO 1800
C--CHECK IF THIS DETAIL IS SET
      IF(STORE(M6DTL+3)-ZERO)1600,1700,1700
C--NOT SET  -  PRINT THE CAPTION AND IGNORE IT
1600  CONTINUE
      IF (ISSPRT .EQ. 0)WRITE(NCWU,1650) CNAME(I-1)
      WRITE ( CMON ,1650) CNAME(I-1)
      CALL XPRVDU(NCVDU, 1,0)
1650  FORMAT(6X,A8, 4X,'No details available')
      GOTO 1800
C--PRINT THE DETAILS
1700  CONTINUE
      K=M6DTL+MD6DTL-3
      IF (ISSPRT .EQ. 0)
     1 WRITE(NCWU,1750) CNAME(I-1), (STORE(J),J=M6DTL,K)
      WRITE ( CMON ,1750) CNAME(I-1), (STORE(J),J=M6DTL,K)
      CALL XPRVDU(NCVDU, 1,0)
1750  FORMAT(6X,A8,2X,6E15.6)
C--UPDATE FOR THE NEXT PARAMETER
1800  CONTINUE
      M6DTL=M6DTL+MD6DTL
1850  CONTINUE
C
C -- SCAN LIST 6 FOR ACCEPTED REFLECTIONS
C
      SCALE = STORE(L5O)
      TOP = 0.0
      BOTTOM = 0.0
      WTOP = 0.0
      WBOT = 0.0
      SIGTOP = 0.0
      IFSQ = ISTORE(L23MN+1)
      N6ACC = 0
      FCMAX = 0
1100  CONTINUE
        ISTAT = KFNR ( 0 )
        IF ( ISTAT .LT. 0 ) GO TO 1200

        N6ACC = N6ACC + 1
        FO = STORE(M6+3)
        FC = SCALE * STORE(M6+5)
        FCMAX = MAX( FCMAX, FC )
        IF ( LEVEL .EQ. 4 ) THEN
          WRITE(HKLLAB, '(2(I4,A),I4)') NINT(STORE(M6)),',',
     1    NINT(STORE(M6+1)), ',', NINT(STORE(M6+2))
          CALL XCRAS(HKLLAB, IHKLLEN)

          WRITE(CMON,'(3A,2F10.2)')
     1   '^^PL LABEL ''', HKLLAB(1:IHKLLEN), ''' DATA ', FC ,FO
          CALL XPRVDU(NCVDU, 1,0)
        ENDIF


        WT = STORE(M6+4)
        TOP = TOP + ABS (ABS(FO) - FC)
        BOTTOM = BOTTOM + ABS(FO)
        SIGTOP = SIGTOP + STORE(M6+12)
        IF (IFSQ .GE. 0) THEN
C - FSQ REFINENENT
            WDEL = WT* (FO * ABS(FO) - FC*FC)
            WFO = WT* (FO * ABS(FO))
        ELSE
            WDEL = WT * (FO - FC)
            WFO = WT * FO
        ENDIF
        WTOP = WTOP + WDEL*WDEL
        WBOT = WBOT + WFO*WFO
      GO TO 1100
1200  CONTINUE

      IF ( LEVEL .EQ. 4 ) THEN      !Also output the omitted refls.

        WRITE(CMON,'(A)')
     1  '^^PL ADDSERIES Omitted TYPE SCATTER'
        CALL XPRVDU(NCVDU,1,0)

        CALL XFAL06 (IULN, 0 )
        DO WHILE ( KLDRNR ( 0 ) .GE. 0 )
          IF (KALLOW(IN).LT.0) THEN
            FO = STORE(M6+3)
            FC = SCALE * STORE(M6+5)
            FCMAX = MAX( FCMAX, FC )

            WRITE(HKLLAB, '(2(I4,A),I4)') NINT(STORE(M6)),',',
     1      NINT(STORE(M6+1)), ',', NINT(STORE(M6+2))
            CALL XCRAS(HKLLAB, IHKLLEN)
            WRITE(CMON,'(3A,2F10.2)')
     1     '^^PL LABEL ''', HKLLAB(1:IHKLLEN), ''' DATA ', FC ,FO
c            WRITE(CMON,'(A,2F10.2)')
c     1     '^^PL DATA ', FC ,FO
            CALL XPRVDU(NCVDU, 1,0)
          ENDIF
        END DO

c Also add A SERIES FOR STRAIGHT LINE (y=x) for extinction spotting.
        WRITE(CMON,'(A/A,2F10.2)') '^^PL ADDSERIES ''Fo=Fc'' TYPE LINE',
     1  '^^PL DATA 0 0 DATA ', FCMAX, FCMAX
        CALL XPRVDU(NCVDU,2,0)

      END IF


C
C
C -- BEGIN OUTPUT
C


C----- COMPUTE AND STORE R-VALUES
      RFACT = 100. * TOP / BOTTOM
      RSIGM = 100. * SIGTOP / BOTTOM
      IF (WBOT .LE. 0.0) THEN
        WRFAC = 0.0
      ELSE
        WRFAC = 100. * SQRT (WTOP / WBOT)
      ENDIF
      STORE(L6P+1) = RFACT
      STORE(L6P+2) = WRFAC
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1215 ) N6D , N6ACC
      WRITE ( CMON , 1215 ) N6D, N6ACC
      CALL XPRVDU(NCVDU, 1,0)
1215  FORMAT ( 1X , 'List 6 contains ' , I5 , ' reflections' ,
     1 ' of which ' , I5 , ' are accepted by LIST 28')
C
C
C -- PRINT THE R VALUE ETC.
      J = NINT(STORE(L6P))
      M6P = L6P+2
      IF (ISSPRT .EQ. 0)
     1 WRITE ( NCWU , 1235 ) J , ( STORE(I+1) , I=L6P,M6P ), RSIGM
      WRITE ( CMON , 1235 ) J , ( STORE(I+1) , I=L6P,M6P ), RSIGM
      CALL XPRVDU(NCVDU, 3,0)

1235  FORMAT (1X , 'After ' , I5 ,
     2 ' structure factor/refinement calculations ' , / ,
     3 1X , ' R =  ' , F6.2 , 5X , 'Weighted R = ' , F6.2 ,
     4 5X , 'Minimisation function = ' , E15.6, / ,
     5     'Rsigma=', F6.2 )

C -- FINISH THE GRAPH DEFINITION
      IF ( LEVEL .EQ. 4 ) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF
C
C
C----- UPDATE LIST 30
C----- DONT UPDATE LIST 30 -  THE USER MIGHT BE FIDDLING WITH LIST 28
C      STORE(L30RF) = RFACT
C      STORE(L30RF+1) = WRFAC
C      CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
      RETURN
      END
C
cCODE FOR FUNCT - USER FUNCTIONS FOR LEAST-SQUARES FITTING
c      FUNCTION FUNCT(K,X)
c      SELECT CASE(K)
c        CASE(:-1)
c          FUNCT = 0
c        CASE(0)
c          FUNCT = X**2
c        CASE(1)
c          FUNCT = X
c        CASE(2)
c          FUNCT = 0
c        END SELECT
c      END
C
C
C
C
CODE FOR XSUM13
      SUBROUTINE XSUM13
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 13
C
      PARAMETER ( NCRYST = 2 , NSPRED = 2 , NGEOMY = 10 , NRADTN = 2 )
      CHARACTER*30 CCRYST(NCRYST)
      CHARACTER*10 CSPRED(NSPRED)
      CHARACTER*10 CGEOMY(NGEOMY)
      CHARACTER*8 CRADTN(NRADTN)
C
\ISTORE
C
\STORE
\XLST13
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
      DATA CCRYST / 'Friedel''s Law is used' ,
     2 'The crystal is twinned' /
      DATA CSPRED / 'Gaussian' , 'Lorentzian' /
      DATA CGEOMY /
     1 'NORMAL', 'EQUI', 'ANTI', 'PRECESSION', 'UNKNOWN',
     2 'CAD4', 'ROLLETT', 'Y290', 'KAPPA', 'AREA'
     3  /
      DATA CRADTN / 'X-rays' , 'neutrons' /
C
C -- BEGIN OUTPUT
C
      IND13 = L13CD
      DO 1100 I = 1 , NCRYST
        IF ( ISTORE(IND13) .GE. 0 ) THEN
          IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1025 ) CCRYST(I)
          WRITE ( CMON , 1025 ) CCRYST(I)
          CALL XPRVDU(NCVDU, 1,0)
1025      FORMAT ( 1X , A )
        ENDIF
        IND13 = IND13 + 1
1100  CONTINUE
C
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1105 ) CSPRED(ISTORE(L13CD+2))
      WRITE ( CMON , 1105 ) CSPRED(ISTORE(L13CD+2))
      CALL XPRVDU(NCVDU, 1,0)
1105  FORMAT ( 1X , 'The mosaic spread is ' , A)
C
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1125 )
     1 CGEOMY(ISTORE(L13DT)), CRADTN(ISTORE(L13DT+1)+2)
      WRITE ( CMON , 1125 )
     1 CGEOMY(ISTORE(L13DT)), CRADTN(ISTORE(L13DT+1)+2)
      CALL XPRVDU(NCVDU, 2,0)
1125  FORMAT ( 1X , 'The diffraction geometry is ' , A /
     1 1X , 'Data was collected with ' , A )
C
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1145 ) STORE(L13DC)
      WRITE ( CMON , 1145 ) STORE(L13DC)
      CALL XPRVDU(NCVDU, 1,0)
1145  FORMAT ( 1X , 'The wavelength is ' , F12.5 )
C
      RETURN
      END
C
C
C
C
C
CODE FOR XSUM14
      SUBROUTINE XSUM14
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 14
C
      PARAMETER ( NAXIS = 3 , NDIVTP = 2 )
      CHARACTER*1 CAXIS(NAXIS)
      CHARACTER*7 CDIREC(NAXIS)
      CHARACTER*11 CDIVTP(NDIVTP)
C
\ISTORE
C
\STORE
\XLST14
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
      DATA CAXIS / 'X' , 'Y' , 'Z' /
      DATA CDIREC / 'down' , 'across' , 'through' /
      DATA CDIVTP / 'Angstrom' , 'Division(s)' /
C
C
C
C -- BEGIN OUTPUT
C
C
      IF (ISSPRT .EQ. 0)
     1 WRITE ( NCWU , 1025 ) ( CDIREC(J) , CAXIS(ISTORE(L14O+J-1)) ,
     2                         J = 1 , NAXIS )
      WRITE ( CMON , 1025 ) ( CDIREC(J) , CAXIS(ISTORE(L14O+J-1)) ,
     2                         J = 1 , NAXIS )
      CALL XPRVDU(NCVDU, 1,0)
1025  FORMAT ( 1X , 'Orientation of map is ',
     1 3 ( A , 1X , A , 2X ) )
C
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1035 ) STORE(L14SC)
      WRITE ( CMON , 1035 ) STORE(L14SC)
      CALL XPRVDU(NCVDU, 1,0)
1035  FORMAT (1X , 'The map scale factor is ' , F10.5  )
C
      IND14 = L14
      DO 1400 I = 1 , N14
C
        IF ( ABS(STORE(IND14+3)) .LE. ZERO ) THEN
          IDIV = 1
        ELSE
          IDIV = 2
        ENDIF
C
      IF (ISSPRT .EQ. 0)
     1 WRITE ( NCWU , 1305 ) CAXIS(I), STORE(IND14), STORE(IND14+2),
     2                          STORE(IND14+1) , CDIVTP(IDIV)
      WRITE ( CMON , 1305 ) CAXIS(I), STORE(IND14), STORE(IND14+2),
     2                          STORE(IND14+1) , CDIVTP(IDIV)
      CALL XPRVDU(NCVDU, 1,0)
1305  FORMAT ( 1X , 'The ' , A , ' axis runs from ' , F7.2 ,
     2 ' to ' , F7.2 , ' in steps of ' , F8.4 , 1X , A )
C
        IF ( IDIV .EQ. 2 ) THEN
            IF (ISSPRT .EQ. 0)
     1      WRITE ( NCWU , 1315 ) CAXIS(I) , STORE(IND14+3)
      WRITE ( CMON , 1315 ) CAXIS(I) , STORE(IND14+3)
      CALL XPRVDU(NCVDU, 1,0)
1315      FORMAT ( 11X , 'The ' , A , ' axis is divided into ' ,
     2             F8.4 , ' divisions' )
        ENDIF
C
        IND14 = IND14 + MD14
1400  CONTINUE
C
      END
C
C
CODE FOR XSUM23
      SUBROUTINE XSUM23
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 23
C
      PARAMETER (NMODFC = 7, NMODMN = 3, MMODSP = 5, NMODSP = 2)
      CHARACTER *34 CMODFC(NMODFC) , CMODMN(NMODMN)
      CHARACTER *13  CHARSP(MMODSP,NMODSP), CSP1(NMODSP)
C
      LOGICAL LHEADR
C
\ISTORE
C
\STORE
\XLST23
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
      DATA CMODFC / 'Anomalous scattering' , 'Extinction parameter' ,
     2 'Layer scale factors' , 'Batch scales factors' ,
     3 'Uses stored partial contributions',
     3 'Updates stored contributions' , 'Enantiopole parameter' /
C
      DATA CMODMN(1) / 'Refinement against /F0/ **2' /
      DATA CMODMN(2) / 'Restraints applied' /
      DATA CMODMN(3) / 'Reflections used' /
C
      DATA CHARSP / 'Nothing', 'Warnings', 'Origin fixing',
     1 'Restraints ', 'Constraints ',
     2 'Nothing', 'Occupancies', 'Parameters',
     3 ' ', ' '/
      DATA CSP1 /' issued', ' updated'/
C
C
C
C -- BEGIN OUTPUT
C
      LHEADR = .FALSE.
C
      IND23 = L23M
      DO 1000 I = 1, NMODFC
        IF ( ISTORE(IND23) .GE. 0 ) THEN
          IF ( .NOT. LHEADR ) THEN
            IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1105 )
            WRITE ( CMON , 1105 )
            CALL XPRVDU(NCVDU, 1,0)
1105        FORMAT ( 1X, 'Modifications applied to /FO/ and /FC/ :-')
            LHEADR = .TRUE.
          ENDIF
          IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1115 ) CMODFC(I)
          WRITE ( CMON , 1115 ) CMODFC(I)
          CALL XPRVDU(NCVDU, 1,0)
1115      FORMAT ( 2X , A )
        ENDIF
        IND23 = IND23 + 1
1000  CONTINUE
C
      IF ( LHEADR ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1125 )
1125    FORMAT ( 1X )
      ELSE
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1135 )
        WRITE ( CMON , 1135 )
        CALL XPRVDU(NCVDU, 1,0)
1135    FORMAT ( 1X , 'No modifications to /FO/ and /FC/')
      ENDIF
C
      LHEADR = .FALSE.

      IF (ISSPRT .EQ. 0) WRITE(NCWU,2000) ISTORE(L23MN)
      WRITE ( CMON ,2000) ISTORE(L23MN)
      CALL XPRVDU(NCVDU, 1,0)
2000  FORMAT(1X,'Refinement terminated if more than ',I4,
     1 ' singularities')
C
      IND23 = L23MN + 1
      DO 2100 I = 1 , NMODMN
        IF ( ISTORE(IND23) .GE. 0 ) THEN
          IF ( .NOT. LHEADR ) THEN
            IF (ISSPRT .EQ. 0) WRITE ( NCWU , 2005 )
            WRITE ( CMON , 2005 )
            CALL XPRVDU(NCVDU, 1,0)
2005        FORMAT ( 1X, 'Conditions applied to minimisation ' ,
     2                    'function :-')
            LHEADR = .TRUE.
          ENDIF
          IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1115 ) CMODMN(I)
          WRITE ( CMON , 1115 ) CMODMN(I)
          CALL XPRVDU(NCVDU, 1,0)
        ENDIF
        IND23 = IND23 + 1
2100  CONTINUE
C
      IF ( LHEADR ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 2105 )
2105    FORMAT ( 1X )
      ELSE
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 2115 )
        WRITE ( CMON , 2115 )
        CALL XPRVDU(NCVDU, 1,0)
2115    FORMAT ( 1X , 'No conditions on minimisation function')
      ENDIF
C
C
      I = KHUNTR( 23, 106, IADDL, IADDR, IADDD, -1)
      IF ( I .EQ. 0) THEN
C----- THIS IS A NEW FORMAT LIST 23
        LHEADR = .FALSE.
C
C
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 3105 )
        WRITE ( CMON , 3105 )
        CALL XPRVDU(NCVDU, 1,0)
3105    FORMAT ( 1X, 'Treatment of atoms on SPECIAL positions:-')
C
        IND23 = L23SP
        DO 3000 I = 1, NMODSP
           J = ISTORE(IND23)+2
           IF (ISSPRT .EQ. 0) WRITE (NCWU, 3115 ) CHARSP(J,I), CSP1(I)
           WRITE ( CMON , 3115 ) CHARSP(J,I), CSP1(I)
           CALL XPRVDU(NCVDU, 1,0)
3115       FORMAT ( 2X , A, A )
           IND23 = IND23+1
3000    CONTINUE
        IF (ISSPRT .EQ. 0) WRITE(NCWU,3116) STORE(L23SP+5)
        WRITE ( CMON , 3116)  STORE(L23SP+5)
        CALL XPRVDU(NCVDU, 1,0)
3116  FORMAT(' Tolerance for coincidence = ', G10.5)
C
      ELSE
        IF (ISSPRT .EQ. 0) WRITE(NCWU,3120)
        WRITE ( CMON ,3120)
        CALL XPRVDU(NCVDU, 1,0)
3120    FORMAT(1X, 'This is an old format LIST 23 - Input a new one')
      ENDIF
      RETURN
      END
C
C
CODE FOR XSUM25
      SUBROUTINE XSUM25
\ISTORE
\STORE
\XLST25
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
C
       WRITE ( CMON , 1015 ) N25
       CALL XPRVDU(NCVDU, 1,0)
1015  FORMAT ( 1X , I5 , ' Twin Laws are stored' , / )
C
      IF (N25 .GT. 0) THEN
      M25 = L25
      DO 3000 J = 1, N25
       WRITE(CMON,1106) (STORE(I),I = M25 , M25 + MD25 -1)
1106   FORMAT ( 3(3F7.3,2X) )
       CALL XPRVDU(NCVDU, 1,0)
      M25 = M25 + MD25
3000  CONTINUE
      ENDIF
      RETURN
      END
C
C
C
C
CODE FOR XSUM27
      SUBROUTINE XSUM27
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 27
C
\ISTORE
C
\STORE
\XLST27
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
C
       WRITE ( CMON , 1015 ) N27
       CALL XPRVDU(NCVDU, 1,0)
1015  FORMAT ( 1X , I5 , ' scale factors are known' , / )
C
      IF (N27 .GT. 0) THEN
       M27 = L27 + (N27-1)*MD27
       J = 1
       DO 2000 I = L27 , M27 , MD27
         IF (J .GE. 80) THEN
             CALL XPRVDU(NCVDU, 1,0)
             J = 1
         ENDIF
         WRITE(CMON(1)(J:),1106) STORE(I+1)
1106    FORMAT ( F8.3 )
         J = J + 8
2000   CONTINUE
       IF (J .NE. 1) CALL XPRVDU(NCVDU, 1,0)
      ENDIF
C
C
      RETURN
      END
C
C
C
C
C
CODE FOR XSUM28
      SUBROUTINE XSUM28
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 28
C
      LOGICAL LHEADR
C
\ISTORE
C
\STORE
\XLST28
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
C
C
C -- BEGIN OUTPUT
      IF (MD28SK .GT. 1 ) THEN
        I = MD28SK-1
        IF (ISSPRT .EQ. 0) WRITE(NCWU,500) I, MD28SK
        WRITE ( CMON ,500) I, MD28SK
        CALL XPRVDU(NCVDU, 1,0)
500     FORMAT (1X,I4, ' out of ', I4,' reflections will be skipped')
      ENDIF
C
      LHEADR = (( N28MN + N28MX + N28RC + N28OM +N28CD) .NE. 0 )
C
      IF ( LHEADR ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1015 )
        WRITE ( CMON , 1015 )
        CALL XPRVDU(NCVDU, 1,0)
1015    FORMAT ( 1X , 'Reflections are selected by the following ' ,
     2                  'conditions :-' )
C
        IF ( N28MN .GT. 0 ) THEN
          INDNAM = L28CN
          DO 1200 I = L28MN , M28MN , MD28MN
            IF (ISSPRT .EQ. 0) THEN
            WRITE ( NCWU , 1105 ) ( ISTORE(J) ,
     2      J = INDNAM , INDNAM + 2 ) , STORE(I+1)
            ENDIF
            WRITE ( CMON , 1105 ) ( ISTORE(J) ,
     2      J = INDNAM , INDNAM + 2 ) , STORE(I+1)
            CALL XPRVDU(NCVDU, 1,0)
1105        FORMAT ( 2X , 'Minimum value of ' , 3A4 , ' is ' , F10.5 )
            INDNAM = INDNAM + MD28CN
1200      CONTINUE
        ENDIF
C
        IF ( N28MX .GT. 0 ) THEN
          INDNAM = L28CX
          DO 1400 I = L28MX , M28MX , MD28MX
            IF (ISSPRT .EQ. 0) THEN
             WRITE ( NCWU , 1305 ) ( ISTORE(J) ,
     2       J = INDNAM , INDNAM + 2 ) , STORE(I+1)
            ENDIF
            WRITE ( CMON , 1305 ) ( ISTORE(J) ,
     2       J = INDNAM , INDNAM + 2 ) , STORE(I+1)
            CALL XPRVDU(NCVDU, 1,0)
1305        FORMAT ( 2X , 'Maximum value of ' , 3A4 , ' is ' , F10.5 )
            INDNAM = INDNAM + MD28CX
1400      CONTINUE
        ENDIF
C
        IF ( N28RC .GT. 0 ) THEN
          DO 1600 I = L28RC , M28RC , MD28RC
            IF ( STORE(I+MD28RC-1) .EQ. 0 ) THEN
             IF (ISSPRT .EQ. 0) THEN
              WRITE ( NCWU , 1504 ) ( STORE(J) , J = I , I + MD28RC - 2)
             ENDIF
             WRITE ( CMON , 1504 ) ( STORE(J) , J = I , I + MD28RC - 2)
             CALL XPRVDU(NCVDU, 1,0)
            ELSE
             IF (ISSPRT .EQ. 0) THEN
              WRITE ( NCWU , 1505 ) ( STORE(J) , J = I , I + MD28RC - 2)
             ENDIF
             WRITE ( CMON , 1505 ) ( STORE(J) , J = I , I + MD28RC - 2)
             CALL XPRVDU(NCVDU, 1,0)
            END IF
1504        FORMAT ( 2X , F6.2 , '*h + ' , F6.2 , '*k + ' ,
     2 F6.2 , '*l must not lie in range ' , F6.2 , ' to ' , F6.2 )
1505        FORMAT ( 2X , F6.2 , '*h + ' , F6.2 , '*k + ' ,
     2 F6.2 , '*l must lie in range     ' , F6.2 , ' to ' , F6.2 )
1600      CONTINUE
        ENDIF
C
C
        IF ( N28CD .GT. 0 ) THEN
          DO 1850 I = L28CD , M28CD , MD28CD
          IF (ISSPRT .EQ. 0) THEN
            WRITE ( NCWU , 1855 ) ( STORE(J) , J = I , I + MD28CD - 1)
          ENDIF
            WRITE ( CMON , 1855 ) ( STORE(J) , J = I , I + MD28CD - 1)
            CALL XPRVDU(NCVDU, 1,0)
1855        FORMAT ( 2X , F6.2 , ' h + ' , F6.2 , ' k + ' ,
     2 F6.2 , ' l + ' , F6.2 , ' divided by ' , F6.2 ,
     3 ' must be integer')
1850      CONTINUE
        ENDIF
C
      IF ( N28OM .GT. 0 ) THEN
       WRITE(CMON,'(''Omitted Reflections'')')
       CALL XPRVDU(NCVDU, 1,0)
       M28OM = L28OM + (N28OM-1)*MD28OM
       J = 1
       INC = 14
       DO 2000 I = L28OM , M28OM , MD28OM
          IF (ISSPRT .EQ. 0) THEN
            WRITE ( NCWU , 1705 ) ( NINT(STORE(K)), K = I, I+MD28OM-1 )
          ENDIF
1705        FORMAT ( 11X , 'Reflection ' , 3I4 , '  omitted' )
         IF (J+INC .GE. 80) THEN
             CALL XPRVDU(NCVDU, 1,0)
             J = 1
         ENDIF
         WRITE(CMON(1)(J:),1106) (NINT(STORE(K)), K = I, I+MD28OM-1)
1106    FORMAT ( ':',3I4,':' )
         J = J + INC
2000   CONTINUE
       IF (J .NE. 1) CALL XPRVDU(NCVDU, 1,0)
      ENDIF
C
      ELSE
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 2005 )
        WRITE ( CMON , 2005 )
        CALL XPRVDU(NCVDU, 1,0)
2005    FORMAT ( 1X , 'Reflections are not subject to restrictions' )
      ENDIF
C
C
      RETURN
      END
C
CODE FOR XSUM29
      SUBROUTINE XSUM29
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 29
C
\ISTORE
C
\STORE
\XLST29
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
      IF ( N29 .GT. 0 ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1015 )
        WRITE ( CMON , 1015 )
        CALL XPRVDU(NCVDU, 2,0)
1015    FORMAT ( ' Type              Radius              ' ,
     2 '  Number     Mu    Atomic Colour' /
     3         1X , '   Covalent  Van der Waals     Ionic  ' ,
     4 '                   weight' )
C
        DO 2000 I = L29 , M29 , MD29
        IF (ISSPRT .EQ. 0) THEN
          WRITE ( NCWU , 1105 ) ( STORE(J) , J = I , I + MD29 - 1 )
        ENDIF
          WRITE ( CMON , 1105 ) ( STORE(J) , J = I , I + MD29 - 1 )
          CALL XPRVDU(NCVDU, 1,0)
1105      FORMAT ( 1X , A4 ,  F7.4 , 2X , F13.4 , 2X , F8.4 , 2X ,
     2 F8.3 , F8.2 ,  F9.3,2X,A4 )
2000    CONTINUE
      ELSE
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 2005 )
        WRITE ( CMON , 2005 )
        CALL XPRVDU(NCVDU, 1,0)
2005    FORMAT ( 1X , 'No element details stored in list 29' )
      ENDIF
C
      RETURN
      END
C
C
CODE FOR XSUM30
      SUBROUTINE XSUM30
C
C----- NUMBER OF RECORDS IN COMMON BLOCK
      PARAMETER (MAXBLK = 9)
C----- NUMBER (MAX) OF KEYS IN EACH BLOCK
      PARAMETER (MAXKEY = 19)
      CHARACTER *16 CTYPE(MAXBLK)
      CHARACTER *25  CKEY(MAXKEY,MAXBLK)
      CHARACTER *80 CLINE, CLOW
C
      CHARACTER *15 CINSTR, CDIR,  CPARAM, CVALUE, CDEF
C
      DIMENSION IPOINT(36)
C
C
\ISTORE
C
\STORE
\XLST30
\XUNITS
\XSSVAL
\XCONST
\XIOBUF
C
\QSTORE
C
      EQUIVALENCE (L30DR, IPOINT(1))
C
C
      DATA CTYPE /
     1 'OBSERVATIONS', 'CONDITIONS', 'REFINEMENT', 'INDICES',
     2 'ABSORPTION', 'GENERAL', 'COLOUR', 'SHAPE', 'CIF'/
C
      DATA (CKEY(I,1),I=1,MAXKEY)/
     1 'Total measured', '*', 'No. merged with Friedel',
     2 'R merged with Friedel',  'No. merged no Friedel',
     3 'R merged no Friedel', 13*'*'
     * /
      DATA (CKEY(I,2),I=1,MAXKEY)/
     1 'Smallest dimension', 'Medium dimension', 'Maximum Dimension',
     2 'No of orienting refs', 'Theta min orienting refs',
     3 'Theta max orienting refs', 'Temperature',
     4 'No of standards', 'Percent decay', '*','Interval', 'Count',
     5  7*'*'
     * /
      DATA (CKEY(I,3),I=1,MAXKEY)/
     1 'R', 'Rw', 'No. param last cycle', 'Sigma Cutoff', 'S',
     2 'Del rho min','Del rho max','max RMS shift','Reflections used',
     3 'Fo min function', 'Restraint min func', 'Total min func',
     4  7*'*'
     * /
      DATA (CKEY(I,4),I=1,MAXKEY)/
     1 'Hmin', 'Hmax', 'Kmin', 'Kmax', 'Lmin', 'Lmax', 'Theta min',
     2 'Theta max', 11*'*'
     * /
      DATA (CKEY(I,5),I=1,MAXKEY)/
     1 4*'*', 'empirical min', 'Empirical max', 'refdelf min',
     2 'refdelf max', 11*'*'
     * /
      DATA (CKEY(I,6),I=1,MAXKEY)/
     1 'Dobs', 'Dcalc', 'Fooo', 'Mu', 'M', 'Z', 'Flack',
     2 'Flack esd', 'Sigma Analyse',
     3 'No. Analyse', 'R Analyse', 'Rw Analyse',
     4 7*'*'
     * /
      DATA (CKEY(I,7),I=1,MAXKEY)/ 19*'*' /
      DATA (CKEY(I,8),I=1,MAXKEY)/ 19*'*' /
      DATA (CKEY(I,9),I=1,MAXKEY)/ 
     1 'Sigma Calc', 'No. Calc', 'R Calc', 'Rw Calc',
     2 'Sigma All', 'No. All', 'R All', 'Rw All', 'Extn-su',
     4 'Completeness' , 'Theta-full', 'Cmpltnss-full', 'Pressure kPa',
     5 'Number restraints','*','x','y','z','*' /
C
C
C
1000    FORMAT ( 1X , 'No ', A16,  ' details stored in list 30' )
C
      CALL XPRTCN
C
      DO 5000 J = 1, MAXBLK
C----- THE ALL-TEXT ITEMS
        IF ((J.EQ.7) .OR. (J.EQ.8))  THEN
            I = 4 * (J-1) +1
            L30 = IPOINT(I)
            MD30 = IPOINT(I+2)
            IF ( MD30 .GT. 0 ) THEN
              CLINE(1:80) = ' '
              WRITE(CLINE,'(A,3X,8A4)') CTYPE(J),
     1        (ISTORE(K), K = L30, L30 + MD30 -1)
              CALL XCCLWC ( CLINE(2:), CLOW(2:))
              CLOW(1:1) = CLINE(1:1)
              IF (ISSPRT .EQ. 0) WRITE(NCWU,1021) CLOW
              WRITE ( CMON , 1021) CLOW
              CALL XPRVDU(NCVDU, 1,0)
            ENDIF
        ELSE
      I = 4 * (J-1) +1
      L30 = IPOINT(I)
      MD30 = IPOINT(I+2)
      IF ( MD30 .GT. 0 ) THEN
         IF (ISSPRT .EQ. 0) WRITE(NCWU, '(/A)') CTYPE(J)
         WRITE ( CMON , '(/A)') CTYPE(J)
         CALL XPRVDU(NCVDU, 2,0)
         M = 0
         DO 3000 K = 1, MD30
          IF (CKEY(K,J) .NE. '*') THEN
           A = STORE(K-1+L30)
           NA = NINT(A)
           IF (ABS(A-NA) .LT. ZERO) THEN
              WRITE(CVALUE,'(I13)') NA
           ELSE
              WRITE(CVALUE,'(F13.5)') A
           ENDIF
          ELSE
            CVALUE = ' '
          ENDIF
          N = K - 2 *(K/2)
            IF (N .EQ. 1) THEN
C----- ODD ITEMS - IF '*' THEN LOOP
              CLINE(1:80) = ' '
              IF (CKEY(K,J) .EQ. '*') GOTO 3000
              WRITE ( CLINE( 1:40) , 1010 ) CKEY(K,J),CVALUE
              M = 1
1010          FORMAT (A,A)
            ELSE
C----- EVEN ITEMS - DONT SAVE '*', BUT PRINT FIRST PART
              IF (CKEY(K,J) .NE. '*') THEN
              WRITE ( CLINE( 41:80) , 1010 ) CKEY(K,J),CVALUE
                M = 1
              ENDIF
              IF ( M .EQ. 1) THEN
                IF (ISSPRT .EQ. 0) WRITE (NCWU, '(A)') CLINE
                WRITE ( CMON, '(A)') CLINE
                CALL XPRVDU(NCVDU, 1,0)
                M = 0
              ENDIF
            ENDIF
3000     CONTINUE
C----- FINISHED ON AN ODD ITEM, SO MUST PRINT
        IF ((N .EQ. 1) .AND. ( M .EQ. 1)) THEN
            IF (ISSPRT .EQ. 0) WRITE (NCWU, '(A)') CLINE
            WRITE ( CMON, '(A)') CLINE
            CALL XPRVDU(NCVDU, 1,0)
        ENDIF
3010    CONTINUE
C
        IF ( J .EQ. 1 ) THEN
C----- PARAMETER 13 ON DIRECTIVE 1 IS A CHARACTER STRING
C DATA REDUCTION
          IPARAM  = 13
          IDIR = 1
          IVAL = ISTORE( L30 +IPARAM -1)
          GOTO 3020
        ELSE IF ( J .EQ. 2 ) THEN
C----- PARAMETER 10 ON DIRECTIVE 2 IS A CHARACTER STRING
C SCAN MODE
          IPARAM  = 10
          IDIR = 2
          IVAL = ISTORE( L30 +IPARAM -1)
C----- WE HAVE TO COPY IN THE CODE HERE BECUSE THERE ARE 2
C      TEXT ITEMS
        IZZZ= KGVAL(CINSTR, CDIR, CPARAM, CVALUE, CDEF,
     1                    33, IDIR, IPARAM, IVAL, JVAL, VAL, JTYPE)
        CLINE(1:80) = ' '
        WRITE(CLINE,1020) CPARAM, CVALUE
        CALL XCCLWC ( CLINE(2:), CLOW(2:))
        CLOW(1:1) = CLINE(1:1)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,1021) CLOW
        WRITE(CMON, 1021) CLOW
        CALL XPRVDU(NCVDU, 1,0)
C----- PARAMETER 13 ON DIRECTIVE 2 IS A CHARACTER STRING
C SCAN MODE
          IPARAM  = 13
          IDIR = 2
          IVAL = ISTORE( L30 +IPARAM -1)
          GOTO 3020
        ELSE IF ( J .EQ. 3 ) THEN
C----- PARAMETER 13 ON DIRECTIVE 3 IS A CHARACTER STRING
C F COEFFICIENT
          IPARAM  = 13
          IDIR = 3
          IVAL = ISTORE( L30 +IPARAM -1)
          GOTO 3020
        ELSE IF ( J .EQ. 5 ) THEN
C----- PARAMETER 9 ON DIRECTIVE 5 IS A CHARACTER STRING
C ABSORPTION TYPE
          IPARAM  = 9
          IDIR = 5
          IVAL = ISTORE( L30 +IPARAM -1)
          GOTO 3020
        ELSE IF ( J .EQ. 6 ) THEN
C----- PARAMETER 13 ON DIRECTIVE 6 IS A CHARACTER STRING
C STRUCTURE SOLUTION
          IPARAM  = 13
          IDIR = 6
          IVAL = ISTORE( L30 +IPARAM -1)
          GOTO 3020
        ENDIF
        GOTO 3040
3020    CONTINUE
        IZZZ= KGVAL(CINSTR, CDIR, CPARAM, CVALUE, CDEF,
     1                    33, IDIR, IPARAM, IVAL, JVAL, VAL, JTYPE)
        CLINE(1:80) = ' '
        WRITE(CLINE,1020) CPARAM, CVALUE
        CALL XCCLWC ( CLINE(2:), CLOW(2:))
        CLOW(1:1) = CLINE(1:1)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,1021) CLOW
        WRITE(CMON, 1021) CLOW
        CALL XPRVDU(NCVDU, 1,0)
1020    FORMAT ( A, 3X,A)
1021    FORMAT (  A)
3040    CONTINUE
      ELSE
          IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1000 ) CTYPE(J)
          WRITE ( CMON , 1000 ) CTYPE(J)
          CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      ENDIF
5000  CONTINUE
      RETURN
      END
C
C
C
CODE FOR XSUMOP
      SUBROUTINE XSUMOP ( OPER , XLATT , TEXT , LENGTH, IMODE )
C
C -- CONVERT MATRIX FORM OF SYMMETRY OPERATOR TO TEXT
C
C -- INPUT :-
C
C      OPER        SYMMETRY OPERATOR IN MATRIX FORM
C      XLATT       LATTICE TRANSLATION TO ADD. THIS CAN BE USED
C                  TO GENERATE ALL OPERATORS NEEDED IF THE LATTICE
C                  TYPE CANNOT BE USED TO DO THIS. ( I.E. SNOOPI
C                  DOES NOT UNDERSTAND LATTICE TYPES, SO OPERATORS
C                  EXPLICITLY INCLUDING THE EFFECT OF CENTERING MUST BE
C                  GENERATED )
C
C -- OUTPUT :-
C      TEXT        TEXT REPRESENTATION OF OPERATOR IN FORM
C                    X,Y,Z  OR  X,Y,Z+1/2  ETC.
C      LENGTH      USEABLE LENGTH OF TEXT
C      IMODE       IF 0, LEAVE OUT WHOLE-CELL TRANSLATIONS
C
      DIMENSION OPER(3,4) , XLATT(3)
      CHARACTER*(*) TEXT
C
      CHARACTER*1 AXIS(3)
      CHARACTER *3 CTRANS
C
\XUNITS
\XIOBUF
\XCONST
C
      DATA AXIS / 'X' , 'Y' , 'Z' /
C
C -- CLEAR TEXT BUFFER
      TEXT = ' '
      LENGTH = 0
C
C -- SCAN EACH COMPONENT
      DO 2000 I = 1 , 3
        IF ( I .NE. 1 ) THEN
          LENGTH = LENGTH + 1
          TEXT(LENGTH:LENGTH) = ','
        ENDIF
C
C -- DETERMINE 'X' , 'Y' , 'Z' PART
      IFIRST = 1
        DO 1900 J = 1 , 3
          IOPER = NINT ( OPER(J,I) )
          IF ( IOPER .EQ. 0 ) GO TO 1900
          IF ( IOPER .LT. 0 ) THEN
            LENGTH = LENGTH + 1
            TEXT(LENGTH:LENGTH) = '-'
          ELSE IF ( IFIRST .LE. 0 ) THEN
            LENGTH = LENGTH + 1
            TEXT(LENGTH:LENGTH) = '+'
          ENDIF
          LENGTH = LENGTH + 1
          TEXT(LENGTH:LENGTH) = AXIS(J)
          IFIRST = 0
1900    CONTINUE
C
C -- DETERMINE TRANSLATIONAL PART, BUT ONLY FOR NON-INTEGRAL
C    TRANSLATIONS
        TRANS = OPER(I,4) + XLATT(I)
cdjwapr2001
        jtrans = int(abs(trans)) * nint(sign(1., trans))
        itrans = nint(trans)
        imult = 1
        IF ( ABS( TRANS - REAL(NINT(TRANS)) ) .LE. ZERO ) then
          GO TO 1975
        endif
C
C -- CONVERT TRANSLATION TO RATIO OF TWO WHOLE NUMBERS
C -- NOTE TOLERANCE IS QUITE CRUDE INCASE VALUES LIKE 0.33 ARE USED
        FAC = 1.
        XTRANS = TRANS
1950    CONTINUE
        IF ( ABS ( TRANS - REAL ( NINT ( TRANS ) ) ) .GT. .01 ) THEN
          FAC = FAC + 1.0
          TRANS = XTRANS * FAC
          XMULT = FAC
          GO TO 1950
        ENDIF
C
C -- CONVERT RATIO FOUND TO PAIR OF INTEGERS, AND REMOVE COMMON FACTORS
C
        ITRANS = NINT ( TRANS )
        IMULT = NINT ( XMULT )
        IFAC = 2
1970    CONTINUE
        IF ( ( IFAC * ( ITRANS / IFAC ) .EQ. ITRANS  ) .AND.
     2       ( IFAC * ( IMULT / IFAC ) .EQ. IMULT )    ) THEN
          ITRANS = ITRANS / IFAC
          IMULT = IMULT / IFAC
          IFAC = IFAC + 1
          IF ( IFAC .LE. NINT ( FAC ) ) GO TO 1970
        ENDIF
C
C -- ADD TRANSLATIONAL COMPONENT TO OUTPUT STRING. ( NUMERATOR MUST
C    BE PRECEDED BY A PLUS OR MINUS SIGN, HENCE FORMAT 'SP' )
C
1975  continue
cdjwapr2001
      if (imode .eq. 0)  itrans=mod(itrans,imult)
c
      if (itrans .ne. 0) then
        WRITE ( CTRANS , '(SP,I3)' ) ITRANS
        DO 1980 J = 1 , 3
          IF ( CTRANS(J:J) .NE. ' ' ) THEN
            LENGTH = LENGTH + 1
            TEXT(LENGTH:LENGTH) = CTRANS(J:J)
          ENDIF
1980    CONTINUE
      endif
C
      if (imult .gt. 1) then
        LENGTH = LENGTH + 1
        TEXT(LENGTH:LENGTH) = '/'
C
        WRITE ( CTRANS , '(I3)' ) IMULT
        DO 1990 J = 1 , 3
          IF ( CTRANS(J:J) .NE. ' ' ) THEN
            LENGTH = LENGTH + 1
            TEXT(LENGTH:LENGTH) = CTRANS(J:J)
          ENDIF
1990    CONTINUE
      endif
C
C
2000  CONTINUE
C
C
      RETURN
      END


CODE FOR XSUM40
      SUBROUTINE XSUM40
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 40
C
      CHARACTER * 32 CATOM1, CATOM2, CBLANK
      DATA CBLANK /' '/

\XUNITS
\XIOBUF
\STORE
\ISTORE
\QSTORE
\XLST40


C--OUTPUT DEFAULTS CARD:
       WRITE(CMON,21)NINT(STORE(L40T)),STORE(L40T+1),
     1 NINT(STORE(L40T+2)), NINT(STORE(L40T+3)),STORE(L40T+4)
21     FORMAT(/,' Tolerance function=',I2,' (0=sum+tol,1=sum*tol)',/,
     2        ' Tolerance=',F6.3,/,
     3        ' Maximum no. of bonds to an atom =',I4,/,
     4        ' No symmetry calculation = ',I4,' (0=symm,1=nosymm)',/,
     5        ' Significant atom movement =',F10.5,' Angstroms',//)
       CALL XPRVDU(NCVDU,7,0)
     
C--OUTPUT ANY ELEMENT CARDS
      IF ( N40E .GT. 0 ) THEN 
        WRITE(CMON,'(A//A/)')
     1  'Over-ride List 29 covalent radii and maximum no. of bonds:',
     2  '  Element  Covalent Radius  Maximum Bonds'
        CALL XPRVDU(NCVDU,4,0)
        DO I = L40E,L40E+(MD40E*(N40E-1)),MD40E
          WRITE(CMON,22) ISTORE(I), STORE(I+1), NINT(STORE(I+2))
22        FORMAT(4X,A4,6X,F8.4,10X,I4)
          CALL XPRVDU(NCVDU,1,0)
        END DO
      ELSE
        WRITE(CMON,'(A//A)')
     1  'Over-ride List 29 covalent radii and maximum no. of bonds:',
     2  '  There are no element directives.'
        CALL XPRVDU(NCVDU,3,0)
      ENDIF

C--OUTPUT ANY PAIR CARDS
      WRITE(CMON,'(/A//)')
     1  'Over-ride covalent radii for a pair of elements:'
      CALL XPRVDU(NCVDU,3,0)
      IF (N40P .GT. 0) THEN
        WRITE(CMON,'(A/)')
     1    '  Element  Element  Min-Dist  Max-Dist  Bond Type'
        CALL XPRVDU(NCVDU,2,0)
        DO I = L40P,L40P+(MD40P*(N40P-1)),MD40P
          WRITE(CMON,23) ISTORE(I), ISTORE(I+1),STORE(I+2),
     1                 STORE(I+3), NINT(STORE(I+4))
23        FORMAT(4X,A4,5X,A4,4X,F6.3,4X,F6.3,5X,I4)
          CALL XPRVDU(NCVDU,1,0)
         END DO
       ELSE
        WRITE(CMON,'(A)')'  There are no pair directives.'
        CALL XPRVDU(NCVDU,1,0)
       END IF


24      FORMAT (2A, ' to ', A, I4)
25      FORMAT (2A, ' to ', A)

      WRITE(CMON,'(//A/)') 'Additional bonds to make:'
      CALL XPRVDU(NCVDU,3,0)
      IF (N40M.GT.0)THEN
        WRITE(CMON,'(A/)')
     1 '                    Bond                             Type'
        CALL XPRVDU(NCVDU,2,0)
C--OUTPUT ANY BONDS TO MAKE
        DO I = L40M,L40M+(MD40M*(N40M-1)),MD40M
          CALL CATSTR (STORE(I),FLOAT(ISTORE(I+1)),
     2                  ISTORE(I+2),ISTORE(I+3),
     3                  ISTORE(I+4),ISTORE(I+5),ISTORE(I+6),
     4                  CATOM1, LATOM1)
          CALL CATSTR (STORE(I+7),FLOAT(ISTORE(I+8)),
     2                  ISTORE(I+9),ISTORE(I+10),
     3                  ISTORE(I+11),ISTORE(I+12),ISTORE(I+13),
     4                  CATOM2, LATOM2)
          WRITE (CMON,24) CBLANK(1: 21-LATOM1),
     2                  CATOM1(1:LATOM1), CATOM2,ISTORE(I+14)
          CALL XPRVDU(NCVDU,1,0)
        END DO
      ELSE
        WRITE(CMON,'(A)')'  There are no make directives.'
        CALL XPRVDU(NCVDU,1,0)
      ENDIF


      WRITE(CMON,'(//A/)') 'Bonds to break:'
      CALL XPRVDU(NCVDU,3,0)
      IF (N40B.GT.0)THEN
        WRITE(CMON,'(A/)')
     1 '                    Bond'
        CALL XPRVDU(NCVDU,2,0)
C--OUTPUT ANY BONDS TO BREAK
        DO I = L40B,L40B+(MD40B*(N40B-1)),MD40B
          CALL CATSTR (STORE(I),FLOAT(ISTORE(I+1)),
     2                ISTORE(I+2),ISTORE(I+3),
     3                ISTORE(I+4),ISTORE(I+5),ISTORE(I+6),
     4                CATOM1, LATOM1)
          CALL CATSTR (STORE(I+7),FLOAT(ISTORE(I+8)),
     2                ISTORE(I+9),ISTORE(I+10),
     3                ISTORE(I+11),ISTORE(I+12),ISTORE(I+13),
     4                CATOM2, LATOM2)
          WRITE (CMON,25)CBLANK(1: 21-LATOM1),
     2                   CATOM1(1:LATOM1), CATOM2(1:LATOM2)
          CALL XPRVDU(NCVDU,1,0)
        END DO
      ELSE
        WRITE(CMON,'(A)')'  There are no break directives.'
        CALL XPRVDU(NCVDU,1,0)
      ENDIF

      RETURN
      END


CODE FOR XSUM41
      SUBROUTINE XSUM41
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 41
C

\XUNITS
\XIOBUF
\STORE
\ISTORE
\QSTORE
\XLST41
\XLST05
      CHARACTER * 32 CATOM1, CATOM2, CBLANK
      DATA CBLANK /' '/

      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05


      WRITE(CMON,'(/,A,//A//,2X,I6,6X,I9,5X,I5,9X,I6//)')
     1 'Dependencies:',
     1 ' List5 size   List5 CRC  List5 serial  List40 serial',
     2 (ISTORE(L41D+J),J=0,3)
      CALL XPRVDU(NCVDU,9,0)

C To do - check dependencies at this point

      WRITE(CMON,'(A,//,A,35x,A/)')'Bonds:',
     1 '                    Bond','Type   Length'

      CALL XPRVDU(NCVDU,4,0)

24      FORMAT (2A, ' to ', A, I4,1x,F10.3)

      DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B

          I51 = L5 + ISTORE(M41B) * MD5
          I52 = L5 + ISTORE(M41B+6) * MD5


          CALL CATSTR (STORE(I51),STORE(I51+1),
     2                  ISTORE(M41B+1),ISTORE(M41B+2),
     3                  ISTORE(M41B+3),ISTORE(M41B+4),ISTORE(M41B+5),
     4                  CATOM1, LATOM1)
          CALL CATSTR (STORE(I52),STORE(I52+1),
     2                  ISTORE(M41B+7),ISTORE(M41B+8),
     3                  ISTORE(M41B+9),ISTORE(M41B+10),ISTORE(M41B+11),
     4                  CATOM2, LATOM2)
          WRITE (CMON,24) CBLANK(1: 21-LATOM1),
     2                  CATOM1(1:LATOM1), CATOM2,ISTORE(M41B+12),
     3                  STORE(M41B+13)
          CALL XPRVDU(NCVDU,1,0)

      END DO


      RETURN
      END



C
CODE FOR XSGDST
      SUBROUTINE XSGDST
      DIMENSION KSIGS(110)
      DIMENSION LSIGS(25,3)
      CHARACTER *15 HKLLAB
\ISTORE
\STORE
\XLST06
\XLST01
\ICOM30
\XLST30
\XUNITS
\XSSVAL
\XERVAL
\XOPVAL
\XCONST
\XIOBUF
\QSTORE
\QLST30
      DATA ICOMSZ / 3 /
      DATA IVERSN /100/

C -- SET THE TIMING AND READ THE CONSTANTS

      CALL XTIME1 ( 2 )
      CALL XCSAE

C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
      ICOMBF = KSTALL( ICOMSZ )
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910

      IPLOT1 = ISTORE(ICOMBF)
      IPLOT2 = ISTORE(ICOMBF+1)
      ITYP06 = ISTORE(ICOMBF+2)
      IULN = KTYP06(ITYP06)
      CALL XFAL06 (IULN, 0)
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01


      DO I = 1,110
        KSIGS(I) = 0
      END DO
      DO I = 1,3
        DO J = 1,25
          LSIGS(J,I) = 0
        END DO
      END DO

C -- SCAN LIST 6 FOR REFLECTIONS

      NTOT = 0
      NALLOW = 0

      ISTAT = KLDRNR(0)
      IF ( KALLOW(IN).EQ. 0 ) NALLOW = NALLOW + 1 



      DO WHILE ( ISTAT .GE. 0 )
        NTOT = NTOT + 1
        CALL XSQRF(FOS, STORE(M6+3), FABS, SIGMA, STORE(M6+12))
        JSIGS = 10 + NINT( (2.*FOS)/SIGMA )
        JSIGS = MAX(JSIGS,1)
        IF ( JSIGS .LE. 110 ) KSIGS(JSIGS) = KSIGS(JSIGS) + 1

        SIGNOI = FOS/SIGMA
        JSIGS = 3
        IF ( SIGNOI .LT. 10 ) JSIGS = 2
        IF ( SIGNOI .LT. 3 ) JSIGS = 1
        MSIGS = 1 + NINT( STORE(M6+16) * 25.0 / 0.5 )
        MSIGS = MAX ( 1,MSIGS )
        MSIGS = MIN ( 25,MSIGS )
        LSIGS(MSIGS,JSIGS) = LSIGS(MSIGS,JSIGS) + 1
        ISTAT = KLDRNR(0)
        IF ( KALLOW (IN) .EQ. 0 ) NALLOW = NALLOW + 1
      END DO



      IF (IPLOT2 .EQ. 1) THEN
        WRITE(CMON,'(A,5(/A))')
     1  '^^PL PLOTDATA _SIGRES SCATTER ATTACH _VSIGRES KEY',
     1  '^^PL XAXIS TITLE ''(sin(theta)/lambda)**2'' NSERIES=3',
     1  '^^PL LENGTH=25 YAXIS TITLE ''Frequency''',
     1  '^^PL SERIES 1 SERIESNAME ''I/sigma(I)<3.0'' TYPE LINE ',
     1  '^^PL SERIES 2 SERIESNAME ''I/sigma(I)<10.0'' TYPE LINE ',
     1  '^^PL SERIES 3 SERIESNAME ''I/sigma(I)>10.0'' TYPE LINE '
        CALL XPRVDU(NCVDU, 6,0)

        DO I = 1,25
          WRITE(CMON,'(A,3(F7.3,1X,I8,1X))')
     1     '^^PL DATA ',((I*0.4/25.0),LSIGS(I,J),J=1,3)
          CALL XPRVDU(NCVDU, 1,0)
        END DO
 
        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      END IF

      IF (IPLOT1 .EQ. 1) THEN
        WRITE(CMON,'(A,6(/A))')
     1  '^^PL PLOTDATA _SIGLEVL BARGRAPH ATTACH _VSIGLEVL KEY',
     1  '^^PL XAXIS TITLE ''I/sigma(I)'' NSERIES=2 LENGTH=100',
     1  '^^PL YAXIS TITLE ''Number of observations''',
     1  '^^PL YAXISRIGHT TITLE ''Number > given I/s(I)''',
     1  '^^PL SERIES 1 SERIESNAME ''I/sigma(I) frequency''',
     1  '^^PL SERIES 2 SERIESNAME ''Observations > I/sigma(I)''',
     1  '^^PL TYPE LINE USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 7,0)

        DO I = 1, 110
          WRITE(CMON,'(A,1X,F5.1,1X,A,1X,I6,1X,I8)')
     1    '^^PL LABEL',(I-11)*.5,'DATA',KSIGS(I),NTOT
          CALL XPRVDU(NCVDU,1,0)
          NTOT = NTOT - KSIGS(I)
        END DO

        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)

      END IF

      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .NE. 0) CALL XFAL30
      STORE(L30GE +9 ) = NALLOW
      CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)


9000  CONTINUE
C -- FINAL MESSAGE
      CALL XOPMSG ( IOPDSP , IOPEND , IVERSN )
      CALL XTIME2 ( 2 )
      CALL XRSL
      CALL XCSAE
      RETURN

9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDSP , IOPABN , 0 )
      GO TO 9000

9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDSP , IOPCMI , 0 )
      GO TO 9900
      RETURN

      END

CODE FOR XTWINP
      SUBROUTINE XTWINP
      DIMENSION KSIGS(25)
      DIMENSION BAD(3), TEMP(3), RJKL(3)
\ISTORE
\STORE
\XLST06
\XLST01
\ICOM30
\XLST30
\XUNITS
\XSSVAL
\XERVAL
\XOPVAL
\XCONST
\XIOBUF
\QSTORE
\QLST30
      DATA ICOMSZ / 11 /
      DATA IVERSN /100 /

C -- SET THE TIMING AND READ THE CONSTANTS

      CALL XTIME1 ( 2 )
      CALL XCSAE

C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
      ICOMBF = KSTALL( ICOMSZ )
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910

      IPLOT = ISTORE(ICOMBF+9)
      ITYP06 = ISTORE(ICOMBF+10)
      IULN = KTYP06(ITYP06)
      CALL XFAL06 (IULN, 0)
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01

      DO I = 1,25
        KSIGS(I) = 0
      END DO

C Calculate max distance in A^-2.

      bad(1)=0.5
      bad(2)=0.5
      bad(3)=0.5
      CALL XMLTMM(STORE(L1M2),BAD,TEMP,3,3,1)
      CALL VPROD(BAD,TEMP,DMX)
      DMX = MAX(DMX,ZEROSQ)
      DMX = SQRT(DMX)

      WRITE(CMON,'(A,G13.6)')'Highest dist = ',DMX
      CALL XPRVDU(NCVDU,1,0)

      tmx =   store(l1s)*bad(1)*bad(1)
     1     +store(l1s+1)*bad(2)*bad(2)
     2     +store(l1s+2)*bad(3)*bad(3)
     3     +store(l1s+3)*bad(2)*bad(3)
     4     +store(l1s+4)*bad(1)*bad(3)
     5     +store(l1s+5)*bad(1)*bad(2)

      tmx = tmx * 4.0

      TMX = MAX(TMX,ZEROSQ)
      TMX = SQRT(TMX)

      WRITE(CMON,'(A,G13.6)')'Highest test = ',TMX
      CALL XPRVDU(NCVDU,1,0)


C SCAN LIST 6 FOR REFLECTIONS


      ISTAT = KLDRNR(0)


      DO WHILE ( ISTAT .GE. 0 )

        DMIN = 1000.0
        DO J = -1,1
         RJKL(1) = J
         DO K = -1,1
          RJKL(2) = K
          DO L = -1,1
           RJKL(3) = L

           CALL XMLTMM(STORE(ICOMBF),STORE(M6),TEMP,3,3,1)
           DO I=1,3
             BAD(I) = (TEMP(I) - NINT(TEMP(I)) + RJKL(I) )
           END DO
 
           CALL XMLTMM(STORE(L1M2),BAD,TEMP,3,3,1)
           CALL VPROD(BAD,TEMP,D)
           IF ( D .GT. ZEROSQ ) D = SQRT(D)
           IF ( D .LT. DMIN ) DMIN = D

          END DO

         END DO

        END DO

        JSIGS = 1 + ( 25. * DMIN / DMX )
        JSIGS = MAX(JSIGS,1)
        JSIGS = MIN(JSIGS,25)
        KSIGS(JSIGS) = KSIGS(JSIGS) + 1

        ISTAT = KLDRNR(0)
      END DO

      IF (IPLOT .EQ. 1) THEN
        WRITE(CMON,'(A,3(/A))')
     1  '^^PL PLOTDATA _XTLA BARGRAPH ATTACH _TLA',
     1  '^^PL XAXIS TITLE ''Deviation in A^-1'' NSERIES=1 LENGTH=25',
     1  '^^PL YAXIS TITLE ''Number of observations''',
     1  '^^PL SERIES 1 SERIESNAME ''Number of reflections at'''
        CALL XPRVDU(NCVDU, 4,0)

        DO I = 1, 25
          WRITE(CMON,'(A,1X,F9.5,1X,A,1X,I6)')
     1    '^^PL LABEL',(I-1)*DMX/25.0,'DATA',KSIGS(I)
          CALL XPRVDU(NCVDU,1,0)
        END DO

        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)

      END IF

9000  CONTINUE
C -- FINAL MESSAGE
      CALL XOPMSG ( IOPDSP , IOPEND , IVERSN )
      CALL XTIME2 ( 2 )
      CALL XRSL
      CALL XCSAE
      RETURN

9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDSP , IOPABN , 0 )
      GO TO 9000

9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDSP , IOPCMI , 0 )
      GO TO 9900
      RETURN

      END


CODE FOR XSPGPL
      SUBROUTINE XSPGPL
      DIMENSION KSIGS(50,2), GM(3)
\ISTORE
\STORE
\XLST06
\XLST01
\ICOM30
\XLST30
\XUNITS
\XSSVAL
\XERVAL
\XOPVAL
\XCONST
\XIOBUF
\QSTORE
\QLST30
      DATA ICOMSZ / 15 /
      DATA IVERSN /100 /

C -- SET THE TIMING AND READ THE CONSTANTS

      CALL XTIME1 ( 2 )
      CALL XCSAE

C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
      ICOMBF = KSTALL( ICOMSZ )
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910

      IPLOT = ISTORE(ICOMBF+9)
      ITYP06 = ISTORE(ICOMBF+10)
      IULN = KTYP06(ITYP06)
      CALL XFAL06 (IULN, 0)
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01

      DO I = 1,50
        KSIGS(I,1) = 0
        KSIGS(I,2) = 0
      END DO

C Find max value of Fo

      RFOMAX =  STORE(L6DTL+3*MD6DTL+1)

C SCAN LIST 6 FOR REFLECTIONS


      ISTAT = KLDRNR(0)

      DO WHILE ( ISTAT .GE. 0 )

        CALL XMLTMM(STORE(ICOMBF),STORE(M6),GM,3,3,1)
C If indices are unchanged under op, then this ref is in the group.
        CALL XSUBTR(STORE(M6),GM,GM,3)
        CALL VPROD(GM,GM,D)
        IF ( D .LT. ZERO ) THEN
C Work out which bin.
          RFO = STORE(M6+3) / STORE(M6+12)
          JSIGS = 6 + ( 45. * RFO / RFOMAX )
          JSIGS = MAX(JSIGS,1)
          JSIGS = MIN(JSIGS,50)
C Work out whether inc or exc.
          CALL VPROD(STORE(ICOMBF+11),STORE(M6),D)

c          WRITE(CMON,'(4F4.0)')STORE(M6),
c     1 STORE(M6+1),STORE(M6+2),D
c          CALL XPRVDU(NCVDU,1,0)

          IF ( MOD ( NINT(D), ISTORE(ICOMBF+14) ) .EQ. 0 ) THEN
               KSIGS(JSIGS,1) = KSIGS(JSIGS,1) + 1
          ELSE
               KSIGS(JSIGS,2) = KSIGS(JSIGS,2) + 1
          END IF
        END IF
        ISTAT = KLDRNR(0)
      END DO

      IF (IPLOT .EQ. 1) THEN
        WRITE(CMON,'(A,4(/A))')
     1  '^^PL PLOTDATA _XSPGA BARGRAPH ATTACH _SPGA KEY',
     1  '^^PL XAXIS TITLE ''Fobs'' NSERIES=2 LENGTH=50',
     1  '^^PL YAXIS TITLE ''Number of observations''',
     1 '^^PL SERIES 1 SERIESNAME ''Condition TRUE''',
     1 '^^PL SERIES 2 SERIESNAME ''Condition FALSE'''
        CALL XPRVDU(NCVDU, 5,0)

        DO I = 1, 50
          WRITE(CMON,'(A,1X,F9.2,1X,A,1X,I6,1X,I6)')
     1    '^^PL LABEL',(I-6)*RFOMAX/45.0,'DATA',KSIGS(I,1),KSIGS(I,2)
          CALL XPRVDU(NCVDU,1,0)
        END DO

        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)

      END IF

9000  CONTINUE
C -- FINAL MESSAGE
      CALL XOPMSG ( IOPDSP , IOPEND , IVERSN )
      CALL XTIME2 ( 2 )
      CALL XRSL
      CALL XCSAE
      RETURN

9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDSP , IOPABN , 0 )
      GO TO 9000

9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDSP , IOPCMI , 0 )
      GO TO 9900
      RETURN

      END

CODE FOR XSUM42
      SUBROUTINE XSUM42
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 42
C

\XUNITS
\XIOBUF
\XLST42
\STORE
\ISTORE
\QSTORE

      M42M = L42M

      WRITE(CMON,'(A,3I8)')'Summary of list 42: ',NINT(STORE(L42L+7)),
     1 NINT(STORE(L42L+4)),NINT(STORE(L42L+1))
      CALL XPRVDU(NCVDU,1,0)


      DO I = 1, NINT(STORE(L42L+7))
       WRITE(CMON,'(/A,I5)')'Mask section ',I
       CALL XPRVDU(NCVDU,2,0)
       DO J = 1, NINT(STORE(L42L+4))
C CDD For g77 changed       CMON = ' '   to:
        WRITE(CMON,'(A)') ' '
        DO K = 1, MIN(80,NINT(STORE(L42L+1)))
         WRITE(CMON(1)(K:K),'(I1)')ISTORE(M42M+K-1)
        END DO
        CALL XPRVDU(NCVDU,1,0)
        M42M = M42M+NINT(STORE(L42L+1))
       END DO
      END DO

      RETURN
      END

