!$Rev::                                      $:  Revision of last commit
!$Author::                                   $:  Author of last commit
!$Date::                                     $:  Date of last commit
! Revision 1.96  2013/11/26 11:49:02  pascal
! removed not used arguments from srtdwn
!
! Revision 1.95  2013/11/06 12:06:34  pascal
! catch singularity during inversion and returning an error
!
! Revision 1.94  2013/11/05 15:37:35  pascal
! replace single precision AA^t accumulation with double precision
!
! Revision 1.93  2013/10/15 11:49:17  pascal
! better determination of the number of threads, slightly optimisation of a loop
!
! Revision 1.91  2013/10/11 16:21:58  pascal
! openmp threads for the accumulation using serial blas functions
!
! Revision 1.90  2013/10/10 13:07:58  pascal
! exp, sin and cos replaced by fast purec functions
!
! Revision 1.87  2013/10/07 13:53:27  pascal
! Fixed copyin/copyout resulting in a too big stack allocatation
!
! Revision 1.86  2013/09/24 08:52:29  rich
! Change test for unaccumulated matrix elements
! Change syntax of #if - possible intel parse error.
!
! Revision 1.85  2013/09/24 08:38:58  rich
! The digital compiler can't handle big F90 allocation of memory (gives a stack overflow). Reduced size of SFLS accumulation buffer for this platform.
!
! Revision 1.84  2013/09/22 21:43:39  rich
! Improved accumulation.
!
! Revision 1.83  2013/09/19 21:35:39  rich
! Change precision of listing output where not important to reduce differences across platforms.
! Important changes - SFLS now uses builtin cos() and sin() functions rather than Chebyshev
! approximations.
!
! Revision 1.82  2013/05/10 14:07:52  djw
! Remove code sorting and saving enentiomer sensitive reflections.  This is now all handled in the Analyse Absolute
! structure script.  Although computation is not changed, there are tiny effects in the nth decimal place
!
! Revision 1.81  2012/08/24 16:19:32  djw
! Lowest value of Umin was incorrectly initialised. No effect on test decks
!
! Revision 1.80  2012/03/20 10:28:25  rich
! Update L30 with L28 ratio value during SFLS.
!
! Revision 1.79  2012/01/05 13:59:18  djw
! Provide more sig fig for different scalefactors
!
! Revision 1.78  2012/01/04 14:31:25  rich
! Fix some uninitialized variables, and output format mistakes.
!
! Revision 1.77  2011/11/03 09:20:16  rich
! Output of leverage stats.
!
! Revision 1.76  2011/09/05 08:40:28  djw
! *** empty log message ***
!
! Revision 1.74  2011/09/01 12:16:26  djw
! Compute the weighted and unweighted overall scale factor by the method of Luc.  The 5 different methods now available have different responses to errors in the model or data
!
! Revision 1.73  2011/05/13 11:16:51  djw
! Calls to Kallow now return a key to the test which failed and a value to indicate if it was Max or Min. The argument of KALLOW must be a variable
!
! Revision 1.72  2011/05/04 13:25:54  rich
! Correct reflection count for FO/FC statistics during SFLS.
! Add
!
! Revision 1.71  2011/02/18 17:11:42  djw
! output means of averages.  Delta should be zero.
!
! Revision 1.70  2011/01/20 15:49:03  djw
! Another attempt to remove all the dual wavelength stuff
!
! Revision 1.69  2011/01/17 15:40:14  rich
! Fix o/w of disk lexical data in dsc file when disk index block is extended.
!
! Committed on the Free edition of March Hare Software CVSNT Client.
! Upgrade to CVS Suite for more features and support:
! http://march-hare.com/cvsnt/
!
! Revision 1.68  2010/12/14 13:06:54  djw
! remove dual wavelength stuff
!
! Revision 1.67  2010/09/20 15:07:55  djw
! Edit cvs comments
!
! Revision 1.66  2010/09/20 15:05:41  djw
! Enable use of dual wavelength data
!
! Dual Wavelength Refinement.       Sept 1010
!
! Dual wavelength machine are becoming increasingly common.  This provides
! the possibility of simultaneously carrying out a high resolution refinement
! (with the Mo data) with good leverage on the hydrogen atoms and the absolute
! configuration (Cu data).
!
! Data Storage:
!
! Reflections for both Mo and Cu data.
! Extinction correction for each radiation
! Batch scale factor for each radiation
! Weighting scheme for each radiation
! f' and f" for each radiation
!
! Programming issues:
!
! Merge:  Ability to merge reflections keeping the different wavelengths separate.
! Agreement Analysis on each wavelength separately
! Fourier.  All data for one or other wavelength.
! Fourier.  Possibly 'correct' Fo for extinction and then merge scaled data
!   for both radiations.
! Ton Speks Bivjoet code.  Handle wavelengths separately or sequentially.
!
!
!
! Problems with CRYSTALS implementation:
!
! 1. No proper place to store f' f" for secondary radiation.
! 2. No mechanism for storing value of secondary wavelength
! 3. No mechanism for indicating wavelength used for each reflection
! 4. Only one extinction correction stored
!
! 1. f' f" currently tagged on to the end of a LIST 3 record.
! 2. Assume Mo is principal and Cu secondary wavelngth
! 3. Use the 'BATCH'' identifier as the wavelength selector (1=Mo, 2=Cu)
! and the batch scalefactors as the wavelength scalefaactors
! 4. There are unused OVERALL parameters for anisotropic extinction (for
! neutron work).  This was never completed because there was (at that time)
! no general agreement about the best expression for extinction.
!
!
! Redesign Features
!
! For each reflection h,k,l store lambda and  the intensity and sigma
! for the reflection itself and its Friedel pair for each wavelength.
! This would lead to significant economy at execution time because most
! of the expression is wavelength independent.
!
! Revision 1.65  2010/08/06 07:10:10  djw
! Further attempts to fix twinniNg for Centred cells and those with reflections from component 2
!
! Revision 1.64  2010/07/21 16:11:10  djw
! Watch out for twinned centred cells. Originally Fc was obtained by doubling the contributio from the 
! unique operators. This works for the 'presences', but gives non-zero results for the absences.  
! These must be kept incase a twin element contribution overlaps it.   
! Treat the left-most element as the parent. However, his leads to problems if the key is, 
! for example, 21. because 2,1 are used to identify the twin scale factor (correclty) but 
! the twin matix (incorreclty).
!
! TO BE SORTED OUT.
!
! Revision 1.63  2010/06/10 08:11:28  djw
! c  For centred cells, CRYSTALS used the optimisation page 45 Rollett which adds together
! c  the contributions to A from atoms at x and x+1/2 (ie multiplies A by 2)
! c  For a systematic absence it should subtract the contrinution fro x+1/2, ie A=0 etc.
! c  As originally written, the program gets FC > 0 for absences.
! c  This should not matter for untwinned crystals, since the absences should have been removed.
! c  For twins, the second component may overlap with a systematic absence from the first
! c  component so we must check for this an ensure the contribution from the first is zero.
!
! Revision 1.62  2010/05/06 09:33:04  djw
! Ensure original reflection indices are maintained in LIST 6 (ancient bug which only shows if elements are of the for 2 or 21 etc)
!
! Revision 1.61  2009/10/21 10:39:13  djw
! Also update list 30 if SCALE done.  This enable the SCRIPTS to make a better guess at the quality of the input model
!
! Revision 1.60  2009/07/20 10:35:18  djw
! Copy low leverage reflctions to the screen
!
! Revision 1.59  2009/06/18 07:11:20  djw
! Message when extparam goes -ve
!
! Revision 1.58  2009/06/08 14:24:39  djw
! Fix checking of polarity and enantiopole in LIST 12, and move initialisation of FLack refinement from SFLS to LIST12
!
! Revision 1.57  2009/06/04 14:32:11  djw
! compute GOF for X-ray data only
!
! Revision 1.56  2009/06/03 15:26:01  djw
! Add missing ABS() in enantiopole checking
!
! Revision 1.55  2009/04/08 08:45:14  rich
! Use .EQV. not .EQ. for logical operands at line 588
!
! Revision 1.54  2009/04/08 07:33:02  djw
! Start Flack parameter from 0.5 if it has not previously been refined
!
! Revision 1.53  2009/03/17 07:34:22  djw
! Watch out for -ve values in the denominator of R and Rw
!
! Revision 1.52  2009/03/02 09:52:36  djw
! If a twin scale factor goes negative, reset it to zero and scale remaining factors so that sum is unity otherwise SUMFIX uses incorrect target
!
! Revision 1.51  2008/02/14 11:04:16  djw
! Add more comments
!
! Revision 1.50  2007/10/09 07:03:15  djw
! Output more R-factors to cif
!
! Revision 1.49  2006/08/02 06:21:04  djw
! Change captions to most disagreeable reflection list
!
! Revision 1.48  2005/05/31 11:34:58  djw
! Try to sort out use of L33CD and M33CD in SFLS.FPP
!
! Revision 1.47  2005/05/26 10:10:47  djw
! Enable REF and CALC to be given in the same SFLS instruction.  CALC must be last command
!
! Revision 1.46  2005/05/19 15:30:21  djw
! Highlight NPD atoms in CMON output
!
! Revision 1.45  2005/05/13 12:06:32  stefan
! 1. The memory allocation for param list is now done in the param_list_make routine and so has been removed from here.
!
! Revision 1.44  2005/05/12 13:35:35  stefan
! 1. The memory allocation for the parameter list is done a little better but still isn't perfect.
!
! Revision 1.43  2005/03/08 13:03:45  stefan
! 1. Replaced code for param-list accumalation with new call which can handle a blocked normal matrix.
!
! Revision 1.42  2005/02/10 15:07:04  djw
! Warn user if scalefactor goes out of range
!
! Revision 1.5  2005/01/17 14:08:03  rich
! Bring new repository into line up-to-date with old. (Remove debugging output,
! correct a variable name, output warning message.).
!
! Revision 1.4  2005/01/07 11:56:35  rich
! Change some zeroes into o's. Typos, I think.
!
! Revision 1.3  2004/12/15 16:02:40  rich
! Bring up to date with parallel version.
!
! Revision 1.2  2004/12/13 16:16:09  rich
! Changed GIL to _GIL_ etc.
!
! Revision 1.1.1.1  2004/12/13 11:16:07  rich
! New CRYSTALS repository
!
! Revision 1.38  2004/11/18 16:48:51  stefan
! 1. Added code to create a paramlist from the bonded atoms.
! 2. Added code to using the param list to accumerlat the paramlist
! 3. Added some code to time sflsc
!
! Revision 1.37  2004/10/11 10:37:10  djw
! Output enantiomer & high GOF info to listinf file
!
! Revision 1.36  2004/10/01 08:25:39  rich
! Fixed syntax errors (AlOl).
!
! Revision 1.35  2004/09/30 15:52:57  rich
! Uh-oh. SFLS reorganised quite a lot.
!
! Revision 1.34  2004/06/17 10:31:25  rich
! Add computation and plotting of Prince t^2/(1+Pii) values to the SFLS
! routine. (Only called if REFINE LEV=n where n>0 is specified).
!
! Revision 1.33  2004/05/13 15:26:21  rich
! Make SFLS do a leverage plot if correct incantation is specified.
!
! Revision 1.32  2004/04/16 09:42:28  rich
! Added code to compute leverages of individual reflections, instead of accummulating
! a new normal matrix. (Requires matching inverted normal matrix from a previous cycle).
!
! Revision 1.31  2004/03/24 15:03:39  rich
! Fixed: U[iso] too small message was never output due to linefeed in FORMAT statement.
! (Symptom: lots of blank lines output, followed by 'n temperature factors too small' message).
!
! Revision 1.30  2003/02/14 17:09:02  djw
! Extend codes to work wih list 6 and list 7.  Note that sfls, calc and
! recine have the parameter ityp06, which corresponds to the types
! pickedip for lists 6 and 7  from the command file
!
! Revision 1.29  2003/01/15 15:26:39  rich
! Removal of NCAWU calls throught the standard SFLS refinement instruction. If
! anywhere will benefit from less IO, it's here.
!
! Revision 1.28  2003/01/15 13:50:35  rich
! Remove all output to NCAWU as part of an ongoing project.
!
! Revision 1.27  2002/12/04 14:31:11  rich
! Reformat output during refinement.
!
! Allow punching to MATLAB files, including restraints.
!
! Tidy some routines.
!
! Revision 1.26  2002/10/31 13:27:53  rich
!
! Two changes: Default I/u(I) cutoff is now 2.0 when called from RESULTS.
! The calculation of R_gt and R_all now respect all L28 cutoffs EXCEPT
! the I/u(I) minimum value. This is more like the IUCr definition (which
! states that these values should respect the theta limits.) The IUCr don't
! mention OMITted reflections, but it's unlikely anyone wants these in
! the R_gt and R_all values.
!
! Revision 1.25  2002/09/27 14:43:46  rich
! Overwrite L5 when updating SCALE factor only.
! Some placeholder comments for Flack's unplaced e- density stuff.
!
! Revision 1.24  2002/07/15 11:58:14  richard
! Update L30 R and Rw for refinement when doing a CALC. (A calc is done during
! Cif production which ensures that these values are truly uptodate.)
!
! Revision 1.23  2002/06/07 16:06:06  richard
! New MODE parameter for SFLSB, set to -1, when called from the Cif code, it
! recalculates R-factors at either the L28 cutoff sigma value, or if there is no
! cutoff in L28, the at I>4u(I). These R-factors are store in L30 (CALC-R, etc).
!
! Also indented and simplified some of the code a bit.
!
! Revision 1.22  2002/03/18 10:01:22  richard
! Minor bug in CALC THRESHOLD fixed.
!
! Revision 1.21  2002/03/12 18:03:55  ckp2
! Only print "unwise" warning when twinned data, if user actually attempts extinction
! calculation.
!
! Revision 1.20  2002/03/11 12:06:11  Administrator
! enable axtinction and twinning, hightlight warning about inadvisability
!
! Revision 1.19  2002/03/06 15:35:53  Administrator
! Fix a format statement, enable Extinction and TWINS to be refined together
!
! Revision 1.18  2002/02/12 12:54:49  Administrator
! Allow filtering of reflections in SFLS/CALC
!
! Revision 1.17  2002/02/01 14:41:30  Administrator
! Enable CALC to get additional R factors and display them in SUMMARY
!
! Revision 1.16  2001/10/08 12:25:59  ckp2
!
! All program sub-units now return to the main CRYSTL() function inbetween commands.
! The changes made are: in every sub-program the GOTO's that used to loop back for
! the next KNXTOP command have been changed to return's. In the main program KNXTOP is now
! called at the top of the loop, but first the current ProgramName (KPRGNM) array is cleared
! to ensure the KNXTOP knows that it is not in the correct sub-program already. (This
! is the way KNXTOP worked on the very first call within CRYSTALS).
!
! We now have one location (CRYSTL()) where the program flow returns between every command. I will
! put this to good use soon.
!
! Revision 1.15  2001/08/14 10:47:06  ckp2
! FLOAT(NINT()) all indices transformed by L25 twinning matrices just in case
! the twin law doesn't quite bring them onto an integer. (The user had better
! know what they are doing).
!
! Revision 1.14  2001/07/11 10:18:51  ckpgroup
! Enable -ve Flack Parameter
!
! Revision 1.13  2001/06/08 15:03:37  richard
! Fix: Store F/F2 state from L23 into the correct slot in L30.
!
! Revision 1.12  2001/03/18 10:34:47  richard
! Sfls was updating wrong parameter in L30, overwriting structure soln with Rw.
!
! Revision 1.11  2001/03/16 16:54:55  CKP2
! Update list 30
!
! Revision 1.10  2001/03/02 17:03:46  CKP2
! djw put common block \xsfwk inti macrifile, and extend for (more!) cif
! items
!
! Revision 1.9  2001/02/26 10:29:08  richard
! Added changelog to top of file
!
!

!CODE FOR XSFLSB
subroutine XSFLSB (MODE, ITYP06)
!--MAIN CONTROL ROUTINE FOR THE S.F.L.S. ROUTINES
!
!--
!      if MODE EQ -1, DON'T READ DATA STREAM, USE I/u(I)>2 if no value
!                                             in L28.
!      if MODE EQ 0,  DON'T READ DATA STREAM, USE EXISTING L33 THRESHOLD
!      if MODE EQ 1, READ DATA STREAM
!
!      ITYP06 - LIST TYPE INDICATOR. 1=6, 2=7
!
!
!include 'STORE.INC'
use store_mod, only:store, istore, nfl
!include 'XLISTI.INC'
use xlisti_mod, only: irec, lef, ln
!include 'XUNITS.INC90'
use xunits_mod, only: ierflg, ncawu, NCFPU1, ncvdu, NCFPU2, ncwu
!include 'XSSVAL.INC90'
use xssval_mod, only:issprt
!include 'XUSLST.INC'
use xuslst_mod, only: ln5
!include 'XLST01.INC90'
use xlst01_mod, only: l1c
!include 'XLST02.INC90'
use xlst02_mod, only: n2, n2t, n2i, md2, md2i, m2, m2i, l2, l2i, ic
!include 'XLST03.INC90'
use xlst03_mod, only: n3, md3, m3, l3
!include 'XLST05.INC90'
use xlst05_mod, only: n5, md5es, md5, m5es, m5, l5o, l5es, l5
!include 'XLST06.INC90'
use xlst06_mod, only: n6w, md6dtl, l6p, l6dtl
!include 'XLST11.INC90'
use xlst11_mod, only: n11r, m11r, l11r, l11p
!include 'XSTR11.INC'
use xstr11_mod, only: str11=>xstr11
!include 'XLST12.INC90'
use xlst12_mod, only: n12
!include 'XLST13.INC90'
use xlst13_mod, only: l13dt, l13dc, l13cd
!include 'XLST22.INC90'
use xlst22_mod, only: n22, md22, l22
!include 'XLST23.INC90'
use xlst23_mod, only: l23sp, l23mn, l23ac, l23m
!include 'XLST28.INC90'
use xlst28_mod, only:l28cn, n28mn, md28mn, md28cn, m28mn, l28mn
!include 'XLST25.INC'
use xlst25_mod, only: n25
!include 'XLST30.INC90'
use xlst30_mod !, only: l30rf, l30ix, l30dr, l30cf, idim30, icom30 (everything is passed to a subroutine)
!include 'XLST33.INC90'
use xlst33_mod !, only: m33v, m33cd (everything is passed to a subroutine)
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XOPVAL.INC90'
use xopval_mod, only: iopsfs, iopend
!include 'XSFWK.INC90'
use xsfwk_mod, only: rall, wdft, wave, theta1, theta2, smin, smax, r, scale, rw, a, aminf
!include 'XMTLAB.INC'
use xmtlab_mod, only: matlab
!include 'XWORKB.INC'
use xworkb_mod!, only: nd, nf, ni, nl, nm, nr, nu, nt, nv, nn, jo, jq, ji, jq, jp, jn, jr
!include 'XSFLSW.INC90'
use xsflsw_mod, only: wsfofc, wsfcfc, sfofc, sfcfc, twinned, sfls_type, sfls_calc, batched
use xsflsw_mod, only: sfls_refine, sfls_scale, scaled_fot, refprint, partials, newlhs, enantio
use xsflsw_mod, only: jref_stack_start, layered, jref_stack_ptr, iso_only, extinct, anomal
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
use xconst_mod, only: nowt, rtd, uiso, zero

implicit none

!include 'TYPE11.INC' ! merged in xstr11.inc.F90
!include 'ISTORE.INC' ! merged in store.inc.f90
!include 'ICOM30.INC' ! merged in xlst30.inc.F90
!include 'ICOM33.INC' ! merged in xlst33.inc.F90


!include 'QSTORE.INC' ! merged in store.inc.f90 
!include 'QLST33.INC' ! merged in xlst33.inc.F90 ! equivalence removed
!include 'QSTR11.INC' ! merged in xstr11.inc.F90 ! equivalence removed
!include 'QLST30.INC' ! merged in xlst30.inc.F90 ! equivalence removed

integer, dimension(idim33) :: icom33
integer, dimension(idim30) :: icom30
!
!
!
character, dimension(4,2), parameter :: &
&   JFRN=reshape( (/ 'F', 'R', 'N', '1', 'F', 'R', 'N', '2' /), (/4,2/) )
!
!
character(len=12) :: CTEMP
!
!----- V 810 includeS THE SPECIAL SHAPES
integer, parameter :: IVERSN=811
integer PARAM_LIST_MAKE

integer, intent(in) :: MODE
integer, intent(inout) :: ityp06

integer iupdat, iuln, istat2, istat, iresults, irefls, indnam
integer lstop, lstno, j, k, l, nneg, nj, n6temp, n
integer mgm, ny, nupdat, num, nresults, m, ljs, ilev
integer igstat, iclass, iaddu, iaddr, iaddl, iaddd, i
integer idir
real umin, u, stoler, s6sig, rscle, foav, fcav, elesum, elescl
real delfofc, cycno, wscle

integer, external :: krddpv, kset52, kchnfl, ktyp06, kspget
integer, external :: ksctrn, kset53, kspini, kchlfl, krdndc
integer, external :: khuntr, knxtop
character(len=256) :: formatstr

!----- ACCEPT -VE FLACK PARAMETER
!----- USES DifABS CORRECTION TO FC
!----- THE CODE HAS BEEN REORGANISED SO THAT FOR NONTWINNED REFINEMENT
!      THE CODE IS ALMOST CONTINUOUS. F**2 REFINEMENT HAS ALSO BEEN
!      LINEARISED.
!
call XTIME1(1)
ILEV = 0
IRESULTS=1
NRESULTS=1
if (MODE .LE. 0) then
!----- WE WONT READ ANY DATA, BUT WILL SET TYPE TO 'CALC'
    NUM = 3
else
!--LOAD THE NEXT '#INSTRUCTION'
    NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
!--CHECK if WE SHOULD return
    if(NUM.LE.0) return
!--BRANCH ON THE TYPE OF OPERATION
    I=KRDDPV(ISTORE(NFL),1)
!--READ THE NEXT DIRECTIVE CARD
! RIC11            LAST=IDIR
    IDIR=KRDNDC(ISTORE(NFL),1)
!--CHECK THE REPLY
    if(IDIR .GE. 0) then
!--ERROR CONDITION
        formatstr="(1X ,'No additional arguments permitted')"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
        write ( NCAWU , formatstr )
        write ( CMON, formatstr )
        call XPRVDU(NCVDU, 1,0)
        return
    end if
!--END OF THE DIRECTIVES  -  CHECK FOR ANY ERRORS
    if ( LEF .NE. 0 ) then
        formatstr="(1X ,'No additional arguments permitted')"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
        write ( NCAWU , formatstr )
        write ( CMON, formatstr )
        call XPRVDU(NCVDU, 1,0)
        return
    end if
!--SAVE THE LIST TYPE INDICATOR
      ITYP06=ISTORE(NFL)
end if

!call XZEROF(IWORKA(1),17)
!IWORKA(1:17)=0
call xworkb_zeros

select case(num) ! GOTO(1200,1250,1300,1350,4550,4600,1150),NUM
    case(7)
    ! Something really wrong happened, terminating
    call GUEXIT(54)
    STOP ! Should not been called

!--'#REFINE' HAS BEEN GIVEN
    !case(1)
    case default !1200  CONTINUE
    SFLS_TYPE = SFLS_REFINE
    !GOTO 1400
!
!--'#SCALE' HAS BEEN REQUESTED
    case(2) ! 1250  CONTINUE
    SFLS_TYPE = SFLS_SCALE
    !GOTO 1400
!
!--'#CALCULATE' HAS BEEN GIVEN
    case(3) ! 1300  CONTINUE
    SFLS_TYPE = SFLS_CALC
    !call XZEROF(RALL(1),12)
    RALL(1:12)=0.0
    !GOTO 1400
!
!--'#CYCLENDS' INSTRUCTION
    case(4) ! 1350  CONTINUE
    call XCYCLE
    return
    
!--'#END' INSTRUCTION
    case(5) ! 4550  CONTINUE
    call XEND
    return

!--'#TITLE' INSTRUCTION
    case(6) ! 4600  CONTINUE
    call XRCN
    return          
end select
    
!
!--SET THE VALUES FOR A S.F.L.S. CALCULATION
!1400  CONTINUE
#if defined(_PPC_) 
!S***
call SETSTA( 'S.F.L.S.' )
call nextcursor
!E***
#endif
call XDUMP
!--CLEAR THE CORE
call XRSL
!--LOAD LIST 13  -  THE EXPERIMENTAL CONDITIONS LIST
call XFAL13
if ( IERFLG .LT. 0 ) return
!--SET THE TWINNED/NON-TWINNED FLAG
TWINNED = .FALSE.
if(ISTORE(L13CD+1).GE.0) TWINNED = .TRUE.
!--FIND THE TYPE OF RADIATION
NU=ISTORE(L13DT+1)
!--FETCH THE POLARISATION CONSTANTS
WAVE=STORE(L13DC)
THETA1=STORE(L13DC+1)
THETA2=STORE(L13DC+2)
!--LOAD LIST 23  -  DEFINES CONDITIONS FOR S.F.L.S. CALCULATIONS
!call XFAL23new(ierflg)
call XFAL23
if ( IERFLG .LT. 0 ) return
!--SET THE ANOMALOUS DISPERSION FLAG
! SET TO -1 FOR NO ANOMALOUS DISPERSION, else 0 Replaced by ANOMAL      
ANOMAL = .FALSE.
if ( ISTORE(L23M) .EQ. 0 ) ANOMAL = .TRUE.
!--SET THE EXTINCTION FLAG
EXTINCT = .FALSE.
if(ISTORE(L23M+1).GE.0) EXTINCT = .TRUE.
!--SET THE LAYER SCALES APPLICATION FLAG
LAYERED=.FALSE.
if(ISTORE(L23M+2).GE.0) LAYERED = .TRUE.
!--SET THE BATCH SCALES APPLICATION FLAG
BATCHED=.FALSE.
if (ISTORE(L23M+3).GE.0) BATCHED = .TRUE.
!--SET THE PARTIAL CONTRIBUTIONS FLAG
PARTIALS = .FALSE.
if(ISTORE(L23M+4).GE.0) PARTIALS = .TRUE.
!--SET THE UPDATE PARTIAL CONTRIBUTIONS FLAG
ND=ISTORE(L23M+5)
!----- SET THE ENANTIOPOLE REFINEMENT FLAG
ENANTIO = .FALSE.
if ( ISTORE(L23M+6) .EQ. 0 ) ENANTIO = .TRUE.
!--SET THE FLAG FOR REFINEMENT AGAINST /FO/ OR /FO/ **2
NV=ISTORE(L23MN+1)
!----- CHECK if WE  NEED REFLECTIONS (-1 IF NOT)
IREFLS = ISTORE(L23MN+3)
!--FIND THE MINIMUM ALLOWED TEMPERATURE FACTOR
UMIN=STORE(L23AC+8)
!----- SAVE THE TOLERANCE AND UPDATE VALUES
STOLER = STORE(L23SP+5)
IUPDAT = ISTORE(L23SP+1)
!--CLEAR THE CORE OUT AGAIN
call XRSL
call XCSAE
!----- SAVE SOME SPACE FOR THE U AXES
IADDU = KCHLFL (4)
!--LOAD LIST 33  -  THE CONDITIONS FOR THIS S.F.L.S. CALCULATION
call XFAL33
if ( IERFLG .LT. 0 ) return
if ( SFLS_TYPE .EQ. SFLS_CALC ) then
    RALL(1)=STORE(M33CD+5)
