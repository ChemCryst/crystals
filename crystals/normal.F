C $Log: normal.F,v $ 
C Revision 1.26  2012/08/30 09:38:52  djw
C Use SAFESET for _MW_E2MIN* for passing values to gui
C
C Revision 1.25  2012/05/11 12:42:52  rich
C Fix N(Z) graph when L28 sin(t)/l filter in place. Fix E2-1 value in tabbed analyses.
C
C Revision 1.24  2012/02/21 18:28:50  djw
C Sometimes the Fc Wilson plot was just a vertical line.
C Logical E5 used for two different purposes. Introduce new temporary logical E5B.
C
C Revision 1.23  2012/02/21 14:47:35  djw
C In Wilson plot, add comment tat Rho is Sin(theta)/lambda)^2
C
C Revision 1.22  2011/05/13 11:16:51  djw
C Calls to Kallow now return a key to the test which failed and a value to indicate if it was Max or Min. The argument of KALLOW must be a variable
C
C LOGGING STARTED APRIL 2011
C
CODE FOR MLTNRM
      SUBROUTINE MLTNRM
C VERSION    JAN    1980          UNIVERSITY OF YORK
C HACKED TO BITS 22 YEARS LATER  by  RICHARD COOPER
C FIDDLED TO HANDLE HIGH RESOLUTION DATA AND FILTERED
C DATA BY DJW 2016
C
C      IWEIGT 0 = NOTHING
C             1 = UPDATE WEIGHTS 


      INCLUDE 'XWISYM.INC'
      INCLUDE 'XWSCAT.INC'
      INCLUDE 'XWMISC.INC'
      INCLUDE 'XWILSO.INC'
      INCLUDE 'XESTAT.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST03.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST29.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'

      DATA ICOMSZ / 6 /
      DATA IVERSN /100/

C -- SET THE TIMING AND READ THE CONSTANTS
C -- SET UP INITIAL VALUES, READ PROGRAM PARAMETERS                    

      CALL XTIME1 ( 2 )
      CALL XCSAE
C----- SET REFLECTION LIST TYPE
      IULN6 = 6
C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
      ICOMBF = KSTALL( ICOMSZ )
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910

      IF (KEXIST(3).LE.0) THEN
         WRITE(CMON,'(A)')'No list 3 (scattering factors) available'
         CALL XPRVDU(NCVDU,1,0)
         GOTO 9900
      END IF


      IF (KEXIST(5).LE.0 .and. (issrat.eq.1)) THEN
C            RESET RATIO FLAG TO Io
             WRITE(CMON,'(A)')'No list 5 (scale factors) available'
             CALL XPRVDU(NCVDU,1,0)
             write(cmon,'(a)')
     1      'IRATIO reset to Io because scale is not available'
             CALL XPRVDU(NCVDU, 1,0)
             ISSRAT = 0
      ELSE
        IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      END IF


      IF (KEXIST(6).LE.0) THEN
         WRITE(CMON,'(A)')'No list 6 (observations) available'
         CALL XPRVDU(NCVDU,1,0)
         GOTO 9900
      END IF
      IF (KEXIST(29).LE.0) THEN
        WRITE(CMON,'(A)')'No list 29 (for unit cell contents) available'
        CALL XPRVDU(NCVDU,1,0)
        GOTO 9900
      END IF
      IF (KEXIST(1).LE.0) THEN
        WRITE(CMON,'(A)')'No list 1 (for unit cell) available'
        CALL XPRVDU(NCVDU,1,0)
        GOTO 9900
      END IF


      IPLOTW = ISTORE(ICOMBF)
      IPLOTN = ISTORE(ICOMBF+1)
      ISTATP = ISTORE(ICOMBF+2)
      IL28FL = ISTORE(ICOMBF+3)
      IWEIGT = ISTORE(ICOMBF+4)
      EVALS=.FALSE.
      EPUNCH=.FALSE.
      IF(ISTORE(ICOMBF+5).EQ.1) EVALS=.TRUE.
      IF(ISTORE(ICOMBF+5).EQ.2) THEN
            EPUNCH=.TRUE.
            EVALS=.TRUE.
      ENDIF
