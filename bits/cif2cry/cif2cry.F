#include       "ciftbx.for"
C<ric02>
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
      parameter (maxat = 10000)   !Max of 10000 atoms
      parameter (nodchr = 29)    !Number of chars to look out for.
      character*256 prognm,infil,outfil,option
      logical lfirst,namebl,allbl,linfl,loutfl
      integer optlen
C<ric02/>
#include       "ciftbx.cmn"
      logical       probably_neutrons
      logical       f0,f1,f2,f3,f4,f5,f6
      character*32  name, response,buffer
      character*24  cspace, output_name
      character*33  output_hkl
      character*80  line
      character*15   label(maxat,3),cpzlabel(100,3)
      character*1   c
       
      character*(nodchr)  charcCase, charc, numer
      real          cela,celb,celc,siga,sigb,sigc
      real          celalp,celbet,celgam,sigalp,sigbet,siggam
      real          x,y,z,u,sx,sy,sz,su
      real          wave, wavesu
      real          numb,sdev,dum,unitZ
      real          uisoeq(maxat),natoms(maxat), occ(maxat)
      real          xf(maxat),yf(maxat),zf(maxat),uij(maxat,6)
      integer       group(maxat), asmbly
      integer       h,i,j,k,nsite,nelement,flag(maxat), cton, ndata
      integer       spgflag, number,serialflag
      real          nrefmes, nrefmerg, rmerge
      real          minsize, medsize, maxsize
      real          norien, thorientmin, thorientmax
      real          temperature, stand, decay
      real          hmin, hmax, kmin, kmax, lmin, lmax
      real          r, rw, s, nparam
      real          dcalc, dobs, molwt
      character*20   colour, shape

      data numer     /'1234567890.000000000000000000'/
      data charcCase /'ABCDEFGHIJKLMNOPQRSTUVWXYZ*?'''/
      data charc     /'abcdefghijklmnopqrstuvwxyz*?'''/
      data noutf    /10/
      data noutr    /11/
      data dobs    /0.0/
      data temperature    /0.0/
      data stand    /0.0/
      data decay    /0.0/
      data dcalc    /0.0/
      data molwt    /0.0/
      data norien   /0.0/
      data thorientmin   /0.0/
      data thorientmax   /0.0/
      data hmax    /0.0/
      data kmax    /0.0/
      data lmax    /0.0/
      data hmin    /0.0/
      data kmin    /0.0/
      data lmin    /0.0/
      data r    /0.0/
      data rw    /0.0/
      data s    /0.0/
      data nparam    /0.0/


	  data probably_neutrons /.false./
	  
      call no_stdout_buffer()

cdjw open a file for errors since DOS window closes too fast
c    lots of writes to 17 later
      open(17,file='cif2CRY.lis',status='unknown')

C<ric02>
C Read data from the commandline:
      optlen=132
#if defined(CRY_FORTDIGITAL)
      CALL GetArg(0,prognm,optlen)
#else
      call get_command_argument (0, prognm, optlen)
#endif
      lfirst = .FALSE.
      namebl = .FALSE.
      allbl = .FALSE.
      linfl = .FALSE.
      loutfl = .FALSE.

      N = 1
#if defined(CRY_FORTDIGITAL)
      NARG = IARGC()
#else
      NARG = command_argument_count ()+1
#endif

      DO WHILE ( N .LT. NARG )
#if defined(CRY_FORTDIGITAL)
        CALL GetArg(N,option,optlen) 
#else
        call get_command_argument (N,option,optlen) 
#endif
        IF (option.eq.'-f') THEN
          IF ( allbl ) GOTO 8000
          lfirst = .TRUE.
        ELSE IF (option.eq.'-a') THEN
          IF ( lfirst ) GOTO 8000
          allbl = .TRUE.
        ELSE IF (option.eq.'-n') THEN
          if ( loutfl ) GOTO 8000
          N = N + 1
          IF ( N .GE. NARG ) GOTO 8000
          namebl=.TRUE.
#if defined(CRY_FORTDIGITAL)
          CALL GetArg(N,outfil,optlen)
#else
          call get_command_argument (N,outfil,optlen)
#endif
          IF (outfil(1:1).eq.'-') GOTO 8000
        ELSE IF (option.eq.'-o') THEN
          if ( namebl ) GOTO 8000
          N = N + 1
          IF ( N .GE. NARG ) GOTO 8000
          loutfl=.TRUE.
#if defined(CRY_FORTDIGITAL)
          CALL GetArg(N,outfil,optlen)
#else
          call get_command_argument (N,outfil,optlen)
#endif

          IF (outfil(1:1).eq.'-') GOTO 8000
        ELSE IF (option(1:1).eq.'-') THEN
          GOTO 8000
        ELSE
          IF (linfl) GOTO 8000
          IF ( N .GE. NARG ) GOTO 8000
          linfl=.TRUE.
#if defined(CRY_FORTDIGITAL)
          CALL GetArg(N,infil,optlen)
#else
          call get_command_argument (N,infil,optlen)
