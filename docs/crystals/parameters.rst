.. toctree::
   :maxdepth: 1
   :caption: Contents:



********************************
Atomic And Structural Parameters
********************************


.. _atomparams:

 

=====================================================
Scope of the atomic and structural parameters Section
=====================================================





The areas covered are:



::


    Specifications of atoms and other parameters
    Input of atoms and other parameters              - \LIST 5
    Re-order the atom list                           - \REGROUP
    Collect atoms together by symmetry               - \COLLECT
    Move the structure into the cell                 - \ORIGIN
    Modification of lists 5 and 10 on the disc       - \EDIT
    Applying permitted origin shifts                 - \ORIGIN
    Conversion of temperature factors                - \CONVERT
    Hydrogen placing                                 - \HYDROGENS
    Per-hydrogenation                                - \PERHYDRO
    Re-numbering hydrogen atoms                      - \HNAME
    Regularisation of groups in LIST 5               - \REGULARISE







.. index:: Atom name syntax


============================================
Specifications of atoms and other parameters
============================================



There is a consistent syntax thoughout CRYSTALS for refering to atoms
and atomic parameters. This was referred to briefly in Chapter 1, and
will be defined more fully here.



------------------
ATOM SPECIFICATION
------------------


   
   There are three different but related ways of specifying an atom
   or a group of atoms.
   

**TYPE(SERIAL,S,L,TX,TY,TZ)**



   
   This specification defines one atom.
   The various parts of the expression are :
   

*TYPE*


   The atom type, defined in Chapter 1 in the section on form-factors.
   

*SERIAL*


   The serial number, in the range 1-9999
   

*Checking of serial numbers*



   
   Atoms of the same type are distinguished from one another by having
   different serial numbers. However, at no stage is a check made to ensure
   that there is not more than one atom in LIST 5 (atomic parameters) with 
   the same type and
   serial number. If a routine is searching for an atom with a given type
   and serial number, the first atom found will always be taken, and any
   subsequent atoms with the same type and serial number will be ignored.

   
   Serial numbers are considered to be different if they differ from
   each other by more than 0.0005.
   
   

*S*


   'S' specifies a symmetry operator provided
   in the unit cell symmetry LIST (LIST 2 - see section :ref:`LIST02`).
   'S' may take any value between '-NSYM' and
   '+NSYM', except zero, where 'NSYM' is the
   number of symmetry equivalent positions
   provided in LIST 2.
   if 'S' is less than zero, the coordinates
   of the atom stored in LIST 5 are negated (i.e.
   inverted through a centre of symmetry at
   the origin) and then multiplied by the
   operator specified by the absolute value of
   'S' to generate the new atomic coordinates.
   'S' may be less than zero even if the space
   group is non-centrosymmetric ( *i.e.* introduce a false centre),
   but must not be greater than 'NSYM'.
   The default value for 'S' is '1', specifying the
   first matrix in LIST 2, usually the unit matrix.
   
   

*L*


   'L' specifies the non-primitive lattice translation
   that is to be added after the coordinates have been
   modified by the operations given by 'S'.
   'L' must not be greater than the number of allowed
   non-primitive translations in the space group.
   The translations provided by 'L' depend on
   the lattice type and are given by :
   
   ::


                L=    1             2                3                4
      
            P       0,0,0
            I       0,0,0      1/2,1/2,1/2
            R       0,0,0      1/3,2/3,2/3      2/3,1/3,1/3
            F       0,0,0        0,1/2,1/2      1/2, 0 ,1/2      1/2,1/2,0
            A       0,0,0        0,1/2,1/2
            B       0,0,0      1/2, 0 ,1/2
            C       0,0,0      1/2,1/2, 0
   


   
   the default value of 'L' is '1', specifying no
   non-primitve lattice translation.
   
   

*TX,TY,TZ*


   Unit cell translation along the x,y and z directions.
   
   
   The unit cell translations are added to the
   coordinates after the 'S' and 'L' operations
   have been performed.
   The translations may be positive or
   negative, but must refer to complete
   unit cell shifts.
   The default values for 'TX', 'TY' and 'TZ'
   are all zero, giving no unit cell translations.
   
   
   The symmetry operations are applied in the order :
   
   ::


            1.  Centre of symmetry if 'S' negative
            2.  Symmetry operator 'S'
            3.  Non-primitve lattice translation
            4.  Whole unit cell translations 'T(X)', 'T(Y)', 'T(Z)'.
      
          i.e.
                 X'=  [R(s)](+X) + t(s) + L + T(X) + T(Y) + T(Z)
          or
                 X'=  [R(s)](-X) + t(s) + L + T(X) + T(Y) + T(Z)
   


   

   
   The format given above is a complete atom definition.
   For convenience the definition may sometimes be shortened.
   The obligatory parts are the  TYPE  and  SERIAL.
   The remaining parameters, S,  L,  TX,  TY, TZ, are optional.

   
   An optional parameter taking its default value
   may be omitted, though its place must be marked by its associated
   comma. A series of trailing commas may be omitted.

   
   The following are all equivalent :
   
   ::


            TYPE(SERIAL,1,1,0,0,0)
            TYPE(SERIAL,,,0,0,0)
            TYPE(SERIAL,1,,,,0)
            TYPE(SERIAL,,,,,)
   


   

   
   The values of  S ,  L ,  TX ,  TY  and  TZ  are exactly those
   output and used by the distance angles routines under the headings
   S(I) ,  L ,  T(X) ,  T(Y)  and  T(Z)  respectively.
   (See the section of the user guide on 'results of refinement').

   
   When the symmetry operators are applied, the actual values
   of  S  and  L  are checked to see that they are reasonable.
   If the values found are not reasonable, an error message will
   be output and the job terminated.

   
   In some cases, the symmetry operators are accepted on input,
   but not used by the routine. The description of the routine will state this.
   
   
   

**UNTIL sequences**


   When a group of atoms lie sequentially in the atom parameter list,
   there is an abbreviated way to refer to the group.
   ::


            TYPE1(SERIAL1,S,L,TX,TY,TZ)  UNTIL  TYPE2(SERIAL2)
   


   

   
   This definition specifies all the
   atoms in the current list starting with the atom TYPE1(SERIAL1)
   The first atom in the specification must  occur before the second atom
   in the current parameter list,
   otherwise an error message will be output and the task aborted.
   If symmetry operators are used, they must be given for the first atom
   of the sequence, and will be appied to all  the atoms in the sequence.
   
   
   ::


            Examples
      
                        C(1) until C(6)
      
            Six atoms lying around a centre of symmetry:
      
                        C(1) until C(3) C(1,-1) UNTIL C(3)
   


   
   

**FIRST   AND   LAST**



   
   These specifications each define one atom.   FIRST  Refers to the
   first atom stored in LIST 5 (the model parameters) or LIST 10
   (Fourier peaks), and  LAST  refers to the last atom in the
   list. If these are used as atom designators, no serial number may be given,
   but symmetry operators may be. They may be used in until sequences.
   
   ::


            examples
                        LAST
                        FIRST(x)
                        FIRST(-1) UNTIL C(16)  C(23) UNTIL LAST
   


   
   

**ALL**



   
   This specifies all atoms in the list, can take symmetry
   operators or parameter names, but cannot be accompanied on the same line
   by any other atom specifiers.
   
   ::


            examples
                        ALL
                        ALL(x)
                        ALL(-1)
   


   
   

