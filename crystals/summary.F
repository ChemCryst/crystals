C $Log: summary.F,v $
C Revision 1.109  2013/07/04 09:58:31  djw
C Correct text for quasi unit weight scheme
C
C Revision 1.108  2013/07/03 09:27:15  rich
C Comment nmax (unused).
C
C Revision 1.107  2013/05/24 09:47:05  djw
C Modify sigma vs resolution graph (Tabbed Initial) to use rightaxes for the average(I)/sigma(I) - may be easier to understand.
C
C Revision 1.106  2012/09/17 12:24:53  rich
C DPROD subroutine name clashes with intrinsic function. Renamed DVPROD.
C
C Revision 1.105  2012/09/10 16:06:17  djw
C Increase format statement foe weight vs Sigma plot
C
C Revision 1.104  2012/07/12 08:35:14  rich
C Changed completeness test array back to dynamic - this will still cause problems with large data sets. Need to find a better algorithm soon.
C
C Revision 1.103  2012/06/07 11:59:32  djw
C Add note about possible causes of P(2) being large (Twinning)
C
C Revision 1.102  2011/11/03 09:19:10  rich
C Fix output format.
C
C Revision 1.101  2011/09/21 14:27:25  rich
C Switch labels for RMS and ABS in SUML30 (now correct).
C
C Revision 1.100  2011/09/19 13:03:45  djw
C In wt vs Sigma, interchange axes.  All unit line to NPP and wt vs Sigma plots
C
C Revision 1.99  2011/09/06 12:23:41  djw
C Enable plots of weight ve 1/sigma
C
C Revision 1.98  2011/07/01 13:42:46  djw
C Change the dot product module name from VPROD to DPROD
C
C Revision 1.97  2011/06/13 14:25:35  djw
C remove the blue line and enable info to be obtained from the red one
C
C Revision 1.96  2011/05/25 12:45:35  djw
C Increase field for atom count
C
C Revision 1.95  2011/05/23 16:07:58  rich
C For abs config normal probability plot, use weight instead of sigma.
C Fix axis on normal normal probability plot.
C
C Revision 1.94  2011/05/19 11:04:43  rich
C Correct description of L4 scheme 5 and 6 in XSUM04
C Allow larger (2-digit) exponents on output weights in FCF.
C Output zero for weight on omitted reflections.
C
C Revision 1.93  2011/05/13 11:16:51  djw
C Calls to Kallow now return a key to the test which failed and a value to indicate if it was Max or Min. The argument of KALLOW must be a variable
C
C Revision 1.92  2011/03/15 09:00:09  djw
C More work on LIST 9
C Routine which use LISTs 5,9,10 all use the same common block, ICOM05, for loading from the disk and for
C creating output.
C If one needs two of these lists in memeory at the same time, the calling routine must sort out the common
C block (l5,l9,l10) addresses itself.
C XFAL09 loads a LIST 9, and saves the LIST 5 addresses if L5 is already in core.
C
C Revision 1.91  2011/02/07 16:59:07  djw
C Put IDIM09 as a parameter in ICOM09 so that we can use it to declare work space
C
C Revision 1.90  2011/01/25 08:42:36  djw
C Add Mcmahon flag and fix file closing when there are no list 28 omissions
C
C Revision 1.89  2011/01/20 15:40:17  djw
C Use Brian McMahons data names
C
C Revision 1.88  2011/01/19 14:43:47  djw
C Move header for OMIT so that nothing appears if there are no omissions
C
C Revision 1.87  2011/01/19 14:36:54  djw
C Tag OMITTED reflections onto end of cif
C
C Revision 1.86  2010/11/04 15:18:43  djw
C Do completeness in terms of (sin(theta)lambda)^3 i.e. equal volumes
C
C Revision 1.85  2010/07/16 11:37:37  djw
C Enable XPCHLX to output lists 12 and 16 to the cif file.  This means carrying the I/O chanel (as NODEV)
C  in XPCHLX,XPCHLH,PPCHND and XPCHUS.
C Fixed oversight in distangle for esds of H-bonds
C
C Revision 1.84  2010/07/07 16:11:45  djw
C Output corresct list tpe for 6/7
C
C Revision 1.83  2010/06/17 15:42:11  djw
C Load L25 if it exists for KSYSAB
C
C Revision 1.82  2010/06/03 17:00:28  djw
C Output thresholds upto 5 sigma (was 3)
C
C Revision 1.81  2009/10/28 16:27:56  djw
C Add error print to .LIS as well as screen. Correct base address for parameters in 
C DELU (was mistakenly changed in last update) list16.fpp
C
C Revision 1.80  2009/07/31 12:44:47  djw
C Insert a message about inapprpriate weights
C
C Revision 1.79  2009/06/17 13:43:28  djw
C Messages for merged data corrected to match COMMANDS.DSC
C
C Revision 1.78  2009/02/05 11:40:53  djw
C Output summary of lists 40 and 41 to printer for Dave.
C
C Revision 1.77  2008/11/21 16:05:06  djw
C Improvements in formatting output, trap negative sqrts and zero denominators
C
C Revision 1.76  2008/11/19 18:30:00  djw
C Compute slope and intercept for normal probability plot
C
C Revision 1.75  2008/03/31 14:48:15  djw
C output more info from L13
C
C Revision 1.74  2006/11/10 08:28:08  djw
C Small format change
C
C Revision 1.73  2006/05/23 12:30:25  djw
C Increase format for No of reflections
C
C Revision 1.72  2006/03/09 19:03:31  djw
C Correct initialisation of sios and nios
C
C Revision 1.71  2006/02/17 14:51:54  djw
C Fix some writes to monitir/listinganisotfs.fpp
C
C Revision 1.70  2006/02/16 18:44:47  djw
C Enable filtering in Tabbed Analyse
C
C Revision 1.69  2006/01/18 17:18:05  djw
C fix a weird (possibly compiler) error in XCOMPL.  The dynamic scratch area 
C causes the program to die if there are more than about 90,000 reflections
C
C Revision 1.68  2005/02/08 10:41:07  rich
C Fix bug in completeness check when list 6 contains reflections with impossibly
C high indices. No longer goes into infinite loop. (reported by A. vd Lee)
C
C Revision 1.67  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:09  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:06  rich
C New CRYSTALS repository
C
C Revision 1.66  2004/11/11 15:58:09  rich
C Output of agreement vs deviation in TWINPLOT.
C
C Revision 1.65  2004/08/09 11:23:12  rich
C Some commented out code for testing List42 Fourier transform.
C
C Revision 1.64  2004/07/08 15:23:28  rich
C Added H-treatment options to the end of L30's CIF block. The default is
C UNKNOWN, and if left unchanged, this will cause the CIF generator to
C actually work out the appropriate keyword. It does this using the REFINE
C flag (Offset 15 in List 5), and can distinguish between NONE (no H present),
C CONSTR (for riding and rigid group refinement), REFALL, REFU, REFXYZ (for
C those types), MIXED (if any H differs from any other), and NOREF (for
C no refinement of any H). Happy Acta'ing.
C
C Revision 1.63  2004/06/28 12:30:35  rich
C Fix bug in labels of reflections on normal probability plot (k&l were swapped).
C
C Revision 1.62  2004/06/18 15:27:56  rich
C Fix completeness calculation so that theta_full is always > 25 provided
C that theta_max is > 25. No account is currently made of radiation type
C or wavelength.
C
C Revision 1.61  2004/06/17 10:29:06  rich
C Swap axes on the normal probability plot so that they are consistent with,
C and labelled like the plots in Abrahams & Keve (Acta A27, 157).
C
C Revision 1.60  2004/06/08 14:15:22  djw
C Output all L30 info in summary
C
C Revision 1.59  2004/05/12 09:56:14  rich
C Store the Wilson scale and B factors in list 30.
C
C Revision 1.58  2004/04/21 13:11:45  rich
C Added "#PUNCH 6 G" command, it outputs a SHELX format reflection
C file, but using slightly perturbed Fcalc^2 and made-up sigma(F-calc^2).
C
C Added a routine ISCNTRC(HKL) to determine if a given reflection is
C in a centrosymmetric class of reflections (e.g. the h0l class in monoclinic-b
C ). Used in plot of phase distribution to exclude this class of reflections.
C Added text to xphase.scp to explain this.
C
C Revision 1.57  2004/04/19 15:43:13  rich
C Added normal probability plot to \SUM L 6 (if LEVEL=NORMPP is specified)
C For each reflection the value of (w)^.5*DELTA is stored in memory along
C with a packed version of the indices. These are sorted using XSHELQ and
C the normal score is calculated.
C
C Revision 1.56  2004/03/10 13:11:35  rich
C Avoid error in summary if too many weighting parameters are given.
C
C Revision 1.55  2004/02/16 16:40:28  rich
C Add a plot of phase distribution to the increasingl inappropriately named
C #SIGMADIST command. Use #SIGM/OUT PHASE=YES/END graph is drawn on
C PLOTWINDOW _VPHASED if it's there.
C
C Revision 1.54  2004/02/16 14:17:05  rich
C Output list of missing reflections to GUI during #THLIM calculation, if
C requested.
C
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
C----- SEE ALSO KSUMLN - FOR THE SAME DATA - SHOULD IT BE IN BLOCK DATA?
      DATA ISMTYP /  1 ,  2 ,  3 ,  4 ,  5 ,     6 ,  0 ,  0 ,  0 , 10 ,
     2               0 , 12 , 13 , 14 ,  0 ,    16 , 17 , 18 ,  0 ,  0 ,
     3               0 ,  0 , 23 ,  0 , 25 ,     0 , 27 , 28 , 29 , 30 ,
     4               0 ,  0 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 , 40 ,
     5              41 , 42 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 ,  0 /
