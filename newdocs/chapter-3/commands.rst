.. toctree::
   :maxdepth: 1
   :caption: Contents:


.. include:: ../macros.bit



.. index:: Command Line Overview

.. _command overview:


############################
Overview of the COMMAND LINE
############################
The |blue| Guide |xblue| and menus provide a very convenient way of
dealing with routine structures. However, CRYSTALS has many more powerful
options which must be accessed via the Command Line.
|br|\
CRYSTALS is actually controlled by sending it *COMMANDS*. The menus 
pre-package commands and other information to simplify routine tasks.
For non-routine projects the user can issue commands and other information
either by typing on the comman line, or by putting the information into an
ASCII-encoded (plain text) file.
|br|\
All the data input utilities convert the *alien* formatted data to native CRYSTALS
format.  In the event that automatic conversion fails, the following section outlines
the basic data LISTS that must be given to CRYSTALS.  Full details of the LISTS can be 
found in the CRYSTALS Reference Manual.
|br|\
The contents of LISTS stored in the *dsc* file can be viewed:
::

      /SUM LIST n      Displays a summary of LIST n in the screen
      /PRINT n         Lists the detailed contents of LIST n in the Print file
      /PUNCH n         Creates CRYSTALS format data in the PUNCH file



In general, a COMMAND starts with the special symbol and the command name
and ends with |blue| END |xblue| On a separate line.  
See the :ref:`COMMAND LINE <command-line>`. 

----

***************************
Worked Command Line Example 
***************************

The worked example :ref:`nket <nket>` shows a complete structure analysis performed from 
the command line.

----


.. index:: Basic Data Input

.. _initialdinput:

****************************************
Scope of the Initial Data Input section.
****************************************

The areas covered are:
::


    Abbreviated startup command                      QUICKSTART
    Input of the cell parameters                     LIST 1
    Input of the unit cell parameter errors          LIST 31
    Input of the space group symmetry information    SPACEGROUP
    Alternative input of the symmetry information    LIST 2
    Input of molecular contents                      COMPOSITION
    Input of the atomic scattering factors           LIST 3
    Input of the contents of the unit cell           LIST 29
    Input of the crystal and data collection details LIST 13
    Input of general crystallographic data           LIST 30



.. index:: QUICKSTART


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Abbreviated startup command  -  QUICKSTART
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^



The command QUICKSTART is provided to assist in migration from other
systems to CRYSTALS. It requires that data reduction (section :ref:`DATAREDUC`) 
has been done and that reflections are on a common scale.
The reflection data should be in a fixed format file with
one reflection per line. This command expands the given data into
standard CRYSTALS lists, as described elsewhere in the manuals. The user
is free to overwrite LISTS created by QUICKSTART by entering new LISTS
manually.


For example:
::


    \QUICKSTART
    SPACEGROUP P 21/n
    CONTENT C 6 H 4 N O 2 CL
    FILE CRDIR:REFLECT.DAT
    FORMAT (3F3.0, 2X, 2F8.2)
    DATA 1.5418
    CELL 10.2 12.56 4.1 BETA=113.7
    END



============
\\QUICKSTART
============

   None of the directives may be omitted, though some parameters do have
   default values. **CONTINUE directives may not be used.**
   
   
   

* SPACEGROUP SYMBOL

  This directive generates symmetry information from the spacegroup symbol.
  The syntax is exactly as describe for the command SPACEGROUP, given
  in section :ref:`spacegroup`.
   

  * SYMBOL=
    There is no default for the symbol, it should be a valid H-M space group
    symbol, e.g. 'P 21 21 21' or 'P 21/c' or 'I -4 3 m'. Use spaces to 
    separate each of the operators. 
  
 

* CONTENTS FORMULA

  This directive takes the contents of the UNIT CELL 
  (cf LIST 29 - section :ref:`LIST29`) and generates scattering factors 
  (LIST 3 - section :ref:`LIST03`) and elemental properties (LIST 29 - section
  :ref:`LIST29`).
   

  * FORMULA=
    The formula for the UNIT CELL contents
    |blue| (not asymmetric unit) |xblue|   is given as a list with entries of the type
    ::

             'element name' 'number of atoms'
      
       e.g. CONTENT FORMULA = C  24  H  36  O  8  N  4
   

    The items in the list **must** be separated by at least one space. The
    number of atoms may be fractional or, if omitted, they 
    default to 1.0.
   
   

* DATA WAVELENGTH REFLECTIONS RATIO

  * WAVELENGTH=
    The wavelength, in Angstroms, used in selecting elemental properties. The
    default is 0.7107 (Molybdenum K-alpha radiation).
  * REFLECTIONS=
    A keyword to indicate whether the input data is F or |F2|
    ::


            FOBS     -  Default, indicating F values being input.
            FSQUARED -  Indicating F squared values being input.

   
    Note that the reflections from modern diffractometers are 
    most likely to be fiven as |F2|. Some old X-ray data and neutron data may 
    still be given as FOBS.

  * RATIO=


    The minimum ratio of :math:`(F^2/\sigma(F^2))` to be used in selecting reflections.
    Default is -3.0
   
     
   

* FILE NAME

  This directive associates CRYSTALS with the file containing the reflections.
   

  * NAME=
    The name of the file containing the reflections. The
    syntax of the name must conform to the computers operating system. See
    the *immediate* command \\SET FILE for case sensitive operating systems.
   
