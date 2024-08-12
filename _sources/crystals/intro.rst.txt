.. toctree::
   :maxdepth: 1
   :caption: Contents:
   



***************************
Definitions And Conventions
***************************


.. index:: Command syntax


.. index:: Syntax


.. _defandconv:

 

==================
Syntax of Commands
==================

Commands are given to CRYSTALS as small packages, rather like
sentences. This enables the program to recognise when the user thinks
that a piece of input
is complete and then, after inserting any default values and checking
for errors, perform the task.



------------------
Format of Commands
------------------


   
   All command packages follow the same general format. The command is
   introduced
   with a backslash (or alternatively, a hash symbol) and ends with the
   word 'END'.
   
   ::


            \COMMAND ([keyword=]value ) ...
            (DIRECTIVE ([keyword=]value ) ...)
            END
   


   
   Items in
   round brackets '()' may be absent, items in square brackets '[]' are
   optional. Ellipsis '...' means the preceding item may be repeated.

   
   Actual data on a COMMAND or DIRECTIVE line is input in free format,
   with at least one space (or sometimes an optional comma) terminating an
   item. Data items may either be preceded with the keyword and its '=' sign,
   or if the order given in the definition is strictly followed, just by
   the data values. COMMANDS, DIRECTIVES and KEYWORDS can be abbreviated to
   the minimum string which resolves ambiguity.
   Both types of identification can be intermingled.

   
   The following examples are all identical to the program. They use
   the command \\DISTANCES to compute all interatomic distances in the range
   0.0-1.9 Angstrom, and all interatomic angles involving bonds in the range
   1.6-2.1 Angstrom.
   
   ::


            \DISTANCE
            SELECT RANGE=LIMITS
            LIMITS DMIN=0.0 DMAX=1.9 AMIN=1.6 AMAX=2.1
            END
   


   
   
   ::


            \DIS
            SE RA=LI
            LI 0.0 1.9 1.6 2.1
            EN
   


   
   
   ::


            \DIST
            SEL RANGE=LIM
            LIMI DMAX=1.9 1.6 2.1
            END
   


   
   
   Note that in the last example, the value for DMIN is omitted (its
   default value turns out to be 0.0) and the list of parameters starts
   with a DMAX: CRYSTALS knows that the next parameter is AMIN so it 
   need not be specified.
   
   

====================
Syntax of the manual
====================


Those parts of the manual describing data and command input will
generally be in the following format:
::


         1. A summary of the complete command, with all directives and
            keywords. Ellipsis (...) may be printed to represent omitted
            but similar parameters.
         2. An typical example. This may not demonstrate all the available
            options
         3. A description of all the directives and keywords.




For a simple example, see LIST 1, section :ref:`LIST01`.

.. index:: Command types


==================
Types of Commands:
==================


-----
Lists
-----


   
   These contain related data items, grouped together so that CRYSTALS can
   check
   that the data is complete. These lists are stored in the CRYSTALS
   database. Usually, input of a new list of a given type over-writes an
   existing list of the same type. In general, LISTS do not 'do' anything.

   
   There are two types of syntax for LISTS:
   

**Keyed LISTS**



   
   In these, CRYSTALS can know in advance how much and what kind of
   input to expect. Each element of data is identified by an optional
   keyword. See, for example, LIST 1 (section :ref:`LIST01`).
   

**Lexical LISTS**



   
   In these, CRYSTALS cannot know in advance what kind of data the user
   may wish to input. Each line of input is processed by a lexical scanner,
   and parsed to determine the action needed. See, for example, LIST 12 
   (section :ref:`LIST12`).

   
   For a list of all the lists, see the Lists overview (section :ref:`LISTS`).
   
   

--------
Commands
--------


   
   These cause CRYSTALS to 'do' something, for example, compute a Fourier
   map. There are two type of syntax for commands, similar to those used
   for LISTS:
   

**Keyed Commands**


   

**Lexical Commands**


   
.. _immediate:

 

------------------
Immediate Commands
------------------


   
   These are special commands which are acted upon immediately they are
   issued. They are never more than one line long, and do not require an
   'END'. They can be issued whenever the cursor is at the beginning of a
   line, even inside a COMMAND or LIST. They are not usually involved with
   the crystallographic calculation, but control some aspect of the way
   CRYSTALS works, such as hooking in an external data file, or changing
   the amount of output produced.
   
   

--------
Comments
--------

   Any data line starting with a backslash or hash followed immediately with
   a space is ignored, and may thus be used as a comment, or to deactivate
   the line without deleting it from the file.
   
   
   
   

------------------
Continuation Lines
------------------

   The directive CONTINUE indicates that the data on the current line is a
   continuation of the previous line.
   
   
   
.. index:: Immediate commands


==================
Immediate commands
==================


--------
\\FINISH
--------


   
   This command closes down CRYSTALS neatly.
   

----------------------
\\ ..... COMMENTS ....
----------------------


   
   This is a comment line. Column 1 contains the  \\  character and
   column 2 **must** be left blank.
   The remaining columns (3-80) may be used for a descriptive comment.
   Such a comment line may appear at any point in the input.
   

-----------------------------------------
\\TITLE ..... A title to be printed .....
-----------------------------------------


   
   This command changes the title that appears at the start of every
   operation. The characters  \\TITLE  are terminated by a space in
   column 7 and the remainder of the line contains the title.
   

------------------
\\TYPE  'filename'
------------------


   
   The file 'filename' is typed on the users terminal without its contents
   being interpreted by CRYSTALS. Thus \\ commands in this file are NOT
   acted on, giving the user a method of previewing a USE file.
   

