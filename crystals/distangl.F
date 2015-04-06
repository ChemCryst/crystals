C $Log: not supported by cvs2svn $
C Revision 1.110  2013/05/09 11:24:37  rich
C Fix bounds overrun in distangl when called from Fourier routines (shorter stack).
C
C Revision 1.109  2013/03/21 10:26:57  rich
C When outputing lists of RIDE instructions don't duplicate atoms.
C
C Revision 1.108  2012/07/11 13:49:08  djw
C Include the use of the RESIDUE flag when deciding if a bond is inter/intra when the flag is not zero
C
C Revision 1.107  2012/03/23 13:48:47  rich
C Avoid double UpdateL41 message. Set uninit variable.
C
C Revision 1.106  2011/07/27 12:02:46  djw
C Add a comment about NWS
C
C Revision 1.105  2011/04/21 11:18:49  rich
C Fix perhydro of disordered parts
C
C Revision 1.104  2011/04/08 12:56:30  djw
C Add new alternative 'Mode = ATOM'
C
C Revision 1.103  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.102  2011/03/04 05:49:49  rich
C Ensure proper closing of properties file in bond calculation routine.
C
C Revision 1.101  2011/02/04 17:34:03  djw
C Extend parameter list on PRTGRP to enable selection by RESIDUE
C
C Revision 1.100  2010/07/16 11:35:31  djw
C Enable XPCHLX to output lists 12 and 16 to the cif file.  This means carrying the I/O chanel (as NODEV)
C in XPCHLX,XPCHLH,PPCHND and XPCHUS.
C Fixed oversight in distangle for esds of H-bonds
C
C Revision 1.99  2010/07/13 14:12:04  djw
C Remove debugging print
C
C Revision 1.98  2010/04/19 16:03:22  djw
C Only print bond breaking messages in debug mode
C
C Revision 1.97  2010/01/05 14:45:14  djw
C Fix silly wrror in NWDT and NWAT
C
C Revision 1.96  2009/12/24 09:56:40  djw
C Remove diagnostic printdistangl.fpp
C
C Revision 1.95  2009/12/23 08:24:43  djw
C Add more comments to esd calculation
C
C Revision 1.94  2008/12/15 14:57:44  djw
C Move List 11 error messages into XFAL11 itself
C
C Revision 1.93  2009/07/31 12:41:20  djw
C Add a switch to SEQUENCE so that H atoms are not changed
C
C Revision 1.92  2009/05/06 13:02:13  djw
C When generating RIDE cards, fix (some) treatment of H atoms related by symmetry
C
C Revision 1.91  2009/02/09 08:04:08  djw
C Restore resetting oh L29 addresses, fouled up at version 1.88, when tried to inhibit updating of L41 when there was only one atom.
C
C Revision 1.90  2008/12/18 16:32:18  djw
C Remove test for less than 2 atoms - it causes looping in creaton of list 41
C
C Revision 1.89  2008/11/28 14:45:24  djw
C Remove planrity restraint from some N-H restraints
C
C Revision 1.88  2008/11/07 08:41:17  djw
C Dont try to update L41 if there is only one atom
C
C Revision 1.87  2008/10/14 16:13:07  djw
C Restore Richards END-DOs
C
C Revision 1.86  2008/10/01 11:11:54  djw
C Support for treatment of Deuterium as hydrogen
C
C Revision 1.85  2008/02/14 11:03:21  djw
C Remove bond update diagnostics
C
C Revision 1.84  2008/02/12 09:01:16  djw
C Matrix work diagnostics
C
C Revision 1.83  2007/12/14 16:39:57  djw
C Add more comments
C
C Revision 1.82  2007/03/20 15:39:21  djw
C Filter out improbable H-bonds
C
C Revision 1.81  2007/03/13 18:26:15  djw
C Bug in H-bond generation
C
C Revision 1.80  2007/02/22 10:51:42  djw
C Bugfix in sorting out unique H atoms
C
C Revision 1.79  2006/11/30 08:34:13  djw
C Remove h-bonds if D-H .gt. 1.2
C
C Revision 1.78  2006/11/24 18:04:52  djw
C Improve layout of low level listing so that it can be pulled into Excel
C
C Revision 1.77  2006/09/22 08:17:54  djw
C Fix multiple reference to same H on RIDE command
C
C Revision 1.76  2005/10/13 15:48:32  stefan
C 1. Increased the length of the file names allowed in XBCALC from 80 to 255.
C
C Revision 1.75  2005/06/28 13:00:22  djw
C Correct multiplier for Uequiv in H restraints
C
C Revision 1.74  2005/05/24 16:41:17  djw
C Move info text from CMON to NCWU
C
C Revision 1.73  2005/05/18 14:53:33  djw
C Move a few writes to CMON to the printer during the formation of L41
C
C Revision 1.72  2005/02/25 17:25:20  stefan
C 1. Added some preprocessor if defined lines for the mac version.
C
C Revision 1.71  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.3  2005/01/17 14:11:07  rich
C Bring new repository into line up-to-date with old. (Better error messages).
C
C Revision 1.2  2004/12/13 16:16:07  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:10  rich
C New CRYSTALS repository
C
C Revision 1.69  2004/11/17 08:53:39  djw
C Spot NH4 and CH4 for H restraints
C
C Revision 1.68  2004/11/10 16:43:54  djw
C Include N-H and O-H restraint generator
C
C Revision 1.67  2004/09/28 10:36:52  rich
C Move some boring messages to the listing file.
C
C Revision 1.66  2004/08/17 15:56:47  djw
C Append H bonds to cif
C
C Revision 1.64  2004/06/01 08:01:57  rich
C Remove all writes to NCAWU
C
C Revision 1.63  2004/02/02 14:41:00  rich
C Change Mogul syntax slightly.
C Fix bug in L41 which missed symmetry related bonds in one
C direction where the only operation was a cell translation.
C E.g. Ga(1)-O(1,1,1,1,1,1) would show up, but O(1)-Ga(1,1,-1,-1,-1) would
C not.
C
C Revision 1.62  2003/12/11 13:32:44  rich
C KDIST4: Loop backwards through L41 (which is constructed upside-down in
C the first place) so that SEL RAN=L41 doesn't have (much) effect on the
C order of distances output.
C
C Revision 1.61  2003/12/03 08:24:58  djw
C Change VIB to REST for hydrogen U[iso] restraints.  Enables a scale factor to be used
C
C Revision 1.60  2003/11/24 12:51:40  rich
C If a directive name is not defined uniquely on input the command
C common block is emptied. This caused a crash when the instruction
C was completed as it tried to load list 5 type 0. Fixed.
C
C Revision 1.59  2003/11/06 15:48:01  rich
C Improved part numbering rules. The group bit of the number (digits > 1000)
C should now be called the assembly number. The number may now be negative,
C the -ve sign is given to the part digits (<999) and these atoms are not
C allowed to form bonds to the same part using symmetry operators. Useful
C for assemblies disordered across a sym op.
C
C Revision 1.58  2003/10/31 12:42:18  rich
C If BONDTYPE is set to OFF, remove list of special bonds from list 41
C (L41S), since this bit is only ever changed by the BONDTY routine.
C If bond type in L41 is zero, display 'unassigned' on model, rather
C than memory access violation.
C
C Revision 1.57  2003/10/30 13:36:07  djw
C Output H-restraints and atom list from DISTANCES
C
C Revision 1.56  2003/10/23 08:23:26  rich
C Load list 1 and 2 early, in case using L41.
C
C Revision 1.55  2003/08/13 12:29:38  rich
C Mogul punch requires a list 41 before it is generally loaded (to grow
C the fragment by symmetry). Load it.
C
C Revision 1.54  2003/08/12 19:14:05  rich
C KDIST4: SEL RAN=L41 - recompute distance, don't rely on stored value.
C
C Revision 1.53  2003/08/05 11:11:10  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.52  2003/07/16 16:02:58  rich
C Added code to \REGROUP, so that if the MOVE parameter is -ve, then
C a covalent radius vector is provided to KDIST1, and the absolute
C value of MOVE is used as a TOLERANCE, such that bonds are formed
C if D < COV1+COV2+TOLERANCE.
C
C Revision 1.51  2003/07/09 17:02:20  rich
C Problem: New CIF script includes cell esd's in distance calculation, this
C makes C-H distances for riding H's have a non-zero esd. (Correctly, I might
C add). However checkcif cares not for this number, so we must detect riding
C H's and explicitly set the bond esd to zero after it is computed. Needless
C to say, this only happens if you explicitly set the \DIST HESD parameter to
C 'NONFIXED' which you're not likely to do by accident. The only place that
C does this is the XCIF script.
C
C Revision 1.50  2003/07/01 16:43:34  rich
C Change IOR intrinsics to OR, similarly: IAND -> AND, INOT -> NOT. The "I"
C prefix is for INTEGER*2 (16 bit) types only, so could overflow when fed
C data from CRYSTALS' store. The unprefixed versions take any type and return
C the same type.
C
C Revision 1.49  2003/06/27 11:55:03  rich
C
C  If an angle involves a riding hydrogen atom, zero the esd to supress PLATON
C  warnings.
C
C Revision 1.48  2003/06/20 11:39:53  rich
C
C Increase maximum parts per parameter (MXPPP) from 10 to 50.
C
C In KDIST4 (analagous to KDIST1, but returns distances from
C List 41) keep track of the List 12 pointers if required.
C
C Made XCOVAR more consistent - the VCV returned for distances
C or angles is now always pre and postmultiplied by the
C matrix of constraint for the given atoms. The 'weight' vector
C that is returned is now always a unit matrix. Previously
C XCOVAR treated atoms with single part and multi part
C paramters differently.
C
C Also, the diagonal multiplier matrix that was computed for
C atoms with multipart parameters (XFWM) isn't required since
C in these cases the multiplier information is already applied
C to the VCV: a unit matrix is now returned.
C
C Revision 1.47  2003/06/09 13:45:34  rich
C Use correct module ID when generating errors in bond calculation
C routines. IOPBND.
C
C Revision 1.46  2003/05/22 11:21:57  rich
C In function MAKE41 (constructs a list of bonds from atom coords), add extra
C logic so that any symmetry operation that is not I, and does not move an
C atom is ignored. This prevents two bonds being formed to atoms on
C special positions. This mattered not for display, but it matters much to
C Mogul.
C
C The BREAK directive in L40 breaks bonds that would otherwise form and be
C stored in L41. If you explicitly give a symmetry operator,S, of zero,
C then all bonds between the pair of atoms will be broken, even if related
C by symmetry. For example: Imagine a Zn(1) on a 2-fold axis. Imagine it
C is coordinated by a carboxylate anion. Imagine that the C(1) atom is
C accidentally bonding to the Zn(1) - it shouldn't only the O's should
C bond. You say "BREAK ZN(1) TO C(1)", but the ZN(1) TO C(1,2) remains.
C Now you can say "BREAK ZN(1,0) TO C(1,0)" and all ZN(1)-C(1) bonds are
C broken, hurrah.
C
C Revision 1.45  2003/05/14 13:01:19  rich
C Typo.
C
C Revision 1.44  2003/05/07 12:18:53  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.43  2003/03/20 16:10:11  rich
C
C Moved SYMMETRY expansion code into a subroutine so it can be applied
C identically whether in LINK or in DISTANCES. Commented out some debugging.
C
C Revision 1.42  2003/03/05 16:30:45  rich
C Fiddling to make more general.
C
C Revision 1.41  2003/02/27 11:24:38  rich
C Changed regroup, so that residue number goes into slot 17 of L5 (RESIDUE)
C
C Revision 1.40  2003/02/20 15:59:11  rich
C Output html from distances.
C
C Revision 1.39  2003/01/29 11:46:10  rich
C Lesson of the day: Don't use stack pointers as implied do loop variables in
C write statements.
C
C Revision 1.38  2003/01/15 15:26:38  rich
C Removal of NCAWU calls throught the standard SFLS refinement instruction. If
C anywhere will benefit from less IO, it's here.
C
C Revision 1.37  2003/01/14 10:13:22  rich
C g77 spots missing comma in Format statement.
C
C Revision 1.36  2003/01/10 15:55:35  djw
C Fix my mistake
C
C Revision 1.34  2002/12/17 15:25:07  rich
C
C DIST / OUT PUNCH=NONBONDED VALUE=1.5 POWERFACTOR=1.0 / END
C will output a list of nonbonded restraints to the punch unit.
C
C Revision 1.33  2002/12/16 18:22:55  rich
C Added code to KDIST1 and KDIST4 for outputting different parts in
C self-consistent sets, all permutations.
C
C Revision 1.32  2002/10/31 13:20:33  rich
C Changes to PUNCH=MOGUL option in #DIST.
C
C Revision 1.31  2002/10/02 13:38:42  rich
C
C Extra arg to KDIST1 to indicate offset of X coord in L5 (may be 2 from Fourier routines).
C KDIST1 - fixed box function.
C KDIST4 - return transformed coords in list of contacts
C Fix bug in bond finding code that would miss bonds occassionally.
C
C Revision 1.30  2002/08/29 15:19:43  richard
C Attempt overwrite of L41 when re-writing to disk. (Will work if number of bonds and atoms
C is unchanged).
C
C Revision 1.29  2002/08/23 09:02:59  richard
C Fix alldist=yes.
C
C Revision 1.28  2002/07/31 06:51:21  richard
C
C Be a little more careful with STORE allocation in XBCALC when called from #EDIT.
C
C Revision 1.27  2002/07/29 12:59:25  richard
C When adding new items to L29 either set colour to 'UNKN', or find the correct
C colour. (This L29 remains loaded and will be used by XGUIUP).
C
C Revision 1.26  2002/07/23 15:51:33  richard
C If XBCALC is called internally, with MODE 2 (i.e. from #EDIT), then don't
C even think about trying to write L41 back to disk - bad things will happen
C due to #EDIT claiming bits of store without asking.
C
C Revision 1.25  2002/07/23 10:02:09  richard
C
C INSERT NCONN and INSERT RELAX use L41 to work out bonding. L41 is dangerously
C useless if L5 has been sorted in #EDIT. One can now call XBCALC(2) to recalculate
C bonds. L5 is not reloaded in this mode.
C
C Revision 1.24  2002/07/19 08:56:25  Administrator
C Typo.
C
C Revision 1.23  2002/07/18 17:26:04  richard
C
C New #DISTANCE directives: NOTBONDED [atoms or types]
C                           NOTPIVOT [atoms or types]
C
C Specifically excludes the specified atoms from being either
C pivots or bonded atoms. Useful because: if I want all the bonds
C from peaks to non-peaks, I can now say PIVOT Q / NOTBONDED Q and
C it will do the trick.
C
C New #DISTANCE option: OUTPUT LIST=DEBUG
C
C Every time you issue INCLUDE/PIVOT/BONDED/EXCLUDE/NOTBONDED/NOTPIVOT this
C option prints a list of all the atoms along with the three column vectors
C which specify where an atom can appear in a distance or angle result.
C Useful to see what exactly is going on.
C
C New #DISTANCE option: OUTPUT MONITOR=PEAKSTOGUI
C
C For each pivot atom this option outputs the pivot with its SPARE value,
C and the distance to the closest of the bonded atoms and its name -
C (Like this: ^^WI 'Q(1) height: 1.43, 1.243A from C(11)') - allowing
C it to be added to a listbox in the GUI. You probably want to use the options
C PIVOT Q and NOTBONDED Q in conjunction with this option. See script XPRUNE
C for an example.
C
C Revision 1.22  2002/07/17 09:29:49  richard
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
C Revision 1.21  2002/06/26 10:30:52  richard
C New output punch option: "SIMPLE" punches value followed by atoms. Suitable
C for reading by scripts.
C
C Revision 1.20  2002/06/21 09:49:03  Administrator
C Fix zero esds on bonds across a symmetry operator between atoms on special positions
C
C Revision 1.19  2002/03/15 16:50:00  richard
C Type #SET BONDTYPE OFF to suppress bond type calculation.
C
C Revision 1.18  2002/03/15 11:30:09  richard
C Fix problem where bond types are not calculated on opening a new structure.
C
C Revision 1.17  2002/03/13 12:48:34  richard
C Huge overhaul of distances and angles. Improved workings of INCLUDE/EXCLUDE/PIVOT
C /BONDED. Indented whole distances subroutine so that it is readable.
C Added lots of new L40/41 processing code.
C
C Revision 1.16  2001/10/17 15:14:05  Administrator
C Changes to allow PARTS in list 5
C
C Revision 1.15  2001/10/08 16:09:06  ckp2
C Fix bug reading #BONDING MAKE command
C
C Revision 1.14  2001/10/05 13:31:50  ckp2
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
C Revision 1.13  2001/09/04 14:54:54  ckp2
C PUNCH=PUB option was outputing distances twice. Now fixed.
C
C Revision 1.12  2001/06/18 08:23:45  richard
C Add missing comma to format statement.
C
C Revision 1.11  2001/06/12 15:44:23  richard
C Code to inhibit printing of SU's of bond lengths and angles to non-refined
C H atoms to the CIF (if requested).
C
C Revision 1.10  2001/03/28 13:34:21  richard
C Update Andy Brown's code to generate dummy atoms compatible with the new list 5 format.
C
C Revision 1.9  2001/03/28 12:53:18  richard
C Recent changes in KDIST1 (pivot and bonded related) broke Andy's void code.
C The good news is that it's now better than ever.
C
C Revision 1.8  2001/03/08 14:24:13  richard
C Revamped the way this works a bit. KDIST1 overhauled to get rid of unnecessary jumps
C and deprecated fortran stuff - seems easier to understand now ;)
C ONLY (dirctive on it's own) simply causes the function vector to be used for INCL/EXCL
C only, it no longer takes arguments. (Used to work like INCLUDE).
C INCLUDE - as before, but disables PIVOT and BONDED directives. Any set of directives
C featuring an INCLUDE will result in all non-specified atom being EXCLUDED.
C EXCLUDE - as before, on it's own all non-specified atoms are INCLUDED.
C PIVOT - atom can be a pivot in the calculation. Disables the INCLUDE directive. All
C non specified atoms will be type BONDED, unless there is a BONDED directive, in which case
C non-specified atoms are excluded.
C BONDED - atom can be bonded to in the calculation. Disables the INCLUDE directive. All
C non-specified atoms will be type PIVOT, unless there is a PIVOT directive, in which case
C non-specified atoms are excluded.
C
C Revision 1.7  2001/01/22 16:49:25  richard
C Fix array overflow when using include in #dist after List12 has been previously loaded.
C
C Revision 1.6  2001/01/18 11:33:29  richard
C Added new DISTANCE DIRECTIVES:
C OUTPUT PUNCH=SCRIPT - outputs easily script-readable bond info to the punch file.
C PIVOT atomspec - outputs all bonds and/or angles where atomspec is the PIVOT atom.
C BONDED atomspec - output all bonds where atomspec is bonded to.
C Both PIVOT and BONDED set ALLDIST to YES, the difference is in the output. PIVOT
C atoms always appear first and at the centre of angles. If you say
C #DIST / OUT PUNCH=SCRIPT / BONDED H / END - then the punch file will contain the pivot
C atom, say C, followed by a list of H's bonded to it. Useful for constructing a
C set of riding H instructions, I think.
C
C Revision 1.5  2000/10/31 15:35:48  ckp2
C RIC: New subroutine XDIST3 sets up distance calculation for a box.
C

CODE FOR XDIST
      SUBROUTINE XDIST
C--CALCULATE AND PRINT DISTANCES AND ANGLES
C
C  AT      MINIMUM CONTACT FOR DISTANCES.
C  AC      MAXIMUM CONTACT FOR DISTANCES.
C  BT      MINIMUM CONTACT FOR ANGLES.
C  BC      MAXIMUM CONTACT FOR ANGLES.
C  BP      MINIMUM OVERALL CONTACT SQUARED.
C  AP      MAXIMUM OVERALL CONTACT SQUARED.
C  AO      MAXIMUM OVERALL CONTACT.
C  IDIST   DISTANCE OR BOX FLAG :
C          -1  D/A CALCULATION.
C
C----- CONTROL VARIABLES IN XPROCD
C
C  IALL    DISTANCE CONTROL FLAG :
C          -1  PRINT CONTACTS TO THOSE ATOMS BELOW THE CURRENT ONE IN LI
C           0  AUTO (No, UNLESS INCLUDE, PIVOT OR BONDED GIVEN)
C           1  PRINT ALL CONTACTS TO THE CURRENT ATOM.
C  IP      PRINT CONTROL FLAG FOR COORDINATES :
C          -1  DO NOT PRINT GENERATED COORDINATE FOR A DISTANCE.
C           0  PRINT GENERATED COORDINATES FOR A DISTANCE.
C  IESD    E.S.D. CALCULATION CONTROL FLAG :
C          -1  DO NOT CALCULATE E.S.D.'S.
C           0  CALCULATE E.S.D.'S.
C  ICELL   CELL E.S.D. CONTROL FLAG :
C          -1  DO NOT THE CELL E.S.D.'S IN THE E.S.D. CALCULATIONS.
C           0  INCLUDE THE UNIT CELL E.S.D.'S IN THE E.S.D. CALCULATIONS
C  ISORT   DETERMINES WHETHER THE DISTANCES ARE SORTED :
C          -1  DO NOT SORT THE DISTANCES AT EACH ATOM
C           0  SORT THE DISTANCES.
C  INTRA   CONTROLS WHETHER ONLY INTRA-MOLECULAR DISTANCES AND ANGLES
C          ARE PRODUCED :
C          -1  ALL D/A OUTPUT IS PRODUCED.
C           0  ONLY INTRA-MOLECULAR D/A OUTPUT IS LISTED.
C           1  ONLY INTER-MOLECULAR OUTPUT IS PRODUCED.
C
C  LEVEL   CONTROLS LISTING LEVEL
C            -1 OFF
C             0 LOW
C             1 MEDIUM
C             2 HIGH
C             3 DEBUG
C
C  IULN    THE INPUT LIST TYPE.
C  IRDUS     TYPE OF RADIUS TO USE
C           -1 USE LIST 41 for BONDS
C            0 OVERALL LIMITS
C            N N'TH RADIUS FROM LIST 29
C
C  IDSPDA   MONITOR LEVEL
C            0 OFF
C            1 DISTANCES
C            2 ANGLES
C            3 ALL
C  IPUNCH    PUNCHED OUTPUT
C            -1 NOTHING
C             0 RESTRAINTS
C             1 PUBLICATION
C             2 CIF
C             3 SCRIPT READ-ABLE RIDE INSTRUCTIONS
C             4 MOGUL query file.
C             5 SIMPLE SCRIPT READ-ABLE DATA
C             6 DELU RESTRAINTS
C             7 SIMU RESTRAINTS
C             8 NONBONDED RESTRAINTS
C             9 HTML OUTPUT
C            10 HYDROGEN RESTRAINTS
C            11 HYDROGEN BONDING
c            12 HYDROGEN RIDES
C
C  ISYMOD   SYMMETRY MODIFIER
C           -1  PATTERSON
C            0  NORMAL
C            1  NOSYMMETRY
C
C  ITRANS   TRANSLATION MODIFIER
C           -1 DO NOT APPLY UNIT CELL TRANSLATIONS
C            0 DO APPLY UNIT CELL TRANSLATIONS
C
C
C
C----- A VECTOR MAY BE DEFINED TO INDICATE THE TREATMENT OF ATOMS
C
C----- JATVC - 0 DO NOT USE A FUNCTION VECTORS
C               1 USE THE VECTORS
C
C      LATMVC, MATMVC, ETC. - THE FUNCTION VECTOR POINTERS FOR ATOMS
C
C      THE VECTOR WILL BE N5*3 IN LENGTH
C
C      (MATVC+0) USE FLAG FOR PIVOT ATOM 
C      (MATVC+1) USE FLAG FOR BONDED ATOM 
C      (MATVC+2) USE FLAG FOR 3RD ATOM IN ANGLE SEARCH
C
C      MEANINGS OF USE FLAG
C             -1     DO NOT USE AT THIS POSITION
C              0     ATOM ALLOWED AT THIS POSITION
C
C----- A FUNCTION VECTOR IS DEFINED TO INDICATE THE RADIUS OF ATOMS
C
C----- JFNVC - 0 DO NOT USE THE RADIUS VECTOR
C              1 USE THE RADIUS INFO.
C
C      LFNVC,MFNVC, ETC - THE RADIUS FUNCTION VECTOR POINTERS
C
C      (MFNVC)    RADIUS FOR CONTACT
C
C
C--THE COMMON BLOCK XWORKA IS USED AS :
C
C  JA  ADDRESS OF FIRST ATOM IN ATOM COORDINATE STACK
C  JB  ADDRESS OF THE SECOND ATOM IN THE COORDINATE STACK
C  JC  ADDRESS OF ANY ATOM IN THE STACK
C  JD  WORK SPACE
C  JE  WORK SPACE
C  JF  WORK SPACE
C
C--ALL THE ABOVE WORK SPACE WILL HOLD THE LARGEST USED MATRIX
C
C  JG  ADDRESS OF THE SYMMETRY MATRIX FOR THE FIRST ATOM IN DISTANCES
C  JH  ADDRESS OF THE SYMMETRY MATRIX FOR THE SECOND ATOM IN DISTANCES
C  JI  ADDRESS OF THE SYMMETRY MATRIX FOR ANY ATOM IN DISTANCES
C
C  JJ  ADDRESS OF THE SYMMETRY MATRIX FOR THE FIRST ATOM IN ANGLES
C  JK  ADDRESS OF THE SYMMETRY MATRIX OF THE SECOND ATOM IN ANGLES
C  JL  ADDRESS OF THE SYMMETRY MATRIX OF THE THIRD ATOM IN ANGLES
C
C  JM  ADDRESS OF THE FIRST ELEMENT OF THE V/CV MATRIX FOR DISTANCES
C  JN  ADDRESS OF THE FIRST ELEMENT OF THE FIRST ATOM IN THE V/VC
C      MATRIX FOR DISTANCES
C
C  JP  ADDRESS OF THE FIRST ELEMENT OF THE V/VC MATRIX FOR ANGLES
C  JQ  ADDRESS OF THE FIRST ELEMENT OF THE FIRST ATOM IN THE V/VC
C      MATRIX FOR ANGLES
C
C  JS  THE NEXT ADDRESS THAT CAN BE USED IN THE STACK ON RETURN
C      FROM 'XDIST1'.
C      (THE STACK STARTS AT 'NFL' AND GOES UP).
C  JT  THE NUMBER OF WORDS PER ENTRY IN THE STACK.
C
C  JU  FIRST ANGLE TO CALCULATE
C  JV  LAST ANGLE TO CALCULATE
C  IJW  START OF PRINT BUFFER
C  IJX  CURRENT ITEM IN BUFFER
C  IJY  LAST POSITION IN BUFFER
C
C--FOR ANGLES THE ATOMS ARE GIVEN BY :
C
C  B - A - C
C
C  ANGLE(1) IS AT C
C  ANGLE(2) IS AT A
C  ANGLE(3) IS AT B
C
C  L(1)  A TO B
C  L(2)  B TO C
C  L(3)  C TO A
C
C--
C
      CHARACTER *4 RESTR, RESTR1, RESTR2
      CHARACTER *12 CBUFF
      CHARACTER *32 CATOM1, CATOM2, CATOM3, CBLANK
c
      LOGICAL LDISTI, LDISTE, LDISTP, LDISTB ! Directives given.
      LOGICAL PIVINI, BONINI !Atom vector initialised by directive.
      LOGICAL LHFIXD(3)
C
      INCLUDE 'TYPE11.INC'
      INCLUDE 'ISTORE.INC'
C
c----- to hold h/nh flag, length of atom names, part ID
      parameter (nbonda=12)
      dimension ihy(nbonda), lbonda(nbonda),iparth(nbonda)
      character *32 cbonda(nbonda)
      character *80 cline
      DIMENSION B(3), PROCS(24)
      DIMENSION CC(4),TT(2)
      DIMENSION IS(9),ANGLE(3),DIST(3),DISTSQ(3)
      DIMENSION IAPD(13)
      DIMENSION INTRAD(5)
C----- TO HOLD HE NUMBER OF 'PARTS' PER ATOM
      DIMENSION IPART(3)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'XDSTNC.INC'
C
      COMMON /XPROCD/DISTS(4),IALL,IP,IESD,ICELL,ISORT,INTRA,LEVEL,IULN
     1 ,IRDUS,IDSPDA,IPUNCH,ISYMOD,ITRANS,IHFIXD,DDEV1,DDEV2,SDEV1,SDEV2
     2 ,SNBVAL,SNBPOW 
      COMMON /XDISTW/A,BB,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y
c
c
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XFLAGS.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QSTR11.INC'
C
      EQUIVALENCE (DISTS(1),PROCS(1))
      EQUIVALENCE (B(1),C)
      EQUIVALENCE (CC(1),AC),(TT(1),AT)
      EQUIVALENCE (APD(1),IAPD(1))
      DIMENSION KATV(3)
C
C
      DATA RESTR1 /'DIST'/, RESTR2 /'ENER'/
      DATA TOLER1 / .2 /, TOLER2 / .5 /
C
      DATA IDIMN /24/
C
      DATA IS(1)/0/,IS(2)/3/,IS(3)/6/
      DATA IS(4)/3/,IS(5)/3/,IS(6)/3/
      DATA IS(7)/6/,IS(8)/-6/,IS(9)/9/
C
      DATA IVERSN /620/
      DATA ANGLE(1)/0.0/,DIST(1)/0.0/,DISTSQ(1)/0.0/
C
      DATA CBLANK /' '/
#if !defined(_HOL_) 
      DATA JAKEY /' KEY'/
#else
      DATA JAKEY /4H KEY/
C
#endif
      DATA INTRAD(1)/1/,INTRAD(2)/1/,INTRAD(3)/0/
      DATA INTRAD(4)/0/,INTRAD(5)/0/
C----- MAXIMUM PARTS PER PARAMETER
      DATA MXPPP /50/

#if defined (_HOL_)
      DATA KHYD /4HH   /, KCARB /4HC   /, KAZOT/4HN   /, KOXY/4HO   /
      DATA KDET /4HD   /
#else
      DATA KHYD /'H   '/, KCARB /'C   '/, KAZOT/'N   '/, KOXY/'O   '/
      DATA KDET /'D   '/
#endif
      PIVINI = .FALSE.
      BONINI = .FALSE.
      LDISTI = .FALSE.
      LDISTE = .FALSE.
      LDISTP = .FALSE.
      LDISTB = .FALSE.
C--SET THE TIMING FUNCTION
      CALL XTIME1(2)
      CALL XCSAE
C----- INITIALISE FUNCTION VECTOR USE
      JFNVC = 1
      JATVC = 1
C -- ALLOCATE A BUFFER FOR COMMAND PROCESSING
      MQ = KSTALL ( 100 )
C----- INITIALISE LEXICAL INPUT
      ICHNG=0
      CALL XLXINI (INEXTD, ICHNG)
C---- RESERVE A COMMAND LINE BUFFER OF 8 ELEMENTS
      JDIMBF = 8
      IDIMBF=JDIMBF+IDIMN
      ICOMBF=KSTALL(IDIMBF)
      JCOMBF = ICOMBF+JDIMBF
C----- ZERO THE BUFFER
      CALL XZEROF( ISTORE(ICOMBF), IDIMBF)
C----- RICJAN01 INDICATE NO L12 YET.
      L12=-1

C--READ THE INITIAL CONSTANTS
C----- INSTRUCTION READING LOOP
100   CONTINUE
C----- READ A DIRECTIVE
        IDIRNM = KLXSNG(ISTORE(ICOMBF),IDIMBF,INEXTD)
        IF (IDIRNM .LT. 0) GOTO 100
        IF (IDIRNM .EQ. 0) GOTO 1000
        GOTO( 100, 100, 100, 210, 220, 230, 240, 250, 260, 255,
     1        265, 200,9910),IDIRNM
        GOTO 9910


200   CONTINUE
C------ LOAD LIST 5/10
        IULN= ISTORE(JCOMBF+11)
        IF (IULN .LT. 1) GOTO 9900 ! Common may be cleared by previous error.
        IULN = KTYP05 (IULN)
        CALL XLDR05 (IULN)
        IF (IERFLG .LT. 0) GOTO 9900

C----- ALLOCATE DUPLICATE BUFFER
        MDDUPV = 1
        NDUPV = N5
        I=NDUPV*MDDUPV
        LDUPV = KSTALL (I)
        CALL XFILL ( 0, ISTORE(LDUPV) , I )
C----- ALLOCATE A RADIUS VECTOR
        MDFNVC = 1
        NFNVC = N5
        I=NFNVC*MDFNVC
        LFNVC = KSTALL (I)
        CALL XZEROF ( ISTORE(LFNVC) , I )
        IDEFFN = 0
C----- ALLOCATE A FUNCTION VECTOR
        MDATVC = 3
        NATVC = N5
        I=NATVC*MDATVC
        LATVC = KSTALL (I)
        CALL XZEROF ( ISTORE(LATVC) , I ) !Include all by default.
C----- LOAD L41 in case anyone might want it. (KDIST4, for example)
C----- sAVE SPACE FOR UEQUIV ETC
        NBASE = KSTALL(4)
        GOTO 100

210   CONTINUE
C -- 'OUTPUT' DIRECTIVE - not normally checked, but we need to know
C if PUNCH=MOGUL.
C---- In MOGUL mode, grow the fragment to allow polymeric structures.
        IPUNCH = ISTORE(JCOMBF+14)
        IF ( IPUNCH .EQ. 4 ) THEN
         NORIG5 = N5
         IF (KHUNTR (1,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL01
         IF (KHUNTR (2,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL02
         IF (KHUNTR (41,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL41
         CALL GROWFR
         WRITE (CMON,'(A4,2I6)') 'Grown: ',NORIG5,N5
         CALL XPRVDU(NCVDU,1,0)
         IF ( N5.GT.NORIG5) THEN       ! RE-ALLOCATE VECTORS
           I=N5*MDFNVC
           LFNVC = KSTALL (I)
           NFNVC = N5
           CALL XZEROF ( ISTORE(LFNVC) , I ) ! Not used yet, just zero.
           LLATVC = LATVC
           I=N5*MDATVC
           LATVC = KSTALL (I)
           CALL XZEROF ( ISTORE(LATVC) , I ) !Include all by default.
C Copy any existing values:
           CALL XMOVE ( ISTORE(LLATVC), ISTORE(LATVC), NATVC*MDATVC )
           NATVC = N5
C---- Fill rest of function vector default to bonded, not pivot.
           DO MATVC = LATVC+NORIG5*MDATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
             ISTORE(MATVC) = -1
             ISTORE(MATVC+1) = 0
             ISTORE(MATVC+2) = 0
           ENDDO
           PIVINI = .TRUE.
         END IF
        END IF

        GOTO 100

220   CONTINUE
C -- 'INCLUDE' DIRECTIVE
C Set all 3 atom vectors to exclude by default.
        DO MATVC = LATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
          IF ( .NOT. PIVINI ) ISTORE(MATVC)   = -1
          IF ( .NOT. BONINI ) ISTORE(MATVC+1) = -1
          IF ( .NOT. BONINI ) ISTORE(MATVC+2) = -1
        ENDDO
        PIVINI = .TRUE.
        BONINI = .TRUE.
        KATV(1) = 1
        KATV(2) = 1
        KATV(3) = 1
        CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , 0 , KATV)

        IF ( ISTORE(ICOMBF+18) .EQ. 3 ) THEN
          WRITE (CMON,'(A)')
     1      'Atom         Pivot    Bonded "3rd in angle"'
          CALL XPRVDU(NCVDU,1,0)
          DO KKI = 0, NATVC-1
            MATVC = LATVC+MDATVC*KKI
            WRITE (CMON,'(A4,I4,3I10)') ISTORE(L5+KKI*MD5),
     1        NINT(STORE(L5+1+KKI*MD5)),(ISTORE(MATVC+KKR),KKR=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
        END IF
        LDISTI=.TRUE.
        GO TO 100

230   CONTINUE
C -- 'EXCLUDE' DIRECTIVE
C Set all 3 atom vectors to include by default.
        DO MATVC = LATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
          IF ( .NOT. PIVINI ) ISTORE(MATVC)   = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+1) = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+2) = 0
        ENDDO
        PIVINI = .TRUE.
        BONINI = .TRUE.
        KATV(1) = 1
        KATV(2) = 1
        KATV(3) = 1
        CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , -1 , KATV )
        IF ( ISTORE(ICOMBF+18) .EQ. 3 ) THEN
          WRITE (CMON,'(A)')
     1      'Atom         Pivot    Bonded "3rd in angle"'
          CALL XPRVDU(NCVDU,1,0)
          DO KKI = 0, NATVC-1
            MATVC = LATVC+MDATVC*KKI
            WRITE (CMON,'(A4,I4,3I10)') ISTORE(L5+KKI*MD5),
     1        NINT(STORE(L5+1+KKI*MD5)),(ISTORE(MATVC+KKR),KKR=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
        END IF
        LDISTE=.TRUE.
        GO TO 100

C----- ONLY. ORIGINAL USE NOW LOST IN MISTS OF TIME. ONLY SETS THE
C----- 3RD ATOM VECTOR TO INCLUDE ANY ATOM. SO, WITHOUT ONLY, THE COMMAND
C----- "BONDED H" WOULD RETURN, SAY, "H-C-H", WITH ONLY IT CAN RETURN
C----- "H-C-O" FOR EXAMPLE.
240   CONTINUE
        DO MATVC = LATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
          ISTORE(MATVC+2) = 0
        ENDDO  
        IF ( ISTORE(ICOMBF+18) .EQ. 3 ) THEN
          WRITE (CMON,'(A)')
     1      'Atom         Pivot    Bonded "3rd in angle"'
          CALL XPRVDU(NCVDU,1,0)
          DO KKI = 0, NATVC-1
            MATVC = LATVC+MDATVC*KKI
            WRITE (CMON,'(A4,I4,3I10)') ISTORE(L5+KKI*MD5),
     1        NINT(STORE(L5+1+KKI*MD5)),(ISTORE(MATVC+KKR),KKR=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
        END IF
        GOTO 100

250   CONTINUE
C----- 'PIVOT'
C Set first vector (pivot) to -1, and the other 2 to 0:
        DO MATVC = LATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
          IF ( .NOT. PIVINI ) ISTORE(MATVC)   = -1
          IF ( .NOT. BONINI ) ISTORE(MATVC+1) = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+2) = 0
        ENDDO
        PIVINI = .TRUE.
        KATV(1) = 1
        KATV(2) = 0
        KATV(3) = 0
        CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , 0 , KATV)
        IF ( ISTORE(ICOMBF+18) .EQ. 3 ) THEN
          WRITE (CMON,'(A)')
     1      'Atom         Pivot    Bonded "3rd in angle"'
          CALL XPRVDU(NCVDU,1,0)
          DO KKI = 0, NATVC-1
            MATVC = LATVC+MDATVC*KKI
            WRITE (CMON,'(A4,I4,3I10)') ISTORE(L5+KKI*MD5),
     1        NINT(STORE(L5+1+KKI*MD5)),(ISTORE(MATVC+KKR),KKR=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
        END IF
        LDISTP=.TRUE.
        GOTO 100

255   CONTINUE
C----- 'NOTPIVOT'
C Set first vector (pivot) to 0, and the other 2 to 0:
        DO MATVC = LATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
          IF ( .NOT. PIVINI ) ISTORE(MATVC)   = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+1) = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+2) = 0
        ENDDO
        PIVINI = .TRUE.
        KATV(1) = 1
        KATV(2) = 0
        KATV(3) = 0
        CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , -1 , KATV)
        IF ( ISTORE(ICOMBF+18) .EQ. 3 ) THEN
          WRITE (CMON,'(A)')
     1      'Atom         Pivot    Bonded "3rd in angle"'
          CALL XPRVDU(NCVDU,1,0)
          DO KKI = 0, NATVC-1
            MATVC = LATVC+MDATVC*KKI
            WRITE (CMON,'(A4,I4,3I10)') ISTORE(L5+KKI*MD5),
     1        NINT(STORE(L5+1+KKI*MD5)),(ISTORE(MATVC+KKR),KKR=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
        END IF
        LDISTP=.TRUE.
        GOTO 100

260   CONTINUE
C----- 'BONDED'
C Set first vector (pivot) to 0, and the other 2 to -1:
        DO MATVC = LATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
          IF ( .NOT. PIVINI ) ISTORE(MATVC)   = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+1) = -1
          IF ( .NOT. BONINI ) ISTORE(MATVC+2) = -1
        ENDDO
        BONINI = .TRUE.
        KATV(1) = 0
        KATV(2) = 1
        KATV(3) = 1
        CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , 0 , KATV)
        IF ( ISTORE(ICOMBF+18) .EQ. 3 ) THEN
          WRITE (CMON,'(A)')
     1      'Atom         Pivot    Bonded "3rd in angle"'
          CALL XPRVDU(NCVDU,1,0)
          DO KKI = 0, NATVC-1
            MATVC = LATVC+MDATVC*KKI
            WRITE (CMON,'(A4,I4,3I10)') ISTORE(L5+KKI*MD5),
     1        NINT(STORE(L5+1+KKI*MD5)),(ISTORE(MATVC+KKR),KKR=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
        END IF
        LDISTB=.TRUE.
        GOTO 100

265   CONTINUE
C----- 'NOTBONDED'
C Set first vector (pivot) to 0, and the other 2 to 0:
        DO MATVC = LATVC,LATVC+(NATVC-1)*MDATVC,MDATVC
          IF ( .NOT. PIVINI ) ISTORE(MATVC)   = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+1) = 0
          IF ( .NOT. BONINI ) ISTORE(MATVC+2) = 0
        ENDDO
        BONINI = .TRUE.
        KATV(1) = 0
        KATV(2) = 1
        KATV(3) = 1
        CALL XDSSEL ( ISTORE(LATVC) , MDATVC , NATVC , -1 , KATV)
        IF ( ISTORE(ICOMBF+18) .EQ. 3 ) THEN
          WRITE (CMON,'(A)')
     1      'Atom         Pivot    Bonded "3rd in angle"'
          CALL XPRVDU(NCVDU,1,0)
          DO KKI = 0, NATVC-1
            MATVC = LATVC+MDATVC*KKI
            WRITE (CMON,'(A4,I4,3I10)') ISTORE(L5+KKI*MD5),
     1        NINT(STORE(L5+1+KKI*MD5)),(ISTORE(MATVC+KKR),KKR=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
        END IF
        LDISTB=.TRUE.
        GOTO 100

C--SET A FEW INITIAL CONSTANTS AND PRINT THE CAPTION
1000  CONTINUE

C COMMAND INPUT COMPLETE. CHECK FOR ERRORS
      IF ( LEF .GT. 0 ) GO TO 9910

C----- RELOCATE THE COMMON BLOCK DATA
      CALL XMOVE( STORE(JCOMBF), PROCS(1),IDIMN)

      IF ( IALL .EQ. 0 ) THEN
        IALL = -1
        IF ( LDISTI .OR. LDISTP .OR. LDISTB ) IALL=1
      END IF

      IF ( IDSPDA .EQ. -1 ) ISORT = 1

C----- EXTRACT THE FUNCTION FLAG (0 for no radii, 1 for radii):
      JFNVC = MIN0(1,IRDUS)  !IRDUS: 0 limits, 1 covalent, 2 vdw, 3 ionic
C                            !JFNVC: 0 limits, -1 list41, 1 some radius
      IRDUS = MAX0(1,IRDUS)  !Set to valid value.
      CHECK = VALUE + ZERO
C----- SET RESTRAINT DIRECTIVE NAME AND DISTANCE TOLERANCE
      IF (IRDUS .EQ. 2) THEN
            RESTR = RESTR2 !ENER
            TOLER = TOLER2 !.5
      ELSE
            RESTR = RESTR1 !DIST
            TOLER = TOLER1 !.2
      ENDIF
                                              
C----- LOAD LISTS 29&41
      IF (KHUNTR (29,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL29
      IF (KHUNTR (41,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL41
C----- SCAN LIST 5 SETTING FUNCTION VECTOR TO APPROPRIATE RADIUS
      IFNVC=LFNVC
      I29=L29 + (N29-1)*MD29
      I5 = L5 + (N5-1)*MD5
      BMAX = 0.

      DO M5=L5,I5,MD5
        JZ = L29 + IRDUS    !IF NO MATCH - POINT TO DEFAULT (FIRST) ATOM
        DO M29= L29,I29,MD29
          IF (ISTORE(M5) .EQ. ISTORE(M29)) THEN
            JZ=M29+IRDUS
            EXIT
          END IF
        END DO
        STORE(IFNVC) = STORE(JZ)
        BMAX = AMAX1( BMAX, STORE(JZ))
        IFNVC = IFNVC + MDFNVC
      END DO

      IF ( IPUNCH .EQ. 7 ) THEN
C We need to know about terminal atoms. (Excluding H).
         INHVEC = KSTALL ( N5 )
         DO I = 0,N5-1
           ISTORE(INHVEC+I) = 0
         END DO
         DO M41B = L41B, L41B+(N41B-1)*MD41B, MD41B
            J51 = ISTORE(M41B)
            J52 = ISTORE(M41B+6)
            I51 = L5 + J51 * MD5
            I52 = L5 + J52 * MD5
            IF ((ISTORE(I52).NE.KHYD) .AND. (ISTORE(I52).NE.KDET))
     1                     ISTORE(INHVEC+J51)=ISTORE(INHVEC+J51)+1
            IF ((ISTORE(I51).NE.KHYD) .AND. (ISTORE(I51).NE.KDET))
     1                     ISTORE(INHVEC+J52)=ISTORE(INHVEC+J52)+1
         END DO
      END IF    

      AT = DISTS(1)
      AC = DISTS(2)
      BT = DISTS(3)
      BC = DISTS(4)
C----- RESET FUNCTION VECTOR AND LIMITS IF NECESSARY
      IF(JFNVC.EQ.1) THEN
        BMAX = 2.*BMAX + TOLER
        AT = CHECK
        AC = BMAX
        BT = AT
C----- DONT COMPUTE ANGLES IF USING VDW RADII
        IF (IRDUS .NE. 2) BC = BMAX
      ENDIF
C----- LOAD LISTS 1 AND 2, AND SET UP SOME CONSTANTS
      CALL XDIST2
      IF( IERFLG .LT. 0 ) GOTO 9900

C----- REDUCE SYMMETRY IF NECESSARY
      CALL KSYMOD (ISYMOD, IC, IL, N2P, L2C, L2, N2, MD2)

      IF ( IPUNCH .EQ. 4 ) THEN   ! Don't need symmetry in MOGUL mode.
        ITRANS = -1
        N2 = 1
        N2P = 1
        IC = 0
      END IF


C----- WRITE OUT THE CELL CONTENT PROPERTIES
C----- SKIP THE MOLECULAR PROPERTIES CALCULATION - FOR NOW
      JZ=IESD+2
      JZ=MAX0(1,JZ)
      JZ=MIN0(2,JZ)
      CALL XPRTCN
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1050)(IB,I=1,JZ)
      ENDIF
1050  FORMAT(21H Distances and angles,2A1,1H-,2X,
     2 39Hwith standard deviations estimated from,
     3 36H the full variance-covariance matrix)
C
      IF (JFNVC .LE. 0) THEN
       IF (ISSPRT .EQ. 0) WRITE(NCWU,1100)AT,AC,BT,BC
1100   FORMAT(' Distance limits',F7.3,' to',F7.3/
     2 ' Angles   limits',F7.3,' to',F7.3)
      ELSE
        IF (ISSPRT .EQ. 0) WRITE(NCWU,1130) TOLER, AT
1130    FORMAT(' Tolerance in determining contacts = ',G10.5,
     1      / ,'        Minimum resolved distance  = ',G10.5)
      ENDIF
C
      REWIND (MTE)
C
C----- SET LEVEL TO HIGH IF COORDINATES REQUESTED
      IF ((IP .GE. 0) .AND. (LEVEL . GE. 0)) LEVEL = 1
C----- WRITE HEADER IF RESTRAINTS TO BE GENERATED
      IF (IPUNCH .EQ. 0) CALL XPCHLH (16, ncpu)

C----- ALLOCATE ONE SLOT FOR THE MOMENT
      JF = KSTALL(1)

C--CHECK IF E.S.D.'S ARE TO CALCULATED
      IF ( IESD .LT. 0 ) THEN
C--E.S.D.'S ARE NOT TO BE CALCULATED
        NW=12
C----- SAVE SOME SPACE FOR THE TARGET RADIUS IN RESTRAINTS
        IF (IPUNCH .EQ. 0) NW = 14
cnancy just make nw 16 for all cases
        nw = 16	
        NCOL=9
C----- RESET COLUMNS FOR BRIEF O/P
        IF (LEVEL .LE. 0) NCOL = 11
        L12=-1
        JU=2
        JV=2
      ELSE
C--SET UP THE SYSTEM FOR E.S.D.'S
        JQ=0
        JS=1
C--LOAD LIST 12
        CALL XFAL12(JS,JQ,JU,JV)
C--CHECK IF THE E.S.D.'S OF THE CELL PARAMETERS ARE TO INCLUDED
        IF(ICELL.LT.0)THEN
C--DO NOT INCLUDE THE CELL ERRORS
C      ATOMS 2X3
          NWDT=6
C      ANGLES 2X3
          NWAT=9
        ELSE
C--INCLUDE THE CELL ERRORS (+6)
          NWDT= 12
          NWAT= 15
        END IF
C--SET VARIOUS CONSTANTS FOR E.S.D. CALCULATIONS
C      DISTANCE
        NWD=6
C      ANGLE
        NWA=9
C      ?
        NWS=4   !stack used by xfpces - must be 4
cnancy        NW=13
C----- SAVE SOME SPACE FOR THE TARGET RADIUS IN RESTRAINTS
        IF (IPUNCH .EQ. 0) NW=14
cdjw130804
C----- SAVE SOME SPACE FOR THE ESDS FOR H-BONDS
        IF (IPUNCH .EQ. 11) NW=15
cnancy  make nw 16 for all cases
        nw=16
        JU=1
        JV=3
        NCOL=5
C----- RESET COLUMN FOR BRIEF O/P
        IF (LEVEL .LE. 0) NCOL = 6
C--SET A FEW AREAS OF CORE FOR E.S.D. CALCLATION
        JA=NFL
        JD = JA + NWA * NWS * MXPPP
        NO=JD+NWAT*3-1
        NZ=NWAT*NWAT    !NWAT normally 9, but 15 if CELL errors are used.
        JE=JD+NZ
        JF=JE+NZ
        JG=JF+NZ
        JH=JG
        JJ=JG+NWD*NWD
        JK=JJ
        JM=JJ+NWA*NWA
        JN=JM
        JP=JM+NWDT*NWDT
        JQ=JP
cnov07
c          NWDT=6 or 12
c          NWAT=9 or 15
c          NWD=6
c          NWA=9
c          NWS=4
cnancy          NW=13, 14 or 15
c          nw=16 for all cases
c
c      JA > 9X4X50 = 1800                  NWA.NWS.MXPPT
C      JD > 9X9 OR 15X15 = 81 0R 225       NWAT.NWAT
C      JE > 9X9 OR 15X15 = 81 0R 225       NWAT.NWAT
C      JF > 9X9 OR 15X15 = 81 0R 225       NWAT.NWAT
C      JG = JH > 6X6 = 36                  NWD.NWD
C      JJ = JK > 9X9 = 81                  NWA.NWA
C      JM = JN > 12X12 = 144               NWDT.NWDT
C      JP = JQ > 15X15 = 225               NWAT.NWAT
C--COMPUTE THE LENGTH OF THE DATA AREA
        JS=JP+NWAT*NWAT-NFL
C--ALLOCATE THE SPACE
        LN=9
        IREC=1001
        I=KCHNFL(JS)
c
C--ZERO THE AREA INITIALLY
        CALL XZEROF(STORE(JA),JS)
C--SET UP THE UNIT MATRIX SYMMETRY OPERATOR FOR THE FIRST ATOM
c---djw 6x6 and 9x9 - perhaps for 2 and 3 atoms? Dist and angle?
C  IN THE AREA FOR DISTANCES AND ANGLES
        DO I=1,3
          STORE(JH)=1.
          STORE(JK)=1.
          JH=JH+NWD+1
          JK=JK+NWA+1
          JN=JN+2*(NWDT+1)
          JQ=JQ+2*(NWAT+1)
        END DO
        JL=JK+3*(NWA+1)

c
C--LOAD LIST 11
        CALL XFAL11(1,1)
        IF ( IERFLG .LT. 0 ) THEN
cdjwdec09 - moved into XFAL11 itself
c           IF (ISSPRT .EQ. 0) WRITE(NCWU,1405)
c           WRITE ( CMON ,1405)
c           CALL XPRVDU(NCVDU, 3,0)
c1405       FORMAT(
c     1     'The covariance matrix does not correspond to the atom list'/
c     2     'You have changed LIST 12 or LIST 5'/
c     3     'You must do another cycle of refinement')
           GO TO 9900
        ENDIF
        IF(ISTORE(L11P+15).GE.0) THEN
           IF (ISSPRT .EQ. 0) WRITE(NCWU,1500)
           WRITE ( CMON ,1500)
           CALL XPRVDU(NCVDU, 3,0)
1500       FORMAT(' Matrix is wrong type for e.s.d.''s')
           CALL XERHND ( IERWRN )
           IESD=-1
           GOTO 1000
        END IF

C--APPLY THE CORRECT MULTIPLICATION FACTOR TO THE MATRIX
        C=STORE(L11P+17)/STORE(L11P+16)
        M11=L11+N11-1
        DO I=L11,M11
           STR11(I)=STR11(I)*C
        END DO

C--PREPARE TO INITIATE THE CELL ERROR AREA IF NECESSARY
c  computes M31T as metric tensor x diagonal matrix with elements
c  1./cell-edge
c  plus 3-vector of term like -a.b.sin(gamma)
c  expands vCv matrix into full squares in param vCv area for dist (jM)
c  and angles (jp)
        IF(ICELL.GE.0)THEN
           CALL XFAL31(JM,JP)
           IF ( IERFLG .LT. 0 ) GO TO 9900
        ELSE
           JN=JM !RESET THE FIRST ATOM ADDRESSES FOR NO CELL ERRORS
           JQ=JP
        END IF
      END IF

C--SET THE NUMBER OF WORDS PER ATOM IN THE DISTANCES STACK
      JT=NW
C----- GET A LINE BUFFER
      IJW=NFL
      IJY=IJW+12
      I=KCHNFL(16)
C--SET THE ANGLE DETAILS
      G=360./PI
      GS=0.5*G
      SIN45=SIN(0.25*PI)
C--PREPARE A SORT BUFFER AT THE TOP OF CORE
      LN=9
      IREC=1002
      ITEMP1=KCHLFL(JT)
C--PREPARE ONE EMPTY SLOT AT THE TOP AS WELL
      IREC=1003
      I=KCHLFL(JT)
      if (ipunch .eq. 10) then
            CALL XRESTV 
      endif
C
C
C --             **** MAIN DISTANCE / ANGLES LOOP ****

      M5A=L5
      M12A=L12
      MFNVCA = LFNVC
      MATVCA = LATVC
C----- SAVE THE NEXT FREE ADDRESS
      NFLBAS = NFL

      MAINLOOP: DO I=1,N5

        IF ( I .GT. 1 ) THEN 
          M5A=M5A+MD5A
          MFNVCA = MFNVCA + MDFNVC
          MATVCA = MATVCA + MDATVC
          IF ( M12A .GT. 1 ) M12A=ISTORE(M12A)
        END IF

        JPART = 1
        KPLOOP = 1

        PARTLOOP: DO WHILE ( JPART .GE. 1 ) 

C----- RESTORE THE NEXT FREE ADDRESS
         NFL = NFLBAS

C -- CAN WE USE THIS ATOM ?
         IF ((ABS(JATVC).GE.1).AND.(ISTORE(MATVCA).LE.-1))
     1                                          CYCLE MAINLOOP
         M12=L12
         M5=L5
         MFNVC = LFNVC
         MATVC = LATVC

C--CALCULATE ALL THE DISTANCES AND ANGLES ABOUT THIS ATOM
1850  FORMAT(/,' Distances about atom  ',A4,F5.0,10X,'X =',F9.5,5X,
     2 'Y =',F9.5,5X,'Z =',F9.5)
C--CHECK IF ANY DISTANCES OR ANGLES HAVE BEEN FOUND AT THIS ATOM

         IF ( JFNVC.GE.0 ) THEN
           JPART = 0
           K = KDIST1( N5, JS, JT, JFNVC, TOLER, ITRANS, JATVC, 4,0)
         ELSE
C           JPART = 0
           K = KDIST4( JS, JT, JATVC, JPART)
         ENDIF

C Distance stack has this structure: NW = 16 items
C   0  ADDRESS OF ATOM IN L5
C   1  ACCEPTANCE FLAG
C
C      1  ACCEPTABLE TO NONE
C      2  DISTANCES ONLY
C      3  ANGLES ONLY
C      4  ACCEPTABLE TO BOTH
C
C   2  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CENTRE OF SYM.)
C   3  NON-PRIMITIVE LATTICE INDICATOR
C   4  T(X)
C   5  T(Y)
C   6  T(Z)
C   7  TRANSFORMED X
C   8  TRANSFORMED Y
C   9  TRANSFORMED Z
C  10  DISTANCE
C  11  DISTANCE SQUARED
C  12  ADDRESS IN LIST 12  (IF USED).
C  13  TARGET CONTACT DISTANCE FOR RESTRAINTS (OPTIONAL)
C  14  HYDROGEN ESD
C  15  RESIDUE NUMBER


c        DO MMMI=NFLBAS,NFLBAS+JT*(K-1),JT
c         WRITE(CMON,'(A,A4,I4)')'Found bond to:',
c     1   ISTORE(ISTORE(MMMI)),NINT(STORE(ISTORE(MMMI)+1))
c         CALL XPRVDU(NCVDU,1,0)
c        END DO

C----- DISTANCE STACK STARTS AT NFL AND RUNS TO JS
C----- RESET NFL (ITS BEEN CHECKED) TO UPPER  LIMIT
         NFL = JS
C--CHECK THE REPLY
         IF ( K .LT. 0 ) GOTO 9920
         IF ( K .EQ. 0 ) THEN
           IF ( IDSPDA .EQ. -1 ) THEN
              CALL CATSTR(STORE(M5A),STORE(M5A+1),1,1,0,0,0,
     1                      CATOM1,LATOM1)
              LATOM1 = MIN(10, LATOM1)
              WRITE ( CMON ,2803)
     1        CATOM1(1:LATOM1),STORE(M5A+13)
              CALL XPRVDU(NCVDU, 1,0)
2803          FORMAT ('^^WI ''',A,' height:',F8.2,
     1                ', no near contacts''')
           ENDIF
           CYCLE MAINLOOP
         END IF
c        WRITE(CMON,'(A,I4)') 'IALL = ',IALL
c        CALL XPRVDU(NCVDU,1,0)
c         IF (IALL .LE. 0) THEN
C----- ELIMINATE DUPLICATE ATOMS
          IF (K .GE. 2) THEN   !If there are more than two atoms found:
            L = NFLBAS
1960        CONTINUE
            J = L + NW    !L points to 1st atom, J the next
            LV = J
            LU = JS - NW  !JS is the end of the stom stack.
            NREJ = 0
            DO M =  J, LU, NW !Go from atom after L, to the end of the stack:
C-----        ARE ATOM ADDRESSES SAME?
              IF   (ISTORE(L) .EQ. ISTORE(M))  THEN
C-----          ARE DISTANCES SAME?
                IF (ABS(STORE(L+10) - STORE(M+10)) .LE. CHECK) THEN
C-----          ARE ATOMS COINCIDENT?
                  IF ( XDSTN2 (STORE(L+7), STORE(M+7)) .LE. CHECK) THEN
                    NREJ = NREJ + 1
c         WRITE(CMON,'(A,2(A4,I4))')'Rejecting same atoms:',
c     1   ISTORE(ISTORE(L)),NINT(STORE(ISTORE(L)+1)),
c     1   ISTORE(ISTORE(M)),NINT(STORE(ISTORE(M)+1))
c         CALL XPRVDU(NCVDU,1,0)
                    CYCLE
c                  ELSE
c         WRITE(CMON,'(A,2(A4,I4),G14.7)')'Non coincident atoms:',
c     1   ISTORE(ISTORE(L)),NINT(STORE(ISTORE(L)+1)),
c     1   ISTORE(ISTORE(M)),NINT(STORE(ISTORE(M)+1)),
c     1   XDSTN2 (STORE(L+7), STORE(M+7))
c         CALL XPRVDU(NCVDU,1,0)
                  ENDIF
c                ELSE
c         WRITE(CMON,'(A,2(A4,I4))')'Diff dist atoms:',
c     1   ISTORE(ISTORE(L)),NINT(STORE(ISTORE(L)+1)),
c     1   ISTORE(ISTORE(M)),NINT(STORE(ISTORE(M)+1))
c         CALL XPRVDU(NCVDU,1,0)
                ENDIF
              ENDIF
              IF (LV .NE. M) THEN
C-----          SHUFFLE ITEMS UP IF ADDRESSES DIFFERENT
                CALL XMOVE (STORE(M), STORE(LV), NW)
              ENDIF
              LV = LV + NW
            END DO
            L = L + NW        !Invcrement L atom pointer.
            JS = JS - NREJ*NW !Shorten stack if atoms were rejected.
            K = K - NREJ      !Reduce number of finds.
            IF (L .LT. JS-NW) GOTO 1960
          ENDIF
c         ENDIF
C----- SAVE THE PIVOT ADDRESS
         M5P = M5A
C----- INDICATE NO CAPTION YET FOR THIS PIVOT
         LEVEL2 = 0
C--CHECK IF WE SHOULD SORT THE DISTANCES
         IF(ISORT.GE.0)THEN
C--THAT OUTPUT DISTANCES MUST BE SORTED
          ITEMP2=JT*K
          CALL XSHELQ( STORE(NFLBAS), JT, 11, K, ITEMP2, STORE(ITEMP1) )
C--SET UP THE PROCESSING FLAGS
         END IF
         JS=JS-NW
         K = NFLBAS
         N=0
C--CHECK IF ERRORS ARE TO BE CALCULATED
         IF(IESD.GE.0)THEN
C--SET UP THE ATOM STACK FOR THE PIVOT ATOM
c--- note mxppp (maximum number of parts per parameter)
c      is set to 50. This is to reserve enough room at JA
          JB=JA
c--- NWS = 4
cdjwdec09
          CALL XFPCES( M12A, JB, NWS, IPART(1) )
c          write(ncwu,*) '1st dist atom  M12A=', M12A, 
c     1    ' JB=',JB, MWS, IPART(1)
          LHFIXD(1) = .FALSE.
C Check if it is a H
          IF ((ISTORE(M5P).EQ.KHYD) .OR. (ISTORE(M5P).EQ.KDET)) THEN
C Check if the H is riding, or the esd happens to be zero.          
            IF ( ( AND(ISTORE(M5A+15),KBREFB(3)).GT.0 ) .OR.
     1                                   (ISTORE(JA) .LT. 0 ))THEN
             LHFIXD(1) = .TRUE.   
           ENDIF
          ENDIF
         END IF
C----- INITIALIZE BUFFER
         IJX=IJW
      IF (IPUNCH .EQ. 3) THEN

C - This code only allows bonded atoms to appear once across whole output
C - avoid riding a bridging H twice.

           NREJ = 0
           LV = NFLBAS
C JS is (now) location of start of last atom in stack
           DO M =  NFLBAS, JS, NW

C Is atom already riding?
              ILD = LDUPV+(ISTORE(M)-L5)/MD5
              ISTORE(ILD) = ISTORE(ILD)+1

c              write(ncwu,*) 'bonded atom ',
c     c         ISTORE(ISTORE(M)),NINT(STORE(ISTORE(M)+1)),
c     c           M, (ISTORE(M)-L5)/MD5,
c     c           ISTORE(ILD)


              IF ( ISTORE(ILD) .GT. 1) THEN
                  NREJ = NREJ + 1
                  CYCLE
              ENDIF
              IF (LV .NE. M) THEN
C-----          SHUFFLE ITEMS UP IF ADDRESSES DIFFERENT
                CALL XMOVE (STORE(M), STORE(LV), NW)
              ENDIF
              LV = LV + NW
           END DO
c          write(ncwu,*) 'nrej ', nrej

           JS = JS - NREJ*NW !Shorten stack if atoms were rejected.
           K = K - NREJ      !Reduce number of finds.


cdjwsep06 get serial numbers to find unique H atoms
c
           nbon  = 1+(js-nflbas)/nw
           if (nbon .gt. 3) then
            WRITE(NCPU,2184) STORE(M5P), NINT(STORE(M5P+1)),nbon
2184       format('REM too many H atoms on ' a4,'(',i4,'), -',i2)
           endif
cdjwmay09

c - NB when called from xwrite5 with SYMM=NONE, this code is redundant:

          if (nbon .eq. 3) then
           j1 = nint(store(istore(nflbas)+1))
           j2 = nint(store(istore(nflbas+nw)+1))
           j3 = nint(store(istore(nflbas+2*nw)+1))
           if ((j3 .eq. j2) .or. (j3 .eq. j1))     then
c           discard last
            nbon = nbon-1
            js = js-nw
           else if (j1 .eq. j2) then
c           discard first
            nbon = nbon-1
            nflbas = nflbas+nw
           endif
          endif

          if(nbon .eq. 2) then
           j1 = nint(store(istore(nflbas)+1))
           j2 = nint(store(istore(nflbas+nw)+1))
           if (j2 .eq. j1) then
            nbon = nbon-1
            js = js-nw
           endif
          endif


C----- SCRIPT READABLE RIDE LINES
2185      FORMAT( 'RIDE ',50(A4,'(',I4,',X''S)',1X) )
2186      FORMAT( 'CONT ',50(A4,'(',I4,',X''S)',1X) )

          IF ( KPLOOP .EQ. 1 ) THEN
            WRITE(NCPU,2185) STORE(M5P), NINT(STORE(M5P+1)),
     1      (STORE(ISTORE(J)),NINT(STORE(ISTORE(J)+1)),J=NFLBAS,JS,NW)
            KPLOOP = KPLOOP + 1
          ELSE
            WRITE(NCPU,2186) 
     1      (STORE(ISTORE(J)),NINT(STORE(ISTORE(J)+1)),J=NFLBAS,JS,NW)
          END IF
C
C
C
      ELSE IF ((IPUNCH.EQ.10).OR.(IPUNCH.EQ.12)) THEN
C 
C
C---- FIND HYDROGEN CONSTRAINTS/RESTRAINTS  
C
C----- THE ATOMS BONDED TO A PIVOT ARE PUT INTO A STACK 'CBONDA'
C      TOGETER WITH A FLAG IN IHY TO MARK H ATOMS.  THE HYBRIDISATION
C      IS DETECTED AND RESTRAINTS WRITTEN TO THE PUNCH FILE
C
          CALL XZEROF (IHY,NBONDA)
          NHY = 0
          NNHY = 0
          KHY = 0
          IF ((ISTORE(M5P).NE.KHYD).AND.(ISTORE(M5P).NE.KDET))THEN
           WRITE(CATOM1,'(A4''('',I6,'')'')')STORE(M5P),
     1     NINT(STORE(M5P+1))
           LOOP16: DO J = NFLBAS, JS, NW 
C-----  FORM ATOM NAME INTO CHARACTERS
            L=ISTORE(J)
            KHY = KHY + 1
            IF (KHY .GT. NBONDA) CYCLE
C
            CALL CATSTR (STORE(L), STORE(L+1),
     1  ISTORE(J+2), ISTORE(J+3), ISTORE(J+4), ISTORE(J+5),
     2  ISTORE(J+6), CATOM2, LATOM2)
            IF((ISTORE(ISTORE(J)).EQ.KHYD).OR.
     1      (ISTORE(ISTORE(J)).EQ.KDET)) THEN
                NHY = NHY + 1
                IHY(KHY) = 1
            ELSE
                NNHY = NNHY + 1
                IHY(KHY) = 2
            ENDIF
            IPARTH(KHY)=ISTORE(L+14)
            CBONDA(KHY)(:) = CATOM2(1:LATOM2)
           END DO LOOP16
C
C-----     FIND A UEQUIV TO USE FOR FOR THE H ATOMS 
C          RESCALED LATER BY 1.25 FOR ME AND OH
cdjwsep08       CALL XEQUIV (0, M5P, N5P, NBASE)
           CALL XEQUIV (1, M5P, N5P, NBASE)
           UEQUIV = STORE(NBASE) * 1.2
C
      if (ipunch .eq. 12) then
c
C PUNCH CONSTRAINTS
             if (nhy .ge. 1) then
              IDJW=INDEX(CATOM1,')')
              CATOM1(IDJW:)=',X''s) '
              WRITE (CLINE,'(a,a)') 'RIDE ',CATOM1
              CALL XCREMS (CLINE,CLINE,NCH)
              DO  J=1,KHY
               IF (IHY(J).EQ.1) THEN
                IDJW=INDEX(CBONDA(J),',')
                IF (IDJW.LE.0) IDJW=INDEX(CBONDA(J),')')
                CBONDA(J)(IDJW:)=',X''s) '
                WRITE (CLINE(NCH:),'(1x,a)') CBONDA(J)
                CALL XCREMS (CLINE,CLINE,NCH)
               END IF
              END DO
              WRITE(NCPU,'(A)') CLINE
             endif
c
      else if (ipunch .eq. 10) then
C----- C-H RESTRAINTS
           IF ((ISTORE(M5P) .EQ. KCARB) .AND. 
     1                (NHY .GE. 1)) THEN
C----- WRITE THE HYDROGEN ATOMS TO THE SCRIPT DATA FILE
             do idjw=1,khy
               if (ihy(idjw) .eq. 1) then
                write(cline,'(a,a,a,a,a,a )') 
     2          cbonda(idjw)
                j = index(cline,')')
                write(cline(j:),'(a)') ,',x''s)'
                call xcrems( cline, cline, nch)
                write(ncque,'(a)') cline(1:nch)
               endif
             END DO
C
C               
            IF (KHY .GT. 4) THEN
             WRITE(NCPU,'(A,I6)')
     1      'REM Probably disordered, No of H atoms=', NHY
                  UEQUIV = UEQUIV * 1.25
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.96)
                  CALL HCC109(KHY, IHY, CATOM1, CBONDA)
                  CALL HCHAV(KHY, IHY, CATOM1, CBONDA, IPARTH)
            ELSE
             IF      (NHY .EQ. 1) THEN
                IF       (NNHY .EQ. 1) THEN
                  WRITE(NCPU,'(/A)') 'REM            1 H on sp 1'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.93)
                  CALL ANG180(KHY, IHY, CATOM1, CBONDA)
                ELSE IF (NNHY .EQ. 2) THEN
                  WRITE(NCPU,'(/A)') 'REM            1 H on sp 2'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.93)
                  CALL HCCAV(KHY, IHY, CATOM1, CBONDA)
                  CALL PLANH(KHY, IHY, CATOM1, CBONDA)
                ELSE IF (NNHY .EQ. 3) THEN
                  WRITE(NCPU,'(/A)') 'REM            1 H on sp 3'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.98)
                  CALL HCCAV(KHY, IHY, CATOM1, CBONDA)
                ELSE
                  WRITE(NCPU,'(/A)') 'REM            unattached H'
                ENDIF

             ELSE IF (NHY .EQ. 2) THEN
                IF       (NNHY .EQ. 1) THEN
                  WRITE(NCPU,'(/A)') 'REM            2 H on sp 2'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.93)
                  CALL HCC120(KHY, IHY, CATOM1, CBONDA)
                  CALL PLANH(KHY, IHY, CATOM1, CBONDA)
                ELSE IF (NNHY .EQ. 2) THEN
                  WRITE(NCPU,'(/A)') 'REM            2 H on sp 3'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.97)
                  CALL HCCAV(KHY, IHY, CATOM1, CBONDA)
                  CALL HCH109(KHY, IHY, CATOM1, CBONDA, IPARTH)
                ELSE
                  WRITE(NCPU,'(/A)') 'REM            unattached H'
                ENDIF

             ELSE IF (NHY .EQ. 3) THEN
                IF       (NNHY .EQ. 1) THEN
                  WRITE(NCPU,'(/A)') 'REM            3 H on sp 3'
                  UEQUIV = UEQUIV * 1.25
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.96)
                  CALL HCC109(KHY, IHY, CATOM1, CBONDA)
                  CALL HCHAV(KHY, IHY, CATOM1, CBONDA, IPARTH)
                ELSE
                  WRITE(NCPU,'(/A)') 'REM            unattached H'
                ENDIF
             ENDIF        
            ENDIF
C----- N-H 
           ELSE IF ((ISTORE(M5P) .EQ. KAZOT) .AND. (NHY .GE. 1)) THEN
C----- WRITE THE HYDROGEN ATOMS TO THE SCRIPT DATA FILE
            do idjw=1,khy
               if (ihy(idjw) .eq. 1) then
                write(cline,'(a,a,a,a,a,a )') 
     2          cbonda(idjw)
                j = index(cline,')')
                write(cline(j:),'(a)') ,',x''s)'
                call xcrems( cline, cline, nch)
                write(ncque,'(a)') cline(1:nch)
               endif
            END DO
            IF (KHY .GE. 4) THEN
C---- 4 OR MORE BONDS
             WRITE(NCPU,'(A,I6)')
     1      'REM Possibly disordered, No of H atoms=', NHY
                  UEQUIV = UEQUIV * 1.25
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.89)
                  CALL HCC109(KHY, IHY, CATOM1, CBONDA)
                  CALL HCHAV(KHY, IHY, CATOM1, CBONDA, IPARTH)
            ELSE
             IF      (NHY .EQ. 1) THEN
                IF       (NNHY .EQ. 1) THEN
C 1H, 1NOT-H
                  WRITE(NCPU,'(A)') 'REM            H1-N-R1'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.86)
                  CALL HCC120(KHY, IHY, CATOM1, CBONDA)
                ELSE IF (NNHY .EQ. 2) THEN
C 1H, 2NOT-H
                  WRITE(NCPU,'(A)') 'REM            H1-N-R2'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.86)
                  CALL HCCAV(KHY, IHY, CATOM1, CBONDA)
camber-08                  CALL PLANH(KHY, IHY, CATOM1, CBONDA)
                ELSE IF (NNHY .EQ. 3) THEN
C 1H, 3NOT-H
                  WRITE(NCPU,'(A)') 'REM            H1-N-R3'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.89)
                  CALL HCCAV(KHY, IHY, CATOM1, CBONDA)
                ELSE
                  WRITE(NCPU,'(A)') 'REM            unattached H'
                ENDIF

             ELSE IF (NHY .EQ. 2) THEN
                IF       (NNHY .EQ. 1) THEN
C 2H, 1NOT-H
                  WRITE(NCPU,'(A)') 'REM            H2-N-R'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.86)
                  CALL HCC120(KHY, IHY, CATOM1, CBONDA)
camber-08                  CALL PLANH(KHY, IHY, CATOM1, CBONDA)
                ELSE IF (NNHY .EQ. 2) THEN
C 2H, 2NOT-H
                  WRITE(NCPU,'(A)') 'REM            H2-N-R2'
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.89)
                  CALL HCCAV(KHY, IHY, CATOM1, CBONDA)
                  CALL HCH109(KHY, IHY, CATOM1, CBONDA, IPARTH)
                ELSE
                  WRITE(NCPU,'(A)') 'REM            unattached H'
                ENDIF

             ELSE IF (NHY .EQ. 3) THEN
                IF       (NNHY .EQ. 1) THEN
C 3H, 1NOT-H
                  WRITE(NCPU,'(A)') 'REM            H3-N-R'
                  UEQUIV = UEQUIV * 1.25
                  CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.89)
                  CALL HCC109(KHY, IHY, CATOM1, CBONDA)
                  CALL HCHAV(KHY, IHY, CATOM1, CBONDA, IPARTH)
                ELSE
                  WRITE(NCPU,'(A)') 'REM            unattached H'
                ENDIF
             ENDIF        
            ENDIF
C----- O-H
           ELSE IF ((ISTORE(M5P) .EQ. KOXY) .AND. (NHY .GE. 1)) THEN
C----- WRITE THE HYDROGEN ATOMS TO THE SCRIPT DATA FILE
            do idjw=1,khy
               if (ihy(idjw) .eq. 1) then
                write(cline,'(a,a,a,a,a,a )') 
     2          cbonda(idjw)
                j = index(cline,')')
                write(cline(j:),'(a)') ,',x''s)'
                call xcrems( cline, cline, nch)
                write(ncque,'(a)') cline(1:nch)
               endif
            END DO
            WRITE(NCPU,'(A)') 'REM       H ON O-HETRO ATOM'
            UEQUIV = UEQUIV * 1.25
            CALL DIS11(KHY, IHY, CATOM1, CBONDA, UEQUIV, 0.82)
           ENDIF
      endif                                 ! end of ipunch 10/12 switch
          ENDIF
C
      ENDIF
C^^^
         IF ( IDSPDA .EQ. -1 ) JS = NFLBAS

C--PRINT THE CALCULATED DISTANCES
         PRINTLOOP: DO J = NFLBAS, JS, NW
cnancy
         M=J+1
C--CHECK IF WE WANT ALL DISTANCES
          IF(INTRA.EQ.0)THEN 
C--INTRA-MOLECULAR DISTANCES ONLY
            DO L=1,5
              M=M+1
              IF(ISTORE(M).NE.INTRAD(L)) CYCLE PRINTLOOP
            END DO
            if((istore(m5a+16) .ne. istore(istore(j)+16)) 
     1      .and. (istore(m5a+16) .ne. o)) cycle printloop
          ELSE IF ( INTRA.GE.1 ) THEN
C--ONLY INTER-MOLECULAR DISTANCES REQUIRED
            DO L=1,5
              M=M+1
              IF(ISTORE(M).EQ.INTRAD(L))CYCLE
              GOTO 2400
            END DO
            if((istore(m5a+16) .ne. istore(istore(j)+16)) 
     1      .and. (istore(m5a+16) .ne. o)) goto 2400
            CYCLE
2400        CONTINUE
          END IF

C--PROCESS THIS DISTANCE
          L=ISTORE(J+1)
          M=J+4


C--CHECK THAT THE ATOM INCL/EXCL/BOND VECTORS ALLOW THIS BONDED ATOM
C  (The pivot atom has already have been okayed - check the 2nd)
          IA2 = (( ISTORE(J)  - L5 ) / MD5 ) 
          IL2 = LATVC + IA2 * MDATVC

          IF ((ISTORE(IL2+1).EQ.-1 ).AND.(L.EQ.2 .OR. L.EQ.4))THEN
             L = 3
c             WRITE(CMON,'(A,A4,I4)')'Atom rejected in (bonded) print:',
c     1       ISTORE(ISTORE(J)),NINT(STORE(ISTORE(J)+1))
c             CALL XPRVDU(NCVDU,1,0)
          ENDIF

C-- Check if this bond would be acceptable the other way around, if
C   it's one where L.LT.M5A. To avoid duplication.

          IF ((ISTORE(J).LT.M5A).AND.(ISTORE(MATVCA+1).EQ.0)
     1                          .AND.(ISTORE(IL2     ).EQ.0)) THEN
             IF (IALL.LE.0) L=3
c             WRITE(CMON,'(A,A4,I4)')'Duplication removed:',
c     1       ISTORE(ISTORE(J)),NINT(STORE(ISTORE(J)+1))
c             CALL XPRVDU(NCVDU,1,0)
          ENDIF


C--BRANCH ON THE TYPE OF DISTANCE FOUND (AND ACCEPTANCE BY "BONDED" VECTOR):
          IF ( L .EQ. 1 ) CYCLE !Acceptable to none ( dist or angle ).
          IF ( L .EQ. 2 .OR. L .EQ. 4 ) THEN !Acceptable to dist or both.
C--DISTANCE ACCEPTABLE
            L=ISTORE(J)
C--CHECK IF ALL THE DISTANCES ARE  REQUIRED
            IF(IALL.GE.0 .OR. M5A.LE.L)THEN

C--CHECK IF THE ERRORS ARE TO BE CALCULATED
C----- SET ESD TO ZERO
              STORE(IJX+3)=.00000001
              STORE(JF)=0.0
              IF(IESD.GE.0)THEN
C--CALCULATE THE E.S.D.
                JC=JB
C--ADD THE SECOND ATOM INTO THE STACK
cdjedec09
                CALL XFPCES( ISTORE(J+12), JC, NWS, IPART(2) )
c          write(ncwu,*) '2nd dist atom  M12A=',ISTORE(J+12), 
c     1  ' JC=',JC, NWS, IPART(2)
                LHFIXD(2) = .FALSE.
C Check if it is a H
                IF ((ISTORE(L).EQ.KHYD) .OR.
     1          (ISTORE(L).EQ.KDET)) THEN
C Check if the H is riding, or the esd happens to be zero.          
                 IF ( ( AND(ISTORE(L+15),KBREFB(3)).GT.0 ) .OR.
     1                                   (ISTORE(JB) .LT. 0 ))THEN
                   LHFIXD(2) = .TRUE.
                 ENDIF
                ENDIF

cnov07
c          NWDT=6 or 12 =(6+6)
c          NWAT=9 or 15 =(9+6)
c          NWD=6
c          NWA=9
c          NWS=4
c          NW=13, 14 0r 15
c
c      JA > 9X4X50 = 1800                  NWA.NWS.MXPPT
C      JD > 9X9 OR 15X15 = 81 0R 225       NWAT.NWAT
C      JE > 9X9 OR 15X15 = 81 0R 225       NWAT.NWAT
C      JF > 9X9 OR 15X15 = 81 0R 225       NWAT.NWAT
C      JG = JH > 6X6 = 36                  NWD.NWD
C      JJ = JK > 9X9 = 81                  NWA.NWA
C      JM = JN > 12X12 = 36 or 144         NWDT.NWDT
C      JP = JQ > 15X15 = 81 or 225         NWAT.NWAT
c
C--SET UP THE V/CV MATRIX (6x6) AT 'JD' and diagonal weight matrix at JE
c  note the diagonal matrix at JE is now a unit matrix, and could be 
c  removed from code
c  JD is a temporary location - matrix is moved to lower right (JN) of full 
c  vCv matrix at JM
                CALL XCOVAR( JA, NWD, NWS, JD, JE, IPART, 2)
cdjwdec09
c      write(ncwu,'(a)') 'VcV matrix'
c      write(ncwu,'(6f12.9 )') (store(jd+ifeb08-1), ifeb08=1,nwd*nwd)
c      write(ncwu,'(a)') 'multipliers'
c      write(ncwu,'(6f12.4 )') (store(je+ifeb08-1), ifeb08=1,nwd*nwd)
cdjwdec09

C--SET UP THE RELEVANT SYMMETRY MATRIX  AT JH
c-- second atom only - unit matrix for 1st atom already set at JG

                CALL XMVCSP(J,JH,NWD)
C--APPLY THE weight matrix to the SYMMETRY MATRIX 
C  AND STORE THE TRANSFORMATION MATRIX AT 'JF'
c  JG is same as JH, the address of the two-block symmetry matrix
c  JF is the address of the two-block result.
                CALL XMD3B(JE,JG,JF,2,NWD)
cfeb08
c      write(ncwu,'(a,i8)') 'jf',jf
c      write(ncwu,'(6f16.12)') (store(idjw),idjw=jf,jf+35)
c      write(ncwu,'(/)')

C--MOVE THE V/CV MATRIX TO DISTANCE V/CV AREA  
c  The cell vCv matrix at JM already set by XFAL31
c  JN is pointer to start of positional vCv
c  move nwd*nwd = 6x6 items into nwdt*nwdt matrix 
c      JD, original vCv matrix
c      JN  start of vCv matrix in overall vCv matrix
c      jm  start of overall vCv matrix, cell upper left block, atoms
c          lower right
c

                CALL XMVCD(JD,NWD,JN,NWDT)
cnov07
cdjwfeb08
c      write(ncwu,'(2(a,i8))') 'jm',jm, '  jn',jn
c      write(ncwu,'(12f12.9)') (store(idjw),idjw=jm,jm+143)
c      write(ncwu,'(/)')
cdjwfeb08

C--CALCULATE 'DX','DY' AND 'DZ', store results in B(1 to 3)
c  x,y z all fractionsal, those at J+7 have symmetry applied
                CALL XSUBTR(STORE(M5A+4),STORE(J+7),B(1),3)
C--CALCULATE THE RECIPROCAL OF THE DISTANCE
                F=1./STORE(J+10)
                NY=JD
C--CHECK IF THE CELL ERRORS ARE TO BE USED
                IF(ICELL.GE.0)THEN 
C--CALCULATE THE CELL ERRORS
c  note   EQUIVALENCE (B(1),C) above
c  6-vector of derivatives d(D)/d(a) ... d(D)/d(gamma) at NY
                  CALL XAPP31(NY)
                  NY=NY+6
                END IF
C--CALCULATE THE ERROR CONTRIBUTIONS FOR ATOM ONE 
                CALL XMULTR(B(1),F,B(1),3)
C B(1) now is: Delta(X) / Distance
C Multiply by metrix tensor
                CALL XMLTMM(STORE(L1M1),B(1),BPD(4),3,3,1)
C--APPLY THE DERIVATIVE VECTOR TO THE TRANSFORMATION MATRIX
c  JF is 6x6 transformation matrix = [3x3 0] [0 3x3]
                J1=JF
                DO I1=1,3
                  STORE(NY)=   STORE(J1)*   BPD(4)+
     1                         STORE(J1+6)* BPD(5)+
     2                         STORE(J1+12)*BPD(6)
                  STORE(NY+3)=-STORE(J1+21)*BPD(4)
     1                        -STORE(J1+27)*BPD(5)
     2                        -STORE(J1+33)*BPD(6)
                  NY=NY+1
                  J1=J1+1
                END DO
C--CALCULATE THE VARIANCE
                CALL XMLTMM(STORE(JM),STORE(JD),STORE(JE),NWDT,NWDT,1)
                CALL XMLTTM(STORE(JD),STORE(JE),STORE(JF),1,NWDT,1)
C--CALCULATE THE E.S.D.
C -- CALCULATE E.S.D. FROM THE VARIANCE, PRODUCING NEGATIVE E.S.D.'S
C    FROM 'NEGATIVE VARIANCES'
                STORE(JF) = XDSESD ( STORE(JF) , STORE(JN) , NWDT )
                STORE(IJX+3)=STORE(JF)
              END IF                          ! end of esd calculation
CDJW130804
C----- SAVE THE ESD IF NECESSARY
              IF (IPUNCH .EQ. 11) STORE(J+14) = STORE(JF)
C----- COMPRESS ATOMS INTO CHARACTER FORM
              CALL CATSTR(STORE(M5P),STORE(M5P+1),1,1,0,0,0,
     1                      CATOM1,LATOM1)
              CALL CATSTR (STORE(L), STORE(L+1),
     1         ISTORE(J+2), ISTORE(J+3), ISTORE(J+4), ISTORE(J+5),
     2         ISTORE(J+6), CATOM2, LATOM2)
c
c
              IF ( IDSPDA .EQ. -1 ) THEN
                LATOM1 = MIN(10, LATOM1)
                WRITE ( CMON ,2804)
     1          CATOM1(1:LATOM1),STORE(M5P+13),STORE(J+10),CATOM2(1:25)
                CALL XPRVDU(NCVDU, 1,0)
2804    FORMAT ('^^WI ''',A,' height:',F8.2,', ',
     1                     F6.3,'A from ',A,'''')
              ENDIF

              IF (IDSPDA .EQ. 1  .OR. IDSPDA .EQ. 3 ) THEN
                LATOM1 = MIN(10, LATOM1)
                IF (STORE(JF) .GT. ZERO) THEN
                  WRITE ( CMON ,2806)
     1            CBLANK(1: 21-LATOM1), CATOM1(1:LATOM1), CATOM2(1:25),
     2            STORE(J+10), STORE(JF),(STORE(J+JAR),JAR=7,9)
                ELSE
                  WRITE ( CMON ,2807)
     1           CBLANK(1: 21-LATOM1), CATOM1(1:LATOM1), CATOM2(1:25),
     2           STORE(J+10),(STORE(J+JAR),JAR=7,9)
                ENDIF
                CALL XPRVDU(NCVDU, 1,0)
c^^djwnov06
                IF ((ISSPRT .EQ. 0) .and. (level .eq.0) )
     1          WRITE(NCWU, '(A)') CMON( 1)(:)
2806            FORMAT (A,A,' - ',A, F6.3, F6.3, 1X, 3F6.3)
2807            FORMAT (A,A,' - ',A, F6.3, 6X,   1X, 3F6.3)
              ENDIF

              IF (IPUNCH .EQ. 0) THEN
C----- WRITE RESTRAINT
                WRITE (NCPU,'(A,'' '', F7.3, '',.01= '', A,'' to '',A)')
     1          RESTR, STORE(J+13), CATOM1(1:LATOM1),
     2          CATOM2(1:LATOM2)
              ELSE IF (IPUNCH .EQ. 6) THEN
C----- WRITE RESTRAINT
                WRITE (NCPU,'(''VIBR .0, '',F7.5,'' = '',A,'' to '',A)')
     1          DDEV1, CATOM1(1:LATOM1), CATOM2(1:LATOM2)
              ELSE IF (IPUNCH .EQ. 7) THEN
C----- WRITE RESTRAINT
C Get index of atoms at L and M5P in L5.
               J51 = ( L  - L5) / MD5
               J52 = (M5P - L5) / MD5
               SDEV = SDEV1
               IF ( ISTORE(INHVEC+J51) .LE. 1 ) SDEV = SDEV2
               IF ( ISTORE(INHVEC+J52) .LE. 1 ) SDEV = SDEV2
               WRITE (NCPU,'(''U(IJ) .0, '',F7.5,'' = '',A,'' to '',A)')
     1         SDEV, CATOM1(1:LATOM1), CATOM2(1:LATOM2)
              ELSE IF (IPUNCH .EQ. 8) THEN
C----- WRITE RESTRAINT
                WRITE (NCPU,
     1  '(''NONBONDED '',F7.4,'', '',F7.4,'' = '',A,'' to '',A)')
     1          SNBVAL,SNBPOW,CATOM1(1:LATOM1),CATOM2(1:LATOM2)
              ELSE IF ((IPUNCH .EQ. 1).OR.(IPUNCH.EQ.2).OR.
     1                 (IPUNCH .EQ. 9) ) THEN
C----- CIF AND FORMATTED PUBLICATION
                IF ((IHFIXD.EQ.1).AND.(LHFIXD(1).OR.LHFIXD(2))) THEN
                  STORE(JF) = 0.0
                ENDIF
                WRITE( MTE) 'D',STORE(J+10),STORE(JF),
     1          STORE(M5A), STORE(M5A+1), 1,1,0,0,0,
C--- ATOM 2
     2          STORE(L), STORE(L+1), ISTORE(J+2),
     3          ISTORE(J+3), ISTORE(J+4), ISTORE(J+5), ISTORE(J+6),
C----- DUMMY WRITES AT END FOR COMPATIBILITY WITH TORSION
     4          IB, ZERO, 1,1,0,0,0,
     5          IB, ZERO, 1,1,0,0,0
              ELSE IF(IPUNCH.EQ.4.AND.(IDSPDA.EQ.1.OR.IDSPDA.EQ.3))THEN
                INH1 = 1+ (M5P-L5)/MD5 
                INH2 = 1+ (L-L5)/MD5
                  WRITE(NCPU,'(A,2(1X,I4),A,F7.4,2(1X,A))')
     1            'BOND ',INH1,INH2,' # ',STORE(J+10),CATOM1(1:LATOM1),
     2            CATOM2(1:LATOM2)
              ELSE IF (IPUNCH .EQ. 5) THEN
C----- WRITE SIMPLE FORM
                WRITE (NCPU,'(F7.3,2(1X,A))')
     1          STORE(J+10), CATOM1(1:LATOM1), CATOM2(1:LATOM2)
              ENDIF
C
              IF ((LEVEL2 .EQ. 0) .AND. (LEVEL .GE. 0)) THEN
C----- WRITE A CAPTION
                IF (LEVEL .EQ. 0) THEN
C                  IF (ISSPRT .EQ. 0) THEN
C                    WRITE(NCWU,2825) STORE(M5P),STORE(M5P+1)
C                  ENDIF
2825              FORMAT(/,'Pivot ',A4,F5.0)
                ELSE IF (LEVEL .GE. 1) THEN
                  IF (ISSPRT .EQ. 0) THEN
                    WRITE(NCWU,1850) STORE(M5P),STORE(M5P+1),
     1                    (STORE(MMN),MMN=M5P+4,M5P+6)
                  ENDIF
                ENDIF
                LEVEL2 = 1
              ENDIF
              IF (LEVEL.EQ.0)THEN
cdjwnov06
C----- STORE CURRENT DISTANCE IN BUFFER
c                STORE(IJX)=STORE(L)
c                STORE(IJX+1)= STORE(L+1)
c                STORE(IJX+2)=STORE(J+10)
c                IJX=IJX+4
c                IF(IJX.GT.IJY) THEN
C----- PRINT BUFFER
c                  IJX=IJX-4
C -- CHECK FOR E.S.D.
c                  IF (IESD .LT. 0) THEN
c                    IF (ISSPRT .EQ. 0) THEN
c                      WRITE(NCWU,2850)
c     1                      ((STORE(IJZ),IJZ=I1,I1+2),I1=IJW,IJX,4)
c                    ENDIF
2850                FORMAT(11X,4(5X,A4,F5.0,F7.3,6X))
c                  ELSE
c                    IF (ISSPRT .EQ. 0) THEN
c                      WRITE(NCWU,2851)
c     1                      ((STORE(IJZ),IJZ=I1,I1+3),I1=IJW,IJX,4)
c                    ENDIF
2851                FORMAT(11X,4(5X,A4,F5.0,F7.3,F6.3))
c                  ENDIF
c                  IJX=IJW
c                END IF
c
              ELSE IF ( LEVEL.GT.0 ) THEN                      !  FULL PRINT

C----- CHECK IF THE TRANSFORMED COORDINATES ARE TO BE PRINTED
                IF(IP.LT.0)THEN       

                  IF(N.LE.0)THEN        !CHECK IF THIS IS FIRST DISTANCE
C--PRINT THE CAPTION HEADING
                    IF (ISSPRT .EQ. 0) THEN
                      WRITE(NCWU,2950)IB
                    ENDIF
2950                FORMAT(/1X,A4,2X,'Atom',3X,'Serial',3X,'S(I)',
     1                     2X,'L',2X,'T(X)',1X,'T(Y)',1X,'T(Z)',A4,
     2                     25X,'X''',8X,'Y''',8X,'Z''')
                    IF (ISSPRT .EQ. 0) THEN
                      WRITE(NCWU,3100)
                    ENDIF
                  ENDIF

                  IF(IESD.LT.0)THEN       !NO ERRORS TO BE PRINTED
                    IF (ISSPRT .EQ. 0) THEN
                    WRITE(NCWU,3100)STORE(L),STORE(L+1),
     1               (ISTORE(NX+2),NX=J,M),STORE(J+10)
                    ENDIF
3100                FORMAT(7X,A4,F8.0,4X,I3,I4,3I5,F11.3,14X,3F10.5)

                  ELSE IF (ISSPRT .EQ. 0) THEN      !ERRORS TO BE PRINTED
                      WRITE(NCWU,3450)STORE(L),STORE(L+1),
     1                 (ISTORE(NY+2),NY=J,M),STORE(J+10),STORE(JF)
                  END IF

                ELSE                         !PRINT THE GENERATED COORDINATES

                  IF(N.LE.0)THEN             !CHECK IF THIS IS THE FIRST ATOM
                    IF (ISSPRT .EQ. 0) THEN
                      WRITE(NCWU,2950)IB,IB
                    ENDIF
                    IF (ISSPRT .EQ. 0) THEN
                      WRITE(NCWU,3100)
                    ENDIF
                  END IF
         
                  NX=J+2
                  IF(IESD.LT.0)THEN             !NO ERRORS TO BE PRINTED
                    IF (ISSPRT .EQ. 0) THEN
                      WRITE(NCWU,3100)STORE(L),STORE(L+1),
     1                 (ISTORE(NY+2),NY=J,M),STORE(J+10),
     2                 (STORE(NY+7),NY=J,NX)
                    ENDIF

                  ELSE IF (ISSPRT .EQ. 0) THEN    ! PRINT THE ERRORS
                    WRITE(NCWU,3450)STORE(L),STORE(L+1),
     1               (ISTORE(NY+2),NY=J,M),
     2                 STORE(J+10),STORE(JF),(STORE(NY+7),NY=J,NX)
3450                FORMAT(7X,A4,F8.0,4X,I3,I4,3I5,F11.3,F7.3,7X,3F10.5)
                  END IF
                END IF
              END IF

              N=N+1
            END IF
          END IF


C--CHECK WHETHER THIS DISTANCE IS ACCEPTABLE FOR ANGLES.
C  IF THIS IS GOOD FOR ANGLES MOVE IT UP SO THAT ALL NON-ANGLES
C  DISTANCE ENTRIES ARE EXCLUDED BY THE END OF THE DISTANCE PRINT

C--CHECK IF IT IS NECESSARY TO MOVE THE DISTANCE BLOCK
          IF(ISTORE(J+1).LT.3)CYCLE

          IF(K.NE.J)THEN
C--MOVE THE DATA
            CALL XMOVE(STORE(J),STORE(K),NW)
          ENDIF
C--UPDATE THE CURRENT LAST POINTER
          K=K+NW
         END DO PRINTLOOP
CDJWNOV06
C----- EMPTY PRINT BUFFER
         IF(IJX.GT.IJW) THEN
          IJX=IJX-4
C -- CHECK FOR E.S.D.
          IF (IESD .LT. 0) THEN
            IF (ISSPRT .EQ. 0) THEN
              WRITE(NCWU,2850) ((STORE(IJZ),IJZ=I1,I1+2),I1=IJW,IJX,4)
            ENDIF
          ELSE
            IF (ISSPRT .EQ. 0) THEN
              WRITE(NCWU,2851) ((STORE(IJZ),IJZ=I1,I1+3),I1=IJW,IJX,4)
            ENDIF
          ENDIF
         END IF
         IJX=IJW
C
C--START OF THE ANGLES PRINT LOOP
         M=1
         L = NFLBAS
         K=K-NW

C--CHECK IF ANY ANGLES REMAIN TO BE CALCULATED AND PRINTED

c        WRITE (CMON,'(A,2I8)')'Angle K and L: ',K,L
c        CALL XPRVDU(NCVDU,1,0)

         ANGLELOOP: DO WHILE ( K .GT. L )

C--CHECK IF THIS IS THE FIRST TIME OR A CONTINUATION


          IF (NFLBAS .GE. L) THEN                           ! FIRST TIME
            IF ((LEVEL2 .EQ. 0) .AND. (LEVEL .GE. 0)) THEN
C----- WRITE A CAPTION
              IF (LEVEL .EQ. 0) THEN
                IF (ISSPRT .EQ. 0) THEN
                  WRITE(NCWU,2825) STORE(M5P),STORE(M5P+1)
                ENDIF
              ELSE IF (LEVEL .GE. 1) THEN
                IF (ISSPRT .EQ. 0) THEN
                  WRITE(NCWU,1850) STORE(M5P),STORE(M5P+1),
     1              (STORE(MMN),MMN=M5P+4,M5P+6)
                ENDIF
              ENDIF
              LEVEL2 = 1
            ENDIF
Cdjwnov06^^
                IF (LEVEL .EQ. 0) THEN
                  IF (ISSPRT .EQ. 0) THEN
                    WRITE(NCWU,2825) STORE(M5a),STORE(M5a+1)
                  ENDIF
                END IF
c
            IF (LEVEL.GT.0)THEN
              IF (ISSPRT .EQ. 0) THEN
                WRITE(NCWU,4050)STORE(M5A),STORE(M5A+1)
              ENDIF
4050          FORMAT(//,' Angles about atom  ',A4,F5.0)
              IF (ISSPRT .EQ. 0) WRITE(NCWU,2950)JAKEY
            END IF

          ELSE                                              ! CONTINUATION
            IF (LEVEL.GE.0) THEN 
              IF (ISSPRT .EQ. 0) THEN
                WRITE(NCWU,3950)
              ENDIF
3950          FORMAT(//,' Continuation')
            ENDIF
            IF (LEVEL.GT.0)THEN  
              IF (ISSPRT .EQ. 0) WRITE(NCWU,2950)JAKEY
            END IF

          END IF

          IF (ISSPRT .EQ. 0) WRITE(NCWU,3100)
          N=M
          NX=L+4
          NY=ISTORE(L)

          IF (ISSPRT .EQ. 0) THEN
            IF (LEVEL.GT.0)THEN 
              WRITE(NCWU,4150)N,STORE(NY),STORE(NY+1),
     1                        (ISTORE(NZ+2),NZ=L,NX)
4150          FORMAT(I4,3X,A4,F8.0,4X,I3,I4,3I5,3X,9F8.2)
            ELSE IF (LEVEL.EQ.0) THEN
              WRITE(NCWU,4170) N,STORE(NY),STORE(NY+1)
4170          FORMAT(I4,2X,A4,F5.0,3X,13F8.2)
            END IF
          END IF


          NX=L+(NCOL-1)*NW
          NY=L+NW

c        WRITE (CMON,'(A,2I8)')'Angleprint NY and K: ',NY,K
c        CALL XPRVDU(NCVDU,1,0)

C--MAIN ANGLE PRINT AND CALCULATION LOOP
          ANGLEPRINT: DO NZ=NY,K,NW
            N=N+1
            NB=NZ-NW
            NB=MIN0(NB,NX)
            NC=0
C--CHECK IF E.S.D.'S ARE REQUIRED
            IF(IESD.GE.0)THEN
C--INSERT THE SECOND ATOM  -  ATOM (B)
              JC=JB
              CALL XFPCES( ISTORE(NZ+12), JC, NWS, IPART(2) )
c          write(ncwu,*) '2nd angle atom  M12A=',ISTORE(NZ+12), 
c     1  ' JC=',JC, NWS, IPART(2)
              LHFIXD(2) = .FALSE.
              IF((ISTORE(JB).LT.0).AND.
     1        ((ISTORE(ISTORE(NZ)).EQ.KHYD)
     2        .OR.(ISTORE(ISTORE(NZ)).EQ.KDET)) ) LHFIXD(2) = .TRUE.
              CALL XMVCSP(NZ,JK,NWA)
C--STARTING FROM THE FIRST ATOM OF THE CURRENT LIST ,
C  CALCULATE ALL THE ANGLES TO THE PRESENT ATOM
C
C  ATOM A IS AT M5A
C  ATOM B IS AT ISTORE(NZ)
C  ATOM C IS AT ISTORE(NA)
C
            END IF

            DO 5350 NA=L,NB,NW
C--CHECK THAT A AND B ARE NOT THE SAME ATOM
              IF(STORE(NZ+10).LE.CHECK)THEN   ! EITHER B OR C DUPLICATES A  
                APD(NC+1)=0.                  ! ANGLE IS SET TO 0.0
                APD(NC+2)=0.
                NC=NC+3-JU
                CYCLE
              END IF

C--CHECK THAT A AND C ARE NOT THE SAME ATOM
              IF(STORE(NA+10).LE.CHECK) THEN
                APD(NC+1)=0.
                APD(NC+2)=0.
                NC=NC+3-JU
                CYCLE
              END IF

C--CHECK THAT THE ATOM INCL/EXCL/PIV/BOND VECTORS ALLOW THIS ANGLE
C  (The pivot atom has already have been okayed - check the 2nd and 3rd)


              IA2 = (( ISTORE(NZ)  - L5 ) / MD5 )
              IA3 = (( ISTORE(NA)  - L5 ) / MD5 ) 
              IL2 = LATVC + IA2 * MDATVC
              IL3 = LATVC + IA3 * MDATVC

c              WRITE(CMON,'(A,2(A4,I4,1X))')'Bonded atoms: ',
c     1      ISTORE(ISTORE(NZ)), NINT(STORE(ISTORE(NZ)+1)),
c     2      ISTORE(ISTORE(NA)), NINT(STORE(ISTORE(NA)+1))
c              CALL XPRVDU(NCVDU,1,0)


              IF (( ISTORE(IL2+1).EQ.-1 .OR. ISTORE(IL3+2).EQ.-1) .AND.
     1            ( ISTORE(IL2+2).EQ.-1 .OR. ISTORE(IL3+1).EQ.-1)) THEN
c                WRITE(CMON,'(2(A,A4,I4))')
c     1          'Atom rejected in (angle) print:',
c     1          ISTORE(ISTORE(NZ)),NINT(STORE(ISTORE(NZ)+1)),' or ',
c     1          ISTORE(ISTORE(NA)),NINT(STORE(ISTORE(NA)+1))
c                CALL XPRVDU(NCVDU,1,0)
                CYCLE
              END IF

              NSWAP = 0
              IF ( ISTORE(IL2+1).EQ.-1 ) THEN !Swap atoms over for consistent printing
                NSWAP = 1
              ENDIF

C--COMPUTE THE COORDINATES OF 'E'  -  AE BISECTS THE ANGLE AT A.
              F=STORE(NZ+10)/STORE(NA+10)
              B(1)=0.5*(STORE(M5A+4)+STORE(NZ+7)
     1              +F*(STORE(NA+7)-STORE(M5A+4)))
              B(2)=0.5*(STORE(M5A+5)+STORE(NZ+8)
     1              +F*(STORE(NA+8)-STORE(M5A+5)))
              B(3)=0.5*(STORE(M5A+6)+STORE(NZ+9)
     1              +F*(STORE(NA+9)-STORE(M5A+6)))
C--SET L1 AS THE DISTANCES FROM A TO B
              DIST(1)=STORE(NZ+10)
              DISTSQ(1)=STORE(NZ+11)
C--COMPUTE 'DX', 'DY' AND 'DZ' FOR THE BOND B TO E.
              CALL XSUBTR(STORE(NZ+7),B(1),BPD(7),3)
C--CALCULATE THE DISTANCE BETWEEN THE TWO NON-PIVOT ATOMS
              DISTSQ(2)=XDSTN2(STORE(NZ+7),B(1))
C--CALCULATE THE DISTANCE FROM 'A' TO 'E'
              DISTSQ(3)=XDSTN2(STORE(M5A+4),B(1))
C--COMPUTE THE DISTANCES
              DO NF=2,3
                DIST(NF)=SQRT(DISTSQ(NF))
              END DO
C--CHECK IF THE POINTS 'B' AND 'E' ARE COINCIDENT
              IF(DIST(2).LE.CHECK)THEN
                APD(NC+1)=0.
                APD(NC+2)=0.
                NC=NC+3-JU
                CYCLE
              END IF

C--CALCULATE THE OUTPUT ANGLE
              F=DIST(2)/DIST(1)
C--CHECK IF THE SIN OR COS SHOULD BE USED
              IF(F.LE.SIN45)THEN
                ANGLE(2)=ASIN(F)
              ELSE
C--USE THE COS
                ANGLE(2)=ACOS(DIST(3)/DIST(1))
              END IF
              NC=NC+1
              APD(NC)=ANGLE(2)*G

C--CHECK IF THE E.S.D. IS TO BE CALCULATED
              IF(IESD.GE.0)THEN
C--CALCULATE THE E.S.D.
                NF=JC
C--ADD THE THIRD ATOM (C) INTO THE STACK
cdjwdec09
                CALL XFPCES( ISTORE(NA+12), NF, NWS, IPART(3) )
c          write(ncwu,*) '3rd angle atom  M12A=',ISTORE(NA+12), 
c     1  ' NF=',NF, NWS, IPART(3)
                LHFIXD(3) = .FALSE.
                IF ( (ISTORE(JC).LT.0).AND.
     1            ((ISTORE(ISTORE(NA)).EQ.KHYD) .OR.
     1             (ISTORE(ISTORE(NA)).EQ.KDET)) ) THEN
                  LHFIXD(3) = .TRUE.
                ENDIF
C Check if any of the atoms are hydrogens riding.
                IZZ = ISTORE(NZ)
                IXX = ISTORE(NA)
                IF (  (AND( ISTORE(M5A+15),KBREFB(3) ).GT.0).AND.
     1                ((ISTORE(M5A).EQ.KHYD).OR.
     2                 (ISTORE(M5A).EQ.KDET)  )) LHFIXD(3) = .TRUE.
                IF (  (AND( ISTORE(IXX+15),KBREFB(3) ).GT.0).AND.
     1                ((ISTORE(IXX).EQ.KHYD).OR.
     2                 (ISTORE(IXX).EQ.KDET)  )) LHFIXD(3) = .TRUE.
                IF (  (AND( ISTORE(IZZ+15),KBREFB(3) ).GT.0).AND.
     1                ((ISTORE(IZZ).EQ.KHYD).OR. 
     2                 (ISTORE(IZZ).EQ.KDET)  )) LHFIXD(3) = .TRUE.
C--CALCULATE THE V/CV MATRIX FOR THE POSITIONAL ERRORS
                CALL XCOVAR( JA, NWA, NWS, JD, JE, IPART, 3)
cdjwdec09
c      write(ncwu,'(a)') 'VcV matrix'
c      write(ncwu,'(9f12.9 )') (store(jd+ifeb08-1), ifeb08=1,nwa*nwa)
c      write(ncwu,'(a)') 'multipliers'
c      write(ncwu,'(9f12.4 )') (store(je+ifeb08-1), ifeb08=1,nwa*nwa)
cdjwdec09

C--MOVE THE V/CV MATRIX TO THE FINAL AREA, WHICH CONTAIN THE CELL ERRORS
                CALL XMVCD(JD,NWA,JQ,NWAT)
C--ADD THE SYMMETRY MATRIX OF THE LAST ATOM
                CALL XMVCSP(NA,JL,NWA)
C--APPLY THE SYMMETRY INFORMATION
                CALL XMD3B(JE,JJ,JD,3,NWA)
C--CALCULATE 'DX' ETC. FOR BOND 1 (A - B)
                CALL XSUBTR(STORE(M5A+4),STORE(NZ+7),BPD(4),3)
C--CALCULATE 'DX' ETC. FOR BOND 3 (C - A)
                CALL XSUBTR(STORE(NA+7),STORE(M5A+4),BPD(10),3)
C--SET UP THE MATRIX TO TRANFORM FROM V/CV MATRIX OF 'ABC' TO 'ABE'
                CALL XZEROF(STORE(JE),54)
C--ADD THE TRANSFORMATIONS FOR A AND B.
                STORE(JE)=1.
                STORE(JE+10)=1.
                STORE(JE+20)=1.
                STORE(JE+30)=1.
                STORE(JE+40)=1.
                STORE(JE+50)=1.
C--CALCULATE THE DERIVATIVES WITH RESPECT TO 'AB' AND 'CA'
                CALL XMLTMM(STORE(L1M1),BPD(4),STORE(JF),3,3,1)
                CALL XMLTMM(STORE(L1M1),BPD(10),STORE(JF+3),3,3,1)
C--FINISH OFF THE DERIVATIVES BY DIVIDING BY THE BOND LENGTHS
                NF=JF+2
                DO NE=JF,NF
                  STORE(NE)=STORE(NE)/STORE(NZ+10)
                  STORE(NE+3)=STORE(NE+3)/STORE(NA+10)
                END DO
                NL=JE+54
C--COMPUTE AB/AC
                F=0.5*STORE(NZ+10)/STORE(NA+10)
C--LOOP OVER THE COORDINATES OF E  -  'X' FIRST ETC..
                DO NF=1,3
                  B(1)=0.5*BPD(NF+9)/STORE(NA+11)
                  B(2)=0.5*BPD(NF+9)/STORE(NA+10)
                  B(3)=0.5*BPD(NF+9)*STORE(NZ+10)/STORE(NA+11)
                  NG=JF
C--LOOP OVER THE COORDINATES OF A, B AND C
                  DO NE=1,3
C--DERIVATIVES FOR A
                    STORE(NL)=B(1)*(STORE(NG)*STORE(NA+10)
     1                      +STORE(NZ+10)*STORE(NG+3))
C--DERIVATIVES FOR B
                    STORE(NL+3)=-B(2)*STORE(NG)
C--DERIVATIVES FOR C
                    STORE(NL+6)=-B(3)*STORE(NG+3)
                    NG=NG+1
                    NL=NL+1
                  END DO
C--ADD IN THE ODD TERMS FOR X W.R.T. X, ETC..
                  NL=NL-4+NF
                  STORE(NL)=STORE(NL)+0.5-F
                  STORE(NL+3)=STORE(NL+3)+0.5
                  STORE(NL+6)=STORE(NL+6)+F
                  NL=NL+10-NF
                END DO
C--APPLY THE TRANSFORMATION AT 'JE' TO THE TRANSFORMATION MATRIX AT 'JD'
                L1=JE
                M1=JF
                DO I1=1,NWA
                  K1=JD
                  DO J1=1,3
                    STORE(M1)=STORE(L1)*STORE(K1)
     1                       +STORE(L1+1)*STORE(K1+9)
     1                       +STORE(L1+2)*STORE(K1+18)
                    STORE(M1+3)=STORE(L1+3)*STORE(K1+30)
     1                         +STORE(L1+4)*STORE(K1+39)
     2                         +STORE(L1+5)*STORE(K1+48)
                    STORE(M1+6)=STORE(L1+6)*STORE(K1+60)
     1                         +STORE(L1+7)*STORE(K1+69)
     2                         +STORE(L1+8)*STORE(K1+78)
                    M1=M1+1
                    K1=K1+1
                  END DO
                  L1=L1+NWA
                  M1=M1+6
                END DO
C--COMPUTE 'DX', ETC., FOR THE BOND E - A.
                BPD(10)=-BPD(4)-BPD(7)
                BPD(11)=-BPD(5)-BPD(8)
                BPD(12)=-BPD(6)-BPD(9)
C
C--BEGIN TO COMPUTE THE V/CV MATRIX FOR THREE BONDS  -  AB, BE AND EA.
                I1=JE
                NF=JD
C--CLEAR THE AREA TO ZERO
                DO NE=JD,NO
                   STORE(NE)=0.
                END DO
C--ADD IN THE TERMS FOR EACH OF THE THREE BONDS IN TURN
                DO NE=1,3
                  ND=NE*3
C--MOVE 'DX' ETC.
                  CALL XMOVE(BPD(ND+1),B(1),3)
                  F=1./DIST(NE)
C--APPLY THE CELL ERRORS IF NEC.
                  IF(ICELL.GE.0)THEN
                    CALL XAPP31(I1)
                    I1=I1+6
                  END IF
                  J1=NF
                  NF=NF+IS(ND-2)
                  CALL XMULTR(B(1),F,B(1),3)
C--CALCULATE THE CONTRIBUTIONS FOR THE FIRST ATOM
                  CALL XMLTMM(STORE(L1M1),B(1),STORE(NF),3,3,1)
C--CALCULATE THE CONTRIBUTIONS FOR THE SECOND ATOM
                  NG=NF
                  NF=NF+IS(ND-1)
                  CALL XNEGTR(STORE(NG),STORE(NF),3)
                  NF=NF+IS(ND)
C--CALCULATE THE FINAL TRANSFORMATION MATRIX AND STORE IT AT JE
                  CALL XMLTTT(STORE(J1),STORE(JF),STORE(I1),1,NWA,NWA)
                  I1=I1+NWA
                END DO
C--MULTIPLY THE DERIVATIVES ONTO THE V/CV MATRIX
                CALL XMLTMM(STORE(JP),STORE(JE),STORE(JD),NWAT,NWAT,3)
                CALL XMLTTM(STORE(JE),STORE(JD),STORE(JF),3,NWAT,3)
C--CHECK IF THE SIN OR COS HAS BEEN USED
                IF(APD(NC).LT.90.)THEN
C--THE SIN WAS USED  -  ANGLE IS LESS THAN 90
                  BPD(6)=COS(ANGLE(2))
C--CALCULATE THE DERIVATIVES FOR AB AND BE.
                  BPD(4)=-2.*DIST(2)/(DISTSQ(1)*BPD(6))
                  BPD(5)=2./(DIST(1)*BPD(6))
                  BPD(6)=0.
                ELSE
C--THE COS WAS USED  -  ANGLE IS GREATER THAN 90
                  BPD(5)=SIN(ANGLE(2))
C--CALCULATE THE DERIVATIVES FOR AB AND AE
                  BPD(4)=2.*DIST(3)/(DISTSQ(1)*BPD(5))
                  BPD(6)=-2./(DIST(1)*BPD(5))
                  BPD(5)=0.
                END IF
C--CALCULATE THE VARIANCE OF THE ANGLE
                NC=NC+1
                CALL XMLTMM(STORE(JF),BPD(4),STORE(JD),3,3,1)
                CALL XMLTTM(BPD(4),STORE(JD),APD(NC),1,3,1)
C -- CALCULATE E.S.D. FROM THE VARIANCE, PRODUCING NEGATIVE E.S.D.'S
C    FROM 'NEGATIVE VARIANCES'
                APD(NC) = GS * XDSESD ( APD(NC) , STORE(JP) , NWAT )
              ENDIF
              IZZ = ISTORE(NZ)
              IXX = ISTORE(NA)
              TERM = APD(NC-1-IESD)
              IF (IESD .LT. 0) THEN
                ESD = 0.0
              ELSE
                ESD = APD(NC)
              ENDIF
C----- STRIP AND PACK ATOM NAMES
              IF ( NSWAP .EQ. 1) THEN
                 CALL CATSTR (STORE(IXX), STORE(IXX+1), ISTORE(NA+2),
     1           ISTORE(NA+3), ISTORE(NA+4), ISTORE(NA+5), ISTORE(NA+6),
     2           CATOM1, LATOM1)
                 dd1 = store(na+10)
                 ed1 = store(na+14)
                 CALL CATSTR (STORE(IZZ), STORE(IZZ+1), ISTORE(NZ+2),
     1           ISTORE(NZ+3), ISTORE(NZ+4), ISTORE(NZ+5), ISTORE(NZ+6),
     2           CATOM3, LATOM3)
                 dd3 = store(nz+10)
                 ed3 = store(nz+14)
              ELSE
                 CALL CATSTR (STORE(IXX), STORE(IXX+1), ISTORE(NA+2),
     1           ISTORE(NA+3), ISTORE(NA+4), ISTORE(NA+5), ISTORE(NA+6),
     2           CATOM3, LATOM3)
                 dd3 = store(na+10)
                 ed3 = store(na+14)
                 CALL CATSTR (STORE(IZZ), STORE(IZZ+1), ISTORE(NZ+2),
     1           ISTORE(NZ+3), ISTORE(NZ+4), ISTORE(NZ+5), ISTORE(NZ+6),
     2           CATOM1, LATOM1)
                 dd1 = store(nz+10)
                 ed1 = store(nz+14)
              END IF
              CALL CATSTR (STORE(M5A), STORE(M5A+1),
     1         1,1,0,0,0, CATOM2, LATOM2)
c
              IF ((IPUNCH .EQ. 1).OR.(IPUNCH.EQ.2).OR.
     1            (IPUNCH .EQ. 9)      ) THEN
c
C--- NOTE THAT TWO ITEMS ARE OUTPUT EVEN WHEN ESDS ARE NOT COMPUTED
                IF ((IHFIXD.EQ.1).AND.
     1                (LHFIXD(1).OR.LHFIXD(2).OR.LHFIXD(3))) ESD = 0.0
                WRITE(MTE) 'A',TERM,ESD,
     1          STORE(IXX), STORE(IXX+1), ISTORE(NA+2),
     1          ISTORE(NA+3), ISTORE(NA+4), ISTORE(NA+5), ISTORE(NA+6),
C--- PIVOT
     2          STORE(M5A), STORE(M5A+1), 1,1,0,0,0,
C--- ATOM 3
     3          STORE(IZZ), STORE(IZZ+1), ISTORE(NZ+2),
     4          ISTORE(NZ+3), ISTORE(NZ+4), ISTORE(NZ+5), ISTORE(NZ+6),
C--- DUMMY
     5          IB, ZERO, 1,1,0,0,0
CDJW160804
cdjwnov06
cdjwmar07
              else if ((ipunch .eq. 11) .and. (term .ge. 120.) .and.
     1          ((dd1.lt.1.2).or.(dd3.lt.1.2))   ) then
c   HYDROGEN BONDS
c
c
      if (lhfixd(3)) then
        if (dd1 .le. dd3) then
            ed1 = 0
        else
            ed3 = 0
        endif
      endif
CRIC2015:Ignore ESD on DH-A angles with constrained atoms.
                IF ((IHFIXD.EQ.1).AND.
     1                (LHFIXD(1).OR.LHFIXD(2).OR.LHFIXD(3))) ESD = 0.0
c
                WRITE(MTE) 'H',TERM,ESD,
c--- ATOM 2
     1          STORE(IXX), STORE(IXX+1), ISTORE(NA+2),
     1          ISTORE(NA+3), ISTORE(NA+4), ISTORE(NA+5), ISTORE(NA+6),
C--- PIVOT HYDROGEN
     2          STORE(M5A), STORE(M5A+1), 1,1,0,0,0,
C--- ATOM 3
     3          STORE(IZZ), STORE(IZZ+1), ISTORE(NZ+2),
     4          ISTORE(NZ+3), ISTORE(NZ+4), ISTORE(NZ+5), ISTORE(NZ+6),
C--- OTHER BONDS AND ESDS
     5          DD1, ED1, DD3,ED3,0.,0.,0.
C
C       
              ELSE IF(IPUNCH.EQ.4.AND.(IDSPDA.EQ.2.OR.IDSPDA.EQ.3)) THEN
                INH1 = 1+  (M5A-L5)/MD5
                INH2 = 1+ (IZZ-L5)/MD5 
                INH3 = 1+ (IXX-L5)/MD5 
                  WRITE(NCPU,'(A,3(1X,I4),A,F7.2,3(1X,A))')
     1            'ANGLE ',INH1,INH2,INH3,' # ',TERM,
     2            CATOM2(1:LATOM2),CATOM1(1:LATOM1),CATOM3(1:LATOM3)
              ELSE IF (IPUNCH .EQ. 0) THEN
                NANG = NINT (TERM)
                WRITE(NCPU,
     1          '(''ANGL '',I3,'',1= '',A,'' to '',A,'' to '',A)')
     1          NANG,CATOM1(1:LATOM1),CATOM2(1:LATOM2),CATOM3(1:LATOM3)
              ELSE IF (IPUNCH .EQ. 6) THEN
C----- WRITE RESTRAINT
                WRITE (NCPU,'(''VIBR .0, '',F7.5,'' = '',A,'' to '',A)')
     1          DDEV2, CATOM1(1:LATOM1), CATOM3(1:LATOM3)
              ELSE IF (IPUNCH .EQ. 5) THEN
                WRITE(NCPU,'(F7.2,3(1X,A))')
     1          TERM,CATOM1(1:LATOM1),CATOM2(1:LATOM2),CATOM3(1:LATOM3)
              ENDIF
              IF (IDSPDA .GE. 2 ) THEN
                CBUFF = ' '
                NANG = MAX((12 - LATOM2) /2, 1)
                CBUFF(NANG:NANG+LATOM2-1) = CATOM2(1:LATOM2)
                IF( ESD .GE. ZERO) THEN
                  WRITE(CMON,5348)
     1             CBLANK(1: 21-LATOM1), CATOM1(1:LATOM1), CBUFF(1:12),
     2             CATOM3(1:21), TERM, ESD
                ELSE
                  WRITE(CMON,5348)
     1             CBLANK(1: 21-LATOM1), CATOM1(1:LATOM1), CBUFF(1:12),
     2             CATOM3(1:21), TERM
                ENDIF
                CALL XPRVDU(NCVDU, 1,0)
              ENDIF
5348          FORMAT (1X,A, A, ' to ', A, ' to ', A,  F7.2, F5.2)

5350        CONTINUE

            ND=ISTORE(NZ)
            NE=NZ+4

C--CHECK IF THE E.S.D.'S ARE TO BE PRINTED
            IF(IESD.LT.0 .AND. ISSPRT.EQ.0)THEN
C--NO ERRORS TO BE PRINTED
              IF (LEVEL.EQ.0)THEN
                WRITE(NCWU,4170)N,STORE(ND),STORE(ND+1),
     1                             (APD(NF),NF=1,NC)
              ELSE IF (LEVEL.GT.0) THEN
                WRITE(NCWU,4150)N,STORE(ND),STORE(ND+1),
     1               (ISTORE(NF+2),NF=NZ,NE),(APD(NF),NF=1,NC)
              ENDIF
            ELSE IF ( ISSPRT .EQ. 0 ) THEN
C--PRINT WITH ERRORS
              IF (LEVEL.EQ.0)THEN
                WRITE(NCWU,5520)N,STORE(ND),STORE(ND+1),
     1                                       (APD(NF),NF=1,NC)
5520            FORMAT(I4,2X,A4,F5.0,3X,7(F8.2,F6.2))
              ELSE IF ( LEVEL .GT. 0 ) THEN
                WRITE(NCWU,5500)N,STORE(ND),STORE(ND+1),
     1               (ISTORE(NF+2),NF=NZ,NE),(APD(NF),NF=1,NC)
5500            FORMAT(I4,3X,A4,F8.0,4X,I3,I4,3I5,3X,5(F8.2,F6.2))
              END IF
            ENDIF
          END DO ANGLEPRINT

          DO NA=1,NC
             IAPD(NA)=NA+M-1
          END DO
C--CHECK FOR E.S.D.'S
          IF(IESD.LT.0)THEN
C--NO E.S.D.'S
            IF (LEVEL.GT.0 .AND. ISSPRT .EQ. 0)THEN
              WRITE(NCWU,5700)JAKEY,(IAPD(NA),NA=1,NC)
5700          FORMAT(/1X,A4,41X,9I8)
            ELSE IF (LEVEL.EQ.0 .AND. ISSPRT.EQ.0) THEN
              WRITE(NCWU,5500)
            END IF
          ELSE
C--E.S.D.'S HAVE BEEN PRINTED
            NC=NC/2
            IF (LEVEL.GT.0 .AND. ISSPRT.EQ.0)THEN 
              WRITE(NCWU,5800)JAKEY,(IAPD(NA),NA=1,NC)
5800          FORMAT(/1X,A4,41X,I9,4I14)
            ELSE IF (LEVEL.EQ.0 .AND. ISSPRT.EQ.0) THEN
            WRITE(NCWU,5500)
            ENDIF
          ENDIF
          M=M+NCOL
          L=L+NCOL*NW

         END DO ANGLELOOP
        END DO PARTLOOP
      END DO MAINLOOP



C --                   **** MAIN LOOP COMPLETED ****



C -- WRITE PUBLICATION LISTING
      IF (IPUNCH .EQ. 0) THEN
C----- FINISH RESTRAINT LIST
        CALL XPCHUS(ncpu)
      ELSE IF (IPUNCH .EQ. 1) THEN
        CALL XPRTDA(3,IESD,NCPU)
      ELSE IF (IPUNCH .EQ. 2) THEN
C----- CIF
        CALL XPRTDA(13,IESD,NCPU)
      ELSE IF (IPUNCH .EQ. 11) THEN
C----- H-CIF
        CALL XPRTDA(15,IESD,NCPU)
      ELSE IF (IPUNCH .EQ. 9) THEN
C----- HTML
        CALL XPRTDA(23,IESD,NCPU)
      ENDIF
C
C--TERMINATION MESSAGES
6050  CONTINUE
      CALL XOPMSG ( IOPDIS, IOPEND, IVERSN )
      CALL XTIME2(2)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDIS , IOPABN , 0 )
      GO TO 6050
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDIS , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
C -- INSUFF. CORE
      CALL XOPMSG ( IOPDIS , IOPSPC , 0 )
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,9921)  K
      ENDIF
9921  FORMAT(1X, I10, ' Contacts to current atom.' )
      GO TO 9900
C
      END
C
C
C
C
C
C
CODE FOR XDSSEL
      SUBROUTINE XDSSEL ( IFUNC , MDFUNC , NFUNC , IMARK , KATV )
C
C
C      IFUNC(MDFUNC,NFUNC)  FUNCTION VECTORS. IFUNC(1,*) IS MARKED WITH
C                           THE FLAG TO INDICATE WHETHER ATOM IS TO BE
C                           INCLUDED
C      IMARK        MARK TO PLACE IN FUNCTION VECTOR FOR ATOMS INDICATED
C                   BY INPUT
C      KATV(MDFUNC) VECTOR INDICATING WHICH VECTORS TO UPDATE
C                    1 - UPDATE
C                    0 - LEAVE ALONE
C
      DIMENSION IFUNC(MDFUNC,NFUNC)
      DIMENSION KATV(MDFUNC)
      LOGICAL SETTHS

      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'QSTORE.INC'


C -- SEARCH INPUT FOR TYPE/ATOM SPECIFIERS

1000  CONTINUE
      ISAVME = ME
      ISAVMF = MF

      IF ( ME .LE. 0 ) GO TO 9000
      IF ( ISTORE(MF) .GE. 0 ) GO TO 9910

C -- CHECK FOR A ATOM HEADER
      ITYPE = ISTORE(MF+2)
      ME = ME - 1
      MF = MF + LK2
      IOPER = 1
      LSCAN = L5
      MSCAN = L5 + ( N5 - 1 ) * MD5

C -- TRY FOR '(', INDICATING AN ATOM SPECIFICATION
      IF ( KOP(6) .EQ. 0 ) THEN
        ME = ISAVME
        MF = ISAVMF
        IN = 0
        ISTAT = KATOMU ( IN )
        IF ( ISTAT .LE. 0 ) GO TO 9000
        IOPER = 2
        LSCAN = M5A
        MSCAN = LSCAN + ( N5A - 1 ) * MD5A
      ENDIF

      MFUNC = 1 + ( LSCAN - L5 ) / MD5

      DO J = LSCAN , MSCAN , MD5
        SETTHS = .FALSE.

        IF ( IOPER .EQ. 1 ) THEN
          SETTHS = ( ISTORE(J) .EQ. ITYPE )
        ELSE
          SETTHS = .TRUE.
        ENDIF


        DO I = 1,MDFUNC
          IF ( ( KATV(I) .NE. 0 ).AND.( SETTHS ) ) THEN
            IFUNC(I,MFUNC) = IMARK
          ENDIF
        END DO

        MFUNC = MFUNC + 1
      END DO

C -- CHECK FOR ',' BETWEEN ARGUMENTS
      ISTAT = KOP ( 8 )

      GO TO 1000


9000  CONTINUE
      RETURN

9910  CONTINUE
      CALL XILOPD ( ISTORE(MF+1) )
      CALL XERHND ( IERWRN )
      GO TO 9000
      END


CODE FOR XDSESD
      FUNCTION XDSESD ( VARIAN , VCVMAT , NVCV )
C
C -- CALCULATE AN E.S.D. FROM A VARIANCE.
C
C    E.S.D.                  ACTION
C    ------                  ------
C    LESS THEN 'TOLER'       A WARNING MESSAGE AND THE VARIANCE-
C                            COVARIENCE MATRIX ARE PRINTED
C    'TOLER' TO 'ZERO'       THE E.S.D. IS SET TO 0.0. NO MESSAGE IS
C                            PRODUCED
C    GREATER THAN 'ZERO'     E.S.D. OK
C
C      'TOLER' IS A SMALL NEGATIVE REAL NUMBER WHICH GIVES A LIMIT TO
C      THE RANGE OF VALUES ASSUMED TO BE ROUNDING ERRORS ON '0.0'
C
      DIMENSION VCVMAT(NVCV,NVCV)
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      DATA TOLER / -1.0E-5 /
C
      XDSESD = SIGN (  SQRT ( ABS ( VARIAN ) )  ,  VARIAN )
C
      IF ( XDSESD .LT. TOLER ) THEN
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 1005 ) XDSESD , IB
      ENDIF
        WRITE ( CMON , 1005 ) XDSESD
        CALL XPRVDU(NCVDU, 1,0)
1005    FORMAT ( 1X , 'Negative e.s.d. output ' , F14.10 , A1 , / ,
     2 1X , 'Variance-covariance matrix follows' )
C
        DO 1100 I = 1 , NVCV
      IF (ISSPRT .EQ. 0) THEN
          WRITE ( NCWU , 1015 ) ( VCVMAT(J,I) , J = 1 , NVCV )
      ENDIF
1015      FORMAT ( 1X , 1P , 3 ( 3E13.4 , 5X ) )
1100    CONTINUE
C
        CALL  XERHND ( IERWRN )
C
      ELSE IF ( XDSESD .LT. ZERO ) THEN
        XDSESD = 0.0
      ENDIF
C
      RETURN
      END
C
C
C
C
C
C
CODE FOR XCOND
      SUBROUTINE XCOND
C--CONDENSE A LIST 5 OR LIST 10 AND ASSEMBLE MOLECULAR RESIDUES
C
C
C  IACT    OPERATION - SET IN COMMAND FILE
C          -1 FOR #PEAKS
C           0 FOR #PEAKS
C           1 FOR #REGROUP
C
C  ITYPE   TYPE OF ATOMS TO BE MODIFIED
C           -1 FOR ALL
C            0 FOR PEAKS ONLY
C
C  LN1    INPUT LIST TYPE
C  LN2    OUTPUT LIST TYPE
C  D1     ELIMINATE ATOMS OR PEAKS CLOSER THAN 'D1' TO THE CURRENT ATOM
C  D2     CONTACT DISTANCE FOR ATOM MOVING AND FRAGMENT ASSEMBLY
C  NATOM  THE MAXIMUM NUMBER OF ATOMS THAT THE FINAL LIST CAN CONTAIN
C  ILIST   THE LIST CONTROL FLAG :
C
C          -1  DO NOT LIST THE MOVED OR DELETED ATOMS.
C           0  LIST THE MOVED OR DELETED ATOMS.
C
C  D3      THE MAXIMUM DISTANCE THAT IS ALLOWED WHEN FOURIER TYPE
C          COORDINATE CORRECTIONS ARE TO BE MADE.
C  AMULT   THE FOURIER TYPE CORRECTION MULTIPLIER.
C  IREF    THE FOURIER TYPE CORRECTION CONTROL FLAG :
C
C          -1  MAKE NO CORRECTIONS.
C           0  MAKE ANY SUITABLE CORRECTIONS.
C
C--THE COMMON BLOCK /XWORKA/ IS USED :
C
C  JB  ADDRESS OF THE TEMP. STORAGE FOR ATOMS
C  JC  ADDRESS OF THE ATOM HEADER FOR MOVING ATOMS FROM 'JB'
C  JD  WORK SPACE FOR 'KATOMS'
C  JE  START OF DISTANCE STACK.
C  JF  NUMBER OF ATOMS LEFT TO SCAN
C  JG  CURRENT LAST ENTRY IN LIST 5 OR 10
C  JH  MD5-1
C  JI  MD5+MD5
C  JK  ZERO FOR THE FIRST OPERATION FOR THE CURRENT PIVOT ATOM,
C      ELSE NON-ZERO.
C  JL  ZERO FOR THE FIRST OPERATION FOR THE CURRENT CALL,
C      ELSE NON-ZERO.
C
C--
      INCLUDE 'ISTORE.INC'
C
      DIMENSION IAPD(13), PROCS(16)
      DIMENSION JPEAK(1)
C
      CHARACTER*8 CDELET , CMOVED , CCORRE
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
C
      INCLUDE 'XPROCC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (DISTS(1),PROCS(1))
      EQUIVALENCE (D1,DISTS(2)),(D2,DISTS(4))
      EQUIVALENCE (APD(1),IAPD(1))
C
C
      DATA IDIMN /16/
C
      DATA IVERSN / 303 /
C
      DATA CDELET / 'Deleted ' / , CMOVED / ' Moved  ' /
      DATA CCORRE / 'Corrects' /
      DATA TOLER / .2 /
C
#if !defined(_HOL_) 
      DATA JPEAK(1) /'Q   '/
      DATA KHYD /'H   '/
      DATA KDET /'D   '/
#else
      DATA JPEAK(1) /4HQ   /
      DATA KHYD /4HH   /
      DATA KDET /4HD   /
C
C--CALLL THE TIMING FUNCTION
#endif
      CALL XTIME1(2)
C -- READ THE REST OF THE INSTRUCTIONS AND CHECK FOR ERRORS
      IF (   KRDDPV ( PROCS(1) , IDIMN )    .LT.   0   ) GO TO 9910
C--LOAD A FEW PIECES OF DATA
      AT=DISTS(1)
      AC=AMAX1(DISTS(2),D3)
      BT=DISTS(3)
      BC=DISTS(4)
      JFNVC = 0
      IF ( BC .LT. 0.0 ) THEN
C----- LOAD THE FUNCTION VECTOR WITH RADIUS 1 (VDW)
        JFNVC = 1
        IRDUS = 1
C----- LOAD LIST 29
        CALL XFAL29
        TOLER = - BC
      END IF
C--LOAD THE INPUT LIST
      LN1=KTYP05(LN1)
      CALL XLDR05(LN1)
      IF ( IERFLG .LT. 0 ) GO TO 9900

      I29=L29 + (N29-1)*MD29
      I5 = L5 + (N5-1)*MD5

      IF ( JFNVC .EQ. 1 ) THEN
C----- ALLOCATE A RADIUS VECTOR
        MDFNVC = 1
        NFNVC = N5
        I=N5*MDFNVC
        LFNVC = KSTALL (I)
        CALL XZEROF ( ISTORE(LFNVC) , I )
        IDEFFN = 0
        I29=L29 + (N29-1)*MD29
        BMAX = 0.
        DO M29= L29,I29,MD29
          BMAX = AMAX1( BMAX, STORE(M29+IRDUS))
        END DO
        BMAX=2.*BMAX + TOLER
        AT = 0.
        AC = BMAX
        BT = 0.
        BC = BMAX
        D2 = BMAX
      END IF

      CALL XDIST2

C----- REDUCE SYMMETRY IF NECESSARY
      CALL KSYMOD (ISYMOD, IC, IL, N2P, L2C, L2, N2, MD2)

C--FIND THE OUTPUT LIST TYPE
      LN2=KTYP05(LN2)
C----- FIDDLE THINGS FOR 'AVERAGE'. CHECKED VALUES OF D1 AND D3 ARE
C      IN COMMANDS.SRC
      IF (ITYPE .EQ. 1) THEN
            IF (ABS(D1-0.5) .LE. ZERO) D1 = VALUE
            IF (ABS(D3) .LE. ZERO) D3 = .5
      ENDIF
C--CHECK IF FOURIER TYPE REFINEMENT IS REQUIRED
      IREF=-1
C--CHECK THE CONTACT DISTANCE GIVEN
      IF(D3-ZERO)1200,1200,1100
C--FOURIER REFINEMENT IS REQUIRED
1100  CONTINUE
      IREF=0
C--CHECK IF A MULTIPLIER HAS BEEN GIVEN
      IF (AMULT + 99.) 1150, 1150, 1200
C--ASSIGN THE DEFAULT MULTIPLIER
1150  CONTINUE
      AMULT=FLOAT(2-IC)
C--SET A FEW CONSTANTS
1200  CONTINUE
      JT=12
      L12=-1
      M12=-1
C--SET UP A FEW STACK CONSTANTS
      JB=NFL
      JC=JB+MD5
      JD=JC+20
      JE=JD+30
C--CHECK THE STORE AREA
      IF ( JE - LFL ) 1350 , 9920 , 9920
C--SET UP A FEW CONSTANTS FOR THE PASSAGE THROUGH THE ATOMS
1350  CONTINUE
      M5A=L5
      MFNVCA = LFNVC
      JF=N5
      JG=L5+(N5-1)*MD5
      JL=0
      SEQ=1.0
C
cdjwoct2001
      ifrag = 0
C--SET UP THE CONTROL VARIABLES FOR THIS PASS AND CHECK IF ANY ATOMS ARE
1400  CONTINUE

      IF ( JFNVC .EQ. 1 ) THEN
C Reform radius vector every time, as atom list is shifting.
        MFNVC = LFNVC
        DO M5=L5,I5,MD5
          JZ = L29 + IRDUS    !IF NO MATCH - POINT TO DEFAULT (FIRST) ATOM
          DO M29= L29,I29,MD29
            IF (ISTORE(M5) .EQ. ISTORE(M29)) THEN
              JZ=M29+IRDUS
              EXIT
            END IF
          END DO
          STORE(MFNVC) = STORE(JZ)
          MFNVC = MFNVC + MDFNVC
        END DO
      END IF

      M5=M5A+MD5
      MFNVC = MFNVCA+MDFNVC
      JF=JF-1
      IF(JF)3400,3400,1450
C--CHECK THE REMAINING ATOMS WITH THE CURRENT PIVOT
1450  CONTINUE
cdjwoct2001
      if (igroup .ge. 0) then
       if (istore(m5a+16) .le. 0) then
            ifrag = ifrag+1
            istore(m5a+16)=ifrag*1000
       endif
      endif
      NFL=JE
      JJ=M5
C -- CHECK SPACE AVAILABLE
      IF (KDIST1( JF, J, JT, JFNVC, TOLER, ITRANS,0,4,0)) 9920,3350,1550
C--REMOVE DUPLICATE ENTRIES FOR EACH ATOM, LEAVING THE MIN. CONTACT DIST
1550  CONTINUE
      NFL=J
      I=JE
      JS=JE
C--CHECK IF THERE ARE ANY MORE ATOMS IN THE STACK
1600  CONTINUE
      IF(I-J)1650,2000,2000
C--BEGIN THE SEARCH FOR ALL CONTACTS TO THIS CURRENT ATOM
1650  CONTINUE
      E=STORE(I+10)
      K=I
C--CHECK IF THERE ARE ANY MORE ATOMS IN THE STACK
1700  CONTINUE
      IF(I-J)1750,1950,1950
C--CHECK IF THIS IS THE SAME ATOM
1750  CONTINUE
      IF(ISTORE(I)-ISTORE(K))1950,1800,1950
C--CHECK THE DISTANCE
1800  CONTINUE
      IF(STORE(I+10)-E)1850,1900,1900
1850  CONTINUE
      E=STORE(I+10)
      K=I
C--MOVE TO THE NEXT ATOM
1900  CONTINUE
      I=I+JT
      GOTO 1700
C--MOVE THE STACK INFORMATION
1950  CONTINUE
      CALL XMOVE(STORE(K),STORE(JS),JT)
      K=K+JT
      JS=JS+JT
      GOTO 1600
C--CHECK IF ANY ATOMS HAVE BEEN FOUND
2000  CONTINUE
      IF(JS-JE)3350,3350,2050
C--ATOMS FOUND  -  CHECK FOR ATOMS TO BE DELETED
2050  CONTINUE
      JK=0
      JS=JS-JT
      IPOINT=NOWT
      IF (IACT) 2100, 2100, 3000
C-----  CONDENSING A PEAKS OR ATOM LIST
C--CHECK IF FOURIER TYPE REFINEMENT IS BEING DONE
2100  CONTINUE
      IF(IREF)2450,2150,2150
C--CHECK THAT THE PIVOT IS AN ATOM AND NOT A PEAK
2150  CONTINUE
      IF(KCOMP(1,JPEAK(1),STORE(M5A),1,MD5A))2200,2200,2450
C--NOT A PEAK  -  SEARCH FOR AN ACCEPTABLE CONTACT
2200  CONTINUE
      E=D3
C--LOOP OVER ALL THE ATOMS
      DO 2400 I=JE,JS,JT
      K=ISTORE(I)
C----- ONLY INSIST THE CONTACT IS A PEAK DURING CONDENSING OR
C      FOURIER REFINEMENT
      IF (ITYPE .NE. 1) THEN
       IF(KCOMP(1,JPEAK(1),STORE(K),1,MD5A))2400,2400,2250
      ENDIF
C--CHECK THAT THE TWO HAVE THE SAME OCCUPANCY
2250  CONTINUE
      IF(ABS(XOCC(K)-XOCC(M5A))-ZERO)2300,2300,2400
C--COMPARE THE CURRENT MINIMUM DISTANCE
2300  CONTINUE
      IF(STORE(I+10)-E)2350,2400,2400
C--DISTANCE IS OKAY TOO  -  ALTER THE POINTERS
2350  CONTINUE
      E=STORE(I+10)
      IPOINT=I
2400  CONTINUE
C--ELIMINATE UNWANTED ATOMS
2450  CONTINUE
C----- SAVE THE POINTERS IN CASE WE NEED TO REGROUP ATOMS
      JSS = JE
      JJS = J
      DO 2950 I=JE,JS,JT
C----- GET THE ADDRESS IN LIST 10
      KKKI = ISTORE(I)
C--UPDATE THE ATOM ADDRESS
      ISTORE(I)=ISTORE(I)+JK
C--CHECK IF THIS PEAK SHOULD BE USED TO CORRECT THE COORDS.
      IF(IPOINT-I)2600,2500,2600
C--CORRECTING PEAK  -  MOVE ALONG THE COORDINATES
2500  CONTINUE
      K=I
      L=M5A
      DO 2550 M=1,3
      IF (ITYPE .EQ. 1) THEN
C       'AVERAGE'
        STORE(L+4) = 0.5 * (STORE(L+4) + STORE(K+7))
      ELSE
C       'REFINE'
        STORE(L+4)=STORE(L+4)+AMULT*(STORE(K+7)-STORE(L+4))
      ENDIF
      K=K+1
      L=L+1
2550  CONTINUE
C---- REPLACE ATOM HEIGHT BY CORRESPONDING PEAK HEIGHT
      IF( (KCOMP(1,JPEAK(1),STORE(KKKI),1,MD5A) .GE. 1) .AND.
     1 (MD5A .GE. 14) ) STORE(M5A+13) = STORE(KKKI+13)
C--PRINT THE DETAILS IF NECESSARY
      CALL XPRTCD ( I , J , CCORRE )
      GOTO 2700
C--CHECK IF THIS ATOM SHOULD BE DELETED
2600  CONTINUE
      IF( STORE(I+10) - D1) 2650,2650, 2900
C--CHECK FOR LISTING WITH THIS CALL
2650  CONTINUE
      IF ( ITYPE .EQ. 0) THEN
C----- ONLY DELETE PEAKS.
        K = ISTORE(I)
        IF ( KCOMP(1, JPEAK(1), STORE(K), 1, MD5A) .LE. 0) GOTO 2900
      ENDIF
      CALL XPRTCD ( I , J , CDELET )
C--CHECK IF THIS ATOM IS AT THE BOTTOM
2700  CONTINUE
      IF(J-JG)2750,2850,2850
C--MOVE THE STACK UP INTO THE SLOT FOR THIS ATOM
2750  CONTINUE
      K=J+MD5
      DO 2800 L=K,JG,MD5
      CALL XMOVE(STORE(L),STORE(J),MD5)
      J=J+MD5
2800  CONTINUE
      JK=JK-MD5
C--UPDATE THE VARIOUS POINTERS
2850  CONTINUE
      JF=JF-1
      JG=JG-MD5
      N5=N5-1
C--MARK THE ATOM AS DELETED IN THE STACK
      STORE(I+10)=-1.
2900  CONTINUE
      JSS = JSS + JT
2950  CONTINUE
C----- RESTORE POINTERS
      JS = JSS - JT
      J  = JJS
      IF (IACT) 3350, 3000, 3000
C
C--BEGIN MOVING NON-DELETED ATOMS
3000  CONTINUE
      NFL=JD
C--MAIN ATOM MOVING LOOP
      DO I=JE,JS,JT
        IF (STORE(I+10) .LE. -1.) CYCLE
        IF(STORE(I+10).GT.D2)CYCLE
C--CHECK IF WE ARE PRINTING THE MOVED ATOMS
        CALL XPRTCD ( I , J , CMOVED )
        JK=-1
C--SHIFT THE SYMMETRY OPERATORS TO THE HEADER PLACE
        CALL XMOVE(STORE(I+2),STORE(JC+7),5)
C--SHIFT THE ATOM TO TEMP. STORAGE
        CALL XMOVE(STORE(J),STORE(JB),MD5)
C--MOVE THE REST OF THE ATOMS DOWN TO MAKE ROOM FOR THIS ATOM AT THE TOP
        K=J
        L=J-MD5
        DO WHILE (L.GE.JJ)             !CHECK IF WE HAVE REACHED THE TOP
          CALL XMOVE(STORE(L),STORE(K),MD5)     !MOVE THE NEXT ATOM DOWN
          K=K-MD5
          L=L-MD5
        END DO

C--MOVE THE NEW ATOM FROM TEMP. STORAGE TO THE TOP OF THE STACK
cdjwoct2001
        if (igroup .ge. 0) then
         if (istore(jb+16) .le. 0) istore(jb+16)=ifrag
        endif
        JJ=KATOMS(JC,JB,JJ)
      END DO

C--UPDATE FOR THE NEXT PIVOT ATOM
3350  CONTINUE
      IF(ISEQ)3370,3360,3355
C--CHANGE THE SERIAL NUMBER
3355  continue
c----- check for H or D
      if ((istore(m5a).eq.khyd) .or. (istore(m5a).eq.kdet)) goto 3370
3360  CONTINUE
      STORE(M5A+1)=SEQ
      SEQ=SEQ+1.0
C--UPDATE THE POINTER
3370  CONTINUE
      M5A=M5A+MD5
      MFNVCA=MFNVCA+MDFNVC
      GOTO 1400
C
C--END OF THE CONDENSING LOOP  -  OUTPUT THE NEW LIST
3400  CONTINUE
C----- WE MUST ASLO CHECH THE LAST ATOM
      IF(ISEQ) 3430,3420,3420
3420  CONTINUE
C----- UPDATE SERIAL NUMBER OF LAST ATOM
      STORE(M5A+1)=SEQ
3430  CONTINUE
      IF(N5 .GT. NATOM) THEN
C--THE LIST MUST BE SHORTENED
3450  CONTINUE
      N=N5-NATOM
      WRITE ( CMON ,3451)NATOM, N5
      CALL XPRVDU(NCVDU, 1,0)
3451  FORMAT(' First', I5, ' atoms kept out of', I6, ' found')
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3500)N,NATOM
      ENDIF
3500  FORMAT(//,' The following',I5,
     2 '  atom(s) have been omitted to reduce',
     3 ' the number of atoms to',I5/)
      CALL XERHND ( IERWRN )
      J=L5+NATOM*MD5
      K=L5+(N5-1)*MD5
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3550)(ISTORE(I),STORE(I+1),I=J,K,MD5)
      ENDIF
3550  FORMAT((5(3X,A4,F8.0,7X)))
      N5=NATOM
C--PRINT THE NEW ATOM TOTAL
      ELSE
3600  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,3650)N5
      ENDIF
      WRITE ( CMON ,3650) N5
      CALL XPRVDU(NCVDU, 1,0)
3650  FORMAT(' List now contains ',I5,' atoms')
      ENDIF
C--CREATE THE OUTPUT LIST TYPE WHERE NECESSARY
      N=N5
      NEW=1
      CALL XCPYL5(LN1,LN2,N,NEW)
C--OUTPUT THE LIST TO THE DISC
      CALL XSTR05(LN2,0,NEW)
C
C
3720  CONTINUE
C
C -- FINAL MESSAGES
C
      CALL XOPMSG ( IOPREF, IOPEND, IVERSN )
C
      CALL XTIME2(2)
      CALL XCSAE
      CALL XRSL
      RETURN
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPREF , IOPABN , 0 )
      GO TO 3720
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPREF , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
C -- INSUFFICIENT SPACE
      CALL XOPMSG ( IOPREF , IOPSPC , 0 )
      GO TO 9900
      END
C
CODE FOR XCOLL
      SUBROUTINE XCOLL
C----- COLLECT
C--CONDENSE A LIST 5 OR LIST 10 AND ASSEMBLE MOLECULAR FRAGMENTS
C
C  LN1    INPUT LIST TYPE
C  LN2    OUTPUT LIST TYPE
C  ILIST   THE LIST CONTROL FLAG :
C          -1  DO NOT LIST THE MOVED OR DELETED ATOMS.
C           0  LIST THE MOVED OR DELETED ATOMS.
C  TOLER   THE TOLLERANCE ADDED TO SUM OF RADII FOR BOND LIMIT
C  ITYPE    ALL(-1) OR PEAKS ONLY(0) ONLY ATOMS (1)
C
C--THE COMMON BLOCK /XWORKA/ IS USED :
C
C  JB  ADDRESS OF THE TEMP. STORAGE FOR ATOMS
C  JC  ADDRESS OF THE ATOM HEADER FOR MOVING ATOMS FROM 'JB'
C  JD  WORK SPACE FOR 'KATOMS'
C  JE  START OF DISTANCE STACK.
C  JF  NUMBER OF ATOMS LEFT TO SCAN
C  JG  CURRENT LAST ENTRY IN LIST 5 OR 10
C  JH  MD5-1
C  JI  MD5+MD5
C  JK  ZERO FOR THE FIRST OPERATION FOR THE CURRENT PIVOT ATOM,
C      ELSE NON-ZERO.
C  JL  ZERO FOR THE FIRST OPERATION FOR THE CURRENT CALL,
C      ELSE NON-ZERO.
C
C--
      INCLUDE 'ISTORE.INC'
C
      DIMENSION IAPD(13), PROCS(16)
C
      CHARACTER*8 CMOVED
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
C
      INCLUDE 'XPROCC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (DISTS(1),PROCS(1))
      EQUIVALENCE (TOLER,DISTS(4))
      EQUIVALENCE (APD(1),IAPD(1))
C
C
      DATA IDIMN /16/
C
      DATA CMOVED / ' Moved  ' /
C
#if !defined(_HOL_) 
      DATA IQPEAK/'Q   '/
      DATA ICPEAK/'QC  '/
#else
      DATA IQPEAK/4HQ   /
      DATA ICPEAK/4HQC  /
C
C--CALLL THE TIMING FUNCTION
#endif
      CALL XTIME1(2)
C -- READ THE REST OF THE INSTRUCTIONS AND CHECK FOR ERRORS
      IF (   KRDDPV ( PROCS(1) , IDIMN )    .LT.   0   ) GO TO 9910
C
#if defined(_PPC_) 
CS***
      CALL SETSTA( 'Collect' )
      CALL nextcursor
CE***
C--LOAD THE INPUT LIST
#endif
      LN1=KTYP05(LN1)
      CALL XLDR05(LN1)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--FIND THE OUTPUT LIST TYPE
      LN2=KTYP05(LN2)
C
C----- ALLOCATE FUNCTION VECTORS TO HOLD RADII OF EACH ATOM AND STATUS

C----- ALLOCATE A RADIUS VECTOR
      MDFNVC = 1
      NFNVC = N5
      I=N5*MDFNVC
      LFNVC = KSTALL (I)
      CALL XZEROF ( ISTORE(LFNVC) , I )
      IDEFFN = 0
C----- ALLOCATE A FUNCTION VECTOR
      MDATVC = 3
      NATVC = N5
      I=N5*MDATVC
      LATVC = KSTALL (I)
      CALL XZEROF ( ISTORE(LATVC) , I ) !Include all by default.
C
C----- LOAD THE FUNCTION VECTOR WITH RADIUS 1 (VDW)
      JFNVC = 1
      IRDUS = 1
C----- LOAD LIST 29
      CALL XFAL29
C----- SCAN LIST 5 SETTING FUNCTION VECTOR TO APPROPRIATE RADIUS
      MFNVC=LFNVC
      I29=L29 + (N29-1)*MD29
      I5 = L5 + (N5-1)*MD5
      BMAX = 0.

      DO M5=L5,I5,MD5
        JZ = L29 + IRDUS    !IF NO MATCH - POINT TO DEFAULT (FIRST) ATOM
        DO M29= L29,I29,MD29
          IF (ISTORE(M5) .EQ. ISTORE(M29)) THEN
            JZ=M29+IRDUS
            EXIT
          END IF
        END DO
        STORE(MFNVC) = STORE(JZ)
        BMAX = AMAX1( BMAX, STORE(JZ))
        MFNVC = MFNVC + MDFNVC
      END DO


      IF (ILIST .GE. 0) THEN
        IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU ,7460) TOLER
        ENDIF
7460    FORMAT(' Tolerance used in determining bonds is ',F4.2)
      ENDIF
C
C----- RESET FUNCTION VECTOR AND LIMITS USED BY D/A IF NECESSARY
      IF(JFNVC) 7670,7670,7660
7660  CONTINUE
      BMAX=2.*BMAX + TOLER
      AT = 0.
      AC = BMAX
      BT = 0.
      BC = BMAX
7670  CONTINUE
C----- LOAD LISTS 1 AND 2, AND SET UP SOME CONSTANTS
      CALL XDIST2
C
C
C----- REDUCE SYMMETRY IF NECESSARY
      CALL KSYMOD (ISYMOD, IC, IL, N2P, L2C, L2, N2, MD2)
      JT=12
      L12=-1
      M12=-1
C--SET UP A FEW STACK CONSTANTS
      JB=NFL
      JC=JB+MD5
      JD=JC+20
      JE=JD+30
C--CHECK THE STORE AREA
      IF ( JE - LFL ) 1350 , 9920 , 9920
1350  CONTINUE
C----- THE 'USE' FLAG IS DECREMENTED WHEN AN ATOM IN THE FOUND LIST MAKE
C      A CONTACT TO AN UNFOUND ATOM
C----- SET CUTTENT LEVEL OF ACTIVITY (NEGATIVE)
      ICURR = -1
C----- MARK FIRST ATOM AS FOUND
      DO I = 0,MDATVC-1
        ISTORE(LATVC+I) = ICURR
      END DO
      IF (ITYPE .EQ. 0) THEN
C----- ONLY MOVE PEAKS - MARK ALL NON-PEAKS AS FOUND
          I5 = L5 + (N5-1)*MD5
          MATVC = LATVC
          DO M5 = L5, I5, MD5
              IF((ISTORE(M5) .NE. IQPEAK) .AND. 
     1           (ISTORE(M5) .NE. ICPEAK)) THEN
                DO I = 0,MDATVC-1
                  ISTORE(MATVC+I) = ICURR
                END DO
              END IF
              MATVC = MATVC + MDATVC
          END DO
      ELSE IF (ITYPE .EQ. 1) THEN
C    ONLY MOVE NON-PEAKS 
          I5 = L5 + (N5-1)*MD5
          MATVC = LATVC
          DO M5 = L5, I5, MD5
              IF((ISTORE(M5) .EQ. IQPEAK) .OR. 
     1           (ISTORE(M5) .EQ. ICPEAK)) THEN
                DO I = 0,MDATVC-1
                  ISTORE(MATVC+I) = ICURR
                END DO
              END IF
              MATVC = MATVC + MDATVC
          END DO
      ENDIF
C----- FRAGMENT PRINT FLAG
      IFRGPT = -1
      ICHNG = 1
      DO WHILE ( ICHNG .NE. 0 )
C----- LOOP BACK HERE IF ICHNG NOT ZERO
C--SET UP THE CONTROL VARIABLES FOR THIS PASS
C----- SET NO NEW CHANGES YET
        ICHNG = 0
        MATOM = 0
C----- OUTER PIVOT LOOP ALWAYS RE-START FROM BEGINNING
        M5A = L5
        MFNVCA = LFNVC
        MATVCA = LATVC
1400    CONTINUE
C----- INNER CONTACT LOOP, STARTING FROM M5, ALWAYS GOES OVER ALL ATOMS
        M5=L5
        MFNVC = LFNVC
        MATVC = LATVC
        IF (MATOM  .GE. N5) GOTO 3400
C----- DONT REUSE PREVIOUS FOUND OR UNFOUND ATOMS AS PIVOT.
        IF (ISTORE(MATVCA) .NE. ICURR) GOTO 3350
        NFL=JE
C -- COMPUTE DISTANCE STACK
cdjwjan11
c set module type to residue (2)
        NDIST = KDIST1( N5, JRIC, JT, 1, TOLER, ITRANS,1,4,2)
        IF(NDIST .LE. -1 ) GOTO 9920 !Error

        IF (NDIST .EQ. 0) THEN
          IF (ITYPE .LT. 0) THEN
            IF (ISTORE(MATVCA) .EQ. 0) THEN
C----- AN ISOLATED ATOM
              IF (ISSPRT .EQ. 0) THEN
                WRITE(NCWU,1451) ISTORE(M5A), STORE(M5A+1)
              ENDIF
1451          FORMAT(' Isolated atom : ', A4,F6.0)
            ELSE IF ( (ICHNG .EQ. 0) .AND. ( IFRGPT .LT. 0) ) THEN
C----- START OF A NEW FRAGMENT - SET FLAG TO 'PRINT'
              IFRGPT = +1
            END IF
          END IF
          GOTO 3350
        ENDIF
C--REMOVE DUPLICATE ENTRIES FOR EACH ATOM, LEAVING THE MIN. CONTACT DIST
        NFL=JRIC
        IRIC=JE
        JS=JE
C--CHECK IF THERE ARE ANY MORE ATOMS IN THE STACK
1600    CONTINUE
        IF(IRIC.LT.JRIC)THEN
C--BEGIN THE SEARCH FOR ALL CONTACTS TO THIS CURRENT ATOM
          E=STORE(IRIC+10)
          K=IRIC
C--CHECK IF THERE ARE ANY MORE ATOMS IN THE STACK
1700      CONTINUE
          DO WHILE (IRIC .LT. JRIC)
C--CHECK IF THIS IS THE SAME ATOM
            IF(ISTORE(IRIC).NE.ISTORE(K)) EXIT

            IF(STORE(IRIC+10).LT.E)THEN     !CHECK THE DISTANCE
              E=STORE(IRIC+10)
              K=IRIC
            END IF
            IRIC=IRIC+JT                    !MOVE TO THE NEXT ATOM
          END DO

          CALL XMOVE(STORE(K),STORE(JS),JT) !MOVE THE STACK INFORMATION
          K=K+JT
          JS=JS+JT
          GOTO 1600
        END IF


        IF(JS.GT.JE)THEN          !CHECK IF ANY ATOMS HAVE BEEN FOUND
C--ATOMS FOUND  -  CHECK FOR ATOMS TO BE DELETED
          JK=0
          JS=JS-JT
          IPOINT=NOWT
C
C--BEGIN MOVING NON-DELETED ATOMS
          NFL=JD
C--MAIN ATOM MOVING LOOP
          DO I=JE,JS,JT
C----- CHECK IF ACCEPTABLE
            IF(ISTORE(I+1) .LE. 1) CYCLE
C--CHECK IF WE ARE PRINTING THE MOVED ATOMS
            IF (IFRGPT .GT. 0) THEN                             
              IF (ISSPRT .EQ. 0) THEN
                WRITE(NCWU,'(A)' ) ' Start of a new residue '
              ENDIF
C   NOW INHIBIT PRINTING
              IFRGPT = -1
            ENDIF
            CALL XPRTCD(I,J,CMOVED)
            JK=-1
C--SHIFT THE SYMMETRY OPERATORS TO THE HEADER PLACE
            CALL XMOVE(STORE(I+2),STORE(JC+7),5)
C--SHIFT THE ATOM TO TEMP. STORAGE
            CALL XMOVE(STORE(J),STORE(JB),MD5)
C
C----- LIST 5 ADDRESS
            IADDR = ISTORE(I)
C----- WHICH ATOM
            IATOM = (IADDR-L5)/MD5
C----- FUNCTION VECTOR ADDRESS
            IADDF = LATVC + IATOM*MDATVC
C--MOVE THE NEW ATOM FROM TEMP. STORAGE TO CORRECT POSITION
            JJ=KATOMS(JC,JB,IADDR)
            DO II=0,MDATVC-1
              ISTORE(IADDF+II) = ICURR-1
            END DO
            ICHNG = ICHNG + 1
          END DO
        ENDIF

3350    CONTINUE               !UPDATE FOR THE NEXT PIVOT ATOM

        M5A = M5A + MD5
        MFNVCA = MFNVCA + MDFNVC
        MATVCA = MATVCA + MDATVC
        MATOM = MATOM + 1
        GOTO 1400


3400    CONTINUE        !SEE IF THERE ARE ANY UNMOVED ATOMS LEFT

        ICURR = ICURR - 1
        IF (ICHNG .EQ. 0) THEN
          K = LATVC + MDATVC*(NATVC-1)
          DO I = LATVC, K, MDATVC
            IF (ISTORE(I) .EQ. 0) THEN
              DO II=0,MDATVC-1
                ISTORE(I+II) = ICURR
              ENDDO
              ICHNG = ICHNG + 1
              EXIT
            END IF
          END DO
        END IF

      END DO !End of do while ichng .ne. 0


C--END OF THE CONDENSING LOOP  -  OUTPUT THE NEW LIST
C--CREATE THE OUTPUT LIST TYPE WHERE NECESSARY
      N=N5
      NEW=1
      CALL XCPYL5(LN1,LN2,N,NEW)
C--OUTPUT THE LIST TO THE DISC
      CALL XSTR05(LN2,0,NEW)
C
C
3720  CONTINUE
C
C -- FINAL MESSAGES
C
      CALL XOPMSG ( IOPREF , IOPEND , 301 )
C
      CALL XTIME2(2)
      CALL XCSAE
      CALL XRSL
      RETURN
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPREF , IOPABN , 0 )
      GO TO 3720
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPREF , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
C -- INSUFFICIENT SPACE
      CALL XOPMSG ( IOPREF , IOPSPC , 0 )
      GO TO 9900
      END
C
C
CODE FOR XPRTCD
      SUBROUTINE XPRTCD(II,IJ,MESS)
C--PRINT AN ATOM THAT IS TO BE DELETED OR MOVED BY 'XCOND'
C
C  II      ADDRESS OF THE DISTANCE CONTROL BLOCK FOR THIS CONTACT.
C  IJ      SET TO THE ADDRESS OF THE ATOM TO BE ALTERED ON RETURN.
C  MESS    MESSAGE THAT IS TO BE PRINTED.
C
C--THIS ROUTINE CHECKS 'ILIST' TO SEE IF THE PRINT IS REQUIRED,
C  AND ASSUMES THAT THE CURRENT PIVOT ATOM IS AT 'M5A'.
C
C--TWO VARIABLES IN 'XWORKA' ARE USED TO CONTROL THE PRINTING :
C
C  JK  ZERO IF THIS IS THE FIRST PRINT FOR THIS PIVOT ATOM,
C      ELSE NON-ZERO.
C  JL  ZERO IF THIS IS THE FIRST PRINT OF ANY KIND FOR THIS CALL
C      OF 'XCOND', ELSE NON-ZERO.
C
C--
      INCLUDE 'ISTORE.INC'
C
      DIMENSION PROCS(16)
      CHARACTER*(*) MESS
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
C
      INCLUDE 'XPROCC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
      EQUIVALENCE (PROCS(1), DISTS(1))
C
C--FIND THE ADDRESS OF THE ATOM TO BE ALTERED
      IJ=ISTORE(II)
      K=II+4
C--CHECK FOR LISTING WITH THIS CALL
      IF(ILIST)1400,1000,1000
C--PRINT REQUIRED  -  CHECK IF THIS THE FIRST DELETION FOR THIS ATOM
1000  CONTINUE
      IF(JL)1100,1100,1160
C--THIS IS THE FIRST CALL  -  OUTPUT THE HEADING
1100  CONTINUE
      JL=1
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1150)
      ENDIF
1150  FORMAT(///' Current pivot atom',7X,'Atom',3X,'Serial',3X,'S(I)',
     2 2X,'L',2X,'T(X)',1X,'T(Y)',1X,'T(Z)',2X,'Distance',5X,'Action',
     3 6X, 'x/a', 5X, 'y/b', 5X, 'z/c', 5X, 'Rho', /)
      WRITE(CMON,1156)
      CALL XPRVDU(NCVDU, 1,0)
1156  FORMAT(3X,'Pivot',4X,'Atom',5X,'Dist',5X,'Rho',6X,'Action')
C
1160  CONTINUE
      WRITE ( CMON , 1256 )  STORE(M5A), NINT(STORE(M5A+1)),
     3  STORE(IJ), NINT(STORE(IJ+1)), STORE(II+10), STORE(J+13), MESS
      CALL XPRVDU(NCVDU, 1,0)
1256  FORMAT ( 2(1X,A4 , I4), 2F8.2, 4X,A8)
      IF(JK)1300,1050,1300
C--CHECK IF THIS IS THE FIRST ACTION IN THIS CALL
1050  CONTINUE
C--PRINT THE ATOM TO BE ALTERED WITH THE PIVOT ATOM
1200  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1250)STORE(M5A),STORE(M5A+1),ISTORE(IJ),STORE(IJ+1),
     2 (ISTORE(L+2),L=II,K) , STORE(II+10) , MESS,
     3 STORE(IJ+4), STORE(IJ+5), STORE(IJ+6), STORE(IJ+13)
      ENDIF
1250  FORMAT (/, 1X,4X,A4,F8.0,9X,A4,F8.0,4X,I3,I4,3I5,F9.3,6X,A8,
     1 3F8.3, F9.1 )
      GOTO 1400
C--PRINT THE ALTERED ATOM WITHOUT THE CURRENT PIVOT
1300  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1350)ISTORE(IJ),STORE(IJ+1),(ISTORE(L+2),L=II,K),
     2 STORE(II+10) , MESS,
     3 STORE(IJ+4), STORE(IJ+5), STORE(IJ+6), STORE(IJ+13)
      ENDIF
1350  FORMAT ( 26X,A4,F8.0,4X,I3,I4,3I5,F9.3,6X,A8,
     1 3F8.3, F9.1 )
C--AND NOW RETURN
1400  CONTINUE
      RETURN
      END
C
CODE FOR XOCC
      FUNCTION XOCC(IADD)
C--COMPUTE THE OCCUPANCY OF AN ATOM.
C
C  IADD    THE ADDRESS OF THE ATOM IN 'STORE'.
C
C--RETURN VALUES OF 'XOCC' ARE :
C
C  -1.  INSUFFICIENT CORE.
C  >0.  THE OCCUPANCY.
C
C--THE DETAILS FOR 'KDIST1' SHOULD ALREADY HAVE BEEN SET UP, WITH A
C  MAXIMUM DISTANCE CONTACT OF AT LEAST '2.0*VALUE'.
C  THE RESULTS FROM 'KDIST1' OVERWRITE THE DATA AT 'NFL', SO THAT
C  THIS SHOULD BE PROTECTED IF IT IS IMPORTANT.
C
C--
      INCLUDE 'STORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
C
C--PRESERVE THE LIST 5 POINTERS
      KA=M5A
      M5A=IADD
      KB=M5
      M5=IADD
C--PRESERVE THE LIST 12 POINTERS
      KC=M12
      M12=NOWT
C--SET THE ENTRY LENGTH
      KD=12
C--COMPUTE SOME DISTANCES
      IF(KDIST1( 1, I, KD, 0, .2, 0, 0, 4, 0)) 1000, 1050, 1150
C--NOT ENOUGH CORE
1000  CONTINUE
      XOCC=-1.
      GOTO 1100
C--NO OTHER CONTACTS
1050  CONTINUE
      XOCC=1.
1100  CONTINUE
      M5A=KA
      M5=KB
      M12=KC
      RETURN
C--SOME CONACTS  -  CHECK THEM OUT
1150  CONTINUE
      I=I-KD
      A=1.
      B=2.*VALUE
      DO 1250 K=NFL,I,KD
      IF(STORE(K+10)-B)1200,1200,1250
C--UPDATE THE POINTER
1200  CONTINUE
      A=A+1.
1250  CONTINUE
      XOCC=1./A
      GOTO 1100
      END
C
CODE FOR KDIST1
      FUNCTION KDIST1( IN, JS, JT, JFNVC, TOLER,
     1                 ITRANS, JATVC, IPTR, IPART)
C--ENTRY THAT CALCULATES DISTANCES AND STORES THE RESULTS AT NFL
C
C  IN    THE NUMBER OF ATOMS TO BE MOVED AROUND.
C  JS    POINTER TO THE DISTANCES STACK  -  ORIGINALLY SET TO 'NFL'
C        AND POINTING TO THE NEXT FREE LOCATION AFTER THE STACK ON EXIT.
C  JT    HE NUMBER OF WORDS PER ENTRY IN THE DISTANCES STACK.
C  JFNVC ZERO OR LESS IF NO BOND RADIUS VECTOR SUPPLIED
C  JFNVC  +1  IF VCTOR USED BONDING RADIUS
C  JFNVC NOWT NO VECTOR, AND ONLY FIRST CONTACT TO BE RETURNED
C  TOLER SET TO TOTAL TOLERANCE IF FUNCTION VECTOR SUPPLIED
C  ITRANS SET TO -1 TO SUPPRESS UNIT CELL TRANSLATIONS
C  JATVC ZERO IF NO FUNCTION VECTOR SUPPLIED
C  JATVC  +1  IF VCTOR CONTAINING 3 ATOM FLAGS SUPPLIED
C  IPTR - OFFSET of co-ordinates (usually 4, may be 2 from Fourier).
C  IPART - 0: normal operation
C          1: no bonds between different parts (except 0) (L5 offset 14)
C          2: No bonds between different RESIDUES
C
C--THE RETURN VALUES OF 'KDIST1' ARE :
C
C  -1  NOT ENOUGH CORE IS AVAILABLE.
C   0  NO SUITABLE CONTACTS HAVE BEEN FOUND.
C  >0  THE NUMBER OF ENTRIES IN THE DISTANCES STACK.
C
C--THE VARIABLE 'IDIST' DETERMINES THE TYPE OF SEARCH
C  THAT IS PERFORMED :
C
C  -1  NORMAL DISTANCES AND ANGLES.
C   0  PLACEMENT WITHIN THE VOLUME DEFINED BY 'BPD(4-9)'.
C  >0  PLACEMENT WITHIN THE VOLUME GIVEN BY THE FACE
C      EQUATIONS. THE VALUES IN 'BPD(4-9)' ARE USED IN THE
C      INITIAL SEARCH AND MUST BE THE MIN. AND MAX.
C      VALUES TO BE FOUND.
C
C--THE BOX VARIABLES FOLLOW 'IDIST' IN 'XDSTNC' :
C
C  LBOX    LOCATION OF THE BOX CONTROL DATA.
C  MBOX    WORK VARIABLE.
C  MDBOX   NUMBER OF WORDS PER BOX CONTROL BLOCK ENTRY
C  NBOX    NUMBER OF CONTROL BLOCKS MINUS ONE.
C
C--THE FIRST ENTRY IN THIS TABLE IS THE CENTROID OF THE BOX IN CRYSTAL
C  FRACTIONS, AND THE REMAINING ENTRIES CONTAIN THE EQUATION OF ONE
C  OF THE PLANES BOUNDING THE SHAPE TO BE FILLED. THE EQUATIONS USE
C  COORDINATES IN CRYSTAL FRACTIONS AND ARE OF THE FORM A*X+Y*B+Z*C-D=0.
C
C--FOR THE BOX ALGORITHM, THE REPLIES ARE THE SAME, EXCEPT THAT THE
C  DISTANCE ENTRIES ARE NOT SET, ONLY THE COORDINATES.
C
C--THE FOLLOWING VARIABLES MUST BE SET ON ENTRY
C
C  AT     MINIMUM ALLOWED DISTANCE FOR DISTANCES
C  AC     MAXIMUM ALLOWED DISTANCE FOR DISTANCES
C  BT     MINIMUM ALLOWED DISTANCE FOR ANGLES
C  BC     MAXIMUM ALLOWED DISTANCE FOR ANGLES
C  AO    MAXIMUM ALLOWED DISTANCE OVERALL
C  AP     MAXIMUM ALLOWED DISTANCES SQUARED OVERALL
C  BP     MINIMUM ALLOWED DISTANCE SQUARED OVERALL
C  M5A    ADDRESS OF THE CURRENT PIVOT ATOM IN LIST 5
C  M5     ADDRESS OF THE FIRST ATOM TO MOVE AROUND IN LIST 5
C----  MFNVCA  ADDRESS IN FUNVTION VECTOR OF PIVOT ATOM
C      MFNVC   ADDRESS IN FUNCTION VECTOR OF FIRST ATOM
C
C--ATOMS WHICH FORM ACCEPTABLE CONTACTS ARE STORED IN A STACK
C  WHICH HAS THE FOLLOWING FORMAT :
C
C   0  ADDRESS OF THE ATOM IN LIST 5
C   1  ACCEPTANCE FLAG
C
C      1  ACCEPTABLE TO NONE
C      2  DISTANCES ONLY
C      3  ANGLES ONLY
C      4  ACCEPTABLE TO BOTH
C
C   2  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CENTRE OF SYM.)
C   3  NON-PRIMITIVE LATTICE INDICATOR
C   4  T(X)
C   5  T(Y)
C   6  T(Z)
C   7  TRANSFORMED X
C   8  TRANSFORMED Y
C   9  TRANSFORMED Z
C  10  DISTANCE
C  11  DISTANCE SQUARED
C  12  ADDRESS IN LIST 12  (IF USED).
C  13  TARGET CONTACT DISTANCE FOR RESTRAINTS (OPTIONAL)
C  14  ESD FOR HYDROGEN BONDS
C  15  RESIDUE NUMBER
C
C--THE STACK STARTS AT NFL, AND GOES UPWARDS SO THAT THE LAST ENTRY IS
C  AT JS, AND THE STEP IS JT.
C
C--THE COMMON BLOCK /XAPD/ IS USED AS :
C
C  APD(1-3)  SYMMETRY RELATED X, Y AND Z, WITH TRANSLATION PART OMITTED.
C  APD(4-6)  INITIAL SYMMETRY RELATED X, Y AND Z.
C  APD(7-9)  FINAL SYMMETRY RELATED X, Y AND Z AFTER A SUCCESSFUL FIND.
C
C  BPD(1-3)  D(L,M,N) IN ANGSTROM  -  CORRESPONDS TO A UNIT CELL SHIFT.
C  BPD(4-6)  MINIMUM FRACTIONAL COORDINATES OF THE SEARCH VOLUME.
C  BPD(7-9)  MAXIMUM FRACTIONAL COORDINATES OF THE SEARCH VOLUME.
C
C--
      INCLUDE 'ISTORE.INC'
C
      DIMENSION XX(3)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (E,XX(1)),(F,XX(2)),(G,XX(3))
C
C--SET UP A FEW INITIAL POINTERS
      NJ=0
      JS=NFL
      JTRANS = ITRANS
C--SET DEFAULT DISTANCES
      E=0.
      F=0.
C--CHECK IF WE ARE CALCULATING DISTANCES OR A BOX FUNCTION
      IF(IDIST)1000,1100,1100
C--DISTANCES ARE BEING CALCULATED
1000  CONTINUE
      I=M5A
C--SET UP THE MAXIMUM AND MINIMUM VALUES FOR EACH DIRECTION FOR A DISTAN
      DO J=1,3
        BPD(J+3)=STORE(I+IPTR)-AO/BPD(J)
        BPD(J+6)=STORE(I+IPTR)+AO/BPD(J)
        I=I+1
      END DO
C--SET UP THE OTHER FLAGS
1100  CONTINUE
      NC=2*IC+1


C----- LOOP BACK HERE FOR NEXT ATOM
cdjwjan11
      IF ( IPART .eq. 1 ) then
             CALL PRTGRP(ISTORE(M5A+14), MPIVPR, MPIVGR,ipart)

      else if ( IPART .EQ. 2 ) THEN ! IPART eq 2 - look at RESIDUE slot in list 5
             CALL PRTGRP(ISTORE(M5A+16), MPIVPR, MPIVGR,ipart)
      endif
      DO ND = 1, IN

C----- CHECK IF THIS ATOM IS EXCLUDED from being a BONDED type 
        IF ( ABS(JATVC) .EQ. 1 ) THEN
          IF ( ( ISTORE(MATVC+1) .LE. -1 ) .AND.
     1         ( ISTORE(MATVC+2) .LE. -1 ) ) GOTO 2725
        END IF

C--IF NOT BONDING PARTS, then CHECK PART NUMBERS
        NPTSYM = 0


cdjwjan11
      IF ( IPART .eq. 1 ) then
             CALL PRTGRP(ISTORE(M5+14),MBONPR, MBONGR,ipart)
      else if ( IPART .eq. 2 ) then ! IPART eq 2 - look at RESIDUE slot in list 5
             CALL PRTGRP(ISTORE(M5+16),MBONPR, MBONGR, ipart)
      endif

      IF ( IPART .ge. 1 ) then
C 1) Allow bond if one atom is group 0, part 0.
           IF (( MPIVPR .EQ. 0 .AND. MPIVGR .EQ. 0 ) .OR.
     1         ( MBONPR .EQ. 0 .AND. MBONGR .EQ. 0 ) ) GOTO 1110

C 2) Don't bond things in same 'group' if 'part' numbers are non-zero
C    and different.
           IF (( MPIVGR.EQ.MBONGR ).AND.( MPIVPR.NE.MBONPR ) .AND.
     1         ( MPIVPR.NE.0)      .AND.( MBONPR.NE.0      ) ) GOTO 2725

C 3) Don't bond things if 'group' numbers non-zero and different
C    and one of the 'parts' is 0.
           IF (( MPIVGR.NE.MBONGR ) .AND. ( MIN(MPIVGR,MBONGR).NE.0 )
     1     .AND. ((MPIVPR.EQ.0).OR.(MBONPR.EQ.0)) ) GOTO 2725

C 4) Later, don't bond to same prt&grp across symops if part number is -ve.

           IF (( MPIVGR.EQ.MBONGR ) .AND. ( MPIVPR.EQ.MBONPR ) .AND.
     1         ( MPIVPR .LT. 0 )) THEN
                 NPTSYM = -1   ! Don't apply sym ops
                 JTRANS = -1  ! Skip cell translations
           END IF
        END IF

1110    CONTINUE

C--LOOP OVER EACH SYMMETRY OPERATOR COMBINATION FOR THIS ATOM
        M2=L2
        DO NE=1,N2
C--APPLY THIS SYMMETRY OPERATOR
          CALL XMLTTM(STORE(M2),STORE(M5+IPTR),APD(1),3,3,1)
C--LOOP OVER EACH REQUIRED SIGN FOR THE CENTRE OF SYMMETRY FLAG
          DO NF=1,NC,2
            M2P=L2P
C--LOOP OVER EACH OF THE NON-PRIMITIVE LATTICE TRANSLATIONS
            DO NG=1,N2P
              NH=M2
C--ADD IN THE VARIOUS TRANSLATION PARTS
              DO NI=1,3
                APD(NI+3)=APD(NI)+STORE(M2P)+STORE(NH+9)
                APD(NI+6)=APD(NI+3)
                M2P=M2P+1
                NH=NH+1
              END DO


              IF (JTRANS .EQ. -1) GOTO 1510

C--MOVE THE X COORDINATE SO THAT IT IS OUT OF THE REQUIRED VOLUME
              CALL XSHIFT(1)
C--ADVANCE THE X COORDINATE BY ONE OR MORE UNIT CELLS
1300  CONTINUE
              IF( KDIST(1) .LT. 0 ) GOTO 2600
C--MOVE THE Y COORDINATE SO THAT IT IS OUT OF THE REQUIRED VOLUME
              CALL XSHIFT(2)
C--ADVANCE THE Y COORDINATE BY ONE OR MORE UNIT CELLS
1400  CONTINUE
              IF( KDIST(2) .LT. 0 ) GOTO 1300
C--MOVE THE Z COORDINATE SO THAT IT IS OUT OF THE REQUIRED VOLUME
              CALL XSHIFT(3)
C--ADVANCE THE Z COORDINATE BY ONE OR MORE UNIT CELLS
1500          CONTINUE 
              IF( KDIST(3) .LT. 0 ) GOTO 1400

1510          CONTINUE

              IF( JS+MAX0(JT,13) .GE. LFL) THEN
C--NOT ENOUGH CORE FOR THIS ENTRY NEGATE RETURN VALUE TO SIGNAL OVERFLOW
                  NJ = -NJ
                  GOTO 2800
              END IF

C--ASSIGN A DEFAULT ACCEPTANCE FLAG
              ISTORE(JS+1)=1

C--SWITCH -- TYPE OF FUNCTION
              IF ( IDIST .GE. 1 ) THEN

C--FILLING A MULTI-SIDED BOX  -  MOVE TO THE CENTROID
                  CALL XSUBTR(APD(7),STORE(LBOX),XX(1),3)

c          WRITE (CMON,'(A,3(1X,3F6.3))')'Crd,cen,diff',
c     1 (APD(7+J),J=0,2),(STORE(LBOX+J),J=0,2),(XX(J),J=1,3)
c          CALL XPRVDU(NCVDU,1,0)

C--CHECK THAT THE POINT IS WITHIN THE BOX
                  MBOX=LBOX
                  DO NH=1,NBOX
                    MBOX=MBOX+MDBOX
c      WRITE (CMON,'(A,I4,4F8.3)')'NH,plane,D: ',NH,(STORE(MBOX+J),J=0,3)
c                    CALL XPRVDU(NCVDU,1,0)
c      WRITE (CMON,'(A,F8.3)')'Prod: ', STORE( MBOX )*XX(1)
c     1                 + STORE(MBOX+1)*XX(2)
c     2                 + STORE(MBOX+2)*XX(3)
c                    CALL XPRVDU(NCVDU,1,0)

                    IF(  STORE( MBOX )*XX(1)
     1                 + STORE(MBOX+1)*XX(2)
     2                 + STORE(MBOX+2)*XX(3)
     3                 - STORE(MBOX+3) .GT. 0.0 ) GOTO 2570
                  END DO
              ELSE IF ( IDIST .LE. -1 ) THEN

C----- CHECK FOR SELF-SELF CONTACT
                  IF ( ( M5 .EQ. M5A ) .AND. 
     1                 (ABS(STORE(M5A+IPTR)-APD(7)) .LE. ZERO) .AND.
     1                 (ABS(STORE(M5A+IPTR+1)-APD(8)).LE.ZERO) .AND.
     1                 (ABS(STORE(M5A+IPTR+2)-APD(9)).LE.ZERO))GOTO 2570

C-- NOT A SELF-SELF CONTACT WITH NO OPERATORS  -  CALC. DIST.
                  F=XDSTN2(STORE(M5A+IPTR),APD(7))
C--CHECK THE DISTANCE AGAINST THE MIN AND MAX ALLOWED VALUE SQUARED
                  IF ((F .LE. BP) .OR. (F .GE. AP)) GOTO 2570

C--COMPUTE THE DISTANCE
                  E=SQRT(F)

C---- USE THE FUNCTION VECTOR FOR DISTANCES ?
                  IF ( JFNVC .NE. 1 ) THEN
C----- SET TARGET TO CURRENT VALUE
                    BOND = E
C----- USE OVERALL LIMITS
C--WRITE IN ACCEPTANCE FLAGS (We know one of these will work.)
C--CHECK FOR DISTANCE ACCEPTABLE
                    IF((E .GE. AT).AND.(E. LT. AC)) THEN
                      ISTORE(JS+1)=ISTORE(JS+1)+1
                    END IF
C--CHECK FOR ANGLE ACCEPTABLE
                    IF((E .GE. BT).AND.(E .LT. BC)) THEN
                      ISTORE(JS+1)=ISTORE(JS+1)+2
                    END IF

                  ELSE

C-----  CHECK THE DISTANCE AGAINST FUNC. VECTOR RADII
C----- DONT PUT INTO STACK IF TOO LONG COMPARED WITH FUNCTION VECTOR
                    BOND = STORE(MFNVC) + STORE(MFNVCA)
                    IF ((E.GT.(BOND+TOLER)).OR.( E.LE.AT))GOTO 2570
                    ISTORE(JS+1) = 4
                  END IF
              END IF


C--SET THE REMAINING FLAGS
              ISTORE(JS)=M5
              ISTORE(JS+2)=(2-NF)*NE
              ISTORE(JS+3)=NG
              NJ=NJ+1
              J=JS+4
              DO I=1,3
                ISTORE(J)=NINT(APD(I+6)-APD(I+3))
                STORE(J+3)=APD(I+6)
                J=J+1
              END DO

c          WRITE (CMON,'(A,3(1X,3F6.3))')'Stored: ',
c     1 (STORE(7+JK+JS),JK=0,2)
c          CALL XPRVDU(NCVDU,1,0)


              STORE(JS+10)=E
              STORE(JS+11)=F
              ISTORE(JS+12)=M12
              IF (JT .GE. 14) STORE(JS+13) = BOND
              IF (JT .GE. 16) ISTORE(JS+15) = ISTORE(M5+16)  ! RESIDUE
              JS=JS+JT
C When JFNVC .EQ. NOWT then only find one contact at a time. (Voids only?)
              IF ( JFNVC .EQ. NOWT ) GOTO 2800

2570          IF (JTRANS .EQ. 0) GOTO 1500

2600          CONTINUE
              IF ( NPTSYM .LT. 0 ) GOTO 2725 !Skip applying any symmetry.
            END DO
            CALL XNEGTR(APD(1),APD(1),3)
          END DO
          M2=M2+MD2
        END DO
2725    CONTINUE
        IF (JFNVC .GT. 0) MFNVC = MFNVC+MDFNVC
        IF (JATVC .GT. 0) MATVC = MATVC+MDATVC
        IF (M12 .GT. 0)   M12=ISTORE(M12)        !IF L12 PTR NEEDS UPDATING
        M5=M5+MD5
      END DO

2800  CONTINUE
      KDIST1=NJ
      RETURN
      END


CODE FOR KDIST4
      FUNCTION KDIST4( JS, JT, JATVC, IPART)
C--ENTRY THAT CALCULATES DISTANCES AND STORES THE RESULTS AT NFL

C  JS    POINTER TO THE DISTANCES STACK  -  ORIGINALLY SET TO 'NFL'
C        AND POINTING TO THE NEXT FREE LOCATION AFTER THE STACK ON EXIT.
C  JT    HE NUMBER OF WORDS PER ENTRY IN THE DISTANCES STACK.
C
C  M5A    ADDRESS OF THE CURRENT PIVOT ATOM IN LIST 5
C  M5     ADDRESS OF THE FIRST ATOM TO MOVE AROUND IN LIST 5
C
C----- JATVC - 0 DO NOT USE A FUNCTION VECTORS
C              1 USE THE VECTORS
C
C      LATVC, MATVC, ETC. - THE FUNCTION VECTOR POINTERS FOR ATOMS
C
C      THE VECTOR WILL BE N5*3 IN LENGTH
C
C      (MATVC+0) USE FLAG FOR PIVOT ATOM 
C      (MATVC+1) USE FLAG FOR BONDED ATOM 
C      (MATVC+2) USE FLAG FOR 3RD ATOM IN ANGLE SEARCH
C
C      MEANINGS OF USE FLAG
C             -1     DO NOT USE AT THIS POSITION
C              0     ATOM ALLOWED AT THIS POSITION
C
C  IPART   0   RETURN FULL SET OF DISTANCES, IPART UNCHANGED.
C  IPART  +N   RETURN Nth CONSISTENT SET OF DISTANCES, BASED
C              UPON GROUP/PART NUMBERS. RETURN VALUE IS 0 FOR NO
C              MORE SETS, OTHERWISE N+1, READY FOR NEXT SET.
C              IF N># CONSISTENT SETS A RANDOM SET WILL BE RETURNED.
C              SET 1 IS ALWAYS ALL THE LOWEST PART NUMBERS OF ANY GROUPS SO
C              JUST USE THIS SET IF YOU WANT TO IGNORE DISORDER ALTOGETHER.
C
C--THE RETURN VALUES OF 'KDIST4' ARE :
C
C  -1  NOT ENOUGH CORE IS AVAILABLE.
C   0  NO SUITABLE CONTACTS HAVE BEEN FOUND.
C  >0  THE NUMBER OF ENTRIES IN THE DISTANCES STACK.
C
C-  MFNVCA  ADDRESS IN FUNVTION VECTOR OF PIVOT ATOM
C   MFNVC   ADDRESS IN FUNCTION VECTOR OF FIRST ATOM
C
C--ATOMS WHICH FORM ACCEPTABLE CONTACTS ARE STORED IN A STACK
C  WHICH HAS THE FOLLOWING FORMAT :
C
C   0  ADDRESS OF ATOM IN L5
C   1  ACCEPTANCE FLAG
C
C      1  ACCEPTABLE TO NONE
C      2  DISTANCES ONLY
C      3  ANGLES ONLY
C      4  ACCEPTABLE TO BOTH
C
C   2  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CENTRE OF SYM.)
C   3  NON-PRIMITIVE LATTICE INDICATOR
C   4  T(X)
C   5  T(Y)
C   6  T(Z)
C   7  TRANSFORMED X
C   8  TRANSFORMED Y
C   9  TRANSFORMED Z
C  10  DISTANCE
C  11  DISTANCE SQUARED
C  12  ADDRESS IN LIST 12  (IF USED).
C  13  TARGET CONTACT DISTANCE FOR RESTRAINTS (OPTIONAL)
C
C--THE STACK STARTS AT NFL, AND GOES UPWARDS SO THAT THE LAST ENTRY IS
C  AT JS, AND THE STEP IS JT.
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'QSTORE.INC'
      CHARACTER * 32 CATOM1, CATOM2, CBLANK
      DATA CBLANK /' '/


C--SET UP A FEW INITIAL POINTERS
      NJ=0
      JS=NFL

C---- LOOP BACKWARDS THRU LIST 41
c24      FORMAT (2A, ' to ', A, I4,1x,F10.3)

      DO M41B = L41B+(N41B-1)*MD41B, L41B, -MD41B

          I51 = L5 + ISTORE(M41B) * MD5
          I52 = L5 + ISTORE(M41B+6) * MD5

c          CALL CATSTR (STORE(I51),STORE(I51+1),
c     2                  ISTORE(M41B+1),ISTORE(M41B+2),
c     3                  ISTORE(M41B+3),ISTORE(M41B+4),ISTORE(M41B+5),
c     4                  CATOM1, LATOM1)
c          CALL CATSTR (STORE(I52),STORE(I52+1),
c     2                  ISTORE(M41B+7),ISTORE(M41B+8),
c     3                  ISTORE(M41B+9),ISTORE(M41B+10),ISTORE(M41B+11),
c     4                  CATOM2, LATOM2)
c          WRITE (CMON,24) CBLANK(1: 21-LATOM1),
c     2                  CATOM1(1:LATOM1), CATOM2,ISTORE(M41B+12),
c     3                  STORE(M41B+13)
c          CALL XPRVDU(NCVDU,1,0)

          IF ( ( I51 .NE. M5A ) .AND. ( I52 .NE. M5A ) ) CYCLE

C Ensure the order is BONDED, PIVOT:

          IF ( I51 .EQ. M5A ) THEN
               DO I = 0,5
                    ITEMP = ISTORE(M41B+I)
                    ISTORE(M41B+I) = ISTORE(M41B+6+I)

                    ISTORE(M41B+6+I) = ITEMP
               END DO
          END IF

          J51 = ISTORE(M41B)
          J52 = ISTORE(M41B+6)
          I51 = L5 + J51 * MD5
          I52 = L5 + J52 * MD5


C Don't want pivots that are in sym-related posns.
          IF (( ISTORE(M41B+7) .NE.1 ) .OR.
     1        ( ISTORE(M41B+8) .NE.1 ) .OR.
     2        ( ISTORE(M41B+9) .NE.0 ) .OR.
     3        ( ISTORE(M41B+10).NE.0 ) .OR.
     4        ( ISTORE(M41B+11).NE.0 )) CYCLE


C Only consider BONDED atoms after M5 in L5 order.
          IF ( I51 .LT. M5 ) CYCLE

C-- CHECK IF THIS ATOM IS EXCLUDED from being a BONDED type 
          IF ( ABS(JATVC) .EQ. 1 ) THEN
             IF ( ( ISTORE(LATVC+(MDATVC*J51)+1) .LE. -1) .AND.
     1            ( ISTORE(LATVC+(MDATVC*J51)+2) .LE. -1))CYCLE
          END IF

          IF( JS+MAX0(JT,13) .GE. LFL) THEN
C--NOT ENOUGH CORE FOR THIS ENTRY NEGATE RETURN VALUE TO SIGNAL OVERFLOW
             NJ = -NJ
             EXIT
          END IF

C--SET THE FLAGS
          ISTORE(JS)=I51
          ISTORE(JS+1)=4
          ISTORE(JS+2)=ISTORE(M41B+1)
          ISTORE(JS+3)=ISTORE(M41B+2)

          ISTORE(JS+4)=ISTORE(M41B+3)
          ISTORE(JS+5)=ISTORE(M41B+4)
          ISTORE(JS+6)=ISTORE(M41B+5)

C Calculate transformed co-ordinates

          M2 = L2 + ( MIN(N2,ABS(ISTORE(M41B+1))) - 1) * MD2
          M2P =L2P+ ( MIN(N2P,ISTORE(M41B+2))     - 1) * MD2P
          CALL XMLTTM(STORE(M2),STORE(I51+4),STORE(JS+7),3,3,1)
          IF (ISTORE(M41B+1).LT.0)CALL XNEGTR(STORE(JS+7),STORE(JS+7),3)
          DO L = 0,2
            STORE(JS+7+L) = STORE(JS+7+L) +STORE(M2P+L) +STORE(M2+9+L)
     1                                    +ISTORE(JS+4+L)
          END DO


          STORE(JS+11)=XDSTN2(STORE(JS+7),STORE(I52+4))
          STORE(JS+10)=SQRT(STORE(JS+11))


          IF ( L12 .GT. 0 ) THEN
            M12 = L12
            DO I = 1,J51
              M12 = ISTORE(M12)
            END DO
          END IF


          ISTORE(JS+12)=M12
          IF(JT.EQ.14) STORE(JS+13)=STORE(M41B+13)

          CALL CATSTR (STORE(I51),STORE(I51+1),
     2                  ISTORE(M41B+1),ISTORE(M41B+2),
     3                  ISTORE(M41B+3),ISTORE(M41B+4),ISTORE(M41B+5),
     4                  CATOM1, LATOM1)
          CALL CATSTR (STORE(I52),STORE(I52+1),
     2                  ISTORE(M41B+7),ISTORE(M41B+8),
     3                  ISTORE(M41B+9),ISTORE(M41B+10),ISTORE(M41B+11),
     4                  CATOM2, LATOM2)
c          WRITE (CMON,24) CBLANK(1: 21-LATOM1),
c     2                  CATOM1(1:LATOM1), CATOM2,ISTORE(M41B+12),
c     3                  STORE(M41B+13)
c          CALL XPRVDU(NCVDU,1,0)
c          WRITE (CMON,'(2(A,I5))')'I51=',I51,' Stored at JS=', JS
c          CALL XPRVDU(NCVDU,1,0)


          JS=JS+JT
          NJ=NJ+1

      END DO

C Post process dist stack into consistent disordered set.

c      WRITE (CMON,'(/A)')'Results:'
c      CALL XPRVDU(NCVDU,2,0)
c      DO I = NFL,JS-JT,JT
c        WRITE (CMON,'(A,I5,I15)')
c     1  ISTORE(ISTORE(I)),NINT(STORE(ISTORE(I)+1)),ISTORE(ISTORE(I)+14)
c        CALL XPRVDU(NCVDU,1,0)
c      END DO

      IF ( IPART .GT. 0 ) THEN
C We can use space after current stack. (at JS)
C Need to know - how many groups.
C              - how many parts in each group.

C Start by creating a vector of all the unique GROUP/PART numbers.
        IUVP = JS
        LUVP = JS-1
        DO I5T = NFL, JS-JT, JT
          I5P = ISTORE(I5T)
          IFND = 0
          IF ( ISTORE(I5P+14) .NE. 0 ) THEN
            DO IVC = IUVP,LUVP
              IF ( ISTORE(IVC) .EQ. ISTORE(I5P+14) ) THEN
                IFND = 1
                EXIT
              ELSE IF ( ISTORE(I5P+14) .LT. ISTORE(IVC) ) THEN
                IFND = 1
                CALL XMOVEI(ISTORE(IVC),ISTORE(IVC+1),1+LUVP-IVC)
                ISTORE(IVC) = ISTORE(I5P+14)
                LUVP = LUVP + 1
                EXIT
              END IF
            END DO
            IF ( IFND .EQ. 0 ) THEN
              LUVP = LUVP + 1
              ISTORE(LUVP) = ISTORE(I5P+14)
            END IF
          END IF
        END DO
        NUVP = 1+LUVP-IUVP
C We now have a vector of unique group/part IDs.

c      WRITE (CMON,'(A)')'Unique parts:'
c      CALL XPRVDU(NCVDU,1,0)
c      DO I = IUVP,LUVP
c        WRITE (CMON,'(I15)')ISTORE(I)
c        CALL XPRVDU(NCVDU,1,0)
c      END DO


C Check if the vector is worth having:
        IF ( NUVP .LE. 1 ) THEN             ! We have nothing to do.
           IPART = 0
           GOTO 9000
        END IF
        CALL SSORTI(IUVP,NUVP,1,1)          ! Sort it
C Calculate the number of groups, and the number of parts in each:

        IGP = LUVP + 1
        MGP = IGP 

        ICURN = ISTORE(IUVP)

        ISTORE(IGP) = 1

        DO IVC = IUVP,LUVP
          IF ( ISTORE(IVC) .EQ. ICURN) CYCLE
          CALL PRTGRP( ISTORE(IVC), NWPT, NWGR, 1 )
C Check for group change:
          CALL PRTGRP( ICURN, MOPT, MOGR, 1 )
          IF ( NWGR .NE. MOGR )THEN !Next group
            MGP = MGP + 1
            ISTORE (MGP) = 1
          ELSE                               !Same group, just increment.
            ISTORE(MGP) = ISTORE(MGP) + 1
          END IF
          ICURN = ISTORE(IVC)
        END DO
        LGP = MGP

c        WRITE (CMON,'(A)')'Group sizes:'
c        CALL XPRVDU(NCVDU,1,0)
c        DO I = IGP,LGP
c          WRITE (CMON,'(I8)')ISTORE(I)
c          CALL XPRVDU(NCVDU,1,0)
c        END DO


C Make a vector of allowed/not allowed to match unique group/part vector...

        IAVC = LGP+1
        LAVC = IAVC+LUVP-IUVP
        MAVC = IAVC-1

        MGP = IGP -1
        IOPROD = 1
        PROD = 1

        ICURN = 0
        IPCUR = -1

        DO IVC = IUVP,LUVP
          MAVC = MAVC + 1

          CALL PRTGRP( ISTORE(IVC), NWPT, NWGR, 1 )
C Check for group change:
          CALL PRTGRP( ICURN, MOPT, MOGR, 1 )
          IF ( NWGR .NE. MOGR )THEN !Next group
            MGP = MGP + 1
            NGR = ISTORE(MGP)
            IOPROD = PROD
            PROD = PROD * NGR
C This is the next group, which parts are allowed?
            IPAL = MOD(((IPART-1)-MOD((IPART-1),IOPROD))/IOPROD,NGR)
c        WRITE (CMON,'(A,4I9)')
c     1  'IPAL,IPART,IOPROD,NGR:',IPAL,IPART,IOPROD,NGR
c        CALL XPRVDU(NCVDU,1,0)
            IPCUR = -1
          END IF

          IPCUR = IPCUR + 1
          IF ( IPCUR .EQ. IPAL ) THEN
            ISTORE(MAVC)=1
          ELSE
            ISTORE(MAVC)=0
          END IF


          ICURN = ISTORE(IVC)
        END DO

c        WRITE (CMON,'(A)')'Allow / disallow:'
c        CALL XPRVDU(NCVDU,1,0)
c        DO I = IAVC,LAVC
c          WRITE (CMON,'(I8)')ISTORE(I)
c          CALL XPRVDU(NCVDU,1,0)
c        END DO

C Work out number of possible sets of consistent bonds.

        NSET = 1
        DO LGP = IGP,MGP
          NSET = NSET * ISTORE(LGP)
        END DO

C We now have three vectors:
C   IUVP - LUVP  : a sorted list of all the unique group/parts.
C   IGP  - LGP   : the number of parts in each group
C   IAVC - LAVC  : 1/0 corresponding to IUVP-LUVP parts for allow/exclude.


C Loop backwards through bond stack, removing entries with incompatible part
C numbers for the current set.

        DO I5T = JS-JT, NFL, -JT
          I5P = ISTORE(I5T)
          IF ( ISTORE(I5P+14).NE.0 ) THEN
            DO IVC = IUVP,LUVP
              IF ( ISTORE(IVC) .EQ. ISTORE(I5P+14) ) THEN
                IF ( ISTORE (IVC + IAVC - IUVP ) .EQ. 0 ) THEN
                  CALL XMOVE(STORE(I5T+JT),STORE(I5T),JS-I5T)
                  JS = JS - JT
                  NJ = NJ - 1
                END IF
                EXIT
              END IF
            END DO
          END IF
        END DO
        IPART = IPART + 1

        IF ( IPART .GT. NSET ) IPART = 0

      END IF




9000  CONTINUE
      KDIST4=NJ
      RETURN
      END


CODE FOR XDSTN2
      FUNCTION XDSTN2(A,B)
C--COMPUTE THE DISTANCE SQUARED BETWEEN TWO POINTS

C  A  VECTOR CONTAINING THE COORDINATES OF THE FIRST POINT.
C  B  VECTOR CONTAINING THE COORDINATES OF THE SECOND POINT.

C--THE RETURN VALUE OF 'XDSTN2' IS THE DISTANCE SQUARED.

C--

      DIMENSION A(3),B(3),C(3),D(3)

      INCLUDE 'STORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'

C--SUBTRACT THE VECTORS
      CALL XSUBTR(A(1),B(1),C(1),3)
C--ORTHOGONALISE THE DIFFERENCE VECTOR
      CALL XMLTTM(STORE(L1O1),C(1),D(1),3,3,1)
C--COMPUTE THE DISTANCE
      C(1)=D(1)*D(1)+D(2)*D(2)+D(3)*D(3)
C--CHECK THE VALUE
      IF(C(1)-ZEROSQ)1000,1050,1050
C--LESS THAN 'ZERO'  -  ASSIGN THE ANSWER TO 'VALUE'
1000  CONTINUE
      C(1)=VALUSQ
1050  CONTINUE
      XDSTN2=C(1)
      RETURN
      END
C
CODE FOR XSHIFT
      SUBROUTINE XSHIFT(NOC)
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
C
CODE FOR KDIST
      FUNCTION KDIST(NOC)
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
      KDIST=-1
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
      KDIST=0
1150  CONTINUE
      RETURN
      END
C
CODE FOR XDIST2
      SUBROUTINE XDIST2
C--SET UP A FEW CONSTANTS
C
      INCLUDE 'ISTORE.INC'
C
      DIMENSION IAPD(13)
      DIMENSION CC(4)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XCNTRL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST12.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (APD(1),IAPD(1))
      EQUIVALENCE (CC(1),AT)
C
      ISTAT2=0
C--LOAD LIST 1 AND LIST 2
      IF (KHUNTR (1,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL01
      IF (KHUNTR (2,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL02
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--SET UP THE SHIFT DATA
      DO 1050 I=1,3
      K=L1O2+I-1
      BPD(I)=0.
      DO 1000 J=1,I
      BPD(I)=BPD(I)+STORE(K)*STORE(K)
      K=K+3
1000  CONTINUE
      BPD(I)=1./SQRT(BPD(I))
1050  CONTINUE
C--CHECK THE INPUT DISTANCES PROVIDED
      DO 1150 I=1,4
      IF(CC(I)-ZERO)1100,1150,1150
C--SET UP THE DEFAULT
1100  CONTINUE
      CC(I)=ZERO
1150  CONTINUE
      AO=AMAX1(AC,BC)
      AP=AO*AO
      BP=AMIN1(AT,BT)
      BP=BP*BP
C--INDICATE THAT LIST 12 IS NOT STORE INITIALLY
      L12=NOWT
      M12=NOWT
C--DEFAULT TO AN INTER-ATOMIC DISTANCES CALCULATION
      IDIST=-1
9900  CONTINUE
C -- NORMAL AND ERROR RETURN
      RETURN
      END

CODE FOR XDIST3
      SUBROUTINE XDIST3
C--SET UP A FEW CONSTANTS
C
      INCLUDE 'ISTORE.INC'
C
      DIMENSION IAPD(13)
      DIMENSION CC(4)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XCNTRL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST12.INC'
C
      INCLUDE 'QSTORE.INC'
C
      EQUIVALENCE (APD(1),IAPD(1))
      EQUIVALENCE (CC(1),AT)
C
      ISTAT2=0
C--LOAD LIST 1 AND LIST 2
      IF (KHUNTR (1,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL01
      IF (KHUNTR (2,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL02
      IF ( IERFLG .LT. 0 ) GO TO 9900
C--SET UP THE SHIFT DATA
      DO 1050 I=1,3
      K=L1O2+I-1
      BPD(I)=0.
      DO 1000 J=1,I
      BPD(I)=BPD(I)+STORE(K)*STORE(K)
      K=K+3
1000  CONTINUE
      BPD(I)=1./SQRT(BPD(I))
1050  CONTINUE
C--CHECK THE INPUT DISTANCES PROVIDED
      DO 1150 I=1,4
      IF(CC(I)-ZERO)1100,1150,1150
C--SET UP THE DEFAULT
1100  CONTINUE
      CC(I)=ZERO
1150  CONTINUE
      AO=AMAX1(AC,BC)
      AP=AO*AO
      BP=AMIN1(AT,BT)
      BP=BP*BP
C--INDICATE THAT LIST 12 IS NOT STORE INITIALLY
      L12=NOWT
      M12=NOWT
C--DEFAULT TO A BOX CALCULATION
      IDIST=1
9900  CONTINUE
C -- NORMAL AND ERROR RETURN
      RETURN
      END
C
CODE FOR KSYMOD
      SUBROUTINE KSYMOD (ISYMOD, IC, IL, N2P, L2C, L2, N2, MD2)
C
C----- MODIFY THE SYMMETRY CONDITIONS FOR PATTERSONS OR NO SYMMETRY CASE
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
C
      IF (ISYMOD .EQ. -1) THEN
C-----  PATTERSON PEAKS - MAKE CENTRIC AND DROP TRANSLATIONS
        IF (ISSPRT .EQ. 0) THEN
          WRITE(NCWU,7710)
        ENDIF
7710    FORMAT(//,' Symmetry of the Patterson space group being used')
        IC = 1
        STORE(L2C) = 1.
        M2 = L2
        DO 7700 I = 1, N2
        CALL XZEROF (STORE(M2+9), 3)
        M2 = M2 + MD2
7700    CONTINUE
      ELSE IF (ISYMOD .EQ. 1) THEN
C----- NO SYMMETRY OPTION. MAKE NONCENTRO WITHOUT OPERATORS
        IF (ISSPRT .EQ. 0) WRITE(NCWU,7720)
7720    FORMAT(//,' No symmetry operators will be used')
        IC = 0
        STORE(L2C) = 0.
C-----  NO CENTRINGS
        STORE(L2C+1) = 1.
        IL = 1
        N2P = IL
C-----  IDENTITY OPERATOR ONLY
        N2 = 1
      ENDIF
C
      RETURN
      END
CODE FOR XFAL31
      SUBROUTINE XFAL31(IADDD,IADDA)
C--LOAD LIST 31 INTO STORE AND SET UP THE CONSTANTS TO ALLOW FOR CELL
C  PARAMETER ERRORS
C
C  IADDD  ADDRESS OF THE AREA ASSIGNED TO THE DISTANCE V/VC MATRIX
C         (AN AREA OF 12x12 = 144 WORDS)
C  IADDA  ADDRESS OF THE AREA ASSIGNED TO THE ANGLES V/CV MATRIX.
C         (15x15 = 225 WORDS LONG)
C
C
C--LIST 1 MUST ALREADY HAVE BEEN LOADED
C
C--THE TERMS ARE STORED AT 'L31T', AND OCCUPY 12 LOCATIONS
C
C--
C
      INCLUDE 'ICOM31.INC'
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLISTI.INC'
C
      INCLUDE 'XLST31.INC'
C
C
      INCLUDE 'QLST31.INC'
      INCLUDE 'QSTORE.INC'
C
C--LOAD LIST 31 FROM DISC
      INCLUDE 'IDIM31.INC'
      CALL XLDLST(31,ICOM31,IDIM31,0)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C----- SCALE THE ELEMENTS OF THE V/CV MATRIX
      A = STORE(L31K)
      M31 = L31
      M31L = M31 + MD31 -1
      DO 900 I = M31, M31L
        STORE(I)  =  STORE(I) * A
900   CONTINUE
C--FORM THE WORK AREA
      M31T=L31T
c      real metric tensor
      L=L1M1
c      real cell parameters
      N=L1P1
C--SET UP THE TERMS FOR THE CELL LENGTHS
c      [metric tensor] x [1/a(i) along diagonal]
      DO 1050 I=1,3
      A=1./STORE(N)
      DO 1000 J=1,3
      STORE(M31T)=STORE(L)*A
      M31T=M31T+1
      L=L+1
1000  CONTINUE
      N=N+1
1050  CONTINUE
C--SET UP THE TERMS FOR THE ANGLES
c      b x c x sin(alpha) etc
      STORE(M31T)=-STORE(L1P1+1)*STORE(L1P1+2)*SIN(STORE(L1P1+3))
      STORE(M31T+1)=-STORE(L1P1)*STORE(L1P1+2)*SIN(STORE(L1P1+4))
      STORE(M31T+2)=-STORE(L1P1)*STORE(L1P1+1)*SIN(STORE(L1P1+5))
c
C--SET UP THE V/VC MATRIX IN THE DISTANCE AND ANGLES AREAS
c     12x12 at iaddd and 15x15 at iadda. Top 6x6 filled-in cell vcv
      M31=L31
      I=IADDD
      M=IADDA
      DO 1150 I1=1,6
      J=I
      N=M
      DO 1100 I2=I1,6
      STORE(I)=STORE(M31)
      STORE(J)=STORE(M31)
      STORE(M)=STORE(M31)
      STORE(N)=STORE(M31)
      I=I+1
      J=J+12
      M31=M31+1
      M=M+1
      N=N+15
1100  CONTINUE
      I=I+6+I1
      M=M+9+I1
1150  CONTINUE
9900  CONTINUE
C -- NORMAL AND ERROR RETURN
      RETURN
      END
C
CODE FOR XAPP31
      SUBROUTINE XAPP31(IADD)
C--CALCULATE THE TERMS NEEDED FOR THE CELL ERRORS FOR THE
C  CURRENT PAIR OF ATOMS
C
C--'IADD' IS THE ADDRESS AT WHICH TO PUT THE RESULTS
C
C--'DX', 'DY' AND 'DZ' ARE STORED IN C, D AND E, WHILE F CONTAINS
C  THE RECIPROCAL OF THE DISTANCE
C
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST01.INC'
      COMMON /XDISTW/A,BB,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y
C
      INCLUDE 'XLST31.INC'
C
      INCLUDE 'QSTORE.INC'
C
C--COMPUTE A FEW INITIAL CONSTANTS
      YZ=D*E
      XZ=C*E
      XY=C*D
C--CALCULATE THE DIFFERENTIALS FOR THE CELL LENGTHS
      STORE(IADD)=F*(C*C*STORE(L31T)+XY*STORE(L31T+1)+XZ*STORE(L31T+2))
      STORE(IADD+1)=F*(XY*STORE(L31T+3)+D*D*STORE(L31T+4)
     2 +YZ*STORE(L31T+5))
      STORE(IADD+2)=F*(XZ*STORE(L31T+6)+YZ*STORE(L31T+7)
     2 +E*E*STORE(L31T+8))
C--CALCULATE THE DIFFERENTIALS FOR THE ANGLES
      STORE(IADD+3)=F*YZ*STORE(L31T+9)
      STORE(IADD+4)=F*XZ*STORE(L31T+10)
      STORE(IADD+5)=F*XY*STORE(L31T+11)
      RETURN
      END
C
CODE FOR XFPCES
      SUBROUTINE XFPCES( IADD12, ISTACK, NW, NPART)
C--FORM THE POSITIONAL COORDINATE ERROR STACK
C
C--ENTRY PARAMETERS ARE :
C
C  IADD12  ADDRESS OF THE PREAMBLE BLOCK FOR THIS ATOM IN LIST 12
C  ISTACK  ADDRESS AT WHICH TO PUT THE RESULTS FOR THIS ATOM
C          (THIS IS UPDATED BY THIS SUBROUTINE)
C  NW      NUMBER OF WORDS PER STACK ENTRY
C  NPART   SET BY THIS ROUTINE TO THE NUMBER OF 'LS PARTS' FOR THE ATOM
C
C--THIS STACK IS USED BY 'XCOVAR' TO FORM THE CORRECT V/VC MATRIX
C
C--THE FORMAT OF THE STACK IS :
C
C  0  PARAMETER NUMBER
C  1  ADDRESS OF THE DATA FOR THE BLOCK CONTAINING THIS PARAMETER
C  2  ADDRESS OF THE DIAGONAL ELEMENT IN LIST 11 FOR THIS PARAMETER
C  3  MULTIPLIER FOR THIS PARAMETER
C
C--IF THE COORDINATE HAS NOT BE REFINED, THE FORMAT IS :
C
C  0  -1
C  1  NOT DEFINED
C  2  DIAGONAL ELEMENT TO BE USED
C  3  MULTIPLIER FOR THIS PARAMETER
C
C----- THE STACK IS REPEATED NPART TIMES
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'QSTORE.INC'
C-dec09
c      write(ncwu,*) 'fpces in ', iadd12, istack, nw, npart
      NPART = 0
C----- GET THE FIRST PART HEADER
      J = KFPH (IADD12)
C
900   CONTINUE
C----- WE MUST ALWAYS TRY FOR A FIRST PART
C--LOOP OVER COORDINATES
      DO 1200 I=4,6
C----- FIND THE PARAMETER POSITION
      ISTORE(ISTACK) = KFPP (I, J, K)
C--IS THIS PARAMETER REFINED
      IF(ISTORE(ISTACK))1000,1000,1050
C--COORDINATE NOT REFINED
1000  CONTINUE
      STORE(ISTACK+2)=0.
      STORE(ISTACK+3)=0.
      GOTO 1150
C--SET UP THE REMAINING INFORMATION
1050  CONTINUE
      ISTORE(ISTACK+2)=KBLCK(ISTORE(ISTACK))
      ISTORE(ISTACK+1)=M12B
      STORE(ISTACK+3)=1.
C--CHECK IF THE 'WEIGHT' CAN DIFFER FROM UNITY
      IF(ISTORE(J+1)-1)1150,1150,1100
C--'WEIGHT' CAN DIFFER FROM UNITY
1100  CONTINUE
      STORE(ISTACK+3)=STORE(K+1)
1150  CONTINUE
c dec09
c      write(ncwu,'(a,4i12,2f12.4)')'         Stack',
c     1 istack, istore(istack),istore(istack+1),
c     2 istore(istack+2),store(istack+3)
      ISTACK=ISTACK+NW
1200  CONTINUE
      NPART = NPART+1
C----- ANY MORE PARTS TO PROCESS ?
      IF (J) 1350, 1350, 1250
1250  CONTINUE
      IF (ISTORE(J)) 1350, 1350, 1300
1300  CONTINUE
C----- MORE PARTS TO BE SET UP
      J = ISTORE (J)
      GOTO 900
1350  CONTINUE
C
c dec09
c      write(ncwu,*) 'fpces out', iadd12, istack, nw, npart
      RETURN
      END
C
CODE FOR XMVCD
      SUBROUTINE XMVCD(IADD1,NW1,IADD2,NW2)
C--MOVE VARIANCE - COVARIANCE DATA
C
C  IADD1  ADDRESS OF THE INFORMATION TO MOVE
C  NW1    LENGTH OF EACH ROW AS STORED AT IADD1
C  IADD2  ADDRESS AT WHICH TO PUT THE INFORMATION
C  NW2    LENGTH OF A ROW AT IADD2
C
C--NW1 IS ASSUMED TO BE LESS THAN OR EQUAL TO NW2
C
C--
      INCLUDE 'STORE.INC'
C
      I=IADD1
      J=IADD2
      DO 1050 K=1,NW1
      L=I
      M=J
      DO 1000 N=1,NW1
      STORE(M)=STORE(L)
      L=L+1
      M=M+1
1000  CONTINUE
      I=I+NW1
      J=J+NW2
1050  CONTINUE
      RETURN
      END
C
CODE FOR XMVCSP
      SUBROUTINE XMVCSP(IADD1,IADD2,NW2)
C--SET UP THE SYMMETRY INFORMATION IN THE V/VC AREA
C
C  IADD1  ADDRESS OF THE ATOM HEADER FROM WHICH THE SYMMETRY INFORMATION
C         SHOULD BE EXTRACTED.
C  IADD2  ADDRESS AT WHICH TO PUT THE INFORMATION
C  NW2    LENGTH OF A ROW AT IADD2
C
C--
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST02.INC'
C
      INCLUDE 'QSTORE.INC'
C
      NW1=3
      I=(IABS(ISTORE(IADD1+2))-1)*MD2+L2
      A=1.
      IF(ISTORE(IADD1+2))1000,1050,1050
1000  CONTINUE
      A=-1.
1050  CONTINUE
      J=IADD2
      DO 1150 K=1,NW1
      L=I
      M=J
      DO 1100 N=1,NW1
      STORE(M)=STORE(L)*A
      L=L+1
      M=M+1
1100  CONTINUE
      I=I+NW1
      J=J+NW2
1150  CONTINUE
      RETURN
      END
C
CODE FOR XCOVAR
      SUBROUTINE XCOVAR ( LS, NS, NW, LF, JA, IPART, NATOM)
C
C----- CALCULATE AN ATOMIC PARAMETER VARIANCE COVARIANCE MATRIX
C      FROM THE GIVEN LS PARAMETER V/COV MATRIX
C
C
C  LS  ADDRESS OF THE FIRST WORD OF THE STACK
C  NS  NUMBER OF ENTRIES IN THE STACK
C  NW  NUMBER OF WORDS PER ENTRY IN THE STACK
C  LF  ADDRESS AT WHICH TO SET UP THE V/CV MATRIX
C  JA  ADDRESS AT WHICH TO SET UP THE 'MULTIPLIERS' OR 'WEIGHTS'
C      AS A DIAGONAL MATRIX
C  IPART(NATOM) HOLDS THE NUMBER OF 'PARTS' FOR EACH ATOM
C
C--FORMAT OF THE STACK :
C
C  0  LEAST SQUARES PARAMETER NUMBER
C  1  ADDRESS OF THE BLOCK INFORMATION FOR THIS PARAMETER
C  2  ADDRESS OF THE DIAGONAL ELEMENT FOR THIS PARAMETER
C  3  COEFFICIENT FOR THIS PARAMETER
C
C--IF THE PARAMETER NUMBER IS NEGATIVE, THE FORMAT IS :
C
C  0  -1
C  1  NOT DEFINED
C  2  DIAGONAL ELEMENT TO USE
C  3  COEFFICIENT TO USE
C
C--THIS PATTERN IS REPEATED 'NS' TIMES STARTING FROM 'LS' EVERY 'NW' WOR
C
C--
      DIMENSION IPART(NATOM)
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XIOBUF.INC'
C
      DATA NPAR/3/
C
c dec09
c      write(ncwu,'(a,5i8,(10x,5i8))') 'Xcovar in ', 
c     1 LS, NS, NW, LF, JA,
c     2 (IPART(itemp), itemp=1, NATOM)

C----- CHECK IF ALL ATOMS HAVE ONLY ONE PART, GET NO. OF LS PARAMETERS
      NLS = 0
      MPART = 0
      DO 900 I = 1,NATOM
      NLS = NLS + NPAR * IPART(I)
      MPART = MAX( MPART, IPART(I) )
900   CONTINUE
      IF (MPART .EQ. 1) GOTO 950
C
C
C----- CONVERT THE VCV MATRIX FOR THE LS PARAMETERS INTO ONE FOR
C      THE PHYSICAL PARAMETERS.
C
C----- RESERVE SOME SPACE FOR THE LS VCV MATRIX
      NSS = NLS * NLS
      IVCV = KSTALL(NSS)
C----- RESERVE SOME SPACE FOR THE PARTIAL PRODUCT
      NPHYS = 3 * NATOM
      NPP = NLS * NPHYS
      IPP = KSTALL(NPP)
C----- RESERVE A PARTS PER PARAMETER VECTOR
      IPPV = KSTALL(NPHYS)
C----- RESERVE SPACE FOR THE DIAGONAL 'WEIGHTS' MATRIX
      IWTS = KSTALL(NSS)
C----- DID WE HAVE ENOUGH ROOM?
      IF (IERFLG .LE. 0) GOTO 9000
C
C----- FETCH THE LS VCV MATRIX
      CALL XGVCV (LS, NLS, NW, IVCV, IWTS)
C----- COMPRES THE 'WEIGHTS' MATRIX TO A VECTOR IN COLUMN 1
      J = IWTS
      K = IWTS
      DO 1300 I = 1,NLS
        STORE(J) = STORE(K)
        J = J + 1
        K = K + 1 + NLS
1300  CONTINUE
C
C----- SET UP THE PARTS-PER-PARAMETER VECTOR
      K = IPPV
      DO 1400 I = 1, NATOM
      ISTORE(K)   = IPART(I)
      ISTORE(K+1) = IPART(I)
      ISTORE(K+2) = IPART(I)
      K = K + 3
1400  CONTINUE
C
C----- FORM THE FIRST PARTIAL PRODUCT
      CALL XFVCV (NLS, NLS, NPHYS, STORE(IVCV), STORE(IWTS), STORE(IPP),
     1 ISTORE(IPPV), 1, 3 )
C
C----- FORM THE FINAL PRODUCT
      CALL XFVCV (NLS, NPHYS, NPHYS, STORE(IPP), STORE(IWTS), STORE(LF),
     1 ISTORE(IPPV), 2, 3 )
C
C----- GENERATE THE MODIFIED 'WEIGHT' MATRIX
      CALL XFWM ( NLS, NPHYS, STORE(IWTS), STORE(JA), ISTORE(IPPV), 3)
C
C----- RESTORE THE WORK AREA
      CALL XSTRLL (IVCV)
      GOTO 9900
C
950   CONTINUE
C----- ONE TO ONE CORRESPONDANCE BETWEEN PHYSICAL AND LS PARAMETERS
      CALL XGVCV ( LS, NS, NW, LF, JA)

C For consistency with the multi-part route through this routine,
C pre and post-multiply by weights (at JA) and then replace JA
C with a unit matrix.

C - Get some work space for the following calculation
      IVCV = KSTALL(NS*NS)
C - Premultiply VCV by multipliers.
      CALL XMLTMM ( STORE(JA),   STORE(LF), STORE(IVCV), NS, NS, NS )
C - Postmultiply VCV by multipliers.
      CALL XMLTMM ( STORE(IVCV), STORE(JA), STORE(LF),   NS, NS, NS )
C - Replace weights with unit matrix.
      CALL XUNTM ( STORE(JA), NS )
C - Hand back the work area.
      CALL XSTRLL (IVCV)


      GOTO 9900
C
9000  CONTINUE
      IF (ISSPRT .EQ. 0) WRITE(NCWU,9100)
      WRITE ( CMON ,9100)
      CALL XPRVDU(NCVDU, 1,0)
9100  FORMAT(' Error allocating space for e.s.d. calculation')
9900  CONTINUE
c dec09
c      write(ncwu,'(a,5i8,(10x,5i8))') 'Xcovar out', 
c     1 LS, NS, NW, LF, JA,
c     2 (IPART(itemp), itemp=1, NATOM)

      RETURN
      END
C
C
CODE FOR XFVCV
      SUBROUTINE XFVCV (IDM1, IDM2, IDM3, V, A, U, NPARTS, IPOINT, NPAR)
C
C----- MATRIX MULTIPLIER FOR GENERATION OF V/CV MATRIX FOR DERIVED PARAM
C
C---- CALLED TWICE.
C      IPOINT =  1 FOR FIRST CALL
C      ON BOTH CALLS,
C      IDM1 = NO OF LS PARAM
C      IDM3 = NO OF PHYSICAL PARAMS
C      NPAR = NUMBER OF PARAMETERS PER ATOM
C------ON FIRST CALL,
C      V IS LS V/CV MATRIX,
C      A IS 'WEIGHT' VECTOR, REPRESENTING TRANSPOSE OF DIAGONAL 'WEIGHT'
C      U IS THE PARTIAL PRODUCT MATRIX
C      NPARTS IS VECTOR OF LS PATRTS PER PHYSICAL PARAMETER
C      IDM2 = NO OF LS PARAMS
C
C------ON SECOND CALL
C      V IS PARTIAL PRODUCT MATRIX
C      A IS 'WEIGHT' VECTOR, REPRESENTING TRANSPOSE OF DIAGONAL 'WEIGHT'
C      U IS PHYSICAL V/CV MATRIX
C      IDM2 = NO OF PHYSICAL PARAMS
C
      DIMENSION V(IDM1,IDM2), A(IDM1), U(IDM2,IDM3), NPARTS(IDM3)
C
C      U(I,J) = SUM [ A(L)*V(L,I)], L = WEIGHT ELEMENTS FOR PARAMETER J
C
      LBASE = 0
      DO 1300 I = 1, IDM2
      IF (IPOINT .EQ. 1)    LBASE = 0
      INDEXF = I
      ISUB  = I
C
            DO 1200 J = 1,IDM3
            IF (IPOINT .EQ. 1) THEN
                  INDEXF = J
            ELSE
                  ISUB = J
            ENDIF
            LOFF = MOD (INDEXF-1, NPAR) + LBASE + 1
            SUM = 0.0
C
                  DO 1100 K = 1, NPARTS(INDEXF)
                  L = NPAR * (K-1)  + LOFF
                  SUM = SUM + V(L,ISUB) * A(L)
1100              CONTINUE
C
            U(I,J) = SUM
            IF (IPOINT .EQ. 1) THEN
             IF (MOD(INDEXF,NPAR).EQ.0) LBASE=LBASE+NPAR*NPARTS(INDEXF)
            ENDIF
1200        CONTINUE
C
      IF (IPOINT .NE. 1)  THEN
            IF (MOD(INDEXF,NPAR).EQ.0) LBASE=LBASE+NPAR*NPARTS(INDEXF)
      ENDIF
1300  CONTINUE
      RETURN


C e.g. FIRST CALL
c      DO 1300 I = 1, NLS
c        LBASE = 0
c        DO 1200 J = 1, NPHYS
c          SUM = 0.0
c          DO 1100 K = 1, NPARTS(J)
c            L = 3 * (K-1)  + MOD (J-1, 3) + LBASE + 1
c            SUM = SUM + V(L,I) * A(L)
c1100      CONTINUE
c          U(I,J) = SUM
c          IF (MOD(J,3).EQ.0) LBASE=LBASE+3*NPARTS(J)
c1200    CONTINUE
c1300  CONTINUE
c      RETURN
c
C e.g. SECOND CALL
c      LBASE = 0
c      DO 1300 I = 1, NPHYS
c        DO 1200 J = 1,NPHYS
c          SUM = 0.0
c          DO 1100 K = 1, NPARTS(I)
c            L = 3 * (K-1)  + MOD (I-1, 3) + LBASE + 1
c            SUM = SUM + V(L,J) * A(L)
c1100      CONTINUE
c          U(I,J) = SUM
c1200    CONTINUE
c        IF (MOD(I,3).EQ.0) LBASE=LBASE+3*NPARTS(I)
c1300  CONTINUE
c      RETURN

      END
C
CODE FOR XFWM
      SUBROUTINE XFWM (IDM1, IDM2, A, B, NPARTS, NPAR)
C
C----- GENERATE MODIFIED WEIGHT MATRIX FOR V-CV MATRIX
C
C      IDM1 = NO OF LS PARAM
C      IDM2 = NO OF PHYSICAL PARAMS
C      NPAR = NUMBER OF PARAMETERS PER ATOM
C      A IS 'WEIGHT' VECTOR, REPRESENTING DIAGONAL 'WEIGHT' MATRIX
C      B IS THE NEW 'WEIGHT' MATRIX FOR PHYSICAL PARAMS
C      NPARTS IS VECTOR OF LS PATRTS PER PHYSICAL PARAMETER
C
C
      DIMENSION A(IDM1), B(IDM2,IDM2), NPARTS(IDM2)
C
C      B(I,I) = SUM [ A(L)**2], L = WEIGHT ELEMENTS FOR PARAMETER I
C
C----- ZERO THE WEIGHT MATRIX
      NS = IDM2*IDM2
      CALL XZEROF (B(1,1),NS)
C
C
      LBASE = 0
      DO 1200 I = 1, IDM2
      INDEXF = I
C
      LOFF = MOD (INDEXF-1, NPAR) + LBASE + 1
      SUM = 0.0
C
             DO 1100 K = 1, NPARTS(INDEXF)
             L = NPAR * (K-1)  + LOFF
             SUM = SUM + A(L) * A(L)
1100         CONTINUE
C
C      B(I,I) = SUM
C RICHARD 2003 - I think this should be a unit matrix.
C the weights have already been applied.
      B(I,I) = 1.
      IF (MOD(INDEXF,NPAR).EQ.0) LBASE = LBASE + NPAR * NPARTS(INDEXF)
1200  CONTINUE
      RETURN
      END
C
C
CODE FOR XGVCV
      SUBROUTINE XGVCV ( LS, NS, NW, LF, JA)
C
C----- GET THE V/COV MATRIX FOR THE GIVEN LS PARAMETERS
C
C  LS  ADDRESS OF THE FIRST WORD OF THE STACK
C  NS  NUMBER OF ENTRIES IN THE STACK
C  NW  NUMBER OF WORDS PER ENTRY IN THE STACK
C  LF  ADDRESS AT WHICH TO SET UP THE V/CV MATRIX
C  JA  ADDRESS AT WHICH TO SET UP THE 'MULTIPLIERS' OR 'WEIGHTS'
C      AS A DIAGONAL MATRIX
C
C--FORMAT OF THE STACK :
C
C  0  LEAST SQUARES PARAMETER NUMBER
C  1  ADDRESS OF THE BLOCK INFORMATION FOR THIS PARAMETER
C  2  ADDRESS OF THE DIAGONAL ELEMENT FOR THIS PARAMETER
C  3  COEFFICIENT FOR THIS PARAMETER
C
C--IF THE PARAMETER NUMBER IS NEGATIVE, THE FORMAT IS :
C
C  0  -1
C  1  NOT DEFINED
C  2  DIAGONAL ELEMENT TO USE
C  3  COEFFICIENT TO USE
C
C--THIS PATTERN IS REPEATED 'NS' TIMES STARTING FROM 'LS' EVERY 'NW' WOR
C
C--
      INCLUDE 'TYPE11.INC'
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XSTR11.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QSTR11.INC'
C
      N=LS
      IA=LF
      L=NS*NS
      JB=LF+L-1
      IC=JA
      IB=JA
      DO 1000 I=LF,JB
      STORE(I)=0.
      STORE(IC)=0.
      IC=IC+1
1000  CONTINUE
c
cdjwjun2002
c- to fix the problem of zero esds on bonds across
c symmetry operators when atoms are on special
c positions.
c - initialise the diagonal weight matrix
      call xuntm(store(ja), ns)
C--FORM THE VARIANCE-COVARIANCE MATRIX
      DO 1600 I=1,NS
C--CHECK THAT THIS PARAMETER HAS BEEN REFINED
      IF(ISTORE(N))1050,1050,1100
C--NOT REFINED
1050  CONTINUE
      STORE(IA)=STORE(N+2)
cdjwjun2002      STORE(IB)=STORE(N+3)
      IA=IA+NS+1
      GOTO 1550
1100  CONTINUE
      K=ISTORE(N+2)
C--STORE THE DIAGONAL ELEMENTS
      STORE(IA)=STR11(K)
      STORE(IB)=STORE(N+3)
C--CHECK IF THIS IS THE LAST PARAMETER
      IF(I-NS)1150,1650,1650
1150  CONTINUE
      IC=IA+NS
      IA=IA+1
      ID=I+1
      M=N+NW
C--SET UP THE OFF-DIAGONAL TERMS
      DO 1500 J=ID,NS
C--CHECK THAT THE PARAMETER THAT WE HAVE MET IS TO BE REFINED
      IF(ISTORE(M))1450,1450,1200
C--CHECK IF THE TWO PARAMETERS ARE IN THE SAME BLOCK
1200  CONTINUE
      IF(ISTORE(N+1)-ISTORE(M+1))1450,1250,1450
C--COMPUTE THE ADDRESS OF THE OFF-DIAGONAL TERM IN THE L.S. MATRIX
1250  CONTINUE
      K=ISTORE(N)-ISTORE(M)
      IF(K)1300,1300,1350
1300  CONTINUE
      K=ISTORE(N+2)-K
      GOTO 1400
1350  CONTINUE
      K=ISTORE(M+2)+K
1400  CONTINUE
      STORE(IA)=STR11(K)
      STORE(IC)=STR11(K)
1450  CONTINUE
      M=M+NW
      IA=IA+1
      IC=IC+NS
1500  CONTINUE
      IA=IA+I
1550  CONTINUE
      IB=IB+NS+1
      N=N+NW
1600  CONTINUE
1650  CONTINUE
      RETURN
      END
C
CODE FOR XMD3B
      SUBROUTINE XMD3B(IADD1,IADD2,IADD3,N,N3)
C--MULTIPLY A DIAGONAL MATRIX ONTO A 3 BLOCK BAND MATRIX
C
C  IADD1  ADDRESS OF THE DIAGONAL MATRIX
C  IADD2  ADDRESS OF THE BAND MATRIX
C  IADD3  ADDRESS OF THE PRODUCT  -  ZEROS ARE NOT SET.
C  N      ORDER OF THE MATRICES DIVIDED BY 3
C  N3 (I.E. THE ORDER OF THE MATRICES)     =N*3
C
C--
      INCLUDE 'STORE.INC'
C
      K=IADD3
      L=IADD2
      M=IADD1
      DO 1050 I=1,N
      DO 1000 J=1,3
      A=STORE(M)
      STORE(K)=STORE(L)*A
      STORE(K+1)=STORE(L+1)*A
      STORE(K+2)=STORE(L+2)*A
      K=K+N3
      L=L+N3
      M=M+N3+1
1000  CONTINUE
      K=K+3
      L=L+3
1050  CONTINUE
      RETURN
      END
C
cCODE FOR XPRTA
c      SUBROUTINE XPRTA(A,L,M)
cC
cC
c      DIMENSION A(L,M)
cC
c\XUNITS
c\XSSVAL
cC
c      CALL XLINES
c      DO 1050 I=1,L
c      IF (ISSPRT .EQ. 0) THEN
c      WRITE(NCWU,1000)(A(I,J),J=1,M)
c      ENDIF
c1000  FORMAT(1X,9F13.9)
c1050  CONTINUE
c      RETURN
c      END

CODE FOR XVOID
      SUBROUTINE XVOID
C       CODE DEVISED AND PRODUCED BY ANDY BROWN AS A PART II PROJECT
C       FINDS VOIDS IN CRYSTAL STRUCTURE
C
C       THIS ROUTINE SEARCHES FOR THE ALL POINTS IN AN ASSYMETRIC
C       UNIT AND CHECKS IF IT IS WITHIN A CERTAIN DISTANCE OF ANY
C       OF THE ATOMS IN THE STRUCTURE SAVING THE POINTS WITH NO CONTACT.
C
C
C       LN1    INPUT LIST TYPE
C       LN2    OUTPUT LIST TYPE
C       TOLER   CURRENTLY A DUMMY
C
C       THE COMMON BLOCK /XWORKA/ IS USED :
C
C       JB  ADDRESS OF THE TEMP. STORAGE FOR ATOMS
C       JC  ADDRESS OF THE ATOM HEADER FOR MOVING ATOMS FROM 'JB'
C       JD  WORK SPACE FOR 'KATOMS'
C       JE  START OF DISTANCE STACK.
C       JF  NUMBER OF ATOMS LEFT TO SCAN
C       JG  CURRENT LAST ENTRY IN LIST 5 OR 10
C       JH  MD5-1
C       JI  MD5+MD5
C       JK  ADDRESS OF LAST ATOM ON PRINCIPAL DISTANCE STACK
C       JL  NEXT FREE ADDRESS AFTER PRINCIPAL DISTANCE STACK
C       JT  WORDS PER ENTRY IN THE STACK
C       JU  5 WORD WORK AREA
C       SX  DISTANCE NO BONDED CONTACT TO USE
C
C       THE FOLLOWING VARIABLES MUST BE SET ON ENTRY TO KDIST1:-
C
C       AT     MINIMUM ALLOWED DISTANCE FOR DISTANCES
C       AC     MAXIMUM ALLOWED DISTANCE FOR DISTANCES
C       BT     MINIMUM ALLOWED DISTANCE FOR ANGLES
C       BC     MAXIMUM ALLOWED DISTANCE FOR ANGLES
C       AO     MAXIMUM ALLOWED DISTANCE OVERALL
C       AP     MAXIMUM ALLOWED DISTANCES SQUARED OVERALL
C       BP     MINIMUM ALLOWED DISTANCE SQUARED OVERALL
C       M5A    ADDRESS OF THE CURRENT TARGET ATOM IN LIST 5
C       M5     ADDRESS OF THE FIRST ATOM TO MOVE AROUND IN LIST 5
C
C
C       ATOMS WHICH FORM ACCEPTABLE CONTACTS ARE STORED IN A STACK
C       WHICH HAS THE FOLLOWING FORMAT :
C
C       0  ADDRESS OF THE ATOM IN LIST 5
C       1  ACCEPTANCE FLAG
C
C          1  ACCEPTABLE TO NONE
C          2  DISTANCES ONLY
C          3  ANGLES ONLY
C          4  ACCEPTABLE TO BOTH
C
C       2  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CENTRE OF SYM
C       3  NON-PRIMITIVE LATTICE INDICATOR
C       4  T(X)
C       5  T(Y)
C       6  T(Z)
C       7  TRANSFORMED X
C       8  TRANSFORMED Y
C       9  TRANSFORMED Z
C      10  DISTANCE
C      11  DISTANCE SQUARED
C      12  ADDRESS IN LIST 12  (IF USED).
C      13  TARGET CONTACT DISTANCE FOR RESTRAINTS (OPTIONAL)
C
C
      CHARACTER *80 CSRQ
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'ICOM12.INC'
C
      PARAMETER (NCONT=2)
      DIMENSION INCONT(NCONT)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XWORKA.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST14.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'
C
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QLST12.INC'
C
C----- MAXIMUM DISTANCE FOR A 1-3 CONTACT, AND ITS SQUARE
      DATA D13 / 3.0 /, D13S / 9.0 /
      DATA TOLER /0.6/, ITRANS / 0 /
C
C-------SET THE INITIAL TIMING
C
      CALL XTIME1(2)
C
C-------READ THE INPUT DATA
C
      IF ( KLEXAN(IULN,IFIRST,LENGTH) .LT. 0 ) GO TO 9910
C
C-------DATA INPUT  -  CLEAR THE STORE
C
      CALL XRSL
      CALL XCSAE
C
C-------CLEAR A BUFFER
C
      JU = NFL
      NFL = NFL + 5
C
C-------LOAD THE INPUT LIST
C
      LN1=KTYP05(MX)
      CALL XLDR05(LN1)
      IF ( IERFLG .LT. 0 ) GO TO 9900
C
C-------FIND THE OUTPUT LIST TYPE
C
      LN2=KTYP05(MY)
C
C-------SET THE DEFAULT TEMPERATURE FACTOR OR MULTIPLIER(****CHANGE THIS
C
      JT=12
      BMAX = D13
      AT = 0.5
      AC = D13
C-------NO ANGLES TO BE LOOKED FOR
      BT = 0.
      BC = 0.
C-------SET THE INPUT PARAMETER DEFAULTS
      SX=3.0
C
C-------LOAD LISTS 1 AND 2, AND SET UP SOME CONSTANTS
      CALL XDIST2
C
C-------LOAD THE FOURIER LIMITS
      CALL XFAL14
C
C-------RESOLUTION
      RES=0.8
      J = 27
      DO 500 I = 1,NCONT
      INCONT(I) = J
      J = J -12
500   CONTINUE
C
      IF ( IERFLG .LT. 0 ) GO TO 9900
C
C--SET THE DIMENSION OF THE COMMON BLOCK FOR LIST 12
      IDIM12=40
C--INDICATE THAT LIST 12 IS NOT TO BE USED
      DO 1050 I=1,IDIM12
      ICOM12(I)=NOWT
1050  CONTINUE
      L12=-1
      M12=-1
C-------SET UP A FEW STACK CONSTANTS
      JB=NFL
      JC=JB+MD5
      JD=JC+20
      JE=JD+30
C-------CHECK THE STORE AREA
      IF ( JE - LFL ) 1000 , 9920 , 9920
1000  CONTINUE
C
C-------PREPARE FOR PROCESSING OF THE LEXICAL SCANNER OUTPUT
      CALL XILEXP(IULN,IFIRST)
C
C-------MAIN INSTRUCTION CYCLING LOOP  -  SET THE BUFFER ADDRESS AFTER T
1100  CONTINUE
      IF(KLDNLR(I))2100, 1150, 4200
C
C-------SET THE POINTER TO THE ATOM STACK
1150  CONTINUE
      GOTO (1250, 1750, 1600, 1200), MG
1200  STOP346
C
C-------'DISTANCE' INSTRUCTION
1250  CONTINUE
      IF(ME)1300,1300,1400
1300  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1350)
1350  FORMAT(/19H No arguments found)
      GOTO 4200
C
C-------READ THE DISTANCE FOR NON-BONDED CONTACT
1400  CONTINUE
      IF(KSYNUM(Z))1450,1550,1450
1450  CONTINUE
      CALL XPCLNN(LN)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1500)ISTORE(MF+1)
1500  FORMAT(/35H New value of wrong type or missing,
     2 16H at about column,I5)
      GOTO 4200
1550  CONTINUE
      SX=Z
      BMAX = SX
      AT = 0.5
      AC = SX
      GOTO 4250
C
C-------'CONTACTS' INSTRUCTION
1600  CONTINUE
      IF(ME)1300,1300,1650
1650  CONTINUE
      DO 1665 I = 1, NCONT
C
C-------READ THE DISTANCE FOR NON-BONDED CONTACT
      IF(KSYNUM(Z))1450,1660,1450
1660  CONTINUE
      INCONT(I) = NINT(Z)
1665  CONTINUE
      GOTO 4250
C
C-------'RESOLUTION' INSTRUCTION
1750  CONTINUE
      IF(ME)1300,1300,1800
C
C-------CHECK THE TYPE OF ARGUMENT
1800  CONTINUE
      IF(KSYNUM(Z))1450,2000,1450
C
C-------STORE THE NUMBER AND RESET THE FLAG
2000  CONTINUE
      RES = Z
      GOTO 4250
C
C
C-------MAIN TERMINATION ROUTINES
2100  CONTINUE
C(****CHANGE THIS****)
2110  FORMAT ('Dist. of contacts is',F6.2/'Grid resolution is'
     2,F6.2/'Contact are R gt ',I2,',L lt ',I2,',else M atoms')
      WRITE(NCAWU,2110) AC,RES,INCONT(1),INCONT(2)
C
C-------ASSYMETRIC UNIT DIMENSIONS
      AS1=STORE(L14+2)-STORE(L14)
      AS2=STORE(L14+8)-STORE(L14+6)
      AS3=STORE(L14+14)-STORE(L14+12)
C
C-------WE NEED TO SCALE THE LIMITS BY THE RESOLUTION AND TURN INTO
C-------INTEGERS-GET NWE RESOLUTIONS IN EACH DIRECTION SO NO PART
C-------OF RELEVANT CELL IS LOST.
C
      NARBA=NINT((STORE(L1P1)*AS1)/RES)
      RESX =(STORE(L1P1)*AS1)/FLOAT(NARBA)
      NARBA=NINT(STORE(L1P1)/RESX)
 
      NARBB=NINT((STORE(L1P1+1)*AS2)/RES)
      RESY =(STORE(L1P1+1)*AS2)/FLOAT(NARBB)
      NARBB=NINT(STORE(L1P1+1)/RESY)
 
      NARBC=NINT((STORE(L1P1+2)*AS3)/RES)
      RESZ =(STORE(L1P1+2)*AS3)/FLOAT(NARBC)
      NARBC=NINT(STORE(L1P1+2)/RESZ)
C
C
C-------SET THE TARGET ATOM ADDRESSES
      IATOM = 0
      IABAT=NFL
      M5A = IABAT
      NFL=NFL+6
C
C-------SAVE CURRENT SRQ
C
      CALL XSSRQ(IADSRQ,NSRQ)
C
C-------LOOP OVER ASSYMETRIC UNIT
C
      DO 3351 IABX=NARBA*STORE(L14)+1,NARBA*STORE(L14+2)+1
      STORE(IABAT+4)=FLOAT(IABX-1)/FLOAT(NARBA)
         DO 3352 IABY=NARBB*STORE(L14+6)+1,NARBB*STORE(L14+8)+1
         STORE(IABAT+5)=FLOAT(IABY-1)/FLOAT(NARBB)
            DO 3353 IABZ=NARBC*STORE(L14+12)+1,
     2                   NARBC*STORE(L14+14)+1
            STORE(IABAT+6)=FLOAT(IABZ-1)/FLOAT(NARBC)
C
C-------INITIALISE A DUMMY ATOM
C
            STORE(IABAT+2)=1.0
            STORE(IABAT+3)=1.0     ! New format L5 - this is the flag
C
C-------FIX THE RADII FOR 1-2 CONTACTS
            AO = AC
            AP = AC * AC
C
C-------BEGINNING OF LIST 5
C-------RESET THE CONTACT ATOM AND FUNCTION VECTOR ADDRESSES
            M5=L5
C
C
C-------RESET BEGINNING OF DISTANCE STACK TO JE EVERY TIME
            NFL=JE
C
C
C ----- SET JFNVC TO 'NOWT' TO REDUCE SEARCH TIME
            JFNVC = NOWT
            NBONDS = 0
C-------COMPUTE DISTANCE STACK TO A TWO BOND MAXIMUM
            NDIST = KDIST1( N5, JL, JT, JFNVC, TOLER, ITRANS, 0, 4,0)
            NBONDS = NDIST
C-------JK IS CURRENT NEXT FREE ADDRESS - SAVE AND SET LAST ENTRY
            NFL = JL
            JK = JL - JT
C
3350   CONTINUE
            IF(NBONDS.LE.0) THEN
C-------WE ARE INTERESTED IN THIS POINT
            IATOM = IATOM + 1
            IF(IATOM.EQ.1) THEN
C-------WRITE TO THE SYSTEM REQUEST FILE(SRQ)
C
            CSRQ(1:80) = ' '
            CSRQ(1:80) = '#EDIT'
            CALL XISRC(CSRQ)
            END IF
C
C-------LOOP OVER 26 ADJACENT POINTS TESTING FOR CONTACTS
C
            CONT=0
            DO 3354 IX1=-1,1
            STORE(IABAT+4)=(FLOAT(IABX-1)/FLOAT(NARBA))
     2                     +IX1/(FLOAT(NARBA))
               DO 3355 IY1=-1,1
               STORE(IABAT+5)=(FLOAT(IABY-1)/FLOAT(NARBB))
     2                        +IY1/(FLOAT(NARBB))
                  DO 3356 IZ1=-1,1
                  STORE(IABAT+6)=(FLOAT(IABZ-1)/FLOAT(NARBC))
     2                          +IZ1/(FLOAT(NARBC))
C
C
C-------BEGINNING OF LIST 5
C-------RESET THE CONTACT ATOM AND FUNCTION VECTOR ADDRESSES
                  M5=L5
C
C
C-------RESET BEGINNING OF DISTANCE STACK TO JE EVERY TIME
                  NFL=JE
C
C
                  MBONDS = 0
C-------COMPUTE DISTANCE STACK TO A TWO BOND MAXIMUM
                  MDIST = KDIST1( N5, JL, JT, JFNVC,TOLER,ITRANS,0,4,0)
                  MBONDS = MDIST
C-------JK IS CURRENT NEXT FREE ADDRESS - SAVE AND SET LAST ENTRY
                  NFL = JL
                  JK = JL - JT
C
3357  CONTINUE
                  IF(MBONDS.LE.0) THEN
C-------ADJACENT POINT IN VOID
                  CONT = CONT + 1
                  END IF
3356              CONTINUE
3355           CONTINUE
3354        CONTINUE
C
C-------RESET TO ORIGINAL ATOM
C
            STORE(IABAT+4)=FLOAT(IABX-1)/FLOAT(NARBA)
            STORE(IABAT+5)=FLOAT(IABY-1)/FLOAT(NARBB)
            STORE(IABAT+6)=FLOAT(IABZ-1)/FLOAT(NARBC)
C
C-------WE NOT IN AN ATOM SO SAVE POINT IN SRQ
C
            CSRQ = ' '
            IF (CONT.GE.INCONT(1)) THEN
            WRITE(CSRQ,'(A7,I4,5F11.6)')'ATOM R ',
     2         IATOM, STORE(IABAT+2), STORE(IABAT+3),
     3         STORE(IABAT+4), STORE(IABAT+5), STORE(IABAT+6)
            ELSE IF (CONT.LE.INCONT(2)) THEN
            WRITE(CSRQ,'(A7,I4,5F11.6)')'ATOM L ',
     2         IATOM, STORE(IABAT+2), STORE(IABAT+3),
     3         STORE(IABAT+4), STORE(IABAT+5), STORE(IABAT+6)
            ELSE
            WRITE(CSRQ,'(A7,I4,5F11.6)')'ATOM M ',
     2         IATOM, STORE(IABAT+2), STORE(IABAT+3),
     3         STORE(IABAT+4), STORE(IABAT+5), STORE(IABAT+6)
            END IF
            CALL XISRC(CSRQ)
            END IF
3353        CONTINUE
3352     CONTINUE
3351  CONTINUE
C
      IF (IATOM.GT.0) THEN
C-------END EDIT LIST5
C
      CSRQ(1:80) = ' '
      CSRQ(1:80) = 'END'
      CALL XISRC(CSRQ)
      END IF
      WRITE (NCAWU,*) 'no. of pseudo atoms=',IATOM
C
C-------REINSTATE PREVIOUS SRQ
C
      CALL XRSRQ(IADRSQ,NSRQ)
C
C
3720  CONTINUE
C
C-------END ROUTINE
      GO TO 9000
C
C
C-------ERROR EXIT FOR THESE ROUTINES
4200  CONTINUE
      CALL XPCA(ISTORE(MD+4))
      LEF=LEF+1
4250  CONTINUE
      GOTO 1100
C
C-------FINAL MESSAGES
9000  CONTINUE
C
      CALL XOPMSG ( IOPLSM , IOPEND , 500 )
C
      CALL XTIME2(2)
      CALL XCSAE
      CALL XRSL
      RETURN
9900  CONTINUE
C
C-------ERRORS
      CALL XOPMSG ( IOPHYD , IOPABN , 0 )
      GO TO 3720
9910  CONTINUE
C
C-------INPUT ERRORS
      CALL XOPMSG ( IOPHYD, IOPCMI, 0 )
      GO TO 9900
9920  CONTINUE
C
C-------INSUFFICIENT SPACE
      CALL XOPMSG ( IOPHYD , IOPSPC , 0 )
      GO TO 9900
C
      END


CODE FOR XBOND
      SUBROUTINE XBOND
C--INPUT OR EXTEND A LIST 40 (BONDING INFO)

      INCLUDE 'TYPE11.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XSTR11.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST11.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'QSTR11.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'ICOM40.INC'
      INCLUDE 'QLST40.INC'
      INCLUDE 'XLST50.INC'
      DIMENSION PROCS(35)
      DATA IDIMN /35/
      INCLUDE 'IDIM40.INC'

C -- Start the clock.
      CALL XTIME1(2)

C -- Clear something.
      CALL XCSAE

C -- ALLOCATE A 100 byte BUFFER in store FOR COMMAND PROCESSING.
C -- MQ is a common block variable used by the lexical routines.
      MQ = KSTALL ( 100 )

C----- INITIALISE LEXICAL INPUT
      ICHNG=1                       ! Ensure all directives appear read
      CALL XLXINI (INEXTD, ICHNG)   ! This also sets INEXTD to -1


C---- RESERVE A COMMAND LINE BUFFER OF 8 ELEMENTS
      JDIMBF = 8
      IDIMBF = JDIMBF+IDIMN
      ICOMBF = KSTALL(IDIMBF)
      JCOMBF = ICOMBF+JDIMBF

C----- ZERO THE BUFFER
      CALL XZEROF( ISTORE(ICOMBF), IDIMBF)

C----- INSTRUCTION READING LOOP processes one line at a time.
100   CONTINUE

C----- READ A DIRECTIVE
      IDIRNM = KLXSNG(ISTORE(ICOMBF),IDIMBF,INEXTD)

      IF (IDIRNM .LT. 0) GOTO 100
      IF (IDIRNM .EQ. 0) GOTO 1000

C -- Jump depending on the directive given:
      GOTO( 210, 220, 230, 240, 250, 200, 9910), IDIRNM
      GOTO 9910





200   CONTINUE
C -- '#BONDING' - extra instruction line parameters:

      IEXTEN = ISTORE(ICOMBF+11)    ! REPLACE or EXTEND current L40?
      IEXIST = KEXIST(40)           ! Does L40 even exist?

      IF ( ( IEXTEN .EQ. 1 ) .AND. ( IEXIST .GE. 1 ) )THEN
C -- Load existing list forty (ready for overwriting):
        CALL XLDLST ( 40, ICOM40, IDIM40, -1 )
        IF ( IERFLG .LT. 0 ) GO TO 9900

        KCOM40 = KSTALL ( IDIM40 )
C -- Copy list40 common block for safe keeping:
        CALL XMOVEI(ICOM40(1),ISTORE(KCOM40),IDIM40)

c        WRITE(CMON,'(/A/)') 'Loaded existing list 40, common block is:'
c        CALL XPRVDU(NCVDU, 3,0)
c        DO I = 1, IDIM40, 4
c          WRITE(CMON,'(4I10)') ( ICOM40(I+J),J=0,3 )
c          CALL XPRVDU(NCVDU, 1,0)
c        END DO
c        WRITE(CMON,'(/A/)') 'Data dump is:'
c        CALL XPRVDU(NCVDU, 3,0)
c        K = ICOM40(1)-8
c        WRITE(CMON,'(I4,A,8I9)') K,':',(ISTORE(K+J),J=0,7)
c        CALL XPRVDU(NCVDU, 1,0)
c        DO I = 1, 21, 4
c          K = ICOM40(I)+(ICOM40(I+3)*ICOM40(I+2))
c          WRITE(CMON,'(I4,A,8I9)') K,':',(ISTORE(K+J),J=0,7)
c          CALL XPRVDU(NCVDU, 1,0)
c        END DO

      ELSE
        IEXTEN = 0 !Not extending if there was no existing list.

      END IF

C -- Initialise some counters/pointers.
      LNXTL = 0  !next free store for storing data as it is read in.
      LFRST = 0  !the beginning of the chain of stored data as read in.
      KDEFAL = 0 !Flag - whether 'default' card is given.
C -- The number of each type of card read in:
      NELEM = 0
      NPAIR = 0
      NMAKE = 0
      NBREAK = 0
      NFORCE = 0
      GOTO 100

210   CONTINUE
C -- 'DEFAULTS' DIRECTIVE
C If the user provides their own DEFAULT card then overide the existing one.
C DEFAULTS directive takes up 3 words. Allocate 5 words:
      IF ( KDEFAL .EQ. 1 ) GOTO 9920
      I = 3
      LLSTL = LNXTL
      LNXTL = KSTALL ( I + 2 )
      ISTORE(LNXTL+1) = 6    ! Flag for DEFAULTS data
      CALL XMOVE(STORE(ICOMBF+20),STORE(LNXTL+2),I)
      KDEFAL = 1
      GOTO 300

220   CONTINUE
C -- 'ELEMENT' DIRECTIVE
C ELEMENT directive takes up 3 words. Allocate 5 words:
      I = 3
      LLSTL = LNXTL
      LNXTL = KSTALL ( I + 2 )
      ISTORE(LNXTL+1) = 1    ! Flag for ELEMENT data
      CALL XMOVE(STORE(ICOMBF+20),STORE(LNXTL+2),I)
      NELEM = NELEM + 1
      GOTO 300

230   CONTINUE
C -- 'PAIR' DIRECTIVE
C PAIR directive takes up 5 words. Allocate 7 words:
      I = 5
      LLSTL = LNXTL
      LNXTL = KSTALL ( I + 2 )
      ISTORE(LNXTL+1) = 2    ! Flag for PAIR data
      CALL XMOVE(STORE(ICOMBF+20),STORE(LNXTL+2),I)
      NPAIR = NPAIR + 1
      GOTO 300

240   CONTINUE
C -- 'MAKE' DIRECTIVE
C MAKE directive takes up 15 words. Allocate 17 words:
      I = 15
      LLSTL = LNXTL
      LNXTL = KSTALL ( I + 2 )
      ISTORE(LNXTL+1) = 3    ! Flag for MAKE data
C -- Read the bond info from the card e.g. C(19) TO C(20):
      II = KLXBND ( ICOMBF+20 )
241   CONTINUE
      J = KNUMBR ( Z )
      IF ( J .GT. 0 ) THEN ! Not a number, nor the end of the line.
C -- Advance to the next thing on the CARD.
        ME = ME - 1
        MF = MF + LK2
        GOTO 241 
      ELSE IF ( J .EQ. 0 ) THEN ! This is the number we are looking for.
        ISTORE(ICOMBF+34)=NINT(Z)
      ELSE                     ! End of the line. Default to zero.
        ISTORE(ICOMBF+34)=0
      END IF
      CALL XMOVE(STORE(ICOMBF+20),STORE(LNXTL+2),I)
      NMAKE = NMAKE + 1
      GOTO 300

250   CONTINUE
C -- 'BREAK' DIRECTIVE
C BREAK directive takes up 14 words. Allocate 16 words:
      I = 14
      LLSTL = LNXTL
      LNXTL = KSTALL ( I + 2 )
      ISTORE(LNXTL+1) = 4    ! Flag for BREAK data
C -- Read the bond info from the card e.g. C(19) TO C(20):
      II = KLXBND ( ICOMBF+20 )
      CALL XMOVE(STORE(ICOMBF+20),STORE(LNXTL+2),I)
      NBREAK = NBREAK + 1
      GOTO 300


300   CONTINUE
      IF ( LLSTL.GT.0 ) THEN
C -- Store pointer to this new record in the last record.
        ISTORE(LLSTL) = LNXTL
      ELSE
C -- This is the first record, keep a pointer.
        LFRST = LNXTL
      END IF
C -- Ensure this pointer is zero. (Marks end of chain).
      ISTORE(LNXTL) = 0 
      GO TO 100

1000  CONTINUE
C
C -- COMMAND INPUT COMPLETE. CHECK FOR ERRORS
      IF ( LEF .GT. 0 ) GO TO 9910

      IPLACE = LFRST
      DO WHILE (IPLACE .NE. 0)
C Check flag for this link. If it is an element then add into new L40.
         IF ( ISTORE(IPLACE+1).EQ.1 ) THEN
            WRITE(CMON,'(A,I7,2A,2F12.0)')'At ',IPLACE,': ', 
     1              ISTORE(IPLACE+2),STORE(IPLACE+3),STORE(IPLACE+4)
            CALL XPRVDU(NCVDU, 1,0)
         END IF
         IPLACE = ISTORE(IPLACE)
C         IF ( IPLACE .EQ. 0 ) EXIT
      END DO


      IF ( IEXTEN .EQ. 0 ) THEN

C -- C R E A T E   A   N E W   L I S T   4 0:

         IDWZAP = 0
         CALL XFILL (IDWZAP, ICOM40, IDIM40)
         N40T = 1
         N40E = 0
         N40P = 0
         N40M = 0
         N40B = 0
         CALL XCELST ( 40, ICOM40, IDIM40 )
      END IF


C -- L40T - the DEFAULTS card. There is only ever one of these,
C -- so we can overwrite this (if given).

      IPLACE = LFRST
      DO WHILE (IPLACE .NE. 0)
C Check flag for this link. If it is a DEFAULTS then add into new L40.
         IF ( ISTORE(IPLACE+1).EQ.6 ) THEN
            CALL XMOVE( STORE(IPLACE+2), STORE(L40T), MD40T )
         END IF
         IPLACE = ISTORE(IPLACE)
      END DO


C -- L40E - the ELEMENT cards.
      ISTAT = KHUNTR(40,102,IADDL,IADDR,IADDD,-1)
      IF ( ISTAT.NE.0 ) GOTO 9900
      LDATA = ISTORE(IADDR+3)
      
C -- Move existing ELEMENT data if there is any.
      NEWDAT = KSTALL ((N40E + NELEM)*MD40E)
      NMOVE = MD40E * N40E
      IF ( NMOVE .GT. 0 ) THEN
        CALL XMOVE( STORE(LDATA), STORE(NEWDAT), NMOVE )
      END IF
      ISTORE(IADDR+3) = NEWDAT        ! Change header pointer to data

C -- Then the new ELEMENT cards.
      IPLACE = LFRST
      I = NEWDAT + NMOVE
      DO WHILE (IPLACE .NE. 0)
C Check flag for this link. If it is an ELEMENT then add into new L40.
         IF ( ISTORE(IPLACE+1).EQ.1 ) THEN
            CALL XMOVE( STORE(IPLACE+2), STORE(I), MD40E )
            I = I + MD40E
            N40E = N40E + 1
         END IF
         IPLACE = ISTORE(IPLACE)
      END DO



C -- L40P - the PAIR cards.
      ISTAT = KHUNTR(40,103,IADDL,IADDR,IADDD,-1)
      IF ( ISTAT.NE.0 ) GOTO 9900
      LDATA = ISTORE(IADDR+3)
      
C -- Move existing PAIR data if there is any.
      NEWDAT = KSTALL ((N40P + NPAIR)*MD40P)
      NMOVE = MD40P * N40P
      IF ( NMOVE .GT. 0 ) THEN
        CALL XMOVE( STORE(LDATA), STORE(NEWDAT), NMOVE )
      END IF
      ISTORE(IADDR+3) = NEWDAT        ! Change header pointer to data

C -- Then the new PAIR cards.
      IPLACE = LFRST
      I = NEWDAT + NMOVE
      DO WHILE (IPLACE .NE. 0)
C Check flag for this link. If it is an PAIR then add into new L40.
         IF ( ISTORE(IPLACE+1).EQ.2 ) THEN
            CALL XMOVE( STORE(IPLACE+2), STORE(I), MD40P )
            I = I + MD40P
            N40P = N40P + 1
         END IF
         IPLACE = ISTORE(IPLACE)
      END DO



C -- L40M - the MAKE cards.
      ISTAT = KHUNTR(40,104,IADDL,IADDR,IADDD,-1)
      IF ( ISTAT.NE.0 ) GOTO 9900
      LDATA = ISTORE(IADDR+3)
      
C -- Move existing MAKE data if there is any.
      NEWDAT = KSTALL ((N40M + NMAKE)*MD40M)
      NMOVE = MD40M * N40M
      IF ( NMOVE .GT. 0 ) THEN
        CALL XMOVE( STORE(LDATA), STORE(NEWDAT), NMOVE )
      END IF
      ISTORE(IADDR+3) = NEWDAT        ! Change header pointer to data

C -- Then the new MAKE cards.
      IPLACE = LFRST
      I = NEWDAT + NMOVE
      DO WHILE (IPLACE .NE. 0)
C Check flag for this link. If it is a MAKE then add into new L40.
         IF ( ISTORE(IPLACE+1).EQ.3 ) THEN
C Check if this "make" already exists...
           ISTAT = 0
           OUTER1: DO J = NEWDAT, NEWDAT+(N40M*MD40M), MD40M
              INNER1: DO K = 0,MD40M-2 !ignore bondtype
                 IF ( ISTORE(IPLACE+2+K) .NE. ISTORE(J+K) ) THEN
                    CYCLE OUTER1
                 ENDIF
              END DO INNER1
              ISTAT = J
              EXIT OUTER1
           END DO OUTER1
           IF ( ISTAT.EQ.0 ) THEN
C Try testing atom names the other way around.
             OUTER2: DO J = NEWDAT, NEWDAT+(N40M*MD40M), MD40M
                INNER2: DO K = 0,6
                   IF ( ISTORE(IPLACE+2+K) .NE. ISTORE(J+K+7) ) THEN
                      CYCLE OUTER2
                   ENDIF
                END DO INNER2
                INNER3: DO K = 0,6
                   IF ( ISTORE(IPLACE+2+K+7) .NE. ISTORE(J+K) ) THEN
                      CYCLE OUTER2
                   ENDIF
                END DO INNER3
                ISTAT = J
                EXIT OUTER2
             END DO OUTER2
           END IF
           IF ( (ISTAT .EQ. 0) .AND. (ISTORE(IPLACE+16).GE.0) ) THEN
C Normal MAKE card.
             CALL XMOVE( STORE(IPLACE+2), STORE(I), MD40M )
             I = I + MD40M
             N40M = N40M + 1
           ELSE IF ( ISTAT .EQ. 0 ) THEN
C Make card with -ve bond type, but can't find bond type to remove - do nothing.
             CONTINUE
           ELSE IF ( ISTORE(IPLACE+2+14).GE.0 ) THEN
C Record already exists. Just change the bondtype.
             ISTORE(J+14) = ISTORE(IPLACE+2+14)
           ELSE
C Record already exists, and is to be removed.
             CALL XMOVE( STORE(J+MD40M), STORE(J), NEWDAT+N40M*MD40M-J)
           END IF
         END IF
         IPLACE = ISTORE(IPLACE)
      END DO


C -- L40B - the BREAK cards.
      ISTAT = KHUNTR(40,105,IADDL,IADDR,IADDD,-1)
      IF ( ISTAT.NE.0 ) GOTO 9900
      LDATA = ISTORE(IADDR+3)
      
C -- Move existing BREAK data if there is any.
      NEWDAT = KSTALL ((N40B + NBREAK)*MD40B)
      NMOVE = MD40B * N40B
      IF ( NMOVE .GT. 0 ) THEN
        CALL XMOVE( STORE(LDATA), STORE(NEWDAT), NMOVE )
      END IF
      ISTORE(IADDR+3) = NEWDAT        ! Change header pointer to data

C -- Then the new BREAK cards.
      IPLACE = LFRST
      I = NEWDAT + NMOVE
      DO WHILE (IPLACE .NE. 0)
C Check flag for this link. If it is a BREAK then add into new L40.
         IF ( ISTORE(IPLACE+1).EQ.4 ) THEN
            CALL XMOVE( STORE(IPLACE+2), STORE(I), MD40B )
            I = I + MD40B
            N40B = N40B + 1
         END IF
         IPLACE = ISTORE(IPLACE)
      END DO

                
C -- Write new list back to disk.

      CALL XWLSTD (40,ICOM40,IDIM40,0,1)




C--TERMINATION MESSAGES
6050  CONTINUE
      CALL XOPMSG ( IOPDIS, IOPEND, IVERSN )
C -- Stop the clock. Stop the clock!
      CALL XTIME2(2)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDIS , IOPABN , 0 )
      GO TO 6050
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDIS , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
C -- Default card more than once.
      WRITE(CMON,'(A)')'The DEFAULTS card may only appear once.'
      CALL XPRVDU(NCVDU, 1,0)
      GO TO 9900


      END







CODE FOR KLXBND
      FUNCTION KLXBND(IADDR)
C Routine to read two atoms from the lexical input of the form
C "C(21) TO C(22)" or "C(21,1,1,0,0,1) TO C(4,-1,0,1,2)" and place
C them in 14 bytes of STORE. The stack format is:
C
C 1 & 8       TYPE
C 2 & 9       SERIAL
C 3 & 10      S
C 4 & 11      L
C 5 & 12      TX
C 6 & 13      TY
C 7 & 14      TZ
C
C      IADDR       PLACE IN STORE TO PUT THE RESULTS
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'QSTORE.INC'
#if defined (_HOL_)
      DATA ICTO/4HTO  /
#else
      DATA ICTO/'TO  '/
#endif
C -- SEARCH INPUT FOR TYPE/ATOM SPECIFIERS

      IGTONE = 0

1000  CONTINUE

      KBDMQ = MQ

      II = KATOMH(MQ)

      MQ = KBDMQ

      IF(II.LT.0) THEN
C--END OF CARD - back ONE.
        MF=MF-LK2
        CALL XADE(ISTORE(MF+1))
        KLXBND = II
        RETURN
      ELSE IF (II.EQ.0) THEN
        CALL XADE(ISTORE(MF+1))
        KLXBND = II
        RETURN
      END IF

C Copy info for atom into the output stack.
      ISTORE(IADDR)   = ISTORE(MQ+2)
      ISTORE(IADDR+1) = NINT(STORE(MQ+3)) !Serial real->int.
      ISTORE(IADDR+2) = ISTORE(MQ+7)
      ISTORE(IADDR+3) = ISTORE(MQ+8)
      ISTORE(IADDR+4) = ISTORE(MQ+9)
      ISTORE(IADDR+5) = ISTORE(MQ+10)
      ISTORE(IADDR+6) = ISTORE(MQ+11)

      IF ( IGTONE .EQ. 0 ) THEN
        IADDR = IADDR + 7
        IGTONE = 1
C -- If no more things on this CARD, then error!
        IF (ME.LE.0) THEN
          MF=MF-LK2
          CALL XADE(ISTORE(MF+1))
          KLXBND = -1
          RETURN
        END IF
C -- Look for the 'TO' text.
        IF ( ISTORE(MF).GE.0 ) THEN
          MF=MF-LK2
          CALL XADE(ISTORE(MF+1))
          KLXBND = -1
          RETURN
        END IF
        IF ( KCOMP(1,ISTORE(MF+2),ICTO,1,1) .LE. 0 ) THEN
          MF=MF-LK2
          CALL XADE(ISTORE(MF+1))
          KLXBND = -1
          RETURN
        END IF
C -- Advance to the next thing on the CARD.
        ME = ME - 1
        MF = MF + LK2
        GO TO 1000
      END IF

C -- Input complete

      KLXBND = 1
      RETURN


      END



CODE FOR XBCALC
      SUBROUTINE XBCALC(INTERN)
C
C       ATOMS WHICH FORM ACCEPTABLE CONTACTS ARE STORED IN A STACK
C       WHICH HAS THE FOLLOWING FORMAT :
C
C       0  ADDRESS OF THE ATOM IN LIST 5
C       2  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CENTRE OF SYM
C       3  NON-PRIMITIVE LATTICE INDICATOR
C       4  T(X)
C       5  T(Y)
C       6  T(Z)
C       7  TRANSFORMED X
C       8  TRANSFORMED Y
C       9  TRANSFORMED Z
C      10  DISTANCE
C      11  DISTANCE SQUARED
C
C  INTERN = 0 -> #BONDCALC command issued (use procs)
C         = 1 -> internal call. Don't read commands, force update.
C         = 2 -> internal call. Don't load lists. Don't write out 41.
C
C--
      PARAMETER (NPROCS = 1)
      DIMENSION PROCS(NPROCS)
      DIMENSION IPROCS(NPROCS)
      DIMENSION TXYZ(6)
      DIMENSION ID(2), JDEV(4)
      LOGICAL WEXIST, MATC11, MATC22, MATC12, MATC21
      CHARACTER WCLINE*80, CFILEN*255, CATTYP*4


      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XWORK.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'ICOM12.INC'
      INCLUDE 'XLST20.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'ICOM40.INC'
      INCLUDE 'QLST40.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'ICOM41.INC'
      INCLUDE 'QLST41.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XDSTNC.INC'
      INCLUDE 'TSSCHR.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLIMIT.INC'

      EQUIVALENCE (PROCS(1), IPROCS(1))
#if defined (_HOL_)
      DATA    IUNKN /4HUNKN/
#else
      DATA    IUNKN /'UNKN'/
#endif
      INCLUDE 'IDIM40.INC'
      INCLUDE 'IDIM41.INC'


C--INITIALISE THE TIMING FUNCTION
      CALL XTIME1(1)

      IF ( INTERN .EQ. 0 ) THEN

C--READ THE DATA
        ISTAT = KRDDPV ( PROCS, NPROCS)
        IF ( ISTAT .LT. 0 ) GO TO 9910
        CALL XRSL
        CALL XCSAE

      ELSE

        IPROCS(1) = 1

      END IF

 
      IF ( INTERN .EQ. 2 ) THEN  ! Call from #EDIT, potentially messy.
C #EDIT reserves the right to add atoms on to the end of its L5, which
C is loaded so that the next potential atom belongs at NFL.
C This is my work aroudn:
         KBNFL = NFL
         NFL = NFL + 10*N5*MD5
      END IF

C--LOAD LISTS ONE, TWO, FIVE, TWENTY-NINE AND FORTY


      IF ( KEXIST(1) .LT. 1 ) GOTO 9900
      IF ( KEXIST(2) .LT. 1 ) GOTO 9900

      IF ( KEXIST(5) .LT. 1 ) GOTO 9900
      IF ( KEXIST(29) .LT. 1 ) GOTO 9900
      
      IF ( INTERN .NE. 2 ) THEN

        IF (KHUNTR ( 1,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL01
        IF (KHUNTR ( 2,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL02
        IF ( INTERN .NE. 2 ) THEN
          IF (KHUNTR ( 5,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL05
        END IF
        IF (KHUNTR (29,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL29
        IF ( IERFLG .LT. 0 ) GO TO 9900

        IF ( KEXIST(40) .GE. 1 ) THEN
C -- Load existing list forty:
          IF (KHUNTR (40,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL40
          IF ( IERFLG .LT. 0 ) GO TO 9900
        ELSE
C -- C R E A T E   A   N E W   ( N U L L )   L I S T   4 0:
          IDWZAP = 0
          CALL XFILL (IDWZAP, ICOM40, IDIM40)
          N40T = 1
          N40E = 0
          N40P = 0
          N40M = 0
          N40B = 0
          CALL XCELST ( 40, ICOM40, IDIM40 )
          CALL XWLSTD ( 40, ICOM40, IDIM40, 0, 1)
        ENDIF

        IF ( KEXIST(41) .GE. 1 ) THEN
C -- Load existing list forty-one (ready for overwriting):
          CALL XLDLST ( 41, ICOM41, IDIM41, -1 )
          IF ( IERFLG .LT. 0 ) GO TO 9900
        ELSE
C -- C R E A T E   A   N E W   L I S T   4 1:
          IDWZAP = 0
          CALL XFILL (IDWZAP, ICOM41, IDIM41)
          N41B = 0 !Bond list, no entries
          N41A = 0 !Atom list, no entries
          N41D = 1 !Dependencies, one record.
          CALL XCELST ( 41, ICOM41, IDIM41 )
        END IF
      END IF

C Remember a few pointers

      KBL29 = L29
      KBN29 = N29
cdjwoct08
c     dont look for bonds if less than 2 atoms
cdjwnov08 - fix causes=d looping if no list 41 exists
c      if (n5 .lt. 2) then
c            write (cmon,'(a,i4,a)') 'Only', n5, ' atoms'
c            call xprvdu(ncvdu,2,0)
c            if (issprt .eq. 0) write(ncwu, '(a)') cmon( 1)(:)
c            goto 3350
c      endif
c
      IF ( IPROCS(1) .EQ. 0 ) THEN
        IF ( K41DEP() .GE. 1 ) THEN
         WRITE(CMON,'(A/A)')'No need to recalculate bonds. Use ',
     1                    '#BONDCALC FORCE to force a calculation.'
         CALL XPRVDU(NCVDU,2,0)
         GOTO 3350
        ENDIF
      ENDIF


C -- The ELEMENT records (L40E) will override the covalent
C -- radii given in L29. The vdw parameter in L29 will be over-
C -- written with the MAXBONDS value - this L29 must not be
C -- written back to the DISK as it is now garbage.

      I29  = L29  + (N29-1) *MD29
      I40E = L40E + (N40E-1)*MD40E

C -- Overwrite vdw with maxbonds info
      DO M29= L29,I29,MD29
        STORE(M29+2) = STORE(L40T+2)
      END DO

      NOTFND=0
      NEWL29=NFL
      DO M40E=L40E,I40E,MD40E
         KFOUND = 0
         DO M29= L29,I29,MD29
           IF ( STORE(M40E) .EQ. STORE(M29) ) THEN
              KFOUND = 1
              STORE(M29+1) = STORE(M40E+1)
              STORE(M29+2) = STORE(M40E+2)
              EXIT
           END IF
         END DO
C If not it L29, check if we have found already.
         IF ( KFOUND .EQ. 0 ) THEN
           DO M29= NEWL29,NEWL29 + (NOTFND-1)*MD29,MD29
             IF ( STORE(M40E) .EQ. STORE(M29) ) THEN
                KFOUND = 1
                WRITE(CMON,'(2A)')
     1           'FYI: Element in L40 twice (using 1st): ',ISTORE(M40E)
                CALL XPRVDU(NCVDU,1,0)
                EXIT
             END IF
           END DO
         END IF
         IF ( KFOUND .EQ. 0 ) THEN
C -- Add this extra element in L29 style at NEWL29.
            NEWM29 = NEWL29 + NOTFND*MD29
            CALL XZEROF(STORE(NEWM29),MD29)
            CALL XMOVE (STORE(M40E),STORE(NEWM29),3)
            STORE(NEWM29+7)=IUNKN !Set colour unknown.
            NOTFND = NOTFND + 1
            WRITE(CMON,'(2A)')'FYI: Element in L40, but not in L29: ',
     1                        ISTORE(M40E)
            CALL XPRVDU(NCVDU,1,0)
         END IF
      END DO
      DO M5=L5,L5+(N5-1)*MD5,MD5
         KFOUND = 0
         DO M29= L29,I29,MD29
           IF ( ISTORE(M5) .EQ. ISTORE(M29) ) THEN
              KFOUND = 1
              EXIT
           END IF
         END DO
C If not in L29, check if we have found already.
         IF ( KFOUND .EQ. 0 ) THEN
           DO M29= NEWL29,NEWL29 + (NOTFND-1)*MD29,MD29
             IF ( STORE(M5) .EQ. STORE(M29) ) THEN
                KFOUND = 1
                EXIT
             END IF
           END DO
         END IF
         IF ( KFOUND .EQ. 0 ) THEN
C -- Element found in L5 that is missing from L29 and L40
C -- Add this extra element in L29 style at NEWL29.
            NEWM29 = NEWL29 + NOTFND*MD29
            CALL XZEROF(STORE(NEWM29),MD29)
            CALL XMOVE (STORE(M5),STORE(NEWM29),1)
            STORE(NEWM29+1) = 0.8
            STORE(NEWM29+2) = STORE(L40T+2)

C -- Have to get proper covalent radii from file if possible.
#if !defined(_GIL_) && !defined(_LIN_) && !defined(_MAC_)
            CFILEN = 'CRYSDIR:script\propwin.dat'
#else
            CFILEN = 'CRYSDIR:script/propwin.dat'
#endif
            CALL MTRNLG(CFILEN,'OLD',ILENG)
            INQUIRE(FILE=CFILEN(1:ILENG),EXIST=WEXIST)
            IF(WEXIST) THEN
              WRITE(CATTYP,'(A4)')ISTORE(M5)
              CALL XMOVEI(KEYFIL(1,2), JDEV, 4)
              CALL XRDOPN (6, JDEV, CFILEN(1:ILENG), ILENG)
              IF ( IERFLG .LT. 0) GOTO 9900
C Read the properties file and extract cov, vdw and colour.
              ICOL=IUNKN
              DO WHILE ( .TRUE. )
                 READ(NCARU,'(A80)',END=89) WCLINE
                 IF((WCLINE(1:3).NE.'CON').AND.
     1              (WCLINE(1:3).NE.'   ').AND.
     1              (WCLINE(1:4).EQ.CATTYP)) THEN
                    READ(WCLINE(13:16),'(F4.2)') COV
                    READ(WCLINE(62:65),'(A4)') ICOL
                    STORE(NEWM29+1) = COV
                    ISTORE(NEWM29+7) = ICOL
                    EXIT
                 END IF
              END DO
89            CONTINUE !End of file
              CALL XRDOPN (7, JDEV, CFILEN(1:ILENG), ILENG)
            END IF
            NOTFND = NOTFND + 1
            WRITE(CATTYP,'(A4)')ISTORE(M5)
            IF ( CATTYP(1:1).NE.'Q' ) THEN
              WRITE(CMON,'(3A)')'FYI: Element not in L40 or L29: ',
     1                        ISTORE(M5),ICOL
              CALL XPRVDU(NCVDU,1,0)
            END IF
         END IF
      END DO

      IF ( NOTFND .GT. 0 ) THEN
C -- There are extra elements in L40 that are not in L29 - this is
C -- perfectly acceptable, though refinement cannot proceed. We should
C -- print a warning. For now we need to extend L29 in order to fit
C -- in the information.
C -- NB we have already put stuff above NFL, this call allows for that:
         NEWL29 = KSTALL ( (N29+NOTFND)*MD29 )

         NEWM29 = NEWL29 + NOTFND*MD29
         CALL XMOVE(STORE(L29),STORE(NEWM29),N29*MD29)
         L29 = NEWL29
         N29 = N29 + NOTFND
         I29 = L29  + (N29-1) *MD29
      END IF

      JT = 12

      ITEMP1 = KSTALL(JT) !reserve a sort buffer.


C -- Allocate a N5 length vector to hold: { maxbonds, bondssofar }

      LATVEC = KSTALL( N5 * 2 ) 
      DO I5 = 0,N5-1
         M5 = L5 + I5*MD5
         DO M29 = L29,I29,MD29
            IF ( ISTORE(M29) .EQ. ISTORE(M5) ) EXIT
         END DO
         ISTORE(LATVEC+(I5*2))   = NINT(STORE(M29+2))
         ISTORE(LATVEC+(I5*2)+1) = 0
      ENDDO


C -- There are two parts of list 40 that must be used within the
C -- MAKE41 routine to determine bonding. Firstly, the DEFAULTS
C -- record (L40T) contains the tolerance algorithm type, and the
C -- tolerance. Secondly, the PAIR records (L40P) contain pairs of
C -- elements which will override the TOLERANCE calculation.

      NWN41B = 0
      NWL41B = 0


      DO I5 = 0,N5-1
         M5 = L5 + I5*MD5

         NEXTLC = NFL
         NFOUND = MAKE41( M5, NEXTLC )

         IF ( NFOUND .GT. 0 ) THEN

C Reject bonds to nonsym atoms that have reached their quota of bonds.
            NREJ = 0
            DO J = 0,(NFOUND-1)*JT,JT
               IF ( ( ISTORE(NFL+J+2) .EQ. 1 ) .AND.
     1              ( ISTORE(NFL+J+3) .EQ. 1 ) .AND.
     1              ( ISTORE(NFL+J+4) .EQ. 0 ) .AND.
     1              ( ISTORE(NFL+J+5) .EQ. 0 ) .AND.
     1              ( ISTORE(NFL+J+6) .EQ. 0 )) THEN
                    K = ISTORE(NFL+J)
                    IL5 = ( K - L5 ) / MD5
                    IF ( ISTORE(LATVEC+(IL5*2)+1) .GE.
     1                 ISTORE(LATVEC+(IL5*2)))  THEN
                      STORE(NFL+J+10) = 9999.0
                     NREJ = NREJ + 1
                    END IF
               END IF
            END DO
            
C Find the maximum number of bonds for this element.
            MAXBND = ISTORE(LATVEC+(I5*2))

C should this be:?
C           MAXBND = ISTORE(LATVEC+(I5*2)) - ISTORE(LATVEC+(I5*2)+1)

C Sort bonds on ETOL.
            IF ( NFOUND .GT. 1 )
     1              CALL XSHELQ(STORE(NFL),JT,11,NFOUND,
     1                               NFOUND*JT,STORE(ITEMP1))

C Throw out any that are rejected.
            NFOUND = NFOUND - NREJ
C Limit rest to best MAXBND bonds.

            NFOUND = MIN(NFOUND,MAXBND)

            DO J = 0,(NFOUND-1)*JT,JT
              K = ISTORE(NFL+J)
            END DO


C -- Add these bonds into L41 bond record. Currently descending from the top
C -- of store.
C -- Also add these bonds into the LATVEC vector.
            ISTORE(LATVEC+(I5*2)+1) = ISTORE(LATVEC+(I5*2)+1) + NFOUND
            DO J = 0,(NFOUND-1)*JT,JT
               K = ISTORE(NFL+J)
               IL5 = ( K - L5 ) / MD5
               NWL41B = KCHLFL(MD41B) !Increase storage for L41B records
               NWN41B = NWN41B + 1    !Increase number of records
               ISTORE(NWL41B   ) = (M5-L5)/MD5            !Ptr to first atom
               ISTORE(NWL41B+1 ) = 1
               ISTORE(NWL41B+2 ) = 1
               ISTORE(NWL41B+3 ) = 0
               ISTORE(NWL41B+4 ) = 0
               ISTORE(NWL41B+5 ) = 0
               ISTORE(NWL41B+6 ) = IL5                    !Ptr to 2nd
               CALL XMOVE( STORE(NFL+J+1), STORE(NWL41B+7), 5 )!Ptr to sym
               ISTORE(NWL41B+12) = ISTORE(NFL+J+11)       !Bond type
               STORE(NWL41B+13) = STORE(NFL+J+9)        !Bond length
               ISTORE(LATVEC+(IL5*2)+1) = ISTORE(LATVEC+(IL5*2)+1) + 1
            END DO
         END IF
      END DO

C -- Make any bonds in the MAKE list.

      DO M40M = L40M, L40M+(N40M-1)*MD40M, MD40M
C -- Find these atoms in L5.
        KAT1 = -1
        KAT2 = -1
        DO I5 = 0,N5-1
          M5 = L5 + I5*MD5
          IF (( ISTORE(M40M)   .EQ. ISTORE(M5  ) ) .AND.
     1        ( ISTORE(M40M+1) .EQ. NINT(STORE(M5+1)) ) ) THEN
             KAT1 = I5
             IF ( KAT2.GE.0 ) EXIT
          ENDIF
          IF (( ISTORE(M40M+7) .EQ. ISTORE(M5  ) ) .AND.
     1        ( ISTORE(M40M+8) .EQ. NINT(STORE(M5+1)) ) ) THEN
             KAT2 = I5
             IF ( KAT1.GE.0 ) EXIT
          ENDIF
        ENDDO
C If one of the atoms not found, we can't make this bond.
        IF ( (KAT1.LT.0) .OR. (KAT2.LT.0)) THEN
            WRITE(CMON,'(2(A,A4,I4))')
     1      'Cannot MAKE this bond (no such atom):',
     1      ISTORE(M40M),  ISTORE(M40M+1),' to ',
     2      ISTORE(M40M+7),ISTORE(M40M+8)
            CALL XPRVDU(NCVDU,1,0)
            CYCLE
        END IF

        LBEX = 0
C -- Search L41B records for this bond to see if already found.
        DO M41B = NWL41B, NWL41B+(NWN41B-1)*MD41B, MD41B

          MATC11 =  ( (ISTORE(M41B)   .EQ. KAT1) .AND.
     1                (ISTORE(M41B+6) .EQ. KAT2) )
          MATC12 =  ( (ISTORE(M41B)   .EQ. KAT2) .AND.
     1                (ISTORE(M41B+6) .EQ. KAT1) )

          MATC22 =  ( (ISTORE(M41B+1) .EQ. ISTORE(M40M+2)) .AND.
     3                (ISTORE(M41B+2) .EQ. ISTORE(M40M+3)) .AND.
     4                (ISTORE(M41B+3) .EQ. ISTORE(M40M+4)) .AND.
     5                (ISTORE(M41B+4) .EQ. ISTORE(M40M+5)) .AND.
     6                (ISTORE(M41B+5) .EQ. ISTORE(M40M+6)) .AND.
     7                (ISTORE(M41B+7) .EQ. ISTORE(M40M+9)) .AND.
     8                (ISTORE(M41B+8) .EQ. ISTORE(M40M+10)).AND.
     9                (ISTORE(M41B+9) .EQ. ISTORE(M40M+11)).AND.
     1                (ISTORE(M41B+10).EQ. ISTORE(M40M+12)).AND.
     2                (ISTORE(M41B+11).EQ. ISTORE(M40M+13))     )

          MATC21 =  ( (ISTORE(M41B+7) .EQ. ISTORE(M40M+2))
     1           .AND.(ISTORE(M41B+8) .EQ. ISTORE(M40M+3))
     2           .AND.(ISTORE(M41B+9) .EQ. ISTORE(M40M+4))
     3           .AND.(ISTORE(M41B+10).EQ. ISTORE(M40M+5))
     4           .AND.(ISTORE(M41B+11).EQ. ISTORE(M40M+6))
     5           .AND.(ISTORE(M41B+1) .EQ. ISTORE(M40M+9))
     6           .AND.(ISTORE(M41B+2) .EQ. ISTORE(M40M+10))
     7           .AND.(ISTORE(M41B+3) .EQ. ISTORE(M40M+11))
     8           .AND.(ISTORE(M41B+4) .EQ. ISTORE(M40M+12))
     9           .AND.(ISTORE(M41B+5) .EQ. ISTORE(M40M+13))  )

          IF ( ( MATC11 .AND. MATC22  ) .OR.
     1         ( MATC12 .AND. MATC21  ) ) THEN

C -- We have a match. No need to make this bond.
C -- But, set the type:

            ISTORE(M41B+12) = ISTORE(M40M+14)

c           WRITE(CMON,'(2(A,A4,I4))')
c     1     'No need to make    ',ISTORE(M40M  ),ISTORE(M40M+1),
c     1                   ' to ',ISTORE(M40M+7),ISTORE(M40M+8)
c           CALL XPRVDU(NCVDU, 1,0)

            LBEX = 1
            EXIT
          END IF
        ENDDO
        IF ( LBEX .EQ. 0 ) THEN

          WRITE(CMON,'(2(A,A4,I4))')
     1    'Making bond from   ',ISTORE(M40M  ),ISTORE(M40M+1),
     1                   ' to ',ISTORE(M40M+7),ISTORE(M40M+8)
C            CALL XPRVDU(NCVDU, 1,0)
             IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON( 1)(:)

C -- Add this bond into the L41. Still descending from the top of store.
          NWL41B = KCHLFL(MD41B) !Increase storage for L41B records
          NWN41B = NWN41B + 1    !Increase number of records
          ISTORE(NWL41B  ) = KAT1            !Ptr to first atom
          CALL XMOVE( STORE(M40M+2), STORE(NWL41B+1), 5 )!Ptr to sym
          ISTORE(NWL41B+6) = KAT2            !Ptr to 2nd
          CALL XMOVE( STORE(M40M+9), STORE(NWL41B+7), 5 )!Ptr to sym
          ISTORE(NWL41B+12) = ISTORE(M40M+14)       !Bond type
C --    Calculate bond length
C -- Apply symmetry to atom 1:
          M2 = L2 + ( MIN(N2,ABS(ISTORE(M40M+2))) - 1) * MD2
          M2P =L2P+ ( MIN(N2P,ISTORE(M40M+3))     - 1) * MD2P
C -- Transform     
          CALL XMLTTM(STORE(M2),STORE(4+L5+KAT1*MD5),TXYZ(1),3,3,1)
C -- Invert
          IF ( ISTORE(M40M+2) .LT. 0 ) CALL XNEGTR(TXYZ(1),TXYZ(1),3)
C -- Translate
          TXYZ(1) = TXYZ(1) +STORE(M2P  ) +STORE(M2+9 ) +ISTORE(M40M+4)
          TXYZ(2) = TXYZ(2) +STORE(M2P+1) +STORE(M2+10) +ISTORE(M40M+5)
          TXYZ(3) = TXYZ(3) +STORE(M2P+2) +STORE(M2+11) +ISTORE(M40M+6)
C -- Apply symmetry to atom 2:
          M2 =  L2 + (MIN(N2,ABS(ISTORE(M40M+9))) - 1) * MD2 
          M2P = L2P+ (MIN(N2P,ISTORE(M40M+10))    - 1) * MD2P
C -- Transform
          CALL XMLTTM(STORE(M2),STORE(4+L5+KAT2*MD5),TXYZ(4),3,3,1)
C -- Invert
          IF ( ISTORE(M40M+9) .LT. 0 ) CALL XNEGTR(TXYZ(4),TXYZ(4),3)
C -- Translate
          TXYZ(4) = TXYZ(4) +STORE(M2P  ) +STORE(M2+9 ) +ISTORE(M40M+11)
          TXYZ(5) = TXYZ(5) +STORE(M2P+1) +STORE(M2+10) +ISTORE(M40M+12)
          TXYZ(6) = TXYZ(6) +STORE(M2P+2) +STORE(M2+11) +ISTORE(M40M+13)
          F=XDSTNCR(TXYZ(1),TXYZ(4)) !Calculate distance
          STORE(NWL41B+13) = SQRT(F)       !Bond length
        END IF
      ENDDO

C -- Break any bonds in the BREAK list:

C -- Loop over the list of bonds to be broken:
      DO M40B = L40B, L40B+(N40B-1)*MD40B, MD40B
C -- Find these atoms in L5.
        KAT1 = -1
        KAT2 = -1
        DO I5 = 0,N5-1
          M5 = L5 + I5*MD5
          IF (( ISTORE(M40B)   .EQ. ISTORE(M5  ) ) .AND.
     1        ( ISTORE(M40B+1) .EQ. NINT(STORE(M5+1)) ) ) THEN
             KAT1 = I5
             IF ( KAT2.GE.0 ) EXIT
          ENDIF
          IF (( ISTORE(M40B+7) .EQ. ISTORE(M5  ) ) .AND.
     1        ( ISTORE(M40B+8) .EQ. NINT(STORE(M5+1)) ) ) THEN
             KAT2 = I5
             IF ( KAT1.GE.0 ) EXIT
          ENDIF
        ENDDO
C If one of the atoms not found, we can't break this bond.
        IF ( (KAT1.LT.0) .OR. (KAT2.LT.0)) THEN
           WRITE(CMON,'(2(A,A4,I4))')
     1      'Cannot BREAK this bond (no such atom):',
     1      ISTORE(M40B),  ISTORE(M40B+1),' to ',
     2      ISTORE(M40B+7),ISTORE(M40B+8)
           CALL XPRVDU(NCVDU,1,0)
           CYCLE
        END IF


C -- Find this atom in the NWL41B list:
        KN41B = 0
        KM41B = NWL41B
        DO M41B = NWL41B, NWL41B+(NWN41B-1)*MD41B, MD41B

          INFO51 = L5 + ISTORE(M41B) * MD5
          INFO52 = L5 + ISTORE(M41B+6) * MD5
          ICPDTD = 1

          MATC11 =  ( (ISTORE(M41B)   .EQ. KAT1) .AND.
     1                (ISTORE(M41B+6) .EQ. KAT2) )
          MATC12 =  ( (ISTORE(M41B)   .EQ. KAT2) .AND.
     1                (ISTORE(M41B+6) .EQ. KAT1) )

          MATC22 =  ( (ISTORE(M41B+1) .EQ. ISTORE(M40B+2)) .AND.
     3                (ISTORE(M41B+2) .EQ. ISTORE(M40B+3)) .AND.
     4                (ISTORE(M41B+3) .EQ. ISTORE(M40B+4)) .AND.
     5                (ISTORE(M41B+4) .EQ. ISTORE(M40B+5)) .AND.
     6                (ISTORE(M41B+5) .EQ. ISTORE(M40B+6)) .AND.
     7                (ISTORE(M41B+7) .EQ. ISTORE(M40B+9)) .AND.
     8                (ISTORE(M41B+8) .EQ. ISTORE(M40B+10)).AND.
     9                (ISTORE(M41B+9) .EQ. ISTORE(M40B+11)).AND.
     1                (ISTORE(M41B+10).EQ. ISTORE(M40B+12)).AND.
     2                (ISTORE(M41B+11).EQ. ISTORE(M40B+13))     )

          MATC21 =  ( (ISTORE(M41B+7) .EQ. ISTORE(M40B+2))
     1           .AND.(ISTORE(M41B+8) .EQ. ISTORE(M40B+3))
     2           .AND.(ISTORE(M41B+9) .EQ. ISTORE(M40B+4))
     3           .AND.(ISTORE(M41B+10).EQ. ISTORE(M40B+5))
     4           .AND.(ISTORE(M41B+11).EQ. ISTORE(M40B+6))
     5           .AND.(ISTORE(M41B+1) .EQ. ISTORE(M40B+9))
     6           .AND.(ISTORE(M41B+2) .EQ. ISTORE(M40B+10))
     7           .AND.(ISTORE(M41B+3) .EQ. ISTORE(M40B+11))
     8           .AND.(ISTORE(M41B+4) .EQ. ISTORE(M40B+12))
     9           .AND.(ISTORE(M41B+5) .EQ. ISTORE(M40B+13))  )

          IF ( ( MATC11 .AND. ( MATC22 .OR. ISTORE(M40B+2).EQ.0) ) .OR.
     1         ( MATC12 .AND. ( MATC21 .OR. ISTORE(M40B+9).EQ.0) ) )THEN

C -- We have a match. Need to break this bond.
C -- Copy data down.
            WRITE(CMON,'(2(A,A4,I4))')
     1    'Breaking bond from ',ISTORE(INFO51),NINT(STORE(INFO51+1)),
     1               ' to ',ISTORE(INFO52),NINT(STORE(INFO52+1))
C            CALL XPRVDU(NCVDU, 1,0)
             IF ((ISSPRT .EQ. 0) .AND. (LEVEL.EQ.3))
     1       WRITE(NCWU, '(A)') CMON( 1)(:)
            IF ( KM41B .NE. M41B ) THEN
               CALL XMOVE(STORE(M41B),STORE(KM41B),MD41B)
            END IF
C -- Keep K pointers same. Data will be overwritten next time.
            ICPDTD = 0
          END IF

          IF ( ICPDTD .EQ. 1 ) THEN
C -- Copy data down.
            IF ( KM41B .NE. M41B ) THEN
               CALL XMOVE(STORE(M41B),STORE(KM41B),MD41B)
            END IF
C -- Increment K pointers.
            KN41B = KN41B + 1
            KM41B = KM41B + MD41B
          ENDIF
        END DO

C -- Possibly shorten L41B.
        NWN41B = KN41B
      END DO

      L41B = NWL41B

C TODO -- Include L41A list of atoms, CRC and so on.

      ISTAT = KHUNTR(41,101,IADDL,IADDR,IADDD,-1)
      IF ( ISTAT.NE.0 ) GOTO 9900
      ISTORE(IADDR+3) = NWL41B        ! Change header pointer to new data
      N41B = NWN41B


      ISTAT = KHUNTR(41,102,IADDL,IADDR,IADDD,-1)
      IF ( ISTAT.NE.0 ) GOTO 9900

      N41A = N5
      L41A = KSTALL( N5 * MD41A )
      DO I = 0,N5-1
         M5 = L5 + 4 + I*MD5
         M41A = L41A + I*MD41A
         CALL XMOVE(STORE(M5),STORE(M41A),MD41A)
      END DO

      ISTORE(IADDR+3) = L41A        ! Change header pointer to new data

      CALL XRLIND( 5,ILSERI, NFW, LL, IOW,IL05SR, ID)
      CALL XRLIND(40,IL40SR, NFW, LL, IOW, NOS, ID)

      ISTORE(L41D)   = N5
      ISTORE(L41D+1) = KL5CRC()
      ISTORE(L41D+2) = IL05SR
      ISTORE(L41D+3) = IL40SR

C -- Work out bond types:

      IF ( ISSBND .NE. 0 ) THEN
        CALL BONDTY(1)
      ELSE                      ! Remove special bonds (set by BONDTY).
        N41S = 0
        ISTAT = KHUNTR(41,104,IADDL,IADDR,IADDD,-1)
        IF ( ISTAT.NE.0 ) GOTO 9900
        ISTORE(IADDR+3) = L41S   ! Change header pointer to data
      END IF

C -- Write new list back to disk, unless INTERN == 2, in which case
C -- the list can be used as is.

      IF ( INTERN .NE. 2 ) THEN
        CALL XWLSTD (41,ICOM41,IDIM41,-1,-1)
      END IF


3350  CONTINUE

      IF ( INTERN .EQ. 2 ) THEN  ! Call from #EDIT, potentially messy.
C This is my work around:
         NFL = KBNFL
cdjwoct08  Only restore L29 pointers for external calls
cdjwfeb09  restore RICs code
c      else
      endif
C Restore those old pointers
       L29 = KBL29
       N29 = KBN29
c      END IF

      CALL XOPMSG (IOPBND, IOPEND, 201)
      CALL XTIME2(1)
      RETURN
C
9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPBND , IOPABN , 0 )
      GOTO 3350
9910  CONTINUE
C -- INPUT ERROR
      CALL XOPMSG ( IOPBND , IOPCMI , 0 )
      GO TO 9900
9920  CONTINUE
C -- SINGULAR MATRIX
      WRITE ( CMON, 9925 )
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON( 1)(:)
9925  FORMAT ( 1X , 'Rotation matrix is singular' )
      CALL XERHND ( IERERR )
      GO TO 9900
9930  CONTINUE
C
C-------INSUFFICIENT SPACE
      CALL XOPMSG ( IOPHYD , IOPSPC , 0 )
      GO TO 9900
      END



CODE FOR MAKE41
      FUNCTION MAKE41( MPIV, MSADR )
C
C   MSADR  ADDRESS IN STORE TO PUT RESULTS
C   MPIV    ADDRESS OF THE CURRENT PIVOT ATOM IN LIST 5
C
C--THE RETURN VALUES OF 'MAKE41' ARE :
C   0  NO SUITABLE CONTACTS HAVE BEEN FOUND.
C  >0  THE NUMBER OF ENTRIES IN THE DISTANCES STACK.
C
C--THE FOLLOWING VARIABLES MAY BE ADJUSTED
C  AP     MAXIMUM ALLOWED DISTANCES SQUARED OVERALL
C  BP     MINIMUM ALLOWED DISTANCE SQUARED OVERALL
C
C--ATOMS WHICH FORM ACCEPTABLE CONTACTS ARE STORED IN A STACK
C  WHICH HAS THE FOLLOWING FORMAT :
C   0  ADDRESS OF THE ATOM IN LIST 5
C   1  S, THE SYMMETRY MATRIX TO BE USED (NEGATIVE FOR CENTRE OF SYM.)
C   2  NON-PRIMITIVE LATTICE INDICATOR
C   3  T(X)
C   4  T(Y)
C   5  T(Z)
C   6  TRANSFORMED X
C   7  TRANSFORMED Y
C   8  TRANSFORMED Z
C   9  DISTANCE
C  10  TOLERANCE ( absolute distance from ideal cov+cov bond length )
C  11  BONDTYPE ( if a PAIR record is given, otherwise 0 )
C
C--THE COMMON BLOCK /XAPD/ IS USED AS :
C  APD(1-3)  SYMMETRY RELATED X, Y AND Z, WITH TRANSLATION PART OMITTED.
C  APD(4-6)  INITIAL SYMMETRY RELATED X, Y AND Z.
C  APD(7-9)  FINAL SYMMETRY RELATED X, Y AND Z AFTER A SUCCESSFUL FIND.
C
C--
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XPDS.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'

      COMMON /PERM02/ RLIST2(1000),ICFLAG,LSYM,NSYM,MDSYM,LNONP,NNONP
      EQUIVALENCE (STORE(1),ISTORE(1))

      CALL CRDIST2     !Set up BPD.
      JT= 12           !Size of atom info on stack
      AO = 3.0
      DO M40P = L40P, L40P + (N40P-1)*MD40P, MD40P
          AO = MAX(AO, STORE(M40P+3))
      END DO
      AP = AO * AO     !Max dist squared
      BP = 0.5 * 0.5   !Min dist squared





C--SET UP A FEW INITIAL POINTERS
      MAKE41=0         !Return value. Number of atoms found
      I5A=MPIV
C--SET UP THE MAXIMUM AND MINIMUM VALUES FOR EACH DIRECTION FOR A DISTAN
      DO J=1,3
        BPD(J+3)=STORE(I5A+4)-AO/BPD(J)
        BPD(J+6)=STORE(I5A+4)+AO/BPD(J)
        I5A=I5A+1
      END DO

      DAT1 = 0.0
      DO M29 = L29, L29+(N29-1)*MD29, MD29
        IF ( ISTORE(MPIV) .EQ. ISTORE(M29) ) THEN
          DAT1 = STORE(M29+1)
          EXIT
        END IF
      END DO

      CALL PRTGRP(ISTORE(MPIV+14), MPIVPR, MPIVGR, 1)

C--LOOP OVER ALL THE ATOMS.
      DO I5= L5,L5+(MD5*(N5-1)),MD5

        KPAIR = 0
        DAT2 = 0.0
C--Check for this atom pair on a L40 PAIR record.
        DO M40P = L40P, L40P + (N40P-1)*MD40P, MD40P
          IF (((STORE(M40P).EQ.STORE(I5))
     1    .AND.(STORE(M40P+1).EQ.STORE(MPIV)))
     2    .OR.((STORE(M40P)  .EQ.STORE(MPIV))
     3    .AND.(STORE(M40P+1).EQ.STORE(I5)))) THEN
            KPAIR = 1
            EXIT
          END IF
        END DO
        DO M29 = L29, L29+(N29-1)*MD29, MD29
          IF ( ISTORE(I5) .EQ. ISTORE(M29) ) THEN
            DAT2 = STORE(M29+1)
            EXIT
          END IF
        END DO


C-- CHECK PART NUMBERS
        NPTSYM = 0
        CALL PRTGRP(ISTORE(I5+14), MBONPR, MBONGR, 1)
C 1) Allow bond if one atom is group 0, part 0.
        IF (( MPIVPR .EQ. 0 .AND. MPIVGR .EQ. 0 ) .OR.
     1         ( MBONPR .EQ. 0 .AND. MBONGR .EQ. 0 ) ) GOTO 1110

C 2) Don't bond things in same 'group' if 'part' numbers differ.
C 2) Don't bond things in same 'group' if 'part' numbers are non-zero
C    and different.
           IF (( MPIVGR.EQ.MBONGR ).AND.( MPIVPR.NE.MBONPR ) .AND.
     1         ( MPIVPR.NE.0)      .AND.( MBONPR.NE.0      ) ) CYCLE

C 3) Don't bond things if 'group' numbers non-zero and different
C    and one of the 'parts' is 0.
        IF (( MPIVGR.NE.MBONGR ) .AND. ( MIN(MPIVGR,MBONGR).NE.0 )
     1     .AND. ((MPIVPR.EQ.0).OR.(MBONPR.EQ.0)) ) CYCLE

C 4) Later, don't bond to same prt&grp across symops if part number is -ve.
        IF (( MPIVGR.EQ.MBONGR ) .AND. ( MPIVPR.EQ.MBONPR ) .AND.
     1         ( MPIVPR .LT. 0 )) THEN
                 NPTSYM = -1   ! Don't apply sym ops
        END IF

1110    CONTINUE

C--If the NOSYMM flag is set, hide all the symmetry operators:
        IF (( ISTORE(L40T+3).EQ.1 ).OR.( NPTSYM .LT. 0 )) THEN
            NKSYM = 1
            NKICF = 0
            NKNON = 1
        ELSE
            NKSYM = NSYM
            NKICF = ICFLAG
            NKNON = NNONP
        END IF


C--LOOP OVER EACH SYMMETRY OPERATOR COMBINATION FOR THIS ATOM
        M2=LSYM
        DO NE=1,NKSYM
C--APPLY THIS SYMMETRY OPERATOR
          CALL XMLTTM(RLIST2(M2),STORE(I5+4),APD(1),3,3,1)
C--LOOP OVER EACH REQUIRED SIGN FOR THE CENTRE OF SYMMETRY FLAG
          DO NF=1,2*NKICF+1,2
C--LOOP OVER EACH OF THE NON-PRIMITIVE LATTICE TRANSLATIONS
            M2P=LNONP
            DO NG=1,NKNON
C--ADD IN THE VARIOUS TRANSLATION PARTS
              NH=M2
              DO NI=1,3
                APD(NI+3)=APD(NI)+RLIST2(M2P)+RLIST2(NH+9)
                APD(NI+6)=APD(NI+3)
                M2P=M2P+1
                NH=NH+1
              END DO

              CALL XSHIFT2(1) ! Move X-coord out of required volume.
              DO WHILE ( KDIST2(1).GE.0 ) !Advance X-coord.

                CALL XSHIFT2(2) ! Move Y-coord out of required volume.
                DO WHILE ( KDIST2(2).GE.0 )  ! Advance Y-coord.

                  CALL XSHIFT2(3) ! Move Z-coord out of required volume.
                  DO WHILE ( KDIST2(3).GE.0 )  !Advance Z-coord.
C--A SUCCESSFUL FIND.

                    IF((I5-MPIV.NE.0)
     1                  .OR. (ABS(STORE(MPIV+4)-APD(7)).GT.ZERO)
     2                   .OR. (ABS(STORE(MPIV+5)-APD(8)).GT.ZERO)
     3                    .OR. (ABS(STORE(MPIV+6)-APD(9)).GT.ZERO) )THEN


C--THIS IS NOT A SELF-SELF CONTACT WITH NO OPERATORS. 
C--We want A->B and not B->A, however we want both A->B' and B->A'.
                      IF ((MPIV.GT.I5).OR.(NE.NE.1).OR.(NF.NE.1)
     1                 .OR.(NG.NE.1)
     2                 .OR.(NINT(APD(7)-APD(4)).NE.0)
     3                 .OR.(NINT(APD(8)-APD(5)).NE.0)
     4                 .OR.(NINT(APD(9)-APD(6)).NE.0) ) THEN

C Check that this atom has not just been duplicated by symmetry
C because it is on a special position.

c      WRITE(CMON,'(3I4,2I4/6F10.4)')
c     1 NINT(APD(7)-APD(4)),NINT(APD(8)-APD(5)),NINT(APD(9)-APD(6)),
c     2 NF, NG,
c     3 APD(7),STORE(I5+4),APD(8),STORE(I5+5),APD(9),STORE(I5+6)
c      CALL XPRVDU(NCVDU,3,0)


                       IF ( ( ( NINT(APD(7)-APD(4)) .EQ. 0 ) .AND.
     1                        ( NINT(APD(8)-APD(5)) .EQ. 0 ) .AND.
     2                        ( NINT(APD(9)-APD(6)) .EQ. 0 ) .AND.
     2                        ( NE .EQ. 1 ) .AND. 
     3                        ( NF .EQ. 1 )  .AND. ( NG. EQ. 1 ) ) .OR.
     4                      ( (ABS(APD(7)-STORE(I5+4)).GT.ZERO) .OR.
     5                        (ABS(APD(8)-STORE(I5+5)).GT.ZERO) .OR.
     6                        (ABS(APD(9)-STORE(I5+6)).GT.ZERO) ) ) THEN

                        F=XDSTNCR(STORE(MPIV+4),APD(7)) !Calculate distance
                        DPMIN = 0.0
                        DPMAX = 0.0
                        LPAIR = 0
C -- There may be more than one PAIR record for a given pair of elements.
C -- (they have different bond types). So search L40P again for a matching
C -- pair AND range.
                        IF(KPAIR.EQ.1) THEN
                          DO M40P = L40P, L40P + (N40P-1)*MD40P, MD40P
                            IF (((STORE(M40P).EQ.STORE(I5))
     1                      .AND.(STORE(M40P+1).EQ.STORE(MPIV)))
     2                      .OR.((STORE(M40P)  .EQ.STORE(MPIV))
     3                      .AND.(STORE(M40P+1).EQ.STORE(I5)))) THEN
                              IF (( F .GE. STORE(M40P+2)**2 ) .AND.
     1                            ( F .LE. STORE(M40P+3)**2 )) THEN
                                DPMIN = STORE(M40P+2)
                                DPMAX = STORE(M40P+3)
                                LPAIR = NINT(STORE(M40P+4))
                                EXIT
                              END IF
                            END IF
                          END DO
                          DMIN = DPMIN**2
                          DMAX = DPMAX**2
                        ELSE IF ( NINT(STORE(L40T)) .EQ. 0 ) THEN
                          DMAX = (DAT1+DAT2+STORE(L40T+1))**2
                          DMIN = (MAX(0.0,DAT1+DAT2-STORE(L40T+1)))**2
                        ELSE
                          DMAX = ((DAT1 + DAT2)*STORE(L40T+1))**2
                          DMIN = ((DAT1 + DAT2)/2.0)**2
                        ENDIF

                        IF((F .GE. DMIN).AND.(F .LE. DMAX)) THEN
                          E=SQRT(F) ! Compute distance.
                          ISTORE(MSADR)=I5           !0 = Pointer to atom
                          ISTORE(MSADR+1) = (2-NF)*NE
                          ISTORE(MSADR+2) = NG
                          DO I = 1,3
                            ISTORE(MSADR+I+2) = NINT(APD(I+6)-APD(I+3))
                            STORE (MSADR+I+5) = APD(I+6)
                          END DO
                          STORE(MSADR+9) = E
                          IF (KPAIR.EQ.1) THEN
                            ETOL = ABS( E - ((DPMIN+DPMAX)/2.0))
                          ELSE
                            ETOL = ABS( E - (DAT1 + DAT2) )
                          END IF
                          STORE(MSADR+10) = ETOL
                          ISTORE(MSADR+11) = LPAIR
                          MAKE41=MAKE41+1                   !Atom Counter.
                          MSADR=MSADR+JT
                          IF (MSADR.GT.LFL) THEN
                              MSADR=MSADR-JT
                              MAKE41=MAKE41-1
                          END IF
                        END IF
                       END IF
                      END IF
                    END IF
                  END DO
                END DO
              END DO
            END DO
            CALL XNEGTR(APD(1),APD(1),3)        !Centre of symmetry.
          END DO
          M2=M2+MDSYM
        END DO
      END DO
      RETURN
      END


CODE FOR K41DEP
      FUNCTION K41DEP()
C -- Checks whether list 41 needs updating.

      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST40.INC'
      INCLUDE 'XLST41.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
      DIMENSION ID(2)

      K41DEP = -1        !Return negative value for "need update".

C-- If there is no L41, we need to update.
      IF ( KEXIST(41) .LE. 0 ) THEN
         WRITE(NCWU,'(a)')'Bonds: Update required - There is no list 41'
         RETURN
      ENDIF

      IF (KHUNTR (41,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL41

      IF (KHUNTR ( 5,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL05
      CALL XRLIND( 5,ILSERI, NFW, LL, IOW,IL05SR, ID)

      IF (KHUNTR (40,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL40
      CALL XRLIND(40,IL40SR, NFW, LL, IOW, NOS, ID)


C-- If the number of atoms in L5 has changed, we need to update.

      IF ( N5 .NE. ISTORE(L41D) ) THEN
         WRITE(NCWU,'(a)')'Bonds: Update required - List5 length change'
         RETURN
      ENDIF

C-- If the serial of L40 has changed, we need to update.

      IF ( IL40SR .NE. ISTORE(L41D+3) ) THEN
         WRITE(NCWU,'(a)')'Bonds: Update required - List 40 has changed'
         RETURN
      ENDIF

C-- If the original serial of List 5 has changed, we need to update.

      IF ( IL05SR .NE. ISTORE(L41D+2) ) THEN
         RETURN
      ENDIF

C -- Calculate a 16-bit CRC for List 5:

      L5CRC = KL5CRC()

C -- See if the CRC has changed.

      IF ( L5CRC .NE. ISTORE(L41D+1) ) THEN
         WRITE(NCWU,'(a)')
     + 'Bonds: Update required - List 5 checksum changed'
         RETURN
      ENDIF


C -- No change to anything obvious - we will now compare the XYZ's
C -- to look for a 'significant' change in co-ordinates.

      IF ( N41A .NE. N5 ) RETURN

      DO I = 0,N41A-1
         M5 = L5 + I*MD5
         M41A = L41A + I*MD41A
         F=XDSTNCR(STORE(M5+4),STORE(M41A)) !Calculate distance

C Significant Shift ( F is dist squared ):
         IF ( F .GT. STORE(L40T+4)**2 ) THEN
cfeb08           IF (ISSPRT .EQ. 0) THEN
cfeb08             WRITE(NCWU,'(a,a,I4,2F15.8)')
cfeb08     + 'Bonds: Update required - Significant change in L5',
cfeb08     + 'Atom#, tol^2, F^2 = ',I+1,STORE(L40T+4)**2,F
cfeb08           endif
           RETURN
         ENDIF
         
      END DO

C -- Nothing significant changed. No need to update.

      K41DEP = 1
      RETURN
      END


CODE FOR KL5CRC
      FUNCTION KL5CRC()
C - Returns a CRC checksum for the TYPE, SERIAL and PART# of all L5 atoms.
      INCLUDE 'XLST05.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
      IF (KHUNTR ( 5,0,IADDL,IADDR,IADDD,-1) .LT. 0) CALL XFAL05
      L5VEC = NFL
      DO I = 0,N5-1
        M5 = L5 + I*MD5
        ISTORE(L5VEC+I*3)   = ISTORE(M5)
        ISTORE(L5VEC+I*3+1) = ISTORE(M5+1)
        ISTORE(L5VEC+I*3+2) = ISTORE(M5+14)
      END DO
      KL5CRC = KCRCHK( L5VEC, N5*3 )
      RETURN
      END
CODE FOR DIS11
      SUBROUTINE DIS11(khy, ihy, catom1, cbonda, uequiv, dist)
c----- set c-h distance to dist
      INCLUDE 'XUNITS.INC'
      character*132 cline
      CHARACTER catom1*(*), cbonda(4)*(*)
      parameter (nbonda=12)
      dimension ihy(nbonda), lbonda(nbonda),iparth(nbonda)
c
      write(cline,'(a,f5.2,a )') 'dist ', dist, ', 0.02 = '
      call xcrems( cline, cline, nch)
      write(ncpu,'(a)') cline(1:nch)
      do j=1,khy
       if (ihy(j) .eq. 1) then        
        write(cline,'(a,a,a,a,a )') 
     1  'cont ', catom1, ' to ', cbonda(j)
        call xcrems( cline, cline, nch)
        write(ncpu,'(a)') cline(1:nch)
       endif
      enddo
c
c----- Set vibration restraint
c
      do j=1,khy
       if (ihy(j) .eq. 1) then        
        write(cline,'(a,f6.3,a, a )')
     1 'REST ', UEQUIV, ', 0.002 = ', cbonda(j)
        call xcrems( cline, cline, nch)
        cline(nch-1:) = ',u[iso])'
        nch = nch + 7
        write(ncpu,'(a)') cline(1:nch)
       endif
      enddo

c
      RETURN
      END
c
CODE FOR ANG180
      SUBROUTINE ANG180(KHY, IHY, CATOM1, CBONDA)
c----- set h-c-c angle to 180.0
c
      INCLUDE 'XUNITS.INC'
      CHARACTER*132 CLINE
      CHARACTER catom1*(*), cbonda(4)*(*)
      PARAMETER (NBONDA=12)
      DIMENSION IHY(NBONDA), LBONDA(NBONDA),IPARTH(NBONDA)
C
      DO J=1,KHY
       IF (IHY(J) .EQ. 1) THEN
        I = J
       ELSE IF (IHY(J) .EQ. 2) THEN
        K = J
       ENDIF
      ENDDO
        WRITE(CLINE,'(A,A,A,A,A,A )') 
     1  'ANGLE 180., 2.0 = ', CBONDA(I), ' TO ', CATOM1, ' TO ', 
     2  CBONDA(K)
        CALL XCREMS( CLINE, CLINE, NCH)
        WRITE(NCPU,'(A)') CLINE(1:NCH)
      RETURN
      END
c
CODE FOR hccav
      SUBROUTINE HCCAV(KHY, IHY, CATOM1, CBONDA)
c----- set h-c-c angle to mean of group
c
      INCLUDE 'XUNITS.INC'
      CHARACTER*132 CLINE
      CHARACTER catom1*(*), cbonda(4)*(*)
      PARAMETER (NBONDA=12)
      DIMENSION IHY(NBONDA), LBONDA(NBONDA),IPARTH(NBONDA)
C
      WRITE(CLINE,'(A )') 'ANGLE 0.0, 2.0 = MEAN'
      CALL XCREMS( CLINE, CLINE, NCH)
      WRITE(NCPU,'(A)') CLINE(1:NCH)

      DO I=1,KHY
       IF (IHY(I) .EQ. 1) THEN
        DO J=1,KHY
         IF (IHY(J) .EQ. 2) THEN
          WRITE(CLINE,'(A,A,A,A,A,A )') 'CONT ',
     1    CBONDA(I), ' TO ', CATOM1, ' TO ', 
     2    CBONDA(J)
          CALL XCREMS( CLINE, CLINE, NCH)
          WRITE(NCPU,'(A)') CLINE(1:NCH)
         ENDIF
        ENDDO
       ENDIF
      ENDDO
      RETURN
      END
c
c
CODE FOR cchav
      SUBROUTINE CCHAV(KHY, IHY, CATOM1, CBONDA)
c----- set c-c-h angle to mean of group of several h's
c
      INCLUDE 'XUNITS.INC'
      CHARACTER*132 CLINE
      CHARACTER catom1*(*), cbonda(4)*(*)
      PARAMETER (NBONDA=12)
      DIMENSION IHY(NBONDA), LBONDA(NBONDA),IPARTH(NBONDA)
C
      WRITE(CLINE,'(A )') 'ANGLE 0.0, 2.0 = MEAN'
      CALL XCREMS( CLINE, CLINE, NCH)
      WRITE(NCPU,'(A)') CLINE(1:NCH)

      DO I=1,KHY
       IF (IHY(I) .EQ. 2) THEN
        DO J=1,KHY
         IF (IHY(J) .EQ. 1) THEN
          WRITE(CLINE,'(A,A,A,A,A,A )') 'CONT ',
     1    CBONDA(I), ' TO ', CATOM1, ' TO ', 
     2    CBONDA(J)
          CALL XCREMS( CLINE, CLINE, NCH)
          WRITE(NCPU,'(A)') CLINE(1:NCH)
         ENDIF
        ENDDO
       ENDIF
      ENDDO
      RETURN
      END
c
CODE FOR hcc109
      SUBROUTINE hcc109(khy, ihy, catom1, cbonda)
c--- set h-c-c angle to 109.54
c
      INCLUDE 'XUNITS.INC'
      character*132 cline
      CHARACTER catom1*(*), cbonda(4)*(*)
      parameter (nbonda=12)
      dimension ihy(nbonda), lbonda(nbonda),iparth(nbonda)
c
      write(cline,'(a )') 'angle 109.54, 2.0 = '
      call xcrems( cline, cline, nch)
      write(ncpu,'(a)') cline(1:nch)

      do i=1,khy
       if (ihy(i) .eq. 2) then
        do j=1,khy
         if (ihy(j) .eq. 1) then
          write(cline,'(a,a,a,a,a,a )') 'cont ',
     1    cbonda(i), ' to ', catom1, ' to ', 
     2    cbonda(j)
          call xcrems( cline, cline, nch)
          write(ncpu,'(a)') cline(1:nch)
         endif
        enddo
       endif
      enddo
      RETURN
      END
CODE FOR hcc120
      SUBROUTINE hcc120(khy, ihy, catom1, cbonda)
c--- set h-c-c angle to 120
c
      INCLUDE 'XUNITS.INC'
      character*132 cline
      CHARACTER catom1*(*), cbonda(4)*(*)
      parameter (nbonda=12)
      dimension ihy(nbonda), lbonda(nbonda),iparth(nbonda)
c
      write(cline,'(a )') 'angle 120.0, 2.0 = '
      call xcrems( cline, cline, nch)
      write(ncpu,'(a)') cline(1:nch)

      do i=1,khy
       if (ihy(i) .eq. 2) then
        do j=1,khy
         if (ihy(j) .eq. 1) then
          write(cline,'(a,a,a,a,a,a )') 'cont ',
     1    cbonda(i), ' to ', catom1, ' to ', 
     2    cbonda(j)
          call xcrems( cline, cline, nch)
          write(ncpu,'(a)') cline(1:nch)
         endif
        enddo
       endif
      enddo
      RETURN
      END
c
CODE FOR hch109
      SUBROUTINE hch109(khy, ihy, catom1, cbonda, iparth)
      INCLUDE 'XUNITS.INC'
      character*132 cline
      CHARACTER catom1*(*), cbonda(4)*(*)
      parameter (nbonda=12)
      dimension ihy(nbonda), lbonda(nbonda),iparth(nbonda)
c
      write(cline,'(a )') 'angle 109.54, 2.0 = '
      call xcrems( cline, cline, nch)
      write(ncpu,'(a)') cline(1:nch)
c
c---- type flag negated once used, but reset before exit
c
      do i=1,khy
       if (ihy(i) .eq. 1) then
        ihy(i) =-ihy(i)
        do j=i+1,khy
         if (ihy(j) .eq. 1) then
          if(iparth(i).eq.iparth(j)) then
c           ihy(j)=-ihy(j)
           write(cline,'(a,a,a,a,a,a )') 'cont ',
     1     cbonda(i), ' to ', catom1, ' to ', 
     2     cbonda(j)
           call xcrems( cline, cline, nch)
           write(ncpu,'(a)') cline(1:nch)
          endif
         endif
        enddo
       endif
      enddo
c----- reset flags
      do i=1,khy
       ihy(i)=abs(ihy(i))
      enddo
      RETURN
      END
c
CODE FOR hchav
      SUBROUTINE hchav(khy, ihy, catom1, cbonda, iparth)
      INCLUDE 'XUNITS.INC'
      character*132 cline
      CHARACTER catom1*(*), cbonda(4)*(*)
      parameter (nbonda=12)
      dimension ihy(nbonda), lbonda(nbonda),iparth(nbonda)
c
      write(cline,'(a )') 'angle 0.0, 2.0 = mean '
      call xcrems( cline, cline, nch)
c
c---- type flag negated once used, but reset before exit
c
      do i=1,khy
       if (ihy(i) .eq. 1) then
        ihy(i) =-ihy(i)
        do j=i+1,khy
         if (ihy(j) .eq. 1) then
          if(iparth(i).eq.iparth(j)) then
c           ihy(j)=-ihy(j)
           write(cline(nch+1:),'(a,a,a,a,a,a )') 
     1     cbonda(i), ' to ', catom1, ' to ', 
     2     cbonda(j)
           call xcrems( cline, cline, nch)
           write(ncpu,'(a)') cline(1:nch)
           write(cline,'(a )') 'cont '
           call xcrems( cline, cline, nch)
          endif
         endif
        enddo
       endif
      enddo
c----- reset flags
      do i=1,khy
       ihy(i)=abs(ihy(i))
      enddo
      RETURN
      END
c
CODE FOR PLANH
      SUBROUTINE PLANH(khy, ihy, catom1, cbonda)
      INCLUDE 'XUNITS.INC'
      character*240 cline
      CHARACTER catom1*(*), cbonda(4)*(*)
      parameter (nbonda=12)
      dimension ihy(nbonda), lbonda(nbonda),iparth(nbonda)
c
        write(cline,'(a,a,a,a,a,a )') 
     1  'planar ',  catom1,  (cbonda(j),j=1,khy)
        call xcrems( cline, cline, nch)
        write(ncpu,'(a)') cline(1:nch)
      RETURN
      END
c

CODE FOR PRTGTP
      SUBROUTINE PRTGRP( IPACKD, IPART, IGROUP, ITYPE)
C
C CAUTION. To the user, PART = 1000*ASSEMBLY + GROUP
C
C
C ITYPE
C      0 or 1 use PARTS value
C      2      use the RESIDUE value, 
C Set IPART to the last 3 digits of IPACKD, signed.
C Set IGROUP to the rest, positive.
C
C E.g. -123456 -> IPART = -456, IGROUP = 123
c
      if (itype .le. 1) then
       IPART = MOD(IPACKD,1000)
       IGROUP = ABS(IPACKD - IPART) / 1000
      else ! looking at RESIDUES 
       ipart=ipackd
       igroup=ipackd
      endif
      RETURN
      END
CODE FOR XRESTV
      SUBROUTINE XRESTV
C---- PRINT OUT THE RESTRAINT TARGET VALUES
      INCLUDE 'XUNITS.INC'
       WRITE(NCPU,'(A)')'REM No H   No #H U mult dist'
       WRITE(NCPU,'(A)')'REM C-H'
       WRITE(NCPU,'(A)')'REM >4           1.5    .96 disorder'
       WRITE(NCPU,'(A)')'REM 1      1     1.2    .93 C C-H (acetylene)'
       WRITE(NCPU,'(A)')'REM 1      2     1.2    .93 C-C(H)-C'
       WRITE(NCPU,'(A)')'REM 1      3     1.2    .98 (C)3-C-H'
       WRITE(NCPU,'(A)')'REM 2      1     1.2    .93 C=C-H(2)'
       WRITE(NCPU,'(A)')'REM 2      2     1.2    .97 (C)2-C-(H)2'
       WRITE(NCPU,'(A)')'REM 3      1     1.5    .96 C-C-(H)3'
       WRITE(NCPU,'(A)')'REM N-H'
       WRITE(NCPU,'(A)')'REM >4           1.5    .89 Disorder'
       WRITE(NCPU,'(A)')'REM 1      1     1.2    .86 N-N/H'
       WRITE(NCPU,'(A)')'REM 1      2     1.2    .86 (C)2-N-H'
       WRITE(NCPU,'(A)')'REM 1      3     1.2    .89 (C)3-N-H'
       WRITE(NCPU,'(A)')'REM 2      1     1.2    .86 C-N-(H)2'
       WRITE(NCPU,'(A)')'REM 2      2     1.2    .89 (C)2-N-(H)2'
       WRITE(NCPU,'(A)')'REM 3      1     1.2    .89 C-H-(H)3'
       WRITE(NCPU,'(A)')'REM O-H'
       WRITE(NCPU,'(A)')'REM 1      1     1.5    .82 O-H'
       WRITE(NCPU,'(A)')'REM '
       WRITE(NCPU,'(A)')'REM Dist      esd = 0.02'
       WRITE(NCPU,'(A)')'REM Vib       esd = 0.002'
       WRITE(NCPU,'(A)')'REM Angle     esd = 2.0'
       RETURN
      END



