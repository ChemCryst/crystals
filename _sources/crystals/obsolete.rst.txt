.. toctree::
   :maxdepth: 1
   :caption: Contents:

   
   
   

*****************
Obsolete Commands
*****************


.. index:: Obsolete commands


=================
Obsolete Commands
=================



The following Commands were available in earlier versions of CRYSTALS. 
They are retained for compatibility reasons, but have been suppressed 
or superceeded  by new commands.


::


   
    Least squares best planes                      MOLAX
    Thermal displacement parameter analysis        ANISO
    Principal atomic displacement directions       AXES
    Structure factors for a group of trial models  TRIAL
   





.. index:: MOLAX


.. index:: Best lines and planes


===============================================
Least squares best planes and lines  -  \\MOLAX
===============================================


::


    \MOLAX INPUTLIST=
    EXECUTE
    PUNCH
    ATOMS  W(1)  SPECIFICATION(1)  W(2)  SPECIFICATION(2) .
    PLOT
    PLANE
    LINE
    ANGLE  NP(1)  AND  NP(2)
    EVALUATE  ATOM SPECIFICATIONS . . . .
    REPLACE ATOM SPECIFICATIONS . . .
    SAVE
    QUIT
    END





::


    \MOLAX
    ATOM FIRST UNTIL LAST
    PLANE
    SAVE
    END






MOLAX is used for computing the principal axes of inertia
through groups of atoms using  the routines described in
Computing Methods in Crystallography, edited by J. S. Rollett,
Pergamon Press, 1965, p67-68.
It can be used to compute best lines and planes, and produce simple line
printer plots of the atoms.


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
inertial axes, deviations of atoms from  the planes or lines, and the
angles between normals to these planes or axes. Shape indices (Mingos M.P.
and Rohl A.L. J Chem Soc Dalton Trans (1991) 3419) are computed.


Each time a line or plane
is computed, the direction cosines of the relevent axis are stored as AXIS
number 'n'. The angles between these axes can be computed.
Three geometry indices are also
computed. The geometry is best described by the index closest to unity.
(Mingos,D.P.M & Rohl,A.L., J.Chwm.Soc. Dalton Trans (1991) pp 3419 - 3425)


Immediate execution of a directive can be forced by issuing an EXECUTE
directive.



------------------
\\MOLAX INPUTLIST=
------------------

   

*INPUTLIST=*


   
   ::


            5   -  Default value
            10
   


   
   
   
   

**EXECUTE**



   
   This forces the execution of preceding directives.
   
   
   

**PUNCH**



   
   This directive causes the orthogonal coordinates of the atoms of any plane or
   line computed in following tasks to be output to the 'punch' file.
   
   
   

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
   At least one  ATOM  directive must precede each  PLANE  or PLOT directive.
   An ATOM directive will over-rule an immediately preceding ATOM directive. If an
   input line is not long enough for the full atom list, use CONTINUE.
   
   
   

**PUNCH**



   
   This directive causes the orthogonal coordinates of the atoms of any plane or
   line computed or EVALUATED in the current task to be output to the 'punch'
   file.
   
   
   

**PLOT**



   
   This directive, (or  PLANE or LINE)
   must follow immediately after an  ATOM  directive and
   causes the calculation of inertial axes.
   Details of the computation are suppressed on the Monitor,
   but a line drawing projected onto the best plane is produced.
   MOLAX  Can thus be used as a means of displaying some or all
   of the atoms in a structure.
   
   
   

**PLANE**



   
   This directive, (or  LINE or PLOT)
   must follow immediately after an  ATOM  directive and
   causes the calculation of a least squares best plane.
   
   
   

**LINE**



   
   This directive, (or  PLANE or PLOT)
   must follow immediately after an  ATOM  directive and
   causes the calculation of a least squares best line.
   
   
   

**ANGLE  NP(1)  AND  NP(2)**



   
   If present, thus directive must follow at least
   two  ATOMS/PLANE (ATOMS/LINE, ATOMS/PLOT) directive sequences.
   It causes the program
   to calculate the angle between the axes with  serial numbers
   NP(1)  and  NP(2) .
   The   AND  must be present.
   
   
   

**EVALUATE  ATOM SPECIFICATIONS . . . .**



   
   If present, this directive
   must appear after a  PLANE, LINE or PLOT directive,
   and causes the co-ordinates of the atoms specified
   to be calculated and printed with respect to the least squares axial system.
   
   
   

