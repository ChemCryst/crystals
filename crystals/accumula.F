C $Log: not supported by cvs2svn $
C Revision 1.3  2004/09/30 15:52:56  rich
C Uh-oh. SFLS reorganised quite a lot.
C
C Revision 1.2  2001/02/26 10:24:12  richard
C Added changelog to top of file


CODE FOR XADLHS
      SUBROUTINE XADLHS (DERIVS,NDERIV, AMAT11,NMAT11, I12,N12B,MD12B)

C--ADD THE DERIVATIVES INTO THE L.H.S. OF THE NORMAL MATRIX

      DIMENSION DERIVS(NDERIV)  ! Vector of derivatives
      DIMENSION AMAT11(NMAT11)  ! Normal matrix, upper triangle, blocked
      DIMENSION I12(N12B) ! Info about block numbers & sizes in AMAT11

      K11 = 1
      IBL = 0
      DO I = 1, N12B, MD12B !LOOP THROUGH THE BLOCKS OF THE NORMAL MATRIX
        MNR = I12(I+1)
        DO J=1,MNR  ! LOOP OVER THE DIFFERENT ROWS OF THE MATRIX
          SCONST = DERIVS(IBL+J)  ! SET THE CONSTANT TERM
          DO K=J,MNR  ! LOOP OVER THE COLUMNS OF THE CURRENT ROW
            AMAT11(K11)=AMAT11(K11)+SCONST*DERIVS(IBL+K)
            K11 = K11 + 1
          END DO
        END DO
        IBL = IBL + MNR
      END DO
      RETURN
      END

CODE FOR PAIR_XDLHS
      SUBROUTINE PARM_PAIRS_XLHS (DERIVS, NDERIV, AMAT11,NMAT11, NDIM,
     1 PARAM_LIST, PARAM_L_SIZE)
      implicit none 
C--ADD SPECIFIC DERIVATIVES INTO THE L.H.S. OF THE NORMAL MATRIX
      integer nderiv
      integer nmat11
      real DERIVS(NDERIV)  ! Vector of derivatives
      real AMAT11(NMAT11)  ! Normal matrix, upper triangle, blocked
      INTEGER PARAM_L_SIZE      ! The size of the parameter pair list
      integer PARAM_LIST(PARAM_L_SIZE) ! A list of parameters which should be included in the normal matrix
      integer ndim
      integer param_l_pos       ! Current position in the parameter list
      integer k11, i11          ! Current possition withing the normal matrix and a temparay store also
      real sconst
      integer K, J    ! temp count variables

      param_l_pos = 1
      K11 = 1
      DO J=1,NDIM               ! LOOP OVER THE DIFFERENT ROWS OF THE MATRIX
         SCONST = DERIVS(J)     ! SET THE CONSTANT TERM
         
         if (PARAM_LIST(param_l_pos) < 0) then
            DO K=J,NDIM         ! LOOP OVER THE COLUMNS OF THE CURRENT ROW
               AMAT11(K11) = AMAT11(K11)+SCONST*DERIVS(K)
               K11 = K11 + 1
            END DO
            param_l_pos = param_l_pos + 1                     ! Move to the new row of parameters in the param list
         else
            AMAT11(K11)=AMAT11(K11)+SCONST*DERIVS(J)
            AMAT11(K11) = AMAT11(K11)+SCONST*DERIVS(J)        ! A parameter is always correlated to it's self
            do K = 1, PARAM_LIST(param_l_pos)
               I11 = K11 + (PARAM_LIST(param_l_pos+K) - (J))  ! Get the position of the parameter we what to add
               AMAT11(I11)=AMAT11(I11)+SCONST*DERIVS(PARAM_LIST(
     1          param_l_pos+K))
            end do
            K11 = K11 + (NDIM-(J-1))                          ! Move to the next row in the normal matrix                         
            param_l_pos = param_l_pos + PARAM_LIST(param_l_pos) + 1 ! Move to the new row of parameters in the param list
         end if
      END DO
      RETURN
      END
      
CODE FOR XADRHS
      SUBROUTINE XADRHS(WDF, DERIVS, RMAT11, NDERIV)
C--   ADD INTO THE R.H.S. OF THE NORMAL EQUATIONS
C     WDF  SQRT(W)*(/FO/ - /FC/)
      
      DIMENSION DERIVS(NDERIV)
      DIMENSION RMAT11(NDERIV)

      DO I = 1, NDERIV
        RMAT11(I) = RMAT11(I) + DERIVS(I) * WDF
      END DO

      RETURN
      END
