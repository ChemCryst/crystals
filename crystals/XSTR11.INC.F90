module xstr11_mod

      integer nfld,lfld,nuld 
      common/xdatf/nfld,lfld,nuld 
      real, dimension(16777216) :: xstr11
      common/xdatd/xstr11 

!----- note that if str11 is used double precision, lengrp in
!      list11 in command file must be changed from 1 to 2
!      for lhs and rhs
!      and i11len in xprc12
!      double precision str11(8388608) 
      real str11(16777216)
      integer istr11(16777216) 


      !equivalence (str11(1),xstr11(1)) 
      !equivalence (istr11(1),xstr11(1)) 

end module