------------
\\USE source
------------


   
   This command controls the source of commands for CRYSTALS.
   If 'source' is a filename then commands are read from that file.
   If 'source' is LAST ,the current USE file is closed and
   commands are read from the previous level USE file.
   If  'source' is CONTROL  , all USE files open are closed and
   commands are read from the main control
   stream for the job , for example the terminal in an interactive job.

   
   One USE
   file may contain other USE commands. The maximum depth of USE
   files  allowed will be installation dependent.
   Note that the USEd file need not be a complete list - it can be as little
   as only one line.
   An indirect file should end with '\\USE LAST' , '\\USE CONTROL' , or '\\FINISH'
   .
   This command is only available in some implementations.

-----------------
\\SCRIPT filename
-----------------


   
   This command is only available in interactive mode, and passes control
   to the 'script' file, which tries to assist the user by prompting him
   for data and information. A separate manual describes the writing of
   user define scripts.

----------------------------
\\SPAWN      'shell command'
----------------------------


   
   A 'shell command' can be issued from inside CRYSTALS with this command.
   \\SPAWN without a command spawns a sub-process and passes control of the
   sub-process to the terminal. Return to CRYSTALS by closing the
   sub-process.

----------------------
$      'shell command'
----------------------


   
   A 'shell command' can be issued from inside CRYSTALS with this command.
   Typical examples are: $dir, $notepad, $edit afile, $netscape something.html
   
   

--------------------
\\COMMANDS   command
--------------------


   
   This command, which takes other command-names as a parameter 
   (without the \\ ), produces a listing of the available parameters,
   keywords and defaults for those commands. The listing is
   derived directly from the 'command file', and is thus
   completely up to date for the program being run. This command will
   not operate correctly if the preceding command ended in error. Clear
   the error flag by performing some successful operation.
   The facility
   is an aide-memoire, and not intended to replace the manual.
   The full significance of the output is detailed in section
   :ref:`crysdatabase` on the CRYSTALS database.

------
? text
------


   
   This facility allows the user to make brief inquiries from the command
   file on the commands, directives, and parameters available at the
   current point in the job. If a command is not being processed, and
   '?' is entered alone, a list of the commands is displayed. If
   '? command'
   is entered, a list of the directives available with that command is
   displayed. If '? command directive' is entered, a list of parameters
   for
   the given command and directive is displayed, and so on.

   
   If a command is currently being processed, the behaviour is similar,
   but no command name is allowed. Then '?' alone gives a list of 
   directives, while '? directive' gives a list of parameters, and so 
   on. In this case care should be taken: After a '?', CRYSTALS loses track
   of the last parameter that was input so using CONTINUE
   will have unpredictable results. To work around this, specify the parameter
   explicitly on the command line, for example:
   ::


        \EDIT
        \  Start entering a new atom to be added to the model:
        ATOM U 1.0
        \  Refresh your memory as to the rest of the syntax:
        ?atom
        \  Carry on entering the atom, but give the 
        \ parameter name, X, explicitly.
        CONTINUE X=0.2 0.4 0.5
        END
   


   

----------------
\\MANUAL  'name'
----------------


   
   The 'name' parameter is the name of the volume whose index is required.
   The
   special name 'INDEX' gives a list of subjects for each volume. The special
   name 'LISTS' gives a list of the function of each LIST.
   

----------------
\\HELP   'topic'
----------------


   
   The topic 'HELP' contains a list of topics for which help is given. This
   is likely to be very site-specific.
   
   
   

------------------------------
\\RELEASE  devicename filename
------------------------------


   
   The file currently open on 'devicename' is closed, and a new file opened
   on that device if necessary. The file just closed can be examined using
   the \\TYPE command. The filename parameter is optional. If it is
   specified, the new file will be opened with that name.

   
   Useful devices currently available include PRINTER, PUNCH, LOG and MONITOR.
   
   
   
   

--------------------------
\\OPEN devicename filename
--------------------------


   
   This command is similar to RELEASE, except that a wider range of
   device
   names may be specified, and different messages are produced. An important
   facility available with this command is to open a named HKLI file, for
   the reflection input
   commands HKLI and LIST 6, using the device name HKLI. Similarly permanent
   files may be used in data reduction work by using the device names M32
   and M33
   overriding the default scratch files.
   ::


            e.g.
            \OPEN HKLI reflection.hkl
      
   


   
   
   
   

-------------------
\\CLOSE devicename 
-------------------


   
   Any file on specified device is closed.
   
   
   

----------------------------
\\APPEND devicename filename
----------------------------


   
   Output to the specified device is appended to any output already in
   the specified file.
   
   
   
   
   
   

-------------------
\\FLUSH devicename 
-------------------


   
   Buffered output on the specified device is flushed to the connected file
   so that it can be seen with an editor.
   ::


            e.g.
            \FLUSH LOG
            \FLUSH PRINT
      
   


   
   

