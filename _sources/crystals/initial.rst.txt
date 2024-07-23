.. toctree::
   :maxdepth: 1
   :caption: Contents:



******************
Initial Data Input
******************


.. _initialdinput:

 



========================================
Scope of the Initial Data Input section.
========================================





The areas covered are:
::


    Abbreviated startup command                      QUICKSTART
    Input of the cell parameters                     LIST 1
    Input of the unit cell parameter errors          LIST 31
    Input of the space group symmetry information    SPACEGROUP
    Alternative input of the symmetry information    LIST 2
    Input of molecular contents                      COMPOSITION
    Input of the atomic scattering factors           LIST 3
    Input the structural formula as a SMILES string  LIST 18
    Input of the contents of the unit cell           LIST 29
    Input of the crystal and data collection details LIST 13
    Input of general crystallographic data           LIST 30







.. index:: QUICKSTART


.. index:: Getting started


==========================================
Abbreviated startup command  -  QUICKSTART
==========================================



The command QUICKSTART is provided to assist in migration from other
systems to CRYSTALS. It requires that data reduction (section :ref:`DATAREDUC`) 
has already been
done or that a simple 4-circle Lp correction be suitable,
and that the reflection data are available in a fixed format file with
one reflection per line. This command expands the given data into
standard CRYSTALS lists, as described elsewhere in the manuals. The user
is free to overwrite LISTS created by QUICKSTART by entering new LISTS
manually.

::


    \QUICKSTART
    SPACEGROUP SYMBOL=
    CONTENTS FORMULA=
    FILE NAME=
    FORMAT EXPRESSION=
    DATA WAVELENGTH= REFLECTIONS= RATIO=
    CELL  A= B= C= ALPHA= BETA= GAMMA=
    END





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







------------
\\QUICKSTART
------------

   None of the directives may be omitted, though some parameters do have
   default values. **CONTINUE** **directives** **may** **not** **be** **used.**
   
   
   

**SPACEGROUP SYMBOL=**



   
   This directive generates symmetry information from the spacegroup symbol.
   The syntax is exactly as describe for the command SPACEGROUP, given
   in section :ref:`SPACEGROUP`.
   

*SYMBOL=*



   
   There is no default for the symbol, it should be a valid H-M space group
   symbol, e.g. 'P 21 21 21' or 'P 21/c' or 'I -4 3 m'. Use spaces to 
   separate each of the operators.
   
   
   

**CONTENTS FORMULA=**



   
   This directive takes the contents of the UNIT CELL 
   (cf LIST 29 - section :ref:`LIST29`) and generates scattering factors 
   (LIST 3 - section :ref:`LIST03`) and elemental properties (LIST 29 - section
   :ref:`LIST29`).
   

*FORMULA=*


   The formula for the UNIT CELL contents
   **(NOT** **ASYMMETRIC** **UNIT** - for compatibility with SIR92)
   is given as a list with entries of the type
   ::


             'element name' 'number of atoms'
      
       e.g. CONTENT FORMULA = C  24  H  36  O  8  N  4
   


   

   
   The items in the list **must** be separated by at least one space. The
   number of atoms may be fractional or, if omitted, they 
   default to 1.0.
   
   
   

**FILE NAME=**



   
   This directive associates the file containing the reflections with
   the program. The special name *'COMMANDS'* causes reflection data to be read
   from the command stream. The reflections MUST then be terminated with an
   'h' value of -512, otherwise the end-of-file is sufficient.
   

*NAME=*


   The name of the file containing the reflections. The
   syntax of the name must conform to the computers operating system. See
   the **IMMEDIATE** command \\SET FILE for case sensitive systems.
   
   
   

**FORMAT EXPRESSION=**



   
   This directive controls the reading of the reflection list. The reflection
   file must contain the following items in the order given. Only one
   reflection is permitted per line.
   See \\LIST 6 for more flexible input (section :ref:`LIST06`)
   ::


                h k l F and optionally sigma(F)
   


   

   
   
   F and sigma(F) may be replaced by I or F-squared.
   

*EXPRESSION=*


   The expression is a normal FORTRAN format expression, **including** **the**
   **open** **and** **close** **parentheses.**
   The descriptor 'nX' may be used to skip unwanted
   columns. The indices may be I or F format.
   There is no default expression.
   
   
   
   
   

**DATA WAVELENGTH= REFLECTIONS= RATIO=**


   
   
   

*WAVELENGTH=*


   The wavelength, in Angstroms, used in selecting elemental properties. The
   default is 0.7107 (Molybdenum K-alpha radiation).
   

*REFLECTIONS=*


   A keyword to indicate whether the input data is F, F-squared or I.
   ::


            FOBS     -  Default, indicating F values being input.
            FSQUARED -  Indicating F squared values being input.
            I        -  Indicating intensity values being input.
   


   

   
   If REFLECTIONS equals I, then an Lp correction is done assuming four circle
   geometry. Note that the reflections from modern diffractometers are 
   unlikely to be stored as FOBS. Some old X-ray data and neutron data may 
   still be given as FOBS.
   

*RATIO=*


   The minimum ratio of I/sigma(I) to be used in selecting reflections.
   Default is 3.0
   
   
   

**CELL  A= B= C= ALPHA= BETA= GAMMA=**


   The real cell parameters. The angles default to 90.0 degrees.
   
   
   
   
   
.. index:: LIST 1

   
.. index:: Cell parameters