* FORMAT EXPRESSION
  The format of the reflection
  file, which must contain the following items in the order given. Only one
  reflection is permitted per line.
  See \\LIST 6 for more flexible input (section :ref:`LIST06`)
  ::


                h k l F and optionally sigma(F)
   
   
   
  If |F2| and sigma(|F2|) values are given, the Key *REFLECTIONS* below must be set.
   

  * EXPRESSION=
    The expression is a normal FORTRAN format expression, *including the
    open and close parentheses.*
    The descriptor 'nX' may be used to skip unwanted
    columns. See the  :ref:`reflection data format <refdatform>` section for details.
    There is no default expression.
   

   

* CELL  A B C ALPHA BETA GAMMA
  The real cell parameters, in Angstrons and degrees. The angles default to 90.0 degrees.
   
   
----   
   
^^^^^^^^^^^^^^^^
Individual Lists
^^^^^^^^^^^^^^^^
This section describes the LISTS which may be used to overwrite information input via 
QUICKSTART, or to provide additional information.
   
.. index:: LIST 1

   
.. index:: Cell parameters


.. _LST01:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The cell parameters  -  LIST 1
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Either the real cell parameters or the reciprocal cell
parameters may be input and the three angles be given in degrees or
as their cosines.  The angles default to 90 degrees.
A mixed form, containing both angles and cosines, is not allowed.
See the section :ref:`LIST01` for full details.



For example

::

    \LIST 1
    REAL 14.6 14.6 23.7 GAMMA=120
    END


========
\\LIST 1
========
* REAL A B C ALPHA BETA GAMMA
  |br|\ |blue| or |xblue| |br|\
* RECIPROCAL A* B* C* ALPHA* BETA* GAMMA*


=========
\\PRINT 1
=========
   This command lists the cell parameters, and all the other information
   derived from them which is stored in LIST 1.
   The inter-axial angles are stored in radians in LIST 1, and printed as
   such.
   
   
   
.. index:: Cell errors

   
.. index:: List 31


.. _LST31:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The unit cell parameter errors  -  LIST 31
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This list contains the variance-covariance matrix of the unit
cell parameters. The input consists of a multiplier which is
applied to all input parameters,
followed by the upper
triangle of the variance-covariance matrix (21 Numbers).
The units for the angles **MUST** be
radians and those for the cell lengths are Angstroms.
See the section :ref:`LIST31` for full details.

For example
::

    \LIST 31
    \ the values of the input matrix are to be multiplied
    \ by 0.000001
    AMULT 0.000001
    \ the cell is trigonal,
    \ with errors of 0.002 along 'a' and 'b', and 0.004 along 'c'
    \ Note 0.002^2 = 0.000004
    MATRIX 4 4 1 0 0 0
    CONT     4 1 0 0 0
    CONT      16 0 0 0
    CONT         0 0 0
    CONT           0 0
    CONT             0
    END



=========
\\LIST 31
=========

* AMULT VALUE |br|\
  This directive gives the value by which all the subsequent terms
  are to be multiplied, and has a default of 1.0.

* MATRIX V(11) V(12) . . V(16) V(22) . . V(66) |br|\
  This directive is used to read in the variance-covariance matrix.

  If you only have the parameter e.s.d's, input the square of these for
  V(11), V(22) etc.

  The default values for V(11), V(22) and V(33) correspond to axis
  e.s.d's of .001 A, V(44), V(55) and V(66) to angle e.s.d's of .01 degree.
   
   
   
   
   
.. index:: Space group input

   
.. index:: SPACEGROUP


.. _spacegroup:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Space Group input - \\SPACEGROUP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The spacegroup symbol interpretation routines in CRYSTALS are derived
from subroutines developed by Allen C. Larson and Eric Gabe.
It is distributed with their permission. Standard CRYSTALS
command input, error handling, data storage, and output has been
added to the basic routines. In addition a more flexible method
of  specifying the unique axis in a monoclinic spacegroup is
used. The routine generates a LIST 2 (symmetry information - section
:ref:`LIST02`), and a
LIST 14 (Fourier and Patterson asymmetric unit limits - 
section :ref:`LIST14`).

For example:
::

    \ Input the symbol for a cubic spacegroup
    \SPACEGROUP
    SYMBOL F d 3 m
    END
   
    \ Input the symbol for a common monoclinic spacegroup
    \SPACEGROUP
    SYMBOL P 21/c
    END
   
    \ Input the symbol for a triclinic spacegroup
    \SPACEGROUP
    SYMBOL P -1
    END


============
\\SPACEGROUP
============
* SYMBOL EXPRESSION
  This directive is used to specify the space group symbol.
   
  * EXPRESSION
    The value of this parameter is the text making up the spacegroup
    symbol.  At least one
    space character should appear between each of the axis symbols
    e.g.
    ::


       Use  P 21 3 rather than P 213, P2 1 3, or P2 13 for the cubic space group
       198.
 
   
   Failure to put spaces in the correct place in the symbol will
   lead to misinterpretation.
   
   Rhombohedral cells are always assumed to be on hexagonal indexing.
   
