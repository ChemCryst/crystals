C***********************************************************************
C                                                                      *
C                        PROGRAM RC93                                  *
C                                                                      *
C                   Written By Paul Lilley 1993/94                     *
C                                                                      *
C*********************************************************************
      PROGRAM RC93
#if defined(CRY_FORTDIGITAL)
      USE DFLIB
#endif
C OCT99 - ierfil UNIT to handle catastrophic errors
C     This is the main controlling program section.
C
#include "RC93CM.INC"
      INTEGER NADD, J
#if defined(_DOS_)
      CHARACTER *8 TIME@, DATE@, CTIME, CDATGB, CDATUS
#else
      CHARACTER *8 CTIME, CDATGB, CDATUS
#endif
      EXTERNAL BLKDAT
#if defined(CRY_GNU)
      call no_stdout_buffer_()
#endif

C Is CRYSDIR set on command line?
      CDLEN = 0
#if defined(CRY_FORTDIGITAL)
      if ( NARGS() .gt. 0 ) then
         CALL GetArg(1,CRYSDIR,CDLEN)
      END IF
#endif

C*******  THE SUBROUTINES TIME@ AND DATE@ ARE NON-STANDARD  ***********
C     Initialise the variables contained in RC93.SRT
      ISTORE(1)=0
      CALL READIN
C
C    Temporary measure- if the machine is not KAPPA then RC93 must stop
C     as it can't deal with other machines yet.
      IF (CMACH .NE. 'KAPPA') THEN
        WRITE (ISCRN, '(1X,A,A)') 'ERROR - RC93 cannot use files fro
     +m machine type ', CMACH
        WRITE (IERFIL, '(1X,A,A)') 'ERROR - RC93 cannot use files fro
     +m machine type ', CMACH
        STOP
      END IF
C
C     Set the pointer for the flag types in the chained list
      IFLAGP = NADD (NFLAGS+1)
      ISTORE (IFLAGP) = NFLAGS
      DO 10 J = IFLAGP, (IFLAGP+(ISTORE(IFLAGP)))
            ISTORE(J) = 0
10    CONTINUE
C
C     This is the start of the loop executed for each input file.
20    CONTINUE
C     Get the filenames for input and output and open the channels,
C     unless have already been through in which case only get input
C     filename.
      CALL GETFIL
C
C     If no more files check if an abs profile has been done then
C     go to the tidy up section.
      IF (LTIDY .NE. 0) THEN
            IF (NRUNS .EQ. 0) THEN
C                 No files processed
                  WRITE (ISCRN, '(30X,''No files processed'')')
                  WRITE (IERFIL, '(30X,''No files processed'')')
                  STOP
            END IF
            IF (INT(NRUNS/100) .EQ. 0) THEN
C                 Haven't processed an absorption profile, ask if one
C                 was done.
                  WRITE (ISCRN, '(/)')
                  CALL CENTRE (ISCRN,
     +            'No absorption profile has been processed')
                  CALL CENTRE (IERFIL,
     +            'No absorption profile has been processed')
21                CONTINUE
                 WRITE (ISCRN, '(1X,A,A)') 'Has an absorption profile',
     +            ' been measured (y/n)? [y]'
                  CALL READLN (IKEYBD)
                  IF (KERR .NE. 0) GO TO 21
                  IF ((CLINE .EQ. CNULL).OR. (CLINE(:1) .EQ. 'Y')) THEN
                        LTIDY = 0
                        GO TO 20
                  ELSE IF (CLINE(:1) .EQ. 'N') THEN
                        WRITE (ISCRN, '(/)')
                        CALL CENTRE (ISCRN,
     +              'A psi absorption correction will not be applied')
                        CALL TIDYUP
                        GO TO 999
                  ELSE
                        GO TO 21
                  END IF
            ELSE
C                 Have read in an absorption profile
                  CALL TIDYUP
                  GO TO 999
            END IF
      END IF
C
C     Determine whether abs profile or main data.
      CALL SCANER
C     Determine whether CAD4 1 or 2.
25    CONTINUE
C     A temporary measure until can distinguish Mark I and II
C     automatically
      IF (.NOT. ((MARK.EQ.1) .OR. (MARK.EQ.2))) THEN
            WRITE (ISCRN, '(1X,''CAD4 mark 1 or 2 ?'')' )
            READ (IKEYBD, *,ERR=25) MARK
            GO TO 25
      END IF
C     Write a title onto the .LIS file, CBUFFR is an output buffer to
C     the .LIS file.  The subroutine CENTRE centres the output buffer
C     for an 80 column file and writes it to the file (or screen).
C     Convert the date from American format to British.
      LENINP = LENSTR(CINPFL)
#if defined(_DOS_)
      CDATUS = DATE@()
#else
      CDATUS = "00/00/00"
#endif
      CDATGB = CDATUS
      CDATGB (1:2) = CDATUS (4:5)
      CDATGB (4:5) = CDATUS (1:2)
#if defined(_DOS_)
      CTIME = TIME@()
#else
      CTIME = "00:00"
#endif
      WRITE (CBUFFR, '(A,A,A,A,A,A)') 'RC93 Processing File  ',
     +CINPFL(:LENINP), '  at ', CTIME(:5), ' on ', CDATGB
C&VAX      WRITE (CBUFFR, '(A,A)') 'RC93 Processing File  ',
C&VAX     +CINPFL(:LENINP)
C&UNX  WRITE (CBUFFR,'(A,A)')'RC93 (Unix) Processing File ',
C&UNX     1 CINPFL(:LENINP)
      WRITE (LISFIL, '(/)')
      CALL CENTRE (LISFIL, CBUFFR)
      WRITE (LISFIL, '(/)')
C
50    CONTINUE
      MN2ABS = 0
      IF (LABPRO .EQ. 1) THEN
C           Indicate that an abs profile has been done by adding 100
C           to NRUNS.
            NRUNS = NRUNS +100
            CALL ABSPRO
            IF (MN2ABS .LT. 0) THEN
                  GO TO 50
            END IF
            GO TO 20
      ELSE
C           Get the batch number default=1
60          CONTINUE
            WRITE (ISCRN, '(1X,A)') 'Batch number? [default=1]'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 60
            IF (CLINE .EQ. CNULL) THEN
                  IBATCH = 1
            ELSE
                  READ (CLINE, *, ERR=60) IBATCH
                  IF ((IBATCH .LE. 0) .OR. (IBATCH .GT. 999)) THEN
                   WRITE (ISCRN,'(1X,A)')'ERROR - Invalid batch number'
                    GO TO 60
                  END IF
            END IF
            CALL MAINDA
            NRUNS = NRUNS +1
            IF (MN2ABS .GT. 0) THEN
                  GO TO 50
            END IF
            GO TO 20
      END IF
999   CONTINUE
      WRITE (ISCRN, '(/)')
      CALL CENTRE (ISCRN, 'RC93 FINISHES')
      END
C
      BLOCK DATA BLKDAT
C     This file contains the initialisation data for the COMMON blocked
C     variables.
#include "RC93CM.INC"
*      DATA STORE,ISTORE/65536*0/
      DATA ISCRN, IKEYBD/ 6, 5/
      DATA INIFIL, LISFIL, INPFIL, ISCFFL, IHKLFL, IABSFL/ 10, 11, 12,
     +13, 14, 15/
      DATA IHLPFL, ITMPFL, IERFIL /16, 21, 22/
      DATA IATTFL, ISPABS, ISCATT, IATPRO/17, 18, 19, 20/
      DATA MACHIN, NCODE, LCAPPR/ 0, 0, 0/
      DATA CMACHS/ 'NORMAL', 'EQUI', 'ANTI', 'PRECESSION', ' CAD4'
     +, 'ROLLETT', 'Y290', 'KAPPA', 'NONE'/
      DATA CMACH, COUTFL/ ' ', ' '/
      DATA CNULL, CCOND /' ', ' '/
      DATA CDTCOL /' ', ' ', ' '/
      DATA CATOMS /80*'  '/
      DATA NATOMS /80*0/
      DATA XSECT /80*0.0/
      DATA ATOMWT/80*0.0/
      DATA LTIDY, LOVRWR /0, 0/
      DATA ISKIP, NRUNS /0, 0/
      DATA INPLIN, IBATCH /0, 1/
      DATA NOBS, NLGTR, NRGTR, NEGTH /4* 0/
      DATA MINSP, MAXSP/ 999, -999/
      DATA NREFDP /0/
      DATA NFLAGS / 9/
      DATA MN2ABS /0/
C     Initialise the pointers to the chained list.
c      DATA ISTORE(1) / 0/
      DATA NFREEP, NMAXP /2, 100000/
      DATA IR21P, IR22P, IR24P, IFLAGP, MINITP, MLASTP /6 * 1 /
      DATA ISTDSP, LSTDSP, IGSCFP /3 * 1 /
      DATA ICELLP, NWCELP, L30P, ISTATP /1, 1, 1, 1 /
      DATA IESDSP /1/
C
      DATA MARK, IRAD/0, 0/
      DATA NGROUP, NUMGSF / 0, 0 /
      DATA DISFAC, RCON2/ 0.1, 0.0 /
      END
C**********************************************************************
C
      SUBROUTINE RC31N2
C     This subroutine does the processing for records 31 and 32.  These
C     always come together unless the file has been corrupted.
C     They contain the orientation matrix for the crystal and also the
C     wavelengths lambda1 and lambda2, and the attenuator factor.
C     The attenuator factor from CAD4 is written to the .LIS file, the
C     attenuator factor written to the chained list(and used in
C     calculations) is that in the file ATT.DAT.
C     The orientation matrix
C     is updated so as to hold the first and last matrices.  A count is
C     kept of the number of automatic reorientations.
C     The structure of the chained list is described at the end.
C     The format for both Þrecords is:-
C     1X, I2, 2X, F9.6, F9.6, F9.6, 2X, F9.6, F9.6, F9.6, 1X
#include "RC93CM.INC"
      INTEGER J, LAM1, LAM2, LAM1F, LAM2F, MARKF, IRADF
      REAL RLAM1F, RLAM2F, ATTFAC
      INTEGER NADD
      IF (MINITP .EQ. 1) THEN
C           This is the first record 31&32, reserve space and set no.
C          of reorientations (held in ISTORE(MINITP)) to zero. Set att.
C           factor and wavelength.
            MINITP = NADD ( (9+1) +2 +1 )
            ISTORE(MINITP) = 0
C           Set attenuator factor to 0.0 initially.
            STORE(MINITP+12) = 0.0
            READ (CARD1, 1001)   (STORE(MINITP+J),   J=1,6)
            READ (CARD2, 1001)   (STORE(MINITP+6+J), J=1,6)
            GO TO 10
      ELSE IF (ISTORE(MINITP) .EQ. 0) THEN
C           Have read in INITIAL orientation matrix already, but no
C           others. Reserve space for this one and increment the no of
C           reorientations.
            IF (MLASTP .EQ. 1) MLASTP = NADD (9)
C            ISTORE(MINITP) = ISTORE(MINITP) +1
            READ (CARD1, 1001)   (STORE(MLASTP+(J-1)),   J=1,6)
            READ (CARD2, 1002)   (STORE(MLASTP+6+(J-1)), J=1,3)
C           Check that this is not the same matrix (eg a second
C           shell outputing records 31&32 after the refdump).
            DO 5 J=1,9
                  IF (NINT(STORE(MINITP+J)*1000000) .EQ.
     +                        (NINT(STORE(MLASTP+J-1)*1000000))) THEN
                        GO TO 5
                  ELSE
                        ISTORE(MINITP) = ISTORE(MINITP) +1
                        GO TO 999
                  END IF
5           CONTINUE
C           Only get here if the two matrices are the same.
C            ISTORE(MINITP) = ISTORE(MINITP) -1
            GO TO 999
      ELSE IF (ISTORE(MINITP) .GT. 0) THEN
C           Have already read in more than two matrices, so overwrite
C           the last with the new one and update the no. of reorient's.
            ISTORE(MINITP) = ISTORE(MINITP) +1
            READ (CARD1, 1001)   (STORE(MLASTP+(J-1)),   J=1,6)
            READ (CARD2, 1002)   (STORE(MLASTP+6+(J-1)), J=1,3)
            GO TO 999
      END IF
1001  FORMAT (5X, 3F9.6, 2X, 3F9.6)
1002  FORMAT (5X, 3F9.6)
C
10    CONTINUE
C This is the first rec 31&2, need to set attenuator and wavelengths.
C Also need to set CCOND the condition statement for Crystals.
C The lambda1, lamda2 and att.factor are in STORE(MINITP+10, 11, 12)
C Compare the wavelengths from CAD4 with those in ATT.DAT to 2
C decimal places. Compare the attenuator factors to 3dp, if different
C     USE THE VALUE IN ATT.DAT.
      LAM1 = NINT (STORE(MINITP+10)*100.0)
      LAM2 = NINT (STORE(MINITP+11)*100.0)
20    CONTINUE
      READ (IATTFL, '(A80)', END=60, ERR=50) CBUFFR
      IF (CBUFFR(:2) .NE. ' *') THEN
            GO TO 20
      ELSE
            READ (CBUFFR, '(2X,I2,2(1X,F7.5))') IRAD, RLAM1F, RLAM2F
            READ (IATTFL, '(A80)') CCOND
            LAM1F = NINT (RLAM1F*100.0)
            LAM2F = NINT (RLAM2F*100.0)
            IF ((LAM1 .NE. LAM1F) .OR. (LAM2 .NE. LAM2F)) GO TO 20
      END IF
C     By now we have matched up the wavelengths and found the
C     radiation type, and got the CONDITION statement for Crystals.
C     Rewind the file and scan for the att. factor
C     corresponding to the radiation and Mark 1 or 2.
      REWIND (IATTFL)
30    CONTINUE
      cbuffr = ' '
      READ (IATTFL, '(A80)', ERR=50, END=60) CBUFFR
      IF (.NOT.((CBUFFR(:2).EQ.' 1').OR.(CBUFFR(:2).EQ.' 2'))) GO TO 30
      READ (CBUFFR, '(I2, I2, 1X, F7.3)', ERR=30) MARKF, IRADF, ATTFAC
      IF ((MARKF .NE. MARK) .OR. (IRADF .NE. IRAD)) THEN
                  GO TO 30
      ELSE IF ((NINT(ATTFAC*1000)) .NE.
     +                              (NINT(STORE(MINITP+12)*1000))) THEN
C    Value from ATT.DAT used if the values differ (they will on mark1).
                  STORE(MINITP+12) = ATTFAC
      END IF
      GO TO 999
50    CONTINUE
      WRITE (ISCRN, '(1X,A)') 'ERROR READING FILE ATT.DAT'
      WRITE (IERFIL, '(1X,A)') 'ERROR READING FILE ATT.DAT'
      STOP
60    CONTINUE
      WRITE (ISCRN, '(1X,A/1X,A)') 'ERROR READING FILE ATT.DAT',
     +'Attenuator factor or wavelengths not found or not matching CAD4
     +output.'
      WRITE (IERFIL, '(1X,A/1X,A)') 'ERROR READING FILE ATT.DAT',
     +'Attenuator factor or wavelengths not found or not matching CAD4
     +output.'
      STOP
999   CONTINUE
      RETURN
      END
C    This section describes the structure of the  chained list.
C    The initial orientation matrix:-
C_____________________________________________________________________
CÝ +0 Ý +1 Ý +2 Ý +3 Ý +4 Ý +5 Ý +6 Ý +7
CÝ +8 Ý +9 Ý+10 Ý+11 Ý+12 Ý
C---------------------------------------------------------------------
C
C     MINITP            - start of the initial orient matrix
C     ISTORE(MINITP+0)  - No of automatic reorientations
C      STORE(MINITP+1)  - orient matrix element 1,1 (row,column)
C      STORE(MINITP+2)  -                       1,2
C      STORE(MINITP+3)  -                       1,3
C      STORE(MINITP+4)  -                       2,1
C      STORE(MINITP+5)  -                       2,2
C      STORE(MINITP+6)  -                       2,3
C      STORE(MINITP+7)  -                       3,1
C      STORE(MINITP+8)  -                       3,2
C      STORE(MINITP+9)  -                       3,3
C      STORE(MINITP+10) - Lambda 1
C      STORE(MINITP+11) - Lambda 2
C      STORE(MINITP+12) - Attenuator factor (positive)
C
C     The most recent orientation matrix:-
C_____________________________________________________________________
CÝ +0 Ý +1 Ý +2 Ý +3 Ý +4 Ý +5 Ý +6 Ý +7
CÝ +8 Ý +9 Ý+10 Ý+11 Ý+12 Ý
C---------------------------------------------------------------------
C     MLASTP            - Pointer to start of latest orient matrix
C      STORE(MLASTP+1)  - orient matrix element 1,1 (row,column)
C      STORE(MLASTP+2)  -                       1,2
C      STORE(MLASTP+3)  -                       1,3
C      STORE(MLASTP+4)  -                       2,1
C      STORE(MLASTP+5)  -                       2,2
C      STORE(MLASTP+6)  -                       2,3
C      STORE(MLASTP+7)  -                       3,1
C      STORE(MLASTP+8)  -                       3,2
C      STORE(MLASTP+9)  -                       3,3
C
C**********************************************************************
C
      SUBROUTINE READIN
C     This routine has been restructured to cope with an incomplete
C     .INI file, by using subroutines. These will only be used by this
C     subroutine so are also in the same file.
C     It should determine
C                 the diffractometer type
C                 whether filenames need to be capitalised.
C                 whether to prompt before overwriting existing files
#include "RC93CM.INC"
      CHARACTER*80 CAPION
C     Variable NLINE has been made COMMON.
C***      This will need to be altered for nonDOS systems  *********
      CLGFL = 'CRYSDIR:/rc93.srt'
      CALL MTRNLG(CLGFL, 'OLD', LENFIL)
      OPEN (INIFIL, FILE=CLGFL(1:LENFIL), STATUS='OLD', ERR=5
C&VAX     2 ,READONLY
     3 )
      REWIND INIFIL
      NLINE = 0
      GO TO 10
5     CONTINUE
C     Error opening the RC93.INI file.
      WRITE(ISCRN,'(A,A)') 'Error opening ', clgfl(1:lenfil)
      WRITE(IERFIL,'(A,A)') 'Error opening ', clgfl(1:lenfil)
      WRITE(ISCRN,'(1X,A,/,A,/,A/A)')
     1 'ERROR: THE FILE ''RC93.INI'' COULD NOT BE OPENED',
     2 'This file contains information necessary to set up RC93.',
     3 'This information will be the same each time RC93 is',
     4 'run so it is recommended to create the RC93.INI file.'
      WRITE(Ierfil,'(1X,A,/,A,/,A/A)')
     1 'ERROR: THE FILE ''RC93.INI'' COULD NOT BE OPENED',
     2 'This file contains information necessary to set up RC93.',
     3 'This information will be the same each time RC93 is',
     4 'run so it is recommended to create the RC93.INI file.'
      STOP
10    CONTINUE
      NLINE = NLINE+1
      ISKIP = 1
      CALL READLN (INIFIL)
      ISKIP = 0
      IF (KERR .NE. 0) THEN
            IF (KERR .LT. 0) THEN
C                             End of file reached.
                  GO TO 100
            ELSE
C                             Error during the reading of the line
                  GO TO 15
            END IF
      END IF
      GO TO 25
15    CONTINUE
C     Error reading from the .INI file.  Format may be wrong.
      WRITE (ISCRN,'(1X, A, I4)') 'ERROR READING RC93.INI -please check
     + line ', NLINE
      WRITE (IERFIL,'(1X, A, I4)')'ERROR READING RC93.INI -please check
     + line ', NLINE
      STOP
25    CONTINUE
C     If the first character of the line is not blank then that line is
C     a comment and is skipped over by subroutine READLN.
      READ (CLINE(2:3), '(I2)', ERR=15) NCODE
C     Go to the appropriate section as indicated by NCODE. (NCODE is
C     the code in RC93.INI to indicate what sort of information the
C     line contains).
      IF (NCODE .EQ. 1) THEN
            CALL WOTDIF
C           Determines the diffractometer type
            GO TO 10
      ELSE IF (NCODE .EQ. 2) THEN
            CALL CAPIT
C           Sets whether to capitalise filenames
            GO TO 10
      ELSE IF (NCODE .EQ. 3) THEN
            CALL OVPRMP
C           Sets whether to prompt before overwriting files
            GO TO 10
      ELSE IF (NCODE .EQ. 4) THEN
            CALL SETHLP
C           Sets the path, and name, of the HELP file.
            GO TO 10
      ELSE IF (NCODE .EQ. 5) THEN
            CALL ATTEN
C           Sets path and name of the ATTENUATOR COEFFICIENT data file.
            GO TO 10
      ELSE IF (NCODE .EQ. 6) THEN
            CALL SPHABS
C          Sets path, etc. of the SPHERICAL ABSORPTION CORR FACTOR file
            GO TO 10
      ELSE IF (NCODE .EQ. 7) THEN
            CAPION='Atomic Scattering Factors'
            CALL ATSCAT (CAPION,
     +                          CSCATT)
C           Sets path, etc. of the ATOMIC SCATTERING FACTORS file.
            GO TO 10
C           **!! CODE 8 REDUNDANT !!**
C      ELSE IF (NCODE .EQ. 8) THEN
C            CAPION = 'Atomic Scattering Factors for Copper radiation'
C            CALL ATSCAT (CAPION,
C     +                          CSCACU)
CC           Sets path, etc. of the ATOMIC SCATTERING FACTORS for
CC     copper radiation.
C            GO TO 10
C           **!! CODE 8 REDUNDANT !!**
      ELSE IF (NCODE .EQ. 9) THEN
            CALL ATPROP
C           Sets path, etc. of the ATOMIC PROPERTIES file
            GO TO 10
      ELSE IF (NCODE .EQ. 10) THEN
C           Sets minimum acceptable -ve Fsq
      READ (CLINE(6:), '(F8.0)', ERR=15) FSQNEG
            GO TO 10
      ELSE
            WRITE (ISCRN, '(1X,A)') '******ERROR******'
            WRITE (ISCRN, '(1X,A, I3,A, I4,A, /,15X,A)') 'The code '
     +,NCODE,',at line ',NLINE,
     +' in the RC93.INI file has not been recognised.',
     + 'Please check this file.'
            WRITE (IERFIL, '(1X,A,I3,A,I4,A,/,15X,A)') 'The code '
     +,NCODE,',at line ',NLINE,
     +' in the RC93.INI file has not been recognised.',
     + 'Please check this file.'
            STOP
      END IF
100   CONTINUE
      CLOSE (INIFIL)
C     When we have got here we need to check whether or not all of the
C     necessary variables have been initialised, and prompt for them if
C     they haven't.
C
      IF (CMACH .EQ. ' ') CALL WOTDIF
      IF ((LCAPPR .LT.0) .OR. (LCAPPR .GT. 1)) CALL CAPIT
      IF ((LOVRWR .LT. 0) .OR. (LOVRWR .GT. 1)) CALL OVPRMP
      IF (CHLPFL .EQ. CNULL) CALL SETHLP
      IF (CATTFL .EQ. CNULL) CALL ATTEN
      IF (CSPABS .EQ. CNULL) CALL SPHABS
      IF (CSCATT .EQ. CNULL) THEN
        CAPION='Atomic Scattering Factors for Molybedenum radiation'
            CALL ATSCAT (CAPION,
     +                          CSCATT)
      END IF
C      IF (CSCACU .EQ. CNULL) THEN
C            CAPION = 'Atomic Scattering Factors for Copper radiation'
C            CALL ATSCAT (CAPION,
C     +                          CSCACU)
C      END IF
      IF (CATPRO .EQ. CNULL) CALL ATPROP
C
      RETURN
      END
C**********************************************************************
C     This subroutine reads in the diffractometer type, or prompts for
C     it if it is not there or is unrecognised.
      SUBROUTINE WOTDIF
#include "RC93CM.INC"
      INTEGER J
C  If this has been called because it was not called automatically by
C     the .INI file, then CLINE will be blank and we need to prompt.
      IF (CLINE .EQ. CNULL) GO TO 31
      READ (CLINE(6:21), '(A15)', ERR=31) CMACH
      DO 30 J =1, NMACHS
            IF (CMACH .EQ. CMACHS(J)) THEN
                  MACHIN = J
                  GO TO 40
            END IF
30    CONTINUE
C
31    CONTINUE
C     If we get here then the machine type has not been recognised
C     from RC93.INI so prompt user.
      WRITE (ISCRN,'(1X,A,A, /,20X,A,/)')'The diffractometer type has'
     +,' not been recognised from the RC93.INI','initialisation file.'
      WRITE (IERFIL,'(1X,A,A, /,20X,A,/)')'The diffractometer type has'
     +,' not been recognised from the RC93.INI','initialisation file.'
32    CONTINUE
      WRITE (ISCRN, 35) 'NORMAL', 'Normal beam Weissenberg geometry'
      WRITE (ISCRN, 35) 'EQUI', 'Equi-inclination Weissenberg geometry'
      WRITE (ISCRN, 35) 'ANTI', 'Anti-equi-inclination Weissenberg'
      WRITE (ISCRN, 35) 'PRECESSION', 'Precession Weissenberg'
      WRITE (ISCRN, 35)'CAD4','Nonius CAD4 diffractometer Eulerian ang
     +les'
      WRITE (ISCRN, 35)'ROLLETT','Page 28, Computing Methods in Crysta
     +llography'
      WRITE (ISCRN, 35) 'Y290', 'Hilger-Watts Y290 4-circle diffractomet
     +er'
      WRITE (ISCRN, 35) 'KAPPA', 'Nonius CAD4 in Kappa geometry'
      WRITE (ISCRN, 35) 'NONE', 'Type unknown'
      WRITE (ISCRN, '(/,1X,A)') 'Please enter the machine type:'
35    FORMAT(1X, 5X, A15, 1X, '-', A)
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 32
      READ (CLINE, '(A15)') CMACH
      DO 38 J= 1, NMACHS
            IF (CMACH .EQ. CMACHS(J)) THEN
                  MACHIN = J
                  GO TO 40
            END IF
38    CONTINUE
C     If we get here then the diffractometer type is still not
C     recognised.  A default type of NONE (same as in Crystals) is
C     applied and a warning issued, if the user does not choose to
C     re-enter the type.
      WRITE (ISCRN, '(20X,A)') 'DIFFRACTOMETER TYPE NOT RECOGNISED'
      WRITE (ISCRN, '(/, 1X,A)') 'Re-enter machine type? [y/n] '
      CALL READLN(IKEYBD)
      IF (KERR .NE. 0) GO TO 32
      IF (CLINE(:1) .NE. 'N') GO TO 32
      WRITE (ISCRN, 39)
C     Need to write this to the .LIS file too but need the generic
C     filename first.
39    FORMAT (10X, 'A DEFAULT TYPE OF ''UNKNOWN'' WILL BE ENTERED INTO C
     +RYSTALS')
      CMACH = 'NONE'
      MACHIN = 8
40    CONTINUE
C     Now we have the diffractometer type.
      CLINE = CNULL
      RETURN
      END
C**********************************************************************
C     Read in whether to capitalize all filenames, user input, etc.
      SUBROUTINE CAPIT
#include "RC93CM.INC"
C     If this has not been called automatically, CLINE will be blank so
C     need to prompt.
      IF (CLINE(4:) .EQ. ' ') GO TO 220
      READ (CLINE, '(5X,I2)', ERR=220) LCAPPR
      IF ((LCAPPR .LT. 0) .OR. (LCAPPR .GT. 1)) GO TO 220
      GO TO 230
220   CONTINUE
C     Haven't been able to decide automatically whether to capitalise or
C     not, so prompt user.
      WRITE (ISCRN, '(1X,A)') 'Do you want RC93 to capitalise all filena
     +mes before use [y/n] ?'
      CALL READLN(IKEYBD)
      IF (KERR .NE. 0) GO TO 220
      IF (CLINE(:1) .EQ. 'Y') THEN
            LCAPPR = 0
            GO TO 230
      ELSE IF (CLINE(:1) .EQ. 'N') THEN
            LCAPPR = 1
            GO TO 230
      ELSE
            GO TO 220
      END IF
230   CONTINUE
      CLINE = CNULL
      RETURN
      END
C*********************************************************************
C     This subroutine reads in whether to prompt before 'overwriting'
C     files
      SUBROUTINE OVPRMP
#include "RC93CM.INC"
      IF (CLINE(4:) .EQ. ' ') GO TO 310
      READ (CLINE,  '(5X,I2)', ERR=310) LOVRWR
      IF ((LOVRWR .LT. 0) .OR. (LOVRWR .GT. 1)) THEN
            GO TO 310
      ELSE
            GO TO 330
      END IF
310   CONTINUE
      WRITE (ISCRN, '(1X,A,/,A)') 'Should RC93 prompt you before creatin
     +g a new version', ' of an existing file? [y/n]:-'
      WRITE (ISCRN, '(1X,A,/,A,/)') '[YES is recommended unless your ope
     +rating system creates a new', 'version without destroying the old
     +file, eg:VMS]'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 310
      IF (CLINE(1:1) .EQ. 'Y') THEN
            LOVRWR = 0
            GO TO 330
      ELSE IF (CLINE(1:1) .EQ. 'N') THEN
            LOVRWR = 1
            GO TO 330
      ELSE
            GO TO 310
      END IF
