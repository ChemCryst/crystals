.. toctree::
   :maxdepth: 1
   :caption: Contents:

      

****************
Fourier Routines
****************


.. _fouandpat:

 



.. index:: Fourier routines


==============================================
Scope of the Fourier section of the user guide
==============================================



In this section of the user guide, the lists and commands
relating to the Fourier routines are described.

::


         Input of the Fourier section limits                  -  \LIST 14
         Compute Fourier linits from the symmetry operators   -  \FLIMIT
         Fourier calculations                                 -  \FOURIER
         Processing of the peaks list                         -   LIST 10
         Elimination of duplicated entries in LISTS 5 and 10  -  \PEAKS
         Slant fourier calculations                           -  \SLANT







.. index:: LIST 14


.. index:: Fourier limits


.. _LIST14:

 
=============================================
Input of the Fourier section limits - LIST 14
=============================================




::


    \LIST 14
    X-AXIS MINIMUM= STEP= MAXIMUM= DIVISION=
    Y-AXIS MINIMUM= STEP= MAXIMUM= DIVISION=
    Z-AXIS MINIMUM= STEP= MAXIMUM= DIVISION=
    X-PAT MINIMUM= STEP= MAXIMUM= DIVISION=
    Y-PAT MINIMUM= STEP= MAXIMUM= DIVISION=
    Z-PAT MINIMUM= STEP= MAXIMUM= DIVISION=
    ORIENTATION DOWN= ACROSS= THROUGH=
    SCALEFACTOR VALUE=





::


    \LIST 14
    X-AXIS 0.0 0.0 0.5 0.0
    Y-AXIS 0.0 0.0 0.9 0.0
    Z-AXIS -2 2 32 60
    ORIENTATION Z X Y
    SCALE VALUE = 10
    END






The Fourier routines will calculate a map with section edges
parallel to any two of the cell axes (a, b or c). The starting and
stopping points must be given for each direction (in crystal fractions).
The user should choose the asymmetric unit to have one
range as small as possible, and the other two approximately equal.
Orientate the computation so that the sections are perpendicular to the
short range direction.
If the command \\SPACEGROUP has been used to input the symmetry
information, a LIST 14 will  have been generated. This will be a valid
choice, but may not be optimal.



---------
\\LIST 14
---------

   
   
   

**X-AXIS MINIMUM= STEP= MAXIMUM= DIVISION=**



   
   This directive specifies how the x-axis is to be divided.
   

*MINIMUM=*


   This parameter gives the initial value along the x-direction.
   If it is omitted, a default value of 0.0 is assumed for  MINIMUM.
   

*STEP=*


   This parameter, which has a default value of 0.3, gives the
   step along the x-direction.
   

*MAXIMUM=*


   This parameter, which has a default value of 1.0, gives the
   final value along the x-direction.
   

*DIVISION=*


   If  DIVISION  is greater than zero, it defines the number of
   divisions into which the x-axis is to be divided.
   In this case, the three remaining parameters are expressed in
   terms of  DIVISION  and give the first point ( MIN ), the
   increment between successive points ( STEP ) and the final
   point to be calculated ( MAX ). If the divisions of the unit
   cell along the x-axis are given in this way, the user must
   ensure that sufficient map is calculated for the map scan, by
   adding one extra point beyond the asymmetric unit at both ends
   along the x-axis. If this is not done, peaks at the edge of the
   asymmetric unit may be missed by the peak search.

   
   If  DIVISION  is equal to zero, which is its default value,
   the Fourier  routines will calculate the number of divisions
   required along the x-axis. In this case,  STEP  is the interval
   between successive points along the axis in angstrom.
   If this parameter is less than 0.05, a default value of 0.3 angstrom
   is used.  MINIMUM  And  MAXIMUM  define the first and last points to be
   calculated and are given in fractional coordinates.
   When the values of  MIN  and  MAX  are converted into unit cell
   divisions, an extra point is added at each end to ensure that the
   peak search functions correctly.
   
   
   

**Y-AXIS MINIMUM= STEP= MAXIMUM= DIVISION=**


   Similar to X-AXIS above.
   
   
   

