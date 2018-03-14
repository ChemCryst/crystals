C $Log: not supported by cvs2svn $
C Revision 1.79  2012/01/04 14:31:25  rich
C Fix some uninitialized variables, and output format mistakes.
C
C Revision 1.78  2011/09/15 11:39:01  rich
C Send PT flag if atom list contains parts.
C
C Revision 1.77  2011/05/25 12:41:13  djw
C Increase field for atom count, remove training "."
C
C Revision 1.76  2011/05/04 11:27:25  rich
C Comment out debugging.
C
C Revision 1.75  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.74  2011/03/04 05:48:11  rich
C Ensure right C interfaces are used by right compilers (digital or gnu -type).
C
C Revision 1.73  2011/02/04 17:34:03  djw
C Extend parameter list on PRTGRP to enable selection by RESIDUE
C
C Revision 1.72  2005/02/25 17:25:20  stefan
C 1. Added some preprocessor if defined lines for the mac version.
C
C Revision 1.71  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.3  2005/01/07 11:56:53  rich
C Add some blank lines between some #if and #endifs.
C
C Revision 1.2  2004/12/13 16:16:08  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:09  rich
C New CRYSTALS repository
C
C Revision 1.70  2004/04/16 09:34:41  rich
C Change bonds from black to very dark grey.
C
C Revision 1.69  2004/02/13 12:15:05  rich
C Reduce sig figs in popup bond length display on model. These bond lengths
C can get out of date as they reflect the last time the bonding network
C was calculated, so 3 decimal places was a bit much.
C
C Revision 1.68  2004/02/05 09:29:50  rich
C Fix overlong lines.
C
C Revision 1.67  2004/02/04 16:58:00  stefan
C Changes for Mac command line version
C
C Revision 1.66  2003/11/07 10:43:24  rich
C Pass the assembly and group numbers up to the GUI.
C
C Revision 1.65  2003/10/31 13:37:36  rich
C Change the REFINE column in the atom list (now used for internal
C info indecipherable by humans) into a RESIDUE column. Prints the
C residue number, which is of course 0, unless you explicitly run
C \EDIT/insert residue/END, or run one of the MATCH/COMPARE things
C from the context menu.
C
C Revision 1.64  2003/10/31 12:42:18  rich
C If BONDTYPE is set to OFF, remove list of special bonds from list 41
C (L41S), since this bit is only ever changed by the BONDTY routine.
C If bond type in L41 is zero, display 'unassigned' on model, rather
C than memory access violation.
C
C Revision 1.63  2003/10/30 11:28:37  rich
C Dynamically update Input/Edit menu items in the X-ray data
C menu, to reflect whether they can be input or edited.
C
C Revision 1.62  2003/07/12 08:36:00  rich
C Yesterday's fix of CKP's ring bug was incorrect. THIS is the correct
C fix!
C
C Revision 1.61  2003/07/11 17:20:07  rich
C Kind of fix CKP's aromatic ring bug - they're still off centre, but
C at least in plane!
C
C Revision 1.60  2003/07/01 16:44:24  rich
C Store the fact that a list does not exist, so to only output this data once.
C
C Revision 1.59  2003/05/07 12:18:54  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.58  2003/03/20 16:10:36  rich
C
C Output bond types to the popup labels in the model window.
C
C Revision 1.57  2003/03/10 13:35:28  rich
C Output wavelength and radiation type.
C
C Revision 1.56  2003/03/06 15:13:28  rich
C Output twin laws to the information tab. It would be nice to get the twin
C scales in here too.
C
C Revision 1.55  2003/02/25 15:30:22  rich
C Output L12 & 16 to the info tabs.
C
C Revision 1.54  2003/02/20 15:59:51  rich
C Output list 4 info to the info tab in the GUI.
C
C Revision 1.53  2003/01/21 12:54:11  rich
C Commented out swathes of unused code in order to shrink
C the executable a bit.
C
C Revision 1.52  2003/01/16 11:42:12  rich
C Use new SAFESET instruction to update various GUI elements - if they
C don't exist, the program ignores the instruction. Means you can now
C remove or rename guimenu.srt to drop to a really basic version of
C CRYSTALS without getting lots of warnings.
C
C Revision 1.51  2003/01/14 10:14:26  rich
C g77 spots undeclared logical and doesn't support dynamic character arrays.
C
C Revision 1.50  2002/10/21 15:13:50  rich
C Fixed some compiler errors introduced by recent DVF version.
C
C Revision 1.49  2002/10/14 12:33:24  rich
C Support for DVF command line version.
C
C Revision 1.48  2002/10/02 13:39:17  rich
C Work out Uequiv - pass info to GUI.
C
C Revision 1.47  2002/07/29 13:00:49  richard
C Now that XGUIUP is called sometimes from inside #EDIT,
C it's important not to muck up the L5!
C
C Revision 1.46  2002/07/23 15:53:07  richard
C
C Only clear ERROR flag on general update call (IULN=0) from crystal.for. If
C internal call updating list 5, then set the list serial number to a different
C negative value so that the update goes ahead.
C
C Revision 1.45  2002/06/28 10:10:22  richard
C Minor gui update enabling display of special shapes: ring and sphere.
C
C Revision 1.44  2002/06/07 15:20:55  richard
C If sigma cutoff is <= -10, display 'none' in refinement tab.
C
C Revision 1.43  2002/04/30 20:19:56  richard
C RIC1: In XGUIUP - Keep going if some lists don't exist - was causing problems,
C e.g. formula (L29) not displayed in GUI until atoms (L5) were input. Fixed.
C RIC2: Also in XGUIUP - set the thermal parameters of Q atoms to represent their
C electron density - perhaps a little counterintuitive to crystallographers - big
C thermals usually mean e-density is too low.... We'll see.
C
C Revision 1.42  2002/03/21 17:50:34  richard
C Clear the error flag before doing bond calculations. (In case CRYSTALS had
C an error last instruction).
C
C Revision 1.41  2002/03/13 12:46:26  richard
C HUGE change. Re-written XGDBUP as XGUIUP - now called inbetween commands, so can load
C lists without worrying about use of store. Atoms and bonds now passed through FAST interface.
C List 41 updated as required. Atom types with UNKNOWN colour will revert to the colour in
C PROPWIN.DAT.
C
C Revision 1.40  2002/02/27 19:30:18  ckp2
C RIC: Increase lengths of lots of strings to 256 chars to allow much longer paths.
C RIC: Ensure consistent use of backslash after CRYSDIR:
C
C Revision 1.39  2001/10/18 10:02:49  ckp2
C When mouse hovers over bonds, display the fragment number as well as the length.
C
C Revision 1.38  2001/09/11 08:27:43  ckp2
C Cut down GUI traffic by only sending status updates for flags that have
C actually changed (Flags: L1, L2, L3, L5, L6, QS, IN)
C
C Revision 1.37  2001/07/19 08:01:00  ckp2
C Changed so that ISSUPD flag only stops the updating of List5, the other
C lists still update things in the GUI.
C
C Revision 1.36  2001/06/18 08:25:21  richard
C Platform specific file names were being overridden by a following statement which
C reset file name to the windows specific name.
C
C Revision 1.35  2001/06/17 14:20:27  richard
C Make bonds crossing symmetry elements lighter to distinguish them from normal bonds more.
C
C Revision 1.34  2001/06/08 15:02:51  richard
C Get F/F2 state for status window from L23 rather than L30.
C
C Revision 1.33  2001/03/16 17:10:41  richard
C Re-instate full search of atom list for bonds. Had changed it to pivot onwards,
C but this meant that bonds across symm ops, only one was drawn. Unfortunately, it now
C means that for normal bonds, twice as many as are needed are being sent to the
C GUI and rendered.
C Changed colour of bonds across symm ops to grey.
C
C Revision 1.32  2001/03/08 14:30:58  richard
C
C Remove "Too many contacts" message - failing silently is much much faster.
C XGDBUP is now called with common block address and length allowing
C all lists to be passed through this routine.
C Included calculations for drawing thermal ellipsoids. Speeded up
C bond search. Added atoms labels to bond info passed to GUI.
C Info extracted from LIST 1, LIST 2, LIST 29, LIST 30 and passed
C to the GUI.
C
C Revision 1.31  2001/01/22 16:48:26  richard
C Pass peak height (spare) as value*1000.
C
C Revision 1.30  2001/01/15 12:12:54  richard
C RIC: Prevent array overflow if too many contacts are found to an atom during
C a bond search. (More than 500)
C
C Revision 1.29  2000/12/13 17:47:38  richard
C Support for LINUX.
C
C Revision 1.28  2000/09/19 14:13:16  CKP2
C find colour table in SCRIPT
C
C Revision 1.27  2000/07/19 11:56:56  ckp2
C RIC: Fixed bug where GUI hangs when structure explodes...
C      I think.
C
C Revision 1.26  2000/07/11 11:04:08  ckp2
C Extra argument to KFLOPN, for specifying SEQUENTIAL or DIRECT access
C
C Revision 1.25  2000/07/04 13:43:32  ckp2
C RIC: Better colours for bond deviations using csd checks.
C
C Revision 1.24  2000/02/23 12:22:06  ckp2
C djw abortive attempt to trap NaN values
C
C Revision 1.23  2000/01/20 16:57:58  ckp2
C ric  fix square root problem
C
C Revision 1.22  1999/12/15 14:54:49  ckp2
C djw  Add set autoupdate on/off, force ON in summary.
C
C Revision 1.21  1999/09/22 16:11:37  ckp2
C RIC: Modified bond length tolerances to match Cameron, except that
C bonds shorter than 0.5*(sum of cov radii) will not be drawn.
C
C Revision 1.20  1999/08/03 09:17:18  richard
C RIC: Pass the SPARE value to the GUI (if available), otherwise pass the
C covalent radii. Spare is scaled by 0.01 to display on an angstrom scale.
C
C Revision 1.19  1999/07/30 20:30:13  richard
C RIC: If atoms have negative covalent radii, then don't bond them to
C anything, but still use the absolute value for the radius.
C
C Revision 1.18  1999/07/21 18:11:06  richard
C RIC: Remove defunct code. Fix setting of QSINL5 flag. (Don't set FALSE, if
C not updating list.)
C
C Revision 1.17  1999/07/20 17:58:44  richard
C RIC: There was a problem where any element without a colour assigned
C in propwin.dat, was getting assigned a default radius aswell as a
C default colour. Fixed.
C
C Revision 1.16  1999/07/02 17:53:36  richard
C RIC: Changed bond determining routine to ignore bonds shorter than
C      0.7 * (sum of covalent radii). This makes things a little clearer
C      when there are lots of atoms.
C
C Revision 1.15  1999/07/01 18:09:41  dosuser
C RIC: Changed the largest possible bonding distance of two atoms
C to (COVALENT(1) + COVALENT(2)) * 1.1 to
C    (COVALENT(1) + COVALENT(2)) * 1.3. Should solve problems with
C    metal atoms not bonding to anything.
C
C Revision 1.14  1999/06/22 13:51:27  dosuser
C RIC: Temporarily commented out the eigen vector and axes calculation as
C it doesn't seem to work.
C
C Revision 1.13  1999/06/13 16:18:23  dosuser
C RIC: Centre the molecule on 0,0,0 as it is updated.
C
C Revision 1.12  1999/06/01 13:00:05  dosuser
C RIC: Added commented out debugging code for checking which bonds
C have been found.
C RIC: Commented out some unused variables.
C
C Revision 1.11  1999/05/25 16:03:31  dosuser
C RIC: Changes for UNIX filenames for LIN and GIL targets.
C
C Revision 1.10  1999/05/21 11:18:59  dosuser
C RIC: When drawing bonds colour them according to the deviation from
C the CSD mean, if this info has already been computed.
C
C Revision 1.9  1999/05/10 19:48:44  dosuser
C RIC: It turns out that LGUIL1 and LGUIL5 were a bit useless as they
C     were only set when you call XWININ() from #SET TERM WIN. So I changed
C     things around a bit:
C     There is now no LGUIL5 because XGDBUP can only be called from places
C     which are altering list 5 anyway. Instead there is now an LGUIL2
C     instead, which was a bit overdue. LGUIL1 and LGUIL2 are set in
C     XFAL01 and XFAL02 respectively as the XGUIOV and PERM02 common blocks
C     are filled in. The result: Structure appears when it is supposed to
C     and no crashes in the mean time.
C
C Revision 1.8  1999/05/10 16:53:58  dosuser
C RIC: Removed unused routine GUI()
C
CODE FOR GUIBLK
      BLOCK DATA GUIBLK
      INCLUDE 'XGUIOV.INC'
      INCLUDE 'QGUIOV.INC'
      DATA ISERIA/0/, NATINF/0/
      DATA LGUIL1/.FALSE./
      DATA LGUIL2/.FALSE./
     1 LUPDAT/.FALSE./, QSINL5/.FALSE./, PTINL5/.FALSE./
      DATA KSTAT1 /0/, KSTAT2 /0/, KSTAT3/0/, KSTAT5/0/, KSTAT6/0/,
     1 KSTATQ/0/, KSTATI/0/, KSTATP/0/
      END


