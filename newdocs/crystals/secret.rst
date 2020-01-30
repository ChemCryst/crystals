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










.. index:: List 39


.. _LIST39:

 
=========================================================================
Storage of intermediate results and the status of a refinement -  LIST 39
=========================================================================






There are two INTEGER records.
::


    INFO holds flags indication what steps of the analysis have been completed.

      0      "INFO"
      1      "0"
      2      HMASK/HDONE      0/1   H have all been found
      3      EMASK/EDONE      0/1   Extinction has been checked
      4      WMASK/WDONE      0/1   Weights have been chosen
      5      PMASK/PDONE      0/1 ( Purge LIST 11 done)
      6      HRMASK/HRTYPE/HRKEY    0 FIX
                                    1 POS
                                    2 X & U
                                    3 RIDE
                                   10 RIDE
      7      L12MASK/L12SER   LIST 12 serial number
      8      I6MASK/I6DONE    0/1
      9      HRESTM/HRESTF          2 None
                                    1 All
                                    0 Nitrogen & Oxygen
     


    OVER holds flags indicating which OVERALL parameters are in LIST 12 are 
    being refined, indicated by a non-zero entry.

    OVER 1 Scale Du(iso) Ou(iso) Polarity Enantiopole Extinction 





There are three REAL records


FLAC(0) holds information about the Absolute Structure
::

      0    "FLAC"
      1    "0"
      2    Slope of the npp for the refinement
      3    Slope of the npp for the Bijvoet pairs
      4,5  Hole-in-one value and su
      6,7  Difference or Quotient value and su
      8,9  Hooft y value and su
     10,11 Histogram value and su




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


   Hooft(y)    P2_true    P2_false    P3_true      P3_twin   P3_false
   




SFLS holfd info about the refinement process.
::


   SFLS 0  1or2.  2 indicates CRYSTALS thinks refinement has converged.
   
   
