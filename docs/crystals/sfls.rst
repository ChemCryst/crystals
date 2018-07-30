.. toctree::
   :maxdepth: 1
   :caption: Contents:

***********************************
Structure Factors And Least Squares
***********************************


.. _sfandls:

 

========================================================
Scope of the structure factors and least squares section
========================================================





This section describes the necessary LISTS and explains how structure factor
calculation and
least squares refinement can be carried out.




Refinement

LIST 23 - Structure factor calculation control list (:ref:`LIST23`)

SPECIAL - Special positions constraints (:ref:`SPECIAL`)

LIST 12 - Input of refinement directives (:ref:`LIST12`)

LIST 16 - Input of the restraints (:ref:`LIST16`)

LIST 4 - Weighting the reflections (:ref:`LIST04`)

LIST 28 - Reflection restriction list (:ref:`LIST28`)

CHECK - Checking the refinement and restraint directives

SFLS - Structure factor least squares calculations (:ref:`SFLS`)

ESD - Creates an esd list, LIST 9 (:ref:`LIST9`)

ANALYSE - Systematic comparisons of Fo and Fc

DIFABS - Least squares absorption correction



Internal workings



LIST  9 - Parameter esds (:ref:`LIST9`)

LIST 22 - Refinement parameter map (:ref:`LIST22`)

LIST 17 - Input of the special restraints (:ref:`LIST17`)

LIST 11 - The least squares matrix (:ref:`LIST11`)

LIST 24 - The least squares shift list (:ref:`LIST24`)

LIST 26 - Restraints in internal format (:ref:`LIST26`)



.. index:: Refinement


==========
Refinement
==========





Before a stucture factor-least squares calculation is performed, the
following lists must exist in the .DSC file



LIST  1  Cell parameters (section :ref:`LIST01`)

LIST  2  Symmetry inforamation (section :ref:`LIST02`)

LIST  3  Scattering factors (section :ref:`LIST03`)

LIST  4  Weighting scheme

LIST  5  Atomic and other model parameters (section :ref:`LIST05`)

LIST  6  Reflection data (section :ref:`LIST05`)

LIST 12  Refinement definitions (section :ref:`LIST12`)

LIST 16  Restraints (section :ref:`LIST16`)

LIST 17  Special position restraints (section :ref:`LIST17`)

LIST 18  SMILES string (section :ref:`LIST18`)

LIST 23  Structure factor control list (section :ref:`LIST23`)

LIST 25  Twin laws, only for twinned refinements (section :ref:`LIST25`)

LIST 28  Reflection control list (section :ref:`LIST28`)



LISTS 12,16 and 17 (constraints :ref:`LIST12`, restraints 
:ref:`LIST16` and special restraints  :ref:`LIST17`) 
are not required if structure factors 
are only going to be calculated.


The refinement directives specify which model
parameters are to be refined, and the control directives control the
terms in the minimisation function.


During structure factor least squares calculations,
the partial derivatives with respect to each of the parameters is
calculated for each structure factor and added into the 'normal
equations'.
This system of equations may be represented in matrix notation as :

::


          A.x = b
          WHERE :
          A      'A' is a symmetric n*n matrix. an element
                 'A(i,j)' of 'A'is given by :
                  A(i,j) = Sum [ w(k)*Q(i,k)*Q(j,k) ] over k.
          n       number of parameters being refined.
          k       indicates reflection number 'k'.
          w(k)    weight of reflection k.
          Q(i,k)  the partial differential of Fc(k) with
                  respect to parameter i.
          x       a column vector of order n, containing
                  the shifts in the parameters.
          b       also a column vector, an element
                  of which is given by :
                  b(i) = Sum [ w(k)*DF(k)*Q(i,k) ] over k.
          DF(k)   delta for reflection k, given by :
                  DF(k) = [Fo(k) - Fc(k)]
   






As the matrix  A  is symmetric, only (n(n+1))/2 of its elements
need to be calculated and stored, together with a few house keeping items.


In some cases, because of either storage or time considerations,
it is impractical to use the full normal matrix  A .
In this situation, it is necessary to use a 'block diagonal approximation'
to the full matrix, in which interactions between parameters which are known
not to be highly correlated are ignored.
The effect of ignoring such interactions is to leave blank areas of
the full matrix, related symmetrically across the diagonal, which
do not need to be stored or accumulated.
A common (but not very efficient or stable)
example of this approach is to place one atom in each of the blocks
used to approximate the normal matrix, so that each block is of order
either 4 (x, y, z and u[iso]) or 9 (x, y, z and the anisotropic
thermal parameters).


One of the main purposes of the refinement directives is to
describe the areas of the matrix  A  that are to be calculated.
If the matrix  A  is approximated by  m  blocks of order
n(1), n(2),.....n(m),
The total amount of memory needed to hold the matrix
and vector is:

::


         Elements = 12 + 4*m + Sum n(i)*(5 +n(i))/2,
   
                                                    i = 1 to m
   
         Currently (June 2003) elements=8,388,608, giving over 4000
    parameters in a single block.






The formation of the blocks that are to be used to
approximate the normal matrix  A  is controlled in the refinement
directive list by a series of  BLOCK  directives, each of which
contains the coordinates that are to be included in the newly
specified block.
Further control instructions for the current block may appear on
subsequent directives until a new  BLOCK  directive is found, when the formation
of another block with its associated parameters is started.


Two special directives are provided to allow for the most common
cases required, full matrix refinement (a  FULL  directive)
and one atom per block (a  DIAGONAL  directive).
For all these cases only the parameters specified on the control directives
and the following directives are refined.


**Correlations in Refinement**




Highly correleated parameters **MUST** be refined together. Refining
them in different cycles or different blocks will lead to an incorrect
structure.


As a rough guide, the following groups of parameters are in general
highly correlated and should be refined in the same block if possible :

::


    1.  Temperature factors, scale factors, the extinction
        parameter, the polarity parameter and the
        enantiopole parameter.
    2.  Coordinates of bonded atoms.
    3.  Non-orthogonal coordinates of the same atom.
    4.  U(11), U(22) and U(33) of the same atom.






If it is necessary to split the temperature factors and scale
factor into different blocks, their interactions must not be neglected
but must be allowed for by using a 'dummy overall isotropic temperature
factor'.
In this case, the scale factor and the dummy temperature factor
must be put into a block of order 2 by themselves, and the program
will make the appropriate corrections to all the temperature factors.
This dummy temperature factor should not be confused with the
'overall temperature factor' which is a temperature factor that
applies to all the atoms and is therefore just a convenience and requires
no special treatment.


For further details,  Computing Methods in
Crystallography, edited by J. S. Rollett, page 50, and Crystalographic
Computing, ed Ahmed, 1970,  page 174.



Although it is possible to input an overall temperature factor as one
of the overall parameters, it is not possible to use it under all
circumstances. The structure factor routines always take the
temperature factor of an individual atom as the value or values stored
for that atom. If the overall temperature factor is to be refined, the
system will ensure that the current value of the overall temperature
factor is inserted for the temperature factor of all the atoms. When the
new parameters are computed after the solution of the normal equations,
this substitution is again made, so that all the atoms have the same
overall isotropic temperature factor. However, if the overall temperature
factor is not refined, or no refinement is done, the individual temperature
factor for each atom will be used, and the overall temperature factor ignored.


**CAUTION**




It should be noted that if a set of anisotropic atoms are input with no
U[ISO]  key and  U[ISO]  data, then the default value of 0.05 will be
inserted by the sfls routines. This implies that all such atoms are
isotropic, so that the anisotropic temperature factors will be set to
zero, and the calculation will proceed for isotropic atoms.




**F or Fsq refinement?**


Both type of refinement have been available in CRYSTALS since the early
70's. For most data sets, there is little difference between the two
correclty weighted refinements. One of the current reasons for choosing
Fsq refinement is 'so that -ve observations may be used'. Such a choice
is based on the misapprehension that the moduli in /Fo/ are the result
of taking the square root of Fsq. In fact, it indicates that the phase
cannot be observed experimentally. The experimental value of Fo takes
the sign of Fsq and the positive square root. With proper weighting,
both refinemets converge to the same minima
(Rollett, J.S., McKinlay,T.G. and Haigh, N.P.,  1976, Crystallographic
Computing Techniques, pp 413-415,  ed F.R.
Ahmed,Munksgaard; and Prince,E. 1994, Mathematical Techniques in
Crystalography and Materials Science, pp 124-125.Springer-Verlag).
However, the path to the
minima will be different, and there is some evidence that Fsq refinement
has less false minima. Using all data, including -ve observations,
increases the observation:variable ratio, but it is not evident that a
large number of essentially unobserved data will improve the refinement.
If the difference between F and Fsq refinement is significant, then the
analysis requires care and attention.




**Hydrogen Atom Refinement**




Several strategies are available for refining hydrogen atoms.
Which you use is probably a matter of taste.


*Geometric re-placement*


The command \\HYDROGEN or \\PERHYDRO is used to compute geometrically
suitable positions for the H atoms. These are **not** refined (either
they are left out of LIST 12, or a fixed with the FIX directive). After
a few cycles of refinement of the remaining parameters, they are deleted
(\\EDIT <cr> SELECT TYPE NE H) and new positions computed. This ensures
optimal geometry, ensures that Fcalc is optimal, but avoids the cost of
including the deviatives in the normal matrix.


*Riding hydrogens*


As above, the hydrogens are placed geomtrically, but they are included
in the formation of the least squares matrix. Their derivatives are
added to those of the corresponding carbon, and a composite shift
computed for each carbon and its riding hydrogens. This preserves the
C-H vector, but can distort C-C-H angles. A cycle of refinement takes
almost twice as long as the re-placement method.


*Restrained hydrogens*


In this method, starting positions are hound for the hydrogen atoms
(either from Fourier maps of geometrically), and the hydrogen positions
are refined along with other atoms. The C-H distances and C-C-H angles
are restrained to acceptable values in LIST 16. This calculation is even
slower than the riding model, and would normally only be applied to an
atom of special significance ( *e.g.* a hydrogen bond H atom).


*Free refinement*


The hydrogen atom is treated like any other atom. Requires good data,
and may be applied to atoms of special interest.




Note that the different methods can be mixed in any way, with some
hydrogens placed geometrically, and others refined.




**R-Factor and minimisation function definitions**




**Conventional R-value**


This is defined as:

::


         R = 100*Sum[//Fo/-/Fc//]/Sum[/Fo/]




The summation is over all the reflections accepted by LIST 28. This
definition is used for both conventional and F-squared refinement.


**Weighted R-value**


The Hamilton weighted  R-value  is defined as :

::


         100*Sqrt(Sum[ w(i)*D'(i)*D'(i) ]/SUM[ w(i)*Fo'(i)*Fo'(i) ])
   
         D'  = Fo'-Fc'
         Fo' = Fo for normal refinement, Fsq for F-squared refinement.
         Fc' = Fc for normal refinement, Fc*Fc for F-squared refinement.






*Minimisation function*


This is defined by :

::


         MINFUNC = Sum[ w(i)*D(i)*D(i) ]
   
         D', Fo', Fc' defined above.






*Residual*


The residual and weighted residual are defined by:

::


         residual = Sum D'(i)**2
         weighted residual = Sum w(i)*D'(i)**2








.. index:: Special positions


=================
Special positions
=================



The second major purpose of the refinement directives is to
allow for atoms on special positions.
For example, the atom at the Wyckoff site  H  in the space group
P6(3)/mmc (no. 194) has coordinates  X,2X,Z .
In a least squares refinement, the  X  and  Y  coordinates of this atom
must be set to the same variable, i.e. they become equivalent.

The command
\\SPECIAL (section :ref:`SPECIAL`) can be used to generate the necessary 
constraints or restraints,
and may be invoked automatically before structure factor calculations
by setting the appropriate parameters in  LIST 23 (structure factor
control settings, see section :ref:`LIST23`)

The user can do this manually via  the refinement directives, LIST 12.
The relationship is set up
by an  EQUIVALENCE  directive, which sets all the parameters
on the directive to the same least squares parameter.
In this example, it is also necessary to alter the contribution
of the  Y  coordinates to the normal matrix by multiplying the derivatives
by 2.
This facility is provided by the  WEIGHT  directive, which should not be confused
with the weight ascribed to each reflection in
the refinement.
For a full treatment of atoms on special positions, see
Crystallographic Computing, edited by F. R. Ahmed, page 187,
or Computing Methods in Crystallography, page 51.


Similar relationships also hold for the anisotropic temperature factors.


The relationships between the variable  parameters in a refinement
may also be defined by RESTRAINTS. These are held in LIST 17 (see :ref:`LIST17`),
and are particularly usefull if a complex matrix has been defined (e.g.
using RIDE, LINK, EQUIVALENCE, WEIGHT, BLOCK, GROUP or COMBINE).


.. index:: Refinement - atomic parameters


===========================
Atomic parameter refinement
===========================



Atomic parameters may be specified in three different ways.
Firstly, there is an  **IMPLICIT**  definition, in which parameters for all the
atoms are specified simply by giving the appropriate key or keys.


Hydrogen atoms are automatically excluded from implicit definitions.


Secondly, there is an  **EXPLICIT**  definition, in which the parameters of one
atom are specified by giving the atom name followed by the appropriate
keys.


Lastly, the parameters for a continuous group of atoms in LIST 5 may be
specified by an UNTIL sequence.
This type of parameter definition is taken to be implicit.


**KEY[1] . . . KEY[K]**


parameters defined by the keys KEY[1] . . KEY[K]
are included (or excluded) for all the atoms in LIST 5,
e.g. X U[ISO]  implies that the 'X' and 'U[ISO]'
parameters of all the atoms in the current LIST 5
will be used. This is an **implicit** definition,
since parameters for
all the atoms in LIST 5 are specified simply by
giving the appropiate key.


**TYPE(SERIAL,KEY[1], . . ,KEY[K])**


parameters defined by the keys KEY[1] . . . KEY[K]
are included (or excluded) for the atom of type 'TYPE' with
the serial number 'SERIAL', e.g. C(21,X,U[ISO])
implies that the 'X' and 'U[ISO]' parameters of
atom C(21) will be used.
This is an  **explicit** definition.


**TYPE1(SERIAL1,KEY[1], . ,KEY[K])  UNTIL  TYPE2(SERIAL2)**


the parameters defined by the keys KEY[1] . . KEY[K]
are included (or excluded) for atoms in LIST 5 starting at the
atom with type 'TYPE1' and serial 'SERIAL1', and
finishing with the atom of type 'TYPE2' and
serial 'SERIAL2'.
This definition is **implicit,**
since the number of atoms
included by this definition depends on the number
and order of the atoms in LIST 5.


Parameter definitions of all three types may appear on any directive
in any desired combination.

::


    EXAMPLE
          LIST 5 contains  FE(1) C(1) C(2) C(3) C(4) C(5) C(6) N(1)
   
          \LIST 12
          BLOCK X'S C(1,U[ISO]) UNTIL C(6) FE(1,U'S)
          END
   
         This refines x,y,z of all atoms, u[11]...u[12] of iron, and
         u[iso] of the other atoms.






The following parameter keys may be given in an atom
definition :

::


    OCC     X       Y         Z
    U[ISO]  SIZE    DECLINAT  AZIMUTH
    U[11]   U[22]   U[33]     U[23]    U[13]    U[12]
   
    X'S      Indicating  X,Y,Z
    U'S      Indicating  U[11],U[22],U[33],U[23],U[13],U[12]
    UII'S    Indicating  U[11],U[22],U[33]
    UIJ'S    Indicating  U[23],U[13],U[12]





.. index:: Refinement - overall parameters


============================
Overall parameter refinement
============================



Overall parameters, apart from the layer scale factors and the
element scale factors, are specified  simply by their keys.
Such a specification is considered to be an explicit definition.
The following overall parameter keys may be given :

::


    SCALE       OU[ISO]       DU[ISO]
    POLARITY    ENANTIO       EXTPARAM





========================
Scale factor definitions
========================