**Z-AXIS MINIMUM= STEP= MAXIMUM= DIVISION=**


   Similar to X-AXIS above.
   
   
   
   
   

**X-PAT MINIMUM= STEP= MAXIMUM= DIVISION=**


   This directive is similar to the X-AXIS directive, but refers to the
   Patterson asymmetric unit.
   
   
   

**Y-PAT MINIMUM= STEP MAXIMUM= DIVISION=**


   Similar to X-PAT above.
   
   
   

**Z-PAT MINIMUM= STEP= MAXIMUM= DIVISION=**


   Similar to X-PAT above.
   
   
   

**ORIENTATION DOWN= ACROSS= THROUGH=**



   
   Controls the orientation parameters for the map
   calculation and printing.
   

*DOWN=*


   
   ::


            X  -  Default value
            Y
            Z
   


   
   The default value X
   indicates that the x coordinate goes down the printed page.
   

*ACROSS=*


   As DOWN above, but with the default value Y
   indicating that the y coordinate goes across the page.
   

*THROUGH=*


   As DOWN above, but with the default value Z
   indicating that the z coordinate changes from section to section.
   
   
   

**SCALEFACTOR VALUE=**


   

*VALUE=*


   This parameter specifies the value by which the electron density,
   on the scale of /Fc/, is multiplied before it is printed.
   If this parameter is omitted, a default value of 10 is assumed.
   
   

================================
Printing the contents of LIST 14
================================



The contents of LIST 14 can be listed to the line printer
by issuing the command :



----------
\\PRINT 14
----------


   
   There is no command available for punching LIST 14.
   
   
   
   
   
.. index:: FLIMIT

   
.. index:: Conpute Fourier limits


.. _FLIMIT:

 
========================================
Compute Fourier limits from the symmetry
========================================




::


    \FLIMIT LAUE=





::


    \FLIMIT
    END






This command uses the same algorithms as \\SPACEGROUP 
to create a LIST 14. This will be a valid
choice, but may not be optimal.  The parameter LAUE takes a
value from this table:

::


   
     Laue Group     Number      Nx  Ny  Nz         Comment
        -1                   Default value     Compute from operators
         1             1         4   4   4     Triclinic
        2/m            2         8   8   8     Monoclinic
        mmm            3         8   8   8     Orthorhombic  (Fddd 16)
        4/m            4         8   8  16     Tetragonal
        4/mmm          5         8   8  16     Tetragonal
        -3R            6         8   8   8     Rhombohedral
        -3mR           7         8   8   8     Rhombohedral
        -3             8        12  12  24     Hexagonal
        -3m1           9        12  12  24     Hexagonal
        -31m          10        12  12  24     Hexagonal
        6/m           11        12  12  24     Hexagonal
        6/mmm         12        12  12  24     Hexagonal
        m3            13        16  16  16     Cubic
        m3m           14        16  16  16     Cubic
     The values for groups 8 and 9 are OK for the order X,Y,Z, if the 2
     other orders are searched NX and NY should be 24







.. index:: FOURIER


.. _FOURIER:

 
==================================
Fourier calculations  -  \\FOURIER
==================================




::


    \FOURIER INPUT=
    MAP TYPE= NE= PRINT= SCAN= SCALE= ORIGIN= NMAP= MONITOR=
    REFLECTIONS WEIGHT= REJECT= F000= CALC=
    LAYOUT NLINE= NCHARACTER= MARGIN= NSPACE= MIN-RHO= MAX-RHO=
    PEAKS HEIGHT= NPEAK= REJECT=
    TAPES INPUT= OUTPUT=
    END
   
   
    \FOURIER
    MAP TYPE=DIFF
    PEAK HEIGHT = 3
    END






Before a Fourier is computed, a LIST 14 must have been created or
input. The routine will compute a map in any space group,
the relevant symmetry being found in LIST 2 (space group information,
see section :ref:`LIST02`).


In the ouput listing, new peaks are labelled, with the following
meanings

