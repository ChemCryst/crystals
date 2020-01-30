.. toctree::
   :maxdepth: 1
   :caption: Contents:


.. include:: ../macros.bit


################################
Atomic and Structural Parameters
################################

*********
The Model
*********
The adjustable structural parameters of the model *x,y,z* the atomic displacement parameters,
( *adps* ) and the chemical site occupancey, are held in LIST 5 together with the overall scale factor (which puts the 
obervations onto an absolute scale in electrions), the |blue| Flack |xblue| parameter
(called, for historical reasons in CRYSTALS, the *Enantiopole*) and the Larson extinction 
parameter (A.C. Larson, Crystallographic Computing, Ed Ahmed, Munksgaard, 1970, page 
291-297 - this is a different definition to that used in SHELX). |br|\
For a twinned structure, the twin element scales (twin fractions) and twin laws are held 
in LIST 25.
The atomic form factors (scattering factors) are help in LIST 3, and are not refinable, 
and are identified by their chemical symbol.
|br|\
An initial model, usually obtained from an external Direct Methods program, may be used to 
phase a Fourier calculation, most commonly a *difference map* based on the phases and 
amplitude differences (Fo-Fc) computed from the current model. This map is rarely looked 
at but is automatically scanned for local maxima, called *Q peaks*.  The results of
a peak search are help in |blue| LIST 10 |xblue|, identical in format with LIST 5, but 
with the coordinates of new peaks appended after the original atoms.  
The command \\PEAKS converts 
the LIST 10 to a LIST 5. The user can then use the 
graphical interface to rename the Q-peaks with a likely chemical symbol.  



:ref:`As explained elsewhere <atom id>` , we recommend that the  atom serial numbers are unique even for 
differing atom symbols (*e.g.* C(1) and O(2) rather than C(1) and O(1) ). Automatic 
numbering is often suitable for routine analyses - manual numbering may be required for a 
series of related materials. This can be achieved through the GUI, through the edit box 
below the GUI, by editing LIST 5 with a text editor or vial the Command 
|blue| /EDIT |xblue|.

This section of the manual provides a brief introduction to the main atom-manipulation 
commands. 

::

    Input of atoms and other parameters              - \LIST 5
    Modification of lists 5 and 10 on the disc       - \EDIT
    Re-order the atom list                           - \REGROUP
    Collect atoms together by symmetry               - \COLLECT
    Convert a peaks list to atoms                    - \PEAKS
    Applying permitted origin shifts                 - \ORIGIN
    Hydrogen placing                                 - \HYDROGENS
    Per-hydrogenation                                - \PERHYDRO
    Re-numbering hydrogen atoms                      - \HNAME
    Regularisation of groups in LIST 5               - \REGULARISE





^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\LIST 5 - Atoms and other Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 
::

 \LIST 5
 OVERALL scale= enantio= extparam=
 READ natom= 
 ATOM type= serial= occ= flag= x= y= z= u[11]= ....u[12]=
 END

 #LIST      5                                                                    
 READ NATOM =     4
 OVERALL    1.611329  
 ATOM C             2.   1.000000         0.   0.143590   0.167482   0.596679
 CON U[11]=   0.089279   0.036130   0.045244  -0.002193  -0.007360  -0.012556
 ATOM H            21.   1.000000         1.   0.158290   0.089087   0.625369
 CON U[11]=   0.083975   
 ATOM H            22.   1.000000         1.   0.237088   0.165534   0.541122
 CON U[11]=   0.084325   
 ATOM H            23.   1.000000         1.  -0.044519   0.192429   0.590728
 CON U[11]=   0.084329   
 END

 Note the FLAG is set to 0 for an anisotropic atom, and 1 for the isotropic H 
 atoms, and that the CONTINUATION line begins with the name of the first 
 parameter.



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\EDIT - Editing structural parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\EDIT can be used to change a single parameter for a given atom, though this
is more conveniently done through the GUI.  More usefully, it can be used to
operate on whole groups of atoms, or the whole structure.  For the full list 
of options, see the Reference Manual. This list is a selection of commonly
used options and examples.  \\EDIT creates a new LIST 5 in your data base, leaving
the original one unaltered.
 