The OVERALL scale factor is always applied to the structure factor
calculation, though it need not necessarily be refined.
LAYER and BATCH  scale factors are applied only if indicated in LIST 23
(structure factor control settings, see section :ref:`LIST23`),
and ELEMENT scales only if the crystal is marked as being twinned in LIST
13. Note that all of these scale factors can be expected to be correlated
with each other, and the overall parameters.


The layer scale factors, batch scale factors
and the element scale factors may be
given in three different ways, all of which are
considered to be explicit :


**LAYER(M), BATCH(M)   OR   ELEMENT(M)**


this indicates only scale factor 'M' of the specified type.
'M' must be in the correct range, which for 'N' layer scale factors
is 0 to 'N-1', and for 'N' element scale factors is
1 to N.


**LAYER(P) UNTIL LAYER(Q)   OR   BATCH(P) .....**


this indicates all the scale factors of the specified type from
'P' to 'Q'.
'P' and 'Q' must be in the correct range, as defined for 'M'
in the previous section.


**LAYER SCALES, BATCH SCALES   OR   ELEMENT SCALES**


this indicates all the scale factors of the given type.



.. index:: Structure factor calculation control


.. index:: LIST 23


.. _LIST23:

 
=====================================================
Structure factor calculation control list  -  LIST 23
=====================================================




::


    \LIST 23
    MODIFY ANOM= EXTINCT= LAYERSCALE= BATCHSCALE= PARTIAL= UPDATE= ENANTIO=
    MINIMISE NSINGULARITY= F-SQUARED= REFLECTIONS= RESTRAIN=
    REFINE  SPECIAL= UPDATE= TOLERANCE=
    ALLCYCLES MIN-R= MAX-R= *-WR= *-SUMSQ= *-MINFUNC= U[MIN]=
    INTERCYCLE MIN-DR= MAX-DR= *-DWR= *-DSUMSQ= *-DMINFUNC=
    END





::


    \LIST 23
    MODIFY EXTINCTION=YES, ANOMALOUS=YES
    END








This LIST controls the structure factor calculation. The
default calculation involves the minimum of computation (atomic
parameters and overall sale factor).  More extensive calculations have
to be indicated by entries in this list. The presence of a parameter in
the parameter list (LIST 5) does not automatically mean that it will be
included in the structure factor calculation.


This list also controls the treatment of atoms on special positions,
the use of F or Fsq, and the use of restraints.


The presence of information in the DSC file does
not ensure that it will be used by the structure factor
routines. Thus, the operations corresponding to
RESTRAIN ,  ANOMALOUS ,  EXTINCTION ,  PARTIAL ,  BATCHSCALES,
LAYERSCALES and ENANTIO are not performed unless they are explicitly
asked for in a LIST 23.



---------
\\LIST 23
---------

   

**MODIFY ANOM= EXTINCT= LAYERSCALE= BATCHSCALE= PARTIAL= UPDATE= ENANTIO=**



   
   This directive controls modifications that can be applied to Fo
   and Fc.
   

*ANOMALOUS=*


   ::


            NO   -  Default value
            YES
   


   
   If  ANOMALOUS  is  YES , the imaginary part of the anomalous dispersion
   correction, input in LIST 3 (see section :ref:`LIST03`, will be included in 
   the s.f.l.s. calculations.
   For computational efficiency, it is recommended only to use the value YES
   towards the end of a refinement. Note that the value YES should be used
   even for centro-symmetric crystals if they contain a heavy atom.
   

*EXTINCTION=*


   
   ::


            NO   -  Default value
            YES
   


   
   If  EXTINCTION  is  YES , the calculated structure factors are modified
   to allow for the effects of extinction by the method of A. C. Larson.
   See Atomic and Structural Parameters for the definition.
   
   
   

*LAYERSCALES=*


   

*BATCHSCALES=*


   SCALE keys have two alternatives:
   
   ::


            NO   -  Default value
            YES
   


   
   If either SCALE key is  YES , the corresponding scale factors stored in
   LIST 5 (the model parameters) are
   applied to the reflection data. If this parameter is omitted, the
   scale factors are not applied, even if they exist in LIST 5
   

*PARTIAL=*


   
   ::


            NO   -  Default value
            YES
   


   
   If  PARTIAL  is  YES , the fixed partial contributions stored in LIST 6 
   (section :ref:`LIST06`) are
   added in during the calculation of Fc and the phase.
   The partial contributions must already be present in LIST 6, and should
   have the keys  A-PART  and  B-PART . The atoms which have contributed to
   the partial terms should be omitted from LIST 5 whenever  PARTIAL  is
   YES .
   

*UPDATE=*


   
   ::


            NO   -  Default value
            YES
   


   
   If  UPDATE  is  YES , the contributions of the atoms to  A  and  B  are
   output to LIST 6 with the keys  A-PART  and  B-PART . If  UPDATE  is
   NO , its default value, the partial contributions are not changed
   during structure factor calculations.
   This requires that LIST 6 contain the keys A-PART and B-PART.
   

*ENANTIO=*


   ::


            NO   -  Default value
            YES
   


   
   If ENANTIO is YES, then Fc is computed with
   ::


            Fc = SQRT( (1-x)*F(h)**2 + x*F(-h)**2 )
   


   
   Where x is the enantiopole parameter from LIST 5. Once the correct
   enantiomer has been established, set this parameter back to NO.
   

**MINIMISE= NSINGULARITY= F-SQUARED= REFLECTIONS= RESTRAIN=**



   
   This directive controls modifications made to the minimisation
   function during s.f.l.s.
   

*NSINGULARITY=*


   The default value is zero.
   If this parameter is omitted, any singularities  discovered during the
   inversion of the normal matrix will cause the program to
   terminate after the current cycle of refinement.
   If  NSINGULARITY  is greater than zero, it represents the number of
   singularities allowed before the program will terminate.
   

*F-SQUARED=*


   ::


            NO   -  Default value
            YES
   


   
   If F-SQUARED is NO, the traditional minimisation function is:
   ::


            Minimisation function = Sum[ w*(Fo - Fc)**2 ]
   


   
   If  F-SQUARED  is  YES , the minimisation function is:
   ::


            Minimisation function = Sum[ w*(Fo**2 - Fc**2)**2 ]
   


   
   If  F-SQUARED  is  YES , the weights given by  w  in the above expression
   are assumed to be on the correct scale and to refer to Fsq
   rather than Fo's. Note that refinement can be against Fo or Fsq independent of
   whether the input was Fo or Fsq.
   

*REFLECTIONS=*


   REFLECTIONS has two alternatives:
   ::


            NO
            YES  -  Default value
   


   
   If REFLECTIONS is YES, the reflections stored in LIST 6 (and subject to the
   checks in LIST 28) are used for computing structure factors and the
   derivatives added into the matrix if required.

   
   If REFLECTIONS is NO,  LIST 6 is not used, whether it is
   present or not. This setting could be used for refinement against restraints
   only. See the section DLS, 'Distance Least Squares'.
   

*RESTRAIN=*


   RESTRAIN has two alternatives:
   ::


            NO
            YES  -  Default value
   


   
   If  RESTRAIN  is  YES, the restraints in LIST 16 (section :ref:`LIST16`) 
   and LIST 17 (section :ref:`LIST17`)
   are added into the normal equations.
   
   
   

**REFINE  SPECIAL= UPDATE= TOLERANCE=**


   This directive controls the  refinement of atoms on special positions
   and the control of floating origins.
   The default action for atoms is to try to constrain them.
   However, if an atom is already the subject of a user defined constraint,
   the symmetry requirements are imposed by restraints. The site occupancy,
   positional and thermal parameters can be set to satisfy the
   site symmetry. The site occupancy is indepentant of any chemical or
   physical partial occupancy by an atom.

   
   Floating origins are controlled by
   restraining the center of gravity of the structure along the axis to remain
   fixed.
   

*SPECIAL=*


   
   ::


           SPECIAL = NO                  No action
                   = TEST                Displays but does not store any restrictions
                   = ORIGIN              Tests for and restrains floating origins
                   = RESTRAIN            Creates and stores restraints
                   = CONSTRAIN (Default) Attempt to create constraints
   


   
   

*UPDATE=*


   
   ::


            UPDATE = NO                    Nothing updated
                   = OCCUPATION            Site occupancies modified
                   = PARAMETERS  (Default) All adjustable parameters modified
   


   
   

*REWEIGHT=*


   Not currently used
   

*GROUPS=*


   ::


            NO  -  Default value
            YES
   


   
   GROUPS is automatically set to YES if LIST 12
   contains any GROUP directives. It forces the group derivatives
   to be recalculated between each cycle or refinement.
   Not currently used
   
   
   

*COMPOSITE=*


   Not currently used
   
   

*TOLERANCE=*


   Atoms within 'TOLERANCE' Angstrom of a symmetry equivalent atom are
   regarded as being on a special position. The default is 0.6A. For high
   symmetry spacegroups with disorder, the value might need reducing if
   multiplicities are incorrectly calculated.
   
   
   

**ALLCYCLES MIN-R= MAX-R= *-WR= *-SUMSQ= *-MINFUNC= U[MIN]=**


   This directive controls conditions that must be satisfied after
   each cycle if refinement is to continue. It can be used to detect
   converged or 'blown-up' refinements.
   The heading has been abbreviated, the  *  representing  MIN  and  MAX .
   

*MIN-R=, MAX-R=*


   The normal  R-value  must lie between  MIN-R  and  MAX-R, otherwise
   refinement is terminated after
   the current cycle.
   The default values for
   MIN-R  and  MAX-R  are 0.0 and 100.0 percent.
   

*MIN-WR MAX-WR*


   The Hamilton weighted  R-VALUE  must lie between  MIN-WR  and
   MAX-WR, otherwise the refinement is
   terminated after the current cycle.
   The default values for  MIN-WR  and  MAX-WR  are 0.0 and 100.0
   percent respectively.
   

*MIN-SUMSQ=, MAX-SHUMSQ=*


   The rms (shift/e.s.d.) fo all parameters in the refinement must
   lie between  MIN-SUMSQ  and  MAX-SUMSQ, otherwise
   the refinement is terminated after the current cycle.
   The sum of the squares of the ratios is defined as :
   ::


            SUMSQ = SQRT(SIGMA(SHIFT/ESD))/N)
        The default values
       of  MIN-SUMSQ  and  MAX-SUMSQ  are 0.03 and 10000.0, .
   



*MIN-MINFUNC= MAX-MINFUNC=*


   The minimisation function, on the scale of Fo, must lie between
   MIN-MINFUNC  and  MAX-MINFUNC, otherwise
   the refinement is terminated after the current cycle.
   The default values of  MIN-MINFUNC  and  MAX-MINFUNC  are 0.0 and
   1000000000000000.0.
   

*U[MIN]=*


   If Uiso or a principal component of the adp of any atom is
   less than   U[MIN] , then a warning is issued and the idp
   reset to u[min], or the components of the adp reset to MAX(Uii,U[MIN])
   or MAX(Uij,0.01U[min]).
   If this parameter
   is omitted, a default value of 0.0 is assumed.
   

**INTERCYCLE MIN-DR= MAX-DR= *-DWR= *-DSHIFT/ESD= *-DMINFUNC=**



   
   This directive refers to conditions that must be obeyed before the
   next cycle of least squares refinement can proceed. (A quantity
   undergoes a positive change if  OLD - NEW  is positive, not
   NEW - OLD ). The definitions are similar to ALLCYCLES.
   The abbreviation  '*'  represents  MIN  and  MAX .
   

*MIN-DR= MAX-DR=*


   Between two cycles of least squares, the change in
   R-VALUE  must lie between  MIN-DR  and  MAX-DR, otherwise
   the refinement is terminated.
   The default values are -5.0 and 100.0.
   

*MIN-DWR MAX-DWR*


   The default values are -5.0 and 100.0.
   

*MIN-DSUMSQ MAX-DSUMSQ*


   The default values are -10. and 10000.0.
   

*MIN-DMINFUNC MAX-DMINFUNC*


   The default values are 0.0 and 1000000000000000.0.
   
   

==============================
Printing the SLFS control list
==============================




----------
\\PRINT 23
----------


   
   This prints LIST 23. There is no command for punching LIST 23.
   
   
   
.. index:: Special position constraints


.. _SPECIAL:

 
========================================
Special position constraints - \\SPECIAL
========================================




::


    \SPECIAL  ACTION= UPDATE= TOLERANCE=
    END
   
    \SPECIAL
    END






\\SPECIAL can be issued at any time to get information about atoms on
special positions. However, normally it is called automatically by
setting the SPECIAL keyword in LIST 23 (section :ref:`LIST23`).


Atoms on special positions may be constrained through LIST 12
(section :ref:`LIST12`), or restrained through LIST 17 (section :ref:`LIST17`).
CRYSTALS  will attempt to generate the special position conditions when
requested via the
SPECIAL command, and also  update coordinates of atoms on
special positions.


If the RESTRAIN option is chosen, then the special conditions are imposed
on the refinement by restraints, which are generated without reference to
what is being specified in LIST 12, the refined parameter definition list.


If the CONSTRAIN option is chosen, then CRYSTALS examines the site
restrictions as it processes LIST 12. If an atom on a special position is
being refined without any user defined conditions (EQUIVALENCE, RIDE, LINK,
COMBINE, GROUP, WEIGHT), and the related coordinates are in the same matrix
block, then the internal representation of LIST 12 (LIST 22)
is dynamically modified to include the necessary
constraints. If the atom is already the
object of a constraint,
then LIST 12 cannot safely be modified, and the special condition
is applied as a restraint. In either case, CRYSTALS warns the user about
what is being done.


The origins of polar space groups are always fixed by restraints, since this
produces a better conditioned matrix than one from just fixing atomic
coordinates.


The UPDATE directive controls whether parameters of atoms near special
positions will be modified to make them exact. The routine will update
just the site occupancies, or the occupancies and the other variable
parameters. The crystallographic site occupancy is held temporarily in the
key SPARE, leaving the key OCC available for a refinable chemical
occupancy. Take care if an atom refines onto (or off) a special position.


The function SPECIAL is actioned automatically for every round of least
squares refinement. Its action is then determined by values held in LIST 23 
(structure factor control, see section :ref:`LIST23`)

-------------------------------------
\\SPECIAL  ACTION= UPDATE= TOLERANCE=
-------------------------------------

   

*ACTION*


   
   ::


            ACTION = NONE      No action
                   = TEST      Displays but does not store any restrictions
                   = ORIGIN    Tests for and restrains floating origins
                   = RESTRAIN  Creates and store a LIST 17
                   = CONSTRAIN Attempt to create constraints.
                   = LIST23    (Default) Takes the action defined in LIST 23
   


   
   

*UPDATE*


   
   ::


            UPDATE = NONE        Nothing updated
                   = OCCUPATION  Site occupancies modified
                   = PARAMETERS  All adjustable parameters modified
                   = LIST23      (Default) Takes action defined in LIST 23
   


   
   

*TOLERANCE*



   
   TOLERANCE is the maximum separation, in Angstrom, between nominally
   equivalent sites. The default is 0.6A.

=========================================
Printing the special position information
=========================================



Force the atom parameter list (LIST 5) to be updated and send it to
the PCH file.
::


         \SPECIAL TEST PARAMETER
         END
         \PUNCH 5  (to get a listing with 5 decimal places)
         END





.. index:: LIST 12


.. index:: Refinement directives


.. _LIST12:

 
=================================
Refinement directives  -  LIST 12
=================================





This list defines the parameters to be refined in the
least squares calculation, and
specifies relationships between those parameters.

::


    \LIST 12
    BLOCK  PARAMETERS ...
    FIX  PARAMETERS ...
    EQUIVALENCE  PARAMETERS ...
    RIDE  ATOM_PARAMETER SPECIFICATIONS ...
    LINK PARAMETER_LIST AND PARAMETER_LIST AND PARAMETER_LIST.
    COMBINE PARAMETERS_LIST AND PARAMETERS_LIST
    GROUP  ATOM SPECIFICATIONS
    WEIGHT F1 PARAMETERS F2 PARAMETERS ...
    FULL  PARAMETERS
    DIAGONAL  PARAMETERS
    PLUS  PARAMETERS
    SUMFIX PARAMETERS
    REM text
    END