330   CONTINUE
      CLINE = CNULL
      RETURN
      END
C**********************************************************************
      SUBROUTINE SETHLP
C     This subroutine sets the path and filename of the HELP file.
#include "RC93CM.INC"
      CHARACTER*80 CAPION
      CAPION = 'HELP file'
      CALL GETPTH (CAPION,
     +                    CHLPFL)
      CLINE = CNULL
      RETURN
      END
C***********************************************************************
      SUBROUTINE ATTEN
C     This subroutine reads in the path and filename for the attenuator
C     coefficient data file.
#include "RC93CM.INC"
      CHARACTER*80 CAPION
      CAPION = 'Attenuator Coefficient Data'
30    CONTINUE
      CALL GETPTH (CAPION,
     +                    CATTFL)
      CLGFL = CATTFL
      CALL MTRNLG(CLGFL, 'OLD', LENFIL)
      OPEN (IATTFL, FILE=CLGFL(1:LENFIL), STATUS='OLD', ERR=200
C&VAX     2 ,READONLY
     3 )
      CATTFL = CLGFL(1:LENFIL)
      GO TO 250
200   CONTINUE
C     Need to set CLINE to a blank string so that GETPTH will prompt
C     for a new filename.
      CLINE = CNULL
      GO TO 30
250   CONTINUE
      CLINE = CNULL
      RETURN
      END
C***********************************************************************
      SUBROUTINE SPHABS
C     This subroutine reads in the path and filename for the Spherical
C     Absorption Correction Factors.
#include "RC93CM.INC"
      CHARACTER*80 CAPION
      CAPION = 'Spherical Absorption Correction Factors'
30    CONTINUE
      CALL GETPTH (CAPION,
     +                    CSPABS)
      CLGFL = CSPABS
      CALL MTRNLG(CLGFL, 'OLD', LENFIL)
      OPEN (ISPABS, FILE=CLGFL(1:LENFIL), STATUS='OLD', ERR=200
C&VAX     2 ,READONLY
     3 )
      CSPABS = CLGFL(1:LENFIL)
      GO TO 250
200   CONTINUE
C     Need to set CLINE to a blank string so that GETPTH will prompt
C     for a new filename.
      CLINE = CNULL
      GO TO 30
250   CONTINUE
      CLINE = CNULL
      RETURN
      END
C***********************************************************************
      SUBROUTINE ATSCAT (CAPION, CTYPE)
C     This subroutine reads in the path and filename for the Atomic
C     Scattering Factors, for both Cu and Mo radiation.
#include "RC93CM.INC"
      CHARACTER*80 CAPION, CTYPE
      LOGICAL LOGEX
30    CONTINUE
      CALL GETPTH (CAPION,
     +                    CTYPE)
      CLGFL = CTYPE
      CALL MTRNLG(CLGFL, 'UNKNOWN', LENFIL)
      CTYPE = CLGFL(1:LENFIL)
      INQUIRE (FILE=CTYPE, EXIST=LOGEX, ERR=200)
      IF (.NOT.(LOGEX)) GO TO 200
      GO TO 250
200   CONTINUE
C     Need to set CLINE to a blank string so that GETPTH will prompt
C     for a new filename.
      CLINE = CNULL
      GO TO 30
250   CONTINUE
      CLINE = CNULL
      RETURN
      END
C***********************************************************************
      SUBROUTINE ATPROP
C     This subroutine reads in the path and filename for the Atomic
C     Properties.
#include "RC93CM.INC"
      CHARACTER*80 CAPION
      LOGICAL LOGEX
      CAPION = 'Atomic Properties'
30    CONTINUE
      CALL GETPTH (CAPION,
     +                    CATPRO)
      CALL MTRNLG(CATPRO, 'UNKNOWN', LENFIL)
      INQUIRE (FILE=CATPRO, EXIST=LOGEX, ERR=200)
      IF (.NOT.(LOGEX)) GO TO 200
C     This file is only opened by the routines which need it.
C      OPEN (IATPRO, FILE=CATPRO, STATUS='OLD', ERR=200)
      GO TO 250
200   CONTINUE
C     Need to set CLINE to a blank string so that GETPTH will prompt
C     for a new filename.
      CLINE = CNULL
      GO TO 30
250   CONTINUE
      CLINE = CNULL
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE READLN (IUNIT)
C     This subroutine reads a line from the specified unit as a
C     CHARACTER*80 input CULINE, it then capitalises this to give CLINE.
C     If the input is 'help' then the help function is called from this
C     routine.
C     If an error occurs then KERR.ne.0.
#include "RC93CM.INC"
      INTEGER IUNIT
C     CHARACTER*80 CLINE, CULINE         ***COMMON BLOCKED ARGUMENTS***
C     INTEGER KERR, iskip
      CLINE = ' '
      CULINE = ' '
      KERR = 1
10    CONTINUE
      culine = ' '
      READ (IUNIT, '(A80)', ERR=100, IOSTAT=KERR, END=100) CULINE
C     If the skip flag is set then skip this line if the first character
C     is non blank.
      IF ((ISKIP .NE. 0) .or. (ikeybd .ne. iunit )) THEN
            IF (CULINE(1:1) .NE. ' ') GO TO 10
      END IF
C     Error handling done in the calling routine, END OF FILE gives
C     KERR<0, any other error give KERR>0, success gives KERR=0.
      CALL CAPPER (CULINE,
     +                    CLINE)
C     Allow user to quit or callup help at any time
      IF (CLINE(:4) .EQ. 'HELP') THEN
            CALL HELP
            KERR = 100
      ELSE IF (CLINE(:4) .EQ. 'QUIT') THEN
            CALL CENTRE (ISCRN,'PROGRAM STOPS : PROCESSING INCOMPLETE')
            STOP
      END IF
100   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE REC1N2
C     This subroutine deals with the processing required for records 1 &
C     2 and outputs a line of the .HKL file, if the reflection is not an
C     orientation or intensity control.
C     The format of Record 1 is
C   FORMAT  I2,    I6, I5, I5, I5, 1X, 6A1, F7.2,  I4,  I6,  I7,  I6, 1X
C           1 , NREFL,  H,  K,  L,    CODE,  PSI, NPI, BGL, IPEAK, BGR
C     The NREFL, H, K, L and CODE are read in as a character entity.
C     NPI, BGL, INT and BGR are read into an array IBUFF1(4).
C
C     The format of record 2 is
C   FORMAT  I2,    I6,  F8.3, F9.3, F9.3,  F9.3,  F7.3,    I7,   I3,  1X
C           2 , NREFL, THETA, PHIK,  OMK, RKAPPA, WIDTH, IXRAYT, FRIDL
C
#include "RC93CM.INC"
      INTEGER IXRAYT, FRIDL
      INTEGER JCODE, IBIN
      REAL RINDS(3)
      character *1 c1, c2
      INTEGER INDJW(3)
      REAL DELTA, SIGDEL
      INTEGER IBUFF1(4)
      REAL PSI, THETA, PHIK, OMK, RKAPPA, WIDTH, FOBS, SIGMA
C
C     INTEGER NOBS, NEGTH these are in the common block.
C     NOBS is the number of reflections written out to the .HKL file.
C     The number of main data reflections flagged anything
C     are stored in ISTORE after pointer IFLAGP. ISTORE (IFLAGP)
C     holds the no. of flag types to follow.  The flag types are in the
C     following order Normal, Collision, Strong, Too strong, Other(4),
C     Static, Background, Weak, Deviating, X chie impossible.
C
C      write(lisfil,'(''1:'',a)') card1
C      write(lisfil,'(''2:'',a)') card2
      read(card1, '(2x,a1)') c1
      if (c1 .ne.'1') goto 100
      read(card2, '(2x,a1)') c1
      if (c1 .ne.'2') goto 100
c
      READ (CARD1, 1001) CCARD, PSI, IBUFF1
1001  FORMAT (1X, 2X, A28, F7.2, I4, I6, I7, I6)
      READ (CARD2, 1002) THETA, PHIK, OMK, RKAPPA, WIDTH, IXRAYT, FRIDL
1002  FORMAT (1X, 2X, 6X, F8.3, 3F9.3, F7.3, I7, I3)
C     If the reflection is an intensity or orientation control then we
C     need to process it differently to the main reflections.
C     The first clause of this block if really belongs in the section
C     below on Jcodes, but is put here to speed things up a little.
      JCODE = 1
      IF ((CCARD(23:28) .EQ. 'N*****') .OR.
     1    (CCARD(23:28) .EQ. 'N***0*'))THEN
            JCODE = 1
            ISTORE(IFLAGP+1) = ISTORE(IFLAGP+1) +1
            GO TO 30
      ELSE IF (CCARD(23:23) .EQ. 'N') THEN
C                                   Normal data collection reflection.
            GO TO 20
      ELSE IF (CCARD(23:23) .EQ. 'I') THEN
C                                   Do intensity control stuff.
            CALL INTENS
            GO TO 9900
      ELSE IF (CCARD (23:23) .EQ. 'S') THEN
C                                   Static background, ignore??
            ISTORE (IFLAGP+6) = ISTORE(IFLAGP+6) +1
            GO TO 100
      ELSE
            WRITE (ISCRN, '(1X,A,A,A,I4,A)') 'ERROR - Illegal code in ',
     +              CINPFL(:LENINP), 'line', INPLIN, 'Record skipped'
            GO TO 9999
      END IF
C
20    CONTINUE
C
C     Now need to calcluate the JCODE for CRYSTALS.
C     The JCODE's are:
C            1     normal reflection
C            9     weak reflection
C            7     flagged strong S but not flagged D
C            2     deviates from expected position/peak shape, but not W
C            3     failed non-equal test at least once
C            6     flagged weak
C            4     reflection is bad
C            8     flagged strong T but not flagged D
C     The order of comparisons corresponds to the order of likelihood of
C     having a particular code.
C***********************************************************************
C     The decisions here as to what JCODE is given are my attempt to do
C     the same as was done in RC85, however that was fairly arbitrary
C     and this section may well need altering in the future.
C***********************************************************************
      IF (CCARD(26:26) .EQ. 'W') THEN
            IF (IBUFF1(1) .LT. 0) THEN
             WRITE (CBUFFR, '(A,A,A,A,A)') 'Reflection ', CCARD(:6),
     1      ' code ', CCARD(23:28), ' Weak but attenuator set '
             WRITE (ISCRN, '(1X,A)') CBUFFR
             WRITE (LISFIL, '(1X,A)') CBUFFR
             JCODE = 4
             ISTORE(IFLAGP+5) = ISTORE(IFLAGP+5) +1
            ELSE
             JCODE = 9
             ISTORE(IFLAGP+7) = ISTORE(IFLAGP+7) +1
            ENDIF
      ELSE IF (CCARD(26:26) .EQ. 'S') THEN
            JCODE = 7
            ISTORE(IFLAGP+3) = ISTORE(IFLAGP+3) +1
      ELSE IF (CCARD(26:26) .EQ. 'T') THEN
            JCODE = 8
            ISTORE(IFLAGP+4) = ISTORE(IFLAGP+4) +1
            WRITE (CBUFFR, '(A,A,A,A,A)') 'Reflection ',
     1      CCARD(:6), ' code ', CCARD(23:28), ' Too strong '
            WRITE (ISCRN, '(1X,A)') CBUFFR
            WRITE (LISFIL, '(1X,A)') CBUFFR
      ELSE IF (CCARD(24:24) .EQ. 'D') THEN
            JCODE = 2
            ISTORE(IFLAGP+8) = ISTORE(IFLAGP+8) +1
C Collision
      ELSE IF (CCARD(24:24) .EQ. 'C') THEN
            JCODE = 4
            ISTORE(IFLAGP+2) = ISTORE(IFLAGP+2) +1
            GO TO 100
c Chi High
      ELSE IF (CCARD(24:24) .EQ. 'X') THEN
            JCODE = 4
            ISTORE(IFLAGP+9) = ISTORE(IFLAGP+9) +1
            GO TO 100
CDJW      ELSE
CDJW            JCODE = 4
CDJW            ISTORE(IFLAGP+5) = ISTORE(IFLAGP+5) +1
CDJW            GO TO 100
      END IF
      IF ((CCARD(27:27).NE.'*') .AND. (CCARD(27:27).NE.'0')) THEN
            JCODE = 3
            ISTORE(IFLAGP+5) = ISTORE(IFLAGP+5) +1
C           Non-equal test failed at least once,
            WRITE (CBUFFR, '(A,A,A,A,A)') 'Reflection ',
     1      CCARD(:6), ' code ', CCARD(23:28), ' Failed non-equal test '
            WRITE (ISCRN, '(1X,A)') CBUFFR
            WRITE (LISFIL, '(1X,A)') CBUFFR
      ENDIF
      IF (CCARD(25:25) .NE. '*') THEN
            WRITE (ISCRN, '(1X,A,A6,/,1X,A)') 'BALANCED FILTERS USED, re
     +flection ',CCARD(:6), 'RC93 cannot process'
            STOP
      END IF
C
C     Scan speed cannot be 0.
      IF (IBUFF1(1) .EQ. 0) THEN
            WRITE (CBUFFR,'(1X,A,A6,A,I6,A)') 'Reflection ',CCARD(:6),
     +                  ' line ', INPLIN, ' scan speed=0  IGNORED'
            WRITE (ISCRN, '(1X,A)') CBUFFR
            GO TO 9999
      END IF
C
30    CONTINUE
C     Normal data collection reflection, calculate FOBS and SIGMA
      CALL PNSIG (IBUFF1(1), IBUFF1(2), IBUFF1(3), IBUFF1(4),
     +                                                  FOBS, SIGMA)
C
C     If the peak is less than 21 ensure that the relflection is flagged
C     Weak (this comes from RC85, why 21 and would reflections with a
C     peak of <21 not be flagged Weak by CAD4 ?).
      IF (IBUFF1(3) .LT. 21) JCODE = 9
C
C     If the FOBS is negative then DO NOT reset it to FOBS = SIGMA/10.0
C     as in RC85, output it as it is.
C
C     Check if background larger on one side than the other.  First need
C     to see if the difference is significant [ie, diff > 3sig(diff)].
      DELTA = FLOAT ( IABS  ( IBUFF1(2) - IBUFF1(4) ) )
C     Poisson Statistics give that the Variance of a background = its
C     value, so  (sigma(background)**2) = (background). This is used in
C     the expression below.
      SIGDEL = SQRT ( FLOAT ( IBUFF1(2) + IBUFF1(4) ) )
      IF (DELTA .GT. 3*SIGDEL) THEN
C                                   Difference is significant.
            IF (IBUFF1(2) .GT. IBUFF1(4)) THEN
                  NLGTR = NLGTR + 1
            ELSE
                  NRGTR = NRGTR + 1
            END IF
      END IF
C     Now check for max and min scan speeds
      IF (IABS(IBUFF1(1)) .GT. MAXSP) THEN
            MAXSP = IABS(IBUFF1(1))
      ELSE IF (IABS(IBUFF1(1)) .LT. MINSP) THEN
            MINSP = IABS(IBUFF1(1))
      END IF
C     Now analyse this reflection for int/sigma. Add 1 to the total
C     no of reflns, add 1 to the appropriate bin for the range of
C     int/sigma. The bins should contain int/sigma
C           bin 1    IBIN=1       int/sig = 0.00 - 0.49
C           bin 2    IBIN=2                 0.50 - 0.99     etc
C           bin100   IBIN=100              49.5  -
      ISTORE(ISTATP) = ISTORE(ISTATP) +1
      IF (SIGMA .LE. 0) THEN
            IBIN = 1
      ELSE
            IBIN = INT ( (ABS(FOBS)/ SIGMA) * 2.0) +1
      END IF
      IF (IBIN .GT. 100) IBIN = 100
      ISTORE (ISTATP+IBIN) = ISTORE (ISTATP+IBIN) +1
C
C     The batch number IBATCH is set in the controlling routine RC93.
C
C     Check that Theta is positive, otherwise get an error in Crystals
C     (according to RC85 anyway).
      IF (THETA .LT. 0) THEN
            NEGTH = NEGTH +1
            THETA = ABS (THETA)
            WRITE (ISCRN, '(1X,A,A6)') 'NEGATIVE THETA found and correct
     +ed, reflection no. ', CCARD(:6)
      END IF
C     Now write out the line to a buffer and then to the .HKL file.
      READ (CCARD(7:21), '(3F5.0)') RINDS
      DO 1 IDJW = 1,3
        INDJW(IDJW) = NINT(RINDS(IDJW))
1     CONTINUE
      WRITE (CBUFFR, 1003) INDJW, FOBS, SIGMA, JCODE,
     +IXRAYT, IBATCH, THETA, PHIK, OMK, RKAPPA
CDJW1003  FORMAT (5X, 3F4.0, F9.0, F7.0, F4.0, F9.0, F4.0, 4F7.2)
1003  FORMAT (5X, 3I4, F9.0, F7.0, I4, I9, I4, 4F7.2)
      WRITE (IHKLFL, '(A)') CBUFFR
      NOBS = NOBS+1
      GO TO 9999
100   CONTINUE
      WRITE (CBUFFR,'(A,A6,A,A,A)') 'Reflection ',CCARD(:6),' code ',
     +                                          CCARD(23:28), ' IGNORED'
      WRITE (ISCRN, '(1X,A)') CBUFFR
      WRITE (LISFIL, '(1X,A)') CBUFFR
9999  CONTINUE
c----- get the next record
      CALL RECORD
9900  CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE REC21
C     This subroutine deals with the processing for Record 21.
C     The format is:-
C           1X, I2,    I6,     6A6,       I4, F4.1,  F4.1,  F4.1, 1X
C               21, NREFL,   TITLE,   RADIUS, SLIT, APMIN, APMAX
C     The first title is centred and output to the .LIS file.
C     The whole card is also stored in a character array of data
C     collection parameters, which will be written out neatly to the
C     .LIS file in the TIDYUP section. Records 21, 22, 26 will all be
C     in this array.
#include "RC93CM.INC"
      IF (CDTCOL(1) .EQ .CNULL) THEN
            READ (CARD1, '(A)') CDTCOL(1)
            CALL CENTRE (LISFIL, CARD1(10:46))
      END IF
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE REC22
C     This subroutine deals with the processing of Record 22.
C     The format is:-
C 1X,I2, F6.2, F6.2, F5.2, F5.2, F5.2, F5.2, I2,   F6.3,  F6.3,
C    22, Tmin, Tmax, DOMA, DOMB, APTA, APTB,     SIGPRE, SIGMA,
C
C         I2,      I4,    I2,    I2,   I2
C     NPIPRE, MAXTIME, DUMPFL, NBALF, NFRIDL
C
C     DOMA, DOMB,APTA, APTB, SIGPRE, SIGMA, MAXTIME, DUMPFL, NBALF
C     and NFRIDL will be picked out as a text string for
C     output to the .LIS and screen as a permanent record of the data
C     collection parameters ( temporarily held in a char array 62*3
C     [records 21, 22 and 26]).
#include "RC93CM.INC"
      INTEGER NPIPRE, NADD
      REAL THEMAX, THEMIN
      READ (CARD1, 1001) THEMIN, THEMAX, NPIPRE
1001  FORMAT (1X,2X, F6.2, F6.2, 5X,5X,5X,5X,2X,6X,6X, I2, 4X,2X,2X,2X)
C     IR22P is the pointer in the chained list for the beginning of data
C     from record 22.
      IF (IR22P .EQ. 1) THEN
C     This is the first rec22 to be read, set pointer and reserve space.
            IR22P = NADD(3)
            STORE (IR22P) = 0.0
            STORE (IR22P+1) = 0.0
      END IF
      IF (THEMIN .LT. STORE(IR22P))   STORE(IR22P)   = THEMIN
      IF (THEMAX .GT. STORE(IR22P+1)) STORE(IR22P+1) = THEMAX
C     The max and min values for Theta are updated as new shells are
C     encountered.
C     The value of NPIPRE is also updated as this is used in the
C     calculations of FOBS and sigma(FOBS).
C----- THIS CAUSES CHAOS IF BASE SPEED IS CHANGED DURING DATA COLLECTION
CDJW      ISTORE(IR22P+2) = NPIPRE
      ISTORE(IR22P+2) = 1
      READ (CARD1, '(A)') CDTCOL(2)
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE REC23
C     This subroutine does the processing for record 23. It checks to
C     see if the psiword has changed if a rec 23 is
C     encountered in the middle of a .DAT file (eg if a .DAT and .PSI
C     have been appended.)
C     MN2ABS indicates if a change has really occured, =0 no change,
C     =1 main 2 abs , =-1 abs 2 main.
#include "RC93CM.INC"
      IF ((LABPRO .EQ. 0) .AND. (CARD1(7:12) .EQ. 'AZIMUT')) THEN
C     There has been a change from main data to abs.profile, or this is
C     a junk record23 created during datcin.
            WRITE (ISCRN, '(1X,32X,A)') '*** WARNING ***'
            WRITE (CBUFFR, '(A,I6)') 'Change from Main Data to Absorptio
     +n Profile, Record 23 line ', INPLIN
            CALL CENTRE (ISCRN, CBUFFR)
10          CONTINUE
            WRITE (ISCRN, '(1X,A,1X,A/32X,A/32X,A)') 'Is this likely to
     +be genuine ?','Y = yes process Absorption data','N = skip and cont
     +inue', 'Q = Quit processing'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 10
            IF (CLINE(1:1) .EQ. 'N') THEN
                  WRITE (ISCRN, '(30X,A)') 'RECORD 23 IGNORED'
                  MN2ABS = 0
                  GO TO 999
            ELSE IF (CLINE(:1) .EQ. 'Y') THEN
                  MN2ABS = 1
                  LABPRO = 1
                  GO TO 999
            ELSE IF (CLINE(:1) .EQ. 'Q') THEN
                  WRITE (ISCRN, '(30X,A)') 'PROCESSING INCOMPLETE'
                  STOP
            ELSE
                  GO TO 10
            END IF
      ELSE IF ((LABPRO .EQ. 1) .AND. (CARD1(7:12) .NE. 'AZIMUT')) THEN
C           Change from abs.profile to main data.
            WRITE (ISCRN, '(1X,32X,A)') '*** WARNING ***'
            WRITE (CBUFFR, '(A,I6)') 'Change from Absorption Profile to
     +Main Data, Record 23 line ', INPLIN
            CALL CENTRE (ISCRN, CBUFFR)
20          CONTINUE
            WRITE (ISCRN, '(1X,A,1X,A/32X,A/32X,A)') 'Is this likely to
     +be genuine ?','Y = yes process Main data','N = skip and continue'
     +, 'Q = Quit processing'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 20
            IF (CLINE(1:1) .EQ. 'N') THEN
                  WRITE (ISCRN, '(30X,A)') 'RECORD 23 IGNORED'
                  MN2ABS = 0
                  GO TO 999
            ELSE IF (CLINE(:1) .EQ. 'Y') THEN
                  MN2ABS = -1
                  LABPRO = 0
                  GO TO 999
            ELSE IF (CLINE(:1) .EQ. 'Q') THEN
                  WRITE (ISCRN, '(30X,A)') 'PROCESSING INCOMPLETE'
                  WRITE (IERFIL, '(30X,A)') 'PROCESSING INCOMPLETE'
                  STOP
            ELSE
                  GO TO 20
            END IF
      ELSE
            MN2ABS = 0
      END IF
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE REC24
C     This subroutine does the processing for rec 24.  It also reads in
C     the min and max of H, K and L according to the CAD4 output (NB if
C     the data file has been altered these may be incorrect but CRYSTALS
C     works out its own HKL min and max).
C     The pointer to the start of info from rec 24 is IR24P.
#include "RC93CM.INC"
      INTEGER NADD, MINMAX(6), J
C     MINMAX = (MINH, MAXH, MINK, MAXK, MINL, MAXL)
      READ (CARD1, '(16X,3(5X, I5,I5))', ERR=10) MINMAX
      GO TO 15
10    CONTINUE
      WRITE (ISCRN, '(1X,A,I6,A)') 'Record 24, line ', INPLIN,
     +' corrupt - SKIPPED'
      WRITE (IERFIL, '(1X,A,I6,A)') 'Record 24, line ', INPLIN,
     +' corrupt - SKIPPED'
      GO TO 999
15    CONTINUE
      IF (IR24P .EQ. 1) THEN
C           This is the first rec24, load into chained list.
            IR24P = NADD (6)
            DO 20 J = 1,6
                  ISTORE(IR24P+(J-1)) = MINMAX(J)
20          CONTINUE
            GO TO 999
      ELSE
C     Compare and update min and max values.
            DO 40 J = 1, 5, 2
                 IF (MINMAX(J) .LT. ISTORE(IR24P+(J-1))) THEN
                        ISTORE(IR24P+(J-1)) = MINMAX(J)
                  END IF
40          CONTINUE
            DO 50  J = 2, 6, 2
                  IF (MINMAX(J) .GT. ISTORE(IR24P+(J-1))) THEN
                        ISTORE(IR24P+(J-1)) = MINMAX(J)
                  END IF
50          CONTINUE
      END IF
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE REC25
C     This is a do-nothing subroutine for the time being.
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE REC26
C     This subroutine copies each record 26 into the character array
C     CDTCOL which will be output neatly by the TIDYUP section.
C     It also sets RCON2 for absorption profile processing.
#include "RC93CM.INC"
      READ (CARD1(45:54), '(F10.7)') RCON2
      CDTCOL (3) = CARD1(:62)
      RETURN
      END
C
C***********************************************************************
c^
C
      SUBROUTINE RECORD
#include "RC93CM.INC"
      CHARACTER *64 CTEMP
C----- RECORD NOT YET IDENTIFIED
      IREC = 0
      CARD1 = ' '
      CARD2 = ' '
100   CONTINUE
      I = KINLIN(CTEMP)
      IF ( I .LT. 0) GOTO 1000
150   CONTINUE
      CARD1 = CTEMP
cdjwfeb2000
      READ(CTEMP,'(1X,2I1)',err=1000) JREC, KREC
      IREC = 10*JREC+KREC
      IF ((KREC .EQ. 1) .AND. ((JREC .EQ. 0) .OR. (JREC .EQ. 3)))THEN
C-----      a RECORD TYPE X1 - LOOK FOR RECORD X2
            IF ( KINLIN (CTEMP) .LT. 0) GOTO 1000
            READ(CTEMP,'(1X,2I1)',err=1000) JREC, KREC
C-----      IS THIS A RECORD X2?
            IF ((KREC .EQ. 2) .AND. ((JREC .EQ. 0) .OR. (JREC .EQ. 3)))
     1      THEN
                  IREC = 10*JREC + KREC
                  CARD2 = CTEMP
                  GOTO 1000
           ENDIF
C-----      ERROR
            WRITE(ISCRN,151)
            WRITE(LISFIL,151)card1,ctemp
151   format(
     1 'Record x1 not followed by record x2 - ftp should be in bin mode'
     2 , /a/a/)
            GOTO 150
      ENDIF
1000  CONTINUE
      RETURN
      END
C**********************************************************************
      INTEGER FUNCTION KINLIN(CARD)
C----- READ A LINE, STRIP OUT SPURIOUS CHARACTERS, AND REJECT EMPTY
C      LINES
#include "RC93CM.INC"
      CHARACTER *(*) CARD
      nchar = len(card)
      KINLIN = -1
      KERR = 0
      INPLIN = INPLIN+1
200   CONTINUE
      card = ' '
      READ (INPFIL, CFORMT, IOSTAT= KERR, ERR=400, END=400) CARD(1:64)
cnov98 - fix for ftp bin and ftp text differences
c look for last real character
      do 2 j = 64, 60,-1
      if ((card(j:j) .eq. ' ') .or. (card(j:j) .eq. char(13))) goto 3
      goto 4
3     continue
2     continue
4     continue
      j = j
cnov      write(iscrn,'('' index='',i4)') j
cnov      write(lisfil,'('' index='',i4,'':'',a)') j, card
      if ((j .ne. 0) .and. ( j .ne. 61)) then
c--- move all along
        k = 61-j
        if (k .gt. 0) then
         do 10 i=j,1,-1
            card(i+k:i+k) = card(i:i)
10       continue
         card(1:k) = ' '
        else
          do 11 i=1,j,1
            card(i:i) = card(i+k:i+k)
