!$Rev::                                      $:  Revision of last commit
!$Author::                                   $:  Author of last commit
!$Date::                                     $:  Date of last commit

!CODE FOR XSFLSB
subroutine XSFLSB (MODE, ITYP06)
!--MAIN CONTROL ROUTINE FOR THE S.F.L.S. ROUTINES
!
!--
!      if MODE EQ -1, DON'T READ DATA STREAM, USE I/u(I)>2 if no value
!                                             in L28.
!      if MODE EQ 0,  DON'T READ DATA STREAM, USE EXISTING L33 THRESHOLD
!      if MODE EQ 1, READ DATA STREAM
!
!      ITYP06 - LIST TYPE INDICATOR. 1=6, 2=7
!
!
!include 'STORE.INC'
use store_mod, only:store, istore, nfl
!include 'XLISTI.INC'
use xlisti_mod, only: irec, lef, ln
!include 'XUNITS.INC90'
use xunits_mod, only: ierflg, ncawu, NCFPU1, ncvdu, NCFPU2, ncwu
!include 'XSSVAL.INC90'
use xssval_mod, only:issprt
!include 'XUSLST.INC'
use xuslst_mod, only: ln5
!include 'XLST01.INC90'
use xlst01_mod, only: l1c
!include 'XLST02.INC90'
use xlst02_mod, only: n2, n2t, n2i, md2, md2i, m2, m2i, l2, l2i, ic
!include 'XLST03.INC90'
use xlst03_mod, only: n3, md3, m3, l3
!include 'XLST05.INC90'
use xlst05_mod, only: n5, md5es, md5, m5es, m5, l5o, l5es, l5
!include 'XLST06.INC90'
use xlst06_mod, only: n6w, md6dtl, l6p, l6dtl
!include 'XLST11.INC90'
use xlst11_mod, only: n11r, m11r, l11r, l11p
!include 'XSTR11.INC'
use xstr11_mod, only: str11=>xstr11
!include 'XLST12.INC90'
use xlst12_mod, only: n12
!include 'XLST13.INC90'
use xlst13_mod, only: l13dt, l13dc, l13cd
!include 'XLST22.INC90'
use xlst22_mod, only: n22, md22, l22
!include 'XLST23.INC90'
use xlst23_mod, only: l23sp, l23mn, l23ac, l23m
!include 'XLST28.INC90'
use xlst28_mod, only:l28cn, n28mn, md28mn, md28cn, m28mn, l28mn
!include 'XLST25.INC'
use xlst25_mod, only: n25
!include 'XLST30.INC90'
use xlst30_mod !, only: l30rf, l30ix, l30dr, l30cf, idim30, icom30 (everything is passed to a subroutine)
!include 'XLST33.INC90'
use xlst33_mod !, only: m33v, m33cd (everything is passed to a subroutine)
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XOPVAL.INC90'
use xopval_mod, only: iopsfs, iopend
!include 'XSFWK.INC90'
use xsfwk_mod, only: rall, wdft, wave, theta1, theta2, smin, smax, r, scale, rw, a, aminf
!include 'XMTLAB.INC'
use xmtlab_mod, only: matlab
!include 'XWORKB.INC'
use xworkb_mod!, only: nd, nf, ni, nl, nm, nr, nu, nt, nv, nn, jo, jq, ji, jq, jp, jn, jr
!include 'XSFLSW.INC90'
use xsflsw_mod, only: wsfofc, wsfcfc, sfofc, sfcfc, twinned, sfls_type, sfls_calc, batched
use xsflsw_mod, only: sfls_refine, sfls_scale, scaled_fot, refprint, partials, newlhs, enantio
use xsflsw_mod, only: layered, iso_only, extinct, anomal
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
use xconst_mod, only: nowt, rtd, uiso, zero

implicit none

!include 'TYPE11.INC' ! merged in xstr11.inc.F90
!include 'ISTORE.INC' ! merged in store.inc.f90
!include 'ICOM30.INC' ! merged in xlst30.inc.F90
!include 'ICOM33.INC' ! merged in xlst33.inc.F90


!include 'QSTORE.INC' ! merged in store.inc.f90 
!include 'QLST33.INC' ! merged in xlst33.inc.F90 ! equivalence removed
!include 'QSTR11.INC' ! merged in xstr11.inc.F90 ! equivalence removed
!include 'QLST30.INC' ! merged in xlst30.inc.F90 ! equivalence removed

integer, dimension(idim33) :: icom33
integer, dimension(idim30) :: icom30
!
!
!
character, dimension(4,2), parameter :: &
&   JFRN=reshape( (/ 'F', 'R', 'N', '1', 'F', 'R', 'N', '2' /), (/4,2/) )
!
!
character(len=12) :: CTEMP
!
!----- V 810 includeS THE SPECIAL SHAPES
integer, parameter :: IVERSN=811
integer PARAM_LIST_MAKE

integer, intent(in) :: MODE
integer, intent(inout) :: ityp06

integer iupdat, iuln, istat2, istat, iresults, irefls, indnam
integer lstop, lstno, j, k, l, nneg, nj, n6temp, n
integer mgm, ny, nupdat, num, nresults, m, ljs, ilev
integer igstat, iclass, iaddu, iaddr, iaddl, iaddd, i
integer idir
real umin, u, stoler, s6sig, rscle, foav, fcav, elesum, elescl
real delfofc, cycno, wscle

integer, external :: krddpv, kset52, kchnfl, ktyp06, kspget
integer, external :: ksctrn, kset53, kspini, kchlfl, krdndc
integer, external :: khuntr, knxtop
character(len=256) :: formatstr

!----- ACCEPT -VE FLACK PARAMETER
!----- USES DifABS CORRECTION TO FC
!----- THE CODE HAS BEEN REORGANISED SO THAT FOR NONTWINNED REFINEMENT
!      THE CODE IS ALMOST CONTINUOUS. F**2 REFINEMENT HAS ALSO BEEN
!      LINEARISED.
!
call XTIME1(1)
ILEV = 0
IRESULTS=1
NRESULTS=1
if (MODE .LE. 0) then
!----- WE WONT READ ANY DATA, BUT WILL SET TYPE TO 'CALC'
    NUM = 3
else
!--LOAD THE NEXT '#INSTRUCTION'
    NUM=KNXTOP(LSTOP,LSTNO,ICLASS)
!--CHECK if WE SHOULD return
    if(NUM.LE.0) return
!--BRANCH ON THE TYPE OF OPERATION
    I=KRDDPV(ISTORE(NFL),1)
!--READ THE NEXT DIRECTIVE CARD
! RIC11            LAST=IDIR
    IDIR=KRDNDC(ISTORE(NFL),1)
!--CHECK THE REPLY
    if(IDIR .GE. 0) then
!--ERROR CONDITION
        formatstr="(1X ,'No additional arguments permitted')"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
        write ( NCAWU , formatstr )
        write ( CMON, formatstr )
        call XPRVDU(NCVDU, 1,0)
        return
    end if
!--END OF THE DIRECTIVES  -  CHECK FOR ANY ERRORS
    if ( LEF .NE. 0 ) then
        formatstr="(1X ,'No additional arguments permitted')"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
        write ( NCAWU , formatstr )
        write ( CMON, formatstr )
        call XPRVDU(NCVDU, 1,0)
        return
    end if
!--SAVE THE LIST TYPE INDICATOR
      ITYP06=ISTORE(NFL)
end if

!call XZEROF(IWORKA(1),17)
!IWORKA(1:17)=0
call xworkb_zeros

select case(num) ! GOTO(1200,1250,1300,1350,4550,4600,1150),NUM
    case(7)
    ! Something really wrong happened, terminating
    call GUEXIT(54)
    STOP ! Should not been called

!--'#REFINE' HAS BEEN GIVEN
    !case(1)
    case default !1200  CONTINUE
    SFLS_TYPE = SFLS_REFINE
    !GOTO 1400
!
!--'#SCALE' HAS BEEN REQUESTED
    case(2) ! 1250  CONTINUE
    SFLS_TYPE = SFLS_SCALE
    !GOTO 1400
!
!--'#CALCULATE' HAS BEEN GIVEN
    case(3) ! 1300  CONTINUE
    SFLS_TYPE = SFLS_CALC
    !call XZEROF(RALL(1),12)
    RALL(1:12)=0.0
    !GOTO 1400
!
!--'#CYCLENDS' INSTRUCTION
    case(4) ! 1350  CONTINUE
    call XCYCLE
    return
    
!--'#END' INSTRUCTION
    case(5) ! 4550  CONTINUE
    call XEND
    return

!--'#TITLE' INSTRUCTION
    case(6) ! 4600  CONTINUE
    call XRCN
    return          
end select
    
!
!--SET THE VALUES FOR A S.F.L.S. CALCULATION
!1400  CONTINUE
#if defined(_PPC_) 
!S***
call SETSTA( 'S.F.L.S.' )
call nextcursor
!E***
#endif
call XDUMP
!--CLEAR THE CORE
call XRSL
!--LOAD LIST 13  -  THE EXPERIMENTAL CONDITIONS LIST
call XFAL13
if ( IERFLG .LT. 0 ) return
!--SET THE TWINNED/NON-TWINNED FLAG
TWINNED = .FALSE.
if(ISTORE(L13CD+1).GE.0) TWINNED = .TRUE.
!--FIND THE TYPE OF RADIATION
NU=ISTORE(L13DT+1)
!--FETCH THE POLARISATION CONSTANTS
WAVE=STORE(L13DC)
THETA1=STORE(L13DC+1)
THETA2=STORE(L13DC+2)
!--LOAD LIST 23  -  DEFINES CONDITIONS FOR S.F.L.S. CALCULATIONS
!call XFAL23new(ierflg)
call XFAL23
if ( IERFLG .LT. 0 ) return
!--SET THE ANOMALOUS DISPERSION FLAG
! SET TO -1 FOR NO ANOMALOUS DISPERSION, else 0 Replaced by ANOMAL      
ANOMAL = .FALSE.
if ( ISTORE(L23M) .EQ. 0 ) ANOMAL = .TRUE.
!--SET THE EXTINCTION FLAG
EXTINCT = .FALSE.
if(ISTORE(L23M+1).GE.0) EXTINCT = .TRUE.
!--SET THE LAYER SCALES APPLICATION FLAG
LAYERED=.FALSE.
if(ISTORE(L23M+2).GE.0) LAYERED = .TRUE.
!--SET THE BATCH SCALES APPLICATION FLAG
BATCHED=.FALSE.
if (ISTORE(L23M+3).GE.0) BATCHED = .TRUE.
!--SET THE PARTIAL CONTRIBUTIONS FLAG
PARTIALS = .FALSE.
if(ISTORE(L23M+4).GE.0) PARTIALS = .TRUE.
!--SET THE UPDATE PARTIAL CONTRIBUTIONS FLAG
ND=ISTORE(L23M+5)
!----- SET THE ENANTIOPOLE REFINEMENT FLAG
ENANTIO = .FALSE.
if ( ISTORE(L23M+6) .EQ. 0 ) ENANTIO = .TRUE.
!--SET THE FLAG FOR REFINEMENT AGAINST /FO/ OR /FO/ **2
NV=ISTORE(L23MN+1)
!----- CHECK if WE  NEED REFLECTIONS (-1 IF NOT)
IREFLS = ISTORE(L23MN+3)
!--FIND THE MINIMUM ALLOWED TEMPERATURE FACTOR
UMIN=STORE(L23AC+8)
!----- SAVE THE TOLERANCE AND UPDATE VALUES
STOLER = STORE(L23SP+5)
IUPDAT = ISTORE(L23SP+1)
!--CLEAR THE CORE OUT AGAIN
call XRSL
call XCSAE
!----- SAVE SOME SPACE FOR THE U AXES
IADDU = KCHLFL (4)
!--LOAD LIST 33  -  THE CONDITIONS FOR THIS S.F.L.S. CALCULATION
call XFAL33
if ( IERFLG .LT. 0 ) return
if ( SFLS_TYPE .EQ. SFLS_CALC ) then
    RALL(1)=STORE(M33CD+5)
end if
!
! If outputting design matrix and deltaF's then open files now.
if ( SFLS_TYPE .eq. SFLS_REFINE ) then     
     MATLAB = 0
     if (ISTORE(M33CD+5).EQ.1) then
         MATLAB = 1
         call XRDOPN (5,JFRN(1,1),'design.m',8)
         write (NCFPU1, '(''A=['')')
         call XRDOPN (5,JFRN(1,2),'wdf.m',5)
         write (NCFPU2, '(''DF=['')')
     end if

     ILEV = ISTORE(M33CD+12)
end if

NF=-1
REFPRINT = .FALSE.
!----- READ DOWN SOME LISTS
call XFAL01
call XFAL02
call XFAL05
call XFAL30
if (IERFLG .LT. 0) return
!
!--CHECK THAT ALL THE TEMPERATURE FACTORS ARE REASONABLE
!-C-C-CHECK THAT ALL T.F. AND SPECIAL PARAMETERS ARE REASONABLE
!-C-C-SIMILAR CHECKS ALSO IN XSFLSG (NO CHANGE OF LIST 5 BY XSFLSB)
M5=L5
!--CHECK THAT THERE IS AT LEAST ONE ATOM IN LIST 5
if(N5 .LE. 0) then ! GOTO 9940
    formatstr="(1X ,'LIST 5 contains no atoms')"
    if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
    write ( CMON, formatstr )
    call XPRVDU(NCVDU, 1,0)
    return
end if

!--LOOP OVER EACH ATOM
A=1000.
N=0
do I=1,N5   ! Safety checks
!-C-C-CHECK WHETHER ATOM IS ANISOTROPIC
    if (ABS(STORE(M5+3)) .LE. UISO) then
!-C-C-CHECK ANISOTROPIC ATOMS
!--CHECK THE SMALLEST U AXIS
        call XEQUIV ( 1, M5, MD5, IADDU )
        if (STORE(IADDU+1) .LT. UMIN) then
!--THIS ANISOTROPIC TEMPERATURE FACTOR IS NOT ALLOWED
            if (ISSPRT .EQ. 0) then
                write(NCWU, 3110) STORE(M5), NINT(STORE(M5+1)),STORE(IADDU+1)
            end if
3110  FORMAT(' Atom ', A4, I5, ' has U-min too small, ', F8.4)
            write ( CMON, 3110) STORE(M5), NINT(STORE(M5+1)),STORE(IADDU+1)
            call OUTCOL(9)
            call XPRVDU(NCVDU, 1,0)
            call OUTCOL(1)
            A=MIN(A,STORE(IADDU+1))
            N=N+1
            U = UMIN+ZERO
            STORE(M5+7) = MAX(U,STORE(M5+7))
            STORE(M5+8) = MAX(U,STORE(M5+8))
            STORE(M5+9) = MAX(U,STORE(M5+9))
            STORE(M5+10) = MAX(0.01*U,STORE(M5+10))*STORE(L1C)
            STORE(M5+11) = MAX(0.01*U,STORE(M5+11))*STORE(L1C+1)
            STORE(M5+12) = MAX(0.01*U,STORE(M5+12))*STORE(L1C+2)
        end if
    else
!-C-C-CHECK ISOTROPIC ATOM OR SPECIAL FIGURE
!--CHECK THE ISOTROPIC TEMPERATURE FACTOR
        if(STORE(M5+7) .LE. UMIN) then
!--THIS U[ISO] VALUE IS OUT OF RANGE
            write ( CMON, 3120)STORE(M5), NINT(STORE(M5+1)),STORE(M5+7)
            call XPRVDU(NCVDU, 1,0)
            if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)
3120        FORMAT(' Atom ',A4,I5,' has U-iso too small, ', F8.4)
            A=MIN(A,STORE(M5+7))
            N=N+1
            STORE(M5+7) = UMIN + ZERO
        end if
!-C-C-CHECK OF SPECIAL FIGURE SPECifIC PARAMETERS
        if (NINT(STORE(M5+3)) .GE. 2) then
!-C-C-CHECK OF SIZE FOR ALL SPECIAL FIGURES
            if (STORE(M5+8) .LT. 0.0005) then
                if (ISSPRT .EQ. 0) then
                    write(NCWU,3130)STORE(M5), NINT(STORE(M5+1)),STORE(M5+8)
                end if
3130            FORMAT(/,' Spec.Fig. ',A4,I5, ' has SIZE too small:',F8.4, &
                &    /,31X,'Reset to:  0.001',/, 21X, &
                &    '(in LIST 5 only in case of refinement !)')
                STORE(M5+8)=0.001
            end if
!-C-C-CHECK OF DECLINAT AND AZIMUTH FOR LINE AND RING
            if (NINT(STORE(M5+3)) .GE. 3) then
!-C-C-CHECK WHETHER DECLINAT MIGHT BE GIVEN IN DEGREES
!-C-C-(SUPPOSED if ANGLES BIGGER THAN 5.0)
!-C-C-(THIS BLOCK CAN BE REMOVED WHEN IT IS MADE SURE THAT THE VALUE
!-C-C-OF ANGLES IS ALWAYS IN UNITS OF 100 DEGREES.)
                if ((STORE(M5+9) .GE. 5.0).OR.(STORE(M5+9) .LE. -5.0)) then
                    if (ISSPRT .EQ. 0) then
                        write(NCWU,3140)STORE(M5), NINT(STORE(M5+1)),STORE(M5+9)
                    end if
3140                FORMAT(/,' Line/Ring ',A4,I5,' has DECLINAT probably', &
                    &   ' given in degrees: ', F8.4,/, &
                    &   21X,'Value devided by 100 to get units of 100 degrees',/, &
                    &   21X,'(in LIST 5 only in case of refinement !)')
                    STORE(M5+9)=STORE(M5+9)/100
                end if
!-C-C-BRING DECLINAT INTO PRACTICAL RANGE if TOO FAR AWAY FROM IT
                if ((STORE(M5+9).GT.3.6).OR.(STORE(M5+9).LT.-3.6)) then
                    STORE(M5+9)=MOD(STORE(M5+9),3.6)
                end if
                if (STORE(M5+9) .GT. 1.8) then
                    STORE(M5+9)=STORE(M5+9)-3.6
                else if (STORE(M5+9) .LT. -1.8) then
                    STORE(M5+9)=STORE(M5+9)+3.6
                end if
!-C-C-CHECK WHETHER DECLINAT IS CLOSE TO 0.0 OR +/-1.8
                if ((ABS(STORE(M5+9)+1.8) .LT. 0.001) .OR. &
                &   (ABS(STORE(M5+9)-1.8) .LT. 0.001) .OR. &
                &   (ABS(STORE(M5+9)) .LT. 0.001)) then
!-C-C-PRINT WARNING, GIVE AZIMUTH ARBITRARY VALUE
                    if (ISSPRT .EQ. 0) then
                        write(NCWU, 3145) STORE(M5), NINT(STORE(M5+1))
                    end if
3145                FORMAT(/,' Line/Ring ',A4,I5,' has DECLINAT = n*180.0 deg.', &
                    &   /,21X,'==> AZIMUTH is not defined !!!', &
                    &   /,    ' It is reset to an arbitrary value (0.0)', &
                    &         ' and should not be refined !', &
                    &   /,' (change in LIST 5 only in case of refinement !)')
!-C-C-PERHAPS IT'S REASONABLE TO REMOVE THE AUTOMATICAL CHANGE
                    STORE(M5+10) = 0.0
                else
!-C-C-CHECK WHETHER AZIMUTH MIGHT BE GIVEN IN DEGREES
!-C-C-(SUPPOSED if ANGLES BIGGER THAN 5.0)
!-C-C-(THIS BLOCK CAN BE REMOVED WHEN IT IS MADE SURE THAT THE VALUE
!-C-C-OF ANGLES IS ALWAYS IN UNITS OF 100 DEGREES.)
                    if ((STORE(M5+10).GE.5.0).OR.(STORE(M5+10).LE.-5.0))THEN
                        if (ISSPRT .EQ. 0) then
                            write(NCWU,3150)STORE(M5),NINT(STORE(M5+1)), STORE(M5+10)
                        end if
3150                    FORMAT(/,' Line/Ring ',A4,I5,' has AZIMUTH  probably', &
                        &                ' given in degrees: ', F8.4,/, &
                        &   21X,'Value devided by 100 to get units of 100 degrees',/, &
                        &   21X,'(in LIST 5 only in case of refinement !)')
                        STORE(M5+10)=STORE(M5+10)/100
                    end if
!-C-C-BRING AZIMUTH INTO PRACTICAL RANGE if TOO FAR AWAY FROM IT
                    if ((STORE(M5+10).GT.3.6).OR.(STORE(M5+10).LT.-3.6))THEN
                        STORE(M5+10)=MOD(STORE(M5+10),3.6)
                    end if
                    if (STORE(M5+10) .GT. 1.8) then
                        STORE(M5+10)=STORE(M5+10)-3.6
                    else if (STORE(M5+10) .LT. -1.8) then
                        STORE(M5+10)=STORE(M5+10)+3.6
                    end if
                end if
            end if
        end if
    end if
    M5 = M5 + MD5
end do
!--CHECK if THE T.F.'S ARE ALL OKAY
if (N .NE. 0) then
! -- INVALID TEMPERATURE FACTOR
    if (ISSPRT .EQ. 0) write ( NCWU , 9935 ) N , UMIN , A
9935      FORMAT ( 1X , I6 , ' temperature factors less ' , &
    &   'than the lowest allowed value of ' , F10.5 , &
    &   /1X,' The minimum value  was ', F10.5)
    write ( CMON, 9935) N, UMIN, A
    call XPRVDU(NCVDU, 2,0)
end if
if ((STORE(L5O+4) .GT. 1.) .OR. (STORE(L5O+4) .LT. 0.)) then
    write ( CMON, 3320) STORE(L5O+4)
    call XPRVDU(NCVDU, 1,0)
    if (ISSPRT .EQ. 0)  write(NCWU, '(A)') CMON(1)(:)
3320      FORMAT(1X,'Enantiopole parameter out of range. (',F6.3,' ) ')
end if