#endif
        END IF
        N = N + 1
      END DO
C<ric02/>




C....... Initialise read/write units (toolbox command):

      f1 = init_( 1, 2, 3, 6 )

C<ric02>
      if ( .not. linfl ) then
C</ric02>
           
C.......  Enter the name of Cif file
        write (6, '(1x,a)') 
     *      "Enter name of the Cif file (e.g. test.cif):  "
        write (17, '(1x,a)') 
     *      "Enter name of the Cif file (e.g. test.cif):  "

C<ric02>
        read (*, '(a)') infil
      end if
C</ric02>

C<ric02>
      if(.not.(open_(infil)))then
C</ric02>
        write(6,'(a///)')  ' >>>>> CIF cannot be opened'
        write(17,'(a///)')  ' >>>>> CIF cannot be opened'
        goto 9999
      endif

C....... Assign the data block to be accessed

10    if(.not.(data_(' '))) then
        write(6,'(/a/)')   ' >>>>> No data_ statement found'
        write(6,'(/a/)')   ' >>>>> No data_ statement found'
        write(17,'(/a/)')   ' >>>>> No data_ statement found'
        goto 9999
      else
        if (bloc_ =="global") then
        write(6,'(/a,a/)')   ' >>>>> data_global statement found -',
     1  ' now looking for block_'
        write(17,'(/a,a/)')   ' >>>>> data_global statement found -',
     1  ' now looking for block_'
        open(18,file='cif_global.lis',status='unknown')
        write(18,'(/a,a/)')   ' >>>>> data_global statement found -',
     1  ' now looking for block_'
          goto 10
        else
          write(6,'(/a,3x,a)') 'The first crystal data is',bloc_
          write(17,'(/a,3x,a)') 'The first crystal data is',bloc_
        endif 
      endif
        
      ndata = 1

C<ric02>
120   if ( ( .not. loutfl ) .and. ( .not. namebl ) ) then
C.......  Enter the name of the output file
        write (6, '(/a)')
     *         " Enter name of the output file [cifin.dat]: "
        write (17, '(/a)')
     *         " Enter name of the output file [cifin.dat]: "
C</ric02>

        read (*, '(a)' ) output_name
        if (output_name == ' ') then
          output_name="cifin.dat"
        endif

C<ric02>
        outfil = output_name
      end if
      output_name = outfil
      output_hkl = outfil(1:len_trim(outfil))//'.hkl'
C<ric02/>

C....... Open our file for output of CRYSTALS instructions:
       
C<ric02>
      if ( namebl ) then
