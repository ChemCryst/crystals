.. toctree::
   :maxdepth: 1
   :caption: Contents:

   

   

*******************
Analysis Of Results
*******************




.. _geomandres:

 

=======================================
Scope of this section of the user guide
=======================================


::


    Analysis of residuals                          ANALYSE
    Output of atom esds                            ESD
    Distance and angles calculations               DISTANCES
    Void search                                    VOIDS
    Global Geometry (planes,lines & libration)     GEOMETRY
    Torsion angles                                 TORSION
    Absolute Configuration                         TON
    Publication listing of the atomic parameters   PARAMETERS
    Publication listing of the reflections         REFLECTIONS
    Summary of data lists                          SUMMARY
    CIF files                                      CIF
    Graphics                                       CAMERON







.. index:: ANALYSE


.. index:: Residual analysis


=================================
Analysis of residuals - \\ANALYSE
=================================



This analyses the residual, Fo-Fc, for systematic trends, which might
either indiacate an incomplete model, or an unsatisfactory weighting
scheme. It is described in the chapter Structure Factors and Least
Squares.






*e.s.d.s*


Most publication listings require e.s.ds. These are computed
from the normal matrix. If LIST 5 (the model parameters) has been 
modified in **ANY** **WAY**
(including simply renaming or ordering atoms) since the last
refinement cycle, the matrix will be invalid.


CRYSTALS will warn you that LIST 11, the normal matrix, cannot be
loaded.  To create a valid matrix
without changing the parameter values, compute a refinement cycle but set
all the shifts to zero.

::


         \SFLS
         REFINE
         SHIFT GENERAL = 0.0
         END





.. index:: ESD


.. index:: Create esd list, LIST 9


=======================
Create esd list - \\ESD
=======================

::


   
    \ESD
    END
    






The current LIST 5 must belong to the current VcV matrix (See
the warning above).



.. index:: VCV


.. index:: Output VcV matrix of selected atoms


===================================
Output VcV matrix of selected atoms
===================================

HVcV#
::


    \VCV
    ATOM C(1) C(2) C(3)
    ACTION
    END
   





q




.. index:: DISTANCES


.. index:: Distance calculations


.. index:: Angle calculations


.. index:: Geometry calculations


============================================
Distance angles calculations  -  \\DISTANCES
============================================


::


    \DISTANCES INPUTLIST=
    OUTPUT MONITOR=  LIST= PUNCH= HESD=
    SELECT ALLDIST= COORD= SORTED= TYPE= RANGE= SYMM= TRANS=
    LIMITS DMINIMUM= DMAXIMUM= AMINIMUM= AMAXIMUM=
    E.S.D.S COMPUTE= CELL=
    INCLUDE atoms
    EXCLUDE atoms
    ONLY atoms
    PIVOT atoms
    BONDED atoms
    END
   
    \DIST
    E.S.D YES
    END






The distance angles routine is completely
general with respect to crystal and lattice symmetry.
For distances, the user may either use elemental radii specified in
LIST 29 (see section :ref:`LIST29` for input details), or specify  minimum and 
maximum limits,
and the program then calculates all possible contacts within these
limits.
All symmetry operations and unit cell translations are automatically
generated.
For the angles, LIST 29 or a separate set of distance limits may be used.
At a given atom, angles are then calculated between all the atoms
which bond to the central atom within the given limits.


The distance-angles routines can calculate the estimated
standard deviations of the distances and angles that they produce.
These e.s.d.'s are based upon the matrix stored in LIST 11 (see section
:ref:`LIST11`), and
as many variance and covariance terms as are present are used.
(For a full matrix, therefore, the full variance-covariance matrix
is used).
For this reason, the calculation of e.s.d.'s
takes at least ten times as long
as a simple distance angles calculation.


When  a set of e.s.d.'s are calculated, the variance-covariance matrix
for the cell parameters (LIST 31, section :ref:`LIST31`) may also be used.



----------------------
\\DISTANCES INPUTLIST=
----------------------

   

*INPUTLIST=*


   
   ::


            5   -  Default value
            10
   


   
   The default is to use the normal atom coordinate list.
   
   
   

**OUTPUT MONITOR= LIST= PUNCH= HESD=**


   

*MONITOR=*


   This controls the monitoring information.
   
   ::


            OFF         -  no output
            DISTANCES   -  only monitors distances. (Default)
            ANGLES      -  only monitors angles.
            ALL         -  monitors distances and angles.
   


   
   

*LIST=*


   This controls the format of the listing.
   
   ::


            OFF
            LOW  
            MEDIUM
            HIGH   -  Default
            DISTANCE
            (DEBUG)
   


   
   If  LIST  is  LOW the the listing is in a compressed
   format, without symmetry information. If LIST is OFF, no output is sent
   to the listing file unless PUNCH is PUBLISH, when a copy of the publication
   listing appears in the listing file. If LIST is DISTANCE, a simplified table of
   distances is output.
   
   
   

*PUNCH=*


   This controls the output sent to the 'punch' file.
   
   
   PUBLISH     - Produce a listing suitable for publication.
   
   HTML        - Produce an HTML format listing
   
   CIF         - Produce a listing in CIF format.
   
   H-CIF       - Produce a listing of the H-bonds in CIF format.
   
   SCRIPT      - Lists bonds in a easily machine readable format.
   
   RESTRAIN    - Produce a proforma LIST 16 (restraints - :ref:`LIST16`).  Use the RANGE, 
   LIMIT, TYPE INCLUDE and EXCLUDE parameters to restrict the restraints produced.
   
   DELU        - Proforma LIST 16 for delta U restraints
   
   SIMU        - Proforma LIST 16 for U-similarity restraints
   
   NONBONDED   - Proforma LIST 16 with anti-bumping restraints
   
   H-RESTRAIN  - Produces a list of H-C,N and O distance and angle 
   restraints in the PUNCH file, and a list of the referenced H atoms in 
   the SCRIPTQUEUE file.
   
   H-RIDE      - Produces a list of H-C,N and O RIDE instructions.
   
   H-CIF       - Puts hydrogen bond donor and acceptors into the cif 
   file.
   
   
   
   
   If hydrogen atom restraints are being generated, the following target 
   values are used:
   ::


      No.H  No.H   U mult     dist
      C-H
      >4            1.5      .96 disorder
      1      1      1.2      .93 C C-H (acetylene)
      1      2      1.2      .93 C-C(H)-C
      1      3      1.2      .98 (C)3-C-H
      2      1      1.2      .93 C=C-H(2)
      2      2      1.2      .97 (C)2-C-(H)2
      3      1      1.5      .96 C-C-(H)3
      N-H
      >4            1.5      .89 NH4 or disorder
      1      1      1.2      .86 N-N/H
      1      2      1.2      .86 (C)2-N-H
      1      3      1.2      .89 (C)3-N-H
      2      1      1.2      .86 C-N-(H)2
      2      2      1.2      .89 (C)2-N-(H)2
      3      1      1.2      .89 C-H-(H)3
      O-H
      1      1      1.5      .82 O-H
      
      Dist      esd = 0.02
      Vib       esd = 0.002
      Angle     esd = 2.0
      
   


   
   
   
   
   

