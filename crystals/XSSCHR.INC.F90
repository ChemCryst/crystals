module xsschr_mod
      CHARACTER*16 CSSMAC , CSSOPS , CSSDAT , CSSPRG 
      CHARACTER*256 CSSCMD, CSSNDA, CSSCST, CSSDST, CSSSCT, CSSELE
      CHARACTER*256 CSSVDU, CSSLPT, CSSCIF, CSSMAP
      common /xsschr/ cssmac, cssops, cssdat, cssprg, csscmd, cssnda,&
          csscst , cssdst, csssct, cssele, cssvdu, csslpt, csscif,&
          cssmap
      common /xsslsn/ lssmac, lssops, lssdat, lssprg, lsscmd, lssnda,&
          lsscst , lssdst, lsssct, lssele, lssvdu, lsslpt, lsscif,&
          lssmap
end module
