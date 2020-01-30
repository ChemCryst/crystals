.. toctree::
   :maxdepth: 1
   :caption: Contents:

.. include:: ../macros.bit


.. index:: Atom Identifiers and Parameters

.. _atoms:

#################################
Atomic Identifiers and Parameters
#################################

Dependig on the context, a user may wish to refer to an atom or group
of atoms, or to an atomic parameter or group of parameters.  



 

****************
Atom identifiers
****************

Atom identifiers consist of two parts, a letter string (TYPE)
which is used
to associate the atom with atomic properties (form factor, radius etc), and
a SERIAL
number in parentheses. The total identifier should be unique for each atom.
Two special identifiers, FIRST and LAST refer to the first and last atoms in
the atom list, and must not have serial numbers.  The identifier ALL refers to all atoms 
in the list |br|\
Groups of atoms may be referenced in several ways:
 
::

      #EDIT
      DELETE C(3) UNTIL C(9)
      DELETE C(4) UNTIL LAST
      DELETE FIRST UNTIL LAST
      DELETE ALL
      END


This 'UNTIL' sequence causes the requested operation (deletion in the example
above) to be performed on all
the atoms in the atom list (LIST 5) between and including C(3) and C(9)
A thoughtfull naming of the atoms and ordering of the atom list can save
a lot of typing later. Symmetry operators can also be included in an atom
specification.  See :ref:`atomparams`.

 

**************************
Atom parameter identifiers
**************************

Atomic parameters are specified in an analogous way. The name of the
parameter being operated on is included with the atom serial number inside
the parentheses. 
 
::

 e.g.
      !BLOCK      C(2,X,Y,Z) UNTIL C(23)
      !BLOCK      C(2,X'S,U'S) UNTIL C(23)
      !BLOCK      X'S U'S



The first example specifies
a least squares matrix block for the x, y and z parameters for
atoms C(2) until and including C(23). In example 2, the parameters X'S
and U'S are permitted
abbreviations for X,Y,Z and similarly for the anisotropic temperature
factor components. A parameter appearing without an atom identifier
(X'S and U'S in example 3) implies the named parameters for all 
atoms except hydrogen. |br|\
Permitted model parameters are:
 
::

 Overall parameters
    SCALE OU[ISO] DU[ISO] POLARITY ENANTIO EXTPARAM
 Atomic parameters
    OCC U[ISO] X Y Z U[11] U[22] U[33] U[23] U[13] U[12]
 Abbreviated parameters
    X'S      Indicating  X,Y,Z
    U'S      Indicating  U[11],U[22],U[33],U[23],U[13],U[12]
    UII'S    Indicating  U[11],U[22],U[33]
    UIJ'S    Indicating  U[23],U[13],U[12]
 Special abbreviations
        FIRST
        LAST
        ALL
  


Batch, layer and twin scale factors are also permitted.