CODE FOR MENUUP (Updates the flags for the menus)
      SUBROUTINE MENUUP
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INTEGER LCR
      INCLUDE 'XGUIOV.INC'
      LCR = 1

      IF(KEXIST(1).EQ.1)THEN
        IF (KSTAT1.LE.0) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L1'
          LCR = LCR + 1
          KSTAT1 = 1
        END IF
      ELSE
        IF (KSTAT1.GE.0) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L1'
          LCR = LCR + 1
          KSTAT1 = -1
        END IF
      ENDIF

      IF(KEXIST(2).EQ.1)THEN
        IF(KSTAT2.LE.0) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L2'
          LCR = LCR + 1
          KSTAT2 = 1
        END IF
      ELSE
        IF ( KSTAT2.GE.0 ) THEN
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L2'
          LCR = LCR + 1
          KSTAT2 = -1
        END IF
      ENDIF

      IF(KEXIST(3).EQ.1)THEN
        IF (KSTAT3.LE.0) THEN
          KSTAT3 = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L3'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTAT3.GE.0 ) THEN
          KSTAT3 = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L3'
          LCR = LCR + 1
        END IF
      ENDIF

      IF(KEXIST(5).EQ.1)THEN
        IF(KSTAT5.LE.0) THEN
          KSTAT5 = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L5'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTAT5.GE.0 ) THEN
          KSTAT5 = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L5'
          LCR = LCR + 1
        END IF
      ENDIF

      IF(KEXIST(6).EQ.1)THEN
        IF(KSTAT6.LE.0) THEN
          KSTAT6 = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   L6'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTAT6.GE.0 ) THEN
          KSTAT6 = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET L6'
          LCR = LCR + 1
        END IF
      ENDIF

      IF(QSINL5)THEN
        IF(KSTATQ.LE.0) THEN
          KSTATQ = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   QS'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTATQ.GE.0 ) THEN
          KSTATQ = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET QS'
          LCR = LCR + 1
        END IF
      ENDIF

      IF(PTINL5)THEN
        IF(KSTATP.LE.0) THEN
          KSTATP = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   PT'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTATP.GE.0 ) THEN
          KSTATP = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET PT'
          LCR = LCR + 1
        END IF
      ENDIF

      IF (INSTRC)THEN
        IF (KSTATI.LE.0) THEN
          KSTATI = 1
          WRITE(CMON(LCR),'(A)')'^^ST STATSET   IN'
          LCR = LCR + 1
        END IF
      ELSE
        IF ( KSTATI.GE.0 ) THEN
          KSTATI = -1
          WRITE(CMON(LCR),'(A)')'^^ST STATUNSET IN'
          LCR = LCR + 1
        END IF
      ENDIF
C
C
      IF ( LCR .GT. 1 ) THEN
        WRITE ( CMON(LCR), '(A)')'^^CR'
        CALL XPRVDU(NCVDU, LCR,0)
      END IF
C
      RETURN
      END
C
 
 
 
 
 
 
C
CODE FOR CRDIST2
      SUBROUTINE CRDIST2
C--SET UP A BPD VALUES
      INCLUDE 'XCONST.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XGUIOV.INC'
C--SET UP THE SHIFT DATA
      DO 1050 I=1,3
           K=9+I
         BPD(I)=0.
         DO 1000 J=1,I
            BPD(I)=BPD(I)+GUMTRX(K)*GUMTRX(K)
                  K=K+3
1000     CONTINUE
         BPD(I)=1./SQRT(BPD(I))
1050  CONTINUE
      RETURN
      END



CODE FOR XDSTNCR
      FUNCTION XDSTNCR(A,B)
C--COMPUTE THE DISTANCE SQUARED BETWEEN TWO POINTS
C
C  A  VECTOR CONTAINING THE COORDINATES OF THE FIRST POINT.
C  B  VECTOR CONTAINING THE COORDINATES OF THE SECOND POINT.
C
C--THE RETURN VALUE OF 'XDSTN2' IS THE DISTANCE SQUARED.
C
      DIMENSION A(3),B(3),C(3),D(3)
      INCLUDE 'XCONST.INC'
      INCLUDE 'XGUIOV.INC'
C
C--SUBTRACT THE VECTORS
      CALL XSUBTR(A(1),B(1),C(1),3)
C--ORTHOGONALISE THE DIFFERENCE VECTOR
      CALL XMLTTM(GUMTRX(1),C(1),D(1),3,3,1)
C--COMPUTE THE DISTANCE
      C(1)=D(1)*D(1)+D(2)*D(2)+D(3)*D(3)
C--CHECK THE VALUE
      IF(C(1)-ZEROSQ .LT. 0) C(1)=VALUSQ
C
      XDSTNCR=C(1)
      RETURN
      END
 


CODE FOR KDIST2
      FUNCTION KDIST2(NOC)
C--MOVES AN ATOM POSITIVELY FORWARD ONE UNIT CELL, AND CHECKS IF
C  THE ATOM IS STILL WITHIN THE SEARCH VOLUME FOR THE GIVEN AXIAL DIRECT
C
C  NOC  THE AXIAL DIRECTION ALONG WHICH TO MOVE.
C
C--THE RETURN VALUES OF 'KDIST' ARE :
C
C  -1  ATOM CANNOT BE FITTED IN THE REQUIRED VOLUME ANY MORE.
C   0  ATOM IS STILL WITHIN THE REQUIRED VOLUME FOR THIS DIRECTION.
C
C--THE ATOM IS ASSUMED TO HAVE BEEN POSITIONED OUTSIDE THE VOLUME BY
C  'XSHIFT', AND IT IS ALWAYS MOVED AT LEAST ONE UNIT CELL FOR EACH CALL
C  OF THIS ROUTINE.
C
C--THE COMMON BLOCK 'XPDS' IS USED AS :
C
C  APD(7-9)  CURRENT SET OF ATOMIC COORDINATES TO ALTER.
C  BPD(4-6)  MIINIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C  BPD(7-9)  MAXIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C
C--
      INCLUDE 'XPDS.INC'
C
      KDIST2=-1
C--JUMP THE ATOM TO AT LEAST JUST BEFORE THE REQUIRED VOLUME
c This causes missed bonds sometimes...
c      APD(NOC+6)=MAX(APD(NOC+6),MOD(APD(NOC+6),1.)+NINT(BPD(NOC+3))-1)
C--MOVE FORWARD ONE UNIT CELL
1000  CONTINUE
      APD(NOC+6)=APD(NOC+6)+1.
C--CHECK IF WE HAVE ARRIVED IN THE REQUIRED VOLUME
      IF(APD(NOC+6)-BPD(NOC+3))1000,1050,1050
C--CHECK IF WE HAVE GONE TOO FAR ALONG THIS AXIAL DIRECTION
1050  CONTINUE
      IF(APD(NOC+6)-BPD(NOC+6))1100,1100,1150
C--WE ARE IN THE REQUIRED VOLUME
1100  CONTINUE
      KDIST2=0
1150  CONTINUE
      RETURN
      END



CODE FOR XSHIFT2
      SUBROUTINE XSHIFT2(NOC)
C--SHIFTS THE ATOM OUT OF RANGE SO THAT IT CAN START COMING BACK
C
C  NOC  THE NUMBER OF THE PARAMETER TO MOVE, IN THE RANGE 1 TO 3.
C
C--THE COMMON BLOCK 'XPDS' IS USED AS :
C
C  APD(7-9)  CURRENT SET OF ATOMIC COORDINATES TO ALTER.
C  BPD(4-6)  MIINIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C  BPD(7-9)  MAXIMUM ALONG EACH OF THE AXIAL DIRECTIONS.
C
C--
      INCLUDE 'XPDS.INC'
C
C--CHECK IF WE GONE FAR ENOUGH BACKWARDS
      APD(NOC+6) = MOD(APD(NOC+6),1.0)

1000  CONTINUE
      IF(APD(NOC+6)-BPD(NOC+3))1050,1100,1100
C--SUCCESS  -  NOW RETURN
1050  CONTINUE
      RETURN
C--MOVE BACK ONE MORE UNIT CELL
1100  CONTINUE
      APD(NOC+6)=APD(NOC+6)-1.
      GOTO 1000
      END






CODE FOR XGUIUP
      SUBROUTINE XGUIUP ( IULN )
