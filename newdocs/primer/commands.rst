.. toctree::
   :maxdepth: 1
   :caption: Contents:


.. _defandconv:

.. |br| raw:: html

   <br />

.. |blue| raw:: html
   
   <font color="blue">

.. |xblue|  raw:: html

   </font>

.. |vspace|  raw:: latex

   \vspace{5mm}


.. |F2| replace:: F\ :sup:`2`





.. _command overview:


################
COMMAND Overview
################
CRYSTALS is actually controlled by sending it *COMMANDS*. The menus 
pre-package commands and other information to simplify routine tasks.
For non-routine projects the user can issue commands and other information
either by typing on the comman line, or by putting the information into an
ASCII-encoded (plain text) file.

************************
PREPARATION OF THE MODEL
************************
This may be the input from a direct methods program, from finding additional
atoms in Fourier maps, or modifying the existing model (with \PEAKS, \EDIT,
\COLLECT, \REGROUP,
\REGULARISE, \MOLAX, \HYDROGENS, or \ANISO). These involve operations
on LIST 5.

::

 It is a good idea to assign a final atom numbering scheme as soon as
 possible in the analysis. This will save a lot of hastle later.

 

^^^^^^
\Peaks
^^^^^^
This command converts the output from a Fourier peak search (held as a
LIST 10) into a parameter list, LIST 5. It associates any new PEAKS with
existing atoms. It can also be used for Fourier refinement, and for
rejecting duplicate atoms, e.g. after changing space group.
 

^^^^^^^^^^^^^^^^^^^
\Collect & \Regroup
^^^^^^^^^^^^^^^^^^^
These commands assist in assembling molecules from peaks lists. REGROUP
applies symmetry and
reorders the atoms in LIST 5, COLLECT only applies symmetry. Both can be
made to work with all atoms in LIST 5, or only operate on peaks of type
Q. These are powerful utilities and can save a lot of manual editing.
 
::

  e.g.
      \PEAK
      END
      \COLLECT
      SELECT TYPE = PEAK
      END
      \REGROUP
      SELECT SEQUENCE=YES
      END



These commands take peaks from the latest Fourier map and
try to collect atoms of TYPE 'Q' (i.e. new peaks) so
that they are within bonding distance of existing atoms. The 
graphics window displays the structure and permits the renaming of peaks and
atoms, and the exclusion of spurious peaks. REGROUP tries to number the
atoms so that adjacent ones have sequential serial numbers.
 

^^^^^
\Edit
^^^^^
The CRYSTALS editor, \EDIT, is designed to perform crystallograhic
edits on the atom parameters, in LIST 5. If anything needs to be done
on groups of atoms, \EDIT is likely to be more convenient than using a text
editor on the parameter list.
 
::

  e.g.
     \EDIT
     CHANGE    FIRST(U[ISO])  UNTIL  C(10)  .03
     EXECUTE
     CHANGE    Si(3,OCC) .667   Si(103,OCC)   .333
     SUBTRACT  .25 FIRST(Y) UNTIL LAST
     ADD       C(30,SERIAL) UNTIL LAST 100
     TRANSFORM -1 0 0, 0 -1 0, 0 0 -1 FIRST UNTIL LAST
     SELECT    TYPE NE PEAK
     DELETE    S(14)
     UEQUIV    C(16) C(23) UNTIL LAST
     ANISO     Pb(1)
     KEEP      C(1) C(3) C(5) C(7) UNTIL LAST
     END



The directive EXECUTE forces immediate execution of preceeding commands. The
directive CONTINUE is available for building long lines, and QUIT abandons
the edit without saving the results. The original values are unchanged.

 

^^^^^^^^^^^^^^^^^^^^^^^^^^^
\Molax, \Regularise, \Aniso
^^^^^^^^^^^^^^^^^^^^^^^^^^^
These commands are used to examine the geometry of the model. They can
also be used to force certain geometries onto the model. MOLAX computes
best planes and lines (molecular axes), REGULARISE compares and
regularises structures or structural fragments,
and ANISO  helps with the analysis of the thermal
parameters.

 

**********
REFINEMENT
**********
CRYSTALS was originally developed to perform difficult or complex
refinements, and was subsequently modified to simplify the treatment of
routine cases. There are seven components of a refinement strategy.


 

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Structure factor control list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
On slow computers or for large structures,
the structure factor computation can be speeded up by disabling the
contributions from parameters or data that have null or default values. These
'switches' are in LIST 23, the structure factor control list.
The default values in this list are usually suitable.
Some switches may be reset
automatically by CRYSTALS. You will be told when this happens.
For disordered structures, you may need to inhibit special position
checking, or reduce the tolerance for atom matching.
 
::

  e.g.
      \LIST 23
      REFINE         SPECIAL=TEST      UPDATE=NO
      END
  or
      \LIST 23
      REFINE        TOLERANCE = .1
      END

 

