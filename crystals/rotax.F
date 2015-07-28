C
C
CODE FOR XROTAX
      SUBROUTINE XROTAX
C ROTAX : Simon Parsons & Bob Gould, University of Edinburgh
C Version 26th November, 2001
C Crystals implementation - blame Richard Cooper.
      use unitcell_mod
      use math_mod, only: determinant3x3
      implicit none

      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      !INCLUDE 'XLST01.INC'
      INCLUDE 'XLST05.INC'
      INCLUDE 'XLST23.INC'
      INCLUDE 'XLST06.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'QSTORE.INC'
      integer, DIMENSION(3) :: HKL
      REAL INVM(9), INVM2(9), MRES(9), SROT(9), PHID, PHIR
      REAL P(3,3,3), V, DISAG(3,30)
      CHARACTER*1 dorr
      INTEGER PORI
      LOGICAL NOTPTG
      
      real bottom, fabs, fc, fo, fos
      integer hk, i, iaddd, iaddl, iaddr
      integer icombf, icomsz
      integer ierabo, iercat, iererr, iernop, ierprg, iersev
      integer iersfl, ierunw, ierwrn, ifsq, ixap
      integer ipunch, istat, iuln6, iversn, j, jsrtby
      integer kh, kk, kl, lsort, ltempr, mdsort, msort, n6acc, nsort
      real rfact, scale, sigma, tol, top, wbot, wdel, wfo, wrfac, wt
      real wtop, xvalur
      
      integer, external :: kstall, krddpv, khuntr, kchnfl, kfnr

      DATA ICOMSZ / 7 /
      DATA IVERSN /100/

C -- SET THE TIMING AND READ THE CONSTANTS

      CALL XTIME1 ( 2 )
      CALL XCSAE

C -- ALLOCATE SPACE TO HOLD RETURN VALUES FROM INPUT
      ICOMBF = KSTALL( ICOMSZ )
      CALL XZEROF (STORE(ICOMBF), ICOMSZ)
      I = KRDDPV ( ISTORE(ICOMBF) , ICOMSZ )
      IF ( I .LT. 0 ) GO TO 9910
C----- SET HE REFLECTION LISTING TYPE
      IULN6 = 6
C
C -- SET LIST TYPE AND LISTING LEVEL FLAG

C Store tolerance (only show fom's below this limit)
      TOL = STORE(ICOMBF)
cC Store sigma multiplier for rejecting outlying reflections
c      REJ(1) = STORE(ICOMBF+1)
cC Store minimum number of reflections to throw away anyway.
c      REJ(2) = ISTORE(ICOMBF+2)
cC Store maximum limit on number of reflections to throw away.
c      REJ(3) = ISTORE(ICOMBF+3)
cC Store the rotation angle
      PHID = STORE(ICOMBF+4)
      PORI = ( ISTORE(ICOMBF+5) * 2 ) - 1
      IPUNCH = ISTORE(ICOMBF+6)
      
      PHIR = PHID/57.295779

c      CALL MATS(PHI,PORI,SROT)

      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 2,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL02
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF (KHUNTR (23,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL23
      CALL XFAL06 (IULN6, 0)


      WRITE ( CMON , 1)
     1' R O T A X : Simon Parsons & Bob Gould, University of Edinburgh',
     2' with additions by Richard Cooper (Oxford) and Louis Farrugia (Gl
     3asgow)',
     3' Version 26th November, 2001'

      CALL XPRVDU(NCVDU, 8,0)

      WRITE (NCWU,1)
     1' R O T A X : Simon Parsons & Bob Gould, University of Edinburgh',
     2' with additions by Richard Cooper (Oxford) and Louis Farrugia (Gl
     3asgow)',
     3' Version 26th November, 2001'

      IF (PORI .GE. 1) THEN
        WRITE ( CMON , 4) PHID
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCWU , 4) PHID
      ELSE
        WRITE ( CMON , 5) PHID
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCWU , 5) PHID
      END IF

      WRITE ( CMON , 2) TOL
      CALL XPRVDU(NCVDU, 2,0)
      WRITE ( NCWU , 2) TOL

