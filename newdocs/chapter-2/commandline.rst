.. toctree::
   :maxdepth: 2
   :caption: Contents:


.. include:: ../macros.bit



.. _command-line: 


################
The Command Line
################
.. index:: Command Line

When |blue| CRYSTALS |xblue| starts, it loads the database (crfilev2.dsc) if it exists and 
renders an image of the structure, if it has been solved. CRYSTALS then sits waiting for 
instructions as to what to do next.
|br|\
These instructions are given in the form of |blue| COMMANDS, |xblue| possibly with some additional 
text or numerical data.  The command is executed and CRYSTALS returns to the waiting 
state.
|br|\
For convenience in day to day working, some of the COMMANDS and their associated data 
have been packaged up into |blue| SCRIPTS |xblue|, and some of these SCRIPTS have been 
made accessible via menus.

Many of the COMMANDS have a functionality beyond that which is needed for routine work, 
and so these advanced options do not appear in SCRIPTS.  It remains possible for the 
user to look up the details of a COMMAND in the MANUAL, and then to type the required 
information in via the COMMAND LINE near the bottom left of the screen.



.. _`Syntax of Commands`: 

******************
Syntax of Commands
******************
.. index:: Command syntax
.. index:: Syntax of Commands

Commands are given to CRYSTALS as small packages, rather like
sentences. This enables the program to recognise when the user thinks
that a piece of input is complete and then, after inserting any default values and checking
for errors, perform the task.


   
All command packages follow the same general format:
|br|\
The command is introduced with a special character followed **immediately** with the 
COMMAND name, and ends with the word 'END'.
The alternative permitted special characters are: "#", "\\\\" and "&" (for convenience on 
non-UK keyboards). The special character followed by a space and then text is treated
as a comment.
|br|\
A few COMMANDS include the directive |blue| EXECUTE |xblue| . This forces immediate 
processing of the preceeding directives. Otherwise, execution of the COMMAND is delayed 
until either a new COMMAND is started or the current command is terminated with an **END**

   
::

     \ This is a comment
     \COMMAND ([keyword=]value ) ...
     (DIRECTIVE ([keyword=]value ) ...)
     END
   

   
Items in    round brackets '()' may be absent, items in square brackets '[]' are
optional. Ellipsis '...' means the preceding item may be repeated.
|br|\
Actual data on a COMMAND or DIRECTIVE line is input in free format,
with at least one space (or sometimes an optional comma) terminating an
item. Data items may either be preceded with the keyword and its '=' sign,
or if the order given in the definition is strictly followed, just by
the data values. COMMANDS, DIRECTIVES and KEYWORDS can be abbreviated to
the minimum string which resolves ambiguity. Both types of identification can be 
intermingled. Text is not case sensitive and decimal points are optional for exact
real values (e.g. 2 is the same as 2.0).

::

 e.g. Cell parameter input

   REAL  10.4 12.3 19.5 90.0 113.7 90
   or
   REAL a=10.4 b=12.3 19.5  beta=113.7



|br|\
The following examples are all identical to the program. They use
the command \\DISTANCES to compute all interatomic distances in the range
0.0-1.9 Angstrom, and all interatomic angles involving bonds in the range
1.6-2.1 Angstrom.

* Example 1.  All the keywords are given explicitly. The order on the line is
  not important. The default order is *DMIN DMAX AMIN AMAX* 
  but in this example both *MIN* values are given before the *MAX* values.

::

      \DISTANCE
      SELECT RANGE=LIMITS
      LIMITS DMIN=0.0 AMIN=1.6 DMAX=1.9 AMAX=2.1
      END
   
* Example 2. Directives and keywords have been abbreviated or omitted completely.
  If the keywords are omitted, the parameter values must be given in the order
  specified in the manual, *i.e.* the distance limits are given before the angle limits.

::

      \DIS
      SE RA=LI
      LI 0.0 1.9 1.6 2.1
      EN
   
* Example 3.   The value for DMIN is omitted (its
  default value turns out to be 0.0) and the list of parameters starts
  with a DMAX: CRYSTALS knows that the next parameter is AMIN so it 
  need not be specified.

