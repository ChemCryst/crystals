.. toctree::
   :maxdepth: 1
   :caption: Contents:

*********************
Reflection Data Input
*********************




.. _reflectdata:

 

==================================================================
Scope of the Reflection Data Input section of the Reference Manual
==================================================================





The areas covered are:

::


    Reflection Data
    Simple input of F or Fsq data               - \LIST 6
    Advanced input of F or Fsq data             - \LIST 6
    Reflection Parameter Coefficients
    Storage of reflection data
    Compressed reflection files
    Intensity data                              - \HKLI
    Standard Decay Curves                       - \LIST 27
    Data Reduction                              - \LP
    Systematic absence removal                  - \SYSTEMATIC
    Sorting data                                - \SORT
    Merging equivalent reflections              - \MERGE
    Theta-dependent absorption correction       - \THETABS
    Analysis of data                            - \THLIM, WILSON, SIGMADIST







.. index:: Reflection data format


===============
Reflection Data
===============







**Format of reflection data**


The reflection data may be embedded into the control data, but it
is more normal to hold it in a separate file, the HKLI file. This file
may have one of more reflections per line, or a reflection may span
several lines. The parameters for each reflection may be in fixed
format, *i.e.* right adjusted columns, or be in free-format, with
at least a single space separating items.


If fixed-format input is used, the user must supply a FORTRAN format
statement. This specifies the width of the input fields, where the
decimal points are, and any fields to be skipped.  Even though the indices
are usually integer values, CRYSTALS read them as floating point numbers.
A FORTRAN 'I' format is automatically changed to an 'F' format.
Note that if the input figures contain decimal points, these will
over-ride values given in the format statement.

::


         Examples - ^ represents a space.
   
         FORMAT (3F4.0, 2F8.2)      ^^^1^^12^^^3^^^47.23^^^^9.32
         FORMAT (3I4, 2F8.2)        ^^^1^^12^^^3^^^47.23^^^^9.32
   
         FORMAT (3F4.0, 2F8.0)      ^^^1^^12^^^3^123456.^^312.16
   
         FORMAT (3F4.0, 3X,2F8.0)   ^^^1^^12^^^3ABC^123456.^^312.16






**Termination of reflection data**


The reflection data themselves should be terminated with  a
value less than or equal to -512 for the first value on the 
final input line.


If the reflections are embedded into the control data, then correct
termination is **vital.** Incorrect termination may lead to the program
trying to read commands as reflections, producing massive error files.
If the reflections are in the HKLI file, most
implementations will detect the end-of-file and terminate input.






**F or Fsq?**


CRYSTALS will accept either F or Fsq observations, signed or unsigned.
Either quantity is referred to by the name 'Fo'. If sigma values
are given, they must refer directly to the signed input F or Fsq values.
reflections are stored as Fo, and standard deviations are
transformed or approximated so that Least-Squares refinement
can be performed with either F or Fsq independent of input type. Raw
intensities, I, can be input with the HKLI command. The reflection
input routines (LIST 6 or HKLI) are the only routine able to take the
square root of the observation. See the chapter on refinement for a
brief discussion of the merits of F and FSQ refinements.




**Merged or unmerged data?**


CRYSTALS supports two levels of merging (averaging) simultaneously.  
For Fourier syntheses it is important that all symmetry operations of 
the Laue Group are applied, including Friedel's Law. For refinement it 
is permitted to used un-merged data, though in general some merging is 
performed. For non-centrosymmetric structures containing strong
anomalous scatterers 
Friedel pairs should be kept separate, but other symmetry operations 
should be applied. 


The reflection list with the minimal amount of merging is the 
principal reflection list, LIST 6 (section :ref:`LIST06`). This can 
be used to create 
a full-merged list for Fourier (or other) calculations, LIST 7 
(section :ref:`LIST07`).
The user can indicate to most commands which use reflections whether 
to use LIST 6 or LIST 7, but by default all use LIST 6 for backwards 
compatibility. 

When working from the menus, CRYSTALS tries to determine whether a LIST 
6 or a LIST 7 would be most appropriate.  If a LIST 7 is required, the 
SCRIPT COPY67 is activated to output a LIST 6 as a temporary file, and 
re-input it as a LIST 7.  This can then be manupulated independently of 
the original LIST 6.
\\LIST 7s are currenlty automatically created for:
::


         Fourier Maps
         Slant Fourier Maps
         Superflip Structure Solution
         Absolute Structure Determination





The experienced or adventurous user can of course use 
LIST 6 and LIST 7 quite independently for different purposes.


In LIST 7 the ARCHIVE keyword is set to NO, to prevent the original 
archived data from being over-written





.. index:: LIST 6


.. index:: F or Fsq data


.. _LIST06:

 
======================================
Simple input of F or Fsq data - LIST 6
======================================





LIST 6 will accept reflection data either as F or Fsq.
For routine work, a pre-specified set of coefficients

::


         h k l Fobs sigma(Fobs)




are input and
stored
for each reflection.


**NOTE** that 'Fobs' will refer either to F or Fsq, depending on the
value of F's.


The input coefficient list may be expanded for
non-routine work - see section :ref:`ADVANCEDL6` below.

::


    \LIST 6
    READ F'S=
    FORMAT EXPRESSION=
    END





::


    \ The OPEN command connects the reflection file
    \OPEN HKLI REFLECT.DAT
    \LIST 6
    READ F'S=FSQ
    FORMAT (3F4.0, 2F8.0)
    END
    \ Close the reflection file
    \CLOSE HKLI








**READ F'S=**




*F'S=*


This parameter is used to indicate whether :math:`F_o` or :math:`F_o^2`
type coefficients are being read in, and must take one of the following
values :

::


         FSQ
         FO   -  Default




The default value of  'FO'  indicates that coefficients corresponding
to :math:`F_o` are being read in.


By default, the reflections are assumed to come in fixed format from the HKLI
channel, and may be terminated either by the end-of-file, or with -512.





.. index:: COPY 6 7


.. index:: Copy List 6 to 7


.. _LIST07:

 
=========================================
Creation of LIST 7 from LIST 6 - COPY 6 7
=========================================




This command creates a LIST 7 as an exact copy of LIST 6 (see :ref:`LIST06`).
The LIST 7 can then be merged using Friedel's Law to create a 
reflection list suitable for Fourier syntheses

::


    \COPY INPUT= OUTPUT=
    END




Example
::


    \COPY 6 7
    END











===============
Printing LIST 6
===============



The reflections can be output to listing file as follows :

--------------
\\PRINT 6 mode
--------------

   Mode controls the type of output.
   ::


           A - Default - The reflections are in compressed 
                         format, on the scale of Fo.
           B -           The reflections are in compressed 
                         format, on the scale of Fc.
           C -           A general print of all the data 
                         stored for each reflection.
   


   
   See also \\REFLECTIONS (section :ref:`REFLECTIONS`), which produces tables 
   for publication.
   
   
   
