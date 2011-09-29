#
# This test exercises the TORSION code. 
# GROUP puts the atoms into a GROUP and demonstrates the esd is zero
# NORMAL is a multi-block List 12 plus symmetry effects
# BAD is a list5/12 mismatch, which causes the file to be exited
\set time slow
\rele print CROUTPUT:
#TITLE TD-Torsion
# copper acetate
#LIST 1                                                                         
REAL    13.1082     8.5159    13.7720    90.0000   116.9104    90.0000
END
#LIST 31                                                                        
AMULT 1.0
MATRIX 0.0000001600 0.0 0.0 0.0 0.0 0.0
CONT 0.0000000900 0.0 0.0 0.0 0.0
CONT 0.0000002500 0.0 0.0 0.0
CONT 0.0000000000 0.0 0.0
CONT 0.0000000009 0.0
CONT 0.0000000000
END
#LIST 13                                                                        
condition 0.7107300162
end
#SPACEGROUP                                                                     
SYMBOL C 1 2/c 1
END
#Composition                                                                    
content   C   32  H   64  Cu   8  O   40
SCATTERING CRYSDIR:script/scatt.dat
PROPERTIES CRYSDIR:script/propwin.dat
end
#List 30                                                                        
DATRED  NREFMES =   2794  NREFMERG =   1559  RMERGE =   0.03
CONDITIONS  MINSIZE =   0.08  MEDSIZE =   0.08  MAXSIZE =   0.20
CONT  NORIEN =   1477  THORIENTMIN =   5.00  THORIENTMAX =  27.00
CONT  TEMPERATURE =    150  STAND =      0  DECAY =   0.00
INDEXRANGE  HMIN=-16 HMAX= 16 KMIN=-11 KMAX=  9 LMIN=-17 LMAX= 17
CONT  THETAMIN =     5.29  THETAMAX =    27.52
GENERAL  DOBS =     0.00 DCALC =     1.93 MOLWT =   199.65 Z =     8.00
COLOUR blue
SHAPE prism
REFINEMENT  R =    2.17  RW =    6.70  NPARAM =     91  GoF = 0.8466
END

