      PROGRAM READOD
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
      
c restored v 14 from cvs
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

      call no_stdout_buffer()
C set default output filename - also used as instrument ID
	filename='od-out'
        lfn=6 
C----- GET DATE

      I=IGDAT(CDATE)
C 
C....... Open our files for writing
      OPEN (NOUTF,FILE='od-out.ins',STATUS='UNKNOWN')
      OPEN (NHKL,FILE=filename(1:lfn)//'.hkl', STATUS='UNKNOWN')
      OPEN (NCIF,FILE='od-out.cif',STATUS='UNKNOWN')
C 
C....... Call the CIFTBX code to INITialise read/WRITE units
      F1=INIT_(1,2,3,6)

      write(6,'(/a/)')' Version Feb 2011'
C 
C....... Open the cif file for input
      NAME='od-import.cif'
105   continue
      WRITE (6,'(/2a/)') ' Read DATA from Cif  ',NAME
      IF (.NOT.(OPEN_(NAME))) THEN
         WRITE (6,'(A,A///)') Name, ' does not exist'
         write(6,'(a)') 'Filename for Agilent cif file?'
         read(5,'(a)') name
         if (name .eq. ' ') NAME='od-import.cif'
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
557    format(/,' give space group type number :',/)
556    FORMAT (I5)
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
        call xcras (cform,lenfil)
        line(1:lenfil) = cform(1:lenfil)
        cform = ' '
        lnum = .false.
        lchar = .false.
        k = 1
        do j = 1,lenfil
          i = index(numer,line(j:j))
          if (i .gt. 0) then
c             found a number
              if (lnum .eq. .false.) then
                cform(k:k) =' '
                k = k+1
                lnum = .true.
                lchar = .false.
              endif
          else
c             must be a character
              if (lchar .eq. .false.) then
                cform(k:k) =' '
                k = k+1
                lchar = .true.
                lnum = .false.
              endif
          endif
          cform(k:k) = line(j:j)
          k = k + 1
        enddo
        call xcrems (cform,line,lenfil)
      write(6,*) 'Formula', line(1:lenfil),'.'
cdjw

         i = 80
         cform = ' '
         lnum = .false.
         do 1234 j = lenfil,1,-1
            k = index(numer,line(j:j))
            if (k .gt. 0) then
             cform(i:i) = line(j:j)
             i = i-1
             lnum = .true.
            else
             if (.not. lnum) then
               cform(i:i) = line(j:j)
               i = i-1
             else          
               i = i-1
               cform(i:i) =line(j:j)
               i = i-1
             endif
             lnum = .false.
            endif
1234  continue
         CALL XCREMS (CFORM,c80,LENFIL)
         k = index(c80(2:lenfil), ' ')
         i = index(c80(k+2:lenfil), ' ')
         do 749 j = 2,i+k+1
         c80(j-1:j-1) = c80(j:j)
749      continue
         CALL XCREMS (C80,LINE,LENFIL)
         zm = 1.
         zp = 0.
750      continue
         LLONG=1
         ATSUM=0.
         IST=1
         catom = ' '
         res = 0.0
800      continue
         if (ist.ge.lenfil) go to 1000
         iend=index(line(ist:lenfil),' ')
         if (iend.le.0) then
            iend=lenfil
         else
            iend=iend+ist-1
         end if
         carg = line(ist:iend)
         ist = iend + 1
c----- check there is an argument value
         if (carg .eq. ' ') then
           goto 1000
         endif
c----- remove all spaces
         call xcras (carg, larg)
c---- check if starts with a number
         k=index(numer,carg(1:1))
         if (k .le. 0) then
C-----  no numbers found -  must be name
           if (catom .ne. ' ') then
810          format(1x,a4,1x,f10.2)
             write(c32 ,810) catom, res      
             call xcrems (c32, ctemp, ltemp)
             clong(llong:) = ctemp(1:ltemp)
             llong = llong + ltemp
             if ((catom .ne.'h   ').and.(catom.ne.'H   ')) 
     1       atsum=atsum+res
           endif
           catom = carg(1:4)
           res = 1.*zm
         else
c----- start with a number
          itemp = kccnum(carg, ires, itype)
          if (itype .eq. 1) res = float(ires)
          res = res * zm
c----- dump if no atom name stored
          if (catom .eq. ' ') goto 800
             write(c32 ,810) catom, res      
             call xcrems (c32, ctemp, ltemp)
             clong(llong:) = ctemp(1:ltemp)
             llong = llong + ltemp
          if ((catom .ne.'h   ').and.(catom.ne.'H   ')) 
     1    atsum=atsum+res
          catom = ' '
          res = 0.0
         endif
         go to 800
1000     CONTINUE
           if (catom .ne. ' ') then
             write(c32 ,810) catom, res      
             call xcrems (c32, ctemp, ltemp)
             clong(llong:) = ctemp(1:ltemp)
             llong = llong + ltemp
             if ((catom .ne.'h   ').and.(catom.ne.'H   ')) 
     1       atsum=atsum+res
           endif
C 
         write(6,'(a,a)') 'Formula ',clong(1:llong-1)
         if (celvol .gt. .01) then
          zn=(CELVOL*zm )/(ATSUM*19.)
         else
          zn = 1.0
         endif
         WRITE (6,'(a,i4,a,f8.2,a)') 
     1 '  Z estimated from cell volume and composition is' 
     2  ,nint(zn),' (actually ',zn,')'
         if(zp .lt. .01) then
          WRITE (6,'(a,i4,a)') ' Please give Z [',
     1    nint(zn),']'
          read (5,'(A)') catom
          if (len_trim(catom).ne.0) THEN
               read (catom,*,err=750) zp
               write(6,'(a,f6.2)') 'Using Z = ', zp
          else
               zp = float(nint(zn))
               write(6,'(a,f6.2)') 'Using Z = ', zp
          endif
          if (abs(zm-zp) .gt. 0.1) then
            zm=zp
            goto 750
          endif
         endif
c
         WRITE (NOUTF,'(a)') '#COMPOSITION'
         WRITE (NOUTF,'(a,a)') 'content ',CLONG(1:LLONG-1)
         WRITE (NOUTF,'(a)') 'SCATTERING CRYSDIR:script/scatt.dat'
         WRITE (NOUTF,'(a)') 'PROPERTIES CRYSDIR:script/propwin.dat'
         WRITE (NOUTF,'(a)') 'END'
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
         WRITE (NOUTF,'(a)') 'DATRED REDUCTION=CrysAlis'
         WRITE (NOUTF,'(a)') 'ABSORPTION ABSTYPE=multi-scan'
         WRITE (NOUTF,'(a,f8.3)') 'cont empmin=',atn
         WRITE (NOUTF,'(a,f8.3)') 'cont empmax=',atx
         WRITE (NOUTF,'(a)') 'CONDITION'
         WRITE (NOUTF,'(a,f8.3)') 'cont minsiz=',ZS
         WRITE (NOUTF,'(a,f8.3)') 'cont medsiz=',ZD
         WRITE (NOUTF,'(a,f8.3)') 'cont maxsiz=',ZL
         WRITE (NOUTF,'(a,f8.3)') 'cont temperature=',Z
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmin=',CMTM
         WRITE (NOUTF,'(a,f7.2)') 'cont thorientmax=',CMTX
         WRITE (NOUTF,'(a,i7)') 'cont norient=',NINT(CMRU)
         WRITE (NOUTF,'(a)') 'cont scanmode=omega'
         WRITE (NOUTF,'(a)') 'cont instrument=SuperNova'
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
         WRITE (NOUTF,'(a)') '#OPEN HKLI od-out.hkl'
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
C=======================================================================
#include "xgroup.for"
#include "charact.for"
#include "ciftbx.for"
C=======================================================================
