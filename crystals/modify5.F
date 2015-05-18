C $Log: not supported by cvs2svn $
C Revision 1.62  2013/11/01 16:37:04  rich
C Use fixed random seed for XRAND or tests break.
C
C Revision 1.61  2012/01/04 15:52:41  rich
C Don't issue a warning if no changes to L5.
C
C Revision 1.60  2011/07/05 10:48:02  djw
C Increase the field width for PART in XMDMON fro I4 to I7
C
C Revision 1.59  2011/04/20 09:55:03  djw
C Small fix to XCENTRE
C
C Revision 1.58  2011/04/08 12:55:23  djw
C New module XORIGIN to apply permitted origin shifts
C
C Revision 1.57  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.56  2011/03/15 08:45:40  djw
C Add a COMMENT about loading L5/L10
C
C Revision 1.55  2010/09/17 07:12:51  djw
C Increase format width for overall parameters
C
C Revision 1.54  2009/05/01 08:42:34  djw
C Add comments explaining Splitting
C
C Revision 1.53  2008/11/07 08:41:17  djw
C Dont try to update L41 if there is only one atom
C
C Revision 1.52  2008/10/01 11:11:54  djw
C Support for treatment of Deuterium as hydrogen
C
C Revision 1.51  2008/09/08 10:18:32  djw
C Enable/inhibit punching of ADP info from XPRAXI
C
C Revision 1.50  2008/02/14 10:27:25  djw
C Remove writes to ncawu
C
C Revision 1.49  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.1.1.1  2004/12/13 11:16:08  rich
C New CRYSTALS repository
C
C Revision 1.48  2004/09/29 10:01:48  rich
C Removed a debugging print statement.
C
C Revision 1.47  2004/05/18 14:16:32  rich
C Create empty L40 structure if one doesn't exist.
C
C Revision 1.46  2004/03/10 13:10:46  rich
C 1) Do lexical scanning properly - UNTIL wasn't working.
C 2) Report error if vector has zero length.
C
C Revision 1.45  2004/03/09 09:38:03  rich
C
C Added a 'ROTATE' directive to #EDIT. There are three modes of operation:
C
C   rotate angle px py pz vx vy vz [atoms]
C   rotate angle patom vx vy vz [atoms]
C   rotate angle patom vatom [atoms]
C
C The first rotates the specified [atoms], angle degrees around the vector
C vx,vy,vz keeping point px,py,pz fixed. (px-pz and vx-vz are given in
C crystal fractions).
C
C The rotation is in an orthogonal system so all distances and angles
C within the moved set of atoms are preserved.
C
C The second notation replaces the point to keep fixed with patom, the name
C of an atom. Its coordinates are used to obtain px py and pz.
C
C The third notation uses patom to get px, py and pz, and the vector from patom
C to vatom to get vx, vy and vz.
C
C Examples:
C
C 1) Rotate the hydrogens of a methyl group by sixty degrees.
C
C     #EDIT
C     ROTATE 60 C(1) C(2) H(20) H(21) H(22)
C     END
C
C 2) Turn a phenyl ring through 30 degrees around its rotation axis.
C
C     #EDIT
C     ROTATE 30 C(1) C(20) C(21) C(22) C(23) C(24) C(25)
C     END
C
C 3) Flip a residue 90 degrees around the a-axis about its centroid, QC(1)
C    (see also CENTROID and INSERT RESIDUE directives)
C
C     #EDIT
C     INSERT RESIDUE
C     CENTROID 1 RESIDUE(1)
C     ROTATE 90 QC(1) 1 0 0 RESIDUE(1)
C     END
C
C Revision 1.44  2004/02/26 13:40:56  djw
C enable maths on he integer fields
C
C Revision 1.43  2003/09/16 13:30:08  rich
C Oops. Don't assume that real cell parameters are inverse of reciprocal. Fixed.
C
C Revision 1.42  2003/09/15 15:27:06  rich
C Upgraded TRANSFORM directive to handle transformations of ADPs better.
C Rotation matrix, R, was applied: Unew = RUR', which only works properly
C when all cell axes are identical length. Instead, we use
C Unew = inv(N)RNUN'R'inv(N)', where N has the reciprocal cell lengths
C along its diagonal.
C
C Revision 1.41  2003/09/11 19:41:22  rich
C Transformation matrix was applied incorrectly to Uij tensor. Now fixed.
C
C Revision 1.40  2003/07/17 13:46:40  rich
C Remove unnecesary updating of the GUI during #EDIT with GUI HIGH set
C on.
C
C Revision 1.39  2003/07/09 11:34:39  rich
C REmove line break in print.
C
C Revision 1.38  2003/06/27 11:59:04  rich
C Globally replace FRAGMENT (slot in L5) and FRAGMENT(...) lexical keyword
C with RESIDUE. This should reduce confusion about what it is, and as FRAGMENT
C is only months old, no-one should notice the change anyway. So now it is
C #EDIT
C DELETE RESI(1) RESIDUE(2)
C END
C to delete residues 1 and 2.
C
C Revision 1.37  2003/06/20 13:38:23  rich
C
C Fix bug in #EDIT/DELETE when using the new PART,RESIDUE or TYPE
C keywords to select atoms - the change in size of L5 in between
C calls to KATOMU was confusing things - as a result only half
C the atoms requested were being deleted.
C
C Revision 1.36  2003/05/07 12:18:54  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.35  2003/02/27 12:48:35  rich
C Special case PART, REFINE and RESIDUE in #EDIT CHANGE, so that values
C get stored as integers.
C
C Revision 1.34  2003/02/27 11:39:50  rich
C Code to INSERT RESIDUE id into RESIDUE slot in List 5. The maximum residue number
C is returned to scripts (if they are listening) in the variable 'EDIT:FRAGMAX'.
C This is the first of many places that this method will be used.
C
C Revision 1.33  2002/12/16 18:00:27  rich
C New Perturb command. Allows per parameter shift multipliers, and a general
C multiplier to apply to all shifts. The shifts respect weights setup in
C List 22 so that atoms do not move from special positions, and competing
C occupancies continue to add up to the same number. By default it creates
C new list 5s, but can be forced not to by directing: "WRITE OVER=YES".
C Shifts for XYZ are given in Angstrom, for OCC in natural units, for overall and
C temperature factors as a fraction of the existing value.
C
C Revision 1.32  2002/10/14 12:33:24  rich
C Support for DVF command line version.
C
C Revision 1.31  2002/07/25 15:58:05  richard
C New DRENAME directive for #EDIT, renames an atom, but moves any existing clashes
C out of the way. (Next unused serial for that atom type.)
C
C Revision 1.30  2002/07/23 15:55:45  richard
C Load lists 3,29,40 and 41 *BEFORE* the ordered list 5, otherwise what's going
C to happen when you add an ATOM? That's right: a mess.
C
C If MONGUI is 2 then update the model. Recalculate bonds first as #edit has
C the power to muddle the order of L5 around which makes the bond list
C pointers go wrong.
C
C Revision 1.29  2002/07/23 10:02:09  richard
C
C INSERT NCONN and INSERT RELAX use L41 to work out bonding. L41 is dangerously
C useless if L5 has been sorted in #EDIT. One can now call XBCALC(2) to recalculate
C bonds. L5 is not reloaded in this mode.
C
C Revision 1.28  2002/07/22 08:11:15  richard
C
C Added new #EDIT directive: CLASH. MODE=REPORT, FIXLATTER or FIXFORMER. Either
C just reports clashes, or fixes them (FIXLATTER changing serials lower down
C the list, and FIXFORMER changing those higher up the list.) The new serial is
C chosen to be one higher than ANY existing serial in L5.
C
C Revision 1.27  2002/07/18 17:11:58  richard
C If 'monitor' is set to off, and users 'QUIT's from #EDIT, then don't print
C the warnings. This allows SCRIPTS to sneakily do things without alarming
C the user with what looks like error messages.
C
C Revision 1.26  2002/07/17 09:29:49  richard
C
C In #DISTANCE added option: SEL RANGE=L41
C This will use the bond list (41) to determine what is connected.
C
C In #DISTANCE added option: OUT PUNCH=DELU D1DEV=x D2DEV=y
C This will output VIBR restraints to the punch file with an esd
C of x for 1,2 distances and y for 1,3 distances. You probably want an
C EXCL H if using the DELU option.
C
C In #DISTANCE added option: OUT PUNCH=SIMU S1DEV=x S2DEV=y
C This will output U(IJ) restraints to the punch file with an esd
C of x for normal bonds and y for terminal bonds. A bond is terminal
C if it connects to an atom with no other connections except hydrogen.
C This option uses LIST 41 to determine whether the atom is 'terminal',
C but the RANGE can still be set at user's discretion. You probably want an
C EXCL H if using the SIMU option.
C
C In #EDIT added option: INSERT NCONN
C This will put the number of connections to other atoms (according to L41)
C into the SPARE slot in List 5.
C
C In #EDIT added option: INSERT RELAX
C This will start with the electron count of each atom in SPARE, and
C keep cycling through the bond list, adding the current value of
C SPARE to all the neighbouring atoms. It will cycle until the number
C of unique values of SPARE stops increasing.
C
C distangl.src now contains a routine KDIST4, which works like KDIST1 but using
C the existing L41. It should be noted that the bond lengths stored in L41
C may be out of date as the bonding is only recalculated every now and again.
C
C Revision 1.25  2002/06/28 16:13:09  Administrator
C ensure that the field NEW can hold characters
C
C Revision 1.24  2002/05/15 10:13:26  richard
C New EDIT command - GUISELECT, works like select and typechange, but doesn't
C modify L5, just selects the atoms in the window.
C e.g. #EDIT/GUISEL SPARE LT 40/END selects all atoms where spare < 40.
C Warning: if you execute a command that changes list 5 in the same #EDIT
C block the selections will be lost on END, as the L5 is updated.
C
C Revision 1.23  2002/05/08 08:51:50  richard
C New EDIT directive GRAPH OF=SPARE
C plots a graph of whatever is in the SPARE column in L5. (You need to have
C an appropriate plot window open or nothing happens.)
C
C Revision 1.22  2002/01/09 14:44:38  Administrator
C correct caption for shifted atoms
C
C Revision 1.21  2001/11/12 17:03:11  Administrator
C enable printing of PARTs from LIST 5
C
C Revision 1.20  2001/04/30 11:50:16  ckpgroup
C fix-up omitted rflections when re-indexing matrix has non-integral results' read6.src
C
C Revision 1.19  2001/03/16 16:54:18  CKP2
C fis split atoms
C
C Revision 1.18  2001/02/26 10:29:07  richard
C Added changelog to top of file
C
C
CODE FOR XMOD05
      SUBROUTINE XMOD05
C--SUBROUTINE TO ALTER THE LIST 5 STORED
C
C        THIS ROUTINE ALLOWS THE USER TO EDIT A LIST 5 OR 10. THE
C      OUTPUT LIST CAN BE EITHER A LIST 5 OR 10. DIRECTIVES ARE
C      EXECUTED AS THEY ARE TYPED IN.
C
C        A NEW LIST WILL BE CREATED ONLY IF THE OLD LIST IS CHANGED,
C      OR THE LIST TYPE IS CHANGED. IN INTERACTIVE MODE A NEW LIST
C      WILL BE CREATED EVEN IF THERE ARE ERRORS UNLESS THE USER ENDS
C      WITH A 'QUIT' DIRECTIVE. IN OTHER MODES, NO NEW LIST IS CREATED
C      IF AN ERROR OCCURS.
C
C
C      VERSION 3A        OCTOBER 1977
C              3.10      AUGUST 1983            DJW
C                              MONITOR CHANGES MADE TO LIST 5. ADD
C                              UEQUIV INSTRUCTION.
C
C      VERSION 4.00      AUGUST 1983            PWB
C                              EXECUTE SINGLE DIRECTIVES AS THEY ARE
C                              TYPED IN.
C              4.01      AUGUST 1983            PWB
C                              'READ' REPLACED BY 'ATOM'
C              4.02      SEPTEMBER 1983         PWB
C                              ERROR HANDLING RATIONALISED. KEEP/MOVE
C                              REWRITTEN
C              4.03      APRIL 1984             PWB (CRYSTALS ISSUE 7)
C                              LIST DIRECTIVES INDICATES KEPT ATOMS
C                              AND OTHER MINOR MAINTENANCE
C              4.04      MAY 1984               PWB
C                              CORRECTION TO DIVIDE DIRECTIVE
C                              CHANGE CALL TO 'XLXINI'
C              4.05      MAY 1984               PWB
C                              CHANGE CALL TO 'XMDMON'
C                              MONITOR CHANGES TO OVERALL PARAMETERS
C                              ALLOW ARITHMETIC ON OVERALL PARAMETERS
C              4.06      JULY 1984              PWB
C                              ADD 'SORT' DIRECTIVE
C              4.07      AUGUST 1984            PWB
C                              CORRECTION TO ROTATE. ATOM NAMES ARE
C                              REQUIRED
C              4.08      AUGUST 1984            PWB
C                              MOVE/KEEP ROUTINE ( KMDMOV ) REWRITTEN
C              5.02      DECEMBER 1996          DJW
C                              PERTURB
C                        FEB 97 GRAPHICS DATA BASE
C
C              5.10      NOV 98 lUDGER SCHROEDERS EDITS
C              5.11      APR 99  GUI UPDATE FLAG
C              5.12      JAN 00  'RESET' ADDED
C
C
C      SOME VARIABLES USED ( COMMON BLOCK XMDCOM ) :-
C
C
C       MONLVL      MONITOR LEVEL
C            0      NO MONITORING
C            1      LOW LEVEL MONITORING
C            2      NORMAL LEVEL MONITORING
C            3      HIGH LEVEL MONITORING
C
C       ICHNG       LIST CHANGE FLAG
C            0      NO CHANGES TO LIST
C           >0      CHANGES HAVE BEEN MADE
C
C
C       LA          INPUT LIST TYPE ( 5 / 10 )
C       LB          OUTPUT LIST TYPE ( 5 / 10 )
C
C       MKEEP       'KEEP' FLAG ( +VE = 'KEEP' HAS BEEN USED )
C       NKEEP       NUMBER OF KEPT ATOMS
C       IKEEP       POSITION TO WHICH NEXT 'KEPT' ATOM WILL BE MOVED
C       IPSEQ       POSITION TO WHICH NEXT 'MOVED' ATOM WILL BE MOVED
C
C
C       IQUIT       'QUIT' FLAG ( +VE = ABANDON EDITING. NO NEW FILE )
C       ICHKER      ERROR CHECK FLAG. ( +VE = NO NEW LIST IF ERRORS )
C
C
C      USAGE OF 'ISTORE'/'STORE'
C
C      PERMANENTLY ALLOCATED AREAS
C
C            START       SIZE        USAGE
C            -----       ----        -----
C            ICOMBF      50          COMMAND PROCESSING 'COMMON BLOCK'
C            ITEMP       20          ATOM MOVING
C            JTEMP       9           ROTATION OF T.F. S
C            KTEMP       9           ROTATION OF T.F. S
C            IMONBF      5           CONTROL AREA FOR MONITORING
C            MQ          100         ATOM HEADERS ETC.
C            MD            4000        LEXICAL INPUT BUFFER
C                                      (SET IN XLXINI)
C            -           ( VAR )     LIST 1
C            -           ( VAR )     LIST 2
C            -           ( VAR )     LIST 5 / 10 ( THIS AREA WILL BE
C                                    EXTENDED BY CREATE / ATOM / ETC. )
C
C      SCRATCH AREAS ( NFL IS ALWAYS RESET AFTER USE )
C
C            LTEMP       ( N5 )      'UEQUIV'
C            IFOUND      ( N5 )      'SORT' ( USED IN 'KMDSRT' )
C            IADDRS      ( N5 )      'SORT' ( USED IN 'KMDSRT' )
C            IBUFFR      ( MD5 )     'SORT' ( USED IN 'KMDSRT' )
C
C      THE LAST PERMANENT ITEM IS THE RECORD IN LIST 5/10 CONTAINING
C    THE ATOMIC PARAMETERS
C
C
C-C-C
C-C-C-DEFINITION OF VARIABLES FOR CHANGES BY LS
      REAL SUMUIJ,SUMOCC,SUMUISO,SIDI,SUMDI,MAXDI
      INTEGER NUMDISO,NFLSPEC
c      character *20 ctemp
      character *21 CATOM1
      DIMENSION XCF(3), VA(3), ROF(3,3), RCA(3,3), XWORKS(4)
C - Matrices to hold real and reciprocal unit cell lengths on diagonal:
      DIMENSION RCPD(9), RCPDI(9)
C-C-C
C
C
C--
C----- THE INVERSE DIAGONAL MATRIX FOR TRANSFORMING UANISO
      DIMENSION DANISO(3)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM12.INC'
C
      DIMENSION ICOND(6)
C----- KEYS FOR LOADED LISTS ONLY 3 AND 29 FOR NOW
      DIMENSION KLST(5)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST20.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'ICOM40.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XMDCOM.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XLXPRT.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST12.INC'
      INCLUDE 'QLST40.INC'
C
      INTEGER PEAK,QCENT
      INTEGER QSPHERE,QLINE,QRING
C
      DATA NWCOND/1/,NCOND/6/,LCOND/1/
#ifdef _HOL_
      DATA ICOND(1)/4HEQ  /,ICOND(2)/4HNE  /,ICOND(3)/4HLT  /
      DATA ICOND(4)/4HLE  /,ICOND(5)/4HGT  /,ICOND(6)/4HGE  /
C
      DATA KHYD /4HH   /
      DATA KDET /4HD   /
      DATA PEAK/4HQ   /,QCENT/4HQC  /
C-C-C-DEFINITION OF ATOM TYPE ABBREV. FOR SPECIALS
      DATA QSPHERE/4HQS  /,QLINE/4HQL  /,QRING/4HQR  /
#else
      DATA ICOND(1)/'EQ  '/,ICOND(2)/'NE  '/,ICOND(3)/'LT  '/
      DATA ICOND(4)/'LE  '/,ICOND(5)/'GT  '/,ICOND(6)/'GE  '/
C
      DATA KHYD /'H   '/
      DATA KDET /'D   '/
      DATA PEAK/'Q   '/,QCENT/'QC  '/
C-C-C-DEFINITION OF ATOM TYPE ABBREV. FOR SPECIALS
      DATA QSPHERE/'QS  '/,QLINE/'QL  '/,QRING/'QR  '/
#endif

      DATA IMONSZ/5/
C
C----- LOOP COUNTER
      DATA ILOOP/0/
C-C-C
C----- VERSION 510 INCLUDES ALL LUDGER SCHROEDERS CHANGES
      DATA IVERSN/512/
C
C -- **** INITIALISATION SECTION ****
      CALL XTIME1 (2)
C
C -- CLEAR LIST CHAIN ( XRSL IS NOT CALLED , AS THE INFORMATION IN
C    LIST 50 MUST REMAIN AVAILABLE FOR COMMAND PROCESSING THROUGHOUT
C    THIS ROUTINE )
C
      CALL XCSAE
C----- CLEAR LIST 5 ADDRESS TO INHIBIT GRAPHICS
      L5=0
      LA=0
      LB=0
CDJWAPR99 SET ILOOP TO INDICATE NO CHANGES YET
      ILOOP=0
C
C    THE LOADING OF LISTS ETC. IS LEFT UNTIL THE 'MODIFY' DIRECTIVE
C    IS READ IN.
C
C -- ALLOCATE COMMAND BUFFER
      IDIMBF=50
CMAR98
      ICOMBF=KSTALL(IDIMBF)
      CALL XZEROF (STORE(ICOMBF),IDIMBF)
C -- WORK SPACE FOR ROTATION OF U'S ETC.
      ITEMP=KSTALL(20)
      JTEMP=KSTALL(9)
      KTEMP=KSTALL(9)
C -- ALLOCATE CONTROL SPACE FOR MONITOR ROUTINES
      IMONBF=KSTALL(IMONSZ)
      CALL XZEROF (ISTORE(IMONBF),IMONSZ)
C -- SPACE FOR ATOM HEADERS
      MQ=KSTALL(100)
C -- RELATIVE POSITIONS IN COMMAND PROCESSING BLOCK
C -- THESE ARE THE COMMON BLOCK OFFSETS LESS 1
      IMDAT1=9
      IMDAT2=10
      IGTYPE=38
      ICLASH=39
C -- NOTE - THE 'ATOM' DIRECTIVE REQUIRES A SPACE OF MD5 (=18) WORDS
C---- NEXT FREE ADDRESS IS 29.
      IMDATM=11
Cdjwapr99
C----- THE GUI LEVEL OFFSET AND DEFAULT VALUE (LOW/OFF)
      IMDGUI=35
      MONGUI=-1
C----- THE OFFSETS FOR THE INPUT/OUTPUT LIST NUMBERS
      IMDINP=36
      IMDOUT=37
C -- SET RECORD NUMBER FOR RECORD IN LIST 5 CONTAINING ATOMS
      IATREC=101
C -- SET LIST CREATION FLAGS
      IQUIT=0
      ICHKER=1
      IF (IQUN.EQ.JQUN) ICHKER=0
C -- INITIALISE INPUT PROCESSING
      CALL XLXINI (INEXTD,1)
C
      INCLUDE 'IDIM12.INC'
C
C--INDICATE THAT LIST 12 IS NOT TO BE USED
      DO 50 I=1,IDIM12
         ICOM12(I)=NOWT
50    CONTINUE
C