end if
!
! If outputting design matrix and deltaF's then open files now.
if ( SFLS_TYPE .eq. SFLS_REFINE ) then     
     MATLAB = 0
     if (ISTORE(M33CD+5).EQ.1) then
         MATLAB = 1
         call XRDOPN (5,JFRN(1,1),'design.m',8)
         write (NCFPU1, '(''A=['')')
         call XRDOPN (5,JFRN(1,2),'wdf.m',5)
         write (NCFPU2, '(''DF=['')')
     end if

     ILEV = ISTORE(M33CD+12)
end if

NF=-1
REFPRINT = .FALSE.
!----- READ DOWN SOME LISTS
call XFAL01
call XFAL02
call XFAL05
call XFAL30
if (IERFLG .LT. 0) return
!
!--CHECK THAT ALL THE TEMPERATURE FACTORS ARE REASONABLE
!-C-C-CHECK THAT ALL T.F. AND SPECIAL PARAMETERS ARE REASONABLE
!-C-C-SIMILAR CHECKS ALSO IN XSFLSG (NO CHANGE OF LIST 5 BY XSFLSB)
M5=L5
!--CHECK THAT THERE IS AT LEAST ONE ATOM IN LIST 5
if(N5 .LE. 0) then ! GOTO 9940
    formatstr="(1X ,'LIST 5 contains no atoms')"
    if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
    write ( CMON, formatstr )
    call XPRVDU(NCVDU, 1,0)
    return
end if

!--LOOP OVER EACH ATOM
A=1000.
N=0
do I=1,N5   ! Safety checks
!-C-C-CHECK WHETHER ATOM IS ANISOTROPIC
    if (ABS(STORE(M5+3)) .LE. UISO) then
!-C-C-CHECK ANISOTROPIC ATOMS
!--CHECK THE SMALLEST U AXIS
        call XEQUIV ( 1, M5, MD5, IADDU )
        if (STORE(IADDU+1) .LT. UMIN) then
!--THIS ANISOTROPIC TEMPERATURE FACTOR IS NOT ALLOWED
            if (ISSPRT .EQ. 0) then
                write(NCWU, 3110) STORE(M5), NINT(STORE(M5+1)),STORE(IADDU+1)
            end if
3110  FORMAT(' Atom ', A4, I5, ' has U-min too small, ', F8.4)
            write ( CMON, 3110) STORE(M5), NINT(STORE(M5+1)),STORE(IADDU+1)
            call OUTCOL(9)
            call XPRVDU(NCVDU, 1,0)
            call OUTCOL(1)
            A=MIN(A,STORE(IADDU+1))
            N=N+1
            U = UMIN+ZERO
            STORE(M5+7) = MAX(U,STORE(M5+7))
            STORE(M5+8) = MAX(U,STORE(M5+8))
            STORE(M5+9) = MAX(U,STORE(M5+9))
            STORE(M5+10) = MAX(0.01*U,STORE(M5+10))*STORE(L1C)
            STORE(M5+11) = MAX(0.01*U,STORE(M5+11))*STORE(L1C+1)
            STORE(M5+12) = MAX(0.01*U,STORE(M5+12))*STORE(L1C+2)
        end if
    else
!-C-C-CHECK ISOTROPIC ATOM OR SPECIAL FIGURE
!--CHECK THE ISOTROPIC TEMPERATURE FACTOR
        if(STORE(M5+7) .LE. UMIN) then
!--THIS U[ISO] VALUE IS OUT OF RANGE
            write ( CMON, 3120)STORE(M5), NINT(STORE(M5+1)),STORE(M5+7)
            call XPRVDU(NCVDU, 1,0)
            if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)
3120        FORMAT(' Atom ',A4,I5,' has U-iso too small, ', F8.4)
            A=MIN(A,STORE(M5+7))
            N=N+1
            STORE(M5+7) = UMIN + ZERO
        end if
!-C-C-CHECK OF SPECIAL FIGURE SPECifIC PARAMETERS
        if (NINT(STORE(M5+3)) .GE. 2) then
!-C-C-CHECK OF SIZE FOR ALL SPECIAL FIGURES
            if (STORE(M5+8) .LT. 0.0005) then
                if (ISSPRT .EQ. 0) then
                    write(NCWU,3130)STORE(M5), NINT(STORE(M5+1)),STORE(M5+8)
                end if
3130            FORMAT(/,' Spec.Fig. ',A4,I5, ' has SIZE too small:',F8.4, &
                &    /,31X,'Reset to:  0.001',/, 21X, &
                &    '(in LIST 5 only in case of refinement !)')
                STORE(M5+8)=0.001
            end if
!-C-C-CHECK OF DECLINAT AND AZIMUTH FOR LINE AND RING
            if (NINT(STORE(M5+3)) .GE. 3) then
!-C-C-CHECK WHETHER DECLINAT MIGHT BE GIVEN IN DEGREES
!-C-C-(SUPPOSED if ANGLES BIGGER THAN 5.0)
!-C-C-(THIS BLOCK CAN BE REMOVED WHEN IT IS MADE SURE THAT THE VALUE
!-C-C-OF ANGLES IS ALWAYS IN UNITS OF 100 DEGREES.)
                if ((STORE(M5+9) .GE. 5.0).OR.(STORE(M5+9) .LE. -5.0)) then
                    if (ISSPRT .EQ. 0) then
                        write(NCWU,3140)STORE(M5), NINT(STORE(M5+1)),STORE(M5+9)
                    end if
3140                FORMAT(/,' Line/Ring ',A4,I5,' has DECLINAT probably', &
                    &   ' given in degrees: ', F8.4,/, &
                    &   21X,'Value devided by 100 to get units of 100 degrees',/, &
                    &   21X,'(in LIST 5 only in case of refinement !)')
                    STORE(M5+9)=STORE(M5+9)/100
                end if
!-C-C-BRING DECLINAT INTO PRACTICAL RANGE if TOO FAR AWAY FROM IT
                if ((STORE(M5+9).GT.3.6).OR.(STORE(M5+9).LT.-3.6)) then
                    STORE(M5+9)=MOD(STORE(M5+9),3.6)
                end if
                if (STORE(M5+9) .GT. 1.8) then
                    STORE(M5+9)=STORE(M5+9)-3.6
                else if (STORE(M5+9) .LT. -1.8) then
                    STORE(M5+9)=STORE(M5+9)+3.6
                end if
!-C-C-CHECK WHETHER DECLINAT IS CLOSE TO 0.0 OR +/-1.8
                if ((ABS(STORE(M5+9)+1.8) .LT. 0.001) .OR. &
                &   (ABS(STORE(M5+9)-1.8) .LT. 0.001) .OR. &
                &   (ABS(STORE(M5+9)) .LT. 0.001)) then
!-C-C-PRINT WARNING, GIVE AZIMUTH ARBITRARY VALUE
                    if (ISSPRT .EQ. 0) then
                        write(NCWU, 3145) STORE(M5), NINT(STORE(M5+1))
                    end if
3145                FORMAT(/,' Line/Ring ',A4,I5,' has DECLINAT = n*180.0 deg.', &
                    &   /,21X,'==> AZIMUTH is not defined !!!', &
                    &   /,    ' It is reset to an arbitrary value (0.0)', &
                    &         ' and should not be refined !', &
                    &   /,' (change in LIST 5 only in case of refinement !)')
!-C-C-PERHAPS IT'S REASONABLE TO REMOVE THE AUTOMATICAL CHANGE
                    STORE(M5+10) = 0.0
                else
!-C-C-CHECK WHETHER AZIMUTH MIGHT BE GIVEN IN DEGREES
!-C-C-(SUPPOSED if ANGLES BIGGER THAN 5.0)
!-C-C-(THIS BLOCK CAN BE REMOVED WHEN IT IS MADE SURE THAT THE VALUE
!-C-C-OF ANGLES IS ALWAYS IN UNITS OF 100 DEGREES.)
                    if ((STORE(M5+10).GE.5.0).OR.(STORE(M5+10).LE.-5.0))THEN
                        if (ISSPRT .EQ. 0) then
                            write(NCWU,3150)STORE(M5),NINT(STORE(M5+1)), STORE(M5+10)
                        end if
3150                    FORMAT(/,' Line/Ring ',A4,I5,' has AZIMUTH  probably', &
                        &                ' given in degrees: ', F8.4,/, &
                        &   21X,'Value devided by 100 to get units of 100 degrees',/, &
                        &   21X,'(in LIST 5 only in case of refinement !)')
                        STORE(M5+10)=STORE(M5+10)/100
                    end if
!-C-C-BRING AZIMUTH INTO PRACTICAL RANGE if TOO FAR AWAY FROM IT
                    if ((STORE(M5+10).GT.3.6).OR.(STORE(M5+10).LT.-3.6))THEN
                        STORE(M5+10)=MOD(STORE(M5+10),3.6)
                    end if
                    if (STORE(M5+10) .GT. 1.8) then
                        STORE(M5+10)=STORE(M5+10)-3.6
                    else if (STORE(M5+10) .LT. -1.8) then
                        STORE(M5+10)=STORE(M5+10)+3.6
                    end if
                end if
            end if
        end if
    end if
    M5 = M5 + MD5
end do
!--CHECK if THE T.F.'S ARE ALL OKAY
if (N .NE. 0) then
! -- INVALID TEMPERATURE FACTOR
    if (ISSPRT .EQ. 0) write ( NCWU , 9935 ) N , UMIN , A
9935      FORMAT ( 1X , I6 , ' temperature factors less ' , &
    &   'than the lowest allowed value of ' , F10.5 , &
    &   /1X,' The minimum value  was ', F10.5)
    write ( CMON, 9935) N, UMIN, A
    call XPRVDU(NCVDU, 2,0)
end if
if ((STORE(L5O+4) .GT. 1.) .OR. (STORE(L5O+4) .LT. 0.)) then
    write ( CMON, 3320) STORE(L5O+4)
    call XPRVDU(NCVDU, 1,0)
    if (ISSPRT .EQ. 0)  write(NCWU, '(A)') CMON(1)(:)
3320      FORMAT(1X,'Enantiopole parameter out of range. (',F6.3,' ) ')
end if

if (STORE(L5O+5) .LT. -ZERO) then
    call OUTCOL(9)
    write ( CMON, 3345) STORE(L5O+5)
    call OUTCOL(1)
    call XPRVDU(NCVDU, 1,0)
    write(NCWU, '(A)') CMON(1)(:)
3345      FORMAT(1X,'Extinction parameter negative. (',F12.6,' ) ')
    STORE(L5O+5) = 0.0
end if

if (IUPDAT .GE. 0)  I = KSPINI( -1, STOLER) ! SET THE OCCUPANCIES
NUPDAT = 0  
J =NFL
I = KCHNFL(40)  ! SAVE SOME WORK SPACE
M5 = L5
do I = 1, N5   ! Set occupancies
    if (IUPDAT .GE. 0) then
        IGSTAT =KSPGET ( STORE(J), STORE(J+10), ISTORE(J+20), &
        &   STORE(J+30), MGM, M5, IUPDAT, NUPDAT)
    else
        STORE(M5+13) = 1.0
    end if
    M5 = M5 + MD5
end do
NFL= J
!djwapr09 Check the Flack Enantiopole Parameter.
! If this is the first time it has been refined, set it to 0.5
!
! moved to LIST12.fpp because it can clash with POLARITY refinement
! if the user forgets to reset list 23
!
!      if (( enantio .eqv. .true.) .and. (abs(store (L5o+4)) .le. zerosq)
!     1 .and. (abs(store(l30ge+6)) .le. zero)) then
!            store(L5O+4) = 0.5
!            write ( CMON, '(A)')'Starting FLACK refinement from 0.5' 
!            call XPRVDU(NCVDU, 1,0)
!            if (ISSPRT .EQ. 0)  write(NCWU, '(A)') CMON(1)(:)
!      endif
!
SCALE = STORE(L5O) 
if (SCALE .LE. 0.000001) then  ! CHECK THAT THE SCALE FACTOR GIVEN IS NOT ZERO
    if (ISSPRT .EQ. 0) write(NCWU,1420)
    write ( CMON, 1420)
    call XPRVDU(NCVDU, 1,0)
1420      FORMAT(10X,' The overall scale factor has been set to 1.0' )
    SCALE = 1.   ! SCALE FACTOR IS UNREASONABLE  -  RESET IT TO 1.0
    STORE(L5O)=1.
    call XSTR05(5,-1,-1)
end if

NEWLHS = .FALSE.  ! CHECK ON THE TYPE OF MATRIX TO USE
if ( ISTORE( M33CD+6) .EQ. -1 ) NEWLHS = .TRUE.
ISTAT2 = ISTORE (M33CD+3)  ! SET THE STORE MAP LEVEL

if ( IREFLS .GE. 0 ) then            ! Not Restraints only
    if ( ISTORE(M33CD+2) .GT. 0 ) then  ! CHECK ON THE TYPE OF LISTING REQUIRED
        NF=0   ! COMPLETE LISTING, INCLUDING ELEMENT CONTRIBUTIONS FOR A TWIN
        REFPRINT = .TRUE.   ! LISTING OF EACH STRUCTURE FACTOR AS IT IS CALCULATED
    else if ( ISTORE(M33CD+2) .EQ. 0 ) then
        REFPRINT = .TRUE.   ! LISTING OF EACH STRUCTURE FACTOR AS IT IS CALCULATED
    end if
    if (TWINNED) then  ! CHECK IF THIS STRUCTURE IS TWINNED
        SCALED_FOT = .FALSE.
        if(ISTORE(M33CD+4).GE.0) SCALED_FOT = .TRUE.   ! SCALED /FOT/ IS REQUIRED
    end if

    call XFAL03    ! READ DOWN SOME LISTS
    IULN = KTYP06(ITYP06)  ! FIND THE REFELCTIONLIST TYPE
    call XFAL06(IULN,1)

    S6SIG = -10.0   ! SIGMA THRESHOLD
    rall(1) = 2.0
    if ( MODE.ge. 0 ) then
        if ( N28MN .GT. 0 ) then
        INDNAM = L28CN
        do I = L28MN , M28MN , MD28MN
            write ( CTEMP , '(3A4)') (ISTORE(J),J=INDNAM,INDNAM+2)
            if (INDEX(CTEMP,'RATIO') .GT. 0) then
                S6SIG = STORE(I+1)
                if ( MODE.EQ.-1 ) RALL(1) = STORE(I+1)
            end if
            INDNAM = INDNAM + MD28CN
        end do
    end if
endif

if ( IERFLG .LT. 0 ) return

call XIRTAC(4)   ! CRIC11-Update FO totals in all cases, in case L28 changed
call XIRTAC(6)   ! INITIALISE THE COLLECTION OF THE DETAILS FOR /FC/ AND PHASE
call XIRTAC(7)
call XIRTAC(16)

N12=0  ! SET UP DEFAULT VALUES FOR THE REFLECTION HOLDING STACK
N25=1


if ( .NOT. TWINNED ) then        ! THIS IS NOT A TWINNED REFINEMENT
    NF=-1
    if(ND.GE.0) then  ! CHECK IF WE ARE UPDATING THE PARTIAL DERIVATIVES
        call XIRTAC(8)
        call XIRTAC(9)
    end if

else                         ! THIS IS A TWINNED REFINEMENT

    if ( EXTINCT ) then
        write(CMON,'(6X,A)') 'It is unwise to refine extinction for twinned data'
        call OUTCOL(9)
        call XPRVDU(NCVDU, 1,0)
        if (ISSPRT .EQ. 0) write(NCWU,'(A)') CMON(1)
        call OUTCOL(1)
!djw0302 - allow twin with extparam:  NA=-1
    end if
    PARTIALS = .FALSE. ! SUPPRESS PARTIAL CONTRIBUTIONS
    ND=-1
    ENANTIO = .FALSE.  ! SUPPRESS ENANTIOPOLE REFINEMENT
!ric11        call XIRTAC(4)     ! INITIALISE THE DETAILS FOR /FO/

    if(.NOT. REFPRINT) NF = -1          ! SUPPRESS ELEMENT PRINTING

    if ( IERFLG .LT. 0 ) return
    call XFAL25                  ! LOAD THE TWIN OPERATORS

    if ( MD5ES .NE. N25 ) then !GO TO 9910 ! CHECK THAT THE NUMBER OF OPERATORS EQUALS THE NUMBER OF ELEMENTS
! -- NUMBERS DON'T MATCH
        formatstr="(1X,'The number of elements in lists 5 and 25 is different' )"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
            write ( CMON, formatstr )
            call XPRVDU(NCVDU, 1,0)
            call XERHND ( IERERR )
            return
        end if

        LN=LN5
        IREC=1001
        M5ES=NFL
        I=KCHNFL(MD5ES)
        J=M5ES
        K=L5ES
!djwMar09 - fix sum if scales go -ve
        elesum = 0.
        nneg = 0
! turn on red
        call OUTCOL(9)
        do I=1,MD5ES   ! FORM THE SQUARE ROOT OF THE ELEMENT SCALES
            if (STORE(K) .LT. 0) then
                if (ISSPRT .EQ. 0) write(NCWU,2301) I,STORE(K)
                write ( CMON, 2301)  I, STORE(K)
                call XPRVDU(NCVDU, 1,0)
2301            FORMAT(' Twin element error, Scale',I3,' = ',F8.4)
                STORE(K) = 0.0
                nneg = nneg + 1
            end if
            elesum = elesum + store(k)
            K=K+1
        end do
        if (nneg .gt. 0) then
            elescl = 1./ elesum
            if (ISSPRT .EQ. 0) write(NCWU,2302) elescl
            write ( CMON, 2302)  elescl
            call XPRVDU(NCVDU, 1,0)
2302        FORMAT(' Rescaling element scales by  ',f10.4)
        end if
! turn off red
        call OUTCOL(9)
        K=L5ES
        do I=1,MD5ES   ! FORM THE SQUARE ROOT OF THE ELEMENT SCALES
            if ( nneg .gt. 0) then 
                STORE(J)=SQRT(STORE(K)*elescl)
            else
                STORE(J)=SQRT(STORE(K))
            end if
            J=J+1
            K=K+1
        end do
    end if
end if

JQ=0

if ( SFLS_TYPE .NE. SFLS_REFINE ) then  ! NO REFINEMENT
    ISO_ONLY = .TRUE.
    JO = 1 ! Dummy space for derivatives
    JP = 1 ! Dummy space for derivatives

    if(KSET52(-1,0).GE.0)THEN      ! SET THE T.F. VALUES IN LIST 5
        if ( IERFLG .LT. 0 ) return
        ISO_ONLY = .FALSE.
    end if
else                             ! REFINEMENT

    JQ=(2-IC)  ! SET UP THE STORAGE LOCATIONS FOR THE PARTIAL DERIVATIVES
    if ( ANOMAL ) JQ = JQ * 2
    JQ=MAX0(JQ,2)
    LJS=-1

    call XFAL12(LJS,JQ,JR,JN)  ! LOAD LIST 12
    if ( IERFLG .LT. 0 ) return
    ISO_ONLY = .TRUE. ! SET THE INITIAL DETAILS FOR LINKING LISTS 12 AND 5
    if(KSET52(0,0).GE.0)THEN    ! LINK LIST 12 AND LIST 5
        if ( IERFLG .LT. 0 ) return
        ISO_ONLY = .FALSE.  ! ! ANISO T.F.'S ARE STORED
    end if
    if ( IERFLG .LT. 0 ) return

    if ( N12 .LE. 0 ) then !GO TO 9920  ! CHECK THERE ARE PARAMETERS TO REFINE
! -- NOTHING TO REFINE
        formatstr="(1X, 'List 12 indicates that no parameters are to be refined' )"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
        write ( CMON, formatstr )
        call XPRVDU(NCVDU, 1,0)
        call XERHND ( IERERR )
        return !GO TO 9900
    end if

    JO=JR       ! SET UP THE STACK FOR THE COMPLETE PARTIAL DERIVATIVES
    JP=JO+N12-1

    if ( ILEV .NE. 0 ) then  ! CHECK IF WE NEED THE L.H.S.
        call XSET11(0,1,1)  ! Need old matrices for working out leverage.
        if ( IERFLG .LT. 0 ) return
    else
        if(NEWLHS) then           ! SET UP A NEW MATRIX   MATRIX=NEW (default)
            call XSET11(-1,1,1)
            if ( IERFLG .LT. 0 ) return
            if (ISTORE(M33CD+13) .EQ. 0) then ! See if sparse is set to bond
!                     iresults = KSTALL(N11)
!                     print *, N11, NRESULTS
!                     NRESULTS = param_list_make(istore(IRESULTS), N11, JR,
!     1                JQ)
                NRESULTS = param_list_make(IRESULTS, JR, JQ)
!            print *, N11, NRESULTS
! Allocate the rest of the memory we have already used. this is horrible but there
! isn't any other way to do it unless I create a chain(linked list)
!               inewresult = KSTALL(NRESULT) 
            end if
        else                       ! WE ONLY NEED THE R.H.S. MATRIX=OLD (Old LHS will be loaded later)
            call XSET11(0,0,1)
            if ( IERFLG .LT. 0 ) return
            M11R=L11R+N11R-1  
            STR11(L11R:M11R)=0. ! CLEAR THE R.H.S. OF THE OLD NUMBERS
        end if
    end if

!--CHECK THAT THERE IS ROOM TO OUTPUT THE MATRIX
    call XCL11(11)
!C--INITIALISE THE MATRIX ACCUMULATION ROUTINES
!c        call XSETMT
end if

!--LINK LIST 5 AND 3
!----- CHECK FOR RESTRAINTS ONLY
if (IREFLS .GE. 0) then
    N3=KSET53(0)+1
    if ( IERFLG .LT. 0 ) return
end if
!
!----- CHECK if REFLECTIONS SHOULD BE USED
if (IREFLS .LE. -1) then
    NT    = 0
    R     = 0.
    RW    = 0.
    WDFT  = 0.
    AMINF = 0.
    CYCNO = STORE(M33V) + 1
else
!--SET UP THE REFLECTION HOLDING STACK
    NR=4
    NY=20  ! restore jan2010
!         NY=21  ! leave one more slot for the BATCH number for use sep2010
!         when there is auxilliary radiation
    JREF_STACK_START=NFL
!--SET THE LIST AND RECORD TYPE
    LN=25
    IREC=1001

! N25 is the number of twin elements
! N12 is the number of parameters being refined
! JQ is the number of words needed to hold each derivative
! NY is 20 (21 if batch saved)
! NR is 4 = H,K,L,PSHifT for each reflections
! N2I is the number of symmetry operators

     JREF_STACK_PTR = KCHNFL(N25*(N12*(JQ+1)+NY+NR*N2I)+1)
!--PREPARE TO INITIALISE THE STACK
     JREF_STACK_PTR = JREF_STACK_START+1
     NI = JREF_STACK_START
     NJ = (N2T-1)*NR
 
     do I=1,N25      ! SET UP THE STACK
         ISTORE(NI)    = JREF_STACK_PTR   ! Ptr to next block
         NI            = JREF_STACK_PTR   ! Update ptr
         ISTORE(NI)    = NOWT             ! Indicate last block
         ISTORE(NI+1)  = JREF_STACK_PTR+NY   ! Ptr to start of derivs
         ISTORE(NI+2)  = ISTORE(NI+1)+N12-1  ! Ptr to end of derivs
         ISTORE(NI+18) = ISTORE(NI+2)+1      ! Ptr to start of ?
         ISTORE(NI+19) = ISTORE(NI+18)+N12*JQ-1  ! Ptr to end of ?
         ISTORE(NI+9)  = ISTORE(NI+19)+1
         ISTORE(NI+10) = ISTORE(NI+9)+NJ
         JREF_STACK_PTR= ISTORE(NI+10)+NR
         NL=ISTORE(NI+9) ! INSERT DUMMY INITIAL INDICES
         NM=ISTORE(NI+10)
         do NN=NL,NM,NR
             STORE(NN)=-1000000. ! -huge(store)
             STORE(NN+1)=-1000000.
             STORE(NN+2)=-1000000.
             STORE(NN+3) = 0.0
         end do
     end do

     call XPRTCN               ! OUTPUT AN INITIAL CAPTION
     STORE(L6P)=STORE(L6P)+1.  ! FIND THE NUMBER OF CYCLES CALCULATED
     JI=NINT(STORE(L6P))
     CYCNO = STORE(L6P)

     if (ISSPRT .EQ. 0) write(NCWU,3600)JI  ! PRINT THE TITLE HEADING
3600       FORMAT(' Structure factor least squares',5X,' calculation number',I6)

     if(ISTAT2 .NE. 0) then   ! PRINT THE ALLOCATED CORE STORE IF NECESSARY
         call XPCM(1)
!--CHECK if WE SHOULD DUMP ANY OTHER GOODIES
         if(ISTAT2.GE.1) then 
             if (ISSPRT .EQ. 0) write(NCWU,3750) ji,jn,jo,jp,jq,jr, &
             &  nd,ne,nf,ni,nl,nm,nn,nr,nt,nu,nv ! was iworka
3750         FORMAT('IWK:',13I9)
             M2=L2+MD2*N2-1
             if (ISSPRT .EQ. 0) write(NCWU,3800) (STORE(I),I=L2,M2)
3800         FORMAT(1X,12F10.5)
             M2I=L2I+MD2I*N2I-1
             if (ISSPRT .EQ. 0) write(NCWU,3800) (STORE(I),I=L2I,M2I)
             M3=L3+MD3*N3-1
             if (ISSPRT .EQ. 0) write(NCWU,3850) (STORE(I),I=L3,M3)
3850         FORMAT(1X,A4,11F10.5)
             M5=L5+MD5*(N5-1)
             do I=L5,M5,MD5
                 L=I+2
                 M=I+MD5-1
                 if (ISSPRT .EQ. 0) then
                     write(NCWU,3900)ISTORE(I),ISTORE(I+1),(STORE(K),K=L,M)
                 end if
3900             FORMAT(1X,2I4,11F9.5)
             end do

             if(SFLS_TYPE .EQ. SFLS_REFINE) then
                 call XPRINT(L22,L22+(MD22*N22)-1)
             end if
        end if
    end if