------------
Device names
------------


   
   Devices are names used inside CRYSTALS to refer
   to files that it has opened. Deviecs recognised by CRYSTALS are:
   
   
   
   DISCFILE - the database containing everything.
   
   HKLI     - an hkl file during input using \\LIST 6 or \\HKLI.
   
   CONTROL  - commands being input (can be a file if you type
   \\USE filename, but is usually the command input line)
   
   PRINTER  - the listing file (bfilenn.lis by default)
   
   PUNCH    - the punch file (bfilenn.pch by default)
   
   LOG      - record of all commands issued (bfile.log by default)
   
   MONITOR  - Copy of text that appears on the screen
   
   SPY      - obsolete, used to collect usage data (locally!).
   
   NEWDISC  - a second database, open during \\PURGE commands.
   
   COMMANDS - the file commands.dsc defines the syntax and data 
   structures of all the commands and lists.
   
   M32 M33 MT1 MT2 MT3 MTE - scratch files
   
   SRQ      - system request queue. Some high-level commands 
   may issue other CRYSTALS commands using this file.
   
   FORN1, FORN2 - output of data for 'foreign' (ie. external) 
   programs.
   
   SCPDATA - scripts can read directly from any file opened on
   this device (using EXTRACT script command)
   
   SCP2 - scripts can read directly from any file opened on
   this device (using EXTRACT2 script command)s
   
   SCPQUEUE - stores commands that scripts are building up.
   
   
   Not all may be opened/closed by the user from a command prompt. Some are
   only available inside the initialisation file CRYSTSLS.SRC (See STORE
   below).
   

----------------
\\PAUSE interval
----------------


   
   This command causes the program to wait for 'interval' seconds before
   proceding. The maximum value of 'interval' is 200 seconds. It might be
   useful in a 'USE' file.
   

-------------------
\\BENCH nparam nref
-------------------


   
   This simulates sfls (structure factor least squares, 
   i.e. a cycle of refinement, see :ref:`SFLS`).
   to enable processor speeds to be compared. No real
   refinement is done, and the structure is not modified.
   ::


            nparam defaults to 500
            nref   defaults to 5000
   

::


      Times for a Microvax 3800 (circa 1995) are printed for comparison.
   


   
   

------------------
\\SET LIST   state
------------------


   
   This command allows the user to control the monitoring level
   of transfer of lists to and from the database
   in conjunction with the SET WATCH command. There are four states
   available.

   
   If state is OFF, no list logging information is produced.

   
   If state is READ or WRITE, list logging information is only produced
   when lists  are
   read or written respectively.

   
   If state is BOTH, both reading and writing
   operations may be monitored. Note that the logging operation may be qualified
   by a list type specified by SET WATCH. The initial state is WRITE, with
   the
   specific watch set on list 5 (the model parameters), so that only operations 
   creating or modifying list 5 will be monitored.

------------------
\\SET WATCH number
------------------


   
   This command is used in conjunction with SET LIST to control monitoring
   of list operations. If number is 0, operations on all list types may be
   monitored, according to the state set with SET LIST. If number is a positive
   integer, representing a list type, only operations on that list type may
   be
   monitored. The initial value for the list watch is 5, which in conjunction
   with the initial monitoring state means that operations creating or modifying
   list 5 will be monitored.

---------------
\\SET FILE type
---------------


   
   This command is used to control the case of file names generated
   by CRYSTALS. Possible values are:
   
   ::


       LOWER        Filenames are converted to all lower case.
       UPPER        Filenames are converted to all upper case.
       MIXED        Filenames are left as input or defined.
   


   
   

--------------------
\\SET GENERATE state
--------------------


   
   This command is used to control the generation of output file names
   and pseudo-generation numbers on
   non-VMS systems.  By default, CRYSTALS modifies the root of filenames
   for files which should not be overwritten (normally .LIS, .MON, .LOG).

   
   OFF suppresses automatic name generation.
   

------------------
\\SET EXPORT state
------------------


   
   If 'state' is 'on' then LISTS 5 (atoms), 12 (constraints) and 16 
   (restraints) are copied to the PUNCH file
   when CRYSTALS closes down. These can be archived for safety, or exported
   to another computer.
   

------------------
\\SET UEQUIV state
------------------

   This controls the calculation of Uequiv. Both definitions are acceptable
   to Acta. The arithmetic mean of the principle axes is often similar
   to the refined value of Uiso. The geometric mean is more sensitive to
   long or short axes, and so is more useful in publications.
   ::


            ARITH = (U1+U2+U3)/3
            GEOM  = (U1*U2*U3)**1/3
   


   
   

-----------------
\\SET PAUSE value
-----------------


   
   This command sets a time, in seconds, for which the program will pause
   at
   the end of each screen full of output. It is only effective on DOS machines,
   and enables the user to use the 'pause' key to hold a selected screen.
   The maximum value of 'interval' is 200 seconds.

---------------
\\SET LOG state
---------------


   
   If state = ON  then all user input commands are written
   to a log file.
   
   
   If  state = OFF  then subsequent commands are not written
   to the log. Any change made to
   the log state applies only to the current level of USE file and any
   USE file called by it.
   Because the log file is a direct copy of the users commands, it may
   subsequently be used (probably after modification) as a control file.

------------------
\\SET MIRROR state
------------------


   
   If 'state' = ON, then all input is reflected in the monitor or list file.
   If 'state' = OFF, monitoring.
   is suppressed. Any change made to
   the monitoring state applies only to the current level of USE file and
   any
   USE file called by it.

-----------------
\\SET PAGE length
-----------------


   
   This command is used to change the length of the assumed 'page' when
   displaying files on the monitor channel, using the commands 'HELP', 'MANUAL',
   and 'TYPE'. The initial length is 20 lines. After the number of lines
   specified have been typed, the listing stops and a message indicates the
   program is waiting. A blank line or carriage return
   at this point will cause the listing to
   continue. Any other input is executed normally. If the length is set to
   zero,
   or a negative number, the feature is disabled.

---------------------
\\SET TERMINAL device
---------------------


   
   This command controls the display of SCRIPT menus on some
   terminals. Possible device types are
   
   ::


       UNKNOWN This is the default, and requires no special terminal.
       VT52    For use on terminals with limited screen management facilities.
       VT100   For use on advanced terminals.
       VGA     For use on PC VGA terminals
       WIN     For use under Win32 and X-windows.
   


   