*HESD=*


   This controls the output of ESDs to the CIF file.
   
   ::


            ALL      - (Default) Output all bond length and angle standard
                       uncertainties (if requested) to the CIF (if requested),
                       including those of bonds to fixed atoms (i.e. to atoms on
                       special positions, or to atoms that are not refined).
            NONFIXED - Exclude standard uncertainties of bond distances and angles
                       to Hydrogen atoms that have not been refined. (as
                       required by Acta's notes for authors).
   


   
   

**SELECT ALLDIST= COORD= SORTED= TYPE= RANGE= SYMMETRY= TRANS=**


   
   

*ALLDISTANCES=*


   
   ::


            NO   -  Default value
            YES
   


   
   
   
   If  ALLDISTANCES  is  NO,
   the distances calculated about each atom will only
   be those to atoms that occur after the central
   atom in LIST 5. (i.e. each distance
   is only printed once).
   
   
   If  ALLDISTANCES  is
   YES , then the distances from each atom to all
   the other atoms are calculated for all the atoms.
   (In this case, each distance will appear twice in the list).
   

*COORDINATES=*


   
   ::


            NO   -  Default value
            YES
   


   
   If  COORDINATES  is  YES, the transformed
   coordinates of each atom in a distance calculation
   are printed.
   If  COORDINATES  is  NO,
   the transformed coordinates are not printed.
   

*SORTED=*


   
   ::


            NO   -  Default value
            YES
   


   
   If  SORTED  is  NO,
   the distances from the central atom are in the order
   in which the other atoms occur in LIST 5.
   If  SORTED  is  YES , the distances are printed in
   order of increasing magnitude.
   

*TYPE=*


   This parameter indicates the type of distances which will be
   calculated.
   
   ::


            ALL   -  Default value
            INTRA
            INTER
   


   
   If  TYPE  is  ALL,
   then all distances are printed; if  TYPE  is  INTRA  then only
   intramolecular distances are printed, and if  TYPE  is  INTER
   then the intermolecular distances are printed (Note that the whole
   asymmetric unit is regarded as a 'molecule'.
   

*RANGE=*


   This parameter defines how the range is to be selected.
   Except when RANGE = LIMITS (when the lowest acceptable distance is
   user-specified) contacts of zero angstrom are suppressed.
   
   ::


            COVALENT      Use 'covalent' radii from LIST 29.
            VANDERWAALS.  Use 'VanderWaals' radii from LIST 29, but angles are
                          suppressed.
            IONIC.        Use 'ionic' radii from LIST 29.
            LIMITS.       Use specified or default ranges set by the LIMIT directive.
   


   
   

*SYMMETRY=*


   This parameter controls the use of symmetry information in the calculation of
   contacts, and can take three values.
   
   ::


            SPACEGROUP  -  Default value. The full spacegroup symmetry is used in
                                          all computations
            PATTERSON.     A centre of symmetry in introduced, and the translational
                           parts of the symmetry operators are dropped.
            NONE.          Only the identity operator is used.
   


   
   

*TRANSLATION=*


   This parameter controls the application of cell translations in the
   calculation of contacts, and can take the values YES or NO
   
   
   
   
   

**LIMITS DMINIMUM= DMAXIMUM= AMINIMUM= AMAXIMUM=**



   
   This directive specifies the limits for the distance angles
   calculations, and may only be given if RANGE = LIMITS has been specified
   on a
   preceding SELECT directive.
   

*DMINIMUM*


   This defines the distance below which distances are not
   calculated or printed. The default is zero.
   

*DMAXIMUM*


   This parameter defines the maximum distance above which distances are not
   calculated or printed.
   Use \\COMMANDS DISTANCES to find the default value for  DMAXIMUM.
   All the distances that are to be calculated and printed
   must lie between  DMINIMUM  and  DMAXIMUM.
   

*AMINIMUM*


   For a given central atom, other atoms which
   make contacts that are less than  AMINIMUM  will
   not be considered when the angles at the
   central atom are computed.
   The default is zero.
   

*AMAXIMUM*


   For a given central atom, other atoms which
   make contacts that are greater than  AMAXIMUM
   will not be considered when angles at the
   central atom are computed.
   The default value for  AMAXIMUM  is set in the COMMAND file.
   AMAXIMUM  And  AMINIMUM  define a shell about each
   pivot atom outside of which angles are not computed.
   
   
   
   
   

**E.S.D.S COMPUTE= CELL=**



   
   This directive determines whether estimated standard deviations
   of the distances and angles are calculated.
   

*COMPUTE*


   
   ::


            NO   -  Default value
            YES
   


   
   If this parameter is NO,
   standard deviations are not
   computed.
   Note that if e.s.d.'s are to be calculated, i.e.  COMPUTE  is
   set equal to  YES , then a suitable least squares matrix (LIST 11, see
   section :ref:`LIST11`) must be
   available.
   

*CELL=*


   
   ::


            NO   -  Default value
            YES
   


   
   If this parameter is NO,
   the variance-covariance matrix for the
   cell parameters is not included when the e.s.d.'s are calculated.
   
   
   

**INCLUDE atoms**



   
   This directive determines which atoms are included as pivot atoms
   in the calculation.
   The arguments may be either a type of atom , or an atom specification of
   the 'type(serial)' or 'type(serial) UNTIL type(serial)' kind described
   elsewhere in the manual. Only INCLUDEd atoms are used as pivots, but distances
   and angles are computed to all other atoms in the current LIST 5 within
   the ranges specified on the SELECT directive.
   
   
   

**ONLY atoms**



   
   Similar to INCLUDE, except that specified atoms may be pivot or
   bonded.
   The arguments may be either a type of atom , or an atom specification of
   the 'type(serial)' or 'type(serial) UNTIL type(serial)' kind described
   elsewhere in the manual. Distances
   and angles are computed only to specified atoms in the current LIST 5 within
   the ranges specified on the SELECT directive.
   
   
   

**PIVOT atoms**



   
   Similar to INCLUDE, except that atoms excluded with an EXCLUDE
   directive can still be used to bond to.
   The arguments may be either a type of atom , or an atom specification of
   the 'type(serial)' or 'type(serial) UNTIL type(serial)' kind described
   elsewhere in the manual. Distances
   and angles are computed only to specified atoms in the current LIST 5 within
   the ranges specified on the SELECT directive.
   
   
   

**BONDED atoms**



   
   Similar to INCLUDE, except that non-included atoms can still be used as
   pivots.
   The arguments may be either a type of atom , or an atom specification of
   the 'type(serial)' or 'type(serial) UNTIL type(serial)' kind described
   elsewhere in the manual. Distances
   and angles are computed only to specified atoms in the current LIST 5 within
   the ranges specified on the SELECT directive.
   
   
   

**EXCLUDE atoms**



   
   This directive determines which atoms are excluded as pivots in the
   calculation.
   The arguments may be either a type of atom , or an atom specification of
   the 'type(serial)' or 'type(serial) UNTIL type(serial)' kind described
   elsewhere in the manual. If EXCLUDE directives alone are used, all
   atoms except those EXCLUDEd either explicitly or by
   type, are used as pivot atoms in the calculation.
   However, if both INCLUDE and EXCLUDE are used, the only atoms used in
   the calculation will be those INCLUDEd and not EXCLUDEd.
   
   
   
   

===================================
Distance-angles symmetry operations
===================================



Accompanying each atom in a distance or angle calculation
with  LIST  equal to  HIGH
are the symmetry operators that are necessary to bring the atom
into the correct position in the cell to make a contact with
the central atom.
These symmetry operations are divided into six parts, which are
indicated by five flags. These are explained in the section on Atomic
and Structural Parameters.

::


    \
    \ distances from 0 to 2.5
    \ angles from 0 to 2.0
    \ the e.s.d.'s of the distances and angles are calculated
    \ distances from each atom to all other atoms are printed
    \ transformed coordinates are printed
    \ the distances are sorted in order of increasing magnitude
    \
    \DISTANCES
    SELECT ALL=YES,COORD=YES,SORT=YES,RANGE=LIMITS
    LIMITS DMAX=2.5, AMAX=2.0
    E.S.D. YES
    END







::


    \DIST
    EXCLUDE ALL
    ONLY C(1) C(3) C(4)
    END









.. index:: VOIDS


.. index:: Locating voids in the model


=========================
Void Location  -  \\VOIDS
=========================


::


    \VOIDS INPUTLIST=
    DISTANCE
    TOLERANCE
    CONTACTS
    RESOLUTION
    END
   
    \VOIDS
    DISTANCE 2.2
    END






This utility searches for the asymmetric unit for points which lie
outside the known atoms. The 'radii' of the known atoms is independent
of type, and in an input value. A pseudo atom in inserted at every point
on a search grid outside the known atoms. The pseudo atoms are given a
'TYPE' dependant upon the number of neighbouring pseudo atoms. Atoms of
type R are at the core of large voids, type L are intermediate, and M at
the surface.



------------------
\\VOIDS INPUTLIST=
------------------

   

*INPUTLIST=*


   
   ::


            5   -  Default value
            10
   


   
   The default is to use the normal atom coordinate list.
   
   
   

**DISTANCE value**



   
   This sets the radii of the known atoms, default 2.5A.
   
   
   

**RESOLUTION value**



   
   This sets the sampling interval for the search grid, default 0.8 A.
   
   
   

**CONTACT value1 value2**



   
   This sets the number of pseudo-atom contacts required for the core
   and intermediate pseudo atoms. The defaults are 27 (R type atoms), 15
   (L type atoms). All other atoms are of type M.

   
   \\COLLECT and  \\REGROUP can be used to re-group the pseudo-atoms, and
   the augmented structure can be viewed in CAMERON.
   
   
   
   
   
   
.. index:: GEOMETRY

   
.. index:: Best lines and planes

   
.. index:: Planes

   
.. index:: Lines

   
.. index:: Inertial Tensor

   
.. index:: Centre of Gravity

   
.. index:: Librational tensor

   
.. index:: Analysis of thermal displacement parameters

   
.. index:: Principal atomic displacement directions


==================================================
TLS analysis, best planes and lines  -  \\GEOMETRY
==================================================


::


    \GEOMETRY INPUTLIST=
     ATOMS  W(1)  SPECIFICATION(1)  W(2)  SPECIFICATION(2) .
     PLANE
     LINE
     AXES
     TLS 
     EXECUTE
     EVALUATE  ATOM SPECIFICATIONS . . . .
     REPLACE ATOM SPECIFICATIONS . . .
     PUNCH
     SAVE
     DIHEDRAL  NP(1)  AND  NP(2)
     QUIT
     CENTRE   X=, Y=, Z=
     REJECT   NV=
     LIMITS   VALUE=   RATIO= 
     MODL L(11), L(22) L(33) L(23) L(13) L(12)
     MODT T(11), T(22) T(33) T(23) T(13) T(12)
     ZEROS
     DISTANCES  DL=   AL=
     ANGLES  AL=
     PLOT
     END





::


    \GEOMETRY
    ATOMS FIRST UNTIL LAST
    PLANE
    EXECUTE
    SAVE
    ATOMS FIRST UNTIL LAST
    TLS
    EXECUTE
    ANGLE 1 AND 2
    EXECUTE
    DISTANCES
    END








GEOMETRY is used for computing the following global derived 
parameters:

::


         Centroid (centre of gravity)
         Inertial Tensor
         Best Plane
         Best Line
         Shape Indices
         Principal Axes of adps
         Librational and Translational Thermal Tensors
         Dihedral Angles






It replaces the old \\MOLAX, \\AXES and \\ANISO commands



PLANE & LINE are used for computing the principal axes of inertia
through groups of atoms using  the routines described in
Computing Methods in Crystallography, edited by J. S. Rollett,
Pergamon Press, 1965, p67-68.


The  best  plane for a series of  N
atoms whose positions have varying reliability, such that they can
be assigned weights, w(1), w(2), . . . w(n), is defined as
that for which
the sum of the squares of the distances (in angstroms) of the
atoms from the plane, multiplied by the weights, w(i), of
the atomic positions, is a minimum.
Note that the normal to the 'worst plane' is the 'best line',
and if masses are used for weights, then the calculation gives the
principal inertial axes.


The atomic positions are taken from LIST 5, possibly modified by
symmetry information, to compute
inertial axes & deviations of atoms from  the planes or lines.


Each time a line or plane
is computed, the direction cosines of the relevent axis are stored as AXIS
number 'n'. The dihedral angles between these axes can be computed.
Three geometry indices are also
computed. The geometry is best described by the index closest to unity.
(Mingos,D.P.M & Rohl,A.L., J.Chem.Soc. Dalton Trans (1991) pp 3419 - 3425)


If the three principal axes are "big, medium, small", then



Spherical   = small/big
Cylindrical = 1-((medium+small)/(2.big))
discoidal   = 1-2.small/(big+medium)




TLS. This routine calculates the overall rigid-body
motion tensors T, L, S (Shoemaker and Trueblood, Acta Cryst. B24,
63, 1968) by a least-squares fit to the individual anisotropic
temperature factor components, together with librational corrections
to bond lengths and angles.


Shoemaker and Trueblood's conventions and reductions
are followed throughout; in particular, the trace of S, which is
indeterminant, is set to zero. The program therefore determines
20 overall tensor components - the upper triangles of T and L
together with the whole of S apart from S(33). (See also:
Johnson in Crystallographic Computing, 
ed R.Ahmed, Munksgaard, 1970, pp 207-219)


Even when the trace-of-S singularity has been removed, however,
the nature of the rigid body problem is such that ill-conditioned
and singular normal matrices are much more common than in
structure refinement and the program therefore proceeds via
the eigenvalues and eigenvectors of the normal matrix.  In most
cases the largest and smallest eigenvalues are output for
inspection, but if the ratio of these quantities is less than
the LIMITing RATIO, a full eigenvalue/vector listing is produced. Further,
if any eigenvalue is itself less than the LIMITing VALUE, the corresponding
parameter combination is set to zero, thus removing the near-
singularity. These actions can be modified by the use of the
LIMIT  and  REJECT  directives described below. If the TLS calcuation 
cannot be stabilised by means of these filters, the user can modify 
either T, L or S directly before applying the REPLACE or PUNCH 
commands. Though here is some danger in this, especially if the supposed rigid 
group is infact flexible, it may be preferable to using a model 
yielding negative vibrational or librational amplitudes.






The direction cosines of the 
principal axis of L are stored for use in inter-axis angle comutations.



Immediate execution of a directive can be forced by issuing an EXECUTE
directive.



.. _LIST20:

 
---------------------
\\GEOMETRY INPUTLIST=
---------------------

   

   

*INPUTLIST=*


   
   ::


            5   -  Default value
            10
   


   
   
   
   

**ATOMS  W(1)  SPECIFICATION(1)  W(2)  SPECIFICATION(2) .**



   
   This specifies atoms to be used in the calculation of the
   best plane.
   W(1)  Is the weight assigned to the atoms
   contained in the first atom specification,  W(2)  is the weight
   assigned to the second group of atoms, and so on.
   If  W(1)  is omitted, a default value of 1 is used,
   but any other  W(I)  term applies to all the atoms following it,
   until another  W  is found or the end of the directive is
   encountered.
   At least one  ATOM  directive must precede each  PLANE, LINE, TLS, AXES or
   PLOT directive.
   An ATOM directive will over-rule an immediately preceding ATOM directive. If an
   input line is not long enough for the full atom list, use CONTINUE.
   
   
   

**PLANE**



   
   This directive, (or  LINE, TLS, AXES, PLOT)
   must follow immediately after an  ATOM  directive and
   causes the calculation of a least squares best plane.
   
   
   

**LINE**



   
   This directive, (or  PLANE, TLS, AXES, PLOT)
   must follow immediately after an  ATOM  directive and
   causes the calculation of a least squares best line.
   
   
   

**AXES**



   
   This directive (like \\AXES) computes the principal axis lengths
   and directions for the atoms specified on a preceding ATOM directive.
   
   
   

**TLS**



   
   This causes the TLS calculation to be initiated. It MUST have been preceded
   by an ATOM directive.
   
   
   
   
   

**EXECUTE**



   
   This forces the execution of preceding directives.
   
   
   

**EVALUATE  ATOM SPECIFICATIONS . . . .**



   
   If present, this directive
   must appear after a  PLANE, LINE, TLS or PLOT directive,
   and causes the co-ordinates or adps of the atoms specified
   to be calculated and printed with respect to the current axial system.
   
   
   

**REPLACE ATOM SPECIFICATIONS . . .**



   
   if present, this directive
   must appear after a  PLANE, LINE, TLS or PLOT directive,
   and causes the co-ordinates or adps of the atoms specified to be modified so
   that they conform to the most recent geometry calculation.
   The LIST 5 in core is immediately
   updated, so that the new coordinates will be used for any subsequent
   computation. A LIST 5 is only written to the disc on a satisfactory exit from
   GEOMETRY.
   
   
   

**PUNCH**



   
   This directive causes the orthogonal coordinates of the atoms of any plane or
   line computed or EVALUATED in subsequent tasks to be output to the 'punch'
   file. For a TLS calculation, it causes  a restraint list to be output 
   to TLSREST.DAT
   
   
   

**SAVE**



   
   This directive is optional. 

   
   If it follows a PLANE, LINE or TLS directive, it
   causes the latest rotation matrix and CENTRE  to be stored in the 
   appropriate position in LIST 20. 

   
   If it
   follows an AXES directive, the direction cosines and centre if the ellipse FOR
   THE LAST ATOM are stored in LIST 20.

   
   A LIST 20 is only written to the disc on
   a satisfactory exit from ANISO.
   
   
   

**DIHEDRAL  NP(1)  AND  NP(2)**



   
   If present, thus directive must follow at least
   two  PLANE, LINE or TLS computations.
   It causes the program
   to calculate the angle between the axes with  serial numbers
   NP(1)  and  NP(2) .
   The   AND  must be present.
   
   
   
   
   

**QUIT**



   
   This directive abandons the calculation without modifying the disc LISTs.
   
   
   
   
   
   
   
   
   
   

**CENTRE   X=, Y=, Z=**



   
   This directive specifies the centre of libration,
   in crystal fractions, to be used in the original derivation of
   the overall motion tensors. The program derives and uses a unique
   origin at a later stage in the calculations. This directive
   is optional, the default centre being (0,0,0).
   If a centre of (0,0,0) is given or set by default, the program computes
   and uses the mean position of the given atoms, INCLUDING any which are
   isotropic, even though these are not used to compute TLS. The stored CENTRE
   is updated during TLS, and a second TLS computation may be performed using
   this new value as CENTRE. This may help stabilise certain forms of
   ill-conditioning.
   
   
   

**REJECT   NV=**



   
   Overrides normal action and sets the parameter combination
   corresponding to eigenvector number nv to zero.
   Eigenvectors are numbered in ascending order of their eigenvalues,
   so that nv
   is in the range 1 to 20 inclusive and will usually have been obtained
   from a full eigenvalue/vector listing produced in
   a previous run.
   
   
   

**LIMITS   VALUE=   RATIO=**



   
   If an eigenvalue is less than  VALUE  or its size is less than
   RATIO * (the next bigger), it is eliminated from the analysis.
   VALUE is currently .000001 and RATIO .01 .
   
   
   

**MODL L(11), L(22) L(33) L(23) L(13) L(12)**



   
   This directive enables the user to change the values of the L tensor before
   EVALUATING or REPLACING the Uij. The L tensor changed is that with 
   respect to the inertial axes and the input centre of libration. It does 
   not depend upon S. All six values must be given.
   
   
   

**MODT T(11), T(22) T(33) T(23) T(13) T(12)**



   
   This directive enables the user to change the values of the T tensor before
   EVALUATING or REPLACING the Uij. The T tensor changed is that with 
   respect to the inertial axes and the input centre of libration, NOT the 
   final tensor, since this involves an interaction with S and L.
   All six values must be given.
   
   
   
   
   
   DZEROS

   
   

   
   This directive enables the user to set the S tensor to zero before
   EVALUATING or REPLACING the Uij. It decouples T from L.
   

**DISTANCES  DL=   AL=**



   
   This directive calculates all interatomic distances less than
   DL angstroms with librational corrections. If this directive is omitted,
   no distances are calculated; if DL is absent, a default value of 1.8 is
   inserted. If AL is present, angles between atoms separated by less than AL
   angstroms are computed.
   
   
   

**ANGLES  AL=**



   
   This directive calculates angles between all bonds less than
   AL angstroms. If this directive is omitted, no angles are calculated;
   if AL is absent, a default value of 1.8 is inserted.

   
   

   
   
   ************************* WARNING *************************
   
   

   
   The directive DISTANCE may only be
   followed by ATOM, EXECUTE, or END.
   
   
   

**PLOT**



   
   This obsolete directive produces a join-the-dots diagram
   on the monitor or printer. It (or  PLANE, LINE, TLS, AXES)
   must follow immediately after an  ATOM  directive and
   causes the calculation of inertial axes.
   Details of the computation are suppressed on the Monitor,
   but a line drawing projected onto the best plane is produced.
   MOLAX  Can thus be used as a means of displaying some or all
   of the atoms in a structure.
   
   
   
   ::


         Examples:
       
        These instructions compute a plane
        involving n(1),n(2),n(3) and c(1), and
        prints the co-ordinates of all the atoms with
        respect to this plane.  The positions of the
        nitrogen atoms have double weight
       
       \GEOMETRY
       ATOMS 2 N(1) UNTIL N(3)  1 C(1) C(2)
       PLANE
       EVALUATE ALL
       
        These instructions calculate another plane,
        printing only the co-ordinates of c(5) with respect to
        the second plane.  The angle between the two planes
        is then calculated
       
       ATOMS C(1) S(1) N(1)
       PLANE
       EVALUATE C(5)
       DIHEDRAL 1 AND 2
       END
       
       
        These instructions compute a TLS tensor for the specified atoms
        and then set up restraints to encourage the Uij to conform to a
        rigid body.  You might want to tighten the esd in TLSREST.dat to 0.005.
       
       \GEOM                                                                           
       ATOM ALL
       TLS
       PUNCH
       EVAL ALL
       EX
       END
       \LIST 16                                                                        
       \USE TLSREST.DAT                                                                
       END
   


   
   
   
   
   
   
   
.. index:: TORSION

   
.. index:: Torsion angles


============================
Torsion angles  -  \\TORSION
============================


::


    \TORSION INPUTLIST=
    ATOMS  SPECIFICATIONS
    PUBLICATION  PRINT= LEVEL=
    END
   
    \TORSION
    ATOM C(1) C(2) C(3) C(4)
    END






Calculation of the torsion angles for atoms i,j,k,l. 
The torsion angle about the bond j-k
is the angle the bond i-j is rotated about j-k to bring it into 
coincidence with k-l.
It is positive when  the rotation is
clockwise on looking from j to k.


The program uses atomic positions taken from
LIST 5.  These can be
modified by the space group symmetry operators stored in LIST 2 (space
group information, see section :ref:`LIST02`)


EDSs (SUs) are computed by the method of Nardelli (using code given 
to us from his program PARST) if only average atomic esds are 
avaialble.  If the full VcV matrix is avaiable, they are computed by 
the method of Schaik et al (R. van Schaik, H Berendsen, A Torda & W 
Gunsteren, J. Mol. Biol. (1993) 234, 751-762. The paper by U. Shmueli, 
Acta Cryst (1974) A30, 848-849 explains the need for the full vcv matrix 
and the effect of symmetry. The singularity in his equations (6) when tau is 
0 or 180 is circumvented in Schaiks formulation (which is singular if 
atoms j and k are coincident)



--------------------
\\TORSION INPUTLIST=
--------------------

   

*INPUTLIST*


   
   ::


            5   -  Default value
            10
   


   
   
   
   

**ATOMS  SPECIFICATIONS**



   
   This directive specifies atoms that are to be used in the calculation
   of the torsion angle. More than one  ATOMS  directive can be given. Each
   directive must define at least four atoms, the torsion angle being
   computed with respect to the first three atoms and each of the
   subsequent ones.
   
   
   

**PUBLICATION  PRINT=**


   
   The parameter PRINT controls the publication listing, which is sent to 
   the file open on the CRYSTALS PUNCH unit.
   
   ::


            NO   -  DEFAULT.  There is no publication listing
            YES    There is a publication listing sent to the PUNCH file
            CIF    The listing is in CIF format
   


   
   

**LEVEL=**


   
   If LEVEL is HIGH, the VcV marix of the atoms in each torsion angle
   is printed.
   
   
   
   ::


       Example.
       \ the torsion angle about C(3)-C(4) is calculated
       \ two torsion angles about C(4)-C(5) are calculated
       \
       \TORSION
       ATOMS N(2) C(3) C(4) C(5)
       ATOMS C(3) C(4) C(5) C(6) O(1,2,2)
       END
   


   
   
   
   
   
.. index:: TON

   
.. index:: Hooft-Straver-Spek


================================
Absolute Configuration  -  \\TON
================================


::


    \TON 
    END
   






Compute the Hooft-Straver-Spek parameter for comparisonm with the 
Flack parameter



-----
\\TON
-----

   
   

   
   This instruction evaluates a function of (Fo+h - Fo-h) and  (Fo+h - Fo-h)
   for all Friedel pairs. It uses LIST 7, which must be sorted to that 
   Friedel pairs are adjacent and with the same index signs, and with a 
   flag to indicate if the sign has been changed in 'phase'.

   
   The data is most conveniently prepared useing the SCRIPT TON towards 
   the end of a refinement.
   
   
   
   
   
   
   
   
   
   
   
   
   
.. index:: PARAMETERS

   
.. index:: Publication tables of atomic parameters


=============================================================
Publication listing of the atomic parameters  -  \\PARAMETERS
=============================================================


::


    \PARAMETERS
    LAYOUT INSET= ATOM= DOUBLE= CHOOSE= FLOAT= NCHAR= NLINE= LISTAXES= ESD=
    COORDINATES NCHAR= NDECIMAL= SELECT= TYPE= DISPLAY= PRINT= PUNCH=
    U'S NCHAR= NDEC= SELECT= TYPE= DISPLAY= PRINT= PUNCH=
    END



::


    \PARAMETERS
    LAYOUT ATOM-NAME=6,DOUBLE=YES
    END






This routine sends the atomic parameters to the PUNCH file  in a suitable
format  for publication or binding into a thesis.  As well as the current
atomic parameters in LIST 5, the estimated  standard deviations derived from
the least squares normal matrix are also  printed.
**THIS** **ROUTINE** **WILL** **NOT** **WORK** if LIST
5  is modified *in* *any* *way* since the last round of
refinement. If any changes, including  renaming, are made, a further round of
refinement must be done. If you wish  to preserve parameter values,
and create a valid matrix
without changing the parameter values, compute a refinement cycle but set
all the shifts to zero.

::


         \SFLS
         REFINE
         SHIFT GENERAL = 0.0
         END




The output is in two halves, the first
containing  the positional coordinates and any isotropic temperature factors,
and the  second containing all the anisotropic temperature parameters.


For the first part, a page is split into 6 separate  fields.
The first field
is blank, and is an offset so that the information  is  centred on
the page.  The remaining fields contain the atom type and serial
number, the  three positional parameters, and a temperature factor.
This will be the value of U(iso) with its e.s.d for isotropic atoms,
otherwise U(equiv), without an e.s.d, for anisotropic atoms.
U(equiv) **is** **not** simply related to the
diagonal elements of U(aniso), and may be computed as either the
arithmetic or geometric mean of the principal axes of the ellipsoid.
See \\SET UEQUIV in the chapter on IMMEDIATE commands.
The width of each type of field may be altered by the user, using
respectively the  INSET ,  ATOM-NAME , and  NCHARACTER  parameters.  The
default length
of a page of this type of output is that required for A4 paper.


The second part contains the anisotropic temperature factors, and each page
is split into eight fields.
As for the atomic coordinates, the first field is blank and represents
an offset.
The second field contains the atom type and serial number, and
the remaining six fields contain the components of the anisotropic
temperature factors.
The width of each type of field may be adjusted by the user, using
respectively the  INSET ,  ATOM-NAME  and  NCHARACTER  parameters.
If a different value for  INSET  or  ATOM-NAME  is required in the
first and second parts of the output, the job must be run twice.
Depending upon the width across the page, the second part of the output
occupies one sheet of A4 paper either across the page or down the page.


For both types of output, the user can select double spacing
down the page with the  DOUBLE  parameter.
Similarly for each of the numeric fields, the user can choose the number
of decimal places to be printed
(the  NDECIMAL  parameter),
and whether the numbers are printed as integers or in floating point
with a decimal point.
(The  FLOATING  parameter).
The e.s.d.'s are printed to the same accuracy as the atomic parameters,
so that if the chosen field is too small and an e.s.d. appears to be
zero, it will be omitted in exactly the same way as for a parameter
that has not been refined.
A parameter printed with 4 decimal places might thus appear as :

::


    0.0123(4)
    OR
       123(4)




Depending upon the format.
In either case, the numbers are right justified in their field.


As an alternative to the user selecting the number of decimal
places that should be printed, it is possible to get the program
to choose the number of decimal places required for each parameter
automatically.
(The  CHOOSE  parameter).
If the parameters are to be printed in floating point, the number
of decimal places is chosen so that the e.s.d. Can be represented
as a one digit number in the last decimal place.
For numbers that are to be printed as integers, the field used
is never less than that given by the  NDECIMAL  parameter.
If the required field is larger than that defined by these 
s,
a decimal point is inserted and the required number of extra digits
is output.
For example, if the number of decimal places required is four, but the e.s.d.
is too small, it would appear as :

::


    0.12345(6)
    OR
     1234.5(6)




Depending upon whether floating point or integer output was required.
For either type, if the parameter has not been refined, the number of
decimal places is that given by the  NDECIMAL  instruction.


Since this routine prints the e.s.d.'s, it is vital that the least squares
matrix (LIST 11, see section :ref:`LIST11`) belongs to the current 
LIST 5 (the model parameters). If LIST 5 has been modified
in any way since the last Least Squares, this routine will abort.


When anisotropic atoms are present in LIST 5, U[EQUIV] is calculated
according to the current setting of \\SET UEQUIV.





------------
\\PARAMETERS
------------


   
   This command initiates the routines for printing of the atomic
   parameters in a suitable format for publication.
   
   
   

**LAYOUT= INSET= ATOM= DOUBLE= CHOOSE= FLOAT= NCHAR= NLINE= LISTAXES= ESD=**



   
   This directive defines how the atomic parameters, both positional
   and thermal, are to be laid out on the page.
   

*INSET*


   This parameter sets the number of blank spaces on each line before the
   atom type and serial number. If this parameter is omitted
   a default value of 1 is assumed.
   

*ATOM-NAME*


   This parameter sets the width of the field that contains the atom
   type and serial number.
   The characters are left justified in the field, and the format is
   as follows :
   
   
   
   TYPE(SERIAL)
   
   
   The serial number is printed as an integer, and the unoccupied
   spaces are filled with blanks.
   If this parameter is omitted, a default value of 6 is assumed.
   

*DOUBLE*


   This parameter has two possible values :
   
   
   
   NO   -  DEFAULT VALUE
   
   YES
   
   
   If  DOUBLE  is  YES  each line of parameters is double spaced.
   The default option if this parameter is omitted is single
   spacing, with no interleaving blank lines.
   

*CHOOSE*


   This parameter has two possible values :
   
   
   
   NO
   
   YES  -  DEFAULT VALUE
   
   
   
   If  CHOOSE  is  YES  the program chooses the number of decimal places that
   need to be printed for each parameter, depending upon its e.s.d..
   The format of the output depends upon whether a decimal point
   is being used, as explained above.
   

*FLOATING*


   This parameter has two possible values :
   
   
   
   YES  -  DEFAULT VALUE
   
   NO
   
   
   If  FLOATING  is  NO , the parameters are printed as integers,
   with an accuracy given either by the  NDECIMAL  parameters
   to the directives  COORDINATES  and "U'S, or by the 'CHOOSE' parameter.
   parameter.
   

*NCHARACTER*


   This parameter indicates the total number of printing positions
   on the output device.
   If this parameter is omitted, a default value of 118 is assumed.
   
   

*NLINE*


   This parameter indicates the total number of lines on the
   on the output media. Set a very lartge value (1000) to get continuous
   output.
   
   

*LISTAXES*


   This parameter can have two values
   
   
   
   YES
   
   NO   -  DEFAULT VALUE
   
   
   If the value is YES the principal axes of the temperature factors
   are printed.
   
   
   

*ESDS*


   This parameter can take 3 values
   
   
   
   NO
   
   YES  -  DEFAULT VALUE
   
   EXCLRH
   
   
   EXCLRH inhibits printing the e.s.ds for riding hydrogen atoms
   
   
   

**COORDINATES NCHAR= NDECIMAL= SELECT= TYPE= DISPLAY= PRINT= PUNCH=**



   
   This directive defines how the positional coordinates are to be
   set out on the page.
   

*NCHARACTER*


   This parameter sets the width of the field that contains the
   positional coordinates. The characters are right
   justified in the field, and if this parameter is omitted,
   a default value of 14 is assumed.
   

*NDECIMAL*


   This parameter sets the number of decimal places to be printed for
   the positional parameters.
   It may be partially or completely overriden by the  CHOOSE
   parameter, depending upon the format of the output.
   If this parameter is omitted, a default value of 4 is assumed.
   

*SELECT*


   This parameter selects the kinds of data to be printed, and
   can have five values.
   
   
   
   ALL     - Default. All atoms are printed.
   
   NONE    - No atoms are printed.
   
   ONLY    - Only atoms with TYPEs given on a TYPE directive are printed.
   
   EXCLUDE - Atoms with TYPEs given on a TYPE directive are not printed.
   
   SEPARATE- Atoms with TYPEs given on a TYPE directive are printed separately
   
   
   

*TYPE*


   
   
   Used in conjunction with SELECT to determine which atom types to
   INCLUDE,EXCLUDE or SEPARATE. TYPE is ignored if SELECT is ALL or NONE.
   Its default value is 'H'.
   

*DISPLAY*


   This parameter has two possible values
   
   ::


       NO   No output is displayed on the terminal.
       YES  Output is displayed on the terminal.
   


   
   

*PRINT*


   This parameter has two possible values
   
   ::


       NO       No output is sent to the listing file
       YES      Output is sent to the listing file
   


   
   

*PUNCH*


   This parameter has three possible values
   
   ::


       NO       No output is sent to the punch file
       YES      Output is sent to the punch file
       CIF      Output is in CIF format
   


   
   
   
   

**U'S NCHAR= NDEC= SELECT= TYPE= DISPLAY= PRINT= PUNCH=**



   
   This directive defines how the thermal parameter are to be
   set out on the page.
   

*NCHARACTER*


   This parameter sets the width of the field that contains the thermal
   parameters. The characters are right justified in the field, and
   if this parameter is omitted, a default value of 11 is assumed.
   

*NDECIMAL*


   This parameter sets the number of decimal places to be printed for
   the thermal parameters.
   If this parameter is omitted, a default value of 4 is assumed.
   

*SELECT*


   This parameter selects the kinds of data to be printed, and
   can have five values.
   
   
   
   ALL     - Default. All atoms are printed.
   
   NONE    - No atoms are printed.
   
   ONLY    - Only atoms with TYPEs given on a TYPE directive are printed.
   
   EXCLUDE - Atoms with TYPEs given on a TYPE directive are not printed.
   
   SEPARATE- Atoms with TYPEs given on a TYPE directive are printed separately
   
   
   

*TYPE*


   
   
   Used in conjunction with SELECT to determine which atom types to
   INCLUDE,EXCLUDE or SEPARATE. TYPE is ignored if SELECT is ALL or NONE.
   Its default value is 'H'.
   

*MONITOR*


   This parameter has two possible values
   
   ::


       OFF   No output is displayed on the terminal.
       HIGH  Output is displayed on the terminal.
   


   
   

*PRINT*


   This parameter has two possible values
   
   ::


       NO       No output is sent to the listing file
       YES      Output is sent to the listing file
   


   
   

*PUNCH*


   This parameter has three possible values
   
   ::


       NO       No output is sent to the punch file
       YES      Output is sent to the punch file
       CIF      Output is in CIF format
   


   
   
.. index:: REFLECTIONS

   
.. index:: Publication tables of reflection data


.. _REFLECTIONS:

 
=======================================================
Publication listing of reflection data  - \\REFLECTIONS
=======================================================




::


   \REFLECTIONS INPUT=
   LAYOUT NCOLUMNS= NLINES= INSET= NSPACE= SCALE= NCHARACTER=
   OUTPUT PRINT= PUNCH= LIST28=
   END






This routine prints the reflection data in LIST 6 (section :ref:`LIST06`) 
in a suitable format
for publication or binding into a thesis. The information printed falls
into one or more columns, each of which contains h, k, l, /Fo/, /Fc/, and the
phase angle in degrees.
Each column is 18 characters wide. Although the user has no control
over the contents of each column, it is possible to vary the number of
blank spaces at the start of each line, the number of columns across the
page,  the number of spaces between successive columns, and the number of
lines per page. (The  INSET ,  NCOLUMNS ,  NSPACE  and  NLINES  parameters,
respectively).
/Fo/ and /Fc/ are both put on the same scale of /Fc/, using the scale factor
in LIST 5, and both these two numbers may be modified by a scaling constant
before they are printed. (The  SCALE  parameter). However, all the values of
both /Fo/ and /Fc/ must be less than 10000 when they are printed.


LIST 28 is used for checking whether or not to print a reflection. Remember
that if LIST 28 was used to reject some reflections when structure factors
were last calculated, removing these restrictions before printing LIST 6
will mean that some reflections will have incorrect values of Fc and phase.

--------------------
\\REFLECTIONS INPUT=
--------------------

   

*INPUT*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   
   
   
   

**LAYOUT NCOLUMNS= NLINES= INSET= NSPACE= SCALE= NCHARACTER=**



   
   This directive defines how the reflection data is to be printed.
   

*NCOLUMNS=*


   This parameter indicates the number of columns of reflection data to be
   printed across the page. If this parameter is omitted, a default value of
   3 is assumed.
   

*NLINES=*


   This parameter indicates how many lines should be on each page of output.
   If this parameter is omitted a default value of 52 is assumed.
   

*INSET=*


   This parameter indicates how many blank spaces should be inset at
   the beginning of each line. If this parameter is omitted a default value
   of 30 is assumed.
   

*NSPACE=*


   This parameter indicates the number of spaces separating successive
   columns across the page. If this parameter is omitted a default value
   of 3 is assumed, which means that each column occupies 21
   characters across the page.
   

*SCALE=*


   This parameter indicates the scaling constant by which /Fo/ and /Fc/
   should be multiplied before they are printed,
   after they have been put on the same scale (the scale of /Fc/).
   If this parameter is omitted, a default value of 10 is assumed.
   

*NCHARACTER=*


   This parameter indicates the total number of printing positions
   on the output device.
   If this parameter is omitted, a default value of 120 is assumed.
   

**OUTPUT PRINT PUNCH LIST28**



   
   This directive defines where the reflection data is to be printed.
   

*PRINT=*


   This has two allowed values :-
   
   ::


       NO       No output is sent to the listing file
       YES      Output is sent to the listing file
   


   
   

*PUNCH=*


   This has two allowed values :-
   
   ::


            NO       No output is sent to the punch file
            YES      Output is sent to the punch file
   


   
   
   
   
.. index:: SUMMARY

   
.. index:: Summary of data


=================================
Summary of data lists - \\SUMMARY
=================================


::


    \SUMMARY OF= TYPE= LEVEL=
   
    \SUMMARY LIST 5 HIGH
    END
    \SUMMARY EVERYTHING
    END






This command produces a summary on the terminal of the contents of a
list. Use \\PRINT if you need full details.



--------------------------
\\SUMMARY OF= TYPE= LEVEL=
--------------------------

   

*OF*


   
   LIST         Default, also requires TYPE to be set
   EVERYTHING
   
   
   The value EVERYTHING generates a summary of all LISTS.
   

*TYPE*


   This parameter requires a list type number if the previous parameter
   was 'LIST"
   

*LEVEL*


   Some lists may be listed in more or less detail.
   
   OFF
   LOW
   MEDIUM    Default
   HIGH
   
   
   

**\\SUMMARY 6**


   Unlike all the other SUMMARIES, which only generate readable output,
   SUMMARY 6 computes the conventional R on the basis of the current Fo, Fc
   and LIST 28 (section :ref:`LIST28`), and updates the value stored in 
   LIST 6 (section :ref:`LIST06`) 
   and LIST30 (section :ref:`LIST30`). The
   weighted R is not affected.
   
   
   
   
   
   
.. index:: TONSPEK

   
.. index:: Estimation of Absolute configuration
 

.. _TONSPEK:

 
=================================================
Estimation of Absolute configuration - \\TONSPEK 
=================================================





::


   \TONSPEK INPUT= TYPE= PLOT= PUNCH= FILTER1= ... FILTER5= WEIGHT=
   END






This routine contains code kindly donated by Ton Spek for the 
computation of the Hooft 'y' parameter and probabiliies. 
Rob W. W. Hooft, Leo H. Straver and Anthony L. Spek, 
J. Appl. Cryst. (2008). 41, 96-103.  It requires the current LIST 6 to 
be converted to a LIST 7 in which Friedel pairs are adjacent and in 
which Fc has been computed with the Flack 'x' parameter set to zero.


The pre-preparation for using this routine has been packaged into a 
script available from the Analyse menu.  The current value of the 
Flack parameter should already be stored in LIST 30.



-----------------------------------------------------------------
\\TONSPEK INPUT= TYPE= PLOT= PUNCH= FILTER1= ... FILTER5= WEIGHT=
-----------------------------------------------------------------

   

*INPUT=*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   
   
   
   

*TYPE=*


   The computations can be carried out using the observed and computed
   Bijvoet differences, or the observed and computed Parsons Quotients.
   
   
   ::


            DODC      Bijvoet Differences
            QOQC      Parsons Quotients
   



*PLOT=*


   When used from the GUI causes the various graphs to be displayed 
   ::


            YES     Default value
            NO      
   


   
   

*PUNCH=*


   Controls output to the punch file, BFILE.CPH
   
   
   ::


            NONE           Default
            TABLE          Table of all the Bijvoet pairs.
            RESTRAINT      List of restriants suitable for adding to a LIST 16.
            GRAPH          Values suitable for input to an external program
            SUMMARY        One-line summary of the various parameters and sus.
   


   
   

*FILTER1=*


   The minimum acceptable value of Dcalc/sigma(Dobs).  This is the minimum 
   'ideal' theoretical signal:noise ratio.  The default value of 0.5 can be 
   increased for materials with a large Friedif, or may need to be reduced 
   for small Freidif.
   

*FILTER2=*


   The minimum acceptable value for the ration of the average of the observed Bijvoet 
   pairs to the su of the average, default is 1.0
   

*FILTER3=*


   The observed Bijvoet differences muse bt less than FILTER3 times the 
   maximum calculated difference, default value is 2.0
   

*FILTER4=*


   Minimum accaptable weight modifier from the Blessing algorithm.
   

*FILTER5=*


   Maximum values of Max(Ao,Ac) / Min (Ao,Ac).  Used to filter out 
   reflections where are serious discrepancies between the observed and calculated 
   structure factors. Default value is 2.5.
   
   
   
   
   
   
   
   
   
.. index:: CIF


=================
CIF lists - \\CIF
=================

Data can be produced in CIF format for direct deposition at CCDC or
submission to journals. The required information is taken from several
lists, including LIST 30 (see section :ref:`LIST30`). F000, Mu etc are also 
computed and inserted in LIST 30.



-----
\\CIF
-----


   
   There are no qualifiers.

   
   See \\PARAMETERS and \\REFLECTIONS for the CIF printing of parameters
   and reflections .
   
   
   

**CheckCIF**


   CheckCIF and other validators are continuously updated to meet the 
   changing needs of the community. It is unlikely that a CRYSTALS .cif 
   will pass all checks first time, and edits may be necessary to 
   accommodate special situations. Some of these have been foreseen, and the 
   .cif contains possible alternative texts as 'comments'. These can be 
   found by searching for the text 'choose'.
   

**References**


   The SCRIPT directory contains two text files that contain information 
   copied into the cif file. The user may edit them.
   

*Refcif.dat*


   This file is copied in its entirety to the head of the cif file. If 
   it is edited, care must be taken to follow the rules about text 
   delimiters.
   

*Reftab*


   This is a loosely formatted file containing the references to be 
   transcribed into the cif. 

   
   Every reference is composed of 2 parts - a short text used as a data 
   item in the cif, and the full reference. The two parts must be kept 
   together, be separated from each other by a blank line, and be separated 
   from any other item by a blank line. 
   ::


            n  a four-digit number giving the number of references to follow. 
               Other text on the line is ignored.
      Next items repeated 'n' times:
            m  a three digit number preceded by a 'hash' symbol used as an 
               identifier for the reference. The numbers must be unique, not 
               necessarily in any order, with the largest one equal to 'n'
            
            The full reference. References are put in the file in alphabetic 
            order.
   


   
   Items 001 to 004 are associated with the keywords 'unknown' for the 
   corresponding items in LIST 30 (see section :ref:`LIST30`), and thus 
   enable the user to insert 
   their own references. Don't forget to move them to their correct 
   alphabetical place.
   
   

**e.s.d.s**


   The esds output in CIF files try to follow the 'Rule of 19', as
   requested by Acta Cryst.
   Syd Hall, former Editor for Acta C, summarised the rule as follows:

   
   
   'This method of handling the su (esd) values has been in force
   with Acta since about 1984 apparently. In my time it came up for
   discussion about two years ago (1996) and after much to-ing and fro-ing
   it was readopted as the preferred level of precision for su's.

   
   
   What it means is as follows....
   ::


      (1) if one adopts esd values to one digit precision (rule of 9) the values
      
            5.548(1)      1.453(2)  3.921(3)  1.2287(8)  are acceptable.
      
      (2) if one permits two digits precision with a limit of 19 (rule of 19)...
      
            5.5483(9)     1.4532(16)  3.921(3)  1.2287(8)  are acceptable.
      
      (3) if one permits two digits precision with a limit of 29 (rule of 29)...
      
            5.5483(9)     1.4532(16)  3.9214(28)  1.2287(8)  are acceptable.
      
   


   
   The object of this approach is to provide a more consistent distribution
   of precision across all values. These particular matters are not really
   my responsibility but we try to conform to recommendation of the
   nomenclature people. This is one such occasion.'
   
   
   
.. index:: ADDARC


.. _addarc:

 
=============================
Adding Archive files - ADDARC
=============================






---------------
ADDARC filename
---------------

   This command is usually called from SCRIPTS and inserts the contents
   of the file 'filename' into the current cif file, usually 'publish.cif'
   
   
   
   
   
   
   
   
   
   
   
   
   
.. index:: CAMERON


.. _grcameron:

 
==================
Graphics - CAMERON
==================






-------
CAMERON
-------

   The graphics module CAMERON is part of the graphical user interface, and can
   only be started from the GUI. Like CRYSTALS, a sub-set of the possible
   commands are packaged up into menus, but the advanced full potential
   is still available from the command line. There is a separate guide for
   CAMERON
   

   
   On exit from CAMERON the current image of the structure is padded back to
   CRYSTALS in the file  CAMERON.L5.
   This contains **all** and **only** the atoms last displayed by CAMERON.
   Be careful -
   it could be a packing diagram!
   
   
   
   
   
   