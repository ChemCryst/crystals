C $Log: read.F,v $
C Revision 1.67  2013/06/11 12:30:39  pascal
C Linux changes
C
C Revision 1.66  2012/10/19 12:45:13  djw
C Make Script not found message less frightening
C
C Revision 1.65  2012/03/23 13:51:32  rich
C Intel support.
C
C Revision 1.64  2012/01/04 14:31:25  rich
C Fix some uninitialized variables, and output format mistakes.
C
C Revision 1.63  2012/01/03 14:36:35  rich
C Allow longer lines to be read by KRDLIN if required.
C
C Revision 1.62  2011/12/09 12:14:01  djw
C Make SCRIPT filenames lower case for all implementations
C If a SCRIPT does not exist, unwind the file stack and return to the COMMAND line
C
C Revision 1.61  2011/09/07 09:44:41  djw
C Change format of #SET OPENMESSAGE text so that columns line up across actions
C Add #SET CACHEMESSAGE (off/on) to inhibit caching information at termination
C Remove disc extension messages
C
C Revision 1.60  2011/09/01 12:08:54  djw
C unify file open/close messages
C
C Revision 1.59  2011/05/04 11:31:02  rich
C Fix string assignment.
C
C Revision 1.58  2011/04/21 13:11:45  djw
C Add & for the French
C
C Revision 1.57  2011/03/23 10:14:25  rich
C Fix and catch case where CRYSTALS runs out of pre-defined file units.
C
C Revision 1.56  2011/03/21 13:57:21  rich
C Update files to work with gfortran compiler.
C
C Revision 1.55  2009/06/08 14:26:24  djw
C Enable echoing of all input #COMMANDS
C
C Revision 1.54  2008/09/16 16:04:16  djw
C Enable SCRIPT command copying to .log file as comments
C
C Revision 1.53  2007/10/09 06:57:17  djw
C Output script name to listing file
C
C Revision 1.52  2005/03/10 12:12:48  djw
C Coppy COMMAND list to listing file
C
C Revision 1.51  2005/02/25 17:25:20  stefan
C 1. Added some preprocessor if defined lines for the mac version.
C
C Revision 1.50  2005/01/23 08:29:11  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.2  2004/12/13 16:16:08  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:08  rich
C New CRYSTALS repository
C
C Revision 1.49  2004/02/25 10:02:11  stefan
C Removed gui output not GILGIDWXS versions
C
C Revision 1.48  2004/02/18 12:08:23  rich
C Added option \SET TIME SLOW which prevents output of DATE and TIME strings.
C This is to be used by the new test_suite so that runs at different times
C generate no significant differences. Also supresses timing functions, as
C for \SET TIME OFF.
C
C Revision 1.47  2004/02/17 13:37:21  rich
C Extend some CSYS filenames to 256 characters. At the same time fix
C wrong addresses of last four CSYS units since last week when the
C character variables were extended, but the addresses were unchanged.
C (Affecting MAP and CIF files).
C
C Revision 1.46  2003/09/29 15:38:34  rich
C Added \DEFINE system instruction for building the command file. No
C need for separate executable anymore. This command is \REMOVEd in
C the normal startup file to prevent accidents.
C
C Revision 1.45  2003/08/05 11:11:12  rich
C Commented out unused routines - saves 50Kb off the executable.
C
C Revision 1.44  2003/07/03 10:41:04  rich
C Bug fixed: When top level scripts were called, the status bar shows them
C as being called from the last top level script that was run. Fix: Clear
C variables in between script runs.
C
C Revision 1.43  2003/07/01 16:47:24  rich
C Don't update the prompt information ['!','>',' '] in the GUI unless the
C input unit is the command line. Considerably reduces pointless GUI traffic.
C
C Revision 1.42  2003/05/15 17:26:28  rich
C Addition of one extra ENDFILE statement seems to
C make the system request queue work properly under g77.
C
C Revision 1.41  2003/05/07 12:18:55  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.40  2003/03/06 12:01:59  rich
C Clear ! prompt between reads.
C
C Revision 1.39  2003/02/20 16:04:10  rich
C Don't put prompt in the text output in the GUI version. However, we may
C set the "STATIC" text object XPRMPT to the prompt text.
C
C Revision 1.38  2003/01/21 12:54:11  rich
C Commented out swathes of unused code in order to shrink
C the executable a bit.
C
C Revision 1.37  2003/01/16 11:42:13  rich
C Use new SAFESET instruction to update various GUI elements - if they
C don't exist, the program ignores the instruction. Means you can now
C remove or rename guimenu.srt to drop to a really basic version of
C CRYSTALS without getting lots of warnings.
C
C Revision 1.36  2003/01/15 15:26:38  rich
C Removal of NCAWU calls throught the standard SFLS refinement instruction. If
C anywhere will benefit from less IO, it's here.
C
C Revision 1.35  2002/10/14 12:33:24  rich
C Support for DVF command line version.
C
C Revision 1.34  2002/08/23 09:02:26  richard
C Change for script names in status bar.
C
C Revision 1.33  2002/03/15 16:50:01  richard
C Type #SET BONDTYPE OFF to suppress bond type calculation.
C
C Revision 1.32  2002/03/15 11:30:09  richard
C Fix problem where bond types are not calculated on opening a new structure.
C
C Revision 1.31  2002/02/27 19:40:10  ckp2
C RIC: Increased input line length to 256 chars. HOWEVER - only a few modules know about
C this extra length. In general the program continues to ignore everything beyond
C column 80. The "system" commands (OPEN, RELEASE, etc.) do know about the extra length
C and can take extra long filenames as a result. The script processor also knows: lines
C in script files, the script input buffer and text output may now run up to 256 chars.
C RIC: THe system commands respect double-quotes around arguments, so that filenames can be
C given which contain spaces.
C
C Revision 1.30  2002/02/20 14:34:01  ckp2
C Update KRDARG to respect double quotes when reading off arguments. Updated
C KSYSIN not to use KRDARG, but to pass double quotes straight into KDETCH.
C
C Revision 1.29  2001/10/23 15:23:38  ckp2
C Send filenames regardless of ISSUPD status (this should only affect the sending of the model).
C
C Revision 1.28  2001/07/11 10:17:31  ckpgroup
C Change Format statement in BENCH
C
C Revision 1.27  2001/06/18 12:23:38  richard
C Change all script names to lower case before attempting to open the file.
C This is the one place where mixed case would be very confusing - especially
C as the exisiting scripts use random case when calling other scripts.
C
C Revision 1.26  2001/03/18 10:32:05  richard
C
C No longer send info about monitor file to the GUI.
C
C Revision 1.25  2001/03/08 14:36:04  richard
C Pass file names of punch, log, list and mon files from KRDOPN, if ISSUPD is set
C to one.
C If error occurs, do output on white on red.
C
C Revision 1.24  2001/01/17 11:06:02  richard
C Fixed logging of everything.
C Things which aren't logged: #SCRIPT, #USE, $, #SPAWN. This should
C make the log file entirely self-contained with no dependency on external
C files or programs.
C
C Revision 1.23  2000/12/01 17:08:55  richard
C RIC: Removed calls to experimental CSD code #EMAP and #EMAP2
C
C Revision 1.22  2000/10/30 15:35:10  CKP2
C fix some lowercase
C
C Revision 1.21  2000/10/04 16:57:46  CKP2
C set benchmarking
C
C Revision 1.20  2000/09/20 12:42:24  ckp2
C Allow shell commands to be processed immediately, even if script awaiting input.
C Add "SCRIPTS - Awaiting action" to status bar, when appropriate.
C Move "IGNORED/ERRORS" back 5 spaces so that it doesn't overflow 80 chars.
C
C Revision 1.19  2000/07/11 11:04:10  ckp2
C Extra argument to KFLOPN, for specifying SEQUENTIAL or DIRECT access
C
C Revision 1.18  2000/01/20 16:56:22  ckp2
C djw  remove old diagnostic
C
C Revision 1.17  1999/12/23 17:29:31  ckp2
C djw  fix unwanted output in Monitor file
C
C Revision 1.16  1999/12/15 14:54:53  ckp2
C djw  Add set autoupdate on/off, force ON in summary.
C
C Revision 1.15  1999/10/22 11:47:26  ckp2
C RIC: Uncommented the secret CSD stuff.
C
C Revision 1.14  1999/07/22 11:31:55  richard
C RIC: Made sure that the 'Script running' message, (now 'Script Mode'), appears
C after a read so that it doesn't replace useful Cameron status messages
C such as distances and angles.
C
C Revision 1.13  1999/07/15 10:54:34  richard
C RIC: Changed "Script waiting for input" message to "Script running", which
C is more true, especially when the script isn't waiting for input.
C
C Revision 1.12  1999/07/02 17:54:50  richard
C RIC: Moved the "Script awaiting input" message so that it prints
C every time, not just on first entry to KRDREC.
C
C Revision 1.11  1999/07/02 12:51:52  richard
C RIC: Increase parameter NADR from 68 to 69
C RIC: Increase NSSLEN from 13 to 14
C RIC: Increase NSSCHR by 64 from 640 to 704
C RIC: Add 'MAP' to list of values in CADDR.
C RIC: Add 641 to list of pointers to stored information.(ITRADR)
C RIC: Added 14 to end of ITRAD2 list.
C RIC: Added 64 to list data lengths in ITRLEN.
C
C Revision 1.10  1999/06/22 12:51:00  dosuser
C RIC: Added some more informative text for the status bar. It now
C distinguishes between waiting for commands, directives or script input.
C
C Revision 1.9  1999/06/03 17:23:42  dosuser
C RIC: Added Linux Graphical Interface support.
C
C Revision 1.8  1999/05/26 17:26:46  dosuser
C djw  add CSYS identifier 'CIF' for cif file names
C
C Revision 1.7  1999/05/21 11:47:28  dosuser
C RIC: Added section (commented out) for testing the CSD derived
C validation code.
C
C Revision 1.6  1999/05/10 17:09:10  dosuser
C RIC: Fixed so that atomic co-ordinates will be displayed as soon
C     as they become available. Previously you would have to either close
C     the program or re-call #SET TERM WIN. After the call to XWININ(IN)
C     LUPDAT was set to FALSE if no model was available. Now it isn't since
C     if there is no model, XGDBUP will simply return without doing anything
C     anyway.
C
CODE FOR KRDREC
      RECURSIVE FUNCTION KRDREC(IN)
C--READ THE NEXT RECORD, EITHER FROM THE INPUT STREAM OR FROM THE
C  SYSTEM REQUEST QUEUE, WHICHEVER IS APPROPIATE.
C
C   IN  0 if a call from Crystals (Normal behaviour)
C       1 if a call from Cameron  (Send me the blank lines)
C
C--RETURN VALUES OF 'KRDREC' ARE :
C
C   0  NORMAL CARD READ.
C  +1  '#INSTRUCTION' CARD FOUND, WHICH IS NOT A SYSTEM REQUEST OR
C      A COMMENT CARD.
C
C -- IF THE END OF A FILE FROM WHICH INSTRUCTIONS ARE BEING READ IS
C    DETECTED, THE PROGRAM IS TERMINATED WITH A SEVERE ERROR MESSAGE
C
C -- TYPES OF CARD RECOGNISED BY THIS ROUTINE, AND THE ACTION TAKEN FOR
C    EACH TYPE
C
C    FIRST      TYPE          SUBTYPE         ACTION
C    CHARACTER
C    ---------  ----          -------         ------
C
C    'IH'       INSTRUCTION
C                             NORMAL          RETURN CONTROL
C                             COMMENT         IGNORE AND GET NEW CARD
C                             SYSTEM INSTR.   EXECUTE AND GET NEW CARD
C    'IQ'       QUERY                         EXECUTE AND GET NEW CARD
C    OTHER      OTHER
C                             BLANK CARD      GET NEW CARD
C                             DIRECTIVE       RETURN CONTROL
C
C
C
C
C--THE COMMON BLOCK 'XCARDS' IS USED BY THIS AND OTHER ROUTINES
C  FOR CARD I/O CONTROL. THE VARIABLES ARE :
C
C  LCMAGE  THE TERMINAL INPUT CARD IMAGE, POSSIBLY CONTAINING
C              LOWERCASE CHARS. THE MONITOR OUTPUT IS FROM THIS ARRAY
C  IMAGE   THE ALL UPPERCASE VERSION OF THE INPUT CARD. SYSTEM REQUEST
C              QUEUE CARDS ARE READ INTO THIS ARRAY.
C  NC      THE CURRENT PROCESSING POSITION IN 'IMAGE'.
C  ND      EITHER 'NC' OR THE END OF THE CURRENT INFORMATION TO BE
C          PROCESSED IN 'IMAGE'.
C  LASTCH  THE LAST CHARACTER ON THE CURRENT INPUT RECORD TO BE USED.
C  NI      THE NUMBER OF THE CURRENT INPUT CARD.
C  NILAST  THE NUMBER OF THE CARD FOR THE LAST '#INSTRUCTION' FOUND.
C  NS      THE INCREMENT BETWEEN SUCCESSIVE INPUT RECORDS. THIS IS ONE
C          FOR DATA FROM THE USER AND 10000 FOR DATA ON THE SYSTEM
C          REQUEST QUEUE.
C  MON     THE NUMBER OF THE LAST CARD PRINTED BY 'XMONTR'.
C  ICAT    THE TYPE OF LISTING REQUEST FOR THE CARDS THAT ARE
C          PROCESSED. THIS VARIABLE IS USED BY 'XMONTR'.
C  IEOF    END OF FILE AND SYSTEM REQUEST QUEUE FLAG :
C
C          -1  LAST STATEMENT READ END OF FILE, AND THUS THE NEXT WILL
C              CAUSE THE JOB TO FAIL. THIS IS NOT SET BY THIS ROUTINE,
C              BUT CAN BE USED BY E.G. THE LIST 6 INPUT ROUTINES TO
C              INDICATE AN END OF FILE DETECTED ELSEWHERE
C           0  NORMAL READING FROM THE CONTROL STREAM.
C          >0  READING FROM THE SYSTEM REQUEST QUEUE.
C
C  IHFLAG  THIS VARIABLE INDICATES WHETHER THE LAST CARD CONTAINED
C          A '#INSTRUCTION' WHICH HAS NOT YET BEEN PROCESSE :
C
C          -1  NO '#INSTRUCTION' ON THE LAST CARD.
C           0  UNPROCESSED '#INSTRUCTION' ON THE LAST CARD.
C          +1    PROCESSED '#INSTRUCTION' ON THE LAST CARD.
C
C  NUSRQ   THE UNIT TO BE USED FOR THE SYSTEM REQUEST QUEUE.
C  NREC    THE NUMBER OF REQUESTS OUTSTANDING ON THE SYSTEM REQUEST
C          QUEUE.
C  IPOSRQ  THE CURRENT POSITION OF THE REQUEST QUEUE.
C  ITYPFL  THIS VARIBLE INDICATES THE TYPE OF KEYWORD BEING PROCESSED
C          AT PRESENT :
C
C          1  INSTRUCTION.
C          2  DIRECTIVE.
C          3  PARAMETER.
C          4  REQUIRED INPUT VALUE.
C
C  INSTR   THE NUMBER OF THE CURRENT INSTRUCTION.
C  IDIRFL  THIS CONTAINS THE NUMBER OF THE CURRENT DIRECTIVE, OR
C          -1  IF NO DIRECTIVE IS BEING PROCESSED.
C  IPARAM  THIS CONTAINS THE NUMBER OF THE CURRENT PARAMETER, OR
C          -1  IF NO PARAMETER IS BEING PROCESSED.
C  IPARAD  THIS CONTAINS THE ADDRESS OF THE CURRENT GROUP IN THE
C          DATA AREA FOR THE CURRENT DIRECTIVE OR 'NOWT'.
C
C--
C
C      IRDCPY(I)   COPY FLAG
C                    0      NO COPY. LINES READ ARE INSTRUCTIONS
C                    1      COPY INPUT DIRECTLY TO MONITOR.
C      IRDLOG(I)   LOG FLAG
C                    O      NO LOGGING
C                    1      INPUT WRITTEN TO LOG FILE
C
C      IRDCAT(I)   MONITOR FLAG
C                    0      DO NOT MONITOR INPUT
C                    1      MONITOR INPUT
C      IRDPAG      PAGE SIZE FOR COPY FILE ( IN LINES )
C      IRDLIN      NUMBER OF LINES SINCE LAST PROMPT
C
C
C
C
      LOGICAL LPRMPT
C
      INCLUDE 'TRDDAT.INC'
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XRDDAT.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XSYSHF.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XGUIOV.INC'
CDJW DEC 99 ADD GLOBAL SCRIPT VARIABLES SO WE CAN GET 'VERIFY'
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XSCCHK.INC'
      INCLUDE 'XMENUC.INC'
C
C
C
C
1000  CONTINUE
C
C -- CLEAR STARTUP FILE FLAG IF  NECESSARY
      IF ( IFLIND .LE. 1 ) ISSSTA = 0
C
C--ENSURE THAT THE LAST CARD WAS PRINTED IF NECESSARY
      IF ( ISSSTA .LE. 0 ) CALL XMONTR (-1)
C--CHECK IF ANY ERRORS WERE MADE ON THE LAST CARD
      IF(LEF-LSTLEF)1050,1150,1050
C--ERRORS  -  TERMINATE THEM PROPERLY
1050  CONTINUE

C--CHECK THE LAST READ, AND THE TYPE OF THE NEXT READ
1150  CONTINUE
      LSTLEF=LEF
      IF ( IRDSRQ(IFLIND) .GT. 0 ) THEN

C -- MOVE POINTERS REQUIRED BY SYSTEM REQUEST QUEUE HANDLING
        IF ( NREC .GT. 0 ) THEN
          NREC = NREC - 1
          IEOF = NREC
          IPOSRQ = IPOSRQ + 1
        ENDIF
C
      ENDIF
C
C----- COPY STATUS 'OFF'
      ICPSTS = 0
1400  CONTINUE
C
      LPRMPT = ( IQUN .EQ. 1 ) .AND. ( IUSFLG .NE. 2 ) .AND.
     2 ( ISSSTA .LE. 0 )
      IF ( LPRMPT ) THEN
        IRDLIN = 0
        IF (ITYPFL .EQ. 1 .AND. NCRU .EQ. 5)  THEN
#ifdef CRY_NOGUI
          CALL XPRMPT ( NCVDU , '!' )
#else
          WRITE(CMON,'(A)')
     1     '^^CO SAFESET [ XPRMPT TEXT ''!'' ]'
          CALL XPRVDU(NCVDU,1,0)
          WRITE(CMON,'(A)')
     1     '^^CO SAFESET [ MODEL01 MOUSEACTION=SELECTATOM ]'
          CALL XPRVDU(NCVDU,1,0)
1515      FORMAT ('^^CO SET PROGOUTPUT TEXT = ',A)
          WRITE (CMON,1515) '''Enter Commands'''
          CALL XPRVDU (NCVDU,1,0)
#endif
        ELSE
#ifdef CRY_NOGUI
          CALL XPRMPT ( NCVDU , '>' )
#else
          WRITE(CMON,'(A)')
     1     '^^CO SAFESET [ XPRMPT TEXT ''>'' ]'
          CALL XPRVDU(NCVDU,1,0)
          WRITE(CMON,'(A)')
     1     '^^CO SAFESET [ MODEL01 MOUSEACTION=APPENDATOM ]'
          CALL XPRVDU(NCVDU,1,0)
          WRITE (CMON,1515) '''Enter Directives'''
          CALL XPRVDU (NCVDU,1,0)
#endif
        ENDIF
C If in script mode, set flag.
        IF ( IRDSCR(IFLIND) .GT. 0 ) THEN
          INSTRC = .TRUE.
        ELSE
          INSTRC = .FALSE.
          CPRVNM = ' '  ! Clear names of running scripts.
          CSCPNM = ' '
          CLSTNM = ' '
        END IF
C Update status information for GUI.

#ifdef CRY_GUI
        IF (ISSTML .EQ. 4) CALL MENUUP
#endif
      ENDIF

      IF ( IRDFND(IFLIND) .GT. 0 ) THEN
        CALL XRDPOS ( NCRU , IRDREC(IFLIND) , IRDFND(IFLIND) )
      ENDIF
C
      ISTAT = KRDLIN ( NCRU , CRDLWC , IFIN )

c      WRITE(444,*)'IStat is ', ISTAT

#ifdef CRY_GUI
      IF ( NCRU .EQ. 5 ) THEN
      WRITE(CMON,'(A)') '^^CO SAFESET [ XPRMPT TEXT "" ]'
      CALL XPRVDU(NCVDU,1,0)
      END IF

C
#endif
      IF ( ISTAT .LT. 0 ) GO TO 9910
      IF ( ISTAT .EQ. 0 ) GO TO 3000
C
C -- INCREMENT RECORD NUMBER AND CHECK IF SEARCH IS IN PROGRESS
      IRDREC(IFLIND) = IRDREC(IFLIND) + 1
      IF ( IRDFND(IFLIND) .GT. 0 ) THEN
        IF ( IRDREC(IFLIND) .LT. IRDFND(IFLIND) ) GO TO 1400
        IRDFND(IFLIND) = 0
      ENDIF
C
C -- IF IN INITIALISATION PHASE, PERFORM SUBSTITUTIONS.
C
      IF ( ISSINI .GT. 0 ) THEN
        CALL XRDSUB ( CRDLWC )
      ENDIF
C
1420  CONTINUE

C&GIL      WRITE(6,*) NCRU, ':', CRDLWC
c      WRITE(555,*) NCRU, ':', CRDLWC

C If the current read unit is a script, then call KSCPRC.
      IF ( IRDSCR(IFLIND) .GT. 0 ) THEN
        IFLAG = KSCPRC ( CRDLWC , IFIN )

C If IFLAG is negative, then get a new line (from the SCRIPT file).
        IF ( IFLAG .LE. 0 )      GO TO 1000

C If IFLAG is 2, then send the command to CRYSTALS.
        IF ( IFLAG .EQ. 2 ) GO TO 1500

C If IFLAG is 3, then loop back and send this line back to scripts.
        IF ( IFLAG .EQ. 3 ) GO TO 1420

C Otherwise, carry on the output will be copied to the screen.
      ENDIF

      IFIN = MAX0 ( 1 , IFIN )

C -- IF COPYING, WRITE LINE TO MONITOR CHANNEL
      IF ( IRDCPY(IFLIND) .EQ. 1 ) THEN

        LPRMPT = ( IQUN .EQ. 1 ) .AND. ( IRDPAG .GT. 0 ) .AND.
     2 ( ISSSTA .LE. 0 )
        IF ( LPRMPT ) THEN
          IRDLIN = IRDLIN + 1
          IF ( IRDLIN .GT. IRDPAG ) THEN
            IRDLIN = 1
            INFIN = 0
            IF (ISSTML .NE. 4 ) THEN
                  CALL XPRMPT ( NCAWU , 'Press return to continue : ' )
                  ISTAT = KRDLIN ( NCUFU(1) , CRDUPC , INFIN )
                  IF ( ISTAT .LT. 0 ) GO TO 9910
                  IF ( ISTAT .EQ. 0 ) GO TO 3000
            ENDIF
C
            IF ( INFIN .GT. 0 ) THEN
              CALL XFLUNW ( 2 , 1 )
              CRDLWC = CRDUPC
              IFIN = INFIN
              GO TO 1420
            ENDIF
          ENDIF
        ENDIF
C
C----- CHANGE COLOUR UNDER DOS
        IF (ICPSTS .EQ. 0 ) THEN
C----- CHANGE COLOUR TO BLUE  ON WHITE FOR COPIED TEXT
          CALL OUTCOL(1)
C-----    SWITCH ON LINE FEEDS
          ICPSTS = 1
        ENDIF
       WRITE ( CMON,1451) CRDLWC(1:IFIN)
       CALL XPRVDU(NCVDU, 1,0)
1451   FORMAT ( 1X , A )
       GO TO 1400
      ELSE
         IF (ICPSTS .EQ. 1 ) THEN
C----- RESTORE COLOUR TO WHITE ON BLUE
C          CALL VGACOL ( 'BOL', 'WHI', 'BLU')
          CALL OUTCOL(1)
C-----    COPY STATUS 'OFF'
          ICPSTS = 0
         ENDIF
      ENDIF
C
C
C--UPDATE THE CARD NUMBER POINTER
1500  CONTINUE
C
C
C -- CONVERT INPUT TO UPPERCASE FOR CORRECT COMMAND PROCESSING
      CALL XCCUPC ( CRDLWC , CRDUPC )
      READ ( CRDLWC , '(256A1)' ) LCMAGE
      READ ( CRDUPC , '(256A1)' ) IMAGE
C
      IF ( ISSSTA .LE. 0 ) NI = NI + IRDINC(IFLIND)
C
C
C --  CHECK TYPE OF CARD.
C
      IF ( IMAGE(1) .EQ. IH ) THEN
cdjwjun07
        write(cmon,'(80a1)') (image(idjw),idjw=1,80)
cdjwjun09 copy all # lines
c        if ((issprt .eq. 0) .and. (cmon(1)(2:4) .eq. 'SCR')) then
        if (issprt .eq. 0)  then
            write(ncwu,'(A)') cmon(1)(:)
        endif
cdjwjun07
        IHFLAG = 0
        NC = 2
        IF ( IMAGE(2) .EQ. IB ) GO TO 1000
        ISTAT = KRDSYS ( IN )
        IF ( ISTAT .GT. 0 ) GO TO 1000
        KRDREC = 1
      ELSE IF ( IMAGE(1) .EQ. IQ ) THEN
        CALL XQUERY
        GO TO 1000
      ELSE
        IHFLAG = -1
        NC = 1
        KRDREC = 0
C -- IF LOGGING WRITE LINE BACK TO LOG CHANNEL
      IF ( IRDLOG(IFLIND) .EQ. 1 ) THEN
        WRITE ( NCLU , 1450 ) CRDLWC(1:IFIN)
1450    FORMAT ( A )
      ENDIF
C
      ENDIF
C
C&RIC{
      IF(IN.EQ.0) THEN
C&RIC}
           IF ( KNEQUL ( NC , IB ) .LE. 0 ) GO TO 1000
C&RIC{
        ENDIF
C&RIC}
      ND = NC
      RETURN
C
C
C
C
3000  CONTINUE
C
C -- END OF CURRENT INPUT FILE. THIS IS AN ERROR UNLESS WE ARE COPYING
C    A TEXT FILE
C
      IF ( IFLIND .LE. 1 ) THEN
        WRITE ( CMON,3005)
        CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 3005 )
      ENDIF
3005    FORMAT ( 1X , 'Attempt to read past end of CONTROL' )
        CALL XERHND ( IERERR )
        GO TO 1000
      ELSE IF ( IRDCMS(IFLIND) .LE. 0 ) THEN
        CALL XFLUNW ( 2 , 1 )
         IF (ICPSTS .EQ. 1 ) THEN