-------------------------
\\SET COMMUNICATION speed
-------------------------


   
   This command is used to indicate to the program the speed of the
   communication line or terminal
   on which it is being run. This indication is used by some facilities to
   determine how much output to produce on the monitor channel. The possible
   values for the speed are "SLOW" and "FAST". These keywords are not associated
   with any particular terminal speed, and the appropriate value will depend
   on
   the user's patience. The initial value is "FAST"

----------------
\\SET TIME state
----------------


   
   This command is used to indicate to the program whether the timing
   messages usually produced at the end of each facility are produced. If
   'state'
   is "OFF" the messages are not displayed. If 'state' is "ON" the messages
   are
   displayed.

-------------------
\\SET PRINTER state
-------------------


   
   This command is used to control output to the 'printer' file. The
   state
   OFF suppresses printer output.

-------------------
\\SET MONITOR state
-------------------


   
   This command is used to control output to the 'monitor' file. 
   ::

 
       OFF  suppresses all output 
       ON   copy screen output to monitor
       SLOW copy all screen output PLUS output for graphics to monitor.
       (Mainly used for debuging graphics)
   


   

-----------------------
\\SET OPENMESSAGE state
-----------------------


   
   This command is used to enable or disable file handling messages.
   OFF suppresses messages.

-------------------
\\SET MESSAGE state
-------------------


   
   This command is used to indicate to the program whether the command
   messages usually produced at the end of each facility are produced. If
   'state'
   is "OFF" the messages are not displayed. If 'state' is "ON" the messages
   are
   displayed. Error messages are always displayed.

---------------
\\SET SRQ state
---------------


   
   This command is used to control mirroring of CRYSTALS internal commands.
   The normal state OFF suppresses the mirroring.
   
   

-----------------
\\SET RATIO state
-----------------


   
   This command controls whether Io or Ic is compared with Sigma(Io) 
   during filtering. Arguments are Io or Ic, default is Io.
   See "The use of partial observations, partial models and partial residuals
   to improve the least-squares refinement of crystal structures."
   A. David Rae, Crystallography Reviews, 2013. Vol. 19, No. 4, 165.

   
   Io is appropriate during initial stages of an analysis, but once the R factor
   drops below 10-15%, Ic gives an unbiassed filtering of the weak reflections. A
   threshold ratio of 1 or 2 is useful if there are a very large number of very
   weak reflections.
   
   

=====
Files
=====


When CRYSTALS runs it stores all crystallographic data in a single file,
by default named crfilev2.dsc. This is a binary file and should not be
opened with any other program.


CRYSTALS outputs results and analysis to several places:


*The listing file:*


this will be called bfilenn.lis where nn is a number
from 00-99, incremented each time the program is run. When nn reaches 99
this file will be continuously overwritten every time CRYSTALS is run.


The listing file contains verbose output about all the calculations that
take place.


*The punch file:*


called bfile.pch by default. The idea of 'punching' data
is a throwback to the days of punched cards. This file is used to write out
specific bits of data *as* *commands* that can then be read back into the 
program. For example, the parameters defining the crystallographic model 
are stored in CRYSTALS as a 'List 5'. Then 'Punching List 5':
::


     \PUNCH 5
     END




will result in a full \\LIST 5 command being written to the file bfile.pch.
You can then recover that version of the model parameters by typing
::


     \USE bfile.pch




which causes the commands written in that file to be executed by CRYSTALS.


*The monitor file:*


called bfilenn.mon this is obsolete. If there is any
output in it, it is from a bit of the program that hasn't been looked at
recently.


*The log file:*


called bfilenn.log, this contains everything that you typed into CRYSTALS, 
and commands that were issued on your behalf by the menu system or script
processor.



.. index:: Errors


.. index:: Warnings


===================
Errors and Warnings
===================



CRYSTALS recognises the following run time error categories,
in addition
to any detected by the operating system.

--------
Warnings
--------


   
   These will occur only for tasks which produce user-readable
   output, and do not write to the database.
   The current task is abandoned if necessary,
   and the next task fetched from the input stream.

------
Errors
------


   
   The error is such that the current task must be abandoned. In batch or
   online modes, the job will be terminated as well. In interactive mode
   the current task is abandoned , and control is returned to the user at
   terminal. The processing of any 'USE' file will be abandoned.

-------------
Severe Errors
-------------


   
   The error detected is such that it is not possible for the job to
   continue. These errors are usually caused by database management failures.

--------------------
Catastrophic Errors.
--------------------


   
   The job is completely terminated.
   This is usualy the consequence of
   errors in reading or writing to the database.

------------------
Programming Errors
------------------


   
   The program has detected an inconsistency either in the code, or in
   the command file. A dump and error report will be generated if
   possible. The error and the conditions that cause it should be reported
   to Oxford.
   
   

---------------------------------------------
Errors Detected During the Creation of a LIST
---------------------------------------------


   
   During all operations that create new versions of a list, either by
   input or internally, errors may be found that cause the new list not to
   be written to the database. To prevent the system using an old version of
   a list
   when the creation of the latest version has failed, the relevant list
   type
   is marked as an 'error list' in the 'list control table' (see below).
   This error flag is cleared when a new version of the list is created or
   by user action.

   
   If a list which is marked as an error list is accessed, a message will
   be output, and the job terminated. However, for the printing of most lists,
   the error flags are not checked.
   
   
   
.. _crysdatabase:

 

*********************
The Crystals Database
*********************