::


    \LIST 12
    BLOCK SCALE X'S U'S
    END





---------
\\LIST 12
---------

   

**BLOCK  PARAMETERS**


   This directive defines the start of a new matrix
   block.
   Any parameters that come on this directive and any directives until another BLOCK
   directive are put into the same matrix block. If only one BLOCK directive is
   given, then the refinement is 'full matrix'.
   

**FIX  PARAMETERS**


   The specified parameters are not to be refined.
   

**EQUIVALENCE  PARAMETERS**


   Sets the given parameters to a single least squares parameter (see the
   examples).
   

**RIDE  ATOM_PARAMETER SPECIFICATIONS**


   This directive links corresponding parameters for all the atoms
   specified on the directive.
   The parameters specified for the first atom given on this directive
   are each assigned to individual least squares parameters, and
   parameters for subsequent atoms are EQUIVALENCED,
   in the order given, to the corresponding least squares parameter.
   Only explicit atom parameters can be used on this directive. Usually, the same
   parameter keys will be given in the same order for all atoms referenced,
   though this may not be true for high symmetry space groups.
   

**LINK PARAMETER_LIST AND PARAMETER_LIST ( AND PARAMETER_LIST.)**


   Links the parameters defined after the AND with those specified in the
   first parameter list. A least squares parameter is assigned to each
   physical parameter in the first list. Physical parameters specified in the
   second (and subsequent if present) lists are then assigned IN THE ORDER
   GIVEN to these least squares parameters. There must be the same number
   of parameters in each parameter list. The parameter list may contain
   more than one atom, and is terminated by the 'AND' or the end of the
   directive.  Overall and implicit parameters may  be given.
   

**COMBINE PARAMETERS_1 AND PARAMETERS_2**


   Combines the parameters defined before the AND with those defined after.
   Physical parameters are taken pairwise in the order given
   from parameter list 1 and 2 and two least-squares parameters defined such
   that one is the sum and the other is the difference of the physical
   parameters.
   
   ::


            x' = x1 + x2
            x" = x1 - x2
                              where x1 and x2 are physical parameters,
                                and x' and x" are least squares parameters.
   


   
   Such a re-parameterisation is useful for dealing with certain sorts of ill-
   conditioning, such as that due to pseudo-symmetry,
   of the normal matrix (see Edward Prince, Mathematical Techniques in
   Crystallography and Material Science, 1982, Springer-Verlag, page 113).
   NOTE that only one AND can be given.
   

**GROUP  ATOM SPECIFICATIONS**


   The positional coordinates of the
   atoms given in the ATOM SPECIFICATIONS are refined as a rigid group.
   Parameter specifications MUST NOT be included. The first atom specified
   is taken as the pivot atom of the group. All atoms in the group may be
   the subject of restraints to atoms in other parts of the structure, or in
   other groups. Use LINK, RIDE or EQUIVALENCE to build a suitable model
   for the temperature factors.

   
   Because of the linearisation algorithm used, some distortion of the group
   will occur if there are large parameter shifts. Use REGULARISE to re-form it.
   

**WEIGHT w1 PARAMETERS w2 PARAMETERS . .**


   Before the contributions of the specified parameters
   are included in the normal equations, they are
   multiplied by the number wI .  Similarly ,
   when the normal equations are solved, the shifts
   and e.s.d.'s are multiplied by the same wI.
   The default  value of wI is 1.0.
   The parameters are multiplied by the value of
   wI that precedes them (see the examples).

==============================
Obsolete Refinement directives
==============================



The following directives may be removed in some future release.


**FULL  PARAMETERS**


The parameters on the directive directive plus
any other parameters defined on subsequent directives
are to be included in a full matrix refinement.
The scale factor is automatically included, while
the dummy overall isotropic temperature factor
is fixed. This is equivalent to:


BLOCK SCALE PARAMETERS




**PLUS  PARAMETERS**


The specified parameters are to be refined, and
they will be placed in the current block of
the normal matrix. This is equivalent to:


CONTINUE PARAMETERS after the BLOCK directive.




**DIAGONAL  PARAMETERS**


All the specified parameters in the LIST 12 are
included in a block diagonal approximation to
the full matrix, based on one block for each atom.
Both the SCALE FACTOR and the DUMMY OVERALL ISOTROPIC
TEMPERATURE FACTOR are automatically included.




**SUMFIX PARAMETERS [ AND PARAMETERS ] [ AND PARAMETERS ]...**


Constrains the sum of the specified parameters (or groups of parameters) to
be constant.
If no AND is given, then sum of the parameters specified is constrained, by
making the total of the shifts add to zero. If AND is given then the total of
the shifts for each group add to zero, and each group is equivalenced to a
single least squares parameter.
E.g. constrain sum of three occupancies to be constant.

::


         \LIST 12
         BLOCK SCALE X'S
         SUMFIX Fe(1,OCC) Al(1,OCC) Si(1,OCC)
         END




E.g. constrain sum of three disordered parts to be constant.

::


         \LIST 12
         BLOCK SCALE X'S
         SUMFIX PART(1001,OCC) AND PART(1002,OCC) AND PART(1003,OCC)
         END





=================================
Defining the least squares matrix
=================================



Parameters may be referred to either *implicitly,* by just giving the
parameter name (in which case that parameter is referenced for all
atoms), or *explicitly* by specifying the parameter for an atom
or group of atoms. All implicit specifications ignore H atoms.