11        continue
          card(j:nchar) = ' '
        endif
      endif
cdjw reject lines not beginning with a space
      if (card(1:1) .ne. ' ') then
            write(lisfil,'(a,a)')'Rejected:', card(1:64)
            goto 200
      endif
      DO 250 I = 1,LEN(CARD)
         IF ((ICHAR(CARD(I:I)).LE.31) .OR. (ICHAR(CARD(I:I)).GE.127) )
     1   CARD(I:I) = ' '
250   CONTINUE
      DO 300 J = LEN(CARD),1,-1
cnov98^^            IF (CARD(J:J) .NE. ' ') GOTO 350
       if ((card(J:J) .ne. ' ') .and. (card(j:j) .ne. char(13)))
     1  goto 350
300   CONTINUE
C----- NOTHING ON THIS CARD - TRY AGAIN
      GOTO 200
350   CONTINUE
      KINLIN = 1
400   CONTINUE
      RETURN
      END
c***********************************************************************
C
      SUBROUTINE REFDMP
C     This subroutine deals with the processing of the refdump.
C     NREFDP is the number of refdumps encountered, only want to output
C     the first to the .LIS file.
#include "RC93CM.INC"
      INTEGER NADD
      REAL THETA
      IF (NREFDP .GT. 0) THEN
            CALL RECORD
            GO TO 999
      END IF
      WRITE (LISFIL, '(/1X, ''Contents of the refdump:-'')')
      IF (L30P .EQ. 1) L30P = NADD(15)
      STORE (L30P+3) = 0.0
      STORE (L30P+4) = 78.0
      STORE (L30P+5) = 0.0
10    CONTINUE
      CALL CENTRE (LISFIL, CARD1(:LENSTR(CARD1)) )
C     The reflection status codes can be used to estimate how
C     many reflections were used for orientation
C     and the max, min theta values for orientation.  This is done for
C     ONE refdump so the defaults offered for List 30 will relate to
C     the FIRST refdump only.
C     NB depending upon the orientation status, some of the refdump
C     may be missing (O-status = '*' are usually missing).
C     O-status O or R are used for orientation control/checking.
      IF ((CARD1(18:18) .EQ. 'O') .OR. (CARD1(18:18) .EQ. 'R')) THEN
            READ (CARD1, '(20X,F6.2)') THETA
            STORE (L30P+3) = STORE(L30P+3) +1
            IF (THETA .LT. STORE (L30P+4)) THEN
                  STORE (L30P+4) = THETA
            ELSE IF (THETA .GT. STORE (L30P+5)) THEN
                  STORE (L30P+5) = THETA
            END IF
            NREFDP = NREFDP+1
      END IF
      CALL RECORD
      IF (KERR .NE. 0) GOTO 999
      IF (IREC .NE. 0) THEN
C           Not a refdump record, return.
            GOTO 999
      END IF
C     Another refdump record.
      GO TO 10
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE SCANER
C     This routine does a quick scan down the .DAT or .PSI file to look
C     for the AZIMUT or lack of it on record 23 (the PSIWORD in the
C     CAD4 book).
C     If the psiword is AZIMUT then the following data is for an
C     absorption profile, otherwise it is the main reflection data.
C     The flag for abs profile or not is the variable LABPRO (=0 main
C     data, =1 abs profile data).
#include "RC93CM.INC"
      CHARACTER*6 CPSIWD
      CFORMT = '(A64)'
      REWIND (INPFIL)
      n = len(cline)
      mark = 0
      labpro = 0
      i = 0
20    CONTINUE
      i = i + 1
cnov98      CALL READLN (INPFIL)
      cline = ' '
      read (unit=inpfil, fmt='(a)') cline
      do 21 j = 1,n
       if ((cline(J:J) .ne. ' ') .and. (cline(j:j) .ne. char(13)))
     1  goto 22
21    continue
      goto 20
22    continue
      IF (KERR .NE. 0) GO TO 30
cnov98 - patch for ftp
      j = index(cline, 'AZIMUT')
      if (j .ne. 0) then
            labpro = 1
            goto 10
      endif
      j = index(cline, 'BISECT')
      if (j .ne. 0) then
            labpro = 0
            goto 10
      endif
10    continue
      if (j .eq. 0) goto 20
      write(iscrn,'(i3,''scanner index='',i4,'':'',a)') i,j, cline
      write(lisfil,'(i3,''scanner index='',i4,'':'',a)') i,j, cline
      if (j .eq.6) then
            mark = 1
            cformt = '(A64)'
      else if(j .eq. 7) then
            mark = 2
ctemp            cformt = '(1X,A64)'
            cformt = '(A64)'
      else if (j .eq. 8) then
            mark = 2
            cformt = '(1X,A64)'
      endif
      if (mark .ne. 0) then
      write(iscrn,'(''Machine type'',i4,'' Format '',a)') mark,cformt
      write(lisfil,'(''Machine type'',i4,'' Format '',a)') mark,cformt
            goto 50
      endif
      goto 30
cnov98 end
      IF (CLINE (1:2) .EQ. '23 ') THEN
C     This record 23 is from a CAD4 mark 1.
            CFORMT = '(A64)'
            MARK = 1
            GO TO 50
      else IF (CLINE (2:3) .EQ. '23 ') THEN
C     This record 23 is from a CAD4 mark 1.
            CFORMT = '(A64)'
            MARK = 1
            GO TO 50
      ELSE IF (CLINE(3:4) .EQ. '23') THEN
C     This record 23 is from the mark 2 CAD4.
            CFORMT = '(1X,A64)'
            MARK = 2
            GO TO 50
      ELSE
            GO TO 20
      END IF
30    CONTINUE
C     If we get here then either no record 23 has been found or there
C     has been an error reading from the file, and the program cannot
C     continue.
      WRITE (ISCRN, '(/,1X,A,/,1X,A)') 'ERROR - could not locate a recor
     +d 23 in the input file ', CINPFL(:LENSTR(CINPFL))
      WRITE (ISCRN, '(1X,A)') 'Please check this file.'
      WRITE (ISCRN, '(//,22X,A)')'PROGRAM STOPS : PROCESSING INCOMPLETE'
      WRITE (IERFIL,'(/,1X,A,/,1X,A)')'ERROR - could not locate a recor
     +d 23 in the input file ', CINPFL(:LENSTR(CINPFL))
      WRITE (IERFIL, '(1X,A)') 'Please check this file.'
      WRITE (IERFIL,'(//,22X,A)')'PROGRAM STOPS : PROCESSING INCOMPLETE'
      STOP
50    CONTINUE
C     Now have the correct format and record 23 so search for AZIMUT.
      write(iscrn,'(''Format '',a)') cformt(1:8)
cnov98      READ (CLINE, CFORMT) CARD1(1:64)
cnov98C           TEMPORARY MEASURE REMOVE LATER ON
cnov98      IF (CARD1(1:3) .NE. ' 23') THEN
cnov98            WRITE (ISCRN, '(1X,A)') 'ERROR CHECKING RECORD 23, FORMAT FO
cnov98     +R THE MARK 1/2 IS WRONG'
cnov98      END IF
C           END OF TEMPORARY MEASURE
cnov98      READ (CARD1, '(6X, A6)') CPSIWD
cnov98      IF (CPSIWD .EQ. 'AZIMUT') THEN
cnov98            LABPRO = 1
cnov98      ELSE
cnov98            LABPRO = 0
cnov98      END IF
C     No check for invalid psiwords.
C     Now we know the correct format (ie, mark 1 or 2) and whether
C     absorption profile or main data.
      REWIND (INPFIL)
      MN2ABS = 0
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE SGROUP
C     This subroutine writes out a #SPACEGROUP instruction to the .SCF.
#include "RC93CM.INC"
10    CONTINUE
      WRITE (ISCRN, '(/1X,A,A)') 'Please give the spacegroup',
     +'(eg. P 21 21 21):-'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 10
      IF (CLINE .EQ. CNULL) THEN
            GO TO 10
      ELSE IF (CLINE .EQ. 'QUIT') THEN
            KERR = 100
            GO TO 999
      ELSE
C***********  NB  No check for rubbish spacegroup   *******
            WRITE (ISCFFL, '(''#SPACEGROUP'')')
            WRITE (ISCFFL, '(''SYMBOL '',A)') CLINE(:LENSTR(CLINE))
            WRITE (ISCFFL, '(''END'')' )
            GO TO 999
      END IF
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE TIDYUP
C     This routine does all of the sorting out when no more files are to
C     be processed.
#include "RC93CM.INC"
      INTEGER NOPR, MAXIN(10), ITHETA
      CHARACTER*15 CINDEX(10)
      IF (CDTCOL(1)(10:46) .EQ. ' ') THEN
5           CONTINUE
            WRITE (ISCRN, '(1X,A)') 'Title for your structure?'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 5
            IF (CLINE .EQ. CNULL) THEN
                  GO TO 5
            ELSE
                  WRITE (ISCFFL, '(''#TITLE '',A)') CLINE
            END IF

      ELSE
            WRITE (ISCFFL, '(''#TITLE '',A)') CDTCOL(1)(10:46)
      END IF
      IF (MOD(NRUNS, 100) .EQ. 0) THEN
C           Have not read in a main data file.
            GO TO 100
      END IF
      KERR = 0
      CALL L1N13
      CALL SGROUP
      IF (KERR .EQ. 0) CALL COMP
C     Can only have a #COMPOSITION instruction if we have a #SPACEGROUP.
      CALL LIST31
      CALL LIST30
      CALL LIST27
      CALL WRL30
      CALL WRLIS
100   CONTINUE
1250  CONTINUE
         IF (STORE(L30P+11) .GT. 0. ) GOTO 1100
1200    WRITE (ISCRN,25)
25      FORMAT (/1X,' Enter mu for your crystal (QUIT if unknown):')
CPML
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 1200
      IF (CLINE .EQ. 'QUIT') THEN
            STORE(L30P+11) = 0.001
            GO TO 1100
      ELSE
            READ (CLINE, *, ERR=1200) STORE(L30P+11)
            IF (STORE(L30P+11) .LT. 0.0) THEN
                WRITE (ISCRN, '(1X,A)') 'mu*R MUST be positive'
                WRITE (IERFIL, '(1X,A)') 'mu*R MUST be positive'
                GO TO 1200
           ENDIF
      END IF
1100  CONTINUE
      WRITE (ISCRN, '(/)')
C     The line above used to clear the screen.
      IF (NINT(STORE(L30P+11)*1000) .EQ. 0) THEN
            CALL CENTRE (ISCRN, 'No spherical absorption correction')
            GO TO 120
      END IF
      WRITE (ISCRN, '(/1X,A)')
     +    'A theta dependent absorption correction has been applied'
      IF (STORE(L30P+12) .GE. 2.0) THEN
          WRITE (ISCRN,'(/1X,A,/40X,A,F8.2)')
     +    'WARNING - highly differing absorption',
     +    'I(min dimension) : I(max dim) = ',
     +    STORE (L30P+12)
          CALL CENTRE (ISCRN, 'Use DIFABS during your refinement to comp
     +ensate for this')
      END IF
120   CONTINUE
      IF (NINT(NRUNS/100.0) .GT. 0) THEN
C           Have read in an abs profile, set ITHETA=3, ie apply both
C           psi and theta corrections.
            CALL ABSFIT (NOPR, CINDEX, MAXIN, 3)
            ITHETA = 3
            CALL ABSOUT (NOPR, CINDEX, MAXIN, 3)
      ELSE
C           Have only read in intensity data, apply theta dependant
C           absorption correction.
            ITHETA = 2
            CALL ABSOUT (NOPR, CINDEX, MAXIN, 2)
      END IF
C
      IF (ABS(STORE(L30P+8)) .GE. 10.0) THEN
            WRITE (ISCRN, '(/1X,A,A,F6.1,A)') 'WARNING - Intensity',
     +' standard decay of ', STORE(L30P+8), ' %'
            WRITE (IERFIL, '(/1X,A,A,F6.1,A)') 'WARNING - Intensity',
     +' standard decay of ', STORE(L30P+8), ' %'
      END IF
C
      WRITE (ISCFFL, '(''#USE LAST'')' )
      CLOSE (ITMPFL, STATUS='DELETE')
      CLOSE (ISCFFL)
      PRINT *,' MAX POINTER = ', (NFREEP-1)
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE WRL30
C     This writes out the #LIST 30 instruction to the .SCF file.
#include "RC93CM.INC"
      INTEGER ITEMP, IPNTP
      REAL TEMP
      WRITE (ISCFFL, '(''#LIST 30'')' )
      WRITE (ISCFFL, '(''CONDITION'')' )
1001  FORMAT ('CONT', 1X, A20, '=', 1X, F12.6)
      WRITE (ISCFFL, 1001) 'MINSIZE', STORE (L30P)
      WRITE (ISCFFL, 1001) 'MEDSIZE', STORE (L30P+1)
      WRITE (ISCFFL, 1001) 'MAXSIZE', STORE (L30P+2)
      WRITE (ISCFFL, 1001) 'NORIENT', STORE (L30P+3)
      WRITE (ISCFFL, 1001) 'THORIENTMIN', STORE (L30P+4)
      WRITE (ISCFFL, 1001) 'THORIENTMAX', STORE (L30P+5)
      WRITE (ISCFFL, 1001) 'TEMPERATURE', STORE (L30P+6)
C      WRITE (ISCFFL, '(A)') 'CONT INSTRUMENT = CAD4' 
C     The number of standards is calculated automatically, as is the
C     percentage decay of the standards.
      IF (ISTDSP .EQ. 1) THEN
C           There are no standards.
            STORE (L30P+7) = 0.0
            STORE (L30P+8) = 0.0
            GO TO 200
      END IF
      IPNTP = ISTDSP
      ITEMP = 0
100   CONTINUE
      ITEMP = ITEMP+1
      IF (ISTORE (IPNTP) .EQ. 0) THEN
            STORE (L30P+7) = ITEMP
            GO TO 120
      ELSE
            IPNTP = ISTORE(IPNTP)
            GO TO 100
      END IF
120   CONTINUE
C     Percentage decay of the standards is estimated by
C      100*(1-( scalefactor of first group (xrayt=0)/ sf of last group))
C     ***!! This is not an ideal way of doing it !!***
      TEMP = STORE (IGSCFP+1)
      IPNTP = IGSCFP
130   CONTINUE
      IF (ISTORE(IPNTP) .EQ. 0) THEN
C           This is the last group scale factor.
            TEMP = 100.0 * ( 1.0-(TEMP / STORE (IPNTP+1)) )
            STORE (L30P+8) = TEMP
            GO TO 200
      ELSE
            IPNTP = ISTORE(IPNTP)
            GO TO 130
      END IF
200   CONTINUE
      WRITE (ISCFFL, 1001) 'STANDARDS', STORE (L30P+7)
      WRITE (ISCFFL, 1001) 'DECAY', STORE (L30P+8)
C----- GET THE STANARD INTERVAL
      READ(CDTCOL(3)(5:10),'(I6)') LTIME
      WRITE (ISCFFL, '(A,I6)') '# CONT     INTERVAL= ', LTIME/60
C
      WRITE(ISCFFL,'(A)') 'CONT SCANMODE= 2THETA/OMEGA'
      WRITE(ISCFFL,'(A)') 'CONT INSTRUMENT=MACH3'
C
C
      WRITE (ISCFFL, '(''INDEXRAN'')' )
1002  FORMAT ('CONT', 1X, A20, '=', 1X, I6)
      WRITE (ISCFFL, 1002) 'HMIN', ISTORE(IR24P+0)
      WRITE (ISCFFL, 1002) 'HMAX', ISTORE(IR24P+1)
      WRITE (ISCFFL, 1002) 'KMIN', ISTORE(IR24P+2)
      WRITE (ISCFFL, 1002) 'KMAX', ISTORE(IR24P+3)
      WRITE (ISCFFL, 1002) 'LMIN', ISTORE(IR24P+4)
      WRITE (ISCFFL, 1002) 'LMAX', ISTORE(IR24P+5)
      WRITE (ISCFFL, 1001) 'THETAMIN', STORE (IR22P+0)
      WRITE (ISCFFL, 1001) 'THETAMAX', STORE (IR22P+1)
C
      WRITE (ISCFFL, '(''GENERAL'')' )
      WRITE (ISCFFL, 1001) 'DOBS', STORE (L30P+9)
      WRITE (ISCFFL, 1001) 'DCALC', STORE (L30P+10)
      WRITE (ISCFFL, 1001) 'MU', STORE (L30P+11)
      WRITE (ISCFFL, 1001) 'MOLWT', STORE (L30P+13)
      WRITE (ISCFFL, 1001) 'Z', STORE (L30P+14)
      WRITE (ISCFFL, '(''COLOUR'', 14X, A)' ) COLOUR(:LENSTR(COLOUR))
      WRITE (ISCFFL, '(''SHAPE'', 15X, A)' ) CSHAPE(:LENSTR(CSHAPE))
C
      WRITE (ISCFFL, '(''DATRED'', 15X, A)' ) 'REDUCTION = RC93'
      WRITE (ISCFFL, '(''END'')' )
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE WRLIS
C     This routine writes out some statistics and other information
C     about the data to the .LIS file, and writes the more important
C     to the screen.
#include "RC93CM.INC"
      INTEGER J, I, NSTARS, MAXBIN, ICOUNT
      INTEGER JGSCFP, LT3SIG
      INTEGER IREFP, IMEASP
      REAL BLIM, ULIM, PERCNT
      REAL PRGTR, PLGTR, RMINSP, RMAXSP, DECAY
      IF (NRUNS .EQ. 0) GO TO 999
C
C     Write out cell param's and esd's to the .LIS file.
      WRITE (LISFIL, '(/1X,''Cell Parameters:'')')
      WRITE (LISFIL, '(6X,5X,A,8X,A,8X,A, 6X,A,5X,A,5X,A,9X,A)') 'a',
     + 'b', 'c', 'Alpha', 'Beta', 'Gamma', 'Volume'
      WRITE (LISFIL,'(6X,3(2X,F7.4),3(1X,F8.4),  2X,F15.4)')
     1 (STORE(ICELLP+I), I=0,6)
      WRITE (LISFIL,'(1X,A, 3(2X,F7.4),3(1X,F8.4) )')
     + 'Esd''s', (STORE(IESDSP+I), I=0,5)
      WRITE (LISFIL, '(/1X,''Crystals Cell Parameters'')')
      WRITE (LISFIL,'(6X,3(2X,F7.4), 3(1X,F8.4), 2X,F15.4)')
     1 (STORE(NWCELP+I), I=0,6)
C
C     Write out info about the crystal.
      ICOUNT = 0
      DO 48 I=1,80
            IF (NATOMS(I) .NE. 0) ICOUNT= ICOUNT+1
48    CONTINUE
      WRITE (LISFIL, '(/1X,A,23X,80(A2,I3,3X))') 'Molecular formula',
     +       (CATOMS(I)(:LENSTR(CATOMS(I))), NATOMS(I), I=1,ICOUNT)
      WRITE (LISFIL, '(1X,A,24X, F10.4)' ) 'Molecular weight',
     +                                                 STORE(L30P+13)
      WRITE (LISFIL, '(1X,A,21X,2(F4.2,A),F4.2)')
     +      'Crystal dimensions (mm)',STORE(L30P),' x ',STORE(L30P+1),
     +                                           ' x ', STORE (L30P+2)
      WRITE (LISFIL, '(1X,A,15X, I3)') 'Z (molecules per unit cell)',
     +                                          NINT(STORE(L30P+14))
      WRITE (LISFIL, '(1X,A,12X,F10.4)')'Calculated density (g/cm**3)',
     +                                          STORE (L30P+10)
      WRITE (LISFIL, '(1X,A,8X,F10.4)')
     +  'Linear absorption coeff (cm**-1)', STORE(L30P+11)
      WRITE (LISFIL, '(1X,A,40X,F4.2)') 'mu*R',
     +                         (STORE(L30P+11) * STORE(L30P) / 20.0)
C
C     Now write out some data collection conditions.
      WRITE (LISFIL, '(/1X,A,F9.6/18X,A,F9.6 )')
     + 'Radiation        lambda(1) = ', STORE(MINITP+10),
     + 'lambda(2) = ', STORE(MINITP+11)
      WRITE (LISFIL, '(1X,A,9X,F5.2,A,F5.2)') 'Theta range ',
     +                   STORE (IR22P), ' to ', STORE (IR22P+1)
      WRITE (LISFIL, 2002) (ISTORE(IR24P+J), J=0,5)
2002  FORMAT (1X,'Index ranges',7X,'H  ',I3,' to ',I3/20X,'K  ',
     +I3,' to ', I3/20X,'L  ',I3,' to ',I3)
      WRITE (LISFIL, '(1X,A,9X,I4)') 'No. of reorientations',
     +                                               ISTORE(MINITP)
      WRITE (LISFIL, '(1X,A,15X,F6.2)') 'Temperature (K)',
     +                                                STORE(L30P+6)

C     The scan width in DATCIN is 2/3 of the actual value.
      WRITE (LISFIL, 2005)      CDTCOL(2)(16:20), CDTCOL(2)(21:25)
C     These values are in rec 22   DOMA              DOMB
2005  FORMAT (1X, 'Omega-Scan width (degrees)', 5X, A, ' +', A,
     +' *tan (Theta)', /32X, '(+25% either side for background)')
C
      WRITE (LISFIL, 2006) CDTCOL(2)(26:30), CDTCOL(2)(31:35)
C     These values come from rec22 APTA            APTB
2006  FORMAT (1X, 'Horizontal aperture (mm)', 7X, A, ' +', A,
     +' *tan (Theta)')
C
      WRITE (LISFIL,2007) CDTCOL(1)(54:57), CDTCOL(1)(58:61)
C     These values come from rec21    APMIN        APMAX
2007  FORMAT (1X, 'Minimum aperture',15X, A/1X,
     + 'Maximum aperture', 15X, A)
C     Nb motor speeds are probably machine dependent. ***!!***
C     Nb a higher speed number denotes a SLOWER speed
      RMINSP = 20.1166 / MAXSP
      RMAXSP = 20.1166 / MINSP
      WRITE (LISFIL, 2008) RMINSP, RMAXSP
2008  FORMAT (1X, 'Minimum scan speed', 13X, F4.1, /, 1X,
     +'Maximum scan speed', 13X, F4.1, ' (degrees/min)')
C
C     Write out info about intensity standards.
      IF (ISTDSP .EQ. 1) THEN
C           Haven't got any intensity standards.
            GO TO 75
      END IF
      WRITE (LISFIL, '(1X,A,4X,I3)') 'No. of intensity standards',
     +                                   NINT(STORE(L30P+7))
      WRITE (LISFIL, '(1X,A,10X,F5.1,A)') 'Decay of standards',
     +                  STORE (L30P+8), '%'
      WRITE (LISFIL, '(/)')
CDJWDEC99 THE WRITING IS DONE AS THE SMOOTHING PROCEEDS
C      CALL CENTRE (LISFIL, 'SCALE FACTORS CALCULATION')
      JGSCFP = IGSCFP
C      WRITE (LISFIL, '(20X,A,4X,A,3X,A,4X,A/)') 'Serial', 'Raw',
C     +                   'Smoothed', 'X-ray time'
C      DO 55 J=0, NUMGSF-1
C            WRITE (LISFIL, 1007) J, STORE(JGSCFP+1), STORE(JGSCFP+2),
C     +                                                  ISTORE(JGSCFP+3)
C1007        FORMAT (19X,I5, 2(3X, F7.3), 6X, I7)
C            JGSCFP = ISTORE (JGSCFP)
C55    CONTINUE
CC     Write out the decay of each standard reflection.
      WRITE (LISFIL, '(/1X,A)') 'Intensity standard variation:-'
      WRITE (LISFIL, '(/12X,A,4X,A,4X,A,4X,A,6X,A)') 'H', 'K', 'L',
     +                               'Psi', 'Decay'
      IREFP = ISTDSP
C     This is a DO-WHILE(pointer to next reflection .ne. 0) loop
60    CONTINUE
      IF (IREFP .EQ. 0) THEN
            GO TO 75
      ELSE
C           Find the last weighted intensity measurement of this
C           standard.
            IMEASP = ISTORE(IREFP+2)
            DO 65 J=1, (ISTORE(IREFP+1)-1)
                  IF (IMEASP .EQ. 0) STOP 'ERROR IN WRLIS'
                  IMEASP = ISTORE (IMEASP)
65          CONTINUE
C           Weighted scale factor(i) = I(0) * weight/ I(i)
C           %decay = [1-(weight/final weighted sf)]*100
C           This is not an ideal way of calculating the decay as it uses
C           only the first(estimated) and last values of the curve, but
C           it is the as the same method used for the overall decay.
            DECAY = (1 - (STORE(IREFP+7) / STORE(IMEASP+2)) ) *100.0
            WRITE (LISFIL, '(10X,3(I3,2X),F5.1,5X,F5.1,A)')
     +            (ISTORE(IREFP+J), J=3,5), STORE(IREFP+6), DECAY, '%'
            IREFP = ISTORE(IREFP)
            GO TO 60
      END IF
75    CONTINUE
C
C      Now write out info about the reflections.
      PRGTR = NRGTR*100.0 / NOBS
      PLGTR = NLGTR*100.0 / NOBS
      LT3SIG = 0
      DO 80 J=1,6
            LT3SIG = LT3SIG + ISTORE(ISTATP+J)
80    CONTINUE
      WRITE (LISFIL, '(/)')
      WRITE (LISFIL,1001) NOBS, ' Reflections written to .HKL file'
      WRITE (LISFIL,1002) PRGTR,'% of these had background Left < Right'
      WRITE (LISFIL,1002) PLGTR,'% of these had background Left > Right'
      WRITE (LISFIL, 1002) (LT3SIG*100.0/ISTORE(ISTATP)), '% had an inte
     +nsity < 3 Sigma'
      WRITE (LISFIL,1001) NEGTH, ' Negative Theta values corrected'
      WRITE (LISFIL, '(/,1X,A)') 'Reflections flagged:-'
      WRITE (ISCRN, '(/,1X,A)') 'Reflections flagged:-'
      WRITE (LISFIL,'(1X, 8(A6,2X), A6)') 'N*****', '*C****', '***S**',
     +'***T**', 'Other ', 'S*****', '***W**', '*D****', '*X****'
      WRITE (ISCRN,'(1X, 8(A6,2X), A6)') 'N*****', '*C****', '***S**',
     +'***T**', 'Other ', 'S*****', '***W**', '*D****', '*X****'
      WRITE (LISFIL, '(1X, 8(I6,2X), I6)') (ISTORE(IFLAGP+J),J=1,9)
      WRITE (ISCRN, '(1X, 8(I6,2X), I6)') (ISTORE(IFLAGP+J),J=1,9)
1001  FORMAT (10X,1X, I6, A)
1002  FORMAT (10X, F6.1, A)
C
C     Write out to .LIS the variation of int/sigma.
      MAXBIN = 0
      DO 90 J=1,100
            IF (ISTORE(ISTATP+J) .GT. MAXBIN) MAXBIN=ISTORE(ISTATP+J)
90    CONTINUE
      WRITE (LISFIL,'(//)')
      CALL CENTRE (LISFIL, 'DISTRIBUTION OF INTENSITY WITH SIGMA')
      WRITE (LISFIL, '(/3X,A9,4X,A3,3X,A1)') 'Int/Sigma', 'No.', '%'
      DO 100 J=1, 100
            BLIM = (J-1)*0.50
            ULIM = BLIM +0.49
            PERCNT = ISTORE(ISTATP+J) *100.0 / ISTORE(ISTATP)
            NSTARS = NINT (54.0*ISTORE(ISTATP+J)/MAXBIN)
            IF (NINT(ULIM*100.0) .EQ. 4999) THEN
                  WRITE (LISFIL, 1004) BLIM, ISTORE(ISTATP+J),
     +                             NINT(PERCNT), ('*', I=1,NSTARS)
            ELSE
                  WRITE (LISFIL, 1005) BLIM, ULIM, ISTORE(ISTATP+J),
     +                             NINT(PERCNT), ('*', I=1,NSTARS)
            END IF
1004  FORMAT (1X,F5.2, '-',  5X , 2X,I4,2X,I3, 2X, 55A1)
1005  FORMAT (1X,F5.2, '-', F5.2, 2X,I4,2X,I3, 2X, 55A1)
100    CONTINUE
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      INTEGER FUNCTION ICHKFL (IUNIT, CFILNM)
C     This function checks whether a file CFILNM exists or
C     not, before attempting to open it. ICHKFL=0 if it exists, and
C     should not be overwritten, ICHKFL=1 if it may be overwritten or
C     doesn't exist.
C     If the file is already open it issues warnings and stops.
C     If the file does exist AND the flag LOVRWR=1 then no prompt is
C     given before opening a new version, otherwise a prompt is given.
C     [ LOVRWR is set by the .INI file or by the user and indicates
C     whether or not to prompt before opening a version of a file which
C     already exists.  This will allow VMS users to avoid the prompt
C     which is unnecessary because VMS will not overwrite the existing
C     file but will simply make a higher version of it.]
#include "RC93CM.INC"
      INTEGER IUNIT, NUNIT, LEN
      CHARACTER*80 CFILNM
      LOGICAL LOGEX, LOGOPN
      LEN = LENSTR (CFILNM)
      INQUIRE (FILE= CFILNM, ERR= 30, EXIST= LOGEX, OPENED=LOGOPN, NUMBE
     +R= NUNIT)
      IF (LOVRWR .EQ. 1) THEN
C     No need to check if it exists, it will be overwritten anyway.
            ICHKFL = 1
            GO TO 20
      ELSE IF (LOGEX) THEN
            WRITE (ISCRN, '(1X,A,A)') 'WARNING - The file ',
     +                               CFILNM(:LEN), ' already exists.'
10          CONTINUE
            WRITE (ISCRN,'(/,1X,A)')'Do you wish to overwrite it (y/n)?'
            WRITE (ISCRN, '(1X,A)') '[ALL will overwrite all existing ou
     +tput files with this base]'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 10
            IF (CLINE(1:1) .EQ. 'Y') THEN
                  ICHKFL = 1
            ELSE IF (CLINE(1:1) .EQ. 'N') THEN
                  ICHKFL = 0
            ELSE IF (CLINE(1:3) .EQ. 'ALL') THEN
                  ICHKFL = 1
                  LOVRWR = 1
            ELSE IF (CLINE(1:4) .EQ. 'HELP') THEN
                  CALL HELP
            ELSE
                  GO TO 10
            END IF
      ELSE