C
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      CALL XFAL06(IULN6,0)

      NREF=0                                                            
      RHOMAX=0.0                                                        
      RHOMIN=100000.
      TH=1.0                                                            
      EN=1.2                                                            
      ER=0.3                                                            
      MZ=100                                                            
      MM=0                                                              
      NTOT=0                                                            
      NB=0                                                              
      BT=0.0                                                            
      DO I=1,8                                                          
        SCAL(I)=0.0                                                     
      END DO

      IND=1                                                             

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

      CALL XFAL03
      CALL XFAL29

      ICOMBF = KSTALL( ICOMSZ )

      DO M3 = L3, L3+(N3-1)*MD3, MD3
        STORE(M3+1) = 0.0 !Wipe out F' (list is not saved later)
        STORE(M3+2) = 0.0 !Wipe out F'' (list is not saved later)
      END DO

C Into L3, put number of atoms in cell.
      NAT=0                                                             
      DO M29=L29,L29+(N29-1)*MD29,MD29
         DO M3 = L3, L3+(N3-1)*MD3, MD3
           IF (ISTORE(M29) .EQ. ISTORE(M3)) THEN
             STORE(M3+1) = T2*STORE(M29+4) ! Overwrite F' with atoms in cell
             STORE(M3+2) = NINT ( STORE(M3+3) + STORE(M3+5)
     1                + STORE(M3+7) + STORE(M3+9) + STORE(M3+11))
             IF ( STORE(M3+2) .NE. 1 ) NAT = NAT + STORE(M3+1)
             EXIT
           END IF
         END DO
      END DO

      IF(EVALS)
     1 WRITE(NCWU,2820) (ISTORE(M3),STORE(M3+1),STORE(M3+2),
     1                  (STORE(M3+J),J=3,11),M3=L3,L3+(N3-1)*MD3,MD3)
 2820   FORMAT(//1H ,51X,18HUNIT CELL CONTENTS//                          
     1 1H ,4HATOM,4X,14HNUMBER IN CELL,4X,13HATOMIC NUMBER,4X,          
     2 27HSCATTERING FACTOR CONSTANTS,3X,                               
     3 39H(f = SUM(n=1,4)[a(n)*EXP(-b(n)*RHO)]+c)/
     4 (1H ,1X,A4,F12.0,F17.0,9F7.3))                                     
C CALCULATE WILSON (GIW) SCATTERING FACTORS 
      DO I=1,175
         T=0.01*FLOAT(I-1)                                                 
         TT=T*T                                                            
         GIW(I)=0.0                                                        
         DO M3 = L3, L3+(N3-1)*MD3, MD3
            FZ =   STORE(M3+3) * EXP( -STORE(M3+4) * TT )
     1           + STORE(M3+5) * EXP( -STORE(M3+6) * TT )
     1           + STORE(M3+7) * EXP( -STORE(M3+8) * TT )
     1           + STORE(M3+9) * EXP( -STORE(M3+10) * TT )
     1           + STORE(M3+11)
            GIW(I)=GIW(I)+FZ*FZ*STORE(M3+1)
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
       IF(EVALS)
     1  WRITE(NCWU,380) MM,MZ
      endif