.. _LIST01:

 
=======================================
Input of the cell parameters  -  LIST 1
=======================================





Either the real cell parameters or the reciprocal cell
parameters may be input and the three angles be given in degrees or
as their cosines.
A mixed form, containing both angles and cosines is not allowed.

::


    \LIST 1
    REAL A= B= C= ALPHA= BETA= GAMMA=
    END





For example
::


    \LIST 1
    REAL 14.6 14.6 23.7 GAMMA=120
    END







--------
\\LIST 1
--------

   
   
   

**REAL A= B= C= ALPHA= BETA= GAMMA=**



   
   This directive introduces the real cell parameters.
   If this directive is present, the directive  RECIPROCAL
   will lead to an input error, and no new LIST 1 will be generated.
   

*A=, B=, C=*


   These parameter are the real cell lengths along the  A, B and C axes.
   There are no default values.
   

*ALPHA=, BETA=, GAMMA=*


   These parameters give the real cell angles
   or their cosines. The default value is 90 degrees.
   
   
   

**RECIPROCAL A*= B*= C*= ALPHA*= BETA*= GAMMA*=**


   This directive introduces the reciprocal cell parameters.
   If this directive is present, the directive  REAL
   will lead to an input error, and no new LIST 1 will be generated.
   

*A*=, B*=, C*=*


   These parameters are the reciprocal cell lengths.
   

*ALPHA*=, BETA*=, GAMMA*=*


   These parameters give the reciprocal cell angles or their cosines.
   The default value is 90 degrees.
   
   

============================
Printing the cell parameters
============================




---------
\\PRINT 1
---------


   
   This command lists the cell parameters, and all the other information
   derived from them which is stored in LIST 1.
   The inter-axial angles are stored in radians in LIST 1, and printed as
   such.
   
   

---------
\\PUNCH 1
---------


   
   Punches the real cell parameters from  LIST 1.
   
   
   
   
   
   
   
.. index:: Cell errors

   
.. index:: List 31


.. _LIST31:

 
===================================================
Input of the unit cell parameter errors  -  LIST 31
===================================================





This list contains the variance-covariance matrix of the unit
cell parameters. The input consists of a multiplier which is
applied to all input parameters,
followed by the upper
triangle of the variance-covariance matrix (21 Numbers).
The units for the angles **MUST** be
radians and those for the cell lengths are Angstroms.

::


    \LIST 31
    AMULT VALUE=
    MATRIX V(11)= V(12)= .. V(16)= .. V(22)= .. V(26)= .. V(66)=
    END





For example
::


    \LIST 31
    \ the values of the input matrix are to be multiplied
    \ by 0.000001
    AMULT 0.000001
    \ the cell is trigonal,
    \ with errors of 0.002 along 'a' and 'b', and 0.004 along 'c'
    MATRIX 4 4 1 0 0 0
    CONT     4 1 0 0 0
    CONT      16 0 0 0
    CONT         0 0 0
    CONT           0 0
    CONT             0
    END







---------
\\LIST 31
---------

   
   
   

**AMULT VALUE=**



   
   This directive gives the value by which all the subsequent terms
   are to be multiplied, and has a default of 1.0.
   

*VALUE=*


   
   
   

**MATRIX V(11)= V(12)= . . V(16)= V(22)= . . V(66)=**



   
   This directive is used to read in the variance-covariance matrix.

   
   If you only have the parameter e.s.d's, input the square of these for
   V(11), V(22) etc.
   

*V(11)= V(12)= . . V(16)= V(22)= . .V(66)=*


   V(11) is the variance of  A ,  V(12)  is the covariance of  A
   and  B ,  V(16)  is the covariance of  A  and  GAMMA ,
   V(22)  is the variance of  B , and  V(66)  is the variance of
   GAMMA . The default values for V(11), V(22) and V(33) correspond to axis
   e.s.d's of .001 A, V(44), V(55) and V(66) to angle e.s.d's of .01 degree.
   
   

============================================
Printing the cell variance-covariance matrix
============================================




----------
\\PRINT 31
----------


   
   This prints list 31. There is no command for punching LIST 31.
   
   
   
   
   
.. index:: Space group input

   
.. index:: SPACEGROUP


.. _SPACEGROUP:

 
================================
Space Group input - \\SPACEGROUP
================================



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

::


    \SPACEGROUP
    SYMBOL EXPRESSION=
    AXIS UNIQUE=
    END





For example
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







------------
\\SPACEGROUP
------------

   
   
   

**SYMBOL EXPRESSION=**



   
   This directive is used to specify the space group symbol.
   

*EXPRESSION=*


   The value of this parameter is the text making up the spacegroup
   symbol.  At least one
   space character should appear between each of the axis symbols
   in the spacegroup symbol. e.g.
   ::


       Use  P 21 3 rather than P 213, P2 1 3, or P2 13
   


   

   
   Failure to put spaces in the correct place in the symbol will
   lead to misinterpretation.

   
   Rhombohedral cells are always assumed to be on hexagonal indexing.
   
   
   

**AXIS UNIQUE=**



   
   This directive specifies the unique
   axis orientation for
   monoclinic spacegroups where the symbol specified
   contains only one axis symbol (short symbol). In other cases any information
   specified with this directive is ignored.
   

*UNIQUE=*


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
   are all close too 90 degrees or there is no valid cell parameter
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
   


   
   
   ::


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


.. _LIST02:

 
=====================================
Input of the symmetry data  -  LIST 2
=====================================





