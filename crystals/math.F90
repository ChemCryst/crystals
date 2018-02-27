!> This module contains basic mathematical functions and subroutines
module math_mod

private matrixtoquaternions_sp, matrixtoquaternions_dp
private quaternionstomatrix_dp
private invert22dp, invert22sp

interface matrixtoquaternions !< generic procedure to calculate quaternion from rotation matrix
    module procedure matrixtoquaternions_sp, matrixtoquaternions_dp
end interface matrixtoquaternions

interface quaternionstomatrix !< generic procedure to calculate rotation matrix from quaternion
    module procedure quaternionstomatrix_dp
end interface quaternionstomatrix

interface invert22
    module procedure invert22dp, invert22sp
end interface

contains

!> \brief calculate quaternions from rotation matrix
!!
!! See Shoemake, K. Animating Rotation with Quaternion Curves
!! SIGGRAPH Comput. Graph., ACM, 1985, Vol. 19(3), pp. 245-25
function matrixtoquaternions_sp(rot) result(q)
implicit none
real, dimension(3,3), intent(in) :: rot
real, dimension(4) :: q

double precision, dimension(3,3) :: rotdp
double precision, dimension(4) :: qdp

rotdp=rot
qdp=matrixtoquaternions_dp(rotdp)

q=qdp

end function

!> return the outer product of 2 vectors
function outer_product(a, b) result(c)
implicit none
double precision, dimension(:), intent(in) :: a
double precision, dimension(size(a)), intent(in) :: b
double precision, dimension(size(a), size(a)) :: c
integer i

do i=1, size(a)
  c(:,i)=a*b(i)
end do
end function

!> \brief calculate quaternions from rotation matrix
!!
!! See Shoemake, K. Animating Rotation with Quaternion Curves
!! SIGGRAPH Comput. Graph., ACM, 1985, Vol. 19(3), pp. 245-25
function matrixtoquaternions_dp(rot) result(q)
implicit none
double precision, dimension(3,3), intent(in) :: rot
double precision, dimension(4) :: q
double precision, parameter :: eps=1.0d-16

double precision w2, x2, y2, w, x, y, z

w2=0.25d0*(1.0d0+rot(1,1)+rot(2,2)+rot(3,3))

if(w2>eps) then
    w=sqrt(w2)
    x=(rot(2,3)-rot(3,2))/(4.0d0*w)
    y=(rot(3,1)-rot(1,3))/(4.0d0*w)
    z=(rot(1,2)-rot(2,1))/(4.0d0*w)
else
    w=0.0d0
    x2=-0.5d0*(rot(2,2)+rot(3,3))
    if(x2>eps) then
        x=sqrt(x2)
        y=rot(1,2)/(2.0d0*x)
        z=rot(1,3)/(2.0d0*x)
    else
        x=0.0d0
        y2=0.5d0*(1.0d0-rot(3,3))
        if(y2>eps) then
            y=sqrt(y2)
            z=rot(2,3)/(2.0d0*y)
        else
            y=0.0d0
            z=1.0d0
        end if
    end if
end if

q=(/w,x,y,z/)

end function

!> \brief calculate rotation matrix from quaternions
!!
!! See Shoemake, K. Animating Rotation with Quaternion Curves
!! SIGGRAPH Comput. Graph., ACM, 1985, Vol. 19(3), pp. 245-25
function quaternionstomatrix_dp(q) result(rot)
implicit none
double precision, dimension(3,3) :: rot
double precision, dimension(4), intent(in) :: q
double precision dx2, dy2, dz2, dxy, dxz, dyz, dwx, dwy, dwz

dx2=2.0d0*q(2)**2
dy2=2.0d0*q(3)**2
dz2=2.0d0*q(4)**2
dxy=2.0d0*q(2)*Q(3)
dxz=2.0d0*q(2)*Q(4)
dyz=2.0d0*q(3)*Q(4)
dwx=2.0d0*q(1)*Q(2)
dwy=2.0d0*q(1)*Q(3)
dwz=2.0d0*q(1)*Q(4)