**REPLACE ATOM SPECIFICATIONS . . .**



   
   if present, this directive
   must appear after a  PLANE, LINE or PLOT directive,
   and causes the co-ordinates of the atoms specified to be modified so that
   they lie on the previously defined plane. The LIST 5 in core is immediately
   updated, so that the new coordinates will be used for any subsequent
   computation. A LIST 5 is only written to the disc on a satisfactory exit from
   MOLAX.
   
   
   

**SAVE**



   
   This directive causes the latest plane defining matrix and
   vector to be stored in LIST 20. A LIST 20 is only written to the disc on
   a satisfactory exit from MOLAX.
   
   
   

**QUIT**



   
   This directive abandons the calculation without modifying the disc LISTs.
   ::


       \
       \ these instructions define a plane
       \ involving n(1),n(2),c(1),c(2) and n(3) and
       \ prints the co-ordinates of all the atoms with
       \ respect to this plane.  the positions of the
       \ nitrogen atoms have double weight
       \
       \MOLAX
       ATOMS 2 N(1) UNTIL N(3)  1 C(1) C(2)
       PLANE
       EVALUATE ALL
       \
       \ this set of directives also calculates another plane,
       \ printing only the co-ordinates of c(5) with respect to
       \ the second plane.  the angle between the two planes
       \ is then calculated
       \
       ATOMS C(1) S(1) N(1)
       PLANE
       EVALUATE C(5)
       ANGLE 1 AND 2
       END
   


   
   
   
   
.. index:: ANISO

   
.. index:: Analysis of thermal displacement parameters


===================================================
Thermal displacement parameter analysis  -  \\ANISO
===================================================


::


    \ANISO INPUTLIST
    EXECUTE
    ATOMS   WEIGHT ATOM SPECIFICATIONS
    CENTRE   X=, Y=, Z=
    REJECT   NV=
    LIMITS   VALUE=   RATIO=
    TLS
    EVALUATE ATOM SPECIFICATIONS
    REPLACE ATOM SPECIFICATIONS . . .
    SAVE
    QUIT
    AXES
    DISTANCES  DL=   AL=
    ANGLES  AL=
    END





::


    \ANISO
    ATOM C(1) UNTIL C(6)
    TLS
    SAVE
    END






This routine calculates the overall rigid-body
motion tensors T, L, S (Shoemaker and Trueblood, Acta Cryst. B24,
63, 1968) by a least-squares fit to the individual anisotropic
temperature factor components, together with librational corrections
to bond lengths and angles.


Shoemaker and Trueblood's conventions and reductions
are followed throughout; in particular, the trace of S, which is
indeterminant, is set to zero. The program therefore determines
20 overall tensor components - the upper triangles of T and L
together with the whole of S apart from S(33).


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
LIMIT  and  REJECT  directives described below.



-----------------
\\ANISO INPUTLIST
-----------------

   

*INPUTLIST*


   
   ::


            5   -  Default value
            10
   


   
   
   
   

**EXECUTE**



   
   This causes immediate execution of the previous directive, otherwise
   directives are executed on input of a new directive (or END).
   
   
   

**ATOMS   WEIGHT ATOM SPECIFICATIONS**



   
   This parameter specifies the set of atoms to be used for the following
   calculation.

   
   WEIGHT. The default weight of 1.0 is used for all atoms except those
   following a WEIGHT value. Any decimal number on the ATOM directive 
   is taken as a weight and applied to any following atoms. 
   A subsequent atom directive over rules all previous atom directives.
   If the full atom specification cannot be got on one directive, use CONTINUE.
   The atom specifications are in the usual form with symmetry
   operators and  UNTIL  sequences permitted. An ATOM directive resets the CENTRE to
   its default value, 0,0,0.
   
   
   

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
   
   
   

**TLS**



   
   This causes the TLS calculation to be initiated. It MUST have been preceded
   by an ATOM directive.
   
   
   

**EVALUATE ATOM SPECIFICATIONS**



   
   This may be used after a successfull TLS calculation to list Ucalcs for
   the specified atoms. The atom list is not modified.
   
   
   

**REPLACE ATOM SPECIFICATIONS . . .**



   
   If present, his directive
   must appear after a TLS directive,
   and causes the co-ordinates of the atoms specified to be modified so that
   they have U's defined by the current T, L, and S matrices.
   The LIST 5 in core is immediately
   updated, so that the new coordinates will be used for any subsequent
   computation if a new ATOM directive is issued.
   The updated LIST 5 is only written to the disc on a satisfactory exit from
   ANISO.
   
   
   

