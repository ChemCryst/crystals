!> Module dealing with the absolution configuration of the crystal structure
!! 
module absolut_mod

! Constants for the type of data stored
integer, parameter :: C_H=1 !< \f$ h \f$ index
integer, parameter :: C_K=2 !< \f$ k \f$ index
integer, parameter :: C_L=3 !< \f$ l \f$ index
integer, parameter :: C_ZH=4 !< \f$ Z_H = \frac{F_{ckD}-F_{okD}}{\sigma_D} \f$
integer, parameter :: C_FCKA=5 !< \f$ F_{cka} = 0.5 (F_{CK1}+F_{CK2}) \f$
integer, parameter :: C_FOKA=6 !< \f$ F_{oka} = 0.5 (F_{OK1}+F_{OK2}) \f$
integer, parameter :: C_FCKD=7 !< \f$ F_{ckd} = F_{CK1}-F_{CK2} \f$
integer, parameter :: C_FOKD=8 !< \f$ F_{okd} = F_{OK1}-F_{OK2} \f$
integer, parameter :: C_SIGMAD=9 !< \f$ \sqrt{\sigma_1^2+\sigma_2^2} \f$
integer, parameter :: C_SIGMAQ=10 !<   \f$ \sigma_Q = 2.0 \frac{\sqrt{(F_{ok1} \sigma_2)^2+(F_{ok2} \sigma_1)^2}}{(2F_{oka})^2} \f$
integer, parameter :: C_X=11 !< \f$ C_X = \frac{F_{ckd}-F_{okd}}{2 F_{ckd}} \f$
integer, parameter :: C_SX=12 !< \f$ \sigma_{CX} = \frac{\sigma_D}{|2 F_{ckd}|} \f$
integer, parameter :: C_DELTAX=13 !< \f$ \Delta_X = C_X - <C_X> \f$
integer, parameter :: C_FLXWT=14 !< \f$ w = m \frac{1}{\sigma_{C_X}^2} \f$ Blessing type weights
integer, parameter :: C_FAIL=15 !< 0.0 for valid reflections, 1.0 if ailed any filters, 99999.0 if centric or lone reflection
integer, parameter :: C_SIGNOISE=16 !< \f$ \frac{|F_{ckd}|}{\sigma_D} \f$
integer, parameter :: C_FRIED1=17 !< -1 for centric reflections, 0 for lone reflections, 1 for first reflection of friedel pair
integer, parameter :: C_FRIED2=18 !< 0 for missing friedel pair, 2 for second reflection of friedel pair
integer, parameter :: C_FOK1=19 !< \f$ F_{ok1} \f$ Observed structure factor for reflection 1
integer, parameter :: C_SIG1=20 !< \f$ \sigma_1 \f$ Sigma of \f$ F_{ok1} \f$ for reflection 1
integer, parameter :: C_FCK1=21 !< \f$ F_{ck1} \f$ Calculated structure factor for reflection 1
integer, parameter :: C_FOK2=22 !< \f$ F_{ok2} \f$ Observed structure factor for reflection 2
integer, parameter :: C_SIG2=23 !< \f$ \sigma_2 \f$ Sigma of \f$ F_{ok2} \f$ for reflection 2
integer, parameter :: C_FCK2=24 !< \f$ F_{ck2} \f$ Calculated structure factor for reflection 2
integer, parameter :: C_NUMFIELD=24

! COnstants for the filters name
integer, parameter :: C_DSoSDO=1    ! 1 /Ds/ > filter(1)*sigma(Do)
integer, parameter :: C_ASoSAO=2    ! 2  As  > filter(2)*sigma(Ao)
integer, parameter :: C_DOoDSmax=3  ! 3 /Do/ < filter(3)*Ds(max)
integer, parameter :: C_OUTLIER=4   ! 4 Kflack 
integer, parameter :: C_AOoAc=5     ! 5 Ratio Ao/Ac >< filter(5) 
integer, parameter :: C_NUMFILTERS=5

! Platon constants
real, parameter :: STEP=0.025
integer, parameter :: NSP1=NINT(1.0/STEP)
integer, parameter :: NSTP_401=10*NSP1+1
integer, parameter :: NSPT_201=5*NSP1+1
integer, parameter :: NSPM_161=NSPT_201-NSP1
integer, parameter :: NSPP_241=NSPT_201+NSP1

contains

!> Calculate the Hooft parameter
subroutine hooft(reflections_data, filtered_reflections, yslope, tony, tonsy)
use m_mrgrnk
use xiobuf_mod, only: cmon
use xunits_mod, only: ncvdu, ncwu
use xssval_mod, only: issprt
implicit none
real, dimension(:,:), intent(in) :: reflections_data
logical, dimension(:), intent(in) :: filtered_reflections
real, intent(in) :: yslope
real, intent(out) :: tony, tonsy
double precision datcl, datcm, xg, xg0, xg1, xg2, xgs, yk
double precision fokd, fckd, sigmad, rcn, rco, rct
integer i,j,refls_size
double precision, dimension(NSTP_401) :: DATC
double precision xplll, xmnll, xmnll3, xpll2, xplll3, xsmll, xtwll
double precision yunk
character(len=40) form
character(len=80) line
integer iinvert

integer, external :: nctrim

    datc=0.0d0
    rcn=0.0d0
    rct=0.0d0
    refls_size=ubound(reflections_data, 2)

    !c         datc is x(gamma), yk is gamma
    do i=1, refls_size
        if( .not. filtered_reflections(i)) then            
            fckd=reflections_data(C_FCKD, i)
            fokd=reflections_data(C_FOKD, i)
            sigmad=reflections_data(C_SIGMAD, i)
            rcn=rcn+fckd**2/sigmad
            rct=rct+fokd*fckd/sigmad
            do j=1,nstp_401
                yk=(j-nspt_201)*step
                datc(j)=datc(j)-(((yk*fckd-fokd)/sigmad)**2)/2.0d0
            end do
        end if
    end do
    
    datc=datc/yslope**2      

    !    c determine largest and smallest log-probability for scaling
    datcm=datc(1)
    datcl=datc(1)
    do j=2,nstp_401
        if (datc(j).gt.datcm) datcm=datc(j)
        if (datc(j).lt.datcl) datcl=datc(j)
    end do
    !    c calculate g, sigma(g), fleq and sigma(fleq) with bayesian statistics
    xg0=0.0
    xg1=0.0
    xg2=0.0
    !    c equation 23 and 24
    do j=1,nstp_401
        yk=(j-nspt_201)*step
        xg1=xg1+yk*exp(datc(j)-datcm)
        xg0=xg0+exp(datc(j)-datcm)
    end do
    !    c  'g' parameter
    xg=xg1/xg0
    !    c  su 'g' parameter
    do j=1,nstp_401
        yk=(j-nspt_201)*step
        xg2=xg2+(yk-xg)**2*exp(datc(j)-datcm)
    end do
    xgs=sqrt(xg2/xg0)
    !    c  tons-hooft parameters
    tony=(1.0-xg)/2.0
    tonsy=sqrt(xg2/xg0)/2.0
    
    write (cmon,'(a)') ' Hooft Parameter '
    call xprvdu (ncvdu, 1, 0)
    if (issprt.eq.0) then
        write (ncwu,'(a)') trim(cmon(1))
    end if

    ! Statistical tests

    xplll=datc(nspp_241)-datcm
    xmnll=datc(nspm_161)-datcm

    if (abs(rcn)>epsilon(0.0d0)) then
        rco=rct/rcn
    else
        rco=0.0d0
    end if
