.. toctree::
   :maxdepth: 1
   :caption: Contents:

   
**************************
Frequently asked questions
**************************


=======================================
Getting Started: Organisation of files.
=======================================



1. Organise your computer. Create a master folder to
hold other sub-folders, one for each new compound, e.g.
*c:/cpds/cpd1*



2. Copy the crystallographic data in to the sub-folder.
This can be a SHELXS *hkl* file or CAD4/Mach3 data collection
and psi curves. **Take** **care:** **If** **you** **open** **a** **data** **file** **with** **WORD,**
**you** **may** **accidentally** **save** **it** **as** **a** **WORD** **document.** Use WORDPAD, notepad, EDIT,
or some other text editor



3. Click the CRYSTALS icon, and use the browser to find the
folder containing your data. Click OK.



4. The CRYSTALS window is divided into four areas:

**The** **display** **window,** initially filled with the CRYSTALS logo.

**The** **menu** **bar.** The pull down menus represent the principal stages
in structure analysis, working from left to right.

**The** **text** **output** **window.** This displays the results of
calculations, or asks the user questions. It has a large scroll-back
capability.

**The** **text** **input** **line.** This is below the output window.
The cursor automatically moves to this area when you type. The 'arrow'
keys enable you to recover previous input (like the DOSKEY
utility).


5. CRYSTALS creates many files:

**A** **binary** **database** for each structure,
always named CRFILEV2.DSC. **NEVER** **try** **to** **edit** **this** **file.** This
file enables CRYSTALS jobs to be restarted from where they were left
off. All other files may be opened with a text editor e.g.
notepad, wordpad, or edit.

**Text** **files** BETACRYS.L*nn* and BETACRYS.M*nn.* The number *nn* is automatically
incremented with each run of the program. These files can generally be deleted without
looking at them unless the analysis begins to go wrong. They provide
post-mortem information.

**PUBLISH.*** files. These are final listings for preparing papers.







===================================
General: Who is responsible for it?
===================================


