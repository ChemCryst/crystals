      PROGRAM NEWK
#if defined(CRY_FORTDIGITAL)
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

c try to restore v 1.8, May 2010
#include "ciftbx.cmn"
      LOGICAL F1,F2,F3,F4,F5
      LOGICAL FC,FV,FN,FF,FT,FW,FSG,FL6,FMON
      logical lnum, lchar
      CHARACTER*4 CATOM
      CHARACTER*8 CARG
      CHARACTER*24 CDATE
      CHARACTER*14 CSPACE,CTEMP,CMONO
      CHARACTER*32 C32,NAME,ENAME
      CHARACTER*50 C50
      CHARACTER*80 C80,LINE,SLINE,CFORM
      CHARACTER*160 CLONG
      CHARACTER*6 LABEL(1000,3)
C         CHARACTER*26  alpha
      CHARACTER*10 NUMER
      character*132 filename
      REAL CELA,CELB,CELC,SIGA,SIGB,SIGC
      REAL CELALP,CELBET,CELGAM,SIGALP,SIGBET,SIGGAM
      REAL X,Y,Z,U,SX,SY,SZ,SU
      REAL NUMB,SDEV,DUM
      REAL UISOEQ(1000)
      REAL XF(1000),YF(1000),ZF(1000),UIJ(1000,6)
      INTEGER I,J,NSITE
C         DATA alpha    /'abcdefghijklmnopqrstuvwxyz'/
      DATA NUMER/'1234567890'/
      DATA NOUTF/10/,NHKL/11/,NCIF/12/
C 
      PARAMETER (DTR=3.14159/180.)
      EQUIVALENCE (RES,IRES)

      DATA NOUTF/10/,NHKL/11/,NCIF/12/

      call no_stdout_buffer()

C set default output filename - also used as instrument ID
	filename='kccd'
        lfn = 4 
C----- GET DATE

      I=IGDAT(CDATE)