It is quite possible to use CRYSTALS so that all the data is read from
text files at the start of every job (as in SHELXL).
However, for interactive working, it is preferable to establsh a
database of crystallographic information which can be used whenever it
is needed. This database is called the CRYSTALS 'disk' file. It is
usualy a permanent file on the hard disk, and usually has the extension
'.DSC'.
::


    It is a direct-access binary file. DO NOT try to print or edit it.






The data is organised in this file as lists, corresponding to the
external user-input lists. In modern terminology, these 'lists' 
would be called 'objects' or 'data structures'. Each list groups
together related information, e.g. the cell parameters, the atoms, 
the reflections etc.

While in general input of a list will
overwrite a previous version, for the atomic coordinate list (LIST 5, 
see section :ref:`LIST05`) a
new version is added to the database. In the event that a refinement
goes wrong, the user can usually recover an earlier version of the
structure.


In the  CRYSTALS  system, most of the data required to refine
a crystal structure must be input to the computer as ASCII,
translated into an internal format and stored on a random access
disk file. On the disk, different types of data are recorded
separately, in what are called  LISTS. Each list holds only one
type of crystallographic information and is identified by a number
called the 'list type number'.


Normally, each structure uses a separate disk file, which is preserved
between different jobs and updated whenever a program generates some
new data. This means that several different versions of a given list
may be produced during the course of a structure analysis.
In order that each list may be uniquely identified, every list has
associated with it a second number, called the 'list serial number'.
To specify unambiguously a list that is stored in the database,
it is necessary to know both the relevant list type number
and the list serial number.


In most cases, however, the version of a given list that is required
is the latest list of that type to be created.
Accordingly, an index called the 'current list index' is maintained,
which contains an entry for the latest version of each list.
When a program requires information about the current version of a
list, it accesses the current list index.


As well as an index of the current version of each list,
a second index is kept, called the 'file index'.
For each disk file, this latter index contains the information for every
list that is present in the database.
This index is always checked when a list is written to the database,
to ensure that its list type number and list serial number refer to only
one list.


For a user, the major advantage of splitting the input data into
logical units in the database is that, for any run, only those lists which
need to be changed have to be re-input to the database.
New versions of each list that are generated by programs are
automatically output to the database so that, provided the database file
is not
destroyed or erased, it is probable that each run will contain
only control commands.
For example, during a structure factor least squares calculation
a new set of  Fcalcs  and a new normal matrix will be generated and
stored in the database ready for further calculations.


Old versions of a list may be reused, provided that they have not been
overwritten or deleted, by finding the relevant entry in the file index
and copying it into the current list index.



The database contains two indices which control access to it.

**Current List Index**


   
   This index contains the serial numbers of each list to be used in
   calculations. This index is updated whenever a list is written to
   database.

**Disk Index**


   
   This is an index of all the lists contained in the database. When a
   new list is added to the database, its internal address is added to this
   index, and also inserted into the current disk index. It is possible to
   copy address from this index to the current disk index, thus changing
   the currently active version of a list.
   
   
   
   
   
.. index:: Disk

   
.. index:: Retreiving old data lists


==========================================
General List-control Directives  -  \\DISK
==========================================



The list control table can be marked and used in various ways with this
command.
::


    \DISK
    PRINT INDEX= PUNCH= LIST=
    MARKERROR LIST= SERIAL= RELATIVE= ACTION=
    RETAIN LIST= SERIAL= RELATIVE= ACTION=
    DELETE LIST= SERIAL= RELATIVE= ACTION=
    RESET LIST= SERIAL= RELATIVE=
    USAGE LIST= SERIAL= RELATIVE= FLAG=
    EXTEND RECORDS= FREE= TRIES= SIZE=
    CHECK
    END




For example:
::


    \DISK
    \  Print the current list index
    PRINT INDEX=CURRENT
    \ Print the index containing all the lists stored
    \ on the disk
    PRINT INDEX=DISK
    \ Reset LIST 5 (the model parameters) to the one with serial number 4
    RESET 5 4
    \ Reset LIST 10 (Fourier peaks) to the 'current serial number - 1'
    RESET 10 0 -1
    \ Retain LIST 5 with serial number 6 when the disk
    \ is purged
    RETAIN 5 6
    \ Delete current LIST 11 (normal/inverted least squares matrix)
    DELETE 11
    END





------
\\DISK
------


   
   This is the command which initiates the
   routines to modify the list control table.
   The directives MARKERROR,
   DELETE, RETAIN, USAGE, and RESET all accept the parameters
   SERIAL and RELATIVE.
   The parameters  SERIAL  and  RELATIVE  should not both
   be changed from their default settings on the same directive.

   
   All directives are executed immediately after they have been entered.
   

**PRINT INDEX=**



   
   This directive causes one of the indexes to be printed.
   

*INDEX=*


   ::


            CURRENT  -  default value
            DISK
            SUMMARY
   


   
   If  'INDEX'  is  'CURRENT', the current list index is
   printed (i.e. the index containing the current version of each
   list stored).
   If  'INDEX'  is  'DISK', the index containing information about all
   the lists stored on the disk is printed.
   If 'INDEX' is 'SUMMARY', a summary of the usage of the disk file is printed.
   

*PUNCH=*


   ::


            NO  -  default value
            YES
   


   
   Writes a machine readable summary of whatever is selected by INDEX to
   the currently open PUNCH file.
   

*LIST=*


   ::


            0  -  default value
            n
   


   
   By default (0) all lists are printed or punched. If you specify an
   alternative value for the LIST parameter, then only information about
   that list number is output.
   

**MARKERROR LIST= SERIAL= RELATIVE= ACTION=**



   
   This directive can either mark a specified type of list as an 'error
   list', or alternatively, such a mark can be removed from the list control
   table.
   

