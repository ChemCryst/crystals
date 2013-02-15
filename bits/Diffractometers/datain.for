C $Log: not supported by cvs2svn $
C Revision 1.23  2013/01/20 21:39:30  rich
C Initialise s.u. variables for cell, otherwise NaN values can occur.
C
C Revision 1.22  2012/10/18 12:04:11  djw
C Code from cif2cry merged with difin/datain.  Hundreds of changes.  cif2cry may become obsolete once debugged
C
C Revision 1.21  2012/08/30 10:12:17  djw
C Tidy up screen output so that items missing from cif are more evident
C
C Revision 1.20  2012/03/23 15:49:31  rich
C Intel support.
C fCVS: ----------------------------------------------------------------------
C
C Revision 1.19  2012/01/12 22:15:40  rich
C Fix reading of oxdiff hkls.
C
C Revision 1.18  2012/01/06 10:32:34  rich
C Don't split apart element names (e.g. AG) if the result doesn't make sense (e.g. A 1 G 1).
C But do for SN, -> S 1 N 1.
C
C Revision 1.17  2012/01/05 15:03:03  djw
C Fix typo DCMM > CDMM
C
C Revision 1.16  2012/01/05 14:27:32  djw
C Set up logicals for every data item so that we can check for their presence at the end
C
C Revision 1.15  2012/01/03 14:24:18  rich
C Allow longer filenames and filenames with spaces in.
C
C Revision 1.14  2011/09/22 19:49:34  rich
C Some fixes to make this compile with gfortran and align a common block.
C
C Revision 1.13  2011/09/14 11:09:09  rich
C Extend length of monochromator character string.
C
C Revision 1.12  2011/09/05 07:42:15  djw
C Trap massively negative reflections
C
C Revision 1.11  2011/06/23 09:44:10  djw
C Ensure final formula item is a digit or point.  If no, add "space 1"
C
C Revision 1.10  2011/06/08 11:19:40  djw
C Reorganise code to remove excessive output, remove most interactive questions (some remain), set up input filename and instrument type in popup browse window.
C
C Revision 1.9  2011/05/25 15:44:14  djw
C Change text in output message for case where the input contains a SG symbol.
C
C Revision 1.8  2011/05/17 16:00:16  djw
C Enable long lines, up to 512 characters
C
      SUBROUTINE DATAIN
c #include "ciftbx.sys"
#include "ciftbx.cmn"
#include "cifin.cmn"
      LOGICAL F2,F3,F4,F5
      LOGICAL FC,FV,FN,FF,FT,FW,FZ,FSG,FMON,FABS,FSIZ,FTEMP,FCOL
      LOGICAL F6L, FNX, PROBABLY_NEUTRONS 
      LOGICAL FINFO, FDMDT, FDMD, FDMM
      LOGICAL LNUM, LCHAR

      CHARACTER*16 CSPACE,CNONSP,CTEMP,CSHAPE,SHAPE
      CHARACTER*26 ALPHA
      CHARACTER*32 C32, ENAME, CCOL, BUFFER
      CHARACTER*80 C80
      CHARACTER*80 CMONO,CDMDT,CDMD,CDMM

      CHARACTER*(linlen) LINE
      CHARACTER*(linlen) SLINE
      CHARACTER*(linlen) CFORM


      parameter (nodchr = 29)    !Number of chars to look out for.
      character*(nodchr)  charcCase, charc, numer
      data numer     /'1234567890.000000000000000000'/
      data charcCase /'ABCDEFGHIJKLMNOPQRSTUVWXYZ*?'''/
      data charc     /'abcdefghijklmnopqrstuvwxyz*?'''/
      character*1   c


      parameter     (maxat = 10000)   !Max of 10000 atoms
      real          uisoeq(maxat), occ(maxat)
      real          xf(maxat), yf(maxat), zf(maxat), uij(maxat,6)
      integer       igroup(maxat), nsite, iflag(maxat) 
      character*15  label(maxat,3)

      REAL CELA,CELB,CELC,SIGA,SIGB,SIGC
      REAL CELALP,CELBET,CELGAM,SIGALP,SIGBET,SIGGAM
      REAL X,Y,Z,U,SX,SY,SZ,SU
      REAL HMIN,HMAX,KMIN,KMAX,LMIN,LMAX

      DATA alpha    /'abcdefghijklmnopqrstuvwxyz'/
      DATA sigalp /0.0/,sigbet /0.0/, siggam /0.0/
C 
      PARAMETER   (DTR=3.14159/180.)
      EQUIVALENCE (RES,IRES)

C 
C---- INDICATE NO INFO YET FOUD
      FINFO=.false.
      FC=.false.
      FV=.false.
      FN=.false.
      FF=.false.
      FT=.false.
      FW=.false.
      FZ=.false.
      FSG=.false.
      FMON=.false.
      FABS=.false.
      FSIZ=.false.
      FTEMP=.false.
      FCOL=.false.
      FDMDT=.false.
      FDMD=.false.
      FDMM=.false.
      F6L = .FALSE.
      FL6 = .FALSE.
      cspace = '?'
c
C....... Assign the DATA block to be accessed
C 
      write(6,'(/a,a/)') 'Accessing items in DATA block  ',BLOC_
      write(NTEXT,'(/a,a/)') 'Accessing items in DATA block  ',BLOC_
C 
      FINFO = .TRUE.
C
            ename=block_name(1:NCTRIM(block_name))//' in '//
     1      infil(1:NCTRIM(infil))
            fn = .true.