* AXIS UNIQUE
  This directive specifies the unique
  axis orientation for
  monoclinic spacegroups where the symbol specified
  contains only one axis symbol (short symbol). In other cases any information
  specified with this directive is ignored.

  * UNIQUE
    ::


            A
            B
            C
            GENERATE - the default value.
   


   

   
  When UNIQUE has the value A, B, or C the program uses the 'a',
  'b', or 'c' axis respectively as the unique axis.
  When UNIQUE
  has the value GENERATE, the program will attempt to select the
  unique axis on the basis of the cell parameters currently stored in
  LIST 1. If this is not possible, because the angles in LIST 1
  are all close to 90 degrees or there is no valid cell parameter
  information, the program will assume that the unique axis is
  'b'.
  
  Further examples.
   
  ::


       \LIST 1
       REAL 10.2 11.3 14.1 88.3 90 90
       END
       \ Input symmetry - the program will  automatically select 'a' as the
       \ unique axis based on the cell parameters.
       \SPACEGROUP
       SYMBOL P 21/M
       END
   

       \ Explicitly specify 'c' unique by giving the full symbol.
       \SPACEGROUP
       SYMBOL P 1 1 21/M
       END
       \
       \ Explicitly specify 'c' unique by using the UNIQUE parameter.
       \SPACEGROUP
       SYMBOL P 21/M
       AXIS UNIQUE=C
       END
   


   
   
   
   
.. index:: LIST 2

   
.. index:: Symmetry data


.. _LST02:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Symmetry Operators -  LIST 2
^^^^^^^^^^^^^^^^^^^^^^^^^^^^


The result of inputting a \\SPACEGROUP command (section :ref:`SPACEGROUP`) 
is the automatic generation of a 'LIST 2' containing the explicit 
symmetry operators and other information that defines the spacegroup.


Direct input of this list enables the user to specify explicitly 
the symmetry operators to be used. The advantage of this is that 
they need not comply to any standard convention - the only
check made by the program is to ensure that the determinant is 
not zero. For example, this technique may be used to enter a 
set of symmetry operators that contains a translation of one half along
an axis - normally that cell length would be halved instead, but it may
be useful in order to work consistently with a structure that undergoes
a cell-doubling phase transition.
See the section :ref:`LIST02` for full details.

For example:
::

    \ the space group is B2/b
    \LIST 2
    CELL NSYM= 2, LATTICE = B
    SYM X, Y, Z
    SYM X, Y + 1/2,  - Z
    SPACEGROUP B 1 1 2/B
    CLASS MONOCLINIC
    END



The CELL directive defines the Bravais lattice type,
the number of equivalent positions to be input, and whether the
cell is centric or acentric.
The equivalent positions are defined by  SYMMETRY  directives, which contain
one equivalent position each, and must follow the  CELL  directive.
The equivalent positions input should not include those related
by a centre of symmetry if the lattice is defined as centric, and should
not include those related by non-primitive lattice translations if
the correct Bravais lattice type is given.
Positions generated by the last two operations are computed by the
system.
The unit matrix, defining x, y, z, **Must always** be input.
If a centric cell is used in a setting which does not place the centre
at the origin, then ALL the operators must be given and the cell be
treated as non-centric. This will of course increase the time for
structure factor calculations.


Rhombohedral cells can be treated in two ways. If used with
rhombohedral indexing (a=b=c, alpha=beta=gamma), the lattice type is P,
primitive.
If used with hexagonal indexing, the lattice type is R.



========
\\LIST 2
========

* CELL NSYMMETRIES  LATTICE  CENTRIC

  * NSYMMETRIES
    This defines the number of SYMMETRY directives that are to follow.
    There is no default.

  * LATTICE
    This defines the Bravais lattice type, and must take
    one of the following values :

    ::


            P  -  Default value.
            I            R            F      
            A            B            C
   

  * CENTRIC
    This parameter defines whether the cell is centric or acentric, and must
    take one of the values :

   ::


            NO
            YES  -  The default value.
   

* SYMMETRY  X  Y  Z
  This directive is repeated  NSYMMETRIES  times, and each separate occurrence
  defines one equivalent position in the unit cell.
  The parameter keywords  X ,  Y  and  Z  are normally omitted on this
  directive, and the equivalent position typed up exactly
  as given in international tables.
  The expressions may contain any of the following :

  ::


            +X or -X
            +Y or -Y
            +Z or -Z
            + or - a fractional shift.
   


   
  The fractional shift may be represented by one number divided by another
  (e.g. 1/2 or 1/3) or by a true fraction (0.5 or 0.33333...).
  Apart from terminating text, spaces are optional and ignored.
  The terms for the new x, y and z must be separated by a  comma (,) , and the
  whole expression may be terminated by  ;  if required.
   

* SPACEGROUP LATTICE A-AXIS B-AXIS C-AXIS
  This directive inputs the space group symbol, and is optional for the
  correct working of CRYSTALS. However, some foreign programs need
  the symbol as input data, and they will extract it from this record.
  The keywords LATTICE, A-AXIS etc are normally omitted, and the full
  space group symbol given with spaces between the operators, e.g.
  ::


              SPACEGROUP P 1 21/C 1
   

* CLASS NAME
  This directive inputs the crystal class. It is not used by CRYSTALS, but is
  required for cif files.
  ::

                 CLASS MONICLINIC
 

Further examples.
   
::


       \ THE SPACE GROUP IS P1-BAR.
       \LIST 2
       CELL NSYM= 1
       SYM X, Y, Z
       SPACEGROUP P -1
       END
   


       \ THE SPACE GROUP IS P 321
       \LIST 2
       CELL CENTRIC= NO, NSYM= 6
       SYM X, Y, Z
       SYM -Y, X-Y, Z
       SYM Y-X, -X, Z
       SYM Y, X, -Z
       SYM -X, Y-X, -Z
       SYM X-Y, -Y, -Z
       END
   


       \ THE SPACE GROUP IS P 6122 (note alternative notation for fractions)
       \LIST 2
       CELL NSYM= 12, CENTRIC= NO
       SYM X,Y,Z
       SYM -X    ,   -Y  ,Z+.5
       SYM +Y, +X,1/3-Z
       SYM -Y,-X,5/6-Z
       SYM -Y, X-Y, .333333333+Z
       SYM Y, Y-X, Z+10/12
       SYM -X, Y-X, 4/6-Z
       SYM X, X-Y, 1/6-Z
       SYM Y-X, -X, Z+4/6
       SYM  X-Y, X, Z+1/6
       SYM X-Y, -Y, -Z
       SYM Y-X, Y ,  -Z+.5
       SPACEGROUP P 61 2 2
       END
   