.. index:: Output of reflection data


===============
Punching LIST 6
===============



LIST 6 can be punched as an ASCII file in several formats.

--------------
\\PUNCH 6 mode
--------------

   Mode controls the format of the output.
   ::


            A - Output the reflections in a compressed format - Default.
            B - Output the reflections in 'cif' format. F's
            C - Output stored information in tabulated format.
            D - Output original information in tabulated format.
            E - Output the reflections in 'cif' format. F^s, scale of Fo
            F - Output Fo, sigma information in SHELX format.
            G - SHELX output with statistically generated sigmas
            H - Output the reflections in 'cif' format. F^s, scale of Fc
            I - Outputs all set items as a LIST 6.
            J - Used to convert pre-2016 esds to more precise ones. 
      
           *F - * as above, F indicates that LIST 28 filters will be applied
   


   

   
   LIST 6 is also output by the links to the direct methods programs. In
   these files, the magnitudes of Fo or Fsq are scaled so that the largest
   fits the format statement. The SHELX file contains Fsq, the SIR file
   contains Fo.
   
   
   
.. index:: Reflection data input - advanced


.. _ADVANCEDL6:

 
========================================
Advanced input of F or Fsq data - LIST 6
========================================





LIST 6 will accept reflection data either as F or Fsq.
The data may be
in free or fixed format. For routine work, a pre-specified set of
parameters is stored for each reflection. This may be expanded for
non-routine work by **INPUT** and **OUTPUT** coefficients.

::


    \LIST 6
    READ NCOEFFICIENT= TYPE= F'S= NGROUP= UNIT= CHECK= ARCHIVE=
    INPUT COEFFICIENT(1)= COEFFICIENT(2)= .  .
    STORE NCOEFFICIENT= MEDIUM= APPEND=
    OUTPUT COEFFICIENT(1)= COEFFICIENT(2)=  .  .
    FORMAT EXPRESSION=
    MULTIPLIERS VALUE=
    MATRIX M11=  M12=  ... M33= TOLER= TWINTOLER=
    END





::


    \ The OPEN command connects the reflection file
    \OPEN HKLI REFLECT.DAT
    \LIST 6
    READ NCOEF=5 TYPE=FIXED UNIT=HKLI F'S=FSQ
    FORMAT (3F4.0, 2F8.2)
    INPUT H K L /FO/ SIGMA(/FO/)
    STORE NCOEF=7
    OUTPUT INDICES /FO/ SQRTW /FC/ BATCH/PHASE RATIO/JCODE SIGMA(/FO/)
    END
    \CLOSE HKLI








**READ NCOEFFICIENT= TYPE= F'S= NGROUP= UNIT= CHECK= ARCHIVE=**






*NCOEFFICIENT=*


Specifies the number of coefficients to be input per reflection. A list
of permitted coefficients is given below. If this directive is omitted,
the default is 5.


The default input coefficients are

::


         H K L FOBS SIGMA(F)






*TYPE=*


This parameter determines the form of the reflections as they are read
in, and must take one of the following values :

::


         FIXED     -  Fixed format data
         FREE      -  Free format text  -  default value
         COMPRESSED-  See 'Compressed Reflection Data' below
         COPY      -  LIST 6 is copied from the current input device to the
                      output device designated on the STORE directive with
                      the number of coefficients given on the OUTPUT and
                      COEFFICIENT directives.






*F'S=*


This parameter is used to indicate whether :math:`F_o` or :math`F_o^2`
type coefficients are being read in, and must take one of the following
values :

::


         FSQ
         FO   -  Default value




The default value of  'FO'  indicates that coefficients corresponding
to Fo are being read in.


*NGROUP=*


This parameter defines the number of reflections per line for fixed
format input. (For free format input, the system
can work out this information).
NGROUP will be less than unity if the reflection spans several lines.


*UNIT=*


This parameter defines the source of the reflection data that are
to be input.

::


         HKLI   -  Default value.
         DATAFILE







HKLI  indicates that the reflection data are in a separate file from
the main input data.
The local implementation may set up default names for this file, or
the \\OPEN directive can be used to connect the file to CRYSTALS.



DATAFILE  indicates that the reflections follow the directives for
'\\LIST 6' in the normal data input stream.
If this is the case, the directives for  \\LIST6  **must** be terminated
by the directive  END, otherwise the reflection lines will be
processed as normal directives associated with the  \\LIST6
command, and generate a very large number of input errors.



By default, the data are assumed to come from the alternative HKLI
channel.


*CHECK*


This parameter determines whether reflections are rejected on input
if they have a zero or negative value for Fo.

::


         YES
         NO -  Default value.




By default checking is disabled so that negative reflections are
accepted on input.




*ARCHIVE*


This parameter controls the creation of a file ARCHIVE-HKL.CIF, an  
image of the data in 3i4,2f8.2 (SHELX) format. 

::


         YES -  Default value.
         NO 




The default value is YES except when a COPY is being performed. The 
ARCHIVE-HKL.CIF can be embedded in the final publish.cif file.






**INPUT COEFFICIENT(1)= COEFFICIENT(2)= .  .**




This directive defines the coefficients that are to be read in.
The number of coefficients is given by the  NCOEFFICIENT  parameter
above, or its default value.


*COEFFICIENT(1)= COEFFICIENT(2)=*


Defines the coefficients and their input order. The coefficients must be
selected from the following list

::


         H             K             L             /FO/
         SQRTW         FCALC         PHASE         A-PART
         B-PART        TBAR          FOT           ELEMENTS
         SIGMA(F)      BATCH         INDICES       BATCH/PHASE
         SINTH/L**2    FO/FC         JCODE         SERIAL
         RATIO         THETA         OMEGA         CHI
         PHI           KAPPA         PSI           CORRECTIONS
         FACTOR1       FACTOR2       FACTOR3       RATIO/JCODE




For the meaning of these coefficients, see section :ref:`REFPARCOEF` - 
'Reflection Parameter Coefficients'


**NOTE** that 'Fobs' will refer either to F or Fsq, depending on the
value of F's. Reflections are available during refinement as either signed
Fsq or signed Fo independent of the type of input values.






**STORE NCOEFFICIENT= MEDIUM= APPEND=**




*NCOEFFICIENT=*


Specifies the number of coefficients to be stored per reflection. A list
of permitted coefficients is given above. If this directive is omitted,
the default is 9.


The default output coefficients are

::


         INDICES /FO/ SQRTW /FC/ BATCH/PHASE RATIO/JCODE SIGMA(/FO/)
         CORRECTIONS ELEMENTS






*MEDIUM*


This parameter sets the output reflection storage device. This can be a
text file, but more normally it is the database, the '.dsc' file. 
See section :ref:`STOREREF` - 'Storage of Reflection Data'.