380   FORMAT(1H ,27X,22HOUTPUT FOR MULTAN  -  ,I5,13H  LARGEST E'S,3X,
     1 3HAND,I5,14H  SMALLEST E'S)                                      

C READ REFLEXION DATA FROM A CRYSTALS SHELX FORMAT FILE
      CALL CARDIN ( IL28FL )

      NB=8.0*ALOG10(0.05*FLOAT(MAX0(NREF,100))+0.5)
C MAXIMUM OF 30 POINTS ON WILSON PLOT
      IF(NB.GT.30) NB=30                                            
      IF(NREF.LT.100) THEN
       write(cmon,'(a,i5,a)') '{I',NREF,
     1 ' reflections is too few for a reliable Wilson Plot'
         call xprvdu(ncvdu,1,0)
      ENDIF    
      WRITE(NCWU,440) NREF,RHOMAX,NB                                      
440   FORMAT(23H NUMBER OF REFLEXIONS =,I6,8X,                          
     1 32HMAXIMUM (SIN(THETA)/LAMBDA)**2 =,F7.4,8X,                     
     2 33HNUMBER OF POINTS ON WILSON PLOT =,I3)                         


C OBTAIN SUMS FOR WILSON PLOT AND FIT LEAST SQUARES STRAIGHT LINE
      CALL WILSUM(PTS,ISTATP,IL28FL)   


C PLOT WILSON CURVE AND LEAST SQUARES STRAIGHT LINE
      CALL GRAPH80(0,IPLOTW) 
  450 BT=2.0*BT                                                         

C CALCULATE SCALE FACTORS FOR APPROPRIATE REFLEXION GROUPS
      CALL RESCA(KSYS,IL28FL) 

C CALCULATE FINAL E'S AND OUTPUT REFLEXION STATISTICS
      CALL ECAL(KSYS,IPLOTN, ISTATP, IL28FL, IWEIGT)

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


CODE FOR INCELL
      SUBROUTINE INCELL                                                 
C ------------------------------------------------------------------
C INPUT UNIT CELL PARAMETERS AND CALCULATE RECIPROCAL PARAMETERS    
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XWMISC.INC'
      INCLUDE 'XWILSO.INC'
C
      IF(EVALS)
     1 WRITE(NCWU,20) (CX(I),I=1,6)                                        
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
      IF(EVALS)
     1 WRITE(NCWU,50) P                                                    
   50 FORMAT(6H RHO =,F9.6,9H * H**2 +,F9.6,9H * K**2 +,F9.6,9H * L**2 +
     1 ,F9.6,10H * H * K +,F9.6,10H * H * L +,F9.6,8H * K * L)          
      RETURN                                                            
      END                                                               
C
CODE FOR VOL
      SUBROUTINE VOL(CX,V)                                              
C     SINE AND COSINE OF CELL ANGLES PLUS TRIGONOMETRIC PART OF VOLUME  
      INCLUDE 'XCONST.INC'
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

C
CODE FOR INSYM
      SUBROUTINE INSYM    
C READ GENERAL EQUIVALENT POSITIONS AS IN INTERNATIONAL TABLES AND  
C DETERMINE LATTICE MULTIPLICITY (PTS) AND CRYSTAL SYSTEM (KSYS)    
      INCLUDE 'XWISYM.INC'
      INCLUDE 'XWILSO.INC'
      DIMENSION KX(15),LTC(7),ICAP(2),LINE(21)
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XUNITS.INC'

      DATA KX/1H1,1H2,1H3,1H4,1H5,1H6,1HX,1HY,1HZ,1H ,1H,,1H+,1H-,1H/,
     1 1H*/                                                             
      DATA LTC/1HP,1HA,1HB,1HC,1HI,1HF,1HR/,ICAP/3HNON,3H   /           
      IF(EVALS)
     1 WRITE(NCWU,104) ICAP(ICENT+1),N2,LATT
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
  500 continue
      RETURN                                                            
      END                                                               
C
CODE FOR CARDIN
      SUBROUTINE CARDIN ( IL28FL )
C READ REFLEXIONS
C
C IL28FL: 0 - Use all reflections
C         1 - Use reflections allowed by List 28.
C
      INCLUDE 'XWMISC.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'STORE.INC'
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      CALL XFAL06(6, 0)
      DO WHILE ( KLDRNR(0) .GE. 0 )
       IF ( ( KALLOW(IALLOW) .GE. 0 ) .OR. ( IL28FL .EQ. 0 ) ) THEN
        IH = STORE(M6)               ! H
        IK = STORE(M6+1)             ! K
        IL = STORE(M6+2)             ! L
        NREF=NREF+1                                                       
        RHO   =P(1)*FLOAT(IH*IH)+P(2)*FLOAT(IK*IK)+P(3)*FLOAT(IL*IL)
     3        +P(4)*FLOAT(IH*IK)+P(5)*FLOAT(IH*IL)+P(6)*FLOAT(IK*IL)
        RHOMAX=AMAX1(RHOMAX,RHO)
        RHOMIN=AMIN1(RHOMIN,RHO)
       END IF
      END DO
      RETURN                                                            
      END
C
C
CODE FOR FCAL2
      SUBROUTINE FCAL2 (MHKL,FOB,ID,EW,RHO)
C CALCULATE RHO, EPSILON, MULTIPLICITY AND SCATTERING FACTOR        
C FOR EACH REFLEXION
      DIMENSION MHKL(3),I2(3)
      INCLUDE 'XWISYM.INC'
      INCLUDE 'XWSCAT.INC'
      INCLUDE 'XWMISC.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'QSTORE.INC'
      INCLUDE 'XLST02.INC'
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
        IND  = MAX0(3,INT(SINTH+1.5))                                        
        FRAC = SINTH-FLOAT(IND-1)                                           
        BF   = 0.5*(GIW(IND+1)-GIW(IND-1))                                    
        AF   = BF+GIW(IND-1)-GIW(IND)                                         
        FORM = AF*FRAC*FRAC+BF*FRAC+GIW(IND)                                
C 'WILSON' STRUCTURE FACTOR                                         
        EW   = FF/(FORM*EPS)                                               
      RETURN                                                            
      END                                                               
C
C
CODE FOR WILSUM
      SUBROUTINE WILSUM(PTS,ISTATP,IL28FL)
C     LEAST SQUARES PLOT, INCLUDING SUMMATION OVER NB RANGES OF RHO     
C
C IL28FL: 0 - Use all reflections
C         1 - Use reflections allowed by L28.
C
C ISTATP: 0 - No GUI output
C         1 - Set GUI elements for scale and B-factor
C
C
      INCLUDE 'XWMISC.INC'
      INCLUDE 'XWILSO.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XLST30.INC'
      INCLUDE 'ICOM30.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QLST30.INC'

      LOGICAL E5B      
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
      SCALE = 1.0
      E5 = .TRUE.         !true if LIST 5 exists
      E5B = .FALSE.       !true if Fcal data exists
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0)  THEN
       IF (KEXIST(5) .GT. 0) THEN
          CALL XFAL05
       ELSE
          E5 = .FALSE.
       ENDIF
      ENDIF
      IF(E5) SCALE = STORE(L5O)
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      CALL XFAL06(6, 0)
      DO WHILE ( KLDRNR(0) .GE. 0 )
       IF ( ( KALLOW(IALLOW) .GE. 0 ) .OR. ( IL28FL .EQ. 0 ) ) THEN
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
cdjwfeb2012            E5 = .FALSE. !Can't do calculated line.
            E5B = .FALSE.           !Need temporary value
          ELSE
