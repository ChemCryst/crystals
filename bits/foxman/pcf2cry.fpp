#include       "ciftbx.for"
      program pcf2cry
#if defined(_DIGITALF77_)
      use dflib
#endif
#include       "ciftbx.cmn"
         logical       f1,f2,f3,f4,f5,f6
         character*32  response,buffer,arg, scantype
         character*24  cspace, output_name, abstype, reduction
         Character*24  instrument     
         character*80  line
         character*256 outfil, infil, name
         character*6   label(1000,3),cpzlabel(100,3)
	   character*1   c
	   
         character*28  charcCase, charc
         character*10  numer
         real          cela,celb,celc,siga,sigb,sigc
         real          celalp,celbet,celgam,sigalp,sigbet,siggam
         real          x,y,z,u,sx,sy,sz,su
         real          numb,sdev,dum,unitZ
c Max of 1000 atoms:
         real          uisoeq(1000),natoms(1000), occ(1000)
         real          xf(1000),yf(1000),zf(1000),uij(1000,6)
         integer       i,j,k,nsite,nelement,flag(1000), cton, ndata
	   integer       spgflag, number,serialflag, n,m
	   real          nrefmes, nrefmerg, rmerge
	   real          minsize, medsize, maxsize
	   real          norien, thorientmin, thorientmax
	   real          temperature, stand, decay
	   real          hmin, hmax, kmin, kmax, lmin, lmax
	   real          r, rw, s, nparam
	   real          dcalc, dobs, molwt
	   character*20   colour, shape
         data numer    /'1234567890'/
	   data charcCase    /'ABCDEFGHIJKLMNOPQRSTUVWWXYZ*?'/
	   data charc    /'abcdefghijklmnopqrstuvwxyz*?'/
         data noutf    /10/



C....... Initialise read/write units (toolbox command):

         f1 = init_( 1, 2, 3, 6 )
          
              CALL Getarg(1, infil)
          if (infil.eq.'') then
          write (*,'(a)', advance="No") 
     *   'Enter input file name: '
          read(*,*) infil
          name = infil
	    else
          name = infil
          endif
         if(.not.(open_(name)))then
            write(6,'(a///)')  ' >>>>> CIF cannot be opened'
            goto 9999
         endif


C....... Assign the data block to be accessed

	   if(.not.(data_(' '))) then
            write(6,'(/a/)')   ' >>>>> No data_ statement found'
            goto 9999
	   else 
	      write(6,'(/a,3x,a)')  'The first crystal data is', bloc_
         endif
		
	   ndata = 1
C.......  Enter the name of the output file
          CALL Getarg(2, outfil)
          if (outfil.eq.'') then
          write (*,'(a)', advance="No") 
     *   'Enter output file name: '
          read(*,*) outfil
          output_name = outfil
	    else
          output_name = outfil
          endif

C....... Open our file for output of CRYSTALS instructions:
         
	   
	   OPEN (NOUTF,FILE= output_name, STATUS='UNKNOWN')


c....... Read and store list 30
c.......=========================

	   f1 = numb_('_exptl_crystal_size_min', minsize, dum)
	   f1 = numb_('_exptl_crystal_size_mid', medsize, dum) .AND. f1
	   f1 = numb_('_exptl_crystal_size_max', maxsize, dum) .AND. f1
c         if (.not. (f1)) then
c		  write(6, '(/a/)') '>>>>> Warning: crystal size missing'
c	   endif
       
         f1 = numb_('_cell_measurement_reflns_used', norien, dum)
	   f1 = numb_('_cell_measurement_theta_min', thorientmin, dum) 
     *         .AND. f1
	   f1 = numb_('_cell_measurement_theta_max', thorientmax, dum)
     *         .AND. f1
c        if (.not. (f1)) then
c		  write(6, '(/a/)') '>>>>Warning: orientating reflections data 
c     *                missing'
c	   endif
       
	   f1 = numb_('_cell_measurement_temperature', temperature, dum)
c	   if (. not. (f1)) then
c	      write(6,'(/a/)') '>>>>> Warning: temperature data missing'
c	   endif

	   f1 = numb_('_diffrn_standards_number', stand, dum)
	   f1 = numb_('_diffrn_standards_decay_%', decay, dum) .AND. f1
           if (stand.eq.0.0) decay = 0.0
c	   if (. not. (f1)) then
c	      write(6,'(a/)') 
c     *	    '>>>>Warning: number of intensity control reflections and
c     *           average decay in intensity not found'
c	   endif

	   f2 = char_('_exptl_crystal_colour', colour)
	   f2 = char_('_exptl_crystal_description', shape) .AND. f2
c	   if (. not. (f2)) then
c		  write(6,'(a/)') '>>>>>Warning: no crystal shape and colour 
c     *      found'
c	   endif

c	   endif
          f2 = char_('_exptl_absorpt_correction_type', abstype)
	    if (abstype.eq.'none') write(6,'(/a,/,/a)', advance = "NO")
     *    ' Absorption type is "none" ',
     *    ' Press ENTER to retain, or enter type: '
         read (*,'(a)') response
	   abstype = response
         if (response.eq.'') abstype = 'none'
           f2 = char_('_diffrn_measurement_method', scantype)
           if (scantype.eq.'\f and \w scans') scantype = 'Phiomega'
           if (scantype.eq.'\f scans') scantype = 'Phi'
           if (scantype.eq.'\w scans') scantype = 'Omega'
           f2 = char_('_diffrn_measurement_device_type', instrument)
           if (instrument.eq.'Bruker APEX-II CCD') instrument='apex2'
	     f2 = char_('_computing_data_reduction', reduction)
           if (reduction.eq.'Bruker SAINT') reduction = 'Saint'


	   write(NOUTF, '(a)') '#List 30'
         write(NOUTF, '(2a)') 'DATRED REDUCTION = ', reduction
         write(NOUTF, '(a, 2x, 3(a, f6.2,2x),/2a,/2a)') 'CONDITIONS', 
     *          'MINSIZE = ', minsize, 'MEDSIZE = ', medsize,
     *          'MAXSIZE = ', maxsize, 'CONTINUE SCANMODE = ', scantype,
     *          'CONTINUE INSTRUMENT = ', instrument
         write(NOUTF, '(a, 2x, a, i6,2x,2(a, f6.2, 2x))') 'CONT',
     *          'NORIEN = ', int(norien), 'THORIENTMIN = ', thorientmin,
     *          'THORIENTMAX = ', thorientmax
	   write(NOUTF, '(a, 2x, 2(a, i6,2x), a,f6.2)') 'CONT',
     *          'TEMPERATURE = ', int(temperature), 'STAND = ',
     *          int(stand), 'DECAY = ', decay
         write(NOUTF, '(2a/,2a)') 'COLOUR ', colour, 'SHAPE ', shape
         write(NOUTF, '(2a)') 'ABSORPTION ABSTYPE = ', abstype
         write(NOUTF, '(a)') 'END'
         write(6,'( /a32, a/)') output_name, 
     *        	   'has been sucessfully created.'   
9999  CONTINUE 
	  
c	 write (6,'(a)', advance = "NO") 'Press ENTER to quit'
c	read (*, '(a)') response 
        stop
	end