!c
!c-what is rco? correlation coeficient for npp?
!c       if (issprt.eq.0)
!c     1 write(ncwu,'(a,f12.3)') 'tons rc = ', rco
!c
!c values can be massive - can scaling be improved?
!c      write(ncwu,'(10f12.2)') datc
!c      write(ncwu,'(//4f12.4)') xplll,xmnll, datcm, datcl
!c save some goodies to avoid divide by zero later
    xplll3=xplll
    xmnll3=xmnll
    xplll=exp(xplll)
    xmnll=exp(xmnll)
!c      write(ncwu,'(3e12.4)') xplll,xmnll, xplll+xmnll
!c      write(ncwu,*) xplll,xmnll, xplll+xmnll
!c
!c calculate p2(0)
    if (abs(abs(tony-0.5d0)-0.5d0).lt.max(0.1d0,3.0d0*tonsy)) then
        if ((xplll+xmnll).lt. 0.0d0) then
            if (xplll3.le.xmnll3) then
                xpll2=0.0d0
            else
                xpll2=1.0d0
            end if
        else
            xpll2=xplll/(xplll+xmnll)
        end if
    else
        xpll2=-1.0d0
    end if

    write (cmon,'(a)') ' Hooft probability analysis'
    call xprvdu (ncvdu, 1, 0)
    if (issprt.eq.0) then
        write (ncwu,'(a)') trim(cmon(1))
    end if
!c p2(true)
    write (CMON,'(a,a)') ' For an enantiopure material,', &
    &   ' there are 2 choices, P2'    
    call xprvdu (ncvdu, 1, 0)
    if (issprt.eq.0) then
        write (ncwu,'(a)') trim(cmon(1))
    end if

    if (xpll2.ge.0.0) then
        write (form,2150) xpll2,xpll2
2150      format (x,f9.4,3x,'i.e. ',e12.6)
    else 
        write (form,2200)
2200      format (6x,'does not compute')
    end if
    write (line,2250) form
2250     format (' p2(correct) ',a)
    write (CMON,2300) LINE
    call xprvdu (ncvdu, 1, 0)
    if (issprt.eq.0) write (ncwu,2300) line
2300     format (a)
!c
!c calculate p3(0),p3(tw),p3(1)
    write (cmon,'(/a,a)') ' if 50:50 twinning is possible,',' there are 3 choices, p3'
    call xprvdu (ncvdu, 2, 0)
    if (issprt.eq.0) write (ncwu,'(a)') cmon(1)(:nctrim(cmon(1))),cmon(2)(:nctrim(cmon(2)))
    xtwll=datc(nspt_201)-datcm
    xtwll=exp(xtwll)
    xsmll=xplll+xtwll+xmnll
!c       write(123,'(4e16.4)') xtwll,xplll, xmnll, xsmll
    if (xsmll.gt. 0.0) then
        xplll=xplll/xsmll
        xmnll=xmnll/xsmll
        xtwll=xtwll/xsmll
!c p3(true)
        if (xplll.gt.0.001) then
            write (form,2150) xplll,xplll
        else if (xplll.lt.0.0) then
            write (form,2200)
        else
            write (form,2150) xplll,xplll
        end if
        write (line,2350) form
2350      format (' p3(correct) ',a)
        write (cmon,2300) line
        call xprvdu (ncvdu, 1, 0)
        if (issprt.eq.0) write (ncwu,2300) line
!c p3(twin)
        if (xtwll.gt.0.001) then
            write (form,2150) xtwll,xtwll
        else if (xtwll.lt.0.0) then
            write (form,2200)
        else
            write (form,2150) xtwll,xtwll
        end if
        write (line,2400) form
2400      format (' p3(rac-twin)',a)
        write (cmon,2300) line
        call xprvdu (ncvdu, 1, 0)
        if (issprt.eq.0) write (ncwu,2300) line
!c p3(false)
        if (xmnll.gt.0.001) then
            write (form,2150) xmnll,xmnll
        else if (xmnll.lt.0.0) then
            write (form,2200)
        else
            write (form,2150) xmnll,xmnll
        end if
        write (line,2450) form
2450      format (' p3(inverse) ',a)
        write (cmon,2300) line
!c           call xprvdu (ncvdu, 1, 0)
        if (issprt.eq.0) write (ncwu,2300) line
        write (line,2500) xg
2500      format (' g           ',f9.4)
        if (issprt.eq.0) write (ncwu,2300) line
        yunk=sqrt(xg2/xg0)
        if (yunk.gt.0.0001) then
            write (form,2550) yunk
2550        format (f9.4)
        else
            write (form,2150) yunk,yunk
        end if
        write (line,2600) form
2600      format (' g s.u.      ',a)
        if (issprt.eq.0) write (ncwu,2300) line
        write (cmon,'(/)')
!c          call xprvdu (ncvdu, 1, 0)
        if (issprt.eq.0) write (ncwu,'(a)')cmon(1)(:nctrim(cmon(1)))
    else
        write (cmon,'(a//)') ' data do not resolve the p3 hypothesis'
        call xprvdu (ncvdu, 2, 0)
        if (issprt.eq.0) write (ncwu,'(a//)') cmon(1)(:nctrim(cmon(1)))
    end if


    iinvert = 0
    if ((xpll2 .ge. 0.0).and.(xpll2.le.0.66)) then
        iinvert = 1
    endif
    if((xtwll.le.0.33).and.(xplll.lt.0.33))then
        iinvert = 1
    endif
    if (iinvert .eq. 1) then
        write(cmon,'(a)')'{e you may need to invert the structure'
        call xprvdu (ncvdu,1,0)
    endif

end subroutine

!> slope of the normal probability plot (NPP) 
!! Calculated between 10th and 90th percentile
subroutine npp_slope(reflections_data, filtered_reflections, yslope)
use m_mrgrnk
use xiobuf_mod, only: cmon
use xssval_mod, only: issprt
use xunits_mod, only: ncvdu, ncwu
implicit none
real, dimension(:,:), intent(inout) :: reflections_data
logical, dimension(:), intent(in) :: filtered_reflections
integer, dimension(:), allocatable :: reflections_rank, valid_reflections_indices
real, intent(out) :: yslope
integer iz10, iz90, refls_size, refls_valid_size
real, dimension(3) :: hkl
real ss, sx, sxx, sxy, sy, deter
integer i
real z, zh

integer, external :: nctrim, ksctrn

interface
    function fixquadrant(hklin, friedelarg) result(hklout)
    implicit none
        real, dimension(3), intent(in) :: hklin
        real, dimension(3) :: hklout
        logical, intent(in), optional :: friedelarg
    end function
