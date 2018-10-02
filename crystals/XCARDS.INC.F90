module xcards_mod
  integer nc, nd, lastch, ni, nilast, ns, mon, icat
  integer ieof, ihflag, nusrq, nrec, iposrq, itypfl, instr, idirfl, iparam, iparad
  integer nwchar, imnsrq
  integer, dimension(8092) :: image, lcmage

  common/xcards/image, nc, nd, lastch, ni, nilast, ns, mon, icat, &
  & ieof, ihflag, nusrq, nrec, iposrq, itypfl, instr, idirfl, iparam, iparad, &
  & nwchar, lcmage, imnsrq
end module
