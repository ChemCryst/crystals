      SUBROUTINE MLTNRM
C VERSION    JAN    1980          UNIVERSITY OF YORK
C HACKED TO BITS 22 YEARS LATER  by  RICHARD COOPER

\XWISYM
\XWSCAT
\XWMISC
\XWILSO
\XESTAT
\XLST02
\XLST29
\XLST01
\ISTORE
\STORE
\QSTORE
\XCONST
\XUNITS
\XOPVAL
      DIMENSION LETT(26),N(80),NA(8)

      CHARACTER*4 CELEM
      CHARACTER*26 CLETT

      DATA LETT/1HA,1HB,1HC,1HD,1HE,1HF,1HG,1HH,1HI,1HJ,1HK,1HL,1HM,
     1 1HN,1HO,1HP,1HQ,1HR,1HS,1HT,1HU,1HV,1HW,1HX,1HY,1HZ/
      DATA CLETT/'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
      DATA KSP/1H /

      DATA ICOMSZ / 3 /
      DATA IVERSN /100/

C -- SET THE TIMING AND READ THE CONSTANTS
C -- SET UP INITIAL VALUES, READ PROGRAM PARAMETERS                    

      CALL XTIME1 ( 2 )
      CALL XCSAE

C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
      ICOMBF = KSTALL( ICOMSZ )
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910
       
