C $Log: anisotfs.F,v $
C Revision 1.29  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.28  2011/01/18 12:21:52  djw
C Complete referenc efor U-prime
C
C Revision 1.27  2010/06/03 16:56:22  djw
C Copy the #axes screen output to the monitor file
C
C Revision 1.26  2008/10/01 11:11:54  djw
C Support for treatment of Deuterium as hydrogen
C
C Revision 1.24  2008/09/22 15:23:24  djw
C Output U-prime in AXES and fix long standing bug in calls rom XEQUIV - turned out NFL was mis-set
C
C Revision 1.23  2008/09/08 10:18:32  djw
C Enable/inhibit punching of ADP info from XPRAXI
C
C Revision 1.22  2008/09/08 07:19:24  djw
C In AXES, ouput adp volumes
C
C Revision 1.21  2008/02/14 11:04:02  djw
C remove prints to NCAWU
C
C Revision 1.20  2006/10/19 13:58:14  djw
C Correct labelling of final R factors
C
C Revision 1.19  2006/09/06 06:55:44  djw
C Output more decimal places for matrices
C
C Revision 1.18  2006/08/18 13:51:22  djw
C Reinstate lost output
C
C Revision 1.17  2006/02/17 14:51:54  djw
C Fix some writes to monitir/listinganisotfs.fpp
C
C Revision 1.16  2006/02/14 10:38:59  djw
C Compute some axes statistics in AXES
C
C Revision 1.15  2005/02/08 14:43:33  stefan
C 1. added a precompile if for the mac version
C
C Revision 1.14  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:07  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:11  rich
C New CRYSTALS repository
C
C Revision 1.13  2004/07/02 13:26:01  rich
C Remove dependency on HARWELL and NAG libraries. Replaced with LAPACK
C and BLAS code (and a home-made bessel function approximation).
C
C Revision 1.12  2003/08/05 11:11:10  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.11  2003/05/07 12:18:53  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.10  2002/10/14 12:33:24  rich
C Support for DVF command line version.
C
C Revision 1.9  2002/02/27 19:30:18  ckp2
C RIC: Increase lengths of lots of strings to 256 chars to allow much longer paths.
C RIC: Ensure consistent use of backslash after CRYSDIR:
C
C Revision 1.8  2001/12/14 14:44:28  Administrator
C
C DJW Combine TLS amd MOLAX into new module GEOEMTRY. This enables angles
C beween plane normals (etc) and libration axes to be computed.  Add code
C to enable TLS restaints to be generated, and to enable the user to
C modify the T and L tensors
C
C Revision 1.7  2001/02/26 10:24:13  richard
C Added changelog to top of file
C
C
CODE FOR XPRAXI
      SUBROUTINE XPRAXI (ILIST1,ILIST5,IBASE,ISTART,ISTEP,NATOM,LIST,
     1LIST20, JPUNCH)
C--CALCULATE AND PRINT THE PRINCIPAL AXES OF THERMAL ELLIPSOIDS
C
C--
C      ILIST1 .LE. 0 TO LOAD LIST 1
C      ILIST5 .LE. 0 TO LOAD LIST 5
C      IBASE  ADDRESS IN STORE TO SAVE PRINCIPAL AXES AND UEQUIV,
C             IF ZERO,  NOT SAVED.
C      ISTART START OF ATOM STACK (ONLY IF LIST 5 LOADED)
C      ISTEP  PARAMETERS PER ATOM
C      NATOM  NUMBER OF ATOMS
C      LIST   .LT. 0  NO LISTINGS
C      LIST   .EQ. 0  WARNING ONLY
C      LIST   .EQ. 1  BRIEF LISTINGS
C      LIST   .EQ. 2  FULL LISTINGS
C      LIST20 ADDRESS FOR MATRICES FOR LIST 20
C              IF ZERO, NOT SAVED
C      JPUNCH >0 = OUTPUT OT PUNCH FILE
C
C -- IF 'LIST' IS SET GREATER THAN ZERO, THE RESULTS ARE PRINTED. IF
C    NOT, NO RESULTS ARE PRINTED.
C
      DOUBLE PRECISION TENS(3,3),ROOTS(3),VECT(3,3),WORK(9)
C
      CHARACTER*12 CSHAPE
      CHARACTER*24 CTEXT
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
#if defined(_HOL_) 
      DATA KHYD /4HH   /
      DATA KDET /4HD   /
#else
      DATA KHYD /'H   '/
      DATA KDET /'D   '/
#endif
C
C--SET UP THE TIMING
C----- SET SWITCH FOR NON-POSITIVE DEFINATE ATOM CAPTION
      NNPD=0
      IF (ILIST5.LE.0) THEN
C----- LOAD LIST 1 & 5
C------ SET LIST TYPE TO LIST 5
         IULN=5
C--READ ANY OUTSTANDING DIRECTIVES
         IF (KRDDPV(ISTORE(NFL),1)) 950,50,50
C--PRINT THE INITIAL CAPTIONS
50       CONTINUE
         IULN=KTYP05(ISTORE(NFL))
         CALL XLDRO5 (IULN)
C---- SET LIST 5 AUXILLIARY ADDRESSES
         ISTART=L5
         NATOM=N5
         ISTEP=MD5
         M5A=ISTART
      END IF
      IF (ILIST1.LE.0) THEN
         CALL XFAL01
         IF (IERFLG.LT.0) GO TO 1000
      END IF
C
C
      IF (LIST.GT.0) THEN
         CALL XPRTCN
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,100)
         END IF
100      FORMAT (' Principal axes and ''direction''',' cosines of the th
     1ermal ellipsoids',///,1X,'Type',1X,'Serial',5X,'m.s.d.',9X,'a*',
     2    8X,'b''',9X,'c',10X,'a',9X,'b',9X,'c',4x,'Uarith',5x,'Ugeom',
     3    4x,'Uprime')
cfeb08         WRITE (NCAWU,150)
            WRITE (CMON,150)
            CALL XPRVDU (NCVDU,2,0)
            write(ncawu,'(a)') cmon(1),cmon(2)
150      FORMAT (' Principal axes of the thermal ellipsoids, A**2'/
     1 14x,' Min  ',4x,' Med  ',4x,' Max  ',4x,' Uarith     Ugeom',
     2 4x,'Uprime')
      END IF
      IF (JPUNCH .GT. 0) WRITE(NCPU,150)
C
C--SET UP VARIOUS STORAGE LOCATIONS
      NA=NFL
      NB=NA+9
      NC=NB+9
      ND=NC+9
      NE=ND+9
      NF=NE+3
      NG=NF+21
      NH=NG+9
      NFL=NH+9
      IF (NFL.GE.LFL) GO TO 1050
      L=NA
      NL=NH
      M=L1O1
C--REFORM THE REAL SPACE ORTHOGONALIZATION MATRIX
      DO 250 I=1,3
         K=L1P2
         NK=L1P1
         DO 200 J=1,3
            STORE(L)=STORE(M)*STORE(K)
            STORE(NL)=STORE(M)/STORE(NK)
            NK=NK+1
            NL=NL+1
            K=K+1
            L=L+1
            M=M+1
200      CONTINUE
250   CONTINUE
C--START TO PASS THROUGH THE ATOMS
      JBASE=IBASE
      M5B=ISTART
cdjwfeb06 compute the average and max volume
      Avol=0.0
      Bvol=0.0
      Cvol=0.0
      Dvol=0.0
      nvol=0
      DO 900 N=1,NATOM
C-C-C-CHECK WHETHER ANISOTROPIC OR ISOTROPIC/SPHERE/LINE/RING
CDJWJAN2000      IF(ABS(STORE(M5B+3))-UISO)1200,1700,1700
         IFLAG=NINT(ABS(STORE(M5B+3)))
         IF (IFLAG.LE.0) THEN
C-C-C-ANISOTROPIC
C--PULL OUT THE REQUIRED ELEMENTS
      CALL XPANDU (STORE(M5B+7), STORE(NB))
C--ORHTOGONALIZE THE THERMAL TENSOR
            CALL XMLTTM (STORE(NB),STORE(NA),STORE(NC),3,3,3)
            CALL XMLTTM (STORE(NA),STORE(NC),STORE(ND),3,3,3)
C--DIAGONALIZE THE TENSOR
            ITEMP1=ND
            DO 300 ITEMP2=1,3
               DO 300 ITEMP3=1,3
               TENS(ITEMP3,ITEMP2)=DBLE(STORE(ITEMP1))
               ITEMP1=ITEMP1+1
300         CONTINUE
C            I=0
C            CALL F02ABF (TENS,3,3,ROOTS,VECT,3,WORK,I)
            INFO = 0
            CALL DSYEV('V','L',3,TENS,3,ROOTS,WORK,9,INFO)
            DO ITEMP2=1,3
              DO ITEMP3=1,3
                VECT(ITEMP2,ITEMP3) = TENS(ITEMP2,ITEMP3)
              END DO
            END DO
c
            ITEMP1=NE
            ITEMP2=NG
            DO 350 ITEMP3=1,3
               STORE(ITEMP1)=SNGL(ROOTS(ITEMP3))
               ITEMP1=ITEMP1+1
               DO 350 ITEMP4=1,3
               STORE(ITEMP2)=SNGL(VECT(ITEMP4,ITEMP3))
               ITEMP2=ITEMP2+1
350         CONTINUE
            J=NE+2
            IF (IBASE.GT.0) CALL XMOVE (STORE(NE),STORE(JBASE+1),3)
            M=NE
            K=NF
            L=NG
            DO 450 I=1,3
               STORE(K)=STORE(M)
               K=K+1
               M=M+1
C--MOVE THE COSINES WITH RESPECT TO ORTHOGONAL AXES
               DO 400 J=1,3
                  STORE(K)=STORE(L)
                  K=K+1
                  L=L+1
400            CONTINUE
C--CALCULATE THE COSINES WITH RESPECT TO THE CRYSTALLOGRAPHIC AXES
               CALL XMLTMM (STORE(NH),STORE(K-3),STORE(K),3,3,1)
               K=K+3
450         CONTINUE
C----- DATA FOR LIST 20
            IF (LIST20.GT.0) THEN
C----- CRYSTAL TO AXIAL
               CALL XMLTTM (STORE(NG),STORE(L1O1),STORE(LIST20+9),3,3,3)
