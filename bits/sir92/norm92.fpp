CRYSTALS CODE FOR DATA
c-- sir code for data command                            Release 93.02
      subroutine datasir(newf,ier)
c--
c          struttura del buffer vet/ivet
c
c     h   k   l   fo sigma  fasi 
c     1   2   3   4    5     6  
c----------------------------------------------------------------------
c   lista 7
c     h+k+l    e       fo   e'+e'p    phi'+phi+code  sigma 
c       1      2       3       4            5          6
c   scompattati in                       
c     h   k   l   e   fo    e'   e'p  fasi  sigma 
c     1   2   3   4    5     6    7     8     9
c----------------------------------------------------------------------
c
      character*80 fileh,name
      character*80 formt
      character cff
c   implementation  common
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
c  partial structure procedure common
      common /frgmt/ mmold,mzold,ihmax(3),knowo,sumn,sumd,ntype(80)
c     erlangen
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
c     sapi
      common/rsc/ibgr,mg,mig(8),scl,bts(9),scsa(9),ip(8,3,5)
c     input/output units, title, flags
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,ifper,iprin,iflag
      common / ureq1/ jpatt,jpunt(501),ksacc,jseteq,jumpp,jmpsie,nsec
c     symmetry
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
c     scratch file reflexion arrays
      common /buffer/ vet(6,85) ,nrpb,idumb(4)
c     atomic scattering factors
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
c     known molecular (group) information
      common /atoms/ x(5,200),nz(200),ngp,ninf(10),nag(10)
c     spherical scattering factors
      common/at/gis(142),giw(142)
c     miscellaneous
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
c     wilson plot parameters
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
c     work area common       (244000 integer words)
      common/xdata/ dumx(244000)
c     sin/cos table & trigonometric constants
      common/trig/sint(450),pi,twopi,dtor,rtod
c
      write(cff,'(i1)') kff
      write(lo,10) cff,itle
   10 format(///,a1,120('+'),//,
     1 39h SIR92 : Data routine                  ,68x,14hRelease  93.02
     2 ,//,20x,20a4,/,1h ,120('+'),//)
c     set up initial values
      kuser = 15000
      nsym=0
      nref=0
      rhomax=0.0
      itype=1
      iform=2
      kop=kopen(iscra,name,nlen,itype,ierr)
      call dirdat(newf,s3s2o,fileh,formt,npc,ier,iy)
      if (ier.lt.0) go to 900
      anat=float(nat)/(pts*float((icent+1)*nsym))
      aa=s3s2*s3s2*pts
c  s3s2p is related to the number of atoms in the primitive cell
      s3s2p=aa*sqrt(1.0/aa)
      s3s2=s3s2p
      is3s2=1./(s3s2p*s3s2p)+0.5
c
      a1=cos(cx(4)*pi/180.0)
      a2=cos(cx(5)*pi/180.0)
      a3=cos(cx(6)*pi/180.0)
      arg=1.0-a1*a1
     1       -a2*a2
     2       -a3*a3
     3       +a1*a2*a3*2.0
      v=cx(1)*cx(2)*cx(3)*sqrt(arg)
      atvol = v / float(nat)
c
      write(lo,370) anat,is3s2,atvol
  370 format(/,39x,'Number of atoms in asymmetric unit =',f6.2,/,
     1 31x,'Equivalent number of equal atoms in primitive cell =',i6,/,
     2 46x,'Volume per atom =',f7.2,/)
      nasu=int(anat+0.5)
c
c-- if reflections aren't supplied finish
c
      if (jfile.eq.ln) go to 900
c
c     calculate number of reflexions for (sem)invariant searching
      mn = int(4.0*anat+100.5)
      if (icent.eq.1) mn = mn + 50
      if (nsym.eq.1) mn = mn + 50
      mn = min0(mn,499)
      mm=mn+min0(499-mn,100)/2
c     read reflexion data from cards
      call datain(fileh,formt,newf,kuser,nrefp,npc,ier)
      if (ier.lt.0) go to 900
c ----
c ---- create list 7 ( e's )
c ----
      npseud=0       
      call prepl7(npseud,iy,nrefp)
c ----
c ---- create list 25 ( atomic groups )
c ----
c     if (ngp.gt.0) call frm25
c ----
      call xdump
  900 close(iscra)
      return
      end
c------------------------------------------------------------
c     read reflexions 
c
      subroutine datain(fileh,formt,newf,kuser,nrefp,npc,ier)
      character*80 fileh
      character*80 line,buff,formt
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,ifper,iprin,iflag
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common /uno/ mxbg,indmb
      common /buffer/ vet(6,85) ,nrpb,idumb(4)
      common/xdata/ibig(244000)
c  if ibig dimension has to be changed, alter mxbg accordingly
      dimension kh(12),kk(12),kl(12),f(12),phyr(12),sigma(12)
      integer phy(12),vsym(24),ib(3),ibrav(6,13),jnbl(128),knbl(128)
      dimension ivet(6,85) ,kv(3)
      equivalence (vet(1,1),ivet(1,1))
      data phyr/12*0.0/
      data ibrav/4*1,3,1,0,3*1,0,-1,1,0,6*1,0,3*1,5*2,3,4*0,1,11*0,1,
     ,5*0,2,5*0,1,5*0,1,11*0,2,0/
c
      ngt63=0
      mxbg=244000
      nex=0
      npq=0
      neq=0
c  ksym=number of translational matrices different from ( 0.0 0.0 0.0 )
      ksym=0
      do 20 i=2,nsym
      ifl=0
      do 10 j=1,3
      if (abs(ts(j,i)).gt.0.00001) ifl=1
   10 continue
      if (ifl.eq.0) go to 20
      ksym=ksym+1
      vsym(ksym)=i
   20 continue
      klatt=latt-1
      if (jfile.lt.0) go to 7034
      if (jfile.ne.ln) then
                         itype=2
                         iform=1
                         if (jopen(jfile,fileh,nlen,itype,iform,ios)
     *                             .lt.0) go to 9000
                       endif
 7034 continue
      if (jfile.eq.ln) go to 5900
      jfile=iabs(jfile)
      nref=0
      nrefp=0
      do 7035 i=1,3
 7035 ihx(i)=-100
      if (npc.gt.0) then
                      iffsq=1
                      nn=npc
                    else
                      iffsq=-1
                      nn=-npc
                    endif
      nneg=0
      nrec=0
      nnn=0
      nuobs=0
      nrmax=0
      rhm=-99.9
      nline=1
      read(jfile,'(a80)',end=7000) line
      buff=line
      call shift(buff,nchar)
      if (buff(1:1).eq.'>') go to 30
      if (knw.eq.0) read(line,formt,end=60,err=8000,iostat=ios)
     *                  (kh(i),kk(i),kl(i),f(i),sigma(i),
     *                   i=1,nn)
      if (knw.eq.1) read(line,formt,end=60,err=8000,iostat=ios)
     *                  (kh(i),kk(i),kl(i),f(i),sigma(i),phyr(i),
     *                   i=1,nn)
      go to 32
   30 nline=nline+1
      if (knw.eq.0) read(jfile,formt,end=60,err=8000,iostat=ios)
     *                  (kh(i),kk(i),kl(i),f(i),sigma(i),
     *                   i=1,nn)
      if (knw.eq.1) read(jfile,formt,end=60,err=8000,iostat=ios)
     *                  (kh(i),kk(i),kl(i),f(i),sigma(i),phyr(i),
     *                   i=1,nn)
   32 do 50 i=1,nn
      if(sigma(i).lt.0.0) go to 6000 
      if(icent.eq.1.and.knw.eq.1) then
                                     aaaa=phyr(i)
                                     phyr(i)=dtor*phyr(i)               
                                     phyr(i)=cos(phyr(i))
                                     if(phyr(i).gt.0) then
                                             phyr(i)=0.0
                                                      else
                                             phyr(i)=180.0
                                                     endif 
                                   endif
      phy(i)=phyr(i)
      if(f(i).lt.0.0) then
                        nneg=nneg+1
                        f(i)=0.0
                        if (sigma(i).lt.0.1) sigma(i)=0.1
                      endif
      if (kh(i).eq.0.and.kk(i).eq.0.and.kl(i).eq.0) go to 60
      nref=nref+1
      if (iabs(kh(i)).gt.63.or.
     *    iabs(kk(i)).gt.63.or.
     *    iabs(kl(i)).gt.63) then
                               ngt63=ngt63+1
                               go to 50
                             endif
      call extin(jex,kh(i),kk(i),kl(i),ibrav,klatt,ksym,vsym)
      if (jex.eq.1) then
          nex=nex+1
          if(nex.le.10) write(lo,35) kh(i),kk(i),kl(i),f(i),sigma(i)
   35     format(' Systematically absent :',3i4,'   Fobs =',f10.3,
     *           '   Sigma(Fobs) =',f10.3)
          if(nex.eq.11) write(lo,36)
   36     format(/,' ....  and  so  on ')
        else
          call geneq(1,kh(i),kk(i),kl(i),idelt,jcode,isgnn,id1,rho)
          ireje=0
          if (rho.gt.th)    then
                              ireje=1
                              nrmax=nrmax+1
                            endif
          if (ireje.eq.0) then
          if (rho.gt.rhm) rhm=rho   
          nrefp=nrefp+1
          nnn=nnn+1
          if(knw.eq.0) goto 40
          phy(i)=phy(i)+idelt
          phy(i)=phy(i)*isgnn
          phy(i)=mod(phy(i),360)
          if(phy(i).le.0) phy(i)=phy(i)+360
   40     continue
          if (iffsq.eq.-1) then
                             fdi=sqrt(f(i))
                             sdi=sigma(i)
                             if (f(i).ge.sdi) then
                                 if (fdi.gt.0.0) sdi=0.5*sdi/fdi
                               else
                                 sdi=0.5*sdi
                               endif
                             f(i)=fdi
                             sigma(i)=sdi
                           endif
          phy(i)=phy(i)*32+jcode
          ivet(1,nnn)=kh(i)
          ivet(2,nnn)=kk(i)
          ivet(3,nnn)=kl(i)
          vet(4,nnn)=f(i)
          vet(5,nnn)=sigma(i)
          ivet(6,nnn)=phy(i) 
          if (nnn.eq.nrpb) then
                           nrec=nrec+1
                           write(iscra,rec=nrec)
     *                          ((vet(j1,j2),j1=1,6),j2=1,nrpb)
                           nnn=0
                         endif
        endif
        endif
   50 continue
      go to 30
   60 nrec=nrec+1
      write(iscra,rec=nrec) ((vet(j1,j2),j1=1,6),j2=1,nrpb)
c
c-- at this point the allowed reflections are on the scratch file(iscra)
c-- it is possible to eliminate symmetry equivalents and add (optionally
c-- unobserved reflections
c
c        set values for some constants
c
      nob=0
      nobi=0
      nnob=0
      lag=0
      ib(1)=1
      ib(2)=2**2
      ib(3)=2**12
      do 65 i=1,128
      knbl(i)=-1
   65 jnbl(i)=-1
c 
Corig kv(2)=2*ihx(3)+1
Corig kv(3)=ihx(2)*kv(2)+ihx(3)
Corig kv(1)=kv(2)*(2*ihx(2)+1)
Corig indmb=ihx(1)*kv(1) + ihx(2)*kv(2) + ihx(3) + kv(3)
      kv(1)=(2*ihx(3)+1)*(2*ihx(2)+1)
      kv(2)=(2*ihx(3)+1)
      indmb=ihx(1)*kv(1)+ihx(2)*kv(2)+ihx(3)
      if(indmb.gt.mxbg) then
           write(lo,70) jrel,indmb,mxbg
   70      format(' available memory too small, a scratch file',/,
     *            ' on channel ',i3,' will be used temporarely.',/,
     *            ' required =',i5,'  available =',i5)
           itype=1
           iform=2
           jop=jopen(jrel,fileh,nlen,itype,iform,ier)
         endif
      do 80 i=1,mxbg
   80 ibig(i)=0
      nr=0
      do 232 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,6),j2=1,nrpb)
      do 230 i=1,nrpb
      nr=nr+1
      if (nr.gt.nrefp) go to 230
      lh=ivet(1,i)
      lk=ivet(2,i)
      ll=ivet(3,i)
      fo=vet(4,i)
c        index of reflection in the big list
Corig inbl=lh*kv(1) + lk*kv(2) + ll + kv(3)
      inbl=lh*kv(1) + lk*kv(2) + ll
      if(inbl.le.mxbg) go to 170
      if (nob.eq.0) go to 160
      do 120 j=1,nobi
      if (inbl.eq.jnbl(j)) go to 210
120   continue
      if (nnob.eq.0) go to 160
      rewind jrel
      do 140 k=1,nnob
      read(jrel) knbl
      do 140 j=1,128
      if (inbl.eq.knbl(j)) go to 210
140   continue
160   continue
      jbig = 1
      if (nobi.lt.128) go to 166
      write(jrel) jnbl
      nobi=0
      nnob=nnob+1
      do 165 j=1,128
165   jnbl(j)=-1
166   nob=nob+1
      nobi=nobi+1
      jnbl(nobi)=inbl
      go to 220
170   lag=ibig(inbl)
c
c        lag=0 if ibig(inbl) is empty,
c        lag=1 if ibig(inbl) was filled up
c
      if (lag.eq.1) go to 210
      ibig(inbl)=1
      go to 220
  210 continue
      neq=neq+1
      absv4=abs(vet(4,i))
      if (absv4.gt.0.00001) then
                              vet(4,i)=-absv4
                            else
                              vet(4,i)=-99.9
                            endif
      go to 230
  220 continue
c-- npq contains the number of observed
c-- independent reflections 
      npq=npq+1
  230 continue
      write(iscra,rec=nnn) ((vet(j1,j2),j1=1,6),j2=1,nrpb)
  232 continue
      ifat1=(2*ihx(3)+1)*(2*ihx(2)+1)
      ifat2=(2*ihx(3)+1)
      ifatx=ihx(1)*ifat1+ihx(2)*ifat2+ihx(3)
      write(lo,300) nref
      if (nrmax.gt.0) write(lo,311) nrmax,th
      if (ngt63.gt.0) write(lo,312) ngt63
      if (nneg.gt.0) write(lo,313) nneg
      write(lo,320) npq,nex,neq,ihx,rhm,ifatx
  300 format(/,10x,i5,'  input reflections')
  311 format(10x,i5,'  rejected reflections with s**2 .gt. ',f6.3)
  312 format(10x,i5,'  rejected reflections with indices .gt. 63')
  313 format(10x,i5,'  Fo(s) negative set to 0.0                ')
  320 format(  10x,i5, '  independent input reflections',
     *       /,10x,i5, '  systematically absent reflections rejected',
     *       /,10x,i5, '  symmetry equivalent reflections rejected',
     *       /, 3x,3i4,'  maximum  h,k,l  values',
     *       /,8x,f7.4,'  maximum s**2 = (sin(theta)/lambda)**2',
     *       /,5x,i10, '  maximum super-index')
      nref=nrefp
      rhomax=rhm
      if (ifatx.gt.100000) go to 8020
c
c-- check for unobserved reflections
c
      call unobs(kv,ibrav,klatt,ksym,vsym,jnbl,knbl)
c
      if (jfile.ne.ln) close(jfile)
 5900 return
 6000 continue
      write(lo,6100) kh(i),kk(i),kl(i),f(i),sigma(i)
 6100 format(/,' *** error ***  negative value of sigma(F) in input:',//
     *,16x,'reflection ',3i4,' Fobs =',f10.3,' Sigma(F) =',f10.3)
      go to 9040
 7000 continue
      write(lo,7010) jfile
 7010 format(' *** error ***    eof on channel ',i2)
      go to 9020
 8000 write(lo,8010) jfile,ios,nline
 8010 format(' *** error ***   read error on channel ',i2,' code =',i5,/
     *       '                 line number ',i5,/)
      go to 9020
 8020 write(lo,8030) rhomax
 8030 format(//,' *** error *** maximum values of h,k,l are too large.'
     *       ,/,'               The program cannot manage them'
     *      ,//,' Restart the program using in %DATA the directive '
     *       ,/,'                RHOMAX  xx                        '
     *       ,/,' where xx must be less than ',f7.4
     *       ,/,' in order to reduce the maximum values of h,k,l.  ')
      go to 9040
 9000 write(lo,9010) ios,fileh
 9010 format(' *** error ***  open error, code =',i5,' file is ',a)
 9020 write(lo,9030)
 9030 format('                 reflections expected')
 9040 ier=-1
      return
      end
c--------------------------------------------------------------
c     read directives for this modul
c
      subroutine dirdat(newf,s3s2o,fileh,formt,npc,ier,iy)
      character line*80,dire*80,diret*80,fileh*80,formt*80
      character blank,digit*12,card(100)*80,ffile*80,ibl2*2
      character specie(8)*2
      common /comdir/ icomq(200,2),maxcom,ipcom,ipdir,icomat
      common /chara/ blank,digit,card,ffile
      common /erl/ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      common /frgmt/ mmold,mzold,ihmax(3),knowo,sumn,sumd,n(80)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,ifper,iprin,iflag
      common / ureq1/ jpatt,jpunt(501),ksacc,jseteq,jumpp,jmpsie,nsec
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
      common /atoms/ x(5,200),nz(200),ngp,ninf(10),nag(10)
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common/gpt/nanew(8),naold(8),sn,sq
      common/at/gis(142),giw(142)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
      common /neutro/ neutro,bmat(2,98),neuwei,vetint(200)
      common /genob/ irho
      dimension na(8),vet(40),ivet(40),wn(8),kshif(3)
      data ibl2 /'  '/
c
c-- set default values
c
c  irho = 1 genera i riflessi dello shell esterno
c  irho = 0 genera i riflessi non osservati fino al (sin theta)/lambda
c         max degli osservati
c  irho =-1 controlla l'esistenza di riflessi non-obs senza memorizzarli
c         sul file ad accesso diretto (default)
c
      jpart=0
      jtran=0
cc
      neutro=0
      irho=-1
      iffsq=1
      iy=67543
      iprin=0
      do 10 i=1,10
      nag(i)=0
   10 ninf(i)=0
      do 15 i=1,80
   15 formt(i:i)=' '
      formt(1:11)='(3i4,2f8.2)'
      ishif=0
      do 20 i=1,3
   20 kshif(i)=0
      ksigma=1
      bt=0.0
      sc=-99.9
      knw=0
      mm=0
      mz=166
      th=1.980
      rhomin=0.0
      en=1.2
      er=0.3
      ngp=0
      llpse=0
      npc=1
      jjfile=ln
      do 30 i=1,200
      x(4,i)=1.0
      read(ibl2,'(a2)') nz(i)
      do 30 j=1,3
   30 x(j,i)=0.0
      lix1=0
      lix2=0
      lix3=0
      lix7=0
      ic=0
      icmax=icomq(icomat,2)
c
  100 continue
      ic=ic+1
      if (ic.gt.icmax) go to 8200
      ipdir=ipdir+1
      line=card(ipdir)
      diret=line
  105 call cutst(line,lenp,dire,lend)
      call lcase(dire)
c-- directives with alphanumeric parameters
      if (dire(1:4).eq.'spac') then
          if (lenp.le.1) go to 8000
          call lcase(line)
          call onebl(line,lenp,ier)
          if (ier.lt.0) go to 8000
          read(line,'(16a1)') nt
          lix2=1
          go to 100
          endif
      if (dire(1:4).eq.'cont') then
          call lcase(line)
          call getcon(line,dire,nw,nalf,nk)
          if (nk.le.0) go to 8000
          lix3=1
          go to 100
          endif
      if (dire(1:4).eq.'refl') then
          read(line,'(a)') fileh
          if (fileh(1:4).ne.'foll') then
                                      jjfile=jfile
                                    else 
                                      jjfile=-ln
                                    endif
          go to 100
          endif
      if (dire(1:4).eq.'form') then
          k=index(diret,'(')
          if (k.eq.0) go to 8000
          formt=diret(k:)
          go to 100
          endif
      if (dire(1:4).eq.'fosq') then
          iffsq=-1
          go to 100
          endif
      if (dire(1:4).eq.'gene') then
                                  irho=0
                                  go to 100
                                endif
c-- directives with alphanumeric parameters
      if (dire(1:4).eq.'frag') then
          ngp=ngp+1
          ninf(ngp)=3
          call getfrg(line,lenp,dire,diret,ic,icmax,ier)
          if (ier.eq.-1) go to 8000
          if (ier.eq. 1) go to 8200
          go to 105
          endif
      if (dire(1:4).eq.'nosi') then
          ksigma=0
          go to 100
          endif
c-- directives with numeric parameters
      iopt=0
      call getnum(line,vet,ivet,iv,iopt)
      if (iopt.eq.-1) go to 8000
      if (dire(1:4).eq.'cell') then
          if (iv.ne.6) go to 8000
          do 200 i=1,6
  200     cx(i)=vet(i)
          lix1=1
          call frm01(cx)
          go to 100
          endif
      if (dire(1:4).eq.'shif') then
          if (iv.ne.3) go to 8000
          ishif=1
          do 250 i=1,3
          ksh=ivet(i)
          if (ksh.ne.0) then
              if (mod(24,ksh).ne.0) then
                                      write(lo,230)
                                      go to 8000
                                    endif
                        endif
          kshif(i)=ksh
  250     continue
          go to 100
          endif
  230   format(///' origin shift components must be integral multiples',
     * ' of 1/24 ')
      if (dire(1:4).eq.'rhom') then
          if (iv.ne.1) go to 8000
          th=vet(1)
          if (th.lt.0.0.or.th.gt.1.0) go to 8000
          go to 100
          endif
      if (dire(1:4).eq.'prin') then
          if (iv.ne.1) go to 8000
          iprin=ivet(1)
          go to 100
          endif
      if (dire(1:4).eq.'know') then
          if (iv.ne.0) go to 8000
          knw=1
          go to 100
          endif
      if (dire(1:4).eq.'reco') then
          if (iv.ne.1) go to 8000
          npc=ivet(1)
          go to 100
          endif
      write(lo,6000) diret
 6000 format(' wrong directive on following line:',/a)
      ier=-1
      return
 8000 continue
      ier=-1
      write(lo,'(22h error in directive : ,a80)') diret
      return
 8200 continue
      npc=npc*iffsq
      jfile=jjfile
      if (lix1.le.0) then
                       write(lo,8220)
 8220 format(/,' *** error *** no cell parameters supplied')
                       ier=-1
                     else
      call yfl01
      write(lo,8230) (cx(i),i=1,6),p
 8230 format(/,12h Direct cell,9x,3ha =,f8.3,4x,3hb =,f8.3,4x,
     1 3hc =,f8.3,4x,7halpha =,f7.2,4x,6hbeta =,f7.2,4x,7hgamma =,f7.2,
     2 //,   12h s2 = s**2 =,f9.6,9h * h**2 +,f9.6,9h * k**2 +,f9.6,
     39h * l**2 +,f9.6,10h * h * k +,f9.6,10h * h * l +,f9.6,8h * k * l)
                     endif
      if (lix2.le.0) then
                       write(lo,8240)
 8240 format(/,' *** error *** no space group symbol supplied')
                       ier=-1
                     else
      call insym(ishif,kshif)
      pop=pts*(float((icent+1)*nsym))
      call yfrm02
                     endif
c ---
c --- read scattering factors
c ---
      if (lix3.le.0) then
                       write(lo,8250)
 8250 format(/,' *** error *** no cell content supplied')
                       ier=-1
                     else
      call yfrm03(ier)
      if (ier.ge.0) call yfl03
                     endif
      call xdump
      if (ier.lt.0) return
c ---
      do 9010 i=1,nk
      write(specie(i),'(a2)') nalf(i)
      call ucase(specie(i)(1:1))
 9010 na(i)=nw(i)
      write(lo,9020) (specie(i),nw(i),no(i),
     1               (al(ii,i),bs(ii,i),ii=1,4),cl(i),i=1,nk)
 9020 format(/,15x,'Unit cell contents and scattering factor constants
     1     f = sum (  a(i) * exp(-b(i)*s2)  )  i=1,4 + c ',//,
     2 1h ,4hatom,4x,14hnumber in cell,4x,13hatomic number,5x,
     3 'a(1)',5x,'b(1)',5x,'a(2)',5x,'b(2)',5x,'a(3)',5x,'b(3)',5x,
     4 'a(4)',5x,'b(4)',5x,' c',/,(1h ,1x,a2,i14,i17,6x,9f9.3))
      s3=0
      s2=0
      do 9060 i=1,nk
         ss=float(na(i))*no(i)*no(i)
         s2=s2+ss
         s3=s3+ss*no(i)
 9060 continue
      s3s2=s3/sqrt(s2**3)
      do 9090 i=1,8
 9090 wn(i)=float(nw(i))
      if (ngp.gt.0) then
      nf=0
      nats=0
      do 9190 i=1,ngp
      ns=nf+1
      nf=nf+nag(i)
      write(lo,9100) i,nag(i)
 9100 format(/,27h fragment number          =,i3,/,
     1         27h no. of atoms in fragment =,i3,/,
     2 5x,'type',7x,'x',9x,'y',9x,'z',7x,'occ.   number in cell')
      do 9170 j=ns,nf
      do 9120 k=1,nk
      if(nz(j).eq.nalf(k)) goto 9140
 9120 continue
      write(lo,9130) nz(j)
 9130 format('  *** error *** ',a2,
     *       ' type not present in the declared content')
      ier=-1
      return
 9140 nz(j)=k
      k=nz(j)
      nz(j)=nz(j)*100+1
      nats=nats+1
 9170 continue
 9190 continue
           numset=0
           interp=0
           call frm15(nats,numset,interp)
           endif
      return
      end
c---------------------------------------------------------------------
      subroutine prepl7(npseud,iy,nrefp)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(6,85) ,nrpb,idumb(4)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common /xdata/ store(244000)
      dimension ivet(6,85),vet2(6,85),ivet2(6,85),vat(9)
c     dimension sigv(10,2),isigv(10),isigp(10)
      equivalence (vet(1,1),ivet(1,1))
      equivalence (vet2(1,1),ivet2(1,1))
c
c
      sumsig=0.0
      sig01=0.0
      n01=0
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
c     set initial values
      do 100 nn=1,nrpb
  100 vet2(2,nn)=-9999.9
      nr=0
      nc=0
      nn2=0
      k2=0
      do 250 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,6),j2=1,nrpb)
      do 250 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 255
      if (vet(4,i).lt.0.0) goto 250
      nc=nc+1
      lh=ivet(1,i)
      lk=ivet(2,i)
      ll=ivet(3,i)
      fo=vet(4,i)
      sigma=vet(5,i)
      icobs=1
      inp=(icobs*128*128+(lh+64)*128+(lk+64))*128+ll+64
c
c--   definizione di vet2-ivet2        vet2(6,85)
c       inp   e   fo   ed   fasi sigma 
c        1    2    3    4     5    6
c
      k2=k2+1
      ivet2(1,k2)=inp
      vet2(2,k2)=nref-nc+1    
      vet2(3,k2)=fo
      vet2(4,k2)=0.0
      ivet2(5,k2)=ivet(6,i)
      if (sigma.gt.0.0) then
                          sig01=sig01+sigma
                          n01=n01+1
                        endif
      sumsig=sumsig+sigma
      if (abs(sigma).lt.0.001) sigma=0.1
      vet2(6,k2)=sigma
      if(k2.eq.nrpb) then
                        nn2=nn2+1
                        write(iscra,rec=nn2)
     *                  ((vet2(j1,j2),j1=1,6),j2=1,nrpb)
                        k2=0
                        do 150 nn=1,nrpb
  150                   vet2(2,nn)=-9999.9
                      endif
  250 continue
  255 if(k2.gt.0) then
                    nn2=nn2+1
                    write(iscra,rec=nn2)
     *              ((vet2(j1,j2),j1=1,6),j2=1,nrpb)
                   endif
c
c---- fine ciclo su vet-ivet
c
      nref=nc
      nr2=nn2 
      nrpb2=nrpb
      ksort=1
      kprint=0
      call smerge(nr2,nrpb2,nref,npseud,iy,mm,mz,ksort,bto,sco)
c
c-- sort reflections respect to F's
c
c     value=0.0
c     do 10 i=1,10
c     value=value+0.5
c     sigv(i,1)=value
c     sigv(i,2)=0.0
c  10 continue
      aref=float(nref)
      sumsig=sumsig/aref
      sumdsig=0.0
      do 400 i=1,nref
      call snr07(vat)
      if (ksigma.gt.0) then
                         dsig=abs(sumsig-vat(9))
                         sumdsig=sumdsig+dsig