.. index:: Molecular composition

   
.. index:: COMPOSITION


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Molecular composition \\COMPOSITION
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This command takes the contents of the asymmetric unit, searches the
specified data files for required values, and then internally creates normal
scattering factors (LIST 3 - section :ref:`LIST03`) and elemental 
properties (LIST 29 - section :ref:`LIST29`). |blue| NOTE
LISTS 1 (see :ref:`LIST01`) and 13 (see  :ref:`LIST13`) 
must have been input beforehand. |xblue|

For example:
::

    \COMPOSITION
    CONTENT C 6 H 5 N O 2.5 CL
    SCATTERING CRSCP:SCATT.DAT
    PROPERTIES CRSCP:PROPERTIES.DAT
    END


The symbol CRSCP is an alias for the folder holding SCRIPTS, normally WINCRYS/SCRIPT

=============
\\COMPOSITION
=============
* CONTENTS FORMULA

  * FORMULA
    The formula for the UNIT CELL
    (Not asymmetric unit) is given as a list with entries
    ::


       'element TYPE' 'number of atoms'.
   


   
    The items in the list MUST be separated by at least one space. The number
    of atoms may be omitted, when they default to 1.0, and may be fractional.
   
   
    The element TYPE must conform to the TYPE conventions described in the
    atom syntax, section :ref:`ATOMSYNTAX`.
   
   
   

* SCATTERING FILE
  This directive gives the name of the
  file to be searched for scattering factors, and must conform to the syntax
  of the computing system. A file CRSCP:SCATT.DAT is provided for some
  implementations, and contains all the scattering factors listed in
  Volume IV, International Tables.
   

* PROPERTIES FILE
  This directive gives the name of the
  file to be searched for elemental properties, and must conform to the syntax
  of the computing system. A file CRSCP:PROPERTIES.DAT is provided for
  some implementations, and contains values gleaned from various sources. The
  file contains references.
   
   
   
.. index:: LIST 3

   
.. index:: Scattering factors


.. _LST03:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Atomic scattering factors  -  \\LIST 3
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This list contains the scattering factors that
are to be used for each atomic species that may appear in the
atomic parameter list (LIST 5)
- see the section of the user guide on Atom and Element names
and  :ref:`LIST03` for full details.
.

For example:
::


    \LIST 3
    READ 2
    SCATT C    0    0
    CONT  1.93019  12.7188  1.87812  28.6498  1.57415  0.59645
    CONT  0.37108  65.0337  0.24637
    SCATT S 0.35 0.86  7.18742  1.43280  5.88671  0.02865
    CONT               5.15858  22.1101  1.64403  55.4561
    CONT              -3.87732
    END




The scattering factor of an atom in LIST 5 (the model parameters) 
is determined by its  |blue| TYPE |xblue|, an entry for which must exist in LIST 3.


The form factor is calculated analytically at each value
of sin(theta)/lambda,  s , from the relationship :
::


    f = sum[a(i)*exp(-b(i)*s*s)] + c       i=1 to 4.




The coefficients a(1) to a(4), b(1) to b(4) and c and the real and
imaginary parts of the anomalous dispersion correction
are input for each element TYPE.



========
\\LIST 3
========
* READ  NSCATTERERS

  * NSCATTERERS
    This must be set to the number of atomic species to be stored
    in LIST 3, and thus the number of  SCATTERING  directives to follow.
    There is no default value.

* SCATTERING TYPE F' F'' A(1) B(1) A(2) . . . B(4) C
  This directive provides the form factor details for one atomic species and
  must be repeated  NSCATTERERS  times.
   
  * TYPE
    The element TYPE must conform to the TYPE conventions described in the
    General Introduction.
    The values used for  TYPE  in LIST 3 will have their counterparts
    in the  TYPEs stored for atoms in LIST 5 (the model parameters), 
    and in the  TYPEs
    stored for atomic species in LIST 29 (see section :ref:`LIST29`).
    There is no default for this parameter.
   

  * F' F''
    These define the real and imaginary parts of the anomalous dispersion
    correction for this atomic species at the appropriate wavelength.
    A default value of zero is assumed if these parameters are omitted.
   

  * A(1) B(1) A(2) B(2) A(3) B(3) A(4) B(4) C
    These define the coefficients used to compute the
    scattering factor for this atomic species. There are
    no default values.
   
    ::


       For neutrons, all the A(i) and B(i) are set to zero, and C is set to
       the scattering length.
   
   
   
.. index:: LIST 13

   
.. index:: Experimental details


.. _LST13:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The crystal and data collection details  -  LIST 13
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
LIST 13 contains information about those experimental details
which may be needed during data reduction and structure analysis.

See the CRYSTALS MANUAL for the full listm of parameters - we give here
only those needed if data reduction (Lp and absorption corrections) were
performed in the diffractometer.

Information required only for
the generation of a cif are held in LIST 30 (section :ref:`LIST30`).

If no LIST 13 has been input and one is 
required, a default list is generated.
See the section :ref:`LIST13` for full details.

For example:
::



    \LIST 13
    CRYSTAL FRIEDEL=YES TWINNED=NO 
    DIFF RADIATION=XRAYS
    COND WAVELENGTH= .7107
    END