::


         FILE        A named or scratch ASCII serial file
         INPUT       A file of the same type as the input reflection source
         DISK   -    Default - The current structure database






*APPEND=*


This parameter determines whether the input reflections are to replace
or be appended to existing reflections.
::


         YES      The input reflections are appended to existing reflections
         NO   -   Default - The input reflections replace any existing reflections








**OUTPUT COEFFICIENT(1)= COEFFICIENT(2)= .  .**




This directive defines the coefficients that are to be stored.
The number of coefficients is given by the  NCOEFFICIENT  parameter
above, or its default value, and the coefficients selected from the list
above.


If the  OUTPUT  directive is omitted, as many of the default
coefficients as are required by NCOEFFICIENT  are used as output
coefficients :


If the  OUTPUT  directive is omitted and  NCOEFFICIENT  is greater than 9,
it is reset to 9 so that the coefficients above can be used.






**FORMAT EXPRESSION=**




This directive allows the user to define a format statement if
fixed format input is being used.
This directive is only valid if the  TYPE  parameter on the  READ  
directive is  FIXED .


*EXPRESSION=*


This parameter defines the format to be used.
Normally this keyword is omitted, so that the directive looks
like a FORTRAN format statement, except that there must be at least
one space between the  'FORMAT' and the expression, to terminate the
directive.
Since all the data are read as real numbers, the format expression
can only contain F , E , and X field definitions - either find a good
Fortran reference book for examples, or ask someone who did 
crystallography before 1990.






**MULTIPLIERS VALUE=**




This directive allows the user to define the multipliers to
be applied to the data if they are being read in compressed format.
This directive is only valid if the  TYPE parameter on the  READ  directive 
is COMPRESSED .


*VALUE=*


This parameter, whose default value is unity,
is repeated the number of times specified by the  NCOEFFICIENT  parameter
on the  READ  directive.
The order is the same as the  INPUT  coefficients.




**MATRIX M11= M12= ...M33= TOLER= TWINTOLER=**




This directive inputs a matrix to be applied to the reflection indices
as they are read in. If any component of the index differs by more than
TOLER from an integer, the reflection is rejected. TWINTOLER is a value,
in A-2, for overlap of potentially twinned reflections. See the chapter
on twinning (:ref:`twinning`).


*Mij=*


The 9 elements (by row) of an index transformation matrix. The default
is a unit matrix


*TOLER=*


The reflection is rejected if any transformed index differs from an
integer by more than TOLER. The default is 0.1.


*TWINTOLER=*


The twin element tag is updated if the generated reciprocal lattice
point differs from a base lattice point by less than TWINTOLER
reciprocal Angstrom. The default is 0.001, but an ideal value will depend
upon the integration method, the mosaicity, and the lengths of the cell
edges.







.. _REFPARCOEF:

 
=================================
Reflection Parameter Coefficients
=================================





CRYSTALS has a very flexible procedure for storing reflection
information, enabling the user to optimise disk space use. The user
must indicate to the program what information is available in the input
data, and what information is to be stored. Storage space may also be
reserved for data yet to be computed.


During data reduction (section :ref:`DATAREDUC`), space is reserved for 
relevant coefficients.
These coefficients (*e.g.* setting angles) may not be needed during
structure analysis, so they are not normally preserved beyond reduction.



--------------------------
Special Reflection storage
--------------------------


   
   The user might need to arrange special reflection storage under the
   following conditions:
   
   
   

**Refinement using a partial model**



   
   If the user is experiencing difficulties with a small part of an otherwise
   well behaved large structure, the real and imaginary parts of the
   structure factors due to the well behaved part can be precomputed and
   stored and these atoms removed from the atom list (LIST 5).
   The user then only needs recompute the contributions
   from the varying fragment. The total Fo, Fc, real and imaginary parts are
   stored with the keys
   ::


            /FO/      /FC/      APART      BPART
   


   
   
   
   

**Twinned structures**



   
   See chapter :ref:`twinning` on handling twinned data.
   
   
   

----------------------------------
Recognised reflection coefficients
----------------------------------

   
   
Coefficients recognised are:

	   
|       H            Reflection index h
|       K            Reflection index k
|       L            Reflection index l
|       INDICES      Packed reflection indices
|       /FO/         The observed intensity, :math:`F_o^2` or :math:`F_o` value
|       /FOT/        The observed intensity, :math:`F_o^2` or :math:`F_o` value for a twinned crystal
|       /FC/         The calculated structure factor
|       SIGMA(/FO/)  Standard deviation of the input observation
|       SQRTW        Sqrt of weight to be given a reflection during least squares
|       A-PART       Real part of structure factor
|       B-PART       Imaginary part of structure factor
|       PHASE        Phase angle, radians
|       BATCH        An integer associated with reflections measured in batches
|       BATCH/PHASE  Packed (compressed into one word) Batch and Phase
|       SINTH/L**2   :math:`(\sin\theta / \lambda)^2` 
|       FO/FC        :math:`F_o/F_c`
|       ELEMENTS     Integers corresponding to twin elements
|       SERIAL       Serial number of reflection
|       JCODE        reflection quality code. See below
|       RATIO        Ratio :math:`F_o^2/\sigma(F_o^2)`
|       RATIO/JCODE  Packed ratio and jcode
|       TBAR         Absorption weighted X-ray path length
|       THETA        Bragg angle
|       OMEGA        Setting angle
|       CHI          Setting angle
|       PHI          Setting angle
|       KAPPA        Setting angle
|       PSI          Setting angle
|       CORRECTIONS  Composite correction factor for :math:`F_o`
|       FACTOR1      Individual correction factor for :math:`F_o`
|       FACTOR2      Individual correction factor for :math:`F_o`
|       FACTOR3      Individual correction factor for :math:`F_o`
|       NOTHING      A spare location for programmers use
 


   

   
   If an output coefficient is specified without the corresponding input
   coefficient, it value is set to zero except for BATCH (default is 1.0)
   and SINTH/L**2  (value computed from cell parameters). Packed INDICES are
   restricted to +/- 127, packed RATIO to range 0.0 - 999.0, JCODE to range
   0 - 9. 

   
   JCODE valuse assigned by RC93 for MACH3 data are
   
   ::


                  1     normal reflection
                  9     weak reflection
                  7     flagged strong S but not flagged D
                  2     deviates from expected position/peak shape, but not W
                  3     failed non-equal test at least once
                  6     flagged weak
                  4     reflection is bad
                  8     flagged strong T but not flagged D
           The order of comparisons corresponds to the order of likelihood of
           having a particular code.
   


   
   
   

.. _STOREREF:

 
==========================
Storage of reflection data
==========================





Reflections may be stored either in the structure database (the DSC
file), or as external binary serial files. The latter is used mainly
during data reduction (section :ref:`DATAREDUC`).