C Store tolerance (only show fom's below this limit)
      IPLOTW = ISTORE(ICOMBF)
      IPLOTN = ISTORE(ICOMBF+1)
      ISTATP = ISTORE(ICOMBF+2)

      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      CALL XFAL06 (0)

      NREF=0                                                            
      RHOMAX=0.0                                                        
      TH=1.0                                                            
      EN=1.2                                                            
      ER=0.3                                                            
      MZ=100                                                            
      MM=0                                                              
      NTOT=0                                                            
      NB=0                                                              
      BT=0.0                                                            
      DO I=1,8                                                          
        NW(I)=0                                                         
        NO(I)=0                                                         
        SCAL(I)=0.0                                                     
      END DO

      IND=1                                                             

      CALL XFAL01
      CALL XMULTR ( STORE(L1P1+3) , RTD , STORE(L1P1+3) , 3 ) !Angles to Degr.
      DO J=1,6
        CX(J)=STORE(L1P1+J-1)
      END DO
      CALL INCELL                                          

      CALL XFAL02
      ICENT = 0
      IF (STORE(L2C) .GT. 0.5 ) ICENT = 1
      LATT = ISTORE(L2SG)
      CALL INSYM

      CALL XFAL29

      NK=0
      DO M29=L29,L29+(N29-1)*MD29,MD29
         NK=NK+1
         WRITE(CELEM,'(A)') ISTORE(M29)
         DO J=1,26
           IF ( CELEM(1:1).EQ.CLETT(J:J) ) THEN
             NW(NK)=J
             EXIT
           ENDIF
         ENDDO
         DO J=1,26
           IF ( CELEM(2:2).EQ.CLETT(J:J) ) THEN
             NW(NK)=NW(NK)*100 + J
             EXIT
           ENDIF
         ENDDO
         NA(NK) = T2*STORE(M29+4)
      END DO

      CALL ATREC
         

      NAT=0                                                             
      DO  I=1,80                                                    
         N(I)=KSP                                                          
      END DO
      DO I=1,NK                                                    
         K=NW(I)/100                                                       
         J=NW(I)-100*K                                                     
         IF (K.GT.0) N(I)=LETT(K)                                          
         IF (J.GT.0) N(I+40)=LETT(J)                                       
         NW(I)=NA(I)                                                       
         NO(I)=INT(AL(I)+BL(I)+CL(I)+0.5)                                  
         IF(NO(I).NE.1) NAT=NAT+NA(I)                                      
      END DO
      WRITE(NCWU,2820) (N(I),N(I+40),NA(I),NO(I),AL(I),AS(I),BL(I),
     1                  BS(I),CL(I),I=1,NK)                                                    
 2820   FORMAT(//1H ,51X,18HUNIT CELL CONTENTS//                          
     1 1H ,4HATOM,4X,14HNUMBER IN CELL,4X,13HATOMIC NUMBER,4X,          
     2 27HSCATTERING FACTOR CONSTANTS,3X,                               
     3 42H(F = AA*EXP(-A*RHO) + BB*EXP(-B*RHO) + CC)/                   
     4 (1H ,1X,2A1,I14,I17,5F15.3))                                     
C CALCULATE WILSON (GIW) SCATTERING FACTORS         
      DO I=1,142                                                   
         T=0.01*FLOAT(I-1)                                                 
         TT=T*T                                                            
         GIW(I)=0.0                                                        
         DO J=1,NK                                                    
            FZ=AL(J)*EXP(-AS(J)*TT)+BL(J)*EXP(-BS(J)*TT)+CL(J)                
            GIW(I)=GIW(I)+FZ*FZ*FLOAT(NW(J))
         END DO
      END DO


      ANAT=FLOAT(NAT)/(PTS*FLOAT((ICENT+1)*N2))                       
      WRITE(NCWU,370) ANAT

370   FORMAT(1H ,39X,36HNUMBER OF ATOMS IN ASYMMETRIC UNIT =,F6.2)
371   FORMAT(1X,/,1X,36HNUMBER OF ATOMS IN ASYMMETRIC UNIT =,F6.2)
      NASU=INT(ANAT+0.5)

C CALCULATE NUMBER OF REFLEXIONS TO PASS TO MULTAN
      IF (MM.GT.0) GOTO 400                                             
      MN = INT(4.0*ANAT+100.5)                                          
      IF (ICENT.EQ.1) MN = MN + 50                                      
      IF (N2.EQ.1) MN = MN + 50                                       
      MN = MIN0(MN,500)                                                 
      MM=MN+MIN0(500-MN,100)/2                                          

400   IF(MM.GT.0) then
       WRITE(NCWU,380) MM,MZ
      endif

380   FORMAT(1H ,27X,22HOUTPUT FOR MULTAN  -  ,I5,13H  LARGEST E'S,3X,
     1 3HAND,I5,14H  SMALLEST E'S)                                      

C READ REFLEXION DATA FROM A CRYSTALS SHELX FORMAT FILE
      CALL CARDIN

      NB=8.0*ALOG10(0.05*FLOAT(MAX0(NREF,100))+0.5)
C MAXIMUM OF 30 POINTS ON WILSON PLOT
      IF(NB.GT.30) NB=30                                                
      WRITE(NCWU,440) NREF,RHOMAX,NB                                      
440   FORMAT(23H NUMBER OF REFLEXIONS =,I6,8X,                          
     1 32HMAXIMUM (SIN(THETA)/LAMBDA)**2 =,F7.4,8X,                     
     2 33HNUMBER OF POINTS ON WILSON PLOT =,I3)                         


C OBTAIN SUMS FOR WILSON PLOT AND FIT LEAST SQUARES STRAIGHT LINE
      CALL WILSUM(PTS,ISTATP)   


C PLOT WILSON CURVE AND LEAST SQUARES STRAIGHT LINE
      CALL GRAPH80(0,IPLOTW) 
  450 BT=2.0*BT                                                         

C CALCULATE SCALE FACTORS FOR APPROPRIATE REFLEXION GROUPS
      CALL RESCA(KSYS)                                         

C CALCULATE FINAL E'S AND OUTPUT REFLEXION STATISTICS
      CALL ECAL(KSYS,IPLOTN, ISTATP)

9000  CONTINUE
C -- FINAL MESSAGE
      CALL XOPMSG ( IOPDSP , IOPEND , IVERSN )
      CALL XTIME2 ( 2 )
      CALL XRSL
      CALL XCSAE
      RETURN

9900  CONTINUE
C -- ERRORS
      CALL XOPMSG ( IOPDSP , IOPABN , 0 )
      GO TO 9000
9910  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG ( IOPDSP , IOPCMI , 0 )
      GO TO 9900
      RETURN

      END                                                               



C ------------------------------------------------------------------
C INPUT UNIT CELL PARAMETERS AND CALCULATE RECIPROCAL PARAMETERS    
      SUBROUTINE INCELL                                                 
\XCONST
\XUNITS
\XWMISC
      WRITE(NCWU,20) (CX(I),I=1,6)                                        
   20 FORMAT(1H ,11HDIRECT CELL,9X,3HA =,F8.3,4X,3HB =,F8.3,4X,         
     1 3HC =,F8.3,4X,7HALPHA =,F7.2,4X,6HBETA =,F7.2,4X,7HGAMMA =,F7.2) 
      CALL VOL(CX,V)                                                    
C     VOLUME AND RECIPROCAL CELL FUNCTIONS                              
      V=1.0/(V*CX(1)*CX(2)*CX(3))                                       
      P(1)=CX(2)*CX(3)*CX(7)*V                                          
      P(2)=CX(1)*CX(3)*CX(8)*V                                          
      P(3)=CX(1)*CX(2)*CX(9)*V                                          
      P(4)=0.5*P(1)*P(2)*(CX(4)*CX(5)-CX(6))/(CX(7)*CX(8))              
      P(5)=0.5*P(1)*P(3)*(CX(4)*CX(6)-CX(5))/(CX(7)*CX(9))              
      P(6)=0.5*P(2)*P(3)*(CX(5)*CX(6)-CX(4))/(CX(8)*CX(9))              
      DO 40 I=1,3                                                       
      P(I)=0.25*P(I)*P(I)                                               
      CX(I+3)=180.0*ATAN2(CX(I+6),CX(I+3))/PI                           
   40 CONTINUE                                                          
      WRITE(NCWU,50) P                                                    
   50 FORMAT(6H RHO =,F9.6,9H * H**2 +,F9.6,9H * K**2 +,F9.6,9H * L**2 +
     1 ,F9.6,10H * H * K +,F9.6,10H * H * L +,F9.6,8H * K * L)          
      RETURN                                                            
      END                                                               
C     ------------------------------------------------------------------
C     SINE AND COSINE OF CELL ANGLES PLUS TRIGONOMETRIC PART OF VOLUME  
      SUBROUTINE VOL(CX,V)                                              
\XCONST
      DIMENSION CX(9)                                                   
      ARG=1.0                                                           
      DO 10 I=4,6                                                       
      CX(I+3)=SIN(DTR*CX(I))                                           
      CX(I)=COS(DTR*CX(I))                                             
      ARG=ARG-CX(I)*CX(I)                                               
   10 CONTINUE                                                          
      V=SQRT(ARG+2.0*CX(4)*CX(5)*CX(6))                                 
      RETURN                                                            
      END                                                               

C ------------------------------------------------------------------
C READ GENERAL EQUIVALENT POSITIONS AS IN INTERNATIONAL TABLES AND  
C DETERMINE LATTICE MULTIPLICITY (PTS) AND CRYSTAL SYSTEM (KSYS)    
      SUBROUTINE INSYM    
\XWISYM
      DIMENSION N(80),KX(15),LTC(7),ICAP(2),LINE(21)
\STORE
\ISTORE
\QSTORE
\XLST02
\XUNITS

      DATA KX/1H1,1H2,1H3,1H4,1H5,1H6,1HX,1HY,1HZ,1H ,1H,,1H+,1H-,1H/,
     1 1H*/                                                             
      DATA LTC/1HP,1HA,1HB,1HC,1HI,1HF,1HR/,ICAP/3HNON,3H   /           


      WRITE(NCWU,104) ICAP(ICENT+1),N2,LATT
  104 FORMAT(/1H ,17HTHE STRUCTURE IS ,A3,15HCENTROSYMMETRIC,8X,I3,3X,  
     1 28HGENERAL EQUIVALENT POSITIONS,10X,18HLATTICE IS OF TYPE,3X,A1/)


C DETERMINE LATTICE MULTIPLICITY
C PRIMITIVE                                                         
      PTS=1.0                                                           
      DO 250 I=1,7                                                      
        IF(LATT.EQ.LTC(I)) GO TO 260                                      
  250 CONTINUE                                                          
  260 LATT=I
      IF(LATT.EQ.7) THEN !R
C PRIMITIVE RHOMBOHEDRAL - PTS=1.0 or CENTRED HEXAGONAL - PTS = 3.0
        DO M2 = L2, L2+(N2-1)*MD2,MD2
          IF ( IABS(NINT( STORE(M2+2) )) .EQ. 1) GOTO 400
        END DO
        PTS=3.0
      ELSE IF(LATT.NE.1) THEN
        PTS=2.0 ! A, B, C OR I CENTRED
        IF(LATT.EQ.6) PTS=4.0 ! F CENTRED
      END IF
C DETERMINE CRYSTAL SYSTEM

400    DO M2=L2,L2+(N2-1)*MD2,MD2
         IF(IABS(NINT(STORE(M2+2))).EQ.1)GOTO 480 ! z in first col - cubic
         IF(IABS(NINT(STORE(M2+1))).EQ.1)GOTO 460 ! y in first col - tetrag
       ENDDO

C 1 - TRICLINIC, 2 - MONOCLINIC, 3 - ORTHORHOMBIC
      KSYS=MIN0(N2,3)                                                 
      GO TO 500                                                         
  460 CONTINUE
C TETRAGONAL                                                        
      KSYS=4                                                            
      IF(N2.EQ.4.OR.N2.EQ.8) GO TO 500                              
C TRIGONAL OR RHOMBOHEDRAL INDEXED ON HEXAGONAL AXES                
      KSYS=5                                                            
C TEST FOR 6-FOLD AXIS - GENERAL FORM -X, -Y, Z + T                 

      DO 470 M2=L2+MD2,L2+(N2-1)*MD2,MD2
       IF((IABS(NINT(STORE(M2+1))).EQ.1).OR.
     1    (IABS(NINT(STORE(M2+2))).EQ.1)) GOTO 470
       IF((IABS(NINT(STORE(M2+3))).EQ.1).OR.
     1    (IABS(NINT(STORE(M2+3))).EQ.1)) GOTO 470

C HEXAGONAL
      KSYS=6
  470 CONTINUE                                                          
      GO TO 500                                                         
C CUBIC                                                             
  480 KSYS=8                                                            
C PRIMITIVE RHOMBOHEDRAL                                            
      IF(LATT.EQ.7) KSYS=7                                              
      IF(KSYS.EQ.7) LATT=1                                              
  500 RETURN                                                            
      END                                                               

C ------------------------------------------------------------------
C INPUT INFORMATION ABOUT CELL CONTENTS AND MOLECULAR FRAGMENTS     
C CALCULATE SPHERICAL SCATTERING FACTORS                            
      SUBROUTINE ATREC                                                  
C     INPUT/OUTPUT UNITS, TITLE, FLAGS                                  
\XWSCAT
      DIMENSION ALT(50),AST(50),BLT(50),BST(50),CLT(50),N1(50)
      DATA N1/8,1209,205,2,3,14,15,6,1401,1307,112,1909,16,19,312,      
     1 11,301,2009,22,318,1314,605,315,1409,321,2614,119,1905,218,      
     2 1802,1918,2618,1315,1821,1808,1604,107,304,1914,1902,9,319,      
     3 201,23,1519,1620,121,807,1602,209/                               
C     ATOMIC SCATTERING FACTORS FOR ABOVE ATOM TYPES                    
C         F = AL * EXP(-AS * RHO) + BL * EXP(-BS * RHO) + CL            
      DATA ALT/0.388,1.560,1.261,1.207,2.112,3.188,4.197,5.155,7.488,   
     1 7.426,7.276,6.988,6.509,5.967,5.557,9.544,10.25,11.69,12.50,     
     2 13.67,14.17,15.01,15.84,16.69,17.88,18.32,18.62,18.48,18.18,     
     3 17.27,17.95,18.21,18.38,19.56,20.42,20.02,22.37,23.74,25.20,     
     4 25.41,25.51,25.57,26.03,36.53,36.50,36.08,36.22,37.13,38.75,     
     5 39.16/                                                           
      DATA AST/7.151,3.264,2.620,5.745,7.827,7.341,6.327,5.392,4.821,   
     1 3.770,3.143,2.739,2.602,2.753,3.176,7.683,7.176,6.300,5.929,     
     2 5.789,5.252,4.958,4.687,4.440,4.357,4.019,3.091,2.815,2.638,     
     3 3.382,4.361,4.515,4.490,4.686,4.797,4.398,4.881,4.953,4.631,     
     4 4.290,3.653,3.556,4.022,3.505,3.460,3.333,3.360,3.585,3.820,     
     5 3.714/                                                           
      DATA BLT/0.601,1.059,2.008,2.530,2.462,2.305,2.218,2.172,1.280,   
     1 2.267,3.192,4.169,5.107,5.925,6.573,2.843,3.086,3.419,3.482,     
     2 3.131,3.554,3.573,3.578,3.558,3.088,3.501,5.729,6.744,7.710,     
     3 7.397,5.919,6.578,7.602,7.598,7.360,8.892,6.844,6.153,6.411,     
     4 7.297,9.410,10.22,9.230,8.741,9.627,11.22,11.46,10.38,9.179,     
     5 9.659/                                                           
      DATA BST/30.18,108.3,54.77,38.23,31.65,26.84,22.83,19.61,96.71,   
     1 69.72,55.67,43.28,34.46,28.44,24.26,53.75,79.64,62.92,57.74,     
     2 46.70,49.62,46.50,43.88,41.79,35.63,38.46,35.40,30.87,27.32,     
     3 28.90,44.38,42.30,30.85,28.20,27.65,20.92,26.38,32.06,40.81,     
     4 39.07,33.09,31.70,38.86,33.47,29.80,23.06,22.12,25.33,33.99,     
     5 35.23/                                                           
      DATA CLT/0.008,0.3747,0.7163,1.243,1.412,1.498,1.578,1.668,2.216, 
     1 2.291,2.491,2.801,3.343,4.073,4.839,6.494,6.616,6.846,6.966,     
     2 7.147,7.226,7.375,7.541,7.712,7.986,8.136,8.601,8.727,9.070,     
     3 12.09,13.92,15.06,15.88,16.72,17.11,17.04,17.69,18.02,18.30,     
     4 18.22,18.02,18.93,20.42,28.57,29.71,30.56,31.19,32.35,33.92,     
     5 34.06/                                                           
      ITYPE=0
      DO 150 I=1,NK                                                     
C     CHECK ATOM TYPE                                                   
      DO 120 J=1,50                                                     
      IF(NW(I).NE.N1(J)) GO TO 120                                      
      AS(I)=AST(J)                                                      
      AL(I)=ALT(J)                                                      
      BS(I)=BST(J)                                                      
      BL(I)=BLT(J)                                                      
      CL(I)=CLT(J)                                                      
      ITYPE=ITYPE+1
120    CONTINUE                                                         
150    CONTINUE                                                         
160   RETURN                                                         
      END                                                               
C ------------------------------------------------------------------
C READ REFLEXIONS
      SUBROUTINE CARDIN
\XWMISC
\XLST06
\STORE
      CALL XFAL06(0)
      ISTAT = KFNR(0)
      DO WHILE ( ISTAT .GE. 0 )
        IH = STORE(M6)               ! H
        IK = STORE(M6+1)             ! K
        IL = STORE(M6+2)             ! L
        NREF=NREF+1                                                       
        RHO   =P(1)*FLOAT(IH*IH)+P(2)*FLOAT(IK*IK)+P(3)*FLOAT(IL*IL)
     3        +P(4)*FLOAT(IH*IK)+P(5)*FLOAT(IH*IL)+P(6)*FLOAT(IK*IL)
        RHOMAX=AMAX1(RHOMAX,RHO)                                       
        ISTAT = KFNR(0)
      END DO
      RETURN                                                            
      END


C CALCULATE RHO, EPSILON, MULTIPLICITY AND SCATTERING FACTOR        
C FOR EACH REFLEXION
      SUBROUTINE FCAL2 (MHKL,FOB,ID,EW,RHO)
      DIMENSION MHKL(3),I2(3)
\XWISYM
\XWSCAT
\XWMISC
\STORE
\ISTORE
\QSTORE
\XLST02
        RHO   =P(1)*FLOAT(MHKL(1)*MHKL(1))
     1        +P(2)*FLOAT(MHKL(2)*MHKL(2))
     2        +P(3)*FLOAT(MHKL(3)*MHKL(3))
     3        +P(4)*FLOAT(MHKL(1)*MHKL(2))
     4        +P(5)*FLOAT(MHKL(1)*MHKL(3))
     5        +P(6)*FLOAT(MHKL(2)*MHKL(3))

C COMPUTE EPSILON AND MULTIPLICITY BY GENERATING EQUIVALENT REFLEXIONS                                                        

C EPSILON = NUMBER OF TIMES SAME REFLEXION APPEARS IN LIST
C MULTIPLICITY = NUMBER DIFFERENT REFLEXIONS IN LIST                

        EPS=1.0
        MULT=1

C IN TRICLINIC SPACE GROUPS EPS = 1.0 AND MULT = 1                  
        IF(N2.GT.1) THEN
          K1 = 65536*MHKL(1) + 256*(MHKL(2)+128) + MHKL(3) + 128                          
          IK1 = 65792-K1                                                      

          DO M2 = L2+MD2 , L2+(N2-1)*MD2 , MD2
            DO 10 L=1,3
  10        I2(L)=0    
            DO L=1,3
              DO K=1,3
                M=IABS(NINT(STORE(M2+(L-1)*3+(K-1))))
                IF(M.GT.0) THEN
                  I2(K)=I2(K)+MHKL(L)*
     1                 ISIGN(1, NINT(STORE( M2+(L-1)*3+(K-1) )) )
                END IF
              END DO
            END DO

            K2= 65536*I2(1) + 256*(I2(2)+128) + I2(3) + 128
            IF(K2.EQ.K1) EPS=EPS+1.0
            IF(ICENT.NE.0 .AND. K2.EQ.IK1) EPS=EPS+1.0
            IF(K2.EQ.K1 .OR. K2.EQ.IK1) MULT=MULT+1
          END DO
        END IF
        FF = FOB*FOB / PTS
        ID = N2 / MULT

C DETERMINE INDEX GROUP (FOR RESCALING)                             
        IF(KSYS.GE.7) THEN
C CUBIC AND PRIMITIVE RHOMBOHEDRAL                                  
           IG=3*MOD(IABS(MHKL(1)+MHKL(2)+MHKL(3)),2)                               
           IF(MOD(MHKL(1)-MHKL(3),3).EQ.0)  IG=IG+1                               
           IF(MOD(MHKL(2)-MHKL(3),3).EQ.0 .OR.
     1        MOD(MHKL(1)-MHKL(2),3).EQ.0)  IG=IG+1
           GOTO 100
        END IF

        LG=MOD(IABS(MHKL(3)),2)                                             

        IF(KSYS.GE.5) THEN
C TRIGONAL, HEXAGONAL AND RHOMBOHEDRAL INDEXED ON HEXAGONAL AXES
           IG=3*LG
           IF(MOD(MHKL(1),3).EQ.0) IG=IG+1
           IF(MOD(MHKL(2),3).EQ.0.OR.MOD(MHKL(1)+MHKL(2),3).EQ.0)IG=IG+1
           GO TO 100
        END IF

        KG=MOD(IABS(MHKL(2)),2)
        JG=MOD(IABS(MHKL(1)),2)                                             

C TRICLINIC, MONCLINIC AND ORTHORHOMBIC
        IF(KSYS.LE.3) IG=JG+2*KG+4*LG                                     

C TETRAGONAL
        IF(KSYS.EQ.4) IG=JG+KG+3*LG                                       

C PACK SYMMETRY FUNCTIONS FOR LATER USE                             
  100   ID=10000*ID+100*INT(EPS+0.5)+IG+1                           

C LOOK UP SCATTERING FACTOR TABLES GENERATED BY ATREC
        SINTH= 100.0*SQRT(RHO)                                          
        IND  = MAX0(2,INT(SINTH+1.5))                                        
        FRAC = SINTH-FLOAT(IND-1)                                           
        BF   = 0.5*(GIW(IND+1)-GIW(IND-1))                                    
        AF   = BF+GIW(IND-1)-GIW(IND)                                         
        FORM = AF*FRAC*FRAC+BF*FRAC+GIW(IND)                                
C 'WILSON' STRUCTURE FACTOR                                         
        EW   = FF/(FORM*EPS)                                               

      RETURN                                                            
      END                                                               

C ------------------------------------------------------------------
C     LEAST SQUARES PLOT, INCLUDING SUMMATION OVER NB RANGES OF RHO     
      SUBROUTINE WILSUM(PTS,ISTATP)  
\XWMISC
\XWILSO
\XCONST
\XLST05
\XLST06
\STORE
\XUNITS
\XIOBUF

      DIMENSION SW(30),SR(30),SI(30),NSUM(30), MHKL(3),
     1          SWC(30),SIC(30)

      WRITE(NCWU,40)                                                      
   40 FORMAT(//1H ,20X,18HLEAST SQUARES PLOT//6H RANGE,6X,              
     1 18HRHO=(SINTH/LAM)**2,6X,6HNUMBER,6X,8HMEAN RHO,7X,6HMEAN I,     
     2 7X,23HMEAN EXP(-2*B*RHO)*E**2,3X,5HDEBYE,7X,6HWILSON)            
C     SET INITIAL VALUES                                                
      PP=0.0                                                            
      Q=0.0                                                             
      R=0.0                                                             
      S=0.0                                                             
      T=0.0                                                             
      NUMBER=0                                                          
      ADD=RHOMAX/FLOAT(NB)                                              
      START=-ADD                                                        
      END=ADD                                                           
      RR=FLOAT(NB)/RHOMAX                                               
      DO 50 I=1,30                                                      
        SW(I)=0.0                                                         
        SR(I)=0.0                                                         
        SI(I)=0.0                                                         
        SWC(I)=0.0                                                         
        SIC(I)=0.0                                                         
        NSUM(I)=0                                                         
   50 CONTINUE                                                          
      E5 = .TRUE.
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0)  THEN
       IF (KEXIST(5) .GT. 0) THEN
          CALL XFAL05
       ELSE
          E5 = .FALSE.
       ENDIF
      ENDIF
      IF(E5)SCALE = STORE(L5O)
      CALL XFAL06(0)
      ISTAT = KFNR(0)
      DO WHILE ( ISTAT .GE. 0 )
        FOB  = STORE(M6+3)            ! FO
        IF(E5)THEN
          FCA  = SCALE * STORE(M6+5)    ! FC
        ELSE
          FCA  = 0.0
        ENDIF
        MHKL(1) = STORE(M6)           ! H
        MHKL(2) = STORE(M6+1)         ! K
        MHKL(3) = STORE(M6+2)         ! L
        CALL FCAL2 (MHKL,FOB,IDS,EWS,RHOS)
C N STORES RANGE OF RHO
        N=MIN0(INT(1.0+RR*RHOS),NB)                                     
        MULT=IDS/10000                                                  
        IE=(IDS-10000*MULT)/100                                         
        EPS=FLOAT(IE)                                                     
        TMUL=FLOAT(MULT)                                                  
C WEIGHTED SUMS                                                     
C  NUMBER OF REFLEXIONS                                              
        NSUM(N)=NSUM(N)+MULT                                              
C  WILSON                                                            
        SW(N)=SW(N)+EWS*TMUL                                            
C  RHO                                                               
        SR(N)=SR(N)+RHOS*TMUL                                           
C  INTENSITY                                                         
        SI(N)=SI(N)+TMUL*FOB*FOB/(EPS*PTS)

        IF (E5) THEN
          CALL FCAL2 (MHKL,FCA,IDS,EWS,RHOS)
          IF ( EWS.LE.0 ) THEN
            E5 = .FALSE. !Can't do calculated line.
          ELSE
C WEIGHTED SUMS                                                     
C  WILSON                                                            
            SWC(N)=SWC(N)+EWS*TMUL                                            
C  INTENSITY                                                         
            SIC(N)=SIC(N)+TMUL*FCA*FCA/(EPS*PTS)
          END IF
        ENDIF
        ISTAT = KFNR(0)
      END DO


  250 DO I=1,NB
C SMOOTH CURVE BY ADDING ADJACENT RANGES                            
        NUMBER=NUMBER+NSUM(I)
        NSUM(I)=NSUM(I)+NSUM(I+1)
        SW(I)=SW(I)+SW(I+1)
        SR(I)=SR(I)+SR(I+1)
        SI(I)=SI(I)+SI(I+1)
        IF ( E5 ) THEN
          SWC(I)=SWC(I)+SWC(I+1)
          SIC(I)=SIC(I)+SIC(I+1)
        END IF

C CALCULATE WEIGHTED AVERAGES AND LOGS
        WT=FLOAT(NSUM(I))                                                 
        DIV=1.0/AMAX1(1.0,WT)                                             
        AVI=SI(I)*DIV                                                     
        AVR(I)=SR(I)*DIV                                                  

        FLGW(I)          =ALOG(MAX(SW(I) *DIV,0.00000000001))
        IF ( E5) FLGWC(I)=ALOG(MAX(SWC(I)*DIV,0.00000000001))

c        WRITE(95,'(2F15.8)')FLGW(I), FLGWC(I)

        START=START+ADD
        END=AMIN1(END+ADD,RHOMAX)                                         
        WRITE(NCWU,280) I,START,END,NSUM(I),AVR(I),
     1                AVI,SW(I)*DIV,FLGW(I),FLGW(I)
  280  FORMAT(1H ,I3,F15.4,3H  -,F8.4,I11,F14.4,F14.1,F23.4,F15.4,F13.4) 

C COEFFICIENTS OF NORMAL EQUATIONS
        PP=PP+WT*AVR(I)*AVR(I)                                            
        Q=Q+WT*AVR(I)
        R=R+WT*AVR(I)*FLGW(I)
        S=S+WT*FLGW(I)
        T=T+WT
      END DO

      WRITE(NCWU,320) PP,Q,R,Q,T,S
  320 FORMAT(17H NORMAL EQUATIONS/(1H ,E11.3,10H * SLOPE +,E11.3,       
     1 14H * INTERCEPT =,E11.3))                                        
C     LEAST SQUARES                                                     
      DIV=PP*T-Q*Q                                                      
      SLOPE=(R*T-Q*S)/DIV                                               
      FLGK=(PP*S-Q*R)/DIV                                               
      SC=EXP(-FLGK)                                                     
      BT=-0.5*SLOPE                                                     
      WRITE(NCWU,340) SLOPE,FLGK,BT,SC                                    
  340 FORMAT(1H ,7HSLOPE =,F8.4,4X,11HINTERCEPT =,F8.4,4X,              
     1/25H TEMPERATURE FACTOR (B) =,F8.4,4X,7HSCALE =,F8.4,             
     2 4X,37HF(ABSOLUTE)**2 = SCALE*F(OBSERVED)**2)

      IF (ISTATP .EQ. 1) THEN

        WRITE(CMON,'(A,F8.4,/,A,F8.4,/,A)')
     1  '^^WI SET _MW_BFACTR TEXT ',BT,
     1  '^^WI SET _MW_BSCALE TEXT ',SC,
     1  '^^CR'
        CALL XPRVDU(NCVDU, 3,0)
      END IF


      RETURN                                                            
      END                                                               
C     ------------------------------------------------------------------
C     LINE PRINTER PLOT AT 50 VALUES OF RHO                             
      SUBROUTINE GRAPH80(NGP,IPLOTW)
\XWMISC
\XWILSO
\XIOBUF
\XUNITS
      DIMENSION FH(6),RH(6),M(117),R(4),AD(4),AW(4),AWC(4)                     
      DATA IST,ISP,ICW,ICD/1H*,1H ,1HW,1HD/                             
C     DETERMINE RANGES OF LOGS                                          
      RX=AVR(NB)                                                        
      FX=FLGK                                                           
      FN=SLOPE*RX+FLGK                                                  
      DO I=1,117
        M(I)=ISP
      END DO
      DO I=1,NB
        FX=AMAX1(FX,FLGW(I))
        FN=AMIN1(FN,FLGW(I))
      END DO
      FD=FX-FN
      DO I=1,6
        RH(I)=0.2*FLOAT(I-1)*RX
        FH(I)=FN+0.2*FLOAT(I-1)*FD
      END DO
C TOP FRAME
      WRITE(NCWU,40) FH,RH(1)                                        
   40 FORMAT(1H ,25X,63HPLOT OF WILSON AND DEBYE CURVES AND LEAST SQUARE
     1S STRAIGHT LINE/1H ,15X,20X/1H ,40X,20HLN(F(OBS)**2/SIGFSQ)/1H , 
     2 F18.3,5F20.3/1H ,F12.3,2X,1H-,5(1HI,19(1H-)),2HI-)               
      J=1                                                               
      IR=2

      IF ( IPLOTW .EQ. 1 ) THEN
        WRITE(CMON,'(A,5(/A))')
     1  '^^PL PLOTDATA _WILSON SCATTER ATTACH _VWILSON KEY',
     1  '^^PL XAXIS TITLE LN(F(OBS)**2/SIGFSQ)',
     1  '^^PL NSERIES=3 LENGTH=50 YAXIS TITLE Rho',
     1  '^^PL SERIES 1 SERIESNAME ''Straight Line'' TYPE LINE',
     1  '^^PL SERIES 2 SERIESNAME ''Wilson''',
     1  '^^PL SERIES 3 SERIESNAME ''Wilson (Fcalc)'' TYPE LINE'
        CALL XPRVDU(NCVDU, 6,0)
      END IF

      XMIN = +1000.
      XMAX = -1000.

      DO I=1,50                                                     
        DCV(I)=-1000000.0                                                 
C SIDE FRAME                                                        
        IF(MOD(I,10).EQ.0) THEN
          WRITE(NCWU,70) RH(IR)
   70     FORMAT(1H ,F11.3,3X,3H-I-,$) 
          IR=IR+1
        ELSE
          WRITE(NCWU,50)
   50     FORMAT(1H ,15X,2HI ,$)                                               
        END IF
C INTERPOLATION
        Q=0.02*FLOAT(I)*RX
        SVAL = SLOPE*Q+FLGK
        IL=(SVAL-FN)*100.0/FD+16.5                                
        IF(IL.GT.117) IL=117                                              
        IF(IL.LT.1) IL=1                                                  
        M(IL)=IST
        IF(Q.GE.AVR(1)) THEN
          IF(((J.EQ.NB-2).AND.(J.NE.1)) .OR.
     1       ((Q.LT.AVR(J+1)).AND.(J.NE.1))) GO TO 130
          J=J+1
          DO K=1,4                                                      
            ITEMP = J-2+K                                                     
            R(K)=AVR(ITEMP)
          END DO

          CALL NSOLVE(R,FLGW(J-1),FLGW(J),FLGW(J+1),FLGW(J+2),AW)
C WILSON PLOT INTERPOLATION
  130     WVAL = AW(4)+ Q * ( AW(3) + Q * ( AW(2) + Q * AW(1) ) )
          IL=100.0*(WVAL-FN)/FD+16.5
          IF(IL.GT.117) IL=117                                              
          IF(IL.LT.1) IL=1                                                  
          M(IL)=ICW
C STORE K-CURVE                                                     
          DCV(I)=EXP(AW(4)+Q*(AW(3)+Q*(AW(2)+Q*AW(1))))

          IF ( E5 ) THEN
            CALL NSOLVE(R,FLGWC(J-1),FLGWC(J),FLGWC(J+1),FLGWC(J+2),AWC)
            WCVAL = AWC(4) + Q * ( AWC(3) + Q * (AWC(2) + Q * AWC(1)) )
          ELSE
            WCVAL = 0.0
          END IF

          IF ( IPLOTW .EQ. 1 ) THEN
            WRITE(CMON,'(A,6F10.5)')
     1      '^^PL DATA ', SVAL , 0.02*FLOAT(I-1)*RX, WVAL,
     2      0.02*FLOAT(I-1)*RX, WCVAL , 0.02*FLOAT(I-1)*RX
            CALL XPRVDU(NCVDU, 1,0)
          END IF

          XMIN = MIN(XMIN, SVAL,WVAL)
          XMAX = MAX(XMAX, SVAL,WVAL)

        END IF

        M(16)=ISP

        IF(MOD(I,10).EQ.0)THEN
          M(15)=ISP                                                         
          M(17)=ISP                                                         
          DO L=1,11
            M(L)=ISP
          END DO
        END IF

  170   FORMAT(100A1)
  190   FORMAT(100A1,2X,3HRHO)                                              
        IF ( I.EQ.25 ) THEN
          WRITE(NCWU,190)(M(II),II=18,117)
        ELSE
          WRITE(NCWU,170)(M(II),II=18,117)
        ENDIF

        DO L=1,117
           M(L)=ISP
        END DO
      END DO

      IF ( IPLOTW .EQ. 1 ) THEN
C Round down XMIN to nearest .1:
        XRX = XMIN * 10.
        XMIN = NINT (XRX)
        IF ( XRX.LT.XMIN ) XMIN = XMIN - 1
        XMIN = XMIN / 10.0
C Round XMAX up:
        XRX = XMAX*10.0
        XMAX = NINT(XRX)
        IF ( XRX.GT.XMAX ) XMAX = XMAX + 1
        XMAX = XMAX / 10.
C Round RX up:
        XRX = NINT(RX * 10.0)
        IF ( RX*10.0 .GT. XRX ) XRX = XRX + 1
        XRX = XRX / 10.
        WRITE(CMON,'(A,2(F5.1,1X),A,F4.1,A/A/A)')
     1  '^^PL XAXIS ZOOM ',XMIN,XMAX+.1,'YAXIS ZOOM ',XRX,' 0.0',
     2  '^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 3,0)
      END IF

C     K-CURVE PARAMETERS
      DEL=50.0/AVR(NB)                                                  
C     K-CURVE FOLLOWS LEAST-SQUARES STRAIGHT LINE UNTIL THE DEBYE CURVE 
C     CROSSES IT.                                                       
      J=0                                                               
      JP=0                                                              
      DO I=1,50                    
        SK=EXP(SLOPE*FLOAT(I)/DEL+FLGK)
        IF(DCV(I).GE.(-999999.0)) THEN
          JP=-1                
          IF(DCV(I).GT.SK) JP=1
          IF(J.EQ.(-JP)) EXIT
          J=JP
        END IF
        DCV(I)=SK
      END DO
      RETURN                                                            
      END                                                               
C ------------------------------------------------------------------
C FIT CURVE TO Y = A(1) * RHO**3 + A(2) * RHO**2 + A(3) * RHO + A(4)
      SUBROUTINE NSOLVE(R,Y1,Y2,Y3,Y4,A)                                 
      DIMENSION R(4),A(4)                                               
      B2=R(4)*(R(4)+R(1))                                               
      B1=(Y4-Y1)/(R(4)-R(1))                                            
      C31=(Y2-Y1)/(R(2)-R(1))-B1                                        
      C32=(Y3-Y1)/(R(3)-R(1))-B1                                        
      C11=R(2)*(R(2)+R(1))-B2                                           
      C12=R(3)*(R(3)+R(1))-B2                                           
      C21=R(2)-R(4)                                                     
      C22=R(3)-R(4)                                                     
      A(1)=(C31*C22-C32*C21)/(C22*C11-C12*C21)                          
      A(2)=(C31-C11*A(1))/C21                                           
      A(3)=B1-(R(4)*R(4)+R(1)*R(1)+R(4)*R(1))*A(1)-(R(4)+R(1))*A(2)     
      A(4)=Y1-R(1)*(A(3)+R(1)*(A(2)+R(1)*A(1)))                         
      RETURN                                                            
      END                                                               
C ------------------------------------------------------------------
C INDEX GROUP RESCALING                                             
      SUBROUTINE RESCA(KSYS)                                   
\XWMISC
\XWILSO
\XLST06
\STORE
\XUNITS

      DIMENSION NG(8),SCS(8),MHKL(3)
      TOT=0.0                                                           
      NW=0                                                              
      DO I=1,8                                                       
        SCS(I)=0.0                                                        
        NG(I)=0
      END DO

      CALL XFAL06(0)
      ISTAT = KFNR(0)
      DO WHILE ( ISTAT .GE. 0 )
        FOB  = STORE(M6+3)            ! FO
        MHKL(1) = STORE(M6)           ! H
        MHKL(2) = STORE(M6+1)         ! K
        MHKL(3) = STORE(M6+2)         ! L
        CALL FCAL2 (MHKL,FOB,IDS,EWS,RHOS)
        CALL CURVK(ESQ,RHOS,EWS) 
C UNPACK SYMMETRY FUNCTIONS                                         
        MULT=IDS/10000                                                  
        TMUL=FLOAT(MULT)                                                  
        TOT=TOT+ESQ*TMUL                                                  
        NW=NW+MULT                                                        
        IG=MOD(IDS,100)                                                 
        SCS(IG)=SCS(IG)+ESQ*TMUL                                          
        NG(IG)=NG(IG)+MULT                                                
        ISTAT = KFNR(0)
      END DO

      TOT=TOT/FLOAT(NW)                                                 
C 8 PARITY GROUPS FOR TRICLINIC, MONOCLINIC AND ORTHORHOMBIC        
      NN=8                                                              
C 6 MODIFIED PARITY GROUPS FOR TETRAGONAL                           
C 6 INDEX GROUPS IN OTHER SYSTEMS                                   
      IF(KSYS.GE.4) NN=6                                                
      DO 320 I=1,NN                                                     
      IF(NG(I).GT.0) SCS(I)=SCS(I)/FLOAT(NG(I))                         
  320 CONTINUE                                                          
      WRITE(NCWU,330)                                                     
  330 FORMAT(1H ,27X,66HAVERAGE E**2 ACCORDING TO APPROPRIATE INDEX GROU
     1P BEFORE RESCALING)                                               
      IF(KSYS.LE.3) WRITE(NCWU,335)                                       
  335 FORMAT(1H ,53X,13HPARITY GROUPS/1H ,18X,3HALL,9X,3HEEE,9X,3HOEE,  
     1 9X,3HEOE,9X,3HOOE,9X,3HEEO,9X,3HOEO,9X,3HEOO,9X,3HOOO)           
      IF(KSYS.EQ.4) WRITE(NCWU,340)                                       
  340 FORMAT(1H ,49X,22HMODIFIED PARITY GROUPS/1H ,18X,3HALL,9X,3HEEE,  
     1 7X,7HEOE,OEE,7X,3HOOE,9X,3HEEO,7X,7HEOO,OEO,7X,3HOOO)            
      IF(KSYS.LE.4) GO TO 365                                           
      WRITE(NCWU,345)                                                     
  345 FORMAT(26H INDEX GROUPS DIVIDED ON -)                             
      IF(KSYS.LE.6) WRITE(NCWU,350)                                       
  350 FORMAT(1H+,30X,11H1) MOD(H,3),4X,11H2) MOD(K,3),4X,               
     1 13H3) MOD(H+K,3),4X,11H4) MOD(L,2))                              
      IF(KSYS.GE.7) WRITE(NCWU,355)                                       
  355 FORMAT(1H+,30X,13H1) MOD(H-L,3),4X,13H2) MOD(K-L,3),4X,           
     1 13H3) MOD(H-K,3),4X,15H4) MOD(H+K+L,2))                          
      WRITE(NCWU,360)                                                     
  360 FORMAT(1H ,30X,18HE - ZERO REMAINDER,4X,22HO - NON-ZERO REMAINDER/
     1 1H ,18X,3HALL,9X,4HOOOE,5X,9HOOEE,OEOE,6X,4HEEEE,8X,4HOOOO,      
     2 5X,9HOOEO,OEOO,6X,4HEEEO/1H ,42X,4HEOOE,32X,4HEOOO)              
  365 WRITE(NCWU,370) TOT,(SCS(I),I=1,NN)                                 
  370 FORMAT(1H ,3X,4HE**2,3X,9F12.3)                                   
      WRITE(NCWU,380) NW,(NG(I),I=1,NN)                                   
  380 FORMAT(1H ,2X,6HNUMBER,2X,9I12)                                   
      TOT=1.0/TOT                                                       
      DO 400 I=1,NN                                                     
      IF(NG(I).GT.0) SCAL(I)=1.0/SCS(I)                   
  400 CONTINUE                                                          
      RETURN                                                            
      END                                                               
