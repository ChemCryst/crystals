#set time slow
#rele print CROUTPUT:
#TITLE Test SYST/SORT/MERGE 
# Part 1 sets the FREIDEL pairs flag to NO in SYST, thus keeping
# the pairs separate independent of what was set in LIST 13
# 
# After SORTing, the reflctions are first MERGED with TWIN set to YES,
# thus only merging FOT for reflections with identical ELEMENT flags. The
# data is still twinned and so needs a LIST 25 and a LIST 13 indicating twinning
# 
# The data is then futher merged with TWIN=NO.  This sets the ELEMENT flags to unity
# and merges FO, the de-twinned observed structure factors. Friedel pairs are still 
# separate, so that there are 2 reflections in the final LIST 7.
# 
# Part 2 sets the FRIEDEL flag to YES in SYST, thus applying Friedels law. SORT and MERGE
# are as before, but because Friedel pairs are transformed, there is only one reflection
# in the final LSIT 7
#
#
#LIST 1
REAL    7.5800  10.2880  12.0820  90.0000 108.3650  90.0000
END
#SPACE
symb P   21/C   
END
#LIST 3
READ NSCATTERERS=    4
SCAT TYPE= C         0.003300     0.001600     2.310000    20.843920
CONT                1.020000    10.207509     1.588600     0.568700
CONT                             0.865000    51.651241     0.215600
SCAT TYPE= H         0.000000     0.000000     0.493000    10.510910
CONT                0.322910    26.125732     0.140190     3.142360
CONT                             0.040810    57.799770     0.003040
SCAT TYPE= CL        0.148400     0.158500    11.460400     0.010400
CONT                7.196400     1.166200     6.255600    18.519402
CONT                             1.645500    47.778400    -9.557400
SCAT TYPE= N         0.006100     0.003300    12.212609     0.005700
CONT                3.132200     9.893311     2.012500    28.997540
CONT                             1.166300     0.582600   -11.529010
END
#LIST 4
SCHEME  9 NPARAM= 0 TYPE=1/2FO 
CONT WEIGHT=   2.0000000 MAX=  10000.0000 ROBUST=N
CONT DUNITZ=N TOLER=      6.0000 DS1=      1.0000
CONT DS2=      1.0000 QUASI=      0.2500
END
#
# Punched on 21/04/17 at 13:26:11
#
#LIST      5                                                                    
READ NATOM =     22, NLAYER =    0, NELEMENT =    2, NBATCH =    0
OVERALL    4.719468  0.050000  0.050000  1.000000  0.000000         0.0000000
ATOM CL            1.   1.000000         0.   1.210669   0.671702   0.956236
CON U[11]=   0.029984   0.036835   0.026021   0.000261   0.012035  -0.000516
CON SPARE=       1.00          0          3          1                     0
ATOM N             2.   1.000000         0.   0.707760   0.615560   0.692797
CON U[11]=   0.021537   0.026826   0.020818   0.000911   0.006855  -0.001468
CON SPARE=       1.00          0          3          2                     0
ATOM C             3.   1.000000         0.   0.787799   0.538450   0.783300
CON U[11]=   0.028843   0.039354   0.025089   0.006118   0.010216   0.002082
CON SPARE=       1.00          0          3          2                     0
ATOM N             4.   1.000000         0.   0.666798   0.518907   0.842160
CON U[11]=   0.030085   0.037029   0.026091   0.002806   0.011316   0.000092
CON SPARE=       1.00          0          3          2                     0
ATOM C             5.   1.000000         0.   0.506065   0.587124   0.787878
CON U[11]=   0.025730   0.040344   0.026484  -0.004931   0.010213  -0.003974
CON SPARE=       1.00          0          3          2                     0
ATOM C             6.   1.000000         0.   0.531432   0.647779   0.693724
CON U[11]=   0.026498   0.028320   0.025585  -0.003428   0.009244  -0.001256
CON SPARE=       1.00          0          3          2                     0
ATOM C             7.   1.000000         0.   0.798141   0.665463   0.606984
CON U[11]=   0.026525   0.032726   0.022068   0.000275   0.009869  -0.004247
CON SPARE=       1.00          0          3          2                     0
ATOM C             8.   1.000000         0.   0.807932   0.813725   0.619825
CON U[11]=   0.093643   0.035135   0.053699  -0.012074   0.044068  -0.031815
CON SPARE=       1.00          0          3          2                     0
ATOM C             9.   1.000000         0.   0.675052   0.628352   0.483622
CON U[11]=   0.036485   0.049143   0.022806  -0.004232   0.010087  -0.006838
CON SPARE=       1.00          0          3          2                     0
ATOM C            10.   1.000000         0.   0.991164   0.603140   0.633357
CON U[11]=   0.027342   0.102533   0.038446   0.018305   0.017252   0.013799
CON SPARE=       1.00          0          3          2                     0
ATOM H            31.   1.000000         1.   0.915679   0.504396   0.802761
CON U[11]=   0.038362   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            51.   1.000000         1.   0.401523   0.591498   0.816523
CON U[11]=   0.037004   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            61.   1.000000         1.   0.447013   0.703554   0.638212
CON U[11]=   0.033570   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            83.   1.000000         1.   0.872611   0.851323   0.568457
CON U[11]=   0.084020   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            82.   1.000000         1.   0.874126   0.829437   0.701359
CON U[11]=   0.083920   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            81.   1.000000         1.   0.677373   0.844782   0.599535
CON U[11]=   0.085889   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            93.   1.000000         1.   0.730218   0.663223   0.427886
CON U[11]=   0.054073   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            92.   1.000000         1.   0.550037   0.667121   0.468814
CON U[11]=   0.055199   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H            91.   1.000000         1.   0.669906   0.532894   0.476960
CON U[11]=   0.054728   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H           103.   1.000000         1.   1.048166   0.640307   0.576401
CON U[11]=   0.081662   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H           102.   1.000000         1.   1.061401   0.624756   0.713858
CON U[11]=   0.082273   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ATOM H           101.   1.000000         1.   0.974472   0.508693   0.621394
CON U[11]=   0.082814   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0   25165824          2                     0
ELEMENTS     0.602762   0.397238
END                                                                             
#
# Punched on 21/04/17 at 13:26:26
#
#LIST     12                                                                    
BLOCK SCALE X'S  U'S 
SUMFIX ELEMENT SCALES 
END                                                                             
# Remove space after hash to activate next line
# USE LAST
#LIST 13
CRYST FRIEDELPAIRS=Y TWINNED=Y SPREAD=GAUSSIA
DIFFRACTION GEOMETRY=UNKNOWN  RADIATION=XRAYS 
CONDI WAVEL= 0.71073  6.050 90.000  0.5869359  0.6427007  0.0001788 90.000
MATR    0.000000000    0.000000000    0.000000000
CONT    0.000000000    0.000000000    0.000000000
CONT    0.000000000    0.000000000    0.000000000
END
#
# Punched on 21/04/17 at 13:26:36
#
#LIST     16                                                                    
NO 
REM   HREST   START (DO NOT REMOVE THIS LINE) 
REM   HREST   END (DO NOT REMOVE THIS LINE) 
END                                                                             
# Remove space after hash to activate next line
# USE LAST
#LIST 23
MODIFY ANOM=N EXTI=N LAYER=N BATCH=N
CONT  PARTI=N UPDA=N ENANT=N
MINIMI NSING=    0 F-SQ=Y RESTR=Y REFLEC=Y
ALLCYCLES U[MIN]=        0.00000000
CONT       MIN-R=  0.000000       MAX-R=   100.000
CONT      MIN-WR=  0.000000      MAX-WR=   100.000
CONT   MIN-SUMSQ=  0.030000   MAX-SUMSQ= 10000.000
CONT MIN-MINFUNC=  0.000000 MAX-MINFUNC= 999999986991104.000
INTERCYCLE  MIN-DR= -5.000000       MAX-DR=   100.000
CONT       MIN-DWR= -5.000000      MAX-DWR=   100.000
CONT    MIN-DSUMSQ=-10.000000   MAX-DSUMSQ= 10000.000
CONT  MIN-DMINFUNC=  0.000000 MAX-DMINFUNC= 999999986991104.000
REFINE  SPEC=CONSTRAIN  UPDATE=PARAMETERS  TOL=   0.60000
END
#LIST 25
READ NELEM=  2
MATRIX    1.000000000    0.000000000    0.000000000
CONT      0.000000000    1.000000000    0.000000000
CONT      0.000000000    0.000000000    1.000000000
MATRIX    1.000000000    0.000000000    0.000000000
CONT     -0.000000000   -1.000000000    0.000000000
CONT     -1.003999949   -0.000000000   -1.000000000
END
#LIST 28
READ NSLICE=     0 NOMIS=     0 NCOND=     0
MINIMA 
CONT    SINTH/L**2  =   0.01000
CONT    RATIO       =  -3.00000
END
#LIST 29
READ NELEM=  4
# covalent,vdw,ionic,number,muA,weight,colour
ELEMENT C     0.7700        1.7800   0.0100     7.000    1.150   12.011 GREE
ELEMENT H     0.3200        1.3300  -0.3000    13.000    0.062    1.008 LGRE
ELEMENT CL    1.0800        2.0900   0.6000     1.000   67.800   35.453 BGRE
ELEMENT N     0.7700        1.7800  -0.1000     2.000    1.960   14.007 BLUE
END
#LIST 31
AMULT        0.00000100
MATRIX      1.21000     0.00000     0.00000     0.00000     0.00000     0.00000
CONT                    3.24000     0.00000     0.00000     0.00000     0.00000
CONT                                6.25000     0.00000     0.00000     0.00000
CONT                                            0.00000     0.00000     0.00000
CONT                                                        0.00000     0.00000
CONT                                                                    0.00000
END
#LIST 39
OVERALL         0.00000000        0.00000000        0.00000000        0.00000000
CONT            0.00000000        0.00000000        0.00000000        0.00000000
CONT            0.00000000        0.00000000        0.00000000        0.00000000
READ NINT=     2 NREAL=     1
INT  INFO       0           1           0           0           0          10
CONT                        5           1           0           0           0
INT  OVER       1           1           0           0           0           0
CONT                        0           0           0           0           0
REAL SFLS      0.   1.000000    0.000000    0.000000    0.000000    0.000000
CONT                0.000000    0.000000    0.000000    0.000000    0.000000
END

