.. toctree::
   :maxdepth: 1
   :caption: Contents:

   
      
   


****************
Twinned Crystals
****************


.. index:: Twinning


.. _twinning:

 
.. _LIST25:

 
=======================
Twinning - introduction
=======================







The terminology in articles on twinning is complicated and sometimes
contradictory, with the same term being used in different contexts by
different authors. We shall use the following terms, based upon
observations made from the **whole** reciprocal lattice.



It is assumed that sufficient reflections are measured to give a
complete coverage of the asymmetric part of the r.l. for at least one
(called the major) component of the twinned crystal.


----------
TLQS twins
----------


   
   Some, but possibly not all, of the reflections from the major
   component contain contributions from other twin components.  Overlap is
   controlled by accidental relationships between cell parameters. If the
   relationship is very exact, so that all reflections are overlapped, the
   sample is a **pseudo** **TLS** twin.

---------
TLS twins
---------


   
   Every reflection from the major component contains a
   constant fractional contribution from other components. The overlap is
   controlled by the crystal class rather than accidental relationships
   between cell parameters.
   

**TLS twins - Class I**


   Except for the effect of anomalous dispersion, the Laue
   symmetry of the diffracion pattern is the same as that of an un-twinned
   crystal.
   

**TLS twins - Class II**


   The Laue
   symmetry of the diffracion pattern is **not** the same as that of an un-twinned
   crystal.
   
   

=================
Twinning Problems
=================

The analysis of twinned structures is complicated by several issues.


1. Identification that the crystal is indeed twinned.



------------------------
Twinning - Initial clues
------------------------

   These may include may include:
   
   
   a. Evident interpenetrating reciprocal lattices.
   
   
   b. Split reflections, with a varying intensity ratio.
   
   
   c. Systematic absences not conforming to any space group.
   
   
   d. The ratio of intensties of equivalent reflections from
   different samples is not constant.
   
   
   Other clues are:
   
   
   a. Failure to solve the structure from apparently good data.
   
   
   b. Irreducible R factor from seemingly good quality data.
   
   
   c. Inexplicable strong residual peaks in the difference density
   map.
   
   
   

-----------------------------------------
Twinning - Data collection and processing
-----------------------------------------

   
   

   
   
   a.
   
   
   There is usually no difficulty in collecting data for TLS twins.
   For TLQS twins, each observation needs to be tagged to indicate which
   twin components (elements) contribute to the observation. This may be
   simply computed from the indices if the different lattices have a
   more-or-less exact relationship between them, of may need to be assigned
   more carefully if the twin obliquity causes only partial overlapping of
   some reflections. For doublet spots, it is important that either the
   whole doublet is integrated (tag '12'), or the principal component is
   separated out (tag '1').
   
   

   
   
   b.
   
   
   There may be serious difficulties in determining the space
   group. Trial and error may be the only procedure available.
   
   

   
   
   c.
   
   
   The space group used for data reduction  (section :ref:`DATAREDUC`)
   and merging may not be
   that of the major component. A Space group showing the symmetry of the
   twinned diffraction data should be used initially. The correct space group
   should be used once data reduction is complete.
   
   

-----------------------------
Twinning - Structure solution
-----------------------------

   
   In general, structure solution is the major difficulty in working
   with twinned crystals.

   
   
   a.
   
   
   For TLQS structures, if a substantial number of reflections are
   from the major component only, the structure may solve by traditional
   methods.
   
   

   
   
   b.
   
   
   For Class I TLS structures, structure solution is usually
   straight forward, the components of the twin differing only by the
   effects of anomalous scattering. Such twins (merohedral twins, or
   twinning by inversion) can be processed without further reference to this
   part of the manual. All that needs to be refined is the Flack
   enantiopole parameter. See the main chapter on refinement.
   
   

   
   
   c.
   
   
   For Class II TLS structures, if the twin ratio is far from 50:50, the
   structure may solve by traditional methods.
   
   

-------------------------------
Twinning - Structure Refinement
-------------------------------

   
   If the space group, trial structure, twin law and reflection
   components are known, this is straight forward. The sum of the twin
   fractions must be 1.0
   
   
   

