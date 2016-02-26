CRYSTALS CODE FOR CCONTROL.FOR

C $Log: not supported by cvs2svn $
C Revision 1.26  2012/07/13 15:51:21  djw
C Horrid patch to fix input when atom is flagged as aniso, but all Uij are zero
C (cif from joournal). U11,22,33 set to very small number.
C It would be better to fix the eigen routines, but these were pinched from SNOOPI
C
C Revision 1.25  2012/01/06 12:51:20  rich
C Remove debugging print from Cameron.
C
C Revision 1.24  2012/01/05 17:18:11  rich
C Fix in and out of new L5 format.
C
C Revision 1.23  2009/07/02 09:22:16  djw
C Show error message on screen for unrecognised words
C
C Revision 1.22  2005/02/08 15:59:47  stefan
C 1. Added precompiler if's for the mac source
C
C Revision 1.21  2005/01/23 09:52:52  rich
C Reinstate old history for Cameron files. History for changes since Dec 23 is
C lost, but changes are not!
C
C Revision 1.2  2004/12/13 16:16:47  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:12  rich
C New CRYSTALS repository
C
C Revision 1.20  2003/10/31 09:26:18  rich
C Increase number of colours that are read from COLOUR.CMN. Removed any
C hardcoded references to 16 colours, and use "ICLMAX" instead.
C Added an extra colour BGREEN to the end of colour.cmn, this avoids
C ambiguity between LGREY and LGREEN when storing colours as four letter
C strings in List 29.
C
C Revision 1.19  2003/05/07 12:18:53  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.18  2002/11/04 12:21:43  rich
C Write SPARE out to .l5 in same format (F11.2) that it was read, otherwise
C very large values of spare may be fuddled.
C
C Revision 1.17  2002/06/28 16:20:55  Administrator
C Enable NEW to be stored in LIST 5, try to fix postscript line thickness and boundingbox
C
C Revision 1.16  2002/02/20 14:43:34  Administrator
C Correct colour translation
C
C Revision 1.15  2001/06/18 08:16:46  richard
C Lowercase references to CAMERON.SRT
C
C Revision 1.14  2001/03/08 16:46:48  richard
C Reads and writes new format list 5. (Ints at end).
C
C Revision 1.13  2000/12/13 19:14:07  richard
C Linux support.
C
C Revision 1.12  2000/11/17 17:32:45  CKP2
C Fix up 18 param per atom
C
C Revision 1.11  2000/09/20 14:31:46  CKP2
C djw  Change directory path for fixed files
C
C Revision 1.10  2000/08/04 15:17:48  CKP2
C more pdb mods
C
C Revision 1.9  2000/08/04 14:41:50  CKP2
C More chime/pdb edits
C
C Revision 1.8  2000/07/17 13:53:25  CKP2
C Chime output
C
C Revision 1.7  2000/02/23 12:18:05  ckp2
C djw  Add .XYZ (Chime) output, fix bug with setunit
C
C Revision 1.6  2000/01/13 14:38:24  ckp2
C djw Jan 2000 Reduce amount of output going to status window
C
C Revision 1.5  1999/07/30 20:14:43  richard
C RIC: Store the absolute value of covalent radius, so that it may be set
C negative to flag a non-bonding dummy atom.
C
C Revision 1.4  1999/04/28 12:32:39  dosuser
C RIC: Debugging statements for ellipses added as comments.
C

CAMERON CODE FOR CONTROL
CODE FOR ZABAND [ ABANDON - RESET COMMAND FLAGS ]
      SUBROUTINE ZABAND(ITYPE)
C THIS COMMAND CLEARS THE INPUT LINE
C ITYPE = 1
C ONLY LOSE THE INFO ON THE PREVIOUS COMMAND 'PROCESS'
C ITYPE =2
C LOSE ALL THE COMMAND INFO 'ABANDON'
      
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

C THIS ROUTINE RESETS ALL THE COMMAND FLAGS AND LOSES THE PREVIOUS
C COMMAND LINE
      IF (ITYPE.EQ.2) THEN
        IHEAD = 1
        DO 30 I = 1, ICPOS
          ICOMMD (I) = 0
          ICCMMD (I) = 0
          ICMULT (I) = 0
          NCOMMD (I) = 0
          RCOMMD (I) = 0
          INFCMD (I) = 0
          CTCOMD (I) = ' '
30      CONTINUE
        ICTPOS = 1
        ICPOS = 1
        ICNPOS = 1
        ICRPOS = 1
        ICCPOS = 1
        ICINPS = 1
        ITCNT = 1
        ICNT = 1
        INCNT = 1
        IRCNT = 1
        ICCNT = 1
        IC = 0
        IR = 0
        IN = 0
      ENDIF
      ICTYPE (2,1) = 0
      ICTYPE (2,2) = 0
      ICTYPE (2,3) = 0
      ICTYPE (2,4) = 0
      IINT (2) = 0
      IRL (2) = 0
      ICHARS (2) = 0
      IPREV (2) = 0
      INCOM (2) = 0
      CALL ZCIUDT
      RETURN
      END
 
CODE FOR ZCASCH [ CHARACTER ARRAY SEARCH ]
C This routine searches the character array for the last word found.
      SUBROUTINE ZCASCH (CSEARCH,ISTART,IFIN,ISTEP,IPOS,IPPACK,INSTRT)
      
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

      CHARACTER *(ILEN) WORD,CHECK,CSEARCH,CWD
      CHARACTER*1 CNUMS(10)
      DATA CNUMS/'0','1','2','3','4','5','6','7','8','9'/
      IPPACK = 0
      INSTRT = 0
      IPOS = -1
      IF (ISTART.EQ.-1) THEN
        CALL ZMORE('You havent got any atoms yet!',0)
        CALL ZMORE1('You havent got any atoms yet!',0)
        RETURN
      ENDIF
      IF (CSEARCH(1:1).NE.' ') THEN
         WORD = CSEARCH
         IWD = 0
      ELSE
        IF (IEND-IBEG.GT.ILEN) THEN
          WORD = LINE(ILINE)(IBEG:IBEG+ILEN-1)
        ELSE
          WORD = LINE(ILINE)(IBEG:IEND)
        ENDIF
C CHECK FOR UNDERSCORES IN THE WORD
        IWD = INDEX(LINE(ILINE)(IBEG:IEND),'_')
        IF (IWD.NE.0) THEN
          CWD = WORD(1:IWD-1)//'      '
          WORD = CWD
C GET THE PACK NUMBER
          IPPACK = 0
          DO 11 I = IBEG+IWD, IEND
            IPPACK = IPPACK*10
            DO 12 J = 1 , 10
              IF (LINE(ILINE)(I:I).EQ.CNUMS(J)) THEN
                IPPACK = IPPACK + J - 1
              ENDIF
12          CONTINUE
11        CONTINUE
        ENDIF
      ENDIF
C LOOP OVER THE SPECIFIED PART OF THE ARRAY
      DO 10 I = ISTART,IFIN,ISTEP
      CHECK = CSTORE(I)
      IF (CHECK.EQ.WORD) THEN
        IF ((IWD.NE.0).AND.(I.GE.ICATOM)) THEN
C WE HAVE TO CHECK THE PACK NUMBER FOR ATOMS
          KK = (I-ICATOM)*IPACKT + IRATOM
          IF (NINT(RSTORE(KK+IPCK)).EQ.IPPACK) THEN
            IPOS = I
           IF (I.LT.IFIN) INSTRT = I + IPACKT
           GOTO 13
          ENDIF
        ELSE
          IPOS = I
          IF (I.LT.IFIN) INSTRT = I + IPACKT
          GOTO 13
        ENDIF
      ENDIF
10    CONTINUE
13    CONTINUE
      RETURN
      END
 
 
CODE FOR ZERRLD
      SUBROUTINE ZERRLD(ID,INSUB,ITY)
      
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

      CHARACTER*10 CNAME
      CHARACTER*80 DUMP
      LOGICAL LFILES
      INSUB = 0
      DO 1 I = 1,30
      CSUB (I) = '          '
1     CONTINUE
C VARIABLES : INSUB is the number of valid sub commands.
C             CSUB contains the names of the sub commands
C             CHELP contains the help messages for the sub commands
C             ITY  = 1  sub names only
C             ITY = 2   sub names plus help info
C These are negated if the routine is loaded from XQUERY.
C The names of the commands are held in the file COMMAND.DAT
      IF ((ICPOS.EQ.1).AND.(ITY.GT.0)) THEN
        INSUB = -1
        RETURN
      ENDIF
      ITYPE = ABS(ITY)
      I = ICOM+((ID-ICOM)*ISRCOM/ISCOM)
C I is the starting position of the info in the array
C Calculate the group number of the previous command.
      IGP = ABS(NINT(RSTORE(I))/100)
C NOW LOOP TO FIND THE FIRST AND LAST COMMANDS IN THE GROUP
      ISTART = 0
      IFIN = 0
      IB = I-30*ISRCOM
      IF (IB.LT.ICOM) IB = ICOM
      DO 10 J = IB,(I+30*ISRCOM),ISRCOM
        IGPN = ABS(NINT((RSTORE(J)/100)))
        IF ((IGPN.EQ.IGP).AND.(ISTART.EQ.0)) ISTART = J
        IF ((IGPN.NE.IGP).AND.(ISTART.NE.0).AND.(IFIN.EQ.0))
     c  IFIN = J-ISRCOM
10    CONTINUE
C SEARCH THROUGH THE FILE FOR THE REQUIRED INFO
      IS = (ISTART - ICOM + 1)/ISRCOM
      IF = (IFIN - ICOM + 1)/ISRCOM
#ifdef CRY_FORTDIGITAL
      IF (.NOT.LFILES(-1,'SCRIPT\COMMAND.CMN',IINPT))THEN
#else
      IF (.NOT.LFILES(-1,'script/command.cmn',IINPT))THEN
#endif
          CALL ZTXTMD
          CALL ZMORE('Error - file COMMAND.CMN not found.',0)
          CALL ZMORE('CAMERON cannot continue.',0)
C cljf
          CALL ZMORE1('Error - file COMMAND.CMN not found.',0)
          STOP
        ENDIF
C LOOP OVER INVALID LINES
      DO 20 J = 1,(IS)*3
      READ (IINPT,'(A80)') DUMP
20    CONTINUE
C NOW LOAD IN THE COMMAND INFO - READ IN ALL 10 LETTERS OF COMMAND
      DO 40 J = 1,IF-IS+1
      READ (IINPT,30) CNAME,ICNPREV,DUMP
30    FORMAT (A10,8X,I8,/,A80/)
C DO NOT INCLUDE HEADER COMMANDS IN THE LIST
      IF (ICNPREV.EQ.0) GOTO 40
C CHECK COMMAND VALIDITY
C THIS ROUTINE CAN ONLY BE ENTERED IF ALL THE ARGS HAVE BEEN
C SUPPLIED FOR THE PREVIOUS COMMAND OR IF AN IMMEADIATE
C SUB COMMAND IS POSSIBLE. IE ISUB MAY BE 4 OR -4 ONLY.
C      IF (CNAME(1:6).EQ.CSTORE(ICOMMD(ICPOS-1))) THEN
C        WRITE (ISTOUT,31) CNAME
C31    FORMAT ('HELP information on the command ',A10)
C      ENDIF
      IVALID = 0
      ISUB = NINT(RSTORE(I+5))
      IF (ISUB.LT.0) ISUB = -4
      IF ((IN.NE.0).OR.(IR.NE.0).OR.(IC.NE.0)) ISUB = 4
C ARGUMENTS COME BETWEEN THE COMMANDS
      IF (ISUB.EQ.-4) THEN
C WE NEED A SPECIFIC SUB COMMAND
        IF (ABS(ICNPREV).EQ.NINT(RSTORE(I))) THEN
C VALID
          IVALID = 1
        ENDIF
      ENDIF
      IF (ISUB.NE.-4) THEN
C SUB COMMAND POSS BUT MUST CHECK CRITERIA OF THE COMMAND
        IF (ICNPREV.LE.1) THEN
C NO PARTICULAR PREVIOUS COMMAND NEEDED.
          IVALID = 1
        ELSE
C CHECK PREVIOUS COMMAND
          IF (ICNPREV.EQ.NINT(RSTORE(I))) THEN
            IVALID = 1
          ENDIF
        ENDIF
      ENDIF
      IF (IVALID.EQ.1) THEN
        INSUB = INSUB + 1
        CSUB (INSUB) = CNAME
        CHELP(INSUB) = DUMP
      ENDIF
 
C       IF (RSTORE(I+5).GT.-1.0) THEN
C IS THE SUB COMMAND VALID? - IT IS ONLY INVALID IF ICNPREV = n AND
C n <> INCOM (2)
C        IF ( (ICNPREV.LE.1) .OR. ( NINT(RSTORE(I)).EQ.ICNPREV) ) THEN
C VALID
C        ENDIF
C      ELSE
C        IF (ABS(ICNPREV).EQ.NINT(RSTORE(I))) THEN
C          INSUB = INSUB + 1
C          CSUB (INSUB) = CNAME
C          CHELP(INSUB) = DUMP
C        ENDIF
C      ENDIF
40    CONTINUE
      IF (.NOT.LFILES (0,' ',IINPT)) THEN
        CALL ZMORE('Error on closing COMMAND.CMN.',0)
      ENDIF
      IF (ISUB.NE.-4) THEN
        CALL ZMORE('Any HEADER command is valid here.',2)
      ENDIF
      IF (INSUB.GT.0) THEN
        CALL ZMORE('Valid sub commands are -',2)
      ENDIF
      IF (ITYPE.EQ.1) THEN
        DO 50 I = 0, INSUB/5
          WRITE (CLINE,'(5(A10,2X))') (CSUB(J),J = (I*5)+1,(I*5)+5)
          CALL ZMORE(CLINE,2)
50      CONTINUE
      ELSE
        DO 60 I = 1,INSUB
          CALL ZMORE(CSUB(I),2)
          CALL ZMORE(CHELP(I),2)
cdjwjan00          CALL ZMORE(' ',2)
60      CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZERCHO [ ERROR CHOICE MAKING AND EDITING ROUTINE ]
      SUBROUTINE ZERCHO (ICHOIC,IERRNO,IST,IE)
      
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

      LOGICAL LFILES
      CHARACTER*1 ANS
      CHARACTER*(ICLEN) NEWLN
      CHARACTER*80 ERRMESS
      CHARACTER*30 WORD
      CHARACTER*60 FILENM
C THE RETURN VALUES OF ICHOIC ARE :-
C 1 = PROCESS THE LINE SO FAR (this option has been abandoned because
C     it is confusing to the user)
C 2 = ABANDON
C 3 = RE-PROCESS THE COMMAND LINE
C 4 = ABANDON ALL FILES (FOR OBEYED FILES)
C
C The choices given to the user are :-
C 1 = process ( DUMPED )
C 2 = abandon
C 3 = edit
C 4 = help
C 5 = abandon all files
C Write out the choice message
      CALL ZBEEP
10    CONTINUE
      IF (IFOBEY.EQ.-1) THEN
C        CALL ZMORE(
C     c 'An error has been found in the input line.',0)
C        CALL ZMORE(
C     c 'Do you want to Abandon the line altogether,',0)
C        CALL ZMORE('Edit the line to correct the error',0)
C        CALL ZMORE ('or obtain Help on the current command?',0)
11      CONTINUE
C       CALL ZMORE('A/E/H ?',0)
C        CALL ZGTANS (ANS,0)
C        IF ((ANS.EQ.'a').OR.(ANS.EQ.'A')) THEN
C Just abandon the line.
          ICHOIC = 2
          RETURN
C        ELSE IF ((ANS.EQ.'P').OR.(ANS.EQ.'p')) THEN
C          ICHOIC = 1
C          RETURN
C        ELSE IF ((ANS.EQ.'e').OR.(ANS.EQ.'E')) THEN
C          ICHOIC = 3
C        ELSE IF ((ANS.EQ.'h').OR.(ANS.EQ.'H')) THEN
C          ICHOIC = 4
C        ELSE
C          CALL ZBEEP
C          GOTO 11
C        ENDIF
      ELSE
      CALL ZMORE(
     c'An error has occured while reading an OBEY file.',0)
      CALL ZMORE(
     c 'This file and all other currently open OBEY files will now ',0)
      CALL ZMORE(
     c 'be closed and all non-executed commands will be lost.',0)
20      CONTINUE
        INQUIRE (UNIT=IFOBEY,NAME=FILENM)
        IF (.NOT.LFILES (0 , ' ',IFOBEY)) THEN
          CALL ZMORE('Error on closing OBEY file.',0)
        ENDIF
        WRITE (CLINE,21) FILENM
        CALL ZMORE(CLINE,0)
21      FORMAT ('Closing ',A60)
        IF (IFOBEY.GT.IFSTAR) THEN
          IFOBEY = IFOBEY - 1
          GOTO 20
        ELSE
          IFOBEY = -1
          ICHOIC = 2
          RETURN
        ENDIF
      ENDIF
      GOTO (100,200) ICHOIC-2
100   CONTINUE
C EDIT THE INPUT LINE
      IF (IERRNO.EQ.2) THEN
C DELETE ARGUMENTS
        CALL ZMORE('The following arguments are to be deleted',0)
        CALL ZMORE (LINE(ILINE)(IST:IE-1),0)
      ELSE IF ((IERRNO.EQ.1).OR.(IERRNO.EQ.5)) THEN
C INPUT REPLACEMENT WORD
        CALL ZMORE('Please input the replacement word(s)',0)
        CALL ZGTANS (WORD,0)
      ELSE IF (IERRNO.EQ.6) THEN
C INPUT SUB COMMAND
        CALL ZMORE('Please input the required sub-command',0)
        CALL ZGTANS (WORD,0)
      ELSE IF (IERRNO.GE.3) THEN
        CALL ZMORE('Please input the required argument(s)',0)
        CALL ZGTANS(WORD,0)
      ENDIF
C MODIFY THE COMMAND LINE
      CALL ZERRLN (IERRNO,IST,IE,WORD,NEWLN)
      CALL ZMORE('The new command line is :-',0)
      CALL ZMORE(NEWLN,0)
      CALL ZMORE('Is this OK Y/N ?',0)
      CALL ZGTANS (ANS,0)
      IF ((ANS.NE.'Y').AND.(ANS.NE.'y')) GOTO 10
C REPLACE THE OLD COMMAND LINE WITH THE NEW ONE
      LLINE(ILINE) = NEWLN
      CALL ZUPCAS(NEWLN)
      LINE(ILINE) = NEWLN
C      ICABAN = ICABAN + IST - IEND - 2
C UPDATE ICLOG
C FIND THE END OF NEWLN
C      ICLEND = 1
C      DO 30 I = ICLEN , IST , -1
C        IF (NEWLN(I:I).NE.' ') THEN
C          ICLEND = I + 1
C          GOTO 40
C        ENDIF
C30    CONTINUE
C40    CONTINUE
C      IF (ICLEND.GT.1) THEN
C        CLOG (ICABAN:ICABAN+ICLEND-IST) = NEWLN(IST:ICLEND)
C        ICLOG = ICABAN + ICLEND - IST + 1
C      ENDIF
      IEND = IST - 1
      RETURN
200   CONTINUE
C HELP
C Load in the appropriate error message
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(-1,'SCRIPT\COMMAND.CMN',IINPT))THEN
#else
      IF(.NOT.LFILES(-1,'script/command.cmn',IINPT))THEN
#endif
        CALL ZMORE('Error on opening COMMAND.CMN.',0)
        CALL ZMORE('HELP is unavailable.',0)
        GOTO 10
      ENDIF
      IF (ICPOS.EQ.1) THEN
        CALL ZMORE('Sorry, no help available',0)
        GOTO 10
      ENDIF
      ID = (ICOMMD (ICPOS-1) - ICOM)/2
      DO 210 I = 1 , ID
        READ (IINPT,'(//)')
210   CONTINUE
      READ (IINPT,220) COMM,ERRMESS