**SAVE**



   
   This directive is optional. If it follows a TLS directive, it
   causes the latest L matrix and CENTRE  to be stored in LIST 20. If it
   follows an AXES directive, the direction cosines and centre if the ellipse FOR
   THE LAST ATOM are stored in LIST 20.
   A LIST 20 is only written to the disc on
   a satisfactory exit from ANISO.
   
   
   

**QUIT**



   
   This directive abandons the calculation without modifying the disc LISTs.
   
   
   

**AXES**



   
   This directive (like \\AXES) computes the principal axis lengths
   and directions for the atoms specified on a preceding ATOM directive.
   
   
   

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
   
   ::


       \ANISO
       ATOMS O(12) UNTIL LAST
       AXES
       TLS
       DISTANCES
       END
   


   
   
   
   
   
   
.. index:: AXES

   
.. index:: Principal atomic displacement directions


===================================================
Principal atomic displacement directions  -  \\AXES
===================================================


::


    \AXES INPUTLIST=
    END
   
   \AXES
    END






This routine calculates the magnitudes and directions of the principal axes
of the atomic dispacement ellipsoid of an anisotropic atom.
Atoms which are isotropic are ignored.
Atoms with a negative principal axis generate a warning.
The output gives the mean square displacement in angstroms squared along each
of the principal axes, together with the direction cosines with respect
to the orthogonalized axes and with respect to the
real cell axes.


This routine can also be called from \\ANISO to get the axes of specified
atoms only.



-----------------
\\AXES INPUTLIST=
-----------------


   
   This command initiates the routine for calculating the
   principal atomic vibration directions, and requires no other directives.
   

*INPUTLIST=*


   
   ::


            5   -  Default value
            10
   


   
   The default value is 5.
   
   
   
   

=========================================================
Structure factors for a group of trial models  -  \\TRIAL
=========================================================



This procedure is currently unsupported. It is kept in the code 
because it offers an opportunity for a new programmer to experiment with
improved 'COST' functions.


At some stage during a structure determination, the orientation
of a group of atoms may be known, but not their position in the
unit cell.
The routine described in this section provides a rapid method of
calculating structure factors for a group of atoms at a series of
points that fall on a grid in the unit cell.
The algorithm used is similar to that employed in the slant fourier,
(see the section of the user guide on 'Fourier routines') and is as
follows :


The  A  part of the structure factor for the reflection with indices
given by the vector  H  may be written as :
::


          A(H) = SUM[ G.SUM[ COS2PI(H'.S.X + H'.T) ] ]




With a similar expression for the  B  part.
( G  Is the required form factor, modified by the temperature factor
expression).
Conventionally, the inner sum runs over the various symmetry operators
that define the space group, and the outer sum runs over the number of
atoms in the asymmetric unit.
However, if the summation order is changed, it is possible to
accumulate sums for all the atoms for each symmetry position :
::


          P(H,S) = SUM[ G.COS2PI(H'.S.X + H'.T) ]




With a similar expression for  Q(H,S)  for the  B  part.
It is now possible to use a recurrence relationship for  P
and  Q  to give :