----------------------------
Twin Data stored by CRYSTALS
----------------------------


   
   
   For a twinned crystal the following equation holds.
   ::


            Fsq(obs) = v1.Fsq(1) + v2.Fsq(2) ....
   


   
   and similarly for F(calc). The v(i) are the volume fractions of the
   components contributing to the observation. A Fourier synthesis using /Fobs/ as
   coefficient is meaningless, since the phase alpha(calc) will belong to
   only one of the components. The terms needed for Fourier and other
   calculations are Fcalc(1), alpha(1) Fobs.vol-fract(1), i.e. only that
   contribution to Fo due to the principal element.
   

   
   
   For a twin with two components, each observation may contain a
   contribution from each component, or from both. The reflections have to
   be 'tagged' to indicate which components are contributing, the ELEMENT
   coefficient in LIST 6  (section :ref:`LIST06`)
   

   
   
   For a TLS twin, every observation contains a contribution from both
   components (though if it is a systematic absence for one component, the
   contribution will be zero). Since the tagging is the same for every
   reflection, it can be inserted automatically by CRYSTALS
   

   
   
   For a TLQS twin, some observations will contain a contribution from the
   principal component, and some from both components, giving ELEMENT tags
   of '1' and '12' respectively. If additional observations have been made
   based on the reciprocal lattice of component 2, and are indexed with
   respect to lattice 2, they are given the tag '2'. If any of these
   also contain a contribution from component 1, the tag will be '21'.
   

   
   
   Example 1. An orthorhombic space group with a~b, twinned by interchange
   of 'a' and 'b'. If 'a' is very similar to 'b', every observation 'hkl' will
   overlap with  twin component 'khl', and the ELEMENT tag will be '12',
   the default. If a systematic absence from element 1 falls on element 2,
   the reflection should not be eliminated during data reduction, and will
   have the tag '12', even though the contrinbution from 1 is zero.
   

   
   
   Example 2. A monoclinic crystal with 2cCos(beta)/a about 1/3. Twinning
   by a 2 fold rotation about 'a' gives a twin law
   ::


              1   0   0
              0  -1   0
            -1/3  0  -1
   


   
   Overlap of reflections from both components will only occur when 'h' =
   3n, giving the ELEMENT tag '12'. If the lattice is only sampled at r.l.
   points corresponding to the principal indexing, reflections with 'h' 
   
   3n will have the tag '1'.
   
   

-------------------------
Twinning - LISTS affected
-------------------------

   ::


      LIST 5  - Parameters: the number of twin elements and their values must be set.
      LIST 6  - Reflections: the observed twinned data must be stored as /FOT/, and the
                twin element tags be set.
      LIST 12 - Constraint matrix: the twin elements must be refined, and possibly constrained.
      LIST 13 - Experimental info: the key CRYSTAL TWIN=YES must be set.
      LIST 16 - Restraints: the twin elements may be restrained.
      LIST 25 - This contains the twin laws themselves.
   


   
   

-----------
Twin List 5
-----------

   The number of twin elements and their values must be given. Currently,
   the number of elements and their starting values cannot be input in
   \\EDIT (though values can be changed later). Punch LIST 5, edit it, and
   re-input it, or use the SCRIPT EDLIST5.
   
   ::


      \LIST 5
      READ NATOM=  NELEMENT=
      ELEMENT value(1) value(2) ...
      ATOM ..........
      ......
      END
   


   
   