220   FORMAT (A10,//,A80)
      IF (.NOT.LFILES (0,' ',IINPT)) THEN
        CALL ZMORE('Error on closing COMMAND.CMN.',0)
      ENDIF
      WRITE (CLINE,'(A80)') ERRMESS
      CALL ZMORE(CLINE,1)
C Now load in the sub-commands if possible
C Do we expect a sub-command?
      IF ((IERRNO.EQ.1).OR.(IERRNO.EQ.6)) THEN
        ID = ICOMMD (ICPOS-1)
        CALL ZERRLD (ID,INSUB,2)
      ENDIF
cdjwjan00      CALL ZMORE(' ',2)
      GOTO 10
      END
 
 
CODE FOR ZCICNT [CHARACTER INPUT COUNT]
C This routine checks that the values input are allowed by the processor.
C There are two levels of checks - 1) can we accept a value of this type
C 2) are the final argument counts of the previous command ok?
C VARIABLES :
C      K      - this shows whether to use this or the previous command
C               when checking the counts.
C      IMULT  - this flag is set to show what form the input can take.
C           0 - multiples are allowed.
C           1 - only ICR are allowed.
C           2 - ICR is the minimum number of values, all are put
C               into the same command line stream.
C      ICR - the number of arguments allowed
C      The values of ICR/IMULT are obtained from ICHARS :-
C
C      0 < ICHARS < 10  - ICR = ICHARS , IMULT = 0
C      ICHARS IS n0 - ICR = ICHARS/10 , IMULT = 1
C      ICHARS IS n1 - ICR = ICHARS/10 , IMULT = 2
C
C      IC - the number of character arguments supplied so far.
C      ITYPE - this specifies the type of count to be carried out
C          1 - character count
C          2 - number count
C          4 - final count - this looks in the previous command
C         -4 - final count - this looks in the present command
C  IERR - this returns
C     0 - no error,all args supplied (itype=4) or can accept new value.
C     1 - not enough integers
C     2 - not enough reals
C     3 - not enough characters
C     4 - too many ints
C     5 - too many reals
C     6 - too many characters
C     7 - incorrect multiple - need number
C     8 - incorrect multiple - need characters
C     9 - command can be processed
C NOTE : Must ensure that we do not use MOD to cause a devide by zero!
       SUBROUTINE ZCICNT (ITYPE,IERR)
       
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

       IERR = 0
       IF (ITYPE.EQ.4) THEN
         K = 1
       ELSE
         K = 2
       ENDIF
C SET UP CHARACTER VARIABLES
       IF ((ICHARS(K).LT.10).AND.(ICHARS(K).NE.0)) THEN
         ICR = ICHARS(K)
         IMULT = 0
       ELSE
         IF ((MOD(ICHARS(K),10).EQ.0).OR.(ICHARS(K).EQ.0)) THEN
           IMULT = 1
         ELSE
           IMULT = 2
         ENDIF
         ICR = ICHARS(K)/10
       ENDIF
      GOTO (100,200,200,400) ABS(ITYPE)
100    CONTINUE
C CAN WE ACCEPT A CHARACTER VALUE?
        IF ((ICR.EQ.0).OR.((IC.GE.ICR).AND.(IMULT.EQ.1))) THEN
           IERR = 6
        ENDIF
        RETURN
200   CONTINUE
C NUMBER COUNT - DO WE NEED AN INTEGER OR A REAL?
      IF ((IINT(1).EQ.0).AND.(IRL(1).EQ.0)) THEN
        IF (IN.NE.0) THEN
          IERR = 4
        ELSE
          IERR = 5
        ENDIF
C UNLIMITED NUMBER OF INTEGERS
      ELSE IF (IINT(1).EQ.-1) THEN
        CONTINUE
C TOO MANY NUMBERS - NO MULTIPLES ALLOWED
      ELSE IF ((IN.GE.IINT(1)).AND.(IINT(1).NE.0).AND.
     c (IMULT.EQ.1)) THEN
         IERR = 4
C TOO MANY NUMBERS - NO MULTIPLES ALLOWED
      ELSE IF ((IR.GE.IRL(1)).AND.(IRL(1).NE.0).AND.(IMULT.EQ.1)) THEN
         IERR = 5
      ENDIF
      RETURN
400   CONTINUE
      INMUL = 0
      ICMUL = 0
C FIRST CHECK FOR IMMEADIATE SUB COMMAND
      IF ((ABS(ICTYPE(K,1)).EQ.4).AND.(IC.EQ.0).AND.(IN.EQ.0)
     c .AND.(IR.EQ.0)) THEN
        RETURN
      ENDIF
C FINAL COUNTS - THIS CHECKS THAT ALL THE ARGS HAVE BEEN SUPPLIED
       IF (IINT(K).EQ.0) THEN
         IF (IN.NE.IINT(K)) THEN
           IERR = 4
         ENDIF
       ENDIF
       IF (IRL(K).EQ.0) THEN
         IF (IR.NE.0) THEN
           IERR = 5
         ENDIF
       ENDIF
       IF (ICHARS(K).EQ.0) THEN
         IF (IC.NE.0) THEN
           IERR = 6
         ENDIF
       ENDIF
C IF MULTIPLES ARE ALLOWED THEN WE MUST HAVE THE SAME NUMBER OF ALL ARGS
      IF (IMULT.EQ.0) THEN
         IF (IINT(K).NE.0) THEN
           IF (IN.EQ.0) THEN
             IERR = 1
           ENDIF
           IF (MOD(IN,IINT(K)).NE.0) THEN
             IERR = 7
             RETURN
           ELSE
             INMUL = IN/IINT(K)
           ENDIF
         ENDIF
         IF (IRL(K).NE.0) THEN
           IF (IR.EQ.0) THEN
             IERR = 2
           ENDIF
           IF (MOD(IR,IRL(K)).NE.0) THEN
             IERR = 7
             RETURN
           ELSE
             INMUL = IR/IRL(K)
           ENDIF
         ENDIF
         IF (ICR.NE.0) THEN
           IF (IC.EQ.0) THEN
             IERR = 3
           ENDIF
           IF (MOD(IC,ICR).NE.0) THEN
             IERR = 8
             RETURN
           ELSE
             ICMUL = IC/ICR
           ENDIF
         ENDIF
C CHECK MULTIPLES ARE THE SAME FOR BOTH NUMBERS AND CHARACTERS
         IF (ICMUL.EQ.INMUL) THEN
           CONTINUE
         ELSE IF ((ICMUL.GT.INMUL).AND.((IINT(K).NE.0).OR.
     c     (IRL(K).NE.0))) THEN
           IERR = 7
         ELSE IF ((INMUL.GT.ICMUL).AND.(ICR.NE.0)) THEN
           IERR = 8
         ENDIF
       ELSE
        IF ((IN.NE.0).AND.(IINT(K).EQ.-1)) THEN
          CONTINUE
        ELSE IF (IN.LT.IINT(K)) THEN
          IERR = 1
        ELSE IF (IN.GT.IINT(K)) THEN
          IERR = 4
        ENDIF
        IF (IR.LT.IRL(K)) THEN
          IERR = 2
        ELSE IF (IR.GT.IRL(K)) THEN
          IERR = 5
        ENDIF
      ENDIF
      IF (IMULT.EQ.1) THEN
C IS THE COMMAND FINISHED?
        IF (IC.LT.ICR) THEN
          IERR = 3
        ELSE IF (IC.GT.ICR) THEN
          IERR = 6
        ENDIF
C UNLIMITED NUMERIC ARGUMENTS ALLOWED
        IF ((IN.GT.0).AND.(IINT(K).EQ.-1)) THEN
          CONTINUE
        ELSE IF (IN.LT.IINT(K)) THEN
          IERR = 1
        ELSE IF (IN.GT.IINT(K)) THEN
          IERR = 4
        ENDIF
        IF (IR.LT.IRL(K)) THEN
          IERR = 2
        ELSE IF (IR.GT.IRL(K)) THEN
          IERR = 5
        ENDIF
        IF (IERR.EQ.0) IERR=9
      ELSE IF (IMULT.EQ.2) THEN
         IF (IC.LT.ICR) THEN
           IERR = 3
         ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZCILD [ COMMAND INFORMATION LOADING]
C This routine obtains the command information from the main RSTORE array.
      SUBROUTINE ZCILD(K,ICNUM)
      
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

C VARIABLES : All variables are two dimensioned so that info for the previous
C common is also stored.
C TEST TO SEE IF WE HAVE A COMMAND OR A SUB COMMAND
       IF (ICNUM.GE.ICOM) THEN
C SUB COMMAND
         ID = ICNUM
       ELSE
         ID = NINT(RSTORE(ICNUM))
       ENDIF
       I = ICOM + (((ID-ICOM)/ISCOM)*ISRCOM)
C I is the starting position of the info in the array
       INCOM(K) =  ABS(NINT(RSTORE(I)))
       IPREV(K) = NINT(RSTORE(I+1))
       IINT(K) = NINT(RSTORE(I+2))
       IRL(K) = NINT(RSTORE(I+3))
       ICHARS(K) = NINT(RSTORE(I+4))
       ICTYP = ABS(NINT(RSTORE(I+5)))
C Analyse ICTYP first.
       ICTYPE(K,4) = ICTYP/1000
       ICTYP = ICTYP - ICTYPE(K,4)*1000
       ICTYPE(K,3) = ICTYP/100
       ICTYP = ICTYP - ICTYPE(K,3)*100
       ICTYPE(K,2) = ICTYP/10
       ICTYPE(K,1) = ICTYP - ICTYPE(K,2)*10
       IF (RSTORE(I+5).LT.0.0) ICTYPE(K,1) = -ICTYPE(K,1)
       RETURN
       END
 
 
CODE FOR ZCISCH [CHARACTER INPUT SEARCH]
C This routine searches for the various types of character variables
C that are possible.
      SUBROUTINE ZCISCH (IERR)
      
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

      CHARACTER*12 GNAME
      CHARACTER*20 WORD
      REAL SYMM(4,4)
      CHARACTER*3 CTRAN(8)
      CHARACTER*1 CCENT(7)
      CHARACTER*1 CSYM(15),CNUMS(10)
      CHARACTER*60 FILENM
      CHARACTER*6 COLOUR
      LOGICAL LEXIST
C CTRAN CONTAINS THE TRANSLATIONAL PARTS IN FRACTIONAL FORM.
C CSYM contains the characters that may be part of a symmetry operator.
      DATA CTRAN /'0  ','1/2','1/3','1/4','2/3','3/4','1/6','5/6'/
      DATA CSYM /'X','x','Y','y','Z','z','+','-','/','1','2','3',
     c '4','5','6'/
      DATA CNUMS/'0','1','2','3','4','5','6','7','8','9'/
      DATA CCENT/'P','I','A','B','C','F','R'/
      IERR = 0
C VARIABLES - ICTYPE (1,n) contains the info about the type of character
C             argument that is expected.
C             0 - no char args expected
C             1 - atoms
C             2 - atoms/elements
C             3 - axis
C             4 - sub command (dealt with elsewhere in the code)
C             5 - group name
C             6 - colour
C             7 - symmetry operators (-7 is used for centring vectors.)
C             8 - file name
C             9 - general text
 
C IERR = 3 this means that an until command has occured
C THIS HAS BEEN ALTERED TO ALLOW FOR MORE THAN ONE CHARACTER TYPE PER
C ARGUMENT SET - EG FOR COLOUR BONDS C O YELLOW.
C GET THE NUMBER OF ARGUMENTS
      NARG = ICHARS(1)
      IF (NARG.EQ.0) THEN
        IERR = 1
        RETURN
      ENDIF
      IF (NARG.GT.9) NARG = NARG/10
C DO WE HAVE A SUB-COMMAND ALLOWED?
      IF (ABS(ICTYPE(1,1)).EQ.4) THEN
        ISUB = 1
      ELSE
        ISUB = 0
      ENDIF
C CHECK THE INFO IN THE ICTYPE ARRAY
      NARG = NARG + ISUB
C ALL CHARACTERS MUST BE OF THE SAME TYPE - AT PRESENT ONLY THREE
C DIFFERENT ONES ARE ALLOWED.
      IF (NARG.GT.4) THEN
        IF (ICTYPE(1,2).EQ.0) THEN
          I = ABS(ICTYPE(1,1))
        ELSE
          I = ABS(ICTYPE(1,2))
        ENDIF
      ELSE
        IF (ICTYPE(1,NARG).EQ.0) THEN
C ALL THE ARGUMENTS MUST BE THE SAME
          IF (ICTYPE(1,2).EQ.0) THEN
            I = ABS(ICTYPE(1,1))
          ELSE
            I = ABS(ICTYPE(1,2))
          ENDIF
        ELSE
C FIND OUT WHAT NUMBER ARGUMENT WE ARE ON - NOTE THAT THE
C ARGUMENT LIST WILL BE STORED IN REVERSE ORDER!
          INARG = MOD ( IC , NARG-ISUB )
          I = ICTYPE (1 , NARG - INARG)
        ENDIF
      ENDIF
      IF (I.EQ.0) THEN
C NO CHAR ARGS EXPECTED - HEADER COMMD?!?
        IERR = 1
        RETURN
      ENDIF
C ARE WE LOOKING FOR A SUB COMMAND
      GOTO (100,100,300,400,500,600,700,800,900) I
C Atom search
100   CONTINUE
C FOR ATOM/ELEMENT SEARCH DO ATOM FIRST
C FIRST SEE IF WE HAVE 'UNTIL'
C FIRST CHECK FOR _ AND * CHARACTERS
      ISTAR = INDEX (LINE(ILINE)(IBEG:IEND),'*')
      IUND = INDEX (LINE(ILINE)(IBEG:IEND),'_')
C FIRST CHECK FOR *_N
      IF ((ISTAR.EQ.1).AND.(IUND.EQ.2)) THEN
        IF (I.EQ.1) THEN
          IERR = 1
          RETURN
        ENDIF
        IPPACK = 0
        DO 11 K = IBEG+IUND, IEND
          IPPACK = IPPACK*10
          DO 12 J = 1 , 10
            IF (LINE(ILINE)(K:K).EQ.CNUMS(J)) THEN
              IPPACK = IPPACK + J - 1
            ENDIF
12        CONTINUE
11      CONTINUE
        IF (IPPACK.GT.IPACK) THEN
          IERR = 1
          RETURN
        ENDIF
C STORE THE INFO
        ICCMMD ( ICCPOS ) = 0
        ICMULT ( ICCPOS ) = IPPACK + 1
        ICCPOS = ICCPOS + 1
        IC = IC + 1
        RETURN
      ENDIF
C CHECK FOR _* : AND DELETE THEM - N1_* AND N1 ; N_* AND N ARE TREATED
C THE SAME
      IF (ISTAR.EQ.IUND+1.AND.ISTAR.GT.1) THEN
        LINE(ILINE)(IBEG+IUND-1:IBEG+IUND) = '  '
        IUND = 0
      ENDIF
C WE HAVE GOT A STRAIGHT ATOM NAME
      IF (LINE(ILINE)(IBEG:IBEG+2).NE.'UNT') THEN
        IS = (ISVIEW-IRATOM)/IPACKT + ICATOM
        IF = (IFVIEW-IRATOM)/IPACKT + ICATOM - 1
        CALL ZCASCH ('          '
     c ,IS,IF,ISRATM,IPOS,IPPACK,INTSRT)
        IF ((IPOS.EQ.-1).AND.(IS.EQ.(ISVIEW-IRATOM)/IPACKT+ICATOM)) THEN
          IERR = 1
          IF (IPPACK.GT.IPACK) RETURN
          IF (I.EQ.2) GOTO 200
          RETURN
        ELSE IF (IPOS.NE.-1) THEN
          ICCMMD (ICCPOS) = IPOS
C DO WE HAVE A PACK NUMBER?
          IF (IPACK.GT.0 .AND. IUND.EQ.0) THEN
            ICMULT(ICCPOS) = 1
          ELSE
            ICMULT(ICCPOS) = 0
          ENDIF
          ICCPOS = ICCPOS + 1
          IC = IC + 1
        ENDIF
      ELSE IF (IC.EQ.0) THEN
        CALL ZMORE('CANT HAVE UNTIL HERE!',0)
        IERR = 1
        RETURN
      ELSE
C GET THE NEXT ATOM NAME
        CALL ZWORD(IERR)
        IF (IERR.EQ.1) THEN
          IERR = 1
          RETURN
        ENDIF
        IS = (ISVIEW-IRATOM)/IPACKT + ICATOM
        IF = (IFVIEW-IRATOM)/IPACKT + ICATOM - 1
        CALL ZCASCH ('          '
     c ,IS,IF,ISRATM,IPOS,IPPACK,INSTRT)
        IF ((IPOS.EQ.-1).OR.(IPOS.LT.ICCMMD(ICCPOS-1))) THEN
C NO NEXT ATOM! OR NEXT ATOM INVALID!
          IERR = 1
          CALL ZMORE('NEXT ATOM! OR ATOM INVALID',0)
          RETURN
        ENDIF
C UNTIL IS VALID
        IF (IPOS.NE.ICCMMD(ICCPOS-1)) THEN
C IF UNTIL FROM/TO SAME ATOM - DO NOTHING!
          ISTART = ICCMMD(ICCPOS-1) + ISRATM
          IFIN = IPOS
          DO 20 I = ISTART,IFIN,ISRATM
          ICCMMD (ICCPOS) = I
          IC = IC + 1
          IF (IPACK.GT.0 .AND. IUND.EQ.0) THEN
            ICMULT ( ICCPOS ) = 1
          ELSE
            ICMULT ( ICCPOS ) = 0
          ENDIF
          ICCPOS = ICCPOS + 1
20        CONTINUE
          IC = IC - 1
        ENDIF
        IERR = 3
      ENDIF
      RETURN
200   CONTINUE
C DO ELEMENT SEARCH
      IERR = 0
      IF (ISTAR.EQ.1) THEN
C THIS IS '*' I.E. ALL ATOMS
        ICCMMD(ICCPOS) = -1
        ICMULT(ICCPOS) = 0
        ICCPOS = ICCPOS + 1
        IC = IC + 1
      ELSE
        CALL ZELMSH (IELPOS,IERR,IPPACK)
        IF (IERR.NE.1) THEN
          ICCMMD(ICCPOS) = IELPOS
          IF ((IPACK.GT.0).AND.(IUND.GT.1)) THEN
C WE ADD 1 TO THE PACK NUMBER SO THAT N_0 CAN BE DISTINGUISHED FROM N
            ICMULT ( ICCPOS ) = IPPACK + 1
          ENDIF
          ICCPOS = ICCPOS + 1
          IC = IC + 1
        ELSE
          IERR = 1
        ENDIF
      ENDIF
      RETURN
300   CONTINUE
C AXIS NAME
      IF (LINE(ILINE)(IBEG:IBEG).EQ.'A') THEN
        ICCMMD (ICCPOS) = 1
      ELSE IF (LINE(ILINE)(IBEG:IBEG).EQ.'B') THEN
        ICCMMD (ICCPOS) = 2
      ELSE IF (LINE(ILINE)(IBEG:IBEG).EQ.'C') THEN
        ICCMMD (ICCPOS) = 3
      ELSE
        IERR = 1
        RETURN
      ENDIF
      ICCPOS = ICCPOS + 1
      IC = IC + 1
      RETURN
400   CONTINUE
C THIS IS SUB COMMAND, DEALT WITH ELSEWHERE.
      IERR = 1
      RETURN
500   CONTINUE
C GROUP NAME
C CHECK IS THIS AN ASTERIX?
      IF (LINE(ILINE)(IBEG:IBEG).EQ.'*') THEN
C DO WE HAVE ANY GROUP NAMES DEFINED?
       IF (NGRP.EQ.0) THEN
         IERR = 1
         RETURN
       ENDIF
C THIS IS THE GENERAL GROUP NAME
C STORE GROUP NUMBER
        DO 503 I = 1 , NGRP
          ICCMMD ( ICCPOS ) = I
          ICCPOS = ICCPOS + 1
          IC = IC + 1
503     CONTINUE
        RETURN
      ENDIF
C IS IT AN EXISTING GROUP NAME?
      IGG = 0
      DO 501 I = IGRP,IGRP-NGRP*2+2,-2
        GNAME = CSTORE(I)//CSTORE(I-1)
        IGLEN = IEND-IBEG+1
        IF (GNAME(1:IGLEN).EQ.LINE(ILINE)(IBEG:IEND)) THEN
C YES WE HAVE FOUND A NAME
          IGG = (IGRP-I)/2 + 1
          GOTO 502
        ENDIF
501   CONTINUE
502   CONTINUE
      IF (IGG.EQ.0) THEN
C NO NAME FOUND
        IERR = 1
        RETURN
      ENDIF
C STORE GROUP NUMBER
      ICCMMD ( ICCPOS ) = IGG
      ICCPOS = ICCPOS + 1
      IC = IC + 1
      RETURN
