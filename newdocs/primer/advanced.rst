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



###################
Advanced Facilities
###################


*************
DOCUMENTATION
*************
The main documentation is the Reference Manual.
While CRYSTALS is running, the user can also get various types of
information on-line.
 

^^^^^^^^^^
The Manual
^^^^^^^^^^
The Manual is voluminous but moderately complete and accurate. The
chapters are organised to roughly follow the path of an analysis, but
tables are appended to this guide as aide-memoires for commands and
data lists.
 

^^^^^^^^^^^^
On-line HELP
^^^^^^^^^^^^
The on-line documentation consists of text files giving tips and
advice.
 
::

     \HELP             HELP
 or
     \HELP             topic



^^^^^^^^^^^^^^^
Command summary
^^^^^^^^^^^^^^^
CRYSTALS uses a master system-data-base containig the definitions of all
COMMANDS  and LISTS. This can be interogated to get terse aide-memoires
of COMMANDS and LISTS.

=========
\COMMANDS
=========
This COMMAND should only be issued after any preceeding COMMANDS have
executed to completion. Its format is:
 
::

     \COMMANDS      commandname
 or
     \COMMANDS      LIST      listnumber


==============
Query facility
==============
Once a COMMAND is  initiated, information about its directives and
parameters can be obtained by starting a line with '?'. This facility will
not work if an error has occured during the input of the current COMMAND.
 
::

      \FOURIER
      ?
      ?MAP
      ?MAP            TYPE
      MAP             TYPE=DIFF
      END



In this example, the first ? produces a list of available directives, the
second a list of parameters for MAP, and the third a list of permitted map
types, and the default choice.  The amount of output available depends upon
the structure in the master database. 

 

*************
THE DATA BASE
*************
The users data base is held in the binary file CRFILEV2.DSC, called 'the disk'. This
file |blue| MUST NOT BE PRINTED. |xblue| It will grow with use, and cannot be shortened.
Instructions exist for recovering space within the disk. See the section
:ref:`Purging the disk <purging the disk>`  for details.  



^^^^^^^^^^^^^
Listing LISTs
^^^^^^^^^^^^^
The data in a CRYSTALS LIST can be examined with:
 
::

      \SUMMARY LIST n
      END
     Which sends a brief summary of LIST n to the terminal
 or
      \PRINT n
      END
     Which sends a detailed listing to the .LIS file.




.. _DISK Index:
.. index:: DISK Index 

^^^^^^^^^^^^^^^^^
Index to the disk
^^^^^^^^^^^^^^^^^
The disk index can be examined with
 
::

      \DISK
      PRINT
          or
      PRINT      DISK
      END


PRINT by itself lists the currently active lists |br|\
PRINT DISK lists all the LISTS in the .DSC file.

.._Recovering lists: 
.. index:: Recovering lists

^^^^^^^^^^^^^^^^^^^^^^^^^
Recovering previous lists
^^^^^^^^^^^^^^^^^^^^^^^^^
Whenever a LIST is stored in the disk, its serial number is incremented.
In general, previous lists are over written, but new parameters lists,
LIST 5, are always created. Previous versions can be made current or
active by 'resetting' to them. This is done either by giving their
absolute serial number, or a relative number.

 
::

      \DISK
      RESET       5       0      -1
      RESET       5      42
      END



The first reset steps back one to the previous parameter list. The second
reset (which of course supersedes the first), makes LIST 5 serial number 42
the current active version.
|br|\
There is a menu for resetting the active parameter list (LIST 5)
 
.. _purging the disk:
.. index:: Purging the Disk


^^^^^^^^^^^^^^^^^^^^^
Purging the disk file
^^^^^^^^^^^^^^^^^^^^^
The disc file slowly grows as lists are accumulated in it.
Non-currently
active lists can be eliminated with the PURGE instruction. Valuable
intermediate versions of lists, such as a good trial structure before an
experimental refinement, can retained by setting a flag.

 
::

      \DISK
      RETAIN 5   0  -1
      RETAIN 5      17
      END
      
      \PURGE
      END

      \PURGE new-name
      END

      \PURGE DATE
      END
 

The first RETAIN instruction retains the previous LIST 5, the second 
retains LIST 5 with the serial number 17/ |br|\
Purge by itself eliminates old versions of LISTS but does not shorten the .DSC
file. |br|\
PURGE new-name creates a new data-base new-name.DSC with a minimal size. Useful 
if you need to E-mail the DSC file. |br|\
PURGE DATE creates a data-base with the 'name' built from  the current
month-day-time, e.g. 10231145 for 23rd of October at 11.45



.. index:: Tailoring the Program
.. _tailoring the program:


*********************
TAILORING THE PROGRAM
*********************
The user has some control over the run-time aspects of the program.
Commands put into a CRYSINIT file in the current working folder are
automatically obeyed each time CRYSTALS is started. 
This file need not exist.
 

^^^^^^^^^^^^^^^^^^^^
General Instructions
^^^^^^^^^^^^^^^^^^^^

 
::

 \TITLE                       Any text for a title
 \USE CONTROL                 Skip the graphical startup mode
                              Useful if the structure has 'blown up' and
                              cannot be rendered. 
                              Try resetting to an old List 5
 \SET UEQUIV type             Geometric or arithmetric mean
 \SET PAUSE value             Pause interval after each 24 lines of OP
 \SET GENERATE state          Generate filename 'extensions'
 \SET LOG state               Control the logging of input
 \SET MONITOR state           Control monitoring of input
 \SET TIMING state            Enable timing messages
 \SET LIST   state            Messages about disc transfers
 \SET WATCH number            Select lists to watch
 \SET PRINTER state           On or Off

 