C#if defined(CRY_GUI)      
C      use fwrappergui_mod, only : fstbnd, fstatm, fstsph, fstrng
C#endif
C----- UPDATE THE GUI
C
C Unlike earlier versions of this subroutine, we can now sometimes claim store
C to load lists and update the GUI.
C
C Updating lists 5 updates the whole model, so lists 1,2,29,40 and 41
C are also loaded or required.
C
C IULN
C   0 - process all list information that needs updating.
C   +ve - update list IULN
C   -ve - update list -IULN, but don't touch store. ( We may use STR11 )
C         for list 5, this means that 1, 2, 5, 29 and 41 must have been
c         loaded by the calling routine.

      use lists1_mod, only: xrlind, klschk

      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XGUIOV.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QGUIOV.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST25.INC'
      INCLUDE 'XLST04.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XLST13.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XLSVAL.INC'
      INCLUDE 'HEADES.INC'
      INCLUDE 'TYPE11.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'QSTR11.INC'
      INCLUDE 'XDISCB.INC'

      DIMENSION JDEV(4)
      DIMENSION CARD(20)
      REAL TENSOR(3,3), TEMPOR(3,3), ROTN(3,3), AXES(3,3)
      CHARACTER CCOL*6, WCLINE*80, CFILEN*256, CATTYP*4,CLAB*32,CLAB2*32
      character *80 ctext(4)
      CHARACTER*5 CWT 
      CHARACTER*22 CFM, CFMC ! 'Fo**2'
      CHARACTER*35 CMOD
      CHARACTER CBUF*86
      CHARACTER * 4 CNAME
      LOGICAL WEXIST, LSPARE
      CHARACTER*8 CINST(6)
      INTEGER IUNKN
      CHARACTER*8 CRADTN(2)
      CHARACTER*11 CBONDS(0:9)
      DIMENSION ID(2)


      DIMENSION LST(15)
      DIMENSION ICLINF(400)
      DIMENSION TXYZ(9)

      SAVE NCLINF, ICLINF

      DATA ISERnn /50*0/
      DATA NCLINF /0/

      DATA    CINST /'Unknown','CAD4','Mach3','KappaCCD','Dip','Smart'/
#ifdef _HOL_
      DATA    IUNKN /4HUNKN/
#else
      DATA    IUNKN /'UNKN'/
#endif
      DATA CRADTN / 'X-rays' , 'neutrons' /
      DATA CBONDS / 'unassigned', 'single',    'double',      'triple',
     c'quadruple',  'aromatic',   'polymeric', 'delocalised', 'strange',
     c'pi-bond'/


C The QSINl5 flag is set here, if there are Q atoms in list 5.
C It is used by the menu update routine.
C
C LUPDAT flag prevents the data from being sent to the GUI.
C

2     FORMAT(A)


C Wait for disk buffers to be allocated, before loading lists.
      IF ( IACC .LT. 0 ) RETURN

      IF ( .NOT. LUPDAT ) RETURN

      IF ( IULN .GE. 0 ) THEN
        CALL XRSL
        CALL XCSAE
C -- CLEAR ERROR FLAG
        IERFLG = 1
      END IF

c      WRITE(CMON,'(a)')' XGUIUP: ENTRY.'
c      CALL XPRVDU (NCVDU,1,0)

C



      IF ( IULN .EQ. 0 ) THEN ! decide what needs updating
c         WRITE(CMON,'(a)')' XGUIUP: Setting 7 lists to be updated.'
c         CALL XPRVDU (NCVDU,1,0)
         NLST = 11
         LST(1) = 1
         LST(2) = 2
         LST(3) = 5
         LST(4) = 23
         LST(5) = 29
         LST(6) = 30
         LST(7) = 4
         LST(8) = 12
         LST(9) = 16
         LST(10)= 25
         LST(11)= 13
      ELSE
         NLST = 1
         LST(1) = ABS(IULN)
         IF ( LST(1) .EQ. 41 ) LST(1) = 5  !Use 5 it will include 41.
      ENDIF

      DO MLST = 1,NLST       !Loop over the lists to be sent up.
         ILST = LST(MLST)

C Branch on type of list that needs sending:

         IF ( ILST .EQ. 5 ) THEN   ! atom coordinates - update model

C 'ISSUPD' CAN  BE RESET BY '#SET AUTO = OFF/ON (VALUE 0/1)
            IF ( ISSUPD .EQ. 0 ) THEN
c      WRITE(CMON,'(a)')' XGUIUP: Model update suppressed by user.'
c      CALL XPRVDU (NCVDU,1,0)
             ISERnn(5)  = 0         ! Ensure update if/when ISSUPD is 
             ISERnn(41) = 0         ! switched back on.
             CYCLE ! The model may be switched off for speed reasons.
            ENDIF

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure
                                    ! already loaded.

c               WRITE(CMON,'(a)')' XGUIUP: L5: Sneaky update.'
c               CALL XPRVDU (NCVDU,1,0)

               IF(KEXIST(1).LE.0) CYCLE
               IF(KEXIST(2).LE.0) CYCLE
               IF(KEXIST(5).LE.0) CYCLE
               IF(KEXIST(29).LE.0) CYCLE
               IF(KEXIST(41).LE.0) CYCLE
               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
               IF(KHUNTR(5,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE
C In this mode, we can't run XBCALC so the existing 41 will have to do.
               IF(KHUNTR(41,0,IADDL,IADDR,IADDD,-1).NE.0) CYCLE

            ELSE

c               WRITE(CMON,'(a)')' XGUIUP: L5: Full update.'
c               CALL XPRVDU (NCVDU,1,0)

               IF(KEXIST(1).LE.0) CYCLE
               IF(KEXIST(2).LE.0) CYCLE
               IF(KEXIST(5).LE.0) CYCLE
               IF(KEXIST(29).LE.0) CYCLE

C Ensure list 41 dependencies are up to date:
               IF ( K41DEP() .LT. 0 ) THEN
                 CALL XRSL
                 CALL XCSAE
                 CALL XBCALC(1)
                 CALL XRSL
                 CALL XCSAE
               ENDIF

               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL01
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL02
               IF(KHUNTR(5,0,IADDL,IADDR,IADDD,-1).NE.0)  CALL XFAL05
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL29
               IF(KHUNTR(41,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL41
               IF ( IERFLG .LT. 0 ) GO TO 9920
            END IF

            CALL XRLIND(5, L05SR, NFW, LL, IOW, NOS, ID)
            CALL XRLIND(41,L41SR, NFW, LL, IOW, NOS, ID)

            IF ( IULN .LT. 0 ) THEN
              IF ( ISERnn(5) .EQ. -1) THEN
                L05SR = -2
              ELSE
                L05SR = -1
              END IF
            END IF

C If the current list is is the same as one sent before then
C don't update the GUI.

            IF ( (L05SR.EQ.ISERnn(5)).AND.(L41SR.EQ.ISERnn(41)) ) THEN
c      WRITE(CMON,'(a)')' XGUIUP: Model serial unchanged.'
c      CALL XPRVDU (NCVDU,1,0)

              CYCLE
            ENDIF

C Set old list number to current list number.
            ISERnn(5)  = L05SR
            ISERnn(41) = L41SR

            QSINL5 = .FALSE.
            PTINL5 = .FALSE.

C Calculate and store orthogonal coords....
C Calculate sum of x, y and z as we go.
            XMAX = -100000.0
            XMIN =  100000.0 
            YMAX = -100000.0
            YMIN =  100000.0
            ZMAX = -100000.0
            ZMIN =  100000.0
            IPLACE = 1
            J = L5
            KNF11 = 1

            DO I = L5, L5+(N5-1)*MD5, MD5
              CALL XMLTTM(STORE(L1O1),STORE(I+4),STR11(IPLACE),3,3,1)
              XMIN = MIN(XMIN,STR11(IPLACE))
              YMIN = MIN(YMIN,STR11(IPLACE+1))
              ZMIN = MIN(ZMIN,STR11(IPLACE+2))
              XMAX = MAX(XMAX,STR11(IPLACE))
              YMAX = MAX(YMAX,STR11(IPLACE+1))
              ZMAX = MAX(ZMAX,STR11(IPLACE+2))
              IPLACE = IPLACE + 3
            END DO

            KNF11 = IPLACE

C Calculate the centre of the molecule
            GCENTX = (XMIN + XMAX) / 2.0
            GCENTY = (YMIN + YMAX) / 2.0
            GCENTZ = (ZMIN + ZMAX) / 2.0

C Find atom furthest from the center to set scaling.
C NB, it is quicker to find the center and longest distance from it
C (two loops through the list), than to find the longest distance
C between all pairs of atoms (n squared / 2 loops through the list...)
C
C Centre the molecule on 0,0,0 at the same time!

            RLENTH = 0
            DO I = 1, 3*N5,3
              STR11(I)   = STR11(I)   - GCENTX
              STR11(I+1) = STR11(I+1) - GCENTY
              STR11(I+2) = STR11(I+2) - GCENTZ
              TMPLEN =  ( (STR11(I  )**2)
     1                 + (STR11(I+1)**2)
     2                 + (STR11(I+2)**2) )
              RLENTH = MAX (TMPLEN,RLENTH)
            END DO

            IF (RLENTH.LT.0.1)THEN
              GSCALE = 5000.0
            ELSE
              GSCALE = 5000.0 / (SQRT (RLENTH) + 2)
            ENDIF

c      WRITE ( CMON, '(A,I5)')'GUI-UP: L5: Updating N atoms:', N5
c      CALL XPRVDU(NCVDU, 1,0)

            IF ( N5 .GT. 0 ) THEN     !Only do if there are some atoms.

             WRITE ( CMON, '(A/A)')'^^GR MODEL L5','^^CW'
             CALL XPRVDU(NCVDU, 2,0)


             IPLACE = 1
             DO I5 = L5,L5+(N5-1)*MD5, MD5

C Get atom type.

               LSPARE = .FALSE.
               IATTYP = ISTORE(I5)
               WRITE(CATTYP,'(A4)')IATTYP
               IF(CATTYP(1:1).EQ.'Q') THEN
                 QSINL5 = .TRUE.
                 IF ( ABS(STORE (I5+13)).GT.0.0001 ) LSPARE = .TRUE.
               END IF
               IF ( ISTORE(I5+14).NE.0 ) PTINL5 = .TRUE.

               KFNDPR = 0

C Look for properties in L29:
               ICOL=IUNKN
               DO M29 = L29, L29+(N29-1)*MD29, MD29
                 IF ( ISTORE(M29) .EQ. ISTORE(I5) ) THEN
                    COV = STORE(M29+1)
                    VDW = STORE(M29+2)
                    ICOL = ISTORE(M29+7)
                    KFNDPR = 1
                    EXIT
                 ENDIF
               END DO

               IF ( ICOL .EQ. IUNKN ) KFNDPR = 0 !UNKNOWN colour. (L29 default)

C Look for properties in our cache: (things like Q, which are not in 29).
               IF ( KFNDPR .EQ. 0 ) THEN
                 DO K = 1, NATINF * 4, 4
                   IF(IATINF(K).EQ.ISTORE(I5)) THEN
                      VDW =  ATINF(K+1)
                      COV =  ATINF(K+2)
                     ICOL = IATINF(K+3)
                     KFNDPR = 1
                     EXIT
                   ENDIF
                 ENDDO
               ENDIF

               IF ( KFNDPR .EQ. 0 ) THEN
C Atom info not found. Load it and cache it. The info is stored
C in common, so only needs loading once.

#ifdef CRY_OSWIN32
             CFILEN = 'CRYSDIR:script\propwin.dat'
#else
             CFILEN = 'CRYSDIR:script/propwin.dat'
#endif
                  CALL MTRNLG(CFILEN,'OLD',ILENG)
                  INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
                  IF(WEXIST) THEN
                    CALL XMOVEI(KEYFIL(1,2), JDEV, 4)
                    CALL XRDOPN (6, JDEV, CFILEN(1:ILENG), ILENG)
                    IF ( IERFLG .LT. 0) GOTO 9900
C Read the properties file and extract cov, vdw and colour.
                    DO WHILE ( KFNDPR .EQ. 0 )
                      READ(NCARU,'(A80)',END=89) WCLINE
                      IF((WCLINE(1:3).NE.'CON').AND.
     1                   (WCLINE(1:3).NE.'   ')) THEN

                        IF(WCLINE(1:2).EQ.CATTYP) THEN
c                          CCOL = WCLINE(62:67)
                          READ(WCLINE(13:16),'(F4.2)') COV
                          READ(WCLINE(35:38),'(F4.2)') VDW
                          READ(WCLINE(62:65),'(A4)') ICOL
                          IATINF((NATINF*4)+1) = IATTYP
                          ATINF((NATINF*4)+2)  = VDW
                          ATINF((NATINF*4)+3)  = COV
                          IATINF((NATINF*4)+4) = ICOL
                          NATINF = NATINF + 1
                          KFNDPR = 1
                          EXIT
                        END IF
                      ENDIF
                    END DO
89                  CONTINUE !End of file
                    CALL XRDOPN (7, JDEV, CFILEN(1:ILENG), ILENG) !Close
                  END IF
               END IF

               IF ( KFNDPR .EQ. 0 ) THEN
C Atom info still not found. Store default values in cache.
                  IATINF((NATINF*4)+1) = IATTYP
                  ATINF((NATINF*4)+2)  = 1.8
                  ATINF((NATINF*4)+3)  = 0.8
                  IATINF((NATINF*4)+4) = 0
                  NATINF = NATINF + 1
                  COV = 0.8
                  VDW = 1.8
                  ICOL = 0
                  KFNDPR = 1
               END IF


C Get colour definition from our cache:
               KFNDPR = 0
               DO K = 1, NCLINF * 4, 4
                 IF(ICLINF(K).EQ.ICOL) THEN
                   IRED  = ICLINF(K+1)
                   IGRE  = ICLINF(K+2)
                   IBLU  = ICLINF(K+3)
                   KFNDPR = 1
                   EXIT
                 ENDIF
               ENDDO

               IF ( KFNDPR .EQ. 0 ) THEN

C Get the colour definition for this colour from colour.cmn and cache it.
#ifdef CRY_OSWIN32
                  CFILEN = 'CRYSDIR:SCRIPT\COLOUR.CMN'
#else
                  CFILEN = 'CRYSDIR:script/colour.cmn'
#endif
                  CALL MTRNLG(CFILEN,'OLD',ILENG)
                  INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
                  IF(WEXIST) THEN
                    IF (KFLOPN (NCARU, CFILEN(1:ILENG), ISSOLD, ISSREA,
     1                  1, ISSSEQ) .EQ. -1) GOTO 9900
                    DO WHILE ( KFNDPR .EQ. 0 )
                      READ(NCARU,'(A4,3X,A21)',END=88) IICOL, WCLINE
                      IF(IICOL.EQ.ICOL)THEN
                         READ(WCLINE(1:15),'(3I5)')IRED,IGRE,IBLU
                         ICLINF((NCLINF*4)+1) = ICOL
                         ICLINF((NCLINF*4)+2) = IRED
                         ICLINF((NCLINF*4)+3) = IGRE
                         ICLINF((NCLINF*4)+4) = IBLU
                         NCLINF = NCLINF + 1
                         KFNDPR = 1
                         EXIT
                      ENDIF
                    END DO
88                  CONTINUE !End of file
                    CLOSE(NCARU)
                  ENDIF
               ENDIF

               IF ( KFNDPR .EQ. 0 ) THEN
C Colour info still not found, use and cache default values:
                  IRED = 0
                  IGRE = 0
                  IBLU = 0
                  ICLINF((NCLINF*4)+1) = ICOL
                  ICLINF((NCLINF*4)+2) = IRED
                  ICLINF((NCLINF*4)+3) = IGRE
                  ICLINF((NCLINF*4)+4) = IBLU
                  NCLINF = NCLINF + 1
               END IF

               CALL CATSTR (STORE(I5),STORE(I5+1),1,1,0,0,0,CLAB,LLAB)

               UEQUIV = STORE(I5+7)


               IF ( NINT(STORE(I5+3)) .EQ. 0 ) THEN

                 TENSOR(1,1) = STORE(I5+7)
                 TENSOR(2,2) = STORE(I5+8)
                 TENSOR(3,3) = STORE(I5+9)
                 TENSOR(2,3) = STORE(I5+10)
                 TENSOR(1,3) = STORE(I5+11)
                 TENSOR(1,2) = STORE(I5+12)
                 TENSOR(3,2) = TENSOR(2,3)
                 TENSOR(3,1) = TENSOR(1,3)
                 TENSOR(2,1) = TENSOR(1,2)
      
c                WRITE(99,'(A)') 'CRY: TENSOR, ORTHTENSOR, AXES, ELOR: '
c                WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)
                     
                 CALL XMLTMM(GUMTRX(19), TENSOR,     TEMPOR,3,3,3)
                 CALL XMLTMT(TEMPOR,     GUMTRX(19), TENSOR,3,3,3)

C We now have an orthogonal tensor in TENSOR(3,3).

c                WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)

#ifdef CRY_GUI
         CALL ZEIGEN(TENSOR,ROTN)
#endif

C Filter out tiny axes
                 TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(2,2)/100 )
                 TENSOR(1,1) = MAX ( TENSOR(1,1), TENSOR(3,3)/100 )
                 TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(1,1)/100 )
                 TENSOR(2,2) = MAX ( TENSOR(2,2), TENSOR(3,3)/100 )
                 TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(1,1)/100 )
                 TENSOR(3,3) = MAX ( TENSOR(3,3), TENSOR(2,2)/100 )
            
                 DO KI=1,3
                   DO KJ=1,3
                     AXES(KI,KJ) =   ROTN(KJ,KI)
     1                             * SQRT(ABS(TENSOR(KJ,KJ)))
     2                             * GSCALE
     3                             * 1.5
                   END DO
                 END DO