When a change is made to most other
data lists, they are either completely overwritten (LIST1, cell
parameters), or a new list created in addition to the old list (LIST 5,
atom parameters). Because the reflections are special, they are handled
differently. A small piece of information (called the LIST 6 Header) is
created to hold information about the rest of the reflection list,
and new headers are stored each time the main body is updated. The main
body of the reflection list is modified in-situ if the only changes are
ones which can easily be recomputed ( *e.g.* Fc, phase, sqrtw), thus
reducing the disk activity. If an error occurs during the updating of
the body, the list becomes inaccessible to other processes, and the
failing process must be re-run correctly.
If the changes involve a change in size of
the list, then a new body is created.


During raw data processing (Data reduction, section :ref:`DATAREDUC`) the 
size of the reflection
list can change a lot (coefficients being added or removed, reflections
being merged or rejected). To prevent the .DSC file growing too large,
binary serial files are used to hold the body of the reflection list.
One is used for input and one for output at each stage, the roles being
reversed after each stage. The header is kept in the .DSC file, and
keeps track of the bodies. When data reduction is complete, the body
must be copied to the .DSC file as follows:

::


    \  After data reduction, make a final copy of the reflections
    \  and STORE THEM IN THE .DSC FILE:
    \LIST 6
    READ TYPE=COPY
    END







==========================
Compressed reflection data
==========================



CRYSTALS can produce files containing reflections is a 'compressed'
format. This might be useful for archiving data. The compressed data is
headed by the correct information for its reinput.


The file contains information for  h, k, l, /FO/ or /FOT/, RATIO/JCODE
and elements.
For each  KL  pair, the  K  value is given for this group of
reflections, then the  L  value for the group, followed by
the  H  and /FO/ and other values for the first reflection, the  H   /FO/
and other values for
the second reflection, and so on, finishing with 512, which is the
terminator for this  KL  pair.
This pattern is repeated for all the  KL  pairs, the terminator
for the last  KL  pair being -512, and indicates the end of the reflection
list. Take care if you try to edit these files, and
note that  K  and  L  are the two constant indices for each group,
while  H  changes most rapidly.





=====================
Intensity Data - HKLI
=====================



Raw intensity data require more processing than F or Fsq
values. The instruction '\\HKLI' is related to '\\LIST 6', but has
different default coefficients and additional directives for geometrical
corrections.


::


    \HKLI
    READ NCOEFFICIENT= TYPE= F'S= NGROUP= UNIT= CHECK= ARCHIVE=
    INPUT COEFFICIENT(1)= COEFFICIENT(2)= .  .
    STORE NCOEFFICIENT= MEDIUM= APPEND=
    OUTPUT COEFFICIENT(1)= COEFFICIENT(2)=  .  .
    FORMAT EXPRESSION=
    CORRECTIONS NSCALE NFACTOR
    FACTORS COEFFICIENT(1)= COEFFICIENT(2)=  .  .
    ABSORPTION PRINT= PHI= THETA= TUBE= PLATE=
    PHI NPHIVALUES= NPHICURVES=
    PHIVALUES PHI= .........
    PHIHKLI H= K= L= I[MAX]=
    PHICURVE I= .........
    THETA NTHETAVALUES=
    THETAVALUES THETA=
    THETACURVE CORRECTION= ........
    TUBE NOTHING OMEGA= CHI= PHI= KAPPA= MU=A[MAX]=
    PLATE NOTHING OMEGA= CHI= PHI= KAPPA= MU=A[MAX]=
    END




For example

::


    \  The OPEN command connects the reflection file:
    \OPEN HKLI REFLECT.DAT
    \  The HKLI instruction reads the data in:
    \HKLI
    \  There are 12 items to read:
    READ NCOEF=12 FORMAT=FIXED UNIT=HKLI F'S=FSQ CHECK=NO
    \  This is what they are:
    INPUT H K L /FO/ SIGMA(/FO/) JCODE SERIAL BATCH THETA PHI OMEGA KAPPA
    \  And this is their format:
    FORMAT (5X,3F4.0,F9.0,F7.0,F4.0,F9.0,F4.0,4F7.2)
    \  We only want to store six of them:
    STORE NCOEF=6
    \  Specifically, these ones:
    OUTPUT INDICES /FO/ BATCH RATIO/JCODE SIGMA(/FO/) CORRECTIONS SERIAL
    \  Some absorption corrections have been measured:
    ABSORPTION PHI=YES  THETA=YES PRINT=NONE
    \  Here is the theta dependent absorption curve:
    THETA 16
    THETAVALUES
    CONT 0  5 10 15 20 25 30 35 40 45 50 55 60 65 70 75
    THETACURVE
    CONT 3.61  3.60  3.58  3.54  3.50  3.44  3.37  3.30
    CONT 3.23  3.16  3.09  3.02  2.96  2.91  2.86  2.82
    \  And here is one azimuthal absorption curve containing 26 points:
    PHI 26  1
    PHIVALUES
    CONT   6  16  21  26  31  36  41  61  66  76
    CONT  81  86  91  96 111 121 131 136 141 146
    CONT 151 156 161 166 171 176
    \  This is the reflection we used for the scan:
    PHIHKLI    -3   -1    0    28392
    PHICURVE
    CONT    26887   25377   24608   23990   23445   23049
    CONT    22867   22801   22782   22937   23104   23368
    CONT    23713   24129   25669   26836   27892   28250
    CONT    28291   28256   28101   28009   28204   28373
    CONT    28392   28203
    END
    \  All done. Close the hkl file.
    \CLOSE HKLI




In the following description,
for items defined under LIST 6 above only the default value will be given.





------
\\HKLI
------

   
   
   

**READ NCOEFFICIENT= TYPE= F'S= NGROUP= UNIT= CHECK= ARCHIVE=**


   This directive is the same as the READ directive in \\LIST 6 above, 
   except that the following parameters have
   different default values:
   
   ::


       NCOEFFICIENT= default value is 12
       TYPE= default value is FIXED
       F'S= default value is FSQ
       NGROUP= default value is 1
       UNIT= default value is HKLI
   


   
   
   
   
   

**INPUT COEFFICIENT(1)= COEFFICIENT(2)= .  .**



   
   This directive defines the coefficients that are to be read in.
   The number of coefficients is given by the  NCOEFFICIENT  parameter
   above, or its default value.
   
   
   The default input coefficients are (i.e. for RC93 output):
   
   ::


            H K L /FO/ SIGMA(/FO/) JCODE SERIAL BATCH THETA PHI OMEGA KAPPA
   


   
   
   
   

**STORE NCOEFFICIENT= MEDIUM= APPEND=**


   

*NCOEFFICIENT=*


   The number of coefficients that will appear on the OUTPUT directive.
   The default is 9.
   

*MEDIUM=*


   The default value is 'FILE'. Since the reflections will be much 
   changed during data reduction 
   (section :ref:`DATAREDUC`), the
   intermediate storage is usually a scratch serial file.
   

