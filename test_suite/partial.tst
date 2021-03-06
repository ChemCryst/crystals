#  Test storage of partial structure factors within LIST 6.
# Note change between F and F^2 refinements
# Largely replaced by td-part


#SET TIME SLOW
#RELE PRINT CROUTPUT:
#LIST 1
REAL 11.0667 9.4644 8.7336 91.561 126.557 96.584
END
#list 31
amult  0.00000001
matrix  V(11)=9 V(22)=9 V(33)=9 V(44)=9 V(55)=9 V(66)=9
end
#SPACE
SYMBOL P 1
END
#COMPOSITION
CONTENT C 29 H 36 F 6 N 1 O 2 P 1 RU 1
scattering crysdir:script/scatt.dat
properties crysdir:script/propwin.dat
end
#LIST      5                                                                    
READ NATOM =     54, NLAYER =    0, NELEMENT =    0, NBATCH =    0
OVERALL    6.343499  0.050000  0.050000  1.000000  0.000000        50.9017715
ATOM RU      1.000000   1.000000   0.000000   0.003431  -0.004437   0.001260
CON U[11]=   0.051004   0.045001   0.052315  -0.001025   0.031968   0.011411
CON SPARE=       1.00          0          0          0       0   
ATOM C       1.000000   1.000000   0.000000  -0.133791  -0.098322  -0.300071
CON U[11]=   0.068032   0.112547   0.039027  -0.019273   0.029113  -0.040750
CON SPARE=       1.00          0    8388608          0       0   
ATOM C       2.000000   1.000000   0.000000  -0.113268  -0.208236  -0.183933
CON U[11]=   0.066396   0.055228   0.087169  -0.031511   0.012612   0.018582
CON SPARE=       1.00          0    8388608          0       0   
ATOM C       3.000000   1.000000   0.000000  -0.179041  -0.191231  -0.097658
CON U[11]=   0.070084   0.086040   0.069860  -0.009434   0.032518  -0.049853
CON SPARE=       1.00          0    8388608          0       0   
ATOM C       4.000000   1.000000   0.000000  -0.248564  -0.065978  -0.156188
CON U[11]=   0.029292   0.133958   0.108217  -0.058662   0.027854  -0.005882
CON SPARE=       1.00          0    8388608          0       0   
ATOM C       5.000000   1.000000   0.000000  -0.216728  -0.007096  -0.276890
CON U[11]=   0.046623   0.065399   0.094347   0.018175  -0.000545   0.012706
CON SPARE=       1.00          0    8388608          0       0   
ATOM C      11.000000   1.000000   0.000000  -0.096147  -0.077339  -0.441593
CON U[11]=   0.157922   0.324233   0.079996  -0.071225   0.086199  -0.119533
CON SPARE=       1.00          0    8388608          0       0   
ATOM C      12.000000   1.000000   0.000000  -0.023819  -0.331985  -0.156307
CON U[11]=   0.109319   0.072562   0.273869  -0.046806   0.025326   0.050690
CON SPARE=       1.00          0    8388608          0       0   
ATOM C      13.000000   1.000000   0.000000  -0.180754  -0.277801   0.039158
CON U[11]=   0.515018   0.407081   0.117879  -0.111612   0.166970  -0.396520
CON SPARE=       1.00          0    8388608          0       0   
ATOM C      14.000000   1.000000   0.000000  -0.342214   0.001795  -0.105122
CON U[11]=   0.122755   0.289633   0.404870  -0.205185   0.175565  -0.054854
CON SPARE=       1.00          0    8388608          0       0   
ATOM C      15.000000   1.000000   0.000000  -0.275535   0.123172  -0.379722
CON U[11]=   0.126599   0.081896   0.230394   0.061465  -0.084400   0.012041
CON SPARE=       1.00          0    8388608          0       0   
ATOM C     101.000000   1.000000   0.000000   0.348777   0.172240  -0.208091
CON U[11]=   0.098409   0.098465   0.069236   0.007307   0.049517  -0.000491
CON SPARE=       1.00          0          0          0       0   
ATOM C     103.000000   1.000000   0.000000   0.326911   0.089826   0.038110
CON U[11]=   0.055178   0.054889   0.061329  -0.006769   0.034815   0.004900
CON SPARE=       1.00          0          0          0       0   
ATOM C     104.000000   1.000000   0.000000   0.327278  -0.066000  -0.015719
CON U[11]=   0.078192   0.058599   0.076448   0.001941   0.054711   0.018762
CON SPARE=       1.00          0          0          0       0   
ATOM C     105.000000   1.000000   0.000000   0.376724  -0.156053   0.144917
CON U[11]=   0.058157   0.059429   0.072185  -0.001082   0.040369   0.018993
CON SPARE=       1.00          0          0          0       0   
ATOM C     106.000000   1.000000   0.000000   0.460679  -0.264492   0.170844
CON U[11]=   0.071306   0.066349   0.101184   0.001932   0.057257   0.022892
CON SPARE=       1.00          0          0          0       0   
ATOM C     107.000000   1.000000   0.000000   0.502383  -0.351748   0.313182
CON U[11]=   0.068645   0.061585   0.106726   0.006189   0.048547   0.022538
CON SPARE=       1.00          0          0          0       0   
ATOM C     108.000000   1.000000   0.000000   0.462791  -0.333844   0.433188
CON U[11]=   0.064720   0.055813   0.078109   0.002240   0.032139   0.017616
CON SPARE=       1.00          0          0          0       0   
ATOM C     110.000000   1.000000   0.000000   0.375951  -0.224758   0.409879
CON U[11]=   0.054458   0.058491   0.060402  -0.000860   0.027530   0.010984
CON SPARE=       1.00          0          0          0       0   
ATOM C     113.000000   1.000000   0.000000   0.334706  -0.133578   0.265825
CON U[11]=   0.054010   0.053178   0.062631  -0.000766   0.034142   0.014406
CON SPARE=       1.00          0          0          0       0   
ATOM C     115.000000   1.000000   0.000000   0.248877  -0.014848   0.239995
CON U[11]=   0.036451   0.058541   0.043000  -0.001332   0.016177   0.012828
CON SPARE=       1.00          0          0          0       0   
ATOM C     116.000000   1.000000   0.000000   0.162936  -0.007785   0.312581
CON U[11]=   0.063541   0.083012   0.051414  -0.006895   0.032783   0.022857
CON SPARE=       1.00          0          0          0       0   
ATOM C     117.000000   1.000000   0.000000   0.079306   0.102307   0.276725
CON U[11]=   0.071780   0.081898   0.075341  -0.014653   0.044725   0.015460
CON SPARE=       1.00          0          0          0       0   
ATOM C     118.000000   1.000000   0.000000   0.077820   0.211608   0.168078
CON U[11]=   0.056003   0.053302   0.072203  -0.026101   0.032655   0.005457
CON SPARE=       1.00          0          0          0       0   
ATOM C     119.000000   1.000000   0.000000   0.152196   0.203105   0.082846
CON U[11]=   0.070253   0.058226   0.064430   0.002300   0.029340   0.029412
CON SPARE=       1.00          0          0          0       0   
ATOM C     120.000000   1.000000   0.000000   0.235748   0.089467   0.118168
CON U[11]=   0.066147   0.048517   0.051703  -0.002117   0.032361   0.014053
CON SPARE=       1.00          0          0          0       0   
ATOM C     121.000000   1.000000   0.000000   0.150073   0.319006  -0.031984
CON U[11]=   0.075245   0.048367   0.096611   0.016102   0.038221   0.013696
CON SPARE=       1.00          0          0          0       0   
ATOM C     122.000000   1.000000   0.000000   0.263313   0.317629  -0.069719
CON U[11]=   0.073146   0.061781   0.097054   0.006595   0.042912   0.000130
CON SPARE=       1.00          0          0          0       0   
ATOM C     123.000000   1.000000   0.000000   0.248958  -0.322924   0.537196
CON U[11]=   0.111519   0.108050   0.110990   0.045497   0.079880   0.036688
CON SPARE=       1.00          0          0          0       0   
ATOM C     124.000000   1.000000   0.000000   0.547160  -0.545968   0.583023
CON U[11]=   0.114879   0.076013   0.134085   0.040291   0.060496   0.045176
CON SPARE=       1.00          0          0          0       0   
ATOM O     109.000000   1.000000   0.000000   0.501261  -0.410171   0.582333
CON U[11]=   0.090474   0.076486   0.087571   0.024434   0.038199   0.034449
CON SPARE=       1.00          0          0          0       0   
ATOM O     111.000000   1.000000   0.000000   0.344647  -0.206227   0.538696
CON U[11]=   0.075712   0.073350   0.066049   0.007818   0.038822   0.021521
CON SPARE=       1.00          0          0          0       0   
ATOM N     102.000000   1.000000   0.000000   0.262886   0.169058  -0.129404
CON U[11]=   0.063848   0.062559   0.068939   0.006247   0.032493   0.006695
CON SPARE=       1.00          0          0          0       0   
ATOM H       3.000000   1.000000   1.000000   0.572040  -0.590558   0.698945
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H       4.000000   1.000000   1.000000   0.638924  -0.532031   0.584670
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H       5.000000   1.000000   1.000000   0.461916  -0.610686   0.464502
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H       6.000000   1.000000   1.000000   0.234257  -0.297162   0.636517
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H       7.000000   1.000000   1.000000   0.298428  -0.410335   0.567343
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H       8.000000   1.000000   1.000000   0.147940  -0.341845   0.407916
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H       9.000000   1.000000   1.000000   0.490766  -0.279169   0.084681
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      10.000000   1.000000   1.000000   0.562357  -0.428918   0.329129
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      11.000000   1.000000   1.000000   0.398933  -0.066228  -0.050007
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      12.000000   1.000000   1.000000   0.222011  -0.109032  -0.129105
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      13.000000   1.000000   1.000000   0.237135   0.377762  -0.174902
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      14.000000   1.000000   1.000000   0.366795   0.357621   0.049353
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      15.000000   1.000000   1.000000   0.171875   0.413738   0.040201
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      16.000000   1.000000   1.000000   0.046511   0.306649  -0.157800
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      17.000000   1.000000   1.000000   0.024641   0.294394   0.152584
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      18.000000   1.000000   1.000000   0.019210   0.104764   0.327769
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      19.000000   1.000000   1.000000   0.162286  -0.083563   0.389900
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      35.000000   1.000000   1.000000   0.300597   0.227567  -0.321385
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      36.000000   1.000000   1.000000   0.456445   0.219426  -0.107741
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      37.000000   1.000000   1.000000   0.347576   0.072180  -0.249060
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
ATOM H      38.000000   1.000000   1.000000   0.432497   0.143006   0.134579
CON U[11]=   0.100000   0.000000   0.000000   0.000000   0.000000   0.000000
CON SPARE=       1.00          0          0          0       0   
END                                                                             
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO
MINIMISE F-SQ=NO
END
#USE partial.hkl
\ Set partial to YES and update to NO.
#GENERALEDIT 23
LOCATE RECORDTYPE=101
CHANGE OFFSET=4 MODE=INTEGER INTEGER=0
WRITE
CHANGE OFFSET=5 MODE=INTEGER INTEGER=-1
WRITE
END
#LIST     12                                                                    
FULL X'S U'S
END                                                                             
#LIST 4
END
#WEIGHT
END
#SFLS
SCALE
END
#SFLS
SCALE
END
#SFLS
CALC
END
#SFLS
R
R
R
R
END
#PRINT 23
END
#PRINT 22
END
#PRINT 24 
END
\LIST 23
MODIFY EXTINCTION=YES ANOM=NO PARTIAL=YES UPDATE=NO
MINIMISE F-SQ=YES
END
#LIST 4
END
#WEIGHT
END
#SFLS
CALC
END
#SFLS
R
R
R
R
END
#PRINT 23
END
#PRINT 22
END
#PRINT 24 
END
#END
\finish