C
      DATA IVERSN / 201 /
C
      DATA ICOMSZ / 3 /
C
#if defined(_PPC_) 
CS***
      CALL SETSTA( 'Summary ' )
      CALL NBACUR
CE***
C
C -- SET THE TIMING AND READ THE CONSTANTS
C
#endif
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
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XLST04.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST09.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST14.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XLST25.INC'
      INCLUDE 'XLST27.INC'
      INCLUDE 'XLST28.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
C -- THE ARRAY 'ISMTYP' INDICATES WHETHER A SUMMARY IS AVAILABLE, AND
C    WHICH STRING FROM 'CLTYPE' SHOULD BE USED TO DESCRIBE THE DATA
C
C      1 - 9 , 10 - 19 , 20 - 29 , 30 - 39 , 40 - 49 , 50
C
C----- SEE ALSO XSMMRY - FOR THE SAME DATA - SHOULD IT BE IN BLOCK DATA?
      DATA ISMTYP /  1 ,  2 ,  3 ,  4 ,  5 ,     6 ,  7 ,  0 ,  9 , 10 ,
     2               0 , 12 , 13 , 14 ,  0 ,    16 , 17 , 18 ,  0 ,  0 ,
     3               0 ,  0 , 23 ,  0 , 25 ,     0 , 27 , 28 , 29 , 30 ,
     4               0 ,  0 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 , 40 ,
     5              41 , 42 ,  0 ,  0 ,  0 ,     0 ,  0 ,  0 ,  0 ,  0 /
C
C
      DATA CLTYPE / 'Cell parameters', 'Symmetry',
     2 'Scattering factors', 'Weighting scheme', 'Parameters',
     3 'Reflection data', 
     * 'List 7', '*','Esd', 'Peaks', '*', 'Refinement directives',
     4 'Diffraction conditions', 'Asymmetric section', '*',
     5 'Restraints', 'Special restraints', 'Smiles', 4*'*',
     6 'S.F. modifications', '*', 'Twin Laws', '*',
     7 'Raw data scale factors',
     8 'Reflection selection conditions', 'Elemental properties',
     9 'General details', 9*'*','Bonding information', 'Bonds',
     1 'Fourier mask' /
C
      DATA LLTYPE /
     2 15,  8, 18, 16, 10,
     3 15,  6,  1,  3,  5, 
     4 1,  21, 22, 18,  1,
     5 10, 18,  6,  1,  1,
     6  1,  1, 18,  1,  9,
     7  1, 22,
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
        ELSE IF ( LSTYPE .EQ. 9 ) THEN
      IF (KHUNTR ( 9,0, IADDL,IADDR,IADDD, -1) .LT. 0) 
     1  CALL XLDR05 ( LSTYPE )
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
         WRITE(CMON,'(A,i6,a)') 
     1   'List', lstype,' summary '
         CALL XPRVDU(NCVDU, 1,0)
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
      ELSE IF ( LSTYPE .EQ. 9 ) THEN
        CALL XSUM05 ( LSTYPE , LEVEL )
      ELSE IF ( LSTYPE .EQ. 10 ) THEN
        CALL XSUM05 ( LSTYPE , LEVEL )
      ELSE IF ( LSTYPE .EQ. 12 ) THEN
        CALL XPRTLX ( LSTYPE , -1, NCPU )
      ELSE IF ( LSTYPE .EQ. 13 ) THEN
        CALL XSUM13
      ELSE IF ( LSTYPE .EQ. 14 ) THEN
        CALL XSUM14
      ELSE IF ( LSTYPE .EQ. 16 ) THEN
        CALL XPRTLX ( LSTYPE , -1, NCPU )
      ELSE IF ( LSTYPE .EQ. 17 ) THEN
        CALL XPRTLX ( LSTYPE , -1, NCPU )
      ELSE IF ( LSTYPE .EQ. 18 ) THEN
        CALL XPRTLX ( LSTYPE , -1, NCPU )
      ELSE IF ( LSTYPE .EQ. 12 ) THEN
        CALL XPRTLX ( LSTYPE , -1, NCPU )
      ELSE IF ( LSTYPE .EQ. 23 ) THEN
        CALL XSUM23
      ELSE IF ( LSTYPE .EQ. 25 ) THEN
        CALL XSUM25
      ELSE IF ( LSTYPE .EQ. 27 ) THEN
        CALL XSUM27
      ELSE IF ( LSTYPE .EQ. 28 ) THEN
CDJWJAN11
        CALL XSUM28(LEVEL)
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST04.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA CFORMS /
     1 'FO/P(1), FO < P(1) or FO = P(1)' ,
     2 'P(1)/FO, FO > P(1)' ,
     3 '1.0 , FO < P(1) or FO = P(1)' ,
     4 'P(1)/FO, FO > P(1)' ,
     5 '1/(1 + [(FO - P(2))/P(1)]^2^)' ,
     6 '1/[P(1) + FO + P(2)*FO^2^ + . . + P(NP)*FO^NP^]' ,
     7 '(Data with the key SQRTW in list 6)' ,
     8 '1/(Data with the key SIGMA(/FO/) in list 6)' ,
     9 '1.0 or 1./4Fsq' ,
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
        WRITE ( ctext(4) , 1035 ) ( STORE(J) , J = L4 , MIN(L4+5,M4) )
      ENDIF
C
      if (imode .ge.1) then
       IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1045 ) STORE(L4F+1)
       WRITE ( CMON , 1045 ) STORE(L4F+1)
       CALL XPRVDU(NCVDU, 1,0)
1045   FORMAT ( 1X , 'The maximum weight is ' , G12.5 )
      endif
C
check for SHELX out of range
      if (imode .GE.1) then
       IF ((ITYPE .EQ. 16) .OR. (ITYPE .EQ. 17)) THEN
       SXB = STORE(L4+1)