if (STORE(L5O+5) .LT. -ZERO) then
    call OUTCOL(9)
    write ( CMON, 3345) STORE(L5O+5)
    call OUTCOL(1)
    call XPRVDU(NCVDU, 1,0)
    write(NCWU, '(A)') CMON(1)(:)
3345      FORMAT(1X,'Extinction parameter negative. (',F12.6,' ) ')
    STORE(L5O+5) = 0.0
end if

if (IUPDAT .GE. 0)  I = KSPINI( -1, STOLER) ! SET THE OCCUPANCIES
NUPDAT = 0  
J =NFL
I = KCHNFL(40)  ! SAVE SOME WORK SPACE
M5 = L5
do I = 1, N5   ! Set occupancies
    if (IUPDAT .GE. 0) then
        IGSTAT =KSPGET ( STORE(J), STORE(J+10), ISTORE(J+20), &
        &   STORE(J+30), MGM, M5, IUPDAT, NUPDAT)
    else
        STORE(M5+13) = 1.0
    end if
    M5 = M5 + MD5
end do
NFL= J
!djwapr09 Check the Flack Enantiopole Parameter.
! If this is the first time it has been refined, set it to 0.5
!
! moved to LIST12.fpp because it can clash with POLARITY refinement
! if the user forgets to reset list 23
!
!      if (( enantio .eqv. .true.) .and. (abs(store (L5o+4)) .le. zerosq)
!     1 .and. (abs(store(l30ge+6)) .le. zero)) then
!            store(L5O+4) = 0.5
!            write ( CMON, '(A)')'Starting FLACK refinement from 0.5' 
!            call XPRVDU(NCVDU, 1,0)
!            if (ISSPRT .EQ. 0)  write(NCWU, '(A)') CMON(1)(:)
!      endif
!
SCALE = STORE(L5O) 
if (SCALE .LE. 0.000001) then  ! CHECK THAT THE SCALE FACTOR GIVEN IS NOT ZERO
    if (ISSPRT .EQ. 0) write(NCWU,1420)
    write ( CMON, 1420)
    call XPRVDU(NCVDU, 1,0)
1420      FORMAT(10X,' The overall scale factor has been set to 1.0' )
    SCALE = 1.   ! SCALE FACTOR IS UNREASONABLE  -  RESET IT TO 1.0
    STORE(L5O)=1.
    call XSTR05(5,-1,-1)
end if

NEWLHS = .FALSE.  ! CHECK ON THE TYPE OF MATRIX TO USE
if ( ISTORE( M33CD+6) .EQ. -1 ) NEWLHS = .TRUE.
ISTAT2 = ISTORE (M33CD+3)  ! SET THE STORE MAP LEVEL

if ( IREFLS .GE. 0 ) then            ! Not Restraints only
    if ( ISTORE(M33CD+2) .GT. 0 ) then  ! CHECK ON THE TYPE OF LISTING REQUIRED
        NF=0   ! COMPLETE LISTING, INCLUDING ELEMENT CONTRIBUTIONS FOR A TWIN
        REFPRINT = .TRUE.   ! LISTING OF EACH STRUCTURE FACTOR AS IT IS CALCULATED
    else if ( ISTORE(M33CD+2) .EQ. 0 ) then
        REFPRINT = .TRUE.   ! LISTING OF EACH STRUCTURE FACTOR AS IT IS CALCULATED
    end if
    if (TWINNED) then  ! CHECK IF THIS STRUCTURE IS TWINNED
        SCALED_FOT = .FALSE.
        if(ISTORE(M33CD+4).GE.0) SCALED_FOT = .TRUE.   ! SCALED /FOT/ IS REQUIRED
    end if

    call XFAL03    ! READ DOWN SOME LISTS
    IULN = KTYP06(ITYP06)  ! FIND THE REFELCTIONLIST TYPE
    call XFAL06(IULN,1)

    S6SIG = -10.0   ! SIGMA THRESHOLD
    rall(1) = 2.0
    if ( MODE.ge. 0 ) then
        if ( N28MN .GT. 0 ) then
        INDNAM = L28CN
        do I = L28MN , M28MN , MD28MN
            write ( CTEMP , '(3A4)') (ISTORE(J),J=INDNAM,INDNAM+2)
            if (INDEX(CTEMP,'RATIO') .GT. 0) then
                S6SIG = STORE(I+1)
                if ( MODE.EQ.-1 ) RALL(1) = STORE(I+1)
            end if
            INDNAM = INDNAM + MD28CN
        end do
    end if
endif

if ( IERFLG .LT. 0 ) return

call XIRTAC(4)   ! CRIC11-Update FO totals in all cases, in case L28 changed
call XIRTAC(6)   ! INITIALISE THE COLLECTION OF THE DETAILS FOR /FC/ AND PHASE
call XIRTAC(7)
call XIRTAC(16)

N12=0  ! SET UP DEFAULT VALUES FOR THE REFLECTION HOLDING STACK
N25=1


if ( .NOT. TWINNED ) then        ! THIS IS NOT A TWINNED REFINEMENT
    NF=-1
    if(ND.GE.0) then  ! CHECK IF WE ARE UPDATING THE PARTIAL DERIVATIVES
        call XIRTAC(8)
        call XIRTAC(9)
    end if

else                         ! THIS IS A TWINNED REFINEMENT

    if ( EXTINCT ) then
        write(CMON,'(6X,A)') 'It is unwise to refine extinction for twinned data'
        call OUTCOL(9)
        call XPRVDU(NCVDU, 1,0)
        if (ISSPRT .EQ. 0) write(NCWU,'(A)') CMON(1)
        call OUTCOL(1)
!djw0302 - allow twin with extparam:  NA=-1
    end if
    PARTIALS = .FALSE. ! SUPPRESS PARTIAL CONTRIBUTIONS
    ND=-1
    ENANTIO = .FALSE.  ! SUPPRESS ENANTIOPOLE REFINEMENT
!ric11        call XIRTAC(4)     ! INITIALISE THE DETAILS FOR /FO/

    if(.NOT. REFPRINT) NF = -1          ! SUPPRESS ELEMENT PRINTING

    if ( IERFLG .LT. 0 ) return
    call XFAL25                  ! LOAD THE TWIN OPERATORS

    if ( MD5ES .NE. N25 ) then !GO TO 9910 ! CHECK THAT THE NUMBER OF OPERATORS EQUALS THE NUMBER OF ELEMENTS
! -- NUMBERS DON'T MATCH
        formatstr="(1X,'The number of elements in lists 5 and 25 is different' )"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
            write ( CMON, formatstr )
            call XPRVDU(NCVDU, 1,0)
            call XERHND ( IERERR )
            return
        end if

        LN=LN5
        IREC=1001
        M5ES=NFL
        I=KCHNFL(MD5ES)
        J=M5ES
        K=L5ES
!djwMar09 - fix sum if scales go -ve
        elesum = 0.
        nneg = 0
! turn on red
        call OUTCOL(9)
        do I=1,MD5ES   ! FORM THE SQUARE ROOT OF THE ELEMENT SCALES
            if (STORE(K) .LT. 0) then
                if (ISSPRT .EQ. 0) write(NCWU,2301) I,STORE(K)
                write ( CMON, 2301)  I, STORE(K)
                call XPRVDU(NCVDU, 1,0)
2301            FORMAT(' Twin element error, Scale',I3,' = ',F8.4)
                STORE(K) = 0.0
                nneg = nneg + 1
            end if
            elesum = elesum + store(k)
            K=K+1
        end do
        if (nneg .gt. 0) then
            elescl = 1./ elesum
            if (ISSPRT .EQ. 0) write(NCWU,2302) elescl
            write ( CMON, 2302)  elescl
            call XPRVDU(NCVDU, 1,0)
2302        FORMAT(' Rescaling element scales by  ',f10.4)
        end if
! turn off red
        call OUTCOL(9)
        K=L5ES
        do I=1,MD5ES   ! FORM THE SQUARE ROOT OF THE ELEMENT SCALES
            if ( nneg .gt. 0) then 
                STORE(J)=SQRT(STORE(K)*elescl)
            else
                STORE(J)=SQRT(STORE(K))
            end if
            J=J+1
            K=K+1
        end do
    end if
end if

JQ=0

if ( SFLS_TYPE .NE. SFLS_REFINE ) then  ! NO REFINEMENT
    ISO_ONLY = .TRUE.
    JO = 1 ! Dummy space for derivatives
    JP = 1 ! Dummy space for derivatives

    if(KSET52(-1,0).GE.0)THEN      ! SET THE T.F. VALUES IN LIST 5
        if ( IERFLG .LT. 0 ) return
        ISO_ONLY = .FALSE.
    end if
else                             ! REFINEMENT

    JQ=(2-IC)  ! SET UP THE STORAGE LOCATIONS FOR THE PARTIAL DERIVATIVES
    if ( ANOMAL ) JQ = JQ * 2
    JQ=MAX0(JQ,2)
    LJS=-1

    call XFAL12(LJS,JQ,JR,JN)  ! LOAD LIST 12
    if ( IERFLG .LT. 0 ) return
    ISO_ONLY = .TRUE. ! SET THE INITIAL DETAILS FOR LINKING LISTS 12 AND 5
    if(KSET52(0,0).GE.0)THEN    ! LINK LIST 12 AND LIST 5
        if ( IERFLG .LT. 0 ) return
        ISO_ONLY = .FALSE.  ! ! ANISO T.F.'S ARE STORED
    end if
    if ( IERFLG .LT. 0 ) return

    if ( N12 .LE. 0 ) then !GO TO 9920  ! CHECK THERE ARE PARAMETERS TO REFINE
! -- NOTHING TO REFINE
        formatstr="(1X, 'List 12 indicates that no parameters are to be refined' )"
        if (ISSPRT .EQ. 0) write ( NCWU , formatstr )
        write ( CMON, formatstr )
        call XPRVDU(NCVDU, 1,0)
        call XERHND ( IERERR )
        return !GO TO 9900
    end if

    JO=JR       ! SET UP THE STACK FOR THE COMPLETE PARTIAL DERIVATIVES
    JP=JO+N12-1

    if(NEWLHS) then           ! SET UP A NEW MATRIX   MATRIX=NEW (default)
        call XSET11(-1,1,1)
        if ( IERFLG .LT. 0 ) return
        if (ISTORE(M33CD+13) .EQ. 0) then ! See if sparse is set to bond
!                     iresults = KSTALL(N11)
!                     print *, N11, NRESULTS
!                     NRESULTS = param_list_make(istore(IRESULTS), N11, JR,
!     1                JQ)
            NRESULTS = param_list_make(IRESULTS, JR, JQ)
!            print *, N11, NRESULTS
! Allocate the rest of the memory we have already used. this is horrible but there
! isn't any other way to do it unless I create a chain(linked list)
!               inewresult = KSTALL(NRESULT) 
        end if
    else                       ! WE ONLY NEED THE R.H.S. MATRIX=OLD (Old LHS will be loaded later)
        call XSET11(0,0,1)
        if ( IERFLG .LT. 0 ) return
        M11R=L11R+N11R-1  
        STR11(L11R:M11R)=0. ! CLEAR THE R.H.S. OF THE OLD NUMBERS
    end if

!--CHECK THAT THERE IS ROOM TO OUTPUT THE MATRIX
    call XCL11(11)
!C--INITIALISE THE MATRIX ACCUMULATION ROUTINES
!c        call XSETMT
end if

!--LINK LIST 5 AND 3
!----- CHECK FOR RESTRAINTS ONLY
if (IREFLS .GE. 0) then
    N3=KSET53(0)+1
    if ( IERFLG .LT. 0 ) return
end if
!
!----- CHECK if REFLECTIONS SHOULD BE USED
if (IREFLS .LE. -1) then
    NT    = 0
    R     = 0.
    RW    = 0.
    WDFT  = 0.
    AMINF = 0.
    CYCNO = STORE(M33V) + 1
else

     call XPRTCN               ! OUTPUT AN INITIAL CAPTION
     STORE(L6P)=STORE(L6P)+1.  ! FIND THE NUMBER OF CYCLES CALCULATED
     JI=NINT(STORE(L6P))
     CYCNO = STORE(L6P)

     if (ISSPRT .EQ. 0) write(NCWU,3600)JI  ! PRINT THE TITLE HEADING
3600       FORMAT(' Structure factor least squares',5X,' calculation number',I6)

     if(ISTAT2 .NE. 0) then   ! PRINT THE ALLOCATED CORE STORE IF NECESSARY
         call XPCM(1)
!--CHECK if WE SHOULD DUMP ANY OTHER GOODIES
         if(ISTAT2.GE.1) then 
             if (ISSPRT .EQ. 0) write(NCWU,3750) ji,jn,jo,jp,jq,jr, &
             &  nd,ne,nf,ni,nl,nm,nn,nr,nt,nu,nv ! was iworka
3750         FORMAT('IWK:',13I9)
             M2=L2+MD2*N2-1
             if (ISSPRT .EQ. 0) write(NCWU,3800) (STORE(I),I=L2,M2)
3800         FORMAT(1X,12F10.5)
             M2I=L2I+MD2I*N2I-1
             if (ISSPRT .EQ. 0) write(NCWU,3800) (STORE(I),I=L2I,M2I)
             M3=L3+MD3*N3-1
             if (ISSPRT .EQ. 0) write(NCWU,3850) (STORE(I),I=L3,M3)
3850         FORMAT(1X,A4,11F10.5)
             M5=L5+MD5*(N5-1)
             do I=L5,M5,MD5
                 L=I+2
                 M=I+MD5-1
                 if (ISSPRT .EQ. 0) then
                     write(NCWU,3900)ISTORE(I),ISTORE(I+1),(STORE(K),K=L,M)
                 end if
3900             FORMAT(1X,2I4,11F9.5)
             end do

             if(SFLS_TYPE .EQ. SFLS_REFINE) then
                 call XPRINT(L22,L22+(MD22*N22)-1)
             end if
        end if
    end if
!            call cpu_time(time_begin)
    call XSFLSC(STORE(JO),JP-JO+1,istore(iresults), nresults, ierflg) ! CALL THE CALCULATION LINK
!            call cpu_time(time_end)
!            print *, (time_end - time_begin)
end if

if ( IERFLG .LT. 0 ) return
!--CHECK FOR L.S. REFINEMENT
if( SFLS_TYPE .EQ. SFLS_REFINE ) then  !STORE THE MATRIX
    STORE(L11P+23)=real(N12)      ! STORE THE NUMBER OF PARAMETERS
    STORE(L11P+24)=real(NT)       ! NUMBER OF REFLECTIONS THAT HAVE BEEN USED
    STORE(L11P+25)=WDFT            ! STORE THE SUM OF W*DF**2
    if (ABS (RW) .LE. ZERO) then
        A =1.
    else
        A = 100. / RW
    end if
    STORE(L11P+26)=WDFT*A*A        ! STORE THE SUM OF W* /FO/ **2
    STORE(L11P+16)=STORE(L11P+24)-STORE(L11P+23)  ! NUMBER OF DEGREES OF FREEDOM
    STORE(L11P+17)=AMINF           ! STORE THE MINIMISATION function
    call XCL11(11)                 ! OUTPUT LIST 11
    call XMKOWF(11,0)
    call XALTES(11,1)
end if
!--TERMINATE THE OUTPUT OF LIST 6  -  STORE THE R-VALUE

if (IREFLS .GE. 0) then
    STORE(L6P+1)=R
!--STORE THE WEIGHTED R-VALUE
    STORE(L6P+2)=RW
!--STORE THE MINIMISATION function
    STORE(L6P+3)=AMINF
!--COMPUTE THE REFLECTION TOTALS FOR /FC/ AND PHASE
    N6TEMP = N6W
    N6W  = NT
    call XCRD(6)
!RIC11-Update FO totals in all cases, in case L28 changed
!        if(TWINNED) call XCRD(4)  ! CHECK FOR A TWINNED REFINEMENT
    call XCRD(4)  ! CHECK FOR A TWINNED REFINEMENT
    N6W  = N6TEMP
    call XCRD(7)
    call XCRD(16)
!--

    if(ND.GE.0) then   ! CHECK IF WE HAVE UPDATED THE A AND B PARTS
        call XCRD(8)
        call XCRD(9) ! UPDATE THEIR DETAILS
    end if

    call XMONTR(-1)  ! write THE LIST TO THE DISC
    call XERT(IULN)
end if

STORE(M33V) = CYCNO      ! UPDATE THE DETAILS FOR LIST 33
STORE(M33V+1)=R
STORE(M33V+2)=RW
STORE(M33V+3)=0.
STORE(M33V+4)=AMINF

icom33=(/ l33cd,m33cd,md33cd,n33cd,l33sv,m33sv,md33sv,n33sv, &
&   l33st,m33st,md33st,n33st,l33ib,m33ib,md33ib,n33ib, &
&   l33v,m33v,md33v,n33v,l33cb,m33cb,md33cb,n33cb,ityp33 /)
call XWLSTD(33,ICOM33,IDIM33,-1,-1)   ! OUTPUT THE NEW LIST 33 TO DISC
if (KHUNTR (30,0, IADDL,IADDR,IADDD, -1) .NE. 0) call XFAL30
!djwoct09
if (SFLS_TYPE .EQ. SFLS_SCALE) then
!      update LIST 30 R and Rw values if only SCALE has been asked for
    STORE(L30RF+0 ) = R  
    STORE(L30RF+1 ) = RW
end if
if (KHUNTR (11,0, IADDL,IADDR,IADDD, -1) .EQ. 0) then
    STORE(L30RF+0 ) = R   ! 'REFINE' 
!djwmay07 L30GE is filled in ANALYSE and lets the user see the effect
!         of changing the thresholds.
!djwmay07        STORE(L30GE+10 ) = R  ! UPDATE LIST 30
    STORE(L30RF+1 ) = RW
!djwmay07        STORE(L30GE+11 ) = RW
    if(STORE(L11P+23) .GT.ZERO) STORE(L30RF+2 )=STORE(L11P+23)
    if (STORE(L11P+16) .GT. ZERO) then
        STORE(L30RF+4 ) = SQRT(AMINF / STORE(L11P+16))
    end if
    STORE(L30RF+8 ) = STORE(L11P+24)  ! NUMBER OF REFLECTIONS USED
!djwmay07        STORE(L30GE+9 ) = STORE(L11P+24)

!        if ( SFLS_TYPE .NE. SFLS_REFINE )  then
    STORE(L30RF+3) = S6SIG  ! SIGMA THRESHOLD FOR REFINEMENT
!djwmay07            STORE(L30GE+8) = S6SIG
!        end if

    STORE(L30IX+6) = RTD*ASIN(WAVE*SMIN)  ! STORE THETA LIMITS
    STORE(L30IX+7) = RTD*ASIN(WAVE*SMAX)

    ISTORE(L30RF+12 ) = NV + 2   ! REFINEMENT TYPE

end if


if( SFLS_TYPE .EQ. SFLS_CALC ) then  ! 'CALC' ONLY
    STORE(L30RF+0 ) = R
!djwmay07          STORE(L30GE+10 ) = R
    STORE(L30RF+1 ) = RW
!djwmay07          STORE(L30GE+11 ) = RW

    STORE(L30CF)=RALL(1)
    STORE(L30CF+1)=RALL(2)

    STORE(L30CF+4)=-10.
    STORE(L30CF+5)=RALL(7)

    if (RALL(4) .GT. ZERO) then
        STORE(L30CF+2) =100.* RALL(3)/RALL(4)
    end if
    if (RALL(6) .GT. ZERO) then
        STORE(L30CF+3) = 100.*SQRT(RALL(5)/RALL(6))
    end if

    if (RALL(9) .GT. ZERO) then
        STORE(L30CF+6) =100.* RALL(8)/RALL(9)
    end if
    if (RALL(11) .GT. ZERO) then
        STORE(L30CF+7) = 100.*SQRT(RALL(10)/RALL(11))
    end if

262          FORMAT (2X,I7,' reflections   R ',F5.2,'% Rw ',F5.2, &
    &   '% with I/u(I) from List 28')
6261          FORMAT (2X,I7,' reflections   R ',F5.2,'% Rw ',F5.2, &
    &   '% with I/u(I) >',F6.1)
6262          FORMAT (2X,I7,' reflections   R ',F5.2, &
    &   '% Rw ',F5.2,'% with I/u(I) from List 28')
    if (issprt .eq.0) write(ncwu,'(//)')
    call OUTCOL(6)
    write ( CMON, 6262) NT, MIN(99.99,STORE(L30RF)),MIN(99.99,STORE(L30RF+1))
    call XPRVDU(NCVDU, 1, 0)
    if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)

    write ( CMON, 6261) NINT(RALL(7)), MIN(99.99,STORE(L30CF+6)), &
    &   MIN(99.99,STORE(L30CF+7)), -10.0
    call XPRVDU(NCVDU, 1, 0)
    if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)

    write ( CMON, 6261) NINT(RALL(2)), MIN(99.99,STORE(L30CF+2)), &
    &   MIN(99.99,STORE(L30CF+3)), RALL(1)
    call XPRVDU(NCVDU, 1, 0)
    if (ISSPRT .EQ. 0) write(NCWU, '(A)') CMON(1)(:)
    call OUTCOL(1)
end if
icom30 = (/ l30dr,m30dr,md30dr,n30dr, l30cd,m30cd,md30cd,n30cd, & 
&   l30rf,m30rf,md30rf,n30rf, l30ix,m30ix,md30ix,n30ix, &
&   l30ab,m30ab,md30ab,n30ab, l30ge,m30ge,md30ge,n30ge, &
&   l30cl,m30cl,md30cl,n30cl, l30sh,m30sh,md30sh,n30sh, &
&   l30cf,m30cf,md30cf,n30cf /)
call XWLSTD ( 30, ICOM30, IDIM30, -1, -1)

call XRSL     ! CLEAR THE CORE
call XCSAE

if( SFLS_TYPE .EQ. SFLS_SCALE ) then   ! THE SCALE FACTOR HAS BEEN REFINED
    call XFAL05
    if ( IERFLG .LT. 0 ) return
    STORE(L5O)=SCALE
    J =NFL            ! SAVE SOME WORK SPACE
    I = KCHNFL(40)
    M5 = L5
    do I = 1, N5  ! Set occupancies
        if (IUPDAT .GE. 0) then
            IGSTAT=KSPGET(STORE(J), STORE(J+10), ISTORE(J+20), &
            &   STORE(J+30), MGM, M5, IUPDAT, NUPDAT)
        end if
        M5 = M5 + MD5
    end do
    NFL= J
    call XSTR05(LN5,-1,-1)
    call XRSL
    call XCSAE
