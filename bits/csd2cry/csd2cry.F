      PROGRAM CSD2CRY
#if defined(_DIGITALF77_)
       use dflib
#endif
C       program csdtocry    Version 1.82    01 March 2002
C
C       original progrmamming by Bruce Foxman
C       e-mail foxman1@binah.cc.brandeis.edu
C
C        01.03.02: SJB fixed bug that caused the #REGROUP functionality to only
C      			be available if user is extracting all refcodes in a file
C       07.11.01: SJB added some more non-standard settings (orthorhombic)
C                 SJB fixed bug in matching spacegroups between data structure
C                       (it didn't get as far as reading the last spacegroup in the data list)
C       17.10.01: SJB fixed 'FDAT does not exist' bug
C                 added possible #REGROUP support
C       11.10.01: SJB added routine to generate LIST 29 via #COMPOSITION
C       08.02.01: SJB added patches for the common non-standard spagroup
C      		    settings found in the CSD
C       28.10.99: SJB fixed bug which causes spaces to be written in
C                 the middle of the filename under Windows 98
C                 SJB added code to allow input of a list of REFCODEs
C                 for extraction in the form of a CSD '.GCD' file,
C                 which is obtained by selecting 'SAVE-REFCODE-LIST' in
C                 Quest.
C
C       SJB: line 'use dflib' gives access to the GETARGS subroutine, which
C            is compiler specific to the MS Developer Suite
C
    1   format(/'Enter the name of the CSD FDAT file to be read, or',/,
     1  ' type HELP to see the program instructions: ',$)
    2   format(/,' Use of this program is very simple: ',//,
     1  ' (a) enter the name of a previously-obtained CSD FDAT file,',/,
C
C       SJB: following lines changed to reflect new options and improve
C            help.
C
     2  ' [this name can be entered at the command line in the form',/,
     2  ' CSD2CRY <FDATfilename>.',/,
     2  ' (b) choose whether particular refcodes or all (''ALL'') will',
     2  ' be extracted, or enter the name of a CSD .GCD file to be',
     2  ' used as a REFCODE list.',/
C
C       SJB modifications end.
C
     3  ' (c) the refcodes appear in the current directory as REFCODE',
     3  '.DAT files',/,
     4  '     ready for input to CRYSTALS.',//,
     5  '  Note : Spacegroup symbol generation is usually automatic.',/,
     6  '  Sometimes, you may be required to retype the symbol with ',
     6  'spaces.'//
     7  '  Send comments, errors, and sample problem files to Bruce ',
     7  'Foxman, by'/
     8  '  e-mail, to foxman1@binah.cc.brandeis.edu.')
    3   format(a)
C
C       SJB: modified the following two lines to indicate GCD option.
C
    4   format(/,' Enter names of REFCODE to be extracted (ALL for ',
     1         /,'all, or FILE to select GCD file input) :  ',$)
    5   format(/,' Additional REFCODE to be extracted (END if done) :  '
     1         ,$)
    6   format(A1,A8,2I1,I6,6X,11I3,22I1,I2)
    7   format(' *************************************************',//)
    8   format(a8)
    9   format(' ***** FOR INFORMATION ONLY ***** ' //
     1  ' No coordinates for Refcode: ',a12,2x,'!!!!!!!')
   11   format(a80)
   13   format(6I6,6I1,6I2,2I3,I3,a8,I3,I2,4X)
   14   format(' Extracting Refcode: ',2x,a8,2x,'from FDAT file')
   15   format('#SET PAUSE 2',/'#TITLE  ',A8,/,'#',/,'#',/,
     1  '#LIST 1',/,'REAL',6F10.5,/,'END')
   17   format(' The space group symbol for ',a8, ' is: ', a8, //,
     1  '  Please retype the symbol with appropriate spaces for ',
     2  'input ',//,'  to CRYSTALS, e.g., P b c a : ',$)
   19   format('# NOTE: This is NOT the spacegroup!  See below',
     1  ' for the real one.',/,'#SPACEGROUP',/,'SYMBOL ',A12,/,'END')
   21   format(A5,3I7,1X,A5,3I7,1X,A5,3I7)
   22   format(/,'Enter name of GCD-format file containing the list',/,
     1  'containing the REFCODE list: ', $)
   23   format('#LIST 5',/,'READ NATOM = ',I5)
   25   format('ATOM  ',a1,2X,4a1,2x,'X = ',3F10.6,/,'CONT  0.05')
   26   format('ATOM  ',2a1,1X,3a1,3x,'X = ',3F10.6,/,'CONT  0.05')
   27   format('END')
   28   format('#SET PAUSE 0',/'#USE LAST')
   29   format(/,' Refcode  ', a12, '  was not found; check input!')
   30   format('#REGROUP',/,'SEL GROUP=YES',/,'END')
   31   format('#DISP',/,'END')
   32   format(/,'Do you wish to regroup the atoms by fragment?',
     1        ' (Y or N) ',$)
c
c
      integer max
C      SJB added logical variable for testing whether input FDAT exists
      logical fex
      parameter (max=900)
        dimension icelld(6),iprec(6),icesd(6),celld(6),prec(6),
     1  atom(max),ix(max),iy(max),iz(max),x(max),y(max),z(max),
     2  ipriv(10),at(5,max),nstep(max),at1(28),at2(28),ntest(max),
     3  sgcsd(258),sgcry(258),refcode(100),irefc(100)
      character spg*8,spg2*12,atom*5,refcod*8,at,ipfile*12,ofile*4,
     1  filenm*12,at1,at2,sgcry*10,sgcsd*10,refcode*8,retstring*8,
     2  gcdname*12, regroup*1
C      SJB added integer variable 'rtest' as a switch for regrouping
      integer i, xyz, rtest
C&DOS      character cmnam*128
C&DOS      character JPFILE*128
        equivalence (atom,at)
c
        data ofile/'.dat'/
        data at1/'A','B','C','D','E','F','G','H','I','J','K','L','M',
     1  'N','O','P','Q','R','S','T','U','V','W','X','Y','Z','*',''''/
        data at2/'1','2','3','4','5','6','7','8','9','1','2','3','4',
     1  '5','6','7','8','9','1','2','3','4','5','6','7','8','9','9'/
        data (sgcsd(i),i=1,30)/'P1        ','P-1       ','P2        ',
     1             'P21       ','C2        ','A2        ',
     2             'I2        ','Pm        ','Pc        ',
     3             'Pn        ','Pa        ','Cm        ',
     4             'Am        ','Im        ','Cc        ',
     5             'An        ','Ia        ','P2/m      ',
     6             'P21/m     ','C2/m      ','A2/m      ',
     7             'I2/m      ','P2/c      ','P2/n      ',
     8             'P2/a      ','P21/c     ','P21/n     ',
     9             'P21/a     ','C2/c      ','A2/n      '/
        data (sgcsd(i),i=31,60)/'I2/a      ','P222      ','P2221     ',
     1             'P21212    ','P212121   ','C2221     ',
     2             'C222      ','F222      ','I222      ',
     3             'I212121   ','Pmm2      ','Pmc21     ',
     4             'Pcc2      ','Pma2      ','Pca21     ',
     5             'Pnc2      ','Pmn21     ','Pba2      ',
     6             'Pna21     ','Pnn2      ','Cmm2      ',
     7             'Cmc21     ','Ccc2      ','Amm2      ',
     8             'Abm2      ','Ama2      ','Aba2      ',
     9             'Fmm2      ','Fdd2      ','Imm2      '/
        data (sgcsd(i),i=61,90)/'Iba2      ','Ima2      ','Pmmm      ',
     1             'Pnnn      ','Pccm      ','Pban      ',
     2             'Pmma      ','Pnna      ','Pmna      ',
     3             'Pcca      ','Pbam      ','Pccn      ',
     4             'Pbcm      ','Pnnm      ','Pmmn      ',
     5             'Pbcn      ','Pbca      ','Pnma      ',
     6             'Cmcm      ','Cmca      ','Cmmm      ',
     7             'Cccm      ','Cmma      ','Ccca      ',
     8             'Fmmm      ','Fddd      ','Immm      ',
     9             'Ibam      ','Ibca      ','Imma      '/
        data (sgcsd(i),i=91,120)/'P4        ','P41       ','P42       ',
     1             'P43       ','I4        ','I41       ',
     2             'P-4       ','I-4       ','P4/m      ',
     3             'P42/m     ','P4/n      ','P42/n     ',
     4             'I4/m      ','I41/a     ','P422      ',
     5             'P4212     ','P4122     ','P41212    ',
     6             'P4222     ','P42212    ','P4322     ',
     7             'P43212    ','I422      ','I4122     ',
     8             'P4mm      ','P4bm      ','P42cm     ',
     9             'P42nm     ','P4cc      ','P4nc      '/
        data (sgcsd(i),i=121,150)/'P42mc     ','P42bc     ','I4mm      '
     1            ,'I4cm      ','I41md     ','I41cd     ',
     2             'P-42m     ','P-42c     ','P-421m    ',
     3             'P-421c    ','P-4m2     ','P-4c2     ',
     4             'P-4b2     ','P-4n2     ','I-4m2     ',
     5             'I-4c2     ','I-42m     ','I-42d     ',
     6             'P4/mmm    ','P4/mcc    ','P4/nbm    ',
     7             'P4/nnc    ','P4/mbm    ','P4/mnc    ',
     8             'P4/nmm    ','P4/ncc    ','P42/mmc   ',
     9             'P42/mcm   ','P42/nbc   ','P42/nnm   '/
        data (sgcsd(i),i=151,180)/'P42/mbc   ','P42/mnm   ','P42/nmc   '
     1            ,'P42/ncm   ','I4/mmm    ','I4/mcm    ',
     2             'I41/amd   ','I41/acd   ','P3        ',
     3             'P31       ','P32       ','R3        ',
     4             'P-3       ','R-3       ','P312      ',
     5             'P321      ','P3112     ','P3121     ',
     6             'P3212     ','3221      ','R32       ',
     7             'P3m1      ','P31m      ','P3c1      ',
     8             'P31c      ','R3m       ','R3c       ',
     9             'P-31m     ','P-31c     ','P-3m1     '/
        data (sgcsd(i),i=181,210)/'P-3c1     ','R-3m      ','R-3c      '
     1            ,'P6        ','P61       ','P65       ',
     2             'P62       ','P64       ','P63       ',
     3             'P-6       ','P6/m      ','P63/m     ',
     4             'P622      ','P6122     ','P6522     ',
     5             'P6222     ','P6422     ','P6322     ',
     6             'P6mm      ','P6cc      ','P63cm     ',
     7             'P63mc     ','P-6m2     ','P-6c2     ',
     8             'P-62m     ','P-62c     ','P6/mmm    ',
     9             'P6/mcc    ','P63/mcm   ','P63/mmc   '/
        data (sgcsd(i),i=211,240)/'P23       ','F23       ','I23       '
     1            ,'P213      ','I213      ','Pm-3      ',
     2             'Pn-3      ','Fm-3      ','Fd-3      ',
     3             'Im-3      ','Pa-3      ','Ia-3      ',
     4             'P432      ','P4232     ','F432      ',
     5             'F4132     ','I432      ','P4332     ',
     6             'P4132     ','I4132     ','P-43m     ',
     7             'F-43m     ','I-43m     ','P-43n     ',
     8             'F-43c     ','I-43d     ','Pm-3m     ',
     9             'Pn-3n     ','Pm-3n     ','Pn-3m     '/
        data (sgcsd(i),i=241,258)/'Fm-3m     ','Fm-3c     ','Fd-3m     '
     1            ,'Fd-3c     ','Im-3m     ','Ia-3d     '
C      Nonstandard settings common in the CSD
     2            ,'Pcab      ','P1121/b   ','P21cn     '
     3              ,'P22121    ','P1121/n   ','P1121/a   '
     4            ,'Pbc21     ','Pb21a     ','P21ab     '
     5            ,'Pn21a     ','P21cn     ','Pbn21     '/
        data (sgcry(i),i=1,30)/'P 1       ','P -1      ','P 1 2 1   ',
     1             'P 1 21 1  ','C 1 2 1   ','A 1 2 1   ',
     2             'I 1 2 1   ','P 1 m 1   ','P 1 c 1   ',
     3             'P 1 n 1   ','P 1 a 1   ','C 1 m 1   ',
     4             'A 1 m 1   ','I 1 m 1   ','C 1 c 1   ',
     5             'A 1 n 1   ','I 1 a 1   ','P 1 2/m 1 ',
     6             'P 1 21/m 1','C 1 2/m 1 ','A 1 2/m 1 ',
     7             'I 1 2/m 1 ','P 1 2/c 1 ','P 1 2/n 1 ',
     8             'P 1 2/a 1 ','P 1 21/c 1','P 1 21/n 1',
     9             'P 1 21/a 1','C 1 2/c 1 ','A 1 2/n 1 '/
        data (sgcry(i),i=31,60)/'I 1 2/a 1 ','P 2 2 2   ','P 2 2 21  ',
     1             'P 21 21 2 ','P 21 21 21','C 2 2 21  ',
     2             'C 2 2 2   ','F 2 2 2   ','I 2 2 2   ',
     3             'I 21 21 21','P m m 2   ','P m c 21  ',
     4             'P c c 2   ','P m a 2   ','P c a 21  ',
     5             'P n c 2   ','P m n 21  ','P b a 2   ',
     6             'P n a 21  ','P n n 2   ','C m m 2   ',
     7             'C m c 21  ','C c c 2   ','A m m 2   ',
     8             'A b m 2   ','A m a 2   ','A b a 2   ',
     9             'F m m 2   ','F d d 2   ','I m m 2   '/
        data (sgcry(i),i=61,90)/'I b a 2   ','I m a 2   ','P m m m   ',
     1             'P n n n   ','P c c m   ','P b a n   ',
     2             'P m m a   ','P n n a   ','P m n a   ',
     3             'P c c a   ','P b a m   ','P c c n   ',
     4             'P b c m   ','P n n m   ','P m m n   ',
     5             'P b c n   ','P b c a   ','P m m a   ',
     6             'C m c m   ','C m c a   ','C m m m   ',
     7             'C c c m   ','C m m a   ','C c c a   ',
     8             'F m m m   ','F d d d   ','I m m m   ',
     9             'I b a m   ','I b c a   ','I m m a   '/
        data (sgcry(i),i=91,120)/'P 4       ','P 41      ','P 42      ',
     1             'P 43      ','I 4       ','I 41      ',
     2             'P -4      ','I -4      ','P 4/m     ',
     3             'P 42/m    ','P 4/n     ','P 42/n    ',
     4             'I 4/m     ','I 41/a    ','P 4 2 2   ',
     5             'P 4 21 2  ','P 41 2 2  ','P 41 21 2 ',
     6             'P 42 2 2  ','P 42 21 2 ','P 43 2 2  ',
     7             'P 43 21 2 ','I 4 2 2   ','I 41 2 2  ',
     8             'P 4 m m   ','P 4 b m   ','P 42 c m  ',
     9             'P 42 n m  ','P 4 c c   ','P 4 n c   '/
        data (sgcry(i),i=121,150)/'P 42 m c  ','P 42 b c  ','I 4 m m   '
     1            ,'I 4 c m   ','I 41 m d  ','I 41 c d  ',
     2             'P -4 2 m  ','P -4 2 c  ','P -4 21 m ',
     3             'P -4 21 c ','P -4 m 2  ','P -4 c 2  ',
     4             'P -4 b 2  ','P -4 n 2  ','I -4 m 2  ',
     5             'I -4 c 2  ','I -4 2 m  ','I -4 2 d  ',
     6             'P 4/m m m ','P 4/m c c ','P 4/n b m ',
     7             'P 4/n n c ','P 4/m b m ','P 4/m n c ',
     8             'P 4/n m m ','P 4/n c c ','P 42/m m c',
     9             'P 42/m c m','P 42/n b c','P 42/n n m'/
        data (sgcry(i),i=151,180)/'P 42/m b c','P 42/m n m','P 42/n m c'
     1            ,'P 42/n c m','I 4/m m m ','I 4/m c m ',
     2             'I 41/a m d','I 41/a c d','P 3       ',
     3             'P 31      ','P 32      ','R 3       ',
     4             'P -3      ','R -3      ','P 3 1 2   ',
     5             'P 3 2 1   ','P 31 1 2  ','P 31 2 1  ',
     6             'P 32 1 2  ','P 32 2 1  ','R 3 2     ',
     7             'P 3 m 1   ','P 3 1 m   ','P 3 c 1   ',
     8             'P 3 1 c   ','R 3 m     ','R 3 c     ',
     9             'P -3 1 m  ','P -3 1 c  ','P -3 m 1  '/
        data (sgcry(i),i=181,210)/'P -3 c 1  ','R -3 m    ','R -3 c    '
     1            ,'P 6       ','P 61      ','P 65      ',
     2             'P 62      ','P 64      ','P 63      ',
     3             'P -6      ','P 6/m     ','P 63/m    ',
     4             'P 6 2 2   ','P 61 2 2  ','P 65 2 2  ',
     5             'P 62 2 2  ','P 64 2 2  ','P 63 2 2  ',
     6             'P 6 m m   ','P 6 c c   ','P 63 c m  ',
     7             'P 63 m c  ','P -6 m 2  ','P -6 c 2  ',
     8             'P -6 2 m  ','P-6 2 c   ','P 6/m m m ',
     9             'P 6/m c c ','P 63/m c m','P 63/m m c'/
        data (sgcry(i),i=211,240)/'P 2 3     ','F 2 3     ','I 2 3     '
     1            ,'P 21 3    ','I 21 3    ','P m -3    ',
     2             'P n -3    ','F m -3    ','F d -3    ',
     3             'I m -3    ','P a -3    ','I a -3    ',
     4             'P 4 3 2   ','P 42 3 2  ','F 4 3 2   ',
     5             'F 41 3 2  ','I 4 3 2   ','P 43 3 2  ',
     6             'P 41 3 2  ','I 41 3 2  ','P -4 3 m  ',
     7             'F -4 3 m  ','I -4 3 m  ','P -4 3 n  ',
     8             'F -4 3 c  ','I -4 3 d  ','P m -3 m  ',
     9             'P n -3 n  ','P m -3 n  ','P n -3 m  '/
        data (sgcry(i),i=241,258)/'F m -3 m  ','F m -3 c  ','F d -3 m  '
     1            ,'F d -3 c  ','I m -3 m  ','I a -3 d  '
C      Non-standard settings common in the CSD
     2      	    ,'P c a b   ','P 1 1 21/b','P 21 c n  '
     3                   ,'P 2 21 21 ','P 1 1 21/n','P 1 1 21/a'
     4            ,'P b c 21  ','P b 21 a  ','P 21 a b  '
     5            ,'P n 21 a  ','P 21 c n  ','P b n 21  '/
 
#if defined(CRY_GNU)
        call no_stdout_buffer_()
#endif
c
c       let's read in the file name and clear some arrays
c
        do 70 i=1,100
   70   irefc(i)=0
   71     j1=2
      ipfile='            '
c       
C&DOS      ipfile=CMNAM()      
C&DOS      write(*,*) ipfile(1:60)
C&DOS      if ( ipfile(1:3).ne.'   ')then
C&DOS            CALL XCRAS( IPFILE,  LENFIL)
C&DOS            open(8,file=Ipfile,status='old',err=71)
C&DOS            refcode(1)='ALL'
C&DOS            goto 99      	! Modified SJB 010302
C&DOS      end if
C&DOS      read(*,3) ipfile
C&DOS      if (ipfile.eq.'HELP'.or.ipfile.eq.'help') then
C&DOS             write(*,2)
C&DOS             go to 71
C&DOS      else
C&DOS             open(8,file=ipfile,status='old')
C&DOS      endif
C&XXX      read(*,3) ipfile
C&XXX      write(*,*) ipfile(1:60)
C&XXX            if (ipfile.eq.'HELP'.or.ipfile.eq.'help') then
C&XXX                  write(*,2)
C&XXX                  go to 71
C&XXX            else
C&XXX                  CALL XCRAS( IPFILE, LENFIL)
C&XXX                  open(8,file=ipfile,status='old',err=71)
C&XXX            endif
c       SJB: This is compiler specific code to get the command-line options
c            entered to look for a file specification to use for input; the
c            original code was compiler specific to ftn77.
c
       call getarg(1,ipfile)
c
c       SJB: Compiler specific code ends
c
   72 if (ipfile.eq.'            ') then
       write(*,1) 
       read(*,'(a)') ipfile
      endif
      if (ipfile.eq.'HELP'.or.ipfile.eq.'help') then
             write(*,2)
             ipfile='            '
             go to 72
      else
C      SJB Added check to make sure input FDAT exists, and STOP if not.
      	   inquire(file=ipfile,exist=fex)
      	   if (.not.fex) then
      	    write(*,'(a)') ' '
               write(*,'(a)') '** FATAL: Input FDAT file does not exist'
      		stop
             endif
             open(8,file=ipfile,status='old')
      endif
 
C #DOS      read(*,3) ipfile
C #DOS            if (ipfile.eq.'HELP'.or.ipfile.eq.'help') then
C #DOS                  write(*,2)
C #DOS                  go to 71
C #DOS            else
C #DOS                  open(8,file=ipfile,status='old')
C #DOS            endif
c
c       read the first refcode or 'all' to extract all the files
c
        write(*,4)
        read(*,8) refcode(1)
c
c
        call upcase (refcode(1),retstring)
        jk=1
        refcode(1)=retstring
               if (refcode(1).eq.'ALL') then
                       go to 99      	! Modified SJB 010302
C
C       SJB: added the code to select the GCD file input
C            option, and then read in the data from the
C            GCD file selected.
C
                elseif (refcode(1).eq.'FILE') then
   73                 gcdname='            '
         			  write(*,22)
                    read(*,'(a)') gcdname
                    if (gcdname(1:1).eq.' ') then
      			   goto 73
                    end if
                    open(unit=9,file=gcdname)
      			  xyz=1
   74                    continue
                     read(9,'(a8)',END=75) refcode(xyz)
      			   call upcase (refcode(xyz),retstring)
                     refcode(xyz)=retstring
      			   xyz=xyz+1
      			  goto 74
   75      			  continue
                    close(unit=9)
      			  goto 99		! Modified SJB 010302
                else
c
c       get the rest of the refcodes to be extracted
c
   77                   jk=jk+1
                        write(*,5)
                        read(*,8) refcode(jk)
                        call upcase (refcode(jk),retstring)
                        refcode(jk)=retstring
                              if (refcode(jk).eq.'END') then
                                        jlast=jk-1
                                        go to 99      ! Modified SJB 010302
                                else
                                        go to 77
                                endif
                endif
c
c       now read each entry in the csd fdat file
c
C        SJB: Checking for regroup - THIS DOES NOT AFFECT THE ATOM
C        ORDER IN THE OUTPUT OF CSD2CRY!
C        This bit of code has been moved so it gets run irrespective
C        of how the refcodes were entered.
   99        write(*,32)
        read(*,'(a)') regroup
        rtest=0
        if ((regroup.eq.'Y').or.(regroup.eq.'y')) rtest=1
  100   read(8,6,end=300)hash,refcod,isys,icat,iadat,ncards,nrfac,nrem,
     1  ndis,nerr,nopr,nrad,nat,nsat,nbnd,ncon,icell,intf,iatfor,
     2  icent,ierr,irpa,itd,ipd,nu,icbl,ias,ipol,ipriv,iyear
c
c       variable jtest (=1) sets switch for refcode extraction
c
        jtest=0
        if(refcode(1).eq.'ALL') jtest=1
           if (refcode(1).ne.'ALL') then
                do 102 j1=1,100
                if(refcode(j1).eq.refcod) irefc(j1)=1
  102           if(refcode(j1).eq.refcod) jtest=1
           else
                go to 105
           endif
  105   ntot=nrfac+nrem+ndis+nerr
        nop1=nopr
        nt=1
        do 110 i=1,10
        if (ntot.gt.80) nt=nt+1
        if (nop1.gt.5) nt=nt+1
        nop1=nop1-5
        ntot=ntot-80
        if (ntot.le.0.and.nop1.le.0) go to 120
  110   continue
  120   write(6,7)
        if(ncards.gt.nt+3) go to 140
        write(6,9) refcod
        do 130 i=2,ncards
        read(8,11)
  130   continue
        go to 100
  140   last=nat+nsat
        do 145 i=1,last
  145   ntest(i)=0
        read(8,13)icelld,iprec,icesd,idensm,idensx,nspg,spg,nz,itol
        if(jtest.gt.0) write(*,14) refcod
C
C       SJB: added code to strip spaces out of filename to use in
C            the OPEN statement.        
C        
        i=index(refcod,' ')
        if(i.eq.0) then
         i=8
c        elseif(i.eq.1) then stop 'Empty_refcode_field_caused_file_error'
        else
         i=i-1
        endif
        filenm=refcod(1:i)//ofile
        if (jtest.gt.0) open(10,file=filenm,status='unknown')	
C
        do 150 I=1,6
        prec(i)=iprec(i)
        celld(i)=icelld(i)
        celld(i)=celld(i)/10**prec(i)
  150   continue
        if (jtest.gt.0) write(10,15) refcod,celld
        jj=1
  151     if(spg.eq.sgcsd(jj)) then
                spg2 = sgcry(jj)
          else
                jj=jj+1
                if(jj.le.258) go to 151
                write (6,17) refcod,spg
                read (*,3) spg2
          endif
        if(jtest.gt.0) write(10,19) 'P 1         '
        do 160 i=1,2+nt
  160   read (8,11)
        nc=nt+5
        do 170 i=1,last,3
        ip2=i+2
        if(ip2.gt.last) ip2=last
        read (8,21) (atom(j),ix(j),iy(j),iz(j),j=i,ip2)
        nc=nc+1
        if(ip2.eq.last) go to 171
  170   continue
  171   do 175 i=1,last
        do 175 j=i+1,last
  175   if (atom(i).eq.atom(j)) ntest(j)=ntest(j)+1
        do 200 I=1,last
        nstep(i)=1
        if(at(2,i).ge.'A') nstep(i)=2
        do 190 jj=3,5
        do 190 kk=1,28
  190   if(at(jj,i).eq.at1(kk)) at(jj,i) = at2(kk)
        x(I)=ix(I)*.00001
        y(I)=iy(I)*.00001
        z(I)=iz(I)*.00001
  200   continue
        if(jtest.gt.0) write(10,23) last
        do 210 i=1,last
        assign 25 to ifmt
        if(nstep(i).eq.2) assign 26 to ifmt
          if(ntest(i).ge.1) then
                if(nstep(i).eq.1) then
                        at(4,i) = at(3,i)
                        at(3,i) = at(2,i)
                        at(2,i) = at2(ntest(i))
                else
                        at(5,i) = at(4,i)
                        at(4,i) = at(3,i)
                        at(3,i) = at2(ntest(i))
                endif
          endif
        if(jtest.gt.0) write(10,ifmt) (at(j,i),j=1,nstep(i)),
     1  (at(k,i),k=nstep(i)+1,5),x(i),y(i),z(i)
  210   continue
        if(jtest.gt.0) write(10,27)
        do 220 i=nc,ncards
  220   read (8,11)
C        SJB: calling the list 29 routine
C      	NOTE!  This subroutine DESTROYS the atom list!
        if(jtest.gt.0) call elem(atom, last, 10, spg2)
c       SJB: added a close statement to close the output DAT file on
c            unit 10. (Just tidying things up)
        if(jtest.gt.0) then
         if (rtest.ne.0) write(10,30)
C        SJB: added lines to force update the model window
         write(10,31)
         write(10,28)
        endif
        if(jtest.gt.0) close(10)
        go to 100
  300   if (refcode(1).ne.'ALL') then
                do 310 i=1,jk-1
  310           if(irefc(i).eq.0) write(*,29) refcode(i)
        endif
        stop
9510    write(*,'(a)') '** Error opening FDAT file'
        stop
        end
C
C       SJB: added this subroutine to replace a compiler specific
C            which is not available in MSDS
C
C CODE FOR UPCASE
      SUBROUTINE upcase ( CLOWER , CUPPER )
C
C -- CONVERT STRING TO UPPERCASE
C
C      CLOWER      SOURCE STRING TO BE CONVERTED
C      CUPPER      RESULTANT STRING
C
C
      CHARACTER*(*) CLOWER , CUPPER
C
      CHARACTER*26 CALPHA , CEQUIV
C
      DATA CALPHA / 'abcdefghijklmnopqrstuvwxyz' /
      DATA CEQUIV / 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' /
C
C
C -- MOVE WHOLE STRING.
C-ASSIGNING LOWER TO UPPER IS FORMALLY INVALID
C      CUPPER = CLOWER
      READ(CLOWER,'(A)') CUPPER
C
      LENGTH = MIN0 ( LEN ( CLOWER ) , LEN ( CUPPER ) )
C
C -- SEARCH FOR LOWERCASE CHARACTERS AND CONVERT TO UPPERCASE
      DO 2000 I = 1 , LENGTH
        IPOS = INDEX ( CALPHA , CLOWER(I:I) )
        IF ( IPOS .GT. 0 ) CUPPER(I:I) = CEQUIV(IPOS:IPOS)
2000  CONTINUE
C
C
      RETURN
      END
C
C      CODE FOR ELEM   Simon Borwick, 11 October 2001
      subroutine elem(elatom, totc, outunit, elspac)
C
C -- ROUTINE TO WRITE OUT LIST 29
C
      integer max
      parameter (max=900)
      integer elemc, atomc, totc, outunit, elnum, elemi, elemj, elemk
      character elatom*5, ellast*2, numbers*10, elelem*2, elspac*12
      dimension elatom(max), elelem(50), elnum(50)
      character*2 elatomb(totc)
C     ELATOM is the atom list from the FDAT
C     OUTUNIT is the fortran unit attached to the output file
C      ELEMC counts the number of element cards to be written
C      TOTC is the number of atoms in the AU
C      ATOMC counts the number of atoms of the current element
C      ELELEM and ELNUM store the element card details
C      ELSPAC is the spacegroup identifier
C      ELEMI, ELEMJ and ELEMK are counter variables
9001  format('#LIST 29')
9002  format('READ NELEMENT=',I3)
9003  format('ELEMENT ',A4,' NUM= ',I3)
9004  format('END')
9005  format('# This is the real spacegroup here:',/,
     1   '#SPACEGROUP',/,'SYMBOL ',A12,/,'END')
C      NOTE: This kind of real-time-dimensioned format statement is DVF specific and is nonstandard
#if defined(_DIGITALF77_)
9007  format('CONTINUE ',<elemj>(A2,' ',I3,' '))
9008  format('#COMPOSITION',/,'CONTENT  ',<elemj>(A2,' ',I3,' '))
#else
9007  format('CONTINUE ',99(A2,' ',I3,' '))
9008  format('#COMPOSITION',/,'CONTENT  ',99(A2,' ',I3,' '))
#endif
9009  format('SCATTERING CRYSDIR:script/scatt.dat',/,
     1  'PROPERTIES CRYSDIR:script/propwin.dat',/,'END')
C      Convert to all upper case and lose the numbers to clarify the collating sequence
      numbers='0123456789'
      do elemi=1,totc
       if (elatom(elemi).ne.'     ') then
        elatomb(elemi)=elatom(elemi)(1:2)
        if (index(numbers,elatomb(elemi)(2:2)).ne.0)
     1        elatomb(elemi)(2:2)=' '
        call upcase(elatomb(elemi),ellast)
        elatomb(elemi)=ellast
       endif
      end do
C      Sort the atoms into descending alphabetic order
C      The standard F77 collating sequence causes blank entries to collect @ the top
      call shell(totc, elatomb)
C      Count the number of different elements present
      elemi=1	
      ellast='  '
      elemc=0
      do while (elemi.le.totc)
       if (elatomb(elemi).ne.ellast) elemc=elemc+1
       ellast=elatomb(elemi)
       elemi=elemi+1
      end do
C      Check elelem & elnum bounds
      if ((elemc.eq.0).or.(elemc.gt.50)) goto 9500
C      write(outunit,9001)
C      write(outunit,9002) elemc
C      Count the number of different atoms for each element
      elemi=1
      elemj=1
      ellast=elatomb(1)
      atomc=0
      do while (elemi.le.totc)
       if ((elatomb(elemi).eq.ellast)) then 
        atomc=atomc+1
       else
C        write(outunit, 9003) ellast, atomc
        elelem(elemj)=ellast
        elnum(elemj)=atomc
        elemj=elemj+1
        atomc=1
       endif
       ellast=elatomb(elemi)
       elemi=elemi+1
      end do
C      Handle the element that was last in the atom list
      elelem(elemj)=elatomb(totc)
      elnum(elemj)=atomc
      elemi=0
C      Writing to disk now...
C      ELEMJ serves here to control the FORMAT statement - see 9007 & 9008
C      	This is compiler specific!
      if (elemc.le.9) then 
C      All of the elements will fit on one line
       elemj=elemc
       write(outunit, 9008) (elelem(elemi),elnum(elemi),elemi=1,elemc)
      else
C      They won't, so write the first line
       elemj=9
       write(outunit, 9008) (elelem(elemk),elnum(elemk),elemk=1,elemj)
C      If we require some FULL continue lines, write them
       if (elemc.ge.18) then
        do elemk=1,(elemc/9)-1
         write(outunit, 9007)
     *    (elelem((elemk*9)+elemi),elnum((elemk*9)+elemi),elemi=1,9)  
        enddo
       endif
C      Now an incomplete continue line if necessary
       elemj=mod(elemc,9)
       if (elemj.ne.0) then
        write(outunit,9007) 
     *   (elelem(((elemc/9)*9)+elemk),elnum(((elemc/9)*9)+elemk),
     *   elemk=1,elemj)
       endif
      endif
C      Done
      write(outunit, 9009)
      write(outunit, 9005) elspac
      RETURN
C      Code to handle a failure in the LIST29 routine gracefully
C      Write the spacegroup out and return
9500  write(outunit, 9005) elspac
      write(6,'(a)') '** LIST29 output failed **'
      RETURN
      END
C
c      Modified shell sort from Numerical Recipes (chap 8).  The collating sequence
c      should be OK for this.
      SUBROUTINE shell(n,a)
      INTEGER n
      character*2 a(n)
      INTEGER i,j,inc
      CHARACTER*2 v
      inc=1
1     inc=3*inc+1
      if(inc.le.n)goto 1
2     continue
        inc=inc/3
        do 11 i=inc+1,n
          v=a(i)
          j=i
3         if(a(j-inc).gt.v)then
            a(j)=a(j-inc)
            j=j-inc
            if(j.le.inc)goto 4
          goto 3
          endif
4         a(j)=v
11      continue
      if(inc.gt.1)goto 2
      return
      END

