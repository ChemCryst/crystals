module xlst50_mod
      integer lr50,mr50,mdr50,nr50,lr51,mr51,mdr51,nr51
      integer lr52,mr52,mdr52,nr52
      integer lr60,mr60,mdr60,nr60,lr61,mr61,mdr61,nr61,lr62,mr62
      integer mdr62,nr62
      integer lr63,mr63,mdr63,nr63,lr64,mr64,mdr64,nr64
      integer lr62n,mr62n,mdr62n,nr62n,lr62d,mr62d,mdr62d,nr62d
      integer lcom,mcom,mdcom,ncom,mult50,idim50,lstoff 

      common/xlst50/lr50,mr50,mdr50,nr50,lr51,mr51,mdr51,nr51, &
		  lr52,mr52,mdr52,nr52, &
		  lr60,mr60,mdr60,nr60,lr61,mr61,mdr61,nr61,lr62,mr62,mdr62,nr62, &
		  lr63,mr63,mdr63,nr63,lr64,mr64,mdr64,nr64, &
          lr62n,mr62n,mdr62n,nr62n,lr62d,mr62d,mdr62d,nr62d, &
          lcom,mcom,mdcom,ncom,mult50,idim50,lstoff 
end module