end if
!djwjan05
FOAV = STORE(L6DTL+3*MD6DTL + 2)
FCAV = STORE(L6DTL+5*MD6DTL + 2)
rscle=foav/fcav
if (store(l30dr+7) .le. zero) then
    wscle = zero
else
    wscle = sqrt(1./store(l30dr+7))
endif
!djwsep09
istat = ksctrn (1,'sfls:rscale', rscle, 1)
istat = ksctrn (1,'sfls:scale',  scale, 1)
write(cmon,'(3(a,f7.3,3x))') 'SumFo/SumFc=', rscle, &
&   'SumFoFc/SumFc^2=', sfofc/sfcfc, &
&   'SumwFoFc/SumwFc^2=', wsfofc/wsfcfc, &
&   'LS-scale=', scale, &
&   'Wilson Scale=', wscle
if (min(scale, rscle)/max(scale,rscle) .lt. 0.8) then
    call outcol(9)
endif
call xprvdu(NCVDU,2,0)
if(issprt.eq.0) write(ncwu, '(a)') cmon(1)(:),cmon(2)(:)
call outcol(1)
delfofc = (foav-fcav*scale)
!RIC13:        write(cmon,'(a,f8.3,4x,a,f8.3)')'<Fo>-<Fc> = ', 
write(cmon,'(a,f8.3,4x,a,f8.2)')'<Fo>-<Fc> = ', &
&   delfofc/scale, &
&   '100*(<Fo>-<Fc>)/<Fo> = ',100.*delfofc/foav
call xprvdu(NCVDU,1,0)
if(issprt.eq.0) write(ncwu, '(a)') cmon(1)(:)
!djwjan05
!
!--PRINT THE TERMINATION MESSAGES
call XOPMSG(IOPSFS, IOPEND, IVERSN)
call XTIME2(1)

END

!CODE FOR XSFLSC
subroutine XSFLSC ( DERIVS, NDERIV, IRESULTS, NRESULTS, ierflg)
!$    use OMP_LIB
!--MAIN STRUCTURE FACTOR CALCULATION ROUTINE
!
!--USEAGE OF CONTROL VARIABLES :
!
!  JA      SET TO 1 FOR ISO ATOMS ONLY, else N2                           Changed to ISO_ONLY
!  JB      SET TO -1 FOR NO REFINEMENT, else 0 .                          Replaced by SFLS_TYPE
!  JC      SET TO -1 FOR ONLY CALCULATE COS, else 0                       REplaced by COS_ONLY
!  JD      SET TO -1 FOR CENTRO, else 0                                   Replaced by CENTRO
!  JE      SET TO -1 FOR NO ANOMALOUS DISPERSION, else 0                  Replaced by ANOMAL
!  JF      CURRENT VALUE OF JB, SET FOR EACH ATOM if JB=0                 Replaced by ATOM_REFINE
!  JG      SET TO -1 FOR NO PRINT, else THE NUMBER OF LINES BEFORE PAGE   Replaced by REFPRINT
!  JH      SET TO -1 if THE SCALE FACTOR IS NOT TO BE REFINED, else 0     Replaced by SFLS_TYPE

!  JJ      SET TO -1 if ONLY ISO-TERMS REQUIRED, else 0 (SIMILAR TO JA)   Removed (use ISO_ONLY)
!  JK      SET TO -1 if BOTH LEFT AND RIGHT HAND SIDES ARE NEEDED         Replaced by NEWLHS
!  JL      SET TO -1 if ENANTIOPOLE PARAMETER NOT USED, else 0            Replaced by ENANTIO

!  JI      CYCLE NUMBER                                                   Replaced by cycle_number

!  JN      DUMMY LOCATION FOR NON-REFINED PARAMETERS                      replaced by non_refined_param
!  JO      ADDRESS COMPLETE PARTIAL DERIVATIVES                           replaced by address_part_deriv_complete 
!  JP      LAST ADDRESS COMPLETE PARTIAL DERIVATIVES                      replaced by last_address_part_deriv_complete
!  JQ      NUMBER OF PARTIAL DERIVATIVES PER REFLECTION (0,1,2 OR 4)      replaced by num_part_deriv_per_refl
!  JR      ADDRESS PARTIAL DERIVATIVES BEFORE THEY ARE ADDED TOGETHER     replaced by address_part_deriv
!  LJS      WORK VARIABLE
!  JT      WORK VARIABLES USED DURING ACCUMULATION OF PARTIAL DERIVATIVE  Replaced by LJT
!  JU                                                                     Replaced by LJU
!  JV                                                                     Replaced by LJV
!  JW                                                                     Replaced by LJW
!  JX      LOOP VARIABLE FOR EQUIVALENT POSITIONS                         Replaced by LJX
!  JY      LOOP VARIABLE FOR ATOMS                                        Replaced by LJY
!  JZ                                                                     Replaced by LJZ
!
!  NA      SET TO -1 FOR NO EXTINCTION CORRECTION TO /FC/, else 0         Replaced by EXTINCT
!  NB      SET TO -1 FOR NO TWINNED DATA, else TO 0 OR 1.                 Replaced by TWINNED and SCALED_FOT
!          (0 MEANS PUT /FOT/ ETC. IN /FO/, WHILE 1 OR GREATER
!           MEANS PUT THE /FO/ AND /FC/ ETC. COMPUTED FOR THE
!           ELEMENT FOR WHICH THE INDICES ARE GIVEN).
!  NC      if GREATER THAN -1, then THE GIVEN PARTIAL CONTRIBUTIONS
!          ARE TO BE USED, else NOT.                                      Replaced by PARTIALS
!  ND      if SET TO -1, then NO NEW PARTIAL CONTRIBUTIONS ARE
!          OUTPUT. if GREATER THAN -1, THE NEW /FC/ ETC. ARE STORED
!          AS THE PARTIAL CONTRIBUTIONS.
!  NE      if GREATER THAN -1, then THE LAYER SCALES ARE APPLIED TO /FO/
!          else NOT.   Replaced by LAYERED
!  NF      if GREATER THAN -1, THE CONTRIBUTORS TO EACH TWINNED REFLECTI
!          ARE PRINTED.
!  JREF_STACK_START      ADDRESS OF THE WORD THAT HOLDS THE ADDRESS OF THE FIRST
!          BLOCK OF THE REFLECTION HOLDING STACK
!  JREF_STACK_PTR  USED TO PASS THROUGH THE REFLECTION HOLDING STACK (NH?)
!  NI      SIMILAR TO NH.
!  NJ      THE VALUE OF THE VARIABLE 'ELEMENTS' FOR EACH REFLECTION.
!  NK      CURRENT VALUE OF 'NJ' FOR EACH REFLECTION .
!  NL      THE ELEMENT OF THE CURRENT REFLECTION
!  NM      THE NUMBER OF REFLECTIONS IN THE STACK USED SO FAR
!  NN      SET TO 0 if NO NEW REFLECTIONS HAVE BEEN INTRODUCED,
!          else THE NUMBER OF NEW REFLECTIONS FOUND
!  NO      DUMP OF 'JO'
!  NP      DUMP OF 'JP'
!  NQ      COUNTER WHEN THE TWIN COMPONENTS ARE BEING COMBINED
!  NR      NUMBER OF WORDS PER SYMMETRY RELATED REFLECTION IN THE
!          REFLECTION HOLDING STACK.
!          THE FORMAT OF THE SYMMETRY RELATED REFLECTION ENTRIES IS :
!
!          0  H TRANSFORMED
!          1  K TRANSFORMED
!          2  L TRANSFORMED
!          3  THE PHASE SHifT FOR THIS GROUP OF INDICES
!
!  NT      THE NUMBER OF REFLECTIONS THAT HAVE BEEN USED
!  NU      -1 FOR XRAYS, AND 0 FOR NEUTRONS  -  ONLY USED FOR EXTINCTION
!  NV      -1 FOR REFINEMENT ON /FO/, else REFINEMENT ON /FO/ **2
!  NW      -1 FOR NO BATCH SCALE APPLICATION, else 0.       Replaced by BATCHED
!
!--THE FORMAT OF THE REFLECTION HOLDING STACK WHICH STARTS AT
!      'ISTORE(NG)' IS :
!
!   0  LINK TO NEXT REFLECTION OR -1000000
!   1  ADDRESS OF THE FIRST WORD OF THE DERIVATIVES W.R.T. /FC/
!   2  ADDRESS OF THE LAST WORD OF THE DERIVATIVES W.R.T. /FC/
!   3  H FOR THE CURRENT REFLECTION                                     
!   4  K FOR THE CURRENT REFLECTION
!   5  L FOR THE CURRENT REFLECTION (ALL IN FLOATING POINT).
!   6  /FC/ FOR THE CURRENT REFLECTION
!   7  PHASE FOR THE CURRENT REFLECTION
!   8  ELEMENT NUMBER WHICH THIS REFLECTION CURRENTLY REPRESENTS.
!   9  ADDRESS OF THE FIRST WORD OF THE FIRST GROUP OF
!      EQUIVALENT INDICES FOR  THIS BLOCK. (THE REFLECTIONS ARE
!      ARE EQUIVALENT TO THOSE INDICES GIVEN IN WORDS 3 TO 5).
!  10  ADDRESS OF THE LAST GROUP OF EQUIVALENT INDICES FOR THIS
!      REFLECTION BLOCK.
!      (EACH EQUIVALENT SET OF INDICES IS 'NR' WORDS LONG).
!  11  PHASE SHIFT NECESSARY FOR THE REFLECTION CURRENTLY USING THIS BLO
!  12  1.0 if FRIEDEL'S LAW HAS NOT BEEN USED FOR THE CURRENT REFLECTION
!  13  real PART OF A FOR THE ORIGINAL REFLECTION
!  14  IMAGINARY PART OF A FOR THE ORIGINAL REFLECTION
!  15  real PART OF B FOR THE ORIGINAL REFLECTION
!  16  IMAGINARY PART OF B FOR THE ORIGINAL REFLECTION
!  17  NOT USED
!  18  ADDRESS OF THE FIRST WORD OF THE DERIVATIVES W.R.T. A, B ETC.
!  19  ADDRESS OF THE LAST WORD OF THE DERIVATIVES W.R.T. TO A, B ETC.
!
!--THE DERIVATIVES FOLLOW THIS INFORMATION.
!
!--NORMALLY, WHEN EACH REFLECTION IS READ FROM THE DISC,
!  IT IS CHECKED AGAINST THOSE ALREADY IN THE STACK TO SEE if ITS
!  A AND B PARTS TOGETHER WITH THEIR DERIVATIVES ARE PRESENT.
!  if THEY ARE NOT PRESENT, then THESE VALUES ARE CALCULATED
!  AND THE INFORMATION SET UP IN THE BLOCK AT THE TOP OF THE STACK.
!  THIS CORRESPONDS TO THE ORIGINAL VALUES IN WORDS 13-16 AND IN THE
!  DERIVATIVES STORED FOR THE A AND B PARTS.
!  ONCE THE VALUES REQUIRED FOR THE CURRENT REFLECTION ARE PRESENT,
!  /FC/ AND ITS DERIVATIVES ARE CALCULATED.
!  (AT THIS STAGE, THE CURRENT REFLECTION MAY CORRESPOND TO THE ORIGINAL
!   REFLECTION OR MAY BE ONE OF ITS EQUIVALENTS FROM THE STACK).
!  THE DERIVATIVES ARE then ADDED TO THE NORMAL EQUATIONS, AFTER
!  MODifICATION FOR EXTINCTION AND REFINEMENT AGAINST /FO/ **2 IF
!  NECESSARY.
!
!--DURING THE PROCESSING OF ONE NOMINAL REFLECTION FOR A TWIN, THE STACK
!  IS SEARCHED FOR EACH ELEMENT IN TURN. if THE ELEMENT HAS
!  ALREADY BEEN CALCULATED, THE BLOCK IS MOVED TO THE TOP OF THE STACK
!  AND CONTROL PASSES TO THE NEXT COMPONENT. if THE ELEMENT OR
!  COMPONENT IS NOT IN THE STACK, THE LAST BLOCK IS SWITCHED TO
!  THE TOP OF THE STACK, AND then ITS A AND B PARTS WITH THEIR DERIVATIV
!  COMPUTED. AT THE END, THE ELEMENT FOR WHICH THE INDICES ARE GIVEN
!  IS LEFT AT THE TOP OF THE STACK AS THIS IS ALWAYS THE LAST
!  ELEMENT PROCESSED.
!  WHEN THE A AND B PARTS HAVE BEEN  FOUND FOR ALL THE ELEMENTS, /FC/
!  AND ITS DERIVATIVES ARE CALCULATED FOR EACH ELEMENT.
!  FOLLOWING THIS, /FCT/ AND ITS DERIVATIVES ARE CALCULATED, AND then AD
!  TO THE NORMAL EQUATIONS.
!
!      PARTIAL DERIVATIVE STACK
!                  FLACK SYMBOL
!      0   F.COS(HX)      A      AC
!      1   F.SIN(HX)      B      BC
!      2  -F".SIN(HX)    -D      ACI
!      3   F".COS(HX)     C      BCI
!
!      FC = (A-D) + I.(B+C)
!
!
!--THE FORMAT OF THE LIST 6 BUFFER AT 'M6' IS :
!
!   0  H
!   1  K
!   2  L (ALL IN FLOATING POINT).
!   3  /FO/
!   4  WEIGHT  -  realLY THE SQUARE ROOT OF THE WEIGHT
!   5  /FC/
!   6  PHASE
!   7  PARTIAL CONTRIBUTION FOR A.
!   8  PARTIAL CONTRIBUTION FOR B.
!   9  T-BAR  -  EXTINCTION TERM FOR THIS REFLECTION.
!  10  /FOT/  -  TOTAL /FO/ FOR A TWINNED STRUCTURE
!  11  THE ELEMENTS OF A TWINNED STRUCTURE.
!
!--USEAGE OF GENERAL VARIABLES
!
!  TC     COEFFICIENT FOR THE ISO-TEMPERATURE FACTORS
!  SST    SIN(THETA)/LAMBDA SQUARED
!  ST     SIN(THETA)/LAMBDA
!  SMAX, SMIN      MAX AND MIN VALUES OF SINTETA/LAMBDA
!  AC     TOTAL real A PART FOR THE REFLECTION
!  BC     TOTAL real B PART FOR THE REFLECTION
!  ACI    TOTAL IMAGINARY A PART FOR THE REFLECTION
!  BCI    TOTAL IMAGINARY B PART FOR THE REFLECTION
!  ACT    TOTAL A PART FOR THE RELFECTION
!  BCT    TOTAL B PART FOR THE REFLECTION
!  ACD    PARTIAL DERIVATIVE WITH RESPECT TO POLARITY PARAMETER
!  BCD    PARTIAL DERIVATIVE WRTO POLARITY PARAMETER
!  ACF    TOTAL PARTIAL DERIV WRTO POLARITY
!  ACN    TOTAL A PART FOR INVERSE STRUCTURE - USED IN ENANTIOPOLE REFIN
!  BCN    TOTAL B PART FOR INVERSE STRUCTURE - USED IN ENANTIOPOLE REFIN
!  ACE    PARTIAL DERIVATIVE FOR ENANTIOPOLE
!  ENANT  ENANTIOPOLE PARAMETER
!  ALPD    PARTIAL DERIVATIVES FOR  EACH ATOM WITH RESPECT TO A
!  BLPD    PARTIAL DERIVATIVES FOR  EACH ATOM WITH RESPECT TO B
!  FO     SCALED FO
!  FC     FC ON ABSOLUTE SCALE
!  P      PHASE ANGLE IN RADIANS
!  W      SQUARE ROOT OF THE WEIGHT FOR THIS RELFECTION
!  DF     DifFERENCE BETWEEN FO AND FC
!  WDF    WEIGHTED DifFERENCE BETWEEN FO AND FC
!  FOT    SUM OF FO
!  FCT    SUM OF FC
!  DFT    SUM OF MOD(DF)
!  AMINF  MINIMIZATION function - SUM WEIGHTED DifFERENCE SQUARED
!  WDFT   MINIMISATION function BASED ONLY ON /FO/.
!  RW     HAMILTON WEIGHTED R VALUE
!  R      NORMAL WEIGHTED R VALUE
!  COSP   COSINE OF THE PHASE ANGLE
!  SINP   SINE OF THE PHASE ANGLE
!  EXT    EXTINCTION PARAMETER (R*)  -  SEE LARSON IN C.C. 1970.
!  LAYER  THE INDEX OF THE CURRENT LAYER AS REQUIRED BY THE LAYER SCALES
!  IBATCH  THE BATCH OF THE CURRENT REFLECTION MINUS ONE.
!  FCEXT  FC CORRECTED FOR EXTINCTION EFFECTS.
!  FCEXS  FCEXT CORRECTED FOR THE SCALE FACTOR
!  EXT1   (1 + 2*(R*)* /FC/ **2*DELTA)
!  EXT2   (1 + (R*)* /FC/ **2*DELTA)
!  EXT3   EXT1/EXT2
!  WAVE   THE WAVELENGTH OF THE RADIATION USED TO COLLECT THE DATA
!  THETA1 THE MONOCHROMATOR BRAGG ANGLE
!  THETA2 THE ANGLE BETWEEN THE MONOCHROMATOR AND THE DifFRACTING PLANES
!  POL1   FIRST PART OF THE POLARISATION CORRECTION
!  POL2   THE SECOND PART OF THE POLARISATION CORRECTION
!  DEL    THE FIXED PART OF DELTA
!  DELTA  THE EXTINCTION MULTILPLIER  -  SEE LARSON.
!
!  PH, PK AND PL ARE A DUMP OF THE NOMINAL INDICES FOR A TWIN.
!
!  SH, SK AND SL ARE THE INDICES OF A TWINNED REFLECTION IN THE
!        STANDARD SETTING.
!
!--THE VARIOUS SCALE FACTORS USED ARE :
!
!  SCALEO  THE OVERALL SCALE FACTOR FROM LIST 5.
!          'SCALEO' IS ASSUMED NOT TO BE ZERO.
!  SCALEL  THE LAYER SCALE FACTOR FOR THE CURRENT LAYER  -  THIS
!          SCALE MAY BE ZERO if REQUIRED.
!  SCALEB  THE BATCH SCALE FACTOR FOR THE CURRENT REFLECTION  -  THIS
!          SCALE MAY BE ZERO if REQUIRED.
!  SCALES  THE SCALE FACTOR TO BE USED WHEN STORING /FC/.
!          THIS EQUALS SCALEL*SCALEB, SINCE 'SCALEO' IS NOT APPLIED TO /
!  SCALEG  THE COMBINED /FC/ SCALE FACTOR (=SCALEO*SCALEL*SCALEB).
!          'SCALEG' WILL BE ZERO if 'SCALEL' OR 'SCALEB' IS ZERO.
!  SCALEK  THE OVERALL /FO/ SCALE FACTOR (=1.0/SCALEG, UNLESS
!          'SCALEG' IS ZERO, WHEN 'SCALEK' IS SET TO 1.0).
!  SCALEW  SCALEG*W
!
!--if 'SCALEL' IS ZERO, ITS DERIVATIVE IS CALCULATED CORRECTLY,
!  BUT ALL OTHER DERIVATIVES FOR THAT REFLECTION WILL BE ZERO.
!
!
!--ALL DERIVATIVES ARE INTIALLY COMPUTED ON THE SCALE OF /FC/, AND then
!  ON THE CORRECT SCALE (THAT OF /FO/) WHEN THE A AND B PARTS ARE ADDED
!  TOGETHER AND THE WEIGHTS APPLIED.
!
!--THE DERIVATIVES FOR THE OVERALL SCALE FACTORS ARE COMPUTED SEPARATELY
!  OTHER OVERALL PARAMETERS.
!
!----- PARTIAL DERIVATIVE RELATIONSHIPS
!
!      FTSQ  = (1-X)*FP**2 + X*FN**2
!      where FPSQ is for the given index, and FNSQ for its Friedel inver
!
!      dFTSQ = 2*FP*(1-X)*dFP + 2*FN*X*dFN
!
!      dFT   = (FP/FT)*(1-X)*dFP   +    (FN/FT)*dFN
!
!            COSA := (1-X)*FP/FT,       SINA := X*FN/FT
!
!      FPSQ  = Q**2 + S**2,             FNSQ = QN**2 + SN**2
!
!      dFP   = (Q/FP)*dQ + (S/FP)*dS,   dFN   = (QN/FN)*dQN + (SN/FN)*dS
!
!           COSP := Q/FP, SINP := S/FP, COSPN := QN/FN, SINPN := SN/FN
!
!            Q = A-D, S = B+C,          QN = A+D, SN = -B+C
!
!            AC := A, ACI := -D, BC := B, BCI = C
!
!            ACT := Q, BCT := S,        ACN := QN, BCN := SN
!
!      dQ/dp = dA/dp - dD/dp,           dQN/dp =  dA/dp + dD/dp
!      dS/dp = dB/dp + dC/dp,           dSN/dp = -dB/dp + dC/dp

