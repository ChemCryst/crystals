.. toctree::
   :maxdepth: 1
   :caption: Contents:

************
Secret Lists
************


.. index:: Secret LISTS


============
Secret LISTS
============







These are LISTS used by programmers to transfer data from one utility
to another.


The user can sometimes access them via a SCRIPT or the GUI.







.. index:: Miscelaneous


.. index:: List 39


.. _LIST39:

 
=========================================================================
Storage of intermediate results and the status of a refinement -  LIST 39
=========================================================================






There are two INTEGER records.
::


    INFO holds flags indication what steps of the analysis have been completed.
    OVER holds flags indicating which OVERALL parameters are in LIST 12 are 
    being refined, indicated by a non-zero entry.
   OVER 1 Scale Du(iso) Ou(iso) Polarity Enantiopole Extinction 





There are three REAL records


FLAC(0) holds information about the Absolute Structure
::


   Slope of the npp for the refinement
   Slope of the npp for the Bijvoet pairs
   Hole-in-one value and su
   Difference or Quotient value and su
   Hooft y value and su
   Histogram value and su




FLAC(1) Holds the numbers of reflections used for various calculations:
::


   No of Friedel Pairs found
   No of Friedel Pairs after applying filters 1,2 & 5
   No of Friedel Pairs used for the normal probability plot
   Not used
   No of Friedel Pairs used for the Parsons method, applying filters 1,2,3 & 5
   Not used
   No of Friedel Pairs used for the Parsons method, applying filters 1,2,3 & 5
   Not used
   No of Friedel Pairs used for the histogram method, applying filters 1,2,3,4 & 5
   Not used




HOOF holds the Hooft probabilities
::


   Hooft(y)    P2_true P2_false    P3_true P3_twin P3_false
   




SFLS holfd info about the refinement process.
::


   SFLS 0  1or2.  2 indicates CRYSTALS thinks refinement has converged.
   
   