*LIST=n*


   'n' is the list type number (there is no default value).
   

*SERIAL=n*


   'n' is the list serial number. The default value is zero, which
   represents the serial number of the current list of this type.
   

*RELATIVE=n*


   'n' is the offset applied to the serial. The default value
   is 0. If both SERIAL and RELATIVE are zero (the defaults) 
   the current list of the specified type will be 
   the one that is marked.
   

*ACTION=*


   ::


            NO
            YES  -  default value
   


   
   If  ACTION is  NO , the entry in the list control table for the list type
   specified is altered so that it is not marked as an 'error list'.
   If  ACTION is  YES, the entry in the list control
   table for the list type specified is altered so that it is marked as an
   'error list'. If a program attempts to use such a list, an error is
   reported, and the job terminated.
   
   
   

**RETAIN LIST= SERIAL= RELATIVE= ACTION=**



   
   With this directive, certain old versions of specified lists can be
   retained when the disk file is  PURGED  (see :ref:`PURGE`).
   

*LIST=n*


   'n' is the list type number (there is no default value).
   

*SERIAL=n*


   See markerror definition above.
   

*RELATIVE=*


   See markerror definition above.
   

*ACTION=*


   ::


            NO
            YES  -  default value
   


   
   If  'ACTION'  is  'YES', the list with the specified
   type and serial number will be retained when the disk file is  PURGED.
   If  'ACTION'  is  'NO' , the particular list will be deleted when the
   disk file is  PURGEd (see section :ref:`PURGE`).
   

**DELETE LIST= SERIAL= RELATIVE= ACTION=**



   
   With this directive certain lists can be deleted from the file index.
   

*LIST=*


   See markerror definition above.
   

*SERIAL=*


   See markerror definition above.
   

*RELATIVE=*


   See markerror definition above.
   

*ACTION=*


   ::


            NO
            YES  -  default value
   


   
   If  'ACTION'  is  'YES', the list with the specified
   serial number will be marked to be deleted from the file when the
   file is PURGED.
   If  ACTION  is  'NO' , the specified list will not be marked as one to
   be deleted when the disk file is  PURGEd (see section :ref:`PURGE`).
   

**RESET LIST= SERIAL= RELATIVE=**


   This directive alters the entry for the list type in the
   current list index.
   

*LIST=*


   This parameter is the list type number,
   for which there is no default value.
   

*SERIAL=*


   See markerror definition above.
   

*RELATIVE=*


   See markerror definition above.
   

**USAGE LIST= SERIAL= RELATIVE= FLAG=**


   This directive alters the list write/overwrite flag.
   

*LIST=n*


   'n' is the list type number
   (there is no default value).
   

*SERIAL=*


   See markerror definition above.
   

*RELATIVE=*


   See markerror definition above.
   

*FLAG=*


   ::


            OVERWRITE
            READY
            UPDATE  -  default value.
   


   
   

**EXTEND RECORDS= FREE= TRIES= SIZE=**


   This directive 
   allows the user to extend the database by a specified number
   of records, and to control the auto-extension. On modern
   platforms the extension of the database is automatic by
   default.
   

*RECORDS=*


   This parameter specifies a number of records to be added to the
   file. The default value is zero i.e. no records are added.
   

*FREE=*


   This parameter specifies a number of records that must be available
   for use in the file. The file will be extended until there are at
   least 'FREE' records unused after the next free disk address.
   

*TRIES=*


   This is the number of times the system may try adding 'SIZE' records to
   the disk file to achieve enough space for the current operation. Usual
   default is 1.
   

*SIZE=*


   This is the size, in records, that the system will increase the disk by
   to try to accommodate the current operation. The usual default is 5.
   If the write still fails after TRIES x SIZE records have been added it 
   produces an error. Setting SIZE to zero enables uncontrolled
   extension of the disk file. This is the default, but if the
   user gets carried away doing crystallography, they may fill their 
   disk.
   
   
   

**CHECK**


   This directive checks the integrity of the disk file. It takes
   no parameters.
   

*Errors in the DISK file.*


   If CRYSTALS
   reports errors in the disk file, run this utility to get a list of those
   LISTS corrupted. Use \\PUNCH 5, \\PUNCH 12 and \\PUNCH 16 to make ASCII
   copies of these important lists (by default output to the 'punch' 
   file, bfile.pch - rename it after punching to e.g. 'savedlists.pch'). 
   If the final version 
   of a list is corrupt, use \\DISK RESET (see above) to point 
   the program 
   to an earlier version and punch that instead.
   If the disk file becomes totally
   unusable, delete it, read in the reflections again, and then read in
   these 'punched' lists (\\USE savedlists.pch).
   
   
   If only certain lists are unusable,
   use the DELETE directive in \\DISK to mark defective LISTS for
   deletion, and then use \\PURGE NEW to create a new disk file (by 
   default new.dsc). Rename new.dsc to crfilev2.dsc to make CRYSTALS 
   open it by default when it starts in that directory.
   
   ::


       The following lists can always safely be deleted since CRYSTALS creates
       new ones automatically.
   


   10 Fourier peaks (section :ref:`LIST10`).
   
   11 Normal matrix (section :ref:`LIST11`).
   
   20 Saved geometrical transformation matrices (section :ref:`LIST20`).
   
   22 Constraints in internal format (section :ref:`LIST22`).
   
   24 Least squares shift list (section :ref:`LIST24`).
   
   26 Restraints in internal format (section :ref:`LIST26`).
   
   33 SFLS command in internal format (section :ref:`SFLS`).
   
   36 List dependency tracking (not documented).
   
   
   
   See section :ref:`LISTS` for all the list definitions.
   
   

   
   Example 1
   
   ::


      Imagine that the current versions of LIST 5 (the model parameters) 
      and LIST 29 (element properties) have beome corrupt.
      We will also delete any recreatable lists.
      
            \DISK
            \  Check the index
            CHECK
            \  Delete current version of atomic params
            DEL 5
            \  Point index to the previous version
            RESET 5 0 -1
            \  Remove corrupt and safe-to-delete lists:
            DEL 29
            DEL 10
            DEL 11
            DEL 20
            DEL 22
            DEL 24
            DEL 26
            DEL 33
            DEL 36
            END
            \  Open a new file save.dat on the 'PUNCH device'.
            \  Release is equivalent to CLOSE followed by OPEN.
            \RELEASE PUNCH SAVE.DAT
            \  Output the important data lists:
            \PUNCH 5
            END
            \PUNCH 12
            END
            \PUNCH 16
            END
            \  Write a new database called rescue.dsc with only the 
            \  current index of lists in it:
            \PURGE RESCUE
            \  Close CRYSTALS
            \FINISH
   


   
   At this point it would be useful on a stand-alone computer to
   run a system utility (e.g. SCANDISK on a PC) to check the integrity of
   the computers hard disk, since CRYSTALS rarely corrupts the disk itself.
   
   
   One would then open a command prompt in the working folder and do this:
   ::


            del crfilev2.dsc
            ren rescue.dsc crfilev2.dsc
   


   
   Now restart CRYSTALS in the same folder. Recover the important saved 
   data by typing:
   ::


            \USE save.dat
   


   
   
   
   