*APPEND=*


   The default value is 'NO'.
   
   
   

**OUTPUT COEFFICIENT(1)= COEFFICIENT(2)= .  .**


   The default coefficients are:
   ::


            INDICES /FO/ SQRTW /FC/ BATCH/PHASE RATIO/JCODE SIGMA(/FO/)
            CORRECTIONS ELEMENTS
   


   
   Note that H, K, and L are compressed into one key: 'INDICES'.
   
   
   

**FORMAT EXPRESSION=**



   
   This directive is only valid if the  TYPE  parameter on the  
   READ  directive is  FIXED.
   

*EXPRESSION=*


   If the diffractometer type indicated in LIST 13 (section :ref:`LIST13`)
   is CAD4, the default
   corresponds to RC93 or RC85 output, otherwise an expression must be
   given.
   ::


                e.g. (5X,3F4.0,F9.0,F7.0,F4.0,F9.0,F4.0,4F7.2)
   


   
   
   
   
   
   
   
   Directives found in HKLI commands, but not in LIST 6 commands are:
   
   
   

**CORRECTIONS NSCALE= NFACTOR=**


   
   

*NSCALE=*


   Set to 1 or 2 to select the first or second scale factor in LIST 27
   (see section :ref:`LIST27`).
   
   
   The default is 2.
   

*NFACTOR=*


   Up to three correction per reflection to be applied to the input
   observations can be included in the input file. This keyword specifies
   how many to use.
   
   
   The default is 0.
   
   
   

**FACTORS COEFFICIENT(1)= COEFFICIENT(2)= .  .**


   The permitted coefficients are FACTOR1, FACTOR2 and FACTOR3. These are
   applied to the input observation before any other action (including
   square rooting if requested) is performed.
   
   
   

**ABSORPTION PRINT= PHI= THETA= TUBE= PLATE=**


   This directive controls approximate absorption corrections to be applied
   during input. They are only suitable if the diffractometer used is one
   of those permitted in LIST 13 (section :ref:`LIST13`).
   

*PRINT=*


   Permitted levels are
   ::


            FULL                  Two lines of information per reflection
            NONE    - Default     No output is produced
            PARTIAL -             Summary for each reflection
   


   
   

*PHI=*


   ::


            NO      - Default
            YES
   


   
   If YES, then phi (azimuthal scan) data must follow.
   

*THETA=*


   ::


            NO      - Default
            YES
   


   
   If YES, then a theta dependent correction curve must follow.
   

*TUBE=*


   ::


            NO      - Default
            YES
   


   
   If YES, then orientation angles for the tube must follow.
   

*PLATE=*


   ::


            NO      - Default
            YES
   


   
   If YES, then orientation angles for the plate must follow.
   
   
   
   
   

**PHI NPHIVALUES= NPHICURVES=**


   If phi has been set to 'YES' above,
   this directive sets up input and computation of azimuthal scan
   absorption corrections, by the method of North, Phillips and Mathews,
   Acta Cryst., **A24,** 351 (1968).
   

*NPHIVALUES=*


   Number of sampling points on the phi curve. These need not be equally
   spaced
   

*NPHICURVES=*


   Number of phi curves that will be entered after this directive.
   
   
   

**PHIVALUES PHI= .....**


   The 'Nphivalue' phi angles  of the points on the absorption curve.
   
   
   

**PHIHKLI H= K= L= I[MAX]=**


   The h,k,l and Imax values for the following 'Nphicurve' phi profiles,
   in the same order as the profiles.
   
   
   

**PHICURVE I= .....**


   The 'Nphivalue' intensity values for the profile  at the phi values
   given on the Phivalues directive. There is a Phicurve corresponding to
   each PHIHKLI directive.
   
   
   

**THETA NTHETAVALUES=**



   
   If theta has been set to 'YES' above this directive sets up the input
   for and computation of a theta dependent absorption correction. Except
   when the data has been corrected by a proper analytical correction,
   a theta dependent correction is **ALWAYS** recommended, since neither
   a phi scan, multi-scan nor DIFABS (section :ref:`DIFABS`) will make a 
   good theta 
   approximation. See Int Tab,
   Vol II, p295 and 303 for suitable profiles.
   

*NTHETAVALUES=*


   The number of sampling points on the theta curve.
   
   
   

**THETAVALUES THETA= .....**



   
   The Nthetavalues at which the curve is sampled
   
   
   

**THETACURVE CORRECTION= ......**



   
   The Nthetavalue values of the correction factor profile.
   
   
   

**TUBE NOTHING OMEGA= CHI= PHI= KAPPA= MU A[MAX]**



   
   If TUBE has been set to 'YES' above, this directive sets up the
   correction for a sample in a tube, or for an acicular crystal steeply
   inclined to the phi axis. See J. Appl. Cryst, 8. 491, 1975. 'NOTHING' is
   a place-holder for internal workings.
   

*OMEGA= CHI= PHI= KAPPA=*


   These are the settings needed to bring the tube axis into the
   equatorial plane and perpendicular to the incident X-ray beam. Only one
   of Chi and Kappa may be given.
   

*MU=*


   The product of Mu and the thickness of the tube wall.
   

*A[MAX]*


   The maximum permitted correction. Values greater than A[max] generate a
   warning.
   
   
   

**PLATE NOTHING OMEGA= CHI= PHI= KAPPA= MU A[MAX]**



   
   If PLATE has been set to 'YES' above, this directive sets up the
   correction for an extended plate-like sample. See J. Appl. Cryst, 8. 491,
   1975. 'NOTHING' is
   a place-holder for internal workings.
   

*OMEGA= CHI= PHI= KAPPA=*


   These are the settings needed to bring the plate normal into the
   equatorial plane and perpendicular to the incident X-ray beam. Only one
   of Chi and Kappa may be given.
   

*MU=*


   The product of Mu and the plate thickness.
   

*A[MAX]*


   The maximum permitted correction. Values greater than A[max] generate a
   warning.
   
   
   
   
   
.. index:: LIST 27

   
.. index:: Intensity decay curves


.. _LIST27:

 
=================================
Intensity Decay Curves  \\LIST 27
=================================




::


    \LIST 27
    READ NSCALE=
    SCALE SCALENUMBER= RAWSCALE= SMOOTHSCALE= SERIAL=
    END






If each reflection has been assigned a serial number (or some other
incrementing value, such as total X-ray exposure time) then CRYSTALS can
apply a correction which is linked to this value. The corrections, on the
scale of Fsq, are held in LIST 27. Two correction factors can be stored,
but only one used. For example, these can be the actual corrections computed
from the decay of the standard reflections, and those obtained from
a 3-point smoothing of the same correction data.
The applied scale factor is obtained by interpolating between those given
scale factors with serial numbers above and below the serial number of
the current reflection.
If there is a dramatic change in scale (for example due to remeasurement
of some very strong reflections with attenuated X-rays), it is important
not to interpolate over this discontinuity. To achieve this, a dummy
scale factor is inserted at this point with scale values the same as the
current scales, but with the same serial number as the first scales
after the discontinuity - for example:

::


    \LIST 27
    READ NSCALE=16
    SCALE   1      1.000  1.000    1
    SCALE   2      1.066  1.066    4
    SCALE   3      1.074  1.053   57
    SCALE   4      0.997  1.018   83
    SCALE   5      1.003  1.003  564
    SCALE   6      0.370  0.370  564
    SCALE   7      0.372  0.371  617
    END







---------
\\LIST 27
---------

   
   
   

**READ NSCALE=**


   

*NSCALE=*


   The number of  SCALE directives to follow.
   There is no default value for this parameter.
   
   
   

**SCALE SCALENUMBER= RAWSCALE= SMOOTHSCALE= SERIALNUMBER=**



   
   This directive is repeated once for each scale factor that is
   to be read in.
   

*SCALENUMBER=*


   This parameter indicates the number of the scale factor, starting
   from one.  There is no default for this parameter, which currently is
   not used.
   

*RAWSCALE=*


   This parameter gives the initial scale factor, computed directly
   from the intensities of the standard reflections.
   
   
   There is no default.
   

*SMOOTHSCALE=*


   This parameter gives the scale factor after the raw scale factors have been
   smoothed, so that a continuous curve is fitted to all the data.
   
   
   There is no default.
   

*SERIALNUMBER=*


   This parameter gives the serial number of the first standard reflection
   contributing to this scale.
   The data reduction programs use the  SERIAL to locate the correct
   scales to use for a given reflection.
   
   
   There is no default.
   
   
   
   

========================
Printing the decay curve
========================




----------
\\PRINT 27
----------


   
   This command prints the decay curve.
   There is no command to punch LIST 27.
   
   
   
   
   
.. index:: LP

   
.. index:: Data reduction


.. _DATAREDUC:

 
===================
Data Reduction - Lp
===================





This command causes the Lp correction to be calculated for each
reflection.


The diffraction geometry, wavelength, etc. are taken from
LIST 13 (section :ref:`LIST13`).
If LIST 13 is input incorrectly, or has to be generated by the system,
the message 'illegal diffraction geometry flag' will be output
and the job terminated. If the user has forced the storage of Fsq
values in \\HKLI, it is necessary to indicate this to the Lp correction.

::


    \LP
    STORE MEDIUM= F'S=
    END




For example
::


    \  Apply an LP correction for the geometry stored
    \  in List 13.
    \LP
    END







----
\\LP
----

   
   
   

**STORE MEDIUM= F'S=**


   

*MEDIUM=*


   Determines the output medium.
   
   ::


            FILE              A serial file
            INPUT - Default   The same as the input medium
            DISC              The .DSC file.
   


   
   The default output medium is the same as te input medium -  usually a
   serial file.
   

*F'S=*


   
   ::


            FO      -      Default
            FSQ            Indicating that square roots were not taken at
                           input time.
   


   
   
   
   
.. index:: SYSTEMATIC

   
.. index:: Removing systematic absences


.. _SYSTEMATIC:

 
=========================================
Systematic absence removal - \\SYSTEMATIC
=========================================




::


    \SYSTEMATIC INPUTLIST=
    STORE MEDIUM= F'S= NEWINDICES=  FRIEDEL=
    END




For example:
::


    \  Remove systematic absences and move each hkl index
    \  by symmetry so that they all lie in the same part of
    \  the reciprocal lattice:
    \SYST
    END






This routine uses the symmetry operators in LIST 2 (section :ref:`LIST02`)
to identify
systematic absences, which are listed and rejected. It can also
use the symmetry operators to transform indices to that the reflections
fall into a unique part of the reciprocal lattice. The unique set is
bounded by the maximum range in 'l', maximum range of 'k' given the 'l'
range, and maximum range of 'h', given the 'k,l' range.



Friedel's Law may be invoked, depending on the flag in 
LIST 13 (section :ref:`LIST13`).
It is important **NOT** to use Friedel's Law for structures which have
strong anomalous scatterers,
since reflections related by Friedel's law are not
equivalent in this case and should not be merged together.
Similarly, if orientation dependent corrections are to be made (*e.g.*
DIFABS),original indices should be preserved. Note that in this case,
only exactly equivalent reflections will be merged, and care must be
taken when computing Fourier maps. See the sections on Fourier maps, 
:ref:` and DIFABS  <FOURIER>`RDIFABS
.  


If FRIEDEL is set to "YES", Friedel's law is applied whatever the 
space group.  A flag is set in the 'JCODE' slot for each reflcetion 
to indicate if the law was invoked or not. 
DO NOT USE excluded JCODES IN \\MERGE. If the data is then
sorted but not merged, Friedel pairs will be adjacent and flagged. Used
by the function "\\TON" for evaluating absolute configuration.





------------
\\SYSTEMATIC
------------

   
   
   

**SYSTEMATIC INPUTLIST=**


   
   
   

*INPUTLIST=*


   6 OR 7
   
   
   

**STORE MEDIUM= F'S= NEWINDICES=**


   

*MEDIUM=*


   Determines the output medium.
   
   ::


            FILE              A serial file
            INPUT - Default   The same as the input medium
            DISC              The .DSC file.
   


   
   The default output medium is the same as the input medium -  usually a
   serial file.
   
   
   

*F'S=*


   
   ::


            FO      -      Default
            FSQ            Indicating that square roots were not taken at
                           input time.
   


   
   
   
   

*FRIEDEL=*


   
   ::


            No      -      Default
            YES            Indicating that Friedels law should be applied 
                           whatever the space group.
   


   
   

*NEWINDICES=*


   Determines whether new indices are computed.
   
   ::


            YES  -  Default - Permits transformation of indices.
            NO
   


   
   
   
   
.. index:: Sorting reflection data


.. _SORT:

 
=========================================
Sorting of the reflection data  -  \\SORT
=========================================




::


    \SORT INPUTLIST=
    STORE MEDIUM=
    END




For example:
::


    \  Sort reflections into order by L, then K, then H:
    \SORT
    END






This routine sorts the data so that the reflections are placed
in a predetermined order, in which reflections with the same indices
are adjacent in the list. Upon output, the reflections are arranged
so that they are in groups of constant  L, starting with the group
with the smallest  L  value. Within any  L  group, the reflections
are ordered in groups of constant  K, starting with the group with the
smallest  K  value. Within each  group of constant K and L, the 
reflections are arranged
with the smallest  H  value first and the largest last in ascending
order.


The method of sorting is a multi-pass tree sort, in which as
many reflections as possible are held in memory during each pass.
If all the reflections with a given value of  L  cannot be in memory
at the same time, the program will terminate in error.



------
\\SORT
------

   
   
   

**STORE MEDIUM**


   

