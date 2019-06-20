.. toctree::
   :maxdepth: 3
   :caption: Contents:



#################
Files and Folders
#################





.. _defandconv:

.. |br| raw:: html

   <br />

.. |blue| raw:: html
   
   <font color="blue">

.. |xblue|  raw:: html

   </font>

.. |vspace|  raw:: latex

   \vspace{5mm}



.. index:: Organising your data

.. index:: Files and Folders

.. _Files and Folders:

***************************************
Organising your data: Files and Folders
***************************************

::

 (for my info only - todo list)
 see crystals/intro.rst#files
 see crystals/manual/readme.man
 see crystals/manual/primer.man
 see crystals/manual/guide.man#yfiles
 see crystals/manual/guide.man#yinitilisation
 see crystals/manual/crystals.man#yfiles



* Organising your Data:
  |br|\
  **Do not run CRYSTALS** directly on your desktop.  CRYSTALS creates many files
  during each task.  The best way to keep control of them is to create a separate 
  folder  for each new structure. You might choose to put a master folder in 
  *My Documents* or on the desktop, and put the individual structural folders 
  into that.
  |br|\
  Each structure folder will contain some sub-folders:

  #. data.  This folder contains various text file of information created by
     CRYSTALS mainly during inital reflection processing, and used to create
     graphs.
  #. logs. Text files containing copies of the input information and more detailed
     output than was sent to the screen and 
     which you might want to refer to if things go wrong.
  #. tmp. temporary files.
  |br|\
  |br|\

* Raw Data:
  |br|\
  You must have a file containing the reflections as F or F :superscript:`2` corrected
  for geometrical factors (Lp and absorption corrections) and preferably on a common
  scale. CRYSTALS has its own format for such a file (LIST 6 format) but can also
  process files in the SHELX *hklf4* and *hklf5* formats, and *cif* (*fcf*) formats.
  |br|\
  See the section :ref:`LIST 6` for more details.
  |br|\
  |br|\

  You will also need the unit cell parameters, space group information and empirical
  formula.  These can be in  *cif* or *fcf* files, in SHELX *ins* or *res* files,
  or can be input to CRYSTALS manually via the GUI or by preparing a datafile. 
  |br|\
  See the section :ref:`Basic Data` for more details.
  |br|\
  |br|\

* The *DSC* file:
  |br|\
  CRYSTALS accumulates information as it works, which means that if you stop working 
  on a structure, you can restart the task from where you left off - a bit like 
  creating a big WORD document. The accumulated data is stored in a binary database 
  *something.dsc*. By default, the something is *crfilev2.dsc*. 
  |br|\
  Like a WORD document, this file is a proprietary binary database and |blue| MUST NOT |xblue| 
  be accessed by any other program   than CRYSTALS.
  |br|\
  COMMANDS are provided to enable you to see and modify the contents of this file, and
  in particular to regress to earlier versions of the structure.
  |br|\
  See the section :ref:`Structure Database` for more details.
  |br|\
  |br|\

* The Output Files:
  |br|\
  In addition to the binary *dsc* file, CRYSTALS creates several plain text output files.

  * The listing file: The file *bfile.lis* is the principal plain text output from 
    CRYSTALS.  It mirrors all of the user-input and all of the output from the 
    calculations.  A sub-set of this information, usually sufficient to enable the user to
    verify how the work is proceeding, appears in the GUI text window.  If things go
    catastrohically wrong the cause may sometimes be found in the listing file.
    |br|\
    Because the listing file records the history of an analysis, if CRYSTALS is stopped 
    and re-started, the listing file is not over-written, but output is sent to a new 
    text file *bfilenn.lis* , where *nn* is a decimal number, incremented each time a 
    new file is started.
    |br|\


  * PUNCH files:  CRYSTALS may output plain text files in formats suitable for input to
    other programs, or for re-input to CRYSTALS.  These files may have special names if
    they are ear-marked for special purposes, but the generic name is *bfile.pch*.

    * initial.dat  Copy of the data and instructions used to start a new structure.
    * publish.cif  cif file to accompany a publication.
    * publish.fcf  fcf file to accompany a publication.
    * ARCHIVE-HKL.CIF  Archive of the reflection data before removal of systematic
      absences or merging of equivalent reflections.
    * CAMERON.*  Files enabling CRYSTALS and CAMERON to communicate with each other.
    * histogram.dat  Data reduction information.
    * mergingr.dat  Data reduction information.
    * moo2.dat  Data reduction information.
    * sigmas2.dat  Data reduction information.

    |br|\

  * The LOG file, bfile.log:  This is an (almost) verbatim copy of information which
    has been input to CRYSTALS during the current session. It can sometimes be re-named 
    and edited to create a file useful for re-inputting to CRYSTALS.

* Input Files:
  |br|\
  CRYSTALS itself only accepts input in the *LIST* format (see the section :ref:`Lists` ).
  However utilities packaged with CRYSTALS will pre-process SHELX *ins* and *res* files 
  and *cif* and *fcf* files into LIST format. The generated files have the extension 
  *\*.cry*.
  |br|\
  See :ref:`Inputting Data`
  |br|\




