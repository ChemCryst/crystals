.. toctree::
   :maxdepth: 1
   :caption: Contents:


.. include:: ../macros.bit





.. _tetraphenylene:


**********************************
Poor Quality Data - Tetraphenylene
**********************************
.. index:: Tetraphenylene
.. index:: Example - Poor Quality Data


^^^^^^^^^^
Background
^^^^^^^^^^

This is a hard, well crystalline organic material, melting point 232-235 C.
The crystals are in the form of prisms terminated with brilliant pyramidal
faces. It was selected as a potential test crystal for analysing data
collection and processing strategies because its internal symmetry
permits non-crystallographic statistical tests to be applied.  A
crystal 0.04 x 0.05 x 0.17 mm was Araldited to a fine glass capilliary.
A hemisphere of data was collected using the parameter settings selected
by the Nonius COLLECT software.  Further equivalent data sets were collected
with exposure times doubled, halved and quartered.

The data we have here is for the very fast data collection.
The full hemisphere of data took 48 minutes to collect (15519
reflections).  The average redundancy is 3, with 4000 reflections having
a redundancy of 5 or more.



Chemical formula C24 H16 |br|\
The instrument which collected this data only output
the point group, C2. The actual Space group monoclinic C2/c.



^^^^^^^^^^^^^^^^^^^^^
Analysis and solution
^^^^^^^^^^^^^^^^^^^^^



Get started as in Exercise 1, with the following differences:
::


   This time:
          Choose the workshop structure "Quick"
          the SHELX format input file is called veryfast.ins 
          the reflection file is called veryfast.hkl
          when the filter dialogue opens, change the minimum
               I/sigma(I) from 3.0 to -10.0 (i.e. only reject
               very negative data).


Foolishly ignore the "Initial analysis" selection, and try to solve
the structure with SIR92, using the default settings.
It will not be very successful.




Quit SIR, and when asked do not use the solution from Sir92.
Close the advice dialog that follows.




Now re-select the "Initial Analysis" option in the GUIDE. (OK)




There may be a few moments delay while the systematic absences
are loaded.

Note that the high resolution completeness is awful.


Select the "Absences" tab - you should see that they are
fairly symmetrically distributed about 0,0.



Select "Sigma freq." - you will see that there are only about 500
reflections with I>3sigma(I).



Select "Wilson Plot" - the high-angle data don't make any sense. In the textpane CRYSTALS 
will suggest a resolution cut-off of about 0.28.  Be a bit more
conservative than this and
right-click a blue cross on the Wilson plot somewhere near
:math:`\rho`, (:math:`=(\sin\theta/\lambda)^2`) = 0.32. Then click the "Reject data"
menu item that pops up.



.. image:: ../images/bad-wilson.png



In the filter dialogue (under Refinement), 
round the :math:`(\sin\theta/\lambda)^2` upper limit
to exactly 0.35.



Close this dialogue, close the Initial Analyses window and then
re-run SIR92, but this time click the radio-button that says *Filter
Reflections using List28 conditions*.



The structure should now solve, but with two molecules in the asymmetric unit. This is 
because the space group has not been set correctly. Go to the Info Tab |blue|
Cell/Symmetry |xblue| and input the correct space group, C 2/c. Now select *Solve* 
from the Menu bar.



Note that setting a minimum I/sigma(I) threshold instead of a
resolution threshold will not help solve the structure.  This
is because while high-angle weak reflections are just noise,
low angle weak reflections have high information content and
are needed for the negative quartets.

If you try to solve the structure with Superflip it will also find the wrong space group
unless you choose the *Superflip parameters for difficult structures*


^^^^^^^^^^
Refinement
^^^^^^^^^^



The Guide will now invite you to perform Isotropic refinement.


Try it.  


Because of the high R factor, the Guide will not advance past
isotropic refinement.


Force anisotropic refinement.  


There is little improvement in R, but if you enable ellipses
in the model window they look fair.


Now choose "Filter Reflections" from the "Refinement" menu.



Change the I/sigma(I) threshold from -3.0 to 3.0, and then try
some aniso refinement.


The R factor will be quite small, but in the Refinement summary
tab, you will see that there are less than 3 reflections per parameter!


Accept the GUIDE's invitation to Add Hydrogen atoms.  


You should see that many of the ones found in the difference map are reasonably
near to the predicted positions.


Select more anisotropic refinement, but in the dialog box, also
enable hydrogen position refinement
by selecting Restrain H x's, Uiso for all H bonds.


Go back to *Refine Position and Aniso* in the Guide and turn off
hydrogen restaints and enable hydrogen positional refinement. 
You have a stable refinement with no restraints yet an
observation:parameter ratio of little over two.

^^^^^^^^^^^^^^^^^^^^^^^^
But what of the e.s.d's?
^^^^^^^^^^^^^^^^^^^^^^^^



Type the following into the CRYSTALS command line box (below
the information tabs):

::


   \DIST
   E.S.D. YES
   END







Each of the bond lengths will be listed, with its associated e.s.d.



There will be an optimum I/sigma(I) cutoff and weighting scheme
to minimize the e.s.d's:
::


   Cutoff too high      => not enough data.
   Cutoff too low	=> too much noise.







You can use the reflection filter dialogue box to experiment with
different filters, and use the optimise weights dialogue to experiment
with weighting.