=========
\\LIST 13
=========
* CRYSTAL FRIEDELPAIRS TWINNED SPREAD

  * FRIEDELPAIRS
    This parameter defines whether Friedel's law should be used during
    \\SYSTEMATIC in
    data reduction. It should be set to NO for high accuracy or absolute
    structure determinations. If omitted, Friedel's law will be used.
    ::


            YES  -  default value.
            NO
   
  * TWINNED
    This parameter is used during refinement to indicate
    whether the twin laws should be used. It is automatically updated
    if twinned reflection data is input.
    ::


            NO  -  Default value.
            YES
   

  * SPREAD
    This parameter defines the type of mosaic spread in the crystal.
    This information is used during the calculation of an extinction
    correction.
    ::


            GAUSSIAN  -  Default value. Suitable for X-rays
            LORENTZIAN - Suitable for Neutrons
   


   
 
* DIFFRACTION RADIATION
  This directive defines the experimental conditions used to
  collect the data.

  * RADIATION

    This parameter defines the type of radiation used to collect the
    data.
    ::


            XRAYS  -  Default value
            NEUTRONS
   

* CONDITIONS WAVELENGTH 

  * WAVELENGTH
    This defines the wavelength of the radiation used to collect
    the data.
    If omitted, a default value of 0.71073 is assumed,(Mo k-alpha).

   
   
   
.. index:: LIST 29

   
.. index:: Element properties


.. _LST29:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Elemental Properties  -  LIST 29
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
To perform calculations based on elemental properties, such as Sim
weighting for Fourier maps (section :ref:`FOURIER`), connectivity 
calculations, absorption
and density calculations, it is necessary to input the numbers and
properties of the elements in the cell.
This information, stored in LIST 29 is generally input as a \\COMPOSITION card,
which finds the required valuesm in a system file.
See the section :ref:`LIST29` for full details.

For example:
::


    \LIST 29
    READ NELEMENT=4
    ELEMENT MO NUM=0 .5 colour=purple
    ELEMENT S NUM=2
    ELEMENT O NUM=3
    ELEMENT C NUM=10
    END



=========
\\LIST 29
=========
* READ  NELEMENT

  * NELEMENT*
    This must be set to the number of atomic species in the asymmetric
    unit, and
    consequently the number of  ELEMENT directives that are about to 
    follow this directive.
    If this directive is omitted, a default value of one is assumed for
    NELEMENT.
   
* ELEMENT TYPE COVALENT  VANDERWAALS IONIC NUMBER MUA WEIGHT
  Each  ELEMENT directive provides the information about that atomic
  species in the asymmetric unit.
   

  * TYPE
    The element TYPE must conform to the TYPE conventions described in the
    section on atom syntax, :ref:`ATOMSYNTAX`.
    The default value for this parameter is taken from the COMMAND file.
    When LIST 29 is used for Simm weighting,
    the  TYPE  is compared with the  TYPEs stored
    in LIST 3 (section :ref:`LIST03`) to determine the scattering 
    factor of the given species.
   

  * COVALENT
  * VANDERWAALS
  * IONIC
    The radii used during geometry calculations,
    with a default values set in the COMMAND file. The covalent radius is
    incremented by 0.1 A for distance contacts, and
    used for defining restraint targets (see \\DISTANCES).
    The van der Waals radius is incremented by .25A for finding non-bonded
    contacts, and used for defining energy restraints
    The ionic radius may be used during geometry calculations.
   

  * NUMBER
    This parameter gives the number of atoms of the given type in the
    asymmetric unit.
    This number can be fractional, depending
    on the number of atoms in the cell and whether they occupy special
    positions, and whether they are disordered.
   

  * MUA
    This is the atomic absorption coefficient x10**(-23)  /cm as in INT TAB
    VOL III.  Note that in Vol IV the units are x10**(-24).
    Take care to ensure that the coefficients are appropriate
    for the wavelength used.
   

 * WEIGHT
   This is the Atomic weight
   
 * COLOUR*
   This is the colour to be used for each atom in CAMERON. The available 
   colours are:
   
   ::


       BLACK BLUE    CYAN   GREEN GREY   LBLUE LGREEN LGREY  
       LRED  MAGENTA ORANGE PINK  PURPLE RED   WHITE  YELLOW 
   
   

   
   
.. index:: LIST 30

   
.. index:: General crystallographic data


.. _LST30:

 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