David Watkin is in charge of most of the code (with the
obvious exception of the SHELXS and SIR92

Many people have contributed to the software by adding new functionality or donating useful standalone
programs.


Bob Gould in Edinburgh has donated the program SXTOCRY, which
will generate a file in CRYSTALS format from SHELX.INS files. This may not
work completely for very complex SHELX.INS files, but it is a quick way to
get started in CRYSTALS.


Neil Henson (UCSB) has updated the SGI version of CRYSTALS/CAMERON,
and we believe it is working well. One user in Oxford has installed it on his
SGI and is pleased with it.



=============================
General: Where is the manual?
=============================


The CRYSTALS documentation is currently being revised and updated.

Up-to-date manuals are included in the downloadable distribution
kit at 
http://www.xtl.ox.ac.uk/download.html


All manuals are available as adobe acrobat files (.pdf) from

http://www.xtl.ox.ac.uk/download/manuals.zip PDF Files



HTML: 
http://www.xtl.ox.ac.uk/cameron.html
02/05/96 The graphics manual (50 pages)


HTML: 
http://www.xtl.ox.ac.uk/primer.html
08/10/96 An overview of the program - pre-release


HTML: 
http://www.xtl.ox.ac.uk/crystalsmanual.html
14/01/97 The CRYSTALS reference manual - pre-release (125 pages)


HTML: 
http://www.xtl.ox.ac.uk/guide.html
14/01/97 A summary of the features available - not quite finished.


=============================================
General: Is there an example to work through?
=============================================


Yes. The distribution contains two old data sets:

**Nket:** A small organic molecule. There are
instructions for processing the data, and solving and refining the
structure in the file NKET.DOC.



**Hex:** A smaller organic molecule. Used as the
data for the CRYSTALS 'test deck'. Run CRYSTALS in this directory and
type *\\USE* *HEXAMPLE.DAT* to exercise most of the CRYSTALS commands.
The file hexample.dat is commented, so that you can follow what it
does.

**Other** **examples:** From the "Help" menu, choose "Demo". There are
many 'workshop' structures. The documentation for these may be in
the "Crystals Worked Examples" manual distributed with CRYSTALS.



===========================================================================
General: Can I prepare commands to run CRYSTALS in batch mode (like SHELX)?
===========================================================================


Type the commands into a file with your favourite text editor. Then
start crystals and type **\\USE** *filename*



Including the command *\\SET* *EXPORT* *ON* will
cause CRYSTALS to write out a file called EXPORT.DAT at
the end of a run, which contains atomic co-ordinates and
refinement setup instructions, which may be edited for the next run.


========================================
General: Is there any command line help?
========================================


As a basic memory aid, you can type ? at any point and
you will be given a list of relevant options. (i.e. if you
have already typed a \\Instruction, you will see a list of directives.)


==============================================================
General: How can I switch the left and right CRYSTALS windows?
==============================================================



Edit \\WINCRYS\\GUIMENU.SRT



Find the section beginning:
::


   ^^WI         ITEM GRID _GR_TEXT_AND_INPUT NROWS=1 NCOLS=1 {




(lines 11-25) and swap it with the section beginning:
::


   ^^WI         ITEM GRID _GR_MODEL NROWS=1 NCOLS=1 {




(lines 26-51). Check the indentation remains intact. You may
want to back up your old guimenu.srt when first experimenting.


===============================================================
Solving structures: How do I prepare a job for SIR92 or SHELXS?
===============================================================


 Input the necessary data:


**List** **1** - Cell

**List** **2** - Symmetry

**List** **6** - Reflections

**List** **29** - Asymmetric unit contents



 Type: *\\FOREIGN* *SIR92* or *\\FOREIGN* *SHELX* 


Exit CRYSTALS (*\\END)* and run the direct methods
program (Sir92 or Shelxs).


================================================================
Solving structures: It failed. How do I prepare a different job?
================================================================


 Type: *\\FOREIGN* *SIR92* **DIFFICULT** or *\\FOREIGN* *SHELX* **DIFFICULT** 


Exit CRYSTALS (*\\END)* and run the direct methods
program (Sir92 or Shelxs).


====================================================================
Solving structures: How do I import the solution back into CRYSTALS?
====================================================================


Type *\\SCRIPT* *INEMAP* and follow the
instructions given. (You will be asked which program you
used to solve the structure.)


==============================================
CAMERON: How do I see a plot of the structure?
==============================================


Type:*\\SCRIPT* *PLOT*

To exit CAMERON, type *END* or click File/Exit in the menus.


=============================================
CAMERON: Can I rotate it and label the atoms?
=============================================


Some basic commands:


**VIEW** - update the graphics (v. important)

**XROT** n - rotate about x by n degrees

**YROT** n - rotate about y by n degrees

**ZROT** n - rotate about z by n degrees

**CURSOR** - rotate using cursor keys

**LABEL** **ALL** - label all the atoms

**NOLABEL** **ALL** - remove labels

**EXCL** **H** - hide all H atoms

**INCL** **H** - show all hidden H atoms

**MENU** **ON** - turn on the menu bar


===============================
CAMERON: How do I delete atoms?
===============================


Type *EXCL* followed by the atom name (or
just click on the atom. You can restore a deleted
atom by typing *INCL* followed by the atom name, or
*INCL* *ALL* to bring everything back.




================================================================
Fourier: How do I calculate a Fourier map to find missing atoms?
================================================================


You must have already entered the following required information:


**List** **1** - Cell

**List** **2** - Symmetry

**List** **3** - Scattering factors

**List** **5** - Parameters (model)

**List** **6** - Observations (reflections)

**List** **14** - Fourier limits

**List** **29** - Asymmetric unit contents


From the *Fourier* pull-down menu, choose the type of Fourier
map that you wish to calculate. You will be presented with a
dialog box which allows you to control the subsequent peak
search routine.


Use an F-obs map for completing structures with atoms other
than hydrogen missing. You will also be given the option to use the
Fourier map to refine the positions of existing atoms in the structure.


Use a difference map for completing structures that are almost
complete, e.g. to find hydrogen atoms. Using the *Add*
*hydrogen* option from the *Structure* menu will place hydrogen
geometrically on carbon skeletons **and** allow you to compare
these positions with a difference Fourier map.


===============================================
Refinement: What infomation does CRYSTALS need?
===============================================



 **List** **1** - Cell

**List** **2** - Symmetry

**List** **3** - Scattering factors

**List** **4** - Weighting scheme (default - unit weights)

**List** **5** - Parameters (model)

**List** **6** - Observations (reflections) AND/OR **List** **16** - Observations (restraints)

**List** **12** - Refinement instructions

**List** **23** - Refinement options

**List** **28** - Reflection acceptance criteria (default - all)

**List** **29** - Asymmetric unit contents


===================================
Refinement: Refinement instructions
===================================



List 12 can be entered in the following manner:
::


    \LIST 12
    FULL I(1,X'S,U'S) C(7,X'S) O(1,Y) O(1,U[ISO]) UNTIL C(6)
    GROUP C(1) UNTIL C(6)
    END




This example refines the position and Uij's of I(1), the position
of C(7), the y-coordinate of O(1) and the isotropic thermal
parameters of atoms O(1) until C(6) based on the order they appear
in list 5. It also refines the positions of atoms C(1) to C(6) as a rigid-body.



Alternatively, choose *Guided* *Automatic* from the
*Refinement* menu to run a script which automatically writes List
12 and refines the structure based on its assessment of the
current state of progress.


====================================================================
Refinement: Occupancies of an atom or fragment split over two sites?
====================================================================


Use constraints. Constraints are set up using List 12, so you must be
prepared to eschew the GUIDE and write your own constraint instructions. Here is how:




Step one:

Before you do anything, ensure that the occupancies of the two sites add up to one.
A constraint only affects the shifts applied to parameters: if the sum of the 
parameters is not sensible to begin with, it never will be.

There are several ways to do this. In these examples the occupancy of each
fragment is set to 0.5:
::


     1. Use the graphical interface - right click an atom, choose Edit from
        the popup menu and change the occupancy in the dialog box. Click Apply.
        Repeat for each atom. 
     2. Use the \EDIT command (changing the atom names, of course):
             \EDIT
             CHANGE C(1,OCC) C(10,OCC) UNTIL C(15) 0.5
             CHANGE C(101,OCC) C(110,OCC) UNTIL C(115) 0.5
             END
        Please remember that UNTIL sequences are dependent on the order
        of atoms in LIST 5, don't use them if you're not sure.
     3. 'Punch out', edit, and read back in the parameters (LIST 5). There
        are menu and toolbar options to do this, or just type:
             \SCRIPT SYSED5






Step two:

Setup the constraints. If you like using the GUIDE, then it will already
have produced a basic LIST 12 (constraints) for you.

To edit List 12, there are menu and toolbar options, or just type:
::


             \SCRIPT EDLIST12




Presumably, the first two lines of the LIST 12 instruction 
will be something like this:
::

        
             \LIST 12
             BLOCK SCALE X'S U'S




There may also be lots of RIDE constraints if you have chosen to
ride the hydrogen atoms.

Add the following lines after those and before the 'END' statement 
(changing the atom names, of course):
::


             \   This is a comment.
             \   The EQUIVALENCE constraint, split over two lines here
             \   maps all the model parameters following it onto one
             \   least squares parameter. ie. for all the occupancies
             \   given here only one value will be refined.
             EQUIVALENCE C(1,OCC) C(10,OCC) UNTIL C(15)
             CONTINUE C(101,OCC) C(110,OCC) UNTIL C(115)
             \   This is a comment.
             \   The weight instruction means that the derivatives and
             \   shifts of the listed parameters will be multiplied by
             \   the given weight. This has the effect of ensuring that
             \   the sum of the occupancies of the two sites remains
             \   constant.
             WEIGHT -1 C(101,OCC) C(110,OCC) UNTIL C(115)




Save and close the file, CRYSTALS will automatically read it back in.


Step three:

Carry out the refinement. *Don't* *use* *the* *GUIDE,* it will overwrite
all your hard work typing in those constraints. Instead use one of the
following methods to initiate some cycles of least squares:
::


       1. Just type:
         \SFLS
         REFINE
         REFINE
         REFINE
         END
    or 2. Type \SCRIPT XREFINE to get a dialog with a few options.
       3. Choose "Refinement"->"Refine" from the menus, or the 
          equivalent toolbar button ("R").




Verify that the occupancy values after refinement make sense. Check
that they add up to one, and confirm that only the occupancies that
you intended to refine have in fact been refined.



====================================
Refinement: How do I add restraints?
====================================


Restraints are set up using list 16.





For easy generation of simple restraints select two, three or
more atoms in the model window. Right click on one of the group
and choose an option from the pop-up restraints sub-menu. Any
restraints generated in this way will be appended to the existing restraint instructions
in list 16.


An example List 16 could be:
::


    \LIST 16
    DIST  1.39 , .01 =      C(1) to C(2)
    DIST  0.0  , .01 = MEAN C(3) to C(4), C(4) to C(5)
    VIBR  0.0  , .01 =      C(6) to C(7)
    U(IJ) 0.0  , .02 =      C(8) to C(9)
    PLANAR                  C(1) until C(6)
    SUM                     K(1,OCC), K(2,OCC), K(3,OCC)
    LIMIT                   U[11] U[22] U[33]
    END




The first instruction restrains the bond C(1) to C(2) to be 1.39
angstroms with an e.s.d. of .01 angstroms.

The second instruction is a similarity restraint which restrains the difference
between two bonds (C3-C4 and C4-C5) to be zero with an e.s.d of .01
angstroms.

The third restrains the difference between the mean square
displacement of each atom along the direction of a bond to be
zero, with an e.s.d of .01. Isotropically refined atoms will also be dealt with
correctly.

The U(IJ) restraint between C(8) and C(9) restrains the difference between the
corresponding Uij components to be zero with an e.s.d of .02.

The planar restraint restrains atoms C(1) to C(6) (based on the
list 5 order) to be planar. The e.s.d defaults to 0.01.

The sum restraint holds the sum of the specified parameters (in
this case the occupancy of three postassium atoms) to be constant
during the refinement. The default e.s.d is 0.0001. This is
useful where disordered atoms occupy more than two sites, since
in these cases the total occupancy cannot be held constant using
constraints.

The limit restraint attempts to limit the shift of the specified
parameters to zero (in this case all the Uii anisotropic
parameters). This is useful for controlling refinements of poor
starting models. The default e.s.d is 0.01. Lowering it to 0.001
will effectively fix the parameter, and raising it to 10 will have
almost no effect unless the shift due to the X-ray observations is
huge.


==========================================================
Refinement: How do you use Platon's Squeeze from CRYSTALS?
==========================================================



I gave it a try but doesn't seem to make much difference. I am not 
sure that I am using it in the right way.


(1) You must make sure there is a void in the structure. (ie. delete the
solvent that you want squeeze to take care of) - this is the a
common misunderstanding about running squeeze.


(2) Run Squeeze from the Refinement menu. Three things might happen:


(a) CRYSTALS asks where platon.exe is. Tell CRYSTALS and carry on.
If you don't have a copy of PLATON, them download one.


(b) Something flickers quickly onto the screen and then disappears,
and CRYSTALS asks whether you want to use the results from 
Squeeze. Don't. It didn't work. You could try downloading a 
new version of Platon, and testing that Platon can be
started in interactive mode by choosing 'Platon' from the
Tools menu.


(c) Platon starts and grinds through some calculations for a while. If 
it ends in error, the don't apply the results when CRYSTALS asks.
If something went wrong, then maybe your trying to squeeze to 
large or small a void or something.


(3) Look at the summary in the Platon dialog window. Close the Platon
dialog window.


(4) CRYSTALS will ask 'Do you want to apply the results?'. Click Yes.


Instead of doing the usual 'Squeeze thing' of altering your FObs values
(generally considered to be a BAD THING), CRYSTALS and PLATON together
do something much nicer: the A and B components of the structure factor
which are due to scattering from the 'void' are stored in your list of 
reflections; the F-obs value is unchanged. When calculating structure
factors, the program adds together the scattering from the atomic
electron density as usual, and then adds in the pre-computed A and B 
parts aswell. Not only does this avoid meddling with the FObs values,
but it also (a) keeps the phase information from the scattering from
the 'void', and (b) allows you to iteratively reapply squeeze if you
think you've improved the model at all and (c) ditch the squeeze
correction if you don't like it.




=================================================
Refinement: What are parts assemblies and groups?
=================================================

Please could you tell me briefly how can I make use of 'PART' for 
disordered groups.


The easy way: type "
script xparts" and add new assemblies and groups
and then click the atoms that you want to be in those groups.


An 'assembly' is a disordered set of atoms, a 'group' is a subset
that has the same occupancy (e.g. very simply if a CF3 is has
rotational disorder then group 1 might be F(1), F(2),F(3),
F(11), F(12), F(13). Group 1 Part 1 might be F(1), F(2), F(3) and
group 1 part 2 might be F(11), F(12), F(13).


A PART is the value in list 5 used to store this information.
PART = ASSEMBLY * 1000 + GROUP


Group 1 will not bond to group 2 of the same assembly in the diagram,
and in versions of CRYSTALS 12.09 and onwards the bonds and angles
in the CIF will also be only between the appropriate atoms.


For the refinement itself, you can take shortcuts using a new
the PART syntax, e.g. to refine the occupancies:

LIST 12
BLOCK SCALE X'S U'S
EQUIVALENCE PART(1001,OCC) PART(1002,OCC)
WEIGHT -1 PART(1002,OCC)
END

(Obviously make sure the occ's add up to 1 before you start, same
as normal)                               

This stuff is quite new, so try to verify it's doing what you think
it's doing! If in doubt send me the .dsc file for checking.


=============================================================================
Structure: How can I adjust a molecule or fragment to have ideal coordinates?
=============================================================================

This assumes you've got some known coordinates for, say, a solvent
molecule and you want to tidy up a molecule in your structure because
it isn't refining very well.


We find a nice orthoxylene molecule (eg. CSD entry
WAFKOD) and we want to correct our rather poor orthoxylene molecule
which is numbered C101-C108 starting on one methyl and ending on
the other, going the long-way around the ring.


That atoms we want to correct are specified on the TARGET directive.
The coordinates of atoms of the ideal molecule are given on ATOM
directives, following a SYSTEM directive with the cell parameters
of the structure that the ideal molecule is taken from.

::


    \REGULARISE REPLACE
    GROUP 8
    TARGET C(101) C(102) C(103) C(104) C(105) C(106) C(107) C(108)
    SYSTEM 10.433 11.857 16.054 86.44 76.81 75.44
    ATOM  .7930 .5259 .5059
    ATOM  .8696 .4140 .4641
    ATOM  .9491 .3689 .3994
    ATOM 1.0055 .2640 .3753
    ATOM  .9669 .1771 .4394
    ATOM  .8941 .2227 .5072
    ATOM  .8292 .3231 .5311
    ATOM  .7351 .3958 .6018
    END




Note that for pdb-type coordinates, you should give "SYSTEM 1 1 1 90 90 90".


============================================================
Analysis: Find the angle between a plane of atoms and a bond
============================================================

To find the angle between a plane of atoms and a bond use the \\GEOMETRY instruction:


::


     \GEOMETRY
     ATOMS C(3) C(4) C(5) C(6) C(7) C(8)
     PLANE
     ATOMS C(1) O(2)
     LINE
     DIHEDRAL 1 AND 2
     END




This calculates the best plane of atoms C(3) through to C(8), and
the line through the bond C(1) O(2). The dihedral command prints
the angle between the vector normal to the best plane and the vector defined
by the bond.

i.e. if the bond is at right angles to the ring, the angle will be 
zero, and if the bond is in the same plane as the ring, the angle
will be 90.



Changing PLANE to LINE, or LINE to PLANE will allow you to find the
angle between two planes or the angle between two lines!


============================================
Analysis: Calculate intermolecular distances
============================================

For intermolecular bond lengths, the syntax is quite flexible - it's just
a matter of telling the program what distance range to look in - try
typing something like this at the command line:


::


      \dist
      select range=limits
      limit 2.0 4.0 2.0 4.0
      include N(6) O(8)
      end




This will give all the bond lengths and angles involving the 
specified atoms (so only bond lengths in this case!) that fall
in the range 2.0 to 4.0 Angstroms. The first range 2.0->4.0 is
for bonds, the second is for bond that form angles.


If you want su's too, then add this line before 'end':

::


       e.s.d yes




You can specify atom types instead of specific atoms, e.g. to look
for only O-O contacts just use

::


       include O




The manual details other options for selecting atoms such as exclude,
pivot etc.


========================================================================
Analysis: Find LIKELY H-BONDS with donors or acceptors other the O and N
========================================================================

The action for the 'Likely H bonds' menu option is to find any H--A 
distances in the range 1.5-2.2 angstroms, where A is O or N. It also 
lists D-H--A angles where DH and AH are in the range 0.7-2.2 angstroms, 
so that you can check that a give H--A bond forms a reasonable D-H--A angle.


The instruction that is executed is:
::

 
     \dist
     out mon=all
     select range=limits
     limit 1.5 2.2 0.7 2.2
     pivot H
     bonded O N
     end




The 'pivot' atoms can only be at the centre of an angle or one end
of a bond, and the 'bonded' can only be at the edges of an angle or the
other end of the bond. 


For other acceptors, add element to the BONDED directive (e.g. CL) in the above 
command and extend the bonding limits to something reasonable for a H--CL distance
e.g. from 2.2 to about 3.7(?). It will then find all H--CL bonds and O-H--CL, or
N-H--CL angles.


Becuase the distance command doesn't let you specify different limits for each
side of an angle no distinction can be made between donors and acceptors, (i.e. you
cannot get separate listings of O--H-N and N--H-O angles)



===================================================
Analysis: How do I use ROTAX to test for twin laws?
===================================================


1. Choose Analyse-> Rotax Analysis/Twins-> ROTAX from the menu.


2. In the ROTAX dialog box, leave settings as 180 degree rotation 
and show F.O.M. less than 5.0. Click OK.


3. On the results dialog there will be (possibly) some numbers in a listbox
below where it says "Choose a figure of merit:".

Any which are exactly zero correspond to possible merohedral twin
laws

If there are any non-zero numbers then these are likely merohedral 
twin laws.

Click one of the numbers to see the twin-law matrix.

If you like the look of a twin-law (lowest non-zero FOM) then click 
the button "Apply Twin Law", then "Apply Twin Laws" on the next dialog.


4. To test the twin law Choose Refinement-> Setup and Refine and check
the "Twin Element Scales" box. Then do some cycles of refinement.


The R-factor should drop substantially if the twin law is correct,
and typing
::


    \PARAM
    END




will show you what the twin elements scales have refined to.


To undo it all, choose Analyse-> Rotax Analysis/Twins-> Remove Twin
Laws.



=========================================================
Analysis: How do I add hydrogen atoms to water molecules?
=========================================================


The following will work to find short O--O or O--N contacts
in the range 2 - 3 Angstroms around a water atom O(6). 
Adjust the numbers on the LIMITS line to look at different ranges. 
Type this into the CRYSTALS command line (the small edit box below
the text output), press return after each line.
::


       \DIST 
       OUTPUT MON=DIST 
       SELECT RANGE=LIMITS 
       LIMITS 2.0 3.0  0.0 0.0 
       PIVOT O(6)
       BONDED O N
       END




The PIVOT line specifies the single water atom (O(6)) at one end of
the bond, while the BONDED line specifies that the other end of the
bond must be a nitrogen or oxygen atom. 


Once you have found a likely H-bond, say to O(21), you can place the
H by typing in the following set of commands: 
::


       \HYDROGEN
       DISTANCE 0.9
       HBOND O(6) O(21)
       END




i.e. O(6) is the donor and O(21) is the acceptor.



================================================================
Publication: Editor wants completeness of the data at 25 degrees
================================================================


Is there a way to get that from CRYSTALS?
The current data in the CIF is something like this:
::

 
    _diffrn_reflns_theta_min              4.123
    _diffrn_reflns_theta_max             28.884 
    _diffrn_measured_fraction_theta_max   0.934 
     
    _diffrn_reflns_theta_full            21.098
    _diffrn_measured_fraction_theta_full  0.996






Those pesky editors. Here's what to do:


1)  Choose "X-ray data"->"Edit goodies".


2)  Locate the box labelled "Theta full (set -ve to fix at absolute
value)", and change the value to -25.00


3)  Click OK.


4)  Make a new CIF.



======================================================================
Publication: What's the difference between _theta_max and _theta_full?
======================================================================
::


   _diffrn_reflns_theta_max             28.884 
   _diffrn_measured_fraction_theta_max   0.934 
    
   _diffrn_reflns_theta_full            21.098
   _diffrn_measured_fraction_theta_full  0.996






Theta_max is the very highest theta angle found in all of your
data. The _diffrn_measured_fraction_theta_max is the completeness
(number measured/number reflections expected) at this angle.



Theta_full allows you to specify a value of theta at which you
are prepared to call your data set 'complete'. Because 100% completeness
is very tricky to acheive, there is no hard and fast rule for
deciding where to set theta_full. By default, CRYSTALS will choose
a value for you, trading off decreasing theta with increasing completeness 
(though it is worth noting that in many cases, a few missing reflections
at low theta - e.g. due to beam stop - will mean that completeness actually
increases with increasing theta).  An analysis of completeness is
given amongst the "Tabbed initial analysis" graphs from the "Analyse" menu
in CRYSTALS.



========================================================
Publication: Diagram shows wrong enantiomer. What to do?
========================================================



If you just want a diagram, you can edit the cif by multiplying all the 
atomic coordinates by -1, but this isn't a good idea when producing material 
for publication.


It's generally better to do it in CRYSTALS:


For most space groups you can just use the 'invert structure' option from 
the 'structure' menu. Alternatively you can do the same thing from the 
command line by issuing:
::


   \edit
   transform -1 0 0 0 -1 0 0 0 -1 all
   end




These will probably give you a model in which the asymmetric unit lies well 
outside the standard unit cell. Look at a packing diagram in Cameron to find 
a better choice of molecule, save the changes then do another cycle of 
refinement. A new cif will have the correct symmetry operators if there are 
any bonds leading from one asymmetric unit to another, which is the main 
reason for not just modifying the original cif.


WARNING: there are certain space groups for which this procedure is 
insufficient. One type is where the space group contains a screw axis with a 
rotation component <180 degrees and all the symmetry operators have the same 
hand. In this case it is necessary to change the space group symbol. There 
are 11 pairs of this type: if your structure is one of these it should be 
interchanged with the other member of the pair:
::


   P 41      <-> P 43
   P 41 2 2  <-> P 43 2 2
   P 41 21 2 <-> P 43 21 2
   P 31      <-> P 32
   P 31 2 1  <-> P 32 2 1
   P 31 1 2  <-> P 32 1 2
   P 62      <-> P 64
   P 61      <-> P 65
   P 62 2 2  <-> P 64 2 2
   P 61 2 2  <-> P 65 2 2
   P 41 3 2  <-> P 43 3 2




Change the space group from the 'edit spacegroup' option of the 'X-ray data' 
menu, then invert the structure and choose the best asymmetric unit as 
above.


There are also 7 space groups in which the origin also has to be changed - 
the offending ones are:

F d d 2, I 41, I 41 2 2, I 41 m d, I 41 c d, I -4 2 d and F 41 3 2. If you 
have a structure in one of these, get help!




================================================
References: What References should I know about?
================================================


Please note the references for CRYSTALS and CAMERON, and cite them with each
structure you publish, along with references to any other software programs that you
have used. In the current difficult financial
atmosphere in the UK, employers have begun to count the numbers of
citations for work, as well as publications, so we will need clear support from
the user community if the work is to continue.

::


   CRYSTALS
      Betteridge, P. W.,  Carruthers, J. R.,  Cooper, R. I.,
      Prout, K., Watkin, D. J. (2003). J. Appl. Cryst. 36, 1487.





CAMERON References
::


   CAMERON
        Watkin, D.J. Prout, C.K., Pearce, L.J. (1996). CAMERON, Chemical
        Crystallography Laboratory, University of Oxford, Oxford, UK.





RC93 References
::


   RC93
        Watkin, D.J., Prout, C.K., Lilley, P.M.deQ. (1994), RC93, Chemical
        Crystallography Laboratory, University of Oxford, Oxford, UK.





Sir92 References
::


   SIR92
        Altomare, A., Cascarano, G., Giacovazzo G., Guagliardi A.,
        Burla M.C., Polidori, G. & Camalli, M. (1994)
        SIR92 - a program for automatic solution of crystal structures by
        direct methods. J. Appl. Cryst. (27), 435





Chebychev weighting References
::


   CHEBYCHEV WEIGHTING
        Carruthers, J.R. and Watkin, D.J. (1979), (Chebychev Weighting)
        Acta Cryst, A35, 698-699





SHELXS References
::


   SHELXS86
        Sheldrick, G.M. (1986).  SHELXS86. Program for the solution of
        crystal structures.  Univ. of Gottingen, Federal Republic of Germany.





DIFABS References
::


   DIFABS
        Walker, N., and Stuart, D. DIFABS. Acta Cryst, A39, 158-166





====================================
Miscellaneous: Environment variables
====================================


CRYSTALS will substitute for any environment variables when
opening files or spawning processes. The variable is identified by
appearing before a colon (e.g. CRYSDIR:script/test.scp will be
expanded to something like /usr/local/crystals/script/test.scp
where CRYSDIR=/usr/local/crystals/).



Any environment variable that refers to paths or files may be a comma 
separated list of alternative locations.


 
When opening files for reading, CRYSTALS will look in each location in
turn and open the first file that exists. When opening files for 
writing, they will always open in the first location in the list.