***************
File processing
***************
^^^^^^^^^^^^^^^^^^^^^^
Using and typing files
^^^^^^^^^^^^^^^^^^^^^^
When CRYSTALS is running, instructions stored in a data file can be executed
with:
 
::

             \USE  filename



To find out what is in a file without obeying it, issue:
 
::

            \TYPE  filename



CRYSTALS automatically hooks in suitable files or devices to input and output
channels. These can be changed while the program is running. For example, the
listings can be directed to a new file, so that the previous file can be
printed without stopping CRYSTALS. Output can also be directed to specially
named files, or devices. The command used is:

============================
\RELEASE devicename filename
============================
Permitted devices include:
 
::
      MONITOR   A brief listing of some operations
      PRINTER   The main listing file
      LOG       The copy (log) of all input
      PUNCH     An ASCII (card image) file



The filenames can be any system permitted file name.
If omitted, a new file with the  default name is opened, generally
over-writing the previous file. Exceptions are the log and listing files
which are generally set to auto-generate numbered versions.
The command
 
::

      \SET GENERATE ON



causes the second part of the file names to be modified to help reduce this
problem. This command could be put in the CRYSINIT file.
Under WINDOWS, all files for a given structure have the specific part
set to BFILE, and the extension identifies the type of file.
 
::

 e.g.
 \RELEASE PUNCH new-file Sends punch (ASCII) data to new-file.pch
 \RELEASE PRINTER        Closes the current .lis file and starts a new one
 \RELEASE LOG            releases the log file, which could then
                         be edited and used as input. A new log file is opened.
  


^^^^^^^^^^^^^^^^^^^^^^^^^
Automatic Disc extension.
^^^^^^^^^^^^^^^^^^^^^^^^^
If the .DSC file becomes full, CRYSTALS makes an attempt to extend it. The
number of attempts and the increment are set by the program installer. The
user can over-ride the defaults. The
following commands permit very substantial disk  extensions, suitablefor very 
large structures.
 
::

      \DISK
      EXTEND SIZE=10 TRIES=100
      END



 These commands could be put in the CRYSINIT file.
 

^^^^^^^^^^^^^^^
CRYSINIT files.
^^^^^^^^^^^^^^^
They contain commands the user
always wants executing when CRYSTALS starts in a particular folder.
The special instruction *\USE CONTROL* by-passes graphical mode startup.

 
::

      \ Disc extensions are set large.
      \DISK
      EXTEND FREE=100 SIZE=10 TRIES=100
      END
      \USE CONTROL



The file CRYSTALS.SRT, in the folder holding the CRYSTALS program, is a master
CRYSINIT file obeyed every time CRYSTALS starts for all structures. 
You may edit this, but take care.


*******
SCRIPTS
*******
The CRYSTALS SCRIPT environment rather like a command tree, with
a root, branches, twigs and finally leaves which perform discrete
crystallographic or data management operations. This sort of structure is
adopted so that related operations may be grouped together, making them
easy to locate. 
However, a basic operation may be strongly related to
several groups of operations, and must therefore appear on the menu for
each of these groups. The same leaf can be found on several different
branches In addition, it is sometimes useful to execute a 'leaf' quite
out of its normal context.
|br|\
This structured flexibility is provided by the SCRIPT processor,
and the CRYSTALS program is issued with an extensive set of scripts.
These build and control the graphical interface, but are
themselves only plain text data files, and users are free to modify
them in any way they wish, and add new ones. It is not possible for a
script to corrupt the CRYSTALS program.
|br|\
Scripts are generally executed from a menu, but they can also, with care, 
be executed from the command line.

 

^^^^^^^^^^^^^^^^^^^^^
Entering SCRIPT  mode
^^^^^^^^^^^^^^^^^^^^^
Control can be passed to  script mode by issuing the CRYSTALS command.
 
::

          \SCRIPT    scriptname



where scriptname is the name of the script required. 
 
::
 e.g.
        \SCRIPT  DISK



This (pre-gui) script give access to the most common operation on the .DSC file.

 

^^^^^^^^^^^^^^^^^^^^^^^^^
Escaping from SCRIPT mode
^^^^^^^^^^^^^^^^^^^^^^^^^
Control can be passed to the command mode at any time by replying DIRECT
(in full) to any SCRIPT question. The users is passed to the CRYSTALS prompt



----


=======================
\DISK - Disk management
=======================

 
::

 \DISK
 PRINT INDEX=
 MARKERROR LIST= SERIAL= RELATIVE= ACTION=
 RETAIN LIST= SERIAL= RELATIVE= ACTION=
 DELETE LIST= SERIAL= RELATIVE= ACTION=
 RESET LIST= SERIAL= RELATIVE=
 USAGE LIST= SERIAL= RELATIVE= FLAG=
 EXTEND RECORDS= FREE= TRIES= SIZE=
  


==========================================
\PURGE - Deletion of Old Versions of Lists
==========================================

 
::

 \PURGE FILE= INITIALSIZE= LOG=
 END