The result of inputting a \\SPACEGROUP command (section :ref:`SPACEGROUP`) 
is the automatic generation of a 'LIST 2' containing the explicit 
symmetry operators and other information that defines the spacegroup.


Direct input of this list enables the user to specify explicitly 
the symmetry operators to be used. The advantage of this is that 
they need not comply to any standard convention - the only
check made by the program is to ensure that the determinant is 
not zero. For example, this technique may be used to enter a 
set of symmetry operators that contains a translation of a half along
an axis - normally that cell length would be halved instead, but it may
be useful in order to work consistently with a structure that undergoes
a cell-doubling phase transition.

::


    \LIST 2
    CELL NSYMMETRIES=  LATTICE=  CENTRIC=
    SYMMETRY  X=  Y=  Z=
    SPACEGROUP LATTICE= A-AXIS= B-AXIS= C-AXIS=
    CLASS NAME=
    END




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
The unit matrix, defining x, y, z, **MUST** **ALWAYS** be input.
If a centric cell is used in a setting which does not place the centre
at the origin, then ALL the operators must be given and the cell be
treated as non-centric. This will of course increase the time for
structure factor calculations.


Rhombohedral cells can be treated in two ways. If used with
rhombohedral indexing (a=b=c, alpha=beta=gamma), the lattice type is P,
primitive.
If used with hexagonal indexing, the lattice type is R.



--------
\\LIST 2
--------

   
   
   

**CELL NSYMMETRIES=  LATTICE=  CENTRIC=**


   

*NSYMMETRIES=*


   This defines the number of SYMMETRY directives that are to follow.
   There is no default.
   

*LATTICE=*


   This defines the Bravais lattice type, and must take
   one of the following values :
   
   
   ::


            P  -  Default value.
            I
            R
            F
            A
            B
            C
   


   
   

*CENTRIC=*


   This parameter defines whether the cell is centric or acentric, and must
   take one of the values :
   ::


            NO
            YES  -  The default value.
   


   
   

**SYMMETRY  X=  Y=  Z=**


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
   
   
   

**SPACEGROUP LATTICE= A-AXIS= B-AXIS= C-AXIS=**


   This directive inputs the space group symbol, and is optional for the
   correct working of CRYSTALS. However, some foreign programs need
   the symbol as input data, and they will extract it from this record.
   The keywords LATTICE, A-AXIS etc are normally omitted, and the full
   space group symbol given with spaces between the operators, e.g.
   ::


              SPACEGROUP P 1 21/C 1
   


   
   
   
   

**CLASS NAME=**


   This directive inputs the crystal class. It is not used by CRYSTALS, but is
   required for cif files.
   
   
   
   

=================================
Printing the symmetry information
=================================




---------
\\PRINT 2
---------


   
   This prints LIST 2. There is no command for punching LIST 2.
   
   

   
   Further examples.
   
   ::


       \ THE SPACE GROUP IS P1-BAR.
       \LIST 2
       CELL NSYM= 1
       SYM X, Y, Z
       SPACEGROUP P -1
       END
   


   
   
   ::


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
   


   
   
   ::


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


============================================
Input of molecular composition \\COMPOSITION
============================================

This command takes the contents of the asymmetric unit, searches the
specified data files for required values, and then internally creates normal
scattering factors (LIST 3 - section :ref:`LIST03`) and elemental 
properties (LIST 29 - section :ref:`LIST29`). **NOTE**
**LISTS** **1** (see :ref:`LIST01`) **and** **13** (see  :ref:`LIST13`) 
**must** **have** **been** **input** **beforehand.**

::


    \COMPOSITION
    CONTENTS FORMULA=
    SCATTERING FILE=
    PROPERTIES FILE=
    END




For example:

::


    \COMPOSITION
    CONTENT C 6 H 5 N O 2.5 CL
    SCATTERING CRSCP:SCATT.DAT
    PROPERTIES CRSCP:PROPERTIES.DAT
    END







-------------
\\COMPOSITION
-------------


   
   There are three directives, none of which have default values.
   
   
   

**CONTENTS FORMULA=**


   

*FORMULA=*


   The formula for the UNIT CELL
   (NOT ASYMMETRIC UNIT) is given as a list with entries
   ::


       'element TYPE' 'number of atoms'.
   


   
   The items in the list MUST be separated by at least one space. The number
   of atoms may be omitted, when they default to 1.0, and may be fractional.
   
   
   The element TYPE must conform to the TYPE conventions described in the
   atom syntax, section :ref:`ATOMSYNTAX`.
   
   
   

**SCATTERING FILE=**


   This directive gives the name of the
   file to be searched for scattering factors, and must conform to the syntax
   of the computing system. A file CRSCP:SCATT.DAT is provided for some
   implementations, and contains all the scattering factors listed in
   Volume IV, International Tables.
   
   
   

**PROPERTIES FILE=**


   This directive gives the name of the
   file to be searched for elemental properties, and must conform to the syntax
   of the computing system. A file CRSCP:PROPERTIES.DAT is provided for
   some
   implementations, and contains values gleaned from various sources. The
   file contains references.
   
   
   
   
   
.. index:: LIST 3

   
.. index:: Scattering factors


.. _LIST03:

 
===================================================
Input of the atomic scattering factors  -  \\LIST 3
===================================================





This list contains the scattering factors that
are to be used for each atomic species that may appear in the
atomic parameter list (LIST 5)
- see the section of the user guide on Atom and Element names).

