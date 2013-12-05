module xcards_mod
      integer image(256),nc,nd,lastch,ni,nilast,ns,mon,icat
      integer ieof,ihflag,nusrq,nrec,iposrq,itypfl,instr,idirfl,iparam
      integer iparad
      integer nwchar , lcmage(256), imnsrq

      common/xcards/image,nc,nd,lastch,ni,nilast,ns,mon,icat, &
          ieof,ihflag,nusrq,nrec,iposrq,itypfl,instr,idirfl,iparam,iparad, &
          nwchar , lcmage, imnsrq
end module