c                        do 88 jsig=1,10
c                        asig=sigv(jsig,1)
c                        asigm=asig*vat(9)
c                        if (fo.gt.asigm) sigv(jsig,2)=sigv(jsig,2)+1
c  88                    continue
                       endif
c     store(i)=vat(5)
  400 continue
      sumdsig=sumdsig/aref
      if (sumdsig.lt.0.01) ksigma=0
      if (nint(sig01).eq.n01) ksigma=0
c
c-- print F's statistics
c
c     if (ksigma.gt.0) then
c                        write(lo,370) 
c                        do 360 i=1,10
c                        isigv(i)=nint(sigv(i,2))
c                        isigp(i)=nint(100.0*sigv(i,2)/aref)
c 360                    continue
c                        write(lo,380) (isigv(i),i=1,10),
c    *                                 (isigp(i),i=1,10),
c    *                                 (sigv(i,1),i=1,10)
c                      else
c                        write(lo,385) 
c                      endif
      if (ksigma.eq.0) write(lo,385) 
c 370 format(//,35x,
c    *48hnumber and percentage of  F's > param * sigma(F),/)
c 380 format('     number',10i8,/,
c    *       ' percentage',10(i7,'%'),/,
c    *       '      param',10f8.2)
  385 format(/,' *** warning ***  sigma(F) values are meaningless',/)
c     iniz=1
c     ndata=nref
c     istep=1
c     jump=-1
c     call sortz(iniz,ndata,istep,jump)
c     ist=0
c     istep=nref/10
c     do 405 i=1,10
c     ist=ist+istep
c     isigv(i)=ist
c     isigp(i)=nint(100.0*float(ist)/aref)
c     sigv(i,1)=store(ist)
c 405 continue
c     write(lo,410)
c 410 format(//,35x,
c    *38hnumber and percentage of  F's > limit ,/)
c     write(lo,420) (isigv(i),i=1,10),
c    *              (isigp(i),i=1,10),
c    *              (sigv(i,1),i=1,10)
c 420 format('     number',10i8,/,
c    *       ' percentage',10(i7,'%'),/,
c    *       '      limit',10f8.2)
c
c
c-- write fosog in list 7
      fosog=0.0
      iy=-1
      call spb07(iy)
c  
      return
      end
c-----------------------------------------------------------------------
      subroutine smerge(nr2,nrpb2,nref,npseud,iy,mm,mz,ksort,bto,sco)
c
c-- merge the sorted blocks of reflections in iscra
c-- create list 7
c     nr2 = number of disk blocks
c    nrpb2 = number of reflections per block
c    ksort = 0 do not sort reflections
c          = 1 sort reflections
c   lbuffe = buffer lenght
c     ntop = number of reflections to transfer from disk in buffer
c            for each disk block
c    nitem = number of values per reflection
c    inizb = starting address of the buffer   
c    inizd = starting address in the buffer    for disk block
c    inizt = starting address in the buffer    for total counter
c    inizp = starting address in the buffer    for partial counter
c    inize = starting address in the buffer    for emax values
c    inizr = starting address in the buffer    for reflections
c
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common/xdata/ buffer(244000)
      dimension vet2(6,85),ivet2(6,85),vet(6),ivet(6),ibuffe(244000)
      equivalence (vet(1),ivet(1))
      equivalence (vet2(1,1),ivet2(1,1))
      equivalence (vet2(1,1),buffer(1))
      equivalence (buffer(1),ibuffe(1))
c
c-- create preamble block for list 7
      call ysfp07(nref,npseud,iy)
c
c-- reset pointers for list 7
      call ysfl07(idum1,idum2,idum3,idum4,idum5)
c
c-- initialize pointers and constants
      mxbg=240000
      n90=0
      nrf=0
      iweak=nref-mz+1
      nitem = 6
      lbuffe=mxbg
      inizd=1
      inizb=inizd+nitem*nrpb2
      inizt=inizb
      inizp=inizt+nr2
      inize=inizp+nr2
      inizr=inize+nr2
c
c-- initialize counters and array for max e values
c-- fill the buffer with the tops of disk blocks
      ntop= ( lbuffe - inizr ) / ( nr2 * nitem )
      ntop=min0(ntop,nrpb2)
      ib=inizr-1
      do 100 i=1,nr2
      ibuffe(inizt+i-1)=1
      ibuffe(inizp+i-1)=1
      read(iscra,rec=i) ((vet2(j1,j2),j1=1,nitem),j2=1,nrpb2)
      buffer(inize+i-1)=vet2(2,1)
      do 90 j2=1,ntop
      do 90 j1=1,nitem
      ib=ib+1
      buffer(ib)=vet2(j1,j2)
   90 continue
  100 continue
c
c-- compute imax = number of block containing the e-max
  110 imax=0
c
      if (ksort.eq.0) then
c-- imax correspond to the first reflection in the first available block
      imax=0
      do 115 i=1,nr2
      j=ibuffe(inizt+i-1)
      if (j.le.nrpb2.and.imax.eq.0) imax=i
  115 continue
                     else
c-- find out imax
      emax=-999.9
      do 120 i=1,nr2
      j=ibuffe(inizt+i-1)
      if (j.le.nrpb2) then
                        emx=buffer(inize+i-1)
                        if (emx.gt.emax) then
                                           emax=emx
                                           imax=i
                                         endif
                      endif
  120 continue
                      endif
      if (imax.eq.0) go to 200
c
c-- if the top of imax-th block is empty load the 'next' top
c
c-- itx  = value of the  total  counter for imax-th block
c-- ipx  = value of the partial counter for imax-th block
c--  ib  = address in buffer of the selected reflection
      itx=ibuffe(inizt+imax-1)
      ipx=ibuffe(inizp+imax-1)
      ib= inizr + ( (imax-1)*ntop + (ipx-1)  ) * nitem 
      ivet(1)=ibuffe(ib  )
       vet(2)=buffer(ib+1)
       vet(3)=buffer(ib+2)
       vet(4)=buffer(ib+3)
      ivet(5)=ibuffe(ib+4)
       vet(6)=buffer(ib+5)
      call xslw07(vet)
      itx=itx+1
      k1=inize+imax-1
      k2=inizp+imax-1
      k3=inizt+imax-1
      if (itx.le.nrpb2) then
                if (ipx.eq.ntop) then
                                   ipx=0
                                   read(iscra,rec=imax) 
     *                             ((vet2(j1,j2),j1=1,nitem),j2=1,nrpb2)
                                   ib=inizr+(imax-1)*ntop*nitem-1
                                   ifin=itx+ntop-1
                                   ifin=min0(ifin,nrpb2)
                                   do 130 j2=itx,ifin
                                   do 130 j1=1,nitem
                                   ib=ib+1
                                   buffer(ib)=vet2(j1,j2)
  130                              continue
                                 endif
                          ipx=ipx+1
                          ib=inizr+((imax-1)*ntop+(ipx-1))*nitem
                          buffer(k1)=buffer(ib+1)
                          ibuffe(k2)=ipx
                          if (buffer(k1).lt.0.0) itx=nrpb2+1
                        else
                          buffer(k1)=-888.8
                        endif
      ibuffe(k3)=itx
      go to 110
  200 continue
c
c-- reset pointers for list 7
      call ysfl07(idum1,idum2,idum3,idum4,idum5)
      call xdump
      return
      end
c------------------------------------------------------------
c     read space group symbol as in international tables and
c     determine lattice multiplicity (pts) and crystal system (ksys)
      subroutine insym(ishif,kshif)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common /erl/ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      dimension ltc(7),kshif(3)
      data ltc/1hp,1ha,1hb,1hc,1hi,1hf,1hr/
c     -------
      call symm(lo,ishif,kshif)
c     determine lattice multiplicity
c     primitive
      pts=1.0
      do 250 i=1,7
      if(latt.eq.ltc(i)) go to 260
  250 continue
      stop
  260 latt=i
      if(latt.eq.7) go to 300
c     a, b, c or i centred
      if(latt.ne.1) pts=2.0
c     f centred
      if(latt.eq.6) pts=4.0
      go to 400
  300 do 310 i=1,nsym
c     primitive rhombohedral  (pts=1.0)
      if(iabs(is(1,1,i)).eq.3) go to 400
  310 continue
c     centred hexagonal
      pts=3.0
c     determine crystal system
  400 do 450 i=1,2
      do 440 j=1,nsym
      do 430 in=1,2
      if(iabs(is(in,1,j)).eq.4-i) go to 460
  430 continue
  440 continue
  450 continue
c     1 - triclinic, 2 - monoclinic, 3 - orthorhombic
      ksys=min0(nsym,3)
      go to 500
  460 if(i.eq.1) go to 480
c     tetragonal
      ksys=4
      if(nsym.eq.4.or.nsym.eq.8) go to 500
c     trigonal or rhombohedral indexed on hexagonal axes
      ksys=5
c     test for 6-fold axis - general form -x, -y, z + t
      do 470 j=2,nsym
      if(iabs(is(1,1,j)).gt.1.or.iabs(is(2,1,j)).gt.1) go to 470
      if(iabs(is(1,2,j)).eq.1.or.iabs(is(2,2,j)).eq.1) go to 470
c     hexagonal
      ksys=6
  470 continue
      go to 500
c     cubic
  480 ksys=8
c     primitive rhombohedral
      if(latt.eq.7) ksys=7
      if(ksys.eq.7) latt=1
  500 return
      end
c------------------------------------------------------------
      subroutine symm(ncwu,ishif,kshif)
      character oshift*33,oshp*5,texc(6)*12,buffer(24)*60
      character space*16
      common /ureq1/ jpatt,jpunt(501),ksacc,jseteq,jumpp,jmpsie,nsec
      common /erl/ r,tmat(48,3),nt,isys,ngen,ngt,svet(10),jvet(8)
     *            ,dum(7)
      integer  svet,kshif(3)
      integer sys,nt(16),ges(3,3,36),net(3),in(3,4),is(3),get(3,34),
     *ntex(42),hbr(9),hs(15),ll(2,3,2),iss(59),lsh(2,78),s(3),lgt(
     *48),mst1(3,6),mst2(3,6),lf(216),q(3,4,5),txa(3,11),nsm(45),sem(3,3
     *,18),sc(3,3),lgn(3,45),atx(18),txb(5,7),tx(2,6,3),teb(2,9),t(48,3)
     *,ngt(48,48),r(48,3,3)
      equivalence (j2,in(2,2)),(j3,in(2,3)),(k2,in(3,2)),(k3,in(3,3)),
     *(i3,in(1,3)),(i2,in(1,2)),(i1,in(1,1)),(j1,in(2,1)),(k1,in(3,1))
     *,(i4,in(1,4)),(j4,in(2,4)),(k4,in(3,4))
      data sem/1,3*0,1,3*0,1,96,3*0,1,3*0,1,1,3*0,96,3*0,1,1,3*0,1,3*0,9
     *6,1,3*0,96,3*0,2*96,3*0,1,3*0,2*96,3*0,96,3*0,1,96,3*0,96,3*0,3*96
     *,3*0,1,3*0,2*96,3*0,96,5*0,96,6*0,3*96,8*0,1,6*0,64,128,32,6*0,128
     *,64,3*0,1,3*0,128,64,3*0,96,3*0,3*48,96,3*0,96,0,2*96,2*0,96,48,2*
     *0,96/,nsm/1,2,3,4,5,6,7,5,6,7,8,10,9,9,10,10,10,15,15,13,11,16,16,
     *13,13,16,11,11,12,12,12,8,8,8,8,8,11,10,10,11,11,11,11,12,12/,
     *q/4*0,2*12,9*0,12,0,12,9*0,2*12,11*0,3*12,0,3*12,4*0,3*12,6*0/
      data lsh/2,26,6,11,5,15,7,26,435,28,603,26,453,28,645,15,747,26,
     *771,15,2287,30,2383,32,2299,31,1622,11,899,9,1319,10,1209,10,1749,
     *11,954,9,1601,11,898,9,1221,10,1770,11,955,9,1307,10,2401,13,2547,
     *13,2421,13,5105,16,7303,15,7205,15,29187,12,29687,12,31662,12,1372
     *1,21,13202,11,13210,21,13691,22,17219,21,17221,15,17223,23,17227,
     *13,17229,15,17231,24,17721,24,14137,21,14147,11,14164,21,14170,
     *21,14638,3,14689,25,14692,26,15183,15,15160,21,15185,13,16229,15,
     *16228,11,16230,12,16729,15,15708,34,17122,3,17149,3,17102,21,171
     *29,21,17120,11,17148,11,17155,3,17132,3,17135,21,17112,11,17153,11
     *,17131,11,17603,3,17659,29,17662,15,5204,14,5104,14,5205,16/
      data mst1/3*1,0,2,2,3,0,3,4,4,0,5,6,7,9,10,11/,mst2/3*1,2,0,0,3,3,
     *0,0,4,4,7,5,8,11,0,12/,sys/2/,n,net,is,k/8*1/,id,il,lt,nrt/4
     **0/
      data lgn/1,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,2,0,0,3,4,0,3,4,0,
     *3,4,0,3,4,0,3,0,0,3,0,0,5,7,0,5,3,0,5,3,0,3,5,0,2,0,0,4,2,0,4,2,0,
     *4,2,0,4,2,0,5,0,0,5,0,0,7,10,0,7,4,0,7,4,0,7,10,0,2,5,0,5,14,0,
     *5,14,0,2,0,0,4,2,0,4,2,0,4,2,0,7,8,6,5,0,0,6,3,0,10,11,13,10,8,0,
     *10,8,0,14,19,22,8,5,0,26,37,5,14,5,0/,mcc,ngo,ncs,s,in,lgt/66*0/
      data lf/1,1,-2,1,-3,1,-4,1,2,1,3,1,4,1,2,-3,-4,1,3,-2,-4,1,4,-2,-3
     *,1,4,2,3,1,4,-15,-14,1,4,15,14,1,4,15,14,-2,-3,-13,-16,1,4,2,3,-13
     *,-16,-14,-15,1,4,13,16,-2,-3,-14,-15,1,4,2,3,13,16,14,15,1,3,5,1,3
     *,5,-9,-11,-7,1,3,5,-10,-8,-12,1,3,5,9,11,7,1,3,5,10,8,12,1,3,5,-4,
     *-2,-6,1,4,3,5,2,6,1,4,3,5,2,6,-9,-11,-7,-10,-8,-12,1,3,5,10,8,12,-
     *9,-11,-7,-4,-2,-6,1,3,5,9,11,7,-10,-8,-12,-4,-2,-6,1,4,3,5,2,6,9,1
     *1,7,10,8,12,1,4,2,3,5,9,7,12,8,10,6,11,1,4,2,3,5,9,7,12,8,10,6,11,
     *-13,-16,-14,-15,-17,-21,-19,-24,-20,-22,-18,-23,1,4,2,3,5,9,7,12,8
     *,10,6,11,13,16,14,15,17,21,19,24,20,22,18,23/,t  /144*0/
      data ges/1,3*0,1,3*0,1,1,3*0,-1,3*0,2*-1,3*0,1,3*0,2*-1,3*0,
     *-1,3*0,1,0,1,3*0,1,1,3*0,1,3*0,2*-1,3*0,-1,3*0,1,-1,3*0,-1,3*0,-1,
     *1,4*0,1,1,3*0,1,3*0,1,-1,3*0,-1,3*0,-1,1,3*0,-1,3*0,2*-1,3*0,
     *1,2*0,-1,0,-1,4*0,-1,0,-1,0,1,4*0,1,0,1,0,-1,4*0,1,0,1,0,1,4*0,
     *2*-1,4*0,-1,0,-1,0,-1,4*0,1,0,1,0,1,4*0,-1,0,1,0,1,4*0,1,0,-1,
     *3*0,-1,0,-1,0,-1,4*0,-1,0,1,0,1,4*0,1,0,-1,0,1,4*0,1,0,1,0,-1,0,0,
     *1,3*0,1,3*0,1,1,1,0,-1,4*0,1,0,1,0,2*-1,3*0,1,-1,3*0,-1,3*0,1,2*-1
     *,0,1,4*0,1,0,-1,0,1,1,3*0,1,0,1,0,1,4*0,-1,1,1,0,0,-1,3*0,-1,1,0,
     *0,2*-1,3*0,-1,0,-1,0,-1,4*0,3*-1,0,0,1,3*0,2*-1,0,0,1,1,3*0,-1/
      data iss/111,711,171,117,211,121,112,277,727,772,222,-389,411,477,
     *-373,-328,422,311,371,317,321,312,-589,611,677,-528,-573,622,231,-
     *363,432,-89,218,128,119,777,-289,418,484,-229,-283,684,618,737,731
     *,1,5,6,7,11,18,13,17,21,22,28,24,31,29/
      data texc/'triclinic   ','monoclinic  ','orthorhombic',
     *'tetragonal  ','hexagonal   ','cubic       '/
      data hbr/1hp,1ha,1hb,1hc,1hf,1hi,1hr,1hy,1h /
     *,hs/1hm,1ha,1hb,1hc,1hn,1hd,1h-,1h0,1h1,1h2,1h3,1h4,1h5,1h6,1h//
      data ntex/2h  ,2h  ,4*0,2h+1,2h/8,2h+1,2h/6,2*0,2h+1,2h/4,2*0,2h+1
     *,2h/3,2h+3,2h/8,4*0,2h+1,2h/2,6*0,2h+2,2h/3,2*0,2h+3,2h/4,2*0,2h+5
     *,2h/6/,teb/2h  ,2h-z,2h  ,2h-y,2h x,2h-y,2h  ,2h-x,0,0,2h  ,2h x,
     *2h y,2h-x,2h  ,2h y,2h  ,2h z/,txa/3*2h 0,2h g,3*2h 0,2h g,3*2h 0,
     *2
     *h g,2h 0,3*2h g,2h 0,3*2h g,2h 0,3*2h g,2h h,2h k,2h 0,2h h,2h k,2
     *h g,2h h,2h k,2h l/,txb/5*2h  ,2hh+,2hk=,2h2n,2*2h  ,2hh+,2hk+,2hl
     *=
     *,2h2n,2h  ,2h2h,2h+4,2hk+,2hg=,2h6n,2h2h,2h+k,2h=3,2hn ,2h  ,2hh+,
     *2hk+,2hl=,2h4n,2h  ,2h2h,2h+2,2hk+,2hg=,2h4n/,atx/11,21,31,41,51,6
     *1
     *,71,81,92,102,101,113,91,104,95,105,86,107/,get/3*0,12,3*0,12,3*0,
     *1
     *2,0,3*12,0,3*12,0,3*12,0,3*6,0,3*6,0,3*6,18,2*6,0,0,4,0,0,6,0,0,8,
     *0,0,12,0,0,16,0,0,18,0,0,20,18,6,0,18,12,6,18,6,3,18,6,9,0,18,0,0,
     *6,0,0,6,3,6,0,0,0,12,6,9,9,0,9,0,9,0,9,9,6,18,18,0,18,9/
      data oshift /'                                 '/
c--
c  13 format(2(i3,')',2(4a2,','),4a2))
   13 format(2(1h ,i3,2(4a2,','),4a2))
   15 format(//,' Seminvariant condition : ',3a2,4x,5a2)
   19 format (/,' Crystal family',29x,':  ',a12)
   20 format (/,' Space group (centrosymmetric)',14x,':  ',a16,a33)
   21 format (/,' Space group (noncentrosymmetric)',11x,':  ',a16,a33)
   27 format(/,' Symmetry-operations'/)
   32 format(2a60)
c     read the symbol,determine bravais lattice and crystal family.
      i=hbr(8)
      do 99 i=1,7
   99 if(nt(1).eq.hbr(i)) nbr=i
c     standardization of the symbol
      do 100 i=3,16
      if(nt(i).ne.hbr(9)) goto 95
      k=0
      n=n+1
      goto 100
   95 if(nt(i).eq.hs(11).or.nt(i).eq.hs(14))sys=5
      do 96 j=1,15
   96 if(nt(i).eq.hs(j)) in(n,k)=j-8
  100 k=k+1
      if(i1.eq.4.or.i1.eq.-1.and.i2.eq.4) sys=4
      if(j1.eq.3) sys=6
      if(j1.eq.0.and.i1.eq.1.or.i1.eq.-1.and.i2.eq.1)sys=1
      if(sys.eq.2.and.j1.eq.0)goto 105
      if(sys.eq.2.and.i1.ne.1.and.j1.ne.1.and.k1.ne.1)sys=3
      goto 107
  105 do 106 i=1,4
      in(2,i)=in(1,i)
  106 in(1,i)=0
      i1=1
      k1=1
c     determination of code no. ngc for the point group
  107 do 97 i=1,3
      if(in(i,1).ne.0) is(i)=in(i,1)
      if(is(i).eq.-1) is(i)=-in(i,2)
      if(in(i,1).lt.-1) is(i)=7
      if(in(i,1).gt.-2) goto 94
      in(i,4)=in(i,1)
      in(i,1)=1
   94 if(in(i,2).ne.7) goto 97
      in(i,4)=in(i,3)
      in(i,3)=7
      in(i,2)=0
   97 continue
      if(k1.eq.2.and.(j1.eq.2.or.j1.eq.3))nrt=1
      m=100*is(1)+10*is(2)+is(3)+i3+j3+k3
      do 109 i=1,45
  109 if(m.eq.iss(i)) ngc=i
c     fix code no. ncs for centrosymmetry
      if(ngc.le.31) ncs=1
      nd=ngc
      if(nd.gt.31) nd=iss(ngc+14)
c     rotation parts
      do 110 i=1,216
      if(lf(i).eq.1) id=id+1
      if(id-nd) 110,112,120
  112 m=lf(i)*isign(1,lf(i))+24*(5/sys)*(sys/5)
      ngo=ngo+1
      do 111 k=1,3
      do 111 l=1,3
  111 r(ngo,k,l)=ges(k,l,m)*isign(1,lf(i))
  110 continue
c     multiplcation table
  120 do 90 i=1,ngo
      do 124 j=1,3
      do 124 k=1,3
  124 if(ncs.eq.0) r(ngo+i,j,k)=-r(i,j,k)
      do 90 j=1,ngo
      do 91 k=1,3
      do 91 l=1,3
   91 sc(k,l)=0
      do 92 k=1,3
      do 92 l=1,3
      do 92 m=1,3
   92 sc(k,l)=sc(k,l)+r(i,k,m)*r(j,m,l)
      do 93 k=1,ngo
      do 89 l=1,3
      do 89 m=1,3
      if(sc(l,m).ne.r(k,l,m)) goto 93
   89 continue
      ngt(i,j)=k
      if(ncs.eq.0)ngt(ngo+i,j)=k+ngo
      if(ncs.eq.0)ngt(i,ngo+j)=k+ngo
      if(ncs.eq.0)ngt(ngo+i,ngo+j)=k
      goto 90
   93 continue
   90 continue
      if(ncs.eq.0)ngo=ngo+ngo
c     select translation parts for generators
      if(ngc.eq.30.or.ngc.eq.31) il=1
      if(sys.eq.3) mcc=400*nbr+i4*49+j4*7+k4+399
      if(sys.ge.4)mcc=1000*nd+100*nbr+25*((k4+7)/2)+5*i4+j4+42+4*i2+j2*2
      if(sys.eq.5)mcc=3000+100*ngc+i2+j1+k1
      if(ngc.eq.11) mcc=i2*4+j2*2+k2
      do 122 i=1,3
      l=in(i,4)+8
      if(l.ge.7) goto 122
      il=il+1
      net(il)=mst1(i,l)
      if(sys.gt.3) net(il)=mst2(i,l)
  122 continue
      if(ngc.eq.30.and.k4.eq.-2) net(il)=13
      if(il.ge.2) goto 130
      do 123 i=1,3
      if(in(i,1).ne.2) goto 123
      il=il+1
      net(il)=1+i*in(i,2)
      if(sys.gt.3.and.in(i,1).ne.-1) net(il)=1+in(i,2)
      if(sys.eq.6) net(il)=1+5*in(i,2)
  123 continue
      if(i1.lt.3.or.i1.gt.6.or.i2.eq.0) goto 130
      il=il+1
      net(il)=13+(10*i2)/i1-(i2+i2)/i1
  130 n=net(3)
      if(ngc.eq.31)n=1+7*(i2/2)+i2/3+i2*(10*i2*i2-42*i2+43+mod(nbr,5))
      do 129 i=1,3
      m=net(i)
      id=lgn(i,ngc)
      if(id.eq.0) goto 128
      do 129 j=1,3
      t(id,j)=get(j,m)-nrt*(i/2)*(2/i)*(1-2*(sys/6))*get(j,n)
  129 if(nrt.eq.0.and.sys.lt.4.and.nbr.ne.5) s(j)=get(j,m)/2+s(j)
c     complete translation parts
  128 do 131 i=1,3
      if(lgn(i,ngc).eq.0) goto 131
      lt=lt+1
      lgt(lt)=lgn(i,ngc)
  131 continue
  135 if(lt.eq.ngo) goto 200
      n=0
      do 132 i=1,lt
      do 132 j=1,lt
      il=lgt(i)
      jl=lgt(j)
      kl=ngt(il,jl)
      do 133 m=1,ngo
      if(lgt(m).eq.kl) goto 132
  133 continue
      do 136 k=1,3
      do 134 l=1,3
  134 t(kl,k)=t(kl,k)+r(il,k,l)*t(jl,l)
      t(kl,k)=t(kl,k)+t(il,k)+48
  136 t(kl,k)=mod(t(kl,k),24)
      n=n+1
      lgt(lt+n)=kl
  132 continue
      lt=lt+n
      goto 135
c     selection of origin
  200 continue
      l=ishif+1
      if (l.eq.1) go to 219
      do 218 l=1,3
  218 s(l)=kshif(l)
      oshift(1:16)='( origin shift ='
      oshift(33:33)=')'
      iniz=18
      do 6923 l=1,3
         if (kshif(l).eq.0) then
                              oshp='  0  '
                            else
                              kk=24/kshif(l)
                              if (kk.le.9) then
                                             write(oshp,1000) kk
                                           else
                                             write(oshp,1100) kk
                                           endif
                            endif
         oshift(iniz:iniz+4)=oshp
         iniz=iniz+5
 6923  continue
 1000 format('1/',i1,'  ')
 1100 format('1/',i2,' ')
  219 n=0
      do 201 i=1,78
  201 if(mcc.eq.lsh(1,i)) n=lsh(2,i)
      if(n.eq.0) goto 210
      do 202 i=1,3
  202 s(i)=s(i)+get(i,n)
  210 do 211 i=1,ngo
      do 216 j=1,3
      t(i,j)=t(i,j)+r(i,j,1)*s(1)+r(i,j,2)*s(2)+r(i,j,3)*s(3)-s(j)+48
  216 t(i,j)=mod(t(i,j),24)
      if(nbr.eq.1.or.nbr.eq.7) goto 211
      nd=72
      do 214 l=1,4
      ne=0
      do 212 k=1,3
      is(k)=t(i,k)+q(k,l,nbr-1)
  212 ne=ne+mod(is(k),24)
      if(nd.le.ne) goto 214
      nd=ne
      do 213 k=1,3
  213 t(i,k)=mod(is(k),24)
  214 continue
  211 continue
      write(ncwu,19) texc(sys)
      write(space,'(16a1)') nt
      call ucase(space(1:1))
      if(ncs.eq.0) write(ncwu,20) space,oshift
      if(ncs.eq.1) write(ncwu,21) space,oshift
      write(ncwu,27)
      ne=(ngo+1)/2
      do 423 n=1,60
  423 buffer(ne)(n:n)=' '
      do 424 n=1,ne
      id=2-(n+n-1)/ngo
      do 425 l=1,2
      is(l)=l+(n-1)*2
      i=is(l)
      do 425 j=1,3
      nd=r(i,j,1)+r(i,j,2)*3+r(i,j,3)*4+5
      tx(1,j,l)=teb(1,nd)
      tx(2,j,l)=teb(2,nd)
      do 425 k=1,2
      m=t(i,j)*2+k
  425 ll(k,j,l)=ntex(m)
      write(buffer(n),13)(is(m),(tx(1,j,m),tx(2,j,m),ll(1,j,m),ll(2,j,m)
     *,j=1,3),m=1,id)
  424 continue
      write(ncwu,32) (buffer(m),m=1,ne)
c     seminvariants
      nse=nsm(ngc)
      if(sys.eq.6.and.nbr.eq.5) nse=8
      if(nbr.eq.5.and.(ngc.eq.11.or.ngc.eq.29.or.ngc.eq.30)) nse=17
      if(nbr.eq.6.and.(ngc.eq.12.or.ngc.eq.16)) nse=18
      if(nbr.eq.7.and.(ngc.eq.37.or.ngc.eq.21.or.ngc.eq.40)) nse=14
      m=atx(nse)/10
      n=atx(nse)-10*m
      write(ncwu,15)(txa(i,m),i=1,3),(txb(j,n),j=1,5)
      do 426 jj=1,3
  426 jvet(jj)=txa(jj,m)
      do 427 jj=1,5
  427 jvet(jj+3)=txb(jj,n)
      isys=sys
      isv=1
      do 503 i=1,3
      do 503 j=1,3
      jsem=sem(i,j,nse)
      svet(isv)=jsem
      isv=isv+1
  503 continue
      svet(10)=3
      ngen=0
      do 504 i=1,3
      if (lgn(i,ngc).eq.0) go to 504
      ngen=ngen+1
  504 continue
c ---------------
c -------   calcola tmat
c
      do 505 i=1,ngo
      do 505 j=1,3
      tmat(i,j)=0.0
      if(t(i,j).eq.0) goto 505
      tmat(i,j)=float(t(i,j))/24.
  505 continue
      call modif(r,tmat,ngo,ncs,nt)
      call calmod(ngc,nbr,ncs,sem,nse)
      return
      end
c-----------------------------------------------------------------------
      subroutine modif(r,tmat,ngo,ncs,nt)
      common/sym/isba(2,3,24),tsba(3,24),nsym,dummy(2),icent,latt,s3s2,e
     *          ,s3s2p
      integer nt(16),r(48,3,3)
      dimension tmat(48,3)
      icent=1-ncs
      nsym=ngo
      if (icent.eq.1) nsym=nsym/2
      latt=nt(1)
      call musym(r,tmat,nsym,isba,tsba)
      return
      end
c-----------------------------------------------------------------------
      subroutine calmod(ngc,nbr,ncs,sem,nse)
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen,
     * irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      integer jmat(3,3),norv(3),sem(3,3,18)
      data jmat,norv/12*0/
c
      do 5 j=1,3
      nss(j)=0
      modul(j)=256
    5  continue
      do 10 j=1,3
      do 10 i=1,3
      isem=sem(i,j,nse)
      norv(j)=norv(j)+isem
      if(isem.lt.modul(j).and.isem.gt.1) modul(j)=isem
      jmat(i,j)=isem
   10 continue
      do 50 j=1,3
      if(modul(j).eq.0) goto 50
      do 40 i=1,3
   40 jmat(i,j)=jmat(i,j)/modul(j)
      modul(j)=192/modul(j)
   50 continue
      nori=3
      do 60 i=1,3
      j=3-i+1
      if(norv(j).gt.0) goto 70
      nori=nori-1
   60 continue
   70 continue
      do 80 i=1,3
      do 75 j=1,3
      if(sem(i,j,nse).ne.1) goto 75
      jmat(i,j)=1
   75 continue
      do 80 j=1,3
   80 nss(i)=nss(i)+jmat(i,j)
c --     nbr is the lattice code  p=1, a=2, b=3, c=4, f=5, i=6, r=7
      goto(100,600,1000,600,500,600,700),nbr
  100 if(ncs.eq.0) goto 1000
      if(ngc.ne.22.and.ngc.ne.23.and.ngc.ne.26) goto 1000
      nori=1
      nss(2)=4
      nss(3)=3
      modul(1)=6
      modul(2)=0
      goto 1000
  500 nori=1
      modul(2)=0
      modul(3)=0
      if(ngc.eq.10) goto 550
      nss(1)=1
      nss(2)=1
      modul(1)=2
      if(ncs.eq.1) modul(1)=4
      goto 1000
  550 nss(1)=0
      nss(2)=0
      modul(1)=0
      goto 1000
  600 nori=nori-1
      if(nori.gt.0) goto 620
      do 610 k=1,3
  610 modul(k)=1
      goto 1000
  620 continue
      do 630 k=1,2
      j1=2-k+1
      j2=j1
      if(nbr.eq.6.and.nori.eq.2) j1=k
      if(modul(j1).eq.0) goto 630
      nss(j1)=0
      modul(j2)=0
      goto 640
  630 continue
  640 if(nbr.eq.4) goto 650
      if(nbr.ne.6) goto 1000
      if(ngc.ne.12.and.ngc.ne.16) goto 650
      nori=1
      nss(1)=0
      nss(2)=2
      nss(3)=-1
      modul(1)=4
      modul(2)=0
      modul(3)=0
      goto 1000
  650 if(nori.eq.1) goto 680
      modul(2)=modul(3)
      modul(3)=0
      goto 1000
  680 nss(1)=0
      nss(2)=0
      goto 1000
  700 if(ncs.eq.0) goto 1000
      if(ngc.ne.18.and.ngc.ne.19) goto 1000
      nori=1
      nss(3)=0
 1000 return
      end
c     ------------------------------------------------------------------
      subroutine extin(jex,kg1,kg2,kg3,ibrav,klatt,ksym,vsym)
c   check for extinction (jex=0/1 allowed/absent)
c   first: check bravais lattice type
c   type  p   a  b    c   i    f   r
c   latt: 1   2   3   4   5    6   7
c   ibrav(    1   2   3   4    5   6  )  x  13
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      integer ibrav(6,13),kg(3),vsym(24),mr(3)
c
      kg(1)=kg1
      kg(2)=kg2
      kg(3)=kg3
      do 10 i=1,3
      if (kg(i).ne.0) go to 20
   10 continue
      jex=1
      return
   20 jex=0
      if(klatt.eq.0) go to 420
      nbrav=ibrav(klatt,1)
      do 410 i=1,nbrav
      isum=0
      do 400 j=1,3
      lb=1+(i-1)*4+j
 400  isum=isum+kg(j)*ibrav(klatt,lb)
      lb=4*i+1
      if(mod(isum,ibrav(klatt,lb)).eq.0) go to 410
      jex=1
      go to 700
410   continue
420   continue
c   second: check translations from symmetry operators
c         first condition for h to absent:  h*ri=h   (h=kg)
      if (ksym.eq.0) go to 700
      jc=icent+1
      do 490 kc=1,jc
      do 480 lsym=1,ksym
      isym=vsym(lsym)
        ca=0.
      do 470 jj=1,3
      nh=0
      do 430 j=1,3
430     mr(j)=0
      do 450 i=1,2
      do 440 j=1,3
      ikk=is(i,j,isym)
       ka=iabs(ikk)
      if(ka.ne.jj)goto 440
      if(kc.eq.2) ikk=-ikk
      mr(j)=isign(1,ikk)
440   continue
450   continue
      do 460 j=1,3
460   nh=kg(j)*mr(j)+nh
      if(kg(jj).ne.nh)goto 480
      ca=float(nh)*ts(jj,isym)   +  ca
470   continue
c  second condition:    h*ts ; integer, for an ext. reflexion.
      ca=abs(ca)
      ica=(ca+0.0005)*1000
      if(mod(ica,1000).eq.0)goto 480
c  variable ca is not an integer number,the reflexion is absent.
      jex=1
      goto 700
480     continue
490   continue
700     continue
      return
      end
c-----------------------------------------------------------------------
      subroutine geneq(lty,ih,kk,il,idelt,jcode,isnn,istd,rho)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      dimension kl1(24),kl2(24),kl3(24),i1(3),i2(3),ise(24)
c
      isnn=1
      rho1=rhof(p,ih,kk,il)
      rho=rho1*rho1
      if (rho.lt.th) then
      i1(1)=ih
      i1(2)=kk
      i1(3)=il
      jcode=13
      ido=1
      maxi=1
      ise(maxi)=1
      do 250 j=1,nsym
      kl1(j)=2400
      kl2(j)=2400
      do 200 i=1,3
      i2(i)=0
      kl1(j)=kl1(j)-i1(i) * int(ts(i,j)*24+0.01)
      kl2(j)=kl2(j)-i1(i) * int(ts(i,j)*12+0.01)
  200 continue
      kl1(j)=mod(kl1(j),24)
      do 220 i=1,3
      do 210 k=1,2
      m=iabs(is(k,i,j))
      if(m.gt.0) i2(m)=i2(m)+i1(i)*isign(1,is(k,i,j))
  210 continue
  220 continue
      if(icent.eq.1.or.ido.ne.1) goto 230
      jcode=1
      do 225 i=1,3
      if (i1(i)+i2(i).ne.0) go to 230
  225 continue
      jcode=mod(kl2(j),12)+1
      if(jcode.le.1) jcode=jcode+12
      ido=0
  230 ind=262144 * i2(1) + 512 * i2(2) + i2(3)
      kl3(j)=131328 + iabs(ind)
      if (lty.eq.1) then
                      rhomax=amax1(rhomax,rho1)
                      if(ihx(1).lt.iabs(i2(1))) ihx(1)=iabs(i2(1))
                      if(ihx(2).lt.iabs(i2(2))) ihx(2)=iabs(i2(2))
                      if(ihx(3).lt.iabs(i2(3))) ihx(3)=iabs(i2(3))
                    endif
      if (j.ne.1) then
          jm1=j-1
          do 240 i=1,jm1
          if(kl3(i).eq.kl3(j)) kl3(j)=0
  240     continue
          if(kl3(j).gt.kl3(maxi)) then
                                    maxi=j
                                    ise(maxi)=isign(1,ind)
                                  endif
                  endif
  250 continue
      isnn=ise(maxi)
      call sir_unpack (kl3(maxi),ih,kk,il)
      idelt=kl1(maxi)*15
      istd=0
      if (lty.eq.1) return
      if (i1(1).eq.ih.and.i1(2).eq.kk.and.i1(3).eq.il) istd=1
      endif
      return
      end
c------------------------------------------------------------
      function rhof(p,jh,jk,jl)
      dimension p(6)
c
      rho2=p(1)*float(jh*jh)+p(2)*float(jk*jk)
     1 +p(3)*float(jl*jl)+p(4)*float(jh*jk)
     2 +p(5)*float(jh*jl)+p(6)*float(jk*jl)
      rhof=sqrt(rho2)
      return
      end
c------------------------------------------------------------
      subroutine getfrg(line,lenp,dire,diret,ic,icmax,ier)
      character*(*) line,dire,diret
      character blank,digit*12,card(100)*80,ffile*80
      common /comdir/ icomq(200,2),maxcom,ipcom,ipdir,icomat
      common /chara/ blank,digit,card,ffile
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common /atoms/ x(5,200),nz(200),ngp,ninf(10),nag(10)
      dimension vet(40),ivet(40)
      dimension xo(11),xn(11),key(10),newvet(48,3)
c
      ier=0
      n=0
      do 10 i=1,10
   10 n=n+nag(i)
      nn=n
      if (lenp.gt.0) go to 105
  100 continue
      ic=ic+1
      if (ic.gt.icmax) go to 9000
      ipdir=ipdir+1
      line=card(ipdir)
      diret=line
  105 call cutst(line,lenp,dire,lend)
      call lcase(dire)
      if (lenp.le.0.and.lend.le.2) go to 8000
      if (lend.gt.2) go to 7000
      n=n+1
      read(dire(1:2),'(a2)') nz(n)
      iopt=0
      call getnum(line,vet,ivet,iv,iopt)
      if (iopt.eq.-1) go to 8000
      if (iv.ne.3.and.iv.ne.4) go to 8000
      do 120 i=1,iv
  120 x(i,n)=vet(i)
      if (iv.eq.3) then
                     xo(1)=x(1,n)
                     xo(2)=x(2,n)
                     xo(3)=x(3,n)
                     iser=n
                     iactn=1
                     khead=0
                     ksp=kspecb(newvet,xo,xn,key,itype,iser,khead,iactn)
                     x(4,n)=1.0/float(key(10))
                   endif
      x(5,n)=x(4,n)
      go to 100
 7000 continue
      nag(ngp)=n-nn
      line=diret
      return
 8000 continue
      ier=-1
      return
 9000 continue
      nag(ngp)=n-nn
      ier=1
      return
      end
c-----------------------------------------------------------------------
      subroutine getcon(line,dire,nw,nalf,ier)
      character*(*) line,dire
      dimension nalf(8),nw(8),vet(40),ivet(40)
c
      ier=0
      do 150 i=1,8
      call cutst(line,lenp,dire,lend)
      if (lenp.le.0) go to 300
      ier=ier+1
      read(dire,'(a2)') nalf(i)
      iopt=1
      call getnum(line,vet,ivet,iv,iopt)
      if (iopt.eq.-1) go to 300
      nw(i)=ivet(1)
      call cutst(line,lenp,dire,lend)
      if (lenp.le.0) go to 200
  150 continue
  200 continue
      return
  300 continue
      ier=-1
      return
      end
c-----------------------------------------------------------------------
      subroutine onebl(string,lenstr,ier)
      character blank,string*(*),buff*16,poss*22
      dimension in(7)
c
      ier=0
      poss='pabcifrmabcnd-123456/ '
      blank=poss(22:22)
      k=len(string)
c
c-- check the number of blanks between items in space
c-- group symbol ( max one blank allowed )
c
      do 5 i=1,16
    5 buff(i:i)=blank
      ic=0
      j=1
      do 10 i=1,k
      if (string(i:i).ne.blank) then
                                  buff(j:j)=string(i:i)
                                  j=j+1
                                  if (j.gt.16) go to 15
                                  ic=0
                                else 
                                  if (ic.eq.0) then
                                      ic=ic+1
                                      buff(j:j)=string(i:i)
                                      j=j+1
                                      if (j.gt.16) go to 15
                                    endif
                                endif
   10 continue
   15 do 20 i=1,16
   20 string(i:i)=buff(i:i)
c
c-- now check the correctness of the space group symbol 
c
c     poss='pabcifrmabcnd-123456/ '
c                  123456789012345
c-- ifoll = possible following character
c         = 0   initial state ( actual char = blank )
c         = 1   only numbers < 7 ( not 5 )
c         = 2   only numbers < actual number or / or blank
c         = 3   only letters
c         = 4   only blank
      if (string(2:2).ne.blank) go to 800
      n=0
      k=0
      iz=0
      nbr=0
      do 99 i=1,7
      in(i)=0
  99  if (string(1:1).eq.poss(i:i)) nbr=i
      if(nbr.eq.0) go to 800
      do 100 i=2,lenstr
      if(string(i:i).ne.blank) go to 101
      minus=1
      num=0
      ifoll=0
      k=k+1
      go to 100
 101  m=0
      do 102 j=1,14
 102  if(string(i:i).eq.poss(j+7:j+7)) m=j
      if(m.eq.0.or.k.gt.3) go to 800
c     poss='pabcifrmabcnd-123456/ '
c                  123456789012345
           if (m.ge.1.and.m.le.6.and.ifoll.eq.3) then
                                        ifoll=4
      else if (m.ge.1.and.m.le.6.and.ifoll.eq.0) then
                                        ifoll=4
      else if (m.eq.7.and.ifoll.eq.0) then
                                        ifoll=1
                                        minus=-1
                                        num=num+1
      else if (m.ge.8.and.m.le.13.and.ifoll.le.1) then
                                        ifoll=2
                                        iold=m-7
                                        if (iold.eq.5) go to 800
                                        num=num+1
                                        if (num.gt.2) go to 800
      else if (m.ge.8.and.m.le.13.and.ifoll.eq.2) then
                                        inew=m-7
                                        if (inew.ge.iold) go to 800
                                        num=num+1
                                        if (num.gt.2) go to 800
                                        ifoll=2
      else if (m.eq.14.and.ifoll.eq.2) then
                                        ifoll=3
                                      else
                                        go to 800
                                      endif
 100  continue
      if (minus.lt.0.and.num.eq.1) go to 800
c
c-- space group symbol ok
c
      return
c
c-- error
c
  800 continue
      ier=-1
      return
      end
c------------------------------------------------------------
      subroutine unobs(kv,ibrav,klatt,ksym,vsym,jnbl,knbl)
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
      common/ureq/ ihx(3),none,knw,jpart,jtran,fosog,ifper,iprin,iflag
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common /buffer/ vet(6,85),nrpb,idumb(4)
      common /xdata/ ibig(244000)
      common /genob/ irho
c---
c  if ibig dimension has to be changed, alter mxbg accordingly
      integer vsym(24),ibrav(6,13),jnbl(128),knbl(128)
      integer  hmin,hmax,kmin,kmax,lmin,lmax                  
      dimension ivet(6,85),kv(3)
      equivalence (vet(1,1),ivet(1,1))
c---
      nitem=6
      mxbg=244000
      rhomax1=rhomax
      if (irho.lt.0) then
                       lty=0
                     else
                       lty=0
                     endif
c
c-- at this point the allowed reflections are on the scratch file(iscra)
c-- it is possible to add (optionally)  unobserved reflections
c
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
c
c-- ibig has been already filled with observed reflections
c
      nru=0
      nr=nref
c --
c --
      nnn=nrec
      i=mod(nref,nrpb)
      if (i.eq.0) then
         nnn=nnn+1
      else
        read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      endif
c--------------------
      call indmm(hmin,hmax,kmin,kmax,lmin,lmax)
c---------------------------------------------------------------
      nhmax=hmin
      nkmax=kmin
      nlmax=lmin
c-------------
      do  800 indh=hmin,hmax
      do  700 indk=kmin,kmax
      do  600 indl=lmin,lmax
      if (indh.eq.0.and.indk.eq.0.and.indl.eq.0) go to 600
c---
c---  vedere se il nuovo riflesso generato e' equivalente
c---  ad uno gia' considerato, in questo caso :
c---
c   
c    TRIGONALE : va' considerata la condizione aggiuntiva /h/>/k/
c                nel caso (+-+)
c               
      if (lsys.eq.5.and.indk.lt.0.
     *and.iabs(indh).lt.iabs(indk)) goto 600
c   
c    CUBICO :  va' considerata la condizione aggiuntiva h<=k<=l
c    
      if(lsys.eq.6.and.(indk.lt.indh.and.indk.gt.indl)) goto 600
c
      indh1=indh
      indk1=indk
      indl1=indl
Corig inbl=indh1*kv(1) + indk1*kv(2) + indl1 + kv(3)
      inbl=indh1*kv(1) + indk1*kv(2) + indl1
      inbl=iabs(inbl)
      if (ibig(inbl).ne.0) go to 600
      call extin(jex,indh1,indk1,indl1,ibrav,klatt,ksym,vsym)
      if (jex.ne.1) then
      call geneq(lty,indh1,indk1,indl1,idelt,jcode,isgnn,id1,rho)
      if (rho.gt.rhomax1) go to 600
      if (iabs(indh1).gt.ihx(1).
     * or.iabs(indk1).gt.ihx(2).
     * or.iabs(indl1).gt.ihx(3)) 
     *                           go to 600
Corig inbl=indh1*kv(1) + indk1*kv(2) + indl1 + kv(3)
      inbl=indh1*kv(1) + indk1*kv(2) + indl1
      inbl=iabs(inbl)
      if (ibig(inbl).ne.0) go to 600
c
c-- fill ibig using unobserved reflection and its equivalents
c
      ibig(inbl)=-10
c
      nru=nru+1
      if (irho.ge.0) then
                       i=i+1
                       ivet(1,i)=indh1
                       ivet(2,i)=indk1     
                       ivet(3,i)=indl1     
                       vet(4,i)=0.0
c
c -- sigma field set to -1 for generated reflection
c
                       vet(5,i)=-1.0
                       ivet(6,i)=jcode
                       nr=nr+1
                       if(i.eq.nrpb)then
                                      write(iscra,rec=nnn) 
     *                              ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
                                      i=0
                                      nnn=nnn+1
                                    endif
                     endif
                    endif
  600 continue
  700 continue
  800 continue
c
      if (irho.ge.0) then
                      if (i.gt.0) write(iscra,rec=nnn) 
     *                ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
                      nref=nr
                      if (nru.gt.0) write(lo,310) nru
                    else
                      if (nru.gt.0) write(lo,320) nru
                    endif
  310 format(10x,i5,'  reflections (not in input data) have been added')
  320 format(10x,i5,'  reflections are not in input data')
      rhomax=rhomax1
      return
      end
c-----------------------------------------------------------------------
      subroutine indmm(hmin,hmax,kmin,kmax,lmin,lmax)
c
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/ureq/ ihx(3),none,knw,jpart,jtran,fosog,ifper,iprin,iflag
      integer  hmin,hmax,kmin,kmax,lmin,lmax                  
      character ntc*16
c
      write(ntc,'(16a1)') nt
c --
c --   calcolo hmin e hmax , kmin e kmax , lmin e lmax                  
c --
        hmin=-ihx(1)
        hmax=ihx(1)
        kmin=-ihx(2)
        kmax=ihx(2)
        lmin=-ihx(3)
        lmax=ihx(3)
c --
c -- TRICLINO
c --
      if (lsys.eq.1) then
        hmin=0
c --
c -- MONOCLINO
c --
      else if (lsys.eq.2) then
       if (ntc(3:3).eq.'1') then
        if (ntc(5:5).eq.'1') then
c -- 2//c
            hmin=0
            lmin=0         
        else 
c -- 2//b
            hmin=0
            kmin=0         
        endif      
       else
        if (ntc(4:4).eq.'1') then
         if (ntc(6:6).eq.'1') then
c -- 2//a
            hmin=0
            kmin=0
         else
c -- 2//b
            hmin=0
            kmin=0         
         endif
        else
         if(ntc(5:5).eq.'1') then
c -- 2//a
            kmin=0
            hmin=0
         else
c -- 2//b
            hmin=0
            kmin=0         
         endif
        endif
       endif
c --
c -- ORTOROMBICO
c --
      else if (lsys.eq.3) then
          hmin=0
          kmin=0
          lmin=0
c --
c -- TETRAGONALE : 
c -- 
      else if (lsys.eq.4) then
          hmin=0
          kmin=0
          lmin=0
c --
c -- ESAGONALE E TRIGONALE : 
c -- 
      else if (lsys.eq.5) then
            hmin=0
            lmin=0
c --
c -- CUBICO :  va' considerata la condizione aggiuntiva h<=k<=l
c -- 
      else if (lsys.eq.6) then
           hmin=0
           kmin=0
           lmin=0
      endif
c --
      return
      end
c------------------------------------------------------------
      subroutine caosm(ier)
c
c-- Caos-Sir link routine
c
CHANGE-RIC-OX-98: name must have the correct type even if not needed explicitly.
      character*80 name

      character cff
c   implementation  common
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
c     erlangen
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
c     input/output units, title, flags
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,ifper,iprin,iflag
      common / ureq1/ jpatt,jpunt(501),ksacc,jseteq,jumpp,jmpsie,nsec
c     symmetry
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
c     scratch file reflexion arrays
      common /buffer/ vet(6,85) ,nrpb,idumb(4)
c     atomic scattering factors
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
c     miscellaneous
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
c     wilson plot parameters
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
c     sin/cos table & trigonometric constants
      common/trig/sint(450),pi,twopi,dtor,rtod
c
      write(cff,'(i1)') kff
      write(lo,100) cff,itle
  100 format(///,a1,120('+'),//,
     1 39h SIR92 : Caos-Sir link routine         ,68x,14hRelease  93.02
     2 ,//,20x,20a4,/,1h ,120('+'),//,
     *       40x,'                                 ',//)
c
c-- open the scratch file
      itype=1
      iform=2
      kop=kopen(iscra,name,nlen,itype,ierr)
c-- read directives
      call dircao(ier)
      if (ier.lt.0) go to 900
c-- load in memory lists 1-2-3 and transfer in iscra reflections
      call caos(ier)
      if (ier.lt.0) go to 900
      anat=float(nat)/(pts*float((icent+1)*nsym))
      aa=s3s2*s3s2*pts
c  s3s2p is related to the number of atoms in the primitive cell
      s3s2p=aa*sqrt(1.0/aa)
      s3s2=s3s2p
      is3s2=1./(s3s2p*s3s2p)+0.5
      write(lo,200) anat,is3s2
  200 format(/,39x,'number of atoms in asymmetric unit =',f6.2,/,
     1 31x,'equivalent number of equal atoms in primitive cell =',i6)
c
c-- calculate number of reflexions for (sem)invariant searching
      mn = int(4.0*anat+100.5)
      if (icent.eq.1) mn = mn + 50
      if (nsym.eq.1) mn = mn + 50
      mn = min0(mn,499)
      mm=mn+min0(499-mn,100)/2
c-- create list 7 ( e's )
      npseud=0       
      iy=67543
      if (nref.gt.0) call prepl7(npseud,iy,nref)
c-- finish
      call xdump
  900 close(iscra)
      return
      end
c-----------------------------------------------------------------------
      subroutine caos(ier)
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,ifper,iprin,iflag
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common /buffer/ vet(6,85) ,nrpb,idumb(4)
      dimension ivet(6,85),vat(12),ivat(12)
      equivalence (vat(1)  ,ivat(1)  )
      equivalence (vet(1,1),ivet(1,1))
c
c++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c-- already exists a direct access file containing
c-- information concerning the structure
c
      iln=1
      call srlin (iln,lsn,lix1,ljxx,lkxx,llxx)
      if(lix1.gt.0) then
                       call yfl01
                     else
                       write(lo,1100)
                       ier=-1
                     endif
      iln=2
      call srlin (iln,lsn,lix2,ljxx,lkxx,llxx)
      if(lix2.gt.0) then
                      call yfl02
                     else
                       write(lo,1200)
                       ier=-1
                     endif
      iln=3
      call srlin (iln,lsn,lix3,ljxx,lkxx,llxx)
      if(lix3.gt.0) then
                      call yfl03
                     else
                       write(lo,1300)
                       ier=-1
                     endif
 1100 format(/,' *** error *** no cell parameters supplied')
 1200 format(/,' *** error *** no space group symbol supplied')
 1300 format(/,' *** error *** no cell content supplied')
c++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
      if (ier.lt.0) return
c
c  assign values to constants in preamble of list 7
c
      bt=0.0
      sc=-99.9
c
c  s3s2p is related to the number of atoms in the primitive cell
c
      s3=0
      s2=0
      do 1400 i=1,nk
         ss=float(nw(i))*no(i)*no(i)
         s2=s2+ss
         s3=s3+ss*no(i)
 1400 continue
      s3s2=s3/sqrt(s2**3)
c
      nref=0
      rhm=0.0
      do 1500 i=1,3
 1500 ihx(i)=-100
c
c-- read reflections from list 6
c
      iln=6
      call srlin (iln,lsn,lixx,ljxx,lkxx,llxx)
      if (lixx.le.0) then 
                       write(lo,1510) iln
                       go to 8000
                     endif
 1510 format(' *** error ***  list number',i5,' not existent',/,
     *       '                reflections expected')
      in=0
      call yfl06(in,nref)
c
      fosog=-999.9
      rhomax=-999.9
      sig=1.0
      nnn=0
      nrec=0
      nrec=0
      nuobs=0
      nrmax=0
      rhm=-99.9
      do 1600 i=1,nref
      if (kkfnr(vat).lt.0) go to 9500
      rho=rhof(p,ivat(1),ivat(2),ivat(3))
      rho=rho*rho
      if (rho.gt.rhomax) rhomax=rho
      fo=vat(4)
      eeee=vat(6)
c-    ifasi=mod(ivat(7),2**15)
      if (fo.gt.fosog) fosog=fo
      if(vat(7).lt.0.0) vat(7)=vat(7)+360.0
      iphy=int(vat(7)+0.05)
      call geneq(1,ivat(1),ivat(2),ivat(3),idelt,jcode,isgnn,id1,rho)
      if (rho.gt.rhm) rhm=rho   
      nnn=nnn+1
      iphy=iphy*32+jcode
c      WRITE(LO,*)I,NNN,IVAT(1),IVAT(2),IVAT(3)
      ivet(1,nnn)=ivat(1)
      ivet(2,nnn)=ivat(2)
      ivet(3,nnn)=ivat(3)
      if (fo.gt.fosog) fosog=fo
      vet(4,nnn)=fo
      vet(5,nnn)=vat(5)
      ivet(6,nnn)=iphy
      if (nnn.ge.nrpb) then
                           nrec=nrec+1
                           write(iscra,rec=nrec)
     *                          ((vet(j1,j2),j1=1,6),j2=1,nrpb)
                           nnn=0
                         endif
 1600 continue
      nrec=nrec+1
      write(iscra,rec=nrec) ((vet(j1,j2),j1=1,6),j2=1,nrpb)
c
c-- at this point the allowed reflections are on the scratch file(iscra)
c
 8000 continue
      write(lo,1700) nref,ihx,rhm
 1700 format(  10x,i5, '  independent input reflections',
     *       /, 3x,3i4,'  maximum  h,k,l  values',
     *       /,8x,f7.4,'  maximum s**2 = (sin(theta)/lambda)**2')
      rhomax=rhm
      return
c
 9500 write(lo,9510) iln
 9510 format(' *** error ***  problems in list number',i5)
      ier=-1
      return
      end
c-----------------------------------------------------------------------
      subroutine dircao(ier)
      character line*80,dire*80,diret*80
      character blank,digit*12,card(100)*80,ffile*80
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common /comdir/ icomq(200,2),maxcom,ipcom,ipdir,icomat
      common /chara/ blank,digit,card,ffile
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common /erl/ ksmat(48,3,3),tmat(48,3),nto(16),jsys,ngen
     *,irot(48,48),jsvet(10),isvet(8),nori,modul(3),nss(3)
      common/sym/isp(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emv
     *          ,s3s2p
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,ifper,iprin,iflag
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
c
      dimension vet(40),ivet(40)
c
c-- set default values
      knw=0 
      iffsq=1
      iprin=0
      ishif=0
      jump=-1
      jtran=0
      jpart=0
      bt=0.0
      sc=-99.9
      knw=0
      mm=0
      mz=100
      th=1.0
      rhomin=0.0
      en=1.2
      er=0.3
      ngp=0
      llpse=0
      npc=1
c
      ic=0
      icmax=icomq(icomat,2)
c
  100 continue
      ic=ic+1
      if (ic.gt.icmax) go to 9000
      ipdir=ipdir+1
      line=card(ipdir)
      diret=line
      call cutst(line,lenp,dire,lend)
      call lcase(dire)
c-- directives with numeric parameters
      iopt=0
      call getnum(line,vet,ivet,iv,iopt)
      if (iopt.eq.-1) go to 8000
      if (dire(1:4).eq.'know') then
          if (iv.ne.0) go to 8000
          knw=1
          go to 100
          endif
      write(lo,6000) diret
 6000 format(' wrong directive on following line:',/a)
      go to 100
 8000 continue
      ier=-1
      write(lo,'(22h error in directive : ,a80)') diret
      return
 9000 continue
      return
      end
CRYSTALS CODE FOR NORM92
c-- sir code for normal                          Release 93.02
c
       subroutine normal(ier)
c--
c     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
c        routine for the calculation of normalised structure factors
c
c        version jan  1980                        university of york
c        version april '88                university of perugia-bari
c     * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
c          struttura del buffer vet/ivet
c
c     h   k   l   fo  rho   id   fasi   e  e'/ed  e'p/ew  denor  sig
c     1   2   3   4    5     6    7     8    9      10     11    12
c----------------------------------------------------------------------
c   lista 7
c     h+k+l    e       fo   e'+e'p    phi'+phi+code
c       1      2       3       4            5
c   scompattati in
c     h   k   l   e   fo    e'   e'p  fasi
c     1   2   3   4    5     6    7     8
c----------------------------------------------------------------------
c
      character*80 fileh,name
      character cff
c   implementation  common
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
c  partial structure procedure common
      common /frgmt/ mmold,mzold,ihmax(3),knowo,sumn,sumd,ntype(80)
c     erlangen
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
c     sapi
      common/rsc/ibgr,mg,mig(8),scl,bts(9),scsa(9),ip(8,3,5)
c     input/output units, title, flags
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common / ureq1/ jpatt,jpunt(501),ksacc,jseteq,jumpp,jmpsie,nsec
c     symmetry
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
c     scratch file reflexion arrays
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
c     atomic scattering factors
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
c     known molecular (group) information
      common /atoms/ x(5,200),nz(200),ngp,ninf(10),nag(10)
c     spherical scattering factors
      common/at/gis(142),giw(142)
c     miscellaneous
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
c     wilson plot parameters
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
c     work area common       (160000 integer words)
      common/xdata/ dumx(160000)
     * ,dummpc(84000)
c     sin/cos table
      common/trig/sint(450),pi,twopi,dtor,rtod
c     pseudotranslation information
      common /cpseud/ npsedd,lpseuv(12),llpse
c
      write(cff,'(i1)') kff
      write(lo,10) cff,itle
   10 format(///,a1,120('+'),//,
     1 39h SIR92 : Normalization routine         ,68x,14hRelease  93.02
     2 ,//,20x,20a4,/,1h ,120('+'),//)
c
c-- check if PARTIAL or PSEUDO has been already used.
c-- In this case SIR has to restart from %DATA.
c
      call ysfl07(mm1,mm2,mm3,npseud,mm4)
      if (jpart.ne.0.or.npseud.ne.0) then
          write(lo,30)
          ier=-1
          return
        endif
   30 format(//,' *** error ***  PARTIAL or PSEUDO have been used',/,
     *          '                in a previous run of SIR.       ',/,
     *          '                Restart from %DATA.             ')
c     set up initial values
      mxbg  =160000
      rhomax=0.0
      do 40 i=1,12
   40 lpseuv(i)=0
c
c-- define the number of reflections per block in scratch file
c--   nrpb = (number of words in block) / (number of item per refl)
c
      nitem=13
      nrpb=knwr/nitem
      iflag=0
      itype=1
      iform=2
c
      bto =0.0
      sco=0.0
c
      kop=kopen(iscra,name,nlen,itype,ierr)
  350 continue
      call dirnor(jmppse,jump,s3s2o,fileh,ier,iy)
      if (ier.lt.0) go to 900
      if (jpart.eq.1) then
c  s3s2p is related to the number of atoms in the primitive cell
                        anat=float(nat)/(pts*float((icent+1)*nsym))
                        aa=s3s2*s3s2*pts
                        s3s2p=aa*sqrt(1.0/aa)
                        is3s2=1./(s3s2p*s3s2p)+0.5
                        write(lo,380) anat,is3s2
                        if (nat.eq.0) then
                            write(lo,385)
                            ier=-1
                            return
                          endif
                      endif
  380 format(/,31x,
     1'Number of not localized atoms in asymmetric unit =',f6.2,/,
     2 31x,'Equivalent number of equal atoms in primitive cell =',i6)
  385 format(/,' *** error *** known fragment too big.')
c     read reflexion data from direct access file
c 431 format(//,1h ,120('+'),//,
c    *       40x,'***   normalization section   ***',/)
      if (jpart.le.0) then
                        call hklinp(ier)
                        if(ier.lt.0) return
c                       write(lo,431)
                        call fcal
                      else
                        sumn=0.0
                        sumd=0.0
                        call fcal
                        sumn=100.0*sumn/sumd
                        write(lo,433) sumn,nref
                      endif
  433 format(//,35x,'Resid =',f7.2,'%',3x,'using ',i6,' reflexions',//)
      nb=8.0*alog10(0.05*float(max0(nref,100))+0.5)
c     maximum of 30 points on wilson plot
      if(nb.gt.30) nb=30
      if (nref.le.0) then
                       write(lo,448)
  448 format(/,' *** error *** no reflections supplied')
                       ier=-1
                       return
                     endif
      if (iprin.gt.0.and.jump.lt.0) write(lo,442) nb
  442 format(34h number of points on wilson plot =,i3)
      if(jump.ge.0) go to 450
c     obtain sums for wilson plot and fit least squares straight line
c     bto=bt
c     sco=sc
      if (jpart.eq.1) then
                        bto=bt
                        sco=sc
                        s3s2=s3s2o
                      endif
      call sir_sum(pts,ier)
      if (ier.lt.0) return
c     plot wilson and debye curves and least squares straight line
      call plotw
  450 bt=2.0*bt
      if(jump.ge.0) sc=1.0
c     calculate scale factors for appropriate reflexion groups
      if (jpart.eq.1) go to 500
      call resca
      patom=0.0
      qatom=0.0
      npseud=0
      if (jmppse.eq.0) then
      if (jpart.eq.0.and.jtran.eq.0)  then
                               call pseudo(patom,qatom,scale,npseud,ier)
                               if (ier.lt.0) return
                             endif
                       endif
c
c  call sub. scrittura pseudo
c
      if (npseud.ne.0) call frm19(lpseuv,patom,qatom)
      write(lo,470)
  470 format(//,1h ,120('+'))
c     calculate final e's and output reflexion statistics
  500 bt=bt/2
c
      call ecal(npseud,iy,bto,sco)
      if (jpart.ne.-1) go to 800
c     s3s2o=s3s2p
      iflag=1
      go to 350
  800 continue
c
      call xdump
  900 close(iscra)
      return
      end
c ------------------------------------------------------------------
c     read reflexions from direct access file
      subroutine hklinp(ier)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common /xdata/ ibig(160000)
     * ,dummpc(84000)
      dimension ivet(13,39),vat(9),ivat(9)
      equivalence (vet(1,1),ivet(1,1))
      equivalence (vat(1)  ,ivat(1)  )
c
c-- reflections are in the direct access file
      rhomax=-999.9
      sig=1.0
      nnn=0
      nrec=0
      do 7030 i=1,nref
      nnn=nnn+1
      call snr07(vat)
      if(vat(9).lt.0.0.and.jpart.lt.0) go to 8000
      rho=rhof(p,ivat(1),ivat(2),ivat(3))
      rho=rho*rho
      if (rho.gt.rhomax) rhomax=rho
      ivet(1,nnn)=ivat(1)
      ivet(2,nnn)=ivat(2)
      ivet(3,nnn)=ivat(3)
      fo=vat(5)
      eeee=vat(4)
      ifasi=mod(ivat(8),2**15)
      vet(4,nnn)=fo
      vet(5,nnn)=rho
      vet(6,nnn)=0.0
      ivet(7,nnn)=ifasi
      vet(8,nnn)=eeee
      vet(12,nnn)=sig
      vet(13,nnn)=vat(9)
      if (nnn.eq.nrpb) then
                       nrec=nrec+1
                       write(iscra,rec=nrec)
     *                      ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
                       nnn=0
                     endif
 7030 continue
      nrec=nrec+1
      write(iscra,rec=nrec) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      return
 8000 write(lo,8100)
 8100 format(/,' *** error *** Partial directive not allowed if ',/,
     *         '               reflections have been generated.')
      ier=-1
      return
      end
c     ------------------------------------------------------------------
c     calculate rho, epsilon, multiplicity and scattering factor
c     for each reflexion and create the scratch tape (iscra)
c     prepare file for weighted fourier
      subroutine fcal 
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
      common /frgmt/ mmold,mzold,ihmax(3),knowo,sumn,sumd,ntype(80)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common /atoms/ x(5,200),nz(200),ngp,ninf(10),nag(10)
      common/at/gis(142),giw(142)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      dimension i1(3),i2(3),ivet(13,39)
      equivalence(vet(1,1),ivet(1,1))
c
c     bessel function i1/i0
c      vec(u)=u*(u+0.4807)/((u+0.8636)*u+1.3943)
c
c
      if(jpart.gt.0) then
                       a1=s3s2
                       a2=s3s2p
                       call ysfl07(nref,idum1,idum2,idum3,idum4)
                       s3s2= a1
                       s3s2p=a2
                       jpart=1
                     endif
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      iphap=360
      nr=0
      do 310 nnn=1,nrec
      if(jpart.ne.1) read(iscra,rec=nnn) 
     *                   ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 300 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 320
C     if (vet(4,i).lt.0.0) goto 300
      if(jpart.eq.1) then
                       call snr07(vet(1,i))
                       lh=ivet(1,i)
                       lk=ivet(2,i)
                       ll=ivet(3,i)
                       fo=vet(4,i)
                       vet(12,i)=isign(1,ivet(8,i))
                       ivet(7,i)=iabs(ivet(8,i))
                       vet(8,i)=vet(4,i)
                       vet(4,i)=vet(5,i)
                       rho1=rhof(p,ivet(1,i),ivet(2,i),ivet(3,i))
                       vet(5,i)=rho1*rho1
                       vet(13,i)=vet(9,i)
                     endif
      lh=ivet(1,i)
      lk=ivet(2,i)
      ll=ivet(3,i)
      fo=vet(4,i)
      rho=vet(5,i)
      sig=vet(12,i)
      rhomax=amax1(rhomax,rho)
c     compute epsilon and multiplicity by generating equivalent
c     reflexions
c     epsylon = number of times same reflexion appears in list
c     multiplicity = number different reflexions in list
      eps=1.0
      mult=1
      i1(1)=lh
      i1(2)=lk
      i1(3)=ll
c     in triclinic space groups eps = 1.0 and mult = 1
      if(nsym.eq.1) go to 60
      k1=65536*i1(1)+256*(i1(2)+128)+i1(3)+128
      ik1=65792-k1
      do 50 j=2,nsym
      do 10 l=1,3
   10 i2(l)=0
      do 40 l=1,3
      do 30 k=1,2
      m=iabs(is(k,l,j))
      if(m.gt.0) i2(m)=i2(m)+i1(l)*isign(1,is(k,l,j))
   30 continue
   40 continue
      k2=65536*i2(1)+256*(i2(2)+128)+i2(3)+128
      if(k2.eq.k1) eps=eps+1.0
      if(icent.ne.0.and.k2.eq.ik1) eps=eps+1.0
      if(k2.eq.k1.or.k2.eq.ik1) mult=mult+1
   50 continue
   60 continue
      if (jpart.le.0) go to 78
c***********************************************************************
c     structure factor and phases for partial structure
      rel=0.0
      rim=0.0
      nf=0
      do 75 nngg=1,ngp
      ns=nf+1
      nf=nf+nag(nngg)
      ient=0
      do 75 j=1,nsym
      t=1000.0
      do 65 l=1,3
      t=t+float(i1(l))*ts(l,j)
      i2(l)=0
   65 continue
      do 70 l=1,3
      do 68 k=1,2
      m=iabs(is(k,l,j))
      if(m.gt.0) i2(m)=i2(m)+i1(l)*isign(1,is(k,l,j))
   68 continue
   70 continue
      call sfac(ns,nf,i2,t,rho,a,b,ient)
      ient=1
      rel=rel+a
      if (icent.eq.0) then
                        rim=rim+b
                      else
                        rel=rel+a
                      endif
   75 continue
      args=rel*rel+rim*rim
      if (args.gt.0.000001) then
                              sig=pts*sqrt(args)*exp(-bt*rho)
                              faze=(180.0/pi)*atan2(rim,rel)+360.0
                            else
                              sig=0.0
                              faze=0.0
                            endif
      sumn=sumn+abs(sig-fo)
      sumd=sumd+fo
      faze=mod(int(faze+0.5),360)
      iphap=faze
c     uno=1.0
c     write(6,'(3i4,3f8.2)')  lh,lk,ll,sig,uno,faze
c     write(6,'(3i4,2f8.2)')  lh,lk,ll,sig,iphap
      if(iphap.eq.0) iphap=360
c***********************************************************************
   78 ff=fo*fo/pts
      fff=ff
      if (jpart.eq.1) fff=sig*sig/pts
      id=nsym/mult
c     ig variable is not used
      ig=1
c     pack symmetry functions for later use
      id=10000*id+100*int(eps+0.5)+ig+1
c     look up scattering factor tables
      sinth=100.0*sqrt(rho)
      ind=max0(2,int(sinth+1.5))
      frac=sinth-float(ind-1)
      bf=0.5*(giw(ind+1)-giw(ind-1))
      af=bf+giw(ind-1)-giw(ind)
      form=af*frac*frac+bf*frac+giw(ind)
      denor=form*eps
c     'wilson' structure factor or e'(p)
      ew=fff/denor
c     'debye' structure factor or e'
      ed=ff/denor
      ivet(6,i)=id
      ivet(7,i)=mod(ivet(7,i),2**15)+iphap*2**15
      vet(9,i)=ed
      vet(10,i)=ew
      vet(11,i)=denor
      vet(12,i)=sign(sig,vet(12,i))
  300 continue
      write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
  310 continue
  320 write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      return
      end
c     ------------------------------------------------------------------
      subroutine gammac(gamma,hkle,lpseud,npseud,m)
c-- compute gamma value
      integer lpseud(3,4),hkle(48,3)
c
      gamma=0.0
      do 100 i=1,m
      do  80 j=1,npseud
      isum=0
      do  50 k=1,3
      isum=isum+hkle(i,k)*lpseud(j,k)
   50 continue
      if(mod(isum,lpseud(j,4)).ne.0) go to 100
   80 continue
      gamma=gamma+1.0
  100 continue
      return
      end
c     ------------------------------------------------------------------
      subroutine equi(hkl,m,hkle)
c-- compute symmetry equivalent reflections
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      integer hkl(3),hkle(48,3)
c
      do 100 k=1,m
      do  50 i=1,3
      hkle(k,i)=0
      do  30 j=1,3
      hkle(k,i)=hkle(k,i)+hkl(j)*ksmat(k,j,i)
   30 continue
   50 continue
  100 continue
      return
      end
c     ------------------------------------------------------------------
c     sort on a
      subroutine sort(a,b,ic,ix,ew,ed,n)
      dimension a(n),ic(n),b(n),ix(n),ew(n),ed(n)
      int=2
   10 int=2*int
      if(int.lt.n) go to 10
      int=min0(n,(3*int)/4-1)
   20 int=int/2
      ifin=n-int
      do 70 ii=1,ifin
      i=ii
      j=i+int
      if(a(i).ge.a(j)) go to 70
      t=a(j)
      x=b(j)
      l=ix(j)
      id=ic(j)
      wb=ew(j)
      db=ed(j)
   40 a(j)=a(i)
      b(j)=b(i)
      ix(j)=ix(i)
      ic(j)=ic(i)
      ew(j)=ew(i)
      ed(j)=ed(i)
      j=i
      i=i-int
      if(i.le.0) go to 60
      if(a(i).lt.t) go to 40
   60 a(j)=t
      b(j)=x
      ix(j)=l
      ic(j)=id
      ew(j)=wb
      ed(j)=db
   70 continue
      if(int.gt.1) go to 20
      return
      end
c---------------------------------------------------------------------
      subroutine fillkq(keq)
      dimension keq(74),kq1(74),kq2(74),kq3(74),kq4(74),kq5(74),kq6(74)
      integer toteq(74,6)
      equivalence (toteq(1,1),kq1(1))
      equivalence (toteq(1,2),kq2(1))
      equivalence (toteq(1,3),kq3(1))
      equivalence (toteq(1,4),kq4(1))
      equivalence (toteq(1,5),kq5(1))
      equivalence (toteq(1,6),kq6(1))
      common /erl/ ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
c-- triclino
      data kq1 /
     1  1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,
     1 19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
     1 37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,
     1 55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74/
c-- monoclino
      data kq2 /
     2  1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,15,16,
     2 12,20,14,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
     2 37,38,39,40,41,28,41,44,34,34,25,48,27,50,51,52,53,54,
     2 55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74/
c--ortorombico
      data kq3 /
     3  1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,15,15,15,
     3 12,13,14,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,
     3 37,38,39,40,28,28,28,33,34,34,25,26,27,50,51,52,53,54,
     3 55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74/
c-- tetragonale
      data kq4 /
     4  1, 2, 2, 4, 5, 6, 7, 7, 9, 9,11,12,13,13,15,15,15,15,
     4 12,13,13,22,23,23,25,26,26,28,29,30,30,32,32,34,35,36,
     4 36,35,39,39,28,28,28,32,34,34,25,26,26,50,51,52,52,50,
     4 51,56,57,58,59,59,61,62,61,62,65,66,66,68,68,70,71,72,73,74/
c-- esagonale & trigonale
      data kq5 /
     5  1, 2, 2, 4, 5, 2, 5, 5, 9, 9,11, 9,13,13,15,13,17,18,
     5 19,15,15,22,23,23,23,26,26,28,29,30,30,32,33,34,35,34,
     5 34,35,29,29,26,33,32,32,30,30,35,28,28,11,51,52,53,11,
     5 51,51,57,11,59,59,61,62,63,62,65, 4, 4,68,68, 4,68,72,73,74/
c-- cubico
      data kq6 /
     6  1, 2, 2, 2, 5, 6, 6, 6, 9, 9, 9, 6, 6, 6,15,15,15,15,
     6  6, 6, 6,22,22,22,25,25,25,28,29,29,29,32,32,32,35,36,
     6 35,36,35,36,28,28,28,32,32,32,25,25,25,50,51,51,50,51,
     6 50,56,57,57,59,60,59,60,60,59,65,65,65, 5, 5, 5,71,72,73,74/
c
      do 10 i=1,74
   10 keq(i)=toteq(i,lsys)
      return
      end
c-----------------------------------------------------------------------
c
c     subroutine for finding the greatest common divisors
c     for the increments of h k and l of the strong reflections
      subroutine gcd(edx,icx,index,scl,ip,ip6,nrln)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      dimension edx(3,256),icx(3),sed(256),ip(8,3,5),ip6(6,5)
      do 600 i=1,3
        sige=0.0
        do 400 j=1,256
          sed(j)=0.0
          sige=sige+edx(i,j)
  400   continue
        do 500 j=2,256
          if(edx(i,j).lt.0.01) goto 500
          do 450 k=1,256
            if(edx(i,k).lt.0.01) goto 450
            if(mod(k,j).eq.0) goto 450
            sed(j)=sed(j)+edx(i,k)
  450     continue
  500   continue
        sed(1) = 10000000.0
        do 550 j=2,256
          if(nrln.eq.0) go to 512
          do 510 n=1,nrln
            if(ip6(n,i).eq.1.and.ip6(n,4).eq.j) edx(i,j)=0.0
  510     continue
  512     if(edx(i,j).lt.0.01) goto 550
          if(sed(j)/sige.lt.scl*0.6) goto 520
          edx(i,j)=0.0
          goto 550
  520     if(sed(j).gt.sed(1)) goto 550
          sed(1) = sed(j)
          icx(i) = j
  550   continue
        do 570 j=2,256
          if(edx(i,j).lt.0.01) goto 570
          if(mod(j,icx(i)).eq.0) icx(i)=j
  570   continue
  600 continue

      index=1
      do 700 i=1,3
      if(icx(i).gt.1) index=index+1
  700 continue
      return
      end
c
c-----------------------------------------------------------------------
c
c     subroutine for finding a least common multiple
c     for the increments of different indices
      subroutine commul(i1,i2,i3,icom)
      dimension in(3)
      in(1)=i1
      in(2)=i2
      in(3)=i3
      icom=1
   50 do 300 j=2,256
      do 100 i=1,3
      if(mod(in(i),j).eq.0) go to 150
  100 continue
  300 continue
      goto 400
  150 do 250 i=1,3
      if(mod(in(i),j).eq.0) in(i)=in(i)/j
  250 continue
      icom=icom*j
      do 350 i=1,3
      if(in(i).ne.1) goto 50
  350 continue
  400 return
      end
c
c-----------------------------------------------------------------------
c     subroutine for checking index relationships
      subroutine rcheck(in,icom,nrln,jump,nb,latt,lsym,ip6,ex,idx)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/rsc/ibgr,mg,mig(8),scl,bts(9),sc(9),ip(8,3,5)
      common /xdata/ inx(3,50000),dummx(10000)
     * ,dummpc(84000)
      dimension in(3),lsym(3,4),ip6(6,5),ex(1000),idx(1000)
      ebot=0.0
      etop=0.0
      jump=0
      if (latt.eq.1) goto 90
c     check for the systematic extinction of centered lattice
      do 80 i=1,3
      do 60 j=1,3
      if (in(j).eq.lsym(i,j)) goto 60
      goto 80
   60 continue
      if (icom.eq.lsym(i,4)) goto 400
   80 continue
   90 do 100 i=1,nb
      ebot=ebot+ex(i)
      iix=idx(i)
      insm=in(1)*inx(1,iix)+in(2)*inx(2,iix)+in(3)*inx(3,iix)
      if(mod(insm,icom).ne.0) etop=etop+ex(i)
  100 continue
      if(etop/ebot.gt.scl*0.6) go to 400
      nrln=nrln+1
      do 300 i=1,3
      ip6(nrln,i)=in(i)
  300 continue
      ip6(nrln,4)=icom
      jump=1
      ip6(nrln,5)=int(1000000.0*etop/ebot)
  400 return
      end
c
c-----------------------------------------------------------------------
c     finding the greatest common divisor for three integers
      subroutine gcd3(in,ic,jump)
      dimension in(3)
      jump=0
      do 200 i=1,9
      j=10-i
      do 100 k=1,3
      if (mod(in(k),j).ne.0) goto 200
  100 continue
      goto 300
  200 continue
  300 if (j.eq.1.or.mod(j,ic).ne.0) jump=1
      return
      end
c-----------------------------------------------------------------------
      subroutine insert(j,esq,tmul,alfa,qn,jqn,iflag)
      dimension qn(12,3,74),jqn(74)
c--
      if (jqn(j).eq.0) go to 20
      jqnj = jqn(j)
      do 10 i=1,jqnj
      l=i
      if (abs(qn(i,1,j)-alfa).lt.0.001) go to 30
   10 continue
   20 jqn(j)=jqn(j)+1
      qn(jqn(j),1,j)=alfa
      l=jqn(j)
   30 qn(l,2,j)=qn(l,2,j)+esq*tmul
      qn(l,3,j)=qn(l,3,j)+tmul
      return
      end
c------------------------------------------------------------
c     structure factor calculation
      subroutine sfac(ns,nf,l,t,rho,a,b,ient)
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
      common /atoms/ x(5,200),nz(200),ngp,ninf(10),nag(10)
      common/trig/sint(450),pi,twopi,dtor,rtod
      dimension l(3),cost(360)
      equivalence (sint(91),cost(1))
      a=0.0
      b=0.0
      if(ient.eq.1) go to 30
      do 10 i=1,nk
      f(i)=cl(i)
      do 5 ii=1,4
      f(i)=f(i)+al(ii,i)*exp(-bs(ii,i)*rho)
    5 continue
c     f(i)=al(i)*exp(-as(i)*rho)+bl(i)*exp(-bs(i)*rho)+cl(i)
   10 continue
   30 hj=float(l(1))
      hk=float(l(2))
      hl=float(l(3))
      do 50 i=ns,nf
      n=nz(i)
      if (n.le.0) go to 50
      arg=amod(hj*x(1,i)+hk*x(2,i)+hl*x(3,i)+t,1.0)
      iarg=int(360.0*arg+0.5)+1
      if(iarg.eq.361) iarg=1
      a=a+f(n)*cost(iarg)*x(5,i)
      b=b+f(n)*sint(iarg)*x(5,i)
   50 continue
      return
      end
c     ------------------------------------------------------------------
      subroutine plotw
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
c--
      character itit(5)*6,icar(4),resval(14)*14,reslab(14)*20
      common /xdata/ store(251),dumm(159749)
     * ,dummpc(84000)
      data icar/'w','d','*',' '/
      data itit/'s**2  ','ln i/s','wilson','debye ','calc  '/
c
      ubt=bt/(8.0*pi*pi)
c--load results labels (reslab) array
      write(reslab( 1),'(20h********************)')
      write(reslab( 2),'(20h*      y   = s**2   )')
      write(reslab( 3),'(20h*      x   = ln <i> )')
      write(reslab( 4),'(20h*    ( w ) = wilson )')
      write(reslab( 5),'(20h*    ( * ) = calc   )')
      write(reslab( 6),'(20h********************)')
      write(reslab( 7),'(20h*        intercept =)')
      write(reslab( 8),'(20h*            slope =)')
      write(reslab( 9),'(20h*           b(iso) =)')
      write(reslab(10),'(20h*           u(iso) =)')
      write(reslab(11),'(20h*            scale =)')
      write(reslab(12),'(20h* scale*f(obs.)**2 =)')
      write(reslab(13),'(20h********************)')
c--load results values (resval) array
      write(resval( 1),4)
      write(resval( 2),7)
      write(resval( 3),8)
      write(resval( 4),7)
      write(resval( 5),7)
      write(resval( 6),4)
      write(resval( 7),5) flgk
      write(resval( 8),5) slope
      write(resval( 9),5) bt
      write(resval(10),5) ubt
      write(resval(11),5) sc
      write(resval(12),6)
      write(resval(13),4)
    4 format(14('*'))
    5 format(f12.5,2h *)
    6 format('  f(abs.)**2 *')
    7 format('             *')
    8 format('/ sigfsq     *')
      nres=13
c--load store array
      j=0
      do 20 i=1,nb
      store(j+1)=avr(i)
      store(j+2)=flgw(i)
      store(j+3)=0.0
   20 j=j+3
      icar(2)=icar(3)
      itit(4)=itit(5)
      do 40 i=1,nb
      store(j+1)=avr(i)
      store(j+2)=slope*avr(i)+flgk
      store(j+3)=0.0
   40 j=j+3
      nstore=j
      n2=nb
      n3=2
      nd=3
      call xplot(store,nstore,lo,n2,n3,nd,icar,itit,resval,reslab,nres)
      return
      end
c-----------------------------------------------------------------------
      subroutine xplot(wrk,nwrk,lo,n2,n3,nd,n4,n5,n6,n7,n8)
c--plot routine
c
c  wrk    work array
c  nwrk   dimension of work array
c  lo     printer logical unit
c  n2     number of points
c  n3     number of sets of points
c  nd     number of words per each point
c  n4     vector containing the characters
c  n5     vector containing the name(s)
c  n6     vector containing variables values
c  n7     vector containing variables names
c  n8     dimension of n6 and n7
c
c--
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
      dimension asc(11),wrk(nwrk)
      dimension r(4),t(4),a(4)
      character n6(n8)*14,n7(n8)*20,blank*14
      character its*14,n5(5)*6,n4(4),ic,ia,ib,ista,istrip(106)
c
      ic  ='x'
      ib  =' '
      ista='*'
      do 10 i=1,14
   10 blank(i:i)=ib
      a(1)=0.00001
c--
      nnr=0
      iniz=51-n8+1
      l1=1
      l1b=l1
      n2b=n2*n3
      fx1=wrk(l1b)
      fx2=wrk(l1b)
      fy1=wrk(l1b+1)
      fy2=wrk(l1b+1)
      do 1000 n=1,n2b
      e=wrk(l1b)
      f=wrk(l1b+1)
      fx1=amin1(fx1,e)
      fx2=amax1(fx2,e)
      fy1=amin1(fy1,f)
      fy2=amax1(fy2,f)
      l1b=l1b+nd
 1000 continue
      dif=fy2-fy1
      sc1=100./dif
      dif=fx2-fx1
      sc2=50./dif
      rsc1=1./sc1
      rsc2=1./sc2
      asc(1)=fy1
      do 1100 i=1,11
      asc(i)=asc(1)+10.*(i-1)*rsc1
 1100 continue
      write(lo,1101)     (asc(i),i=1,11)
 1101 format(/,1h ,11f10.3)
      write(lo,1102)
 1102 format(11(9x,1h*))
      write(lo,1103)
 1103 format(6x,107(1h*))
      write(lo,1104)
 1104 format(6x,1h*,105x,1h*)
      write(lo,1104)
c--controllo titolo
      jj=1
      jjj=1
      jj1=1
      j1=4
c--loop analogo normal
      n2b=n2-2
      j=1
      q=fx1
      do 1600 m=1,51
      do 1502 i=1,14
 1502 its(i:i)=ib
      do 1505 i=1,106
      istrip(i)=ib
1505  continue
      istrip(104)=ista
      if(j.eq.1) go to 1500
      if(j.eq.n2b) go to 1515
      l1b=l1+j*nd
      if(q.lt.wrk(l1b)) go to 1515
1500  continue
      j=j+1
      l1ba=l1+(j-2)*nd
      l1bx=l1ba
      do 1510 k=1,4
      r(k)=wrk(l1bx)
      l1bx=l1bx+nd
1510  continue
1515  continue
      l1bx=l1ba
      do 1570 n=1,n3
      l1bb=l1bx
      do 1530 k=1,4
      t(k)=wrk(l1bb+1)
      l1bb=l1bb+nd
1530  continue
      call xfit (r,t,a)
      al=(a(4)+q*(a(3)+q*(a(2)+q*a(1)))-fy1)*sc1
      if(al.gt.102) al=102
      il=al+1
      if(il.gt.101) il=101
      if(il.lt.  1) il=1
      if(istrip(il).eq.ib) go to 1540
      ia=ic
      go to 1560
1540  continue
      ia=n4(n)
1560  continue
      istrip(il)=ia
      l1bx=l1bx+n2*nd
1570  continue
c--controllo titolo
      if(jj1.gt.2) go to 1430
      jj1=jj1+1
      go to 1440
1430  continue
      if(jj.gt.n3) go to 1400
      jj=jj+1
1440  continue
      jjj=jjj+1
1400  continue
      j1=j1+1
      if(j1.eq.5) istrip(105)=ista
      if (n8.ne.0) then
      if (m.ge.iniz.and.m.le.51) then
                                     jnr=m-iniz+1
                                     its=n6(jnr)
                                     do 1248 j2=87,106
                                     j3=j2-86
 1248                                istrip(j2)=n7(jnr)(j3:j3)
                                   endif
                      endif
      if(j1-5) 1300,1250,1300
 1250 continue
      write(lo,1251) q  ,(istrip(i),i=1,106),its
 1251 format(f6.3,1h*,2x,106a1,a14)
      j1=0
      go to 1350
 1300 continue
      write(lo,1301)(istrip(i),i=1,106),its
c1301 format(8x,1h*,2x,106a1,a14)
 1301 format(6x,1h*,2x,106a1,a14)
 1350 continue
      q  =q  +rsc2
1600  continue
      write(lo,1104)
      write(lo,1104)
      write(lo,1103)
      write(lo,1102)
      return
      end
c-----------------------------------------------------------------------
      subroutine xfit(r,t,a)
c--fit curve to y = a1*rho**3 +a2*rho**2 +a3*rho +a4
c
      dimension r(4),t(4),a(4)
c--
      a1old=a(1)
      b2=r(4)*(r(4)+r(1))
      b1=(t(4)-t(1))/(r(4)-r(1))
      c31=(t(2)-t(1))/(r(2)-r(1))-b1
      c32=(t(3)-t(1))/(r(3)-r(1))-b1
      c11= r(2)     *(r(2)+r(1))-b2
      c12= r(3)     *(r(3)+r(1))-b2
      c21= r(2)-r(4)
      c22= r(3)-r(4)
      denom=c22*c11-c12*c21
      if (abs(denom).lt.0.00000001) then
                                   a(1)=a1old
                                 else
                                   a(1)=(c31*c22-c32*c21)/denom
                                 endif
c     a(1)=(c31*c22-c32*c21)/(c22*c11-c12*c21)
      a(2)=(c31-c11*a(1))/c21
      a(3)=b1-(r(4)*r(4)+r(1)*r(1)+r(4)*r(1))*a(1)
     1  -(r(4)+r(1))*a(2)
      a(4)=t(1)-r(1)*(a(3)+r(1)*(a(2)+r(1)*a(1)))
      return
      end
c-----------------------------------------------------------------------
      subroutine dirnor(jmppse,jump,s3s2o,fileh,ier,iy)
      character line*80,dire*80,diret*80,fileh*80,str2*2
      character blank,digit*12,card(100)*80,ffile*80,ibl2*2
      common /comdir/ icomq(200,2),maxcom,ipcom,ipdir,icomat
      common /chara/ blank,digit,card,ffile
      common /erl/ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      common /frgmt/ mmold,mzold,ihmax(3),knowo,sumn,sumd,n(80)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common /atoms/ x(5,200),nz(200),ngp,ninf(10),nag(10)
      common/gpt/nanew(8),naold(8),sn,sq
      common/at/gis(142),giw(142)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common /cpseud/ npseud,lpseuv(12),llpse
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
      common/shell/zme(2,30),enr,ewmin(30)
      dimension na(8),vet(40),ivet(40),wn(8),nnw(8)
      data ibl2 /'  '/
c
      call xspinb
c
c-- if partial ( 2-nd run ) ...
      if (iflag.eq.0) go to 5
      jump=-1
      mmold=mm
      mzold=mz
      npc=-15
      jpart=1
      lst=0
      ngp=1
      do 4 i=1,8
      na(i)=nw(i)
    4 wn(i)=float(nw(i))
      go to 9065
c set default values
    5 iy=67543
      jmppse=0
      iprin=0
      jj=0
      do 10 i=1,19,2
      jj=jj+1
      nag(jj)=0
      ninf(jj)=0
   10 continue
      jump=-1
      bt=0.0
      mz=166
      th=1.0
      rhomin=0.0
      en=1.2
      er=0.4
      enr=99.0
      ngp=0
      jpart=0
      jtran=0
      npseud=-1
      llpse=0
      npc=1
      jjfile=ln
      do 30 i=1,200
      read(ibl2,'(a2)') nz(i)
      do 30 j=1,5
   30 x(j,i)=0.0
      lix1=0
      lix2=0
      lix3=0
      lix7=0
c++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
c-- already exists a direct access file containing
c-- information concerning the structure
c
      iln=1
      call srlin (iln,lsn,lix1,ljxx,lkxx,llxx)
      if (lix1.le.0) then
                       write(lo,8220)
 8220 format(/,' *** error *** no cell parameters present ')
                       ier=-1
                     else
                       call yfl01
                     endif
      iln=2
      call srlin (iln,lsn,lix2,ljxx,lkxx,llxx)
      if (lix2.le.0) then
                       write(lo,8240)
 8240 format(/,' *** error *** no space group symbol present ')
                       ier=-1
                     else
                       call yfl02
                       if (icent.eq.1) call newmat
                       call musym(ksmat,tmat,nsym,is,ts)
                       pop=pts*(float((icent+1)*nsym))
                     endif
      iln=3
      call srlin (iln,lsn,lix3,ljxx,lkxx,llxx)
      if (lix3.le.0) then
                       write(lo,8250)
 8250 format(/,' *** error *** no cell content present ')
                       ier=-1
                     else
                       call yfl03
                     endif
      iln=7
      call srlin (iln,lsn,lix7,ljxx,lkxx,llxx)
      if (lix7.le.0) then
                       write(lo,8260)
 8260 format(/,' *** error *** no reflections  present ')
                       ier=-1
                     else
                       call ysfl07(nref,nstr,nzro,idummy,iy)
                       s3s2o=s3s2
                       mmold=mm
                       mzold=mz
                    endif
      if (ier.lt.0) return
c
      ic=0
      icmax=icomq(icomat,2)
c
  100 continue
      ic=ic+1
      if (ic.gt.icmax) go to 8200
      ipdir=ipdir+1
      line=card(ipdir)
      diret=line
  105 call cutst(line,lenp,dire,lend)
      call lcase(dire)
c-- directives with alphanumeric parameters
      if (dire(1:4).eq.'part') then
          jpart=-1
          ngp=ngp+1
          ninf(ngp)=1
          call getfrg(line,lenp,dire,diret,ic,icmax,ier)
          if (ier.eq.-1) go to 8000
          if (ier.eq. 1) go to 8200
          go to 105
          endif
c     if (dire(1:4).eq.'tran') then
c         jtran=1
c         ngp=ngp+1
c         ninf(ngp)=2
c         call getfrg(line,lenp,dire,diret,ic,icmax,ier)
c         if (ier.eq.-1) go to 8000
c         if (ier.eq. 1) go to 8200
c         go to 105
c         endif
c     if (dire(1:4).eq.'nops') then
c         jmppse=1
c         go to 100
c         endif
c-- directives with numeric parameters
      iopt=0
      call getnum(line,vet,ivet,iv,iopt)
      if (iopt.eq.-1) go to 8000
      if (dire(1:4).eq.'nref') then
          if (iv.ne.1) go to 8000
          mm=ivet(1)
          go to 100
          endif
      if (dire(1:4).eq.'nzro') then
          if (iv.ne.1) go to 8000
          mz=ivet(1)
          go to 100
          endif
cccccccccccccccccccccccccccccccccccccccccccccccccccc
c     if (dire(1:4).eq.'nuro') then
c         if (iv.ne.1) go to 8000
c         enr=vet(1)
c         go to 100
c         endif
cccccccccccccccccccccccccccccccccccccccccccccccccccc
      if (dire(1:4).eq.'prin') then
          if (iv.ne.1) go to 8000
          iprin=ivet(1)
          go to 100
          endif
      if (dire(1:4).eq.'bfac') then
          if (iv.ne.1) go to 8000
          bt=vet(1)
          jump=0
          go to 100
          endif
      if (dire(1:4).eq.'pseu') then
          npseud=0
          do 290 i=1,12
  290     lpseuv(i)=0
          if (iv.gt.0) then
             if (iv.eq.1) then
                            nn=ivet(1)
                            if (nn.le.1.or.nn.gt.72) nn=-1
                            npseud=nn
                          else
                            do 300 i=1,iv
  300                         lpseuv(i)=ivet(i)
                            do 310 i=4,12,4
                              if (lpseuv(i).ne.0) llpse=llpse+1
  310                       continue
                            if (llpse.ge.1) then
                                              npseud=74
                                            else
                                              npseud=-2
                                            endif
                            if (npseud.lt.0) go to 8000
                          endif
                       endif
                       go to 100
                     endif
      write(lo,6000) diret
 6000 format(' wrong directive on following line:',/a)
      ier=-1
      return
 8000 continue
      ier=-1
      write(lo,'(22h error in directive : ,a80)') diret
      return
 8200 continue
      jfile=jjfile
      if (jpart.ne.0.and.npseud.ne.-1) then
                        npseud=-1
                        write(lo,8210)
                      endif
 8210 format('  *** warning *** PSEUDO & PARTIAL directives are not comp
     *atible. PSEUDO ignored.')
c     if (jpart.eq.-1.and.lix7.gt.0.and.jfile.eq.ln) jpart=1
      if (jpart.eq.-1.and.sc.gt.0.0) jpart=1
      if (jpart.eq.-1.and.jump.eq.0) go to 9500
c ---
      do 9010 i=1,nk
      if (jpart.eq.1.or.jtran.eq.1) wn(i)=float(nw(i))
 9010 na(i)=nw(i)
 9065 do 9070 i=1,142
      gis(i)=0.0
 9070 continue
      if(ngp.eq.0) go to 9200
      pop=pts*(float((icent+1)*nsym))
      if (jtran.gt.0) then
                        do 9075 i=1,nk
 9075                   nnw(i)=nw(i)
                        natot=0
                        do 9080 i=1,ngp
 9080                   natot=natot+nag(i)
                        write(lo,9090) natot,pop
                      endif
 9090 format(//,19x,35hfragment : translated positions for,i5,
     1 29h  atoms having multiplicity =,f5.1,//,
     2 28x,'type',12x,'x',14x,'y',14x,'z',12x,'occ',/)
      nf=0
      do 9190 i=1,ngp
      ns=nf+1
      nf=nf+nag(i)
      if (ninf(i).eq.2.and.jtran.eq.1) write(lo,9100) i,nag(i)
 9100 format(24h group number          =,i3,/,
     1       24h no. of atoms in group =,i3)
      if(ninf(i).eq.1.and.jpart.eq.1) write(lo,9110)bt,nag(i),pop
 9110 format(//,1h ,120('+'),//,
     *       40x,'***  partial structure section  ***',//,
     * 37x,33hPrevious temperature factor (b) =,f9.5,//,
     * 25x,30hFragment : known positions for,i5,
     1 29h  atoms having multiplicity =,f5.1,//,
     2 28x,'Type',12x,'x',14x,'y',14x,'z',12x,'occ',/)
      do 9170 j=ns,nf
      if(jpart.eq.1.and.iflag.eq.1) goto 9150
      do 9120 k=1,nk
      if(nz(j).eq.nalf(k)) goto 9140
 9120 continue
      write(lo,9130) nz(j)
 9130 format(' error :',a2,' type not present in the declared content')
      ier=-1
      return
 9140 nz(j)=k
 9150 k=nz(j)
      intpo=nint(x(5,j)*pop)
      if (jpart.le.0.and.jtran.eq.0) go to 9170
      if (jtran.eq.0) nat = nat - intpo
      nw(k)=nw(k)-intpo
      wn(k)=wn(k)-pop*x(5,j)
      write(str2,'(a2)') nalf(k)
      call ucase(str2(1:1))
      if (jpart.eq.1.or.jtran.eq.1)
     *    write(lo,9160) str2,(x(jj,j),jj=1,3),x(5,j)
 9160 format(1h ,28x,a2,4f15.4)
      if(abs(wn(k)).lt.0.001) wn(k)=0.0
      if(wn(k).lt.0.0) then
                       call yfl03
                       write(lo,9165) nalf(k),nw(k)
 9165 format('  *** error *** the number of atoms in the fragment ',/,
     *       '                exceedes the cell content',/,
     *       '                type of atom ',a2,' max = ',i8,//)
                       ier = -1
                       return
                      endif
 9170 continue
      if (jtran.eq.1) then
                        do 9175 ikk=1,nk
 9175                   nw(ikk)=nnw(ikk)
                      endif
c     calculate spherically averaged molecular scattering factors
c     do 9180 j=1,6
c     f(j)=cr(j,i)
c9180 continue
 9190 continue
c     calculate wilson (giw) and debye (gis) scattering factors
 9200 do 9230 i=1,142
      t=0.01*float(i-1)
      tt=t*t
      giw(i)=0.0
      do 9220 j=1,nk
      fz = cl(j)
      do 9210 jj=1,4
      bst=bs(jj,j)*tt
      if(bst.le.60.)  fz=fz+al(jj,j)*exp(-bst)
 9210 continue
      gis(i)=gis(i)+fz*fz*float(na(j))
      fnw=float(nw(j))
      if (jpart.eq.1) fnw=wn(j)
      giw(i)=giw(i)+fz*fz*fnw
 9220 continue
 9230 continue
      if (jpart.le.0) go to 9260
c     if partial structure procedure compute the modified
c     equivalent number of equal ( and not localized ) atoms in the cell
      iflag=1
      s3=0
      s2=0
      do 9250 i=1,nk
      ss=      wn(i) *no(i)*no(i)
      s2=s2+ss
      s3=s3+ss*no(i)
 9250 continue 
      s3s2=s3/sqrt(s2**3)
 9260 pop=pts*(float((icent+1)*nsym))
      return
 9500 write(lo,9510) 
 9510 format('  *** error *** BFAC & PARTIAL directives are not compatib
     *le.')
      ier=-1
      return
      end
c-----------------------------------------------------------------------
      subroutine newmat
      common /erl/ksmat(48,3,3),tmat(48,3),nt(16),lsys,ngen
     *,irot(48,48),kvet(10),jvet(8),nori,modul(3),nss(3)
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      do 1050 k=1,nsym
      do 1050 i=1,3
      do 1050 j=1,3
 1050 ksmat(k+nsym,i,j)=-ksmat(k,i,j)
      do 1060 k=1,nsym
      do 1060 i=1,3
 1060 tmat(k+nsym,i)=-tmat(k,i)
      return
      end
c-----------------------------------------------------------------------
      subroutine pseudo(xx   ,yy   ,scale,nnpse,ier)
      character line*36,liner*36,ib,hklc(3),plus,equal,and,enne
      common/rc/prc(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/impl/jdir,kform,jfile,jout,nlen,knwr,kenvir,kstory(99),kff
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common /cpseud/ npsedd,lpseuv(12),llpse
      common/rsc/ibgr,mg,mig(8),scl,bts(9),scs(9),ip(8,3,5)
c
      common /xdata/ kpseud(74),epseud(74),esuper(74),ksuper(74),
     *enew(74),patom(74),qatom(74),emed(74),ipseud(74),pnew(74),
     *qnew(74),qn(12,3,74),jqn(74),iskip(74),keq(74),hkle(48,3),
     *dumm(156156)
     * ,dummpc(84000)
      dimension mpseud(12,74),jkl(3),lpseud(3,4),ipp(12),numps(74)
      integer hkle
c
c
c     dimension mpseud(12,74),kpseud(74),epseud(74),jkl(3)
c     dimension esuper(74),ksuper(74),enew(74)
c     dimension patom(74),qatom(74),emed(74),ipseud(74)
c     dimension pnew(74),qnew(74),qn(12,3,74),jqn(74),iskip(74)
c     integer keq(74),hkle(48,3),numps(74),lpseud(3,4),ipp(12)
      dimension ivet(13,39)
      equivalence (vet(1,1),ivet(1,1))
      data numps/64*1,7*2,3,0,0/
c     data kpseud,ksuper/148*0/,qn/2664*0.0/,jqn/74*0/,iskip/74*0/
c     data epseud,esuper/148*0.0/,ipseud/74*0/,enew/74*0.0/
      data ib,hklc,plus,equal,and,enne /' ','h','k','l','+','=','&','n'/
      data mpseud /1,1,1,1,8*1,1,0,0,2,8*1,0,1,0,2,8*1,0,0,1,2,8*1,
     1 1,1,1,2,8*1,1,1,0,2,8*1,1,0,1,2,8*1,0,1,1,2,8*1,1,0,0,3,8*1,
     1 0,1,0,3,8*1,0,0,1,3,8*1,1,1,0,3,8*1,1,0,1,3,8*1,0,1,1,3,8*1,
     1 1,1,1,3,8*1,1,1,2,3,8*1,1,2,1,3,8*1,2,1,1,3,8*1,1,2,0,3,8*1,
     1 1,0,2,3,8*1,0,1,2,3,8*1,0,0,1,4,8*1,0,1,0,4,8*1,1,0,0,4,8*1,
     1 1,1,0,4,8*1,1,0,1,4,8*1,0,1,1,4,8*1,1,1,1,4,8*1,2,2,1,4,8*1,
     1 2,1,2,4,8*1,1,2,2,4,8*1,2,1,1,4,8*1,1,2,1,4,8*1,1,1,2,4,8*1,
     1 1,2,0,4,8*1,1,0,2,4,8*1,0,1,2,4,8*1,2,1,0,4,8*1,2,0,1,4,8*1,
     1 0,2,1,4,8*1,3,3,1,4,8*1,3,1,3,4,8*1,1,3,3,4,8*1,1,2,3,4,8*1,
     1 1,3,2,4,8*1,3,1,2,4,8*1,1,3,0,4,8*1,1,0,3,4,8*1,0,1,3,4,8*1,
     1 0,3,2,6,8*1,0,2,3,6,8*1,2,3,0,6,8*1,3,2,0,6,8*1,3,0,2,6,8*1,
     1 2,0,3,6,8*1,2,2,3,6,8*1,3,2,3,6,8*1,3,3,2,6,8*1,0,4,3,12,8*1,
     1 4,0,3,12,8*1,4,3,0,12,8*1,0,3,4,12,8*1,3,4,0,12,8*1,3,0,4,12,8*1,
     1 1,0,0,2,0,1,0,2,1,1,1,1,1,0,0,2,0,0,1,2,1,1,1,1,
     1 0,1,0,2,0,0,1,2,1,1,1,1,1,0,0,2,0,1,1,2,1,1,1,1,
     1 0,1,0,2,1,0,1,2,1,1,1,1,0,0,1,2,1,1,0,2,1,1,1,1,
     1 1,1,0,2,1,0,1,2,1,1,1,1,1,0,0,2,0,1,0,2,0,0,1,2,24*1/
c
      zero=0.00001
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      kk=73
      nopseu=0
      if (npsedd.eq.-1) nopseu=1
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cccccc       nopseu=0      si deve rinormalizzare
cccccc       nopseu=1  non si deve rinormalizzare
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(lo,10) itle
   10 format(//,1h ,120('+'),//,
     *       38x,'***   pseudotranslation section   ***',//,10x,20a4,/)
      isapi=0
      nsapi=0
      iniz=2
      ifin=72
      if (npsedd.gt.1.and.npsedd.lt.73) then
                                          iniz=73
                                          ifin=73
                                          numps(ifin)=numps(npsedd)
                                          do 70 i=1,12
  70                                      mpseud(i,73)=mpseud(i,npsedd)
                                        endif
      if (npsedd.eq.74) then
      iniz=73
      ifin=73
      numps(ifin)=llpse
      if (numps(ifin).gt.0) then
                              do 90 i=1,12
                                 mpseud(i,ifin)=lpseuv(i)
   90                         continue
                            else
                              write(lo,95)
                              npsedd=-1
                              return
   95 format(//,
     &' *** warning *** user must specify the condition for reflexions.'
     &,/,'                 pseudo directive ignored',//)
                            endif
                endif
      if (iniz.ne.ifin) then
      scs(1)=sc
      bts(1)=bt
      scl=0.5
      j=0
c     write(6,*) 'call autogp'
      call autogp (latt,en,icont,nref,prc)
c     write(6,*) 'fine autogp'
      j=0
      do 22 i=1,3
      if (ip(1,i,4).ne.0) j=j+1
   22 continue
      ii=0
      do 25 i=1,j
      do 25 k=1,4
      ii=ii+1
   25 ipp(ii)=ip(1,i,k)
      if (j.ne.3) then
                    k=j*4+1
                    do 28 i=k,12
   28               ipp(i)=1
                  endif
      nsapi=j
      if (j.ne.0) then
c-- check if class found by autogp is present in mpseud
                    k=73
                    do 33 i=2,72
                    do 31 j=1,12
                    if (ipp(j).ne.mpseud(j,i)) go to 33
   31               continue
                    k=i
   33               continue
                    isapi=1
                    if (k.ne.73) then
                                   iniz=2
                                   kk=2
                                 else
                                   do 40 i=1,12
   40                              mpseud(i,73)=ipp(i)
                                   ifin=ifin+1
                                   numps(ifin)=nsapi
                                 endif
                  else
                    kk=2
                  endif
              endif
c??
c??      if (npsedd.eq.-1) iniz=kk
c??
      do 1 i=1,74
      kpseud(i)=0
      ipseud(i)=0
      ksuper(i)=0
      iskip (i)=0
      jqn   (i)=0
      epseud(i)=0.0
      esuper(i)=0.0
      enew  (i)=0.0
      emed  (i)=0.0
      do 2 j=1,12
      do 2 k=1,3
      qn(j,k,i)=0.0
    2 continue
    1 continue
      nnpse=0
      call fillkq(keq)
      mme=nsym*(icent+1)
      emme=float(mme)
      fnat=s3s2p*s3s2p
      fnat=1.0/fnat
      tot=0.0
      nw =0
      nr=0
c     write(6,*) ' inizio do 250 '
      do 250 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 250 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 260
C     if (vet(4,i).lt.0.0) go to 250
      lh=ivet(1,i)
      lk=ivet(2,i)
      ll=ivet(3,i)
      rho=vet(5,i)
      id=ivet(6,i)
      esq=vet(8,i)
      icont=icont+1
c     unpack symmetry functions
      mult=id/10000
      tmul=float(mult)
      tot=tot+esq*tmul
      nw=nw+mult
      jkl(1)=lh
      jkl(2)=lk
      jkl(3)=ll
      call equi(jkl,mme,hkle)
      iflag=0
      do 240 j=iniz,ifin
      if (j.ne.keq(j)) go to 240
      npseud=numps(j)
      kk=0
      do 210 ii=1,npseud
      jj=(ii-1)*4
      kk=kk+1
      do 210 k=1,4
  210 lpseud(kk,k)=mpseud(jj+k,j)
      jprod=1
      do 215 k=1,npseud
  215 jprod=jprod*lpseud(k,4)
      call gammac(gamma,hkle,lpseud,npseud,mme)
      alfa=float(jprod)*gamma/emme
      jins=j
      call insert(jins,esq,tmul,alfa,qn,jqn,iflag)
      if (gamma.lt.zero) go to 246
      kpseud(j)=kpseud(j)+mult
      epseud(j)=epseud(j)+esq*tmul
      go to 240
  246 continue
      ksuper(j)=ksuper(j)+mult
      esuper(j)=esuper(j)+esq*tmul
  240 continue
  250 continue
  260 www=float(nw)
c     write(6,*) '   fine do 250 '
      tot=tot/www
      iflag=0
c     write(6,*) ' inizio do 400 '
      do 400 i=iniz,ifin
      if (i.ne.keq(i)) go to 400
      denom=float(kpseud(i))
      if (denom.lt.zero) denom=1.0
      epseud(i)=epseud(i)/(denom*tot)
      if (i.eq.1) go to 400
      denom=float(ksuper(i))
      if (denom.gt.zero) go to 355
      iskip(i)=1
      iflag=1
      go to 358
  355 emed(i)=esuper(i)/denom
      qatom(i)=emed(i)*fnat
      patom(i)=fnat-qatom(i)
  358 somma=0.0
      rden=0.0
      jqni=jqn(i)
      do 380 l=1,jqni
      if (qn(l,3,i).lt.zero) go to 380
      rnum=qn(l,2,i)/qn(l,3,i)-qn(l,1,i)
      denom=1.0-qn(l,1,i)
      if (denom.lt.zero) go to 380
      somma=somma+qn(l,3,i)*rnum/denom
      rden=rden+qn(l,3,i)
  380 continue
      if (i.eq.1) rden=1.0
      if (abs(rden).lt.zero) then
                               iskip(i)=2
                             else
                               qnew(i)=fnat*somma/rden
                               pnew(i)=fnat-qnew(i)
                               if (pnew(i).lt.0.0) iskip(i)=2
                             endif
  400 continue
c     write(6,*) '   fine do 400 '
c     write(6,*) ' inizio do 700 '
      do 700 i=iniz,ifin
      enew(i)=0.0
      ipseud(i)=0
      if (i.ne.keq(i)) go to 700
      if (emed(i).ge.1.0) go to 700
      if (emed(i).lt.0.001) go to 700
      if (iskip(i).ne.0) go to 700
      enew(i)=epseud(i)/emed(i)
      ipseud(i)=i
  700 continue
c     write(6,*) '   fine do 700 '
c     write(6,*) ' inizio do 730 '
      do 730 k=iniz,ifin
      l=keq(k)
      if (k.eq.l) go to 725
      kpseud(k)=kpseud(l)
      epseud(k)=epseud(l)
      enew  (k)=enew  (l)
  725 if (ipseud(k).eq.0) enew(k)=0.0
  730 continue
c     write(6,*) '   fine do 730 '
c-- print statistics
c     write(6,*) ' call sort     '
      call sort(enew,epseud,kpseud,ipseud,patom,qatom,74)
c     write(6,*) ' fine sort     '
      if (ipseud(1).ne.0) then
                            ipik=ipseud(1)
                          else
                            write(lo,740)
                            return
                          endif
  740 format(/,29x,46h***  no pseudo-translational symmetry has been,
     & 12h found   ***/)
      iwrite=0
      nkk=ifin-iniz+1
      nkk=min0(10,nkk)
      do 830  k=1,nkk
      ifi=36
      do 800  l=1,36
  800 line(l:l)=ib
      kk=ipseud(k)
      if (kk.eq.0) go to 830
      perc=pnew(kk)/fnat
      kperc=int(100.0*perc)
      if (kperc.le.12) go to 830
      nps=numps(kk)
      do 820 l=nps,1,-1
      j=l*4
      line(ifi:ifi)=enne
      write(line(ifi-2:ifi-1),'(i2)') mpseud(l*4,kk)
      line(ifi-3:ifi-3)=equal
      ifi=ifi-5
      ii=j
      do 810 i=3,1,-1
      ii=ii-1
      mpse=mpseud(ii,kk)
      if (mpse.ne.0) then
                       line(ifi:ifi)=hklc(i)
                       ifi=ifi-1
                  if (mpse.ne.1.and.mpse.ge.0) then
                                   write(line(ifi:ifi),'(i1)') mpse
                                   ifi=ifi-1
                                               endif
                       if (mpse.ne.1.and.mpse.lt.0) then
                                   write(line(ifi-1:ifi),'(i2)') mpse
                                                       ifi=ifi-2
                                                     endif
                       line(ifi:ifi)=plus
                       ifi=ifi-1
                     endif
  810 continue
      line(ifi+1:ifi+1)=ib
      ifi=ifi-1
      line(ifi:ifi)=and
      ifi=ifi-2
  820 continue
      line(ifi+2:ifi+2)=ib
      if (k.eq.1) liner=line
      if (iwrite.eq.0) then
                         write(lo,850)
                         ipik=kk
                         percme=perc
                       endif
      iwrite=iwrite+1
      write(lo,840) line,kpseud(k),epseud(k),enew(k),kperc
c     write(lo,*) line,kpseud(k),epseud(k),enew(k),kperc
  830 continue
  840 format(1h ,a36,3x,i6,5x,f6.3,3x,f5.2,15x,i5,2h %,i5)
  850 format(22x,' class(es) of reflections probably affected by pseudot
     *ranslational effects:',//,28x,
     *'condition   number of   <E**2>  figure ',
     *'        mean fract. scatt. power',/,28x,
     *11x,'reflections         of merit',
     *'   in pseudotranslation (m.f.s.p.)',/)
      if (iwrite.eq.0) then
                         write(lo,740)
                         return
                       endif
      npsedd=ipik
      nnnp=numps(ipik)
      nnn=nnnp*4
      i=ipik
      somma=0.0
      rden=0.0
      jqni=jqn(i)
      do 860 l=1,jqni
      if (qn(l,3,i).lt.zero) go to 860
      rnum=qn(l,2,i)/qn(l,3,i)-qn(l,1,i)
      denom=1.0-qn(l,1,i)
      if (denom.lt.zero) go to 860
      somma=somma+qn(l,3,i)*rnum/denom
      rden=rden+qn(l,3,i)
  860 continue
      q99=fnat*somma/rden
      npseud=numps(npsedd)
      do 870 k=1,12
  870 lpseuv(k)=mpseud(k,ipik)
      call ultima(mpseud,patom,qatom,pnew,qnew,qn,jqn,q99
     *           ,hkle,npseud,lpseud,ipik,fnat,mme,xx,yy,zero)
      amfsp0=(1.0-yy)
      amfspx=(1.0-(xx*rhomax+yy))
      ctest=(amfsp0-amfspx)/percme
      if (ctest.gt.0.25) then
                           mfsp0=int(amfsp0*100.0)
                           mfspx=int(amfspx*100.0)
                           mfspm=int(percme*100.0)
                           write(lo,960) mfsp0,mfspx,mfspm,ctest
                         endif
  960 format(/,
     *30x,'remarkable deviations (of displacive type) from',/,
     *30x,'ideal pseudotranslational symmetry are present:',/,
     *30x,'      at s**2 = 0.0    m.f.s.p. =',i4,' %     ',/,
     *30x,'      at s**2 = max    m.f.s.p. =',i4,' %     ',/,
     *30x,'                      <m.f.s.p.>=',i4,' %     ',/,
     *30x,'                          test  =',f9.3)
      if (nopseu.eq.1) then
                         npsedd=-1
                         write(lo,965)
                         return
                       endif
  965 format(/,20x,45h*** pseudotranslational symmetry will be negl,
     & 29hected in subsequent steps ***/)
      write(lo,970) liner
  970 format(/,1h ,a36,
     1       ' class has been selected as the most probable one;'
     1 ,/,38x,'pseudotranslational symmetry is assumed as prior '
     1 ,/,38x,'information in subsequent steps.')
      call renorm(npsedd,numps,lpseud,kpseud,fnat,mme,keq,mpseud
     *           ,scale,nnpse,ifin,xx,yy,zero)
      return
      end
c-----------------------------------------------------------------------
      subroutine ultima(mpseud,patom,qatom,pnew,qnew,qn,jqn,q99
     *           ,hkle,npseud,lpseud,ipik,fnat,mme,xx,yy,zero)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomi
      dimension sw(30),sd(30),sr(30),nsum(30),nriff(30)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common /cpseud/ npsedd,lpseuv(12),llpse
      dimension jkl(3),patom(74),qatom(74)
      dimension pnew(74),qnew(74),qn(12,3,74),jqn(74),mpseud(12,74)
      integer hkle(48,3),lpseud(3,4)
      dimension ivet(13,39)
      equivalence (vet(1,1),ivet(1,1))
c
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      iniz=1
      ifin=nb
      kk=0
      do 800 ii=1,npseud
      jj=(ii-1)*4
      kk=kk+1
      do 800 k=1,4
  800 lpseud(kk,k)=mpseud(jj+k,ipik)
      jprod=1
      do 830 k=1,npseud
  830 jprod=jprod*lpseud(k,4)
      alf0=float(jprod)/emme
      nw=0
      do 809 i=1,30
      qnew(i)  =0.0
      nsum(i)  =0
  809 sr(i)    =0
      do 810 i=1,74
      jqn(i)   =0
      do 810 j=1,12
      do 810 k=1,3
  810 qn(j,k,i)=0.0
      rr=float(ifin)/rhomax
      nr=0
      do 870 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 870 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 875
C     if (vet(4,i).lt.0.0) go to 870
      jkl(1)=ivet(1,i)
      jkl(2)=ivet(2,i)
      jkl(3)=ivet(3,i)
      rho=vet(5,i)
      id=ivet(6,i)
      esq=vet(8,i)
c     unpack symmetry functions
      mult=id/10000
      tmul=float(mult)
c     n stores range of rho
      n=min0(int(1.0+rr*rho),ifin)
      nsum(n)=nsum(n)+mult
      sr  (n)=sr  (n)+rho*tmul
      call equi(jkl,mme,hkle)
      call gammac(gamma,hkle,lpseud,npseud,mme)
      alfa=alf0*gamma
      iflag=0
      call insert(n,esq,tmul,alfa,qn,jqn,iflag)
  870 continue
  875 continue
      do 900 i=iniz,ifin
      somma=0.0
      rden=0.0
      jqni=jqn(i)
      do 890 l=1,jqni
      if (qn(l,3,i).lt.zero) go to 890
      rnum=qn(l,2,i)/qn(l,3,i)-qn(l,1,i)
      denom=1.0-qn(l,1,i)
      if (abs(denom).lt.zero) go to 890
      somma=somma+qn(l,3,i)*rnum/denom
      rden=rden+qn(l,3,i)
  890 continue
      qnew(i)=somma
      pnew(i)=somma/rden
      nriff(i)=rden
  900 continue
c     set initial values
      pp=0.0
      qq=0.0
      r=0.0
      s=0.0
      t=0.0
      add=rhomax/float(ifin)
      start=0.00
      end=add
      qnew(1)=0.0
      sr  (1)=0.0
      nsum(1)=0
      qnew(2)=0.0
      sr  (2)=0.0
      nsum(2)=0
      do 910 i=1,30
      sw(i)=qnew(i)
      sd(i)=qnew(i)
  910 continue
      esqav=0.0
      do 930 i=2,ifin
c     smooth curve by adding adjacent ranges
      nsum(i)=nsum(i)+nsum(i+1)
      sw(i)=sw(i)+sw(i+1)
      sd(i)=sd(i)+sd(i+1)
      sr(i)=sr(i)+sr(i+1)
c     calculate weighted averages
      wt=float(nsum(i))
      div=1.0/amax1(1.0,wt)
      flgd(i)=sw(i)*div
      avr(i)=sr(i)*div
      flgw(i)=flgd(i)
      start=start+add
      end=amin1(end+add,rhomax)
c     write(lo,280) i,start,end,nsum(i),avr(i),avi,esqav,flgd(i),flgw(i)
c 280 format(1h ,i3,f15.4,3h  -,f8.4,i11,f14.4,f14.1,f23.4,f15.4,f13.4)
c     coefficients of normal equations
      pp=pp+wt*avr(i)*avr(i)
      qq=qq+wt*avr(i)
      r=r+wt*avr(i)*flgd(i)
      s=s+wt*flgd(i)
      t=t+wt
  930 continue
c     least squares
      div=pp*t-qq*qq
      xx=(r*t-qq*s)/div
      yy=(pp*s-qq*r)/div
c
c
c
      if (yy.lt.0.0) yy=0.0
c
c
c
      if (xx.ge.0.0) go to 945
      xx=0.0
      yy=q99/fnat
  945 continue
      return
      end
c-----------------------------------------------------------------------
c
c            search for the pseudo-systematic extinction rule and
c              prepare for automatic grouping of the reflections
c                            beijing   august 1985
c
      subroutine autogp (latt,emin,icont,nref,prc)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/rsc/ibgr,mg,mig(8),scl,bts(9),sc(9),ip(8,3,5)
      common /xdata/ inx(3,50000),dummx(10000)
     * ,dummpc(84000)
      dimension lsym(3,4),edx(3,256),edx1(3,256),mdx(3),icx(3),in(3)
     1,ip6(6,5),ex(1000),idx(1000),ivet(13,39),prc(6)
      equivalence (vet(1,1),ivet(1,1))
c
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      write(lo,5)
    5 format(//29x,
     1'*** program searched for pseudo-translational symmetry ***',/)
      do 40 i=1,3
        in(i)=0
        icx(i)=1
        do 10 j=1,4
          lsym(i,j)=0
   10   continue
        do 30 j=1,256
          edx(i,j)=0.0
          edx1(i,j)=0.0
   30   continue
   40 continue
      do 50 i=1,6
        do 50 j=1,5
          ip6(i,j)=0
   50 continue
c     store the systematic extinction rules of centred lattice
      if(latt.eq.1) go to 200
      lsym(1,4)=2
      k=latt-1
      go to (100,110,120,130,140,130), k
  100 lsym(1,2)=1
      lsym(1,3)=1
      go to 200
  110 lsym(1,1)=1
      lsym(1,3)=1
      go to 200
  120 lsym(1,1)=1
      lsym(1,2)=1
      go to 200
  130 do 132 n=1,3
      lsym(1,n)=1
  132 continue
      if(latt.eq.7) go to 150
      go to 200
  140 do 144 i=1,3
      do 142 n=1,3
      lsym(i,n)=1
  142 continue
      lsym(i,i)=0
  144 continue
      go to 200
  150 lsym(1,1)=-1
      lsym(1,4)=3
c     read reflection file, store separatively the absolute values of
c     indices h, k, l and the cumulated E**2 values
  200 m=mg+1
      nb=0
      icont=0
      nr=0
      do 220 nnn=1,nrec
        read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
        do 220 i=1,nrpb
          nr=nr+1
          if (nr.gt.nref) go to 222
C         if (vet(4,i).lt.0.0) go to 220
          lh=ivet(1,i)
          lk=ivet(2,i)
          ll=ivet(3,i)
          fo=vet(4,i)
          rho=vet(5,i)
          id=ivet(6,i)
          esq=vet(8,i)
          ed=vet(9,i)
c - sapi
c         ed(i)=sc(m)*ed(i)*exp(2.0*bts(m)*rho(i))
c - sapi         k k                 k
          ed=esq
          icont=icont+1
          mult=id/10000
c     exx(icont)=float(mult)*1000.0+esq
          inx(1,icont)=lh
          inx(2,icont)=lk
          inx(3,icont)=ll
          if(sqrt(ed).lt.emin) goto 220
c     pick up reflections with  e  greater then emin
          iih=iabs(lh)
          iik=iabs(lk)
          iil=iabs(ll)
          if(iih.ne.0) edx(1,iih)=edx(1,iih)+ed
          if(iik.ne.0) edx(2,iik)=edx(2,iik)+ed
          if(iil.ne.0) edx(3,iil)=edx(3,iil)+ed
c     store up to 1000 strong reflections for later use
          nb=nb+1
          idx(nb)=icont
          ex(nb)=ed
          if(nb.eq.1000) go to 222
  220 continue
  222 continue
      do 230 i=1,3
        do 228 j=1,256
          edx1(i,j)=edx(i,j)
  228   continue
  230 continue

c     find the one-index-relations for the 'strong' reflection group
      nrln=0
      call gcd(edx,icx,index,scl,ip,ip6,nrln)
      if(index.eq.1) go to 300
      do 270 i=1,3
        if(icx(i).eq.1) go to 270
        nrln=nrln+1
        ip6(nrln,i)=1
        ip6(nrln,4)=icx(i)
        icx(i)=1
  270 continue
c     find the three index-differences for each pair of reflections,
c     store one index-difference when the other two equal zero
  300 do 265 i=1,3
        do 260 j=1,256
          edx(i,j)=0.0
  260   continue
  265 continue
      do 450 i=1,nb
        n=i+1
        do 400 j=n,nb
          do 310 k=1,3
            mdx(k)=iabs(inx(k,idx(i))-inx(k,idx(j)))
  310     continue
          do 320 k=1,3
            if(mdx(k).eq.0) go to 320
            ksw=0
            do 314 kk=1,3
              if(kk.eq.k) go to 314
              if(mdx(kk).ne.0) goto 314
              ksw=ksw+1
              if(ksw.ne.2) goto 314
              mx=mdx(k)
              edx(k,mx)=edx(k,mx)+ex(i)+ex(j)
  314       continue
  320     continue
  400   continue
  450 continue
      call gcd(edx,icx,index,scl,ip,ip6,nrln)
      if(index.gt.2) go to 680
      if(nrln.gt.0) go to 1105
      go to 1200
c     find the relations involving two indices
  680 nrs=nrln
      nrs2=nrln
      do 760 i=1,2
        n=i+1
        do 740 j=n,3
          do 700 j1=1,3
            in(j1)=0
  700     continue
          call commul(icx(i),icx(j),1,icom)
          do 720 k=2,3
            is=(-1)**k
            in(i)=icom/icx(i)
            in(j)=is*icom/icx(j)
            call rcheck(in,icom,nrln,jump,nb,latt,lsym,ip6,ex,idx)
            if(nrln-nrs.eq.2) goto 770
            if(jump.eq.1) go to 740
            if (icom.eq.2) goto 740
  720     continue
  740   continue
  760 continue
  770 nrs2=nrln
      if(index.lt.4) go to 1000
c     relation involving three indices
      call commul(icx(1),icx(2),icx(3),icom)
      in(3)=icom/icx(3)
      do 800 i=2,3
      is=(-1)**i
      in(1)=is*icom/icx(1)
      do 790 k=2,3
      ks=(-1)**k
      in(2)=ks*icom/icx(2)
      call rcheck(in,icom,nrln,jump,nb,latt,lsym,ip6,ex,idx)
      if(jump.eq.1) go to 1000
  790 continue
  800 continue
 1000 if (nrln.eq.nrs) goto 1105
c     check for the independency of the index relations
      nrlnt=nrln
      nrs1=nrs+1
      if (nrln.eq.nrs2.or.nrs2.eq.nrs) goto 1045
c     simultaneous existence of 2- and 3-index relations is not allowed
      do 1020 i=nrs1,nrs2
      if (ip6(i,5).gt.ip6(nrln,5)) goto 1020
c     delete 3-index relation
      do 1010 j=1,5
      ip6(nrln,j)=0
 1010 continue
      nrln=nrln-1
      goto 1045
 1020 continue
c     delete 2-index relations
      do 1040 i=nrs1,nrs2
      do 1030 j=1,5
      ip6(i,j)=0
 1030 continue
      nrln=nrln-1
 1040 continue
 1045 if (nrs.eq.0) goto 1105
c     delete 1-index relation if it is included in another relation or
c     in the combination of other relations
      nr0=nrs
      do 1100 i=1,nrs
      j=nrs1-i
      do 1050 k=1,3
      if (ip6(j,k).eq.1) goto 1052
 1050 continue
 1052 do 1090 l=nrs1,nrlnt
      if (ip6(l,4).eq.0.or.ip6(l,k).eq.0) goto 1090
      ii=1
      do 1054 m=1,4
      if (m.eq.k) goto 1054
      in(ii)=ip6(l,m)
      ii=ii+1
 1054 continue
      ic=ip6(l,k)
      call gcd3(in,ic,jump)
      if (jump.eq.1) goto 1066
      do 1064 ii=1,4
      ip6(j,ii)=0
 1064 continue
      nr0=nr0-1
 1066 if (nr0.lt.2) goto 1090
      do 1070 ii=1,3
      in(ii)=0
      if (nrlnt.gt.nrs2.and.ip6(nrlnt,4).ne.0) in(ii)=1
 1070 continue
      ii=1
      do 1080 m=1,3
      if (m.eq.j) goto 1080
      do 1078 mm=1,nrs
      if (ip6(mm,4).eq.0) goto 1078
      if (mm.eq.j) goto 1078
      if (ip6(mm,m).eq.0.or.ip6(l,m).eq.0) goto 1078
      in(ii)=ip6(mm,4)*ip6(l,mm)
      ii=ii+1
 1078 continue
 1080 continue
      if (ii.eq.1) goto 1090
      in(ii)=ip6(l,4)
      ic=ip6(l,k)
      call gcd3(in,ic,jump)
      if (jump.eq.1) goto 1100
      do 1088 ii=1,4
      ip6(j,ii)=0
 1088 continue
      nr0=nr0-1
 1090 continue
 1100 continue
 1105 nrln=0
      do 1110 i=1,6
      if(ip6(i,4).eq.0) goto 1110
      nrln=nrln+1
      do 1120 j=1,4
      ip(1,nrln,j)=ip6(i,j)
      ip6(i,j)=0
 1120 continue
 1110 continue
      if(nrln.gt.0) go to 1500
 1200 return
c     set up index relations for the weak groups
 1500 mg=1
      do 1510 i=1,nrln
      mg=mg*ip(1,i,4)
 1510 continue
      if(mg.le.8) go to 1520
      mg=2
      go to 1620
 1520 do 1600 i=2,mg
      do 1580 j=1,nrln
      do 1560 k=1,4
      ip(i,j,k)=ip(1,j,k)
 1560 continue
      if(nrln-j.ne.2) go to 1565
      ip(i,j,5)=mod((i-1)/(ip(1,nrln,4)*ip(1,nrln-1,4)),ip(1,j,4))
      go to 1580
 1565 if(nrln-j.eq.1) ip(i,j,5)=mod((i-1)/ip(1,nrln,4),ip(1,j,4))
      if(nrln-j.eq.0) ip(i,j,5)=mod(i-1,ip(1,j,4))
 1580 continue
 1600 continue
 1620 ibgr=1
c     check for null 'weak' groups
      ii=0
      mg1=mg
      do 1700 ni=2,mg
      i=ni-ii
      esig=0
      nr=0
      do 1660 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 1660 n=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 1666
C     if (vet(4,n).lt.0.0) go to 1660
      lh=ivet(1,n)
      lk=ivet(2,n)
      ll=ivet(3,n)
      ed=vet(9,n)
      do 1650 j=1,3
      if(ip(i,j,4).eq.0) go to 1650
      if(mod(ip(i,j,1)*lh+ip(i,j,2)*lk+ip(i,j,3)*ll-ip(i,j,5)
     & ,ip(i,j,4)).ne.0) go to 1660
 1650 continue
      esig=esig+ed
      if(esig.gt.0.000001) go to 1700
 1660 continue
 1666 n=n-1
      if(esig.gt.0.000001) go to 1700
      mg1=mg1-1
      do 1690 k=i,mg1
      do 1680 j=1,3
      do 1670 jj=1,5
      ip(k,j,jj)=ip(k+1,j,jj)
 1670 continue
 1680 continue
 1690 continue
      ii=1+ii
 1700 continue
      mg=mg1
      return
      end
c-----------------------------------------------------------------------
      subroutine renorm(jpseud,numps,lpseud,kpseud,fnat,mme,keq,
     1                  mpseud,scale,nnpse,ifin,penden,tercet,zero)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/rc/prc(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      dimension jkl(3),kpseud(74),numps(74),keq(74)
      dimension epseud(74),lpseud(3,4),mpseud(12,74)
      integer hkle(48,3)
      real ner
      character*132 fmt
      dimension ivet(13,39)
      equivalence (vet(1,1),ivet(1,1))
c
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      npseud=numps(jpseud)
      nnpse=npseud
      jprod=1
      do 10 k=1,npseud
   10 jprod=jprod*lpseud(k,4)
      fprod=float(jprod)
      do 20 i=1,ifin
      kpseud(i)=0
   20 epseud(i)=0.0
      ersum=0.0
      tot=0.0
      nw=0
      ner=0.0
      iniz=1
      nr=0
      icont=0
      alf0=fprod/emme
      do 260 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 250 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 270
C     if (vet(4,i).lt.0.0) go to 250 
      jkl(1)=ivet(1,i)
      jkl(2)=ivet(2,i)
      jkl(3)=ivet(3,i)
      rho=vet(5,i)
      id=ivet(6,i)
      esq=vet(8,i)
      icont=icont+1
      mult=id/10000
      tmul=float(mult)
      call equi(jkl,mme,hkle)
      call gammac(gamma,hkle,lpseud,npseud,mme)
      alfa=alf0*gamma
      qat=penden*rho+tercet
      if (qat.gt.0.99) qat=0.99
      erin=esq/(alfa*(1.0-qat)+qat)
      ersum=ersum+erin*tmul
      ner=ner+tmul
      vet(10,i)=erin
  250 continue
      write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
  260 continue
  270 write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      emd= ersum / ner
      scale=1.0/emd
      nr=0
      do 510 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 500 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 520
C     if (vet(4,i).lt.0.0) go to 500 
      jkl(1)=ivet(1,i)
      jkl(2)=ivet(2,i)
      jkl(3)=ivet(3,i)
      id=ivet(6,i)
      icont=icont+1
      mult=id/10000
      tmul=float(mult)
      vet(10,i)=vet(10,i)*scale
      tot=tot+vet(10,i)*tmul
      nw=nw+mult
      call equi(jkl,mme,hkle)
      do 410 j=iniz,ifin
      if (j.ne.keq(j)) go to 410
      npseud=numps(j)
      kk=0
      do 420 ii=1,npseud
      jj=(ii-1)*4
      kk=kk+1
      do 420 k=1,4
  420 lpseud(kk,k)=mpseud(jj+k,j)
      jprod=1
      do 430 k=1,npseud
  430 jprod=jprod*lpseud(k,4)
      call gammac(gamma,hkle,lpseud,npseud,mme)
      if (gamma.lt.zero) go to 450
      kpseud(j)=kpseud(j)+mult
      epseud(j)=epseud(j)+vet(10,i)*tmul
  450 continue
  410 continue
  500 continue
      write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
  510 continue
  520 write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      www=float(nw)
      tot=tot/www
      do 560 i=iniz,ifin
      if (i.ne.keq(i)) go to 560
      denom=float(kpseud(i))
      if (denom.lt.zero) denom=1.0
      epseud(i)=epseud(i)/(denom*tot)
  560 continue
      do 580 k=1,ifin
      l=keq(k)
      if (k.eq.l) go to 580
      kpseud(k)=kpseud(l)
      epseud(k)=epseud(l)
  580 continue
c-- print statistics
      write(lo,790)
  790 format(///,30x,
     1'pseudo-translation statistic after renormalization'
     2,//,1h ,5x,4('           number <E**2>       '))
      write(lo,590) (k,(mpseud(l,k),l=1,4),kpseud(k),epseud(k),k=1,64)
  590 format(4(i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3,2x))
      write(lo,601)
  600 format(1h ,'                   ')
  601 format(/,1h ,43x,40h           number <E**2>                )
      do 630 k=65,72
      nps=numps(k)
      jj=nps*4
      if (nps.eq.2)
     *write(lo,610) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
      if (nps.eq.3)
     *write(lo,620) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
  610 format(19x,i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,'   &  ',
     *                1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3)
  620 format(/,1h ,51x,40h           number <E**2>                ,
     *       /,8x,i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,'   &  ',
     *                  1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,'   &  ',
     *                1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3)
C 630 continue
C     if (ifin.le.72) go to 670
C     write(lo,600)
C     k=ifin
C     nps=numps(k)
C     jj=nps*4
C     if (nps.eq.1)
C    *write(lo,640) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
C     if (nps.eq.2)
C    *write(lo,650) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
C     if (nps.eq.3)
C    *write(lo,660) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
C 640 format(i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3,11x)
C 650 format(19x,i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,'   &  ',
C    *                1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3)
C 660 format( 8x,i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,'   &  ',
C    *                  1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,'   &  ',
C    *                1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3)
  630 continue
      if (ifin.le.72) go to 670
      write(lo,600)
      k=ifin
      nps=numps(k)
      jj=nps*4
      if (nps.eq.1) then
      fmt='(i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,i6,f6.3,11x)'
      if (mpseud(1,k).lt.0.or.mpseud(1,k).gt.9) fmt(13:13)='2'
      if (mpseud(2,k).lt.0.or.mpseud(2,k).gt.9) fmt(21:21)='2'
      if (mpseud(3,k).lt.0.or.mpseud(3,k).gt.9) fmt(29:29)='2'
      write(lo,fmt) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
      endif
c    *write(lo,640) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
      if (nps.eq.2) then
      fmt='(19x,i3,1h),1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,6hn  &  ,
     *                1x,i1,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3)'
      if (mpseud(1,k).lt.0.or.mpseud(1,k).gt.9) fmt(17:17)='2'
      if (mpseud(2,k).lt.0.or.mpseud(2,k).gt.9) fmt(25:25)='2'
      if (mpseud(3,k).lt.0.or.mpseud(3,k).gt.9) fmt(33:33)='2'
      if (mpseud(5,k).lt.0.or.mpseud(5,k).gt.9) fmt(56:56)='2'
      if (mpseud(6,k).lt.0.or.mpseud(6,k).gt.9) fmt(64:64)='2'
      if (mpseud(7,k).lt.0.or.mpseud(7,k).gt.9) fmt(72:72)='2'
      write(lo,fmt) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
c    *write(lo,650) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
         else
      continue
      endif
      if (nps.eq.3) then
      fmt='(8x,i3,1h),i2,2hh+,i1,2hk+,i1,2hl=,i2,6hn  &  ,'
     *  //'i2,2hh+,i1,2hk+,i1,2hl=,i2,6hn  &  ,'
     *  //'i2,2hh+,i1,2hk+,i1,2hl=,i2,1hn,i6,f6.3)'
      if (mpseud(1,k).lt.0.or.mpseud(1,k).gt.9) fmt(17:17)='2'
      if (mpseud(2,k).lt.0.or.mpseud(2,k).gt.9) fmt(25:25)='2'
      if (mpseud(3,k).lt.0.or.mpseud(3,k).gt.9) fmt(33:33)='2'
      if (mpseud(3,k).lt.0.or.mpseud(3,k).gt.9) fmt(33:33)='2'
      if (mpseud(5,k).lt.0.or.mpseud(5,k).gt.9) fmt(56:56)='2'
      if (mpseud(6,k).lt.0.or.mpseud(6,k).gt.9) fmt(64:64)='2'
      if (mpseud(7,k).lt.0.or.mpseud(7,k).gt.9) fmt(72:72)='2'
      if (mpseud(9,k).lt.0.or.mpseud(9,k).gt.9) fmt(95:95)='2'
      if (mpseud(10,k).lt.0.or.mpseud(10,k).gt.9) fmt(103:103)='2'
      if (mpseud(11,k).lt.0.or.mpseud(11,k).gt.9) fmt(111:111)='2'
      write(lo,fmt) k,(mpseud(l,k),l=1,jj),kpseud(k),epseud(k)
      else
      continue
      endif
  670 continue
      scale=sqrt(scale)
      return
      end
C------------------------------------------------------------------
      subroutine out90p(nref)
      common /frgmt/ mmold,mzold,ihmax(3),knowo,sumn,sumd,ntype(80)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      dimension ih(3),ik(3),il(3),ep(3),es(3),eo(3),sig(3)
      dimension vat(9),ivat(9)
      equivalence (vat(1),ivat(1))
      integer pp(3),pv(3),ic(3)
      character*6 sigc(3)
c
      call ysfl07(idum0,idum1,idum2,idum3,idum4)
c
      write(lo,50) mmold
   50 format(///,i6,' reflections with largest E values , associated ',
     1 40hpseudo-normalized E's and partial phases,/)
      if(knw.eq.0) then 
                     write(lo,60)
                   else
                     write(lo,70)
                   endif
   60  format(1h ,3('code  h  k  l   E''  E''p phip   E  fo/sig. ')/)
   70  format(1h ,2('code    h  k  l   E''    E''p   phip    E   phi  fo
     */sig.     ')/)
c
c-- reflections are in the direct access file
c
      kk=0
      sigc(1)='      '
      sigc(2)='      '
      sigc(3)='      '
      do 300 i=1,mmold
      call snr07(vat)
      kk=kk+1
      ih(kk)= ivat(1)
      ik(kk)= ivat(2)
      il(kk)= ivat(3)
      ic(kk)=i
      ep(kk)= vat(6)
      es(kk)= vat(7)
      pp(kk)=ivat(8)/2**15
      eo(kk)= vat(4)
      sig(kk)= vat(9)
      fo=vat(5)
      if (ksigma.gt.0) then
      if (sig(kk).gt.0.0) sig(kk) = fo / sig(kk)
      if (sig(kk).lt.0.0) then
                            sigc(kk) = ' gen. '
      else if (sig(kk).gt.6.0) then
                            sigc(kk) = '    >6'
                          else
                            write(sigc(kk),'(f6.2)') sig(kk)
                          endif
                       else
                          sigc(kk) = '      '
                          sig(kk) = 0.0
                       endif
      if(knw.eq.0) then 
                     if (kk.lt.3) go to 300
                     write(lo,200) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),sigc(j),j=1,kk)
                   else
                     pv(kk)=(ivat(8)-pp(kk)*2**15)/32
                     if (kk.lt.2) go to 300
                     write(lo,210) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),pv(j),sigc(j),j=1,kk)
                   endif
  200 format(1h ,3(i4,3i3,2f5.2,i4,f6.2,a6,3x))
  210 format(1h ,2(i4,2x,3i3,2f6.2,i7,f6.2,i5,a6,6x))
      kk=0
  300 continue
      if (kk.eq.0) go to 400
      if (knw.eq.0) then
                     write(lo,200) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),sigc(j),j=1,kk)
                  else
                     write(lo,210) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),pv(j),sigc(j),j=1,kk)
                    endif
c
  400 continue
c     write weak reflection
c
      write(lo,500) mzold
  500 format(//,i5,' reflections with weakest E values , associated ',
     1 40hpseudo-normalized E's and partial phases,//)
      if(knw.eq.0) then 
                     write(lo,60)
                   else
                     write(lo,70)
                   endif
c
      ii=mmold
      nrf=nref-mmold-mzold
      do 700 i=1,nrf
      ii=ii+1
      call snr07(vat)
  700 continue
      kk=0
      sigc(1)='      '
      sigc(2)='      '
      sigc(3)='      '
      do 800 i=1,mzold
      call snr07(vat)
      kk=kk+1
      ii=ii+1
      ih(kk)= ivat(1)
      ik(kk)= ivat(2)
      il(kk)= ivat(3)
      ic(kk)=ii
      ep(kk)= vat(6)
      es(kk)= vat(7)
      pp(kk)=ivat(8)/2**15
      eo(kk)= vat(4)
      sig(kk)= vat(9)
      fo=vat(5)
      if (ksigma.gt.0) then
      if (sig(kk).gt.0.0) sig(kk) = fo / sig(kk)
      if (sig(kk).lt.0.0) then
                            sigc(kk) = ' gen. '
      else if (sig(kk).gt.6.0) then
                            sigc(kk) = '    >6'
                          else
                            write(sigc(kk),'(f6.2)') sig(kk)
                          endif
                       else
                          sigc(kk) = '      '
                          sig(kk) = 0.0
                       endif
      if(knw.eq.0) then 
                     if (kk.lt.3) go to 800
                     write(lo,200) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),sigc(j),j=1,kk)
                   else
                     pv(kk)=(ivat(8)-pp(kk)*2**15)/32
                     if (kk.lt.2) go to 800
                     write(lo,210) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),pv(j),sigc(j),j=1,kk)
                   endif
      kk=0
  800 continue
      if (kk.eq.0) return   
      if (knw.eq.0) then
                     write(lo,200) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),sigc(j),j=1,kk)
                  else
                     write(lo,210) (ic(j),ih(j),ik(j),il(j),ep(j),es(j),
     1                              pp(j),eo(j),pv(j),sigc(j),j=1,kk)
                    endif
      return
      end
c     ------------------------------------------------------------------
c     least squares plot, including summation over nb ranges of rho
      subroutine sir_sum(pts,ier)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common/shell/zme(2,30),enr,ewmin(30)
c
      dimension sw(30),sd(30),sr(30),nsum(30),si(30),ivet(13,39)
      dimension nsumu(30),sru(30),sdu(30),nsumt(30)
      dimension vet2(13,39),ivet2(13,39)
      equivalence (vet(1,1),ivet(1,1))
      equivalence (vet2(1,1),ivet2(1,1))
c
c     if (iprin.gt.0) write(lo,40)
c  40 format(///,20x,18hleast squares plot//6h range,6x,
c    1 18hrho=(sinth/lam)**2,6x,6hnumber,6x,8hmean rho,7x,6hmean i,
c    2 7x,23hmean exp(-2*b*rho)*E**2,3x,5hdebye,7x,6hwilson)
c     set initial values
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      ifun=0
      if0=0
      pp=0.0
      q=0.0
      r=0.0
      s=0.0
      t=0.0
      number=0
      add=rhomax/float(nb)
      start=-add
      end=add
      rr=float(nb)/rhomax
      do 50 i=1,30
      sw(i)=0.0
      sd(i)=0.0
      sr(i)=0.0
      si(i)=0.0
      sru(i)=0.0
      sdu(i)=0.0
      nsum(i)=0
      nsumu(i)=0
      ewmin(i)=99.9
   50 continue
      nr=0
      do 200 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 150 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 210
C     if (vet(4,i).lt.0.0) goto 150
      if (vet(13,i).lt.0.0) then
                             ifun=1
                             rho=vet(5,i)
                             id=ivet(6,i)
                             ed=vet(9,i)
c     n stores range of rho
                             n=min0(int(1.0+rr*rho),nb)
                             mult=id/10000
                             tmul=float(mult)
                             nsumu(n)=nsumu(n)+mult
                             sru(n)=sru(n)+rho*tmul
                             ivet(8,i)=n 
c-------
                         else
      fo=vet(4,i)
      rho=vet(5,i)
      id=ivet(6,i)
      ed=vet(9,i)
      ew=vet(10,i)
      sig=vet(12,i)
      denor=vet(11,i)
c     n stores range of rho
      n=min0(int(1.0+rr*rho),nb)
      mult=id/10000
      ie=(id-10000*mult)/100
      eps=float(ie)
      tmul=float(mult)
c     weighted sums
c     number of reflexions
      nsum(n)=nsum(n)+mult
c     wilson
      sw(n)=sw(n)+ew*tmul
      if (ew.lt.ewmin(n)) ewmin(n)=ew
c     debye
      edi=ed
      if (jpart.eq.1) edi=(fo*fo-sig*sig)/(denor*pts)
      if(edi.lt.0.) edi=0.
      sd(n)=sd(n)+edi*tmul
c     rho
      sr(n)=sr(n)+rho*tmul
c     intensity
      fo2=fo*fo
      if (jpart.eq.1) fo2=fo*fo-sig*sig
      if(fo2.lt.0.) fo2=0.
      si(n)=si(n)+tmul*fo2/(eps*pts)
                           endif
  150 continue
      write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
  200 continue
  210 write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      if (ifun.gt.0) then
                        call sumun(nsum,nsumu,sw,nsumt)
                        do 220 i=1,nb
                        sr(i)=sr(i)+sru(i)
                        sd(i)=sw(i)
                        nsum(i)=nsumt(i)
  220                   continue
                      endif
      do 300 i=1,nb
c-new 19/04/93
      if(nsum(i).eq.0.or.sw(i).lt.0.000001.or.
     *                       sd(i).lt.0.000001) then
                                             write(lo,301)
                                             ier=-1
                                             return
                                                endif
  301 format(//,' ***  Wilson-plot procedure in error  ***',/,
     *          ' ***         Check reflections        ***')
c     smooth curve by adding adjacent ranges
      number=number+nsum(i)
      nsum(i)=nsum(i)+nsum(i+1)
      sw(i)=sw(i)+sw(i+1)
      sd(i)=sd(i)+sd(i+1)
      sr(i)=sr(i)+sr(i+1)
      si(i)=si(i)+si(i+1)
c     calculate weighted averages and logs
      wt=float(nsum(i))
      div=1.0/amax1(1.0,wt)
      esqav=sd(i)*div
      flgd(i)=alog(esqav)
      avi=si(i)*div
      avr(i)=sr(i)*div
      flgw(i)=alog(sw(i)*div)
      start=start+add
      end=amin1(end+add,rhomax)
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     asimps(i)=sqrt(avr(i))
c     avish(i)=avi
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if (nsum(i).eq.0) go to 260
      go to 270
  260 flgd(i)=-20
      flgw(i)=-20
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
  270 if (iprin.gt.0) then
                        if (if0.eq.0) then
                                       if0=1
                                       write(lo,40)
                                      endif
   40 format(///,20x,18hleast squares plot//6h range,6x,
     1 18hrho=(sinth/lam)**2,6x,6hnumber,6x,8hmean rho,7x,6hmean i,
     2 7x,23hmean exp(-2*b*rho)*E**2,3x,5hdebye,7x,6hwilson)
                        write(lo,280) i,start,end,nsum(i),avr(i),avi,
     *                  esqav,flgd(i),flgw(i)
                      endif
  280 format(1h ,i3,f15.4,3h  -,f8.4,i11,f14.4,f14.1,f23.4,f15.4,f13.4)
c     coefficients of normal equations
      pp=pp+wt*avr(i)*avr(i)
      q=q+wt*avr(i)
      r=r+wt*avr(i)*flgd(i)
      s=s+wt*flgd(i)
      t=t+wt
  300 continue
      if (iprin.gt.0) write(lo,320) pp,q,r,q,t,s
  320 format(17h0normal equations/(1h ,e11.3,10h * slope +,e11.3,
     1 14h * intercept =,e11.3))
c     least squares
      div=pp*t-q*q
      slope=(r*t-q*s)/div
      flgk=(pp*s-q*r)/div
      sc=exp(-flgk)
      bt=-0.5*slope
      if (iprin.gt.0) write(lo,340) slope,flgk,bt,sc
  340 format(/,7hslope =,f8.4,4x,11hintercept =,f8.4,4x,
     1 24htemperature factor (b) =,f8.4,4x,7hscale =,f8.4/
     2 51x,37hf(absolute)**2 = scale*f(observed)**2)
      if (jpart.le.0) return
      do 350 i=1,30
  350 flgw(i)=flgd(i)
      return
      end
c--------------------------------------------------------------------
c subroutine che gestisce i non-osservati di ogni shell
      subroutine sumun(nsum,nsumu,sw,nsumt)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/rc/px(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/sym/is(2,3,24),ts(3,24),nsym,pts,ksys,icent,latt,s3s2,emme
     *          ,s3s2p
      common/shell/zme(2,30),enr,ewmin(30)
      dimension sw(30),nsum(30),nsumu(30),nsumt(30),zmu(4),line(6)
      character line*318,l0*59
c
      l0='                                                          '
      line(1)='no    = number of observed reflections               '
      line(2)='nu    = number of unobserved reflections             '
      line(3)='nt    = no+nu                                        '
      line(4)='zmax  = maximum value of z for unobserved reflections'
      line(5)='zmed  = average value of z for unobserved reflections'
      line(6)='sigma = standard deviation                           '
c
      zlim=1.05
      do 5 i=1,nb
      zme(1,i)=0.0
      zme(2,i)=0.0
   5  continue
      write(lo,7)
    7 format(/,' shell   no   nu   nu/nt    zmax    zmed   sigma ',
     *12h            ,'legenda:',/)
cccccc
cccccc
c     jj=0
      do 10 i=1,nb
      nsumt(i)=nsum(i)+nsumu(i)
      pun=float(nsumu(i))/float(nsumt(i))
      zumax=(float(nsumt(i)))/(float(nsum(i)))
      if (zumax.le.zlim) then
                           zumax=0.0
                           zmm=0.0
                           ss=0.0
c                          if (i.le.11.and.mod(i,2).gt.0) then
                           if (i.le.6) then
c                                     jj=jj+1            
                                      write(lo,11)i,nsum(i),
     *                                nsumu(i),pun,zumax,zmm,ss,line(i)
                                                           else
                                         write(lo,12)i,nsum(i),
     *                                   nsumu(i),pun,zumax,zmm,ss
                                                           endif
                           go to 10
                          endif
      if (icent.eq.0) then
                         zumax=alog(zumax)
                       else
                         p=(float(nsumu(i)))/(float(nsumt(i)))
                         call merfi(p,y,ier)
                         zumax=(y**2)*2.0
                       endif
      x=zumax
      if (icent.eq.0) then
                         p=0.0
                         ks2=2.0
                      else
                         p=-0.5
                         ks2=3.0
                      endif
      do 20 j=1,3
      p=p+1.0
      call mdgam(x,p,prob,ier)
      zmu(j)=prob
   20 continue
      zmm=zmu(2)/zmu(1)
      zmo=(1.0-zmu(2))/(1.0-zmu(1))
      szz=(nsumu(i)*zmm)/(nsum(i)*zmo)
      sw(i)=sw(i)*(1+szz)
      zme2=zmm**2.0
      s2=ks2*zmu(3)/zmu(1)-zme2
      ss=sqrt(s2)
      zme(1,i)=zmm
      zme(2,i)=ss
c     if (i.le.11.and.mod(i,2).gt.0) then
c                         jj=jj+1            
      if (i.le.6) then
                     write(lo,11)i,nsum(i),
     *               nsumu(i),pun,zumax,zmm,ss,line(i)
                   else
                     write(lo,12)i,nsum(i),
     *               nsumu(i),pun,zumax,zmm,ss
                    endif
   11 format(1h ,3i5,4f8.3,12h            ,a53)
   12 format(1h ,3i5,4f8.3)
   10 continue
      return
      end
c     ------------------------------------------------------------------
c     reflection rescaling
      subroutine resca
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common/shell/zme(2,30),enr,ewmin(30)
      dimension ivet(13,39)
      equivalence (vet(1,1),ivet(1,1))
c
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      tot=0.0
      nw=0
      nr=0
      do 260 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 250 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 270
C     if (vet(4,i).lt.0.0) then
C                            vet(8,i)=-99.9
C                            goto 250
C                          endif
      if (vet(13,i).lt.0.0) then
                            n=ivet(8,i)
                            if (zme(1,n).eq.0.0) zme(1,n)=ewmin(n)/2.0
                            vet(8,i)=zme(1,n)
                            esq=vet(8,i)
                           else
                            rho=vet(5,i)
                            ed=vet(9,i)
                            esq=sc*ed*exp(bt*rho)
                            vet(8,i)=esq
                           endif
c     unpack symmetry functions
      id=ivet(6,i)
      mult=id/10000
      tmul=float(mult)
      tot=tot+esq*tmul
      nw=nw+mult
  250 continue
      write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
  260 continue
  270 write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      tot=tot/float(nw)
      scala=1.0/tot
CNEW
      if (jpart.ne.-1) sc =  scala
CNEW
      nr=0
      do 290 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 280 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 300
C     if (vet(4,i).lt.0.0) goto 280
      vet(8,i)=vet(8,i)*scala
  280 continue
      write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
  290 continue
  300 write(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      return
      end
c---------------------------------------------------------------
c     calculate final e-values and rescaled f's
c     output reflexions for sir
c     prepare tables of statistics
c
      subroutine ecal(npsedd,iy,bto,sco)
      character line(25,3),blank,star,cbuff*81
      dimension ctest(3)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common /buffer/ vet(13,39),nrpb,nitem,dummb(6)
      common/rc/p(6),cx(9),nref,nb,rhomax,mm,en,mz,er,th,rhomin
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      common/sf/al(4,8),bs(4,8),cl(8),nw(8),no(8),nk,nat,f(9),nalf(8)
      common/xdata/ dumx(160000)
     * ,dummpc(84000)
      common/gpt/nanew(8),naold(8),sn,sq
      common/shell/zme(2,30),enr,ewmin(30)
c     pseudotranslation informations
      common /cpseud/ npseud,lpseuv(12),llpse
      dimension rhr(10),nhr(10),nu(25),stl(10)
      dimension ava(10),avc(10),avh(10),cph(25)
      dimension vst(10),zt(25),ee(10),ivet(13,39)
      dimension vet2(6,84),ivet2(6,84)
can
      dimension sigv(10,2),isigv(10),isigp(10),vat(9)
can
      equivalence (vet(1,1),ivet(1,1))
      equivalence (vet2(1,1),ivet2(1,1))
      equivalence (vet2(1,1),dumx(1))
c
      data blank,star /' ','*'/
c     tables of theoretical distributions
      data ava/0.886,1.0,1.329,2.0,3.323,6.0,0.736,1.0,2.0,2.415/
      data avc/0.798,1.0,1.596,3.0,6.383,15.0,0.968,2.0,8.0,8.691/
      data avh/0.718,1.0,1.916,4.5,12.26,37.5,1.145,3.5,26.0,26.903/
      data cph/0.368,0.463,0.526,0.574,0.612,0.643,0.670,0.694,0.715,
     1 0.733,0.765,0.791,0.813,0.832,0.848,0.863,0.875,0.886,0.896,
     2 0.905,0.913,0.920,0.926,0.932,0.938/
c
      nrec=nref/nrpb
      if (mod(nref,nrpb).gt.0) nrec=nrec+1
      bt2=2.*bt
c     set initial values
      do 20 i=1,10
      rhr(i)=0.0
      nhr(i)=0
      vst(i)=0.0
   20 continue
      nst=0
      do 30 i=1,25
      zt(i)=0.0
      nu(i)=0
   30 continue
      nrw=0
      lim=1000
      nc=0
      ns=0
      nl=0
      scf=sqrt(sc)
      rr=10.0/sqrt(rhomax)
      rr1=float(nb)/rhomax
      enr=enr**2.0
      nr=0
      ind2=0
      nr2=0
      nrpb2=nrpb*2
      do 35 j1=1,nrpb2
   35 vet2(2,j1)=-99999.9
      iblk2=6
      lind2=1
      do 250 nnn=1,nrec
      read(iscra,rec=nnn) ((vet(j1,j2),j1=1,nitem),j2=1,nrpb)
      do 250 i=1,nrpb
      nr=nr+1
      if (nr.gt.nref) go to 270
C     if (vet(4,i).lt.0.0) goto 250
      lh=ivet(1,i)
      lk=ivet(2,i)
      ll=ivet(3,i)
      icobs=1
c     icobs  =  0 if reflexion is unobserved
c            =  1 if reflexion is observed
c     inp=65536*lh+256*(lk+128)+ll+128
      inp=(icobs*128*128+(lh+64)*128+(lk+64))*128+ll+64
      id=ivet(6,i)
      fo=vet(4,i)
      rho=vet(5,i)
      sig=vet(12,i)
      ipha=mod(ivet(7,i),2**15)
      e=vet(8,i)
      ed=vet(9,i)
      ew=vet(10,i)
      denor=vet(11,i)
      sigm=vet(13,i)
      d=sc*exp(bt2*rho)
      mult=id/10000
      ie=(id-10000*mult)/100
      eps=float(ie)
      if (jpart.le.0) go to 72
c     calculate pseudo-normalized e
      esq=d*ed
      ed=sqrt(esq)
      esq=d*ew
      ew=sqrt(esq)
      go to 100
c     calculate e
   72 if (npseud.ge.1) go to 73
      esq=e
      e=sqrt(esq)
      ed=e
      ew=e
      go to 76
   73 continue
      esq=ew
      e=sqrt(esq)
      ed=e
      ew=vet(8,i)
      ew=sqrt(ew)
   76 continue
c     calculate rescaled f
      fo=fo*scf
*     if(rho.gt.th) go to 110
*     if(rho.lt.rhomin) go to 110
c     store reflexions for sir
      if(sigm.lt.0.0) then
                         n=min0(int(1.0+rr1*rho),nb)
Corig                    enn=zme(1,n)+zme(2,n)
Corig                    if(enn.ge.enr) then
Corig                                      go to 110
Corig                                   else
c
c
c
Corig                                      vet(13,i)=zme(2,n)
                                           vet(13,i)=-zme(2,n)
                                           fo=0.0
c
c
c
                                           go to 90
Corig                                    endif
                      else
                        vet(13,i)=sigm*scf
                      endif
      if(sig.lt.0.0) go to 90
      nl=nl+1
      if(e.gt.en) go to 100
      nl=nl-1
   90 continue
      if(e.gt.er) go to 100
      ns=ns+1
  100 nc=nc+1
c
c-- definizione di vet2-ivet2       vet2(6,84)
c       inp   e   fo   fasi  ew  ed
c        1    2    3    4     5   6
      ind2=ind2+1
cccc  dum=ew*1000.0
      dum=ed*1000.0
      if (dum.gt.32767.0) dum=32767.0
      idum=int(dum)
cccc  dum=ed*1000.0
      dum=ew*1000.0
      if (dum.gt.32767.0) dum=32767.0
      idum1=int(dum)
      ivet2(1,ind2)=inp
       vet2(2,ind2)=e
       vet2(3,ind2)=fo
       vet2(4,ind2)=idum1+idum*32768
      ivet2(5,ind2)=ivet(7,i)
       vet2(6,ind2)=vet(13,i)
       if (ind2.eq.nrpb2) then
                            nr2=nr2+1
                            jump=-2
                            call sortz(lind2,nrpb2,iblk2,jump)
                            write(iscra,rec=nr2)
     *                      ((vet2(j1,j2),j1=1,6),j2=1,nrpb2)
                            ind2=0   
                            do 105 j1=1,nrpb2
  105                       vet2(2,j1)=-99999.9
                          endif
  110 if (jpart.eq.1) goto 240
c     work out final statistics
      tmul=float(mult)
c     distribution of e with sin(theta)/lambda
      n=min0(10,int(1.0+rr*sqrt(rho)))
      nhr(n)=nhr(n)+mult
      rhr(n)=rhr(n)+esq*tmul
      nzr=int(10.0*esq)+1
      if(nzr.gt.10) nzr=10+(nzr-9)/2
      ee(1)=ed
      do 120 j=2,6
      ee(j)=ee(j-1)*ed
  120 continue
      ee(7)=esq-1.0
      ee(8)=ee(7)*ee(7)
      ee(9)=ee(8)*ee(7)
      ee(10)=abs(ee(9))
      ee(7)=abs(ee(7))
      do 130 j=1,10
      ee(j)=tmul*ee(j)
c     add functions of e to appropriate zones
      vst(j)=vst(j)+  ee(j)
  130 continue
      nst=nst+mult
      if(nzr.le.25) zt(nzr)=zt(nzr)+tmul
c     distribution of e for complete data
      net=min0(25,int(10.0*ed))
      if(net.eq.0) go to 220
      nu(net)=nu(net)+1
  220 nrw=nrw+mult
  240 vet(4,i)=fo
      ivet(7,i)=mod(ivet(7,i),2**15)
  250 continue
c
c---- fine ciclo su vet-ivet
c
  270 continue
c
c---- fine ciclo sui riflessi
c
                            nr2=nr2+1
                            jump=-2
                            call sortz(lind2,nrpb2,iblk2,jump)
                            write(iscra,rec=nr2)
     *                      ((vet2(j1,j2),j1=1,6),j2=1,nrpb2)
      if (jpart.eq.1) goto 570
c     output statistics
      rr=1.0/rr
      do 320 i=1,10
      stl(i)=rr*float(i)
      if(nhr(i).gt.0) rhr(i)=rhr(i)/float(nhr(i))
      if(nst.gt.0) vst(i)=vst(i)/float(nst)
  320 continue
      write(lo,330) stl,rhr,nhr
  330 format(/,40x,'***   final statistics section   ***',//,1h ,35x,
     1 45hdistribution of <E**2> with sin(theta)/lambda,/,10h sinth/lam,
     2 10f10.4/1h ,2x,7h<E**2> ,10f10.4/1h ,2x,6hnumber,10i10)
       write(lo,340)
  340 format(///,44x,14haverage values)
      write(lo,345)
  345 format(/,4x,7haverage,/,
     1        43x,7hnumeric,23x,7hgraphic,/)
      write(cbuff,350)
  350 format( 24x,8hall data,4x,8hacentric,5x,7hcentric,
     1         2x,12hhypercentric,3x,'a. c. h.')
      write(lo,'(a)') cbuff
      do 380 i=1,10
      do 360 j=1,3
  360 line(i,j)=blank
      if (i.eq.2) go to 380
      ctest(1)=abs(vst(i)-ava(i))
      ctest(2)=abs(vst(i)-avc(i))
      ctest(3)=abs(vst(i)-avh(i))
      cmin=9999.9
      do 370 j=1,3
      if (ctest(j).lt.cmin) then
                              cmin=ctest(j)
                              llim=j
                            endif
  370 continue
      line(i,llim)=star
  380 continue
      write(lo,430) (vst(i),ava(i),avc(i),avh(i),
     1              (line(i,j),j=1,3),i=1,10)
  430 format(1h ,5x,6hmod(E),7x,  4f12.3,6x,3(a1,2x),/
     1 1h ,6x,4hE**2,8x,          4f12.3,6x,3(a1,2x),/
     2 1h ,6x,4hE**3,8x,          4f12.3,6x,3(a1,2x),/
     3 1h ,6x,4hE**4,8x,          4f12.3,6x,3(a1,2x),/
     4 1h ,6x,4hE**5,8x,          4f12.3,6x,3(a1,2x),/
     5 1h ,6x,4hE**6,8x,          4f12.3,6x,3(a1,2x),/
     6 1h ,2x,11hmod(E**2-1),5x,  4f12.3,6x,3(a1,2x),/
     7 1h ,2x,11h(E**2-1)**2,5x,  4f12.3,6x,3(a1,2x),/
     8 1h ,2x,11h(E**2-1)**3,5x,  4f12.3,6x,3(a1,2x),/
     9 1h ,16h(mod(E**2-1))**3,2x,4f12.3,6x,3(a1,2x))
      write(lo,450)
  450 format(/,33x,40hn(z) cumulative probability distribution,/)
      cbuff(7:7)='z'
      write(lo,'(a)') cbuff
      do 500 i=1,25
      if(nst.gt.0) zt(i)=zt(i)/float(nst)
      if(i.ne.1) zt(i)=zt(i)+zt(i-1)
c     theoretical distributions
      zz=0.1*float(i)
      if(i.gt.10) zz=2.0*zz-1.0
c     acentric
      cpa=1.0-exp(-zz)
c     centric
      xx=sqrt(0.5*zz)
      t=1.0/(1.0+0.47047*xx)
      cpc=1.0-((0.74786*t-0.09588)*t+0.34802)*t*exp(-0.5*zz)
      do 472 j=1,3
  472 line(i,j)=blank
      ctest(1)=abs(zt(i)-cpa   )
      ctest(2)=abs(zt(i)-cpc   )
      ctest(3)=abs(zt(i)-cph(i))
      cmin=9999.9
      do 475 j=1,3
      if (ctest(j).lt.cmin) then
                              cmin=ctest(j)
                              llim=j
                            endif
  475 continue
      line(i,llim)=star
      write(lo,480) zz,zt(i),cpa,cpc,cph(i),(line(i,j),j=1,3)
  480 format(1h ,f7.1,11x,4f12.3,6x,3(a1,2x))
  500 continue
      do 510 i=1,24
      j=25-i
      nu(j)=nu(j)+nu(j+1)
  510 continue
      write(lo,520)
  520 format(//,38x,44hdistribution of E - number of E's .gt. limit)
      do 540 i=1,25
      avr(i)=0.1*float(i)
  540 continue
      write(lo,560) (avr(i),i=7,25),(nu(i),i=7,25)
  560 format(/,2x,4hE   ,19f6.1/1h ,1x,4hno. ,19i6)
c     output reflexions for sir
  570 continue
      if(jpart.eq.1) go to 575
      nref=nc
      mr=nc
      mm=min0(mm,nl)
      mm=min0(mm,499)
      mz=min0(mz,ns)
      mmz=nint(float(mm)/3.0)


c     mmz = 166


      mz=min0(mz,mmz)
      ms=mr-mz
      if (npseud.gt.0) then
                         mm = nc - mz
                         mm = min0(499,mm)
                         if (mm.gt.nc) mm=nc
                         mm=min0(mm,nl)
                       endif
  575 ksort=1
      call smerge(nr2,nrpb2,nref,npsedd,iy,mm,mz,ksort,bto,sco)
c
      value=0.0
      do 10 i=1,10
      value=value+0.5
      sigv(i,1)=value
      sigv(i,2)=0.0
   10 continue
      aref=0.0
      ndata=0      
      do 600 i=1,nref
      call snr07(vat)
      aref=aref+1.0
      fo=vat(5)
      if (ksigma.gt.0.and.vat(9).gt.0.0) then
                         do 88 jsig=1,10
                         asig=sigv(jsig,1)
                         asigm=asig*vat(9)
                         if (fo.gt.asigm) sigv(jsig,2)=sigv(jsig,2)+1
   88                    continue
                       endif
CORIG if(vat(9).gt.0.0) then
CORIG                    ndata=ndata+1
CORIG                    dumx(ndata)=vat(5)
CORIG                   endif
      if(.not.(vat(9).lt.0.0)) then
                         ndata=ndata+1
                         dumx(ndata)=vat(5)
                        endif
  600 continue
c
c-- print F's statistics
c
      if (jpart.ge.0) then
      if (ksigma.gt.0) then
                         write(lo,670) 
                         do 660 i=1,10
                         isigv(i)=nint(sigv(i,2))
                         isigp(i)=nint(100.0*sigv(i,2)/aref)
  660                    continue
                         write(lo,680) (isigv(i),i=1,10),
     *                                 (isigp(i),i=1,10),
     *                                 (sigv(i,1),i=1,10)
                       endif
  670 format(//,35x,
     *48hnumber and percentage of  F's > param * sigma(F),/)
  680 format('     number',10i8,/,
     *       ' percentage',10(i7,'%'),/,
     *       '      param',10f8.2)
      iniz=1
      istep=1
      jump=-1
      call sortz(iniz,ndata,istep,jump)
      ist=0
Corig istep=nref/10
      istep=ndata/10
      do 705 i=1,10
      ist=ist+istep
      isigv(i)=ist
      isigp(i)=nint(100.0*float(ist)/aref)
      sigv(i,1)=dumx(ist)
  705 continue
      write(lo,710)
  710 format(//,35x,
     *38hnumber and percentage of  F's > limit ,/)
      write(lo,720) (isigv(i),i=1,10),
     *              (isigp(i),i=1,10),
     *              (sigv(i,1),i=1,10)
  720 format('     number',10i8,/,
     *       ' percentage',10(i7,'%'),/,
     *       '      limit',10f8.2)
c
c-- write fosog in list 7
      fosog=sigv(7,1)
      iy=-1
      call spb07(iy)
                      endif
c
      if (jpart.eq.1) call out90p(nref)
      if (jpart.eq.0) call out90(nref,mm,mz)
      return
      end
c---------------------------------------------------------------
c     print of reflexions to be used in sir
      subroutine out90(nref,mm,mz)
      common/unit/ln,lo,ifour,jrel,iscra,jhost,itle(20),jgrap
      common/trig/sint(450),pi,twopi,dtor,rtod
      common/ureq/ ihx(3),ksigma,knw,jpart,jtran,fosog,mxbg,iprin,iflag
      common/c/flgw(30),flgd(30),avr(30),dcv(50),slope,flgk,bt,sc,del,ks
      dimension j(4),k(4),l(4),e(4),kode(4),iph(4),sigma(4)
      dimension ivet(9),vet(9)
      character*7 sigc(4)
      equivalence (vet(1),ivet(1))
c
      call ysfl07(idum0,idum1,idum2,idum3,idum4)
c
      write(lo,700) mm
  700 format(///,1h ,i6,'  largest E-values to phase',/)
      if (knw.eq.0) then
                       npr=4
                       write(lo,10)
                     else
                       npr=3
                       write(lo,15)
                     endif 
   10 format(1x,4(1x,4hcode,9h  h  k  l,7h   E   ,9h  fo/sig.,1x))
c  15 format(3(3x,4hcode,10h   h  k  l,7h   E   ,6h phase,6h sigma,4x))
   15 format(3(3x,4hcode,10h   h  k  l,7h   E   ,6h phase,
     *            9h  fo/sig.,1x))
      kk=0
      do 300 i=1,mm
      call snr07(vet)
      kk=kk+1
      j(kk)=ivet(1)
      k(kk)=ivet(2)
      l(kk)=ivet(3)
      e(kk)=vet(4)
      kkk  =ivet(8)
      kkk=mod(kkk,2**15)
      iph(kk)=kkk/32
      kode(kk)=i
      sigma(kk)=vet(9)
      fo=vet(5)
      if (ksigma.gt.0) then
      if (sigma(kk).gt.0.0) sigma(kk) = fo / sigma(kk)
      if (sigma(kk).lt.0.0) then
                              sigc(kk) = '  gen. '
      else if (sigma(kk).gt.6.0) then
                              sigc(kk) = '     >6'
                            else
                              write(sigc(kk),'(f7.2)') sigma(kk)
                            endif
                       else
                            sigc(kk) = '       '
                            sigma(kk) = 0.0
                       endif
c
c
      if(kk.lt.npr) go to 300
      if(knw.eq.0) then
                     write(lo,25)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),sigc(ii),ii=1,npr)
                    else
                     write(lo,30)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),iph(ii),sigc(ii),ii=1,npr)
                     endif
   25 format(1x,4(i5,3i3,f7.3,a7,3x))
   30 format(3(i7,1x,3i3,f7.3,i5,a7,4x))
      kk=0
  300 continue
      if(kk.eq.0) go to 400
      if (knw.eq.0) then
           write(lo,25)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),sigc(ii),ii=1,kk)
                  else
           write(lo,30)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),iph(ii),sigc(ii),ii=1,kk)
                  endif
c
c       write weak reflection
c
  400 continue
      write(lo,710) mz
  710 format(/,i6,
     * '  smallest E-values for psi0 and negative quartets',/)
      if (knw.eq.0) then
                       write(lo,10)
                     else
                       write(lo,15)
                     endif 
      jj=mm
      nrf=nref-mm-mz
      do 500 i=1,nrf
      jj=jj+1
      call snr07(vet)
  500 continue
      kk=0
      do 600 i=1,mz
      call snr07(vet)
      kk=kk+1
      jj=jj+1
      j(kk)=ivet(1)
      k(kk)=ivet(2)
      l(kk)=ivet(3)
      e(kk)=vet(4)
      kkk  =ivet(8)
      kkk=mod(kkk,2**15)
      iph(kk)=kkk/32
      kode(kk)=jj
      sigma(kk)=vet(9)
      fo=vet(5)
      if (ksigma.gt.0) then
      if (sigma(kk).gt.0.0) sigma(kk) = fo / sigma(kk)
      if (sigma(kk).lt.0.0) then
                              sigc(kk) = '  gen. '
      else if (sigma(kk).gt.6.0) then
                              sigc(kk) = '     >6'
                            else
                              write(sigc(kk),'(f7.2)') sigma(kk)
                            endif
                       else
                            sigc(kk) = '       '
                            sigma(kk) = 0.0
                       endif
c
c
      if(kk.lt.npr) go to 600
      if(knw.eq.0) then
                     write(lo,25)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),sigc(ii),ii=1,npr)
                    else
                     write(lo,30)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),iph(ii),sigc(ii),ii=1,npr)
                     endif
      kk=0
  600 continue
      if(kk.eq.0) return
      if (knw.eq.0) then
           write(lo,25)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),sigc(ii),ii=1,kk)
                  else
           write(lo,30)
     1     (kode(ii),j(ii),k(ii),l(ii),e(ii),iph(ii),sigc(ii),ii=1,kk)
                  endif
      return
      end