::

 \EDIT 
 CREATE z atom-specification  ...
 SPLIT z atom-specification ...
 CENTROID z atom-specification ...
 SELECT atom-parameter  operator  value, . .
 SORT type1 type2 ...
 SORT keyword
 TYPECHANGE keyword operator value new-atom-type
 ADD  value parameters  ...
 SUBTRACT  value  parameters  ...
 MULTIPLY  value  parameters  ...
 DIVIDE  value  parameters  ...
 SHIFT  v1, v2, v3   atom-specification . .
 TRANSFORM  r11, r21, r31, . . . r33  atom-specification . .
 END

 CREATE 100 FIRST(2,1,0,1,0) UNTIL LAST
      Creates a copy of the structure generated by the second
      symmetry operator and shifted one unit cell along y.
 SPLIT 100 F(3)
      The atom F(3) is replace by atoms F(200) and F(201) along 
      the principal axis of the adp.
 CENTROID 100 C(1) UNTIL C(5)
      Creates a pseudo-atom QC(100) at the centroid of the five 
      carbon atoms.
 SELECT U[ISO] LE 0.10
      Eliminates all atoms whose U[iso] has refined to a value
      over 0.10
 SORT C H I N O 
      Sorts the atom list so that all the carbon are first, then the 
      hydrogen etc.
 SORT U[iso]
      Sorts the atom list so that the largest U[iso] are at the end.
 ADD  0.123 FIRST(Y) UNTIL LAST
      Add 0.123 to all the y coordinates, for example to shift the
      origin along the polar axis in P 1 21 1
 SHIFT .333 .333 .666 ALL
      Shifts all the atoms by 1/3, 1/3, 2/3
 TRANSFORM 1 0 0   0 -1 0    0 0 1 ALL
      Inverts the y coordinates of all atoms




^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\REGROUP - Reorganisation of lists 5 and 10
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


 
::

 \REGROUP 
 SELECT move=1.6 sequence=yes type=all
 END



This routine  re-orders the atoms in LIST 5 (atomic parameters) or LIST 10
(Fourier peaks), so that related atoms or peaks
form a sequential group in the list, and the coordinates put the atoms
as close together as possible.
|br|\
THIS ROUTINE DOES NOT USE LIST 29 (atomic properties) to get bonding 
distances, but uses a single overall distance.
|br|\
Starting with the first atom in the list, a set of distances is calculated about
each atom or peak in the list in turn.
For each atom or peak in the list below the current pivot, the
minimum contact distance is chosen, and if this is less than a user
specified maximum, the atom or peak is moved up the list to
a position directly below the pivot. 
When more than one atom or peak is moved, their relative order is
preserved as they are inserted behind the current pivot atom.
As well as reordering the list, the necessary symmetry operators are
applied to the positional and thermal parameters to bring the atom
or peak into the same part of the unit cell as the current pivot
atom. The result of this process is to bring related atoms together
in the list, and to place all the atoms in the same part of the unit cell. 
If SEQUENCE=NO, the original serial numbers are preserved, otherwise they
are incremented, starting at one, as atoms are moved up the list.
|br|\
It is often a good idea put the heaviest atoms at the top of the original list.
|br|\ The TYPE can be |blue| ALL |xblue| (everything is available for moving), 
|blue| PEAK |xblue| (only atoms of type Q are moved), or |blue| atoms |xblue| .

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\COLLECT - Repositioning of atoms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 
::

 \COLLECT 
 SELECT tolerance=0.2 type=all
 END



Similar to REGROUP, except that the list is not re-ordered and the serial numbers are not 
changed.  Bonding is detected as the sum of the covalent radii (from LIST 29) plus a
tolerance. 

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\PEAKS - Processing of a peaks list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


 
::

 \PEAKS 
 SELECT TYPE=PEAKS
 END


This takes a peaks list (LIST 10) and converts it to an atoms list (LIST 5).  
The symmetry opeators are applied to the peaks and by default
Q-peaks which are very close to existing atoms are eliminated.  Other options
allow the Q-peaks to be used to improve the atom coordinates, and to eliminate  duplicate 
atoms (for example, if the SG symmetry is changed)



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\ORIGIN - Shifting the molecule to a permitted alternative origin
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