c      WRITE ( CMON , 3) NINT(REJ(2)),NINT(REJ(3)),REJ(1)
c      CALL XPRVDU(NCVDU, 5,0)
c      WRITE ( NCWU , 3) NINT(REJ(2)),NINT(REJ(3)),REJ(1)


      IF(IPUNCH.EQ.1)THEN
        WRITE(NCPU,'(f5.1,1X,I2)') PHID,PORI
      ENDIF

1     FORMAT(/,/,/,A,/,A,/,A,/,/)
4     FORMAT(' Symmetry element tested: ',f5.1,' degree rotation')
5     FORMAT(' Symmetry element tested: ',f5.1,' degree roto-inversion')

2     FORMAT(' Max figure of merit printed = ',f6.2,/,
     1      ' Largest index tested = 12')

C-- A BUFFER FOR ONE REFELCTION AND ITS Q VALUE
      LTEMPR = NFL
      MDSORT = 7
      NFL = KCHNFL(MDSORT)
C-- INITIALISE THE SORT BUFFER
      JSRTBY = -3
      NSORT = 30
C LSORT is set by function call.
C MDSORT is 7 (the length of record we are storing (h,k,l,q,fo2,fc2,sigma2).
C NSORT is 30, the number of records to keep.
C JSRTBY is 3, the offset of q (which we sort by) in the record.
C LTEMPR is the addr where we put new records before they are added.
C XVALUR is the smallest value in array. (To check if call is necessary).
C 1 is the sort type largest->smallest
      CALL SRTDWN(LSORT,MDSORT,NSORT, JSRTBY, LTEMPR, XVALUR,1)
      JSRTBY = 3

C
C -- SCAN LIST 6 FOR ACCEPTED REFLECTIONS
C
      SCALE = STORE(L5O)
      TOP = 0.0
      BOTTOM = 0.0
      WTOP = 0.0
      WBOT = 0.0
      IFSQ = ISTORE(L23MN+1)
      N6ACC = 0

      ISTAT = KFNR(0)

      DO WHILE ( ISTAT .GE. 0 )
        N6ACC = N6ACC + 1
        FO = STORE(M6+3)
        FC = SCALE * STORE(M6+5)
        WT = STORE(M6+4)

        CALL XSQRF(FOS, FO, FABS, SIGMA, STORE(M6+12))

        TOP = TOP + ABS (ABS(FO) - FC)
        BOTTOM = BOTTOM + ABS(FO)
        IF (IFSQ .GE. 0) THEN
C - FSQ REFINENENT
            WDEL = WT* (FO * ABS(FO) - FC*FC)
            WFO = WT* (FO * ABS(FO))
        ELSE
            WDEL = WT * (FO - FC)
            WFO = WT * FO
        ENDIF
        WTOP = WTOP + WDEL*WDEL
        WBOT = WBOT + WFO*WFO

        STORE(LTEMPR) = STORE(M6)
        STORE(LTEMPR+1) = STORE(M6+1)
        STORE(LTEMPR+2) = STORE(M6+2)
        STORE(LTEMPR+3) = ( FOS - (FC*FC) ) / SIGMA
        STORE(LTEMPR+4) = FOS 
        STORE(LTEMPR+5) = FC*FC
        STORE(LTEMPR+6) = SIGMA

        CALL SRTDWN(LSORT,MDSORT,NSORT,JSRTBY,LTEMPR,XVALUR,1)
        ISTAT = KFNR(0)
      END DO

C
C
C -- BEGIN OUTPUT
C
C----- COMPUTE AND STORE R-VALUES
      RFACT = 100. * TOP / BOTTOM
      IF (WBOT .LE. 0.0) THEN
        WRFAC = 0.0
      ELSE
        WRFAC = 100. * SQRT (WTOP / WBOT)
      ENDIF
      STORE(L6P+1) = RFACT
      STORE(L6P+2) = WRFAC
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1215 ) N6D , N6ACC
      WRITE ( NCAWU , 1215 ) N6D, N6ACC
      WRITE ( CMON , 1215 ) N6D, N6ACC
      CALL XPRVDU(NCVDU, 1,0)