c---------------------------------------------------------------
C
      SUBROUTINE MDGAM   (X,P,PROB,IER)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            IER
      REAL               X,P,PROB
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      REAL               V(6),V1(6),PNLG,CNT,YCNT,XMIN,AX,BIG,CUT,
     *                   Y,Z,RATIO,REDUC
      EQUIVALENCE        (V(3),V1(1))
      DATA               XMIN/-87.49823/
C                                  TEST  X AND  P
C                                  FIRST EXECUTABLE STATEMENT
      PROB = 0.0
      IF (X  .GE. 0.0) GO TO 5
      IER = 129
      GO TO 9000
    5 IF (P .GT. 0.0) GO TO 10
      IER = 130
      GO TO 9000
   10 IER = 0
      IF (X  .EQ. 0.0) GO TO 9005
C                                  DEFINE LOG-GAMMA AND INITIALIZE
      PNLG = ALGAMX(P)
      CNT = P * ALOG(X)
      YCNT = X + PNLG
      IF ((CNT-YCNT) .GT. XMIN) GO TO 15
      AX = 0.0
      GO TO 20
   15 AX = EXP(CNT-YCNT)
   20 BIG = 1.E35
      CUT = 1.E-8
C                                  CHOOSE ALGORITHMIC METHOD
      IF ((X  .LE. 1.0) .OR. (X  .LT. P )) GO TO 40
