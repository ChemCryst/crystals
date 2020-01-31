.. toctree::
   :maxdepth: 1
   :caption: Contents:


.. include:: ../macros.bit





***********************************
NKET - Introduction to Command mode
***********************************
.. index:: COMMAND mode example
.. index:: Example - Introduction to COMMAND mode 
.. index:: NKET Example
.. _nket:

The native mode for using CRYSTALS consists of inputting commands either
from the keyboard, or from pre-prepared files.  CRYSTALS has an extensive 
vocabulary of commands and sub-commands. An ability to use the command mode 
interface gives the user access to advanced facilities which have not been
packaged up into *SCRIPTS*. |br|\
Now that most instruments produce basic data in SHELX format, the SCRIPT
that processes *.INS* and *.RES* files is the most convenient way to start
an analysis. However, is the data is in some way exotic, it can be input 
via the COMMAND line.

^^^^^^^^^^
Background
^^^^^^^^^^


The demonstration data set *NKET* is a quick introduction to the command line.
You could print out the files listed below and input each piece of information
line by line, but in practice it is more convenient to instruct CRYSTALS to 
read the information from each file - to |blue| *USE* |xblue| the named file
|br|\
The files to be used in Command mode are:


::

 NKET.QCK    Initial data, including a set of trial coordinates
 NKET.LSQ    Isotropic refinement and molecule assembly
 NKET.ANI    Anisotropic refienement
 NKET.FOU    Difference Fourier
 NKET.REF    Reflections in SHELX format - you would almost never type this in!



Start CRYSTALS as described else where. The `COMMAND`_  LINE 
is near the bottom of
the left hand side of the screen. To *USE* a file (i.e. input the contents of a file)
type **#USE fole-name**.  If you wish to see the contents of a file before you execute it, type
**#TYPE file-name** .

.. _command: ../_../images/layout.png 
 

|blue| #USE NKET.QCK |xblue|

This file inputs the basic information needed for an analysis, including an
atomic model obtained from elsewhere. It also refines the scael factor and 
carries out an analysis of variance.  It does NOT contain all the information
needed to create a fully valid cif file.
  

::


      #QUICKSTART
      CELL 7.5330  7.5336 15.7802
      SPACEGROUP P 41
      CONTENT C 32 H 32 N 4 O 16
      DATA 1.5418 FSQ
      FILE NKET.REF
      FORMAT (3F4.0, 2F8.2 )
      END
      #LIST 6
      READ TYPE=COPY
      END
      #LIST      5
      READ NATOM =     13
      ATOM C       1 X=0.819200   0.697300   0.118000
      ATOM C       2 X=0.502300   0.661800   0.030100
      ATOM C       3 X=0.809300   0.322200   0.053100
      ATOM C       4 X=0.739400   0.046200   0.091800
      ATOM C       5 X=0.936400   0.463600   0.025800
      ATOM C       6 X=1.059800   0.461400   0.171800
      ATOM C       7 X=0.836400   0.629600   0.033900
      ATOM C       8 X=0.634800   0.560100   0.004300
      ATOM C       9 X=1.106300   0.435500   0.091400
      ATOM C      10 X=1.180100   0.263500   0.070100
      ATOM C      11 X=1.048600   0.109000   0.096000
      ATOM C      12 X=0.857800   0.160100   0.077100
      ATOM C      13 X=0.630000   0.381500   0.040500
      END
      #SFLS
      SCALE
      END
      #ANALYSE
      END
                

|blue| #USE NKET.LSQ |xblue|

  This file specifies that the x,yz and isotropic adp coordinates of
  all the atoms should be refined by two cycles of least squares, that
  the atoms should be collected to form a single molecule, and that
  the atom list should be sorted on the magnitude of Uiso. The DISPLAY
  HIGH instruction lists the atomic parameters in the text window.
  The MOLAX
  instruction is now essentially obsolete. It computes a simple plot
  in the text window of all the atoms between and including the first
  and last (i.e. all) atoms in the list.

::

 #LIST 12
 FULL X'S U[ISO]
 END
 #SFLS
 REFINE
 REFINE
 CALC
 END
 #COLLECT
 END
 #EDIT
 SORT U[ISO]
 END
 #DISPLAY HIGH
 END
 #MOLAX
 ATOM FIRST UNTIL LAST
 PLOT
 END
 



|blue| #USE NKET.ANI  |xblue|

 The structure outline looks OK - now use the structure editor to rename 
 some of the atoms. Note that keywords can be shortened to a unique string
 in the current context (RENAME becomes REN).

 The overall scale factor is refined followed by 
 the atomic positions (X's = x,y,z) and adps (U's = U[11], U[22] etc) 
 

::

 #EDIT
 RENAME C(1) O(1), C(2) O(2), C(4) O(4), C(6) O(6)
 REN C(3) N(3)
 EXEC
 END
 #LIST 12
 FULL X'S U'S
 END
 #SFLS
 SCALE
 REFINE
 REFINE
 END



|blue| #USE NKET.FOU |xblue|

 Compute a difference Fourier map, scans it for peaks and bring these peaks
 into close contact with the existing atoms. The positive peaks are named
 Q( ), the deepest hole QN(1). You should rename the peaks that look like
 hydrogen to H( ) and delete spurious peaks, including QN(1). |br|\
 PERHYDRO tries to fill in any missing hydrogen atoms based on standard
 geometries. |br|\
 The refinement directive specifies the list of atoms to be refined i.e. 
 the hydrogen atoms are omitted. The implicit specification used above
 would also work here since it automatically omits hydrogen atoms.
 #FINISH (or #END) closes CRYSTALS down.

::

 #FOURIER
 MAP TYP=DIFF
 PEAK HEIGHT=2
 END
 #PEAK
 END
 #COLLECT
 SEL TYPE=PEAK
 END
 #PERHYDRO
 END
 #LIST 12
 BLOCK SCALE O(1,X'S,U'S) UNTIL C(9)
 END
 #SFLS
 REFINE
 REFINE
 END
 #FINISH


The interested user might wish to delete the .dsc file which was created for this
example and start again by just importing NKET.QCK and then using the GUIDE to
complete the analysis.
 

..index:: Spacegroup Quiz
.. _Spacegroup quiz


***************
Spacegroup Quiz
***************
From the Tools menu, choose Space group quiz - a simple test of your understanding of 
space groups. 
|br|\
The files for this toy are SPACETEST*.SCP in \SCRIPT.  Feel free to add your own 
additional tests 