C                WRITE(99,'(9(1X,F7.4))') ((AXES(KI,KJ)/GSCALE,KI=1,3),KJ=1,3)
C                WRITE(99,'(9(1X,F7.4))') (GUMTRX(KI),KI=19,27)

C Work out UEQUIV:

                 IADDU = KSTALL(4)
                 CALL XEQUIV ( 1, I5, MD5, IADDU )
                 UEQUIV = STORE ( IADDU )

               ELSE IF ( NINT(STORE(I5+3)) .EQ. 1 ) THEN
                 DO KI=1,3
                   DO KJ=1,3
                     AXES(KI,KJ) = 0
                   END DO
                 END DO
                 AXES(1,1) = SQRT(ABS(STORE(I5+7))) * GSCALE
               END IF

        
               SPAREV = 0.0

               IF ( LSPARE .AND. ( NINT(STORE(I5+3)) .LE. 1 )) THEN
                  ISPARE = NINT(1000 * STORE(I5+13) )
                  SPARE = 0.297 * (STORE(I5+13)**(1.0/3.0))
                  AXES (1,1) = ( GSCALE * SPARE )
                  AXES (2,2) = ( GSCALE * SPARE )
                  AXES (3,3) = ( GSCALE * SPARE )
                  AXES (1,2) = 0.0
                  AXES (1,3) = 0.0
                  AXES (2,1) = 0.0
                  AXES (2,3) = 0.0
                  AXES (3,1) = 0.0
                  AXES (3,2) = 0.0
C                  STORE(I5+3) = 0.0
               ELSE
                   SPAREV = STORE(I5+3)
                   ISPARE = NINT(COV*GSCALE)
               END IF

C Pass sticky refinement flag options if present.
               ISFLAG = 0
C This block catches old negative sticky flag and fixes it to look like new format
               IF (ISTORE(I5+15) .LT. 0) THEN
                  ISTORE(I5+15) = -ISTORE(I5+15)
                  ISTORE(I5+15) = OR ( ISTORE(I5+15), 128 ) ! Set bit7
               END IF
C This block detects sticky flag and sets ISFLAG to pass info to GUI.               
               IF( AND( ISTORE(I5+15), 128 ) .NE. 0 ) THEN
                 ISFLAG = AND(ISTORE(I5+15), 127)  ! Pass lower 7 bits.
               ENDIF
               
               IF ( NINT(STORE(I5+3)) .LE. 1 ) THEN

                     CALL PRTGRP(ISTORE(I5+14),JPRT,JGRP,1)

#ifdef CRY_GUI
                CALL FSTATM(CATTYP,NINT(STORE(I5+1)),LLAB,CLAB,
     1          NINT(STR11(IPLACE)*GSCALE),
     5          NINT(STR11(IPLACE+1)*GSCALE),
     6          NINT(STR11(IPLACE+2)*GSCALE),
     7          NINT(IRED*2.55),NINT(IGRE*2.55),NINT(IBLU*2.55),
     8          NINT(1000*STORE(I5+2)), COV*GSCALE,
     2          NINT(VDW*GSCALE),ISPARE,NINT(SPAREV),
     3          AXES(1,1),AXES(2,1),AXES(3,1),
     3          AXES(1,2),AXES(2,2),AXES(3,2),
     3          AXES(1,3),AXES(2,3),AXES(3,3),
     4          STORE(I5+4),STORE(I5+5),STORE(I5+6),
     5          ISTORE(I5+16), JGRP, JPRT, UEQUIV, STORE(I5+13),ISFLAG)

#endif
               ELSE IF ( NINT(STORE(I5+3)) .EQ. 2 ) THEN

#ifdef CRY_GUI
               CALL FSTSPH(LLAB,CLAB,NINT(STR11(IPLACE)*GSCALE),
     5         NINT(STR11(IPLACE+1)*GSCALE),
     6         NINT(STR11(IPLACE+2)*GSCALE),
     7         NINT(IRED*2.55),NINT(IGRE*2.55),NINT(IBLU*2.55),
     8         NINT(1000*STORE(I5+2)), NINT(COV*GSCALE),
     2         NINT(VDW*GSCALE),ISPARE,NINT(SPAREV),
     3         NINT( SQRT(ABS(STORE(I5+7))) * GSCALE),
     4         NINT(STORE(I5+8) * GSCALE) )

#endif
               ELSE IF ( NINT(STORE(I5+3)) .EQ. 4 ) THEN

#ifdef CRY_GUI
               CALL FSTRNG(LLAB,CLAB,NINT(STR11(IPLACE)*GSCALE),
     5         NINT(STR11(IPLACE+1)*GSCALE),
     6         NINT(STR11(IPLACE+2)*GSCALE),
     7         NINT(IRED*2.55),NINT(IGRE*2.55),NINT(IBLU*2.55),
     8         NINT(1000*STORE(I5+2)), NINT(COV*GSCALE),
     2         NINT(VDW*GSCALE),ISPARE,NINT(SPAREV),
     3         NINT( SQRT(ABS(STORE(I5+7))) * GSCALE),
     4         NINT(STORE(I5+8) * GSCALE),
     5         NINT(STORE(I5+9)*100.0),NINT(STORE(I5+10)*100.0))