::


    \LIST 3
    READ  NSCATTERERS=
    SCATTERING TYPE= F'= F''= A(1)= B(1)= A(2)= . . . B(4)= C=
    END






For example

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
is determined by its  TYPE, an entry for which must exist in LIST 3.


The form factor is calculated analytically at each value
of sin(theta)/lambda,  s , from the relationship :
::


    f = sum[a(i)*exp(-b(i)*s*s)] + c       i=1 to 4.




The coefficients a(1) to a(4), b(1) to b(4) and c and the real and
imaginary parts of the anomalous dispersion correction
are input for each element TYPE.



--------
\\LIST 3
--------


   
   This is the normal calling command for the input of LIST 3.
   
   
   

**READ  NSCATTERERS=**


   

*NSCATTERERS=*


   This must be set to the number of atomic species to be stored
   in LIST 3, and thus the number of  SCATTERING  directives to follow.
   There is no default value.
   
   
   

**SCATTERING TYPE= F'= F''= A(1)= B(1)= A(2)= . . . B(4)= C=**


   This directive provides the form factor details for one atomic species.
   This directive must be repeated  NSCATTERERS  times.
   

*TYPE=*


   The element TYPE must conform to the TYPE conventions described in the
   General Introduction.
   The values used for  TYPE  in LIST 3 will have their counterparts
   in the  TYPEs stored for atoms in LIST 5 (the model parameters), 
   and in the  TYPEs
   stored for atomic species in LIST 29 (see section :ref:`LIST29`).
   There is no default for this parameter.
   

*F'= F''=*


   These define the real and imaginary parts of the anomalous dispersion
   correction for this atomic species at the appropriate wavelength.
   A default value of zero is assumed if these parameters are omitted.
   

*A(1)= B(1=) A(2=) B(2)= A(3)= B(3)= A(4)= B(4)= C=*


   These define the coefficients used to compute the
   scattering factor for this atomic species. There are
   no default values.
   
   ::


        For neutrons, all the A(i) and B(i) are set to zero, and C is set to
       the scattering length.
   


   
   
   

===============================
Printing the scattering factors
===============================




---------
\\PRINT 3
---------


   
   This prints LIST 3. There is no command for punching LIST 3.
   
   
   
.. index:: LIST 13

   
.. index:: Experimental details


.. _LIST13:

 
============================================================
Input of the crystal and data collection details  -  LIST 13
============================================================





LIST 13 contains information about those experimental details
which may be needed during structure analysis.
Information only required for
the generation of a cif are held in LIST 30 (section :ref:`LIST30`).


If no LIST 13 has been input and one is 
required, a default list is generated.

::


    \LIST 13
    CRYSTAL FRIEDELPAIRS= TWINNED= SPREAD=
    DIFFRACTION GEOMETRY= RADIATION=
    CONDITIONS WAVELENGTH= THETA(1)= THETA(2)= CONSTANTS . .
    MATRIX R(1)= R(2)= R(3)= . . . R(9)=
    TWO H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=
    THREE H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=
    REAL COMPONENTS= H= K= L= ANGLES=
    RECIPROCAL COMPONENTS= H= K= L= ANGLES=
    AXIS H= K= L=




For example:

::


    \LIST 13
    DIFF GEOM= CAD4
    COND WAVE= .7107
    MATRIX
    END







---------
\\LIST 13
---------


   
   This directive describes properties that relate to the whole
   crystal.
   
   
   
   
   

**CRYSTAL FRIEDELPAIRS= TWINNED= SPREAD=**


   
   
   

*FRIEDELPAIRS=*


   This parameter defines whether Friedel's law should be used during
   \\SYSTEMATIC in
   data reduction. It should be set to NO for high accuracy or absolute
   structure determinations. If omitted, Friedel's law will be used.
   ::


            YES  -  default value.
            NO
   


   
   

*TWINNED=*


   This parameter is used during refinement to indicate
   whether the twin laws should be used. It is automatically updated
   if twinned reflection data is input.
   ::


            NO  -  Default value.
            YES
   


   
   

*SPREAD=*


   This parameter defines the type of mosaic spread in the crystal.
   This information is used during the calculation of an extinction
   correction.
   ::


            GAUSSIAN  -  Default value. Suitable for X-rays
            LORENTZIAN - Suitable for Neutrons
   


   
   
   
   

**DIFFRACTION GEOMETRY= RADIATION=**



   
   This directive defines the experimental conditions used to
   collect the data.
   

*GEOMETRY=*


   This defines the type of data collection method used
   to measure the raw intensities, and determines the type of Lp
   correction.
   
   ::


            NORMAL  -  Normal beam Weissenberg geometry.
            EQUI    -  Equi-inclination Weissenberg geometry.
            ANTI    -  Anti-equi-inclination Weissenberg geometry.
            PRECESSION
            CAD4    -  Nonius CAD4 diffractometer, Eulerian angles.
            KAPPA   -  Nonius CAD4 in kappa geometry.
            ROLLETT -  Abstract machine, see page 28 , Computing Methods
                       in Crystallography.
            Y290    -  Hilger-Watts Y290 4-Circle diffractometer.
            NONE    -  Default.
   


   
   

*RADIATION=*


   This parameter defines the type of radiation used to collect the
   data.
   ::


            XRAYS  -  Default value
            NEUTRONS
   


   
   