^^^^^^^^^^^^^^^^^^^^^
Refinement definition
^^^^^^^^^^^^^^^^^^^^^
Defining the parameters to be refined. This information is held separately
from the atom coordinates, in LIST 12. This list also contains information
about the matrix blocking, constrained parameters, riding parameters, rigid
groups and other special processes.

The release version of CRYSTALS will refine about 8,000 atoms full matrix
or 50,000 atoms by anisotropic atom-block
diagonal methods. The parameters to
be refined are specified in LIST 12.
 
::

  e.g.
      \LIST 12
      FULL     X'S U[ISO]
      END


      \LIST 12
      BLOCK SCALE  X'S U'S
      END


      \LIST 12
      FULL     X'S
      CONTINUE     FIRST(U'S) UNTIL C(30)
      CONTINUE     H(1,U[ISO]) UNTIL LAST
      END



The first example gives full matrix isotropic refinement, the second
full matrix anisotropic refinement. The third is a mixed aniso-iso
refinement.
FULL always implies refinement of the over all scale factor.
The matrix will be large, so you may need to
extend the .DSC file if automatic extension is not enabled. See the
sections on :ref:`ADVANCED REFINEMENT <ADVANCED REFINEMENT>` 
and on :ref:`CRYSINIT files <CRYSINIT files>`.

 

^^^^^^^^^^^^^^^^^
Special positions
^^^^^^^^^^^^^^^^^

CRYSTALS normally automatically applies the constraints or restraints necessary for
the treatment of atoms on special positions, and adjusts the site
occupancy. Default actions are set in LIST 23, and if these are disabled
they can be set on demand with \SPECIAL. The user needs only be concerned
with partial occupancy due to disorder, etc. 

 

^^^^^^^^^^^^^^^^^^^^^^^^
Treatment of reflections
^^^^^^^^^^^^^^^^^^^^^^^^
Reflections may be included or excluded from computations
depending on values of filters set in LIST 28. Reflections are not actually
deleted from the reflection list, but merely flagged as not-to-be-used. The 
filters can be set and reset at any time ti include/exclude reflections
 
::

 e.g.
      \LIST 28
      MINIMA RATIO=3.0
      READ NOMISSION=2
      OMIT 2 0 0
      OMIT 0 2 2
      END


 

^^^^^^^^^^^^^^^^^^^^^^^^^
Weighting the reflections 
^^^^^^^^^^^^^^^^^^^^^^^^^
A large number of schemes are possible,  defined in LIST 4. Schemes are
available for F or Fsq refinement.

By default, unit weights are set for initial refinement refinement against F
and statistical weights are used for refinement against |F2| .
|br|\
Once the
model is fully parameterised (all atoms found) and more or less converged,
alternative weights should be chosen to obtain the most realistic estimated
standard deviations. There is a menu item (under REFINE) to help set a 
suitable weighting scheme
|br|\
The ANALYSE menu produces an analysis of residuals. The column headed
<w*deltasq> should be more or less constant for suitable weights.

 

^^^^^^^^^^
Restraints
^^^^^^^^^^
Treatment of restraints. These are stored in LIST 16, and applied or
not depending on a switch in LIST 23.
CRYSTALS offers many restraints. They are stored in symbolic form in
LIST 16, and are converted to computable format by \LIST 26.
 
::

 e.g.
   \LIST 16
   DIST       1.39, .01 = C(10) TO C(11), C(10) TO C(15)
   DIST       0.0 , .01 = MEAN  C(1) TO C(2), C(1) TO C(6)
   PLANAR     C(101) UNTIL C(106)
   VIBRATION  0.0 , .01 = MEAN  C(1) TO C(2), C(1) TO C(6)
   SUM        Ca(1,OCC) FE(1,OCC) Al(1,OCC)
   END
   \CHECK
   END



The CHECK command produces a listing of the observed and calculated values
for the restraints. The atom specifications can include symmetry
indicators.
The distance and angle restraints using the mean value of the observed
molecular parameters is especially valuable for imposing molecular symmetry
without the user being required to know the target values.
 
::

 e.g. for a phenyl group bonded though C(1)
       \LIST 16
       DIST 0.0, .001 = MEAN C(1) to C(2), C(1) TO C(6)
       DIST 0.0, .001 = MEAN C(2) to C(3), C(6) TO C(5)
       DIST 0.0, .001 = MEAN C(3) to C(4), C(5) TO C(4)
       ANGLE 0.0, .02 = MEAN C(1) to C(2) to C(3),
       CONTINUE           C(1) to C(6) to C(5)
       ANGLE 0.0, .02 = MEAN C(2) to C(3) to C(4),
       CONTINUE           C(6) to C(5) to C(4)
       END



If there are several phenyl groups, all equivalent bonds can be added into
the same mean.
 

^^^^^^^^^^^^^
Least Squares
^^^^^^^^^^^^^
Least squares are initiated once the preparations are completed. For large
structures it is sensible to do the preparations interactively, and run the
LS in batch. If refinement converges or diverges before the specified
number of cycles, refinement is terminated. The user can always demand one
cycle.
 
::

      \SFLS
      SCALE
      REFINE
      REFINE
      CALCULATE
      END

 

********************
SEEING THE STRUCTURE
********************


^^^^^^^^^^^^^^^^^^^^^^^
Listing the coordinates
^^^^^^^^^^^^^^^^^^^^^^^
The atomic parameters are kept in LIST 5. They can be displayed on the
screen or printer file with:
 
::

      \DISPLAY      low/medium/high
      END

 
^^^^^^^^
Graphics
^^^^^^^^
The model window continuously displays the current structure and contains some 
functionality for editing the structure or performing computations on it.
See :ref:`The Model Window <The Model Window>` for details
|br|\
The graphics program 'CAMERON' is accessed via the main menus.
It was designed to
help with the understanding of crystal packing, but can also be used as
a structure editor.
If the structure is modified in Cameron, it may be re-input to the CRYSTALS
data-base. :ref:`Cameron <cameron-manual>` has its own user manual.
 


 

******************
MOLECULAR GEOMETRY
******************
Details of the molecular geometry can be computed in CRYSTALS. Most
calculations send a summary to the screen and a detailed listing to the
printer file. Some will also produce a fixed format ASCII file suitable
for incorporation into documents in either tabular of 'cif' format.
 

^^^^^^^^^^^^^^^^^^^^
Distances and angles
^^^^^^^^^^^^^^^^^^^^
The  distance-angle routine has a very large vocabulaty of directives which
should help the user to details about the
molecular structure or the packing environment. 
For many cases the default settings are suitable. 
|br|\ Text files suitable for editing into documents or as part
of a commnd file suitable to reading into CRYSTALS may also be
produced.
 
::

      \DISTANCE
      END

 

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Best planes, lines and dihedral angles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Planes, lines and the angles between them are computed with MOLAX (molecular
axes). 
 
::

      \MOLAX
      ATOM FIRST UNTIL LAST
      PLANE
      EXEC
      ATOM C(1) UNTIL C(6) P(1)
      PLANE
      EXEC
      ATOM P(1) FE(1) P(2)
      LINE
      ATOM P(3) FE(1) C(17)
      LINE
      ANGLE 3 AND 4
      END



This task computes the best plane through the whole structure, through a
P-phenyl group, and lines through two groups of atoms. The corresponding
vector (plane normal or line axis)
is stored for each PLANE or LINE calculation. The ANGLE directive
requests the angle between the 3rd and 4th vectors, i.e. the two lines.
EXEC, as in EDIT, forces immediate execution of the preceeding directive.
|br|\
Plain text files can also be generated.
 

^^^^^^^^^^^^^^
Torsion angles
^^^^^^^^^^^^^^
CRYSTALS does not automatically compute all the torsions angles for a structure.
Selected torsion angles are explicitly computed.  If the inverse of the normal
matrix is available the esds are computed including all correlations, otherwise
just the axial esds are used. 
 
::

      \TORSION
      ATOM C(1) C(2) C(3) C(4)
      ATOM C(6) C(7) C(8) C(9) UNTIL C(11)
      END



This computes one torsion atom in the first command, and 3 in the second.
The output can be sent to a text file.

 

^^^^^^^^^^^^^^^^
Thermal analysis
^^^^^^^^^^^^^^^^
During the course of refinement, CRYSTALS keep a watch on the thermal
parameters and issues warnings if they go too small or too aspherical.
However, it is often instructive for the user to examine both the principal
axes and the TLS molecular motion tensors, in
association with a Cameron thermal ellipsoid plot.
 
::

      \ANISO
      ATOM FIRST UNTIL LAST
      AXES
      EXEC
      ATOM C(1) UNTIL C(6) P(1)
      TLS
      END



These commands compute the principal axes of all the atoms, and then does a
TLS analysis on the P-phenyl group. EXEC forces immediate execution of the
preceeding commands.

 

********************
PUBLICATION LISTINGS
********************
Normally journals require crystallographic information to be submitted in the for of *cif* 
files. CRYSTALS can also output plain text files suitable fo inclusion in
other documents. |br|\
Atomic coordinate and structure factor listings are organised to fit onto
A4 paper or a continuous listing.
Bond length, angle and torsion angle listings are a continuous
column, since they will generally need editing. The listings include standard
deviations, computed from the normal matrix. This is linked internally to
LIST 5, therefore, |blue| LIST 5 MUST NOT BE MODIFIED |xblue| in any way between the final
least squares and the generation of publication listings.
|br|\
These listings are normally accessed from a menu, but can be created manually too.

 
::

      \REFLECTION
      END
      \PARAMETERS
      END
      \DISTANCE
      E.S.D YES
      OUTPUT PUNCH=PUBLISH
      END
      \TORSION
      PUBLICATION YES
      ATOM C(1) C(2) C(3) C(4)
      ATOM C(6) C(7) C(8) C(9) UNTIL C(11)
      END



The output is in an ASCII file with, by default, the type .PCH.
REFLECTIONS, PARAMETERS
and DISTANCE have a wide range of parameters which can be set to control the
type and format of the output.

 