rot(1,1)=1.0d0-dy2-dz2
rot(2,1)=dxy-dwz
rot(3,1)=dxz+dwy
rot(1,2)=dxy+dwz
rot(2,2)=1.0d0-dx2-dz2
rot(3,2)=dyz-dwx
rot(1,3)=dxz-dwy
rot(2,3)=dyz+dwx
rot(3,3)=1.0d0-dx2-dy2

end function


!* ----------------------------------------------------------------------------
!* Numerical diagonalization of 3x3 matrices
!* Copyright (C) 2006  Joachim Kopp
!* ----------------------------------------------------------------------------
!* This library is free software; you can redistribute it and/or
!* modify it under the terms of the GNU Lesser General Public
!* License as published by the Free Software Foundation; either
!* version 2.1 of the License, or (at your option) any later version.
!*
!* This library is distributed in the hope that it will be useful,
!* but WITHOUT ANY WARRANTY; without even the implied warranty of
!* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
!* Lesser General Public License for more details.
!*
!* You should have received a copy of the GNU Lesser General Public
!* License along with this library; if not, write to the Free Software
!* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
!* ----------------------------------------------------------------------------


!* ----------------------------------------------------------------------------
!> Calculates the eigenvalues and normalized eigenvectors of a symmetric 3x3 
!! matrix A using the Jacobi algorithm.
!! The upper triangular part of A is destroyed during the calculation,
!! the diagonal elements are read but not destroyed, and the lower
!! triangular elements are not referenced at all.
SUBROUTINE DSYEVJ3(A, Q, W, info)
!* ----------------------------------------------------------------------------
!* ----------------------------------------------------------------------------
!* Parameters:
!*   A: The symmetric input matrix
!*   Q: Storage buffer for eigenvectors
!*   W: Storage buffer for eigenvalues
!*info: return success (0) or failure for convergence (-1)
!* ----------------------------------------------------------------------------
!*     .. Arguments ..
DOUBLE PRECISION, intent(inout) :: A(3,3) !< symmetric 3x3 matrix
DOUBLE PRECISION, intent(out) ::  Q(3,3) !< eigenvectors
DOUBLE PRECISION, intent(out) ::  W(3) !< eigenvalues
integer, intent(out) :: info !< flag for success

!*     .. Parameters ..
INTEGER          N
PARAMETER        ( N = 3 )

!*     .. Local Variables ..
DOUBLE PRECISION SD, SO
DOUBLE PRECISION S, C, T
DOUBLE PRECISION G, H, Z, THETA
DOUBLE PRECISION THRESH
INTEGER          I, X, Y, R

info=0

!*     Initialize Q to the identitity matrix
!*     --- This loop can be omitted if only the eigenvalues are desired ---
DO X = 1, N
  Q(X,X) = 1.0D0
  DO Y = 1, X-1
    Q(X, Y) = 0.0D0
    Q(Y, X) = 0.0D0
  end do
end do

!*     Initialize W to diag(A)
DO X = 1, N
  W(X) = A(X, X)
end do 

!*     Calculate SQR(tr(A))  
SD = 0.0D0
DO X = 1, N
  SD = SD + ABS(W(X))
end do 
SD = SD**2

!*     Main iteration loop
DO I = 1, 50
  !*       Test for convergence
  SO = 0.0D0
  DO X = 1, N
    DO Y = X+1, N
      SO = SO + ABS(A(X, Y))
    end do 
  end do
  IF (SO .EQ. 0.0D0) THEN
    RETURN
  END IF

  IF (I .LT. 4) THEN
    THRESH = 0.2D0 * SO / N**2
  ELSE
    THRESH = 0.0D0
  END IF