end interface

    ss=0.0
    sx=0.0
    sy=0.0
    sxx=0.0
    sxy=0.0
    
    refls_size=ubound(reflections_data, 2)
    ! get valid reflections, ie not filtered out
    valid_reflections_indices=pack( (/ (i,i=1,size(filtered_reflections)) /), .not. filtered_reflections)
    refls_valid_size=size(valid_reflections_indices)

    if(refls_valid_size<1) then
        print *, 'Not enough reflections for the normal probability plot'
        return
    end if
    allocate(reflections_rank(refls_valid_size))
    ! Sort the (Do-Dc)/sigma into ascending order.
    call mrgrnk(reflections_data(C_ZH,valid_reflections_indices), reflections_rank)
    reflections_rank=valid_reflections_indices(reflections_rank)

    iz10=CEILING(refls_valid_size*0.1)
    iz90=CEILING(refls_valid_size*0.9)

    ! Slope calculated excluding head and tails
    DO I=iz10,iz90
!c       this time we will use all reflections
!C       Generate Friedel opposite for current HKL:
!C       Work out canonicalized HKL for the Friedel Opposite
        hkl=fixquadrant(-reflections_data( (/C_H,C_K,C_L/), reflections_rank(i)))

!C       WORK OUT EXPECTED NPP VALUE
        z=expected_npp(i, refls_valid_size)
        ZH = reflections_data(C_ZH, reflections_rank(i))

!c       accumulate totals for slope and intercept of NPP
        SS=SS+1.
        SX=SX+Z
        SY=SY+ZH
        SXX=SXX+Z**2
        SXY=SXY+ZH*Z
    ENDDO 

    DETER=SS*SXX-SX*SX
    IF (DETER.NE.0.) THEN
        YSLOPE=(SS*SXY-SX*SY)/DETER
    ELSE
        WRITE (*,'(A)') 'NPP Slope cannot be computed'
        yslope=0.0
    END IF
    
    print *, ''   

end subroutine

!> Expected value of the normal probability plot (npp)
function expected_npp(i, isize) result(z)
implicit none
integer, intent(in) :: i, isize
real pc, b, a, c, z

    pc=(i-0.5)/float(isize)
    a=sqrt(-2.*log(.5-abs(pc-.5)))
    b=0.27061*a+2.30753
    c=a*(a*.04481+.99229)+1
    z=a-b/c
    if (i.le.isize/2) z=-z

end function

!> @brief Average of the ratios method
!! @par
!! compute individual and mean Flack x and sigma, and overall LSQ Flack \n
!! The mean Flack is an Average of Ratios \n
!! The LSQ Flack is a Ratio of Averages \n
!! These will differ if the distribution is far from Normal. \n
!! The Blessing weigting scheme down-weights outliers, keeping \n
!! those reflections with a more or less Normal distribution. 
subroutine average_ratios(reflections_data, filtered_reflections, xbar, sbar)
use xiobuf_mod, only: cmon
use xssval_mod, only: issprt
use xunits_mod, only: ncvdu, ncwu
use m_mrgrnk

implicit none
real, dimension(:,:), intent(inout) :: reflections_data
logical, dimension(:), intent(in) :: filtered_reflections
real sumflx, sumsig, sumwt
integer refls_valid_size, refls_size
integer i
real flxwt
real sbar, xbar


integer, external :: nctrim

!c  Compute Flack for each reflection
    sumflx=0.
    sumsig=0.
    sumwt=0.

    refls_size=ubound(reflections_data,2)

    refls_valid_size=0
    do i=1,refls_size
        if(.not. filtered_reflections(i)) then
            refls_valid_size=refls_valid_size+1
            flxwt = 1./reflections_data(C_SX, i)**2
            sumflx=sumflx+reflections_data(C_X, i)*flxwt
            sumwt=sumwt+flxwt
            sumsig = sumsig + reflections_data(C_SX, i)
        end if
    end do
    
! average Flack(x) and average sigma
    xbar = sumflx/sumwt
    sbar = sumsig/float(refls_valid_size)

end subroutine

!> Filter reflections based on an outlier rejection algorithm
subroutine filter_four(reflections_data, reflections_filters, filter4, ierror)
use xiobuf_mod, only: cmon 
use xssval_mod, only: issprt
use xconst_mod, only: 
use xunits_mod, only: ncvdu, ncwu
implicit none

real, dimension(:,:), intent(inout) :: reflections_data
logical, dimension(:,:), intent(inout) :: reflections_filters
logical, dimension(:), allocatable :: currentfilter
real, intent(out) :: filter4
integer, intent(out) :: ierror
real change, deltax, do, ds, dwt, flackx, flxwt
real fmean, sflackx, sigd, sigint
real smean, sumflx, sumsig, sumwt
real wtmodifier, xbar
integer i, iii, refls_size, nbad, ncycle, ngood, noldgood
integer ntries

integer, external :: nctrim

    noldgood = count(reflections_data(C_FRIED2, :)/=2.0)
    refls_size=ubound(reflections_data, 2)
    allocate(currentfilter(refls_size))
    ncycle = 0
    ierror=0
    ntries=10
    
    !Estimate starting point
    DO i=1,refls_size !1600
        if(reflections_data(C_FRIED2, i)/=2.0) cycle
        flxwt = 1./reflections_data(C_SX, i)**2
        sumflx=sumflx+reflections_data(C_X, i)*flxwt
        sumwt=sumwt+flxwt
        sumsig = sumsig + reflections_data(C_SX, i)    
    end do    
    fmean = sumflx/sumwt
    smean = sumsig/float(count(reflections_data(C_FRIED2, :)==2.0))

    DO iii=1,ntries !1650
        ngood=0
        nbad=0
        sumflx=0.
        sumsig=0.
        sumwt=0.
        currentfilter=.false.

        DO i=1,refls_size !1600
            if(reflections_data(C_FRIED2, i)/=2.0) cycle
            
            do=reflections_data(C_FOKD, i)                           !Do
            Ds=reflections_data(C_FCKD, i)                       !Ds
            sigd=reflections_data(C_SIGMAD, i)                         !sig(Do)
            dwt  =1./(sigd*sigd)                        !Do(wt) = w' = 1/sig(Do)^2
            flackx=reflections_data(C_X, i)                       !x     from A3.13 or A3.1
            sflackx=reflections_data(C_SX, i)                      !sig(x)
            flxwt=1./(sflackx*sflackx)                  !x(wt)= 1/sig(x)^2
            deltax= abs(flackx-fmean)                   !/x-<x>/
            reflections_data(C_DELTAX, i)=deltax
            !c          type 3 is Blessing weight modifier
            wtmodifier=xwtmod(3,smean,deltax,6.)
            flxwt = flxwt*wtmodifier
            dwt = dwt*wtmodifier                         
            reflections_data(C_FLXWT, i)=flxwt
            if (wtmodifier.ge. filter4) then
                !c   average of ratios totals
                sumflx=sumflx+flackx*flxwt                 !Swx  for A3.14
                sumwt=sumwt+flxwt                          !Sw   for A3.14
                sigint = sigint +flxwt*deltax*deltax       !SwDelsq for A3.16
            else
                currentfilter(i)=.true.
                nbad = nbad + 1
            endif
        end do !1600      CONTINUE

        ngood=count(.not. currentfilter)
        if(ngood .ge. 2) then
            !c       average of ratio, mean Flack(x)
            xbar = sumflx/sumwt                   ! x' = Swx/Sw  A3.14
            sigint = sqrt((ngood*sigint)/((ngood-1)*sumwt))   !  A3.16

            !c            re-initialise for next round
            fmean=xbar
            smean=sigint
            ierror=1
        else
            ierror=-1
            if(ierror .le. 0) then
                write(cmon,'(a)') ' Too few reflections for histogram'
                call xprvdu (ncvdu,1,0)
                if (issprt.eq.0)write(ncwu,'(/A)')cmon(1)(:nctrim(cmon(1)))
            endif
            call outcol(1)
            return
        endif
        change = float(noldgood-ngood)/float(ngood)
        ncycle = iii
        if(ncycle.ne.1) then
            if(change .ge. 0.02) then
                noldgood = ngood
            else
                exit
            endif
        endif
    end do !1650    CONTINUE
    reflections_filters(C_OUTLIER,:)=currentfilter
    do i=1, refls_size
        if(currentfilter(i)) then
            reflections_data(C_FAIL,i)=1.0
        end if
    end do
    
    call outcol(9)
    if(ncycle.ge.ntries) then
        write(cmon,'(/A/)')' Histogram analysis failed to converge'
        CALL XPRVDU (NCVDU,3,0)
    endif
    if(ierror .le. 0) then
        write(cmon,'(a)') ' Too few reflections for histogram'
        call xprvdu (ncvdu,1,0)
        if (issprt.eq.0)write(ncwu,'(/A)')cmon(1)(:nctrim(cmon(1)))
    endif
    call outcol(1)
    return