C----- INTERCHANGE EIGEN VECTORS
               CALL XMTREX (STORE(LIST20+9),STORE(LIST20),3,3)
               I=KINV2(3,STORE(LIST20),STORE(LIST20+9),9,0,STORE(LIST20+
     1          18),STORE(LIST20+18),3)
               CALL XMOVE (STORE(M5B+4),STORE(LIST20+18),3)
            END IF
cdjwfeb06  add in volume contributions
cdjwfeb06 compute geometric mean
            UGEOM=(STORE(NE)*STORE(NE+1)*STORE(NE+2))
            UGEOM=sign(1.,ugeom)*abs(UGEOM)**0.33333
            UARITH = (STORE(NE)+STORE(NE+1)+STORE(NE+2))/3.
cdjwsep08
            UPRIME =SIGN(real(1., kind(STORE)),STORE(NE))*
     1          ABS(STORE(NE+2)*STORE(NE+1))/
     1          ABS(STORE(NE))
            UEQUIV = UGEOM
            avol = avol + uequiv
            dvol = dvol + uequiv*uequiv
            bvol = max (bvol, uequiv)
            cvol = max (cvol, STORE(NE+2))
            nvol = nvol + 1
cdjwfeb06 recompute arithemtic mean if this is what the user needs
            IF (ISSUEQ.EQ.1) THEN
               UEQUIV=UARITH
            END IF
            IF (IBASE.GT.0) STORE(JBASE)=UEQUIV
C----- CHECK FOR SPLITTING
            IF (STORE(NE+2)-STORE(NE).GE.0.25) THEN
               CTEXT=' Might be split'
            ELSE
               CTEXT=' '
            END IF
C----- CHECK NEGATIVE ELLIPSOID
            IF (STORE(NE).LT.0.0) THEN
C--     SOME OF THE AXES ARE NOT POSITIVE
               CTEXT=' Physically unreasonable'
            END IF
C
C-----   PRINT A CAPTION THE FIRST TIME
            IF ((LIST.EQ.0).AND.(CTEXT.NE.' ')) THEN
               IF (NNPD.LE.0) THEN
                  NNPD=1
                  IF (ISSPRT.EQ.0) WRITE (NCWU,500)
cfeb08                  WRITE (NCAWU,500)
                  WRITE (CMON,500)
                  CALL XPRVDU (NCVDU,1,0)
500               FORMAT (' The following atoms should be carefully exam
     1ined ')
               END IF
            END IF
            J=NE+2
            K=NF+20
            IF (LIST.GT.0) THEN
               WRITE (CMON,550) STORE(M5B),STORE(M5B+1),(STORE(III),III=
     1          NE,J),UARITH, UGEOM, UPRIME, CTEXT
               CALL XPRVDU (NCVDU,1,0)
               write(ncawu,'(a)') cmon(1)
550            FORMAT (1X,A4,F6.0,6F10.4,3X,A24)
               IF (ISSPRT.EQ.0) WRITE (NCWU,600) STORE(M5B),STORE(M5B+1)
     1          ,(STORE(I),I=NF,K),UARITH, UGEOM, UPRIME, CTEXT
600            FORMAT (/1X,A4,F7.0,2X,F9.5,2(1X,3F10.5),2(/14X,F9.5,
     1          2(1X,3F10.5)),3F10.5,A24)
            ELSE IF ((LIST.EQ.0).AND.(CTEXT.NE.' ')) THEN
               WRITE (CMON,550) STORE(M5B),STORE(M5B+1),(STORE(III),III=
     1          NE,J),UARITH,UGEOM,UPRIME, CTEXT
               CALL XPRVDU (NCVDU,1,0)
               IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
cfeb08               WRITE (NCAWU,'(A)') CMON(1)
            END IF
CDJWSEP08
            IF (JPUNCH .GT. 0) THEN
               WRITE (NCPU,550) STORE(M5B),STORE(M5B+1),(STORE(III),III=
     1          NE,J),UARITH, UGEOM, UPRIME
            END IF
            GO TO 850
         ELSE
C-C-C-   ISOTROPIC ATOMS/SPHERE/LINE/RING
            IF (IBASE.GT.0) THEN
C----- SET TO U[ISO]
               STORE(JBASE)=STORE(M5B+7)
            END IF
CFEB00
C-----      DONT BOTHER WITH H
            IF ((ISTORE(M5B) .EQ. KHYD).OR.(ISTORE(M5B) .EQ. KDET)) 
     1      GOTO 850
C-----      CHECK FOR SPLITTING
            CSHAPE = ' '
            CTEXT=' '
            IF (STORE(M5B+7).GE.0.25) THEN
               CTEXT=' Might be spurious'
            END IF
C-----      CHECK NEGATIVE SPHERE
            IF (STORE(M5B+7).LT.0.0) THEN
               CTEXT=' Physically unreasonable'
            END IF
C
C-----   PRINT A CAPTION THE FIRST TIME
            IF ((LIST.EQ.0).AND.(CTEXT.NE.' ')) THEN
               IF (NNPD.LE.0) THEN
                  NNPD=1
                  IF (ISSPRT.EQ.0) WRITE (NCWU,500)
cfeb08                  WRITE (NCAWU,500)
                  WRITE (CMON,500)
                  CALL XPRVDU (NCVDU,1,0)
               END IF
            END IF
C
            IF (IFLAG.EQ.1) THEN
                     CSHAPE ='Isotropic'
            ELSE IF (IFLAG.EQ.2) THEN
                     CSHAPE = 'Sphere'
            ELSE IF (IFLAG.EQ.3) THEN
                     CSHAPE = 'Line'
            ELSE IF (IFLAG.EQ.4) THEN
                     CSHAPE = 'Ring'
            END IF
            IF (LIST.GT.1) THEN
               IF (ISSPRT.EQ.0) THEN
                  WRITE (NCWU,800) STORE(M5B),STORE(M5B+1),STORE(M5B+7),
     1            CSHAPE,CTEXT
800            FORMAT (1X,A4,F7.0,2X,F9.5,51X,A12,A)
               END IF
            ENDIF
            IF ((LIST.ge.0).AND.(CTEXT.NE.' ')) THEN
               WRITE (CMON,830) STORE(M5B),STORE(M5B+1),STORE(M5B+7),
     1         CSHAPE, CTEXT
830            FORMAT (1X,A4,F6.0,F10.4,5X,A12,6X,A24)
               CALL XPRVDU (NCVDU,1,0)
c               WRITE (NCAWU,'(A)') CMON(1)
            END IF
C
         END IF
850      CONTINUE
         IF (IBASE.GT.0) JBASE=JBASE+4
C--MOVE TO THE NEXT ATOM
         M5B=M5B+ISTEP
900   CONTINUE
C--FINAL CAPTION AND RETURN
cdjwfeb06
      if(list .gt. 0) then
       if (nvol .gt. 1) then
         write(cmon,'(A,i6,a,f8.4,a,f8.4)')' Average radius of ',nvol,
     1 ' atoms =',avol/float(nvol), ' rmsd ',
     2   sqrt((nvol*dvol-avol*avol)/(nvol*(nvol-1)))
         CALL XPRVDU (NCVDU,1,0)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
c
         write(cmon,'(A,i6,a,f8.4)')' Maximum radius of ',nvol,
     1 ' atoms =',bvol
         CALL XPRVDU (NCVDU,1,0)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
c
         write(cmon,'(A,i6,a,f8.4)')'   Maximum axis of ',nvol,
     1 ' atoms =',cvol
         CALL XPRVDU (NCVDU,1,0)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
c
         write(cmon,'(a)')
     1   'for Uprime see Acta Cryst (2000). B56, 747-749'
         CALL XPRVDU (NCVDU,1,0)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)
       endif
      endif
950   CONTINUE
C----- RETURN WORKSPACE
      NFL=NA
      IF (LIST.GT.0) THEN
         CALL XOPMSG (IOPPRA,IOPEND,200)
      END IF
      RETURN
C
1000  CONTINUE
C -- ERRORS
      CALL XOPMSG (IOPPRA,IOPABN,0)
      GO TO 950
1050  CONTINUE
C----- INSUFFICIENT STORE
      IERFLG=-1
      CALL XOPMSG (IOPPRA,IOPSPC,0)
      GO TO 950
      END
CODE FOR XEQUIV
      SUBROUTINE XEQUIV (MODE,IATOM,NPAR,IBASE)
C----- COMPUTE THE U EQUIVALENT FOR THE ATOM AT STORE(IATOM)
C      WITH NPAR PARAMETERS PER ATOM
C      IBASE IS 5 WORD AREA CONTAUNING UEQUIV, UMIN, UMED, UMAX
C
C----- USE MODE = 1 IF CALLING ROUTINE HANDLES LFL AND LFL CORRECTLY,
C      OTHERWISE USE MODE = 0
C      E.G. XPRAXI INTERACTS WITH SYDROG, PROBABLY THROUGH COMMON
C      STORAGE OVERWRITES, SO THAT ONE OR MORE GENERATED ATOMS BECOME
C      CORRUPT.
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'QSTORE.INC'
C
C-C-C-CHECK WHETHER ATOM IS ANISOTROPIC OR ISOTROPIC/SPHERE/LINE/RING
      IF (ABS(STORE(IATOM+3)).LE.UISO) THEN
C----- ATOM IS ANISOTROPIC SO COMPUTE UEQUIV
         IF (MODE.EQ.1) THEN
C         WELL ORGANISED CALLING ROUTINE
            CALL XPRAXI (1,1,IBASE,IATOM,NPAR,1,-1,0,0)
         ELSE
C         AN APPROXIMATION FOR POOR CALLING ROUTINES
            UEQUIV=(STORE(IATOM+7)+STORE(IATOM+8)+STORE(IATOM+9))
            IF (UEQUIV.LE.ZERO) THEN
               STORE(IBASE)=0.051
            ELSE
               STORE(IBASE)=UEQUIV/3.
            END IF
         END IF
      ELSE
C----- ATOM IS ISOTROPIC ANYWAY
C-C-C-ATOM IS ISOTROPIC ANYWAY (OR SPHERE/LINE/RING)
         STORE(IBASE)=STORE(IATOM+7)
         STORE(IBASE+1)=0.0
         STORE(IBASE+2)=0.0
         STORE(IBASE+3)=0.0
      END IF
      RETURN
      END
CODE FOR RSUB06
      SUBROUTINE RSUB06
C--CONTROL ROUTINE OF TLS CALCUATIONS
C
C
C--
      CHARACTER*4 CCALC(2)
      INCLUDE 'ICOM12.INC'
      INCLUDE 'ISTORE.INC'