C----- RESTORE COLOUR TO WHITE ON BLUE
C          CALL VGACOL ( 'BOL', 'WHI', 'BLU')
          CALL OUTCOL(1)
C-----    COPY STATUS 'OFF'
          ICPSTS = 0
         ENDIF
        GO TO 1000
      ELSE
        CALL XFLUNW ( 2 , 3 )
        GO TO 1000
      ENDIF
C
C
C
C
9910  CONTINUE
C -- READ ERROR
C    FOR COPY TYPE OPERATIONS, RESTORE CONTROL
      IF ( IRDCPY(IFLIND) .EQ. 1 ) GO TO 3000
      CALL XERHND ( IERERR )
      GO TO 1000
C
C
      END
C
C
C
C
C
CODE FOR KRDLIN
      FUNCTION KRDLIN ( IUNIT , CLINE , LENUSE )
C
C -- READ A LINE OF INPUT
C
C  INPUT :-
C
C      IUNIT       UNIT NUMBER FOR READ
C
C  OUTPUT :-
C
C      CLINE        CHARACTER VARIABLE TO ACCEPT INPUT
C      LENUSE      USEFUL LENGTH OF INPUT ( I.E. UP TO LAST NON-SPACE
C                  CHARACTER )
C
C  RETURN VALUES :-
C
C      -1      ERROR READING LINE
C       0      END OF FILE DETECTED
C      +1      SUCCESS
C      +2      SHELL COMMAND
C
      CHARACTER*(*) CLINE
      CHARACTER *1 CDOLAR
      CHARACTER *2 CTRAN1 , CTRAN2, CTRAN3
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XGUIOV.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XIOBUF.INC'
CTest
      INCLUDE 'XLEXIC.INC'
CTest
C
C
CDJWAPR2011 ADD & FOR FRENCH USERS
      DATA  CTRAN3 / '&?' /      
      DATA  CTRAN2 / '#?' /, CDOLAR /'$'/
C------ THE FOLLOWING LINE WOULD BE BACKSLASH* IN THE DATA STATEMENT
C       ABOVE, EXCEPT THAT SOME WEIRD UNIX DICTATE WHAT YOU CAN DO
C       IN FORTRAN
      CTRAN1 = CHAR(92)//'*'
C
C----- INITIALISE BUFFER
      CLINE = ' '
      KRDLIN = 1

c      WRITE(NCWU,'(A,I5)') 'NWCARD is now:', NWCARD

c      WRITE(444,*)'Reading from ', IUNIT


C
      IF (IUNIT .EQ. NCUFU(1)) THEN
C If in script mode, set flag.
#ifdef CRY_GUI
          INSTRC = .FALSE.
          IF ( IRDSCR(IFLIND) .GT. 0 ) THEN
              INSTRC = .TRUE.
          END IF
          CALL MENUUP
#endif

	  CALL FLUSH(NCWU)
	  CALL FLUSH(NCPU)
	  CALL FLUSH(NCAWU)
          call flush(123)       ! for debugging purposes
          CALL GETCOM(CLINE)

C If in script mode, set progress text.
#ifdef CRY_GUI
          IF ( INSTRC ) THEN
              WRITE (CMON,1515) '''Crystals Script Mode'''
              CALL XPRVDU (NCVDU,1,0)
1515          FORMAT ('^^CO SET PROGOUTPUT TEXT = ',A)
          END IF
#endif
      ELSE
      READ ( IUNIT, 1015, ERR = 9910, END = 9920 , IOSTAT = IOS ) CLINE
      ENDIF

1015  FORMAT ( A )
1002  CONTINUE

      LENUSE = 0
      DO 1100 I = 1 , LEN ( CLINE )
        IF ( CLINE(I:I) .NE. ' ' ) LENUSE = I
1100  CONTINUE
C
C----- SPOT LINES BEGINNING WITH $, AND CONVERT TO # FUNCTIONS
      IF (CLINE(1:1) .EQ. CDOLAR) THEN
        LENUSE = MIN0( LENUSE, 76)
        DO 1200 I = LENUSE, 2, -1
        J = I+4
        CLINE(J:J) = CLINE(I:I)
1200    CONTINUE
        LENUSE = LENUSE + 4
        CLINE(1:5) = CTRAN1(1:1)//CDOLAR//'   '
        KRDLIN = 2
      END IF
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cC This section is used to test the CSDCODE.
cC Typing '#BONDTY' generates a list of bonds and automatically assigns
cC their bond types.
cC----- SPOT LINES BEGINNING WITH #BONDTY, AND CALL BONDTY
c      IF (CLINE(1:7) .EQ. '#BONDTY') THEN                               
c          LENUSE = 1
c          CLINE = ' '
c          CALL BONDTY(0)
cC Typing '#BONDCK' compares bond lengths and angles to the CSD data.
cC It writes quest files if the data is not available..
cC----- SPOT LINES BEGINNING WITH #BONDCK, AND CALL KBNDCH               
c      ELSE IF (CLINE(1:7) .EQ. '#BONDCK') THEN                               
c          LENUSE = 1
c          CLINE = ' '
c        IDV4 = KBNDCH ( RDV,  IDV, RDV2,
c     1                  RDV3, IDV2, IDV3, RDV4,
c     1                  1,    RDV5 )


C '#EMAP2' is put in the SRQ by '#EMAP' so that we can come back
C and analyse the results of a #FIND.
cC----- SPOT LINES BEGINNING WITH #EMAP2, AND CALL EMAP2D               
c      ELSE IF (CLINE(1:6) .EQ. '#EMAP2') THEN                               
c          LENUSE = 1
c          CLINE = ' '
c        ICODE = 2
c        CALL EMAP2D(ICODE)
C '#EMAP2D' reads in a 'GUESS.DAT' file which describes the
C bonding of a molecule (CSD quest format). It gets the relevant
C bond length and angle data from the local database and then
C checks the results of #FIND with this.
cC----- SPOT LINES BEGINNING WITH #EMAP, AND CALL EMAP2D               
c      ELSE IF (CLINE(1:5) .EQ. '#EMAP') THEN                               
c          LENUSE = 1
c          CLINE = ' '
c        ICODE = 0
c        CALL EMAP2D(ICODE)
c      ENDIF
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
C -- CONVERT FIRST CHARACTER IF NECESSARY
      IPOS = INDEX ( CTRAN1 , CLINE(1:1) )
      IF (IPOS .LE. 0) IPOS = INDEX ( CTRAN3 , CLINE(1:1) )
      IF ( IPOS .GT. 0 ) CLINE(1:1) = CTRAN2(IPOS:IPOS)
C
C
      I =  KHKIBM (CLINE)
      RETURN
C
C
9910  CONTINUE
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
9915  FORMAT ( 1X , 'Error during read. Line ignored' )
      CALL XERIOM ( IUNIT , IOS )
C
      KRDLIN = -1
      RETURN
9920  CONTINUE
C -- END OF FILE
      KRDLIN = 0
      RETURN
C
C
      END
C
C
C
C
C
CODE FOR XRDPOS
      SUBROUTINE XRDPOS ( IUNIT , ICURRN , ITARGT )
C
C -- POSITION SEQUENTIAL FILE NEAR REQUIRED ADDRESS
C
C
      IF ( ICURRN .GE. ITARGT ) THEN
        REWIND IUNIT
        ICURRN = 0
      ELSE IF ( ICURRN .EQ. ( ITARGT - 1 ) ) THEN
        RETURN
      ENDIF
C
      DO 1100 I = ICURRN + 1 , ITARGT - 1
        READ ( IUNIT , 1005 )
1005    FORMAT ( )
1100  CONTINUE
C
      ICURRN = ITARGT - 1
C
C
      RETURN
      END
C
C
C
C
C
C
CODE FOR KRDSYS
      RECURSIVE FUNCTION KRDSYS ( IN )
C -- CHECK IF THE CURRENT CARD CONTAINS A SYSTEM INSTRUCTION. IF IT
C    DOES, EXECUTE THE INSTRUCTION.
C
CDJWMAR99 Add APPEND as system function - implies 'OPEN'
CDJWOXT00 Add BENCHMARK for timings
CRICAPR03 Add DEFINE as system instruction. Build .dsc and exit.
C
C  INPUT :-
C
C      IN          DUMMY ARGUMENT.
C
C  RETURN VALUES :-
C
C      -1          INSTRUCTION WAS NOT A SYSTEM INSTRUCTION
C       1          INSTRUCTION WAS A SYSTEM INSTRUCTION. GO ON TO NEXT
C                    CARD.
C
C
      DIMENSION PAUSE(1), IDEV(4)
C
      DIMENSION KEYUSE(8)
      LOGICAL WEXIST
C
      CHARACTER *1  CFILE
      CHARACTER *256 CCMND
      CHARACTER *256 CUFILE, CRFILE
C
      INCLUDE 'XSTR11.INC'
      INCLUDE 'TDVNAM.INC'
      INCLUDE 'TRDDAT.INC'
C
C
C
C
      INCLUDE 'TSSCHR.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XDVNAM.INC'
      INCLUDE 'XRDDAT.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XSYSHF.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XSSCHR.INC'
C
      DATA IPAUSE / 1 / , IHELP  /  2 / , ISET   /  3 / , IATTCH /  4 /
      DATA IOPEN  / 5 / , IRELES /  6 / , IUSE   /  7 / , IMANUL /  8 /
      DATA ITYPE  / 9 / , IREMOV / 10 / , ISTRE  / 11 / , ISTART / 12 /
      DATA ISCRIP / 13 /, ICOMND / 14 / , ICLOSE / 15 / , ISPAWN / 16 /
      DATA IDOLLA / 17 /, IAPEND / 18 / , IBENCH / 19 / , IDEFIN / 20 /
C
      DATA NUSE / 2 / , LUSE / 4 /
C
C        CONT        LAST
C
#ifdef _HOL_
      DATA KEYUSE(1)/1HC/,KEYUSE(2)/1HO/,KEYUSE(3)/1HN/,KEYUSE(4)/1HT/
      DATA KEYUSE(5)/1HL/,KEYUSE(6)/1HA/,KEYUSE(7)/1HS/,KEYUSE(8)/1HT/
#else
      DATA KEYUSE(1)/'C'/,KEYUSE(2)/'O'/,KEYUSE(3)/'N'/,KEYUSE(4)/'T'/
      DATA KEYUSE(5)/'L'/,KEYUSE(6)/'A'/,KEYUSE(7)/'S'/,KEYUSE(8)/'T'/
#endif
C----- A DUMMY FILE
#ifdef _HOL_
      DATA  IDEV /1H ,1H ,1H ,1H /
#else
      DATA  IDEV /' ',' ',' ',' ' /
#endif
      DATA LFILE / 1 /
      DATA CFILE /' '/
C
      DATA MCHNAM / 4 / , LNAM / 8 /
C
C
C
C
C
C -- CHECK IF WE HAVE A SYSTEM INSTRUCTION
C
      ISYSIN = KCOMP ( NWHF , IMAGE(2) , IHF , NHF , LHF )
C
      IF ( ISYSIN .LE. 0 ) THEN
C --  IF LOGGING WRITE LINE BACK TO LOG CHANNEL
        IF ( IRDLOG(IFLIND) .EQ. 1 ) THEN
         WRITE ( NCLU , 500 ) CRDLWC(1:80)
500      FORMAT ( A )
501      FORMAT ('# ',A)
        ENDIF
        KRDSYS = -1
        RETURN
      ELSE
        KRDSYS = 1
      ENDIF
C
C
C
C --  BRANCH ON THE TYPE
C
C      PAUS(E)     HELP        SET         ATTACH      OPEN
C      RELE(ASE)   USE         MANUAL      TYPE        REMO(VE)
C      STOR(E)     STAR(T)     SCRI(PT)    COMM(ANDS)  CLOS(E)
C      SPAW(N)     $           APPE(ND)    BENCH       DEFI(NE)
C
C --  IF LOGGING WRITE LINE BACK TO LOG CHANNEL
      IF ( IRDLOG(IFLIND) .EQ. 1 ) THEN
C-----   DO NOT LOG SCRIPT INSTRUCTIONS
CRIC0101 DO NOT LOG USE,$,or SPAWN INSTRUCTIONS EITHER.
         IF (( ISYSIN .NE. ISCRIP) .AND. ( ISYSIN .NE. IUSE )
     1   .AND.(ISYSIN .NE. IDOLLA) .AND. ( ISYSIN .NE. ISPAWN) ) THEN
          WRITE ( NCLU , 500 ) CRDLWC(1:80)
         ELSE
c          WRITE ( NCLU , 501 ) CRDLWC(1:80)
          WRITE ( NCLU , 501 ) CRDLWC
         ENDIF
      END IF
C
C
CDJWMAR99
      GO TO ( 1100 , 1200 , 1300 , 1400 , 1500 ,
     2        1600 , 1700 , 1200 , 1200 , 2000 ,
     3        2100 , 2200 , 2300 , 2400 , 2500 , 
     4        2600 , 2600 , 1550 , 3000 , 3200 , 
     5        9920 ) , ISYSIN
      GO TO 9920
C
C
C
C
1100  CONTINUE
C
C -- 'PAUSE'
C
C -- IDENTIFY ARGUMENT
      IREQUI = 1
      LENGTH = KRDARG ( IREQUI  , 1 )
      IF ( LENGTH .LE. 0 ) GO TO 9930
C
      I = KREADC ( PAUSE(1) , 1 )
      IF ( I .LT. 0 ) GO TO 9930
C
C -- CONVERT VALUE READ TO INTEGER NUMBER OF MILLISECONDS AND PAUSE
      IPAUSE = NINT ( PAUSE(1) * 1000 )
      CALL XPAUSE ( IPAUSE )
      GO TO 9000
C
C
1200  CONTINUE
C
C -- 'HELP', 'MANUAL', AND 'TYPE'
C
C -- IDENTIFY NEXT ARGUMENT. DETERMINE LENGTH. CHECK ONLY ONE ARGUMENT.
      IREQUI = 1
      LENGTH = KRDARG ( IREQUI , 1 )
      IF ( LENGTH .LE. 0 ) GO TO 9980
C
C -- SWITCH ON COPYING TO OUTPUT FILE
      ICOPY = 1
      INLOG = 0
      INCAT = 0
      IOPER = 0
      ICLMSG = 0
      ISCR   = 0
      GO TO 3100
C
C
1300  CONTINUE
C
C -- 'SET'
C
      CALL XRDSET ( 0 , 0  , 0 , 0 )
      GO TO 9000
C
C
1400  CONTINUE
C
C -- 'ATTACH'
C
      CALL XRDATT
      GO TO 9000
C
C
1500  CONTINUE
C
C -- 'OPEN'
C
      CALL XRDOPN ( 2, IDEV, CFILE, LFILE )
      GO TO 9000
C
CDJWMAR99
C
1550  CONTINUE
C
C--- 'APPEND'
C
      CALL XRDOPN ( 4, IDEV, CFILE, LFILE )
      GOTO 9000
C
C
1600  CONTINUE
C
C -- 'RELEASE'
C
      CALL XRDOPN ( 1, IDEV, CFILE, LFILE )
      GO TO 9000
C
C
1700  CONTINUE
C
C -- 'USE'
C
C -- IDENTIFY NEXT ARGUMENT. DETERMINE LENGTH. CHECK ONLY ONE ARGUMENT.
      IREQUI = 1
      LENGTH = KRDARG ( IREQUI , 1 )
      IF ( LENGTH .LE. 0 ) GO TO 9980
C
C
      ICOPY = 0
      INLOG = IRDLOG(IFLIND)
      INCAT = ICAT
      IOPER = KCOMP ( LUSE , IMAGE(NC) , KEYUSE(1) , NUSE , LUSE )
      ICLMSG = IRDCMS(IFLIND)
      ISCR   = 0
C
      IF ( IOPER .GT. 0 ) THEN
        CALL XMONTR ( -1 )
      ENDIF
C
      GO TO 3100
C
C
3100  CONTINUE
C
C -- EXECUTE ALL FILE OPEN/CLOSE OPERATIONS, FROM 'USE', 'TYPE' ETC.
C
C -- 'IOPER' INDICATES OPERATION TO BE PERFORMED. VALUES ARE :-
C      -VE,0       OPEN A FILE FOR READING. IF IT FAILS, CLOSE CURRENT
C                    FILE
C      1           CLOSE ALL FILES BACK TO MAIN LEVEL ( 'USE CONTROL' )
C      2           CLOSE CURRENTLY OPEN FILE ( 'USE LAST' )
C
C
      IF ( IOPER .LE. 0 ) THEN
        IF ( IFLIND .EQ. IFLMAX ) GO TO 9940
        IFLIND = IFLIND + 1
C
        IF ( ISYSIN .EQ. IMANUL ) THEN
          CALL XFLPCK ( LCMAGE(NC) , LENGTH ,
     2            CINDDV(1:LINDDV) , CINDEX(1:LINDEX) , CRFILE , N )
        ELSE IF ( ISYSIN .EQ. IHELP ) THEN
          CALL XFLPCK ( LCMAGE(NC) , LENGTH ,
     2            CHLPDV(1:LHLPDV) , CHLPEX(1:LHLPEX) , CRFILE , N )
        ELSE IF ( ISYSIN .EQ. ISCRIP ) THEN
          CALL XFLPCK ( LCMAGE(NC) , LENGTH ,
     2            CSCPDV(1:LSCPDV) , CSCPEX(1:LSCPEX) , CRFILE , N )
C FORCE all #SCRIPT arguments to lowercase - all other files can be
C mixed case, but all script must be lower. This is for compatibility
C with existing script calls in scripts which are usually uppercase.
          CUFILE = CRFILE
          CALL XCCLWC ( CUFILE, CRFILE )
          CALL MTRNLG(CRFILE,'OLD',ILENG)
          INQUIRE(FILE=CRFILE(1:ILENG),EXIST=WEXIST)
          IF(.NOT.WEXIST) THEN
            CALL XFLPCK ( LCMAGE(NC) , LENGTH ,
     2           '' , CSCPEX(1:LSCPEX) , CRFILE , N )
            CUFILE = CRFILE
            CALL XCCLWC ( CUFILE, CRFILE )
            CALL MTRNLG(CRFILE,'OLD',ILENG)
          END IF
C DJW Dec11 #endif
        ELSE
          CALL XFLPCK ( LCMAGE(NC) , LENGTH ,
     2            ' ' ,              ' ' ,              CRFILE , N )
        ENDIF
C
        IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
         WRITE(NCWU,1006) IFLIND, NCUFU(IFLIND) , CRFILE
1006    FORMAT('READ      Opening File index=',I8, ': Unit =',I8,1X,A)
        ENDIF
C
        I = KFLOPN (NCUFU(IFLIND),CRFILE,ISSOLD,ISSREA,1,ISSSEQ)
        IF ( I .GT. 0 ) THEN
C -- DISPLAY THE CURRENT CARD BEFORE WE LOSE THE CHANCE
          CALL XMONTR ( -1 )
          IRDCPY(IFLIND) = ICOPY
          IRDLOG(IFLIND) = INLOG
          IRDCAT(IFLIND) = INCAT
          IFLCHR(IFLIND) = 0
          IRDCMS(IFLIND) = ICLMSG
          IRDINC(IFLIND) = 1
          IRDSCR(IFLIND) = ISCR
          IRDSRQ(IFLIND) = 0
          IRDFND(IFLIND) = 0
          IRDREC(IFLIND) = 0
          IRDHGH(IFLIND) = 0
          CALL XFLUNW ( 4 , 1 )
        ELSE
C --      FILE OPEN FAILED ( ERROR FOR USE, SCRIPT
C         WARN FOR TYPE ETC. , 
C         IGNORE FOR STARTUP )
          IF ( ISSSTA .LE. 0 ) THEN
            CALL XCTRIM( CRFILE, NCHAR)
            WRITE ( CMON,3105) CRFILE(1:NCHAR)
            CALL XPRVDU(NCEROR, 1,0)
cdjwdec11            IF (ISSPRT .EQ. 0) THEN
              WRITE ( NCWU , 3105 ) CRFILE
cdjwdec11            ENDIF
3105        FORMAT ( 1X , 'Error opening specified file - ' , A )
            CALL XERIOM ( NCUFU(IFLIND) , I )
            IERROR = IERWRN
            IF ( ISYSIN .EQ. IUSE ) IERROR = IERERR
            IF ( ISYSIN .EQ. ISCRIP ) IERROR = IERERR
            CALL XERHND ( IERROR )
          ENDIF
cdjwdec11
            IF ( ISYSIN .EQ. ISCRIP ) THEN
C            close back to top level if a SCRIPT does not exist
             WRITE(CMON,'(A/A/A/A)')
     1      '{EThe requested SCRIPT was not found. ',
     2      '{ECRYSTALS is closing down the SCRIPT processor.',
     3      '{EProbably a bug.',
     4      '{EPlease send the .log and .lis files to Oxford'
             CALL XPRVDU(NCVDU, 4, 0)
             write(ncwu,'(a)') cmon(1), cmon(2), cmon(3), cmon(4)
             CALL XFLUNW ( 1 , 3 )
            ELSE
             CALL XFLUNW ( 2 , 1 )
            ENDIF
        ENDIF
      ELSE IF ( ( IOPER .EQ. 1 ) .OR. ( IOPER .EQ. 2 ) ) THEN
C -- 'USE LAST' OR 'USE CONTROL'
      CALL XFLUNW ( IOPER , 3 )
      ENDIF
C
      GO TO 9000
C
C
2000  CONTINUE
C
C -- 'REMOVE'
C
C -- IDENTIFY ARGUMENT
      IREQUI = 1
      LENGTH = KRDARG ( IREQUI  , 1 )
      IF ( LENGTH .LE. 0 ) GO TO 9930
C
      MATCH = MIN0 ( LENGTH , NWHF )
      ILOC = KCOMP ( MATCH , IMAGE(NC) , IHF , NHF , LHF )
      IF ( ILOC .LE. 0 ) GO TO 9930
C
      IBEGIN = ( ILOC - 1 ) * LHF + 1
      DO 2010 I = IBEGIN , IBEGIN + LHF - 1
        IHF(I) = IB
2010  CONTINUE
      IF ( ILOC .EQ. NHF ) NHF = NHF - 1
      GO TO 9000
C
2100  CONTINUE
C
C -- 'STORE'
C
      CALL XRDSTR
      GO TO 9000
C
2200  CONTINUE
C
C -- 'START'
C
      CALL XRDSTA
      GO TO 9000
C
2300  CONTINUE
C
C -- 'SCRIPT'
C
C -- ONLY PROCESSED IN INTERACTIVE MODE
C
      IF ( IQUN .NE. 1 ) GO TO 9000
C
C -- IDENTIFY NEXT ARGUMENT. DETERMINE LENGTH. CHECK ONLY ONE ARGUMENT.
      IREQUI = 1
      LENGTH = KRDARG ( IREQUI , 1 )
      IF ( LENGTH .LE. 0 ) GO TO 9980
C
C -- CLEAR ERROR FLAG
C
      IERFLG = 1
C
C -- SET UP POINTERS FOR SCRIPT FILE
C
      CALL XSCFRM ( 0 )
C
C -- SWITCH ON COPYING TO OUTPUT FILE
      ICOPY = 1
CRIC0101 USE LOGGING PROPERTIES FOR THIS FILE INDEX
      INLOG = IRDLOG(IFLIND)
      INCAT = 0
      IOPER = 0
      ISCR = 1
      ICLMSG = 0
C
C -- PROCESS FILE SPECIFICATION
      GO TO 3100
C
C
2400  CONTINUE
C
C -- 'COMMANDS'
C
      NC = KEQUAL ( NC , IB )
      NC = KNEQUL ( NC , IB )
      CALL XWHELP ( 2 )
      GO TO 9000
C
2500  CONTINUE
C
C -- 'CLOSE'
C
      CALL XRDOPN ( 3, IDEV, CFILE, LFILE )
      GO TO 9000
C
C
C
2600  CONTINUE
C----- BREAK OUT TO JCL
C -- IDENTIFY ARGUMENT

c      IREQUI = 1
c      LENGTH = KRDARG ( IREQUI  , 2 )
      LSTART = KCCEQL ( CRDLWC, 1,' ' )
      LLAST  = KCLNEQ ( CRDLWC,-1,' ' )
      LENGTH = 1 + LLAST - LSTART
      CCMND  = ' '
      LCMND = 7
      CCMND(1:LCMND) = 'EXIT '
      IF ( LENGTH .GT. 0 ) THEN
C----- COPY AS MUCH OF LINE AS POSSIBLE
c        LENGTH = 80 - NC
        LENGTH = 256 - LSTART
        LCMND = LENGTH + 1
        CCMND(1:LCMND) = CRDLWC(LSTART:256)
      ENDIF
      CALL XDETCH ( CCMND(1:LCMND) )
      GOTO 9000
C
3000  CONTINUE
C----- SPEED BENCHMARK
C----- NOTE TEMPORARY USE OF PAUSE(1)
C      INITIALISE THE MATRIX AREA SIZE
      CALL XIN11
C -- IDENTIFY 1ST ARGUMENT
      IREQUI = 1
      LENGTH = KRDARG ( IREQUI  , 2 )
      IF ( LENGTH .LE. 0 ) THEN
            NVAR = 500
      ELSE
            I = KREADC ( PAUSE(1) , 1 )
            IF ( I .LT. 0 ) GO TO 9930
C -- CONVERT VALUE READ TO INTEGER NUMBER 
            NVAR = NINT ( PAUSE(1))
      ENDIF
C -- IDENTIFY 2ND ARGUMENT
      IREQUI = 1
      LENGTH = KRDARG ( IREQUI  , 2 )
      IF ( LENGTH .LE. 0 ) THEN
            NREF = 5000
      ELSE
            I = KREADC ( PAUSE(1) , 1 )
            IF ( I .LT. 0 ) GO TO 9930
C -- CONVERT VALUE READ TO INTEGER NUMBER 
            NREF = NINT ( PAUSE(1))
      ENDIF
C      WRITE(NCAWU,*) LFLD, NFLD, NVAR
      IF ((LFLD-NFLD) .LT. NVAR*(NVAR+1)) THEN
            WRITE(CMON,3050) NVAR,NREF
            CALL XPRVDU(NCVDU, 1,0)
3050  FORMAT ('Too many variables requested', 2I6)
      ELSE
        CALL XBENCH (XSTR11(NFLD), NVAR, XSTR11(NFLD+NVAR),
     1  NVAR*NVAR, NVAR, NREF)
      ENDIF
      GO TO 9000

3200  CONTINUE
C -- Define instruction
C
      NCDFU = NCIFU                ! IF A STARTUP FILE IS USED, THIS  
      ISTAT = KRDREC ( IN )        ! WILL CREATE A DISK ON UNUT NCDFU
      NU = NCIFU          ! ALL REFERENCES ARE TO THE NEW COMMAND FILE
