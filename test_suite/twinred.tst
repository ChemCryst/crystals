\set time slow
\rele print CROUTPUT:
\LIST 1
REAL 20.033 19.9759 13.3995
\LIST 2
\ P222 This is a dummy to preserve 'absences' since some are
\ 'present' due to the twinning.
CELL NSYM=4 LATT=P CENT=NO
SYMM X,Y,Z
SYMM X,-Y,-Z
SYMM -X,Y, -Z
SYMM -X,-Y,Z
\LIST 3
\ Exponential scattering factors for Cu radiation taken from
\ International Tables Vol IV
READ NSCAT=2
SCAT O    0.047 0.032 3.04850 13.2771 2.28680 5.70110 1.54630
CONT            0.323900 0.867000 32.9089 0.250800
SCAT SI  0.244 0.330 6.29150 2.43860 3.03530 32.3337 1.98910
CONT           0.678500 1.54100 81.6937 1.14070
\LIST 13
\ Set TWINNED = NO here or set the key /FOT/ fo input in HKLI
CRYSTAL TWINNED=NO
DIFFRACTION GEOM=CAD4
CONDITIONS  1.5418
MATRIX
\LIST 14
X-AXIS 0 .5
Y-AXIS .25 .75
Z-AXIS -.25 .25
\LIST 25
READ NELEMENT=2
MATRIX 1 0 0  0 1 0  0 0 1
MATRIX 0 1 0  1 0 0  0 0 1
\LIST 5
READ NATOM=8 NELEM=2
ELEMENT .73 .27
ATOM SI 1 X=.1215 .3256 .9731
ATOM SI 2 X=.2741 .3252 .9715
ATOM SI 3 X=.0767 .4412 .8365
ATOM SI 4 X=.0712 .3690 .1825
ATOM SI 5 X=.3144 .4403 .8318
ATOM O 1 X=.1139 .25 .9279
ATOM O 2 X=.1956 .3466 .9631
ATOM O 3 X=.0819 .3705 .8874
END
\
\ Note that the data reduction produces a LIST 6 NOT
\ containing any information about the twinning, since
\ this information is not present in the CAD4 output
\ file. We must punch out LIST 6, and perform an operation
\ on the term 'ELEMENTS' to indicate which elements actually
\ contribute to the reflection.
\
\ The Lp correction was done elsewhere
\HKLI 
READ NCOEF=4, TYPE=FIXED, F'S=FSQ, UNIT = DATAFILE
INPUT H K L /FO/ 
FORMAT (3F4.0,F10.2)
END
   2   0   0     55.12   
   4   0   0     41.92   
   6   0   0     54.53   
   8   0   0     75.09   
  10   0   0    167.25   
  14   0   0     14.61   
  16   0   0     85.46   
  18   0   0     41.08   
  20   0   0     40.36   
   2   1   0     17.84   
   6   1   0     12.02   
  14   1   0      8.13   
  20   1   0      8.91   
   0   2   0     54.23   
   1   2   0     11.15   
   2   2   0     23.78   
   3   2   0     16.38   
   4   2   0     15.32   
   5   2   0     17.28   
   8   2   0     32.72   
  10   2   0     25.06   
  12   2   0      9.37   

   2   0  15      7.94   
   4   0  15     10.11   
   5   0  15     17.23   
   4   2  15     11.40   
   0   4  15     11.04   
   0   5  15     18.60   
   2   5  15      9.72   