C     ------------------------------------------------------------------
C     K-CURVE INTERPOLATION                                             
      SUBROUTINE CURVK(ESQ,RHO,ED)                                      
\XWILSO
\XWMISC
      EI=RHO*DEL                                                        
      I=EI                                                              
C FOR SMALL RHO THE CURVE IS EXTRAPOLATED FROM THE FIRST POINT      
C USING THE LEAST SQUARES SLOPE                                     
      IF(I.EQ.0) SK=EXP(SLOPE*RHO+FLGK)                                 
C INTERPOLATION                                                     
      IF(I.GT.0.AND.I.LT.50) SK=DCV(I)+(EI-FLOAT(I))*(DCV(I+1)-DCV(I))  
C FOR LARGE RHO THE CURVE IS EXTRAPOLATED FROM THE LAST POINT       
      IF(I.GE.50) SK=DCV(50)*EXP(SLOPE*(AVR(NB)-RHO))                   
      ESQ=ED/SK                                                         
      RETURN                                                            
      END                                                               

C ------------------------------------------------------------------
C CALCULATE FINAL E-VALUES AND RESCALED F'S                         
C CREATE NEW IF REQUIRED                                      
C OUTPUT REFLEXIONS FOR MULTAN                                      
C PREPARE TABLES OF STATISTICS                                      
      SUBROUTINE ECAL(KSYS,IPLOTN, ISTATP) 