60    CONTINUE
C No point in updating GUI on first run. (It's already there).
C Or on the directive FOLLOWING an EXEC.
      IGUIUP =0
C
100   CONTINUE
cdjwoct08
c      only if more than one atom
      if (n5 .gt. 1) then
       IF (MONGUI.GE.2) THEN
        IF ( IGUIUP .EQ. 0 ) THEN
          IGUIUP = 1
        ELSE
          CALL XBCALC(2)    ! Re-calculate bonding
          CALL XGUIUP (-5)  ! Update GUI model
        END IF
       END IF
      endif
C
C -- **** MAIN INSTRUCTION LOOP ****
C
C -- MAKE SURE THE BUFFER IS EMPTY
      CALL XMDMON (0,0,0,0,0,0,0,0,0,1,ISTORE(IMONBF))
C -- READ A SINGLE SET OF DIRECTIVES
      IDIRNM=KLXSNG(ISTORE(ICOMBF),IDIMBF,INEXTD)
      IF (IDIRNM.LT.0) GO TO 100
      IF (IDIRNM.EQ.0) GO TO 7000
C -- BRANCH ON REQUIRED FUNCTION
C    ( THE LINK TO THE 'MODIFY' DIRECTIVE SHOULD ALWAYS BE LAST )
C
C-C-C-INTRODUCTION OF ADDITIONAL DIRECTIVE-ADDRESSES FOR "SPECIALS"
      GO TO (650, 4700, 500,3000,5500,5500,5500,5500,6500,3650,
     1       3800,1000,1050, 900,1100, 400,5100, 60, 200, 300,
     2        250, 600,2700,2850,2300,1150,6950,6300,6800,3950,
     3       5450,4100,4300,4500,2900,350,15500, 460,1160,2870,
     4       2300,6790, 150,8250), IDIRNM
      GO TO 8250
C
150   CONTINUE
C -- 'MODIFY' DIRECTIVE
C
C    THERE SHOULD ONLY BE ONE MODIFY DIRECTIVE, AMD IT WILL BE THE
C    FIRST ONE PROCESSED FOR EACH RUN OF THE ROUTINE.
C
C -- DETERMINE LIST NUMBERS
      IF (ISTORE(ICOMBF+IMDINP) .LE. 0) THEN
CDJWJAN2001 SET A LIST TYPE JUST IN CASE FIRST COMMAND IS AN ERROR
       LA = 5
       LB = 5
      ELSE
       LA=KTYP05(ISTORE(ICOMBF+IMDINP))
       LB=KTYP05(ISTORE(ICOMBF+IMDOUT))
      ENDIF
      IF ((LA.LE.0).OR.(LB.LE.0)) THEN
      WRITE(CMON,'(''No output list type given'')')
      CALL XPRVDU (NCVDU,1,0)
      GOTO 8200
      ENDIF
      IF (IERFLG.LT.0) GO TO 8200
C -- LOAD LISTS
      CALL XFAL01
      CALL XFAL02

C--- LOAD LIST 3, 29 AND 41 INCASE WE NEED THEM LATER
C RIC02 - Moved these calles to before XLDRO5, since all subsequent
C code assumes that L5 is loaded last and will happily write over
C anything above L5 in store. Previously this would have caused chain
C breaks if you added an atom, then tried to, say, INSERT ELECTRON.
C Now that XBCALC is called it was having the more serious effect
C of creating huge invalid L41s.
      KLST(1)=-1
      KLST(2)=-1
      KLST(3)=-1
      KLST(4)=-1
      KLST(5)=-1
      IF (KEXIST(3).GT.0) THEN
         IF (KHUNTR(3,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL03
         KLST(1)=1
      END IF
      IF (KEXIST(29).GT.0) THEN
         IF (KHUNTR(29,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL29
         KLST(2)=29
      END IF
      IF (KEXIST(41).GT.0) THEN
         IF (KHUNTR(41,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL41
         KLST(3)=41
         KLST(4)=41
         KLST(5)=41
      END IF
      IF (KEXIST(40).GT.0) THEN
         IF (KHUNTR(40,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL40
      ELSE
      INCLUDE 'IDIM40.INC'
         CALL XFILL(0,ICOM40(1),IDIM40)
         MD40T=1
         MD40E=1
         MD40P=1
         MD40M=1
         MD40B=1
      END IF

C----- LOAD LIST 20 IF NOT ALREADY IN CORE
      IF (KHUNTR(20,0,IADDL,IADDR,IADDD,-1).NE.0) CALL XFAL20
c-----LOAD LIST5/10
      CALL XLDRO5 (LA)
      IF (IERFLG.LT.0) GO TO 8200

C----- SEE LIPSON & COCHRAN, EQN 302.3
      STORE(NFL)=COS(STORE(L1P1+3))
      STORE(NFL+1)=COS(STORE(L1P1+4))
      STORE(NFL+2)=COS(STORE(L1P1+5))
      STORE(NFL+3)=1.+2.*(STORE(NFL)*STORE(NFL+1)*STORE(NFL+2))-
     1(STORE(NFL)*STORE(NFL)+STORE(NFL+1)*STORE(NFL+1)+STORE(NFL+2)*
     2STORE(NFL+2))
      STORE(NFL+3)=SQRT(STORE(NFL+3))
      DANISO(1)=STORE(NFL+3)*STORE(L1P1)/SIN(STORE(L1P1+3))
      DANISO(2)=STORE(NFL+3)*STORE(L1P1+1)/SIN(STORE(L1P1+4))
      DANISO(3)=STORE(NFL+3)*STORE(L1P1+2)/SIN(STORE(L1P1+5))
C
C -- SET CHANGE FLAG
      ICHNG=0
      IF (LA.NE.LB) ICHNG=1
C -- SET INITIAL ADDRESSES , FLAGS , AND COUNTS FOR 'MOVE' AND 'KEEP'
      IPSEQ=L5
      IKEEP=L5
      MKEEP=-1
      NKEEP=0
C -- SET INITIAL MONITOR LEVEL
      MONLVL=2
Cdjwmay99 if is't a small strucuture, reset gui monitor as hi
      IF (N5.LE.50) MONGUI=+1
      N5A=N5
      GO TO 100
C
C
200   CONTINUE
C -- 'SAVE' DIRECTIVE
C
C    SAVE THE CURRENT LIST
      CALL XMDWLS
C -- RESET LIST FLAGS
      ICHNG=0
      MKEEP=-1
      NKEEP=0
      GO TO 100
C
C
250   CONTINUE
C -- 'QUIT' DIRECTIVE
C
C    ABANDON EDITING WITHOUT CREATING NEW LIST
C -- NEXT DIRECTIVE SHOULD BE 'END'
      IF (INEXTD.NE.0) GO TO 7200
      IQUIT=1
      GO TO 100
C
C
300   CONTINUE
C -- 'MONITOR' DIRECTIVE
C
C    CHANGE MONITOR LEVEL
      MONLVL=ISTORE(ICOMBF+IMDAT2)
      GO TO 100
C
350   CONTINUE
C -- 'GUI' DIRECTIVE
C
C    CHANGE MONITOR LEVEL
      MONGUI=ISTORE(ICOMBF+IMDGUI)
      GO TO 100
C
C
400   CONTINUE
C -- 'LIST' DIRECTIVE
C
C    CHANGE LISTING LEVEL
      LSTLVL=ISTORE(ICOMBF+IMDAT1)
      CALL XMDMON (L5,MD5,N5,1,1,1,LSTLVL,1,1,1,ISTORE(IMONBF))
C -- INDICATE TO THE USER WHICH ATOMS WILL BE 'KEPT'
      IF (LSTLVL.GT.0) THEN
         IF (MKEEP.GT.0) THEN
            IADDR=L5+(NKEEP-1)*MD5
            IF (ISSPRT.EQ.0) WRITE (NCWU,450) NKEEP,STORE(IADDR),
     1       STORE(IADDR+1)
cfeb08            WRITE (NCAWU,450) NKEEP,STORE(IADDR),STORE(IADDR+1)
            WRITE (CMON,450) NKEEP,STORE(IADDR),STORE(IADDR+1)
            CALL XPRVDU (NCVDU,1,0)
450         FORMAT (1X,'The ',I5,' atoms up to ',A4,F5.0,' will be KEPT'
     1       )
         END IF
      END IF
      GO TO 100
C
C
460   CONTINUE
C -- 'GRAPH' DIRECTIVE
C
C     GET GRAPH TYPE LEVEL
      MGTYPE=ISTORE(ICOMBF+IGTYPE)

      WRITE(CMON,'(A,/,A,/,A)')
     1  '^^PL PLOTDATA _PARAM BARGRAPH ATTACH _VPARAM',
     1  '^^PL XAXIS TITLE ''Atoms''',
     1  '^^PL NSERIES=1 LENGTH=20'
      CALL XPRVDU(NCVDU, 3,0)

      DO IPR = L5, L5+((N5-1)*MD5), MD5
        CALL CATSTR(STORE(IPR),STORE(IPR+1),1,1,0,0,0,CATOM1,LATOM1)
        WRITE(CMON,'(A,A,A,F9.3)')
     1  '^^PL LABEL ''', CATOM1(1:LATOM1),''' DATA ', STORE(IPR+13)
        CALL XPRVDU(NCVDU, 1,0)
      END DO

      WRITE(CMON,'(A,/,A)') '^^PL SHOW','^^CR'
      CALL XPRVDU(NCVDU, 2,0)

      GO TO 100
C
C
500   CONTINUE
C -- 'READ' DIRECTIVE
C
C    THIS DIRECTIVE HAS BEEN SUPERSEDED BY 'ATOM' AND IS NO LONGER
C    SUPPORTED.
      IF (ISSPRT.EQ.0) WRITE (NCWU,550)
cfeb08      WRITE (NCAWU,550)
      WRITE (CMON,550)
      CALL XPRVDU (NCVDU,1,0)
550   FORMAT (1X,'The READ directive has been replaced by ATOM')
      CALL XERHND (IERWRN)
      GO TO 100
C
C
600   CONTINUE
C -- 'ATOM' DIRECTIVE
C
C    APPEND THE SPECIFIED ATOMIC PARAMETERS TO LIST 5
      I=KSTALL(MD5)
      IENDL5=L5+(MD5*N5)
      CALL XMOVE (STORE(ICOMBF+IMDATM),STORE(IENDL5),MD5)
      N5=N5+1
      CALL XUDRH (LB,IATREC,0,N5)
      ICHNG=ICHNG+1
      GO TO 100
C
C
650   CONTINUE
C -- 'DELETE' INSTRUCTION
C
C -- CHECK THERE IS SOME DATA
      IF (ME.LE.0) GO TO 7300
700   CONTINUE
C -- CHECK FOR MORE DATA. READ IT. CHECK NO PARAMETERS SPECIFIED.
      IF (KOP(8).LT.0) GO TO 100
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C
C -- UPDATE MODIFICATION FLAGS AND MONITOR ATOMS
      ICHNG=ICHNG+1
      CALL XMDMON (M5A,MD5A,N5A,1,1,2,1,MONLVL,2,0,ISTORE(IMONBF))
      JV=M5A+N5A*MD5A
      JW=L5+N5*MD5
C--CHECK IF THE ATOMS ARE AT THE BOTTOM OF THE STACK
      IF (JV-JW) 750,800,800
C--MOVE THE ATOMS AFTER THE DELETED ATOMS UP
750   CONTINUE
      CALL XMOVE (STORE(JV),STORE(M5A),JW-JV)
C--ADJUST THE NUMBER OF ATOMS IN THE LIST
800   CONTINUE
      N5=N5-N5A
      NPTCUR = -1 ! Avoid confusing the lexical scanner when changing
                  ! size of L5 in middle of loop.
C--CHECK IF WE HAVE DELETED 'KEPT' ATOMS
      L=(M5A-L5)/MD5A
      IF (L-NKEEP) 850,700,700
C--THE ATOMS DELETED HAVE BEEN 'KEPT'
850   CONTINUE
      NKEEP=MAX0(0,NKEEP-N5A)
      IKEEP=L5+NKEEP*MD5
      GO TO 700
C
C
900   CONTINUE
C -- 'AFTER' DIRECTIVE
C
C -- CHECK FOR DATA. READ ATOMS. CHECK ONLY ONE ATOM
      IF (ME.LE.0) GO TO 950
      IF (KATOMU(LN).LT.0) GO TO 7100
      IF (N5A.NE.1) GO TO 7900
C -- NEXT ATOM GOES AFTER THIS ONE
      IPSEQ=M5A+MD5A
      GO TO 100
950   CONTINUE
C -- BLANK CARD. THIS REPRESENTS 'AFTER BEGINNING OF LIST'
      IPSEQ=L5
      GO TO 100
C
C
1000  CONTINUE
C -- 'KEEP' DIRECTIVE
C
      MKEEP=1
      ISTAT=KMDMOV(IKEEP,1,8)
      IF (ISTAT.LT.0) GO TO 7100
      GO TO 100
C
C
1050  CONTINUE
C -- 'MOVE' DIRECTIVE
C
      ISTAT=KMDMOV(IPSEQ,0,9)
      IF (ISTAT.LT.0) GO TO 7100
      GO TO 100
C
C
1100  CONTINUE
C -- 'SELECT' DIRECTIVE
C
C----- SET SELECT/TYPECHANGE FLAG TO 'SELECT'
      ISTCF=-1
      GO TO 1200
C
C
1150  CONTINUE
C      'TYPECHANGE'     SET FLAG
      ISTCF=1
      GO TO 1200

1160  CONTINUE
C      'GUISELECT'     SET FLAG
      ISTCF=0
      GO TO 1200
C
1200  CONTINUE
C -- CHECK FOR SOME DATA
      IF (ME.LE.0) GO TO 7300
1250  CONTINUE
C -- READ ATOMIC OR OVERALL PARAMETER. CHECK ONLY ONE PARAMETER
      IF (KOP(8).LT.0) GO TO 100
      IF (KCORCH(LN).GT.0) GO TO 1300
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.1) GO TO 7600
1300  CONTINUE
C -- COMPUTE PARAMETER ADDRESS
      JU=ISTORE(MQ+6)+MQ
CDJW JAN2000 JVO IS THE EXTENDED PARAMETER NUMBER
      JVO=ISTORE(JU+1)
      JV = JVO -1
C--SEARCH FOR THE CONDITIONAL ARGUMENT
      JT=KFDOPD(1,NWCOND,ICOND,NCOND,LCOND)
C--CHECK FOR SUCCESS
      IF (JT.LE.0) GO TO 7100
C--CHECK THE PARAMETER NUMBER
      IF (JV) 1350,1350,1400
C--THIS IS 'TYPE'  -  ONLY FIRST CONDITIONALS MAY BE USED
1350  CONTINUE
      IF (JT.GE.3) GO TO 7700
C--CHECK FOR AN ALPHA-NUMBERIC ARGUMENT
      ISTAT=KFDOPD(-1,NWCOND,ICOND,NCOND,LCOND)
      IF (ISTAT.LE.0) GO TO 7100
C--ARGUMENT FOUND  -  MOVE IT ACROSS
      CALL XMOVE (STORE(MF+2),APD(1),1)
      MF=MF+LK2
      ME=ME-1
      GO TO 1450
C--NUMERIC ARGUMENT  -  READ THE NUMBER
1400  CONTINUE
CDJWJAN00 BEFORE WE READ THE NUMBER, FIDDLE WITH THE
C  PARAMETER OFF SET FOR EXTENDED KEYS
      IF (JVO .GE. NKAS) JV = JV - NKAO
      JT=JT+2
      IF (KFDNUM(APD(1)).LT.0) GO TO 7100
1450  CONTINUE
C----- CHECK FOR ATOM TYPE IF MODE IS TYPE CHANGE
      IF (ISTCF.EQ.1) THEN
         IF (ME.LE.0) GO TO 7500
         IF (ISTORE(MF).GT.0) GO TO 7500
         ITYPE=ISTORE(MF+2)
         ME=ME-1
         MF=MF+LK2
      END IF
C--CHECK IF THERE ARE ANY ATOMS
      IF (N5A) 1250,1250,1500
C--LOOP OVER EACH ATOM IN THE LIST
1500  CONTINUE
      DO 2200 JW=1,N5A
C--GENERATE THE MOVED PARAMETERS
         IF (KATOMS(MQ,M5A,ITEMP).LT.0) GO TO 7100
C--MOVE THE PARAMETERS BACK
         CALL XMOVE (STORE(ITEMP),STORE(M5A),MD5A)
C--SET THE PARAMETER ADDRESS
         JU=JV+M5A
C--BRANCH ON THE TYPE OF CONDITION
         GO TO (1550,1600,1650,1700,1750,1800,1850,1900,8250),JT
         GO TO 8250
C--ALPHA-NUMERIC 'EQUAL'
1550     CONTINUE
         IF (KCOMP(1,STORE(JU),APD(1),1,1)) 1950,1950,2150
C--ALPHA-NUMERIC 'NOT EQUAL'
1600     CONTINUE
         IF (KCOMP(1,STORE(JU),APD(1),1,1)) 2150,2150,1950
C--NUMERIC 'EQUAL'
1650     CONTINUE
         IF (ABS(STORE(JU)-APD(1))-ZERO) 2150,1950,1950
C--NUMERIC 'NOT EQUAL'
1700     CONTINUE
         IF (ABS(STORE(JU)-APD(1))-ZERO) 1950,2150,2150
C--'LESS THAN'
1750     CONTINUE
         IF (STORE(JU)-APD(1)) 2150,1950,1950
C--'LESS THAN OR EQUAL'
1800     CONTINUE
         IF (STORE(JU)-APD(1)) 2150,2150,1950
C--'GREATER THAN'
1850     CONTINUE
         IF (STORE(JU)-APD(1)) 1950,1950,2150
C--'GREATER THAN OR EQUAL'
1900     CONTINUE
         IF (STORE(JU)-APD(1)) 1950,2150,2150
C--ELIMINATE THE CURRENT ATOM
1950     CONTINUE
C----- CHECK IF TYPECHANGE
         IF (ISTCF.GE.0) THEN
C-----  NOTHING TO BE DONE - ACCEPT ATOM
            M5A=M5A+MD5A
            GO TO 2200
         END IF
         NEW=1
C--COMPUTE THE NUMBER OF ATOMS TO BE MOVED UP
         L=(M5A-L5)/MD5A
         N=N5-L-1
C--CHECK IF THERE ARE ANY ATOMS TO MOVE
         IF (N) 2050,2050,2000
C--MOVE THE ATOMS UP
2000     CONTINUE
         M=M5A+MD5A
         CALL XMOVE (STORE(M),STORE(M5A),N*MD5A)
C--DECREMENT THE NUMBER OF ATOMS
2050     CONTINUE
         N5=N5-1
C--CHECK IF WE HAVE ELIMINATED A 'KEPT' ATOM
         IF (L-NKEEP) 2100,2200,2200
C--ADJUST THE NUMBER OF 'KEPT' ATOMS
2100     CONTINUE
         NKEEP=MAX0(0,NKEEP-1)
         IKEEP=L5+NKEEP*MD5
         GO TO 2200
C--UPDATE FOR THE NEXT ATOM
2150     CONTINUE
C----- CHECK IF TYPECHANGE
         IF (ISTCF.EQ.1) THEN
C----- TYPE CHANGE
            CALL XMOVEI (ITYPE,ISTORE(M5A),1)
            CALL XMDMON (M5A,MD5A,1,1,1,4,1,MONLVL,2,0,ISTORE(IMONBF))
            ICHNG=ICHNG+1
         ELSE IF ( ISTCF .EQ. 0 ) THEN
            WRITE(CMON,'(A,A,I5,A)')'^^CO SET MODEL01 SELECT ''',
     1      ISTORE(M5A), NINT(STORE(M5A+1)), ''' YES'
            CALL XPRVDU(NCVDU,1,0)
            CALL XMDMON (M5A,MD5A,1,1,1,4,1,MONLVL,2,0,ISTORE(IMONBF))
         ELSE 
            CALL XMDMON (M5A,MD5A,1,1,1,10,1,MONLVL,2,0,ISTORE(IMONBF))
            ICHNG=ICHNG+1
         END IF
         M5A=M5A+MD5A
2200  CONTINUE
      GO TO 1250
C
C
C
2300  CONTINUE
C -- 'RENAME' DIRECTIVE
      IF (ME.LE.0) GO TO 7300
2350  CONTINUE
C -- READ ATOM SPEC. NO PARAMETERS PERMITTED
      II=KATOMH(MQ)
C--CHECK THAT AN ATOM HAS BEEN FOUND CORRECTLY
      IF (II) 2400,2450,2500
C--END OF CARD  -  BACKSPACE ONE ARGUMENT
2400  CONTINUE
      MF=MF-LK2
C--ERROR IN ATOM DEFINITION
2450  CONTINUE
      GO TO 7500
C--CHECK FOR THIS ATOM IN LIST 5
2500  CONTINUE
      M5A=L5
      N5A=N5
      L12A=0
      IF (KATOMF(STORE(MQ+2),M5A,N5A,MD5A,L12A)) 2550,2600,2550
C--ATOM NOT IN LIST 5
2550  CONTINUE
      II=MQ+2
      CALL XPCLNN (LN)
      CALL XMISL5 (1,ISTORE(MQ+1),II)
      GO TO 8000
2600  CONTINUE
C -- CHECK  NO PARAMETERS GIVEN
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C--GENERATE THE NEW ATOM IN WORKSPACE
      IF (KATOMS(MQ,M5A,ITEMP).LT.0) GO TO 7100
C----- SAVE ADDRESS IN LIST 5
      M5B=M5A
      MD5B=MD5A
C--PUT IT BACK IN THE LIST 5
      CALL XMOVE (STORE(ITEMP),STORE(M5A),MD5A)
C----- LOOK FOR NEW ATOM NAME - IT MUST NOT ALREADY EXIST
      II=KATOMH(MQ)
C--CHECK THAT AN ATOM HAS BEEN FOUND CORRECTLY
      IF (II) 2400,2450,2650
C--CHECK FOR THIS ATOM IN LIST 5
2650  CONTINUE
      M5A=L5
      N5A=N5
      L12A=0
      IF (KATOMF(STORE(MQ+2),M5A,N5A,MD5A,L12A).EQ.0) THEN
         IF (IDIRNM.LE.25) GO TO 8100   !'RENAME'
C Otherwise 'DRENAME' - push other serial out of the way:
         IHSER = 1
         DO K5 = L5,L5+(N5-1)*MD5,MD5
           IF ( ISTORE(K5) .EQ. ISTORE(M5A) ) THEN
             IHSER = MAX(IHSER,NINT(STORE(K5+1)))
           END IF
         END DO
         STORE(M5A+1) = IHSER+1.0
      END IF
C--ATOM NOT IN LIST 5
C----- MOVE OVER THE NEW NAME AND SERIAL
      CALL XMOVE (STORE(MQ+2),STORE(M5B),2)
      CALL XMDMON (M5B,MD5B,1,1,1,4,3,MONLVL,2,0,ISTORE(IMONBF))
      ICHNG=ICHNG+1
C--CHECK FOR MORE ATOMS
      IF (KOP(8).LT.0) GO TO 100
      GO TO 2350
C
C
2700  CONTINUE
C -- 'SORT' DIRECTIVE
C
      I=+1
      ISTAT=KMDSRT(I)
2750  CONTINUE
      IF (ISTAT.LT.0) GO TO 7100
C -- IF 'KEEP' HAS BEEN USED, RESET NOW
      IF (MKEEP.GT.0) THEN
         IF (ISSPRT.EQ.0) WRITE (NCWU,2800)
cfeb08         WRITE (NCAWU,2800)
         WRITE (CMON,2800)
         CALL XPRVDU (NCVDU,1,0)
2800     FORMAT (1X,'Previous KEEP instruction(s) cancelled')
         CALL XERHND (IERWRN)
         MKEEP=-1
         IKEEP=L5
         NKEEP=0
      END IF
      ICHNG=ICHNG+1
      CALL XMDMON (L5,MD5,N5,1,1,12,1,MONLVL,2,0,ISTORE(IMONBF))
      GO TO 100
C
C
2850  CONTINUE
C----- 'DSORT' - DECREASING VALUE SORT
C
      I=-1
      ISTAT=KMDSRT(I)
      GO TO 2750
C
C-C-C
2870  CONTINUE
C-C-C-'CLASH'-DIRECTIVE CLASHING SERIALS ARE RENAMED.
C     GET CLASH EXECUTION MODE
      MCLASH=ISTORE(ICOMBF+ICLASH)
C - 0, just report any clashes
C - 1, when clash, change serial of latter atom.
C - 2, when clash, change serial of former atom.

      K5F = L5
      K5L = L5 + (N5-1)*MD5
      K5S = MD5
      IF ( MCLASH .EQ. 2 ) THEN
        K5F = K5L
        K5L = L5
        K5S = -MD5
      END IF
C  Outer loop over all but last atom.
      DO K5A = K5F,K5L-K5S,K5S
C  Inner loop over atoms between current and last.
        DO K5B = K5A+K5S,K5L,K5S
          IF ( ( ISTORE(K5A)        .EQ. ISTORE(K5B)        ) .AND.
     1         ( NINT(STORE(K5A+1)) .EQ. NINT(STORE(K5B+1)) ) ) THEN
           CALL CATSTR(STORE(K5A),STORE(K5A+1),1,1,0,0,0,CATOM1,LATOM1)
           WRITE (CMON,'('' Clash detected, atom: '',A)')
     1     CATOM1(1:LATOM1)
           CALL XPRVDU (NCVDU,1,0)
           IF ( MCLASH .GT. 0 ) THEN
C  Fix clash. Find highest serial and add one.
             IHSER = 1
             DO K5C = K5F,K5L,K5S
              IF ( ISTORE(K5C) .EQ. ISTORE(K5A) ) THEN
               IHSER = MAX(IHSER,NINT(STORE(K5C+1)))
              END IF
             END DO
             STORE(K5B+1) = IHSER+1.0
             ICHNG = ICHNG + 1
           END IF
          END IF
        END DO
      END DO
      IERROR=IERNOP   ! This function should not cause a warning if no changes to L5.
      GO TO 100
C
C-C-C
2900  CONTINUE
C-C-C-'REFORMAT'-DIRECTIVE
C-C-C-(OLD VERSION LIST 5 IS TRANSFORMED INTO NEW VERSION LIST 5)
      N5A=N5
      M5A=L5
C-C-C-LOOP OVER ALL ATOMS OF LIST 5
      DO 2950 JU=1,N5A
C-C-C-CHECK FOR TYPE OF ATOM
         IF (STORE(M5A+3).GE.UISO) THEN
            STORE(M5A+7)=STORE(M5A+3)
            CALL XZEROF (STORE(M5A+8),5)
            STORE(M5A+3)=1.0
         END IF
C-C-C-NEXT ATOM IN LIST 5
         M5A=M5A+MD5A
2950  CONTINUE
C
C
3000  CONTINUE
C -- 'CHANGE' DIRECTIVE
C
      IF (ME.LE.0) GO TO 7300
3050  CONTINUE
C -- CHECK FOR MORE DATA
      IF (KOP(8).LT.0) GO TO 100
C -- CHECK FOR AN OVERALL PARAMETER
      ISCALE=KOVPCH(I)
      IF (ISCALE.LT.0) GO TO 7100
      IF (ISCALE.EQ.0) GO TO 3150
      L5A=M5A
C -- OVERALL PARAMETER FOUND. A NUMBER MUST BE READ NOW
      IF (ME.LE.0) GO TO 7500
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      DO 3100 I=1,N5A
         STORE(M5A)=Z
         M5A=M5A+1
3100  CONTINUE
      CALL XMDMON (L5A,1,N5A,ISTORE(MQ+2),ISCALE+1,4,3,MONLVL,2,0,
     1ISTORE(IMONBF))
C
      ICHNG=ICHNG+1
      GO TO 3050
3150  CONTINUE
C -- CHECK FOR A GLOBAL PARAMETER. LOOKS LIKE AN ATOM SPEC
      IF (KCORCH(I).GT.0) GO TO 3200
C -- READ ATOM SPEC. EITHER NO PARAMETER OR ONE PARAMETER PLUS VALUE
      IF (KATOMU(LN).LE.0) GO TO 7100
      MP=-1
C -- CHECK IF NO PARAMETERS
      IF (ISTORE(MQ+5).LE.0) GO TO 3400
C -- CHECK IF ONE PARAMETER
      IF (ISTORE(MQ+5).GT.1) GO TO 7600
C -- CHECK DATA FOLLOWS
3200  CONTINUE
      IF (ME.LE.0) GO TO 7500
      MP=1
      JU=ISTORE(MQ+6)+MQ
CDJW JAN2000 JVO IS THE EXTENDED PARAMETER NUMBER
      JVO=ISTORE(JU+1)
      JV = JVO-1
C--CHECK THE TYPE
cdjwjun02
c      write(ctemp,'(a,i9)')' jvo = ', jvo
c&&&GIDGILWXS      call zmore(ctemp,0)
c      IF (JV) 3250,3250,3300
      if ((jv .eq. 0) .or.(jv.eq.17)) then
C--ALPHA-NUMERIC VALUE EXPECTED
3250  CONTINUE
      IF (ISTORE(MF).GE.0) GO TO 7500
      CALL XMOVE (STORE(MF+2),APD(1),1)
      GO TO 3350
      endif
C--NUMBER EXPECTED
3300  CONTINUE
CDJWJAN00 BEFORE WE READ THE NUMBER, FIDDLE WITH THE
C  PARAMETER OFF SET FOR EXTENDED KEYS
      IF (JVO .GE. NKAS) JV = JV - NKAO
      IF (KSYNUM(APD(1)).NE.0) GO TO 7500
C--INCREMENT THE POINTERS
3350  CONTINUE
      ME=ME-1
      MF=MF+LK2
C--CHECK IF THERE ARE ANY ATOMS TO BE MOVED
3400  CONTINUE
      IF (N5A) 3050,3050,3450
C--PROCESS THE ATOMS
3450  CONTINUE
      DO 3600 JU=1,N5A
C--MOVE THE ATOM ITS NEW POSITION
         IF (KATOMS(MQ,M5A,ITEMP).LT.0) GO TO 7100
C--PUT IT BACK IN THE LIST
         CALL XMOVE (STORE(ITEMP),STORE(M5A),MD5A)
C--CHECK IF THERE IS A PARAMETER TO BE CHANGED
         IF (MP) 3550,3500,3500
C--COMPUTE THE PARAMETER ADDRESS
3500     CONTINUE
         JT=M5A+JV
C-C-C
C-C-C-CHECK WHETHER FLAG IS CHANGED
C-C-C
         IF (JV.EQ.3) THEN
C-C-C-DISTINCTION BETWEEN DIFFERENT TARGETS FOR FLAG
            IF (NINT(APD(1)).EQ.0) THEN
C-C-C
C-C-C-ATOM OR SPECIAL FIGURE SHALL BECOME ANISOTROPIC ATOM
C-C-C
C-C-C-SUMMARIZE THE ABSOLUTE VALUES OF 5 LAST U[IJ]
               SUMUIJ=ABS(STORE(M5A+8))+ABS(STORE(M5A+9))+ABS(STORE(M5A+
     1          10))+ABS(STORE(M5A+11))+ABS(STORE(M5A+12))
C-C-C-CHECK ATOM BEING NON-ANISO OR ANISO WITHOUT VALUES FOR U[IJ]
               IF ((STORE(JT).GE.UISO).OR.((STORE(JT).LT.UISO).AND.
     1          (SUMUIJ.LT.0.0005))) THEN
C-C-C-CHECK STARTING VALUE TO GET U[IJ] AND RESET IT POSSIBLY
C-C-C-TO STANDARD VALUE
                  IF (STORE(M5A+7).LT.UISO) THEN
                     STORE(M5A+7)=0.05
                  END IF
C-C-C-GET U[IJ] FROM U[ISO],"U[ISO]" OR STANDARD VALUE
                  STORE(M5A+8)=STORE(M5A+7)
                  STORE(M5A+9)=STORE(M5A+7)
                  STORE(M5A+10)=STORE(M5A+7)*STORE(L1C)
                  STORE(M5A+11)=STORE(M5A+7)*STORE(L1C+1)
                  STORE(M5A+12)=STORE(M5A+7)*STORE(L1C+2)
               END IF
            ELSE IF (NINT(APD(1)).EQ.1) THEN
C-C-C
C-C-C-ATOM OR SPECIAL FIGURE SHALL BECOME ISOTROPIC ATOM
C-C-C
C-C-C-CHECK WHETHER ATOM WAS ANISO UNTIL NOW
               IF (STORE(JT).LT.UISO) THEN
C-C-C-SET UP WORK SPACE
                  LTEMP=KSTALL(4)
C-C-C-FIND U[EQUIV]
                  CALL XPRAXI (1,1,LTEMP,M5A,MD5A,1,0,0,0)
                  STORE(M5A+7)=STORE(LTEMP)
C-C-C-RETURN WORKSPACE
                  CALL XSTRLL (LTEMP)
               END IF
C-C-C-CHECK U[ISO] AND RESET IT POSSIBLY TO STANDARD VALUE
               IF (STORE(M5A+7).LT.UISO) THEN
                  STORE(M5A+7)=0.05
               END IF
C-C-C-SET UNUSED U[IJ]'S TO ZERO
               CALL XZEROF (STORE(M5A+8),5)
            ELSE IF (NINT(APD(1)).EQ.2) THEN
C-C-C
C-C-C-ATOM OR SPECIAL FIGURE SHALL BECOME SPHERE
C-C-C
C-C-C-CHECK WHETHER ATOM WAS ANISO UNTIL NOW
               IF (STORE(JT).LT.UISO) THEN
C-C-C-SET UP WORK SPACE
                  LTEMP=KSTALL(4)
C-C-C-FIND U[EQUIV]
                  CALL XPRAXI (1,1,LTEMP,M5A,MD5A,1,0,0,0)
                  STORE(M5A+7)=STORE(LTEMP)
C-C-C-RETURN WORKSPACE
                  CALL XSTRLL (LTEMP)
               END IF
C-C-C-CHECK ATOM NOT BEING SPHERE OR BEING SPHERE WITHOUT SIZE-VALUE
               IF ((NINT(STORE(JT)).NE.2).OR.((NINT(STORE(JT)).EQ.2).
     1          AND.(STORE(M5A+8).LT.0.0005))) THEN
C-C-C-SET SPECIAL PARAMETER TO STANDARD VALUE
                  STORE(M5A+8)=1.0
               END IF
C-C-C-CHECK "U[ISO]" AND RESET IT POSSIBLY TO STANDARD VALUE
               IF (STORE(M5A+7).LT.UISO) THEN
                  STORE(M5A+7)=0.05
               END IF
C-C-C-SET UNUSED U[IJ]'S TO ZERO
               CALL XZEROF (STORE(M5A+9),4)
            ELSE IF (NINT(APD(1)).GE.3) THEN
C-C-C
C-C-C-ATOM OR SPECIAL FIGURE SHALL BECOME LINE OR RING
C-C-C
C-C-C-CHECK WHETHER ATOM WAS ANISO UNTIL NOW
               IF (STORE(JT).LT.UISO) THEN
C-C-C-SET UP WORK SPACE
                  LTEMP=KSTALL(4)
C-C-C-FIND U[EQUIV]
                  CALL XPRAXI (1,1,LTEMP,M5A,MD5A,1,0,0,0)
                  STORE(M5A+7)=STORE(LTEMP)
C-C-C-RETURN WORKSPACE
                  CALL XSTRLL (LTEMP)
               END IF
C-C-C-SUMMARIZE THE ABSOLUTE VALUES OF U[IJ] FOR SIZE, DECL., AZIM.
               SUMUIJ=ABS(STORE(M5A+8))+ABS(STORE(M5A+9))+ABS(STORE(M5A+
     1          10))
C-C-C-CHECK ATOM NOT BEING LINE/RING
C-C-C-OR BEING LINE/RING WITHOUT VALUES FOR SIZE, DECL., AZIM.
               IF ((NINT(STORE(JT)).NE.NINT(APD(1))).OR.((NINT(STORE(JT)
     1          ).EQ.NINT(APD(1))).AND.(SUMUIJ.LT.0.0005))) THEN
C-C-C-SET SPECIAL PARAMETERS TO STANDARD VALUES
                  STORE(M5A+8)=1.0
                  STORE(M5A+9)=0.45
                  STORE(M5A+10)=0.45
               END IF
C-C-C-CHECK "U[ISO]" AND RESET IT POSSIBLY TO STANDARD VALUE
               IF (STORE(M5A+7).LT.UISO) THEN
                  STORE(M5A+7)=0.05
               END IF
C-C-C-SET UNUSED U[IJ]'S TO ZERO
               CALL XZEROF (STORE(M5A+11),2)
            END IF
         END IF
C-C-C-APPLY CHANGE OF PARAMETER
         CALL XMOVE (APD(1),STORE(JT),1)
C Look out for PART, REFINE, RESIDUE - they are integers.
         IF ((JV .GE. 14) .AND. (JV .LE. 16)) ISTORE(JT) = NINT(APD(1))
C--UPDATE THE ATOM ADDRESS
3550     CONTINUE
         CALL XMDMON (M5A,MD5A,1,1,1,4,3,MONLVL,2,0,ISTORE(IMONBF))
         ICHNG=ICHNG+1
         M5A=M5A+MD5A
3600  CONTINUE
      GO TO 3050
C
C
3650  CONTINUE
C -- 'CREATE' DIRECTIVE
C
      IF (ME.LE.0) GO TO 7300
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
3700  CONTINUE
C -- READ ATOMS. CHECK NO COORDINATES. READ SERIAL NUMBER INCREMENT.
C    CHECK NO MORE DATA FOLLOWS
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C -- CREATE THE NEW ATOMS
      ICHNG=ICHNG+1
      M5=L5+(N5*MD5)
      M5B=M5
C -- ALLOCATE SPACE REQUIRED BY NEW ATOMS
      I=KSTALL(N5A*MD5)
      DO 3750 JU=1,N5A
         IF (KATOMS(MQ,M5A,M5).LT.0) GO TO 7100
         STORE(M5+1)=STORE(M5+1)+Z
C----- CONDITIONAL BECAUSE OF OLD (13 PARAM) LIST 5S
         IF (MD5.GE.14) STORE(M5+13)=0.0
         M5A=M5A+MD5A
         M5=M5+MD5
         N5=N5+1
3750  CONTINUE
      CALL XMDMON (M5B,MD5A,N5A,1,1,7,3,MONLVL,2,0,ISTORE(IMONBF))
C--CHECK FOR MORE ATOMS
      IF (KOP(8).LT.0) GO TO 100
      IF (KSYNUM(ZZ).EQ.0) THEN
         Z=ZZ
         ME=ME-1
         MF=MF+LK2
         J=KOP(8)
      END IF
      GO TO 3700
C
C
3800  CONTINUE
C -- 'SPLIT' DIRECTIVE
C
      IF (ME.LE.0) GO TO 7300
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      J=KOP(8)
3850  CONTINUE
C -- CHECK IF ANY ATOMS HAVE BEEN GIVEN
      IF (ME.LE.0) GO TO 7500
C -- READ ATOMS. CHECK NO COORDINATES. READ SERIAL NUMBER INCREMENT.
C    CHECK NO MORE DATA FOLLOWS
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C -- STORE TWO NEW HALF ATOMS ATOMS
      ICHNG=ICHNG+1
      M5=L5+(N5*MD5)
      M5B=M5
C -- ALLOCATE SPACE REQUIRED BY NEW ATOMS
      I=KSTALL(N5A*MD5*2)
C----- ALLOCATE WORKSPACE FOR XPRAXI
      NFLSAV=NFL
      NFL=NFL+25
      IBASE=NFLSAV
      JBASE=NFLSAV+4
      DO 3900 JU=1,N5A
         IF (KATOMS(MQ,M5A,M5).LT.0) GO TO 7100
C----- NEW ATOM AT STORE(M5)
C----- HALVE OCC
         STORE(M5+2)=0.5*STORE(M5+2)
C----- FIDDLE SERIAL
         STORE(M5+1)=STORE(M5+1)*Z
C----- COMPUTE SPLITTING
         IF (STORE(M5+3).LE.UISO) THEN
            CALL XPRAXI (1,1,IBASE,M5,MD5,1,-1,JBASE,0)
C----- UEQUIV * COMPONENTS OF LONG VECTOR
            DX=STORE(IBASE+3)*STORE(JBASE+9)
            DY=STORE(IBASE+3)*STORE(JBASE+10)
            DZ=STORE(IBASE+3)*STORE(JBASE+11)
C----- RESTORE TO ISO
            STORE(M5+3)=1.
C----- SET U[ISO] = MEDIAN AND CLEAR UIJ
            STORE(M5+7)=STORE(IBASE+2)
            CALL XZEROF (STORE(M5+8),5)
C----- CLEAR OUR SPARE
C----- CONDITIONAL BECAUSE OF OLD (13 PARAM) LIST 5S
         IF (MD5.GE.14) STORE(M5+13)=0.0
C---- MAKE COPY
         CALL XMOVE (STORE(M5),STORE(M5+MD5),MD5)
         STORE(M5+MD5+1)=STORE(M5+1)+1
C
C----- APPLY SPLITTING
            STORE(M5+4)=STORE(M5+4)+DX
            STORE(M5+4+MD5)=STORE(M5+4+MD5)-DX
            STORE(M5+5)=STORE(M5+5)+DY
            STORE(M5+5+MD5)=STORE(M5+5+MD5)-DY
            STORE(M5+6)=STORE(M5+6)+DZ
            STORE(M5+6+MD5)=STORE(M5+6+MD5)-DZ
         END IF
         M5A=M5A+MD5A
         M5=M5+2*MD5
         N5=N5+2
3900  CONTINUE
C----- RESTORE WORKSPACE
      NFL=NFLSAV
      CALL XMDMON (M5B,MD5A,N5A*2,1,1,7,3,MONLVL,2,0,ISTORE(IMONBF))
C--CHECK FOR MORE ATOMS
      IF (KOP(8).LT.0) GO TO 100
      IF (KSYNUM(ZZ).EQ.0) THEN
         Z=ZZ
         ME=ME-1
         MF=MF+LK2
         J=KOP(8)
      END IF
      GO TO 3850
C
C
3950  CONTINUE
C -- 'CENTROID' DIRECTIVE
C
      IF (ME.LE.0) GO TO 7300
C -- READ NEW SERIAL NUMBER.
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      J=KOP(8)
C    CHECK MORE DATA FOLLOWS
      IF (ME.LE.0) GO TO 7800
C -- STORE PSEUDO  ATOM
      ICHNG=ICHNG+1
      M5=L5+(N5*MD5)
      M5B=M5
C -- ALLOCATE SPACE REQUIRED BY PSEUDO ATOM
      I=KSTALL(N5A*MD5)
C----- ALLOCATE WORKSPACE
      NFLSAV=NFL
C----- ATOMIC COORDINATES (3 ITEMS)
      JBASE=NFLSAV
C----- WORKSPACE (9 ITEMS)
      IBASE=NFLSAV+3
      NFL=NFL+12
C----- INITIALISE
      CALL XINERT (0,STORE(JBASE),STORE(IBASE),DANISO)
4000  CONTINUE
C -- READ ATOMS. CHECK NO COORDINATES.
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
      DO 4050 JU=1,N5A
         IF (KATOMS(MQ,M5A,M5).LT.0) GO TO 7100
         CALL XMOVE (STORE(M5+4),STORE(JBASE),3)
         CALL XINERT (1,STORE(JBASE),STORE(IBASE),DANISO)
         M5A=M5A+MD5A
4050  CONTINUE
C----- CHECK FOR MORE ATOMS
      IF (KOP(8).GE.0) GO TO 4000
C----- EVALUATE
      CALL XINERT (2,STORE(JBASE),STORE(IBASE),DANISO)
      CALL XMOVE (STORE(IBASE),STORE(M5+4),9)
C----- NEW ATOM AT STORE(M5)
      ISTORE(M5)=QCENT
C----- FIDDLE SERIAL
      STORE(M5+1)=Z
C----- SET OCC
      STORE(M5+2)=1.0
C----- SET U[ISO] FLAG TO ANISO
      STORE(M5+3)=0.0
C----- CONDITIONAL BECAUSE OF OLD (13 PARAM) LIST 5S
      IF (MD5.GE.14) STORE(M5+13)=0.0
      M5=M5+MD5
      N5=N5+1
C----- RESTORE WORKSPACE
      NFL=NFLSAV
      CALL XMDMON (M5B,MD5A,1,1,1,7,3,MONLVL,2,0,ISTORE(IMONBF))
      GO TO 100
C
C
C-C-C
C-C-C-3 DIRECTIVES TO CREATE SPECIAL FIGURES AUTOMATICALLY
C-C-C-(DERIVED FROM CENTROID-DIRECTIVE)
C-C-C
4100  CONTINUE
C-C-C
C-C-C-'SPHERE' DIRECTIVE
C-C-C
      IF (ME.LE.0) GO TO 7300
C-C-C-READ NEW SERIAL NUMBER.
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      J=KOP(8)
C-C-C-CHECK MORE DATA FOLLOWS
      IF (ME.LE.0) GO TO 7800
C-C-C-STORE PSEUDO  ATOM
      ICHNG=ICHNG+1
      M5=L5+(N5*MD5)
      M5B=M5
C-C-C-ALLOCATE SPACE REQUIRED BY PSEUDO ATOM
      I=KSTALL(N5A*MD5)
C-C-C-ALLOCATE WORKSPACE
      NFLSAV=NFL
C-C-C-ATOMIC COORDINATES (3 ITEMS)
      JBASE=NFLSAV
C-C-C-WORKSPACE (9 ITEMS)
      IBASE=NFLSAV+3
      NFL=NFL+12
C-C-C-INITIALISE CALCULATION OF CENTER (OF SPHERE)
      CALL XINERT (0,STORE(JBASE),STORE(IBASE),DANISO)
C-C-C-SET VARIABLES FOR AUTOM. CREATION OF SPECIALS TO INITIAL VALUE
      SUMOCC=0.0
      SUMUISO=0.0
      SIDI=0.0
      SUMDI=0.0
      NUMDISO=0.0
      NFLSPEC=NFL
4150  CONTINUE
C-C-C-READ ATOMS. CHECK NO COORDINATES.
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C-C-C-CREATE WORKSPACE TO STORE SYMMETRY TREATED DISORDERED ATOMS
      JU=KSTALL(N5A*3)
      DO 4200 JU=1,N5A
         IF (KATOMS(MQ,M5A,M5).LT.0) GO TO 7100
C-C-C-CALCULATE SUM OF OCCUPATION FACTORS
         SUMOCC=SUMOCC+STORE(M5A+2)
C-C-C-CALCULATE MEAN UEQUIV
         IF (STORE(M5A+3).LT.UISO) THEN
C-C-C-CREATE WORKSPACE, CALC. UEQUIV, SUM UP, RETURN WORKSPACE
            LTEMP=KSTALL(4)
            CALL XPRAXI (1,1,LTEMP,M5A,MD5A,1,0,0,0)
            SUMUISO=SUMUISO+STORE(LTEMP)
            CALL XSTRLL (LTEMP)
         ELSE
C-C-C-TAKE UEQUIV FROM U[11]
            SUMUISO=SUMUISO+STORE(M5A+7)
         END IF
C-C-C-STORE POSITIONS OF DISORDERED ATOM (SYMMETRY TREATED)
C-C-C-IN RESERVED WORKSPACE
         STORE(NFLSPEC+NUMDISO*3)=STORE(M5+4)
         STORE(NFLSPEC+1+NUMDISO*3)=STORE(M5+5)
         STORE(NFLSPEC+2+NUMDISO*3)=STORE(M5+6)
         NUMDISO=NUMDISO+1
         CALL XMOVE (STORE(M5+4),STORE(JBASE),3)
         CALL XINERT (1,STORE(JBASE),STORE(IBASE),DANISO)
         M5A=M5A+MD5A
4200  CONTINUE
C-C-C-CHECK FOR MORE ATOMS
      IF (KOP(8).GE.0) GO TO 4150
C-C-C-EVALUATE (CENTROID CALCULATION)
      CALL XINERT (2,STORE(JBASE),STORE(IBASE),DANISO)
      CALL XMOVE (STORE(IBASE),STORE(M5+4),9)
C-C-C-NEW ATOM AT STORE(M5)
C-C-C-ATOM TYPE (SPHERE)
      ISTORE(M5)=QSPHERE
C-C-C-FIDDLE SERIAL
      STORE(M5+1)=Z
C-C-C-SET OCC
      STORE(M5+2)=SUMOCC
C-C-C-SET FLAG TO SPHERE
      STORE(M5+3)=2.0
C-C-C-SET U[11] TO "U[ISO]",I.E. THE MEAN U[ISO] OF DISORDERED ATOMS
      STORE(M5+7)=SUMUISO/NUMDISO
C-C-C-CALCULATE RADIUS OF SPHERE
      DO 4250 JU=0,NUMDISO-1
C-C-C-CALCULATE DISTANCE OF CENTER TO EVERY DISORDERED ATOM
C-C-C-AND SUM THEM UP
         SIDI=SQRT(XDSTN2(STORE(NFLSPEC+JU*3),STORE(M5+4)))
         SUMDI=SUMDI+SIDI
4250  CONTINUE
C-C-C-STORE VALUE FOR SIZE (SPHERE-RADIUS): MEAN DISTANCE TO CENTER
      STORE(M5+8)=SUMDI/NUMDISO
C-C-C-SET REMAINING (NOT USED) U[IJ] TO 0.0
      STORE(M5+9)=0.0
      STORE(M5+10)=0.0
      STORE(M5+11)=0.0
      STORE(M5+12)=0.0
C-C-C-RETURN WORKSPACE
      CALL XSTRLL (NFLSPEC)
C-C-C-CONDITIONAL BECAUSE OF OLD (13 PARAM) LIST 5S
      IF (MD5.GE.14) STORE(M5+13)=0.0
      M5=M5+MD5
      N5=N5+1
C-C-C-RESTORE WORKSPACE
      NFL=NFLSAV
      CALL XMDMON (M5B,MD5A,1,1,1,7,3,MONLVL,2,0,ISTORE(IMONBF))
      GO TO 100
C-C-C
C-C-C
4300  CONTINUE
C-C-C
C-C-C-'LINE' DIRECTIVE
C-C-C
      IF (ME.LE.0) GO TO 7300
C-C-C-READ NEW SERIAL NUMBER.
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      J=KOP(8)
C-C-C-CHECK MORE DATA FOLLOWS
      IF (ME.LE.0) GO TO 7800
C-C-C-STORE PSEUDO  ATOM
      ICHNG=ICHNG+1
      M5=L5+(N5*MD5)
      M5B=M5
C-C-C-ALLOCATE SPACE REQUIRED BY PSEUDO ATOM
      I=KSTALL(N5A*MD5)
C-C-C-ALLOCATE WORKSPACE
      NFLSAV=NFL
C-C-C-ATOMIC COORDINATES (3 ITEMS)
      JBASE=NFLSAV
C-C-C-WORKSPACE (9 ITEMS)
      IBASE=NFLSAV+3
      NFL=NFL+12
C-C-C-INITIALISE CALCULATION OF CENTER (OF LINE)
      CALL XINERT (0,STORE(JBASE),STORE(IBASE),DANISO)
C-C-C-SET VARIABLES FOR AUTOM. CREATION OF SPECIALS TO INITIAL VALUE
      SUMOCC=0.0
      SUMUISO=0.0
      MAXDI=0.0
      NUMDISO=0.0
      NFLSPEC=NFL
4350  CONTINUE
C-C-C-READ ATOMS. CHECK NO COORDINATES.
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C-C-C-CREATE WORKSPACE TO STORE SYMMETRY TREATED DISORDERED ATOMS
      JU=KSTALL(N5A*4)
      DO 4400 JU=1,N5A
         IF (KATOMS(MQ,M5A,M5).LT.0) GO TO 7100
C-C-C-CALCULATE SUM OF OCCUPATION FACTORS
         SUMOCC=SUMOCC+STORE(M5A+2)
C-C-C-CALCULATE MEAN UEQUIV
         IF (STORE(M5A+3).LT.UISO) THEN
C-C-C-CREATE WORKSPACE, CALC. UEQUIV, SUM UP, RETURN WORKSPACE
            LTEMP=KSTALL(4)
            CALL XPRAXI (1,1,LTEMP,M5A,MD5A,1,0,0,0)
            SUMUISO=SUMUISO+STORE(LTEMP)
            CALL XSTRLL (LTEMP)
         ELSE
C-C-C-TAKE UEQUIV FROM U[11]
            SUMUISO=SUMUISO+STORE(M5A+7)
         END IF
C-C-C-STORE POSITIONS OF DISORDERED ATOM (SYMMETRY TREATED)
C-C-C-IN RESERVED WORKSPACE
         STORE(NFLSPEC+NUMDISO*4)=STORE(M5+4)
         STORE(NFLSPEC+1+NUMDISO*4)=STORE(M5+5)
         STORE(NFLSPEC+2+NUMDISO*4)=STORE(M5+6)
C-C-C-WEIGHTING (PROVISIONALLY 1.0)
         STORE(NFLSPEC+3+NUMDISO*4)=1.0
         NUMDISO=NUMDISO+1
C-C-C-SUM UP FOR CENTROID CALCULATION
         CALL XMOVE (STORE(M5+4),STORE(JBASE),3)
         CALL XINERT (1,STORE(JBASE),STORE(IBASE),DANISO)
         M5A=M5A+MD5A
4400  CONTINUE
C-C-C-CHECK FOR MORE ATOMS
      IF (KOP(8).GE.0) GO TO 4350
C-C-C-EVALUATE (CENTROID CALCULATION)
      CALL XINERT (2,STORE(JBASE),STORE(IBASE),DANISO)
      CALL XMOVE (STORE(IBASE),STORE(M5+4),9)
C-C-C-NEW ATOM AT STORE(M5)
C-C-C-ATOM TYPE (LINE)
      ISTORE(M5)=QLINE
C-C-C-FIDDLE SERIAL
      STORE(M5+1)=Z
C-C-C-SET OCC
      STORE(M5+2)=SUMOCC
C-C-C-SET FLAG TO LINE
      STORE(M5+3)=3.0
C-C-C-SET U[11] TO "U[ISO]",I.E. THE MEAN U[ISO] OF DISORDERED ATOMS
      STORE(M5+7)=SUMUISO/NUMDISO
C-C-C-CALCULATE LENGTH OF LINE
      DO 4450 JU=0,NUMDISO-1
C-C-C-CALCULATE DISTANCE OF CENTER TO EVERY DISORDERED ATOM
C-C-C-AND FIND THE MAXIMUM
         SIDI=SQRT(XDSTN2(STORE(NFLSPEC+JU*4),STORE(M5+4)))
         MAXDI=MAX(MAXDI,SIDI)
4450  CONTINUE
C-C-C-STORE VALUE FOR SIZE (LINE-LENGTH):
C-C-C-TWICE THE MAXIMAL DISTANCE TO CENTER
      STORE(M5+8)=2*MAXDI
C-C-C-CALCULATE LINE ORIENTATION (---> ORIENTATION-VECTOR IN ROF)
      CALL KMOLAX (STORE(NFLSPEC),NUMDISO,4,XCF,VA,ROF,RCA,XWORKS)
C-C-C-CALCULATION OF POLAR COORDINATES OF ORIENTATION VECTOR
C-C-C-FOR LINE USE OF ROF(1,X)
C-C-C-DECLINAT
      IF (ROF(1,1).GE.0.0) THEN
         STORE(M5+9)=(ACOS(ROF(1,3)))*3.6/TWOPI
      ELSE
         STORE(M5+9)=(-ACOS(ROF(1,3)))*3.6/TWOPI
      END IF
C-C-C-AZIMUTH
      IF (ABS(ROF(1,1)).LT.ZEROSQ) THEN
         IF (ROF(1,2).GE.0.0) THEN
            STORE(M5+10)=0.9
         ELSE
            STORE(M5+10)=-0.9
         END IF
      ELSE
         STORE(M5+10)=(ATAN(ROF(1,2)/ROF(1,1)))*3.6/TWOPI
      END IF
C-C-C-SET REMAINING (NOT USED) U[IJ] TO 0.0
      STORE(M5+11)=0.0
      STORE(M5+12)=0.0
C-C-C-RETURN WORKSPACE
      CALL XSTRLL (NFLSPEC)
C-C-C-CONDITIONAL BECAUSE OF OLD (13 PARAM) LIST 5S
      IF (MD5.GE.14) STORE(M5+13)=0.0
      M5=M5+MD5
      N5=N5+1
C-C-C-RESTORE WORKSPACE
      NFL=NFLSAV
      CALL XMDMON (M5B,MD5A,1,1,1,7,3,MONLVL,2,0,ISTORE(IMONBF))
      GO TO 100
C-C-C
C-C-C
4500  CONTINUE
C-C-C
C-C-C-'RING' DIRECTIVE
C-C-C
      IF (ME.LE.0) GO TO 7300
C-C-C-READ NEW SERIAL NUMBER.
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      J=KOP(8)
C-C-C-CHECK MORE DATA FOLLOWS
      IF (ME.LE.0) GO TO 7800
C-C-C-STORE PSEUDO  ATOM
      ICHNG=ICHNG+1
      M5=L5+(N5*MD5)
      M5B=M5
C-C-C-ALLOCATE SPACE REQUIRED BY PSEUDO ATOM
      I=KSTALL(N5A*MD5)
C-C-C-ALLOCATE WORKSPACE
      NFLSAV=NFL
C-C-C-ATOMIC COORDINATES (3 ITEMS)
      JBASE=NFLSAV
C-C-C-WORKSPACE (9 ITEMS)
      IBASE=NFLSAV+3
      NFL=NFL+12
C-C-C-INITIALISE CALCULATION OF CENTER (OF RING)
      CALL XINERT (0,STORE(JBASE),STORE(IBASE),DANISO)
C-C-C-SET VARIABLES FOR AUTOM. CREATION OF SPECIALS TO INITIAL VALUE
      SUMOCC=0.0
      SUMUISO=0.0
      SIDI=0.0
      SUMDI=0.0
      NUMDISO=0.0
      NFLSPEC=NFL
4550  CONTINUE
C-C-C-READ ATOMS. CHECK NO COORDINATES.
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C-C-C-CREATE WORKSPACE TO STORE SYMMETRY TREATED DISORDERED ATOMS
      JU=KSTALL(N5A*4)
      DO 4600 JU=1,N5A
         IF (KATOMS(MQ,M5A,M5).LT.0) GO TO 7100
C-C-C-CALCULATE SUM OF OCCUPATION FACTORS
         SUMOCC=SUMOCC+STORE(M5A+2)
C-C-C-CALCULATE MEAN UEQUIV
         IF (STORE(M5A+3).LT.UISO) THEN
C-C-C-CREATE WORKSPACE, CALC. UEQUIV, SUM UP, RETURN WORKSPACE
            LTEMP=KSTALL(4)
            CALL XPRAXI (1,1,LTEMP,M5A,MD5A,1,0,0,0)
            SUMUISO=SUMUISO+STORE(LTEMP)
            CALL XSTRLL (LTEMP)
         ELSE
C-C-C-TAKE UEQUIV FROM U[11]
            SUMUISO=SUMUISO+STORE(M5A+7)
         END IF
C-C-C-STORE POSITIONS OF DISORDERED ATOM (SYMMETRY TREATED)
C-C-C-IN RESERVED WORKSPACE
         STORE(NFLSPEC+NUMDISO*4)=STORE(M5+4)
         STORE(NFLSPEC+1+NUMDISO*4)=STORE(M5+5)
         STORE(NFLSPEC+2+NUMDISO*4)=STORE(M5+6)
C-C-C-WEIGHTING (PROVISIONALLY 1.0)
         STORE(NFLSPEC+3+NUMDISO*4)=1.0
         NUMDISO=NUMDISO+1
C-C-C-SUM UP FOR CENTROID CALCULATION
         CALL XMOVE (STORE(M5+4),STORE(JBASE),3)
         CALL XINERT (1,STORE(JBASE),STORE(IBASE),DANISO)
         M5A=M5A+MD5A
4600  CONTINUE
C-C-C-CHECK FOR MORE ATOMS
      IF (KOP(8).GE.0) GO TO 4550
C-C-C-EVALUATE (CENTROID CALCULATION)
      CALL XINERT (2,STORE(JBASE),STORE(IBASE),DANISO)
      CALL XMOVE (STORE(IBASE),STORE(M5+4),9)
C-C-C-NEW ATOM AT STORE(M5)
C-C-C-ATOM TYPE (RING)
      ISTORE(M5)=QRING
C-C-C-FIDDLE SERIAL
      STORE(M5+1)=Z
C-C-C-SET OCC
      STORE(M5+2)=SUMOCC
C-C-C-SET FLAG TO RING
      STORE(M5+3)=4.0
C-C-C-SET U[11] TO "U[ISO]",I.E. THE MEAN U[ISO] OF DISORDERED ATOMS
      STORE(M5+7)=SUMUISO/NUMDISO
C-C-C-CALCULATE RADIUS OF RING
      DO 4650 JU=0,NUMDISO-1
C-C-C-CALCULATE DISTANCE OF CENTER TO EVERY DISORDERED ATOM
C-C-C-AND SUM THEM UP
         SIDI=SQRT(XDSTN2(STORE(NFLSPEC+JU*4),STORE(M5+4)))
         SUMDI=SUMDI+SIDI
4650  CONTINUE
C-C-C-STORE VALUE FOR SIZE (RING-RADIUS): MEAN DISTANCE TO CENTER
      STORE(M5+8)=SUMDI/NUMDISO
C-C-C-CALCULATE RING (---> ORIENTATION-VECTOR IN ROF)
      CALL KMOLAX (STORE(NFLSPEC),NUMDISO,4,XCF,VA,ROF,RCA,XWORKS)
C-C-C-CALCULATION OF POLAR COORDINATES OF ORIENTATION VECTOR
C-C-C-FOR RING USE OF ROF(3,X)
C-C-C-DECLINAT
      IF (ROF(3,1).GE.0.0) THEN
         STORE(M5+9)=(ACOS(ROF(3,3)))*3.6/TWOPI
      ELSE
         STORE(M5+9)=(-ACOS(ROF(3,3)))*3.6/TWOPI
      END IF
C-C-C-AZIMUTH
      IF (ABS(ROF(3,1)).LT.ZEROSQ) THEN
         IF (ROF(3,2).GE.0.0) THEN
            STORE(M5+10)=0.9
         ELSE
            STORE(M5+10)=-0.9
         END IF
      ELSE
         STORE(M5+10)=(ATAN(ROF(3,2)/ROF(3,1)))*3.6/TWOPI
      END IF
C-C-C-SET REMAINING (NOT USED) U[IJ] TO 0.0
      STORE(M5+11)=0.0
      STORE(M5+12)=0.0
C-C-C-RETURN WORKSPACE
      CALL XSTRLL (NFLSPEC)
C-C-C-CONDITIONAL BECAUSE OF OLD (13 PARAM) LIST 5S
      IF (MD5.GE.14) STORE(M5+13)=0.0
      M5=M5+MD5
      N5=N5+1
C-C-C-RESTORE WORKSPACE
      NFL=NFLSAV
      CALL XMDMON (M5B,MD5A,1,1,1,7,3,MONLVL,2,0,ISTORE(IMONBF))
      GO TO 100
C-C-C
C
4700  CONTINUE
C--'ANISO' INSTRUCTION
C
      N5A=N5
      M5A=L5
C--CHECK TO SEE IF THE CARD IS BLANK  -  ALL THE ATOMS TO BE CHANGED
      IF (ME) 4850,4850,4800
C--CHECK IF THERE ARE ANY MORE ARGUMENTS
4750  CONTINUE
C -- CHECK FOR MORE DATA. READ ATOMS. CHECK NO PARAMETERS SPECIFIED
      IF (KOP(8).LT.0) GO TO 100
4800  CONTINUE
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
4850  CONTINUE
      CALL XMDMON (M5A,MD5A,N5A,1,1,3,1,MONLVL,2,0,ISTORE(IMONBF))
      ICHNG=ICHNG+1
C -- LOOP FOR CHANGING THE ATOMS
      DO 5050 JT=1,N5A
C--CHECK TO SEE IF THE ATOM IS ALREADY ANISO
         IF (ABS(STORE(M5A+3))-UISO) 5000,4900,4900
C--NOT ALREADY ANISO
4900     CONTINUE
         JV=M5A+2
         JW=L1C
         DO 4950 JU=M5A,JV
C      STORE(JU+7)=STORE(M5A+3)
C      STORE(JU+10)=STORE(M5A+3)*STORE(JW)
            STORE(JU+7)=STORE(M5A+7)
            STORE(JU+10)=STORE(M5A+7)*STORE(JW)
            JW=JW+1
4950     CONTINUE
         STORE(M5A+3)=0.0
5000     CONTINUE
         M5A=M5A+MD5A
5050  CONTINUE
      GO TO 4750
C
C
5100  CONTINUE
C -- 'UEQUIV' DIRECTIVE
C
C -- SET UP WORK SPACE
      LTEMP=KSTALL(4*N5)
      N5A=N5
      M5A=L5
C--CHECK TO SEE IF THE CARD IS BLANK  -  ALL THE ATOMS TO BE CHANGED
      IF (ME.LE.0) GO TO 5250
5150  CONTINUE
C -- CHECK FOR MORE ARGUMENTS
      IF (KOP(8).GE.0) GO TO 5200
C -- RETURN WORKSPACE
      CALL XSTRLL (LTEMP)
      GO TO 100
C--READ THE NEXT ATOM OR ATOMS
5200  CONTINUE
      IF (KATOMU(LN).LE.0) GO TO 7100
C--CHECK THAT NO COORDINATES HAVE BEEN GIVEN
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C--LOOP FOR CHANGING THE ATOMS
5250  CONTINUE
C--- FIND U[EQUIV]
      L5A=M5A
      M5B=M5A
      CALL XPRAXI (1,1,LTEMP,L5A,MD5A,N5A,0,0,0)
      JU=LTEMP
      DO 5400 JT=1,N5A
C--CHECK TO SEE IF THE ATOM IS ALREADY ISO
         IF (ABS(STORE(M5A+3))-UISO) 5300,5350,5350
C--NOT ALREADY ISO
5300     CONTINUE
C      STORE(M5A+3)=STORE(JU)
         STORE(M5A+7)=STORE(JU)
         STORE(M5A+3)=1.0
C----- ZERO THE ANISO TFS
C      CALL XZEROF (STORE(M5A+7), 6)
         CALL XZEROF (STORE(M5A+8),5)
5350     CONTINUE
         M5A=M5A+MD5A
         JU=JU+4
5400  CONTINUE
      CALL XMDMON (M5B,MD5A,N5A,1,1,11,1,MONLVL,2,0,ISTORE(IMONBF))
      ICHNG=ICHNG+1
      GO TO 5150
C
C
5450  CONTINUE
C----- PERTURB INSTRUCTION
C      FIDDLE THE DIRECTIVE NUMBER
      IDIRNM=5
      PERTOT=0.0
      PERTSQ=0.0
      NPERT=0
      GO TO 5550
C
C
5500  CONTINUE
C -- 'ADD' , 'SUBTRACT' , 'MULTIPLY' , OR 'DIVIDE' DIRECTIVE
C
      IDIRNM=IDIRNM-4
5550  CONTINUE
      IF (ME.LE.0) GO TO 7300
C -- CHECK FOR AN ARGUMENT AND READ NUMBER
      IF (ME.LE.0) GO TO 7500
      IF (KSYNUM(Z).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      J=KOP(8)
C----- BRANCH ON FUNCTION
      GO TO (5750,5600,5750,5650,5700,8250),IDIRNM
      GO TO 8250
5600  CONTINUE
C----- SUBTRACT
      Z=-Z
      GO TO 5750
5650  CONTINUE
C----- DIVIDE
      Z=1./Z
      GO TO 5750
5700  CONTINUE
C     RANDOM PERTURBATION - SAVE REQUESTED VARIANCE
      ZZ=Z*Z
      GO TO 5750
C
C----- START THE WORK
5750  CONTINUE
5800  CONTINUE
C -- CHECK FOR MORE DATA. CHECK FOR OVERALL PARAMETER. CHECK FOR
C    ATOMIC PARAMETER
      IF (KOP(8).LT.0) GO TO 100
      ISCALE=KOVPCH(I)
      IF (ISCALE.LT.0) THEN
C -- ERROR IN SPECIFICATION
         GO TO 7100
      ELSE IF (ISCALE.EQ.0) THEN
C -- ASSUME ATOMIC PARAMETER
         IPOSIT=1
         IPARTP=1
      ELSE IF (ISCALE.GT.0) THEN
C -- AN OVERALL PARAMETER
         IPOSIT=ISTORE(MQ+2)
         IPARTP=ISCALE+1
         JV=0
         MD5A=1
         GO TO 5900
      END IF
      IF (KCORCH(I).GT.0) GO TO 5850
      IF (KATOMU(LN).LE.0) GO TO 7100
C -- CHECK ONLY ONE ATOMIC PARAMETER
      IF (ISTORE(MQ+5).NE.1) GO TO 7600
5850  CONTINUE
C -- CHECK TYPE OF PARAMETER
      JU=ISTORE(MQ+6)+MQ
CDJW JAN2000 JVO IS THE EXTENDED PARAMETER NUMBER
      JVO=ISTORE(JU+1)
      JV = JVO-1
CDJWJAN00 LOOK FOR EXTENDED PARAMETERS
      IF (JV.LE.0) GO TO 7700
      IF (JVO .GE. NKAS) JV = JV - NKAO
5900  CONTINUE
C--CHECK IF THERE ARE ANY ATOMS TO PROCESS
      IF (N5A) 5800,5800,5950
C--LOOP OVER THE ATOMS
5950  CONTINUE
      DO 6200 JW=1,N5A
C -- APPLY SYMMETRY TO ATOMIC COORDINATES
         IF (IPARTP.EQ.1) THEN
            IF (KATOMS(MQ,M5A,ITEMP).LT.0) GO TO 7100
            CALL XMOVE (STORE(ITEMP),STORE(M5A),MD5A)
         END IF
         JU=M5A+JV
         GO TO (6000,6000,6050,6050,6100,8250),IDIRNM
         GO TO 8250
C--'ADD' OR 'SUBTRACT'
6000     CONTINUE
cdjwfeb04 to enable maths on the integer fields
         IF (((JV .EQ. 14) .OR. (JV .EQ. 15)) .OR. (JV .EQ. 16)) THEN
           ISTORE(JU)=ISTORE(JU)+NINT(Z)
         ELSE
           STORE(JU)=STORE(JU)+Z
         ENDIF
         GO TO 6150
C--'MULTIPLY' OR 'DIVIDE'
6050     CONTINUE
cdjwfeb04 to enable maths on the integer fields
         IF (((JV .EQ. 14) .OR. (JV .EQ. 15)) .OR. (JV .EQ. 16)) THEN
           ISTORE(JU)=ISTORE(JU)*NINT(Z)
         ELSE
           STORE(JU)=STORE(JU)*Z
         ENDIF
         GO TO 6150
6100     CONTINUE
C----- PERTURB
         Z=XRAND(ZZ,0) ! Use same sequence or tests break.
         PERTSQ=PERTSQ+ABS(Z)
C----- CONVER TO ESD
         Z=SIGN(1.,Z)*SQRT(ABS(Z))
         NPERT=NPERT+1
         PERTOT=PERTOT+Z
         IF (ISCALE.EQ.0) THEN
C----- ATOM PARAMETERS - CONVERT UNITS
            IF (JV.EQ.4) THEN
C----- X
               Z=Z/STORE(L1P1)
            ELSE IF (JV.EQ.5) THEN
C----- Y
               Z=Z/STORE(L1P1+1)
            ELSE IF (JV.EQ.6) THEN
C----- Z
               Z=Z/STORE(L1P1+2)
            END IF
         END IF
         STORE(JU)=STORE(JU)+Z
         GO TO 6150
6150     CONTINUE
         CALL XMDMON (M5A,MD5A,1,IPOSIT,IPARTP,5,3,MONLVL,2,0,
     1    ISTORE(IMONBF))
         IPOSIT=IPOSIT+1
         ICHNG=ICHNG+1
         M5A=M5A+MD5A
6200  CONTINUE
      IF (IDIRNM.EQ.5) THEN
cfeb08         WRITE (NCAWU,6250) NPERT,SQRT(ZZ),PERTOT/FLOAT(NPERT),
cfeb08     1    SQRT(PERTSQ/FLOAT(NPERT))
         IF (ISSPRT.EQ.0) WRITE (NCWU,6250) NPERT,SQRT(ZZ),PERTOT/
     1    FLOAT(NPERT),SQRT(PERTSQ/FLOAT(NPERT))
         WRITE (CMON,6250) NPERT,SQRT(ZZ),PERTOT/FLOAT(NPERT),
     1    SQRT(PERTSQ/FLOAT(NPERT))
         CALL XPRVDU (NCVDU,3,0)
6250     FORMAT ('Mean perturbation should be approximately zero'/' No o
     1f perturbations=',I5,5X,' Requested perturbation=',F10.4,/'   Mean
     2 perturbation=',F10.4,'       Rms perturbation=',F10.4)
      END IF
      GO TO 5800
C

C
15500  CONTINUE
C -- 'RESET' DIRECTIVE - DIRECTIVE 37
CDJW JAN00
15550  CONTINUE
      IDIRNM=IDIRNM-36
      IF (ME.LE.0) GO TO 7300
      IF (ME.LE.0) GO TO 7500
C----- CHECK FOR A PARAMETER NAME
      IDJW = KCHPRM(I)
C----- CONFIRM ONLY ONE PARAMETER NAME
      IF (IDJW .LE. 0) GOTO 7500
      IF (I .NE. 1) GOTO 7700
C----- SET PARAMETER OFFSET POINTER
      JV = IDJW
      IF (JV .GE. NKAS) JV = JV-NKAO
C----- ADJUST OFF-SET
      JV = JV -1
C----- CHECK PARAMETER IN RANGE
      IF (JV .LT. 0) GOTO 7700
      IF (JV .GT. 16) GOTO 7700
      IF (JV .EQ. 0) THEN
C----- 'TYPE' - GET AN ELEMENT NAME
C--         CHECK FOR AN ALPHA-NUMERIC ARGUMENT
            ISTAT=KFDOPD(-1,1,ISTORE(NFL),1,1)
            IF (ISTAT.LE.0) GO TO 7100
C--         ARGUMENT FOUND  -  SAVE IT
            CALL XMOVE (STORE(MF+2),APD(1),1)
      ELSE
C-----       A NUMERIC PARAMETER - READ NUMBER
            IF (KSYNUM(APD(1)).NE.0) GO TO 7500
      ENDIF
      MF=MF+LK2
      ME=ME-1
      J=KOP(8)
C----- BRANCH ON FUNCTION
      GO TO (15600, 15650, 8250),IDIRNM
      GO TO 8250
15600  CONTINUE
C----- 'RESET'
      CALL XMOVE( APD(1), Z, 1)
      GO TO 15750
15650  CONTINUE
C----- 'SPARE'
      Z=Z
      GO TO 15750
C
C----- START THE WORK
15750  CONTINUE
15800  CONTINUE
C -- CHECK FOR MORE DATA. CHECK FOR OVERALL PARAMETER. CHECK FOR
C    ATOMIC PARAMETER
      IF (KOP(8).LT.0) GO TO 100
      ISCALE=KOVPCH(I)
C -- ERROR OR SCALEFACTOR
      IF (ISCALE.NE.0) GO TO 7100
C -  CHECK FOR PARAMETER TYPE ONLY
      IPOSIT = 1
      IPARTP = 1
      IDJW = KCORCH(I)
      IF (IDJW.GT.0) GO TO 7100
      IDJW = KATOMU(LN)
      IF (IDJW.LE.0) GO TO 7100
C -- CHECK NO ATOMIC PARAMETER
      IF (ISTORE(MQ+5).NE.0) GO TO 7600
      IPOSIT=IPOSIT+1
      JU = ISTORE(MQ+6)+MQ
C--CHECK IF THERE ARE ANY ATOMS TO PROCESS
      IF (N5A) 15800,15800,15950
C--LOOP OVER THE ATOMS
15950  CONTINUE
      DO 16200 JW=1,N5A
C -- APPLY SYMMETRY TO ATOMIC COORDINATES
         IDJW = KATOMS(MQ,M5A,ITEMP)
         IF (IDJW.LT.0) GO TO 7100
         CALL XMOVE (STORE(ITEMP),STORE(M5A),MD5A)
         JU=M5A+JV
         GO TO (16000, 16050, 8250),IDIRNM
         GO TO 8250
C--'RESET'
16000     CONTINUE
         CALL XMOVE(Z, STORE(JU), 1)
C Look out for PART, REFINE, RESIDUE - they are integers.
         IF ((JV .GE. 14) .AND. (JV .LE. 16)) ISTORE(JU) = NINT(Z)
         GO TO 16150
C--'SPARE'
16050     CONTINUE
         STORE(JU)=Z
C Look out for PART, REFINE, RESIDUE - they are integers.
         IF ((JV .GE. 14) .AND. (JV .LE. 16)) ISTORE(JU) = NINT(Z)
         GO TO 16150
16150     CONTINUE
         CALL XMDMON (M5A,MD5A,1,IPOSIT,IPARTP,5,3,MONLVL,2,0,
     1    ISTORE(IMONBF))
         IPOSIT=IPOSIT+1
         ICHNG=ICHNG+1
         M5A=M5A+MD5A
16200  CONTINUE
      GO TO 15800
C
C
6300  CONTINUE
C----- 'SHIFT' DIRECTIVE
C
      IF (ME.LE.0) GO TO 7300
C -- READ SHIFT VECTOR. THREE NUMBERS OPTIONALLY SEPARATED WITH ','
      DO 6350 JW=1,3
         IF (ME.LE.0) GO TO 7500
         IF (KSYNUM(APD(JW)).NE.0) GO TO 7500
         ME=ME-1
         MF=MF+LK2
         J=KOP(8)
6350  CONTINUE
C -- CHECK IF ANY ATOMS HAVE BEEN GIVEN
      IF (ME.LE.0) GO TO 7500
6400  CONTINUE
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
      DO 6450 JW=1,N5A
C--GENERATE THE MOVED PARAMETERS BY SYMMETRY FIRST
         IF (KATOMS(MQ,M5A,ITEMP).LT.0) GO TO 7100
C--MOVE THE PARAMETERS BACK
         CALL XMOVE (STORE(ITEMP),STORE(M5A),MD5A)
C--SHIFT THE NEW COORDS.
         STORE(M5A+4)=STORE(M5A+4)+APD(1)
         STORE(M5A+5)=STORE(M5A+5)+APD(2)
         STORE(M5A+6)=STORE(M5A+6)+APD(3)
         CALL XMDMON (M5A,MD5A,1,1,1,13,3,MONLVL,2,0,ISTORE(IMONBF))
         ICHNG=ICHNG+1
         M5A=M5A+MD5A
6450  CONTINUE
C--CHECK FOR MORE ATOMS
      IF (KOP(8).LT.0) GO TO 100
      GO TO 6400
C
C
6500  CONTINUE
C----- 'TRANSFORM' DIRECTIVE
C
      IF (ME.LE.0) GO TO 7300
C -- READ ROTATION MATRIX. NINE NUMBERS OPTIONALLY SEPARATED WITH ','
      DO 6550 JW=1,9
         IF (ME.LE.0) GO TO 7500
         IF (KSYNUM(APD(JW)).NE.0) GO TO 7500
         ME=ME-1
         MF=MF+LK2
         J=KOP(8)
6550  CONTINUE
CDJWAPR2001
C---- MATRIX READ IN BY ROWS, BUT NEEDED BY COLUMNS
      CALL XTRANS(APD(1),BPD(1),3,3)
      CALL XMOVE (BPD(1), APD(1),9)
C -- CHECK IF ANY ATOMS HAVE BEEN GIVEN
      IF (ME.LE.0) GO TO 7500
6600  CONTINUE
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
      CALL XZEROF(RCPD,9)
      CALL XZEROF(RCPDI,9)
      RCPD(1) = STORE(L1P2)
      RCPD(5) = STORE(L1P2+1)
      RCPD(9) = STORE(L1P2+2)
      RCPDI(1) = 1.0/STORE(L1P2)
      RCPDI(5) = 1.0/STORE(L1P2+1)
      RCPDI(9) = 1.0/STORE(L1P2+2)
C--APPLY THE MATRIX to each atom in turn
      DO 6750 JW=1,N5A
C--GENERATE THE MOVED PARAMETERS BY SYMMETRY FIRST
         IF (KATOMS(MQ,M5A,ITEMP).LT.0) GO TO 7100
C--MOVE THE PARAMETERS BACK
         CALL XMOVE (STORE(ITEMP),STORE(M5A),MD5A)
C--GENERATE THE NEW COORDS. BY ROTATION
         BPD(1)=STORE(M5A+4)
         BPD(2)=STORE(M5A+5)
         BPD(3)=STORE(M5A+6)
CDJWAPR2001
         CALL XMLTMM (APD,BPD,STORE(M5A+4),3,3,1)
C----- NOW DO THE U'S
C-----TRANSFORM THE ANISOTROPIC TEMPERATURE FACTORS
         IF (ABS(STORE(M5A+3))-UISO) 6650,6700,6700
6650     CONTINUE
C Get full tensor from upper diagonal storage:
         J=M5A+7
         CALL XEXANI (J,JTEMP)
C Transform should be inv(N) * R * N * U * trans(N) * trans(R) * trans(inv(N))
C where N is a matrix with a*, b* and c* on the diagonal.
C N == RCPD, inv(N) == RCPDI
C Start from the middle to the left:
C N * U
         CALL XMLTMM (RCPD,STORE(JTEMP),STORE(KTEMP),3,3,3)
C R * RESULT
         CALL XMLTMM (APD,STORE(KTEMP),STORE(JTEMP),3,3,3)
C inv(N) * RESULT
         CALL XMLTMM (RCPDI,STORE(JTEMP),STORE(KTEMP),3,3,3)
C Now to the right:
C RESULT * trans(N) == RESULT * N
         CALL XMLTMM (STORE(KTEMP),RCPD,STORE(JTEMP),3,3,3)
C RESULT * trans(R)
         CALL XMLTMT (STORE(JTEMP),APD,STORE(KTEMP),3,3,3)
C RESULT * trans(inv(N)) == RESULT * inv(N)
         CALL XMLTMM (STORE(KTEMP),RCPDI,STORE(JTEMP),3,3,3)
C Put RESULT back in upper diagonal storage:
         CALL XCOANI (JTEMP,J)
6700     CONTINUE
         CALL XMDMON (M5A,MD5A,1,1,1,6,3,MONLVL,2,0,ISTORE(IMONBF))
         ICHNG=ICHNG+1
         M5A=M5A+MD5A
6750  CONTINUE
C--CHECK FOR MORE ATOMS
      IF (KOP(8).LT.0) GO TO 100
      GO TO 6600
C
C
6790  CONTINUE
C----- 'ROTATE' DIRECTIVE
C
      IF (ME.LE.0) GO TO 7300        ! Check there are some arguments

C -- READ ROTATION. POSSIBLE SYNTAX:
C   1) around vector from point.
C       ROTATE angle pointX pointY pointZ vectorX vectorY vectorZ <atoms>
C   2) around vector from atom.
C       ROTATE angle atom vectorX vectorY vectorZ <atoms>
C   3) around a bond (vec starts at atom1)
C     ROTATE angle atom1 atom2 <atoms>

      LTEMP =KSTALL(N5)
      LPNT  =KSTALL(3)
      LVEC  =KSTALL(3)
      LCF2OR=KSTALL(16)
      LOR2CF=KSTALL(16)
      LROTAT=KSTALL(16)
      LWORK =KSTALL(16)

C Get the angle.
      IF (KSYNUM(ROTATE).NE.0) GO TO 7500
      ME=ME-1
      MF=MF+LK2
      J=KOP(8)

C Get either a single atom, or a point in crys frac (see syntax above)

      IF ( ISTORE(MF) .NE. 0 ) THEN       ! Syntax 2 or 3 (atom,...)
        IF (ME.LE.0) GO TO 950               !Check for data
        IF (KATOMU(LN).LT.0) GO TO 7100      !Read atom
        IF (N5A.NE.1) GO TO 7900             !Check only one atom
        STORE(LPNT  ) = STORE(M5A+4)
        STORE(LPNT+1) = STORE(M5A+5)
        STORE(LPNT+2) = STORE(M5A+6)

C Get either another single atom, or a vector in crys frac  (see syntax above)

        IF ( ISTORE(MF) .NE. 0 ) THEN       ! Syntax 3 (atom,atom)
          IF (ME.LE.0) GO TO 950               !Check for data
          IF (KATOMU(LN).LT.0) GO TO 7100      !Read atom
          IF (N5A.NE.1) GO TO 7900             !Check only one atom
          STORE(LVEC)   = STORE(M5A+4) - STORE(LPNT)
          STORE(LVEC+1) = STORE(M5A+5) - STORE(LPNT+1)
          STORE(LVEC+2) = STORE(M5A+6) - STORE(LPNT+2)

        ELSE                                ! Syntax 2 (atom, vector)
          DO I = 0,2
            IF ( KSYNUM(STORE(LVEC+I)).NE.0) GOTO 7500
            ME=ME-1
            MF=MF+LK2
            J=KOP(8)
          END DO
        END IF

      ELSE                                ! Syntax 1 (point & vector)

        DO I = 0,2
          IF ( KSYNUM(STORE(LPNT+I)).NE.0) GOTO 7500
          ME=ME-1
          MF=MF+LK2
          J=KOP(8)
        END DO
        DO I = 0,2
          IF ( KSYNUM(STORE(LVEC+I)).NE.0) GOTO 7500
          ME=ME-1
          MF=MF+LK2
          J=KOP(8)
        END DO
      END IF

C -- READ ALL THE ATOMS.
      CALL XFILL(0,ISTORE(LTEMP),N5)
      IF (ME.LE.0) GO TO 7500
      DO WHILE (.TRUE.)
        IF (KATOMU(LN).LE.0) GO TO 7100
        IF (ISTORE(MQ+5).NE.0) GO TO 7400
        DO JW=1,N5A
C--GENERATE THE MOVED PARAMETERS BY SYMMETRY FIRST
          IF (KATOMS(MQ,M5A,ITEMP).LT.0) GO TO 7100
          LIND = (M5A-L5)/MD5
          ISTORE(LTEMP + LIND) = 1
          M5A=M5A+MD5A
        END DO
        ICHNG=ICHNG+1
C--CHECK FOR MORE ATOMS
        IF (KOP(8).LT.0) EXIT
      END DO

C Transform vector into orthogonal Angstrom space.

      CALL XMLTTM(STORE(L1O1),STORE(LVEC),BPD(1),3,3,1)

c      WRITE(CMON,'(A,3F8.4)')'CF vector: ',(STORE(LVEC+I),I=0,2)
c      CALL XPRVDU(NCVDU,1,0)
c      WRITE(CMON,'(A,3F8.4)')'OR vector: ',(BPD(I),I=1,3)
c      CALL XPRVDU(NCVDU,1,0)

C Normalise the vector, and compute rotation matrix in ortho space.
C (See matrix.src)

      IF ( NROT(BPD(1),ROTATE,APD(1)) .LT. 0 ) THEN
         WRITE(CMON,'(A)')'Rotate error: Vector has zero length.'
         CALL XPRVDU(NCVDU,1,0)
         GOTO 7100
      END IF

c      WRITE(CMON,'(A/3(3F8.4/))')'OR rotation: ',
c     c  ((APD(I+J),I=1,7,3),J=0,2)
c      CALL XPRVDU(NCVDU,4,0)

C Expand to 4-D notation.

      CALL XZEROF(STORE(LROTAT),16)
      DO I = 0,2
       DO J = 0,2
        STORE(LROTAT+I*4+J) = APD(I*3+J+1)
       END DO
      END DO
      STORE(LROTAT+15) = 1.0

c      WRITE(CMON,'(A/4(4F8.4/))')'4D version: ',
c     c  ((STORE(LROTAT+I+J),I=0,12,4),J=0,3)
c      CALL XPRVDU(NCVDU,5,0)


C Get the rotation for going from orthogonal Angstrom to CF (L1O2)
C and expand it to 4D notation.

      CALL XZEROF(STORE(LOR2CF),16)
      DO I = 0,2
       DO J = 0,2
        STORE(LOR2CF+I*4+J) = STORE(L1O2+I*3+J)
       END DO
      END DO
      STORE(LOR2CF+15) = 1.0

C Tack on the translation to the specified point in CFs.
      DO I = 0,2
        STORE(LOR2CF+12+I) = STORE(LPNT+I)
      END DO

c      WRITE(CMON,'(A/4(4F8.4/))')'4D inv(orth): ',
c     c  ((STORE(LOR2CF+I+J),I=0,12,4),J=0,3)
c      CALL XPRVDU(NCVDU,5,0)

C Now work out the inverse, that is the matrix that goes from CF
C to an orthogonal system with the origin at the point stored in LPNT.
C (This is like L1O1, but by inverting LOR2CF we get the translation
C part worked out too).


      I=KINV2(4,STORE(LOR2CF),STORE(LCF2OR),16,0,
     1          STORE(LWORK), STORE(LWORK), 4)

c      WRITE(CMON,'(A/4(4F8.4/))')'4D ORTH: ',
c     c  ((STORE(LCF2OR+I+J),I=0,12,4),J=0,3)
c      CALL XPRVDU(NCVDU,5,0)


C Pre-multiply rotation matrix by deorthogonalisation matrix,
C and post multiply by orthogonalisation matrix, so that we can do
C [ inv(O) . R . O ] . X
C
C where X are the CF coords, R is the orthogonal rotation matrix,
C and O is the transfrom from CF to Orthogonal Angstrom with the
C specified CF point at the origin.
     
      CALL XMLTMM( STORE(LOR2CF), STORE(LROTAT), STORE(LWORK), 4, 4, 4 )
      CALL XMLTMM( STORE(LWORK),  STORE(LCF2OR), STORE(LROTAT),4, 4, 4 )

c      WRITE(CMON,'(A/4(4F8.4/))')'4D all OP: ',
c     c  ((STORE(LROTAT+I+J),I=0,12,4),J=0,3)
c      CALL XPRVDU(NCVDU,5,0)

      DO I = 0,N5-1
        IF ( ISTORE(LTEMP+I) .GT. 0 ) THEN
          M5A = L5 + I * MD5
          CALL XMOVE(STORE(M5A+4),STORE(LWORK),3)
          STORE(LWORK+3) = 1.0
          CALL XMLTMM( STORE(LROTAT),STORE(LWORK),STORE(LWORK+4), 4,4,1)
          CALL XMOVE(STORE(LWORK+4),STORE(M5A+4),3)
c          WRITE(CMON,'(A,I5,6F8.3)')'Chn: ',I,STORE(M5A+4),
c     1     STORE(M5A+5),STORE(M5A+6), STORE(LWORK),
c     2     STORE(LWORK+1),STORE(LWORK+2)
c          CALL XPRVDU(NCVDU,1,0)
        END IF
      END DO

      CALL XSTRLL (LTEMP)

      GOTO 100
C
6800  CONTINUE
C----- 'DEORTHOGINALISE' ATOMS IN-PUT IN A LIST 20 SYSTEM
C
      IF (ME.LE.0) GO TO 7300
C -- READ ORTHOGONALISATION MATRIX IDENTIFIER
C      IF ( KSYNUM ( APD(1) )  .NE.  0  ) GO TO 19540
C      J = NINT (APD(1)
C      ME = ME - 1
C      MF = MF + LK2
C -- CHECK IF ANY ATOMS HAVE BEEN GIVEN
      IF (ME.LE.0) GO TO 7500
6850  CONTINUE
      IF (KATOMU(LN).LE.0) GO TO 7100
      IF (ISTORE(MQ+5).NE.0) GO TO 7400
C--APPLY THE MATRIX
      DO JW=1,N5A
C--GENERATE THE NEW COORDS. BY ROTATION
         BPD(1)=STORE(M5A+4)
         BPD(2)=STORE(M5A+5)                     
         BPD(3)=STORE(M5A+6)
         CALL XMLTMM (STORE(L20I+9),BPD,STORE(M5A+4),3,3,1)
C----- NOW TRANSLATE
         STORE(M5A+4)=STORE(M5A+4)+STORE(L20V+3)
         STORE(M5A+5)=STORE(M5A+5)+STORE(L20V+4)
         STORE(M5A+6)=STORE(M5A+6)+STORE(L20V+5)
         CALL XMDMON (M5A,MD5A,1,1,1,6,3,MONLVL,2,0,ISTORE(IMONBF))
         ICHNG=ICHNG+1
         M5A=M5A+MD5A
      END DO
C--CHECK FOR MORE ATOMS
      IF (KOP(8).LT.0) GO TO 100
      GO TO 6850
C
C
6950  CONTINUE
C----- 'INSERT' - INSERT A VALUE FROM LIST 3 OR 29 INTO 'SPARE'

      I=ISTORE(ICOMBF+IMDAT1)
      IF (KLST(I).LE.0) GO TO 7100 ! Reqd list failed to load.
      IF ( MD5.LT.14 ) GO TO 7100 ! Very old List 5 form.

      IF ( I .LE. 2 ) THEN    ! ELECTRON or WEIGHT
         IF (KMDINS(I).LT.0) GO TO 7100
      ELSE IF ( I .EQ. 3 ) THEN ! NCONNECTIONS
C Force a bondcalc, but don't allow loading of L5
         CALL XBCALC(2)
C Put number of connections into SPARE
         DO I = 0,N5-1
           STORE(L5+13+I*MD5) = 0.0
         END DO
         DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B
            J51 = ISTORE(M41B)
            J52 = ISTORE(M41B+6)
            I51 = L5 + J51 * MD5
            I52 = L5 + J52 * MD5
            STORE(I51+13)=STORE(I51+13)+1.0
            STORE(I52+13)=STORE(I52+13)+1.0
         END DO
         ICHNG=ICHNG+1
         CALL XMDMON (L5,MD5,N5,3,1,1,1,MONLVL,2,1,ISTORE(IMONBF))
      ELSE IF ( I .EQ. 4 ) THEN ! RELAXATION ID
C Force a bondcalc, but don't allow loading of L5
         CALL XBCALC(2)
C Put electron count into SPARE
         IF (KLST(1).LE.0)   GO TO 7100 ! Reqd list failed to load.
         IF (KMDINS(1).LT.0) GO TO 7100
C Get some workspace
         LTEMP=KSTALL(N5)
C Relax.
         IDOCNT = -1
         DO WHILE ( .TRUE. )
C Copy existing SPARE into STORE(LTEMP)
            DO I = 0, N5-1
               STORE(LTEMP+I) = REAL(NINT( STORE(L5+13+I*MD5) ))
            END DO
C Propagate values through the bonding network.
            DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B
               J51 = ISTORE(M41B)
               J52 = ISTORE(M41B+6)
               I51 = L5 + J51 * MD5
               I52 = L5 + J52 * MD5
               STORE(I51+13)=REAL(NINT(STORE(I51+13)+STORE(LTEMP+J52)))
               STORE(I52+13)=REAL(NINT(STORE(I52+13)+STORE(LTEMP+J51)))
            END DO

C Copy new SPARE into ISTORE(LTEMP)
            DO I = 0, N5-1
               ISTORE(LTEMP+I) = NINT( STORE(L5+13+I*MD5) )
            END DO
C Sort data at LTEMP
            CALL SSORTI(LTEMP,N5,1,1)
C Scan through, and count number of unique ID's.
            LASTID = -1
            IDCOUN = 0
            DO I = 0, N5-1
              IF ( ISTORE(LTEMP+I) .NE. LASTID) THEN
                 IDCOUN = IDCOUN + 1
                 LASTID = ISTORE(LTEMP+I)
              END IF
            END DO
C If unique number is unchanged or worse(?), then break.
            IF ( IDCOUN .LE. IDOCNT ) EXIT
            IDOCNT = IDCOUN
         END DO
C- RETURN WORKSPACE
         CALL XSTRLL (LTEMP)
         ICHNG=ICHNG+1
         CALL XMDMON (L5,MD5,N5,3,1,1,1,MONLVL,2,1,ISTORE(IMONBF))
      ELSE IF ( I .EQ. 5 ) THEN ! RESIDUE
C Force a bondcalc, but don't allow loading of L5
         CALL XBCALC(2)
C Put residue ID into RESIDUE slot.
         IF (KLST(1).LE.0)   GO TO 7100 ! Reqd list failed to load.
         IF (KMDINS(1).LT.0) GO TO 7100
C Ensure all RESIDs are zero or positive and discover whether
C all RESIDs are zero:
         IFRGMX = 0
         DO I = 0,N5-1
           ISTORE(L5+16+I*MD5) = ABS ( ISTORE(L5+16+I*MD5) )
           IFRGMX = MAX ( IFRGMX, ISTORE(L5+16+I*MD5) )
c           write(cmon,'(a,i4)')'RESIID = ', ISTORE(L5+16+I*MD5)
c           call xprvdu(ncvdu,1,0)
         END DO

c         write(cmon,'(a,i4)')'IFRGMX 1 = ',IFRGMX
c         call xprvdu(ncvdu,1,0)

         IF ( IFRGMX .GE. 1 ) THEN
C Residues already have some RESIID's: Ensure no two residues contain
C the same ID. How? Well:
C  1) Take the first non-negative, non-zero ID, set it negative.
C  2) Propagate negative numbers through the bonding network, until
C     no more changes.
C  3) Search remainder for a matching +ve RESIID. If found, assign a free ID.
C  4) Go back to 1, until all residues are zero or negative.

c           write(cmon,'(a)')'Some non-zero residue ids.'
c           call xprvdu(ncvdu,1,0)

           DO I = 0, N5-1   
             IF (ISTORE(L5+16+I*MD5).GT.0) THEN     ! Found next +ve RESIID
               IFRGID = ISTORE(L5+16+I*MD5)
               ISTORE(L5+16+I*MD5) = - IFRGID
               NCHANG = 1
               DO WHILE ( NCHANG .GT. 0 )
                 NCHANG = 0
                 DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B
                   I51 = L5 + ISTORE(M41B) * MD5
                   I52 = L5 + ISTORE(M41B+6) * MD5
                   IF (ISTORE(I51+16) .LT. 0) THEN
                     IF ( ISTORE(I51+16) .NE. ISTORE(I52+16) ) NCHANG=1
                     IF ( ISTORE(I52+16) .LT. 0) THEN
                       NEWVAL = MAX(ISTORE(I51+16),ISTORE(I52+16))
                       ISTORE(I51+16)=NEWVAL
                       ISTORE(I52+16)=NEWVAL
                     ELSE
                       ISTORE(I52+16)=ISTORE(I51+16)
                     END IF
                   ELSE IF (ISTORE(I52+16) .LT. 0) THEN
                     IF ( ISTORE(I51+16) .NE. ISTORE(I52+16) ) NCHANG=1
                     ISTORE(I51+16)=ISTORE(I52+16)
                   END IF
                 END DO
               END DO   ! RESIIDs propagated everywhere.

               DO J = I+1, N5-1  ! Check for matching values, and reassign.
                 IF (ISTORE(L5+16+J*MD5) .EQ. IFRGID) THEN
                   IFRGMX = IFRGMX + 1
                   WRITE(CMON,'(2(A,I4))')
     1 'Duplicate residue ID found: ',IFRGID,' 2nd set to: ',IFRGMX
                   CALL XPRVDU(NCVDU,1,0)
                   ISTORE(L5+16+J*MD5) = IFRGMX
                 END IF
               END DO    
             END IF
           END DO
           IFRGMX = 0
c           write(cmon,'(a)')'End of init check: '
c           call xprvdu(ncvdu,1,0)
           DO I = 0,N5-1                      ! Make all RESIIDs non negative.
             ISTORE(L5+16+I*MD5) = ABS ( ISTORE(L5+16+I*MD5) )
             IFRGMX = MAX ( IFRGMX, ISTORE(L5+16+I*MD5) )
c             write(cmon,'(a,i4)')'REISID = ', ISTORE(L5+16+I*MD5)
c             call xprvdu(ncvdu,1,0)
           END DO
         END IF

c         write(cmon,'(a,i4)')'IFRGMX 2 = ',IFRGMX
c         call xprvdu(ncvdu,1,0)

C Residues may already have some RESIID's, but they will be already
C numbered and propagated.
C  1) Take the first zero ID, set it to next free ID.
C  2) Propagate numbers through the bonding network, until no more changes.
C  4) Go back to 1, until all residues are non zero.

         DO I = 0, N5-1   
           IF (ISTORE(L5+16+I*MD5).EQ.0) THEN     ! Found next zero RESIID
             IFRGMX = IFRGMX + 1
             ISTORE(L5+16+I*MD5) = IFRGMX

c             write(cmon,'(a,i4)')'Found 0 RESIID: ', I
c             call xprvdu(ncvdu,1,0)
c             write(cmon,'(a,i4)')'Changed to: ', IFRGMX
c             call xprvdu(ncvdu,1,0)

             NCHANG = 1
             DO WHILE ( NCHANG .GT. 0 )
               NCHANG = 0
               DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B
                 I51 = L5 + ISTORE(M41B) * MD5
                 I52 = L5 + ISTORE(M41B+6) * MD5
                 IF ( ISTORE(I51+16) .NE. ISTORE(I52+16) ) THEN
                   NCHANG=1
                   NEWVAL = MIN(ISTORE(I51+16),ISTORE(I52+16))
                   IF(NEWVAL.LE.0)
     1                 NEWVAL = MAX(ISTORE(I51+16),ISTORE(I52+16))
                   ISTORE(I51+16)=NEWVAL
                   ISTORE(I52+16)=NEWVAL
                 END IF
               END DO
             END DO   ! RESIIDs propagated everywhere.
           END IF
         END DO

C Might a script want to know IFRGMX?
C It is useful to know that the current maximum variable length is 12 chars.
         ISTAT = KSCTRN ( 1 , 'EDIT:FRAGMAX' , IFRGMX, 1 )

         

         ICHNG=ICHNG+1
         CALL XMDMON (L5,MD5,N5,3,1,1,1,MONLVL,2,1,ISTORE(IMONBF))
      END IF
      GO TO 100
C
C
7000  CONTINUE
C -- **** SUCCESSFUL TERMINATION ****
C
C -- WRITE OUT THE NEW LIST
      CALL XMDWLS
      GO TO 7050
C
C
7050  CONTINUE
C -- **** FINAL MESSAGES ****
C
      CALL XOPMSG (IOPLSM,IOPEND,IVERSN)
      CALL XTIME2 (2)
      RETURN
C
C
7100  CONTINUE
C -- **** NON-FATAL ERRORS AND WARNINGS ****
C
      IF (ISSPRT.EQ.0) WRITE (NCWU,7150)
cfeb08      WRITE (NCAWU,7150)
      WRITE (CMON,7150)
      CALL XPRVDU (NCVDU,1,0)
7150  FORMAT (1X,'The previous directive has been ignored')
      CALL XERHND (IERWRN)
      LEF=LEF+1
      GO TO 100
C
7200  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7250)
cfeb08      WRITE (NCAWU,7250)
      WRITE (CMON,7250)
      CALL XPRVDU (NCVDU,1,0)
7250  FORMAT (1X,'The previous directive should have been followed',' by
     1 END')
      GO TO 7100
C
7300  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7350)
cfeb08      WRITE (NCAWU,7350)
      WRITE (CMON,7350)
      CALL XPRVDU (NCVDU,1,0)
7350  FORMAT (1X,'No arguments found')
      GO TO 7100
C
7400  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7450)
cfeb08      WRITE (NCAWU,7450)
      WRITE (CMON,7450)
      CALL XPRVDU (NCVDU,1,0)
7450  FORMAT (1X,'Parameter specifications are illegal for this ','instr
     1uction')
      GO TO 7100
C
7500  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7550)
cfeb08      WRITE (NCAWU,7550)
      WRITE (CMON,7550)
      CALL XPRVDU (NCVDU,1,0)
7550  FORMAT (1X,'Argument missing or of wrong type')
      GO TO 7100
C
7600  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7650)
cfeb08      WRITE (NCAWU,7650)
      WRITE (CMON,7650)
      CALL XPRVDU (NCVDU,1,0)
7650  FORMAT (1X,'Wrong number of parameters specified')
      GO TO 7100
C
7700  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7750)
cfeb08      WRITE (NCAWU,7750)
      WRITE (CMON,7750)
      CALL XPRVDU (NCVDU,1,0)
7750  FORMAT (1X,'Incorrect parameter type specified')
      GO TO 7100
C
7800  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7850)
cfeb08      WRITE (NCAWU,7850)
      WRITE (CMON,7850)
      CALL XPRVDU (NCVDU,1,0)
7850  FORMAT (1X,'Only one argument group is allowed with this ','direct
     1ive')
      GO TO 7100
C
7900  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,7950)
cfeb08      WRITE (NCAWU,7950)
      WRITE (CMON,7950)
      CALL XPRVDU (NCVDU,1,0)
7950  FORMAT (1X,'Only one atom may be specified')
      GO TO 7100
C
8000  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,8050)
cfeb08      WRITE (NCAWU,8050)
      WRITE (CMON,8050)
      CALL XPRVDU (NCVDU,1,0)
8050  FORMAT (1X,' Atom not found in LIST 5')
      GO TO 7100
C
8100  CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,8150)
cfeb08      WRITE (NCAWU,8150)
      WRITE (CMON,8150)
      CALL XPRVDU (NCVDU,1,0)
8150  FORMAT (1X,' Atom already in LIST 5')
      GO TO 7100
C
C
8200  CONTINUE
C -- **** TERMINATING ERRORS ****
C
      CALL XOPMSG (IOPMOD,IOPLSP,LA)
      GO TO 7050
8250  CONTINUE
C -- INTERNAL ERROR
      CALL XOPMSG (IOPLSM,IOPINT,0)
      GO TO 8200
      END
CODE FOR XINERT
      SUBROUTINE XINERT (KEY,X,A,D)
C----- COMPUTE CONTRIBUTION TO INERTIAL TENSOR
C      KEY 0 FOR INITIALISATION
C          1 FOR SUMMATION
C          2 FOR EVALUATION
C      X - ATOMIC COORDINATES
C      A - WORKSPACE
C      D - CONVERSION TERM
      DIMENSION X(3), A(9), D(3)
      INCLUDE 'XUNITS.INC'
      SAVE NTERM
      IF (KEY.EQ.0) THEN
         NTERM=0
         CALL XZEROF (A,9)
      ELSE IF (KEY.EQ.1) THEN
C----- ACCUMULATION
         DO 50 I=1,3
            X(I)=X(I)*D(I)
50       CONTINUE
C
         DO 100 I=1,3
            A(I)=A(I)+X(I)
            A(I+3)=A(I+3)+X(I)*X(I)
            J=1+MOD((I+1),3)
            K=1+MOD((I),3)
            A(I+6)=A(I+6)+X(J)*X(K)
100      CONTINUE
         NTERM=NTERM+1
      ELSE IF (KEY.EQ.2) THEN
C----- EVALUATION
C-----  2/NTERM IS AN ARBITARY SCALING FACTOR FOR THE TENSOR
         DIV=1./FLOAT(NTERM)
C----- COMPARE WITH MEAN AND STANDARD DEVIATION
C      SUM[(X-A)*(Y-B)]= SUM(X*Y) - 1/N * SUM(X)*SUM(Y)
         DO 150 I=1,3
            J=1+MOD((I+1),3)
            K=1+MOD((I),3)
            A(I+3)=2.*DIV*(A(I+3)-A(I)*A(I)*DIV)
            A(I+6)=2.*DIV*(A(I+6)-A(J)*A(K)*DIV)
150      CONTINUE
         DO 200 I=1,3
            A(I)=A(I)*DIV/D(I)
200      CONTINUE
      ELSE
C            STOP 'ERROR'
         CALL GUEXIT (2017)
      END IF
      RETURN
      END
CODE FOR XBUC
      SUBROUTINE XBUC
C--TRANSFORM FROM B(IJ8) TO U(IJ) FORM
C
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XOPVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
C--SET THE TIMING
      CALL XTIME1 (2)
C--READ THE REMAINING DATA
      IF (KRDDPV(ISTORE(NFL),3).LT.0) GO TO 550
C--SET UP THE CONVERSION CONSTANT
      IN=ISTORE(NFL)
      IULN=KTYP05(ISTORE(NFL+1))
      LNOUT=KTYP05(ISTORE(NFL+2))
      A=1./(4.*TWOPIS)
C--CLEAR THE STORE
      CALL XCSAE
      CALL XRSL
C--LOAD THE LISTS
      CALL XFAL01
      CALL XLDR05 (IULN)
      IF (IERFLG.LT.0) GO TO 500
      M5=L5+(N5-1)*MD5
      DO 300 I=L5,M5,MD5
C--CHECK THE ATOM TYPE
         IF (ABS(STORE(I+3))-UISO) 100,50,50
C--'ISO' ATOMS
50       CONTINUE
         STORE(I+3)=STORE(I+3)*A
C      STORE(I+3)=STORE(I+3)*A
         STORE(I+7)=STORE(I+7)*A
         GO TO 300
C--'ANISO' ATOMS
100      CONTINUE
         K=I+7
         L=I+12
         M=L1A
         DO 150 J=K,L
            STORE(J)=-STORE(J)/STORE(M)
            M=M+1
150      CONTINUE
C--CHECK IF 0.5 FACTOR REQUIRED
         IF (IN) 200,200,300
200      CONTINUE
         K=I+10
         DO 250 J=K,L
            STORE(J)=2.0*STORE(J)
250      CONTINUE
300   CONTINUE
      NEW=-1
      IF (IULN-LNOUT) 350,400,350
350   CONTINUE
      NEW=1
400   CONTINUE
      CALL XSTR05 (LNOUT,0,NEW)
C--FINAL TERMINATION MESSAGES
450   CONTINUE
      CALL XOPMSG (IOPTFC,IOPEND,410)
      CALL XTIME2 (2)
      RETURN
C
500   CONTINUE
      CALL XOPMSG (IOPTFC,IOPABN,0)
      GO TO 450
550   CONTINUE
C -- COMMAND INPUT ERRORS
      CALL XOPMSG (IOPTFC,IOPCMI,0)
      GO TO 500
      END
CODE FOR XMDWLS
      SUBROUTINE XMDWLS
C
C -- THIS ROUTINE WRITES THE CURRENT LIST 5 FROM 'MODIFY'
C
C      NEW LIST IS ONLY WRITTEN IF LIST TYPE IS CHANGED OR LIST
C      HAS BEEN CHANGED
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XMDCOM.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
C -- IF A NEW LIST IS NOT CREATED A WARNING MESSAGE WILL BE SENT TO
C    THE USER, UNLESS THE REASON WAS ERRORS DURING PROCESSING IN WHICH
C    CASE THE MESSAGE IS AN ERROR
      IERROR=IERWRN
C -- CHECK FOR ERRORS IF FLAG SET
      IF (ICHKER.LE.0) GO TO 50
      IF (IERFLG.LT.0) GO TO 400
      IF (LEF.GT.0) GO TO 400
50    CONTINUE
C -- SET LIST WRITE FLAG
      LISTWR=0
C -- CHECK IF LIST HAS BEEN ALTERED
      IF (ICHNG.GT.0) LISTWR=1
      IF (LISTWR.LE.0) GO TO 300
C
C -- CHECK IF EDITING ABANDONED
      IF (IQUIT.GT.0) GO TO 500
C
C -- CHECK IF KEEP HAS BEEN USED.
      IF (MKEEP.GT.0) N5=NKEEP
C
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,100) LB,N5
      END IF
100   FORMAT (1X,'List ',I3,' now contains ',I6,' atom(s)')
C
C -- WRITE THE LIST TO DISC
      N=N5
      NEW=1
      CALL XCPYL5 (LA,LB,N,NEW)
      CALL XSTR05 (LB,0,NEW)
C
150   CONTINUE
C
      RETURN
C
200   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,250) LB
      IF ( MONLVL .GT. 0 ) THEN
cfeb08        WRITE (NCAWU,250) LB
        WRITE (CMON,250) LB
        CALL XPRVDU (NCVDU,1,0)
250     FORMAT (1X,'No new list ',I3,' will be created')
        CALL XERHND (IERROR)
      END IF
      GO TO 150
300   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,350) LA
cfeb08      WRITE (NCAWU,350) LA
      WRITE (CMON,350) LA
      CALL XPRVDU (NCVDU,1,0)
350   FORMAT (1X,'List ',I3,' has not been changed ')
      GO TO 200
400   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,450) LA
cfeb08      WRITE (NCAWU,450) LA
      WRITE (CMON,450) LA
      CALL XPRVDU (NCVDU,1,0)
450   FORMAT (1X,'Errors during processing of list ',I3)
C -- THIS CONDITION IS AN ERROR
      IERROR=IERERR
      GO TO 200
500   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,550) LA
cfeb08      WRITE (NCAWU,550) LA
      IF ( MONLVL .GT. 0 ) THEN
        WRITE (CMON,550) LA
        CALL XPRVDU (NCVDU,1,0)
550     FORMAT (1X,'Modification of list ',I3,' abandoned')
      END IF
      GO TO 200
C
      END
CODE FOR XMDMON
      SUBROUTINE XMDMON (ISTART,ISIZE,NDATA,IPOSIT,IPARTP,IFUNC,LEVEL,
     1IMNLVL,IMNCNT,IFLAG,ICONTL)
C
C -- MONITOR/DISPLAY ROUTINE FOR ATOMIC AND OVERALL PARAMETERS AND
C    VARIOUS SCALE FACTORS
C
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
C            WORD 2  NUMBER OF ITEMS PRINTED SO FAR
C            WORD 3  SAVED VALUE OF IFUNC
C            WORD 4  SAVED VALUE OF IPARTP
C            WORD 5  SAVED VALUE OF NDATA
C
C
      DIMENSION ICONTL(5)
C
C
      CHARACTER*4 CTEMP
C
C
      DIMENSION INUM(3,3), IMAX(3,3), IOFF(3,3), ILEN(3,3)
      DIMENSION A(20)
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XOPK.INC'
      INCLUDE 'XSCALE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      SAVE A
C
      DATA IMDLVL/1/,IMDITM/2/,IMDFUN/3/
      DATA IMDTYP/4/,IMDNDA/5/
C
Cdjwmap99 output 8 items for brief atoms
      DATA INUM(1,1)/2/,INUM(2,1)/8/,INUM(3,1)/15/
      DATA INUM(1,2)/2/,INUM(2,2)/3/,INUM(3,2)/3/
      DATA INUM(1,3)/3/,INUM(2,3)/4/,INUM(3,3)/4/
C
Cdjwmap99 output 8x2 items for brief atoms
      DATA IMAX(1,1)/14/,IMAX(2,1)/16/,IMAX(3,1)/15/
      DATA IMAX(1,2)/16/,IMAX(2,2)/12/,IMAX(3,2)/12/
      DATA IMAX(1,3)/15/,IMAX(2,3)/16/,IMAX(3,3)/16/
C
      DATA IOFF(1,1)/1/,IOFF(2,1)/1/,IOFF(3,1)/1/
      DATA IOFF(1,2)/0/,IOFF(2,2)/3/,IOFF(3,2)/3/
      DATA IOFF(1,3)/0/,IOFF(2,3)/4/,IOFF(3,3)/4/
C
Cdjwmap99 output 8 items for brief atoms
      DATA ILEN(1,1)/2/,ILEN(2,1)/8/,ILEN(3,1)/15/
      DATA ILEN(1,2)/0/,ILEN(2,2)/1/,ILEN(3,2)/1/
      DATA ILEN(1,3)/0/,ILEN(2,3)/1/,ILEN(3,3)/1/
C
      DATA ITEM/0/
      DATA MAXITM/15/
C
C -- SELECT THE REQUIRED LEVEL OF LISTING
C
C
      IF (IMNCNT.EQ.0) THEN
         GO TO 550
      ELSE IF (IMNCNT.EQ.1) THEN
         JLEVEL=LEVEL
      ELSE IF (IMNCNT.EQ.2) THEN
C
         IF (IMNLVL.EQ.0) THEN
            JLEVEL=0
         ELSE IF (IMNLVL.EQ.1) THEN
            JLEVEL=MIN0(LEVEL,1)
         ELSE IF (IMNLVL.EQ.2) THEN
            JLEVEL=LEVEL
         ELSE IF (IMNLVL.EQ.3) THEN
            JLEVEL=MAX0(LEVEL,2)
         ELSE
            GO TO 600
         END IF
C
      ELSE
         GO TO 600
      END IF
C
      GO TO (50,100,150,150,150,200,200,200,600),IPARTP
      GO TO 600
C
50    CONTINUE
      ICLASS=1
      IDISPL=JLEVEL
      GO TO 250
100   CONTINUE
      ICLASS=2
      IF (JLEVEL.EQ.1) THEN
         IDISPL=4
      ELSE
         IDISPL=5
      END IF
      GO TO 250
150   CONTINUE
      ICLASS=3
      IF (JLEVEL.EQ.1) THEN
         IDISPL=6
      ELSE
         IDISPL=7
      END IF
      GO TO 250
200   CONTINUE
      ICLASS=3
      IF (JLEVEL.EQ.1) THEN
         IDISPL=8
      ELSE
         IDISPL=9
      END IF
      GO TO 250
250   CONTINUE
C
C
C -- IF THIS IS THE FIRST CALL FOR THIS TYPE ( BUFFER HAS JUST BEEN
C    PURGED ) , REMEMBER FUNCTION TYPE AND LEVEL
C
      IF (ICONTL(IMDITM).LE.0) THEN
         ICONTL(IMDLVL)=IDISPL
         ICONTL(IMDFUN)=IFUNC
         ICONTL(IMDTYP)=IPARTP
         ICONTL(IMDNDA)=NDATA
      END IF
C
      IF (JLEVEL.LE.0) GO TO 550
C
      ITMLEN=INUM(JLEVEL,ICLASS)
      MAXITM=IMAX(JLEVEL,ICLASS)
      MOVOFF=IOFF(JLEVEL,ICLASS)
      MOVLEN=ILEN(JLEVEL,ICLASS)
C
      JSTART=ISTART
      ITMCHK=MAXITM-ITMLEN
C
      IF (NDATA.LE.0) GO TO 550
C
      DO 500 I=1,NDATA
C
         GO TO (300,350,400,600),ICLASS
         GO TO 600
C
300      CONTINUE
         GO TO 450
350      CONTINUE
         IND=IPOSIT+I-1
         CALL XMOVE (KVP(1,IND),A(ITEM+1),2)
         GO TO 450
400      CONTINUE
C----- SPECIAL OVERALL PARAMS
         CALL XMOVE (KSCAL(1,IPARTP),A(ITEM+1),2)
         A(ITEM+3)=REAL(IPOSIT+I-1)
         GO TO 450
C
450      CONTINUE
         IF (MOVLEN.GT.0) THEN
            CALL XMOVE (STORE(JSTART),A(ITEM+MOVOFF),MOVLEN)
         END IF
CDJWMAR99 - PACK UP TYPE AND SERIAL
         IF (ICLASS.EQ.1) THEN
            CALL XHSHR (A(ITEM+MOVOFF),CTEMP)
         END IF
C
         ITEM=ITEM+ITMLEN
         IF (ITEM.GT.ITMCHK) THEN
            CALL XMDPRT (A,ITEM,ICONTL)
         END IF
         JSTART=JSTART+ISIZE
500   CONTINUE
C
C
550   CONTINUE
C
C -- CHECK IF PRINT HAS BEEN FORCED
      IF (IFLAG.GT.0) THEN
         CALL XMDPRT (A,ITEM,ICONTL)
         ICONTL(IMDITM)=0
      END IF
C
      RETURN
C
600   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,650)
cfeb08      WRITE (NCAWU,650)
      WRITE (CMON,650)
      CALL XPRVDU (NCVDU,1,0)
650   FORMAT (1X,'Illegal LEVEL value selected')
      CALL XERHND (IERPRG)
      RETURN
      END
CODE FOR XMDPRT
      SUBROUTINE XMDPRT (A,NA,ICONTL)
C
C -- OUTPUT FORMAT ROUTINE FOR THE 'EDIT' MONITORING ROUTINES
C
C  A        DATA TO BE OUTPUT
C  NA       NUMBER OF WORDS TO BE OUTPUT
C  ICONTL   CONTROL DATA - ARRAY OF LENGTH 5. SEE 'XMDMON'
C
C
      DIMENSION A(20)
      dimension b(20),ib(20)
      DIMENSION ICONTL(5)
C
      DIMENSION LTYPE(8)
      DIMENSION LACT(11)
C
      CHARACTER*24 TYPE (8),ACTTYP
      CHARACTER*24 ACTION(12),OPERAT
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      equivalence (b(1), ib(1))
C
      DATA TYPE(1)/' atom                   '/
      DATA TYPE(2)/' overall parameter      '/
      DATA TYPE(3)/' layer scale            '/
      DATA TYPE(4)/' element scale          '/
      DATA TYPE(5)/' batch scale            '/
      DATA TYPE(6)/' cell parameter         '/
      DATA TYPE(7)/' profile parameter      '/
      DATA TYPE(8)/' extinction parameter   '/
C
      DATA LTYPE(1)/5/,LTYPE(2)/18/,LTYPE(3)/12/
      DATA LTYPE(4)/14/,LTYPE(5)/12/
      DATA LTYPE(6)/15/,LTYPE(7)/18/,LTYPE(8)/21/
C
      DATA ACTION(1)/'deleted                 '/
      DATA ACTION(2)/'made anisotropic        '/
      DATA ACTION(3)/'changed                 '/
      DATA ACTION(4)/'arithmetically modified '/
      DATA ACTION(5)/'rotated                 '/
      DATA ACTION(6)/'created                 '/
      DATA ACTION(7)/'kept                    '/
      DATA ACTION(8)/'moved                   '/
      DATA ACTION(9)/'selected                '/
      DATA ACTION(10)/'made isotropic          '/
      DATA ACTION(11)/'sorted                  '/
      DATA ACTION(12)/'shifted                 '/
C
      DATA LACT(1)/7/,LACT(2)/16/,LACT(3)/7/
      DATA LACT(4)/23/,LACT(5)/7/,LACT(6)/7/
      DATA LACT(7)/4/,LACT(8)/5/,LACT(9)/8/
      DATA LACT(10)/14/,LACT(11)/6/
C
      DATA IMDLVL/1/,IMDITM/2/,IMDFUN/3/
      DATA IMDTYP/4/,IMDNDA/5/
C
CDJWNOV2001 - A BODGE TO HANDLE THE INTEGER ELEMENTS
      CALL XMOVE(A,B,20)
C
      IF (NA.LE.0) GO TO 1000
      IF (ICONTL(IMDLVL).LE.0) GO TO 1000
C
C -- CHECK IF A HEADING SHOULD BE PRINTED AT THIS POINT. THIS WILL BE
C    THE CASE IF NO ATOMS HAVE YET BEEN PRINTED
      IF (ICONTL(IMDITM).GT.0) GO TO 250
      ICONTL(IMDITM)=ICONTL(IMDITM)+1
C
C -- SELECT THE TYPE OF DATA FOR THE HEADING
      ITYPE=ICONTL(IMDTYP)
      ACTTYP=TYPE(ITYPE)
      LENGTH=LTYPE(ITYPE)
C
C
      IF (ICONTL(IMDFUN).LE.1) THEN
C
         IF (ICONTL(IMDNDA).NE.1) THEN
            LENGTH=LENGTH+1
            ACTTYP(LENGTH:LENGTH)='s'
         END IF
C
         WRITE (CMON,50) ICONTL(IMDNDA),ACTTYP(1:LENGTH)
50       FORMAT (' The list currently contains ',I5,A)
         CALL XPRVDU (NCVDU,1,0)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
cfeb08         WRITE (NCAWU,'(A)') CMON(1)
C
CDJWMAR99[
         IF (ICONTL(IMDLVL).EQ.2) THEN
            WRITE (CMON,100)
            CALL XPRVDU (NCVDU,1,0)
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
cfeb08            WRITE (NCAWU,'(A)') CMON(1)
         ELSE IF (ICONTL(IMDLVL).EQ.3) THEN
            WRITE (CMON,150)
            CALL XPRVDU (NCVDU,2,0)
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1),CMON(2)
cfeb08            WRITE (NCAWU,'(A)') CMON(1),CMON(2)
         END IF
100      FORMAT (2(9X,'Occ',4X,'x',5X,'y',5X,'z',7X,'U',3X))
150      FORMAT (9X,'Occ',4X,'x',5X,'y',5X,'z',6X,'U11',3X,'U22',3X,'U33
     1',2X,'U23',2X,'U13',2X,'U12',4X,'Spare',5X,'Part'/
     2 35X,'Uiso',2X,'Size',1X,'D/100',1X,'A/100')
      ELSE
C
C -- SELECT THE OPERATION THAT WILL BE PERFORMED
         OPERAT=ACTION(ICONTL(IMDFUN)-1)
         LOPER=LACT(ICONTL(IMDFUN)-1)
C
         ACTTYP(LENGTH+1:LENGTH+3)='(s)'
         LENGTH=LENGTH+3
C
         WRITE (CMON,200) ACTTYP(1:LENGTH),OPERAT(1:LOPER)
         CALL XPRVDU (NCVDU,1,0)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
cfeb08         WRITE (NCAWU,'(A)') CMON(1)
C
         IF (ICONTL(IMDLVL).EQ.2) THEN
            WRITE (CMON,100)
            CALL XPRVDU (NCVDU,1,0)
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
cfeb08            WRITE (NCAWU,'(A)') CMON(1)
         ELSE IF (ICONTL(IMDLVL).EQ.3) THEN
            WRITE (CMON,150)
            CALL XPRVDU (NCVDU,2,0)
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1),CMON(2)
cfeb08            WRITE (NCAWU,'(A)') CMON(1),CMON(2)
         END IF
CDJWMAR99]
200      FORMAT (1X,'The following',A,' will be ',A)
      END IF
C
C
250   CONTINUE
C
C
      GO TO (300,400,500,600,700,800,900,800,900,1050),ICONTL(IMDLVL)
      GO TO 1050
C
300   CONTINUE
C -- BRIEF PRINT
      IF (ISSPRT.EQ.0) WRITE (NCWU,350) (A(I),NINT(A(I+1)),I=1,NA,2)
cfeb08      WRITE (NCAWU,350) (A(I),NINT(A(I+1)),I=1,NA,2)
      WRITE (CMON,350) (A(I),NINT(A(I+1)),I=1,NA,2)
      CALL XPRVDU (NCVDU,1,0)
350   FORMAT (1X,7(A4,I4,3X))
      GO TO 1000
C
400   CONTINUE
C -- MEDIUM PRINT
Cdjwmar99 print Uiso/Uii - 8 items
      WRITE (CMON,450) (A(I),NINT(A(I+1)),A(I+2),A(I+4),A(I+5),A(I+6),
     1NINT(A(I+3)),A(I+7),I=1,NA,8)
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)(:)
cfeb08      WRITE (NCAWU,'(A)') CMON(1)(:)
450   FORMAT (2(A4,I4,F5.2,3F6.3,I2,F6.3,1X))
      GO TO 1000
C
500   CONTINUE
C -- FULL PRINT
      WRITE (CMON,550) (A(I),NINT(A(I+1)),A(I+2),A(I+4),A(I+5),A(I+6),
     1NINT(A(I+3)),A(I+7),A(I+8),A(I+9),A(I+10),A(I+11),A(I+12),A(I+13),
     2IB(I+14),I=1,NA,15)
      CALL XPRVDU (NCVDU,1,0)
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)(:)
cfeb08      WRITE (NCAWU,'(A)') CMON(1)(:)
550   FORMAT (A4,I4,F5.2,3F6.3,I2,3F6.3,3F5.2,F10.3,I7)
      GO TO 1000
600   CONTINUE
C -- LOW LEVEL PRINT FOR OVERALL PARAMETERS
      IF (ISSPRT.EQ.0) WRITE (NCWU,650) (A(I),I=1,NA)
cfeb08      WRITE (NCAWU,650) (A(I),I=1,NA)
      WRITE (CMON,650) (A(I),I=1,NA)
650   FORMAT (1X,8(2A4,1X))
      GO TO 1000
700   CONTINUE
C -- MEDIUM/HIGH LEVEL PRINT FOR OVERALL PARAMETERS
      IF (ISSPRT.EQ.0) WRITE (NCWU,750) (A(I),I=1,NA)
cfeb08      WRITE (NCAWU,750) (A(I),I=1,NA)
      WRITE (CMON,750) (A(I),I=1,NA)
      CALL XPRVDU (NCVDU,1,0)
750   FORMAT (1X,4(2A4,F9.3,2X))
      GO TO 1000
800   CONTINUE
C -- LOW LEVEL PRINT FOR LAYER/BATCH/ELEMENT SCALE FACTORS
      IF (ISSPRT.EQ.0) WRITE (NCWU,850) (A(I),I=1,NA)
cfeb08      WRITE (NCAWU,850) (A(I),I=1,NA)
      WRITE (CMON,850) (A(I),I=1,NA)
      CALL XPRVDU (NCVDU,1,0)
850   FORMAT (1X,5(2A4,F4.0,3X))
      GO TO 1000
900   CONTINUE
C -- MEDIUM/HIGH LEVEL PRINT FOR LAYER/BATCH/ELEMENT SCALE FACTORS
      IF (ISSPRT.EQ.0) WRITE (NCWU,950) (A(I),I=1,NA)
cfeb08      WRITE (NCAWU,950) (A(I),I=1,NA)
      WRITE (CMON,950) (A(I),I=1,NA)
      CALL XPRVDU (NCVDU,1,0)
950   FORMAT (1X,4(2A4,F4.0,1x,F8.3,1X))
      GO TO 1000
C
1000  CONTINUE
      NA=0
      RETURN
C
1050  CONTINUE
      CALL XOPMSG (IOPLSM,IOPINT,0)
      RETURN
      END
CODE FOR KMDMOV
      FUNCTION KMDMOV (NXTATM,JY,IMSG)
C
C -- PERFORM 'KEEP' AND 'MOVE' OPERATIONS FOR MODIFY
C
C      RETURN VALUES :-
C
C            -VE      ERROR
C            +VE      SUCCESS
C
C      PARAMETERS :-
C
C      NXTATM      ADDRESS AT WHICH NEXT ATOM IS TO BE STORED ( UPDATED
C                  BY THIS ROUTINE )
C      JY          INCREMENT FOR 'NKEEP'
C      IMSG        MESSAGE TYPE FOR 'XMDMON'
C
C      INTERNAL VARIABLES :-
C
C      ISEQ      INDICATES SEQUENCING STATE
C            -1      NO SERIAL NUMBER CHANGE
C             0      MANUAL SERIAL NUMBER CHANGE. EACH NEW NUMBER
C                    FOLLOWS THE ATOM SPEC.
C             1      AUTOMATIC SEQUENCING
C
C      IMOVE       USED TO INDICATE THE POSITION OF 'NXTATM' RELATIVE
C                  TO THE NEXT GROUP OF ATOMS TO BE MOVED.
C                    0           INSIDE GROUP. ATOMS NEED NOT BE MOVED
C                    1           AFTER GROUP
C                    2           BEFORE GROUP
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XMDCOM.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C -- ALLOCATE A BUFFER FOR MOVING ATOMS
      ITEMP=KSTALL(MD5)
C -- CHECK THERE ARE SOME ARGUMENTS
      IF (ME.LE.0) GO TO 350
C -- SET INITIAL VALUES OF VARIABLES
      ISEQ=-1
C
50    CONTINUE
C -- CHECK FOR A NUMBER WHICH INDICATES SEQUENCING
C^      IF ( KNUMBR ( SEQ ) .EQ. 0 ) ISEQ = 1
C -- THE NEXT ITEM MIGHT BE A SEQUENCE NUMBER.
C^      ISEQ = -1
C^      IF ( ME .LE. 0 ) GO TO 7750
      IF (KSYNUM(SEQ).NE.0) GO TO 100
      ME=ME-1
      MF=MF+LK2
      ISEQ=0
100   CONTINUE
C -- READ ATOMS. CHECK NO PARAMETERS.
      LN=0
      IF (KATOMU(LN).LE.0) GO TO 300
      IF (ISTORE(MQ+5).NE.0) GO TO 450
      ICHNG=ICHNG+1
C
C -- DETERMINE MOVE DIRECTION FOR ATOMS
C
      IENDMV=M5A+(N5A-1)*MD5A
      IF (NXTATM.GT.IENDMV) THEN
         IMOVE=1
         IMOVTO=NXTATM-MD5A
         INCREM=0
      ELSE IF (NXTATM.LT.M5A) THEN
         IMOVE=2
         IMOVTO=NXTATM
         INCREM=MD5A
      ELSE
         IMOVE=0
         IMOVTO=M5A
         NXTATM=M5A
         INCREM=MD5A
      END IF
C -- CHANGE THE LIST
C
      DO 200 I=1,N5A
C
C -- MOVE THE ATOM INTO WORK SPACE
         CALL XMOVE (STORE(M5A),STORE(ITEMP),MD5A)
C -- CHECK IF WE SHOULD CHANGE ITS SERIAL NUMBER
         IF (ISEQ.LT.0) GO TO 150
         STORE(ITEMP+1)=SEQ
         SEQ=SEQ+1.0
150      CONTINUE
C -- CHECK ADDRESS OF ATOM TO BE MOVED AND NEW ADDRESS
C
         IF (IMOVE.EQ.1) THEN
C -- MOVE ATOM AWAY FROM 'L5'. THIS IS NOT ALLOWED FOR 'KEEP'
            IF (JY.EQ.1) GO TO 550
C
            IFROM=M5A+MD5A
            ITO=M5A
            NMOVE=IMOVTO-M5A
C
            CALL XMOVE (STORE(IFROM),STORE(ITO),NMOVE)
         ELSE IF (IMOVE.EQ.2) THEN
C -- MOVE ATOM TOWARDS 'L5'
            IFROM=IMOVTO
            ITO=IMOVTO+MD5A
            NMOVE=M5A-IMOVTO
C
            CALL XMOVE (STORE(IFROM),STORE(ITO),NMOVE)
         END IF
C
C -- APPLY SYMMETRY WHILE MOVING ATOM BACK TO CORRECT POSITION
         IF (KATOMS(MQ,ITEMP,IMOVTO).LT.0) GO TO 300
C
C -- MONITOR ATOM
         CALL XMDMON (IMOVTO,MD5,1,1,1,IMSG,1,MONLVL,2,0,ISTORE(IMONBF))
C
C -- UPDATE ADDRESSES AND COUNTERS
         M5A=M5A+INCREM
         IMOVTO=IMOVTO+INCREM
         NXTATM=NXTATM+INCREM
C
         NKEEP=NKEEP+JY
C
200   CONTINUE
C
C--CHECK IF THERE ARE ANY MORE ARGUMENTS
      IF (KOP(8).GE.0) GO TO 50
C
C -- SUCCESSFUL COMPLETION
C
      KMDMOV=1
C
250   CONTINUE
      CALL XSTRLL (ITEMP)
      RETURN
C
300   CONTINUE
C -- ERRORS
      KMDMOV=-1
      GO TO 250
C
C
350   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,400)
cfeb08      WRITE (NCAWU,400)
      WRITE (CMON,400)
      CALL XPRVDU (NCVDU,1,0)
400   FORMAT (1X,'No arguments found')
      GO TO 300
450   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,500)
cfeb08      WRITE (NCAWU,500)
      WRITE (CMON,500)
      CALL XPRVDU (NCVDU,1,0)
500   FORMAT (1X,'Parameter specifications are illegal for this ','instr
     1uction')
      GO TO 300
550   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,600)
cfeb08      WRITE (NCAWU,600)
      WRITE (CMON,600)
      CALL XPRVDU (NCVDU,1,0)
600   FORMAT (1X,'An atom may not be KEPT more than once')
      GO TO 300
      END
CODE FOR KMDSRT
      FUNCTION KMDSRT (ISRT)
C
C -- IMPLEMENT 'SORT' DIRECTIVE FOR 'EDIT'
C
C      ISRT :  +1 FOR INCREASING SORT
C              -1 FOR DECREASING SORT
C
C      RETURN VALUES :-
C            -1      FAILURE DURING SORTING
C            +1      SUCCESS
C
C -- THE ROUTINE WORKS AS FOLLOWS :-
C
C  1)  THE INPUT DIRECTIVE IS SCANNED FOR DATA INDICATING ATOM TYPES.
C      IF AN ATOM TYPE IS FOUND, LIST 5 IS SEARCHED FOR ATOMS OF THAT
C      TYPE, AND THEIR ADDRESSES ARE STORED IN A VECTOR, USING 'XMDEXT'
C  2)  AFTER ALL TYPES SPECIFIED EXPLICITLY ON THE DIRECTIVE HAVE BEEN
C      PROCESSED, LIST 5 IS SCANNED AND ANY ATOM TYPES NOT YET PROCESS-
C      ED ARE FOUND. FOR EACH ATOM TYPE FOUND, THE ADDRESSES OF ALL
C      ATOMS OF THAT TYPE ARE STORED IN THE VECTOR, USING 'XMDEXT'
C      ( THIS LEADS TO THE DEFAULT ACTION, IF NO TYPES ARE SPECIFIED
C      EXPLICITLY, OF SORTING TYPES IN ORDER OF THEIR APPEARANCE IN
C      LIST 5 )
C  3)  THE DATA IS SORTED, USING THE ROUTINE 'XMDSRK', ON THE BASIS OF
C      THE SERIAL NUMBERS IN EACH SET OF ATOMS OF A SINGLE TYPE.
C  4)  LIST 5 IS REORDERED TO REFLECT THE RESULTS OF THE SORTING
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
C -- **** INITIALISATION SECTION ****
C
      IFOUND=KSTALL(N5)
      CALL XZEROF (ISTORE(IFOUND),N5)
C
      IADDRS=KSTALL(N5*1)
      CALL XZEROF (ISTORE(IADDRS),N5)
C----- SET DEFAULTS
      ISEROF=1
      JTYPE=-1
      MADDRS=IADDRS
      IBUFFR=KSTALL(MD5)
C
      M5=L5+(N5-1)*MD5
C
C
C -- **** FIND ATOMS OF EXPLICITLY SPECIFIED TYPES ****
C
50    CONTINUE
      IF (ME.LE.0) GO TO 100
      IF (ISTORE(MF).GE.0) GO TO 450
C
      ITYPE=ISTORE(MF+2)
C----- SEE IF THIS IS A PARAMETER NAME
      JTYPE=KCOMP(1,ITYPE,ICOORD,NKA,LKA)
      IF (JTYPE.EQ.-1) THEN
C-----       NOT PARAMETER NAME, SET TO 'SERIAL'
         ISEROF=1
      ELSE
         ISEROF=MIN0(JTYPE,NKA)-1
      END IF
      ME=ME-1
      MF=MF+LK2
C
      CALL XMDEXT (L5,M5,MD5,ITYPE,JTYPE,IFOUND,MADDRS)
C
      ISTAT=KOP(8)
      IF (ISTAT.GT.0) GO TO 50
C
C -- **** MOVE REMAINING ATOMS INTO BUFFER ****
C
100   CONTINUE
C
      MFOUND=IFOUND
      DO 150 I=L5,M5,MD5
         IF (ISTORE(MFOUND).LE.0) THEN
            CALL XMDEXT (I,M5,MD5,ISTORE(I),JTYPE,MFOUND,MADDRS)
         END IF
         MFOUND=MFOUND+1
150   CONTINUE
C
      MADDRS=MADDRS-1
C
C -- **** REORDER EACH SET OF ATOMS ****
C
      IFIRST=IADDRS
      IADDR=ISTORE(IFIRST)
      ILTYPE=ISTORE(IADDR)
C
      IADDR=ISTORE(IADDRS)
C----- CHECK IF SORTING BY GENERIC PARAMETER
      IF (JTYPE.EQ.-1) THEN
C
         DO 200 I=IADDRS,MADDRS
C
            IADDR=ISTORE(I)
C
            IF (ISTORE(IADDR).NE.ILTYPE) THEN
               NSORT=I-IFIRST
               IF (ISRT.GE.0) THEN
                  CALL XMDSRK (ISTORE(IFIRST),NSORT,ISEROF)
               ELSE
                  CALL XMDSRD (ISTORE(IFIRST),NSORT,ISEROF)
               END IF
C
               IFIRST=I
               ILTYPE=ISTORE(IADDR)
            END IF
C
200      CONTINUE
C
      END IF
C
      NSORT=MADDRS-IFIRST+1
      IF (ISRT.GE.0) THEN
         CALL XMDSRK (ISTORE(IFIRST),NSORT,ISEROF)
      ELSE
         CALL XMDSRD (ISTORE(IFIRST),NSORT,ISEROF)
      END IF
C
C -- **** SORT LIST 5 INTO NEW ORDER ****
C
      M5=L5
C
      DO 300 I=IADDRS,MADDRS
C
         IADDR=ISTORE(I)
C
         IF (IADDR.LT.M5) THEN
            GO TO 500
         ELSE IF (IADDR.EQ.M5) THEN
         ELSE
            CALL XMOVEI (ISTORE(M5),ISTORE(IBUFFR),MD5)
            CALL XMOVEI (ISTORE(IADDR),ISTORE(M5),MD5)
            CALL XMOVEI (ISTORE(IBUFFR),ISTORE(IADDR),MD5)
C
            DO 250 J=I+1,MADDRS
               IF (ISTORE(J).EQ.M5) ISTORE(J)=IADDR
250         CONTINUE
C
         END IF
         M5=M5+MD5
300   CONTINUE
C
      KMDSRT=1
C
350   CONTINUE
C
      CALL XSTRLL (IFOUND)
C
      RETURN
C
C
400   CONTINUE
      KMDSRT=-1
      GO TO 350
450   CONTINUE
      CALL XILOPD (ISTORE(MF+1))
      GO TO 400
500   CONTINUE
      CALL XOPMSG (IOPLSM,IOPINT,0)
      GO TO 400
C
C
      END
CODE FOR XMDEXT
      SUBROUTINE XMDEXT (LATOM,MATOM,MDATOM,ICOMP,JTYPE,LFOUND,MADDRS)
C
C -- FIND ATOMS IN LIST 5 CORRESPONDING TO THE SPECIFIED TYPE, AND
C    STORE THEIR ADDRESSES
C
C      LATOM,MATOM  START/END ADDRESS IN 'STORE' OF LIST 5 ( WHOLE
C                    OR PART )
C      MDATOM      WORDS PER ATOM IN LIST 5
C      ICOMP       'TYPE' TO BE SELECTED
C      LFOUND      ADDRESS IN 'ISTORE' OF VECTOR MARKING ATOMS ALREADY
C                    FOUND
C      MADDRS      ADDRESS IN 'ISTORE' OF LOCATION AT WHICH ADDRESS OF
C                    THE NEXT ATOM FOUND WILL BE STORED. THIS VALUE IS
C                    UPDATED BY THIS ROUTINE
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      MFOUND=LFOUND
C
      DO 50 I=LATOM,MATOM,MDATOM
C----- CHECK IF SORTING BY GENERIC PARAMETER OR SPECIFIED TYPE
         IF ((JTYPE.NE.-1).OR.(ISTORE(I).EQ.ICOMP)) THEN
            IF (ISTORE(MFOUND).GT.0) GO TO 100
C
            ISTORE(MADDRS)=I
            MADDRS=MADDRS+1
C
            ISTORE(MFOUND)=1
         END IF
         MFOUND=MFOUND+1
50    CONTINUE
C
      RETURN
C
C
100   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,150) ICOMP
cfeb08      WRITE (NCAWU,150) ICOMP
      WRITE (CMON,150) ICOMP
      CALL XPRVDU (NCVDU,1,0)
150   FORMAT (1X,'Type ',A4,' has been repeated')
      CALL XERHND (IERWRN)
      RETURN
      END
CODE FOR XMDSRK
      SUBROUTINE XMDSRK (ITAG,NTAG,IOFFST)
C
C -- SORT THE ADDRESSES OF VARIOUS ATOMS IN LIST 5 ACCORDING TO THE
C    VALUE OF SOME PARAMETER. THE ATOMS WILL BE SORTED INTO ASCENDING
C    ORDER
C
C      ITAG(NTAG)  ARRAY CONTAINING THE ADDRESSES TO BE SORTED
C      IOFFST      ADDRESS RELATIVE TO ADDRESS FROM 'ITAG' OF VALUE
C                    ON WHICH ITEMS ARE TO BE SORTED. ( E.G. FOR
C                    SORTING ON SERIAL NUMBER, IOFFST = 1. THE ADDRESS
C                    OF EACH ATOM IN LIST 5 POINTS TO ITS TYPE )
C
C -- THIS ROUTINE USES A SHUTTLE SORT. EACH ITEM IS COMPARED WITH THE
C    PRECEDING ONE. IF IT IS LESS, THEY ARE EXCHANGED AND A NEW COMPAR-
C    ISON IS MADE WITH THE NEW PREDECESSOR. WHEN EACH ITEM HAS BE
C    TREATED IN THIS WAY, THE SORT IS FINISHED
C
C
      DIMENSION ITAG(NTAG)
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
      DO 100 I=1,NTAG
C
         IPOS=I
C
50       CONTINUE
         IF (IPOS.GT.1) THEN
            IADDR=ITAG(IPOS)
            IPADDR=ITAG(IPOS-1)
            IF (STORE(IADDR+IOFFST).LT.STORE(IPADDR+IOFFST)) THEN
               ISAVE=ITAG(IPOS-1)
               ITAG(IPOS-1)=ITAG(IPOS)
               ITAG(IPOS)=ISAVE
               IPOS=IPOS-1
               GO TO 50
            END IF
         END IF
C
100   CONTINUE
C
C
      RETURN
      END
CODE FOR XMDSRD
      SUBROUTINE XMDSRD (ITAG,NTAG,IOFFST)
C
C -- SORT THE ADDRESSES OF VARIOUS ATOMS IN LIST 5 ACCORDING TO THE
C    VALUE OF SOME PARAMETER. THE ATOMS WILL BE SORTED INTO DESCENDING
C    ORDER
C
C      ITAG(NTAG)  ARRAY CONTAINING THE ADDRESSES TO BE SORTED
C      IOFFST      ADDRESS RELATIVE TO ADDRESS FROM 'ITAG' OF VALUE
C                    ON WHICH ITEMS ARE TO BE SORTED. ( E.G. FOR
C                    SORTING ON SERIAL NUMBER, IOFFST = 1. THE ADDRESS
C                    OF EACH ATOM IN LIST 5 POINTS TO ITS TYPE )
C
C -- THIS ROUTINE USES A SHUTTLE SORT. EACH ITEM IS COMPARED WITH THE
C    PRECEDING ONE. IF IT IS MORE, THEY ARE EXCHANGED AND A NEW COMPAR-
C    ISON IS MADE WITH THE NEW PREDECESSOR. WHEN EACH ITEM HAS BE
C    TREATED IN THIS WAY, THE SORT IS FINISHED
C
C
      DIMENSION ITAG(NTAG)
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
      DO 100 I=1,NTAG
C
         IPOS=I
C
50       CONTINUE
         IF (IPOS.GT.1) THEN
            IADDR=ITAG(IPOS)
            IPADDR=ITAG(IPOS-1)
            IF (STORE(IADDR+IOFFST).GT.STORE(IPADDR+IOFFST)) THEN
               ISAVE=ITAG(IPOS-1)
               ITAG(IPOS-1)=ITAG(IPOS)
               ITAG(IPOS)=ISAVE
               IPOS=IPOS-1
               GO TO 50
            END IF
         END IF
C
100   CONTINUE
C
C
      RETURN
      END
CODE FOR KMDINS
      FUNCTION KMDINS (KEY)
C
C----- INSERT AN ITEM FROM LIST 3 OR LIST 29 INTO THE 'SPARE' SLOT
C
C----- KEY3 MAXIMUM VALUE FOR 'KEY' TO BE LOOKED FOR IN LIST3
C      NKEY MAXIMUM NUMBER OF KEYS
C      KEY   1 GET Z FROM LIST3
C            2     ATOMIC WEIGHT FROM LIST 29
C
      PARAMETER (KEY3=1,NKEY=2)
C----- KVAL, THE OFFSET IN THE APPROPRIATE LIST OF THE REQUIRED KEY
      DIMENSION KVAL(NKEY)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XMDCOM.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'QSTORE.INC'
      DATA KVAL/1,6/
C
      KMDINS=-1
      IF (KEY.LE.KEY3) THEN
C-----  SET LIST 3 ADDRESSES
         IF (KHUNTR(3,0,I,K,J,-1).GE.0) THEN
            KMDINS=1
            LINS=L3
            MDINS=MD3
            NINS=N3
         END IF
      ELSE
C-----  SET LIST 29 ADDRESSES
         IF (KHUNTR(29,0,I,K,J,-1).GE.0) THEN
            KMDINS=1
            LINS=L29
            MDINS=MD29
            NINS=N29
         END IF
      END IF
      IF (KMDINS.LT.0) RETURN
C      LIST 5 OF CORRECT LENGTH?
      IF (MD5.GE.14) KMDINS=1
C----- LIST DOESNT EXIST OR LIST 5 TOO SHORT
      IF (KMDINS.LT.0) RETURN
C----- SET OFFSET FOR REQUIRED DATA
      KEYO=KVAL(KEY)
      M5=L5
      DO 150 I=1,N5
         MINS=LINS
         DO 50 J=1,NINS
            IF (ISTORE(M5).EQ.ISTORE(MINS)) THEN
               IF (KEY.EQ.1) THEN
C                 SPECIAL CASE, SUM OF FORMFACTOR F', A AND C TERMS
                  STORE(M5+13)=STORE(MINS+KEYO)+STORE(MINS+KEYO+2)+
     1             STORE(MINS+KEYO+4)+STORE(MINS+KEYO+6)+STORE(MINS+
     2             KEYO+8)+STORE(MINS+KEYO+10)
               ELSE
                  CALL XMOVE (STORE(MINS+KEYO),STORE(M5+13),1)
               END IF
               GO TO 100
            END IF
            MINS=MINS+MDINS
50       CONTINUE
         STORE(M5+13)=0.0
100      CONTINUE
         M5=M5+MD5
150   CONTINUE
      ICHNG=ICHNG+1
      CALL XMDMON (L5,MD5,N5,3,1,1,1,MONLVL,2,1,ISTORE(IMONBF))
      RETURN
      END

CODE FOR PRTB12
      SUBROUTINE PRTB12
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XOPK.INC'
      INCLUDE 'XSCALE.INC'
      DIMENSION SHF(23)
      INCLUDE 'ICOM12.INC'
C
      INCLUDE 'QSTORE.INC'
C

C--SET THE TIMING
      CALL XTIME1 (2)
C--READ THE REMAINING DATA
      IF (KRDDPV(ISTORE(NFL),24).LT.0) GO TO 550
      CALL XMOVE(STORE(NFL),SHF(1),23)
C The 23rd position of SHF is the multiplier, multiply it onto the shifts.
      DO I = 1,22
         SHF(I) = SHF(I) * SHF(23)
      END DO

      IOWL5 = ISTORE(NFL+23)

C--CLEAR THE STORE
      CALL XCSAE
      CALL XRSL
C--LOAD THE LISTS
      CALL XFAL01
      CALL XFAL02
      CALL XFAL05
c      LA=5
c      CALL XLDRO5 (LA)
C Form the relative list 12
      JQ=2
      JS=1
      CALL XFAL12(JS,JQ,JR,JN)

      IDX12 = KSTALL(N12)      
      DO I = 0,N12
        STORE(IDX12+I)=-1000000
      END DO

      M5 = L5 - MD5
      M12 = L12O
      L12A = NOWT
      JS = 0
      DO WHILE ( M12 .GT. 0 )
        IF ( ISTORE(M12+1) .GT. 0 ) THEN
          L12A=ISTORE(M12+1)
          DO WHILE ( L12A .GE. 0 )
            IF ( ISTORE(L12A+3).GE.0 ) THEN
              MD12A=ISTORE(L12A+1)
              JU=ISTORE(L12A+2)
              JV=ISTORE(L12A+3)
              JS=ISTORE(L12A+4)
C-- Scan through this part
              INLOOP: DO JW=JU,JV,MD12A
                JS=JS+1
                JT = ISTORE(JW)     !Parameter number
                IF ( JT .LE. 0 ) CYCLE

                M5G = 0
                IF ( M12 .EQ. L12O ) THEN                 !Overall parameter
                     M5G = L5O
                ELSE IF (M12 .EQ. L12LS) THEN             !LAYER SCALE
                     M5G = L5LS
                ELSE IF (M12 .EQ. L12ES) THEN             !ELEMENT SCALES
                     M5G = L5ES
                ELSE IF (M12 .EQ. L12BS) THEN             !BATCH SCALE
                     M5G = L5BS                           
                ELSE IF (M12 .EQ. L12CL) THEN             !CELL PARAM
                     M5G = L5CL
                ELSE IF (M12 .EQ. L12PR) THEN             !PROFILE PARAM
                     M5G = L5PR
                ELSE IF (M12 .EQ. L12EX) THEN             !EXTINCTION PARAM
                     M5G = L5EX
                ENDIF

                IF ( M5G .GT. 0 ) THEN
C The shift is given as a fraction of the scale factors.
                   Z = XRAND( (SHF(1)*STORE(M5G-1+JS))**2, 0 )
                   Z = SIGN(1.0,Z) * SQRT( ABS(Z) ) ! Convert to ESD
                   STORE(IDX12+JT-1) = Z

                   WRITE(CMON,2750)'Scale ',JT,JS,(KVP(JRR,JS),JRR=1,2),
     1             STORE(M5G),STORE(M5G-1+JS)
2750               FORMAT(1X,A6,I5,I12,26X,2A4,2F12.7)
                   CALL XPRVDU(NCVDU,1,0)
                   CYCLE
                END IF


C Assume it's an atom
               WEIGHT = 1.0
               IF ( JS .EQ. 3 ) THEN                  !Occupancy
                  Z = XRAND( SHF(2)**2, 0 )
                  Z = SIGN(1.0,Z) * SQRT( ABS(Z) )
               ELSE IF ( ( JS .GE. 5 ) .AND. ( JS .LE. 7 ) ) THEN !Coords
                  Z = XRAND( SHF(JS-2)**2, 0 )
                  Z = SIGN(1.0,Z) * SQRT( ABS(Z) ) 
                  Z=Z/STORE(L1P1+JS-5)
               ELSE IF ( (NINT(STORE(M5+3)) .EQ. 0) .AND.
     1                   (JS.GE.8) .AND. (JS.LE.13)) THEN   ! Anisotropic atom
C The shift is given as a fraction of the temperature factors.
                  Z = XRAND( (SHF(JS-2)*STORE(M5-1+JS))**2, 0 )
                  Z = SIGN(1.0,Z) * SQRT( ABS(Z) )
               ELSE IF ( (NINT(STORE(M5+3)) .EQ. 1) .AND.
     1                                   (JS.EQ.8)) THEN    ! Isotropic atom
C The shift is given as a fraction of the temperature factors.
                  Z = XRAND( (SHF(12)*STORE(M5+7))**2, 0 )
                  Z = SIGN(1.0,Z) * SQRT( ABS(Z) )
               ELSE IF ( (NINT(STORE(M5+3)) .EQ. 2) .AND.
     1                   (JS.GE.8) .AND. (JS.LE.9)) THEN    ! Shell
                  IF ( JS.EQ.8 ) WEIGHT = STORE(M5+7)
C The shift is given as a fraction of the temperature factors.
                  Z = XRAND( (SHF(JS+5)*WEIGHT)**2, 0 )
                  Z = SIGN(1.0,Z) * SQRT( ABS(Z) )
               ELSE IF ( (NINT(STORE(M5+3)) .EQ. 3) .AND.
     1                   (JS.GE.8) .AND. (JS.LE.11)) THEN   ! Line
                  IF ( JS.EQ.8 ) WEIGHT = STORE(M5+7)
C The shift is given as a fraction of the temperature factors.
                  Z = XRAND( (SHF(JS+7)*WEIGHT)**2, 0 )
                  Z = SIGN(1.0,Z) * SQRT( ABS(Z) )
               ELSE IF ( (NINT(STORE(M5+3)) .EQ. 4) .AND.
     1                   (JS.GE.8) .AND. (JS.LE.11)) THEN   ! Annulus
                  IF ( JS.EQ.8 ) WEIGHT = STORE(M5+7)
C The shift is given as a fraction of the temperature factors.
                  Z = XRAND( (SHF(JS+11)*WEIGHT)**2, 0 )
                  Z = SIGN(1.0,Z) * SQRT( ABS(Z) )
               ELSE
                  Z = 0
                  STORE(IDX12+JT-1) = Z
                  WRITE(CMON,'(A,3I7)')'Odd parameter: ',JT,JS,M12
                  CALL XPRVDU(NCVDU,1,0)
                  CYCLE
               END IF

               STORE(IDX12+JT-1) = Z
3050  FORMAT(1X,A6,I5,I12,8X,A4,I4,1X,F12.5,1X,3A4)
               IF((STORE(M5+3) .GE. 1.0) .AND. (JS .GE. 8)) THEN
                 WRITE(CMON,3050)'Iso   ',JT,JS,STORE(M5),
     2           NINT(STORE(M5+1)),Z,(ICOORD(JRR,JS+NKAO),JRR=1,NWKA)
               ELSE
                 WRITE(CMON,3050)'Aniso ',JT,JS,STORE(M5),
     2           NINT(STORE(M5+1)),Z,(ICOORD(JRR,JS),JRR=1,NWKA)
               ENDIF
               CALL XPRVDU(NCVDU,1,0)

              END DO INLOOP
            END IF
            L12A=ISTORE(L12A)
          END DO 

        END IF

        M5=M5+MD5
        M12=ISTORE(M12)
      END DO 

C Loop again, this time - apply the shifts from the IDX12 vector.

      M5 = L5 - MD5
      M12 = L12O
      L12A = NOWT
      JS = 0
      DO WHILE ( M12 .GT. 0 )
        IF ( ISTORE(M12+1) .GT. 0 ) THEN
          L12A=ISTORE(M12+1)
          DO WHILE ( L12A .GE. 0 )
            IF ( ISTORE(L12A+3).GE.0 ) THEN
              MD12A=ISTORE(L12A+1)
              JU=ISTORE(L12A+2)
              JV=ISTORE(L12A+3)
              JS=ISTORE(L12A+4)
C-- Scan through this part
              DO JW=JU,JV,MD12A
                JS=JS+1
                JT = ISTORE(JW)     !Parameter number
                IF ( JT .LE. 0 ) CYCLE

                IF ( MD12A .GT. 1 ) THEN
                  WEIGHT = STORE(JW+1)
                ELSE
                  WEIGHT = 1.0
                END IF

                M5G = 0
                IF ( M12 .EQ. L12O ) THEN                 !Overall parameter
                     M5G = L5O
                ELSE IF (M12 .EQ. L12LS) THEN             !LAYER SCALE
                     M5G = L5LS
                ELSE IF (M12 .EQ. L12ES) THEN             !ELEMENT SCALES
                     M5G = L5ES
                ELSE IF (M12 .EQ. L12BS) THEN             !BATCH SCALE
                     M5G = L5BS                           
                ELSE IF (M12 .EQ. L12CL) THEN             !CELL PARAM
                     M5G = L5CL
                ELSE IF (M12 .EQ. L12PR) THEN             !PROFILE PARAM
                     M5G = L5PR
                ELSE IF (M12 .EQ. L12EX) THEN             !EXTINCTION PARAM
                     M5G = L5EX
                ENDIF
                IF ( M5G .GT. 0 ) THEN
                   STORE(M5G-1+JS) = STORE(M5G-1+JS)+STORE(IDX12+JT-1)
                   CYCLE
                END IF
C Assume it's an atom
                Z=STORE(M5-1+JS)
                STORE(M5-1+JS) = STORE(M5-1+JS)+WEIGHT*STORE(IDX12+JT-1)

                WRITE(CMON,'(A,3F15.8)') 'Rand, weight, shift:',
     1          STORE(IDX12+JT-1), WEIGHT, STORE(IDX12+JT-1)*WEIGHT
                CALL XPRVDU(NCVDU,1,0)

                IF((STORE(M5+3) .GE. 1.0) .AND. (JS .GE. 8)) THEN
                 WRITE(CMON,3050)'Iso   ',JT,JS,STORE(M5),
     2           NINT(STORE(M5+1)),Z,(ICOORD(JRR,JS+NKAO),JRR=1,NWKA)
                ELSE
                 WRITE(CMON,3050)'Aniso ',JT,JS,STORE(M5),
     2           NINT(STORE(M5+1)),Z,(ICOORD(JRR,JS),JRR=1,NWKA)
                ENDIF
                CALL XPRVDU(NCVDU,1,0)
              END DO
            END IF
            L12A=ISTORE(L12A)
          END DO 
        END IF
        M5=M5+MD5
        M12=ISTORE(M12)
      END DO 

      CALL XSTR05 (5,IOWL5,-1)

C--FINAL TERMINATION MESSAGES
450   CONTINUE
      CALL XOPMSG (IOPTFC,IOPEND,410)
      CALL XTIME2 (2)
      RETURN
C
500   CONTINUE
      CALL XOPMSG (IOPTFC,IOPABN,0)
      GO TO 450
550   CONTINUE
C -- COMMAND INPUT ERRORS
      CALL XOPMSG (IOPTFC,IOPCMI,0)
      GO TO 500
      END

CODE FOR XORIGIN
      SUBROUTINE XORIGIN
C-- sHIFT ORIGIN TOWARDS CENTRE OF CELL
C -- DIRECT METHODS IN CRYSTALLOGRAPHY,
C    GIACOVAZZO, 1980, ACADEMIN PRESS
C
C      FOR THE MOMENT ONLY WORKS UP TO PRIMITIVE ORTHORHOMBIC
C      USING LOOK-UP TABLES. 
C
C      IORI No of floating origins
C      IFLOR(3) Floating origins (1 if yes) - in XSPECC.INC
C      ICENTR -1 FOR NON CENTRO
C      LATTYP Lattice type - 1 is P etc
C      CCLASS Crystal class

C
C--
      CHARACTER*32 OPERAT
      CHARACTER*16 LATTIC(7)
      CHARACTER *5 CNOT
      CHARACTER *2 CNO
      CHARACTER *4 CCLASS, CMIX
      CHARACTER *80 CLINE, CLOW
      DIMENSION COFG(3), CSHIFT(3), COFGB(3)
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XSPECC.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XOPVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA LATTIC / 'primitive' , 'body centered' , 'rhombohedral' ,
     2 'face centered' , 'A centered' , 'B centered' , 'C centered' /
      DATA CNOT / ' non-' /, CNO / 'no' /
C
C
C--SET THE TIMING
      CALL XTIME1 (2)
C--READ THE REMAINING DATA
      IF (KRDDPV(ISTORE(NFL),3).LT.0) GO TO 550
      IULN=KTYP05(ISTORE(NFL))
      LNOUT=KTYP05(ISTORE(NFL+1))
      MODE =ISTORE(NFL+2)
C--CLEAR THE STORE
      CALL XCSAE
      CALL XRSL
C--LOAD THE LISTS
      CALL XFAL01
      CALL XFAL02
      CALL XLDR05 (IULN)
      IF (IERFLG.LT.0) GO TO 500
C
C----- FIND FLOATING ORIGINS
      IORI = -1
      IF ((KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .GE. 0) .AND.
     1    (KHUNTR ( 2,0, IADDL,IADDR,IADDD, -1) .GE. 0) .AND.
     2    (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .GE. 0)) THEN
            IORI = KSPINI( -1, .06)
            IF (IORI .GE. 0) CALL XFLORG( N2, 0, IORI)
C -- GET CENTRO AND LATTICE TYPE FLAGS
C
            ICENTR = NINT ( STORE(L2C) )
            LATTYP = NINT ( STORE(L2C+1) )
            WRITE(CMIX,'(A4)') ISTORE(L2CC)
      ELSE
            WRITE(CMON,'(A)') ' List 1,2 or 5 missing'
            CALL XPRVDU(NCVDU, 1,0)
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
            GOTO 450
      ENDIF
C
C---- CHECK CLASS
      CALL XCCUPC(CMIX, CCLASS)
      ICLASS = 0
      IF (CCLASS .EQ. 'TRIC') THEN
            ICLASS = 1
      ELSE IF (CCLASS .EQ. 'MONO') THEN
            ICLASS = 2
      ELSE IF (CCLASS .EQ. 'ORTH') THEN
            ICLASS = 3
      ELSE
            WRITE(CMON,'(A)') ' This SG not yet handled'
            CALL XPRVDU(NCVDU, 1,0)
            IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
C----- DISPLAY CRYSTAL CLASS
            CLOW = ' '
            WRITE(CLOW,2200) (ISTORE(I), I = L2CC, L2CC+MD2CC-1)
2200        FORMAT('Crystal class is ', 1X, 4(A4))
            CALL XCTRIM (CLOW, ILAST)
            IF (ISSPRT .EQ. 0) WRITE(NCWU,2201) CLOW(1:ILAST)
            WRITE ( CMON, 2201) CLOW(1:ILAST)
            CALL XPRVDU(NCVDU, 1,0)
2201        FORMAT(1X,A)
            GOTO 450
      ENDIF
C
      WRITE ( CLINE , 1025 ) LATTIC(LATTYP)
1025  FORMAT ('The lattice type is : ' , A )
      WRITE ( CLINE(40:) , 1035 ) N2
1035  FORMAT ('with ' , I3 , ' unique symmetry operators' )
      CALL XCTRIM (CLINE, ILAST)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,2201) CLINE(1:ILAST)
      WRITE ( CMON, 2201) CLINE(1:ILAST)
      CALL XPRVDU(NCVDU, 1,0)
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
C---- CHECK IF PRIMITIVE 
      IF (LATTYP .NE. 1) THEN
       WRITE(CMON,'(A)') 'Only available for primitive Space Groups'
       CALL XPRVDU(NCVDU, 1,0)
       GOTO 450
      ENDIF
C
      CALL XZEROF(COFG,3)
      CALL XZEROF(CSHIFT,3)
      IF (MODE .EQ. 0) THEN
C----- USE CENTRE OF GRAVITY
            M5=L5+(N5-1)*MD5
            MEAN: DO  I=L5,M5,MD5
             COFG(1) = COFG(1) + STORE(I+4)
             COFG(2) = COFG(2) + STORE(I+5)
             COFG(3) = COFG(3) + STORE(I+6)
            ENDDO MEAN
            COFG(1) = COFG(1)/FLOAT(N5)
            COFG(2) = COFG(2)/FLOAT(N5)
            COFG(3) = COFG(3)/FLOAT(N5)
      ELSE
C----- USE FIRST ATOM
            COFG(1) = STORE(L5+4)
            COFG(2) = STORE(L5+5)
            COFG(3) = STORE(L5+6)
      ENDIF
C
      CALL XMOVE(COFG,COFGB,3)
C
c-- look for case where molecule is miles outside of cell
c
      WRITE(CMON,'(a,6F8.3)')'Old centre ', 
     1 (COFG(I),I=1,3)
      CALL XPRVDU(NCVDU, 1,0)
c
      DO I = 1,3
        K = INT(COFG(I))
        l = k
        if (COFG(I) .lt. 0) l = k - 1
        CSHIFT(I) = CSHIFT(I) - FLOAT(l)
        COFG(I) = COFG(I) + CSHIFT(I)
      ENDDO
C
C
      IF (ICENTR .GT. 0) THEN
C      CENTRIC - ALL 8 ORIGINS PERMITTED
       SHIFTA: DO I=1,3
        IF (COFG(I) .LT. 0.25) THEN
         CSHIFT(I) = .5 + CSHIFT(I)
        ELSE IF (COFG(I) .GT. 0.75) THEN
         CSHIFT(I) = -0.5  + CSHIFT(I)
        ENDIF
       ENDDO SHIFTA
      ELSE
C     NON-CENTRIC
       IF (ICLASS .EQ. 1) THEN
C            TRICLINIC - ALL ORIGINS FLOAT
      WRITE(CMON,'(A)')'Triclinic'
      call xprvdu(ncvdu,1,0)
             CSHIFT(1) = 0.5 - COFG(1) + CSHIFT(I)
             CSHIFT(2) = 0.5 - COFG(2) + CSHIFT(I)
             CSHIFT(3) = 0.5 - COFG(3) + CSHIFT(I)
       ELSE IF ((ICLASS .EQ. 2) .OR.
     1          (ICLASS .EQ. 3)) THEN
C            MONOCLINIC OR ORTHORHOMBIC
      WRITE(CMON,'(A)')'Monoclinic/Orthorhombic'
      call xprvdu(ncvdu,1,0)
             SHIFTB: DO I=1,3
              IF (IFLOR(I) .EQ. 1) THEN
               CSHIFT(I) = 0.5 - COFG(I) + CSHIFT(I)
              ELSE
               IF (COFG(I) .LT. 0.25) THEN
                CSHIFT(I) = .5 + CSHIFT(I)
               ELSE IF (COFG(I) .GT. 0.75) THEN
                CSHIFT(I) = -0.5 + CSHIFT(I)
               ENDIF
              ENDIF
             ENDDO SHIFTB
       ENDIF
      ENDIF
C
      WRITE(CMON,'(a,6F8.3)')' Shift     ',
     1 (CSHIFT(I),I=1,3)
      CALL XPRVDU(NCVDU, 1,0)
      WRITE(CMON,'(a,6F8.3)')'New centre ', 
     1 (COFGB(I)+CSHIFT(I),I=1,3)
      CALL XPRVDU(NCVDU, 1,0)

      M5=L5
      SHIFTC: DO  I=1,N5
            STORE(M5+4) = STORE(M5+4) + CSHIFT(1)
            STORE(M5+5) = STORE(M5+5) + CSHIFT(2)
            STORE(M5+6) = STORE(M5+6) + CSHIFT(3)
            M5 = M5+MD5
      ENDDO SHIFTC



      NEW=-1
      IF (IULN-LNOUT) 350,400,350
350   CONTINUE
      NEW=1
400   CONTINUE
      CALL XSTR05 (LNOUT,0,NEW)
C--FINAL TERMINATION MESSAGES
450   CONTINUE
      CALL XOPMSG (IOPTFC,IOPEND,410)
      CALL XTIME2 (2)
      RETURN
C
500   CONTINUE
      CALL XOPMSG (IOPTFC,IOPABN,0)
      GO TO 450
550   CONTINUE
C -- COMMAND INPUT ERRORS
      CALL XOPMSG (IOPTFC,IOPCMI,0)
      GO TO 500
      END