::


         GOOD PEAK - The peak centre was determined by Least-Squares.
         POOR PEAK - The peak centre was determined by interpolation.
         DUBIUOS PEAK - The peak centre is only a local maximum.
         MALFORMED PEAK - The peak centre is extrapolated to be out side
                    of the asymmetric unit - usually due to very poor phasing.







----------------
\\FOURIER INPUT=
----------------

   

*INPUT*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   
   
   
   

**MAP TYPE= NE= PRINT= SCAN= SCALE= ORIGIN= NMAP= MONITOR=**


   
   
   

*TYPE=*


   
   ::


            F-OBS     -  Default value
            F-CALC
            DIFFERENCE
            2F0-FC
            OPTIMAL
            FO-PATTERSON
            FC-PATTERSON
            EXTERNAL
   


   
   The map type 'OPTIMAL' implements a suggestion of Peter Main. It is
   a form of weighted Fo map, with coefficients w*Fo if the reflection is
   in a centro-symmtric class, otherwise (2*w*Fo)-Fc, where w is the Simm weight.
   NOTE this is not the same as w(2*Fo-Fc), a Sim weighted 2Fo-Fc map. It has
   the property that known and unknown atom peak heights are approximately the
   same, and should be usefull for Fourier refinement.
   

*NE=*


   This parameter indicates which solution should be used to compute the
   externally phased map, and has a default value of 1.
   NE  is only used in conjunction with TYPE = EXTERNAL.
   

*PRINT=*


   Controls the printing pf the map.
   
   ::


            NO   -  Default value
            YES
   


   
   

*SCAN=*


   Controls automatic scanningof the map for peaks.
   
   ::


            NO
            YES  -  Default value
   


   
   

*SCALE=*


   Controls the scaling of the electron density in the map.
   
   ::


            NO
            AUTOMATIC  -  Default value
            YES
   


   
   If SCALE is YES,
   the program computes a scale factor rather than take one
   from LIST 14 (Fourier control - section :ref:`LIST14`). The 
   scale factor is computed by summing the modulus of
   all the contributors to the map, and dividing this total into
   ORIGIN  (see the next parameter).
   For a Patterson, therefore, the origin is scaled to be  ORIGIN,
   while for other maps a scale factor is computed which guarantees
   that every number is less than  ORIGIN.

   
   If  SCALE  is  NO, the scale factor is taken from LIST 14
   for all types of Fourier maps.
   If SCALE is AUTOMATIC,
   there is automatic scaling for an external or Patterson map,
   while other maps take their scale factors from LIST 14.
   

*ORIGIN=*


   The default value for this parameter is 999, and is used when
   the program calculates a scale factor (see  SCALE  above).
   

*NMAP*


   Controls negation of the density values, with default NO.
   Use YES, in which case the density values are negated,
   when looking for minima. This
   feature permits location of hydrogen in Neutron maps, and the location of
   minima (which become maxima) generally. Set the Peak Height positive
   even when searching for minina, since at the time of the search the
   minima are inverted. The out put density values have the correct sign.
   Use \\COLLECT 10 5 rather than \\PEAKS on negated maps, since PEAKS
   cannot handle minima.
   

*MONITOR=*


   
   ::


            LOW
            MEDIUM  -  Default value
            HIGH
   


   
   If MONITOR is MEDIUM the, the peak coordinates are printed as they
   are found. If HIGH, density at known sites is also printed.
   
   
   
   
   

**REFLECTIONS WEIGHT= REJECT= F000= CALC=**


   
   
   