C                                  CONTINUED FRACTION EXPANSION
      Y = 1.0 - P
      Z = X  + Y + 1.0
      CNT = 0.0
      V(1) = 1.0
      V(2) = X
      V(3) = X + 1.0
      V(4) = Z * X
      PROB = V(3)/V(4)
   25 CNT = CNT + 1.0
      Y = Y + 1.0
      Z = Z + 2.0
      YCNT = Y * CNT
      V(5) = V1(1) * Z - V(1) * YCNT
      V(6) = V1(2) * Z - V(2) * YCNT
      IF (V(6) .EQ. 0.0) GO TO 50
      RATIO = V(5)/V(6)
      REDUC = ABS(PROB-RATIO)
      IF (REDUC .GT. CUT) GO TO 30
      IF (REDUC .LE. RATIO*CUT) GO TO 35
   30 PROB = RATIO
      GO TO 50
   35 PROB = 1.0 - PROB * AX
      GO TO 9005
C                                  SERIES EXPANSION
   40 RATIO =  P
      CNT = 1.0
      PROB = 1.0
   45 RATIO = RATIO + 1.0
      CNT = CNT *  X/RATIO
      PROB = PROB + CNT
      IF (CNT .GT. CUT) GO TO 45
      PROB = PROB * AX/P
      GO TO 9005
   50 DO 55 I=1,4
         V(I) = V1(I)
   55 CONTINUE
      IF (ABS(V(5)) .LT. BIG) GO TO 25