600   CONTINUE
C COLOUR
C MAKE THE COLOUR THE CORRECT LENGTH
      COLOUR = LINE(ILINE)(IBEG:IEND)//'     '
      DO 610 I = 1 , ICLMAX
        IF ((COLOUR.EQ.COLNAM(I)).OR.(COLOUR.EQ.COLGRY(I))) THEN
          ICCMMD ( ICCPOS) = I - 1
          ICCPOS = ICCPOS + 1
          IC = IC + 1
          RETURN
        ENDIF
610   CONTINUE
      IERR = 1
      RETURN
700   CONTINUE
C SYMMETRY OPERATORS
C THIS LOOKS ALONG THE INPUT LINE UNTIL IT HAS GOT A COMPLETE OPERATOR
C IT THEN CHECKS THAT IT IS A FEASIBLE ONE.
      IF (ICHARS(1).EQ.1) THEN
C WE ARE LOOKING FOR A CENTERING LETTER
        DO 705 I = 1 , 6
          IF (CCENT(I).EQ.LINE(ILINE)(IBEG:IEND)) THEN
            ICCMMD(ICCPOS) = I
            ICMULT(ICCPOS) = 1
            ICCPOS = ICCPOS + 1
            IC = IC + 1
            RETURN
          ENDIF
705     CONTINUE
        IERR = 1
        RETURN
      ENDIF
      IF (ICTYPE(1,1).LT.0) THEN
C WE ARE LOOKING FOR CENTRING VECTORS
C LOOK FOR A FRACTION
        N = 1
703     CONTINUE
        IF (IEND-IBEG.GT.4) THEN
          IERR = 1
          RETURN
        ENDIF
        WORD = LINE(ILINE)(IBEG:IEND)
        IF (WORD(1:1).EQ.CSYM(7)) THEN
C WE HAVE A PRECEEDING SIGN
          ISIGN = 1
        ELSE IF (WORD(1:1).EQ.CSYM(8)) THEN
          ISIGN = -1
        ELSE
          ISIGN = 0
        ENDIF
        ITRAN = 0
        DO 702 I = 1 , 8
          IF (WORD(ABS(ISIGN)+1:3+ABS(ISIGN)).EQ.CTRAN(I)) THEN
            ITRAN = I
          ENDIF
702     CONTINUE
        IF (ITRAN.EQ.0) THEN
          IERR = 1
          RETURN
        ENDIF
C STORE THE RESULT
        IF (ISIGN.EQ.-1) THEN
          ICCMMD (ICCPOS) = -ITRAN
        ELSE
          ICCMMD (ICCPOS) = ITRAN
        ENDIF
        ICCPOS = ICCPOS + 1
        IC = IC + 1
        N = N + 1
        IF (N.EQ.4) RETURN
C GET THE NEXT WORD
        CALL ZWORD (IERR)
        IF (IERR.NE.0) THEN
          IERR = 1
          RETURN
        ENDIF
        GOTO 703
      ENDIF
C WE ARE LOOKING FOR A SYMMETRY OPERATOR
      CALL ZZEROF (SYMM,16)
      SYMM(4,4) = 1.0
      N = 1
C THE FOLLOWING 4 FLAGS ARE SET SO THAT WE DO NOT HAVE AN INVALID
C COMBINATION OF SIGNS ETC.
C THE OPERATORS ARE STORED USING A SINGLE NUMBER CONTAINING 6 FIELDS
C 0 - NEGATIVE FLAG
C 0 - X,Y,Z
C 0 - TRANS
C 0 - NEGATIVE
C 0 - X,Y,Z
C 0 - TRANS
C IE. 1 1 0 0 0 1 MEANS -X+1/2 IE NEGATIVE;X;POSITIVE;2ND TRANSLATION.
C BEGIN TO LOOP DOWN THE WORD
701   CONTINUE
      WORD = LINE(ILINE)(IBEG:IEND)
      IERR = 0
      ISYMNO = 0
      CALL ZGTSYM(WORD,IEND-IBEG+1,ISYMNO,IERR)
      IF (IERR.EQ.1) THEN
        RETURN
      ENDIF
C STORE THE RESULT
      ICCMMD(ICCPOS) = ISYMNO
      ICCPOS = ICCPOS + 1
      IC = IC + 1
C INCREMENT N
      N = N + 1
      IF (N.LT.4) THEN
C GET THE NEXT WORD
        CALL ZWORD(IERR)
        IF (IERR.NE.0) THEN
          IERR = 1
          RETURN
        ENDIF
        GOTO 701
      ENDIF
      RETURN
800   CONTINUE
C FILENAME
      ICT = 0
      FILENM = LINE(ILINE)(IBEG:IEND)
      INQUIRE (FILE=FILENM,EXIST=LEXIST)
      IF (LEXIST) THEN
C FILE IS PRESENT
C STORE THE NAME
        NPOS = (IEND-IBEG+1)/12
        DO 801 I = 1 , NPOS
          CTCOMD(ICTPOS) = FILENM((I-1)*12+1:I*12)
          ICTPOS = ICTPOS + 1
          ICT = ICT + 1
801     CONTINUE
        IF (MOD(IEND-IBEG+1,12).NE.0) THEN
          CTCOMD(ICTPOS) = FILENM(NPOS*12+1:IEND-IBEG+1)//'            '
        ENDIF
        ICTPOS = ICTPOS + 1
        ICT = ICT + 1
        ICCMMD(ICCPOS) = ICT
        IC = IC + 1
        ICCPOS = ICCPOS + 1
      ELSE
        IERR = 1
      ENDIF
      RETURN
900   CONTINUE
C GENERAL TEXT
C If quotes " are found then take the text between them otherwise
C just take the next word.
C General text input will be halted by the inclusion of a sub command or
C a header command. If one is required in the text they must be
C enclosed in quotes.
      ICT = 0
      IF (IC.EQ.ICHARS(1)/10.AND.MOD(ICHARS(1),10).EQ.0) THEN
C IF WE ALREADY HAVE STORED ENOUGH TEXT, REGISTER AN ERROR.
        IERR = 1
        RETURN
      ENDIF
      IF (LINE(ILINE)(IBEG:IBEG).EQ.'"') THEN
C        ICABAN = ICABAN - IEND + IBEG - 2
C FIND THE NEXT "
        II = INDEX ( LINE(ILINE)(IBEG+1:ICLEN) ,'"') + IBEG
C        DO 903 II = IBEG+1,ICLEN
C          IF (LINE(ILINE)(II:II).EQ.'"') GOTO 904
C903     CONTINUE
C904     CONTINUE
        IF (II.EQ.0) THEN
          IEND = ICLEN
        ELSE
C DO NOT INCLUDE THE QUOTES IN THE WORD
          IEND = II-1
        ENDIF
        IBEG = IBEG+1
C NEED TO UPDATE ICABAN
C        ICABAN = ICABAN + IEND - IBEG + 3
      ENDIF
      IF (IEND-IBEG.LE.12) THEN
C NEED TO USE THE LOWERCASE VERSION FOR GENERAL TEXT
        CTCOMD(ICTPOS) = LLINE(ILINE)(IBEG:IEND)
        ICTPOS = ICTPOS + 1
        ICT = ICT + 1
      ELSE
        IK = ( IEND - IBEG + 1) / 12
        DO 901 II = 0 , IK-1
          CTCOMD(ICTPOS) = LLINE(ILINE)(IBEG+II*12:IBEG+II*12+11)
          ICTPOS = ICTPOS + 1
          ICT = ICT + 1
          IF (ICTPOS.EQ.20) GOTO 902
901     CONTINUE
902     CONTINUE
C NOW STORE THE LAST WORD
        IF (MOD(IEND-IBEG+1,12).NE.0) THEN
          CTCOMD(ICTPOS) = LLINE(ILINE)(IBEG+ICT*12:IEND)
          ICT = ICT + 1
          ICTPOS = ICTPOS + 1
        ENDIF
      ENDIF
C WRITE WORD INTO SCRATCH LOG FILE
      BACKSPACE (ISCRLG)
      WRITE (ISCRLG,'(3A)') '"',LINE(ILINE)(IBEG:IEND),'"'
C RESET END OF WORD POSITION
      IF (LINE(ILINE)(IEND+1:IEND+1).EQ.'"') IEND=IEND+1
C TREAT THE TEXT AS A DUMMY ENTRY IN ICCMMD.
C ICCMMD WILL CONTAIN THE NUMBER OF CTCOMD ENTRIES
      ICCMMD (ICCPOS) = ICT
      IC = IC + 1
      ICCPOS = ICCPOS + 1
      END
 
 
CODE FOR ZCIUDT [ COMMAND INFORMATION UPDATE]
      SUBROUTINE ZCIUDT
C This routine moves all the sub command info into the previous command place.
C and updates INFCMD
      
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

      IPREV(1) = IPREV(2)
      INCOM(1) = INCOM(2)
      IINT (1) = IINT(2)
      IRL (1) = IRL (2)
      ICHARS(1) = ICHARS(2)
      ICTYPE(1,1) = ICTYPE (2,1)
      ICTYPE (1,2) = ICTYPE (2,2)
      ICTYPE ( 1,3) = ICTYPE(2,3)
      ICTYPE(1,4) = ICTYPE(2,4)
      IN = 0
      IC = 0
      IR = 0
      RETURN
      END
 
 
 
CODE FOR ZCOMIN [COMMAND INPUT]
      SUBROUTINE ZCOMIN
C THIS IS THE CODE WHICH READS THE COMMAND FILE AND LOADS IT INTO MEMORY
C FIRST IT WILL LOAD THE COMMAND INDEX.
C VARIABLES :
C             ISINDX - this is the step length for the command index ie 1
C             ICOM - this is the start address for the commands
C             ISCOM - this is the step length for the commnands ie 2
C             ISRCOM - this is the step length for the real variables ie 6
C             ICLAST - this is the next position for character variables
C             IPRV - this contains the 'previous command' flag.
C The command file itself will consist of a three character command followed
C by two 80 character lines of help and error message.
      
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

      LOGICAL LFILES
C MAIN LOOP TO INPUT THE INDEX
C      OPEN (UNIT = 1,FILE = 'ORDER.DAT',STATUS = 'OLD')
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(-1,'SCRIPT\ORDER.CMN',IINPT))THEN
#else
      IF(.NOT.LFILES(-1,'script/order.cmn',IINPT))THEN
#endif
        CALL ZTXTMD
        CALL ZMORE('Error - file ORDER.CMN cannot be opened.',0)
        CALL ZMORE('CAMERON cannot continue.',0)
C cljf
        CALL ZMORE1('Error - file ORDER.CMN cannot be opened.',0)
        STOP
      ENDIF
      DO 10 I = 1,ITOT,ISINDX
      READ (IINPT,20,END = 30) CSTORE(I)
20    FORMAT (A6)
      ICOM = I+1
10    CONTINUE
30    CONTINUE
      IF (.NOT.LFILES (0,' ',IINPT)) THEN
        CALL ZMORE('Error on closing ORDER.CMN.',0)
      ENDIF
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(-1,'SCRIPT\COMMAND.CMN',IINPT))THEN
#else
      IF(.NOT.LFILES(-1,'script/command.cmn',IINPT))THEN
#endif
        CALL ZTXTMD
        CALL ZMORE('Error - file COMMAND.CMN cannot be opened.',0)
        CALL ZMORE('CAMERON cannot continue.',0)
C cljf
        CALL ZMORE1('Error - file COMMAND.CMN cannot be opened.',0)
        STOP
      ENDIF
CALCULATE THE POSITION IN THE REAL ARRAY
      IRLAST = ICOM
C INPUT THE MAIN COMMAND FILE
C WE DO NOT READ THE HELP AND ERROR MESSAGES INTO MEMORY
      DO 40 I = ICOM,ITOT,ISCOM
      READ(IINPT,50,END = 60) CSTORE(I),CSTORE(I+1),(RSTORE(K),
     c K = IRLAST,IRLAST+ISRCOM-1)
50    FORMAT (A6,A6,F6.0,5F8.0,//)
      IF (CSTORE(I)(1:1).EQ.'#') GOTO 60
      IRLAST = IRLAST+ISRCOM
40    CONTINUE
60    CONTINUE
      ICLAST = I
C NOW WE LOAD IN THE HEADER INFO - IF IT IS PRESENT
      IF (CSTORE(I)(1:1).NE.'#') GOTO 65
C GET THE NUMBER OF HEADER COMMANDS
      READ (IINPT,68) IHNUM,IHMAX
68    FORMAT (I2,2X,I2)
C LOOP OVER THESE NUMBERS
      IHMAX = IHMAX + 2
C THE EXTRA 2 IS FOR THE START AND NUMBER FLAGS
      ICHEAD = ICLAST
      ISHEAD = IRLAST
      DO 62 I = 1 , IHNUM
C READ IN THE HEADER NAME
        READ (IINPT,63) CSTORE(ICHEAD+(I-1)*2),
     c  CSTORE(ICHEAD+(I-1)*2+1),IH
63      FORMAT (A6,A6,2X,I4)
C STORE THE NUMBER AND POSITION OF THE INFO
        RSTORE(ISHEAD+(I-1)*IHMAX) = ICHEAD+(I-1)*2
        RSTORE(ISHEAD+(I-1)*IHMAX+1) = IH
C NOW GET THE NUMBERS
        DO 64 J = 1 , IH
          READ (IINPT,'(F4.0)') RSTORE(ISHEAD+(I-1)*IHMAX+1+J)
64      CONTINUE
62    CONTINUE
      IRLAST = ISHEAD + IHNUM*IHMAX
C NOW READ IN THE CHARACTER MENU TITLES
      READ (IINPT,'(80X)')
      IMCHAR = ICHEAD+IHNUM*2
      READ (IINPT,'(I4)') INCHAR
      DO 66 I = 1 , INCHAR
        READ (IINPT,67) CSTORE(IMCHAR+(I-1)*2), CSTORE(IMCHAR+(I-1)*2+1)
66    CONTINUE
67    FORMAT (2A6)
65    CONTINUE
      IF (.NOT.LFILES (0,' ',IINPT)) THEN
        CALL ZMORE('Error on closing COMMAND.CMN.',0)
      ENDIF
C NOW SET UP THE INDEX
C THE INDEX WILL CONTAIN THE POSTION IN THE RSTORE ARRAY OF THE
C INFO ABOUT THE COMMAND IN QUESTION.
      DO 70 I = 1,ICOM-1
            DO 80 J = ICOM,ICLAST-1,ISCOM
            K = ICOM + (J-ICOM)*ISRCOM/ISCOM
            IF (CSTORE(I).EQ.CSTORE(J)) THEN
              IF (NINT(RSTORE(K+1)).EQ.0) THEN
                RSTORE(I) = J
              ENDIF
            ENDIF
80          CONTINUE
70    CONTINUE
      IF (IHNUM.GT.0) THEN
C UPDATE ICLAST
        ICLAST = IMCHAR + INCHAR*2 - 2
      ENDIF
      RETURN
      END
 
CODE FOR ZCOMSH [COMMAND SEARCH]
C This is the routine that sets up the command search.
      SUBROUTINE ZCOMSH(ID,ICNUM,ITYPE)
      
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

      CHARACTER*4 WORD,COMM,WORD1
C VARIABLES :  LINE - this is the input line to be analysed
C              IBEG - this is the beginning of the word
C Note that only the first four characters will be checked
C              WORD - this is the word to be analysed
C              COMM - this is the common being compared
C              ISTART   - the starting position in the array
C              IFIN - the ending position for the search
C              ICNUM - the returned commands number, -1 if none found
C              ITYPE - this gives the search type
C                      1 - header search
C                      2 - sub command search
C              ID - this is the address of the previous command
C              IPCOM - this is the number of the previous command
C              INEW - this is the number of the found command
C              ICPREV - this is the previous number of the found command
 
      ICNUM = -1
      IF (ITYPE.EQ.1) THEN
        ISTART = 1
        IFIN = ICOM-1
        ISTEP = 1
      ELSE
C FOR A SUB COMMAND SEARCH DOWNWARDS FROM FIRST COMMAND, THEN BACKWARDS
C IF NOT FOUND
        ISTART = ID
        IFIN = ID+60
        ISTEP = ISCOM
        IF (IFIN.GT.ICHEAD-1) IFIN = ICHEAD-1
      ENDIF
      WORD = LINE(ILINE)(IBEG:IBEG+3)
C Need to see whether we have a short word eg IN.
      I = INDEX (WORD,' ')
      IF (I.EQ.3) THEN
        WORD1 = WORD(1:2)//'  '
        WORD = WORD1
      ENDIF
      DO 10 I = ISTART,IFIN,ISTEP
        COMM = CSTORE(I)(1:4)
        IF (WORD.EQ.COMM) THEN
          IF (ITYPE.EQ.2) THEN
C SUB COMMAND
            IPCOM= ABS(NINT(RSTORE(ICOM+(ID-ICOM)*ISRCOM/ISCOM)))
            INEW = ABS(NINT(RSTORE(ICOM+(I-ICOM)*ISRCOM/ISCOM)/100))
            ICPREV = NINT (RSTORE(ICOM+(I-ICOM)*ISRCOM/ISCOM+1))
            IF ((INEW.EQ.IPCOM/100).AND.(ICNUM.EQ.-1)) THEN
              IF (ICPREV.GT.1) THEN
C NEED TO CHECK PREVIOUS COMMAND
                IF (ICPREV.EQ.IPCOM) THEN
                  ICNUM = I
                  GOTO 11
                ENDIF
              ELSE
                ICNUM = I
                GOTO 11
              ENDIF
            ENDIF
          ELSE
C HEADER COMMAND
            ICNUM = I
            GOTO 11
          ENDIF
        ENDIF
10    CONTINUE
11    CONTINUE
      IF ((ICNUM.EQ.-1).AND.(ITYPE.EQ.2)) THEN
C DO BACKWARDS SEARCH
        ISTART = ID - 2
        IFIN = ID - 60
        IF (IFIN.LT.ICOM) IFIN=ICOM
        DO 20 I = ISTART,IFIN,-ISTEP
        COMM = CSTORE(I)(1:4)
        IF (WORD.EQ.COMM) THEN
           IPCOM= ABS(NINT(RSTORE(ICOM+(ID-ICOM)*ISRCOM/ISCOM)))
           INEW = ABS(NINT(RSTORE(ICOM+(I-ICOM)*ISRCOM/ISCOM)/100))
           ICPREV = NINT (RSTORE(ICOM+(I-ICOM)*ISRCOM/ISCOM+1))
           IF ((INEW.EQ.IPCOM/100).AND.(ICNUM.EQ.-1)) THEN
             IF (ICPREV.GT.1) THEN
C NEED TO CHECK PREVIOUS COMMAND
               IF (ICPREV.EQ.IPCOM) THEN
                 ICNUM = I
                 GOTO 12
               ENDIF
             ELSE
               ICNUM = I
               GOTO 12
             ENDIF
           ENDIF
        ENDIF
20    CONTINUE
12    CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZELMSH [ ELEMENT SEARCH ]
      SUBROUTINE ZELMSH (IELPOS,IERR,IPPACK)
C VARIABLES : IELPOS - this returns the position of the element name
C             IERR = 1 element not found
C             IERR = 0 element found
      
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

      IERR = 0
C ELEMENT SEARCH
      CALL ZCASCH ('          '
     c ,ICELM,ICLAST-1,1,IELPOS,IPPACK,INSTRT)
      IF (IELPOS.EQ.-1) THEN
        IERR = 1
        RETURN
      ENDIF
C NEED TO CHECK THAT THE ELEMENT IS PRESENT IN THE CURRENT LIST.
      IELPOS = IELPOS - ICELM + 1
      J = 0
      DO 10 I = ISINIT , IFVIEW -1 , IPACKT
        IF (NINT(RSTORE(I+IATTYP)).EQ.IELPOS) THEN
          J = 1
          GOTO 20
        ENDIF
10    CONTINUE
20    CONTINUE
      IF (J.EQ.0) IERR = 1
      IELPOS = IELPOS + ICELM - 1
      RETURN
      END
 
CODE FOR ZERRLN (IERRNO,IST,IE,WORD,NEWLN)
      SUBROUTINE ZERRLN (IERRNO,IST,IE,WORD,NEWLN)
C This performs the required edits of the command line.
      
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

      CHARACTER*30 WORD
      CHARACTER*(ICLEN) NEWLN
      IF (IERRNO.NE.2) THEN
C HOW LONG IS THE WORD?
        ILN = 0
        DO 10 I = 30, 1 , -1
          IF ((WORD(I:I).NE.' ').AND.(ILN.EQ.0)) ILN = I+1
10      CONTINUE
      ENDIF
C IF WE HAVE A SPACE - THEN MAKE THE WORD ONE CHARACTER LONG
      IF (ILN.EQ.0) ILN = 1
      IF ((IERRNO.EQ.1).OR.(IERRNO.EQ.5)) THEN
c NEED TO REPLACE THE OLD WORD WITH THE NEW ONE
C EDIT THE LINE
C WHAT IS THE DIFFERENCE IN LENGTH BETWEEN THE NEW AND OLD WORDS?
        IDIFF = IE - IST + 1 - ILN
        IF (IDIFF.LT.0) IDIFF = 0
        IF (IE+1.LT.ICLEN-IDIFF) IDIFF=0
        IF (IST.EQ.1) THEN
          NEWLN = WORD(1:ILN)//LINE(ILINE)(IE+1:ICLEN-IDIFF)
        ELSE
          NEWLN = LINE(ILINE)(1:IST-1)//WORD(1:ILN)//
     c    LINE(ILINE)(IE+1:ICLEN-IDIFF)
        ENDIF
C ALTER THE LOGFILE
        BACKSPACE (ISCRLG)
      ELSE IF (IERRNO.EQ.2) THEN
C DELETE ARGUMENTS
        IF (IST.EQ.1) THEN
          NEWLN = LINE(ILINE)(IE+1:ICLEN)
        ELSE
          NEWLN = LINE(ILINE)(1:IST-1)//LINE(ILINE)(IE:ICLEN)
        ENDIF
        BACKSPACE (ISCRLG)
      ELSE IF (IERRNO.GE.3) THEN
C ADD IN NEW ARGUMENTS / NEW SUB COMMAND
        IF (IST.EQ.1) THEN
          NEWLN = WORD(1:ILN)//LINE(ILINE)(1:ICLEN-ILN)
        ELSE
          NEWLN = LINE(ILINE)(1:IST-1)//WORD(1:ILN)
     c    //LINE(ILINE)(IST:ICLEN-ILN)
        ENDIF
        BACKSPACE (ISCRLG)
      ENDIF
      RETURN
      END
 
CODE FOR ZERROR [ ERROR HANDLING IN THE COMMAND LINE ]
C THIS ROUTINE DEALS WITH COMMAND LINE ERRORS AND CORRECTS THEM IF
C THE USER WISHES.
      SUBROUTINE ZERROR (IERRNO,IERRH,ERRTXT)
      CHARACTER*(*) ERRTXT
C This subroutine returns IERRH
C IERRH = 0 reprocess the command line
C       = 1 abandon the line
C       = 2 process if possible.
C The error numbers are passed in as IERRNO
C IERRNO = 1 word not recognised
C        = 2 too many arguments supplied
C        = 3 not enough arguments
C        = 4 incorrect multiple
C        = 5 file does not exist
C        = 6 we need a sub command to be added to the line
      
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

      IF (IEDIT.EQ.0) THEN
C EDIT IS TURNED OFF
        CALL ZBEEP
        CALL ZMORE('ERROR. Re-enter command.',0)
        CALL ZMORE(ERRTXT,0)
        CALL ZMORE1('ERROR. Re-enter command. See main window',0)
        IERRH = 1
        RETURN
      ENDIF

C PRINT OUT THE ERROR MESSAGE
cdjwjan00      CALL ZMORE(' ',0)
      CALL ZMORE(ERRTXT,0)
cdjwjan00      CALL ZMORE(' ',0)
C PRINT OUT THE LINE HIGHLIGHTING THE ERROR
C CHECK TO SEE IF WE HAVE MOVED ON A LINE
      IF (IBEG.EQ.-1) THEN
        ILINE = ILINE - 1
        IF (ILINE.EQ.10) ILINE= 10
C FIND END OF THE LINE
        DO 10 I = ICLEN , 1 , -1
          IF (LINE(ILINE)(I:I).NE.' ') GOTO 11
10      CONTINUE
11      CONTINUE
        IBWORD = I + 2
      ENDIF
      IE = IBEG+30
      IF (IE.GT.ICLEN) IE=ICLEN
      GOTO (100,200,300,300,100,300) IERRNO
100   CONTINUE
C WORD NOT RECOGNISED
C FIND THE END OF THE WORD
      IE = 0
      DO 110 I = IBEG, ICLEN
        IF ((LINE(ILINE)(I:I).EQ.' ').AND.(IE.EQ.0)) IE = I
110   CONTINUE
      IF (IBEG.EQ.1) THEN
        WRITE (CLINE,'(4A)') '*',LINE(ILINE)(IBEG:IE-1),'*',
     c  LINE(ILINE)(IE:ICLEN)
      ELSE
        WRITE (CLINE,'(5A)') LINE(ILINE)(1:IBEG-1),'*',
     c  LINE(ILINE)(IBEG:IE-1),'*',LINE(ILINE)(IE:ICLEN)
      ENDIF
      CALL ZMORE(CLINE,0)
      IST = IBEG
      GOTO 400
200   CONTINUE
CC WE NEED TO FIND THE NEXT COMMAND
      IST = IBEG
      IE = IEND+1
C NO COMMAND FOUND ON THIS LINE
      IF (IST.EQ.1) THEN
        WRITE (CLINE,'(4A)') '*',LINE(ILINE)(IST:IE),'*',
     c LINE(ILINE)(IE+1:ICLEN)
      ELSE
        WRITE (CLINE,'(5A)') LINE(ILINE)(1:IST-1),'*',
     c LINE(ILINE)(IST:IE-1)//'*'//LINE(ILINE)(IE:ICLEN)
      ENDIF
      CALL ZMORE(CLINE,0)
      GOTO 400
300   CONTINUE
C NEED TO SUPPLY ARGUMENTS
      IF (IBEG.EQ.1) THEN
        WRITE (CLINE,'(2A)') '** ',LINE(ILINE)
      ELSE IF (IBEG.EQ.-1) THEN
        WRITE (CLINE,'(2A)') LINE(ILINE)(1:IBWORD),'**'
        IBEG = IBWORD
      ELSE
        WRITE (CLINE,'(3A)') LINE(ILINE)(1:IBEG-1),'** ',
     c  LINE(ILINE)(IBEG:ICLEN)
      ENDIF
      CALL ZMORE(CLINE,0)
      IST = IBEG
      GOTO 400
400   CONTINUE
C NOW SUPPLY THE USER WITH CHOICES
      CALL ZERCHO (ICHOIC,IERRNO,IST,IE)
      IF (ICHOIC.EQ.1) THEN
C PROCESS
        IERRH=2
      ELSE IF (ICHOIC.EQ.2) THEN
C ABANDON
        IERRH = 1
      ELSE IF (ICHOIC.EQ.3) THEN
C RE-PROCESS THE COMMAND LINE (THE EDITING WILL HAVE BEEN DONE IN
C XERCHO )
        IERRH = 0
      ENDIF
C      IF (IMENCN.GT.0) CALL ZMNRED(1)
      RETURN
      END
 
CODE FOR ZGNHLP [ READ GENERAL HELP FILE ]
      SUBROUTINE ZGNHLP
      
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

      CHARACTER*80 GENHELP
      CHARACTER*80 HELTIT
      CHARACTER*80 HELNAM
      INTEGER NITEM,I
      INTEGER IFLAG
      LOGICAL LFILES
      IFLAG = 1
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(-1,'SCRIPT\GENHELP.CMN',12))THEN
#else
      IF(.NOT.LFILES(-1,'script/genhelp.cmn',12))THEN