!include 'TYPE11.INC'
!include 'XSTR11.INC'
use xstr11_mod, only: str11 => xstr11
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store, istore, nfl, storelength
!include 'XSFWK.INC90'
use xsfwk_mod, only: r, p, s, w, rw, scale, scalew, scalek, ienprt, smin, smax
use xsfwk_mod, only: st, sst, theta1, theta2, tc, wdf, wave, rall, wdft, fo, fc
use xsfwk_mod, only: enant, df, d, cenant, c, bct, bcn, anom, aminf
use xsfwk_mod, only: act, acn, acf, ace, a
!include 'XWORKB.INC'
use xworkb_mod, only: nv, nu, nr, nt, nl, nf, nd, jr, jq, jp, jo, cycle_number=>ji
!include 'XSFLSW.INC90'
use xsflsw_mod, only: wsfofc, wsfcfc, sfofc, sfcfc
use xsflsw_mod, only: sfls_type, sfls_scale, sfls_refine, sfls_calc, cos_only, centro, batched
use xsflsw_mod, only: twinned, scaled_fot, refprint, partials, newlhs, layered, extinct
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu, ncfpu2, ncfpu1
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST01.INC90'
use xlst01_mod, only: l1p1
!include 'XLST02.INC90'
use xlst02_mod, only: n2p, m2p, l2p, ic, g2, l2, md2, n2, symm_operators
!include 'XLST03.INC90' Not used!
!include 'XLST05.INC90'
use xlst05_mod, only: m5ls, m5es, m5bs, m5ls, l5o, l5ls, l5es, l5bs
!include 'XLST06.INC90'
use xlst06_mod!, only: m6, l6p, md6
!include 'XLST11.INC90'
use xlst11_mod, only: n11, l11r, l11, n11r
!include 'XLST12.INC90'
use xlst12_mod, only: n12b, n12, md12b, m12, l12o, l12ls, l12es, l12bs, l12b, md12a
!include 'XLST25.INC'
use xlst25_mod, only: n25, md25, m25, l25
!include 'XLST28.INC90'
use xlst28_mod, only: n28mn, md28mn, m28mn, l28mn
!include 'XLST33.INC90'
use xlst33_mod, only: m33cd
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
use xconst_mod, only: pi, zero, zerosq

implicit none

interface
    subroutine xab2fc(reflectiondata, scalew, partialderivatives,temporaryderivatives)
        implicit none
        real, intent(in) :: scalew
        real, dimension(:), intent(inout) :: reflectiondata
        double precision, dimension(:), intent(out) :: partialderivatives
        double precision, dimension(:), intent(in) :: temporaryderivatives
    end subroutine
end interface

interface
    subroutine XSFLSX(acd, bcd, ac, bc, nn, nm, tc, sst, smin, smax, nl, nr, jo, jp, &
    &   g2, m12, md12a, reflectiondata, temporaryderivatives)
        implicit none
        real, intent(out) :: ACD, BCD, tc, sst
        real, intent(inout) :: smin, smax, bc, ac, g2
        real, dimension(:), intent(inout) :: reflectiondata
        integer, intent(inout) :: nn, nm
        integer, intent(in) :: nl, nr, jo, jp
        integer, intent(out) :: m12, md12a
        double precision, dimension(:), intent(out) :: temporaryderivatives
    end subroutine
end interface

interface
    subroutine XADDPD ( A, JX, JO, JQ, JR, md12a, m12, partialderivatives) 
        implicit none 
        real, intent(in) :: a
        integer, intent(in) :: jx, jo, jq, jr
        integer, intent(inout) :: md12a, m12
        double precision, dimension(:), intent(out) :: partialderivatives
    end subroutine
end interface

interface
    integer function klayernew(dummy, ierflg)
        implicit none 
        integer, intent(in) :: dummy
        integer, intent(out) :: ierflg
    end function
end interface

interface
    SUBROUTINE XACRT(IPOSN, minimum, maximum, summation, summationsq, reflectiondata)
    implicit none
    integer, intent(in) :: iposn
    real, dimension(:), intent(inout):: minimum, maximum
    real, dimension(:), intent(inout):: summation, summationsq
    real, dimension(:), intent(in) :: reflectiondata
    end subroutine
end interface

interface
    subroutine XSLRnew(reflectiondata, store, l6w, n6w)
    implicit none
    real, dimension(:), intent(inout) :: store, reflectiondata
    integer, intent(in) :: l6w, n6w
    end subroutine
end interface

interface
    subroutine xadrhs(wdf, derivs, rmat11)
    implicit none
    double precision, dimension(:), intent(in) :: DERIVS
    double precision, dimension(:), intent(inout) :: RMAT11
    real wdf
    end subroutine
end interface

!include 'QSTORE.INC'
!include 'QSTR11.INC' equivalence not needed

!-C-C-AGREEMENT OF CONSTANTS AND VARIABLES
!-C-C-...FOR FLAG TO DECIDE BETWEEN KIND OF ATOM
!      real FLAG
!

integer, intent(in) :: nderiv, nresults
real, dimension(nderiv), intent(in) :: DERIVS
integer, dimension(NRESULTS), intent(in) :: IRESULTS  !Parameter list if there is one
integer, intent(out) :: ierflg

!
character(len=15) :: hkllab
character(len=256) :: formatstr
integer i, ibadr, iallow,  ibl, ibs, ifnr, ihkllen, ilevpr
integer ixap, ibatch, i28mn, jxap, jsort, ljs, ljt
integer lju, ljv, ljx, lsort, ltempl, ltempr, msort
integer mnr, mdsort, mdleve, mb, layer, k, j, nsort
integer ntempl, nq, np, no, ntempr, nk, nj, n, mstr, ni
integer dummy
real pk, pii, ph, path, fot, scaleb, savsig, rlevnm, redmax, red
real rdjw, pol2, pol1, pl, sh
real g2sav, fcext, fcexs, ext4, ext3, ext2, ext1, ext
real dft, delta, del, foabs, fct, xvalur, xvalul, wj
real vj, uj, tix, time_begin, time_end, t, sl, sk, sfo, sfc
real scales, scaleq, scalel, scaleg, scaleo, rlevdn

integer, external :: klayer, kbatch, kallow, kfnr, KFNRnew, kchnfl
real, external :: pdolev
real, dimension(5) :: tempr

! variable moved from common block to local
real acd, bcd, ac, bc
integer nm, nn, l12a
!
!
#if defined(_GIL_) || defined(_LIN_)
integer :: starttime
integer, dimension(8) :: measuredtime
#endif

! Accumulation is done is double precision to avoid precision loss
! single precision seems to introduce errors of about 1e-3 in Fc and 
! other parameters
double precision, dimension(:,:), allocatable :: designmatrix
double precision, dimension(:,:,:), allocatable :: normalmatrix!, ref
! tid is the number of threads
integer :: designindex, tid
integer, parameter :: storechunk=2048
character(len=4) :: buffer

!> Buffer holding reflections data of several reflections
!! reflectionsdata_size reflections stored by columns (md6 values from m6 in original store)
real, dimension(:,:), allocatable :: reflectionsdata
integer, dimension(:), allocatable :: batches, layers, l6wpointers, n6wpointers
!> Number of reflections stores in the reflectionsdata buffer
integer reflectionsdata_size
!> Current index in the reflectionsdata buffer
integer reflectionsdata_index
real, dimension(16) ::  minimum_shared, maximum_shared, summation, summationsq
real, dimension(16) ::  minimum, maximum
real, dimension(:), allocatable :: shiftsaccumulation
integer iposn

real, dimension(:), allocatable :: storetemp
integer, dimension(:), allocatable :: istoretemp
double precision, dimension(:), allocatable :: righthandside
integer cpt

double precision, dimension(:), allocatable :: temporaryderivatives

ierflg = 0

call CPU_TIME ( time_begin )

!------ SET MIN AND MAX SIN THETA/LAMBDA
SMAX=0.
SMIN=1./WAVE
!----- A BUFFER FOR ONE REFELCTION AND ITS R FACTOR
LTEMPR = NFL
NTEMPR = 7
NFL = KCHNFL(NTEMPR)
!----- INITIALISE THE SORT BUFFER
JSORT = -5
MDSORT = NTEMPR
NSORT = 30
call SRTDWN(LSORT,MDSORT,NSORT, JSORT, LTEMPR, XVALUR,0)
JSORT = 5 ! useless, if jsort<0, on return jsort is abs(jsort)


!----- SET PRINT COUNTER
IENPRT = -1
ILEVPR = 0
!----- SET BAD R FACTOR COUNTER
IBADR = -1
!--INITIALISE THE TIMING function
CENTRO = .FALSE.
if ( IC .EQ. 1 ) CENTRO = .TRUE.
!      JD=-IC
D=180.0/PI
COS_ONLY = .FALSE.

if(CENTRO)THEN        ! CHECK IF THIS STRUCTURE IS CENTRO
    if (SFLS_TYPE .NE. SFLS_REFINE) then  ! CHECK IF WE ARE DOING REFINEMENT
        COS_ONLY = .TRUE.  ! CENTRO WITH NO REFINEMENT  -  ONLY COS TERMS NEEDED
    end if
end if

!--CLEAR THE VARIABLES FOR HOLDING THE OVERALL TOTALS
!----- GET THE OLD R FACTOR AND SET PRINT RATIO
R = STORE(L6P+1) * .01 *3.
RW=0.0
FOABS = 0.0
FOT=0.0
FCT=0.0
DFT=0.0
WDFT=0.0
AMINF=0.
SFO=0.0
SFC=0.0
sfofc=0.0
sfcfc=0.0
wsfofc=0.0
wsfcfc=0.0
NT=0
ACE=0.
ACF = 0.
!----- OVERALL SCALE
SCALEO=STORE(L5O)
!----- ENANTIOPOLE PARAMETER
ENANT = STORE(L5O+4)
CENANT  =  (1.- ENANT)
!----- POLARITY PARAMETER
ANOM = STORE(L5O+3)
!--SET UP THE EXTINCTION VARIABLE
EXT=0.
EXT1=1.0
EXT2=1.0
EXT3=1.0
DELTA=0.

if(EXTINCT)THEN   ! THE EXTINCTION PARAMETER IN LIST 5 SHOULD BE USED
    EXT=STORE(L5O+5)
    POL1=1.
    POL2=0.
    DEL=WAVE*WAVE/(STORE(L1P1+6)*STORE(L1P1+6))
    if(NU.LT.0) then   ! CHECK IF WE ARE USING NEUTRONS OR XRAYS
!--WE ARE USING XRAYS
        DEL=DEL*WAVE*0.0794
!  SET UP THE POLARISATION CONSTANTS
        THETA2=THETA2/D !  D converts from degrees to radians
        A=COS(THETA2)
        C=SIN(THETA2)
        S=COS(THETA1/D)
        A=A*A
        C=C*C
        S=S*S
        POL1=A+C*S
!djwoct2010 POL2 had found itself outside of the if clause
        POL2=C+A*S
    end if
end if

!--CHECK if A PRINT IS REQUIRED
if(REFPRINT) then 
    if (ISSPRT .EQ. 0)  write(NCWU,1750)
