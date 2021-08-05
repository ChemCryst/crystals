      program ctwin

!writes a crystals instruction file given an hklf5 format file from saint.

      implicit none
      real f,s
      integer h,k,l,io, mmax,i,m,lens
      character*(80) junk(9)
      character*(9) crystals_element
      character*20 ctrim,cnew
   
#if defined(CRY_FORTDIGITAL)
      use dflib
      interface
        subroutine no_stdout_buffer
        !dec$ attributes c :: no_stdout_buffer
        end subroutine
      end interface
#else
      interface
        subroutine no_stdout_buffer() bind(c)
          use, intrinsic :: ISO_C_BINDING
          implicit none
        end subroutine
      end interface
#endif      
      write(6,*) 
     1 '  CTWIN - read HKLF5 and write List 6. Simon Parsons 2003. '
      write(6,*) ' '
      write(6,*) 
     1' Input is read from hklf5.hkl and written to ctwin.hkl'
      write(6,*) ' if you are not ready, CTRL+C now...'
      write(6,*) ' '

      write(6,*) 'How many twin components are there '//
     1 '(Crystals can handle up to 9)?'
      read(5,*) mmax

      open(11,file="hklf5.hkl",status='old')
      open(12,file='ctwin.hkl',status='replace')


      do i=1,mmax-1
         write(6,"('Enter twin law number ',i2,' '//
     1   'e.g. 1 0 0 0 -1 0 -0.125 0 -1 <return>')") i
         read(5,'(a80)') junk(i)
      enddo


      write(12,"('#list 6')")
      write(12,
     1"('read ncoeff=6 type=fixed f''s=fsq unit=datafile check=no')")
      write(12,"('input h k l /fo/ sigma(/fo/) elements')")
      write(12,"('format (3f4.0,2f8.2,i9)')")
      write(12,"('store ncoeff=11')")
      write(12,"('output  H K L /FO/ SIGMA(/FO/) /FC/'//
     1' PHASE RATIO  /FOT/ ELEMENTS SQRTW')")
      write(12,"('end')")


      do
      crystals_element = "         "
      read(11,'(3i4,2f8.2,i4)',iostat=io)h,k,l,f,s,m
      if ( (h==0).and.(k==0).and.(l==0) ) exit
      if (io/=0) exit
      if (m<0) then
       do 
        cnew = ctrim(abs(m),lens)
        crystals_element= cnew(1:lens)//crystals_element
        read(11,'(3i4,2f8.2,i4)',iostat=io)h,k,l,f,s,m
         if (m>0) then
          cnew = ctrim(abs(m),lens)
          crystals_element= cnew(1:lens)//crystals_element
          write(12,'(3i4,2f8.2,a9)') h,k,l,f,s,crystals_element
          exit
         else
          cycle
         endif
         enddo
      else   
         crystals_element= ctrim(abs(m),lens)
         write(12,'(3i4,2f8.2,a9)') h,k,l,f,s,crystals_element