C
      DIMENSION ITARG(1)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XLST02.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST12.INC'
      INCLUDE 'XLST20.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XRTLSC.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QLST12.INC'
      INCLUDE 'QSTORE.INC'
C
      INCLUDE 'IDIM12.INC'
C
      DATA CCALC/' TLS','AXIS'/
#if defined(_HOL_) 
      DATA ITARG(1) / 4HALL /
#else
      DATA ITARG(1)/'ALL '/
#endif
      DATA EIGMIN/0.000001/,EIGRAT/0.01/
      DATA IVERSN/201/
C
C
C--SET UP THE TIMING CONTROL
      CALL XTIME1 (2)
C--CLEAR THE CORE
      CALL XCSAE
C----- WORKSPACE FOR REPLACEMENT
      IWORK=KSTALL(3)
      JWORK=KSTALL(6)
      KWORK=KSTALL(30)
C----- SPACE FOR ATOM HEADERS
      MQ=KSTALL(100)
C----- COMMAND BUFFER
      IDIMBF=50
CMAR98
      ICOMBF=KSTALL(IDIMBF)
      CALL XZEROF (STORE(ICOMBF),IDIMBF)
C----- ZERO THE BUFFER
      CALL XZEROF (ISTORE(ICOMBF),IDIMBF)
C----- COMMON BLOCK OFFSET(-1) FOR INPUT LIST
      IMDINP=35
C----- INITIALSE LEXICAL PROCESSING
      ICHNG=1
      CALL XLXINI (INEXTD,ICHNG)
C--INDICATE THAT LIST 12 IS NOT TO BE USED
      DO 50 I=1,IDIM12
         ICOM12(I)=NOWT
50    CONTINUE
CDJWSEP08      TURN OFF PUNCHING
      JPUNCH = -1
C
C--MAIN INSTRUCTION CYCLING LOOP
100   CONTINUE
C----- DO NOT REPLACE ATOMS
      IRPL=0
      IDIRNM=KLXSNG(ISTORE(ICOMBF),IDIMBF,INEXTD)
      IF (IDIRNM.LT.0) GO TO 100
      IF (IDIRNM.EQ.0) GO TO 3300
C--NEXT RECORD HAS BEEN LOADED  -  BRANCH ON THE TYPE
      GO TO (200,2000,1250,1350,2400,1850,1650,100,3450,950,2750,2350,
     12800,150),IDIRNM
      GO TO 3650
C
150   CONTINUE
C----- ANISO ITSELF
C--LOAD THE RELEVANT LISTS
      CALL XFAL01
      CALL XFAL02
      CALL XFAL20
      IULN5=KTYP05(ISTORE(ICOMBF+IMDINP))
      CALL XLDR05 (IULN5)
      IF (IERFLG.LT.0) GO TO 3600
C--LIST READ IN OKAY  -  SET UP THE INITIAL CONTROL FLAGS
C--RESET SOME CONTROL FLAGS FOR THIS ROUTINE
      NATOM=0
      IPRINT=0
      TESTEV=EIGMIN
      TESTER=EIGRAT
      NDEL=0
      CALL XZEROF (JDEL(1),20)
      CALL XZEROF (CF(1),3)
C--SET THE FLAG TO INDICATE NO ATOMS STORED AT PRESENT
      NATOM=0
C----- IOK : -1 = AXIS, 0 = NOTHING, +1 = TLS
      IOK=0
      IERR=1
C----- SET GROUP COUNTER TO ZERO
      NGP=0
C-----  SAVE THE WORK AREAS
C----- ORIGINAL ATOMS
      IBASE=LFL
C----- ORTHOGOONAL ATOMS
      KBASE=NFL
C----- INDICATE NO MODIFICATIONS YET
      IMOD5=0
C----- INDICATE LIST 20 NOT UPDATED
      IUPDT=0
      GO TO 100
C
C
C--'ATOM' INSTRUCTION
200   CONTINUE
      NATOM=0
      IOK=0
      IERR=+1
      DL=0.
      DA=0.
C----- CLEAR THE CENTROID
      CALL XZEROF (CF(1),3)
C----- RESTORE THE 'END' OF THE ATOM STACK
      LFL=IBASE
C----- RESTORE ORTHOGONAL ATOM STACK
      NFL=KBASE
      Z=1.
C--CHECK FOR SOME ARGUMENTS
      IF (KFDARG(I)) 250,350,350
C--ERROR(S)  -  SET THE ATOM ERROR COUNT
250   CONTINUE
      IERR=-1
      GO TO 100
C--CHECK IF THERE ARE MORE ARGUMENTS ON THIS CARD
300   CONTINUE
      IF (KOP(8)) 800,350,350
C--CHECK IF NEXT ARGUMENT IS A NUMBER
350   CONTINUE
      IF (KSYNUM(Z)) 450,400,450
400   CONTINUE
      ME=ME-1
      MF=MF+LK2
C--READ THE NEXT GROUP OF ATOMS
450   CONTINUE
      IF (KATOMU(LN)) 500,500,550
C--ERRORS  -  SET THE ATOM ERROR COUNT
500   CONTINUE
      IERR=-1
      GO TO 3200
C--MOVE ATOMS TO STACK WITH CORRECT CO-ORDINATES
550   CONTINUE
      DO 750 J=1,N5A
         LFL=LFL-MD5A
         IF (NFL+27-LFL) 650,600,600
C--ERRORS
600      CONTINUE
         IERR=-1
         GO TO 3250
C--TRANSFORM THE ATOM AND MOVE IT ACROSS
650      CONTINUE
         IF (KATOMS(MQ,M5A,LFL)) 500,500,700
C--ATOM MOVED OKAY  -  SET THE WEIGHT OVER TH OCCOPATION
700      CONTINUE
         STORE(LFL+2)=Z
C--INCREMENT FOR THE NEXT ATOM
         M5A=M5A+MD5A
750   CONTINUE
      NATOM=NATOM+N5A
      GO TO 300
C--CHECK THAT THERE IS AT LEAST ONE ATOM ON THIS CARD
800   CONTINUE
C----- STORE THE 'START' OF THE ATOM STACK
      JBASE=LFL
      LFL=LFL-1
      IF (NATOM) 850,850,100
C--NO ATOMS ON THIS CARD
850   CONTINUE
      CALL XPCLNN (LN)
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,900)
      END IF
cfeb08      WRITE (NCAWU,900)
      WRITE (CMON,900)
      CALL XPRVDU (NCVDU,1,0)
900   FORMAT (' No atoms found')
      GO TO 100
C
C
C--'TLS' INSTRUCTION
950   CONTINUE
C -- CHECK THERE ARE SOME ATOMS
      IF (NATOM.LE.0) GO TO 3700
C--INCREMENT THE NUMBER OF GROUP CARDS READ
      NGP=NGP+1
C--CHECK IF ANY ERRORS HAVE BEEN GENERATED DURING THE INPUT OF THE ATOMS
      IF (IERR) 1000,1000,1100
1000  CONTINUE
      CALL XPCLNN (LN)
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,1050)
      END IF
cfeb08      WRITE (NCAWU,1050)
      WRITE (CMON,1050)
      CALL XPRVDU (NCVDU,1,0)
1050  FORMAT (' Instruction ignored because of previous errors')
      GO TO 100
1100  CONTINUE
cfeb08      WRITE (NCAWU,1150) NGP
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,1150) NGP
      END IF
      WRITE (CMON,1150) NGP
      CALL XPRVDU (NCVDU,1,0)
1150  FORMAT (' Results for group number ',I4)
C--PRINT THE PAGE HEADING
      CALL XPRTCN
C----- FIND TLS
      LBASE=NFL
C----- CHECK WORKSPACE FOR NEXT SUBROUTINE
      NFL=NFL+3*NATOM
      N=LFL-NFL
      IF (N.LE.0) GO TO 3250
      IF (IRTLS(JBASE,LBASE,NATOM,MD5A,KWORK,1).GT.0) THEN
C--MARK THE GROUP AS ACCEPTABLE
         IOK=1
         IERR=1
C----- CLEAR THE REJECT AND LIMIT CONDITIONS
         TESTEV=EIGMIN
         TESTER=EIGRAT
         NDEL=0
         CALL XZEROF (JDEL(1),20)
      ELSE
cfeb08         WRITE (NCAWU,1200)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,1200)
         END IF
         WRITE (CMON,1200)
         CALL XPRVDU (NCVDU,1,0)
1200     FORMAT (' TLS analysis fails')
      END IF
      GO TO 100
C
C
C---'DISTANCES' INSTRUCTION
1250  CONTINUE
      DL=1.8
      IF (ME) 1500,1500,1300
1300  CONTINUE
      IF (KSYNUM(DL)) 3100,1400,3100
C
C---'ANGLES' INSTRUCTION
1350  CONTINUE
      DA=1.8
1400  CONTINUE
      IF (ME) 1500,1500,1450
1450  CONTINUE
      IF (KSYNUM(DA)) 3100,1500,3100
1500  CONTINUE
      IF (IOK) 3100,3100,1550
1550  CONTINUE
C -- CHECK THERE ARE SOME ATOMS
      IF (NATOM.LE.0) GO TO 3700
C----- COMPUTE DISTANCES AND ANGLES
      CALL RDSTAN (JBASE,LBASE,NATOM,MD5A)
cfeb08      WRITE (NCAWU,1600)
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,1600)
      END IF
      WRITE (CMON,1600)
      CALL XPRVDU (NCVDU,4,0)
1600  FORMAT (1X,79('*'),/'    Remember that DISTANCE resets the current
     1 atom counter',/10X,'You must issue a new ATOM directive',/,1X,
     279('*'))
      NATOM=0
      IOK=0
      GO TO 100
C
C
C----- 'LIMITS' INSTRUCTION TO RESET EIGENVALUE TEST LIMITS
1650  CONTINUE
      IF (KFDARG(I)) 3200,1700,1700
C--READ THE FIRST NUMBER
1700  CONTINUE
      IF (KFDNUM(TESTEV)) 3200,1750,1750
C--CHECK IF THERE IS A SECOND NUMBER
1750  CONTINUE
      IF (ME) 100,100,1800
C--READ THE SECOND NUMBER
1800  CONTINUE
      IF (KFDNUM(TESTER)) 3200,100,100
C
C----- 'REJECT' INSTRUCTION TO REJECT CHOSEN EIGENVALUES
1850  CONTINUE
      IF (KFDARG(I)) 3200,1900,1900