*MEDIUM=*


   Determines the output medium.
   
   ::


            FILE              A serial file
            INPUT - Default   The same as the input medium
            DISC              The .DSC file.
   


   
   The default output medium is the same as the input medium -  usually a
   serial file.
   
   
   
   
   
.. index:: Merging reflection data

   
.. index:: MERGE


==========================================
Merging equivalent reflections  -  \\MERGE
==========================================


::


    \MERGE INPUT= TWINNED=
    STORE MEDIUM=
    REFLECTIONS NJCODE= LIST= LEVEL= F'S=
    JCODE NUMBER= VALUE=
    REJECT RATIO= SIGMA=
    WEIGHT SCHEME= NPARAMETERS= NCYCLE=
    PARAMETERS P .....
    END




For example:

::


    \MERGE
    WEIGHT SCHEME=2 NPARAM=6
    PARAMETERS .5  3.0  1.0  2.0  .01 .00001
    END






The merge routine takes a list of
reflections and combines groups of adjacent reflections with
*exactly* the same indices to
produce a single mean structure amplitude.


\\SYST (section :ref:`SYSTEMATIC`) and \\SORT (section  :ref:`SORT`) produce 
a suitable list, and if
either of them have been omitted, it is extremely
likely that the list of reflections produced by the merge process
will contain duplicated entries for certain reflections.


It is possible to combine equivalent
reflections in several different ways, depending upon how each
individual contributor is weighted when the mean is computed.
Several different weighting schemes are provided, and these are described
in the next section (the  WEIGHT  directive).


The JCODE key in the list of reflections may be input from some
diffractometers (e.g. a CAD4) to indicate that the value may be
inaccurate. Reflections which have JCODES that differ from unity 
are thought
to be inaccurate and can be down-weighted or eliminated during the merge
process (the  JCODE  directive). Note that JCODES MUST be positive
and less than 10.


Although under normal circumstances LIST 6 (reflections) contains :math:`|F_o|`
data rather than :math:`|F_o|^2` data, the calculations performed during
the merge are done on the scale of :math:`|F_o|^2`.
This means that r-values are computed which refer to :math:`|F_o|^2`,
and that reflections can be rejected on the basis of the
ratio of :math:`|F_o|^2` to its standard deviation.
If for some reason the LIST 6 contains :math:`|F_o|^2` data rather
than the normal :math:`|F_o|` data, it is necessary to use the "F's"
parameter of the "REFLECTIONS" directive to inform the system 
of this fact.


During the merge process, the system calculates and then prints a
set of merging r-values, which are defined as follows :

    :math:`R = 100*\frac{\sum{ Sd_i }}{\sum{M_i}}`
    where :math:`i` runs over all reflections, and   

    :math:`Sd_i = \sum{<F_i^2> - F_j^2}`
    summed over :math:`j` contributors. And
  
    :math:`M_i = \sum{<F_i^2>}`
    summed :math:`j` times for :math:`j` contributors.


The sum variable  :math:`i`  runs over all the reflections produced by the merge
process which have more than one contributor.
The sum variable  :math:`j`  runs over all the contributors for each reflection
produced by the merge process.
:math:`<F^2_i>`  is the mean value for the reflection  :math:`i` , while  :math:`F^2_j`  is
the observed value of :math:`F^2` for the contributor  :math:`j`.


If the crystal is twinned, this will affect the merge. See chapter 
:ref:`twinning` on twinned crystals


If the data is in Batches with different BATCH scale factors, this will
affect the merge.



------------------------------------
WEIGHTING SCHEMES FOR THE DATA MERGE
------------------------------------


   
   At present there are three different weighting schemes available
   for merging equivalent reflections.
   These are :
   
            #. Each reflection is given equal weight (unit weights).
            #. Weights based on a Gaussian distribution.
            #. :math:`w_i = 1.0/\sigma_i^2`  for each reflection.
   


   

   
   Unit and statistical weights (schemes 1 and 3) are more or less
   equivalent unless some reflections have been remeasured under very
   different regimes ( *e.g.* with an attenuator set, mA turned down,
   different crystal)

   
   Scheme 2 is designed to discriminate against outliers, *i.e.*
   reflections lying farther from the mean than might be expected.
   
   For this scheme, a weighted mean value of :math:`F^2` is determined
   iteratively, starting from unit weights.
   At each iteration, the weights are recomputed to discriminate against
   outliers and  the contributing reflections are given a new
   weight :math:`w_i` given by :
   
   :math:`w_i = exp [ (-log(a) q_i^2)/(b^2 e_i^2) ]`
      
   Where
     
   :math:`q_i`  is the deviation of the particular :math:`F^2_i` from the current average.
   :math:`e_i`  is a predicted mean deviation of the reflection :math:`i` from the
   current mean and is given by a function similar to that used
   in Least Squares :
   
   :math:`e_i = c + d \sigma(F_i^2) + g \sigma(F_i^2) |F_{o,i}| + h \sigma(F^2_i).F^2_i`
   
   
   a,b,c,d,g,h  are 6 input parameters provided by the user
   
   
   'a'  and  'b' define the Gaussian distribution.
   
   
   'a'  is the weight to be given to a reflection which has a
   deviation given by :math:`q_i = be_i`.
   
   
   Suggested values of  'a'  and  'b'  are  0.5 and 3.0 respectively,
   so that if for example, :math:`e_i = 3\sigma(F_i^2)` (d=3, c=g=h=0),
   a deviation  :math:`q_i`  of  :math:`6\sigma(F^2_i)`  will assign a reflection a
   weight of 0.5.
   
   'c'  Provides the bias necessary to allow for
   failures in the counting statistics at low count
   rates.
      
   'd'  is a scaling constant.
      
   'g'  and  'h'  allow for the increased dispersion of strong reflections.
   
   ::


       For a conventional diffractometer, suggested values for the parameters are :
      
            a = .5      b=3.0      c=1.0      d=2.0      g=.01      h=.00001
   



   
   It is recommended that the Gaussian scheme be used, as it discriminates
   against zero or widely dispersed intensities very efficiently.
   
   

-----------------------------------------
Standard deviations produced by the merge
-----------------------------------------


   
   After the equivalent reflections have been merged
   two different standard deviations
   are computed and can be output :
   
   :math:`\Sigma_1 = \sqrt{ \sum [ w_i q_i^2 ] / n * \sum w_i }`
   that is, the weighted r.m.s. deviation.
      
   :math:`\Sigma_2 = \sqrt{ \sum [ w_i \sigma_i^2 ] / n * \sum w_i }`
   that is, the weighted average standard deviation.
   


   
   Either of these two standard deviations can be selected as an estimate
   of :math:`\sigma(F^2)`, and perhaps be converted to a Least Squares weight. If a
   reflection is measured very many times, :math:`\Sigma_1` should be similar to
   :math:`\Sigma_2`. It is almost always much greater.
   