C 
C....... Open our files for writing
      OPEN (NOUTF,FILE='kccd.ins',STATUS='UNKNOWN')
      OPEN (NHKL,FILE=filename(1:lfn)//'.hkl', STATUS='UNKNOWN')
      OPEN (NCIF,FILE='kccd.cif',STATUS='UNKNOWN')
C 
C....... Call the CIFTBX code to INITialise read/WRITE units
      F1=INIT_(1,2,3,6)
      write(6,'(/a/)')' Version Feb 2011'
C 
C....... Open the cif file for input
      NAME='import.cif'
105   continue
      WRITE (6,'(/2a/)') ' Read DATA from Cif  ',NAME
      IF (.NOT.(OPEN_(NAME))) THEN
         WRITE (6,'(A,A///)') Name, ' does not exist'
         write(6,'(a)') 'Filename for Kccd cif file?'
         read(5,'(a)') name
         if (name .eq. ' ') NAME='import.cif'
         GO TO 105
      END IF
C 
C 
C....... Assign the DATA block to be accessed
C 
50    IF (.NOT.(DATA_(' '))) THEN
         WRITE (6,'(/a/)') ' >>>>> No DATA_ statement found'
         GO TO 1050
      END IF
C 
      WRITE (6,'(/a,a/)') ' Accessing items in DATA block  ',BLOC_
C 
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
         WRITE (6,'(a)') '>>>>> No cell DATA in this block.'
         WRITE (6,'(a)') '>>>>> Trying next block.'
         GO TO 50
      END IF
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
C----- GET VOLUME
      CELVOL = 0.0
      FV=NUMB_('_cell_volume',CELVOL,SIGVOL)
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
         WRITE (6,'(/a/)') ' >>>>> No spacegroup found'
         GO TO 1050
      END IF
      WRITE (6,'(a,a,a/)')'Space group  from cif= ',NAME(1:LONG_),'.'
      CSPACE=NAME(1:LONG_)
      i = index(cspace(1:long_),' ')
      if (i .le. 0) then
        write(6,'(a)') 'CRYSTALS needs spaces in symbol'
        fsg = .false.
      endif
c
c wavelength
      FW=NUMB_('_diffrn_radiation_wavelength',WAV,DUM)
      IF (.NOT.(FW)) THEN
         WRITE (6,'(/a/)') ' >>>>> No wavelength '
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
      write(6,'(a)') cform
      IF (.NOT.(FF)) THEN
         WRITE (6,'(/a/)') ' >>>>> No chemical formula given'
         GO TO 150
      END IF
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
         WRITE (6,'(/A/)') ' >>>>> No orient matrix or format error'
         GO TO 200
      END IF
                                                                        
200   CONTINUE
      FT=NUMB_('_cell_measurement_reflns_used',CMRU,DUM)
      FT=NUMB_('_cell_measurement_theta_min',CMTM,DUM).AND.(FT)
      FT=NUMB_('_cell_measurement_theta_max',CMTX,DUM).AND.(FT)
      IF (.NOT.(FT)) THEN
         WRITE (6,'(A)') ' No cell measurement info'
      END IF
C....... Read and process the refletions
C 
      MINH=10000
      MINK=10000
      MINL=10000
      MAXH=-10000
      MAXK=-10000
      MAXL=-10000
      NREFS=0
250   NREFS=NREFS+1
      F2=NUMB_('_refln_index_h',RHR,DUM)
      F2=NUMB_('_refln_index_k',RKR,DUM).AND.(F2)
      F2=NUMB_('_refln_index_l',RLR,DUM).AND.(F2)
      F2=NUMB_('_refln_F_squared_meas',RMEAS,DUM).AND.(F2)
      F2=NUMB_('_refln_F_squared_sigma',RSIGMA,DUM).AND.(F2)
      IF (.NOT.(F2)) THEN
      F2=NUMB_('_hkl_oxdiff_h',RHR,DUM)
      F2=NUMB_('_hkl_oxdiff_k',RKR,DUM).AND.(F2)
      F2=NUMB_('_hkl_oxdiff_l',RLR,DUM).AND.(F2)
      F2=NUMB_('_hkl_oxdiff_f2',RMEAS,DUM).AND.(F2)
      F2=NUMB_('_hkl_oxdiff_sig',RSIGMA,DUM).AND.(F2)
      ENDIF
      IF (.NOT.(F2)) THEN
         WRITE (6,'(/a/)') ' >>>>> reflections missing or wrong format'
         GO TO 300
      END IF
      IF (NREFS.EQ.1) FL6=.TRUE.
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
      F2=NUMB_('_exptl_absorpt_correction_T_min',atn,DUM)
      F2=NUMB_('_exptl_absorpt_correction_T_max',atx,DUM).AND.(F2)
      if (.not. (f2)) then
       atn=0.
       atx=0.
      endif
C
320   continue
c Kccd SG is only Point Group
      if(filename(1:4).eq.'kccd') fsg = .false.
      if ((.not. fsg) .and. (nrefs .gt. 1)) then
C----- reflections all read - check space group with Nonius code
      write(6,'(a)') 'Space Group Code provided by Enraf-Nonius'
c----------------------------------------------------------------
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
557   format(/,' give space group type number :',/)
556   FORMAT (I5)
	write(6,*)filename(1:lfn)//'.hkl', I_value
c----------------------------------------------------------------

      CALL SGROUP(filename(1:lfn)//'.hkl', i_value)
      WRITE (6,'(A,a,a)') 'Input space group symbol',
     1 ' with spaces between the components',
     2 ' e.g. P n a 21'
      write(6,'(a)') 'For monoclinic systems, input the full symbol'
      READ (5,'(a)') CSPACE
      fsg = .true.
      endif
C 
C 
C....... Read and store the atom site DATA from other DATA block
C 
      NSITE=0
350   NSITE=NSITE+1
      F1=CHAR_('_atom_site_LABEL',LABEL(NSITE,1))
      IF (.NOT.(F1)) THEN
         GO TO 700
      END IF
C....... pull apart the site LABEL into element and NUMBer
      IELLEN=2
      DO 400 I=1,10
         IF (NUMER(I:I).EQ.LABEL(NSITE,1)(2:2)) IELLEN=1
400   CONTINUE
      LABEL(NSITE,2)=LABEL(NSITE,1)(1:IELLEN)
      DO 500 J=3,6
         F5=.FALSE.
         DO 450 I=1,10
            IF (NUMER(I:I).EQ.LABEL(NSITE,1)(J:J)) F5=.TRUE.
450      CONTINUE
         IF (.NOT.(F5)) GO TO 550
500   CONTINUE
550   LABEL(NSITE,3)=LABEL(NSITE,1)(IELLEN+1:J-1)
      F2=NUMB_('_atom_site_fract_x',XF(NSITE),SX)
      F2=NUMB_('_atom_site_fract_y',YF(NSITE),SY).AND.(F2)
      F2=NUMB_('_atom_site_fract_z',ZF(NSITE),SZ).AND.(F2)
      IF (.NOT.(F2)) THEN
         WRITE (6,'(/a/)') ' >>>>> atom_site_fract_ missing'
         GO TO 1050
      END IF
      DO 600 I=1,6
600      UIJ(NSITE,I)=0.0
      IF (LOOP_) GO TO 350
C 
C 
      WRITE (NOUTF,'(a)') '#LIST 5'
      WRITE (NOUTF,'(a,i4,a)') 'READ NATOM = ',NSITE,', NLAYER = 0, NELE
     1MENT = 0, NBATCH = 0'
      WRITE (NOUTF,'(a)') '# Random values for scale...'
      WRITE (NOUTF,'(a)') 'OVERALL 1 0.5 0.5 1 0 1'
      DO 650 I=1,NSITE
C Occ for now
         ROCC=1.0
         WRITE (NOUTF,'(3(a,1x),5F11.6)') 'ATOM',LABEL(I,2),LABEL(I,3),
     1    ROCC,UISOEQ(I),XF(I),YF(I),ZF(I)
         WRITE (NOUTF,'(a,6F11.6)') 'CON U[11]= ',(UIJ(I,J),J=1,6)
         IF (UIJ(I,1).GT.0.0001) THEN
            WRITE (6,'(1x,a,9f8.4)') LABEL(I,1),XF(I),YF(I),ZF(I),
     1       (UIJ(I,J),J=1,6)
         ELSE
            WRITE (6,'(1x,a,3f8.4)') LABEL(I,1),XF(I),YF(I),ZF(I)
         END IF
650   CONTINUE
      WRITE (NOUTF,'(a)') 'END'
700   CONTINUE
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
         WRITE (NOUTF,'(a)') '# theta 1 and 2 set to zero for mirrors'
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
c$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
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


c$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
      END IF
cC 
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
         WRITE (6,'(A)') 'Smallest, medium and longest dimensions? '
         READ (5,*) ZS, ZD, ZL
         WRITE (6,'(A)') 'Temperature (K)? '
         READ (5,*) Z
         WRITE (NOUTF,'(a)') '#LIST 30'
         WRITE (NOUTF,'(a)') 'DATRED REDUCTION=DENZO'
         WRITE (NOUTF,'(a)') 'ABSORPTION ABSTYPE=MULTI-SCAN'
         WRITE (NOUTF,'(a)') 'CONDITION'
         WRITE (NOUTF,'(a,f8.3)') 'cont minsiz=',ZS
         WRITE (NOUTF,'(a,f8.3)') 'cont medsiz=',ZD
         WRITE (NOUTF,'(a,f8.3)') 'cont maxsiz=',ZL
         WRITE (NOUTF,'(a,f8.3)') 'cont temperature=',Z
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmin=',CMTM
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmax=',CMTX
         WRITE (NOUTF,'(a,i7)') 'cont norient=',NINT(CMRU)
         WRITE (NOUTF,'(a)') 'cont scanmode=omega'
         WRITE (NOUTF,'(a)') 'cont instrument=Kappaccd'
         WRITE (NOUTF,'(a)') 'GENERAL'
         WRITE (NOUTF,'(a,f7.1)') 'cont z=',ZM
         WRITE (6,'(A)') 'Colour? '
         READ (5,'(a)') CSPACE
         WRITE (NOUTF,'(a,a)') 'COLOUR ',CSPACE
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
C- LIST 6
      GOTO 1050
      IF (FL6) THEN
         WRITE (NOUTF,'(a)') '#OPEN HKLI kccd.hkl'
         WRITE (NOUTF,'(a)') '#LIST 6'
         WRITE (NOUTF,'(a)') 'READ F''S=FSQ UNIT=HKLI'
         WRITE (NOUTF,'(a)') 'END'
      END IF
         WRITE (NOUTF,'(a)') '#syst'
         WRITE (NOUTF,'(a)') 'END'
         WRITE (NOUTF,'(a)') '#sort'
         WRITE (NOUTF,'(a)') 'END'
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
      CHARACTER*160 CLONG
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