1750      FORMAT(/7X,'H',5X,'K',5X,'L',6X,'/FO/',5X,'/FC/',4X,'Phase', &
    &   5X,'Delta    SQRT(W)*Delta',2X,'/FC''/',2X,'/FC''''/', &
    &   2X,'D/F/ **2', 1X,'T.B.R.(%)',2X,'SINTH/L/')
end if

NO=JO
NP=JP

#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
starttime=((measuredtime(5)*3600+measuredtime(6)*60)+measuredtime(7))*1000+measuredtime(8)
#endif
 
    
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!Begin big loop
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

!     Working out the number of threads available
tid=1
!$    tid =  omp_get_max_threads() 

!     To be replaced by GET_ENVIRONMENT_VARIABLE f2003 feature
!     getenv is a deprecated extension      
CALL GETENV('OMP_NUM_THREADS', buffer) 
if(buffer/='    ') then
    read(buffer, '(I4)') i
    if(i>0) then
        tid=i
    end if
end if

allocate(normalmatrix(JP-JO+1,JP-JO+1, tid))
allocate(designmatrix(JP-JO+1,storechunk*tid))
allocate(reflectionsdata(MD6+6,storechunk*tid))
!md6+1 ac
!md6+2 aci
!md6+3 bc
!md6+4 bci
!md6+5 pshift
!md6+6 fried

reflectionsdata=0.0
allocate(layers(storechunk*tid))
allocate(batches(storechunk*tid))
allocate(l6wpointers(storechunk*tid))
allocate(n6wpointers(storechunk*tid))

layers=-1 ! SET THE LAYER SCALING CONSTANTS INITIALLY
batches=-1
n6w=-1
l6w=l6w-md6w

normalmatrix=0.0
minimum_shared=huge(minimum_shared)
maximum_shared=-huge(maximum_shared)
if(ND<0)THEN
    minimum_shared(8:9)=0.0
    maximum_shared(8:9)=0.0
end if   
summation=0.0
summationsq=0.0
allocate(shiftsaccumulation(JP-JO+1))
shiftsaccumulation=0.0
!print *, ubound(shiftsaccumulation_indices, 1)
      
allocate(storetemp(storelength))
allocate(istoretemp(storelength))
allocate(righthandside(n11r))
righthandside=0.0d0

storetemp=store
istoretemp=istore

! Caching symmetry operators
if(allocated(symm_operators)) deallocate(symm_operators)
allocate(symm_operators(md2,n2))
do i=1, N2
    symm_operators(:,i)=store(l2+(i-1)*md2:l2+i*md2-1)
end do

cpt=0
reflectionsdata_size=1
do WHILE (reflectionsdata_size>0)  ! START OF THE LOOP OVER REFLECTIONS

do reflectionsdata_index=1, storechunk*tid
    if( SFLS_TYPE .EQ. SFLS_CALC ) then
    ! Remove I/sigma(I) cutoff, temporarily, leaving all other filters
    ! in place.
        do I28MN = L28MN,L28MN+((N28MN-1)*MD28MN),MD28MN
            if(ISTORE(I28MN)-M6.EQ.20) then
                SAVSIG = STORE(I28MN+1)
                STORE(I28MN+1) = -99999.0
            end if
        end do
    ! Fetch reflection using all other filters:
        ifNR = KFNRnew(1, l6w, n6w, reflectionsdata(:,reflectionsdata_index))
    ! Put sigma filter back:
        do I28MN = L28MN,M28MN,MD28MN
            if(ISTORE(I28MN)-M6.EQ.20) then
                STORE(I28MN+1) = SAVSIG
            end if
        end do
    else
        ifNR = KFNRnew(1, l6w, n6w, reflectionsdata(:,reflectionsdata_index))
    end if
    if(ifnr>=0) then
        !print *, 's', reflectionsdata(:,reflectionsdata_index)
        !store(m6:m6+md6-1)=reflectionsdata(:,reflectionsdata_index)
        l6wpointers(reflectionsdata_index)=l6w
        n6wpointers(reflectionsdata_index)=n6w

        if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
            layers(reflectionsdata_index)=KLAYERnew(dummy, ierflg)  ! FIND THE LAYER NUMBER AND SET ITS VALUE
            if ( IERFLG .LT. 0 ) return ! GO TO 19900
        end if    
    
        if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
            batches(reflectionsdata_index)=KBATCH(dummy)  ! FIND THE BATCH NUMBER AND SET THE SCALE
            if ( IERFLG .LT. 0 ) return !GO TO 19900
        end if    
    
    else
        exit
    end if
end do
reflectionsdata_size=reflectionsdata_index-1
if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
    layers=layers+L5LS-1
end if
if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
    batches=batches+m5bs-1
end if
designmatrix=0.0

!$OMP PARALLEL default(none)&
!$OMP& shared(nP, nO, layered, str11) &
!$OMP& shared(batched,twinned, reflectionsdata_size) &
!$OMP& shared(reflectionsdata, layers, batches, scaleo, partials, nr) &
!$OMP& shared(issprt, ncwu, md6, n12) &
!$OMP& shared(sfls_type, extinct, wave, l12es, jr, jq, del, nu) &
!$OMP& shared(pol1, pol2, ext, nd, nv, iallow, xvalur,LTEMPR, nsort, mdsort) &
!$OMP& shared(refprint, l12o, l12ls, l12bs, m33cd, ncfpu1, ncfpu2) &
!$OMP& shared(newlhs, l11, l12b, n12b, md12b, nresults, iresults, n11) &
!$OMP& shared(ltempl, designmatrix, normalmatrix, store, istore) &
!$OMP& shared(l6wpointers, n6wpointers, l6w, n6w) &
!$OMP& shared(ILEVPR, ibadr) &  ! atomic
!$OMP& firstprivate(rall, m12, smin, smax, g2, l5es, d) &
!$OMP& firstprivate(jsort, lsort, r, designindex, red, tix, hkllab, ihkllen, ext3) &
!$OMP& firstprivate(jp,jo) &
!$OMP& private(M5LS, layer, ibatch, ierflg, w, nm, nn, md12a) &
!$OMP& private(scalek,scales,scalel, scaleb,scaleg,act,bct,acn,bcn,fo,fc,scalew,nl) &
!$OMP& private(tc, bc, ac, bcd, acd, acf, ace, p, sst) &
!$OMP& private(ljx, temporaryderivatives) &
!$OMP& private(tempr, m5bs, a, fcext) &
!$OMP& private(path, delta, c, ext1, ext2, ext4, fcexs, df, wdf) &
!$OMP& private(minimum, maximum, s, uj, rdjw, vj, wj, t, tid) &
!$OMP& shared(minimum_shared, maximum_shared) &
!$OMP& reduction(max:REDMAX) &
!$OMP& reduction(+: summation, summationsq, nt, fot, foabs, shiftsaccumulation) &
!$OMP& reduction(+: fct, dft, wdft, rw, sfofc, sfcfc, wsfofc, wsfcfc) &
!$OMP& reduction(+: sfo, sfc, righthandside, aminf) 
    
    minimum=huge(minimum)
    maximum=-huge(maximum)
    if(ND<0)THEN
        minimum(8:9)=0.0
        maximum(8:9)=0.0
    end if    

    allocate(temporaryderivatives(n12*jq))
    temporaryderivatives=0.0d0

!$OMP DO
    do reflectionsdata_index=1, reflectionsdata_size
    !storetemp(M6:M6+MD6-1)=reflectionsdata(:,reflectionsdata_index)
    !print *, storetemp(M6:M6+MD6-1)

    if(LAYERED)THEN   ! CHECK IF THIS SCALE IS TO BE USED
        M5LS=layers(reflectionsdata_index)
        SCALEL=store(M5LS)
    else
        SCALEL=1.0
    end if

    if(BATCHED) then ! CHECK IF THE BATCH SCALE FACTOR SHOULD BE USED
        M5BS=batches(reflectionsdata_index)
        SCALEB=store(M5BS)
    else
        scaleb=1.0
    end if

    SCALEK=1.   ! SET UP THE SCALE FACTORS CORRECTLY
    SCALES=SCALEL*SCALEB
    SCALEG=SCALEO*SCALES

    if(SCALEG .GT. 1e-6) then   ! CHECK IF THE SCALE IS ZERO
        SCALEK=1./SCALEG   ! THE /FC/ SCALE FACTOR IS NOT ZERO  -  COMPUTE THE /FO/ SCALE FACTOR
    end if

    ACT = reflectionsdata(1+7,reflectionsdata_index) 
    BCT = reflectionsdata(1+8,reflectionsdata_index) 

    FO=reflectionsdata(1+3,reflectionsdata_index) ! SET UP /FO/ ETC. FOR THIS REFLECTION
    W=reflectionsdata(1+4,reflectionsdata_index) 
    SCALEW=SCALEG*W
 
    NM=0  ! INITIALISE THE HOLDING STACK, DUMP ENTRIES
    NN=0
    JO=NO  ! Point JO back to beginning of PD list.
    JP=NP
    
!       CHECK if THIS IS TWINNED CALCULATION
    if(.NOT.TWINNED)THEN   ! NOT TWINNED
        NL=0
        call XSFLSX(acd, bcd, ac, bc, nn, nm, tc, sst, smin, smax, nl, nr, jo, jp, &
        &   g2, m12, md12a, reflectionsdata(:,reflectionsdata_index), temporaryderivatives )
        
        call XAB2FC(reflectionsdata(:,reflectionsdata_index), scalew, designmatrix(:,reflectionsdata_index), temporaryderivatives)  ! DERIVE THE TOTALS AGAINST /FC/ FROM THOSE W.R.T. A AND B
        call XACRT(4, minimum, maximum, summation, summationsq, reflectionsdata(:,reflectionsdata_index))  ! ACCUMULATE THE /FO/ TOTALS
    else ! THIS IS A TWINNED CALCULATION  
        print *, 'Not implemented'
        stop
    end if
!
!--CHECK if WE SHOULD include EXTINCTION
    if(EXTINCT)THEN ! WE SHOULD include EXTINCTION
        A=MIN(1.,WAVE*sqrt(sST))
        !A=ASIN(A)*2.
        PATH=reflectionsdata(1+9,reflectionsdata_index)  ! CHECK MEAN PATH LENGTH
        if(PATH.LE.ZERO) PATH = 1.
        !DELTA=DEL*PATH/SIN(A)  ! COMPUTE DELTA FOR NEUTRONS
        ! sin(a) = sin(sin-1(a)*2.0) (see above)
        ! equivalent to 2*a*sqrt(1-a**)
        DELTA=DEL*PATH/(2.0*a*sqrt(1.0-a**2))
        if(NU.LT.0)THEN ! WE ARE USING XRAYS
            ! cos(a) = cos(sin-1(a)*2.0) (see above)
            ! equivalent to 1-2a**2
            !A=COS(A)**2
            A=1.0-2.0*a**2
            DELTA=DELTA*(POL1+POL2*A*A)/(POL1+POL2*A)
        end if
        EXT1=1.+2.*EXT*reflectionsdata(1+5,reflectionsdata_index)**2*DELTA
        EXT2=1.0+EXT*reflectionsdata(1+5,reflectionsdata_index)**2*DELTA
        EXT3=EXT2/(EXT1**(1.25))
        EXT4=(EXT1**(-.25))
        FCEXT=reflectionsdata(1+5,reflectionsdata_index)*EXT4   ! COMPUTE THE MODifIED /FC/
    else
        EXT4=1.
        FCEXT=reflectionsdata(1+5,reflectionsdata_index)
    end if
!
    FCEXS=FCEXT*SCALEG ! THE VALUE OF /FC/ AFTER SCALE FACTOR APPLIED
!

    if(TWINNED)THEN 
        ! broken
        !reflectionsdata(1+5,reflectionsdata_index)=reflectionsdata(1+5,reflectionsdata_index)*EXT4*SCALES
        stop
    else
        reflectionsdata(1+5,reflectionsdata_index)=FCEXT*SCALES ! STORE FC AND PHASE IN THE LIST 6 SLOTS
    end if
    !reflectionsdata(1+6,reflectionsdata_index)=P
!
    if(ND.GE.0)THEN ! CHECK IF THE PARTIAL CONTRIBUTIONS ARE TO BE OUTPUT
        reflectionsdata(1+7,reflectionsdata_index)=reflectionsdata(1+7,reflectionsdata_index) + &
        &   reflectionsdata(MD6+1,reflectionsdata_index) + &
        &   reflectionsdata(MD6+2,reflectionsdata_index)*reflectionsdata(MD6+6,reflectionsdata_index) ! STORE THE NEW CONTRIBUTIONS
        reflectionsdata(1+8,reflectionsdata_index)=reflectionsdata(1+8,reflectionsdata_index) + &
        &   reflectionsdata(MD6+3,reflectionsdata_index)*reflectionsdata(MD6+6,reflectionsdata_index) + &
        &   reflectionsdata(MD6+4,reflectionsdata_index)

        call XACRT(8, minimum, maximum, summation, summationsq, reflectionsdata(:,reflectionsdata_index))  ! ACCUMULATE THE TOTALS FOR THE NEW PARTS
        call XACRT(9, minimum, maximum, summation, summationsq, reflectionsdata(:,reflectionsdata_index))
    end if

!        A=FO*W    ! ADD IN THE COMPUTED VALUES OF /FC/ ETC., TO THE OVERALL TOTALS
! Add abs to deniminator
    A=abs(FO)*W    ! ADD IN THE COMPUTED VALUES OF /FC/ ETC., TO THE OVERALL TOTALS
    DF=FO-FCEXS
    WDF=W*DF
    S=SCALEK
!
    if(NV.GE.0)THEN ! 4500,4450,4450 ! CHECK IF WE REFINING AGAINST /FO/ **2
!          A=ABS(FO)*FO*W  ! COMPUTE W-DELTA FOR /FO/ **2 REFINEMENT
! remove abs Mar2009
        A=FO*FO*W  ! COMPUTE W-DELTA FOR /FO/ **2 REFINEMENT
        DF=ABS(FO)*FO-FCEXS*FCEXS
        WDF=W*DF
        S=SCALEK*SCALEK
    end if
    AMINF=AMINF+WDF*WDF  ! COMPUTE THE MINIMISATION function

    if ((SFLS_TYPE.NE.SFLS_CALC) .OR.(KALLOW(IALLOW).GE.0)) then
! If #CALC, then L28 was adjusted earlier. Call KALLOW again to get normal R
!$OMP ATOMIC        
        NT=NT+1     ! UPDATE THE REFLECTION COUNTER FLAG
        FOT=FOT+FO   ! COMPUTE THE TERMS FOR THE NORMAL R-VALUE
        FOABS = FOABS + ABS(FO)
        FCT=FCT+FCEXS
        DFT=DFT+ABS(ABS(FO) - FCEXS)
        WDFT=WDFT+WDF*WDF  ! COMPUTE THE TERMS FOR THE WEIGHTED R-VALUE
        RW=RW+A*A
        sfofc = sfofc + fo * fcext
        sfcfc = sfcfc + fcext * fcext
        wsfofc = wsfofc + w * fo * fcext
        wsfcfc = wsfcfc + w * fcext * fcext
    end if
!
!
    UJ=FO*SCALEK
    RDJW = ABS(WDF)
    if (RDJW .GT. ABS(XVALUR)) then
!----  H,K,L,FO,FC,/WDELTA/,FO/FC
!$OMP CRITICAL        
        call XMOVE(reflectionsdata(1:3,reflectionsdata_index), store(LTEMPR), 3)
        store(LTEMPR+3) = UJ
        store(LTEMPR+4) = FCEXT
        store(LTEMPR+5) = RDJW
        store(LTEMPR+6) = MIN(99., UJ / MAX(FCEXT , ZERO))
        call SRTDWNnew(LSORT,MDSORT,NSORT, JSORT, LTEMPR, XVALUR, 0, store)
!$OMP END CRITICAL
    end if
  
    if(REFPRINT)THEN !   CHECK IF A PRINT OF THE RELFECTIONS IS NEEDED
        P=P*D             ! PRINT ALL REFLECTIONS
        VJ=WDF*S
        WJ=DF*S
        !A=SQRT(AC*AC+BC*BC)
        A=sqrt(reflectionsdata(MD6+1, reflectionsdata_index)**2 + reflectionsdata(MD6+3,reflectionsdata_index)**2)
        !S=SQRT(ACI*ACI+BCI*BCI)
        S=sqrt(reflectionsdata(MD6+2, reflectionsdata_index)**2 + reflectionsdata(MD6+4,reflectionsdata_index)**2)
        T=4.*(reflectionsdata(MD6+3,reflectionsdata_index)*reflectionsdata(MD6+4,reflectionsdata_index) + &
        &   reflectionsdata(MD6+1, reflectionsdata_index)*reflectionsdata(MD6+2, reflectionsdata_index))
        C=T*200.0/(2.*reflectionsdata(1+5,reflectionsdata_index)**2-T)
        if (ISSPRT .EQ. 0) then 
            write(NCWU,4600) reflectionsdata(1,reflectionsdata_index), &
            &   reflectionsdata(1+1,reflectionsdata_index), &
            &   reflectionsdata(1+2,reflectionsdata_index),UJ,FCEXT,P,WJ,VJ,A,S,T,C,sqrt(sST)
        end if
4600    FORMAT(3X,3F6.0,3F9.1,E13.4,E13.4,F8.1,F8.1,F9.1,F10.1,F10.5)
!
    else   ! Only print worst 25 agreements.
        if ( ABS(UJ-FCEXT) .GE. R*UJ .AND. IBADR .LE. 50 ) then
            if (IBADR .LT. 0) then
                if (ISSPRT .EQ. 0) write(NCWU,4651)
!$OMP CRITICAL
                    IBADR = 0
!$OMP END CRITICAL
4651                FORMAT(10X,' Bad agreements ',/ &
                    &   /1X,'   h    k    l      Fo        Fc '/)
                else if (IBADR .LT. 25) then
                    if (ISSPRT .EQ. 0) then
                        write(NCWU,4652) reflectionsdata(1,reflectionsdata_index), &
                        &   reflectionsdata(1+1,reflectionsdata_index), &
                        &   reflectionsdata(1+2,reflectionsdata_index),UJ,FCEXT
                    end if
4652                FORMAT(1X,3F5.0,2F9.2)
                    else if (IBADR .EQ. 25) then
                        if (ISSPRT .EQ. 0) write(NCWU,4653)
4653                    FORMAT(/' And so on ------------'/)
                    end if
!$OMP ATOMIC                
                    IBADR = IBADR + 1
                end if
            end if

            if(SFLS_TYPE .NE. SFLS_REFINE)THEN    ! NO REFINEMENT
                if(SFLS_TYPE .EQ. SFLS_SCALE)THEN ! CHECK IF WE ARE REFINING ONLY THE SCALE FACTOR
 
!--COMPUTE THE TOTALS FOR REFINEMENT OF THE SCALE FACTOR ONLY
                    A=W*SCALES*FCEXT
                    if(NV.GE.0) A=A*SCALES*FCEXT  ! IF WE ARE REFINING AGAINST /FO/ **2

! Originally, CRYSTALS computed the scale wrt F, but this is non-linear,
! so convergence was poor. Now the shifts are wrt F**2. This is taken car
! of when the shift is applied. See near label 6100.

                    SFO=SFO+WDF*A   ! ACCUMULATE THE TERMS FOR THE SCALE FACTOR
                    SFC=SFC+A*A
                end if
            else

!--ADD THE CONTRIBUTIONS OF THE OVERALL PARAMETERS AND SCALE FACTORS.
!  THESE ARE COMPUTED WITH RESPECT TO 'FC' MODifIED FOR EXTINCTION, RATH
!  THAN WITH RESPECT TO 'FC'. THIS IS WHY THEY ALL CONTAIN '1./EXT3'
!  TERM WHICH IS REMOVED LATER WHEN THE DERIVATIVES ARE MODifIED FOR
!  EXTINCTION. THE FIRST PARAMETER IS THE OVERALL SCALE FACTOR.

            A=W*FCEXT*SCALES/EXT3

!---- TO REFINE SCALE OF F**2 (RATHER THAN F), SQUARE AND
!      TAKE OUT THE CORRECTION FACTOR TO BE APPLIED LATER, NEAR LABEL 5300

            if(NV .GE. 0) A = A * FCEXT * SCALES / ( 2. * FCEXS )
            LJX=0
            M12=L12O

            call XADDPD ( A, 0, JO, JQ, JR, md12a, m12, designmatrix(:,reflectionsdata_index))

            A=W*FCEXS*TC/EXT3       ! OVERALL TEMPERATURE FACTORS NEXT
            call XADDPD ( A, 1, JO, JQ, JR, md12a, m12, designmatrix(:,reflectionsdata_index)) 
            call XADDPD ( A, 2, JO, JQ, JR, md12a, m12, designmatrix(:,reflectionsdata_index)) 
 
            A=-0.5*SCALEW*FC*FC*FC*DELTA/EXT2   ! NOW THE EXTINCTION PARAMETER DERIVED BY LARSON
            call XADDPD ( A, 5, JO, JQ, JR, md12a, m12, designmatrix(:,reflectionsdata_index)) 
 
            if(LAYER.GE.0) then                 ! CHECK IF LAYER SCALES ARE BEING USED
                A=W*SCALEO*SCALEB*FCEXT/EXT3
                M12=L12LS
                call XADDPD ( A, LAYER, JO, JQ, JR, md12a, m12, designmatrix(:,reflectionsdata_index))  ! THE LAYER SCALES
            end if

            if(IBATCH.GE.0) then           ! CHECK IF BATCH SCALES ARE BEING USED
                A=W*SCALEO*SCALEL*FCEXT/EXT3
                M12=L12BS
                call XADDPD ( A, IBATCH, JO, JQ, JR, md12a, m12, designmatrix(:,reflectionsdata_index))  ! THE BATCH SCALES  
            end if

            if ( ( NV.GE.0 ) .OR. EXTINCT ) then  ! Either FO^2, or extinction correction required.
                if ( NV .GE. 0 ) designmatrix(:,reflectionsdata_index)=designmatrix(:,reflectionsdata_index)*2.0*FCEXS   ! Correct derivatives for refinement against Fo^2
                if ( EXTINCT ) designmatrix(:,reflectionsdata_index)=designmatrix(:,reflectionsdata_index)*EXT3      ! Modify for extinction
            end if

            ! ACCUMULATE THE RIGHT HAND SIDES
            ! accumulation done in double precision
            call XADRHS(WDF,designmatrix(:,reflectionsdata_index),righthandside)  

            if(NEWLHS)THEN   ! ACCUMULATE THE LEFT HAND SIDES
 
            if (istore(M33CD+13).EQ.0) then
                !call PARM_PAIRS_XLHS(storetemp(JO), JP-JO+1, &
                !&   STR11(L11), N11, iresults, nresults, & 
                !&   storetemp(L12B), N12B*MD12B, MD12B)
                print *, 'not implemented (parm_pairs_xlhs)'
                stop
            else
                ! Store a chunk of the design matrix
                !designmatrix(:,reflectionsdata_index) = storetemp(JO:JP)
                !print *, storetemp(JO:JP)
        
!                  call XADLHS( storetemp(JO), JP-JO+1, STR11(L11), N11,
!     1                 storetemp(L12B), N12B*MD12B, MD12B )
            end if
        end if
    end if

    ! save the new values in the buffer
    ! writing is delayed outside the loop
    !reflectionsdata(:,reflectionsdata_index)=storetemp(M6:M6+MD6-1)
    !call XSLR(1)  ! STORE THE LAST REFLECTION ON THE DISC
    !call XSLRnew(1, storetemp, l6wpointers(reflectionsdata_index), n6wpointers(reflectionsdata_index))
    call XACRT(6, minimum, maximum, summation, summationsq, reflectionsdata(:,reflectionsdata_index))  ! ACCUMULATE TOTALS FOR /FC/ 
    call XACRT(7, minimum, maximum, summation, summationsq, reflectionsdata(:,reflectionsdata_index))  ! AND THE PHASE
    call XACRT(16,minimum, maximum, summation, summationsq, reflectionsdata(:,reflectionsdata_index))
 
    if(SFLS_TYPE .eq. SFLS_CALC) then ! ADD DETAILS FOR ALL DATA WHEN 'CALC'
        tempr=(/1.0, ABS(ABS(FO)-FCEXS), ABS(FO), WDF**2, A**2 /)
        if (reflectionsdata(1+20,reflectionsdata_index) .GE. RALL(1)) then
            RALL(2:6) = RALL(2:6) + tempr
        end if
        RALL(7:11) = RALL(7:11) + tempr
    end if
    
    shiftsaccumulation=shiftsaccumulation+designmatrix(:,reflectionsdata_index)
    end do
!$OMP END DO
    
    ! merge minimum and maximum
    do i=1, 16
!$OMP ATOMIC      
        minimum_shared(i)=min(minimum_shared(i), minimum(i))
!$OMP ATOMIC          
        maximum_shared(i)=max(maximum_shared(i), maximum(i))
    end do    

    tid=0
!$  tid=omp_get_thread_num()

    ! Accumulating the normal matrix
    if(SFLS_TYPE .EQ. SFLS_REFINE .and. &! NO REFINEMENT
    &   NEWLHS .and. &! ACCUMULATE THE LEFT HAND SIDES
    &   ISTORE(M33CD+12).EQ.0 .and. &! Just a normal accumulation.
    &   ISTORE(M33CD+13).NE.0)THEN    
        call DSYRK('L','N',JP-JO+1,storechunk, &
        &   1.0d0, designmatrix(1,storechunk*tid+1), &
        &   JP-JO+1,1.0d0,normalmatrix(1,1,tid+1),JP-JO+1)    
    end if
    
!$OMP END PARALLEL

    ! writing new values back to the disk
    do reflectionsdata_index=1, reflectionsdata_size
        call XSLRnew(reflectionsdata(:,reflectionsdata_index), &
        &   store, l6wpointers(reflectionsdata_index), n6wpointers(reflectionsdata_index))
    end do


END do  ! END OF REFLECTION LOOP

! Merge accumulation matrices
! Only vectorized with gfortran 4.8 not 4.4
do i=1, ubound(normalmatrix,2)
    do j=2, ubound(normalmatrix,3)
        normalmatrix(:,i,1)=normalmatrix(:,i,1)+normalmatrix(:,i,j)
    end do
end do


!!!!!!!!!!!!!!!!!!!!!!!!!
! putting back values in original storage
iposn=4
I=IPOSN-1
J=L6DTL+I*MD6DTL
STORE(J:J+3) = (/ minimum_shared(iposn), maximum_shared(iposn),summation(iposn), summationsq(iposn) /)
do iposn=6, 9
    I=IPOSN-1
    J=L6DTL+I*MD6DTL
    STORE(J:J+3) = (/ minimum_shared(iposn), maximum_shared(iposn),summation(iposn), summationsq(iposn) /)
end do
iposn=16
I=IPOSN-1
J=L6DTL+I*MD6DTL
STORE(J:J+3) = (/ minimum_shared(iposn), maximum_shared(iposn),summation(iposn), summationsq(iposn) /)

! put back right hand side to orignal space
str11(l11r:l11R+n11r-1)=righthandside

! put back shifts
!do i=1, storelength
!    if(shiftsaccumulation_shared(i)>0) then
!        store(i)=shiftsaccumulation_shared(i)
!    end if
!end do


if(SFLS_TYPE .EQ. SFLS_REFINE .and. &! NO REFINEMENT
&   NEWLHS .and. &! ACCUMULATE THE LEFT HAND SIDES
&   ISTORE(M33CD+12).EQ.0 .and. &! Just a normal accumulation.
&   ISTORE(M33CD+13).NE.0)THEN    
    ! process the remaining chunk of design matrix

    ! Pack normal matrix back into original crystals storage     
    IBL = 1                  ! Parameter # at start of current block
    IBS = L11                ! Packed storage address.
    
    do MB = 1, N12B*MD12B, MD12B      
        MNR  = ISTORE(L12B+MB)  ! Dimension of this block
        MSTR = (MNR*(MNR+1))/2  ! Storage space for this block    
        do i=1,MNR
            j = ((i-1)*(2*(MNR)-i+2))/2
            k = j + MNR - i
            STR11(IBS+j:IBS+k)=normalmatrix(i+IBL-1:IBL-1+MNR,IBL+i-1,1)
! E.g. two blocks of 2 - normalmatrix is 4x4, output is 2 upper triangles of side 2.
! Initially IBL is 1, IBS is L11.
!       MNR is 2
!       MSTR is 3
!       i: 1->2
!          j = 0;  k = 2-1 = 1
!          str11(L11:L11+1) = norm(1:2, 1)
!          j = 2;  k = 2 + 2 - 2 = 2
!          str11(L11+2:L11+2) = norm(2:2, 2)
!       IBL = 3
!       IBS = L11+3
!       MNR is 2
!       MSTR is 3
!       i = 1->2
!          j = 0;  k = 1
!          str11(L11+3:L11+4) = norm(3:4, 3)
!          j = 2; k = 2
!          str11(L11+5:L11+5) = norm(4:4, 4)
! Looks OK.
              
        end do

        IBS = IBS + MSTR       ! Increment the storage pointer
        IBL = IBL + MNR        ! Increment the derivative pointer
    end do
!      do i=1,JP-JO+1
!            j = ((i-1)*(2*(JP-JO+1)-i+2))/2
!            k = j + JP-JO+1 - i
!            STR11(L11+j:L11+k)=normalmatrix(i:JP-JO+1,i)
!      end do    
end if


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! end big loop
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



#if defined(_GIL_) || defined(_LIN_)
call date_and_time(VALUES=measuredtime)
print *, 'Formation of the normal matrix time (ms): ', &
&   ((measuredtime(5)*3600+measuredtime(6)*60)+ &
&   measuredtime(7))*1000+measuredtime(8)-starttime
#endif

if(allocated(designmatrix)) deallocate(designmatrix)
if(allocated(normalmatrix)) deallocate(normalmatrix)      

!--END OF THE REFLECTIONS  -  PRINT THE R-VALUES ETC.
    
if (NT .LE. 0) then
    if (ISSPRT .EQ. 0) write(NCWU,5851)
    write ( CMON, 5851)
    call XPRVDU(NCVDU, 1,0)
5851      FORMAT(' No reflections have been used for the Structure Factor calculation')
    R = 0.
    A = 0.
    T = 0.
    RW = 0.
    S = 0.
else
    if (FOABS .LE. 0.0) then ! GOTO 19940
!------ SIGMA FO .LE. ZERO ---- SUGGESTS PROBABLY NO CALCULATION
        formatstr="(1X,'The denominator for the R factor is less than or equal to zero.',&
        &   /,' No structure factors have been stored.')"
        if (ISSPRT .EQ. 0) write(NCWU,formatstr)
        write ( CMON, formatstr)
        call XPRVDU(NCVDU, 2,0)
    return
    end if
    
    R=DFT/FOABS*100.0
!----- PATCH TO AVOID INCIPIENT DIVISION BY ZERO
    if(RW .LE. 0) then ! GOTO 19930
!------ SIGMA W*FO*FO .LE. ZERO ---- SUGGESTS PROBABLY NO WEIGHTS
        formatstr="(1X,'The denominator for the weighted R factor is less than or equal to zero.', &
        &   ' Check that you have computed Fc and applied weights.')"
        if (ISSPRT .EQ. 0) write(NCWU,formatstr)
        write ( CMON, formatstr)
        call XPRVDU(NCVDU, 2,0)
        call XERHND ( IERERR )
        return ! GOTO 19900
    end if
              
    RW=SQRT(WDFT/RW)*100.0
    A=FOT/SCALEO
    S=FCT/SCALEO
    T=DFT/SCALEO
end if

if(SFLS_TYPE .EQ. SFLS_SCALE) then  ! WE ARE TO CALCULATE A NEW SCALE FACTOR HERE
!6100    CONTINUE. Scale factor shift is wrt F**2, change is necessary.
    if (NV .GE. 0) then   ! REMEMBER THE SHIFT IS IN F**2
        if (SFC.GT.ZEROSQ) then
            STORE(L5O) = SQRT(STORE(L5O)*STORE(L5O) + SFO/SFC)
        else
            STORE(L5O) = SQRT(STORE(L5O)*STORE(L5O))
        end if
    else
        if (SFC.GT.ZEROSQ) then
            STORE(L5O)=STORE(L5O) + SFO/SFC
        else
            STORE(L5O)=STORE(L5O)
        end if
    end if
end if

!--STORE THE SCALE AND PRINT IT
SCALE=STORE(L5O)
LJX = 0
if ( TWINNED )THEN
    LJX = 4
    if ( SCALED_FOT ) LJX=8
end if
if ( SFLS_TYPE .NE. SFLS_REFINE ) LJX = LJX + 1
if ( SFLS_TYPE .NE. SFLS_SCALE ) LJX = LJX + 2

!
! Only print disagreeable reflections during calc.
if( SFLS_TYPE .EQ. SFLS_CALC ) then
    write (CMON ,'(/'' Target Weighted Residual ='',F6.2)') SQRT(AMINF/real(NT))
    call XPRVDU(NCVDU, 2,0)
    if(ISSPRT.EQ.0) write(NCWU, '(//)')
    if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(2)(:)
    write ( CMON ,11)
    call XPRVDU(NCVDU, 1,0)
    if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)
11        FORMAT(2('   h   k  l     Fo      Fc  wDel Fo/Fc','  '))
    do MSORT = LSORT, LSORT+(NSORT-1)*MDSORT, 2*MDSORT
        write ( CMON , '(3I4, 2F7.1, F6.1, F6.2,2X,3I4, 2F7.1, F6.1, F6.2)') &
        &   ( (NINT(STORE(IXAP)), IXAP=JXAP, JXAP+2), &
        &   (STORE(IXAP), IXAP= JXAP+3,JXAP+6), &
        &   JXAP= MSORT, MSORT+MDSORT, MDSORT)
        call XPRVDU(NCVDU, 1,0)
        if(ISSPRT.EQ.0) write(NCWU, '(A)') CMON(1)(:)
    end do
end if

!
if (ISSPRT .EQ. 0) then
    write(NCWU,5900)R,RW,A,S,T
5900      FORMAT(/30X,3('*')/29X,3('*')/' R-value    Weighted R',6X, &
    &   12('*'),14X,12('*')/27X,13('*'),2X,'HERE IT IS',2X,12('*')/ &
    &   F7.2,F12.2,9X,12('*'),14X,12('*')/29X,3('*')/30X,3('*')// &
    &   ' Sum of /FO/    Sum of /FC/    Sum of /Delta/', &
!RIC13:     5  '    Minimization function',//F11.1,F15.1,F16.1,34X,
    &   '    Minimization function',//F11.0,F15.0,F16.0,34X, &
    &   ' On scale of /FC/')
    write(NCWU,5950)FOT,FCT,DFT,AMINF
!RIC13:5950    FORMAT(/F11.1,F15.1,F16.1,E25.8,9X,' On scale of /FO/')
5950      FORMAT(/F11.0,F15.0,F16.0,E25.4,9X,' On scale of /FO/')
    write(NCWU,6150) STORE(L5O), NT
    write(NCWU,6250)cycle_number,LJX
end if
!
!RIC13:6150  FORMAT(/,' New scale factor (G) is ',F10.5,
6150  FORMAT(/,' New scale factor (G) is ',F10.3,',  ',I6,' reflections used in refinement')
6250  FORMAT(/,' Structure factor least squares calculation',I5,'  ends',I3)

if (S .GT. ZERO) S = A/S

write ( CMON, 6260) cycle_number, N12, MIN(R,99.99), MIN(RW,99.99), AMINF, MIN(999.99,S)

6260  FORMAT (' Cycle',I5,' Params',I5,' R{9,1 ',F5.2, &
&   '%{8,1 Rw{9,1 ',F5.2, '%{8,1 MinFunc ',G9.2,' SumFo/SumFc ',F6.2)
call OUTCOL(6)
call XPRVDU(NCVDU, 1, 0)
call OUTCOL(1)

call CPU_TIME ( time_end )
!      write ( NCWU, '(A,F15.8)' )'SFLSC seconds: ',time_end - time_begin

END

!CODE FOR KLAYER
integer function KLAYER(input)
!--COMPUTE THE LAYER SCALE INDEX FOR THE CURRENT REFLECTION.
!
!  IN  A DUMMY ARGUMENT.
!
!--return VALUES OF 'KLAYER' ARE :
!
!  -1  NO LAYER SCALES IN LIST 5.
!  >0  THE LAYER SCALE INDEX.
!
!--
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu, IERFLG
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST05.INC90'
use xlst05_mod, only: md5ls, l5lsc
!include 'XLST06.INC90'
use xlst06_mod, only: m6
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
!
!include 'QSTORE.INC'
!
implicit none

integer, intent(in) :: input
real a
integer idwzap, i

IDWZAP = input
!--
KLAYER=-1

if(MD5LS.GT.0)THEN  ! ARE THERE ANY LAYER SCALES STORED?

    A=STORE(L5LSC)*STORE(M6)+STORE(L5LSC+1)*STORE(M6+1) &
    &   +STORE(L5LSC+2)*STORE(M6+2)  ! !  COMPUTE THE INDEX VALUE

    if(STORE(L5LSC+4).LT.0) A=ABS(A) ! Take absolute value

    I=NINT(A+STORE(L5LSC+3))  ! COMPUTE THE OUTPUT INDEX

    if((I.LE.0).OR.(I.GT.MD5LS))THEN  ! ILLEGAL LAYER SCALE VALUE
        call XERHDR(0)
        if (ISSPRT .EQ. 0) then
            write(NCWU,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        end if
        write(CMON,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        call XPRVDU(NCVDU, 1,0)
1200          FORMAT(' Reflection : ',3I5,'  generates an illegal layer scale index of ',I4)
        !call XERHNDnew ( IERERR, ierflg )
        call XERHND ( IERERR )
        return
    end if

    KLAYER=I
end if
END

!CODE FOR KLAYER
integer function KLAYERnew(input, ierflg) result(klayer)
!--COMPUTE THE LAYER SCALE INDEX FOR THE CURRENT REFLECTION.
!
!  IN  A DUMMY ARGUMENT.
!
!--return VALUES OF 'KLAYER' ARE :
!
!  -1  NO LAYER SCALES IN LIST 5.
!  >0  THE LAYER SCALE INDEX.
!
!--
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST05.INC90'
use xlst05_mod, only: md5ls, l5lsc
!include 'XLST06.INC90'
use xlst06_mod, only: m6
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
!
!include 'QSTORE.INC'
!
implicit none

integer, intent(in) :: input
integer, intent(out) :: ierflg
real a
integer idwzap, i

IDWZAP = input
!--
KLAYER=-1

if(MD5LS.GT.0)THEN  ! ARE THERE ANY LAYER SCALES STORED?

    A=STORE(L5LSC)*STORE(M6)+STORE(L5LSC+1)*STORE(M6+1) &
    &   +STORE(L5LSC+2)*STORE(M6+2)  ! !  COMPUTE THE INDEX VALUE

    if(STORE(L5LSC+4).LT.0) A=ABS(A) ! Take absolute value

    I=NINT(A+STORE(L5LSC+3))  ! COMPUTE THE OUTPUT INDEX

    if((I.LE.0).OR.(I.GT.MD5LS))THEN  ! ILLEGAL LAYER SCALE VALUE
        call XERHDR(0)
        if (ISSPRT .EQ. 0) then
            write(NCWU,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        end if
        write(CMON,1200)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        call XPRVDU(NCVDU, 1,0)
1200          FORMAT(' Reflection : ',3I5,'  generates an illegal layer scale index of ',I4)
        call XERHNDnew ( IERERR, ierflg )
        return
    end if

    KLAYER=I
end if
END


!CODE FOR KBATCH
integer function KBATCH(input)
!--COMPUTE THE BATCH SCALE INDEX FOR THE CURRENT REFLECTION.
!
!  IN  A DUMMY ARGUMENT.
!
!--return VALUES OF 'KBATCH' ARE :
!
!  -1  NO BATCH SCALES IN LIST 5.
!  >0  THE BATCH SCALE INDEX.
!
!--
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only:store
!include 'XUNITS.INC90'
use xunits_mod, only: ncwu, ncvdu
!include 'XSSVAL.INC90'
use xssval_mod, only: issprt
!include 'XLST05.INC90'
use xlst05_mod, only: md5bs
!include 'XLST06.INC90'
use xlst06_mod, only: m6
!include 'XERVAL.INC90'
use xerval_mod, only: iererr
!include 'XIOBUF.INC'
use xiobuf_mod, only: cmon
!include 'QSTORE.INC'
implicit none

integer, intent(in) :: input
integer idwzap, i

IDWZAP = input
KBATCH=-1
if (MD5BS.GT.0) then   ! ARE ANY BATCH SCALES STORED
    I=NINT(STORE(M6+13))  ! COMPUTE THE INDEX VALUE
!--CHECK if THE VALUE IS LARGE ENOUGH
    if((I.LE.0).OR.(I.GT.MD5BS))THEN 
        call XERHDR(0)  ! ILLEGAL BATCH SCALE VALUE
        if (ISSPRT .EQ. 0) then
            write(NCWU,1100)NINT(STORE(M6)),NINT(STORE(M6+1)),NINT(STORE(M6+2)),I
        end if
        write(CMON,1100)NINT(STORE(M6)),NINT(STORE(M6+1)), NINT(STORE(M6+2)),I
        call XPRVDU(NCVDU, 1,0)
1100          FORMAT(' Reflection : ',3I5,'  generates an illegal batch scale index of ',I4)
        call XERHND ( IERERR )
        return
    end if
    KBATCH=I
end if
END


!CODE FOR XLINE
subroutine XLINE (M2LI, M5ALI, reflectiondata, LifAC, DLFLILE, DLFTHE, DLFPHI, store)
 
!include 'ISTORE.INC'
!include 'STORE.INC'
!use store_mod, only: store
!include 'XLST01.INC90'
use xlst01_mod, only: l1p1, l1o2
!include 'QSTORE.INC'
use xconst_mod, only: zerosq, twopi, pi

implicit none

!-C-C-SOME TRANSFERRED STARTING-ADDRESSES OF ACTUAL (!) PARAMETERS
integer, intent(in) :: M2LI, M5ALI
real, dimension(:), intent(inout) :: reflectiondata, store
double precision, intent(inout) :: LifAC, DLFLILE, DLFTHE, DLFPHI
!-C-C-AGREEMENT OF CONSTANTS AND VARIABLES
!-C-C-CELL-CONSTANTS, REFLECTION-INDICES
real CONA, CONB, CONC, CONAL, CONBET, CONGA, COGAST
real COSCONAL, COSCONGA, COSCONBET
real REFLH, REFLK, REFLL
!-C-C-COORDINATES FOR LINE (POLAR, CARTESIAN, TRICLINIC)
real LILE, ANGLZD, AZIMXD, ANGLZ, AZIMX
real LINCX, LINCY, LINCZ, LINX, LINY, LINZ
!-C-C-TRANSF. BETWEEN COORD. SYST. (CARTESIAN TO TRIGONAL)
real CATRI11, CATRI12, CATRI13
real CATRI21, CATRI22, CATRI23
real CATRI31, CATRI32, CATRI33
!-C-C-SOME ABBREVIATIONS
!-C-C-...FOR STRUCTURFACTOR-CALCULATION
real COSIA, COSIB, COSIC, COSIRO
real DOTHLX, DOTHLY, DOTHLZ, DOTHL
!-C-C-...FOR DERIVATIVES
real DLINXLL, DLINYLL, DLINZLL
real DLINXTHE, DLINYTHE, DLINZTHE
real DLINXPHI, DLINYPHI, DLINZPHI
real DDOTLL, DDOTTHE, DDOTPHI

!-C-C-CALCULATE THE LINE
!-C-C-ABBREVIATIONS FOR CONSTANTS AND VARIABLES
CONA=STORE(L1P1)
CONB=STORE(L1P1+1)
CONC=STORE(L1P1+2)
CONAL=STORE(L1P1+3)
CONBET=STORE(L1P1+4)
CONGA=STORE(L1P1+5)
REFLH=reflectiondata(1)
REFLK=reflectiondata(1+1)
REFLL=reflectiondata(1+2)
LILE=reflectiondata(1+8)
!-C-C-(POLAR ANGLES IN UNITS OF 100 DEGREES)
ANGLZD=STORE(M5ALI+9)
AZIMXD=STORE(M5ALI+10)
!-C-C-TRANSFORMATION OF DEGREES (IN UNITS OF 100 DEGREES) TO RADIANS
ANGLZ=ANGLZD*TWOPI/3.6
AZIMX=AZIMXD*TWOPI/3.6
!-C-C-PREP. OF CALC. OF THE DOT-PROD. OF LINE AND HKL AND HKL-LENGTH
cosconal=cos(conal)
cosconga=cos(conga)
cosconbet=cos(conbet)
COSIA=cosconbet*cosconga-cosconal
COSIB=cosconal*cosconga-cosconbet
COSIC=cosconal*cosconbet-cosconga
COSIRO=1+2*cosconal*cosconbet*cosconga-cosconal**2-cosconbet**2-cosconga**2
!-C-C-CALCULATION OF RECIPROCAL CELL-CONSTANTS FROM real CELL-CONSTANTS
COGAST=cosconal*cosconbet-cosconga/(SIN(CONAL)*SIN(CONBET))
!-C-C-GETTING MATRIX (TRANSF. CART. --> TRICL.) FROM CRYSTALS
CATRI11=STORE(L1O2+0)
CATRI21=STORE(L1O2+1)
CATRI31=STORE(L1O2+2)
CATRI12=STORE(L1O2+3)
CATRI22=STORE(L1O2+4)
CATRI32=STORE(L1O2+5)
CATRI13=STORE(L1O2+6)
CATRI23=STORE(L1O2+7)
CATRI33=STORE(L1O2+8)
!-C-C-CALC. OF THE CARTESIAN COORD. OF LINE IN real SPACE
LINCX=LILE*SIN(ANGLZ)*COS(AZIMX)
LINCY=LILE*SIN(ANGLZ)*SIN(AZIMX)
LINCZ=LILE*COS(ANGLZ)
!-C-C-CALC. OF THE TRICLINIC COORD. OF LINE IN real SPACE
LINX=LINCX*CATRI11+LINCY*CATRI12+LINCZ*CATRI13
LINY=LINCX*CATRI21+LINCY*CATRI22+LINCZ*CATRI23
LINZ=LINCX*CATRI31+LINCY*CATRI32+LINCZ*CATRI33
!-C-C-CALC. OF SYMMETRY-EQUIVALENT DIRECTIONS (TRANSF. OF VECTOR-
!-C-C-END-POINT BY ROTATIONAL PART ONLY)
LINX=LINX*STORE(M2LI)+LINY*STORE(M2LI+1)+LINZ*STORE(M2LI+2)
LINY=LINX*STORE(M2LI+3)+LINY*STORE(M2LI+4)+LINZ*STORE(M2LI+5)
LINZ=LINX*STORE(M2LI+6)+LINY*STORE(M2LI+7)+LINZ*STORE(M2LI+8)
!-C-C-CALC. DOT-PRODUCT OF HKL-VECTOR AND LINE-VECTOR IN REC. SPACE
DOTHLX=COSIC*((REFLK*CONA/CONB)+REFLH*cosconga) &
&   +COSIB*((REFLL*CONA/CONC)+REFLH*cosconbet) &
&   +COSIA*((REFLL*CONA*cosconga/CONC) &
&        +(REFLK*CONA*cosconbet/CONB)) &
&   +REFLH*(SIN(CONAL)**2) &
&   +(REFLK*CONA*(SIN(CONBET)**2)*cosconga/CONB) &
&   +(REFLL*CONA*(SIN(CONGA)**2)*cosconbet/CONC)
DOTHLY=COSIC*(REFLK*cosconga+(REFLH*CONB/CONA)) &
&   +COSIB*((REFLL*CONB*cosconga/CONC) &
&        +(REFLH*CONB*cosconal/CONA)) &
&   +COSIA*((REFLL*CONB/CONC)+REFLK*cosconal) &
&   +(REFLH*CONB*(SIN(CONAL)**2)*cosconga/CONA) &
&   +REFLK*(SIN(CONBET)**2) &
&   +(REFLL*CONB*(SIN(CONGA)**2)*cosconal/CONC) 
DOTHLZ=COSIC*((REFLK*CONC*cosconbet/CONB) &
&             +(REFLH*CONC*cosconal/CONA)) &
&   +COSIB*(REFLL*cosconbet+(REFLH*CONC/CONA)) &
&   +COSIA*(REFLL*cosconal+(REFLK*CONC/CONB)) &
&   +(REFLH*CONC*(SIN(CONAL)**2)*cosconbet/CONA) &
&   +(REFLK*CONC*(SIN(CONBET)**2)*cosconal/CONB)&
&   +REFLL*(SIN(CONGA)**2)
DOTHL=(LINX*DOTHLX+LINY*DOTHLY+LINZ*DOTHLZ)/COSIRO
!-C-C-CALCULATE FINAL FACTOR FOR LINE s
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    LifAC=1.0
else
    LifAC=SIN(PI*DOTHL)/(PI*DOTHL)
end if
!-C-C-CALCULATE DERIVATIVES
!-C-C-ABBR. FOR PART. DERIV. W.R.T. A AND (!) B FOR LINE (LILE)
DLINXLL=SIN(ANGLZ)*COS(AZIMX)*CATRI11 &
&      +SIN(ANGLZ)*SIN(AZIMX)*CATRI12 &
&      +COS(ANGLZ)*CATRI13 
DLINYLL=SIN(ANGLZ)*COS(AZIMX)*CATRI21 &
&      +SIN(ANGLZ)*SIN(AZIMX)*CATRI22 &
&      +COS(ANGLZ)*CATRI23 
DLINZLL=SIN(ANGLZ)*COS(AZIMX)*CATRI31 &
&      +SIN(ANGLZ)*SIN(AZIMX)*CATRI32 &
&      +COS(ANGLZ)*CATRI33 
DDOTLL=(DLINXLL*DOTHLX+DLINYLL*DOTHLY+DLINZLL*DOTHLZ)/COSIRO
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    DLFLILE=0.0
else
    DLFLILE=((DOTHL*COS(PI*DOTHL)-SIN(PI*DOTHL)/PI)*DDOTLL)/(DOTHL**2)
end if
!-C-C-ABBR. FOR PART. DERIV. W.R.T. A AND (!) B FOR LINE (ANGLZ)
DLINXTHE=LILE*COS(ANGLZ)*COS(AZIMX)*CATRI11 &
&       +LILE*COS(ANGLZ)*SIN(AZIMX)*CATRI12 &
&       -LILE*SIN(ANGLZ)*CATRI13
DLINYTHE=LILE*COS(ANGLZ)*COS(AZIMX)*CATRI21 &
&       +LILE*COS(ANGLZ)*SIN(AZIMX)*CATRI22 &
&       -LILE*SIN(ANGLZ)*CATRI23
DLINZTHE=LILE*COS(ANGLZ)*COS(AZIMX)*CATRI31 &
&       +LILE*COS(ANGLZ)*SIN(AZIMX)*CATRI32 &
&       -LILE*SIN(ANGLZ)*CATRI33
DDOTTHE=(DLINXTHE*DOTHLX+DLINYTHE*DOTHLY+DLINZTHE*DOTHLZ)*TWOPI/(3.6*COSIRO)
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    DLFTHE=0.0
else
    DLFTHE=((DOTHL*COS(PI*DOTHL)-SIN(PI*DOTHL)/PI)*DDOTTHE)/(DOTHL**2)
end if
!-C-C-ABBR. FOR PART. DERIV. W.R.T. A AND (!) B FOR LINE (AZIMX)
DLINXPHI=-LILE*SIN(ANGLZ)*SIN(AZIMX)*CATRI11 &
&       +LILE*SIN(ANGLZ)*COS(AZIMX)*CATRI12 
DLINYPHI=-LILE*SIN(ANGLZ)*SIN(AZIMX)*CATRI21 &
&       +LILE*SIN(ANGLZ)*COS(AZIMX)*CATRI22 
DLINZPHI=-LILE*SIN(ANGLZ)*SIN(AZIMX)*CATRI31 &
&       +LILE*SIN(ANGLZ)*COS(AZIMX)*CATRI32
DDOTPHI=(DLINXPHI*DOTHLX+DLINYPHI*DOTHLY+DLINZPHI*DOTHLZ) &
&       *TWOPI/(3.6*COSIRO)
!-C-C-TEST WHETHER DOTHL APPROACHES ZERO
if (ABS(DOTHL) .LE. ZEROSQ) then
    DLFPHI=0.0
else
    DLFPHI=((DOTHL*COS(PI*DOTHL)-SIN(PI*DOTHL)/PI)*DDOTPHI)/(DOTHL**2)
end if
END

!CODE FOR XRING
subroutine XRING (M2RI, STRI, M5ARI, reflectiondata,RifAC, DRFRA, DRFTHE, DRFPHI, store)

!include 'ISTORE.INC'
!include 'STORE.INC'
!use store_mod, only: store
!include 'XLST01.INC90'
use xlst01_mod, only: l1p1, l1o2
use xconst_mod, only: twopi, zerosq

implicit none
!include 'QSTORE.INC'
real, dimension(:), intent(inout) :: reflectiondata, store
!-c-c-agreement of constants and variables
!-c-c-cell-constants, reflection-indices
real cona, conb, conc, conal, conbet, conga
real cosconal, cosconga, cosconbet
real reflh, reflk, refll
!-c-c-parameters/coordinates for ring (polar, cartesian, triclinic)
real rira, anglzd, azimxd
double precision anglz, azimx
double precision lincx, lincy, lincz, linx, liny, linz
!-c-c-some transferred starting-addresses of actual (!) parameters
integer m2ri, m5ari
!-c-c-transferred value of st
real stri
!-c-c-transf. between coord. syst. (cartesian to trigonal)
real catri11, catri12, catri13
real catri21, catri22, catri23
real catri31, catri32, catri33
!-c-c-some abbreviations
!-c-c-...for structurfactor-calculation
double precision cosia, cosib, cosic, cosiro
double precision dothlx, dothly, dothlz, dothl
double precision cospsi, sinpsi
double precision bessr1, bessr2, bessr3, bessr4, bessr5, bessr6
double precision besss1, besss2, besss3, besss4, besss5, besss6
double precision bessp1, bessp2, bessp3, bessp4, bessp5
double precision bessq1, bessq2, bessq3, bessq4, bessq5
double precision argbes, argsq, sicarg, rar8sq, rifac
!-c-c-...for derivatives
double precision dlinxthe, dlinythe, dlinzthe
double precision dlinxphi, dlinyphi, dlinzphi
double precision ddotthe, ddotphi, drfout, dargra
double precision dargthe, dargphi, drfra, drfthe, drfphi

!-c-c-variables for bessel-functions are preoccupied
data bessr1,bessr2,bessr3,bessr4,bessr5,bessr6 & 
&   /57568490574.d0, -13362590354.d0, 651619640.7d0, &
&   -11214424.18d0, 77392.33017d0, -184.9052456d0/
data besss1,besss2,besss3,besss4,besss5,besss6 &
&   /57568490411.d0, 1029532985.d0, 9494680.718d0, &
&   59272.64853d0, 267.8532712d0, 1.d0/
data bessp1,bessp2,bessp3,bessp4,bessp5 &
&   /1.d0, -.1098628627d-2, .2734510407d-4, &
&   -.2073370639d-5, .2093887211d-6/
data bessq1,bessq2,bessq3,bessq4,bessq5 &
&   /-.1562499995d-1, .1430488765d-3, -.6911147651d-5, &
&   .7621095161d-6, -.934945152d-7/
!-c-c-calculate the ring
!-c-c-abbreviations for constants and variables
cona=store(l1p1)
conb=store(l1p1+1)
conc=store(l1p1+2)
conal=store(l1p1+3)
conbet=store(l1p1+4)
conga=store(l1p1+5)
cosconal=cos(conal)
cosconga=cos(conga)
cosconbet=cos(conbet)      
reflh=reflectiondata(1)
reflk=reflectiondata(1+1)
refll=reflectiondata(1+2)
rira=store(m5ari+8)
!-c-c-(polar angles in units of 100 degrees)
anglzd=store(m5ari+9)
azimxd=store(m5ari+10)
!-c-c-transformation of degrees (in units of 100 degrees) to radians
anglz=anglzd*twopi/3.6
azimx=azimxd*twopi/3.6
!-c-c-prep. of calc. of the dot-prod. of ring-normal, hkl(-length)
cosia=cosconbet*cosconga-cosconal
cosib=cosconal*cosconga-cosconbet
cosic=cosconal*cosconbet-cosconga
cosiro=1+2*cosconal*cosconbet*cosconga-cosconal**2-cosconbet**2-cosconga**2
!-c-c-getting matrix (transf. cart. --> tricl.) from crystals
catri11=store(l1o2+0)
catri21=store(l1o2+1)
catri31=store(l1o2+2)
catri12=store(l1o2+3)
catri22=store(l1o2+4)
catri32=store(l1o2+5)
catri13=store(l1o2+6)
catri23=store(l1o2+7)
catri33=store(l1o2+8)
!-c-c-calc. of the cartesian coord. of ring-normal in real space
lincx=sin(anglz)*cos(azimx)
lincy=sin(anglz)*sin(azimx)
lincz=cos(anglz)
!-c-c-calc. of the triclinic coord. of ring-normal in real space
linx=lincx*catri11+lincy*catri12+lincz*catri13
liny=lincx*catri21+lincy*catri22+lincz*catri23
linz=lincx*catri31+lincy*catri32+lincz*catri33
!-c-c-calc. of symmetry-equivalent directions (transf. of vector-
!-c-c-end-point by rotational part only)
linx=linx*store(m2ri)+liny*store(m2ri+1)+linz*store(m2ri+2)
liny=linx*store(m2ri+3)+liny*store(m2ri+4)+linz*store(m2ri+5)
linz=linx*store(m2ri+6)+liny*store(m2ri+7)+linz*store(m2ri+8)
!-c-c-calc. dot-prod. of hkl-vect. and ring-normal-vect. in rec. space
dothlx=cosic*((reflk*cona/conb)+reflh*cosconga) &
&   +cosib*((refll*cona/conc)+reflh*cosconbet) &
&   +cosia*((refll*cona*cosconga/conc) &
&        +(reflk*cona*cosconbet/conb)) &
&   +reflh*(sin(conal)**2) &
&   +(reflk*cona*(sin(conbet)**2)*cosconga/conb) &
&   +(refll*cona*(sin(conga)**2)*cosconbet/conc)
dothly=cosic*(reflk*cosconga+(reflh*conb/cona)) &
&   +cosib*((refll*conb*cosconga/conc) &
&        +(reflh*conb*cosconal/cona)) &
&   +cosia*((refll*conb/conc)+reflk*cosconal) &
&   +(reflh*conb*(sin(conal)**2)*cosconga/cona) &
&   +reflk*(sin(conbet)**2) &
&   +(refll*conb*(sin(conga)**2)*cosconal/conc)
dothlz=cosic*((reflk*conc*cosconbet/conb) &
&             +(reflh*conc*cosconal/cona)) &
&   +cosib*(refll*cosconbet+(reflh*conc/cona)) &
&   +cosia*(refll*cosconal+(reflk*conc/conb)) &
&   +(reflh*conc*(sin(conal)**2)*cosconbet/cona) &
&   +(reflk*conc*(sin(conbet)**2)*cosconal/conb) &
&   +refll*(sin(conga)**2)
dothl=(linx*dothlx+liny*dothly+linz*dothlz)/cosiro
!-c-c-calculate cosine of angle between hkl-vector and ring-normal
cospsi=dothl/(2*stri)
if (cospsi .gt. 1.0) then
    cospsi=1.0
else if (cospsi .lt. -1.0) then
    cospsi=-1.0
end if
!-c-c-calculate sine of angle between hkl-vector and ring-normal
sinpsi=sqrt(1-cospsi**2)
!-c-c-calculate final factor for ring s
argbes=2*twopi*stri*rira*sinpsi
if (argbes .lt. 8.) then
    argsq=argbes**2
    rifac=(bessr1+argsq*(bessr2+argsq*(bessr3+argsq &
    &   *(bessr4+argsq*(bessr5+argsq*bessr6))))) &
    &   /(besss1+argsq*(besss2+argsq*(besss3+argsq &
    &   *(besss4+argsq*(besss5+argsq*besss6)))))
else
    sicarg=argbes-.785398164
    rar8sq=(8./argbes)**2
    rifac=sqrt(.636619772/argbes)*(cos(sicarg) &
    &   *(bessp1+rar8sq*(bessp2+rar8sq*(bessp3+rar8sq &
    &   *(bessp4+rar8sq*bessp5)))) &
    &   -(8./argbes)*sin(sicarg) &
    &   *(bessq1+rar8sq*(bessq2+rar8sq*(bessq3+rar8sq &
    &   *(bessq4+rar8sq*bessq5)))))
end if
!-c-c-abbr. for part. deriv. w.r.t. a and (!) b for ring (anglz)
dlinxthe=cos(anglz)*cos(azimx)*catri11 &
&       +cos(anglz)*sin(azimx)*catri12 &
&       -sin(anglz)*catri13
dlinythe=cos(anglz)*cos(azimx)*catri21 &
&       +cos(anglz)*sin(azimx)*catri22 &
&       -sin(anglz)*catri23
dlinzthe=cos(anglz)*cos(azimx)*catri31 &
&       +cos(anglz)*sin(azimx)*catri32 &
&       -sin(anglz)*catri33
ddotthe=(dlinxthe*dothlx+dlinythe*dothly+dlinzthe*dothlz)*twopi/(3.6*cosiro)
!-c-c-abbr. for part. deriv. w.r.t. a and (!) b for ring (azimx)
dlinxphi=-sin(anglz)*sin(azimx)*catri11+sin(anglz)*cos(azimx)*catri12
dlinyphi=-sin(anglz)*sin(azimx)*catri21+sin(anglz)*cos(azimx)*catri22
dlinzphi=-sin(anglz)*sin(azimx)*catri31+sin(anglz)*cos(azimx)*catri32
ddotphi=(dlinxphi*dothlx+dlinyphi*dothly+dlinzphi*dothlz)*twopi/(3.6*cosiro)
!-c-c-abbr. for part. deriv. w.r.t. a and (!) b for ring
!-c-c-outer deriv. for rira, anglz and azimx (for argbes < 8.)
if (argbes .lt. 8.) then
    drfout=argbes &
    &   *((2*bessr2+argsq*(4*bessr3+argsq*(6*bessr4+argsq &
    &   *(8*bessr5+argsq*10*bessr6)))) &
    &   *(besss1+argsq*(besss2+argsq*(besss3+argsq &
    &   *(besss4+argsq*(besss5+argsq*besss6))))) &
    &   -(2*besss2+argsq*(4*besss3+argsq*(6*besss4+argsq &
    &   *(8*besss5+argsq*10*besss6)))) &
    &   *(bessr1+argsq*(bessr2+argsq*(bessr3+argsq &
    &   *(bessr4+argsq*(bessr5+argsq*bessr6)))))) &
    &   /((besss1+argsq*(besss2+argsq*(besss3+argsq &
    &   *(besss4+argsq*(besss5+argsq*besss6)))))**2)
!-c-c-outer deriv. for rira, anglz and azimx (for argbes >/= 8.)
else
    drfout=(sqrt(.636619772/argbes)/argbes)*((8./argbes) &
    &   *(bessq1*(1.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *(bessq2*(3.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *(bessq3*(5.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *(bessq4*(7.5*sin(sicarg)-argbes*cos(sicarg))+rar8sq &
    &   *bessq5*(9.5*sin(sicarg)-argbes*cos(sicarg)))))) &
    &   -(bessp1*(argbes*sin(sicarg)+0.5*cos(sicarg))+rar8sq &
    &   *(bessp2*(argbes*sin(sicarg)+2.5*cos(sicarg))+rar8sq &
    &   *(bessp3*(argbes*sin(sicarg)+4.5*cos(sicarg))+rar8sq &
    &   *(bessp4*(argbes*sin(sicarg)+6.5*cos(sicarg))+rar8sq &
    &   *bessp5*(argbes*sin(sicarg)+8.5*cos(sicarg)))))))
end if
!-c-c-inner deriv. for rira
dargra=2*twopi*stri*sinpsi
!-c-c-check, whether sinpsi approaches zero
if (sinpsi .lt. zerosq) then
    drfthe=0.0
    drfphi=0.0
else
!-c-c-inner deriv. for anglz
    dargthe=-twopi*rira*dothl*ddotthe/(2*stri*sinpsi)
!-c-c-inner deriv. for azimx
    dargphi=-twopi*rira*dothl*ddotphi/(2*stri*sinpsi)
!-c-c-part. deriv. w.r.t. a and (!) b for ring (anglz,azimx,rira)
    drfthe=drfout*dargthe
    drfphi=drfout*dargphi
end if
drfra=drfout*dargra
end

!CODE FOR XSPHERE
subroutine XSPHERE (STSP, M5ASP, SPHEFAC, DSFRAD)
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only: store
use xconst_mod, only: pi

implicit none

!-c-c-transferred starting-addresses of m5a
integer m5asp
!-c-c-transferred value of st
real stsp
!-c-c-agreement of variables (sphere-factor and derivativ)
double precision sphefac
double precision dsfrad

!include 'QSTORE.INC'


!-c-c-calculate the sphere-factor
sphefac=(sin(4*pi*store(m5asp+8)*stsp))/(4*pi*store(m5asp+8)*stsp)
!-c-c-calculate the derivative w.r.t. sphere-factor for radius
dsfrad=((cos(4*pi*stsp*store(m5asp+8)) &
&   *4*pi*stsp*store(m5asp+8))-(sin(4*pi*stsp*store(m5asp+8)))) &
&   /(4*pi*stsp*(store(m5asp+8))**2)
end

!CODE FOR XSFLSX
subroutine XSFLSX(acd, bcd, ac, bc, nn, nm, tc, sst, smin, smax, nl, nr, jo, jp, &
&   g2, m12, md12a, reflectiondata, temporaryderivatives)
!
!--MAIN S.F.L.S. LOOP  -  CALCULATES A AND B AND THEIR DERIVATIVES
!
!  NL     ELEMENT NUMBER OF THIS REFLECTION (MAY BE SET TO 0)
!  T      TEMPERATURE FACTOR
!  FOCC   FORMFACTOR * SITE OCC * CHEMICAL OCC * DifABS CORECTION
!  TFOCC  T*FOCC
!  AP     A PART FOR EACH SYMMETRY POSITION FOR EACH ATOM
!  BP     B PART FOR EACH SYMMETRY POSITION FOR EACH ATOM
!  BT     TOTAL B PART FOR EACH ATOM
!  AT     TOTAL A PART FOR EACH ATOM

!--
#if defined(_GIL_) || defined(_LIN_) 
use sleef    
#endif
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only: istore, store
!include 'XSFWK.INC90'
use xsfwk_mod, only: anom
!include 'XWORKB.INC'
use xworkb_mod, only: jr, jq, jn ! always constant in xsflsc and read only
!include 'XSFLSW.INC90'
use xsflsw_mod, only: sfls_type, sfls_refine
use xsflsw_mod, only: cos_only, centro, iso_only, anomal
!include 'XLST01.INC90'
use xlst01_mod, only: l1s, l1a ! always constant in xsflsc and read only
!include 'XLST02.INC90'
use xlst02_mod, only: n2, n2t, md2t, md2i, md2, l2t, l2i, l2, symm_operators ! always constant in xsflsc and read only
!include 'XLST03.INC90'
use xlst03_mod, only: n3, md3tr, md3ti, l3tr, l3ti  ! always constant in xsflsc and read only
!include 'XLST05.INC90'
use xlst05_mod, only: n5, md5a, l5 ! always constant in xsflsc and read only
!include 'XLST06.INC90'
use xlst06_mod, only: md6
!include 'XLST12.INC90'
use xlst12_mod, only: n12, l12 ! always constant in xsflsc and read only
!include 'XUNITS.INC90'
!
!include 'QSTORE.INC'
use xconst_mod, only: zero, twopis, twopi
implicit none

real aimag, ap, at, bd, bf, bp, bt, focc, fried, tfocc, t, pshift
real dd
real aci, bci
integer ljs, ljt, lju, ljv, ljw, ljx, ljy, ljz
integer n, j

! moved from common blocks to local
integer m2, m2t, m2i, m3ti, m3tr, m5a, m12a, l12a
real st, s, c, a

real FLAG
LOGICAL ATOM_REFINE

!-C-C-...FOR STRUCTURE FACTOR-CALCULATION
DOUBLE PRECISION SLRFAC
!-C-C-...FOR DERIVATIVES
DOUBLE PRECISION DSIZE, DDECLINA, DAZIMUTH

real ALPD(14),BLPD(14)   ! Use local arrays for better optimisation?

integer ISTACK

real, intent(out) :: ACD, BCD, tc, sst
real, intent(inout) :: smin, smax, bc, ac
real, dimension(:), intent(inout) :: reflectiondata
integer, intent(inout) :: nn, nm, m12, md12a
integer, intent(in) :: nl, nr, jo, jp
real, intent(in) :: g2
double precision, dimension(:), intent(out) :: temporaryderivatives
real, dimension(:,:), allocatable :: formfactors
real, dimension(:), allocatable :: storem2t

#if defined(_GIL_) || defined(_LIN_) 
real, dimension(2) :: scb
#endif

interface
    subroutine XLINE (M2LI, M5ALI, reflectiondata, LifAC, DLFLILE, DLFTHE, DLFPHI, store)
    implicit none
    integer, intent(in) :: M2LI, M5ALI
    real, dimension(:), intent(inout) :: reflectiondata, store
    double precision, intent(inout) :: LifAC, DLFLILE, DLFTHE, DLFPHI
    end subroutine
end interface
interface
    subroutine XRING (M2RI, STRI, M5ARI, reflectiondata,RifAC, DRFRA, DRFTHE, DRFPHI, store)
    implicit none
    real, dimension(:), intent(inout) :: reflectiondata, store
    integer :: m2ri, m5ari
    real :: STRI
    double precision :: RifAC, drfra, DRFTHE, DRFPHI
    end subroutine
end interface
interface
    subroutine XSCATTnew(ST, formfactors)
    implicit none
    real, intent(in) :: st
    real, dimension(:,:), allocatable, intent(out) :: formfactors    
    end subroutine
end interface

DD=1.0/TWOPI

ISTACK=-1   ! CLEAR OUT A FEW CONSTANTS
AC=0.
BC=0.
ACI=0.
BCI=0.
ACD=0.
BCD=0.
temporaryderivatives=0.0d0
allocate(storem2t(N2*MD2T))

! Rollett 5.12.5-7
!--calculate the information for the symmetry positions
M2=L2
M2T=L2T
do LJZ=1,N2
! compute h' = S.h
    storem2t(1+(LJZ-1)*MD2T)=reflectiondata(1)*symm_operators(1+0, ljz)+reflectiondata(1+1)*symm_operators(1+3, ljz)+ &
    &   reflectiondata(1+2)*symm_operators(1+6, ljz)
    storem2t(1+(LJZ-1)*MD2T+1)=reflectiondata(1)*symm_operators(1+1, ljz)+reflectiondata(1+1)*symm_operators(1+4, ljz)+ &
    &   reflectiondata(1+2)*symm_operators(1+7, ljz)
    storem2t(1+(LJZ-1)*MD2T+2)=reflectiondata(1)*symm_operators(1+2, ljz)+reflectiondata(1+1)*symm_operators(1+5, ljz)+ &
    &   reflectiondata(1+2)*symm_operators(1+8, ljz)
! calculate the h.t terms
    storem2t(1+(LJZ-1)*MD2T+3)=(reflectiondata(1)*symm_operators(1+9, ljz)+reflectiondata(1+1)*symm_operators(1+10, ljz)+ &
    &   reflectiondata(1+2)*symm_operators(1+11, ljz))
    
    if ( ( LJZ .EQ. 1 ) .OR. ( .NOT. ISO_ONLY ) ) then 
!
! aniso contributions are required
! compute h'.h', h'.k' etc 
!
        storem2t(1+(LJZ-1)*MD2T+4:1+(LJZ-1)*MD2T+6)=storem2t(1+(LJZ-1)*MD2T:1+(LJZ-1)*MD2T+2)**2
        storem2t(1+(LJZ-1)*MD2T+7)=storem2t(1+(LJZ-1)*MD2T+1)*storem2t(1+(LJZ-1)*MD2T+2)
        storem2t(1+(LJZ-1)*MD2T+8)=storem2t(1+(LJZ-1)*MD2T)*storem2t(1+(LJZ-1)*MD2T+2)
        storem2t(1+(LJZ-1)*MD2T+9)=storem2t(1+(LJZ-1)*MD2T)*storem2t(1+(LJZ-1)*MD2T+1)
    end if
    storem2t(1+(LJZ-1)*MD2T:1+(LJZ-1)*MD2T+3)=storem2t(1+(LJZ-1)*MD2T:1+(LJZ-1)*MD2T+3)*TWOPI
end do
!
!--calculate sin(theta)/lambda squared
! Rollett 5.12.8  h"= Uh, U is reciprocal orhogonalisation matrix
! Rollett 5.12.8  sst = h"^t.h" = [sin(theta)/lambda]^2
!
SST=STORE(L1S)*storem2t(1+4)+STORE(L1S+1)*storem2t(1+5) &
&   +STORE(L1S+2)*storem2t(1+6)+STORE(L1S+3)*storem2t(1+7) &
&   +STORE(L1S+4)*storem2t(1+8)+STORE(L1S+5)*storem2t(1+9)
ST=SQRT(SST)
SMIN=MIN(SMIN,ST)
SMAX=MAX(SMAX,ST)
!
!--The temperature factor coefficient TC = -8 Pi^2 [sin(theta)/lambda]^2
!
TC=-SST*TWOPIS*4.
!--CHECK if THE ANISO TERMS ARE REQUIRED
if(.NOT. ISO_ONLY) then 
    M2T=L2T
    do LJZ=1,N2
!
! compute h* = h'.k'.a*.b* etc.
!
        storem2t(1+(LJZ-1)*MD2T+4:1+(LJZ-1)*MD2T+9)=storem2t(1+(LJZ-1)*MD2T+4:1+(LJZ-1)*MD2T+9)*STORE(L1A:L1A+5)
    end do
end if
!
!  st  the value of sin(theta)/lambda for the calculation
!  l3tr and l3ti the real and imaginary components of the scattering factor
!
if(N3>0) then
    call XSCATTnew(SST, formfactors)  ! CALCULATE THE FORM FACTORS
end if
!      write(NCWU,'(A,F16.9,1x,Z0)')'ST:',ST,ST
!      write(NCWU,'(A,4(Z0,1X,F20.16,1X))')'COS consts:',C0,C0,C1,C1,
!     1            C2,C2,C3,C3
!      write(NCWU,'(A,4(Z0,1X,F20.16,1X))')'SIN consts:',S0,S0,S1,S1,
!     1            S2,S2,S3,S3

  
!
! compute the ratio of imaginary to real form (scattering) factors
! This will be a computational convenience later
! Results stored in a stack with one row per element type
! G2 is number of Non-primitive lattice translations (*2 if centre of symmetry)
! T2 is the total number of operators = G2*NOP
!
! For efficiency, the formfactor is multiplied by the number of 
! non-unique operators, G2 before summation over the unique operators
!  Rollett, page 45
!
do LJZ=1,N3
!         STORE(M3TR)=STORE(M3TR+nint(store(m6+13))-1)*G2
!         STORE(M3TI)=STORE(M3TI+nint(store(m6+13))-1)*G2
!         write(NCWU,'(A,F16.9,1x,Z0)')'M3TR1:',STORE(M3TR),STORE(M3TR)
    formfactors(1,(LJZ-1)*md3tr+1)=formfactors(1,(LJZ-1)*md3tr+1)*G2
    formfactors(2,(LJZ-1)*md3ti+1)=formfactors(2,(LJZ-1)*md3ti+1)*G2
    if(formfactors(1,(LJZ-1)*md3tr+1).LE.ZERO)THEN  ! real PART IS ZERO  
        formfactors(2,(LJZ-1)*md3ti+1)=0. ! SO IS THE IMAGINARY NOW
    else   ! real PART IS OKAY
        formfactors(2,(LJZ-1)*md3ti+1)=formfactors(2,(LJZ-1)*md3ti+1)/formfactors(1,(LJZ-1)*md3tr+1)
    end if
!        write(NCWU,'(A,F16.9,1x,Z0)')'M3TR2:',STORE(M3TR),STORE(M3TR)
end do
if(SFLS_TYPE .EQ. SFLS_REFINE) then    ! CHECK IF WE ARE DOING REFINEMENT
    M12=L12                  ! SET THE ATOM POINTER IN LIST 12
end if
!
!--START OF THE LOOP BASED ON THE ATOMS
!
M5A=L5
do LJY=1,N5
    AT=0.  ! CLEAR THE ACCUMULATION VARIABLES
    BT=0.

    ATOM_REFINE = .FALSE. 

    if(SFLS_TYPE .EQ. SFLS_REFINE) then   ! CHECK IF REFINEMENT IS BEING DONE
        !call XZEROF ( ALPD(1),11 )  ! CLEAR PARTIAL DERIVATIVE STACKS
        ALPD(1:11)=0.0
        !call XZEROF ( BLPD(1),11 )
        BLPD(1:11)=0.0
        L12A=ISTORE(M12+1)
        if ( L12A .GE.0 ) ATOM_REFINE = .TRUE.  ! Set if any params of this atom are being refined
        M12=ISTORE(M12)
    end if
!djwsep2010 extend to use dual wavelength anomalous scattering as appropriate 
    M3TR=1+ISTORE(M5A)*MD3TR  ! PICK UP THE FORM FACTORS FOR THIS ATOM
    M3TI=1+ISTORE(M5A)*MD3TI
!
! focc   formfactor * site occ * chemical occ * difabs corection
! modify focc for other fc corrections 
!
    FOCC = formfactors(1, M3TR) * STORE(M5A+2) * STORE(M5A+13) 

    FLAG=STORE(M5A+3)   ! PICK UP THE TYPE OF THIS ATOM
    if(NINT(FLAG) .EQ. 1) then  ! CHECK THE TEMPERAURE TYPE FOR THIS ATOM
!
! calculate the iso-temperature factor coefficients for this atom
! TC = -8 Pi^2 [sin(theta)/lambda]^2
! T = exp(Uiso *TC)
!
#if defined(_GIL_) || defined(_LIN_) 
        T=sleef_expf(real(STORE(M5A+7)*TC))  
#else
        T=EXP(STORE(M5A+7)*TC)  
#endif
        TFOCC=T*FOCC
    end if
!
! L2T is address of symmetry transformed index
!
    M2T=L2T
    M2=L2   ! M2 (ADDR. FOR TRANSF.MAT.) IS RESET TO ADDR. FOR 1ST SYM.OP.
!
! loop cycling over the different equivalent reflections for this atom
!
!  calculate a = h'.x + h.t
    do LJX=1,N2T
        A=STORE(M5A+4)*storem2t(1+(LJX-1)*MD2T)+STORE(M5A+5)*storem2t(1+(LJX-1)*MD2T+1)+ &
        &   STORE(M5A+6)*storem2t(1+(LJX-1)*MD2T+2)+storem2t(1+(LJX-1)*MD2T+3)              
!  slrfac starting-values for special shape factors and derivatives
        SLRFAC=1.0 
        DSIZE=1.0
        DDECLINA=1.0
        DAZIMUTH=1.0

        if (NINT(FLAG) .EQ. 0) then   
!
!  calculate the aniso-temperature factor
!  T=exp(h*Uij + ...)
!  store(mt2+..) is h* where h* = h'.k'.a*.b* etc.

!
#if defined(_GIL_) || defined(_LIN_) 
            T=sleef_expf(real(STORE(M5A+7)*storem2t(1+(LJX-1)*MD2T+4) &
            &   +STORE(M5A+8)*storem2t(1+(LJX-1)*MD2T+5) &
            &   +STORE(M5A+9)*storem2t(1+(LJX-1)*MD2T+6)+STORE(M5A+10)*storem2t(1+(LJX-1)*MD2T+7) &
            &   +STORE(M5A+11)*storem2t(1+(LJX-1)*MD2T+8)+STORE(M5A+12)*storem2t(1+(LJX-1)*MD2T+9)))
            TFOCC=T*FOCC
#else
            T=EXP(STORE(M5A+7)*storem2t(1+(LJX-1)*MD2T+4)+STORE(M5A+8)*storem2t(1+(LJX-1)*MD2T+5) &
            &   +STORE(M5A+9)*storem2t(1+(LJX-1)*MD2T+6)+STORE(M5A+10)*storem2t(1+(LJX-1)*MD2T+7) &
            &   +STORE(M5A+11)*storem2t(1+(LJX-1)*MD2T+8)+STORE(M5A+12)*storem2t(1+(LJX-1)*MD2T+9))
            TFOCC=T*FOCC
#endif
!
        else if ( NINT(FLAG) .GE. 2) then
            if (NINT(FLAG) .EQ. 2) then  ! CALC SPHERE TF
                call XSPHERE (ST, M5A, SLRFAC, DSIZE)
            else if (NINT(FLAG) .EQ. 3) then   ! CALC LINE TF
                call XLINE (M2, M5A, reflectiondata, &
                &   SLRFAC, DSIZE, DDECLINA,DAZIMUTH, store)
            else if (NINT(FLAG) .EQ. 4) then   ! CALC RING TF
                call XRING (M2, ST, M5A,reflectiondata,SLRFAC,DSIZE,DDECLINA,DAZIMUTH, store)
            end if
#if defined(_GIL_) || defined(_LIN_) 
            T=sleef_expf(real(STORE(M5A+7)*TC))
#else
            T=EXP(STORE(M5A+7)*TC)
#endif
            TFOCC=T*FOCC
            TFOCC=TFOCC*SLRFAC
        end if

!--CALCULATE THE SIN/COS TERMS   
! Chebychev approximation replaced with standard calls or sleef
!  dd = 1.0/twopi
!  a = h'.x + h.t
!
#if defined(_GIL_) || defined(_LIN_) 
        c = mod(a,2.0*3.14159265359)
        call sleef_sincosf(c, scb)          
! s = Sin(h'x+ht)
        s=scb(1)
!c c = Cos(h'x+ht)
        c=scb(2)
#else
!c c = Cos(h'x+ht)
        c = cos(a)
! s = Sin(h'x+ht)
        s = sin(a)
#endif
!c
!c Test if  centro with no refinement  -  only cos terms needed
        if(.not. COS_ONLY) then 
!8850      CONTINUE        
!c
!--CALCULATE THE B CONTRIBUTION
            BP=S*TFOCC
            BT=BT+BP
        end if !8900      CONTINUE
!
!--CALCULATE THE A CONTRIBUTION
        AP=C*TFOCC
        AT=AT+AP
!          write(NCWU,'(A,Z0,1X,F15.6)')'AT:',AT,AT
!          write(NCWU,'(A,Z0,1X,F15.6)')'BT:',BT,BT
!         write(NCWU,'(A,2(1X,Z0,1X,F20.16))')'SIN:',S,S, aaas, aaas
!         write(NCWU,'(A,2(1X,Z0,1X,F20.16))')'COS:',C,C, aaac, aaac

!--CHECK if ANY REFINEMENT IS BEING DONE
        if(ATOM_REFINE)THEN
!
!  store(mt2+ 0 to 2) is h' 
!  store(mt2+ 4 to 9) is h* where h* = h'.k'.a*.b* etc.
!  T=exp(h*Uij + ... ) where h* = h'.k'.a*.b* etc.
!  c = cos(hx)
!
!-CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR X,Y AND Z
!-C-C-CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR OCC,X,Y AND Z
            ALPD(1)=ALPD(1)+T*C*SLRFAC
            ALPD(3)=ALPD(3)-storem2t(1+(LJX-1)*MD2T)*BP
            ALPD(4)=ALPD(4)-storem2t(1+(LJX-1)*MD2T+1)*BP
            ALPD(5)=ALPD(5)-storem2t(1+(LJX-1)*MD2T+2)*BP
!--CHECK THE TEMPERATURE FACTOR TYPE
            if(NINT(FLAG) .NE. 1) then
!-C-C-CHECK WHETHER WE HAVE SPHERE, LINE OR RING
                if (NINT(FLAG) .LE. 1) then
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR THE ANISO-TERMS
                    ALPD(6:11)=ALPD(6:11)+storem2t(1+(LJX-1)*MD2T+4:1+(LJX-1)*MD2T+9)*AP
                else
!-C-C-CALC. THE PART. DERIV. W.R.T. A FOR ISO-TERM + SPECIAL FIGURES
                    ALPD(6)=ALPD(6)+TC*AP
                    ALPD(7)=ALPD(7)+((DSIZE*AP)/SLRFAC)
                    ALPD(8)=ALPD(8)+((DDECLINA*AP)/SLRFAC)
                    ALPD(9)=ALPD(9)+((DAZIMUTH*AP)/SLRFAC)
                end if
            else
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. A FOR U[ISO]
                ALPD(6)=ALPD(6)+TC*AP
            end if

!--GOTO THE NEXT PART - DEPENDS ON WHETHER THE STRUCTURE IS CENTRO
            if(.NOT. CENTRO) then
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR X,Y AND Z
!-C-C-CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR OCC,X,Y AND Z
                BLPD(1)=BLPD(1)+T*S*SLRFAC
                BLPD(3)=BLPD(3)+storem2t(1+(LJX-1)*MD2T)*AP
                BLPD(4)=BLPD(4)+storem2t(1+(LJX-1)*MD2T+1)*AP
                BLPD(5)=BLPD(5)+storem2t(1+(LJX-1)*MD2T+2)*AP
!--CHECK THE TEMPERATURE FACTOR TYPE
                if(NINT(FLAG) .NE. 1) then
!-C-C-CHECK WHETHER WE HAVE SPHERE, LINE OR RING
                    if (NINT(FLAG) .LE. 1) then
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR THE ANISO-TERMS
                        BLPD(6:11)=BLPD(6:11)+storem2t(1+(LJX-1)*MD2T+4:1+(LJX-1)*MD2T+9)*BP
                    else
!-C-C-CALC. THE PART. DERIV. W.R.T. B FOR ISO-TERM + SPECIAL FIGURES
                        BLPD(6)=BLPD(6)+TC*BP
                        BLPD(7)=BLPD(7)+((DSIZE*BP)/SLRFAC)
                        BLPD(8)=BLPD(8)+((DDECLINA*BP)/SLRFAC)
                        BLPD(9)=BLPD(9)+((DAZIMUTH*BP)/SLRFAC)
                    end if
                else
!--CALCULATE THE PARTIAL DERIVATIVES W.R.T. B FOR U[ISO]
                    BLPD(6)=BLPD(6)+TC*BP
                end if
            end if
        end if

        M2T=M2T+MD2T  ! UPDATE THE SYMMETRY INFORMATION POINTER
        M2=M2+MD2     ! M2 (ADDR. FOR TRANSF.MAT.) IS INCREASED FOR NEXT SYM.OP.
    END do    ! LOOP ON EQUIVALENT POSITIONS ENDS  -  COMPUTE THE TOTALS FOR THIS ATO

    AC=AC+AT
    BC=BC+BT

    if (ANOMAL) then  ! CHECK IF ANOMALOUS DISPERSION IS BEING CONSIDERED
        AIMAG=ANOM*formfactors(2, M3TI)  ! CALCULATE THE IMAGINARY PARTS
        ACI=ACI-BT*AIMAG
        BCI=BCI+AT*AIMAG
        if (SFLS_TYPE .EQ. SFLS_REFINE) then   ! ANY REFINEMENT AT ALL?
            ACD=ACD-BT*formfactors(2, M3TI)   ! DERIVATIVES FOR POLARITY PARAMETER
            BCD=BCD+AT*formfactors(2, M3TI)
        end if
    end if


    if(ATOM_REFINE)THEN  ! CHECK IF ANY REFINEMENT IS BEING DONE
        ALPD(1) = formfactors(1, M3TR) * STORE(M5A+13) * ALPD(1)  ! CALCULATE THE PARTIAL DERIVATIVES 
        BLPD(1) = formfactors(1, M3TR) * STORE(M5A+13) * BLPD(1)  ! W.R.T. A AND B FOR OCC

        do WHILE (L12A.GT.0)  ! LOOP ADDING THE PARTIAL DERIVATIVES INTO THE TEMPORARY STACKS

            M12A=ISTORE(L12A+4)
            MD12A=ISTORE(L12A+1)  ! SET UP THE CONDITIONS OF THIS ATOM
            LJU=ISTORE(L12A+2)
            LJV=ISTORE(L12A+3)

            if(MD12A.LT.2)THEN    ! WEIGHTS ARE UNITY
                if ( CENTRO ) then
                    if ( ANOMAL ) then    ! UNITY, CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)+ALPD(M12A-1)
                            temporaryderivatives(LJT-JR+1+1)=temporaryderivatives(LJT-JR+1+1)+ALPD(M12A-1)*aimag
                            M12A=M12A+1
                        end do
                    else                 ! UNITY, CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)+ALPD(M12A-1)
                            M12A=M12A+1
                        end do
                    end if
                else
                    if ( ANOMAL ) then    ! UNITY, NON-CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)+ALPD(M12A-1)
                            temporaryderivatives(LJT-JR+1+3)=temporaryderivatives(LJT-JR+1+3)+ALPD(M12A-1)*aimag
                            temporaryderivatives(LJT-JR+1+2)=temporaryderivatives(LJT-JR+1+2)-BLPD(M12A-1)*aimag
                            temporaryderivatives(LJT-JR+1+1)=temporaryderivatives(LJT-JR+1+1)+BLPD(M12A-1)
                            M12A=M12A+1
                        end do
                    else                  ! UNITY, NON-CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)+ALPD(M12A-1)
                            temporaryderivatives(LJT-JR+1+1)=temporaryderivatives(LJT-JR+1+1)+BLPD(M12A-1)
                            M12A=M12A+1
                        end do
                    end if
                end if
            else       ! WEIGHTS DifFER FROM UNITY
                if ( CENTRO ) then
                    if ( ANOMAL ) then    ! NON-UNITY, CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            A=ALPD(M12A-1)*STORE(LJW+1)
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)+A
                            temporaryderivatives(LJT-JR+1+1)=temporaryderivatives(LJT-JR+1+1)+A*aimag
                            M12A=M12A+1
                        end do
                    else                 ! NON-UNITY, CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)+ALPD(M12A-1)*STORE(LJW+1)
                            M12A=M12A+1
                        end do
                    end if
                else
                    if ( ANOMAL ) then  ! NON-UNITY, NON-CENTRO AND ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)+ALPD(M12A-1)*STORE(LJW+1)
                            A=STORE(LJW+1)*AIMAG
                            temporaryderivatives(LJT-JR+1+3)=temporaryderivatives(LJT-JR+1+3)+ALPD(M12A-1)*A
                            temporaryderivatives(LJT-JR+1+2)=temporaryderivatives(LJT-JR+1+2)-BLPD(M12A-1)*A
                            temporaryderivatives(LJT-JR+1+1)=temporaryderivatives(LJT-JR+1+1)+BLPD(M12A-1)*STORE(LJW+1)
                            M12A=M12A+1
                        end do
                    else               ! NON-UNITY, NON-CENTRO AND NO ANOMALOUS DISPERSION
                        do LJW=LJU,LJV,MD12A
                            LJT=ISTORE(LJW)
                            temporaryderivatives(LJT-JR+1)=temporaryderivatives(LJT-JR+1)*STORE(LJW+1)
                            temporaryderivatives(LJT-JR+1+1)=temporaryderivatives(LJT-JR+1+1)+BLPD(M12A-1)*STORE(LJW+1)
                            M12A=M12A+1
                        end do
                  end if
                end if
            end if
            L12A=ISTORE(L12A)
        END do            
    end if
    M5A=M5A+MD5A
END do             ! END OF ATOM CYCLING LOOP

if(CENTRO) then ! CHECK IF THIS STRUCTURE IS CENTRO
    BC=0.         ! Zero appropriate parts.
    ACI=0.
end if

reflectiondata(MD6+1)=AC
reflectiondata(MD6+2)=aCi
reflectiondata(MD6+3)=bc
reflectiondata(MD6+4)=bCI
reflectiondata(MD6+5)=pshift
reflectiondata(MD6+6)=fried

M2I=L2I
END

!CODE FOR XAB2FC
subroutine XAB2FC(reflectiondata, scalew, partialderivatives,temporaryderivatives)
!--CONVERSION OF THE A AND B PARTS INTO /FC/ TERMS
!

! all module variables used here are read only

!include 'ISTORE.INC'
!include 'STORE.INC'
!use store_mod, only:store, istore
!include 'XSFWK.INC90'
use xsfwk_mod, only: enant, cenant ! constant in xsflc
!include 'XWORKB.INC'
use xworkb_mod, only: jn, jq ! constant in xsflc
!include 'XSFLSW.INC90'
use xsflsw_mod, only: sfls_type, sfls_refine, enantio, centro, anomal ! constant in xsflc
!include 'XLST06.INC90'
use xconst_mod, only: zero, twopi
use xlst06_mod, only: md6

implicit none

!include 'QSTORE.INC'

real cosa, cospn, fcsq, fesq, fn, fnsq, fp
real sina, sinpn, temp, sinp, cosp, act, bct
real, dimension(:), intent(inout) :: reflectiondata
real, intent(in) :: scalew
integer j, ljs, n
real ac, aci, bc, bci, pshift, fried
double precision, dimension(:), intent(out) :: partialderivatives
double precision, dimension(:), intent(in) :: temporaryderivatives

!--FETCH A AND B ETC. FROM THE STACK
!AC=STORE(JREF_STACK_PTR+13)
!ACI=STORE(JREF_STACK_PTR+14)
!BC=STORE(JREF_STACK_PTR+15)
!BCI=STORE(JREF_STACK_PTR+16)
!PSHifT=STORE(JREF_STACK_PTR+11)
!FRIED=STORE(JREF_STACK_PTR+12)

ac=reflectiondata(MD6+1)
aci=reflectiondata(MD6+2)
bc=reflectiondata(MD6+3)
bci=reflectiondata(MD6+4)
pshift=reflectiondata(MD6+5)
fried=reflectiondata(MD6+6)

ACT=AC+ACI*FRIED
BCT=BC*FRIED+BCI

if ( ABS(ACT) .LT. 0.001 .and. ABS(BCT) .LT. 0.001) then  ! A and B-PART are 0
    ACT = 0.000001
    BCT = 0.
end if


!--COMPUTE /FC/ AND THE PHASE FOR THE GIVEN ENANTIOMER
FCSQ = ACT*ACT + BCT*BCT
FP = SQRT(FCSQ)
reflectiondata(1+5) = FP                     ! SAVE THE TOTAL MAGNITUDE
reflectiondata(1+6)=AMOD(ATAN2(BCT,ACT)+PSHifT,TWOPI)  ! THE PHASE

FNSQ = FCSQ

! these are used in test2.tst
! program crashes if they are not set
!STORE(JREF_STACK_PTR+6) = reflectiondata(1+5)
!STORE(JREF_STACK_PTR+7) = reflectiondata(1+6)

if(SFLS_TYPE .EQ. SFLS_REFINE) then   ! CHECK IF WE ARE DOING REFINEMENT
    TEMP = SCALEW / reflectiondata(1+5)   ! TO PERMANENT STORE
    COSP = ACT * TEMP
    SINP = BCT * TEMP
    N = ubound(partialderivatives, 1)

    if ( CENTRO .EQV. ANOMAL ) then ! NON-CENTRO WITHOUT ANOMALOUS DISPERSION
                                    ! OR CENTRO WITH ANOMALOUS
        if ( .NOT. CENTRO ) SINP=SINP*FRIED ! NON-CENTRO WITHOUT AD
        partialderivatives=temporaryderivatives(1:N*JQ:JQ)*COSP+temporaryderivatives(1+1:N*JQ+1:JQ)*SINP
        ! look like dead code
        !STORE(JN+1)=0.0
        !STORE(JN)=0.0
    else if ( CENTRO .AND. (.NOT. ANOMAL) ) then ! CENTRO WITHOUT ANOMALOUS DISPERSION
        
        partialderivatives=temporaryderivatives(1:N*JQ:JQ)*COSP
        ! look like dead code
        !STORE(JN)=0.0
    else                              ! NON-CENTRO WITH ANOMALOUS DISPERSION
        partialderivatives=(temporaryderivatives(1:N*JQ:JQ) + &
        &   temporaryderivatives(1+2:N*JQ+2:JQ)*FRIED)*COSP + &
        &   (temporaryderivatives(1+1:N*JQ+1:JQ)*FRIED + &
        &   temporaryderivatives(1+3:N*JQ+3:JQ))*SINP
        ! look like dead code
        !STORE(JN:JN+3)=0.0
    end if
end if            
END


subroutine XADDPD ( A, JX, JO, JQ, JR, md12a, m12, partialderivatives) 
!include 'ISTORE.INC'
!include 'STORE.INC'
use store_mod, only: store, istore
!include 'XLST12.INC90'
!use xlst12_mod, only: md12a, m12
implicit none
!include 'QSTORE.INC'

real, intent(in) :: a
integer, intent(in) :: jx, jo, jq, jr
integer, intent(inout) :: md12a, m12
double precision, dimension(:), intent(inout) :: partialderivatives

integer ljt, lju

! moved from common block to local variable
integer l12a

!--ROUTINE TO ADD P.D.'S WITH RESPECT TO /FC/ FOR THE OVERALL PARAMETER
!  A     THE DERIVATIVE TO BE ADDED
!  JX    ITS POSITION IN THE OVERALL PARAMETER LIST SET IN M12
!  JO    ADDRESS COMPLETE PARTIAL DERIVATIVES
!  JQ    NUMBER OF PARTIAL DERIVATIVES PER REFLECTION (0,1,2 OR 4)
!  JR    ADDRESS PARTIAL DERIVATIVES BEFORE THEY ARE ADDED TOGETHER

! And in common:
!  M12   ADDRESS OF THE HEADER FOR THE PARAMETER IN LIST 12

!--SET UP THE LIST 12 FLAGS
L12A=ISTORE(M12+1)
do WHILE ( L12A .GT. 0 )
    if(ISTORE(L12A+4).LE.JX)THEN ! THE PART STARTS LOW ENOUGH DOWN
        MD12A=ISTORE(L12A+1)
        LJU=ISTORE(L12A+2)+(JX-ISTORE(L12A+4))*MD12A
        if(LJU.LE.ISTORE(L12A+3)) then  ! CHECK IF THIS PARAMETER IS IN RANGE
            LJT=(ISTORE(LJU)-JR)/JQ  ! FIND PARAMETER IN DERIVATIVE STACK
            if(LJT.GE.0)THEN        ! PARAMETER HAS BEEN REFINED?
                LJT=LJT+JO
                if(MD12A.LT.2)THEN  ! IS WEIGHT GIVEN OR ASSUMED UNITY?
                    partialderivatives(LJT-JO+1)=partialderivatives(LJT-JO+1)+A ! THE WEIGHT IS UNITY
                else
                    partialderivatives(LJT-JO+1)=partialderivatives(LJT-JO+1)+A*STORE(LJU+1)! THIS WEIGHT IS GIVEN
                end if
            end if
        end if
    end if
    L12A=ISTORE(L12A)  ! PASS ONTO THE NEXT PART
end do
END