C---- READ THE REJECTED EIGENVALUES
1900  CONTINUE
      IF (KFDNUM(A)) 3200,1950,1950
1950  CONTINUE
      NDEL=NDEL+1
      JDEL(NDEL)=NINT(A)
      GO TO 100
C
C
C---'CENTRE' INSTRUCTION
2000  NB=0
2050  IF (ME) 2300,2300,2100
2100  IF (KSYNUM(Z)) 2900,2150,2250
2150  NB=NB+1
      IF (NB-3) 2200,2200,3000
2200  CF(NB)=Z
      ME=ME-1
      MF=MF+LK2
      GO TO 2050
2250  IF (KOP(8)) 2300,2050,2900
2300  IF (NB-3) 3000,100,3000
C
C
C----- 'REPLACE' INSTRUCTION
2350  CONTINUE
      IRPL=1
C
C--'PRINT' INSTRUCTION  -  CHECK IF WE CAN PRINT THE ATOMS
2400  CONTINUE
      IF (IOK) 3100,3100,2450
C--START TO PROCESS THE CARD
2450  CONTINUE
      IF (KFDARG(I)) 100,2500,2500
C--PRINT A CAPTION
2500  CONTINUE
      IF (IRPL.EQ.0) THEN
cfeb08         WRITE (NCAWU,2550)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,2550)
         END IF
         WRITE (CMON,2550)
         CALL XPRVDU (NCVDU,1,0)
2550     FORMAT (1X,' Co-ordinates of other atoms',' after TLS applicati
     1on')
      END IF
C--CHECK THE CORE AREA
C      LFL=LFL-MD5A
C      IF(NFL + 27 -LFL)3350,3350,8900
C--ENOUGH CORE
      IF (KCOMP(1,ISTORE(MF+2),ITARG,1,1).LE.0) THEN
         IALL=0
         GO TO 2650
      ELSE
         IALL=1
         GO TO 2700
      END IF
C--CHECK IF THERE ARE MORE ARGUMENTS TO BE PROCESSED
2600  CONTINUE
      IF (KOP(8)) 100,2650,2650
C--FIND THE NEXT GROUP OF ATOMS
2650  CONTINUE
      IF (KATOMU(LN)) 3200,3200,2700
2700  CONTINUE
C----- PRINT THE RESULTS FOR THESE ATOMS
      IF (IALL.LE.0) THEN
         ISTART=LFL
         NUMBER=N5A
         ISTEP=MD5A
         ISAVE=M5A
      ELSE
         ISTART=L5
         NUMBER=N5
         ISTEP=MD5
         ISAVE=L5
      END IF
      IF (KTLSPT(ISTART,NUMBER,ISTEP,ISAVE,IWORK,JWORK,IALL,IRPL,IMOD5
     1 ,0) .LE. 0) GO TO 3450
      IF (IALL.LE.0) GO TO 2600
      GO TO 100
C
C
2750  CONTINUE
C----- 'AXES' INSTRUCTION
      IF (NATOM.LE.0) GO TO 3700
      IF (IERR.LE.0) GO TO 1000
      LBASE=NFL
C----- CHECK WORKSPACE FOR NEXT SUBROUTINE
      NFL=KSTALL(4*NATOM)
cdjwmar00      CALL XPRAXI (1,1,LBASE,JBASE,MD5A,NATOM,2,KWORK,JPUNCH)
      CALL XPRAXI (1,1,0,JBASE,MD5A,NATOM,2,0, JPUNCH)
C--MARK THE CALCULATION AS ACCEPTABLE
      IOK=-1
      IERR=1
      GO TO 100
C
C----- 'STORE' INSTRUCTION
2800  CONTINUE
      IF (IOK.NE.0) THEN
         IF (IOK.EQ.-1) THEN
            ISHIFT=3
         ELSE
            ISHIFT=2
         END IF
         M20M=L20M+ISHIFT*MD20M
         M20I=L20I+ISHIFT*MD20I
         M20V=L20V+ISHIFT*MD20V
         CALL XMOVE (STORE(KWORK),STORE(M20M),9)
         CALL XMOVE (STORE(KWORK+9),STORE(M20I),9)
         CALL XMOVE (STORE(KWORK+18),STORE(M20V),3)
         IUPDT=1
cfeb08         WRITE (NCAWU,2850) CCALC(ISHIFT-1)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,2850) CCALC(ISHIFT-1)
         END IF
         WRITE (CMON,2850) CCALC(ISHIFT-1)
         CALL XPRVDU (NCVDU,1,0)
2850     FORMAT (' LIST 20 ',A4,' record will be updated ')
      END IF
      GO TO 100
C
C
C---ERROR MODES FOR 'CENTRE' INSTRUCTION
2900  CALL XPCLNN (LN)
      I=ISTORE(MF+1)
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,2950) I
      END IF
cfeb08      WRITE (NCAWU,2950)
      WRITE (CMON,2950)
      CALL XPRVDU (NCVDU,1,0)
2950  FORMAT (' Spurious character at about column',I5)
      GO TO 3200
3000  CALL XPCLNN (LN)
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,3050)
      END IF
cfeb08      WRITE (NCAWU,3050)
      WRITE (CMON,3050)
      CALL XPRVDU (NCVDU,1,0)
3050  FORMAT (' Too many or too few numbers')
      GO TO 3200
C
C--ERROR BECAUSE TLS  HAS NOT BEEN CALCULATED
3100  CONTINUE
      CALL XPCLNN (LN)
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,3150)
      END IF
cfeb08      WRITE (NCAWU,3150)
      WRITE (CMON,3150)
      CALL XPRVDU (NCVDU,1,0)
3150  FORMAT (1X,' Instruction ignored. TLS have not been',' successfull
     1y computed')
      GO TO 100
C
C--ERROR EXIT FOR THESE ROUTINES
3200  CONTINUE
      CALL XPCA (I)
      GO TO 100
C
C--NOT ENOUGH CORE
3250  CONTINUE
      I=0
      J=0
      CALL XSTICA (I,J)
      GO TO 3450
C
C--MAIN TERMINATION ROUTINES
C
3300  CONTINUE
      IF (IMOD5.GT.0) THEN
         CALL XSTR05 (IULN5,0,1)
cfeb08         WRITE (NCAWU,3350)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,3350)
         END IF
         WRITE (CMON,3350)
         CALL XPRVDU (NCVDU,1,0)
3350     FORMAT (' LIST 5 has been updated')
      END IF
      IF (IUPDT.GT.0) THEN
         CALL XSTR20 (20,0,1)
cfeb08         WRITE (NCAWU,3400)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,3400)
         END IF
         WRITE (CMON,3400)
         CALL XPRVDU (NCVDU,1,0)
3400     FORMAT (' LIST 20 has been updated')
      END IF
      GO TO 3550
C
C
3450  CONTINUE
      IF (IMOD5.GT.0) THEN
         N=5
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,3500) N
         END IF
cfeb08         WRITE (NCAWU,3500) N
         WRITE (CMON,3500) N
         CALL XPRVDU (NCVDU,1,0)
3500     FORMAT (' WARNING. The requested update to LIST ',I4,' has not
     1been performed')
      END IF
      IF (IUPDT.GT.0) THEN
         N=20
cfeb08         WRITE (NCAWU,3500) N
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,3500) N
            WRITE (CMON,3500) N
            CALL XPRVDU (NCVDU,1,0)
         END IF
      END IF
3550  CONTINUE
      CALL XOPMSG (IOPTLS,IOPEND,IVERSN)
      CALL XTIME2 (2)
      RETURN
C
C -- ERRORS
3600  CONTINUE
      CALL XOPMSG (IOPTLS,IOPABN,0)
      GO TO 3450
3650  CONTINUE
C -- INPUT ERRORS
      CALL XOPMSG (IOPTLS,IOPCMI,0)
      GO TO 3600
3700  CONTINUE
C
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,3750)
      END IF
cfeb08      WRITE (NCAWU,3750)
      WRITE (CMON,3750)
      CALL XPRVDU (NCVDU,1,0)
3750  FORMAT (1X,'No atoms have been specified ')
      CALL XERHND (IERWRN)
      GO TO 100
      END
CODE FOR KTLSPT
      FUNCTION KTLSPT (ISTART,NUMBER,ISTEP,ISAVE,IWORK,JWORK,IALL,IRPL,
     1IMOD5,IPUNCH)
C----- PRINT OBSERVED AND CALCULATED U'S
C
C----- RETURNS -1 IF FATAL ERROR GENERATED
C      ISTART START OF ACTUAL PARAMETERS
C      NUMBER NUMBER OF ATOMS
C      ISTEP  NUMBER OF PARAMETERS PER ATOM
C      ISAVE  ADDRESS TO SAVE TATOMS
C      JWORK, IWORK  WORK SPACE
C      IALL   1 FOR ALL ATOMS
C      IRPL   1 FOR REPLACE REQUIRED
C      IMOD5  1 IF MODIFICATION OCCURS
C      IPUNCH 1 IF RESTRAINT TO BE PUNCHED
C
      CHARACTER *256 CPATH
      CHARACTER *32 CTEMP
      DIMENSION JFRN(4)
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST20.INC'
      INCLUDE 'XLEXIC.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XAPK.INC'
      INCLUDE 'XRTLSC.INC'
C
      INCLUDE 'QSTORE.INC'
C
#if defined(_HOL_)
      DATA JFRN /4HF   , 4HR   , 4HN   , 4H1   /
#else
      DATA JFRN /'F', 'R', 'N', '1'/
#endif
C
C----- NO ERRORS YET
      KTLSPT=+1
      IF (IPUNCH .GT. 0) THEN