end subroutine

!> This function return a scalar that modifies the weights
function xwtmod(itype,smean,deltax,width)
use xunits_mod, only:
use xiobuf_mod, only:
implicit none

real xwtmod
!> - itype = 1 = unit modifier
!! - itype = 2 = Blessing modifier
!! - itype = 3 = Tukey modifier
integer, intent(in) :: itype
real, intent(in) :: smean, deltax, width
real probx, tukey

    !c     probability - see Blessing J. Appl. Cryst. 
    !c     (1987). 20, 427-428
    probx= exp((-1.*deltax*deltax)/(width*smean*smean))
    !c     Tukey weight, Prince page 82
    if(abs(deltax) .le. width*smean) then
        tukey= (1.-(deltax/(width*smean))**2)**2
    else
        tukey = 0.
    endif
    if (itype.eq.1) then
        xwtmod = 1.
    else if (itype.eq.2) then
        xwtmod = probx
    else
        xwtmod=tukey
    endif
    !c      write(123,'(3f12.4 )') probx,tukey, smean
    return
END function

!> Lepage statistics
subroutine lepage(reflections_data, filtered_reflections)
use xiobuf_mod, only: cmon
use xunits_mod, only: ncvdu, ncwu
use xssval_mod, only: issprt
use m_mrgrnk
!c      One (final?) pass to sort on signal:noise
!c      Format was :   [WDEL,INDICES, Do,Ds,sigmaD, x, sigmax, sigmaQ, ifail]
!c      Format now :   [WDEL,INDICES, Do,Ds,sigmaD, x, sigmax, sig:noise, ifail]
!c                       0      1      2  3    4    5    6        7     8
implicit none
real, dimension(:,:), intent(inout) :: reflections_data 
logical, dimension(:), intent(in) :: filtered_reflections
integer, dimension(:), allocatable :: valid_reflections_indices, reflections_rank
integer i, n, nn, np, npls, ln, lp, n100n, n100p, n10n, n10p
integer n200n, n200p, n20n, n20p, n50n, n50p
integer refls_size, refls_valid_size
integer n6accmedian, n6accn, n6accp
integer nmin
real smin10, smin100, smin20, smin50, smin200
real sminacc, fokd, fckd
integer nmm, nmp, npm, npp
real ymm, ymp, ypm, ypp, xmm, xmp, xpm, xpp
real cdf, q

    !c now sort on signal to noise for Le Page algorithm
    refls_size=ubound(reflections_data,2)

    ! get valid reflections, ie not filtered out
    valid_reflections_indices=pack( (/ (i,i=1,size(filtered_reflections)) /), .not. filtered_reflections)
    refls_valid_size=size(valid_reflections_indices)
    
    ! Sort valid reflections, on signal to noise in reverse order
    allocate(reflections_rank(refls_valid_size))
    call mrgrnk(reflections_data(C_SIGNOISE,valid_reflections_indices), reflections_rank)
    reflections_rank=valid_reflections_indices(reflections_rank)
    reflections_rank=reflections_rank(refls_valid_size:1:-1)
        
    !c
    !c  Lepage totals
    !c
    n6accmedian = refls_valid_size/2
    n10p=0
    n20p=0
    n50p=0
    n100p=0
    n200p=0
    n6accp=0
    n6accn=0
    n10n=0
    n20n=0
    n50n=0
    n100n=0
    n200n=0
    do i=1,refls_valid_size
        lp = 0
        ln = 0
        if(reflections_data(C_FOKD,reflections_rank(i))*reflections_data(C_FCKD, reflections_rank(i)).gt.0.0) then
            lp = 1
        else
            ln = 1
        endif

        if (i .le. 10) then 
            n10p=n10p+lp
            n10n=n10n+ln
            smin10=reflections_data(C_SIGNOISE, reflections_rank(i))
        else if(i .le. 20)then
            n20p=n20p+lp
            n20n=n20n+ln
            smin20=reflections_data(C_SIGNOISE, reflections_rank(i))
        else if(i .le. 50)then
            n50p=n50p+lp
            n50n=n50n+ln
            smin50=reflections_data(C_SIGNOISE, reflections_rank(i))
        else if(i .le. 100)then
            n100p=n100p+lp
            n100n=n100n+ln
            smin100=reflections_data(C_SIGNOISE, reflections_rank(i))
        else if(i .le. 200)then
            n200p=n200p+lp
            n200n=n200n+ln
            smin200=reflections_data(C_SIGNOISE, reflections_rank(i))
        endif
        
        if (i .le. n6accmedian) then
            n6accp=n6accp+lp
            n6accn=n6accn+ln
            sminacc=reflections_data(C_SIGNOISE, reflections_rank(i))
        else
            exit
        endif
    enddo

    npp=0
    xpp=0.0
    ypp=0.0
    nmp=0
    xmp=0.0
    ymp=0.0
    npm=0
    xpm=0.0
    ypm=0.0
    nmm=0
    xmm=0.0
    ymm=0.0
    npls=0
    nmin=0
    do i=1,refls_valid_size
        fokd=reflections_data(C_FOKD,reflections_rank(i))
        fckd=reflections_data(C_FCKD,reflections_rank(i))
    
        !C SORT INTO QUADRANTS
        IF (FokD.GT.0.0) THEN
            IF (FckD.GT.0.0) THEN
                npp=npp+1
                xpp=xpp+fckd
                ypp=ypp+fokd
            else
                nmp=nmp+1
                xmp=xmp+fckd
                ymp=ymp+fokd
            end if
        else
            if (fckd.gt.0.0) then
                npm=npm+1
                xpm=xpm+fckd
                ypm=ypm+fokd
            else
                nmm=nmm+1
                xmm=xmm+fckd
                ymm=ymm+fokd
            end if    
        end if
        
        if (fokd*fckd.gt.0.0) then
        !c  same sign
            npls=npls+1
        else
        !c  opposite sign
            nmin=nmin+1
        end if        
    end do

    !c write lots of diagnostics
    !c
    IF (ISSPRT.EQ.0) THEN
        if(nmp.gt.0) then 
            xmp=xmp/nmp
            ymp=ymp/nmp
        else
            xmp = 0.
            ymp = 0.
        endif
        if(npp.gt.0) then
            xpp=xpp/npp
            ypp=ypp/npp
        else
            xpp = 0.
            ypp = 0.
        endif
        if(nmm.gt.0) then
            xmm=xmm/nmm
            ymm=ymm/nmm
        else
            xmm = 0.
            ymm = 0.
        endif
        if(npm.gt.0) then
            xpm=xpm/npm
            ypm=ypm/npm
        else
            xpm = 0.
            ypm = 0.
        endif


        WRITE (*,1950) 