**CONDITIONS WAVELENGTH= THETA(1)= THETA(2)= CONSTANTS . .**



   
   This directive describes the conditions that were used when the
   data were collected.
   CONSTANTS  is short for four constants.
   ::


            CONSTANT(1)= CONSTANT(2)= CONSTANT(3)= CONSTANT(4)=
   


   
   

*WAVELENGTH=*


   This defines the wavelength of the radiation used to collect
   the data.
   If omitted, a default value of 0.71073 is assumed,(Mo k-alpha).
   

*THETA(1)=*


   This defines the Bragg angle of the monochromator.
   If omitted, a default of 6.05 is assumed, indicating
   that a monochromator was used with Mo radiation
   

*THETA(2)=*


   This defines the angle between the plane of the
   monochromator and the diffracting planes of the crystal.
   If this parameter is omitted, a default value of 90 is assumed.
   This value is not used if  THETA(1)  is zero.
   Since the angle  THETA(2)  is fixed, the Lp correction computed
   using these constants is correct only for experiments where  THETA(2)
   is a constant.
   This is true for equatorial geometry experiments, but is not true
   for equipment that uses Weissenberg or precession geometry.  It is not 
   true for area detector instruments.
   

*CONSTANT(1)= CONSTANT(2)= CONSTANT(3)= CONSTANT(4)=*


   These four parameters are used to input fundamental constants
   for the diffractometer used to collect the data.
   How many of the constants, and what values they should have are
   determined by the equipment and its setting.
   To determine the values required, consult your local diffractometer
   expert.
   The default values for c(1), c(2) and c(3) are the Nonius CAD4 GONCON
   constants, and c(4) is the theta value for the change from
   bisecting to fixed chi mode (and has a value of 90 degrees).
   These constants are important when machine geometry dependent
   calculations are made - for example, absorption corrections.
   The defaults in the program were correct for the Nonius CAD4 
   in the Oxford Chemical Crystallography lab on 13 October 1980.
   
   
   

**MATRIX R(1)= R(2)= R(3)= . . . R(9)=**



   
   This directive is used to input the orientation matrix directly.
   If this directive is input, the directives  TWO ,  THREE ,  REAL ,
   and  RECIPROCAL (detailed below) may not be used.
   This directive is normally used for diffractometer collected data.
   

*R(1)= R(2)= R(3)= . . . R(9)=*


   The elements of the matrix must be input in the order
   (1,1), (1,2), (1,3), (2,1), etc.
   The default is a unit diagonal matrix.
   
   
   

**TWO H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=**



   
   This directive is used to input the setting details
   required to define a diffractometer orientation matrix from
   two reflections.
   The details for the two reflections must be input on separate
   directives, so that this directive must be repeated twice.
   This directive may only be input when the  GEOMETRY parameter 
   on the DIFFRACTION directive is  Y290  or  CAD4 .
   If this directive is input, the directives  THREE ,  REAL ,
   RECIPROCAL , and  MATRIX  may not be used.
   The reflections should be given in the same order as
   in the original experiment.
   

*H= K= L=*


   These three parameters define the indices of the reflection
   that is to be used to calculate the orientation matrix.
   

*THETA= OMEGA= CHI= PHI= KAPPA= PSI=*


   These parameters define the setting angles for the reflection
   whose indices are given by  H ,  K  and  L .
   There are no default values for  THETA ,  OMEGA  and  PHI , and
   one of  CHI or KAPPA must be input.
   The default values for CHI , KAPPA and PSI are zero.
   
   
   

**THREE H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=**



   
   This directive is used to input the setting details
   required to define a diffractometer orientation matrix from
   three reflections.
   The details for the three reflections must be input on separate
   directives, so that this directive must be repeated three times.
   This directive may only be input when the  GEOMETRY  parameter 
   on the DIFFRACTION  directive is  Y290  or  CAD4 .
   If this directive is input, the directives  TWO ,  REAL ,
   RECIPROCAL , and  MATRIX  may not be used.
   

*H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=*


   These parameters are defined as for TWO above.
   
   
   

**REAL COMPONENTS= H= K= L= ANGLES=**


   This directive is used to define the orientation matrix for
   the Nonius CAD4 diffractometer from the components of the real
   vector along the phi axis and the setting angles of one reflection.
   The  items COMPONENTS  and  ANGLES  are short for:
   
   
   
   COMPONENT(1)= COMPONENT(2)= COMPONENT(3)=
   
   and
   
   THETA= OMEGA= CHI= PHI= KAPPA= PSI=
   
   
   If this directive is input, the directives  TWO ,  THREE ,
   RECIPROCAL , and  MATRIX  may not be used.
   This directive may only be input when the  GEOMETRY  parameter
   on the DIFFRACTION  directive is  CAD4 .
   

*COMPONENT(1)= COMPONENT(2)= COMPONENT(3)=*


   These three parameters provide the components of the real cell
   vector that is parallel to the phi axis.
   

*H= K= L= THETA= OMEGA= CHI= PHI= KAPPA= PSI=*


   These parameters are defined as in TWO above
   
   
   

**RECIPROCAL COMPONENTS= H= K= L= ANGLES=**


   This directive is used to define the orientation matrix for
   the Nonius CAD4 diffractometer from the components of the reciprocal
   vector along the phi axis and the setting angles of one reflection.
   The  items COMPONENTS  and  ANGLES  are short for:
   
   
   
   COMPONENT(1)= COMPONENT(2)= COMPONENT(3)=
   
   and
   
   THETA= OMEGA= CHI= PHI= KAPPA= PSI=
   
   
   If this directive is input, the directives  TWO ,  THREE ,
   REAL , and  MATRIX  may not be used.
   This directive may only be input when the  GEOMETRY  parameter
   on the DIFFRACTION  directive is  CAD4 .
   