!            call cpu_time(time_begin)
    call XSFLSC(STORE(JO),JP-JO+1,istore(iresults), nresults, ierflg) ! CALL THE CALCULATION LINK
!            call cpu_time(time_end)
!            print *, (time_end - time_begin)
end if

if ( IERFLG .LT. 0 ) return
!--CHECK FOR L.S. REFINEMENT
if( SFLS_TYPE .EQ. SFLS_REFINE ) then  !STORE THE MATRIX
    STORE(L11P+23)=real(N12)      ! STORE THE NUMBER OF PARAMETERS
    STORE(L11P+24)=real(NT)       ! NUMBER OF REFLECTIONS THAT HAVE BEEN USED
    STORE(L11P+25)=WDFT            ! STORE THE SUM OF W*DF**2
    if (ABS (RW) .LE. ZERO) then
        A =1.
    else
        A = 100. / RW
    end if
    STORE(L11P+26)=WDFT*A*A        ! STORE THE SUM OF W* /FO/ **2
    STORE(L11P+16)=STORE(L11P+24)-STORE(L11P+23)  ! NUMBER OF DEGREES OF FREEDOM
    STORE(L11P+17)=AMINF           ! STORE THE MINIMISATION function
    call XCL11(11)                 ! OUTPUT LIST 11
    call XMKOWF(11,0)
    call XALTES(11,1)
end if
!--TERMINATE THE OUTPUT OF LIST 6  -  STORE THE R-VALUE

if (IREFLS .GE. 0) then
    STORE(L6P+1)=R
!--STORE THE WEIGHTED R-VALUE
    STORE(L6P+2)=RW
!--STORE THE MINIMISATION function
    STORE(L6P+3)=AMINF
!--COMPUTE THE REFLECTION TOTALS FOR /FC/ AND PHASE
    N6TEMP = N6W
    N6W  = NT
    call XCRD(6)
!RIC11-Update FO totals in all cases, in case L28 changed
!        if(TWINNED) call XCRD(4)  ! CHECK FOR A TWINNED REFINEMENT
    call XCRD(4)  ! CHECK FOR A TWINNED REFINEMENT
    N6W  = N6TEMP
    call XCRD(7)
    call XCRD(16)
!--

    if(ND.GE.0) then   ! CHECK IF WE HAVE UPDATED THE A AND B PARTS
        call XCRD(8)
        call XCRD(9) ! UPDATE THEIR DETAILS
    end if

    call XMONTR(-1)  ! write THE LIST TO THE DISC
    call XERT(IULN)
end if

STORE(M33V) = CYCNO      ! UPDATE THE DETAILS FOR LIST 33
STORE(M33V+1)=R
STORE(M33V+2)=RW
STORE(M33V+3)=0.
STORE(M33V+4)=AMINF

icom33=(/ l33cd,m33cd,md33cd,n33cd,l33sv,m33sv,md33sv,n33sv, &
&   l33st,m33st,md33st,n33st,l33ib,m33ib,md33ib,n33ib, &
&   l33v,m33v,md33v,n33v,l33cb,m33cb,md33cb,n33cb,ityp33 /)
call XWLSTD(33,ICOM33,IDIM33,-1,-1)   ! OUTPUT THE NEW LIST 33 TO DISC
if (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .NE. 0) call XFAL30
!djwoct09
if (SFLS_TYPE .EQ. SFLS_SCALE) then
!      update LIST 30 R and Rw values if only SCALE has been asked for
    STORE(L30RF+0 ) = R  
    STORE(L30RF+1 ) = RW
end if
if (KHUNTR (11,0, IADDL,IADDR,IADDD, -1) .EQ. 0) then
    STORE(L30RF+0 ) = R   ! 'REFINE' 
!djwmay07 L30GE is filled in ANALYSE and lets the user see the effect
!         of changing the thresholds.
!djwmay07        STORE(L30GE+10 ) = R  ! UPDATE LIST 30
    STORE(L30RF+1 ) = RW
!djwmay07        STORE(L30GE+11 ) = RW
    if(STORE(L11P+23) .GT.ZERO) STORE(L30RF+2 )=STORE(L11P+23)
    if (STORE(L11P+16) .GT. ZERO) then
        STORE(L30RF+4 ) = SQRT(AMINF / STORE(L11P+16))
    end if
    STORE(L30RF+8 ) = STORE(L11P+24)  ! NUMBER OF REFLECTIONS USED
!djwmay07        STORE(L30GE+9 ) = STORE(L11P+24)

!        if ( SFLS_TYPE .NE. SFLS_REFINE )  then
    STORE(L30RF+3) = S6SIG  ! SIGMA THRESHOLD FOR REFINEMENT
!djwmay07            STORE(L30GE+8) = S6SIG
!        end if

    STORE(L30IX+6) = RTD*ASIN(WAVE*SMIN)  ! STORE THETA LIMITS
    STORE(L30IX+7) = RTD*ASIN(WAVE*SMAX)

    ISTORE(L30RF+12 ) = NV + 2   ! REFINEMENT TYPE

end if


if( SFLS_TYPE .EQ. SFLS_CALC ) then  ! 'CALC' ONLY
    STORE(L30RF+0 ) = R
!djwmay07          STORE(L30GE+10 ) = R
    STORE(L30RF+1 ) = RW
!djwmay07          STORE(L30GE+11 ) = RW

    STORE(L30CF)=RALL(1)
    STORE(L30CF+1)=RALL(2)

    STORE(L30CF+4)=-10.
    STORE(L30CF+5)=RALL(7)

    if (RALL(4) .GT. ZERO) then
        STORE(L30CF+2) =100.* RALL(3)/RALL(4)
    end if
    if (RALL(6) .GT. ZERO) then
        STORE(L30CF+3) = 100.*SQRT(RALL(5)/RALL(6))
    end if

    if (RALL(9) .GT. ZERO) then
        STORE(L30CF+6) =100.* RALL(8)/RALL(9)
    end if
    if (RALL(11) .GT. ZERO) then
        STORE(L30CF+7) = 100.*SQRT(RALL(10)/RALL(11))
    end if

262          FORMAT (2X,I7,' reflections   R ',F5.2,'% Rw ',F5.2, &
    &   '% with I/u(I) from List 28')
6261          FORMAT (2X,I7,' reflections   R ',F5.2,'% Rw ',F5.2, &
    &   '% with I/u(I) >',F6.1)
6262          FORMAT (2X,I7,' reflections   R ',F5.2, &
    &   '% Rw ',F5.2,'% with I/u(I) from List 28')
    if (issprt .eq.0) write(ncwu,'(//)')
    call OUTCOL(6)
    write ( CMON, 6262) NT, MIN(99.99,STORE(L30RF)),MIN(99.99,STORE(L30RF+1))
    call XPRVDU(NCVDU, 1, 0)
    if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)

    write ( CMON, 6261) NINT(RALL(7)), MIN(99.99,STORE(L30CF+6)), &
    &   MIN(99.99,STORE(L30CF+7)), -10.0
    call XPRVDU(NCVDU, 1, 0)
    if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)

    write ( CMON, 6261) NINT(RALL(2)), MIN(99.99,STORE(L30CF+2)), &
    &   MIN(99.99,STORE(L30CF+3)), RALL(1)
    call XPRVDU(NCVDU, 1, 0)
    if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)
    call OUTCOL(1)
end if
icom30 = (/ l30dr,m30dr,md30dr,n30dr, l30cd,m30cd,md30cd,n30cd, & 
&   l30rf,m30rf,md30rf,n30rf, l30ix,m30ix,md30ix,n30ix, &
&   l30ab,m30ab,md30ab,n30ab, l30ge,m30ge,md30ge,n30ge, &
&   l30cl,m30cl,md30cl,n30cl, l30sh,m30sh,md30sh,n30sh, &
&   l30cf,m30cf,md30cf,n30cf /)
call XWLSTD ( 30, ICOM30, IDIM30, -1, -1)

call XRSL     ! CLEAR THE CORE
call XCSAE

if( SFLS_TYPE .EQ. SFLS_SCALE ) then   ! THE SCALE FACTOR HAS BEEN REFINED
    call XFAL05
    if ( IERFLG .LT. 0 ) return
    STORE(L5O)=SCALE
    J =NFL            ! SAVE SOME WORK SPACE
    I = KCHNFL(40)
    M5 = L5
    do I = 1, N5  ! Set occupancies
        if (IUPDAT .GE. 0) then
            IGSTAT=KSPGET(STORE(J), STORE(J+10), ISTORE(J+20), &
            &   STORE(J+30), MGM, M5, IUPDAT, NUPDAT)
        end if
        M5 = M5 + MD5
    end do
    NFL= J
    call XSTR05(LN5,-1,-1)
    call XRSL
    call XCSAE
end if
!djwjan05
FOAV = STORE(L6DTL+3*MD6DTL + 2)
FCAV = STORE(L6DTL+5*MD6DTL + 2)
rscle=foav/fcav
if (store(l30dr+7) .le. zero) then
    wscle = zero
else
    wscle = sqrt(1./store(l30dr+7))
endif
!djwsep09
istat = ksctrn (1,'sfls:rscale', rscle, 1)
istat = ksctrn (1,'sfls:scale',  scale, 1)
write(cmon,'(3(a,f7.3,3x))') 'SumFo/SumFc=', rscle, &
&   'SumFoFc/SumFc^2=', sfofc/sfcfc, &
&   'SumwFoFc/SumwFc^2=', wsfofc/wsfcfc, &
&   'LS-scale=', scale, &
&   'Wilson Scale=', wscle
if (min(scale, rscle)/max(scale,rscle) .lt. 0.8) then
    call outcol(9)
endif
call xprvdu(NCVDU,2,0)
if(issprt.eq.0) write(ncwu, '(a)') cmon(1)(:),cmon(2)(:)
call outcol(1)
delfofc = (foav-fcav*scale)
!RIC13:        write(cmon,'(a,f8.3,4x,a,f8.3)')'<Fo>-<Fc> = ', 
write(cmon,'(a,f8.3,4x,a,f8.2)')'<Fo>-<Fc> = ', &
&   delfofc/scale, &
&   '100*(<Fo>-<Fc>)/<Fo> = ',100.*delfofc/foav
call xprvdu(NCVDU,1,0)
if(issprt.eq.0) write(ncwu, '(a)') cmon(1)(:)
!djwjan05
!
!--PRINT THE TERMINATION MESSAGES
call XOPMSG(IOPSFS, IOPEND, IVERSN)
call XTIME2(1)

END

!CODE FOR XSFLSC
subroutine XSFLSC ( DERIVS, NDERIV, IRESULTS, NRESULTS, ierflg)
!$    use OMP_LIB
!--MAIN STRUCTURE FACTOR CALCULATION ROUTINE
!
!--USEAGE OF CONTROL VARIABLES :
!
!  JA      SET TO 1 FOR ISO ATOMS ONLY, else N2                           Changed to ISO_ONLY
!  JB      SET TO -1 FOR NO REFINEMENT, else 0 .                          Replaced by SFLS_TYPE
!  JC      SET TO -1 FOR ONLY CALCULATE COS, else 0                       REplaced by COS_ONLY
!  JD      SET TO -1 FOR CENTRO, else 0                                   Replaced by CENTRO
!  JE      SET TO -1 FOR NO ANOMALOUS DISPERSION, else 0                  Replaced by ANOMAL
!  JF      CURRENT VALUE OF JB, SET FOR EACH ATOM if JB=0                 Replaced by ATOM_REFINE
!  JG      SET TO -1 FOR NO PRINT, else THE NUMBER OF LINES BEFORE PAGE   Replaced by REFPRINT
!  JH      SET TO -1 if THE SCALE FACTOR IS NOT TO BE REFINED, else 0     Replaced by SFLS_TYPE

!  JJ      SET TO -1 if ONLY ISO-TERMS REQUIRED, else 0 (SIMILAR TO JA)   Removed (use ISO_ONLY)
!  JK      SET TO -1 if BOTH LEFT AND RIGHT HAND SIDES ARE NEEDED         Replaced by NEWLHS
!  JL      SET TO -1 if ENANTIOPOLE PARAMETER NOT USED, else 0            Replaced by ENANTIO

!  JI      CYCLE NUMBER                                                   Replaced by cycle_number

!  JN      DUMMY LOCATION FOR NON-REFINED PARAMETERS                      replaced by non_refined_param
!  JO      ADDRESS COMPLETE PARTIAL DERIVATIVES                           replaced by address_part_deriv_complete 
!  JP      LAST ADDRESS COMPLETE PARTIAL DERIVATIVES                      replaced by last_address_part_deriv_complete
!  JQ      NUMBER OF PARTIAL DERIVATIVES PER REFLECTION (0,1,2 OR 4)      replaced by num_part_deriv_per_refl
!  JR      ADDRESS PARTIAL DERIVATIVES BEFORE THEY ARE ADDED TOGETHER     replaced by address_part_deriv
!  LJS      WORK VARIABLE
!  JT      WORK VARIABLES USED DURING ACCUMULATION OF PARTIAL DERIVATIVE  Replaced by LJT
!  JU                                                                     Replaced by LJU
!  JV                                                                     Replaced by LJV
!  JW                                                                     Replaced by LJW
!  JX      LOOP VARIABLE FOR EQUIVALENT POSITIONS                         Replaced by LJX
!  JY      LOOP VARIABLE FOR ATOMS                                        Replaced by LJY
!  JZ                                                                     Replaced by LJZ
!
!  NA      SET TO -1 FOR NO EXTINCTION CORRECTION TO /FC/, else 0         Replaced by EXTINCT
!  NB      SET TO -1 FOR NO TWINNED DATA, else TO 0 OR 1.                 Replaced by TWINNED and SCALED_FOT
!          (0 MEANS PUT /FOT/ ETC. IN /FO/, WHILE 1 OR GREATER
!           MEANS PUT THE /FO/ AND /FC/ ETC. COMPUTED FOR THE
!           ELEMENT FOR WHICH THE INDICES ARE GIVEN).
!  NC      if GREATER THAN -1, then THE GIVEN PARTIAL CONTRIBUTIONS
!          ARE TO BE USED, else NOT.                                      Replaced by PARTIALS
!  ND      if SET TO -1, then NO NEW PARTIAL CONTRIBUTIONS ARE
!          OUTPUT. if GREATER THAN -1, THE NEW /FC/ ETC. ARE STORED
!          AS THE PARTIAL CONTRIBUTIONS.
!  NE      if GREATER THAN -1, then THE LAYER SCALES ARE APPLIED TO /FO/
!          else NOT.   Replaced by LAYERED
!  NF      if GREATER THAN -1, THE CONTRIBUTORS TO EACH TWINNED REFLECTI
!          ARE PRINTED.
!  JREF_STACK_START      ADDRESS OF THE WORD THAT HOLDS THE ADDRESS OF THE FIRST
!          BLOCK OF THE REFLECTION HOLDING STACK
!  JREF_STACK_PTR  USED TO PASS THROUGH THE REFLECTION HOLDING STACK (NH?)
!  NI      SIMILAR TO NH.
!  NJ      THE VALUE OF THE VARIABLE 'ELEMENTS' FOR EACH REFLECTION.
!  NK      CURRENT VALUE OF 'NJ' FOR EACH REFLECTION .
!  NL      THE ELEMENT OF THE CURRENT REFLECTION
!  NM      THE NUMBER OF REFLECTIONS IN THE STACK USED SO FAR
!  NN      SET TO 0 if NO NEW REFLECTIONS HAVE BEEN INTRODUCED,
!          else THE NUMBER OF NEW REFLECTIONS FOUND
!  NO      DUMP OF 'JO'
!  NP      DUMP OF 'JP'
!  NQ      COUNTER WHEN THE TWIN COMPONENTS ARE BEING COMBINED
!  NR      NUMBER OF WORDS PER SYMMETRY RELATED REFLECTION IN THE
!          REFLECTION HOLDING STACK.
!          THE FORMAT OF THE SYMMETRY RELATED REFLECTION ENTRIES IS :
!
!          0  H TRANSFORMED
!          1  K TRANSFORMED
!          2  L TRANSFORMED
!          3  THE PHASE SHifT FOR THIS GROUP OF INDICES
!
!  NT      THE NUMBER OF REFLECTIONS THAT HAVE BEEN USED
!  NU      -1 FOR XRAYS, AND 0 FOR NEUTRONS  -  ONLY USED FOR EXTINCTION
!  NV      -1 FOR REFINEMENT ON /FO/, else REFINEMENT ON /FO/ **2
!  NW      -1 FOR NO BATCH SCALE APPLICATION, else 0.       Replaced by BATCHED
!
!--THE FORMAT OF THE REFLECTION HOLDING STACK WHICH STARTS AT
!      'ISTORE(NG)' IS :
!
!   0  LINK TO NEXT REFLECTION OR -1000000
!   1  ADDRESS OF THE FIRST WORD OF THE DERIVATIVES W.R.T. /FC/
!   2  ADDRESS OF THE LAST WORD OF THE DERIVATIVES W.R.T. /FC/
!   3  H FOR THE CURRENT REFLECTION                                     
!   4  K FOR THE CURRENT REFLECTION
!   5  L FOR THE CURRENT REFLECTION (ALL IN FLOATING POINT).
!   6  /FC/ FOR THE CURRENT REFLECTION
!   7  PHASE FOR THE CURRENT REFLECTION
!   8  ELEMENT NUMBER WHICH THIS REFLECTION CURRENTLY REPRESENTS.
!   9  ADDRESS OF THE FIRST WORD OF THE FIRST GROUP OF
!      EQUIVALENT INDICES FOR  THIS BLOCK. (THE REFLECTIONS ARE
!      ARE EQUIVALENT TO THOSE INDICES GIVEN IN WORDS 3 TO 5).
!  10  ADDRESS OF THE LAST GROUP OF EQUIVALENT INDICES FOR THIS
!      REFLECTION BLOCK.
!      (EACH EQUIVALENT SET OF INDICES IS 'NR' WORDS LONG).
!  11  PHASE SHIFT NECESSARY FOR THE REFLECTION CURRENTLY USING THIS BLO
!  12  1.0 if FRIEDEL'S LAW HAS NOT BEEN USED FOR THE CURRENT REFLECTION
!  13  real PART OF A FOR THE ORIGINAL REFLECTION
!  14  IMAGINARY PART OF A FOR THE ORIGINAL REFLECTION
!  15  real PART OF B FOR THE ORIGINAL REFLECTION
!  16  IMAGINARY PART OF B FOR THE ORIGINAL REFLECTION
!  17  NOT USED
!  18  ADDRESS OF THE FIRST WORD OF THE DERIVATIVES W.R.T. A, B ETC.
!  19  ADDRESS OF THE LAST WORD OF THE DERIVATIVES W.R.T. TO A, B ETC.
!
!--THE DERIVATIVES FOLLOW THIS INFORMATION.
!
!--NORMALLY, WHEN EACH REFLECTION IS READ FROM THE DISC,
!  IT IS CHECKED AGAINST THOSE ALREADY IN THE STACK TO SEE if ITS
!  A AND B PARTS TOGETHER WITH THEIR DERIVATIVES ARE PRESENT.
!  if THEY ARE NOT PRESENT, then THESE VALUES ARE CALCULATED
!  AND THE INFORMATION SET UP IN THE BLOCK AT THE TOP OF THE STACK.
!  THIS CORRESPONDS TO THE ORIGINAL VALUES IN WORDS 13-16 AND IN THE
!  DERIVATIVES STORED FOR THE A AND B PARTS.
!  ONCE THE VALUES REQUIRED FOR THE CURRENT REFLECTION ARE PRESENT,
!  /FC/ AND ITS DERIVATIVES ARE CALCULATED.
!  (AT THIS STAGE, THE CURRENT REFLECTION MAY CORRESPOND TO THE ORIGINAL
!   REFLECTION OR MAY BE ONE OF ITS EQUIVALENTS FROM THE STACK).
!  THE DERIVATIVES ARE then ADDED TO THE NORMAL EQUATIONS, AFTER
!  MODifICATION FOR EXTINCTION AND REFINEMENT AGAINST /FO/ **2 IF
!  NECESSARY.
!
!--DURING THE PROCESSING OF ONE NOMINAL REFLECTION FOR A TWIN, THE STACK
!  IS SEARCHED FOR EACH ELEMENT IN TURN. if THE ELEMENT HAS
!  ALREADY BEEN CALCULATED, THE BLOCK IS MOVED TO THE TOP OF THE STACK
!  AND CONTROL PASSES TO THE NEXT COMPONENT. if THE ELEMENT OR
!  COMPONENT IS NOT IN THE STACK, THE LAST BLOCK IS SWITCHED TO
!  THE TOP OF THE STACK, AND then ITS A AND B PARTS WITH THEIR DERIVATIV
!  COMPUTED. AT THE END, THE ELEMENT FOR WHICH THE INDICES ARE GIVEN
!  IS LEFT AT THE TOP OF THE STACK AS THIS IS ALWAYS THE LAST
!  ELEMENT PROCESSED.
!  WHEN THE A AND B PARTS HAVE BEEN  FOUND FOR ALL THE ELEMENTS, /FC/
!  AND ITS DERIVATIVES ARE CALCULATED FOR EACH ELEMENT.
!  FOLLOWING THIS, /FCT/ AND ITS DERIVATIVES ARE CALCULATED, AND then AD
!  TO THE NORMAL EQUATIONS.
!
!      PARTIAL DERIVATIVE STACK
!                  FLACK SYMBOL
!      0   F.COS(HX)      A      AC
!      1   F.SIN(HX)      B      BC
!      2  -F".SIN(HX)    -D      ACI
!      3   F".COS(HX)     C      BCI
!
!      FC = (A-D) + I.(B+C)
!
!
!--THE FORMAT OF THE LIST 6 BUFFER AT 'M6' IS :
!
!   0  H
!   1  K
!   2  L (ALL IN FLOATING POINT).
!   3  /FO/
!   4  WEIGHT  -  realLY THE SQUARE ROOT OF THE WEIGHT
!   5  /FC/
!   6  PHASE
!   7  PARTIAL CONTRIBUTION FOR A.
!   8  PARTIAL CONTRIBUTION FOR B.
!   9  T-BAR  -  EXTINCTION TERM FOR THIS REFLECTION.
!  10  /FOT/  -  TOTAL /FO/ FOR A TWINNED STRUCTURE
!  11  THE ELEMENTS OF A TWINNED STRUCTURE.
!
!--USEAGE OF GENERAL VARIABLES
!
!  TC     COEFFICIENT FOR THE ISO-TEMPERATURE FACTORS
!  SST    SIN(THETA)/LAMBDA SQUARED
!  ST     SIN(THETA)/LAMBDA
!  SMAX, SMIN      MAX AND MIN VALUES OF SINTETA/LAMBDA
!  AC     TOTAL real A PART FOR THE REFLECTION
!  BC     TOTAL real B PART FOR THE REFLECTION
!  ACI    TOTAL IMAGINARY A PART FOR THE REFLECTION
!  BCI    TOTAL IMAGINARY B PART FOR THE REFLECTION
!  ACT    TOTAL A PART FOR THE RELFECTION
!  BCT    TOTAL B PART FOR THE REFLECTION
!  ACD    PARTIAL DERIVATIVE WITH RESPECT TO POLARITY PARAMETER
!  BCD    PARTIAL DERIVATIVE WRTO POLARITY PARAMETER
!  ACF    TOTAL PARTIAL DERIV WRTO POLARITY
!  ACN    TOTAL A PART FOR INVERSE STRUCTURE - USED IN ENANTIOPOLE REFIN
!  BCN    TOTAL B PART FOR INVERSE STRUCTURE - USED IN ENANTIOPOLE REFIN
!  ACE    PARTIAL DERIVATIVE FOR ENANTIOPOLE
!  ENANT  ENANTIOPOLE PARAMETER
!  ALPD    PARTIAL DERIVATIVES FOR  EACH ATOM WITH RESPECT TO A
!  BLPD    PARTIAL DERIVATIVES FOR  EACH ATOM WITH RESPECT TO B
!  FO     SCALED FO
!  FC     FC ON ABSOLUTE SCALE
!  P      PHASE ANGLE IN RADIANS
!  W      SQUARE ROOT OF THE WEIGHT FOR THIS RELFECTION
!  DF     DifFERENCE BETWEEN FO AND FC
!  WDF    WEIGHTED DifFERENCE BETWEEN FO AND FC
!  FOT    SUM OF FO
!  FCT    SUM OF FC
!  DFT    SUM OF MOD(DF)
!  AMINF  MINIMIZATION function - SUM WEIGHTED DifFERENCE SQUARED
!  WDFT   MINIMISATION function BASED ONLY ON /FO/.
!  RW     HAMILTON WEIGHTED R VALUE
!  R      NORMAL WEIGHTED R VALUE
!  COSP   COSINE OF THE PHASE ANGLE
!  SINP   SINE OF THE PHASE ANGLE
!  EXT    EXTINCTION PARAMETER (R*)  -  SEE LARSON IN C.C. 1970.
!  LAYER  THE INDEX OF THE CURRENT LAYER AS REQUIRED BY THE LAYER SCALES
!  IBATCH  THE BATCH OF THE CURRENT REFLECTION MINUS ONE.
!  FCEXT  FC CORRECTED FOR EXTINCTION EFFECTS.
!  FCEXS  FCEXT CORRECTED FOR THE SCALE FACTOR
!  EXT1   (1 + 2*(R*)* /FC/ **2*DELTA)
!  EXT2   (1 + (R*)* /FC/ **2*DELTA)
!  EXT3   EXT1/EXT2
!  WAVE   THE WAVELENGTH OF THE RADIATION USED TO COLLECT THE DATA
!  THETA1 THE MONOCHROMATOR BRAGG ANGLE
!  THETA2 THE ANGLE BETWEEN THE MONOCHROMATOR AND THE DifFRACTING PLANES
!  POL1   FIRST PART OF THE POLARISATION CORRECTION
!  POL2   THE SECOND PART OF THE POLARISATION CORRECTION
!  DEL    THE FIXED PART OF DELTA
!  DELTA  THE EXTINCTION MULTILPLIER  -  SEE LARSON.
!
!  PH, PK AND PL ARE A DUMP OF THE NOMINAL INDICES FOR A TWIN.
!
!  SH, SK AND SL ARE THE INDICES OF A TWINNED REFLECTION IN THE
!        STANDARD SETTING.
!
!--THE VARIOUS SCALE FACTORS USED ARE :
!
!  SCALEO  THE OVERALL SCALE FACTOR FROM LIST 5.
!          'SCALEO' IS ASSUMED NOT TO BE ZERO.
!  SCALEL  THE LAYER SCALE FACTOR FOR THE CURRENT LAYER  -  THIS
!          SCALE MAY BE ZERO if REQUIRED.
!  SCALEB  THE BATCH SCALE FACTOR FOR THE CURRENT REFLECTION  -  THIS
!          SCALE MAY BE ZERO if REQUIRED.
!  SCALES  THE SCALE FACTOR TO BE USED WHEN STORING /FC/.
!          THIS EQUALS SCALEL*SCALEB, SINCE 'SCALEO' IS NOT APPLIED TO /
!  SCALEG  THE COMBINED /FC/ SCALE FACTOR (=SCALEO*SCALEL*SCALEB).
!          'SCALEG' WILL BE ZERO if 'SCALEL' OR 'SCALEB' IS ZERO.
!  SCALEK  THE OVERALL /FO/ SCALE FACTOR (=1.0/SCALEG, UNLESS
!          'SCALEG' IS ZERO, WHEN 'SCALEK' IS SET TO 1.0).
!  SCALEW  SCALEG*W
!
!--if 'SCALEL' IS ZERO, ITS DERIVATIVE IS CALCULATED CORRECTLY,
!  BUT ALL OTHER DERIVATIVES FOR THAT REFLECTION WILL BE ZERO.
!
!
!--ALL DERIVATIVES ARE INTIALLY COMPUTED ON THE SCALE OF /FC/, AND then
!  ON THE CORRECT SCALE (THAT OF /FO/) WHEN THE A AND B PARTS ARE ADDED
!  TOGETHER AND THE WEIGHTS APPLIED.
!
!--THE DERIVATIVES FOR THE OVERALL SCALE FACTORS ARE COMPUTED SEPARATELY
!  OTHER OVERALL PARAMETERS.
!
!----- PARTIAL DERIVATIVE RELATIONSHIPS
!
!      FTSQ  = (1-X)*FP**2 + X*FN**2
!      where FPSQ is for the given index, and FNSQ for its Friedel inver
!
!      dFTSQ = 2*FP*(1-X)*dFP + 2*FN*X*dFN
!
!      dFT   = (FP/FT)*(1-X)*dFP   +    (FN/FT)*dFN
!
!            COSA := (1-X)*FP/FT,       SINA := X*FN/FT
!
!      FPSQ  = Q**2 + S**2,             FNSQ = QN**2 + SN**2
!
!      dFP   = (Q/FP)*dQ + (S/FP)*dS,   dFN   = (QN/FN)*dQN + (SN/FN)*dS
!
!           COSP := Q/FP, SINP := S/FP, COSPN := QN/FN, SINPN := SN/FN
!
!            Q = A-D, S = B+C,          QN = A+D, SN = -B+C
!
!            AC := A, ACI := -D, BC := B, BCI = C
!
!            ACT := Q, BCT := S,        ACN := QN, BCN := SN
!
!      dQ/dp = dA/dp - dD/dp,           dQN/dp =  dA/dp + dD/dp
!      dS/dp = dB/dp + dC/dp,           dSN/dp = -dB/dp + dC/dp