::

      \DIST
      SEL RANGE=LIM
      LIMI DMAX=1.9 1.6 2.1
      END


 
******************
Types of Commands:
******************
.. index:: Command types
.. index:: Types of Commands
.. index:: Types of Lists

^^^^^
Lists
^^^^^
These contain lists of related data items, grouped together so that CRYSTALS can
check that the data is complete. The final END causes these lists to be processed,
and if sysntactically valid, to be stored in the CRYSTALS database.
|br|\
The lists are called |blue| LISTS |xblue| and are 
identified by a number. Usually, input of a new list of a given type over-writes an
existing list of the same type. In general, LISTS do not 'do' anything. |br|\
|red| Take care when typing in a LIST. |xred| If you enter the wrong list number
(*e.g.* #LIST 6 wnen you meany #LIST 4) the LIST 6 (your reflections) will be
destroyed even if you abort the command.  There is no 'undo' for this.

   
There are two types of syntax for LISTS:
   
===========
Keyed LISTS
===========
Lists of (mainly) numeric data.  The data in each list are usualy closely related
(*e.g.* the atomic parameters). In these lists, CRYSTALS can know in advance how much and what kind of
input to expect. Each element of data is identified by an optional
keyword. See, for example, LIST 1 ( :ref:`LIST01`).

=============
Lexical LISTS
=============
Lists of descriptive (lexical) information. These are in a freer format, but are still
called LISTS. In these, CRYSTALS cannot know in advance what kind of data the user
may wish to input. Each line of input is processed by a lexical scanner,
and parsed to determine the action needed. See, for example, LIST 12 
(section :ref:`LIST12`).
|br|\
For a list of all the lists, see the Lists overview (section :ref:`LISTS`).
   

^^^^^^^^
Commands
^^^^^^^^
Commands  cause CRYSTALS to 'do' something, for example, compute a Fourier
map. There are two type of syntax for commands, similar to those used
for LISTS.  The computation is not started until the terminating END is read.

==============
Keyed Commands
==============
In these, CRYSTALS can know in advance how much and what kind of
input to expect - see for example \\DISTANCE (above)

================
Lexical Commands
================
In these, CRYSTALS cannot know in advance what kind of operation the user
may wish to compute. Each line of input is processed by a lexical scanner,
and parsed to determine the action needed. See for example \\FOURIER.



^^^^^^^^
CONTINUE
^^^^^^^^
The command CONTINUE indicates that the data on the current line is a
continuation of the previous line.  Using the rules for abbreviating commands,
it can usually be shortened to *CONT*.


.. _Immediate Commands:
   
******************
Immediate Commands
******************
.. index:: Immediate Commands
.. index:: Set (something)

These are special commands which are acted upon immediately they are
issued. They are never more than one line long, and must not have an
'END'. They can be issued whenever the cursor is at the beginning of a
line, even inside a COMMAND or LIST. They are not usually involved with
the crystallographic calculation, but control some aspect of the way
CRYSTALS works, such as hooking in an external data file, or changing
the amount of output produced.
|br|\


.. _tailoring the program:
.. _crysinit:

^^^^^^^^^^^^^^
CRYSINIT Files
^^^^^^^^^^^^^^
.. index:: The CRYSINIT File
.. index:: Tailoring the Program

The user has some control over the run-time aspects of the program.
Commands put into a CRYSINIT file in the current working folder are
automatically obeyed each time CRYSTALS is started. 
This file need not exist.
|br|\
There is also a system-wide initialisation file (CRYSTALS.SRT) in 
the same folder as the CRYSTALS executable. Commands added to this 
file will be executed every time CRYSTALS is started. If you do edit
this file take great care - errors may make CRYSTALS inoperable.

::

      \ ..... COMMENTS ....
      \TITLE Text to be used as a title.

   File Operations
      \APPEND devicename filename
      \CLOSE devicename 
      \FLUSH devicename 
      \OPEN devicename filename
      \RELEASE  devicename filename
      \SCRIPT filename
      \TYPE  'filename'
      \USE source
      \SET FILE type
      \SET LOG state
      \SET PRINTER state
      \SPAWN      'shell command'
      $      'shell command'

   Miscelaneous
      \BENCH nparam nref
      \COMMANDS   command
      ? text
      \END
      \FINISH
      \PAUSE interval
      \SET RATIO state
      \SET UEQUIV state

   List Operations
      \SET LIST   state
      \SET WATCH number
      \SET EXPORT state

   System defaults and monitoring
      \SET GENERATE state
      \SET MESSAGE state
      \SET MIRROR state
      \SET MONITOR state
      \SET OPENMESSAGE state
      \SET SRQ state
      \SET TIME state

   Obsolete
      \MANUAL  'name'
      \HELP   'topic'
      \SET COMMUNICATION speed
      \SET TERMINAL device
      \SET PAGE length
      \SET PAUSE value



^^^^^^^^
Comments
^^^^^^^^

::

 \ .....Text ....

Any data line starting with a backslash or hash followed immediately with
a space is ignored, and may thus be used as a comment, or to deactivate
the line without deleting it from the file.
The remaining columns (3-80) may be used for a descriptive comment.
Such a comment line may appear at any point in the input.  |br|\
COMMENTS are discarded during input and so will not appear inside the
stored version of lexical lists (*e.g.* LIST 16). In this situation 
comment lines should start **REM** (by analogy with the old BASIC 
programming langauge remark statement).
   
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
\\TITLE ..... A title to be printed .....
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This command sets the title that appears in the output files.
The characters  *\\TITLE*  are terminated by a space in
column 7 and the remainder of the line contains the text.
    
^^^^^^^^^^^^^^^
File Operations
^^^^^^^^^^^^^^^
.. index:: File Operations

CRYSTALS uses a large number of files for both input and output.  The 
files are associated with the *device* which either reads or writes them.
For example, some verbose text output is sent to a *Printer*.  
This is no longer a real printer, 
but the file which is created could be printed on a device supporting 132 column wide 
paper - perhaps A4 in landscape mode.
|br|\

============
Device Names
============
.. index:: Device Names


::

 Devices used for input.   
   
   CONTROL  - Source of commands being input. This is usually the command input line
   but can also be a file if you type   \USE filename
   HKLI     - A file containing reflections to be input using \LIST 6 or \HKLI.

 Devices used for output

   PRINTER  - the listing file (bfile#nn.lis by default)
   PUNCH    - the punch file (bfile.pch by default - generations are not created)
   LOG      - record of all commands issued (bfile#nn.log by default)
   MONITOR  - Copy of text that appears on the screen (bfile.mon)

 Devices used for CRYSTALS own purposes.

   DISCFILE - the CRYSTALS database (e.g. crfilev2.dsc) containing everything for 
              the current structure.
   NEWDISC  - a second database, created during \PURGE commands.
   COMMANDS - the file commands.dsc defines the syntax and data 
              structures of all the commands and lists.  It lives in the same folder
              as the CRYSTALS executable, and should never be tinkered with.
   M32 M33 MT1 MT2 MT3 MTE - scratch files (formerly real magnetic tapes!)
   SRQ      - system request queue. Some high-level commands 
              may issue other CRYSTALS commands using this file.
   FORN1, FORN2 - output of data for 'foreign' (ie. external) 
              programs.
   SCPDATA  - scripts can read directly from any file opened on
              this device (using EXTRACT script command)
   SCP2     - scripts can read directly from any file opened on
              this device (using EXTRACT2 script command)s
   SCPQUEUE - stores commands that scripts are building up.

   
Not all may be opened/closed by the user from a command prompt. Some are
only available inside the initialisation file CRYSTSLS.SRC 


.. _Use Source:


============
\\USE source
============
If 'source' is a filename then commands are read from that file.
|br|\
If 'source' is **LAST** ,the current USE file is closed and
commands are read from the previous level USE file.
|br|\
If  'source' is **CONTROL**  , all USE files currenlty open are closed and
commands are read from the main control
stream for the job , for example the terminal in an interactive job.
|br|\
   
One USE
file may contain other USE commands. The maximum depth of USE
files  allowed will be installation dependent.
Note that the USEd file need not be a complete list - it can be as little
as only one line.
If a *USE* file does not end with 
*\\USE LAST* , *\\USE CONTROL* , or *\\FINISH*, control reverts to the previous
input source once the *USE* file is exhausted.


==========================
\\OPEN devicename filename
==========================

::

      e.g.
      \OPEN HKLI reflection.hkl

This example connects the named file to the device (HKLI) used for reading reflections.
Similarly, permanent
files may be used in data reduction work by using the device names M32 and M33 and
overriding the default scratch files.

==============================
\\RELEASE  devicename filename
==============================
The file currently open on 'devicename' is closed, and a new file opened
on that device. The file just closed can be examined using an editor.
The filename parameter is optional. 
Useful devices currently available include PRINTER, PUNCH, LOG and MONITOR.
If a filename is given, subsequent output will be to that file.
If a filename is not given and the  device is *PRINTER* or *LOG* a new file
with an augmented filename will be created.

::

      \RELEASE PRINTER

will cause the current print file, perhaps bfile.lis, to be augmented to
bfile#00.lis. 



============================
\\APPEND devicename filename
============================
Output to the specified device is appended to any output already in
the specified file.
  
 
==================
\\CLOSE devicename 
==================
Any file on the specified device is closed.  The file can be reopened from its begining
with a new \\OPEN statement.

      
===================
\\FLUSH devicename 
===================
The text output from CRYSTALS is written to the output devices listed above. The user may 
wish to see the contents of one of these files without closing down CRYSTALS, 
perhaps in order to see in more detail the results of a calculation.
This can be done using a suitable 
editor (*e.g.* Notepad).  The computer usually stores output secretly (called buffering)
and only actually outputs the information to the file in large blocks. This instruction tells 
the computer to flush the latest buffered information to the specified device immediately
so that it can be seen with an editor.

::

      e.g.
      \FLUSH LOG
      \FLUSH PRINT

   

=================
\\SCRIPT filename
=================
This command passes control to the named script file. 
|br|\
|blue| SCRIPT |xblue| files are used to create dialogues between CRYSTALS and the user, to 
create menus, or to cause the execution of preset sequences of COMMANDS. The are text 
files, and the careful user can modify them for their own purposes.

==================
\\TYPE  'filename'
==================
The file 'filename' is typed on the users terminal without its contents
being interpreted by CRYSTALS, giving the user a method of previewing a USE file.


===============
\\SET FILE type
===============
This command is used to control the case of file names generated
by CRYSTALS. Possible values for *type* are:
   
   ::

       LOWER        Filenames are converted to all lower case.
       UPPER        Filenames are converted to all upper case.
       MIXED        Filenames are left as input or defined.


===============
\\SET LOG state
===============
::

 If state = ON  then all user input commands are written to the log file (bfile#nn.log)
 If state = OFF then subsequent commands are not written  to the log. Any change made to
                the log state applies only to the current level of USE file and any 
                USE file called by it.



Because the log file is a direct copy of the users commands, it may
subsequently be used (probably after modification) as a control file.



===================
\\SET PRINTER state
===================
This command is used to control output to the 'printer' file. The
state   **OFF** suppresses printer output, **ON** resumes sending text
to the printer.

============================
\\SPAWN      'shell command'
============================
A 'shell command' can be issued from inside CRYSTALS with this command.
Typical examples are:  $notepad,  $firefox something.html.
|br|\
SCRIPTS use SPAWN to run external programs such as PLATON, Mogul etc. 

======================
$      'shell command'
======================
A 'shell command' can be issued from inside CRYSTALS with this command.
Typical examples are:  $notepad,  $firefox something.html.



 

^^^^^^^^^^^^
Miscelaneous
^^^^^^^^^^^^

   
===================
\\BENCH nparam nref
===================
This simulates structure factor least squares, 
i.e. a cycle of refinement.
to enable processor speeds to be compared. See :ref:`Benchmark under Menus <benchmark>`

::

      nparam defaults to 500
      nref   defaults to 5000


Times for a Microvax 3800 (circa 1995) are printed for comparison.

====================
\\COMMANDS   command
====================
This command, which takes other command-names as a parameter 
(without the \\ ), produces a listing of the available parameters,
keywords and defaults for those commands. The listing is
derived directly from the 'command file', and is thus
completely up to date for the program being run. This command will
not operate correctly if the preceding command ended in error. Clear
the error flag by performing some successful operation.
The facility
is an aide-memoire, and not intended to replace the manual.
The full significance of the output is detailed in :ref:`crysdatabase` .

==============
? Command-name
==============
This facility allows the user to make brief inquiries from the command
file on the commands, directives, and parameters available at the
current point in the job. 

* If a command is not being processed, and
  **?** is entered alone, a list of the commands is displayed. 
* If **? COMMAND**
  is entered, a list of the directives available with that command is
  displayed. 
* If **? COMMAND DIRECTIVE** is entered, a list of parameters for
  the given command and directive is displayed, and so on.

   
If a command is currently being processed, the behaviour is similar,
but no command name is allowed. Then **?** alone gives a list of 
directives, while **? DIRECTIVE** gives a list of parameters, and so 
on. In this case care should be taken: After a **?**, CRYSTALS loses track
of the last parameter that was input so using CONTINUE
will have unpredictable results. To work around this, specify the parameter
explicitly on the command line, for example:
::

      \EDIT
      \              Start entering a new atom to be added to the model:
      ATOM U 1.0
      \              Refresh your memory as to the rest of the syntax:
      ?atom
      \              Carry on entering the atom, but give the 
      \              parameter name, X, explicitly.
      CONTINUE X=0.2 0.4 0.5
      END
   

=====
\\END
=====
This command closes down CRYSTALS neatly.

========
\\FINISH
========
This command closes down CRYSTALS neatly.

================
\\PAUSE interval
================
This command causes the program to wait for *interval* seconds before
proceding. The maximum value of *interval* is 200 seconds. It might be
useful in a *USE* file to enable the user to digest some intermediate output
before the computation continue.

=================
\\SET RATIO state
=================
This command controls whether Io or Ic is compared with Sigma(Io) 
during filtering. *state*  is Io or Ic, default is Io.
|br|\
See "The use of partial observations, partial models and partial residuals
to improve the least-squares refinement of crystal structures."
A. David Rae, Crystallography Reviews, 2013. Vol. 19, No. 4, 165.

   
Io is appropriate during initial stages of an analysis, but once the R factor
drops below 10-15%, Ic gives an unbiassed filtering of the weak reflections. A
threshold ratio of 1 or 2 is useful if there are a very large number of very
weak reflections scattered throughout the data set, otherwise use a resolution
threshold,  :math:`(\sin\theta/\lambda)^2` .
   

==================
\\SET UEQUIV state
==================
This controls the calculation of Uequiv. Both definitions are acceptable
to Acta. The arithmetic mean of the principle axes is often similar
to the refined value of Uiso. The geometric mean is more sensitive to
long or short axes, and so is more useful when evaluating a structure.
::

            ARITH = (U1+U2+U3)/3
            GEOM  = (U1*U2*U3)**1/3
   

^^^^^^^^^^^^^^^
List Operations
^^^^^^^^^^^^^^^
.. index:: List Operations

Enables the User (or more likely, the programmer) to see which LISTS are being 
fetched from and written to the database.

==================
\\SET LIST   state
==================
This command allows the user to control the monitoring level
of transfer of lists to and from the database
in conjunction with the SET WATCH command. 
   
::

      OFF, no list logging information is produced.
      READ or WRITE, list logging information is only produced when lists are    
           read or written respectively.
      BOTH, both reading and writing  operations will be monitored. Note that 
           the logging operation may be qualified by a list type specified by SET WATCH. 



==================
\\SET WATCH number
==================
This command is used in conjunction with SET LIST to control monitoring
of list operations. If *number* is 0, operations on all list types will be
monitored, according to the state set with SET LIST. If *number* is a positive
integer, representing a list type, only operations on that list type will
be monitored. 
   


==================
\\SET EXPORT state
==================
If 'state' is 'on' then all the curent LISTS are copied to a file *EXPORT.CRY*
when CRYSTALS closes down. These can be archived for safety, or exported
to another computer. Editing the line
|br|\
\\SET EXPORT OFF
|br|\
to **ON** will automatically export the data eachtime CRYSTALS closes. 
A previous EXPORT.CRY file will be over-written. To get this action every
time CRYSTALS closes in a given folder, the folder should contain a CRYSINIT.DAT
file which include \\SET EXPORT ON.  If you want to export the file for every
CRYSTALS folder, you should include the SET command in  a file CRYSTART.DAT in
the same folder as the CRYSTALS executable.
|br|\
Note that :ref:`Export Archive Files <export archive files>` 
in the *RESULTS* menu exports all lists on demand.


^^^^^^^^^^^^^^^^^
System Monitoring
^^^^^^^^^^^^^^^^^
These Immediate Commands are usually used by programmers during software development.
   
====================
\\SET GENERATE state
====================
This command is used to control the generation of output file names
and pseudo-generation numbers on
non-VMS systems.  By default, CRYSTALS modifies the root of filenames
for files which should not be overwritten (normally .LIS, .LOG).
|br|\
OFF suppresses automatic name generation.

===================
\\SET MESSAGE state
===================
This command is used to indicate to the program whether the command
messages usually produced at the end of each facility are produced. If
'state'
is "OFF" the messages are not displayed. If 'state' is "ON" the messages
are displayed. Error messages are always displayed.

==================
\\SET MIRROR state
==================

::

   If 'state' = ON, then all input is reflected in the monitor or list file.
   If 'state' = OFF, monitoring is suppressed. Any change made to
      the monitoring state applies only to the current level of USE file and
      any   USE file called by it.


===================
\\SET MONITOR state
===================

::

       OFF  suppresses all screen output 
       ON   copy screen output to monitor
       SLOW copy all screen output PLUS output for graphics to monitor.
            (Mainly used for debuging graphics)
       FAST Only sends selected output to the screen. Status reverts to
            ON if an error condition occurs.

   
=======================
\\SET OPENMESSAGE state
=======================
This command is used to enable or disable file handling messages.
OFF suppresses messages.


===============
\\SET SRQ state
===============
This command is used to control mirroring of CRYSTALS internal commands.
The normal state OFF suppresses the mirroring.


================
\\SET TIME state
================
This command is used to indicate to the program whether the timing
messages produced at the end of each facility are displayed. If
'state'
is "OFF" the messages are not displayed. If 'state' is "ON" the messages
are   displayed.


^^^^^^^^
Obsolete
^^^^^^^^
These Immediate Commands have no functionality in the current MS Windows implementation.

================
\\MANUAL  'name'
================
   The 'name' parameter is the name of the volume whose index is required.
   The
   special name 'INDEX' gives a list of subjects for each volume. The special
   name 'LISTS' gives a list of the function of each LIST.

================
\\HELP   'topic'
================
   
   The topic 'HELP' contains a list of topics for which help is given. This
   is likely to be very site-specific.

   
=========================
\\SET COMMUNICATION speed
=========================
   This command is used to indicate to the program the speed of the
   communication line or terminal
   on which it is being run. This indication is used by some facilities to
   determine how much output to produce on the monitor channel. The possible
   values for the speed are "SLOW" and "FAST". These keywords are not associated
   with any particular terminal speed, and the appropriate value will depend
   on
   the user's patience. The initial value is "FAST"


=====================
\\SET TERMINAL device
=====================
   This command controls the display of SCRIPT menus on some
   terminals. Possible device types are
   
   ::

       UNKNOWN This is the default, and requires no special terminal.
       VT52    For use on terminals with limited screen management facilities.
       VT100   For use on advanced terminals.
       VGA     For use on PC VGA terminals
       WIN     For use under Win32 and X-windows.

=================
\\SET PAGE length
=================
This command is used to change the length of the assumed 'page' when
displaying files on the monitor channel, using the commands 'HELP', 'MANUAL',
and 'TYPE'. The initial length is 20 lines. After the number of lines
specified have been typed, the listing stops and a message indicates the
program is waiting. A blank line or carriage return
at this point will cause the listing to
continue. Any other input is executed normally. If the length is set to
zero,
or a negative number, the feature is disabled.


=================
\\SET PAUSE value
=================
   This command sets a time, in seconds, for which the program will pause
   at
   the end of each screen full of output. It is only effective on DOS machines,
   and enables the user to use the 'pause' key to hold a selected screen.
   The maximum value of 'interval' is 200 seconds.