-------
\\MERGE
-------

   
   
   

**MERGE=**


   

*INPUT=*


   Either 6 or 7.  Default is 6.
   
   
   

*TWINNED=*


   ::


        NO      Treat data as un-twinned
        LIST13  Treat data according to list 13 
        YES     Treat data as twinned
   


   
   
   
   

**STORE MEDIUM=**


   

*MEDIUM=*


   Determines the output medium.
   
   ::


            FILE              A serial file
            INPUT - Default   The same as the input medium
            DISC              The .DSC file.
   


   
   The default output medium is the same as the input medium -  usually a
   serial file.
   
   
   
   
   

**REFLECTIONS NJCODE= LIST= LEVEL= F'S=**


   

*NJCODE=*


   Specifies the number of JCODE directives to follow - default zero.
   

*LIST=*


   Determines the amount of information printed
   during the merge process.
   
   ::


            OFF
            MEDIUM  -  Default value
            HIGH
   


   
   If  LIST  is 'HIGH' , all Fsq are listed with their
   contributors and their deviations from the computed mean.
   The default value of  MEDIUM  indicates that the merged Fsq are listed
   with the contributors and their deviations
   from the computed mean if the r.m.s. deviation exceeds
   LEVEL*(mean standard deviation).
   HIGH  is equivalent to  MEDIUM  with  LEVEL  set at zero.
   

*LEVEL=*


   This parameter specifies the r.m.s. deviation level above which
   contributors are printed if  LIST  is equal to  MEDIUM .
   
   They are printed if sigma1 exceeds level*sigma2.
   The default value for this parameter is 3.
   

*F'S=*


   
   ::


            FO      -      Default
            FSQ            Indicating that square roots were not taken at
                           input time.
   


   
   
   
   

**JCODE NUMBER= VALUE=**



   
   This directive allows reflections whose JCODE key differs from
   unity to be down-weighted or eliminated from the merge.
   It is repeated once for each JCODE that is read in.
   

*NUMBER=*


   The number of the JCODE must be given.
   There is no default value for this parameter.
   

*VALUE=*


   This is the absolute weight, associated with the JCODE number,
   that is given to the reflection.
   If this parameter is omitted a default value of zero is assumed,
   indicating that the reflection is to be eliminated
   and not included in the merge at all.
   
   
   

**REJECT RATIO= SIGMA=**



   
   This directive causes reflections
   whose mean intensity is less than product of the ratio and sigma to 
   be eliminated.
   

*RATIO=*


   The default value for this parameter is -10. Use LIST 28 (section 
   :ref:`LIST28`) to suppress the
   use of reflections with RATIOs below a suitable threshold.
   

*SIGMA=*


   
   
   
   ::


            1
            2  -  Default value
   


   
   If sigma is equal to 1 the e.s.d. is the weighted r.m.s. deviation.
   If sigma is equal to 2 the e.s.d. is the weighted standard deviation.
   
   
   

**WEIGHT SCHEME= NPARAMETERS= NCYCLE=**



   
   This directive determines the weighting scheme to be used in
   merging equivalent reflections.
   

*SCHEME=*


   This parameter determines which of the weighting schemes defined above
   is to be used in the merging of equivalent reflections,
   and must take one of the following values:
   
   
   
   ::


            1  -  Default value (unit weights)
            2                   (modified Gaussian)
            3                   (statistical)
   


   
   If this parameter is omitted, unit weights are applied (scheme=1).
   

*NPARAMETERS=*


   This must be set to the number of parameters required to define the
   weighting scheme, and thus the number of values on the
   PARAMETERS  directive to follow.
   The default value for this parameter is zero,
   as schemes 1 and 3 require no parameters.
   

*NCYCLE=*


   This parameter has a default value of 5 and is the number of cycles of
   refinement of the weighted mean if scheme 2 is being used in the merge.
   
   
   

**PARAMETERS P .....**


   This directive contains  NPARAMETERS  values.
   

*P=*


   For weighting scheme 2, these parameters give the values  'a'  to  'h'
   defined above, and describe the form of the Gaussian distribution.
   
   
   
   
   
.. index:: Theta-dependent Absorption Correction

   
.. index:: THETABS


===================================================
Theta-dependent Absorption Correction  -  \\THETABS
===================================================


::


    \THETABS
    THETA NTHETAVALUES=
    THETAVALUES THETA=
    THETACURVE CORRECTION= ........
    END






For example

::


    \THETABS
    THETA 16
    THETAVALUES
    CONT 0  5 10 15 20 25 30 35 40 45 50 55 60 65 70 75
    THETACURVE
    CONT 3.61  3.60  3.58  3.54  3.50  3.44  3.37  3.30
    CONT 3.23  3.16  3.09  3.02  2.96  2.91  2.86  2.82
    END






Except
when the data has been corrected by a proper analytical correction,
a theta dependent correction is **ALWAYS** recommended, since neither
a phi scan multi-scan nor DIFABS (section :ref:`DIFABS`) will make a 
good theta 
approximation. See Int Tab,
Vol II, p295 and 303 for suitable profiles.






**THETA NTHETAVALUES=**




*NTHETAVALUES=*


The number of sampling points on the theta curve.




**THETAVALUES THETA= .....**


The Nthetavalues at which the curve is sampled




**THETACURVE CORRECTION= ......**


The Nthetavalue values of the correction factor profile.







.. index:: wILSON PLOT


.. index:: WILSON


========================
WILSON PLOT  -  \\WILSON
========================


::


    \WILSON
    OUTPUT PLOT= NZ= STATS= EVALS=
    FILTER LIST28=
    WEIGHT UPDATE=
    END






PLOT, NZ and STATS take values of YES and NO, controlling whether output
is sent to the GUI.
EVALS takes the values NO/YES/PUNCH.


NO/YES  controls whether E-values are computed.


PUNCH enables E-values to be computed and output to a text file.









.. index:: THLIM


.. index:: THLIM


=================
THLIM  -  \\THLIM
=================

Hthetalim#

::


    \THLIM  INPUTLIST=
    OUTPUT PLOT= GLIST=
    END




This command is only used in SCRIPTS to send information to the GUI


INPUTLIST IS EITHER 6 or 7


PLOT=YES sends plotting data to the GUI


GLIST=YES sends a list of missing reflections to the GUI









SIGMADIST#

.. index:: SIGMADIST


=========================
SIGMADIST  -  \\SIGMADIST
=========================

Hsigmadist#

::


    \SIGMADIST  INPUTLIST=
    OUTPUT PLOT= RESOLUTIO= PHASE= FILTER=
    END




This command is only used in SCRIPTS to send information to the GUI


PLOT=YES sends completeness data to GUI


RESOLUTIO=YES sends distribution as function of resolution to GUI


PHASE=YES   sends phase angle distribution to GUI


FILTER=YES enable LIST 28 to be used.