C-Acta/PLATON tests
C>> ALERT A for > 50
C>> ALERT B for > 25
C>> ALERT C for > 5

          IF (SXB .GT. 50. ) THEN
            WRITE(CMON,'(A,F8.2,A)') '{E P(2) too large -',
     1       SXB, ' Acta ALERT A'
          ELSE IF (SXB .GT. 25. )THEN
            WRITE(CMON,'(A,F6.2,A)') '{E P(2) too large -',
     1       SXB, ' Acta ALERT B'
          ELSE IF (SXB .GT. 5.) THEN
            WRITE(CMON,'(A,F6.2,A)') '{E P(2) too large -', 
     1       SXB,'  Acta ALERT C'
          ENDIF
          IF(SXB .GT. 5) THEN
            call xprvdu(ncvdu,1,0)
            IF (ISSPRT .EQ. 0) WRITE(NCWU,'(/A/)') cmon(1)(3:)
            WRITE(CMON,'(A)')
     1      'One possible cause is twinning - try ROTAX Analysis'            
            call xprvdu(ncvdu,1,0)
            IF (ISSPRT .EQ. 0) WRITE(NCWU,'(/A/)') cmon(1)
          ENDIF
c
C
       ENDIF
      endif
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      INCLUDE 'ICOM05.INC'
      INCLUDE 'QLST05.INC'
CNOW A PARAMETER      INCLUDE 'IDIM05.INC'
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
c
CODE FOR XTHETA
      FUNCTION XTHETA(I)
      INCLUDE 'XLST13.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST06.INC'
      ST = SQRT ( ABS ( SNTHL2(I) ) ) * STORE(L13DC)
      IF ( ST .GT. 1.0 ) THEN
        XTHETA = 90.0
      ELSE
        XTHETA = ASIN ( ST  ) * RTD
      END IF
      RETURN
      END
C
CODE FOR XSTHL3
      FUNCTION XSTHL3(I)
C return SIN(theta)/lambda all cubed
c      I a dummy
      INCLUDE 'XLST13.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST06.INC'
      ST = SQRT ( ABS ( SNTHL2(I) ) ) 
      IF ( ST .GT. 1.0 ) THEN
        XSTHL3 = 1.
      ELSE
        XSTHL3 = ST*ST*ST
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'ICOM30.INC'
      INCLUDE 'XLST30.INC'
C
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST25.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST30.INC'
        if (kexist(25) .ge. 1)  then
         if (khuntr (25,0, iaddl,iaddr,iaddd, -1) . lt. 0) call xfal25
        else
         n25=0
        endif
c
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
c
CODE FOR XCOMPL
      SUBROUTINE XCOMPL ( ITRSZ, JNH,JNK,JNL, JXH,JXK,JXL,
     1              THMAX,THMCMP, THBEST,THBCMP, IPLOT, IULN, IGLST )
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST25.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
cdjw0106  problems with dynamic arrays if > about 90,000 refls
cric0712  problems with static arrays if about 100001 refls...
      DIMENSION IHKLTR ( 3, ITRSZ + 1 )
c      parameter (itrmax=100001)
c      DIMENSION IHKLTR ( 3, itrmax )
      DIMENSION ALLBIN ( 100 )
      DIMENSION FNDBIN ( 100 )
      DIMENSION ACTBIN ( 100 )

      THBEST = 0.0
      THBCMP = 0.0
c   convert thmax to (sin(th)/lam)^3
      stl3max = sin(dtr*thmax)/store(l13dc)
      stl3max = stl3max*stl3max*stl3max
c
c      if (itrsz+1 .gt. itrmax) then
c        WRITE ( CMON , '(a,2i8)' ) 
c     1 'Too many reflections to compute completeness ',itrsz,itrmax
c        CALL XPRVDU(NCVDU, 2,0)
c        if (issprt .eq. 0) then
c            write(ncwu,'(a)') cmon(1)(:)
c            return
c        endif
c      endif
c
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
            IF ( XTHETA(IH) .LT. THMAX ) THEN
C Check if it is systematically absent.
              IF ( KSYSAB(2) .GE. 0 ) THEN
C Only consider 'allowed' if indices were not changed by KSYSAB:
                IF (     ( NINT(STORE(M6  )) .EQ. IH )
     1              .AND.( NINT(STORE(M6+1)) .EQ. IK )
     2              .AND.( NINT(STORE(M6+2)) .EQ. IL ) ) THEN
                  NALLWD = NALLWD + 1
c--- find bin in (sin(theta)/lambda)^3 (equal volume) intervals
cdjwoct2010                  JID = ( ( XTHETA(NALLWD) / THMAX ) * 100.0 )
                  AJID = xsthl3(NALLWD) 
                  JID = ( ( ajid / stl3max ) * 100.0 )
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
                    IF (ISSPRT .EQ. 0)  
     1              WRITE (NCWU,'(A,F5.2,A/A)')
     2 ' The following reflections ( < ',THMAX, ' theta ) are missing:',
     3 '   H    K    L   Theta '
                    END IF
                    IMISSI = IMISSI + 1
                    IF ( IPLOT.GE.0 ) THEN
                            IF (ISSPRT .EQ. 0) 
     1                      WRITE (NCWU,'(3I5,F8.3)') IH,IK,IL,XTHETA(1)
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
        IF (ISSPRT .EQ. 0) 
     1   WRITE(NCWU,'(/A/2(A,I9)/)') ' Completeness of hkl data.',
     2 ' Reflections expected: ', NALLWD, ' Reflections found: ', NFOUND
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
        IF (ISSPRT .EQ. 0) 
     1   WRITE(NCWU,'(A)') ' Theta  Completeness% Expected  Found '
      ENDIF



      DO I = 1,100
        IF ( ALLBIN(I) .EQ. 0 ) THEN
          COMP = 1.0
        ELSE
          COMP = FNDBIN(I) / ALLBIN(I)
          CMPMIN = MIN (CMPMIN,COMP)
        END IF
cdjwoct2010
          cmpmin = 0.
c
C Compute lowest reasonable value of THBEST - this is 25 degrees unless
C THMAX < 25 degrees, in which case it is 0.75*THMAX.

        THLOW = 25.0
        IF ( THMAX .LT. 25.0 ) THEN
           THLOW = 0.75*THMAX
        END IF
        
        IF ( IPLOT .GE. 0 ) THEN
        IF (ISSPRT .EQ. 0) 
     1   WRITE(NCWU,'(F6.2,F11.2,I11,I9)') THMAX*((I)/100.0),
     2   COMP*100., NINT(ALLBIN(I)), NINT(FNDBIN(I))
        END IF

        IF ( THMAX*(I/100.0) .GE. THLOW ) THEN ! Theta_full shouldn't be too low
         IF ( (COMP .GE. THBCMP) .OR. (COMP .GT. 0.995) ) THEN
          THBEST = THMAX*(I/100.0)                       
          THBCMP = COMP
         END IF
        END IF
      END DO

      IF ( IPLOT .GE. 0 ) THEN
        IF (ISSPRT .EQ. 0) 
     1   WRITE(NCWU,'(/F6.2,F11.2,A)') THBEST, THBCMP,
     2   '< best theta_full'
      END IF
      IF ( IPLOT .EQ. 1 ) THEN
        CMPMIN = 100.0 * MIN(0.99,CMPMIN)
        WRITE(CMON,'(A/A/A,F7.2,A/A/A/A)')
     1  '^^PL PLOTDATA _COMPL SCATTER ATTACH _VCOMPL KEY',
     1  '^^PL XAXIS TITLE (SIN(Theta)/lambda)^3 NSERIES=2 LENGTH=100',
     1  '^^PL YAXIS ZOOM ', CMPMIN,
     1  ' 100.0 TITLE ''Cumulative Completeness''',
     1  '^^PL YAXISRIGHT ZOOM 0 100 TITLE ''Shell Completeness''',
     1 '^^PL SERIES 1 SERIESNAME ''Cumulative Completeness'' TYPE LINE',
     1  '^^PL SERIES 2 SERIESNAME ''Shell Completeness''',