C----- OPEN A FILE FOR THE TLS RESTRAINTS
      WRITE (CMON,'(11X,A)') 'Putting TLS restraints in TLSREST.DAT'
      CALL XPRVDU (NCVDU,1,0)
      LPATH=KPATH(CPATH)
      CALL XRDOPN (6,JFRN(1),CPATH(1:LPATH)//'TLSREST.DAT',LPATH+11)
      WRITE (NCFPU1,'(A)') '# TLS RESTRAINTS'
      ENDIF
C
C--LOOP OVER EACH OF THE ATOMS WE HAVE FOUND
      DO 200 I=1,NUMBER
         IF (IALL.LE.0) THEN
C----- PROCESS ATOM DEFINITION
            IF (KATOMS(MQ,ISAVE,ISTART)) 250,250,50
50          CONTINUE
         ELSE
            ISTART=ISAVE
         END IF
C----- ORTHOGONALISE X
         CALL XMLTMM (AO,STORE(ISTART+4),STORE(IWORK),3,3,1)
C----- COMPUTE U'S
         CALL RSUB08 (IWORK)
         CALL XMLTMM (DV,AR,WC,6,20,1)
         CALL RSUB10 (WA,WC)
         CALL XMLTMM (UO,WA,WB,3,3,3)
         CALL XMLTMT (WB,UO,WA,3,3,3)
         CALL RSUB09 (WA,WC)
         CALL XMOVE (WC(1),STORE(JWORK),6)
C-----  WRITE DETAILS
C-C-C-CHECK WHETHER ATOM IS ANISOTROPIC OR ISOTROPIC/SPHERE/LINE/RING
            IF (ABS(STORE(ISTART+3)).LT.UISO) THEN
C-----    ANISOTROPIC
C-----    WRITE NEW PARAMETERS
               JJ=ISTART+4
               WRITE(CMON,100)  STORE(ISTART),STORE(ISTART+1),
     1         (STORE(J),J=JJ,JJ+8)
               CALL XPRVDU(NCVDU,1,0)
               IF (ISSPRT.EQ.0) WRITE(NCWU,'(A)') CMON(1)(1:)
cfeb08               WRITE (NCAWU,'(A)') CMON(1)(1:)
100            FORMAT (1X,A4,F4.0,3F8.4,6F8.3)
               WRITE(CMON,150)  (STORE(J),J=JWORK,JWORK+5)
150            FORMAT (1X,32X,6F8.3)
               CALL XPRVDU(NCVDU,1,0)
               IF (ISSPRT.EQ.0) WRITE(NCWU,'(A)') CMON(1)(1:)
cfeb08               WRITE (NCAWU,'(A)') CMON(1)(1:)
               IF (IRPL.EQ.1) THEN
C-----           REPLACE
                 CALL XMOVE (STORE(JWORK),STORE(ISAVE+7),6)
                 STORE(ISAVE+3)=0.0
                 IMOD5=1
               ENDIF
               IF (IPUNCH .GT.0) THEN
                DO 115 KK=1,6
                  WRITE(CTEMP,109) STORE(ISTART), 
     1            NINT(STORE(ISTART+1)),ICOORD(1,KK+7),ICOORD(2,KK+7)
109               FORMAT(A4,'(',I5,',',A4,A4,')')
                  CALL XCRAS ( CTEMP, LENNAM )
                  WRITE(NCFPU1,110)STORE(JWORK+KK-1), CTEMP(1:LENNAM)
110               FORMAT('RESTRAIN ', F10.4, ',0.01 = ', A)
115             CONTINUE
               ENDIF
            ELSE
C-----    ISOTROPIC
C-C-C-ISOTROPIC/SPHERE/LINE/RING
               JJ=ISTART+4
               JJJ=ISTART+6
               IF (ISSPRT.EQ.0) THEN
                  WRITE (NCWU,100) STORE(ISTART),STORE(ISTART+1),
     1             (STORE(J),J=JJ,JJJ),STORE(ISTART+7)
               END IF
cfeb08               WRITE (NCAWU,100) STORE(ISTART),STORE(ISTART+1),(STORE(J)
cfeb08     1          ,J=JJ,JJJ),STORE(ISTART+7)
            END IF
         ISAVE=ISAVE+ISTEP
200   CONTINUE
      GO TO 400
250   CONTINUE
cfeb08      WRITE (NCAWU,300)
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,300)
      END IF
      WRITE (CMON,300)
      CALL XPRVDU (NCVDU,1,0)
300   FORMAT (' Errors in atom definitions')
      IF (IRPL.GT.0) THEN
cfeb08         WRITE (NCAWU,350)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,350)
         END IF
         WRITE (CMON,350)
         CALL XPRVDU (NCVDU,1,0)
350      FORMAT (' Coordinates will not be updated')
         KTLSPT=-1
      END IF
400   CONTINUE
      IF (IMOD5*IRPL.GT.0) THEN
cfeb08         WRITE (NCAWU,450)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,450)
         END IF
         WRITE (CMON,450)
         CALL XPRVDU (NCVDU,1,0)
450      FORMAT (/' U''s have been modified'/)
      END IF
      IF (IPUNCH .GT. 0) THEN