1950    FORMAT (//' No of pairs for which delta(Io)', &
        &   ' has same sign as delta(Is)')
        WRITE (*,2000)
2000    FORMAT (' Same sign',3X,'Opposite sign')
        WRITE (*,2050) NPLS,NMIN
2050    FORMAT (I8,6X,I8)

        write(*,'(2x,a/2x,a)') &
        &   ' LePage Analysis (Assuming Enantio-purity)', &
        &   ' Data are ranked by the Signal:Noise'
        if(issprt.eq.0) then
            write(*,'(//2x,a/a)') &
            &   ' LePage Analysis (Assuming Enantio-purity)', &
            &   ' Data are ranked by the Signal:Noise'
        end if
        if(refls_size .le. 0) then
            write(*,'(a)') ' No suitable reflections for LePage analysis'
            if(issprt.eq.0) then
                write(ncwu,'(a///)') ' No suitable reflections for LePage analysis'
            end if
        else
            write(*,'(a,f8.4)') ' Minimum signal : noise used =', smin200
            WRITE(*,'(A,I5)') ' No. Available', refls_valid_size
            write(*,'(a,2x,a,2x,a,2x,a,2x,a)') &
            &   '  Range  ','No.Same','No.Opposite', 'Signal:noise', &
            &   ' Prob Wrong Hand'
            nn = 0
            np = 0
            q = 0.5
            nn = nn + n10n
            np = np + n10p
            n = np+nn
            if (n.gt.0)then
                call bincdf(float(np),q,n,cdf)
                write(*,1720) 0, n, np, nn, smin10, 1.-cdf
            endif
            nn = nn + n20n
            np = np + n20p
            n = np+nn
            if (n.gt.0)then
                call bincdf(float(np),q,n,cdf)
                write(*,1720) 0, n, np, nn, smin20, 1.-cdf
            endif
            nn = nn + n50n
            np = np + n50p
            n = np+nn
            if (n.gt.0)then
                call bincdf(float(np),q,n,cdf)
                write(*,1720) 0, n, np, nn, smin50, 1.-cdf
            endif
            nn = nn + n100n
            np = np + n100p
            n = np+nn
            if (n.gt.0) then
                call bincdf(float(np),q,n,cdf)
                write(*,1720) 0, n, np, nn, smin100, 1.-cdf
            endif
            nn = nn + n200n
            np = np + n200p
            n = np+nn
            if (n.gt.0) then
                 call bincdf(float(np),q,n,cdf)
                 write(*,1720) 0, n, np, nn, smin200, 1.-cdf
            endif

            nn = n6accn
            np = n6accp
            n = np+nn
            if (n.gt.0) then
                 print *, ''
                 Write(*,'(2x,a)') ' Top 50% of data'
                 write(*,1720) 0, n, np, nn, sminacc, 1.-cdf
            endif

             q = 0.5
            nn = n10n
            np = n10p
            n = np+nn
            print *, ''
            print *, ''
            if (n.gt.0) then
                 call bincdf(float(np),q,n,cdf)
                 write(*,1720) 0, 10, np, nn, smin10, 1.-cdf
            endif
            nn = n20n
            np = n20p
            n = np+nn
            if (n.gt.0) then
                 call bincdf(float(np),q,n,cdf)
                 write(*,1720) 10,20, np, nn, smin20, 1.-cdf
            endif
            nn = n50n
            np = n50p
            n = np+nn
            if (n.gt.0) then
                 call bincdf(float(np),q,n,cdf)
                 write(*,1720) 20,50, np, nn, smin50, 1.-cdf
            endif
            nn = n100n
            np = n100p
            n = np+nn
            if (n.gt.0) then
                 call bincdf(float(np),q,n,cdf)
                 write(*,1720) 50,100, np, nn, smin100, 1.-cdf
            endif
            nn = n200n
            np = n200p
            n = np+nn
            if (n.gt.0) then
                 call bincdf(float(np),q,n,cdf)
                 write(*,1720) 100,200, np, nn, smin200, 1.-cdf
            endif
        endif
    end if

1720        format(i3,i5,2x,i7,2x,i5,8x,f8.4,2x, f14.3)  

end subroutine

!> least squares best line, based on Bevington, Chapter 6 \n
!!  see also http://mathworld.wolfram.com/LeastSquaresFitting.html \n
!!  y = a + bx \n
!! \n
!! verified against Watts & Halliwell, Essential Environmental \n
!! Science, Routledge, 1996. 
subroutine linearfit(x,y,wt,a,sa,b,sb,t,tsq,r,rsq,tensor)
use xssval_mod, only: issprt
use xunits_mod, only: ncvdu, ncwu
implicit none
real, dimension(:), intent(in) :: x !< x-values
real, dimension(:), intent(in) :: y !< y-values
real, dimension(:), intent(in) :: wt !< weights
real, intent(out) :: a,sa !< Intercept and su
real, intent(out) :: b,sb !< slope and its su
real, intent(out) :: t !< t   = t in Watts & Halliwell page 113
real, intent(out) :: tsq !c tsq = F-test in Excel
real, intent(out) :: r !< r   = r in Watts & Halliwell, page 111
real, intent(out) :: rsq !< rsq = r-sq in Excel,  & W&H, page 112
real, dimension(3), intent(out) :: tensor !< variance/covariance matrix

