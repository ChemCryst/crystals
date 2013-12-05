! TLST18 - temporary storage for bond list. To be replaced with LIST18.
      REAL BBLK(1500,9)                                                 
      INTEGER NB18                                                       
      COMMON /BOND18/ BBLK, NB18                                          
      DIMENSION IBLK(1500,9)                                               
      EQUIVALENCE (BBLK(1,1),IBLK(1,1))