C WEIGHTED SUMS                                                     
C  WILSON  
            E5B = .TRUE.                                                          
            SWC(N)=SWC(N)+EWS*TMUL                                            
C  INTENSITY                                                         
            SIC(N)=SIC(N)+TMUL*FCA*FCA/(EPS*PTS)
          END IF
        ENDIF
       ENDIF
      END DO



  250 DO I=1,NB
C SMOOTH CURVE BY ADDING ADJACENT RANGES                            
        NUMBER=NUMBER+NSUM(I)
        NSUM(I)=NSUM(I)+NSUM(I+1)
        SW(I)=SW(I)+SW(I+1)
        SR(I)=SR(I)+SR(I+1)
        SI(I)=SI(I)+SI(I+1)
        IF ( E5B ) THEN
          SWC(I)=SWC(I)+SWC(I+1)
          SIC(I)=SIC(I)+SIC(I+1)
        END IF

C CALCULATE WEIGHTED AVERAGES AND LOGS
        WT=FLOAT(NSUM(I))                                                 
        DIV=1.0/AMAX1(1.0,WT)                                             
        AVI=SI(I)*DIV                                                     
        AVR(I)=SR(I)*DIV                                                  

        FLGW(I)          =ALOG(MAX(SW(I) *DIV,0.00000000001))
