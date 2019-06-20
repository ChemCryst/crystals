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


   
***************
Worked examples
***************
These (and other) examples can be found in the *Wincrys/demo* folder.
Each demo subfolder contains data and instructions exploring a differenct crystallographic 
problem. In this section of the manual we look at just two simple cases.

====================================
Cyclo - a routine structure analysis
====================================
This natty material was supplied as very poor colourless crystals found congealed 
in the bottom of a half-abandoned flask.
|br|\
A fragment of crystal (0.3 x 0.4 x 0.4 mm) was mounted in oil 
on a KCCD diffractometer at 190K and  a data set collected in two hours. 
|br|\
The space group is P 21 21 21


.. image:: images/cyclo.jpg


-------------------
Video demonstration
-------------------
The video is explained step by step after it finishes.

.. raw:: html

    <div style="position: relative; padding-bottom: 16.25%; height: 0; overflow: hidden; max-width: 100%; height: auto;">
    <iframe width="560" height="315" src="https://www.youtube.com/embed/KDUIFE_epXE?rel=0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
    </div>
	
	
----------
Discussion
----------

^^^^^^^^^^^^^^^^^^^^^^^^^^
Step one: SHELX-style data
^^^^^^^^^^^^^^^^^^^^^^^^^^


.. image:: images/guidetool.png


Click the GUIDE button (crystal icon) at the top left of the toolbar.


The GUIDE provides a list of options. To carry out the current 
recommended action you would just click OK. You can change the 
action by clicking the little down arrow to the right of where it 
suggests a useful option.
|br|\ |br|\
Choose *Import Data* |br|\
In the folder listing which pops up, choose **cyclo.ins** and then
*Open*.  
|br|\
If there is a corresponding hkl file (cyclo.hkl in this case) it will also
be read in, other wise you will be prompted for the reflection data.
|br|\
You will be invited to merge the Friedel Pairs. Read the explanatory text
so that you can make a suitable decision. CRYSTALS assumes that you will
want to refine your structure using |F2|.  You can change this to F later
if you prefer to.  CRYSTALS stores all of your reflections, but you can
selectively filter out those you don't want to use. The default filter rejects 
very negative reflections. (:math:`I/\sigma(I) < -3`)
|br|\
The *Experimental Conditions* box will pop up. It's a good idea to fill this in
now because these items will be needed later when you output a cif file.

.. image:: images/experimental.png





^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step two: Initial assessment of the data
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/initguide.png


It is useful to get an idea of the
quality of your data before proceeding - click OK.


.. image:: images/initial.png


Click on each tab, and convince yourself that the data looks reasonable. 
Some of the graphs allow you to choose cut-off limits for the
data (based on :math:`I/\sigma(I)` or :math:`(\sin\theta/\lambda)^2`) if you click with the
right mouse button. However, don't do this for now.
|br|\
Click |blue| **Help** |xblue| for an explanation of what each tab tells you
|br|\
The last tab is particularly useful as it checks that the cell
contents are reasonable given the cell volume, and that the number
of observations is reasonable given the expected number of final
parameters.
|br|\
Note that the resolution is in terms of :math:`(\sin\theta/\lambda)^3`.  The cube
exponent means that the shells are of equal volumes and so should contain roughly
the same number of reflections. The *Resolution Table* button converts to
:math:`(\sin\theta/\lambda)^2`, and this value can also be seen directly by hovering the
cursor over a point on the graph. 



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step three: Structure solution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**If your *.ins* file contained some atoms, CRYSTALS will have imported them and you will
not be invited to solve the structure, but will skip on to refinement.**
|br|\
Otherwise, the guide should now be recommending *Run Superflip*.  This has been made the 
default choice because it tries to confirm your space group assingment and is generally 
robust. You will be offered a small menu of alternatives - just click OK to the default 
values.  Note that your database (.dsc) will be backed up just in case something goes 
seriously wrong.

.. image:: images/superflip.png