#endif
        CALL ZMORE(
     +'Error - help information file GENHELP.CMN not available.',0)
       RETURN
      ENDIF
10    READ (12,'(A80)',END=20) GENHELP
      CALL ZMORE(GENHELP,IFLAG)
      IFLAG =2
      GOTO 10
20    CONTINUE
      IF (.NOT.LFILES (0,' ',12)) THEN
        CALL ZMORE('Error on closing GENHELP.CMN.',0)
      ENDIF
C NOW WORK OUT THE HEADER COMMANDS AND PRINT THEM OUT ACCORDING
C TO THE GROUPING IN THE MENU FILE
C LOOP OVER THE HEADER NAMES
      DO 30 I = ISHEAD , ISHEAD + (IHNUM-1)*IHMAX , IHMAX
        HELTIT = 'Commands dealing with : ' //
     +  CSTORE(NINT(RSTORE(I)))//CSTORE(NINT(RSTORE(I))+1)
cdjwjan00        CALL ZMORE(' ',2)
        CALL ZMORE(HELTIT,2)
cdjwjan00        CALL ZMORE(' ',2)
        NITEM = 1
        DO 40 J = 1 , NINT(RSTORE(I+1))
C GET THE GROUP NUMBERS
          IGNUM = NINT(RSTORE(I+1+J))/100
C LOOP OVER THE COMMAND FILE
          DO 50 K = ICOM , ISHEAD-1 , ISRCOM
            IF (ABS(NINT(RSTORE(K)))/100.NE.IGNUM) GOTO 50
            IF (NINT(RSTORE(K+1)).NE.0) GOTO 50
C WE HAVE FOUND A COMMAND IN THIS GROUP
            ICHPOS = (K-ICOM)/ISRCOM*ISCOM + ICOM
            HELNAM(NITEM:NITEM+19) = CSTORE(ICHPOS)//CSTORE(ICHPOS+1)
     +   //'       '
            NITEM = NITEM + 20
            IF (NITEM.GE.80) THEN
              CALL ZMORE(HELNAM,2)
              NITEM=1
            ENDIF
50        CONTINUE
40      CONTINUE
        IF (NITEM.NE.1) THEN
          HELNAM(NITEM:80)='                                    '
     +//'                                        '
         CALL ZMORE(HELNAM,2)
        ENDIF
30    CONTINUE
      RETURN
      END
 
CODE FOR ZINCSS
      SUBROUTINE ZINCSS
      
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

C THIS ROUTINE READS IN THE CSSR FILE FORMAT (NUMBER 1)
      CHARACTER*6 ATOMNM
      CHARACTER*9 LABEL
      CHARACTER*60 FILENM
      REAL ORTHI (3,3), COORDS(3), MIN(3),MAX(3)
      INTEGER ICON(8)
      INTEGER ICONN(8,3)
      LOGICAL LOPEN,LFILES
      DATA ICONN/2,1,2,1,1,2,3,4,5,3,4,3,6,5,6,5,4,6,7,8,8,7,8,7/
C THIS READS IN THE ATOMIC INFORMATION FROM A CSSR FILE.
C THE INFO IS THE ATOM LABEL, COORDS, CONNECTIVITY AND UNIT CELL
C DATA.
C ASSUME NO BLANK LINES AT THE TOP OF THE FILE
C CREATE THE SCRATCH FILE
      INQUIRE (UNIT=ISCRAT,OPENED=LOPEN)
      IF (LOPEN) THEN
        IF (.NOT.LFILES (0, ' ' , ISCRAT)) THEN
          CALL ZMORE('Error on closing symmetry scratch file.',0)
        ENDIF
      ENDIF
      IF (.NOT.LFILES (8,' ', ISCRAT)) THEN
        CALL ZMORE('Error on opening symmetry scratch file.',0)
        IPROC = 0
        RETURN
      ENDIF
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT ( FILENM , 60 , NPOS )
      IF (.NOT.LFILES (1,FILENM,IINPT)) THEN
        CALL ZMORE('Error - cannot open file.',0)
        CALL ZMORE(FILENM,0)
        IPROC = 0
        RETURN
      ENDIF
      IREND = ISYMED-IGMAX
      ICONBG = IREND
C SET FLAGS FOR CENTRE CALCULATION
      DO 10 I = 1 , 3
        MIN(I) = 1000000.0
        MAX(I) = -1000000.0
10    CONTINUE
C FIRST READ IN THE CELL INFO
      READ (IINPT,1000) A,B,C
1000  FORMAT (38X,3F8.3)
      READ (IINPT,1001) ALP,BET,GAM
1001  FORMAT (21X,3F8.3)
      CALL ZCRYST (A,B,C,ALP,BET,GAM)
      CALL ZVIMAT
C      IREND = IBPOS
C GET THE RESULTING INVERSE ORTHOGONALISATION MATRIX
      CALL ZMOVE (RSTORE(ICRYST+15),ORTHI,9)
C GET THE NUMBER OF ATOMS
      READ (IINPT,1002) NATOM, IORTH
1002  FORMAT (I4,3X,I1,/)
C IORTH GIVES THE TYPE OF COORDINATES -
C  0 - FRACTIONAL, 1 - ORTHOGONAL.
C READ IN THE COORDINATES
      IRATOM = IRLAST
      ICATOM = ICLAST
      K = IRATOM
      DO 20 I = ICATOM , ICATOM + NATOM - 1
        IF ((MOD ( I - ICATOM , 50 ).EQ.0).AND.((I-ICATOM).NE.0)) THEN
          WRITE (CLINE,11) I-ICATOM
          CALL ZMORE(CLINE,0)
11        FORMAT (I5,' atoms loaded.')
        ENDIF
        READ (IINPT,1003) IATN , ATOMNM, COORDS, ICON
1003    FORMAT (I4,A6,3F10.5,1X,8I4)
C DO WE NEED TO DEORTHOGONALISE THESE?
C ZERO THE INFO
        CALL ZZEROF (RSTORE(K),IPACKT)
        IF (IORTH.EQ.1) THEN
C YES
          CALL ZMATV (ORTHI, COORDS, COORDS )
        ENDIF
C STORE THE RESULT
        RSTORE(K) = 1.0
        DO 30 J = 1 , 3
          RSTORE(K+J) = COORDS(J)
          IF (MIN(J).GT.COORDS(J)) MIN(J) = COORDS(J)
          IF (MAX(J).LT.COORDS(J)) MAX(J) = COORDS(J)
30      CONTINUE
        RSTORE (K+IPCK+1) = 1.0
C SET THE TEMPERATURE FACTORS TO THE LOWEST ALLOWED VALUE
        RSTORE (K+IXYZO+12) = -RNUISO
C FIND OUT WHICH BIT OF THE NAME IS THE ELEMENT
        II = INDEX ( ATOMNM , ' ')
        IF (II.EQ.1) THEN
          LABEL = ATOMNM(2:6)//' '
        ELSE
          LABEL = ATOMNM
        ENDIF
C CONVERT TO UPPERCASE FOR ANALYSIS
        CALL ZUPCAS(LABEL)
        CALL ZELEM (LABEL,IPOS,2)
        CSTORE(I) = LABEL
        RSTORE (K+IATTYP) = IPOS - ICELM + 1
C MOVE OVER THE CONN RADIUS ETC
        RSTORE(K+IATTYP+5) = RSTORE ( NINT ( IRELM + ( RSTORE (K+IATTYP)
     c      -1 )*4.0 ) )
        RSTORE(K+IATTYP+4) = RSTORE(K+IATTYP+5)/4.0
        RSTORE(K+IATTYP+1) =
     c  RSTORE ( NINT( IRELM + (RSTORE(K+IATTYP)-1) *4.0 + 3 ) )
C NOW DO THE BOND DATA
        DO 70 J = 0 , 7
C NEED TO STORE THE BOND INFO
           RSTORE(IREND-J) = ICON(J+1)
70      CONTINUE
        IREND = IREND - 8
C CHECK FOR SPECIAL POSITION
        RSTORE(K+ISYM) = LSPECH(K)
        K = K + IPACKT
20    CONTINUE
      ICLAST = ICATOM + NATOM
      IRLAST = IRATOM + (NATOM*IPACKT)
C MODIFY IRATOM AND ICATOM TO ALLOW FOR UNIT CELL VERTICES
      IRATOM = IRATOM - IPACKT*8
      ICATOM = ICATOM - 8
      ISINIT = IRATOM
      IFINIT = IRLAST
      ISVIEW = ISINIT
      IFVIEW = IFINIT
      IRLAST = IFINIT + ICONBG - IREND
C ARRAY TO LEAVE SPACE FOR THE OTHER INFORMATION
C NOW WORK OUT THE CONNECITIVITY - WE NEED TO MOVE IT DOWN THE
      CALL ZMOVE (RSTORE(IREND),RSTORE(IFINIT),ICONBG-IREND+1)
      IREND = ISYMED - IGMAX
      IBPOS = IREND
C DO THE CELL BONDS
      DO 2 I = 1,8
        DO 3 J = 1,3
          RSTORE (IBPOS-J*2+2) = (ISINIT+((ICONN(I,J)-1)*IPACKT))
          RSTORE (IBPOS-J*2+1) = ICELLC*10
3       CONTINUE
        RSTORE (ISINIT+(I-1)*IPACKT+IBOND) = IBPOS
        RSTORE (ISINIT+(I-1)*IPACKT+IBOND+1) = 3.0
        IBPOS = IBPOS - 6
2     CONTINUE
C NOW LOOP OVER THE ATOMS
      DO 80 I = ISINIT+IPACKT*8 , IFINIT-1 , IPACKT
        RSTORE(I+IBOND) = IBPOS
        NBNDST = IBPOS
        NBONDS = 0
        INAT = (I-ISINIT)/IPACKT - 8
C FIRST COPY OVER THE BONDS STORED FOR THIS ATOM
        DO 90 J = IRLAST-INAT*8 , IRLAST-INAT*8-7,-1
          IF (NINT(RSTORE(J)).NE.0) THEN
            RSTORE(IBPOS) = (RSTORE(J)+7)*IPACKT+ISINIT
            RSTORE(IBPOS-1) = IBNDCL*10
            IBPOS = IBPOS - 2
            NBONDS = NBONDS + 1
          ENDIF
90      CONTINUE
        IF (NBONDS.LT.8) THEN
C THERE WERE BLANK SPACES IN THE BOND INFO SO WE CAN ASSUME THAT
C THERE ARE NO MORE BONDS
          RSTORE(I+IBOND+1) = NBONDS
          GOTO 80
        ENDIF
C OTHERWISE WE NEED TO SEARCH THE LIST FOR THIS ATOMS NUMBER
        DO 100 J = IFINIT , IRLAST
          IF (NINT(RSTORE(J)).EQ.INAT+1) THEN
            INAT1 = ((IRLAST-J)/8 + 8 )*IPACKT + ISINIT
            KKK = 0
C LOOP TO SEE IF THIS BOND IS STORED ALREADY
            DO 110 K = NBNDST , NBNDST-(NBONDS-1)*2 , -2
              IF (NINT(RSTORE(K)).EQ.INAT1) THEN
                KKK = 1
                GOTO 111
              ENDIF
110         CONTINUE
111         CONTINUE
            IF (KKK.EQ.0) THEN
              RSTORE(IBPOS) = INAT1
              RSTORE(IBPOS-1) = IBNDCL*10
              IBPOS = IBPOS - 2
              NBONDS = NBONDS + 1
            ENDIF
          ENDIF
100     CONTINUE
        RSTORE(I+IBOND+1) = NBONDS
80    CONTINUE
      IREND = IBPOS
      ICONED = IREND
      CALL ZCENTR (MIN,MAX)
      CALL ZCOLKY
      WRITE (CLINE,11) NATOM
      CALL ZMORE(CLINE,0)
      IF (.NOT.LFILES (0,FILENM,IINPT)) THEN
        CALL ZMORE('Error on closing CSSR file.',0)
      ENDIF
      IF (.NOT.LFILES (0, ' ',ISCRAT)) THEN
        CALL ZMORE('Error on closing symmetry scratch file.',0)
      ENDIF
      RETURN
      END
 
CODE FOR ZCOLOT [ COLOUR TABLE INPUT ]
      SUBROUTINE ZCOLOT
      
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

      CHARACTER*6 CNAME
      INTEGER IVALS(6)
      INTEGER IPOS
      LOGICAL LSTOP,LFILES
C CHECK FOR THE FILES EXISTENCE
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(-1,'SCRIPT\COLOUR.CMN',IINPT))THEN
#else
      IF(.NOT.LFILES(-1,'script/colour.cmn',IINPT))THEN
#endif
        CALL ZTXTMD
        CALL ZMORE ('Error : COLOUR.CMN not available',0)
        CALL ZMORE ('CAMERON cannot continue.',0)
        CALL ZMORE1 
     1 ('Error : COLOUR.CMN not available CAMERON cannot continue.',0)
C cljf
        CALL ZMORE1 ('Error : COLOUR.CMN not available',0)
        STOP
      ENDIF
C READ IN THE BLANK LINES
      READ (IINPT,'(////)')
      IPOS = 1