-----------
Twin List 6
-----------

   
   
   For TLQS twins, the element tags (section :ref:`LIST06`)
   really depend upon exact experimental conditions, and should be computed
   by the data collection software. If a reflection is entered without a
   twin element tag (eg a SHELX HKL 4 file),
   CRYSTALS tries to compute the tag from the twin laws
   as follows:

            h      the index with respect to LIST 1 (cell) and LIST 2 (space group)(this is the index in LIST 6)

            T      The twin law matrix.
			
            n      the nominal index for the twinned reflection. n = T.h

            d      the difference between an exact lattice point and the generated point. n-nint(n)

            s      The squared length of the difference vector, in :math:`\mathring{A} {}^{-2}`.
      
   
   
   If 's' is less than the TWINTOLERANCE given on the LIST 6 MATRIX
   directive, the twinned reflection is regarded as falling upon a primary
   element reflection, and the element tag is updated to indicate this.
   This method is only an approximation, but may help to make otherwise
   useless data useable. LIST 13 (section :ref:`LIST13`) will be automatically
   updated to indicate that twinned data are being refined.
   
   

   
   a)Analysis was started as untwinned, and the user wishes to convert to
   a twinned refinement
   
   The twin laws must be entered and CRYSTALS instructed to convert the
   reflection list to a twinned list.
   ::


            \LIST 25
            READ NELEMENT=2
            MATRIX 1 0 0  0 1 0  0 0 1
            MATRIX 0 1 0  1 0 0  0 0 1
            END
            \LIST 6
            READ TYPE=TWIN
            MATRIX TWINTOL=.001
            END
            
   


   
   

   
   b)Crystal identified as twinned, and data reduction, sorting and 
   merging done outside of CRYSTALS
   
   

   
   If the reflection data has been preprocessed so that it is a full,
   unique, set for the corret space group, then the correct space group
   should be entered, and the reflections input as FOT directly. This tells
   CRYSTALS that the data is twinned. 
   ::


            \LIST 25
            READ NELEMENT=2
            MATRIX 1 0 0  0 1 0  0 0 1
            MATRIX 0 1 0  1 0 0  0 0 1
            END
            \OPEN HKLI TWINREF.HKL
            \LIST 6
            READ   F'S=FSQ  NCOEF = 5  TYPE = FIXED CHECK = NO
            INPUT H K L /FOT/ SIGMA(/FO/)
            FORMAT (3F4.0,2F8.0)
            STORE NCOEF=9
            OUTPUT   INDICES /FO/ SIGMA(/FO/) /FOT/ /FC/ SQRTW ELEMENT
            CONTINUE RATIO/JCODE CORRECT
            MATRIX TWINTOL=.001
            END
   


   
   
   

   
   c)Data reduction, sorting and merging to be done in CRYSTALS
   
   

   
   
   During initial data reduction  (section :ref:`DATAREDUC`) the crystal must 
   be given as **untwinned**
   in LIST 13 (section :ref:`LIST13`), and the 'space group' should be that of the
   Laue Class of the intensity data, so that the symmetry of the data is
   preserved. In  general, systematic absences should be preserved, unless
   centring of the cell matches for all twin components. Twin elelemt tags
   may be provided by an external program, or computed by CRYSTALS.

   
   
   If there are special ELEMENT tags, use something like the following:
   
   ::


      \OPEN HKLI twin.hkl
      \LIST 6
      READ   F'S=FSQ  NCOEF = 6  TYPE = FIXED CHECK = NO
      INPUT H K L /FO/ SIGMA(/FO/) ELEMENTS
      FORMAT (3F4.0, 2F8.0, F3.0)
      STORE NCOEF=7
      OUTPUT INDICES /FO/ SIGMA(/FO/) ELEMENTS RATIO/JCODE CORRECTIONS SERIAL
      END
   


   
   After initial processing, LIST 13 (section :ref:`LIST13`) should be changed 
   to twinned, the
   correct space group entered, and the value of the observed structure
   factor stored as FOT, the Total or Twinned structure factor. This is
   done by a special call to the LIST 6 instruction (which also sets the
   TWIN flag in LIST 13).
   ::


      \LIST 6
      READ TYPE=TWIN
      MATRIX TWINTOL=.001
      END
   


   
   
   
   
   

------------
TWIN LIST 13
------------

   
   The keyword TWINNED must be set to YES for structure factor
   calculations. Because different components of a twin will probably have
   different extinction corrections, refinement of extinction is deprocated
   for twins. CRYSTALS prints a warning, then lets you continue at your own 
   risk.
   The special use on the LIST 6 command (above) will update
   LIST 13 automatically.
   
   ::


      \LIST 13
      ....
      CRYSTALS FRIEDEL=NO  TWIN=YES  EXTINCTION=NO
   


   
   

------------
Twin List 12
------------

   
   If all the element scale factors are refined simultaneously with the
   overall scale factor, the calculation will be singular. In general, the
   sum of the element scale factors is held at unity. For only two twin
   componenets, this can be done in LIST 12 as a constraint. For more, it
   can be done in LIST 16 as a restraint. The sum of the elements in input
   to LIST 5 should be unity.
   ::


      \LIST 12
      FULL ........
      EQUIVALENCE ELEMENT(1) ELEMENT(2)
      WEIGHT -1 ELEMENT(2)
      END
   


   
   

   
   For a twin with more that 2 components (for example, twinning by some rotation/reflection
   plus enantiomeric (Flack) twinning), an alternative LIST 12 construct should be used.
   ::


      \LIST     12                                                                    
      BLOCK SCALE X'S, U'S 
      SUMFIX ELEMENT SCALES 
      END
   


   

   
   The Flack parameter is just a short-cut to twinning by inversion. If you have additional twinning, then you have to do it the hard way by including all the twin laws in LIST 25, setting the appropriate ELEMENT flags in LIST 6, and appropriate instructions in LIST 12

   
   
   If for example the macroscopic twin law is a reflection in P41, eg (0 1 0,  1 0 0, 0 0 1), then LIST 25 would be
   ::


      1 0 0  0 1 0  0 0 1  (the unit operator)
      1 0 0  0 1 0  0 0 -1 (inversion)
      0 1 0  1 0 0  0 0 1  (reflection)
      0 1 0  1 0 0  0 0 -1 (inversion and reflection)
   


   

   
   
   and every reflection would, have the ELEMENT key 1234.
   

