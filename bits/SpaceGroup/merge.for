#
# Stefan - this routine is passed one reflection and 
# moves it by available symmetry such that all equivalent
# reflections end up with exactly the same indices:
# e.g. 2 1 4 and -2 -1 -4 both end up as 2 1 4 in the
# triclinic case.
#
# I've removed the code for doing systematic absences, so
# don't be confused by the name of the function...
#
CODE FOR KSYSAB
      FUNCTION KSYSAB(IN,H)
C--DETECT SYSTEMATIC ABSENCES AND COLLECT CORRECT EQUIVALENTS
C
C  IN  IF 'IN' IS 1, A NEW SET OF INDICES IS COMPUTED, BUT FRIEDEL'S
C      LAW IS NOT USED.
C      IF 'IN' IS 2, A NEW SET OF INDICES IS COMPUTED USING FRIEDEL'S LA
C
C  H is a vector of length 3, containing the original HKL on input.
C
C--THE NEW SET OF INDICES HAS THE MAXIMUM VALUE OF 'L' FROM AMONGST THE
C  SYMMETRY EQUIVALENT SET. FROM THE REFLECTIONS WITH THIS VALUE OF 'L',
C  THOSE WITH THE MAXIMUM VALUE OF 'K' ARE CHOSEN. FROM AMONGST THESE
C  REFLECTIONS, THE ONE WITH THE LARGEST VALUE FOR 'H' IS CHOSEN.
C
C--THE NEW UNIQUE INDICES ARE PUT BACK IN H(), WHERE THE OLD INDICES
C  ARE FOUND ON INPUT.
C
C--
      DIMENSION H(3),HG(3),HMAX(3)

C--SET MAX VALUES FOR THE INDICES AND TRANSFORMED INDICES
      DO I=1,3
        HMAX(I)=H(I)
      end do

# The symmetry ops are stored as a list of 4x4 matrices at STORE(L2I)
# (in columns, as it's Fortran)
# M2I is the position of the last one.
# MD2I is the step size (ie. 16).
#
# For your version, you need matrices corresponding to the full 
# Laue symmetry. e.g. for 2/m you would need:
#  
#     1           2          -1          m
#
#  1 0 0 0   -1 0  0 0   -1  0  0 0   1  0 0 0
#  0 1 0 0    0 1  0 0    0 -1  0 0   0 -1 0 0
#  0 0 1 0    0 0 -1 0    0  0 -1 0   0  0 1 0
#  0 0 0 1    0 0  0 1    0  0  0 1   0  0 0 1
#
# You could ditch the translational bits (last row and column) for
# Laue symmetry, since it has none!

C--PASS THROUGH THE DIFFERENT SYMMETRY POSITIONS
      DO 1950 I=L2I,M2I,MD2I
C--TRANFORM INDICES USING CURRENT SYMMETRY MATRIX
        HG(1)=H(1)*STORE(I)+H(2)*STORE(I+3)+H(3)*STORE(I+6)
        HG(2)=H(1)*STORE(I+1)+H(2)*STORE(I+4)+H(3)*STORE(I+7)
        HG(3)=H(1)*STORE(I+2)+H(2)*STORE(I+5)+H(3)*STORE(I+8)

C--CHECK IF THESE ARE THE BEST TRANSFORMS FOR OUTPUT

        DO J=1,IN       !Loop once for no Friedel merge, twice to merge Friedels.

#
# These IF's are peculiar: If the test is -ve, the first label is jumped to,
# if the test is zero, the second label is jumped to, if the test is +ve the
# third label is jumped to.
#
          IF(NINT(HG(3)-HMAX(3)))1800,1600,1700
1600      CONTINUE
          IF(NINT(HG(2)-HMAX(2)))1800,1650,1700
1650      CONTINUE
          IF(NINT(HG(1)-HMAX(1)))1800,1800,1700
1700      CONTINUE
C--THIS SET IS A BETTER SET  -  STORE THEM
          DO K=1,3
            HMAX(K)=HG(K)
          END DO

C--INVERT THE INDICES FOR THE NEXT POSSIBLE PASS (if merging Friedels.)
1800      CONTINUE
          DO K=1,3
            HG(K)=-HG(K)
          END DO
        END DO
      END DO

C--WRITE THE NEW INDICES BACK FOR RETURN
      DO I=1,3
        H(I)=HMAX(I)
      END DO


      KSYSAB=0
      RETURN
      END
