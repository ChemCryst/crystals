C $Log: not supported by cvs2svn $
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
      DO I = 1, N12B, MD12B
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

CODE FOR XADRHS
      SUBROUTINE XADRHS(WDF, DERIVS, RMAT11, NDERIV)
C--ADD INTO THE R.H.S. OF THE NORMAL EQUATIONS
C  WDF  SQRT(W)*(/FO/ - /FC/)

      DIMENSION DERIVS(NDERIV)
      DIMENSION RMAT11(NDERIV)

      DO I = 1, NDERIV
        RMAT11(I) = RMAT11(I) + DERIVS(I) * WDF
      END DO

      RETURN
      END