C                                  SCALE TERMS DOWN TO PREVENT OVERFLOW
      DO 60 I=1,4
         V(I) = V(I)/BIG
   60 CONTINUE
      GO TO 25
 9000 CONTINUE
      CALL UERTST (IER,'MDGAM ')
 9005 RETURN
      END
C
      SUBROUTINE MERFI (P,Y,IER)
C                                  SPECIFICATIONS FOR ARGUMENTS
      REAL               P,Y
      INTEGER            IER
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      REAL               A,B,X,Z,W,WI,SN,SD,F,Z2,RINFM,A1,A2,A3,B0,B1,
     *                   B2,B3,C0,C1,C2,C3,D0,D1,D2,E0,E1,E2,E3,F0,F1,
     *                   F2,G0,G1,G2,G3,H0,H1,H2,SIGMA
      DATA               A1/-.5751703/,A2/-1.896513/,A3/-.5496261E-1/
      DATA               B0/-.1137730/,B1/-3.293474/,B2/-2.374996/
      DATA               B3/-1.187515/
      DATA               C0/-.1146666/,C1/-.1314774/,C2/-.2368201/
      DATA               C3/.5073975E-1/
      DATA               D0/-44.27977/,D1/21.98546/,D2/-7.586103/
      DATA               E0/-.5668422E-1/,E1/.3937021/,E2/-.3166501/
      DATA               E3/.6208963E-1/
      DATA               F0/-6.266786/,F1/4.666263/,F2/-2.962883/
      DATA               G0/.1851159E-3/,G1/-.2028152E-2/
      DATA               G2/-.1498384/,G3/.1078639E-1/
      DATA               H0/.9952975E-1/,H1/.5211733/
      DATA               H2/-.6888301E-1/
      DATA               RINFM/.3402823E+38/