10    CONTINUE
C LOOP TO READ THE DATA
      READ (IINPT,'(A6,6I5)',ERR=9999) CNAME,IVALS
C STORE THE RESULT
      COLNAM(IPOS) = CNAME
      DO 20 I = 1 , 3
        IVGACL(I,IPOS) = nint(float(IVALS(I))*0.63)
        IPSTCL(I,IPOS) = IVALS(I+3)
20    CONTINUE
      IPOS = IPOS + 1
      IF (IPOS.LE.17) GOTO 10
C CLOSE THE FILE
      IF (.NOT.LFILES(0,' ',IINPT)) THEN
        CALL ZMORE('Error on closing COLOUR.CMN',0)
      ENDIF
      RETURN
9999  CONTINUE
C ERROR HANDLING
      CALL ZTXTMD
      CALL ZMORE ('Error in file COLOUR.CMN',0)
      LSTOP = LFILES(0,' ',IINPT)
C cljf
      CALL ZMORE1 ('Error in file COLOUR.CMN',0)
      STOP
      END
 
CODE FOR ZINELP [ELEMENTAL PROPERTIES INPUT]
      SUBROUTINE ZINELP
C THIS ROUTINE LOADS IN THE ELEMENTAL PROPERITES TABLE
C The info is read in from the file PROP.DAT which was moved over from
C CRYSTALS. The info contained is -
C ATOM NAME
C COVALENT RADIUS, IONIC RADIUS, VAN DER WAALS RADIUS,[ ATOMIC WEIGHT,
C ABSORPTION COEFFS (Cu and Mo) ] AND COLOUR.
C The info is stored at IRELM and ICELM in RSTORE and CSTORE.
C The file contains info about NELM elements.
      
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
      CHARACTER*2 LABEL
      CHARACTER*6 CCOL
      REAL COV,ION,VAN
      LOGICAL LFILES
c      IF (.NOT.LFILES (-1,'script\PROP.CMN',IINPT)) THEN
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(-1,'SCRIPT\PROPWIN.DAT',IINPT))THEN
#else
      IF(.NOT.LFILES(-1,'script/propwin.dat',IINPT))THEN
#endif
        CALL ZTXTMD
        CALL ZMORE('Error - file PROPWIN.DAT cannot be accessed.',0)
        CALL ZMORE('CAMERON cannot continue.',0)
C cljf
        CALL ZMORE1('Error - file PROPWIN.DAT cannot be accessed.',0)
        STOP
      ENDIF
C OPEN FILE, CONNECT TO UNIT 11
      IRELM = IRLAST
      ICELM = ICLAST
      J = IRELM
C-DJW NELM counted from the PROPWIN.DAT file - MAX SET IN BLOCK.FOR
      JELM = 0
      DO 10 I = ICELM , ICELM + NELM - 1
C READ IN THE INFO
      READ (IINPT,20,END=15) LABEL,COV,ION,VAN, CCOL
      READ (IINPT,'( )')
      READ (IINPT,'( )')
20    FORMAT (A2,8X,F6.2,6X,F5.2,6X,F5.2,23X,6A)
C STORE THE INFO
      JELM = JELM + 1
      CSTORE (I) = LABEL
      RSTORE (J) = ABS(COV)
      RSTORE (J+1) = ION
      RSTORE (J+2) = VAN
C WORK OUT THE COLOUR NUMBER
      CALL ZGTCOL (CCOL,N)
      RSTORE ( J+ 3) = N
      J = J + 4
10    CONTINUE
      IF (JELM .LE. NELM) THEN
            NELM = JELM
      ELSE
            CALL ZMORE (' Too many elements in PROPWIN.DAT', 0)
      ENDIF
15    CONTINUE
      IF (.NOT.LFILES (0,' ',IINPT)) THEN
        CALL ZMORE('Error on closing PROPWIN.DAT',0)
      ENDIF
      ICLAST = I + 1
      IRLAST = J
      RETURN
      END
 
CODE FOR ZQUERY
      SUBROUTINE ZQUERY(ITYPE)
      
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
      CHARACTER*10 WORD
      CHARACTER*80 HLPMESS
      CHARACTER*1 ANS
      LOGICAL LFILES
C HELP can be obtained in three contexts. (ihtype)
C 1 - during a command/sub command. If a command is incomplete help is
C provided on the arguments that are required.
C 2 - If a command is complete then info is given on possible sub
C commands (if any).
C 3 - if HELP is issued at the beginning of a line and the previous
C command is completed then HELP is given on the command following
C ie HELP VIEW would give help on view. Here HELP on its own will give
C general help information.
C
C As well as this there are two sorts of help -
C HELP (itype=-2) gives info on sub commands together with their help
Clines.
C ? (itype=-1) just gives the help line on the current command
c
C What context is the help being used in?
C Have any args been entered and can we have a direct sub command?
      IF ((ABS(ICTYPE(2,1)).EQ.4).AND.(IN.EQ.0).AND.(IR.EQ.0).AND.
     c (IC.EQ.0)) THEN
C SUB COMMAND POSSIBLE
        IHTYPE = 2
      ELSE
C HAVE WE FINISHED THE PREVIOUS COMMAND?
        CALL ZCICNT (4,IERR)
        IF ((IERR.EQ.0).OR.(IERR.EQ.9)) THEN
C ARE WE AT THE BEGINNING OF A LINE?
          IF (IBEG.NE.1) THEN
            IHTYPE = 2
          ELSE
            IHTYPE = 3
          ENDIF
        ELSE
          IHTYPE = 1
        ENDIF
      ENDIF
      IF (IHTYPE.EQ.3) THEN
C OPTION 3 NEED TO GET THE NO OF THE QUALIFYING COMMAND.
        ICTYP = 1
3       CALL ZWORD (IERR)
        IF (IERR.EQ.3) THEN
          IF (ICTYP.EQ.1) THEN
C NO NEXT WORD DO GENERAL HELP????
            CALL ZGNHLP
            RETURN
          ELSE
            GOTO 5
          ENDIF
        ELSE
C FIRST TIME AROUND LOOK FOR HEADER
          CALL ZCOMSH (ID,ICNUM,ICTYP)
          IF (ICNUM.EQ.-1) THEN
            CALL ZCLEAR
            WRITE (CLINE,'(2A)') 'Sorry no help on '
     c      ,LINE(ILINE)(IBEG:IEND)
            CALL ZMORE(CLINE,0)
            CALL ZGNHLP
            RETURN
          ENDIF
          IF (ICTYP.EQ.1) THEN
            ID = NINT(RSTORE(ICNUM))
          ELSE
            ID = ICNUM
          ENDIF
          ICTYP = 2
          GOTO 3
        ENDIF
      ELSE
        ID = ICOMMD (ICPOS-1)
      ENDIF
C LOAD IN THE HELP MESSAGE
5     CONTINUE
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(-1,'SCRIPT\COMMAND.CMN',IINPT))THEN
#else
      IF(.NOT.LFILES(-1,'script/command.cmn',IINPT))THEN
#endif
        CALL ZMORE('Error - cannot access COMMAND.CMN',0)
        HLPMESS = 'Help unavailable.'
        WORD = '******'
      ELSE
C LOAD IN THE HELP MESSAGE
        CALL ZCLEAR
        CALL ZMORE(LINE(ILINE) , 1)
C      WRITE (ISTOUT,'(A)') LINE(ILINE)
        DO 10 I = 1, (ID-ICOM)/ISCOM
10      READ (IINPT,'(//)')
        READ (IINPT,11) WORD,HLPMESS
        IF (.NOT.LFILES (0,' ',IINPT))
     +  CALL ZMORE('Error on closing COMMAND.CMN.',0)
      ENDIF
11    FORMAT (A10,/,A80)
      WRITE (CLINE,12) WORD
      CALL ZMORE(CLINE,0)
      CALL ZMORE(HLPMESS,0)
12    FORMAT ('Help Information on :',A10)
C LOAD IN THE LIST OF POSSIBLE SUB COMMANDS
      IF (IHTYPE.NE.1) THEN
        CALL ZERRLD (ID,INSUB,-ITYPE)
      ENDIF
      IF (IHTYPE.EQ.3) RETURN
      WRITE (CLINE,14)
      CALL ZMORE(CLINE,0)
15    CALL ZGTANS(ANS,0)
      IF (ANS.EQ.'A'.OR.ANS.EQ.'a') THEN
C ABANDON THE LINE
        IPROC = 0
      ELSE IF (ANS.EQ.'C'.OR.ANS.EQ.'c') THEN
C CONTINUE
C REMOVE THE HELP FROM THE LOG SCRATCH FILE
        BACKSPACE (ISCRLG)
        WRITE (ISCRLG,'(A)')
        BACKSPACE (ISCRLG)
        IBEG = -1
        IPROC = 3
        IF (ITYPE.EQ.2) THEN
          IF (IEND.GT.4) THEN
            CALL ZMORE(LINE(ILINE)(1:IEND-4),0)
          ENDIF
        ELSE
          IF (IEND.GT.2) THEN
            CALL ZMORE(LINE(ILINE)(1:IEND-2),0)
          ENDIF
        ENDIF
C      ELSE IF (ANS.EQ.'p'.OR.ANS.EQ.'P') THEN
C PROCESS
C        IPROC = 2
       ELSE
        CALL ZMORE('?',0)
        GOTO 15
      ENDIF
14    FORMAT ('Do you want to Continue or Abandon the line? (C,A)')
      RETURN
      END
 
CODE FOR ZINL5 [ READ IN LIST5 FILE ]
      SUBROUTINE ZINL5
      dimension djwtmp(6)      
      dimension idjwtmp(6)      
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

      CHARACTER*9 ATOMNM
      CHARACTER*60 FILENM
      CHARACTER*80 CDUMP1, CDUMP2
      CHARACTER*6 CELLAB(8)
      LOGICAL LFILES
      REAL COORDS(11),MIN(3),MAX(3),TENSOR(3,3),AXES(3,3),AXESC(3,3)
      REAL EIGS(3),ELOR(3,3),ELORT(3,3)
      LOGICAL LOPEN
      EQUIVALENCE (djwtmp(1), idjwtmp(1))
      DATA CELLAB /'0    ','a    ','     ','c     ','b     ','      ',
     c '      ','      '/
C THIS ROUTINE READS IN INFO FROM A LIST 5 FILE - CONNECTED TO DEV 11
C THE INFO STORED IN THIS FILE IS -
C ATOM NAME,NUMBER,X,Y,Z,U[ISO],U11,U22,U33,U23,U13,U12.
C ICATOMS is the start of the atom information
C ISATM is the step size in the database.
C Other information stored in the file but not used by CAMERON - eg
C scale factors is held in CSTORE, the number of lines used is held in
C ICLST5
CALCULATE THE RECIPROCAL LATTICE ANGLES FOR USE WITH U[ISO]
CONVERSION.
C CREATE THE SCRATCH FILE FOR THE ELEMENT NAMES
      INQUIRE (UNIT=ISCRAT,OPENED=LOPEN)
      IF (LOPEN) THEN
        IF (.NOT.LFILES(0,' ',ISCRAT))
     +CALL ZMORE('Error on closing symmetry scratch file.',0)
      ENDIF
      IF (.NOT.LFILES (8,' ',ISCRAT)) THEN
        CALL ZMORE('Error on opening symmetry scratch file.',0)
        IPROC = 0
        RETURN
      ENDIF
C GET THE ORTHOGONALISATION MATRICES
      CALL ZMOVE (RSTORE(ICRYST+24),ELOR,9)
      CALL ZMOVE (RSTORE(ICRYST+33),ELORT,9)
      ALP = RSTORE(ICRYST+3) * PI / 180.0
      BET = RSTORE(ICRYST+4) * PI / 180.0
      GAM = RSTORE(ICRYST+5) * PI / 180.0
      CSASTR = (COS(BET)*COS(GAM)-COS(ALP)) / (SIN(BET)*SIN(GAM))
      CSBSTR = (COS(ALP)*COS(GAM)-COS(BET)) / (SIN(ALP)*SIN(GAM))
      CSGSTR = (COS(ALP)*COS(BET)-COS(GAM)) / (SIN(ALP)*SIN(BET))
      DO 1 I = 1,3
      MIN(I) = 100.0
1     MAX(I) = -100.0
C GET THE FILENAME
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT ( FILENM, 60,NPOS)
      IF (.NOT.LFILES(1,FILENM,IINPT)) THEN
        CALL ZMORE('Error on opening file.',0)
        CALL ZMORE(FILENM,0)
        IPROC = 0
        RETURN
      ENDIF
C FIRST READ IN NUMBER OF ATOMS
      CALL ZMORE('INPUTTING FILE',0)
      READ (IINPT,10,ERR=9999) NATOM,CDUMP1, CDUMP2
10    FORMAT (////,12X,I7,A80,/,A80)
C CHECK IS THERE ROOM FOR THIS NUMBER OF ATOMS?
      NROOM = NATOM * IPACKT
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.EQ.-1) THEN
        IPROC = 0
        CALL ZMORE('Not enough room to read in all the atoms',0)
        RETURN
      ENDIF
C WE NOW NEED TO STORE THE "DUMMY" LINES
      DO 1005 I = 0,12
        CSTORE(ICLAST+I) = CDUMP1 (I*6+1:I*6+7)
        CSTORE (ICLAST+I+14) = CDUMP2 (I*6+1:I*6+7)
1005  CONTINUE
      CSTORE(ICLAST+13) = CDUMP1 ( 79 : 80 )//'    '
      CSTORE (ICLAST+27) = CDUMP2 (79:80) //'    '
      ICLST5 = 0
C NOW WE NEED TO CHECK THE LAST LINES OF THE FILE
cnov2000  skip all the atom data
      DO 1001 I = 1 , 3*NATOM
c        READ (IINPT,'(/)')
        READ (IINPT,'(1x)')
1001  CONTINUE
      ICLAST = ICLAST + 28
1002  CONTINUE
C GET THE NEXT LINE
      READ (IINPT,'(A80)') CDUMP1
      IF (CDUMP1(1:4).NE.'END ') THEN
C WE HAVE GOT INFO AT THE FILE END - READ AND STORE IT
        DO 1004 I = 0,12
          CSTORE(ICLAST+I) = CDUMP1 (I*6+1:I*6+7)
1004    CONTINUE
        CSTORE(ICLAST+13) = CDUMP1 ( 79 : 80 )//'    '
        ICLAST = ICLAST + 14
        ICLST5 = ICLST5 + 1
        GOTO 1002
      ENDIF
C REPOSITION FILE
      REWIND (IINPT)
      READ (IINPT,'(/////)')
      IRATOM = IRLAST
      K = IRATOM
C NEED TO STORE CELL LABELS AGAIN
      ICATOM = ICLAST
      DO 13 I = ICATOM , ICATOM+7
        CSTORE(I) = CELLAB(I-ICATOM+1)
13    CONTINUE
      ICATOM = ICATOM + 8
      DO 20 I = ICATOM,ICATOM+NATOM-1
      IUISO = 0
C READ IN THE COORDS ETC.
      IF ((MOD ( I - ICATOM , 50 ).EQ.0).AND.(I-ICATOM.NE.0) ) THEN
        WRITE (CLINE,11) I-ICATOM
        CALL ZMORE(CLINE,0)
11    FORMAT (I5, ' atoms loaded .')
      ENDIF
      READ (IINPT,30,ERR=9999) ATOMNM,RSEI,(COORDS(J),J=1,5)
      WRITE(ATOMNM(5:),'(I5)')NINT(RSEI)
      READ (IINPT,31,ERR=9999) (COORDS(J),J=6,11)
cdjwjul2012
      if(coords(6)+coords(7)+coords(8).le.0.0001) then
       call zmore('Impossibly small adps',0)
       call zzerof(coords(6),6)
       coords(6)=0.0001
       coords(7)=0.0001
       coords(8)=0.0001
c      set flag to ISO
       coords(2) = 1.
      endif
cnov2000
      read (iinpt,32,err=9999) djwtmp(1),(idjwtmp(j),j=2,5)
c      read (iinpt,32,err=9999) ( djwtmp(j),j=1,5 )
30    FORMAT (5X,A5,F11.0,5F11.6)
31    FORMAT (10X,6F11.6)
32    FORMAT (10X,F11.6,3I11,7X,A4)
c ATOM C       1.000000   1.000000   0.000000  -0.227446   0.085452   0.065982
c CON U[11]=   0.047883   0.039787   0.042615   0.003707  -0.000464  -0.004190
c CON SPARE=   0.000000  000000000  000000000 -000000000       text
C ANALYSE AND STORE THE DATA
      CALL ZELEM (ATOMNM,IELM,1)
      CSTORE ( I ) = ATOMNM
C STORE THE REAL INFO
C INITIALISE THE ARRAY SPACE
      DO 101 L = 0 , IPACKT-1
      RSTORE(K+L) = 0.0
101   CONTINUE
cnov2000 store away the excess goodies
      do 102 l = 14,18
      rstore(k+l) = djwtmp(l-13)
102   continue 
C MAKE ALL ATOMS 'LINE' INITIALLY
      RSTORE (K) = 1.0
      DO 70 KK = 1,3
      IF (MIN(KK).GT.COORDS(KK+2)) MIN(KK) = COORDS(KK+2)
      IF (MAX(KK).LT.COORDS(KK+2)) MAX(KK) = COORDS(KK+2)
70    RSTORE (K+KK) = COORDS(KK+2)
C DO WE HAVE A U[ISO]?
CNOV      IF (ABS(COORDS(2)-0.00).LT.0.00000001) THEN
      IF (ABS(COORDS(2)).LT.0.00000001) THEN
C NO - STORE ANISO U'S
        DO 40 KK = 4,9
          RSTORE (K+KK) = COORDS(KK+2)
40      CONTINUE
      ELSE
CNOV98  ISOTROPIC U - SEE IF WE CAN PICK UP THE OLD FORMS
        IF (COORDS(2) .LT. .99999) THEN
C         WE HAVE AN OLD FORM
          COORDS(6) = COORDS(2)
        ENDIF
CNOV    IF (COORDS(2).LE.0.0) THEN
        IF (COORDS(6).LT.0.0) THEN
C         NEGATIVE U[ISO]
          WRITE (CLINE,41) ATOMNM, RNUISO
          CALL ZMORE(CLINE,0)
41        FORMAT ('Atom ',A,' has negative U[iso] - reset to ',F4.2)
          COORDS (6) = RNUISO
        ENDIF
        IUISO = 1
CNOV98
cnov98        EIGS(1) = COORDS(2)
cnov98        EIGS(2) = COORDS(2)
cnov98        EIGS(3) = COORDS(2)
        EIGS(1) = COORDS(6)
        EIGS(2) = COORDS(6)
        EIGS(3) = COORDS(6)
C----- ENTER A DUMMY UIJ
        DO 42 KK = 4,6
cnov98          RSTORE (K+KK) = COORDS(2)
          RSTORE (K+KK) = COORDS(6)
Cdjw - the cross terms must be calculated properly
          RSTORE (K+KK +3) = 0.0
42      CONTINUE
cdjw        GOTO 1000
      ENDIF
C ORTHOGONALISE THE TENSOR
      TENSOR(1,1) = RSTORE(K+4)
      TENSOR(2,2) = RSTORE(K+5)
      TENSOR(3,3) = RSTORE(K+6)
      TENSOR(2,3) = RSTORE(K+7)
      TENSOR(1,3) = RSTORE(K+8)
      TENSOR(1,2) = RSTORE(K+9)
      TENSOR(2,1) = TENSOR(1,2)
      TENSOR(3,1) = TENSOR(1,3)
      TENSOR(3,2) = TENSOR(2,3)

C      WRITE(99,'(A)') 'CAM: TENSOR, ORTHTENSOR, AXES, ELOR: '
C      WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)

      CALL ZMATR3 (ELOR,TENSOR,TENSOR)
      CALL ZMATR3 (TENSOR,ELORT,TENSOR)
C Now obtain the axes coordinates and eigenvalues

C      WRITE(99,'(9(1X,F7.4))') ((TENSOR(KI,KJ),KI=1,3),KJ=1,3)


      CALL ZANISO (TENSOR,AXES,EIGS,AXESC)
C Store the results

C      WRITE(99,'(9(1X,F7.4))') ((AXES(KI,KJ),KI=1,3),KJ=1,3)

C      WRITE(99,'(9(1X,F7.4))') ((ELOR(KI,KJ),KI=1,3),KJ=1,3)

      DO 90 L=1,3
        DO 90 J = 1,3
          RSTORE(K+IXYZO-1+L*3+J) = AXES(L,J)