#
#TITLE PART 1
#store unit ncpu 9
#LIST   7
READ NCOEF=13 TYPE=FIX, UNIT=DAT, CHECK=NO L30=NO ARCH=NO
STORE  NCOEF=10
OUTPUT INDICES     /FO/        SQRTW       /FC/        BATCH/PHASE RATIO/JCODE
CONT   SIGMA(/FO/) CORRECTIONS ELEMENTS    /FOT/      
INPUT  H           K           L           /FO/        SQRTW       /FC/       
CONT   BATCH       PHASE       JCODE       SIGMA(/FO/) CORRECTIONS ELEMENTS   
CONT   /FOT/      
FOR (I4,I4,I4,F10.2,1X,G10.3,F10.2,F4.0,F6.2,F4.0,F8.2,F7.4,F8.0,F10.2)
END
   1 -13   0     17.00  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     17.00 
   1 -13   0     17.21  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     17.20 
   1 -13   0     17.42  0.120E-01      3.23  1. -3.10  2.    1.57 1.0000      2.     17.40 
   1 -13   0     17.63  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     17.60 
   1  13   0     18.68  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     18.60 
   1  13   0     18.80  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     18.80 
   1  13   0     19.01  0.120E-01      3.23  1. -3.10  2.    1.57 1.0000      2.     19.00 
   1 -13   0     17.84  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     17.80 
   1  13   0     18.05  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     18.00 
   1  13   0     18.26  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     18.20 
   1  13   0     18.47  0.120E-01      3.23  1. -3.10  2.    1.57 1.0000      2.     18.40 