C----- CLOSE THE TLS RESTRAINT FILE
      CALL XRDOPN (7,JFRN(1),CPATH(1:LPATH)//'TLSREST.DAT',LPATH+11)
      ENDIF
      RETURN
      END
CODE FOR IRTLS
      FUNCTION IRTLS (JBASE,LBASE,NATOM,ISTEP,KWORK,IMODE)
C----- CALCULATE T, L, AND S FOR GROUP OF ATOMS
C
C      RETURN VALUE .GT. 0 IF OK
C
C      JBASE  START OF ATOM STACK (FRACTIONAL)
C      LBASE  START OF ATOM STACK (ORTHOGONAL)
C      NATOM  NUMBER OF ATOMS
C      ISTEP  NUMBER OF PARAMETERS PER ATOM
C             JBASE + 3 = UISO
C                   + 4 = X'S
C                   + 7 = U'S
C      KWORK  ADDRESS FOR RESULTANT MATRICES
C      IMODE  IF .LE. 0 PRODUCE NO OUTPUT
C
C--
      DOUBLE PRECISION DAA,DAR,DAI,DWE,DAS
C
      DIMENSION DUMMYA(420), DUMMYB(420)
      DIMENSION TEMP1(3,3), TEMP2(3,3)
      dimension djwa(3,3),djwb(3,3)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XLST01.INC'
      INCLUDE 'XWORK.INC'
      INCLUDE 'XWORKA.INC'
C
      INCLUDE 'XRTLSC.INC'
      COMMON /DRWORK/ DAA(20,20),DAR(21),DAI(20,20),DWE(60),DAS(20)
      INCLUDE 'XIOBUF.INC'
C
C
      EQUIVALENCE (DUMMYA(1),AA(1,1)), (DUMMYB(1),DV(1,1))
      EQUIVALENCE (TEMP1(1,1),DUMMYA(1)), (TEMP2(1,1),DUMMYA(10))
C
C----- USE SYSTEM-WIDE CONVENTION
      RAD =RTD
      IRTLS=-1
C--OUTPUT AN INITIAL CAPTION
      IF (IMODE.GT.0) THEN
         CALL XPRTCN
         IF (ISSPRT.EQ.0) WRITE (NCWU,50)
         WRITE (CMON,50)
         CALL XPRVDU (NCVDU,1,0)
50       FORMAT (' Analysis of rigid body motion')
         IF (ISSPRT.EQ.0) WRITE (NCWU,100) CF
         WRITE (CMON,100) CF
         CALL XPRVDU (NCVDU,1,0)
100      FORMAT (' Input centre of libration (crystal fractions) ',4X,
     1    3F8.4)
      END IF
C---SET UP MATRIX TO ORTHOGONALISE COORDINATES
      K=L1O1
      DO 150 I=1,3
         DO 150 J=1,3
         AO(I,J)=STORE(K)
         WA(I,J)=0.
150      K=K+1
C---SET UP MATRIX TO ORTHOGONALISE U'S
      A=COS(STORE(L1P1+3))
      B=COS(STORE(L1P1+4))
      C=COS(STORE(L1P1+5))
      D=1.+2.*A*B*C-A*A-B*B-C*C
      D=SQRT(D)
      WA(1,1)=SIN(STORE(L1P1+3))/(D*STORE(L1P1))
      WA(2,2)=SIN(STORE(L1P1+4))/(D*STORE(L1P1+1))
      WA(3,3)=SIN(STORE(L1P1+5))/(D*STORE(L1P1+2))
      CALL XMLTMM (AO,WA,UO,3,3,3)
C---ZERO DERIVATIVES AND MATRICES
      CALL XZEROF (DUMMYA(1),420)
      CALL XZEROF (DUMMYB(1),420)
      DO 250 I=1,20
         DO 200 J=1,20
            DAA(J,I)=0.0D0
200      CONTINUE
250   CONTINUE
C---CALCULATE LOCATION OF FIRST ATOM;  SET LOCATION OF
C   ORTHOGONAL COORDINATES
      JP=JBASE
      JO=LBASE
C----- IF ORIGINAL CENTRE IS 0,0,0 COMPUTE C.OF.G
      IF (ABS(CF(1))+ABS(CF(2))+ABS(CF(3))-.000001) 300,300,450
300   CONTINUE
      CF(1)=0.
      CF(2)=0.
      CF(3)=0.
C---- CYCLE THROUGH ATOM LIST TO GET C.OF.G
      JB=JP+4
      DO 350 JA=1,NATOM
C----- INCLUDE ISOTROPIC ATOMS AT THIS STAGE
         CF(1)=CF(1)+STORE(JB)
         CF(2)=CF(2)+STORE(JB+1)
         CF(3)=CF(3)+STORE(JB+2)
         JB=JB+ISTEP
350   CONTINUE
      CF(1)=CF(1)/FLOAT(NATOM)
      CF(2)=CF(2)/FLOAT(NATOM)
      CF(3)=CF(3)/FLOAT(NATOM)
      IF (IMODE.GT.0) THEN
         IF (ISSPRT.EQ.0) WRITE (NCWU,400) CF
cfeb08         WRITE (NCAWU,400) CF
         WRITE (CMON,400) CF
         CALL XPRVDU (NCVDU,1,0)
400      FORMAT (' Centre of gravity, used as centre of libration',4X,
     1    3F8.4)
      END IF
450   CONTINUE
C------ ORTHOGONALISE CENTRE OF LIBRATION
      CALL XMLTMM (AO,CF,CO,3,3,1)
C---CYCLE THROUGH ATOM LIST
      JB=JP
      NATOM2=0
      DO 900 JA=1,NATOM
C----- ORTHOGONAL COORDINATES AT JO
         CALL XMLTMM (AO,STORE(JB+4),STORE(JO),3,3,1)
C---CHECK IF ATOM IS ISOTROPIC
         IF (ABS(STORE(JB+3))-UISO) 600,500,500
500      CONTINUE
         IF (IMODE.GT.0) THEN
            IF (ISSPRT.EQ.0) WRITE (NCWU,550) STORE(JB),STORE(JB+1)
550         FORMAT (' Atom  ',A4,F5.0,'  is isotropic and has been',
     1      'ignored')
         END IF
         GO TO 850
600      CONTINUE
         NATOM2=NATOM2+1
C---ORTHOGONALIZE U'S, STORING AS WC
         CALL RSUB10 (WB,STORE(JB+7))
         CALL XMLTMM (UO,WB,WA,3,3,3)
         CALL XMLTMT (WA,UO,WB,3,3,3)
         CALL RSUB09 (WB,WC)
C---SET UP DERIVATIVES FOR THIS ATOM
         CALL RSUB08 (JO)
C---ACCUMULATE L.H.S. AS AA, R.H.S. AS AB
         DO 700 I=1,6
            DO 650 J=1,20
               DAI(I,J)=DBLE(DV(I,J))
650         CONTINUE
700      CONTINUE
         DO 800 N=1,6
            DO 800 I=1,20
            DO 750 J=I,20
750            DAA(I,J)=DAA(I,J)+DAI(N,I)*DAI(N,J)
800         AB(I)=AB(I)+DV(N,I)*WC(N)
C---RESET COUNTERS
850      CONTINUE
         JB=JB+ISTEP
         JO=JO+3
900   CONTINUE
      IF (NATOM2.LT.4) THEN
         WRITE (CMON,950) NATOM2
         CALL XPRVDU (NCVDU,1,0)
950      FORMAT (' Insufficient anisotropic atoms for tls -',I5)
         GO TO 2650
      END IF
C----- RESTORE JO
      JO=LBASE
C----- SCALE THE NORMAL MATRIX TO GIVE DIAGONAL ELEMENTS OF 1.
C     FIND THE SCALE FACTORS , MAXIMUM=100
      DO 1000 I=1,20
         DAS(I)=1.0D0/DMAX1(DSQRT(DAA(I,I)),.01D0)
1000  CONTINUE
C---FILL OUT AA
      DO 1050 I=1,20
C---- RHS
         AB(I)=AB(I)*SNGL(DAS(I))
         DO 1050 J=1,I
         DAA(J,I)=DAA(J,I)*DAS(I)*DAS(J)
         DAA(I,J)=DAA(J,I)
1050  CONTINUE
C---SOLVE NORMAL EQUATIONS, STORING INVERSE MATRIX AS AI AND RESULTS AS
      CALL RLTNT
C----- RESCALE THE RESULTS
      DO 1100 I=1,20
         AR(I)=AR(I)*SNGL(DAS(I))
1100  CONTINUE
C---SET UP L-, T-, AND S-TENSORS FROM AR; CALCULATE LIBRATIONAL CORRECTI
      CALL RSUB10 (AT,AR(1))
      CALL RSUB10 (AL,AR(7))
      AR(21)=-AR(13)-AR(17)
C----- SAVE FOR POSSIBLE USER MODIFICATION
      CALL XMOVE(AT,SAVET,9)
      CALL XMOVE(AL,SAVEL,9)
      CALL XMOVE(AR(13),SAVES,9)
      CALL XMOVE(CF,SAVEC,3)
C
C----- SKIP REST IF ONLY AFTER 'AR'
      IF (IMODE.LE.0) GO TO 2600
      K=13
C--- CONVERT TO DEGREES
      T=0.
      DO 1150 I=1,3
         T=T+AL(I,I)
         DO 1150 J=1,3
         AQ(I,J)=-0.5*AL(I,J)
         AS(I,J)=RAD*AR(K)
         AL(I,J)=RAD*RAD*AL(I,J)
         WA(I,J)=AL(I,J)
1150     K=K+1
      DO 1200 I=1,3
1200     AQ(I,I)=AQ(I,I)+1.+0.5*T
C---OUTPUT T, L, S
      IF (ISSPRT.EQ.0) WRITE (NCWU,1250)
1250  FORMAT (//' Tensors with respect to the above centre',' and orthog
     1onal axes (A*, B'' and C)')
      CALL RSUB11 (1)
C---TRANSFORM TENSORS TO PRINCIPAL AXES OF L
      DO 1300 I=1,3
         DO 1300 J=1,3
         DAA(J,I)=DBLE(WA(J,I))
1300  CONTINUE
C      M=0
C      CALL F02ABF (DAA,20,3,DAR,DAI,20,DWE,M)
      INFO = 0
      CALL DSYEV('V','L',3,DAA,20,DAR,DWE,21,INFO)
      DO ITEMP2=1,3
        DO ITEMP3=1,3
          DAI(ITEMP2,ITEMP3) = DAA(ITEMP2,ITEMP3)
        END DO
      END DO

      DO 1350 I=1,3
         WD(I)=SNGL(DAR(I))
         DO 1350 J=1,3
         WB(J,I)=SNGL(DAI(J,I))
1350  CONTINUE
      DO 1400 J=1,3
         I=NORM3(WB(1,J))
1400  CONTINUE
      D=XDETR3(WB)
      D=SIGN(1.,D)
C--MAKE SURE THAT THE MATRIX IS RIGHT HANDED
      DO 1450 I=1,3
         DO 1450 J=1,3
1450     WB(I,J)=WB(I,J)*D
C--PRINT THE LATENT ROOTS OF THE 'L' MATRIX
      I=L1P1
      DO 1550 J=1,3
         K=L1O1+J
         DO 1500 L=1,3
            TEMP2(L,J)=STORE(K-1)/STORE(I)
            K=K+3
1500     CONTINUE
         I=I+1
1550  CONTINUE
C--COMPUTE THE COSINES W.R.T. THE CRYSTALS SYSTEM IN FRACTIONS
      CALL XMLTTM (WB(1,1),TEMP2(1,1),TEMP1(1,1),3,3,3)
C--COMPUTE THE SAME TRANSFORMATION INTO ANGSTROM
      CALL XMLTTT (WB(1,1),STORE(L1O1),TEMP2(1,1),3,3,3)
C--PRINT THE DATA THUS ACQUIRED
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,1600) (WD(I),(WB(J,I),J=1,3),I=1,3),((TEMP2(I,J),J=
     1    1,3),(TEMP1(I,J),J=1,3),I=1,3)
      END IF
1600  FORMAT (' Rotation matrix from orthogonal axes',' to coordinate sy
     1stem defined by L'//' Latent roots',13X,'L',9X,'M',9X,'N',9X,'w.r.
     2t. a*, b'' and c'//3(1X,F10.3,9X,3F10.5/)//' Rotation matrices fro
     3m crystal fractions',' w.r.t. libration centre '/,' to axial syste
     4m  defined by L',/,15X,' Angstrom',31X,'Fractions',//,3(4X,3F10.4,
     511X,3F10.5/))
C----- SAVE EIGENVECTORS
      CALL XMOVE(WB,STOREE,9)
C----- COPY MATRICES FOR SAVING IN LIST 20
      CALL XMOVE(WB,STORE(KWORK+21),9)
      CALL XTRANS (WB(1,1),STORE(KWORK+9),3,3)
      CALL XMLTMT (STORE(KWORK+9),STORE(L1O1),STORE(KWORK),3,3,3)
      I=KINV2(3,STORE(KWORK),STORE(KWORK+9),9,0,STORE(KWORK+18),
     1STORE(KWORK+18),3)
      CALL XMOVE(WB,SAVEE,9)
      CALL XMOVE (CF(1),STORE(KWORK+18),3)
      CALL XMLTMM (AL,WB,WA,3,3,3)
      CALL XMLTTM (WB,WA,AL,3,3,3)
      CALL XMLTMM (AT,WB,WA,3,3,3)
      CALL XMLTTM (WB,WA,AT,3,3,3)
      CALL XMLTMM (AS,WB,WA,3,3,3)
      CALL XMLTTM (WB,WA,AS,3,3,3)
C---OUTPUT NEW TENSORS
      IF (ISSPRT.EQ.0) WRITE (NCWU,1750)
      WRITE(CMON,1750)
#if defined(_GID_) || defined(_GIL_)  || defined(_MAC_)
      CALL ZMORE(CMON,0)
#endif
#if defined(_WXS_) 
      CALL ZMORE(CMON,0)
#endif
1750  FORMAT (' Tensors with respect to principal axes of L')
      CALL RSUB11 (2)
C
C---SHIFT ORIGIN TO MAKE S SYMMETRIC
      WD(1)=RAD*(AS(2,3)-AS(3,2))/(AL(2,2)+AL(3,3))
      WD(2)=RAD*(AS(3,1)-AS(1,3))/(AL(1,1)+AL(3,3))
      WD(3)=RAD*(AS(1,2)-AS(2,1))/(AL(1,1)+AL(2,2))
      CALL XMLTTM (WB,AO,WA,3,3,3)
      I=KINV2(3,WA,WB,9,1,WD,WC,3)
      DO 1650 I=1,3
         CF(I)=CF(I)+WC(I)
         WA(I,I)=0.
1650  CONTINUE
      WRITE (CMON,1700) CF
      IF (ISSPRT.EQ.0) WRITE (NCWU,'(/A)') CMON(1)(:)
      CALL XPRVDU (NCVDU,1,0)
1700  FORMAT (' Centre for which s is symmetric :             ',4X,3F8.
     14)
C---TRANSFORM TENSORS TO NEW ORIGIN
      WA(1,2)=WD(3)/RAD
      WA(1,3)=-WD(2)/RAD
      WA(2,3)=WD(1)/RAD
      WA(2,1)=-WA(1,2)
      WA(3,1)=-WA(1,3)
      WA(3,2)=-WA(2,3)
C--- T=T+S'P'
      CALL XMLTTT (AS,WA,WB,3,3,3)
      CALL RADDMM (AT,WB)
C--- S=S+LP'
      CALL XMLTMT (AL,WA,WB,3,3,3)
      CALL RADDMM (AS,WB)
C--- T=T+PS
      CALL XMLTMM (WA,AS,WB,3,3,3)
      CALL RADDMM (AT,WB)
C---CALCULATE AND OUTPUT AXIAL SHIFTS
      IF (ISSPRT.EQ.0) WRITE (NCWU,1800)
1800  FORMAT (' Axial displacements for which S becomes diagonal',2X,'(A
     1ngstroms along principal axes of L)'/1X,32X,'Shift directions'/1X,
     229X,'1',9X,'2',9X,'3')
      A=-AS(1,3)/AL(1,1)
      B=AS(1,2)/AL(1,1)
      C=AS(2,3)/AL(2,2)
      D=-AS(2,1)/AL(2,2)
      E=-AS(3,2)/AL(3,3)
      F=AS(3,1)/AL(3,3)
      IF (ISSPRT.EQ.0) WRITE (NCWU,1850) A,B,C,D,E,F