::


    e.g.
         IMPLICIT: x, u's
         EXPLICIT C(1,X), O(1,U'S) UNTIL O(14)






A parameter may not be referenced more than once either explicitly or
implicitly. A parameter *may* be referenced both implicitly and
explicitly, in which case the explicit reference takes precedence.

::


    e.g.
         BLOCK x's            (implicit reference)
         FIX Pb(1,y)          (explicit reference)
                     This establishes the refinement of z,y,z for all atoms
                     except Pb(1), for which only x and z are refined.





::


    EXAMPLES :
         1. BLOCK SCALE X
            FIX C(1,X)     ALLOWED
         2. BLOCK SCALE  X
            FIX X          NOT ALLOWED






The refinement directives are read and
stored on the disc.
Before the structure factor least squares routines
can use the information in LIST 12 (constraint directives), it is validated against 
LIST 5 (the model parameters) and stored
symbolically as a LIST 22.
This is done automatically by the SFLS routines (section :ref:`SFLS`), but
the user can force the verification of LIST 12 by issuing the command
\\LIST 22.

===================
Printing of LIST 12
===================



LIST 12 may be listed with either

----------
\\PRINT 12
----------

   or

------------
\\SUMMARY 12
------------


   
   LIST 12 may be punched with

----------
\\PUNCH 12
----------

   
   

========================
Creating a null LIST 12 
========================



A null LIST 12, containing no refinement directives, may be created with

----------
\\CLEAR 12
----------

   
   

=====================
Processing of LIST 12
=====================



LIST 12 is processed to greate a LIST 22 with

---------
\\LIST 22
---------

   
   ::


       Examples.
       1. Full matrix isotropic refinement of a structure without H atoms
      
            \LIST 12
            BLOCK SCALE X'S U[ISO]
            END
      
       2. Full matrix anisotropic of a structure with C(25) as the last
       non-hydrogen, not refining the H atoms.
      
            \LIST 12
            BLOCK SCALE FIRST(X'S,U'S) UNTIL C(25)
            END
      
       3. Refine all positions, aniso non-H, iso H atoms
      
            \LIST 12
            BLOCK SCALE X'S
            CONTINUE FIRST(U'S) UNTIL C(25)
            CONTINUE H(1,U[ISO]) UNTIL LAST
            END
      
       4. Ride H(1) positions on C(21) positions, etc. There are 2 H on C(25)
      
            \LIST 12
            BLOCK SCALE X'S
            CONTINUE FIRST(U'S) UNTIL C(25)
            CONTINUE H(1,U[ISO]) UNTIL LAST
            RIDE C(21,X'S) H(1,X'S)
            RIDE C(22,X'S) H(2,X'S)
            RIDE C(23,X'S) H(3,X'S)
            RIDE C(24,X'S) H(4,X'S)
            RIDE C(25,X'S) H(51,X'S) H(52,X'S)
            END
      
       5. A fragment is distributed over 2 sites. The fragments are
       C(100) C(101) O(102) C(103) and C(200) C(201) O(202) C(203)
      
            \LIST 12
            BLOCK SCALE X'S
            ... ...
            EQUIVALENCE C(100,OCC) UNTIL C(103) C(200,OCC) UNTIL C(203)
            WEIGHT -1 C(200,OCC) UNTIL C(203)
            END
      
   


   
   
.. index:: LIST 16

   
.. index:: Restraint directives


.. _LIST16:

 
======================
Restraints  -  LIST 16
======================





This list defines the restraint to be used as supplemental
observations.

::


    \LIST 16
    DISTANCES  VALUE, E.S.D= BOND1, BOND2
    A-DISTANCES  VALUE, E.S.D= BOND1, BOND2
    DISTANCES  VALUE, E.S.D= MEAN BOND1, BOND2
    DISTANCES  VALUE, E.S.D= DIFFERENCE BOND1, BOND2
    NONBONDED  VALUE, POWERFACTOR=  BOND1, BOND2
    ANGLES     VALUE, E.S.D= ANGLE1, ANGLE2
    ANGLES     VALUE, E.S.D= MEAN ANGLE1, ANGLE2
    ANGLES     VALUE, E.S.D= DIFFERENCE ANGLE1, ANGLE2
    VIBRATIONS VALUE, E.S.D= BOND1, BOND2
    U(IJ)'S    VALUE, E.S.D= BOND1, BOND2
    A-VIBRATIONS VALUE, E.S.D= BOND1, BOND2
    A-U(IJ)'S    VALUE, E.S.D= BOND1, BOND2
    UTLS              E.S.D. [ m ] ATOM1 [ ATOM2 ] ...
    UEQIV             E.S.D. ATOM1 [ ATOM2 ] ...
    UVOL              E.S.D. ATOM1 [ ATOM2 ] ...
    UQISO             E.S.D. ATOM1 [ ATOM2 ] ...
    UEIG              E.S.D. ATOM1 [ ATOM2 ] ...
    UALIGN            E.S.D. ATOM1 [ ATOM2 ] ...
    URIGU             E.S.D. ATOM1 TO ATOM2 [, ATOM3 TO ATOM4 ] ...
    UPERP             E.S.D. ATOM1 TO ATOM2 [ TO ATOM3 ] [, ATOM4 TO ATOM5 [ TO ATOM6 ] ] ...
    UPLANE            E.S.D. ATOM1 TO ATOM2 TO ATOM3 [, ATOM4 TO ATOM5 TO ATOM6 ] ...
    ULIJ              E.S.D. ATOM1 TO ATOM2 TO ATOM3 [, ATOM4 TO ATOM5 TO ATOM6 ] ...
    PLANAR            E.S.D  FOR 'ATOM SPECIFICATIONS'
    LIMIT             E.S.D  FOR 'PARAMETER SPECIFICATIONS'
    ORIGIN            E.S.D  FOR 'PARAMETER SPECIFICATIONS'
    SUM               E.S.D  FOR 'PARAMETER SPECIFICATIONS'
    AVERAGE           E.S.D  FOR 'PARAMETER SPECIFICATIONS'
    SAME       BOND-ESD ANGLE-ESD FOR GROUP-1 AND GROUP-2 AND ...       
    DELU       ADP-ESD  GROUP-1 (AND GROUP-2 AND ...)       
    SIMU       ADP-ESD  GROUP-1 (AND GROUP-2 AND ...)       
    RESTRAIN   VALUE, E.S.D= TEXT
    DEFINE NAME = TEXT
    COMPILER
    EXECUTION
    END





::


    \LIST 16
    DIST  1.39 , .01 =      C(1) to C(2), C(2) to C(3), C(3) to C(4)
    DIST  0.0  , .01 = MEAN C(1) to C(2), C(2) to C(3), C(3) to C(4)
    VIBR  0.0  , .01 =      C(1) to C(2), C(2) to C(3), C(3) to C(4)
    U(IJ) 0.0  , .02 =      C(1) to C(2), C(2) to C(3), C(3) to C(4)
    PLANAR                  C(1) until C(6)
    SUM                     K(1,OCC), K(2,OCC) K(3,OCC)
    SUM                     ELEMENT SCALES  (twin element scale factors)
    LIMIT                   U[11] U[22] U[33]
    END






The restraints that can be applied under this system are of a type
originally described by J. Waser, Acta Cryst. 1963, 16, 1091.
A good summary of the present facilities and aims is provided
by J.S. Rollett in Crystallographic Computing, p170.


In this method of restraints, the user provides  a set of
physical or chemical restraints that are to be applied to the
proposed model.
These restraints are usually based upon observations of similar
compounds (for example, bond lengths or bond angles) or upon
known physical laws (for example, the difference in mean square displacement
of two atoms along the bond that joins them).
These restraints are not
rigidly applied to the model, but each restraint has
associated with it an e.s.d., which is used to calculate a weight
so that the restraint can then be added into the normal
equations.
(The e.s.d.'s are provided on an absolute scale, and rescaled by the
program onto the same scale as the xray data).
In this way, the importance of the restraints, which are
treated as extra observations, can be varied with respect to the
importance of the X-ray data.
If the structure is required to adhere closely to the proposed
model, the restraints are given high weights (i.e. small e.s.d.'s)
otherwise they can be given smaller weights.


If, at the end of a refinement, the restraints are not compatible with
the Xray data, this is shown by a discrepancy
between the requested value for the restraint, and that computed from
the refine parameters.
If this is found, the validity of the restraints that have been imposed
should be carefully checked.


In order that the restraint routines should be completely general,
each atom that is part of a restraint can be modified by a set of
symmetry operators before the restraint is applied.
(This is vital for molecules that lie across a symmetry element,
as all the atoms that constitute the molecule are not present
in LIST 5).


If a structure uses symmetry related atoms to form bonds, the
command \\DISTANCE with OUTPUT PUNCH=RESTRAIN can be used to set up a
proforma restraints list, including symmetry codes.
The distances and e.s.ds
will have to be edited to the correct target values. Use appropriate values
on the SELECT, INCLUDE and EXCLUDE directives for DISTANCE to
tailor the generated list.


Note that restraints may be used without
diffraction data, see the chapter 'Distance Least Squares' for examples.


**NOTE**


The restraint directives are read and
stored on the disc.
Before the structure factor least squares routines
can use the information in LIST 16 (restraints), it is validated against LIST 5
(the model parameters) and stored symbolically as a LIST 26 (see :ref:`LIST26`).
This is done automatically by the SFLS routines (section :ref:`SFLS`), but
the user can force the verification of LIST 16 by issuing the command
\\CHECK (see later).

==============================================
Parameter, atom, bond and angle specifications
==============================================



Composite parameter specifications are not permitted ( *e.g.* U's), atom
specifications are as in Chapter 4.


Two atoms that are bonded together are defined in the following
way :
::


         atom1 to atom2,




'atom1'  and  'atom2'  are standard atom specifications as described
in chapter 4, and are separated from any other text on the line by
at least one space. If there is more than one bond specification on  a
line, it may be separated from another by either a space or a comma.
The 'TO'  is mandatory, and is terminated by
one or more spaces.


The definition of an angle is an extension of the definition
of a bond:
::


         atom1 to atom2 to atom3,




The angle is defined as the angle subtended at  atom2  by  atom1
and  atom3.
The restraints routines apply all the required symmetry if specified in
an atom definition, while still
conserving the partial derivatives in their correct form.

---------
\\LIST 16
---------

   The restraints routines regard all
   continuation directives as part of the original
   directive, so that the column of a
   character on a continuation directive will
   have had '80*n' added to it, where 'n' is
   the number of directives between the current
   continuation directive and the start of
   the directive. The ',', '=' signs and separator 'MEAN' are mandatory
   if shown in  the definition.
   

**DISTANCES  VALUE, E.S.D. = BOND1, BOND2, . . . . .**


   The bonds specified after the '=' sign are
   restrained to have a length of 'VALUE', with
   an e.s.d. of 'E.S.D.'.
   

**A-DISTANCES  VALUE, E.S.D. = BOND1, BOND2, . . . . .**


   Asymmetric distance restraint. The second atom in the bond is 
   restrained to be the given distance from the first, which is unrestrained.

   
   Note that the qualifiers MEAN and DIFFERENCE cannot be used in this 
   context.
   

**DISTANCES VALUE, E.S.D. = MEAN BOND1, BOND2, . . . .**


   Initially the restraints routines calculate the
   'MEAN' value of all the bonds specified by
   the directive. Each of the bonds
   specified is then restrained to be
   equal to 'MEAN' + 'VALUE', with an e.s.d. of
   'E.S.D.'. The 'DELTA' used in the
   right hand sides of the normal equations is
   defined by :
   ::


            DELTA = MEAN + VALUE - BOND CALCULATED.
   


   
   

**DISTANCES VALUE, E.S.D. = DIFFERENCE BOND1, BOND2, . .**


   Each of the bonds in this directive is restrained 
   to be equal to 'VALUE'
   plus the length of each of the bonds that
   follow it.
   The computed value of 'DELTA' used in
   the right hand sides of the normal
   equations is thus given by :
   ::


            DELTA = VALUE + BOND(N) - BOND(M)
   


   
   Where BOND(N) occurs after BOND(M) in
   the directive.

   
   Each such restraint is added into the
   normal equations with an e.s.d. Of  E.S.D. .
   However, as each bond is restrained to each
   of the bonds that follow it,  (N*(N-1))/2
   separate restraints are generated.
   Many of these restraints involve the same
   bond lengths and are thus not independent.
   To be strictly accurate, a non-diagonal
   weight matrix should be used with this
   restraint but such a facility
   is not available.

   
   The letters  DIFFERENCE  are terminated
   by one or more spaces and may be abbreviated to
   DIFF.
   

**NONBONDED  VALUE, POWERFACTOR =, BOND1, BOND2, . . . . .**


   This restraint is similar to the 'DISTANCE' restraint in that the pairs of
   atoms defining the bond are restrained to be at the 'VALUE' distance appart.
   However, the weight to be given to the restraint is computed from the
   difference between the observed and the requested contact distance using the
   expression:
   
   ::


             weight = 10000*(requested/observed)**(powerfactor*12)
   


   

   
   When the observed equals the requested distance,
   the weight corresponds to an e.s.d.
   of .01. If the requested is less than the observed, the weight is reduced
   slowly as a function of the discrepancy. If the requested is greater than the
   observed, the weight rises rapidly with discrepancy. The function is like the
   repulsive part of a 6-12 energy expression, having greatest effect on
   anomalously short contacts. Powerfactors of between 1 and 4 seem to be
   suitable.
   
   
   

**ANGLES VALUE, E.S.D. = ANGLE1, ANGLE2, . . . .**


   Each of the angles given in the directive 
   is restrained to a value of 'VALUE',
   with an e.s.d. of 'E.S.D.'. The angles must
   be in degrees.
   

**ANGLES VALUE, E.S.D. = MEAN ANGLE1, ANGLE2, . . . . .**


   This is the analagous to the MEAN distance restaint,
   except that the mean value is computed for
   the specified angles and each of the angles
   is then restrained to 'MEAN' + 'VALUE',
   with an e.s.d. of 'E.S.D.'.
   The 'DELTA' values and the syntax rules are all the
   same as for the equivalent distance restraint.
   

**ANGLES VALUE, E.S.D. = DIFFERENCE ANGLE1, ANGLE2, . .**


   This restraint is analogous to the
   DIFFERENCE restraint  for bond lengths.
   Each of the angles in the directive is
   restrained to be equal to 'VALUE' plus each of
   the angles after it in the input.
   Although each such restraint is applied with
   an e.s.d. of 'E.S.D.', the same reservations about
   the validity of the weighting scheme exist
   here as for the equivalent distance restraint.
   

**VIBRATIONS VALUE, E.S.D. = BOND1, BOND2, . . . .**


   The difference in mean square displacement
   along the bond direction
   of the two atoms that form the bond is
   restrained to be 'VALUE', with an e.s.d. of
   'E.S.D.'. In general, 'VALUE' is assumed to be
   zero, while the e.s.d. reflects the maximum
   discrepancy  in m.s.d. that would be expected for
   the type of bond being considered.
   If either or both of the given atoms is
   isotropic, the program will convert the m.s.d.
   into the appropriate form and calculate the
   derivatives for the isotropic atom correctly.

   
   Note that the atoms defining a 'bond' need not actually be bonded, but
   merely serve to define a direction. For really bonded atoms, try an esd
   of  .002; for 1-3 atoms or diagonals of phenyl groups, try .005.
   

**A-VIBRATIONS VALUE, E.S.D. = BOND1, BOND2, . . . .**


   Asymmetric vibration restraint. The second atom in the bond is 
   restrained to be similar to the first, which is unrestrained.
   

**U(IJ)'S VALUE, E.S.D. =, BOND1, BOND2, . . . .**


   This is a similarity restraint, and may be used to ensure that the
   vibration parameters of adjacent atoms are similar, as must be the case
   even for flexible systems. The esd used must be softer than for a
   VIBRATION restraint, typically 0.01.
   In this restraint, the difference
   between corresponding u(ii) and u(ij) terms
   is restrained to be 'VALUE', with an
   e.s.d. of 'E.S.D.'.
   Each bond that is specified generates therefore
   six separate restraints, one for each of
   the anisotropic temperature parameters. If
   an atom with an isotropic temperature factor
   is included in this restraint, the specified bond
   and all six restraints are ignored.
   

**A-U(IJ)'S VALUE, E.S.D. =, BOND1, BOND2, . . . .**


   
   Asymmetric Uij restraint. The second atom in the bond is 
   restrained to be similar to the first, which is unrestrained.
   

**PLANAR E.S.D. FOR 'ATOM SPECIFICATIONS'**


   This directive instructs the system to compute the mean plane
   through the atoms given in the atom specifications,
   and then to restrain each of the atoms to lie in the plane.
   The 'E.S.D.' with which each atom is restrained to be on
   the plane is given in angstrom.
   This parameter is optional and has a default value of 0.01.
   'FOR' is optional.
   'ATOM SPECIFICATIONS' define the atoms that are on the plane.
   Each 'ATOM SPECIFICATIONS' may consist of one atom, together
   with symmetry data, or two atoms separated by 'UNTIL'.
   One or more specifications must be given.
   
   ::


            Examples :
             PLANAR C(1,2) UNTIL C(6) C(9) C(10,2,2)
             PLANAR 0.05 C(1) C(2) UNTIL C(6)
             PLANAR 0.05 FOR C(1) C(2) UNTIL C(6)
             PLANAR FOR C(1,2) UNTIL C(6)
   


   
   

**LIMIT E.S.D. FOR 'PARAMETER SPECIFICATIONS'**


   This restraint seta a target shift of zero for the specified
   parameters, with the specified esd, and thus tries to limit the shift
   in the parameters.
   Since it modifies the normal matrix, it does not have the same effect as
   partial shifts (SHIFT,MAXIMUM,and FORCE in SFLS [section :ref:`SFLS`]). 
   In particular, the
   e.s.d. on the parameter will depend upon the E.S.D. given to this restraint.
   The default for E.S.D. is .001. Reducing this to about .00001 will have almost
   the same effect as FIX in LIST 12. Increasing it to 10.0  will cause the
   restraint to have almost no effect unless the parameter involved is almost
   singular with respect to some other parameter. Note that this is only a
   restraint, and if the medel and X-ray data are good, the specified parameters
   will still shift. This restraint is valuable during the development of
   a poor starting model.
   
   
   

**ORIGIN E.S.D. FOR 'PARAMETER SPECIFICATIONS'**


   This is used  for polar space groups,
   where the singularity up the polar axis may be removed by  holding
   the electron weighted sum of all the coordinates up that axis constant.
   
   ::


            Example
             ORIGIN Y
   


   
   

**SUM E.S.D. FOR 'PARAMETER SPECIFICATIONS'**


   This restraint holds the sum of the parameters on the directive constant
   during the refinement.
   A typical case is where several (more than 2, which are better
   treated with EQUIVALENCE, in LIST 12) atoms share a site.
   'E.S.D.' is the e.s.d. with which the sum of the parameters is
   held constant.
   This is an optional parameter and has a default value of 0.0001.
   'FOR' is optional.
   'PARAMETER SPECIFICATIONS' define the parameters that are to be
   summed. They may be given as :
   
   ::


             overall parameters e.g. SCALE,
             all atomic parameters of one type e.g. X, Y, U[11],
             atomic parameters of one type for a group of atoms
                   e.g. NA(1,OCC) UNTIL RB(6),
   


   
   
   ::


            Examples :
             SUM 0.0001 NA(1,OCC) UNTIL RB(6)
             SUM LAYER SCALES
   


   
   

**AVERAGE E.S.D. FOR 'PARAMETER SPECIFICATIONS'**


   For this directive, the system computes the mean of the given
   parameters,
   and then restrains each to have the mean value
   with an e.s.d. of 'E.S.D.'.
   The parameters are as for the 'SUM' directive above.
   
   
   
   
   

**SAME BOND-ESD ANGLE-ESD FOR GROUP-1 AND GROUP-2 AND ...**


   The first group on the card is the 'target' - 
   all following groups are mapped onto it (in order specified) and the distances and
   angles restrained - using the connectivity of the first group.
   
   
   The first two arguments are the e.s.d for bond length restraints and the e.s.d
   for angle restraints. Groups are seperated by the word 'AND'.
   NOTE the absence of the usual '=' sign.
   I.E:
   ::


       SAME 0.01, 0.1 FOR RESI(1) AND RESI(2)
       SAME  PART(1001) PART(1002)
   


   
   maps all atoms in the first argument onto all the atoms in 
   the second argument.

   
   TAKE CARE
   Although this shorthand is appealing, the order of the atoms in LIST 
   5 must be identical in both arguments, although the atoms do not have 
   to be adjacent.
   ::


       SAME 0.01 , 0.1 
       CONT C(17)  C(18)  H(183) H(182) H(181) AND
       CONT C(17)  C(18)  H(182) H(181) H(183)
         imposes 3-fold symmetry on a single methyl group.
      
       SAME 0.01 , 0.1 
       CONT C(17)  C(18)  H(183) H(182) H(181) AND
       CONT C(17)  C(19)  H(193) H(192) H(191) AND
       CONT C(8)   C(9)   H(93)  H(92)  H(91) AND
       CONT C(8)   C(10)  H(103) H(102) H(101) AND
       CONT C(14)  C(15)  H(153) H(152) H(151) AND
       CONT C(14)  C(16)  H(163) H(162) H(161)
         restrains six methyl groups to have the same geometry as each
         other. Combining the last two restraints would make all the
         methyls have 3 fold symmetry, and all be the same.
   


   

   
   Errors are generated if
   1) the size of any of the groups on the SAME card is not the
   same as the first group.
   2) the element type in a group does not match the corresponding
   element type in the first group.
   
   
   Warnings are printed if there are zero bonds to any of the atoms
   in the first group.
   
   
   The comma separating the e.s.d arguments, and the 'FOR' separating the
   e.s.d.s from the atom specifications are optional.
   The second e.s.d is optional, the default is 0.1 degrees.
   The first e.s.d is optional unless you wish to specify the second, the
   default is 0.01 Angstroms.
   
   
   List 41 (bonds) is loaded by the restraint generating routine, if it
   does not exist an error will occur. (By default L41 is kept up to date
   with the current model.)
   
   
   
   
   

**DELU ADP-ESD  FOR GROUP-1 (AND GROUP-2 AND ...)**


   The adps of all pairs of bonded atoms in each group are restrained
   to be equal in the direction of the bond.  Unlike SAME, a single
   group can be given.  The RESIDUES are NOT restrained to be similar.
   
   
   The first argument is the e.s.d for adp-restraint,  
   I.E:
   ::


       DELU 0.01  FOR RESI(1) AND RESI(2)
   


   

   
   Errors are generated if
   1) the size of any of the groups on the DELU card is not the
   same as the first group.
   2) the element type in a group does not match the corresponding
   element type in the first group.
   
   
   Warnings are printed if there are zero bonds to any of the atoms
   in the first group.
   
   
   The  'FOR' separating the
   e.s.d.s from the atom specifications is optional.
   The e.s.d is optional, the  default is 0.01 Angstroms.
   
   
   List 41 (bonds) is loaded by the restraint generating routine, if it
   does not exist an error will occur. (By default L41 is kept up to date
   with the current model.)
   
   
   
   
   

**SIMU ADP-ESD  FOR GROUP-1 (AND GROUP-2 AND ...)**


   Restrains equivalent elements of the  adps of all pairs on bonded atoms 
   in each residue. The RESIDUES are NOT restrained to be similar. Unlike
   SAME, a single group can be given
   
   
   The first argument is the e.s.d for adp-restraint.
   I.E:
   ::


       SIMU 0.04  FOR RESI(1) AND RESI(2)
   


   

   
   Errors are generated if
   1) the size of any of the groups on the DELU card is not the
   same as the first group.
   2) the element type in a group does not match the corresponding
   element type in the first group.
   
   
   Warnings are printed if there are zero bonds to any of the atoms
   in the first group.
   
   
   The  'FOR' separating the
   e.s.d.s from the atom specifications is optional.
   The e.s.d is optional, the  default is 0.04 Angstroms.
   
   
   List 41 (bonds) is loaded by the restraint generating routine, if it
   does not exist an error will occur. (By default L41 is kept up to date
   with the current model.)
   
   
   
   
   

**UTLS              E.S.D. [ m ] ATOM1 [ ATOM2 ] ...**


   Restrain ADPs of all or the m first atoms listed to calculated ADPs derived 
   from a TLS model from all the atom list.
   ::


       UTLS 0.01 3 F(1) F(2) F(3) C(1) C(2)
   


   

   
   A TLS model is generated using F(1), F(2), F(3), C(1) and C(2). This model 
   is then used to calculate theoritical ADPs. These ADPs are then used as targets
   for the restraints on atoms F(1), F(2) and F(3) with an e.s.d. of 0.01.
   
   
   
   
   

**UEQIV             E.S.D. ATOM1 [ ATOM2 ] ...**


   Restrain Ueqiv of the ADPs of all the atom listed to be equal
   ::


       UEQIV 0.01 F(1) F(2) F(3)
   


   

   
   Ueq is the arthmetic mean of the principal axes of an ADP. 
   the current Ueq is calculated for each atom and an average calculated.
   If an atom is non positive definite, its Ueq is not used for the calculation of the mean
   but the atom is included in the restraint. Ueq of each atom is then restrained to
   the average.
   
   
   
   
   

**UVOL              E.S.D. ATOM1 [ ATOM2 ] ...**


   Restrain Ugeom of the ADPs of all the atom listed to be equal
   ::


       UVOL 0.01 F(1) F(2) F(3)
   


   

   
   Ugeom is the geometric mean of the principal axes of an ADP. 
   the current Ugeom is calculated for each atom and an average calculated.
   If an atom is non positive definite, the atom is excluded from the restraint. 
   Ugeom of each atom is then restrained to the average.
   
   
   
   
   

**UQISO             E.S.D. ATOM1 [ ATOM2 ] ...**


   Restrain each atom listed to be isotropic
   ::


       UQISO 0.01 F(1) F(2) F(3)
   


   

   
   The length of the principal component of each atom are restrained to its average.
   Each atom is treated independantly.
   
   
   
   
   

**UEIG              E.S.D. ATOM1 [ ATOM2 ] ...**

 
   Restrain each atom listed to be spheroid (2 smallest principle axes to be equal)
   ::


       UEIG 0.01 F(1) F(2) F(3)
   


   

   
   The length of the two smallest principal component of each atom are restrained to its average.
   Each atom is treated independantly and the third principal component is free.
   
   
   
   
   