-512
#purg                                                                           
end
#punch 7 i                                                                      
end
#syst 7 fried=no
end
#punch 7 i                                                                      
end
#sort 7
end
#punch 7 i
end
#merge 7 twin=yes                                                               
ref list=hi
end
#punch 7 i                                                                      
end
#merge 7 twin=no                                                                
ref list=hi
end
#punch 7 i                                                                      
end

#TITLE PART 2
#LIST   7
READ NCOEF=13 TYPE=FIX, UNIT=DAT, CHECK=NO L30=NO ARCH=NO
STORE  NCOEF=10
OUTPUT INDICES     /FO/        SQRTW       /FC/        BATCH/PHASE RATIO/JCODE
CONT   SIGMA(/FO/) CORRECTIONS ELEMENTS    /FOT/      
INPUT  H           K           L           /FO/        SQRTW       /FC/       
CONT   BATCH       PHASE       JCODE       SIGMA(/FO/) CORRECTIONS ELEMENTS   
CONT   /FOT/      
FOR (I4,I4,I4,F10.2,1X,G10.3,F10.2,F4.0,F6.2,F4.0,F8.2,F7.4,F8.0,F10.2)
END
   1 -13   0     17.00  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     17.00 
   1 -13   0     17.21  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     17.20 
   1 -13   0     17.42  0.120E-01      3.23  1. -3.10  2.    1.57 1.0000      2.     17.40 
   1 -13   0     17.63  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     17.60 
   1  13   0     18.68  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     18.60 
   1  13   0     18.80  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     18.80 
   1  13   0     19.01  0.120E-01      3.23  1. -3.10  2.    1.57 1.0000      2.     19.00 
   1 -13   0     17.84  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     17.80 
   1  13   0     18.05  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000     12.     18.00 
   1  13   0     18.26  0.120E-01      3.99  1. -3.10  2.    1.57 1.0000      1.     18.20 
   1  13   0     18.47  0.120E-01      3.23  1. -3.10  2.    1.57 1.0000      2.     18.40 
-512
#purg                                                                           
end
#use td-syst-sort.l7                                                                                                                                                                                                                                                     
#punch 7 i                                                                      
end
#syst 7 fried=yes
end
#punch 7 i                                                                      
end
#sort 7
end
#punch 7 i
end
#merge 7 twin=yes                                                               
ref list=hi
end
#punch 7 i                                                                      
end
#merge 7 twin=no                                                                
ref list=hi
end
#punch 7 i                                                                      
end
#end                                                                            