C                                  FIRST EXECUTABLE STATEMENT
      IER = 0
      X = P
      SIGMA = SIGN(1.0,X)
C                                  TEST FOR INVALID ARGUMENT
      IF (.NOT.(X.GT.-1. .AND. X.LT.1.)) GO TO 30
      Z = ABS(X)
      IF (Z.LE. .85) GO TO 20
      A = 1.-Z
      B = Z
C                                  REDUCED ARGUMENT IS IN (.85,1.),
C                                     OBTAIN THE TRANSFORMED VARIABLE
      W = SQRT(-ALOG(A+A*B))
      IF (W.LT.2.5) GO TO 15
      IF (W.LT.4.) GO TO 10
C                                  W GREATER THAN 4., APPROX. F BY A
C                                     RATIONAL FUNCTION IN 1./W
      WI = 1./W
      SN = ((G3*WI+G2)*WI+G1)*WI
      SD = ((WI+H2)*WI+H1)*WI+H0
      F = W + W*(G0+SN/SD)
      GO TO 25
C                                  W BETWEEN 2.5 AND 4., APPROX. F
C                                     BY A RATIONAL FUNCTION IN W
   10 SN = ((E3*W+E2)*W+E1)*W
      SD = ((W+F2)*W+F1)*W+F0
      F = W + W*(E0+SN/SD)
      GO TO 25