If the structure solves, Superflip will try to assign atom types based on the peak 
heights and connectivity in electron density maps.  The solution is rendered in a new 
window where you have the opportunity to change the atom assignments made by Superflip.
|br|\
To rotate the structure:
|br|\
Point into some empty space, hold down the left-mouse button and drag the mouse around.
|br|\
To change an atom type, select the type you want from the box on the left and then 
left-click on the atoms to change. In this example all but one nitrogen should be changed 
to oxygen.
|br|\
Make sure the model matches the expected structure before continuing.

.. image:: images/typechange.png

If the structure is a molecular material but has not already been assembled into discrete
molecules, click *Collect Atoms*.  Once the atom labelling is complete, CRYSTALS 
automatically re-numbers the atoms so that the serial numbers progress logically through 
the structure.






















^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step four: Commence refinement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



You may wish to change the model style from Ball to
Ellipse so that you can see how the anisotropic temperature
factors are behaving as the structure refines.
|br|\
To do this click the Ellipse button on the toolbar above the model:


.. image:: images/ballelli.jpg




The guide is recommending refinement. (Refine scale, position and Uiso)
|br|\
Click OK to start.


.. image:: images/lsqd.png




Click OK to set up the least squares directives as specified.
|br|\
Refinement will start automatically (unless you check the Advanced
box, in which case you can edit the directives and choose the number
of cycles).
|br|\
The Guide now recommends anisotropic refinement. Click OK
|br|\
CRYSTALS will carry out some rounds of refinement, the R-factor
should drop to somewhere around 9%
*(see bottom-left Info-Tab)*.  Note that because Superflip uses a random start 
procedure, successive runs will give slightly different initial atomic coordinates
but they will finally converge.


.. image:: images/infotabs.jpg




^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step five: Adding Hydrogen Atoms
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^


The GUIDE has decided that it is time to add hydrogen atoms.

.. image:: images/addhguid.jpg



Click OK to do this.
|br|\
White atoms are a sites computed from the geometry of the existing atoms. 
Because the geometry  at nitrogen is very flexible, CRYSTALS 
does not normally try to compute the positions of hydrogen connected to nitrogen.
|br|\
Pink atoms are sites found in a difference density map that does **not** include contributions 
from the theoretical H atoms.


.. image:: images/firsth.png




You can see that in general while most of the hydrogen atoms have been
computed correctly (almost co-incident white and pink atoms), the computed positions for the CH3 
at the botton of the image are about 60 degrees out of phase.  This is because CRYSTALS 
has to start by putting one H atom *trans* to either the adjacent O or N, and it made the 
wrong choice. Don't worry - the |blue| Regularise H Using Restraints |xblue| will fix 
that. Watch the CH3 rotate as it refines.
|br|\
Note also that there is still a hydrogen missing from the nitrogen atom.
|br|\
Click Continue.
|br|\
Follow the GUIDE, it will recommend more refinement, then
Add Hydrogen again but make sure NOT to delete the existing hydrogen atoms.
|br|\

.. image:: images/nodelete.png

This time the missing hydrogen atom will be found in the
Fourier map. It is currently labelled QH(1). Using the right-click
method from step five, change the element type to Hydrogen.
|br|\
Check the box that says "All H atoms have been found".
|br|\
Click Continue.



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step six: More refinement & Extinction
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



Carry out some more refinement by clicking OK on the GUIDE.
|br|\
This time, the refinement setup offers a choice of how to
treat the H atoms:


.. image:: images/lsqsetup2.png


You will now have a selection of possible treatments for the hydrogen atoms.
|br|\
The default treatment is to refine H attached to O or N with slack restaints,
and to *RIDE* all other hydrogen atoms.  

::

  Riding Hydrogen atoms are refined synchronously 
  with their parent atom (i.e. they have the same 
  shifts applied) and do not introduce new parameters.

  Hydrogen bound to O or N are best refined with 
  restraints because their exact position is less
  predictable.

  With modern data it is usually possible to
  refine all hydrogen atoms with weak restraints,
  and with good modern data it is possible to 
  refine most hydrogen without restraints.



  


Set up and carry out the refinement by clicking OK.
|br|\
Next the GUIDE recommends an extinction check:

.. image:: images/extguid.png


Click OK
|br|\
The extinction check graph is displayed:

.. image:: images/fovsfc.png