1215  FORMAT ( 1X , 'List 6 contains ' , I5 , ' reflections' ,
     1 ' of which ' , I5 , ' are accepted by LIST 28')
C
C
C -- PRINT THE R VALUE ETC.
      J = NINT(STORE(L6P))
      M6P = L6P+2
      IF (ISSPRT .EQ. 0)
     1 WRITE ( NCWU , 1235 ) J , ( STORE(I+1) , I=L6P,M6P )
      WRITE ( NCAWU , 1235 ) J , ( STORE(I+1) , I=L6P,M6P )
      WRITE ( CMON , 1235 ) J , ( STORE(I+1) , I=L6P,M6P )
      CALL XPRVDU(NCVDU, 2,0)
1235  FORMAT (1X , 'After ' , I5 ,
     2 ' structure factor/refinement calculations ' , / ,
     3 1X , 'R = ' , F6.2 , 5X , 'Weighted R = ' , F6.2 ,
     4 5X , 'Minimisation function = ' , E15.6 )

      WRITE(NCWU,13)
      WRITE(CMON,13)
      CALL XPRVDU(NCVDU, 1,0)
      WRITE(NCWU,11)
      WRITE(CMON,11)
      CALL XPRVDU(NCVDU, 1,0)
13    FORMAT(/,' Reflections with greatest unexpected extra intensity:')
11    FORMAT('   h   k   l ',
     1                   '(Fo2-Fc2)/s     Fo^2        Fc^2       Sigma')
      HK=1
      DO MSORT = LSORT, LSORT+(MDSORT*(NSORT-1)), MDSORT
        WRITE ( CMON , '(3I4,F11.3,1X,3(F11.1,1X))' ) 
     1                    (NINT(STORE(MSORT+IXAP)),     IXAP=0,2),
     3 (                        STORE(MSORT+IXAP) ,     IXAP=3,6)
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCWU , '(3I4,F11.2,1X,3(F11.1,1X))' ) 
     1                    (NINT(STORE(MSORT+IXAP)),     IXAP=0,2),
     3 (                        STORE(MSORT+IXAP) ,     IXAP=3,6)
        DISAG(1,HK)=STORE(MSORT)
        DISAG(2,HK)=STORE(MSORT+1)
        DISAG(3,HK)=STORE(MSORT+2)
        HK = HK + 1
      END DO


      WRITE(NCWU,14)
      WRITE(CMON,14)
      CALL XPRVDU(NCVDU,16,0)

14    FORMAT(/' Each set of indices above is transformed by the'/
     2' printed rotation matrix. How far the transformed indices are'/
     3' from integral values is measured by the figure of merit. The'/
     4' figure of merit is defined as 1000 times the average '/
     5' deviation (in Ang-1) of transformed indices from their '/
     6' nearest reciprocal lattice node. ROTAX tries to minimise'/
     7' the f.o.m. by omitting up to 15 of the largest deviations. A'/
     8' small figure of merit means that most (or all) of the indices'/
     9' were transformed to integers and this makes it a likely '/
     1' candidate for a twin law. If only symmetry elements which'/
     2' occur in the point group of your crystal structure are'/
     3' printed then either your crystal is not a twin, or this'/
     4' program has not worked. Matrices which have a figure of merit'/
     5' less than 2 are marked with a row of asterisks: ***********'/)

      !v = sqrt ( xdetr3(store(L1M1)) )
      v = sqrt ( determinant3x3(unitcells(1)%rmetric()))
      call make_p(p,v)


C Instead of writing all planes out to a file, just
C loop through them all here:

      do KL=0,12

         IF (ISSTML .EQ. 4) THEN
            WRITE (CMON,1505) NINT ( KL / .12 )