1850  FORMAT (/1X,16X,'Axis 1',10X,2F10.2//1X,16X,'Axis 2',F10.2,10X,
     1F10.2//1X,16X,'Axis 3',2F10.2)
C---CALCULATE REDUCED T AND S, AND SCREW PITCHES
      DO 1950 I=1,3
         DO 1900 J=1,3
            DO 1900 K=1,3
1900        AT(I,J)=AT(I,J)-AS(K,I)*AS(K,J)/AL(K,K)
1950     AT(I,I)=AT(I,I)+AS(I,I)*AS(I,I)/AL(I,I)
      DO 2050 I=1,3
         WD(I)=AS(I,I)/AL(I,I)
         DO 2050 J=1,3
         IF (I-J) 2000,2050,2000
2000     AS(I,J)=0.
2050  CONTINUE
C---OUTPUT FINAL REDUCED TENSORS
      IF (ISSPRT.EQ.0) WRITE (NCWU,2100)
      WRITE (CMON,2100)
      CALL XPRVDU (NCVDU,1,0)
2100  FORMAT (' Final reduced tensors')
      CALL RSUB11 (2)
C---OUTPUT SCREW PITCHES
      IF (ISSPRT.EQ.0) WRITE (NCWU,2150) WD
      WRITE (CMON,2150) WD
      CALL XPRVDU (NCVDU,1,0)
2150  FORMAT (' Screw pitches (angstrom/degree) :',12X,3F7.2)
C---INVERT UO TO GET MATRIX FOR CONVERSION OF U'S BACK TO CRYSTAL AXES
      I=KINV2(3,UO,WA,9,0,WC,WD,3)
      CALL XMOVE (WA,UO,9)
C---CALCULATE AND OUTPUT OBSERVED AND CALCULATED TEMPERATURE FACTORS
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,2200)
      END IF
2200  FORMAT (' Observed and calculated temperature factors',3X,'(Crysta
     1l axes)'///1X,5X,'Code',5X,'Atom',2X,'Serial',7X,'X/A',6X,'Y/B',
     26X,'Z/C',10X,'U11',5X,'U22',5X,'U33',5X,'U23',5X,'U13',5X,'U12'//)
      JB=JP
      JC=LBASE
C--SET UP THE ACCUMULATION CONSTANTS FOR THE SCAN THROUGH THE ATOMS
      DELU=0.
      SUMU=0.
      DELS=0.
      SUMS=0.
      ANUMB=0.
C--LOOP OVER EACH ATOM IN TURN
      DO 2500 JA=1,NATOM
         IF (ABS(STORE(JB+3))-UISO) 2250,2450,2450
C--CHECK IF THE ATOM IS ISOTROPIC
2250     CONTINUE
         JD=JB+4
         JE=JB+12
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,2300) JA,STORE(JB),STORE(JB+1),(STORE(J),J=JD,
     1       JE)
         END IF
2300     FORMAT (1X,I8,6X,A4,F7.0,4X,3F9.4,4X,6F8.3)
         CALL RSUB08 (JC)
         CALL XMLTMM (DV,AR,WC,6,20,1)
         CALL RSUB10 (WA,WC)
         CALL XMLTMM (UO,WA,WB,3,3,3)
         CALL XMLTMT (WB,UO,WA,3,3,3)
         CALL RSUB09 (WA,WC)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,2350) WC
         END IF
2350     FORMAT (1X,60X,6F8.3/)
         JF=JB+7
C--ACCUMULATE THE TOTALS FOR THIS ATOM
         DO 2400 K=1,6
            DEL=ABS(STORE(JF)-WC(K))
            SUM=ABS(STORE(JF))
            JF=JF+1
            DELS=DELS+DEL*DEL
            SUMS=SUMS+SUM*SUM
            DELU=DELU+DEL
            SUMU=SUMU+SUM
            ANUMB=ANUMB+1.
2400     CONTINUE
2450     CONTINUE
         JB=JB+ISTEP
         JC=JC+3
2500  CONTINUE
C--COMPUTE AND PRINT THE TOTALS FOR ALL THE ATOMS
      UFAC=DELU/SUMU*100.
      SFAC=SQRT(DELS/SUMS)*100.
      RMSU=SQRT(DELS/ANUMB)
      IF (ISSPRT.EQ.0) WRITE (NCWU,2550) UFAC,SFAC,RMSU
      WRITE (CMON,2550) UFAC,SFAC,RMSU
      CALL XPRVDU (NCVDU,4,0)
2550  FORMAT (/6X,
     1'          R1-Factor for U''S = ',F7.2,/6X,
     2'         R^2-Factor for U''S = ',F7.2,/6X,
     3' R.M.S. discrepancy for U''S = ',2F7.4)
C
2600  CONTINUE
      IRTLS=1
2650  CONTINUE
      RETURN
      END
CODE FOR RSUB08
      SUBROUTINE RSUB08 (JJ)
C---CALCULATE DERIVATIVES FOR ATOM WHOSE ORTHOGONAL COORDINATES
C   ARE STORED AT JJ
C
C--
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORK.INC'
      INCLUDE 'XRTLSC.INC'
C
      CALL XZEROF (DV(1,1),120)
      X=STORE(JJ)-CO(1)
      Y=STORE(JJ+1)-CO(2)
      Z=STORE(JJ+2)-CO(3)
      A=X*X
      B=Y*Y
      C=Z*Z
      D=Y*Z
      E=X*Z
      F=X*Y
C---DERIVATIVES W.R.T. T'S
      DO 50 I=1,6
50       DV(I,I)=1.
C---DERIVATIVES W.R.T. L'S
      DV(1,8)=C
      DV(1,9)=B
      DV(1,10)=-2.*D
      DV(2,7)=C
      DV(2,9)=A
      DV(2,11)=-2.*E
      DV(3,7)=B
      DV(3,8)=A
      DV(3,12)=-2.*F
      DV(4,7)=-D
      DV(4,10)=-A
      DV(4,11)=F
      DV(4,12)=E
      DV(5,8)=-E
      DV(5,10)=F
      DV(5,11)=-B
      DV(5,12)=D
      DV(6,9)=-F
      DV(6,10)=E
      DV(6,11)=D
      DV(6,12)=-C
C---DERIVATIVES W.R.T. S'S
      DV(1,16)=2.*Z
      DV(1,19)=-2.*Y
      DV(2,14)=-2.*Z
      DV(2,20)=2.*X
      DV(3,15)=2.*Y
      DV(3,18)=-2.*X
      DV(4,13)=-X
      DV(4,14)=Y
      DV(4,15)=-Z
      DV(4,17)=-2.*X
      DV(5,13)=2.*Y
      DV(5,16)=-X
      DV(5,17)=Y
      DV(5,18)=Z
      DV(6,13)=-Z
      DV(6,17)=Z
      DV(6,19)=X
      DV(6,20)=-Y
      RETURN
      END
CODE FOR RSUB09
      SUBROUTINE RSUB09 (UA,UB)
C
C
      DIMENSION UA(3,3), UB(6)
C
      UB(1)=UA(1,1)
      UB(2)=UA(2,2)
      UB(3)=UA(3,3)
      UB(4)=UA(2,3)
      UB(5)=UA(1,3)
      UB(6)=UA(1,2)
      RETURN
      END
CODE FOR RSUB10
      SUBROUTINE RSUB10 (UA,UB)
C
C
      DIMENSION UA(3,3), UB(6)
C
      UA(2,3)=UB(4)
      UA(1,3)=UB(5)
      UA(1,2)=UB(6)
      DO 50 I=1,3
         UA(I,I)=UB(I)
         K=MIN0(3,I+1)
         DO 50 J=K,3
50       UA(J,I)=UA(I,J)
      RETURN
      END
CODE FOR RSUB11
      SUBROUTINE RSUB11 (MON)
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XWORK.INC'
      INCLUDE 'XRTLSC.INC'
      INCLUDE 'XIOBUF.INC'
C
      IF (ISSPRT.EQ.0) WRITE (NCWU,50)
      IF (MON.EQ.2) THEN
         WRITE (CMON,50)
         CALL XPRVDU (NCVDU,3,0)
      END IF
50    FORMAT (/1X,14X,'L',27X,'T',26X,'S'/)
      DO 100 I=1,3
         WRITE (CMON,150) (AL(I,J),J=1,3),(AT(I,J),J=1,3),(AS(I,J),
     1   J=1,3)
         IF (ISSPRT.EQ.0) WRITE (NCWU,'(A)') CMON(1)(:)
         IF (MON.EQ.2) CALL XPRVDU (NCVDU,1,0)
100   CONTINUE
150   FORMAT ((3(3F9.4,X)))
      CALL XLINES
      RETURN
      END
C
CODE FOR RADDMM
      SUBROUTINE RADDMM (XX,YY)
C
C
      DIMENSION XX(3,3), YY(3,3)
C
      INCLUDE 'XWORK.INC'
C
      DO 50 I=1,3
         DO 50 J=1,3
50       XX(I,J)=XX(I,J)+YY(I,J)
      RETURN
      END
CODE FOR RDSTAN
      SUBROUTINE RDSTAN (JBASE,LBASE,NATOM,ISTEP)
C
C----- CORRECTED DISTANCE AND ANGLES
C      JBASE - FRACTIONAL COORDS
C      LBASE - ORTHORONAL COORDS
C
      INCLUDE 'ISTORE.INC'
      DIMENSION IKEY(400)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRTLSC.INC'
C
      INCLUDE 'QSTORE.INC'
      EQUIVALENCE (IKEY(1),WA(1,1))
C
C
C--INITIAL CAPTIONS
      CALL XPRTCN
      IF (ISSPRT.EQ.0) THEN
         WRITE (NCWU,50) DL,DA
      END IF
50    FORMAT (' Bond lengths and angles :  (1) uncorrected,  ','(2) corr
     1ected for libration',///,' Distance limit',F8.3//,' Angle limit',
     2F11.3)
C---TRANSFER UNCORRECTED ORTHOGONAL COORDINATES TO RELATIVE
C   LOCATIONS 7-9, CORRECTED COORDINATES TO 10-12
      JP=JBASE
      JO=LBASE
      JB=JP
      JC=JO
      DO 100 JA=1,NATOM
         STORE(JB+7)=STORE(JC)
         STORE(JB+8)=STORE(JC+1)
         STORE(JB+9)=STORE(JC+2)
         CALL XMLTMM (AQ,STORE(JB+7),STORE(JB+10),3,3,1)
         JB=JB+ISTEP
         JC=JC+3