real ss,sx,sxx,sy,syy,sxy,sqs,wsa,wsb, denom
integer mitem

    mitem=size(x)
    
    ss=sum(wt)
    sx=sum(x*wt)
    sxx=sum(x**2*wt)
    sy=sum(y*wt)
    syy=sum(y**2*wt)
    sxy=sum(x*y*wt)

    denom = ss*sxx - sx*sx

    if(abs(denom) > 0.0 ) then
        a = (sy*sxx - sx*sxy)/denom
        b = (ss*sxy - sx*sy)/denom

        !c This bit based on Wolfram world but including weights (derived by DJW so 
        !c beware)
        !c But see also Analysis of Straight Line Data, F.S. Acton (1966)
        !c Dover Publications
        sqs = ((syy*sxx)-(sxy*sxy))/ ((mitem-2)*sxx)
        sa = (sx*sx)/(mitem*mitem*sxx) +(1./float(mitem))
        wsa = sa * sqs
        wsb = (((syy*sxx)-(sxy*sxy))/((mitem-2)*sxx*sxx))
        !c in the end this was not used, but Bevington's simpler formula chosen.
        !c  
        !c Data Reduction and Error Analysis for the Physical Sciences
        !c PR Bevington, 1969, McGraw-Hill.  Page 118
        !c
        sa = sxx/denom
        sb = ss / denom
        !c
        !c      write(123,'(a,4f12.8)')'wsa,wsb,sa,sb',
        !c     1 sqrt(wsa),sqrt(wsb),sqrt(sa),sqrt(sb)
        !c
        if (sa .ge. 0.0) then
            sa = sqrt(sa)
        else
        !c                write(ncwu,*) 'Sa negative', sa
            sa = -999.
        endif
        if (sb .ge. 0.0) then
            sb = sqrt(sb)
        else
        !c                  write(ncwu,*) 'Sb negative', sb
            sb = -999.
        endif
        !c            write(ncwu,'(2(a,4f10.3))') ' Gradient and esd', b, sb
        !c      1      ' Intercept and su', a, sa
        !c
        tensor(1)=sxx
        tensor(2)=sxy
        tensor(3)=syy
    else
        if (issprt .eq. 0) THEN
            write(ncwu,*)'Denominator 1 in linfit = ', denom
        END IF
    endif

    !c r   = r in Watts & Halliwell, page 111
    !c rsq = r-sq in Excel,  & W&H, page 112
    !c t   = t in Watts & Halliwell page 113
    !c tsq = F-test in Excel

    denom=(ss*sxx-sx*sx)*(ss*syy-sy*sy)
    if(denom .gt. 0.0) then
        r    =  (ss*sxy-sx*sy)/sqrt(denom)
        rsq  = r * r
        if ((ss .ge. 2.).and.(1. .ge. rsq)) then
            t   =  r*sqrt(ss-2.)/sqrt(1.-rsq)
            tsq =  rsq*(ss-2.)/(1.-rsq)
        else   
            t = -999.
            tsq = -999.
        endif
    else
        if (issprt .eq. 0) THEN
            write(ncwu,*)'Denominator 2 in linfit = ', denom
        end if
    endif
    
    !500     format (A,t40,2f11.3,4x,i7)
    !501     format (A,t40,2f11.7,4x,i7)
    !c        ax = max(xmax,ymax)
    !c        if (issprt .eq. 0) THEN
    !c          if (ax .ge. .001) then
    !c          write(NCWU,500) 
    !c     1 'Weighted averages of x and y', sx/ss, sy/ss, mitem
    !c           write(NCWU,500) 'Weighted RMS',
    !!c     1  sqrt(sxx/mitem), sqrt(syy/mitem)
    !c           write(NCWU,500) 'Weighted Maxima  ', xmax, ymax
    !c          else
    !c           write(NCWU,501) 
    !c     1 'Weighted averages of x and y', sx/mitem, sy/mitem, mitem
    !c           write(NCWU,501) 'Weighted RMS',
    !c     1  sqrt(sxx/mitem), sqrt(syy/mitem)
    !c           write(NCWU,501) 'Weighted Maxima  ', xmax, ymax
    !c          endif
    !c        endif
    !c

end subroutine

!> Hole in one method
subroutine hole_in_one(reflections_data, filtered_reflections, hin1, hin1su, weights)
implicit none
real, dimension(:,:), intent(in) :: reflections_data
logical, dimension(:), intent(in) :: filtered_reflections
real, dimension(:), optional, intent(in) :: weights
real, intent(out) :: hin1, hin1su
real, dimension(:,:), allocatable :: buffertemp
integer i, j, k
real a,sa,b,sb,t,tsq,r,rsq
real, dimension(3) :: tensor

    !Check input data
    if(ubound(reflections_data, 2)/=size(filtered_reflections)) then
        print *, "Arguments size don't match in subroutine bijvoet_difference"
        stop
    end if
    
    if(present(weights)) then
        if(size(weights)/=size(filtered_reflections)) then
            print *, "Arguments size don't match in subroutine bijvoet_difference"
            stop
        end if
    end if

    ! select valid reflections (friedel pairs not filtered out)
    i=count(.not. filtered_reflections)
    if(i>1) then
        allocate(buffertemp(2*i,3))
        k=-1
        do j=1, ubound(reflections_data, 2)
            if(.not. filtered_reflections(j)) then
                ! x, y, wt
                k=k+1
                buffertemp(k*2+1,1)=reflections_data(C_FCK2,j)-reflections_data(C_FCK1,j)
                buffertemp(k*2+1,2)=reflections_data(C_FOK1,j)-reflections_data(C_FCK1,j)
                if(present(weights)) then
                    buffertemp(k*2+1,3)=weights(j)
                else
                    buffertemp(k*2+1,3)=1./reflections_data(C_SIG1,j)**2
                end if
                buffertemp(k*2+2,1)=reflections_data(C_FCK1,j)-reflections_data(C_FCK2,j)
                buffertemp(k*2+2,2)=reflections_data(C_FOK2,j)-reflections_data(C_FCK2,j)
                if(present(weights)) then
                    buffertemp(k*2+1,3)=weights(j)
                else
                    buffertemp(k*2+2,3)=1./reflections_data(C_SIG2,j)**2
                end if
            end if
        end do

        call linearfit(buffertemp(:,1),buffertemp(:,2),buffertemp(:,3), &
        &     a,sa,b,sb,t,tsq,r,rsq,tensor)
        hin1 = b
        hin1su = sb
    else
        hin1 = 0.0
        hin1su = 0.0       
    end if    

end subroutine

!> Flack parameter extracted from refinement plus statistics
subroutine howard_goodies(reflections_data, xflack, qflack, friedif, distmax)
use xiobuf_mod, only: cmon
use xssval_mod, only: issprt
use xunits_mod, only: ncvdu, ncwu
use xlst30_mod
use xconst_mod, only: zero
use xlst05_mod
implicit none
real, dimension(:,:), intent(in) :: reflections_data
real, intent(in) :: friedif
real, intent(out) :: xflack, qflack
real, intent(out) :: distmax
real,  dimension(8) :: hflack
integer refls_size, i, kdjw, nfc, nfo
real flrnum, flrden, preflack, stnfc, stnfcm, stnfo, stnfom
integer, parameter :: nplt=10
integer ifoplt(2*nplt+1), ifcplt(2*nplt+1)
real, parameter :: distplt = 3.0

include  'STORE.INC'

    refls_size=ubound(reflections_data, 2)

    if(store(l30ge+7).le.zero) then
        call outcol(9)
        write(cmon,'(/a/)') '{I You should refine the Flack(x) parameter'
        call xprvdu (ncvdu, 3, 0)
        call outcol(1)
    endif
    xflack = store(l5o+4)
    qflack = store(l30ge+7)
    print *, 'Flack parameter obtained from refinement ', xflack, qflack