c     1  '^^PL SERIES 3 SERIESNAME ''Theta value'' TYPE LINE',
     1  '^^PL USERIGHTAXIS'
        CALL XPRVDU(NCVDU, 7,0)

        DO I = 1,100
          IF ( ALLBIN(I) .EQ. 0 ) THEN
            COMP = 1.0
          ELSE
            COMP = FNDBIN(I) / ALLBIN(I)
          END IF
c
c          WRITE(CMON,'(A,F10.3,A,4F10.5)')
c     1    '^^PL LABEL ', THMAX*(I/100.0),
c     1    ' DATA ', THMAX*(I/100.0),100.0*COMP,
c     1              THMAX*(I/100.0),100.0*ACTBIN(I)
cdjwoct2010
          point=stl3max*(I/100.0)
          point=rtd*asin(store(l13dc)*point**0.333)
          WRITE(CMON,'(A,F10.3,A,4F10.5)')
     1    '^^PL LABEL ', point,
     1    ' DATA ', stl3max*(I/100.0),100.0*COMP,
     1              stl3max*(I/100.0),100.0*ACTBIN(I)
c     1            , stl3max*(I/100.0),point
          CALL XPRVDU(NCVDU, 1,0)
        END DO
c
        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)

      END IF
c
      RETURN
      END
c
CODE FOR XSUM06
      SUBROUTINE XSUM06 (iuln,  LEVEL )
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 6
C
      CHARACTER *8 CNAME(35)
      CHARACTER *15 HKLLAB

      INCLUDE 'ICOM30.INC'
      DIMENSION KEY(35)
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XLST30.INC'
C
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'TYPE11.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'XSIZES.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QSTR11.INC'
      INCLUDE 'QLST30.INC'
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
CDJW08      DATA MAX11 /16777216/
C
c      DIMENSION X(N6D)
c      DIMENSION Y(N6D)

      DIMENSION TEMP(2)
CDJW08
      MAX11 = ISIZ11
