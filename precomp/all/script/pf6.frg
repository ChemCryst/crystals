  P1    0.0  0.0  0.0 
  F1   -1.5708  0.0  0.0 
  F2    1.5708  0.0  0.0 
  F3    0.0 -1.5708  0.0 
  F4    0.0  1.5708  0.0 
  F5    0.0  0.0 -1.5708 
  F6    0.0  0.0  1.5708 
END
#LIST 12
FULL P(1,X'S,U[ISO]) UNTIL F(6) 
EQUIV P(1,U[ISO]) UNTIL F(6)
END 
#LIST 16
ANGLE 90, 2.5 = F(1) TO P(1) TO F(3) 
ANGLE 90, 2.5 = F(1) TO P(1) TO F(4) 
ANGLE 90, 2.5 = F(1) TO P(1) TO F(5) 
ANGLE 90, 2.5 = F(1) TO P(1) TO F(6) 
ANGLE 90, 2.5 = F(3) TO P(1) TO F(5) 
ANGLE 90, 2.5 = F(5) TO P(1) TO F(4) 
ANGLE 90, 2.5 = F(4) TO P(1) TO F(6) 
ANGLE 90, 2.5 = F(6) TO P(1) TO F(3) 
ANGLE 90, 2.5 = F(2) TO P(1) TO F(3) 
ANGLE 90, 2.5 = F(2) TO P(1) TO F(4) 
ANGLE 90, 2.5 = F(2) TO P(1) TO F(5) 
ANGLE 90, 2.5 = F(2) TO P(1) TO F(6) 
DIST 0.0, 0.0372 = MEAN P(1) TO F(1), 
CONT P(1) TO F(2), P(1) TO F(3), 
CONT P(1) TO F(4), P(1) TO F(5), P(1) TO F(6) 
VIB 0.0, 0.01 = P(1) TO F(1) 
VIB 0.0, 0.01 = P(1) TO F(2) 
VIB 0.0, 0.01 = P(1) TO F(3) 
VIB 0.0, 0.01 = P(1) TO F(4) 
VIB 0.0, 0.01 = P(1) TO F(5) 
VIB 0.0, 0.01 = P(1) TO F(6) 
END