100   CONTINUE
C---DISTANCE/ANGLES ROUTINE
C
C---START ATOM CYCLE
      JB=JP
      DO 1300 JA=1,NATOM
         JQ=JO-1
         JR=0
         JZ=0
         M=JB+4
         N=JB+6
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,150) STORE(JB),STORE(JB+1),(STORE(K),K=M,N)
         END IF
150      FORMAT (////,' Distances about atom  ',A4,F5.0,10X,'X/A =',F8.
     1    4,5X,'Y/B =',F8.4,5X,'Z/C =',F8.4/)
         JE=JP
         DO 700 JD=1,NATOM
            STORE(JE+2)=RDIST(JE+7,JB+7)
            STORE(JE+3)=RDIST(JE+10,JB+10)
            IF (JD-JA) 200,650,200
200         IF (STORE(JE+2)-DA) 250,250,300
250         JQ=JQ+1
            ISTORE(JQ)=JE
            JR=JR+1
            IKEY(JR)=JD
300         IF (JD-JA) 650,650,350
350         IF (STORE(JE+2)-DL) 400,400,650
400         IF (JZ) 450,450,550
450         JZ=1
            IF (ISSPRT.EQ.0) THEN
               WRITE (NCWU,500)
            END IF
500         FORMAT (2X,'Code',4X,'Atom',2X,'Serial',/)
550         CONTINUE
            JU=JE+3
            IF (ISSPRT.EQ.0) THEN
               WRITE (NCWU,600) JD,(STORE(J),J=JE,JU)
            END IF
600         FORMAT (1X,I4,5X,A4,F7.0,2X,2F10.3)
650         CONTINUE
            JE=JE+ISTEP
700      CONTINUE
         IF (DA-0.001) 1250,1250,750
750      CONTINUE
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,800) STORE(JB),STORE(JB+1)
         END IF
800      FORMAT (//,' Angles about atom  ',A4,F5.0/)
         IF (JR-1) 1250,1250,850
850      CONTINUE
         JL=1
         JS=JO
900      CONTINUE
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,500)
         END IF
         JK=JL
         JE=ISTORE(JS)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,950) IKEY(JK),STORE(JE),STORE(JE+1)
         END IF
950      FORMAT (1X,I4,5X,A4,F7.0,2X,5(F10.2,F8.2))
         JW=JS+1
         DO 1050 JM=JW,JQ
            JE=ISTORE(JM)
            JT=JQ
            JV=MIN0(JM-1,JS+4)
            JK=JK+1
            DO 1000 JN=JS,JV
               JF=ISTORE(JN)
               D=RDIST(JE+7,JF+7)
               E=RDIST(JE+10,JF+10)
               JT=JT+2
               STORE(JT-1)=RANGLE(STORE(JE+2),D,STORE(JF+2))
               STORE(JT)=RANGLE(STORE(JE+3),E,STORE(JF+3))
1000        CONTINUE
            JU=JQ+1
            IF (ISSPRT.EQ.0) THEN
               WRITE (NCWU,950) IKEY(JK),STORE(JE),STORE(JE+1),(STORE(K)
     1          ,K=JU,JT)
            END IF
1050     CONTINUE
         JU=MIN0(JK-1,JL+4)
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,1100) (IKEY(M),M=JL,JU)
         END IF
1100     FORMAT (/2X,'Code',11X,5(15X,I3))
         JS=JS+5
         IF (JQ-JS) 1250,1250,1150
1150     JL=JL+5
         IF (ISSPRT.EQ.0) THEN
            WRITE (NCWU,1200)
         END IF
1200     FORMAT (//,' Continuation',/)
         GO TO 900
1250     CONTINUE
         JB=JB+ISTEP
1300  CONTINUE
      RETURN
      END
CODE FOR RDIST
      FUNCTION RDIST (MA,MB)
C--CALCULATES DISTANCE BETWEEN TWO ATOMS WHOSE ORTHOGONAL COORDINATES
C   ARE STORED FROM MA AND FROM MB
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORK.INC'
C
      X=STORE(MB)-STORE(MA)
      Y=STORE(MB+1)-STORE(MA+1)
      Z=STORE(MB+2)-STORE(MA+2)
      RDIST=SQRT(X*X+Y*Y+Z*Z)
      RETURN
      END
CODE FOR RANGLE
      FUNCTION RANGLE (D1,D2,D3)
C---CALCULATES ANGLE A-B-C WHERE A-B=D1, B-C=D3, A-C=D2
C
      INCLUDE 'XWORK.INC'
      INCLUDE 'XCONST.INC'
C
      U=-(D2*D2-D1*D1-D3*D3)/(2.*D1*D3)
      T=180.*ACOS(U)/PI
      IF (T) 50,100,100
50    T=T+360.
100   IF (T-180.) 200,200,150
150   T=360.-T
200   RANGLE=T
      RETURN
      END
CODE FOR RLTNT
      SUBROUTINE RLTNT
C
      DOUBLE PRECISION DAA,DAR,DAI,DWE,DAS
C
      DIMENSION IQ1(1), IB1(1), IW(21)
      DIMENSION WE(27)
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XWORK.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRTLSC.INC'
      COMMON /DRWORK/ DAA(20,20),DAR(21),DAI(20,20),DWE(60),DAS(20)
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      EQUIVALENCE (IW(1),AA(1,1))
      EQUIVALENCE (IB1(1),IB), (IQ1(1),IQ)
C
      EQUIVALENCE (WE(1),WA(1,1))
C--EXTRACT THE LATENT ROOTS AND VECTORS OF THE NORMAL MATRIX
c      M=0
c      CALL F02ABF (DAA,20,20,DAR,DAI,20,DWE,M)
      INFO = 0
      CALL DSYEV('V','L',20,DAA,20,DAR,DWE,60,INFO)
      DO ITEMP3=1,20
        DO ITEMP2=1,20
          DAI(ITEMP2,ITEMP3) = DAA(ITEMP2,ITEMP3)
        END DO
      END DO
      DO 100 I=1,20
         AR(I)=SNGL(DAR(I))
         DO 50 J=1,20
            AI(J,I)=SNGL(DAI(J,I))
            AA(J,I)=SNGL(DAA(J,I))
50       CONTINUE
100   CONTINUE
C--TRANSFORM THE R.H.S.
      CALL XMLTTM (AI,AB,WE,20,20,1)
      AR(21)=AR(20)
      L=0
C--LOOP OVER EACH EIGENVALUE AND CHECK ITS SIZE AND RATIO TO THE LAST
      DO 650 I=1,20
         J=21-I
         IF (AR(J)-TESTEV) 150,150,350
C--THE EIGENVALUE HAS TOO SMALL A VALUE
150      CONTINUE
         L=J
         DO 200 K=1,J
            WE(K)=0.
200      CONTINUE
         IF (ISSPRT.EQ.0) WRITE (NCWU,250) J,IB,IQ1(1)
250      FORMAT (//' CRYSTALS is having difficulties withe the analysis'
     1    ,//' The inverse of the eigenvalues from 1 to ',I2,'  have bee
     2n set to zero',A1,'and marked by a ''',A1,''' in the listing below
     3')
         WRITE (CMON,300) J
         CALL XPRVDU (NCVDU,4,0)
300      FORMAT (/' CRYSTALS is having difficulties with the the analysi
     1s',/1X,I2,' eigenvalues undefined. See the main listing file'/)
         GO TO 700
C--CHECK THE RATIO TO THE LAST
350      CONTINUE
         IF (J-20) 400,500,500
400      CONTINUE
         IF (AR(J)/AR(J+1)-TESTER) 150,150,450
450      CONTINUE
C----- SHOULD WE REJECT THIS ANYWAY
         IF (NDEL) 600,600,500
500      CONTINUE
         DO 550 K=1,NDEL
            IF (J-JDEL(K)) 550,150,550
550      CONTINUE
C--COMPUTE THE TERM FOR THIS CORRECT VALUE
600      CONTINUE
         WE(J)=WE(J)/AR(J)
650   CONTINUE
C--CHECK IF THE EIGENVALUES AND VECTORS SHOULD BE PRINTED
      IF (IPRINT) 1050,1050,700
C--PRINT THE VALUES
700   CONTINUE
      IF (ISSPRT.EQ.0) WRITE (NCWU,750)
750   FORMAT (//,' Eigenvalues and eigenvectors of the normal matrix',
     14X,'(Vector components multiplied by 1000)',//,1X,21X,'T11  T22  T
     233  T23  T13  T12  L11  L22  L33  L23  L13  L12','  S11  S12  S13
     3 S21  S22  S23  S31  S32',/)
      DO 1000 J=1,20
         DO 800 I=1,20
800         IW(I)=NINT(1000.*AI(I,J))
         CALL XMOVE (IB1(1),IW(21),1)
C--CHECK IF WE HAVE EXHAUSTED THE DELETED EIGENVALUES
         IF (L-J) 900,850,850
C--THIS ONE WAS DELETED
850      CONTINUE
         CALL XMOVE (IQ1(1),IW(21),1)
C--PRINT THE VALUES
900      CONTINUE
         IF (ISSPRT.EQ.0) WRITE(NCWU,950)J,AR(J),IW(21),(IW(K),K=1,20)
950      FORMAT (1X,I3,E12.3,1X,A1,2X,20I5)
1000  CONTINUE
C---TRANSFORM BACK TO ORIGINAL PARAMETER SET
1050  CONTINUE
      CALL XMLTMM (AI,WE,AR,20,20,1)
      RETURN
      END
CODE FOR XPANDU
      SUBROUTINE XPANDU(A,B)
C      EXPAND THE VECTOR A INTO THE TENSOR B
      DIMENSION A(6), B(9)
      B(1) = A(1)
      B(2) = A(6)
      B(3) = A(5)
      B(4) = A(6)
      B(5) = A(2)
      B(6) = A(4)
      B(7) = A(5)
      B(8) = A(4)
      B(9) = A(3)
      RETURN
      END
cCODE FOR XCOMPU
c      SUBROUTINE XCOMPU(B,A)
cC      COMPRESS THE TENSOR B INTO THE VECTOR A
c      DIMENSION A(6), B(9)
c      A(1) = B(1)
c      A(2) = B(5)
c      A(3) = B(9)
c      A(4) = B(8)
c      A(5) = B(7)
c      A(6) = B(5)
c      RETURN
c      END
C

