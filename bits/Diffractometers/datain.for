      SUBROUTINE DATAIN
#include "ciftbx.cmn"
#include "cifin.cmn"
      LOGICAL F2,F3,F4,F5
      LOGICAL FC,FV,FN,FF,FT,FW,FZ,FSG,FMON,FABS,FSIZ,FTEMP,FCOL
      logical lnum, lchar

      CHARACTER*16 CSPACE,CTEMP,CMONO
      CHARACTER*26 ALPHA
      CHARACTER*32 C32, ENAME,CCOL 
      CHARACTER*50 C50
      CHARACTER*80 C80,LINE,SLINE,CFORM
      CHARACTER*160 CLONG, c160
      CHARACTER*6 LABEL(1000,3)
C         CHARACTER*26  alpha
      CHARACTER*11 NUMER
      REAL CELA,CELB,CELC,SIGA,SIGB,SIGC
      REAL CELALP,CELBET,CELGAM,SIGALP,SIGBET,SIGGAM
      REAL X,Y,Z,U,SX,SY,SZ,SU
      REAL NUMB,SDEV,DUM
      REAL OCC(1000)
      REAL XF(1000),YF(1000),ZF(1000),UIJ(1000,6)
      INTEGER I,J,NSITE
      DATA alpha    /'abcdefghijklmnopqrstuvwxyz'/
      DATA NUMER/'1234567890.'/
      DATA NOUTF/10/,NHKL/11/,NCIF/12/
C 
      PARAMETER (DTR=3.14159/180.)
      EQUIVALENCE (RES,IRES)

C 
C....... Assign the DATA block to be accessed
C 
50    IF (.NOT.(DATA_(' '))) THEN
         WRITE (6,'(/a/)') 'No DATA_ statement found'
         GO TO 1050
      END IF
C 
      WRITE (6,'(/a,a/)') ' Accessing items in DATA block  ',BLOC_
C 
C....... Read in Z
c
      FZ = NUMB_('_cell_formula_units_Z',zp,DUM)
      IF (.NOT. (FZ)) ZP=0.
C 
C....... Read in cell DATA and esds
C 
      FC=NUMB_('_cell_length_a',CELA,SIGA)
      FC=(NUMB_('_cell_length_b',CELB,SIGB)).AND.(FC)
      FC=(NUMB_('_cell_length_c',CELC,SIGC)).AND.(FC)
      FC=(NUMB_('_cell_angle_alpha',CELALP,SIGALP)).AND.(FC)
      FC=(NUMB_('_cell_angle_beta',CELBET,SIGBET)).AND.(FC)
      FC=(NUMB_('_cell_angle_gamma',CELGAM,SIGGAM)).AND.(FC)
C 
      IF (.NOT.(FC)) THEN
         WRITE (6,'(a)') 'No cell DATA in this block.'
         WRITE (6,'(a)') 'Trying next block.'
         GO TO 50
      ELSE
         WRITE (6,'(A)') 'Cell Data Found'
      END IF
c
C----- GET VOLUME
      CELVOL = 0.0
      FV=NUMB_('_cell_volume',CELVOL,SIGVOL)
      if (celvol .le. 1.) then
c       get a rough volume
        cosa = cos(celalp*3.1419/180.)
        cosb = cos(celbet*3.1419/180.)
        cosc = cos(celgam*3.1419/180.)
        celvol = 1-cosa*cosa-cosb*cosb-cosc*cosc+2.*cosa*cosb*cosc
        celvol = cela*celb*celc*sqrt(celvol)
        sigvol = 0.0
        FV = .TRUE.
      ELSE
         WRITE (6,'(A)') 'Cell Volume Found'
      endif
C 
C----- get experiment name
      FN=CHAR_('_chemical_name_common',ENAME)
c
      if (.not. fn) then
            ename=name
            fn = .true.
      endif
