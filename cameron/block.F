CRYSTALS CODE FOR BLOCK.FOR
CODE FOR ZBLOCK
      BLOCK DATA ZBLOCK
C THE VARAIBLES INCLUDED IN THE COMMON BLOCKS ARE DESCRIBED BELOW.
C
CC COMMAND
CC CGRAPH     character array for ascii characters used in drawing
CC IBEG       start of current word in command line
CC IC         number of character arguments supplied for current command
CC ICABAN     position in input line before which all characters have been already executed.
CC ICC        number of character arguments supplied
CC ICHARS      number of character arguments allowed
CC ICLOG      next free position in log file character string
CC ICN        number of integer arguments supplied
CC ICR        number of real arguments supplied
CC ICTYPE     type of character argument accepted
CC IEND       end of current word in command line
CC IFOBEY     unit number for obey file - -1 if not in use.
CC IGOUT      unit number for graphics driver file (TEK)
CC IHEAD      header command input status
CC IINT       number of integer arguments allowed
CC ILINE      next free position for reading into LINE
CC IMENCN     current control flag (menu vs keyboard)
CC IN         number of integer arguments supplied for current command
CC INCOM      command number
CC IPREV      number specifying the previous commands nature
CC IPROC      process status for the command arrays
CC IR         number of real arguments supplied for current command
CC IRL        number of real arguments allowed
CC ISTORE     command info storage flag
CC IVNUM      number of last view matrix stored.
C
CD DATACO
CD ICATOM     start of atom info in CSTORE
CD ICELLC     start of dummy cell corner atoms in RSTORE
CD ICELM      start of element info in CSTORE
CD ICLAST     next free space in CSTORE
CD ICLST5     number of character lines stored on list5 input.
CD ICOM       start of command info in RSTORE and CSTORE
CD ICONBG     beginning of connectivity information
CD ICONED     end of connectivity information
CD ICRYST     start of crystal info in RSTORE
CD ICTXT      start of text storage numbers in RSTORE
CD IELROT     start of ellipse info in RSTORE
CD IFINIT     end of original atom list
CD IFVIEW     end of atom list for current view
CD IGPCK      pack/enclosure group on/off flag
CD IGRP       start of group name storage in CSTORE
CD IKEY       start of colour key storage in RSTORE
CD INATOM     used as an atom counting number in various operations
CD INTXT      number of pieces of text stored in CSTORE
CD IPACK      current pack generation number
CD IRATOM     start of atom info in RSTORE
CD IRELM      start of element info in RSTORE
CD IREND      last occupied space down from the end of RSTORE
CD IRLAST     next free space in RSTORE
CD ISINIT     start of original atom list
CD ISVIEW     start of atom list for current view in RSTORE
CD ISYMED     end of symmetry info down from end of RSTORE
CD ITEXT      start of general text storage in CSTORE
CD ITNUMB     number of the currently active general text
CD NGRP       number of group names stored
CD NSYMM      number of symmetry operators stored
C
CF FLAGSS
CF DBDMAX     maximum bond distance (used in label calculations)
CF IAXIS      axis number for view along axis
CF IBACK      background colour
CF IBNDCL     default bond colour
CF ICAMER     flag that specifies CAMERON calling mode.
CF ICELL      cell include/exclude flag
CF ICLDEF     default colour number
CF ICOLL      previous collect flag
CF ICPOST      flag for colour postscript
CF ICURS      cursor rotation on/off
CF IDOKEY     atom colour key on/off
CF IEDIT      flag the specifies the current editing mode.
CF IELTYP     ellipse type
CF IENCAP     flag for encapsulated postscript
CF IENCL      number of enclosure centre atom.
CF IEXFLG     include/exclude flag
CF IFILL      ball fill/unfill
CF IFORE      foreground colour
CF IFRAME     frame/noframe flag
CF ILABCL     default label colour
CF ILABFG     labelling on (=1 during session, =-1 in archived views)/off (=0)
CF ILSEC      secondary bonds labelling search on/off
CF ILSIZE     label size
CF IMAXIM     picture maximise on/off
CF IMTFLG     set if orthogonalisation matrix has been included in MAT1
CF INLINE     line count for the text output
CF IOVER      number of overlapping atoms
CF IPCOLL     pack collect type flag
CF IPLAB      pack labelling type
CF IPPCK      type of volume for pack/enclosure
CF ISCRN      screen type number
CF ISQR       size of atom colour key squares
CF ISTREO     Stereo flag (0 =mono, 1 = stereo)
CF ITCOL      colour type (scheme) currently being used.
CF ITYPCK     type of limit condition for pack/enclosure
CF IVCHAN     flag set when there is a change in the current view matrix.
CF NKEY       number of elements in key
CF RNUISO     reset value for zero/negative temperature factors
CF RTAPER     bond tapering factor
CF RTHICK     bond thickness
CF STRANG     stereo angle
CF VERS       CAMERON version number
C
CG GRAPHIC
CG IBUFF      used in screen capture routines for menus
CG ICOLS      colour numbers for drawing
CG IDEVCL     device colour look up table
CG IFONT      font size for labels etc (Changed from IFSIZE by DJW)
CG IGREYC     colour numbers for grey scale
CG IHAND      hand of output device
CG IPAGE      number of text lines per output page
CG IPOST      postscript header data flag
CG IPSTCL     colour numbers for colour postscript
CG ISLCNT     scale calculations on/off
CG IVGACL     colour numbers for VGA screen
CG NCAW       output channel 2
CG NCAWU      output channel 1
CG PMAXX      Maximum x dimension of image
CG PMAXY      Maximum y dimension of image
CG RELSCL     ellipse scaling number
CG RES        resolution of page (postscript)
CG SCALE      current drawing scale
CG SCLFIX     fixed drawing scale
CG SCLLIM     scale limit for drawing full bonds
CG XCEN       centre of current device, (x)
CG XCP        centre of picture in angstroms (x)
CG XOFF       offset in X direction
CG YCEN       centre of current device, (y)
CG YCP        centre of picture in angstroms (y)
CG YOFF       offset in Y direction
C
CH CHARAC
CH CBUFF      array for keys entered during a long operation
CH CHELP      holds help text
CH CLINE      character string for write string transfer
CH CMENUS     storage array for the menu generated commands
CH CSTORE     main character storage array
CH CSUB       holds valid subcommand names during help
CH CTCOMD     storage array for general text arguments
CH LINE       array containing command input lines (uppercase)
CH LLINE      array containing initial version of input lines
C
CL CALCUL
CL AMSYMM     symmetry operator for current ADD/MOVE
CL AMTRAN     translational operator for current ADD/MOVE
CL ANGBEG     lower limit for angle calculations
CL ANGEND     upper limit for angle calculations
CL CENTR      molecules centroid
CL D000       perpendicular spacing between cell edges in angstroms
CL DISBEG     lower limit for distance calculations
CL DISEND     upper limit for distance calculations
CL IBDORD     initial, unsorted bond info for atoms
CL IORD       sorted bond info
CL ISPECL     special position calculation flag.
CL ISSPRT     print flag for symmetry code
CL MAT1       current view matrix
CL MAT2       previous view matrix
CL NDIST1     number of atoms included in distance/angle FROM
CL NDIST2     number of atoms included in distance/angle TO
CL PCMAX      upper limit for molecule box
CL PCMIN      lower limit for molecule box
CL PI         pi
CL PKCNA      pack/enclosure centre in angstroms
CL PKCNF      pack/enclosure centre in fractions
CL PKMAX      upper limit for pack/enclosure volume
CL PKMIN      lower limit for pack/enclosure volume
CL ROT        current rotation matrix
CL RSTOL      tolerance for special positions calculation
CL XC         centre of molecule in angstroms (x)
CL XCOS       coses of all integral angles
CL XSIN       sins of all integral angles
CL YC         centre of molecule in angstroms (y)
CL ZC         centre of molecule in angstroms (z)
C
CM MCONTR
CM IMOUSE     flag set to control mouse usage
CM NMOUSE     line in command line array used to hold mouse input atoms
C
CN MENUSS
CN ICBUFF     flag showing if keys have been stored in a buffer
CN ICHEAD     start of menu storage in CSTORE
CN IHMAX      max number of sub menu items
CN IHNUM      number of items in top menu bar
CN IMCHAR     start of storage for header commands in the init sub menus
CN IMENAR     top menubar arrow flag
CN IMENU      contains storage positions etc for the menus
CN IMENVT     flag for current menu level
CN IMENWD     width of the vertical menus
CN IMENX      x coordinates of menu boxes
CN IMENY      y coordinates of menu boxes
CN IMNTOP     position in top menu bar
CN IMOLD      traceback of previous menu usage
CN IMPOS      positioning for top menu bar captions
CN INFOLL     following sub-menu flag
CN ISHEAD     start of menu storage in RSTORE
CN NITEM      number of items in the current menu
C
CS STORAGE
CS IATTYP     position of atom type number
CS IBOND      bond info
CS ICCMMD     storage array for character argument positions in CSTORE
CS ICCNT      current read position in ICCMMD
CS ICCPOS     next free position in ICCMMD array
CS ICINPS     next free position in INFCMD
CS ICNPOS     next free position in NCOMMD
CS ICNT       current read position in ICOMMD, (and INFCMD)
CS ICOMMD     storage array for command numbers
CS ICPOS      next free position in ICOMMD array
CS ICRPOS     next free position in RCOMMD array
CS ICTPOS     next free position in CTCOMD array
CS ILAB       label info begins
CS INCNT      current read position in NCOMMD
CS INFCMD     storage array for command argument information
CS IPCK       position of pack number
CS IRCNT      current read position in RCOMMD
CS ISYM       symmetry operator info positon
CS ISTACK
CS ITCNT      current read position in CTCOMD
CS IXYZO      position of orthogonal coordinate info
CS NCOMMD     storage array for integer arguments
CS RCOMMD     storage array for real arguments
CS RSTORE     main real storage array
CS ZSTACK     these are the arrays for the plot stack
C
CT BUTTON ROUTINES
CT IBBACK - BACKGROUND COLOUR
CT IBBORD - BORDER COLOUR
CT IBTEXT - TEXT COLOUR
CT IBUTNO - NO OF CURRENT BUTTON DEFINITION
CT IBUTTS IS THE ARRAY THAT HOLDS THE BUTTON POSITION,WIDTH ETC
CT ICENTR - CENTRING FLAG
CT IHEIGT - BUTTON HEIGHT
CT IWIDTH - WIDTH OF THE BUTTONS
C
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'CAMKMS.INC'

      DATA INEVEN /0/, IREVEN /1/, IWEVEN /1/