General Crystallographic Data - LIST 30
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This list holds general crystallographic information (*GOODIES*) for later
inclusion in the cif file. CRYSTALS contains no COMMAND for editing
this list - inputting a new LIST 30 over writes any existing version.
There is a Menu item for updating some of the items in this list, and
some CRYSTALS operations also update LIST 30 as an analysis proceeds.
If you need to make major changes, punch out the list (//PUNCH 30), edit it,
and re-input it as a *USE* file. See the section :ref:`LIST30` for full details.


For example:
::



  \LIST 30
  CONDITIONS MINSIZE=.1 MEDSIZE=.3 MAXSIZE=.8 NORIENT=25
  CONTINUE   THORIENTMIN=15.0 THORIENTMAX=25.0
  CONTINUE   TEMPERATURE=293 STANDARDS=3 DECAY=.05 SCANMODE=2THETA/OMEGA
  CONTINUE   INSTRUMENT=MACH3
  INDEXRANGE HMIN==12 HMAX=12 KMIN==13 KMAX=13 LMIN==1 LMAX=19
  COLOUR RED
  SHAPE PRISM
  END




=========
\\LIST 30
=========



#LIST30


* DATRED
  Information about the data reduction process.

  * NREFMES
    The number of reflections actually measured in the diffraction
    experiment
  * RSIGMA
  * NREFMERG
    Number of unique reflections remaining after merging equivalents
    applying Friedel's Law
  * RMERGE
    Merging R factor (R int) applying Friedel's Law (as decimal not %)
  * NREFFRIED
    Number of unique reflections remaining after merging equivalents
    without applying Friedel's Law
  * RMERGFRIED
    Merging R factor (R int) without applying Friedel's Law (as decimal not %)
  * WILSONB
  * WILSONSCALE
  * REDUCTION
    Software used for data reduction. Known systems are:

    ::

     UNKNOWN            RC93              DENZO             SHELX        
     XRED               CRYSALIS          SAINT         


* CONDITIONS
  Information about data collection.

  * MINSIZE, MEDSIZE, MAXSIZE:
    The crystal dimensions, in mm.
  * NORIENT
    Number of orientation checking reflections.
  * THORIENTMIN
    Minimum theta value for orientating reflections.
  * THORIENTMAX
    Maximum theta value for orientating reflections.
  * TEMPERATURE
    Data collection temperature, Kelvin.
  * STANDARDS
    Number of intensity control reflections.
  * DECAY
    Average decay in intensity, %.
  * SCANMODE
    Data collection scan method. Options are
   
    ::

     2THETA/OMEGA       OMEGA             PHI               PHIOMEGA     
     UNKNOWN      
 


  * INTERVAL
    Intensity control reflection interval time, minutes. Used if standards
    are measured at a fixed time interval
  * COUNT
    Intensity control reflection interval count. Used if standards are
    measured after a fixed number (count) of general reflections.
  * INSTRUMENT
    Instrument used for data collection. Known instruments are:
   
    ::

     UNKNOWN           CAD4             MACH3            KAPPACCD     
     DIP               SMART            IPDS             XCALIBUR     
     APEX2             GEMINI           SUPERNOVA        SYNCHROTRON  



* REFINEMENT
  Information about the refinement procedure.

  * R
    Conventional R-factor.
  * RW
    Hamilton weighted R-factor. |br|\
    The weighted R-factor stored in  LIST 6 (section :ref:`LIST06`) and LIST 30 
    is that computed
    during a structure factor calculation. The conventional R-factor is
    updated by either an SFLS calculation (section :ref:`SFLS`)
    or a SUMMARY of LIST 6.
  * NPARAM
    Number of parameters refined in last cycle.
  * SIGMACUT
    The I/sigma(I) threshold used during refinement.
  * GOF
    GOF, Goodness-of-Fit, S.
  * DELRHOMIN
    Minimum and maximum electron density in last difference synthesis.
  * DELRHOMAX
  * ABSSHIFT/ESD
    R.m.s (shift/e.s.d) in last cycle of refinement.
  * NREFUSED
    Number of reflections used in last cycle of refinement.
  * FMINFUNC
    Minimisation function for diffraction observations.
  * RESTMINFUNC
    Minimisation function for restraints.
  * RMSSHIFT/ESD
  * COEFFICIENT
    Coefficient for refinement. Alternatives are:
   
    ::


            F (Default)
            F**2
            UNKNOWN
   



* INDEXRANGE
  Range of reflection limits during data collection.

  * HMIN, HMAX, KMIN, KMAX, LMIN, LMAX: 
    Minimum and maximum values of h,k and l.
  * THETAMIN, THETAMAX: 
    Minimum and maximum values of theta.


* ABSORPTION
  Information about absorption corrections.

  * ANALMIN, ANALMAX: 
    Minimum and maximum analytical corrections
  * THETAMIN, THETAMAX:
    Minimum and maximum theta dependant corrections
  * EMPMIN, EMPMAX: 
    Minimum and maximum empirical corrections (usually combination of theta
    and psi or multi-scan for area detectors).
  * DIFABSMIN, DIFABSMAX: 
    Minimum and maximum DIFABS type correction, i.e. based on residue 
    between Fo anf Fc (see section :ref:`DIFABS`). In the cif it is called
    a refdelf correction.
  * ABSTYPE
    Type of absorption correction. Alternatives are:
   
    ::


            NONE (default) EMPIRICAL    GAUSSIAN     SPHERICAL
            DIFABS         MULTI-SCAN   ANALYTICAL   CYLINDRICAL
            SHELXA         SADABS       NUMERICAL
                           SORTAV       INTEGRATION
                           PSI-SCAN 
                           SAINT            
      
   


* GENERAL
  General information, usually generated by CRYSTALS.

  * DOBS
    Observed density and that calculated by CRYSTALS.
  * DCALC
  * F000
    F(000), sum of scattering factors at theta = zero.
  * MU
    Absorption coefficient, calculated by CRYSTALS.
  * MOLWT
    Molecular weight, calculated bt CRYSTALS.
  * Z
  * FLACK
    The Flack parameter and its esd, if refined.
  * ESD
  * ANALYSE-SIGM
    These values are updated when ever \\ANALYSE is run, and can be used 
    to record the effect of different LIST 28 schemes. **Remenber** that if 
    the LIST 28 conditions are modified to include more reflections than 
    were used in the last \\SFLS calculation (section :ref:`SFLS`), the values 
    of Fc for the 
    additional reflections will be incorrect. An \\SFLS calculation sets 
    these to the same values as in REFINEMENT above.
  * ANALYSE-NREF
  * ANALYSE-R
  * ANALYSE-RW
  * SOLUTION
    The program/procedure used for structure solution
   
    ::

     UNKNOWN           SHELXS           SIR88            SIR92        
     PATTERSON         SIR97            DIRDIF           SUPERFLIP    
     SIR02             SIR04            SIR11        
   


* COLOUR

  * The crystal colour


* SHAPE

  * The crystal shape (estimated by CRYSTALS from the size)


* CIFEXTRA
  These are filled in by the \\SFLS CALC operation (section :ref:`SFLS`).  
  Structure factors are  computed for ALL reflections along with R and Rw - 
  LIST 28 is ignored (LIST 28, reflection filtering, see section :ref:`LIST28`). 
  R and Rw are also computed for reflections above a given 
  threshold.

  * CALC-SIGMA, CALC-NREF, CALC-R, CALC-RW
  * ALL-SIGMA, ALL-NREF, ALL-R, ALL-RW
  * EXTNCTN-SU
  * COMPLETENESS
  * THETA-FULL
  * COMPL-FULL
  * PRESSURE
  * NRESTUSED
  * CCESD
  * XMIN, YMIN, ZMIN
  * H-TREATMENT

    ::

     UNDEF              MIXED             REFALL            REFXYZ       
     REFU               NOREF             UNDEF             CONSTR       
     NOREF        


----

************************
Preparation of the model
************************
This may be the input by hand, i.e. atomic coordinates typed directly into CRYSTALS, or 
into a file to be :ref:`USED <use source>` by CRYSTALS.

::

 e.g.
      \LIST 5
      READ  NATOM = 3
      ATOM  C 1 X=.23  .37   .45
      ATOM  C 2 X=.31  Y=.06 .78
      ATOM  O 6 OCC=.5 X=0.5  0   .25
      END

 The ordered list of parameters for an atom are:

 Type Serial Occupation Flag X Y Z U[11]/U[iso] U[22] ...U[12] + others

 Note that the parameters x, y, z are in sequence, so only the first keyword is
 required, and that the parameters for atoms on special positions are not coded
 (as required by SHELX), There are defaults of 1.0 for occupancies and 0.05 for Uiso.



The atoms are more likely to come from a direct methods program, from finding additional
atoms in Fourier maps, or modifying the existing model (with \\PEAKS, \\EDIT,
\\COLLECT, \\REGROUP,
\\REGULARISE, \\MOLAX, \\HYDROGENS, or \\ANISO). These involve operations
on LIST 5.

::

 It is a good idea to assign a final atom numbering scheme as soon as
 possible in the analysis. This will save a lot of hastle later.

 CRYSTALS can generate a good numbering scheme automatically, which will
 serve very well for most structures.
 
 Note that if you want to number the atoms manually so that they correspond
 to a scheme used elsewhere (e.g. a published paper or related material),
 you MUST not use facilities like \REGROUP.

.. _\Peaks:

.. index:: \Peaks 

^^^^^^^^^^
1. \\Peaks
^^^^^^^^^^
This command converts the output from a Fourier peak search (held as a
LIST 10) into a parameter list, LIST 5. It associates any new PEAKS with
existing atoms. It can also be used for Fourier refinement, and for
rejecting duplicate atoms, e.g. after changing space group.
The section :ref:`FOURIER <FOURIER>` explains the output of the Fourier peak search, and 
how it search can be controlled.


.. index:: \Collect
.. index:: \Regroup

^^^^^^^^^^^^^^^^^^^^^^^^
2. \\Collect & \\Regroup
^^^^^^^^^^^^^^^^^^^^^^^^
These commands assist in assembling molecules from peaks lists. 
:ref:`REGROUP <REGROUP>` applies symmetry and
reorders the atoms in LIST 5, :ref:`COLLECT <COLLECT>` only applies symmetry. 
Both can be
made to work with all atoms in LIST 5, or only operate on peaks of type
Q (i.e. unassigned peaks). These are powerful utilities and can save a lot of manual editing.
 
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
|br|\
You should be familiar with the recommendations for 
:ref:`atom identifiers <Atom ID>` used in CRYSTALS


.. index:: \Edit

^^^^^^^^^
3. \\Edit
^^^^^^^^^
The CRYSTALS editor, :ref:`EDIT <Editing Atoms>`, is designed to perform crystallograhic
operations on the atom parameters, in LIST 5. If anything needs to be done
on groups of atoms, \\EDIT is likely to be more convenient than using a text
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

 
.. index:: Geometry - Model Building

.. _geometry-1:

^^^^^^^^^^^^^
4. \\Geometry
^^^^^^^^^^^^^
This command is used to examine the geometry of the model and can
also be used to force certain geometries onto the model. MOLAX computes
best planes and lines (molecular axes), TLS computed the rigid body tensors,
AXES the principal axes of the anisotropic displacement parameters. See
:ref:`GEOMETRY <GEOMETRY>` and :ref:`Geometry Calculations <geometry-2>`.

::

      \GEOMETRY
      ATOM C(1) UNTIL C(6)
      PLANE
      REPLACE C(1) UNTIL C(6)
      END

      These commands compute the best plane through six atoms  and then
      replace the original coordinates with those for atoms lying in the 
      plane.


.. index: Refinement Overview 

**********
Refinement
**********
CRYSTALS was originally developed to perform difficult or complex
refinements, and was subsequently modified to simplify the treatment of
routine cases. There are seven components to a refinement strategy.


 

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
1. Structure factor control list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
On slow computers or for large structures,
the structure factor computation can be speeded up by disabling the
contributions from parameters or data that have null or default values. These
'switches' are in LIST 23, the structure factor control list.
The default values in this list are usually suitable.
Some switches may be reset
automatically by CRYSTALS. You will be told when this happens.
For disordered structures, you may need to inhibit special position
checking, or reduce the tolerance for atom matching. See the section
:ref:`LIST23` .
 
::

  e.g.
      \LIST 23
      REFINE  SPECIAL=TEST UPDATE=NO
      END
  or
      \LIST 23
      REFINE  TOLERANCE = .1
      END

 

^^^^^^^^^^^^^^^^^^^^^^^^
2. Refinement definition
^^^^^^^^^^^^^^^^^^^^^^^^
Defining the parameters to be refined. This information is held in LIST 12, separately
from the atom coordinates in LIST 5. This list also contains information
about the matrix blocking, constrained parameters, riding parameters, rigid
groups and other special processes.  A feature of CRYSTALS, not easily replicated
in other programs, is the ability to very simply choose a subset 
of the parameters to be 
refined at any one time.  This means that in a large structure which is generally
well behaved, the User can concetrate on small areas which are problematic
(usually solvents or disorder) before finally refining the whole structure. 
 


The release version of CRYSTALS (2019) will refine about 8,000 atoms full 
matrix or 50,000 atoms by anisotropic atom-block
diagonal methods. The parameters to
be refined are specified in LIST 12. For full details, see the section
:ref:`LIST12` .
 
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
extend the .DSC file if automatic extension is not enabled. See 
:ref:`Extending the disk <extend_disk>`.`.

 

^^^^^^^^^^^^^^^^^^^^
3. Special positions
^^^^^^^^^^^^^^^^^^^^

In CRYSTALS, the occupancy of an atom is the *chemical* occupancy, i.e. the fraction of an 
atom which would be expected at the site ignoring the crystallographic multiplicity.
The the user needs only be concerned with partial occupancy due to disorder, etc. 
|br|\
CRYSTALS normally automatically applies the constraints or restraints necessary for
the treatment of atoms on special positions, and adjusts the site
occupancy. Default actions are set in :ref:`LIST 23 <LIST23>`, and if these are disabled
they can be set on demand with :ref:`\\SPECIAL <SPECIAL>`. 


 

^^^^^^^^^^^^^^^^^^^^^^^^^^^
4. Treatment of reflections
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Reflections may be included or excluded from computations
depending on values of filters set in :ref:`LIST 28 <LIST28>`. Reflections are not actually
deleted from the reflection list, but merely flagged as not-to-be-used. The 
filters can be set and reset at any time to include/exclude reflections
 
::

 e.g.
      \LIST 28
      MINIMA RATIO=3.0
      READ NOMISSION=2
      OMIT 2 0 0
      OMIT 0 2 2
      END


 

^^^^^^^^^^^^^^^^^^^^^^^^^^^^
5. Weighting the reflections 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
A large number of schemes are possible,  defined in LIST 4. Schemes are
available for F or Fsq refinement.
|br|\
By default, unit weights are set for initial refinement refinement against F
and statistical weights are used for refinement against |F2|.

Once the
model is fully parameterised (all atoms found) and more or less converged,
alternative weights should be chosen to obtain the most realistic estimated
standard deviations. There is a menu item :ref:`(under REFINE) <Refinement Menu>` to help set a 
suitable weighting scheme.
|br|\
The :ref:`ANALYSE <analyse>` menu produces an analysis of residuals. The column headed
<w*deltasq> should be more or less constant for suitable weights.

 

^^^^^^^^^^^^^
6. Restraints
^^^^^^^^^^^^^
Treatment of restraints.
CRYSTALS offers many restraints. They are stored in symbolic form in
:ref:`LIST 16 <list16>`, and are converted to computable format by the command *\\LIST 26*. 
CRYSTALS normally does this conversion automatically, but the user can type |blue| \\LIST 16
|xblue| to force conversion if there are problems with creating a valid LIST 16.
 
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
 

^^^^^^^^^^^^^^^^
7. Least Squares
^^^^^^^^^^^^^^^^
Least squares are initiated once the preparations are completed. 
If refinement converges or diverges before the specified
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
Seeing the structure
********************


^^^^^^^^^^^^^^^^^^^^^^^
Listing the coordinates
^^^^^^^^^^^^^^^^^^^^^^^
The atomic parameters are kept in LIST 5. They can be displayed on the
screen or printer file with:
 
::

      \DISPLAY      low/medium/high
      END


The atomic coordinates are also summarised below the graphics window. This display list 
can be sorted by clicking on a column header - this **DOES NOT** sort the stored LIST 5.
Items can also be edited in this graphical summary. LIST 5 will be updated. 
 
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
 


.. index:: Geometry Calculations

.. _geometry-2: 


******************
Molecular geometry
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
|br|\ 
Text files suitable for editing into documents or as part
of a commnd file suitable to reading into CRYSTALS may also be
produced.
 
::

      \DISTANCE
      END

 

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Best planes, lines and dihedral angles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Planes, lines and the angles between them are computed with \\GEOMETRY. See also
:ref:`Geometry - Model Building <geometry-1>`.
 
::

      \GEOMETRY     
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
EXECute, as in EDIT, forces immediate execution of the preceeding directive.
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

      \GEOMETRY
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
Publication listings
********************
Normally journals require crystallographic information to be submitted in the forM of *cif* 
files. CRYSTALS can also output plain text files suitable fo inclusion in
other documents. |br|\
Atomic coordinate and structure factor listings are organised to fit onto
A4 paper or AS a continuous listing.
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

 