C     The file doesn't exist, but prompts are desired, so we need to set
C     ICHKFL to 1
            ICHKFL = 1
      END IF
20    CONTINUE
      IF (LOGOPN) THEN
            WRITE (ISCRN, '(1X, A, A, A, I4, A, I4)') 'PROGRAMMING ERROR
     +- The file ', CFILNM(:LEN), ' about to be opened onto unit ',
     +IUNIT, ' is already connected to unit ', NUNIT
            WRITE (IERFIL, '(1X,A,A,A,I4,A,I4)') 'PROGRAMMING ERROR
     +- The file ', CFILNM(:LEN), ' about to be opened onto unit ',
     +IUNIT, ' is already connected to unit ', NUNIT
            STOP
      END IF
      GO TO 50
30    CONTINUE
      WRITE (ISCRN, '(1X,A,A,A,I4)') 'ERROR trying to INQUIRE on file ',
     +                  CFILNM(:LEN), 'about to connect to unit ',IUNIT
      WRITE (IERFIL,'(1X,A,A,A,I4)')'ERROR trying to INQUIRE on file',
     +             CFILNM(:LEN), 'about to connect to unit ',IUNIT
      STOP
50    RETURN
      END
C
C***********************************************************************
C
C     This function determines the useful length of a partially filled
C     character string.
      INTEGER FUNCTION LENSTR (CSTRIN)
      CHARACTER*(*) CSTRIN
      INTEGER J
      LENSTR = 0
      DO 20 J= LEN(CSTRIN), 1, -1
            IF (CSTRIN(J:J) .NE. ' ') THEN
                  LENSTR= J
                  GO TO 30
            END IF
20    CONTINUE
30    CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      INTEGER FUNCTION LSTCHR (CINPFL)
C     This function finds the base of a path and filename specification.
C     It has to be able to cope with path specifications from DOS, Unix
C     and VMS and will possibly need altering for other operating
C     systems.
      CHARACTER*(*) CINPFL
      CHARACTER*1 CH
      INTEGER J, LEND, IDOT, LENSTR
      LEND = LENSTR(CINPFL)
C     Find the rightmost '.'
      DO 20 J= LEND, 1, -1
            IF (CINPFL(J:J) .EQ. '.') THEN
                  IDOT = J
                  GO TO 30
            END IF
20    CONTINUE
C     Only get here if no '.' in the input, in this case there is no
C     extension on the input file.
      LSTCHR = LEND
      GO TO 999
C
30    CONTINUE
C     If we get here then there is a '.' in the input, need to check if
C     it is part of the path.
      DO 40 J= IDOT+1, LEND
            CH = CINPFL(J:J)
C *** Annoyingly the backslash may have to be 'escaped' for unix
C     machines, ie the line for unix machines is
#if defined (CRY_GNU)
      IF (((CH .EQ.'/').OR.(CH .EQ.'\\')) .OR.(CH .EQ. ']')) THEN