#endif
               END IF

               IPLACE = IPLACE + 3
             END DO


C Output bonds:

c       WRITE ( CMON, '(A,I4)')'GUI-UP: L5: Updating N Bonds: ',N41B
c       CALL XPRVDU(NCVDU, 1,0)

             DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B

               IA1 = ISTORE(M41B)
               IA2 = ISTORE(M41B+6)

               IAT1P = L5 + IA1 * MD5
               IAT2P = L5 + IA2 * MD5

C Set colour to blackish:
               KR = 40
               KG = 40
               KB = 40

C If a symm related atom, colour bond bright white, and calculate real
C co-ordinates for bond end.
               ISSYM = 0
               DO I = 1,2
                  IF ((ISTORE(M41B+I).NE.1).OR.
     1                (ISTORE(M41B+I+6).NE.1)) ISSYM=1
               END DO
               DO I = 3,5
                  IF ((ISTORE(M41B+I).NE.0).OR.
     1                (ISTORE(M41B+I+6).NE.0)) ISSYM=1
               END DO
C Should be 1,1,0,0,0 and 1,1,0,0,0
               IF ( ISSYM .NE. 0 ) THEN
                  KR = 230
                  KG = 230
                  KB = 230
C -- Apply symmetry to atom 1:
                  M2 = L2 + ( MIN(N2,ABS(ISTORE(M41B+1))) - 1) * MD2
                  M2P =L2P+ ( MIN(N2P,ISTORE(M41B+2))     - 1) * MD2P

c              WRITE(CMON,'(A,3F9.3)')'Atom1:',(STORE(IAT1P+L),L=4,6)
c              CALL XPRVDU(NCVDU,1,0)

                  CALL XMLTTM(STORE(M2),STORE(4+IAT1P),TXYZ(1),3,3,1)
c              WRITE(CMON,'(A,3F9.3)')'symm:',(TXYZ(L),L=1,3)
c              CALL XPRVDU(NCVDU,1,0)
                  IF (ISTORE(M41B+1).LT.0)CALL XNEGTR(TXYZ(1),TXYZ(1),3)
c              WRITE(CMON,'(A,3F9.3)')'negt:',(TXYZ(L),L=1,3)
c              CALL XPRVDU(NCVDU,1,0)
C -- Translate
                  DO L = 0,2
                     TXYZ(7+L) = TXYZ(1+L) +STORE(M2P+L) +STORE(M2+9+L)
     1                          +ISTORE(M41B+3+L)
                  END DO
c              WRITE(CMON,'(A,3F9.3)')'trans:',(TXYZ(L),L=7,9)
c              CALL XPRVDU(NCVDU,1,0)

C -- Orthogonalise
                  CALL XMLTTM(STORE(L1O1),TXYZ(7),TXYZ(1),3,3,1)
c              WRITE(CMON,'(A,3F9.3)')'ortho:',(TXYZ(L),L=1,3)
c              CALL XPRVDU(NCVDU,1,0)

C -- Centre with the rest of the molecule.
                  TXYZ(1)   = TXYZ(1) - GCENTX
                  TXYZ(2)   = TXYZ(2) - GCENTY
                  TXYZ(3)   = TXYZ(3) - GCENTZ

C -- Apply symmetry to atom 2:
                  M2 =  L2 + (MIN(N2,ABS(ISTORE(M41B+7))) - 1) * MD2 
                  M2P = L2P+ (MIN(N2P,ISTORE(M41B+8))    - 1) * MD2P
                  CALL XMLTTM(STORE(M2),STORE(4+IAT2P),TXYZ(4),3,3,1)
                  IF(ISTORE(M41B+7).LT.0)CALL XNEGTR(TXYZ(4),TXYZ(4),3)
C -- Translate
                  DO L = 0,2
                     TXYZ(7+L) = TXYZ(4+L) +STORE(M2P+L) +STORE(M2+9+L)
     1                          +ISTORE(M41B+9+L)
                  END DO
C -- Orthogonalise
                  CALL XMLTTM(STORE(L1O1),TXYZ(7),TXYZ(4),3,3,1)
C -- Centre with the rest of the molecule.
                  TXYZ(4) = TXYZ(4) - GCENTX
                  TXYZ(5) = TXYZ(5) - GCENTY
                  TXYZ(6) = TXYZ(6) - GCENTZ

               ELSE
                  CALL XMOVE ( STR11((IA1*3)+1), TXYZ(1), 3)
                  CALL XMOVE ( STR11((IA2*3)+1), TXYZ(4), 3)
               END IF

C See if this bond is in CSD list. If so, use it's deviation to colour it.
c               IF ( KBDDEV(IAT1P,IAT2P,DEVN) .GT. 0 )THEN

C As deviation goes positive, KB and KG should decrease giving a red colour
C As deviation goes negative, KR and KG should decrease giving a blue colour
C i.e. +ve devn. KR 255, KB ->0  KG ->0
C      -ve devn  KR ->0, KB 255  KG ->0
C But, the deviation starts being coloured from 1.0, rather than 0.0
C DEVN = DEVN - 1
c                  KR = MAX ( 0, MIN (255, NINT (383+128*DEVN) ) )
c                  KG = MAX ( 0, MIN (255, NINT (383-128*ABS(DEVN))))
c                  KB = MAX ( 0, MIN (255, NINT (383-128*DEVN) )  )
c               ENDIF

               CALL CATSTR (STORE(IAT1P),STORE(IAT1P+1),
     1                       ISTORE(M41B+1),ISTORE(M41B+2),
     1                       ISTORE(M41B+3),ISTORE(M41B+4),
     1                       ISTORE(M41B+5), CLAB, LLAB )
               CALL CATSTR (STORE(IAT2P),STORE(IAT2P+1),
     1                       ISTORE(M41B+7),ISTORE(M41B+8),
     1                       ISTORE(M41B+9),ISTORE(M41B+10),
     1                       ISTORE(M41B+11), CLAB2, LLAB2 )