#
# Punched on 27/07/11 at 08:25:58
#
#LIST      5                                                                    
READ NATOM =     18, NLAYER =    0, NELEMENT =    0, NBATCH =    0
OVERALL    1.022994  0.050000  0.050000  0.000000  0.000000         0.0000000
ATOM CU      1.000000   1.000000   0.000000   0.449630  -0.084598   0.544982
CON U[11]=   0.010840   0.013212   0.011763  -0.000219   0.005088  -0.000416
CON SPARE=       1.00          0   25165828          0           
ATOM O       2.000000   1.000000   0.000000   0.404046   0.120786   0.575752
CON U[11]=   0.019989   0.019102   0.023236  -0.003454   0.012888   0.000505
CON SPARE=       1.00          0    8388612          0           
ATOM C       3.000000   1.000000   0.000000   0.434431   0.251550   0.550700
CON U[11]=   0.011557   0.012894   0.008205  -0.004725  -0.004501   0.000707
CON SPARE=       1.00          0   25165828          0           
ATOM O       4.000000   1.000000   0.000000   0.493143   0.266166   0.500151
CON U[11]=   0.018598   0.019015   0.021809  -0.001576   0.012100  -0.000405
CON SPARE=       1.00          0   25165828          0           
ATOM C       5.000000   1.000000   0.000000   0.396441   0.397840   0.586166
CON U[11]=   0.019337   0.022371   0.023970  -0.006995   0.009271  -0.001291
CON SPARE=       1.00          0   25165828          0           
ATOM O       6.000000   1.000000   0.000000   0.314889  -0.089413   0.399295
CON U[11]=   0.012598   0.018587   0.010520   0.001697   0.002352  -0.001807
CON SPARE=       1.00          0    8388612          0           
ATOM C       7.000000   1.000000   0.000000   0.316654  -0.019893   0.318329
CON U[11]=   0.014253   0.015024   0.014575  -0.002533   0.006370   0.001275
CON SPARE=       1.00          0    8388612          0           
ATOM O       8.000000   1.000000   0.000000   0.399914   0.062217   0.323600
CON U[11]=   0.013382   0.025014   0.013237   0.001676   0.003349  -0.000807
CON SPARE=       1.00          0    8388612          0           
ATOM C       9.000000   1.000000   0.000000   0.214310  -0.035714   0.208750
CON U[11]=   0.022130   0.045635   0.016485  -0.000223   0.004919  -0.006842
CON SPARE=       1.00          0    8388612          0           
ATOM O      10.000000   1.000000   0.000000   0.376361  -0.209036   0.633403
CON U[11]=   0.028283   0.026897   0.019929  -0.005190   0.017530  -0.010532
CON SPARE=       1.00          0    8388612          0           
ATOM H      53.000000   1.000000   1.000000   0.437900   0.485300   0.580600
CON U[11]=   0.035000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
ATOM H      51.000000   1.000000   1.000000   0.407500   0.382400   0.659300
CON U[11]=   0.035000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
ATOM H      52.000000   1.000000   1.000000   0.317100   0.410900   0.542500
CON U[11]=   0.034800   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
ATOM H      91.000000   1.000000   1.000000   0.189900   0.068000   0.178400
CON U[11]=   0.041100   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
ATOM H      93.000000   1.000000   1.000000   0.238200  -0.091400   0.162900
CON U[11]=   0.040800   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
ATOM H      92.000000   1.000000   1.000000   0.153600  -0.088100   0.213500
CON U[11]=   0.040900   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
ATOM H     102.000000   1.000000   1.000000   0.317800  -0.263800   0.609600
CON U[11]=   0.037000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
ATOM H     101.000000   1.000000   1.000000   0.391000  -0.203900   0.696900
CON U[11]=   0.038600   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0           
END                                                                             
#CLOSE HKLI                                                                     
#OPEN HKLI  "td-tors.hkl"                                                   
#HKLI                                                                           
READ F'S=FSQ NCOEF=6 TYPE=FIXED CHECK=NO
INPUT H K L /FO/ SIGMA(/FO/) /Fc/
FORMAT (3F4.0, 3F8.0)
STORE NCOEF=7
OUTP INDI /FO/ SIG RATIO/J CORR SERI /Fc/
END
#CLOSE HKLI                                                                     
#list 6
read type=copy
end
#LIST 23                                                                        
MODIFY ANOM= NO EXTI= NO ENANT= NO
MINIM NSINGU= 0 F-SQ= NO REFLE= YES RESTR= YES
REFINE SPEC= CONS UPDATE= PARAM TOLER= 0.600000
ALLC  0.000000 100.000000 0.000000 100.000000
CONT MIN-SUMSQ= 0.030000 10000.000000 U[MIN]= 0.000000
END
#sfls
calc
end
#LIST 4                                                                         
SCHEME NUMBER=14, NPARAM=   3        
END

#TITLE GROUP TORSION
#list 12                                                                        
block
group o(6) until c(9)
end
#sfls                                                                           
ref
shift gen=0
end
#tors                                                                           
publication level=hi
atom  C(9)  C(7)  O(6)  O(8)
end


#TITLE NORMAL TORSION
#LIST     12                                                                    
BLOCK CU(1,X'S,U'S) O(2,X'S) O(10,X)
CONT C(3,X'S,U'S) UNTIL C(5)
BLOCK O(6,X'S) UNTIL C(9)
END
#sfls
ref 
shift general=0
end
#use torsion.dat


# The mis-match between lists 5 and 12 causes the file to 
# be abandoned and control passed to the user. 
# Not much use in batch mode
#edit
keep all
end
#TITLE BAD LIST 5/12
#tors                                                                           
ATOM  CU(1)  O(2)  C(3)  C(5)
ATOM  CU(1)  O(2)  C(3)  C(5)
atom cu(1) o(6) until c(9)
atom c(7) o(6) cu(1) o(10) c(3)
atom o(10) cu(1) cu(1,1,1,0,1,0) o(10,1,1,0,1,0)
ATOM  C(5)  C(3)  CU(1) C(3,-1,1,1,0,1)
#end