*WEIGHT=*


   
   ::


            SIM
            NO     -  Default value
            LIST-6
   


   

   
   If  WEIGHT  is  NO , its default value, then the map is not weighted.

   
   If  WEIGHT  is set equal to  SIM , then SIM weights are computed.
   This option requires both LIST 29 (atomic properties, section :ref:`LIST29`
   and LIST 5. The occupation factors in LIST 5 are used to determine how many
   atoms of each type are present, and LIST 29 indicates how many should be
   present. See the notes under 'TYPE', above.

   
   If  WEIGHT  is  LIST-6 , then the map is weighted with the weight
   stored in LIST 6 (section :ref:`LIST06`).
   

*REJECT=*


   
   ::


            NONE
            SMALL  -  Default value
            QUARTER
            HALF
   


   
   If REJECT  is NONE, all the reflections in LIST 6 which are
   allowed by LIST 28 are included.
   In this case, no check is made on the /Fc/ value.
   For an /Fo/, /Fc/ and difference Fourier, the program expects that there
   should be an /Fc/ value if the phase is to be defined.
   Accordingly, reflections where /Fc/ < 0.001 are normally rejected
   for such Fouriers, and this is the default option of  SMALL.

   
   Some users like to omit reflections if Fc is smaller then a fraction of
   Fo. The options QUARTER and HALF are available.
   

*F000=*


   The default value for this parameter is zero, and specifies the value
   of F(000) to be used.
   

*CALC*


   
   ::


            NO   -  Default value
            YES
   


   
   Value YES causes structure factors (i.e. Fc and phase) to be calculated
   immediately before the map is computed. This option can only be activated
   if some previous task with the current DSC file
   has computed phases via a \\SFLS command (section :ref:`SFLS`) and left a 
   LIST 33 on the disk (List 33 is the stored representation of the SFLS
   command, so that the program can rememeber how the last refinement was
   carried out, see section :ref:`SFLS`)
   
   
   

**LAYOUT NLINE= NCHARACTER= MARGIN= NSPACE= MIN-RHO= MAX-RHO=**



   
   This directive specifies how the map should be printed, if the value of the
   PRINT parameter on the MAP directive is YES.
   

*NLINE=*


   This parameter sets the number of lines per row of map, and has a default
   value of 2.
   

*NCHARACTER=*


   This parameter controls the number of characters for each grid
   point, and has a default value of 4.
   

*MARGIN=*


   This parameter, whose default value is 4, defines the number of
   characters per division number down each side of the map.
   

*NSPACE=*


   This parameter has a default value of 2, and defines the number of
   spaces between the division number and the grid number down each
   side of the map. The minimum value for  NSPACE  is 2.
   

*MIN-RHO=*


   This parameter has a default value of -1000000, and points less than
   MIN-RHO  are left blank when the map is printed.
   

*MAX-RHO=*


   This parameter has a default value of 1000000, and points greater than
   MAX-RHO  are left blank when the map is printed.
   
   
   

**PEAKS HEIGHT= NPEAK= REJECT=**



   
   Controls the search for peaks when the map is
   searched, i.e. if the value of the SCAN  parameter on the MAP directive
   is YES.
   

*HEIGHT=*


   This parameter sets the search of the map for all
   peaks with an electron density greater than  HEIGHT. If this
   parameter is omitted, a default value of 50 is assumed
   for an external or Patterson map. For all other maps, the map is scanned
   for peaks greater than 1.5*SCALE, where  SCALE  is the map scale factor,
   either taken from LIST 14 (Fourier control - section :ref:`LIST14`) 
   or computed using  SCALE  =  YES  above.
   

*NPEAK=*


   This parameter, whose default value is 0, determines the number
   of peaks to be retained after they have been ranked by peak height.
   If NPEAK is zero or negative, the number of peaks saved is computed from
   
   ::


            NPEAK = (Cell volume) / (18 * Space Group multiplicity)
      
                                     18 is an average atomic volume.
   


   
   

*REJECT=*


   This parameter, with a default value of 0.01, specifies that peaks
   within a distance of  REJECT  angstrom of a peak already ranked on
   peak height, will be rejected from the list.
   
   
   

**TAPES INPUT= OUTPUT=**


   This directive is used if a map is to be read off magnetic tape,
   or a computed map is to be written to a
   magnetic tape. Remember that CRYSTALS will use scratch files unless given
   named files. To assign a named  output file, issue
   ::


            \OPEN MT1 filename
   


   

   
   The tape is unformatted.
   
   ::


       Record 1: 'INFO  DOWN ACROSS SECTION'
       Record 2: 'TRAN'       9 elements of a transformation matrix
       Record 3: 'CELL'       Cell parameters, angles in radians
       Record 4: 'L14 '       List 14 information
       Record 5: 'SIZE'       number of points down, across, and number of sections
       Record 6:  number of values,  values for a section
                 Record 6 is repeated for every section.
       Record n:  number of atoms, number of items per atom
       Record n+1: Items for an atom, repeated for all atoms
   


   

   
   Record 4 contains 6 integers, (No of points down
   and across the page, number of sections, and the index of these
   directions, 1 = x). Subsequent records contain a whole section line by line,
   prefixed by the total number of points in the section.
   

*INPUT=*


   
   ::


            NO   -  Default value
            YES
   


   
   If INPUT is YES, a map will be
   read in from the 'input magnetic tape', and the resulting map
   will be the minimum of each point of the calculated and input maps.
   The input map sections must be on device 'MT2'

   
   *** THIS FACILITY IS NOT CURRENTLY IMPLEMENTED ***
   
   
   

*OUTPUT=*


   
   ::


            NO   -  Default value
            YES
   


   
   If  OUTPUT  is YES, the map produced is written to the
   'output magnetic tape'. You may need to OPEN a permanent file on
   device 'MT1'.
   
   

==============================================
Calculation of superposition minimum functions
==============================================



(Issue 7 - implementation incomplete, 1984)


(Issue 9 - implementation still incomplete, 1993 - no one seems to want it
anyway!- use SHELXS if you need to).


(Issue 10 - still no change, 1996)


The Fourier routine provides a way of
calculating superposition minimum functions.
For each map that is produced, it is possible to specify that another
map should be read in from magnetic tape at the same time (the  TAPES
directive). Each point of the resulting map is taken as the minimum of
the newly computed map and that read off the magnetic tape. This output
map may be written to a second magnetic tape, also by use of the  TAPES
directive.


When the input map and the calculated map are superposed, the first
point calculated and the first point read off the tape are compared,
the second point calculated and the second point input are compared,
and so on. This implies that the first point on each map must represent
the same point in real space for the output map, and that each map must
contain the same number of points.
The origin of each map that is to be calculated is altered by
changing LIST 14 (Fourier limits - section :ref:`LIST14`). For example, 
if a 2x, 2y, 2z vector has been identified
at 0.36, 0.14 and 0.28, and the 2x, 1/2-2y, 0 vector resulting from a
two-fold axis has been found at 0.36, 0.36, 0, then the two LIST 14's
for the superposition function might appear as :

::


    \LIST 14
    X-AXIS 14 4 122 400
    Y-AXIS 5 2 59 100
    Z-AXIS 12 2 66 100
    ORIENT X Y Z
    SCALE 10
    END
   
         and
   
    \LIST 14
    X-AXIS 14 4 122 400
    Y-AXIS 16 2 70 100
    Z-AXIS -2 2 52 100
    ORIENT X Y Z
    SCALE 10
    END






For the first map, the origin of real space is at 0.18, 0.07 and 0.14
in vector space. This point is moved so that it is one grid point
in along each axial direction, to allow for the map scan.
For the second peak, the origin in real space is at 0.18, 0.18 and 0.0.
The second LIST 14 places this point one grid point in along each of the
axial directions so that the real space origin of the two maps
coincides. To convert the coordinates that result from the second map
scan to real space coordinates, it is necessary to subtract 0.18
from x and 0.18 from y, since the coordinates are printed in
Patterson space for all the maps calculated.



.. index:: LIST 10


.. index:: Peaks list


.. _LIST10:

 
========================================
Processing of the peaks list  -  LIST 10
========================================







**\\LIST 10**




LIST 10 cannot be input bythe user. When the map scan has been completed,
the resulting peaks are output to the disc as a LIST 10.
Except for an external or  Patterson map, the atoms already
in LIST 5 are placed at the beginning of the LIST 10.


A LIST 10 is usually converted to a LIST 5
by one of the following commands :

::


    \EDIT 10 5                \PEAKS 10 5
    \COLLECT 10 5             \REGROUP  10 5




\\PEAKS  is the normal choice,
since duplicate peaks related by symmetry, or peaks corresponding to
known atoms  can be eliminated. It is described below; EDIT, COLLECT
and REGROUP are in the section on Atomic and Structural Parameters.



================================
Printing the contents of LIST 10
================================



The contents of LIST 10 can be listed with:



----------
\\PRINT 10
----------


   
   There is no command available for punching LIST 10 out to a file.
   
   
   
.. index:: PEAKS


===============================================================
Elimination of duplicated entries in LISTS 5 and 10  -  \\PEAKS
===============================================================


::


    \PEAKS INPUTLIST= OUTPUTLIST=
    SELECT REJECT= KEEP= MONI= SEQ= TYPE= REGROUP= MOVE= SYMM= TRANS=
    REFINE DISTANCE= MULTIPLIER=
    END
   
    \PEAKS
    SELECT REJECT=0.0001
    REFINE DISTANCE=.5
    END






This routine eliminates
atoms or peaks which duplicate other entries in an atomic
parameter list.
When using this routine, a set of distances is calculated about each
atom or peak in turn. Atoms or peaks further down the list than the
current pivot are then eliminated if they have a contact distance less
than a user specified maximum (the  REJECT  parameter).
Thus, when peaks have been added to a
LIST 5, the peaks corresponding to the atoms can be eliminated.



------------------------------
\\PEAKS INPUTLIST= OUTPUTLIST=
------------------------------

   INPUTLIST and OUTPUTLIST specify where the atoms are to be taken from,
   and where they will be put.
   

*INPUTLIST=*


   
   ::


            5
            10  -  Default value
   


   
   

*OUTPUTLIST=*


   
   ::


            5   -  Default value
            10
   


   
   
   
   

**SELECT REJECT= KEEP= MONI= SEQ= TYPE= REGROUP= MOVE= SYMM= TRANS=**


   

*REJECT=*


   REJECT is the distance above which connected atoms or peaks are assumed to
   be distinct. If a contact is found which is less than  REJECT
   the second atom or peak of the pair in the list is eliminated, and
   defaults to 0.5.
   

*KEEP=*


   This parameter indicates how many entries are to be kept in the
   output list. The default value of 1000000 is the maximum possible.
   

*MONITOR=*


   
   ::


            LOW
            HIGH  -  Default value
   


   
   If  MONITOR  is given as  LOW only the atoms or peaks that are
   deleted because of the REJECT limit are listed.
   If  MONITOR  is  HIGH, all the atoms deleted because of both  KEEP
   and  REJECT  are listed.
   

*SEQUENCE=*


   
   ::


            NO  -  Default value
            YES
            EXHYD
   


   
   If  SEQUENCE  is  YES, then the program will
   give sequential serial numbers to the atoms and
   peaks in the final output  list .
   
   
   If SEQUECE is EXHYD the hydrogen atoms are excluded from the 
   renumbering.
   

*TYPE=*


   
   ::


            PEAK  -  Default value
            ALL
            AVERAGE
   


   
   If  TYPE is  PEAK, then the program will only delete PEAKS which are
   within REJECT of an existing atom. It TYPE is ALL, atoms are also
   deleted.
   
   
   If TYPE is AVERAGE, coincident atoms or peaks are averaged. The radius
   for coincidence is taken from the DISTANCE keyword on the REFINE
   directive. The default radius is .5 Angstrom.
   

*REGROUP=*


   This parameter has two allowed values :
   
   ::


            NO  -  Default value
            YES
   


   
   If  REGROUP  is  YES, then the program will reorganise LIST 5 so that
   bonded atoms and peaks are adjacent.
   

*MOVE=*


   The value of this parameter is the maximum separation for 'bonded' atoms.
   The default is 2.0 A.
   

*SYMMETRY=*


   This parameter controls the use of symmetry information in the calculation of
   contacts, and can take three values.
   
   ::


            SPACEGROUP  -  Default value. The full spacegroup symmetry is used in
                                          all computations
            PATTERSON.     A centre of symmetry in introduced, and the translational
                           parts of the symmetry operators are dropped.
            NONE.          Only the identity operator is used.
   


   
   

*TRANSLATION=*


   This parameter controls the application of cell translations in the
   calculation of contacts, and can take the values YES or NO
   
   
   
   
   

**REFINE DISTANCE= MULTIPLIER=**



   
   Controls action of Fourier refinement.
   

*DISTANCE=*


   This parameter has a default value of zero, and is
   the distance below which atoms and peaks are considered
   to be coincident.  The coordinates of an existing atom are replaced
   by those of a coincident peak. Refinement takes precedence
   over deletion of peaks.
   

*MULTIPLIER=*


   This parameter has a default value to give automatic refinement.
   It is set to 1 for a centric space group and is set to
   2 for a non-centric space group. It can be set to 0.0 to preserve original
   coordinates but be given new peak heights.
   
   ::


            X(new) = x(atom) + mult(x(peak) - x(atom)).
   


   
   
   ::


       \ reject atoms or peaks with contact distances less than 0.7
       \ keep 30 entries in the output list
       \ list the atoms and peaks rejected because of both 'KEEP'
       \ and 'REJECT'
       \
       \PEAKS 10 5
       SELECT REJECT=0.7,KEEP=30,MONITOR=HIGH
       END
   


   
   
   
   
.. index:: SLANT

   
.. index:: Slant Fourier calculation


======================================
Slant fourier calculations  -  \\SLANT
======================================


::


    \SLANT INPUT=
    MAP TYPE= MIN-RHO= SCALE= WEIGHT=
    SAVED MATRIX=
    CENTROID XO= YO= ZO=
    MATRIX R(11)= R(12)= R(13)= R(21)=  .  .  . R(33)=
    DOWN MINIMUM= NUMBER= STEP=
    ACROSS MINIMUM= NUMBER= STEP=
    SECTION MINIMUM= NUMBER= STEP=
    END
   






A Slant Fourier is one that is calculated through any general plane
of the unit cell. For such a Fourier, the normal Beevers-Lipson
expansion of the summation cannot be used, so that it
will take many orders of magnitude longer than a
conventional one.
The algorithm adopted here is as follows :

::


    X    A general vector expressed in fractions of the
        unit cell edges (i.e. x/a, y/b and z/c)
    XO   The centroid of the required general fourier section,
        also expressed in crystal fractions.
    XP   The coordinates of the point 'X' when expressed
        in the coordinate system used to define the
        plane of the general section.
    'X' and 'XP' are related by the expression :  XP = R.(X-XO)
    R    'R' is the matrix that describes the transformation
        of a set of coordinates in the crystal system to
        a set of coordinates in the required plane.
    therefore :  X = S.XP + XO
   
        'S' is the inverse matrix of 'R'.
   
    The required expression in the fourier is :
   
        H'.X = H'.S.XP + H'XO
   
    H    H is a vector containing the Miller indices of
        a reflection and H' is the transpose of H.
    This may be re-expressed as :
   
        H'.X = H'.S.DXP + H'.(S.XPS + XO)
   
    DXP  'DXP' represents the increment in going from the
        first point on the section to be calculated.
    XPS  'XPS' is the coordinate of the first point on the
        section to be calculated.
        obviously :  XP = XPS + DXP.






When the Fourier is calculated, the term *H'.(S.XPS* *+* *XO)*
is constant for each section to be calculated. The term *H'.S* ,
which may be regarded as the transformed indices, is also constant
for each reflection, so that a two dimensional recurrence relation
may be used to change  *DXP*  and thus  *Cos(2*PI*H.X* *-* *ALPHA)'* over
the required section for each reflection. ( *ALPHA*  is the phase
angle for the current reflection).


The input for the slant Fourier thus must include the rotation
matrix  *R,* the centroid  *XO,* and the steps and divisions in the
required plane.



--------------
\\SLANT INPUT=
--------------


   
   This is the command which initiates the slant fourier routines.
   

*INPUT*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   
   
   
   

**MAP TYPE= MIN-RHO= SCALE= WEIGHT=**


   

*TYPE=*


   
   ::


            F-OBS
            F-CALC
            DIFFERENCE
            FO-PATTERSON
            FC-PATTERSON
   


   
   There is no default value for this parameter
   

*MIN-RHO=*


   This parameter has a default value of zero, and
   is the value below which all numbers on the map are replaced by
   MIN-RHO.
   

*SCALE=*


   The terms used in the Fourier are put on the same scale as  Fc,
   and then before the map is printed the numbers are multiplied
   by  SCALE . (i.e.  SCALE  is the map scale factor).
   The default is 10.
   

*WEIGHT=*


   
   ::


            NO   -  Default value
            YES
   


   

   
   If WEIGHT = YES, the observed and calculated structure factors are
   multiplied by  the weights in LIST 6 (usually SQRT(w)). The user should
   be aware that this might have a major effect on the scale if the map
   density, and that SCALE may need adjusting.
   
   
   

**SAVED MATRIX=**



   
   This directive, which excludes CENTRIOD and MATRIX, uses the matrix and
   centroid stored in LIST 20 by a previous GEOMETRY, MOLAX or ANISO command (see
   section :ref:`LIST20`).
   

*MATRIX=*


   
   ::


            MOLAX
            TLS
            AXES
   


   
   
   
   

**CENTROID XO= YO= ZO=**



   
   This specifies the slant Fourier map centroid, in crystal fractions,
   and excludes SAVED.
   

*XO=*


   

*YO=*


   

*ZO=*


   The defaults value for  XO,YO,ZO, the coordinates  of the centroid,
   are 0.0.
   
   
   

**MATRIX R(11)= R(12)= R(13)= R(21)=  .  .  . R(33)=**



   
   This gives the elements of the rotation matrix  R, and
   excludes SAVED. The trnsformation generally used is from crystal
   fractions to orthogonal Angstroms.
   

*R(11)= R(12)= R(13=) R(21)=  .  .  . R(33)=*


   There are no default values for any of these parameters.
   
   
   

**DOWN MINIMUM= NUMBER= STEP=**



   
   This directive defines the printing of the map down the page.
   

*MINIMUM=*


   There is no default value for this parameter, the first point,
   in Angstrom,
   down the page of the plane to be calculated.
   

*NUMBER=*


   There is no default value for this parameter, the number of points
   of the plane to be printed down the page
   

*STEP=*


   There is no default value for this parameter, the interval
   in Angstrom between successive points down the page.
   
   
   

**ACROSS MINIMUM= NUMBER= STEP=**



   
   This directive defines the printing of the map across the page. The
   parameters have similar meanings to those for 'DOWN'.
   
   
   
   

**SECTION MINIMUM= NUMBER= STEP=**



   
   This directive defines the printing of the map sections. The
   parameters have similar meanings to those for 'DOWN'.
   

   
   The units of  MINIMUM  and  STEP  are based on the coordinate system
   used to describe the plane, with the new 'x' axis going down the page and
   'y' across. In general the most convenient axial
   system for the plane is one expressed in Angstrom, so that the initial
   points and the steps are all expressed in Angstrom. (The
   least squares best plane program
   prints out the centroid in crystal fractions
   and the rotation matrix from crystal fractions to best plane coordinates
   in Angstrom, which are the numbers required, and may be  saved for use in
   SLANT by the directive 'SAVE').
   
   ::


       \ the map will be a difference map
       \ we wish to compute the section 0.3 anstrom above the plane
       \ numbers less than zero will be printed as zero
       \ the molecule lies at a centre of symmetry
       \ so that the centroid in crystal fractions is 0, 0, 0
       \ the plane coordinates are in angstrom
       \ for printing the plane both across and down the page,
       \ we will start 4 angstrom from the centroid,
       \ and go 4 angstrom the other side of the centroid,
       \ making a grid 8 angstrom by 8 angstrom
       \
       MAP DIFFERENCE 0.3 0
       CENTROID 0 0 0
       MATRIX 3.4076 10.0498 6.1794
       CONT   5.0606  8.287 -9.5483
       CONT  -6.9181 11.0121 1.546
       DOWN -4 33 0.25
       ACROSS -4 33 0.25
       END
   