::


    \ORIGIN MODE=FIRST
    END
   


Attempt to move the structure to near the centre of the unit cell
using the permitted origin shifts.  Note that for some Z'>1 structures it may not
be possible to automatically achieve this for all motifs. See the graphical utility
|blue| CAMERON |xblue| for ways to achieve this manually
|br|\ 
The MODE can take the value FIRST where the computation puts the first atom  in LIST 5
close to 0.5, 0.5, 0.5, or CENTROID (the default value) which tries to centre the 
centroid of the whole LIST 5. Other connected atoms follow the centroid.
|br|\
A useful trick might be to introduce a dummy atom at the centroid of a selected group of 
atoms, in this example the centroid of RESIDUE(1)

   ::


            \edit
            cent 100 residue 1
            move qc(100)
            end
            \origin mode=first
            end
            \edit
            delete qc(100)
            end


   

   
Currently the code only handles primitive triclinic, 
monoclinic and orthorhombic cells, using the tables in Direct Methods in 
Crystallography, Giacovazzo, Academic press, 1980, pp 74 and 76.
   
   
   




^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\HYDROGENS - Hydrogen placing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


 
::

 #HYDROGENS
 DISTANCE  0.95
 SERIAL   101
 H13   C(10) H(102)    C(11)    C(5)
 END

 #HYDROGENS
 DISTANCE  0.95
 SERIAL   101
 H13   C(10) H(102)    C(16)    C(16,2,1,0,0,0)
 END


Computes the positions of hydrogen atoms based on regular geometry.  In the code *Hnm*,
*n* is the number of hydrogens to attach, *m* is the hybridisation state.  The usual rules 
for atom identifiers apply - in the second example the full symmetry definition for last 
atom - indicates that this is C(16) operated on by the second symmety operator - for 
example if C(10) lay on a mirror plane.  If the serial number requested for the new atom 
is already in use, the number is incremented until a free value is found.
|br|\
Note that this routine can be tricked into placing any missing tetrahedral, trigonal or linear 
atoms by first setting the DISTANCE to the length of the C-X bond, and then renaming the 
created hydrogen atoms to *X*.


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\PERHYDRO - Perhydrogenation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


 
::

 \PERHYDRO
 U[ISO] next 1.2
 END


This command scans the atomic coordinates for carbon atoms, attempts
to assign their hybridisation state (on the basis of bond lengths, angles and planarity)
and generates \\HYDROGEN commands to create any necessary hydrogen atoms.
Existing hydrogen atoms are not replaced by this routine, but missing ones will be added.  
The routine can also hydrogenate
nitrogen atoms, but this is generally less reliable because of the variability of geometry 
at nitrogen.


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Hydrogen re-numbering - \\HNAME
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

::


    \HNAME
    END




This command automatically renumbers hydrogen atoms so that their
serial numbers are related to the bonded non-hydrogen atom.





^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\REGULARISE - Regularisation of atomic groups
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


 
::

 \REGULARISE   REPLACE
 GROUP 6
 TARGET C(1) C(2) C(3) C(4) C(5) 
 CP-RING
 END

 \REGULARISE   AUGMENT
 GROUP 6
 TARGET C(1) C(2) Q(3) C(4) Q(5) C(6)
 PHENYL
 END


This routine calculates a fit between the
coordinates of a group of atoms in LIST 5 (atomic parameters) and another 
group. The secong group may be other atoms in the same structure or a pre-stored
idealised group.
The calculated fitting matrix may be used to compare the geometry of two
groups, or it may be applied to transform the new coordinates which will
then replace the existing target group in LIST 5 (D. J. Watkin, Act Cryst
(1980). A36,975).
|br|\
In the first example an irregular CP-ring  c(1) to C(5) is replace by an idealised
group. In the second example C(3) and C(5) are missing and are represented by the 
place holders Q(3) and Q(5). Coordinates will be computed for them, the other atoms 
remaining untouched.
|br|\
In Z'>1 structures, the routine will look for pseudo symmetry operators between motifs and
measures of similarity are output.