CDJWFEB2012        IF ( E5) FLGWC(I)=ALOG(MAX(SWC(I)*DIV,0.00000000001))
        IF ( E5B) FLGWC(I)=ALOG(MAX(SWC(I)*DIV,0.00000000001))


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
      SCC=SQRT(1/SC)                  !CRYSTALS Fo  SCALE FACTOR                                                    
      BT=-0.5*SLOPE                                                     
      UT = BT/(8*PI*PI)
      WRITE(NCWU,340) SLOPE,FLGK,BT,SC                                    
  340 FORMAT(1H ,7HSLOPE =,F8.4,4X,11HINTERCEPT =,F8.4,4X,              
     1/25H TEMPERATURE FACTOR (B) =,F8.4,4X,7HSCALE =,F12.4,             
     2 4X,37HF(ABSOLUTE)**2 = SCALE*F(OBSERVED)**2)

      IF (ISTATP .EQ. 1) THEN
CDJW-2018 OUTPUT U TO GRAPHICS
        WRITE(CMON,'(A,F8.4,A,F12.4)')
     1  '^^CO SET _MW_BFACTR TEXT ',UT,
     1  ' SET _MW_BSCALE TEXT ',SCC
        CALL XPRVDU(NCVDU, 1,0)
      END IF

      IF (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) . LT. 0) CALL XFAL30
         STORE(L30DR+6) = BT
         STORE(L30DR+7) = SC
      CALL XWLSTD ( 30, ICOM30, IDIM30, -1, -1)
      RETURN                                                            
      END                                                               
C
C
CODE FOR GRAPH80
      SUBROUTINE GRAPH80(NGP,IPLOTW)
C     LINE PRINTER PLOT AT 50 VALUES OF RHO                             
      INCLUDE 'XWMISC.INC'
      INCLUDE 'XWILSO.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XUNITS.INC'

      DIMENSION FH(6),RH(6),M(117),R(4),AD(4),AW(4),AWC(4)                     
      DATA IST,ISP,ICW,ICD/1H*,1H ,1HW,1HD/                             
C     DETERMINE RANGES OF LOGS                                          
cdjwfeb08
      if (iplotw .eq.1) then
       write(ncpu,'(a)')'Wilson Plot'
       write(ncpu,123)
123   format(10x,'s^2',5x,'Best Line',3x,'Obs Wilson'2x,'Calc Wilson')
      endif
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
     1S STRAIGHT LINE/1H ,15X,20X/1H ,40X,20HLN(F(obs)**2/SIGfSQ)/1H , 
     2 F18.3,5F20.3/1H ,F12.3,2X,1H-,5(1HI,19(1H-)),2HI-)               
      J=1                                                               
      IR=2

      IF ( IPLOTW .EQ. 1 ) THEN
        WRITE(CMON,'(A,6(/A))')
     1  '^^PL PLOTDATA _WILSON SCATTER ATTACH _VWILSON KEY',
     1 '^^PL XAXIS TITLE "ln(<Fo\**2>(\rho)/<\SUMf\**2>(\rho))"',
     1  '^^PL NSERIES=3 LENGTH=50 YAXIS TITLE ', 
     1  '^^PL "\rho (= sin\**2\theta/\lambda\**2)"',
     1  '^^PL SERIES 1 SERIESNAME ''Straight Line'' TYPE LINE',
     1  '^^PL SERIES 2 SERIESNAME ''Wilson (Fobs)''',
     1  '^^PL SERIES 3 SERIESNAME ''Wilson (Fcalc)'''
        CALL XPRVDU(NCVDU, 7,0)
      END IF

      XMIN = +1000.
      XMAX = -1000.

C NOTE. FOR THE PRINTER, EACH LINE IS FILLED WITH SPACES
C AND THEN TEXT ADDED. THE FORMAT DESCRIPTOR $ INHIBITS
C LINE FEEDS

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


C  TRY SOLVING FOR THE QUARTIC. IF FAILS, FILL OUTPUT WITH ZERO
           K=NSOLVE(R,FLGW(J-1),FLGW(J),FLGW(J+1),FLGW(J+2),AW)
           IF (K.LE.0) CALL XFILL(0.0,AW,4)
           IF ( E5 ) THEN
           K=NSOLVE(R,FLGWC(J-1),FLGWC(J),FLGWC(J+1),FLGWC(J+2),AWC)
           IF (K.LE.0) CALL XFILL(0.0,AWC,4)
           END IF