!c-----multiplier to correct fC for flack parameter value
    preflack=1.-2.*xflack

    hflack=0.0
    flrnum=0.0
    flrden=0.0
    do i=1, refls_size
        if(reflections_data(C_FRIED2,i)==2.0) then
            ! we have a friedel pair, we do not use filters here
            !C  Accumulate info to RA        
            hflack(1)=hflack(1)+ABS(reflections_data(C_FOKA,i)-reflections_data(C_FCKA,i))
            hflack(2)=hflack(2)+abs(reflections_data(C_FOKA,i))
            !c  accumulate info to rd
            hflack(3)=hflack(3)+abs(reflections_data(C_FOKD,i)-preflack*reflections_data(C_FCKD,i))
            hflack(4)=hflack(4)+abs(reflections_data(C_FOKD,i))
            !c  accumulate info to ra2
            hflack(5)=hflack(5)+ &
            &   (reflections_data(C_FOKA,i)-reflections_data(C_FCKA,i))**2/ &
            &   (reflections_data(C_SIG1,i)**2+reflections_data(C_SIG2,i)**2)
            hflack(6)=hflack(6)+reflections_data(C_FOKA,i)**2/ &
            &   (reflections_data(C_SIG1,i)**2+reflections_data(C_SIG2,i)**2)
            !c  accumulate info to rd2
            hflack(7)=hflack(7)+(reflections_data(C_FOKD,i)- &
            &   preflack*reflections_data(C_FCKD,i))**2/ &
            &   (reflections_data(C_SIG1,i)**2+reflections_data(C_SIG2,i)**2)
            hflack(8)=hflack(8)+reflections_data(C_FOKD,i)**2/ &
            &   (reflections_data(C_SIG1,i)**2+reflections_data(C_SIG2,i)**2)

            flrnum=flrnum+abs(reflections_data(C_FOKD,i) - preflack*reflections_data(C_FCKD,i))
            flrden=flrden+abs(reflections_data(C_FOKD,i))
        end if
    end do

    if(any(hflack/=0.0)) then  
        if(issprt.eq.0) then
            write(*,'(a)') '   RA   RD    wRA2  wRD2   Friedif for all data and x=zero'
            write(*,"(4F6.1,2X, F8.2/)") &
            &   100.*HFLACK(1)/HFLACK(2), &
            &   100.*HFLACK(3)/HFLACK(4), &
            &   100.*SQRT(HFLACK(5)/HFLACK(6)), &
            &   100.*SQRT(HFLACK(7)/HFLACK(8)),FRIEDIF
        endif
    end if


    WRITE (*,'(a,f6.2,a,f4.2,a,f7.2,a)') &
    &   ' Do-Dm R-factor(%) with Flack(x) of ', &
    &   xflack, '(',qflack,') = ', &
    &   100.*FLRNUM/FLRDEN,'%'

!C SIGNAL:NOISE FOR DELTA FO AND FC
    STNFOM=-huge(1.0)
    STNFCM=-huge(1.0)
    ifoplt=0
    ifcplt=0
    do i=1, refls_size
        if(reflections_data(C_FRIED2,i)==2.0) then
            STNFO=reflections_data(C_FOKD,i)/reflections_data(C_SIGMAD,i)
            STNFC=reflections_data(C_FCKD,i)/reflections_data(C_SIGMAD,i)
            stnfom=max(stnfom,stnfo)
            stnfcm=max(stnfcm,stnfc)
            nfo=nint(distplt*stnfo)+nplt+1   
            nfo=max(nfo,1)
            nfo=min(nfo,2*nplt+1)
            nfc=nint(distplt*stnfc)+nplt+1
            nfc=max(nfc,1)
            nfc=min(nfc,2*nplt+1)
            ifoplt(nfo)=ifoplt(nfo)+1
            ifcplt(nfc)=ifcplt(nfc)+1
        end if
    end do
    if(issprt.eq.0)then
        WRITE (*,'(A/A)')  &
        &   ' Distribution of NINT(D/sigma) for all data', &
        &   ' Rabinovich & Hope, Acta A36, (1980), 670-674'
        WRITE (*,'(a,21I6)') 'Do',IFOPLT
        WRITE (*,'(a,21I6)') 'Dc',IFCPLT
        WRITE (*,'(a,21F6.2)') &
        &   ' n',((KDJW/DISTPLT),KDJW=-NPLT,NPLT,1)
    endif

    distmax=float(max(maxval(ifoplt), maxval(ifcplt)))
    
end subroutine

!> Different percentiles from a sorted serie
subroutine percentiles(sortedvalues, f1decile, f1octile, f1quintile, fquart, fmedian, &
&   f3quart, f4quintile, f7octile, f9decile)
implicit none
real, dimension(:), intent(in) :: sortedvalues
real, intent(out) :: f1decile, f1octile, f1quintile, fquart, fmedian
real, intent(out) :: f3quart, f4quintile, f7octile, f9decile
integer nsize

        nsize=size(sortedvalues)
        fmedian=sortedvalues(nsize/2)
        fquart=sortedvalues(nsize/4)
        f3quart=sortedvalues(3*nsize/4)
        f1quintile=sortedvalues(nsize/5)
        f4quintile=sortedvalues(4*nsize/5)
        f1octile=sortedvalues(nsize/8)
        f7octile=sortedvalues(7*nsize/8)
        f1decile=sortedvalues(nsize/10)
        f9decile=sortedvalues(9*nsize/10)
end subroutine

!> Get friedif (calculated somewhere else)
subroutine getfriedif(reflections_data, friedif)
use xiobuf_mod, only: cmon
use xunits_mod, only: ncvdu, ncwu
use xssval_mod, only: issprt
implicit none
real, dimension(:,:), intent(inout) :: reflections_data
real, intent(out) :: friedif
real, dimension(12) :: aprop
real obstocal
integer i

integer, external :: kcprop

    I=KCPROP(APROP)
    if(i .le. 0) then
        write(cmon,'(a)')'  Lists 3,5 and 29 may be incompatible'
        call outcol(3)
        call xprvdu(ncvdu,1,0)
        call outcol(1)
        if(issprt.eq.0) then
            write(ncwu,'(a)')'  Lists 3,5 and 29 may be incompatible'
        end if
    endif
    FRIEDIF=APROP(11)

    print *, 'Friedif = ', friedif, ' Acta A63, (2007), 257-265'
    print *, 'Flack & Shmueli (2007) recommend a value >200 for'
    print *, 'general structures and >80 for enantiopure crystals'   
    print *, ''   

    obstocal=sqrt(sum(reflections_data(C_FOKD,:)**2)/sum(reflections_data(C_FCKD,:)**2))
    print *, ' Observed:calculated signal  =', obstocal
    if(obstocal>3) then
        print *, ' The observed Bijvoet differences are much', &
        &   ' greater than the calculated differences'
    end if
    print *, ''

end subroutine

!> Apply all the filters to the reflection list
subroutine applyfilters(reflections_data, reflections_filters, filter)
implicit none
real, dimension(:,:), intent(inout) :: reflections_data
logical, dimension(:,:), intent(out)  :: reflections_filters
real, dimension(5) :: filter
real dcmax, q
integer i, ierror


!------------------------------------- Start of filters
!c accept reflections where:
!c1      /Ds/ > f1 sigma(Do)
!c2       As  > f2 sigma(Ao)
!c3      /Do/ < f3 Ds(max)
!c
!c         fcka is average of Fc
!c         FckD is difference of Fc
!c

    dcmax=maxval(abs(reflections_data(C_FCKD,:)))
    do i=1, ubound(reflections_data, 2)
! filter 1 C_DSoSDO
        if(abs(reflections_data(C_FCKD,i)) < filter(C_DSoSDO)*reflections_data(C_SIGMAD,i)) then
          reflections_filters(C_DSoSDO, i)= .True.
          reflections_data(C_FAIL, i)=1.0
        endif