This plots Fo against Fc. If extinction is a problem for the
crystal, the graph will flatten out (drop under the blue Fo=Fc
line) at high values of Fc.
|br|\
Extinction isn't a problem here, however, three of the reflections
are clearly outliers. (Lie far from the Fo/Fc line).
|br|\
Exclude the outliers from the refinement 
by right-clicking on the offending points and
choosing "Omit". However, you should investigate why there are outliers.
|br|\
The most common cause is that the beam trap was
partially obscuring the image on the diffractometer due to a misplaced
beam trap, or an incorreclty defined exclusion zone.
|br|\
Click the "Do not" button to close the window and continue without
an extinction correction.



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step seven: Choose a suitable weighting scheme
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



Carry out one more cycle of refinement to account for the reflections
just omitted.
|br|\
We now have an opportunity to pick an optimal weighting scheme.
The GUIDE recommends "Optimise Weights"
|br|\
Click OK
|br|\
This dialog offers several alternatives:

.. image:: images/scheme.png

If you are refining against |F2|, choose the Modified SHELX scheme.

.. image:: images/agreement.png

The red bars in the plots are the residuals with unit weights, the green bars
are the weighted residuals. The green bars should all be very small, centred about
the unity line. The dark blue line shows the number of reflections in each
bin. Bins contailing small numbers of reflections may have un-typical 
average residuals.
|br|\
The Help button brings up a short description of the functions of the 
different schemes.



^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Step eight: Validation and CIF archival
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



Click OK on the GUIDE to carry out a few last cycles of refinement.
|br|\
The GUIDE now recommends "Validate" (this means that it's happy that
the structure is complete).
|br|\
Click OK to validate the structure.
|br|\
A list of tests and any failures will
appear in the text window on the left:

.. image:: images/valid.jpg

If the shift/esd is causing a warning this usually means that the refinement has
not quite converged. Try a few more cycles. 
Change the GUIDE default option to Refine posn and aniso and click OK.
Then carry out the validation again.
|br|\
This time, there should be no problems with the structure.

::

  If a refinement fails to converge (shift/esd keeps changing 
  up and down or moves very slowly in one direction) look at 
  the blue line in the text pane and see if a single parameter
  is responsible. 
  Possible remedies are:
   1) Re-optimise thr weights
   2) Look for outliers in the Fo/Fc plot
   3) Apply shift limiting restraints
   4) Apply a few cycles of refinement with 'Partial Shifts' 



.. image:: images/converge.png



If all checks passed, the GUIDE will recommend Publish.
|br|\
A variety of data formats are available for publication/archiving.
|br|\
Choose CIF, which contains just about everything that you need.
|br|\
Click OK to write a CIF.


.. image:: images/publish.png


If the Six final cycles box is ticked, it means that CRYSTALS doesnt think 
the refinement has converged. 
|br|\
Choose 'Edit CIF Goodies' from the top of the menu and verify that
you have input all the small details like crystal colour, size, shape etc.
|br|\
Click OK.


From the menus choose "Results"->"Checkcif on the web" for further
checks.
|br|\
The cif is c:\\wincrys\\demo\\cyclo\\publish.cif.
|br|\
To close CRYSTALS choose Exit Crystals from the File menu.


==================================
Poor Quality Data - Tetraphenylene
==================================


----------
Background
----------



This is a hard, well crystalline organic material. Melting point 232-235 C.
The crystals are in the form of prisms terminated with brilliant pyramidal
faces. It was selected as a potential test crystal for analysing data
collection and processing strategies, since its internal symmetry
permits non-crystallographic statistical tests to be applied.  A
crystal 0.04 x 0.05 x 0.17 mm was Araldited to a fine glass capilliary.
A hemisphere of data was collected using the parameter settings selected
by the Nonius COLLECT software.  Further equivalent data sets were collected
with exposure times doubled, halved and quartered.

The data we have here is for the very fast data collection.
The full hemisphere of data took 48 minutes to collect (15519
reflections).  The average redundancy is 3, with 4000 reflections having
a redundancy of 5 or more.



Chemical formula C24 H16|br|\
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



.. image:: images/bad-wilson.png



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


===============
Spacegroup Quiz
===============



From the Development menu, choose Space group quiz.