\XWMISC
\XWILSO
\XESTAT
\XLST06
\STORE
\XUNITS
\XIOBUF
      DIMENSION IX(1000),EX(1000),FX(1000)                             
      DIMENSION RHR(10),NHR(10),NU(25),STL(10),MHKL(3)
C TABLES OF THEORETICAL DISTRIBUTIONS                               
      DIMENSION AVA(10),AVC(10),AVH(10),CPH(25)
      CHARACTER*8 CBIT1(2),CBIT3(2)
      CHARACTER*3 CBIT2(2)
      DATA CBIT1/'0KL     ','H,K,2K-H'/
      DATA CBIT2/'H0L','HHL'/
      DATA CBIT3/'HK0     ','H,K,-H-K'/
      DATA AVA/0.886,1.0,1.329,2.0,3.323,6.0,0.736,1.0,2.0,2.415/       
      DATA AVC/0.798,1.0,1.596,3.0,6.383,15.0,0.968,2.0,8.0,8.691/      
      DATA AVH/0.718,1.0,1.916,4.5,12.26,37.5,1.145,3.5,26.0,26.903/    
      DATA CPH/0.368,0.463,0.526,0.574,0.612,0.643,0.670,0.694,0.715,   
     1 0.733,0.765,0.791,0.813,0.832,0.848,0.863,0.875,0.886,0.896,     
     2 0.905,0.913,0.920,0.926,0.932,0.938/                             
      DATA IOBS,IUNOBS/1H ,1HU/                                         