C DATA FOR THE MAXIMUM NUMBER OF KNOWN ELEMENT TYPES
      DATA NELM /250/
C DATA FOR THE PC KEYS
      DATA ICUP /328/
      DATA ICDOWN /336/
      DATA ICRGHT /333/
      DATA ICLEFT /331/
      DATA ICANTI /339/
      DATA ICCLCK /335/
C DATA FOR THE VAX KEYS
CVAX      DATA ICUP /274/
CVAX      DATA ICDOWN /275/
CVAX      DATA ICLEFT /276/
CVAX      DATA ICRGHT /277/
CVAX      DATA ICANTI /90/
CVAX      DATA ICCLCK /88/
      DATA ICBCK /127/
      DATA ICDEL /8/
      DATA ICRET /13/
      DATA ICESP /27/
      DATA ICLV /86/
      DATA ICUV /118/
      DATA ICHMIN /0/
      DATA ICHMAX /255/
C      DATA IVGACL /0,0,0,
C     c 0,0,63,
C     c 10,30,10,
C     c 63,25,0,
C     c 45,0,0,
C     c 0,63,63,
C     c 63,0,63,
C     c 40,40,40,
C     c 25,25,25,
C     c 30,63,30,
C     c 0,40,63,
C     c 63,10,10,
C     c 63,30,30,
C     c 35,0,50,
C     c 63,63,0,
C     c 63,63,63/
      DATA IGREYC /0,0,0,
     c 4,4,4,
     c 8,8,8,
     c 12,12,12,
     c 16,16,16,
     c 20,20,20,
     c 24,24,24,
     c 28,28,28,
     c 32,32,32,
     c 36,36,36,
     c 40,40,40,
     c 44,44,44,
     c 48,48,48,
     c 52,52,52,
     c 56,56,56,
     c 63,63,63,
     c 36,36,36/