*COMPONENT(1)= COMPONENT(2)= COMPONENT(3)=*


   These three parameters provide the components of the reciprocal cell
   vector that is parallel to the phi axis.
   

*H K L THETA OMEGA CHI PHI KAPPA PSI*


   These parameters are defined as in TWO above
   
   
   

**AXIS H= K= L=**



   
   This directive is used to define the axis about which data were
   collected in Weissenberg geometry.
   This directive may only be given when the  GEOMETRY  parameter 
   on the  DIFFRACTION  directive is one of  NORMAL ,  EQUI  or  ANTI .
   

*H= K= L=*


   These three parameters define the zone axis [hkl] about which the
   crystal was rotated during data collection.
   If any of these parameters is omitted, a default value of zero
   is assumed.
   
   

=============================================
Printing the experimental conditions, LIST 13
=============================================




----------
\\PRINT 13
----------


   
   This prints list 13. There is no command for punching LIST 13.
   
   
   
   
   
   
   
.. index:: LIST 18

   
.. index:: Structural Formula as a SMILES string


.. _LIST18:

 
========================================================
Input of Structural Formula as a SMILES string - LIST 18
========================================================





This list holds the structural formula as a SMILES string

::


    \LIST 18
    SMILES    string.
    END




For example

::


   \list 18
   smile CC(C1=CC=CC=[N]1[Ga]2345[N](N=C(S5)Nc6ccccc6)=C(C)
   cont C7=CC=CC=[N]73)=[N]2N=C(S4)Nc8ccccc8
   smile n(o)(o)(o)
   end







---------
\\LIST 18
---------

   
   
   
   DSMILE smiles text. Remeber there is an 80 character line length. Break
   the SMILES at a suitable point and use a CONTINUATION card.

   
   If there is more than one discrete moiety in the cell, enter each on 
   its own SMILES card
   
   
   
   

===================================
Printing the SMILES string, LIST 18
===================================




----------
\\PRINT 18
----------


   
   This prints list 18. 
   
   

===================================
Punching the SMILES string, LIST 18
===================================




----------
\\PUNCH 18
----------


   
   This punches list 18. 
   
   
   
   
   
   
.. index:: LIST 29

   
.. index:: Element properties


.. _LIST29:

 
========================================================
Input of the contents of the asymmetric unit  -  LIST 29
========================================================





To perform calculations based on elemental properties, such as Sim
weighting for Fourier maps (section :ref:`FOURIER`), connectivity 
calculations, absorption
and density calculations, it is necessary to input the numbers and
properties of the elements in the cell.
This information is stored in LIST 29.

::


    \LIST 29
    READ  NELEMENT=
    ELEMENT TYPE= COVALENT= VANDERWAALS= IONIC= NUMBER= MUA= WEIGHT= COLOUR=
    END




For example:

::


    \LIST 29
    READ NELEMENT=4
    ELEMENT MO NUM=0 .5
    ELEMENT S NUM=2
    ELEMENT O NUM=3
    ELEMENT C NUM=10
    END







---------
\\LIST 29
---------

   
   
   

**READ  NELEMENT=**


   

*NELEMENT*


   This must be set to the number of atomic species in the asymmetric
   unit, and
   consequently the number of  ELEMENT directives that are about to 
   follow this directive.
   If this directive is omitted, a default value of one is assumed for
   NELEMENT.
   
   
   

**ELEMENT TYPE= COVALENT=  VANDERWAALS= IONIC= NUMBER= MUA= WEIGHT=**


   Each  ELEMENT directive provides the information about that atomic
   species in the asymmetric unit.
   

*TYPE=*


   The element TYPE must conform to the TYPE conventions described in the
   section on atom syntax, :ref:`ATOMSYNTAX`.
   The default value for this parameter is taken from the COMMAND file.
   When LIST 29 is used for Simm weighting,
   the  TYPE  is compared with the  TYPEs stored
   in LIST 3 (section :ref:`LIST03`) to determine the scattering 
   factor of the given species.
   

*COVALENT=*


   

*VANDERWAALS=*


   

*IONIC=*


   The radii used during geometry calculations,
   with a default values set in the COMMAND file. The covalent radius is
   incremented by 0.1 A for distance contacts, and
   used for defining restraint targets (see \\DISTANCES).
   The van der Waals radius is incremented by .25A for finding non-bonded
   contacts, and used for defining energy restraints
   The ionic radius may be used during geometry calculations.
   

*NUMBER=*


   This parameter gives the number of atoms of the given type in the
   asymmetric unit.
   This number can be fractional, depending
   on the number of atoms in the cell and whether they occupy special
   positions, and whether they are disordered.
   

*MUA=*


   This is the atomic absorption coefficient x10**(-23)  /cm as in INT TAB
   VOL III.  Note that in Vol IV the units are x10**(-24).
   Take care to ensure that the coefficients are appropriate
   for the wavelength used.
   

*WEIGHT*


   This is the Atomic weight
   
   
   

*COLOUR*


   This is the colour to be used for each atom in CAMERON. The available 
   colours are:
   ::


       BLACK BLUE    CYAN   GREEN GREY   LBLUE LGREEN LGREY  
       LRED  MAGENTA ORANGE PINK  PURPLE RED   WHITE  YELLOW 
   


   	
   
   