1505        FORMAT ('^^CO SET PROGOUTPUT COMPLETE = ',I3)
            CALL XPRVDU (NCVDU,1,0)
         ENDIF

         do KK=-12,12
            if(KL.eq.0.and.KK.lt.0) cycle
            do KH=-12,12
               if(kh/2*2.eq.kh .and.kk/2*2.eq.kk .and.kl/2*2.eq.kl)cycle
               if(kh/3*3.eq.kh .and.kk/3*3.eq.kk .and.kl/3*3.eq.kl)cycle
               if(kh/5*5.eq.kh .and.kk/5*5.eq.kk .and.kl/5*5.eq.kl)cycle
               if(kh/7*7.eq.kh .and.kk/7*7.eq.kk .and.kl/7*7.eq.kl)cycle
               if(kh/11*11.eq.kh .and.
     1            kk/11*11.eq.kk .and.kl/11*11.eq.kl)cycle
               if(kl.eq.0.and.kk.eq.0.and.kh.lt.1) cycle
               HKL(1) = KH
               HKL(2) = KK
               HKL(3) = KL

C Direct vectors
               DORR="d"
               CALL RTXMAT(PHIR,HKL,DORR,unitcells(1)%metric(),
     1             unitcells(1)%rmetric(),MRES,P)
               IF (PORI .LT. 0) CALL XNEGTR(MRES,MRES,9)

               IF ( NOTPTG ( MRES ) ) THEN

                  CALL RTXAPP(MRES,HKL,DISAG,
     1                TOL,PHID,PORI,unitcells(1)%rmetric(),DORR,ipunch)

               END IF

C Reciprocal vectors

               DORR="r"
               CALL RTXMAT(PHIR,HKL,DORR,unitcells(1)%metric(),
     1             unitcells(1)%rmetric(),MRES,P)
               IF (PORI .LT. 0) CALL XNEGTR(MRES,MRES,9)

               IF ( NOTPTG ( MRES ) ) THEN

                  CALL RTXAPP(MRES,HKL,DISAG,
     1                TOL,PHID,PORI,unitcells(1)%rmetric(),DORR,ipunch)

               END IF
       
            enddo
         enddo
      enddo


9000  CONTINUE
C -- FINAL MESSAGE
      CALL XOPMSG ( IOPDSP , IOPEND , IVERSN )
      CALL XTIME2 ( 2 )
C
      CALL XRSL
      CALL XCSAE
C
      RETURN
C
C
C
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


      LOGICAL FUNCTION NOTPTG(TM)
C Returns TRUE if the transformation matrix does not belong
C to the current point group.
      DIMENSION TM(9),SYM(9),SUB(9)

      INCLUDE 'XLST02.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'

      NOTPTG = .TRUE.

      NC=2*IC+1

C--LOOP OVER EACH SYMMETRY OPERATOR COMBINATION FOR THIS ATOM
      M2=L2
      DO NE=0,N2-1
        CALL XMOVE(STORE(L2+MD2*NE),SYM(1),9)  !FETCH THE SYMMETRY OPERATOR
C--LOOP OVER EACH REQUIRED SIGN FOR THE CENTRE OF SYMMETRY FLAG
        DO NF=1,NC,2
          CALL XSUBTR(TM(1),SYM(1),SUB(1),9)
          DO I = 1,9
            IF ( ABS(SUB(I)) .GT. ZERO ) GOTO 100
          END DO
          NOTPTG = .FALSE.
          WRITE(CMON,'(A)')
     1'Rejected the following twin law; it is part of the point group:'
          CALL XPRVDU(NCVDU,1,0)
          DO I = 1,7,3
            WRITE(CMON,'(3F7.4,3X)') (TM(I+J),J=0,2)
            CALL XPRVDU(NCVDU,1,0)
          END DO
          RETURN

100       CONTINUE
          CALL XNEGTR(SYM(1),SYM(1),9)
        END DO
      END DO

      RETURN

      END

      SUBROUTINE RTXMAT(phir,x,dorr,G,GS,M,p)