C                                  W BETWEEN 1.13222 AND 2.5, APPROX.
C                                     F BY A RATIONAL FUNCTION IN W
   15 SN = ((C3*W+C2)*W+C1)*W
      SD = ((W+D2)*W+D1)*W+D0
      F = W + W*(C0+SN/SD)
      GO TO 25
C                                  Z BETWEEN 0. AND .85, APPROX. F
C                                     BY A RATIONAL FUNCTION IN Z
   20 Z2 = Z*Z
      F = Z+Z*(B0+A1*Z2/(B1+Z2+A2/(B2+Z2+A3/(B3+Z2))))
C                                  FORM THE SOLUTION BY MULT. F BY
C                                     THE PROPER SIGN
   25 Y = SIGMA*F
      IER = 0
      GO TO 9005
C                                  ERROR EXIT. SET SOLUTION TO PLUS
C                                     (OR MINUS) INFINITY
   30 IER = 129
      Y = SIGMA * RINFM
      CALL UERTST(IER,'MERFI ')
 9005 RETURN
      END
C
      REAL FUNCTION ALGAMX(X)
C                                  SPECIFICATIONS FOR ARGUMENTS
      REAL               X
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      INTEGER            IER,J,IEND,IEND1,IEND2
      LOGICAL            MFLAG
      REAL               Y,T,R,XSIGN,A,B,TOP,DEN,EPS,BIG1,XINF,PI
      REAL               P1(5),Q1(4),P2(5),Q2(4),P3(5),Q3(4),P4(3)
