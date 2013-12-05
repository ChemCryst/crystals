module ufile_mod
      integer, parameter :: iflmax = 20
      common /ufile/ ncufu(iflmax),iflchr(iflmax),iflind,nclu, &
          irdlog(iflmax), irdcpy(iflmax), irdcat(iflmax), irdpag, irdlin, &
          irdcms(iflmax), irdinc(iflmax), irdscr(iflmax), irdsrq(iflmax), &
          irdrec(iflmax), irdfnd(iflmax), irdhgh(iflmax)
      integer, parameter :: nflmax=55
      common /xfldat/ keyfil(8,nflmax), ifluni(nflmax), iflacc(nflmax), &
          iflsta(nflmax), iflfrm(nflmax), iflrea(nflmax), iflopn(nflmax), &
          ifllck(nflmax) , nflusd 
end module