C DATA FOR THE COLOURS
C      DATA IVGACL /0,0,0,
C     c 0,0,63,
C     c 0,63,0,
C     c 63,30,0,
C     c 63,0,0,
C     c 0,63,63,
C     c 63,0,63,
C     c 40,40,40,
C     c 25,25,25,
C     c 10,50,30,
C     c 0,40,63,
C     c 50,15,0,
C     c 60,30,30,
C     c 30,10,50,
C     c 63,63,0,
C     c 63,63,63/
C DATA FOR THE COLOUR NAME
C      DATA COLNAM /'BLACK ','BLUE  ','GREEN ','ORANGE','RED   ',
C     c 'CYAN  ','MAGENT','LGREY ','GREY  ','LGREEN', 'LBLUE ',
C     c 'LRED  ','PINK  ','PURPLE','YELLOW','WHITE '/
      DATA COLGRY /'BLACK ','GREY1 ','GREY2 ','GREY3 ','GREY4 ',
     c 'GREY5 ','GREY6 ','GREY7 ','GREY8 ','GREY9 ' ,'GREY10',
     c 'GREY11','GREY12', 'GREY13','GREY14','WHITE', 'GREY9'/
      DATA IFIRST /0/
C DATA FOR SOME INITIALISATIONS
      DATA IELTYP /4/

      DATA LCLOSE / .TRUE. /

      END