C SET INITIAL VALUES                                                
      DO 20 I=1,10                                                      
      RHR(I)=0.0                                                        
      NHR(I)=0                                                          
      DO 10 J=1,5                                                       
      VST(I,J)=0.0                                                      
   10 CONTINUE                                                          
   20 CONTINUE                                                          
      DO 40 I=1,5                                                       
      NST(I)=0                                                          
      DO 30 J=1,25                                                      
      ZT(J,I)=0.0                                                       
   30 CONTINUE                                                          
   40 CONTINUE                                                          
      DO 50 I=1,25                                                      
      NU(I)=0                                                           
   50 CONTINUE                                                          
      NRW=0                                                             
      LIM=1000                                                          
      NC=0                                                              
      NS=0                                                              
      NL=0                                                              
      SCF=SQRT(SC)                                                      
      RR=10.0/SQRT(RHOMAX)
     
      CALL XFAL06(0)
      ISTAT = KFNR(0)
      DO WHILE ( ISTAT .GE. 0 )
        FOB  = STORE(M6+3)            ! FO
        SIGS = STORE(M6+12)           ! SIGF
        MHKL(1) = STORE(M6)           ! H
        MHKL(2) = STORE(M6+1)         ! K
        MHKL(3) = STORE(M6+2)         ! L
        CALL FCAL2 (MHKL,FOB,IDS,EWS,RHOS)
 
        INP = 32896