C                                  COEFFICIENTS FOR MINIMAX
C                                  APPROXIMATION TO LN(GAMMA(X)),
C                                  0.5 .LE. X .LE. 1.5
      DATA               P1(1)/-21.96990/,P1(2)/-24.43875/,
     *                   P1(3)/-2.666855/,P1(4)/3.130605/,
     *                   P1(5)/11.16675/
      DATA               Q1(1)/31.46901/,Q1(2)/11.94009/,
     *                   Q1(3)/.6077714/,Q1(4)/15.23469/
C                                  COEFFICIENTS FOR MINIMAX
C                                  APPROXIMATION TO LN(GAMMA(X)),
C                                  1.5 .LE. X .LE. 4.0
      DATA               P2(1)/137.5194/,P2(2)/-142.0463/,
     *                   P2(3)/-78.33593/,P2(4)/4.164389/,
     *                   P2(5)/78.69949/
      DATA               Q2(1)/263.5051/,Q2(2)/313.3992/,
     *                   Q2(3)/47.06688/,Q2(4)/43.34000/
C                                  COEFFICIENTS FOR MINIMAX
C                                  APPROXIMATION TO LN(GAMMA(X)),
C                                  4.0 .LE. X .LE. 12.0
      DATA               P3(1)/27464.76/,P3(2)/230661.5/,
     *                   P3(3)/-212159.6/,P3(4)/-2296.607/,
     *                   P3(5)/-40262.11/
      DATA               Q3(1)/-24235.74/,Q3(2)/-146025.9/,
     *                   Q3(3)/-116328.5/,Q3(4)/-570.6910/
C                                  COEFFICIENTS FOR MINIMAX
C                                  APPROXIMATION TO LN(GAMMA(X)),
C                                  12.0 .LE. X
      DATA               P4(1)/.9189385/,P4(2)/.8333332E-01/,
     *                   P4(3)/-.2770927E-02/
      DATA               IEND/5/,IEND1/4/,IEND2/3/
      DATA               PI/3.141593/
      DATA               XINF/.3402823E+38/
      DATA               EPS/1.192093E-07/
      DATA               BIG1/4.03E36/
C                                  FIRST EXECUTABLE STATEMENT
      IER = 0
      MFLAG = .FALSE.
      T = X
      IF (ABS(T).LT.BIG1) GO TO 5
      IER = 129
      ALGAMX = XINF
      GO TO 9000
    5 IF (T.GT.0.0) GO TO 20
      IF (T.LT.0.0) GO TO 10
      IER = 130
      ALGAMX = XINF
      GO TO 9000
C                                  ARGUMENT IS NEGATIVE
   10 MFLAG = .TRUE.
      T = -T
      R = AINT(T)
      XSIGN = 1.0
      IF (AMOD(R,2.0) .EQ. 0.0) XSIGN = -1.
      R = T-R
      IF (R.NE.0.0) GO TO 15
      IER = 130
      ALGAMX = XINF
      GO TO 9000
C                                  ARGUMENT IS NOT A NEGATIVE INTEGER
   15 R = PI/SIN(R*PI)*XSIGN
      T = T+1.0
      R = ALOG(ABS(R))
C                                  EVALUATE APPROXIMATION FOR
C                                    LN(GAMMA(T)), T .GT. 0.0
   20 IF (T.GT.12.0) GO TO 70
      IF (T.GT.4.0) GO TO 60
      IF (T.GE.1.5) GO TO 50
      IF (T.GE.0.5) GO TO 35
C                                  0.0 .LT. T .LT. 0.5
      B = -ALOG(T)
      A = T
      T = T+1.0
      IF (A.GE.EPS) GO TO 40
      ALGAMX = B
      GO TO 9005
C                                  0.5 .LE. T .LT. 1.5
   35 TOP = T-0.5
      B = 0.0
      A = TOP-0.5
   40 TOP = P1(IEND1)*T+P1(IEND)
      DEN = T+Q1(IEND1)
      DO 45 J=1,IEND2
         TOP = TOP*T+P1(J)
         DEN = DEN*T+Q1(J)
   45 CONTINUE
      Y = (TOP/DEN)*A+B
      IF (MFLAG) Y = R-Y
      ALGAMX = Y
      GO TO 9005
C                                  1.5 .LE. T .LE. 4.0
   50 B = T-1.0
      A = B-1.0
      TOP = P2(IEND1)*T+P2(IEND)
      DEN = T+Q2(IEND1)
      DO 55 J=1,IEND2
         TOP = TOP*T+P2(J)
         DEN = DEN*T+Q2(J)
   55 CONTINUE
      Y = (TOP/DEN)*A
      IF (MFLAG) Y = R-Y
      ALGAMX = Y
      GO TO 9005
C                                  4.0 .LT. T .LE. 12.0
   60 TOP = P3(IEND1)*T+P3(IEND)
      DEN = T+Q3(IEND1)
      DO 65 J=1,IEND2
         TOP = TOP*T+P3(J)
         DEN = DEN*T+Q3(J)
   65 CONTINUE
      Y = TOP/DEN
      IF (MFLAG) Y = R-Y
      ALGAMX = Y
      GO TO 9005
C                                  12.0 .LT. X .LT. BIG1
   70 TOP = ALOG(T)
      TOP = T*(TOP-1.0)-.5*TOP
      T = 1.0/T
      IF (T.LT.EPS) GO TO 75
      B = T*T
      TOP = (P4(3)*B+P4(2))*T+P4(1)+TOP
   75 Y = TOP
      IF (MFLAG) Y = R-Y
      ALGAMX = Y
      GO TO 9005
 9000 CONTINUE
      CALL UERTST(-IER,'MLGAMA')
      CALL UERTST(IER,'ALGAMX')
 9005 RETURN
      END
C
      SUBROUTINE UERTST (IER,NAME)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            IER
      CHARACTER          NAME*(*)
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      INTEGER            I,IEQDF,IOUNIT,LEVEL,LEVOLD,NIN,NMTB
      CHARACTER          IEQ,NAMEQ(6),NAMSET(6),NAMUPK(6)
      DATA               NAMSET/'U','E','R','S','E','T'/
      DATA               NAMEQ/6*' '/
      DATA               LEVEL/4/,IEQDF/0/,IEQ/'='/
C                                  UNPACK NAME INTO NAMUPK
C                                  FIRST EXECUTABLE STATEMENT
      CALL USPKD (NAME,6,NAMUPK,NMTB)
C                                  GET OUTPUT UNIT NUMBER
      CALL UGETIO(1,NIN,IOUNIT)
C                                  CHECK IER
      IF (IER.GT.999) GO TO 25
      IF (IER.LT.-32) GO TO 55
      IF (IER.LE.128) GO TO 5
      IF (LEVEL.LT.1) GO TO 30
C                                  PRINT TERMINAL MESSAGE
      IF (IEQDF.EQ.1) WRITE(IOUNIT,35) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,35) IER,NAMUPK
      GO TO 30
    5 IF (IER.LE.64) GO TO 10
      IF (LEVEL.LT.2) GO TO 30
C                                  PRINT WARNING WITH FIX MESSAGE
      IF (IEQDF.EQ.1) WRITE(IOUNIT,40) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,40) IER,NAMUPK
      GO TO 30
   10 IF (IER.LE.32) GO TO 15
C                                  PRINT WARNING MESSAGE
      IF (LEVEL.LT.3) GO TO 30
      IF (IEQDF.EQ.1) WRITE(IOUNIT,45) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,45) IER,NAMUPK
      GO TO 30
   15 CONTINUE
C                                  CHECK FOR UERSET CALL
      DO 20 I=1,6
         IF (NAMUPK(I).NE.NAMSET(I)) GO TO 25
   20 CONTINUE
      LEVOLD = LEVEL
      LEVEL = IER
      IER = LEVOLD
      IF (LEVEL.LT.0) LEVEL = 4
      IF (LEVEL.GT.4) LEVEL = 4
      GO TO 30
   25 CONTINUE
      IF (LEVEL.LT.4) GO TO 30
C                                  PRINT NON-DEFINED MESSAGE
      IF (IEQDF.EQ.1) WRITE(IOUNIT,50) IER,NAMEQ,IEQ,NAMUPK
      IF (IEQDF.EQ.0) WRITE(IOUNIT,50) IER,NAMUPK
   30 IEQDF = 0
      RETURN
   35 FORMAT(19H *** TERMINAL ERROR,10X,7H(IER = ,I3,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
   40 FORMAT(27H *** WARNING WITH FIX ERROR,2X,7H(IER = ,I3,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
   45 FORMAT(18H *** WARNING ERROR,11X,7H(IER = ,I3,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
   50 FORMAT(20H *** UNDEFINED ERROR,9X,7H(IER = ,I5,
     1       20H) FROM IMSL ROUTINE ,6A1,A1,6A1)
C
C                                  SAVE P FOR P = R CASE
C                                    P IS THE PAGE NAMUPK
C                                    R IS THE ROUTINE NAMUPK
   55 IEQDF = 1
      DO 60 I=1,6
   60 NAMEQ(I) = NAMUPK(I)
      RETURN
      END
C
      SUBROUTINE UGETIO(IOPT,NIN,NOUT)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            IOPT,NIN,NOUT
C                                  SPECIFICATIONS FOR LOCAL VARIABLES
      INTEGER            NIND,NOUTD
      DATA               NIND/5/,NOUTD/6/
C                                  FIRST EXECUTABLE STATEMENT
      IF (IOPT.EQ.3) GO TO 10
      IF (IOPT.EQ.2) GO TO 5
      IF (IOPT.NE.1) GO TO 9005
      NIN = NIND
      NOUT = NOUTD
      GO TO 9005
    5 NIND = NIN
      GO TO 9005
   10 NOUTD = NOUT
 9005 RETURN
      END
C
      SUBROUTINE USPKD  (PACKED,NCHARS,UNPAKD,NCHMTB)
C                                  SPECIFICATIONS FOR ARGUMENTS
      INTEGER            NC,NCHARS,NCHMTB
C
      CHARACTER          UNPAKD(1),IBLANK
      CHARACTER*(1)      PACKED(1)
      DATA               IBLANK /' '/
C                                  INITIALIZE NCHMTB
      NCHMTB = 0
C                                  RETURN IF NCHARS IS LE ZERO
      IF(NCHARS.LE.0) RETURN
C                                  SET NC=NUMBER OF CHARS TO BE DECODED
      NC = MIN0 (129,NCHARS)
      DO 5 I=1,NC
         UNPAKD(I) = PACKED(I)
    5 CONTINUE
C                                  CHECK UNPAKD ARRAY AND SET NCHMTB
C                                  BASED ON TRAILING BLANKS FOUND
      DO 200 N = 1,NC
         NN = NC - N + 1
         IF(UNPAKD(NN) .NE. IBLANK) GO TO 210
  200 CONTINUE
      NN = 0
  210 NCHMTB = NN
      RETURN
      END