::


          P(H,S,2) = P(H,S,1)*2*COS2PI(H'.S.DX) - P(H,S,0)
    and
          Q(H,S,2) = Q(H,S,1)*2*COS2PI(H'.S.DX) - Q(H,S,0)




P(H,S,0)  Is the original value of  P  for the symmetry position  S
for the reflection given by  H .
P(H,S,1)  Is the corresponding value of  P  after a vector  DX  has
been added to each set of coordinates, and  P(H,S,2)  is the
corresponding term after a vector  2*DX  has been added.
Similar relationships hold for the  Q  terms.
After the initial eight cosine and sine terms have been calculated,
it is possible to calculate structure factors very rapidly
as the group of atoms is moved about the unit cell,
using the relationships given above.


Apart from an array to hold each section through the unit cell,
it is necessary to store the eight cosine and sine terms, together
with the three step vector cosines, for each reflection for each
symmetry position.
Because this imposes certain storage limitations, it is necessary
to restrict the number of reflections that are used.
In practice it is only the large reflections that must agree, and so
the user is required to input a minimum Fo value, below which
reflections are not used.
The function that is displayed for each grid point is given by :
::


          SCALE*SUM[ Fo*Fc ]




Accordingly, the largest value printed represents the most likely
solution.
The  SCALE  term may be calculated by the program to give numbers in
a reasonable range, or input by the user.
The time for each calculation is proportional to the number of
reflections used, the number of symmetry operators in LIST 2,
and the number of grid points calculated.
(A calculation in a non-centro space group takes twice as long as a
calculation in the corresponding centro space group).
The atoms to be moved around are taken directly from LIST 5.

-------
\\TRIAL
-------


   
   This is the command which initiates the routine to calculate
   structure factors for a group of trial models.
   

**MAP Fo-MIN SCALE MIN-RHO**



   
   This directive determines which reflections will be used in the
   calculations and how the map will be printed.
   

*Fo-MIN*


   This parameter is the minimum value of Fo that a reflection must
   have if it is to be used (this number must be on the scale of Fo).
   If this parameter is omitted, a value of zero is assumed.
   

*SCALE*


   If  SCALE  is equal to zero, its default value, the program will
   choose a scale factor that places all the numbers on
   a reasonable scale for printing.
   If this parameter is greater than zero, the sum of Fo*Fc
   is multiplied by  SCALE  before it is printed.
   (The scale factor computed by the program is dependent upon
   the origin chosen for the group of atoms, so that
   successive maps with different origins will be on different
   scales, unless this parameter is specified for all the maps
   after the first).
   

*MIN-RHO*


   This parameter is a cut-off value, such that all numbers less than
   MIN-RHO  are printed as zero. If this parameter is absent, a
   default value of zero is assumed, which means that all the points
   are printed.
   

**DISPLACEMENT DELTA-X DELTA-Y DELTA-Z**



   
   This directive defines a vector which is added to each set of
   coordinates in LIST 5 before the structure factor calculation
   starts.  DELTA-X ,  DELTA-Y  And  DELTA-Z  thus correspond
   to an initial origin shift for the group in LIST 5.
   

*DELTA-X*


   The shift along the x-direction.
   

*DELTA-Y*


   The shift along the y-direction.
   

*DELTA-Z*


   The shift along the z-direction.

   
   The default values for these parameters are zero, indicating no
   initial origin shift before the structure factor calculation.
   

**DOWN NUMBER X-COMPONENT Y-COMPONENT Z-COMPONENT**



   
   This directive specifies the printing down the page.
   

*NUMBER*


   The number of points to be printed down the page, for which there is no
   default value.
   

*X-COMPONENT Y-COMPONENT Z-COMPONENT*


   There are no default values for these parameters, which specify
   the fractional coordinate shift vector. The vector moves the group so
   that :
   ::


            X1 = X0 + X-COMPONENT
            Y1 = Y0 + Y-COMPONENT
            Z1 = Z0 + Z-COMPONENT
   


   
   Where  1  and  0  define successive points down the page.
   

**ACROSS NUMBER X-COMPONENT Y-COMPONENT Z-COMPONENT**



   
   These are the corresponding values across the page.
   

*NUMBER*


   The number of points to be printed across the page, for which there is
   no default value.
   

*X-COMPONENT Y-COMPONENT Z-COMPONENT*


   There are no default values for these parameters, which specify the
   fractional coordinate shift vector.
   

**THROUGH NUMBER X-COMPONENT Y-COMPONENT Z-COMPONENT**



   
   These are the values that define the change from section to section.
   

*NUMBER*


   The number of sections to be printed, for which there is no default value.
   

*X-COMPONENT Y-COMPONENT Z-COMPONENT*


   There are no default values for these parameters, which specify the
   fractional coordinate shift vector.

   
   These shift vectors allow any change of position for the group
   to be plotted out.
   
   ::


       \TITLE MOVE 2 SULPHURS AROUND
       \LIST 5
       READ NATOM=2
       ATOM S 1 X=0.00 0.15 0.37
       ATOM S 2 X=0.13 0.05 0.24
       \ call '\trial' with a min. fO of 250
       \TRIAL
       MAP Fo-MIN=250
       \ initial origin shift
       DISPLACEMENT 0 0 -0.3
       \ plot half of y down the page
       DOWN 26 0 0.02 0
       \ plot half of x across the page
       ACROSS 26 0.02 0 0
       \ plot half of z up the page negatively
       THROUGH 51 0 0 -0.01
       \FINISH
   


   
   
   
   