c               WRITE ( CMON,'(A,10(1X,I5),/,5A,1X,F6.3,1X,I4)')
c     1                 '$$GR BOND ',
c     1                  (NINT(TXYZ(KJ)*GSCALE),KJ=1,6),
c     3                  KR,KG,KB,
c     1                  NINT(GSCALE*0.25),
c     1                  '$$GR ''',CLAB(1:LLAB),''' ''',
c     1                            CLAB2(1:LLAB2),'''',
c     1                  STORE(M41B+13), ISTORE(M41B+12)
c               CALL XPRVDU(NCVDU, 2,0)

               ISTR11(KNF11) = IA1
               ISTR11(KNF11+1) = IA2

               WRITE(CMON(1),'(4A,F5.2,1X,A)')CLAB(1:LLAB),'-',
     1       CLAB2(1:LLAB2),' ~',STORE(M41B+13), CBONDS(ISTORE(M41B+12))
               CALL XCTRIM( CMON(1), LTMN )

               IF (( NINT(STORE(IAT1P+3)) .LT. 2 ).AND.
     1             ( NINT(STORE(IAT2P+3)) .LT. 2 )) THEN !FSTBND can't handle bonds to special shapes.
                IF ( ISSYM .EQ. 0 ) THEN   !Normal bond
#ifdef CRY_GUI
          CALL FSTBND(NINT(TXYZ(1)*GSCALE),NINT(TXYZ(2)*GSCALE),
     1             NINT(TXYZ(3)*GSCALE),NINT(TXYZ(4)*GSCALE),
     1             NINT(TXYZ(5)*GSCALE),NINT(TXYZ(6)*GSCALE),
     1             KR,KG,KB,NINT(GSCALE*0.25),ISTORE(M41B+12),
     1             2,ISTR11(KNF11),LTMN,CMON(1),0,'')
#endif
                ELSE                       !Bond across symm op.
#ifdef CRY_GUI
         CALL FSTBND( NINT(TXYZ(1)*GSCALE),NINT(TXYZ(2)*GSCALE),
     1             NINT(TXYZ(3)*GSCALE),NINT(TXYZ(4)*GSCALE),
     1             NINT(TXYZ(5)*GSCALE),NINT(TXYZ(6)*GSCALE),
     1             KR,KG,KB,NINT(GSCALE*0.25),-ISTORE(M41B+12),
     1        2,ISTR11(KNF11),LTMN,CMON(1),LLAB2,CLAB2(1:LLAB2))
#endif
                END IF
               END IF
             END DO

             IF ( MD41S .EQ. 0 ) MD41S = 1 !Catch old List 41's (during development only).
             DO M41S = L41S, L41S+(N41S-1)*MD41S, MD41S

               KNF11 = 1
               DO I = 1,MIN(6,ISTORE(M41S))
                 IA  = ISTORE(M41S+I)
                 IAP = L5 + IA * MD5
c                 WRITE(CMON,'(A4,I4)')ISTORE(IAP),NINT(STORE(IAP+1))
c                 CALL XPRVDU(NCVDU,1,0)
                 CALL XMOVE(STORE(IAP+4),STR11(KNF11),4)
                 STR11(KNF11+3) = 1.0
                 KNF11 = KNF11 + 4
               ENDDO
               IA1 = ISTORE(M41S+1)
               IA2 = ISTORE(M41S+MIN(4,ISTORE(M41S)))
               IAT1P = L5 + IA1 * MD5
               IAT2P = L5 + IA2 * MD5
               CALL CATSTR (STORE(IAT1P),STORE(IAT1P+1),1,1,0,0,0,
     1                      CLAB,LLAB)
               CALL CATSTR (STORE(IAT2P),STORE(IAT2P+1),1,1,0,0,0,
     1                      CLAB2,LLAB2)

               ICENT = KNF11     
               IROOT = KNF11 + 3 
               IVECT = KNF11 + 6 
               ICSNE = KNF11 + 15
               IWORK = KNF11 + 24
               KNF11 = KNF11 + 28

               I = KMOLAX(STR11(1),MIN(6,ISTORE(M41S)),4,STR11(ICENT),
     1             STR11(IROOT),STR11(IVECT),STR11(ICSNE),STR11(IWORK))

C Transform centroid into orthogonal (gui) coords.
               CALL XMLTTM(STORE(L1O1),STR11(ICENT),  TXYZ(1),3,3,1)

C Work out matrix for best-plane -> crystal fractions (wrt centroid).
               CALL XMLTMT(STR11(IVECT),STORE(L1O1),STR11(ICSNE),3,3,3)
               I=KINV2(3,STR11(ICSNE),STR11(KNF11),9,0,
     1                   STR11(IROOT),STR11(IROOT),3)
C The orientation of the torus is defined by the centroid and a normal
C vector. The length of this vector is interpreted as the radius of the
C ring. Take 0.7* the distance from centroid to any of the ring atoms.
               STR11(KNF11+9) =0.0
               STR11(KNF11+10)=0.0
               STR11(KNF11+11)=0.7*SQRT(XDSTN2(STR11(ICENT),
     +                                         STORE(IAT1P+4)))
C Transform {0,0,1} bp coords to crystal fractions.
               CALL XMLTMT(STR11(KNF11),STR11(KNF11+9),
     +                                     STR11(KNF11+12),3,3,1)
C Convert crystal fractions into orthogonal.
               CALL XMLTTM (STORE(L1O1),STR11(KNF11+12),TXYZ(4),3,3,1)
               TXYZ(1)   = TXYZ(1) - GCENTX
               TXYZ(2)   = TXYZ(2) - GCENTY
               TXYZ(3)   = TXYZ(3) - GCENTZ
C TXYZ(4-6) is relative to TXYZ(1-3)
               TXYZ(4)   = TXYZ(1) + TXYZ(4)
               TXYZ(5)   = TXYZ(2) + TXYZ(5)
               TXYZ(6)   = TXYZ(3) + TXYZ(6)

c               WRITE ( CMON,'(A,10(1X,I5),/,5A,1X,A,1X,I4)')
c     1                 '^^GR BOND ',
c     1                  (NINT(TXYZ(KJ)*GSCALE),KJ=1,6),
c     3                  0,0,0,
c     1                  NINT(GSCALE*0.25),
c     1                  '^^GR ''',CLAB(1:LLAB),''' ''',
c     1                            CLAB2(1:LLAB2),'''',
c     1                  ' ''et al. Aromatic Ring'' ', 101
c               CALL XPRVDU(NCVDU, 2,0)

#ifdef CRY_GUI
         CALL FSTBND( NINT(TXYZ(1)*GSCALE),NINT(TXYZ(2)*GSCALE),
     1             NINT(TXYZ(3)*GSCALE),NINT(TXYZ(4)*GSCALE),
     1             NINT(TXYZ(5)*GSCALE),NINT(TXYZ(6)*GSCALE),
     1             0,0,0,NINT(GSCALE*0.25),101,
     1             ISTORE(M41S),ISTORE(M41S+1),13,
     1             'Aromatic Ring',0,'' )


c               WRITE ( CMON,'(A,6F8.5)')
c     1                 '  AROMATIC RING: ',
c     1                  (STR11(ICENT+KJ),KJ=0,2),
c     1                  (STR11(IVECT+KJ),KJ=6,8)
c               CALL XPRVDU(NCVDU, 1,0)
#endif
             ENDDO

             WRITE (CMON,'(A/A)')'^^GR SHOW','^^CW'
             CALL XPRVDU(NCVDU, 2,0)
c             WRITE ( CMON, '(A)')'GUI-UP: Done L5'
c             CALL XPRVDU(NCVDU, 1,0)


            ELSE

             WRITE (CMON,'(A,2(/A))')'^^GR MODEL L5','^^GR SHOW','^^CW'
             CALL XPRVDU(NCVDU, 3,0)
c             WRITE ( CMON, '(A)')'GUI-UP: Empty L5'
c             CALL XPRVDU(NCVDU, 1,0)


            END IF

         ELSE IF ( ILST .EQ. 1 ) THEN   ! cell params - update info tab.

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(1).LE.0) CYCLE
               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(1).LE.0) THEN
                 WRITE(CMON,'(A)')
     1            '^^CO SAFESET [ _XIN1 TEXT "Input cell" ]'
                 CALL XPRVDU(NCVDU, 1,0)
                 CYCLE
               END IF
               IF(KHUNTR(1,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL01
            END IF
            CALL XRLIND(1, L01SR, NFW, LL, IOW, NOS, ID)
            IF ( L01SR.NE.ISERnn(1) )THEN
              ISERnn(1)  = L01SR
              WRITE(CMON,'(A)')'^^CO SAFESET [ _XIN1 TEXT "Edit cell" ]'
              CALL XPRVDU(NCVDU, 1,0)

211           FORMAT ('^^WI SAFESET [ _MT_CELL_A TEXT ',F8.4,' ]',/,
     1                '^^WI SAFESET [ _MT_CELL_B TEXT ',F8.4,' ]',/,
     1                '^^WI SAFESET [ _MT_CELL_C TEXT ',F8.4,' ]',/,
     1                '^^WI SAFESET [ _MT_CELL_AL TEXT  ',F7.3,' ]',/,
     1                '^^WI SAFESET [ _MT_CELL_BE TEXT  ',F7.3,' ]',/,
     1                '^^WI SAFESET [ _MT_CELL_GA TEXT ',F7.3,' ]',/,
     1                '^^CR')
              WRITE ( CMON, 211 ) (STORE(L1P1+J),J=0,2),
     1                          (STORE(L1P1+J)*RTD,J=3,5)
              CALL XPRVDU(NCVDU, 7,0)
            ENDIF

         ELSE IF ( ILST .EQ. 2 ) THEN   ! space group - update info tab.

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(2).LE.0) CYCLE
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(2).LE.0) THEN
                WRITE(CMON,'(A)')
     1           '^^CO SAFESET [ _XIN2 TEXT "Input space group" ]'
                CALL XPRVDU(NCVDU, 1,0)
                CYCLE
               END IF
               IF(KHUNTR(2,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL02
            END IF
            CALL XRLIND(2, L02SR, NFW, LL, IOW, NOS, ID)
            IF ( L02SR.NE.ISERnn(2) )THEN
              ISERnn(2)  = L02SR
              WRITE(CMON,'(A)')
     1        '^^CO SAFESET [ _XIN2 TEXT "Edit space group" ]'
              CALL XPRVDU(NCVDU, 1,0)

221         FORMAT ('^^CO SAFESET [ _MT_SPACEGROUP TEXT ''',
     1              4(A4,1X),''' ]')
              WRITE ( CMON, 221 ) (STORE(L2SG+J),J=0,MD2SG-1)
              CALL XPRVDU(NCVDU, 1,0)
            ENDIF

         ELSE IF ( ILST .EQ. 23 ) THEN   ! SFLS control - get F or F2.

            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(23).LE.0) CYCLE
               IF(KHUNTR(23,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(23).LE.0) CYCLE
               IF(KHUNTR(23,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL23
            END IF
            CALL XRLIND(23, L23SR, NFW, LL, IOW, NOS, ID)
            IF ( L23SR.NE.ISERnn(23) )THEN
              ISERnn(23)  = L23SR
              IF ( ISTORE ( L23MN + 1 ) .EQ. -1 ) THEN
               WRITE (CMON,2) '^^CO SAFESET [ _MT_REF_COEF TEXT ''F'' ]'
              ELSE IF ( ISTORE ( L23MN + 1 ) .EQ. 0 ) THEN
               WRITE (CMON,2)
     1                '^^CO SAFESET [ _MT_REF_COEF TEXT ''F squared'' ]'
              ELSE
               WRITE(CMON,2)
     1                '^^CO SAFESET [ _MT_REF_COEF TEXT ''Unknown'' ]'
              END IF
              CALL XPRVDU(NCVDU, 1, 0)
            ENDIF

         ELSE IF ( ILST .EQ. 29 ) THEN   ! asymm unit - update info tab.
            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(29).LE.0) CYCLE
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(29).LE.0) THEN
                 WRITE(CMON,'(A)')
     1        '^^CO SAFESET [ _XIN3 TEXT "Input formula / radiation" ]'
                 CALL XPRVDU(NCVDU, 1,0)
                 CYCLE
               END IF
               IF(KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL29
            END IF
            CALL XRLIND(29, L29SR, NFW, LL, IOW, NOS, ID)
            IF ( L29SR.NE.ISERnn(29) )THEN
              ISERnn(29)  = L29SR
              WRITE(CMON,'(A)')
     1         '^^CO SAFESET [ _XIN3 TEXT "Edit formula / radiation" ]'
              CALL XPRVDU(NCVDU, 1,0)

              WRITE( CMON(1),'(A)')'^^WI SAFESET [ _MT_FORMULA TEXT'
              WRITE( CMON(2),'(A)')'^^WI'''
              WRITE( CMON(3),'(A)')'^^WI ]'
              WRITE( CMON(4),'(A)')'^^CR'