------------
Twin List 16
------------

   
   The sum of the element scale factors can be restrained to unity in LIST
   16. In this case, they must all be freely refined in LIST 12.
   ::


      \LIST12
      FULL ........
      CONTINUE ELEMENT SCALES
      END
      \LIST 16
      SUM .0001 ELEMENT SCALES
      END
   


   

============================================
SORTING TWINNED STRUCTURE DATA  -  \\REORDER
============================================



For a twinned structure, after the data have been merged,
it is advisable to re-sort the reflections, placing observations
that contain contributions from elements with the same indices
adjacent in the new LIST 6.

---------
\\REORDER
---------


   
   This directive initiates the re-sorting of reflections for
   a twinned structure. It is IMPERATIVE that the previous command
   has put the reflections on the disc. This is automatic if input
   is via a \\LIST 6 command (section :ref:`LIST06`) or you can use 
   the \\LIST 6
   READ TYPE=TWIN command.
   

**STORE MEDIUM=**


   This directive determines the output medium of the new LIST 6.
   

*MEDIUM*


   This parameter selects the output medium of the new LIST 6.
   The allowed values for this parameter are :
   ::


            M/T
            DISC   -  DEFAULT VALUE.
   


   
   The default output medium is usually to disk.
   ::


      /REORDER
      END
   


   

------------------------------
Twins - backward compatability
------------------------------

   ::


      Note that the key /FOT/ can be given in the initial data reduction if the
      crystal is also marked as twinned in LIST 13, and 
      the observed intensity
      input as /FOT/. This is preserved for backwards compatibility.
   


   