.. index:: Purge

   
.. index:: Shrinking the contents of a dsc file


.. _PURGE:

 
================================================
Elimination of Old Versions of LISTS  -  \\PURGE
================================================



::


    \PURGE FILE= INITIALSIZE= LOG= LIST=
    END





-------
\\PURGE
-------


   
   This command deletes all but the current
   version of each list, and any lists explicitly marked to be deleted,
   except for lists marked to be retained,
   and then rewrites the disk file
   so that the space occupied by the old deleted lists is overwritten.
   This operation does not normally shorten the file physically (see parameter
   FILE below for a method of doing this) , but frees
   a lot of space that can be reused.
   The optional parameters 'FILE' and 'INITIALSIZE' (available
   in some implementations
   only), allow the user to create a new file with only the current
   version of each list in it. This file may be smaller than the
   original disk file.
   

*FILE=*


   ::


            OLD - default value
            name - The root to be used form the new database - name.DSC
            DATE - The root name is generated by CRYSTALS from the date and
                   time.
   


   

   
   This parameter controls whether a new file is created. If the value
   specified is not OLD, a new file will be created containing only the
   current versions of each list, and any which are marked to be retained.
   The program automatically extends the file to the size required for all
   the lists to be retained. This new file has the extension .DSC,
   and may be used in future CRYSTALS tasks.
   

*INITIALSIZE=*



   
   This parameter is used to specify an initial size for a new file. If
   a new file is not to be created, the value is ignored. The default
   value of zero causes the new file to have the smallest size necessary
   to contain all the copied lists.
   

*LOG=*


   ::


            OFF - default value
            ON
   


   

   
   If the value 'ON' is given for this parameter, the types and serial
   numbers of all lists deleted because they were old versions are listed.
   The types and serials of all lists not copied for other reasons, e.g.
   deleted lists, and lists which are marked as being updated, are always
   listed
   

*LIST = n*



   
   'n' is the type of list to be purged from the database, all old versions 
   of all other lists are preserved. If 'n' is 0 (the default value)
   lists of all types are purged.
   
   
   
   
   
   
.. index:: Lists overview


.. _LISTS:

 
====================
LISTS in Current use
====================



Lists marked * cannot be directly input by the User


List Number     Type of data



1    Cell parameters (section :ref:`LIST01`)

2    Unit cell symmetry (section :ref:`LIST02`)

3    Atomic scattering factors (section :ref:`LIST03`)

4    Weighting parameters (section :ref:`LIST04`)

5    The model parameters (section :ref:`LIST05`)

6    Reflection data (section :ref:`LIST06`)

7    Reflection data not used for refinement (section :ref:`LIST07`)

9*   ESDs of model parameters (section :ref:`LIST9`)

10    Peak coordinates from Fourier (section :ref:`LIST10`)

11    Least squares matrix (section :ref:`LIST11`)

12    Refinement directives (section :ref:`LIST12`)

13    Crystal and collection data (section :ref:`LIST13`)

14    Fourier directives (section :ref:`LIST14`)

16    General Restraints (section :ref:`LIST16`)

17    Special Restraints (section :ref:`LIST17`)

18    SMILEs string representation (section :ref:`LIST18`)

20*   Transformation matrices saved by \\GEOMETRY (section :ref:`LIST20`)

22*   Refinement directives in internal format (section :ref:`LIST22`)

23    Structure factor control list (section :ref:`LIST23`)

24*   Least squares shift list (section :ref:`LIST24`)

25    Twin component operators (section :ref:`LIST25`)

26*   Constraints in internal format (section :ref:`LIST26`)

27    Diffractometer scales (section :ref:`LIST27`)

28    Reflection condition/filter list (section :ref:`LIST28`)

29    Contents of asymmetric unit and elemental properties (section :ref:`LIST29`)

30    General information (section :ref:`LIST30`)

31    Cell parameter E.S.D.'s (section :ref:`LIST31`)

33*   Internal - Refinement control (last SFLS command, see :ref:`SFLS`)

36*   Tracking interdependencies of parameters, normal matrix, weights etc.

