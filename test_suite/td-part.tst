#set time slow
#rele print CROUTPUT:
#title extended PARTs in LIST 6
# Punched on 26/01/17 at 13:24:39
#TITLE extended PARTs in LIST 6
#
# this tests that Fc computed from the whole of the structure has
# the same total as that computed by adding the parts from the 
# ruthenium to those of the rest.
#
# Note simplified LIST 4
#
# The first part just does a normal refinement with anomalous scattering
# but  without PARTS
# ENANTIO is refined
# 
# The second part is without anomalous scattering by setting f' & f" in 
# list 3 to zero.  SFLS/CALC is done with old and new format LIST 6s
#
# The third part tests imaginary parts of A&B wih f' & f" set in LIST 3
# look in the  PUNCH 6 I sections for differences.
# Compare the values of enantio and its esd after part(1) and Part(3)


# send punch output to printer
#store unit ncpu 9


#LIST 1
REAL   11.0667   9.4644   8.7336  91.5612 126.5567  96.5835
END
#space
symbol  p 1
end
# note simplified weighting scheme to make it independent of Fc
#LIST 4
SCHEME 16 NPARAM= 6 TYPE=CHOOSE 
CONT WEIGHT=   2.0000000 MAX=  10000.0000 ROBUST=N
CONT DUNITZ=N TOLER=      6.0000 DS1=      1.0000
CONT DS2=      1.0000 QUASI=      0.2500
PARAM     0.00    0.00000    0.000000    0.000000    0.000000    0.333330
END
#
#LIST     12                                                                    
block enantio
END                                                                             
#
#LIST 28
READ NSLICE=     0 NOMIS=     0 NCOND=     0
MINIMA 
CONT    RATIO       =  -3.00000
END
#LIST 29
READ NELEM=  8
# covalent,vdw,ionic,number,muA,weight,colour
ELEMENT C     0.7700        1.7800   0.0100    29.000    8.990   12.011 GREE
ELEMENT H     0.3200        1.3300  -0.3000    36.000    0.065    1.008 LGRE
ELEMENT F     0.7300        1.7400   1.3000     6.000   49.800   18.998 BGRE
ELEMENT N     0.7700        1.7800  -0.1000     1.000   17.300   14.007 BLUE
ELEMENT O     0.7700        1.7800   1.3600     2.000   30.400   15.999 RED 
ELEMENT P     1.1400        2.1500   0.1400     1.000  388.000   30.974 PURP
ELEMENT RU    1.4900        2.5000   0.7000     1.000 2950.000  101.070 GREY
ELEMENT TI    1.5600        2.5700   0.6100     1.000 1590.000   47.900 GREY
END
#LIST 31
AMULT        0.01000000
MATRIX      0.00010     0.00000     0.00000     0.00000     0.00000     0.00000
CONT                    0.00010     0.00000     0.00000     0.00000     0.00000
CONT                                0.00010     0.00000     0.00000     0.00000
CONT                                            0.00000     0.00000     0.00000
CONT                                                        0.00000     0.00000
CONT                                                                    0.00000
END
#list 39
end
#LIST 3
READ NSCATTERERS=    8
SCAT TYPE= C         0.018100     0.009100     2.310000    20.843920
CONT                1.020000    10.207510     1.588600     0.568700
CONT                             0.865000    51.651249     0.215600
SCAT TYPE= H         0.000000     0.000000     0.493000    10.510910
CONT                0.322910    26.125731     0.140190     3.142360
CONT                             0.040810    57.799770     0.003040
SCAT TYPE= F         0.072700     0.053400     3.539200    10.282500
CONT                2.641200     4.294400     1.517000     0.261500
CONT                             1.024300    26.147600     0.277600
SCAT TYPE= N         0.031100     0.018000    12.212610     0.005700
CONT                3.132200     9.893310     2.012500    28.997540
CONT                             1.166300     0.582600   -11.529010
SCAT TYPE= O         0.049200     0.032200     3.048500    13.277110
CONT                2.286800     5.701110     1.546300     0.323900
CONT                             0.867000    32.908939     0.250800
SCAT TYPE= P         0.295500     0.433500     6.434500     1.906700
CONT                4.179100    27.157000     1.780000     0.526000
CONT                             1.490800    68.164497     1.114900
SCAT TYPE= RU        0.055200     3.296000    19.267401     0.808520
CONT               12.918200     8.434670     4.863370    24.799700
CONT                             1.567560    94.292801     5.378740
SCAT TYPE= TI        0.219100     1.806900     9.759500     7.850800
CONT                7.355800     0.500000     1.699100    35.633801
CONT                             1.902100   116.105003     1.280700
END
#USE td-part-23.dat
#use td-part-5.dat
#bondcalc force
end
# input a traditional list 6
#use td-part-6.hkl
#weight
end
#sum l 6
end
#sfls
ref
ref
ref
end
#TITLE  PUNCH 6 FOR TRADITIONAL REFINEMENT WITH ANOMALOUS SCATTERING
#punch 6 i
end
#SUM L 6
END