----------------------
Twins - Worked Example
----------------------

   The data were provided by Simon Parsons, for a TLQS twin, where
   the bulk of the data is from only one component. For reciprocal lattice
   layers with h=3n, there is overlap from the second twin component. The
   'elelent keys' are thus '12' for reflections with h=3n, otherwise '1'.
   

   
   
   Sections of reflection file 'example.hkl'
   ::


        -6   0   0    2.16    1.08  12
        -6   0  -1   -0.47    0.93  12
        -6   0  -2   24.98    1.63  12
      ......
        -6  -2   0    1.64    0.95  12
        -6  -2  -1    8.40    1.06  12
        -6  -2  -2    3.33    1.18  12
        -5   5   1   10.61    1.22   1
        -5   5   2    0.75    0.96   1
      ........
        -4   0   3   -0.45    0.63   1
        -4   0   4    4.73    0.82   1
        -4   0   5   -0.78    0.71   1
        -4   0   6   48.40    1.69   1
        -4   0   7    0.12    0.68   1
        -4   0   8   -0.35    0.83   1
        -3  -7   0    7.68    1.24  12
        -3  -7  -1   13.11    1.45  12
        -3  -7  -2   13.89    1.36  12
      .......
   


   
   The data can be processed in the true space group. LIST 6 (reflection) 
   input includes
   the 'element keys'. After data reduction, the data is stored as
   'TWINNED' by the call to LIST 6 which saves the data in the .DSC file. 
   ::


      \  Input the cell parameters
      \LIST 1
      REAL 7.2847 9.74 15.231 90 94.386 90
      END
      
      \  Input the space group
      \SPACEGROUP
      SYMBOL p 21/n
      END
      
      \  Input the experimental data
      \list 13
      crystal  friedel = no twinned=no
      cond wave=1.5418
      end
      
      \  Input the twin laws, including the identity matrix
      \  which corresponds to the first component of the
      \  twin, i.e. the one it was indexed on.
      \list 25
      read nele=2
      matrix 1 0 0 0 1 0 0 0 1
      matrix 1 0 0 0 -1 0 -.33333 0 -1
      end
      
      \  Input scattering factors (list 3) and cell contents 
      \  (list 29) using the composition command:
      \COMPOSITION
      CONTENTS c  48  h  44  s  4  o  4  n  4
      SCATT  CRSCP:SCATT
      PROPER CRSCP:PROPERTIES
      END
      
      \  Specify how the SFLS calculations should be done:
      \LIST 23
      MINIMISE  F-SQ=no
      modify  anomalous=yes
      END
      
      \  Input a whole model: scale parameter, twin element scales and
      \  the atom parameters.
      \list 5
      read natom = 5 nelem=2
      overal scale=.2
      elem .5 .5
      atom s    1         1.0000    0.0398    0.9390    0.3740    0.3888
      atom n    2         1.0000    0.0617    0.6708    0.1939    0.3428
      atom o    3         1.0000    0.0460    0.6967    0.4265    0.5265
      atom c    4         1.0000    0.0416    0.9097    0.0426    0.2936
      atom c    5         1.0000    0.0317    0.7467    0.2938    0.3989
      end
      
      \  Open a file on the device called 'HKLI'
      \CLOSE HKLI
      \OPEN HKLI example.hkl
      
      \  Read data from that device into LIST 6 in the 
      \  specified format and leave space for the specified
      \  keys.
      \list 6
      READ   F'S=FSQ  NCOEF = 6  TYPE = FIXED CHECK = NO
      INPUT H K L /FO/ SIGMA(/FO/) ELEMENT
      FORMAT (3F4.0, 2F8.0,f4.0)
      STORE NCOEF=7
      OUTPUT INDICES /FO/ SIGMA(/FO/) RATIO/JCODE CORRECTIONS SERIAL ELEMENT
      END
      
      \  Remove systematic absences and move hkl indices by symmetry so that
      \  they fall into a unique volume of reciprocal space:
      \SYST
      \  Sort the reflections:
      \SORT
      \  Merge adjacent reflections with the same indices:
      \MERGE
      END
      
      \  Store the reflections and at the same time, guess the element
      \  key using the twin laws in L25 to predict if overlap is likely.
      \List 6
      read type=twin
      end
      
      \  Compute the scale factor
      \SFLS
      SCALE
      END
      
      \  Set up the matrix of constraint (aka the refinement
      \  directives):
      \LIST 12
      FULL FIRST(X'S, U[ISO]) UNTIL C(15)
      equivalence element(1) element(2)
      weight -1 element(2)
      END
      
      \  Carry out one cycle of least squares refinement:
      \SFLS
      REF
      END
   


   
   

-------------------------------
Twinning - Mathematical aspects
-------------------------------

   
   
   In a twinned crystal, two or more separate components or  ELEMENTS
   contribute to the diffraction pattern,
   and the observed intensities may
   contain contributions from any one of the possible twin component
   In addition, the amount of each twin component
   present in a specified unit of volume is not restricted, and in
   general will vary between different samples of the same
   material.

   
   
   The expression for an observed intensity in such a case
   is given by :
   ::


       It = v1*I1 + v2*I2 + . . + vn*In
   


   
   Where  *It*  is the total observed intensity to which *N*
   components contribute,  *Ii*  is the intensity of component  *i* ,
   and  *vi*  is the amount of component  *i*  present in a given
   volume.
   The  *vi*  are known as the 'component scale factors', and
   are conventionally taken to be
   the amount of the given component present in a unit volume of the
   crystal, so that :
   ::


       SUM(vi) = 1      over all the components.
   


   
   When a set of reflection data is handled for a twinned crystal,
   it is thus necessary to know which of the possible components
   contribute to the current reflection, and
   to be able to generate the indices
   of each of the components from a set
   of indices given in a standard reference system.
   If the indices of an component in its own reference system are
   given by the vector
   Hc  and those in the standard system by  H , the necessary
   interconversion is given by :
   ::


       Hc = R.H
   


   
   R  is a rotation matrix that describes the transformation
   of the indices.
   (The generation of the various sets of indices can be thought of
   as a rotation centred on the origin).
   The indices  Hc  are of necessity integers, but the components of
   H  may in general take any value.

   
   The interconversion of atomic coordinates between the various
   reference systems in a twinned crystal can also be expressed
   in terms of  R  :
   ::


       Hc[T].Xc = H[T].X      for any component.
   


   
   Where  X  is the coordinate vector for any atom in the standard
   reference system,  Xc  is the coordinate vector for the
   same atom in the reference system for one of the components and
   H[T]  indicates  H  transposed.
   The above expression may be rewritten as :
   ::


       H[T].R[T].Q.X = H[T].X
   


   
   Where  Q  is the matrix that converts the atomic coordinates.
   Therefore :
   ::


       R[T].Q = I
   


   
   Where  I  is the unit matrix.
   The matrix  Q  is thus given by:
   ::


       Q = R[TI]
   


   
   Where  R[TI]  indicates  R  transposed and inverted.
   The coordinates therefore transform as :
   ::


       Xc = R[TI].X
   


   

   
   Before any reflections can be processed, the matrices  R  must
   be provided.
   These are given in LIST 25, which must contain one matrix for
   each possible component.
   (If the standard system is chosen as that of component 1, for example,
   the first  R  matrix will be the unit matrix, which must be given
   as it is not assumed).
   
   
   