C TEST FOR END OF DATA    
        D=SC*EXP(BT*RHOS) 
        MULT=IDS/10000          
        IE=(IDS-10000*MULT)/100 
        IG=IDS-10000*MULT-100*IE
C CALCULATE E                   
        CALL CURVK(ESQ,RHOS,EWS)
        ESQ=ESQ*SCAL(IG)
        E=SQRT(ESQ)    
        EWS=E          
C CALCULATE RESCALED F 
        FOB = FOB*SCF
C PACK INDICES FOR TAPE ISTAN
        INP = 65536*MHKL(1)+256*(MHKL(2)+128)+MHKL(3)+128
C SET OBS/UNOBS FLAG
        NOB=IOBS
        IF(SIGS.LT.0.0) NOB = IUNOBS
        IF(RHOS.GT.TH) GO TO 110
C STORE REFLEXIONS FOR MULTAN   
        IF(SIGS.LT.0.0) GO TO 90
        NL=NL+1              
        IF(E.GT.EN) GO TO 100
        NL=NL-1              
   90   E=E+0.2*RHOS
        IF(E.GT.ER) GO TO 110
        NS=NS+1   
  100   NC=NC+1   
        IX(NC)=INP
        EX(NC)=E  
        FX(NC)=FOB
        IF(NC.NE.LIM) GO TO 110
        CALL SORT(EX,FX,IX,1000)
        IF(MZ.GT.0) ER=AMIN1(ER,EX(1001-MZ))
        EN=AMAX1(EN,EX(MM))
        NC=MIN0(MM,NL)
        LIM=1000-MZ
C WORK OUT FINAL STATISTICS
  110   TMUL=FLOAT(MULT)