C x = direct or reciprocal lattice direction
C If x is direct (dorr=d) this subroutine normalises it, and works out the 
C covariant components.
C If x is reciprocal (dorr=r) this subroutine normalises it, and works out the 
C contravariant components.
C The rotation matrix is then worked out in subroutine eqn442 (see
C Sands' book eqn 4-42.

      real, dimension(3,3), intent(in) :: g, gs
      REAL mag,x(3),d(3),r(3), p(3,3,3),
     1     M(3,3),phir,temp(3)
      CHARACTER*1 dorr

      IF (dorr=='d') then
!        CALL XMOVE(X,D,3)
        d=x
!        CALL XMLTMM(G,D,TEMP,3,3,1)
        temp =matmul(g, d)
!        CALL DVPROD(D,TEMP,MAG)
        mag = dot_product(d,temp)
        mag=sqrt(mag)
        D=D/MAG
!        CALL XMLTMM(G,D,R,3,3,1)
        r = matmul(g, d)
        call eqn442(phir,d,r,p,GS,M)
      endif
      if (dorr=='r') then
!        CALL XMOVE(X,R,3)
        r=x
!        CALL XMLTMM(GS,R,TEMP,3,3,1)
        temp=matmul(GS,r)
!        CALL DVPROD(R,TEMP,MAG)
        mag = dot_product(r,temp)
        mag=sqrt(mag)
        R=R/MAG
!        CALL XMLTMM(GS,R,D,3,3,1)
        d = matmul(GS,r)
        call eqn442(phir,d,r,p,GS,M)
      endif

      END


      subroutine eqn442(phir,d,r,p,GS,M)
C Applies Sands' eqn 4-42. Note that Sands' eqn refers to rotations of 
C coordinates, so the equation we need has the sine term made negative;
C the inverse transpose of the resulting matrix is then taken.
C All of this is simply the transpose of Sands' original matrix!

      integer i,j,k,l
      real phir, M(3,3),d(3),r(3),p(3,3,3),GS(3,3), delta,N
      DO I=1,3
        DO J=1,3
          M(J,I)=0.
        END DO
      END DO
      do i=1,3
        do j=1,3
          if (i==j) then
             delta=1.
          else
             delta=0.
          endif
          M(i,j) = d(i)*r(j)
          M(i,j) = M(i,j) + (delta - M(i,j))*Cos(phir)
          N=0.
          do k=1,3
            do l=1,3
             N =  N + GS(i,k)*P(k,l,j)*d(l)
            enddo
          enddo
          M(i,j) = M(i,j) + N*Sin(phir)   
        enddo
      enddo
      CALL MTRANS(M)
c      M=transpose(M)
      END

      subroutine make_p(P,v)
C calulates elements of the permutation tensor
      real p(3,3,3),v
      DO I=1,3
        DO J=1,3
          DO K=1,3
            p(K,J,I)=0.
          END DO
        END DO
      END DO
      p(1,2,3)=V
      p(2,3,1)=V
      p(3,1,2)=V
      p(1,3,2)=-V
      p(2,1,3)=-V
      p(3,2,1)=-V
      END


      subroutine RTXAPP(M,x,disag,tol,phid,pori,GS,dorr,ipunch)
c applies potentail twin law (matrix M) to array of disagreeable
c reflection indices. Calls figure of merit calculation and then starts 
c to write results to file rotax.out.

      real x(3)
      real M(3,3), GS(3,3)
      real mdisag(3,30),fom,disag(3,30),tol, phid, d(30,5), q(15)
      integer bc, pori
      character*1 dorr
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'

      CALL XMLTMM(M,DISAG,MDISAG,3,3,30)
c      mdisag=matmul(M,disag)

      call figure_of_merit(mdisag,GS,fom,q,d,bc) 


1     FORMAT (/,f5.1,' degree ',A,' about ',3(F4.0),1X,A,
     1               ' lattice direction: ')
2     FORMAT ( A, ' direction     ',3f4.0,' f.o.m. = ',f6.2)
3     FORMAT (f6.3,1X,A,1X,3I4)

      if (fom<tol) then
         if(dorr=="d") then
            if (pori>0) then
               write (NCWU,1) phid,'rotation',x(1),x(2),x(3),'direct'
            else
               write (NCWU,1) phid,'rotoinversion',
     1                        x(1),x(2),x(3),'direct'
            endif

            IF ( ipunch .ge. 1 ) then
               write (NCPU,3) min(99.999,fom), 'direct',
     1                       (nint(x(i)),i=1,3)
            END IF

            call write_results(fom,disag,d,q,bc,M,ipunch)
            write (CMON,2) 'Direct',x(1),x(2),x(3),fom
            CALL XPRVDU(NCVDU,1,0)
          endif

          if(dorr=="r") then
             if (pori>0) then
               write (NCWU,1) phid,'rotation',
     1                        x(1),x(2),x(3),'reciprocal'
            else
               write (NCWU,1) phid,'rotoinversion',
     1                        x(1),x(2),x(3),'reciprocal'
            endif

            IF ( ipunch .ge. 1 ) then
               write (NCPU,3) min(99.999,fom), 'reciprocal',
     1                        (nint(x(i)),i=1,3)
            END IF

            call write_results(fom,disag,d,q,bc,M,ipunch)
            write (CMON,2) 'Reciprocal',x(1),x(2),x(3),fom
            CALL XPRVDU(NCVDU,1,0)
          endif
      endif
      end 

      subroutine figure_of_merit(mdisag,GS,fom,q,d,bc) 
c works out the figure of merit
      real GS(3,3), temp(3)
      real mdisag(3,30),fom,bad(3), d(30,5), dcopy(30),q(15), dmin, d1
      integer i,bc, i1, i2, i3, i1min, i2min, i3min
      integer jp(1)
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'


      do i=1,15
        q(i)=0
      end do
      fom=0
      bc=0

c      bad(1)=  0.5
c      bad(2)=  0.5
c      bad(3)=  0.5
c      CALL XMLTMM(GS,BAD,TEMP,3,3,1)
c      CALL DVPROD(BAD,TEMP,D1)
c      D1 = SQRT(D1)
c      WRITE(CMON,'(A,G15.8)')'Rotax high dist = ',D1
c      CALL XPRVDU(NCVDU,1,0)

      do i=1,30
        dmin=100.
        do i1=-1,1
         do i2=-1,1
          do i3=-1,1
            bad(1)=  nint(mdisag(1,i))+real(i1) - mdisag(1,i) 
            bad(2)=  nint(mdisag(2,i))+real(i2) - mdisag(2,i) 
            bad(3)=  nint(mdisag(3,i))+real(i3) - mdisag(3,i) 
            CALL XMLTMM(GS,BAD,TEMP,3,3,1)
            CALL DVPROD(BAD,TEMP,D1)
            D1 = SQRT(D1)
c            d1 = sqrt(dot_product(bad,mvmul(GS,bad)))
            if (d1<dmin) then
               dmin=d1
               i1min=i1
               i2min=i2
               i3min=i3
            endif
            if ((i1==0).and.(i2==0).and.(i3==0)) then
               d(i,5)=d1      
            endif
          enddo
         enddo
        enddo
        d(i,1)=  dmin 
        d(i,2)=  nint(mdisag(1,i))+real(i1min) 
        d(i,3)=  nint(mdisag(2,i))+real(i2min) 
        d(i,4)=  nint(mdisag(3,i))+real(i3min) 
        d(i,5)=  abs(d(i,5))-dmin
      enddo
      dsum = 0.

      do i=1,30
        dcopy(i) = d(i,1)
        dsum = dsum+dcopy(i)
      enddo

      do i=1,15
          q(i)=dsum/(30.-bc)
          fom=q(i)
          if (fom<.002) then
            exit
          else
            bc=bc+1
#ifdef CRY_FORTDIGITAL
            jp = maxloc(dcopy)
#else
            jp(1) = maxpos(dcopy,30)
#endif
            dsum = dsum - dcopy(jp(1))
            dcopy(jp(1)) = 0.
            d(jp(1),1)=-d(jp(1),1)
          endif
      enddo
      fom=1000.*fom
#ifdef CRY_FORTDIGITAL
      q=1000*q
#else
      do i=1,15
        q(i)=1000*q(i)
      end do
#endif
      end

#ifndef CRY_FORTDIGITAL
      FUNCTION maxpos(dcopy, n)
      DIMENSION dcopy(n)
      maxpos = 1
      do i = 2,n
        if ( dcopy(i).gt.dcopy(maxpos) ) maxpos = i
      end do
      return
      end
#endif

      subroutine write_results(fom,disag, d,q,bc,m2,ipunch)
c prints the results to rotax.out
      real  fom,disag(3,30), d(30,5),q(15), m2(3,3)
      INTEGER BININC(12),BINREJ(12)
      REAL BINMAX
      integer bc,i
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XUNITS.INC'

1     FORMAT('[',f8.3,2(1x,f8.3),']')
2     FORMAT('Figure of merit = ',f6.2,A)
3     FORMAT('No reflections omitted')
4     FORMAT(i2,' reflections omitted'/
     4          'Figure of merit with no omissions = ',f6.2)
5     FORMAT (i2,1X,9f7.3)

      BINMAX = 0.0001

      write(NCWU,1)(m2(1,i),i=1,3)
      write(NCWU,1)(m2(2,i),i=1,3)
      write(NCWU,1)(m2(3,i),i=1,3)
      if (fom<2.) then
        if (bc==0) then 
          write(NCWU,2)fom,' ***********'
          write(NCWU,3) 
        else
          write(NCWU,2)fom,' ***********'
          write(NCWU,4)bc,q(1)
        endif
      else
        write(NCWU,2)fom,' '
        write(NCWU,4)bc,q(1)
      endif

      IF ( ipunch .ge. 1 ) then
         write (NCPU,5) bc,((m2(j,k),k=1,3),j=1,3)
      END IF

6     FORMAT ('Distances in Ang**-1 of transformed indices from integral
     6 r.l. points:'/'d1 = distance of transformed indices to nearest r.
     6l. point'/'d2 = d1 - distance to r.l. point with rounded transform
     6ed indices'/'In a well-behaved system d2 should be zero, but it co
     6uld deviate from this'/'value in the case of a highly skew unit ce
     6ll'/'    Orig.          Trans.         d1         d2    ')
      WRITE(NCWU,6)
      
7     FORMAT (3f4.0,3X,3f4.0,3x,f8.5,3x,f8.5,a)
      do i=1,30
        if (d(i,1)>0) then
         write(NCWU,7) (disag(j,i),j=1,3),
     1      (d(i,j),j=2,4),d(i,1),d(i,5),' '
        else
         write(NCWU,7) (disag(j,i),j=1,3),
     1 (d(i,j),j=2,4),abs(d(i,1)),d(i,5),' Omitted from fom calculation'
        endif
        BINMAX = MAX(BINMAX,ABS(D(I,1)))
      enddo

      IF ( ipunch .ge. 1 ) then
        DO I = 1,12
          BININC(I) = 0
          BINREJ(I) = 0     
        END DO

        DO I = 1,30
          N = 1 + (12.0 * abs(d(i,1)) / BINMAX)
          N = MAX(1,N)
          N = MIN(12,N)
          if (d(i,1)>0) then
             BININC(N) = BININC(N) + 1
          else
             BINREJ(N) = BINREJ(N) + 1
          end if
        END DO

        BINMAX = BINMAX * 1000.0

        IF ( BINMAX .GE. 10000.0 ) THEN
         write(NCPU,13)BINMAX,(BININC(I),BINREJ(I),I=1,12)
        ELSE IF ( BINMAX .GE. 1000.0 ) THEN
         write(NCPU,12)BINMAX,(BININC(I),BINREJ(I),I=1,12)
        ELSE IF ( BINMAX .GE. 100.0 ) THEN
         write(NCPU,11)BINMAX,(BININC(I),BINREJ(I),I=1,12)
        ELSE IF ( BINMAX .GE. 10.0 ) THEN
         write(NCPU,10)BINMAX,(BININC(I),BINREJ(I),I=1,12)
        ELSE
         write(NCPU,9)BINMAX,(BININC(I),BINREJ(I),I=1,12)
        END IF
      END IF

9     FORMAT(F6.4,24I3)
10    FORMAT(F6.3,24I3)
11    FORMAT(F6.2,24I3)
12    FORMAT(F6.1,24I3)
13    FORMAT(F6.0,24I3)

      write(NCWU,8)
8     FORMAT('++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
     8+++++++++++')
      end