40    Bond forming/breaking directives (section :ref:`LIST40`)

41*   Bonds between atoms (section :ref:`LIST41`)



.. index:: Summary


=============================
Printed Summary of Data lists
=============================

::


      \SUMMARY OF= TYPE= LEVEL=
      END




For example:
::


      \  Detailed list of model parameters:
      \SUMMARY OF=LIST TYPE=5 LEVEL=HIGH
      END
   
      \  Again, but less typing:
      \SUM L 5 HI
      END
   
      \  Summary of reflection data:
      \SUM L 6
      END





---------
\\SUMMARY
---------

   

*OF=*



   
   This parameter determines the extent of the data summary.
   ::


            LIST
            EVERYTHING
   


   

   
   If 'LIST' is specified, a summary of a specific list whose type is
   given by the 'TYPE' parameter is produced. If 'EVERYTHING' is specified,
   a summary of all current lists for which summaries are available is
   produced. If 'OF = EVERYTHING' is
   specified, the value of 'TYPE' is ignored.
   

*TYPE=*



   
   This parameter indicates the
   list type for which a summary is required. If a summary of this list
   type is not available, a warning message will be printed.
   
   
   

*LEVEL=*


   ::


            LOW
            MEDIUM
            HIGH
   


   
   This parameter has three values which indicate the level of detail
   required in the data summary. The parameter is ignored unless the list
   type is 5 or 10.
   
   ::


       List      Level   Data printed
       ----      -----   ---- -------
       5 or 10  LOW     Atom names
       5 or 10  MEDIUM  Atom names and positional parameters
       5 or 10  HIGH    All atomic and overall parameters
   


   
   
.. index:: Atom name syntax


.. _ATOMSYNTAX:

 
======================
Element and Atom names
======================






-------------
Element Names
-------------


   
   Elements are specified by a name, called the atom **TYPE** . The
   'TYPE' is used to associate the refined atoms with atomic properties,
   such as form factors, radii, etc. The TYPE **must** start with a letter,
   and is not case sensitive.

   REMEMBER that 'blank' is used as a delimiter in CRYSTALS and so must
   not appear in an atom TYPE. Elements in the form factor list (LIST 3 - see
   section :ref:`LIST03`) and the atomic properties (LIST 29 - section :ref:`LIST29`) 
   are associated by 
   their TYPE with atoms in the parameter list (LIST 5). Numeric properties of the
   elements are pre-prepared in the files SCATT, SCATCU, SCATMO and
   PROPERTI(.dat) in the SCRIPT directory (Often CRYSTALS\\SCRIPT). The
   'elements' C', C", H' and H" are in these files with the properties of C and H.
   You can define your own element names, but may not use +,- or \*.
   
   

----------
Atom names
----------

   Individual atoms are specified by combining the TYPE with a SERIAL
   number. This is an integer in the range 1-9999. When combined with the
   TYPE, it must be enclosed in parentheses ().
   ::


         e.g.   C(2) CL(123)
   


   
   
   

-------------------------
Symmetry equivalent atoms
-------------------------


   
   
   Atoms specified as above correspond exactly to those in the refinable
   atom list (LIST 5). If a symmetry equivalent atom is required, up to 5
   additional items are included inside the parentheses. The full
   specification of an atom is:
   ::


             TYPE(SERIAL,S,L,Tx,Ty,Tz)
   


   
   
   
   

**S**


   is the serial number of the symmetry operator in the stored list of
   space group operators. If negative, it indicates that the atom
   coordinates are first negated before being operated upon. The default is
   1
   
   
   

**L**


   is the serial number of the non-centring lattice translation to be
   used. The default is 1.
   
   
   

**Tx,Ty,Yz**


   are whole cell translations parallel to the cell axes. The
   default is 0.

   
   
   If the value of an item is its default, it may be omitted altogether, though
   its place must be marked by its associated comma. A series of trailing
   commas may also be omitted. For example:
   
   ::


             C(99,-1,1,0,0,0) - an atom related by inversion at the origin
                                (assuming x,y,z is the first operator).
             C(99,-1,1,,,0)   - same atom as above, omitting defaults.
             C(99,-1)         - same atom as above, omitting 
                                defaults and trailing commas.
   


   

   
   For more detailed information, see Atomic and
   Structural parameters (section :ref:`atomparams`)
   
   
   
.. index:: External program links


=====================
Foreign Program Links
=====================


---------
\\FOREIGN
---------


   
   This command provides links to 'FOREIGN' programs, that is,
   programs which are not part of CRYSTALS, but which provide useful
   functions in providing a complete system. These programs often come
   from other laboratories, and are only distributed with the authors
   permission unless they are public domain. Where practical, we make no
   changes to the original code. We offer little or no support in
   connection with these programs, though usually they are in frequent
   use in Oxford. The linking routine prepares data files for the foreign
   program, and may initiate a subprocess to execute the rogram.
   

*PROGRAM=*


   ::


            SNOOPI  - A plotting program using Tektronix 4010 devices.
            CAMERON - An interactive graohics program.
            MULTAN  - Prepares files for MULTAN 84.
            SHELXS  - Prepares files for SHELXS.
            SIRxx   - Prepares files for the SIR direct methods system
   


   
   

*MODE=*



   
   This keyword controls the mode of operation of the foreign program.
   It currently only applies to SHELXS and SIR.
   ::


            NORMAL      - DEFAULT, prepares a default data file with recommended
                          settings.
            DIFFICULT   - Prepares a file with non-default settings.
            PATTERSON   - Prepares a default Patterson calculation (SHELXS only).
            SPECIAL     - Prepares a full SHELX data file (SHELX only)
   