C WILSON PLOT INTERPOLATION
  130     CONTINUE

          WVAL = AW(4)+ Q * ( AW(3) + Q * ( AW(2) + Q * AW(1) ) )
          IF ( E5 ) THEN
            WCVAL = AWC(4) + Q * ( AWC(3) + Q * (AWC(2) + Q * AWC(1)) )
          ELSE
            WCVAL = 0.0
          END IF
          IL=100.0*(WVAL-FN)/FD+16.5
          IF(IL.GT.117) IL=117                                              
          IF(IL.LT.1) IL=1 
          IF(WVAL.NE. ZERO) M(IL)=ICW
C STORE K-CURVE                                                     
          DCV(I)=EXP(AW(4)+Q*(AW(3)+Q*(AW(2)+Q*AW(1))))
          IF ( IPLOTW .EQ. 1 ) THEN
            WRITE(CMON,'(A,6F10.5)')
     1      '^^PL DATA ', SVAL , 0.02*FLOAT(I-1)*RX, WVAL,
     2      0.02*FLOAT(I-1)*RX, WCVAL , 0.02*FLOAT(I-1)*RX
            CALL XPRVDU(NCVDU, 1,0)
          END IF
cdjwfeb08
            write(ncpu,'(i4,4f12.4)') i, 0.02*FLOAT(I-1)*RX, sval,
     1      wval,wcval



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
C
C
CODE FOR NSOLVE
      FUNCTION NSOLVE(R,Y1,Y2,Y3,Y4,A)                                 
C FIT CURVE TO Y = A(1) * RHO**3 + A(2) * RHO**2 + A(3) * RHO + A(4)
C  RETURNS -1 IF ANY DENOMINATIOR LE ZEROSQ
C  (SOME TERMS ARE LESS THAN ZERO - POTENTIAL INSTABILITY?)
      INCLUDE 'XCONST.INC'
      DIMENSION R(4),A(4)  ,D(6)
      NSOLVE = -1 
      D(1)=ABS(R(2)-R(1))
      D(2)=ABS(R(3)-R(1))
      D(3)=ABS(R(4)-R(1))
      D(4)=ABS(R(2)-R(4))
      IF(D(1).LE. ZEROSQ) GOTO 100                                     
      IF(D(2).LE. ZEROSQ) GOTO 100                                     
      IF(D(3).LE. ZEROSQ) GOTO 100                                     
      IF(D(4).LE. ZEROSQ) GOTO 100                                     
      B2=R(4)*(R(4)+R(1))                                               
      B1=(Y4-Y1)/(R(4)-R(1))                                            
      C31=(Y2-Y1)/(R(2)-R(1))-B1                                        
      C32=(Y3-Y1)/(R(3)-R(1))-B1                                        
      C11=R(2)*(R(2)+R(1))-B2                                           
      C12=R(3)*(R(3)+R(1))-B2                                           
      C21=R(2)-R(4)                                                     
      C22=R(3)-R(4)  
      D(5)=(C22*C11-C12*C21)
      D(6)=C21
      IF(ABS(D(5)).LE. ZEROSQ) GOTO 100                                     
      IF(ABS(D(6)).LE. ZEROSQ) GOTO 100
      A(1)=(C31*C22-C32*C21)/D(5)                          
      A(2)=(C31-C11*A(1))/C21                                           
      A(3)=B1-(R(4)*R(4)+R(1)*R(1)+R(4)*R(1))*A(1)-(R(4)+R(1))*A(2)     
      A(4)=Y1-R(1)*(A(3)+R(1)*(A(2)+R(1)*A(1)))                         
      NSOLVE = 1
      RETURN 
100   CONTINUE
      RETURN                                                           
      END                                                               
C
C
CODE FOR RESCA
      SUBROUTINE RESCA(KSYS,IL28FL)