90    CONTINUE
1000  CONTINUE
C FOR ISOTROPIC ONLY NEED TO STORE EIGS.
      DO 80 L = 1,3
        IF (EIGS(L).LE.0.00) THEN
          EIGS(L) = RNUISO
          WRITE (CLINE,81) ATOMNM , L , RNUISO
          CALL ZMORE(CLINE,0)
81        FORMAT ('Atom ',A6, ' axis no. ',I1
     C    ,' was negative - set to ',F4.2)
        ENDIF
        RSTORE(K+IXYZO+11+L) = EIGS(L)

CLJF FIX FOR INCORRECTLY STORED uISO
cnov98        IF (IUISO .EQ. 1) RSTORE(K+IXYZO+11+L) = COORDS(2)
        IF (IUISO .EQ. 1) RSTORE(K+IXYZO+11+L) = COORDS(6)
80    CONTINUE
      IF (IUISO.EQ.1) THEN
        RSTORE(K+IXYZO+12) = -RSTORE(K+IXYZO+12)
      ENDIF
      DO 100 L = 1,3
        DO 100 J = 1,3
          RSTORE(K+L*3+J) = AXESC(L,J)
100    CONTINUE
C STORE OCC, PACKFLAG
      RSTORE (K+13) = COORDS(1)
      RSTORE (K+IPCK+1) = 1.0
C WHAT ELEMENT IS IT?
C      CALL ZCASCH (ELM,ICELM,ICATOM-1,1,IPOS,IPPACK,INSTRT)
      RSTORE(K+IATTYP) = IELM - ICELM + 1
C MOVE OVER CONN RADIUS - COVALENT
      RSTORE(K+IATTYP+5) = RSTORE(NINT(IRELM +
     c(RSTORE(K+IATTYP)-1)*4.0))
      RSTORE (K+IATTYP+4) = RSTORE(K+IATTYP+5)/4.0
C MOVE OVER THE COLOUR INFORMATION
       RSTORE(K+IATTYP+1) =
     c RSTORE ( NINT( IRELM + (RSTORE(K+IATTYP)-1) *4.0)   + 3 )
C INITIALISE THE BOND DATA
       DO 60 IQ = K+IBOND,K+IPACKT
60     RSTORE(IQ) = 0.0
       CALL ZZEROF (RSTORE(K+IBOND),IPACKT-IBOND)
C CHECK FOR SPECIAL POSITIONS
        RSTORE(K+ISYM) = LSPECH(K)
      K = K + IPACKT
20    CONTINUE
      ICLAST = ICATOM + NATOM
      IRLAST = IRATOM + (NATOM*IPACKT)
      CALL ZCENTR(MAX,MIN)
C MODIFY IRATOM AND ICATOM TO ALLOW FOR UNIT CELL VERTICES
      IRATOM = IRATOM - IPACKT*8
      ICATOM = ICATOM - 8
      ISVIEW = IRATOM
      IFVIEW = IRLAST
      ISINIT = ISVIEW
      IFINIT = IFVIEW
      CALL ZCOLKY
      WRITE (CLINE,11) NATOM
      CALL ZMORE(CLINE,0)
      IF (.NOT.LFILES (0,FILENM,IINPT))
     + CALL ZMORE('Error on closing input file.',0)
      IF (.NOT.LFILES (0, ' ' , ISCRAT))
     + CALL ZMORE('Error on closing symmetry scratch file.',0)
      RETURN
9999  CONTINUE
C ERROR IN FILE FORMAT
      WRITE (CLINE,9991) FILENM
      CALL ZMORE(CLINE,0)
9991  FORMAT ('Error in format of file ',A30,' not LIST5 format!')
      IF (.NOT.LFILES (0,FILENM,IINPT))
     + CALL ZMORE('Error on closing input file.',0)
      IF (.NOT.LFILES (0, ' ' , ISCRAT))
     + CALL ZMORE('Error on closing symmetry scratch file.',0)
      RETURN
      END
 
CODE FOR ZSUBCH [ SUB COMMAND SEARCH AND CHECK ]
C This validates a sub command.
      SUBROUTINE ZSUBCH (IERR)
C VARIABLES : IERR this is the error flag. It returns -
C             0 - sub command found (and stored)
C             1 - sub command not valid
C NOTE : IF IC/IR/IN AREN'T ZERO THEN ICTYPE = 4
      
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

                IERR = 0
C FOUND A SUB COMMAND - IS IT VALID?
          IF ((IN.NE.0).OR.(IR.NE.0).OR.(IC.NE.0)) ICTYPE(1,1) = 4
          IF (ICTYPE(1,1).EQ.-4) THEN
C WE NEED A SPECIFIC SUB COMMAND
                    IF (ABS(IPREV(2)).EQ.INCOM(1)) THEN
C COMMAND IS OK!
                     ELSE
C COMMAND INVALID!
                    IERR = 1
                      RETURN
                    ENDIF
                  ENDIF
                  IF (ICTYPE(1,1).EQ.4) THEN
C SUB COMMAND POSSIBLE - CHECK PREV OF SUB COMMAND ITSELF
                    IF (IPREV(2).LE.1) THEN
C OK - NO SPECIFIC PREVIOUS COMMAND NEEDED
                      ELSE
C THE SUB COMMAND REQUIRES A SPECIFIC PREVIOUS COMMAND
                      IF (IPREV(2).NE.INCOM(1)) THEN
                        IERR = 1
                        RETURN
                      ENDIF
                    ENDIF
                  ENDIF
                END
 
CODE FOR ZWORD
      SUBROUTINE ZWORD(IERR)
C This subroutine will analyse the input line into 'words' that are delimited
C by spaces,commas.
C
C VARIABLES :  LINE(ILINE) -character*80 - this contains the current input line
C              IBEG,IEND - these are the beginning and end of the word.
C              IWORD - this is used to specify the beginning of a new word.
C              DELIM(3) - these are the allowed delimeters
C              IEND = -1 - no end of word found
C              IWORD = 141 - no beginning of next word found
C              IERR = 1 blank line
C              IERR = 2 ? found
C              IERR = 3 no next word found
C              ICABAN is used for the log file to show the
C              beginning of the next word in CLOG
      
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

      CHARACTER*1 DELIM(3)
      DATA DELIM(1)/' '/DELIM(2)/','/,DELIM(3)/'?'/
      IERR = 0
      IBEG = -1
      DO 5 I = IEND+1,ICLEN
        IF ((LINE(ILINE)(I:I).NE.DELIM(1)).AND.(IBEG.EQ.-1)) IBEG = I
5     CONTINUE
      IF (IBEG.EQ.-1) THEN
        IF (IEND.EQ.0) THEN
C BLANK LINE
           WRITE (ISCRLG , '(A)') ' '
           IERR = 1
        ELSE
           IERR = 3
        ENDIF
        RETURN
      ENDIF
C HAVE GOT NEXT WORD - FIND END OF IT
      IEND = -1
      DO 10 I = IBEG,ICLEN
        IF (((LINE(ILINE)(I:I).EQ.DELIM(1)).OR.(LINE(ILINE)(I:I).EQ.
     c DELIM(2))).AND.(IEND.EQ.-1)) THEN
          IEND = I-1
        ENDIF
10    CONTINUE
      IF (IEND.EQ.-1) IEND = ICLEN
C SEARCH FOR ?
      IF (LINE(ILINE)(IBEG:IBEG).EQ.DELIM(3)) THEN
        IERR = 2
        RETURN
      ENDIF
C WRITE WORD INTO THE SCRATCH FILE
      IF (IFOBEY.EQ.-1) WRITE (ISCRLG,'(A)') LINE(ILINE)(IBEG:IEND)
C      ICABAN = ICABAN + IEND - IBEG + 2
      RETURN
      END
 
CODE FOR ZPARAM
      SUBROUTINE ZPARAM (M,IPOSN,VAL,ITYPE,IMULT)
      
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

C This routine alters the parameter in position IPOSN to its new value
C VAL.
C ITYPE = 1 RSTORE(I+IPOSN) = VAL
C       = 2                 = -VAL
C       = 3 atom I becomes member of group VAL
C       = 4 atom I is deleted from group VAL
C       = 5 set connectivity and drawing radii
C CHECK FOR M = 0 (THIS IS AN ARGUMENT OF TYPE *_2)
      IF (M.EQ.0) THEN
C LOOP OVER ALL THE ATOMS IN THE ARRAY
        DO 10 I = ISVIEW + IPACKT * 8 , IFVIEW-1 , IPACKT
          IF (NINT(RSTORE(I+IPCK)).NE.IMULT-1) GOTO 10
          IF (ITYPE.EQ.1) THEN
            RSTORE(I+IPOSN) = VAL
          ELSE IF (ITYPE.EQ.2) THEN
            RSTORE(I+IPOSN) = -ABS ( RSTORE ( I+IPOSN ))
          ELSE IF (ITYPE.EQ.5) THEN
            RSTORE(I+IPOSN) =
     +      RSTORE(NINT(IRELM+(RSTORE(I+IATTYP)-1)*4.0+VAL))
            IF (IPOSN.EQ.IATTYP+4) THEN
              RSTORE(I+IPOSN) = RSTORE(I+IPOSN)*0.25
            ENDIF
            IF (RSTORE(I+IPOSN).LT.0) THEN
              IF (IPOSN.EQ.IATTYP+4) THEN
                RSTORE(I+IPOSN) = 0.025
              ELSE
                RSTORE(I+IPOSN) = 0.0
              ENDIF
            ENDIF
          ELSE
C GROUP
            CALL ZPGRP (I,NINT(VAL),ITYPE)
          ENDIF
10      CONTINUE
        RETURN
      ENDIF
      IF (M.EQ.-1) THEN
        DO 11 J = ISVIEW+IPACKT*8 , IFVIEW-1, IPACKT
          IF (ITYPE.EQ.1) THEN
            RSTORE(J+IPOSN) = VAL
          ELSE IF (ITYPE.EQ.2) THEN
            RSTORE(J+IPOSN) = -ABS(RSTORE(J+IPOSN))
          ELSE IF (ITYPE.EQ.5) THEN
            RSTORE(J+IPOSN) =
     +      RSTORE(NINT(IRELM+(RSTORE(J+IATTYP)-1)*4.0+VAL))
            IF (IPOSN.EQ.IATTYP+4) THEN
              RSTORE(J+IPOSN) = RSTORE(J+IPOSN)*0.25
            ENDIF
            IF (RSTORE(J+IPOSN).LT.0) THEN
              IF (IPOSN.EQ.IATTYP+4) THEN
                RSTORE(J+IPOSN) = 0.025
              ELSE
                RSTORE(J+IPOSN) = 0.0
              ENDIF
            ENDIF
          ELSE
            CALL ZPGRP(J,NINT(VAL),ITYPE)
          ENDIF
11      CONTINUE
      ELSE IF (M.LT.ICATOM) THEN
C WE HAVE AN ELEMENT - NEED TO LOOP OVER ALL THESE ATOMS IN THE ARRAY
        N = M - ICELM + 1
        DO 20 J = ISVIEW + IPACKT * 8 ,IFVIEW-1,IPACKT
          IF (NINT(RSTORE(J+IATTYP)).EQ.N) THEN
C YES THIS ELEMENT AGREES
C DO NOT ALTER DUMMY ATOMS AND CELL COORDS
            IF ((IPOSN.EQ.0).AND.(NINT(RSTORE(J)).GT.3.5)) GOTO 20
C CHECK THE PACK NUMBER IF REQUIRED
            IF (IMULT.NE.0) THEN
              IF (NINT(RSTORE(J+IPCK)).NE.IMULT-1) GOTO 20
            ENDIF
            IF (ITYPE.EQ.1) THEN
              RSTORE(J+IPOSN) = VAL
            ELSE IF (ITYPE.EQ.2) THEN
              RSTORE(J+IPOSN) = -ABS(RSTORE(J+IPOSN))
            ELSE IF (ITYPE.EQ.5) THEN
              RSTORE(J+IPOSN) =
     +        RSTORE(NINT(IRELM+(RSTORE(J+IATTYP)-1)*4.0+VAL))
              IF (IPOSN.EQ.IATTYP+4) THEN
                RSTORE(J+IPOSN) = RSTORE(J+IPOSN)*0.25
              ENDIF
              IF (RSTORE(J+IPOSN).LT.0) THEN
                IF (IPOSN.EQ.IATTYP+4) THEN
                  RSTORE(J+IPOSN) = 0.025
                ELSE
                  RSTORE(J+IPOSN) = 0.0
                ENDIF
              ENDIF
            ELSE
              CALL ZPGRP(J,NINT(VAL),ITYPE)
            ENDIF
          ENDIF
20      CONTINUE
      ELSE
C CHECK FOR MULTIPLE ATOMS DUE TO PACKING
        IF (IMULT.EQ.0) THEN
          N = ( M - ICATOM )*IPACKT + ISINIT
          IF (ITYPE.EQ.1) THEN
            IF ((IPOSN.EQ.0).AND.(NINT(RSTORE(N)).GT.3.5)) RETURN
            RSTORE(N+IPOSN) = VAL
          ELSE IF (ITYPE.EQ.2) THEN
            RSTORE(N+IPOSN) = - ABS (RSTORE(N+IPOSN))
          ELSE IF (ITYPE.EQ.5) THEN
            RSTORE(N+IPOSN) =
     +      RSTORE(NINT(IRELM+(RSTORE(N+IATTYP)-1)*4.0+VAL))
            IF (IPOSN.EQ.IATTYP+4) THEN
              RSTORE(N+IPOSN) = RSTORE(N+IPOSN)*0.25
            ENDIF
            IF (RSTORE(N+IPOSN).LT.0) THEN
              IF (IPOSN.EQ.IATTYP+4) THEN
                RSTORE(N+IPOSN) = 0.025
              ELSE
                RSTORE(N+IPOSN) = 0.0
              ENDIF
            ENDIF
          ELSE
            CALL ZPGRP(N,NINT(VAL),ITYPE)
          ENDIF
        ELSE
C NEED TO LOOP AND FIND ALL OF THE ATOMS
          DO 40 I = 0 , IPACK
            CALL ZGTATM ( M , I , IPOS )
            IF (IPOS.EQ.-1) GOTO 40
            IF (ITYPE.EQ.1) THEN
              RSTORE(IPOS+IPOSN) = VAL
            ELSE IF (ITYPE.EQ.2) THEN
              RSTORE (IPOS + IPOSN) = -ABS ( RSTORE(IPOS + IPOSN ))
            ELSE IF (ITYPE.EQ.5) THEN
            RSTORE(IPOS+IPOSN) =
     +      RSTORE(NINT(IRELM+(RSTORE(IPOS+IATTYP)-1)*4.0+VAL))
            IF (IPOSN.EQ.IATTYP+4) THEN
              RSTORE(IPOS+IPOSN) = RSTORE(IPOS+IPOSN)*0.25
            ENDIF
            IF (RSTORE(IPOS+IPOSN).LT.0) THEN
              IF (IPOSN.EQ.IATTYP+4) THEN
                RSTORE(IPOS+IPOSN) = 0.025
              ELSE
                RSTORE(IPOS+IPOSN) = 0.0
              ENDIF
            ENDIF
            ELSE
              CALL ZPGRP(IPOS,NINT(VAL),ITYPE)
            ENDIF
40        CONTINUE
        ENDIF
      ENDIF
      RETURN
      END
 
CODE FOR ZPGRP
      SUBROUTINE ZPGRP (I,IGP,ITYPE)
      INTEGER I,IGP,ITYPE
      
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

C THIS ALTERS THE GROUP INFORMATION FOR THE ATOM I
      IF (ITYPE.EQ.3) THEN
C ADD GROUP INFORMATION
        DO 10 J = I+IATTYP+6 , I+IATTYP+8
          IF (NINT(RSTORE(J)).NE.0) GOTO 10
          IF (NINT(RSTORE(J)).EQ.IGP) RETURN
          RSTORE(J) = IGP
          RETURN
10      CONTINUE
      ELSE
C DELETE GROUP INFORMATION FROM THIS ATOM
        DO 20 J = I+IATTYP+6 , I+IATTYP+8
          IF (NINT(RSTORE(J)).EQ.IGP) THEN
            RSTORE(J) = 0.0
            RETURN
          ENDIF
20      CONTINUE
      ENDIF
      RETURN
      END
 
CODE FOR ZOUTL5
      SUBROUTINE ZOUTL5
C This routine outputs the data stored in CRYSTALS list 5 format.
C only those atoms included in the current view will be output.
      
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

      DIMENSION LSTORE(ITOT)
      EQUIVALENCE (RSTORE(1),LSTORE(1))

      CHARACTER*60 FILENM
      CHARACTER*80 CDUMP
      CHARACTER*6 CELM
      CHARACTER*80 CFORT
      REAL ELORI (3,3), ELORTI (3,3)
      LOGICAL LOPEN,LEXIST
      LOGICAL LFILES
      REAL ORTH(3,3),ELOR(3,3),ELORT(3,3)
      REAL T1(3,3),DIAG(3,3),T2(3,3)
      CALL ZMOVE (RSTORE(ICRYST+6),ORTH,9)
      CALL ZMOVE (RSTORE(ICRYST+24),ELOR,9)
      CALL ZMOVE (RSTORE(ICRYST+33),ELORT,9)
C GET THE INVERSE MATRICES FOR TEMPERATURE FACTOR CONVERSION
      CALL ZINVER (ELOR,ELORI)
      CALL ZINVER (ELORT,ELORTI)
C FIRST GET THE FILENAME
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT ( FILENM , 60 , NPOS)
C CHECK TO SEE IF THE FILE IS ALREADY OPEN
      INQUIRE (FILE=FILENM,OPENED=LOPEN)
      IF (LOPEN) THEN
C WARN THE USER
        WRITE (CLINE,1) FILENM
        CALL ZMORE(CLINE,0)