C DISTRIBUTION OF E WITH SIN(THETA)/LAMBDA
        N=MIN0(10,INT(1.0+RR*SQRT(RHOS)))
        NHR(N)=NHR(N)+MULT    
        RHR(N)=RHR(N)+ESQ*TMUL
        NZR=INT(10.0*ESQ)+1
        IF(NZR.GT.10) NZR=10+(NZR-9)/2
        EE(1)=EWS
        DO 120 J=2,6
          EE(J)=EE(J-1)*EWS
  120   CONTINUE
        EE(7)=ESQ-1.0                                                     
        EE(8)=EE(7)*EE(7)                                                 
        EE(9)=EE(8)*EE(7)                                                 
        EE(10)=ABS(EE(9))                                                 
        EE(7)=ABS(EE(7))                                                  
        DO 130 J=1,10                                                     
          EE(J)=TMUL*EE(J)                                                  
  130   CONTINUE                                                          
C ADD FUNCTIONS OF E TO APPROPRIATE ZONES                           
        IND=1                                                             
        J=MHKL(1)
        K=MHKL(2)
        L=MHKL(3)
        CALL ADD(1)                                                       
        GO TO (140,140,140,150,160,160,170,180),KSYS                      
C TRICLINIC, MONOCLINIC AND ORTHORHOMBIC                            
  140   IF(J.EQ.0) CALL ADD(3)                                            
        IF(K.EQ.0) CALL ADD(4)                                            
        IF(L.EQ.0) CALL ADD(5)                                            
        GO TO 200                                                         
C TETRAGONAL                                                        
  150   IF(J.EQ.0.OR.K.EQ.0) CALL ADD(3)                                  
        IF(IABS(J).EQ.IABS(K)) CALL ADD(4)                                
        IF(L.EQ.0) CALL ADD(5)                                            
        GO TO 200                                                         
C TRIGONAL, HEXAGONAL AND RHOMBOHEDRAL INDEXED ON HEXAGONAL AXES    
  160   IF(J.EQ.0.OR.K.EQ.0.OR.J+K.EQ.0) CALL ADD(3)                      
        IF(J.EQ.K.OR.J+2*K.EQ.0.OR.2*J+K.EQ.0) CALL ADD(4)                
        IF(L.EQ.0) CALL ADD(5)                                            
        GO TO 200                                                         
C PRIMITIVE RHOMBOHEDRAL                                            
  170   IF(J.EQ.K.OR.J.EQ.L.OR.K.EQ.L) CALL ADD(3)                        
        IF(L.EQ.2*K-J.OR.K.EQ.2*J-L.OR.J.EQ.2*L-K) CALL ADD(4)            
        IF(J+K+L.EQ.0) CALL ADD(5)                                        
        GO TO 200                                                         
C CUBIC                                                             
  180   IF(J.EQ.0.OR.K.EQ.0.OR.L.EQ.0) CALL ADD(3)                        
        IF(IABS(J).EQ.IABS(K).OR.IABS(J).EQ.IABS(L)
     1 .OR.IABS(K).EQ.IABS(L)) CALL ADD(4)                                                     
C H,H,2H IS IN TWO PRINCIPAL ZONES BUT NOT ON A PRINCIPAL AXIS      
        IF(IND.EQ.4) IND=0                                                
        IF(IABS(L).EQ.IABS(J+K).OR.IABS(K).EQ.IABS(J+L).OR.
     1  IABS(J).EQ.IABS(K+L)) CALL ADD(5)
C REFLEXIONS NOT BELONGING TO PRINCIPAL ZONES                       
  200   IF(IND.EQ.1) CALL ADD(2)                                          
C DISTRIBUTION OF E FOR COMPLETE DATA                               
        NET=MIN0(25,INT(10.0*EWS))                                      
        IF(NET.EQ.0) GO TO 220                                            
        NU(NET)=NU(NET)+1                                                 
  220   NRW=NRW+MULT                                                      

        ISTAT = KFNR(0)
      END DO


