C
C
CODE FOR XROTAX
      SUBROUTINE XROTAX
C ROTAX : Simon Parsons & Bob Gould, University of Edinburgh
C Version 15th May, 2001
C Crystals implementation - blame Richard Cooper.

\ISTORE
\STORE
\XLST01
\XLST05
\XLST23
\XLST06
\XUNITS
\XSSVAL
\XERVAL
\XOPVAL
\XCONST
\XIOBUF
\QSTORE
      DIMENSION HKL(3)
      REAL INVM(9), INVM2(9), MRES(9), SROT(9), REJ(3), PHI
      INTEGER PORI

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

C -- SET LIST TYPE AND LISTING LEVEL FLAG

C Store tolerance (only show fom's below this limit)
      TOL = STORE(ICOMBF)
C Store sigma multiplier for rejecting outlying reflections
      REJ(1) = STORE(ICOMBF+1)
C Store minimum number of reflections to throw away anyway.
      REJ(2) = ISTORE(ICOMBF+2)
C Store maximum limit on number of reflections to throw away.
      REJ(3) = ISTORE(ICOMBF+3)
C Store the rotation angle
      PHI = STORE(ICOMBF+4)
      PORI = ( ISTORE(ICOMBF+5) * 2 ) - 1
      IPUNCH = ISTORE(ICOMBF+6)
      
      CALL MATS(PHI,PORI,SROT)
     

      IF (KHUNTR ( 1,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL01
      IF (KHUNTR ( 5,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL05
      IF (KHUNTR (23,0, IADDL,IADDR,IADDD, -1) .LT. 0) CALL XFAL23
      CALL XFAL06 (0)


      WRITE ( CMON , 1)
     1' R O T A X : Simon Parsons & Bob Gould, University of Edinburgh',
     2 ' Version 17th July, 2001'
      CALL XPRVDU(NCVDU, 7,0)

      WRITE (NCWU,1)
     1' R O T A X : Simon Parsons & Bob Gould, University of Edinburgh',
     2 ' Version 17th July, 2001'

      IF (PORI .GE. 1) THEN
        WRITE ( CMON , 4) PHI
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCWU , 4) PHI
      ELSE
        WRITE ( CMON , 5) PHI
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCWU , 5) PHI
      END IF

      WRITE ( CMON , 2) TOL
      CALL XPRVDU(NCVDU, 1,0)
      WRITE ( NCWU , 2) TOL

      WRITE ( CMON , 3) NINT(REJ(2)),NINT(REJ(3)),REJ(1)
      CALL XPRVDU(NCVDU, 5,0)
      WRITE ( NCWU , 3) NINT(REJ(2)),NINT(REJ(3)),REJ(1)


      IF(IPUNCH.EQ.1)THEN
        WRITE(NCPU,'(f5.1,1X,I2)') PHI,PORI
      ENDIF

1     FORMAT(3/,A,/,A,2/)
4     FORMAT(' Symmetry element tested: ',f5.1,' degree rotation')
5     FORMAT(' Symmetry element tested: ',f5.1,' degree roto-inversion')

2     FORMAT(' Figures of merit < ',f5.3,' will be listed.')

3     FORMAT(1X,I2,' worst fitting reflections will be rejected.',/,
     1       1X,I2,' reflections will be rejected at most.',/,
     2        ' Within these limits, transformed reflections > ',
     3 f5.2,' sigma ',/,
     4       ' from nearest lattice point will be rejected.',/)

C-- A BUFFER FOR ONE REFELCTION AND ITS Q VALUE
      LTEMPR = NFL
      MDSORT = 7
      NFL = KCHNFL(MDSORT)
C-- INITIALISE THE SORT BUFFER
      JSRTBY = -3
      NSORT = 30
C LSORT is set by function call.
C MSORT is workspace.
C MDSORT is 7 (the length of record we are storing (h,k,l,q,fo2,fc2,sigma2).
C NSORT is 30, the number of records to keep.
C JSRTBY is 3, the offset of q (which we sort by) in the record.
C LTEMPR is the addr where we put new records before they are added.
C XVALUR is the smallest value in array. (To check if call is necessary).
C 1 is the sort type largest->smallest
C DEF is workspace. (Not used after initialisation.)
      CALL SRTDWN(LSORT,MSORT,MDSORT,NSORT, JSRTBY, LTEMPR, XVALUR,
     1   1, DEF)
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

        CALL SRTDWN(LSORT,MSORT,MDSORT,NSORT,JSRTBY,LTEMPR,XVALUR,1,DEF)
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
      DO MSORT = LSORT, LSORT+(MDSORT*(NSORT-1)), MDSORT
        WRITE ( CMON , '(3I4,F11.3,1X,3(F11.1,1X))' ) 
     1                    (NINT(STORE(MSORT+IXAP)),     IXAP=0,2),
     3 (                        STORE(MSORT+IXAP) ,     IXAP=3,6)
        CALL XPRVDU(NCVDU, 1,0)
        WRITE ( NCWU , '(3I4,F11.3,1X,3(F11.1,1X))' ) 
     1                    (NINT(STORE(MSORT+IXAP)),     IXAP=0,2),
     3 (                        STORE(MSORT+IXAP) ,     IXAP=3,6)
      END DO


      WRITE(NCWU,14)
      WRITE(CMON,14)
      CALL XPRVDU(NCVDU,13,0)

14    FORMAT(/,'Each set of indices above is transformed by the',/,
     2 'printed rotation matrix. How far the transformed indices are',/,
     3 'from integral values is measured by the figure of merit. A',/,
     4 'small figure of merit means that most (or all) of the',/,
     5 'indices were transformed to integers and this makes it a',/,
     6 'likely candidate for a twin law.  If only symmetry elements',/,
     7 'which occur in the point group of your crystal structure are',/,
     8 'printed then either your crystal is not a twin, or this',/,
     9 'program has not worked.',/,
     1 'Matrices which have a figure of merit of less than 0.1 are',/,
     2 'marked with a row of asterisks: *************',/)

C Instead of writing all planes out to a file, just
C loop through them all here:


      do KL=0,10
         do KK=-10,10
            if(KL.eq.0.and.KK.lt.0) cycle
            do KH=-10,10
               if(kh/2*2.eq.kh.and.kk/2*2.eq.kk.and.kl/2*2.eq.kl) cycle
               if(kh/3*3.eq.kh.and.kk/3*3.eq.kk.and.kl/3*3.eq.kl) cycle
               if(kh/5*5.eq.kh.and.kk/5*5.eq.kk.and.kl/5*5.eq.kl) cycle
               if(kh/7*7.eq.kh.and.kk/7*7.eq.kk.and.kl/7*7.eq.kl) cycle
               if(kl.eq.0.and.kk.eq.0.and.kh.lt.1) cycle

               HKL(1) = KH
               HKL(2) = KK
               HKL(3) = KL

C Direct vectors
               CALL MAKEM(STORE(L1M1),STORE(L1M2),HKL,MRES)
               CALL MATINV(MRES,INVM,D)
               CALL XMLTMM(SROT,INVM,INVM2,3,3,3)
               CALL XMLTMM(MRES,INVM2,INVM,3,3,3)
               CALL GMATD(INVM,HKL,LSORT,NSORT,MDSORT,
     1                    TOL,REJ,PHI,PORI,IPUNCH)

C Reciprocal vectors
               CALL MAKEM(STORE(L1M2),STORE(L1M1),HKL,MRES)
               CALL MATINV(MRES,INVM,D)
               CALL XMLTMM(SROT,INVM,INVM2,3,3,3)
               CALL XMLTMM(MRES,INVM2,INVM,3,3,3)
               CALL XTRANS(INVM,INVM2,3,3)
               CALL MATINV(INVM2,INVM,D)
               CALL GMATR(INVM,HKL,LSORT,NSORT,MDSORT,
     1                    TOL,REJ,PHI,PORI,IPUNCH)
       
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


      subroutine makem(G,GS,x,M)
C Works out the matrix M which converts cartesian to crystallographic axes 
      real x(3),y(3),z(3),d(3),ax(3)
      real G(3,3),M(3,3),GS(3,3)
      real r1, r

      CALL XMLTMM(G,X,D,3,3,1)

      if ((abs(d(1))<=0.0001).and.(abs(d(2))<=0.0001)) then
        d(1)=1.
        d(2)=1.
      endif

      y(1) = -d(2)
      y(2) =  d(1)
      y(3) =  0.
      z(1) = -x(3)*y(2)
      z(2) =  x(3)*y(1)
      z(3) =  x(1)*y(2) - x(2)*y(1)
      
      ax(1) =  1.
      ax(2) =  0.
      ax(3) =  0.

      CALL XMLTMM(G,X,D,3,3,1)
      CALL VPROD(AX,D,R)
      CALL VPROD(X,D,R1)
      r1 = sqrt(r1)
      M(1,1) = r/r1

      CALL XMLTMM(G,Y,D,3,3,1)
      CALL VPROD(AX,D,R)
      CALL VPROD(Y,D,R1)
      r1 = sqrt(r1)
      M(1,2) = r/r1


      CALL VPROD(AX,Z,R)
      CALL XMLTMM(GS,Z,D,3,3,1)
      CALL VPROD(Z,D,R1)
      r1 = sqrt(r1)
      M(1,3) = r/r1


      ax(1) =  0.
      ax(2) =  1.
      ax(3) =  0.

      CALL XMLTMM(G,X,D,3,3,1)
      CALL VPROD (AX,D,R)
      CALL VPROD (X,D,R1)
      r1 = sqrt(r1)
      M(2,1) = r/r1

      CALL XMLTMM(G,Y,D,3,3,1)
      CALL VPROD (AX,D,R)
      CALL VPROD (Y,D,R1)
      r1 = sqrt(r1)
      M(2,2) = r/r1

      CALL VPROD(AX,Z,R)
      CALL XMLTMM(GS,Z,D,3,3,1)
      CALL VPROD(Z,D,R1)
      r1 = sqrt(r1)
      M(2,3) = r/r1

      ax(1) =  0.
      ax(2) =  0.
      ax(3) =  1.

      CALL XMLTMM(G,X,D,3,3,1)
      CALL VPROD (AX,D,R)
      CALL VPROD (X,D,R1)
      r1 = sqrt(r1)
      M(3,1) = r/r1

      CALL XMLTMM(G,Y,D,3,3,1)
      CALL VPROD (AX,D,R)
      CALL VPROD (Y,D,R1)
      r1 = sqrt(r1)
      M(3,2) = r/r1

      CALL VPROD(AX,Z,R)
      CALL XMLTMM(GS,Z,D,3,3,1)
      CALL VPROD(Z,D,R1)
      r1 = sqrt(r1)
      M(3,3) = r/r1

      END


      subroutine gmatd(M2,x,LSORT,NSORT,MDSORT,tol,rej,phi,pori,ipunch)
C works out the rotation matrices (m2) for direct vectors & tests bad refs
\STORE
\XUNITS
\XIOBUF
      character*13 str,stars
      real x(3), rej(3)
      real M(3,3), INVM(3,3), s(3,3), m2(3,3), phi
      real  mdisag(3,30),fom,bad(30),tol, oldbad(30)
      integer i, pori


      DO I = 1,NSORT
         MSORT = LSORT + MDSORT*(I-1)
         CALL XMLTMM(M2,STORE(MSORT),MDISAG(1,I),3,3,1)
      END DO

      fom=0

      do i=1,NSORT
         bad(i)= ( nint(mdisag(1,i)) - mdisag(1,i) )**2
         bad(i)= bad(i) + ( nint(mdisag(2,i)) - mdisag(2,i) )**2
         bad(i)= bad(i) + ( nint(mdisag(3,i)) - mdisag(3,i) )**2
      enddo

      oldbad=bad

      iout = ibaddv(bad,rej,sigma)
      fom=sum(bad)

      rleft = nsort-iout
      fom=sqrt(fom/rleft)

      if (fom < tol) then

        IF ( PORI .GE. 1 ) THEN
          str = 'rotation'
        ELSE
          str = 'rotoinversion'
        ENDIF

        if ( fom < 0.1 ) THEN
          stars = '*************'
        else
          stars = '             '
        end if

1       FORMAT (/,f5.1,' degree ',A,' about ',3(F4.0),
     2   ' direct lattice direction: ',/,3(8X,3f7.3,/),
     3   '        Figure of merit = ',f10.4,1X,A,/,
     4   8X,i2,' outliers excluded. 4*sigma = ',f7.3)

        write (NCWU,1) phi,str,(x(i),i=1,3),((m2(j,k),k=1,3),j=1,3),
     1                 fom,stars,iout,4.*sigma
        write (CMON,1) phi,str,(x(i),i=1,3),((m2(j,k),k=1,3),j=1,3),
     1                 fom,stars,iout,4.*sigma
        call xprvdu(NCVDU,7,0)

        if ( ipunch .ge. 1 ) then
          write (NCPU,3) fom, 'direct',(nint(x(i)),i=1,3),
     1                   iout,((m2(j,k),k=1,3),j=1,3)
3       FORMAT (f6.4,1X,A,1X,3I4,/,i2,1X,9f7.3)
        endif


        write(NCWU,2) 'Deviations:', (oldbad(i),i=1,30)
2       format(A,/,30(1X,F10.8))

      endif
      END


      subroutine gmatr(m2,x,LSORT,NSORT,MDSORT,tol,rej,phi,pori,ipunch)
c works out the rotation matrices (m2) for recip. vectors & tests bad refs

\STORE
\XUNITS
\XIOBUF

      character*13 str,stars
      real x(3), rej(3)
      real minv(3,3), m2(3,3),phi
      real  mdisag(3,30),fom,bad(30),tol,oldbad(30)
      integer i, pori

       DO I = 1,NSORT
         MSORT = LSORT + MDSORT*(I-1)
         CALL XMLTMM(M2,STORE(MSORT),MDISAG(1,I),3,3,1)
      END DO

      fom=0
      do i=1,NSORT
         bad(i)= ( nint(mdisag(1,i)) - mdisag(1,i) )**2
         bad(i)= bad(i) + ( nint(mdisag(2,i)) - mdisag(2,i) )**2
         bad(i)= bad(i) + ( nint(mdisag(3,i)) - mdisag(3,i) )**2
      enddo

      oldbad=bad

      iout = ibaddv(bad,rej,sigma)
      fom=sum(bad)

      rleft = nsort-iout
      fom=sqrt(fom/rleft)

      if (fom<tol) then

        IF ( PORI .GE. 1 ) THEN
          str = 'rotation'
        ELSE
          str = 'rotoinversion'
        ENDIF

        if ( fom < 0.1 ) THEN
          stars = '*************'
        else
          stars = '             '
        end if

1       FORMAT (/,f5.1,' degree ',A,' about ',3(F4.0),
     2   ' reciprocal lattice direction: ',/,3(8X,3f7.3,/),
     3   '        Figure of merit = ',f10.4,1X,A,/,
     4   8X,i2,' outliers excluded. 4*sigma = ',f7.3)


        write (NCWU,1) phi,str,(x(i),i=1,3),((m2(j,k),k=1,3),j=1,3),
     1                 fom,stars,iout,4.*sigma
        write (CMON,1) phi,str,(x(i),i=1,3),((m2(j,k),k=1,3),j=1,3),
     1                 fom,stars,iout,4.*sigma
        call xprvdu(NCVDU,7,0)


        if ( ipunch .ge. 1 ) then
          write (NCPU,3) fom, 'reciprocal',(nint(x(i)),i=1,3),
     1                   iout,((m2(j,k),k=1,3),j=1,3)
3       FORMAT (f6.4,1X,A,1X,3I4,/,i2,1X,9f7.3)
        endif

        write(NCWU,2) 'Deviations:', (oldbad(i),i=1,30)
2       format(A,/,30(1X,F10.8))

      endif 

      END


      integer function ibaddv(bad,rej,sigma)
\STORE
\XUNITS
\XIOBUF
      real bad(30)
      integer jp(1)
      real sigma, rej(3)


      sigma = sqrt ( (sum(bad)) / 29. )

      ibaddv = 0

C Throw away at least REJ(2) reflections anyway.

      do i=1,NINT(REJ(2))
        jp = maxloc(bad)
        bad(jp(1)) = 0.
        ibaddv = ibaddv + 1
      enddo

C Reject up to rej(3) values more than rej(1) * sigma from zero.

      do i=nint(rej(2))+1,nint(rej(3))
         jp = maxloc(bad)
         if ( bad(jp(1)) .gt. ( (sigma**2) * rej(1) ) ) then
            ibaddv = ibaddv + 1
            bad(jp(1)) = 0.
         endif
      enddo
      return
      end


      subroutine mats(phi,pori,s)
c Calculates the matrix 's', a rotation or rotoinversion about
c the x-axis of the orthogonal axis system.

      integer  pori
      real s(3,3), sphi,cphi, phi, rphi
      rphi=phi/57.29578
      cphi=cos(rphi)
      sphi=sin(rphi)

      if(pori>0) then
      s(1,1)=1.
      s(1,2)=0.
      s(1,3)=0.
      s(2,1)=0.
      s(2,2)=cphi
      s(2,3)=sphi
      s(3,1)=0.
      s(3,2)=-sphi
      s(3,3)=cphi
      elseif(pori<0) then
      s(1,1)=-1.
      s(1,2)=0.
      s(1,3)=0.
      s(2,1)=0.
      s(2,2)=-cphi
      s(2,3)=-sphi
      s(3,1)=0.
      s(3,2)=sphi
      s(3,3)=-cphi
      endif
      return
      end