231           FORMAT (A4,F9.3,'-')
              K = 6
              DO M29=L29,L29+(N29-1)*MD29,MD29
                WRITE (CMON(2)(K:),231) STORE(M29), STORE(M29+4)
                CALL XCRAS ( CMON(2),K )
                DO L = K-1,K-6,-1              !Remove trailing zeroes.
                  IF (CMON(2)(L:L).EQ.'0') THEN
                    CMON(2)(L:L)=' '
                  ELSE IF (CMON(2)(L:L).EQ.'.') THEN
                    CMON(2)(L:L)=' '
                    EXIT
                  ELSE
                     EXIT
                  END IF
                END DO
                K = K + 1
                IF ( K .GT. 70 ) EXIT
              END DO
              WRITE(CMON(2)(K:K),'(A)') ''''
              DO J = 1,K
                IF (CMON(2)(J:J).EQ.'-') CMON(2)(J:J)=' '
              END DO
              CALL XPRVDU(NCVDU, 4, 0)
            END IF
         ELSE IF ( ILST .EQ. 30 ) THEN   ! goodies - update info tab.
            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(30).LE.0) CYCLE
               IF(KHUNTR(30,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(30).LE.0) CYCLE
               IF(KHUNTR(30,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL30
            END IF
            CALL XRLIND(30, L30SR, NFW, LL, IOW, NOS, ID)
            IF ( L30SR.NE.ISERnn(30) )THEN
              ISERnn(30)  = L30SR

241           FORMAT ('^^WI SAFESET [ _MT_CR_MIN TEXT ',F8.4,' ]',
     1                ' SAFESET [ _MT_CR_MED TEXT ',F8.4,' ]',/,
     1                '^^WI SAFESET [ _MT_CR_MAX TEXT ',F8.4,' ]',
     1                ' SAFESET [ _MT_CR_TEMP TEXT  ',F5.1,' ]',/,
     1                '^^WI SAFESET [ _MT_CR_DCALC TEXT ',F7.3,' ]',
     1                ' SAFESET [ _MT_CR_MOLWT TEXT  ',F7.2,' ]',/,
     1                '^^WI SAFESET [ _MT_CR_CELLZ TEXT ',F4.0,' ]',/,
     1                '^^CR')
              WRITE ( CMON,241 ) STORE(L30CD), STORE(L30CD+1),
     1           STORE(L30CD+2), STORE(L30CD+6), STORE(L30GE+1),
     1           STORE(L30GE+4), STORE(L30GE+5)
              CALL XPRVDU(NCVDU, 5, 0)
242           FORMAT('^^WI SAFESET [ _MT_CR_SHAPE TEXT ''',8A4,''' ]',/,
     1              '^^WI SAFESET [ _MT_CR_COLOUR TEXT ''',8A4,''' ]',/,
     1                '^^CR')
              WRITE ( CMON, 242 ) (ISTORE(K),K=L30SH,L30SH+MD30SH-1),
     1                            (ISTORE(K),K=L30CL,L30CL+MD30CL-1)
              CALL XPRVDU(NCVDU, 3, 0)
243           FORMAT ('^^WI SAFESET [ _MT_OBS_MEAS TEXT ',F7.0,' ]',
     1                    ' SAFESET [ _MT_OBS_NMRG TEXT ',F7.0,' ]',/,
     1                '^^WI SAFESET [ _MT_OBS_RMRG TEXT ',F8.5,' ]',
     1                    ' SAFESET [ _MT_OBS_NFMRG TEXT ',F7.0,' ]',/,
     1                '^^WI SAFESET [ _MT_OBS_RFMRG TEXT ',F8.5,' ]',/,
     1                '^^CR')
              WRITE ( CMON,243 ) STORE(L30DR), STORE(L30DR+2),
     1           STORE(L30DR+3), STORE(L30DR+4), STORE(L30DR+5)
              CALL XPRVDU(NCVDU, 4, 0)
244           FORMAT ('^^WI SAFESET [ _MT_OBS_HMIN TEXT ',F4.0,' ]',
     1                    ' SAFESET [ _MT_OBS_HMAX TEXT ',F4.0,' ]',/,
     1                '^^WI SAFESET [ _MT_OBS_KMIN TEXT ',F4.0,' ]',
     1                    ' SAFESET [ _MT_OBS_KMAX TEXT ',F4.0,' ]',/,
     1                '^^WI SAFESET [ _MT_OBS_LMIN TEXT ',F4.0,' ]',
     1                    ' SAFESET [ _MT_OBS_LMAX TEXT ',F4.0,' ]',/,
     1                '^^WI SAFESET [ _MT_OBS_THMIN TEXT ',F4.0,' ]',
     1                    ' SAFESET [ _MT_OBS_THMAX TEXT ',F4.0,' ]',/,
     1                '^^CR')
              WRITE ( CMON, 244 ) ( STORE(L30IX+J), J=0,7)
              CALL XPRVDU(NCVDU, 5, 0)
245           FORMAT ('^^CO SAFESET [ _MT_OBS_INST TEXT ''',A8,''' ]')
              INS = ISTORE(L30CD+12) + 1
              IF (( INS .GT. 0 ) .AND. (INS. LE. 6)) THEN
                WRITE ( CMON, 245 ) CINST(INS)
              ELSE
                WRITE ( CMON, 245 ) 'New Type'
              END IF
              CALL XPRVDU ( NCVDU, 1, 0 )

              CCOL = ' none '
              IF (STORE(L30RF+3).GT.-9.9)
     1            WRITE(CCOL,'(F6.2)')STORE(L30RF+3)

246           FORMAT('^^WI SAFESET [ _MT_REF_R TEXT ',F8.2,' ]',
     1                   ' SAFESET [ _MT_REF_RW TEXT ',F8.2,' ]',/,
     1               '^^WI SAFESET [ _MT_REF_NPAR TEXT ',F9.0,' ]',
     1                   ' SAFESET [ _MT_REF_SCUT TEXT ',A,' ]',/,
     1               '^^WI SAFESET [ _MT_REF_GOOF TEXT ',F9.3,' ]',
     1                   ' SAFESET [ _MT_REF_MAXRMS TEXT ',F9.4,' ]',/,
     1               '^^WI SAFESET [ _MT_REF_NREF TEXT ',F7.0,' ]',/,
     1               '^^CR')
              WRITE ( CMON, 246 ) STORE(L30RF), STORE(L30RF+1),
     1            STORE(L30RF+2), CCOL,  STORE(L30RF+4),
     1            STORE(L30RF+7),STORE(L30RF+8)
              CALL XPRVDU(NCVDU, 5, 0)
            ENDIF


         ELSE IF ((ILST .EQ. 12).OR.(ILST .EQ. 16)) THEN   ! Directives

           IF ( ILST .EQ. 12 ) THEN
             IF(KEXIST(12).LE.0) THEN
               IF ( ISERnn(12) .EQ. -1 ) CYCLE
               ISERnn(12) = -1
               WRITE (CMON,'(''^^CO SAFESET [ _MT_L12 EMPTY ]'')')
               CALL XPRVDU(NCVDU,1,0)
               CYCLE
             END IF
             CALL XRLIND(12, L12SR, NFW, LL, IOW, NOS, ID)
             IF ( L12SR.NE.ISERnn(12) ) THEN
               ISERnn(12)  = L12SR
             ELSE
              CYCLE
             END IF
           ELSE IF ( ILST .EQ. 16 ) THEN
             IF(KEXIST(16).LE.0) THEN
               IF ( ISERnn(16) .EQ. -1 ) CYCLE
               ISERnn(16) = -1
               WRITE (CMON,'(''^^CO SAFESET [ _MT_L16 EMPTY ]'')')
               CALL XPRVDU(NCVDU,1,0)
               CYCLE
             END IF
             CALL XRLIND(16, L16SR, NFW, LL, IOW, NOS, ID)
             IF (L16SR.NE.ISERnn(16) ) THEN
               ISERnn(16)  = L16SR
             ELSE
              CYCLE
             END IF
           END IF

           WRITE (CMON,'(''^^WI SAFESET [ _MT_L'',I2,'' EMPTY ]'')')ILST
           CALL XPRVDU(NCVDU,1,0)


           LN=ILST
           IREC=0
           ISTAT = KLSCHK ( LN , 0 , 0 , ILSAVI, ILSMSG, IADDR, IERERR)
           IF ( ISTAT .LE. 0 ) THEN
            WRITE(CMON,'(A,I2)') 'No list to output: ',ILST
            CALL XPRVDU(NCVDU,1,0)
            CYCLE
           END IF
           CALL XRLIND ( LN, LSN, IADDI, LL, IOW, NOS, ID ) ! READ INDEX
           LAST=0
           NUMB=-1
           DO WHILE (KLDDRH(LAST,IADDI,IBUFF).GE.0) ! LOAD NEXT HEADER BLOCK
             IF(IBUFF(7).LT.0)THEN         !--CARD IMAGE  -  PRINT IT

               NUMB=NUMB+1

               INNJ=0           ! MARK THIS AS THE FIRST REAL CARD

               INNN=IBUFF(6)    ! FIND THE ADDRESS AND LENGTH POINTERS
               INNM=IBUFF(5)
               INNL=IBUFF(4)
               INNK=MIN0(INNM,20)  ! FIND THE LENGTH TO PRINT


600   FORMAT ('^^WI SAFESET [ _MT_L',I2,' TEXT "',A,'" ]')
                                                            
               DO WHILE(INNN.GT.0)   ! CHECK IF THERE ARE MORE CARDS TO PRINT
                 CALL XDOWNF(INNL,CARD(1),INNK)
                 INNL=INNL+KINCRF(INNM) ! UPDATE THE POINTERS
                 INNN=INNN-1
                 IF(INNJ.LE.0)THEN                              ! FIRST CARD
                   WRITE(CBUF,'(I5,1X,20A4)') NUMB, CARD
                   INNJ=1
                 ELSE                                ! NOT THE FIRST CARD
                   WRITE(CBUF,'(5X,1X,20A4)') CARD
                 END IF
                 LBUF = LEN_TRIM(CBUF)
                 IF ( LBUF .GT. 0 ) THEN
                   WRITE(CMON,600) ILST,CBUF(1:LBUF)
                   CALL XPRVDU(NCVDU, 1,0)
                 END IF
               END DO
             END IF
           END DO

           WRITE (CMON,
     1      '(''^^WI SET _MT_L'',I2,'' VIEWTOP'',/,''^^CR'')') ILST
           CALL XPRVDU(NCVDU,2,0)

         ELSE IF (ILST .EQ. 25) THEN   ! Twinning


           IF(KEXIST(25).LE.0) THEN
              IF ( ISERnn(25) .EQ. -1 ) CYCLE
              ISERnn(25) = -1
              WRITE (CMON,
     1 '(''^^CO SAFESET [ _MT_L25 EMPTY TEXT "No twin laws" ]'')')
              CALL XPRVDU(NCVDU,1,0)
              CYCLE
           END IF
           IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
              IF(KHUNTR(25,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
           ELSE
              IF(KHUNTR(25,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL25
           END IF


           CALL XRLIND(25, L25SR, NFW, LL, IOW, NOS, ID)
           IF ( L25SR.NE.ISERnn(25) ) THEN
              ISERnn(25)  = L25SR
           ELSE
             CYCLE
           END IF

           WRITE (CMON,
     1       '(''^^WI SAFESET [ _MT_L25 EMPTY TEXT "Twin laws" ]'')')
           CALL XPRVDU(NCVDU,1,0)

1106       FORMAT ('^^WI SAFESET [ _MT_L25 TEXT "',3(3F7.3,2X),'" ]')
           DO J = 0, N25-1
             M25 = L25+J*MD25
             WRITE(CMON,1106) (STORE(I),I = M25 , M25 + MD25-1)
             CALL XPRVDU(NCVDU, 1,0)
           END DO

           WRITE (CMON,'(''^^WI SET _MT_L25 VIEWTOP'',/,''^^CR'')')
           CALL XPRVDU(NCVDU,2,0)


         ELSE IF (ILST .EQ. 13) THEN   ! Radiation

           IF(KEXIST(13).LE.0) THEN
              IF ( ISERnn(13) .EQ. -1 ) CYCLE
              ISERnn(13) = -1
              WRITE (CMON,
     1         '(''^^CO SAFESET [ _MT_WAVE TEXT "Not set" ]'')')
              CALL XPRVDU(NCVDU,1,0)
              CYCLE
           END IF
           IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
              IF(KHUNTR(13,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
           ELSE
              IF(KHUNTR(13,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL13
           END IF


           CALL XRLIND(13, L13SR, NFW, LL, IOW, NOS, ID)
           IF ( L13SR.NE.ISERnn(13) ) THEN
              ISERnn(13)  = L13SR
           ELSE
             CYCLE
           END IF

1107       FORMAT ('^^CO SAFESET [ _MT_WAVE TEXT "',F8.5,1X,
     2             'Angstroms (',A,')" ]')
           WRITE(CMON,1107) STORE(L13DC),
     2  CRADTN(ISTORE(L13DT+1)+2)(1:LEN_TRIM(CRADTN(ISTORE(L13DT+1)+2)))
           CALL XPRVDU(NCVDU, 1,0)


         ELSE IF ( ILST .EQ. 4 ) THEN   ! Weighting scheme
            IF ( IULN .LT. 0 ) THEN ! not allowed to load lists, ensure loaded
               IF(KEXIST(4).LE.0) CYCLE
               IF(KHUNTR(4,0,IADDL,IADDR,IADDD,-1).NE.0) GOTO 9910
            ELSE
               IF(KEXIST(4).LE.0) CYCLE
               IF(KHUNTR(4,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL04
            END IF
            CALL XRLIND(4, L04SR, NFW, LL, IOW, NOS, ID)
            IF ( L04SR.NE.ISERnn(4) )THEN
              ISERnn(4)  = L04SR

              ITYPE=ISTORE(L4C)
              call xsum04(0,ctext)

602   FORMAT ('^^WI SAFESET [ _MT_WGHT TEXT ''',2A,
     1        ''' ]')
603   FORMAT ('^^WI SAFESET [ _MT_WGHT TEXT ''',A,2A,F10.3,A,F10.3,
     1        ''' ]')
604   FORMAT ('^^WI SAFESET [ _MT_WGHT TEXT ''',A,2A,F10.3,
     1        ''' ]')
605   FORMAT ('^^WI SAFESET [ _MT_WGHT TEXT ''',A,2A,F10.3,A,F10.3,A,
     1        ''' ]')
606   FORMAT ('^^WI SAFESET [ _MT_WGHT TEXT ''',A,2A,A,4(F10.3,A),''' ]'
     1     ,/,'^^WI SAFESET [ _MT_WGHT TEXT ''',A,2(F10.3,A),''' ]')
607   FORMAT ('^^WI SAFESET [ _MT_WGHT TEXT ''',A,A,A,F10.3,A,
     1        ''' ]')

              WRITE (CMON,'(''^^WI SET _MT_WGHT EMPTY'')')
              CALL XPRVDU(NCVDU,1,0)


              JTYPE = ICON41
              IF (JTYPE .EQ. 3) THEN 
                IF (ISTORE(L23MN+1) .GE. 0) THEN 
                  IF (  (ITYPE .EQ. 10) .OR. (ITYPE .EQ. 11) .OR.
     1                  (ITYPE .EQ. 14) .OR. (ITYPE .EQ. 15) .OR.
     1                  (ITYPE .EQ. 17) .OR. (ITYPE .EQ. 16) ) THEN
                    JTYPE = 2
                  ELSE
                    JTYPE = 1
                  ENDIF
                ELSE
                  JTYPE = 0
                ENDIF
              ENDIF

              CMOD = ' '
              IF ( JTYPE .EQ. 1 )
     1              CMOD = '(1/4Fo**2) x '

              CFM  = 'Fo'
              CFMC = 'Fc'
              IF ( JTYPE .EQ. 2 ) THEN
                   CFM  = 'Fo**2'
                   CFMC = 'Fc**2'
              END IF

              CWT = 'w = '
              IF ( IROBUS .EQ. 1 ) THEN
                 CWT = 'w` ='
                 CMOD = ' '
              END IF

              IF ( IDUNITZ .EQ. 1 ) THEN
                 CWT = 'w` ='
                 CMOD = ' '
              END IF

              LMOD = LEN_TRIM(CMOD) + 1
              LFM  = LEN_TRIM(CFM) + 1

              SELECT CASE (ITYPE)

              CASE (1)
                 WRITE(CMON,603) CWT,CMOD(1:LMOD),
     1           '('//CFM(1:LFM)//'/',STORE(L4),
     1           ')**2, if '//CFM(1:LFM)//' <= ',STORE(L4)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,603) CWT,CMOD(1:LMOD),
     1           '(',STORE(L4),
     1           '/'//CFM(1:LFM)//')**2, if '//CFM(1:LFM)//' > ',
     1           STORE(L4)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (2)  
                 WRITE(CMON,604) CWT, CMOD(1:LMOD),
     1           '1 if '//CFM(1:LFM)//' <= ',STORE(L4)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,603) CWT, CMOD(1:LMOD),
     1           '(',STORE(L4),
     2           '/'//CFM(1:LFM)//')**2, if '//CFM(1:LFM)//' > ',
     3           STORE(L4)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (3)
                 WRITE(CMON,605) CWT, CMOD(1:LMOD),
     1            '(1+[('//CFM(1:LFM)//' - ',
     2            STORE(L4+1), ')/', STORE(L4),
     3           ']**2)**-1'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (4)
                 WRITE(CMON,2) CWT,CMOD(1:LMOD)//
     1           '[P1 '//CFM(1:LFM)//') + '//
     2           'P2 '//CFM(1:LFM)//'**2 + ...'//
     3           ' + Pn '//CFM(1:LFM)//'**n]'
     4           //'**-1'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'P1 -> Pn = ',
     1           CTEXT(4)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (5,6)
                 WRITE(CMON,602) 'w = ', 'user supplied weights.'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (7)
                 WRITE(CMON,602) CWT,
     1            CMOD(1:LMOD)//'1/sigma('//CFM(1:LFM)//')'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (8)
                 WRITE(CMON,602) CWT,CMOD(1:LMOD)//
     1           '1/sigma**2('//CFM(1:LFM)//')'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (9)
                 WRITE(CMON,602) CWT,CMOD(1:LMOD)//'1'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (11)
                 WRITE(CMON,602) CWT,CMOD(1:LMOD)//
     1           '[P0T0`(x) + P1T1`(x) + ... + Pn-1Tn-1`(x)]**-1'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'where Pi are the '//
     5           'coefficients of a Chebychev series in '//
     6           'ti(x), where x = ',CFM(1:LFM)//'/'//
     7           CFM(1:LFM)//'max.'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'P0 - Pn-1 = ',
     1           CTEXT(4)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (12)
                 WRITE(CMON,607) CWT,CMOD(1:LMOD),
     1            '[(sin theta)/lambda]**(',STORE(L4),')'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (13)
                 WRITE(CMON,605) 'w =',CMOD(1:LMOD),
     1            '[old-weight] x '//
     2            'e**[8 x pi**2 x (',STORE(L4),'/',STORE(L4+1),
     3            ')x((sin theta)/(lambda))**2]'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (15)
                 WRITE(CMON,602) 'w =',CMOD(1:LMOD)//
     1           'w` x [1 - (Delta (F) / '//
     2           '6 x Delta (F est))**2]**2'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'w` =',
     1           '[P0T0`(x) + P1T1`(x) + ... + Pn-1Tn-1`(x)]**-1'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'where Pi are the '//
     5           'coefficients of a Chebychev series in '//
     6           'ti(x), where x = ',CFMC(1:LFM+1)//'/'//
     7           CFMC(1:LFM+1)//'max.'
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'P0 - Pn-1 = ',
     1           CTEXT(4)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              CASE (16)
                 IF ( ABS(STORE(L4+2)).LT.ZERO ) THEN
                    CBUF = '1/'
                 ELSE IF (STORE(L4+2).GT.0) THEN
                    WRITE (CBUF,'(A,F10.4,A)') 'e**[',STORE(L4+2),
     1              ' x (sin(theta)/lambda)**2]'
                 ELSE
                    WRITE (CBUF,'(A,F10.4,A)') '1 - e**[',STORE(L4+2),
     1              ' x (sin(theta)/lambda)**2]'
                 END IF
                 WRITE(CMON,606) CWT,CMOD(1:LMOD),
     1            CBUF(1:LEN_TRIM(CBUF)),
     1          '[sigma**2('//CFM(1:LFM)//') + (',
     2          STORE(L4),' x P)**2 + ',STORE(L4+1),
     3          ' x P + ', STORE(L4+3), ' + ', STORE(L4+4),
     4          ' x sin theta]','P = ',STORE(L4+5),
     5          ' x max('//CFM(1:LFM)//',0) + ', 1-STORE(L4+5),
     6          ' x '//CFMC(1:LFM+1)
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XCREMS(CMON(2),CMON(2),NOCARE)
                 CALL XPRVDU(NCVDU,2,0)
              END SELECT

              CMOD = ' '
              IF ( JTYPE .EQ. 1 )
     1              CMOD = '(1/4Fo**2) x '
              LMOD = MAX(1,LEN_TRIM(CMOD))

              IF ( ( IROBUS .EQ. 1 ) .AND. ( IDUNITZ. EQ. 1 ) ) THEN
                 WRITE(CMON,605) 'w" = ',
     1            ' ',
     2            'e**[8 x (',DUN01,'/',DUN02,
     3            ')x(pi x sin(theta)/lambda)**2]'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,607) 'w* =',
     1           '[1 - ','(Delta (F) / ',
     2           ROBTOL,
     3           ' x Delta (F est))**2]**2'
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'w =', CMOD(1:LMOD)//'w` x w" x w*'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              ELSE IF ( IROBUS .EQ. 1 ) THEN
                 WRITE(CMON,607) 'w" =',
     1           '[1 - ','(Delta(F) / ',
     2           ROBTOL,' x Delta (F est))**2]**2'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'w =', CMOD(1:LMOD)//'w` x w"'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              ELSE IF ( IDUNITZ .EQ. 1 ) THEN
                 WRITE(CMON,605) 'w" = ',
     1            '',
     2            'e**[8 x (',DUN01,'/',DUN02,
     3            ')x(pi sin(theta)/lambda)**2]'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
                 WRITE(CMON,602) 'w =', CMOD(1:LMOD)//'w` x w"'
                 CALL XCREMS(CMON(1),CMON(1),NOCARE)
                 CALL XPRVDU(NCVDU,1,0)
              END IF
              WRITE (CMON,'(''^^WI SET _MT_WGHT VIEWTOP'',/,''^^CR'')')
              CALL XPRVDU(NCVDU,2,0)
            END IF
         END IF

      END DO
      RETURN

9900  CONTINUE
      WRITE ( CMON, '(A,/,A)')'Failed to open file : ',CFILEN(1:ILENG)
      CALL XPRVDU(NCVDU, 2,0)
      RETURN
9910  CONTINUE
c      WRITE ( CMON, '(A)')'GUI-UP: Some required lists not loaded.'
c      CALL XPRVDU(NCVDU, 1,0)
      RETURN
9915  CONTINUE
c      WRITE ( CMON, '(A)')'GUI-UP: Some required lists not present.'
c      CALL XPRVDU(NCVDU, 1,0)
      RETURN
9920  CONTINUE
      WRITE ( CMON, '(A)')'GUI-UP: Error loading list 41.'
      CALL XPRVDU(NCVDU, 1,0)
      RETURN

      END





cCODE FOR KBDDEV
c      FUNCTION KBDDEV ( IAT1P, IAT2P, DEVN )
c
cC Return bond type (1-9) if it is found in the list.
cC Return number of stdev's of actual value from mean.
c
c\STORE
c\ISTORE
c\QSTORE
c\TLST18                           
c
c      KBDDEV = 0
c      DEVN = 0.0
c
c      IAT1N = ISTORE(IAT1P)     
c      IAT1S = NINT(STORE(IAT1P+1))     
c      IAT2N = ISTORE(IAT2P)     
c      IAT2S = NINT(STORE(IAT2P+1))     
c      
c        DO 800 I = 1, NB18
c                        
c            JAT1N = IBLK(I,1)
c            JAT1S = NINT(BBLK(I,2))
c            JAT2N = IBLK(I,3)
c            JAT2S = NINT(BBLK(I,4))
c
c            IF( ( (IAT1N.EQ.JAT1N) .AND. (IAT1S.EQ.JAT1S) .AND.
c     1            (IAT2N.EQ.JAT2N) .AND. (IAT2S.EQ.JAT2S) ) .OR.
c     2          ( (IAT1N.EQ.JAT2N) .AND. (IAT1S.EQ.JAT2S) .AND.
c     3            (IAT2N.EQ.JAT1N) .AND. (IAT2S.EQ.JAT1S) ) ) THEN
c
c               BLEN = BBLK(I,5)
c               KBDDEV = NINT(BBLK(I,6))
c               DEVN = BBLK(I,8)
c               RETURN
c            END IF
c800   CONTINUE
c
c      RETURN
c      END