-512
\SYST
\SORT
\MERGE
WEIGHT SCHEME=2 NPARAM=6
PARAM .05 3.0 1.0 2.0 .01 .0001
REJECT RATIO=2.5 SIGMA=2
REFLECT 
\LIST 2
\ Pnma. Since we wont do a SYST again, we can switch to the sg
\ for twin element 1.
CELL NSYM=4 LATT=P CENT=YES
SYMM X,Y,Z
SYMM 1/2+X,1/2-Y,1/2-Z
SYMM -X,1/2+Y, -Z
SYMM 1/2-X,-Y,1/2+Z
\LIST 6
READ TYPE = COPY
END
\PUNCH 6 C
END
\
\ This program, included as CRYSTALS comments, may be used as an example
\ for a module to generate the element flags given the twin laws. Note
\ that in this case most reflections overlap exactly (with element key 12)
\ so that the twin ratio is determined by only a small subset of the data
\ (with elements either 1 or 2). The indeterminancy in the twin ratio may
\ have effects on other parameters, particularly the U's.
\
\ 	PROGRAM TWIN
\ 	DIMENSION J(3), I(3)
\ C
\ C	RE-INDEXES TWINNED DATA AND SETS UP THE ELEMENT FLAGS FOR
\ C	A LIST 6 PUNCHED OUT OF CRYSTALS.
\ C
\ C	THE TWIN LAW FOR ELEMENT 2 IS
\ C
\ C	0 1 0
\ C	1 0 0
\ C	0 0 1
\ C
\ C   2   0   0     55.12    0.00      0.00 0.00000 0.00000E+00      0.00 12
\ C   4   0   0     41.92    0.00      0.00 0.00000 0.00000E+00      0.00 12
\ C
\ C
\ C
\ 10    CONTINUE
\ 	READ(1,100,END=20)I,FO,SERIAL,FC,PHASE,WEIGHT,FOT,J
\ 100   FORMAT (3I4,F10.2,F8.2,F10.2,F8.5,E12.5,F10.2,3I1)
\ C
\ 	J(1) = 0
\ 	J(2) = 1
\ 	J(3) = 2
\ 	IF (I(3) .EQ. 0) GOTO 200
\ 	IF (I(2) .EQ. 0) GOTO 300
\ 	IF (I(1) .EQ. 0) GOTO 400
\ 	GO TO 500
\ C
\ 200	CONTINUE
\ 	K=I(1)+I(2)
\ 	IF( MOD(K,2) .EQ. 0) GOTO 500
\ 	J(2) = 0
\ 	IF( MOD(I(1),2) .EQ. 0 ) THEN 
\ 		J(3) = 1
\ 	ELSE
\ 		J(3) = 2
\ 		K = I(1)
\ 		I(1) = I(2)
\ 		I(2) = K
\ 	ENDIF
\ 	GOTO 500
\ C
\ 300	CONTINUE
\ 	K=I(1)+I(3)	
\ 	IF( MOD(K,2) .EQ. 0) GOTO 500
\ 	J(2) = 0
\ 	J(3) = 1
\ 	GOTO 500
\ C
\ 400	CONTINUE
\ 	K =I(2) + I(3)
\ 	IF( MOD(K,2) .EQ. 0) GOTO 500
\ 	J(2) = 0
\ 	J(3) = 2
\ 	K = I(1)
\ 	I(1) = I(2)
\ 	I(2) = K
\ C
\ 500	CONTINUE
\ 	WRITE(6,100)I,FO,SERIAL,FC,PHASE,WEIGHT,FOT,J
\ 	GOTO 10
\ 20	CONTINUE
\ 	STOP
\ 	END
\
\ Punched on 30-APR84 at 15:37:55
\ The list as punched refers to an untwinned structure.
\ It was modified  in 4 ways.
\ 1. The item output above as /FO/ is infact the total amplitude, so we 
\    mustinterchange the keys /FO/ and /FOT/ for input
\ 2. Sigma and  Fo are now read as zero, which would cause the reflection 
\    (Sigma now set to 0.01 for all except 2 0 0 because of new sigma checking)
\    to be rejected on reinput. We must inhibit checking (which will normally
\    be OK since the data comes from a previous job).
\ 3. The value output for ELEMENTS, (zero) was modified (as above) to indicate
\    which twin elements contribute to the reflection. The first element
\    of the key indicates which element of the twin corresponds to the 
\    nominal index.
\ 4. The nominal indices, HKL, may need to be changed if there is no
\    contribution to the total from the 'main' (i.e. element 1) component.
\    In that case, HK and L must be the index of the first component in
\    ELEMENT. NOTE THAT IF THIS REINDEXING IS DONE ( by some procedure
\    external to CRYSTALS) the data MUST be RE-SORTED but MUST NOT be 
\    RE-MERGED. Use the instructions SORT and REORDER to reorder the data.
\
\LIST 6
READ NCOEFFICIENT = 10, TYPE = FIXED, UNIT = DATAFILE,           CHECK=NO 
INPUT  H K L /FOT/ SIGMA  /FC/ PHASE SQRTW /FO/ ELEMENTS
FORMAT (3F4.0,F10.2,F8.2,F10.2,F8.5,E12.5,F10.2,F3.0)
STORE NCOEF=7
OUTPUT INDICES /FO/ SQRTW /FC/ PHASE /FOT/ ELEMENTS
END
   2   0   0     55.12    0.00      0.00 0.00000 0.00000E+00      0.00 12
   4   0   0     41.92    0.01      0.00 0.00000 0.00000E+00      0.00 12
   6   0   0     54.53    0.01      0.00 0.00000 0.00000E+00      0.00 12
   8   0   0     75.09    0.01      0.00 0.00000 0.00000E+00      0.00 12
  10   0   0    167.25    0.01      0.00 0.00000 0.00000E+00      0.00 12
  14   0   0     14.61    0.01      0.00 0.00000 0.00000E+00      0.00 12
  16   0   0     85.46    0.01      0.00 0.00000 0.00000E+00      0.00 12
  18   0   0     41.08    0.01      0.00 0.00000 0.00000E+00      0.00 12
  20   0   0     40.36    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   1   0     17.84    0.01      0.00 0.00000 0.00000E+00      0.00 12
   6   1   0     12.02    0.01      0.00 0.00000 0.00000E+00      0.00 12
  14   1   0      8.13    0.01      0.00 0.00000 0.00000E+00      0.00 12
  20   1   0      8.91    0.01      0.00 0.00000 0.00000E+00      0.00 12
   0   2   0     54.23    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   1   0     11.15    0.01      0.00 0.00000 0.00000E+00      0.00  2
   2   2   0     23.78    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   3   0     16.38    0.01      0.00 0.00000 0.00000E+00      0.00  2
   4   2   0     15.32    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   5   0     17.28    0.01      0.00 0.00000 0.00000E+00      0.00  2
   8   2   0     32.72    0.01      0.00 0.00000 0.00000E+00      0.00 12
  10   2   0     25.06    0.01      0.00 0.00000 0.00000E+00      0.00 12
  12   2   0      9.37    0.01      0.00 0.00000 0.00000E+00      0.00 12
  14   2   0      5.50    0.01      0.00 0.00000 0.00000E+00      0.00 12
  16   2   0     18.88    0.01      0.00 0.00000 0.00000E+00      0.00 12
  18   2   0     14.01    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   3   0     23.52    0.01      0.00 0.00000 0.00000E+00      0.00  1
   4   3   0     44.22    0.01      0.00 0.00000 0.00000E+00      0.00  1
   6   3   0     23.64    0.01      0.00 0.00000 0.00000E+00      0.00  1
   8   3   0     11.93    0.01      0.00 0.00000 0.00000E+00      0.00  1
  10   3   0     18.22    0.01      0.00 0.00000 0.00000E+00      0.00  1
  12   3   0     44.79    0.01      0.00 0.00000 0.00000E+00      0.00  1
  14   3   0     23.95    0.01      0.00 0.00000 0.00000E+00      0.00  1
  16   3   0     19.86    0.01      0.00 0.00000 0.00000E+00      0.00  1
  22   3   0     13.96    0.01      0.00 0.00000 0.00000E+00      0.00  1
   0   4   0     47.32    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   4   0     11.90    0.01      0.00 0.00000 0.00000E+00      0.00 12
   4   3   0     26.71    0.01      0.00 0.00000 0.00000E+00      0.00  2



   1  10  14      7.95    0.01      0.00 0.00000 0.00000E+00      0.00 12
   1   0  15      9.53    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   0  15      7.94    0.01      0.00 0.00000 0.00000E+00      0.00 12
   4   0  15     10.11    0.01      0.00 0.00000 0.00000E+00      0.00 12
   5   0  15     17.23    0.01      0.00 0.00000 0.00000E+00      0.00 12
   4   2  15     11.40    0.01      0.00 0.00000 0.00000E+00      0.00 12
   0   4  15     11.04    0.01      0.00 0.00000 0.00000E+00      0.00 12
   0   5  15     18.60    0.01      0.00 0.00000 0.00000E+00      0.00 12
   2   5  15      9.72    0.01      0.00 0.00000 0.00000E+00      0.00 12
-512
\SORT
\REORDER
\ compare the new LIST 6 with the earlier one. Note that the data has been
\ moved about.
\PUNCH 6 C
\FINI