C INDEX GROUP RESCALING                                             
C
C IL28FL: 0 - Use all reflections
C         1 - Use reflections allowed by L28.
C

      INCLUDE 'XWMISC.INC'
      INCLUDE 'XWILSO.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'

      DIMENSION NG(8),SCS(8),MHKL(3)
      TOT=0.0                                                           
      NW=0                                                              
      DO I=1,8                                                       
        SCS(I)=0.0                                                        
        NG(I)=0
      END DO

      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      CALL XFAL06(6, 0)
      DO WHILE ( KLDRNR(0) .GE. 0 )
       IF ( ( KALLOW(IALLOW) .GE. 0 ) .OR. ( IL28FL .EQ. 0 ) ) THEN
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
       END IF
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
C 
C
CODE FOR CURVK
      SUBROUTINE CURVK(ESQ,RHO,ED)                                      
C     K-CURVE INTERPOLATION                                             
      INCLUDE 'XWILSO.INC'
      INCLUDE 'XWMISC.INC'
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
C
C
CODE FOR ECAL
      SUBROUTINE ECAL(KSYS,IPLOTN, ISTATP, IL28FL, IWEIGT)
C
C IL28FL: 0 - Use all reflections
C         1 - Use reflections allowed by L28
C IWEIGT: 0 - DO NOTHING
C         1 - UPDATE WEIGHTS
C
C ------------------------------------------------------------------
C CALCULATE FINAL E-VALUES AND RESCALED F'S                         
C CREATE NEW IF REQUIRED                                      
C OUTPUT REFLEXIONS FOR MULTAN                                      
C PREPARE TABLES OF STATISTICS  

      DIMENSION  KDEV(4) 
                                    
      INCLUDE 'UFILE.INC'
      INCLUDE 'ISTORE.INC'
      INCLUDE 'XWMISC.INC'
      INCLUDE 'XWILSO.INC'
      INCLUDE 'XESTAT.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
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
      CALL XRSL
      CALL XCSAE
      IF(EPUNCH) THEN
C      - OPEN E-VALUE OUTPUT ON FRN1
        CALL XMOVEI (KEYFIL(1,23),KDEV,4)
        CALL XRDOPN (6,KDEV,'E-VALUES.HKL',12)
        WRITE(NCFPU1,'(A)') ' h,k,l,  Scaled Fobs, E-value, Rho-sq'
      ENDIF
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
C     
CDJW0904
      EMAX = 4
      RMAX = 0.4
      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (IWEIGT .EQ. 1) THEN
        CALL XFAL06(6, 1)
        CALL XIRTAC(5) ! CLEAR THE ACCUMULATION AREA FOR THE WEIGHT
      ELSE
        CALL XFAL06(6, 0)
      ENDIF
      DO WHILE ( KLDRNR(0) .GE. 0 )
       IF ( ( KALLOW(IALLOW) .GE. 0 ) .OR. ( IL28FL .EQ. 0 ) ) THEN
        FOB  = STORE(M6+3)            ! FO
        SIGS = STORE(M6+12)           ! SIGF
        MHKL(1) = STORE(M6)           ! H
        MHKL(2) = STORE(M6+1)         ! K
        MHKL(3) = STORE(M6+2)         ! L
        CALL FCAL2 (MHKL,FOB,IDS,EWS,RHOS)
C
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
        IF(EPUNCH)
     1  WRITE(NCFPU1,'(3I4,3F8.3)') MHKL, FOB, E, rhos
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
        IF(NET.LE.0) GO TO 220                                            
        NU(NET)=NU(NET)+1                                                 
  220   NRW=NRW+MULT                                                      
CDJW0904
        IF (IWEIGT .EQ. 1) then
C        CALCULATE WEIGHT MODIFIER
         EDJW = MIN (EWS, EMAX)
         RDJW = MIN (RHOS, RMAX)
         W =-1.*(1.-2.*EDJW/EMAX)*(2.*RDJW/RMAX-1.)
         W = SQRT (2.+MAX(-2.,W))
         STORE(M6+4) = W * STORE(M6+4)
         I = 1
         CALL XSLR(I)
         CALL XACRT(5)
        ENDIF
       END IF
      END DO
CDJW0904
      CALL XCRD(5)
      IF (IWEIGT .EQ. 1) CALL XERT(6)