!include 'TYPE11.INC'
!include 'XSTR11.INC'
use xstr11_mod, only: str11 => xstr11
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store, istore, nfl
!include 'XSFWK.INC90'
use xsfwk_mod, only: r, p, s, w, rw, scale, scalew, scalek, ienprt, smin, smax
use xsfwk_mod, only: st, sst, theta1, theta2, tc, wdf, wave, rall, wdft, fo, fc
use xsfwk_mod, only: enant, df, d, cenant, c, bct, bcn, anom, aminf
use xsfwk_mod, only: act, acn, acf, ace, a
!include 'XWORKB.INC'
use xworkb_mod, only: nv, nu, nr, nt, nl, nf, nd, jr, jq, jp, jo, cycle_number=>ji
!include 'XSFLSW.INC90'
use xsflsw_mod, only: wsfofc, wsfcfc, sfofc, sfcfc
use xsflsw_mod, only: sfls_type, sfls_scale, sfls_refine, sfls_calc, cos_only, centro, batched
use xsflsw_mod, only: twinned, scaled_fot, refprint, partials, newlhs, layered, extinct
use xsflsw_mod, only: jref_stack_start, jref_stack_ptr
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu, ncfpu2, ncfpu1
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST01.INC90'
use xlst01_mod, only: l1p1
!include 'XLST02.INC90'
use xlst02_mod, only: n2p, m2p, l2p, ic, g2
!include 'XLST03.INC90' Not used!
!include 'XLST05.INC90'
use xlst05_mod, only: m5ls, m5es, m5bs, m5ls, l5o, l5ls, l5es, l5bs
!include 'XLST06.INC90'
use xlst06_mod!, only: m6, l6p, md6
!include 'XLST11.INC90'
use xlst11_mod, only: n11, l11r, l11
!include 'XLST12.INC90'
use xlst12_mod, only: n12b, n12, md12b, m12, l12o, l12ls, l12es, l12bs, l12b, md12a
!include 'XLST25.INC'
use xlst25_mod, only: n25, md25, m25, l25
!include 'XLST28.INC90'
use xlst28_mod, only: n28mn, md28mn, m28mn, l28mn
!include 'XLST33.INC90'
use xlst33_mod, only: m33cd
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
use xconst_mod, only: pi, zero, zerosq

implicit none

interface
    subroutine xab2fc(FC, P, act, bct, acn, bcn, ace, acf, store, istore, scalew, jp, jo, jref_stack_ptr, acd, bcd)
        implicit none
        real, intent(out) :: fc, p
        real, intent(inout) :: act, bct, acn, bcn, ace, acf
        real, intent(in) :: scalew, acd, bcd
        integer, intent(in) :: jp, jo, JREF_STACK_PTR
        real, dimension(:), intent(inout) :: store
        integer, dimension(:), intent(inout) :: istore
    end subroutine
end interface

interface
    subroutine XSFLSX(acd, bcd, ac, bc, nn, nm, tc, sst, smin, smax, nl, nr, jo, jp, g2, m12, md12a, store, istore)
        implicit none
        real, intent(out) :: ACD, BCD, tc, sst
        real, intent(inout) :: smin, smax, bc, ac, g2
        real, dimension(:), intent(inout) :: store
        integer, dimension(:), intent(inout) :: istore
        integer, intent(inout) :: nn, nm
        integer, intent(in) :: nl, nr, jo, jp
        integer, intent(out) :: m12, md12a
    end subroutine
end interface

interface
    subroutine XADDPD ( A, JX, JO, JQ, JR, md12a, m12, store, istore) 
        implicit none 
        real, intent(in) :: a
        integer, intent(in) :: jx, jo, jq, jr
        integer, intent(inout) :: md12a, m12
        integer, dimension(:), intent(in) :: istore
        real, dimension(:), intent(inout) :: store
    end subroutine
end interface

interface
    integer function klayernew(dummy, ierflg)
        implicit none 
        integer, intent(in) :: dummy
        integer, intent(out) :: ierflg
    end function
end interface

!include 'QSTORE.INC'
!include 'QSTR11.INC' equivalence not needed

!-C-C-AGREEMENT OF CONSTANTS AND VARIABLES
!-C-C-...FOR FLAG TO DECIDE BETWEEN KIND OF ATOM
!      real FLAG
!

integer, intent(in) :: nderiv, nresults
real, dimension(nderiv), intent(in) :: DERIVS
integer, dimension(NRESULTS), intent(in) :: IRESULTS  !Parameter list if there is one
integer, intent(out) :: ierflg

!
character(len=15) :: hkllab
character(len=256) :: formatstr
integer i, ibadr, iallow,  ibl, ibs, ifnr, ihkllen, ilevpr
integer ixap, ibatch, i28mn, jlever, jxap, jsort, ljs, ljt
integer lju, ljv, ljx, llever, lsort, ltempl, ltempr, msort
integer mnr, mlever, mdsort, mdleve, mb, layer, k, j, nsort
integer ntempl, nq, np, no, nlever, ntempr, nk, nj, n, mstr, ni
integer dummy
real pk, pii, ph, path, fot, scaleb, savsig, rlevnm, redmax, red
real rdjw, pol2, pol1, pl, sh
real g2sav, fcext, fcexs, ext4, ext3, ext2, ext1, ext
real dft, delta, del, foabs, fct, xvalur, xvalul, wj
real vj, uj, tix, time_begin, time_end, t, sl, sk, sfo, sfc
real scales, scaleq, scalel, scaleg, scaleo, rlevdn

integer, external :: klayer, kbatch, kallow, kfnr, kchnfl
real, external :: pdolev
real, dimension(5) :: tempr

! variable moved from common block to local
real acd, bcd, ac, bc
integer nm, nn
!
!
#if defined(_GIL_) || defined(_LIN_)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

! Accumulation is done is double precision to avoid precision loss
! single precision seems to introduce errors of about 1e-3 in Fc and 
! other parameters
double precision, dimension(:,:), allocatable :: designmatrix
double precision, dimension(:,:,:), allocatable :: normalmatrix!, ref
! tid is the number of threads
integer :: designindex, tid
integer, parameter :: designchunk=512, storechunk=512
character(len=4) :: buffer

real, dimension(:,:), allocatable :: tempstore
integer, dimension(:), allocatable :: batches, layers
integer tempstoremax, tempstorei
real, dimension(16) ::  minimum, maximum, summation, summationsq
integer iposn

ierflg = 0

!     Working out the number of threadings available
!     Using at most 6 of them
!     each thread has a chunk of reflections and a normal matrix
tid=1
!$    tid =  omp_get_max_threads() 

!     To be replaced by GET_ENVIRONMENT_VARIABLE f2003 feature
!     getenv is a deprecated extension      
call GETENV('OMP_NUM_THREADS', buffer) 
if(buffer/='    ') then
    read(buffer, '(I4)') i
    if(i>0) then
        tid=i
    end if
end if
tid=min(tid, 6)

#if defined(_GIL_) || defined(_LIN_)
print *, 'Number of threads used around DSYRK: ', tid
#endif

call CPU_TIME ( time_begin )

!------ SET MIN AND MAX SIN THETA/LAMBDA
SMAX=0.
SMIN=1./WAVE
!----- A BUFFER FOR ONE REFELCTION AND ITS R FACTOR
LTEMPR = NFL
NTEMPR = 7
NFL = KCHNFL(NTEMPR)
!----- INITIALISE THE SORT BUFFER
JSORT = -5
MDSORT = NTEMPR
NSORT = 30
call SRTDWN(LSORT,MDSORT,NSORT, JSORT, LTEMPR, XVALUR,0)
JSORT = 5 ! useless, if jsort<0, on return jsort is abs(jsort)


if (ISTORE(M33CD+12).NE.0) then    ! Leverage calc.
!----- A BUFFER FOR ONE REFELCTION AND ITS LEVERAGE
    LTEMPL = NFL
    NTEMPL = 7              ! Seven items to be stored: H,K,L,STL2,LEV,FO,FC
    NFL = KCHNFL(LTEMPL)    ! Make the space
!----- INITIALISE THE SORT BUFFER
    JLEVER = -5             ! Sort on the fifth item (NB: abs)
    MDLEVE = NTEMPL         ! Five items to be stored
    NLEVER = 30             ! Worst 30 reflections to be kept
    call SRTDWN(LLEVER,MDLEVE,NLEVER,JLEVER,LTEMPL,XVALUL,-1) ! Init
    JLEVER = 4              ! Sort on the fifth item (NB: offset)
    REDMAX = 0.0

    write(CMON,'(A,6(/,A))') &
    &   '^^PL PLOTDATA _LEVP SCATTER ATTACH _VLEVP', &
    &   '^^PL XAXIS TITLE ''k x Fo'' NSERIES=2 LENGTH=2000', &
    &   '^^PL YAXIS TITLE ''Leverage, Pii'' ZOOM 0.0 1.0', &
    &   '^^PL YAXISRIGHT TITLE ''tij**2/(1+Pii)''', &
    &   '^^PL SERIES 1 TYPE SCATTER SERIESNAME ''Leverage''', &
    &   '^^PL SERIES 2 TYPE SCATTER', &
    &   '^^PL SERIESNAME ''Influence of remeasuring'' USERIGHTAXIS'
    call XPRVDU(NCVDU, 7,0)

end if

!----- SET PRINT COUNTER
IENPRT = -1
ILEVPR = 0
!----- SET BAD R FACTOR COUNTER
IBADR = -1
!--INITIALISE THE TIMING function
CENTRO = .FALSE.
if ( IC .EQ. 1 ) CENTRO = .TRUE.
!      JD=-IC
D=180.0/PI
COS_ONLY = .FALSE.

if(CENTRO)THEN        ! CHECK IF THIS STRUCTURE IS CENTRO
    if (SFLS_TYPE .NE. SFLS_REFINE) then  ! CHECK IF WE ARE DOING REFINEMENT
        COS_ONLY = .TRUE.  ! CENTRO WITH NO REFINEMENT  -  ONLY COS TERMS NEEDED
    end if
end if

!--CLEAR THE VARIABLES FOR HOLDING THE OVERALL TOTALS
!----- GET THE OLD R FACTOR AND SET PRINT RATIO
R = STORE(L6P+1) * .01 *3.
RW=0.0
FOABS = 0.0
FOT=0.0
FCT=0.0
DFT=0.0
WDFT=0.0
AMINF=0.
SFO=0.0
SFC=0.0
sfofc=0.0
sfcfc=0.0
wsfofc=0.0
wsfcfc=0.0
NT=0
ACE=0.
ACF = 0.
!----- OVERALL SCALE
SCALEO=STORE(L5O)
!----- ENANTIOPOLE PARAMETER
ENANT = STORE(L5O+4)
CENANT  =  (1.- ENANT)
!----- POLARITY PARAMETER
ANOM = STORE(L5O+3)
!--SET UP THE EXTINCTION VARIABLE
EXT=0.
EXT1=1.0
EXT2=1.0
EXT3=1.0
DELTA=0.

if(EXTINCT)THEN   ! THE EXTINCTION PARAMETER IN LIST 5 SHOULD BE USED
    EXT=STORE(L5O+5)
    POL1=1.
    POL2=0.
    DEL=WAVE*WAVE/(STORE(L1P1+6)*STORE(L1P1+6))
    if(NU.LT.0) then   ! CHECK IF WE ARE USING NEUTRONS OR XRAYS
!--WE ARE USING XRAYS
        DEL=DEL*WAVE*0.0794
!  SET UP THE POLARISATION CONSTANTS
        THETA2=THETA2/D !  D converts from degrees to radians
        A=COS(THETA2)
        C=SIN(THETA2)
        S=COS(THETA1/D)
        A=A*A
        C=C*C
        S=S*S
        POL1=A+C*S
!djwoct2010 POL2 had found itself outside of the if clause
        POL2=C+A*S
    end if
end if

!--CHECK if A PRINT IS REQUIRED
if(REFPRINT) then 
    if (ISSPRT .EQ. 0)  write(NCWU,1750)