# note f' and f" set to zero
#LIST 3
READ NSCATTERERS=    8
SCAT TYPE= C         0.0     0.000     2.310000    20.843920
CONT                1.020000    10.207510     1.588600     0.568700
CONT                             0.865000    51.651249     0.215600
SCAT TYPE= H         0.000000     0.000000     0.493000    10.510910
CONT                0.322910    26.125731     0.140190     3.142360
CONT                             0.040810    57.799770     0.003040
SCAT TYPE= F         0.000     0.000     3.539200    10.282500
CONT                2.641200     4.294400     1.517000     0.261500
CONT                             1.024300    26.147600     0.277600
SCAT TYPE= N         0.000     0.0000    12.212610     0.005700
CONT                3.132200     9.893310     2.012500    28.997540
CONT                             1.166300     0.582600   -11.529010
SCAT TYPE= O         0.000     0.000     3.048500    13.277110
CONT                2.286800     5.701110     1.546300     0.323900
CONT                             0.867000    32.908939     0.250800
SCAT TYPE= P         0.00     0.00     6.434500     1.906700
CONT                4.179100    27.157000     1.780000     0.526000
CONT                             1.490800    68.164497     1.114900
SCAT TYPE= RU        0.000     0.00    19.267401     0.808520
CONT               12.918200     8.434670     4.863370    24.799700
CONT                             1.567560    94.292801     5.378740
SCAT TYPE= TI        0.00     0.00     9.759500     7.850800
CONT                7.355800     0.500000     1.699100    35.633801
CONT                             1.902100   116.105003     1.280700
END
#USE td-part-23.dat
#use td-part-5.dat
#bondcalc force
end
# input a traditional list 6
#use td-part-6.hkl
#weight
end
#sum l 6
end
#sfls
calc
end
# re-input list 5
#use td-part-5.dat
# input a list 6 with PARTS and IMGINARY keys set
#use td-part-6.new                                                                                                                                                                                                                                          
#weight
end
#sfls                                                                           
calc
end
#TITLE A&B KEYS SET, f' & f" SET TO ZERO
#punch 6 i
end
# set all occupancies except Ru to zero and update PARTS
#edit                                                                           
reset occ 0 all
change ru(1,occ) 1.0
end
#use td-part-23up.dat                                                                                                                                                                                                                                                  
#sfls                                                                           
calc
end
# set all occupancies except Ru to unity, set Ru to zero
# Use stored PARTS
#edit                                                                           
reset occ 1 all
change ru(1,occ) 0.
end
#use td-part-23part.dat                                                                                                                                                                                                                                                
#sum l 6
end
#sfls                                                                           
calc
end
#sum l 6
end
#TITLE A&B KEYS SET, PARTS USED, f' & f" SET TO ZERO
#punch 6 i
end
#disk
del 6
end
#purg
end


#TITLE Pass 2, Include anomalous scattering
#LIST 3
READ NSCATTERERS=    8
SCAT TYPE= C         0.018100     0.009100     2.310000    20.843920
CONT                1.020000    10.207510     1.588600     0.568700
CONT                             0.865000    51.651249     0.215600
SCAT TYPE= H         0.000000     0.000000     0.493000    10.510910
CONT                0.322910    26.125731     0.140190     3.142360
CONT                             0.040810    57.799770     0.003040
SCAT TYPE= F         0.072700     0.053400     3.539200    10.282500
CONT                2.641200     4.294400     1.517000     0.261500
CONT                             1.024300    26.147600     0.277600
SCAT TYPE= N         0.031100     0.018000    12.212610     0.005700
CONT                3.132200     9.893310     2.012500    28.997540
CONT                             1.166300     0.582600   -11.529010
SCAT TYPE= O         0.049200     0.032200     3.048500    13.277110
CONT                2.286800     5.701110     1.546300     0.323900
CONT                             0.867000    32.908939     0.250800
SCAT TYPE= P         0.295500     0.433500     6.434500     1.906700
CONT                4.179100    27.157000     1.780000     0.526000
CONT                             1.490800    68.164497     1.114900
SCAT TYPE= RU        0.055200     3.296000    19.267401     0.808520
CONT               12.918200     8.434670     4.863370    24.799700
CONT                             1.567560    94.292801     5.378740
SCAT TYPE= TI        0.219100     1.806900     9.759500     7.850800
CONT                7.355800     0.500000     1.699100    35.633801
CONT                             1.902100   116.105003     1.280700
END
#LIST 23
MODIFY ANOM=Y EXTI=Y LAYER=N BATCH=N
CONT  PARTI=N UPDA=N ENANT=Y
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

#use td-part-5.dat
#bondcalc force
end
# input a traditional list 6
#use td-part-6.hkl
#weight
end
#sum l 6
end
#sfls
calc
end
#TITLE NORMAL LIST 6, f2 & f" SET
#punch 6 i
end
# re-input list 5
#use td-part-5.dat
# input a list 6 with PARTS and IMGINARY keys set
#use td-part-6.new                                                                                                                                                                                                                                          
#weight
end
#sfls                                                                           
calc
end
#TITLE A&B KEYS SET, f' & f" SET 
#punch 6 i
end
# set all occupancies except Ru to zero and update PARTS
#edit                                                                           
reset occ 0 all
change ru(1,occ) 1.0
end
#use td-part-23up.dat                                                                                                                                                                                                                                                  
#sfls                                                                           
calc
end
# set all occupancies except Ru to unity, set Ru to zero
# Use stored PARTS
#edit                                                                           
reset occ 1 all
change ru(1,occ) 0.
end
#use td-part-23part.dat                                                                                                                                                                                                                                                
#sum l 6
end
#sfls                                                                           
calc
end
#sum l 6
end
#TITLE A&B KEYS SET, f' & f" SET, PARTS USED 
#punch 6 i
end
#sfls
ref
ref
ref
end
#TITLE FINAL REFINEMENT, A&B KEYS SET, f' & f" SET, PARTS USED 
#punch 6 i
end
#SUM L 6
END

#end