C Name formed from blockname and outfil is used as extension:
        option = bloc_
        DO N = 1,LEN_TRIM(option)    !Remove illegal chars
          IF ( option(N:N) .EQ. '\') option(N:N) = '_'
          IF ( option(N:N) .EQ. '/') option(N:N) = '_'
          IF ( option(N:N) .EQ. ':') option(N:N) = '_'
          IF ( option(N:N) .EQ. '*') option(N:N) = '_'
          IF ( option(N:N) .EQ. '?') option(N:N) = '_'
          IF ( option(N:N) .EQ. '>') option(N:N) = '_'
          IF ( option(N:N) .EQ. '<') option(N:N) = '_'
          IF ( option(N:N) .EQ. 'Ý') option(N:N) = '_'
          IF ( option(N:N) .EQ. '|') option(N:N) = '_'
        END DO
        OPEN (NOUTF,FILE=option(1:LEN_TRIM(option))//outfil,
     1                                  STATUS='UNKNOWN')
        output_name = option(1:LEN_TRIM(option))//outfil
        output_hkl = output_name(1:len_trim(output_name))//'.hkl'
      else if ( allbl ) then
C All blocks into one file. Only open once:
        if ( ndata .eq. 1 ) then
          OPEN (NOUTF,FILE=outfil, STATUS='UNKNOWN')
        end if
        output_hkl = outfil(1:len_trim(outfil))//'00000'//'.hkl'
        write(output_hkl(len_trim(outfil)+1:len_trim(outfil)+5),
     *  '(i5.5)') ndata
      else
C Any other case, just open it:           
        OPEN (NOUTF,FILE=outfil, STATUS='UNKNOWN')
      end if
      write(6,'(''Output: '',A)') output_name
      write(17,'(''Output: '',A)') output_name

      option = bloc_
      DO N = 1,LEN_TRIM(option)    !Remove illegal chars
        IF ( option(N:N) .EQ. '\') option(N:N) = '_'
        IF ( option(N:N) .EQ. '/') option(N:N) = '_'
        IF ( option(N:N) .EQ. ':') option(N:N) = '_'
        IF ( option(N:N) .EQ. '*') option(N:N) = '_'
        IF ( option(N:N) .EQ. '?') option(N:N) = '_'
        IF ( option(N:N) .EQ. '>') option(N:N) = '_'
        IF ( option(N:N) .EQ. '<') option(N:N) = '_'
        IF ( option(N:N) .EQ. 'Ý') option(N:N) = '_'
        IF ( option(N:N) .EQ. '|') option(N:N) = '_'
       END DO
       write(NOUTF,'(2a)') '#TITLE ', option(1:LEN_TRIM(option))


c
C<ric02/>
C....... Read in cell data and esds
C....... ==========================
C....... f1 ends up false if any of these functions fail.

      siga = 999.99
      sigb = 999.99
      sigc = 999.99
      sigalp = 999.99
      sigbet = 999.99
      siggam = 999.99

      f1 = numb_('_cell_length_a', cela, siga)
      f1 = (numb_('_cell_length_b', celb, sigb)).AND.(f1)
      f1 = (numb_('_cell_length_c', celc, sigc)).AND.(f1)
      f1 = (numb_('_cell_angle_alpha', celalp, sigalp)).AND.(f1)
      f1 = (numb_('_cell_angle_beta', celbet, sigbet)).AND.(f1)
      f1 = (numb_('_cell_angle_gamma', celgam, siggam)).AND.(f1)

      if(.not.(f1)) then
        write(6,'(a)') '>>>>> No cell data in this block.'
        write(17,'(a)') '>>>>> No cell data in this block.'
      else
C....... Write out a crystals instruction:

       write(NOUTF,'(a)') '#LIST 1'
       write(NOUTF,'(a,6f11.4)') 'REAL',cela,celb,celc,
     *                              celalp,celbet,celgam
       write(NOUTF,'(a)') 'END'
       DTRSQ = .000305
       if ( siga+sigb+sigc+sigalp+sigbet+siggam .lt. 999.0) then
        write(NOUTF,'(a)') '#LIST 31'
        write(NOUTF,'(a)') 'AMULT 1.0'
        write(NOUTF,'(a,1x,F12.10,A)') 'MATRIX', SIGA*SIGA,
     1 ' 0.0 0.0 0.0 0.0 0.0 '
        write(NOUTF,'(a,1x,F12.10,A)') 'CONT', SIGB*SIGB,
     1 ' 0.0 0.0 0.0 0.0  '
        write(NOUTF,'(a,1x,F12.10,A)') 'CONT', SIGC*SIGC,
     1 ' 0.0 0.0 0.0  '
        write(NOUTF,'(a,1x,F12.10,A)') 'CONT', 
     1 SIGALP*SIGALP*DTRSQ,' 0.0 0.0  '
        write(NOUTF,'(a,1x,F12.10,A)') 'CONT', 
     1 SIGBET*SIGBET*DTRSQ,' 0.0  '
        write(NOUTF,'(a,1x,F12.10,A)') 'CONT', 
     1 SIGGAM*SIGGAM*DTRSQ,'  '
        write(NOUTF,'(a)') 'END'
       end if
      endif

C     probably_neutrons only true if a1 coeff are present and all zero.
180   continue
      f2 = numb_('_atom_type_scat_Cromer_Mann_a1',  x, sx)
	  if (.not.(f2)) goto 182
	  if ( abs ( x ) .lt. 0.000001 ) then
	    probably_neutrons = .true.
      else
	    probably_neutrons = .false.
		goto 182 !stop looping
	  end if
      if(loop_) goto 180
182   continue

C     probably_neutrons set true if diffrn_radiation_type starts with 'neutron'.
      f1 = char_('_diffrn_radiation_type', name)
	  if ( f1 ) then
	    do i = 1,len(name)
          j = index( charcCase, name(i:i) )
		  if ( j .gt. 0 ) name(i:i) = charc(j:j)
		end do
		if ( index( name, 'neutron' ) .gt. 0 ) then
		   probably_neutrons = .true.
		end if
      end if
190   continue		  


c djwnov09
c      read in wavelength
      f1 = numb_('_diffrn_radiation_wavelength', wave, wavesu)
      if(.not.(f1)) then
        write(6,'(a)') '>>>>> No wavelength data in this block.'
        write(17,'(a)') '>>>>> No wavelength data in this block.'
      else
C....... Write out a crystals instruction:
       write(NOUTF,'(a)') '#LIST 13'
	   if ( probably_neutrons ) then
         write(NOUTF,'(a)') 'diffraction radiation = neutrons'
	   end if
       write(NOUTF,'(a,f12.10)') 'condition ', wave
       write(NOUTF,'(a)') 'end'
      endif
c

C....... Extract space group notation (expected char string):
C....... =============================

      f1 = char_('_symmetry_space_group_name_H-M', name)
cdjwdec07  Note new alternative identifier
      if (.not. (f1)) then
        f1 = char_('_space_group_name_H-M_alt', name)
      endif

      if(.not.(f1)) then
         write(6,'(/a/)')   ' >>>>> No spacegroup found'
         write(17,'(/a/)')   ' >>>>> No spacegroup found'
      else   
        write(NOUTF,'(a)') '# The spacegroup symbol must have '//
     *                  'a space between each of the operators.'
        write(NOUTF,'(a)') '#SPACEGROUP'      
       
        spgflag=0
         
C If it contains spaces, it's probably ok.
        do i= 1, long_
          if (name(i:i) == ' ') spgflag=1
        end do

C If 2nd char is not a space this is definitely wrong.
        if (name(2:2) .ne. ' ' ) spgflag = 0
     
        if (spgflag == 1) then
          write(NOUTF,'(2a)') 'SYMBOL ',name(1:long_)
          write(NOUTF,'(a)') 'END'
        else 
          write(6,'(/a)') '# The spacegroup symbol must have '//
     *                  'a space between each of the operators.'
          write (6, '(/a,3x,a/)') 'The space group symbol in '//
     *        'this cif file is', name
          write (6, '(a)')
     *              'Please enter the new space group (e.g. P n m a): '

          write(17,'(/a)') '# The spacegroup symbol must have '//
     *                  'a space between each of the operators.'
          write (17, '(/a,3x,a/)') 'The space group symbol in '//
     *        'this cif file is', name
          write (17, '(a)')
     *              'Please enter the new space group (e.g. P n m a): '

          read (*, '(a)') name
          write(NOUTF,'(2a)') 'SYMBOL ',name
          write(NOUTF,'(a)') 'END'
        endif
        
      endif
 	  
	  
C....... Extract cell formula units Z

      f1 = numb_('_cell_formula_units_Z', unitZ, dum)
      if(.not.(f1)) then
        write(6,'(/a/)')   ' >>>>> No cell_formula_units_Z found'
        write(17,'(/a/)')   ' >>>>> No cell_formula_units_Z found'
        unitZ = 1.
      endif
C....... Extract composition data (expected char string)
C....... =========================
         
      f1 = char_('_chemical_formula_sum', name)

      nocomp = 0

         
      if(.not.(f1)) then
        write(6,'(/a/)')   ' >>>>> No composition data found'
        write(17,'(/a/)')   ' >>>>> No composition data found'
        nocomp = 1

      else

C....... Pull apart the composition data into Atom1Number1, Atom2Number2(K4 C6...)
        nelement=1
        if (name(1:1) .eq. ' ') then
          k=2
        else 
           k=1
        endif   
        do i=2, long_
          if (name(i:i) .eq. ' ')  then
            cpzlabel(nelement,1) = name(k:i-1)
            nelement = nelement + 1
            k = i+1
          else if (i == long_) then
            cpzlabel(nelement,1) = name(k:i)
            nelement = nelement + 1
          endif
        end do
         
        do i=1, nelement-1
          iellen=2
          do j=1,11
            name = cpzlabel(i,1)
            if (numer(j:j).eq.name(2:2)) then
              iellen=1
            end if
          end do  
          cpzlabel(i,2) = name(1:iellen) 
C                                        Store atom type 
          cpzlabel(i,3) = name(iellen+1: long_)
C                                        Store the number of atoms
          natoms(i)= unitZ*ctonum1(cpzlabel(i,3))
          if (ctonum1(cpzlabel(i,3)) == 0) then
            natoms(i) = unitZ * 1
          end if
        end do

        write(NOUTF,'(a)') '#Composition'
        write(NOUTF, '(a,15(a2,I4,2x))') 'content   ',
     *               (cpzlabel(i,2), Int(natoms(i)),i=1,nelement-1)
        
		if ( probably_neutrons ) then
          write(NOUTF,'(a/a)')'SCATTERING CRYSDIR:script/nscatt.dat',
     *              'PROPERTIES CRYSDIR:script/propwin.dat'
		else
	      write(NOUTF,'(a/a)')'SCATTERING CRYSDIR:script/scatt.dat',
     *              'PROPERTIES CRYSDIR:script/propwin.dat'
	    end if
        write(NOUTF, '(a)') 'end'
      endif

        

C
C....... Read and store the atom site data
C....... =================================

      nsite = 0
240   nsite = nsite+1
      f1 = char_('_atom_site_label', label(nsite,1))
      if(.not.(f1)) then
        write(6,'(/a/)')   ' >>>>> No atom_site_label found'
        write(17,'(/a/)')   ' >>>>> No atom_site_label found'
        nsite=nsite-1
        goto 241
      endif
          
C....... pull apart the site label into element and number
C....... find out if one of two character element by checking
C....... if 2nd char is a number:
C....... Original label is in label(n,1)
      iellen=2
      do i=1,10
        if (numer(i:i).eq.label(nsite,1)(2:2)) iellen=1
      end do
C........Store element type in label(n,2):
      if (iellen == 2) then
        c=label(nsite,1) (2:2)
        cton = ichar(c)
C . If uppercase, make lowercase.
        if ((cton < 91) .and. (cton > 64) ) then
          cton = cton+32
          c = char(cton)
        end if
        label(nsite,2)=label(nsite,1)(1:iellen)
        label(nsite,2)(2:2) = c
      else if (iellen == 1) then
        label(nsite,2)=label(nsite,1)(1:iellen)
      endif
        
      serialflag=0
      buffer = ' '

      do j=iellen+1,iellen+6
        buffer(j:j)=label(nsite,1)(j:j)

        do i=1,nodchr
          if (((label(nsite,1)(j:j)) .eq. charcCase(i:i)) .or.
     *        ((label(nsite,1)(j:j)) .eq. charc(i:i))) then
            buffer(j:j)=numer(i:i)
            serialflag=1
            exit
          endif
        enddo
                     
        if (label(nsite,1)(j:j) == ' '.or.
     *      label(nsite,1)(j:j) == '_' ) then    !First time through there is no serial
            buffer(j:j)='0'
            serialflag=1
            exit
        end if

        if (label(nsite,1)(j+1:j+1) == ' '.or.
     *      label(nsite,1)(j+1:j+1) == '_' ) exit
      enddo       


C RIC03 - Removed duplicate label detection code. Use #EDIT 
C instead. (See later)

C-------------------------------

C........Store serial number:
      If (serialflag==0) then
        label(nsite,3)=label(nsite,1)(iellen+1:j)
      else 
        label(nsite,3)=buffer(iellen+1:j)
        write(6, '(a,2x,a,2x,a,2x,a3,a)') 'atom name',
     *          label(nsite,1), 'changed to',
     *            label(nsite,2), label(nsite,3) 

        write(17, '(a,2x,a,2x,a,2x,a3,a)') 'atom name',
     *          label(nsite,1), 'changed to',
     *            label(nsite,2), label(nsite,3) 

      endif

      f2 = numb_('_atom_site_fract_x',  xf(nsite), sx)
      f2 = numb_('_atom_site_fract_y',  yf(nsite), sy).AND.(f2)
      f2 = numb_('_atom_site_fract_z',  zf(nsite), sz).AND.(f2)
      if(.not.(f2)) then
         write(6,'(/a/)')' >>>>> atom_site_fract_ missing'
         write(17,'(/a/)')' >>>>> atom_site_fract_ missing'
      endif
         
      f2 = numb_('_atom_site_U_iso_or_equiv',  uisoeq(nsite), su)
      if(.not.(f2)) uisoeq(nsite) = 0.05

      f2 = numb_('_atom_site_occupancy', occ(nsite), su)
      if (.not. (f2)) occ(nsite) = 1
       
      f2 = char_('_atom_site_adp_type', name)
      if (.not. (f2)) then
        flag(nsite) = 1
      else if (name .eq.'Uani') then
        flag(nsite) = 0
      else if (name .eq. 'Uiso') then
        flag(nsite) = 1
      endif

      f2 = char_('_atom_site_disorder_assembly', name)
      if ( .not. f2 ) then
         asmbly=0
      else
        if ( name(1:1) .eq. ' ' ) name(1:1) = '1' 
        do i = 1,LEN_TRIM(name)    !ABCD -> 1234 etc.
          do j = 1,nodchr
            if ( ( name(i:i) .eq. charcCase(j:j) ) .or.
     *           ( name(i:i) .eq. charc(j:j)     ) ) then
              k = min(j,9)
              name(i:i) = numer(k:k)
            end if
          end do
        end do
        read ( name(1:3),'(I3)') asmbly
      end if
      f2 = char_('_atom_site_disorder_group', name)
      if ( .not. f2 ) then
         group(nsite)=asmbly * 1000
      else
        if ( name(1:1) .eq. ' ' ) name(1:1) = '1' 
        do i = 1,LEN_TRIM(name)    !ABCD -> 1234 etc.
          do j = 1,nodchr
            if ( ( name(i:i) .eq. charcCase(j:j) ) .or.
     *           ( name(i:i) .eq. charc(j:j)     ) ) then
              k = min(j,9)
              name(i:i) = numer(k:k)
            end if
          end do
        end do
        read ( name(1:4),'(I4)') group(nsite)
        group(nsite)=sign(abs(group(nsite))+asmbly*1000,group(nsite))
      end if
     
           
C         
C........Check if there are more atoms in the loop to get.

      if(loop_) goto 240
241   continue

C....... Read the Uij loop and store in the site list
      do i=1,nsite
        if (flag(i) == 0) then
          f1 = char_('_atom_site_aniso_label', name) 
          do j=1, nsite
            if(label(j,1).eq.name) then
              f1 = numb_('_atom_site_aniso_U_11', uij(i,1), dum)
              f1 = numb_('_atom_site_aniso_U_22', uij(i,2), dum) 
              f1 = numb_('_atom_site_aniso_U_33', uij(i,3), dum)
              f1 = numb_('_atom_site_aniso_U_23', uij(i,4), dum)
              f1 = numb_('_atom_site_aniso_U_13', uij(i,5), dum) 
              f1 = numb_('_atom_site_aniso_U_12', uij(i,6), dum)
              goto 300
            end if  
          end do
        endif
300     if(.not.(loop_)) exit
      end do


      if ( nsite .gt. 0 ) then

        if ( nocomp .eq. 1 ) then
          write(NOUTF,'(a)') '#Composition'
          write(NOUTF, '(a)') 'content C 1 H 1 '
          write(NOUTF,'(a/a)')'SCATTERING CRYSDIR:script/scatt.dat',
     *                    'PROPERTIES CRYSDIR:script/propwin.dat'
          write(NOUTF, '(a)') 'END'
        end if

        write(NOUTF,'(a)') '#LIST 5'
        write(NOUTF,'(a)') 'OVERALL 1 0.05 0.05 0 0 0'
        write(NOUTF,'(a,i4,x,a)') 'READ NATOM = ',nsite,
     *      'NLAYER = 0 NELEMENT = 0 NBATCH = 0 '

        do i=1,nsite
          write(NOUTF,'(3(a,1x),f11.6,i4,3f11.6,1X,2a4)')
     *    'ATOM',label(i,2)(1:6),
cdjw     *    label(i,3)(1:6),occ(i),flag(i),xf(i),yf(i),zf(i),'NEW=',
cdjw     *    label(i,1)(1:4)
     *    label(i,3)(1:6),occ(i),flag(i),xf(i),yf(i),zf(i)
c     *    label(i,1)(1:4)
          if (flag(i) .eq. 0 )then
            write(NOUTF,'(a,6f11.6)')'CON U[11]= ',(uij(i,j),j=1,6)
          else if (flag(i) .eq. 1) then
            do j=2,6
              uij(i,j)=0
            end do
            write(NOUTF,'(a,6f11.6)') 'CON U[11]=', uisoeq(i),
     *            (uij(i,j), j=2,6)  

          endif
          if ( group(i) .ne. 0 ) then
            write(NOUTF,'(a,f11.6)') 'CON PART=', group(i)
          end if
        end do
        write(NOUTF,'(a)') 'END'
        write(NOUTF,'(a)') '#EDIT'           !This will fix clashing
        write(NOUTF,'(a)') 'LIST LEVEL=OFF ' !serial numbers.
        write(NOUTF,'(a)') 'MONITOR LEVEL=OFF ' !serial numbers.
        write(NOUTF,'(a)') 'CLASH FIXLATTER' !serial numbers.
        write(NOUTF,'(a)') 'END'
      end if


c....... Read and store list 30
c.......=========================


      f1 = numb_('_diffrn_reflns_number', nrefmes,dum)
      f1 = numb_('_reflns_number_total', nrefmerg, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_av_R_equivalents', rmerge, dum).or.(f1)
      f1 = numb_('_exptl_crystal_size_min', minsize, dum).or.(f1)
      f1 = numb_('_exptl_crystal_size_mid', medsize, dum).or.(f1)
      f1 = numb_('_exptl_crystal_size_max', maxsize, dum).or.(f1)
      f1 = numb_('_cell_measurement_reflns_used', norien, dum).or.(f1)
      f1 = numb_('_cell_measurement_theta_min', thorientmin,dum).or.(f1)
      f1 = numb_('_cell_measurement_theta_max', thorientmax,dum).or.(f1)
      f1 =numb_('_cell_measurement_temperature',temperature,dum).or.(f1)
      f1 = numb_('_diffrn_standards_number', stand, dum).or.(f1)
      f1 = numb_('_diffrn_standards_decay_%', decay, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_h_min', hmin, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_h_max', hmax, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_k_min', kmin, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_k_max', kmax, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_l_min', lmin, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_l_max', lmax, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_theta_min', thetamin, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_theta_max', thetamax, dum).or.(f1)
      f2 = char_('_exptl_crystal_colour', colour).or.(f1)
      f2 = char_('_exptl_crystal_description', shape).or.(f1)
      f1 = numb_('_refine_ls_R_factor_gt', r, dum).or.(f1)
      f1 = numb_('_refine_ls_wR_factor_ref', rw, dum).or.(f1)
      f1 = numb_('_refine_ls_number_parameters', nparam, dum).or.(f1)
      f1 = numb_('_refine_ls_goodness_of_fit_ref', s, dum).or.(f1)
      f1 = numb_('_exptl_crystal_density_diffrn', dcalc, dum).or.(f1)
      f1 = numb_('_exptl_crystal_density_meas', dobs, dum).or.(f1)
      f1 = numb_('_chemical_formula_weight', molwt,dum).or.(f1)

      IF ( f1 ) then

        write(NOUTF, '(a)') '#List 30'
        write(NOUTF,'(a,2x, 2(a,I6,2x), a, f6.2)') 'DATRED',
     *        'NREFMES = ', nint(nrefmes), 'NREFMERG = ', 
     *         int(nrefmerg), 'RMERGE = ', rmerge 
        write(NOUTF, '(a, 2x, 3(a, f6.2,2x))') 'CONDITIONS', 
     *          'MINSIZE = ', minsize, 'MEDSIZE = ', medsize,
     *          'MAXSIZE = ', maxsize
        write(NOUTF, '(a, 2x, a, i6,2x,2(a, f6.2, 2x))') 'CONT',
     *          'NORIEN = ', int(norien), 'THORIENTMIN = ', thorientmin,
     *          'THORIENTMAX = ', thorientmax
        write(NOUTF, '(a, 2x, 2(a, i6,2x), a,f6.2)') 'CONT',
     *          'TEMPERATURE = ', int(temperature), 'STAND = ',
     *          int(stand), 'DECAY = ', decay
        write(NOUTF, '(a,2x, 6(a,i3,1x),/a,2x,2(a,f8.2,2x))') 
     *          'INDEXRANGE','HMIN=', int(hmin), 'HMAX=', int(hmax),
     *          'KMIN=',  int(kmin),'KMAX=', int(kmax), 'LMIN=', 
     *          int(lmin),'LMAX=', int(lmax), 
     *          'CONT', 'THETAMIN = ',
     *          thetamin, 'THETAMAX = ', thetamax 
        write (NOUTF, '(a,2x, 4(a, f8.2))') 'GENERAL', 'DOBS = ',
     *          dobs, ' DCALC = ', dcalc, ' MOLWT = ', molwt, ' Z = ', 
     *          unitZ 
        write(NOUTF, '(2a/,2a)') 'COLOUR ', colour, 'SHAPE ', shape
        write(NOUTF, '(a,2x, 2(a,f7.2,2x),a,i6,2x,a,f6.4)') 
     *          'REFINEMENT', 'R = ',  100.*r, 
     *          'RW = ',   100.*rw, 'NPARAM = ', 
     *          int(nparam), 'GoF = ', s
        write(NOUTF, '(a)') 'END'

      end if

cdjw oct07 - read reflections


      nref = 0
      lftype = 0
      rc = 0.

      do while (.true.)

        f1 = numb_('_refln_index_h', rh, dum)
        f1 = numb_('_refln_index_k', rk, dum).AND.(f1)
        f1 = numb_('_refln_index_l', rl, dum).AND.(f1)

        if ( .not. f1 ) exit

        nref = nref + 1

        if ( nref .eq. 1 ) then
          open ( noutr, FILE=output_hkl, STATUS='unknown' )
        end if

        f1 = numb_('_refln_F_squared_meas', rf, dum)

        if ( f1 .and. (lftype .ne. 1 ) ) then
          lftype = 2
          f1 = numb_('_refln_F_squared_sigma', rs, dum)
          f0 = numb_('_refln_F_squared_calc', rc, dum)
          if ( .not. f1 ) then
            write(6,'(a,i7///)')
     *      ' >>>>> No Fsq sigma found in CIF for reflection ',NREF

            write(17,'(a,i7///)')
     *      ' >>>>> No Fsq sigma found in CIF for reflection ',NREF
            nref = 0
            exit
          end if

          if ( .not. f0 ) then
            write(6,'(a,i7///)')
     *      ' >>>>> No Fcalc found in CIF for reflection ',NREF
            write(17,'(a,i7///)')
     *      ' >>>>> No Fcalc found in CIF for reflection ',NREF
            nref = 0
            exit
          end if
        else if ( lftype .ne. 2 ) then
          lftype = 1
          f1 = numb_('_refln_F_meas', rf, dum)
          f1 = numb_('_refln_F_sigma', rs, dum).and.(f1)
          f0 = numb_('_refln_F_calc', rc, dum)
          if ( .not. f1 ) then
            write(6,'(a,i7///)')
     *      ' >>>>> No F or sigmaF found in CIF for reflection ',NREF
            write(17,'(a,i7///)')
     *      ' >>>>> No F or sigmaF found in CIF for reflection ',NREF
            nref = 0
            exit
          end if
        else
          write(6,'(a,i7///)')
     *    ' >>>>> No data found in CIF for reflection ',NREF
          write(17,'(a,i7///)')
     *    ' >>>>> No data found in CIF for reflection ',NREF
          nref = 0
          exit
        end if

        if (( rf .lt. 100000 ).and.( rc .lt. 100000 )) then
          write ( noutr, '(3I4,3F8.2)' )NINT(rh),NINT(rk),NINT(rl),rf,rs
     1                                  ,rc
        else if (( rf .lt. 1000000 ).and.( rc .lt. 1000000 )) then
          write ( noutr, '(3I4,3F8.1)' )NINT(rh),NINT(rk),NINT(rl),rf,rs
     1                                  ,rc
        else if (( rf .lt. 10000000 ).and.( rc .lt. 10000000 )) then
          write ( noutr, '(3I4,3F8.0)' )NINT(rh),NINT(rk),NINT(rl),rf,rs
     1                                  ,rc
        else
          write ( noutr, '(3I4,3I8)' )NINT(rh),NINT(rk),NINT(rl),
     *                                NINT(rf),NINT(rs),NINT(rc)
        end if

        if(.not.(loop_)) exit

      end do

      if ( nref .gt. 0 ) then

        write(NOUTF,'(a)')'# read in reflections'
        write(NOUTF,'(a)')'#CLOSE HKLI'
        write(NOUTF,'(3a)')'#OPEN HKLI  "'//
     *                      output_hkl(1:len_trim(output_hkl))//'"'
        write(NOUTF,'(a)')'#HKLI'
        if ( lftype .eq. 2 ) then
          write(NOUTF,'(a)')'READ F''S=FSQ NCOEF=6 TYPE=FIXED CHECK=NO'
        else
          write(NOUTF,'(a)')'READ F''S=FO NCOEF=6 TYPE=FIXED CHECK=NO'
        end if
        write(NOUTF,'(a)')'INPUT H K L /FO/ SIGMA(/FO/) /Fc/'
        write(NOUTF,'(a)')'FORMAT (3F4.0, 3F8.0)'
        write(NOUTF,'(a)')'STORE NCOEF=7'
        write(NOUTF,'(a)')'OUTP INDI /FO/ SIG RATIO/J CORR SERI /Fc/'
        write(NOUTF,'(a)')'END'
        write(NOUTF,'(a)')'#CLOSE HKLI'

        write(NOUTF,'(a)')'#GENERALEDIT 13'
        write(NOUTF,'(a)')'LOCATE RECORDTYPE = 101'
        write(NOUTF,'(a)')'CHANGE OFFSET=0  MODE =INTEGER  INTEGER=-1 '
        write(NOUTF,'(a)')'WRITE OVERWRITE=OVERWRITE'
        write(NOUTF,'(a)')'END'


        write(NOUTF,'(a)')'#GENERALEDIT 23'
        write(NOUTF,'(a)')'LOCATE RECORDTYPE=103'
        write(NOUTF,'(a)')'CHANGE OFFSET=1 MODE=INTEGER INTEGER=0'
        write(NOUTF,'(a)')'WRITE OVERWRITE=OVERWRITE'
        write(NOUTF,'(a)')'END'




        write(NOUTF,'(a)')'#SYSTEMATIC'
        write(NOUTF,'(a)')'#SORT'
        write(NOUTF,'(a)')'#MERGE'
        write(NOUTF,'(a)')'#LIST 6'
        write(NOUTF,'(a)')'READ TYPE = COPY'
        write(NOUTF,'(a)')'#LIST 4'
        write(NOUTF,'(a)')'#WEIGHT'
        write(NOUTF,'(a)')'END'
      end if


      write(NOUTF, '(a)') '#SCRIPT CIFPROC'

      write(6,'(/a, a/)') output_name, 
     *             'has been sucessfully created.'
      write(17,'(/a, a/)') output_name, 
     *             'has been created.'

9900  write(6,'(a)') 'Check new crystal data ... ...'
      write(17,'(a)') 'Check new crystal data ... ...'
    
      if(.not.(data_(' '))) then
        write (6, '(a)') ' ---------------------------------' 
        write(6,'(a)')   ' *** No more structures found ***'
        write (6, '(a)') ' ---------------------------------' 
        write(6,'(/I4, 2x, a/, a)') ndata, 
     *        'structure(s) processed. Final message', 
     *          ' Program is finished.'  

        write (17, '(a)') ' ---------------------------------' 
        write(17,'(a)')   ' *** No more structures found ***'
        write (17, '(a)') ' ---------------------------------' 
        write(17,'(/I4, 2x, a/, a)') ndata, 
     *        'structure(s) processed. Final message', 
     *          ' Program is finished.'  

        goto 9999
      else 
        write (6, '(a)') ' -----------------------------------'
        write  (6, '(2x,a)') '*** New structure found ***'
        write (6, '(2x,a,a,a)') '(', bloc_, ')'
        write (6, '(a)') ' -----------------------------------' 

        write (17, '(a)') ' -----------------------------------'
        write  (17, '(2x,a)') '*** New structure found ***'
        write (17, '(2x,a,a,a)') '(', bloc_, ')'
        write (17, '(a)') ' -----------------------------------' 

c<ric02>
        if ( allbl ) then     !User has req. all blocks on cmd line.              
          ndata = ndata + 1
          goto 120
        end if
        if ( lfirst ) goto 9999  !User only wants first block.
c<ric02/>
          write (6, '(a)') ' Continue y/n? [y]'
          write (17, '(a)') ' Continue y/n? [y]'
          read (*, '(a)') response
          if (response == 'y' .or. response == 'Y' .or. 
     *                                    response == ' ') then
            ndata = ndata + 1
            goto 120
          else if (response == 'n'.or. response == 'N') then
            write (6, '(I4,2x,a)') ndata, 
     *          'structure(s) processed. Final message.' 
            write (17, '(I4,2x,a)') ndata, 
     *          'structure(s) processed. Final message.' 
            goto 9999
          endif                 
        endif

C<ric02>
      goto 9999
8000  CONTINUE    !Usage error
      write(6,'(/3a/)')  'Usage: ',prognm(1:LEN_TRIM(prognm)),
     1 ' [-f|a] [[-n blockname]|[-o outputfile]] [inputfile]'

      write(17,'(/3a/)')  'Usage: ',prognm(1:LEN_TRIM(prognm)),
     1 ' [-f|a] [[-n blockname]|[-o outputfile]] [inputfile]'


9999  CONTINUE 
      if ( .not. linfl ) then   !Only print quit message in interactive mode.
        write (6,'(a)') 'Press ENTER to quit'
        read (*, '(a)') response
      end if
C<ric02/>
      end
