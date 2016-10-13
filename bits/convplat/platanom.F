      program platanom
c convert A and B parts of PLATON output for amomalous scattering
c
      character *80 cin,cout,chkl,ctemp
      character *4 ceyword, sfac
      logical lcell, lsfac
c
      dimension  cx(9), p(6) !unit cell and reciprocal data.
c
      character *4 catom(10)
      dimension    matom(10)
      dimension values(12)
      dimension scat(12,10) !f', f", (a-i), natom
c
      cin ='platon.res'
      chkl='LIST6.ABC'
      cout='LIST6.DEF'
      open(10,file=cin,status='old')
      open(11,file=chkl,status='old')
      open(12,file=cout,status='unknown')

      nref = 0

      write(*,*)
     1 'nscat,  Number of elements in solvent (maximum is 10)'
      read(*,*)nscat
      write(*,*)' Name & number for each different element'
      write(*,*) 'e.g. C 1 Cl 4'
      read(*,*,err=400) (catom(i),matom(i),i=1,nscat) ! atoms in solvent
      do i=1,nscat
            call xccupc(catom(i),ctemp(1:4))
      write(*,*)i,catom(i),ctemp(1:4)
            catom(i)=ctemp(1:4)
      enddo
      write(*,'(a4,i6)')(catom(i),matom(i),i=1,nscat)
c
      write(*,*) 'D-multiplier (usually 1.0)'
      read(*,*) dmult
c
c
c
c start reading the res file.
      LSCAT = 0      ! NUMBER OF SCATTERING CURVES
      lcell=.false.
      lsfac=.false.
100   continue

      read (10,'(a)',err=150,end=150) ctemp  
      read (ctemp,'(a)') ceyword
      if(ceyword.eq.'CELL') then
            write(*,*)ceyword
            read(ctemp,'(5X, F8.5, 3F7.3, 3F8.3)')         
     1 wave, (cx(i),i=1,6)
      write (*,*) (cx(i),i=1,6)
      lcell=.true.
c
      else if(ceyword.eq.'SFAC') then
            read(ctemp,1837) sfac,(values(i),i=3,9)
            write(*,1837) sfac,(values(i),i=3,9)
1837    FORMAT (5x , A4, 7F9.4)
        read (10,'(a)',err=150,end=150) ctemp  
        read(ctemp,1838) values(10),values(11),values(1),values(2)
        write(*,1838) values(10),values(11),values(1),values(2)
1838    FORMAT ( 9X,4F9.4,F9.2,2F9.4 )

        do j=1,nscat
         if(catom(j).eq.sfac)then
          lscat=lscat+1
          write(*,*)'lscat=',lscat
          do l=1,11 
            scat(l,lscat)=values(l)
          enddo
          scat(12,lscat)= matom(j)
         endif
        enddo
      endif
      goto 100

150   continue
      if(nscat.ne.lscat)then
      write(*,*)'Insufficient scattering factors found'
      goto 200
      endif
      if(.not.lcell)then
      write(*,*)'Unit cell not found'
      goto 200
      endif
c
      do j = 1,nscat
            write(*,'(i4,3x,a4,12f8.4)')j,catom(j),(scat(i,j),i=1,12)
      enddo
c
c total real and imaginary scattering
      frt=0.
      fit=0.
      do i=1,8
            read(11,'(a)')ctemp
            write(12,'(a)')ctemp(1:80)
      enddo
c
      pi=3.14159
      dtr=pi/180.
c
c  calculate reciprocal parameters    
c
c     sine and cosine of cell angles plus trigonometric part of volume  
c
      arg=1.0                                                           
      do 10 i=4,6                                                       
        cx(i+3)=sin(dtr*cx(i))                                           
        cx(i)=cos(dtr*cx(i))                                             
        arg=arg-cx(i)*cx(i)                                               
10    continue                                                          
      v=sqrt(arg+2.0*cx(4)*cx(5)*cx(6))
c     volume and reciprocal cell functions                              
      v=1.0/(v*cx(1)*cx(2)*cx(3))                                       
      p(1)=cx(2)*cx(3)*cx(7)*v                                          
      p(2)=cx(1)*cx(3)*cx(8)*v                                          
      p(3)=cx(1)*cx(2)*cx(9)*v                                          
      p(4)=0.5*p(1)*p(2)*(cx(4)*cx(5)-cx(6))/(cx(7)*cx(8))              
      p(5)=0.5*p(1)*p(3)*(cx(4)*cx(6)-cx(5))/(cx(7)*cx(9))              
      p(6)=0.5*p(2)*p(3)*(cx(5)*cx(6)-cx(4))/(cx(8)*cx(9))              
      do 40 i=1,3                                                       
        p(i)=0.25*p(i)*p(i)                                               
        cx(i+3)=180.0*atan2(cx(i+6),cx(i+3))/pi                           
40    continue                                                          
      WRITE(*,*) 'Vol=',1./V
      write(*,'(A,6F8.4)')'P= ', p                                                    
c
c      loop over reflections
c
300   continue
      read(11,'(3i4,a)',err=200,end=200) ih,ik,il,ctemp(1:53)
      read(11,'(2f8.4)',err=200,end=200) apart,bpart
      if(ih.eq.-512) goto 200
      nref=nref+1
        rho   =p(1)*float(ih*ih)+p(2)*float(ik*ik)+p(3)*float(il*il)
     3        +p(4)*float(ih*ik)+p(5)*float(ih*il)+p(6)*float(ik*il)
c Get normal, real and imaginary parts
      frt = 0.
      frn = 0.
      fit = 0.
      fn = 0.
      do i=1,nscat
             f=scat(11,i)
     1       +scat(3,i) * exp(-scat(4,i)*rho)
     1       +scat(5,i) * exp(-scat(6,i)*rho)
     1       +scat(7,i) * exp(-scat(8,i)*rho)
     1       +scat(9,i) * exp(-scat(10,i)*rho)
             fn =         f*scat(12,i)
             fr = scat(1,i)*scat(12,i)
             fi = scat(2,i)*scat(12,i)
             frn=frn+fn
             frt=frt+fr
             fit=fit+fi
      enddo
      d = fit/(frn+frt)
      d = d*dmult
      anewa=  apart-d*bpart
      bnewb=d*apart+  bpart
      write(12,'(3i4,a)') ih,ik,il,ctemp(1:53)
      write(12,'(2f8.2)') anewa, bnewb
      goto 300
400   CONTINUE
      WRITE(*,*) 'Error during input of solvent formula'
200   continue
      write(12,'(i4//)') -512
      write(*,*)'Number of reflections read =',nref, '  dmod=',dmult
      write(*,*)'Press return to finish'
      read(*,'(a)') ctemp
      stop
      end
c
c

code for xccupc
      subroutine xccupc ( clower , cupper )
c
c -- convert string to uppercase
c      clower      source string to be converted
c      cupper      resultant string
      character*(*) clower , cupper
      character*26 calpha , cequiv
      DATA CALPHA / 'abcdefghijklmnopqrstuvwxyz' /
      DATA CEQUIV / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
c
c -- move whole string.
c-assigning lower to upper is formally invalid
c      cupper = clower
      length = min0 ( len ( clower ) , len ( cupper ) )
      if ( length .le. 0 ) then
        return
      end if
      read(clower,'(a)') cupper
c -- search for lowercase characters and convert to uppercase
      do 2000 i = 1 , length
        ipos = index ( calpha , clower(i:i) )
        if ( ipos .gt. 0 ) cupper(i:i) = cequiv(ipos:ipos)
2000  continue
      return
      end