**RESIDUE**



   
   This specifies all atoms or parameters with the given residue number.
   
   ::


            examples
                        RESIDUE(3)
                        RESIDUE(3,X's)
   


   
   

**PART**



   
   This specifies all atoms or parameters with the given part number.
   
   ::


            examples
                        PART(3001)
                        PART(3001,X's)
   


   
   The part number is constructed from two values, the assembly number and
   the group number.
   ::


          PART NO. = 1000 * ASSEMBLY NO. + GROUP NO.
   


   
   
   
   The assembly number is normally zero, but a value
   can be given to all atoms that are involved in a particular disordered
   area of the structure. E.g. on a disordered methyl all the H atoms could
   be placed in assembly number 1.
   
   
   The group number within an assembly groups together those atoms which
   are simultaneously occupied. E.g. on a disordered methyl, all the H atoms
   approximately 109 degrees apart would be given the same group number.
   
   
   The part and group numbers affect the default bonds that are determined
   by CRYSTALS, and subsequently output in the CIF or summary file. Some
   bonding rules are applied in the following order of priority:
   ::


      1. An atom in assembly 0, group 0, will bond to any other nearby atom.
      2. Atoms in the same assembly, but with different, non-zero group numbers
         will not bond to each other.
      3. Atoms in different assemblies with one zero group number
         will not bond to each other.
      4. Atoms in the same assembly and group, but with a negative group number
         will not bond to symmetry related atoms in the same assembly and group.
      5. All remaining close contacts will be bonded together.
   


   
   Rule 3 may be ignored unless you're trying to set up something very
   special. Rule 4 is useful if you have a group disordered across a
   symmetry element.
   
   
   Finally, you can select all atoms in a given part of group by using the number 999 as a wild-card.
   
   ::


            examples
                        PART(3999,X's)
            selects all atoms in assembly 3.
   


   
   
   
   

**HPART**



   
   This specifies all hydrogen (or deuterium) atoms or parameters with the given part number.
   
   ::


            examples
                        HPART(3001)
                        HPART(3001,X's)
   


   
   

**NHPART**



   
   This specifies all non-hydrogen (and deuterium) atoms or parameters with the given part number.
   
   ::


            examples
                        NHPART(3001)
                        NHPART(3001,X's)
   


   
   

**TYPE**



   
   This enable all atoms or parameters on atoms of the given type to be 
   processed together.
   ::


            example
            /EDIT
            RESET 9900 PART TYPE(H)
            END
   


   

   
   This puts all the hydrogen atoms into PART(9900). Since all other 
   atoms are in PART(0) or a specified PART, the hydrogen will now be 
   treated independently.
   
   
   
   
   

------------------------------
ATOMIC PARAMETER SPECIFICATION
------------------------------


   
   Atomic parameters have a NAME. Some directives permit the use of the
   parameter name by itself, which implies that parameter for all atoms.
   The parameter name may be combined with an atom specifier, in which case
   only the parameter for that atom (or group in an UNTIL sequence) is
   referenced. Symmetry operators may be used. The normal drop-out rules
   apply.
   

**Parameter NAMES**



   
   The following NAMES are recognised.
   
   ::


            X      Y      Z      OCC      U[ISO]    SPARE
            U[11]  U[22]  U[33]  U[23]    U[13]     U[12]
            X'S    U'S    UIJ'S  UII'S
   


   
   
   ::


            Examples
              X            The 'x' coordinate for all atoms
              C(9,X,Y)     The 'x' and 'y' coordinates for atom C(9)
              FIRST(X'S)   The 'x','y' and 'z' coordinates for the first atom
              FIRST(U'S) UNTIL C(23)
                           The anisotropic temperature factors for all atoms
                           up to C(23).
   


   
   

**Temperature factor definitions**


   

*Isotropic temperature factor*


   ::


       The isotropic temperature factor is defined by:
      
             T = exp(-8*pi*pi*U[iso]*s**2)
                                             where s = sin(theta)/lambda
   


   
   

*Anisotropic Temperature Factor*


   ::


            The anisotropic temperature factor (adp) is defined by:
      
             T = exp(-2*pi*pi*(h*h*a'*a*u[11]
                              +k*k*b'*b'*u[22]
                              +l*l*c'*c'*u[33]
                          +2.0*k*l*b'*c'*u[23]
                          +2.0*h*l*a'*c'*u[13]
                          +2.0*h*k*a'*b'*u[12])).
                                             where x' are the reciprocal
                                             cell parameters and h, k and
                                             l are the Miller indices
   



*Uequiv*



   
   CRYSTALS contains two definitions od Uequiv. Both definitions are acceptable
   to Acta. The arithmetic mean of the principle axes is often similar
   to the refined value of Uiso. The geometric mean is more sensitive to
   long or short axes, and so is more useful in publications. Ugeom is the
   sphere with the same volume as the ellipsoid.
   ::


            U(arith) = (U1+U2+U3)/3
            U(geom)  = (U1*U2*U3)**1/3
                                          Where Ui are the principal axes of
                                          the orthogonalised tensor.
   


   
   
   
   **CAUTION**

   
   It should be noted that if a set of anisotropic atoms are input with
   the
   FLAG  key set to anything but 0, then the parameters will be
   interpreted as Isotropic atoms, or special shapes.
   
   
   

**Uequiv**


   Two expressions are available for the equivalent temperature factor
   (the geometric or arithmetric mean of the principal components).
   The Immediate Command 'SET UEQUIV' sets which definition will be used.
   
   
   ::


            Ugeom  = (Ui * Uj * Uk)**1/3
      
            Uarith = (Ui + Uj + Uk)/3
                                             Where Ui, Uj & Uk are the
                                             principal components of U
      
            Ugeom is the radius of the sphere with the same volume as the adp
            ellipsoid, and thus gives a good indication of the quality of the
            ellipsoid. Uarith is often closer to the value of Uiso, and so is
            useful for returning to an isotropic refinement.
   


   
   

**The Special Shapes**



   
   
   The SPecial Shape keys are
   
   ::


      
            type serial occ FLAG x y z u[11]  u[22] u[33] u[23] u[13] u[12] spare
                                       U[ISO]                               spare
                                       U[ISO] SIZE                          spare
                                       U[ISO] SIZE  DECLINAT AZIMUTH        spare
      
   


   
   
   The value of 'FLAG' is used on input of atoms to indicate what kind of
   patameters will follow, and is used during calculations for the
   interpretation of the parameters.
   
   

*FLAG interpretation*


   The following table shows the interpretation of the FLAG parameter.
   ::


      
      FLAG        meaning          parameters
      
      'normal' types of atoms:
      
       0          Aniso ADP        u[11]  u[22] u[33] u[23] u[13] u[12]
       1          Iso ADP          U[ISO]
      
      New 'special' shapes:
      
       2          Sphere           U[ISO] SIZE
       3          Line             U[ISO] SIZE  DECLINAT AZIMUTH
       4          Ring             U[ISO] SIZE  DECLINAT AZIMUTH
      
   


   
   

   
   The parameters have the following meaning for the new special shapes:
   

*Special U[iso]*


   U[iso] is related to the 'thickness' of the line, annulus or shell.
   

**Special SIZE**


   SIZE is the length of the line, or the radius of the annulus or shell.
   

*Special DECLINAT*


   DECLINAT is the declination angle between the line axis or annulus normal and the
   *z*
   axis of the usual CRYSTALS orthogonal coordinate system, in
   degrees/100.
   

*Special AZIMUTH*


   AZIMUTH is the azimuthal angle between the projection of the
   line axis or annulus normal onto the *x* - *y* plane and the *x*
   axis of the usual CRYSTALS orthogonal coordinate system, in
   degrees/100.
   

   
   If either of these angles is input with a value greater than 5.0, it
   is assumed that the user has forgotten to divide by 100, which is thus
   done automatically.
   
   
   
   

-------------------------------
OVERALL PARAMETER SPECIFICATION
-------------------------------


   
   Overall parameters are specified simply by their keys.
   The following overall parameter keys may be given :
   
   ::


            SCALE      OU[ISO]      DU[ISO]      POLARITY
            ENANTIO    EXTPARAM
   


   
   

*SCALE*


   This parameter defines the overall scale factor and has a default value
   of unity.
   It is the number by which /FC/ must be multiplied to put
   it onto the scale of /FO/, i.e. /Fo/ = scale*/FC/.
   

*DU[ISO]*


   This parameter is the dummy overall isotropic temperature factor and has
   a default value of 0.05.

   
   The dummy overall temperature factor is in no way related to the overall
   temperature factor, and its use is explained in the input of LIST 12,
   which comes in the section of the user guide on 'structure factors'.
   

*OU[ISO]*


   This parameter is the overall isotropic temperature factor and has a default
   value of 0.05.
   

*POLARITY*


   This is the Rogers *eta* parameter, and  is a  multiplier for the
   imaginary part of the anomalous
   scattering factor.
   Setting the value to 1.0 (its default) has the effect of using the
   imaginary part
   of the anomalous scattering factor as given.
   Changing the value to
   -1.0 has the effect of changing the hand of the model. Setting the value
   at zero has the effect of removing the contribution of f". However, if
   contributions from f" are not required, IT IS MORE EFFICIENT to set ANOMALOUS
   = NO in LIST 23 (structure factor control, see section :ref:`LIST23`). If you 
   need to use f", remember not to
   apply Friedel's law (LIST 13, section :ref:`LIST13`) during data reduction
   (section :ref:`DATAREDUC`),
   and to include anomalous scattering (LIST 3, section :ref:`LIST03` and
   LIST 23, section :ref:`LIST23`). See D. Rogers, Acta Cryst (1981), 
   A37,734-741. *POLARITY*
   *and* *ENANTIO* *should* *not* *be* *used* *simultaniously.*
   

*ENANTIO*


   This overall parameter is the fractional contribution of F(-h) to the observed
   structure amplitude, and like the POLARITY parameter is sensitive to the
   polarity of the structure. It is defined by
   ::


             Fo**2 =(1-x)* F(h)**2 + x*F(-h)**2
   


   
   where x is the ENANTIOpole parameter. A value of 0.0 means the structure
   stored in LIST 5 is of the correct hand. A value of 1.0 inverts the structure.
   Its effect on the structure factor is switched on or off by the parameter
   ENANTIO in LIST 23 (see section :ref:`LIST23`). Computations are more efficient 
   when it is turned off.
   If the enantiopole is used (or refined) then Friedel's law must not be applied
   (LIST 13, section :ref:`LIST13`) and anomaloue scattering must 
   be included (LIST 13 and LIST 23).
   See Howard Flack, Acta Cryst, 1983, A39, 876-881. This parameter
   is more robust than the POLARITY parameter.
   See also section in Results.
   

*EXTPARAM*


   This parameter is Larson's extinction parameter , r*, (equation 22 in
   A.C. Larson, Crystallographic Computing, 1970, 291-294, ed F.R.
   Ahmed, Munksgaard, Copenhagen , but with V
   replaced by the cell volume)
   and has a default value of zero.

   
   Note that many other programs use expression (4),
   which cannot cope with Neutron data, and  gives a value for 'g'
   which is about 1,000,000 times smaller than 'r*'.
   
   ::


             g ~= [(e**2/mc**2)**2 . lambda**3/V**2 . Tbar ] . r*
   


   
   Tbar is the absorption weighted mean path length, and is assumed to be
   stored in
   LIST 6 (section :ref:`LIST06`) with a key of  TBAR . If this key is 
   absent, a default value of 1.0
   is used. If extinction is to be included in the model, the mosaic spread
   should have been set in LIST 13 (section :ref:`LIST13`).
   
   
   
   
.. index:: LIST 5

   
.. index:: Input of atoms and other parameters


.. _LIST05:

 
==============================================
Input of atoms and other parameters  -  LIST 5
==============================================




::


    \LIST 5
    OVERALL SCALE= DU[ISO]= OU[ISO]= POLARITY= ENANTIO= EXTPARAM=
    READ NATOM= NLAYER= NELEMENT= NBATCH=
    either ATOM TYPE= SERIAL= OCC= FLAG= X= Y= Z= U[11]= ....U[12]=
    or     ATOM TYPE= SERIAL= OCC= FLAG= X= Y= Z= U[ISO]
    INDEX P= Q= R= S= ABSOLUTE=
    LAYERS SCALE=
    ELEMENTS SCALE=
    BATCH SCALE=
   





::


    \LIST 5
    OVERALL SCALE=0.123
    READ NATOM=2 NELEMENT=2
    ATOM PB 1 FLAG=0 .25 .25 .25 .03 .03 .03 .0 .0 .0
    ATOM C 2  X= .23 .13 .67
    ELEMENTS 0.8 0.2
    END
   





--------
\\LIST 5
--------

   

**OVERALL SCALE= DU[ISO]= OU[ISO]= POLARITY= ENANTIO= EXTPARAM=**



   
   This directive specifies various parameters that refer to the
   structure as a whole.
   

*SCALE=*


   The overall scale factor, default = 1.0
   

*DU[ISO]=*


   The dummy overall isotropic temperature factor, default = 0.05.
   

*OU[ISO]=*


   The overall isotropic temperature factor, default = 0.05.
   

*POLARITY=*


   Rogers *eta* parameter (see above), default = 1.0.
   

*ENANTIO=*


   Flack enantiopole parameter (see above), default = 0.0.
   

*EXTPARAM=*


   Larson r* secondary extincion parameter, default = 0.0.
   

**READ NATOM= NLAYER= NELEMENT= NBATCH=**



   
   This directive specifies the number of atoms, layer scale factors,
   element scale factors, and batch scale factors that are to follow.
   

*NATOM=*


   The number of atom directives to follow, default = 0.
   

*NLAYER=*


   The number of layer scale factors to follow, default = 0.
   

*NELEMENT=*


   The number of element scale factors to follow, default = 0.
   

*NBATCH=*


   The number of batch scale factors to follow, default = 0.
   

**ATOM TYPE= SERIAL= OCC= FLAG= X= Y= Z= U[11]= ..**



   
   The parameters for an atom, repeated NATOM times.
   

*TYPE=*


   The atomic species, an entry for which should exist
   in LIST 3 (see section :ref:`LIST03`). There is no default value.
   

*SERIAL=*


   The atoms serial number. There is no default value.
   

*OCC=*


   This parameter defines the site occupancy **EXCLUDING** special position
   effects (i.e. is the 'chemical occupancy). The default is 1.0.
   Special position  effects are computed by CRYSTALS and multiplied onto
   this parameter.
   

*FLAG=*


   This parameter specifies the type of temperature factor for the atom,
   and if it is omitted a default value of 1 is assumed. **NOTE** that it
   **must** be set to 0 for anisotropic atoms.
   

*X= Y= Z=*


   These parameters specify the atomic coordinates for the atom, for which
   there are no default values.
   

*U[11]= U[22]= U[33]= U[23]= U[13]= U[12]=*


   These parameters have different interpretations depending upon the
   value of FLAG

   
   
   If FLAG=0

   
   These parameters specify the anisotropic temperature factors for the atom
   and if they are omitted default values of zero are assumed.
   The order of the
   cross terms is obtained by dropping 1,2,3 sequentially from [123].

   
   
   If FLAG=1

   
   The first parameter specifies the isotropic temperature factor, which
   defaults to 0.05.

   
   
   If FLAG=2,3 or 4, the six parameters represented by u[ij] have the
   following imterpretation:
   
   
   ::


      KEY   shape      parameters
      
       2    Sphere     U[ISO] SIZE
       3    Line       U[ISO] SIZE  DECLINAT AZIMUTH
       4    Ring       U[ISO] SIZE  DECLINAT AZIMUTH
      
   


   
   

   
   The parameters have the following meaning for the new special shapes:
   

*Special U[iso]*


   U[iso] is related to the 'thickness' of the line, annulus or shell.
   

**Special SIZE**


   SIZE is the length of the line, or the radius of the annulus or shell.
   

*Special DECLINAT*


   DECLINAT is the declination angle between the line axis or annulus normal and the
   *z*
   axis of the usual CRYSTALS orthogonal coordinate system, in
   degrees/100.
   

*Special AZIMUTH*


   AZIMUTH is the azimuthal angle between the projection of the
   line axis or annulus normal onto the *x* - *y* plane and the *x*
   axis of the usual CRYSTALS orthogonal coordinate system, in
   degrees/100.
   

   
   If either of these angles is input with a value greater than 5.0, it
   is assumed that the user has forgotten to divide by 100, which is thus
   done automatically.
   
   
   

**INDEX P= Q= R= S= ABSOLUTE=**



   
   This directive is used to input the constants that define an index
   for layer scaling. The layer scale index for the reflection with indices
   HKL  is computed from
   
   ::


            index = (h*p + k*q + l*r + s)
   


   
   and the absolute value is taken if the parameter  ABSOLUTE  = yes.
   

*P= Q= R=*


   These parameters have default values of zero.
   

*S=*


   This parameter has a default value of unity. The zeroth layer must have
   an index of 1.
   

*ABSOLUTE=*


   
   ::


            NO
            YES  -  Default value
   


   
   

**LAYERS SCALE=**



   
   This directive defines the layer scale factors, starting with the scale
   for an index of 1.
   

*SCALE=*


   This parameter gives the layer scale, and has a default value of 1.
   It is repeated  NLAYER  times.
   

**ELEMENTS SCALE=**



   
   This directive defines the scale factors for the elements of a twinned
   structure. See the chapter on twinned structures.
   

*SCALE=*


   This parameter gives the element scale factor, and has a default value
   of 1. It is repeated  NELEMENT  times - the number of components
   in the twin.
   

**BATCH SCALE=**



   
   This directive defines the batch scale factors.
   

*SCALE=*


   This parameter gives the batch scale factor, and has a default value of 1.
   It is repeated  NBATCH  times. Remember to set appropriate keys in LIST
   6
   
   

-----------------------------------
Further examples of parameter input
-----------------------------------

   
   ::


       ATOM TYPE=C,SERIAL=4,OCC=1,U[ISO]=0,X=0.027,Y=0.384,Z=0.725,
       CONT U[11]=0.075,U[22]=0.048,U[33]=.069
       CONT U[23]=-.007,U[13]=.043,U[12]=-.001
       ATOM C 5 U[ISO]=0.0 .108,.365,.815,.074
       CONT .051 .065 -.015 .048 -.014
       ATOM C 2 1 0.05 0.149 0.411 0.651 0 0 0 0 0 0
       ATOM C 1 X=0.094,Y=0.343,Z=0.890
       ATOM C 3 X=0.050 0.406 0.648
   


   

============================
Printing and punching list 5
============================


---------
\\PRINT 5
---------

   Lists the current LIST 5 to the printer file.

--------------
\\PUNCH 5 mode
--------------

   Mode controls the format of the file.
   ::


              -  Punches the model parameters in CRYSTALS format.
            A -  Punches the model parameters in CRYSTALS format.
            B -  Punches the atomic parameters in XRAY format.
            C -  Punches the atomic parameters in SHELX format.
            E -  Punches atomic parameters and esds in a plain format
   


   

-------------------------------------
Summary display of LIST 5 - \\DISPLAY
-------------------------------------

   
   ::


       \DISPLAY LEVEL=
       END
      
       \DISP HIGH
       END
   


   

   
   This allows the user to display a summary of the contents
   of list 5.  The  output is sent to both monitor and listing channels, so
   the contents of list 5 can be examined on-line during interactive work.
   The output produced is more compact than that from PRINT 5, and various
   levels of detail can be selected.
   The command required is :-

-------------------
\\DISPLAY    LEVEL=
-------------------


   
   DISPLAY has one  optional  parameter.
   
   

*LEVEL*


   ::


            LOW
            MEDIUM
            HIGH
   


   

   
   The effects of this parameter are :-

   
   LOW            The names of the atoms, overall parameters,
   and any layer, batch, and element scales in list 5 are displayed.

   
   MEDIUM         Each atom in list 5 is displayed with its type, serial,
   occupancy, isotropic temperature factor ( if any ), and positional parameters.
   The values of the overall parameters and of any layer, batch, and element
   scales are displayed.

   
   HIGH           All of the parameters of each atom in list 5 are
   displayed. The values of the overall parameters, and of any layer, batch,
   and element scale factors are displayed.
   
   
   
   
   
.. index:: EDIT

   
.. index:: Editing structural parameters


=======================================
Editing structural parameters -  \\EDIT
=======================================

::


    \EDIT INPUTLIST= OUTPUTLIST=
    
    EXECUTE
    SAVE
    QUIT
    LIST LEVEL
    MONITOR LEVEL
    END
   
    ADD  VALUE PARAMETERS  ...
    AFTER  ATOM-SPECIFICATION
    ANISO  ATOM-SPECIFICATIONS  .  .
    ATOM TYPE= SERIAL= OCC= FLAG= X= Y= Z= U11= ..
    CENTROID Z ATOM-SPECIFICATION ...
    CHANGE  PARAMETER-SPECIFICATION VALUE ...
    COPYXYZ ATOM-PAIRS
    COPYUIJ ATOM-PAIRS
    CREATE Z ATOM-SPECIFICATION  ...
    DELETE  ATOM SPECIFICATIONS  .  .
    DEORTHOGINAL  ATOM-SPECIFICATION . .
    DIVIDE  VALUE  PARAMETERS  ...
    DSORT TYPE1 TYPE2 ...
    INSERT IDENTIFIER
    KEEP  Z ATOM-SPECIFICATIONS ...
    MOVE Z ATOM-SPECIFICATION  ...
    MULTIPLY  VALUE  PARAMETERS  ...
    PERTURB VALUE PARAMETERS ...
    REFORMAT
    RENAME ATOM1  ATOM2  (, ATOM1  ATOM2) ...
    RESET PARAMETER-NAME VALUE ATOM-NAMES
    ROTATE ANGLE ATOM VECTOR ATOM-SPECIFICATION
    ROTATE ANGLE ATOM1 ATOM2 ATOM-SPECIFICATION
    ROTATE ANGLE POINT VECTOR ATOM-SPECIFICATION
    SELECT ATOM-PARAMETER  OPERATOR  VALUE, . .
    SHIFT  V1, V2, V3   ATOM-SPECIFICATION . .
    SORT KEYWORD
    SORT TYPE1 TYPE2 ...
     SPLIT Z ATOM-SPECIFICATION ...
    SUBTRACT  VALUE  PARAMETERS  ...
    SWAP ATOM-PAIRS
    TRANSFORM  R11, R21, R31, . . . R33  ATOM-SPECIFICATION . .
    TYPECHANGE KEYWORD OPERATOR VALUE NEW-ATOM-TYPE
    UEQUIV  ATOM-SPECIFICATIONS  .  .
   
    LINE NEWSERIAL ATOMLIST
    RING NEWSERIAL ATOMLIST
   SPHERE NEWSERIAL ATOMLIST





::


    LIST LOW
    TYPECHANGE TYPE EQ Q C
    SELECT U[ISO] LT 0.1
    ADD  0.25 X
    RENAME C(1) S(1)
    CHANGE  S(1,OCC) UNTIL O(1) .5
    KEEP  1 FIRST UNTIL LAST
    L L
    SPLIT 100 C(45)
    DELETE  C(46) UNTIL LAST
    RESET OCC 1.0 ALL









This is a powerful crystallographic editor for
modifying a LIST 5 (the model parameters) or LIST 10 (Fourier peaks).
It offers the editing facilities frequently needed
for the management of atom parameters, including conditional operations
and arithmetic.




EDIT is a semi-interactive command, in that each directive is
computed as soon as its input is complete. Since CONTINUE can be used
to extend a directive over several lines, completion is indicated be
the start of a new directive, or the special directive EXECUTE.


After the terminating END, the resulting list is
output to the disc.
However if the list has not been changed, a new list will be created only
if the list type is being changed ( e.g. 10 to 5 ).
The current edited version of the list can be saved at
any time to protect against future editing mistakes ( the SAVE directive ).
It is also possible to abandon editing without creating a new list ( the QUIT
directive ).


When used in interactive mode, a new list is created even though errors may
have occured during command input unless the QUIT directive is used. In
online and batch modes no new list will be created if errors occured
during the edit. In this case an error message in generated.


Take care to note that some directives refer to atom or group of atoms,
others refer to one or more parameters, and two
(CHANGE  and  SELECT)will refer to either an atom specification
or a parameter specification.
Although atom definitions can include a series of symmetry operators,
the only directives that will use them are those
for which the subsequent description explicitly states that the
symmetry operators are used.
In all other cases, the symmetry information will be read in without any
error messages and ignored.
Those operations which require a single parameter type as argument
(ADD,  MULTIPLY  etc ) will fail if composite parameters ( "U'S", etc )
are given.




---------------------------
\\EDIT INPUTLIST OUTPUTLIST
---------------------------

   
   

*INPUTLIST*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   

   
   
   

*OUTPUTLIST*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   

   
   
   

**EXECUTE**


   This directive which has no parameters does nothing to the edited list. It
   is provided to allow the user to see the results of one operation (
   initiated by the directive whose input is terminated by EXECUTE ) before
   attempting the next.
   

**SAVE**


   Forces the current atom list to be writen to disk.
   

**QUIT**


   This directive will cause the edit to be abandoned without the creation
   of a new list if it is followed by
   END . If it is followed by any other directive it is ignored.

   
   
   

**LIST LEVEL**


   This directive produces a list of the current edited list in the monitor
   output stream and in the listing file. If KEEP has been used, the atoms
   which will be kept are indicated.
   The possible values for 'level' are :-
   
   ::


            OFF               No listing produced
            LOW               Type and serial listed
            MEDIUM            Type , serial , occ , u[iso] ,
                              x , y , z listed
            HIGH              All atomic parameters listed
   


   
   

**MONITOR LEVEL**


   This directive controls the level of monitoring of editing operations. When
   each operation is performed, the results can be monitored in the monitor
   channel and in the listing file. Four levels of monitoring are provided. The
   inital level and the default level used when no value is specified is
   'MEDIUM'. The possible values of the parameter 'level' are :-
   
   ::


            OFF          No monitoring occurs
            LOW          Type and serial only are displayed
            MEDIUM       Program selects level of display   (default)
            HIGH         At least the level represented by
                         'MEDIUM' listing is displayed
   


   

   
   When the program selects a monitor level account is taken of the
   amount of relevant information for the particular directive. Thus for
   DELETE only 'type' and 'serial' need be displayed whereas for CHANGE
   all parameter values are displayed.
   

**END**


   This must be the last directive in the set of modification directives, 
   and writed the list to disk.
   
   
   
   
   
   
   
   
   
   
   

**ADD  VALUE  PARAMETERS  ...**


   
   
   

**AFTER  ATOM-SPECIFICATION  ...**



   
   This defines the atom in the list after which atoms
   that are  MOVEd  should be placed.
   (See  MOVE  below).
   If this directive is omitted, the default option places the first  MOVED
   atom at the head of the list, and successive atoms after it.
   Once one  AFTER  directive has been given, atoms are placed behind the
   given atom in the order in which they are presented on  MOVE  directives.
   If no atom specification is given on this directive, subsequent MOVEs will move
   the atoms  to the  head of the list.
   
   
   

**ANISO  ATOM SPECIFICATIONS  .  .**


   This directive causes all the specified atoms to be converted so that they
   have anisotropic temperature factors.
   If an atom is already anisotropic, no action is taken, and any symmetry
   operators given are ignored.
   If this directive is given with no arguments, all the atoms in the current
   atomic parameter list are converted to anisotropic temperature factors.

   
   Note that   the anisotropic temperature factor produced by this operation
   is in fact still spherically symmetrical, and
   that the s.f.l.s.
   routines automatically ensure that when the temperature factor of an atom
   is to be  refined, it is in the correct form.
   
   
   

**ATOM TYPE SERIAL OCC FLAG X Y Z U11 ..**


   This directive causes the system to add an atom to the
   end of the edited list. The format is the same as that used in \\LIST 5 (see
   section :ref:`LIST05`).
   Values must be provided for 'type' , 'serial' , 'x' , 'y' , and 'z' .
   Default values are provided for the other parameters as in \\LIST 5.
   Example :
   ::


       ATOM O 1 X = 0.3427 .89004 .09181
   


   
   

**CENTROID Z ATOM-SPECIFICATION ...**


   A new atom is created at the centroid of the specified atoms, and with
   a pseudo adp representing the inertial tensor (ie the 'shape' of the
   group). The atom TYPE is QC, and its serial Z.
   The sequence Z ATOM-SPECIFICATIONS can be repeated.
   
   
   

**CHANGE  ARG(1)  ARG(2)  ARG(3)  .**


   There are two possible formats for each 'ARG(i)' on this directive.
   the first is :
   ::


       PARAMETER(i)  VALUE(i)
   


   
   If  ARG(i)  is of this form, the specified parameter or parameters
   are changed to the value  VALUE(i) .
   If  PARAMETER(i)  defines one or more atomic parameters, then the
   symmetry operators found or inserted by default
   are applied to the resulting set of atomic parameters.
   For overall parameters,
   no symmetry information can be provided.
   The  VALUE  associated with this argument must always be present.

   
   The second form of  ARG(i)  on this directive is :
   ::


       ATOM-SPECIFICATION
   


   
   For this form of  ARG(i) , the symmetry operators given in the
   atom specification or assumed by default are applied, but no
   other atomic parameter is explicitly altered.
   There is no  VALUE  associated with  ARG(i)  in this format.

   
   The two different types of argument on this directive may be used
   interchangeably :
   
   ::


            CHANGE  S(1,OCC) UNTIL O(1) .5
            CONT    C(1,-2,1) UNTIL C(12)
            CONT    C(13,X) .0179
   


   
   
   
   

**COPYXYZ  ATOM-PAIRS  ...**


   This directive COPIES the XYZ coordinates of the first atom into
   the second atom.  The other parameters are left  unchanged.  
   
   
   
   
   

**COPYUIJ  ATOM-PAIRS  ...**


   This directive COPIES the Uij coordinates of the first atom into
   the second atom.    The other parameters are left  unchanged.
   
   
   
   
   

**CREATE Z ATOM-SPECIFICATION  ...**


   This directive applies the symmetry operators given or assumed by default
   in the atom specification, and creates a set of new atoms from those given.
   The new atoms are added at the end of the current list. The serial numbers
   of the new atoms are given by:
   ::


            NEWSERIAL = Z + OLDSERIAL
   


   
   The sequence Z ATOM-SPECIFICATIONS can be repeated.
   When moving from a centrosymmetric to a non-centrosymmetric space group,
   for example, atoms formerly related by the centre of symmetry can be
   generated :
   ::


            CREATE 30 MO(1,-1) UNTIL C(15)
      
            Creates atoms MO(31) until C(45)
   


   
   

**DELETE  ATOM SPECIFICATIONS  .  .**


   All the specified atoms are removed
   from the current atomic parameter list.
   Deleted atoms should not be referenced by subsequent directives.
   
   
   

**DEORTHOGINAL  ATOM SPECIFICATION . .**


   This directive applies the matrix vector saved by a previous MOLAX SAVE
   directive to the atoms given  in the atom specification. THEIR ORIGINAL
   COORDIANATES x,y,z MUST be in the MOLAX coordinate (Angstrom) system
   This directive does not create new atoms, but simply modifies
   those already present. Symmetry operators are not permitted.
   
   
   

**DIVIDE  VALUE  PARAMETERS  ...**


   These directives causes the 'value' to be applied to the parameter.
   'PARAMETER(I)' may be an overall parameter, or a single atomic
   parameter of one  or more atoms, as defined above.
   Any symmetry operators given with this directive will be ignored.
   Note that the parameter SERIAL is numeric, and so can be arithmetically
   modified.
   
   
   

**DRENAME ATOM1 ATOM2**


   Used by SCRIPTS to avoid name clashes.
   
   
   

**DSORT TYPE1 TYPE2 ...**


   

**DSORT KEYWORD**


   This directive is exactly analagous to SORT, below, except that it sorts
   into descending order.
   
   
   

**INSERT IDENTIFIER=NAME**


   This directive inserts the value of the named identifier into the
   parameter 'SPARE' in the atom list, replacing any previous value
   (except 'RESIDUE' which uses the 'RESIDUE' paramter in the atom list).
   SPARE is normally used to hold rho after Fourier maps.

   
   Currently available values for NAME are
   
   
   
   
   ELECTRON - This inserts the atomic electron count calculated
   from the form factor
   
   WEIGHT - This inserts the atomic weight from LIST 29 (see section :ref:`LIST29`).
   
   RESIDUE - This inserts a residue number into the 'RESIDUE' slot
   of list 5 replacing any previous value, such that all connected atoms
   have the same residue number and each molecule has a different residue number.
   
   NCONN - This inserts the number of atoms connected to an atom, using
   the list of bonds.
   
   RELAX - This inserts an ID, based upon the bonding topology and atomic
   types of the atoms. Atoms at topologically identical positions will be given
   the same ID. (e.g. the terminal F's in a CF3 group).
   
   
   

**KEEP  Z ATOM-SPECIFICATIONS ...**



   
   Only the atoms referenced in this directive will be kept in the list,
   all the others will be lost, even though they can be referenced
   right up until the final END.
   The sequence Z ATOM-SPECIFICATIONS can be repeated.
   
   
   Atoms that are  KEPT  are moved to the top of the list, and stored in the
   order in which they are specified on  the KEEP  directive. Only one KEEP
   directive may be given. Use CONTINUE if one line isn't long enough for the
   atom sequence.

   
   The atom specifications may contain symmetry operators, which are used
   to generate the coordinates of the atoms that are to be retained.
   'Z' Is an optional parameter which defines the serial number
   of the first atom in the specification immediately following it.
   For each atom thereafter in the current atom specification, the serial
   number is incremented by one to generate the output
   serial number.
   Atoms whose serial numbers are changed in this way must be referred to
   in subsequent directives by their new serial numbers.
   If 'Z' is not given, the atoms retain
   their old serial numbers.

   
   If an  UNTIL  sequence is used after a  KEEP  directive has
   been given, it should be used with care, since the order of the new
   parameter list is different from the input list.
   
   
   

**MOVE Z ATOM-SPECIFICATION  ...**



   
   This directive moves atoms about in the list and places them
   in the position defined by the latest  AFTER  directive.
   (See the previous directive).
   This directive does not remove atoms from the list, but simply
   reorders the list.
   The sequence Z ATOM-SPECIFICATIONS can be repeated.

   
   The atom specifications may contain symmetry operators, which are used
   to generate the coordinates of the atoms that are to be moved.
   'Z'  is an optional parameter which defines the serial number
   of the first atom in the specification immediately following it.
   For each atom thereafter in the current atom specification, the serial
   number is incremented by one to generate the output
   serial number.
   Atoms whose serial numbers are changed in this way must be referred to
   in subsequent directives by their new serial numbers.
   If no  'Z' is given, the atoms retain
   their old serial numbers.

   
   If an  UNTIL  sequence is used after one or more  MOVE  directives have
   been given, it should be used with care, since the order of the new
   parameter list is different from the input list.
   
   
   

**MULTIPLY  VALUE  PARAMETERS  ...**


   
   
   

**PERTURB VALUE PARAMETERS ...**


   This directive perturbs the specified parameters using a rnadom
   number generator. The VALUE is the requested rms perturbation, in the
   natural units of the parameters. The mean deviation applied should be
   approximately zero, and the rms deviation applied should be
   approximately that requested.
   
   
   

**REFORMAT**


   This directive converts an old (non-FLAG) version of LIST 5 (see
   section :ref:`LIST05`) to the new format (extra parameters, old U[iso] 
   slot now used as a flag and u[11] used for u[iso]).
   
   
   

**RENAME ATOM1  ATOM2  (, ATOM1  ATOM2) ...**


   This directive requires pairs of atom specifications (optionally separated
   by a comma). The TYPE and SERIAL of 'atom1' are changed to those of 'atom2'.
   Atom1 must exist in LIST 5, atom2 must NOT exist in LIST 5. An atom can be
   renamed repeatedly. If atom1 contains symmetry operators, these are applied
   to the coordinates of the renamed atom. An atom cannot be renamed to itself
   in a single step.
   
   
   

**RESET PARAMETER-NAME  VALUE ATOM LIST**



   
   This directive assigns the given value to the named parameter
   for all the atoms in the atom list
   
   ::


            RESET OCC 1.0 ALL
            RESET OCC .5 O(1) O(2) O(3)
            RESET U[11] .05 C(27) UNTIL C(50)
   


   
   

**ROTATE**


   This directive rotates a group of atoms a certain number of degrees
   around a specified vector. The rotation is carried out in orthogonal
   space so preserves the geometry of the group.
   
   
   There are three options available:
   ROTATE D X Y Z VX VY VZ atom-specification  
   
   ROTATE D ATOM1 VX VY VZ atom-specification  
   
   ROTATE D ATOM1 ATOMS2   atom-specification  
   
   
   
   The first rotates the specified atoms, D degrees around the vector
   VX,VY,VZ keeping point X,Y,Z fixed. (X,Y,Z and VX,VY,VZ are given in
   crystal fractions).
   
   
   The second notation uses ATOM1 instead of X,Y,Z to specify the fixed point.
   
   
   The third notation uses ATOM1 to specify the fixed point and the vector
   from ATOM1 to ATOM2 to rotate around.
   
   
   The rotation is D degrees anti-clockwise, when the specified vector
   is pointing towards you.
   
   
   1) Rotate the hydrogens of a methyl group by sixty degrees.
   ::


       \EDIT
       ROTATE 60 C(1) C(2) H(20) H(21) H(22)
       END
   


   
   2) Turn a phenyl ring through 30 degrees around its external connecting
   bond, c(1) to c(20).
   ::


       \EDIT
       ROTATE 30 C(1) C(20) C(21) C(22) C(23) C(24) C(25)
       END
   


   
   3) Rotate a residue 90 degrees about the a-direction from its centroid, QC(1)
   (see also CENTROID and INSERT RESIDUE directives)
   ::


       \EDIT
       INSERT RESIDUE
       CENTROID 1 RESIDUE(1)
       ROTATE 90 QC(1) 1 0 0 RESIDUE(1)
       END
   


   
   

**SELECT ATOM-PARAMETER  OPERATOR  VALUE, . .**



   
   This directive selects and retains atoms with parameters satisfying
   the specified conditions.
   Only atoms that satisfy ALL the selection criteria, whether these
   are in the same or different directives, will be kept.
   All other atoms will be deleted from the list.

   
   The operators allowed are :
   
   ::


                  EQ            equal
                  NE            not equal
                  GT            greater than
                  GE            greater than or equal to
                  LT            less than
                  LE            less than or equal to
   


   
   Examples of the  SELECT  directive are :
   
   ::


            SELECT SERIAL LT 50
            SELECT OCC GT 0.5, OCC LT 1.5
            SELECT C(1,X) LT 1., C(1,X) GT 0.
            SELECT TYPE NE Q
   


   
   This example will only retain atoms with serial numbers less than 50
   and occupancies between 0.5 and 1.5.
   The  'X'  parameter of atom c(1) must also lie between 0.0 and
   1.0 oterwise it will be rejected, and any atoms of type Q  will be deleted.
   
   
   

**SHIFT  V1, V2, V3   ATOM-SPECIFICATION . .**


   This directive reads the three numbers of a shift vector, which must
   be in the same coodrinate system as the atomic parameters,
   and applies it to the parameters in the atom specification.
   This directive does not create new atoms, but simply modifies
   those already present.
   Any symmetry operators given are applied before the translation.
   
   
   

**SORT TYPE1 TYPE2 ...**


   

**SORT KEYWORD**


   This directive has two formats, and is used to sort the atoms stored in
   LIST 5 into a user-defined order.
   The default action sorts the atoms  on their types and serial numbers.
   The types are taken in the order found in LIST 5, and atoms of each
   type are grouped together. In each group the atoms are
   arranged by ascending serial number.
   The order of the types of atoms may also be determined
   by specifying them explicitly on the SORT directive,  or by a mixture of
   these methods.
   
   

   
   In the second format, a keyword corresponding to an atom parameter
   name (as defined in LIST 5, see
   section :ref:`LIST05`) is given, and the whole list sorted on
   increasing value of the specified parameter. Note that sorting on TYPE
   will give results depending on the 'collating sequence' of the computer.
   Fortunately, this generally leads to alphabetic sorting.

   
   SORT sorts the whole list 5, and cancels any existing KEEP
   directives.
   
   
   

**SPLIT Z ATOM-SPECIFICATION ...**


   Two new isotropic atoms are added to the end of the atom list for every
   atom referenced in the atom-specification. These atoms lie on
   of the principal axis of the original atoms anisotropic adp ellipsoid 
   and U[iso] set to U[meadian] of the original adp.

   
   The original atoms are not deleted.
   The sequence Z ATOM-SPECIFICATIONS can be repeated.
   The new serial numbers are given by
   ::


            NEWSERIAL(1) = Z* OLDSERIAL and
            NEWSERIAL(2) = Z* OLDSERIAL +1
   


   
   

**SUBTRACT  VALUE  PARAMETERS  ...**


   
   
   

**SWAP  ATOM-PAIRS  ...**


   This directive swaps the atomic coordinates (x's and U's) for the two 
   named atoms.  The occupation numbers, Residue and Parts are left 
   unchanged.  
   
   
   

**TRANSFORM  R11, R21, R31, . . . R33  ATOM SPECIFICATION . .**


   This directive reads the nine numbers of a transformation matrix, which must
   be separated by commas or spaces, and applies the matrix to the atoms given
   in the atom specification.
   This directive does not create new atoms, but simply modifies
   those already present.
   Any symmetry operators given are applied before the rotation.
   
   
   

**TYPECHANGE KEYWORD OPERATOR VALUE NEW-ATOM-TYPE**



   
   This directive conditionally changes the TYPES of atoms. If an atomic
   parameter selected by the keyword (see sort above) satisfies the
   conditions defined by the 'operator' and 'value' (see SELECT above),
   then the TYPE of the atom is changed to 'new-atom-type'.
   
   ::


            TYPECHANGE OCC GT 1.2 O
                                    If Occ large, convert to oxygen
            TYPECHANGE U[ISO] LE 0.03 N
                                    If Uiso small, convert to nitrogen
            TYPECHANGE TYPE EQ Q C                              Convert peaks (type Q) to carbon
   


   
   

**UEQUIV  ATOM SPECIFICATIONS  .  .**


   The specified atoms to be converted so that they
   have isotropic temperature factors,
   U(equiv), defined by the SET UEQUIV command.
   IT IS NOT simply related to the
   diagonal elements of U(aniso).
   If an atom is already isotropic, no action is taken.
   If this directive is given with no arguments, all the atoms in the current
   atomic parameter list are converted to isotropic temperature factors.
   Physically impossible values are not rejected.
   Symmetry operators are ignored.
   
   
   
   
   
   
   

   
   The following directives are used to convert atomic parameters into 
   the special shape parameters
   
   
   
   
   
   

**SPHERE NEWSERIAL ATOMLIST**


   This creates a 'shell' shape from the specified atom list. The centre of
   the shell is at the centre of gravity, the size is the mean distance of
   the given atoms from the centre, and the occupancy is equal to  the sum of
   the occupancies
   of the atoms listed. U[iso] is the mean of the U[iso] or Ueqiv of the
   listed atoms.
   The atom TYPE is QS, with the given serial number. The
   original atoms are not deleted, though they should be or their occupancy
   set to zero. The atom type, QS, should be changed to something
   appropriate.
   
   
   
   

**RING NEWSERIAL ATOMLIST**


   This creates an 'annulus' shape from the specified atom list. The centre of
   the ring is at the centre of gravity, the size is the mean distance of
   the given atoms from the centre, and the occupancy is equal to the sum of
   the occupancies
   of the atoms listed. U[iso] is the mean of the U[iso] or Ueqiv of the
   listed atoms.
   The atom TYPE is QR, with the given serial number. The
   original atoms are not deleted, though they should be or their occupancy
   set to zero. The atom type, QS, should be changed to something
   appropriate. The DECLINATION and AZIMUTH are computed from the
   constituent atoms.
   
   
   

**LINE NEWSERIAL ATOMLIST**


   This creates an 'line' shape from the specified atom list. The centre of
   the line is at the centre of gravity, the size is twice the mean distance of
   the given atoms from the centre, and the occupancy is equal to the sum of
   the occupancies
   of the atoms listed. U[iso] is the mean of the U[iso] or Ueqiv of the
   listed atoms.
   The atom TYPE is QL, with the given serial number. The
   original atoms are not deleted, though they should be or their occupancy
   set to zero. The atom type, QS, should be changed to something
   appropriate. The DECLINATION and AZIMUTH are computed from the
   constituent atoms.
   
   
   
   
   
   
.. index:: REGROUP

   
.. index:: Reorganising atoms and peaks


==============================================
Reorganisation of lists 5 and 10  -  \\REGROUP
==============================================


::


    \REGROUP INPUTLIST= OUTPUTLIST=
    SELECT MOVE= KEEP= MONITOR= SEQUENCE= SYMMETRY= TRANSLATION= GROUP=
    END





::


    \REGROUP
    SELECT MOVE=1.6,MONITOR=HIGH
    END






This routine offers a
way of re-ordering the atoms in LIST 5 (atomic parameters) or LIST 10
(Fourier peaks), so that
related atoms or peaks
form a sequential group in the list, and the coordinates put the atoms
as close together as possible.


THIS ROUTINE DOES NOT USE LIST 29 (atomic properties) to get bonding 
distances, but uses a single overall distance.


In this routine, a set of distances is calculated about
each atom or peak in the list in turn.
For each atom or peak in the list below the current pivot, the
minimum contact distance is chosen, and if this is less than a user
specified maximum, the atom or peak is moved up the list to
a position directly below the pivot. ( The  MOVE  parameter).
When more than one atom or peak is moved, their relative order is
preserved as they are inserted behind the current pivot atom.
As well as reordering the list, the necessary symmetry operators are
applied to the positional and thermal parameters to bring the atom
or peak into the same part of the unit cell as the current pivot
atom. The result of this process is to bring related atoms together
in the list, and to place all the atoms in the same part of the unit cell. 
Setting the GROUP parameter to YES causes the PART to be incremented 
between isolated parts of the structure.

--------------------------------
\\REGROUP INPUTLIST= OUTPUTLIST=
--------------------------------

   

*INPUTLIST=*


   
   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*OUTPUTLIST=*


   
   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

**SELECT MOVE= KEEP= MONITOR= SEQUENCE= SYMMETRY= TRANSLATION= GROUP=**


   

*MOVE=*


   This parameter has a default value of 2.0, and is the distance
   below which atoms or peaks are considered to be bonded, and are thus
   moved about the cell and relocated in LIST 5 (atomic parameters).

   
   
   If the MOVE parameter is -ve, then a covalent radius used, and the
   absolute value of MOVE is used as a TOLERANCE, such that bonds are formed
   if D < COV1+COV2+TOLERANCE.
   
   
   
   
   
   

*KEEP=*


   This is the maximum number of atoms that the final output list can
   contain. If this parameter is omitted, all the atoms are output.
   If MOVE is used to move the atoms around, it is unwise to use the  KEEP
   parameter,since some of the original input atoms may find their way
   to the bottom of the list and be eliminated. (The default value is
   1000000).
   

*MONITOR=*


   
   ::


            LOW   -  Default value
            HIGH
   


   
   If  MONITOR  is  HIGH, then each
   pivot atom and its associated moved atoms are listed, as well as any
   deleted atoms. If MONITOR is LOW,
   the moved atoms are not listed.
   

*SEQUENCE*


   
   ::


            NO   -  Default value
            YES
            EXHYD
   


   
   If  SEQUENCE  is  YES, the outputlist is resquenced as described above.
   
   
   If  SEQUENCE  is  NO, the serial numbers of the atoms are not
   changed from the  original list.
   
   
   If SEQUECE is EXHYD the hydrogen atoms are excluded from the 
   renumbering.
   

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
   
   
   

*GROUP*


   
   ::


            NO   -  Default value
            YES
   


   
   If  GROUP  is  YES, the PART parameter for each atom is set.
   
   
   
.. index:: COLLECT

   
.. index:: Repositioning atoms and peaks


====================================
Repositioning of atoms  -  \\COLLECT
====================================



This routine changes the atom
coordinates so as to form a 'molecule' using the covalent radii given in
LIST 29 (atomic properties - see section :ref:`LIST29`). The atom TYPE, SERIAL 
and order in LIST 5 (atomic parameters - see section :ref:`LIST05`) is not changed.



--------------------------------
\\COLLECT INPUTLIST= OUTPUTLIST=
--------------------------------

   

*INPUTLIST=*


   
   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*OUTPUTLIST=*


   
   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

**SELECT MONITOR= TOLERANCE= TYPE= SYMMETRY= TRANSLATION=**


   

*MONITOR=*


   
   ::


            LOW   -  Default value
            HIGH
   


   
   If  MONITOR  is  HIGH, then each
   pivot atom and its associated moved atoms are listed, as well as any
   deleted atoms. If MONITOR is LOW,
   only deleted atoms are listed.
   
   
   

*TOLERANCE=*


   The tolerance is added to the sum of the co-valent radii
   taken from LIST 29 (atomic properties - see section :ref:`LIST29`) to give a 
   value used for determining inter-atomic bonds.
   The default is 0.2 A.
   
   
   

*TYPE=*


   
   ::


            ALL
            PEAKS
            ATOMS
   


   
   If TYPE equals ALL, then the coodinates of all atoms and Q-peaks 
   are liable to be
   modified by the symmetry operators in order to assemble a single fragment.
   
   
   If TYPE equals PEAKS, then only the peaks are moved to bring them as close
   as possible to existing atoms.
   
   
   If TYPE equald ATOMS, only non-Q atoms are modified
   
   
   

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
   
   
   
   
   
.. index:: ORIGIN

   
.. index:: Shifting the molecule to a permitted alternative origin


==================================================================
Shifting the molecule to a permitted alternative origin - \\ORIGIN
==================================================================


::


    \ORIGIN INPUTLIST= OUTPUTLIST= MODE=
    END
   






Attempt to move the structure to the centre of the unit cell
using the permitted origin shifts.

-------------------------------------
\\ORIGIN INPUTLIST= OUTPUTLIST= MODE=
-------------------------------------

   
   
   
   
   

*INPUTLIST=*


   
   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*OUTPUTLIST=*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*MODE=*


   ::


            CENTROID   -  Default value.
            FIRST
   


   

   
   CENTROID tries to move the centroid of LIST 5 as close to .5 .5 .5
   as is permitted by the permitted origin shifts.  Other connected atoms follow 
   the centroid.

   
   FIRST  As above excpet that the first atom in LIST 5 is the 
   target atom.  This may be a user-computed partial centroid.
   ::


            \edit
            cent 100 residue 3
            move qc(100)
            end
            \origin mode=first
   


   

   
   Currently (April 2011) the code only processes primitive triclinic, 
   monoclinic and orthorhombic cells, using the tables in Direct Methods in 
   Crystallography, Giacovazzo, Academic press, 1980, pp 74 and 76.
   
   
   
   
.. index:: CONVERT

   
.. index:: Converting B[ij's] to U[ij's]


=============================================
Conversion of temperature factors - \\CONVERT
=============================================


::


    \CONVERT INPUTLIST= OUTPUTLIST= CROSSTERMS=
    END
   
    \CONVERT
    END






This routine will convert the temperature factors of a set of atoms
into the correct form when their temperature factor, t, is given by :

::


          T = exp(-B[iso]*S**2)     where s = sin(theta)/lambda.
   
    or for an anisotropic atom :
   
          T = exp(-(h*h*b[11] + k*k*b[22] + l*l*b[33]
              + k*l*2*b[23] + h*l*2*b[13] + h*k*2*b[12]))




The cross terms stored in the original LIST 5 (the model parameters) 
may either be  B[IJ]  or 2*B[IJ] .
(The correct form of the temperature factor, in terms of u[ii]'s
and u[ij]'s, is given in the section on the input of LIST 5).
After conversion, the atoms are output to the disc as a new LIST 5.
Remember that if U[ISO] is non-zero, (its default at atom input is 0.05)
the U[IJ] are ignored and so will not be converted.

--------------------------------------------
\\CONVERT INPUTLIST= OUTPUTLIST= CROSSTERMS=
--------------------------------------------


   
   This is the command which initiates the routine
   to convert the temperature factors.
   

*INPUTLIST=*


   
   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*OUTPUTLIST=*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*CROSSTERMS=*


   ::


            B[IJ]   -  Default value.
            2B[IJ]
   


   
   
.. index:: Hydrogen placement

   
.. index:: HYDROGENS


==============================
Hydrogen placing - \\HYDROGENS
==============================


::


    \HYDROGENS INPUTLIST= OUTPUTLIST=
    DISTANCE  D
    SERIAL    N
    U[ISO]    U
    U[ISO]    NEXT   MULT
    AFTER     TYPE(SERIAL)
    PHENYL    X R(1) R(2) R(3) R(4) R(5)
    H33       X R(1) R(2)
    H23       X R(1) R(2)
    H13       X R(1) R(2) R(3)
    H22       X R(1) R(2)
    H12       X R(1) R(2)
    H11       X R(1)
    HBOND     DONOR ACCEPTOR
    END





::


    \HYDROGENS
    DISTANCE  1.09
    U[ISO]    NEXT   1.2
    H33     C(7) C(6) R(5)
    H22     C(14) C(15) C(13)
    END




This routine computes the coordinates of hydrogen atoms bonded to a
target atom. The hybridisation of the target atom and the identifiers of
atoms bonded to it must be given.

----------------------------------
\\HYDROGENS INPUTLIST= OUTPUTLIST=
----------------------------------

   

*INPUTLIST=*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*OUTPUTLIST=*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

**DISTANCE  D**


   This sets the central atom-hydrogen atom distance to
   'D' angstroms. The default value is 1.0.
   The current value of 'D' remains in force until another 'DISTANCE'
   directive is given.
   

**SERIAL  N**


   This sets the serial number of the next hydrogen atom
   to be added to LIST 5 (atomic parameters) to 'N'.
   The default value is 1.
   Subsequent hydrogen atoms will have the serial numbers 'N+1', 'N+2', etc.,
   until the next 'SERIAL' directive is input.
   

**U[ISO]    U**


   This directive sets the isotropic temperature factor
   of each hydrogen atom
   to 'U' angstroms squared,
   and remains in force until another 'U[ISO]'
   directive is given.
   If no values is given for U, the next definition is used.
   

**U[ISO]    NEXT   MULT**


   This is an alternatine form of the preceding directive. It sets the
   isotropic temperature factor  of each hydrogen atom
   to 'MULT' times the equivalent temperature factor of the atom it is
   bonded to.  The default value is 1.2.
   The directive remains in force until another 'U[ISO]'
   directive is given.
   

**AFTER   TYPE(SERIAL)**


   The hydrogen atoms generated by the placing routines
   are inserted in the new LIST 5 (atomic parameters) after the atom
   'TYPE(SERIAL)'.
   This directive must appear immediately after the directive that generated
   the hydrogen atom coordinates, and applies only to that group of
   hydrogen atoms.
   If no 'AFTER' directive is
   given, the new hydrogen atoms are added at the end of the
   current LIST 5 (atomic parameters).
   

**PHENYL  X R(1) R(2) R(3) R(4) R(5)**


   This generates the coordinates of  the five hydrogen atoms
   of a phenyl group. The first atom specified must be
   the atom that bonds the phenyl group
   to the rest of the structure, and the other atoms must be in the order
   of connectivity.
   

**H33  X R(1) R(2)**


   This geneates the hydrogen atoms of a methyl
   group.
   The methyl carbon is the first atom specified, and
   the hydrogen atoms are generated so that one of them is trans
   with respect to the third atom specified, R(2).
   
   ::


            H
             \
            H-X-R(1)-R(2)
             /
            H
   


   
   

**H23  X R(1) R(2)**


   This generates the coordinates of two hydrogen atoms on an sp3 atom X.
   
   ::


            H   R(1)
             \ /
              X
             / \
            H   R(2)
   


   
   
   

**H13  X R(1) R(2) R(3)**


   This generates the coordinates of one hydrogen atom on an sp3 atom X.
   
   ::


                R(1)
               /
           H- X-R(2)
               \
                R(3)
   


   
   
   

**H22  X R(1) R(2)**


   This generates the coordinates of two hydrogen atoms on an sp2  atom X
   
   ::


            H        R(2)
             \      /
              X=R(1)
             /
            H
   


   
   
   

**H12  X R(1) R(2)**


   This generates the coordinates of one hydrogen atom on an sp2 atom X.
   
   ::


              H
               \
                X=R(1)
               /
            R(2)
   


   
   

**H11  X  R**


   This generates the coordinates of the single
   hydrogen atom bonded to an SP hybridised atom.
   

**HBOND X  R**


   This generates a single H atom 'DISTANCE' angstroms from the donor
   in the direction of the acceptor. X is the donor, R the acceptor.
   
   ::


      
              X-H....R
   


   
   
   ::


       Place Hydrogen atoms on the following fragment:
      
            C(1)          C(5)
                \        /
                 C(2)=C(3)
                         \
                          C(4)-Br(1)
      
           \HYDROGENS
            DISTANCE 0.99
            U[ISO]   0.06
            H33 C(1) C(2) C(3)
            AFTER C(1)
            H12 C(2) C(1) C(3)
            AFTER C(2)
            H23 C(4) Br(1) C(3)
            AFTER C(4)
            H33 C(5) C(3) C(4)
            END
   


   
   
.. index:: Hydrogen placement - automatic

   
.. index:: PERHYDRO


=============================
Perhydrogenation - \\PERHYDRO
=============================


::


    \PERHYDRO INPUTLIST= OUTPUTLIST=
    DISTANCE  D
    SERIAL    N
    U[ISO]    U
    U[ISO]    NEXT   MULT
    ACTION    MODE
    TYPE      C or N
    END





::


    \PERHYDRO
    U[ISO] NEXT 1.0
    END




This command scans the atomic coordinates for carbon atoms, attempts
to assign their hybridisation state (on the basis of bond lengths) and
then generates \\HYDROGEN commands to create any necessary hydrogen atoms.
Existing Hydrogen atoms are not replaced by this routine.


The generated commands may be processed internally by CRYSTALS without
the user needing to see them, or they may be sent to the external files for
later use. This is the default mode. If no new hydrogen atoms are 
generated, no new external files are created.


The external files are called DELH.DAT and PERH.DAT, with DELH 
containing an entry for every atom created by PERH.  Executing DELH and 
PERH will delete existing named atoms, and recreate them geometrically.

---------------------------------
\\PERHYDRO INPUTLIST= OUTPUTLIST=
---------------------------------

   

*INPUTLIST=*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

*OUTPUTLIST*


   ::


            5   -  Default value, the atomic coordinates
            10                    the Fourier peaks search
   


   
   

**DISTANCE  D**


   This sets the central atom-hydrogen atom distance to
   'D' angstroms. The default value is 1.0.
   The current value of 'D' remains in force until another 'DISTANCE'
   directive is given.
   

**SERIAL  N**


   This sets the serial number of the next hydrogen atom
   to be added to LIST 5 to 'N'.
   The default value is 1.
   Subsequent hydrogen atoms will have the serial numbers 'N+1', 'N+2', etc.,
   until the next 'SERIAL' directive is input.
   

**U[ISO]    U**


   This directive sets the isotropic temperature factor
   associated with each hydrogen atom
   to 'U' angstroms squared.
   The default value is 0.05.
   The directive remains in force until another 'U[ISO]'
   directive is given.
   

**U[ISO]    NEXT   MULT**


   This is an alternatine form of the preceding directive. It sets the
   isotropic temperature factor  associated with each hydrogen atom
   to 'MULT' times the equivalent temperature factor of the atom it is
   bonded to.  The default value is 1.2.
   The directive remains in force until another 'U[ISO]'
   directive is given.
   

**ACTION    MODE**


   
   
   

*MODE*


   ::


            NORMAL
            PUNCH
            BOTH     -  Default value.
   


   
   NORMAL causes internal commands to be generated and executed. PUNCH causes
   output to the PUNCH file only. BOTH forces both actions.
   
   
   
   
   

**TYPE    MODE**


   
   
   

*MODE*


   ::


            C   -  Default value.
            N
   


   
   C enables the program to place hydrogen atoms on carbon atoms.
   
   
   N enables the program to place hydrogen atoms on nitrogen.
   
   
   It is advisable to perform placement on C before N, since the
   hybridisation states of C are more clearly defined.
   
   
   
   
   
   
   
.. index:: HNAME

   
.. index:: Hydrogen - automatic renumbering  


===============================
Hydrogen re-numbering - \\HNAME
===============================


::


    \HNAME INPUTLIST= OUTPUTLIST=
    END





::


    \HNAME
    END




This command automatically renumbers hydrogen atoms so that their
serial numbers are related to the bonded non-hydrogen atom.



.. index:: REGULARISE


.. index:: Regularisation of atomic groups


==============================================
Regularisation of atomic groups - \\REGULARISE
==============================================


::


    \REGULARISE    MODE
    COMPARE
    KEEP
    REPLACE
    AUGMENT
    METHOD NUMBER
    GROUP NUMBER
    TARGET Atom Specifications
    IDEAL  Atom Specifications
    RENAME offset number
    CAMERON
    MAP Atom Specifications
    ONTO Atom Specifications
    SYSTEM a b c alpha beta gamma
    ATOM    x    y    z
    CP-RING x
    HEXAGON x
    OCTAHEDRON x y z
    PHENYL
    SQP x y z
    SQUARE x y
    TBP x z
    TETRAHEDRON x
    END







::


    \REGULARISE REPLACE
    GROUP 6
    TARGET C(1) UNTIL C(6)
    PHENYL
    END






This routine calculates a fit between the
coordinates of a group of atoms in LIST 5 (atomic parameters) and another 
group.
The calculated fitting matrix may be used to compare the geometry of two
groups, or it may be applied to transform the new coordinates which will
then replace the existing group in LIST 5 (D. J. Watkin, Act Cryst
(1980). A36,975).


In this section, the group of atoms in LIST 5 to whose coordinates the
fit is made is referred to as the 'TARGET atoms', and the group to be fitted
onto that group is referred to as the 'IDEAL atoms'.


The source of the 'IDEAL atoms' can be the LIST 5,
a pre-stored idealised geometry,  or values read in from the directives.
Those directives that refer to LIST 5 use the usual CRYSTALS formats for
atom specifications. Once a transformation has been found, this can be 
used as the basis for naming one fragment based on the names of 
another.


--------------------
Input for REGULARISE
--------------------


   
   The input to REGULARISE must define the groups to be fitted together,
   the method used for fitting , and the use to be made of the results.
   The user must ensure that corresponding atoms
   are specified in the same positions of the 'TARGET' and 'IDEAL' group
   definitions, so the program knows which pairs of atoms are to be
   matched.
   It is not necessary to have co-ordinates of every atom
   in the TARGET fragment. The inclusion of atom specifications
   for which coordinates do not exist in the parameter list indicates
   that the procedure must generate coordinates for these atoms.
   This allows the user to give a type and serial to new atoms
   created by the procedure.
   Any 'atoms' without coordinates are not included in the fitting
   process.

   
   The maximum number of atom  IDENTIFIERS permitted on an TARGET or
   IDEAL directive is about 250. Note that an UNTIL sequence only 
   counts as two identifiers.
   The number of implied atoms permitted is very large.

   
   The 'IDEAL' group may be given in various ways.
   For calculations
   on a single structure,  it may be extracted from the stored data
   in the same way as the 'TARGET' group.  In this case however, all the atoms
   must previously exist.
   Alternatively, explicit co-ordinates may be  given in
   a system defined  by the user,   or a predefined group may be used.
   In any case all the positional parameters of
   the atoms in the  'IDEAL' group will be known before the
   calculation begins. Finally, various pre-defined geometrical groups are
   available.

----------------------
Output from REGULARISE
----------------------


   
   The output from REGULARISE  includes the fragment centroids, their
   sums and differences and the
   transformation fitting the IDEAL onto the TARGET.
   

---------------------
Method of calculation
---------------------

   

   
   The centroid of each fragment is moved to the origin.
   The atomic
   coordinates are converted to an orthogonal system and rotated  to an
   'inertial tensor' system (to help condition the L.S. matrix).

   
   The fitting calculation is either constrained to be a pure rotation-
   inversion, or is a free linear transformation (rotation-diltion).
   If requested, the pure rotation component of the calculated
   rotation-dilation matrix is extracted.
   
   The calculated  matrix is applied to the co-ordinated of the
   'IDEAL' group, which is then converted back to crystal fractions,
   for comparison with the TARGET.
   

**WARNING**



   
   The  3 by 3  transformation  matrices  generated  at  various
   stages  may  well  be  singular,  especially if  no rotation  is
   defined about one of the axes.  To combat possible problems with
   matrix inversion, a Moore-Penrose type matrix inverter is used.
   Even so, the user should be aware that there may be no unique solution
   to his problem. For example, when a planar fragment is fitted to an
   almost planar fragment one fit may involve inversion of the non-planar
   fragment. Inversion can be prevented by using Method 3.
   Note also that if almost planar groups are being fitted, the dilation
   factor perpendicular to the plane may be very large, and thus have an
   undesirable effect if applied to atoms far from the plane.
   
   

--------------------
\\REGULARISE    MODE
--------------------

   MODE is an  optional  parameter.
   

*MODE*


   ::


            COMPARE      -      Default value
            KEEP
            REPLACE
            AUGMENT
   


   

   
   The effects are :-

   
   COMPARE        The specified groups are only compared. The
   translations and rotations necessary to match the
   groups will be calculated but not applied.

   
   KEEP           The specified groups will be compared and the
   calculated transformations applied. The TARGET atoms are
   kept, and atoms  whose parameters have been
   calculated will be stored at the end of the new LIST 5.
   NOTE. If KEEP is given as a keyword, it can be followed by an offset
   to be used for the new serial numbers

   
   REPLACE        The specified groups will be compared and the
   calculated transformations applied. The new atoms whose parameters
   have been calculated will
   be placed at the end of LIST 5 and the old atoms deleted form the list.

   
   AUGMENT        The specified groups will be compared and the
   calculated transformations applied. The TARGET atoms which actually
   exist in LIST 5 are retained unaltered.
   Parameters that have been  calculated for dummy atoms (represented by a
   name only in the TARGET list) will be placed at the end of the new LIST 5.

   
   For REPLACE and KEEP the 'IDEAL' coordinates define the geometry to
   be preserved, i.e. the model, and the 'TARGET' coordinates specify where,
   in what orientation and with what atom identifiers the model is to be placed.
   That is, the TARGET structure is replaced by the IDEAL.
   
   
   

**KEEP  Z**


   

**COMPARE**


   

**REPLACE**


   

**AUGMENT**



   
   These 4 directives override the option specified by the MODE parameter of
   the REGULARISE command. The next group calculated will be treated
   in the specified mode. See the description of MODE for
   details. If the mode is KEEP, an offset Z can be given to be added to 
   ther SERIAL of kept atoms (default 0) otherwise there are no parameters.
   

**METHOD NUMBER**



   
   This directive selects the method for matching the
   groups by giving its number from the
   following list:-
   
   ::


            Number     Method
            ------     ------
             1        Rotation  component of  rotation-dilation
                      matrix applied. ( default )
             2        Rotation-dilation  matrix  calculated and
                      applied.
             3        Pure  rotation matrix  calculated  by the
                      Kabsch method and applied. This algorithm
                      preserves chirality.
             4        Enable improper rotation in Kabsch method
             5        Use identity matrix as rotation component
   


   
   

**GROUP NUMBER**



   
   This directive specifies the number of atoms in the groups to be matched.
   It should be the first directive for each group of atoms. The appearance
   of a second or subsequent GROUP directive in the input
   initiates the calculation for the previous group.
   

**TARGET Atom Specifications**



   
   This directive is used to specify the 'TARGET' group of atoms. The directive
   will carry a series of atom specifications which will define the positions
   of the 'TARGET' atoms and the names of any atoms to be created by the
   routine. Atoms which exist in LIST 5 and atoms to be created can appear in
   any order in the TARGET group , although the order should be such that
   corresponding pairs of atoms appear at the same relative positions in the
   'TARGET' and 'IDEAL' groups.
   

**IDEAL Atom Specifications**



   
   This directive is used to specify a group of 'IDEAL' atoms to be taken
   from the stored LIST 5. Every atom on this directive must exist.
   

**SYSTEM a b c alpha beta gamma**



   
   This directive is will change the co-ordinate system used to interpret any
   subsequent ATOM directives.

   
   The initial co-ordinate system has orthogonal axes of unit length and is
   equivalent to :-
   ::


       SYSTEM  1.0  1.0  1.0  90.0  90.0  90.0
   


   

   
   Values must be given for a', b', and c', the angles default to 90.0.
   

**ATOM    x    y    z**


   This directive allows the cordinates of a single atom to be specified,
   in fractional co-ordinates in the current co-ordintate system. It must be
   followed by three decimal numbers which will be the X, Y, and Z coordinates
   of the atom.
   

**RENAME offset number**


   This directive can only be used after previous directives have been 
   used to match one group onto another (REGULARISE COMPARE),
   and enables the use of the MAP 
   and ONTO directives. The MAP list of atoms is transformed by the 
   existing transformation matrix (which may have been computed from only a 
   few specified atoms). Each atom is then compared with the ONTO list, 
   and the TYPE and SERIAL of the MAP atom used to generate a TYPE and 
   SERIAL for the closest ONTO atom. 
   

*OFFSET*


   The serial numbers of the atoms in the group being re-named are 
   related to those of the master group by an increment of 'OFFSET'. The 
   default value is 100
   

*NUMBER*


   If the number of atoms supplied on the following MAP and ONTO 
   directives does not match NUMBER, a warning is printed.
   

**CAMERON**


   This matches atoms as in RENUMBER, but only creates CAMERON files
   with atoms transformed into the common coordinate system.
   

**MAP  Atom Specifications**


   This specifies the atoms whose TYPE and SERIAL are to be propogated 
   into the ONTO atoms. The atoms can be in any order.
   

**ONTO  Atom Specifications**


   This specifies the atoms to be renamed. The atoms may be in any order 
   and have any TYPE, but there must be EXACTLY as many as on the MAP 
   directive. The atoms can have any TYPE, but must have unique SERIAL 
   numbers.
   
   

**HEXAGON X**


   The 'IDEAL' group is a regular hexagon with
   a side of length 'X'. The default for x is 1.0.
   

**PHENYL**


   The same as HEXAGON with a fixed side of 1.39.
   

**CP-RING X**


   The 'IDEAL' group is a regular pentagon with
   a side of length 'X'. The default for x is 1.4.
   

**SQUARE X Y**


   The 'IDEAL' group is a rectangle with atoms
   at (x,0,0) , (0,y,0) , (-x,0,0) , (0,-y,0) . The parameters
   X and Y specify the size of the group to be used.
   

**OCTAHEDRON X Y Z**


   The 'IDEAL' group is an octahedron with
   atoms at (0,0,0) , (-x,0,0) , (0,y,0) , (x,0,0) , (0,-y,0) ,
   (0,0,z) , (0,0,-z).
   The parameters X, Y and Z specify the size of the octahedron.
   'z' defaults to 'y' defaults to 'x'
   defaults to '1.0'
   

**SQP X Y Z**


   The 'IDEAL' group is a square pyramid with
   atoms at (0,0,0) , (x,0,0) , (0,y,0) , (-x,0,0) , (0,-y,0) ,
   (0,0,z).
   The parameters X, Y and Z specify the size of the octahedron.
   'z' defaults to 'y' defaults to 'x'
   defaults to '1.0'
   

**TBP X Z**


   The 'IDEAL' group is a trigonal bipyramid with
   atoms at (0,0,0) , (x,0,0) , (-x/2,0.86603x,0), (-x/2,-0.86603x,0) ,
   (0,0,z) , (0,0,-z) . The parameters X and Z specify the scale in the
   xy plane  and z directions.
   

**TETRAHEDRON X**


   The 'IDEAL' group is a regular tetrahedron with
   an atom at the centre.
   'x' is the distance in Angstrom from the
   centre to an apex and defaults to '1.0'
   

**ORIGIN**



   
   This directive is not yet implemented.
   
   

--------------------
Uses of \\REGULARISE
--------------------

   
   
   

**1 - Extending a fragment to a complete molecule**


   
   

   
   Three atoms of a phenyl group ( C(1), C(2) C((6)) have been located.
   Fill in the missing  atoms from a non-dilated idealised phenyl group.
   
   ::


            \REGULARISE AUGMENT
            GROUP 6
            METHOD 1
            \ C(3), C(4), and C(5) do not yet exist.
            TARGET C(1) C(2) C(3) C(4) C(5) C(6)
            PHENYL
            END
   


   
   
   
   

**2 - Forcing a regular shape on a group of atoms**



   
   A group of atoms is approximately  octahedral.
   Replace them by a (posibly dilated) regular octahedron.
   
   ::


            \REGULARISE REPLACE
            GROUP 7
            METHOD 2
            TARGET CO(1) N(1) N(2) N(3) N(4) N(5) N(6)
            OCTAHEDRON
            END
   


   
   

**3 - Checking for an additional symmetry element**



   
   Determine whether the two molecules in an asymmetric unit are
   related  by a  symmetry operation not  expected for the space  group.
   The matrix relating the molecules and the translation required  to
   make their centroids  coincide should display any additional
   (approximate)  symmetry  present. Remember that if one molecule is
   the enantiomer of the other, Method 3 will lead to an unsatisfactory
   fitting unless  one molecule is inverted, (by using the operator -1 in
   the atom specifications e.g. FIRST(-1) UNTIL C(23). This can be done
   even if the space group is non-centrosymmetric ).
   
   
   
   ::


            \REGULARISE COMPARE
            GROUP 16
            TARGET C(101) UNTIL N(102)
            IDEAL  C(201) UNTIL N(202)
            END
   


   
   

**4 - Renaming a group of atoms**


   A second group of atoms is given new TYPES and SERIAL numbers 
   so that the atom names are related to  a previously named group.

   
   
   In the example, the user has identified two sets of four non-coplanar 
   atoms in each 
   group e.g. C(1) with Q(103), C(3) with  Q(99) etc. The transformation 
   is then used to map the whole of the first group (C(1) until O(25)) onto 
   the second group (Q(96) until Q(120)). Both of these groups must contain 
   the same number of atoms, but they may be in any order. Atom Q(103) will 
   be renamed to C(101), atom Q(100) to C(107) etc. Once all the atoms 
   have been renamed, the list could be sorted based on the serial numbers.
   
   ::


            \REGULARISE
            GROUP 4
            IDEAL C(1) C(3) C(5) C(7)
            TARGET Q(103) Q(99) C(116) Q(100)
            RENAME 100
            MAP C(1) UNTIL O(25)
            ONTO Q(96) UNTIL Q(120)
            END
            \EDIT
            SORT SERIAL
            END
   


   
   

**5 - Viewing matched molecules in CAMERON**


   This does the mapping as RENAME, but doesn't
   rename the atoms, just outputs CAMERON input files showing the two molecules
   superimposed. Use as follows:
   
   ::


         \REGULARISE
         group 16
         target C(10) until C(26)
         ideal  C(60) until C(76)
         cameron
         map    C(51) until C(99)
         onto   C(1) until C(49)
         end
   


   This produces a cameron.ini, regular.l5i and regular.oby which may be viewed
   by choosing Graphics->Special->Cameron (use existing...) from the menu.
   Then type "obey regular.oby" in Cameron to colour the molecules nicely.
   The TARGET and IDEAL are used to obtain the mapping. The atoms in MAP and ONTO
   are just the ones you want to be included.
   Don't read the atoms back into CRYSTALS when closing CAMERON - they're in
   orthogonal coordinates.
   
   
   

**- Comparing two structures**


   The SYSTEM and ATOM directives enable one to compare one structure with
   atoms from a second structure. However, since the second structure is 
   not part of the main model, CRYSTALS knows nothing about the 
   connectivity.  Using the KEEP z directive, the second strcuture can be 
   added to the DSC file, enabling a complete calculation to be performed.
   
   In the following example, O(16) is in a quite distinctly different 
   position in the two structures, so place holder Q(16) is used during the 
   first mapping. The input coordinates are added to the DSC file with 
   SERIAL numbers off-set by 400.
   
   
   In the second calculation O(16) of the original structure is compared 
   with Q(416) of the input structure. 
   ::


      \regular keep
      keep 400
      group 7
      old mo(1) o(11) o(12) o(13) o(14) o(15) q(16)
      system 8.4830 10.1870 11.0340 105.260 95.290 95.100 909.60
      atom 0.1570 0.5269 0.2514
      atom 0.1356 0.5975 0.1278  
      atom -0.0296 0.4567 0.2632  
      atom 0.2258 0.3448 0.1750  
      atom 0.1693 0.6928 0.3850  
      atom 0.4211 0.5669 0.2567  
      atom 0.7960 0.1904 0.1727  
      
      
      \regular compare
      group 7
      old mo(1) o(11) until o(16)
      new mo(401) until q(416)
      end
   


   
   
   
   
   
.. index:: MATCH

   
.. index:: Map two atomic groups together


========================================
Map two atomic groups together - \\MATCH
========================================


::


    \MATCH
    MAP Atom Specifications
    ONTO Atom Specifications
    RENAME n
    EQUALATOM
    METHOD
    END







::


    \MATCH
    METHOD 3
    MAP RESIDUE(1)
    ONTO RESIDUE(2)
    RENAME 100
    END






This routine  uses the mapping routines in REGULARISE to compare
two residues.  Unlike REGULARISE itself, the user does not have
to list the atoms in any special order - the routine attempts to make
pairwise assigments. Initially this is done via a topographical search,
and refined by minimising cartesian residuals whenever degeneracy is 
found.



**MAP**




The following list of atoms is the ideal fragment with ideal atom 
types and numbers




**ONTO**




The following list of atoms is the fragment ot be compared with the 
ideal.  There must be the same number of atoms in both fragments, but 
not necessarily in the same order. Inclusion of any Q atoms sets the 
EQUALATOM flag, ie the atom types are ignored.




**EQUALATOM**




If this parameter is included, the atom types in the "ONTO" list are 
ignored - they can even be Q atoms




**METHOD**




One of the METHODS available in REGULARISE

The default is method 4.




**RENAME  n**




If the mapping is succerssful, atoms in the ONTO list are given the 
same type as the corresponding atom in the MAP list, and the same SERIAL 
plus "n".




**OUTPUT LIST= PUNCH=**




lIST takes the values OFF, LOW, MEDIUM, HIGH.


unch takes the values OFF, RESULTS



Results creates an ASCII file that could be processed by EXCEL or 
other spreadsheet.
The fields are tab-deliminated, and have the following attributes.
::


   CSD_CIF_BAZHAM01  (title)
   Asymmetric  (potential internal symmetry)
   :Centroids   (x,y,z)A and (x,y,z)B  
   :Axes of Inertia   (long, medium, short)A and (long, medium, short)B 
   :Sum dev sq  After matching, Sum(delta_x^2), y and z.  Sum Separation^2 
   :RMS dev  As above, but root mean square deviation rather than sums  
   :RMS bond and tors dev  RMS differences of equivalent bond lengths and torsion angles  
   :Min and Max bond dev  Minimum and maximum bond length differences.  
   :Min and Max tors dev   Minimum and maximum torsion angle differences. 
   :Mean & delta Centroids  Mean(xA,xB), (yA,yB), (zA,zB) and (xA-xB), (yA-yB), (zA-zB)
   :Transformation   (3x3) transformation matrix
   :Det and trace   Determinant and trace of matrix
   :Closeness to ideal rotation  RMS of the deviations of matrix elements from integers  
   :Closeness to group operator  RMS of the deviations of translations from integers  
   :Combined measure of closeness    
   :Rworst & Raverage  Worst and Average for to an operator, operator identifier  
   :Symmetry  Local point group relating molecules.
   :Pseudo  Pseudo point group  relating molecules.
   :Operator  Pseudo symmetry operator.
   :No_Atoms  Number of atoms in each molecule.
   :S.G.  Original space group.
   :Cell  Original unit cell parameters.






**Comparing lots of Z'=2 structures**




If one has a single cif file containing many Z'=2 structures, the whole 
file can be processed structure-by-structure automatically, with 
automatic matching of the structures. See
Structure matching: measures of similarity and pseudosymmetry. 
A.  Collins, R. I.  Cooper and D. J.  Watkin. 
Journal of Applied Crystallography 2006;39(6):842-849.


To do this, extract the structures from the CSD saving the results to 
a single file using the operation 'Import CIF file' from the drop-down 
menu 'X-ray Data'.  Before starting, 
ensure that a file titled "cifproc.dat" is in the same folder as the 
composite cif file and that it says:

::


   /edit
   mon off
   list off
   insert resi
   sel type ne h
   end
   /match
   output punch=results
   map resi(1)
   onto resi(2)
   end
   /purge
   end








**Output from MATCH**




If the output is set to PUNCH=RESULTS, a summary of the result of 
each matching operation is copied to the Punch file (Usually BFILE.PCH)
All the information for each match is appended to a single line. The 
items are "tab deliminated" to facilitate reading them into 
spreadsheets. The keywords are preceeded by a ":" so that an editor can 
be used to break the line as necessary.


Description of output:

::


   CSD_CIF_AANHOX01  
   :Centroids    (the x,y and z coordinates of both centroids)
   :Axes of Inertia    (the three axes of inertia of both molecules)
   :Sum dev sq   (sum of the squares of the deviations in x,y,z and delta-d)
   :RMS dev   (rms deviations in x,y,z and delta-d)
   :RMS bond and tors dev     
   :Min and Max bond dev     
   :Min and Max tors dev   
   :Sum & delta Centroids   
   :Transformation    (matrix transforming one molecule to the other)
   :Det and trace     (of the matrix - -ve indicates inversion)
   :Closeness to ideal rotation   
   :Closeness to group operator   
   :Combined measure of closeness   
   :Rworst & Raverage   
   :Symmetry   
   :Pseudo   
   :Operator   
   :No_Atoms   
   :S.G.   
   :Cell  








Example of output

::


   CSD_CIF_AANHOX01 
   :Centroids       0.9169 0.6281 0.3346 1.0255 0.8741 0.8117 
   :Axes of Inertia 59.3690 10.0284 0.1392 59.1659 10.1380 0.0762 
   :Sum dev sq      0.0014 0.0014 0.0726 0.0754 
   :RMS dev         0.0115 0.0114 0.0812 0.0828 
   :RMS bond and tors dev 0.0040 2.3978 
   :Min and Max bond dev  0.0003 0.0094 
   :Min and Max tors dev  0.2952 6.1112 
   :Sum & delta Centroids 0.9712 0.7511 0.5731 0.1086 0.2461 0.4771 
   :Transformation 0.9662 0.1296 -0.071 -0.237 0.961 0.146 -0.476 0.292 -0.960
   :Det and trace -1.0000 0.9679 
   :Closeness to ideal rotation 0.21507 
   :Closeness to group operator 0.21567 
   :Combined measure of closeness 0.21522 
   :Rworst & Raverage 0.203432098 0.186725736 10 
   :Symmetry m 
   :Pseudo m 
   :Operator 0.11+X 0.25+Y 1.15-Z 
   :No_Atoms 11 
   :S.G. P N A 21 
   :Cell 7.5570 11.4580 17.6020 90.0000 90.0000 90.0000








.. index:: BONDCALC


.. index:: Calculation of interatomic bonds


.. _LIST41:

 
=============================================
Calculation of interatomic bonds - \\BONDCALC
=============================================




::


    \BONDCALC
     END







::


    \BONDCALC FORCE
    END






This routine calculates a list of unique bonds between
atoms in LIST 5 including bonds to symmetry related atoms.
The bonds are stored in LIST 41.


----------------------
 Method of calculation
----------------------

   

   
   The BONDCALC routine uses the atomic positions from LIST 5 (the
   model parameters, see :ref:`LIST05`) (together
   with cell (LIST 1, see :ref:`LIST01`) and spacegroup information 
   (LIST 2, see :ref:`LIST02`),
   the covalent radii from LIST 29 (atomic properties, see :ref:`LIST29`), and any 
   additional bonding information in LIST 40 to calculate a list of bonds. 
   The algorithm and tolerances used depend upon settings in LIST 40.
   

   
   LIST 41 is only updated by \\BONDCALC if there has been a change
   to LISTS 5 or 40 OR if \\BONDCALC FORCE is issued.
   
   
   
   
.. index:: LIST 40


.. _LIST40:

 
===============================
Bonding information - \\LIST 40
===============================




::


    \LIST 40
    DEFAULTS TOLTYPE= TOLERANCE= MAXBONDS= NOSYMMETRY= SIGCHANGE=
    READ NELEMENTS= NPAIRS= NMAKE= NBREAK=
    ELEMENT TYPE= RADIUS= MAXBONDS=
    PAIR TYPE1= TYPE2= MIN= MAX= BONDTYPE=
    MAKE TYPE= SERIAL= S= L= TX= TY= TZ=
         TYPE2= SERIAL2= S2= L2= TX2= TY2= TZ2= BONDTYPE=
    BREAK TYPE= SERIAL= S= L= TX= TY= TZ=
          TYPE2= SERIAL2= S2= L2= TX2= TY2= TZ2=
    END






**DEFAULTS TOLTYPE= TOLERANCE= MAXBONDS= NOSYMMETRY= SIGCHANGE=**




This directive may only appear once. It affects the algorithm used
to update LIST 41.


*TOLTYPE=*


A value of 1 (default) causes \\BONDCALC to use as a threshold for
bonding, the sum of the covalent radii * the tolerance given.
A value of 0 causes \\BONDCALC to use the sum of the covalent radii + the
tolerance given (in Angstroms), as a threshold.


*TOLERANCE=*


The tolerance to be used in the \\BONDCALC calculation as a threshold
for bonds. Exact use depends on the value of the TOLTYPE keyword above.


*MAXBONDS=*


Specifies the maximum number of bonds that may be formed to an atom. The
BONDCALC calculation proceeds through the list of atoms searching for bonds,
according to the TOLERANCE criteria. If more than MAXBONDS bonds are found,
the best MAXBONDS will be kept. Best bonds are those where the sum of the
covalent radii is closest to the actual bond length. (Where a PAIR 
directive has been used, the best are the closest to the mean of the min and 
max values  on the PAIR directive.)
Note well: The calculation proceeds through the list of atoms, so bonds
are formed from atoms near the top of the list to those lower down. While
atoms lower down will still only form at most MAXBONDS bonds, they are 
less likely to be the 'best' bonds since they are formed from atoms higher
up the list. E.g. You have an H right at the end of the list, and you
set MAXBONDS=1 for H (see ELEMENT). If the first atom forms a bond to that
H, then no more bonds can be formed to that H even if they are better.
If the H were at the top of the list it would get the choice of which bonds
to pick. This is fairly unimportant stuff, it is rare that there will
be ambiguities over whether something is bonded or not. The default value
of MAXBONDS is therefore 15.


*NOSYMMETRY=*


0 (default) searches for all symmetry related bonds.
1 ignores symmetry, will not find bonds across operators, may speed
up bond bond calculation slightly.


*SIGCHANGE=*


Number of angstroms that any atom in LIST 5 must move during refinement
for it to be considered a significant change resulting in a recalculation
of bonding.


**READ NELEMENTS= NPAIRS= NMAKE= NBREAK=**


Specify the number of ELEMENT, PAIR, MAKE and BREAK directives that are
to follow.


**ELEMENT TYPE= RADIUS= MAXBONDS=**


Override the covalent radius in L29 and the MAXBONDS value on the DEFAULTS
directive for a specific element.


*TYPE=*


The element type. E.g. C


*RADIUS=*


The covalent radius to use for this element.


*MAXBONDS=*


The maximum number of bonds to this element.

DPAIR TYPE1= TYPE2= MIN= MAX= BONDTYPE=
Override the covalent based calculation altogether.


*TYPE1=*


An element type, e.g. C


*TYPE2=*


An element type, e.g. O


*MIN=*


The minimum length of a bond.


*MAX=*


The maximum length of a bond.


*BONDTYPE=*


The bondtype to be assigned to this bond. BONDCALC will eventually have a
go at bond type assignment, if you are forced to add in extra PAIR
commands then there is not much chance that the assignment will be correct
so it can be specified here. Use 0 for unknown.


More than one pair of the same elements can be used at once:

::


   e.g.
     PAIR C O 1.0 1.2 BONDTYPE=2
     PAIR C O 1.2 1.4 BONDTYPE=1






**MAKE TYPE= SERIAL= S= L= TX= TY= TZ= TYPE2= SERIAL2= S2= L2= TX2= TY2= TZ2= BONDTYPE=**


Makes a bond between two atoms (possibly symmetry related).


*TYPE= TYPE2=*


An element type, e.g. C.


*SERIAL= SERIAL2=*


The serial number of the atom. (From List 5, atomic parameters).


*S= S2=*


The number of the symmetry matrix used from List 2 (list of space group 
symmetry operators, see section :ref:`LIST02`) (default, unity = 1).
Negative indicates centre of symmetry applied aswell.


*L= L2=*


The number of the non-primitive lattice translation from List 2. (default =1, 
see section :ref:`LIST02`)


*TX= TY= TZ= TX2= TY2= TZ2=*


Translations from asymmetric unit co-ordinates.


*BONDTYPE=*


The bondtype to be assigned to this bond. BONDCALC will eventually have a
go at bond type assignment, if you are forced to add in extra MAKE
commands then there is not much chance that the assignment will be correct
so it can be specified here. Use 0 for unknown.


**BREAK TYPE= SERIAL= S= L= TX= TY= TZ= TYPE2= SERIAL2= S2= L2= TX2= TY2= TZ2=**


As for MAKE, but without the BONDTYPE keyword.



.. index:: BONDING


===============================
Bonding information - \\BONDING
===============================


::


    \BONDING ACTION
    DEFAULTS TOLTYPE= TOLERANCE= MAXBONDS= NOSYMMETRY= SIGCHANGE=
    ELEMENT TYPE= RADIUS= MAXBONDS=
    PAIR TYPE1= TYPE2= MIN= MAX= BONDTYPE=
    MAKE  atom-specification TO atom-specification bondtype
    BREAK atom-specification TO atom-specification
    END






THis is a more user-friendly alternative to inputting a LIST 40.
Directive syntax is like \\LIST 40 with the following exceptions:


1) ACTION. This can take two values:

::


         REPLACE (Default, and replace previous LIST 40 with a new on)
         EXTEND  (adds new commands to end of existing LIST 40)






2) The MAKE and BREAK directives look like this:

::


    MAKE C(1) TO C(4) 8
    BREAK N(1) TO H(14)






Symmetry may be specified in the standard CRYSTALS way, the numbers
in parenthesis are serial,S,L,Tx,Ty,Tz (see above) the list may be
truncated when the rest are default values: (serial,1,1,0,0,0):

::


    MAKE C(1,2,1,0,1,1) TO C(8) 4






3) The READ directive need not be given. This makes it easier to edit
text files containing the command as you don't have to remember to alter
the values on the READ directive.


3) The command may be given as \\BONDING EXTEND, in which case it takes
any directives given and adds them to the existing LIST 40.



===================
Printing of LIST 40
===================



LIST 40 may be listed with either

----------
\\PRINT 40
----------

   or

------------
\\SUMMARY 40
------------


   
   LIST 40 may be punched with

----------
\\PUNCH 40
----------

   which will produce a standard List 40 in CRYSTALS format, or

-------------
\\PUNCH 40 B 
-------------

   which will produce a \\BONDING command which is easier to edit.
   
   

=======================
Creating a null LIST 40
=======================



A null LIST 40, containing no extra information, may be created with

::


    \LIST 40
    END




or

::

 
    \BONDING
    END





===================
Printing of LIST 41
===================



LIST 41 may be listed with either

----------
\\PRINT 41
----------

   or

------------
\\SUMMARY 41
------------


   
   Issuing \\BONDCALC when there is no LIST 40 will cause a null list 40
   to be created.
   
   
   
   