!*       Do sweep
  DO X = 1, N
    DO Y = X+1, N
      G = 100.0D0 * ( ABS(A(X, Y)) )
      IF ( I .GT. 4 .AND. ABS(W(X)) + G .EQ. ABS(W(X)) &
      &  .AND. ABS(W(Y)) + G .EQ. ABS(W(Y)) ) THEN
        A(X, Y) = 0.0D0
      ELSE IF (ABS(A(X, Y)) .GT. THRESH) THEN
!*             Calculate Jacobi transformation
        H = W(Y) - W(X)
        IF ( ABS(H) + G .EQ. ABS(H) ) THEN
          T = A(X, Y) / H
        ELSE
          THETA = 0.5D0 * H / A(X, Y)
          IF (THETA .LT. 0.0D0) THEN
            T = -1.0D0 / (SQRT(1.0D0 + THETA**2) - THETA)
          ELSE
            T = 1.0D0 / (SQRT(1.0D0 + THETA**2) + THETA)
          END IF
        END IF

        C = 1.0D0 / SQRT( 1.0D0 + T**2 )
        S = T * C
        Z = T * A(X, Y)
      
!*             Apply Jacobi transformation
        A(X, Y) = 0.0D0
        W(X)    = W(X) - Z
        W(Y)    = W(Y) + Z
        DO R = 1, X-1
          T       = A(R, X)
          A(R, X) = C * T - S * A(R, Y)
          A(R, Y) = S * T + C * A(R, Y)
        end do 
        DO R = X+1, Y-1
          T       = A(X, R)
          A(X, R) = C * T - S * A(R, Y)
          A(R, Y) = S * T + C * A(R, Y)
        end do 
        DO R = Y+1, N
          T       = A(X, R)
          A(X, R) = C * T - S * A(Y, R)
          A(Y, R) = S * T + C * A(Y, R)
        end do 

!*             Update eigenvectors
!*             --- This loop can be omitted if only the eigenvalues are desired ---
        DO R = 1, N
          T       = Q(R, X)
          Q(R, X) = C * T - S * Q(R, Y)
          Q(R, Y) = S * T + C * Q(R, Y)
        end do 
      END IF
    end do 
  end do 
end do 

info = -1
!c      PRINT *, "DSYEVJ3: No convergence."
    
END SUBROUTINE
!* End of subroutine DSYEVJ3


!***********************************************************************************************************************************
!  M33DET  -  Compute the determinant of a 3x3 matrix.
!***********************************************************************************************************************************
!> Return the determinant of a 3x3 matrix
      FUNCTION M33DET (A) RESULT (DET)

      IMPLICIT NONE

      DOUBLE PRECISION, DIMENSION(3,3), INTENT(IN)  :: A

      DOUBLE PRECISION :: DET


      DET =   A(1,1)*A(2,2)*A(3,3)  &
            - A(1,1)*A(2,3)*A(3,2)  &
            - A(1,2)*A(2,1)*A(3,3)  &
            + A(1,2)*A(2,3)*A(3,1)  &
            + A(1,3)*A(2,1)*A(3,2)  &
            - A(1,3)*A(2,2)*A(3,1)

      RETURN

      END FUNCTION M33DET
      
!> Invert a 2x2 matrix
function invert22dp(a) result(b)
implicit none
double precision, dimension(2,2), intent(in) :: a
double precision, dimension(2,2) :: b !< inverse of matrix
double precision det

    det=a(1,1)*a(2,2)-a(1,2)*a(2,1)

    b(1,1)=a(2,2)
    b(2,1)=-a(2,1)
    b(1,2)=-a(1,2)
    b(2,2)=a(1,1)

    b=1/det*b
end function

!> Invert a 2x2 matrix
function invert22sp(a) result(b)
implicit none
real, dimension(2,2), intent(in) :: a
real, dimension(2,2) :: b !< inverse of matrix
real det

    det=a(1,1)*a(2,2)-a(1,2)*a(2,1)

    b(1,1)=a(2,2)
    b(2,1)=-a(2,1)
    b(1,2)=-a(1,2)
    b(2,2)=a(1,1)

    b=1/det*b
end function


end module