1       FORMAT ('The file ',A12,' is already being used for something el
     cse! Cannot output to this file.')
        CALL ZMORE('All commands not executed have been lost',0)
        IPROC = 0
        RETURN
      ENDIF
C OTHERWISE OPEN IT
      INQUIRE (FILE=FILENM,EXIST=LEXIST)
      IF (.NOT.LEXIST) THEN
C INQUIRE ABOUT THE TRUE FILENAME
        CALL ZFORTF (FILENM,CFORT,IERR)
        IF (IERR.EQ.1) THEN
          IPROC = 0
          RETURN
        ENDIF
        CALL ZMORE('File created as: ',0)
        CALL ZMORE (CFORT,0)
      ELSE
        CFORT = FILENM
      ENDIF
      IF (.NOT.LFILES (2,CFORT,IFSTAR-1)) THEN
        CALL ZMORE('Error on opening file for output.',0)
        CALL ZMORE(CFORT,0)
        IPROC = 0
        RETURN
      ENDIF
C WRITE OUT THE HEADER LINES
      WRITE (IFSTAR-1,'(A)') '#'
      WRITE (IFSTAR-1,'(A)') '# Written out from CAMERON'
      WRITE (IFSTAR-1,'(A)') '#'
      WRITE (IFSTAR-1,'(A)') '#LIST 5'
C NEED TO GET THE NUMBER OF ATOMS TO BE OUTPUT
      IATOMS = 0
      DO 10 I = ISVIEW + IPACKT*8 , IFVIEW-1 , IPACKT
        IF (NINT(RSTORE(I+IPCK+1)).GT.0) IATOMS = IATOMS + 1
10    CONTINUE
C GET THE HEADER INFORMATION FROM THE PREVIOUS FILE (IF ANY)
      IF (ICLST5.GT.-1) THEN
        ICLIST = ICATOM - (ICLST5+2)*14
        DO 20 I = 0 , 12
          CDUMP (I*6+1:I*6+7) = CSTORE(ICLIST+I)
20      CONTINUE
        WRITE (IFSTAR-1,30) IATOMS,CDUMP(1:50)
30      FORMAT ('READ NATOM =',I7,A50)
        ICLIST = ICLIST + 14
        DO 40 I = 0 , 12
          CDUMP (I*6+1:I*6+7) = CSTORE(ICLIST+I)
40      CONTINUE
        CDUMP (79:80) = CSTORE(ICLIST+13)(1:2)
        WRITE (IFSTAR-1,'(A)') CDUMP
      ELSE
        WRITE (IFSTAR-1,31) IATOMS
31      FORMAT ('READ NATOM =',I7)
      ENDIF
C NOW LOOP OVER THE ATOMS
      DO 50 I = ISVIEW+IPACKT*8 , IFVIEW-1 , IPACKT
        IF (NINT(RSTORE(I+IPCK+1)).LT.1) GOTO 50
C       DO NOT OUTPUT EXCLUDED ATOMS
C       WORK OUT THE ATOM NUMBER
C       GET THE ELEMENT TYPE NUMBER AND HOW LONG THE ELEMENT NAME IS
        IELTYP = NINT(RSTORE(I+IATTYP)) + ICELM - 1
        CELM = CSTORE(IELTYP)
        IELLN = INDEX (CELM,' ')
        KK = (I - IRATOM ) /IPACKT + ICATOM
C       NOW FIND OUT THE VALUE OF CELM
        II = YCCREA (CSTORE(KK)(IELLN:6),RATNO)
C WRITE OUT THE LINE
        IF (RSTORE(I+IXYZO+12).LT.0.0) THEN
C ISOTROPIC ATOM
          FLAG = 1.
          CALL ZZEROF (T1, 9)
          T1(1,1) = -RSTORE(I+IXYZO+12)
        ELSE
C ANISO ATOM
          FLAG = 0.
C         NEED TO GET THE INITIAL ANISO TENSOR
        DO 60 J = 1 , 3
          DO 60 K = 1 , 3
            T1(K,J) = RSTORE (I + K*3 + J )
60      CONTINUE
C       ORTHOGONALISE THIS
        CALL ZMATR3 (ORTH,T1,T1)
        DO 70 J = 1 , 3
          DO 70 K = 1 , 3
            T2(K,J) = T1(J,K) / ABS ( SQRT ( RSTORE ( I + IXYZO + 11 + K
     c      )))
70      CONTINUE
C       TRANSPOSE T2 TO GET NEW T1
        DO 74 J = 1 , 3
          DO 74 K = 1 ,3
            T1(J,K) = T2(K,J)
74      CONTINUE
C       MAKE UP THE DIAGONAL MATRIX
        CALL ZZEROF (DIAG,9)
        DO 80 J = 1 , 3
          DIAG(J,J) = RSTORE ( I + IXYZO + 11 + J )
80      CONTINUE
C       NOW MAKE THE TENSOR
        CALL ZMATR3 ( DIAG , T2 , T2 )
        CALL ZMATR3 ( T1, T2 , T1)
C       AND DEORTHOGONALISE IT
        CALL ZMATR3 ( ELORI , T1, T1)
        CALL ZMATR3 ( T1 , ELORTI , T1 )
      ENDIF
C     OUTPUT TWO ATOM LINES
CNOV2000 OUTPUT 3 LINES
      WRITE (IFSTAR-1,110) CELM , RATNO , RSTORE(I+13) , FLAG ,
     1 RSTORE(I+1), RSTORE(I+2), RSTORE(I+3)
110   FORMAT ( 'ATOM ',A2,3X,F11.0,5F11.6)
      WRITE (IFSTAR-1,90) T1(1,1), T1(2,2) , T1(3,3) , T1 (2,3)
     1 , T1(1,3), T1(1,2)
90    FORMAT ('CON U[11]=',6F11.6)
      WRITE(IFSTAR-1,95) RSTORE(I+14),(LSTORE(I+J),J=15,18)
95    FORMAT ('CON SPARE=',F11.2,3I11,7X,A4)
50    CONTINUE
C NOW LOOP OVER THE FINAL LINES OF THE FILE (IF ANY HAVE BEEN PREVIOUSLY
C STORED.
      DO 120 K = ICLST5 , 1 , -1
        ICLIST = ICATOM - K*14
        DO 130 I = 0 , 12
          CDUMP (I*6+1:I*6+7) = CSTORE(ICLIST+I)
130      CONTINUE
      WRITE (IFSTAR-1,'(A80)') CDUMP
120   CONTINUE
      WRITE (IFSTAR-1,'(A)') 'END'
C IF ICLST5 = -1 THEN WE DID NOT INPUT A LIST5 SO WE HAVE TO OUTPUT
C A LIST1 HERE FOR CRYSTALS ENTRY
      IF (ICLST5.EQ.-1) THEN
        WRITE (IFSTAR-1,'(A)') '#LIST 1'
        WRITE (IFSTAR-1 ,140) ( RSTORE (ICRYST+J), J=0,5 )
140     FORMAT ('REAL ',6(F10.4,2X))
        WRITE (IFSTAR-1,'(A)') 'END'
      ENDIF
      WRITE (IFSTAR-1,'(A)') '#USE LAST'
      IF (.NOT.LFILES (0,' ',IFSTAR-1))
     +CALL ZMORE('Error on closing input file.',0)
      RETURN
      END
C 
CODE FOR ZOUTCS
      SUBROUTINE ZOUTCS (IORTH)
C This routine outputs the current data in CSSR format.
CDJWFEB2000 or CHIME .pdb format
C IORTH = 1 ORTHOGONAL
C IORTH = 0 FRACTIONAL
C IORTH = -1 .pdb FORMAT      
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
      CHARACTER *10 CNUM
      PARAMETER (CNUM='0123456789')
      REAL ORTH(3,3),X(3)
      INTEGER BONDS(8)
      CHARACTER * 60 FILENM
      CHARACTER*6 CLAB
      LOGICAL LEXIST,LFILES
      CHARACTER*80 CFORT
      CALL ZMOVE ( RSTORE(ICRYST+6) , ORTH, 9)
      NPOS = ICCMMD(ICCNT)
      IF (IORTH .GE. 0) THEN
       CALL ZGTTXT ( FILENM , 60 , NPOS )
      ELSE
       FILENM = 'CHIME.pdb'
      ENDIF
      INQUIRE (FILE=FILENM,EXIST=LEXIST)
      IF (.NOT.LEXIST) THEN
        CALL ZFORTF (FILENM,CFORT,IERR)
        IF (IERR.EQ.1) THEN
          IPROC = 0
          RETURN
        ENDIF
        WRITE(CLINE,'(A,A)') 'File created as:', CFORT
        CALL ZMORE (CLINE,0)
      ELSE
        CFORT = FILENM
        WRITE(CLINE,'(A,A)') 'Writing to existing file:', CFORT
        CALL ZMORE (CLINE,0)
      ENDIF
      IF (.NOT.LFILES (2,CFORT,IFSTAR-1)) THEN
        WRITE(CLINE,'(A,A)') 'Error on opening file:', CFORT
        CALL ZMORE (CLINE,0)
        IPROC = 0
        RETURN
      ENDIF
      IF (IORTH .GE. 0) THEN
C OUTPUT THE UNIT CELL INFORMATION
       WRITE (IFSTAR-1 , 100) RSTORE(ICRYST), RSTORE(ICRYST+1),
     c RSTORE(ICRYST+2)
       WRITE (IFSTAR-1 , 101) RSTORE(ICRYST+3), RSTORE(ICRYST+4),
     c RSTORE(ICRYST+5)
100    FORMAT (38X,3F8.3)
101    FORMAT (21X,3F8.3)
      else
CDJWJUL2000
       write(ifstar-1,9100) (rstore(icryst+i),i=0,5)
9100  format('CRYST1',3F9.3,3F7.2)
      ENDIF
C NOW WE NEED TO FIND OUT THE NUMBER OF THE ATOMS AND GENERATE AN
C ATOM LIST.
      INATOM = 0
      DO 10 I = ISVIEW + IPACKT*8 , IFVIEW-1 , IPACKT
      IF (RSTORE(I+IPCK+1).GT.0.0) THEN
C ATOM IS INCLUDED ADD INTO LIST
        RSTORE(IRLAST+INATOM) = I
        INATOM = INATOM + 1
      ENDIF
10    CONTINUE
C NOW OUTPUT THE LINE CONTAINING THE NUMBER OF ATOMS
      IF (IORTH .GE. 0) THEN
       WRITE (IFSTAR-1, 102) INATOM, IORTH
102    FORMAT (I4,3X,I1,/)
      ELSE
C       WRITE (IFSTAR-1, 102) INATOM
C       WRITE (IFSTAR-1, '(A)') '  Chime file created by CAMERON '
      ENDIF
C NOW WORK THROUGH THE LIST OF ATOMS
      IATOUT = 0
      DO 20 I = IRLAST , IRLAST + INATOM - 1
C GET THE COORDS IN THE CORRECT FORM
        DO 24 J = 1 , 3
          X(J) = RSTORE(NINT(RSTORE(I))+J)
24      CONTINUE
        IF (IORTH.ne.0) THEN
          CALL ZMATV ( ORTH , X , X)
        ENDIF
C CHECK FOR SIZE OF X
        IF ((X(1).GE.1000.0).OR.(X(2).GE.1000.0).OR.(X(3).GE.1000.0))
     c    THEN
          CALL ZBEEP
          CALL ZMORE(
     c 'Coordinates are too large for output in this format - try FRACT'
     c ,0)
          IPROC = 0
          RETURN
        ENDIF
        CALL ZZEROI (BONDS,8)
        IBND = 0
        N = NINT(RSTORE(I))
C WORK OUT THE CONNECTIVITY
        IBNDST = NINT (RSTORE (N+IBOND) )
        NBONDS = NINT (RSTORE (N+IBOND+1) )
C YOU CANT HAVE MORE THAN 8 CONNECTIVITY NUMBERS IN A CSSR FILE.
        IF (NBONDS.GT.8) NBONDS = 8
        DO 30 J = IBNDST , IBNDST - (NBONDS-1)*2 , -2
C GET THE OTHER ATOMS NUMBER
          NN = NINT(RSTORE(J))
C IS THIS ATOM INCLUDED
          IF (RSTORE(NN+IPCK+1).GT.0.0) THEN
C LOOP OVER THE LIST TO FIND THIS ATOMS NUMBER
            DO 40 K = IRLAST , IRLAST + INATOM - 1
              IF (NINT(RSTORE(K)).EQ.NN) KK = K - IRLAST + 1
40          CONTINUE
            IBND = IBND + 1
            BONDS (IBND) = KK
          ENDIF
30      CONTINUE
C GET THE LABEL
        KK = (N - IRATOM ) / IPACKT + ICATOM
C----- RIGHT ADJUST NAME
        if (cstore(kk)(2:2) .eq. ' ') then
         CLAB = ' '//CSTORE(KK)(1:1)
        else
         CLAB = CSTORE(KK)(1:2)
        endif
        IF (IORTH .GE. 0) THEN
          WRITE (IFSTAR-1 , 104) I-IRLAST+1, CLAB ,
     c  X , BONDS
104     FORMAT (I4,A6,3F10.5,1X,8I4)
        ELSE
CJUL2000 .PDB OUTPUT
            IATOUT = IATOUT + 1
            DO 9104 ILL = 1,6
              IF (INDEX(CNUM, CSTORE(KK)(ILL:ILL)) .NE. 0) GOTO 9105
9104        CONTINUE
            ILL = 6
9105        CONTINUE
            IF (ILL .LT. 3) THEN
C-           RIGHT SHIFT LABEL
             CLAB(1:6) = ' '//CSTORE(KK)(1:5)
            ELSE
             CLAB(1:6) = CSTORE(KK)(1:6)
            ENDIF
            WRITE(IFSTAR-1,  105) IATOUT, CLAB, X
105         FORMAT('ATOM',I7,1X,A6,7X,'0',4X,3F8.3)
        ENDIF
20    CONTINUE
      IF (.NOT.LFILES (0, ' ',IFSTAR-1))
     + CALL ZMORE('Error on closing output file.',0)
      RETURN
      END
C 
CODE FOR ZXYZ [ READ IN LIST5 FILE ]
      SUBROUTINE ZXYZ
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

      LOGICAL LFILES
      CHARACTER*6 CLAB,ELM
      CHARACTER*60 FILENM
      CHARACTER*6 CELLAB(8)
      REAL COORDS(3),MIN(3),MAX(3)
      DATA CELLAB /'0    ','a    ','     ','c     ','b     ','      ',
     c '      ','      '/
C THIS ROUTINE READS IN INFO FROM AN XYZ FILE
C THE INFO STORED IN THIS FILE IS -
C ATOM LABEL, X, Y, Z
C ICATOMS is the start of the atom information
C ISATM is the step size in the database.
      DO 1 I = 1,3
      MIN(I) = 100.0
1     MAX(I) = -100.0
C GET THE FILENAME
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT ( FILENM , 60 , NPOS)
      IF (.NOT.LFILES (1,FILENM,IINPT)) THEN
        CALL ZMORE('Error on opening file.',0)
        CALL ZMORE(FILENM,0)
        IPROC = 0
        RETURN
      ENDIF
C READ IN THE BLANK LINE
      READ (IINPT,'(80X)')
C GET THE NEXT LINE
      IRATOM = IRLAST
      K = IRATOM
C NEED TO STORE CELL LABELS AGAIN
      ICATOM = ICLAST
      DO 13 I = ICATOM , ICATOM+7
        CSTORE(I) = CELLAB(I-ICATOM+1)
13    CONTINUE
      ICATOM = ICATOM + 8
      I = ICATOM
      K = IRATOM
      NATOM = 0
20    CONTINUE
C READ IN THE COORDS ETC.
      READ (IINPT,1000) CLAB , COORDS
1000  FORMAT (A6,3X,5F10.5)
      IF (CLAB.EQ.'      ') GOTO 9999
      CALL ZZEROF ( RSTORE(K), IPACKT )
      IF ((MOD ( I - ICATOM , 50 ).EQ.0).AND.(I-ICATOM.NE.0) ) THEN
        WRITE (CLINE,11) I-ICATOM
        CALL ZMORE(CLINE,0)
11    FORMAT (I5, ' atoms loaded .')
      ENDIF
      II = YCCREA (CLAB(2:2),VALUE)
      IF (II.EQ.1) THEN
        ELM = CLAB(1:1)//'     '
      ELSE
        ELM = CLAB(1:2)//'    '
      ENDIF
C WORK OUT THE LABEL
      CSTORE ( I ) = CLAB
C STORE THE REAL INFO
C MAKE ALL ATOMS 'LINE' INITIALLY
      RSTORE (K) = 1.0
      DO 70 KK = 1,3
      IF (MIN(KK).GT.COORDS(KK)) MIN(KK) = COORDS(KK)
      IF (MAX(KK).LT.COORDS(KK)) MAX(KK) = COORDS(KK)
      RSTORE (K+KK) = COORDS(KK)
70    CONTINUE
C STORE OCC, PACKFLAG
      RSTORE (K+IPCK-1) = 0.0
      RSTORE (K+IPCK+1) = 1.0
C WHAT ELEMENT IS IT?
      CALL ZCASCH (ELM,ICELM,ICATOM-1,1,IPOS,IPPACK,INSTRT)
      RSTORE(K+IATTYP) = IPOS - ICELM + 1
C MOVE OVER CONN RADIUS - COVALENT
      RSTORE(K+IATTYP+5) = RSTORE(NINT(IRELM +
     c(RSTORE(K+IATTYP)-1)*4.0))
      RSTORE (K+IATTYP+4) = RSTORE(K+IATTYP+5)/4.0
C MOVE OVER THE COLOUR - FOR NOW ICOL = ICELM/10 + 1
      RSTORE (K+IATTYP+1) = NINT(RSTORE(K+IATTYP)/10.0) + 1.0
      K = K + IPACKT
      I = I + 1
      NATOM = NATOM + 1
      GOTO 20
9999  CONTINUE
      ICLAST = ICATOM + NATOM
      IRLAST = IRATOM + (NATOM*IPACKT)
      CALL ZCENTR(MAX,MIN)
C MODIFY IRATOM AND ICATOM TO ALLOW FOR UNIT CELL VERTICES
      IRATOM = IRATOM - IPACKT*8
      ICATOM = ICATOM - 8
      ISVIEW = IRATOM
      IFVIEW = IRLAST
      ISINIT = ISVIEW
      IFINIT = IFVIEW
      CALL ZCOLKY
      WRITE (CLINE,11) NATOM
      CALL ZMORE(CLINE,0)
      IF(.NOT.LFILES (0,FILENM,IINPT))
     + CALL ZMORE('Error on closing input file.',0)
      RETURN
      END
 
CODE FOR ZGTATM
      SUBROUTINE ZGTATM (N, IPPACK, IPOS)
C This subroutine is used to analyse atom names in a pack situation.
C In such cases N1 refers to N1_n , N1_n+1 , N1_n+2 etc. where n is
C 0 or 1 depending on the situation.
C N is the position in CSTORE of the base atom.
C IPPACK is the pack number of the desired result
C IPOS is the position in RSTORE of the atom - set to -1 if not found.
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

      CHARACTER*6 CNAME
      CNAME = CSTORE(N)
C LOOP TO FIND THE FIRST ATOM IN THE LIST WITH THE REQUIRED PACK NUMBER
      IPOS = -1
      IS = 0
      DO 10 I = ISVIEW+IPACKT*8 , IFVIEW - 1 ,IPACKT
        IF (NINT(RSTORE(I+IPCK)).EQ.IPPACK) THEN
          IS = I
          GOTO 20
        ENDIF
10    CONTINUE
20    CONTINUE
      IF (IS.EQ.0) THEN
        RETURN
      ENDIF
C FIND THE LAST ATOM WITH THIS PACK NUMBER
      IF = IFVIEW-IPACKT
      DO 30 I = IS , IFVIEW - 1, IPACKT
        IF (NINT(RSTORE(I+IPCK)).NE.IPPACK) THEN
          IF = I
          GOTO 40
        ENDIF
30    CONTINUE
40    CONTINUE
C GET THE EQUIVALENT CHARACTER POSITION
      IS =  ( IS - IRATOM ) / IPACKT + ICATOM
      IF =  ( IF - IRATOM ) / IPACKT + ICATOM
C LOOP OVER THE ATOM LIST
      DO 50 I = IS , IF - 1
        IF (CSTORE(I).EQ.CNAME) THEN
C WE HAVE FOUND IT!
          IPOS = ( I - ICATOM ) * IPACKT + IRATOM
          GOTO 60
        ENDIF
50    CONTINUE
60    CONTINUE
      RETURN
      END
 
CODE FOR ZGTPCK
      SUBROUTINE ZGTPCK ( IPPACK , IS , IF )
C This routine find the start and end points of atoms in the RSTORE
C array which have the given pack numbers
      
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

      IS = -1
      IF = -1
      DO 10 I = ISVIEW + IPACKT*8 , IFVIEW - 1 , IPACKT
        IF (NINT(RSTORE(I+IPCK)).EQ.IPPACK) THEN
          IF (IS.EQ.-1) IS = I
          IF = I
        ELSE IF (IF.NE.-1) THEN
          GOTO 20
        ENDIF
10    CONTINUE
20    CONTINUE
      RETURN
      END
 
CODE FOR ZSTUP
      SUBROUTINE ZSTUP
C THIS ROUTINE OBEYS THE STARTUP FILE CAMERON.SRT
C THIS IS CALLED EVERY TIME A DATA FILE IS LOADED.
      LOGICAL LEXIST
      CHARACTER*60 FILENM
      
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

      INTEGER IFPATH
      LOGICAL LFILES
      IFPATH = 1
CNOV      INQUIRE (FILE='CAMERON.OBY',EXIST=LEXIST)
      FILENM = 'cameron.srt'
      CALL ZMORE ('1 OBY FILE IS '//FILENM, 0)
      CALL ZMORE1 ('1 OBY FILE IS '//FILENM, 0)
      INQUIRE (FILE=FILENM,EXIST=LEXIST)
      IF (.NOT.LEXIST) THEN
C INQUIRE FOR THE MAIN FILE
cnov98
        FILENM = 'cameron.srt'
        CALL ZMORE ('2 OBY FILE IS '//FILENM, 0)
        CALL ZMORE1 ('2 OBY FILE IS '//FILENM, 0)
        CALL ZFPATH (FILENM)
        CALL ZMORE ('3 OBY FILE IS '//FILENM, 0)
        CALL ZMORE1 ('3 OBY FILE IS '//FILENM, 0)
        INQUIRE (FILE=FILENM,EXIST=LEXIST)
        IFPATH = -1
      ENDIF
      IF (.NOT.LEXIST) RETURN
      IFST = IFOBEY
      IF (IFOBEY.EQ.-1) THEN
        IFOBEY = IFSTAR
      ELSE
        IFOBEY = IFOBEY + 1
      ENDIF
CNOV98      IF (.NOT.LFILES (IFPATH,'CAMERON.OBY',IFOBEY)) THEN
#ifdef CRY_FORTDIGITAL
      IF(.NOT.LFILES(IFPATH,'CAMERON.SRT',IFOBEY))THEN
#else
      IF(.NOT.LFILES(IFPATH,'cameron.srt',IFOBEY))THEN
#endif
        CALL ZMORE('CAMERON.SRT exists but cannot be opened.',0)
        RETURN
      ENDIF
10    CONTINUE
      CALL ZCONTR
      IF (IFOBEY.GT.IFST) GOTO 10
      RETURN
      END
 
CODE FOR ZELEM
      SUBROUTINE ZELEM (CELM , IPOS , ITYPE)
      
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

      CHARACTER*9 CELM
      CHARACTER*9 CNEW,COLD
      CHARACTER*9 CSAV, CSAV1
      CHARACTER*1 CNUM(10)
      INTEGER IPOS,ISAV
      DATA CNUM /'0','1','2','3','4','5','6','7','8','9'/
C ITYPE = 1 LIST5
C         2 CSSR,SHELXS
C THIS ROUTINE LOOKS AT THE LABEL TO TRY AND DETERMINE THE ELEMENT
C TYPE. IT ALSO CONVERTS THE LABEL INTO THE CORRECT FORM
C FIRST FIND THE ELEMENT PART OF THE LABEL
      ISAV = 0
      I = 0
      IF (ITYPE.EQ.1) THEN
        I = INDEX (CELM,' ')-1
      ELSE
C LOOP TO FIND THE LAST CHARACTER
        DO 40 J = 1 , 9
          KKK = 0
          DO 50 KK = 1 , 10
            IF (CNUM(KK).EQ.CELM(J:J)) I = J
50        CONTINUE
          IF (I.NE.0) GOTO 60
40      CONTINUE
60      CONTINUE
        I = I - 1
      ENDIF
      CNEW = CELM(1:I)
      COLD = CELM(1:I)
      II = I
C HAS THIS ELEMENT BEEN ENCOUNTERED BEFORE?
      IF (NSCRAT.GT.0) THEN
        ISAV = 0
        DO 10 J = 1, NSCRAT
          READ (ISCRAT,REC=J) CSAV,CSAV1
          IF (CSAV.EQ.CNEW) THEN
            CNEW = CSAV1
            ISAV = 1
            GOTO 100
          ENDIF
10      CONTINUE
      ENDIF
C IS THE ELEMENT RECOGNISED?
100   CONTINUE
      CALL ZCASCH (CNEW,ICELM,ICLAST-1,1,IPOS,IPPOS,INSTRT)
      IF (IPOS.EQ.-1) THEN
C THE ELEMENT HAS NOT BEEN FOUND - NEED TO TRUNCATE THE STRING
        IF (I.GT.1) THEN
          CNEW(I:I) = ' '
          I = I - 1
          GOTO 100
        ELSE
          CNEW(1:1) = 'Q'
        ENDIF
      ENDIF
C OUTPUT THE RESULT
      IF (ISAV.EQ.0) THEN
        NSCRAT = NSCRAT + 1
        WRITE (ISCRAT,REC=NSCRAT) COLD,CNEW
        IF (CNEW.NE.COLD) THEN
          WRITE (CLINE,111) COLD,CNEW
111       FORMAT ('Element ',A9,
     +    ' not recognised. Element has been set to ',A9)
          IF (NSCRAT.EQ.1) THEN
            CALL ZMORE(CLINE,1)
          ELSE
            CALL ZMORE(CLINE,2)
          ENDIF
        ENDIF
      ENDIF
C NOW BUILD THE LABEL
      IF (ITYPE.EQ.1) THEN
        DO 20 J = 9 , II , -1
          IF (CELM(J:J).EQ.' ') GOTO 30
20      CONTINUE
30      CONTINUE
        J = J + 1
        IL = INDEX (CNEW,' ') - 1
        CSAV = CNEW(1:IL)//CELM(J:9)
      ELSE
        IL = INDEX (CNEW,' ') - 1
        CSAV = CNEW(1:IL)//CELM(II+1:9)
      ENDIF
      CELM = CSAV
      RETURN
      END
 
CODE FOR ZFDAT
      SUBROUTINE ZFDAT
      
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

      CHARACTER*9 ATOMNM
      CHARACTER*60 FILENM
      CHARACTER*80 CDUMP
      CHARACTER*6 CELLAB(8)
      CHARACTER*9 STRUC,SNAME
      CHARACTER*1 ANS
      REAL A,B,C,ALP,BET,GAM
      INTEGER IA,IB,ICCC,IALP,IBET,IGAM
      INTEGER ICAT,IADAT,IW,NCARDS,NRFAC,NREM,NDIS,NOPR
      INTEGER NRAD,NAT,NSAT,NBND,NCON,ICCELL,INTF,IATFOR,ICENT
      INTEGER IERR,IRPA,ITD,IPD,INU,ICBL,IAS,IPOL,IYEAR
      INTEGER PRECA,PRECB,PRECC,PRECAL,PRECBE,PRECGA
      CHARACTER*8 CSGRP
      LOGICAL LFILES
      REAL MIN(3),MAX(3)
C      REAL RADS(16)
      LOGICAL LOPEN
      INTEGER ICONN(8,3)
      INTEGER ICORD(3)
      LOGICAL LSYMM
      DATA ICONN/2,1,2,1,1,2,3,4,5,3,4,3,6,5,6,5,4,6,7,8,8,7,8,7/
      DATA CELLAB /'0    ','a    ','     ','c     ','b     ','      ',
     c '      ','      '/
C This reads in the FDAT format file output from the Cambridge
C Crystallographic Database.
C GET THE FILENAME
      NPOS = ICCMMD(ICCNT)
      CALL ZGTTXT ( FILENM, 60,NPOS)
      IF (.NOT.LFILES(1,FILENM,IINPT)) THEN
        CALL ZMORE('Error on opening file.',0)
        CALL ZMORE(FILENM,0)
        IPROC = 0
        RETURN
      ENDIF
C Now we need to search the file for the structure names.
C Open a scratch file to store the names
C CREATE THE SCRATCH FILE FOR THE ELEMENT NAMES
      INQUIRE (UNIT=ISCRAT,OPENED=LOPEN)
      IF (LOPEN) THEN
        IF (.NOT.LFILES(0,' ',ISCRAT))
     +CALL ZMORE('Error on closing scratch file.',0)
      ENDIF
      IF (.NOT.LFILES (8,' ',ISCRAT)) THEN
        CALL ZMORE('Error on opening scratch file.',0)
        IPROC = 0
        RETURN
      ENDIF
      INSTRU = 0
10    CONTINUE
      READ (IINPT,'(A9)',END=20) STRUC
      IF (STRUC(1:1).EQ.'#') THEN
C FOUND A NAME
         INSTRU = INSTRU + 1
         WRITE (CLINE,11) STRUC(2:9)
11       FORMAT ('Structure name: ',A8)
         WRITE (ISCRAT,REC=INSTRU) STRUC(2:9)
      ENDIF
      GOTO 10
20    CONTINUE
      IF (INSTRU.EQ.0) THEN
        CALL ZMORE('Error - no structure names found.',0)
        IPROC = 0
      ENDIF
      IF (INSTRU.EQ.1) THEN
        READ (ISCRAT,REC=1) STRUC
        WRITE (CLINE,12) STRUC
12      FORMAT ('Loading information on ',A)
        CALL ZMORE(CLINE,0)
        INUM = 1
      ELSE
30      CONTINUE
        CALL ZMORE('Input your chosen structure.',0)
        READ (ISTIN,'(A)') SNAME
        INUM = -1
        DO 40 I = 1 , INSTRU
          READ (ISCRAT,REC=INSTRU) STRUC
          IF (STRUC.EQ.SNAME) THEN
            INUM = I
            GOTO 50
          ENDIF
40      CONTINUE
50      CONTINUE
        IF (INUM.EQ.-1) THEN
          CALL ZMORE('Error - structure not found.',0)
          CALL ZMORE('Do you want to cancel this input? (y/n) ',0)
          CALL ZGTANS(ANS,0)
          IF (ANS.EQ.'Y' .OR. ANS .EQ.'y') THEN
            IPROC = 0
            IF (LOPEN) THEN
              IF (.NOT.LFILES(0,' ',ISCRAT))
     +          CALL ZMORE('Error on closing scratch file.',0)
              ENDIF
            RETURN
          ENDIF
          GOTO 30
        ENDIF
      ENDIF
C NOW FIND THE CORRECT POSITION IN THE FILE
      REWIND(IINPT)
60    CONTINUE
      READ (IINPT,'(A80)') CDUMP
      IF (CDUMP(1:1).EQ.'#') THEN
        IF (CDUMP(2:9).EQ.SNAME) THEN
C FOUND THE INFORMATION
          GOTO 70
        ENDIF
      ENDIF
      GOTO 60
70    CONTINUE
C SET UP THE SCRATCH FILES
      INQUIRE (UNIT=ISCRAT,OPENED=LOPEN)
      IF (LOPEN) THEN
        IF (.NOT.LFILES(0,' ',ISCRAT))
     +CALL ZMORE('Error on closing scratch file.',0)
      ENDIF
      IF (.NOT.LFILES (8,' ',ISCRAT)) THEN
        CALL ZMORE('Error on opening scratch file.',0)
        IPROC = 0
        RETURN
      ENDIF
C NOW DECODE IT
      READ (CDUMP,13) ICAT,IADAT,IW,NCARDS,NRFAC,NREM,NDIS,NERRR,NOPR,
     +NRAD,NAT,NSAT,NBND,NCON,ICCELL,INTF,IATFOR,ICENT,IERR,IRPA,
     +ITD,IPD,INU,ICBL,IAS,IPOL,IYEAR
13    FORMAT (9X,2I1,I6,6X,11I3,12I1,10X,I2)
      DO 80 I = 1,3
        MIN(I) = 1000000.0
        MAX(I) = -1000000.0
80    CONTINUE
C CHECK THERE IS ENOUGH ROOM FOR THE ATOMS TO BE LOADED
      NROOM = NAT * IPACKT
      IRM = LROOM ( IRLAST , IREND , NROOM)
      IF (IRM.EQ.-1) THEN
        IPROC = 0
        CALL ZMORE('Not enough room to read in all the atoms',0)
        RETURN
      ENDIF
      ICATOM = ICLAST
      IRATOM = IRLAST
      K = IRATOM
      IREND = ISYMED
      ICONBG = IREND
C NOW READ IN THE CELL INFORMATION
      IF (ICELL.EQ.0) THEN
        CALL ZMORE('Error - cell information not stored in the file.',0)
        IPROC = 0
        RETURN
      ENDIF
      READ (IINPT,14) IA,IB,ICCC,IALP,IBET,IGAM,PRECA,PRECB,PRECC,
     +PRECAL,PRECBE,PRECGA,CSGRP
14    FORMAT (6I6,6I1,21X,A8)
C ALLOW FOR THE PRECISION FOR THE CELL PARAMETERS
      A = IA * (10.0 ** (-1.0 * PRECA ) )
      B = IB * (10.0 ** (-1.0 * PRECB ) )
      C = ICCC * (10.0 ** (-1.0 * PRECC ) )
      ALP = IALP * (10.0 ** (-1.0 * PRECAL ) )
      BET = IBET * (10.0 ** (-1.0 * PRECBE ) )
      GAM = IGAM * (10.0 ** (-1.0 * PRECGA ) )
      CALL ZCRYST (A,B,C,ALP,BET,GAM)
      CALL ZVIMAT
      IBPOS = IREND
      DO 90 I = 1,8
        DO 100 J = 1,3
          RSTORE (IBPOS-J*2+2) = (ISINIT+((ICONN(I,J)-1)*IPACKT))
          RSTORE (IBPOS-J*2+1) = ICELLC*10
100     CONTINUE
        RSTORE (ISINIT+(I-1)*IPACKT+IBOND) = IBPOS
        RSTORE (ISINIT+(I-1)*IPACKT+IBOND+1) = 3.0
        IBPOS = IBPOS - 6
        CSTORE(ICATOM+I-1) = CELLAB(I)
90    CONTINUE
      IREND = IBPOS
C IGNORE THE NEXT LINE
      READ (IINPT,'(A80)') CDUMP
      READ (IINPT,'(A80)') CDUMP
C NOW LOAD IN THE ATOM INFORMATION
      NPOS = 1
      LSYMM = .FALSE.
      DO 110 I = ICATOM + 8 , ICATOM + 8 + NAT + NSAT - 1
        IF (I.GE.ICATOM+8+NAT) LSYMM = .TRUE.
        N = (I-ICATOM)*IPACKT + IRATOM
        IF (NPOS.EQ.1) THEN
          READ (IINPT,'(A80)') CDUMP
        ENDIF
        IF (LSYMM) GOTO 140
C READ THE COORDINATE INFORMATION
        READ (CDUMP(NPOS:NPOS+25),15) ATOMNM,ICORD
15      FORMAT (A5,3I7)
C GET THE ELEMENT NUMBER
        CALL ZELEM (ATOMNM,IELM,1)
        CSTORE(I) = ATOMNM
C MAKE THE ATOMS LINE INITIALLY
        RSTORE(N) = 1.0
C STORE THE COORDINATES
        DO 120 J = 1 , 3
          RSTORE(N+J) = ICORD(J)*0.00001
          IF (ICORD(J).LT.MIN(J)) MIN(J) = ICORD(J)
          IF (ICORD(J).GT.MAX(J)) MAX(J) = ICORD(J)
120     CONTINUE
        RSTORE(N+IPCK+1) = 1.0
C SET THE EIGENVALUES FOR AN ISOTROPIC ATOM
        DO 130 J = 1 , 3
          RSTORE(N+IXYZO+9+J) = RNUISO
130     CONTINUE
        RSTORE(N+IXYZO+12) = -RSTORE(N+IXYZO+12)
C STORE THE ATOM TYPE
        RSTORE(N+IATTYP) = IELM - ICELM + 1
C MOVE OVER CONN RADIUS - COVALENT
        RSTORE(N+IATTYP+5) = RSTORE(NINT(IRELM +
     c  (RSTORE(N+IATTYP)-1)*4.0))
        RSTORE (N+IATTYP+4) = RSTORE(N+IATTYP+5)/4.0
C MOVE OVER THE COLOUR INFORMATION
        RSTORE(N+IATTYP+1) =
     c  RSTORE ( NINT( IRELM + (RSTORE(N+IATTYP)-1) *4.0)   + 3 )
C JUMP TO HERE IF WE ARE LOOKING AT SYMMETRY GENERATED ATOMS
140     CONTINUE
        IF (NPOS.EQ.1) THEN
          NPOS = 28
        ELSE IF (NPOS.EQ.28) THEN
          NPOS = 55
        ELSE
          NPOS = 1
        ENDIF
110   CONTINUE
      DO 150 J = 1 , 3
        MIN(J) = MIN(J) * 0.00001
        MAX(J) = MAX(J) * 0.00001
150   CONTINUE
      CALL ZCENTR(MIN,MAX)
      CALL ZCOLKY
      ISVIEW = IRATOM
      IFVIEW = IRLAST
      ISINIT = ISVIEW
      IFINIT = IFVIEW
      WRITE (CLINE,16) NAT
16    FORMAT (I6,' atoms loaded.')
      CALL ZMORE(CLINE,0)
      IF (.NOT.LFILES (0,FILENM,IINPT))
     + CALL ZMORE('Error on closing input file.',0)
      IF (.NOT.LFILES (0, ' ' , ISCRAT))
     + CALL ZMORE('Error on closing scratch file.',0)
      RETURN
      END
 
CODE FOR ZGTSYM
      SUBROUTINE ZGTSYM (WORD,IWORD,ISYMNO,IERR)
C THIS ROUTINE TAKES THE CHARACTER FORM OF AN OPERATOR AND
C CONVERTS IT INTO THE SYMMETRY NUMBER.
      CHARACTER*(20) WORD
      CHARACTER*20 COPER
      INTEGER ISYMNO,IWORD,IERR
      CHARACTER*3 CTRAN(8)
      CHARACTER*1 CSYM(15)
      REAL TRAN(8)
      DATA TRAN /0.0,0.5,0.33333,0.25,0.6666667,0.75,0.16666667,
     c 0.8333333/
      DATA CTRAN /'0  ','1/2','1/3','1/4','2/3','3/4','1/6','5/6'/
      DATA CSYM /'X','x','Y','y','Z','z','+','-','/','1','2','3',
     c '4','5','6'/
C FIND THE LINKING OPERATOR - IF ANY
      ILINK = 0
      INLINK = 0
      IF (IWORD.GT.20) THEN
        IERR= 1
        RETURN
      ENDIF
      DO 710 II = 2 , IWORD
        IF (WORD(II:II).EQ.'+'.OR.WORD(II:II).EQ.'-') THEN
          ILINK = II
          INLINK = INLINK + 1
        ENDIF
710   CONTINUE
C IF WE HAVE >1 LINKING OPERATORS THERE IS AN ERROR
      IF (INLINK.GT.1) THEN
        IERR= 1
        RETURN
      ENDIF
      ISYMNO = 0
C WORK ON THE FIRST PART OF THE OPERATOR
      IF (ILINK.EQ.0) THEN
        COPER = WORD
      ELSE
        COPER = WORD(1:ILINK-1)
      ENDIF
720   CONTINUE
      IS = 1
      IPLUS = 0
C BEGIN TO ANALYSE THIS PART OF THE OPERATOR
      IF (COPER(1:1).EQ.'-') THEN
        IPLUS = -1
        IS  = 2
      ELSE IF (COPER(1:1).EQ.'+') THEN
        IS = 2
      ENDIF
C NOW LOOK AT THE NEXT PART OF THE OPERATOR
      IXYZ = 0
      DO 730 I = 1 , 6
        IF (COPER(IS:IS).EQ.CSYM(I)) THEN
          IXYZ = I/2 + 1
        ENDIF
730   CONTINUE
C HAVE WE FOUND AN X,Y OR Z.
      IF (IXYZ.NE.0) THEN
C STORE IT IN THE HIGH HALF OF THE NUMBER UNLESS IT IS ALREADY OCCUPIED
        IF (ISYMNO.GT.100) THEN
          ISYMNO = ISYMNO + IXYZ*10
          IF (IPLUS.EQ.-1) THEN
            ISYMNO = ISYMNO + 100
          ENDIF
        ELSE
          ISYMNO = ISYMNO + IXYZ*10000
          IF (IPLUS.EQ.-1) THEN
            ISYMNO = ISYMNO + 100000
          ENDIF
        ENDIF
C NOW CHECK - THIS SHOULD BE THE END OF THIS SECTION OF OPERATOR
        IF (ILINK.GT.0.AND.IS.NE.ILINK-1) THEN
          IERR = 1
          RETURN
        ENDIF
C GET THE NEXT PART OF THE OPERATOR
        IF (ILINK.NE.0) THEN
          COPER = WORD(ILINK:20)
          ILINK = 0
          GOTO 720
        ENDIF
C WE CANNOT HAVE TWO TRANSLATIONS AS PART OF THE SAME OPERATOR
        IF (ISYMNO.LT.1000.AND.ISYMNO.GT.0) THEN
          IERR = 1
          RETURN
        ENDIF
      ELSE
C OTHERWISE LOOK FOR A TRANSLATION
        ITRANS = 0
        III = YCCREA(COPER,RTRANS)
        IF (III.NE.-1) THEN
          RTRANS = ABS(RTRANS)
C FIND OUT WHAT TRANSLATION THIS IS
          DO 740 I = 1 , 8
            IF (ABS(RTRANS-TRAN(I)).LT.0.05) THEN
              ITRANS = I
            ENDIF
740       CONTINUE
C OTHERWISE IT MUST BE A FRACTION
        ELSE
          DO 750 I = 1 , 8
            IF (COPER(2:4).EQ.CTRAN(I)) THEN
              ITRANS = I
            ENDIF
750       CONTINUE
        ENDIF
        IF (ITRANS.EQ.0) THEN
          IERR = 1
          RETURN
        ENDIF
        ISYMNO = ISYMNO + ITRANS
        IF (IPLUS.EQ.-1) THEN
          ISYMNO = ISYMNO + 100
        ENDIF
C GET THE NEXT PART OF THE OPERATOR
        IF (ILINK.NE.0) THEN
          COPER = WORD(ILINK:20)
          ILINK = 0
          GOTO 720
        ENDIF
      ENDIF
      RETURN
      END