=====================================================
Printing the contents of the asymmetric unit, LIST 29
=====================================================




----------
\\PRINT 29
----------


   
   This prints list 29. There is no command for punching LIST 29.
   
   
   
.. index:: LIST 30

   
.. index:: General crystallographic data


.. _LIST30:

 
================================================
Input of General Crystallographic Data - LIST 30
================================================





This list holds general crystallographic information for later
inclusion in the cif file. CRYSTALS contains no COMMAND for editing
this list - inputting a new LIST 30 over writes any existing version.
However, some CRYSTALS commands update LIST 30 as an analysis proceeds, 
and there is a SCRIPT which enables some details to be changed.

::


    \LIST 30
    DATRED     NREFMES= NREFMERG= RMERGE= NREFFRIED= RMERGFRIED= REDUCTION=
    CONDITIONS MINSIZE= MEDSIZE= MAXSIZE= NORIENT=
    CONTINUE   THORIENTMIN= THORIENTMAX= TEMPERATURE= STANDARDS= DECAY= SCANMODE=
    CONTINUE   INTERVAL= COUNT= INSTRUMENT=
    REFINEMENT R= RW= NPARAM= SIGMACUT= GOF= DELRHOMIN= DELRHOMAX=
    CONTINUE   RMSSHIFT= NREFUSED= FMINFUNC= RESTMINFUN= TOTALMINFUN= COEFFICIENT=
    INDEXRANGE HMIN= HMAX= KMIN= KMAX= LMIN= LMAX= THETAMIN= THETAMAX=
    ABSORPTION ANALMIN= ANALMAX= THETAMIN= THETAMAX= EMPMIN= EMPMAX=
    CONTINUE   DIFABSMIN= DIFABSMAX= ABSTYPE=
    GENERAL    DOBS= DCALC= F000= MU= MOLWT= FLACK= ESD= ANALYSE-CUT= 
    CONTINUE   ANALYSE-NREF= ANALYSE-R= ANALYSE-RW= SOLUTION=
    COLOUR
    SHAPE
    CIFEXTRA   CALC-SIGMA= CALC-NREF= CALC-R= CALC-RW= 
    CONTINUE   ALL-SIGMA= ALL-NREF= ALL-R= ALL-RW=
    END




For example

::


    \LIST 30
    CONDITIONS MINSIZE=.1 MEDSIZE=.3 MAXSIZE=.8 NORIENT=25
    CONTINUE   THORIENTMIN=15.0 THORIENTMAX=25.0
    CONTINUE   TEMPERATURE=293 STANDARDS=3 DECAY=.05 SCANMODE=2THETA/OMEGA
    CONTINUE   INSTRUMENT=MACH3
    INDEXRANGE HMIN=-12 HMAX=12 KMIN=-13 KMAX=13 LMIN=-1 LMAX=19
    COLOUR RED
    SHAPE PRISM
    END







---------
\\LIST 30
---------

   
   
   

**DATRED NREFMES= NREFMERG= RMERGE= NREFFRIED= RMERGFRIED= REDUCTION=**


   Information about the data reduction process.
   

*NREFMES=*


   The number of reflections actually measured in the diffraction
   experiment
   

*NREFMERG=*


   Number of unique reflections remaining after merging equivalents
   applying Friedel's Law
   

*RMERGE=*


   Merging R factor (R int) applying Friedel's Law (as decimal not %)
   

*NREFFRIED=*


   Number of unique reflections remaining after merging equivalents
   without applying Friedel's Law
   

*RMERGFRIED=*


   Merging R factor (R int) without applying Friedel's Law (as decimal not %)
   
   
   
   
   

**CONDITIONS MINSIZE= MEDSIZE= MAXSIZE= NORIENT= THORIENTMIN= THORIENTMAX=**


   

**CONDITIONS (continued) TEMPERATURE= STANDARDS= DECAY= SCANMODE=**


   

**CONDITIONS (continued) INTERVAL= COUNT= INSTRUMENT=**


   Information about data collection.
   

*MINSIZE=*


   

*MEDSIZE=*


   

*MAXSIZE=*


   The crystal dimensions, in mm.
   

*NORIENT=*


   Number of orientation checking reflections.
   

*THORIENTMIN=*


   Minimum theta value for orientating reflections.
   

*THORIENTMAX=*


   Maximum theta value for orientating reflections.
   

*TEMPERATURE=*


   Data collection temperature, Kelvin.
   

*STANDARDS=*


   Number of intensity control reflections.
   

*DECAY=*


   Average decay in intensity, %.
   

*SCANMODE=*


   Data collection scan method. Options are
   
   ::


            2THETA/OMEGA (Default)
            OMEGA
            UNKNOWN
   


   

---------
INTERVAL=
---------

   Intensity control reflection interval time, minutes. Used if standards
   are measured at a fixed time interval
   

*COUNT=*


   Intensity control reflection interval count. Used if standards are
   measured after a fixed number (count) of general reflections.
   

*INSTRUMENT*


   Instrument used for data collection. Known instruments are:
   
   ::


            UNKNOWN (default)
            CAD4
            MACH3
            KAPPACCD
            DIP
            SMART
            IPDS
   


   
   

**REFINEMENT R= RW= NPARAM= SIGMACUT= GOF= DELRHOMIN= DELRHOMAX= RMSSHIFT=**


   