**UALIGN            E.S.D. ATOM1 [ ATOM2 ] ...**


   Restrain the ADPs of all the atom listed to be aligned to their average direction
   ::


       UALIGN 0.01 F(1) F(2) F(3)
   


   

   
   The matrix of eigenvectors is calculated for each ADP and an average calculated.
   If an atom is non positive definite, the atom is excluded from average but keep for the restraint. 
   Each matrix of eigenvectors is then restrained to the average. The eigenvalues remain free.
   
   
   
   
   

**URIGU             E.S.D. ATOM1 TO ATOM2 [, ATOM3 TO ATOM4 ] ...**


   Restrain the ADPs listed using enhanced rigibody restraints
   ::


       URIGU 0.01 F(1) TO F(2), F(2) TO F(3)
   


   

   
   Implementation of the RIGU restraint from SHELXL. See 
   
   Uhttps://dx.doi.org/10.1107%2FS0108767312014535 Thorn, A., et. al., Acta Cryst. Sect A, 2012, Vol. 68, pp. 448-451#
   
   
   
   
   

**UPERP             E.S.D. ATOM1 TO ATOM2 [ TO ATOM3 ] [, ATOM4 TO ATOM5 [ TO ATOM6 ] ] ...**


   Restrain the ADP of the first atom of the group to be perpendicular to the direction 
   of the 2 atoms of the group or the bissector define by ATOM1 TO ATOM2 and ATOM1 TO ATOM3
   ::


       UPERP 0.01 F(1) TO C(1), F(2) TO C(1)
   


   

   
   The ADP of the atom F(1) and F(2) are restrained to be perpendicular to the direction
   F(1)-C(1) and F(2)-C(2) respectively.
   
   
   
   ::


       UPERP 0.01 C(2) TO C(1) TO C(3)
   


   

   
   The ADP of the atom C(2) is restrained to be perpendicular to the direction
   define by the bissector of C(1)-C(2)-C(3).
   
   
   
   
   

**UPLANE            E.S.D. ATOM1 TO ATOM2 TO ATOM3 [, ATOM4 TO ATOM5 TO ATOM6 ] ...**

   
   Restrain the ADP of the first atom of the group to be perpendicular to the plane 
   formed by the 3 atoms of the group
   ::


       UPLANE 0.01 F(1) TO C(1) TO C(2)
   


   

   
   The ADP of the atom F(1) is restrained to be colinear to the direction
   define by the normal of the plane defined by F(1), C(1) and C(2).
   
   
   
   
   

**ULIJ              E.S.D. ATOM1 TO ATOM2 TO ATOM3 [, ATOM4 TO ATOM5 TO ATOM6 ] ...**


   Restrain the ADP of all the first atom (ATOM1, ATOM4...) of the groups to be equal in the local coordinate 
   basis defined by all the atom of each group (ATOM1, ATOM2, ATOM3; ATOM4, ATOM5, ATOM6...).
   ::


       ULIJ 0.01 F(1) TO C(1) TO C(2), F(2) TO C(1) TO C(2)
   


   

   
   The Uij terms of the ADP of the atom F(1) and F(2) are restrained to be equal
   in their repesctive local coordinate system defined by F(1), C(1), C(2) and
   F(2), C(1), C(2).
   
   
   
   

==================
General restraints
==================



The 'general restraint' enables
the user to write out a restraining equation explicitly.
The system
automatically calculates the value of the restraint and then
evaluates the partial derivatives for each of the refinable  parameters


Thes restraints look like  simple
fortran statements involving operators and operands.


**OPERATORS**


The available operators are :

::


         (
         )
         **            must be followed by an operand.
         *             must join two operands.
         /             must join two operands.
         +             must precede an operand.
         -             must precede an operand.




An operand may be a simple variable or
an expression enclosed in parentheses.


The operators above assume their normal FORTRAN meanings,
and the combination of operands and operators is the same as in
standard FORTRAN, except that all calculations are done
in floating point.


**ATOMIC COORDINATES**


These are specified by a modified form of the
atom definition given above. This is :
::


          TYPE(SERIAL,S,L,TX,TY,TZ,KEY)




KEY  Specifies the relevant coordinate of the
atom. The  KEY  is regarded as an
obligatory parameter, but for the remaining
symmetry parameters, the drop
out rules and default
settings described under the atom definition may be
applied, so that the simplest form of
coordinate definition is  TYPE(SERIAL,KEY), similar to a LIST 12
definition .
The usual parameter keys are recognized.




**OVERALL PARAMETERS**


The usual overall paameter keys are recognized.


**VARIABLES**


These are unsubscripted variables specified by up to
8 characters, of which the first must be a letter.
Many commonly occurring crystallographic
quantities are already prestored by the system,
and the user has the ability to declare new
constants with a 'DEFINE' directive, which
is described below.
When a user defines a new variable, he must not use a name that
has already been declared by the system.
The system variables are:


**ARRAY VARIABLES**




The system has pre-stored various arrays and variables holding
useful crystallographic information, and
users may not define or declare  new arrays.
The addressing is done in
the normal Fortran manner, except that
the element required must be specified by numeric
arguments, and not variables.
Thus A(3,1) is allowed, but A(I,J) is illegal.
::


         A(6)       the cell parameters (angles in radians)
         CV         real cell volume
         AR(6)      reciprocal cell parameters (angles in radians)
         RCV        reciprocal cell volume
         G(3,3)     real metric tensor
         GR(3,3)    reciprocal metric tensor
         L(3,3)     real orthogonalization matrix
         LR(3,3)    reciprocal orthogonalization matrix
         CONV(3)    conversion factor for the 'U(ij)'s' from 'U[iso]'
         RIJ(6)     coefficients needed to calculate [sin(theta)/l]**2
         ANIS(6)    coefficients needed to calculate the temperature
                    factor from the anisotropic temperature factors
         SM(3,4,p)  symmetry matrix 'p', where the translational
                    part is stored in sm(i,4,p)
         SMI(3,4,p) inverse symmetry operators
         NPLT(3,n)  non-primitive lattice translations
         PI         3.141......... etc.
         TPI        2*Pi
         TPIS       2*pi*pi
         DTR        conversion of degrees to radians
         RTD        conversion of radians to degrees
         ZERO       0.0




The following functions
are also recognized :

::


         SIN(ARG)      COS(ARG)      TAN(ARG)      ACOS(ARG)
         ASIN(ARG)     ATAN(ARG)     EXP(ARG)      SQRT(ARG)





==================
General restraints
==================



There are two directives.


**DEFINE NAME = TEXT**


This may be used to set up a user-defined constant which is evaluated
at run time, and  which may be referred to later on by 'NAME'.
The text comprises  a series of variables and
numeric constants interspersed with operators.
The 'NAME' must not be one of the standard functions or
variables, and may be overwritten several times  -  i.e.
its value may be redefined. Derivatives of a DEFINEd constant are not
evaluated as part of the restraint, though its numerical value will
change in successive cycles of refinement.


**RESTRAIN VALUE, E.S.D. = TEXT**


The physical or chemical quantity defined by the
'TEXT' is restrained to be 'VALUE', with
an e.s.d. of 'E.S.D.'.
The text is comprised of operands separated by
operators.
The system will differentiate the 'TEXT' with
respect to each of the refinable coordinates
that it contains and add the derivatives to
the normal matrix in the usual way.

====================
Debugging restraints
====================



Debugging commands are available to help with the creation of general
restraints


**COMPILER**


During the formation of LIST 26 (see :ref:`LIST26`),
the input directives are listed, together
with various internal stacks.


**EXECUTION**


During the application of the restraints to
the normal equations, various stacks are
printed and all the calculated derivatives
are printed (use with care).

================================
Printing the contents of LIST 16
================================



The contents of LIST 16 may be listed with:

----------
\\PRINT 16
----------

   or

-----------------
\\SUMMARY LIST 16
-----------------


   
   LIST 16 may be punched with:

----------
\\PUNCH 16
----------

   
   

========================
Creating a null LIST 16 
========================



A null LIST 16, containing no restraints, may be created with

----------
\\CLEAR 16
----------

   
   
   ::


       restrain a set of distances to 1.5 angstrom with an
       e.s.d. of 0.03, note the use of symmetry indicators.
      
            DISTANCE 1.5 , 0.03 = C(1) TO S(1) , C(1,5) TO S(1,5)
            CONT                  S(1,7,1,-1) TO C(1,7,1,-1)
      
       restrain the first distance above explicitly, by a user defined
       restraint
      
            RESTRAIN 1.5 , 0.03 = SQRT
            CONT ((C(1,5,X)-S(1,5,X))*(C(1,5,X)-S(1,5,X))*G(1,1)
            CONT +(C(1,5,X)-S(1,5,X))*(C(1,5,Y)-S(1,5,Y))*G(1,2)
            CONT +(C(1,5,X)-S(1,5,X))*(C(1,5,Z)-S(1,5,Z))*G(1,3)
            CONT +(C(1,5,Y)-S(1,5,Y))*(C(1,5,X)-S(1,5,X))*G(2,1)
            CONT +(C(1,5,Y)-S(1,5,Y))*(C(1,5,Y)-S(1,5,Y))*G(2,2)
            CONT +(C(1,5,Y)-S(1,5,Y))*(C(1,5,Z)-S(1,5,Z))*G(2,3)
            CONT +(C(1,5,Z)-S(1,5,Z))*(C(1,5,X)-S(1,5,X))*G(3,1)
            CONT +(C(1,5,Z)-S(1,5,Z))*(C(1,5,Y)-S(1,5,Y))*G(3,2)
            CONT +(C(1,5,Z)-S(1,5,Z))*(C(1,5,Z)-S(1,5,Z))*G(3,3))
      
       restrain some distances to their mean
      
            DISTANCE 0.0 , 0.03 = MEAN O(1) TO S(1) O(2) TO S(1)
            CONT                       O(1,2) TO S(1) O(1,7) TO S(1)
      
       vibration restraints along a bond
      
            VIBRATION 0.0 , 0.01 = S(1,5) TO O(1,5) S(1,7) TO C(1,7)
            CONT                  S(1) TO O(1) S(1) TO C(1)
      
       thermal similarity restraints
      
            U(IJ)  0.0 , 0.01 = S(1,5) TO O(1,5) S(1,7) TO C(1,7)
            CONT                S(1) TO O(1) S(1) TO C(1)
      
       user defined restraints to some of the U(IJ)'S. This might cure a npd
       atom
      
            RESTRAIN 0.0,0.01=S(1,U[11])-S(1,U[33])
            RESTRAIN 0.0,0.01=S(1,U[12])
            RESTRAIN 0.0,0.01=S(1,U[13])
            RESTRAIN 0.0,0.01=S(1,U[23])
      
   


   

.. _LIST17:

 
==================================
The special restraints  -  LIST 17
==================================




---------
\\LIST 17
---------


   
   LIST 17 is  generated automatically
   by the command \\SPECIAL (section :ref:`SPECIAL`), 
   and is intended to take care of floating
   origins and atoms on special positions.
   The user may create their own LIST 17, but this will be over written by
   SPECIAL unless it this is deactivated.
   
   

=============================
Printing and punching LIST 17
=============================

LIST 17 may be printed with:

----------
\\PRINT 17
----------

   or

-----------------
\\SUMMARY LIST 17
-----------------

   
   
   It is punched with:

----------
\\PUNCH 17
----------

   
   

========================
Creating a null LIST 17 
========================



A null LIST 17, containing no restraints, may be created with

----------
\\CLEAR 17
----------

   
   

===========================
Checking restraints - CHECK
===========================


\\CHECK LEVEL=
END

\\CHECK HI
END




The target values for the restraints can be checked against
the calculated values by issuing the following command :

--------------
\\CHECK LEVEL=
--------------

   

*LEVEL=*


   
   ::


            LOW      Default value
            HIGH
   


   

   
   This command causes the restraints to be calculated,
   but not added into the normal equations.
   The observed and calculated values are output to the listing file,
   with a summary on the terminal. If the LEVEL is LOW, only restraints
   where the calculated value differs significantly from the target are
   printed, otherwise all restraints are printed.

   
   If a cycle of refinement is done before issuing the command, the leverages 
   of all the restraints are calculated and printed on the screen and the lis file.
   A leverage of 0 means that the restraint has no influence on the parameter, 
   a leverage of 1 means that the restraint completely determine the value of the parameter,
   a value between 0 and 1 indicate that bot the X-ray data and the restraint contribute to the parameter.
   
   
   
.. index:: LIST 4

   
.. index:: Weighting schemes


.. _LIST04:

 
=========================================
Weighting schemes for refinement-  LIST 4
=========================================




::


    \LIST 4
    SCHEME NUMBER= NPARAMETERS= TYPE= WEIGHT= MAXIMUM=
    PARAMETERS P=
    END
   
    \LIST 4
    SCHEME 14 3
    END
   






The weighting of least squares refinement is still very controversial.
The matter is discussed at some length by Schwartzenbach *et* *al* in
Statistical Descriptors, and further insights may be gleaned from
Numerical Recipies. Weighting the refinement can serve several purposes,
and the weighting
may need to be changed as the refinement proceeds. The weighting of Fo
and Fsq refinements will be different. To a first approximation,
::


         w(Fsq) = w(Fo)/2Fo
                                 note the problem as Fo approaches 0.0






Initially the analyst
must choose a scheme which will hasten the rate of convergence, and
reduce the risk of the refinement falling
into a false minimum.
Towards the end of the refinement, once all the parameters have been
approximately refined, a different scheme will be necessary to generate
reliable parameter s.u.s (e.s.d.s)