C----- CREATE A NEW FILE
      ISTAT = KDAOPN ( NCIFU , CSSCMD(1:LSSCMD) , ISSNEW , ISSWRI )
      IF ( ISTAT .LT. 0 ) THEN
         CALL XERIOM ( NCIFU , ISTAT )
         CALL GUEXIT (2005)
      ENDIF
      CALL XDAXTN ( NCIFU, -1, 120) ! Extend disk to 120 records.
      WRITE ( CMON, 3191 )
      CALL XPRVDU(NCVDU,1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU, '(A)') CMON(1 )(:)
3191  FORMAT(' Create command file')
      CALL XSYSDC(-1,-1)
      NU=NCIFU         ! ENSURE ALL TRANSFERS ARE TO THE COMMAND FILE DISC
      CALL XRDHI(IFIRST)
      WRITE ( CMON, 3192 )
      CALL XPRVDU(NCVDU,6,0)
3192  FORMAT(//' Command file created successfully.'/
     1         'Closing in 4 seconds'/)
      CALL XPAUSE (4000)
      CALL XEND

C
9000  CONTINUE
      RETURN
C
C
9920  CONTINUE
C -- INTERNAL ERROR
      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
      GO TO 9000
9930  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9935)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9935 )
9935  FORMAT(1X,'Illegal or missing parameter for this Instruction' )
      GO TO 9980
9940  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9945)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9945 )
9945  FORMAT ( 1X, 'Attempt to exceed the maximum number of ' ,
     2 'HELP, MANUAL, TYPE, or USE files')
      CALL XERHND ( IERERR )
      GO TO 9000
9980  CONTINUE
C -- GENERAL HELP ON USING SYSTEM INSTRUCTIONS HANDLED BY THIS ROUTINE
      WRITE ( CMON,9985) (IH,J=1,7)
      CALL XPRVDU(NCEROR, 5,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9985 ) ( IH , J = 1 , 7 )
9985  FORMAT ( 1X , 'Specify a filename for ',A1,'TYPE or ',A1,'USE',/,
     2 1X , 'Specify a topic for ',A1,'HELP or ',A1,'MANUAL' , / ,
     3 1X , 'Specify a script name for ', A1 , 'SCRIPT' , / ,
     4 1X , 'Specify a time interval for ' , A1 , 'PAUSE' , / ,
     5 1X , 'Use the command ',A1,'HELP HELP for more information' )
      IERROR = IERWRN
      IF ( ISYSIN .EQ. IUSE ) IERROR = IERERR
      CALL XERHND ( IERROR )
      GO TO 9000
C
C
      END
C
C
C
C
C
CODE FOR KRDARG
      FUNCTION KRDARG ( ICOUNT , IEXACT )
C
C -- ISOLATE THE NEXT ARGUMENT ON THE CARD, DELIMITED BY SPACES.
C -- RIC 2002: or also CONTAINED BY DOUBLE QUOTES - allows spaces in file names.
C
C -- INPUTS :-
C      ICOUNT      NUMBER OF ARGUMENTS REQUIRED ( THIS VALUE IS CHANGED
C                    BY THIS ROUTINE IF AN ARGUMENT IS FOUND )
C      IEXACT      INDICATES WHETHER EXACT MATCH OF NUMBER OF ARGUMENTS
C                    SHOULD BE CHECKED.
C                        1     EXACT MATCH SHOULD BE CHECKED, AS FAR
C                                POSSIBLE
C                        2     ARGUMENTS ARE OPTIONAL
C
C -- RETURN VALUES :-
C      -1          NO ARGUMENT WHEN ONE WAS REQUIRED, OR MORE THAN ONE
C                    IF ONLY ONE WAS REQUIRED.
C      0           NO ARGUMENT EXPECTED OR FOUND
C      +VE         ARGUMENT FOUND SUCCESSFULLY. THE VALUE IS THE LENGTH
C                    OF THE ARGUMENT. 'NC' AND 'ND' POINT TO THE ENDS
C                    OF THE ARGUMENT.
C
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'

#ifdef _HOL_
      DATA KQUOT /1H"/
#else
      DATA KQUOT /'"'/
#endif
C
C
C
      LLASTC=LASTCH
      LASTCH=256

C -- LOCATE NEXT CHARACTER FOLLOWING SPACE
      NC = KEQUAL ( NC , IB )
      NC = KNEQUL ( NC , IB )
C
C -- CHECK FOR PRESENCE OF ARGUMENT
      IF ( NC .LE. 0 ) THEN
        NFOUND = 0
        LENGTH = 0
      ELSE

        NFOUND = 1
C -- Check if this argument starts with a quote
        IF (IMAGE(NC).EQ.KQUOT)THEN
C -- Skip over the quote
          NC = MIN(NC+1,256)
C -- FIND OTHER END OF ARGUMENT (next quote)
          ND = KEQUAL ( NC, KQUOT )
          IF ( ND .LE. 0 ) THEN
            ND = 256
          ELSE
C -- Remove second quote completely.
            IMAGE(ND)=IB
          END IF

        ELSE

C -- FIND OTHER END OF ARGUMENT (next space)
          ND = KEQUAL ( NC , IB )
          IF ( ND .LE. 0 ) ND = 256
        END IF

        LENGTH = ND - NC
        IF ( LENGTH .LE. 0 ) NFOUND = 0
C
C -- SEARCH FOR ANOTHER ARGUMENT
        NE = KNEQUL ( ND , IB )
        IF ( NE .GT. 0 ) NFOUND = 2
C
C
      ENDIF

      LASTCH=LLASTC

C
      IF ( IEXACT .EQ. 1 ) THEN
        IF ( ( NFOUND .EQ. 0 ) .AND. ( ICOUNT .GT. 0 ) ) GO TO 9960
        IF ( NFOUND .GT. ICOUNT ) GO TO 9970
      ENDIF
C
      ICOUNT = ICOUNT - 1
      KRDARG = LENGTH
C
      RETURN
C
C
9900  CONTINUE
      KRDARG = -1
      RETURN
9960  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9965)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9965 )
9965  FORMAT ( 1X , 'A required parameter has been omitted' )
      GO TO 9900
9970  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9975)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9975 )
9975  FORMAT ( 1X , 'Too many parameters have been given' )
      GO TO 9900
C
C
      END
C
C
C
C
C
CODE FOR XRDSET
      SUBROUTINE XRDSET ( IFNSET , IVLSET , IFUNC , IVAL )
C
C -- THIS ROUTINE IS USED TO SET SYSTEM CONSTANTS. IT CAN FUNCTION IN
C    THREE DIFFERENT WAYS.
C    1)  VALUES INDICATING THE CONSTANT TO BE SET AND THE VALUE TO
C        STORE CAN BE PASSED TO THIS ROUTINE.
C    2)  THE ROUTINE CAN PROCESS AN INPUT LINE TO DETERMINE WHICH
C        VALUE TO SET AND THE VALUE TO STORE.
C    3)  THE ROUTINE CAN BE TOLD WHICH VALUE TO SET, AND DETERMINE THE
C        VALUE FROM THE INPUT LINE.
C
C    2) IS USED TO IMPLEMENT THE 'SET' SYSTEM INSTRUCTION. 1) AND 3)
C    HAVE BEEN USED ( BUT ARE NO LONGER ) TO ALLOW THE OLD SYSTEM
C    INSTRUCTIONS 'LOG', 'HIDE' ETC. TO EXIST IN PARALLEL WITH 'SET'.
C
C
C
C      IFNSET      INDICATES WHETHER 'IFUNC' IS USED
C                    0      DETERMINE FUNCTION FROM INPUT CARD
C                    1      DETERMINE FUNCTION FROM 'IFUNC'
C      IVLSET      INDICATES WHETHER 'IVAL' IS USED
C                    0      DETERMINE VALUE FROM INPUT CARD
C                    1      DETERMINE VALUE FROM 'IVAL'
C      IFUNC       SPECIFY FUNCTION
C      IVAL        SPECIFY THE VALUE TO SET.
C
C -- ALLOWED FUNCTIONS :-
C
C      VALUE       KEYWORD           VARIABLE(S) SET
C      -----       -------           ---------------
C      1           MAPS              'MAPS'
C      2           MONI(TOR)         'ICAT' AND 'IRDCAT(IFLIND)'
C      3           LOG               'IRDLOG(IFLIND)'
C      4           PAGE              'IRDPAG'
C      5           LIST(S)           'ISSLSM'
C      6           SPEE(D)           'ISSSPD'
C      7           TIMI(NG)          'ISSTIM'
C      8           WATC(H)           'ISSLNM'
C      9           SRQ               'INMSRQ'
C     10           TERMINAL          'ISSTML'
C     11           FILECASE          'ISSFLC'
C     12           MESSAGE           'ISSMSG'
C     13           PRINTER           'ISSPRT'
C     14           GENERATE          'ISSGEN'
C     15           OPENMESSAGE       'ISSFLM'
C     16           PAUSE             'ISSPAS'
C     17           EXPO(RT)          'ISSEXP'
C     18           UEQU(IV)          'ISSUEQ'
C     19           AUTO(UPDATE)      'ISSUPD'
C     20           BOND(TYPE)        'ISSBND'
C     21           CACHEMESSAGE      'ISSCSH'
C     22           RATIO             'ISSRAT'
C
C    THE NAMES OF THE ALLOWED FUNCTIONS ARE STORED IN THE ARRAY
C    'KEYFNC'. EACH STORED NAME IS 8 'A1' WORDS LONG. ONLY THE FIRST 4
C    CHARACTERS ARE USED WHEN COMPARING THE NAME WITH A COMMAND LINE,
C    BUT ALL 8 ARE DISPLAYED IN THE ERROR MESSAGE PRODUCED WHEN THE
C    FUNCTION KEYWORD IS ILLEGAL OR MISSING.
C
C
C -- DATA DEFINING TYPE OF ARGUMENTS ALLOWED :-
C
C      ITPVAL      TYPE OF ARGUMENT
C                    1      CHARACTER ( ONE OF SET OF ALLOWED VALUES )
C                    2      INTEGER
C      KEYVAL      HOLDS ALLOWED VALUES FOR CHARACTER ARGUMENTS. ( 4 A1
C                  WORDS )
C      ISTVAL      STARTING ADDRESS IN 'KEYVAL' OF FIRST ALLOWED VALUE
C      NUMVAL      NUMBER OF ALLOWED VALUES IN 'KEYVAL' TO USE
C      IFIRVL      NUMERIC VALUE ASSOCIATED WITH FIRST ALLOWED STRING
C                  VALUE. SUBSEQUENT STRING VALUES ARE GIVEN INCREASING
C                  NUMERIC VALUES
      PARAMETER (LFNC=8)
      PARAMETER (NFNC=22)
      PARAMETER (LUFNC=4)
C
      DIMENSION KEYFNC(LFNC,NFNC)
      DIMENSION ITPVAL(NFNC)
      DIMENSION ISTVAL(NFNC)
      DIMENSION NUMVAL(NFNC)
      DIMENSION IFIRVL(NFNC)
C
      PARAMETER (LVAL=4)
      PARAMETER (NVAL=23)
      DIMENSION KEYVAL(LVAL,NVAL)
C
      DIMENSION VALUE(1)
C
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XGUIOV.INC'
C
C
C      MAPS        MONI(TOR)   LOG         PAGE        LIST(S)
C      SPEE(D)     TIME        SRQ         TERM(INAL)   FILE(CASE)
C      MESS(AGE)   PRIN(TER)   GENE(RATE)  OPEN(MESSAGE)
C      PAUS(E)     EXPO(RT)    UEQU(IV)    AUTO(UPDATE) BOND(TYPE)
C      CACHEMESSAGE RATIO
C
C
C      LIST        NONE        CORE        OFF         ON
C      SLOW        FAST        NONE        READ        WRIT
C      BOTH        UNKN(OWN)   VT52        VT10(0)     VGA
C      WIN(OW)     LOWE(R)     UPPE(R)     MIXE(D)     ARIT(H)
C      GEOM        IO          IC
C
#ifdef _HOL_
      DATA KEYFNC(1,1) / 1HM / , KEYFNC(2,1) / 1HA /
      DATA KEYFNC(3,1) / 1HP / , KEYFNC(4,1) / 1HS /
      DATA KEYFNC(5,1) / 1H  / , KEYFNC(6,1) / 1H  /
      DATA KEYFNC(7,1) / 1H  / , KEYFNC(8,1) / 1H  /
      DATA KEYFNC(1,2) / 1HM / , KEYFNC(2,2) / 1HO /
      DATA KEYFNC(3,2) / 1HN / , KEYFNC(4,2) / 1HI /
      DATA KEYFNC(5,2) / 1HT / , KEYFNC(6,2) / 1HO /
      DATA KEYFNC(7,2) / 1HR / , KEYFNC(8,2) / 1H  /
      DATA KEYFNC(1,3) / 1HL / , KEYFNC(2,3) / 1HO /
      DATA KEYFNC(3,3) / 1HG / , KEYFNC(4,3) / 1H  /
      DATA KEYFNC(5,3) / 1H  / , KEYFNC(6,3) / 1H  /
      DATA KEYFNC(7,3) / 1H  / , KEYFNC(8,3) / 1H  /
      DATA KEYFNC(1,4) / 1HP / , KEYFNC(2,4) / 1HA /
      DATA KEYFNC(3,4) / 1HG / , KEYFNC(4,4) / 1HE /
      DATA KEYFNC(5,4) / 1H  / , KEYFNC(6,4) / 1H  /
      DATA KEYFNC(7,4) / 1H  / , KEYFNC(8,4) / 1H  /
      DATA KEYFNC(1,5) / 1HL / , KEYFNC(2,5) / 1HI /
      DATA KEYFNC(3,5) / 1HS / , KEYFNC(4,5) / 1HT /
      DATA KEYFNC(5,5) / 1HS / , KEYFNC(6,5) / 1H  /
      DATA KEYFNC(7,5) / 1H  / , KEYFNC(8,5) / 1H  /
C
      DATA KEYFNC(1,6) / 1HC / , KEYFNC(2,6) / 1HO /
      DATA KEYFNC(3,6) / 1HM / , KEYFNC(4,6) / 1HM /
      DATA KEYFNC(5,6) / 1HU / , KEYFNC(6,6) / 1HN /
      DATA KEYFNC(7,6) / 1HI / , KEYFNC(8,6) / 1HC /
C
      DATA KEYFNC(1,7) / 1HT / , KEYFNC(2,7) / 1HI /
      DATA KEYFNC(3,7) / 1HM / , KEYFNC(4,7) / 1HE /
      DATA KEYFNC(5,7) / 1H  / , KEYFNC(6,7) / 1H  /
      DATA KEYFNC(7,7) / 1H  / , KEYFNC(8,7) / 1H  /
      DATA KEYFNC(1,8) / 1HW / , KEYFNC(2,8) / 1HA /
      DATA KEYFNC(3,8) / 1HT / , KEYFNC(4,8) / 1HC /
      DATA KEYFNC(5,8) / 1HH / , KEYFNC(6,8) / 1H  /
      DATA KEYFNC(7,8) / 1H  / , KEYFNC(8,8) / 1H  /
      DATA KEYFNC(1,9) / 1HS / , KEYFNC(2,9) / 1HR /
      DATA KEYFNC(3,9) / 1HQ / , KEYFNC(4,9) / 1H  /
      DATA KEYFNC(5,9) / 1H  / , KEYFNC(6,9) / 1H  /
      DATA KEYFNC(7,9) / 1H  / , KEYFNC(8,9) / 1H  /
      DATA KEYFNC(1,10) / 1HT / , KEYFNC(2,10) / 1HE /
      DATA KEYFNC(3,10) / 1HR / , KEYFNC(4,10) / 1HM /
      DATA KEYFNC(5,10) / 1HI / , KEYFNC(6,10) / 1HN /
      DATA KEYFNC(7,10) / 1HA / , KEYFNC(8,10) / 1HL /
      DATA KEYFNC(1,11) / 1HF / , KEYFNC(2,11) / 1HI /
      DATA KEYFNC(3,11) / 1HL / , KEYFNC(4,11) / 1HE /
      DATA KEYFNC(5,11) / 1HC / , KEYFNC(6,11) / 1HA /
      DATA KEYFNC(7,11) / 1HS / , KEYFNC(8,11) / 1HE /
      DATA KEYFNC(1,12) / 1HM / , KEYFNC(2,12) / 1HE /
      DATA KEYFNC(3,12) / 1HS / , KEYFNC(4,12) / 1HS /
      DATA KEYFNC(5,12) / 1HA / , KEYFNC(6,12) / 1HG /
      DATA KEYFNC(7,12) / 1HE / , KEYFNC(8,12) / 1H  /
C
      DATA KEYFNC(1,13) / 1HP / , KEYFNC(2,13) / 1HR /
      DATA KEYFNC(3,13) / 1HI / , KEYFNC(4,13) / 1HN /
      DATA KEYFNC(5,13) / 1HT / , KEYFNC(6,13) / 1HE /
      DATA KEYFNC(7,13) / 1HR / , KEYFNC(8,13) / 1H  /
C
      DATA KEYFNC(1,14) / 1HG / , KEYFNC(2,14) / 1HE /
      DATA KEYFNC(3,14) / 1HN / , KEYFNC(4,14) / 1HE /
      DATA KEYFNC(5,14) / 1HR / , KEYFNC(6,14) / 1HA /
      DATA KEYFNC(7,14) / 1HT / , KEYFNC(8,14) / 1HE /
C
      DATA KEYFNC(1,15) / 1HO / , KEYFNC(2,15) / 1HP /
      DATA KEYFNC(3,15) / 1HE / , KEYFNC(4,15) / 1HN /
      DATA KEYFNC(5,15) / 1HM / , KEYFNC(6,15) / 1HE /
      DATA KEYFNC(7,15) / 1HS / , KEYFNC(8,15) / 1HS /
C
      DATA KEYFNC(1,16) / 1HP / , KEYFNC(2,16) / 1HA /
      DATA KEYFNC(3,16) / 1HU / , KEYFNC(4,16) / 1HS /
      DATA KEYFNC(5,16) / 1HE / , KEYFNC(6,16) / 1H  /
      DATA KEYFNC(7,16) / 1H  / , KEYFNC(8,16) / 1H  /
C
      DATA KEYFNC(1,17) / 1HE / , KEYFNC(2,17) / 1HX /
      DATA KEYFNC(3,17) / 1HP / , KEYFNC(4,17) / 1HO /
      DATA KEYFNC(5,17) / 1HR / , KEYFNC(6,17) / 1HT /
      DATA KEYFNC(7,17) / 1H  / , KEYFNC(8,17) / 1H  /
C
      DATA KEYFNC(1,18) / 1HU / , KEYFNC(2,18) / 1HE /
      DATA KEYFNC(3,18) / 1HQ / , KEYFNC(4,18) / 1HU /
      DATA KEYFNC(5,18) / 1HI / , KEYFNC(6,18) / 1HV /
      DATA KEYFNC(7,18) / 1H  / , KEYFNC(8,18) / 1H  /
C
      DATA KEYFNC(1,19) / 1HA / , KEYFNC(2,19) / 1HU /
      DATA KEYFNC(3,19) / 1HT / , KEYFNC(4,19) / 1HO /
      DATA KEYFNC(5,19) / 1HU / , KEYFNC(6,19) / 1HP /
      DATA KEYFNC(7,19) / 1HD / , KEYFNC(8,19) / 1HT /
C
      DATA KEYFNC(1,20) / 1HB / , KEYFNC(2,20) / 1HO /
      DATA KEYFNC(3,20) / 1HN / , KEYFNC(4,20) / 1HD /
      DATA KEYFNC(5,20) / 1HT / , KEYFNC(6,20) / 1HY /
      DATA KEYFNC(7,20) / 1HP / , KEYFNC(8,20) / 1HE /
C
      DATA KEYFNC(1,21) / 1HC / , KEYFNC(2,21) / 1HA /
      DATA KEYFNC(3,21) / 1HC / , KEYFNC(4,21) / 1HH /
      DATA KEYFNC(5,21) / 1HE / , KEYFNC(6,21) / 1HM /
      DATA KEYFNC(7,21) / 1HE / , KEYFNC(8,21) / 1HS /
C
      DATA KEYFNC(1,22) / 1HR / , KEYFNC(2,22) / 1HA /
      DATA KEYFNC(3,22) / 1HT / , KEYFNC(4,22) / 1HI /
      DATA KEYFNC(5,22) / 1HO / , KEYFNC(6,22) / 1H  /
      DATA KEYFNC(7,22) / 1H  / , KEYFNC(8,22) / 1H  /
C
      DATA KEYVAL(1,1) / 1HL / , KEYVAL(2,1) / 1HI /
      DATA KEYVAL(3,1) / 1HS / , KEYVAL(4,1) / 1HT /
      DATA KEYVAL(1,2) / 1HN / , KEYVAL(2,2) / 1HO /
      DATA KEYVAL(3,2) / 1HN / , KEYVAL(4,2) / 1HE /
      DATA KEYVAL(1,3) / 1HC / , KEYVAL(2,3) / 1HO /
      DATA KEYVAL(3,3) / 1HR / , KEYVAL(4,3) / 1HE /
      DATA KEYVAL(1,4) / 1HO / , KEYVAL(2,4) / 1HF /
      DATA KEYVAL(3,4) / 1HF / , KEYVAL(4,4) / 1H  /
      DATA KEYVAL(1,5) / 1HO / , KEYVAL(2,5) / 1HN /
      DATA KEYVAL(3,5) / 1H  / , KEYVAL(4,5) / 1H  /
      DATA KEYVAL(1,6) / 1HS / , KEYVAL(2,6) / 1HL /
      DATA KEYVAL(3,6) / 1HO / , KEYVAL(4,6) / 1HW /
      DATA KEYVAL(1,7) / 1HF / , KEYVAL(2,7) / 1HA /
      DATA KEYVAL(3,7) / 1HS / , KEYVAL(4,7) / 1HT /
      DATA KEYVAL(1,8) / 1HN / , KEYVAL(2,8) / 1HO /
      DATA KEYVAL(3,8) / 1HN / , KEYVAL(4,8) / 1HE /
      DATA KEYVAL(1,9) / 1HR / , KEYVAL(2,9) / 1HE /
      DATA KEYVAL(3,9) / 1HA / , KEYVAL(4,9) / 1HD /
      DATA KEYVAL(1,10)/ 1HW / , KEYVAL(2,10)/ 1HR /
      DATA KEYVAL(3,10)/ 1HI / , KEYVAL(4,10)/ 1HT /
      DATA KEYVAL(1,11)/ 1HB / , KEYVAL(2,11)/ 1HO /
      DATA KEYVAL(3,11)/ 1HT / , KEYVAL(4,11)/ 1HH /
      DATA KEYVAL(1,12)/ 1HU / , KEYVAL(2,12)/ 1HN /
      DATA KEYVAL(3,12)/ 1HK / , KEYVAL(4,12)/ 1HN /
      DATA KEYVAL(1,13)/ 1HV / , KEYVAL(2,13)/ 1HT /
      DATA KEYVAL(3,13)/ 1H5 / , KEYVAL(4,13)/ 1H2 /
      DATA KEYVAL(1,14)/ 1HV / , KEYVAL(2,14)/ 1HT /
      DATA KEYVAL(3,14)/ 1H1 / , KEYVAL(4,14)/ 1H0 /
      DATA KEYVAL(1,15)/ 1HV / , KEYVAL(2,15)/ 1HG /
      DATA KEYVAL(3,15)/ 1HA / , KEYVAL(4,15)/ 1H  /
      DATA KEYVAL(1,16)/ 1HW / , KEYVAL(2,16)/ 1HI /
      DATA KEYVAL(3,16)/ 1HN / , KEYVAL(4,16)/ 1HD /
      DATA KEYVAL(1,17)/ 1HL / , KEYVAL(2,17)/ 1HO /
      DATA KEYVAL(3,17)/ 1HW / , KEYVAL(4,17)/ 1HE /
      DATA KEYVAL(1,18)/ 1HU / , KEYVAL(2,18)/ 1HP /
      DATA KEYVAL(3,18)/ 1HP / , KEYVAL(4,18)/ 1HE / 
      DATA KEYVAL(1,19)/ 1HM / , KEYVAL(2,19)/ 1HI /
      DATA KEYVAL(3,19)/ 1HX / , KEYVAL(4,19)/ 1HE /
      DATA KEYVAL(1,20)/ 1HA / , KEYVAL(2,20)/ 1HR /
      DATA KEYVAL(3,20)/ 1HI / , KEYVAL(4,20)/ 1HT /
      DATA KEYVAL(1,21)/ 1HG / , KEYVAL(2,21)/ 1HE /
      DATA KEYVAL(3,21)/ 1HO / , KEYVAL(4,21)/ 1HM /
      DATA KEYVAL(1,22)/ 1HI / , KEYVAL(2,22)/ 1HO /
      DATA KEYVAL(3,22)/ 1H  / , KEYVAL(4,22)/ 1H  /
      DATA KEYVAL(1,23)/ 1HI / , KEYVAL(2,23)/ 1HC /
      DATA KEYVAL(3,23)/ 1H  / , KEYVAL(4,23)/ 1H  /
#else
      DATA KEYFNC(1,1) / 'M' / , KEYFNC(2,1) / 'A' /
      DATA KEYFNC(3,1) / 'P' / , KEYFNC(4,1) / 'S' /
      DATA KEYFNC(5,1) / ' ' / , KEYFNC(6,1) / ' ' /
      DATA KEYFNC(7,1) / ' ' / , KEYFNC(8,1) / ' ' /
      DATA KEYFNC(1,2) / 'M' / , KEYFNC(2,2) / 'O' /
      DATA KEYFNC(3,2) / 'N' / , KEYFNC(4,2) / 'I' /
      DATA KEYFNC(5,2) / 'T' / , KEYFNC(6,2) / 'O' /
      DATA KEYFNC(7,2) / 'R' / , KEYFNC(8,2) / ' ' /
      DATA KEYFNC(1,3) / 'L' / , KEYFNC(2,3) / 'O' /
      DATA KEYFNC(3,3) / 'G' / , KEYFNC(4,3) / ' ' /
      DATA KEYFNC(5,3) / ' ' / , KEYFNC(6,3) / ' ' /
      DATA KEYFNC(7,3) / ' ' / , KEYFNC(8,3) / ' ' /
      DATA KEYFNC(1,4) / 'P' / , KEYFNC(2,4) / 'A' /
      DATA KEYFNC(3,4) / 'G' / , KEYFNC(4,4) / 'E' /
      DATA KEYFNC(5,4) / ' ' / , KEYFNC(6,4) / ' ' /
      DATA KEYFNC(7,4) / ' ' / , KEYFNC(8,4) / ' ' /
      DATA KEYFNC(1,5) / 'L' / , KEYFNC(2,5) / 'I' /
      DATA KEYFNC(3,5) / 'S' / , KEYFNC(4,5) / 'T' /
      DATA KEYFNC(5,5) / 'S' / , KEYFNC(6,5) / ' ' /
      DATA KEYFNC(7,5) / ' ' / , KEYFNC(8,5) / ' ' /