C OUTPUT STATISTICS
      RR=1.0/RR                                                         
      DO 320 I=1,10                                                     
      STL(I)=RR*FLOAT(I)                                                
      IF(NHR(I).GT.0) RHR(I)=RHR(I)/FLOAT(NHR(I))                       
      DO 310 J=1,5                                                      
      IF(NST(J).GT.0) VST(I,J)=VST(I,J)/FLOAT(NST(J))                   
  310 CONTINUE                                                          
  320 CONTINUE                                                          
      WRITE(NCWU,330) STL,RHR,NHR                                         
  330 FORMAT(///1H ,52X,16HFINAL STATISTICS//1H ,38X,                   
     1 43HDISTRIBUTION OF E**2 WITH SIN(THETA)/LAMBDA/10H SINTH/LAM,    
     2 10F10.4/1H ,3X,4HE**2,2X,10F10.4/1H ,2X,6HNUMBER,10I10)          
      WRITE(NCWU,340)                                                     
  340 FORMAT(//1H ,53X,14HAVERAGE VALUES)                               
      WRITE(NCWU,350)                                                     
  350 FORMAT(1H ,45X,12HEXPERIMENTAL,39X,11HTHEORETICAL/1H ,23X,        
     1 8HALL DATA,7X,3HHKL,44X,8HACENTRIC,5X,7HCENTRIC,                 
     2 2X,12HHYPERCENTRIC)                                              
      WRITE(NCWU,360)                                                     
  360 FORMAT(1H+,4X,7HAVERAGE)                                          
C     CAPTION ACCORDING TO CRYSTAL SYSTEM                               
      IF(KSYS.NE.7) WRITE(NCWU,370)                                       
  370 FORMAT(1H+,50X,3H0KL)                                             
      IF(KSYS.EQ.7) WRITE(NCWU,380)                                       
  380 FORMAT(1H+,47X,8HH,K,2K-H)                                        
      IF(KSYS.LE.3) WRITE(NCWU,390)                                       
  390 FORMAT(1H+,62X,3HH0L)                                             
      IF(KSYS.GE.4) WRITE(NCWU,400)                                       
  400 FORMAT(1H+,62X,3HHHL)                                             
      IF(KSYS.LE.6) WRITE(NCWU,410)                                       
  410 FORMAT(1H+,74X,3HHK0)                                             
      IF(KSYS.GE.7) WRITE(NCWU,420)                                       
  420 FORMAT(1H+,71X,8HH,K,-H-K)                                        
      WRITE(NCWU,430) ((VST(I,J),J=1,5),AVA(I),AVC(I),AVH(I),I=1,10)      
  430 FORMAT(1H ,5X,6HMOD(E),7X,5F12.3,2X,3F12.3/                       
     1 1H ,6X,4HE**2,8X,5F12.3,2X,3F12.3/                               
     2 1H ,6X,4HE**3,8X,5F12.3,2X,3F12.3/                               
     3 1H ,6X,4HE**4,8X,5F12.3,2X,3F12.3/                               
     4 1H ,6X,4HE**5,8X,5F12.3,2X,3F12.3/                               
     5 1H ,6X,4HE**6,8X,5F12.3,2X,3F12.3/                               
     6 1H ,2X,11HMOD(E**2-1),5X,5F12.3,2X,3F12.3/                       
     7 1H ,2X,11H(E**2-1)**2,5X,5F12.3,2X,3F12.3/                       
     8 1H ,2X,11H(E**2-1)**3,5X,5F12.3,2X,3F12.3/                       
     9 1H ,16H(MOD(E**2-1))**3,2X,5F12.3,2X,3F12.3)

      IF ( ISTATP .EQ. 1 ) THEN
        WRITE(CMON,'(A,F12.3)')
     1  '^^CO SET _MW_E2MIN1 TEXT ',VST(7,1)
        CALL XPRVDU(NCVDU, 1,0)
      END IF


      WRITE(NCWU,440) NST                                                 
  440 FORMAT(21H WEIGHTED SAMPLE SIZE,I10,4I12)                         
      WRITE(NCWU,450)                                                     
  450 FORMAT(//1H ,40X,40HN(Z) CUMULATIVE PROBABILITY DISTRIBUTION)     
      WRITE(NCWU,350)                                                     
      WRITE(NCWU,460)                                                     
  460 FORMAT(1H+,5X,1HZ)                                                
C     CAPTION ACCORDING TO CRYSTAL SYSTEM                               
      IF(KSYS.NE.7) WRITE(NCWU,370)                                       
      IF(KSYS.EQ.7) WRITE(NCWU,380)                                       
      IF(KSYS.LE.3) WRITE(NCWU,390)                                       
      IF(KSYS.GE.4) WRITE(NCWU,400)                                       
      IF(KSYS.LE.6) WRITE(NCWU,410)                                       
      IF(KSYS.GE.7) WRITE(NCWU,420)

      IF ( IPLOTN .EQ. 1 ) THEN
        WRITE(CMON,'(A/A/A/A/3A/3A/3A/A/A/A)')
     1  '^^PL PLOTDATA _NZDIST SCATTER ATTACH _VNZDIST KEY',
     1  '^^PL XAXIS TITLE Z',
     1  '^^PL NSERIES=7 LENGTH=25 YAXIS TITLE N(Z)',
     1  '^^PL SERIES 1 SERIESNAME ''All Data''',
     1  '^^PL SERIES 2 SERIESNAME ''',
     1  CBIT1(MAX(1,KSYS-5)),'''',
     1  '^^PL SERIES 3 SERIESNAME ''',
     1  CBIT2(MIN(2,MAX(1,KSYS-2))),'''',
     1  '^^PL SERIES 4 SERIESNAME ''',
     1  CBIT3(MAX(1,KSYS-5)),'''',
     1  '^^PL SERIES 5 SERIESNAME ''Acentric'' TYPE LINE',
     1  '^^PL SERIES 6 SERIESNAME ''Centric'' TYPE LINE',
     1  '^^PL SERIES 7 SERIESNAME ''Hypercentric'' TYPE LINE'
        CALL XPRVDU(NCVDU, 10,0)
      END IF
      

      DO 500 I=1,25                                                     
      DO 470 J=1,5                                                      
      IF(NST(J).GT.0) ZT(I,J)=ZT(I,J)/FLOAT(NST(J))                     
      IF(I.NE.1) ZT(I,J)=ZT(I,J)+ZT(I-1,J)                              
  470 CONTINUE                                                          
C     THEORETICAL DISTRIBUTIONS                                         
      ZZ=0.1*FLOAT(I)                                                   
      IF(I.GT.10) ZZ=2.0*ZZ-1.0                                         
C     ACENTRIC                                                          
      CPA=1.0-EXP(-ZZ)                                                  
C     CENTRIC                                                           
      XX=SQRT(0.5*ZZ)                                                   
      T=1.0/(1.0+0.47047*XX)                                            
      CPC=1.0-((0.74786*T-0.09588)*T+0.34802)*T*EXP(-0.5*ZZ)            
      WRITE(NCWU,480) ZZ,(ZT(I,J),J=1,5),CPA,CPC,CPH(I)                   
  480 FORMAT(1H ,F7.1,11X,5F12.3,2X,3F12.3)

      IF ( IPLOTN .EQ. 1 ) THEN
        WRITE(CMON,'(A,4(1X,F3.1,1X,F8.3)/A,3(1X,F3.1,1X,F8.3))')
     1 '^^PL DATA ', ZZ, ZT(I,1), ZZ, ZT(I,3), ZZ, ZT(I,4), ZZ, ZT(I,5),
     3 '^^PL ',      ZZ, CPA,     ZZ, CPC,     ZZ, CPH(I)
       CALL XPRVDU(NCVDU, 2,0)
      END IF
      
  500 CONTINUE
      IF ( IPLOTN .EQ. 1 ) THEN
        WRITE(CMON,'(A/A)')'^^PL SHOW','^^CR'
        CALL XPRVDU(NCVDU, 2,0)
      END IF

      WRITE(NCWU,440) NST                                                 
      DO 510 I=1,24                                                     
      J=25-I                                                            
      NU(J)=NU(J)+NU(J+1)                                               
  510 CONTINUE                                                          
      WRITE(NCWU,520)                                                     
  520 FORMAT(/1H ,38X,44HDISTRIBUTION OF E - NUMBER OF E'S .GT. LIMIT)  
      DO 540 I=1,25                                                     
      AVR(I)=0.1*FLOAT(I)                                               
  540 CONTINUE                                                          
      WRITE(NCWU,560) (AVR(I),I=7,25),(NU(I),I=7,25)                      
  560 FORMAT(1H ,2X,3HE  ,19F6.1/1H ,1X,4HNO. ,19I6)                    
C     OUTPUT REFLEXIONS FOR MULTAN                                      
      MR=1000                                                           
      IF(LIM.EQ.1000) MR=NC                                             
      CALL SORT(EX,FX,IX,MR)                                            
      MM=MIN0(MM,NL)                                                    
      WRITE(NCWU,580) MM                                                  
  580 FORMAT(///1H ,I6,41H  LARGEST E-VALUES WRITTEN TO OUTPUT FILE)    
      CALL OUTPUT(EX,FX,IX,0,MM)                                        
      MZ=MIN0(MZ,NS)                                                    
      MS=MR-MZ                                                          
      WRITE(NCWU,600) MZ                                                  
  600 FORMAT(1H ,I6,42H  SMALLEST E-VALUES WRITTEN TO OUTPUT FILE)      
      CALL OUTPUT(EX,FX,IX,MS,MR)                                       
  630 RETURN                                                            
      END                                                               
C     ------------------------------------------------------------------
C     SUMS FOR REFLEXION IN ZONE N                                      
      SUBROUTINE ADD(N)                                                 
\XESTAT
      IS=1                                                              
      NT=N                                                              
      IF(N.LE.2.OR.IND.LE.1) GO TO 20                                   
C     REFLEXION IS ON PRINCIPAL AXIS - THEREFORE IGNORE IT              
      NT=IND                                                            
      IS=-1                                                             
   20 S=FLOAT(IS)                                                       
      DO 30 I=1,10                                                      
      VST(I,NT)=VST(I,NT)+S*EE(I)                                       
   30 CONTINUE                                                          
      NST(NT)=NST(NT)+IS*MULT                                           
      IF(NZR.LE.25) ZT(NZR,NT)=ZT(NZR,NT)+S*TMUL                        
      IND=N                                                             
      RETURN                                                            
      END                                                               
C     ------------------------------------------------------------------
C     SORT ON A                                                         
      SUBROUTINE SORT(A,B,IX,N)                                         
      DIMENSION A(N),B(N),IX(N)                                         
      INT=2                                                             
   10 INT=2*INT                                                         
      IF(INT.LT.N) GO TO 10                                             
      INT=MIN0(N,(3*INT)/4-1)                                           
   20 INT=INT/2                                                         
      IFIN=N-INT                                                        
      DO 70 II=1,IFIN                                                   
      I=II                                                              
      J=I+INT                                                           
      IF(A(I).GE.A(J)) GO TO 70                                         
      T=A(J)                                                            
      X=B(J)                                                            
      L=IX(J)                                                           
   40 A(J)=A(I)                                                         
      B(J)=B(I)                                                         
      IX(J)=IX(I)                                                       
      J=I                                                               
      I=I-INT                                                           
      IF(I.LE.0) GO TO 60                                               
      IF(A(I).LT.T) GO TO 40                                            
   60 A(J)=T                                                            
      B(J)=X                                                            
      IX(J)=L                                                           
   70 CONTINUE                                                          
      IF(INT.GT.1) GO TO 20                                             
      RETURN                                                            
      END                                                               
C     ------------------------------------------------------------------
C     PRINT AND OUTPUT TO FILE FOR REFLEXIONS TO BE USED IN MULTAN      
      SUBROUTINE OUTPUT(EX,FX,IX,N,M)                                   
\XUNITS
      DIMENSION EX(1000),FX(1000),IX(1000)                              
      DIMENSION J(6),K(6),L(6),E(6),KODE(6)                             
      IF(N.EQ.M) GO TO 60                                               
      WRITE(NCWU,10)                                                      
   10 FORMAT(6(1X,4HCODE,9H  H  K  L,3X,1HE,2X))                        
      NA=N+1                                                            
      KK=0                                                              
      DO 50 JJ=NA,M                                                     
      I=JJ                                                              
      IF(N.NE.0) I=M-JJ+NA                                              
      KK=KK+1                                                           
      IND=IX(I)                                                         
      J(KK)=IND/65536                                                   
      IF(IND.LT.0) J(KK)=J(KK)-1                                        
      IND=IND-65536*J(KK)                                               
      K(KK)=IND/256                                                     
      L(KK)=IND-256*K(KK)-128                                           
      K(KK)=K(KK)-128                                                   
      E(KK)=EX(I)                                                       
      KODE(KK)=JJ-N                                                     
      IF(KK.NE.6) GO TO 50                                              
      WRITE(NCWU,30) (KODE(II),J(II),K(II),L(II),E(II),II=1,6)            
   30 FORMAT(6(I5,3I3,F6.3))                                            
      KK=0                                                              
   50 CONTINUE                                                          
      IF(KK.EQ.0) GO TO 60                                              
      WRITE(NCWU,30) (KODE(II),J(II),K(II),L(II),E(II),II=1,KK)           
   60 KK=0                                                              
      D=-1.0                                                            
      RETURN                                                            
      END                                                               