C 
C----- WRITE OPTIONAL GOODIES TO TEXT FILE
1234  FORMAT(A,'''',A,'''')
      IF (FN) then 
            write(ncif,'(//)')
            WRITE (NCIF,1234) '# Text info for ',
     1                          ENAME(1:NCTRIM(ENAME))
            WRITE (NCIF,1234) '#  ',CDATE(1:NCTRIM(CDATE))
      endif

      f1=CHAR_('_diffrn_measurement_device_type',c80)
      if (f1) then
       FDMDT=CHAR_('_diffrn_measurement_device_type',CDMDT)
       IF (FDMDT) WRITE (NCIF,1234) '_diffrn_measurement_device_type ',
     1 CDMDT(1:nctrim(cdmdt))
      endif
c
c
      F1=CHAR_('_diffrn_measurement_device',c80)
      if (f1) then
       FDMD=CHAR_('_diffrn_measurement_device',CDMD)
       IF (FDMD) WRITE (NCIF,1234) '_diffrn_measurement_device ',
     1   CDMD(1:NCTRIM(CDMD))
      endif

      F1=CHAR_('_diffrn_detector_area_resol_mean',C80)
      IF (F1) WRITE (NCIF,1234) '_diffrn_detector_area_resol_mean ',
     1 C80(1:NCTRIM(C80))

      F1=CHAR_('_diffrn_radiation_monochromator',C80)
      if(f1) then
       FMON=CHAR_('_diffrn_radiation_monochromator',CMONO)
       IF (FMON) WRITE (NCIF,1234) '_diffrn_radiation_monochromator ',
     1 CMONO(1:NCTRIM(CMONO))
      endif

      F1=CHAR_('_computing_data_collection',C80)
      IF (F1) WRITE (NCIF,1234) '_computing_data_collection ',
     1 C80(1:NCTRIM(C80))

      F1=CHAR_('_diffrn_measurement_method',C80)
      if (f1) then
       FDMM=CHAR_('_diffrn_measurement_method',CDMM)
       IF (FDMM) WRITE (NCIF,1234) '_diffrn_measurement_method ',
     1 CDMM(1:NCTRIM(CDMM))
      endif

      F1=CHAR_('_diffrn_orient_matrix_type',C80)
      IF (F1) WRITE (NCIF,1234) '_diffrn_orient_matrix_type ',
     1 C80(1:NCTRIM(C80))

      F1=CHAR_('_computing_cell_refinement',C80)
      IF (F1) WRITE (NCIF,1234) '_computing_cell_refinement ',
     1 C80(1:NCTRIM(C80))

      F1=CHAR_('_computing_data_reduction',C80)
      IF (F1) WRITE (NCIF,1234) '_computing_data_reduction ',
     1 C80(1:NCTRIM(C80))
C 
c
C....... Read in Z
c
      F1 = NUMB_('_cell_formula_units_Z',adum,DUM)
      if (f1) then
       FZ = NUMB_('_cell_formula_units_Z',zp,DUM)
      endif
      IF (.NOT. (FZ)) ZP=0.
C 
c
C....... Read in cell DATA and esds
C 
      F1=NUMB_('_cell_length_a',adum,dum)
      if (f1) then
       FC=NUMB_('_cell_length_a',CELA,SIGA)
       FC=(NUMB_('_cell_length_b',CELB,SIGB)).AND.(FC)
       FC=(NUMB_('_cell_length_c',CELC,SIGC)).AND.(FC)
       FC=(NUMB_('_cell_angle_alpha',CELALP,SIGALP)).AND.(FC)
       FC=(NUMB_('_cell_angle_beta',CELBET,SIGBET)).AND.(FC)
       FC=(NUMB_('_cell_angle_gamma',CELGAM,SIGGAM)).AND.(FC)
       if (fc) then
cdjw - evade spurious significance possibly introduced by MAKECIF
        siga = .0001*max(1,nint(10000*siga))
        sigb = .0001*max(1,nint(10000*sigb))
        sigc = .0001*max(1,nint(10000*sigc))
        write(6,'(/a,6F10.4)') ' Cell ',CELA,CELB,CELC,CELALP,CELBET,
     1  CELGAM
        write(6,'(a,6F10.4/)') '      ',SIGA,SIGB,SIGC,SIGALP,SIGBET,
     1  SIGGAM
       endif
      endif
      IF (.NOT.(FC)) THEN
         write(6,'(a)') 'No cell data in this block.'
         write(NTEXT,'(a)') 'No cell data in this block.'
      ELSE
         write(6,'(A)') 'Cell Data Found'
         write(NTEXT,'(A)') 'Cell Data Found'
      END IF
c
c
C----- GET VOLUME
      F1=NUMB_('_cell_volume',adum,dum)
      if(f1) then
       FV=NUMB_('_cell_volume',CELVOL,SIGVOL)
      endif
       if ((celvol .le. 1.) .and. (fc)) then
c       get a rough volume
         cosa = cos(celalp*3.1419/180.)
         cosb = cos(celbet*3.1419/180.)
         cosc = cos(celgam*3.1419/180.)
         celvol = 1-cosa*cosa-cosb*cosb-cosc*cosc+2.*cosa*cosb*cosc
         celvol = cela*celb*celc*sqrt(celvol)
         sigvol = 0.0
         FV = .TRUE.
       ELSE
          write(6,'(A)') 'Cell Volume Found'
          write(NTEXT,'(A)') 'Cell Volume Found'
       endif
c
C
C Look at scattering factors to see if they suggest neutrons
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
c
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
c
c
c
c
c.....  wavelength
      F1=NUMB_('_diffrn_radiation_wavelength',num,DUM)
      if(f1) then
       FW=NUMB_('_diffrn_radiation_wavelength',WAV,DUM)
      endif
      IF (.NOT.(FW)) THEN
         write(6,'(a)') 'No wavelength '
         write(NTEXT,'(a)') 'No wavelength '
      ELSE
         write(6,'(A,F10.5)') 'Wavelength Found',wav
         write(NTEXT,'(A,F10.5)') 'Wavelength Found',wav
      END IF
c
c
100   CONTINUE
      F1=CHAR_('_chemical_formula',C80)
      if(f1) then
       FF=CHAR_('_chemical_formula',CFORM)
      endif
      IF (.NOT.(FF)) THEN
        F1=CHAR_('_chemical_formula_sum',C80)
        if(f1) then
         FF=CHAR_('_chemical_formula_sum',CFORM)
        endif
      ENDIF
      IF (.NOT.(FF)) THEN
       F1=CHAR_('_chemical_oxdiff_formula', C80)
       if (f1) then
        FF=CHAR_('_chemical_oxdiff_formula', CFORM)
       endif
      ENDIF
      LFORM=LONG_
      IF (.NOT.(FF)) THEN
         write(6,'(a)') 'No chemical formula given'
         write(NTEXT,'(/a/)') 'No chemical formula given'
      END IF
c
c
c
150   CONTINUE
      F2=NUMB_('_diffrn_orient_matrix_UB_11',RMAT11,DUM)
      F2=NUMB_('_diffrn_orient_matrix_UB_12',RMAT12,DUM).AND.(F2)
      F2=NUMB_('_diffrn_orient_matrix_UB_13',RMAT13,DUM).AND.(F2)
      F2=NUMB_('_diffrn_orient_matrix_UB_21',RMAT21,DUM).AND.(F2)
      F2=NUMB_('_diffrn_orient_matrix_UB_22',RMAT22,DUM).AND.(F2)
      F2=NUMB_('_diffrn_orient_matrix_UB_23',RMAT23,DUM).AND.(F2)
      F2=NUMB_('_diffrn_orient_matrix_UB_31',RMAT31,DUM).AND.(F2)
      F2=NUMB_('_diffrn_orient_matrix_UB_32',RMAT32,DUM).AND.(F2)
      F2=NUMB_('_diffrn_orient_matrix_UB_33',RMAT33,DUM).AND.(F2)
      IF (.NOT.(F2)) THEN
         write(6,'(A)') 'No orient matrix or format error'
         write(NTEXT,'(/A/)') 'No orient matrix or format error'
      END IF
                                                                        
200   CONTINUE
      cmru= 0.
      cmtm = 0.
      cmtx = 0.
      F1=NUMB_('_cell_measurement_reflns_used',adum,DUM)
      if (f1) then
       FT=NUMB_('_cell_measurement_reflns_used',CMRU,DUM)
       FT=NUMB_('_cell_measurement_theta_min',CMTM,DUM).AND.(FT)
       FT=NUMB_('_cell_measurement_theta_max',CMTX,DUM).AND.(FT)
      endif
      IF (.NOT.(FT)) THEN
         write(6,'(A)') 'No cell measurement info'
      ELSE
         write(6,'(A)') 'Cell Measurement Data Found'
      END IF

      F1=NUMB_('_exptl_crystal_size_min', adum,DUM)
      xs = 0.
      zd = 0.
      zl = 0.
      if(f1) then
       FSIZ=NUMB_('_exptl_crystal_size_min', ZS,DUM)
       FSIZ=NUMB_('_exptl_crystal_size_mid', ZD,DUM).AND.(FSIZ)
       FSIZ=NUMB_('_exptl_crystal_size_max', ZL,DUM).AND.(FSIZ)
      else
       FSIZ = .FALSE.
      endif
c
      IF (.NOT.(FSIZ)) THEN
         write(6,'(A)') 'No crystal size info in cif.'
c         write(6,'(A)') 
c     1   'Smallest, medium and longest dimensions? [0.2]'
c         read(5,'(a16)') ctemp
c         if (len_trim(ctemp).eq.0) THEN
           zs = 0.0
           zd = 0.0
           zl = 0.0
c         else
c           READ (ctemp,*,err=201,end=201) ZS, ZD, ZL
c         endif
      END IF
      goto 202
201   continue
c      read(5,*) zd,zl
202   continue
      write(6,'(A,3f8.3)') 'Crystal Size Used',zs,zd,zl


      zt = 0.
      F1=NUMB_('_diffrn_ambient_temperature', adum ,DUM)
      if(f1) then
       FTEMP=NUMB_('_diffrn_ambient_temperature', ZT ,DUM)
      endif
      IF (.NOT. FTEMP) THEN
       F1=NUMB_('_cell_measurement_temperature', adum ,DUM)
       if(f1) then
        FTEMP=NUMB_('_cell_measurement_temperature', ZT ,DUM)
       endif
      ENDIF
      IF (.NOT. FTEMP) THEN
c         write(6,'(A)') 'Temperature (K)? [0]'
c         READ (5,'(a16)') ctemp
c         if (len_trim(ctemp).eq.0) THEN
            zt = 0.0
c         else
c            read(ctemp,*) zt
c         endif
      ENDIF
      write(6,'(A,f8.2)') 'Temperature Used',zt
c
c
      ccol = ' '
      F1=CHAR_('_exptl_crystal_colour', c80)
      if(f1) then
       FCOL=CHAR_('_exptl_crystal_colour', ccol)
      endif
      IF (.NOT. FCOL) THEN
       F1=CHAR_('_exptl_crystal_colour_primary', C80)
       if(f1)then
        FCOL=CHAR_('_exptl_crystal_colour_primary', CCOL)
       endif
      ENDIF
      IF (.NOT. FCOL) THEN
c         write(6,'(A)') 'Colour? [Colourless]'
c         read(5,'(a16)') ctemp
c         if (len_trim(ctemp).eq.0) THEN
           ccol = '?'
c         else      
c           READ (ctemp,'(a)') CCOL
c         endif
      ENDIF
      write(6,'(A,3x,a)') 'Crystal Colour Found', ccol(1:nctrim(ccol))
c
c
c 
c -TO DO - SEPTEMBER 2012 - TEST FOR OLD-STYLE F REFINEMENT
C....... Read and process the reflections
C 
      F1=NUMB_('_refln_index_h',adum,DUM)
      if ( .not. f1 ) then
        F1=NUMB_('_hkl_oxdiff_h',adum,DUM)
      end if
c-------------------------------------------------
      if(f1) then
       MINH=10000
       MINK=10000
       MINL=10000
       MAXH=-10000
       MAXK=-10000
       MAXL=-10000
       nref=0
c
cdjw oct07 - read reflections


        nref = 0
        lftype = 0
        rc = 0.

       do while (.true.)


        fl6=numb_('_refln_index_h',RH,DUM)
        fl6=numb_('_refln_index_k',RK,DUM).AND.(FL6)
        fl6=numb_('_refln_index_l',RL,DUM).AND.(FL6)
        if (.not.(fl6)) then
         fl6=numb_('_hkl_oxdiff_h',RH,DUM)
         fl6=numb_('_hkl_oxdiff_k',RK,DUM).AND.(FL6)
         fl6=numb_('_hkl_oxdiff_l',RL,DUM).AND.(FL6)
        endif

         if ( .not. fl6 ) then
          write(6,'(/a/)') 'Reflections missing or wrong format'
          write(ntext,'(/a/)') 'Reflections missing or wrong format'
          exit
         endif

         nref = nref + 1
         rc = 0.
         if ( nref .eq. 1 ) then
           open ( noutr, FILE=chkl, STATUS='unknown' )
         end if

         f1 = numb_('_refln_F_squared_meas', rf, dum)
         if(.not.f1) f1 = numb_('_hkl_oxdiff_f2', rf, dum)

         if ( f1 .and. (lftype .ne. 1 ) ) then
           lftype = 2
           f1 = numb_('_refln_F_squared_sigma', rs, dum)
           if(.not.f1) f1 = numb_('_hkl_oxdiff_sig', rs, dum)
  
           f0 = numb_('_refln_F_squared_calc', rc, dum)
           if ( .not. f1 ) then
             write(6,'(a,i7///)')
     *      ' >>>>> No Fsq sigma found in CIF for reflection ',NREF
             write(ntext,'(a,i7///)')
     *      ' >>>>> No Fsq sigma found in CIF for reflection ',NREF
             nref = 0
             exit
           end if
c
c
         else if ( lftype .ne. 2 ) then
           lftype = 1
           f1 = numb_('_refln_F_meas', rf, dum)
           f1 = numb_('_refln_F_sigma', rs, dum).and.(f1)
           f0 = numb_('_refln_F_calc', rc, dum)
           if ( .not. f1 ) then
             write(6,'(a,i7///)')
     *      ' >>>>> No F or sigmaF found in CIF for reflection ',NREF
             write(ntext,'(a,i7///)')
     *      ' >>>>> No F or sigmaF found in CIF for reflection ',NREF
             nref = 0
             exit
           end if
         else
           write(6,'(a,i7///)')
     *    ' >>>>> No data found in CIF for reflection ',NREF
           write(ntext,'(a,i7///)')
     *    ' >>>>> No data found in CIF for reflection ',NREF
           nref = 0
           exit
         end if
C
         IH=NINT(RH)
         IK=NINT(RK)
         IL=NINT(RL)
         IF ((ABS(IL).GT.255).OR.(ABS(IK).GT.255).OR.(ABS(IH).GT.255))
     1    THEN
          WRITE(6,'(A,3I10,2F10.2,i10)') 'Index too big for CRYSTALS',
     1    IH,IK,IL, RF, RS, nref
          WRITE(ntext,'(A,3I10,2F10.2,i10)') 
     1    'Index too big for CRYSTALS',IH,IK,IL, RF, RS, nref
          CYCLE
         ENDIF
         IF (RF .LT. -9999.0) THEN
          WRITE(6,'(A,3I5,2F15.2,i10)') 
     1    'Reflection too negative',IH,IK,IL, RF, RS, nref
          WRITE(ntext,'(A,3I5,2F15.2,i10)') 
     1    'Reflection too negative',IH,IK,IL, RF, RS, nref
          CYCLE
         ENDIF
         MINH=MIN(MINH,IH)
         MINK=MIN(MINK,IK)
         MINL=MIN(MINL,IL)
C
         MAXH=MAX(MAXH,IH)
         MAXK=MAX(MAXK,IK)
         MAXL=MAX(MAXL,IL)
C
        if (( rf .lt. 100000 ).and.( rc .lt. 100000 )) then
          write ( noutr, '(3I4,3F8.2)' )ih,ik,il,rf,rs
     1                                  ,rc
        else if (( rf .lt. 1000000 ).and.( rc .lt. 1000000 )) then
          write ( noutr, '(3I4,3F8.1)' )ih,ik,il,rf,rs
     1                                  ,rc
        else if (( rf .lt. 10000000 ).and.( rc .lt. 10000000 )) then
          write ( noutr, '(3I4,3F8.0)' )ih,ik,il,rf,rs
     1                                  ,rc
        else
          write ( noutr, '(3I4,3I8)' )ih,ik,il,
     *                                NINT(rf),NINT(rs),NINT(rc)
        end if

        if(.not.(loop_)) exit

       end do
       close(noutr)
c
      endif
c-------------------------------------------------
C
      write(6,'(i8,a/)') nref, ' reflections found'
      write(ntext,'(i8,a/)') nref, ' reflections found'
c
c
      f1 = numb_('_diffrn_reflns_limit_h_min', hmin, dum)
      f1 = numb_('_diffrn_reflns_limit_h_max', hmax, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_k_min', kmin, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_k_max', kmax, dum).or.(f1)
      f1 = numb_('_diffrn_reflns_limit_l_min', lmin, dum).or.(f1)
      f6l = numb_('_diffrn_reflns_limit_l_max', lmax, dum).or.(f1)
c
      if(f6l) then
            minh = nint(hmin)
            maxh = nint(hmax)
            mink = nint(kmin)
            maxk = nint(kmax)
            minl = nint(lmin)
            maxl = nint(lmax)
      endif      
c
C 
      atn = 0.
      atx = 0.
      F1=NUMB_('_exptl_absorpt_correction_T_min',adum,DUM)
      if(f1)then
       FABS=NUMB_('_exptl_absorpt_correction_T_min',atn,DUM)
       FABS=NUMB_('_exptl_absorpt_correction_T_max',atx,DUM).AND.(FABS)
      endif
      if (.not. (fABS)) then
       atn=0.
       atx=0.
      ELSE
         write(6,'(A)') 'Absorption Correction Found'
         write(ntext,'(A)') 'Absorption Correction Found'
      endif
C
C
C....... Extract space group notation (expected char string)
      CSPACE = '?'
      F1=CHAR_('_symmetry_space_group_name_H-M',c80)
      if(f1) FSG=CHAR_('_symmetry_space_group_name_H-M',NAME)
      if(.not. f1) then
       F1=CHAR_('_space_group_name_H-M_alt',c80)
       if(f1) FSG=CHAR_('_space_group_name_H-M_alt',NAME)
      endif
c
       IF (.NOT.(FSG)) THEN
         write(6,'(/a/)') 'No spacegroup found'
         write(ntext,'(/a/)') 'No spacegroup found'
         CSPACE = '?'
         GO TO 1050
       END IF
      if(fsg)then
       CSPACE=NAME(1:LONG_)
       write(6,'(//a,a/)')'Space group  from cif= ',NAME(1:LONG_)
       write(ntext,'(//a,a/)')'Space group  from cif= ',NAME(1:LONG_)
       call xcrems(name, cspace,lspace)
       i = index(cspace(1:lspace),' ')
       if ((i .le. 0) .or. (cspace(2:2) .ne. ' ' ))then
          write(6,'(a)') 
     1 'CRYSTALS needs spaces in symbol - Int Tab G pp 256'
          write(ntext,'(a)') 
     1 'CRYSTALS needs spaces in symbol - Int Tab G pp 256'
          fsg = .false.
       endif
       if (cspace(1:lspace) .eq. 'unknown') fsg = .false.
       if (cspace(1:lspace) .eq. '?') fsg = .false.
C 
c      IDIFF = 0 = UNKNOWN
c      IDIFF = 1 = AGILENT
C      IDIFF = 2 = KCCD
C      IDIFF = 3 = RIGAKU
C      IDIFF = 4 = WINGX
C      IDIFF = 5 = CSD
C
c Kccd SG is only Point Group
      if (idiff .eq. 2) fsg = .false.
      if (fsg) then
         write(6,'(/A)') 
     1 'CAUTION - some cifs only contain the Point Group'
         write(6,'(a,a)')'Space Group from cif is ',
     1    cspace(1:nctrim(cspace))
        if(idiff .ne. 5) then
         write(6,'(a)') 'Is this correct [yes]'
         read (5,'(A)') ctemp
         if ((ctemp(1:1).eq.'n') .or. (ctemp(1:1).eq.'N')) then
           fsg =.false.
         else
           write(6,'(a,a)') 'Using input space group'
           fsg = .true.
         endif
        endif
       endif
      endif
C
c
c----------------------------------------------------------------

      if ((nref .gt. 1).and.(idiff.ne.5).and. (.not.fsg) ) then
C----- reflections all read - check space group with Nonius code
       write(6,'(a)') 'Space Group Code provided by Enraf-Nonius'
       if (.not. fsg) then
         i_value=0
	 isa = 0
         isb = 0
	 if (abs(90.-celalp) .le. .001) isa=isa+1
	 if (abs(90.-celbet) .le. .001) isa=isa+1
	 if (abs(90.-celgam) .le. .001) isa=isa+1
         if(isa .eq. 0) isa=1

	 if (abs(cela-celb) .le. (siga+sigb)) isb=isb+1
	 if (abs(cela-celc) .le. (siga+sigc)) isb=isb+1
	 if (abs(celc-celb) .le. (sigc+sigb)) isb=isb+1
	 if (isb .ge. 1) isa = 0
         i_value=isa
         if (i_value .eq. 0)       write(6,555)
555   FORMAT (' Possible space group types :',/,' Number:   Group:      
     1       ',/,

     * ' 1         1(bar)   triclinic',/,
     * ' 2         2/m      monoclinic(b)',/,
     * ' 3         mmm      orthorhombic',/,
     * ' 4         4/m      tetragonal',/,
     * ' 5         4/mmm    tetragonal',/,
     * ' 6         3(bar)   trigonal/rhomboedric(hex. setting)',/,
     * ' 7         3(bar)m1 trigonal/rhomboedric(hex. setting)',/,
     * ' 8         3(bar)1m trigonal',/,
     * ' 9         6/m      hexagonal',/,
     * ' 10        6/mmm    hexagonal',/,
     * ' 11        m3(bar)  cubic',/,
     * ' 12        m3(bar)m cubic',/)

C
        if (i_value .eq. 0) then
            write(6,557)
            READ (5,556) I_VALUE
        endif
557     format(/,' give space group type number :',//)
556     FORMAT (I5)
c----------------------------------------------------------------
C
        ctemp = ' '
        call sgroup(chkl, i_value,cnonsp)
        lspace = nctrim(cnonsp)
        if (cnonsp(2:2) .ne. ' ') then
            do i=lspace,2,-1
              cnonsp(i+1:i+1) = cnonsp(i:i)
            enddo
            cnonsp(2:2) = ' '
            lspace = lspace + 1
        endif
        if ( cnonsp .eq. ' ') then
            cnonsp='?'
            lspace = nctrim(cnonsp)
        endif
        if (i_value .eq. 2) then
         write(6,'(/a)') 
     1   ' For monoclinic systems, input the full symbol'
        endif
        write(6,'(/A)') 
     1 ' CAUTION - some cifs only contain the Point Group'
        write(6,'(a,a)')' Space Group from cif is : ',cspace(1:lspace)
        write(6,'(/a,a,a)')' Absences suggest [',cnonsp(1:lspace),']'
        write(6,'(a,a,a/)') 'Click RETURN or input space group ',
     1 'symbol with spaces between the components'
        read (5,'(a)') ctemp
        if (ctemp(1:3) .ne. '   ') then
         cspace = ctemp(1:nctrim(ctemp))
        else
         cspace = cnonsp(1:lspace)
        endif
        if (cspace(1:1) .ne. '?') then
          fsg = .true.
        else
          fsg = .false.
        endif
       endif
      endif
C 
C 
C
C....... Read and store the atom site data
C....... =================================

      nsite = 0
240   nsite = nsite+1
      f1 = char_('_atom_site_label', label(nsite,1))
      if(.not.(f1)) then
        write(6,'(/a/)')   ' >>>>> No atom_site_label found'
        write(ntext,'(/a/)')   ' >>>>> No atom_site_label found'
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
        icton = ichar(c)
C . If uppercase, make lowercase.
        if ((icton < 91) .and. (icton > 64) ) then
          icton = icton+32
          c = char(icton)
        end if
        label(nsite,2)=label(nsite,1)(1:iellen)
        label(nsite,2)(2:2) = c
      else if (iellen == 1) then
        label(nsite,2)=label(nsite,1)(1:iellen)
      endif
        
      iserialflag=0
      buffer = ' '

      do j=iellen+1,iellen+6
        buffer(j:j)=label(nsite,1)(j:j)

        do i=1,nodchr
          if (((label(nsite,1)(j:j)) .eq. charcCase(i:i)) .or.
     *        ((label(nsite,1)(j:j)) .eq. charc(i:i))) then
            buffer(j:j)=numer(i:i)
            iserialflag=1
            exit
          endif
        enddo
                     
        if (label(nsite,1)(j:j) == ' '.or.
     *      label(nsite,1)(j:j) == '_' ) then    !First time through there is no serial
            buffer(j:j)='0'
            iserialflag=1
            exit
        end if

        if (label(nsite,1)(j+1:j+1) == ' '.or.
     *      label(nsite,1)(j+1:j+1) == '_' ) exit
      enddo       


C RIC03 - Removed duplicate label detection code. Use #EDIT 
C instead. (See later)

C-------------------------------

C........Store serial number:
      If (iserialflag==0) then
        label(nsite,3)=label(nsite,1)(iellen+1:j)
      else 
        label(nsite,3)=buffer(iellen+1:j)
        write(6, '(a,2x,a,2x,a,2x,a3,a)') 'atom name',
     *          label(nsite,1), 'changed to',
     *            label(nsite,2), label(nsite,3) 

        write(ntext, '(a,2x,a,2x,a,2x,a3,a)') 'atom name',
     *          label(nsite,1), 'changed to',
     *            label(nsite,2), label(nsite,3) 

      endif

      f2 = numb_('_atom_site_fract_x',  xf(nsite), sx)
      f2 = numb_('_atom_site_fract_y',  yf(nsite), sy).AND.(f2)
      f2 = numb_('_atom_site_fract_z',  zf(nsite), sz).AND.(f2)
      if(.not.(f2)) then
         write(6,'(/a/)')' >>>>> atom_site_fract_ missing'
         write(ntext,'(/a/)')' >>>>> atom_site_fract_ missing'
      endif
         
      f2 = numb_('_atom_site_U_iso_or_equiv',  uisoeq(nsite), su)
      if(.not.(f2)) uisoeq(nsite) = 0.05

      f2 = numb_('_atom_site_occupancy', occ(nsite), su)
      if (.not. (f2)) occ(nsite) = 1
       
      f2 = char_('_atom_site_adp_type', name)
      if (.not. (f2)) then
        iflag(nsite) = 1
      else if (name .eq.'Uani') then
        iflag(nsite) = 0
      else if (name .eq. 'Uiso') then
        iflag(nsite) = 1
      endif

      f2 = numb_('_atom_site_disorder_assembly', assmbly, dum)
      if (.not. f2) then
       f2 = char_('_atom_site_disorder_assembly', name)
       if ( .not. f2 ) then
          iasmbly=0
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
         read ( name(1:3),'(I3)') iasmbly
       end if
      else
        iasmbly = nint(assmbly)
      endif
c
      f2 = numb_('_atom_site_disorder_group', group, dum)
      if(.not. f2) then
       f2 = char_('_atom_site_disorder_group', name)
       if ( .not. f2 ) then
          igroup(nsite)=iasmbly * 1000
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
         read ( name(1:4),'(I4)') igroup(nsite)
         igroup(nsite)=sign(abs(igroup(nsite))
     1  +iasmbly*1000,igroup(nsite))
       end if
      else
         igroup(nsite)=nint(group)
         igroup(nsite)=sign(abs(igroup(nsite))
     1  +iasmbly*1000,igroup(nsite))
      endif
C........Check if there are more atoms in the loop to get.
      if(loop_) goto 240
241   continue

C....... Read the Uij loop and store in the site list
      do i=1,nsite
        if (iflag(i) == 0) then
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
c
c
700   CONTINUE
      write(6,*) nsite, ' Atoms found'
      write(NTEXT,*) nsite, ' Atoms found'
c
c
C 
C-----------------------------------------------------------------------
C       BEGIN WRITING THE OUTPUT CRYSTALS FILES ONLY IF CELL DATA FOUND
C
      IF (.NOT.(FC)) THEN
         write(6,'(//a)') 'No cell DATA in this block.'
         write(NTEXT,'(a)') 'No cell DATA in this block.'
         write(6,'(//a)') 'Abandoning  block'
         write(NTEXT,'(a)') 'Abandoning block'
         GO TO 1050
      END IF
C
5678  CONTINUE
C
      IF (FINFO .EQ. .FALSE.) THEN
            WRITE(NTEXT,'(A)') 'No data found in cif'
            goto 1050
      ENDIF
C 
      IF (FN) WRITE (NOUTF,'(//a,2X,A,2x,a)') '#TITLE ',
     1                    ENAME(1:NCTRIM(ENAME)),CDATE
c
c
C Dont write lists if data comes from an .fcf file
      if(.not. fcf) then
C #LIST 1
       IF (FC) THEN
         WRITE (NOUTF,'(a)') '#LIST 1'
         WRITE (NOUTF,'(a,6F11.4)') 'REAL',CELA,CELB,CELC,CELALP,CELBET,
     1    CELGAM
         WRITE (NOUTF,'(a)') 'END'
C 
C            scale the variances
         big=0.0
         SIGA=SIGA*SIGA
         big=max(big,siga)
         SIGB=SIGB*SIGB
         big=max(big,sigb)
         SIGC=SIGC*SIGC
         big=max(big,sigc)
         SIGALP=SIGALP*SIGALP*DTR*DTR
         big=max(big,sigalp)
         SIGBET=SIGBET*SIGBET*DTR*DTR
         big=max(big,sigbet)
         SIGGAM=SIGGAM*SIGGAM*DTR*DTR
         big=max(big,siggam)
         amult = 1./big

         SIGA=SIGA*amult
         SIGB=SIGB*AMULT
         SIGC=SIGC*AMULT
         SIGALP=SIGALP*AMULT
         SIGBET=SIGBET*AMULT
         SIGGAM=SIGGAM*AMULT
c
C #LIST 31
         WRITE (NOUTF,'(a)') '#LIST 31'
         WRITE (NOUTF,'(a,F12.10)') 'AMULT ',BIG
         WRITE (NOUTF,'(2(3(a,F13.6,1x),/),a)') 'MATRIX   V(11)=',SIGA,'
     1V(22)=',SIGB,'V(33)=',SIGC,'CONTINUE V(44)=',SIGALP,'V(55)=',
     2    SIGBET,'V(66)=',SIGGAM,'END'
       END IF
C 
C -SG
C 
C #SPACE
       IF (FSG) THEN
         WRITE (NOUTF,'(a)') '#SPACEGROUP'
         WRITE (NOUTF,'(2a)') 'SYMBOL ',CSPACE
         WRITE (NOUTF,'(a)') 'END'
       ELSE
         WRITE (NOUTF,'(A)') '#SCRIPT XSPACE'
       END IF
C 
       IF (FW) THEN
C      WAVELENGTH
         th1 = 0.
         th2 = 0.
        if(probably_neutrons .eqv. .false.) then
         if(nint(100*wav) .eq. 154) then
c         copper
          th1=13.0
          th2=0.
         else if(nint(100*wav).eq..71) then
c         moly
          th1=6.
          th2=0.
         endif
        endif
        IF (FMON)THEN
         I = INDEX(CMONO,'mirror')
         if (i .ne. 0) then
          th1=0.
          th2=0.
         endif
        ENDIF
C
C #LIST 13
        WRITE (NOUTF,'(a)') '#LIST 13'
        WRITE (NOUTF,'(a)') '# set theta 1 and 2 to zero for mirrors'
        WRITE (NOUTF,'(a,f8.5,a,f8.5,a,f8.5)') 
     1'CONDITIONS WAVELENGTH = ',WAV,' theta(1)=', th1, ' theta(2)=',
     2 th2
        if(probably_neutrons.eqv..true.) 
     1   write(noutf,'(a)') 'diffraction radiation = neutron'
        WRITE (NOUTF,'(a)') 'END'
       END IF
C 
C -FORMULA
C(FF)
       IF (FF) THEN
cdjw Insert space if character immediately follows a number
c    beware if the element type is a charged species like Om2
c
        call fixform(line,cform,lenfil,atsum,celvol,zm,zp,idiff)
c
c
c
         write(6,'(a,a)') 'Formula ',cform(1:NCTRIM(cform))
c
         WRITE (NOUTF,'(a)') '#COMPOSITION'
         WRITE (NOUTF,'(a,a)') 'content ',cform(1:lenfil)
         WRITE (NOUTF,'(a)') 'SCATTERING CRYSDIR:script/scatt.dat'
         WRITE (NOUTF,'(a)') 'PROPERTIES CRYSDIR:script/propwin.dat'
         WRITE (NOUTF,'(a)') 'END'
       END IF
c
C 
C- CELL PARAMTER MEASUREMENTS
C FT
       if(idiff .ne. 5) then
c       IF (.NOT.(FT)) THEN
c        if (cmru .le. 0.0) then
c         write(6,'(A)') 'How many cell measurement reflns used? '
c         READ (5,*) CMRU
c        endif
c        if (cmtm .le. 0.0) then
c         write(6,'(A)') 'Cell measurement theta min? '
c         READ (5,*) CMTM
c        endif
c        if (cmtx .le. 0.0) then
c         write(6,'(A)') 'Cell measurement theta max? '
c         READ (5,*) CMTX
c        endif
c       END IF
       endif
c
c
C.....  SHAPE
         CSHAPE = '?'
         IF (ZS .GT. 0.0) THEN
          IF (ZL/ZS.LT.1.5) THEN
            WRITE (CSHAPE,'(a)') 'block'
          ELSE IF (ZL/ZD.GT.ZD/ZS) THEN
            WRITE (CSHAPE,'(a)') 'prism'
          ELSE
            WRITE (CSHAPE,'(a)') 'plate'
          END IF
          WRITE (NOUTF,'(a,a)') '# shape ',CSHAPE
 
          IF (ZS .LE. .5*ZD) THEN
           IF (ZD .LE. .5*ZL) THEN
            WRITE (CSHAPE,'(a)')'lath'
           ELSE
            WRITE (CSHAPE,'(a)')'plate'
           endif
          ELSE
           IF (ZD .LE. .5*ZL) THEN
            WRITE (CSHAPE,'(a)')'prism'
           ELSE
            WRITE (CSHAPE,'(a)')'block'
           ENDIF
          ENDIF
         ENDIF
         WRITE (NOUTF,'(a,a)') '# shape ',CSHAPE
C  
         f1 = char_('_exptl_crystal_description', shape)
         if(f1) cshape = shape
c
C
C #LIST 30
C----- WRITING LIST 30
         WRITE (NOUTF,'(a)')      '#LIST 30'
         WRITE (NOUTF,'(a,a)')    'DATRED REDUCTION= ', creduct
         WRITE (NOUTF,'(a)')      'ABSORPTION ABSTYPE=multi-scan'
         WRITE (NOUTF,'(a,f8.3)') 'cont empmin=',atn
         WRITE (NOUTF,'(a,f8.3)') 'cont empmax=',atx
         WRITE (NOUTF,'(a)')      'CONDITION'
         WRITE (NOUTF,'(a,f8.3)') 'cont minsiz=',ZS
         WRITE (NOUTF,'(a,f8.3)') 'cont medsiz=',ZD
         WRITE (NOUTF,'(a,f8.3)') 'cont maxsiz=',ZL
         WRITE (NOUTF,'(a,f8.2)') 'cont temperature=',ZT
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmin=',CMTM
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmax=',CMTX
         WRITE (NOUTF,'(a,i7)')   'cont norient=',NINT(CMRU)
         WRITE (NOUTF,'(a)')      'cont scanmode=omega'
         WRITE (NOUTF,'(a,a)')    'cont instrument= ', cinst
         WRITE (NOUTF,'(a)')      'GENERAL'
         WRITE (NOUTF,'(a,f7.1)') 'cont Z=',zm
         WRITE (NOUTF,'(a,a)')    'COLOUR ',ccoL
         WRITE (NOUTF,'(a,a)')    'SHAPE ',cshape
         WRITE (NOUTF,'(a)')      'INDEXRAN'
         WRITE (NOUTF,'(a,i7)')   'cont hmin=',MINH
         WRITE (NOUTF,'(a,i7)')   'cont hmax=',MAXH
         WRITE (NOUTF,'(a,i7)')   'cont kmin=',MINK
         WRITE (NOUTF,'(a,i7)')   'cont kmax=',MAXK
         WRITE (NOUTF,'(a,i7)')   'cont lmin=',MINL
         WRITE (NOUTF,'(a,i7)')   'cont lmax=',MAXL
         WRITE (NOUTF,'(a,i7)')   'END'
c
c--------------------------------------------------------------
c      write out atoms
C
c #LIST 5
       if ( nsite .gt. 0 ) then

        if ( .not.(ff) ) then
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
     *    label(i,3)(1:6),occ(i),iflag(i),xf(i),yf(i),zf(i)
          if (iflag(i) .eq. 0 )then
            write(NOUTF,'(a,6f11.6)')'CON U[11]= ',(uij(i,j),j=1,6)
          else if (iflag(i) .eq. 1) then
            do j=2,6
              uij(i,j)=0
            end do
            write(NOUTF,'(a,6f11.6)') 'CON U[11]=', uisoeq(i),
     *            (uij(i,j), j=2,6)  
          endif
          if ( igroup(i) .ne. 0 ) then
            write(NOUTF,'(a,f11.6)') 'CON PART=', float(igroup(i))
          end if
        end do
        write(NOUTF,'(a)') 'END'
        write(NOUTF,'(a)') '#EDIT'           !This will fix clashing
        write(NOUTF,'(a)') 'LIST LEVEL=OFF ' !serial numbers.
        write(NOUTF,'(a)') 'MONITOR LEVEL=OFF ' !serial numbers.
        write(NOUTF,'(a)') 'CLASH FIXLATTER' !serial numbers.
        write(NOUTF,'(a)') 'END'
       end if
c
c
       IF (.NOT.(FSIZ)) 
     1 write(6,'(A)') 'No crystal size info in cif.'
       IF (.NOT. FTEMP) 
     1 write(6,'(A)') 'No temperature info in cif.'
       IF (.NOT. FCOL) 
     1 write(6,'(A)') 'No colour info in cif.'
c
      endif
c     end of general data when readinf from a non-fcf file
C
Cc #LIST 6
      if ( nref .gt. 0 ) then
        write(NOUTF,'(a)')'# read in reflections'
        write(NOUTF,'(a)')'#CLOSE HKLI'
        write(NOUTF,'(3a)')'#OPEN HKLI  "'//
     *                      chkl(1:len_trim(chkl))//'"'
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
        write(noutf,'(a)')'#LIST 6'
        write(noutf,'(a)')'READ TYPE=COPY'
        write(noutf,'(a)')'END'
      endif
C END LIST 6
C
1050  CONTINUE
      RETURN
      END
C=======================================================================
      INTEGER FUNCTION IGDAT(CFILE)
C      GET AN 8 BYTE CHARACTER REPRESENTATION OF DATE/TIME
      CHARACTER*(*) CFILE
      INTEGER IIDATE(8)
      CHARACTER (LEN=12)CLOCK(3)
      CALL DATE_AND_TIME (CLOCK(1),CLOCK(2),CLOCK(3),IIDATE)
      I=IIDATE(6)+100*IIDATE(5)+10000*IIDATE(3)+1000000*IIDATE(2)
c      WRITE (CFILE,'(I8)') I
      write(cfile,100) iidate(5),iidate(6),iidate(3),iidate(2)
100   format('At ',i2,':',i2,' on ',i2,'/',i2)
      IGDAT=I
      RETURN
      END
c
c
c
      SUBROUTINE FIXFORM (LINE,CFORM,LENFIL,sum,celvol,zm,zp,idiff)
      CHARACTER*(*) LINE,CFORM
c     Separate the components of the formula in LINE into CFORM
      LOGICAL LNUMER, LCHAR, LSPACE, FF, lhatom
      CHARACTER*4 CATOM
      CHARACTER*12 CARG
      CHARACTER*11 NUMER
      CHARACTER*12 CBUFF1
      CHARACTER*20 CBUFF2
      CHARACTER*14 CTEMP
      CHARACTER*26 alpha, ualpha
      CHARACTER*32 C32
      CHARACTER*160 CLONG
      CHARACTER*30 SELEM
      DATA alpha    /'abcdefghijklmnopqrstuvwxyz'/
      DATA ualpha   /'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
      DATA numer/'1234567890.'/
      DATA LATOM/4/
      DATA LARG/12/
c valid single letter elements (including D)
      DATA SELEM /'HDBCNOFPSKVYIWUhdbcnofpskvyiwu'/

c
c      Rules:
c      Elements and the number of atoms should be separated from each 
c      other by at least one space.
c      Elements named with a single letter can be upper or lower case
c      Element followd immediately by a number will be separated by a
c      space
c      Number followed immediately by an element will be separated by 
c      a space
c      Two adjacent letters in the same case (upper or lower) will be
c      sepatated by space 1 space. - if results are valid elements.
c      Two adjacent letters where the first is upper and the second 
c      lower case will be treated as a single element type
c      Two numbers separated by a space will not be interpreted.
c
c       line    c 1 h 2 n 3 o 4                                                                 
c      cform    c 1 h 2 n 3 o 4                                                                 
c
c       line    c1 h2 n3 o4                                                                     
c      cform    c 1 h 2 n 3 o 4                                                                 
c
c       line    c1h 2n 3 o4                                                                     
c      cform    c 1 h 2 n 3 o 4                                                                 
c
c       line    c1h 2n 3 o4 Sn 5                                                                
c      cform    c 1 h 2 n 3 o 4 Sn 5                                                            
c
c       line    c1h 2n 3 o4 SN 5                                                                
c      cform    c 1 h 2 n 3 o 4 S 1 N 5                                                         
c
	

      ff = .true.
      IF (FF) THEN
c     beware if the element type is a charged species like Om2
      lspace = .false.
      lchar = .false.
      lnumer = .false.
      call xcrems (cform,line,lenfil)
      cform = ' '
      k = 1
      do j = 1,lenfil
        i = index(numer,line(j:j))
c
        if (i .gt. 0) then
C       FOUND A NUMBER 
c
          if (lchar) then
c           number following character - insert space
            cform(k:k) = ' '
            cform(k+1:k+1) = line(j:j)
            k = k + 2
            lspace = .false.
            lchar = .false.
            lnumer = .true.
          else if (lspace) then
c           number following space - just output it
            cform(k:k) = line(j:j)
            k = k + 1
            lspace = .false.
            lchar = .false.
            lnumer = .true.
          else
c           number following space - just output it
            cform(k:k) = line(j:j)
            k = k + 1
          endif
c
        else if (line(j:j) .eq. ' ') then
C         JUST A SPACE - OUTPUT IT
c
          cform(k:k) = ' '
          k = k + 1
          lspace = .true.
c
        else
C          NOT A NUMBER OR A SPACE - MUST BE CHARACTER
c
c
           if ( k .eq. 1) then
c            first character on line - just output
             cform(k:k) = line(j:j)
             k = k + 1
             lspace = .false.
             lchar = .true.
             lnumer = .false.
           else if (lspace) then
c            character following space 
c            if last item was also a character, output a 1 first
             if (lchar) then
                  cform(k:k+1) = '1 '
                  k = k + 2
                  lchar = .false.
                  lnum = .true.
             endif
c            character following space - just output it
             cform(k:k) = line(j:j)
             k = k + 1
             lspace = .false.
             lchar = .true.
             lnumer = .false.
           else if (lnumer) then
c            character following number - insert space
             cform(k:k) = ' '
             cform(k+1:k+1) = line(j:j)
             k = k + 2
             lspace = .false.
             lchar = .true.
             lnumer = .false.
           else
c            must be following another character           
             if (k .gt. 1) then
c              check last and current characters are capitals
               l = index(ualpha,cform(k-1:k-1))
               m = index(ualpha,line(j:j))
               if ((l .gt. 0) .and. (m .le. 0)) then
c                 lowercase following capital - just output it
                  cform(k:k) = line(j:j)
                  k = k + 1
                  lspace = .false.
                  lchar = .true.
                  lnumer = .false.
               else if ((l .gt. 0) .and. (m .le. 0)) then
c  			lowercase before capital, insert space.			   
                  cform(k:k+2) = ' 1 '
                  cform(k+3:k+3) = line(j:j)
                  k = k + 4
                  lspace = .false.
                  lchar = .true.
                  lnumer = .false.
               else 
			      if ( ( index(selem,cform(k-1:k-1)).gt.0).and.
     1 	  	      (index(selem,line(j:j)).gt.0)) then
c                 both same case and valid elements - insert a sp 1 sp between them
                    cform(k:k+2) = ' 1 '
                    cform(k+3:k+3) = line(j:j)
                    k = k + 4
                    lspace = .false.
                    lchar = .true.
                    lnumer = .false.
				  else
c same case but not valid element if split up, so output as is				  
                    cform(k:k) = line(j:j)
                    k = k + 1
                    lspace = .false.
                    lchar = .true.
                    lnumer = .false.
				  end if
               endif
             endif        
           endif      
        endif              
      enddo
      endif
      lform = nctrim(cform)
      i = index(numer,cform(lform:lform))
      if (i .le. 0) then
            cform(lform+1:) = ' 1'
            lform = nctrim(cform)
      endif
      write(6,'(a,4x,a)') 'Input:  ', cform
c
c start adding up atoms.
c assume the formula consists of labels and numbers separated by spaces
c------------------------------------------------------------
c
      call xcrems (cform,line,lenfil)
      k=1
      res = 0.
      atsum = 0.
      sum = 0.
      do while (k.le. lenfil)
        i = index(line(k:lenfil),' ')
        i = k + i-2
        i = min(i,k+latom-1)
        catom = line(k:i)
        if ((line(k:i) .eq. 'H') .or. (line(k:i) .eq. 'h')) then
              lhatom = .true.
        else
              lhatom = .false.
        endif
        if ((line(k:i) .eq. 'D') .or. (line(k:i) .eq. 'd')) 
     1        lhatom = .true.
        k = i+2
        i = index(line(k:lenfil),' ')
        i = k + i-2
        i = min(i,k+larg-1)
        carg = line(k:i)
        k = i + 2
c     convert 'number' to real
        l = index(carg,'.')
        if (l.le.0) then
c----- try as integer
          itype = 1
          cbuff1 = carg
          read ( cbuff1 , '(bn,i12)' , err = 1200 ) ivalue
          xvalue = float(ivalue)
        else
c----- try as real
          itype = 2
          cbuff2 = carg
          read ( cbuff2 , '(bn,f20.0)', err = 1200  ) xvalue
        endif   
        res = xvalue
        if (.not. lhatom)  atsum = atsum + res
        sum = sum + res
1200    continue
      enddo
      write(6,'(a,f10.3)') 'No of non-H atoms =', atsum
c------------------------------------------------------------      
c
c  now find the multiplicity
c
         if (celvol .gt. .01) then
          zn=(CELVOL)/(ATSUM*19.)
         else
          zn = 1.0
         endif
         write(6,'(a,f8.2)') 'Z from cif is ', zp
         if (zn .lt. 1.) then
            zz = 1./zn
            zz = nint(zz)
            zz = 1./zz
         else
            zz = float(nint(zn))
         endif
         write(6,'(a,i4,a,f8.2,a)') 
     1 'Z estimated from cell volume and composition is' 
     2  ,nint(zz),' (actually ',zn,')'
         if(zp.le.0.) zp = zz
c
         if(idiff.ne.5) then
          write(6,'(a,f6.1,a)') 'Please give Z [',
     1    zp,']'
          read (5,'(A)') ctemp
          if (len_trim(ctemp).ne.0) THEN
               read (ctemp,*,err=750) zp
          endif
         endif
750      continue
         zm=zp
         write(6,'(a,f6.2)') 'Using Z = ', zp
c
c----     scale the contents
c
      call xcrems (cform,line,lenfil)
       k=1
       kl = 1
       clong = ' '
       do while (k.le. lenfil)
        i = index(line(k:lenfil),' ')
        i = k + i-2
        i = min(i,k+latom-1)
        catom = line(k:i)
        k = i + 2
        i = index(line(k:lenfil),' ')
        i = k + i-2
        i = min(i,k+larg-1)
        carg = line(k:i)
        k = i + 2
c     convert 'number' to real
        l = index(carg,'.')
        if (l.le.0) then
c----- try as integer
          itype = 1
          cbuff1 = carg
          read ( cbuff1 , '(bn,i12)' , err = 1300 ) ivalue
          xvalue = float(ivalue)
        else
c----- try as real
          itype = 2
          cbuff2 = carg
          read ( cbuff2 , '(bn,f20.0)', err = 1300  ) xvalue
        endif   
        res = xvalue
        clong(kl:kl+latom-1) = catom
        kl = kl + latom
        clong(kl:kl)=' '
        kl = kl + 1
        write(clong(kl:kl+larg-1), '(f12.2)') xvalue*zm
        kl = kl + larg 
        clong(kl:kl)=' '
        kl = kl + 1
1300    continue
       enddo
       call xcrems (clong,line,lenfil)
c
c----- remove trailing '.00 '
       do j=1,lenfil
          if (line(j:j+3) .eq.'.00 ') line(j:j+3) = '    '
       enddo
       call xcrems(line,cform,lenfil)
       write(6,'(a,4x,a)') 'Formula:', cform
c
2000   continue
      return
      end
c
C=======================================================================
#include "xgroup.for"
#include "charact.for"
#include "ciftbx.for"
C=======================================================================