C
      DATA KEYFNC(1,6) / 'C' / , KEYFNC(2,6) / 'O' /
      DATA KEYFNC(3,6) / 'M' / , KEYFNC(4,6) / 'M' /
      DATA KEYFNC(5,6) / 'U' / , KEYFNC(6,6) / 'N' /
      DATA KEYFNC(7,6) / 'I' / , KEYFNC(8,6) / 'C' /
C
      DATA KEYFNC(1,7) / 'T' / , KEYFNC(2,7) / 'I' /
      DATA KEYFNC(3,7) / 'M' / , KEYFNC(4,7) / 'E' /
      DATA KEYFNC(5,7) / ' ' / , KEYFNC(6,7) / ' ' /
      DATA KEYFNC(7,7) / ' ' / , KEYFNC(8,7) / ' ' /
      DATA KEYFNC(1,8) / 'W' / , KEYFNC(2,8) / 'A' /
      DATA KEYFNC(3,8) / 'T' / , KEYFNC(4,8) / 'C' /
      DATA KEYFNC(5,8) / 'H' / , KEYFNC(6,8) / ' ' /
      DATA KEYFNC(7,8) / ' ' / , KEYFNC(8,8) / ' ' /
      DATA KEYFNC(1,9) / 'S' / , KEYFNC(2,9) / 'R' /
      DATA KEYFNC(3,9) / 'Q' / , KEYFNC(4,9) / ' ' /
      DATA KEYFNC(5,9) / ' ' / , KEYFNC(6,9) / ' ' /
      DATA KEYFNC(7,9) / ' ' / , KEYFNC(8,9) / ' ' /
      DATA KEYFNC(1,10) / 'T' / , KEYFNC(2,10) / 'E' /
      DATA KEYFNC(3,10) / 'R' / , KEYFNC(4,10) / 'M' /
      DATA KEYFNC(5,10) / 'I' / , KEYFNC(6,10) / 'N' /
      DATA KEYFNC(7,10) / 'A' / , KEYFNC(8,10) / 'L' /
      DATA KEYFNC(1,11) / 'F' / , KEYFNC(2,11) / 'I' /
      DATA KEYFNC(3,11) / 'L' / , KEYFNC(4,11) / 'E' /
      DATA KEYFNC(5,11) / 'C' / , KEYFNC(6,11) / 'A' /
      DATA KEYFNC(7,11) / 'S' / , KEYFNC(8,11) / 'E' /
      DATA KEYFNC(1,12) / 'M' / , KEYFNC(2,12) / 'E' /
      DATA KEYFNC(3,12) / 'S' / , KEYFNC(4,12) / 'S' /
      DATA KEYFNC(5,12) / 'A' / , KEYFNC(6,12) / 'G' /
      DATA KEYFNC(7,12) / 'E' / , KEYFNC(8,12) / ' ' /
C
      DATA KEYFNC(1,13) / 'P' / , KEYFNC(2,13) / 'R' /
      DATA KEYFNC(3,13) / 'I' / , KEYFNC(4,13) / 'N' /
      DATA KEYFNC(5,13) / 'T' / , KEYFNC(6,13) / 'E' /
      DATA KEYFNC(7,13) / 'R' / , KEYFNC(8,13) / ' ' /
C
      DATA KEYFNC(1,14) / 'G' / , KEYFNC(2,14) / 'E' /
      DATA KEYFNC(3,14) / 'N' / , KEYFNC(4,14) / 'E' /
      DATA KEYFNC(5,14) / 'R' / , KEYFNC(6,14) / 'A' /
      DATA KEYFNC(7,14) / 'T' / , KEYFNC(8,14) / 'E' /
C
      DATA KEYFNC(1,15) / 'O' / , KEYFNC(2,15) / 'P' /
      DATA KEYFNC(3,15) / 'E' / , KEYFNC(4,15) / 'N' /
      DATA KEYFNC(5,15) / 'M' / , KEYFNC(6,15) / 'E' /
      DATA KEYFNC(7,15) / 'S' / , KEYFNC(8,15) / 'S' /
C
      DATA KEYFNC(1,16) / 'P' / , KEYFNC(2,16) / 'A' /
      DATA KEYFNC(3,16) / 'U' / , KEYFNC(4,16) / 'S' /
      DATA KEYFNC(5,16) / 'E' / , KEYFNC(6,16) / ' ' /
      DATA KEYFNC(7,16) / ' ' / , KEYFNC(8,16) / ' ' /
C
      DATA KEYFNC(1,17) / 'E' / , KEYFNC(2,17) / 'X' /
      DATA KEYFNC(3,17) / 'P' / , KEYFNC(4,17) / 'O' /
      DATA KEYFNC(5,17) / 'R' / , KEYFNC(6,17) / 'T' /
      DATA KEYFNC(7,17) / ' ' / , KEYFNC(8,17) / ' ' /
C
      DATA KEYFNC(1,18) / 'U' / , KEYFNC(2,18) / 'E' /
      DATA KEYFNC(3,18) / 'Q' / , KEYFNC(4,18) / 'U' /
      DATA KEYFNC(5,18) / 'I' / , KEYFNC(6,18) / 'V' /
      DATA KEYFNC(7,18) / ' ' / , KEYFNC(8,18) / ' ' /
C
      DATA KEYFNC(1,19) / 'A' / , KEYFNC(2,19) / 'U' /
      DATA KEYFNC(3,19) / 'T' / , KEYFNC(4,19) / 'O' /
      DATA KEYFNC(5,19) / 'U' / , KEYFNC(6,19) / 'P' /
      DATA KEYFNC(7,19) / 'D' / , KEYFNC(8,19) / 'T' /
C
      DATA KEYFNC(1,20) / 'B' / , KEYFNC(2,20) / 'O' /
      DATA KEYFNC(3,20) / 'N' / , KEYFNC(4,20) / 'D' /
      DATA KEYFNC(5,20) / 'T' / , KEYFNC(6,20) / 'Y' /
      DATA KEYFNC(7,20) / 'P' / , KEYFNC(8,20) / 'E' /
C
      DATA KEYFNC(1,21) / 'C' / , KEYFNC(2,21) / 'A' /
      DATA KEYFNC(3,21) / 'C' / , KEYFNC(4,21) / 'H' /
      DATA KEYFNC(5,21) / 'E' / , KEYFNC(6,21) / 'M' /
      DATA KEYFNC(7,21) / 'E' / , KEYFNC(8,21) / 'S' /
C
      DATA KEYFNC(1,22) / 'R' / , KEYFNC(2,22) / 'A' /
      DATA KEYFNC(3,22) / 'T' / , KEYFNC(4,22) / 'I' /
      DATA KEYFNC(5,22) / 'O' / , KEYFNC(6,22) / ' ' /
      DATA KEYFNC(7,22) / ' ' / , KEYFNC(8,22) / ' ' /
C
      DATA KEYVAL(1,1) / 'L' / , KEYVAL(2,1) / 'I' /
      DATA KEYVAL(3,1) / 'S' / , KEYVAL(4,1) / 'T' /
      DATA KEYVAL(1,2) / 'N' / , KEYVAL(2,2) / 'O' /
      DATA KEYVAL(3,2) / 'N' / , KEYVAL(4,2) / 'E' /
      DATA KEYVAL(1,3) / 'C' / , KEYVAL(2,3) / 'O' /
      DATA KEYVAL(3,3) / 'R' / , KEYVAL(4,3) / 'E' /
      DATA KEYVAL(1,4) / 'O' / , KEYVAL(2,4) / 'F' /
      DATA KEYVAL(3,4) / 'F' / , KEYVAL(4,4) / ' ' /
      DATA KEYVAL(1,5) / 'O' / , KEYVAL(2,5) / 'N' /
      DATA KEYVAL(3,5) / ' ' / , KEYVAL(4,5) / ' ' /
      DATA KEYVAL(1,6) / 'S' / , KEYVAL(2,6) / 'L' /
      DATA KEYVAL(3,6) / 'O' / , KEYVAL(4,6) / 'W' /
      DATA KEYVAL(1,7) / 'F' / , KEYVAL(2,7) / 'A' /
      DATA KEYVAL(3,7) / 'S' / , KEYVAL(4,7) / 'T' /
      DATA KEYVAL(1,8) / 'N' / , KEYVAL(2,8) / 'O' /
      DATA KEYVAL(3,8) / 'N' / , KEYVAL(4,8) / 'E' /
      DATA KEYVAL(1,9) / 'R' / , KEYVAL(2,9) / 'E' /
      DATA KEYVAL(3,9) / 'A' / , KEYVAL(4,9) / 'D' /
      DATA KEYVAL(1,10)/ 'W' / , KEYVAL(2,10)/ 'R' /
      DATA KEYVAL(3,10)/ 'I' / , KEYVAL(4,10)/ 'T' /
      DATA KEYVAL(1,11)/ 'B' / , KEYVAL(2,11)/ 'O' /
      DATA KEYVAL(3,11)/ 'T' / , KEYVAL(4,11)/ 'H' /
      DATA KEYVAL(1,12)/ 'U' / , KEYVAL(2,12)/ 'N' /
      DATA KEYVAL(3,12)/ 'K' / , KEYVAL(4,12)/ 'N' /
      DATA KEYVAL(1,13)/ 'V' / , KEYVAL(2,13)/ 'T' /
      DATA KEYVAL(3,13)/ '5' / , KEYVAL(4,13)/ '2' /
      DATA KEYVAL(1,14)/ 'V' / , KEYVAL(2,14)/ 'T' /
      DATA KEYVAL(3,14)/ '1' / , KEYVAL(4,14)/ '0' /
      DATA KEYVAL(1,15)/ 'V' / , KEYVAL(2,15)/ 'G' /
      DATA KEYVAL(3,15)/ 'A' / , KEYVAL(4,15)/ ' ' /
      DATA KEYVAL(1,16)/ 'W' / , KEYVAL(2,16)/ 'I' /
      DATA KEYVAL(3,16)/ 'N' / , KEYVAL(4,16)/ 'D' /
      DATA KEYVAL(1,17)/ 'L' / , KEYVAL(2,17)/ 'O' /
      DATA KEYVAL(3,17)/ 'W' / , KEYVAL(4,17)/ 'E' /
      DATA KEYVAL(1,18)/ 'U' / , KEYVAL(2,18)/ 'P' /
      DATA KEYVAL(3,18)/ 'P' / , KEYVAL(4,18)/ 'E' /
      DATA KEYVAL(1,19)/ 'M' / , KEYVAL(2,19)/ 'I' /
      DATA KEYVAL(3,19)/ 'X' / , KEYVAL(4,19)/ 'E' /
      DATA KEYVAL(1,20)/ 'A' / , KEYVAL(2,20)/ 'R' /
      DATA KEYVAL(3,20)/ 'I' / , KEYVAL(4,20)/ 'T' /
      DATA KEYVAL(1,21)/ 'G' / , KEYVAL(2,21)/ 'E' /
      DATA KEYVAL(3,21)/ 'O' / , KEYVAL(4,21)/ 'M' /
      DATA KEYVAL(1,22)/ 'I' / , KEYVAL(2,22)/ 'O' /
      DATA KEYVAL(3,22)/ ' ' / , KEYVAL(4,22)/ ' ' /
      DATA KEYVAL(1,23)/ 'I' / , KEYVAL(2,23)/ 'C' /
      DATA KEYVAL(3,23)/ ' ' / , KEYVAL(4,23)/ ' ' /

#endif
C
C----- TYPE OF ARGUMENT: 1=KEYWORD, 2=INTEGER
C
      DATA ITPVAL(1)  / 1 / , ITPVAL(2)  / 1 / , ITPVAL(3)  / 1 /
      DATA ITPVAL(4)  / 2 / , ITPVAL(5)  / 1 / , ITPVAL(6)  / 1 /
      DATA ITPVAL(7)  / 1 / , ITPVAL(8)  / 2 / , ITPVAL(9)  / 1 /
      DATA ITPVAL(10) / 1 / , ITPVAL(11) / 1 /
      DATA ITPVAL(12) / 1 / , ITPVAL(13) / 1 / , ITPVAL(14) / 1 /
      DATA ITPVAL(15) / 1 / , ITPVAL(16) / 2 / , ITPVAL(17) / 1 /
      DATA ITPVAL(18) / 1 / , ITPVAL(19) / 1 / , ITPVAL(20) / 1 /
      DATA ITPVAL(21) / 1 / , ITPVAL(22) / 1 /
C
C----- STARTING POSITION IN LIST OF KEYWORDS
C
      DATA ISTVAL(1)  /  1 / , ISTVAL(2)  /  4 / , ISTVAL(3)  /  4 /
      DATA ISTVAL(4)  /  0 / , ISTVAL(5)  /  8 / , ISTVAL(6)  /  6 /
      DATA ISTVAL(7)  /  4 / , ISTVAL(8)  /  0 / , ISTVAL(9)  / 4 /
      DATA ISTVAL(10) /  12 /, ISTVAL(11) / 17 /
      DATA ISTVAL(12) /   4 /, ISTVAL(13) /  4 / , ISTVAL(14) /  4 /
      DATA ISTVAL(15) /   4 /, ISTVAL(16) /  0 / , ISTVAL(17) / 4 /
      DATA ISTVAL(18) /  20 /, ISTVAL(19) /  4 / , ISTVAL(20) /  4 /
      DATA ISTVAL(21) /   4 /, ISTVAL(22) / 22 /
C
C----- NUMBER OF KEYWORDS PERMITTED
C
      DATA NUMVAL(1)  /  3 / , NUMVAL(2)  /  2 / , NUMVAL(3)  /  2 /
      DATA NUMVAL(4)  /  0 / , NUMVAL(5)  /  4 / , NUMVAL(6)  /  2 /
      DATA NUMVAL(7)  /  3 / , NUMVAL(8)  /  0 / , NUMVAL(9)  / 2 /
      DATA NUMVAL(10) /  5/, NUMVAL(11) / 3/
      DATA NUMVAL(12) /  2/, NUMVAL(13) / 2/ , NUMVAL(14)  /  2 /
      DATA NUMVAL(15) /  2/, NUMVAL(16) / 0/ , NUMVAL(17)  /  2 /
      DATA NUMVAL(18) /  2/, NUMVAL(19) /  2/, NUMVAL(20) /  2/
      DATA NUMVAL(21) /  2/, NUMVAL(22) / 2/
C
C----- NUMERIC VALUE CORRESPONDING TO FIRST KEYWORD
C
      DATA IFIRVL(1)  / -1 / , IFIRVL(2)  /  0 / , IFIRVL(3)  /  0 /
      DATA IFIRVL(4)  /  0 / , IFIRVL(5)  /  1 / , IFIRVL(6)  /  1 /
      DATA IFIRVL(7)  /  0 / , IFIRVL(8)  /  0 / , IFIRVL(9) /  0 /
      DATA IFIRVL(10)  /  0 /, IFIRVL(11) / 0 /
      DATA IFIRVL(12)  /  0 /, IFIRVL(13) / -1 / , IFIRVL(14)  /  0 /
      DATA IFIRVL(15)  /  0 /, IFIRVL(16) /0/ , IFIRVL(17) / 0 /
      DATA IFIRVL(18)  /  1 /, IFIRVL(19)  /  0 /, IFIRVL(20)  /  0 /
      DATA IFIRVL(21)  /  0 /, IFIRVL(22) / 0 /
C
C
C
C
      IREQUI = 2
C
C
      IF ( IFNSET .LE. 0 ) THEN
C
C -- IDENTIFY FUNCTION REQUIRED
C
        LENGTH = KRDARG ( IREQUI , 1 )
        IF ( LENGTH .LE. 0 ) GO TO 9910
C
        MATCH = MIN0 ( LENGTH , LUFNC )
        IRQFNC = KCOMP ( MATCH , IMAGE(NC) , KEYFNC , NFNC , LFNC )
        IF ( IRQFNC .LE. 0 ) GO TO 9910
      ELSE
        IRQFNC = IFUNC
      ENDIF
C
C
C
C
      IF ( IVLSET .LE. 0 ) THEN
C
C -- IDENTIFY INPUT VALUE
C
        LENGTH = KRDARG ( IREQUI , 1 )
        IF ( LENGTH .LE. 0 ) GO TO 9930
C
        IF ( ITPVAL(IRQFNC) .EQ. 1 ) THEN
          ISTART = ISTVAL(IRQFNC)
          MATCH = MIN0 ( LENGTH , LVAL )
          IOFFST = KCOMP ( MATCH, IMAGE(NC),
     2 KEYVAL(1,ISTART), NUMVAL(IRQFNC) , LVAL )
          IF ( IOFFST .LE. 0 ) GO TO 9930
          IRQVAL = IFIRVL(IRQFNC) + IOFFST - 1
        ELSE IF ( ITPVAL(IRQFNC) .EQ. 2 ) THEN
          ISTAT = KREADC ( VALUE(1) , 1 )
          IF ( ISTAT .LT. 0 ) GO TO 9930
          IRQVAL = NINT ( VALUE(1) )
        ENDIF
      ELSE
        IRQVAL = IVAL
      ENDIF
C
C
C -- SET VALUE
C
      IF ( IRQFNC .EQ. 1 ) THEN
        MAPS = IRQVAL
      ELSE IF ( IRQFNC .EQ. 2 ) THEN
        ICAT = IRQVAL
        IRDCAT(IFLIND) = IRQVAL
      ELSE IF ( IRQFNC .EQ. 3 ) THEN
        IRDLOG(IFLIND) = IRQVAL
      ELSE IF ( IRQFNC .EQ. 4 ) THEN
        IRDPAG = IRQVAL
      ELSE IF ( IRQFNC .EQ. 5 ) THEN
        ISSLSM = IRQVAL
      ELSE IF ( IRQFNC .EQ. 6 ) THEN
        ISSSPD = IRQVAL
      ELSE IF ( IRQFNC .EQ. 7 ) THEN
        ISSTIM = IRQVAL
      ELSE IF ( IRQFNC .EQ. 8 ) THEN
        ISSLNM = IRQVAL
      ELSE IF ( IRQFNC .EQ. 9 ) THEN
        IMNSRQ = IRQVAL
      ELSE IF ( IRQFNC .EQ. 10 ) THEN
        IF (ISSTML .EQ. 3 ) THEN
C             IF TERMINAL CURRENTLY VGA, SWITCH TO BLACK AND WHITE
C              CALL VGACOL ( 'OFF', 'WHI', 'BLA' )
              CALL OUTCOL(5)
              WRITE ( CMON,'(80X)')
              CALL XPRVDU(NCVDU, 1,0)
        END IF
        ISSTML = IRQVAL
        IF ((ISSTML .EQ. 1) .OR. (ISSTML .EQ. 2)) THEN
C-----  INITIALISE MENU AREAS AND SET TERMINAL TYPE ON VAX/NOVAX SYSTEMS
              CALL XMNINI (IMNFLG)
              IF ( IMNFLG .EQ. 0) ISSTML = 0
              LUPDAT = .FALSE.
        ELSE IF (ISSTML .EQ. 3 ) THEN
C             VGA COLOURS
C              CALL VGACOL ( 'BOL', 'WHI', 'BLU' )
              CALL OUTCOL(1)
              LUPDAT = .FALSE.
        ELSE IF (ISSTML .EQ. 4) THEN
C         WINDOWED OUTPUT
              CALL OUTCOL(1)
              CALL XWININ (IWNFLG)
c              IF (IWNFLG .EQ. 0) THEN
c                  LUPDAT = .FALSE.
c              ELSE
                  LUPDAT = .TRUE.
c              ENDIF
        ELSE
              LUPDAT = .FALSE.
              ISSTML = 0
        END IF
      ELSE IF ( IRQFNC .EQ. 11 ) THEN
        ISSFLC = IRQVAL
      ELSE IF ( IRQFNC .EQ. 12 ) THEN
        ISSMSG = IRQVAL
      ELSE IF ( IRQFNC .EQ. 13 ) THEN
        ISSPRT = IRQVAL
      ELSE IF ( IRQFNC .EQ. 14 ) THEN
        ISSGEN = IRQVAL
      ELSE IF ( IRQFNC .EQ. 15 ) THEN
        ISSFLM = IRQVAL
      ELSE IF ( IRQFNC .EQ. 16 ) THEN
        ISSPAS = IRQVAL
      ELSE IF ( IRQFNC .EQ. 17 ) THEN
        ISSEXP = IRQVAL
      ELSE IF ( IRQFNC .EQ. 18 ) THEN
        ISSUEQ = IRQVAL
      ELSE IF ( IRQFNC .EQ. 19 ) THEN
        ISSUPD = IRQVAL
      ELSE IF ( IRQFNC .EQ. 20 ) THEN
        ISSBND = IRQVAL
      ELSE IF ( IRQFNC .EQ. 21 ) THEN
        ISSCSH = IRQVAL
      ELSE IF ( IRQFNC .EQ. 22 ) THEN
        ISSRAT = IRQVAL
      ELSE
        GO TO 9920
      ENDIF
C
C
9000  CONTINUE
C
      RETURN
C
C
9900  CONTINUE
C -- ERRORS DURING 'SET' INSTRUCTION
      CALL XERHND ( IERWRN )
      GO TO 9000
9910  CONTINUE
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 2,0)
9915  FORMAT ( 1X , 'Illegal or missing keyword in SET instruction' /
     1 1X , 'The following keywords are allowed :-' )
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
      IF ( NFNC .GT. 0 ) THEN
        NCOL = 7
        NITEM = NFNC
        NROW = (NITEM+NCOL-1) / NCOL
        NBLOCK = (NROW +LINBUF-1) / LINBUF
        NSTART = 1
        NEND = 0
        DO 97531 I975 = 1, NBLOCK
        NEND = MIN (NITEM, (NCOL*LINBUF+NSTART-1))
        NROW = (NEND-NSTART+NCOL) / NCOL
          WRITE ( CMON,9917)
     1    ((KEYFNC(JCMON,ICMON),JCMON=1,LFNC),ICMON=NSTART,NEND)
          CALL XPRVDU(NCEROR, NROW,0)
        NSTART = NEND+1
97531 CONTINUE
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9917 ) KEYFNC
9917    FORMAT ( 7(2X , 8A1 ))
      ENDIF
      GO TO 9900
9920  CONTINUE
      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
      GO TO 9900
9930  CONTINUE
        WRITE ( CMON,9935)
        CALL XPRVDU(NCEROR, 2,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9935 )
9935  FORMAT ( 1X , 'Illegal or missing value in SET instruction'/
     1 1X , 'The following values are allowed :-' )
      IF ( ITPVAL(IRQFNC) .EQ. 1 ) THEN
        ISTART = ISTVAL(IRQFNC)
        IEND = ISTART + NUMVAL(IRQFNC) - 1
        NCOL = 6
        NITEM = IEND - ISTART + 1
        NROW = (NITEM+NCOL-1) / NCOL
        NBLOCK = (NROW +LINBUF-1) / LINBUF
        NSTART = 1
        NEND = 0
        DO 97532 I975 = 1, NBLOCK
          NEND = MIN (NITEM, (NCOL*LINBUF+NSTART-1))
          NROW = (NEND-NSTART+NCOL) / NCOL
          WRITE(CMON,9937)
     1    ( (KEYVAL(I,J+ISTART-1),I=1,4),J=NSTART,NEND)
          CALL XPRVDU(NCEROR, NROW,0)
          NSTART = NEND+1
97532   CONTINUE
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 9937 ) ((KEYVAL(I,J),I=1,4),J=ISTART,IEND)
      ENDIF
9937    FORMAT ( 6(2X , 4A1 ))
      ELSE IF ( ITPVAL(IRQFNC) .EQ. 2 ) THEN
        WRITE ( CMON,9942)
        CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 9942 )
      ENDIF
9942    FORMAT ( 1X , 'This instruction requires an integer value' )
      ENDIF
      GO TO 9900
C
      END
C
C
C
C
C
CODE FOR XRDATT
      SUBROUTINE XRDATT
C -- PROCESS 'ATTACH' INSTRUCTION
C
C
      DIMENSION XUNIT(1)
C
      DIMENSION KEYACC(4,2)
      DIMENSION KEYSTA(4,5)
      DIMENSION KEYFRM(4,2)
      DIMENSION KEYWRI(4,2)
      DIMENSION KEYLCK(4,2)
C
C
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
C
C
      DATA MCHNAM / 4 / , LNAM / 8 /
C
      DATA LACC / 4 / , NACC / 2 /
C
C                  SEQU        DIRE
C

#ifdef _HOL_
      DATA KEYACC(1,1) / 1HS / , KEYACC(2,1) / 1HE /
      DATA KEYACC(3,1) / 1HQ / , KEYACC(4,1) / 1HU /
      DATA KEYACC(1,2) / 1HD / , KEYACC(2,2) / 1HI /
      DATA KEYACC(3,2) / 1HR / , KEYACC(4,2) / 1HE /
#else
      DATA KEYACC(1,1) / 'S' / , KEYACC(2,1) / 'E' /
      DATA KEYACC(3,1) / 'Q' / , KEYACC(4,1) / 'U' /
      DATA KEYACC(1,2) / 'D' / , KEYACC(2,2) / 'I' /
      DATA KEYACC(3,2) / 'R' / , KEYACC(4,2) / 'E' /
#endif
C
      DATA LSTA / 4 / , NSTA / 5 /
C
C     OLD   NEW   CIF   SCRA    UNKN
C
#ifdef _HOL_
      DATA KEYSTA(1,1) / 1HO / , KEYSTA(2,1) / 1HL /
      DATA KEYSTA(3,1) / 1HD / , KEYSTA(4,1) / 1H  /
      DATA KEYSTA(1,2) / 1HN / , KEYSTA(2,2) / 1HE /
      DATA KEYSTA(3,2) / 1HW / , KEYSTA(4,2) / 1H  /
      DATA KEYSTA(1,3) / 1HC / , KEYSTA(2,3) / 1HI /
      DATA KEYSTA(3,3) / 1HF / , KEYSTA(4,3) / 1H  /
      DATA KEYSTA(1,4) / 1HS / , KEYSTA(2,4) / 1HC /
      DATA KEYSTA(3,4) / 1HR / , KEYSTA(4,4) / 1HA /
      DATA KEYSTA(1,5) / 1HU / , KEYSTA(2,5) / 1HN /
      DATA KEYSTA(3,5) / 1HK / , KEYSTA(4,5) / 1HN /