C Test edit 2

      SUBROUTINE CAMSET
	  
      INCLUDE 'CAMPAR.INC'
      INCLUDE 'CAMCOM.INC'
      INCLUDE 'CAMANA.INC'
      INCLUDE 'CAMDAT.INC'
      INCLUDE 'CAMCAL.INC'
      INCLUDE 'CAMMSE.INC'
      INCLUDE 'CAMMEN.INC'
      INCLUDE 'CAMCHR.INC'
      INCLUDE 'CAMGRP.INC'
      INCLUDE 'CAMCOL.INC'
      INCLUDE 'CAMFLG.INC'
      INCLUDE 'CAMSHR.INC'
      INCLUDE 'CAMVER.INC'
      INCLUDE 'CAMKEY.INC'
      INCLUDE 'CAMBTN.INC'
      INCLUDE 'CAMBLK.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'CAMKMS.INC'

      INEVEN = 0 
	  IREVEN =1 
	  IWEVEN =1
C DATA FOR THE MAXIMUM NUMBER OF KNOWN ELEMENT TYPES
      NELM = 250
C DATA FOR THE PC KEYS
      ICUP = 328
      ICDOWN = 336
      ICRGHT = 333
      ICLEFT = 331
      ICANTI = 339
      ICCLCK = 335
      ICBCK = 127
      ICDEL = 8
      ICRET = 13
      ICESP = 27
      ICLV = 86
      ICUV = 118
      ICHMIN = 0
      ICHMAX = 255
      IFIRST = 0
C DATA FOR SOME INITIALISATIONS
      IELTYP = 4
      LCLOSE = .TRUE. 
      END