C 
C----- WRITE TEXT TO TEXT FILE
      IF (FN) WRITE (NCIF,'(a,a)') '# Text info for ',ENAME
      WRITE (NCIF,'(A,A)') '# On ',CDATE
      F1=CHAR_('_diffrn_measurement_device_type',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_diffrn_measurement_device_type ',
     1C50
      F1=CHAR_('_diffrn_measurement_device',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_diffrn_measurement_device ',C50
      F1=CHAR_('_diffrn_detector_area_resol_mean',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_diffrn_detector_area_resol_mean ',
     1C50
      FMON=CHAR_('_diffrn_radiation_monochromator',CMONO)
      IF (FMON) WRITE (NCIF,'(a,a)') '_diffrn_radiation_monochromator ',
     1CMONO
      F1=CHAR_('_computing_data_collection',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_computing_data_collection ',C50
      F1=CHAR_('_diffrn_measurement_method',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_diffrn_measurement_method ',C50
      F1=CHAR_('_diffrn_orient_matrix_type',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_diffrn_orient_matrix_type ',C50
      F1=CHAR_('_computing_cell_refinement',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_computing_cell_refinement ',C50
      F1=CHAR_('_computing_data_reduction',C50)
      IF (F1) WRITE (NCIF,'(a,a)') '_computing_data_reduction ',C50
C 
cdjw - evade spurious significance possibly introduced by MAKECIF
      siga = .0001*max(1,nint(10000*siga))
      sigb = .0001*max(1,nint(10000*sigb))
      sigc = .0001*max(1,nint(10000*sigc))
      WRITE (6,'(/a,6F10.4)') ' Cell ',CELA,CELB,CELC,CELALP,CELBET,
     1CELGAM
      WRITE (6,'(a,6F10.4/)') '      ',SIGA,SIGB,SIGC,SIGALP,SIGBET,
     1SIGGAM


C....... Extract space group notation (expected char string)
      FSG=CHAR_('_symmetry_space_group_name_H-M',NAME)
      IF (.NOT.(FSG)) THEN
         WRITE (6,'(/a/)') 'No spacegroup found'
         GO TO 1050
      END IF
      WRITE (6,'(a,a,a/)')'Space group  from cif= ',NAME(1:LONG_),'.'
      CSPACE=NAME(1:LONG_)
      call xcrems(name, cspace,lspace)
      i = index(cspace(1:lspace),' ')
      if ((i .le. 0) .or. (cspace(2:2) .ne. ' ' ))then
        write(6,'(a)') 'CRYSTALS needs spaces in symbol'
        fsg = .false.
      endif
      if (cspace(1:lspace) .eq. 'unknown') fsg = .false.
      if (cspace(1:lspace) .eq. '?') fsg = .false.
c
c wavelength
      FW=NUMB_('_diffrn_radiation_wavelength',WAV,DUM)
      IF (.NOT.(FW)) THEN
         WRITE (6,'(/a/)') 'No wavelength '
      ELSE
         WRITE (6,'(A,F10.3)') 'Wavelength Found',wav
         GO TO 100
      END IF
100   CONTINUE
      FF=CHAR_('_chemical_formula',CFORM)
      IF (.NOT.(FF)) THEN
        FF=CHAR_('_chemical_formula_sum',CFORM)
      ENDIF
      IF (.NOT.(FF)) THEN
      FF=CHAR_('_chemical_oxdiff_formula', CFORM)
      ENDIF
      LFORM=LONG_
      IF (.NOT.(FF)) THEN
         WRITE (6,'(/a/)') 'No chemical formula given'
         GO TO 150
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
         WRITE (6,'(/A/)') 'No orient matrix or format error'
         GO TO 200
      END IF
                                                                        
200   CONTINUE
      FT=NUMB_('_cell_measurement_reflns_used',CMRU,DUM)
      FT=NUMB_('_cell_measurement_theta_min',CMTM,DUM).AND.(FT)
      FT=NUMB_('_cell_measurement_theta_max',CMTX,DUM).AND.(FT)
      IF (.NOT.(FT)) THEN
         WRITE (6,'(A)') ' No cell measurement info'
      ELSE
         WRITE (6,'(A)') 'Cell Measurement Data Found'
      END IF

      FSIZ=NUMB_('_exptl_crystal_size_min', ZS,DUM)
      FSIZ=NUMB_('_exptl_crystal_size_mid', ZD,DUM).AND.(FSIZ)
      FSIZ=NUMB_('_exptl_crystal_size_max', ZL,DUM).AND.(FSIZ)
      IF (.NOT.(FSIZ)) THEN
         WRITE (6,'(A)') 'No crystal size info in cif. Please give'
         WRITE (6,'(A)') 
     1   'Smallest, medium and longest dimensions? [0.2]'
         read(5,'(a16)') ctemp
         if (len_trim(ctemp).eq.0) THEN
           zs = 0.2
           zd = 0.2
           zl = 0.2
         else
           READ (ctemp,*,err=201,end=201) ZS, ZD, ZL
         endif
      END IF
      goto 202
201   continue
      read(5,*) zd,zl
202   continue
      WRITE (6,'(A,3f8.3)') 'Crystal Size Found',zs,zd,zl


      FTEMP=NUMB_('_diffrn_ambient_temperature', ZT ,DUM)
      IF (.NOT. FTEMP) THEN
       FTEMP=NUMB_('_cell_measurement_temperature', ZT ,DUM)
      ENDIF
      IF (.NOT. FTEMP) THEN
         WRITE (6,'(A)') 'Temperature (K)? [0]'
         READ (5,'(a16)') ctemp
         if (len_trim(ctemp).eq.0) THEN
            zt = 0.0
         else
            read(ctemp,*) zt
         endif
      ENDIF
      WRITE (6,'(A,f8.2)') 'Temperature Found',zt
c
c
      FCOL=CHAR_('_exptl_crystal_colour', ccol)
      IF (.NOT. FCOL) THEN
       FCOL=CHAR_('_exptl_crystal_colour_primary', CCOL)
      ENDIF
      IF (.NOT. FCOL) THEN
         WRITE (6,'(A)') 'Colour? [Colourless]'
         read(5,'(a16)') ctemp
         if (len_trim(ctemp).eq.0) THEN
           ccol = 'Colourless'
         else      
           READ (ctemp,'(a)') CCOL
         endif
      ENDIF
      call xctrim(ccol,lcol)
      WRITE (6,'(A,3x,a)') 'Crystal Colour Found', ccol(1:lcol)
c
c
c
C....... Read and process the reflections
C 
      MINH=10000
      MINK=10000
      MINL=10000
      MAXH=-10000
      MAXK=-10000
      MAXL=-10000
      NREFS=0

250   NREFS=NREFS+1
      FL6=NUMB_('_refln_index_h',RHR,DUM)
      FL6=NUMB_('_refln_index_k',RKR,DUM).AND.(FL6)
      FL6=NUMB_('_refln_index_l',RLR,DUM).AND.(FL6)
      FL6=NUMB_('_refln_F_squared_meas',RMEAS,DUM).AND.(FL6)
      FL6=NUMB_('_refln_F_squared_sigma',RSIGMA,DUM).AND.(FL6)
      IF (.NOT.(FL6)) THEN
      FL6=NUMB_('_hkl_oxdiff_h',RHR,DUM)
      FL6=NUMB_('_hkl_oxdiff_k',RKR,DUM).AND.(FL6)
      FL6=NUMB_('_hkl_oxdiff_l',RLR,DUM).AND.(FL6)
      FL6=NUMB_('_hkl_oxdiff_FL6',RMEAS,DUM).AND.(FL6)
      FL6=NUMB_('_hkl_oxdiff_sig',RSIGMA,DUM).AND.(FL6)
      ENDIF
      IF (.NOT.(FL6)) THEN
         WRITE (6,'(/a/)') 'Reflections missing or wrong format'
         GO TO 300
      else if ( nrefs .eq. 1) then
        OPEN (NHKL,FILE=chkl, STATUS='UNKNOWN')
        fl6 = .true.
      END IF

      IH=NINT(RHR)
      IK=NINT(RKR)
      IL=NINT(RLR)
      IF (IH.LT.MINH) THEN
         MINH=IH
      ELSE IF (IH.GT.MAXH) THEN
         MAXH=IH
      END IF
      IF (IK.LT.MINK) THEN
         MINK=IK
      ELSE IF (IK.GT.MAXK) THEN
         MAXK=IK
      END IF
      IF (IL.LT.MINL) THEN
         MINL=IL
      ELSE IF (IL.GT.MAXL) THEN
         MAXL=IL
      END IF
      IF (RMEAS.LE.99999.) THEN
         WRITE (NHKL,'(3i4,2f8.2)') IH,IK,IL,RMEAS,RSIGMA
      ELSE IF (RMEAS.LE.999999.) THEN
         WRITE (NHKL,'(3i4,2f8.1)') IH,IK,IL,RMEAS,RSIGMA
      ELSE
         WRITE (NHKL,'(3i4,2f8.0)') IH,IK,IL,RMEAS,RSIGMA
      END IF
      IF (LOOP_) GO TO 250
C           WRITE ( nhkl,'(a)') '-512'
      CLOSE (NHKL)
C 
300   CONTINUE
      FABS=NUMB_('_exptl_absorpt_correction_T_min',atn,DUM)
      FABS=NUMB_('_exptl_absorpt_correction_T_max',atx,DUM).AND.(FABS)
      if (.not. (fABS)) then
       atn=0.
       atx=0.
      ELSE
         WRITE (6,'(A)') 'Absorption Correction Found'
      endif
C
320   continue
C 
c      IDIFF = 0 = UNKNOWN
c      IDIFF = 1 = AGILENT
C      IDIFF = 2 = KCCD
C      IDIFF = 3 = RIGAKU
C      IDIFF = 4 = WINGX
C
c Kccd SG is only Point Group
      if (idiff .eq. 2) fsg = .false.
      if (fsg) then
         call xctrim(cspace,lspace)
         write(6,'(A)') 
     1 'CAUTION - some cifs only contain the Point Group'
         write(6,'(a,a)') 'SG from cif is ', cspace(1:lspace)
         write(6,'(a)') 'Is this correct [yes]'
         read (5,'(A)') ctemp
         if ((ctemp(1:1).eq.'n') .or. (ctemp(1:1).eq.'N')) then
           fsg =.false.
         else
           write(6,'(a,a)') 'Using input space group'
           fsg = .true.
         endif
      endif
c----------------------------------------------------------------
      if (nrefs .gt. 1) then
C----- reflections all read - check space group with Nonius code
       write(6,'(a)') 'Space Group Code provided by Enraf-Nonius'
       if (.not. fsg) then
         i_value=0
	 isa = 0
         isb = 0
	 if (abs(90.-celalp) .le. .001) isa=isa+1
	 if (abs(90.-celbet) .le. .001) isa=isa+1
	 if (abs(90.-celgam) .le. .001) isa=isa+1

	 if (abs(cela-celb) .le. (siga+sigb)) isb=isb+1
	 if (abs(cela-celc) .le. (siga+sigc)) isb=isb+1
	 if (abs(celc-celb) .le. (sigc+sigb)) isb=isb+1
	 write(6,*) isa, isb
	 if (isb .le. 0) then
		if(isa .eq. 0) isa=1
             i_value=isa
	endif
	 write(6,*)filename(1:lfn)//'.hkl', I_value
         if (i_value .eq. 0)       WRITE(6,555)
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
            write(6,556)
            READ (5,556) I_VALUE
        endif
557     format(/,' give space group type number :',/)
556     FORMAT (I5)
	write(6,*)filename(1:lfn)//'.hkl', I_value
c----------------------------------------------------------------
        ctemp = ' '
        call sgroup(filename(1:lfn)//'.hkl', i_value,cspace)
        call xctrim(cspace,lspace)
        if (cspace(2:2) .ne. ' ') then
            do i=lspace,2,-1
              cspace(i+1:i+1) = cspace(i:i)
            enddo
            cspace(2:2) = ' '
            lspace = lspace + 1
        endif
        WRITE (6,'(A,a,a)') 'Input space group symbol',
     1 ' with spaces between the components',
     2 ' e.g. P n a 21'
        write(6,'(a)') 'For monoclinic systems, input the full symbol'
        write(6,'(a,a,a)')' Suggested SG is [',cspace(1:lspace),']'
        read (5,'(a)') ctemp
        if (ctemp(1:3) .ne. '   ') then
         callxctrim(ctemp,ltemp)
         cspace = ctemp(1:ltemp)
        endif
        fsg = .true.
       endif
      endif
C 
C 
c
c
c
C....... Read and store the atom site data
C....... =================================

      nsite = 0
240   nsite = nsite+1
      f1 = char_('_atom_site_label', label(nsite,1))
      if(.not.(f1)) then
        write(6,'(/a/)')   'No atom_site_label found'
        nsite=nsite-1
        goto 241
      endif
          
C....... pull apart the site label into element and number
      call xcras(label(nsite,1),llabel)
c     find first number
      ii = 0
      do i = 1,llabel
        j = index(numer,label(nsite,1)(i:i))
        if (j .ne. 0) exit
        ii = i
      enddo
      if (ii .eq. 0) then
c       no proper label
        label(nsite,2) = 'temp'
      else
        label(nsite,2) = label(nsite,1)(1:ii)
      endif

c     find end of numbers
      kk = ii + 1      
      do i = ii+1, llabel
        k = index(numer,label(nsite,1)(i:i))
        if (k .eq. 0) exit
        kk = i
      enddo
      if (label(nsite,1)(kk:).eq.' ') then
c        no proper number
         label(nsite,3) = ' 1'
      else
         label(nsite,3) = label(nsite,1)(ii+1:kk)
      endif

      f2 = numb_('_atom_site_fract_x',  xf(nsite), sx)
      f2 = numb_('_atom_site_fract_y',  yf(nsite), sy).AND.(f2)
      f2 = numb_('_atom_site_fract_z',  zf(nsite), sz).AND.(f2)
      if(.not.(f2)) then
         write(6,'(/a/)')'atom_site_fract_ missing'
      endif
         
      f2 = numb_('_atom_site_occupancy', occ(nsite), su)
      if (.not. (f2)) occ(nsite) = 1
                 
C         
C........Check if there are more atoms in the loop to get.

      if(loop_) goto 240
241   continue


700   CONTINUE
      write(6,*) nsite, ' Atoms found'
c
C 
C-----------------------------------------------------------------------
C-----  WRITE THE CRYSTALS FILES
C      FC, FV, FN, FF, FT, FW, FSG
C 
      IF (FN) WRITE (NOUTF,'(a,2X,A,2x,a)') '#TITLE ',ENAME,CDATE
      IF (FC) THEN
C -CELL
         WRITE (NOUTF,'(a)') '#LIST 1'
         WRITE (NOUTF,'(a,6F11.4)') 'REAL',CELA,CELB,CELC,CELALP,CELBET,
     1    CELGAM
         WRITE (NOUTF,'(a)') 'END'
C 
C            scale the variances
c         AMULT=.00001
         AMULT=.0000001
         SIGA=SIGA*SIGA/AMULT
         SIGB=SIGB*SIGB/AMULT
         SIGC=SIGC*SIGC/AMULT
         SIGALP=SIGALP*SIGALP*DTR*DTR/AMULT
         SIGBET=SIGBET*SIGBET*DTR*DTR/AMULT
         SIGGAM=SIGGAM*SIGGAM*DTR*DTR/AMULT
         WRITE (NOUTF,'(a)') '#LIST 31'
         WRITE (NOUTF,'(a,F11.8)') 'AMULT ',AMULT
         WRITE (NOUTF,'(2(3(a,F13.6,1x),/),a)') 'MATRIX   V(11)=',SIGA,'
     1V(22)=',SIGB,'V(33)=',SIGC,'CONTINUE V(44)=',SIGALP,'V(55)=',
     2    SIGBET,'V(66)=',SIGGAM,'END'
      END IF
C 
C -SG
C 
      IF (FSG) THEN
         WRITE (NOUTF,'(a)') '#SPACEGROUP'
         WRITE (NOUTF,'(2a)') 'SYMBOL ',CSPACE
         WRITE (NOUTF,'(a)') 'END'
      ELSE
         WRITE (NOUTF,'(A)') '#SCRIPT XSPACE'
      END IF
C 
C WAVELENGTH
      IF (FW) THEN
       if(wav .ge.1.) then
c       copper
        th1=13.0
        th2=0.
       else
c      moly
        th1=6.
        th2=0.
       endif
       IF (FMON)THEN
        I = INDEX(CMONO,'mirror')
        if (i .ne. 0) then
          th1=0.
          th2=0.
        endif
       ENDIF
         WRITE (NOUTF,'(a)') '#LIST 13'
         WRITE (NOUTF,'(a)') '# set theta 1 and 2 to zero for mirrors'
         WRITE (NOUTF,'(a,f8.5,a,f8.5,a,f8.5)') 
     1'CONDITIONS WAVELENGTH = ',WAV,' theta(1)=', th1, ' theta(2)=',
     2 th2
         WRITE (NOUTF,'(a)') 'END'
      END IF
C 
C -FORMULA
C 
C(FF)
      IF (FF) THEN
cdjw Insert space if character immediately follows a number
c    beware if the element type is a charged species like Om2
c
        call fixform(line,cform,lenfil,atsum,celvol,zm,zp)
c
c
c
         call xctrim(cform,lenfil)
         write(6,'(a,a)') 'Formula ',cform(1:lenfil)
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
      IF (.NOT.(FT)) THEN
       if (cmru .le. 0.0) then
         WRITE (6,'(A)') 'How many cell measurement reflns used? '
         READ (5,*) CMRU
       endif
       if (cmtm .le. 0.0) then
         WRITE (6,'(A)') 'Cell measurement theta min? '
         READ (5,*) CMTM
       endif
       if (cmtx .le. 0.0) then
         WRITE (6,'(A)') 'Cell measurement theta max? '
         READ (5,*) CMTX
       endif
      END IF
C

C----- WRITING LIST 30
         WRITE (NOUTF,'(a)') '#LIST 30'
         WRITE (NOUTF,'(a,a)') 'DATRED REDUCTION= ', creduct
         WRITE (NOUTF,'(a)') 'ABSORPTION ABSTYPE=multi-scan'
         WRITE (NOUTF,'(a,f8.3)') 'cont empmin=',atn
         WRITE (NOUTF,'(a,f8.3)') 'cont empmax=',atx
         WRITE (NOUTF,'(a)') 'CONDITION'
         WRITE (NOUTF,'(a,f8.3)') 'cont minsiz=',ZS
         WRITE (NOUTF,'(a,f8.3)') 'cont medsiz=',ZD
         WRITE (NOUTF,'(a,f8.3)') 'cont maxsiz=',ZL
         WRITE (NOUTF,'(a,f8.3)') 'cont temperature=',ZT
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmin=',CMTM
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmax=',CMTX
         WRITE (NOUTF,'(a,i7)') 'cont norient=',NINT(CMRU)
         WRITE (NOUTF,'(a)') 'cont scanmode=omega'
         WRITE (NOUTF,'(a,a)') 'cont instrument= ', cinst
         WRITE (NOUTF,'(a)') 'GENERAL'
         WRITE (NOUTF,'(a,f7.1)') 'cont z=',ZM
         WRITE (NOUTF,'(a,a)') 'COLOUR ',CCOL
C 
         IF (ZL/ZS.LT.1.5) THEN
            WRITE (CSPACE,'(a)') 'block'
         ELSE IF (ZL/ZD.GT.ZD/ZS) THEN
            WRITE (CSPACE,'(a)') 'prism'
         ELSE
            WRITE (CSPACE,'(a)') 'plate'
         END IF
         WRITE (NOUTF,'(a,a)') '# shape ',CSPACE

      if (ZS .le. .5*ZD) then
        if (ZD .le. .5*ZL) then
            WRITE (CSPACE,'(a)')'lath'
        else
            WRITE (CSPACE,'(a)')'plate'
        endif
      else
        if (ZD .le. .5*ZL) then
           WRITE (CSPACE,'(a)')'prism'
        else
            WRITE (CSPACE,'(a)')'block'
        endif
      endif
c
         WRITE (NOUTF,'(a,a)') 'shape ',CSPACE
C 
         WRITE (NOUTF,'(a)') 'INDEXRAN'
         WRITE (NOUTF,'(a,i7)') 'cont hmin=',MINH
         WRITE (NOUTF,'(a,i7)') 'cont hmax=',MAXH
         WRITE (NOUTF,'(a,i7)') 'cont kmin=',MINK
         WRITE (NOUTF,'(a,i7)') 'cont kmax=',MAXK
         WRITE (NOUTF,'(a,i7)') 'cont lmin=',MINL
         WRITE (NOUTF,'(a,i7)') 'cont lmax=',MAXL
         WRITE (NOUTF,'(a,i7)') 'END'
c
c
c  write out atoms
C 
c--------------------------------------------------------------
c      output list 5
c
      if ( nsite .gt. 0 ) then
        write(NOUTF,'(a)') '#LIST 5'
        write(NOUTF,'(a)') 'OVERALL 1 0.05 0.05 0 0 0'
        write(NOUTF,'(a,i4,x,a)') 'READ NATOM = ',nsite,
     *      'NLAYER = 0 NELEMENT = 0 NBATCH = 0 '

        do i=1,nsite
          write(NOUTF,'(3(a,1x),f11.6,i4,3f11.6,14X,2a4)')
     *    'ATOM',label(i,2)(1:6),
     *    label(i,3)(1:6),occ(i),1,xf(i),yf(i),zf(i),label(i,1)
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
1050  CONTINUE
      STOP
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
      SUBROUTINE FIXFORM (LINE,CFORM,LENFIL, sum, celvol, zm,zp)
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
      CHARACTER*50 C50
      CHARACTER*80 C80
      CHARACTER*160 c160, CLONG
      DATA alpha    /'abcdefghijklmnopqrstuvwxyz'/
      DATA ualpha   /'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
      DATA numer/'1234567890.'/
      DATA LATOM/4/
      DATA LARG/12/

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
c      sepatated by space 1 space.
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
               else 
c                 both same case - insert a sp 1 sp between them
                  cform(k:k+2) = ' 1 '
                  cform(k+3:k+3) = line(j:j)
                  k = k + 4
                  lspace = .false.
                  lchar = .true.
                  lnumer = .false.
               endif
             endif        
           endif      
        endif              
      enddo
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
         WRITE (6,'(a,i4,a,f8.2,a)') 
     1 'Z estimated from cell volume and composition is' 
     2  ,nint(zn),' (actually ',zn,')'
         WRITE(6,'(a,f8.2)') 'Z from cif is ', zp
c
          WRITE (6,'(a,i4,a)') 'Please give Z [',
     1    nint(zn),']'
          read (5,'(A)') ctemp
          if (len_trim(ctemp).ne.0) THEN
               read (ctemp,*,err=750) zp
               write(6,'(a,f6.2)') 'Using Z = ', zp
          else
               zp = float(nint(zn))
               write(6,'(a,f6.2)') 'Using Z = ', zp
          endif
750    continue
       zm=zp
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
C=======================================================================
#include "xgroup.for"
#include "charact.for"
#include "ciftbx.for"
C=======================================================================