#else
      DATA KEYSTA(1,1) / 'O' / , KEYSTA(2,1) / 'L' /
      DATA KEYSTA(3,1) / 'D' / , KEYSTA(4,1) / ' ' /
      DATA KEYSTA(1,2) / 'N' / , KEYSTA(2,2) / 'E' /
      DATA KEYSTA(3,2) / 'W' / , KEYSTA(4,2) / ' ' /
      DATA KEYSTA(1,3) / 'C' / , KEYSTA(2,3) / 'I' /
      DATA KEYSTA(3,3) / 'F' / , KEYSTA(4,3) / ' ' /
      DATA KEYSTA(1,4) / 'S' / , KEYSTA(2,4) / 'C' /
      DATA KEYSTA(3,4) / 'R' / , KEYSTA(4,4) / 'A' /
      DATA KEYSTA(1,5) / 'U' / , KEYSTA(2,5) / 'N' /
      DATA KEYSTA(3,5) / 'K' / , KEYSTA(4,5) / 'N' /
#endif
C
      DATA LFRM / 4 / , NFRM / 2 /
C
C                  FORM        UNFO
C
#ifdef _HOL_
      DATA KEYFRM(1,1) / 1HF / , KEYFRM(2,1) / 1HO /
      DATA KEYFRM(3,1) / 1HR / , KEYFRM(4,1) / 1HM /
      DATA KEYFRM(1,2) / 1HU / , KEYFRM(2,2) / 1HN /
      DATA KEYFRM(3,2) / 1HF / , KEYFRM(4,2) / 1HO /
#else
      DATA KEYFRM(1,1) / 'F' / , KEYFRM(2,1) / 'O' /
      DATA KEYFRM(3,1) / 'R' / , KEYFRM(4,1) / 'M' /
      DATA KEYFRM(1,2) / 'U' / , KEYFRM(2,2) / 'N' /
      DATA KEYFRM(3,2) / 'F' / , KEYFRM(4,2) / 'O' /
#endif
C
      DATA LWRI / 4 / , NWRI / 2 /
C
C                  READ        WRIT
C
#ifdef _HOL_
      DATA KEYWRI(1,1) / 1HR / , KEYWRI(2,1) / 1HE /
      DATA KEYWRI(3,1) / 1HA / , KEYWRI(4,1) / 1HD /
      DATA KEYWRI(1,2) / 1HW / , KEYWRI(2,2) / 1HR /
      DATA KEYWRI(3,2) / 1HI / , KEYWRI(4,2) / 1HT /
#else
      DATA KEYWRI(1,1) / 'R' / , KEYWRI(2,1) / 'E' /
      DATA KEYWRI(3,1) / 'A' / , KEYWRI(4,1) / 'D' /
      DATA KEYWRI(1,2) / 'W' / , KEYWRI(2,2) / 'R' /
      DATA KEYWRI(3,2) / 'I' / , KEYWRI(4,2) / 'T' /
#endif
C
      DATA LLCK / 4 / , NLCK / 2 /
C
C                  FREE        LOCK
C
#ifdef _HOL_
      DATA KEYLCK(1,1) / 1HF / , KEYLCK(2,1) / 1HR /
      DATA KEYLCK(3,1) / 1HE / , KEYLCK(4,1) / 1HE /
      DATA KEYLCK(1,2) / 1HL / , KEYLCK(2,2) / 1HO /
      DATA KEYLCK(3,2) / 1HC / , KEYLCK(4,2) / 1HK /
#else
      DATA KEYLCK(1,1) / 'F' / , KEYLCK(2,1) / 'R' /
      DATA KEYLCK(3,1) / 'E' / , KEYLCK(4,1) / 'E' /
      DATA KEYLCK(1,2) / 'L' / , KEYLCK(2,2) / 'O' /
      DATA KEYLCK(3,2) / 'C' / , KEYLCK(4,2) / 'K' /
#endif
C
C
C
C
C -- IDENTIFY ARGUMENTS
C
      IREQUI = 7
      LENGTH = KRDARG ( IREQUI , 1 )
      IF ( LENGTH .LE. 0 ) GO TO 9900
C
      ISTAT = KREADC ( XUNIT , 1 )
      IF ( ISTAT .LT. 0 ) GO TO 9910
C
      IUNIT = NINT ( XUNIT(1) )
C
      LENNAM = KRDARG ( IREQUI , 1 )
      IF ( LENNAM .LE. 0 ) GO TO 9900
      NCNAM = NC
C
      LENACC = KRDARG ( IREQUI , 1 )
      IF ( LENACC .LE. 0 ) GO TO 9900
      NCACC = NC
C
      LENSTA = KRDARG ( IREQUI , 1 )
      IF ( LENSTA .LE. 0 ) GO TO 9900
      NCSTA = NC
C
      LENFRM = KRDARG ( IREQUI , 1 )
      IF ( LENFRM .LE. 0 ) GO TO 9900
      NCFRM = NC
C
      LENWRI = KRDARG ( IREQUI , 1 )
      IF ( LENWRI .LE. 0 ) GO TO 9900
      NCWRI = NC
C
      LENLCK = KRDARG ( IREQUI , 1 )
      IF ( LENLCK .LE. 0 ) GO TO 9900
      NCLCK = NC
C
C
C
      N = MIN0 ( LENACC , LACC )
      IACCSS = KCOMP ( N , IMAGE(NCACC) , KEYACC , NACC , LACC )
      IF ( IACCSS .LE. 0 ) GO TO 9910
C
      N = MIN0 ( LENSTA , LSTA )
      ISTTUS = KCOMP ( N , IMAGE(NCSTA) , KEYSTA , NSTA , LSTA )
      IF ( ISTTUS .LE. 0 ) GO TO 9910
C
      N = MIN0 ( LENFRM , LFRM )
      IFORMT = KCOMP ( N , IMAGE(NCFRM) , KEYFRM , NFRM , LFRM )
      IF ( IFORMT .LE. 0 ) GO TO 9910
C
      N = MIN0 ( LENWRI , LWRI )
      IRDWRI = KCOMP ( N , IMAGE(NCWRI) , KEYWRI , NWRI , LWRI )
      IF ( IRDWRI .LE. 0 ) GO TO 9910
C
      N = MIN0 ( LENLCK , LLCK )
      ILOCK  = KCOMP ( N , IMAGE(NCLCK) , KEYLCK , NLCK , LLCK )
      IF ( ILOCK  .LE. 0 ) GO TO 9910
C
C
      IDEV = 0
      IF ( NFLUSD .GT. 0 ) THEN
        N = MIN0 ( LENNAM , MCHNAM )
        IDEV = KCOMP ( N , IMAGE(NCNAM) , KEYFIL , NFLUSD , LNAM )
        IF ( ( IDEV .GT. 0 ) .AND. ( ISSINI .LE. 0 ) ) GO TO 9920
      ENDIF
C
      IF ( IDEV .LE. 0 ) THEN
        NFLUSD = NFLUSD + 1
        IDEV = NFLUSD
      ENDIF
C
      IF (IDEV .GT. NFLMAX ) GOTO 9930

      CALL XFILL ( IB , KEYFIL(1,IDEV) , LNAM )
      N = MIN0 ( LENNAM , LNAM )
      CALL XMOVE ( IMAGE(NCNAM) , KEYFIL(1,IDEV) , N )
      IFLUNI(IDEV) = IUNIT
      IFLACC(IDEV) = IACCSS
      IFLSTA(IDEV) = ISTTUS
      IFLFRM(IDEV) = IFORMT
      IFLREA(IDEV) = IRDWRI
      IFLLCK(IDEV) = ILOCK
      IFLOPN(IDEV) = -1
C
C
C
C
9000  CONTINUE
      RETURN
C
9900  CONTINUE
      GO TO 9000

9910  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
9915  FORMAT(1X,'Illegal parameter for this instruction' )
      GO TO 9900

9920  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9925)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9925 )
9925  FORMAT ( 1X , 'Repeated name in ATTACH command' )
      GO TO 9900

9930  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9935)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9935 )
9935  FORMAT ( 1X , 'No spare file UNITS for ATTACH command' )
      GO TO 9900
C
      END
C
C
C
C
CODE FOR XRDOPN
      SUBROUTINE XRDOPN ( JFUNC , JDEV, CFILE, LFILE)
C -- PROCESS SYSTEM INSTRUCTIONS WHICH PERFORM OPERATIONS ON CRYSTALS
C    'DEVICES'.
cdjwmar99
c      Add APPEND function. This implies OPEN
C
C
C      INPUT :-
C
C            JFUNC       OPEN FUNCTION REQUIRED
C                          1      IMPLEMENT 'RELEASE' INSTRUCTION
C                          2      IMPLEMENT 'OPEN' INSTRUCTION
C                          3      IMPLEMENT 'CLOSE' INSTRUCTION
c                          4      IMPLEMENT 'APPEND' INSTRUCTION
C
C                        EQUIVALENT 'INTERNAL' CALLS
C                          5      RELEASE SPECIFIED FILE AND DEVICE
C                          6      OPEN SPECIFIED FILE AND DEVICE
C                          7      CLOSE SPECIFIED FILE AND DEVICE
C                          8      APPEND TO SPECIFIED FILE AND DEVICE
C
C            JDEV                 DEVICE
C            CFILE,LFILE          FILE NAME AND LENGTH
C
C
      LOGICAL LEXIST, LOPEN, LNAMED
      CHARACTER *(*) CFILE
      PARAMETER (LNMMAX = 256)
      CHARACTER *(LNMMAX)  OLDFIL, NEWFIL, INQFIL
C
CDJWMAR99
C      PARAMETER ( MAXFNC = 3 )
      PARAMETER ( MAXFNC = 4 )
C
      CHARACTER*16 COPER(MAXFNC)
      CHARACTER*8 CRESLT(MAXFNC) , CACTN(MAXFNC)
      CHARACTER*7 CINSTR(MAXFNC)
      DIMENSION   IRQARG(MAXFNC)
C
      DIMENSION JDEV(4)
C
      INCLUDE 'TSSCHR.INC'
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'XIOBUF.INC'
      DATA COPER / ' output sent to ', ' connected to ', 'closed', 
     1 ' appended to '/
      DATA CRESLT / 'released' , 'opened  ' , 'closed  '
     1 , 'appended' /
      DATA CACTN  / 'releases' , ' opens  ' , ' closes ', 
     1 'appends ' /
      DATA CINSTR / 'RELEASE' , 'OPEN   ' , 'CLOSE  ' , 'APPEND '/
C
      DATA IRQARG / 2 , 2 , 1, 2  /
CDJWMAR99]
C
      DATA MCHNAM / 4 / , LNAM / 8 /
C
CDJWMAR99 - SET APPEND OFF
            IAPPND = 0
C----- MAKE INTERNAL CALL LOOK LIKE AN EXTERNAL
      IF (JFUNC .GT. MAXFNC) THEN
        IFUNC = JFUNC - MAXFNC
      ELSE
        IFUNC = JFUNC
      ENDIF
CDJWMAR99[
C      A TEMPORARY BODGE TO TEST THE THE IDEA
      KFUNC = IFUNC
      IF (IFUNC .EQ. 4) THEN
            IFUNC = 2
            IAPPND = ISSAPP
      ENDIF
CDJWMAR99]
C
C -- CHECK PARAMETERS TO THE ROUTINE
      IF ((IFUNC .LE. 0 ) .OR. ( IFUNC .GT. MAXFNC ) ) GO TO 9920
      IF (LFILE .GT. LNMMAX) GOTO 9930
C -- IDENTIFY FIRST INPUT ARGUMENT ( DEVICE NAME )
C
      IF (JFUNC .LE. MAXFNC) THEN
        IREQUI = IRQARG(IFUNC)
        LENGTH = KRDARG ( IREQUI , 2 )
        IF ( LENGTH .LE. 0 ) GO TO 9910
      ENDIF
C
C -- IDENTIFY THE DEVICE THE USER WANTS, AND FIND ITS CHARACTERISTICS
C
      IF ( NFLUSD .LE. 0 ) GO TO 9910
      IF (JFUNC .LE. MAXFNC) THEN
        N = MIN0 ( MCHNAM , LENGTH )
        IFIND = KCOMP ( N , IMAGE(NC) , KEYFIL , NFLUSD , LNAM )
      ELSE
        IFIND = KCOMP ( MCHNAM , JDEV(1) , KEYFIL , NFLUSD , LNAM )
      ENDIF
      IF ( IFIND .LE. 0 ) GO TO 9910
C
C -- NOTE: FILES ARE NOT LOCKED DURING INITIALISATION
C
      IDEV   = IFLUNI(IFIND)
      IACCSS = IFLACC(IFIND)
      ISTTUS = IFLSTA(IFIND)
      IFORMT = IFLFRM(IFIND)
      IRDWRI = IFLREA(IFIND)
      ILOCK  = IFLLCK(IFIND)
      IF ( ISSINI .GT. 0 ) ILOCK = 1
      IOPEN  = IFLOPN(IFIND)
C
C -- CHECK THAT THE OPERATION MAY BE PERFORMED ON THIS DEVICE
C
      IF ( ILOCK .EQ. 2 ) GO TO 9960
C
C
      IF ( IFUNC .EQ. 1 ) THEN
        IF ( IACCSS .NE. 1 ) GO TO 9950
        IF ( ( ISTTUS .EQ. ISSOLD ) .OR. ( ISTTUS .EQ. ISSSCR ) )
     1 GO TO 9950
        IF ( IRDWRI .NE. 2 ) GO TO 9950
        IF ( ILOCK .EQ. 2 ) GO TO 9960
      ELSE IF ( IFUNC .EQ. 2 ) THEN
        IF ( ILOCK .EQ. 2 ) GO TO 9960
      ENDIF
CDJWMAR99
C----- CHECK THAT APPEND TYPE FILES ARE SET FOR WRITING
      IRWOPN = IRDWRI
      IF (IAPPND .EQ. ISSAPP) THEN
       IF (IRDWRI .NE. 2) GOTO 9950
       IRWOPN = IAPPND
      ENDIF
C----- GET THE OLDFILE NAME IF IT IS NAMED
      INQUIRE (UNIT=IDEV, IOSTAT=IOS, ERR=9000, EXIST=LEXIST,
     1  OPENED=LOPEN, NUMBER=INUMB, NAMED=LNAMED, NAME=INQFIL)
C----- SAVE OLDNAME IF IT EXISTS
      IF (LNAMED .EQV. .TRUE.) THEN
            OLDFIL = INQFIL
      ELSE
            OLDFIL = ' '
      ENDIF