My advice (DJW,1996) is
to use unit weights for Fo refinement (1./4Fsq for Fsq refinement) until
the structure is fully parameterised, and then an empirical scheme for
the final refinement. It seems that pure 'statistical' weights are
rarely satisfactory. The crucial thing is to look at the analysis of
variance (/ANALYSE). The weighted residual (see definition of Fo' etc above)
w(Fo'-Fc')**2 should be invariant for any rational
ranking of the data. If there are any trends, then either the model is
wrong or the estimates of w are wrong. If the model is believed to be
full parameterised and substantially correct, the trend in residual can
be used to estimate the weights.

===================================
Weighting for refinement against Fo
===================================



This set of weighting schemes should be selected when
the minimisation function that is to be used during the least squares
process is given by :
::


          SUM( w*(Fo - Fc)**2 )




Where the summation is over all the reflections.

====================================
Weighting for refinement against Fsq
====================================



Refinement against Fo or Fsq is also controversial. The controversy is
not really concerned with negative observations, since Fo can be given
the sign of Io. The real problem is that the error distribution for Fo
is not the same as that of Fsq, and is not simply related to it for very
weak reflections. However, the argument is academic, since the error
estimates for Fsq are not really known.


CRYSTALS provides two different alternatives for the case in which the
minimisation function is given by :
::


             SUM( w*(Fo**2 - Fc**2)**2 )




In the first of these options, the weights are calculated normally for Fo,
and then converted so that they apply to Fsq
by the operation :
::


             w' = w/(4*Fo*Fo)




Where w' is the weight for Fsq and  w  is the weight for Fo.
This option is selected by the parameter  TYPE  =  1/2Fo
in the  SCHEME  directive above.
For example, pseudo unit weights are selected by the input :

::


         \LIST 4
         SCHEME 9 0 1/2Fo
         END




This option may be used with any of the weighting schemes above.


The second option also uses the weighting scheme types for Fo, except
that Fsq is substituted for Fo in the equations.
This option is selected by the parameter  TYPE  =  Fo**2
in the  SCHEME  directive above. This choice would be suitable for the
Chebychev weighting schemes.

--------
\\LIST 4
--------

   

**SCHEME NUMBER= NPARAMETERS= TYPE= WEIGHT= MAXIMUM=**


   

*NUMBER*


   The number of the weighting scheme to be used
   (see below). The default value is  9 (unit weights).
   

*NPARAMETERS=*


   The number of parameters to be provided for the weighting
   scheme. The default value is zero,
   

*TYPE*


   
   
   ::


            NORMAL
            1/2Fo
            Fo**2
            CHOOSE    -  Default value
   


   
   The value of  NORMAL  indicates that the weighting scheme type
   is for refinement against Fo.
   If  TYPE  is  1/2Fo  or  Fo**2  the weighting scheme type is for
   refinement against Fsq (see above).

   
   If TYPE equals CHOOSE, one of the three previous type is chosen depending
   on the scheme number and the refinement type set in LIST 23 (structure
   factor control, see section :ref:`LIST23`).
   

*WEIGHT=*


   This parameter determines the weight assigned to reflections during the
   determination of Chebychev coefficients.
   For each reflection the weight with which it is added into the
   Chebychev normal equations is given by :
   ::


            W = 1/[1+Fo**WEIGHT].
   


   
   Thus if WEIGHT is equal to zero, all the weights will be the same and equal
   to  0.5.
   The default value is 2.0
   

*MAXIMUM=*


   This parameter is used to set the maximum weight that can be applied, and
   is usefull for the Dunitz-Seiler scheme (13), and the Chebyshev
   schemes (10 and 14).
   
   
   
   
   

**PARAMETERS P=**



   
   The parameters that are to be used to compute the weight for a given
   reflection are specified with this directive.
   

*P=*


   This directive contains  NPARAMETERS  values. If this parameter is omitted,
   default values of zero are assumed for  P.

   
   The parameters must always be provided on the scale of Fo, not
   on the scale of Fc.
   For example, the agreement analysis programs can work on the scale
   of Fc, so that constants derived from such output must be put
   on the scale of Fo by multiplying them by the scale factor in LIST 5 
   (the model parameters).

========================
Weights stored in LIST 6
========================



If w is the weight to be applied to a reflection in the least squares
refinement, the value to be stored in LIST 6  (section :ref:`LIST06`) 
is sqrt(w), given the key
SQRTW. If weights are computed by some external utiity, then either is
should generate sqrt(w), or the values be converted after input to
CRYSTALS - see scheme 5 below.

=================
Weighting schemes
=================



In the equations and explanations below,  NP  is an
abbreviation of  NPARAMETERS , the number of parameters required
to define the weighting scheme, P(1) is the first such
parameter and P(NP) the last parameter.


The available weighting schemes are :

::


    1.     sqrt(W) = Fo/P(1), Fo < P(1) OR Fo = P(1)
           sqrt(W) = P(1)/Fo, Fo > P(1)
   
    2.     sqrt(W) = 1      , Fo < P(1) OR Fo = P(1)
           sqrt(W) = P(1)/Fo, Fo > P(1)
   
    3.     sqrt(W) = sqrt(1/(1 + [(Fo - P(2))/P(1)]**2))
   
    4.     sqrt(W) = sqrt(1/[P(1) + Fo + P(2)*Fo**2 + . . + P(NP)*Fo**NP])
   
           try P(1) = 2*FMIN and P(2) = 2/FMAX,
           Cruickshank, Computing Methods and the Phase
           Problem, Pepinsky et al, 1961, page 45
   
    5.     sqrt(W) = SQRT(data with the key 'SQRTW' in list 6)
   
    6.     sqrt(W) = (data with the key 'SQRTW' in list 6)
   
    7.     sqrt(W) = SQRT(1/(data with the key 'sigma(Fo)' in LIST 6))
   
    8.     sqrt(W) = 1/(DATA WITH THE KEY 'SIGMA(Fo)' IN LIST 6)
                     ** remember that for schemes 7 & 8, LIST 6  **
                     ** must store both weight and sigma.        **
   
    9.     sqrt(W) = 1.0 (Unit weights, default)
   
    10.    sqrt(W) = sqrt(1.0/[A[0]*T[0]'(X) + A[1]*T[1]'(X) . .
                     +A[NP-1]*T[NP-1]'(X)])
                     Chebychev weighting - see below for details
   
    11.     As for 10, but only applying previously determined parameters.
   
    12.    sqrt(W) = sqrt([SIN(THETA)/LAMBDA]**P(1))
                     If  NP  is zero, a value of -1 is assumed for P(1) .
   
    13.    sqrt(W) = sqrt([weight] * exp[8*(p(1)/p(2))*(pi*s)**2])
                     Dunitz Seiler weighting - see below for details
   
    14.    sqrt(W) = sqrt(W' * (1. - (delta(F)/ 6* del(F)est)**2)**2)
                W' = 1.0/[A[0]*T[0]'(X) + A[1]*T[1]'(X) . .
                     +A[NP-1]*T[NP-1]'(X)]
                      Robust-resistant refinement - see below
   
    15.     As for 14, but only applying previously determined parameters.
   
    16.     sqrt(W) = Sheldrick SHELX-97 weights (page 7-31). The P1-P6
                      correspond to Sheldricks parameters a-f, but are not
                      refined automatically. Fo and Fc replace Fosq and
                      Fcsq for Fo refinement.
                      Use 0.1 0 0 0 0 .333 to get Sheldrick defaults.
   
    17.    Automatically determine the parameters for 16
   





===================================
Dunitz Seiler weighting - scheme 13
===================================

S is sin(theta)/lambda, pi is 3.141...  Use p(1) = 1 and
p(2) = 4 to simulate p=3, q=9 in Dunitz and Seiler
Acta(1973),B29,589. Set MAXIMUM to 100. This scheme may be used for
refinement before looking for bonding electrons.

==================================
Chebychev weighting schemes 10, 11
==================================



A[i] are the coefficients of a Chebyshev series in t[i]'(x),
where x = Fo/Fo(max).
(There is an account of CHEBYSHEV series in Computing Methods
in Crystallography, edited by J.S. Rollett, p40).
For this weighting scheme, the coefficients a[i] are calculated
by the program using a least squares procedure which
minimizes sum[(Fo - Fc)**4] over all the reflections.
The resulting coefficients are stored in a new LIST 4
as weighting scheme type 11 (see below),
and then used to calculate the weights
for each of the reflections.
It is recommended that several different values of
NP  are used (e.g 3 to 5), so that series of various orders are tested
to see which gives the best fit. If negative or very small reciprocal
weights are computed (i.e. the computed curve fall close to or crosses
the ordinate axis), the parameter MAXIMUM can be used to restrict the
maximum weight. For data on 'ordinary' scales, this will require a value
of about 100.
(This is best seen by computing an agreement analysis
once the new weights have been calculated).
The parameters P(i) need not be given,  because they are to be computed.
When the Chebyshev coefficients have been determined, p(1) is
overwritten by the value determined for a[1]. (Carruthers and Watkin,
Acta Cryst (1979) A35, 698).
Scheme 10 generates the parameters needed for a scheme 11.

=========================================
Robust-resistant weighting schemes 14, 15
=========================================

This scheme should only be used towards the end of a refinement, when
all of the expected variables have been introduced.
It is usefull when there is suspicion of uncorrelated but significant
errors in the data, and its effect is similar to scheme 10 in the absence
of such errors.
The expression for W' is as in Scheme 10 above, except that X is Fc/Fc(max).
This weight is then modified by a function expressing confidence in
Fo-Fc. If the observed delta is large compared with the delta estimated
from the Chebychev fitting, the reflection is down weighted. It it is more
than 6 times the estimate, the weight is set to zero and the reflection
flagged as an 'OUTLIER'. This scheme is recommended in preference to Scheme
10, which is kept for old times sake. See E. Prince, Mathematical Techniques
in Crystallography, Springer-Verlag, for the background.



=======================
Statistical Weights, 16
=======================

This scheme can in principle be introduced at any time, but the
parameters P(i) are best optimised near the end of a refinement.
Typical values for CAD4 data are: p(1)=.001, p(2)=3.0 and p(4)=1.



============================
Auto-Statistical Weights, 17
============================

This scheme can in principle be introduced at any time, but the
parameters P(i) are best optimised near the end of a refinement.
The parameters are optimised automatically by a grid-search of 
the residual as a function of intensity and resolution.



===============
Printing LIST 4
===============



of LIST 4 may be printed with:

---------
\\PRINT 4
---------


   
   There is no command for punching LIST 4.
   
   ::


       Example
            \ Weighting scheme type 10 (Chebyshev) with 3 parameters
            \LIST 4
            SCHEME NUMBER = 10,NPARAM = 3
            END
   


   

==================================
Weighting the reflections - WEIGHT
==================================



If the weighting scheme is changed, new weights are automatically
computed for the next structure factor calculation. The computation of
weights can be forced at any time with \\WEIGHT.

-----------------------
\\WEIGHT INPUT= FACTOR=
-----------------------

   

*INPUT*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   
   
   

*FACTOR*


   
   If FACTOR is less or equal zero, the code tries to compute a value
   which will make S (GoF) about unity.  It is important that the GoF 
   stored in LIST 30 is up to date. The SCRIPT REWEIGHT will try to do this 
   for you.
   
   If FACTOR is unity, the re-weighting factor is taken from LIST 4.
   This is the default action

   
   
   If FACTOR is greater than zero and not exactly unity,
   all weights will be multiplied by this amount.  
   
   
   
   
   
   

**LIST LEVEL=**


   

*LEVEL*


   LEVEL is OFF, LOW, MEDIUM or HIGH 
   
   
   
   
   
   
   
.. index:: LIST 28

   
.. index:: Reflection restriction

   
.. index:: Omitting reflections

   
.. index:: Cutting reflection data


.. _LIST28:

 
=======================================
Reflection restriction list  -  LIST 28
=======================================




::


    \LIST 28
    MINIMA COEFFICIENT(1)= COEFFICIENT(2)= ...
    MAXIMA COEFFICIENT(1)= COEFFICIENT(2)= ...
    READ NSLICES= NOMISSION= NCONDITION=
    SLICE P= Q= R= S= T= TYPE=
    OMIT H= K= L=
    CONDITION P= Q= R= S= T= TYPE
    SKIP STEP=
    END





::


    \LIST 28
    MINIMA RATIO=3
    READ NOMIS=1
    OMIT 2 0 0
    END






LIST 6 (section :ref:`LIST06`) should contain all the reflections, 
including negative ones.
LIST 28 can then be used to dynamically select which ones are to be
omitted from a calculation. Several conditions may be specified, and
ALL the conditions must be satisfied for a reflection to be used,
i.e. the conditions are ANDed  together.


It is also possible to specify individual reflections which
are to be omitted.


TAKE CARE WHEN CHANGING LIST 28. If the conditions are relaxed, reflections
may become acceptable for which Fc and phase have not been recomputed
because they were rejected at an earlier stage. Recompute them all.



---------
\\LIST 28
---------

   

**MINIMA COEFFICIENT(1)= COEFFICIENT(2)= .  .**



   
   This defines the coefficients whose minimum values are
   to be restricted.
   

*COEFFICIENT=  VALUE*


   Each such parameter defines one coefficient and its minimum value.
   The following are known to the system, BUT REMEMBER, with the exception of
   (sintheta/lambda)**2, which is computed for each reflection from the cell
   parameters, only those coefficients specifically stored in the LIST 6
   (see section :ref:`LIST06`) will have values.
   ::


            H             K             L             /FO/
            SQRTW         FCALC         PHASE         A-PART
            B-PART        TBAR          FOT           ELEMENTS
            SIGMA(F)      BATCH         INDICES       BATCH/PHASE
            SINTH/L**2    FO/FC         JCODE         SERIAL
            RATIO         THETA         OMEGA         CHI
            PHI           KAPPA         PSI           CORRECTIONS
            FACTOR1       FACTOR2       FACTOR3       RATIO/JCODE
   


   
   

**MAXIMA COEFFICIENT(1) COEFFICIENT(2) .  .**



   
   This defines the coefficients whose maximum values are
   to be restricted. See MINIMA above.
   
   
   

**READ NSLICES= NOMISSION= NCONDITION=**



   
   This gives the number of conditional directives to follow.
   

*NSLICES*


   This specifies the number of  SLICE directives, default is zero.
   

*NOMISSIONS*


   This specifies the number of OMIT directives, default is zero.
   

*NCONDITION*


   This specifies the number of  CONDITION directives, default is zero.
   

**SLICE P= Q= R= S= T= TYPE=**



   
   This directive selects reflections to those giving
   values of (h*p + k*q + l*r) in the range s to t.
   The number
   of such directives is specified on the  READ  directive above. TYPE
   indicates whether the selected reflections are accepted or rejected.
   
   The records are processed in the order given. If a reflection matches 
   the conditions, the specified action is taken and no further slice 
   directives are considered. This enables quite fancy intersections to be 
   specified.

   
   
   For example, a single layer of
   reciprocal points, or a set of adjacent layers, oriented in any
   desired crystallographic direction, can be selected.
   
   

*P= Q= R= S= T=*


   These parameters, whose default values are zero, specify selected
   slices of reciprocal space.
   

*TYPE=*


   ::


            REJECT (default) causes rejection of selected reflections.
            ACCEPT           accepts reflections
   


   
   
   
   
   

**OMIT H= K= L=**



   
   This directive causes the reflection with the indices H, K, and L
   to be omitted.
   

*H= K= L=*


   These parameters specify the indices of the reflection to be omitted.
   

**CONDITION P= Q= R= S= T= TYPE=**



   
   This directive causes selection of reflections giving
   values of (h*p + k*q + l*r + s) exact multiples of 't'.  TYPE
   indicates whether the selected reflections are accepted or rejected.
   The number
   of such directives is specified on the  READ  directive above.
   The records are processed in the order given. If a reflection matches 
   the conditions, the specified action is taken and no further slice 
   directives are considered. This enables quite fancy intersections to be 
   specified.

   
   
   For example, l odd layers can be rejected by setting
   'r' and 's' to 1, 't' to 2.
   
   

*P= Q= R= S= T=*


   These parameters, whose default values are zero, specify selected
   slices of reciprocal space.
   

*TYPE=*


   ::


            REJECT (default) causes rejection of selected reflections.
            ACCEPT           accepts reflections
   


   
   

**SKIP STEP=**



   
   This directive can be used sample the data by skipping through LIST 6,
   (reflections, section :ref:`LIST06`) and may be usefull to speed up 
   initial refinement.
   

*STEP=*


   This is the skip step length, and has a default of 1, i.e. all reflections
   are accepted. A value of 3 selects every third reflection for use in 
   calculations (i.e. 2 out of 3 are skipped).
   
   
   

=======================
Creating a null LIST 28
=======================

::


    \LIST 28
    END




Allows all the reflections in LIST 28 to be used.

================================
Printing the contents of LIST 28
================================



LIST 28 may be listed by the command :

----------
\\PRINT 28
----------


   
   There is no command for punching LIST 28.
   
   ::


            Example 1
            \LIST 28
            \ Set the minimum ratio I/sigma(i) to 3.0,
            \ a maximum Fo to 1000
            \ and omit the 0 2 0 reflection
            \
            MINIMA Ratio=3
            MAXIMA Fo=1000
            READ NOMIS = 1
            OMIT 0 2 0
            END
      
            Example 2. To reject h and k simultaneously even:
      
            condit p=1 s=1 t=1 type=accept    \lets ALL with h odd through
            condit q=1 s=1 t=1 type=accept    \lets ALL with k odd through
            condit s=1 t=1 type=reject        \rejects remaining.
      
            Example 3. To reject all k=0, k=2:
      
            slice q=1 s=0 t=0 type=reject
            slice q=1 s=2 t=2 type=reject
      
            Example 4. To reject all k=0, k=2 but keep the l=0 row:
      
            slice r=1 s=0 t=0 type=accept
            slice q=1 s=0 t=0 type=reject
            slice q=1 s=2 t=2 type=reject
      
            Example 5. To only allow specific zones, the ones wanted are 
            selected, and then the rest rejected, eg for h=0:
      
            slice p=1 s=0 t=0 type=accept              \ accept the h00 zone
            slice p=1 q=1 r=1 s=-500 t=500 type=reject \ reject everything else
      
   


   
   
.. index:: SFLS

   
.. index:: Structure factor least squares calculation


.. _SFLS:

 
======================================================
Structure Factor Least Squares Calculations  -  \\SFLS
======================================================




::


    \SFLS  INPUT=
    CALCULATE LIST= MAP= /Fo/= THRESHHOLD=
    SCALE LIST= MAP= /Fo/=
    REFINE LIST= MAP= /Fo/= PUNCH= MATRIX= MONITOR= INVERTOR= CALCULATE=
    SHIFT  KEY= KEY=
    MAXIMUM  KEY= KEY=
    FORCE  KEY= KEY=
    SOLVE MONITOR= MA=P /Fo/= PUNCH= MATRIX=
    VECTOR MONITOR= MAP= /Fo/= PUNCH= MATRIX=
    HUGE=
    END




::


    \SFLS
    REFINE
    REFINE
    END





===========
Definitions
===========



**Minimisation funtion for Fsq**


::


         Minimisation function = Sum[ w*(Fo**2 - Fc**2)**2 ]






**Minmisation function for Fo**


::


         Minimisation function = Sum[ w*(Fo - Fc)**2 ]






**R-factor for Fo**


::


         R = 100*Sum[//Fo/-/Fc//]/Sum[/Fo/]




The summation is over all the reflections accepted by LIST 28. This
definition is used for both conventional and F-squared refinement.


**R-Factor, Hamilton weighted**


::


         100*Sqrt(Sum[ w(i)*D'(i)*D'(i) ]/SUM[ w(i)*Fo'(i)*Fo'(i) ])
   
         Fo' = Fo for normal refinement, Fsq for F-squared refinement.
         Fc' = Fc for normal refinement, Fc*Fc for F-squared refinement.
         D'  = Fo'-Fc'






The weighted R-factor stored in  LIST 6 (section :ref:`LIST06`) and LIST 30 
(section :ref:`LIST30`) is that computed
during a structure factor calculation. The conventional R-factor is
updated by either an SFLS calculation or a SUMMARY of LIST 6.




**Minimisation function**



::


         Fo' = Fo for normal refinement, Fo*Fo for F-squared refinement.
         Fc' = Fc for normal refinement, Fc*Fc for F-squared refinement.
         D'  = Fo'-Fc'
   
         MINFUNC = Sum[ w(i)*D(i)*D(i) ]






Good references to the theory and practice of structure factor least squares
are in the chapters by J. S. Rollett and D. W. J.
Cruickshank in Crystallographic Computing, edited by F. R. Ahmed, and
chapters 4, 5 and 6 in Computing Methods in Crystallography, edited by
J. S. Rollett.


====================
Unstable refinements
====================



If a refinement 'blows up', i.e. diverges rapidly, the user should
seek out the physical cause (wrong space group, pseudo symmetry,
incorrect data processing, disorder, twinning etc). If the cause of the
divergence is simply that the model is too inaccurate, the divergence
can by controlled by limiting the shifts applied in the first few
cycles. The modern way to do this is via 'shift limiting restraints'
(Marquardt modifier) in LIST 16. An older method was to use partial
shift factors. These are set up by directives to the \\SFLS command 
(section :ref:`SFLS`).

During the solution of the normal equations, the user may specify
that more or less than the whole calculated shift should be
applied.
Alternatively, the program can be instructed to scale the shifts so that
the maximum shift for any parameter group is limited to a given value.
(The  SHIFT ,  MAXIMUM  and  FORCE  directives).



===================================================
Sorting of LIST 6 for structure factor calculations
===================================================



During a structure factor least squares calculation, the values
for the real and imaginary parts of  A  and  B  and their derivatives
are computed and stored.
These values are then taken and formed into Fc and its derivatives,
which are added into the normal matrix.
Between reflections, the values for A and B and their derivatives are
retained.
If the next reflection in LIST 6 (section :ref:`LIST06`) has a set of indices 
which are equivalent
to the
last reflection, the same values for the real and imaginary parts of A and B
and their derivatives can be used.


This type of situation can arise either when anomalous scatterers
are present, implying that F(h,k,l) is not equal to F(-h,-k,-l), or
when an extinction parameter is being refined and formally equivalent
reflections have different Fo values and mean path lengths.
In this sort of case, the time for a structure factor calculation
can be significantly reduced if reflections with symmetry related sets
of indices are adjacent in LIST 6, when the conserved values
of A and B can be used repeatedly.


In a similar way,
during a structure factor calculation for a twinned crystal, the
contribution and derivatives for each element are stored as they are
calculated and then combined to produce /FCT/ when all the contributions
have been accumulated.
Between reflections this stored information is retained, so that if the
next reflection contains contributions from elements with the same
indices as the previous reflection,
it is unnecessary to re-compute  the A and B parts.
Obviously,
reflections with common contributors must again be adjacent in LIST 6,
in which case a structure factor calculation, with or without least
squares, takes only slightly longer than the corresponding normal calculation
with the same number of observations.

------
\\SFLS
------


   
   The directives are carried out in the order in
   which they appear.

   
   The directives  REFINE,  SCALE,  and CALCULATE
   initiate cycles of S.F.L.S. calculations. If one of the
   directives  SHIFT ,  MAXIMUM  or  FORCE  is given following  REFINE,
   a scaled shift will be applied to that cycle of refinement.
   

**SFLS INPUT=**


   

*INPUT*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   

   
   
   

**CALCULATE LIST= MAP= /Fo/= THRESHOLD=**



   
   If CALCULATE is included with other commands within a single \\SFLS 
   block, it **MUST** **BE** the last command.

   
   This directive indicates that structure factors should be
   calculated, but that no refinement of any type should be done. 
   Structure factors are computed for every reflection and used to compute 
   R and Rw for all data. R and Rw are also computed for reflections with 
   I>threshold Sigma(I).  The default value for the threshold is 4.

   
   
   The directives
   SHIFT ,  MAXIMUM  and  FORCE  may not be given before the next
   REFINE directive.
   
   

*LIST*


   Controls the listing of reflection information.
   
   ::


            OFF   -  Default
            MEDIUM
            HIGH
   


   
   The value OFF  indicates that the
   discrepancy for each reflection :math:`|F_o-F_c|/F_o` is computed and if greater than
   3*(overall R factor) from the previous cycle of structure factors, a warning
   is printed. Only the first 25 such reflections are listed.

   
   If the ENANTIOPOLE parameter is activated in LIST 23 (structure factor
   control, see section :ref:`LIST23`), sensitive reflections,
   for which :math:`|F_+-F_-| > .05 |F_++F_-|/2` are also listed.

   
   If  LIST  is  MEDIUM , the structure factors are listed as they
   are computed. The output contains h, k, l, :math:`F_o`
   (on the scale of :math:`F_c`), :math:`F_c`, the phase and :math:`\sin\theta/\lambda`,
   the unweighted and weighted delta's.
   (:math:`F_o - F_c` or :math:`F_o^2 - F_c^2`, depending upon the type of refinement
   being done), and information which is useful when anomalous
   dispersion effects are present, and contains the real part of :math:`F_c` (:math:`F_c^\prime`),
   the imaginary part of :math:`F_c` (:math:`F_c^{\prime\prime}`), the computed difference between
   :math:`F_{hkl}^2` and :math:`F_{-h-k-l}^2`, and the calculated or theoretical
   Bijvoet ratio (t.b.r.).

   When a twinned crystal structure is being refined,  LIST  =  HIGH
   gives FoT and /FcT/ in place of Fo and Fc, respectively.
   Also, the contributions of each element to each reflection of a twinned
   crystal are listed. As well as /FcT/ and the indices,
   Fc, multiplied by the square root of the element scale factor, and the
   element number are also printed for each component under the column headed
   by /FC'/. This option is only obeyed if LIST 13 (section :ref:`LIST13`)
   indicates that a twinned crystal structure is being refined.

   
   List MEDIUM and HIGH produces one line of output for each reflection.
   

*MAP*


   Controls printing of the memory map - mainly used by programmers
   
   ::


            NONE  -  Default value
            PART
            FULL
   


   
   If  MAP  is  PART , a list of core addresses is printed,
   together with any unused locations. If  MAP  is  FULL , the addresses and
   contents of the areas of code claimed by each list as it is brought down
   are printed on the line printer as the list is loaded.
   This option produces reams of output and should never be used
   except by programmers.
   If  MAP  is  NONE , its default value, a core map is
   not printed.
   

*/Fo/*


   Controls the treatment of twinned data.
   
   ::


            FoT        -  Default value
            Scaled-FoT
   


   
   In the refinement of a twinned crystal, if  /Fo/  =  FoT , its
   default value, the FoT is output as the data for the key  /Fo/ , the
   corresponding /FcT/ is output for  Fc , and the phase is arbitrarily
   set to zero. If  /Fo/  is  SCALED-FoT , the data for  Fo ,  Fc
   and  PHASE  contain an estimate of the required quantities for the
   element in whose reference system the nominal indices are given, i.e.
   estimates of the resolved data are produced.
   

*THRESHOLD*


   Sets a sigma(I) threshold for computing the restricted Rfactor. The 
   default value is 4.0
   

**SCALE LIST= MAP= /Fo/=**



   
   This directive indicates that structure factors should be calculated
   and the overall scale factor should be refined.
   The directives
   SHIFT ,  MAXIMUM  and  FORCE  may not be given before the next
   REFINE directive.
   

*LIST*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*MAP*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*Fo*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

**REFINE LIST= MAP= /Fo/= PUNCH= MATRIX= MONITOR= INVERTOR=**



   
   This directive indicates a complete structure factor least squares
   calculation.
   

*LIST*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*MAP*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*Fo*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*PUNCH*


   Controls punching results to files
   
   ::


            NO  -  Default value
            YES  -  write the model parameters to a *.pch file
            MATLAB  - write the design matrix, normal matrix, inversion and weights to matlabs files *.m
            TEXT  - write the design matrix, normal matrix, inversion and weights to ASCII files *.dat
            NUMPY  - write numpy files for python plus a python script for the user to use
   



*MATRIX*


   Controls re-use of the normal matrix
   
   ::


            NEW  -  Default value
            OLD
   


   
   If MATRIX is NEW, a new matrix is computed for the current cycle.
   
   

   
   If  MATRIX  is  OLD , the left hand side of the normal matrix is not
   accumulated during the cycle of refinement. Instead, the version that
   already exists is used with the new right hand sides. This option
   is particularly useful at the end of a refinement of a large structure
   when the left hand side does not change appreciably from cycle to cycle.
   It greatly reduces the time for a cycle.
   

*MONITOR*


   Controls the shift information printed out.
   
   ::


            LOW  -  Default value
            MEDIUM
   


   
   The MEDIUM listing outputs details about all parameters refined, and lists
   the values, shifts and e.s.d.s of all parameters in LIST 5. The LOW
   listing outputs information only for those l.s. parameters for which the
   SHIFT RATIO exceeds 3.0, and/or the SHIFT/ESD  exceeds 1.0 . Only those
   atoms in LIST 5 containing one or more refinable parameters are listed.
   

*INVERTOR*


   Six matrix inversion methods are provided.
   
   ::


            AUTO - Default value (Auto-adaptive single precision/double precision LDLT inversion)
            LDLT - single precision Robust Cholesky decomposition of a matrix with pivoting
            EIGENVALUE - Eigenvalue decomposition + filtering on small eigenvalues then inversion
            DP_LDLT - double precision Robust Cholesky decomposition of a matrix with pivoting
            XCHOLESKY - original crystals Cholesky decomposition
            CHOLESKY - Standard Cholesky inversion
   


   
   The AUTO method is suitable for most problem including moderatly ill condition problems.
   Crystals will switch automatically from single precision to double precision for the inversion when needed.
   The eigenvalue decomposition should be used with care, the XCHOLESKY method is kept for historical purpose,
   The LDLT and DP_LDLT can be use to forced crystals to use single or double precision. Beware of precision loss
   in single precision. The CHOLESKY method is deprecated.
   

**SHIFT  KEY = VALUE  KEY = VALUE .  .  .  .**



   
   This directive sets the shift factor for the specified cycle of
   refinement. (The shift factor is the amount by which the calculated
   shift is multiplied before it is applied to generate the new parameters).
   For each of the parameters given by the  KEYS  on the directive,
   the shift factor is changed to the value given by  VALUE.
   The  =  sign is not optional. 
   
   
   If more
   than one shift directive ( SHIFT ,  MAXIMUM  or  FORCE ) is given for
   the same parameter, only the last is obeyed.
   
   
   The following  KEYS  are recognized :
   
   ::


            GENERAL   This refers to all the atomic, batch and element parameters
            OVERALL   This refers to the overall parameters
      
            OCC     U[ISO]      X       Y       Z
            U[11]   U[22]   U[33]   U[23]   U[13]   U[12]
            SPISO   SPSIZE  LINISO  LINSIZE LINDEC  LINAZI
            RINGISO RINGSIZ RINGDEC RINGAZI 
   


   
   This is the default for GENERAL, OVERALL and 
   SPECIAL parameters, with default shift factors 1.0.
   

**MAXIMUM  KEY = VALUE  KEY = VALUE .  .  .  .**



   
   This directive is similar to the directive  SHIFT  above, except that the
   maximum shift that is applied for the given parameters cannot be
   greater than  VALUE. The units of  VALUE  are conventional,
   WITH x, y, z measured in angstrom, and ADPs in Angstrom sq. If none of 
   the shifts exceend VALUE, then they are applied unmodified.
   This provides a
   method of automatically scaling down the applied shifts if the matrix 
   inversion has become unstable. Shift limiting restraints (LIST 16) are a 
   more controlled alternative
   
   
   The KEYS are the same as in SHIFT above, and this is the default 
   action for Occ, adps and positions, with maximal values:
   ::


            OCC 1.0
            U*  0.05 (Angstrom sq)
            X's 1.0  (Angstom)
      
   


   
   

**FORCE  KEY = VALUE  KEY = VALUE .  .  .  .**



   
   This is similar to MAXIMUM  above, except that the
   maximum shift is scaled to VALUE even if it is less than VALUE. 
   
   
   
   
   The KEYS are the same as in SHIFT above. There is no default
   shift.
   

**VECTOR MONITOR MAP Fo PUNCH MATRIX**



   
   This is an obsolete feature, and will be removed at a later date.

   
   This directive indicates that structure factors are to be calculated
   and then the shift vector stored in LIST 24 (see :ref:`LIST24`) is to be applied.
   This is used to apply a shift vector calculated from one of
   the eigenvalues of the normal matrix. Although no new matrix is produced
   by this directive, sufficient space must be allocated for the normal
   matrix, since it is loaded when the new coordinates are calculated.
   

*HUGE*
   This directive tuned the refinement for big structures. It performs the
   the normal matrix accumulation in single precision, 
   the accumulation of the right and side is also done in single precision.
   The inversion is still using double precision but with a 
   Cholesky decomposition faster than the default auto-adaptive LDL^t decomposition. 
   Bigger structures tend to be more ill-conditioned so inversion needs to be done in double precision.
   These changes could potentially lead to a less stable refinement but it is unlikely, 
   the default refinement is just very conservative.
   
*CALCULATE*
   LEVERAGES  - CALCULATE the leverages and t-values. Warning: shifts are not applied in this case; 
   default output is numpy but can be changed to TEXT using PUNCH. MATLAB and pch is not supported at the moment.
   
   This directive CALCULATE is differente from the previous directive and is applied under REFINE.
   
*P1*
   Parameter passed to CALCULATE (see Above).
   
   If CALCULATE=LEVERAGES then P1 is the parameter number on which the leverages are calculated.

*MONITOR*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*MAP*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*Fo*


   This parameter has the same options as for
   the  CALCULATE  directive above.
   

*PUNCH*


   This parameter has the same options as for
   the  REFINE directive above.
   

*MATRIX*


   This parameter has the same options as for
   the  REFINE  directive above.

=======================================
Processing of the refinement directives
=======================================



The program expands the CALCULATE, SCALE or REFINE directives into
sub-directives. These sub-directives **MUST** **NOT** be
given by a user:

::


    1.   \REFINE
                     Compute structure factors and
                     derivatives. No refinement is
                     actually done.
    2.   \SCALE
                     Calculate structure factors and
                     refine the overall scale factor.
    3.   \CALCULATE
                     Calculate structure factors.
    4.   \RESTRAIN
                     Apply the restraints stored in
                     the current lists 16 and 17.
    5.   \INVERT
                     Invert the current normal matrix
                     and store a shift list as list 24.
    6.   \SOLVE
                     Take the current list 5 (the model parameters)
                     and apply the shifts given in the current
                     list 24.
    7.   \NEWSHIFTS
                     Allocate space for list 24.
    8.   \CYCLENDS







.. index:: ANALYSE


.. index:: Residual analysis


==================================
Analysis of residuals -  \\ANALYSE
==================================


::


    \ANALYSE INPUT=
    FO INTERVAL= TYPE= SCALE=
    THETA INTERVAL=
    LIST LEVEL=
    LAYERSCALE AXIS= APPLY= ANALYSE=
    END





::


    \ANALYSE
    LIST HIGH
    END






ANALYSE provides a comparison between Fo and Fc as a
function of the indices, various parity groups, ranges of F and
ranges of sin(theta)/lambda. For a well refined structure with suitable
weights, <Fo>/<Fc> should be about unity for all ranges, and <wdeltasq>
should also be about unity for all ranges. A serious imbalance in Fo/Fc
may mean the structure is incomplete, or unsuitable data reduction 
(section :ref:`DATAREDUC`). A
systemstic trend in <wdeltasw> may mean unsuitable weights are being
used.


The monitor listing is always just as a funtion of F. The output to
the listing file is user controlled.


This routine will also compute approximate layer scale factors for
data which has been collected by layers. These can be refined in the
least squares to complete a refinement.

----------------
\\ANALYSE INPUT=
----------------

   

*INPUT*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   
   
   

**FO INTERVAL= TYPE= SCALE=**


   Controls the analysis as a function of F.
   

*INTERVAL=*


   The interval between successive ranges of F.
   Its value should be determined in combination with the
   parameter  TYPE.
   

*TYPE*


   Controls how F is sampled.
   
   ::


            sqrt(Fc)  -  Default value
            Fc
            sqrt(Fo)
            Fo
   


   
   If  TYPE  is  sqrt(Fc),
   (its default value), the interval between successive F ranges is based
   on 'the square root of Fc' Values of Fc in the interval
   '0 to INTERVAL**2' will be analysed in the first range, Fc values that lie
   in the range INTERVAL**2 to 4*INTERVAL**2 in the second and so on).
   INTERVAL  is thus the increment in the square root of Fc between
   successive ranges and, in this case, has a default value of 1.
   If  TYPE  is  Fc , the interval between successive Fc ranges is
   based on the value of Fc. In this case  INTERVAL  is the increment
   in Fc and has a default value of 2.5.
   

*SCALE*


   Controls the scale of the listing
   
   ::


            Fo  -  Default value
            Fc
   


   
   If  SCALE  is  Fo, the reflection information
   is printed on the scale of Fo.
   (This is useful as the weighting parameters in LIST 4 (section :ref:`LIST04`)
   must be provided on the scale of Fo).
   If  SCALE  is  Fc, the reflection information is printed on the scale
   of Fc.
   

**THETA INTERVAL=**



   
   This directive determines the interval between successive
   sin(theta)/lambda squared ranges.
   

*INTERVAL=*


   The default is 0.04.
   

**LAYERSCALE AXIS= APPLY= ANALYSE=**



   
   This directive allows the results of layer scaling to be
   investigated.
   

*AXIS=*


   Selects the axis for layer scaling
   
   ::


            NONE  -  Default value
            H
            K
            L
   


   
   The default value of  NONE  indicates that no layer scaling is to be
   done.  H,  K  and  L  indicate the axes up which layer scaling
   is to be done.
   

*APPLY=*


   
   ::


            NO   -  Default value
            YES
   


   
   When layer scaling has been completed and the results printed,
   the calculated scale factors will be applied to the stored Fo data
   if  APPLY  is  YES . If  APPLY  is  NO , its default setting,
   then the new scales will not be applied to the data.
   If  AXIS  is  NONE , then  APPLY  is ignored.
   

*ANALYSE*


   
   ::


            NO
            YES  -  Default value
   


   
   If  ANALYSE  is  YES, a second agreement analysis
   will be performed after the layer scaling so that the results of the
   new scales can be seen. (This is true whether the new scales are
   applied or not, i.e. independent of the value of  APPLY ).
   In this way the effects of layer scaling can be seen without damaging
   the data. If  ANALYSE  is  NO , the second agreement analysis is
   suppressed.
   

**LIST LEVEL=**



   
   This directive determines the amount of output produced.
   

*LEVEL=*


   
   ::


            HIGH
            LOW   -  Default value
   


   
   If LEVEL is LOW the  analysis is against Fo and sin theta only.
   
   
   
.. index:: DIFABS

   
.. index:: Least squares absorption corrrection


.. _DIFABS:

 
===============================================
Least squares absorption correction  - \\DIFABS
===============================================




::


    \DIFABS  ACTION= MODE= INPUT=
    CORRECTION THETA=
    DIFFRACTION GEOMETRY= MODE=
    END
   
    \DIFABS ACTION=NEW MODE=FC
    END
   






Although this is a least squares fitting technique for an arbitary
model, it does not form part of the main refinement module. The DIFABS
parameters cannot be refined simultaneously with the atomic parameters.


A low order term Fourier series is used to model an absorption surface for
differences between the observed structure factors and those obtained from a
structure factor calculation after isotropic least squares refinement.

For SERIAL diffractometrs (e.g. CAD4)
Spherical polar angles are used to define the incident and diffracted
beam path
directions so that each reflection is characterised by four angles - viz.
PHI(p),
MU(p), PHI(s), and MU(s).  A theta-dependent correction is evaluated to allow
for diffracted beams with different path lengths occurring at the same polar
angles.  A low order term Fourier series is used in Bragg angle THETA,
but is highly correlated with the temperature factors, and not normally
recommended.
This version is general for any SERIAL diffractometer data collection
geometry.


For AREA detector diffractometers equivalent reflections are usually 
measured at different setting angles and then averaged.   
The concept of incident and emergent beams has no meaning for merged 
data, so instead DIFABS computes the azimuth and declination of the
scattering vector.  This cannot be reliably used as the basis for a 
correction, but the "absorption" surface is a measure of the mis-match
between Fo and Fc.


The quantity minimised is the sum of the squares of the residuals, Rj, where


::


                  Rj = ( //Fc/-/Fo//)wj






The weighting function, wj, used is derived from the overall scale factor,
the counting statistics standard deviation, and the Lorentz-polarisation
factor.


In the original implementation, the correction factor was applied to
Fo. This lead to criticism in the literature that the observations were
being tampered with. In the current implementaion in CRYSTALS, the
correction can be applied to Fo or Fc.






References:
N. Walker and D. Stuart, 1983, Acta Cryst., A39, 158 - 166.
The code is incorporated with the permission of Dr N. Walker




Implementation




The correction is evaluated using observed structure factors, /Fo/, corrected
for Lorentz-polarisation effects and any decay in intensity standards during
data collection, with systematically absent reflections removed. Since
equivalent reflections will be measured at different diffractometer
settings, the  correction should be  calculated and  applied to the data set
without any transformation of the reflection indices, and without
symmetry- equivalent or Friedel-pair reflections being averaged.
Calculated  amplitudes must be obtained from  the  isotropic
refinement of an as-complete a model as practical from the unique (merged)
data set. Such a LIST 6 (reflections, section :ref:`LIST06`) will probably be 
unsuitable for Fourier or
difference maps (since these expect a unique segment of data only) unless
you then remerge the data. The best maps must be computed
with the correction applied to Fo before the data is merged.  In addition,
the most reliable merging R factor (Rint) must be computed from
corrected Fos.



**WARNING**


To use DIFABS most successfully, you should probably do data-reduction
again from scratch, inhibiting the merging of all but exactly equivalent
reflections.


In favourable cases, when the observed data is the unique segment plus a
small redundant volume (e.g. often the -1 layers at Oxford), you may get away
with applying the correction to normally (merged) processed data during
structure development.


Once the structure is fully developed (ie all atoms found
and partially refined with an extinction correction if necessary), data
reduction should be repeated inhibiting all index transformations.
New values of Fc must be computed from
isotropic atoms (Use UEQUIV in \\EDIT to recover equivalent isotropic
temperature factors, and then do a few cylces of isotropic refinement)
and the DIFABS correction applied to Fc. Anisotropic refinement can be
computed to completion (including optimisation of weights) using
unmerged data. If you wish to see an  absorption correctd Rint
and compute a final difference map, the data must be re-merged. Use
DIFABS with MODE = TRANSFER to move the correction onto Fo before
transforming indices, sorting and merging the data.



------------------------------
\\DIFABS  ACTION= MODE= INPUT=
------------------------------

   

*INPUT*


   Indicates which reflection list to use.
   ::


            6      Default
            7      Alternative reflection list
   


   
   

*ACTION=*


   Controls the action on LIST 6 (reflections, section :ref:`LIST06`), and 
   has three values:
   
   ::


            TEST   -   Computes the correction, but does not apply it
            UPDATE -   Tries to update LIST 6
            NEW    -   DEFAULT. Creates new LIST 6
   


   

   
   If UPDATE is specified, the stored values of Fo are over written. If
   NEW is specified, a new LIST 6 is written to disc. The
   disc will be extended sufficiently to accommodate the new list.
   
   

*MODE=*


   Controls the mode of application of the correction, and
   has three values:
   
   ::


            FO        - Applies the correction to Fo
            FC        - Applies the correction to Fc
            TRANSFER  - Applies the inverse of the Fc correction to Fo
   


   
   

**CORRECTION THETA=**


   
   Controls whether a theta-dependent correction is to be
   applied. - NOT RECOMMENDED.
   

*THETA=*


   
   ::


            NO - Default value
            YES
   


   
   

**DIFFRACTION GEOMETRY= MODE=**


   
   Controls the geometry used for data collection to be input.
   

*GEOMETRY=*


   The type of diffractometer used is specified:
   
   ::


            CAD4          - Default value
            SYNTEX-P1
            SYNTEX-P21
            PICKER        - Picker FACS-I
            PW1100        - Philips PW1100
            AREA          - Any Area detector instrument
   


   
   

*MODE=*


   The mode of data collection is given:
   
   ::


            BISECTING      - Default value
            PARALLEL
            GENERAL
   


   
   
   ::


       This example assumes that there are no equivalent reflections.
            \DIFABS
            DIFFRACTION GEOMETRY=SYNTEX-P1
            END
   


   
   ::


       This example demonstrates a total re-processing of the data, including
       converting atoms to isotropic if they have previously been refined
       anisotropically. Note that a theta dependent correction from
       International Tables is applied during data reduction. The theta
       dependant correction in DIFABS is ill-conditioned and unstable.
      
            \ save the contents of the old dsc file
            \PURGE NEW
            END
            \ Connect the reflection file to HKLI
            \OPEN HKLI ZNCPD.HKL
            \ Use an \HKLI command to apply the tabulated theta correction
            \HKLI
            READ NCOEF=12 FORMAT=FIXED UNIT=HKLI F'S=FSQ CHECK=NO
            INPUT H K L /FO/ SIGMA(/FO/) JCODE SERIAL BATCH THETA PHI OMEGA KAPPA
            FORMAT (5X,3F4.0,F9.0,F7.0,F4.0,F9.0,F4.0,4F7.2)
            STORE NCOEF=6
            OUTPUT INDICES /FO/ BATCH RATIO/JCODE SIGMA(/FO/) CORRECTIONS SERIAL
            ABSORPTION PHI=NO  THETA=YES PRINT=NONE
            THETA 16
            THETAVALUES
            CONT 0  5 10 15 20 25 30 35 40 45 50 55 60 65 70 75
            THETACURVE
            CONT 3.61  3.60  3.58  3.54  3.50  3.44  3.37  3.30
            CONT 3.23  3.16  3.09  3.02  2.96  2.91  2.86  2.82
            END
            \LP
            END
            \SYSTEMATIC
            \ preserve the original indices
            STORE NEWINDICES=NO
            END
            \SORT
            END
            \ copy from workfile to disk
            \LIST 6
            READ TYPE=COPY
            END
            \ unit weights
            \LIST 4
            END
            \WEIGHT
            END
            \EDIT
            UEQUIV FIRST UNTIL LAST
            END
            \LIST 28
            MINIMA RATIO =  3.0
            END
            \SFLS
            SCALE
            END
            \ assume there are no H atoms
            \LIST 12
            FULL FIRST(U[ISO]) UNTIL LAST
            END
            \SFLS
            REFINE
            REFINE
            CALC
            END
            \LIST 28
            \ remove all restrictions to get Fcs.
            END
            \DIFABS UPDATE FC
            END
            \ Complete anisotropic refinement, produce publication tables etc
            \LIST 12
            FULL X'S U'S
            END
            \LIST 28
            MINIMA RATIO=3
            END
            \SFLS
            REFINE
            .....
            \CIF
            END
            \ reprocess data so that it can be merged for the final
            \ difference map
            \DIFABS UPDATE TRANSFER
            END
            \SYST
            END
            \MERGE
            END
            \FOURIER
            \ etc etc etc ---
   


   

=================
Internal workings
=================



SOme understanding of the internal data management in CRYSTALS may
help the user to sort out unexplained failures.



.. _LIST9:

 
-----------------------
Parameter esds - LIST 9
-----------------------

   


   
   This list contains the refineable parameter esds.

   
   It is created from LIST 5 and LIST 11 with the instruction
   ::


      
        \ESD
        END
      

   
   

The list can be printed with
   ::


        \PRINT 9
        END
   


   

   
   The instruction \\PUNCH 5 E creates a plain format punch file with
   the atomic parameters and esds.
   
   

.. _LIST22:

 
------------------------------------
Refinement parameter map  -  LIST 22
------------------------------------

   


   
   This list contains the refinement directives in internal format
   and it can only be generated by the computer.
   After the refinement directives have been read in, they are
   stored on the disc in binary format ready for processing.
   Before the structure factor least squares routines can
   use the information in LIST 12, it is necessary to convert them to
   a LIST 22.

   
   If the conversion fails, or the input of LIST 5 or LIST 12
   is in error, LIST 22 will be marked as an error list, and any job
   that attempts to reference LIST 22 will terminate in error.

   
   For complex LIST 12s, i.e. those
   containing EQUIVALENCE, LINK, RIDE, GROUP, WEIGHT or COMBINE, the user is
   strongly advised to issue \\LIST 22 and then \\PRINT 22, and look at the
   LIST 22
   generated. The ouput, which is set out like a LIST 5, shows the
   relationship between the physical and the least squares parameters.
   
   

.. _LIST11:

 
------------------------------------
The least squares matrix  -  LIST 11
------------------------------------

   

   

   
   The matrix that is produced by the structure factor least
   squares process is stored on the disc as a LIST 11. This list may be
   massive, so it is wise to purge the disk regularly with large
   structures. To recover the maximum space, delete the LIST 11 before
   purging.
   ::


            \DISK
            DELETE 11
            END
            \PURGE
            END
   


   

--------------------------------
Printing the contents of LIST 11
--------------------------------

   

   
   LIST 11 is printed by :
   

**\\PRINT 11**


   

**\\PRINT 11 A**


   Prints the largest 10 correlation coefficients whose magnitude is
   greater than 0.25.
   

**\\PRINT 11 B**


   Prints the correlation matrix.
   

**\\PRINT 11 C**


   Prints the current matrix (usually the inverse matrix).

.. _LIST24:

 
------------------------------------
Least squares shift list  -  LIST 24
------------------------------------

   

   

   
   When the normal matrix produced by the least squares process
   has been inverted, a set of shifts is calculated,
   suitably scaled if necessary, to apply to the atomic parameters.
   These shifts are output to the disc as a LIST 24,
   and then applied by the routines that compute the new parameters.
   List 24 can only be generated in the machine.

.. _LIST26:

 
-----------------------------------------
Restraints in internal format  -  LIST 26
-----------------------------------------

   
   


   
   This list contains the restraints in internal format.
   Before the structure factor least squares routines can
   use the information in LIST 16 and 17, it is necessary to
   convert it to an internal format held in LIST 26.

   
   If this operation fails, or the input of LIST 12 or LIST 16
   goes wrong, LIST 26 will be marked as an error list, and any job
   that attempts to reference LIST 26 will terminate in error.
   