**REFINE (cont) NREFUSED= FMINFUNC= RESTMINFUNC= TOTALMINFUNC= COEFFICIENT=**


   Information about the refinement procedure.
   

*R=*


   Conventional R-factor.
   

*RW=*


   Hamilton weighted R-factor.
   
   

   
   The weighted R-factor stored in  LIST 6 (section :ref:`LIST06`) and LIST 30 
   is that computed
   during a structure factor calculation. The conventional R-factor is
   updated by either an SFLS calculation (section :ref:`SFLS`)
   or a SUMMARY of LIST 6.
   

*NPARAM=*


   Number of parameters refined in last cycle.
   

*SIGMACUT=*


   The I/sigma(I) threshold used during refinement.
   

*GOF=*


   GOF, Goodness-of-Fit, S.
   

*DELRHOMIN=*


   

*DELRHOMAX=*


   Minimum and maximum electron density in last difference synthesis.
   

*RMSSHIFT=*


   R.m.s (shift/e.s.d) in last cycle of refinement.
   

*NREFUSED=*


   Number of reflections used in last cycle of refinement.
   

*FMINFUNC=*


   Minimisation function for diffraction observations.
   

*RESTMINFUNC=*


   Minimisation function for restraints.
   

*TOTALMINFUNC=*


   Total minimisation function.
   

*COEFFICIENT=*


   Coefficient for refinement. Alternatives are:
   
   ::


            F (Default)
            F**2
            UNKNOWN
   


   
   

**INDEXRANGE HMIN= HMAX= KMIN= KMAX= LMIN= LMAX= THETAMIN= THETAMAX=**


   Range of reflection limits during data collection.
   

*HMIN= HMAX= KMIN= KMAX= LMIN= LMAX=*


   Minimum and maximum values of h,k and l.
   

*THETAMIN= THETAMAX=*


   Minimum and maximum values of theta.
   
   
   

**ABSORPTION ANALMIN= ANALMAX= THETAMIN= THETAMAX= EMPMIN= EMPMAX=**


   

**ABSORPTION (continued) DIFABSMIN= DIFABSMAX= ABSTYPE=**


   Information about absorption corrections.
   
   
   **NOTE** the keywords PSIMIN and PSIMAX have been removed.  Store values 
   as EMPMIN  and EMPMAX
   

*ANALMIN= ANALMAX=*


   Minimum and maximum analytical corrections
   

*THETAMIN= THETAMAX=*


   Minimum and maximum theta dependant corrections
   

*EMPMIN= EMPMAX=*


   Minimum and maximum empirical corrections (usually combination of theta
   and psi or multi-scan for area detectors).
   

*DIFABSMIN= DIFABSMAX=*


   Minimum and maximum DIFABS type correction, i.e. based on residue 
   between Fo anf Fc (see section :ref:`DIFABS`). In the cif it is called
   a refdelf correction.
   

*ABSTYPE=*


   Type of absorption correction. Alternatives are:
   
   ::


            NONE (default) EMPIRICAL    GAUSSIAN     SPHERICAL
            DIFABS         MULTI-SCAN   ANALYTICAL   CYLINDRICAL
            SHELXA         SADABS       NUMERICAL
                           SORTAV       INTEGRATION
                           PSI-SCAN             
      
   


   
   

**GENERAL DOBS= DCALC= F000= MU= MOLWT= FLACK= ESD=**


   

**GENERAL (continued) ANALYSE-CUT= ANALYSE-NREF=**


   

**GENERAL (continue)  ANALYSE-R= ANALYSE-RW= SOLUTION=**


   General information, usually provided by CRYSTALS.
   

*DOBS= DCALC=*


   Observed density and that calculated by CRYSTALS.
   

*F000=*


   Sum of scattering factors at theta = zero.
   

*MU=*


   Absorption coefficient, calculated by CRYSTALS.
   

*MOLWT=*


   Molecular weight, calculated bt CRYSTALS.
   

*FLACK=*


   

*ESD=*


   The Flack parameter and its esd, if refined.
   

*ANALYSE-CUT=*


   

*ANALYSE-NREF=*


   

*ANALYSE-R=*


   

*ANALYSE-RW=*


   These values are updated when ever \\ANALYSE is run, and can be used 
   to record the effect of different LIST 28 schemes. **Remenber** that if 
   the LIST 28 conditions are modified to include more reflections than 
   were used in the last \\SFLS calculation (section :ref:`SFLS`), the values 
   of Fc for the 
   additional reflections will be incorrect. A \\SFLS calculation sets 
   these to the same values as in REFINEMENT above.
   
   

*SOLUTION=*


   The program/procedure used for structure solution
   
   ::


            UNKNOWN (Default)
            SHELXS
            SIR88
            SIR92
            PATTERSON
            SIR97
            DIRDIF
   


   
   

**COLOUR**


   The crystal colour.
   

**SHAPE**


   The crystal shape.
   
   

**CIFEXTRA**


   These are filled in by the \\SFLS CALC operation (section :ref:`SFLS`).  
   Structure factors are  computed for ALL reflections along with R and Rw - 
   LIST 28 is ignored (LIST 28, reflection filtering, see section :ref:`LIST28`). 
   R and Rw are also computed for reflections above a given 
   threshold.
   
   

=========================================
Printing the general information, LIST 30
=========================================




----------
\\PRINT 30
----------


   
   This prints list 30. There is no command for punching LIST 30.
   
   
   
   