C
C -- EXPLICIT CLOSE OF OLD FILE FOR CLOSE OR RELEASE
C
      IF (  IFUNC .NE. 2 ) THEN
        IF ( LEXIST .NEQV. .TRUE. ) GOTO 9960
        IF ( OLDFIL .NE. ' ' ) THEN
          LENNAM = INDEX ( OLDFIL//' ' , ' ' ) - 1
          IF (LENNAM .GT. 0) THEN
            IF (( ISSFLM .GT. 0 ) .AND. ( JFUNC .LE. MAXFNC)) THEN
             WRITE ( CMON,2340)
     1       CSSPRG(1:LSSPRG), CACTN(kFUNC), OLDFIL(1:LENNAM)
             CALL XPRVDU(NCVDU, 1,0)
2340          FORMAT ( 1X , A , ' ' , A , ' ' , A )

cdjwsep2011
             IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
              IDJW = MIN(8,LSSPRG)
              WRITE(NCWU,1007)  CSSPRG(1:IDJW), CACTN(kFUNC),
     2                         IDEV, OLDFIL(1:LENNAM)
1007    FORMAT('READ      ', A,A,           T38, ': Unit =',I8,1X,A)
             ENDIF
            ENDIF
          ENDIF
        ENDIF
        ISTAT = KFLCLS ( IDEV )
      ELSE
        IF ( IACCSS .EQ. 2 ) THEN
          IF ( ISSINI .LE. 0 ) THEN
            GO TO 9960
          ENDIF
        ENDIF
      ENDIF
C
C -- WE CAN NOW MARK THE FILE AS CLOSED
C
      IFLOPN(IFIND) = 0
C
C -- PROCESSING FINISHED FOR 'CLOSE'
C
      IF ( IFUNC .EQ. 3 ) GO TO 9010
C
C
C -- READ NEW FILENAME IF ANY, AND PREPARE TO OPEN NEW FILE
C
      NEWFIL = ' '
      IF (JFUNC .LE. MAXFNC) THEN
        LENGTH = KRDARG ( IREQUI , 2 )
      ELSE
        LENGTH = LFILE
      ENDIF
      IF ( LENGTH .GT. 0 ) THEN
        IF (JFUNC .LE. MAXFNC) THEN
          CALL XFLPCK ( LCMAGE(NC) , LENGTH, ' ', ' ', NEWFIL, LENNAM)
        ELSE
          LENNAM = LFILE
          NEWFIL = CFILE(1:LENNAM)
        ENDIF
C -- IF A NAME HAS BEEN GIVEN EXPLICITLY, AND THE FILE IS CURRENTLY A
C    SCRATCH FILE, CHANGE STATUS TO 'UNKNOWN'
        IF ( ISTTUS .EQ. ISSSCR ) THEN
          IFLSTA(IFIND) = ISSUNK
          ISTTUS = ISSUNK
        ENDIF
      ENDIF
C
C -- OPEN THE NEW FILE
C
C
      IF ( IACCSS .EQ. 1 ) THEN
C----- GENERATE NAME IF NECESSARY - NOT FOR D/A FILES
       IF (ISSGEN .GE. 1)
     1   CALL XGENNM ( IDEV, NEWFIL, OLDFIL, IRDWRI, ISTTUS )
       ISTAT = KFLOPN ( IDEV, NEWFIL, ISTTUS, IRWOPN, IFORMT, ISSSEQ )
       IF ( ISTAT .LE. 0 ) GO TO 9980
      ELSE IF ( IACCSS .EQ. 2 ) THEN
       ISTAT = KDAOPN ( IDEV , NEWFIL , ISTTUS , IRDWRI )
       IF ( ISTAT .LT. 0 ) GO TO 9980
      ENDIF
C

      I = KFLNAM ( IDEV , NEWFIL )
      IF ( I .LE. 0 ) GO TO 9900
C
C      LENNAM = INDEX ( NEWFIL//' ' , ' ' ) - 1
       LENNAM = MAX(1,KCLNEQ ( NEWFIL, -1, ' ' ))
C
CDJWMAR99[
C----- WRITE A SINGLE SPACE FOR NULL FILE NAMES
      IF (LENNAM .EQ. 0) LENNAM = 1
      IF (( ISSFLM .GT. 0 ) .AND. ( JFUNC .LE. MAXFNC)) THEN
        WRITE ( CMON,2345) (KEYFIL(I,IFIND),I=1,LNAM),
     2                          COPER(KFUNC), NEWFIL(1:LENNAM)
2345    FORMAT ( 1X , 8A1 , 1X , A , 1X , A )
        CALL XPRVDU(NCVDU, 1,0)
cdjwsep2011
       IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .GE. 1)) THEN
        WRITE(NCWU,1006)  (KEYFIL(I,IFIND),I=1,LNAM),
     2    COPER(KFUNC),  idev,NEWFIL(:LENNAM)
1006    FORMAT('READ      ', 8A1,A,           T38, ': Unit =',I8,1X,A)
       ENDIF
      ENDIF
CRICFEB01[
2346    FORMAT ( '^^CO SAFESET [ ', A , ' TEXT ''', A , ''' ]' )
#ifdef CRY_GUI
      IF ( IDEV .EQ. NCPU ) THEN
        WRITE ( CMON,2346) '_MT_PCH', NEWFIL(1:LENNAM)
        CALL XPRVDU ( NCVDU, 1, 0 )
      ELSE IF ( IDEV .EQ. NCWU ) THEN
        WRITE ( CMON,2346) '_MT_LIS', NEWFIL(1:LENNAM)
        CALL XPRVDU ( NCVDU, 1, 0 )
      ELSE IF ( IDEV .EQ. NCLU ) THEN
        WRITE ( CMON,2346) '_MT_LOG', NEWFIL(1:LENNAM)
        CALL XPRVDU ( NCVDU, 1, 0 )
      ENDIF
CRICFEB01]
CDJWMAR99]
C
C
#endif
      IFLOPN(IFIND) = 1
      GOTO 9010
C
C
9000  CONTINUE
      IERFLG = -1
9010  CONTINUE
      RETURN
C
C
C
C
CDJWMAR99[
9900  CONTINUE
CDJWMAR99[
      IF (JFUNC .GT. MAXFNC) THEN
       CALL XCTRIM( CFILE, NCHARS )
       WRITE(CMON,
     1 '('' Internal file handling - '', I4,2X,4A1,2X,A,2X,I4)') 
     2 JFUNC , JDEV, CFILE(1:NCHARS), NCHARS
      CALL XPRVDU(NCVDU, 1,0)
      ENDIF
      WRITE ( CMON,9905) CCRCHR(1:2), IH , CINSTR(kFUNC)
      CALL XPRVDU(NCVDU, 2,0)
9905  FORMAT ( 1X , 'The correct format for this instruction is :-' ,/
     2 11X , A1 , A , ' devicename [ filename ] ' )
      IF ( NFLUSD .GT. 0 ) THEN
      WRITE ( CMON,9906)
      CALL XPRVDU(NCVDU, 1,0)
9906    FORMAT ( 1X , 'The following device names are known :-' )
        NCOL = 5
        NITEM = NFLUSD
        NROW = (NITEM+NCOL-1) / NCOL
        NBLOCK = (NROW +LINBUF-1) / LINBUF
        NSTART = 1
        NEND = 0
        DO 97531 I975 = 1, NBLOCK
          NEND = MIN (NITEM, (NCOL*LINBUF+NSTART-1))
          NROW = (NEND-NSTART+NCOL) / NCOL
          WRITE ( CMON,9907) ((KEYFIL(J,I),J=1,LNAM),
     1    I= NSTART,NEND)
          CALL XPRVDU(NCVDU, NROW, 0)
          NSTART = NEND+1
97531   CONTINUE
9907    FORMAT ( 5( 2X , 8A1 ) )
        WRITE ( CMON,9908) CRESLT(kFUNC)
        CALL XPRVDU(NCVDU, 1,0)
9908    FORMAT ( 1X , 'NOTE not all devices may be ' , A )
      ENDIF
CDJWMAR99]
      GO TO 9000
9910  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
9915  FORMAT(1X,'Illegal or missing parameter for this Instruction' )
      GO TO 9900
9920  CONTINUE
CDJWMAR99[
      WRITE ( CMON,9925) kFUNC
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9925 ) kFUNC
9925  FORMAT ( 1X , 'Illegal value supplied to routine' , I10 )
      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
CDJWMAR99]
      GO TO 9900
9930  CONTINUE
      CALL XCTRIM( CFILE, NCHARS )
      WRITE ( CMON,9935) CFILE(1:NCHARS), LNMMAX
      CALL XPRVDU(NCEROR, 3,0)
      IF (ISSPRT .EQ. 0) THEN
        WRITE(NCWU,9935) CFILE, LNMMAX
      ENDIF
9935  FORMAT(1X, ' The filename  ',/, A, /,
     1 ' is too long. Maximum is ', I5, ' characters',/)
      GOTO 9000
9950  CONTINUE
CDJWMAR99[
      CALL XMONTR ( 0 )
      WRITE ( CMON,9955) CRESLT(kFUNC)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9955 ) CRESLT(kFUNC)
      ENDIF
9955  FORMAT ( 1X , 'Only WRITEABLE SEQUENTIAL files may be ' , A )
      GO TO 9000
9960  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9965) CRESLT(kFUNC)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9965 ) CRESLT(kFUNC)
      ENDIF
9965  FORMAT ( 1X , 'The specified file may not be ' , A )
      GO TO 9000
9970  CONTINUE
      CALL XMONTR ( 0 )
      WRITE ( CMON,9975) CRESLT(kFUNC)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9975 ) CRESLT(kFUNC)
      ENDIF
9975  FORMAT ( 1X , 'A name may not be specified when DIRECT ACCESS' ,
     2 ' files are ' , A )
      GO TO 9000
9980  CONTINUE
      CALL XMONTR ( 0 )
      CALL XCTRIM( NEWFIL, NCHARS )
      WRITE ( CMON,9985)
     1 NEWFIL(1:NCHARS), ( KEYFIL(J,IFIND) , J = 1 , LNAM )
      CALL XPRVDU(NCEROR, 2,0)
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9985 ) 
     1 NEWFIL(1:NCHARS), ( KEYFIL(J,IFIND) , J = 1 , LNAM )
      ENDIF
9985  FORMAT ( 1X , 'Error opening ' , A ,/ ' on ', 8A1 )
      CALL XERIOM ( IDEV , ISTAT )
      CALL XERHND ( IERERR )
      GO TO 9000
C
C
      END
C
C
C
C
CODE FOR XRDSTA
      SUBROUTINE XRDSTA
C
C -- IMPLEMENTS 'START' INSTRUCTION
C
      DIMENSION KEYFNC(6)
      DIMENSION ID50(2), IMATCH(1)
C
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      DATA LFNC / 1 / , NFNC / 6 /
      DATA LPACK / 4 /
C
C      ENVI(RONMENT) ERRO(R)   MESS(AGE)   DISC        SPY
C      INDE(X)
C
#ifdef _HOL_
      DATA KEYFNC / 4HENVI , 4HERRO , 4HMESS , 4HDISC , 4HSPY  ,
     2 4HINDE /
#else
      DATA KEYFNC / 'ENVI' , 'ERRO' , 'MESS' , 'DISC' , 'SPY ' ,
     2 'INDE' /
#endif
C
C
C
C
      IREQUI = 1
      IOPT = 1
C
      LENGTH = KRDARG ( IREQUI , IOPT )
      IF ( LENGTH .LE. 0 ) GO TO 9910
C
      MOVE = MIN0 ( LENGTH , LPACK )
      CALL XFA4CS ( IMAGE(NC) , IMATCH(1) , MOVE )
C
      IRQFNC = KCOMP ( 1 , IMATCH , KEYFNC , NFNC , LFNC )
      IF ( IRQFNC .LE. 0 ) GO TO 9910
C
C
C
      IF ( IRQFNC .EQ. 1 ) THEN
        CALL XQUEN
      ELSE IF ( IRQFNC .EQ. 2 ) THEN
        CALL XERINI
      ELSE IF ( IRQFNC .EQ. 3 ) THEN
        CALL XSYINI
      ELSE IF ( IRQFNC .EQ. 4 ) THEN
        CALL XSYSDC ( -1 , -1 )
      ELSE IF ( IRQFNC .EQ. 5 ) THEN
        CALL XSPY ( 1 )
      ELSE IF ( IRQFNC .EQ. 6 ) THEN
        CALL XSYSDC(-1,0)
C -- CHANGE TO INSTRUCTION DISC
        KA = KSWPDU ( NCIFU )
C -- LOAD THE INDICES
        CALL XLOADF
        CALL XLOADL
C -- READ THE DETAILS OF LIST 50
        LN50 = 50
        ISTAT = KRCLI(LN50,LSN50,NFW50,NLW50,IOWF50,NOS50,ID50(1))
C -- SWOP BACK TO THE DATA DISC
        N = KSWPDU ( KA )
C -- RELOAD ITS INDICES
        CALL XLOADF
        CALL XLOADL
C -- WRITE THE INDEX DATA FOR LIST 50 INTO THIS INDEX
        CALL XWCLI(LN50,LSN50,NFW50,NLW50,IOWF50,NOS50,ID50(1))
C -- LOAD DIRECT ACCESS FILE CONTROL INFORMATION
        CALL XDAEXC
      ENDIF
C
C
C
9000  CONTINUE
C
      RETURN
C
C
9900  CONTINUE
C -- ERRORS DURING 'START' INSTRUCTION
      CALL XERHND ( IERWRN )
      GO TO 9000
9910  CONTINUE
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
9915  FORMAT ( 1X , 'Illegal or missing keyword in START instruction' )
      GO TO 9900
C
      END
C
C
C
C
C
CODE FOR XRDSTR
      SUBROUTINE XRDSTR
C
C -- IMPLEMENTS 'STORE' INSTRUCTION
C
C
C -- THE FOLLOWING VARIABLES DEFINE THE COMMON BLOCKS THAT CAN BE
C    ACCESSED WITH THIS ROUTINE
C
C      CBLOCK      EXTERNAL NAMES OF COMMON BLOCK
C      LADDR       ADDRESS IN 'KEYADR' OF FIRST ADDRESS NAME FOR THIS
C                  COMMON BLOCK
C      NADDR       NUMBER OF ADDRESS NAMES IN 'KEYADR' FOR THIS COMMON
C                  BLOCK
C      MAXADR      MAXIMUM ADDRESS IN THIS COMMON BLOCK
C      IBLKTP      TYPE OF DATA FOR THIS COMMON BLOCK
C                    JNUMER      NUMERIC DATA ( INTEGER/REAL/HOLLERITH )
C                    JCHAR       CHARACTER DATA ( CHARACTER*(N) )
C
C -- THE FOLLOWING VARIABLE DEFINE THE 'ADDRESS NAMES' AVAILABLE
C
C      CADDR       ADDRESS NAMES
C      ITRADR      TRANSLATIONS OF ADDRESS NAMES
C      ITRAD2      SECONDARY TRANSLATIONS OF ADDRESS NAMES
C      ITRLEN      LENGTH OF CORRESPONDING DATA ITEM
C
      PARAMETER ( LBLK = 1 , NBLK = 9 )
      DIMENSION LADDR(NBLK) , NADDR(NBLK) , MAXADR(NBLK) , IBLKTP(NBLK)
      CHARACTER*4 CBLOCK(NBLK)
C
      PARAMETER ( JNUMER = 1 , JCHAR = 2 )
C
cdjwmay99
cRICjul99
      PARAMETER ( LADR = 1, NADR = 70)
      DIMENSION ITRADR(NADR) , ITRAD2(NADR) , ITRLEN(NADR)
      CHARACTER*4 CADDR(NADR)
C
C------ THESE ARE THE ACTUAL SIZE OF THE COMMON BLOCK, INCLUDING SKIPPED
C      ITEMS
C
      PARAMETER ( ISSDIM = 38 )
C----- ICDDIM = 2 * NWK, IN COMMON BLOCK XLEXCH
      PARAMETER (ICDDIM  = 28 )
      INCLUDE 'PLSTHN.INC'
      PARAMETER ( NUNITS = 29 )
      PARAMETER ( NTAPES = 6 )
      PARAMETER ( NDISCS = 4 )
      PARAMETER ( NUFILE = 125 )
      PARAMETER ( NDVLEN = 6  , NDVNAM = 384 )
C----- NUMBER OF VARIABLES AND CHARACTERS IN COMMON /XSSCHR/
cdjwmay99one more parameter length 64
cRICjul99and another length 64
      PARAMETER (NSSLEN = 15, NSSCHR = 2632 )
C
C
      DIMENSION ISSBLK(ISSDIM)
      DIMENSION ICDBLK(ICDDIM)
      DIMENSION IUNITS(NUNITS)
      DIMENSION ITAPES(NTAPES)
      DIMENSION IDISCS(NDISCS)
      DIMENSION IUFILE(NUFILE)
      CHARACTER*(NDVNAM) CDVNAM
      DIMENSION IDVLEN(NDVLEN)
      CHARACTER*(NSSCHR) CSSCHR
      DIMENSION ISSLEN(NSSLEN)
C
C
      INCLUDE 'TRDDAT.INC'
      INCLUDE 'TDVNAM.INC'
      INCLUDE 'TSSCHR.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XRDDAT.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XOPVAL.INC'
C
C
      INCLUDE 'XAPK.INC'
      INCLUDE 'XLSTHN.INC'
      INCLUDE 'XTAPES.INC'
      INCLUDE 'XDISCS.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XDVNAM.INC'
      INCLUDE 'XSSCHR.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      EQUIVALENCE ( ISSBLK(1) , ISSISS )
      EQUIVALENCE ( ICOORD(1,1) , ICDBLK(1) )
      EQUIVALENCE ( IUNITS(1) , NCRU )
      EQUIVALENCE ( ITAPES(1) , MTA )
      EQUIVALENCE ( IDISCS(1) , NCDFU )
      EQUIVALENCE ( IUFILE(1) , NCUFU(1) )
      EQUIVALENCE ( CDVNAM(1:1) , CHLPDV(1:1) )
      EQUIVALENCE ( IDVLEN(1) , LHLPDV )
      EQUIVALENCE ( CSSCHR(1:1) , CSSMAC(1:1) )
      EQUIVALENCE ( ISSLEN(1) , LSSMAC )
C
C
C      SYST(EM)    INPL(IST)   COOR(DINATES) UNIT(S)   TAPE(S)
C      DISC(S)     UFIL(E)
C
      DATA CBLOCK / 'SYST' , 'INPL' , 'COOR' , 'UNIT' , 'TAPE' ,
     2              'DISC' , 'UFIL' , 'DEVI' , 'CSYS' /
C
      DATA LADDR  /      1 ,      0 ,      0 ,     18 ,     38 ,
     2                  44 ,     48 ,     50 ,     56 /
C
C
      DATA NADDR  /     17 ,      0 ,      0 ,     20 ,      6 ,
     2                   4 ,      2 , NDVLEN , NSSLEN /
C
C
      DATA MAXADR / ISSDIM , MAXLST , ICDDIM , NUNITS , NTAPES ,
     2              NDISCS , NUFILE , NDVNAM , NSSCHR /
C
C
      DATA IBLKTP / JNUMER , JNUMER , JNUMER , JNUMER , JNUMER ,
     2              JNUMER , JNUMER ,  JCHAR ,  JCHAR /
C
C
      DATA CADDR /
C----- SYST   1 - 17
     1 'VERS', 'KFNF', 'NBUF', 'RCLI', 'BLLI', 'WDLI', 'RCLF', 'BLLF',
     2 'WDLF', 'LSMN', 'SPEE', 'TMNG', 'LMNT', 'INIT', 'STRT', 'BANN',
     3 'DARL',
C----- UNIT   18 - 37
     4 'NCRU', 'NCRR', 'NCWU', 'NCPU', 'NCAR', 'NCAW', 'NCSU', 'NCXT',
     5 'NCQU', 'NCCB', 'NCF1', 'NCF2', 'NUCM', 'NVDU', 'NCER', 'NCAD',
     5 'NCMU', 'NCCH', 'NCPD', 'NCDB',
C----- TAPE   38 - 43
     6 'MTA ', 'MTB ', 'MT1 ', 'MT2 ', 'MT3 ', 'MTE ',
C----- DISC   44 - 47
     7 'NCDF', 'NCIF', 'NCLD', 'NCND',
C----- UFIL   48 - 49
     8 'FLMX', 'NCLU',
C----- DEVI   50 - 55
     9 'HLPD', 'HLPE', 'INDD', 'INDE', 'SCPD', 'SCPE',
cdjwmay99
cRICjul99
C----- CSYS   56 - 70
     1 'MACH', 'OPER', 'DATE', 'PROG', 'CMND', 'NEWD', 'CSRT', 'DSRT',
     2 'SCAT', 'ELEM', 'TT', 'LP', 'CIF', 'MAP', 'SVN' /
C
C
      DATA ITRADR /
C----- SYST   1 - 17
     * 2,   15,  19,  21,  22,  23,  24,  25,  26,  29,
     * 30,  31,  33,  34,  35,  36,  38,
C----- UNIT   18 - 37
     * 1,   2,   3,   4,   10,  11,  16, 17,  18,  19,  20,  21, 22,
     * 23, 24,  25,  26,   27,  28,  29,
C----- TAPE   38 - 43
     * 1,   2,   3,   4,   5,   6,
C----- DISC   44 - 47
     * 1,   2,   3,   4,
C----- UFIL   48 - 49
     * 21,  23,
C----- DEVI   50 - 55
     * 1, 65, 129, 193, 257, 321,
C----- CSYS   56 - 67
cdjwmay99 change 448 to 449, add 577
cRICjul99 add 641.
CRICmay15 add 8 for 'SVN'
     * 1,   17,  33,  49,  65,  321, 577, 833,1089,1345,1601,1857,
     * 2113, 2369, 2625 /
C
C
      DATA ITRAD2 /
C----- SYST   1 - 17
     * 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
C----- UNIT   18 - 37
     * 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
C----- TAPE   38 - 43
     * 0, 0, 0, 0, 0, 0,
C----- DISC   44 - 47
     * 0, 0, 0, 0,
C----- UFIL   48 - 49
     * 0, 0,
C----- DEVI   50 - 55
     * 1, 2, 3, 4, 5, 6,
cdjwmay99
cRICjul99
C----- CSYS   56 - 70
     * 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 /
C
C
      DATA ITRLEN /
C----- SYST   1 - 17
     * 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
C----- UNIT   18 - 37
     * 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
C----- TAPE   38 - 43
     * 0, 0, 0, 0, 0, 0,
C----- DISC   44 - 47
     * 0, 0, 0, 0,
C----- UFIL   48 - 49
     * 0, 0,
C----- DEVI   50 - 55
     * 64, 64, 64, 64, 64, 64,
cdjwmay99
cRICjul99
C----- CSYS   56 - 70
     * 16, 16, 16, 16,256,256,256,256,256,256,256,256,256,256,8 /
C
C
C -- IDENTIFY BLOCK NAME
C
      IPOS = KCCEQL ( CRDUPC , 2 , ' ' )
C
      LENBLK = KCCARG ( CRDUPC , IPOS , 1 , ISTART , IEND )
      IF ( LENBLK .LE. 0 ) GO TO 9910
C
      IRQBLK = KCCOMP ( CRDUPC(ISTART:IEND) , CBLOCK , NBLK , 1 )
      IF ( IRQBLK .LE. 0 ) GO TO 9910
C
      LENADR = KCCARG ( CRDUPC , IPOS , 1 , ISTART , IEND )
      IF ( LENADR .LE. 0 ) GO TO 9940
C
      NVAL = NADDR(IRQBLK)
      LVAL = LADDR(IRQBLK)
C
C
2000  CONTINUE
C
C -- TRANSLATE ADDRESS. FIRST TRY NUMERIC ADDRESS. THEN TRY CONVERTING
C    ADDRESS USING DEFINED NAMES, IF THERE ARE ANY FOR THIS BLOCK
C
      IADDR2 = 0
      LENRES = 1
C
      ISTAT = KCCINT ( CRDUPC(ISTART:IEND) , IADDR )
      IF ( ISTAT .LE. 0 ) THEN
        IF ( NVAL .LE. 0 ) GO TO 9940
        IKEY = KCCOMP ( CRDUPC(ISTART:IEND) , CADDR(LVAL) , NVAL , 2 )
        IF ( IKEY .LE. 0 ) GO TO 9940
        IKEY = IKEY + LVAL - 1
        IADDR  = ITRADR(IKEY)
        IADDR2 = ITRAD2(IKEY)
        LENRES = ITRLEN(IKEY)
      ENDIF
C
C -- READ VALUE
C
      ISAVE = IPOS
C
      IF ( IBLKTP(IRQBLK) .EQ. JNUMER ) THEN
C
C -- BLOCK IS OF 'NUMERIC' TYPE. ARGUMENT MUST BE CONVERTED BEFORE USE
        LENVAL = KCCARG ( CRDUPC , IPOS , 1 , ISTART , IEND )
        IF ( LENVAL .LE. 0 ) GO TO 9930
C -- TRY TO CONVERT VALUE TO NUMBER
        ISTAT = KCCREA ( CRDUPC(ISTART:IEND) , VALUE )
        IF ( ISTAT .GT. 0 ) THEN
          IVALUE = NINT ( VALUE )
        ELSE
C -- NOT A NUMBER. READ VALUE AGAIN, AND PACK UP TO 'A4' FORMAT
          IPOS = ISAVE
          LENVAL = KCCARG ( CRDUPC , IPOS , 2 , ISTART , IEND )
          IF ( LENVAL .LE. 0 ) GO TO 9930
          LENGTH = MIN0 ( 4 , LENVAL )
          READ ( CRDLWC(ISTART:ISTART+LENGTH-1) , '(A4)' ) IVALUE
        ENDIF
      ELSE
C
C -- BLOCK IS OF 'CHARACTER' TYPE. ARGUMENT CAN BE USED DIRECTLY
        LENVAL = KCCARG ( CRDUPC , IPOS , 2 , ISTART , IEND )
        IF ( LENVAL .LE. 0 ) GO TO 9930
      ENDIF
C
C -- CHECK ADDRESS IS VALID
C
      ILASTA = IADDR + LENRES - 1
      IF ( IADDR .LE. 0 ) GO TO 9940
      IF ( ILASTA .GT. MAXADR(IRQBLK) ) GO TO 9940
      IF ( IBLKTP(IRQBLK) .EQ. JCHAR ) THEN
        IF ( IADDR2 .LE. 0 ) GO TO 9940
        IF ( LENVAL .GT. LENRES ) GO TO 9940
      ENDIF
C
C -- STORE VALUE
C
      GO TO ( 2010 , 2020 , 2030 , 2040 , 2050 , 2060 , 2070 , 2080 ,
     2        2090 , 9920 ) , IRQBLK
      GO TO 9920
C
2010  CONTINUE
        ISSBLK(IADDR) = IVALUE
        GO TO 4000
2020  CONTINUE
        ILSTHN(IADDR) = IVALUE
        GO TO 4000
2030  CONTINUE
        ICDBLK(IADDR) = IVALUE
        GO TO 4000
2040  CONTINUE
        IUNITS(IADDR) = IVALUE
        GO TO 4000
2050  CONTINUE
        ITAPES(IADDR) = IVALUE
        GO TO 4000
2060  CONTINUE
        IDISCS(IADDR) = IVALUE
        GO TO 4000
2070  CONTINUE
        IUFILE(IADDR) = IVALUE
        GO TO 4000
2080  CONTINUE
        CDVNAM(IADDR:ILASTA) =  CRDLWC(ISTART:IEND)
        IDVLEN(IADDR2) = LENVAL
        GO TO 4000
2090  CONTINUE
        CSSCHR(IADDR:ILASTA) = CRDLWC(ISTART:IEND)
        ISSLEN(IADDR2) = LENVAL
        GO TO 4000
C
C
4000  CONTINUE
C
      LENARG = KCCARG ( CRDUPC , IPOS , 1 , ISTART , IEND )
      IF ( LENARG .LE. 0 ) GO TO 9000
C
      GO TO 2000
C
C
9000  CONTINUE
C
      RETURN
C
C
9900  CONTINUE
C -- ERRORS DURING 'STORE' INSTRUCTION
      CALL XERHND ( IERWRN )
      GO TO 9000
9910  CONTINUE
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9915 )
9915  FORMAT ( 1X , 'Illegal or missing keyword in STORE instruction' )
      GO TO 9900
9920  CONTINUE
      CALL XOPMSG ( IOPCRY , IOPINT , 0 )
      GO TO 9900
9930  CONTINUE
      WRITE ( CMON,9935)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , 9935 )
9935  FORMAT ( 1X , 'Illegal or missing value in STORE instruction' )
      GO TO 9900
9940  CONTINUE
      WRITE ( CMON,9945)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,9945)
9945  FORMAT(1X, 'Illegal or missing address in STORE instruction' )
      GOTO 9900
C
      END
C
C
CODE FOR XQUERY
      SUBROUTINE XQUERY
C
C -- THIS SUBORUTINE PROVIDES A BRIEF SUMMARY OF THE COMMANDS AVAILABLE
C    THE USER AT THE CURRENT POINT IN THE JOB
C
C
C    IF NO INSTRUCTION IS BEING PROCESSED, THE ROUTINE TREATS THE FIRST
C    STRING ON THE INPUT LINE AS AN INSTRUCTION NAME, THE SECOND AS A
C    DIRECTIVE, ETC. ( THIS IS CARRIED OUT BY ROUTINE 'XWHELP' )
C
C    IF AN INSTRUCTION IS CURRENTLY BEING PROCESSED, THE ROUTINE
C    INTERPRETS EVERYTHING ASSUMING THE CURRENT INSTRUCTION. THE FIRST
C    ITEM ON THE LINE IS TREATED AS A DIRECTIVE, ETC. BECAUSE THE
C    INSTRUCTION NAME PART OF LIST 50 ( RECORD 50 ) IS NO LONGER
C    AVAILABLE AT THIS POINT, THE CORRESPONDING LOCATIONS IN THE COMMON
C    BLOCK ARE ALTERED TO INDICATE THIS.
C
C    THE VALUE OF 'LEF' IS SAVED BEFORE THIS ROUTINE DOES ANYTHING, AND
C    RESTORED AFTERWARDS, SO THAT ANY ERRORS DETECTED ON INPUT, FOR
C    INSTANCE QUERIES USING AN AMBIGUOUS OR NON-EXISTENT NAME, DO NOT
C    CAUSE COMMAND INPUT TO BE ABANDONED
C
C
      DIMENSION ICONTX(4)
      DIMENSION ICOMMN(100)
C
C
C
      INCLUDE 'XLST50.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      DATA IDIMCX / 4 /
      DATA IDIMN / 100 /
C
C
      LEFSAV = LEF
C
C -- SET CHARACTER POINTER
      NC = 2
C
C
C -- CHECK THAT WE ARE CURRENTLY PROCESSING AN INSTRUCTION
      IF ( INSTR .LE. 0 ) THEN
        WRITE ( CMON,1005)
        CALL XPRVDU(NCEROR, 2,0)
1005    FORMAT (/,1X,'No instruction is currently being processed')
        CALL XWHELP ( 1 )
      ELSE
C -- CLEAR HELP POINTERS
        CALL XZEROF ( ICONTX , IDIMCX )
C
        NR50 = 0
        ICONTX(1) = INSTR
C
C -- PROCESS INPUT 'HELP' SPECIFICATION. DISPLAY REQUIRED 'HELP'
C    RESET POINTERS TO CURRENT DIRECTIVE
C
        CALL XHLPRD ( ICONTX , IDIMCX  )
        CALL XHLPOU ( ICONTX , IDIMCX )
C
        CALL XDIRFL ( IDIRFL , ICOMMN , IDIMN )
C
        WRITE ( CMON,1015)
        CALL XPRVDU(NCEROR, 1,0)
1015    FORMAT ( 1X , 'Parameter number reset to 1' )
C
      ENDIF
C
C -- RESTORE ERROR COUNT
      LEF = LEFSAV
C
C
      RETURN
      END
C
C
C
C
C
CODE FOR XWHELP
      SUBROUTINE XWHELP ( IFUNC )
C
C -- THIS SUBORUTINE PROVIDES A BRIEF SUMMARY OF THE COMMANDS AVAILABLE
C    THE USER AT THE CURRENT POINT IN THE JOB. THIS ROUTINE CAN ONLY BE
C    CALLED WHEN NO INSTRUCTION IS BEING PROCESSED.
C
C
C    THE FIRST ITEM ON THE INPUT LINE IS TREATED AS AN INSTRUCTION NAME
C    THE SECOND AS A DIRECTIVE ETC.
C
C
      DIMENSION ICONTX(4)
C
C
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
C
C
      DATA IDIMCX / 4 /
C
      IF ( INSTR .GT. 0 ) THEN
        WRITE ( CMON,1005)
        CALL XPRVDU(NCEROR, 2,0)
1005    FORMAT ( 1X , 'An instruction is being processed.' , / ,
     2           1X , 'Use the query facility for information ' ,
     3                'on the current instruction' )
            RETURN
      ENDIF
C
C
      CALL XZEROF ( ICONTX , IDIMCX )
C
C -- LOAD LIST 50
      CALL XFAL50
C
C -- PROCESS INPUT 'HELP' SPECIFICATION
      CALL XHLPRD ( ICONTX , IDIMCX )
C
C -- DISPLAY REQUIRED 'HELP'
      IF ( ( IFUNC .EQ. 1 ) .OR. ( ICONTX(1) .LE. 0 ) ) THEN
        CALL XHLPOU ( ICONTX , IDIMCX )
      ELSE IF ( IFUNC .EQ. 2 ) THEN
        CALL XPRTHI ( 0 , ICONTX(1) , 1 )
      ENDIF
C
C -- RESET STORE
      CALL XRSL
      CALL XCSAE
C
      RETURN
      END
C
C
C
C
C
CODE FOR XHLPRD
      SUBROUTINE XHLPRD ( ICONTX , IDIMCX )
C
C -- INTERPRET THE INPUT LINE AS A HELP RESUEST.
C
C  ICONTX(IDIMCX)      INPUT AND OUTPUT ARRAY. ANY VALUES WHICH ARE
C                      ZERO WHEN THIS ROUTINE IS CALLED WILL BE FILLED
C                      IN BY INTERPRETING THE INPUT STRING IF POSSIBLE.
C                      VALUES NOT SPECIFIED BY THE INPUT STRING WILL BE
C                      LEFT AS ZERO. THE MAXIMUM VALUE OF 'IDIMCX' IS 4
C    ICONTX(1)  INSTRUCTION NUMBER FOUND
C    ICONTX(2)  DIRECTIVE NUMBER ( FOR INSTRUCTION ICONTX(1) ) FOUND
C    ICONTX(3)  PARAMETER NUMBER ( FOR PARAMETER ICONTX(2) ) FOUND
C    ETC.
C
C
C    THE HELP SPECIFIER ARRAY 'ICONTX' IS FILLED IN FROM THE INPUT LINE
C    FROM 'IMAGE', BY CALLING THE APPROPIATE SUBROUTINES. :-
C
C      XHLPRI      READ INSTRUCTION NAME
C      XHLPRR      READ DIRECTIVE NAME
C      XHLPRP      READ PARAMETER NAME
C      XHLPRV      READ PARAMETER VALUE
C
C    IF ICONTX(I) IS NON-ZERO, THE CORRESPONDING TYPE IS LEFT AS
C    SPECIFIED, AND NO ITEM IS PROCESSED FROM THE INPUT STRING.
C    THIS CAN BE USED TO SEARCH FOR DIRECTIVES BELONGING TO THE CURRENT
C    INSTRUCTION FOR INSTANCE, BY SETTING ICONTX(1) TO 1 SAY.
C
C    THE ROUTINE ASSUMES THAT ENOUGH OF LIST 50 HAS BEEN LOADED TO
C    INTERPRET THE FIRST TYPE OF ITEM THAT WILL BE ENCOUNTERED. FOR
C    INSTANCE, IF THE FIRST ITEM ON THE LINE WILL BE AN INSTRUCTION
C    NAME, 'XFAL50' MUST HAVE BEEN CALLED.
C
C
C
C
      DIMENSION ICONTX(IDIMCX)
C
C
      LOGICAL SPEC , SINGLE , WILD
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XERVAL.INC'
C
      DATA MAXCX / 4 /
C
C
C----- CLEAR THE ERROR FLAG
      IERFLG = 0
C
      IF ( IDIMCX .GT. MAXCX ) THEN
            NZERO = IDIMCX - MAXCX
            CALL XZEROF ( ICONTX(MAXCX+1) , NZERO )
      ENDIF
C
C
C
      DO 1500 I = 1 , MAXCX
C
        IF ( ICONTX(I) .NE. 0 ) GO TO 1500
C
C
C -- GET NEXT KEYWORD
        NC = KNEQUL ( NC , IB )
        IF ( NC .GT. 0 ) THEN
          ND = KEQUAL ( NC , IB )
        ENDIF
C
C
        ITEML  = ND - NC + 1
        SPEC   = ( NC .GT. 0 )
        SINGLE = ( SPEC .AND. ( ITEML .EQ. 1 ) )
        IF ( SINGLE ) THEN
          WILD = ( IMAGE(NC) .EQ. IQ )
        ELSE
          WILD = .FALSE.
        ENDIF
C
        IF ( .NOT. SPEC ) THEN
              ICONTX(I) = 0
              GO TO 1500
        ELSE IF ( WILD ) THEN
              ICONTX(I) = -1
              GO TO 1500
        ELSE
              ITYPFL = I
              IF ( I .EQ. 1 ) THEN
                    CALL XHLPRI ( ICONTX(I) )
              ELSE IF ( I .EQ. 2 ) THEN
                    CALL XHLPRR ( ICONTX(I) )
              ELSE IF ( I .EQ. 3 ) THEN
                    CALL XHLPRP ( ICONTX(I) )
              ELSE IF ( I .EQ. 4 ) THEN
                    CALL XHLPRV ( ICONTX(I) )
              ENDIF
              IF ( ( ICONTX(I) .LE. 0 ) .OR. ( IERFLG .LT. 0 ) ) THEN
                    DO 1400 J = I , MAXCX
                      ICONTX(J) = 0
1400                CONTINUE
                    GO TO 9900
              ENDIF
        ENDIF
1500  CONTINUE
C
C
      RETURN
C
C
9900  CONTINUE
      CALL XERHND ( IERWRN )
      RETURN
C
C
      END
C
C
C
C
C
CODE FOR XHLPRI
      SUBROUTINE XHLPRI ( ICONTX )
C
C -- THIS ROUTINE SCANS THE STRING POINTED TO BY 'NC' AND 'ND' AS A
C    POSSIBLE INSTRUCTION NAME. IF IT IS A VALID INSTRUCTION NAME,
C    'ICONTX' IS SET TO THE APPROPRIATE INSTRUCTION NUMBER. IF NOT
C    ICONTX IS SET TO 0
C
C -- IF AN INSTRUCTION NAME IS FOUND, 'XLL50R' IS CALLED TO LOAD THE
C    DIRECTIVE DETAILS FOR THIS INSTRUCTION
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XLSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
      LENGTH = ND - NC + 1
      LENGTH = MIN0 ( LENGTH , MDR50 - 1 )
C
      ICONTX = KCNXTS ( LENGTH, ISTORE(LR50), NR50, MDR50 )
      IF ( ICONTX .LT. 0 ) GO TO 9900
      IF ( ICONTX .EQ. 0 ) GO TO 9920
C
      IF ( ICONTX .LE. LSTOFF ) THEN
            NC = KEQUAL ( NC , IB )
            IF ( NC .LE. 0 ) GO TO 9910
            I = KREADC ( VALUE , 1 )
            IF ( I .LT. 0 ) THEN
                  GO TO 9910
            ELSE IF ( I .GT. 0 ) THEN
                  LISTNO = NINT ( VALUE )
                  ISTAT = KLSCHK (LISTNO,0,0,ILSCLN,ILSMSG,ITMP,IERWRN)
                  IF ( ISTAT .LE. 0 ) GO TO 9900
                  ICONTX = LSTOFF + LISTNO
            ENDIF
      ENDIF
      CALL XLL50R ( ICONTX )
C
C
      RETURN
C
C
9900  CONTINUE
      ICONTX = 0
      RETURN
9910  CONTINUE
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1,0)
9915  FORMAT ( 1X , 'Illegal input value for list number' )
      GO TO 9900
9920  CONTINUE
      WRITE ( CMON,9925)
      CALL XPRVDU(NCEROR, 1,0)
9925  FORMAT ( 1X , 'Unrecognised instruction' )
      GO TO 9900
C
      END
C
C
C
C
C
CODE FOR XHLPRR
      SUBROUTINE XHLPRR ( ICONTX )
C
C -- THIS ROUTINE SCANS THE STRING POINTED TO BY 'NC' AND 'ND' AS A
C    POSSIBLE DIRECTIVE NAME. IF IT IS A VALID DIRECTIVE NAME,
C    'ICONTX' IS SET TO THE APPROPRIATE DIRECTIVE NUMBER. IF NOT
C    ICONTX IS SET TO 0
C
C -- IF A DIRECTIVE NAME IS FOUND, 'XDIRFL' IS CALLED TO SET UP
C    THE POINTERS TO THE PARAMETERS FOR THIS DIRECTIVE
C
      DIMENSION ICOMN(100)
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
      DATA IDIMN / 100 /
C
C
      IF ( NR60 .EQ. 0 ) THEN
            ICONTX = 0
      ELSE
            ICONTX = KCNXTS ( MDR60-1, ISTORE(LR60), NR60, MDR60 )
      ENDIF
C
C
      IF ( ICONTX .GT. 0 ) THEN
            CALL XDIRFL ( ICONTX , ICOMN , IDIMN )
      ELSE
            WRITE ( CMON,1005)
            CALL XPRVDU(NCEROR, 1,0)
1005        FORMAT ( 1X , 'Unrecognised directive' )
      ENDIF
C
C
      RETURN
C
      END
C
C
C
C
C
CODE FOR XHLPRP
      SUBROUTINE XHLPRP ( ICONTX )
C
C -- THIS ROUTINE SCANS THE STRING POINTED TO BY 'NC' AND 'ND' AS A
C    POSSIBLE PARAMETER NAME. IF IT IS A VALID PARAMETER NAME,
C    'ICONTX' IS SET TO THE APPROPRIATE PARAMETER NUMBER. IF NOT
C    ICONTX IS SET TO 0
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
C
C
      IF ( NR62D .LE. 0 ) THEN
            ICONTX = 0
      ELSE
            ICONTX = KCNXTS ( MDR62N-1, ISTORE(LR62N), NR62N, MDR62D )
C
            IF ( ICONTX .LE. 0 ) THEN
                  WRITE ( CMON,1005)
                  CALL XPRVDU(NCEROR, 1,0)
1005              FORMAT ( 1X , 'Unrecognised parameter' )
            ENDIF
      ENDIF
C
C
C
      RETURN
      END
C
C
C
C
C
CODE FOR XHLPRV
      SUBROUTINE XHLPRV ( ICONTX )
C
C -- THIS ROUTINE SCANS THE STRING POINTED TO BY 'NC' AND 'ND' AS A
C    POSSIBLE PARAMETER VALUE. IF IT IS A VALID PARAMETER VALUE,
C    'ICONTX' IS SET TO THE APPROPRIATE VALUE NUMBER. IF NOT
C    ICONTX IS SET TO 0
C
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCONST.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
C
C
      NVAL = ISTORE(MR62D+3)
      LVAL = ISTORE(MR62D+1) + LR62
      MDVAL = ISTORE(MR62D+2)
C
      ITYPE = ISTORE(MR62D)
C
      IF ( ITYPE .EQ. 1 ) THEN
            ISTAT = KINPUT ( VALUE )
            IF ( ISTAT .NE. 0 ) GO TO 9900
            IVALUE = NINT ( VALUE )
            IF ( NVAL .GT. 0 ) THEN
                  ICONTX = KCOMP ( 1, IVALUE, ISTORE(LVAL),NVAL,MDVAL )
                  IF ( ICONTX .LE. 0 ) GO TO 9910
            ENDIF
      ELSE IF ( ITYPE .EQ. 2 ) THEN
            ISTAT = KINPUT ( VALUE )
            IF ( ISTAT .NE. 0 ) GO TO 9900
            ICONTX = 0
            MVAL = LVAL + ( NVAL - 1 ) * MDVAL
            IF ( NVAL .GT. 0 ) THEN
                  ICONTX = 0
                  DO 1400 J = LVAL , MVAL , MDVAL
                    IF ( ABS(VALUE-STORE(J)) .LE. ZERO ) ICONTX = J
1400              CONTINUE
                  IF ( ICONTX .LE. 0 ) GO TO 9910
            ENDIF
      ELSE IF ( ITYPE .EQ. 3 ) THEN
            IF ( NVAL .GT. 0 ) THEN
                  ICONTX = KCNXTS ( MDVAL-1, ISTORE(LVAL), NVAL,MDVAL )
                  IF ( ICONTX .LE. 0 ) GO TO 9910
            ENDIF
      ENDIF
C
C
C
      RETURN
C
C
9900  CONTINUE
      ICONTX = 0
      RETURN
9910  CONTINUE
      WRITE ( CMON,9915)
      CALL XPRVDU(NCEROR, 1,0)
9915  FORMAT ( 1X , 'Illegal input value' )
      GO TO 9900
C
      END
C
C
C
C
C
CODE FOR XHLPOU
      SUBROUTINE XHLPOU ( ICONTX , IDIMCX )
C
C -- THIS ROUTINE PRODUCES THE APPROPRIATE OUTPUT FOR THE HELP
C    SPECIFIER ARRAY 'ICONTX(IDIMCX)'
C
C    FOR EACH TYPE OF ITEM ( UP TO THE MAXIMUM VALUE OF 4 ) THE ROUTINE
C    'XHLPDS' IS CALLED TO EITHER OUTPUT THE OBJECT NAME, OR, IF THE
C    VALUE OF ICONTX(I) INDICATES THAT THE OBJECT WAS NOT SPECIFIED ON
C    INPUT, A LIST ON THE POSSIBLE NAMES.
C
C    IN ADDITION, THIS ROUTINE OUTPUTS INFORMATION DESCRIBING THE
C    TYPE OF DATA REQUIRED FOR PARAMETERS, THE ALLOWED VALUES
C    OF REAL OR INTEGER PARAMETERS, AND THE DEFAULT VALUE OF PARAMETERS
C
C
C
      DIMENSION ICONTX(IDIMCX)
C
      CHARACTER*21 CPTYPE(4)
C
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XLST50.INC'
      INCLUDE 'XSYSHF.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
C
C
      DATA CPTYPE(1) / 'integer number       ' /
      DATA CPTYPE(2) / 'floating point number' /
      DATA CPTYPE(3) / 'character keyword    ' /
      DATA CPTYPE(4) / 'character string     ' /
C
C
C
      IF ( NR50 .GT. 0 ) THEN
            CALL XHLPDS ( ISTORE(LR50),MDR50,NR50,MDR50-1,ICONTX(1),1 )
            IF ( ICONTX(1) .LE. 0 ) THEN
            WRITE ( CMON,985)
            CALL XPRVDU(NCEROR, 2,0)
985           FORMAT ( 1X , 'Available system instructions' ,
     2                           ' ( see manual for details )' , /)
C             LHF (AND 4A1 LATER) INRTODUCED BECAUSE TEXT STORED A1
              NCOL = 10*LHF
              NITEM = NHF*LHF
              NROW = (NITEM+NCOL-1) / NCOL
              NBLOCK = (NROW +LINBUF-1) / LINBUF
              NSTART = 1
              NEND = 0
              DO 97531 I975 = 1, NBLOCK
                NEND = MIN (NITEM, (NCOL*LINBUF+NSTART-1))
                NROW = (NEND-NSTART+NCOL) / NCOL
                    WRITE ( CMON,995) (IHF(I),I=NSTART,NEND)
                    CALL XPRVDU(NCEROR, NROW, 0)
                NSTART = NEND+1
97531         CONTINUE
995           FORMAT ( 10( 2X, 4A1))
              GO TO 9000
            ENDIF
      ENDIF
C
      IF ( NR60 .LE. 0 ) GO TO 9000
      CALL XHLPDS ( ISTORE(LR60), MDR60, NR60, MDR60-1, ICONTX(2), 2 )
      IF ( ICONTX(2) .EQ. 0 ) GO TO 9000
C
      IF ( NR62N .LE. 0 ) GO TO 9000
      CALL XHLPDS ( ISTORE(LR62N),MDR62D,NR62N, MDR62N-1, ICONTX(3),3 )
      IF ( ICONTX(3) .EQ. 0 ) GO TO 9000
C
C
      MR62D  = LR62D + ( ICONTX(3) - 1 ) * MDR62D
      ITPVAL = ISTORE(MR62D)
C
      WRITE ( CMON,1002) CPTYPE(ITPVAL)
      CALL XPRVDU(NCEROR, 1,0)
1002  FORMAT ( 1X , 'Data type required is : ' , A )
C
      NVAL = ISTORE(MR62D+3)
      LVAL = LR62 + ISTORE(MR62D+1)
      MDVAL = ISTORE(MR62D+2)
      MVAL = LVAL + ( NVAL - 1 ) * MDVAL
C
      IDEFLT = ISTORE(MR62D+7)
C
      IF ( IDEFLT .GE. 0 ) THEN
            IF ( NVAL .GT. 0 ) THEN
              IDEFAD = LVAL + ( ISTORE(MR62D+8)-ISTORE(MR62D+6) )*MDVAL
            ELSE
              IDEFAD = MR62D+8
            ENDIF
      ENDIF
C
      IF ( NVAL .GT. 0 ) THEN
        IF ( ITPVAL .EQ. 1 ) THEN
          WRITE ( CMON,1005)
          CALL XPRVDU(NCEROR, 1, 1)
1005      FORMAT ( 1X , 'Available input value(s)' )
         WRITE ( CMON,1015)(ISTORE(J), J= LVAL,MVAL,MDVAL)
         CALL XPRVDU(NCEROR, 1, 0)
1015      FORMAT ( 1X , 6I12 )
        ELSE IF ( ITPVAL .EQ. 2 ) THEN
          WRITE ( CMON,1005)
         CALL XPRVDU(NCEROR, 1, 1)
         WRITE ( CMON,1025)(STORE(J), J= LVAL,MVAL,MDVAL)
         CALL XPRVDU(NCEROR, 1, 0)
1025      FORMAT ( 1X , 6F12.4 )
        ELSE
          CALL XHLPDS ( ISTORE(LVAL),MDVAL,NVAL,MDVAL-1,ICONTX(4),4 )
        ENDIF
      ENDIF
C
      IF ( IDEFLT .GE. 0 ) THEN
            IF ( ITPVAL .EQ. 1 ) THEN
                  WRITE ( CMON,1017) ISTORE(IDEFAD)
                  CALL XPRVDU(NCVDU, 1,0)
1017              FORMAT ( / , 1X , 'Default value is : ' , I12 )
            ELSE IF ( ITPVAL .EQ. 2 ) THEN
                  WRITE ( CMON,1027) STORE(IDEFAD)
                  CALL XPRVDU(NCVDU, 1,0)
1027              FORMAT ( / , 1X , 'Default value is : ' , F12.4 )
            ELSE
                  WRITE ( CMON,1035)  ( ISTORE(J) ,
     2                                    J = IDEFAD+1,IDEFAD+MDVAL-2 )
                  CALL XPRVDU(NCVDU, 1,0)
1035              FORMAT ( / , 1X , 'Default value is : ' , 12A1 )
            ENDIF
1037        FORMAT ( 1X )
      ELSE
            WRITE ( CMON,1045)
            CALL XPRVDU(NCVDU, 1,0)
1045        FORMAT ( / , 1X , 'There is no default value' , / )
      ENDIF
C
      IF ( ICONTX(4) .EQ. 0 ) GO TO 9000
C
C
C
9000  CONTINUE
C
      RETURN
      END
C
C
C
C
C
CODE FOR XHLPDS
      SUBROUTINE XHLPDS ( NAME,MDNAME,NNAME,NAMLEN,NINSTR,ITYPE)
C
C  -- THIS ROUTINE PRODUCES THE FORMATTED OUTPUT OF
C     INSTRUCTION/DIRECTIVE/PARAMETER NAMES ETC.
C
C     INPUT :-
C
C      NAME(MDNAME,NNAME)  ARRAY CONTAINING THE NAMES TO BE OUTPUT. THE
C                    NAME IS ASSUMED TO BEGIN IN THE SECOND WORD E.G.
C                    NAME(2,1) , NAME(3,1) , ... NAME(NAMLEN+1,1) FOR
C                    THE FIRST NAME.
C      NAMLEN      LENGTH OF EACH NAME TO OUTPUT. THIS IS 'MDNAME' FOR
C                    INSTRUCTIONS AND DIRECTIVES, BUT HAS A DIFFERENT
C                    VALUE FOR PARAMETER NAMES/VALUES ETC.
C      NINSTR      NUMBER OF THE CURRENT OBJECT IN THE LIST OF NAMES.
C                    IF 'NINSTR' HAS THE VALUE 0 , THE COMPLETE LIST OF
C                    NAMES IS OUTPUT, WITH A SUITABLE HEADING. IF IT
C                    IS POSITIVE, THE FULL NAME TAKEN FROM THE ARRAY '
C                    'NAME' IS OUTPUT, INDENTED ( 4 * ITYPE ) SPACES.
C      ITYPE       THE TYPE OF THE NAMES.
C                        1      INSTRUCTIONS
C                        2      DIRECTIVES
C                        3      PARAMETERS
C                        4      ALLOWED VALUES
C
C
      DIMENSION NAME(MDNAME,NNAME)
C
      CHARACTER*14 CDTYPE(4)
C
      INCLUDE 'ISTORE.INC'
C
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XIOBUF.INC'
C
      INCLUDE 'QSTORE.INC'
C
      DATA CDTYPE(1) /'instruction(s)'/ , CDTYPE(2) /'directive(s)  '/
      DATA CDTYPE(3) /'parameter(s)  '/ , CDTYPE(4) /'input value(s)'/
C
      NAMSPC = 12
      INTSPC = 4
C
      NAMBEG = 2
      NAMEND = NAMBEG + MIN0 ( NAMLEN , NAMSPC ) - 1
C
      INTBEG = 1
      INTEND = INTBEG + ( INTSPC - 1 ) + MAX0 ( (NAMSPC-NAMLEN) , 0 )
C
      IF ( NINSTR .EQ. 0 ) THEN
            WRITE ( CMON,1005) CDTYPE(ITYPE)
            CALL XPRVDU(NCVDU, 3,0)
1005        FORMAT ( / , 1X , 'Available ' , A , / )
            NCOL = 4
            NITEM = NNAME
            NROW = (NITEM+NCOL-1) / NCOL
            NBLOCK = (NROW +LINBUF-1) / LINBUF
            NSTART = 1
            NEND = 0
            DO 97531 I975 = 1, NBLOCK
              NEND = MIN (NITEM, (NCOL*LINBUF+NSTART-1))
              NROW = (NEND-NSTART+NCOL) / NCOL
                WRITE ( CMON,1015)
     1          ((NAME(J,K),J=NAMBEG,NAMEND),(IB,J=INTBEG,INTEND),
     2          K =NSTART,NEND)
                CALL XPRVDU(NCVDU, NROW, 0)
                IF (ISSPRT .EQ. 0) 
     1          WRITE ( NCWU, '(A)') (CMON(IDJW)(:),IDJW=1,NROW)
              NSTART = NEND+1
97531       CONTINUE
1015        FORMAT ( 4(1X,16A1) )
      ELSE
            WRITE ( CMON,1025)( IB , J = 1 , 4 * ITYPE ) ,
     2                              ( NAME(J,NINSTR),J = NAMBEG,NAMEND)
            CALL XPRVDU(NCVDU, 1, 0)
1025        FORMAT ( 1X , 72A1 )
      ENDIF
C
C
C
C
      RETURN
      END
C
C
CODE FOR KPSRQ
      FUNCTION KPSRQ(IN)
C--PROCESS THE SYSTEM REQUEST QUEUE
C
C--RETURN VALUES ARE :
C
C  -1  THE QUEUE IS ALREADY BEING PROCESSED
C   0  NO QUEUE TO PROCESS
C  >0  NUMBER OF REQUESTS TO PROCESS
C
C--THE VALUE OF 'IN' DETERMINES WHAT HAPPENS TO THE CURRENT CARD :
C
C  <1  DO NOT PRESERVE THE CURRENT CARD FOR LATER PROCESSING
C   1  PRESERVE THE CURRENT CARD AND PROCESS IT AT THE END
C
C--NOTE
C
C  NO ROUTINE THAT PRESERVES THE CURRENT CARD IMAGE MAY ISSUE
C  A SYSTEM REQUEST THAT WILL IN TURN LEAD TO FURTHER
C  SYSTEM REQUESTS BEING ISSUED.
C
C--
C
      CHARACTER CFORM *6, CIMAGE*80
C
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
C
C
      DATA CFORM / '(80A1)' /
C
      KPSRQ=-1
C--CHECK IF THE QUEUE IS ALREADY BEING PROCESSED
      IF(IEOF)1050,1050,1000
1000  CONTINUE
      RETURN
C--CHECK IF THERE ARE ANY REQUESTS TO PROCESS
1050  CONTINUE
      KPSRQ=0
      IF(NREC)1000,1000,1100
C--CHECK IF THE CURRENT CARD IS TO BE PRESERVED
1100  CONTINUE
      IF(IN)1200,1200,1150
C--PRESERVE THE PRESENT CARD
1150  CONTINUE
      WRITE(CIMAGE, CFORM) (IMAGE(I),I=1,LASTCH)
      CALL XISRC(CIMAGE)
      IHFLAG=-1
      MON=NI
C--SWITCH TO READING FROM M/T
1200  CONTINUE
      IEOF=NREC
      KPSRQ=NREC
      NS=10000
      IPOSRQ=0
      CALL XRPSRQ
      GOTO 1000
      END
C
CODE FOR XISRC
      SUBROUTINE XISRC (CLINE)
C--ISSUE A SYSTEM REQUEST COMMAND.
C
C  A     ARRAY HOLDING THE COMMAND
C  NW    NUMBER OF WORDS IN THE COMMAND
C  FORM  ARRAY HOLDING THE OUTPUT FORMAT
C  IDIM  THE DIMENSION OF 'FORM'.
C
C--THE ELEMENTS OF 'A' ARE ALL TREATED AS REAL NUMBERS,
C  OR AS HOLERITH CHARACTER STRINGS.
C
C--THE SYSTEM REQUEST QUEUE IS CONTROLLED BY THREE VARIABLES :
C
C  NUSRQ    THE SYSTEM REQUEST QUEUE UNIT NUMBER.
C           (AN M/T FILE OR A SEQUENTIAL DISC FILE)
C  NREC    THE NUMBER OF REQUESTS WAITING TO BE PROCESSED
C  IPOSRQ  THE ABSOLUTE RECORD POSITION OF THE SYSTEM REQUEST FILE.
C
C--
C
      CHARACTER CLINE*(*)
C
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      DATA I / 0 /
C
C--CHECK IF ANY REQUESTS ARE WAITING
      IF(NREC)1000,1000,1050
C--NO OTHER REQUESTS ARE WAITING
1000  CONTINUE
C
C -- START USING SYSTEM REQUEST QUEUE
C
      IF ( IFLIND .EQ. IFLMAX ) THEN
        WRITE ( CMON,1005)
        CALL XPRVDU(NCEROR, 1,0)
        IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1005 )
1005    FORMAT ( 1X,'No channel available for system request queue' )
        CALL XERHND ( IERPRG )
      ENDIF
      IF ( IRDSRQ(IFLIND) .LE. 0 ) THEN
C
        IFLIND = IFLIND + 1
      IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
       WRITE(NCWU,1006) IFLIND, NUSRQ , ' Srq'
1006   FORMAT('READ      Opening File index=',I8, ': Unit =',I8,1X,A)
      ENDIF
C
C------ THIS IS ONE OF THE FEW FILES NOT HANDLED BY XRDOPN
        I = KFLOPN ( NUSRQ , ' ' , ISSSCR , ISSWRI , 1, ISSSEQ )
        IF ( I .GT. 0 ) THEN
          IRDCPY(IFLIND) = 0
          IRDLOG(IFLIND) = 2
          IRDCAT(IFLIND) = ICAT
          NCRU = NUSRQ
          IFLCHR(IFLIND) = KFLCHR ( NCRU )
          IRDCMS(IFLIND) = 0
          IRDINC(IFLIND) = 10000
          IRDSCR(IFLIND) = 0
          IRDSRQ(IFLIND) = 1
          IRDFND(IFLIND) = 0
          IRDREC(IFLIND) = 0
C
          ICAT = IRDCAT(IFLIND)
          IUSFLG = IFLCHR(IFLIND)
        ELSE
C -- FILE OPEN FAILED
        WRITE ( CMON,1015)
        CALL XPRVDU(NCEROR, 1,0)
          IF (ISSPRT .EQ. 0) WRITE ( NCWU , 1015 )
1015      FORMAT ( 1X , 'Error opening system request file' )
          CALL XERIOM ( NCUFU(IFLIND) , I )
          CALL XERHND ( IERSEV )
        ENDIF
      ENDIF
C
      REWIND(NUSRQ)
      NREC=1
COCT98 - WIN32
C      write(NUSRQ,1100)
      IPOSRQ=0
      GOTO 1200
C--ADD ONTO THE OTHER REQUESTS THAT ARE WAITING
1050  CONTINUE
      DO 1150 I=1,NREC
         READ(NUSRQ,1100)
1100  FORMAT ( 1X )

1150  CONTINUE
c      ENDFILE ( NUSRQ )
      NREC=NREC+1
C--OUTPUT THE INSTRUCTION
1200  CONTINUE
      IF (IMNSRQ .GT. 0) THEN
           WRITE ( CMON,'(A,A)') ' SRQ write ', CLINE
           CALL XPRVDU(NCEROR, 1,0)
      ENDIF
      WRITE(NUSRQ,'(A/)' ) CLINE
      ENDFILE(NUSRQ)
C--REPOSITON THE TAPE FOR READING
      CALL XRPSRQ
      RETURN
      END
C
C
CODE FOR XSSRQ
      SUBROUTINE XSSRQ(IADD, NSRQ)
C
C----- STORE THE SYSTEM REQUEST QUEUE
C      IADD  ADDRESS IN ISTORE FOR START OF QUEUE
C      NSRQ  NO OF REQUESTS IN QUEUE
C
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'QSTORE.INC'
C
C----- CHECK IF THERE ARE ANY REQUESTS OUTSTANDING
      NSRQ = 0
      IF (NREC .GT. 0) THEN
      NSRQ = NREC
      KZ = 20 * NREC
      IADD = KCHLFL(KZ)
      LFL = IADD-1
      JADD = IADD + KZ - 1

      READ (NUSRQ, 1100) (ISTORE(KR), KR = IADD, JADD)
c        DO I = 0,NREC-1
c          KRR = IADD + ( 20 * I )
c          READ (NUSRQ,1100) (ISTORE(KR), KR=KRR,KRR+19)
c          WRITE(99,'(20A4)') (ISTORE(KR),KR=KRR,KRR+19)
c        END DO
1100  FORMAT (20A4)
      NREC = 0
      IEOF = 0
      IPOSRQ = 0
      REWIND(NUSRQ)
      ENDIF
      RETURN
      END
C
CODE FOR XRSRQ
      SUBROUTINE XRSRQ(IADD, NSRQ)
C
C----- RESTORE THE SYSTEM REQUEST QUEUE
C      IADD  ADDRESS IN ISTORE FOR START OF QUEUE
C
      CHARACTER CFORM *6, CIMAGE*80
      INCLUDE 'ISTORE.INC'
      INCLUDE 'STORE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'QSTORE.INC'
      DATA CFORM / '(20A4)' /
C
C----- CHECK IF THERE ARE ANY REQUESTS OUTSTANDING
      IF (NSRQ .GT. 0) THEN
            KY = 20
            DO 1100 KR =  1, NSRQ
            WRITE(CIMAGE, CFORM) (ISTORE(I), I= IADD, IADD+KY-1)
            CALL XISRC( CIMAGE )
            IADD = IADD + 20
1100        CONTINUE
      ENDIF
      RETURN
      END
CODE FOR XRPSRQ
      SUBROUTINE XRPSRQ
C--REPOSITION THE SYSTEM REQUEST QUEUE
C
C
      INCLUDE 'XCARDS.INC'
C
C
      DATA I/0/
C
      REWIND(NUSRQ)
      IF(IPOSRQ)1150,1150,1000
1000  CONTINUE
      DO 1100 I=1,IPOSRQ
      READ(NUSRQ,1050)
1050  FORMAT(1X)
1100  CONTINUE
1150  CONTINUE
      RETURN
      END
C
CODE FOR KCNXTS
      FUNCTION KCNXTS(NWDIR,IDIR,NDIR,LDIR)
C----- A LINK FROM EXISTING CODE TO A MODIFIED 'XCNXTS',
C      NOW CALLED KCHKDS
C
      DIMENSION IDIR(LDIR,NDIR)
      DIMENSION ITEXT(80)
C
      INCLUDE 'XCARDS.INC'
      M = ND - NC
      CALL XMOVE (IMAGE(NC), ITEXT(1), M)
      I = KCHKDS (ITEXT(1), M, NWDIR, IDIR, NDIR, LDIR)
      IF (I .GT. 0) NC = ND
      KCNXTS = I
      RETURN
      END
C
CODE FOR KCHKDS
      FUNCTION  KCHKDS (ITEXT, M, NWDIR, IDIR, NDIR, LDIR)
C
C----- MODIFIED TO LOOK FOR STRING HELD IN ITEXT(M)
C--SEARCH FOR A DIRECTIVE, CHECKING THAT THE STRING GIVEN DOES NOT
C  DEFINE TWO OR MORE KEYWORDS, AND THAT THE KEYWORD FOUND IS NOT
C  TOO LONG.
C
C  NWDIR   THE NUMBER OF WORDS PER KEYWORD IN 'IDIR'.
C  IDIR    AN ARRAY CONTAINING THE KEYWORDS. THE FIRST WORD
C          OF EACH ENTRY MUST BE THE MAXIMUM ALLOWED LENGTH
C          FOR THIS KEYWORD.
C  NDIR    THE NUMBER OF KEYWORDS.
C  LDIR    THE NUMBER OF WORDS BETWEEN SUCCESSIVE KEYWORDS.
C
C--RETURN VALUES FOR THIS ROUTINE ARE :
C
C  -1  AN ERROR DURING THE PROCESSING  -  A MESSAGE WILL HAVE
C      BEEN PRINTED, USING THE 'ITYPFL' PARAMETER IN 'XCARDS'.
C   0  NO MATCH.
C  >0  THE KEYWORD NUMBER FOUND.
C
C--THIS ROUTINE EXPECTS 'NC' TO POINT TO THE FIRST CHARACTER OF
C  THE KEYWORD TO BE CHECKED, AND 'ND' TO POINT TO THE CHARACTER
C  IMMEDIATELY FOLLOWING THE KEYWORD.
C
C--
C
      DIMENSION ITEXT(M)
      DIMENSION IDIR(LDIR,NDIR)
C
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
C----- COMPUTE THE USEFUL LENGTH
      N = KCOMP (1, IB, ITEXT(1), M, 1) -1
      IF (N .LE. 0) N = M
      N = MIN0( N, NWDIR)
C--SEE IF THERE ARE ANY CHARACTERS TO SEARCH OVER
      IF(N)1000,1000,1100
C--NO MATCH FOUND
1000  CONTINUE
      KCHKDS = 0
1050  CONTINUE
      RETURN
C--FIND THE FIRST MATCH
1100  CONTINUE
      NUM=KCOMP(N,ITEXT(1),IDIR(2,1),NDIR,LDIR)
C--CHECK FOR SUCCESS
      IF(NUM)1000,1000,1150
C--SUCCESS  -  CHECK THE MAXIMUM LENGTH
1150  CONTINUE
      IF(M-IDIR(1,NUM))1400,1200,1250
C--ALL OKAY  -  RESET THE CURRENT COUNTER POSITION
1200  CONTINUE
      KCHKDS = NUM
      GOTO 1050
C--THE KEYWORD INPUT IS TOO LONG
1250  CONTINUE
      CALL XMONTR(0)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1300)(ITEXT(I),I=1,M)
      ENDIF
      WRITE ( CMON,1300) (ITEXT(I),I=1,M)
      CALL XPRVDU(NCEROR, 2,0)
1300  FORMAT(' The following keyword or value is known,',
     2 ' but contains too many characters here : ',/,40A1)
      LEF=LEF+1
      IDIRFL=-1
C--UPDATE THE ERROR FLAG AND RETURN
1350  CONTINUE
      KCHKDS = -1
      GOTO 1050
C--SUCCESS  -  CHECK IF THERE MORE KEYWORDS THAT WE CAN CHECK
1400  CONTINUE
      L=NDIR-NUM
      IF(L)1200,1200,1450
C--CHECK THE REMAINING DIRECTIVES FOR A MATCH
1450  CONTINUE
      IF(KCOMP(N,ITEXT(1),IDIR(2,NUM+1),L,LDIR))1200,1200,1500
C--STRING DEFINES MORE THAN KEYWORD IN THIS CONTEXT
1500  CONTINUE
      CALL XMDCS
      GOTO 1350
      END
C
CODE FOR XMDCS
      SUBROUTINE XMDCS
C--MULTIPLY DEFINED CHARACTER STRING
C
C--
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XDIRTP.INC'
      INCLUDE 'XIOBUF.INC'
C
      CALL XMONTR(0)
C--THE INPUT KEYWORD DEFINES MORE THAN ONE PROVIDED KEYWORD
      J=ND-1
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1000)(IDTYPE(I,ITYPFL),I=1,3),(IMAGE(I),I=NC,J)
      ENDIF
      WRITE ( CMON,1000) (IDTYPE(I,ITYPFL),I=1,3),
     2                     (IMAGE(I),I=NC,J)
      CALL XPRVDU(NCEROR, 2,0)
1000  FORMAT(' The following character string',
     2 ' does not uniquely define one ',3A4,': ',/,40A1)
      LEF=LEF+1
      IDIRFL=-1
      RETURN
      END
C
CODE FOR KCOMP
      FUNCTION KCOMP(NW,ITEST,IARG,NARG,NSARG)
C--STANDARD COMPARISON ROUTINE
C
C  NW     NUMBER OF SEPARATE WORDS TO BE COMPARED
C  ITEST  VECTOR HOLDING THE WORD(S) TO BE COMPARED
C  IARG   VECTOR HOLDING THE WORDS AGAINST WHICH THE COMPARISON IS TO
C         BE MADE
C  NARG   NUMBER OF STANDARD WORDS TO COMPARE AGAINST
C  NSARG  THE STEP BETWEEN SUCCESSIVE COMPARISON WORDS
C
C--ON RETURN KCOMP HOLDS THE POSITION OF THE FIND OR ELSE -1
C
C--
C
      DIMENSION ITEST(NW),IARG(NSARG,NARG)
C
C
C
C--FIND THE MINIMUM SEARCH LENGTH
      L=MIN0(NW,NSARG)
C--CHECK FOR A ZERO SEARCH LENGTH
      IF(L)1000,1000,1100
C--NO SUCCESS
1000  CONTINUE
      KCOMP=-1
1050  CONTINUE
      RETURN
C--LOOP OVER EACH OF THE ARGUMENTS
1100  CONTINUE
      DO 1200 I=1,NARG
C--LOOP OVER EACH PART
      DO 1150 J=1,L
      IF(ITEST(J).NE.IARG(J,I))GOTO 1200
1150  CONTINUE
C--SUCCESS
      KCOMP=I
      GOTO 1050
1200  CONTINUE
      GOTO 1000
      END
CODE FOR KREADC
      FUNCTION KREADC(A,N)
C--READ FLOATING POINT NUMBERS OFF A CARD, WITHOUT CHANGING CARDS.
C  IF THE END OF THE CARD IS REACHED, A DEFAULT VALUE OF 0.0 IS GIVEN TO
C  REMAINING NUMBERS.
C
C  A  ARRAY INTO WHICH THE NUMBERS GO
C  N  THE NUMBER OF NUMBERS TO READ
C
C--RETURN VALUES ARE :
C
C  -1  ERRORS
C   0  NUMBER OF NUMBERS FOR WHICH VALUES ARE PRESENT
C   1  .
C   .  .
C   N  .
C
C--
C
      DIMENSION A(N)
C
      KREADC=0
C--CHECK IF THERE ARE ANY NUMBERS TO READ
      IF(N)1050,1050,1000
C--SET THE DEFAULT VALUES
1000  CONTINUE
      CALL XZEROF(A(1),N)
C--READ THE NUMBERS
      KREADC=KREADB(A,N)
1050  CONTINUE
      RETURN
      END
C
CODE FOR KREADB
      FUNCTION KREADB(A,N)
C--READ FLOATING POINT NUMBERS OFF A CARD, WITHOUT CHANGING CARDS.
C  IF THE END OF THE CARD IS REACHED, THE REMAINING NUMBERS ARE LEFT UNS
C
C  A  ARRAY INTO WHICH THE NUMBERS GO
C  N  THE NUMBER OF NUMBERS TO READ
C
C--RETURN VALUES ARE :
C
C  -1  ERRORS
C   0  NUMBER OF NUMBERS FOR WHICH VALUES ARE PRESENT
C   1  .
C   .  .
C   N  .
C
C--
C
      DIMENSION A(N)
C
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCHARS.INC'
C
C
      DATA I/0/,M/0/
C
      M=0
      KREADB=0
C--CHECK IF THERE ARE NAY NUMBERS TO READ
      IF(N)1200,1200,1000
C--LOOP OVER THE NUMBERS TO READ
1000  CONTINUE
      DO 1150 I=1,N
C--SEARCH FOR THE NEXT NON-BLANK CHARACTER
      NC=KNEQUL(NC,IB)
C--CHECK FOR END OF CARD
      IF(NC)1150,1150,1050
C--READ THE NUMBER
1050  CONTINUE
      M=M+1
      IF(KINPUT(A(I)))1100,1150,1100
C--ERROR IN READING THE LAST NUMBER
1100  CONTINUE
      CALL XSPCH
      KREADB=-1
      NC=KEQUAL(NC,IB)
      GOTO 1200
1150  CONTINUE
C--SUCCESSFUL EXIT  -  SET THE RETURN VALUE
      KREADB=M
1200  CONTINUE
      RETURN
      END
C
cCODE FOR KREADK
c      FUNCTION KREADK(IA,N)
cC--READ INTEGER NUMBERS OFF A CARD, WITHOUT CHANGING CARDS.
cC  IF THE END OF THE CARD IS REACHED, A DEFAULT VALUE OF 0 IS GIVEN TO
cC  THE REMAINING NUMBERS.
cC
cC  IA  ARRAY INTO WHICH THE NUMBERS GO
cC  N   THE NUMBER OF NUMBERS TO READ
cC
cC--RETURN VALUES ARE :
cC
cC  -1  ERRORS
cC   0  NUMBER OF NUMBERS FOR WHICH VALUES ARE PRESENT
cC   1  .
cC   .  .
cC   N  .
cC
cC--
cC
c      DIMENSION IA(N)
cC
c      KREADK=0
cC--CHECK IF THERE ARE ANY NUMBERS TO PROCESS
c      IF(N)1050,1050,1000
cC--INSERT THE DEFAULT VALUES
c1000  CONTINUE
c      CALL XZEROF(IA(1),N)
cC--READ THE NUMBERS
c      KREADK=KREADJ(IA,N)
c1050  CONTINUE
c      RETURN
c      END

cCODE FOR KREADJ
c      FUNCTION KREADJ(IN,N)
cC--READ INTEGER NUMBERS OFF A CARD, WITHOUT CHANGING CARDS.
cC  IF THE END OF THE CARD IS REACHED, THE REMAINING NUMBERS ARE LEFT
cC  UNSET.
cC
cC  IN  ARRAY INTO WHICH THE NUMBERS GO
cC  N   THE NUMBER OF NUMBERS TO READ
cC
cC--RETURN VALUES ARE :
cC
cC  -1  ERRORS
cC   0  NUMBER OF NUMBERS FOR WHICH VALUES ARE PRESENT
cC   1  .
cC   .  .
cC   N  .
cC
cC--
cC
c      DIMENSION IN(N),A(1)
cC
c\XCARDS
c\XCHARS
cC
cC
c      DATA I/0/,M/0/
cC
c      KREADJ=0
cC--CHECK IF THERE ARE ANY NUMBERS TO PROCESS
c      IF(N)1250,1250,1000
cC--LOOP OVER THE NUMBERS TO BE INPUT
c1000  CONTINUE
c      M=0
c      DO 1200 I=1,N
cC--SEARCH FOR THE NEXT NON-BLANK CHARACTER ON THE CARD
c      NC=KNEQUL(NC,IB)
cC--CHECK FOR THE END OF THE CARD
c      IF(NC)1200,1200,1050
cC--READ THE NUMBER AS AFLOATING POINT NUMBER
c1050  CONTINUE
c      M=M+1
c      IF(KINPUT(A(1)))1100,1150,1100
cC--ERROR IN READING THE LAST NUMBER
c1100  CONTINUE
c      CALL XSPCH
c      NC=KEQUAL(NC,IB)
c      KREADJ=-1
c      GOTO 1250
cC--FIX THE NUMBER WE HAVE JUST READ
c1150  CONTINUE
c      IN(I)=NINT(A(1))
c1200  CONTINUE
c      KREADJ=M
c1250  CONTINUE
c      RETURN
c      END
C
CODE FOR KINPUT
      FUNCTION KINPUT(A)
C--READ A NUMBER FROM A CARD
C
C  THE NUMERIC VALUE IS PUT IN 'A'
C
C--ERROR FUNCTIONS ARE INDICATED BY THE VALUE OF KINPUT ON RETURN
C
C  -1  SPURIOUS CHARACTER FOUND AFTER THE FIRST CHARACTER READ
C   0  NUMBER READ CORRECTLY
C   1  FIRST CHARACTER DOES NOT INDICATE A NUMBER IN THIS POSITION
C
C--ON ENTRY, THE CARD CHARACTER POINTER ('NC') IS ASSUMED TO BE
C  POINTING AT THE FIRST CHARACTER OF THE NUMBER  -  I.E. THIS
C  ROUTINE DOES NOT SKIP OVER BLANK SPACES AT THE START.
C
C--A NUMBER IS TERMINATED BY ONE OR MORE SPACES, A COMMA OR BY
C  THE END OF THE CARD. THE CHARACTER POINTER 'NC' IS LEFT POINTING
C  TO THE SPACE OR THE CHARACTER AFTER THE ',' DEPENDING ON THE
C  TERMINATION CONDITION.
C
C--
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCHARS.INC'
C
C
      DATA I/0/,J/0/
      DATA P/0.0/,Q/0.0/,R/0.0/,S/0.0/,T/0.0/
C
C--SET UP THE INITIAL CONSTANTS
      J=NC
      T=0.
      S=1.
      R=10.
      Q=1.
      P=1.
C--CHECK THE FIRST CHARACTER TO BE READ
      IF(IMAGE(NC).EQ.IPLUS)GOTO 1150
C--NOT A '+' SIGN  -  CHECK FOR '-'
      IF(IMAGE(NC).NE.MINUS)GOTO 1000
C--AN INITIAL '-'  -  SET THE FLAGS
      S=-1.
      GOTO 1150
C--CHECK IF THE FIRST CHARACTER IS '.'
1000  CONTINUE
      IF(IMAGE(NC).NE.IPOINT)GOTO 1400
C--CHECK IF THIS IS THE FIRST '.' FOUND
1050  CONTINUE
      IF(P-0.5)1500,1500,1100
C--RESET FOR READING AFTER THE '.'
1100  CONTINUE
      R=1.
      Q=0.1
      P=0.1
C--MOVE TO THE NEXT CHARACTER
1150  CONTINUE
      NC=NC+1
C--CHECK IF THIS IS END OF CARD
      IF(NC-LASTCH)1200,1200,1250
C--CHECK IF THIS IS THE END OF THE NUMBER  -  ' '
1200  CONTINUE
      IF(IMAGE(NC).EQ.IB)GOTO 1250
C--NOW CHECK FOR ',' TO TERMINATE THE NUMBER
      IF(IMAGE(NC).NE.ICOMMA)GOTO 1350
C--UPDATE THE CHARACTER POINTER
      NC=NC+1
C--SUCCESSFUL NUMBER TERMINATION
1250  CONTINUE
      KINPUT=0
C--COMPUTE THE RETURN VALUE
1300  CONTINUE
      A=T*S
      RETURN
C--CHECK IF THE NEXT CHARACTER IS A '.'
1350  CONTINUE
      IF(IMAGE(NC).EQ.IPOINT)GOTO 1050
C--FIND THE NUMERIC EQUIVALENT OF THE CHARACTER AND ADD IN
1400  CONTINUE
      DO 1450 I=1,10
      IF(IMAGE(NC).NE.NUMB(I))GOTO 1450
C--MATCH  -  COMPUTE THE NEXT ADDITION
      T=T*R+FLOAT(I-1)*Q
      Q=Q*P
      GOTO 1150
1450  CONTINUE
C--CHECK IF AN ERROR OCCURS ON THE FIRST CHARACTER READ
      IF(J-NC)1500,1550,1500
C--ERROR DOES NOT OCCUR ON THE FIRST CHARACTER
1500  CONTINUE
      KINPUT=-1
      GOTO 1300
C--ERROR OCCURS ON THE FIRST CHARACTER
1550  CONTINUE
      KINPUT=1
      GOTO 1300
      END
C
CODE FOR XSPCH
      SUBROUTINE XSPCH
C--PRINT OUT A MESSAGE FOR A SPURIOUS CHARACTER
C
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XLISTI.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      DATA I/0/
C
C--PRESERVE THE MONITORING CATEGORY
      JCAT=ICAT
C--PRINT THE CARD AND INDICATE THE POSITION OF THE SP. CH.
      ICAT=1
      CALL XMONTR(0)
C--RESTORE THE MONITORING CATEGORY
      ICAT=JCAT
C--PRINT THE CHARACTER POSITION
      IF(NC)1000,1000,1050
C--OFF THE BEGINNING OF THE CARD
1000  CONTINUE
      I=LASTCH
      GOTO 1100
C--SET TO THE CURRENT VALUE
1050  CONTINUE
      I=MIN0(NC,LASTCH)
C--AND NOW THE PRINT
1100  CONTINUE
      WRITE ( CMON,1151) (IB,J=1,I),IA
      CALL XPRVDU(NCEROR, 1,0)
1151  FORMAT(5X,82A1)
      IF (ISSPRT .EQ. 0) THEN
      WRITE(NCWU,1150)(IB,J=1,I),IA
      ENDIF
1150  FORMAT(7X,82A1)
      WRITE ( CMON,1200)
      CALL XPRVDU(NCEROR, 1,0)
      IF (ISSPRT .EQ. 0) WRITE(NCWU,1200)
1200  FORMAT(' Spurious character  (Marked by an *)')
      LEF=LEF+1
      IDIRFL=-1
      RETURN
      END
C
CODE FOR XMONTR
      SUBROUTINE XMONTR(IND)
C--SUBROUTINE THAT PRINTS THE INPUT STREAM, IF THE MONITORING
C  CATEGORY IN 'ICAT' ALLOWS.
C
C  IND     THE TYPE OF CARD JUST FOUND AND TO BE PRINTED :
C
C          -1  AN OKAY CARD.
C           0  AN ERROR OR IGNORED CARD.
C
C--VALUES OF 'ICAT' ARE :
C
C   0  DO NOT PRINT THE CARDS AS THEY ARE READ IN.
C   1  PRINT THE INPUT CARDS WITH LINE NUMBERS AND LEADING ZEROES
C
CDJW OUTPUT TO LISTING AND MONITOR FILES IS ENABLED EITHER BY ICAT 'ON'
C    OR BY SCRIPT VERIFY 'TRUE'
C--
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XCHARS.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
CDJW DEC 99  SCRIPT GLOBALS TO ENABLE/DISABLE MONITORING
      INCLUDE 'XSCGBL.INC'
C
C -- CHECK IF THIS CARD HAS BEEN PRINTED BEFORE
      IF ( MON .EQ. NI ) RETURN
C -- CARD HAS NOT BEEN PRINTED  -  SET THE LAST CARD PRINTED FLAG
      MON = NI
C -- CHECK IF PRINTING IS REQUIRED
C----- CHECK IF WE ARE MONITORING THE SRQ
      IF ((IEOF .GT. 0) .AND. (IMNSRQ .EQ. 0)) RETURN
C--SET THE TYPE OF CARD CORRECTLY
      J=MAX0(1,MIN0(IND+2,2))
C--SET THE CARD NUMBER UP PROPERLY
      N=MOD(MAX0(NI,0),10000)
C--COMPUTE THE CARD NUMBER, INCLUDING LEADING ZEROES
      K=N/1000
      N=N-1000*K
      L=N/100
      N=N-100*L
      M=N/10
      N=N-10*M
      K=K-K/10*10
C -- CALCULATE HOW MANY CHARACTERS TO PRINT
C
      IFIN = 1
      DO 1120 I = 1 , LASTCH
      IF ( LCMAGE(I) .EQ. IB ) GO TO 1120
      IFIN = I
1120  CONTINUE
C
      IFILL = LASTCH - IFIN
      IF ( J .GT. 1 ) J = J + IFILL
C
C--PRINT THE CARD AND ITS NUMBER
      WRITE ( CMON,1151) NUMB(K+1),NUMB(L+1),NUMB(M+1),
     2  NUMB(N+1),(LCMAGE(I),I=1,MIN(72,IFIN))
1151  FORMAT(1X,4A1,1X,80A1,2A1)
      IF (IND .GE. 0) CMON(1)(60:) = ' IGNORED/ERRORS'
cdjwdec99 slightly re-organied
      IF ( ICAT .GT. 0 ) THEN
        IF (IND .GE. 0) THEN
          CALL OUTCOL(9)
        ELSE
          CALL OUTCOL(8)
        END IF
          CALL XPRVDU(NCVDU, 1, 0)
          CALL OUTCOL(1)
      ENDIF
      IF ((ISCVER .GT. 0) .OR. (ICAT .GT. 0)) THEN
         IF (ISSPRT .EQ. 0) 
     1   WRITE(NCWU,1150)NUMB(K+1),NUMB(L+1),NUMB(M+1),NUMB(N+1),
     2   (LCMAGE(I),I=1,IFIN),(IB,I=1,J)
1150     FORMAT(1X,4A1,'*  ',80A1,2A1,'*** IGNORED/ERROR(S) *** ')
      ENDIF
C
      RETURN
      END
C
CODE FOR KEQUAL
      FUNCTION KEQUAL(IFIRST,IICHAR)
C--FIND THE NEXT CHARACTER ON A CARD
C
C  IFIRST  CHARACTER POSITION AT WHICH TO START
C  IICHAR   THE CHARACTER TO SEARCH FOR
C
C--KEQUAL IS SET TO THE CHARACTER POSITION, OR -1 IF THE CHARACTER
C  CANNOT BE FOUND
C
C--
      INCLUDE 'XCARDS.INC'
C
C
      DATA I/0/
C
      I=IFIRST
      KEQUAL=-1
C--CHECK IF THERE IS ANY MORE USEFUL INFORMATION ON THIS CARD
      IF(I)1150,1150,1000
C--CHECK FOR END OF CARD
1000  IF(I-LASTCH)1050,1050,1150
C--CHECK THE NEXT CHARACTER
1050  CONTINUE
      IF(IMAGE(I).EQ.IICHAR)GOTO 1100
C--UPDATE FOR THE NEXT CHARACTER
      I=I+1
      GOTO 1000
1100  KEQUAL=I
1150  CONTINUE
      RETURN
      END
C
CODE FOR KNEQUL
      FUNCTION KNEQUL(IFIRST,IICHAR)
C--SEARCH A CARD FOR THE CHARACTER NOT OF TYPE 'IICHAR'
C
C  IFIRST  CHARACTER POSITION AT WHICH TO START
C  IICHAR   THE CHARACTER WHICH THE CURRENT CHARACTER MUST NOT BE
C
C--KNEQUL RETURNS SET TO THE POSITION OF THE FIRST CHARACTER NOT
C  EQUAL TO 'IICHAR', OR ELSE TO -1.
C
C--
      INCLUDE 'XCARDS.INC'
C
C
      DATA I/0/
C
      I=IFIRST
      KNEQUL=-1
C--CHECK IF THERE IS MORE USEFUL INFORMATION ON THIS CARD
      IF(I)1150,1150,1000
C--CHECK FOR THE END OF THE CARD
1000  IF(I-LASTCH)1050,1050,1150
C--CHECK THE NEXT CHARACTER
1050  CONTINUE
      IF(IMAGE(I).NE.IICHAR)GOTO 1100
C--UPDATE FOR THE NEXT CHARACTER
      I=I+1
      GOTO 1000
1100  KNEQUL=I
1150  CONTINUE
      RETURN
      END
C
CODE FOR XBENCH
      SUBROUTINE XBENCH(DV, NDV, A, NA ,NVAR,NREF)
C      DV - VECTOR
C      NVD - LENGTH OF VECTOR
C      A MATRIX
C      NA NUMBER OF ELEMENTS
C      NVAR NUMBER OF VARIABLES (LESS THAN SQRT(NA))
C      NREF NUMBER OF REFLECTIONS
C
      DOUBLE PRECISION ACC
      DIMENSION DV(NDV), A(NA)
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
      INCLUDE 'XSSVAL.INC'
C
C----- SAVE THE TIMER STATUS
      ITEMP = ISSTIM
      ISSTIM = 1
      WRITE ( CMON,1234)
      CALL XPRVDU(NCVDU, 5,0)
1234  format (' BENCH MARK for crystallography.',/
     1 ' Part 1 simulates matrix accumulation',/
     1 ' Part 2 simulates matrix inversion',/
     1 ' Both parts test addressing of a large array',/
     1 ' and use of Double Precision accumulators')
C
      WRITE (CMON,1235)
      CALL XPRVDU(NCVDU, 4,0)
1235  format (/  ' For Microvax 3800,',
     1 ' 500 parameters, 5000 observations '/
     1 'Accumulation = 1824 secs, Inversion = 75 secs'/)
C
            WRITE(CMON,3060) NVAR,NREF
            CALL XPRVDU(NCVDU, 2,0)
3060  FORMAT (I6, ' variables and', I6, ' reflections'/
     1 'Start')
      KOFFST = NVAR*NVAR
      DO 10 I=1,KOFFST
      A(I)=0.
10    CONTINUE
      M=NVAR
      MM=M+1
C----- SIMULATE DERIVATIVES
      DO 20 I=1,M
      DV(I)=I*NVAR*.9
20    CONTINUE
      CALL XTIME1(3)
      CALL XTIME2(3)
      CALL XTIME1(3)
C----- LOOP FOR EACH REFLECTION
      DO 6001 IP=1,NREF
      K=1
C----- SUMMATION OVER DERIVATIVES
      DO 5001 J=1,NVAR
      B=DV(J)
      DO 5003 L = J,M
      A(K)=A(K)+DV(L)*B
      A(KOFFST-K)=A(K)
      K=K+1
5003  CONTINUE
5001  CONTINUE
6001  CONTINUE
      WRITE (CMON,'(A)') ' Matrix accumulation'
      CALL XPRVDU(NCVDU,1,0)
      CALL XTIME2(3)
C
C---- SIMULATE MATRIX INVERSION
      ACC = 0.0D1
      CALL XTIME1(3)
      K = 1
      DO 7000 J = 1, NVAR
            B = A(J)
            DO 7500 L = J,NVAR
                  C = A(L)
                  DO 7300 I = L, NVAR
                  ACC = ACC + DPROD( A(K), B ) + DPROD( A(L), C )
     1                      + DPROD( A(K), A(L))
7300              CONTINUE
                  K =K + 1
7500        CONTINUE
7000  CONTINUE
      WRITE (CMON,'(A)') ' Matrix inversion'
      CALL XPRVDU(NCVDU,1,0)
      CALL XTIME2(3)
C----- RESTORE THE TIMER STATUS
      ISSTIM = ITEMP
      RETURN
      END