C
C OUTPUT STATISTICS
      RR=1.0/RR                                                         
      DO 320 I=1,10                                                     
      STL(I)=RR*FLOAT(I)                                                
      IF(NHR(I).GT.0) RHR(I)=RHR(I)/FLOAT(NHR(I))                       
      DO 310 J=1,5                                                      
      IF(NST(J).GT.0) VST(I,J)=VST(I,J)/FLOAT(NST(J))                   
  310 CONTINUE                                                          
  320 CONTINUE             
c      IF(EVALS) then                                             
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
c      endif
      IF ( ISTATP .EQ. 1 ) THEN
        WRITE(CMON,'(A,F12.3,A)')
     1  '^^CO SAFESET [ _MW_E2MIN1 TEXT ',VST(7,1), ' ]'
        CALL XPRVDU(NCVDU, 1,0)
        WRITE(CMON,'(A,F12.3,A)')
     1  '^^CO SAFESET [ _MW_E2MIN2 TEXT ',VST(7,1), ' ]'
        CALL XPRVDU(NCVDU, 1,0)
      END IF

c      if(evals) then
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
c      endif
      IF ( IPLOTN .EQ. 1 ) THEN
        WRITE(CMON,'(A/A/A/A/3A/3A/3A/A/A/A)')
     1  '^^PL PLOTDATA _NZDIST SCATTER ATTACH _VNZDIST KEY',
     1  '^^PL XAXIS TITLE Z',
     1  '^^PL NSERIES=7 LENGTH=25 YAXIS TITLE N(Z)',
     1  '^^PL SERIES 1 SERIESNAME ''All Data'' TYPE LINE',
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
c      if(evals)
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
      IF(EVALS)
     1 WRITE(NCWU,580) MM                                                  
  580 FORMAT(///1H ,I6,41H  LARGEST E-VALUES WRITTEN TO OUTPUT FILE)    
      CALL OUTPUT(EX,FX,IX,0,MM)                                        
      MZ=MIN0(MZ,NS)                                                    
      MS=MR-MZ                                                          
      IF(EVALS)
     1 WRITE(NCWU,600) MZ                                                  
  600 FORMAT(1H ,I6,42H  SMALLEST E-VALUES WRITTEN TO OUTPUT FILE)      
      CALL OUTPUT(EX,FX,IX,MS,MR)                                       
  630 CONTINUE
C     CLOSE THE OUTPUT FILE
      IF(EPUNCH) CALL XRDOPN (7,KDEV,'E-VALUES.HKL',12)
      RETURN                                                            
      END                                                               
C 
C
CODE FOR ADD
      SUBROUTINE ADD(N)                                                 
C     SUMS FOR REFLEXION IN ZONE N                                      
      INCLUDE 'XESTAT.INC'
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
C
C
CODE FOR SORT
      SUBROUTINE SORT(A,B,IX,N)                                         
C     SORT ON A                                                         
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
CC
C
CODE FOR OUTPUT
      SUBROUTINE OUTPUT(EX,FX,IX,N,M)                                   
C     PRINT AND OUTPUT TO FILE FOR REFLEXIONS TO BE USED IN MULTAN      
      INCLUDE 'XWILSO.INC'
      INCLUDE 'XUNITS.INC'
      DIMENSION EX(1000),FX(1000),IX(1000)                              
      DIMENSION J(6),K(6),L(6),E(6),KODE(6)                             
      IF(N.EQ.M) GO TO 60                                               
      IF(EVALS)
     1 WRITE(NCWU,10)                                                      
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
      IF(EVALS)
     1 WRITE(NCWU,30) (KODE(II),J(II),K(II),L(II),E(II),II=1,6)
   30 FORMAT(6(I5,3I3,F6.3))                                            
      KK=0                                                              
   50 CONTINUE                                                          
      IF(KK.EQ.0) GO TO 60                                              
      IF(EVALS)
     1 WRITE(NCWU,30) (KODE(II),J(II),K(II),L(II),E(II),II=1,KK)
   60 KK=0                                                              
      D=-1.0                                                            
      RETURN                                                            
      END                                                               