#else
      IF (((CH .EQ.'/').OR.(CH .EQ.'\')) .OR.(CH .EQ. ']')) THEN
#endif
C                 The '.' is part of the path specification.
                  LSTCHR = LEND
                  GO TO 999
            END IF
40    CONTINUE
C     Get here if the '.' is the extension marker.
      LSTCHR = IDOT-1
      GO TO 999
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      INTEGER FUNCTION NADD (ITEMS)
C     This function returns NADD with the starting pointer for the set
C     of items ITEMS and reserves space in the chained list for the
C     items.  ITEMS must be large enough to account for things which
C     need eg,3 spaces for each 'item'.
#include "RC93CM.INC"
      INTEGER ITEMS
      IF (NMAXP .LE. (NFREEP+ITEMS)) THEN
            WRITE (ISCRN, '(''ERROR - Chained list too short.'')')
            WRITE (IERFIL, '(''ERROR - Chained list too short.'')')
            STOP
      ELSE
            NADD = NFREEP
            NFREEP = NFREEP + ITEMS
      END IF
      RETURN
      END
C
C***********************************************************************
C
CODE FOR MTRNLG
      SUBROUTINE MTRNLG(FILNAM,STATUS,LENNAM)
C
C----- EXPAND LOGICAL NAMES (ENVIRONMENT VARIABLES) IF THEY
C      ARE PART OG THE FILE NAME.
C
C      CODE BY MARTIN KRETSCHMAR, TUBINGEN, 1991
C
C FILNAM CONTAINS THE OLD FILE NAME AND WILL PASS BACK THE NEW ONE.
C
C STATUS IS THE THE WAY THE FILE IS INTENDED TO BE OPENED. IF SEARCH-
C LISTS LIKE THE VAX/VMS LOGICAL NAMES ARE TO BE EMULATED, IT IS
C IMPORTANT TO KNOW THIS.
C
C LENNAM USEFUL LENGTH OF FILENAME
C
C      IMPLICIT NONE
#if defined(CRY_FORTDIGITAL)
      USE DFPORT
#endif
#include "RC93CM.INC"
      INTEGER MAXLVL
      PARAMETER (MAXLVL=30)
      CHARACTER*(*) FILNAM,STATUS
      LOGICAL LEXIST
      INTEGER KSTRLN
      INTEGER I,J,K,LEVEL,IWHAT
      INTEGER NAMLEN(MAXLVL),COLPOS(MAXLVL)
      INTEGER LSTLEN(MAXLVL),LSTPOS(MAXLVL)
      CHARACTER*200 INQNAM,NAME(MAXLVL),LIST(MAXLVL)
C
C
C NOW WE SEARCH FOR THE LENGTH OF OUR FILE NAME AND REMOVE BLANKS.
C
C      WRITE(NCAWU,*) 'MTRNLG:  Input="',FILNAM(1:KSTRLN(FILNAM)),
C     & '":',LEN(FILNAM),', Status="',STATUS(1:KSTRLN(STATUS)),'"'
      NCAWU = 6
      NCWU = 6
      LEVEL=1
      J=0
      DO 1 I=LEN(FILNAM),1,-1
        IF(FILNAM(I:I).NE.' ') THEN
          J = I
          EXIT
        ENDIF
1     CONTINUE
      IF(J.LE.LEN(NAME(1))) NAME(1)(1:J)=FILNAM(1:J)
      NAMLEN(1)=J
      LSTPOS(1)=0
      LSTLEN(1)=-1
C
C CHECK ON FILE NAME NAMLEN OVERFLOW
C
      IF(J.GT.LEN(NAME(LEVEL))) THEN
      WRITE ( NCAWU, '(// '' MTRNLG: Filename too long ''//)')
      STOP
      ENDIF
C
      IWHAT=0
      IF(STATUS.EQ.'OLD') IWHAT=1
      IF(STATUS.EQ.'NEW') IWHAT=2
      IF(STATUS.EQ.'FRESH') IWHAT=2
      IF(STATUS.EQ.'UNKNOWN') IWHAT=3
      IF(IWHAT.EQ.0) THEN
      WRITE ( NCAWU, '(// '' MTRNLG: Unknown status ''//)')
      STOP
      END IF
C
C HERE COMES THE BIG SEARCH LOOP. IT IS GUIDED BY THE LEVEL AND THE IWHA
C VARIABLE.
C
C SEARCH FOR THE FIRST ':' IF THERE IS ANY
C

2     COLPOS(LEVEL)=INDEX(NAME(LEVEL)(1:NAMLEN(LEVEL)),':')

C FEB04: On Win32 platform, search for forward slashes and change
C to back slashes - this will allow consistent file and path naming
C on all platforms.
#if defined(CRY_OSWIN32)
      DO WHILE(.TRUE.)
        ISLP = KCCEQL(NAME(LEVEL),1,'/')
        IF ( ISLP .GT. 0 ) THEN
#if defined (__MAC__)
          NAME(LEVEL)(ISLP:ISLP) = '\\'
#else
          NAME(LEVEL)(ISLP:ISLP) = '\'
#endif
        ELSE
          EXIT
        END IF
      END DO
#endif

C
C TEST IF SOMETHING CAN BE DONE
C
      IF(COLPOS(LEVEL).LT.3) THEN
C        WRITE(NCAWU,*) 'Inquiring "',NAME(LEVEL)(1:NAMLEN(LEVEL)),'"'
        IF(IWHAT.EQ.2) GOTO 9999
        INQNAM=NAME(LEVEL)(1:NAMLEN(LEVEL))
        DO 6666 I=NAMLEN(LEVEL)+1,LEN(INQNAM)
          INQNAM(I:I)=' '
6666    CONTINUE
        INQUIRE(FILE=INQNAM,EXIST=LEXIST)
        IF(LEXIST) GOTO 9999
        LEVEL=LEVEL-1
        IF(LEVEL.GE.1) GOTO 3
        LEVEL=1
        GOTO 9999
      ENDIF
C
C LOOK FOR AN ENVIRONMENT STRING IF NONE WAS ASSIGNED UP TO NOW
C
      IF(LSTLEN(LEVEL).LT.0) THEN
        CALL XCCUPC(NAME(LEVEL)(1:COLPOS(LEVEL)-1),
     1              NAME(LEVEL)(1:COLPOS(LEVEL)-1))
        LIST(LEVEL) = ' '
C&DOSC----- DOSPARAM@ ( CPARAM, CVALUE) RETURNS THE CVALUE OF THE PARAMET
C&DOSC      CPARAM, INITIALISED WITH THE DOS COMMAND
C&DOSC      SET CPARAM=CVALUE
#if defined(_DOS_)
        CALL DOSPARAM@(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
#else
      CALL GETENV(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
#if defined(CRY_FORTDIGITAL)
      IF ( ( CDLEN .gt. 0 ) .AND.
     1     ( NAME(LEVEL)(1:COLPOS(LEVEL)-1) .EQ. 'CRYSDIR' ) ) THEN
         LIST(LEVEL) = CRYSDIR(1:CDLEN)
      END IF
#endif
#endif
C#VAX        CALL DOSPARAM@(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
C&UNX        CALL GETENV(NAME(LEVEL)(1:COLPOS(LEVEL)-1),LIST(LEVEL))
        LSTPOS(LEVEL)=0
        LSTLEN(LEVEL)=KSTRLN(LIST(LEVEL))
C        WRITE(NCAWU,*) 'Environment ',LEVEL,'  "',
C     &    NAME(LEVEL)(1:COLPOS(LEVEL)-1),'"  = "',
C     &    LIST(LEVEL)(1:LSTLEN(LEVEL)),'"'
      ENDIF
C
C TEST LIST FOR SOMETHING TO PROCESS
C
3     CONTINUE
C      WRITE(NCAWU,*) 'Testing ',LEVEL,'  "',
C     &  NAME(LEVEL)(1:NAMLEN(LEVEL)),'"'
      IF((LSTPOS(LEVEL).GE.LSTLEN(LEVEL))
     1  .OR.((LSTPOS(LEVEL).GT.0).AND.(IWHAT.EQ.2))) THEN
        LEVEL=LEVEL-1
        IF(LEVEL.GE.1) GOTO 3
        LEVEL=1
        IF(IWHAT.EQ.3) THEN
          IWHAT=2
          LEVEL=1
          LSTPOS(1)=0
          LSTLEN(1)=-1
          GOTO 2
        ENDIF
        GOTO 9999
      ELSE
        IF(LEVEL.GE.MAXLVL) THEN
      WRITE ( NCAWU, '(// '' MTRNLG: Out of levels ''//)')
      STOP
        END IF
        J=LSTPOS(LEVEL)+1
        LSTPOS(LEVEL)=INDEX(LIST(LEVEL)(J:LSTLEN(LEVEL)),',')+J-1
        IF(LSTPOS(LEVEL).EQ.(J-1)) LSTPOS(LEVEL)=LSTLEN(LEVEL)+1
C         WRITE(NCAWU,*)
C     1 'Extracted     "',LIST(LEVEL)(J:LSTPOS(LEVEL)-1),'"'
        K=LSTPOS(LEVEL)-J
        NAME(LEVEL+1)(1:K)=LIST(LEVEL)(J:LSTPOS(LEVEL)-1)
C          WRITE(NCAWU,*)'Name="',NAME(LEVEL+1)(1:K),'"',J,K
        J=COLPOS(LEVEL)
C
C IF SOME 'REST' OF THE ORIGINAL FILE NAME REMAINDED
C
        IF(J.LT.NAMLEN(LEVEL)) THEN
C
C IF THE 'REST' CAN BE ADDED TO THE STRING WE GOT, DO SO
C
          IF((K+(NAMLEN(LEVEL)-J)).LE.LEN(NAME(LEVEL+1))) THEN
            NAME(LEVEL+1)(K+1:K+(NAMLEN(LEVEL)-J))
     1        =NAME(LEVEL)(J+1:NAMLEN(LEVEL))
            NAMLEN(LEVEL+1)=K+(NAMLEN(LEVEL)-J)
            DO 4 I=NAMLEN(LEVEL+1)+1,LEN(NAME(LEVEL+1))
              NAME(LEVEL+1)(I:I)=' '
4           CONTINUE
          ELSE
            NAME(LEVEL+1)(K+1:LEN(NAME(LEVEL+1)))
     1        =NAME(LEVEL)(J+1:J+(LEN(NAME(LEVEL+1))-K))
            NAMLEN(LEVEL+1)=LEN(NAME(LEVEL+1))
C           ...
          ENDIF
        ELSE
          NAMLEN(LEVEL+1)=K
        ENDIF
        LEVEL = LEVEL+1
        LSTPOS(LEVEL) = 0
        LSTLEN(LEVEL) = 0
        GOTO 2
      ENDIF
9999  CONTINUE
      IF(LEN(FILNAM).LT.NAMLEN(LEVEL)) THEN
          WRITE ( NCAWU, '(// '' MTRNLG: Filename too small ''//)')
          STOP
       END IF
C
      FILNAM(1:NAMLEN(LEVEL))=NAME(LEVEL)(1:NAMLEN(LEVEL))
      DO 8888 I=NAMLEN(LEVEL)+1,LEN(FILNAM)
        FILNAM(I:I)=' '
8888  CONTINUE
      LENNAM = KSTRLN(FILNAM)
C      WRITE(NCAWU,*) 'MTRNLG: Output="',FILNAM(1:LENNAM),'"'
      RETURN
      END
C
CODE FOR KSTRLN
      FUNCTION KSTRLN(STRING)
      CHARACTER*(*) STRING
      INTEGER I,J
      J=0
      DO 1 I=1,LEN(STRING)
        IF((STRING(I:I).NE.CHAR(32)).AND.(STRING(I:I).NE.' ')) J=I
1     CONTINUE
      KSTRLN=J
      RETURN
      END
C
CODE FOR XCCUPC
      SUBROUTINE XCCUPC ( CLOWER , CUPPER )
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
      CUPPER = CLOWER
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
C***********************************************************************
C
      SUBROUTINE AB31N2
C
C     This subroutine does the absorption processing of records 31 and
C     32.  These come together unless the file has been corrupted.
C     They contain the orientation matrix for the crystal and also the
C     wavelengths lambda1 and lambda2, and the attenuator factor.
C     The attenuator factor written out by CAD4 may differ from that
C     in the file ATT.DAT, but the ATT.DAT value is used.
C     The format for both records is:-
C     1X, I2, 2X, F9.6, F9.6, F9.6, 2X, F9.6, F9.6, F9.6, 1X
#include "RC93CM.INC"
      INTEGER J, LAM1, LAM2, LAM1F, LAM2F, MARKF, IRADF
      REAL RLAM1F, RLAM2F, ATTFAC
      INTEGER NADD
C     Assume that absorption profile measured on same machine as the
C     main data collection, so if we have an attenuator factor don't
C     get another one.
      IF (MINITP .NE. 1)  THEN
C           Have an att. factor.
            GO TO 999
      ELSE
C           This is the first record 31&32.
C           Set att factor and wavelength.
            MINITP = NADD ( (9+1) +2 +1 )
C           Set attenuator factor to 0.0 initially, just in case.
C           Set no. of reor's to zero
            STORE(MINITP+12) = 0.0
            ISTORE(MINITP) = 0
            READ (CARD1, 1001)   (STORE(MINITP+J),   J=1,6)
            READ (CARD2, 1001)   (STORE(MINITP+6+J), J=1,6)
            GO TO 10
      END IF
1001  FORMAT (5X, 3F9.6, 2X, 3F9.6)
C
10    CONTINUE
C     Need to check attenuator and wavelengths against ATT.DAT
C     The lambda1, lamda2 and att.factor are in STORE(MINITP+10, 11, 12)
C     Compare the wavelengths from CAD4 with those in ATT.DAT to 2
C     decimal places. Compare the attenuator factors to 3dp, if
C     different USE THE VALUE IN ATT.DAT.
      LAM1 = NINT (STORE(MINITP+10)*100.0)
      LAM2 = NINT (STORE(MINITP+11)*100.0)
20    CONTINUE
      READ (IATTFL, '(A80)', END=60, ERR=50) CBUFFR
      IF (CBUFFR(:2) .NE. ' *') THEN
            GO TO 20
      ELSE
            READ (CBUFFR, '(2X,I2,2(1X,F7.5))') IRAD, RLAM1F, RLAM2F
            LAM1F = NINT (RLAM1F*100.0)
            LAM2F = NINT (RLAM2F*100.0)
            IF ((LAM1 .NE. LAM1F) .OR. (LAM2 .NE. LAM2F)) GO TO 20
      END IF
C     By now we have matched up the wavelengths and found the
C     radiation type.
C     Rewind the file and scan for the att. factor
C     corresponding to the radiation and Mark 1 or 2.
      REWIND (IATTFL)
30    CONTINUE
      READ (IATTFL, '(A80)', ERR=50, END=60) CBUFFR
      IF (.NOT.((CBUFFR(:2).EQ.' 1').OR.(CBUFFR(:2).EQ.' 2'))) GO TO 30
      READ (CBUFFR, '(I2, I2, 1X, F7.3)', ERR=30) MARKF, IRADF, ATTFAC
      IF ((MARKF .NE. MARK) .OR. (IRADF .NE. IRAD)) THEN
                  GO TO 30
      ELSE IF ((NINT(ATTFAC*1000)) .NE.
     +                               (NINT(STORE(MINITP+12)*1000))) THEN
C     Value from ATT.DAT used if the values differ (they will on mark1).
                  STORE(MINITP+12) = ATTFAC
      END IF
      GO TO 999
50    CONTINUE
      WRITE (ISCRN, '(1X,A)') 'ERROR READING FILE ATT.DAT'
      WRITE (IERFIL, '(1X,A)') 'ERROR READING FILE ATT.DAT'
      STOP
60    CONTINUE
      WRITE (ISCRN, '(1X,A/1X,A)') 'ERROR READING FILE ATT.DAT',
     +'Attenuator factor or wavelengths not found or not matching CAD4 o
     +utput.'
      WRITE (IERFIL, '(1X,A/1X,A)') 'ERROR READING FILE ATT.DAT',
     +'Attenuator factor or wavelengths not found or not matching CAD4 o
     +utput.'
      STOP
999   CONTINUE
      RETURN
      END
C***********************************************************************
C
      SUBROUTINE ABS1N2
C
C     This deals with the processing of records 1&2 of an absorption
C     profile.
C     The format of Record 1 is
C   FORMAT  I2,    I6, I5, I5, I5, 1X, 6A1, F7.2,  I4,  I6,  I7,  I6, 1X
C           1 , NREFL,  H,  K,  L,    CODE,  PSI, NPI, BGL, IPEAK, BGR
C     The NREFL, H, K, L and CODE are read in as a character entity.
C     NPI, BGL, INT and BGR are read into an array IBUFF1(4).
C
C     The format of record 2 is
C   FORMAT  I2,    I6,  F8.3, F9.3, F9.3,  F9.3,  F7.3,    I7,   I3,  1X
C           2 , NREFL, THETA, PHIK,  OMK, RKAPPA, WIDTH, IXRAYT, FRIDL
#include "RC93CM.INC"
      REAL FACT
      PARAMETER (FACT = 0.0174532925)
C     FACT = pi / 180
      INTEGER IXRAYT, FRIDL
      REAL EKAPPA, RKP2EU, SI, RCO, PHIE
      INTEGER IBUFF1(4)
      REAL PSI, THETA, PHIK, OMK, RKAPPA, WIDTH, FOBS, SIGMA
      READ (CARD1, 1001) CCARD, PSI, IBUFF1
1001  FORMAT (1X, 2X, A28, F7.2, I4, I6, I7, I6)
      READ (CARD2, 1002) THETA, PHIK, OMK, RKAPPA, WIDTH, IXRAYT, FRIDL
1002  FORMAT (1X, 2X, 6X, F8.3, 3F9.3, F7.3, I7, I3)
C     If the reflection is an intensity or orientation control then we
C     need to process it differently to the main reflections.
      IF (CCARD(23:28) .EQ. 'N*****') THEN
            GO TO 30
      ELSE IF (CCARD(23:23) .EQ. 'N') THEN
C                                   Normal data collection reflection.
            GO TO 20
      ELSE IF (CCARD(23:23) .EQ. 'I') THEN
C                                   Skip intensity controls.
            GO TO 9999
      ELSE IF (CCARD (23:23) .EQ. 'S') THEN
C                                   Static background, ignore??
            GO TO 100
      ELSE
            WRITE (ISCRN, '(1X,A,A,A,I4,A)') 'ERROR - Illegal code in ',
     +              CINPFL(:LENINP), 'line', INPLIN, 'Record skipped'
            GO TO 9999
      END IF
C
20    CONTINUE
C
      CBUFFR = ' '
      IF (CCARD(26:26) .EQ. 'W') THEN
C           Weak, strong, and deviant reflections are used for abs
C           profile because better than nothing.
            WRITE (CBUFFR, '(A,A,A,A,A)') 'WARNING reflection ',
     +            CCARD(:6), ' code ', CCARD(23:28), ' will be used'
      ELSE IF (CCARD(26:26) .EQ. 'S') THEN
            WRITE (CBUFFR, '(A,A,A,A,A)') 'WARNING reflection ',
     +            CCARD(:6), ' code ', CCARD(23:28), ' will be used'
      ELSE IF (CCARD(26:26) .EQ. 'T') THEN
            WRITE (CBUFFR, '(A,A,A,A,A)') 'WARNING reflection ',
     +            CCARD(:6), ' code ', CCARD(23:28), ' will be used'
      ELSE IF (CCARD(24:24) .EQ. 'D') THEN
            WRITE (CBUFFR, '(A,A,A,A,A)') 'WARNING reflection ',
     +            CCARD(:6), ' code ', CCARD(23:28), ' will be used'
      ELSE IF (CCARD(24:24) .EQ. 'C') THEN
C           Ignore as couldn't be measured.
            GO TO 100
      ELSE IF (CCARD(24:24) .EQ. 'X') THEN
C           Ignore as couldn't be measured.
            GO TO 100
Cfeb96      ELSE
C           Some code not covered by the above, skip it.
Cfeb96            GO TO 100
      END IF
      IF (CBUFFR .NE. ' ') THEN
            WRITE (ISCRN, '(1X,A)') CBUFFR
            WRITE (LISFIL, '(1X,A)') CBUFFR
      ENDIF
C
      IF ((CCARD(27:27).NE.'*').AND.(CCARD(27:27).NE.'0')) THEN
C           Non-equal test failed at least once,
            WRITE (CBUFFR, '(A,A,A,A,A)') 'WARNING reflection ',
     1        CCARD(:6), ' code ', CCARD(23:28), ' will be used'
            WRITE (ISCRN, '(1X,A)') CBUFFR
      ENDIF
      IF (CCARD(25:25) .NE. '*') THEN
            WRITE (ISCRN, '(1X,A,A6,/,1X,A)') 'BALANCED FILTERS USED, re
     +flection ',CCARD(:6), 'RC93 cannot process'
            WRITE (IERFIL,'(1X,A,A6,/,1X,A)')'BALANCED FILTERS USED, re
     +flection ',CCARD(:6), 'RC93 cannot process'
            STOP
      END IF
C
C     Scan speed cannot be 0.
      IF (IBUFF1(1) .EQ. 0) THEN
            WRITE (CBUFFR,'(1X,A,A6,A,I6,A)') 'Reflection ',CCARD(:6),
     +                  ' line ', INPLIN, ' scan speed=0  IGNORED'
            WRITE (ISCRN, '(1X,A)') CBUFFR
            GO TO 9999
      END IF
C
30    CONTINUE
C     Calculate Fobs (FOBS) and sigma(Fobs) (SIGMA)
      CALL PNSIG (IBUFF1(1), IBUFF1(2), IBUFF1(3), IBUFF1(4),
     +                                                    FOBS, SIGMA)
C
C     Now calculate the geometry, this calculation mimics that in RC85
C     RKP2EU converts angles from Kappa to Eulerian geometry.
C     RCON2 is taken from rec26 'con2' - What is this ??
C     internal funcion ATAN2(arg1, arg2)  is arctan(arg1 / arg2).
      EKAPPA = RKP2EU (RKAPPA*FACT)
      SI = RCON2* SIN (EKAPPA / 2.0)
      RCO = COS (EKAPPA / 2.0)
      SI = ATAN2  (SI, RCO)
      PHIE = RKP2EU (PHIK*FACT + SI)
      PHIE = PHIE / FACT
C
C     Now write out to the ITMPFL temporary file (read in by ABSFIT),
C     and the LIS file.
      WRITE (ITMPFL, '(A15,1X,F15.7,1X,F15.7)') CCARD(7:21),FOBS,PHIE
      GO TO 9999
100   CONTINUE
      WRITE (CBUFFR,'(A,A,A,A,A)') 'Absorption reflection ',CCARD(:6),
     +                                ' code ', CCARD(23:28), ' IGNORED'
      WRITE (ISCRN, '(1X,A)') CBUFFR
      WRITE (LISFIL, '(1X,A)') CBUFFR
      GO TO 9999
9999  CONTINUE
      RETURN
      END
C
      REAL FUNCTION RKP2EU ( ANGLE)
C     This function converts angles from kappa geometry to Eulerian.
C     It is copied from RC85.
      REAL PI, ANGLE
      PARAMETER ( PI = 3.141592654)
      RKP2EU = ANGLE
     +         - 2.0*PI* (FLOAT(INT((SIGN(PI,ANGLE)+ANGLE)/(2.0*PI))))
      RETURN
      END
C***********************************************************************
C
        SUBROUTINE ABSFIT (NOPR, CINDEX, MAXIN, ITHETA)
C
C     PROGRAM FOR DRAWING ABSORPTION CURVE AND PRODUCING OUTPUT
C     FOR CRYSTALS
C     WRITTEN BY P.GREBENIK MARCH 1983
C     Modified for spherical absorption correction by Pete Baird
C     Modified for use in RC93 and made case insensitive by Paul Lilley
C     AR
C     PH
C     GRADL
C     GRADU
C     UB
C     LB
C     RE
C     GR
C     OUTA
C     OUTI
C     NO
C     LU
C     CINDEX
C     MAXIN
C     FILNAM
C     INDA
C     THREP
C     LIBU
C     LIBUI
C     INTERA
C     NOPR
CPML INC
#include "RC93CM.INC"
       INTEGER NOPR, ITHETA
       INTEGER I, MI, MINN, MAXIN (10)
       INTEGER N, N1, NN, NO2, ICORR
       INTEGER N3, IN, N5, N6
       CHARACTER*15 CINDEX(10)
CPML INC ENDS
         INTEGER GRADL,GRADU,UB,LB,RE,GR
       INTEGER NO(10),LU(50)
       INTEGER OUTA (26), OUTI(26,10)
       INTEGER AR(10,180), ISUM
       REAL SPHAB, COUNTS, PHI
       REAL SC
         CHARACTER*15 INDA,
     1  LIBU*150,LIBUI*150,INTERA*1
       COMMON /ABSORP/ OUTA , OUTI
C
C----- Initialise variables
         NOPR = 1
       SPHAB = STORE (L30P+11) * (STORE(L30P) / 20.0)
CPML  sphab = mu * min crystal dimension / 20   , 20 to get from crystal
Cpml  dimension in mm to radius in cm.
         DO 2210 I=1,10
         NO(I) = 0
         CINDEX (I) = 'O'
2210    CONTINUE
         DO 2100 I=1,26
         OUTA (I) = 0
2100    CONTINUE
         INTERA = 'N'
C
CPML       Apply a spherical absorption correction anyway.
1250  CONTINUE
c      write(57,*) 'sphab=', sphab
         IF (SPHAB) 1200,1200,1100
1200    WRITE (ISCRN,25)
25      FORMAT (/1X,' Enter mu*R for your crystal (QUIT if unknown):')
CPML
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 1200
      IF (CLINE .EQ. 'QUIT') THEN
            SPHAB = 0.001
            CALL CENTRE (ISCRN,
     +      'No spherical absorption correction will be written')
            GO TO 1100
      ELSE
            READ (CLINE, *, ERR=1200) SPHAB
            IF (SPHAB .GT. 10.0) THEN
               WRITE (ISCRN,60)
60              FORMAT (/' Please ask for advice: mu*R > 10.0 (no data a
     +vailable)')
               SPHAB = 0.0
                GO TO 1100
            ELSE IF (SPHAB .LT. 0.0) THEN
                WRITE (ISCRN, '(1X,A)') 'mu*R MUST be positive'
                GO TO 1200
           ENDIF
      END IF
      IF (SPHAB) 1250,1100,1100
C
C----- Read in the file produced by RC85 absorption processing
1100    WRITE (ISCRN, '(1X,A)') 'Absorption Profile:-'
         WRITE (ISCRN ,20)
20     FORMAT(/21X,' Interactive mode(y/n)?  [n]:')
CPML   READ (IKEYBD,50) INTERA
              CALL READLN(IKEYBD)
              IF (KERR .NE. 0) GO TO 1100
              IF ((CLINE .EQ. CNULL) .OR. (CLINE(:1) .EQ. 'N')) THEN
                     INTERA = 'N'
              ELSE IF (CLINE(:1) .EQ. 'Y') THEN
                     INTERA = 'Y'
              ELSE
                     GO TO 1100
              END IF
C
C----- Finding out how many different reflections to be processed for phicurve
       REWIND ITMPFL
CPML  WRITE (ITMPFL, '(A15,1X,F15.7,1X,F15.7)') INDA, FOBS, FPHIE
160    READ (ITMPFL, '(A15)', END=200) INDA
        IF (INDA .NE. CINDEX(NOPR)) GOTO 170
        NO(NOPR) = NO(NOPR) + 1
        GOTO 160
170    NOPR = NOPR + 1
        NO(NOPR) = NO(NOPR) + 1
        CINDEX(NOPR) = INDA
        GOTO 160
200    REWIND ITMPFL
C
C----- Set up an empty character array for later use
        DO 225 N = 1, 150
          LIBUI(N:N) = ' '
225    CONTINUE
        LIBUI(5:5) = '+'
C
C----- Now start - processing one reflection at a time
        DO 800 N1 = 2, NOPR
C
C----- Reset the data array
          DO 240 N = 1, 180
            DO 230 NN = 1, 10
               AR(NN,N) = 0
230        CONTINUE
240      CONTINUE
          NO2 =  0
          ICORR = 1
          WRITE (CBUFFR,30) CINDEX(N1)
30     FORMAT('ABSORPTION PROFILE FOR REFLECTION ', A15)
              WRITE (LISFIL , '(/)')
              CALL CENTRE (LISFIL, CBUFFR)
C
C----- Read in the data for a given reflection
          DO 250 N = 1, NO(N1)
C PML       WRITE (ITMPFL, '(A15,1X,F15.7,1X,F15.7)') INDA, FOBS, FPHIE
            READ(ITMPFL, '(A15,1X,F15.7,1X,F15.7)') INDA,COUNTS,PHI
            IF (COUNTS.LT.20.0) GOTO 250
            IF (PHI.LE.0.)   PHI = PHI + 180.
            IF (NINT(PHI).EQ.0) PHI = PHI + 1.0
            AR(1,NINT(PHI)) = AR(1,NINT(PHI)) + 1
            AR((AR(1,NINT(PHI)) + 5),NINT(PHI)) = NINT(COUNTS)
250      CONTINUE
C
C----- Set up look-up file
          DO 300 N = 1, 180
            IF (AR(1,N).EQ.0) GOTO 300
            NO2 = NO2 + 1
            LU(NO2) = N
300      CONTINUE
C
C----- Chuck out a profile with too few data points
          IF (NO2.LT.10) THEN
            WRITE (LISFIL,10)
10     FORMAT(' TOO FEW DATA POINTS')
            CINDEX(N1) = '*'
            GOTO 800
          END IF
C
C----- Calculate averages
          DO 350 N = 1, NO2
            ISUM = 0
            DO 330 N3 = 1, AR(1,LU(N))
               ISUM = ISUM + AR(5+N3,LU(N))
330        CONTINUE
            AR(3,LU(N)) = ISUM/AR(1,LU(N))
350      CONTINUE
C
C----- Calculate gradients to the succeeding point
          DO 400 N = 1, NO2 - 1
            AR(4,LU(N)) = (AR(3,LU(N+1)) - AR(3,LU(N)))/
     1     (LU(N+1) - LU(N))
400      CONTINUE
          AR(4,LU(NO2)) = (AR(3,LU(1)) - AR(3,LU(NO2)))/
     1   (180 + LU(1) - LU(NO2))
C
C----- Calculate average gradient for each data point
          DO 450 N = 2, NO2
            AR(5,LU(N)) = (AR(4,LU(N)) + AR(4,LU(N-1)))/2
450      CONTINUE
          AR(5,LU(1)) = (AR(4,LU(1)) + AR(4,LU(NO2)))/2
C
C----- Calculate the curve
          AR(2,1) = AR(3,LU(1))
          GRADL = AR(5,LU(NO2))
          GRADU = AR(5,LU(1))
          NN = 1
          LB = LU(NO2) - 180
          UB = LU(1)
          RE = 0
          IF (LU(1).EQ.1) THEN
            LB = LU(1)
            UB = LU(2)
            GRADL = AR(5,LB)
            GRADU = AR(5,UB)
            NN = 2
          END IF
          DO 500 N = 2, 180
            IF ((N.EQ.UB).AND.(UB.EQ.LU(NO2))) THEN
               LB = LU(NO2)
               UB = LU(1)
               GRADL = AR(5,LB)
               GRADU = AR(5,UB)
               AR(2,N) = AR(2,N-1) + GRADL
               UB = UB + 180
               GOTO 500
C
               ELSE IF (N.EQ.UB) THEN
                 NN = NN + 1
                 LB = LU(NN - 1)
                 UB = LU(NN)
                 GRADL = AR(5,LB)
                 GRADU = AR(5,UB)
                 AR(2,N) = AR(2,N-1) + GRADL
                 GOTO 500
            END IF
            IN = ((UB - N)*GRADL + (N - LB)*GRADU)/(UB - LB)
            AR(2,N) = AR(2,N-1) + IN
500      CONTINUE
C
C----- Rescaling the curve
          DO 550 N = 1, NO2
            RE = RE + AR(2,LU(N)) - AR(3,LU(N))
550      CONTINUE
          RE = RE/NO2
          GR = 0
          DO 600 N = 1, 180
            AR(2,N) = AR(2,N) - RE
            IF (AR(2,N).GT.GR) GR = AR(2,N)
600      CONTINUE
C
C----- Calculating diff between Calc and Obs
          DO 605 N = 1, NO2
            AR(4,LU(N)) = AR(2,LU(N)) - AR(3,LU(N))
605      CONTINUE
C
C----- Calculating corrections
          DO 610 N = 1, NO2
            N3 = 0
            RE = 0
            DO 607 NN = N-2, N+2
               N5 = NN
               IF (NN.LT.1) N5 = NN + NO2
               IF (NN.GT.NO2) N5 = NN - NO2
               N6 = (AR(4,LU(N))*100.0)/AR(3,LU(N))
               IF (IABS(N6).GT.20) GOTO 607
               N3 = N3 + 1
               RE = RE + AR(4,LU(N5))
607        CONTINUE
            IF (N3.EQ.0) THEN
               AR(5,LU(N)) = 0
               GOTO 610
            END IF
            AR(5,LU(N)) = RE/N3
610      CONTINUE
C
611      NN = 1
          GRADL = AR(5, LU(NO2))
          GRADU = AR(5,LU(1))
          LB = LU(NO2) - 180
          UB = LU(1)
          DO 640 N = 1,180
            IF ((N.EQ.UB).AND.(UB.EQ.LU(NO2))) THEN
               LB = LU(NO2)
               UB = LU(1)
               GRADL = AR(5,LB)
               GRADU = AR(5,UB)
               AR(2,N) = AR(2,N) - GRADL
               UB = UB + 180
               GOTO 640
C
            ELSE IF (N.EQ.UB) THEN
               NN = NN + 1
               LB = LU(NN-1)
               UB = LU(NN)
               GRADL = AR(5,LB)
               GRADU = AR(5,UB)
               AR(2,N) = AR(2,N) - GRADL
               GOTO 640
            END IF
            IN = ((UB-N)*GRADL + (N-LB)*GRADU)/(UB - LB)
            AR(2,N) = AR(2,N) - IN
640      CONTINUE
C
C----- Manual correction
          IF (ICORR.EQ.2) GOTO 655
          IF ((ICORR.EQ.1).AND.(INTERA.EQ.'Y')) THEN
            WRITE (ISCRN ,30) CINDEX(N1)
            DO 650 N = 1, NO2
               AR(5,LU(N)) = 0
641              CONTINUE
               WRITE (ISCRN ,22) LU(N), AR(2,LU(N)), AR(3,LU(N))
22     FORMAT(' PHI   ', I3,/1X, 'CALCULATED   ', I8,/1X,
     1 'OBSERVED   ', 1I8,/1X, 'OK?  (Y/N)  [N]')
CPML         READ (IKEYBD,50) RESPON
CPML         IF (RESPON.NE.'Y') GOTO 650
CPML         WRITE (ISCRN ,21)
CPML21      FORMAT(' INPUT DESIRED VALUE FOR THIS POINT')
CPML         READ (IKEYBD,*) ICORR
CPML         AR(5,LU(N)) = AR(2,LU(N)) - ICORR
CPML I think the decision above is the wrong way round, so have changed
Cpml      it and made it case insensitive
                   CALL READLN (IKEYBD)
                   IF (KERR .NE. 0) GO TO 641
                   IF ((CLINE.EQ.CNULL).OR.(CLINE(:1).EQ.'N')) THEN
777                     CONTINUE
                            WRITE (ISCRN ,21)
21                      FORMAT(' INPUT DESIRED VALUE FOR THIS POINT')
                              READ (IKEYBD,*, ERR = 777) ICORR
                            AR(5,LU(N)) = AR(2,LU(N)) - ICORR
                            GO TO 650
                   ELSE IF (CLINE(:1) .EQ. 'Y') THEN
                            GO TO 650
                   ELSE
                            GO TO 641
                   END IF
650        CONTINUE
            ICORR = 2
          END IF
          GOTO (655, 611) ICORR
C
C----- Outputting the results via a line-buffer
655      SC = 100./GR
          LIBU = LIBUI
          WRITE (LISFIL,35) (N*GR/10, N = 1, 10)
35     FORMAT(/'INTENSITY',10I9,8X,'MEAN OBS.',
     1 5X,'CALCULATED',//,'PHI',/1X)
          DO 656 N = 5, 100
            LIBU(N:N) = '+'
656      CONTINUE
          WRITE (LISFIL,90) LIBU
90     FORMAT(A110)
C
          N3 = 1
          DO 750 N = 1, 180, 3
            LIBU = LIBUI
            N5 = NINT(SC*AR(2,N))
            LIBU(N5:N5) = '*'
            IF (IABS(N-LU(N3)).GT.1) GOTO 700
            DO 660 NN = 1, AR(1,LU(N3))
               N5 = NINT(SC*AR(5+NN,LU(N3)))
               LIBU(N5:N5) = 'M'
660        CONTINUE
Cpml      output altered
Cpml           WRITE (LISFIL,90) LIBU(1:110)
Cpml           WRITE (LISFIL,38) AR(3,LU(N3)), AR(2,N)
Cpml38     FORMAT('+',105X, I10, 5X, I10)
C2           WRITE (LISFIL, 38) LIBU(1:110), AR(3,LU(N3)), AR(2,N)
C2 38         FORMAT (1X, A110, 1X, I9, 2X, I9)
C2           N3 = N3 + 1
C2           GOTO 740
C2 PML output altered
C2 700        WRITE (LISFIL,90) LIBU(1:110)
C2 740        IF (MOD(N,10).EQ.0) WRITE (LISFIL,40) N
C2 40     FORMAT('+',1I3)
C2 750      CONTINUE
C2 alterations below
       IF (MOD(N,10) .EQ. 0) THEN
            WRITE (LISFIL, 38) N, LIBU(4:110), AR(3,LU(N3)), AR(2,N)
38      FORMAT(I3,A107,1X,I9,2X,I9)
          N3 = N3+1
          GO TO 750
       ELSE
          WRITE (LISFIL, 1038) LIBU(1:110), AR(3,LU(N3)), AR(2,N)
1038       FORMAT(A110, 1X, I9, 2X, I9)
          N3 = N3+1
          GO TO 750
       END IF
700      CONTINUE
          IF (MOD(N,10) .EQ. 0) THEN
                 WRITE (LISFIL, '(I3,A107)') N, LIBU(4:110)
          ELSE
                 WRITE (LISFIL, '(A110)') LIBU(1:110)
                 GO TO 750
          END IF
750         CONTINUE
C
C----- Getting results ready for CRYSTALS
C----- Testing to see if this is the first profile
          IF (OUTA(2).NE.0) GOTO 785
C
C----- Setting up DI/DTHETA and D2I/DTHETA2
          DO 760 N = 1, 176, 5
            AR(4,N) = AR(2,N+1) - AR(2,N)
760      CONTINUE
          DO 765 N = 1, 176, 5
            NN = N + 5
            IF (N.EQ.176) NN = 1
            AR(5,N) = IABS(AR(4,NN) - AR(4,N))
765      CONTINUE
C
C----- Get rid of 10 - CRYSTALS requires 26 theta values
          DO 770 N = 1, 10
            MI = AR(5,1)
            MINN = 1
            DO 767 NN = 6, 176, 5
               IF (AR(5,NN).LT.MI) THEN
                 MI = AR(5,NN)
                 MINN = NN
               END IF
767        CONTINUE
            AR(5,MINN) = 1000000
            AR(1,MINN) = -1
770      CONTINUE
C
C----- Set up theta output file
          NN = 0
          DO 780 N = 1, 176, 5
            IF (AR(1,N).EQ.-1) GOTO 780
            NN = NN + 1
            OUTA(NN) = N
780      CONTINUE
C
C----- Find maximum intensity and write intensity file
785      GR = 0
          DO 790 N = 1, 26
            OUTI(N,N1) = AR(2,OUTA(N))
            IF (AR(2,OUTA(N)).GT.GR) GR = AR(2,OUTA(N))
790      CONTINUE
          MAXIN(N1) = GR
C
C---- Continue with the next profile
800    CONTINUE
C
CPML    CALL ABSOUT (NOPR, CINDEX, MAXIN, ITHETA)
CPML      The call to ABSOUT is made by tidyup.
C
       RETURN
         END
C**********************************************************************
C
         SUBROUTINE ABSOUT (NOPR, CINDEX, MAXIN, ITHETA)
C
C    This writes out the absorption correction file
C                                                            *
C********************************************************************
C
C  ITHETA   controls which corrections are written out to the file
C              1 - PSI only
C              2 - THETA only
C              3 - Both
C
C  NN       number of reflections for which there are psi-scans
C
C  IVTHET   Theta values for the spherical absorption correction (0 ->
C             75 deg)
C
C  CTHETA   Theta dependent absorption factors
C
C  ATHETA   Holds 'YES' and 'NO' qualifiers for theta correction given
C            or not
C
C  APHI     As ATHETA but for phi
C
C  LINE     Holds a line from the spherical absorption correction table
C
Cpml  #include 'ALL.CMN'
CPML INC
#include "RC93CM.INC"
       CHARACTER*15 CINDEX(10)
       INTEGER MAXIN(10)
       INTEGER ILINE, LL15, I1, I2, LSPHAB, N, NN
       REAL SPHAB
       INTEGER NOPR
CPML INC ENDS
         CHARACTER ATHETA(3)*3,APHI(3)*3,LINE*80
       REAL CTHETA(16)
       INTEGER IVTHET(16)
       INTEGER ITHETA
       INTEGER OUTA(26), OUTI(26,10)
       COMMON /ABSORP/ OUTA, OUTI
         DATA ATHETA,APHI /'NO ','YES','YES' , 'YES','NO','YES'/
         DATA  IVTHET /0,5,10,15,20,25,30,35,40,45,50,
     1   55,60,65,70,75/
C
       SPHAB = STORE (L30P+11) * (STORE(L30P) / 20.0)
CPML  sphab = mu * min crystal dimension / 20   , 20 to get from crystal
Cpml  dimension in mm to radius in cm.
         ILINE = 0
CDJW         IF (SPHAB .GT. 10.0 .AND. ITHETA .EQ. 3) THEN
C           ITHETA = 1
C           WRITE (ISCRN ,'(21H mu*R > 10.0, ignored)')
C           WRITE (IERFIL ,'(21H mu*R > 10.0, ignored)')
C          ELSE IF (SPHAB .GT. 10.0 .AND. ITHETA .EQ. 2) THEN
C           WRITE (ISCRN ,'(32H mu*R > 10.0, no correction done)')
C           WRITE (IERFIL ,'(32H mu*R > 10.0, no correction done)')
C           RETURN
C         ENDIF
CDJWOCT99
          IF (SPHAB .GT. 10.) THEN
         WRITE (ISCRN ,'(A,F6.2,A)')'mu*R =', SPHAB, ', Reset to 10.'
          ENDIF
CDJWOCT99
       WRITE (IABSFL,10)
10    FORMAT ('#HKLI')
         WRITE (IABSFL,20) APHI(ITHETA),ATHETA(ITHETA)
20      FORMAT ('ABSORPTION PHI=',A3,'  THETA=',A3,' PRINT=NONE')
C
         GOTO (300) ITHETA
C
C----- Get the theta values...assume that at 0,5,10,15,etc
         LSPHAB = NINT(SPHAB*10.0) + 1
         IF (LSPHAB) 300,300,150
CPML {opened by READIN}
CPML      OPEN (UNIT=ISPABS,FILE=CSPABS,STATUS='OLD',READONLY)
150     CONTINUE
CDJWDEC99 STORE THE LINE ANYWAY, AND JUMP OUT AT END OF FILE
         DO 100 LL15=1,150
CDJW         READ (ISPABS,'(A80)') LINE
         READ (ISPABS,'(A80)',END=100) LINE
         IF ((LINE(1:1)) .EQ. ' ') GOTO 100
         READ (LINE,*) (CTHETA(I1) , I1=1,16)
         ILINE=ILINE+1
         IF (ILINE .NE. LSPHAB) GOTO 100
         CLOSE (ISPABS)
         GOTO 200
100     CONTINUE
C
C---- Now put Theta correction in.
200     WRITE (IABSFL,'(8HTHETA 16)')
         WRITE (IABSFL,30) (IVTHET(I2) , I2=1,16)
30      FORMAT ('THETAVALUES',16(1X,I2))
         WRITE (IABSFL,40) (CTHETA(I2) , I2=1,16)
40      FORMAT ('THETACURVE',5(1X,F7.2),/'CONT',6(1X,F7.2),
     1  /'CONT',5(1X,F7.2))
         GOTO (300,400) ITHETA
C
C----- Write out Phi absorption correction
300    NN = 0
        DO 250 N = 2, NOPR
          IF (CINDEX(N).EQ.'*') THEN
            NN = NN + 1
          END IF
250    CONTINUE
C
         WRITE (IABSFL,'(7HPHI 26 ,1I2)') NOPR - NN - 1
         WRITE (IABSFL,50) OUTA
50      FORMAT ('PHIVALUES', 10I4,/ 'CONT',10I4,/ 'CONT', 6I4)
         DO 340 N = 2, NOPR
           IF (CINDEX(N).EQ.'*') GOTO 340
          WRITE (IABSFL,60) CINDEX(N), MAXIN(N)
60       FORMAT ('PHIHKLI ',A15, 1I9)
340     CONTINUE
         DO 370 N = 2, NOPR
           IF (CINDEX(N).EQ.'*') GOTO 370
          WRITE (IABSFL,70) (OUTI(NN,N), NN = 1,6)
70       FORMAT ('PHICURVE ', 6I8)
          WRITE (IABSFL,80) (OUTI(NN,N), NN = 7,26)
80       FORMAT ('CONT ', 6I8)
370     CONTINUE
C
C----- Terminate absorption correction file
400     WRITE (IABSFL,'(''END'')')
         SPHAB = -1
         RETURN
         END
C***********************************************************************
C
      SUBROUTINE ABSPRO
C
C     This subroutine does the processing of each card if the file
C     contains the absorption profile.
#include "RC93CM.INC"
      CALL CENTRE (ISCRN, '-- PROCESSING ABSORPTION DATA -- ')
      OPEN (ITMPFL, STATUS='SCRATCH')
20    CONTINUE
C     Get a record from the file.
      CALL RECORD
      IF (KERR .NE. 0) THEN
            IF (KERR .LT. 0) THEN
C                                   End of file, return to RC93.SUB
                  GO TO 999
            ELSE
                  WRITE (ISCRN, '(A,A/1X,A,I4)') 'ERROR Reading file ',
     +                              CINPFL(:LENINP), 'Line ', INPLIN
                  WRITE (IERFIL, '(A,A/1X,A,I4)') 'ERROR Reading file ',
     +                              CINPFL(:LENINP), 'Line ', INPLIN
                  STOP
            END IF
      END IF
C
      IF (IREC .EQ. 2) THEN
C           Reflection data cards 1&2
            CALL ABS1N2
            GO TO 20
      ELSE IF (IREC .EQ. 0) THEN
C           No refdump processing required for abs profile
            GO TO 20
      ELSE IF (IREC .EQ. 32) THEN
            CALL AB31N2
C           Need to check that we have value for attenuator,
C           if not read it in from rec 31 & 32.
            GO TO 20
      ELSE IF ((IREC .GT. 2) .AND. (IREC .LT. 20)) THEN
C           These records are the profile dump (3-10) and the learnt
C           profile or static background measurements. SKIP THESE.
            GO TO 20
      ELSE IF (IREC .EQ. 21 ) THEN
C           Nothing needed for abs profile.
            GO TO 20
      ELSE IF (IREC .EQ. 22) THEN
C           Need to read in a value for the base speed if we haven't
C           got one.
            CALL REC22
            GO TO 20
      ELSE IF (IREC .EQ. 23) THEN
            CALL  REC23
C           MN2ABS .LT. 0 means a change from abs data to intensity data
            IF (MN2ABS .LT. 0) GO TO 999
            GO TO 20
      ELSE IF (IREC .EQ. 24) THEN
C           Nothing needed for abs profile.
            GO TO 20
      ELSE IF (IREC .EQ. 25) THEN
C           Do-nothing as no processing needed.
            GO TO 20
      ELSE IF (IREC .EQ. 26) THEN
C           Need to get a value for 'CONA' in
            CALL REC26
            GO TO 20
      ELSE IF (IREC .EQ. 27) THEN
C           Do nothing as no processing needed.
            GO TO 20
      ELSE
            WRITE (ISCRN,'(1X,A,I4,A,I6,2X,A,A)')'Unidentified Record ',
     +            IREC, ' on line ', INPLIN, CINPFL(:LENINP), '-SKIPPED'
            GO TO 20
      END IF
999   CONTINUE
      RETURN
      END
C***********************************************************************
C
      SUBROUTINE CAPPER (CIN,
     +                       COUT)
C
C     This subroutine will convert any lower case letters to upper case
C     in a string up to 80 characters in length.  Non alphabetic
C     characters are left unchanged.
C     This may turn out to be a function not a subroutine.
C     CIN is the input buffer*80, COUT is the output buffer*80.
#include "RC93CM.INC"
      CHARACTER*26 CUPPER, CLOWER
      INTEGER J, IPLACE
      CHARACTER*(*) CIN, COUT
      DATA CUPPER/ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
      DATA CLOWER/ 'abcdefghijklmnopqrstuvwxyz'/
      COUT = CIN
      DO 30 J= 1, LENSTR (CIN)
            IPLACE = INDEX (CLOWER, CIN(J:J))
            IF (IPLACE .NE. 0) COUT(J:J) = CUPPER(IPLACE:IPLACE)
30    CONTINUE
      RETURN
      END
C***********************************************************************
C
      SUBROUTINE CELPAR (IUMBP)
C
C     This subroutine calculates the unit cell parameters from the
C     orientation matrix held in the chained list at pointer IUMBP
C     [STORE (IUMBP) = element 1,1 of the matrix] and
C     returns a pointer ICELLP to the position of the cell parameters in
C     the list.
C     It is based directly on the code in RC85 which originates from
C     Enraf-Nonius.
#include "RC93CM.INC"
      DOUBLE PRECISION RADIAN
      PARAMETER (RADIAN = 57.2957795131)
      REAL UMB(3,3), UTRA(3,3), UTRAU(3,3), UTUINV(3,3)
      REAL ACELL(7), V, DETUTU, REC(6)
      INTEGER IUMBP
C     UMB    = the orientation matrix
C     UTRA   = the transpose of [UMB]
C     UTRAU  = [the transpose of UMB]x[UMB]
C     UTUINV = the inverse of [UTRAU]
C     DETUTU = the determinant of [UTRAU]
C     REC    = a temporary array for calculations I think.  pml
C     ACELL  = holds the cell parameters during calculation
      INTEGER I, J, NADD
      KERR = 0
      IF (ICELLP .EQ. 1) ICELLP = NADD (7)
C     Load the orientation matrix from the chained list into UMB, and
C     calculate its transpose UTRA.
C     NB. the orientation matrix is output by CAD4, and stored in the
C     chained list, by ROWS not COLUMNS.  In UMB and all the other
C     matrices consecutive memory addresses contain values by COLUMNS.
      DO 15 J = 1,3
            DO 10 I = 1,3
                  UMB (I,J) = STORE (IUMBP+ (3*(I-1) + (J-1)) )
                  UTRA(J,I) = UMB(I,J)
10          CONTINUE
15    CONTINUE
C     Calculate UTRAU = [UTRA]x[U]
      CALL MULMAT (UTRA, UMB,
     +                        UTRAU)
C     Calculate UTUINV and DETUTU
      CALL MATINV (UTRAU,
     +                   UTUINV, DETUTU)
      IF (KERR .NE. 0) GO TO 70
      DO 40 I = 1,3
            REC(I) = SQRT (UTRAU(I,I))
            ACELL(I) = SQRT (UTUINV(I,I))
C           Store the cell lengths into ACELL(1) - (3).
40    CONTINUE
      REC(4) = UTRAU(2,3) / (REC(2)*REC(3))
      REC(5) = UTRAU(1,3) / (REC(1)*REC(3))
      REC(6) = UTRAU(1,2) / (REC(1)*REC(2))
C     Store the cell angles (in radians) into ACELL(4)-(6)
      ACELL(4) = UTUINV(2,3) / (ACELL(2)*ACELL(3))
      ACELL(5) = UTUINV(1,3) / (ACELL(1)*ACELL(3))
      ACELL(6) = UTUINV(1,2) / (ACELL(1)*ACELL(2))
C     REC(4) contains cos(alpha), etc
C     V = 1 -cos**2(alpha) -cos**2(beta) -cos**2(gamma)
C           + 2cos(alpha)cos(beta)cos(gamma)
      V = 1.0 -REC(4)*REC(4) -REC(5)*REC(5) -REC(6)*REC(6)
     +        + 2*REC(4)*REC(5)*REC(6)
      V2 = 1.0 -acell(4)*acell(4) -acell(5)*acell(5)
     1         -acell(6)*acell(6)
     +        + 2*acell(4)*acell(5)*acell(6)
      ACELL(7) = ACELL(1)*ACELL(2)*ACELL(3)*SQRT(V2)
C     Convert cell angles from radians to degrees
      DO 50 I= 4,6
            ACELL(I) = ACOS(ACELL(I)) * RADIAN
50    CONTINUE
C     Store the cell parameters into the chained list.
      DO 60 I = 1,7
            STORE(ICELLP+(I-1)) = ACELL(I)
60    CONTINUE
70    CONTINUE
      RETURN
      END
C
C***********************************************************************
      SUBROUTINE MULMAT (A, B,
     +                        C)
C
C     This subroutine multiplies two 3x3 matrices, A and B, giving the
C     answer C;ie      [A]x[B] = [C]
      REAL A(3,3), B(3,3), C(3,3)
      INTEGER I, J, K
      DO 30 I = 1,3
            DO 20 K = 1,3
                  C (I,K) = 0.0
                  DO 10 J = 1,3
                        C(I,K) = C(I,K) + A(I,J)*B(J,K)
10                CONTINUE
20          CONTINUE
30    CONTINUE
C
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE MATINV (A,
     +                     B, DETA)
C
C     This subroutine gives the inverse and determinant of a 3x3 matrix
C                 B    = inv (A)
C                 DETA = det (A)
#include "RC93CM.INC"
      REAL A(3,3), B(3,3), DETA
      INTEGER I,J
      B(1,1) = A(2,2)*A(3,3) - A(3,2)*A(2,3)
      B(2,1) = A(2,1)*A(3,3) - A(3,1)*A(2,3)
      B(3,1) = A(2,1)*A(3,2) - A(3,1)*A(2,2)
      DETA = (A(1,1)*B(1,1)) - (A(1,2)*B(2,1)) + (A(1,3)*B(3,1))
      detb =
     1 a(1,1)*a(2,2)*a(3,3)+a(1,2)*a(2,3)*a(3,1)+a(2,1)*a(3,2)*a(1,3)-
     2 a(3,1)*a(2,2)*a(1,3)-a(2,1)*a(1,2)*a(3,3)-a(1,1)*a(2,3)*a(3,2)
      IF (abs(deta) .le. 1.0e-20) THEN
            WRITE (ISCRN, '(1X,A,f20.18)')
     1 'ERROR -  determinant almost zero', deta
            KERR = 100
            GO TO 40
      END IF
      B(1,2) = A(1,2)*A(3,3) - A(3,2)*A(1,3)
      B(2,2) = A(1,1)*A(3,3) - A(3,1)*A(1,3)
      B(3,2) = A(1,1)*A(3,2) - A(3,1)*A(1,2)
      B(1,3) = A(1,2)*A(2,3) - A(2,2)*A(1,3)
      B(2,3) = A(1,1)*A(2,3) - A(2,1)*A(1,3)
      B(3,3) = A(1,1)*A(2,2) - A(2,1)*A(1,2)
      DO 30 I = 1,3
            DO 20 J = 1,3
                  B(I,J) = ( ((-1.0)**(I+J)) *B(I,J) ) / DETA
20          CONTINUE
30    CONTINUE
40    CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE CENTRE (IUNIT, CINBUF)
C
C     This subroutine takes an input string, centres it within an output
C     buffer *80 and writes it out to the specified channel.
#include "RC93CM.INC"
      CHARACTER*(*) CINBUF
      CHARACTER *80 COUTBF
      INTEGER IOFSET, LENGTH, IUNIT
      COUTBF = ' '
      LENGTH = LENSTR(CINBUF)
      IOFSET = INT( (80 - LENGTH)/2 )
C     NB This calculation is deliberately put into an integer variable
C     so that all the centred lines are biased to the left if they are
C     not exactly centred.
      COUTBF(IOFSET:IOFSET+LENGTH) = CINBUF(:LENGTH)
      WRITE (IUNIT, '(1X,A)') COUTBF(:LENSTR(COUTBF))
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE COMP
C
C     This subroutine outputs a #COMPOSITION instruction to the .SCF
C     file, which enters the scattering factors and atomic properties of
C     those elements in the molecular formula. This is equivalent to the
C     old #LIST 3 and #LIST 29.
C     The path and file name for the scattering factors and atomic
C     properties are held in CSCATT and CATPRO
#include "RC93CM.INC"
      INTEGER I, ICOUNT, NONH, NADD
      REAL VOLMOL, Z, ZEST
30    CONTINUE
C
      WRITE (ISCRN, '(/1X,A)') 'Do you have the molecular formula (y/n)?
     +[y]'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 30
      IF (CLINE(:1) .EQ. 'N') THEN
C           If we don't have the molecular formula, can't do a #COMP.
            GO TO 999
      ELSE IF ((CLINE(:1) .EQ. 'Y') .OR. (CLINE .EQ. CNULL)) THEN
            GO TO 40
      END IF
      GO TO 30
C     Need to prompt user for the molecular formula.
40    CONTINUE
      WRITE (ISCRN,'(1X,A,A/1X,A)')'Enter the molecular formula',
     + ' as At1Num1 At2Num2 etc',
     + '(''Q'' to abandon formula input) '
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 40
      IF (CLINE .EQ. CNULL) THEN
            GO TO 30
      ELSE IF (CLINE(:1) .EQ. 'Q') THEN
            GO TO 999
      END IF
      CALL MOLFOR
C     This will take the input in CLINE and convert it to two arrays,
C     CATOMS(char*2 holding the elements) and NATOMS (int holding the
C     no of each type of atom).
      IF ((KERR .NE. 0) .OR. (NATOMS(1) .EQ. 0)) THEN
            WRITE (ISCRN, '(1X,A)') '!!Formula not recognised!!'
            GO TO 40
      ELSE IF (NATOMS(1). EQ .1) THEN
            ICOUNT = 0
            DO 48 I=1,80
                  IF (NATOMS(I) .NE. 0) ICOUNT= ICOUNT+1
48          CONTINUE
49          CONTINUE
            WRITE (ISCRN, '(/80(3X,A2,I3))') (CATOMS(I), NATOMS(I),
     +                                                      I=1,ICOUNT)
            WRITE (ISCRN, '(1X,A,A)') 'Is this correct? Remember no ',
     +                     'spaces between At1Num1 (ie:C7 not C 7)'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 49
            IF (CLINE(:1) .EQ. 'Y') THEN
                  GO TO 60
            ELSE
                  GO TO 40
            END IF
      END IF
60    CONTINUE
C
C     Now need to estimate Z the number of molecules in the unit cell.
C     Get the number of non-hydrogen atoms, then estimate 18cubic
C     Angstroms for each.
      I = 1
      NONH = 0
62    CONTINUE
      IF (NATOMS(I) .EQ. 0) THEN
            GO TO 65
      ELSE IF (CATOMS(I) .EQ. 'H') THEN
            I = I+1
            GO TO 62
      ELSE
            NONH = NONH+NATOMS(I)
            I = I+1
            GO TO 62
      END IF
65    CONTINUE
C     Estimate molecular volume and Z.
      VOLMOL = 18.0 * NONH
      ZEST = STORE(NWCELP+6) / VOLMOL
      IF (L30P .EQ. 1) L30P = NADD(15)
66    CONTINUE
      WRITE (ISCRN, '(1X, A,A,I2,A)') 'Number of molecules per unit',
     +' cell Z [', NINT(ZEST), ']:-'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 66
      IF (CLINE .EQ. CNULL) THEN
            STORE (L30P+14) = FLOAT (NINT(ZEST))
      ELSE
            READ (CLINE, *, ERR=66) Z
            STORE (L30P+14) = Z
      END IF
C
C     The files specified by CSCATT and CATPRO do actually
C     exist, (this is checked by READIN).
C     Output #COMPOSITION instruction.
      WRITE (ISCFFL, '(''#COMPOSITION'')')
      ICOUNT = 0
      DO 100 I=1,80
            IF (NATOMS(I) .NE. 0) ICOUNT= ICOUNT+1
100    CONTINUE
      WRITE (ISCFFL, '(A,1X,80(A,1X,F7.2,1X))') 'CONTENTS ',
     +                               (CATOMS(I)(:LENSTR(CATOMS(I))),
     +                         (NATOMS(I)*STORE(L30P+14)), I=1,ICOUNT)
      WRITE (ISCFFL, '(A,1X,A)') 'SCATTER', CSCATT(:LENSTR(CSCATT))
      WRITE (ISCFFL, '(A,1X,A)') 'PROPERTIES', CATPRO(:LENSTR(CATPRO))
      WRITE (ISCFFL, '(''END'')')
C
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE GETFIL
C
C     This routine will prompt the user for the input filename and if
C     necessary capitalise it.  It will offer output filenames of the
C     same type as the input and check this with the user.  It will
C     prompt before overwriting any old output files of the same name.
C     It also opens the input and output channels.
#include "RC93CM.INC"
      INTEGER LFILNM, ISTART, IEND
      INTEGER ICHKFL, LSTCHR
      LFILNM = 0
      CLOSE (INPFIL)
      INPLIN = 0
cdjwoct99
      open(IERFIL,file='rc93.err',status='UNKNOWN')
      WRITE(IERFIL,'(1x)')
5     CONTINUE
      WRITE (ISCRN, '(//,1X,A)') 'Please give name of file for processin
     +g, including extension:-'
      WRITE (ISCRN, '(1X,A,/)') '( HELP for help, END if no more files,
     +QUIT to quit )'
      CALL READLN(IKEYBD)
      IF (KERR .NE. 0) GO TO 5
C     Check if response is END, HELP or QUIT (or any case variation of)
      IF (CLINE .EQ. CNULL) THEN
            GO TO 5
      ELSE IF (CLINE .EQ. 'HELP') THEN
            CALL HELP
            GO TO 5
      ELSE IF (CLINE .EQ. 'END') THEN
            LTIDY = 1
            GO TO 999
      ELSE IF (CLINE .EQ. 'QUIT') THEN
            CALL CENTRE (ISCRN,'PROGRAM STOPS : PROCESSING INCOMPLETE')
            CALL CENTRE (IERFIL,'PROGRAM STOPS : PROCESSING INCOMPLETE')
            STOP
      END IF
C     Use the capitalised line if required from the RC93.INI file.
      IF (LCAPPR .EQ. 0) THEN
            CINPFL = CLINE
      ELSE
            CINPFL = CULINE
      END IF
C     Open the input file. USE MTRNLG (DJW)
      CLGFL = CINPFL
      CALL MTRNLG(CLGFL, 'OLD', LENFIL)
      OPEN (INPFIL, FILE=CLGFL(1:LENFIL),
     1  STATUS= 'OLD', ERR=18
C&VAX     2 ,READONLY
     3 )
      CINPFL = CLGFL(1:LENFIL)
      GO TO 19
18    CONTINUE
      WRITE (ISCRN, '(5X, A, A)') 'ERROR OPENING ',
     +                                         CINPFL(:LENSTR(CINPFL))
      WRITE (IERFIL, '(5X, A, A)') 'ERROR OPENING ',
     +                                         CINPFL(:LENSTR(CINPFL))
      GO TO 5
19    CONTINUE
C     If we've already processed a file, we don't need output filenames.
      IF (NRUNS .NE. 0) GO TO 999
C
C     Get the base length of the input file
22    CONTINUE
      LFILNM = LSTCHR(CINPFL)
      WRITE (ISCRN, '(/,1X,A,/,1X,A, A, A,/)') 'Please give the name for
     + output files, WITHOUT the extension:-', '[default = ',
     +CINPFL(:LFILNM), '.***]'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 22
      IF (CULINE .EQ. CNULL) THEN
            COUTFL = CINPFL(:LFILNM)
            GO TO 40
      ELSE
            IF (LCAPPR .EQ. 0) THEN
                  COUTFL = CLINE
            ELSE
                  COUTFL = CULINE
            END IF
      CLGFL = COUTFL
      CALL MTRNLG(CLGFL, 'UNKNOWN', LENFIL)
      OPEN (LISFIL, FILE=CLGFL(1:LENFIL), STATUS ='UNKNOWN', ERR=90)
      COUTFL = CLGFL(1:LENFIL)
            LFILNM = LSTCHR(COUTFL)
C           The line above will strip off any file extensions which
C           are supplied, if this causes conflict with existing files
C           this will be dealt with by ICHKFL
      END IF
C
40    CONTINUE
C     Close all the output channels before attempting to open them.
      WRITE(ISCRN,*) COUTFL
      CLOSE (LISFIL)
      CLOSE (IHKLFL)
      CLOSE (ISCFFL)
      CLOSE (IABSFL)
C     Open the channels for input and output.
      ISTART = LFILNM+1
      IEND = LFILNM+5
      IF (IEND .GT. 80) THEN
            WRITE(ISCRN,'(1X,''ERROR - Filename too long'')')
            WRITE(IERFIL,'(1X,''ERROR - Filename too long'')')
            GO TO 22
      END IF
C     Open the channel for the .LIS file.
      COUTFL(ISTART:IEND) = '.lis'
C     Check if OK to open this file, if not prompt for new filename.
      IF (ICHKFL(LISFIL,COUTFL) .NE. 1) THEN
            GO TO 22
      END IF
      OPEN (LISFIL, FILE=COUTFL, STATUS ='UNKNOWN', ERR=90)
      WRITE(LISFIL,'(A)')
     1'     The JCODEs are:',
     2' 1  normal reflection',
     5' 2  deviates from expected position/peak shape, but not W',
     6' 3  failed non-equal test at least once',
     8' 4  reflection is bad',
     7' 6  flagged weak',
     4' 7  flagged strong S but not flagged D',
     9' 8  flagged strong T but not flagged D',
     3' 9  weak reflection'
C     Open the channel for the .SCF file.
      COUTFL(ISTART:IEND) = '.scf'
      IF (ICHKFL(ISCFFL,COUTFL) .NE. 1) THEN
            GO TO 22
      END IF
      OPEN (ISCFFL, FILE=COUTFL, STATUS='UNKNOWN', ERR=90)
C
C     Open the channel for the .ABS file.
      COUTFL(ISTART:IEND) = '.abs'
      IF (ICHKFL(IABSFL,COUTFL) .NE. 1) THEN
            GO TO 22
      END IF
      OPEN (IABSFL, FILE=COUTFL, STATUS='UNKNOWN', ERR=90)
C     Open the channel for the .HKL file.
      COUTFL(ISTART:IEND) = '.hkl'
      IF (ICHKFL(IHKLFL,COUTFL) .NE. 1) THEN
            GO TO 22
      END IF
      OPEN (IHKLFL, FILE=COUTFL, STATUS='UNKNOWN', ERR=90)
      GO TO 999
C     Error opening one of the files for output.  Warn user and reprompt
C     for the filename.
90    CONTINUE
      WRITE (ISCRN, '(4X, A, A)') 'ERROR OPENING ',
     +                  COUTFL(:LENSTR(COUTFL))
      WRITE (IERFIL, '(4X, A, A)') 'ERROR OPENING ',
     +                  COUTFL(:LENSTR(COUTFL))
      GO TO 22
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE GETPTH (CAPION,
     +                           CFILNM)
C
C     This subroutine reads in the path and filename for the calling
C     routine and returns as CFILNM.
#include "RC93CM.INC"
      CHARACTER*80 CAPION, CFILNM
      IF (CLINE .EQ. CNULL) THEN
            GO TO 30
      ELSE IF (LCAPPR .EQ. 0) THEN
            CFILNM = CLINE(6:)
            GO TO 100
      ELSE
            CFILNM = CULINE(6:)
            GO TO 100
      END IF
30    CONTINUE
C     The path,etc has not been found in the .INI file, so prompt for it
      WRITE (ISCRN, '(1X, A)') 'Please give the filename, and path if ne
     +cessary, for the file containing the ', CAPION
      CALL READLN(IKEYBD)
      IF (KERR .NE. 0) THEN
            GO TO 30
      ELSE IF (LCAPPR .EQ. 0) THEN
            CFILNM = CLINE
      ELSE
            CFILNM = CULINE
      END IF
100   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE HELP
C
C     This routine provides a basic help function in the form of a text
C     file help.hlp.
#include "RC93CM.INC"
      INTEGER J
      CLGFL = CHLPFL
      CALL MTRNLG(CLGFL, 'OLD', LENFIL)
      OPEN( IHLPFL, FILE = CLGFL(1:LENFIL),
     1 STATUS='OLD', ERR=30
C&VAX     2 ,READONLY
     3 )
      CHLPFL = CLGFL(1:LENFIL)
20    CONTINUE
      REWIND (IHLPFL)
      GO TO 40
30    CONTINUE
C     Error opening the HELP.HLP file
      WRITE (ISCRN, '(5X,A,/,5X,A,A,/,5X,A)') 'ERROR - opening the HELP
     +file', 'The current path or filename ', CHLPFL(:LENSTR(CHLPFL)),
     +' specified in the RC93.INI file may be incorrect.'
      GO TO 60
40    CONTINUE
C     Copy 20 lines from the help file to the screen and prompt for more
C     or to quit.
      WRITE (ISCRN, '(//////////)')
      DO 50 J=1,20
            READ (IHLPFL, '(A80)', END=52) CBUFFR
            WRITE (ISCRN, '(1X,A)') CBUFFR
50    CONTINUE
      GO TO 54
52    CONTINUE
C     If the end of the help file has been reached, then don't prompt
C     for 'next?'.
      DO 53 J=1,20
            BACKSPACE (IHLPFL, ERR=20)
53    CONTINUE
      WRITE (ISCRN, '(1X,A)') 'P for previous, Q to quit'
      GO TO 57
54    CONTINUE
      WRITE (ISCRN, '(1X,A)') 'Next ? [P for previous, Q to quit]'
57    CONTINUE
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 54
      IF (CLINE(1:1) .EQ. 'Q') THEN
            GO TO 60
      ELSE IF (CLINE (1:1) .EQ. 'P') THEN
            DO 59 J=1, 40
                  BACKSPACE (IHLPFL, ERR=20)
59          CONTINUE
            GO TO 40
      ELSE
            GO TO 40
      END IF
60    CONTINUE
      CLOSE (IHLPFL)
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE INTENS
C
C     This subroutine deals with records 1 and 2 of an intensity
C     standard reflection.  It will also pick up any int stds which
C     follow the first and group them together.
C     The structure of the chained list is described below
C
C    The intensity standard reflections:-
C     ___________________________________________________
C Ý +0 Ý +1 Ý +2 Ý +3 Ý +4 Ý +5 Ý +6 Ý +7
C Ý +8 Ý
C     ---------------------------------------------------
C     ISTDSP            - P to start of the intensity standard data
C     ISTORE(ISTDSP+0)  - P to next int std reflection
C     ISTORE(ISTDSP+1)  - no of int measurements of this standard
C     ISTORE(ISTDSP+2)  - P to 1st int measurement of this standard
C     ISTORE(ISTDSP+3)  - H
C     ISTORE(ISTDSP+4)  - K
C     ISTORE(ISTDSP+5)  - L
C      STORE(ISTDSP+6)  - Psi
C      STORE(ISTDSP+7)  - the weight of this reflection
C      STORE(ISTDSP+8)  - estimated intensity at xraytime=0
C
C     ISTORE(ISTDSP+0) points to an indentically structured section of
C     the list, holding the same information about the next intensity
C     standard reflection. 'No more standard reflections' is indicated
C     by a pointer here of 0.
C     The intensity measurements of each standard reflection:-
C     ________________________
C       Ý +0 Ý +1 Ý +2 Ý +3 Ý
C     ------------------------
C     The first location (+0) is pointed to by ISTORE(ISTDSP+0) or its
C     equivalent for other standard reflections.
C
C     ISTORE (+0)       - P to next measurement of this std reflection
C     ISTORE (+1)       - Group number of this measurement
C      STORE (+2)       - The intensity, later replaced by the weighted
C                         scale factor for this measurement
C     ISTORE (+3)       - The cumulative xray exposure time for this
C                       - measurement
C     No more measurements of this reflection is denoted by ISTORE(+0)
C     pointing to location 0.
C
C     The pointer to the start of the intensity standards is ISTDSP.
C     NITNS is the no of items stored for a new standard, NITES is the
C     no of items for a new measurement of an existing standard.
C     Each standard has its HKL and Psi values stored, the approximated
C     weight (= I(1) / sigma**2(I(1))) and a space left for the I(0).
#include "RC93CM.INC"
      INTEGER NADD, NITNS, NITES, J, IND(3), NPI, INTBGL, IPEAK, INTBGR
      INTEGER IXRAYT, I, ICURRP, IMESDP, INEWP
      INTEGER IGPREP
      REAL PSI, FOBS, SIGMA, SIGMA2
      PARAMETER ( NITNS = 9, NITES = 6)
      NGROUP = NGROUP +1
      IGPREP = 0
5     CONTINUE
      READ (CARD1,'(9X,3(I5),7X,F7.2,I4,I6,I7,I6)') IND, PSI,
     +                                       NPI, INTBGL, IPEAK,INTBGR
      READ (CARD2, '(51X, I7)') IXRAYT
C     First calculate Fobs (FOBS) and sigma**2(Fobs) (SIGMA2)
      CALL PNSIG (NPI, INTBGL, IPEAK, INTBGR,
     +                                       FOBS, SIGMA)
      SIGMA2 = SIGMA*SIGMA
C
C     Get to the correct standard reflection.
      IF (ISTDSP .EQ. 1) THEN
C           This is the first int std to be encountered, so set ISTDSP.
            ISTDSP = NADD(NITNS)
C           Zero the pointers.
            DO 30 J=1,3
                  ISTORE(ISTDSP+(J-1)) = 0
30          CONTINUE
C           Store the indicies, psi and weight of the first measurement
            DO 40 J=1,3
                  ISTORE (ISTDSP+2+J) = IND(J)
40          CONTINUE
            STORE(ISTDSP+6) = PSI
            STORE(ISTDSP+(NITNS-2)) = ( FOBS / SIGMA2)
C           Zero the base intensity and set the CURRent Pointer
            STORE (ISTDSP+(NITNS-1)) = 0.0
            ICURRP = ISTDSP
            GO TO 110
      ELSE
C           Have some standards stored, chain through to find the
C           appropriate one.  If this is a new standard then add it to
C           the list.
            ICURRP = ISTDSP
50          CONTINUE
            DO 100 J=1,3
C            The Psi values may drift, if they are within 5 degrees
C            either side they are taken as being the same reflection.
                  IF ((ISTORE(ICURRP+2+J) .NE. IND(J)) .OR.
     +            (NINT(STORE(ICURRP+6)*0.1).NE.NINT(PSI*0.1))) THEN
                        IF (ISTORE(ICURRP) .EQ. 0) THEN
C                             This is a new standard.
                              ISTORE(ICURRP) = NADD(NITNS)
                              ICURRP = ISTORE(ICURRP)
C                             Zero the pointers.
                              DO 60 I=1,3
                                    ISTORE(ICURRP+(I-1)) = 0
60                            CONTINUE
C                             Store the indicies, psi & weight
                              DO 70 I=1,3
                                    ISTORE (ICURRP+2+I) = IND(I)
70                            CONTINUE
                              STORE(ICURRP+6) = PSI
                              STORE(ICURRP+NITNS-2) = ( FOBS / SIGMA2 )
C                             Zero base intensity.
                              STORE (ICURRP+NITNS-1) = 0.0
                              GO TO 110
                        ELSE
C                             Set pointer to next standard and compare.
                              ICURRP = ISTORE (ICURRP)
                              GO TO 50
                        END IF
                  END IF
100         CONTINUE
      END IF
C
110   CONTINUE
C     By now we have the pointer ICURRP to the correct standard
C     reflection.  Need to store the measurement.
      IF (ISTORE(ICURRP+2) .NE. 0) THEN
C      Have already got some measurements of this reflection, chain
C      along to the last one, store measurement and update pointers.
            IMESDP = ISTORE (ICURRP+2)
120         CONTINUE
            IF (ISTORE(IMESDP) .NE. 0) THEN
C                 Not the last measurement.
                  IMESDP = ISTORE(IMESDP)
                  GO TO 120
            ELSE
C                 This is the last measurement, set pointer to new
C                 measurement.
                  ISTORE(IMESDP)  = NADD(NITES)
                  INEWP = ISTORE (IMESDP)
                  LSTDSP = INEWP
C                 Store the intensity, xraytime and set pointers.
                  ISTORE(INEWP)   = 0
                  ISTORE(INEWP+1) = NGROUP
C16/5                  ISTORE(INEWP+2) = IGPREP
C16/5                  ISTORE(INEWP+3) = 0
                   STORE(INEWP+2) = FOBS
                  ISTORE(INEWP+3) = IXRAYT
C                 Set pointers in the previous one of this group.
c16/5                  IF (IGPREP .NE. 0) ISTORE(IGPREP+3) = INEWP
c16/5                  IGPREP = INEWP
C                 Increment the no of measurements for this standard.
                  ISTORE(ICURRP+1) = ISTORE (ICURRP+1) + 1
                  GO TO 150
            END IF
      ELSE
C           This is the first measurement for this standard, set
C           pointers and store the measurement.
            ISTORE(ICURRP+1) = ISTORE (ICURRP+1) + 1
            ISTORE(ICURRP+2) = NADD (NITES)
            INEWP            = ISTORE (ICURRP+2)
            LSTDSP           = INEWP
            ISTORE (INEWP)   = 0
            ISTORE (INEWP+1) = NGROUP
c16/5            ISTORE (INEWP+2) = IGPREP
C16/5            ISTORE (INEWP+3) = 0
             STORE (INEWP+2) = FOBS
            ISTORE (INEWP+3) = IXRAYT
C16/5            IGPREP = INEWP
            GO TO 150
      END IF
C     Have now stored this int std.  Get a new card, if it is an int std
C     then go back up and run through most of this again, if not then
C     backspace the input file and return to REC1N2.
150   CONTINUE
      CALL RECORD
      IF (KERR .NE. 0) GO TO 999
      IF (IREC .NE. 2) THEN
            GO TO 999
      ELSE IF (CARD1(26:26) .NE. 'I') THEN
C           This is a rec 1&2 but not an intensity standard
            GO TO 999
      ELSE
C           Cards 1&2 are another intensity standard in this group.
            GO TO 5
      END IF
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE L1N13
C     This subroutine offers the user the choice of first or most
C     recent orientation matrix for List13, and also the chance to
C     alter the unit cell which is input to crystals via List1.
#include "RC93CM.INC"
      INTEGER I, J, K, IUMBP, NADD
      REAL UMBNEW (9), ALTCEL(7), V, FACT, ALPCOS, BETCOS, GAMCOS
      PARAMETER (FACT=0.0174532925)
C     FACT (a conversion factor between degrees and radians) =pi/180
      IF (ISTORE(MINITP) .EQ. 0) THEN
C           No reorientations, don't ask which matrix to use
            IUMBP = MINITP+1
            GO TO 80
      END IF
      WRITE (ISCRN, '(/1X,A,I4,A)')'Crystal Automatically Reorientated',
     +                                         ISTORE(MINITP), ' Times'
10    CONTINUE
      WRITE (ISCRN, '(/1X,A,A)') 'Use Initial or Latest orientation',
     + ' matrix ? [default = initial]'
      WRITE (ISCRN, '(1X,A,A)') '[I-initial, L-latest, N-new ',
     +                                        'matrix, S-show matrices]'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 10
      IF ((CLINE .EQ. CNULL) .OR. (CLINE(:1) .EQ. 'I')) THEN
            IUMBP = MINITP+1
            GO TO 80
      ELSE IF (CLINE(1:1) .EQ. 'L') THEN
            IUMBP = MLASTP
            GO TO 80
      ELSE IF (CLINE(1:1) .EQ. 'N') THEN
15          CONTINUE
            WRITE (ISCRN,'(/1X,A)') 'Input the first ROW of the matrix:'
            READ (IKEYBD, *, ERR=15) (UMBNEW(I), I=1,3)
16          CONTINUE
            WRITE (ISCRN,'(1X,A)')'Input the second ROW of the matrix:'
            READ (IKEYBD, *, ERR=16) (UMBNEW(I), I=4,6)
17          CONTINUE
            WRITE (ISCRN,'(1X,A)') 'Input the third ROW of the matrix:'
            READ (IKEYBD, *, ERR=17) (UMBNEW(I), I=7,9)
            WRITE (ISCRN, '(/1X,''New Matrix:'')')
            DO 18 J=0,2
                  WRITE (ISCRN, '(30X,3(F9.6,1X))')
     +                                   (UMBNEW(I+(J*3)), I=1,3)
18          CONTINUE
19          CONTINUE
            WRITE (ISCRN, '(1X,''Is this correct? [y/n/Q-return to old m
     +atrices]'')')
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 19
            IF (CLINE(:1) .EQ. 'N') THEN
                  GO TO 15
            ELSE IF (CLINE(:1) .EQ. 'Y') THEN
                  GO TO 20
            ELSE IF (CLINE(:1) .EQ. 'Q') THEN
                  GO TO 10
            ELSE
                  GO TO 19
            END IF
20          CONTINUE
C           Store the new matrix by over writing the latest matrix.
            DO 22 J=1,9
                  STORE (MLASTP+J-1) = UMBNEW(J)
22          CONTINUE
            IUMBP = MLASTP
            GO TO 80
      ELSE IF (CLINE(1:1) .EQ. 'S') THEN
            WRITE (ISCRN,'(/3X,''Initial Orientation Matrix'',20X,
     +                         ''Latest Orientation Matrix'')')
            DO 40 J=0, 2
                  WRITE (ISCRN, '(1X,3(F9.6,1X), 15X,3(F9.6,1X))')
     +(STORE(MINITP+I+(J*3)), I=1,3), (STORE(MLASTP+K+(J*3)), K=0,2)
40          CONTINUE
            GO TO 10
      ELSE
            GO TO 10
      END IF
80    CONTINUE
      CALL CELPAR (IUMBP)
      IF (KERR .NE. 0) GO TO 10
C     Have now got the desired orientation matrix, output cell params
C     and prompt for changes.
      DO 90 J=1,7
            ALTCEL (J) = STORE (ICELLP+J-1)
90    CONTINUE
C
91    CONTINUE
      WRITE (ISCRN, '(/1X,''Cell Parameters:'')')
      WRITE (ISCRN,'(1X,4X,A,9X,A,9X,A, 7X,A,6X,A,6X,A,9X,A)')
     + 'a','b', 'c', 'Alpha', 'Beta', 'Gamma', 'Volume'
      WRITE (ISCRN, '(1X,6(F9.4,1X),1X,F15.4)') (STORE(ICELLP+I), I=0,6)
92    CONTINUE
      WRITE (ISCRN, '(/1X,A,A)') 'Alter cell parameters for input',
     +' to Crystals (E-edges / A-angles / n)? [n]'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 91
      IF ((CLINE(:1) .EQ. 'N') .OR. (CLINE .EQ. CNULL)) THEN
            GO TO 120
      ELSE IF (CLINE(:1) .EQ. 'A') THEN
            CALL ALTER('Alpha', 4, ALTCEL)
            CALL ALTER('Beta', 5, ALTCEL)
            CALL ALTER('Gamma', 6, ALTCEL)
            GO TO 110
      ELSE IF (CLINE(:1) .EQ. 'E') THEN
            CALL ALTER('A', 1, ALTCEL)
            CALL ALTER('B', 2, ALTCEL)
            CALL ALTER('C', 3, ALTCEL)
            GO TO 110
      ELSE IF (CLINE(:1) .EQ. 'Y') THEN
            CALL ALTER('A', 1, ALTCEL)
            CALL ALTER('B', 2, ALTCEL)
            CALL ALTER('C', 3, ALTCEL)
            CALL ALTER('Alpha', 4, ALTCEL)
            CALL ALTER('Beta', 5, ALTCEL)
            CALL ALTER('Gamma', 6, ALTCEL)
            GO TO 110
      ELSE
            GO TO 91
      END IF
110   CONTINUE
C       V = 1 -cos**2(alpha{IN RADIANS}) -cos**2(beta) -cos**2(gamma)
C       + 2cos(alpha)cos(beta)cos(gamma)
      ALPCOS = COS (ALTCEL(4)*FACT)
      BETCOS = COS (ALTCEL(5)*FACT)
      GAMCOS = COS (ALTCEL(6)*FACT)
      V = 1.0 -ALPCOS**2 -BETCOS**2 -GAMCOS**2 + 2*ALPCOS*BETCOS*GAMCOS
      ALTCEL(7) = ALTCEL(1)*ALTCEL(2)*ALTCEL(3)*SQRT(V)
      WRITE (ISCRN, '(/1X,4X,A,8X,A,8X,A,6X,A,5X,A,5X,A,9X,A)')
     +              'a', 'b', 'c', 'Alpha', 'Beta', 'Gamma', 'Volume'
      WRITE (ISCRN, '(1X,6(1X,F9.4),1X,F15.4)') (ALTCEL(I), I=1,7)
      GO TO 92
120   CONTINUE
c     Now store the altered cell params in the chained list.
      IF (NWCELP .EQ. 1) NWCELP = NADD(7)
      DO 130 I=1,7
            STORE (NWCELP+I-1) = ALTCEL (I)
130   CONTINUE
C     Now happy with the cell parameters so write them out to list 1.
      WRITE (ISCFFL, '(''#LIST 1'')')
      WRITE (ISCFFL, '(''REAL'',6(1X,F10.4))') (ALTCEL(J), J=1,6)
      WRITE (ISCFFL, '(''END'')')
C
C     Now need to prompt for stuff to go into List 13.
      WRITE (ISCFFL, '(''#LIST 13'')' )
140   CONTINUE
      WRITE (ISCRN,'(/1X,A)')'Do you want to merge Friedel pairs (y/n)?
     +[y]'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 140
      IF ((CLINE(:1) .EQ. 'Y') .OR. (CLINE .EQ. CNULL)) THEN
            WRITE (ISCFFL, '(''CRYSTAL FRIEDEL=YES'')' )
      ELSE IF (CLINE(:1) .EQ. 'N') THEN
            WRITE (ISCFFL, '(''CRYSTAL FRIEDEL=NO'')' )
      ELSE
            GO TO 140
      END IF
C
      WRITE (ISCFFL, '(''DIFFRACTION GEOM='',A)') CMACH
      WRITE (ISCFFL, '(''CONDITION'',A)') CCOND(:LENSTR(CCOND))
      WRITE (ISCFFL,'(''MATRIX '',3(1X,F9.6))')(STORE(IUMBP+J),J=0,2)
      WRITE (ISCFFL,'(''CONT'',3X,3(1X,F9.6))')(STORE(IUMBP+J),J=3,5)
      WRITE (ISCFFL,'(''CONT'',3X,3(1X,F9.6))')(STORE(IUMBP+J),J=6,8)
      WRITE (ISCFFL, '(''END'')' )
      RETURN
      END
C
      SUBROUTINE ALTER (CMESS, IOFSET, ALTCEL)
C     This subroutine offers the current value of the cell parameter
C     as a default, and allows the user to input a new value.
#include "RC93CM.INC"
      INTEGER IOFSET
      REAL ALTCEL (7)
      CHARACTER*(*) CMESS
10    CONTINUE
      WRITE (ISCRN, 1001) CMESS, ALTCEL(IOFSET)
1001  FORMAT (1X,'New value for ',A,' [default= ',F10.5,' ]:-')
      CALL READLN (IKEYBD)
      IF (CLINE .EQ. CNULL) THEN
            GO TO 999
      ELSE
            READ (CLINE, *, ERR=10) ALTCEL(IOFSET)
            IF (NINT(ALTCEL(IOFSET)) .LE. 0.0) GO TO 10
      END IF
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE LIST27
C     This deals with the smoothing and output of the intensity
C     standards into a Crystals List 27.
C     The structure of the chained list is described at the end.
#include "RC93CM.INC"
C     Check if have any standards stored.
      IF (ISTDSP .EQ. 1) THEN
            WRITE (ISCRN, '(/1X,A)') 'NO INTENSITY STANDARDS STORED'
            WRITE (ISCRN, '(1X,A)') 'No List 27 will be written out'
            GO TO 999
      END IF
C     Estimate I(0) for each standard
      CALL SMTH5
C     Check that still have some valid standards left to use.
      IF (ISTDSP .EQ. 1) THEN
            WRITE (ISCRN, '(/1X,A)') 'NO INTENSITY STANDARDS STORED'
            GO TO 999
      END IF
C Scale each int measurement and store the scale factors in the chain
      CALL SCALE1
C     Calc group scale factors and store them in the chain
      CALL SCALE2
10    CONTINUE
      WRITE (ISCRN, '(1X,''Intensity Standard '',
     1 ''Default discontinuity factor'',
     + '' 0.1 (ie. 10%) (y/n)? [y]'')')
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 10
      IF ((CLINE .EQ. CNULL) .OR. (CLINE (:1) .EQ. 'Y')) THEN
            DISFAC = 0.1
      ELSE
15        CONTINUE
          IF (CLINE(:1) .EQ. 'N') THEN
            WRITE (ISCRN, '(1X,A)') 'Enter discontinuity factor :-'
            READ (IKEYBD, *, ERR=15) DISFAC
            IF ((DISFAC .LE. 0.0) .OR. (DISFAC .GE. 1.0)) THEN
                  WRITE (ISCRN, '(1X,A,A)') 'Must be a number between',
     +                          ' 0 and 1'
                  GO TO 15
            END IF
          ELSE
            GO TO 15
          ENDIF
      END IF
C     Smooth the group scale factors, but not over discontinuities.
CDJWDEC99 NEW SMOOTHING ROUTINE WRITTEN TO OVERCOME ADDRESS ERRORS
      CALL SMTH3B
C     Write out a #LIST 27 instruction to the .SCF file.
CDJWDEC99 NEW SMOOTHING ALSO WRITES LIST27
C      CALL WRL27
999   CONTINUE
      RETURN
      END
C*********************************************************************
      SUBROUTINE SMTH5
C     This subroutine uses 5 point smoothing to estimate the intensity
C     of each standard reflection at x-raytime=0.
#include "RC93CM.INC"
      INTEGER J,K, IPNTP, IDATP, IOLDP, ITEMP
      INTEGER RINTEN(3), ZERINT
C     Get the first three recorded intensities for each standard and use
C     these to estimate I(0).
C                  I(0) approx= (11*I(1) + 4*I(2) + I(3)) / 16
C
      IPNTP = ISTDSP
      IOLDP = ISTDSP
C     Loop through here for each standard stored.
30    CONTINUE
C     If we have less than 3 measurements then adjust pointers to
C     completely skip this standard.
      IF (ISTORE(IPNTP+1) .LT. 3) THEN
            WRITE(ISCRN,'(1X,A,3(I4,1X),F5.2,A)')'Intensity Standard ',
     +      (ISTORE(IPNTP+2+J),J=1,3), STORE(IPNTP+6),
     +      'Too few measurements - SKIPPED'
            IF (IOLDP .EQ. ISTDSP) THEN
                  IF (ISTORE(ISTDSP) .EQ. 0) THEN
C                       No useful standards stored.
                        ISTDSP = 1
                        GO TO 999
                  END IF
                  ISTDSP = ISTORE(ISTDSP)
                  IPNTP = ISTDSP
                  GO TO 30
            ELSE
                  ISTORE(IOLDP) = ISTORE(IPNTP)
                  IF (ISTORE(IPNTP) .EQ. 0) THEN
C                       No more standards, adjust LSTDSP.
                        ITEMP = ISTORE (IOLDP+2)
35                      CONTINUE
                        IF (ISTORE(ITEMP) .EQ. 0) THEN
                              LSTDSP = ITEMP
                              GO TO 999
                        ELSE
                              ITEMP = ISTORE(ITEMP)
                              GO TO 35
                        END IF
                  ELSE
                        IPNTP = ISTORE(IPNTP)
                        GO TO 30
                  END IF
            END IF
      END IF
C     Set IDATP to the first int measurement
      IDATP = ISTORE(IPNTP+2)
C     Read the first three intensity measurements into RINTEN
      DO 40 K=1,3
            RINTEN(K) = STORE(IDATP+2)
            IDATP = ISTORE(IDATP)
40    CONTINUE
C     Estimate I(0) and store it into the chained list.
      ZERINT = (11.0*RINTEN(1) + 4.0*RINTEN(2) + RINTEN(3)) / 16.0
      STORE (IPNTP+8) = ZERINT
C     Set IPNTP to the next standard
      IF (ISTORE(IPNTP) .EQ. 0) THEN
C           No more standards
            GO TO 999
      ELSE
            IPNTP = ISTORE (IPNTP)
            GO TO 30
      END IF
999   CONTINUE
      RETURN
      END
C***********************************************************************
      SUBROUTINE SCALE1
C     This subroutine converts each of the intensity measurements for
C     each standard into a weighted scale factor.
C     The scale factor for the jth measurement of the ith standard is
C                  SCALE(i,j) = X(i,0) / X(i,j)
C     These are then weighted with the stored weight.
#include "RC93CM.INC"
      INTEGER IPNTP, IDATP
      REAL ZERINT, WEIGHT
      IPNTP = ISTDSP
      IF (ISTDSP .EQ. 1) GO TO 999
10    CONTINUE
      IF (IPNTP .EQ. 0) GO TO 999
      ZERINT = STORE (IPNTP+8)
      WEIGHT = STORE (IPNTP+7)
      IDATP = ISTORE(IPNTP+2)
20    CONTINUE
      STORE (IDATP+2) = (ZERINT / STORE(IDATP+2)) * WEIGHT
      IF (ISTORE(IDATP) .EQ. 0) THEN
C           No more measurements for this standard.
            IPNTP = ISTORE(IPNTP)
            GO TO 10
      ELSE
            IDATP = ISTORE(IDATP)
            GO TO 20
      END IF
999   CONTINUE
      RETURN
      END
C***********************************************************************
      SUBROUTINE SCALE2
C     This subroutine uses the weights and weighted scale factors in the
C     chained list to calculate average weighted scale factors for each
C     group of standards, along with the averaged time for the group
C     scale factor.
C     The group scale factors and xraytime are stored in the chained
C     list. IGSCFP points to the first of them.
#include "RC93CM.INC"
      INTEGER LGSCFP, ITGSCF
      INTEGER NADD
      INTEGER IPNTP, IDATP, IGRPNO, ISUMXT, NOING, MEANXT
      REAL SUMWSF, SUMWTS, GRPSCF
      ITGSCF = 4
      IGRPNO = 1
      IF (ISTDSP .EQ. 0) GO TO 999
10    CONTINUE
      SUMWSF = 0.0
      SUMWTS = 0.0
      ISUMXT = 0.0
      NOING = 0
      IPNTP = ISTDSP
20    CONTINUE
C     Loop through here for each standard reflection stored.
      IF (IPNTP .EQ. 0) GO TO 40
      IDATP = ISTORE(IPNTP +2)
25    CONTINUE
C     Loop through here for each measurement of a reflection until the
C     group numbers match.
      IF (ISTORE(IDATP+1) .NE. IGRPNO) THEN
            IF (ISTORE(IDATP) .EQ. 0) THEN
C                 No more measurements of this refln, get next
                  IF (IDATP .EQ. LSTDSP) THEN
                        IF (NOING .GT. 0) THEN
                              GO TO 40
                        ELSE
                              GO TO 999
                        END IF
                  END IF
                  IPNTP = ISTORE(IPNTP)
                  GO TO 20
            END IF
C           Not the last measurement, so try the next one.
            IDATP = ISTORE(IDATP)
            GO TO 25
      ELSE
C           Have found a reflection in the correct group.
            NOING = NOING +1
            SUMWSF = SUMWSF + STORE(IDATP+2)
            ISUMXT = ISUMXT + ISTORE(IDATP+3)
            SUMWTS = SUMWTS + STORE(IPNTP+7)
C           Set pointers to next standard.
            IPNTP = ISTORE(IPNTP)
            GO TO 20
      END IF
C
40    CONTINUE
C     Have now used all stored standards in group IGRPNO.
      GRPSCF = SUMWSF / SUMWTS
      MEANXT = NINT( FLOAT(ISUMXT) / NOING)
C     Set pointers to store these in the chain list.
      IF (IGSCFP .EQ. 1) THEN
C           This is the first group scale factor.
            IGSCFP = NADD (ITGSCF)
            LGSCFP = IGSCFP
      ELSE
C           Not the first, so set pointer in previous grp.scale.fact.
            ISTORE(LGSCFP) = NADD(ITGSCF)
            LGSCFP = ISTORE(LGSCFP)
      END IF
C     Store the values
      ISTORE (LGSCFP) = 0
       STORE(LGSCFP+1) = GRPSCF
      ISTORE(LGSCFP+ITGSCF-1) = MEANXT
      IGRPNO = IGRPNO +1
      GO TO 10
999   CONTINUE
      RETURN
      END
C************************************************************************
      SUBROUTINE SMTH3
C     This subroutine uses 3 point smoothing to smooth the raw group
C     scale factors.  It doesn't smooth over discontinuities greater
C     than DISFAC (10% by default), but estimates before and after
C     values and outputs them with the same xraytime.
C            smoothed sf(i) = (sf(i-1)+ 2*sf(i) +sf(i+1)) / 4
C     The value at xrayt=0 is estimated using the gradient of the first
C     2 points.
#include "RC93CM.INC"
      INTEGER ITGSF, IRAWXT (3), IPNTSP(3), LEND, NADD
      REAL RAWSCF (3), GRAD, RAWNEW
      PARAMETER (ITGSF = 4)
      LEND = 0
C     Estimate the group scale factor for xrayt=0.
      RAWSCF (1) = 0.0
      IRAWXT (1) = 0
      RAWSCF (2) = STORE (IGSCFP+1)
      IRAWXT (2) = ISTORE(IGSCFP+3)
      IPNTSP (2) = IGSCFP
      IPNTSP (3) = ISTORE (IGSCFP)
      RAWSCF (3) = STORE (IPNTSP(3)+1)
      IRAWXT (3) = ISTORE (IPNTSP(3)+3)
C     If the difference between two scale factors is greater than the
C     average*DISFAC then a discontinuity has been found.
      IF (ABS(RAWSCF(2)-RAWSCF(3)).GT.((RAWSCF(2)+RAWSCF(3))*DISFAC/2))
     +                                                             THEN
C           If there is a discontinuity between the first two raw sf's
C           then the sf at xrayt=0 is assumed the same as the first raw
C           scale factor.
            RAWSCF (1) = RAWSCF (2)
      ELSE
C           Otherwise it is estimated by the gradient between the first
C           two raw sf's.
C----- CHECK FOR ZERO TIME INTERVAL - PROBABLY FALSE START
           IF ((IRAWXT (3) - IRAWXT(2)) .EQ. 0) THEN
            GRAD = 0.0
           ELSE
            GRAD = (RAWSCF(3) - RAWSCF(2)) / (IRAWXT (3) - IRAWXT(2))
           ENDIF
            RAWSCF (1) = (-IRAWXT(2) * GRAD) + RAWSCF(2)
      END IF
C     Now store the estimated value in the chained list, in front of the
C     first value.
      IPNTSP(1) = NADD(ITGSF)
      ISTORE(IPNTSP(1))   = IGSCFP
C**      ISTORE(IPNTSP(1)+1) = 1001
       STORE(IPNTSP(1)+1) = RAWSCF(1)
       STORE(IPNTSP(1)+2) = RAWSCF(1)
      ISTORE(IPNTSP(1)+3) = 0
      NUMGSF = NUMGSF +1
      IGSCFP = IPNTSP(1)
      GO TO 40
20    CONTINUE
      IF (LEND .EQ. 1) GO TO 999
C     We now have RAWSCF and IRAWXT loaded with 3 consecutive values.
C     Will probably want to loop through here
C     Is there a discontinuity between RAWSCF 1 and 2 ?
      IF (ABS(RAWSCF(1)-RAWSCF(2)).GT.((RAWSCF(1)+RAWSCF(2))*DISFAC/2))
     +                                                             THEN
C           Yes. Make 'extrapolated' value = known value,store raw known
C           value as smoothed known value, store new value in
C           the appropriate place in the chained list. Then shuffle the
C           values down and get a new rawscf(3).
            STORE (IPNTSP(1)+2) = RAWSCF(1)
            NUMGSF = NUMGSF +1
C           Call INSERT (CURR_POINTER, SCALE_FACTOR, XRAYT)
            CALL INSERT (IPNTSP(1), RAWSCF(1), IRAWXT(2) )
C           Call SHUFFL (NEW_POINTER_TO_1 )
            CALL SHUFFL ( 2,
     +                      IPNTSP, RAWSCF, IRAWXT, LEND)
            GO TO 20
      END IF
C     Smooth 1 using 1&2.
      STORE (IPNTSP(1)+2) = (3*RAWSCF(1) + RAWSCF(2)) / 4.0
      NUMGSF = NUMGSF +1
C
40    CONTINUE
      IF (LEND .EQ. 1) GO TO 999
      IF (ABS(RAWSCF(2)-RAWSCF(3)).GT.((RAWSCF(2)+RAWSCF(3))*
     +                                                   DISFAC/2)) THEN
C           Is there a discontinuity between 2 and 3? If yes, use
C           1&2 to smooth 2, use gradient 1 -> 2 to estimate new value
C           store this in the correct place in the chain, make raw3 the
C           new raw1 and load in new values for raw2 and 3.
            STORE (IPNTSP(2)+2)= (RAWSCF(1) + 3*RAWSCF(2)) / 4.0
            NUMGSF = NUMGSF +1
            GRAD = (RAWSCF(2) - RAWSCF(1)) / (IRAWXT (2) - IRAWXT(1))
            RAWNEW = (GRAD*(IRAWXT(3)-IRAWXT(2))) + RAWSCF(2)
C           Now need to store the new value in the proper place in the
C           chained list.
            CALL INSERT (IPNTSP(2), RAWNEW, IRAWXT(3))
            CALL SHUFFL ( 3,
     +                      IPNTSP, RAWSCF, IRAWXT, LEND)
            GO TO 20
      ELSE
C           No discontinuities, use 1,2&3 to smooth 2, store it and
C           shuffle along.
            STORE (IPNTSP(2)+2) = (RAWSCF(1)+2*RAWSCF(2)+RAWSCF(3))/ 4.0
            NUMGSF = NUMGSF +1
            CALL SHUFFL ( 2,
     +                      IPNTSP, RAWSCF, IRAWXT, LEND)
            GO TO 40
      END IF
999   RETURN
      END
C
C
      SUBROUTINE SHUFFL (IPNTP,
     +                         IPNTSP, RAWSCF, IRAWXT, LEND)
C     This subroutine loads three consecutive raw int stds starting from
C     IPNTP, their pointers and xraytimes into the appropriate arrays.
#include "RC93CM.INC"
      INTEGER IPNTP, IPNTSP(3), IRAWXT(3), LEND
      REAL RAWSCF(3)
      IF (IPNTP .EQ. 0 ) THEN
            PRINT *,'ERROR IN SMTH3 (SHUFFL)'
      END IF
      IF (ISTORE(IPNTSP(3)) .EQ. 0) THEN
C           The three stds stored in RAWSCF are the last in the list.
            IF (IPNTP .EQ. 2) THEN
C                 Either no disc.'s or at least a disc. between 1&2.
                  IF (ABS(RAWSCF(2)-RAWSCF(3)) .GT.
     +                        ((RAWSCF(2)+RAWSCF(3))* DISFAC/2)) THEN
C                       Disc. between 2&3,must be one between 1&2 so
C                       cant use gradient to extrapolate 2. Insert a
C                       new value equal to 2 and dont smooth 3.
                        STORE(IPNTSP(2)+2) = RAWSCF(2)
                        NUMGSF = NUMGSF +1
                        CALL INSERT (IPNTSP(2), RAWSCF(2), IRAWXT(3))
                        STORE(IPNTSP(3)+2) = RAWSCF(3)
                        NUMGSF = NUMGSF +1
                        LEND = 1
                        GO TO 999
                  ELSE IF (ABS(RAWSCF(1)-RAWSCF(2)) .GT.
     +                        ((RAWSCF(1)+RAWSCF(2))* DISFAC/2)) THEN
C                       Disc. between 1&2, but not 2&3, smooth 2 and 3
C                       using each other.
                        STORE(IPNTSP(2)+2)=(3*RAWSCF(2)+RAWSCF(3))/4.0
                        NUMGSF = NUMGSF +1
                        STORE(IPNTSP(3)+2)=(RAWSCF(2)+3*RAWSCF(3))/4.0
                        NUMGSF = NUMGSF +1
                        LEND = 1
                        GO TO 999
                  ELSE
C                       No discontinuities, just smooth 3.
                        STORE(IPNTSP(3)+2)=(RAWSCF(2)+3*RAWSCF(3))/4.0
                        NUMGSF = NUMGSF +1
                        LEND = 1
                        GO TO 999
                  END IF
            ELSE IF (IPNTP .EQ. 3) THEN
C                 Disc. between 2&3 but not 1&2, cant smooth 3.
                  STORE(IPNTSP(3)+2) = RAWSCF(3)
                  NUMGSF = NUMGSF +1
                  LEND = 1
                  GO TO 999
            ELSE
                  WRITE(ISCRN,'(A,I3)')
     1            'ERROR SMTH3, CALLED WITH IPNTP=',IPNTP
                  WRITE(IERFIL,'(A,I3)')
     1            'ERROR SMTH3, CALLED WITH IPNTP=',IPNTP
                  STOP
            END IF
      ELSE
C           The standards in RAWSCF are not the last in the list, get
C           next consecutive ones starting with IPNTP.
            IPNTSP(1) = IPNTSP(IPNTP)
            RAWSCF(1) = STORE(IPNTSP(1)+1)
            IRAWXT(1) = ISTORE(IPNTSP(1)+3)
            IPNTSP(2) = ISTORE(IPNTSP(1))
            RAWSCF(2) = STORE(IPNTSP(2)+1)
            IRAWXT(2) = ISTORE(IPNTSP(2)+3)
            IPNTSP(3) = ISTORE(IPNTSP(2))
            RAWSCF(3) = STORE(IPNTSP(3)+1)
            IRAWXT(3) = ISTORE(IPNTSP(3)+3)
            GO TO 999
      END IF
999   CONTINUE
      RETURN
      END
C
C
      SUBROUTINE INSERT (IFRNTP, SCFACT, IRAYT)
C     This subroutine inserts an estimated value into the chained list
C     after the value pointed to by ICURRP.
      INTEGER IFRNTP, IRAYT, NITGSF, ITEMPP, NADD
      PARAMETER (NITGSF = 5)
      REAL SCFACT
#include "RC93CM.INC"
      ITEMPP = ISTORE(IFRNTP)
      ISTORE(IFRNTP) = NADD (NITGSF)
      ISTORE(ISTORE(IFRNTP)) = ITEMPP
      ITEMPP = ISTORE(IFRNTP)
      STORE(ITEMPP+1) = SCFACT
      STORE(ITEMPP+2) = SCFACT
      NUMGSF = NUMGSF +1
      ISTORE(ITEMPP+3)= IRAYT
      RETURN
      END
C
      SUBROUTINE WRL27
C     This subroutine writes out the #LIST 27 to the .SCF file
#include "RC93CM.INC"
      INTEGER JGSCFP, J
      JGSCFP = IGSCFP
      WRITE (ISCFFL, '(''#LIST 27'')')
      WRITE (ISCFFL, '(''READ NSCALE='', I6)') NUMGSF
      DO 55 J=0, NUMGSF-1
            WRITE (ISCFFL, 1007) J, STORE(JGSCFP+1), STORE(JGSCFP+2),
     +                                                  ISTORE(JGSCFP+3)
1007        FORMAT ('SCALE', 1X, I5, 2(1X, F7.3), 1X, I7)
            JGSCFP = ISTORE (JGSCFP)
55    CONTINUE
      WRITE (ISCFFL, '(''END'')')
      RETURN
      END
C
C    This section describes the structure of the  chained list.
C    The group scale factors:-
C     ___________________________________________________
CÝ +0 Ý +1 Ý +2 Ý +3 Ý +4 Ý +5 Ý +6 Ý +7
CÝ +8 Ý
C     ---------------------------------------------------
C
C     IGSCFP            - start of the group scale factors
C     IGSCFP(+0)        - P to start of next group scale factor
C     IGSCFP(+1)        - raw scale factor for this group
C     IGSCFP(+2)        - smoothed group scale factor
C     IGSCFP(+3)        - mean xray time for this group
C
C     ISTORE(IGSCFP+0) points to an indentically structured section of
C     the list, holding the same information about the next group scale
C     factor. 'No more group scale factors' is indicated by a pointer
C     here of 0.
C
C***********************************************************************
C
      SUBROUTINE LIST30
C     This subroutine prompts the user for information to go into List30
C     and stores this in the chained list. Other routines also store
C     list 30 info which can be worked out automatically.  The actual
C     output of the #LIST 30 instruction is done by subroutine WRL30.
#include "RC93CM.INC"
      REAL DIMEN(3), TEMP, ATEMP(2), SPHMIN, TOTX, ABS, DEN, AMOLWT
      REAL SPHMAX
      INTEGER I, J, NADD
      REAL FACTOR, E
      PARAMETER (FACTOR = 1.66057, E = 2.718281828)
      IF (L30P .EQ. 1) L30P = NADD(15)
10    CONTINUE
      WRITE (ISCRN, '(1X,A)') 'Please give crystal dimensions (mm):-'
      READ (IKEYBD, *, ERR=10) DIMEN
C     Sort so that DIMEN(1) is smallest
      DO 40 J=1,2
            DO 30 I=1,2
                  IF (DIMEN(I) .GT. DIMEN(I+1)) THEN
                        TEMP = DIMEN(I+1)
                        DIMEN (I+1) = DIMEN (I)
                        DIMEN (I)   = TEMP
                  END IF
30          CONTINUE
40    CONTINUE
      DO 50 I=1,3
            STORE (L30P+I-1) = DIMEN(I)
50    CONTINUE
C
C     Now get no. of orientating reflections and theta max, min for
C     orientation.
C     The default is estimated from the refdump.
60    CONTINUE
      WRITE (ISCRN, '(1X,A,A,I3,A)') 'Please give number of',
     +' orientating reflections [', NINT(STORE(L30P+3)), ']:-'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 60
      IF (CLINE .EQ. CNULL) THEN
            GO TO 70
      ELSE
            READ (CLINE, *, ERR= 60) TEMP
            IF ((TEMP .LT. 0) .OR. (TEMP .GT. 25)) GO TO 60
            STORE (L30P+3) = TEMP
      END IF
70    CONTINUE
      WRITE (ISCRN, '(1X,A,A,F6.2,A,F6.2,A)') 'Please give min and max',
     +' theta of orientating reflections [', STORE (L30P+4), ',',
     + STORE (L30P+5), ']:-'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 70
      IF (CLINE .EQ. CNULL) THEN
            GO TO 90
      ELSE
            READ (CLINE, *, ERR=70) ATEMP
            IF (ATEMP (1) .GT. ATEMP(2)) THEN
                  TEMP = ATEMP(1)
                  ATEMP(1) = ATEMP(2)
                  ATEMP(2) = TEMP
            END IF
            DO 80 J=1, 2
                  IF ((ATEMP(J) .LT. 0.0) .OR. (ATEMP(J) .GT. 78)) THEN
                        GO TO 70
                  ELSE
                        STORE (L30P+3+J) = ATEMP(J)
                  END IF
80          CONTINUE
      END IF
C
C     Now get temperature.
90    CONTINUE
      STORE (L30P+6) = 20.0 + 273.0
      WRITE (ISCRN, '(1X,A)') 'Temperature of the experiment, degrees,
     1 Kelvin. (293)'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 90
      IF (CLINE .EQ. CNULL) THEN
            GO TO 200
      ELSE
            READ (CLINE, *, ERR= 90) TEMP
            IF ((TEMP .LT. 0.0) .OR. (TEMP .GT. 400)) THEN
            WRITE (ISCRN, '(1X,A)') 'Are you SURE ? (Nb. temp in degrees
     + K)'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0 ) GO TO 90
              IF (CLINE(:1) .EQ. 'Y') THEN
                  STORE (L30P+6) = TEMP
              ELSE
                  GO TO 90
              END IF
            ELSE
              STORE (L30P+6) = TEMP
            END IF
      END IF







C
C     Now get the observed density.
200   CONTINUE
      WRITE (ISCRN, '(1X,A,A)') 'Observed density (g/cm**3)',
     +                          ' [0.0 if unknown]:-'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 200
      IF (CLINE .EQ. CNULL) THEN
            STORE (L30P+9) = 0.0
      ELSE
            READ (CLINE, *, ERR=200) TEMP
            IF (TEMP .LT. 0.0) THEN
                  GO TO 200
            ELSE
                  STORE (L30P+9) = TEMP
            END IF
      END IF
C
C     Now calulate the molecular weight
      AMOLWT = 0.0
      I = 1
270    CONTINUE
      IF (NATOMS(I) .EQ. 0) THEN
            STORE (L30P+13) = AMOLWT
            GO TO 275
      ELSE
            AMOLWT = AMOLWT +(NATOMS(I) * ATOMWT(I))
            I = I+1
            GO TO 270
      END IF
C
275    CONTINUE
C     Calculate density as a simple check for the user that it is a
C     sensible value.
C     1amu = 1.66057 * 10e-27 kg , so density is in g/cm**3
C     density = ((molwt * 1.66057) * Z ) / cell volume
      IF (NINT(AMOLWT) .EQ. 0) THEN
C           Have not got mol formula so can't calculate density,
C           mu, ratio mumin/mumax,mol weight or Z.
            STORE (L30P+10) = 0.0
            STORE (L30P+11) = 0.0
            STORE (L30P+12) = 0.0
            STORE (L30P+13) = 0.0
            STORE (L30P+14) = 0.0
            GO TO 400
      ELSE
            DEN=((AMOLWT * FACTOR)*STORE(L30P+14)) / STORE (NWCELP+6)
            STORE (L30P+10) = DEN
      END IF
C
C     Don't bother to calculate F000 as Crystals does this.
C
C     Calculate Mu*R for the spherical absorption factor
C     This calculation is lifted from RC85.
C     R is estimated as half the smallest crystal dimension.
      TOTX = 0.0
      DO 300 J=1, I-1
            IF (XSECT(J) .LT. 0.0) GO TO 400
            TOTX = TOTX + (NATOMS (J) * (XSECT(J)*10))
C           XSECT is multiplied by 10 to give compatibility between the
C           old DATA statements of RC85 and the atomic properties file
C           of Crystals.
300   CONTINUE
C     Cross section is in barns/atom (10e-24cm**2), vol is 10e-24cm**3
C     hence abs coeff is in cm**-1.
C     abs = Z * cross section / volume
      ABS = STORE(L30P+14) * TOTX / STORE (NWCELP+6)
      STORE (L30P+11) = ABS
C     The min crystal dimension is in mm, so divide by 10 to get cm
C     and divide by 2 for the radius not the diameter.
C     sphmin = abs * (min dimension / 20.0)
      SPHMIN = ABS * STORE(L30P)   / 20.0
      SPHMAX = ABS * STORE(L30P+2) / 20.0
C     Store(L30P+12) holds the ratio of intensity through min:max
C     crystal dimensions.
C     I(min) = I(0) * e**(-abs cross section * min dimension)
C     ratio I(min) / I(max) = e ** (abs cross section*(max -min))
C     Higher absorption leads to a higher value for the ratio, and
C     means that the spherical absorption correction will be less
C     useful as it is based on the smallest dimension only.
C     If the ratio >2 the user is warned in the tidyup section.
      STORE (L30P+12) = E ** ( SPHMAX - SPHMIN)
C     Now get the colour and shape of the crystal.
400   CONTINUE
      WRITE (ISCRN,'(1X,A)')'Colour of crystal [ default=colourless ] ?'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 400
      IF (CLINE .EQ. CNULL) THEN
            COLOUR = 'COLOURLESS'
      ELSE
            COLOUR = CLINE
      END IF
C
500   CONTINUE
      AS = STORE(L30P+0)
      AM = STORE(L30P+1)
      AL = STORE(L30P+2)
      IF (AL - AS .LE. .1*AL ) THEN
            CSHAPE = 'CUBE'
      ELSE IF ((AL-AM) .LE. (AM-AS)) THEN
            IF (AM .LT. 2.*AS) THEN
                  CSHAPE = 'BLOCK'
            ELSE
                  CSHAPE = 'PLATE'
            ENDIF
      ELSE
            IF (AL .LE. 2.*AM) THEN
                  CSHAPE = 'BLOCK'
            ELSE
                  CSHAPE = 'PRISM'
            ENDIF
      ENDIF
      WRITE (ISCRN,'(1X,A,A,A)')
     1 'Shape of crystal [ default= ',CSHAPE(:LENSTR(CSHAPE)), ' ] ?'
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 500
      IF (CLINE .NE. CNULL) THEN
            CSHAPE = CLINE
      END IF
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE LIST31
C     This subroutine prompts the user for the information required
C     for List31, the unit cell esd's and writes them out to the
C     .SCF file.
#include "RC93CM.INC"
      REAL ESDS(6), FACT
      PARAMETER (FACT = 0.01745329252)
C     FACT = pi/180
      INTEGER I, NADD
      IF (IESDSP .EQ. 1) IESDSP = NADD(6)
10    CONTINUE
      WRITE (ISCRN, '(1X,A/1X,A)') 'Please give the unit cell esd''s:-',
     + '(in the order A B C Alpha Beta Gamma)'
      READ (IKEYBD, *, ERR=10) ESDS
C     Do a quick check for very large or effectively zero esd's
      DO 20 I=1, 6
            IF (ESDS(I) .GT. 0.5) GO TO 100
            IF (ESDS(I) .LT. 0.00001) GO TO 110
20    CONTINUE
c
40    CONTINUE
C     Now store esds in chained list.
      DO 30 I=1,6
            STORE(IESDSP+I-1) = ESDS(I)
30    CONTINUE
C
C     Write out #list 31 instruction.
      WRITE (ISCFFL, '(''#LIST 31'')' )
      WRITE (ISCFFL, '(''AMULT 0.01'')' )
C     AMULT is a factor which Crystals applies to the values in the
C     matrix.
C     The diagonal elements of the matrix are the cell esd's SQUARED.
C     The cell edge esd's must be in Angstroms, the angles in RADIANS
C     As output by CAD4 the edge esd's are in Angstrom, angles in
C     degrees.
      DO 45 I=4,6
C           Convert degrees to radians. FACT = pi/180
            ESDS(I) = ESDS(I) * FACT
45    CONTINUE
      DO 50 I=1,6
            ESDS(I) = (ESDS(I) * ESDS(I)) * 100.00
50    CONTINUE
      WRITE (ISCFFL, '(A, 6(1X,F10.8))') 'MATRIX', ESDS(1), 0.0, 0.0,
     +                                                 0.0, 0.0, 0.0
      WRITE (ISCFFL, '(''CONT'',2X,11X,5(1X, F10.8))') ESDS(2), 0.0,
     +                                                0.0, 0.0, 0.0
      WRITE (ISCFFL, '(''CONT'',2X,22X,4(1X,F10.8))') ESDS(3), 0.0, 0.0,
     +                                                         0.0
      WRITE (ISCFFL, '(''CONT'',2X,33X,3(1X,F10.8))') ESDS(4), 0.0, 0.0
      WRITE (ISCFFL, '(''CONT'',2X,44X,2(1X,F10.8))') ESDS(5), 0.0
      WRITE (ISCFFL, '(''CONT'',2X,55X,1X, F10.8)')   ESDS(6)
      WRITE (ISCFFL, '(''END'')' )
      GO TO 999
C
100   CONTINUE
      WRITE (ISCRN, '(1X,A,A)') 'Very high esd''s, are you sure',
     +                                                  ' (y/n/q-quit)?'
      GO TO 120
110   CONTINUE
      WRITE (ISCRN, '(1X,A,A)') 'One or more esd''s of zero, are you',
     +  ' sure (y/n/q-quit)?'
120   CONTINUE
      CALL READLN (IKEYBD)
      IF (KERR .NE. 0) GO TO 100
      IF (CLINE(:1) .EQ. 'Q') THEN
            WRITE (ISCRN, '(1X,A,A)') 'WARNING - No List 31 written',
     +                                     ' to .SCF file'
            GO TO 999
      ELSE IF (CLINE(:1) .EQ. 'N') THEN
            GO TO 10
      ELSE IF (CLINE(:1) .EQ. 'Y') THEN
            GO TO 40
      ELSE
            GO TO 100
      END IF
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE MAINDA
C     This subroutine does the processing of each card if the file
C     contains the main reflection data.
#include "RC93CM.INC"
      INTEGER I, NADD
      CALL CENTRE (ISCRN, '-- PROCESSING INTENSITY DATA -- ')
      IF (ISTATP .EQ. 1) THEN
            ISTATP = NADD(101)
            DO 10 I = 0, 100
                  ISTORE(ISTATP+I) = 0
10          CONTINUE
      END IF
      IREC = -1
C     ISTORE (ISTATP+1) -(ISTATP+101) contains the distribution of
C     intensity/sigma for the data.ISTORE(ISTATP) holds the total
C     no of reflections analysed for int/sigma.
20    CONTINUE
C     Get a record from the file.
      CALL RECORD
21    CONTINUE
      IF (KERR .NE. 0) THEN
        IF (KERR .LT. 0) THEN
C         End of file, return to RC93.SUB
          GO TO 999
        ELSE
          WRITE (ISCRN, '(A,A/1X,A,I4)') 'ERROR Reading file ',
     +    CINPFL(:LENINP), 'Line ', INPLIN
          WRITE (IERFIL, '(A,A/1X,A,I4)') 'ERROR Reading file ',
     +    CINPFL(:LENINP), 'Line ', INPLIN
          STOP
        END IF
      END IF
C
      IF (IREC .EQ. 2) THEN
C                                   Reflection data cards 1&2
            CALL REC1N2
            GOTO 21
      ELSE IF (IREC .EQ. 0) THEN
            CALL REFDMP
            GO TO 21
      ELSE IF (IREC .EQ. 32) THEN
            CALL RC31N2
            GO TO 20
      ELSE IF ((IREC .GT. 2) .AND. (IREC .LT. 20)) THEN
C           These records are the profile dump (3-10) and the learnt
C           profile or static background measurements. SKIP THESE.
            GO TO 20
      ELSE IF (IREC .EQ. 21 ) THEN
            CALL  REC21
            GO TO 20
      ELSE IF (IREC .EQ. 22) THEN
            CALL  REC22
            GO TO 20
      ELSE IF (IREC .EQ. 23) THEN
            CALL  REC23
            IF (MN2ABS .GT. 0) GO TO 999
            GO TO 20
      ELSE IF (IREC .EQ. 24) THEN
            CALL  REC24
            GO TO 20
      ELSE IF (IREC .EQ. 25) THEN
C           CALL  REC25_processing
C           Do-nothing as no processing needed.
            GO TO 20
      ELSE IF (IREC .EQ. 26) THEN
            CALL  REC26
            GO TO 20
      ELSE IF (IREC .EQ. 27) THEN
C           CALL 27_PROCESSING
C           Do nothing as no processing needed.
            GO TO 20
      ENDIF
C----- DROPPED OFF END - JUNK?
      WRITE (ISCRN,'(1X,A,I4,A,I6,2X,A,A)')'Unidentified Record ',
     + IREC, ' on line ', INPLIN, CINPFL(:LENINP), '-SKIPPED'
      GO TO 20
999   CONTINUE
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE MOLFOR
C     This will take the input in CLINE and convert it to two arrays,
C     CATOMS(char*2 holding the elements) and NATOMS (int holding the
C     no of each type of atom).
#include "RC93CM.INC"
      INTEGER I, J, K, LINE
      CHARACTER*26 CUPPER
      DATA CUPPER/ 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
      J = 1
      K = 1
C     This loop is a sort of 'While J < lenstr(CLINE) do the loop'
10    CONTINUE
      IF (J .GT. LENSTR(CLINE)) GO TO 100
            IF (CLINE(J:J) .EQ. ' ') THEN
                  J = J+1
                  GO TO 10
            ELSE
                  DO 50 I=1,26
                        IF (CLINE(J:J) .NE. CUPPER(I:I)) THEN
                              GO TO 50
                        ELSE
                              GO TO 60
                        END IF
50                CONTINUE
C                 If get here then not an alphabetic character.
                  J = J+1
                  GO TO 10
            END IF
60          CONTINUE
C           Have now got an alphabetic char., is next char alphabetic?
            IF (CLINE(J+1:J+1) .EQ. ' ') THEN
C                 If element followed by a blank then assume number=1
                  CATOMS(K) = CLINE(J:J)
                  NATOMS(K) = 1
                  K = K+1
                  J = J+2
                  GO TO 10
            ELSE
                  DO 65 I=1,26
                        IF (CLINE(J+1:J+1) .NE. CUPPER(I:I)) THEN
                              GO TO 65
                        ELSE
C                             Second char is also alphabetic.
                              GO TO 70
                        END IF
65                CONTINUE
C                 If get here then 2nd character is not alphabetic.
                  CATOMS(K) = CLINE(J:J)
67                CONTINUE
C                 Here CLINE(J+1) is on the first non-alphabetic
C                 character after the element.
                  IF (CLINE(J+2:J+2) .EQ. ' ') THEN
C                       Number only 1 digit long.
                        READ (CLINE(J+1:J+1), '(I1)',ERR=900) NATOMS(K)
                        J = J+3
                  ELSE IF (CLINE(J+3:J+3) .EQ. ' ') THEN
C                       Number 2 digits long.
                        READ (CLINE(J+1:J+2), '(I2)', ERR=900) NATOMS(K)
                        J = J+4
                  ELSE IF (CLINE(J+4:J+4) .EQ. ' ') THEN
C                       Number 3 digits long.
                        READ (CLINE(J+1:J+3), '(I3)', ERR=900) NATOMS(K)
                        J = J+5
                  ELSE
C                       Either number>999 or no space between next,
C                       can't process, so go to error section.
                        GO TO 900
                  END IF
C                 Have now read this AtNum combination so look for next
                  K = K+1
                  GO TO 10
C                 If the second char is also alphabetic we get here
70                CONTINUE
                  CATOMS(K) = CLINE(J:J+1)
                  J = J+1
C                 Now sort out the number of atoms of this type.
                  GO TO 67
            END IF
C
C     Now read down the data file of the atomic properties (usually
C     PROPERTI.DAT or PROPERTIES.DAT, on unit IATPRO to check that the
C     mol formula is valid and to read in the atomic weights and xray
C     cross sections for the radiation type.
C     This is effectively a 'do while NATOMS(I) .ne. 0' loop
100   CONTINUE
      CLGFL = CATPRO
      CALL MTRNLG(CLGFL, 'OLD', LENFIL)
      OPEN (IATPRO, FILE=CLGFL(1:LENFIL), STATUS='OLD'
C&VAX     2 ,READONLY
     3 )
      CATPRO = CLGFL(1:LENFIL)
      I = 1
101   CONTINUE
      IF (NATOMS(I) .EQ. 0) THEN
C           No more atoms to follow.
            GO TO 200
      ELSE
            REWIND (IATPRO)
            LINE = 0
110         CONTINUE
            READ (IATPRO, '(A)', ERR=920, END=950) CBUFFR
            LINE = LINE +1
            IF (CBUFFR(:8) .EQ. 'CONTINUE') GO TO 110
            IF (CATOMS(I) .NE. CBUFFR(:2)) THEN
                  GO TO 110
            ELSE
                  READ (CBUFFR(45:), *, ERR=120) ATOMWT(I)
                  DO 115 K=1, IRAD-1
                        READ (IATPRO, '(A)', ERR=920) CBUFFR
                        LINE = LINE+1
115               CONTINUE
C                 This loop above should step down the att.prop file the
C                 appropriate number of lines for the radiation type.
                  READ (IATPRO, '(A)') CBUFFR
                  READ (CBUFFR(14:), *, ERR=920) XSECT(I)
                  LINE = LINE+1
                  I = I+1
                  GO TO 101
            END IF
120         CONTINUE
C           Error reading in the atomic weight.
            WRITE (ISCRN, '(1X,A,A,A,A,I6)') 'ERROR - reading atomic',
     +          ' weight, ', CATPRO(:LENSTR(CATPRO)), ' line ', LINE
            WRITE (IERFIL, '(1X,A,A,A,A,I6)') 'ERROR - reading atomic',
     +          ' weight, ', CATPRO(:LENSTR(CATPRO)), ' line ', LINE
            STOP
      END IF
200   CONTINUE
      GO TO 999
900   CONTINUE
C     This is the error section. It returns KERR .ne. 0 and lets the
C     calling routine reprompt for the molecular formula. Get here if
C     no. of elements>999 or if element not followed by a number or a
C     blank.
      KERR = 100
      GO TO 999
920   CONTINUE
C     Error reading a line from ATPRO
      WRITE (ISCRN, '(1X,A,A,A,I6)') 'ERROR - reading ',
     +                       CATPRO(:LENSTR(CATPRO)), ' line ', LINE
      WRITE (IERFIL, '(1X,A,A,A,I6)') 'ERROR - reading ',
     +                       CATPRO(:LENSTR(CATPRO)), ' line ', LINE
      STOP
950   CONTINUE
C     End of file of atomic props before have matched element type.
      WRITE (ISCRN, '(1X,A,A,A)') 'Element type ' ,CATOMS(I),
     +                                               ' unrecognised'
      KERR = 100
      GO TO 999
999   CONTINUE
      CLOSE (IATPRO)
      RETURN
      END
C
C***********************************************************************
C
      SUBROUTINE PNSIG (NPI, IBGL, IPEAK, IBGR,
     +                                         FOBS, SIGMA)
C     This subroutine calculates the true intensity(FOBS) and
C     sigma(SIGMA) of a peak.
C
C     NPI is the scan speed, higher NPI means SLOWER speed, a negative
C     value indicates use of the attenuator.
C
C           I    = PEAK -2(BGL+BGR)
C           FOBS = I * BASE SPEED * ATTENUATOR / SPEED
C
C           sigma(I)  = SQRT( PEAK+ 4(BGL+BGR))
C           sigma'(I) = sigma(I) * BASE SPEED * ATTENUATOR / SPEED
C
#include "RC93CM.INC"

      REAL FOBS, SIGMA, TEMP, RTEMP
      INTEGER NPI, IBGL, IPEAK, IBGR
C Check that we have a value the attenuator, held in STORE(MINITP+12).
      IF (STORE(MINITP+12) .LE. 0.0) THEN
            WRITE (ISCRN, '(1X,A,/,1X,A)') 'ERROR - RC93 cannot process
     +reflection data without a value for the ', 'attenuator coeffic
     +ent.'
35          CONTINUE
C           Ask for attenuator factor, no default value.
            WRITE (ISCRN, '(/1X,A,A)') 'Please give the attenuator ',
     +                     'factor (QUIT if unknown) :-'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 35
            IF (CLINE .EQ. 'QUIT') THEN
                  WRITE(ISCRN,'(A)')'RC93 STOPS : PROCESSING INCOMPLETE'
             WRITE(IERFIL,'(A)')'RC93 STOPS : PROCESSING INCOMPLETE'
                  STOP
            ELSE
                  READ (CLINE, *, ERR=35) STORE(MINITP+12)
                  IF (NINT(STORE(MINITP+12)*10000) .LE. 0.0) GO TO 35
            END IF
      END IF
C     Check for a base scan speed, held in ISTORE(IR22P+2).
      IF (ISTORE(IR22P+2) .LE. 0) THEN
            WRITE (ISCRN, '(1X,A/1X,A)') 'ERROR - RC93 cannot process
     +reflection data without a value for the ', 'base scan speed'
40          CONTINUE
            WRITE (ISCRN, '(1X,A,A)') 'Please give base scan speed',
     +                                                ' [default=1]'
            CALL READLN (IKEYBD)
            IF (KERR .NE. 0) GO TO 40
            READ (CLINE, *, ERR=40) ISTORE(IR22P+2)
      END IF
      TEMP=FLOAT((IPEAK- 2*(IBGL +IBGR))) /IABS(NPI)
      FOBS = TEMP * ISTORE(IR22P+2)
      RTEMP = IPEAK + 4*( IBGL + IBGR)
      SIGMA = (SQRT (RTEMP) * ISTORE(IR22P+2)) / IABS(NPI)
      IF (NPI .LT. 0) THEN
C Attenuator set [value should be +ve but use ABS just in case]
            FOBS  = FOBS  * ABS(STORE(MINITP+12))
CDJW - Fix -ve FSQ from .INI file
            FOBS = MAX( FOBS, FSQNEG)
            SIGMA = SIGMA * ABS(STORE(MINITP+12))
      END IF
      RETURN
      END
C************************************************************************
      SUBROUTINE SMTH3B
C - SMTH3 MODIFIED BY DJW, DEC 99
C     This subroutine uses 3 point smoothing to smooth the raw group
C     scale factors.  It doesn't smooth over discontinuities greater
C     than DISFAC (10% by default), but estimates before and after
C     values and outputs them with the same xraytime.
C            smoothed sf(i) = (sf(i-1)+ 2*sf(i) +sf(i+1)) / 4
C     The value at xrayt=0 is estimated using the gradient of the first
C     2 points.
#include "RC93CM.INC"
      INTEGER ITGSF, IRAWXT (3), IPNTSP(3), LEND
      REAL RAWSCF (3), GRAD, RAWNEW
      PARAMETER (ITGSF = 4)
c------ prepare to output a new list at idjw
      inext = nadd (itgsf)
      IDJW = inext 
      irun = idjw
      istore(irun)=0 
      ndjw = 0
C--- look at first 3 scales
c----- first scale stored at istore(igscfp)
      i1 = igscfp
      i2 = i1
      i3 = istore(i2)
      if (i3 .eq. 0) goto 100
c
20    continue
      if (abs (store(i2+1)-store(i3+1)) .lt. 
     1 disfac*(store(i2+1)+store(i3+1))/2.) then
c      normal values
       inext = nadd (itgsf)
       istore(irun) = inext
       store(irun+1) = store(i2+1)
       istore(irun+3) = istore(i2+3)
       store(irun+2) = 
     1 (store(i1+1) + 2.* store(i2+1) + store(i3+1))/4.
       ndjw = ndjw + 1
       irun = inext
       istore(irun) = 0
       i1 = i2
       i2 = i3
       i3 = istore(i2)
       if (i3 .eq. 0) goto 100
      else
c      discontinuity
       inext = nadd (itgsf)
       istore(irun) = inext
       store(irun+1) = store(i2+1)
       istore(irun+3) = istore(i2+3)
       store(irun+2) = (store(i1+1) + 3.* store(i2+1))/4.
       ndjw = ndjw + 1
       irun = inext
       istore(irun) = 0
c      extra point at next time       
       inext = nadd (itgsf)
       istore(irun) = inext
       store(irun+1) = store(i2+1)
       istore(irun+3) = istore(i3+3)
       store(irun+2) = (store(i1+1) + 3.* store(i2+1))/4.
       ndjw = ndjw + 1
       irun = inext
       istore(irun) = 0
c      fiddle addresses after discontinuity
       i1 = i3
       i2 = i3
       i3 = istore(i2)
       if (i3 .eq. 0) goto 100
      endif
      goto 20
c
100   continue
c      extra final at current time       
       inext = nadd (itgsf)
       istore(irun) = inext
       store(irun+1) = store(i2+1)
       istore(irun+3) = istore(i2+3)
       store(irun+2) = (store(i1+1) + 3.* store(i2+1))/4.
       ndjw = ndjw + 1
       irun = inext
       istore(irun) = 0
c begin output
      j = idjw
       write(lisfil,110)
110    format('    Crystal decay scale factors')
       write(lisfil,111)
111    format('    Number       Raw    Smooth      Time')
       write (iscffl, '(''#list 27'')')
       write (iscffl, '(''read nscale='', i6)') ndjw+1
c write a dummy first scalefactor
      write(iscffl,1007) 0,store(j+1),store(j+2),0
      do 200 i = 1, ndjw
      write(lisfil,201) i,store(j+1),store(j+2),istore(j+3)
201   format(i10, 2f10.3, i10)
      write(iscffl,1007) i,store(j+1),store(j+2),istore(j+3)
1007  format ('scale', 1x, i5, 2(1x, f7.3), 1x, i7)
      j = j + itgsf
200   continue
      write (iscffl, '(''end'')')
c
999   continue
      return
      end
C

#if defined(CRY_OSWIN32)
CODE FOR KCCEQL
      FUNCTION KCCEQL ( CDATA , ISTART , CMATCH )
C -- LOCATE SUBSTRING IN STRING
C -- THIS FUNCTION IS SIMILAR TO FORTRAN 'INDEX'
C      CDATA       STRING IN WHICH TO SEARCH
C      ISTART      STARTING POSITION IN 'CDATA'
C      CMATCH      STRING TO SEARCH FOR
C      KCCEQL      -1      NO MATCH
C                  +VE     POSITION IN 'CDATA' OF CMATCH
      CHARACTER*(*) CDATA , CMATCH
      KCCEQL = -1
      LENMAT = LEN ( CMATCH )
      LENDAT = LEN ( CDATA )
      IFINSH = LENDAT - LENMAT + 1
      IF ( ISTART .LE. 0 ) RETURN
      IF ( ISTART .GT. IFINSH ) RETURN
      IPOS = INDEX ( CDATA(ISTART:) , CMATCH )
      IF ( IPOS .LE. 0 ) RETURN
      KCCEQL = ISTART + IPOS - 1
      RETURN
      END
#endif