C
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF (KHUNTR (13,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL13
      IF (KHUNTR (23,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL23
      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL30

      IFSQ = ISTORE(L23MN+1)
c set flag for twinned/normal data
C
      IF (ISTORE(L13CD+1) .LE. -1) THEN    ! F = FO
            ITWIN = 3
      ELSE                                 ! F = FOT
            ITWIN = 10
      ENDIF
C--SETUP A GRAPH HERE
      IF ( LEVEL .EQ. 4 ) THEN                 ! Fo vs Fc scatter
        WRITE(CMON,'(A,/,A,/,A)')
     1  '^^PL PLOTDATA _FOFC SCATTER ATTACH _VFOFC',
     1  '^^PL XAXIS TITLE Fc NSERIES=1 LENGTH=2000',
     1  '^^PL YAXIS TITLE Fo SERIES 1 TYPE SCATTER'
        CALL XPRVDU(NCVDU, 3,0)
      END IF
      IF ( LEVEL .EQ. 5 ) THEN                 ! Normal probability plot
        WRITE(CMON,'(A,/,A,/,A)')
     1  '^^PL PLOTDATA _NORMPP SCATTER ATTACH _VNORMPP',
     1  '^^PL XAXIS TITLE ''Expected (Z-score)'' NSERIES=1 LENGTH=2000',
     1  '^^PL YAXIS TITLE ''w(Fo-Fc)'' SERIES 1 TYPE SCATTER'
        IF (IFSQ .GE. 0) THEN   ! FSQ REFINENENT
          WRITE(CMON(3),'(A)')
     1      '^^PL YAXIS TITLE ''w^.5(Fo^2-Fc^2)'' SERIES 1 TYPE SCATTER'
        END IF
        CALL XPRVDU(NCVDU, 3,0)
      END IF
      IF ( LEVEL .EQ. 6 ) THEN                 ! Weight vs Sigma
        WRITE(CMON,'(A,/,A,/,A)')
     1  '^^PL PLOTDATA _WTVSIG SCATTER ATTACH _VWTVSIG',
     1  '^^PL YAXIS TITLE ''SQRT(weight)'' NSERIES=1 LENGTH=2000',
     1  '^^PL XAXIS TITLE ''1/Sigma'' SERIES 1 TYPE SCATTER'
        CALL XPRVDU(NCVDU, 3,0)
      END IF
C
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
      IFTYPE = ISTORE(L23MN+1)+2
      SCALE = STORE(L5O)
      FSCALE = 1./(SCALE*SCALE)
      TOP = 0.0
      BOTTOM = 0.0
      WTOP = 0.0
      WBOT = 0.0
      SIGTOP = 0.0
      N6ACC = 0
      PLOTMAX = 0
c----- totals for slope and intercept
        ss = 0.
        sx = 0.
        sy = 0.
        sxx = 0.
        syy = 0.
        sxy = 0.

1100  CONTINUE
        ISTAT = KFNR ( 0 )
        IF ( ISTAT .LT. 0 ) GO TO 1200

        N6ACC = N6ACC + 1
cjun2010  FO = STORE(M6+itwin)
        FO = STORE(M6+3)
        FC = SCALE * STORE(M6+5)

        IF ( LEVEL .EQ. 4 ) THEN
          PLOTMAX = MAX( PLOTMAX, FC )
          WRITE(HKLLAB, '(2(I4,A),I4)') NINT(STORE(M6)),',',
     1    NINT(STORE(M6+1)), ',', NINT(STORE(M6+2))
          CALL XCRAS(HKLLAB, IHKLLEN)
          WRITE(CMON,'(3A,2(1X,F12.2))')
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

        IF ( LEVEL .EQ. 5 ) THEN
C If you have more than 8.8 million reflections you might be in trouble.
         IF ( N6ACC .LE. MAX11/2 ) THEN
          STR11(N6ACC*2-1) = WDEL     !Format:   [WDEL,INDICES]
          STR11(N6ACC*2) = STORE(M6)+STORE(M6+1)*256.+STORE(M6+2)*65536.
         END IF
        END IF

        IF ( LEVEL .EQ. 6 ) THEN
C-PLOT WEIGHT VS 1/SIGMA
          FSIGN = STORE(M6+3)
          SIG = STORE(M6+12)
          WT = STORE(M6+4)
C----- RETURN THE SIGNED STRUCTURE AMPLITUDE AND THE CORRESPONDING SIGMA
C      FROM A SIGNED STRUCTURE FACTOR
          CALL XSQRF (FSQ,FSIGN,FABS,SIGFSQ,SIG)
          if (iftype .eq.1) then
c         refinement on F
                   sigest = sig
          else
                   sigest = sigfsq
          endif
          if (sigest .le. zero) then
            sig1 = zero
          else
            sig1 = 1/sigest
          endif 
          PLOTMAX = MAX(PLOTMAX,WT)
          WRITE(HKLLAB, '(2(I4,A),I4)') NINT(STORE(M6)),',',
     1    NINT(STORE(M6+1)), ',', NINT(STORE(M6+2))
          CALL XCRAS(HKLLAB, IHKLLEN)
          WRITE(CMON,'(3A,2F12.5)')
     1   '^^PL LABEL ''', HKLLAB(1:IHKLLEN), ''' DATA ', 
     2    sig1, wt
          CALL XPRVDU(NCVDU, 1,0)
        END IF



      GO TO 1100
1200  CONTINUE

      IF ( LEVEL .EQ. 4 ) THEN      !Also output the omitted refls.

        WRITE(CMON,'(A)')
     1  '^^PL ADDSERIES Omitted TYPE SCATTER'
        CALL XPRVDU(NCVDU,1,0)

        CALL XFAL06 (IULN, 0 )
        DO WHILE ( KLDRNR ( 0 ) .GE. 0 )
          IF (KALLOW(IALLOW).LT.0) THEN
cjun2010            FO = STORE(M6+itwin)
            FO = STORE(M6+3)
            FC = SCALE * STORE(M6+5)
            WRITE(HKLLAB, '(2(I4,A),I4)') NINT(STORE(M6)),',',
     1      NINT(STORE(M6+1)), ',', NINT(STORE(M6+2))
            CALL XCRAS(HKLLAB, IHKLLEN)
            WRITE(CMON,'(3A,2(1X,F12.2))')
     1     '^^PL LABEL ''', HKLLAB(1:IHKLLEN), ''' DATA ', FC ,FO
c            WRITE(CMON,'(A,2(1X,F12.2))')
c     1     '^^PL DATA ', FC ,FO
            CALL XPRVDU(NCVDU, 1,0)
          ENDIF
        END DO
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
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1215 ) IULN, N6D , N6ACC
      WRITE ( CMON , 1215 ) IULN, N6D, N6ACC
      CALL XPRVDU(NCVDU, 1,0)
1215  FORMAT ( 1X , 'List 'I3,' contains ' , I6 , ' reflections' ,
     1 ' of which ' , I6 , ' are accepted by LIST 28')
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


      IF ( LEVEL .EQ. 5 ) THEN

        IF ( N6ACC .GT. MAX11/2 ) THEN
          WRITE(CMON,'(A,I8)') '{E Too many reflections: ', N6ACC
          CALL XPRVDU(NCVDU,1,0)
          N6ACC = MAX11/2
        END IF
        WRITE(CMON,'(A,I8,A)')' Computing normal probability plot for',
     1    N6ACC, ' reflections.'
        CALL XPRVDU(NCVDU,1,0)
C Sort the sqrt(W)*(Fo2-Fc2) into ascending order.
        CALL XSHELQ(STR11,2,1,N6ACC,N6ACC*2,TEMP)

        DO I=1,N6ACC
           PC = (I-0.5)/float(N6ACC)
           A = sqrt(-2.*log(.5-abs(PC-.5)))
           B = 0.27061*A+2.30753
           C = A*(A*.04481+.99229)+1
           Z = A-B/C
C Unpack HKL
           D=FLOAT(NINT(STR11(I*2)/256.))
           MH=STR11(I*2)-D*256.
           ML=FLOAT(NINT(D/256.))
           MK=D-ML*256.

           if (I.LE.N6ACC/2) Z=-Z
c debug          WRITE(CMON,'(I5,2F15.2)') I,STR11(I*2-1),Z
c debug          CALL XPRVDU(NCVDU,1,0)
c
           ss =  ss  + 1.
           sx =  sx  + z
           sy =  sy  + str11(i*2-1)
           sxx = sxx + z*z
           syy = syy + str11(i*2-1)*str11(i*2-1)
           sxy = sxy + str11(i*2-1)*z
c
           PLOTMAX = MAX( PLOTMAX, Z )
           WRITE(HKLLAB, '(2(I4,A),I4)') MH, ',', MK, ',', ML
           CALL XCRAS(HKLLAB, IHKLLEN)
           WRITE(CMON,'(3A,2F11.3)')
     1     '^^PL LABEL ''',HKLLAB(1:IHKLLEN),''' DATA ',Z,STR11(I*2-1)
            CALL XPRVDU(NCVDU, 1,0)
        END DO

      END IF

      IF (( LEVEL .EQ. 4) .OR. (LEVEL .EQ. 6)) THEN
c  add A SERIES FOR STRAIGHT LINE (y=x) for extinction spotting.
        WRITE(CMON,'(A/A,2F10.2)')
     1  '^^PL ADDSERIES ''Fo=Fc'' TYPE LINE',
     2  '^^PL DATA 0 0 DATA ', PLOTMAX, PLOTMAX
        CALL XPRVDU(NCVDU,2,0)
      ELSE
        WRITE(CMON,'(A/2(A,2F10.2))')
     1  '^^PL ADDSERIES ''Fo=Fc'' TYPE LINE',
     2  '^^PL DATA ', -PLOTMAX, -PLOTMAX,' DATA ', PLOTMAX, PLOTMAX
        CALL XPRVDU(NCVDU,2,0)
      ENDIF
c
C -- FINISH THE GRAPH DEFINITION
      IF ( ( LEVEL .EQ. 4 ).OR.( LEVEL .EQ. 5 )
     1 .OR.( LEVEL .EQ. 6 )) THEN
        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      ENDIF
C
      if (level .eq. 5) then
c      find slope and intercept
c      determinant
        deter = ss*sxx-sx*sx
        if (deter .ne. 0.) then
          cutter = (sxx*sy-sx*sxy)/deter
          slope = (ss*sxy-sx*sy)/deter
          yslope = slope
          denom = (ss*sxx-sx*sx)*(ss*syy-sy*sy)
          if (denom .gt. 0.) then
            denom=sqrt(denom)
            correl = (ss*sxy - sx*sy)/denom
            write(cmon,470) slope, cutter, correl
470      format(' Slope, intercept and Cc of Normal Probability Plot =',
     1  f7.3,f10.2,f10.5)
            call xprvdu(ncvdu, 1,0)
            if (issprt.eq.0) write (ncwu,'(/a)') cmon(1)(:)

            if ( (slope .gt. 1.1) .or. (slope .lt. 0.9) .or.
     1        (cutter .lt. -.05) .or. (cutter .gt. .05)) then
              write(cmon,'(a,a)')' The slope shoud be unity and the'
     1        ,' intercept zero'
              call xprvdu(ncvdu, 1,0)
              if (issprt.eq.0) write (ncwu,'(/a)') cmon(1)(:)
                write(cmon,'(a)') 
     1 '{E CRYSTALS suggests that you check your weighting scheme'
                call xprvdu(ncvdu, 1,0)
                if (issprt.eq.0) write (ncwu,'(/a)') cmon(1)(:)
            endif
          else
            write(cmon,471) 
471         format ('Correlation coefficient cannot be computed')
            call xprvdu(ncvdu, 1,0)
            if (issprt.eq.0) write (ncwu,'(/a)') cmon(1)(:)
            write(cmon,460) slope, cutter
460        format(' Slope and intercept of Normal Probability Plot =',
     1  2f10.5)
            call xprvdu(ncvdu, 1,0)
            if (issprt.eq.0) write (ncwu,'(/a)') cmon(1)(:)
            if ( (slope .gt. 1.1) .or. (slope .lt. 0.9) .or.
     1      (cutter .lt. -.05) .or. (cutter .gt. .05)) then
              WRITE(CMON,'(A)') 
     1 '{E CRYSTALS suggests that you check your weighting scheme'
             call xprvdu(ncvdu, 1,0)
             if (issprt.eq.0) write (ncwu,'(/a)') cmon(1)(:)
               endif
            endif
        else
            write(cmon,472) 
472         format ('Slope and Intercept cannot be computed')
            call xprvdu(ncvdu, 1,0)
            if (issprt.eq.0) write (ncwu,'(/a)') cmon(1)(:)
        endif
      endif
c
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA CCRYST / 'Friedel''s Law is ' ,
     2 'Twin Laws are ' /
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
          WRITE ( CMON , 1025 ) CCRYST(I), 'used'
        else
          WRITE ( CMON , 1025 ) CCRYST(I), 'not used'
        ENDIF
        call xcrems(cmon(1), cmon(1), len)
          CALL XPRVDU(NCVDU, 1,0)
1025      FORMAT ( 1X , A, A )
          IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(A)' ) cmon(1)
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST14.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
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
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST25.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST27.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
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
      SUBROUTINE XSUM28(LEVEL)
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 28
CDJWJAN11
C    LEVEL HIGH (3) CAUSES OUTPUT TO NCPU
C
      LOGICAL LHEADR
      character *28 comit
      DIMENSION KDEV(4)
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST28.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'TSSCHR.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      data comit/'_oxford_refln_omitted_index_'/
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
cdjwjan11  - output to PUNCH in CIF format
       if (level .eq. 3) then
C -       PREAPRE TO APPEND CIF OUTPUT ON FRN1
          CALL XMOVEI(KEYFIL(1,23), KDEV, 4)
          CALL XRDOPN(8, KDEV , CSSCIF, LSSCIF)
            write(ncfpu1,'(/a)')'# Manually omitted reflections'
            write(ncfpu1,'(/a)')'loop_'
            write(ncfpu1,'(a,a)')comit,'h'
            write(ncfpu1,'(a,a)')comit,'k'
            write(ncfpu1,'(a,a)')comit,'l'
            write(ncfpu1,'(a,a)')comit(1:22),'flag'
            write(ncfpu1,'(a,a)')comit(1:22),'details'
       endif
       WRITE(CMON,'(''Omitted Reflections'')')
       CALL XPRVDU(NCVDU, 1,0)
       M28OM = L28OM + (N28OM-1)*MD28OM
       J = 1
       INC = 14
       DO 2000 I = L28OM , M28OM , MD28OM
cdjwjan11
          if (level .eq. 3) write(ncfpu1,'(3i4,a)') 
     1       (NINT(STORE(K)),K=I,I+MD28OM-1), '  x   .'
cdjwjan11
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
C
       if (level .eq. 3) then
c-          close cif chanel
           CALL XRDOPN(7, KDEV , CSSCIF, LSSCIF)
       endif
c
      ENDIF
C
      ELSE
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 2005 )
        WRITE ( CMON , 2005 )
        CALL XPRVDU(NCVDU, 1,0)
2005    FORMAT ( 1X , 'Reflections are not subject to restrictions' )
      ENDIF
C
      RETURN
      END
C
CODE FOR XSUM29
      SUBROUTINE XSUM29
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 29
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      IF ( N29 .GT. 0 ) THEN
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1015 )
        WRITE ( CMON , 1015 )
        CALL XPRVDU(NCVDU, 2,0)
1015    FORMAT ( ' Type              Radius              ' ,
     2 '   Number     Mu    Atomic Colour' /
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
     2 F9.3 , F8.2 ,  F9.3,2X,A4 )
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
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (L30DR, IPOINT(1))
C
C
      DATA CTYPE /
     1 'OBSERVATIONS', 'CONDITIONS', 'REFINEMENT', 'INDICES',
     2 'ABSORPTION', 'GENERAL', 'COLOUR', 'SHAPE', 'CIF'/
C
      DATA (CKEY(I,1),I=1,MAXKEY)/
     1 'Total measured', '*',
     2  'No. Friedel separate', 'Rint Friedel separate',
     3  'No. Friedel merged',   'Rint Friedel merged',
     4  'Wilson B factor', 'Wilson scale factor',
     5  11*'*'
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
     2 'Del rho min','Del rho max','max shift','Reflections used',
     3 'Fo min function', 'Restraint min func', 'RMS shift',
     4  7*'*'
     * /
      DATA (CKEY(I,4),I=1,MAXKEY)/
     1 'Hmin', 'Hmax', 'Kmin', 'Kmax', 'Lmin', 'Lmax', 'Theta min',
     2 'Theta max', 11*'*'
     * /
      DATA (CKEY(I,5),I=1,MAXKEY)/
     1 'Analmin', 'Analmax', 'Thetamin', 'Thetamax',
     2 'empirical min', 'Empirical max', 'refdelf min',
     3 'refdelf max', 11*'*'
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
        ELSE IF ( J .EQ. 9 ) THEN
C----- PARAMETER 19 ON DIRECTIVE 9 IS A CHARACTER STRING
C H TREATMENT
          IPARAM  = 19
          IDIR = 9
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
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCONST.INC'
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

      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'XSSVAL.INC'
C
C
C--OUTPUT DEFAULTS CARD:
       WRITE(CMON,21)NINT(STORE(L40T)),STORE(L40T+1),
     1 NINT(STORE(L40T+2)), NINT(STORE(L40T+3)),STORE(L40T+4)
21     FORMAT(/,' Tolerance function=',I2,' (0=sum+tol,1=sum*tol)',/,
     2        ' Tolerance=',F6.3,/,
     3        ' Maximum no. of bonds to an atom =',I4,/,
     4        ' No symmetry calculation = ',I4,' (0=symm,1=nosymm)',/,
     5        ' Significant atom movement =',F10.5,' Angstroms',//)
       CALL XPRVDU(NCVDU,7,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,21)NINT(STORE(L40T)),STORE(L40T+1)
     1 ,NINT(STORE(L40T+2)), NINT(STORE(L40T+3)),STORE(L40T+4)
C     
C--OUTPUT ANY ELEMENT CARDS
      IF ( N40E .GT. 0 ) THEN 
32    FORMAT (A//A/)
        WRITE(CMON,32)
     1  'Over-ride List 29 covalent radii and maximum no. of bonds:',
     2  '  Element  Covalent Radius  Maximum Bonds'
        CALL XPRVDU(NCVDU,4,0)
       IF (ISSPRT .EQ. 0) WRITE(NCWU,32)
     1  'Over-ride List 29 covalent radii and maximum no. of bonds:',
     2  '  Element  Covalent Radius  Maximum Bonds'
C
        DO I = L40E,L40E+(MD40E*(N40E-1)),MD40E
          WRITE(CMON,22) ISTORE(I), STORE(I+1), NINT(STORE(I+2))
22        FORMAT(4X,A4,6X,F8.4,10X,I4)
          CALL XPRVDU(NCVDU,1,0)
          IF (ISSPRT .EQ. 0)
     1    WRITE(NCWU,22) ISTORE(I), STORE(I+1), NINT(STORE(I+2))
        END DO
      ELSE
33    FORMAT (A//A)
        WRITE(CMON,33)
     1  'Over-ride List 29 covalent radii and maximum no. of bonds:',
     2  '  There are no element directives.'
        CALL XPRVDU(NCVDU,3,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,33)
     1  'Over-ride List 29 covalent radii and maximum no. of bonds:',
     2  '  There are no element directives.'
      ENDIF
C
C--OUTPUT ANY PAIR CARDS
34    FORMAT(/A//)
      WRITE(CMON,34)
     1  'Over-ride covalent radii for a pair of elements:'
      CALL XPRVDU(NCVDU,3,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,34)
     1  'Over-ride covalent radii for a pair of elements:'
      IF (N40P .GT. 0) THEN
35    FORMAT (A/)
        WRITE(CMON,35)
     1    '  Element  Element  Min-Dist  Max-Dist  Bond Type'
        CALL XPRVDU(NCVDU,2,0)
      IF (ISSPRT .EQ. 0)WRITE(NCWU,35)
     1    '  Element  Element  Min-Dist  Max-Dist  Bond Type'
C
        DO I = L40P,L40P+(MD40P*(N40P-1)),MD40P
          WRITE(CMON,23) ISTORE(I), ISTORE(I+1),STORE(I+2),
     1    STORE(I+3), NINT(STORE(I+4))
23        FORMAT(4X,A4,5X,A4,4X,F6.3,4X,F6.3,5X,I4)
          CALL XPRVDU(NCVDU,1,0)
          IF (ISSPRT .EQ. 0) 
     1    WRITE(NCWU,23) ISTORE(I), ISTORE(I+1),STORE(I+2),
     2    STORE(I+3), NINT(STORE(I+4))
         END DO
       ELSE
        WRITE(CMON,'(A)')'  There are no pair directives.'
        CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)')
     1 '  There are no pair directives.'
       END IF
24      FORMAT (2A, ' to ', A, I4)
25      FORMAT (2A, ' to ', A)

      WRITE(CMON,'(//A/)') 'Additional bonds to make:'
      CALL XPRVDU(NCVDU,3,0)
      IF (ISSPRT .EQ. 0)WRITE(NCWU,'(//A/)') 
     1 'Additional bonds to make:'
C
      IF (N40M.GT.0)THEN
        WRITE(CMON,'(A/)')
     1 '                    Bond                             Type'
        CALL XPRVDU(NCVDU,2,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A/)')
     1 '                    Bond                             Type'
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
      IF (ISSPRT .EQ. 0)WRITE (NCWU,24) CBLANK(1: 21-LATOM1),
     2                  CATOM1(1:LATOM1), CATOM2,ISTORE(I+14)
        END DO
      ELSE
        WRITE(CMON,'(A)')'  There are no make directives.'
        CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0)WRITE(NCWU,'(A)')
     1 '  There are no make directives.'
      ENDIF
C
      WRITE(CMON,'(//A/)') 'Bonds to break:'
      CALL XPRVDU(NCVDU,3,0)
      IF (ISSPRT .EQ. 0)WRITE(NCWU,'(//A/)') 'Bonds to break:'
      IF (N40B.GT.0)THEN
        WRITE(CMON,'(A/)')
     1 '                    Bond'
        CALL XPRVDU(NCVDU,2,0)
      IF (ISSPRT .EQ. 0)WRITE(NCWU,'(A/)')
     1 '                    Bond'
C
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
      IF (ISSPRT .EQ. 0)WRITE (NCWU,25)CBLANK(1: 21-LATOM1),
     2                   CATOM1(1:LATOM1), CATOM2(1:LATOM2)
        END DO
      ELSE
        WRITE(CMON,'(A)')'  There are no break directives.'
        CALL XPRVDU(NCVDU,1,0)
        IF (ISSPRT .EQ. 0)WRITE(NCWU,'(A)')
     1  '  There are no break directives.'
      ENDIF
      RETURN
      END
C
C
CODE FOR XSUM41
      SUBROUTINE XSUM41
C
C -- ROUTINE TO DISPLAY SUMMARY OF LIST 41
C

      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XSSVAL.INC'
C
      CHARACTER * 32 CATOM1, CATOM2, CBLANK
      DATA CBLANK /' '/
C
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
100   FORMAT (/,A,//A//,2X,I6,6X,I9,5X,I5,9X,I6//)
C
      WRITE(CMON,100)
     1 'Dependencies:',
     1 ' List5 size   List5 CRC  List5 serial  List40 serial',
     2 (ISTORE(L41D+J),J=0,3)
      CALL XPRVDU(NCVDU,9,0)
      IF (ISSPRT .EQ. 0)      WRITE(NCWU,100)
     1 'Dependencies:',
     1 ' List5 size   List5 CRC  List5 serial  List40 serial',
     2 (ISTORE(L41D+J),J=0,3)
C
C To do - check dependencies at this point
110   FORMAT (A,//,A,35x,A/)
      WRITE(CMON,110)'Bonds:',
     1 '                    Bond','Type   Length'
C
      CALL XPRVDU(NCVDU,4,0)
      IF (ISSPRT .EQ. 0)      WRITE(NCWU,110)'Bonds:',
     1 '                    Bond','Type   Length'
C
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
      IF (ISSPRT .EQ. 0) WRITE (NCWU,24) CBLANK(1: 21-LATOM1),
     2                  CATOM1(1:LATOM1), CATOM2,ISTORE(M41B+12),
     3                  STORE(M41B+13)
      END DO
C
      RETURN
      END
C
C
CODE FOR XSGDST
      SUBROUTINE XSGDST
c----- produce data for tabbed analysis display
      DIMENSION KSIGS(110)
      DIMENSION LSIGS(25,3)
      DIMENSION MSIGS(120)
      dimension sios(25),nios(25)
      CHARACTER *15 HKLLAB
      PARAMETER ( RTDIV = 19.09859 ) ! Radians to divisions.
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'ICOM30.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST30.INC'
      DATA ICOMSZ / 5 /
      DATA IVERSN /101/

C -- SET THE TIMING AND READ THE CONSTANTS

      CALL XTIME1 ( 2 )
      CALL XCSAE

      call xzerof (sios, 25)
      call xzerof (nios, 25)

C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
      ICOMBF = KSTALL( ICOMSZ )
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910

      IPLOT1 = ISTORE(ICOMBF)
      IPLOT2 = ISTORE(ICOMBF+1)
      ITYP06 = ISTORE(ICOMBF+2)
      IPLOT3 = ISTORE(ICOMBF+3)
      ISKP28 = ISTORE(ICOMBF+4)


      IULN = KTYP06(ITYP06)
      CALL XFAL06 (IULN, 0)
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 2,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL02

      DO I = 1,110
        KSIGS(I) = 0
      END DO
      DO I = 1,120
        MSIGS(I) = 0
      END DO
      DO I = 1,3
        DO J = 1,25
          LSIGS(J,I) = 0
        END DO
      END DO

C -- SCAN LIST 6 FOR REFLECTIONS

      NTOT = 0
      NALLOW = 0
c      nmax=0



      DO WHILE ( KLDRNR(0) .GE. 0 )
        IF ( KALLOW(IALLOW).EQ. 0 ) THEN
          NALLOW = NALLOW + 1
          IF ( ISCNTRC ( STORE(M6) ) .EQ. 0 ) THEN
           JSIGS = MIN( 120, MAX( 1, NINT(60 + RTDIV * STORE(M6+6)) ) )
           MSIGS(JSIGS) = MSIGS(JSIGS) + 1
          END IF
        END IF
        IF ((KALLOW(IALLOW) .EQ. 0 ).or.(iskp28 .eq.0)) THEN
         NTOT = NTOT + 1
         CALL XSQRF(FOS, STORE(M6+3), FABS, SIGMA, STORE(M6+12))
         JSIGS = 10 + NINT( (2.*FOS)/SIGMA )
         JSIGS = MAX(JSIGS,1)
         IF ( JSIGS .LE. 110 ) KSIGS(JSIGS) = KSIGS(JSIGS) + 1
 
 
         SIGNOI = FOS/SIGMA
         JSIGS = 3
         IF ( SIGNOI .LT. 10 ) JSIGS = 2
         IF ( SIGNOI .LT. 3 ) JSIGS = 1
 
         MSIG = 1 + NINT( STORE(M6+16) * 25.0 / 0.5 )
         MSIG = MAX ( 1,MSIG )
         MSIG = MIN ( 25,MSIG )
         LSIGS(MSIG,JSIGS) = LSIGS(MSIG,JSIGS) + 1
c         nmax=max(nmax,LSIGS(MSIG,JSIGS))
         sios(msig)=sios(msig)+signoi
         nios(msig)=nios(msig)+1
        endif

      END DO

      if (issprt .eq. 0) write(ncwu,'(a)')'I/sig(i) vs resolution'
      mios=0
      smax=0.
      slim=5.
      call outcol(6)
      do i=1,25
            mios=mios+nios(I)
            if(nios(i) .gt. 0) sios(i)=sios(i)/float(nios(i))
            if((sios(I) .lt. slim).and.(sios(i).gt. 0.)) then
            write(cmon,'(A,f4.1,a,f6.2)')
     1      '<I/sigma(I)> falls below', slim,
     2      ' at (sintheta/lambda)^2=',(float(i)*.4/25.0)
            CALL XPRVDU(NCVDU, 1,0)
            slim=slim-1.
            endif
            smax=max(smax,sios(I))
            if (issprt .eq. 0) then
            write(ncwu,'(f5.2,2i8,f10.3)') 
     1      (float(i)*.4/25.),nios(I),mios,sios(I)
            endif
      enddo
      call outcol(1)

c      nmax=10*nint(float(nmax)/(10.*smax))
c      nmax=min(90,nmax)
c      nmax=max(1,nmax)
      IF (IPLOT2 .EQ. 1) THEN
c        WRITE(CMON,'(A,10(/A))')
        WRITE(CMON,'(A,3(/A),/a,i6,a,5(/a))')
     1  '^^PL PLOTDATA _SIGRES SCATTER ATTACH _VSIGRES KEY',
     2  '^^PL XAXIS TITLE ''(sin(theta)/lambda)**2'' NSERIES=4',
     3  '^^PL LENGTH=25',
     4  '^^PL YAXIS TITLE ''Frequency''',
     5  '^^PL YAXISRIGHT ZOOM 0 ',nint(smax),
     5  ' TITLE ''Average(I/sigmaI)''',
     6  '^^PL SERIES 1 SERIESNAME ''I/sigma(I)<3.0'' TYPE LINE ',
     7  '^^PL SERIES 2 SERIESNAME ''I/sigma(I)<10.0'' TYPE LINE ',
     8  '^^PL SERIES 3 SERIESNAME ''I/sigma(I)>10.0'' TYPE LINE ',
     9  '^^PL SERIES 4 SERIESNAME ''<I/sigma>'' TYPE LINE ',
     1  '^^PL USERIGHTAXIS'

        CALL XPRVDU(NCVDU, 10,0)

        DO I = 1,25
          WRITE(CMON,'(A,4(F7.3,1X,I8,1X))')
     1     '^^PL DATA ',((I*0.4/25.0),LSIGS(I,J),J=1,3),
     2     (I*0.4/25.0),nint(sios(I))
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

        IF (ISSPRT .EQ. 0) write(ncwu,'(a)')'I/sig(i) distribution'
        DO I = 1, 110
          WRITE(CMON,'(A,1X,F5.1,1X,A,1X,I6,1X,I8)')
     1    '^^PL LABEL',(I-11)*.5,'DATA',KSIGS(I),NTOT
          CALL XPRVDU(NCVDU,1,0)
          IF (ISSPRT .EQ. 0) write(ncwu,'(f5.1, i8, i8)')
     1    (I-11)*.5, KSIGS(I), NTOT
          NTOT = NTOT - KSIGS(I)
        END DO

        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)

      END IF

      IF (IPLOT3 .EQ. 1) THEN
        WRITE(CMON,'(A,2(/A))')
     1  '^^PL PLOTDATA _PHASED BARGRAPH ATTACH _VPHASED',
     1  '^^PL XAXIS TITLE ''Phase'' NSERIES=1 LENGTH=100',
     1  '^^PL YAXIS TITLE ''Number of observations'''
        CALL XPRVDU(NCVDU, 3,0)

        DO I = 1, 120
          WRITE(CMON,'(A,1X,I4,1X,A,1X,I6)')
     1    '^^PL LABEL',(I-60)*3,'DATA',MSIGS(I)
          CALL XPRVDU(NCVDU,1,0)
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
      CHARACTER *15 HKLLAB
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'ICOM30.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST30.INC'
      DATA ICOMSZ / 12 /
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
      IAGREE = ISTORE(ICOMBF+10)
      ITYP06 = ISTORE(ICOMBF+11)
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
      CALL DVPROD(BAD,TEMP,DMX)
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


      IF (IAGREE .EQ. 1) THEN
        WRITE(CMON,'(A,2(/A))')
     1  '^^PL PLOTDATA _XTWAG SCATTER ATTACH _TWAG',
     1  '^^PL XAXIS TITLE ''Deviation in A^-1'' NSERIES=1 LENGTH=25',
     1  '^^PL YAXIS TITLE ''Fo-Fc'''
        CALL XPRVDU(NCVDU, 4,0)
        SCALE = STORE(L5O)
      END IF

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
           CALL DVPROD(BAD,TEMP,D)
           IF ( D .GT. ZEROSQ ) D = SQRT(D)
           IF ( D .LT. DMIN ) DMIN = D

          END DO

         END DO

        END DO

        IF (IAGREE .EQ. 1) THEN
          FO = STORE(M6+3)
          FC = STORE(M6+5)*SCALE
          WRITE(HKLLAB, '(2(I4,A),I4)') NINT(STORE(M6)),',',
     1       NINT(STORE(M6+1)), ',', NINT(STORE(M6+2))
          CALL XCRAS(HKLLAB, IHKLLEN)
          WRITE(CMON,'(A,A,A,1X,F9.5,1X,F9.5)')
     1       '^^PL LABEL ''',HKLLAB(1:IHKLLEN),''' DATA',DMIN,
     2        FO-FC
          CALL XPRVDU(NCVDU,1,0)
        END IF

        JSIGS = 1 + ( 25. * DMIN / DMX )
        JSIGS = MAX(JSIGS,1)
        JSIGS = MIN(JSIGS,25)
        KSIGS(JSIGS) = KSIGS(JSIGS) + 1

        ISTAT = KLDRNR(0)
      END DO


      IF (IAGREE .EQ. 1) THEN

        WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      END IF


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
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'ICOM30.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST30.INC'
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
        CALL DVPROD(GM,GM,D)
        IF ( D .LT. ZERO ) THEN
C Work out which bin.
          RFO = STORE(M6+3) / STORE(M6+12)
          JSIGS = 6 + ( 45. * RFO / RFOMAX )
          JSIGS = MAX(JSIGS,1)
          JSIGS = MIN(JSIGS,50)
C Work out whether inc or exc.
          CALL DVPROD(STORE(ICOMBF+11),STORE(M6),D)

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

      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XLST42.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
c      REAL HKL(3)

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

C Test Fourier transform of L42.
c      CALL XFAL02
c      HKL(1)=0.0
c      HKL(2)=0.0
c      HKL(3)=0.0
c      CALL XMASKF(FA,FB,HKL)
c      WRITE(CMON(1),'(3F4.1,2F9.5)') HKL(1),HKL(2),HKL(3),FA,FB
c      CALL XPRVDU(NCVDU,1,0)
c      HKL(1)=1.0
c      HKL(2)=1.0
c      HKL(3)=1.0
c      CALL XMASKF(FA,FB,HKL)
c      WRITE(CMON(1),'(3F4.1,2F9.5)') HKL(1),HKL(2),HKL(3),FA,FB
c      CALL XPRVDU(NCVDU,1,0)
c      HKL(1)=5.0
c      HKL(2)=2.0
c      HKL(3)=-1.0
c      CALL XMASKF(FA,FB,HKL)
c      WRITE(CMON(1),'(3F4.1,2F9.5)') HKL(1),HKL(2),HKL(3),FA,FB
c      CALL XPRVDU(NCVDU,1,0)

      RETURN
      END


CODE FOR ISCNTRC
      FUNCTION ISCNTRC ( HKL )
      DIMENSION HKL(3), SHKL(3)
      INCLUDE 'XLST02.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      IF ( IC .EQ. 1 ) THEN ! Centre of symmetry, all reflections affected.
        ISCNTRC = 1
        RETURN
      END IF
C Loop over each symmetry operator (we can ignore lattice centerings).
      ISCNTRC = 0
      DO 100 I=0,N2-1
          CALL XMLTTM(STORE(L2+I*MD2),HKL(1),SHKL(1),3,3,1)
          DO J = 1,3
              IF ( NINT(SHKL(J)) .NE. - NINT(HKL(J)) ) GOTO 100
          END DO
          ISCNTRC = 1
          RETURN
100   CONTINUE
      RETURN
      END