1750      FORMAT(/7X,'H',5X,'K',5X,'L',6X,'/FO/',5X,'/FC/',4X,'Phase', &
    &   5X,'Delta    SQRT(W)*Delta',2X,'/FC''/',2X,'/FC''''/', &
    &   2X,'D/F/ **2', 1X,'T.B.R.(%)',2X,'SINTH/L/')
end if

NO=JO
NP=JP
allocate(normalmatrix(JP-JO+1,JP-JO+1, tid))
!allocate(ref(JP-JO+1,JP-JO+1))
normalmatrix=0.0
!ref=0.0
designindex=0
! size of the design matrix chunk to be tuned (PP)
allocate(designmatrix(JP-JO+1,designchunk*tid))
designmatrix=0.0

#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)
#endif

allocate(tempstore(storechunk, MD6))
allocate(layers(storechunk))
allocate(batches(storechunk))

layers=-1 ! SET THE LAYER SCALING CONSTANTS INITIALLY
batches=-1
do tempstorei=1, storechunk
    if( SFLS_TYPE .EQ. SFLS_CALC ) then
    ! Remove I/sigma(I) cutoff, temporarily, leaving all other filters
    ! in place.
        do I28MN = L28MN,L28MN+((N28MN-1)*MD28MN),MD28MN
            if(ISTORE(I28MN)-M6.EQ.20) then
                SAVSIG = STORE(I28MN+1)
                STORE(I28MN+1) = -99999.0
            end if
        end do
    ! Fetch reflection using all other filters:
        ifNR = KFNR(1)
    ! Put sigma filter back:
        do I28MN = L28MN,M28MN,MD28MN
            if(ISTORE(I28MN)-M6.EQ.20) then
                STORE(I28MN+1) = SAVSIG
            end if
        end do
    else
        ifNR = KFNR(1)
    end if
    if(ifnr>=0) then
        tempstore(tempstorei,:)=STORE(M6:M6+MD6-1)

        if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
            layers(tempstorei)=KLAYERnew(dummy, ierflg)  ! FIND THE LAYER NUMBER AND SET ITS VALUE
            if ( IERFLG .LT. 0 ) return ! GO TO 19900
        end if    
    
        if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
            batches(tempstorei)=KBATCH(dummy)  ! FIND THE BATCH NUMBER AND SET THE SCALE
            if ( IERFLG .LT. 0 ) return !GO TO 19900
        end if    
    
    else
        exit
    end if
end do
tempstoremax=tempstorei-1
if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
    layers=layers+L5LS-1
end if
if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
    batches=batches+m5bs-1
end if
    
    
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!Begin big loop
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
minimum=huge(minimum)
maximum=-huge(maximum)
summation=0.0
summationsq=0.0
if(ND<0)THEN
    minimum(8:9)=0.0
    maximum(8:9)=0.0
end if
      
do WHILE (tempstoremax>0)  ! START OF THE LOOP OVER REFLECTIONS

!!$OMP PARALLEL default(none) 
!!$OMP& shared(nP, nO, tid, M6, MD6, l6dtl, md6dtl, L5LS, layered, batched,twinned, JREF_STACK_START,scaleg) 
!!$OMP& firstprivate(store)
!!$OMP& private(designmatrix, M5LS, layer, scalel, ibatch, scaleb, ierflg)
!!$OMP& private(scalek,scales,act,bct,acn,bcn,fo,fc,scalew,jp,jo,nl)
!!$OMP& private(JREF_STACK_PTR)
!!$OMP& reduction(+: normalmatrix, summation, summationsq)
!!$OMP& reduction(min: minimum), reduction(max:maximum)


!!$OMP DO schedule(static)
    do tempstorei=1, tempstoremax
    STORE(M6:M6+MD6-1)=tempstore(tempstorei,:)
    !print *, STORE(M6:M6+MD6-1)

    if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
        M5LS=layers(tempstorei)
        SCALEL=STORE(M5LS)
    else
        SCALEL=1.0
    end if

    if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
        M5BS=batches(tempstorei)
        SCALEB=STORE(M5BS)
    else
        scaleb=1.0
    end if

    SCALEK=1.   ! SET UP THE SCALE FACTORS CORRECTLY
    SCALES=SCALEL*SCALEB
    SCALEG=SCALEO*SCALES

    if(SCALEG .GT. 1e-6) then   ! CHECK IF THE SCALE IS ZERO
        SCALEK=1./SCALEG   ! THE /FC/ SCALE FACTOR IS NOT ZERO  -  COMPUTE THE /FO/ SCALE FACTOR
    end if

!--CLEAR THE PARTIAL CONTRIBUTION FLAGS FOR THIS REFLECTION
    ACT=0.0
    BCT=0.0
    ACN = 0.
    BCN = 0.
!--CHECK if THE PARTIAL CONTRIBUTIONS ARE TO BE ADDED IN
    if(PARTIALS) then 
        ACT=STORE(M6+7)
        BCT=STORE(M6+8)
        ACN = ACT
        BCN = BCT
    end if

    FO=STORE(M6+3)  ! SET UP /FO/ ETC. FOR THIS REFLECTION
    W=STORE(M6+4)
    SCALEW=SCALEG*W
 
    NM=0  ! INITIALISE THE HOLDING STACK, DUMP ENTRIES
    NN=0
    JO=NO  ! Point JO back to beginning of PD list.
    JP=NP

!       CHECK if THIS IS TWINNED CALCULATION
    if(.NOT.TWINNED)THEN   ! NOT TWINNED
        NL=0
        call XSFLSX(acd, bcd, ac, bc, nn, nm, tc, sst, smin, smax, nl, nr, jo, jp, g2, m12, md12a, store, istore)
        JREF_STACK_PTR=ISTORE(JREF_STACK_START)
        call XAB2FC(FC, P, act, bct, acn, bcn, ace, acf, store, istore, scalew, jp, jo, jref_stack_ptr, acd, bcd)  ! DERIVE THE TOTALS AGAINST /FC/ FROM THOSE W.R.T. A AND B
        call XACRT(4, minimum, maximum, summation, summationsq, 16)  ! ACCUMULATE THE /FO/ TOTALS
    else ! THIS IS A TWINNED CALCULATION  
        PH=STORE(M6)  ! PRESERVE THE NOMINAL INDICES
        PK=STORE(M6+1)
        PL=STORE(M6+2)
        NJ=NINT(STORE(M6+11))
        if (NJ .EQ. 0) NJ = 12 ! IF THERE IS NO ELEMENT KEY, SET IT TO MOROHEDRAL TWINNING
        NK=NJ  ! FIND THE ELEMENT FOR WHICH THE INDICES ARE GIVEN  (LEFT-MOST VALUE)
        do WHILE ( NK .GT. 0 ) 
            NL=NK
            NK=NK/10
            LJX=NL-NK*10
            if(LJX<=0 .or. (LJX>0 .and. LJX>N25)) then ! GO TO 19910    
            ! CHECK THAT THIS IS A 
! -- INCORRECT ELEMENT NUMBER
                formatstr="(1X,I5,' is an incorrect element number for reflection ',3F5.0)"
                if (ISSPRT .EQ. 0) write(NCWU, formatstr ) LJX , PH , PK , PL
                write(CMON, formatstr) LJX , PH , PK , PL
                call XPRVDU(NCVDU, 1,0)
                call XERHND ( IERERR )
                return
            end if                  
        end do
! CHECK if 'NL' HOLDS THE ELEMENT NUMBER OF THE GIVEN INDICES.
!  Generate the principal indices (Why?)
!          M25I=L25I+(NL-1)*MD25I  ! COMPUTE THE INDICES IN THE STANDARD REFERENCE SYSTEM
!          SH=STORE(M25I)*PH+STORE(M25I+1)*PK+STORE(M25I+2)*PL
!          SK=STORE(M25I+3)*PH+STORE(M25I+4)*PK+STORE(M25I+5)*PL
!          SL=STORE(M25I+6)*PH+STORE(M25I+7)*PK+STORE(M25I+8)*PL
        sh=ph
        sk=pk
        sl=pl
!      write(ncawu,'(i4,6x,3f4.0, 6x, 3f4.0)') nl, ph, pk, pl, sh,sk,sl
!  For centred cells, CRYSTALS used the optimisation page 45 Rollett which
!  adds together the contributions to A from atoms at x and x+1/2 
!  (ie multiplies A by 2)
!  For a systematic absence it should subtract the contribution from x+1/2, 
!  ie A=0 etc.
!  As originally written, the program gets FC > 0 for absences.
!  This should not matter for untwinned crystals, since the absences should 
!  have been removed.
!  For twins, the second component may overlap with a systematic absence 
!  from the first component so we must check for this an ensure the 
!  contribution from the first is zero.
!
        NK=NJ  ! RESET THE FLAGS FOR THIS GROUP OF TWIN ELEMENTS, e.g. 1234
        do WHILE ( NK .GT. 0 ) ! CHECK if THERE ARE ANY MORE ELEMENTS TO PROCESS
            if (nj .gt.9) then
                LJX=NK      ! FETCH THE NEXT ELEMENT, STARTING AT RIGHT HAND SIDE
                NK=NK/10                                           ! e.g. 123
                NL=LJX-NK*10                                        ! e.g. 1234-1230 = 4
                M25=L25+(NL-1)*MD25   ! COMPUTE THE INDICES FOR THIS COMPONENT
                STORE(M6)=ANINT(STORE(M25)*SH+STORE(M25+1)*SK+STORE(M25+2)*SL)
                STORE(M6+1)=ANINT(STORE(M25+3)*SH+STORE(M25+4)*SK+STORE(M25+5)*SL)
                STORE(M6+2)=ANINT(STORE(M25+6)*SH+STORE(M25+7)*SK+STORE(M25+8)*SL)
                if ( NM .GE. N25 ) then ! GO TO 19920  ! WE HAVE USED TOO MANY ELEMENTS
                    formatstr="(1X,'Too many elements given for reflection ', 3F5.0 )"
                    if (ISSPRT .EQ. 0) write(NCWU, formatstr) PH, PK , PL
                    write ( CMON , formatstr ) PH , PK , PL
                    call XPRVDU(NCVDU, 1,0)
                    call XERHND ( IERERR )
                    return ! GO TO 19900
                end if
                
            else
               nl=nj
               nk = 0
               store(m6) = sh
               store(m6+1) = sk
               store(m6+2) = sl
            endif
!
!  save the multiplier 
            g2sav = g2
!  check if the current reflection is a centring absence
            if(N2P .gt. 1)then
!           CHECK NON-PRIMITIVE CONDITIONS
                M2P=L2P
                do I=1,N2P
                    A=ABS(STORE(M2P)*store(m6)+ &
                    &   STORE(M2P+1)*store(m6+1)+ &
                    &   STORE(M2P+2)*store(m6+2))
                    K=INT(A+0.01)
                    if(A-FLOAT(K).gt.0.01) then
                        g2 = 0.0
                        exit
                    endif
                    M2P=M2P+3
                enddo
            endif

!      write(ncpu,9753)'Given', ph,pk,pl, 'Transformed', store(m6),
!     1 store(m6+1),store(m6+2), g2, store(m6+3),a,k
!9753  format(a,3f8.2,2x,a,3f8.2, '  G2,Fo,A,K ', 3f12.2,i5)
!
            call XSFLSX(acd, bcd, ac, bc, nn, nm, tc, sst, smin, smax, nl, nr, jo, jp, g2, m12, md12a, store, istore)  ! ENTER THE S.F.L.S MAIN LOOP. G2 may be zero
            g2 = g2sav
        END do  ! END OF THIS TWINNED REFLECTION  
!
!
!
        store(m6)=ph  ! restore the nominal indices
        store(m6+1)=pk
        store(m6+2)=pl
!
        FCEXT=0.  !  WIND UP AND CALCULATE THE TOTAL VA
        JREF_STACK_PTR=JREF_STACK_START  ! CALCULATE /FC/ AND ITS DERIVATIVES FOR EACH ELEMENT
        NQ=NM
    
        do WHILE ( NQ .GT. 0 )  ! ACCESS THE NEXT ELEMENT IN THE STACK
            JREF_STACK_PTR=ISTORE(JREF_STACK_PTR)
!--COMPUTE THE TOTALS AGAINST /FC/ FOR THIS ELEMENT
            ACT=0.  ! CLEAR THE PARTIAL CONTRIBUTIONS
            BCT=0.
            JO=ISTORE(JREF_STACK_PTR+1)  ! SET THE POINTER FOR THE DERIVATIVES WITH RESPECT TO /FC/
            JP=ISTORE(JREF_STACK_PTR+2)
  
            call XAB2FC(FC, P, act, bct, acn, bcn, ace, acf, store, istore, scalew, jp, jo, jref_stack_ptr, acd, bcd)   ! CONVERT A AND B PARTS TO FC

            NI=ISTORE(JREF_STACK_PTR+8) ! ACCUMULATE /FCT/
            ISTORE(JREF_STACK_PTR+8)=ISTORE(JREF_STACK_PTR+8)-1
            LJU=L5ES+ISTORE(JREF_STACK_PTR+8)
            LJV=M5ES+ISTORE(JREF_STACK_PTR+8)
            FCEXT=FCEXT+STORE(LJU)*STORE(JREF_STACK_PTR+6)*STORE(JREF_STACK_PTR+6)

            if(NF.GE.0 .and. NM.GT.1) then  ! CHECK IF WE MUST PRINT THIS CONTRIBUTOR
                                            ! CHECK if THERE IS MORE THAN ONE CONTRIBUTOR
                if(NQ.EQ.NM)THEN  ! CHECK IF THIS IS THE FIRST CONTRIBUTOR
                    if (ISSPRT .EQ. 0) write(NCWU,3350)
                end if
!--PRINT THIS CONTRIBUTOR
                LJS=JREF_STACK_PTR+3
                A=STORE(JREF_STACK_PTR+7)*D
                C=STORE(JREF_STACK_PTR+6)*STORE(LJV)
                if (ISSPRT .EQ. 0) then
                    write(NCWU,3350) (STORE(LJT+3),LJT=JREF_STACK_PTR,LJS),A,C,NI
                end if
3350                  FORMAT(3X,3F6.0,9X,2F9.1,22X,F12.1,I4)
            end if
            NQ=NQ-1  ! UPDATE THE NUMBER OF ELEMENTS LEFT TO PROCESS
        end do

        FC=SQRT(FCEXT)  ! COMPUTE THE OVERALL /FCT/ VALUE
        JO=NO
        JP=NP

        if(.NOT.SCALED_FOT) then  ! WHICH TYPE OF /FO/ AND /FC/ WE ARE TO OUTPUT
!           SAVE THE TOTAL OVER ALL ELEMENTS
            STORE(M6+3)=STORE(M6+10)
            STORE(M6+5)=FC
            STORE(M6+6)=0.
        else
!           SAVE THE VALUE FOR THE MAIN ELEMENT
            JREF_STACK_PTR=ISTORE(JREF_STACK_START) 
            LJV=ISTORE(JREF_STACK_PTR+8)+M5ES
            STORE(M6+3)=STORE(M6+10)*STORE(JREF_STACK_PTR+6)*STORE(LJV)/FC
            STORE(M6+5)=STORE(JREF_STACK_PTR+6)*STORE(LJV)
            STORE(M6+6)=STORE(JREF_STACK_PTR+7)
        end if
        FO=STORE(M6+10)      
        STORE(M6+5)=STORE(M6+5)*SCALES
!          P=0. !cdjwjul2010 why set P to zero? Should it be M6+6?
        p=store(m6+6)
        call XACRT(4, minimum, maximum, summation, summationsq, 16)  ! ACCUMULATE THE /FO/ TOTALS
        if (SFLS_TYPE .EQ. SFLS_REFINE) then ! CHECK IF WE ARE DOING REFINEMENT
            STORE(JO:JP)=0. ! CALCULATE THE NECESSARY P.D.'S WITH RESPECT TO /FCT/.
            JREF_STACK_PTR=JREF_STACK_START  
            do LJU=1,NM ! PASS AMONGST THE VARIOUS CONTRIBUTORS
                JREF_STACK_PTR=ISTORE(JREF_STACK_PTR) ! FIND THE ADDRESS OF THIS CONTRIBUTOR
                LJV=ISTORE(JREF_STACK_PTR+8)+L5ES
                A=STORE(JREF_STACK_PTR+6)*STORE(LJV)/FC
                LJS=ISTORE(JREF_STACK_PTR+1)
                N = JP - JO 
                STORE(JO:JP)=STORE(JO:JP) + STORE(LJS:LJS+N)*A  ! ADD IN THE DERIVATIVES
            end do

            M12=L12ES ! ADD IN THE CONTRIBUTIONS FOR THE ELEMENT SCALE FACTORS
            JREF_STACK_PTR=JREF_STACK_START
            do NI=1, NM ! WHILE ( NI.GT.0 ) ! CHECK if THERE ANY MORE SCALES TO PROCESS
!               FETCH THE INFORMATION FOR THE NEXT ELEMENT SCALE FACTOR
                JREF_STACK_PTR=ISTORE(JREF_STACK_PTR)
                LJX=ISTORE(JREF_STACK_PTR+8)
                A=0.5*SCALEW*STORE(JREF_STACK_PTR+6)*STORE(JREF_STACK_PTR+6)/FC
                call XADDPD ( A, LJX, JO, JQ, JR, md12a, m12, store, istore) 
            end do
        end if
    end if  ! end of twinned calculations
!--FINISH OFF THIS REFLECTION  
!
!--CHECK if WE SHOULD include EXTINCTION
    if(EXTINCT)THEN ! WE SHOULD include EXTINCTION
        A=MIN(1.,WAVE*sqrt(sST))
        !A=ASIN(A)*2.
        PATH=STORE(M6+9)  ! CHECK MEAN PATH LENGTH
        if(PATH.LE.ZERO) PATH = 1.
        !DELTA=DEL*PATH/SIN(A)  ! COMPUTE DELTA FOR NEUTRONS
        ! sin(a) = sin(sin-1(a)*2.0) (see above)
        ! equivalent to 2*a*sqrt(1-a**)
        DELTA=DEL*PATH/(2.0*a*sqrt(1.0-a**2))
        if(NU.LT.0)THEN ! WE ARE USING XRAYS
            ! cos(a) = cos(sin-1(a)*2.0) (see above)
            ! equivalent to 1-2a**2
            !A=COS(A)**2
            A=1.0-2.0*a**2
            DELTA=DELTA*(POL1+POL2*A*A)/(POL1+POL2*A)
        end if
        EXT1=1.+2.*EXT*FC*FC*DELTA
        EXT2=1.0+EXT*FC*FC*DELTA
        EXT3=EXT2/(EXT1**(1.25))
        EXT4=(EXT1**(-.25))
        FCEXT=FC*EXT4   ! COMPUTE THE MODifIED /FC/
    else
        EXT4=1.
        FCEXT=FC
    end if
!
    FCEXS=FCEXT*SCALEG ! THE VALUE OF /FC/ AFTER SCALE FACTOR APPLIED

!

    if(TWINNED)THEN 
        STORE(M6+5)=STORE(M6+5)*EXT4*SCALES
    else
        STORE(M6+5)=FCEXT*SCALES ! STORE FC AND PHASE IN THE LIST 6 SLOTS
    end if
    STORE(M6+6)=P
!
    if(ND.GE.0)THEN ! CHECK IF THE PARTIAL CONTRIBUTIONS ARE TO BE OUTPUT
        STORE(M6+7)=ACT ! STORE THE NEW CONTRIBUTIONS
        STORE(M6+8)=BCT
        call XACRT(8, minimum, maximum, summation, summationsq, 16)  ! ACCUMULATE THE TOTALS FOR THE NEW PARTS
        call XACRT(9, minimum, maximum, summation, summationsq, 16)
    end if

!        A=FO*W    ! ADD IN THE COMPUTED VALUES OF /FC/ ETC., TO THE OVERALL TOTALS
! Add abs to deniminator
    A=abs(FO)*W    ! ADD IN THE COMPUTED VALUES OF /FC/ ETC., TO THE OVERALL TOTALS
    DF=FO-FCEXS
    WDF=W*DF
    S=SCALEK
!
    if(NV.GE.0)THEN ! 4500,4450,4450 ! CHECK IF WE REFINING AGAINST /FO/ **2
!          A=ABS(FO)*FO*W  ! COMPUTE W-DELTA FOR /FO/ **2 REFINEMENT
! remove abs Mar2009
        A=FO*FO*W  ! COMPUTE W-DELTA FOR /FO/ **2 REFINEMENT
        DF=ABS(FO)*FO-FCEXS*FCEXS
        WDF=W*DF
        S=SCALEK*SCALEK
    end if
    AMINF=AMINF+WDF*WDF  ! COMPUTE THE MINIMISATION function

    if ((SFLS_TYPE.NE.SFLS_CALC) .OR.(KALLOW(IALLOW).GE.0)) then
! If #CALC, then L28 was adjusted earlier. Call KALLOW again to get normal R
        NT=NT+1     ! UPDATE THE REFLECTION COUNTER FLAG
        FOT=FOT+FO   ! COMPUTE THE TERMS FOR THE NORMAL R-VALUE
        FOABS = FOABS + ABS(FO)
        FCT=FCT+FCEXS
        DFT=DFT+ABS(ABS(FO) - FCEXS)
        WDFT=WDFT+WDF*WDF  ! COMPUTE THE TERMS FOR THE WEIGHTED R-VALUE
        RW=RW+A*A
        sfofc = sfofc + fo * fcext
        sfcfc = sfcfc + fcext * fcext
        wsfofc = wsfofc + w * fo * fcext
        wsfcfc = wsfcfc + w * fcext * fcext
    end if
!
!
    UJ=FO*SCALEK
    RDJW = ABS(WDF)
    if (RDJW .GT. ABS(XVALUR)) then
!----  H,K,L,FO,FC,/WDELTA/,FO/FC
        call XMOVE(STORE(M6), STORE(LTEMPR), 3)
        STORE(LTEMPR+3) = UJ
        STORE(LTEMPR+4) = FCEXT
        STORE(LTEMPR+5) = RDJW
        STORE(LTEMPR+6) = MIN(99., UJ / MAX(FCEXT , ZERO))
        call SRTDWN(LSORT,MDSORT,NSORT, JSORT, LTEMPR, XVALUR, 0)
    end if
  
    if(REFPRINT)THEN !   CHECK IF A PRINT OF THE RELFECTIONS IS NEEDED
        P=P*D             ! PRINT ALL REFLECTIONS
        VJ=WDF*S
        WJ=DF*S
        !A=SQRT(AC*AC+BC*BC)
        A=SQRT(STORE(JREF_STACK_PTR+13)**2+STORE(JREF_STACK_PTR+15)**2)
        !S=SQRT(ACI*ACI+BCI*BCI)
        S=SQRT(STORE(JREF_STACK_PTR+14)**2+STORE(JREF_STACK_PTR+16)**2)
        T=4.*( STORE(JREF_STACK_PTR+15)*STORE(JREF_STACK_PTR+16) + &
        &   STORE(JREF_STACK_PTR+13)*STORE(JREF_STACK_PTR+14) )
        C=T*200.0/(2.*FC*FC-T)
        if (ISSPRT .EQ. 0) then 
            write(NCWU,4600)STORE(M6),STORE(M6+1),STORE(M6+2),UJ,FCEXT,P,WJ,VJ,A,S,T,C,sqrt(sST)
        end if
4600    FORMAT(3X,3F6.0,3F9.1,E13.4,E13.4,F8.1,F8.1,F9.1,F10.1,F10.5)
!
    else   ! Only print worst 25 agreements.
        if ( ABS(UJ-FCEXT) .GE. R*UJ .AND. IBADR .LE. 50 ) then
            if (IBADR .LT. 0) then
                if (ISSPRT .EQ. 0) write(NCWU,4651)
                    IBADR = 0
4651                FORMAT(10X,' Bad agreements ',/ &
                    &   /1X,'   h    k    l      Fo        Fc '/)
                else if (IBADR .LT. 25) then
                    if (ISSPRT .EQ. 0) then
                        write(NCWU,4652)STORE(M6),STORE(M6+1),STORE(M6+2),UJ,FCEXT
                    end if
4652                FORMAT(1X,3F5.0,2F9.2)
                    else if (IBADR .EQ. 25) then
                        if (ISSPRT .EQ. 0) write(NCWU,4653)
4653                    FORMAT(/' And so on ------------'/)
                    end if
                    IBADR = IBADR + 1
                end if
            end if

            if(SFLS_TYPE .NE. SFLS_REFINE)THEN    ! NO REFINEMENT
                if(SFLS_TYPE .EQ. SFLS_SCALE)THEN ! CHECK IF WE ARE REFINING ONLY THE SCALE FACTOR
 
!--COMPUTE THE TOTALS FOR REFINEMENT OF THE SCALE FACTOR ONLY
                    A=W*SCALES*FCEXT
                    if(NV.GE.0) A=A*SCALES*FCEXT  ! IF WE ARE REFINING AGAINST /FO/ **2

! Originally, CRYSTALS computed the scale wrt F, but this is non-linear,
! so convergence was poor. Now the shifts are wrt F**2. This is taken car
! of when the shift is applied. See near label 6100.

                    SFO=SFO+WDF*A   ! ACCUMULATE THE TERMS FOR THE SCALE FACTOR
                    SFC=SFC+A*A
                end if
            else

!--ADD THE CONTRIBUTIONS OF THE OVERALL PARAMETERS AND SCALE FACTORS.
!  THESE ARE COMPUTED WITH RESPECT TO 'FC' MODifIED FOR EXTINCTION, RATH
!  THAN WITH RESPECT TO 'FC'. THIS IS WHY THEY ALL CONTAIN '1./EXT3'
!  TERM WHICH IS REMOVED LATER WHEN THE DERIVATIVES ARE MODifIED FOR
!  EXTINCTION. THE FIRST PARAMETER IS THE OVERALL SCALE FACTOR.

            A=W*FCEXT*SCALES/EXT3

!---- TO REFINE SCALE OF F**2 (RATHER THAN F), SQUARE AND
!      TAKE OUT THE CORRECTION FACTOR TO BE APPLIED LATER, NEAR LABEL 5300

            if(NV .GE. 0) A = A * FCEXT * SCALES / ( 2. * FCEXS )
            LJX=0
            M12=L12O
            call XADDPD ( A, 0, JO, JQ, JR, md12a, m12, store, istore) 

            A=W*FCEXS*TC/EXT3       ! OVERALL TEMPERATURE FACTORS NEXT
            call XADDPD ( A, 1, JO, JQ, JR, md12a, m12, store, istore) 
            call XADDPD ( A, 2, JO, JQ, JR, md12a, m12, store, istore) 
 
            call XADDPD ( ACF, 3, JO, JQ, JR, md12a, m12, store, istore)   ! THE POLARITY PARAMETER

            call XADDPD ( ACE, 4, JO, JQ, JR, md12a, m12, store, istore)  ! THE ENANTIOPOLE PARAMETER - HOWARD FLACK ACTA 1983,A39,876

            A=-0.5*SCALEW*FC*FC*FC*DELTA/EXT2   ! NOW THE EXTINCTION PARAMETER DERIVED BY LARSON
            call XADDPD ( A, 5, JO, JQ, JR, md12a, m12, store, istore) 
 
            if(LAYER.GE.0) then                 ! CHECK IF LAYER SCALES ARE BEING USED
                A=W*SCALEO*SCALEB*FCEXT/EXT3
                M12=L12LS
                call XADDPD ( A, LAYER, JO, JQ, JR, md12a, m12, store, istore)  ! THE LAYER SCALES
            end if

            if(IBATCH.GE.0) then           ! CHECK IF BATCH SCALES ARE BEING USED
                A=W*SCALEO*SCALEL*FCEXT/EXT3
                M12=L12BS
                call XADDPD ( A, IBATCH, JO, JQ, JR, md12a, m12, store, istore)  ! THE BATCH SCALES  
            end if

            if ( ( NV.GE.0 ) .OR. EXTINCT ) then  ! Either FO^2, or extinction correction required.
                if ( NV .GE. 0 ) STORE(JO:JP)=STORE(JO:JP)*2.0*FCEXS   ! Correct derivatives for refinement against Fo^2
                if ( EXTINCT ) STORE(JO:JP)=STORE(JO:JP)*EXT3      ! Modify for extinction
            end if

            if (ISTORE(M33CD+5).EQ.1) then   ! Check if we should output matrix in MATLAB format.
                write(NCFPU1,'(A,3(1X,F5.0))')'%',STORE(M6),STORE(M6+1),STORE(M6+2)
                do I = JO,JP-MOD(JP-JO,5)-1,5
                    write(NCFPU1,'(5G16.8,'' ...'')') (STORE(I+J),J=0,4)
                end do
                write(NCFPU1,'(5G16.8)') (STORE(JP+J),J=0-MOD(JP-JO,5),0)
                write(NCFPU2,'(F16.8)') WDF
            end if

            call XADRHS(WDF,STORE(JO),STR11(L11R),JP-JO+1)  ! ACCUMULATE THE RIGHT HAND SIDES

            if(NEWLHS)THEN   ! ACCUMULATE THE LEFT HAND SIDES
 
            if (ISTORE(M33CD+12).EQ.0) then    ! Just a normal accumulation.
                if (ISTORE(M33CD+13).EQ.0) then
                    call PARM_PAIRS_XLHS(STORE(JO), JP-JO+1, &
                    &   STR11(L11), N11, iresults, nresults, & 
                    &   STORE(L12B), N12B*MD12B, MD12B)
                else
                    ! Store a chunk of the design matrix
                    ! When the chunk is full, accumulate the normal matrix
                    designindex=designindex+1
                    if(designindex>ubound(designmatrix,2)) then
                      ! accumulate normal matrix

!$OMP PARALLEL default(none) &
!$OMP& shared(designmatrix, JP, JO, normalmatrix, tid) 
!$OMP do schedule(static)
                        do i=1, tid
                            ! passing first element as array to avoid temporary copy
                            call DSYRK('L','N',JP-JO+1,designchunk,1.0d0, &
                            &   designmatrix(1,designchunk*(i-1)+1), &
                            &   JP-JO+1,1.0d0,normalmatrix(1,1,i),JP-JO+1)
                        end do
!$OMP end do
!$OMP END PARALLEL
                        ! reset index for the chunk array
                        designindex=1
                        designmatrix=0.0
                    end if
                    designmatrix(:,designindex) = STORE(JO:JP)
            
!                  call XADLHS( STORE(JO), JP-JO+1, STR11(L11), N11,
!     1                 STORE(L12B), N12B*MD12B, MD12B )
                end if
            else                    ! No accumulation, compute leverages, Pii.
                if (ISTORE(M33CD+13).EQ.0) then
                    write(CMON,'(''SPARSE IS NOT USED FOR LEVERAGE'')')
                    call xprvdu(ncvdu,1,0)
                end if
                Pii = PDOLEV( ISTORE(L12B),MD12B*N12B,MD12B, &
                &   STR11(L11),N11,  STORE(JO),JP-JO+1, &
                &   ISTORE(M33CD+12), TIX, RED)
                REDMAX = MAX ( REDMAX, RED )

                write(HKLLAB, '(2(I4,A),I4)') NINT(STORE(M6)), ',', &
                &   NINT(STORE(M6+1)), ',', NINT(STORE(M6+2))
                call XCRAS(HKLLAB, IHKLLEN)
                write(CMON,'(3A,4F11.4)') '^^PL LABEL ''',HKLLAB(1:IHKLLEN), &
                &   ''' DATA ',FO,Pii,FO,RED*1000000000.0
                call XPRVDU(NCVDU, 1,0)

                call XCRAS(HKLLAB, IHKLLEN)
                write(124,'(2A,2F11.4,1X,2(1x,G15.9))') HKLLAB(1:IHKLLEN), &
                &   ' FO,PII,tix,Red ',FO,Pii,tix,RED



                if(( ILEVPR .LT. 30 ).OR.( PII .LT. XVALUL ) ) then
!----    H,K,L,SNTHL,LEV,
                    call XMOVE(STORE(M6), STORE(LTEMPL), 3)
                    STORE(LTEMPL+3) = SST
                    STORE(LTEMPL+4) = Pii
                    STORE(LTEMPL+5) = FO*SCALEK
                    STORE(LTEMPL+6) = FCEXT
                    call SRTDWN(LLEVER,MDLEVE,NLEVER, JLEVER, LTEMPL, XVALUL,-1)
                    ILEVPR = ILEVPR + 1
                end if
            end if
        end if
    end if

    call XSLR(1)  ! STORE THE LAST REFLECTION ON THE DISC
    call XACRT(6, minimum, maximum, summation, summationsq, 16)  ! ACCUMULATE TOTALS FOR /FC/ 
    call XACRT(7, minimum, maximum, summation, summationsq, 16)  ! AND THE PHASE
    call XACRT(16,minimum, maximum, summation, summationsq, 16)
 
    if(SFLS_TYPE .eq. SFLS_CALC) then ! ADD DETAILS FOR ALL DATA WHEN 'CALC'
        tempr=(/1.0, ABS(ABS(FO)-FCEXS), ABS(FO), WDF**2, A**2 /)
        if (STORE(M6+20) .GE. RALL(1)) then
            RALL(2:6) = RALL(2:6) + tempr
        end if
        RALL(7:11) = RALL(7:11) + tempr
    end if
    end do
!!$OMP END DO

!!$OMP END PARALLEL


    do tempstorei=1, storechunk
        if( SFLS_TYPE .EQ. SFLS_CALC ) then
        ! Remove I/sigma(I) cutoff, temporarily, leaving all other filters
        ! in place.
            do I28MN = L28MN,L28MN+((N28MN-1)*MD28MN),MD28MN
                if(ISTORE(I28MN)-M6.EQ.20) then
                    SAVSIG = STORE(I28MN+1)
                    STORE(I28MN+1) = -99999.0
                end if
            end do
        ! Fetch reflection using all other filters:
            ifNR = KFNR(1)
        ! Put sigma filter back:
            do I28MN = L28MN,M28MN,MD28MN
                if(ISTORE(I28MN)-M6.EQ.20) then
                    STORE(I28MN+1) = SAVSIG
                end if
            end do
        else
            ifNR = KFNR(1)
        end if
        if(ifnr>=0) then
            tempstore(tempstorei,:)=STORE(M6:M6+MD6-1)

            if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
                layers(tempstorei)=KLAYERnew(dummy, ierflg)  ! FIND THE LAYER NUMBER AND SET ITS VALUE
                if ( IERFLG .LT. 0 ) return ! GO TO 19900
            end if    
        
            if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
                batches(tempstorei)=KBATCH(dummy)  ! FIND THE BATCH NUMBER AND SET THE SCALE
                if ( IERFLG .LT. 0 ) return !GO TO 19900
            end if    
        
        else
            exit
        end if
    end do
    tempstoremax=tempstorei-1
    if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
        layers=layers+L5LS-1
    end if
    if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
        batches=batches+m5bs-1
    end if

END do  ! END OF REFLECTION LOOP

!!!!!!!!!!!!!!!!!!!!!!!!!
! putting back values in original storage
iposn=4
I=IPOSN-1
J=L6DTL+I*MD6DTL
STORE(J:J+3) = (/ minimum(iposn), maximum(iposn),summation(iposn), summationsq(iposn) /)
do iposn=6, 9
    I=IPOSN-1
    J=L6DTL+I*MD6DTL
    STORE(J:J+3) = (/ minimum(iposn), maximum(iposn),summation(iposn), summationsq(iposn) /)
end do
iposn=16
I=IPOSN-1
J=L6DTL+I*MD6DTL
STORE(J:J+3) = (/ minimum(iposn), maximum(iposn),summation(iposn), summationsq(iposn) /)

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! end big loop
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

if(SFLS_TYPE .EQ. SFLS_REFINE .and. &! NO REFINEMENT
&   NEWLHS .and. &! ACCUMULATE THE LEFT HAND SIDES
&   ISTORE(M33CD+12).EQ.0 .and. &! Just a normal accumulation.
&   ISTORE(M33CD+13).NE.0)THEN    
    ! process the remaining chunk of design matrix
    if(designindex>0) then
        ! Accumulate the normal matrix
!$OMP PARALLEL default(none) &
!$OMP& shared(designmatrix, JP, JO, normalmatrix, tid) 
!$OMP do schedule(static)
        do i=1, tid
            call DSYRK('L','N',JP-JO+1,designchunk, &
            &   1.0d0, designmatrix(1,designchunk*(i-1)+1), &
            &   JP-JO+1,1.0d0,normalmatrix(1,1,i),JP-JO+1)
        end do
!$OMP end do
!$OMP END PARALLEL
    end if

! Only vectorized with gfortran 4.8 not 4.4
! accumulating all normal matrices of each thread in one
    do i=1, ubound(normalmatrix,2)
        do j=2, ubound(normalmatrix,3)
            normalmatrix(:,i,1)=normalmatrix(:,i,1)+normalmatrix(:,i,j)
        end do
    end do
 
    ! Pack normal matrix back into original crystals storage     
    IBL = 1                  ! Parameter # at start of current block
    IBS = L11                ! Packed storage address.

    do MB = 1, N12B*MD12B, MD12B      
        MNR  = ISTORE(L12B+MB)  ! Dimension of this block
        MSTR = (MNR*(MNR+1))/2  ! Storage space for this block    
        do i=1,MNR
            j = ((i-1)*(2*(MNR)-i+2))/2
            k = j + MNR - i
            STR11(IBS+j:IBS+k)=normalmatrix(i+IBL-1:IBL-1+MNR,IBL+i-1,1)

! E.g. two blocks of 2 - normalmatrix is 4x4, output is 2 upper triangles of side 2.
! Initially IBL is 1, IBS is L11.
!       MNR is 2
!       MSTR is 3
!       i: 1->2
!          j = 0;  k = 2-1 = 1
!          str11(L11:L11+1) = norm(1:2, 1)
!          j = 2;  k = 2 + 2 - 2 = 2
!          str11(L11+2:L11+2) = norm(2:2, 2)
!       IBL = 3
!       IBS = L11+3
!       MNR is 2
!       MSTR is 3
!       i = 1->2
!          j = 0;  k = 1
!          str11(L11+3:L11+4) = norm(3:4, 3)
!          j = 2; k = 2
!          str11(L11+5:L11+5) = norm(4:4, 4)
! Looks OK.
              
        end do

        IBS = IBS + MSTR       ! Increment the storage pointer
        IBL = IBL + MNR        ! Increment the derivative pointer
    end do
end if
!      do i=1,JP-JO+1
!            j = ((i-1)*(2*(JP-JO+1)-i+2))/2
!            k = j + JP-JO+1 - i
!            STR11(L11+j:L11+k)=normalmatrix(i:JP-JO+1,i)
!      end do


#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
print *, 'Formation of the normal matrix time (ms): ', &
&   ((measuredtime(5)*3600+measuredtime(6)*60)+ &
&   measuredtime(7))*1000+measuredtime(8)-starttime
#endif

deallocate(designmatrix)
deallocate(normalmatrix)      

!--END OF THE REFLECTIONS  -  PRINT THE R-VALUES ETC.

if (ISTORE(M33CD+12).NE.0) then    ! Leverage plot
    write(CMON,'(A,F18.14,A/A)')'^^PL YAXISRIGHT ZOOM 0.0 ', &
    &   REDMAX,' SHOW','^^CR'
    call XPRVDU(NCVDU, 2,0)
end if

if (NT .LE. 0) then
    if (ISSPRT .EQ. 0) write(NCWU,5851)
    write ( CMON, 5851)
    call XPRVDU(NCVDU, 1,0)
5851      FORMAT(' No reflections have been used for the Structure Factor calculation')
    R = 0.
    A = 0.
    T = 0.
    RW = 0.
    S = 0.
else
    if (FOABS .LE. 0.0) then ! GOTO 19940
!------ SIGMA FO .LE. ZERO ---- SUGGESTS PROBABLY NO CALCULATION
        formatstr="(1X,'The denominator for the R factor is less than or equal to zero.',&
        &   /,' No structure factors have been stored.')"
        if (ISSPRT .EQ. 0) write(NCWU,formatstr)
        write ( CMON, formatstr)
        call XPRVDU(NCVDU, 2,0)
    return
    end if
    
    R=DFT/FOABS*100.0
!----- PATCH TO AVOID INCIPIENT DIVISION BY ZERO
    if(RW .LE. 0) then ! GOTO 19930
!------ SIGMA W*FO*FO .LE. ZERO ---- SUGGESTS PROBABLY NO WEIGHTS
        formatstr="(1X,'The denominator for the weighted R factor is less than or equal to zero.', &
        &   ' Check that you have computed Fc and applied weights.')"
        if (ISSPRT .EQ. 0) write(NCWU,formatstr)
        write ( CMON, formatstr)
        call XPRVDU(NCVDU, 2,0)
        call XERHND ( IERERR )
        return ! GOTO 19900
    end if
              
    RW=SQRT(WDFT/RW)*100.0
    A=FOT/SCALEO
    S=FCT/SCALEO
    T=DFT/SCALEO
end if

if(SFLS_TYPE .EQ. SFLS_SCALE) then  ! WE ARE TO CALCULATE A NEW SCALE FACTOR HERE
!6100    CONTINUE. Scale factor shift is wrt F**2, change is necessary.
    if (NV .GE. 0) then   ! REMEMBER THE SHIFT IS IN F**2
        if (SFC.GT.ZEROSQ) then
            STORE(L5O) = SQRT(STORE(L5O)*STORE(L5O) + SFO/SFC)
        else
            STORE(L5O) = SQRT(STORE(L5O)*STORE(L5O))
        end if
    else
        if (SFC.GT.ZEROSQ) then
            STORE(L5O)=STORE(L5O) + SFO/SFC
        else
            STORE(L5O)=STORE(L5O)
        end if
    end if
end if

!--STORE THE SCALE AND PRINT IT
SCALE=STORE(L5O)
LJX = 0
if ( TWINNED )THEN
    LJX = 4
    if ( SCALED_FOT ) LJX=8
end if
if ( SFLS_TYPE .NE. SFLS_REFINE ) LJX = LJX + 1
if ( SFLS_TYPE .NE. SFLS_SCALE ) LJX = LJX + 2

if (ILEVPR .GT. 0) then
6112      FORMAT(I6,' low leverage reflections.')
    write ( CMON, 6112) MIN(30,ILEVPR)
    call XPRVDU(NCVDU, 1,0)
    if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)
    RLEVNM = 0.0
    RLEVDN = 0.0
    do  MLEVER = LLEVER, LLEVER+(NLEVER-1)*MDLEVE, MDLEVE
        RLEVNM = RLEVNM + ABS(STORE(MLEVER+5)-STORE(MLEVER+6))
        RLEVDN = RLEVDN + STORE(MLEVER+5)
    end do

    write(CMON,'(''R(lowleverage) = <Fo-Fc>/<Fo> ='',F9.2,''%'')') 100.*RLEVNM/MAX(.001,RLEVDN)
    call XPRVDU(NCVDU,1,0)
    if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)

    write(CMON,6113)
6113      FORMAT (2('   h   k   l sintl2 Leverage    FO-FC    '))
    call XPRVDU(NCVDU, 1,0)
    if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)

    do  MLEVER = LLEVER, LLEVER+(NLEVER-1)*MDLEVE, 2*MDLEVE
        write (CMON,'(2(3I4,F6.3,X,F7.5,F10.3,5X))') &
        &   ( (NINT(STORE(IXAP)), IXAP=JXAP, JXAP+2), &
        &   (STORE(IXAP), IXAP= JXAP+3,JXAP+4), &
        &   STORE(JXAP+5)-STORE(JXAP+6), &
        &   JXAP= MLEVER, MLEVER+MDLEVE, MDLEVE)
        call XPRVDU(NCVDU, 1,0)
        if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)
    end do
end if
!
! Only print disagreeable reflections during calc.
if( SFLS_TYPE .EQ. SFLS_CALC ) then
    write (CMON ,'(/'' Target Weighted Residual ='',F6.2)') SQRT(AMINF/real(NT))
    call XPRVDU(NCVDU, 2,0)
    if(ISSPRT.EQ.0) write(NCWU, '(//)')
    if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(2)(:)
    write ( CMON ,11)
    call XPRVDU(NCVDU, 1,0)
    if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)
11        FORMAT(2('   h   k  l     Fo      Fc  wDel Fo/Fc','  '))
    do MSORT = LSORT, LSORT+(NSORT-1)*MDSORT, 2*MDSORT
        write ( CMON , '(3I4, 2F7.1, F6.1, F6.2,2X,3I4, 2F7.1, F6.1, F6.2)') &
        &   ( (NINT(STORE(IXAP)), IXAP=JXAP, JXAP+2), &
        &   (STORE(IXAP), IXAP= JXAP+3,JXAP+6), &
        &   JXAP= MSORT, MSORT+MDSORT, MDSORT)
        call XPRVDU(NCVDU, 1,0)
        if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)
    end do
end if
!
if (ISSPRT .EQ. 0) then
    write(NCWU,5900)R,RW,A,S,T
5900      FORMAT(/30X,3('*')/29X,3('*')/' R-value    Weighted R',6X, &
    &   12('*'),14X,12('*')/27X,13('*'),2X,'HERE IT IS',2X,12('*')/ &
    &   F7.2,F12.2,9X,12('*'),14X,12('*')/29X,3('*')/30X,3('*')// &
    &   ' Sum of /FO/    Sum of /FC/    Sum of /Delta/', &
!RIC13:     5  '    Minimization function',//F11.1,F15.1,F16.1,34X,
    &   '    Minimization function',//F11.0,F15.0,F16.0,34X, &
    &   ' On scale of /FC/')
    write(NCWU,5950)FOT,FCT,DFT,AMINF
!RIC13:5950    FORMAT(/F11.1,F15.1,F16.1,E25.8,9X,' On scale of /FO/')
5950      FORMAT(/F11.0,F15.0,F16.0,E25.4,9X,' On scale of /FO/')
    write(NCWU,6150) STORE(L5O), NT
    write(NCWU,6250)cycle_number,LJX
end if
!
!RIC13:6150  FORMAT(/,' New scale factor (G) is ',F10.5,
6150  FORMAT(/,' New scale factor (G) is ',F10.3,',  ',I6,' reflections used in refinement')
6250  FORMAT(/,' Structure factor least squares calculation',I5,'  ends',I3)

if (S .GT. ZERO) S = A/S

write ( CMON, 6260) cycle_number, N12, MIN(R,99.99), MIN(RW,99.99), AMINF, MIN(999.99,S)

6260  FORMAT (' Cycle',I5,' Params',I5,' R{9,1 ',F5.2, &
&   '%{8,1 Rw{9,1 ',F5.2, '%{8,1 MinFunc ',G9.2,' SumFo/SumFc ',F6.2)
call OUTCOL(6)
call XPRVDU(NCVDU, 1, 0)
call OUTCOL(1)

call CPU_TIME ( time_end )
!      write ( NCWU, '(A,F15.8)' )'SFLSC seconds: ',time_end - time_begin

END

!CODE FOR KLAYER
integer function KLAYER(input)
!--COMPUTE THE LAYER SCALE INDEX FOR THE CURRENT REFLECTION.
!
!  IN  A DUMMY ARGUMENT.
!
!--return VALUES OF 'KLAYER' ARE :
!
!  -1  NO LAYER SCALES IN LIST 5.
!  >0  THE LAYER SCALE INDEX.
!
!--
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu, IERFLG
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST05.INC90'
use xlst05_mod, only: md5ls, l5lsc
!include 'XLST06.INC90'
use xlst06_mod, only: m6
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
!
!include 'QSTORE.INC'
!
implicit none

integer, intent(in) :: input
real a
integer idwzap, i

IDWZAP = input
!--
KLAYER=-1

if(MD5LS.GT.0)THEN  ! ARE THERE ANY LAYER SCALES STORED?

    A=STORE(L5LSC)*STORE(M6)+STORE(L5LSC+1)*STORE(M6+1) &
    &   +STORE(L5LSC+2)*STORE(M6+2)  ! !  COMPUTE THE INDEX VALUE

    if(STORE(L5LSC+4).LT.0) A=ABS(A) ! Take absolute value

    I=NINT(A+STORE(L5LSC+3))  ! COMPUTE THE OUTPUT INDEX

    if((I.LE.0).OR.(I.GT.MD5LS))THEN  ! ILLEGAL LAYER SCALE VALUE
        call XERHDR(0)
        if (ISSPRT .EQ. 0) then
            write(NCWU,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        end if
        write(CMON,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        call XPRVDU(NCVDU, 1,0)
1200          FORMAT(' Reflection : ',3I5,'  generates an illegal layer scale index of ',I4)
        !call XERHNDnew ( IERERR, ierflg )
        call XERHND ( IERERR )
        return
    end if

    KLAYER=I
end if
END

!CODE FOR KLAYER
integer function KLAYERnew(input, ierflg) result(klayer)
!--COMPUTE THE LAYER SCALE INDEX FOR THE CURRENT REFLECTION.
!
!  IN  A DUMMY ARGUMENT.
!
!--return VALUES OF 'KLAYER' ARE :
!
!  -1  NO LAYER SCALES IN LIST 5.
!  >0  THE LAYER SCALE INDEX.
!
!--
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST05.INC90'
use xlst05_mod, only: md5ls, l5lsc
!include 'XLST06.INC90'
use xlst06_mod, only: m6
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
!
!include 'QSTORE.INC'
!
implicit none

integer, intent(in) :: input
integer, intent(out) :: ierflg
real a
integer idwzap, i

IDWZAP = input
!--
KLAYER=-1

if(MD5LS.GT.0)THEN  ! ARE THERE ANY LAYER SCALES STORED?

    A=STORE(L5LSC)*STORE(M6)+STORE(L5LSC+1)*STORE(M6+1) &
    &   +STORE(L5LSC+2)*STORE(M6+2)  ! !  COMPUTE THE INDEX VALUE

    if(STORE(L5LSC+4).LT.0) A=ABS(A) ! Take absolute value

    I=NINT(A+STORE(L5LSC+3))  ! COMPUTE THE OUTPUT INDEX

    if((I.LE.0).OR.(I.GT.MD5LS))THEN  ! ILLEGAL LAYER SCALE VALUE
        call XERHDR(0)
        if (ISSPRT .EQ. 0) then
            write(NCWU,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        end if
        write(CMON,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        call XPRVDU(NCVDU, 1,0)
1200          FORMAT(' Reflection : ',3I5,'  generates an illegal layer scale index of ',I4)
        call XERHNDnew ( IERERR, ierflg )
        return
    end if

    KLAYER=I
end if
END


!CODE FOR KBATCH
integer function KBATCH(input)
!--COMPUTE THE BATCH SCALE INDEX FOR THE CURRENT REFLECTION.
!
!  IN  A DUMMY ARGUMENT.
!
!--return VALUES OF 'KBATCH' ARE :
!
!  -1  NO BATCH SCALES IN LIST 5.
!  >0  THE BATCH SCALE INDEX.
!
!--
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST05.INC90'
use xlst05_mod, only: md5bs
!include 'XLST06.INC90'
use xlst06_mod, only: m6
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
!include 'QSTORE.INC'
implicit none

integer, intent(in) :: input
integer idwzap, i

IDWZAP = input
KBATCH=-1
if (MD5BS.GT.0) then   ! ARE ANY BATCH SCALES STORED
    I=NINT(STORE(M6+13))  ! COMPUTE THE INDEX VALUE
!--CHECK if THE VALUE IS LARGE ENOUGH
    if((I.LE.0).OR.(I.GT.MD5BS))THEN 
        call XERHDR(0)  ! ILLEGAL BATCH SCALE VALUE
        if (ISSPRT .EQ. 0) then
            write(NCWU,1100)NINT(STORE(M6)),NINT(STORE(M6+1)),NINT(STORE(M6+2)),I
        end if
        write(CMON,1100)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        call XPRVDU(NCVDU, 1,0)
1100          FORMAT(' Reflection : ',3I5,'  generates an illegal batch scale index of ',I4)
        call XERHND ( IERERR )
        return
    end if
    KBATCH=I
end if
END


!CODE FOR XLINE
subroutine XLINE (M2LI, M5ALI, M6LI, LifAC, DLFLILE, DLFTHE, DLFPHI)
 
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only: store
!include 'XLST01.INC90'
use xlst01_mod, only: l1p1, l1o2
!include 'QSTORE.INC'
use xconst_mod, only: zerosq, twopi, pi

implicit none

!-C-C-SOME TRANSFERRED STARTING-ADDRESSES OF ACTUAL (!) PARAMETERS
integer, intent(in) :: M2LI, M5ALI, M6LI
double precision, intent(inout) :: LifAC, DLFLILE, DLFTHE, DLFPHI
!-C-C-AGREEMENT OF CONSTANTS AND VARIABLES
!-C-C-CELL-CONSTANTS, REFLECTION-INDICES
real CONA, CONB, CONC, CONAL, CONBET, CONGA, COGAST
real COSCONAL, COSCONGA, COSCONBET
real REFLH, REFLK, REFLL
!-C-C-COORDINATES FOR LINE (POLAR, CARTESIAN, TRICLINIC)
real LILE, ANGLZD, AZIMXD, ANGLZ, AZIMX
real LINCX, LINCY, LINCZ, LINX, LINY, LINZ
!-C-C-TRANSF. BETWEEN COORD. SYST. (CARTESIAN TO TRIGONAL)
real CATRI11, CATRI12, CATRI13
real CATRI21, CATRI22, CATRI23
real CATRI31, CATRI32, CATRI33
!-C-C-SOME ABBREVIATIONS
!-C-C-...FOR STRUCTURFACTOR-CALCULATION
real COSIA, COSIB, COSIC, COSIRO
real DOTHLX, DOTHLY, DOTHLZ, DOTHL
!-C-C-...FOR DERIVATIVES
real DLINXLL, DLINYLL, DLINZLL
real DLINXTHE, DLINYTHE, DLINZTHE
real DLINXPHI, DLINYPHI, DLINZPHI
real DDOTLL, DDOTTHE, DDOTPHI

!-C-C-CALCULATE THE LINE
!-C-C-ABBREVIATIONS FOR CONSTANTS AND VARIABLES
CONA=STORE(L1P1)
CONB=STORE(L1P1+1)
CONC=STORE(L1P1+2)
CONAL=STORE(L1P1+3)
CONBET=STORE(L1P1+4)
CONGA=STORE(L1P1+5)
REFLH=STORE(M6LI)
REFLK=STORE(M6LI+1)
REFLL=STORE(M6LI+2)
LILE=STORE(M5ALI+8)
!-C-C-(POLAR ANGLES IN UNITS OF 100 DEGREES)
ANGLZD=STORE(M5ALI+9)
AZIMXD=STORE(M5ALI+10)
!-C-C-TRANSFORMATION OF DEGREES (IN UNITS OF 100 DEGREES) TO RADIANS
ANGLZ=ANGLZD*TWOPI/3.6
AZIMX=AZIMXD*TWOPI/3.6
!-C-C-PREP. OF CALC. OF THE DOT-PROD. OF LINE AND HKL AND HKL-LENGTH
cosconal=cos(conal)
cosconga=cos(conga)
cosconbet=cos(conbet)
COSIA=cosconbet*cosconga-cosconal
COSIB=cosconal*cosconga-cosconbet
COSIC=cosconal*cosconbet-cosconga
COSIRO=1+2*cosconal*cosconbet*cosconga-cosconal**2-cosconbet**2-cosconga**2
!-C-C-CALCULATION OF RECIPROCAL CELL-CONSTANTS FROM real CELL-CONSTANTS
COGAST=cosconal*cosconbet-cosconga/(SIN(CONAL)*SIN(CONBET))
!-C-C-GETTING MATRIX (TRANSF. CART. --> TRICL.) FROM CRYSTALS
CATRI11=STORE(L1O2+0)
CATRI21=STORE(L1O2+1)
CATRI31=STORE(L1O2+2)
CATRI12=STORE(L1O2+3)
CATRI22=STORE(L1O2+4)
CATRI32=STORE(L1O2+5)
CATRI13=STORE(L1O2+6)
CATRI23=STORE(L1O2+7)
CATRI33=STORE(L1O2+8)
!-C-C-CALC. OF THE CARTESIAN COORD. OF LINE IN real SPACE
LINCX=LILE*SIN(ANGLZ)*COS(AZIMX)
LINCY=LILE*SIN(ANGLZ)*SIN(AZIMX)
LINCZ=LILE*COS(ANGLZ)
!-C-C-CALC. OF THE TRICLINIC COORD. OF LINE IN real SPACE
LINX=LINCX*CATRI11+LINCY*CATRI12+LINCZ*CATRI13
LINY=LINCX*CATRI21+LINCY*CATRI22+LINCZ*CATRI23
LINZ=LINCX*CATRI31+LINCY*CATRI32+LINCZ*CATRI33
!-C-C-CALC. OF SYMMETRY-EQUIVALENT DIRECTIONS (TRANSF. OF VECTOR-
!-C-C-END-POINT BY ROTATIONAL PART ONLY)
LINX=LINX*STORE(M2LI)+LINY*STORE(M2LI+1)+LINZ*STORE(M2LI+2)
LINY=LINX*STORE(M2LI+3)+LINY*STORE(M2LI+4)+LINZ*STORE(M2LI+5)
LINZ=LINX*STORE(M2LI+6)+LINY*STORE(M2LI+7)+LINZ*STORE(M2LI+8)
!-C-C-CALC. DOT-PRODUCT OF HKL-VECTOR AND LINE-VECTOR IN REC. SPACE
DOTHLX=COSIC*((REFLK*CONA/CONB)+REFLH*cosconga) &
&   +COSIB*((REFLL*CONA/CONC)+REFLH*cosconbet) &
&   +COSIA*((REFLL*CONA*cosconga/CONC) &
&        +(REFLK*CONA*cosconbet/CONB)) &
&   +REFLH*(SIN(CONAL)**2) &
&   +(REFLK*CONA*(SIN(CONBET)**2)*cosconga/CONB) &
&   +(REFLL*CONA*(SIN(CONGA)**2)*cosconbet/CONC)
DOTHLY=COSIC*(REFLK*cosconga+(REFLH*CONB/CONA)) &
&   +COSIB*((REFLL*CONB*cosconga/CONC) &
&        +(REFLH*CONB*cosconal/CONA)) &
&   +COSIA*((REFLL*CONB/CONC)+REFLK*cosconal) &
&   +(REFLH*CONB*(SIN(CONAL)**2)*cosconga/CONA) &
&   +REFLK*(SIN(CONBET)**2) &
&   +(REFLL*CONB*(SIN(CONGA)**2)*cosconal/CONC) 
DOTHLZ=COSIC*((REFLK*CONC*cosconbet/CONB) &
&             +(REFLH*CONC*cosconal/CONA)) &
&   +COSIB*(REFLL*cosconbet+(REFLH*CONC/CONA)) &
&   +COSIA*(REFLL*cosconal+(REFLK*CONC/CONB)) &
&   +(REFLH*CONC*(SIN(CONAL)**2)*cosconbet/CONA) &
&   +(REFLK*CONC*(SIN(CONBET)**2)*cosconal/CONB)&
&   +REFLL*(SIN(CONGA)**2)
DOTHL=(LINX*DOTHLX+LINY*DOTHLY+LINZ*DOTHLZ)/COSIRO
!-C-C-CALCULATE FINAL FACTOR FOR LINE s
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    LifAC=1.0
else
    LifAC=SIN(PI*DOTHL)/(PI*DOTHL)
end if
!-C-C-CALCULATE DERIVATIVES
!-C-C-ABBR. FOR PART. DERIV. W.R.T. A AND (!) B FOR LINE (LILE)
DLINXLL=SIN(ANGLZ)*COS(AZIMX)*CATRI11 &
&      +SIN(ANGLZ)*SIN(AZIMX)*CATRI12 &
&      +COS(ANGLZ)*CATRI13 
DLINYLL=SIN(ANGLZ)*COS(AZIMX)*CATRI21 &
&      +SIN(ANGLZ)*SIN(AZIMX)*CATRI22 &
&      +COS(ANGLZ)*CATRI23 
DLINZLL=SIN(ANGLZ)*COS(AZIMX)*CATRI31 &
&      +SIN(ANGLZ)*SIN(AZIMX)*CATRI32 &
&      +COS(ANGLZ)*CATRI33 
DDOTLL=(DLINXLL*DOTHLX+DLINYLL*DOTHLY+DLINZLL*DOTHLZ)/COSIRO
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    DLFLILE=0.0
else
    DLFLILE=((DOTHL*COS(PI*DOTHL)-SIN(PI*DOTHL)/PI)*DDOTLL)/(DOTHL**2)
end if
!-C-C-ABBR. FOR PART. DERIV. W.R.T. A AND (!) B FOR LINE (ANGLZ)
DLINXTHE=LILE*COS(ANGLZ)*COS(AZIMX)*CATRI11 &
&       +LILE*COS(ANGLZ)*SIN(AZIMX)*CATRI12 &
&       -LILE*SIN(ANGLZ)*CATRI13
DLINYTHE=LILE*COS(ANGLZ)*COS(AZIMX)*CATRI21 &
&       +LILE*COS(ANGLZ)*SIN(AZIMX)*CATRI22 &
&       -LILE*SIN(ANGLZ)*CATRI23
DLINZTHE=LILE*COS(ANGLZ)*COS(AZIMX)*CATRI31 &
&       +LILE*COS(ANGLZ)*SIN(AZIMX)*CATRI32 &
&       -LILE*SIN(ANGLZ)*CATRI33
DDOTTHE=(DLINXTHE*DOTHLX+DLINYTHE*DOTHLY+DLINZTHE*DOTHLZ)*TWOPI/(3.6*COSIRO)
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    DLFTHE=0.0
else
    DLFTHE=((DOTHL*COS(PI*DOTHL)-SIN(PI*DOTHL)/PI)*DDOTTHE)/(DOTHL**2)
end if
!-C-C-ABBR. FOR PART. DERIV. W.R.T. A AND (!) B FOR LINE (AZIMX)
DLINXPHI=-LILE*SIN(ANGLZ)*SIN(AZIMX)*CATRI11 &
&       +LILE*SIN(ANGLZ)*COS(AZIMX)*CATRI12 
DLINYPHI=-LILE*SIN(ANGLZ)*SIN(AZIMX)*CATRI21 &
&       +LILE*SIN(ANGLZ)*COS(AZIMX)*CATRI22 
DLINZPHI=-LILE*SIN(ANGLZ)*SIN(AZIMX)*CATRI31 &
&       +LILE*SIN(ANGLZ)*COS(AZIMX)*CATRI32
DDOTPHI=(DLINXPHI*DOTHLX+DLINYPHI*DOTHLY+DLINZPHI*DOTHLZ) &
&       *TWOPI/(3.6*COSIRO)
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    DLFPHI=0.0
else
    DLFPHI=((DOTHL*COS(PI*DOTHL)-SIN(PI*DOTHL)/PI)*DDOTPHI)/(DOTHL**2)
end if
END

!CODE FOR XRING
subroutine XRING (M2RI, STRI, M5ARI, M6RI,RifAC, DRFRA, DRFTHE, DRFPHI)

!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only: store
!include 'XLST01.INC90'
use xlst01_mod, only: l1p1, l1o2
use xconst_mod, only: twopi, zerosq

implicit none
!include 'QSTORE.INC'

!-c-c-agreement of constants and variables
!-c-c-cell-constants, reflection-indices
real cona, conb, conc, conal, conbet, conga
real cosconal, cosconga, cosconbet
real reflh, reflk, refll
!-c-c-parameters/coordinates for ring (polar, cartesian, triclinic)
real rira, anglzd, azimxd
double precision anglz, azimx
double precision lincx, lincy, lincz, linx, liny, linz
!-c-c-some transferred starting-addresses of actual (!) parameters
integer m2ri, m5ari, m6ri
!-c-c-transferred value of st
real stri
!-c-c-transf. between coord. syst. (cartesian to trigonal)
real catri11, catri12, catri13
real catri21, catri22, catri23
real catri31, catri32, catri33
!-c-c-some abbreviations
!-c-c-...for structurfactor-calculation
double precision cosia, cosib, cosic, cosiro
double precision dothlx, dothly, dothlz, dothl
double precision cospsi, sinpsi
double precision bessr1, bessr2, bessr3, bessr4, bessr5, bessr6
double precision besss1, besss2, besss3, besss4, besss5, besss6
double precision bessp1, bessp2, bessp3, bessp4, bessp5
double precision bessq1, bessq2, bessq3, bessq4, bessq5
double precision argbes, argsq, sicarg, rar8sq, rifac
!-c-c-...for derivatives
double precision dlinxthe, dlinythe, dlinzthe
double precision dlinxphi, dlinyphi, dlinzphi
double precision ddotthe, ddotphi, drfout, dargra
double precision dargthe, dargphi, drfra, drfthe, drfphi

!-c-c-variables for bessel-functions are preoccupied
data bessr1,bessr2,bessr3,bessr4,bessr5,bessr6 & 
&   /57568490574.d0, -13362590354.d0, 651619640.7d0, &
&   -11214424.18d0, 77392.33017d0, -184.9052456d0/
data besss1,besss2,besss3,besss4,besss5,besss6 &
&   /57568490411.d0, 1029532985.d0, 9494680.718d0, &
&   59272.64853d0, 267.8532712d0, 1.d0/
data bessp1,bessp2,bessp3,bessp4,bessp5 &
&   /1.d0, -.1098628627d-2, .2734510407d-4, &
&   -.2073370639d-5, .2093887211d-6/
data bessq1,bessq2,bessq3,bessq4,bessq5 &
&   /-.1562499995d-1, .1430488765d-3, -.6911147651d-5, &
&   .7621095161d-6, -.934945152d-7/
!-c-c-calculate the ring
!-c-c-abbreviations for constants and variables
cona=store(l1p1)
conb=store(l1p1+1)
conc=store(l1p1+2)
conal=store(l1p1+3)
conbet=store(l1p1+4)
conga=store(l1p1+5)
cosconal=cos(conal)
cosconga=cos(conga)
cosconbet=cos(conbet)      
reflh=store(m6ri)
reflk=store(m6ri+1)
refll=store(m6ri+2)
rira=store(m5ari+8)
!-c-c-(polar angles in units of 100 degrees)
anglzd=store(m5ari+9)
azimxd=store(m5ari+10)
!-c-c-transformation of degrees (in units of 100 degrees) to radians
anglz=anglzd*twopi/3.6
azimx=azimxd*twopi/3.6
!-c-c-prep. of calc. of the dot-prod. of ring-normal, hkl(-length)
cosia=cosconbet*cosconga-cosconal
cosib=cosconal*cosconga-cosconbet
cosic=cosconal*cosconbet-cosconga
cosiro=1+2*cosconal*cosconbet*cosconga-cosconal**2-cosconbet**2-cosconga**2
!-c-c-getting matrix (transf. cart. --> tricl.) from crystals
catri11=store(l1o2+0)
catri21=store(l1o2+1)
catri31=store(l1o2+2)
catri12=store(l1o2+3)
catri22=store(l1o2+4)
catri32=store(l1o2+5)
catri13=store(l1o2+6)
catri23=store(l1o2+7)
catri33=store(l1o2+8)
!-c-c-calc. of the cartesian coord. of ring-normal in real space
lincx=sin(anglz)*cos(azimx)
lincy=sin(anglz)*sin(azimx)
lincz=cos(anglz)
!-c-c-calc. of the triclinic coord. of ring-normal in real space
linx=lincx*catri11+lincy*catri12+lincz*catri13
liny=lincx*catri21+lincy*catri22+lincz*catri23
linz=lincx*catri31+lincy*catri32+lincz*catri33
!-c-c-calc. of symmetry-equivalent directions (transf. of vector-
!-c-c-end-point by rotational part only)
linx=linx*store(m2ri)+liny*store(m2ri+1)+linz*store(m2ri+2)
liny=linx*store(m2ri+3)+liny*store(m2ri+4)+linz*store(m2ri+5)
linz=linx*store(m2ri+6)+liny*store(m2ri+7)+linz*store(m2ri+8)
!-c-c-calc. dot-prod. of hkl-vect. and ring-normal-vect. in rec. space
dothlx=cosic*((reflk*cona/conb)+reflh*cosconga) &
&   +cosib*((refll*cona/conc)+reflh*cosconbet) &
&   +cosia*((refll*cona*cosconga/conc) &
&        +(reflk*cona*cosconbet/conb)) &
&   +reflh*(sin(conal)**2) &
&   +(reflk*cona*(sin(conbet)**2)*cosconga/conb) &
&   +(refll*cona*(sin(conga)**2)*cosconbet/conc)
dothly=cosic*(reflk*cosconga+(reflh*conb/cona)) &
&   +cosib*((refll*conb*cosconga/conc) &
&        +(reflh*conb*cosconal/cona)) &
&   +cosia*((refll*conb/conc)+reflk*cosconal) &
&   +(reflh*conb*(sin(conal)**2)*cosconga/cona) &
&   +reflk*(sin(conbet)**2) &
&   +(refll*conb*(sin(conga)**2)*cosconal/conc)
dothlz=cosic*((reflk*conc*cosconbet/conb) &
&             +(reflh*conc*cosconal/cona)) &
&   +cosib*(refll*cosconbet+(reflh*conc/cona)) &
&   +cosia*(refll*cosconal+(reflk*conc/conb)) &
&   +(reflh*conc*(sin(conal)**2)*cosconbet/cona) &
&   +(reflk*conc*(sin(conbet)**2)*cosconal/conb) &
&   +refll*(sin(conga)**2)
dothl=(linx*dothlx+liny*dothly+linz*dothlz)/cosiro
!-c-c-calculate cosine of angle between hkl-vector and ring-normal
cospsi=dothl/(2*stri)
if (cospsi .gt. 1.0) then
    cospsi=1.0
else if (cospsi .lt. -1.0) then
    cospsi=-1.0
end if
!-c-c-calculate sine of angle between hkl-vector and ring-normal
sinpsi=sqrt(1-cospsi**2)
!-c-c-calculate final factor for ring s
argbes=2*twopi*stri*rira*sinpsi
if (argbes .lt. 8.) then
    argsq=argbes**2
    rifac=(bessr1+argsq*(bessr2+argsq*(bessr3+argsq &
    &   *(bessr4+argsq*(bessr5+argsq*bessr6))))) &
    &   /(besss1+argsq*(besss2+argsq*(besss3+argsq &
    &   *(besss4+argsq*(besss5+argsq*besss6)))))
else
    sicarg=argbes-.785398164
    rar8sq=(8./argbes)**2
    rifac=sqrt(.636619772/argbes)*(cos(sicarg) &
    &   *(bessp1+rar8sq*(bessp2+rar8sq*(bessp3+rar8sq &
    &   *(bessp4+rar8sq*bessp5)))) &
    &   -(8./argbes)*sin(sicarg) &
    &   *(bessq1+rar8sq*(bessq2+rar8sq*(bessq3+rar8sq &
    &   *(bessq4+rar8sq*bessq5)))))
end if
!-c-c-abbr. for part. deriv. w.r.t. a and (!) b for ring (anglz)
dlinxthe=cos(anglz)*cos(azimx)*catri11 &
&       +cos(anglz)*sin(azimx)*catri12 &
&       -sin(anglz)*catri13
dlinythe=cos(anglz)*cos(azimx)*catri21 &
&       +cos(anglz)*sin(azimx)*catri22 &
&       -sin(anglz)*catri23
dlinzthe=cos(anglz)*cos(azimx)*catri31 &
&       +cos(anglz)*sin(azimx)*catri32 &
&       -sin(anglz)*catri33
ddotthe=(dlinxthe*dothlx+dlinythe*dothly+dlinzthe*dothlz)*twopi/(3.6*cosiro)
!-c-c-abbr. for part. deriv. w.r.t. a and (!) b for ring (azimx)
dlinxphi=-sin(anglz)*sin(azimx)*catri11+sin(anglz)*cos(azimx)*catri12
dlinyphi=-sin(anglz)*sin(azimx)*catri21+sin(anglz)*cos(azimx)*catri22
dlinzphi=-sin(anglz)*sin(azimx)*catri31+sin(anglz)*cos(azimx)*catri32
ddotphi=(dlinxphi*dothlx+dlinyphi*dothly+dlinzphi*dothlz)*twopi/(3.6*cosiro)
!-c-c-abbr. for part. deriv. w.r.t. a and (!) b for ring
!-c-c-outer deriv. for rira, anglz and azimx (for argbes < 8.)
if (argbes .lt. 8.) then
    drfout=argbes &
    &   *((2*bessr2+argsq*(4*bessr3+argsq*(6*bessr4+argsq &
    &   *(8*bessr5+argsq*10*bessr6)))) &
    &   *(besss1+argsq*(besss2+argsq*(besss3+argsq &
    &   *(besss4+argsq*(besss5+argsq*besss6))))) &
    &   -(2*besss2+argsq*(4*besss3+argsq*(6*besss4+argsq &
    &   *(8*besss5+argsq*10*besss6)))) &
    &   *(bessr1+argsq*(bessr2+argsq*(bessr3+argsq &
    &   *(bessr4+argsq*(bessr5+argsq*bessr6)))))) &
    &   /((besss1+argsq*(besss2+argsq*(besss3+argsq &
    &   *(besss4+argsq*(besss5+argsq*besss6)))))**2)
!-c-c-outer deriv. for rira, anglz and azimx (for argbes >/= 8.)
else
    drfout=(sqrt(.636619772/argbes)/argbes)*((8./argbes) &
    &   *(bessq1*(1.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *(bessq2*(3.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *(bessq3*(5.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *(bessq4*(7.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *bessq5*(9.5*sin(sicarg)-argbes*cos(sicarg)))))) &
    &   -(bessp1*(argbes*sin(sicarg)+0.5*cos(sicarg))+rar8sq &
    &   *(bessp2*(argbes*sin(sicarg)+2.5*cos(sicarg))+rar8sq &
    &   *(bessp3*(argbes*sin(sicarg)+4.5*cos(sicarg))+rar8sq &
    &   *(bessp4*(argbes*sin(sicarg)+6.5*cos(sicarg))+rar8sq &
    &   *bessp5*(argbes*sin(sicarg)+8.5*cos(sicarg)))))))
end if
!-c-c-inner deriv. for rira
dargra=2*twopi*stri*sinpsi
!-c-c-check, whether sinpsi approaches zero
if (sinpsi .lt. zerosq) then
    drfthe=0.0
    drfphi=0.0
else
!-c-c-inner deriv. for anglz
    dargthe=-twopi*rira*dothl*ddotthe/(2*stri*sinpsi)
!-c-c-inner deriv. for azimx
    dargphi=-twopi*rira*dothl*ddotphi/(2*stri*sinpsi)
!-c-c-part. deriv. w.r.t. a and (!) b for ring (anglz,azimx,rira)
    drfthe=drfout*dargthe
    drfphi=drfout*dargphi
end if
drfra=drfout*dargra
end

!CODE FOR XSPHERE
subroutine XSPHERE (STSP, M5ASP, SPHEFAC, DSFRAD)
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only: store
use xconst_mod, only: pi

implicit none

!-c-c-transferred starting-addresses of m5a
integer m5asp
!-c-c-transferred value of st
real stsp
!-c-c-agreement of variables (sphere-factor and derivativ)
double precision sphefac
double precision dsfrad

!include 'QSTORE.INC'


!-c-c-calculate the sphere-factor
sphefac=(sin(4*pi*store(m5asp+8)*stsp))/(4*pi*store(m5asp+8)*stsp)
!-c-c-calculate the derivative w.r.t. sphere-factor for radius
dsfrad=((cos(4*pi*stsp*store(m5asp+8)) &
&   *4*pi*stsp*store(m5asp+8))-(sin(4*pi*stsp*store(m5asp+8)))) &
&   /(4*pi*stsp*(store(m5asp+8))**2)
end

!CODE FOR PDOLEV
real function PDOLEV(L12, N12, MD12B, V, N11, DF, NDF, JPNX, TIX, RED)
implicit none 

real, dimension(8192) :: VCVVEC
integer IVCVVSZ
COMMON /VCVTMP/ IVCVVSZ, VCVVEC

integer, intent(in) :: N12, md12b, n11, ndf, jpnx

integer, dimension(N12), intent(in) :: L12
real, dimension(N11), intent(in) :: V
real, dimension(NDF), intent(in) :: DF
real, intent(inout) :: tix, red

real doub
integer i, j, k, ibs, jpn, m11
real pii, titmp
! Work out leverage and some other things. See Prince, Mathematical
! Techniques in Crystallography and Materials Science, 2nd Edition,
! Springer-Verlag. pp120-123

!  L12 is an array of size N12 containing information about the
!  blocking of the array V.

!  V is of size N11, but may be in blocks (see L12)

!  DF is the current row of the design matrix. (Called A below).

!  P = A.V.At
!  where P is the projection (say hat) matrix.
!        A is the LHS
!        V is the inverse normal matrix (must be already known).
!  The leverages are the diagonal elements of the hat matrix, Pii.

! Ti = Ai.Vn, then t^2ij/(1+Pii) is the amount by which a repeated
! measurement of the ith reflection will reduce the variance of the
! estimate of the LJTh parameter.

! JPNX is the (one-based) index of the parameter of interest. E.g
! 1 is usually the scale factor. See \PRINT 22 for indices.

! For calculation of TIx, remember that the matrix V is packed into a
! lower triangle so that each column starts from the diagonal. Thus we
! accumulate TIx when either the row or column matches JPNX.

! Return values:
!      PDOLEV - (function return) the leverage value of this reflection
!      TIX    - the value of ziVn for the selected parameter (JPNX)
!      RED    - the amount by which repeated measurement of this
!               reflection will reduce the JPNXth parameter's variance.

! if JPNX is zero then we use the VCVVEC to pre and post multiply each
! (Zit)(Zi) matrix, and get the stuff.


 write(125,'(1000G15.9)')(DF(I),I=1,NDF)
 write(126,'(4I12)')N12,N11,NDF,IVCVVSZ


 M11 = 1
 PII = 0.0
 TIx = 0.0
 TITMP=0.0
 JPN = JPNX - 1

 
 do I = 1,N12,MD12B        ! Loop over each block
     IBS = L12(I+1)             ! IBS:= Number of rows in block
         do J = 0, IBS-1            ! Loop over each row
             do K = 0, IBS-J-1          ! Loop over each column.
                 DOUB = 2.0                 ! Add in off-diagonals twice.
                 if ( K.EQ.0 ) DOUB = 1.0   ! Add on-diagonals once.
                 PII = PII + DOUB * DF(1+J) * DF(1+J+K) * V(M11)
                 if ( J .EQ. JPN ) then   ! This is the row of interest for Tij
                     TIx = TIx + DF(1+J+K) * V(M11)
                 else if ( J+K .EQ. JPN ) then   ! This is also the row of interest for Tij
                     TIx = TIx + DF(1+J) * V(M11)
                 else if ( JPNX .LT. 0 ) then !Accumulate whole of ti
                     TITMP= TITMP + VCVVEC(1+J) *DF(1+J+K) *V(M11)
                 if (K.NE.0) then
                     TITMP=TITMP+VCVVEC(1+J+K)*DF(1+J)*V(M11)
                 end if
             end if
             M11 = M11 + 1
         end do
     end do
 end do

 if ( JPNX .LT. 0 ) then
     TIx = TITMP
 end if

 RED = (TIX**2)/(1.0+PII)
 PDOLEV = PII
END

!CODE FOR XSFLSX
subroutine XSFLSX(acd, bcd, ac, bc, nn, nm, tc, sst, smin, smax, nl, nr, jo, jp, g2, m12, md12a, store, istore)
!
!--MAIN S.F.L.S. LOOP  -  CALCULATES A AND B AND THEIR DERIVATIVES
!
!  NL     ELEMENT NUMBER OF THIS REFLECTION (MAY BE SET TO 0)
!  T      TEMPERATURE FACTOR
!  FOCC   FORMFACTOR * SITE OCC * CHEMICAL OCC * DifABS CORECTION
!  TFOCC  T*FOCC
!  AP     A PART FOR EACH SYMMETRY POSITION FOR EACH ATOM
!  BP     B PART FOR EACH SYMMETRY POSITION FOR EACH ATOM
!  BT     TOTAL B PART FOR EACH ATOM
!  AT     TOTAL A PART FOR EACH ATOM

!--
#if defined(_GIL_) || defined(_LIN_) 
use sleef    
#endif
!include 'ISTORE.INC'
!include 'STORE.INC'
!use store_mod, only:
!include 'XSFWK.INC90'
use xsfwk_mod, only: anom
!include 'XWORKB.INC'
use xworkb_mod, only: jr, jq, jn ! always constant in xsflsc and read only
!include 'XSFLSW.INC90'
use xsflsw_mod, only: sfls_type, sfls_refine, jref_stack_start
use xsflsw_mod, only: cos_only, centro, iso_only, anomal
!include 'XLST01.INC90'
use xlst01_mod, only: l1s, l1a ! always constant in xsflsc and read only
!include 'XLST02.INC90'
use xlst02_mod, only: n2, n2t, md2t, md2i, md2, l2t, l2i, l2 ! always constant in xsflsc and read only
!include 'XLST03.INC90'
use xlst03_mod, only: n3, md3tr, md3ti, l3tr, l3ti  ! always constant in xsflsc and read only
!include 'XLST05.INC90'
use xlst05_mod, only: n5, md5a, l5 ! always constant in xsflsc and read only
!include 'XLST06.INC90'
use xlst06_mod, only: m6 ! always constant in xsflsc and read only
!include 'XLST12.INC90'
use xlst12_mod, only: n12, l12 ! always constant in xsflsc and read only
!include 'XUNITS.INC90'
!
!include 'QSTORE.INC'
use xconst_mod, only: zero, twopis, twopi
implicit none

real aimag, ap, at, bd, bf, bp, bt, focc, fried, tfocc, t, pshift
real dd
real aci, bci
integer ljs, ljt, lju, ljv, ljw, ljx, ljy, ljz
integer n, j

! moved from common blocks to local
integer JREF_STACK_PTR, ni, m2, m2t, m2i, m3ti, m3tr, m5a, m12a, l12a
real st, s, c, a

real FLAG
LOGICAL ATOM_REFINE

!-C-C-...FOR STRUCTURE FACTOR-CALCULATION
DOUBLE PRECISION SLRFAC
!-C-C-...FOR DERIVATIVES
DOUBLE PRECISION DSIZE, DDECLINA, DAZIMUTH

real ALPD(14),BLPD(14)   ! Use local arrays for better optimisation?

integer ISTACK

real, intent(out) :: ACD, BCD, tc, sst
real, intent(inout) :: smin, smax, bc, ac
real, dimension(:), intent(inout) :: store
integer, dimension(:), intent(inout) :: istore
integer, intent(inout) :: nn, nm, m12, md12a
integer, intent(in) :: nl, nr, jo, jp
real, intent(in) :: g2

#if defined(_GIL_) || defined(_LIN_) 
real, dimension(2) :: scb
#endif
DD=1.0/TWOPI

ISTACK=-1   ! CLEAR OUT A FEW CONSTANTS
AC=0.
BC=0.
ACI=0.
BCI=0.
ACD=0.
BCD=0.
!--SEARCH FOR THIS REFLECTION IN THE REFLECTION HOLDING STACK
JREF_STACK_PTR=JREF_STACK_START
LJX=NM
!--FETCH THE INFORMATION FOR THE NEXT REFLECTION IN THE STACK
STACKSEARCH: do WHILE(.TRUE.)
    NI=ISTORE(JREF_STACK_PTR)
    LJU=ISTORE(NI+9)
    LJV=ISTORE(NI+10)
!--LOOP OVER THE EQUIVALENT POSITIONS STORED
    do LJW=LJU,LJV,NR
        PSHifT=STORE(LJW+3)
        FRIED=1.0
!--CHECK THE GIVEN INDICES
        BD = ABS(STORE(M6)  -STORE(LJW)  ) &! 0 if same indices
        &   +ABS(STORE(M6+1)-STORE(LJW+1)) &
        &   +ABS(STORE(M6+2)-STORE(LJW+2))   
        BF = ABS(STORE(M6)+STORE(LJW)    ) & ! 0 if Friedel opposite
        &   +ABS(STORE(M6+1)+STORE(LJW+1)) &
        &   +ABS(STORE(M6+2)+STORE(LJW+2))
!sjwsep2010 Check the BATCH numbers for refinement of dual Wave data
!          bdf = abs(store(m6+13)-store(ni+20))
!
        if ( BF .LT. 0.5 ) then 
            PSHifT=-PSHIFT   ! USE FRIEDEL'S LAW
            FRIED=-1.0
        end if

!        LOOK FOR REFLECTION IN THE STACK
!djwsep2010 if ((BD.LT.0.5) .OR. (BF.LT.0.5)) then ! REFLECTION FOUND IN THE STACK
        if ((BD.LT.0.5) .OR. (BF.LT.0.5)) then ! REFLECTION FOUND IN THE STACK
!djwjan2011          if (((BD.LT.0.5) .OR. (BF.LT.0.5)).and.(bdf .lt. 0.5))THEN 
            LJY=NI
            if(LJX.GT.0) then  ! CHECK IF WE HAVE USED IT BEFORE
!--WE NEED THIS REFLECTION TWICE
                do WHILE ( ISTORE(NI).GT.0 )  ! FIND THE END BLOCK
                    JREF_STACK_PTR=NI
                    NI=ISTORE(NI)
                end do

                LJU=NI
                LJV=LJY
                ! DUPLICATE THE ENTRY  -  TRANSFER A, B ETC.
                STORE(NI+3:Ni+7)=STORE(LJY+3:LJY+7)
                STORE(NI+13:NI+17)=STORE(LJY+13:LJY+17)
                if( SFLS_TYPE .EQ. SFLS_REFINE ) then  ! WE ARE DOING REFINEMENT
                    LJX=ISTORE(NI+18)  ! TRANSFER THE P.D.'S
                    LJU=ISTORE(LJY+18)
                    LJV=ISTORE(LJY+19)
                    N = LJV - LJU
                    STORE(LJX:LJX+N) = STORE(LJU:LJU+N)
                end if

                LJX=ISTORE(NI+9)   ! TRANSFER THE EQUIVALENT INDICES
                LJU=ISTORE(LJY+9)
                LJV=ISTORE(LJY+10)
                do J=LJU,LJV,NR
                    STORE(LJX:LJX+3)=STORE(J:J+3)
                    LJX=LJX+NR
                end do
            end if
            EXIT STACKSEARCH
        end if
    END do 

!--NOT THIS EQUIVALENT

    if(ISTORE(NI).LE.0) then ! CHECK IF THERE ARE MORE IN THE STACK
!--THIS IS THE END OF THE STACK  -  WE MUST do A CALCULATION HERE
        ISTACK=0
        NN=NN+1
        PSHifT=0.
        FRIED=1.0
        EXIT STACKSEARCH
    end if

    LJX=LJX-1  ! SET UP THE FLAGS FOR THE NEXT REFLECTION IN THE STACK
    JREF_STACK_PTR=NI
END do STACKSEARCH


ISTORE(JREF_STACK_PTR)=ISTORE(NI)   ! SWITCH THE CURRENT BLOCK TO 
ISTORE(NI)=ISTORE(JREF_STACK_START)   ! THE TOP OF THE STACK
ISTORE(JREF_STACK_START)=NI

STORE(NI+3)=STORE(M6)   ! SET UP THE CURRENT SET OF INDICES
STORE(NI+4)=STORE(M6+1)
STORE(NI+5)=STORE(M6+2)
!djwsep2010 Put the BATCH number into the stack
!      store(ni+20)=store(m6+13)
ISTORE(NI+8)=NL
STORE(NI+11)=PSHifT
STORE(NI+12)=FRIED
NM=NM+1

if(ISTACK.LT.0)return  ! CHECK IF WE MUST CALCULATE THIS REFLECTION
! Rollett 5.12.5-7
!--calculate the information for the symmetry positions
M2=L2
M2T=L2T
do LJZ=1,N2
! compute h' = S.h
    STORE(M2T)=STORE(M6)*STORE(M2)+STORE(M6+1)*STORE(M2+3)+STORE(M6+2)*STORE(M2+6)
    STORE(M2T+1)=STORE(M6)*STORE(M2+1)+STORE(M6+1)*STORE(M2+4)+STORE(M6+2)*STORE(M2+7)
    STORE(M2T+2)=STORE(M6)*STORE(M2+2)+STORE(M6+1)*STORE(M2+5)+STORE(M6+2)*STORE(M2+8)
! calculate the h.t terms
    STORE(M2T+3)=(STORE(M6)*STORE(M2+9)+STORE(M6+1)*STORE(M2+10)+STORE(M6+2)*STORE(M2+11))
    if ( ( LJZ .EQ. 1 ) .OR. ( .NOT. ISO_ONLY ) ) then 
!
! aniso contributions are required
! compute h'.h', h'.k' etc 
!
        STORE(M2T+4:M2T+6)=STORE(M2T:M2T+2)**2
        STORE(M2T+7)=STORE(M2T+1)*STORE(M2T+2)
        STORE(M2T+8)=STORE(M2T)*STORE(M2T+2)
        STORE(M2T+9)=STORE(M2T)*STORE(M2T+1)
    end if
    STORE(M2T:M2T+3)=STORE(M2T:M2T+3)*TWOPI
    M2=M2+MD2
    M2T=M2T+MD2T
end do
!
!--calculate sin(theta)/lambda squared
! Rollett 5.12.8  h"= Uh, U is reciprocal orhogonalisation matrix
! Rollett 5.12.8  sst = h"^t.h" = [sin(theta)/lambda]^2
!
SST=STORE(L1S)*STORE(L2T+4)+STORE(L1S+1)*STORE(L2T+5) &
&   +STORE(L1S+2)*STORE(L2T+6)+STORE(L1S+3)*STORE(L2T+7) &
&   +STORE(L1S+4)*STORE(L2T+8)+STORE(L1S+5)*STORE(L2T+9)
ST=SQRT(SST)
SMIN=MIN(SMIN,ST)
SMAX=MAX(SMAX,ST)
!
!--The temperature factor coefficient TC = -8 Pi^2 [sin(theta)/lambda]^2
!
TC=-SST*TWOPIS*4.
!--CHECK if THE ANISO TERMS ARE REQUIRED
if(.NOT. ISO_ONLY) then 
    M2T=L2T
    do LJZ=1,N2
!
! compute h* = h'.k'.a*.b* etc.
!
        STORE(M2T+4:M2T+9)=STORE(M2T+4:M2T+9)*STORE(L1A:L1A+5)
        M2T=M2T+MD2T
    end do
end if
!
!  st  the value of sin(theta)/lambda for the calculation
!  l3tr and l3ti the real and imaginary components of the scattering factor
!
call XSCATT(ST)  ! CALCULATE THE FORM FACTORS
!      write(NCWU,'(A,F16.9,1x,Z0)')'ST:',ST,ST
!      write(NCWU,'(A,4(Z0,1X,F20.16,1X))')'COS consts:',C0,C0,C1,C1,
!     1            C2,C2,C3,C3
!      write(NCWU,'(A,4(Z0,1X,F20.16,1X))')'SIN consts:',S0,S0,S1,S1,
!     1            S2,S2,S3,S3

  
!
! compute the ratio of imaginary to real form (scattering) factors
! This will be a computational convenience later
! Results stored in a stack with one row per element type
! G2 is number of Non-primitive lattice translations (*2 if centre of symmetry)
! T2 is the total number of operators = G2*NOP
!
! For efficiency, the formfactor is multiplied by the number of 
! non-unique operators, G2 before summation over the unique operators
!  Rollett, page 45
!
M3TR=L3TR  
M3TI=L3TI
do LJZ=1,N3
!         STORE(M3TR)=STORE(M3TR+nint(store(m6+13))-1)*G2
!         STORE(M3TI)=STORE(M3TI+nint(store(m6+13))-1)*G2
!         write(NCWU,'(A,F16.9,1x,Z0)')'M3TR1:',STORE(M3TR),STORE(M3TR)
    STORE(M3TR)=STORE(M3TR)*G2
    STORE(M3TI)=STORE(M3TI)*G2
    if(STORE(M3TR).LE.ZERO)THEN  ! real PART IS ZERO  
        STORE(M3TI)=0. ! SO IS THE IMAGINARY NOW
    else   ! real PART IS OKAY
        STORE(M3TI)=STORE(M3TI)/STORE(M3TR)
    end if
!        write(NCWU,'(A,F16.9,1x,Z0)')'M3TR2:',STORE(M3TR),STORE(M3TR)
    M3TR=M3TR+MD3TR  ! UPDATE THE POINTERS
    M3TI=M3TI+MD3TI
end do
if(SFLS_TYPE .EQ. SFLS_REFINE) then    ! CHECK IF WE ARE DOING REFINEMENT
    STORE(JO:JP)=0.           ! CLEAR THE FINAL PARTIAL DERIVATIVE AREA TO ZERO
    LJS=JR
    N = N12*JQ
    STORE(LJS:LJS+N-1) = 0.0! CLEAR THE TEMPORARY PARTIAL DERIVATIVE AREAS TO ZERO
    LJS=JN
    STORE(LJS:LJS+JQ-1)=0.  ! CLEAR THE DUMMY LOCATIONS
    M12=L12                  ! SET THE ATOM POINTER IN LIST 12
end if
!
!--START OF THE LOOP BASED ON THE ATOMS
!
M5A=L5
do LJY=1,N5
    AT=0.  ! CLEAR THE ACCUMULATION VARIABLES
    BT=0.

    ATOM_REFINE = .FALSE. 

    if(SFLS_TYPE .EQ. SFLS_REFINE) then   ! CHECK IF REFINEMENT IS BEING DONE
        !call XZEROF ( ALPD(1),11 )  ! CLEAR PARTIAL DERIVATIVE STACKS
        ALPD(1:11)=0.0
        !call XZEROF ( BLPD(1),11 )
        BLPD(1:11)=0.0
        L12A=ISTORE(M12+1)
        if ( L12A .GE.0 ) ATOM_REFINE = .TRUE.  ! Set if any params of this atom are being refined
        M12=ISTORE(M12)
    end if
!djwsep2010 extend to use dual wavelength anomalous scattering as appropriate 
    M3TR=L3TR+ISTORE(M5A)*MD3TR  ! PICK UP THE FORM FACTORS FOR THIS ATOM
    M3TI=L3TI+ISTORE(M5A)*MD3TI
!
! focc   formfactor * site occ * chemical occ * difabs corection
! modify focc for other fc corrections 
!
    FOCC = STORE(M3TR) * STORE(M5A+2) * STORE(M5A+13) 

    FLAG=STORE(M5A+3)   ! PICK UP THE TYPE OF THIS ATOM
    if(NINT(FLAG) .EQ. 1) then  ! CHECK THE TEMPERAURE TYPE FOR THIS ATOM
!
! calculate the iso-temperature factor coefficients for this atom
! TC = -8 Pi^2 [sin(theta)/lambda]^2
! T = exp(Uiso *TC)
!
#if defined(_GIL_) || defined(_LIN_) 
        T=sleef_expf(real(STORE(M5A+7)*TC))  
#else
        T=EXP(STORE(M5A+7)*TC)  
#endif
        TFOCC=T*FOCC
    end if
!
! L2T is address of symmetry transformed index
!
    M2T=L2T
    M2=L2   ! M2 (ADDR. FOR TRANSF.MAT.) IS RESET TO ADDR. FOR 1ST SYM.OP.
!
! loop cycling over the different equivalent reflections for this atom
!
!  calculate a = h'.x + h.t
    do LJX=1,N2T
        A=STORE(M5A+4)*STORE(M2T)+STORE(M5A+5)*STORE(M2T+1)+ &
        &   STORE(M5A+6)*STORE(M2T+2)+STORE(M2T+3)              
!  slrfac starting-values for special shape factors and derivatives
        SLRFAC=1.0 
        DSIZE=1.0
        DDECLINA=1.0
        DAZIMUTH=1.0

        if (NINT(FLAG) .EQ. 0) then   
!
!  calculate the aniso-temperature factor
!  T=exp(h*Uij + ...)
!  store(mt2+..) is h* where h* = h'.k'.a*.b* etc.

!
#if defined(_GIL_) || defined(_LIN_) 
            T=sleef_expf(real(STORE(M5A+7)*STORE(M2T+4) &
            &   +STORE(M5A+8)*STORE(M2T+5) &
            &   +STORE(M5A+9)*STORE(M2T+6)+STORE(M5A+10)*STORE(M2T+7) &
            &   +STORE(M5A+11)*STORE(M2T+8)+STORE(M5A+12)*STORE(M2T+9)))
            TFOCC=T*FOCC
#else
            T=EXP(STORE(M5A+7)*STORE(M2T+4)+STORE(M5A+8)*STORE(M2T+5) &
            &   +STORE(M5A+9)*STORE(M2T+6)+STORE(M5A+10)*STORE(M2T+7) &
            &   +STORE(M5A+11)*STORE(M2T+8)+STORE(M5A+12)*STORE(M2T+9))
            TFOCC=T*FOCC
#endif
!
        else if ( NINT(FLAG) .GE. 2) then
            if (NINT(FLAG) .EQ. 2) then  ! CALC SPHERE TF
                call XSPHERE (ST, M5A, SLRFAC, DSIZE)
            else if (NINT(FLAG) .EQ. 3) then   ! CALC LINE TF
                call XLINE (M2, M5A, M6, SLRFAC, DSIZE, DDECLINA,DAZIMUTH)
            else if (NINT(FLAG) .EQ. 4) then   ! CALC RING TF
                call XRING (M2, ST, M5A,M6,SLRFAC,DSIZE,DDECLINA,DAZIMUTH)
            end if
#if defined(_GIL_) || defined(_LIN_) 
            T=sleef_expf(real(STORE(M5A+7)*TC))
#else
            T=EXP(STORE(M5A+7)*TC)
#endif
            TFOCC=T*FOCC
            TFOCC=TFOCC*SLRFAC
        end if

!--CALCULATE THE SIN/COS TERMS   
! Chebychev approximation replaced with standard calls or sleef
!  dd = 1.0/twopi
!  a = h'.x + h.t
!
#if defined(_GIL_) || defined(_LIN_) 
        c = mod(a,2.0*3.14159265359)
        call sleef_sincosf(c, scb)          
! s = Sin(h'x+ht)
        s=scb(1)
!c c = Cos(h'x+ht)
        c=scb(2)
#else
!c c = Cos(h'x+ht)
        c = cos(a)
! s = Sin(h'x+ht)
        s = sin(a)
#endif
!c
!c Test if  centro with no refinement  -  only cos terms needed
        if(.not. COS_ONLY) then 
!c
!--CALCULATE THE B CONTRIBUTION
            BP=S*TFOCC
            BT=BT+BP
        end if
!
!--CALCULATE THE A CONTRIBUTION
        AP=C*TFOCC
        AT=AT+AP
!          write(NCWU,'(A,Z0,1X,F15.6)')'AT:',AT,AT
!          write(NCWU,'(A,Z0,1X,F15.6)')'BT:',BT,BT
!         write(NCWU,'(A,2(1X,Z0,1X,F20.16))')'SIN:',S,S, aaas, aaas
!         write(NCWU,'(A,2(1X,Z0,1X,F20.16))')'COS:',C,C, aaac, aaac

!--CHECK if ANY REFINEMENT IS BEING DONE
        if(ATOM_REFINE)THEN
!
!  store(mt2+ 0 to 2) is h' 
!  store(mt2+ 4 to 9) is h* where h* = h'.k'.a*.b* etc.
!  T=exp(h*Uij + ... ) where h* = h'.k'.a*.b* etc.
!  c = cos(hx)
!
!-CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR X,Y AND Z
!-C-C-CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR OCC,X,Y AND Z
            ALPD(1)=ALPD(1)+T*C*SLRFAC
            ALPD(3)=ALPD(3)-STORE(M2T)*BP
            ALPD(4)=ALPD(4)-STORE(M2T+1)*BP
            ALPD(5)=ALPD(5)-STORE(M2T+2)*BP
!--CHECK THE TEMPERATURE FACTOR TYPE
            if(NINT(FLAG) .NE. 1) then
!-C-C-CHECK WHETHER WE HAVE SPHERE, LINE OR RING
                if (NINT(FLAG) .LE. 1) then
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR THE ANISO-TERMS
                    ALPD(6:11)=ALPD(6:11)+STORE(M2T+4:M2T+9)*AP
                else
!-C-C-CALC. THE PART. DERIV. W.R.T. A FOR ISO-TERM + SPECIAL FIGURES
                    ALPD(6)=ALPD(6)+TC*AP
                    ALPD(7)=ALPD(7)+((DSIZE*AP)/SLRFAC)
                    ALPD(8)=ALPD(8)+((DDECLINA*AP)/SLRFAC)
                    ALPD(9)=ALPD(9)+((DAZIMUTH*AP)/SLRFAC)
                end if
            else
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR U[ISO]
                ALPD(6)=ALPD(6)+TC*AP
            end if

!--GOTO THE NEXT PART - DEPENDS ON WHETHER THE STRUCTURE IS CENTRO
            if(.NOT. CENTRO) then
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR X,Y AND Z
!-C-C-CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR OCC,X,Y AND Z
                BLPD(1)=BLPD(1)+T*S*SLRFAC
                BLPD(3)=BLPD(3)+STORE(M2T)*AP
                BLPD(4)=BLPD(4)+STORE(M2T+1)*AP
                BLPD(5)=BLPD(5)+STORE(M2T+2)*AP
!--CHECK THE TEMPERATURE FACTOR TYPE
                if(NINT(FLAG) .NE. 1) then
!-C-C-CHECK WHETHER WE HAVE SPHERE, LINE OR RING
                    if (NINT(FLAG) .LE. 1) then
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR THE ANISO-TERMS
                        BLPD(6:11)=BLPD(6:11)+STORE(M2T+4:M2T+9)*BP
                    else
!-C-C-CALC. THE PART. DERIV. W.R.T. B FOR ISO-TERM + SPECIAL FIGURES
                        BLPD(6)=BLPD(6)+TC*BP
                        BLPD(7)=BLPD(7)+((DSIZE*BP)/SLRFAC)
                        BLPD(8)=BLPD(8)+((DDECLINA*BP)/SLRFAC)
                        BLPD(9)=BLPD(9)+((DAZIMUTH*BP)/SLRFAC)
                    end if
                else
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR U[ISO]
                    BLPD(6)=BLPD(6)+TC*BP
                end if
            end if
        end if

        M2T=M2T+MD2T  ! UPDATE THE SYMMETRY INFORMATION POINTER
        M2=M2+MD2     ! M2 (ADDR. FOR TRANSF.MAT.) IS INCREASED FOR NEXT SYM.OP.
    END do    ! LOOP ON EQUIVALENT POSITIONS ENDS  -  COMPUTE THE TOTALS FOR THIS ATO

    AC=AC+AT
    BC=BC+BT

    if (ANOMAL) then  ! CHECK IF ANOMALOUS DISPERSION IS BEING CONSIDERED
        AIMAG=ANOM*STORE(M3TI)  ! CALCULATE THE IMAGINARY PARTS
        ACI=ACI-BT*AIMAG
        BCI=BCI+AT*AIMAG
        if (SFLS_TYPE .EQ. SFLS_REFINE) then   ! ANY REFINEMENT AT ALL?
            ACD=ACD-BT*STORE(M3TI)   ! DERIVATIVES FOR POLARITY PARAMETER
            BCD=BCD+AT*STORE(M3TI)
        end if
    end if


    if(ATOM_REFINE)THEN  ! CHECK IF ANY REFINEMENT IS BEING DONE
        ALPD(1) = STORE(M3TR) * STORE(M5A+13) * ALPD(1)  ! CALCULATE THE PARTIAL DERIVATIVES 
        BLPD(1) = STORE(M3TR) * STORE(M5A+13) * BLPD(1)  ! W.R.T. A AND B FOR OCC

        do WHILE (L12A.GT.0)  ! LOOP ADDING THE PARTIAL DERIVATIVES INTO THE TEMPORARY STACKS

            M12A=ISTORE(L12A+4)
            MD12A=ISTORE(L12A+1)  ! SET UP THE CONDITIONS OF THIS ATOM
            LJU=ISTORE(L12A+2)
            LJV=ISTORE(L12A+3)

            if(MD12A.LT.2)THEN    ! WEIGHTS ARE UNITY
                if ( CENTRO ) then
                    if ( ANOMAL ) then    ! UNITY, CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+ALPD(M12A-1)
                            STORE(LJT+1)=STORE(LJT+1)+ALPD(M12A-1)*AIMAG
                            M12A=M12A+1
                        end do
                    else                 ! UNITY, CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+ALPD(M12A-1)
                            M12A=M12A+1
                        end do
                    end if
                else
                    if ( ANOMAL ) then    ! UNITY, NON-CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+ALPD(M12A-1)
                            STORE(LJT+3)=STORE(LJT+3)+ALPD(M12A-1)*AIMAG
                            STORE(LJT+2)=STORE(LJT+2)-BLPD(M12A-1)*AIMAG
                            STORE(LJT+1)=STORE(LJT+1)+BLPD(M12A-1)
                            M12A=M12A+1
                        end do
                    else                  ! UNITY, NON-CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+ALPD(M12A-1)
                            STORE(LJT+1)=STORE(LJT+1)+BLPD(M12A-1)
                            M12A=M12A+1
                        end do
                    end if
                end if
            else       ! WEIGHTS DifFER FROM UNITY
                if ( CENTRO ) then
                    if ( ANOMAL ) then    ! NON-UNITY, CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            A=ALPD(M12A-1)*STORE(LJW+1)
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+A
                            STORE(LJT+1)=STORE(LJT+1)+A*AIMAG
                            M12A=M12A+1
                        end do
                    else                 ! NON-UNITY, CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+ALPD(M12A-1)*STORE(LJW+1)
                            M12A=M12A+1
                        end do
                    end if
                else
                    if ( ANOMAL ) then  ! NON-UNITY, NON-CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+ALPD(M12A-1)*STORE(LJW+1)
                            A=STORE(LJW+1)*AIMAG
                            STORE(LJT+3)=STORE(LJT+3)+ALPD(M12A-1)*A
                            STORE(LJT+2)=STORE(LJT+2)-BLPD(M12A-1)*A
                            STORE(LJT+1)=STORE(LJT+1)+BLPD(M12A-1)*STORE(LJW+1)
                            M12A=M12A+1
                        end do
                    else               ! NON-UNITY, NON-CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            STORE(LJT)=STORE(LJT)+ALPD(M12A-1)*STORE(LJW+1)
                            STORE(LJT+1)=STORE(LJT+1)+BLPD(M12A-1)*STORE(LJW+1)
                            M12A=M12A+1
                        end do
                  end if
                end if
            end if
            L12A=ISTORE(L12A)
        END do            
    end if
    M5A=M5A+MD5A
END do             ! END OF ATOM CYCLING LOOP

if(CENTRO) then ! CHECK IF THIS STRUCTURE IS CENTRO
    BC=0.         ! Zero appropriate parts.
    ACI=0.
end if

STORE(NI+13)=AC   ! STORE THE RESULTS OF THIS 
STORE(NI+14)=ACI  ! CALCULATION IN THE STACK
STORE(NI+15)=BC
STORE(NI+16)=BCI

!      write(NCWU,'(A,Z0,1X,F15.6)')'AC: ',AC,AC
!      write(NCWU,'(A,Z0,1X,F15.6)')'ACI:',ACI,ACI
!      write(NCWU,'(A,Z0,1X,F15.6)')'BC: ',BC,BC
!      write(NCWU,'(A,Z0,1X,F15.6)')'BCI:',BCI,BC


M2I=L2I
LJU=ISTORE(NI+9)  ! STORE THE EQUIVALENT INDICES AND THE PHASE SHifT
LJV=ISTORE(NI+10)
do LJW=LJU,LJV,NR
    STORE(LJW)=STORE(M6)*STORE(M2I)+STORE(M6+1)*STORE(M2I+3) &
    &   +STORE(M6+2)*STORE(M2I+6)
    STORE(LJW+1)=STORE(M6)*STORE(M2I+1)+STORE(M6+1)*STORE(M2I+4) &
    &   +STORE(M6+2)*STORE(M2I+7)
    STORE(LJW+2)=STORE(M6)*STORE(M2I+2)+STORE(M6+1)*STORE(M2I+5) &
    &   +STORE(M6+2)*STORE(M2I+8)
    STORE(LJW+3)=-(STORE(LJW)*STORE(M2I+9) &
    &   +STORE(LJW+1)*STORE(M2I+10) &
    &   +STORE(LJW+2)*STORE(M2I+11))*TWOPI
    M2I=M2I+MD2I
end do

if(SFLS_TYPE .EQ. SFLS_REFINE) then    ! CHECK IF WE ARE DOING REFINEMENT
    LJU=ISTORE(NI+18)    ! TRANSFER THE P.D.'S TO THE STACK
    LJV=ISTORE(NI+19)
    LJS=JR
    do LJW=LJU,LJV
        STORE(LJW)=STORE(LJS)
        LJS=LJS+1
    end do
end if
END

!CODE FOR XAB2FC
subroutine XAB2FC(FC, P, act, bct, acn, bcn, ace, acf, store, istore, scalew, jp, jo, jref_stack_ptr, acd, bcd)
!--CONVERSION OF THE A AND B PARTS INTO /FC/ TERMS
!
!  ICONT  SET TO THE return ADDRESS
!  JO     ADDRESS OF THE AREA FOR THE OUTPUT DERIVATIVES W.R.T. /FC/
!  JP     LAST WORD OF THE ABOVE AREA
!  JREF_STACK_PTR     ADDRESS OF THIS REFLECTION IN THE STACK

! all module variables used here are read only

!include 'ISTORE.INC'
!include 'STORE.INC'
!use store_mod, only:store, istore
!include 'XSFWK.INC90'
use xsfwk_mod, only: enant, cenant ! constant in xsflc
!include 'XWORKB.INC'
use xworkb_mod, only: jn, jq ! constant in xsflc
!include 'XSFLSW.INC90'
use xsflsw_mod, only: sfls_type, sfls_refine, enantio, centro, anomal ! constant in xsflc
!include 'XLST06.INC90'
use xconst_mod, only: zero, twopi

implicit none

!include 'QSTORE.INC'

real cosa, cospn, fcsq, fesq, fn, fnsq, fp, fried, pshift
real sina, sinpn, temp, sinp, cosp, aci, bci, bc, ac
real, intent(out) :: fc, p
real, intent(inout) :: act, bct, acn, bcn, ace, acf
real, dimension(:), intent(inout) :: store
integer, dimension(:), intent(inout) :: istore
real, intent(in) :: scalew
integer, intent(in) :: jp, jo, jref_stack_ptr
real, intent(in) :: acd, bcd
integer j, ljs, n

!--FETCH A AND B ETC. FROM THE STACK
AC=STORE(JREF_STACK_PTR+13)
ACI=STORE(JREF_STACK_PTR+14)
BC=STORE(JREF_STACK_PTR+15)
BCI=STORE(JREF_STACK_PTR+16)
PSHifT=STORE(JREF_STACK_PTR+11)
FRIED=STORE(JREF_STACK_PTR+12)

ACT=AC+ACI*FRIED+ACT
BCT=BC*FRIED+BCI+BCT

if ( ABS(ACT) .LT. 0.001 .and. ABS(BCT) .LT. 0.001) then  ! A and B-PART are 0
    ACT = 0.000001
    BCT = 0.
end if


!--COMPUTE /FC/ AND THE PHASE FOR THE GIVEN ENANTIOMER
FCSQ = ACT*ACT + BCT*BCT
FP = SQRT(FCSQ)
FC = FP                     ! SAVE THE TOTAL MAGNITUDE
P=AMOD(ATAN2(BCT,ACT)+PSHifT,TWOPI)  ! THE PHASE

if (ENANTIO) then
    ACN = ACN+AC-ACI*FRIED   ! COMPUTE FRIEDEL PAIR
    BCN = BCN+BCI-BC*FRIED
    FNSQ = ACN*ACN + BCN*BCN
    FN = SQRT (FNSQ)

    FESQ = FCSQ*CENANT + FNSQ*ENANT   ! THE TOTAL EQUIVALENT INTENSITY
    if (FESQ .LE. 0.0) then
        FC = SIGN(1.,FESQ)*SQRT(max(zero,ABS (FESQ)))
        !print *, 'I should not be here! (xab2fc)'
        !stop
    else
        FC = SQRT(FESQ)
    end if

    COSA = CENANT * FP / FC   ! THE RELATIVE CONTRIBUTIONS 
    SINA =  ENANT * FN / FC   ! OF THE COMPONENTS
else
    FNSQ = FCSQ
end if

! these are used in test2.tst
! program crashes if they are not set
STORE(JREF_STACK_PTR+6) = FC
STORE(JREF_STACK_PTR+7) = P

if(SFLS_TYPE .EQ. SFLS_REFINE) then   ! CHECK IF WE ARE DOING REFINEMENT
    LJS=ISTORE(JREF_STACK_PTR+18)     ! TRANSFER PARTIAL DERIVATIVES FROM TEMPORARY
    TEMP = SCALEW / FC   ! TO PERMANENT STORE
    COSP = ACT * TEMP
    SINP = BCT * TEMP
    COSPN = ACN * TEMP
    SINPN = BCN * TEMP
    ACE  = 0.5 * (FNSQ-FCSQ) * TEMP

    if ( CENTRO .EQV. ANOMAL ) then ! NON-CENTRO WITHOUT ANOMALOUS DISPERSION
                                    ! OR CENTRO WITH ANOMALOUS
        if ( .NOT. CENTRO ) SINP=SINP*FRIED ! NON-CENTRO WITHOUT AD
        N = JP-JO
        STORE(JO:JP) = STORE(LJS:LJS+N*JQ:JQ)*COSP+STORE(LJS+1:LJS+N*JQ+1:JQ)*SINP
        ACF = BCD*SINP
        if (ENANTIO) then   ! MODIFY THE EXISTING DERIVATIVES
            LJS = ISTORE(JREF_STACK_PTR+18)
            N = JP-JO
            STORE(JO:JP) = STORE(JO:JP)*COSA + &
            &   SINA*(STORE(LJS:LJS+N*JQ:JQ)*COSPN + &
            &   STORE(LJS+1:LJS+N*JQ+1:JQ)*SINPN)
            ACF = ACF * COSA + SINA * BCD * SINPN
        end if
        STORE(JN+1)=0.0
        STORE(JN)=0.0
    else if ( CENTRO .AND. (.NOT. ANOMAL) ) then ! CENTRO WITHOUT ANOMALOUS DISPERSION
        N = JP-JO
        STORE(JO:JP) = STORE(LJS:LJS+N*JQ:JQ)*COSP
        STORE(JN)=0.0
    else                              ! NON-CENTRO WITH ANOMALOUS DISPERSION
        N = JP-JO
        STORE(JO:JP) = (STORE(LJS:LJS+N*JQ:JQ) + &
        &   STORE(LJS+2:LJS+N*JQ+2:JQ)*FRIED)*COSP + &
        &   (STORE(LJS+1:LJS+N*JQ+1:JQ)*FRIED + &
        &   STORE(LJS+3:LJS+N*JQ+3:JQ))*SINP
        ACF = (ACD * COSP * FRIED) + (BCD * SINP)
        if (ENANTIO) then  ! MODIFY THE EXISTING DERIVATIVES
            LJS = ISTORE(JREF_STACK_PTR+18)
            N = JP-JO
            STORE(JO:JP) = STORE(JO+JP)*COSA + SINA * ( &
            &   (STORE(LJS:LJS+N*JQ:JQ)-STORE(LJS+2:LJS+N*JQ+2:JQ)* &
            &   FRIED)*COSPN + (STORE(LJS+3:LJS+N*JQ+3:JQ)- &
            &   STORE(LJS+1:LJS+N*JQ+1:JQ)* &
            &   FRIED)*SINPN )
            ACF = ACF*COSA + SINA * (BCD*SINPN - ACD*COSPN*FRIED)
        end if
        STORE(JN:JN+3)=0.0
    end if
end if            
END


subroutine XADDPD ( A, JX, JO, JQ, JR, md12a, m12, store, istore) 
!include 'ISTORE.INC'
!include 'STORE.INC'
!use store_mod, only: store, istore
!include 'XLST12.INC90'
!use xlst12_mod, only: md12a, m12
implicit none
!include 'QSTORE.INC'

real, intent(in) :: a
integer, intent(in) :: jx, jo, jq, jr
integer, intent(inout) :: md12a, m12
integer, dimension(:), intent(in) :: istore
real, dimension(:), intent(inout) :: store

integer ljt, lju

! moved from common block to local variable
integer l12a

!--ROUTINE TO ADD P.D.'S WITH RESPECT TO /FC/ FOR THE OVERALL PARAMETER
!  A     THE DERIVATIVE TO BE ADDED
!  JX    ITS POSITION IN THE OVERALL PARAMETER LIST SET IN M12
!  JO    ADDRESS COMPLETE PARTIAL DERIVATIVES
!  JQ    NUMBER OF PARTIAL DERIVATIVES PER REFLECTION (0,1,2 OR 4)
!  JR    ADDRESS PARTIAL DERIVATIVES BEFORE THEY ARE ADDED TOGETHER

! And in common:
!  M12   ADDRESS OF THE HEADER FOR THE PARAMETER IN LIST 12

!--SET UP THE LIST 12 FLAGS
L12A=ISTORE(M12+1)
do WHILE ( L12A .GT. 0 )
    if(ISTORE(L12A+4).LE.JX)THEN ! THE PART STARTS LOW ENOUGH DOWN
        MD12A=ISTORE(L12A+1)
        LJU=ISTORE(L12A+2)+(JX-ISTORE(L12A+4))*MD12A
        if(LJU.LE.ISTORE(L12A+3)) then  ! CHECK IF THIS PARAMETER IS IN RANGE
            LJT=(ISTORE(LJU)-JR)/JQ  ! FIND PARAMETER IN DERIVATIVE STACK
            if(LJT.GE.0)THEN        ! PARAMETER HAS BEEN REFINED?
                LJT=LJT+JO
                if(MD12A.LT.2)THEN  ! IS WEIGHT GIVEN OR ASSUMED UNITY?
                    STORE(LJT)=STORE(LJT)+A              ! THE WEIGHT IS UNITY
                else
                    STORE(LJT)=STORE(LJT)+A*STORE(LJU+1)  ! THIS WEIGHT IS GIVEN
                end if
            end if
        end if
    end if
    L12A=ISTORE(L12A)  ! PASS ONTO THE NEXT PART
end do
END