! filter 2 C_ASoSAO
        if(      reflections_data(C_FCKA,i) < filter(C_ASoSAO)*0.5*reflections_data(C_SIGMAD,i) &
        &   .or. reflections_data(C_FOKA,i) < filter(C_ASoSAO)*0.5*reflections_data(C_SIGMAD,i) ) then
            reflections_filters(C_ASoSAO, i)=.True.
            reflections_data(C_FAIL, i)=1.0
        end if

! filter 3 This one depends on FCKD C_DOoDSmax
!c           watch out for unreasonably large Do
        if (abs(reflections_data(C_FOKD, i)).ge. filter(C_DOoDSmax)*dcmax) then
            reflections_data(C_FAIL, i)=1.0
            reflections_filters(C_AOoAc, i)=.true.
        endif
 
! filter 4 C_OUTLIER
        ! done later

! filter 5 special test for poor agreement C_ASoSAO
        q = abs(max(reflections_data(C_FOKA,i),reflections_data(C_FCKA,i)) / &
        &   min(reflections_data(C_FOKA,i),reflections_data(C_FCKA,i))) 
        if(Q .gt. filter(C_AOoAc)) then
            reflections_filters(C_ASoSAO, i)=.True.
            reflections_data(C_FAIL, i)=1.0
        end if
    end do

! filter 4    
      call filter_four(reflections_data, reflections_filters, filter(4), ierror)
    
end subroutine

!> Absolute configuration using Bijvoet differences
subroutine bijvoet_differences(reflections_data, filtered_reflections, itype, bijvoet, bijvoetsu, weights)
implicit none
real, dimension(:,:), intent(in) :: reflections_data
logical, dimension(:), intent(in) :: filtered_reflections
real, dimension(:), optional, intent(in) :: weights
real, intent(out) :: bijvoet, bijvoetsu
integer, intent(in) :: itype
real, dimension(:,:), allocatable :: buffertemp
integer i, j, k
real a,sa,b,sb,t,tsq,r,rsq
real, dimension(3) :: tensor

    !Check input data
    if(ubound(reflections_data, 2)/=size(filtered_reflections)) then
        print *, "Arguments size don't match in subroutine bijvoet_difference"
        stop
    end if
    
    if(present(weights)) then
        if(size(weights)/=size(filtered_reflections)) then
            print *, "Arguments size don't match in subroutine bijvoet_difference"
            stop
        end if
    end if

    ! select valid reflections (friedel pairs not filtered out)
    i=count(.not. filtered_reflections)
    if(i>1) then
        allocate(buffertemp(i,3))
        k=0
        do j=1, ubound(reflections_data, 2)
            if(.not. filtered_reflections(j)) then
                ! x, y, wt
                k=k+1
                if(itype==1) then
                    buffertemp(k,1)=reflections_data(C_FCKD,j)
                    buffertemp(k,2)=reflections_data(C_FOKD,j)
                    if(present(weights)) then
                        buffertemp(k,3)=weights(j)
                    else
                        buffertemp(k,3)=1./reflections_data(C_SIGMAD,j)**2
                    end if
                else
                    buffertemp(k,1)=reflections_data(C_FCKD,j)/(2.0*reflections_data(C_FCKA,j))
                    buffertemp(k,2)=reflections_data(C_FOKD,j)/(2.0*reflections_data(C_FOKA,j))
                    if(present(weights)) then
                        buffertemp(k,3)=weights(j)
                    else
                        buffertemp(k,3)=1./reflections_data(C_SIGMAQ,j)**2
                    end if
                end if
            end if
        end do

        call linearfit(buffertemp(:,1),buffertemp(:,2),buffertemp(:,3), &
        &     a,sa,b,sb,t,tsq,r,rsq,tensor)
        bijvoet = 0.5*(1.0-b)
        bijvoetsu = 0.5*sb
    else
        bijvoet = 0.0
        bijvoetsu = 0.0       
    end if    
    print *, ''  

end subroutine

!> Proof of concept for a graph
subroutine plot_something(reflections_data, filtered_reflections)
use xiobuf_mod, only: cmon
use xunits_mod, only: ncvdu, ncwu
implicit none
real, dimension(:,:), intent(in) :: reflections_data
logical, dimension(:), intent(in) :: filtered_reflections
integer, parameter :: nplt=10
integer, dimension(2*nplt+1) :: ifoplt, ifcplt
real, parameter :: distplt = 3.0
integer i, nfc, nfo, refls_size
real distmax, stnfc, stnfo

    ifoplt=0
    ifcplt=0
    refls_size=ubound(reflections_data, 2)
    do i=1, refls_size
        if(.not. filtered_reflections(i)) then
            stnfo=reflections_data(C_FOKD, i)/reflections_data(C_SIGMAD, i)
            stnfc=reflections_data(C_FCKD, i)/reflections_data(C_SIGMAD, i)
            nfo=nint(distplt*stnfo)+nplt+1   
            nfo=max(nfo,1)
            nfo=min(nfo,2*nplt+1)
            nfc=nint(distplt*stnfc)+nplt+1
            nfc=max(nfc,1)
            nfc=min(nfc,2*nplt+1)
            ifoplt(nfo)=ifoplt(nfo)+1
            ifcplt(nfc)=ifcplt(nfc)+1
        end if
    end do
    distmax=max(maxval(ifoplt), maxval(ifcplt))

    WRITE (CMON,'(A,/,A,/,A,/,A,2f7.2,A,/,A,2f7.2,A,/,A,/,A,/,A)') &
    &  '^^PL PLOTDATA _DIST SCATTER ATTACH _VDIST KEY', &
    &  '^^PL XAXIS TITLE ''D/sigma(Do)''  ', &
    &  '^^PL NSERIES=2 LENGTH=100 ', &
    &  '^^PL YAXIS ZOOM ', 0.0, 100., &
    &  ' TITLE ''Frequency of Do (% of Dmax)'' ', &
    &  '^^PL YAXISRIGHT ZOOM ', 0.0, 100., &
    &  ' TITLE ''Frequency of Dsingle (% of Dmax)''  ', &
    &  '^^PL SERIES 1 SERIESNAME ''Dobs'' TYPE LINE', &
    &  '^^PL SERIES 2 SERIESNAME ''Dsingle''    TYPE LINE', &
    &  '^^PL USERIGHTAXIS'
    CALL XPRVDU (NCVDU, 8, 0)

!c
!c  in here, replace start (-nplt) by first non-empty bin, and stop
!c  at last non-empty bin.  May then have to scale x axis.
!c
    do i=1,2*nplt+1
        WRITE (CMON,'(A,4F11.3)') '^^PL DATA ', &
        &   float(i-nplt-1)/DISTPLT, 100.*float(ifoplt(i))/distmax, &
        &   float(i-nplt-1)/DISTPLT, 100.*float(ifcplt(i))/distmax
        CALL XPRVDU (NCVDU, 1, 0)
    enddo
    !C -- FINISH THE GRAPH DEFINITION
    WRITE (CMON,'(A,/,A)') '^^PL SHOW','^^CR'
    CALL XPRVDU (NCVDU, 2, 0)
end subroutine

end module


