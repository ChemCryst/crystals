C  EXPRESSION OPERATORS USED IN KSCEXP
C      DATA COPER /                '('   ,   ')'   ,                ! 0-2
C     2                  '+'   ,   '-'   ,   '*'   ,   '/'   ,      ! 3-6    !Bop 1 - 
C     3                '.EQ.'  ,   '='   ,  '.NE.' ,  '<>'   ,      ! 7-10
C     4                '.LE.'  ,  '=<'   ,  '.GE.' ,  '>='   ,      !11-14
C     5                '.LT.'  ,   '<'   ,  '.GT.' ,   '>'   ,      !15-18
C     6                '.OR.'  , '.AND.' , '.THEN.' , '.ELSE.' ,    !19-22
C     7                '//'    , 'STARTSWITH' , '**', 'IOR',        !23-26
C     7                'IAND'  , 'IDECMASK', 'MOD' ,                !27-29   !Bop - 27
C
C     8                '.NOT.' ,   '+'   ,   '-'   , 'EXISTS' ,     !29-32   !Uop 1 - 4
C     9                '.IF.'  , 'REAL'  ,'INTEGER', '.VALUE.',     !33-36   !Uop 5 - 8
C     *                'CHARACTER','KEYWORD','UPPERCASE','FIRSTSTR',!37-40   !un 9-12
C     1                'FIRSTINT','SQRT','GETPATH','GETFILE',       !41-44   !un 13-16
C     2                'GETTITLE','FILEEXISTS','FILEDELETE',        !45-47   !un 17-19
C     3                'FILEISOPEN','GETEXTN','GETCWD','RANDOM' ,   !48-51   !un 20-23
C     4                'GETENV','COMPRESS','SPGTOCRY','ABS','PACK', !52-56   !un 24-28
C     5                'LEN'/                                       !57      !un 29
C
C $Log: not supported by cvs2svn $
C Revision 1.75  2013/09/19 21:35:39  rich
C Change precision of listing output where not important to reduce differences across platforms.
C Important changes - SFLS now uses builtin cos() and sin() functions rather than Chebyshev
C approximations.
C
C Revision 1.74  2013/03/21 15:42:56  djw
C Add new TRANSFER directive 'SHRIEK' to suppress  a ! and all following characters on the input line. Used
C to process SHELX comments in xshelxinand zshelxin
C
C Revision 1.73  2012/03/23 13:51:32  rich
C Intel support.
C
C Revision 1.72  2012/01/04 14:31:25  rich
C Fix some uninitialized variables, and output format mistakes.
C
C Revision 1.71  2011/09/21 09:46:42  rich
C Fix crash on script->use->script scenarios.
C
C Revision 1.70  2011/09/14 12:12:44  djw
C With VERIFY TRUE, re-declaration of an existing variable is signaled to the screen and listing file
C
C Revision 1.69  2011/09/13 13:03:39  rich
C Fix IDECMASK calculation
C
C Revision 1.68  2011/09/07 09:44:41  djw
C Change format of #SET OPENMESSAGE text so that columns line up across actions
C Add #SET CACHEMESSAGE (off/on) to inhibit caching information at termination
C Remove disc extension messages
C
C Revision 1.67  2011/09/05 12:34:21  rich
C Fix backslash forward slash detection in path names.
C
C Revision 1.66  2011/09/01 12:12:49  djw
C When the existing SCRIPT variable STACK is  to TRUE, provide more info about stack frame creation and seletion.
C
C Revision 1.65  2011/06/10 16:00:15  rich
C Avoid uninitialised script stack frames
C
C Revision 1.64  2011/05/04 11:31:29  rich
C Avoid buffer overflows in script string manipulation functions.
C
C Revision 1.63  2011/03/22 14:40:38  rich
C Added extra file unit 'SCP2' which may be read by new script command EXTRACT2
C
C Revision 1.62  2011/03/21 13:57:22  rich
C Update files to work with gfortran compiler.
C
C Revision 1.61  2009/12/07 10:55:11  djw
C Output script and calling-script names in script error messages.
C
C Revision 1.60  2009/07/02 09:20:27  djw
C Add character variable CFAMT for use with DFORM for outputting floating point variables
C
C Revision 1.59  2008/12/18 16:34:46  djw
C Add ABS(REAL) function
C
C Revision 1.58  2007/03/08 11:51:48  djw
C Increase filed in FORMAT expression
C
C Revision 1.57  2005/02/25 17:25:20  stefan
C 1. Added some preprocessor if defined lines for the mac version.
C
C Revision 1.56  2005/01/23 08:29:12  rich
C Reinstated CVS change history for all FPP files.
C History for very recent (January) changes may be lost.
C
C Revision 1.4  2005/01/17 14:59:42  rich
C Typo.
C
C Revision 1.3  2005/01/17 13:42:27  rich
C Bring new repository into line with old. (Extend SPGTOCRY script function).
C
C Revision 1.2  2004/12/13 16:16:08  rich
C Changed GIL to _GIL_ etc.
C
C Revision 1.1.1.1  2004/12/13 11:16:07  rich
C New CRYSTALS repository
C
C Revision 1.54  2004/10/22 11:00:23  rich
C Fix a type mismatch in KSCEXE. Remove all writes to NCAWU.
C
C Revision 1.53  2004/08/09 11:21:15  rich
C Uppercase variable name in KSCTRN. TRANSFER has unpredictable results
C if lowercase variable names were given.
C
C Revision 1.52  2004/03/02 15:13:03  rich
C Remove trailing zeroes after decimal point when converting floating point
C numbers to character strings, using script's CHARACTER unary operator.
C
C Revision 1.51  2004/02/24 15:49:09  rich
C Don't crash if FILEDELETE function fails.
C
C Revision 1.50  2003/11/20 13:02:58  rich
C Add new SCRIPT global character variable 'CTITLE' that evaluates
C to the name of the experiment title set by \TITLE.
C
C Revision 1.49  2003/11/06 15:48:37  rich
C When using IDECMASK operator in scripts always return absolute values.
C
C Revision 1.48  2003/09/04 14:14:28  rich
C Modify FIRSTINT function, so that it returns ZERO if no integer is
C found in the current string. This make the SHELX input work if there
C is an atom label with no digits in it.
C
C Modified the SPGTOCRY function to remove leading spaces before going
C to work on the Xprep style space group. Leads to a nicer formatting
C and allows us to at least ensure that there is a space after the
C lattice symbol.
C
C Revision 1.47  2003/07/03 10:41:04  rich
C Bug fixed: When top level scripts were called, the status bar shows them
C as being called from the last top level script that was run. Fix: Clear
C variables in between script runs.
C
C Revision 1.46  2003/07/01 16:43:34  rich
C Change IOR intrinsics to OR, similarly: IAND -> AND, INOT -> NOT. The "I"
C prefix is for INTEGER*2 (16 bit) types only, so could overflow when fed
C data from CRYSTALS' store. The unprefixed versions take any type and return
C the same type.
C
C Revision 1.45  2003/06/30 17:58:38  rich
C On abandoning script due to CRYSTALS error, or due to a script syntax error,
C print out the script source file line number where the failure occurred.
C
C Revision 1.44  2003/06/09 11:37:35  rich
C
C Two new unary operators for the CRYSTALS scripting language:
C
C SPGTOCRY - tries to convert an XPREP H-M space group string into a Larson
C style one. Ensures at least some of the correct spaces are there and
C gets rid of parenthesis. This routine could be extended to be more
C thorough as examples occur. Usage: EVALUATE STRING1 = SPGTOCRY ( STRING2 )
C
C COMPRESS - removes all redundant spaces from a script string. Nice for
C formatting some output. Usage: EVALUATE STRING1 = COMPRESS ( STRING2 )
C
C Revision 1.43  2003/05/07 12:18:55  rich
C
C RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
C using only free compilers and libraries. Hurrah, but it isn't very stable
C yet (CRYSTALS, not the compilers...)
C
C Revision 1.42  2003/02/27 11:41:16  rich
C
C Changes to KSCTRN so that it can be called safely when SCRIPTS aren't running.
C
C Revision 1.41  2003/01/14 10:22:39  rich
C Remove unimplemented FLOOR intrinsic
C
C Revision 1.40  2002/11/06 10:57:02  rich
C Updated FIRSTINT and FIRSTCHR to do an initial check for () in
C an atom string. These take precedence over alpha-numeric analysis
C so that SIP4(2) can be interpreted. If you have SIP42, you are lost.
C
C Revision 1.39  2002/10/31 13:25:26  rich
C New script binary operator - IDECMASK. Uses one decimal number to
C mask another: A IDECMASK B
C Any 0 digits in B will cause the corresponding digit in A to be set
C to zero, e.g. 987654 IDECMASK 101010 = 907050. Used for now to split
C up the GROUP and PART numbers from offset 14 of L5 records.
C
C Revision 1.38  2002/08/28 14:38:03  richard
C Added two new binary operators: IAND and IOR to do bitwise logical operations
C on integers. (Reals are just NINT'd first). E.g. 6 IAND 2 = 2, 4 IOR 2 = 6.
C
C Revision 1.37  2002/08/23 09:01:19  richard
C Put script name in the status bar.
C
C Revision 1.36  2002/03/11 14:45:54  ckp2
C RIC: Provided more reliable way of deleting files for script (updated FILEDELETE function)
C
C Revision 1.35  2002/03/06 10:57:46  ckp2
C USe CRYSTART.DAT if present. (Different from CRYSINIT, which gets used before
C the GUI is initialised). Remove initial space that script puts in output in TRANSFER
C to DISPLAY or PUNCH.
C
C Revision 1.34  2002/03/06 09:47:41  ckp2
C RIC: Changed operatin if the GETENV script function. Now it passes its argument
C to MTRNLG to expand any environment variables.
C
C Revision 1.33  2002/02/27 19:40:10  ckp2
C RIC: Increased input line length to 256 chars. HOWEVER - only a few modules know about
C this extra length. In general the program continues to ignore everything beyond
C column 80. The "system" commands (OPEN, RELEASE, etc.) do know about the extra length
C and can take extra long filenames as a result. The script processor also knows: lines
C in script files, the script input buffer and text output may now run up to 256 chars.
C RIC: THe system commands respect double-quotes around arguments, so that filenames can be
C given which contain spaces.
C
C Revision 1.32  2002/01/31 10:02:29  ckp2
C RIC: New script function CHAR2=GETENV(CHAR1) set CHAR2 to the value
C of the environment variable CHAR1.
C
C Revision 1.31  2002/01/30 15:24:48  ckp2
C RIC: Calls to MTRNLG in FILEEXISTS and FILEDELETE.
C
C Revision 1.30  2001/09/04 14:57:38  ckp2
C New TRANSFER destination:
C % TRANSFER 'STUFF' TO PUNCH
C puts the word STUFF into the PUNCH file. Brilliant!
C
C Revision 1.29  2001/03/08 14:37:50  richard
C  REAL = RANDOM ( 0.0 )  - the 0.0 doesn't do anything, but could be used
C as a seed in future...
C Fixed array bonds error when missing arguments to operators.
C
C Revision 1.28  2001/03/02 12:26:25  richard
C Added an exponentiation operator ** to scripts. Numerical types of both arguments
C and the result must all be the same.
C
C Revision 1.27  2001/01/25 11:34:42  richard
C RIC: FIxed bug. Array bounds error in FIRSTSTR and FIRSTINT if there was nothing
C to read.
C
C Revision 1.26  2001/01/19 12:55:07  richard
C Fixed call to KSCMSG when GET buffer overflows.
C
C Revision 1.25  2001/01/09 18:48:27  richard
C RIC: GET KEYWORD no longer resets from the end to the beginning of the line when used in
C conjunction with NOPROMPT, instead, the default value is used. If no default value, error.
C
C Revision 1.24  2000/12/11 12:22:52  richard
C RIC: Bug fix in KSCTRN. Recent changes stopped GENERALEDIT getting values
C in some cases. Fixed.
C
C Revision 1.23  2000/12/08 16:12:01  richard
C RIC: Modify KSCTRN to copy CHARACTER data into store for length longer than
C 1 byte. Default behaviour remains backwards compatible.
C
C Revision 1.22  2000/09/20 15:34:09  ckp2
C Removed debug statement
C
C Revision 1.21  2000/09/20 12:43:40  ckp2
C New OP - GETCWD - returns current directory to script variable.
C
C Revision 1.20  2000/01/20 17:00:37  ckp2
C djw  remove old diagnostic messages
C
C Revision 1.19  1999/12/23 17:29:25  ckp2
C djw  fix unwanted output in Monitor file
C
C Revision 1.18  1999/07/15 10:56:31  richard
C RIC: Added INPUT as an option for the "TRANSFER XXX TO" command. This fills
C the users input buffer with the value XXX so that it can be got with GET.
C
C Revision 1.17  1999/07/02 17:56:09  richard
C RIC: If there is a USER ERROR, then SCRIPTS ignores the SILENT keyword
C and prints allowed values and prompts anyway. Stops you from getting
C mysteriously stuck in GUI scripts.
C
C Revision 1.16  1999/06/06 15:43:58  dosuser
C RIC: Added a SILENT keyword to the GET command. This inhibits output
C of allowed value list, prompt string and the echoing of the command
C line. Used when a script is querying the UI. The user doesn't want to
C see all that rubbish on the screen.
C
C Revision 1.15  1999/06/03 17:24:43  dosuser
C RIC: Added Linux graphical interface support.
C
C Revision 1.14  1999/05/27 11:35:41  dosuser
C djw  Echo users input to text window
C
C Revision 1.13  1999/05/25 16:52:06  dosuser
C RIC: PATH splitting functions look for / on unix versions.
C FILEDELETE function calls 'rm' on unix versions.
C
C Revision 1.12  1999/05/21 15:40:48  dosuser
C RIC: Commented out debugging writes to unit 99.
C
C Revision 1.11  1999/05/13 18:03:13  dosuser
C RIC: Seven new unary operators:
C      CHAR = GETFILE (CHAR) Extracts the filename from a full path.
C      CHAR = GETPATH (CHAR) Extracts the directory from a full path.
C      CHAR = GETTITLE (CHAR) Extracts the stem of the filename
C                             from a full path e.g. CRFILE
C      CHAR = GETEXTN (CHAR) Extracts the extenstion of a filename
C                             from a full path e.g. DSC
C      LOGICAL = FILEEXISTS (CHAR) Tests whether a file exists.
C      LOGICAL = FILEISOPEN (CHAR) Tests whether a file is open already.
C      LOGICAL = FILEDELETE (CHAR) Deletes a file and tests success.
C
C Revision 1.10  1999/04/26 11:09:43  dosuser
C RIC: Added an ABS() funtion in the SQRT to prevent crashes.
C
C Revision 1.9  1999/04/26 11:08:16  dosuser
C RIC: Added a  SQRT (  ) function to scripts. Result and argument are
C      real. Program crashes if the argument is less than zero. Perhaps
C      an ABS function in the code wouldn't go amiss.
C
C Revision 1.8  1999/03/24 17:51:54  dosuser
C open/append changes
C
C Revision 1.7  1999/03/05 17:16:37  dosuser
C *** empty log message ***
C
C Revision 1.6  1999/02/23 20:05:13  dosuser
C RIC: Stopped the IBM box characters from going to the screen, in DOS
C      version, if Cameron is running. (They will be printed on a non-
C      terminal window).
C
C Revision 1.5  1999/02/16 11:24:06  dosuser
C RIC: Added log information to head of file.
C      Check return value when NSTART is computed. If 0 or -1, set to +1,
C      as it is used as a character string subscript - even if the
C      character string is empty.
C

CODE FOR KSCPRC
      FUNCTION KSCPRC ( CINPUT , IUSLEN )
C
C -- MAIN SCRIPT PROCESSING ROUTINE FOR CRYSTALS
C
C -- THIS ROUTINE TAKES THE INPUT LINES, READ FROM A SCRIPT FILE
C    AND GENERATES COMMANDS THAT CAN BE USED IN THE NORMAL WAY BY
C    CRYSTALS.
C
C -- INPUT ARGUMENTS :-
C
C      CINPUT      INPUT TEXT READ FROM SCRIPT FILE
C      IUSLEN      USEABLE LENGTH OF 'CINPUT'
C
C -- RETURN VALUE ( KSCPRC ) :-
C
C      -VE,0       GET NEW LINE FROM INPUT DEVICE IMMEDIATELY
C      +1          PRINT LINE IN BUFFER AS PLAIN TEXT
C      +2          TREAT DATA IN BUFFER AS A COMMAND
C      +3          SEND DATA IN BUFFER BACK TO SCRIPT PROCESSOR
C
C
C
C
      CHARACTER*(*) CINPUT
C
C
C
C      HISTORY
C            ( THIS HISTORY BEGINS WITH THE FIRST RELEASE VERSION OF
C            'SCRIPT'. THERE WERE A NUMBER OF IMPLEMENTATIONS, WHICH
C             HAVE LEFT OBVIOUS TRACES, BEFORE VERSION 1 )
C
C      VERSION           DATE        DESCRIPTION
C
C      1.00              MARCH 1985  INITIAL VERSION OF 'SCRIPT'
C
C      2.00              MAY 1985    INITIAL RELEASE OF VERSION 2.
C                                    THE ONLY MAJOR CHANGES WITH RESPECT
C                                    TO VERSION 1 ARE IN THE COMMENTS.
C
C      2.01                          ADD 'IDENTIFY' COMMAND. CORRECT
C                                    INPUT SYNTAX FOR 'CASE'.
C      2.02                          MOVE CONVERSION TO UPPERCASE, AND
C                                    REDUCE VOLUME CONVERTED.
C
C      2.10                          ADD NEW STACK ITEM 'JSTLVL'.
C      2.11                          DELETE REDUNDANT MESSAGE IN KSCADR.
C                                    IMPROVE INITIALISATION OF FIRST
C                                    STACK FRAME.
C                                    MAKE KSCSTK RETURN INFORMATION FROM
C                                    OUTER STACK FRAMES.
C
C      2.20                          INTRODUCE AN 'OUTWARD' SEARCH FOR
C                                    IDENTIFIERS
C
C      2.30                          ADD CHARACTER DATA TYPE, WITH
C                                    NECESSARY CHANGES TO EXPRESSION
C                                    EVALUATION ETC.
C                                    ADD 'TRANSFER' INSTRUCTION.
C                                    REMEMBER ENDS OF STRUCTURES.
C      2.31                          CONVERT ALL CALLS TO 'KSCEXP' TO
C                                    INCLUDE LOWERCASE COPY OF SOURCE
C                                    DATA FOR CHARACTER CONSTANTS.
C                                    ADD 'UPPERCASE' OPERATOR FOR
C                                    EXPRESSIONS
C      2.32                          CHECK ARGUMENTS IN XSCMSG. FIX
C                                    DIAGNOSTIC MESSAGE IN KSCEXE.
C                                    RENAME 'DIRECT' INTERRUPT TO
C                                     'QUIT'
C                                    MOVE SCRIPT UNIT NUMBERS TO XUNITS
C      2.33                          RENAME 'XSCPSH' AND 'XSCPOP' TO
C                                    'XSCFRM' AND 'XSCRST'. MINOR
C                                    CORRECTIONS TO EXPRESSIONS. ADD AN
C                                    AMBIGUITY CHECK IN 'KSCVAL'. REMOVE
C                                    REQUIREMENT FOR EACH CLASS OF
C                                    MESSAGE TO HAVE CONTIGUOUS NUMBERS
C
C      2.34                          RESTORE 'DIRECT' INTERRUPT
C
C      2.35                          ADD FACILITY FOR PROVIDING A
C                                    VALIDATION EXPRESSION IN 'GET'. ADD
C                                    NEW USER MESSAGE TYPE. USE
C                                    EXPRESSIONS FOR PROMPT AND DEFAULT
C                                    VALUE IN 'GET'. MAKE '>=' WORK.
C                                    CORRECTION TO AMBIGUITY CHECK IN
C                                    'KSCVAL'. HANDLE 'END ...' AFTER
C                                    ERROR FLAG SET.
C
C      2.50                          REMOVE ALL 'LABEL' INSTRUCTIONS.
C                                    REPLACE LARGE IF...ENDIF CONSTRUCTS
C                                    WITH COMPUTED GOTOS. CHECK LENGTH
C                                    OF DATA STORED IN BUFFER BY 'GET'
C                                    FIX UNARY '-' OF REAL VALUES; FIX
C                                    CASE OF 'NO DEFAULT' IN FIRST 'GET'
C
C       2.51       AUG 89            STORE SCRIPT NAME IN KSCSCT, AND
C                                    ENABLE SMG MENU SELECTION IN KSCVAL
C
C
C      *****************************************************************
C      *****                KNOWN PROBLEMS / ERRORS                *****
C      *****************************************************************
C
C      COMPONENT   PROBLEM/ERROR
C      ---------   -------------
C
C      TYPE        ISSUE OF A #TYPE COMMAND FROM AN SMG MENU IN A TASK
C                  WHICH HAS NOT BEEN INTO DIRECT MODE CAUSES THE FILE
C                  TO BE DISPLAYED WITHOUT WAITING FOR 'RETURNS' AFTER
C                  EACH PAGE.
C      FILE OPEN   FILE OPEN ERRORS FROM A TASK WHICH HAS BEEN IN DIRECT
C                  MODE CAUSE THE SCTIOT TO EXIT EVEN IF AN ERROR HANDLE
C                  IS SET.
C
C      SCRIPT      VERIFICATION OF LONG SCRIPT COMMAND LINES CAUSES
C                  OUTPUT OVERFLOW. LINES SHOULD BE BROKEN DOWN TO ONE
C                  SCREEN WIDTH.
C
C                  INSTRUCTIONS WHICH APPEND DATA TO INTERNAL COMMAND
C                  BUFFER SHOULD CHECK THAT THIS BUFFER HAS NOT BEEN
C                  OVERFILLED. ( 'INSERT', 'STORE' ETC. ) - DONE FOR
C                  'GET'
C
C                  WHEN AN ERROR IS DETECTED IN A BLOCK WITH NO ERROR
C                  CONTINGENCY, THE 'JWASEX' FLAG SHOULD BE SET, AS
C                  WELL AS CLEARING 'JEXECU', TO AVOID PROBLEMS WITH
C                  'ELSE'.
C
C                  WHEN EXECUTION OF A BLOCK IS ABANDONED BECAUSE OF AN
C                  ERROR, THERE SHOULD BE A CHECK TO SEE IF THE END OF
C                  THE CURRENT BLOCK IS KNOWN.
C
C      USER INPUT  THERE IS NO WAY OF CHANGING THE INTERRUPT STRINGS.
C
C                  THE INPUT ',1' AS A RESPONSE TO A 'GET REAL' DOES NOT
C                  GENERATE AN ERROR, BUT LEADS TO FAILURE LATER WHEN
C                  THE INPUT STRING IS ACTUALLY USED BY 'CRYSTALS'
C
C      'STORE'     USING 'STORE KEYWORD' WITH AN OUT OF RANGE EXPRESSION
C                  DOES NOT GENERATE AN ERROR.
C
C      IDENTIFIERS THERE IS NO CHECK THAT IDENTIFIERS ARE VALID. FOR
C                  INSTANCE, IDENTIFIERS LONGER THAN 12 CHARACTERS
C                  WILL NOT WORK, BUT THERE IS NO CHECK. THE FIRST
C                  CHARACTER OF ANY IDENTIFIER SHOULD BE ALPHABETIC
C
C      *****************************************************************
C
C
C
C
C      *****************************************************************
C      *****                BRIEF TABLE OF CONTENTS                *****
C      *****************************************************************
C
C      NAME        GROUP             DESCRIPTION
C      ----        -----             -----------
C      KSCPRC      MAIN              MAIN SCRIPT PROCESSOR ROUTINE
C
C      KSCACT      MISC              ACTIVATE CONTINGENCY
C      KSCADR      MISC              INPUT VARIABLE NAME
C      KSCCNT      COMMAND           'ON'
C      KSCELS      COMMAND           'ELSE'
C      KSCEST      EXPRESSIONS       PROCESS STANDARD VALUES
C      KSCETR      COMMAND           'EXTRACT'
C      KSCETR2     COMMAND           'EXTRACT'
C      KSCEVL      COMMAND           'EVALUATE'
C      KSCEXE      EXPRESSIONS       EXECUTE INTERPRETED EXPRESSION
C      KSCEXP      EXPRESSIONS       INTERPRET EXPRESSION
C      KSCEXT      COMMAND           'EXTERNAL'
C      KSCIDN      IDENTIFIERS       STORE/FIND IDENTIFIERS
C      KSCINT      INPUT PROCESSING  HANDLE INTERRUPTS
C      KSCINX      COMMAND           'INDEX'
C      KSCQUE      COMMAND           'QUEUE'
C      KSCREL      EXPRESSIONS       RELATIONAL FUNCTIONS
C      KSCSAD      STRINGS           ALLOCATE DESCRIPTOR
C      KSCSCD      STRINGS           MOVE CHARACTERS TO DESCRIPTOR
C      KSCSCT      COMMAND           'STRUCTURE' TYPE COMMANDS AND 'END'
C      KSCSDC      STRINGS           MOVE DESCRIPTOR TO CHARACTERS
C      KSCSDD      STRINGS           MOVE DESCRIPTOR TO DESCRIPTOR
C      KSCSET      COMMAND           'SET'
C      KSCSHW      COMMAND           'SHOW'
C      KSCSRE      STRINGS           RELATIONAL FUNCTIONS
C      KSCSTK      STACK             GET INFORMATION FROM STACK
C      KSCSTR      COMMAND           'STORE'
C      KSCTRA      COMMAND           'TRANSFER'
C      KSCTRN      MISC              TRANSFER DATA TO/FROM VARIABLE
C      KSCUMS      COMMAND           'MESSAGE'
C      KSCVAL      COMMAND           'GET'
C      KSCVAR      COMMAND           'VARIABLE'
C      XSCFRM      STACK             CREATE NEW STACK FRAME
C      XSCJMP      MISC              PERFORM JUMP TO LABEL
C      XSCMSG      MISC              OUTPUT DIAGNOSTIC MESSAGES
C      XSCRST      STACK             REMOVE CURRENT STACK FRAME
C      XSCSNM      MISC              GENERATE UNIQUE STRUCTURE NAME
C      XSCSTU      STACK             UPDATE CURRENT STACK FRAME
C
C      *****************************************************************
C
C
C
C
C      *****************************************************************
C      *****     ROUTINES INVOLVED IN EXECUTION OF EACH COMMAND    *****
C      *****************************************************************
C
C      ( EXECUTION ROUTINE IS SHOWN ONLY IF DIFFERENT FROM 'INPUT' )
C
C      COMMAND           INPUT       EXECUTION
C      -------           -----       ---------
C      BLOCK             KSCSCT
C      CASE              KSCSCT
C      IF                KSCSCT
C      LOOP              KSCSCT
C      SCRIPT            KSCSCT
C
C      ACTIVATE          KSCPRC      KSCACT
C      BRANCH            KSCPRC                        (OBSOLETE)
C      CLEAR             KSCPRC
C      COPY              KSCPRC
C      DECREMENT         KSCPRC                        (OBSOLETE)
C      ELSE              KSCELS
C      END               KSCPRC      KSCSCT
C      ERROR             KSCPRC                        (OBSOLETE)
C      EVALUATE          KSCEVL
C      EXECUTE           KSCPRC
C      EXTERNAL          KSCEXT
C      EXTRACT           KSCETR
C      EXTRACT2          KSCETR2
C      FINISH            KSCPRC
C      GET               KSCVAL
C      IDENTIFY          KSCPRC
C      INDEX             KSCINX
C      INSERT            KSCPRC
C      JUMP              KSCPRC                        (OBSOLETE)
C      LABEL             KSCPRC                        (OBSOLETE)
C      MESSAGE           KSCUMS
C      ON                KSCCNT
C      QUEUE             KSCQUE
C      SELECT            KSCPRC                        (OBSOLETE)
C      SEND              KSCPRC
C      SET               KSCSET
C      SHOW              KSCSHW
C      STORE             KSCSTR
C      TRANSFER          KSCTRA
C      VARIABLE          KSCVAR
C      VERIFY            KSCPRC
C
C      *****************************************************************
C
C
C
C
C      *****************************************************************
C      *****      ROUTINES INVOLVED IN EACH UTILITY FUNCTION       *****
C      *****************************************************************
C
C      FUNCTION          ROUTINE     ACTION
C      --------          -------     ------
C      EXPRESSIONS       KSCEXP      INTERPRET EXPRESSION. CONVERT INPUT
C                                    TEXT INTO A REVERSE POLISH ORDERED
C                                    LIST OF VALUES AND OPERATORS. CALL
C                                    'KSCEXE' TO CALCULATE VALUE. RETURN
C                                    CALCULATED VALUE.
C                        KSCEXE      EXECUTE INTERPRETED EXPRESSION. USE
C                                    THE OUTPUT OF 'KSCEXP' TO CALCULATE
C                                    EXPRESSION VALUE.
C                        KSCREL      RELATIONAL FUNCTIONS. EVALUATE
C                                    RELATIONS ( EQUALS, LESS THAN )
C                                    BETWEEN DATA ITEMS.
C                        KSCEST      PROCESS STANDARD VALUES. CONVERT
C                                    TEXT REPRESENTATIONS OF STANDARD
C                                    VALUES TO NUMERIC FORM.
C
C      IDENTIFIERS       KSCIDN      STORE IDENTIFIERS IN TABLE. LOCATE
C                                    IDENTIFIERS IN TABLE.
C
C      INPUT PROCESSING  KSCINT      HANDLE INTERRUPTS.
C
C      STACK             XSCFRM      CREATE NEW STACK FRAME. THE FRAME
C                                    IS GENERATED ACCORDING TO A SERIES
C                                    OF INSTRUCTIONS ENCODED IN DATA IN
C                                    THIS ROUTINE.
C      STACK             XSCRST      REMOVE CURRENT STACK FRAME. OUTER
C                                    FRAME IS USED TO CONTINUE EXECUTION
C      STACK             KSCSTK      GET INFORMATION FROM STACK. READ
C                                    ONE ITEM FROM CURRENT OR OUTER
C                                    STACK FRAME.
C      STACK             XSCSTU      UPDATE ONE ITEM IN CURRENT STACK
C                                    FRAME.
C
C      STRINGS           KSCSAD      ALLOCATE DESCRIPTOR.
C      STRINGS           KSCSCD      MOVE CHARACTERS TO DESCRIPTOR.
C      STRINGS           KSCSDC      MOVE DESCRIPTOR TO CHARACTERS
C      STRINGS           KSCSDD      MOVE DESCRIPTOR TO DESCRIPTOR
C      STRINGS           KSCSRE      RELATIONAL FUNCTIONS ON DATA HELD
C                                    IN DESCRIPTORS
C
C      MISC              KSCACT      ACTIVATE CONTINGENCY.
C      MISC              KSCADR      INPUT VARIABLE NAME. ( OBSOLETE
C                                    ROUTINE USED BY BRANCH, DECREMENT
C                                    ETC. )
C      MISC              KSCTRN      TRANSFER DATA TO/FROM VARIABLE.
C                                    INTERFACE TO REST OF 'CRYSTALS'
C      MISC              XSCJMP      PERFORM JUMP TO LABEL. ( OBSOLETE
C                                    ROUTINE USED BY 'JUMP' ETC. )
C      MISC              XSCMSG      OUTPUT DIAGNOSTIC MESSAGES FOR
C                                    SCRIPT INSTRUCTION SYNTAX ERRORS.
C      MISC              XSCSNM      GENERATE UNIQUE STRUCTURE NAME.
C
C      *****************************************************************
C
C
C
C
C      *****************************************************************
C      *****           USEFUL CHANGES THAT COULD BE MADE           *****
C      *****************************************************************
C
C      GENERAL     PRODUCE A SINGLE INPUT PROCESSING ROUTINE, TO HANDLE
C                  ALL SCRIPT COMMAND INPUT. THIS WOULD REMOVE LARGE
C                  AMOUNTS OF COMMON CODE.
C
C                  REMOVE LABEL PROCESSING CODE; THE COMMAND NAMES HAVE
C                  BEEN REMOVED, SO THE CODE IS INACCESSIBLE
C
C                  REMOVE OLD INSTRUCTIONS FOR MOVING TEXT, SUCH AS
C                  'COPY', 'INSERT' ETC., AND REPLACE BY 'TRANSFER'
C
C                  MAINTAIN AN ARRAY FOR GENERAL DATA STORAGE, SIMILAR
C                  TO 'STORE'/'ISTORE' IN THE MAIN PROGRAM.
C
C      EXPRESSIONS HOLD INTERMEDIATE CODE AND WORKING STACKS IN GENERAL
C                  STORAGE.
C
C                  DO NOT DESTROY INTERPRETED CODE DURING EXECUTION
C                  PHASE
C
C      STACK       BREAK STACK FRAME INTO FOUR COMPONENTS; GLOBAL FRAME
C                  FOR VERIFICATION CONSTANTS ETC., FILE FRAME FOR EACH
C                  FILE, STRUCTURE FRAME FOR EACH STRUCTURE, AND
C                  EXECUTION FOR EXPRESSION EVALUATION ETC.
C
C                  USE GENERAL STORAGE FOR STACK FRAMES.
C
C      *****************************************************************
C
C
C
C      *****************************************************************
C      *****              MORE SUBSTANTIAL EXTENSIONS              *****
C      *****************************************************************
C
C      VARIABLES   CREATE A MORE GENERAL FORM OF VARIABLE. THIS WOULD
C                  HAVE MORE PROPERTIES THAN THE EXISTING SORT, SUCH AS
C                  INTERNAL FORM :- INTEGER, REAL ETC.
C                  EXTERNAL FORM :- INTEGER, REAL, KEYWORD,
C                  VALIDATION :- VALID IF ( VALUE .GT. 0 )
C                  USAGE :- SOURCE , STORAGE , SINK
C                  USER INPUT :- MISSING IF ( VALUE .EQ. 0 );
C                        PROMPT = 'A PROMPT';
C                        DEFAULT = 'DEFAULT VALUE';
C                        READ_FROM = USER, FILE.
C                  DISPLAY :- TITLE = 'A TITLE';
C                        WRITE_TO = USER, FILE, CRYSTALS, SCRIPT;
C                        FORMAT = '(F10.5)'.
C                  E.G.  GENERALISE 'TRANSFER' INSTRUCTION :-
C                          DECLARE VARIABLE A WITH TYPE=CHARACTER,
C                            USAGE=SOURCE, PROMPT="A", READ_FROM=USER,
C                            DEFAULT="FINISH"
C                          DECLARE VARIABLE COMMAND WITH TYPE=CHARACTER,
C                            USAGE=SINK, WRITE_TO=CRYSTALS
C                          TRANSFER A TO COMMAND
C                        GENERATES THE PROMPT
C                          A (TEXT) [ FINISH ] :
C                        AND AUTOMATICALLY TRANSFERS THE RESULT TO
C                        CRYSTALS.
C
C                  IN ADDITION, THOSE VARIABLES WHICH ONLY NEED TO BE
C                  INITIALISED ONCE COULD BE HANDLED IN A CONSISTENT
C                  FASHION THROUGHOUT A SERIES OF SCRIPTS. ( SEE THE
C                  CURRENT USAGE OF 'RADIATION' ) THIS WOULD BE FURTHER
C                  IMPROVED IF THE DEFINITIONS OF THE VARIABLES COULD
C                  BE EXTERNAL TO THE SCRIPT, AND STORED IN A CENTRAL
C                  AREA.
C
C
C      CONTROL     CREATE A NEW TYPE OF OBJECT, 'STATE'. THIS IS
C                  MODIFIED BY PROCEDURES, WHICH HAVE CERTAIN SPECIFIED
C                  INITIAL 'STATE' REQUIREMENTS, AND GENERATE SPECIFIED
C                  FINAL 'STATES'. CERTAIN STATES COUL OBVIOUSLY BE
C                  LINKED TO THE PRESENCE/ABSENCE OF DATA. E.G. IF THERE
C                  IS A VALID LIST 1, THE STATE 'CELLPRESENT' IS TRUE.
C                  THE PROCEDURE 'READCELL' WOULD CREATE THIS STATE.
C                  IF ANOTHER PROCEDURE, OR ANY OTHER PART OF A SCRIPT,
C                  REQUIRED THIS STATE TO EXIST, 'READCELL' COULD BE
C                  CELLED TO ACHIEVE THIS. 'CELLPRESENT' SHOULD
C                  CERTAINLY BE PRESENT BEFORE DATA REDUCTION IS
C                  ATTEMPTED. THIS WOULD AUTOMATE THE CHECKING AND
C                  ACQUISITION OF DATA REQUIRED FOR THE EXECUTION OF
C                  EACH PHASE; A STATEMENT OF WHAT STATES WERE REQUIRED
C                  SHOULD BOTH CHECK THAT THOSE STATES WERE ENABLED, AND
C                  EXECUTE WHATEVER PROCEDURES WERE NECESSARY TO GET THE
C                  MISSING DATA.
C
C      *****************************************************************
C
C
C
C
C
C -- GENERAL NOTES ON VARIABLE DESCRIPTIONS
C
C      FLAGS ARE 'SET' WHEN THEIR VALUE IS 1, AND 'CLEAR' WHEN
C      IT IS ZERO.
C
C -- VARIABLES USED IN 'SCRIPT' GENERALLY
C
C      IDENTIFIERS
C            MAXLAB      MAXIMUM SIZE OF AN IDENTIFIER
C
C      STACK OFFSETS. THESE QUANTITIES INDENTIFY ITEMS TO BE READ FROM
C      THE STACK.
C            JVARIB      HIGHEST IDENTIFIER NUMBER CURRENTLY IN USE
C            JNVARI      NUMBER OF IDENTIFIERS USED IN THE CURRENT
C                        BLOCK
C            JNFDAT      NEXT FREE DATA LOCATION ( NOT USED )
C            JNFCHR      NEXT FREE CHARACTER LOCATION ( NOT USED )
C            JEXECU      EXECUTION FLAG. IF SET, STATEMENTS IN THE
C                        CURRENT BLOCK ARE BEING EXECUTED
C            JBTYPE      TYPE OF CURRENT STATEMENT BLOCK
C            JBSTRT      STARTING RECORD NUMBER OF CURRENT BLOCK
C            JBLEND      ENDING ADDRESS OF CURRENT BLOCK
C            JNSTAT      RELATIVE STATEMENT NUMBER IN CURRENT BLOCK
C            JREQST      REQUIRED STATEMENT NUMBER IN CURRENT BLOCK
C                        ( JNSTAT AND JREQST ARE USED BY 'CASE'. IF
C                        JREQST = 0, ALL STATEMENTS ARE TO BE EXECUTED )
C            JWASEX      PAST EXECUTION FLAG. IF SET, SOME PART OF THE
C                        CURRENT STATEMENT BLOCK HAS BEEN EXECUTED. THIS
C                        IS USED BY 'IF' ... 'ELSE IF' ETC.
C            JSTLVL      CURRENT STACK LEVEL. THIS ALLOWS ROUTINES TO
C                        FIND OUT HOW MANY STACK LEVELS EXIST
C
C      SCRIPT MESSAGE CODES. THESE CODES ARE PASSED TO 'XSCNSG' WHICH
C      CAN CONVERT THEM INTO READABLE TEXT. THESE MESSAGES ARE DESIGNED
C      FOR SYNTAX ERRORS IN THE SCRIPT, RATHER THAN FOR 'ERRORS' FOUND
C      IN THE INPUT OF THE EVENTUAL USER. THE CODES ARE NOT LISTED
C      INDIVIDUALLY HERE. THEY ARE DEFINED BY PARAMETER STATEMENTS, AND
C      THE TEXT CORRESPONDING TO EACH CAN BE FOUND IN THE ROUTINE XSCMSG
C
C      TEXT BUFFERS. THERE ARE THREE MAIN BUFFERS, OF WHICH TWO ARE KEPT
C      IN TWO FORMS ( ALL UPPERCASE, AND AS ENTERED ).
C            LENLIN      MAXIMUM LENGTH OF A SCRIPT SOURCE FILE LINE,
C                        AND THE MAXIMUM LENGTH OF A COMMAND THAT CAN BE
C                        PASSED BACK TO 'CRYSTALS'
C            LENDIR      MAXIMUM LENGTH OF A SCRIPT DIRECTIVE
C
C            CUPPER      ALL UPPERCASE COPY OF CURRENT SCRIPT DIRECTIVE
C            CLOWER      AS ENTERED COPY OF CURRENT SCRIPT DIRECTIVE
C            IDIRPS      CURRENT PROCESSING POSITION IN CURRENT
C                        DIRECTIVE
C            IDIRLN      LAST USEFUL POSITION IN CURRENT DIRECTIVE
C
C            CCOMBF      'COMMAND' BUFFER. IN THE BUFFER THE SCRIPT
C                        PROCESSOR BUILDS UP DATA TO BE SENT TO
C                        CRYSTALS.
C            ICOMPS      ( NOT USED )
C            ICOMLN      LENGTH OF COMMAND BUFFER. THIS VARIABLE POINTS
C                        TO THE CURRENT END OF THE COMMAND BUFFER
C
C            CUINPB      ALL UPPERCASE COPY OF THE 'USER INPUT' BUFFER.
C                        ANY INPUT FROM THE END USER IS PLACED IN THIS
C                        BUFFER BEFORE PROCESSING
C            CLINPB      AS ENTERED COPY OF USER INPUT BUFFER
C            IINPPS      CURRENT POSITION IN USER INPUT BUFFER
C            IINPLN      LAST USEFUL POSITION IN INPUT BUFFER
C
C      'ALLOWED VALUE' LIST. THIS IS SET BY THE SCRIPT COMMAND 'VERIFY',
C      AND USED PRINCIPALLY BY THE COMMAND 'GET' TO CHECK USER INPUT.
C            CCHECK      CHARACTER ARRAY CONTAINING ALLOWED VALUES
C            NCHKUS      NUMBER OF ELEMENTS OF CCHECK THAT ARE CURRENTLY
C                        DEFINED.
C            NCHK        PARAMETER DEFINING NUMBER OF ELEMENTS IN CCHECK
C            LCHK        PARAMETER DEFINING LENGTH OF EACH ELEMENT OF
C                        CCHECK
C
C      'GLOBAL FLAGS'. THESE FLAGS ARE USED THROUGHOUT 'SCRIPT', MAINLY
C      AS FLAGS FOR VERIFICATION AND OTHER GLOBAL CONTROL FUNCTIONS.
C
C            ISCMSG      IF SET, ENABLE OUTPUT OF MESSAGES BY 'XSCMSG'
C            ISCFST      IF SET, ENABLE 'FAST LABEL SEARCH' MODE. THIS
C                        MODE ATTEMPTS TO FIND THE LABEL IN A LIST OF
C                        KNOWN LABELS.
C            ISCCOM      CURRENT SCRIPT DIRECTIVE
C            ISCSER      IF SET, LABEL SEARCH IS IN PROGRESS. STATEMENTS
C                        ENCOUNTERED WILL NOT BE EXECUTED.
C            ISCVAL      VALUE OF LAST USER INPUT FROM 'GET'
C            ISCVTP      TYPE ( INTEGER/REAL ETC. ) OF LAST USER INPUT
C            ISCVLS      STARTING ADDRESS IN INPUT BUFFER OF LAST USER
C                        INPUT
C            ISCVLN      LENGTH OF STRING REPRESENTATION OF LAST USER
C                        INPUT
C            ISCINI      IF SET, CURRENT SCRIPT HAS BEEN INITIALISED.
C                        THIS FLAG IS CLEARED WHEN EACH SCRIPT FILE
C                        IS STARTED, AND SET WHEN THE 'SCRIPT' STRUCTURE
C                        IS ENCOUNTERED
C            ISCEVE      IF SET, EXPRESSION EVALUATION VERIFICATION IS
C                        ENABLED
C            ISCVER      IF SET, INPUT COMMAND VERIFICATION IS ENABLED
C            ISCSVE      IF SET, STACK OPERATION VERIFICATION IS ENABLED
C            ISCIVE      IF SET, IDENTIFIER TABLE OPERATION VERIFICATION
C                        IS ENABLED
C            ISCDSB      IF SET, STACK OPERATIONS SHOULD NOT BE
C                        ATTEMPTED. THIS FLAG IS USED AFTER 'END
C                        SCRIPT', 'FINISH', AND 'QUEUE PROCESS' TO STOP
C                        OPERATIONS ON INVALID STACK FRAMES.
C
C      'USER MESSAGES'. THESE ARE THE MESSAGES THAT ARE DISPLAYED TO
C      THE 'END USER' IN CERTAIN CIRCUMSTANCES, SUCH AS INPUT ERROR,
C      OR ( OPTIONALLY ) CONTINGENCY ACTIVATION. THE INITIAL TEXTS
C      OF THESE MESSAGES CAN BE CHANGED USING THE 'MESSAGE' COMMAND
C
C            CSCMSG      CHARACTER ARRAY CONTAINING MESSAGE TEXTS. THE
C                        ELEMENTS ARE 80 CHARACTERS LONG
C            LSCMSG      INTEGER ARRAY CONTAINING THE USEFUL LENGTH
C                        OF EACH MESSAGE IN CSCMSG
C            NSCUMS      PARAMETER DEFINING NUMBER OF ELEMENTS IN CSCMSG
C                        WHICH ARE OUTPUT BY 'GET'
C            NSCMSG      PARAMETER DEFINING TOTAL NUMBER OF ELEMENTS IN
C                        CSCMSG
C
C
C
C
C -- VARIABLES USED IN THIS ROUTINE
C
C      CVARIB      USED AS SCRATCH STORAGE FOR VARIABLE NAMES
C      CLABEL      USED AS SCRATCH STORAGE FOR LABELS
C      CSERCH      THE CURRENT SEARCH LABEL. WHEN A LABEL SEARCH IS
C                  BEGUN, THE LABEL REQUIRED IS PLACED IN 'CSERCH'
C                  AND THE SEARCH FLAG 'ISCSER' IS SET
C
C      CCONTU      THIS DEFINES THE CONTINUATION CHARACTER '-'
C      CSPACE      THIS CONTAINS A SPACE ' '
C      CSCRPT      THIS DEFINES THE SCRIPT INSTRUCTION INDICATOR '%'
C
C      CMMNDS      THIS CHARACTER ARRAY CONTAINS THE NAMES OF THE
C                  SCRIPT COMMANDS
C      CSTRUC      THIS CHARACTER ARRAY CONTAINS THE NAMES OF THE
C                  STATEMENT BLOCK TYPES
C
C      IVERSN      SCRIPT PROCESSOR VERSION NUMBER
C
C
C      FOR EACH COMMAND THERE IS AN INTEGER VARIABLE WITH A NAME OF
C      THE FORM 'ICXXXX' WHERE XXXX IS AN ABBREVIATION OF THE COMMAND
C      NAME, WHICH IS AN INDEX OF THE COMMAND NAME IN 'CMMNDS'.
C      E.G. FOR 'LABEL', ( = CMMNDS(1) ) , ICLABE = 1
C
C
C
C
C -- RELATIONSHIPS BETWEEN 'SCRIPTS' AND THE REST OF 'CRYSTALS',
C    AND 'SCRIPTS' AND THE 'FINAL USER'
C
C      AS FAR AS THE REST OF 'CRYSTALS' IS CONCERNED, THE SCRIPT
C      PROCESSOR SHOULD APPEAR :-
C
C            1)    TO ABSORB ALL COMMAND LINES WHICH 'KRDREC' PASSES
C                  TO IT
C            2)    TO GENERATE A SERIES OF 'CRYSTALS' COMMAND INPUT
C                  WHICH CAN BE EXECUTED.
C
C
C      TO THE 'FINAL USER' ( I.E. THE PERSON TO WHOM 'KSCVAL' ADDRESSES
C      ITS QUESTIONS ) THE SCRIPT PROCESSOR SHOULD APPEAR :-
C
C            1)    TO BE GENERATING A SERIES OF QUESTIONS
C            2)    TO BE GENERATING OUTPUT DEPENDING ON THE ANSWERS
C
C      THERE SHOULD BE NO DIFFERENCE AS FAR AS THE REST OF 'CRYSTALS'
C      IS CONCERNED, BETWEEN THE BEHAVIOUR OF A NORMAL USER TYPING IN
C      COMMANDS IN AN INTERACTIVE JOB AND THE SCRIPT PROCESSOR
C      GENERATING COMMANDS. THIS SIMILARITY SHOULD BE EVEN GREATER THAN
C      NORMALLY EXISTS BETWEEN INPUT FROM AN INTERACTIVE TERMINAL AND
C      FROM A 'USE' FILE, BECAUSE THE SCRIPT PROCESSOR CAN RESPOND TO
C      ERROR CONDITIONS. FOR THIS REASON, THE ONLY PART OF 'CRYSTALS'
C      WHICH NEEDS TO KNOW THAT A SCRIPT IS BEING PROCESSED IS 'KRDREC'.
C
C
C
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCSTK.INC'
      INCLUDE 'PSCMSG.INC'
C
      CHARACTER*(MAXLAB) CVARIB
      CHARACTER*(MAXLAB) CLABEL
      CHARACTER*(MAXLAB) CSERCH
C
      CHARACTER*1 CCONTU , CSPACE , CSCRPT
C
C
CJAN99
      PARAMETER ( LCOM = 10 , NCOM = 32 )
      CHARACTER*(LCOM) CMMNDS(NCOM)
C
      PARAMETER ( LSTRUC = 12 , NSTRUC = 5 )
      CHARACTER*(LSTRUC) CSTRUC(0:NSTRUC)
C
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCCHK.INC'
      INCLUDE 'XSCGBL.INC'
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XOPVAL.INC'
C
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XSCMSG.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      SAVE CSERCH
C
C
      DATA CCONTU / '-' / , CSPACE / ' ' / , CSCRPT / '%' /
C
C
      DATA CMMNDS /   '          ' , 'ACTIVATE  ' , 'COPY      ' ,
     2 'CLEAR     ' , 'INSERT    ' , 'SEND      ' , 'GET       ' ,
     3 'VERIFY    ' , '          ' , '          ' , '          ' ,
     4 '          ' , 'FINISH    ' , 'END       ' , 'QUEUE     ' ,
     5 'ON        ' , 'STORE     ' , 'VARIABLE  ' , 'SET       ' ,
     6 'EXTERNAL  ' , 'ELSE      ' , '          ' , 'EXECUTE   ' ,
     7 'SHOW      ' , 'EVALUATE  ' , 'MESSAGE   ' , 'INDEX     ' ,
CJAN99
     8 'EXTRACT   ' , 'IDENTIFY  ' , 'TRANSFER  ' , 'OUTPUT    ' ,
     8 'EXTRACT2  '/
C
      DATA                ICLABE /  1 /, ICACTI /  2 /, ICCOPY /  3 /
      DATA ICCLEA /  4 /, ICINSE /  5 /, ICSEND /  6 /, ICGET  /  7 /
      DATA ICVERI /  8 /, ICERRO /  9 /, ICJUMP / 10 /, ICBRAN / 11 /
      DATA ICDECR / 12 /, ICFINI / 13 /, ICEND  / 14 /, ICQUEU / 15 /
      DATA ICON   / 16 /, ICSTOR / 17 /, ICVARI / 18 /, ICSET  / 19 /
      DATA ICEXTE / 20 /, ICELSE / 21 /, ICSELE / 22 /, ICEXEC / 23 /
      DATA ICSHOW / 24 /, ICEVAL / 25 /, ICMESS / 26 /, ICINDE / 27 /
CJAN99
      DATA ICEXTR / 28 /, ICIDEN / 29 /, ICTRAN / 30 /, ICOUTP / 31 /
C
      DATA CSTRUC / '<Special>' , 'SCRIPT' , 'BLOCK' , 'LOOP' ,
     2 'IF' , 'CASE' /
C
      DATA IVERSN / 251 /
C
      DATA CSERCH / ' ' /
C
C
C
C
C -- CLEAR STACK OPERATION DISABLE FLAG
      ISCDSB = 0
C
C
C -- SET DEFAULT ACTION WITH INPUT LINE. THIS IS TO TYPE IT, UNLESS WE
C    ARE SEARCHING FOR A LABEL. ALSO SET NUMBER OF COMMAND VERBS FOR
C    WHICH WE WILL CHECK
C
      IF ( ISCINI .GT. 0 ) THEN
        IEXECU = KSCSTK ( JEXECU , 0 )
      ELSE
        IEXECU = 0
      ENDIF
C
      IF ( ISCSER .GT. 0 ) THEN
C
C -- THE FOLLOWING METHOD CAN SPEED UP THE LOCATION OF LABELS
C    CONSIDERABLY.
C
        KSCPRC = 0
        IF ( CINPUT(1:6) .NE. '%LABEL' ) RETURN
      ELSE IF ( IEXECU .LE. 0 ) THEN
        KSCPRC = 0
      ELSE
        KSCPRC = 1
      ENDIF
C
C -- CHECK FOR ERRORS.
      IF ( IERFLG .LT. 0 ) THEN
C
C -- CHECK IF AN ERROR CONTINGENCY HAS BEEN DECLARED AT THIS LEVEL
        ISTAT = KSCACT ( 'ERROR' )
        IF ( ISTAT .GT. 0 ) THEN
C
C -- CONTINGENCY FOUND AND PROCESSED
C -- CLEAR SYSTEM ERROR FLAG
          IERFLG = 1
C
          KSCPRC = 0
C
C -- IF THE POSITION IN THE FILE IS BEING ADJUSTED, IMMEDIATE RETURN
C    BEFORE TOO MUCH DAMAGE IS CAUSED
          IF ( IRDFND(IFLIND) .NE. 0 ) THEN
            RETURN
          ENDIF
C
C -- IF THIS IS A SCRIPT TYPE BLOCK, AN ERROR HANDLING LABEL MAY HAVE
C    BEEN DECLARED. EITHER JUMP TO SPECIFIED LABEL, OR CLOSE SCRIPT
C    FILE AT THIS POINT.
C
C -- IF THERE IS NO ERROR LABEL, THE CURRENT SCRIPT FILE IS CLOSED.
C    IN THIS CASE, THE SYSTEM ERROR FLAG IS STILL SET, SO OUTER SCRIPTS
C    MAY STILL HAVE CONTINGENCIES/ERROR LABELS TO HANDLE THE ERROR.
C
C -- IF THERE IS AN ERROR LABEL, THE SYSTEM ERROR FLAG IS CLEARED, AND
C    THE SPECIFIED ERROR LABEL IS SEARCHED FOR.
C
        ELSE IF ( KSCSTK ( JBTYPE , 0 ) .EQ. 1 ) THEN
          ISTAT = KSCIDN ( 2, 1, 'ERROR', 3, I, IDENT, IERROR, -1 )
          IF ( ISTAT .LE. 0 ) THEN
            IDIRLN = 0
            CALL XFLUNW ( 2 , 2 )
            KSCPRC = 0
            RETURN
          ELSE
            IERFLG = 1
            ISTAT = KSCIDN ( 3, 1, CSERCH, 2, I, IERROR , IRECRD , 1 )
            CALL XSCJMP ( CSERCH )
            KSCPRC = 0
          ENDIF
        ELSE
C
C -- A BLOCK TYPE OTHER THAN 'SCRIPT', WITH NO CONTINGENCY DECLARED.
C    DEACTIVATED EXECUTION, AND CONTINUE READING THROUGH FILE.
          CALL XSCSTU ( JEXECU , 0 )
          KSCPRC = 0
        ENDIF
C
      ENDIF
C
C
C
C                      ******************
C                      * INPUT CHECKING *
C                      ******************
C
C
C
C -- BLANK LINES >> IMMEDIATE RETURN
C
      IF ( IUSLEN .LE. 0 ) RETURN
C
C -- MOVE INPUT TEXT INTO SCRIPT DIRECTIVE BUFFER.
      CLOWER(IDIRLN+1:) = CINPUT(1:IUSLEN)
      IDIRLN = IDIRLN + IUSLEN
C
C -- TEXT IS PROCESSED IMMEDIATELY
      IF ( CLOWER(1:1) .NE. CSCRPT ) THEN
        IDIRLN = 0
        RETURN
      ENDIF
C
C
C -- CHECK FOR A CONTINUATION MARK AT THE END OF THE LINE. IF THERE IS
C    ONE, ADJUST LINE LENGTH ( SO CONTINUATION MARK DOES NOT FORM PART
C    OF DIRECTIVE TO BE EXECUTED ) AND RETURN CONTROL SO THE NEXT PART
C    OF THE DIRECTIVE CAN BE FETCHED.
C
      IF ( CLOWER(IDIRLN:IDIRLN) .EQ. CCONTU ) THEN
        IDIRLN = IDIRLN - 1
        KSCPRC = 0
        RETURN
      ENDIF
C
C -- SET POINTERS ( CHARACTER 1 HAS ALREADY BEEN PROCESSED )
      IDIRPS = 2
C
C -- ECHO LINE IF VERIFY ENABLED
C -- ECHO LINE, IF VERIFY IS ENABLED AND THE LINE IS GOING TO BE
C    EXECUTED.
C
      IF ( ( ISCVER .GT. 0 ) .AND. ( ISCSER .LE. 0 ) .AND.
     2     ( IEXECU .GT. 0 ) ) THEN
        WRITE ( CMON, 1005) CLOWER(1:IDIRLN)
        CALL XPRVDU(NCVDU, 1,0)
1005    FORMAT ( 1X , A )
      ENDIF
C
C
C -- WE HAVE A DIRECTIVE TO BE PROCESSED HERE. CHECK FIRST FOR COMMENTS
C    AND LABELS. IF WE ARE NOT SEARCHING FOR A LABEL, WE THEN GO ON TO
C    CHECK OTHER POSSIBLE DIRECTIVES.
C
      IRDLIN = 0
C
C -- DETECT COMMENT LINES. THESE ARE IGNORED, AND CONTROL RETURNS TO
C    'CRYSTALS'. EMPTY LINES, CONTAINING ONLY '%', ARE TREATED
C    IN THE SAME WAY.
C
      IF ( CLOWER(IDIRPS:IDIRPS) .EQ. CSCRPT ) THEN
        IDIRLN = 0
        KSCPRC = 0
        RETURN
      ENDIF
C
C -- EXTRACT DIRECTIVE NAME FROM INPUT.
      LENGTH = KCCARG ( CLOWER , IDIRPS , 1 , NDIREC , NEND )
      IF ( LENGTH .LE. 0 ) THEN
        IDIRLN = 0
        KSCPRC = 0
        RETURN
      ENDIF
C
C -- CONVERT THE DIRECTIVE TO UPPERCASE
C
      CALL XCCUPC ( CLOWER(1:IDIRLN) , CUPPER(1:IDIRLN) )
      IF ( IDIRLN .LT. LEN ( CLOWER ) ) THEN
        CUPPER(IDIRLN+1:) = ' '
      ENDIF
C
C -- COUNT THIS DIRECTIVE
      IF ( ISCINI .GT. 0 ) THEN
        ICOUNT = KSCSTK ( JNSTAT , 0 ) + 1
        CALL XSCSTU ( JNSTAT , ICOUNT )
C
C -- HANDLE STRUCTURE BLOCKS WHERE A SINGLE INSTRUCTION IS ENABLED
C    E.G. 'CASE'
C
        IREQST = KSCSTK ( JREQST , 0 )
        IF ( IREQST .GT. 0 ) THEN
          IF ( IREQST .EQ. ICOUNT ) THEN
            CALL XSCSTU ( JEXECU , 1 )
            IEXECU = 1
          ELSE
            CALL XSCSTU ( JEXECU , 0 )
            IEXECU = 0
          ENDIF
        ENDIF
      ENDIF
C
C -- CHECK DIRECTIVE AGAINST ALLOWED LIST
C    THE DIRECTIVE NAME IS CHECKED FIRST AGAINST THE LIST OF COMMANDS,
C    AND THEN AGAINST THE LIST OF STRUCTURE NAMES. IF IT IS A STRUCTURE
C    NAME, THE 'BEGIN NEW STRUCTURE' ROUTINE IS CALLED, AND CONTROL
C    RETURNS TO 'CRYSTALS'.
C
      ISCCOM = KCCOMP ( CUPPER(NDIREC:NEND) , CMMNDS , NCOM , 1 )
      IF ( ISCCOM .LE. 0 ) THEN
        ISCSTR = KCCOMP ( CUPPER(NDIREC:NEND), CSTRUC(1), NSTRUC, 1 )
        IF ( ISCSTR .GT. 0 ) THEN
          ISTAT = KSCSCT ( ISCSTR , 1 )
          IDIRLN = 0
          KSCPRC = 0
          RETURN
        ELSE
          IF ( ISCSER .LE. 0 ) GO TO 9910
        ENDIF
      ENDIF
C
C
C            **** COMMAND PROCESSING ****
C
C -- CHECK FOR INITIALISATION. FIRST EXECUTABLE COMMAND IN EACH SCRIPT
C    MUST BE 'SCRIPT'
C
      IF ( ISCINI .LE. 0 ) GO TO 9994
C
C -- 'END'
C
      IF ( ISCCOM .EQ. ICEND ) THEN
C
C -- 'END' SHOULD BE FOLLOWED BY A STRUCTURE NAME, AND THAT NAME SHOULD
C    CORRESPOND TO THE ONE THAT STARTED THE CURRENT BLOCK.
C
        LENSTR = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
        IF ( LENSTR .LE. 0 ) GO TO 9980
C
        ISTRUC = KCCOMP ( CUPPER(NARG:NEND), CSTRUC(1), NSTRUC, 1 )
        IF ( ISTRUC .LE. 0 ) GO TO 9990
C
C -- CHECK STRUCTURE TYPE TO BE ENDED IS SAME AS CURRENT TYPE
        ICTYPE = KSCSTK ( JBTYPE , 0 )
        IF ( ICTYPE .GT. NSTRUC ) ICTYPE = 0
        IF ( ISTRUC .NE. ICTYPE ) GO TO 9992
C
        ISTAT = KSCSCT ( ISTRUC , 2 )
C
        IF ( ISCSER .GT. 0 ) GO TO 9930
C
        KSCPRC = 0
C
C -- 'LABEL'
C
      ELSE IF ( ISCCOM .EQ.  ICLABE ) THEN
        LENLAB = KCCARG ( CUPPER , IDIRPS , 1 , NLABEL , NEND )
        IF ( LENLAB .LE. 0 ) GO TO 9940
C
        CLABEL = CUPPER(NLABEL:NEND)
C
        IF ( ISCVER .GT. 0 ) THEN
          WRITE ( CMON, 1015) CLABEL , IRDREC(IFLIND)
          CALL XPRVDU(NCVDU, 1,0)
1015      FORMAT ( 1X , 'Label ' , A , ' found in record ' , I5 )
        ENDIF
C
        ISTAT = KSCIDN ( 1, 1, CLABEL, 2, 0, IDENT, IRDREC(IFLIND), 0 )
C
C -- CHECK LABEL FOUND IF SEARCH IS IN PROGRESS
        IF ( ( ISCSER .GT. 0 ) .AND. ( CLABEL .EQ. CSERCH )  ) THEN
          ISCSER = 0
        ENDIF
C
        KSCPRC = 0
C
C -- 'ELSE'
C
      ELSE IF ( ISCCOM .EQ. ICELSE ) THEN
C
        KSCPRC = KSCELS ( IN )
C
      ENDIF
C
C
C -- IF WE ARE IN THE MIDDLE OF A SEARCH, END PROCESSING NOW
C -- IF THIS IS PART OF A LABEL SEARCH, OR THE INSTRUCTIONS IN THE
C    CURRENT BLOCK ARE NOT BEING EXECUTED, WE CAN STOP PROCESSING THE
C    CURRENT DIRECTIVE NOW. NOTE THAT 'END' AND 'LABEL' MUST ALWAYS
C    BE PROCESSED. THE END OF THE CURRENT BLOCK MAY ( IMPLICITLY )
C    RE-ENABLE COMMAND PROCESSING, AND A 'LABEL' INSTRUCTION MAY
C    RESOLVE A LABEL SEARCH.
C
C
C -- CHECK IF EXECUTION IS DISABLED FOR THIS CONTROL STRUCTURE
C
      IF ( ( ISCSER .GT. 0 ) .OR. ( IEXECU .LE. 0 ) ) THEN
        KSCPRC = 0
        GO TO 8000
      ENDIF
C
C
C
C            END OF SPECIAL COMMAND PROCESSING. REMAINING COMMANDS
C            ARE EXECUTED ONLY IF NOT IN LABEL SEARCH MODE
C
C       (LABEL)     ,  ACTIVATE    ,  COPY        ,
C       CLEAR       ,  INSERT      ,  SEND        ,  GET         ,
C       VERIFY      ,  (ERROR)     ,  (JUMP)      ,  (BRANCH)    ,
C       (DECREMENT) ,  FINISH      ,  END         ,  QUEUE       ,
C       ON          ,  STORE       ,  VARIABLE    ,  SET         ,
C       EXTERNAL    ,  ELSE        ,  (SELECT)    ,  EXECUTE     ,
C       SHOW        ,  EVALUATE    ,  MESSAGE     ,  INDEX       ,
CJAN99
C       EXTRACT     ,  IDENTIFY    ,  TRANSFER    ,  OUTPUT ,  
C       EXTRACT2 /
C
      GO TO ( 8000 , 4030 , 4040 ,
     2 4120 , 4050 , 4090 , 4070 ,
     3 4170 , 4010 , 4130 , 4140 ,
     4 4160 , 4260 , 8000 , 4100 ,
     5 4020 , 4060 , 4190 , 4210 ,
     6 4110 , 8000 , 4150 , 4090 ,
     7 4200 , 4230 , 4220 , 4080 ,
CJAN99
     8 4180 , 4240 , 4250 , 4095 ,
     9 4181 , 9988 ) , ISCCOM
      GO TO 9988
C
C
C
C
C
C -- 'ERROR'
C
4010  CONTINUE
C
        LENLAB = KCCARG ( CUPPER , IDIRPS , 1 , NLABEL , NEND )
        IF ( LENLAB .LE. 0 ) GO TO 9940
C
        CLABEL = CUPPER(NLABEL:NEND)
C
C -- CHECK IF LABEL IS CURRENTLY KNOWN. IF NOT CREATE IT
        IADDR = KSCIDN ( 2 , 1 , CLABEL , 2 , I, IIDENT , IVALUE , -1 )
        IF ( IADDR .LE. 0 ) THEN
          IADDR = KSCIDN ( 1 , 1 , CLABEL , 2, 0, IIDENT , 0 , -1 )
        ENDIF
C
C -- STORE AWAY ADDRESS OF LABEL IDENTIFIER
        ISTAT = KSCIDN ( 1 , 1 , 'ERROR' , 3, 0, IERROR , IIDENT , -1 )
C
        IF ( ISCVER .GT. 0 ) THEN
           WRITE ( CMON, 1017) CLABEL
           CALL XPRVDU(NCVDU, 2,0)
        ENDIF
1017    FORMAT ( 1X , 'Error label set to ' , A , / )
C
        KSCPRC = 0
      GO TO 8000
C
C
4020  CONTINUE
C
C
C -- 'ON'
C
C
        KSCPRC = KSCCNT ( IN )
      GO TO 8000
C
C
4030  CONTINUE
C
C
C -- 'ACTIVATE'
C
C
        LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
        IF ( LENARG .LE. 0 ) GO TO 9996
C
        ISTAT = KSCACT  ( CUPPER(NARG:NEND) )
        IF ( ISTAT .LE. 0 ) GO TO 9998
C
        KSCPRC = 0
      GO TO 8000
C
C
4040  CONTINUE
C
C -- 'COPY'
C
        LENCPY = KCCARG ( CUPPER , IDIRPS , 2 , NCOPY , NEND )
        IF ( LENCPY .LE. 0 ) GO TO 9950
C
        CINPUT = CLOWER(NCOPY:NEND)
        IUSLEN = NEND - NCOPY + 1
        KSCPRC = 2
      GO TO 8000
C
C
4050  CONTINUE
C
C -- 'INSERT'
C
        LENINS = KCCARG ( CUPPER , IDIRPS , 2 , NINS , NEND )
        IF ( LENINS .LE. 0 ) GO TO 9950
        IF ( ICOMLN .LE. 0 ) THEN
          IBSTRT = 1
        ELSE
          IBSTRT = ICOMLN + 2
        ENDIF
        ICOMLN = IBSTRT + LENINS - 1
        CCOMBF(IBSTRT:ICOMLN) = CLOWER(NINS:NEND)
C
        KSCPRC = 0
      GO TO 8000
C
C
4060  CONTINUE
C
C -- 'STORE'
C
C
        KSCPRC = KSCSTR ( IN )
      GO TO 8000
C
C
4070  CONTINUE
C
C
C -- 'GET'
C
C
        KSCPRC = KSCVAL ( IN )
      GO TO 8000
C
C
4080  CONTINUE
C
C -- 'INDEX'
C
C
        KSCPRC = KSCINX ( IN )
      GO TO 8000
C
C
4090  CONTINUE
C
C
C -- 'SEND' AND 'EXECUTE'
C
        IF ( ICOMLN.GT. 0 ) THEN
          CINPUT = CCOMBF(1:ICOMLN)
          IUSLEN = ICOMLN
          KSCPRC = 2
          IF ( ISCCOM .EQ. ICEXEC ) KSCPRC = 3
        ELSE
          KSCPRC = 0
        ENDIF
      GO TO 8000
CJAN99
4095  CONTINUE
C
C
C -- 'OUTPUT'
C
        IF ( ICOMLN.GT. 0 ) THEN
            WRITE(CMON,'(A)') CCOMBF(1:ICOMLN)
          CALL XPRVDU(NCVDU, 1,0)
 
            KSCPRC = 0
        ELSE
          KSCPRC = 0
        ENDIF
      GO TO 8000
C
C
4100  CONTINUE
C
C -- 'QUEUE'
C
C
        KSCPRC = KSCQUE ( IN )
      GO TO 8000
C
C
4110  CONTINUE
C
C -- 'EXTERNAL'
C
C
        KSCPRC = KSCEXT ( IUSLEN )
      GO TO 8000
C
C
4120  CONTINUE
C
C -- 'CLEAR'
C
        CCOMBF = ' '
        ICOMLN = 0
        KSCPRC = 0
      GO TO 8000
C
C
4130  CONTINUE
C
C -- 'JUMP'
C
        LENLAB = KCCARG ( CUPPER , IDIRPS , 1 , NLABEL , NEND )
        IF ( LENLAB .LE. 0 ) GO TO 9940
C
        CSERCH = CUPPER(NLABEL:NEND)
        CALL XSCJMP ( CSERCH )
C
        KSCPRC = 0
      GO TO 8000
C
C
4140  CONTINUE
C
C -- 'BRANCH'
C
C
        ISTAT = KSCADR ( IADDR , CVARIB , ITYPE , IVALUE )
        IF ( ISTAT .LE. 0 ) GO TO 9900
        IF ( ITYPE .NE. 1 ) GO TO 9970
C
        LENNUM = KCCARG ( CUPPER , IDIRPS , 1 , NNUM , NEND )
        IF ( LENNUM .LE. 0 ) GO TO 9960
C
        READ ( CUPPER(NNUM:NEND) , '(I32)' , ERR = 9960 ) ICHECK
C
        IF ( IVALUE .EQ. ICHECK ) THEN
          LENLAB = KCCARG ( CUPPER , IDIRPS , 1 , NLABEL , NEND )
          IF ( LENLAB .LE. 0 ) GO TO 9940
C
          CSERCH = CUPPER(NLABEL:NEND)
          CALL XSCJMP ( CSERCH )
C
        ENDIF
        KSCPRC = 0
      GO TO 8000
C
C
4150  CONTINUE
C
C -- 'SELECT'
C
C
        ISTAT = KSCADR ( IADDR , CVARIB , ITYPE , IINDEX )
        IF ( ISTAT .LE. 0 ) GO TO 9900
        IF ( ITYPE .NE. 1 ) GO TO 9970
C
        ILABEL = 0
        IF ( IINDEX .GT. 0 ) THEN
2000      CONTINUE
          ILABEL = ILABEL + 1
          LENLAB = KCCARG ( CUPPER , IDIRPS , 1 , NLABEL , NEND )
          IF ( LENLAB .GT. 0 ) THEN
            IF ( ILABEL .LT. IINDEX ) GO TO 2000
            CSERCH = CUPPER(NLABEL:NEND)
            CALL XSCJMP ( CSERCH )
          ENDIF
        ENDIF
        KSCPRC = 0
      GO TO 8000
C
C
4160  CONTINUE
C
C -- 'DECREMENT AND BRANCH'
C
C
        ISTAT = KSCADR ( IADDR , CVARIB , ITYPE , IVALUE )
        IF ( ISTAT .LE. 0 ) GO TO 9900
        IF ( ITYPE .NE. 1 ) GO TO 9970
C
        IVALUE = IVALUE - 1
      ISTAT = KSCIDN ( 1, 3, CVARIB, 1, ITYPE , IDENT , IVALUE , 0 )
C
C -- IF VALUE IS POSITIVE THEN JUMP TO LABEL SPECIFIED
        IF ( IVALUE .GT. 0 ) THEN
          LENLAB = KCCARG ( CUPPER , IDIRPS , 1 , NLABEL , NEND )
          IF ( LENLAB .LE. 0 ) GO TO 9940
C
          CSERCH = CUPPER(NLABEL:NEND)
          CALL XSCJMP ( CSERCH )
        ENDIF
        KSCPRC = 0
      GO TO 8000
C
C
4170  CONTINUE
C
C -- 'VERIFY'
C
        NCHKUS = 0
2100    CONTINUE
        LENGTH = KCCARG ( CLOWER , IDIRPS , 1 , NCHECK , NEND )
        IF ( LENGTH .GT. 0 ) THEN
          IF ( NCHKUS .GE. NCHK ) GO TO 9920
          NCHKUS = NCHKUS + 1
C
          CCHECK(NCHKUS) = CLOWER(NCHECK:NEND)
          GO TO 2100
        ENDIF
        KSCPRC = 0
      GO TO 8000
C
C
4180  CONTINUE
C
C -- 'EXTRACT'
C
C
        KSCPRC = KSCETR ( IN )
      GO TO 8000
C
C
4181  CONTINUE
C
C -- 'EXTRACT2'
C
C
        KSCPRC = KSCETR2 ( IN )
      GO TO 8000
C
C
4190  CONTINUE
C
C -- 'VARIABLE'
C
C
        KSCPRC = KSCVAR ( IN )
      GO TO 8000
C
C
4200  CONTINUE
C
C -- 'SHOW'
C
C
        KSCPRC = KSCSHW ( IN )
      GO TO 8000
C
C
4210  CONTINUE
C
C -- 'SET'
C
C
        KSCPRC = KSCSET ( IN )
      GO TO 8000
C
C
4220  CONTINUE
C
C -- 'MESSAGE'
C
C
        KSCPRC = KSCUMS ( IUSLEN )
      GO TO 8000
C
C
4230  CONTINUE
C
C
C -- 'EVALUATE'
C
C
        KSCPRC = KSCEVL ( IN )
      GO TO 8000
C
C
4240  CONTINUE
C
C -- 'IDENTIFY'
C
C
      CALL XOPMSG ( IOPSCP , IOPVER , IVERSN )
      KSCPRC = 0
      GO TO 8000
C
C
4250  CONTINUE
C
C -- 'TRANSFER'
C
C
      KSCPRC = KSCTRA ( CINPUT , IUSLEN )
      GO TO 8000
C
C
4260  CONTINUE
C
C -- 'FINISH'
C
C
C -- DISABLE STACK OPERATIONS
      ISCDSB = 1
C
        CALL XFLUNW ( 2 , 3 )
        KSCPRC = 0
      GO TO 8000
C
C
C
C
8000  CONTINUE
C
C -- EXECUTION OF INSTRUCTION HAS BEEN COMPLETED
C
C -- FINAL PROCESSING FOR 'CASE'
C
      IF ( ( ISCINI .GT. 0 ) .AND. ( ISCDSB .LE. 0 ) ) THEN
        IREQST = KSCSTK ( JREQST , 0 )
        ICOUNT = KSCSTK ( JNSTAT , 0 )
C
C -- CHECK IF THIS IS THE TARGET STATEMENT OF A 'CASE'
C
        IF ( IREQST .EQ. ICOUNT ) THEN
C
C -- CHECK IF THE END OF THE CURRENT STRUCTURE BLOCK IS KNOWN. IF IT
C    IS, THAT IS THE NEXT STATEMENT TO BE EXECUTED.
C
          IBLEND = KSCSTK ( JBLEND , 0 )
          IF ( IBLEND .GT. 0 ) IRDFND(IFLIND) = IBLEND
        ENDIF
      ENDIF
C
C
C
C
      IDIRLN = 0
      RETURN
C
C
9900  CONTINUE
      IDIRLN = 0
      KSCPRC = 0
      RETURN
C
9910  CONTINUE
      ISCCOM = 0
      CALL XSCMSG ( MILLEG , MCOMND , CLOWER(NDIREC:NEND) , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MTOOMY , MAVKEY , 'The maximum is' , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MNOTFD , MLABEL , CSERCH , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MMISSG , MLABEL , ' ' , 0 )
      GO TO 9900
9950  CONTINUE
      CALL XSCMSG ( MMISSG , MDATA , ' ' , 0 )
      GO TO 9900
9960  CONTINUE
      CALL XSCMSG ( MILLMS , MCONST , ' ' , 0 )
      GO TO 9900
9970  CONTINUE
      CALL XSCMSG ( MWRONG , MVARIA , CVARIB , 0 )
      GO TO 9900
9980  CONTINUE
      CALL XSCMSG ( MMISSG , MSTRUC , ' '  , 0 )
      GO TO 9900
9988  CONTINUE
      CALL XSCMSG ( MINTRN , MCMMND , 'Internal error in KSCPRC' , 0 )
      CALL XOPMSG ( IOPSCP , IOPINT , 0 )
      GO TO 9900
9990  CONTINUE
      CALL XSCMSG ( MILLEG , MSTRUC , CUPPER(NARG:NEND) , 0 )
      GO TO 9900
9992  CONTINUE
      CALL XSCMSG ( MUNEXP , MSTRUC ,
     2 'Expected: '//CSTRUC(ICTYPE)//' Found: '//CSTRUC(ISTRUC) , 0 )
      GO TO 9900
9994  CONTINUE
      CALL XSCMSG ( MINCLY , MINITD ,
     2              'Scripts should begin with SCRIPT' , 0 )
      GO TO 9900
9996  CONTINUE
      CALL XSCMSG ( MMISSG , MCONTT , ' ' , 0 )
      GO TO 9900
9998  CONTINUE
      CALL XSCMSG ( MILLEG , MCONTT , CUPPER(NARG:NEND) , 0 )
      GO TO 9900
C
C
C
      END
CODE FOR KSCACT
      FUNCTION KSCACT ( CTYPE )
C
C -- ACTIVATE CONTINGENCY
C
C -- THIS ROUTINE IMPLEMENTS THE 'ACTIVATE' INSTRUCTION IN SCRIPTS.
C    IT IS ALSO CALLED BY CERTAIN OTHER PARTS OF SCRIPTS IN ORDER TO
C    ACTIVATE CONTINGENCIES, AND CAN BE CALLED BY OTHER PARTS OF
C    'CRYSTALS' FOR THE SAME PURPOSE.
C
C      INPUT PARAMETER :-
C
C      CTYPE       NAME OF CONTINGENCY ( AS A CHARACTER STRING. )
C
C      RETURN VALUES :-
C
C      KSCACT      -1      NO SUCH CONTINGENCY
C                  +1      SUCCESS
C
      CHARACTER*(*) CTYPE
C
      INCLUDE 'PSCSTK.INC'
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCMSG.INC'
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C -- SEARCH FOR CONTIGENCY. IF NOT DECLARED, RETURN IMMEDIATELY
C
      ISTAT = KSCIDN ( 2 , 1 , CTYPE , 4 , ISUB , ID , IMSG , -1 )
      IF ( ISTAT .LE. 0 ) GO TO 9900
C
      GO TO ( 2100 , 2200 , 2300 , 2400 , 9910 ) , ISUB
      GO TO 9910
C
C
2100  CONTINUE
C
C -- 'RESTART'
C
C -- FIND STARTING ADDRESS OF CURRENT BLOCK
      IPOS = KSCSTK ( JBSTRT , 0 )
C
C -- RESTORE PREVIOUS STACK LEVEL
      CALL XSCRST
C
C -- REPOSITION INPUT FILE
      IRDFND(IFLIND) = IPOS
      GO TO 9000
C
2200  CONTINUE
C
C -- 'REPEAT'
C
C -- FIND STARTING ADDRESS OF CURRENT BLOCK, AND REPOSITION FILE
C    TO THE LINE AFTER THIS
      IPOS = KSCSTK ( JBSTRT , 0 )
      IRDFND(IFLIND) = IPOS + 1
      GO TO 9000
C
2300  CONTINUE
C
C -- 'TERMINATE'
C
C -- DISABLE PROCESSING OF THIS BLOCK. THIS INVOLVES CLEARING THE
C    EXECUTION FLAG, AND SETTING 'WASEX' SO THAT 'ELSE' DOES NOT
C    REENABLE EXECUTION.
C
      CALL XSCSTU ( JEXECU , 0 )
      CALL XSCSTU ( JWASEX , 1 )
      GO TO 9000
C
2400  CONTINUE
C
C -- 'CONTINUE'
C
C -- NO OPERATION
C
      GO TO 9000
C
9000  CONTINUE
C
C -- OUTPUT ANY MESSAGE ASSOCIATED WITH THIS CONTINGENCY
C
      IF ( IMSG .GT. 0 ) THEN
        WRITE ( CMON, 9905) CSCMSG(IMSG)(1:LSCMSG(IMSG))
        CALL XPRVDU(NCVDU, 3,0)
9905    FORMAT ( / , 1X , A , / )
      ENDIF
      KSCACT = 1
      RETURN
C
C
9900  CONTINUE
      KSCACT = -1
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MILLEG , MCONTI , ' ' , 0 )
      GO TO 9900
      END
CODE FOR KSCADR
      FUNCTION KSCADR ( IADDR , CVARIB , ITYPE , IVALUE )
C
C -- SEARCH INPUT FOR A VARIABLE NAME. IDENTIFY VARIABLE AND
C    RETURN NAME AND VALUE
C
C -- THIS ROUTINE PERFORMS A COMMON 'SCRIPT' SYNTAX CHECKING/ANALYSIS
C    FUNCTION.
C
C      INPUT PARAMETERS :-
C
C            <NONE>
C
C      OUTPUT PARAMETERS :-
C
C            IADDR       INDEX NUMBER OF IDENTIFIER FOUND
C            CVARIB      CHARACTER VARIABLE CONTAINING IDENTIFIER FOUND
C            ITYPE       TYPE OF VARIABLE ( INTEGER / REAL ETC. ). THIS
C                        CORRESPONDS TO THE 'SUBTYPE' FIELD USED BY
C                        'KSCIDN'
C            IVALUE      CURRENT VALUE OF THE VARIABLE
C
C      RETURN VALUE :-
C
C            0      VARIABLE NOT KNOWN
C            +VE    INDEX NUMBER OF VARIABLE ( A COPY OF 'IADDR' )
C
C
      CHARACTER*(*) CVARIB
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCHR.INC'
C
C
C
C
C -- GET NAME FROM INPUT
C
      LENVAR = KCCARG ( CUPPER , IDIRPS , 1 , NVAR , NEND )
      IF ( LENVAR .LE. 0 ) GO TO 9910
C
      CVARIB = CUPPER(NVAR:NEND)
C
C -- LOOKUP IN TABLE
C
      IADDR = KSCIDN ( 2, 3, CVARIB, 1, ITYPE, IDENT, IVALUE, 1 )
      IF ( IADDR .LE. 0 ) GO TO 9900
C
      KSCADR = IADDR
      RETURN
C
C
9900  CONTINUE
C
      IADDR = 0
      CVARIB = ' '
      IVALUE = 0
C
      KSCADR = 0
      RETURN
C
9910  CONTINUE
C -- NO VARIABLE NAME
      CALL XSCMSG ( MMISSG , MVARIA , ' ' , 0 )
      GO TO 9900
      END
CODE FOR KSCCNT
      FUNCTION KSCCNT ( IN )
C
C -- DECLARE CONTIGENCIES
C
C -- THIS ROUTINE IMPLEMENTS THE 'ON' INSTRUCTION IN SCRIPTS.
C
C      INPUT PARAMETERS :-
C            IN          DUMMY
C
C      RETURN VALUE :-
C            <ANY>       VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C
C      LOCAL VARIABLES :-
C
C            CACT        CHARACTER ARRAY DEFINING POSSIBLE ACTIONS
C                        FOR EACH CONTINGENCY. EACH ACTION HERE HAS
C                        A CORRESPONDING SECTION IN 'KSCACT' WHICH
C                        CARRIES IT OUT.
C            CMSG        CHARACTER ARRAY DEFINING POSSIBLE MESSAGES
C                        FOR EACH CONTINGENCY. THESE ARE OUTPUT BY
C                        'KSCACT' WHEN THE CONTINGENCY IS ACTIVATED
C
C
      PARAMETER ( LACT = 12 , NACT = 4 )
      CHARACTER*(LACT) CACT(NACT)
C
      PARAMETER ( LMSG = 12 , NMSG = 5 )
      CHARACTER*(LMSG) CMSG(NMSG)
      DIMENSION ITMSG(NMSG)
C
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      CHARACTER*(MAXLAB) CCONT
C
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      DATA CACT / 'RESTART' , 'REPEAT'  , 'TERMINATE' , 'CONTINUE' /
      DATA CMSG / 'ABANDONED' , 'USER1' , 'USER2' , 'USER3' , 'USER4' /
      DATA ITMSG / 6 , 7 , 8 , 9 , 10 /
C
C
C -- READ CONTINGENCY TYPE
C
      LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
      IF ( LENARG .LE. 0 ) GO TO 9910
C
      CCONT = CUPPER(NARG:NEND)
C
C -- READ ACTION
C
      LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
      IF ( LENARG .LE. 0 ) GO TO 9920
C
      IACT = KCCOMP ( CUPPER(NARG:NEND) , CACT , NACT , 1 )
      IF ( IACT .LE. 0 ) GO TO 9920
C
C -- CHECK TO SEE IF THERE IS A MESSAGE SPECIFIER
      IMSG = 0
      IF ( KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND ) .GT. 0 ) THEN
        IMSG = KCCOMP ( CUPPER(NARG:NEND) , CMSG , NMSG , 1 )
        IF ( IMSG .LE. 0 ) GO TO 9930
        IMSG = ITMSG(IMSG)
      ENDIF
C
      ISTAT = KSCIDN ( 1 , 1 , CCONT , 4 , IACT , ID , IMSG , -1 )
C
      KSCCNT = 0
      RETURN
C
C
9900  CONTINUE
      KSCCNT = 0
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MMISSG , MCONTT , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MILLMS , MCONTI , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MILLEG , MMESSG , CUPPER(NARG:NEND) , 0 )
      GO TO 9900
      END
CODE FOR KSCELS
      FUNCTION KSCELS ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE SCRIPT 'ELSE' INSTRUCTION
C
C      INPUT PARAMETER :-
C
C            IN          DUMMY
C
C      RETURN VALUE :-
C            <ANY>       VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C
C      LOCAL VARIABLES :-
C
C            CKEY1       CHARACTER ARRAY DEFINING KEYWORDS THAT CAN
C                        FOLLOW 'ELSE'. ( I.E. 'IF' )
C            CKEY2       CHARACTER ARRAY DEFINING KEYWORDS THAT CAN
C                        FOLLOW THE LOGICAL EXPRESSION. ( I.E. 'THEN' )
C
      PARAMETER ( JLOGIC = 3 )
      PARAMETER ( JIF = 4 )
C
      PARAMETER ( LKEY1 = 4 , NKEY1 = 1 )
      CHARACTER*(LKEY1) CKEY1(NKEY1)
C
      PARAMETER ( LKEY2 = 4 , NKEY2 = 1 )
      CHARACTER*(LKEY2) CKEY2(NKEY2)
C
      INCLUDE 'PSCMSG.INC'
      INCLUDE 'PSCSTK.INC'
C
      INCLUDE 'XSCCHR.INC'
C
C
      DATA CKEY1 / 'IF' /
      DATA CKEY2 / 'THEN' /
C
C
C -- CHECK THAT THE CURRENT BLOCK IS AN 'IF' BLOCK. 'ELSE' STATEMENTS
C    ONLY MAKE SENSE IN 'IF' BLOCKS.
C
      ITYPE = KSCSTK ( JBTYPE , 0 )
      IF ( ITYPE .NE. JIF ) GO TO 9910
C
C -- CHECK FOR A FOLLOWING 'IF', IMPLYING AN OVERALL 'ELSE IF' EFFECT.
C
      LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
      IF ( LENARG .LE. 0 ) THEN
        IVALUE = 1
      ELSE
        ISTAT = KCCOMP ( CUPPER(NARG:NEND) , CKEY1 , NKEY1 , 1 )
        IF ( ISTAT .LE. 0 ) GO TO 9920
C
C -- IF THE COMMAND IS 'ELSE IF', A LOGICAL EXPRESSION AND 'THEN' SHOULD
C    FOLLOW IT.
C
        ISTAT = KSCEXP ( IVALUE , IEXTYP , CUPPER, CLOWER , IDIRPS , 1 )
        IF ( ISTAT .LT. 0 ) GO TO 9900
        IF ( ISTAT .EQ. 0 ) GO TO 9930
        IF ( IEXTYP .NE. JLOGIC ) GO TO 9940
C
C -- READ 'THEN'
        LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
        IF ( LENARG .LE. 0 ) GO TO 9950
C
        ISTAT = KCCOMP ( CUPPER(NARG:NEND) , CKEY2 , NKEY2 , 1 )
        IF ( ISTAT .LE. 0 ) GO TO 9920
      ENDIF
C
C -- ENABLE EXECUTION IF LOGICAL EXPRESSION TRUE, AND NO PART OF IF
C    BLOCK HAS EXECUTED
      IWASEX = KSCSTK ( JWASEX , 0 )
C
      IF ( ( IWASEX .LE. 0 ) .AND. ( IVALUE .GT. 0 ) ) THEN
        CALL XSCSTU ( JEXECU , 1 )
        CALL XSCSTU ( JWASEX , 1 )
      ELSE
        CALL XSCSTU ( JEXECU , 0 )
      ENDIF
C
9900  CONTINUE
      KSCELS = 0
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MILLEG, MCOMND, 'ELSE should appear in IF block',0)
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MILLEG , MKEYWD , CUPPER(NARG:NEND) , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MMISSG , MEXPRE , ' ' , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MWRONG , MEXPRE , ' ' , 0 )
      GO TO 9900
9950  CONTINUE
      CALL XSCMSG ( MMISSG , MKEYWD , ' ' , 0 )
      GO TO 9900
      END
CODE FOR KSCEST
      FUNCTION KSCEST ( CTEXT , ITYPE , IRESLT )
C
C -- GET STANDARD VALUES IN EXPRESSIONS
C
C -- THIS ROUTINE IS CALLED BY THE EXPRESSION ANALYSIS ROUTINE 'KSCEXP'
C    TO IDENTIFY CERTAIN TOKENS AS 'STANDARD VALUES' AND TO RETURN
C    THE CORRESPONDING VALUE.
C
C
C
C      CTEXT       TEXT TO BE CHECKED FOR AN STANDARD VALUE
C                  SPECIFIER
C      ITYPE       DATA TYPE OF SPECIFIER FOUND
C                    1      INTEGER
C                    2      REAL
C                    3      LOGICAL
C      IRESLT      VALUE FOUND
C
C      KSCEST      INDICATES SUCCESS OR FAILURE
C                    -1      FAILURE
C                    +1      SUCCESS
C
C -- THE FOLLOWING VALUES ARE DETECTED BY THIS ROUTINE :-
C
C      NAME        TYPE        VALUE
C      ----        ----        -----
C      TRUE        LOGICAL     TRUE
C      FALSE       LOGICAL     FALSE
C      VALUE       <VARIABLE>  <VARIABLE>  THE VALUE AND TYPE DEPENDS
C                              ON THE TYPE OF THE LAST USER INPUT
C
C -- NAMES ARE STORED IN 'CSTAND'
C    TYPES ARE STORED IN 'ISTYPE'
C    VALUES ARE STORED IN 'ISVALU'
C    IF VALUE IS DETERMINED AT EXECUTION TIME, A FLAG IN LOGICAL ARRAY
C    'LSCALC' IS SET TO TRUE, AND 'ISTYPE' AND 'ISVALU' MAY ( IF
C    APPROPRIATE ) BE ZERO.
C
C
      CHARACTER*(*) CTEXT
      CHARACTER*80  CTITLE
C
C
      PARAMETER ( LSTAND = 12 , NSTAND = 7 )
      PARAMETER ( JINTEG = 1 , JREAL = 2 , JLOGIC = 3 )
      PARAMETER ( JCHAR = 4 )
      PARAMETER ( JTRUE = 1  , JFALSE = 0 )
C
      CHARACTER*(LSTAND) CSTAND(NSTAND)
      DIMENSION ISTYPE(NSTAND)
      DIMENSION ISVALU(NSTAND)
      LOGICAL LSCALC(NSTAND)
C
C
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XCOMPD.INC'
C
C
      DATA CSTAND / 'TRUE' , 'FALSE' , 'VALUE' , 'USERLENGTH' ,
     2 'NULLSTRING' , 'CVALUE' , 'CTITLE' /
      DATA ISTYPE / JLOGIC , JLOGIC  , 0       , JINTEG       ,
     2 JCHAR        , JCHAR    , JCHAR    /
      DATA ISVALU / JTRUE  , JFALSE  , 0       , 0            ,
     2 0            , 0    ,    0    /
      DATA LSCALC / .FALSE. , .FALSE. , .TRUE. , .TRUE.       ,
     2 .FALSE.      , .TRUE., .TRUE.   /
C
C
C
C
C -- CHECK SPECIFIER AGAINST ALLOWED LIST. RETURN IF NOT FOUND
C
      ISTAND = KCCOMP ( CTEXT , CSTAND , NSTAND  , 1 )
      IF ( ISTAND .LE. 0 ) THEN
        KSCEST = -1
        RETURN
      ENDIF
C
C
C
C -- DETERMINE VALUE
C
      IF ( LSCALC(ISTAND) ) THEN
C
C      **** VALUES WHICH MUST BE CALCULATED AT EXECUTION TIME ****
C
C -- 'VALUE'
C
        IF ( ISTAND .EQ. 3 ) THEN
C
          ITYPE = ISCVTP
          CALL XMOVEI ( ISCVAL , IRESLT , 1 )
C
C -- 'USERLENGTH'
C
        ELSE IF ( ISTAND .EQ. 4 ) THEN
          ITYPE = JINTEG
          IRESLT = MAX0 ( 0 , ( IINPLN - IINPPS + 1 ) )
C
C -- 'CVALUE'
C
        ELSE IF ( ISTAND .EQ. 6 ) THEN
          ITYPE = JCHAR
C RIC 98 ISCVLN is the end position, not the length of the string.
          ISTAT = KSCSCD ( CLINPB(ISCVLS:ISCVLN) , IRESLT )
C
C
C -- 'CTITLE'
C
        ELSE IF ( ISTAND .EQ. 7 ) THEN
          ITYPE = JCHAR
          WRITE( CTITLE, '(20A4)') KTITL
          ISTAT = KSCSCD ( CTITLE , IRESLT )
C
        ENDIF
C
      ELSE
C
C                   **** FIXED, PRECODED VALUES ****
C
        ITYPE = ISTYPE(ISTAND)
        CALL XMOVEI ( ISVALU(ISTAND) , IRESLT , 1 )
      ENDIF
C
C
C
C -- RETURN SUCCESS
C
      KSCEST = 1
C
      RETURN
      END
CODE FOR KSCETR
      FUNCTION KSCETR ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE 'EXTRACT' INSTRUCTION IN SCRIPTS
C
C      INPUT PARAMETER :-
C
C            IN          DUMMY
C
C      RETURN VALUE :-
C            <ANY>       RETURN VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C
C -- DEFINE SUBCOMMANDS FOR 'EXTRACT'
      PARAMETER ( LOPR = 8 , NOPR = 6 )
      CHARACTER*(LOPR) COPER(NOPR)
C
C -- DEFINE KEYWORDS FOR 'EXTRACT FIND'
      PARAMETER ( LFIND = 8 , NFIND = 2 )
      CHARACTER*(LFIND) CFIND(NFIND)
C
C -- DEFINE KEYWORDS FOR 'EXTRACT TRANSFER'
      PARAMETER ( LTRANS = 8 , NTRANS = 2 )
      CHARACTER*(LTRANS) CTRANS(NTRANS)
C
C -- SET UP INPUT BUFFER, AND AREA TO STORE SEARCH STRING
      PARAMETER ( NINPBF = 256 )
      CHARACTER*(NINPBF) CINPBF
      PARAMETER ( NSERCH = 256 )
      CHARACTER*(NSERCH) CSERCH
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XSCCHR.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
C
      SAVE CINPBF
      SAVE LENGTH
C
      DATA COPER / 'TRANSFER', 'REWIND', 'CLOSE', 'NEXT', 'FIND',
     1             'SHRIEK' /
      DATA CFIND / 'STRING' , 'BUFFER' /
      DATA CTRANS / 'COMMAND' , 'INPUT' /
C
C
C
C -- READ KEYWORD
C
      LENTYP = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENTYP .LE. 0 ) GO TO 9940
C
      ITYPE = KCCOMP ( CUPPER(NTYPE:NEND) , COPER , NOPR , 2 )
      IF ( ITYPE .LE. 0 ) GO TO 9910
C
C
C -- 'TRANSFER'
C
      IF ( ITYPE .EQ. 1 ) THEN
C
C -- READ SUBKEYWORD
        LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
        IF ( LENARG .LE. 0 ) GO TO 9940
C
        ITRANS = KCCOMP ( CUPPER(NTYPE:NEND) , CTRANS , NTRANS , 2 )
        IF ( ITRANS .LE. 0 ) GO TO 9910
C
C -- MOVE DATA TO USER INPUT BUFFER OR COMMAND BUFFER
        IF ( ITRANS .EQ. 1 ) THEN
          IF ( ICOMLN .LE. 0 ) THEN
            IBSTRT = 1
          ELSE
            IBSTRT = ICOMLN + 2
          ENDIF
          ICOMLN = IBSTRT + LENGTH - 1
          CCOMBF(IBSTRT:ICOMLN) = CINPBF(1:LENGTH)
        ELSE IF ( ITRANS .EQ. 2 ) THEN
          CLINPB = CINPBF(1:LENGTH)
          CUINPB = CINPBF(1:LENGTH)
          IINPPS = 1
          IINPLN = LENGTH
        ENDIF
C
C -- 'REWIND'
C
      ELSE IF ( ITYPE .EQ. 2 ) THEN
C
C -- REWIND FILE
        REWIND NCEXTR
C
C -- 'CLOSE'
C
      ELSE IF ( ITYPE .EQ. 3 ) THEN
C
C -- CLOSE FILE
        ISTAT = KFLCLS ( NCEXTR )
C
      ELSE IF ( ITYPE .EQ. 4 ) THEN
C
C -- 'NEXT'
C
C -- READ NEXT RECORD
C
        ISTAT = KRDLIN ( NCEXTR , CINPBF , LENGTH )
        IF ( ISTAT .LT. 0 ) GO TO 8910
        IF ( ISTAT .EQ. 0 ) GO TO 8920
C
      ELSE IF ( ITYPE .EQ. 6 ) THEN
C
C -- 'SHRIEK'
C
C -- READ NEXT RECORD UP TO '!'
C
        ISTAT = KRDLIN ( NCEXTR , CINPBF , LENGTH )
        IF ( ISTAT .LT. 0 ) GO TO 8910
        IF ( ISTAT .EQ. 0 ) GO TO 8920
        IDJW = INDEX(CINPBF,'!')
        IF (IDJW .GT. 0) THEN
            LENGTH=IDJW-1
            CINPBF(IDJW:) = ' '
        ENDIF
C
      ELSE IF ( ITYPE .EQ. 5 ) THEN
C
C -- 'FIND'
C
C -- FIND A PARTICULAR RECORD
C
C -- READ SUBKEYWORD
C
        LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
        IF ( LENARG .LE. 0 ) GO TO 9940
C
        IFIND = KCCOMP ( CUPPER(NTYPE:NEND) , CFIND , NFIND , 2 )
        IF ( IFIND .LE. 0 ) GO TO 9910
C
        IF ( IFIND .EQ. 1 ) THEN
C -- EITHER READ SEARCH STRING FROM INPUT LINE
          LENSER = KCCARG ( CUPPER , IDIRPS , 2 , NSER , NEND )
          IF ( LENSER .LE. 0 ) GO TO 9950
          CSERCH = CLOWER(NSER:NEND)
        ELSE IF ( IFIND .EQ. 2 ) THEN
C -- OR GET IT FROM THE COMMAND BUFFER
          LENSER = ICOMPS
          CSERCH = CCOMBF(1:LENSER)
        ENDIF
C
C -- SEARCH ENTIRE FILE FOR THE STRING
        REWIND NCEXTR
2500    CONTINUE
          ISTAT = KRDLIN ( NCEXTR , CINPBF , LENGTH )
          IF ( ISTAT .LT. 0 ) GO TO 8910
          IF ( ISTAT .EQ. 0 ) GO TO 8920
C -- SEARCH ONLY ALLOWS STRING TO BE AT BEGINNING OF LINE
CDJWMAR97
          CALL XCCUPC (CINPBF(1:LENSER), CINPBF(1:LENSER))
          CALL XCCUPC (CSERCH(1:LENSER) ,CSERCH(1:LENSER))
          IF ( CINPBF(1:LENSER) .NE. CSERCH(1:LENSER) ) GO TO 2500
C
      ENDIF
C
      GO TO 9000
C
8900  CONTINUE
C -- SET ERROR FLAG, SO SCRIPT CAN TAKE APPROPRIATE ACTION
      CALL XERHND ( IERSFL )
      GO TO 9000
8910  CONTINUE
C -- READ ERROR ON EXTRACT FILE
      GO TO 8900
8920  CONTINUE
C -- END OF FILE ERROR ON EXTRACT FILE
      GO TO 8900
C
C
9000  CONTINUE
C
      KSCETR = 0
C
      RETURN
C
9900  CONTINUE
      GO TO 9000
9910  CONTINUE
      CALL XSCMSG ( MILLEG , MKEYWD , CUPPER(NTYPE:NEND) , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MMISSG , MKEYWD , ' ' , 0 )
      GO TO 9900
9950  CONTINUE
      CALL XSCMSG ( MMISSG , MDATA , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCETR2
      FUNCTION KSCETR2 ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE 'EXTRACT2' INSTRUCTION IN SCRIPTS
C
C      INPUT PARAMETER :-
C
C            IN          DUMMY
C
C      RETURN VALUE :-
C            <ANY>       RETURN VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C
C -- DEFINE SUBCOMMANDS FOR 'EXTRACT'
      PARAMETER ( LOPR = 8 , NOPR = 5 )
      CHARACTER*(LOPR) COPER(NOPR)
C
C -- DEFINE KEYWORDS FOR 'EXTRACT FIND'
      PARAMETER ( LFIND = 8 , NFIND = 2 )
      CHARACTER*(LFIND) CFIND(NFIND)
C
C -- DEFINE KEYWORDS FOR 'EXTRACT TRANSFER'
      PARAMETER ( LTRANS = 8 , NTRANS = 2 )
      CHARACTER*(LTRANS) CTRANS(NTRANS)
C
C -- SET UP INPUT BUFFER, AND AREA TO STORE SEARCH STRING
      PARAMETER ( NINPBF = 256 )
      CHARACTER*(NINPBF) CINPBF
      PARAMETER ( NSERCH = 256 )
      CHARACTER*(NSERCH) CSERCH
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XSCCHR.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XERVAL.INC'
C
      SAVE CINPBF
      SAVE LENGTH
C
      DATA COPER / 'TRANSFER' , 'REWIND' , 'CLOSE' , 'NEXT' , 'FIND' /
      DATA CFIND / 'STRING' , 'BUFFER' /
      DATA CTRANS / 'COMMAND' , 'INPUT' /
C
C
C
C -- READ KEYWORD
C
      LENTYP = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENTYP .LE. 0 ) GO TO 9940
C
      ITYPE = KCCOMP ( CUPPER(NTYPE:NEND) , COPER , NOPR , 2 )
      IF ( ITYPE .LE. 0 ) GO TO 9910
C
C
C -- 'TRANSFER'
C
      IF ( ITYPE .EQ. 1 ) THEN
C
C -- READ SUBKEYWORD
        LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
        IF ( LENARG .LE. 0 ) GO TO 9940
C
        ITRANS = KCCOMP ( CUPPER(NTYPE:NEND) , CTRANS , NTRANS , 2 )
        IF ( ITRANS .LE. 0 ) GO TO 9910
C
C -- MOVE DATA TO USER INPUT BUFFER OR COMMAND BUFFER
        IF ( ITRANS .EQ. 1 ) THEN
          IF ( ICOMLN .LE. 0 ) THEN
            IBSTRT = 1
          ELSE
            IBSTRT = ICOMLN + 2
          ENDIF
          ICOMLN = IBSTRT + LENGTH - 1
          CCOMBF(IBSTRT:ICOMLN) = CINPBF(1:LENGTH)
        ELSE IF ( ITRANS .EQ. 2 ) THEN
          CLINPB = CINPBF(1:LENGTH)
          CUINPB = CINPBF(1:LENGTH)
          IINPPS = 1
          IINPLN = LENGTH
        ENDIF
C
C -- 'REWIND'
C
      ELSE IF ( ITYPE .EQ. 2 ) THEN
C
C -- REWIND FILE
        REWIND NCEXTR2
C
C -- 'CLOSE'
C
      ELSE IF ( ITYPE .EQ. 3 ) THEN
C
C -- CLOSE FILE
        ISTAT = KFLCLS ( NCEXTR2 )
C
      ELSE IF ( ITYPE .EQ. 4 ) THEN
C
C -- 'NEXT'
C
C -- READ NEXT RECORD
C
        ISTAT = KRDLIN ( NCEXTR2 , CINPBF , LENGTH )
        IF ( ISTAT .LT. 0 ) GO TO 8910
        IF ( ISTAT .EQ. 0 ) GO TO 8920
C
      ELSE IF ( ITYPE .EQ. 5 ) THEN
C
C -- 'FIND'
C
C -- FIND A PARTICULAR RECORD
C
C -- READ SUBKEYWORD
C
        LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
        IF ( LENARG .LE. 0 ) GO TO 9940
C
        IFIND = KCCOMP ( CUPPER(NTYPE:NEND) , CFIND , NFIND , 2 )
        IF ( IFIND .LE. 0 ) GO TO 9910
C
        IF ( IFIND .EQ. 1 ) THEN
C -- EITHER READ SEARCH STRING FROM INPUT LINE
          LENSER = KCCARG ( CUPPER , IDIRPS , 2 , NSER , NEND )
          IF ( LENSER .LE. 0 ) GO TO 9950
          CSERCH = CLOWER(NSER:NEND)
        ELSE IF ( IFIND .EQ. 2 ) THEN
C -- OR GET IT FROM THE COMMAND BUFFER
          LENSER = ICOMPS
          CSERCH = CCOMBF(1:LENSER)
        ENDIF
C
C -- SEARCH ENTIRE FILE FOR THE STRING
        REWIND NCEXTR2
2500    CONTINUE
          ISTAT = KRDLIN ( NCEXTR2 , CINPBF , LENGTH )
          IF ( ISTAT .LT. 0 ) GO TO 8910
          IF ( ISTAT .EQ. 0 ) GO TO 8920
C -- SEARCH ONLY ALLOWS STRING TO BE AT BEGINNING OF LINE
CDJWMAR97
          CALL XCCUPC (CINPBF(1:LENSER), CINPBF(1:LENSER))
          CALL XCCUPC (CSERCH(1:LENSER) ,CSERCH(1:LENSER))
          IF ( CINPBF(1:LENSER) .NE. CSERCH(1:LENSER) ) GO TO 2500
C
      ENDIF
C
      GO TO 9000
C
8900  CONTINUE
C -- SET ERROR FLAG, SO SCRIPT CAN TAKE APPROPRIATE ACTION
      CALL XERHND ( IERSFL )
      GO TO 9000
8910  CONTINUE
C -- READ ERROR ON EXTRACT FILE
      GO TO 8900
8920  CONTINUE
C -- END OF FILE ERROR ON EXTRACT FILE
      GO TO 8900
C
C
9000  CONTINUE
C
      KSCETR2 = 0
C
      RETURN
C
9900  CONTINUE
      GO TO 9000
9910  CONTINUE
      CALL XSCMSG ( MILLEG , MKEYWD , CUPPER(NTYPE:NEND) , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MMISSG , MKEYWD , ' ' , 0 )
      GO TO 9900
9950  CONTINUE
      CALL XSCMSG ( MMISSG , MDATA , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCEVL
      FUNCTION KSCEVL ( IN )
C
C -- EVALUATE EXPRESSION.
C
C -- THIS ROUTINE IMPLEMENTS THE SCRIPT 'EVALUATE' INSTRUCTION
C
C  'IN' IS A DUMMY ARGUMENT
C
C      RETURN VALUE OF KSCEVL IS THE VALUE TO BE USED FOR 'KSCPRC'
C
C
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      CHARACTER*(MAXLAB) CVARIB
C
      INCLUDE 'XSCCHR.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
C
C -- FIND NAME OF RESULT VARIABLE
C
      ISTAT = KSCADR ( IADDR , CVARIB , ITYPE , IVALUE )
      IF ( ISTAT .LE. 0 ) GO TO 9900
C
C -- FIND '=' SIGN
      LENEQU = KCCARG ( CUPPER , IDIRPS , 1 , NEQU , NEND )
      IF ( LENEQU .LE. 0 ) GO TO 9910
      IF ( CUPPER(NEQU:NEND) .NE. '=' ) GO TO 9910
C
C -- FIND EXPRESSION, AND CHECK TYPE AGAINST THE TYPE OF THE VARIABLE.
C
      ISTAT = KSCEXP ( IRESLT , IRTYPE , CUPPER , CLOWER , IDIRPS , 1 )
      IF ( ISTAT .LT. 0 ) GO TO 9900
      IF ( ISTAT .EQ. 0 ) GO TO 9930
      IF ( ITYPE .NE. IRTYPE ) GO TO 9920
C
C -- STORE RESULT
C
C -- MAKE SPECIAL PROVISION FOR KEEPING CHARACTER RESULT. VARIABLE
C    ALREADY HAS DESCRIPTOR WHICH CAN HOLD RESULT, SO USE THAT.
C
      IF ( IRTYPE .EQ. 4 ) THEN
        NEWVAL = IRESLT
        IRESLT = IVALUE
        ISTAT = KSCSDD ( 2 , NEWVAL , IRESLT )
      ENDIF
C
C
      ISTAT = KSCIDN ( 1 , 3 , CVARIB , 1 , ITYPE , IID , IRESLT , 1 )
      IF ( ISTAT .LE. 0 ) GO TO 9900
C
9900  CONTINUE
      KSCEVL = 0
C
      RETURN
C
C
9910  CONTINUE
C -- INCORRECT '='
      CALL XSCMSG ( MILLMS , MEQUAL , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
C -- INCORRECT EXPRESSION TYPE
      CALL XSCMSG ( MINCOR , MEXPRE , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
C -- NO EXPRESSION
      CALL XSCMSG ( MMISSG , MEXPRE , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCEXE
      FUNCTION KSCEXE ( ICODE , XCODE , LENITM , NITEM , CTEXT )
C
C -- EXECUTE CODE GENERATED BY 'KSCEXP'
C
C -- THIS IS THE SECOND PART OF EXPRESSION EVALUATION. THIS ROUTINE
C    TAKES THE INTERPRETATION OF THE INPUT EXPRESSION PRODUCED BY
C    'KSCEXP', AND ACTUALLY DOES THE CALCULATION.
C
C
C      INPUT PARAMETERS :-
C
C            ICODE       THIS IS AN INTEGER ARRAY CONTAINING THE CODE TO
C                        BE EXECUTED.
C            XCODE       THIS IS A REAL ARRAY, EQUIVALENCED TO 'ICODE',
C                        USED TO ACCES REAL NUMBERS
C            LENITM      THE LENGTH OF EACH ITEM IN ICODE/XCODE
C            NITEM       THE NUMBER OF INDIVIDUAL EXPRESSION ITEMS
C            CTEXT       A CHARACTER REPRESENTATION OF THE ORIGINAL
C                        EXPRESSION. THIS IS USED, WITH THE ADDRESSES
C                        STORED IN EACH ITEM IN ICODE/XCODE, TO PRODUCE
C                        DIAGNOSTICS, WHEN THE EVALUATION FAILS
C
C      OUTPUT PARAMETERS :-
C        THERE ARE NO EXPLICIT OUTPUT PARAMETERS, BUT THE CALCULATION
C        DESTROYS THE CONTENTS OF ICODE/XCODE AS IT PROCEEDS, AND THE
C        RESULT WILL BE CONTAINED IN THE FIRST ELEMENT OF ICODE/XCODE
C        AT THE END OF THE EVALUATION.
C
C      RETURN VALUES :-
C            -1          EVALUATION FAILED
C            +1          EVALUATION SUCCESSFUL
C
C
C      LOCAL VARIABLES :-
C            CDATAT      CHARACTER ARRAY CONTAINING THE NAMES OF THE
C                        VARIOUS DATA TYPES ( INTEGER/REAL ETC. ) ,
C                        USED DURING DIAGNOSTIC OUTPUT.
C            IDEFOP      INTEGER ARRAY CONTROLLING OPERATOR DEFINITIONS.
C                        THERE IS AN ENTRY IN 'IDEFOP' FOR EACH OPERATOR
C                        WHICH CAN BE HANDLED BY 'KSCEXP'. THE VALUE OF
C                        THIS ENTRY POINTS TO A DEFINTION OF A 'CLASS'
C                        OF OPERATORS, CONTAINED IN 'NARGS', 'NRESLT',
C                        AND 'ITYPES'. THUS A NUMBER OF OPERATORS WILL
C                        SHARE THE SAME DEFINITION, IF THEY BELONG TO
C                        THE SAME 'CLASS'.
C
C                        FOR EXAMPLE '.EQ.' AND '.NE.'
C                        BELONG TO THE SAME CLASS, BECAUSE THEY BOTH
C                        TAKE TWO ARGUMENTS OF ANY DATA AND GIVE ONE
C                        RESULT
C
C            NARGS       NUMBER OF ARGUMENTS REQUIRED BY THIS OPERATOR.
C                        THERE MUST BE AT LEAST THIS NUMBER OF DATA
C                        ITEMS AVALAILBLE, WHEN THE OPERATOR IS FOUND
C            NRESLT      NUMBER OF RESULT VALUES GENERATED AFTER
C                        APPLICATION OF THE OPERATOR TO ITS ARGUMENTS.
C                        THIS WILL OFTEN, BUT NOT INVARIABLY, BE 1
C            ITYPES      THIS ARRAY DEFINES THE TYPES OF DATA REQUIRED
C                        FOR EACH ARGUMENT OF THE OPERATOR. THE TYPES
C                        MAY BE :-
C                              JNONE       NO DATA
C                              JINTEG      INTEGER VALUE
C                              JREAL       REAL NUMBER
C                              JLOGIC      LOGICAL VALUE
C                              JCHAR       CHARACTER VALUE
C                              JANY        ANY DATA
C                              JSAME       SAME AS TYPE OF PREVIOUS ITEM
C                              JNUMER      NUMERIC DATA ( I.E. INTEGER
C                                          OR REAL )
C
C            JVALUE      ADDRESS IN EACH ITEM IN ICODE/XCODE OF DATA
C                        VALUE, IF ANY
C            JVTYPE      ADDRESS OF TYPE OF VALUE ( INTEGER/REAL ETC. )
C            JCTYPE      ADDRESS OF TYPE OF THIS ITEM (DATA OR OPERATOR)
C            JPOSTK      ADDRESS OF POSITION OF ITEM IN INPUT EXPRESSION
C
C            NOPER       NUMBER OF OPERATORS KNOWN
C            NUBASE      NUMBER OF UNARY OPERATORS KNOWN
C            NARGMX      MAXIMUM NUMBER OF ARGUMENTS FOR AN OPERATOR
C            NOTYPE      NUMBER OF OPERATOR CLASSES
C
cdjwjul09
c            cfmat       format expression for internal writes of 
c                        floating numbers
      character*32  cfmat
C
      CHARACTER*(*) CTEXT 
C
      PARAMETER ( JVALUE = 1 , JVTYPE = 2 , JCTYPE = 3 )
      PARAMETER ( JPOSTK = 4 )
CDEC08  1 NEW UNARY OPERATOR
C       REAL=ABS(REAL)
cjan18  New Binary Operator
c       REAL = REAL MOD (REAL) or INT
C
CJAN02  1 NEW UNARY OPERATOR
C       CHAR=GETENV(CHAR)
C
CJAN99  2 NEW UNARY OPERATORS
C       CHAR=FIRSTSTR(CHAR) AND INT=FIRSTINT(CHAR)
C
CAPR99  1 NEW UNARY OPERATOR:
C       REAL=SQRT(REAL)
C
CMAY99  3 NEW UNARY OPERATORS:
C       CHAR=GETPATH(CHAR), CHAR=GETFILE(CHAR), CHAR=GETTITLE(CHAR)
CMAY99  3 NEW UNARY OPERATORS:
C        LOGICAL=FILEEXISTS(CHAR)
C        LOGICAL=FILEDELETE(CHAR)
C        LOGICAL=FILEISOPEN(CHAR)
CMAY99  1 NEW UNARY OPERATOR:
C       CHAR=GETEXTN(CHAR)
CAUG00  1 NEW OPERATOR
C       CHAR=GETCWD()
CFEB01  1 NEW BINARY OPERATOR 'POWER'
C       REAL = REAL ** REAL
CFEB01  1 NEW UNARY OP:
C       REAL = RANDOM
CAUG02  2 NEW BINARY OPS:
C       INT = INT IOR INT
C       INT = INT IAND INT
CJUN03  2 NEW UNARY OPS:
C       CHAR=COMPRESS(CHAR) - removes extra spaces
C       CHAR=SPGTOCRY(CHAR) - tries to fix up Xprep style space groups
cdjwMar-2017
C       CHAR=PACK(CHAR) - REMOVES ALL SPACES AND LEFT-PACKS
C
cdjwdec08
      PARAMETER ( NOPER = 58 , NUBASE = 29 )
      PARAMETER ( NARGMX = 3 , NOTYPE = 14 )
C
      PARAMETER ( JNONE = 0 )
      PARAMETER ( JINTEG = 1 , JREAL = 2 , JLOGIC = 3 )
      PARAMETER ( JCHAR = 4 )
      PARAMETER ( JANY = 5 , JSAME = 6 , JNUMER = 7 )
C
      CHARACTER*12 CDATAT(JNONE:JNUMER)
      CHARACTER*12  CSPOPS
      CHARACTER*5   CSPNMS
C
      DIMENSION ICODE(LENITM,NITEM)
      DIMENSION XCODE(LENITM,NITEM)
C
      DIMENSION IDEFOP(NOPER)
C
      DIMENSION NARGS(NOTYPE) , NRESLT(NOTYPE)
      DIMENSION ITYPES(NARGMX,NOTYPE)
C
      DIMENSION IARG(NARGMX) , ITYPE(NARGMX) , IPOSIT(NARGMX)
C
      PARAMETER ( LENWRK = 256 )
      CHARACTER*(LENWRK) CWORK1 , CWORK2
C
      CHARACTER*6 CLOGIC(0:1)
C
      CHARACTER*1 CECT
      LOGICAL LRESLT , LEQUAL , LLESST
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSCCHK.INC'
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      DATA IDEFOP / 1 , 1 , 2 , 2 , 2 , 2 , 3 , 3 , 3 , 3 ,
     2              2 , 2 , 2 , 2 , 2 , 2 , 2 , 2 , 5 , 5 ,
     3              6 , 7 , 11, 11, 2,  2 , 2 , 2 , 2 ,
CJAN99  abs dec08
     4           8 , 9 ,  9 , 10 ,  8 , 10 ,  4 , 12 , 13 , 10 ,
     5          12 ,12 , 12,   4 , 12 , 12 , 12 , 12 , 12 , 12 ,
     6          12 ,12 , 13,  12 , 12 , 12 ,  4 , 12 , 12 /
C
      DATA NARGS  /0 , 2 , 2 , 1 , 2 , 2 , 3 , 1 , 1 , 1 , 2 , 1 , 1, 0/
      DATA NRESLT /0 , 1 , 1 , 1 , 1 , 2 , 1 , 1 , 1 , 1 , 1 , 1 , 1, 1/
C
      DATA ITYPES /                 JNONE  , JNONE  , JNONE  ,
     2 JNUMER , JSAME  , JNONE  ,   JANY   , JSAME  , JNONE  ,
     3 JREAL  , JNONE  , JNONE  ,   JLOGIC , JLOGIC , JNONE  ,
     4 JANY   , JLOGIC , JNONE  ,   JANY   , JSAME  , JLOGIC ,
     5 JLOGIC , JNONE  , JNONE  ,   JNUMER , JNONE  , JNONE  ,
     6 JINTEG , JNONE  , JNONE  ,     JCHAR  , JCHAR  , JNONE   ,
     7 JCHAR  , JNONE  , JNONE  ,     JANY   , JNONE  , JNONE,
     8 JREAL  , JNONE  , JNONE  /
C
      DATA CDATAT / 'none' , 'integer' , 'real' , 'logical' ,
     2              'character' , 'any' , 'same' , 'numeric' /
C
      DATA CLOGIC / 'FALSE' , 'TRUE' /
      DATA CSPOPS / 'abcdnmABCDNM' /
      DATA CSPNMS / '12346' /
C
      NLAST = 0
C
C -- SCAN THROUGH DATA
C
      DO 2000 I = 1 , NITEM
C
C -- NUMERIC DATA IS PUSHED TOWRDS THE FRONT OF THE LIST
C
        IF ( ICODE(JCTYPE,I) .EQ. 1 ) THEN
          NLAST = NLAST + 1
          IF ( NLAST .EQ. I ) GO TO 2000
          CALL XMOVEI (ICODE(JVALUE,I) , ICODE(JVALUE,NLAST) , LENITM )
          GO TO 2000
        ENDIF
C
C -- OPERATORS ARE EXECUTED
C
        IOPER = ICODE(JVALUE,I)
        IOPPOS = ICODE(JPOSTK,I)
C
        IDEFIN = IDEFOP(IOPER)
        NARGUM = NARGS(IDEFIN)
        NRES   = NRESLT(IDEFIN)
C
C -- CHECK DATA REQUIRED BY OPERATOR IS AVAILABLE. SCAN BACKWARDS
C
        IF ( NARGUM .GT. NLAST ) GO TO 9910
C
        IADDR = NLAST
        DO 1200 J = 1 , NARGUM
          IF ( ICODE(JCTYPE,IADDR) .NE. 1 ) GO TO 9910
C
          IARG(J) = IADDR
          ITYPE(J) = ICODE(JVTYPE,IADDR)
          IPOSIT(J) = ICODE(JPOSTK,IADDR)
          IADDR = IADDR - 1
1200    CONTINUE
C
C -- CHECK TYPES OF DATA
C
        ILAST = 0
        DO 1300 J = 1 , NARGUM
          IREQ = ITYPES(J,IDEFIN)
C
          IF ( IREQ .EQ. JANY ) THEN
          ELSE IF ( IREQ .EQ. JNONE ) THEN
            GO TO 9920
          ELSE IF ( IREQ .EQ. JSAME ) THEN
            IF ( ILAST .NE. ITYPE(J) ) GO TO 9920
          ELSE IF ( IREQ .EQ. JNUMER ) THEN
            IF ( ( ITYPE(J) .NE. JINTEG ) .AND.
     2           ( ITYPE(J) .NE. JREAL ) ) GO TO 9920
          ELSE
            IF ( ITYPE(J) .NE. IREQ ) GO TO 9920
          ENDIF
C
          ILAST = ITYPE(J)
1300    CONTINUE
C
        NLAST = NLAST - NARGUM + NRES
C
C -- DATA CHECK WAS O.K.
C
C -- OPERATORS 1 AND 2 ARE '(' AND ')' AND DO NOT CAUSE ANY EXECUTION
C
C
      IF ( IOPER .GT. NUBASE ) GO TO 5000
C
      GO TO ( 8000 , 8000 , 4010 , 4020 , 4030 ,
     2        4040 , 4050 , 4050 , 4050 , 4050 ,
     3        4050 , 4050 , 4050 , 4050 , 4050 ,
     4        4050 , 4050 , 4050 , 4100 , 4110 ,
     5        8000 , 4120 , 4130 , 4140 , 4150 ,
     6        4160 , 4170 , 4180 , 4155 ,
     6        9940 ) , IOPER
      GO TO 9940
C
C
C
4010  CONTINUE
C
C -- 'ADD'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = ICODE(JVALUE,IARG(2)) +
     2                              ICODE(JVALUE,IARG(1))
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = XCODE(JVALUE,IARG(2)) +
     2                              XCODE(JVALUE,IARG(1))
          ENDIF
C
      GO TO 8000
C
C
4020  CONTINUE
C
C -- 'SUBTRACT'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = ICODE(JVALUE,IARG(2)) -
     2                              ICODE(JVALUE,IARG(1))
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = XCODE(JVALUE,IARG(2)) -
     2                              XCODE(JVALUE,IARG(1))
          ENDIF
C
      GO TO 8000
C
C
4030  CONTINUE
C
C -- 'MULTIPLY'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = ICODE(JVALUE,IARG(2)) *
     2                              ICODE(JVALUE,IARG(1))
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = XCODE(JVALUE,IARG(2)) *
     2                              XCODE(JVALUE,IARG(1))
          ENDIF
C
      GO TO 8000
C
C
4040  CONTINUE
C
C
C -- 'DIVIDE'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = ICODE(JVALUE,IARG(2)) /
     2                              ICODE(JVALUE,IARG(1))
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = XCODE(JVALUE,IARG(2)) /
     2                              XCODE(JVALUE,IARG(1))
          ENDIF
      GO TO 8000
C
C
4050  CONTINUE
C
C -- 'LOGICAL OPERATIONS'
          IF ( ITYPE(1) .NE. 2 ) THEN
            ISTAT = KSCREL ( ICODE(JVALUE,IARG(2)) , ITYPE(1) ,
     2                       ICODE(JVALUE,IARG(1)) , ITYPE(1) ,
     3                       LEQUAL , LLESST )
          ELSE
            ISTAT = KSCREL ( ICODE(JVALUE,IARG(2)) , ITYPE(1) ,
     2                       ICODE(JVALUE,IARG(1)) , ITYPE(1) ,
     3                       LEQUAL , LLESST )
          ENDIF
          IF ( ( IOPER .EQ. 7 ) .OR. ( IOPER .EQ. 8 ) ) THEN
            LRESLT = LEQUAL
          ELSE IF ( ( IOPER .EQ. 9 ) .OR. ( IOPER .EQ. 10 ) ) THEN
            LRESLT = .NOT. LEQUAL
          ELSE IF ( ( IOPER .EQ. 11 ) .OR. ( IOPER .EQ. 12 ) ) THEN
            LRESLT = LLESST .OR. LEQUAL
          ELSE IF ( ( IOPER .EQ. 13 ) .OR. ( IOPER .EQ. 14 ) ) THEN
            LRESLT = .NOT. LLESST
          ELSE IF ( ( IOPER .EQ. 15 ) .OR. ( IOPER .EQ. 16 ) ) THEN
            LRESLT = LLESST
          ELSE IF ( ( IOPER .EQ. 17 ) .OR. ( IOPER .EQ. 18 ) ) THEN
            LRESLT = .NOT. ( LLESST .OR. LEQUAL )
          ENDIF
C
          IF ( LRESLT ) THEN
            ICODE(JVALUE,IARG(2)) = 1
          ELSE
            ICODE(JVALUE,IARG(2)) = 0
          ENDIF
          ICODE(JVTYPE,IARG(2)) = 3
C
      GO TO 8000
C
C
4100  CONTINUE
C
C -- 'OR'
C
          ICODE(JVALUE,IARG(2)) =
     2       MAX0 ( ICODE(JVALUE,IARG(2)) , ICODE(JVALUE,IARG(1)) )
C
C
      GO TO 8000
C
C
4110  CONTINUE
C
C -- 'AND'
C
          ICODE(JVALUE,IARG(2)) =
     2       MIN0 ( ICODE(JVALUE,IARG(2)) , ICODE(JVALUE,IARG(1)) )
C
C
      GO TO 8000
C
C
4120  CONTINUE
C
C -- '.ELSE.'
C
          IF ( ICODE(JVALUE,IARG(3)) .GT. 0 ) THEN
            IFROM = 2
          ELSE
            IFROM = 1
          ENDIF
          CALL XMOVEI ( ICODE(JVALUE,IARG(IFROM)) ,
     2                 ICODE(JVALUE,IARG(3)) , LENITM )
C
      GO TO 8000
C
C
4130  CONTINUE
C
C -- 'CONCATENATE'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(2)) , CWORK1 , LEN1 )
      IF ( LEN1 .LT. LENWRK ) THEN
        ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)),CWORK1(LEN1+1:), LEN2 )
      ELSE
        LEN2 = 0
      ENDIF
      ISTAT = KSCSCD ( CWORK1(1:LEN1+LEN2) , ICODE(JVALUE,IARG(2)) )
C
      GO TO 8000
C
C
4140  CONTINUE
C
C -- 'STARTSWITH'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(2)) , CWORK1 , LEN1 )
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK2 , LEN2 )
C
      IF ( LEN1 .LE. 0 ) THEN
        LRESLT = .FALSE.
      ELSE IF ( LEN2 .LE. 0 ) THEN
        LRESLT = .TRUE.
      ELSE IF ( LEN2 .GT. LEN1 ) THEN
        LRESLT = .FALSE.
      ELSE
        LRESLT = ( CWORK1(1:LEN2) .EQ. CWORK2(1:LEN2) )
      ENDIF
C
      IF ( LRESLT ) THEN
        ICODE(JVALUE,IARG(2)) = 1
      ELSE
        ICODE(JVALUE,IARG(2)) = 0
      ENDIF
      ICODE(JVTYPE,IARG(2)) = 3
C
      GO TO 8000
C
C
4150  CONTINUE
C
C -- '**'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = ICODE(JVALUE,IARG(2)) **
     2                              ICODE(JVALUE,IARG(1))
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = XCODE(JVALUE,IARG(2)) **
     2                              XCODE(JVALUE,IARG(1))
          ENDIF
C
      GO TO 8000
C

4155  CONTINUE
C
C -- 'MOD'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = MOD(ICODE(JVALUE,IARG(2)) ,
     2                              ICODE(JVALUE,IARG(1)))
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = MOD(XCODE(JVALUE,IARG(2)) ,
     2                              XCODE(JVALUE,IARG(1)))
          ENDIF
C
      GO TO 8000
C

C
4160  CONTINUE
C
C -- 'IOR'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = OR ( ICODE(JVALUE,IARG(2)), 
     2                                    ICODE(JVALUE,IARG(1)) )
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = OR ( NINT(XCODE(JVALUE,IARG(2))), 
     2                                    NINT(XCODE(JVALUE,IARG(1))) )
          ENDIF
C
      GO TO 8000
C
C
4170  CONTINUE
C
C -- 'IAND'
C
          IF ( ITYPE(1) .EQ. 1 ) THEN
            ICODE(JVALUE,IARG(2)) = IAND ( ICODE(JVALUE,IARG(2)), 
     2                                     ICODE(JVALUE,IARG(1)) )
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN
            XCODE(JVALUE,IARG(2)) = IAND ( NINT(XCODE(JVALUE,IARG(2))), 
     2                                     NINT(XCODE(JVALUE,IARG(1))) )
          ENDIF
C
      GO TO 8000
C
4180  CONTINUE
C
C -- 'IDECMASK'
C What is this strange op? The decimal number on the left (an integer) is
C masked by any zeroes in the decimal number on the right. Hence:
C 1234 IDECMASK 0101 = 204. Useful?
C Only the leftmost 9 digits of each number are used.

          IF ( ITYPE(1) .EQ. 1 ) THEN
            IMASK = ICODE(JVALUE,IARG(1))
            IDEC  = ABS(ICODE(JVALUE,IARG(2)))
            IRES  = 0
            DO IDM = 0,8
              ISHIFT = MOD(IDEC,10) * 10**IDM
              IF ( MOD ( IMASK, 10 ) .NE. 0 ) THEN
                IRES = IRES + ISHIFT
              END IF
              IMASK = IMASK - MOD ( IMASK, 10 )
              IMASK = NINT ( IMASK / 10.0 )
              IDEC  = IDEC  - MOD(IDEC,10)
              IDEC  = FLOOR ( IDEC  / 10.0 )
            END DO
            ICODE(JVALUE,IARG(2)) = IRES
          ELSE IF ( ITYPE(1) .EQ. 2 ) THEN

            IMASK = NINT(XCODE(JVALUE,IARG(1)))
            IDEC  = ABS(NINT(XCODE(JVALUE,IARG(2))))
            IRES  = 0
            DO IDM = 0,8
              IF ( MOD ( IMASK, 10 ) .NE. 0 ) THEN
                IRES = IRES + ( MOD(IDEC,10) * 10**IDM )
              END IF
              IMASK = IMASK - MOD ( IMASK, 10 )
              IMASK = NINT ( IMASK / 10.0 )
              IDEC  = IDEC  - MOD ( IMASK, 10 )
              IDEC  = NINT ( IDEC  / 10.0 )
            END DO
            XCODE(JVALUE,IARG(2)) = IRES
          ENDIF
C
      GO TO 8000
C
C
C
C
C
5000  CONTINUE
C
C
C
C                        **** UNARY OPERATORS ****
C
C
C
      IUOPER = IOPER - NUBASE
C
      GO TO ( 5010 , 8000 , 5020 , 5030 , 8000 ,
     2        5040 , 5050 , 5060 , 5070 , 5080 ,
CJAN99  abs dec08
     3        5090 , 5100,  5110 , 5120 , 5130 ,
     3        5140 , 5150,  5160 , 5170 , 5180 , 
     4        5190 , 5200,  5210 , 5220 , 5230 ,
     5        5240 , 5250,  5260 , 5270 , 9940 ) , IUOPER
      GO TO 9940
C
C
C
C
5010  CONTINUE
C
C -- 'NOT'
C
          ICODE(JVALUE,IARG(1)) = 1 - ICODE(JVALUE,IARG(1))
C
C
      GO TO 8000
C
C
5020  CONTINUE
C
C -- 'UNARY -'
C
      IF ( ICODE(JVTYPE,IARG(1)) .EQ. 1 ) THEN
        ICODE(JVALUE,IARG(1)) = - ICODE(JVALUE,IARG(1))
      ELSE
        XCODE(JVALUE,IARG(1)) = - XCODE(JVALUE,IARG(1))
      ENDIF
C
      GO TO 8000
C
C
5030  CONTINUE
C
C -- 'EXISTS'
C
        ILIST = ICODE(JVALUE,IARG(1))
        IF ( ILIST .LE. 0 ) GO TO 9930
        IF ( ILIST .GT. 50 ) GO TO 9930
        ICODE(JVALUE,IARG(1)) = KEXIST ( ILIST )
C
      GO TO 8000
C
C
5040  CONTINUE
C
C -- 'REAL'
C
          XCODE(JVALUE,IARG(1)) = REAL ( ICODE(JVALUE,IARG(1)) )
        ICODE(JVTYPE,IARG(1)) = 2
C
C
      GO TO 8000
C
C
5050  CONTINUE
C
C -- 'INTEGER'
C
          ICODE(JVALUE,IARG(1)) = INT ( XCODE(JVALUE,IARG(1)) )
        ICODE(JVTYPE,IARG(1)) = 1
C
      GO TO 8000
C
C
5060  CONTINUE
C
C -- '.VALUE.'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      ISTAT = KSCIDN ( 2, 3, CWORK1(1:LEN1), 1, IVTYPE, IID, IVAL, 1 )
      IF ( ISTAT .LE. 0 ) GO TO 9900
C
      IF ( IVTYPE .EQ. 4 ) THEN
        IVARVL = IVAL
        ISTAT = KSCSDD ( 1 , IVARVL , IVAL )
      ENDIF
C
      ICODE(JVALUE,IARG(1)) = IVAL
      ICODE(JVTYPE,IARG(1)) = IVTYPE
C
      GO TO 8000
C
C
5070  CONTINUE
C
C -- 'CHARACTER'
C
      IDTYPE = ICODE(JVTYPE,IARG(1))
      IF ( IDTYPE .EQ. 4 ) THEN
      ELSE
        IF ( IDTYPE .EQ. 1 ) THEN
          WRITE ( CWORK1 , '(I12)' ) ICODE(JVALUE,IARG(1))
        ELSE IF ( IDTYPE .EQ. 2 ) THEN
cdjw jul09
C          WRITE ( CWORK1 , '(F12.5)' ) XCODE(JVALUE,IARG(1))
          CALL DFORM(XCODE(JVALUE,IARG(1)), CFMAT)
          WRITE ( CWORK1 , CFMAT ) XCODE(JVALUE,IARG(1))
          DO IZ = 12,9,-1     ! Remove trailing zeroes, except the one after the point
            IF ( CWORK1(IZ:IZ) .EQ. '0' ) THEN
              CWORK1(IZ:IZ) = ' '
            ELSE
              EXIT
            END IF
          END DO
        ELSE IF ( IDTYPE .EQ. 3 ) THEN
          CWORK1 = CLOGIC(ICODE(JVALUE,IARG(1)))
        ENDIF
        ISTAT = KCCTRM ( 1 , CWORK1 , ISTART , IEND )
        ISTAT = KSCSCD ( CWORK1(ISTART:IEND) , ICODE(JVALUE,IARG(1)) )
        ICODE(JVTYPE,IARG(1)) = 4
      ENDIF
C
      GO TO 8000
C
C
5080  CONTINUE
C
C -- 'KEYWORD'
C
      ICURR = ICODE(JVALUE,IARG(1))
      IF ( ICURR .LE. 0 ) GO TO 9930
      IF ( ICURR .GT. NCHKUS ) GO TO 9930
      ISTAT = KSCSCD ( CCHECK(ICURR) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
C
      GO TO 8000
C
C
5090  CONTINUE
C
C -- 'UPPERCASE'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      CALL XCCUPC ( CWORK1(1:LEN1) , CWORK2(1:LEN1) )
C
      ISTAT = KSCSCD ( CWORK2(1:LEN1) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
CJAN99
5100  CONTINUE
C
C -- 'FIRSTSTR'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
C Extract the element from a concatenated element serial combo.
C Returns a string up to the first number bracket or space.
C For example 'C1', 'C(1)', 'C 1', or ' C(1)' will return 'C'
 
      IECF = KCCNEQ(CWORK1(1:LEN1),1,' ') !Skip initial spaces
      IEC = 1
      IF ( IECF .EQ. -1 ) GOTO 8000 !No chars found at all

C Do an initial sweep for brackets
      IECOB = KCCEQL(CWORK1(1:LEN1),IECF+1,'(')
      IECCB = -1

      IF ( IECOB .NE. -1 ) THEN
        IECCB = KCCEQL(CWORK1(1:LEN1),IECOB,')')
      END IF


      IF ( IECCB .EQ. -1 ) THEN
        IECOB = 1
      END IF


      IF ( IECOB .NE. 1 ) THEN
C Sanity check: between first nonspace and (, there can be no
C more than 4 non spaces - these nonspaces must be consecutive.
        IECTOT = 0
        IECCHN = 0
        IECCON = 0
        IESTOP = 0
        DO IEC = IECF,IECOB-1
          IF ( CWORK1(IEC:IEC) .NE. ' ' ) THEN
            IECTOT = IECTOT + 1
            IECCHN = 0
          ELSE
            IF ( IECCHN .EQ. 0 ) THEN
              IECCON = IECCON + 1
              IESTOP = IEC
            END IF
            IECCHN = 1
          END IF
        END DO
        IF ( IECCON .EQ. 0 ) IESTOP = IECOB-1
        IF (( IECTOT .GT. 5 ) .OR. ( IECCON .GT. 1 )) THEN
          IECOB = 1
        END IF
        IF (( IECTOT .EQ. 0 ) .OR. ( IESTOP .EQ. IECF )) THEN
          IECOB = 1
        END IF

      END IF

      IF ( IECOB .EQ. 1 ) THEN
        IEC = 1
        DO IEC = IECF, LEN1
          READ(CWORK1(IEC:IEC),'(A1)') CECT
          IF((CECT .EQ. '(') .OR. (CECT .EQ. ' ')) EXIT
          READ(CECT,'(I1)',ERR=5101) IECT
          EXIT
5101      CONTINUE
        END DO
        ISTAT = KSCSCD ( CWORK1(1:IEC-1) , ICODE(JVALUE,IARG(1)) )
      ELSE
        ISTAT = KSCSCD ( CWORK1(1:IESTOP) , ICODE(JVALUE,IARG(1)) )
      END IF

      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
 
5110  CONTINUE
C
C -- 'FIRSTINT'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
C Extract the serial from a concatenated element serial combo.
C Returns an integer from the first number found in the string.
C For example 'C1', 'C(1)', 'C 1.0', or ' C(1)' will return '1'

      ICODE(JVTYPE,IARG(1)) = 1
      ICODE(JVALUE,IARG(1)) = -9999

      IECF = KCCNEQ(CWORK1(1:LEN1),1,' ') !Skip initial spaces
      IEC = 1
      IF ( IECF .EQ. -1 ) THEN    !No chars found at all
        ICODE(JVALUE,IARG(1)) = 0
        GOTO 8000 
      END IF

C Do an initial sweep for brackets
      IECOB = KCCEQL(CWORK1(1:LEN1),IECF+1,'(')
      IECCB = -1

      IF ( IECOB .NE. -1 ) THEN
        IECCB = KCCEQL(CWORK1(1:LEN1),IECOB,')')
      END IF


      IF ( IECCB .EQ. -1 ) THEN
        IECOB = 1
      ELSE
C Sanity check: between first nonspace and (, there can be no
C more than 4 non spaces - these nonspaces must be consecutive.
        IECTOT = 0
        IECCHN = 0
        IECCON = 0
        DO IEC = IECF,IECOB
          IF ( CWORK1(IEC:IEC) .NE. ' ' ) THEN
            IECTOT = IECTOT + 1
            IECCHN = 0
          ELSE
            IF ( IECCHN .EQ. 0 ) IECCON = IECCON + 1
            IECCHN = 1
          END IF
        END DO
        IF (( IECTOT .GT. 5 ) .OR. ( IECCON .GT. 1 )) THEN
          IECOB = 1
        END IF

      END IF

C Skip till we find an integer
      DO IEC = IECOB, LEN1
          READ(CWORK1(IEC:IEC),'(I1)',ERR=5111) IECT
          IF(CWORK1(IEC:IEC).EQ.'-') GOTO 5111
          EXIT
5111      CONTINUE
      END DO

C Skip till we find not an integer, check explictly for space and -ve.
      DO IEC2 = IEC, LEN1
          IF ( CWORK1(IEC2:IEC2) .EQ. ' ' ) GOTO 5115
          IF ( CWORK1(IEC2:IEC2) .EQ. '-' ) GOTO 5115
          READ(CWORK1(IEC2:IEC2),'(I1)',ERR=5115) IECT
      END DO
5115  CONTINUE

      IF ( IEC2-1 .LT. IEC ) THEN ! No number found
        ICODE(JVALUE,IARG(1)) = 0
        GOTO 8000
      END IF

      READ(CWORK1(IEC:IEC2-1),'(I4)')ICODE(JVALUE,IARG(1))
      GO TO 8000
C
C
5120  CONTINUE
C
C -- 'SQRT'
C
C Return the square root of the argument. 
C
        XCODE(JVALUE,IARG(1)) = SQRT ( ABS ( XCODE(JVALUE,IARG(1)) ) )
        ICODE(JVTYPE,IARG(1)) = 2
C
C
      GO TO 8000
C
5130  CONTINUE
C
C -- 'GETPATH'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
C Extract the directory from a full pathname.
C e.g. GETPATH 'c:\structures\nket\crfile.dsc' will return
C 'c:\structures\nket\'  e.g. everything up to the last slash.
      JLBS = KCLEQL(CWORK1(1:LEN1),'\')
      JLFS = KCLEQL(CWORK1(1:LEN1),'/')
      IECF = MAX(JLBS,JLFS)
      IF ( IECF .LE. 0 ) THEN
            CWORK1 = ' '
            IECF = 1
      END IF
      ISTAT = KSCSCD ( CWORK1(1:IECF) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
5140  CONTINUE
C
C -- 'GETFILE'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
C Extract the filename from a full pathname.
C e.g. GETFILE 'c:\structures\nket\crfile.dsc' will return
C 'crfile.dsc'  e.g. everything after the last slash if there is one.

      JLBS = KCLEQL(CWORK1(1:LEN1),'\')
      JLFS = KCLEQL(CWORK1(1:LEN1),'/')
      IECF = MAX(JLBS,JLFS)
      IF ( IECF .LE. 0 ) THEN
            IECF = 0
      END IF
      IECF = MIN ( IECF, LEN1 - 1 )
      ISTAT = KSCSCD ( CWORK1(IECF+1:LEN1) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
5150  CONTINUE
C
C -- 'GETTITLE'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
C Extract the filetitle from a full pathname.
C e.g. GETTITLE 'c:\structures\nket\crfile.dsc' will return
C 'crfile'  e.g. everything after the last slash if there is one,
C up to the last dot.

      JLBS = KCLEQL(CWORK1(1:LEN1),'\')
      JLFS = KCLEQL(CWORK1(1:LEN1),'/')
      IECF = MAX(JLBS,JLFS)
      IF ( IECF .LE. 0 ) THEN
            IECF = 0
      END IF
      IECG = KCLEQL(CWORK1(1:LEN1),'.')
      IF ( IECG .LE. IECF ) THEN
            IECG=LEN1+1
      ENDIF
      IECG = MAX ( IECG, IECF+2 )
      ISTAT = KSCSCD ( CWORK1(IECF+1:IECG-1) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
5160  CONTINUE
C
C -- 'FILEEXISTS'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
      CALL MTRNLG(CWORK1,'OLD',LEN1)
      INQUIRE(FILE=CWORK1(1:LEN1), EXIST=LRESLT)
#ifdef __INW__ 
      IF ( .NOT. LRESLT ) THEN
        INQUIRE(DIRECTORY=CWORK1(1:LEN1), EXIST=LRESLT)
      END IF      
#endif
      IF ( LRESLT ) THEN
          ICODE(JVALUE,IARG(1)) = 1
      ELSE
          ICODE(JVALUE,IARG(1)) = 0
      ENDIF
      ICODE(JVTYPE,IARG(1)) = 3
C
      GO TO 8000
C
5170  CONTINUE
C
C -- 'FILEDELETE'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
      CALL MTRNLG(CWORK1,'OLD',LEN1)
      INQUIRE(FILE=CWORK1(1:LEN1), EXIST=LRESLT)
      IF ( LRESLT ) THEN
          OPEN  (101,FILE=CWORK1(1:LEN1),ERR=5171)
          CLOSE (101,STATUS='DELETE',ERR=5171)
      ENDIF
5171  CONTINUE
      INQUIRE(FILE=CWORK1(1:LEN1), EXIST=LRESLT)
      IF ( LRESLT ) THEN
          ICODE(JVALUE,IARG(1)) = 0
      ELSE
          ICODE(JVALUE,IARG(1)) = 1
      ENDIF
      ICODE(JVTYPE,IARG(1)) = 3
C
      GO TO 8000
C
5180  CONTINUE
C
C -- 'FILEISOPEN'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
      INQUIRE(FILE=CWORK1(1:LEN1), OPENED=LRESLT)
      IF ( LRESLT ) THEN
          ICODE(JVALUE,IARG(1)) = 1
      ELSE
          ICODE(JVALUE,IARG(1)) = 0
      ENDIF
      ICODE(JVTYPE,IARG(1)) = 3
C
      GO TO 8000
C
5190  CONTINUE
C
C -- 'GETEXTN'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
C Extract the file extension from a full pathname.
C e.g. GETEXTN 'c:\structures\nket\crfile.dsc' will return
C 'dsc'  e.g. everything after the last dot if there is one.
      IECG = KCLEQL(CWORK1(1:LEN1),'.')
      IF ( IECG .LE. 0 ) THEN
            CWORK1 = ' '
            IECG=0
      ENDIF
      IECG = MIN ( IECG, LEN1-1 )
      ISTAT = KSCSCD ( CWORK1(IECG+1:LEN1) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
5200  CONTINUE
C
C -- 'GETCWD'
C
C Get the current crystals working directory.
C e.g. GETCWD might return 'c:\demo\nket\'  
      CALL GETCWD ( CWORK1 )
c      WRITE (99,'(A)') CWORK1
      ISTAT = KSCSCD ( CWORK1(1:) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000

5210  CONTINUE
C
C -- 'RANDOM'
C
C Return a random number between 0 and 1.
C
      XCODE(JVALUE,IARG(1)) = FRAND()
      ICODE(JVTYPE,IARG(1)) = 2
      GO TO 8000
C
5220  CONTINUE
C
C -- 'GETENV'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
C Expand any environment variables.
      CALL MTRNLG(CWORK1,'UNKNOWN',LEN1)
      ISTAT = KSCSCD ( CWORK1(1:LEN1) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
C
5230  CONTINUE
C
C -- 'COMPRESS'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      CALL XCREMS( CWORK1, CWORK1, LEN1)
      LEN1 = MAX ( LEN1, 1 )
      ISTAT = KSCSCD ( CWORK1(1:LEN1) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
C
5240  CONTINUE
C
C -- 'SPGTOCRY'
C
C Some basic things to try to ensure that the H-M space
C group read from an external source is correct:
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )

C Remove any initial spaces.
      ISTA = KCCNEQ ( CWORK1 , 1 , ' ' )
      IF ( ISTA .GT. 1 ) THEN
        CWORK1 = CWORK1(ISTA:)
      END IF

      CALL XCREMS( CWORK1, CWORK1, LEN1)
      LEN1 = MAX ( LEN1, 1 )

C (1) Second character must be a space:
      IF ( CWORK1(2:2) .NE. ' ' ) CWORK1(2:) = ' ' // CWORK1(2:)

C (2) Any opening brackets must be removed.
C (3) Any closing brackets become spaces, unless followed by '/'

      IED=1
      DO IES = 1,LEN(CWORK1)
        IF ( CWORK1(IES:IES) .NE. '(' ) THEN    ! All but open brackets
          CWORK1(IED:IED) = CWORK1(IES:IES)     ! are copied.
          IF ( CWORK1(IED:IED) .EQ. ')' ) THEN  ! If copied a close bracket
            CWORK1(IED:IED) = ' '               ! replace with space unless:
            IF ( CWORK1(IES+1:IES+1).EQ.'/' ) IED = IED - 1   !Cause overwrite.
          END IF
          IED = IED + 1
        END IF
      END DO
C (4) There is always a space after a, b, c, d, n or m
      IED=1
      DO IES = 1,LEN(CWORK1)
        CWORK2(IED:IED) = CWORK1(IES:IES)
        DO JES = 1,12
          IF ( CWORK1(IES:IES) .EQ. CSPOPS(JES:JES) ) THEN
            IED = IED + 1
            CWORK2(IED:IED) = ' '
            EXIT
          END IF
        END DO
        IED = IED + 1
        IF ( IED .GT. LEN(CWORK2) ) EXIT
      END DO
C (5) There is always a space before 6
      IED=1
      DO IES = 1,LEN(CWORK2)
        CWORK1(IED:IED) = CWORK2(IES:IES)
        IF ( CWORK2(IES:IES) .EQ. '6' ) THEN
          CWORK1(IED:IED) = ' '
          IED = IED + 1
          CWORK1(IED:IED) = '6'
        END IF
        IED = IED + 1
        IF ( IED .GT. LEN(CWORK1) ) EXIT
      END DO
C (6a) Adjacent numbers always have #1>#2.
C (6b) Always a space after a number, unless another number or /
      IED=1
      DO IES = 1,LEN(CWORK1) - 1
        IF ( IED .GT. LEN(CWORK2) ) EXIT
        CWORK2(IED:IED) = CWORK1(IES:IES)
        IN1 = INDEX ( CSPNMS, CWORK1(IES:IES) )
        IN2 = INDEX ( CSPNMS, CWORK1(IES+1:IES+1) )
        IF ( ( IN1 .GT. 0 ) .AND. ( IN2 .GT. 0 ) ) THEN
          IF ( IN1 .LE. IN2 ) THEN
            IED = IED + 1
            IF ( IED .GT. LEN(CWORK2) ) EXIT
            CWORK2(IED:IED) = ' '
          END IF
        ELSE IF ( ( IN1 .GT. 0 ) .AND. (IN2 .LE. 0 ) ) THEN
          IF ( CWORK1(IES+1:IES+1) .NE. '/' ) THEN
            IED = IED + 1
            IF ( IED .GT. LEN(CWORK2) ) EXIT
            CWORK2(IED:IED) = ' '
          END IF
        END IF
        IED = IED + 1
        IF ( IED .GT. LEN(CWORK2) ) EXIT
      END DO
C (7) There is always a space before -, and one digit after.
      IED=1
      IMEM = 0
      DO IES = 1,LEN(CWORK2)
        IF ( IED .GT. LEN(CWORK1) ) EXIT
        CWORK1(IED:IED) = CWORK2(IES:IES)
        IF ( CWORK2(IES:IES) .EQ. '-' ) THEN
          CWORK1(IED:IED) = ' '
          IED = IED + 1
          IF ( IED .GT. LEN(CWORK1) ) EXIT
          CWORK1(IED:IED) = '-'
          IMEM = 1
        ELSE IF ( IMEM .EQ. 1 ) THEN  ! Next char should not be a space
          IF ( CWORK2(IES:IES) .NE. ' ' ) THEN
             IMEM = -1
          ELSE
             IED = IED - 1
          END IF
        ELSE IF ( IMEM .EQ. -1 ) THEN ! Next char should be a space.
          IF ( CWORK2(IES:IES) .NE. ' ' ) THEN
            CWORK1(IED:IED) = ' '
            IED = IED + 1
           IF ( IED .GT. LEN(CWORK1) ) EXIT
            CWORK1(IED:IED) = CWORK2(IES:IES)
          END IF
          IMEM = 0
        END IF
        IED = IED + 1
        IF ( IED .GT. LEN(CWORK1) ) EXIT
      END DO
      CALL XCREMS(CWORK1,CWORK2,IED)
      ISTAT = KSCSCD ( CWORK2(1:IED) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
5250  CONTINUE
C
C -- 'ABS'  dec08
C
C Return the absolute of the argument. 
C
        XCODE(JVALUE,IARG(1)) = ABS ( XCODE(JVALUE,IARG(1)) ) 
        ICODE(JVTYPE,IARG(1)) = 2
      GO TO 8000
C
5260  CONTINUE
C
C -- 'PACK'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      CALL XCRAS( CWORK1, LEN1)
      LEN1 = MAX ( LEN1, 1 )
      ISTAT = KSCSCD ( CWORK1(1:LEN1) , ICODE(JVALUE,IARG(1)) )
      ICODE(JVTYPE,IARG(1)) = 4
      GO TO 8000
C
C
5270  CONTINUE
C
C -- 'LEN'
C
      ISTAT = KSCSDC ( ICODE(JVALUE,IARG(1)) , CWORK1 , LEN1 )
      LEN1 = MAX ( LEN1, 1 )
      ICODE(JVALUE,IARG(1)) = NCTRIM( CWORK1 )
      ICODE(JVTYPE,IARG(1)) = 1
C
      GO TO 8000
 
C
C
8000  CONTINUE
C
C
C
C
2000  CONTINUE
C
      KSCEXE = 1
      RETURN
C
C
9900  CONTINUE
C
      KSCEXE = -1
      RETURN
C
9910  CONTINUE
C -- NOT ENOUGH DATA FOR THIS OPERATOR
      CALL XSCMSG ( MINSUF, MOPERA, '* This is a programming error', 0 )
      GO TO 9900
9920  CONTINUE
C -- MIXED OR INAPPROPRIATE ARGUMENT TYPES
      CALL XSCMSG ( MMIXED , MARGTP , ' ' , 0 )
      GO TO 9990
9930  CONTINUE
C -- VALUE OUT OF RANGE
      CALL XSCMSG ( MOUTRG , MARGUM , ' ' , 0 )
      GO TO 9990
9940  CONTINUE
      CALL XSCMSG ( MINTRN , MEXPRE , 'Internal error in KSCEXE' , 0 )
      GO TO 9900
9990  CONTINUE
C
C -- DESCRIBE FAILING OPERATION
C
      WRITE ( CMON, 9991)
      CALL XPRVDU(NCVDU, 6,0)
9991  FORMAT ( / , 1X, 'Failing components of input string are :' , // ,
     2 1X , 'Component' , 5X , 'Location >>' , 15X , 'Reqd. type' ,
     3  10X , 'Actual type'  , / )
      DO 9998 I = 1 , NARGUM
        IF ( I .EQ. NARGUM ) THEN
          WRITE ( CMON, 9992) CTEXT(IOPPOS-6:IOPPOS-1) ,
     2                        CTEXT(IOPPOS:IOPPOS+6)
          CALL XPRVDU(NCVDU, 1,0)
9992      FORMAT ( 1X , 'Operator' , 8X , A , ' >>' , A )
        ENDIF
      WRITE ( CMON, 9995) I , CTEXT(IPOSIT(I)-6:IPOSIT(I)-1) ,
     2                              CTEXT(IPOSIT(I):IPOSIT(I)+6) ,
     3                              CDATAT(ITYPES(I,IDEFIN)) ,
     3                              CDATAT(ITYPE(I))
      CALL XPRVDU(NCVDU, 1,0)
9995    FORMAT ( 1X, 'Operand', I3, 6X, A, ' >>', A, 8X, A, 8X, A )
C
9998  CONTINUE
      WRITE ( CMON,9999 )
      CALL XPRVDU(NCVDU, 1,0)
9999  FORMAT ( 1X )
C
      GO TO 9900
      END
CODE FOR KSCEXP
      FUNCTION KSCEXP ( IRESLT, ITYPE, CTEXT, CLTEXT, ISTART, IEVAL )
C
C -- EVALUATE EXPRESSION
C
C -- THIS ROUTINE PERFORMS THE FIRST PART OF EXPRESSION EVALUATION.
C    THIS CONSISTS OF SYNTAX CHECKING AND CONVERTING THE EXPRESSION INTO
C    A 'REVERSE POLISH' FORM WHICH IS ACTUALLY EVALUATED BY 'KSCEXE'
C
C      INPUT PARAMETERS :-
C            <NONE>
C
C      OUTPUT PARAMETERS :-
C
C      IRESLT      VALUE OF EXPRESSION
C      ITYPE       TYPE OF EXPRESSION
C                    1      INTEGER EXPRESSION
C                    2      REAL EXPRESSION
C                    3      LOGICAL EXPRESSION
C      CTEXT       TEXT FROM WHICH EXPRESSION IS TO BE EXTRACTED
C      CLTEXT      LOWERCASE COPY OF TEXT. USED AS SOURCE OF CHARACTER
C                  CONSTANTS
C      ISTART      STARTING POSITION OF EXPRESSION IN 'CTEXT'.
C                  ( UPDATED BY THIS ROUTINE )
C      IEVAL       EVALUATION FLAG
C                    0,-VE  DO NOT EVALUATE EXPRESSION
C                    1      EVALUATE EXPRESSION
C
C -- RETURN VALUES OF 'KSCEXP' :-
C      -1      ERROR IN EXPRESSION
C       0      NO EXPRESSION FOUND
C      +1      SUCCESS
C
C
C -- THE EXPRESSION IS ANALYSED IN TERMS OF THE FOLLOWING GENERAL SCHEME
C
C     <EXPRESSION> =     '(' <EXPRESSION> ')'                        OR
C                        <UNARY OPERATOR> <EXPRESSION>               OR
C                        <EXPRESSION> <BINARY OPERATOR> <EXPRESSION> OR
C                        <NUMERIC CONSTANT>                          OR
C                        <LOCAL VARIABLE>                            OR
C                        <GLOBAL VARIABLE>                           OR
C                        <STANDARD VALUE>
C
C      <UNARY OPERATOR> IS ONE OF :-
C            .NOT.       LOGICAL COMPLEMENT
C            +           UNARY PLUS
C            -           UNARY MINUS
C            EXISTS      ( CRYSTALS LIST EXISTENCE CHECK )
C            .IF.        INTRODUCES CONDITIONAL
C            REAL        INTEGER TO REAL CONVERSION
C            INTEGER     REAL TO INTEGER CONVERSION
C
C      <BINARY OPERATOR> IS ONE OF :-
C            +           ADDITION
C            -           SUBTRACTION
C            *           MULTIPLICATION
C            /           DIVISION
C            .EQ. , =    EQUALITY
C            .NE. , <>   INEQUALITY
C            .LE. , =<   LESS THAN OR EQUAL
C            .GE. , >=   GREATER THAN OR EQUAL
C            .LT. , <    LESS THAN
C            .GT. , >    GREATER THAN
C            .OR.        LOGICAL OR
C            .AND.       LOGICAL AND
C            .THEN.      COMPONENT OF CONDITIONAL EXPRESSION
C            .ELSE.      COMPONENT OF CONDITIONAL EXPRESSION
C      <NUMERIC CONSTANT> IS
C            AN INTEGER OR REAL NUMBER THAT CAN BE IDENTIFIED BY
C            'KCCNUM'
C      <LOCAL VARIABLE> IS
C            THE NAME OF A VARIABLE DEFINED IN THE CURRENT BLOCK
C      <GLOBAL VARIABLE> IS
C            THE NAME OF A VARIABLE DEFINED IN ANY BLOCK. NOTE THAT THE
C            FIRST VARIABLE OF THIS NAME TO BE DEFINED, IF THERE IS MORE
C            THAN ONE, WILL BE THE ONE USED.
C      <STANDARD VALUE> IS
C            ANY VALUE THAT CAN BE IDENTIFIED BY 'KSCEST'
C
C
C      LOCAL VARIABLES :-
C            DUMPCD      LOGICAL VARIABLE SET TRUE IF 'ISCEVE' IS SET.
C            ENDEXP      LOGICAL VARIABLE INDICATING THE END OF THE
C                        EXPRESSION HAS BEEN FOUND
C            RGTPAR      LOGICAL VARIABLE INDICATING THAT A RIGHT
C                        PARENTHESIS HAS BEEN FOUND.
C
C            JVALUE      DEFINES POSITION IN EACH OUTPUT ITEM OF DATA
C                        VALUE
C            JVTYPE      DEFINES POSITION IN EACH OUTPUT ITEM OF DATA
C                        TYPE ( INTEGER/REAL ETC. )
C            JCTYPE      DEFINES POSITION IN EACH OUTPUT ITEM OF ITEM
C                        TYPE ( DATA OR OPERATOR )
C            JPOSTK      DEFINES POSITION IN EACH OUTPUT ITEM OF
C                        POSITION OF THIS ITEM IN THE INPUT STRING
C
C            JOUTLN      DEFINES LENGTH OF AN OUTPUT ITEM
C            NOUTVL      DEFINES MAXIMUM NUMBER OF OUTPUT ITEMS
C            NOPERS      DEFINES SIZE OF 'PENDING OPERATOR STACK'
C
C            COPER       CHARACTER ARRAY CONTAINING OPERATORS
C            NOPER       NUMBER OF OPERATORS
C            LOPER       SIZE OF EACH ENTRY IN COPER
C            NBROPR      NUMBER OF BRACKET TYPE OPERATORS ( I.E. '('
C                        AND ')' )
C            IBASBR      BASE ADDRESS IN 'COPER' OF BRACKET TYPE
C            NBOPER      NUMBER OF BINARY OPERATORS
C            IBASBI      BASE ADDRESS IN 'COPER' OF BINARY OPERATORS
C            NUOPER      NUMBER OF UNARY OPERATORS
C            IBASUN      BASE ADDRESS IN 'COPER' OF UNARY OPERATORS
C
C            IPRECD      PRECEDENCE TABLE. ONE ENTRY FOR EACH OPERATOR
C                        PRECEDENCE VALUES RANGE FROM 0 TO 20
C
C            IVARIB      CURRENT DATA VALUE
C            IOUTLS      ARRAY OF OUTPUT ITEMS. THIS ARRAY IS FILLED IS
C                        FILLED BY THIS ROUTINE AND PROCESSED BY
C                        'KSCEXE'
C            XOUTLS      EQUIVALENCED TO 'IOUTLS'. THIS IS USED AS AN
C                        ARGUMENT FOR 'KSCEXE'
C            IOPRST      PENDING OPERATOR STACK. OPERATORS ARE STACKED
C                        HERE UNTIL THEY CAN BE PLACED IN THE OUTPUT
C                        LIST
C
C            NOUTLS      NUMBER OF ITEMS IN OUTPUT LIST ( SO FAR )
C            NOPRST      NUMBER OF ITEMS CURRENTLY ON PENDING OPERATOR
C                        STACK
C            NBRACK      NET NUMBER OF PARENTHESES FOUND ( + 1 FOR EACH
C                        '(', -1 FOR EACH ')'
C
C            CSTRNG      CHARACTER VARIABLE HOLDING LIST OF CHARACTERS
C                        THAT CAN BEGIN CHARACTER CONSTANTS.
C
C            NDATAT      NUMBER OF DATA TYPES RECOGNISED
C            CDATAT      CHARACTER ARRAY HOLDING DATA TYPES, USED IN
C                        VERIFICATION. ELEMENT 0 CORRESPONDS TO THE
C                        INVALID DATA TYPE RETURNED BY 'KSCEST' FOR
C                        'VALUE' AFTER 'GET TEXT' ETC.
C
C
C
C      THE FORM OF THE OUTPUT LIST IS AS FOLLOWS :-
C
C      VALUE       TYPE        COMPONENT TYPE      POSITION
C
C                  INTEGER = 1
C                  REAL = 2
C                  LOGICAL = 3
C
C                              VALUE = 1
C                              OPERATOR = 2
C
C
C -- FOR EXAMPLE, THE EXPRESSION
C
C                        1  +  2
C
C    BECOMES :-
C
C   1 ( ACTUAL VALUE )    1 ( INTEGER )    1 ( VALUE )    1 ( POSITION )
C
C   2 ( ACTUAL VALUE )    1 ( INTEGER )    1 ( VALUE )    5 ( POSITION )
C
C   3 ( '+' )             0 ( NOT USED )   2 ( OPERATOR ) 3 ( POSITION )
C
C
C
      CHARACTER*(*) CTEXT , CLTEXT
C
      LOGICAL DUMPCD
C
C
      PARAMETER ( JVALUE = 1 , JVTYPE = 2 , JCTYPE = 3 )
      PARAMETER ( JPOSTK = 4 , JOUTLN = 4 )
      PARAMETER ( NOUTVL = 100 , NOPERS = 20 )
C
      PARAMETER ( IBASBR = 1               , NBROPR =  2 )
      PARAMETER ( IBASBI = IBASBR + NBROPR , NBOPER = 27 )
CJAN99  'ABS' dec08
      PARAMETER ( IBASUN = IBASBI + NBOPER , NUOPER = 29 )
      PARAMETER ( NOPER = IBASUN + NUOPER - 1 )
      PARAMETER ( LOPER = 10 )
C
      DIMENSION IVARIB(JOUTLN)
      DIMENSION IOUTLS(JOUTLN,NOUTVL) , XOUTLS(JOUTLN,NOUTVL)
      DIMENSION IOPRST(2,0:NOPERS)
C
      LOGICAL ENDEXP , RGTPAR
C
      CHARACTER*(LOPER) COPER(NOPER)
      DIMENSION IPRECD(0:NOPER)
C
      PARAMETER ( LDATAT = 10 , NDATAT = 4 )
      CHARACTER*(LDATAT) CDATAT(0:NDATAT)
C
      CHARACTER*2 CSTRNG
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      EQUIVALENCE ( IOUTLS(1,1) , XOUTLS(1,1) )
C
      DATA IVARIB(JCTYPE) / 1 /
C
      DATA COPER /                '('   ,   ')'   ,                ! 0-2
     2                  '+'   ,   '-'   ,   '*'   ,   '/'   ,      ! 3-6    !Bop 1 - 
     3                '.EQ.'  ,   '='   ,  '.NE.' ,  '<>'   ,      ! 7-10
     4                '.LE.'  ,  '=<'   ,  '.GE.' ,  '>='   ,      !11-14
     5                '.LT.'  ,   '<'   ,  '.GT.' ,   '>'   ,      !15-18
     6                '.OR.'  , '.AND.' , '.THEN.' , '.ELSE.' ,    !19-22
     7                '//'    , 'STARTSWITH' , '**', 'IOR',        !23-26
     7                'IAND'  , 'IDECMASK', 'MOD' ,                !27-29   !Bop - 27
C
     8                '.NOT.' ,   '+'   ,   '-'   , 'EXISTS' ,     !29-32   !Uop 1 - 4
     9                '.IF.'  , 'REAL'  ,'INTEGER', '.VALUE.',     !33-36   !Uop 5 - 8
CJAN99 'ABS' dec08
     *                'CHARACTER','KEYWORD','UPPERCASE','FIRSTSTR',!37-40   !un 9-12
     1                'FIRSTINT','SQRT','GETPATH','GETFILE',       !41-44   !un 13-16
     2                'GETTITLE','FILEEXISTS','FILEDELETE',        !45-47   !un 17-19
     3                'FILEISOPEN','GETEXTN','GETCWD','RANDOM' ,   !48-51   !un 20-23
     4                'GETENV','COMPRESS','SPGTOCRY','ABS','PACK', !52-56   !un 24-28
     5                'LEN'/                                       !57      !un 29
C
      DATA IPRECD /      0    ,   200   ,    0    ,
     2                  100   ,   100   ,   120   ,   120   ,
     4                   80   ,    80   ,    80   ,    80   ,
     4                   80   ,    80   ,    80   ,    80   ,
     5                   80   ,    80   ,    80   ,    80   ,
     6                   50   ,    60   ,    30   ,    20   ,
     7                  100   ,    80   ,   190   ,    90   ,
     8                   90   ,    90   ,   190   ,
C
     8                   90   ,   180   ,   180   ,   180   ,
     9                   40   ,   180   ,   180   ,   180   ,
CJAN99 'ABS' dec08
     *                  180   ,   180   ,   180   ,   180   ,
     1                  180   ,   180   ,   180   ,   180   ,
     2                  180   ,   180   ,   180   ,
     3                  180   ,   180   ,   180   ,   200   ,
     4                  180   ,   180   ,   180   ,   180   ,
     5                  180   ,   180 /
C
      DATA CDATAT / '<invalid>', 'integer', 'real', 'logical',
     2             'character' /
C
      DATA CSTRNG / '''"' /
C
C
C -- INITIALISE PROCESSING
C
      NOUTLS = 0
      NOPRST = 0
      IOPRST(1,0) = 0
      IOPRST(2,0) = 0
      NBRACK = 0
      DUMPCD = ( ISCEVE .GT. 0 )
C
C -- CHECK FOR CASE OF NO EXPRESSION
      ISTAT = KCCNEQ ( CTEXT , ISTART , ' ' )
      IF ( ISTAT .LE. 0 ) THEN
        KSCEXP = 0
        RETURN
      ENDIF
C
C -- CREATE A NEW FRAME FOR EXPRESSION PROCESSING
C
      CALL XSCFRM ( 100 )
C
C
1000  CONTINUE
C
C -- WE EXPECT THE NEXT ITEM TO BE '(' , NUMBER , VARIABLE , STRING ETC.
C
C -- CHECK FOR STRINGS FIRST. ( USE LOWERCASE COPY FOR ACTUAL DATA )
C
      IF ( ISTART .LE. 0 ) GOTO 9910
      IF ( INDEX ( CSTRNG , CTEXT(ISTART:ISTART)  ) .GT. 0 ) THEN
        LENARG = KCCARG ( CTEXT , ISTART , 2 , NARG , NEND )
        IF ( LENARG .LE. 0 ) GO TO 9910
        ISTAT = KSCSCD ( CLTEXT(NARG:NEND) , IVALUE )
        IF ( ISTAT .LE. 0 ) GO TO 9900
C
        ITYPE = 4
        GO TO 1040
      ENDIF
C
C -- NOW DEAL WITH THE ORDINARY TYPES OF DATA
C
      LENARG = KCCARG ( CTEXT , ISTART , 1 , NARG , NEND )
      IF ( LENARG .LE. 0 ) GO TO 9910
C
C
C -- IF '(' IS FOUND :-
C      1)  PUSH '(' ONTO OPERATOR STACK
C      2)  LOOK FOR THE BEGINNING OF AN EXPRESSION (I.E. BACK TO START)
C
      IF ( CTEXT(NARG:NEND) .EQ. '(' ) THEN
        NBRACK = NBRACK + 1
        NOPRST = NOPRST + 1
        IF ( NOPRST .GT. NOPERS ) GO TO 9930
        IOPRST(1,NOPRST) = 1
        IOPRST(2,NOPRST) = NARG
        GO TO 1000
      ENDIF
C
C -- CHECK FOR UNARY OPERATOR/NUMBER/VARIABLE NAME/STANDARD DATA NAME
C
      IUOPER = KCCOMP ( CTEXT(NARG:NEND) , COPER(IBASUN) , NUOPER , 1)
      IF ( IUOPER .GT. 0 ) THEN
        IUOPER = IUOPER + IBASUN - 1
C
C -- IF UNARY OPERATOR FOUND :-
C      1)  REMOVE OPERATORS WITH HIGHER PRECEDENCE FROM STACK
C      2)  PUSH NEW OPERATOR ONTO STACK
C      3)  LOOK FOR THE BEGINNING OF AN EXPRESSION
C
C -- COMPARE OPERATOR FOUND WITH THOSE ON STACK. MOVE ANY WITH HIGHER
C    PRECEDENCE TO OUTPUT, THEN PUSH CURRENT OPERATOR TO STACK
C
          IPLACE = NOPRST + 1
          IF ( IPLACE .GT. NOPERS ) GO TO 9930
          DO 1020 I = NOPRST , 1 , -1
            IF ( ( IPRECD(IOPRST(1,I)) .GT. IPRECD(IUOPER) ) .AND.
     2         ( IOPRST(1,I) .NE. 1 ) ) THEN
            IOPRST(1,I+1) = IOPRST(1,I)
            IOPRST(2,I+1) = IOPRST(2,I)
          ELSE
            IPLACE = I + 1
            GO TO 1030
          ENDIF
1020    CONTINUE
1030    CONTINUE
        IOPRST(1,IPLACE) = IUOPER
        IOPRST(2,IPLACE) = NARG
        NOPRST = IPLACE
        GO TO 1000
      ELSE
C -- TRY TO IDENTIFY VALUE, AS NUMBER, LOCAL VARIABLE, GLOBAL VARIABLE
C    OR STANDARD VALUE
C
        ISTAT = KCCNUM ( CTEXT(NARG:NEND) , IVALUE , ITYPE )
        IF ( ISTAT .LE. 0 ) THEN
          ISTAT = KSCIDN ( 2 , 3 , CTEXT(NARG:NEND) , 1 ,
     2                     ITYPE , IID , IVALUE , -1 )
          IF ( ISTAT .GT. 0 ) THEN
C -- MAKE LOCAL COPY OF VALUE OF VARIABLE
            IF ( ITYPE .EQ. 4 ) THEN
              IVARVL = IVALUE
              ISTAT = KSCSDD ( 1 , IVARVL , IVALUE )
            ENDIF
          ELSE
              ISTAT = KSCEST ( CTEXT(NARG:NEND) , ITYPE , IVALUE )
              IF ( ISTAT .LE. 0 ) GO TO 9950
            ENDIF
        ENDIF
      ENDIF
C
C
1040  CONTINUE
C
C -- MOVE VALUE FOUND TO OUTPUT
C
      CALL XMOVEI ( IVALUE , IVARIB(JVALUE) , 1 )
      IVARIB(JVTYPE) = ITYPE
      IVARIB(JPOSTK) = NARG
C
      NOUTLS = NOUTLS + 1
      IF ( NOUTLS .GT. NOUTVL ) GO TO 9920
      CALL XMOVEI ( IVARIB , IOUTLS(JVALUE,NOUTLS) , JOUTLN )
C
1050  CONTINUE
C
C
C -- THE VALUE CAN BE FOLLOWED BY ')' OR A BINARY OPERATOR OR
C    THE END OF THE EXPRESSION.
C
      ISAVEP = ISTART
      LENOPR = KCCARG ( CTEXT , ISTART , 1 , NARG , NEND )
      ENDEXP = ( LENOPR .LE. 0 )
C
      IF ( .NOT. ENDEXP ) THEN
        RGTPAR = ( CTEXT(NARG:NEND) .EQ. ')' )
      ELSE
        RGTPAR = .FALSE.
      ENDIF
C
      IF ( RGTPAR ) THEN
        NBRACK = NBRACK - 1
        IF ( NBRACK .LT. 0 ) GO TO 9940
      ENDIF
C
C
C -- PROCESS OPERATOR FOUND
C
      IF ( .NOT. ( ENDEXP .OR. RGTPAR ) ) THEN
        IBOPER = KCCOMP ( CTEXT(NARG:NEND), COPER(IBASBI) , NBOPER , 1 )
        ENDEXP = ( IBOPER .LE. 0 )
C -- RESTORE 'IBOPER' TO SCALE 1 - N
        IBOPER = IBOPER + 2
C -- RESTORE POINTER
        IF ( ENDEXP ) ISTART = ISAVEP
      ENDIF
C
C -- IF END OF EXPRESSION, OR ')' :-
C      1)  REMOVE ALL OPERATORS BACK TO '(' OR BEGINNING OF EXPRESSION
C      2)  FOR 'END' THEN INTERPRETATION  IS FINISHED
C          FOR ')' LOOK FOR ANOTHER ')', BINARY OPERATOR OR END OF EXPR.
C
      IF ( ENDEXP .OR. RGTPAR ) THEN
        INEXT = 0
        DO 1060 I = NOPRST , 1 , -1
          IF ( RGTPAR .AND. ( IOPRST(1,I) .EQ. 1 ) ) THEN
            INEXT = I - 1
            GO TO 1070
          ENDIF
C
          NOUTLS = NOUTLS + 1
          IF ( NOUTLS .GT. NOUTVL ) GO TO 9920
          IOUTLS(JVALUE,NOUTLS) = IOPRST(1,I)
          IOUTLS(JVTYPE,NOUTLS) = 0
          IOUTLS(JCTYPE,NOUTLS) = 2
          IOUTLS(JPOSTK,NOUTLS) = IOPRST(2,I)
1060    CONTINUE
1070    CONTINUE
        NOPRST = INEXT
C
        IF ( ENDEXP ) GO TO 6000
        IF ( RGTPAR ) GO TO 1050
      ENDIF
C
C -- COMPARE OPERATOR FOUND WITH EACH ON STACK AND PUSH ONTO STACK
C    OR MOVE TO OUTPUT
C
C -- IF BINARY OPERATOR :-
C      1)  REMOVE OPERATORS WITH HIGHER PRECEDENCE FROM STACK
C      2)  PUSH NEW OPERATOR ONTO STACK
C      3)  LOOK FOR THE BEGINNING OF AN EXPRESSION
C
      DO 1200 I = NOPRST , 1 , -1
        IF ( ( IPRECD(IOPRST(1,I)) .GT. IPRECD(IBOPER) ) .AND.
     2      ( IOPRST(1,I) .NE. 1 ) ) THEN
          NOUTLS = NOUTLS + 1
          IF ( NOUTLS .GT. NOUTVL ) GO TO 9920
          IOUTLS(JVALUE,NOUTLS) = IOPRST(1,I)
          IOUTLS(JVTYPE,NOUTLS) = 0
          IOUTLS(JCTYPE,NOUTLS) = 2
          IOUTLS(JPOSTK,NOUTLS) = IOPRST(2,I)
        ELSE
          INEXT = I + 1
          GO TO 1300
        ENDIF
1200  CONTINUE
C
      INEXT = 1
C
1300  CONTINUE
C
C -- PUSH CURRENT OPERATOR
C
      IF ( INEXT .GT. NOPERS ) GO TO 9930
      IOPRST(1,INEXT) = IBOPER
      IOPRST(2,INEXT) = NARG
      NOPRST = INEXT
C
      IF ( IBOPER .EQ. 2 ) GO TO 1050
      GO TO 1000
C
C
C
6000  CONTINUE
C
C -- END OF EXPRESSION. CHECK NUMBER OF PARENTHESES
C
      IF ( NBRACK .NE. 0 ) GO TO 9940
C
C
C -- DISPLAY CODE IF VERIFY ENABLED
C
      IF ( DUMPCD ) THEN
C
        WRITE ( CMON, 7005) NOUTLS
        CALL XPRVDU(NCVDU, 1,0)
7005    FORMAT ( 1X, 'Display of generated code - ' ,  I3 , ' item(s)' )
C
        DO 7100 I = 1 , NOUTLS
          IF ( IOUTLS(JCTYPE,I) .EQ. 1 ) THEN
            IDATAT = IOUTLS(JVTYPE,I)
            IF ( IDATAT .EQ. 2 ) THEN
              WRITE ( CMON, 7012) I, CDATAT(IDATAT),
     2                                XOUTLS(JVALUE,I)
              CALL XPRVDU(NCVDU, 1,0)
7012          FORMAT ( 1X , 4X , I4 , ' : ' , 10X , A12 , 10X , F16.5 )
            ELSE
              WRITE ( CMON, 7015) I, CDATAT(IDATAT),
     2                                IOUTLS(JVALUE,I)
              CALL XPRVDU(NCVDU, 1,0)
7015          FORMAT ( 1X , 4X , I4 , ' : ' , 10X , A12 , 10X , I16 )
            ENDIF
          ELSE IF ( IOUTLS(JCTYPE,I) .EQ. 2 ) THEN
            WRITE ( CMON, 7025 ) I , COPER(IOUTLS(JVALUE,I))
            CALL XPRVDU(NCVDU, 1,0)
7025        FORMAT ( 1X , 4X , I4 , ' : ' , 32X , A16 )
          ENDIF
7100    CONTINUE
      ENDIF
C
C
C -- PROCESS OUTPUT LIST TO FORM VALUE, AND STORE CALCULATED VALUE.
C    IF AN ERROR OCCURS DURING EVALUATION, STORE A DUMMY VALUE
C
      IF ( IEVAL .GT. 0 ) THEN
        ISTAT = KSCEXE ( IOUTLS , XOUTLS , JOUTLN , NOUTLS , CTEXT )
        IF ( ISTAT .LE. 0 ) GO TO 9900
        ITYPE = IOUTLS(JVTYPE,1)
        CALL XMOVEI ( IOUTLS(JVALUE,1) , IRESLT , 1 )
      ELSE
        ITYPE = 0
        IRESLT = 0
      ENDIF
C
C -- DELETE TEMPORARY STACK FRAME
C
      CALL XSCRST
C
C
      KSCEXP = 1
      RETURN
C
C
9900  CONTINUE
      ITYPE = 0
      IRESLT = 0
C
C -- DELETE TEMPORARY STACK FRAME
C
      CALL XSCRST
C
      KSCEXP = -1
      RETURN
C
9910  CONTINUE
C -- MISSING ARGUMENT
      CALL XSCMSG ( MMISSG , MARGUM , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
C -- OUTPUT LIST OVERFLOW
      CALL XSCMSG ( MOVERF , MOUTLS , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
C -- OPERATOR STACK OVERFLOW
      CALL XSCMSG ( MOVERF , MOPRST , ' '  , 0 )
      GO TO 9900
9940  CONTINUE
C -- ILLEGAL NUMBER OF BRACKETS
      CALL XSCMSG ( MILLEG , MBRACK , ' ' , 0 )
      GO TO 9900
9950  CONTINUE
C -- ILLEGAL TOKEN IN EXPRESSION
      CALL XSCMSG ( MILLEG , MTOKEN , CTEXT(NARG:NEND) , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCEXT
      FUNCTION KSCEXT ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE SCRIPT 'EXTERNAL' INSTRUCTION
C
C -- THIS ROUTINE CAN, IF A SUITABLE LINKING ROUTINE IS AVAILABLE,
C    CAUSE EXTERNAL COMMANDS TO BE EXECUTED. THIS REQUIRES THAT THE
C    ROUTINE 'XDETCH' HAS BEEN IMPLEMENTED.
C
C      INPUT PARAMETER :-
C            IN          DUMMY
C
C      RETURN VALUE :-
C            <ANY>       VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C      LOCAL VARIABLES :-
C
C            COMMND      CHARACTER ARRAY CONTAINING NAMES OF SUBCOMMANDS
C
C
      PARAMETER ( LCOM = 4 , NCOM = 2 )
      CHARACTER*(LCOM) COMMND(NCOM)
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
C
      DATA COMMND / 'COPY' , 'SEND' /
C
C
C -- READ INSTRUCTION KEYWORD
C
      LENCOM = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENCOM .LE. 0 ) GO TO 9910
C
      ICOM = KCCOMP ( CUPPER(NTYPE:NEND) , COMMND , NCOM , 2 )
      IF ( ICOM .LE. 0 ) GO TO 9910
C
C -- FOR 'COPY' READ REST OF INPUT LINE. FOR 'SEND' USE COMMAND BUFFER
C
      IF ( ICOM .EQ. 1 ) THEN
        CALL XDETCH ( CLOWER(IDIRPS:IDIRLN) )
      ELSE IF ( ICOM .EQ. 2  ) THEN
        CALL XDETCH ( CCOMBF(1:ICOMLN) )
      ENDIF
C
      KSCEXT = 0
      RETURN
C
C
9900  CONTINUE
      KSCEXT = 0
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MILLMS , MKEYWD , ' ' , 0 )
      GO TO 9900
      END
CODE FOR KSCIDN
      FUNCTION KSCIDN ( IFUNC , ISCOPE , CNAME , ITYPE , ISUBTP ,
     2 IIDENT , IVALUE , NOTFND )
C
C -- IDENTIFIER HANDLING
C -- THIS ROUTINE CONTROLS THE IDENTIFIER LIST. INFORMATION CAN ONLY
C    BE PUT INTO THIS LIST, AND RECOVERED FROM IT, USING THIS ROUTINE.
C
C      PARAMETERS :-
C            ( IFUNC, ISCOPE, ITYPE, AND NOTFND ARE ALWAYS INPUT
C            PARAMETERS. CNAME, ISUBTP, AND IVALUE ARE INPUT
C            PARAMETERS FOR 'STORE' OPERATIONS. CNAME IS AN INPUT
C            FOR 'FIND BY NAME', IIDENT AN INPUT FOR 'FIND BY NUMBER' )
C
C
C      IFUNC       FUNCTION REQUIRED
C                        1      STORE IDENTIFIER
C                        2      FIND IDENTIFIER BY NAME
C                        3      FIND IDENTIFIER BY NUMBER
C
C      ISCOPE      SCOPE OF SEARCH FOR IDENTIFIER
C                        1      SEARCH CURRENT LEVEL ONLY FOR NAME
C                        2      SEARCH ALL LEVELS FOR NAME
C                        3     SEARCH ALL LEVELS FOR NAME, STARTING
C                              WITH THE CURRENT LEVEL AND WORKING
C                              TOWARDS THE OUTERMOST LEVEL
C      CNAME       IDENTIFIER
C      ITYPE       IDENTIFIER TYPE
C                        1      VARIABLE
C                        2      LABEL
C                        3      ERROR IDENTIFIER
C                        4      CONTINGENCY
C      ISUBTP      SUBTYPE ( NOT USED BY THIS ROUTINE. MAY TAKE ANY
C                  INTEGER VALUE )
C      IIDENT      IDENTIFIER NUMBER
C      IVALUE      IDENTIFIER VALUE
C      NOTFND      MESSAGE FLAG IF IDENTIFIER NOT FOUND
C                    -1      MESSAGE
C                    +1      NO MESSAGE
C
C      RETURN VALUES :-
C            -1          FAILURE. IDENTIFIER NOT KNOWN
C            +VE         SUCCESS. RETURN VALUE IS THE INDEX OF THE
C                        IDENTIFIER ( A COPY OF IIDENT )
C
C      LOCAL VARIABLES :-
C
C            CHARACTER REPRESENTATIONS OF INPUT ARGUMENTS USED DURING
C            VERIFICATION
C                  CSCOPE      USED TO CONVERT 'ISCOPE'
C                  CTYPE       USED TO CONVERT 'ITYPE'
C                  COPER       USED TO CONVERT 'IFUNC'
C
C            VARIABLES FORMING THE MAIN 'DATABASE' FOR IDENTIFIERS
C                  MAXIDN      PARAMETER DEFINING MAXIMUM NUMBER OF
C                              IDENTIFIERS THAT CAN BE KNOWN.
C                  CIDENT      CHARACTER ARRAY HOLDING IDENTIFIER NAMES
C                  ITYPEI      ARRAY HOLDING TYPES OF IDENTIFIERS
C                  ISBTPI      ARRAY HOLDING SUBTYPES OF IDENTIFIERS
C                  IVALUI      ARRAY HOLDING VALUES OF IDENTIFIERS
C
C            VARIABLES CONTROLLING SEARCH
C                  LMULTI      LOGICAL VARIABLE, DISTINGUISHING BETWEEN
C                              SINGLE STRUCTURE SEARCHES ( 'LOCAL' AND
C                              'GLOBAL' ), AND MULTI-STRUCTURE SEARCHES
C                              SUCH AS 'OUTWARD'
C                  LVERIF      LOGICAL VARIABLE CONTROLLING VERIFICATION
C
C
C -- THE 'SCOPE' OF A SEARCH FOR AN IDENTIFIER CAN BE EITHER 'LOCAL'
C    OR 'GLOBAL'. 'LOCAL' MEANS THAT ONLY THOSE IDENTIFIERS DEFINED IN
C    THE CURRENT BLOCK ARE CONSIDERED. 'GLOBAL' MEANS THAT ALL
C    IDENTIFIERS THAT HAVE BEEN DEFINED, AND ARE STILL DEFINED, ARE
C    CONSIDERED, IN THE ORDER THAT THEY WERE DEFINED.
C
C
C
      CHARACTER*(*) CNAME
C
      PARAMETER ( LSCP = 8 , NSCP = 3 )
      PARAMETER ( LTYP = 14 , NTYP = 5 )
      PARAMETER ( LOPR = 14 , NOPR = 3 )
      CHARACTER*(LSCP) CSCOPE(NSCP)
      CHARACTER*(LTYP) CTYPE(NTYP)
      CHARACTER*(LOPR) COPER(NOPR)
C
      LOGICAL LMULTI
      LOGICAL LVERIF
C
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCSTK.INC'
      INCLUDE 'PSCMSG.INC'
C
      PARAMETER ( MAXIDN = 200 )
C
      CHARACTER*(MAXLAB) CIDENT(MAXIDN)
      DIMENSION ITYPEI(MAXIDN) , IVALUI(MAXIDN) , ISBTPI(MAXIDN)
C
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
      SAVE CIDENT , ITYPEI , IVALUI , ISBTPI
C
      DATA CSCOPE / 'local   ' , 'global  ' , 'outward ' /
      DATA CTYPE / 'variable' , 'label' , 'error label' ,
     2             'contingency' , 'structure end' /
      DATA COPER / 'store by name ' , 'find by name  ' ,
     2 '  find by id  ' /
C
C
C
      LMULTI = ( ISCOPE .EQ. 3 )
      LVERIF = ( ISCIVE .GT. 0 )
C
C
C -- DEFINE NUMBER OF STRUCTURES TO BE SEARCHED OVER. THIS IS 1 FOR MOST
C    TYPES OF SEARCH. FOR THE MULTI-LEVEL SEARCH, IT IS EQUAL TO THE
C    NUMBER OF LEVELS.
C
      IF ( LMULTI ) THEN
        NLEVEL = KSCSTK ( JSTLVL , 0 )
      ELSE
        NLEVEL = 1
      ENDIF
C
C -- SET OUTER LIMITS ON VARIABLE NAME/TYPE LIST PRODUCED DURING ERRORS
C
      IF ( LVERIF ) THEN
        ILSBEG = MAXIDN
        ILSEND = 1
      ENDIF
C
C -- CLEAR IDENTIFIER NUMER FOR 'STORE/FIND BY NAM'
C
      IF ( ( IFUNC .EQ. 1 ) .OR. ( IFUNC .EQ. 2 ) ) THEN
        IIDENT = 0
      ENDIF
C
C -- SEARCH OVER ALL STRUCTURES. NOTE THAT A STRUCTURE IN THIS SENSE
C    MAY BE MORE THAN ONE STACK FRAME.
C
      DO 2000 ILEVEL = 0 , NLEVEL - 1
C
C -- SET PARAMETERS DEFINING SEARCH FOR THIS STRUCTURE
C
        IVARIB = KSCSTK ( JVARIB , ILEVEL )
C
        IF ( ISCOPE .EQ. 2 ) THEN
          NIDENT = IVARIB
        ELSE
          NIDENT = KSCSTK ( JNVARI , ILEVEL )
        ENDIF
C
        IF ( NIDENT .LE. 0 ) GO TO 2000
C
        IDNEND = IVARIB
        IDNBEG = IDNEND - NIDENT + 1
C
        IF ( LVERIF ) THEN
          ILSEND = MAX0 ( ILSEND , IDNEND )
          ILSBEG = MIN0 ( ILSBEG , IDNBEG )
        ENDIF
C
C -- BEGIN SEARCH
C
C -- FOR 'FIND BY NAME', LOOP OVER ALL NAMES
C
        IF ( ( IFUNC .EQ. 1 ) .OR. ( IFUNC .EQ. 2 ) ) THEN
          IF ( NIDENT .GT. 0 ) THEN
            DO 1100 I = IDNBEG , IDNEND
              IF ( ( CNAME .EQ. CIDENT(I) ) .AND.
     2             ( ITYPE .EQ. ITYPEI(I) ) ) THEN
                IIDENT = I
                GO TO 2100
              ENDIF
1100        CONTINUE
          ENDIF
C
C -- FOR 'FIND BY NUMBER' CHECK WHETHER NUMBER IS IN CURRENT RANGE
C
        ELSE IF ( IFUNC .EQ. 3 ) THEN
          IF ( ( IIDENT .GE. IDNBEG ) .AND.
     2         ( IIDENT .LE. IDNEND ) ) THEN
            CNAME = CIDENT(IIDENT)
            GO TO 2100
          ENDIF
        ENDIF
C
C
2000  CONTINUE
C
C -- IF A 'SEARCH BY NUMBER' HAS FALLEN OUT OF THE LOOP, IT IS AN ERROR
C
      IF ( IFUNC .EQ. 3 ) GO TO 9940
C
2100  CONTINUE
C
C -- CONTROL CAN BE PASSED TO THIS POINT EITHER BY PASSING THROUGH THE
C    LOOP WITHOUT FINDING A MATCH, OR DIRECTLY AFTER A MATCH.
C
C
C -- PERFORM REQUESTED OPERATION
C
      IF ( IFUNC .EQ. 1 ) THEN
C
C -- 'STORE'
C    IF THE IDENTIFIER IS UNKNOWN, THEN CREATE A NEW IDENTIFIER.
C
        IF ( IIDENT .LE. 0 ) THEN
C
        IVARIB = KSCSTK ( JVARIB , 0 ) + 1
        NVARIB = KSCSTK ( JNVARI , 0 ) + 1
          IF ( IVARIB .GT. MAXIDN ) GO TO 9920
C
          CALL XSCSTU ( JVARIB , IVARIB )
          CALL XSCSTU ( JNVARI , NVARIB )
C
          IIDENT = IVARIB
          ITYPEI(IIDENT) = ITYPE
          ISBTPI(IIDENT) = ISUBTP
          CIDENT(IIDENT) = CNAME
        ENDIF
C
C -- STORE OR UPDATE VALUE
C
        CALL XMOVEI ( IVALUE , IVALUI(IIDENT) , 1 )
C
      ELSE IF ( ( IFUNC .EQ. 2 ) .OR. ( IFUNC .EQ. 3 ) ) THEN
C
C -- FIND IDENTIFIER
C    FOR 'FIND' OPERATIONS IT IS AN ERROR IF THE IDENTIFIER IS UNKNOWN
C    THE 'TYPE' MUST BE CHECKED TO COPE WITH 'FIND BY ID' OPERATIONS.
C
        IF ( IIDENT .LE. 0 ) GO TO 9930
C
        IF ( ITYPEI(IIDENT) .NE. ITYPE ) GO TO 9910
C
C -- SET VALUE AND SUBTYPE
C
        CALL XMOVEI ( IVALUI(IIDENT) , IVALUE , 1 )
        ISUBTP = ISBTPI(IIDENT)
C
      ENDIF
C
C -- VERIFY OPERATION IF REQUIRED
C
      IF ( LVERIF ) THEN
        WRITE ( CMON, 8005 ) CSCOPE(ISCOPE) , COPER(IFUNC) ,
     2                          CTYPE(ITYPE) , CNAME , IIDENT
        CALL XPRVDU(NCVDU, 1,0)
8005    FORMAT ( 1X , A , ' ' , A , ' on ' , A , ' ' , A12 ,
     2 '  ( index: ' , I4 , ' )' )
      ENDIF
C
C
      KSCIDN = IIDENT
C
C
      RETURN
C
C
9900  CONTINUE
      IF ( ( NOTFND .GT. 0 ) .AND.
C -- PRODUCE LIST OF IDENTIFIERS KNOWN WHEN AN ERROR OCCURS
C
     2        ( LVERIF ) .AND.
     3        ( ILSEND .GE. ILSBEG ) ) THEN
        WRITE ( CMON, 9905 ) CTYPE(ITYPE), CSCOPE(ISCOPE)
        CALL XPRVDU(NCVDU, 3,0)
9905    FORMAT ( 6X , 'The following identifiers of type "' , A ,
     2 '" are known,' , / ,
     3 6X , 'using "' , A , '" search' , // ,
     4 6X , 'Index' , 8X , 'Name' )
C
        DO 9908 J = ILSBEG , ILSEND
          IF ( ITYPEI(J) .EQ. ITYPE ) THEN
            WRITE ( CMON, 9907 ) J , CIDENT(J)
            CALL XPRVDU(NCVDU, 1,0)
9907        FORMAT ( 6X , I5 , 8X , A )
          ENDIF
9908    CONTINUE
C
        WRITE ( CMON, 9909 )
        CALL XPRVDU(NCVDU, 2,0)
9909    FORMAT ( // )
      ENDIF
C
      KSCIDN = -1
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MINCON , MIDENT , CNAME , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MOVERF , MIDNLS , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
      IF ( NOTFND .LE. 0 ) GO TO 9900
      CALL XSCMSG ( MUNKNW , MIDENT , CNAME , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MOUTRG , MIDNNM , ' ' , 0 )
      GO TO 9900
      END
CODE FOR KSCINT
      FUNCTION KSCINT ( CTEXT )
C
C -- INTERRUPT PROCESSING FOR SCRIPTS
C
C -- THIS ROUTINE IS CALLED BY 'KSCVAL' EACH TIME THE USER HAS ENTERED
C    TEXT TO CHECK FOR 'INTERRUPTS'. THESE ARE STRINGS, WHICH MUST BE
C    EXTERED EXACTLY, WHICH CAUSE THE NORMAL FLOW OF THE SCRIPT TO BE
C    CHANGED.
C
C      INPUT PARAMETER :-
C
C            CTEXT       TEXT TO BE CHECKED
C
C      RETURN VALUES :-
C            -1          TEXT DOES NOT REPRESENT AN INTERRUPT
C            0           TEXT REPRESENTS AN INTERRUPT
C
C      LOCAL VARIABLES :-
C            KEYCOM      CHARACTER ARRAY HOLDING THE POSSIBLE INTERRUPT
C                        TEXTS
C
C
      CHARACTER*(*) CTEXT
C
C
      PARAMETER ( LCOM = 8 , NCOM = 3 )
      CHARACTER*(LCOM) KEYCOM(NCOM)
C
C
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XERVAL.INC'
C
C
      DATA KEYCOM / 'ERROR' , 'DIRECT' , 'END' /
C
C
      KSCINT = -1
C
C -- CHECK SUPPLIED TEXT AGAINST INTERRUPT KEYWORDS. NOTE THAT MATCH
C    MUST BE EXACT.
C
      ICOM = KCCOMP ( CTEXT , KEYCOM , NCOM , 1 )
C
      IF ( ICOM .EQ. 1 ) THEN
C
C -- 'ERROR' INTERRUPT. SET ERROR FLAG
C
        CALL XERHND ( IERSFL )
        KSCINT = 0
      ELSE IF ( ICOM .EQ. 2 ) THEN
C
C -- 'DIRECT' INTERRUPT. CLOSE ALL SCRIPT FILES.
C
        CALL XFLUNW ( 1 , 2 )
        ISCINI = 0
        KSCINT = 0
      ELSE IF ( ICOM .EQ. 3 ) THEN
C
C -- 'END' INTERRUPT. ONLY AVAILABLE IF AN 'END' CONTINGENCY HAS BEEN
C    DECLARED.
C
        ISTAT = KSCACT ( 'END' )
        IF ( ISTAT .GT. 0 ) KSCINT = 0
      ENDIF
C
      RETURN
      END
CODE FOR KSCINX
      FUNCTION KSCINX ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE 'INDEX' INSTRUCTION IN SCRIPTS
C
C
C -- THIS ROUTINE ASSIGNS A VALUE TO A NAMED VARIABLE SELECTED FROM A
C    LIST OF EXPRESSIONS ON THE BASIS OF AN INDEXING EXPRESSION.
C
C      INPUT PARAMETER :-
C            IN          DUMMY
C
C
C -- RETURN VALUES ( OF KSCINX ) :-
C
C      ( ANY )           VALUE TO BE USED AS RETURN VALUE OF KSCPRC
C
C
C
C
C
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCNT.INC'
C
      INCLUDE 'XSCCHR.INC'
C
      CHARACTER*(MAXLAB) CVAR1
C
C
C
C
C -- READ VARIABLE
C
      ISTAT = KSCADR ( IADDR1 , CVAR1 , ITYPE1 , IVALUE )
      IF ( ISTAT .LE. 0 ) GO TO 9920
C
C -- READ INDEXING EXPRESSION ( THIS MUST BE AN INTEGER EXPRESSION )
C
      ISTAT = KSCEXP ( IINDEX , ITYPEE , CUPPER , CLOWER , IDIRPS , 1 )
      IF ( ISTAT .LT. 0 ) GO TO 9920
      IF ( ISTAT .EQ. 0 ) GO TO 9940
C
      IF ( ITYPEE .NE. 1 ) GO TO 9950
C
C -- READ N EXPRESSIONS. THESE NUST ALL BE OF THE SAME TYPE AS THE
C    VARIABLE. NOTE IF N IS LE 0, THE LOOP WILL BE EXECUTED ZERO TIMES
C    AND THE VALUE OF THE VARIABLE WILL NOT BE CHANGED.
C
      DO 1500 I = 1 , IINDEX
        ISTAT = KSCEXP ( IVALUE, ITYPEE, CUPPER, CLOWER, IDIRPS, 1 )
        IF ( ISTAT .LT. 0 ) GO TO 9900
        IF ( ISTAT .EQ. 0 ) GO TO 9000
C
        IF ( ITYPEE .NE. ITYPE1 ) GO TO 9960
1500  CONTINUE
C
C -- STORE NEW VALUE
C
      ISTAT = KSCIDN ( 1, 3, CVAR1, 1 , ITYPE1 , ID , IVALUE , 1 )
C
C
9000  CONTINUE
      KSCINX = 0
      RETURN
C
C
C
C
9900  CONTINUE
      GO TO 9000
C
9920  CONTINUE
      CALL XSCMSG ( MILLMS , MVARIA , ' ' , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MMISSG , MINDEX , ' ' , 0 )
      GO TO 9900
9950  CONTINUE
      CALL XSCMSG ( MWRONG , MINDEX , ' ' , 0 )
      GO TO 9900
9960  CONTINUE
      CALL XSCMSG ( MWRONG , MEXPRE , ' ' , 0 )
      GO TO 9900
C
      END
CODE FOR KSCQUE
      FUNCTION KSCQUE ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE SCRIPT 'QUEUE' INSTRUCTION
C
C      INPUT PARAMETER :-
C            IN          DUMMY
C
C      RETURN VALUE :-
C            <ANY>       VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C
C      LOCAL VARIABLES :-
C            COPER       CHARACTER ARRAY DEFINING SUBCOMMANDS
C
C            NCQUE       INTEGER VARIABLE DEFINING QUEUE UNIT NUMBER
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      DIMENSION JDEV(4)
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XSCGBL.INC'
C
      INCLUDE 'XSCCHR.INC'
C
C
      PARAMETER ( NOPR = 4 , LOPR = 8 )
      CHARACTER*(LOPR) COPER(NOPR)
C
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XCARDS.INC'
      INCLUDE 'XSSVAL.INC'
C
C
#ifdef _HOL_
      DATA JDEV / 1HS, 1HC, 1HP, 1HQ /
#else
      DATA JDEV / 'S', 'C', 'P', 'Q' /
#endif
      DATA COPER / 'SEND' , 'REWIND' , 'PROCESS' , 'COPY' /
C
C
C
C -- READ SUBCOMMAND KEYWORD, AND CHECK AGAINST ALLOWED LIST
C
      LENTYP = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENTYP .LE. 0 ) GO TO 9940
C
      ITYPE = KCCOMP ( CUPPER(NTYPE:NEND) , COPER , NOPR , 2 )
      IF ( ITYPE .LE. 0 ) GO TO 9910
C
C
C -- 'SEND'
C
      IF ( ITYPE .EQ. 1 ) THEN
C
C -- OUTPUT COMMAND BUFFER
C
        IF ( ICOMLN .GT. 0 ) THEN
          WRITE ( NCQUE , 1005 ) CCOMBF(1:ICOMLN)
1005      FORMAT ( A )
        ENDIF
C
C -- 'REWIND'
C
      ELSE IF ( ITYPE .EQ. 2 ) THEN
C -- REWIND QUEUE FILE
C
        ENDFILE (UNIT = NCQUE, IOSTAT = IOS, ERR = 1009)
1009    CONTINUE
        REWIND  (UNIT = NCQUE, IOSTAT = IOS, ERR = 1010)
1010    CONTINUE
C
C -- 'PROCESS'
C
      ELSE IF ( ITYPE .EQ. 3 ) THEN
C
C -- REWIND QUEUE FILE, AND MAKE THIS FILE BE THE NEW SOURCE OF CRYSTALS
C    COMMANDS
C
        REWIND  (UNIT = NCQUE, IOSTAT = IOS, ERR = 1020)
1020    CONTINUE
C
        IF ( IFLIND .GE. IFLMAX ) GO TO 9920
C
            LFILE = 1
            CALL XRDOPN( 6, JDEV, ' ', LFILE)
            IF (IERFLG .LT. 0) GOTO 9930
C
        IFLIND = IFLIND + 1
        IF ((ISSPRT .EQ. 0) .AND. (ISSFLM .EQ. 1)) THEN
         WRITE(NCWU,1006) IFLIND, NCQUE , 'ScriptQ'
1006     FORMAT('SCRIPT    Opening File index=',I8, ': Unit =',I8,1X,A)
        ENDIF
C
        IRDCPY(IFLIND) = 0
        IRDLOG(IFLIND) = 1
        IRDCAT(IFLIND) = ICAT
        NCRU = NCQUE
        IFLCHR(IFLIND) = KFLCHR ( NCRU )
        IRDCMS(IFLIND) = 0
        IRDINC(IFLIND) = 10000
        IRDSCR(IFLIND) = 0
        IRDSRQ(IFLIND) = 0
C
        ICAT = IRDCAT(IFLIND)
        IUSFLG = IFLCHR(IFLIND)
C
C -- COMMAND FILE LEVEL CHANGED, SO STACK OPERATIONS ARE INVALID
C
      ISCDSB = 1
C
C
C -- 'COPY'
C
      ELSE IF ( ITYPE .EQ. 4 ) THEN
C
C -- COPY REMAINDER OF COMMAND LINE TO QUEUE FILE
C
        NSTART = KCCNEQ ( CLOWER , IDIRPS , ' ' )
        IF ( NSTART .LE. 0 ) GO TO 9950
        WRITE ( NCQUE , 1005 ) CLOWER(NSTART:IDIRLN)
C
      ENDIF
C
C
C
9000  CONTINUE
C
      KSCQUE = 0
C
      RETURN
C
9900  CONTINUE
      GO TO 9000
9910  CONTINUE
      CALL XSCMSG ( MILLEG , MKEYWD , CUPPER(NTYPE:NEND) , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MINSUF , MCHANL , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MERROR , MOPENF , ' ' , 0 )
      CALL XERIOM ( NCQUE , ISTAT )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MMISSG , MKEYWD , ' ' , 0 )
      GO TO 9900
9950  CONTINUE
      CALL XSCMSG ( MMISSG , MDATA , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCREL
      FUNCTION KSCREL ( IVAL1 , ITYPE1 , IVAL2 , ITYPE2 , LEQ , LLST )
C
C -- DETERMINES EQUALITY/ORDERING OF TWO QUANTITIES
C
C
C -- INPUT PARAMETERS :-
C
C      IVAL1       VALUE 1
C      ITYPE1      TYPE OF VALUE 1
C                    1      INTEGER
C                    2      REAL
C                    3      LOGICAL
C      IVAL2,ITYPE2 ( SAME AS ABOVE, FOR SECOND QUANTITY )
C
C
C -- OUTPUT PARAMETERS :-
C
C      LEQ          .TRUE.   IF IVAL1 EQUALS IVAL2
C                   .FALSE.  OTHERWISE
C      LLST          .TRUE.   IF IVAL1 IS LESS THEN IVAL2
C                   .FALSE.  OTHERWISE
C
C
C -- RETURN VALUES :-
C
C      KSCREL      -1      INVALID COMPARISON. DATA TYPES ARE DIFFERENT
C                  +1      SUCCESS
C
C
      PARAMETER ( JINTEG = 1 , JREAL = 2 , JLOGIC = 3 )
      PARAMETER ( JCHAR = 4 )
C
      LOGICAL LEQ , LLST
C
      EQUIVALENCE ( IVALU1 , VALUE1 )
      EQUIVALENCE ( IVALU2 , VALUE2 )
C
C
      IF ( ITYPE1 .NE. ITYPE2 ) THEN
        KSCREL = -1
        RETURN
      ENDIF
C
C
      KSCREL = 1
C
      IF ( ITYPE1 .EQ. JINTEG ) THEN
C
C -- COMPARE INTEGERS
C
        LEQ = ( IVAL1 .EQ. IVAL2 )
        LLST = ( IVAL1 .LT. IVAL2 )
      ELSE IF ( ITYPE1 .EQ. JREAL ) THEN
C
C -- COMPARE REALS
C
        CALL XMOVEI ( IVAL1 , IVALU1 , 1 )
        CALL XMOVEI ( IVAL2 , IVALU2 , 1 )
        LEQ = ( VALUE1 .EQ. VALUE2 )
        LLST = ( VALUE1 .LT. VALUE2 )
      ELSE IF ( ITYPE1 .EQ. JLOGIC ) THEN
C
C -- COMPARE LOGICAL VALUES
C
        IVALU1 = MIN0 ( 1 , MAX0 ( 0 , IVAL1 ) )
        IVALU2 = MIN0 ( 1 , MAX0 ( 0 , IVAL2 ) )
        LEQ = ( IVALU1 .EQ. IVALU2 )
        LLST = .FALSE.
      ELSE IF ( ITYPE1 .EQ. JCHAR ) THEN
C
C -- COMPARE CHARACTER VALUES
C
        ISTAT = KSCSRE ( IVAL1 , IVAL2 , LEQ , LLST )
      ELSE
        KSCREL = -1
      ENDIF
C
C
      RETURN
      END
CODE FOR KSCSAD
      FUNCTION KSCSAD ( LENGTH , IDESC )
C
C -- ALLOCATE NEW DESCRIPTOR
C
C -- THIS ROUTINE ALLOCATES A NEW 'CHARACTER STRING DESCRIPTOR'
C
C      INPUT PARAMETER :-
C            LENGTH      SIZE TO BE ALLOCATED FOR NEW DESCRIPTOR. THIS
C                        SIZE IS WRITTEN INTO THE DESCRIPTOR.
C
C      OUTPUT PARAMETER :-
C            IDESC       NUMBER OF NEW DESCRIPTOR
C
C      RETURN VALUES :-
C            -1          ERROR - NO MORE DESCRIPTORS. A MESSAGE IS
C                        OUTPUT
C            +1          SUCCESS
C
      INCLUDE 'PSCSTK.INC'
C
      INCLUDE 'XSCDSC.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XIOBUF.INC'
C
C -- FIND NEXT FREE DESCRIPTOR
C
      IDESC = KSCSTK ( JNFCHR , 0 )
      IF (ISCVER .GT. 0) THEN
            WRITE(CMON,1000) IDESC, NDESCR
1000        FORMAT(' Allocating descriptor ',I5,' / ',I5)
            CALL XPRVDU(NCVDU, 1,0)
            IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') trim(CMON(1))
      ENDIF
      IF ( IDESC .GT. NDESCR ) GO TO 9910
C
C -- CREATE NEW DESCRIPTOR.
C
      IDESCR(1,IDESC) = IDESC
      IDESCR(2,IDESC) = LENGTH
C
C -- UPDATE NEXT FREE DESCRIPTOR DETAILS
C
      CALL XSCSTU ( JNFCHR , IDESC + 1 )
C
      KSCSAD = 1
      RETURN
C
C
9900  CONTINUE
      KSCSAD = -1
      RETURN
9910  CONTINUE
C -- OUTPUT ERROR MESSAGE
      WRITE ( CMON, 9915 )
      CALL XPRVDU(NCVDU, 1,0)
9915  FORMAT ( 1X , 'No more descriptors' )
      GO TO 9900
      END
CODE FOR KSCSCD
      FUNCTION KSCSCD ( CTEXT , IDESC )
C
C -- CONVERT TEXT FROM FORTRAN CHARACTER FORM TO DESCRIPTOR
C
C      INPUT PARAMETER :-
C            CTEXT       TEXT TO BE MOVED TO DESCRIPTOR AREA
C
C      OUTPUT PARAMETER :-
C            IDESC       VARIABLE INTO WHICH DESCRIPTOR NUMBER IS
C                        WRITTEN
C
      CHARACTER*(*) CTEXT
C
C
      INCLUDE 'XSCDSC.INC'
C
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSCGBL.INC'      
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XIOBUF.INC'
C
      ISTAT = KSCSAD ( LEN ( CTEXT ) , IDESC )
      IF ( ISTAT .LT. 0 ) GO TO 9900
C
      if (iscver .gt. 0) then
       write(cmon,1000) idesc, ctext(1:len(ctext))
       call xprvdu(ncvdu,1,0)
       if (issprt .eq. 0) write(ncwu,'(a)') trim(CMON(1))
1000   format(' Descriptor',i4,' = ',A)
      endif
      CDESC(IDESCR(1,IDESC)) = CTEXT
C
      KSCSCD = 1
      RETURN
C
9900  CONTINUE
      KSCSCD = -1
      RETURN
      END
C
C
C
C
C
CODE FOR KSCSCT
      FUNCTION KSCSCT ( ISTRUC , IFUNC )
C
C -- HANDLE STRUCTURE DEFINING INSTRUCTIONS
C
C -- INPUT PARAMETERS :-
C
C      ISTRUC      STRUCTURE TYPE
C      IFUNC       FUNCTION
C                    1      BEGIN STRUCTURE
C                    2      END STRUCTURE
C -- RETURN VALUES :-
C      -1          ERROR DURING STRUCTURE OPERATION
C      +1          SUCCESS
C
C
C      LOCAL VARIABLES :-
C
C      ( DEFINITION OF INPUT SYNTAX FOR 'BEGIN STRUCTURE' )
C
C            NSTRUC      PARAMETER DEFINING NUMBER OF STRUCTURE TYPES
C                        KNOWN
C            IDEFPT      POINTER TO DEFINITION OF REQUIREMENTS OF EACH
C                        STRUCTURE TYPE WHEN IT IS BEGUN.
C            NDEFS       NUMBER OF ELEMENTS IN DEFINITION OF EACH
C                        STRUCTURE TYPE
C            IDEFKY      POINTER TO KEYWORDS USED IN DEFINTION OF EACH
C                        STRUCTURE TYPE
C            NKEYS       NUMBER OF KEYWORDS REQUIRED FOR EACH STRUCTURE
C                        TYPE.
C
C
C            NDEFIN      PARAMETER DEFINING NUMBER OF DEFINITION
C                        ELEMENTS
C            IDEFIN      ARRAY ( 2,NDEFIN ) CONTAINING THE INDIVIDUAL
C                        DEFINITION ELEMENTS. FOR EACH STRUCTURE TYPE
C                        THERE ARE POINTERS ( IDEFPT AND NDEFS )
C                        WHICH CONTROL WHICH ELEMENTS OF IDEFIN DESCRIBE
C                        THE SYNTAX OF THE PARTICULAR STRUCTURE UNDER
C                        CONSIDERATION. THE FORMAT OF EACH ELEMENT IS,
C                        FOR ELEMENT 'I' :-
C
C                        IDEFIN(1,I)      TYPE OF DATA REQUIRED :-
C                                    JINTEG      INTEGER EXPRESSION
C                                    JREAL       REAL EXPRESSION
C                                    JLOGIC      LOGICAL EXPRESSION
C                                    JEXPRE      ANY EXPRESSION
C                                    JNAME       A STRUCTURE NAME
C                                    JKEY        A KEYWORD
C                        IDEFIN(2,I)      THE NUMBER OF OCCURENCES
C                                         OF THE ITEM REQUIRED. ( 0
C                                         MEANS ITEM IS OPTIONAL )
C
C            CKEY        CHARACTER ARRAY DEFINING KEYWORDS. THE
C                        PARTICULAR KEYWORDS AVAILABLE WITH EACH
C                        STRUCTURE TYPE ARE DEFINED BY IDEFKY AND NKEYS
C
C            FOR EXAMPLE CONSIDER 'IF'. THIS IS STRUCTURE NUMBER 4
C            IDEFPT(4) IS 4,  AND NDEFS(4) IS 2. THEREFORE THE
C            SYNTAX FOR 'IF' IS DEFINED BY IDEFIN(,4) AND IDEFIN(,5)
C
C            IDEFIN(1,4) IS 'JLOGIC', IDEFIN(2,4) IS '1', WHICH MEANS
C            THAT 'IF' MUST BE FOLLOWED BY 1 LOGICAL EXPRESSION
C
C            IDEFIN(1,5) IS 'JKEY', IDEFIN(2,5) IS '1', WHICH MEANS THAT
C            THE EXPRESSION MUST BE FOLLOWED BY A KEYWORD. THE ACTUAL
C            KEYWORDS AVAILABLE ARE FOUND AS FOLLOWS :-
C
C            IDEFKY(4) IS 2, ANDS NKEYS(4) IS 1, SO THERE IS 1 KEYWORD
C            WHOSE VALUE IS GIVEN BY CKEY(2) ( I.E. 'THEN' )
C
C      ( INTERPRETATION OF INPUT FOR 'BEGIN STRUCTURE' )
C
C            IREAD       INTEGER ARRAY. EACH ELEMENT IS ZERO INITIALLY.
C                        IT IS SET TO 1 IF EXPRESSIONS ARE PROCESSED
C                        SUCCESSFULLY, AND TO THE INDEX OF THE KEYWORD
C                        IF A KEYWORD IS FOUND
C            LERROR      ( NOT USED )
C            IERROR      POSITIVE IF AN INPUT ERROR WAS FOUND
C            IEXPEV      IF SET, EXPRESSIONS ARE EVALUATED
C            LEXECU      LOGICAL VALUE. TRUE IF INSTRUCTION SHOULD BE
C                        EXECUTED. THIS IS IMPORTANT WHEN CONSIDERING
C                        WHETHER EXPRESSIONS SHOULD BE EVALUATED DURING
C                        INPUT PHASE. IF NOT SET, TYPES OF EXPRESSIONS
C                        ARE NOT CHECKED AGAINST THE DEFINITION
C
C      ( VARIABLES USED DURING EXECUTION OF STRUCTURE INSTRUCTIONS )
C
C            LSKIPL      IF TRUE, LOOP IS EXECUTED ZERO TIMES
C            LEQUAL      USED IN 'CASE AMONG' FOR COMPARISONS
C            LLESS       USED IN 'CASE AMONG' FOR COMPARISONS
C            LTERMI      IF TRUE, LOOP TERMINATION CONDITION MET
C
C
C
      PARAMETER ( JINTEG = 1 , JREAL = 2 , JLOGIC = 3 )
      PARAMETER ( JEXPRE = 4 )
      PARAMETER ( JNAME = 5 , JKEY = 6 )
C
C
      PARAMETER ( NSTRUC = 5 )
      DIMENSION IDEFPT(NSTRUC) , NDEFS(NSTRUC)
      DIMENSION IDEFKY(NSTRUC) , NKEYS(NSTRUC)
C
      PARAMETER ( LDEFIN = 2 , NDEFIN = 7 )
      DIMENSION IDEFIN(LDEFIN,NDEFIN)
C
      PARAMETER ( LKEY = 8 , NKEY = 4 )
      CHARACTER*(LKEY) CKEY(NKEY)
C
      DIMENSION IREAD(5)
      LOGICAL LSKIPL
      LOGICAL LEQUAL , LLESS
      LOGICAL LTERMI
      LOGICAL LEXECU
C
      INCLUDE 'PSCRPT.INC'
C
      CHARACTER*(MAXLAB) CSTNAM
      INCLUDE 'PSCSTK.INC'
      INCLUDE 'PSCMSG.INC'
C
      CHARACTER*(MAXLAB) CNAME
      LOGICAL LERROR
C
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCGBL.INC'
C
      DATA IDEFPT / 1 , 0 , 2 , 4 , 6 /
      DATA NDEFS  / 1 , 0 , 2 , 2 , 2 /
C
      DATA IDEFIN / JNAME  , 1 ,   JINTEG , 0 ,   JKEY   , 0 ,
     2              JLOGIC , 1 ,   JKEY   , 1 ,   JEXPRE , 1 ,
     3              JKEY   , 0 /
C
      DATA IDEFKY / 0 , 0 , 1 , 2 , 3 /
      DATA NKEYS  / 0 , 0 , 1 , 1 , 2 /
C
      DATA CKEY / 'TIMES' , 'THEN' , 'RANGE' , 'AMONG' /
C
C
      IERROR = -1
C
C -- CHECK IF INSTRUCTIONS SHOULD BE EXECUTED ( ONLY IF OUTER BLOCK
C    IS BEING EXECUTED )
C
      IF ( ISCINI .GT. 0 ) THEN
        LEXECU = ( KSCSTK ( JEXECU , 0 ) .GT. 0 )
      ELSE
        LEXECU = .FALSE.
      ENDIF
C
C
C -- FOR 'BEGIN' TYPE OPERATIONS, COMPLETE INPUT PROCESSING
C
      IF ( IFUNC .EQ. 1 ) THEN
        IDEF1 = IDEFPT(ISTRUC)
        IDEFEN = IDEF1 + NDEFS(ISTRUC) - 1
C
        IEXPEV = 0
        IF ( LEXECU ) IEXPEV = 1
C
        ICOMP = 0
        DO 1200 I = IDEF1 , IDEFEN
          ICOMP = ICOMP + 1
          ITYPE = IDEFIN(1,I)
          IREAD(ICOMP) = 0
C
          IF ( ITYPE .LE. JEXPRE ) THEN
C -- READ EXPRESSION, AND CHECK TYPE IF NECESSARY
            ISTAT = KSCEXP ( IVALUE, IEXTYP, CUPPER, CLOWER, IDIRPS,
     2                                                          IEXPEV )
            IF ( ISTAT .LT. 0 ) IERROR = 1
            IF ( ISTAT .EQ. 0 ) GO TO 1200
C
            IF ( LEXECU .AND. ( ITYPE .NE. JEXPRE ) ) THEN
              IF ( IEXTYP .NE. ITYPE ) GO TO 1200
            ENDIF
            IREAD(ICOMP) = 1
          ELSE IF ( ITYPE .EQ. JNAME ) THEN
C -- READ NAME
            LENNAM = KCCARG ( CUPPER , IDIRPS , 1 , NNAME , NEND )
            IF ( LENNAM .LE. 0 ) GO TO 1200
            CNAME = CUPPER(NNAME:NEND)
            IREAD(ICOMP) = 1
          ELSE IF ( ITYPE .EQ. JKEY ) THEN
C -- READ AND CHECK KEYWORD
            LENKEY = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
            IF ( LENKEY .LE. 0 ) GO TO 1200
            IKEY = KCCOMP ( CUPPER(NARG:NEND) ,
     2                      CKEY(IDEFKY(ISTRUC)) , NKEYS(ISTRUC) , 1 )
            IF ( IKEY .LE. 0 ) GO TO 1200
            IREAD(ICOMP) = IKEY
          ENDIF
1200    CONTINUE
C
C -- CHECK IF INPUT WENT OK
C
        ICOMP = 1
        DO 1300 I = IDEF1 , IDEFEN
          IF ( IREAD(ICOMP) .LT. IDEFIN(2,I) ) GO TO 9920
          ICOMP = ICOMP + 1
1300    CONTINUE
C
C -- CHECK IF THE END OF THE CURRENT STRUCTURE IS KNOWN
C
        IBLEND = 0
        IF ( ISCINI .GT. 0 ) THEN
          ICURR = IRDREC(IFLIND)
          CALL XSCSNM ( ISTRUC , ICURR , CSTNAM )
          ISTAT = KSCIDN ( 2, 1, CSTNAM, 5, ISUBTP, IDENT, IBLEND, 0 )
          IF ( ISTAT .LE. 0 ) IBLEND = 0
        ENDIF
      ELSE
C
C -- FOR 'END' TYPE OPERATIONS, REMEMBER TYPE AND STARTING ADDRESS OF
C    CURRENT STRUCTURE
        IOLDTP = KSCSTK ( JBTYPE , 0 )
        IOLDST = KSCSTK ( JBSTRT , 0 )
      ENDIF
C
      IF ( IERROR .GT. 0 ) GO TO 9920
C
C
C                      ***********************
C                      * EXECUTE INSTRUCTION *
C                      ***********************
C
      IF ( IFUNC .EQ. 1 ) THEN
        GO TO ( 2100 , 2200 , 2300 , 2400 , 2500 , 9910 ) , ISTRUC
        GO TO 9910
      ELSE IF ( IFUNC .EQ. 2 ) THEN
        GO TO ( 5100 , 5200 , 5300 , 5400 , 5500 , 9910 ) , ISTRUC
        GO TO 9910
      ENDIF
C
C
C
C
2100  CONTINUE
C
C -- 'SCRIPT'
C
C -- CREATE NEW STACK FRAME
C
      CALL XSCFRM ( ISTRUC )
C
C----- STORE SCRIPT NAME
      ISTAT = KSCSCD ( CNAME, ISRPNM)
      ISTAT = KSCIDN (1, 1, 'SCRIPTNAME', 1, 1, IDSCP, ISRPNM, -1)
C -- ENABLE EXECUTION
C
      CALL XSCSTU ( JEXECU , 1 )
      GO TO 4000
C
C
2200  CONTINUE
C -- 'BLOCK'
C
C -- CREATE NEW STACK FRAME
C
      CALL XSCFRM ( ISTRUC )
      GO TO 4000
C
C
2300  CONTINUE
C -- 'LOOP'
C
C -- CHECK INPUT SYNTAX IS 'LOOP' OR 'LOOP NN TIMES'
C
      IF ( IREAD(1) .NE. IREAD(2) ) GO TO 9920
C
      IF ( IREAD(1) .GT. 0 ) THEN
C
C -- 'LOOP NN TIMES'
C
        IEND = IVALUE
        LSKIPL = ( IEND .LE. 0 )
      ELSE
C
C -- 'LOOP'
C
        IEND = 0
        LSKIPL = .FALSE.
      ENDIF
C
C -- CREATE NEW STACK LEVEL
C
      CALL XSCFRM ( ISTRUC )
C
C -- IF LOOP WILL BE EXECUTED ZERO TIMES, CLEAR EXECUTION FLAG.
C    OTHERWISE CREATE LOOP CONTROL VARIABLES IN CONTEXT OF NEW
C    BLOCK
C
      IF ( LEXECU ) THEN
        IF ( LSKIPL ) THEN
          CALL XSCSTU ( JEXECU , 0 )
        ELSE
          ISTAT = KSCIDN ( 1, 1, 'LOOPCOUNTER', 1, 1, IDC, 1, -1 )
          ISTAT = KSCIDN ( 1 , 1 , 'LOOPEND' , 1 , 1 , IDE , IEND , -1)
        ENDIF
      ENDIF
C
      GO TO 4000
C
C
2400  CONTINUE
C -- 'IF'
C
C -- CREATE NEW STACK FRAME
C
      CALL XSCFRM ( ISTRUC )
C
C -- IF LOGICAL EXPRESSION WAS FALSE, DISABLE EXECUTION. IF TRUE, THEN
C    SET FLAG TO SIGNAL TO ANY 'ELSE' INSTRCUTIONS THAT A PART OF THIS
C    'IF' BLOCK HAS BEEN EXECUTED.
C
      IF ( ( IVALUE .LE. 0 ) .AND. LEXECU ) THEN
        CALL XSCSTU ( JEXECU , 0 )
        CALL XSCSTU ( JWASEX , 0 )
      ELSE
        CALL XSCSTU ( JWASEX , 1 )
      ENDIF
      GO TO 4000
C
C
2500  CONTINUE
C -- 'CASE'
C
C -- CHECK WHETHER 'RANGE' OR 'AMONG' WAS SPECIFIED
C
      IF ( IREAD(2) .EQ. 1 ) THEN
C
C -- 'CASE II RANGE JJ KK'
C
C -- CHECK EXPRESSION 'II' WAS AN INTEGER EXPRESSION. THEN READ UP TO
C    TWO MORE INTEGER EXPRESSSIONS 'JJ' AND 'KK', AND SET REQUIRED
C    STATEMENT ON THE BASIS OF THE VALUES OF THESE THREE EXPRESSIONS.
C
        IF ( LEXECU .AND. ( IEXTYP .NE. JINTEG ) ) GO TO 9930
        ISTAT = KSCEXP ( ILOWER, ITYPE, CUPPER, CLOWER, IDIRPS, IEXPEV )
        IF ( ISTAT .LT. 0 ) THEN
          GO TO 9940
        ELSE IF ( ISTAT .EQ. 0 ) THEN
          ILOWER = 1
          IUPPER = 1000
        ELSE
          IF ( LEXECU .AND. ( ITYPE .NE. JINTEG ) ) GO TO 9930
          ISTAT = KSCEXP ( IUPPER, ITYPE, CUPPER, CLOWER, IDIRPS,
     2                                                          IEXPEV )
          IF ( ISTAT .LT. 0 ) THEN
            GO TO 9940
          ELSE IF ( ISTAT .EQ. 0 ) THEN
            IUPPER = ILOWER + 1000
          ELSE
            IF ( LEXECU .AND. ( ITYPE .NE. JINTEG ) ) GO TO 9930
          ENDIF
        ENDIF
C
        IPOS = IVALUE - ILOWER + 1
        IMAX = IUPPER - ILOWER + 1
        IPOS = MIN0 ( IMAX , IPOS )
      ELSE IF ( IREAD(2) .EQ. 2 ) THEN
C
C -- 'CASE EXP AMONG EXP1 EXP2 ... EXPN'
C
C -- START READING EXPRESSIONS. CHECK THEY ARE EACH OF THE SAME TYPE AS
C    'EXP'. WHEN ONE IS FOUND THAT IS EQUAL TO 'EXP' THEN WE HAVE THE
C    NUMBER OF THE REQUIRED STATEMENT
C
        IPOS = 0
2510    CONTINUE
          IPOS = IPOS + 1
          ISTAT = KSCEXP ( ITEST, ITYPE, CUPPER, CLOWER, IDIRPS, IEXPEV)
          IF ( ISTAT .LT. 0 ) THEN
            GO TO 9940
          ELSE IF ( LEXECU .AND. ( ISTAT .GT. 0 ) ) THEN
            ISTAT = KSCREL ( IVALUE , IEXTYP , ITEST , ITYPE ,
     2                       LEQUAL , LLESS )
            IF ( ISTAT .LE. 0 ) GO TO 9930
            IF ( .NOT. LEQUAL ) GO TO 2510
         ENDIF
      ELSE
C
C -- 'CASE II'
C
C -- CHECK EXPRESSION WAS AN INTEGER EXPRESSION. ITS VALUES GIVES THE
C    REQUIRED STATEMENT DIRECTLY.
C
        IF ( LEXECU .AND. ( IEXTYP .NE. JINTEG ) ) GO TO 9930
        IPOS = IVALUE
      ENDIF
C
C -- CREATE NEW STACK FRAME
C
C -- DISABLE EXECUTION INITIALLY. SET REQUIRED STATEMENT NUMBER.
C
      CALL XSCFRM ( ISTRUC )
      CALL XSCSTU ( JEXECU , 0 )
      IF ( LEXECU ) CALL XSCSTU ( JREQST , IPOS )
C
      GO TO 4000
C
C
4000  CONTINUE
C
C -- GENERAL BEGINNING OF STRUCTURE PROCESSING
C
C -- STORE AWAY ADDRESS OF END OF THIS STRUCTURE IF KNOWN
      CALL XSCSTU ( JBLEND , IBLEND )
C
      GO TO 9000
C
C
C
C
C                        *** END STRUCTURE ***
C
C
C
C
C
5100  CONTINUE
C -- 'END SCRIPT'
C
C -- DISABLE STACK OPERATIONS
      ISCDSB = 1
C
      CALL XSCRST
      CALL XFLUNW ( 2 , 3 )
      GO TO 7000
C
C
5200  CONTINUE
C -- 'END BLOCK'
      CALL XSCRST
      GO TO 7000
C
C
5300  CONTINUE
C -- 'END LOOP'
C
C -- CHECK LOOP CONTROL VARAIBLES, AND EITHER REPEAT LOOP OR TERMINATE
C    AS APPROPRIATE
C
      IF ( KSCSTK ( JEXECU , 0 ) .GT. 0 ) THEN
        ISTAT = KSCIDN ( 2, 1, 'LOOPCOUNTER' , 1 , IS , IDC, ICOUNT, 1)
        ISTAT = KSCIDN ( 2 , 1 , 'LOOPEND' , 1 , IS , IDE, IEND , 1)
        LTERMI = ( ICOUNT .EQ. IEND )
      ELSE
        LTERMI = .TRUE.
      ENDIF
C
C -- CHECK END CONDITION, AND EITHER END LOOP, OR INCREMENT COUNTER,
C    AND REWIND TO START AGAIN
C
      IF ( LTERMI ) THEN
      CALL XSCRST
      ELSE
        IF ( KSCSTK ( JBLEND , 0 ) .LE. 0 ) THEN
          CALL XSCSTU ( JBLEND , IRDREC(IFLIND) )
        ENDIF
        ICOUNT = ICOUNT + 1
        ISTAT = KSCIDN ( 1, 1, 'LOOPCOUNTER', 1, 1, IDC, ICOUNT, 0 )
        IRDFND(IFLIND) = KSCSTK ( JBSTRT , 0 ) + 1
      ENDIF
      GO TO 7000
C
C
5400  CONTINUE
C -- 'END IF'
      CALL XSCRST
      GO TO 7000
C
C
5500  CONTINUE
C -- 'END CASE'
      CALL XSCRST
      GO TO 7000
C
C
7000  CONTINUE
C
C -- GENERAL END OF STRUCTURE PROCESSING
C
C -- IF CURRENT STRUCTURE IS A 'LOOP', REMEMBER WHERE THE END OF THE
C    INNER STRUCTURE WAS.
C
      IF ( IOLDTP .GT. 1 ) THEN
        IF ( KSCSTK ( JBTYPE , 0 ) .EQ. 3 ) THEN
          CALL XSCSNM ( IOLDTP , IOLDST , CSTNAM )
C
          ICURR = IRDREC(IFLIND)
          ISTAT = KSCIDN ( 1, 1, CSTNAM, 5, 1, IDENT, ICURR, 0 )
        ENDIF
      ENDIF
C
      GO TO 9000
C
C
9000  CONTINUE
C
C
      KSCSCT = 1
C
C
      RETURN
C
C
9900  CONTINUE
      KSCSCT = -1
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MILLEG , MSTRUC , 'Internal error' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MILLMS , MPARAM , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MWRONG , MEXPRE , ' ' , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MILLEG , MEXPRE , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCSDC
      FUNCTION KSCSDC ( IDESC , CTEXT , LENGTH )
C
C -- CONVERT TEXT FROM DESCRIPTOR TO FORTRAN CHARACTER FORM
C
      CHARACTER*(*) CTEXT
C
      INCLUDE 'XSCDSC.INC'
C
      IF ( IDESC .LE. 0 ) THEN
        CTEXT = ' '
        LENGTH = 0
      ELSE
        CTEXT = CDESC(IDESCR(1,IDESC))
        LENGTH = IDESCR(2,IDESC)
      ENDIF
C
      KSCSDC = 1
      RETURN
C
      END
CODE FOR KSCSDD
      FUNCTION KSCSDD ( IFUNC , IDESC1 , IDESC2 )
C
C -- COPY TEXT FROM DESCRIPTOR TO DESCRIPTOR
C
C
C      INPUT PARAMETERS :-
C
C            IFUNC       FUNCTION CONTROL
C                        1     ALWAYS ALLOCATE A NEW DESCRIPTOR AS
C                              OUTPUT, UNLESS COPYING EMPTY STRING
C                        2     ONLY USE A NEW DESCRIPTOR IF STRING
C                              CANNOT BE COPIED TO EXISTING ONE
C
C            IDESC1      INPUT DESCRIPTOR
C
C      OUTPUT PARAMETER :-
C            IDESC2      OUTPUT DESCRIPTOR. THIS WILL ALSO BE READ IF
C                        IFUNC = 2
C
C      RETURN VALUE :-
C            -1          ERROR ALLOCATING COPYING TEXT
C            +1          SUCCESS
C
      LOGICAL LEMPTY , LALLOC , LOUTDS
C
      INCLUDE 'XSCDSC.INC'
C
C -- CHECK IF INPUT STRING IS EMPTY
C
      IF ( IDESC1 .GT. 0 ) THEN
        LENGTH = IDESCR(2,IDESC1)
        LEMPTY = ( LENGTH .LE. 0 )
      ELSE
        LENGTH = 0
        LEMPTY = .TRUE.
      ENDIF
C
C -- CHECK IF NEW DESCRIPTOR WILL BE REQUIRED
C
      IF ( IFUNC .EQ. 1 ) THEN
        LALLOC = .NOT. LEMPTY
        LOUTDS = LALLOC
      ELSE IF ( IFUNC .EQ. 2 ) THEN
        IF ( IDESC2 .LE. 0 ) THEN
          LALLOC = .NOT. LEMPTY
          LOUTDS = LALLOC
        ELSE
          LALLOC = .FALSE.
          LOUTDS = .TRUE.
        ENDIF
      ENDIF
C
      IF ( LALLOC ) THEN
        ISTAT = KSCSAD ( LENGTH , IDESC2 )
        IF ( ISTAT .LE. 0 ) GO TO 9900
      ENDIF
C
      IF ( LOUTDS ) THEN
        IDESCR(2,IDESC2) = LENGTH
        IF ( .NOT. LEMPTY ) THEN
          CDESC(IDESCR(1,IDESC2)) = CDESC(IDESCR(1,IDESC1))
        ENDIF
      ELSE
        IDESC2 = 0
      ENDIF
C
      KSCSDD = 1
      RETURN
C
9900  CONTINUE
      KSCSDD = -1
      RETURN
      END
CODE FOR KSCSET
      FUNCTION KSCSET ( IN )
C
C
C -- THIS ROUTINE IMPLEMENTS THE 'SET' INSTRUCTION IN SCRIPTS
C
C
C      INPUT PARAMETER :-
C            IN          DUMMY
C
C -- RETURN VALUES ( OF KSCSET ) :-
C
C      ( ANY )           VALUE TO BE USED AS RETURN VALUE OF KSCPRC
C
C
C      LOCAL VARIABLES :-
C
C            CVALUE      CHARACTER ARRAY DEFINING NAMES OF TYPES OF
C                        OPERATION PERFORMED.
C            IRQTYP      INTEGER ARRAY DEFINING TYPE OF VALUE REQUIRED
C                        FOR EACH TYPE OF SET OPERATION
C
C                              JINTEG      INTEGER EXPRESSION
C                              JREAL       REAL EXPRESSION
C                              JLOGIC      LOGICAL EXPRESSION
C
C -- THIS ROUTINE IS USED TO SET NEW VALUES OF CERTAIN GLOBAL VARIABLES
C    IN THE COMMON BLOCK 'XSCGBL'. THE FUNCTIONS OF THESE VARIABLES ARE
C    DESCRIBED IN THE ROUTINE 'KSCPRC'.
C
C
C
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCGBL.INC'
C
      PARAMETER ( JINTEG = 1 , JREAL = 2 , JLOGIC = 3 )
C
      PARAMETER ( LVAL = 8 , NVAL = 6 )
      CHARACTER*(LVAL) CVALUE(NVAL)
C
      DIMENSION IRQTYP(NVAL)
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
C
      DATA CVALUE / 'MESSAGE' , 'VERIFY' , 'FAST' , 'EVALUATE' ,
     2 'STACK' , 'IDENT' /
C
      DATA IRQTYP / JLOGIC ,    JLOGIC ,    JLOGIC , JLOGIC ,
     2 JLOGIC , JLOGIC /
C
C
C -- FIND OUT WHAT TYPE OF VALUE IS REQUIRED
C
      LENTYP = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENTYP .LE. 0 ) GO TO 9910
C
      IVALTP = KCCOMP ( CUPPER(NTYPE:NEND) , CVALUE , NVAL , 2 )
      IF ( IVALTP .LE. 0 ) GO TO 9910
C
C -- READ VALUE
C
      ISTAT = KSCEXP ( IVALUE , ITYPE , CUPPER , CLOWER , IDIRPS , 1 )
      IF ( ISTAT .LT. 0 ) GO TO 9900
      IF ( ISTAT .EQ. 0 ) GO TO 9920
C
      IF ( ITYPE .NE. IRQTYP(IVALTP) ) GO TO 9930
C
      IF ( IVALTP .EQ. 1 ) THEN
        ISCMSG = IVALUE
      ELSE IF ( IVALTP .EQ. 2 ) THEN
        ISCVER = IVALUE
      ELSE IF ( IVALTP .EQ. 3 ) THEN
        ISCFST = IVALUE
      ELSE IF ( IVALTP .EQ. 4 ) THEN
        ISCEVE = IVALUE
      ELSE IF ( IVALTP .EQ. 5 ) THEN
        ISCSVE = IVALUE
      ELSE IF ( IVALTP .EQ. 6 ) THEN
        ISCIVE = IVALUE
      ENDIF
C
C
9000  CONTINUE
      KSCSET = 0
      RETURN
C
C
9900  CONTINUE
      GO TO 9000
C
9910  CONTINUE
      CALL XSCMSG ( MILLMS , MKEYWD , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MILLMS , MEXPRE , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MWRONG , MEXPRE , ' ' , 0 )
      GO TO 9900
C
      END
CODE FOR KSCSHW
      FUNCTION KSCSHW ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE SCRIPT 'SHOW' INSTRUCTION
C
C -- DISPLAY VALUE OF VARIABLE
C
C      INPUT PARAMETER :-
C            IN          DUMMY
C
C      RETURN VALUE :-
C            <ANY>       VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C
C      LOCAL VARIABLES :-
C            CLOG        TEXT REPRESENTATIONS OF THE TWO POSSIBLE
C                        LOGICAL VALUES ( TRUE AND FALSE )
C
cdjwjul09
c            cfmat       format expression for internal writes of 
c                        floating numbers
      character*32  cfmat
C
      INCLUDE 'PSCRPT.INC'
C
      CHARACTER*(MAXLAB) CVARIB
C
      PARAMETER ( LVALUE = 64 )
      CHARACTER*(LVALUE) CVALUE
      CHARACTER*5 CLOG(0:1)
C
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XIOBUF.INC'
C
      EQUIVALENCE ( IVALUE , XVALUE )
C
      DATA CLOG / 'false' , 'true' /
C
C
C
C
      IVAR = 0
C
1000  CONTINUE
C
C -- GET VARIABLE NAME
C
      LENVAR = KCCARG ( CUPPER , IDIRPS , 1 , NVAR , NEND )
      IF ( LENVAR .LE. 0 ) GO TO 9000
C
      CVARIB = CUPPER(NVAR:NEND)
C
      IVAR = IVAR + 1
C
      ISTAT = KSCIDN ( 2,3, CVARIB , 1, ITYPE, IID, IVALUE,1 )
      IF ( ISTAT .LE. 0 ) GO TO 9900
C
C -- CONVERT VARIABLE VALUE TO TEXT REPRESENTATION
C
        IF ( ITYPE .EQ. 1 ) THEN
          WRITE ( CVALUE , '(I12)' ) IVALUE
        LENVAL = 12
        ELSE IF ( ITYPE .EQ. 2 ) THEN
Cdjwjul09
c          WRITE ( CVALUE , '(F12.5)' ) XVALUE
          call dform(xvalue, cfmat)
          WRITE ( CVALUE , cfmat ) XVALUE
        LENVAL = 12
        ELSE IF ( ITYPE .EQ. 3 ) THEN
          CVALUE = CLOG(IVALUE)
        LENVAL = 5
      ELSE IF ( ITYPE .EQ. 4 ) THEN
        CVALUE(1:1) = '"'
        ISTAT = KSCSDC ( IVALUE , CVALUE(2:) , LENTXT )
        IF ( LENTXT .LE. LVALUE - 1 ) THEN
          CVALUE(LENTXT+2:) = '"'
        ENDIF
        LENVAL = MIN0 ( LVALUE , LENTXT + 2 )
        ENDIF
C
C -- DISPLAY VARIABLE NAME AND VALUE
C
       WRITE ( CMON, 2105 ) CVARIB(1:LENVAR) , CVALUE(1:LENVAL)
       CALL XPRVDU(NCVDU, 1,0)
2105    FORMAT ( 1X , A , ' = ' , A )
C
C
      GO TO 1000
C
C
9000  CONTINUE
      IF ( IVAR .LE. 0 ) GO TO 9910
      KSCSHW = 0
      RETURN
C
C
C
9900  CONTINUE
      KSCSHW = 0
      RETURN
9910  CONTINUE
      CALL XSCMSG ( MMISSG , MVARIA , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCSRE
      FUNCTION KSCSRE ( IDESC1 , IDESC2 , LEQUAL , LLESST )
C
C -- COMPARE DESCRIPTOR WITH DESCRIPTOR
C
C -- THIS ROUTINE CALCULATIONS RELATIONAL FUNCTIONS BETWEEN TWO
C    STRINGS REPRESENTED BY SCRIPT CHARACTER STRING DESCRIPTORS
C
C      INPUT PARAMETERS :-
C            IDESC1,IDESC2     ADDRESSES OF DESCRIPTORS FOR CHARACTER
C                              STRINGS TO BE COMPARED
C
C      OUTPUT PARAMETERS :-
C            LEQUAL      LOGICAL VARIABLE. SET TRUE IF STRING1 = STRING2
C            LLESST      LOGICAL VARIABLE. SET TRUE IF STRING1 LESS THAN
C                        STRING2
C
C      RETURN VALUE :-
C            +1          SUCCESS
C
C
C      STRING1 IS EQUAL TO STRING2 IF
C            1)          BOTH ARE EMPTY
C                                  OR
C            2)          BOTH ARE NON-EMPTY, THE SAME LENGTH, AND
C                        CONTAIN THE SAME CHARACTERS
C
C      STRING1 LESS THAN STRING2 IF
C            1)          STRING1 EMPTY AND STRING2 NON-EMPTY
C                                OR
C            2)          BOTH ARE NON-EMPTY, AND 'LLT' MAKES STRING1
C                        LESS THAN STRING2
C
C
      LOGICAL LEQUAL , LLESST
C
      INCLUDE 'XSCDSC.INC'
C
C
      IF ( IDESC1 .LE. 0 ) THEN
        LEN1 = 0
      ELSE
        LEN1 = IDESCR(2,IDESC1)
      ENDIF
C
      IF ( IDESC2 .LE. 0 ) THEN
        LEN2 = 0
      ELSE
        LEN2 = IDESCR(2,IDESC2)
      ENDIF
C
C
      IF ( LEN1 .EQ. 0 ) THEN
        IF ( LEN2 .EQ. 0 ) THEN
          LEQUAL = .TRUE.
          LLESST = .FALSE.
        ELSE
          LEQUAL = .FALSE.
          LLESST = .TRUE.
        ENDIF
      ELSE IF ( LEN2 .EQ. 0 ) THEN
        LEQUAL = .FALSE.
        LLESST = .FALSE.
      ELSE
        LEQUAL= ( CDESC(IDESCR(1,IDESC1)) .EQ. CDESC(IDESCR(1,IDESC2)) )
        LLESST= LLT ( CDESC(IDESCR(1,IDESC1)), CDESC(IDESCR(1,IDESC2)) )
      ENDIF
C
      KSCSRE = 1
C
      RETURN
      END
CODE FOR KSCSTK
      FUNCTION KSCSTK ( ITEM , IRELLV )
C
C -- RETURN INFORMATION FROM STACK
C
C -- THIS ROUTINE USED TO GET INFORMATION FROM THE STACK. NO ROUTINE
C    SHOULD ATTEMPT DIRECT ACCESS TO THE STACK, AS THIS MAKES FUTURE
C    CHANGES TO THE ORGANISATION OF THE STACK MORE DIFFICULT.
C
C      INPUT PARAMETERS :-
C
C            ITEM        CODE DESCRIBING ITEM REQUIRED. THESE CODES ARE
C                        ALL DEFINED IN PARAMETER STATEMENTS
C            IRELLV      RELATIVE LEVEL OF STACK FOR WHICH INFORMATION
C                        IS REQUIRED. A VALUE OF 0 REPRESENTS THE
C                        CURRENT FRAME. THIS WILL USUALLY BE THE ONE
C                        WANTED. 1 MEANS THE OUTER FRAME, 2 THE NEXT
C                        OUTER, AND SO ON.
C
C      RETURN VALUES :-
C            -VE         ERROR GETTING REQUESTED ITEM (INVALID REQUEST)
C            0,+VE       THE REQUESTED VALUE
C
C
C
      INCLUDE 'PSCSTI.INC'
      INCLUDE 'PSCSTK.INC'
      INCLUDE 'PSCMSG.INC'
C
C
      INCLUDE 'UFILE.INC'
C
      INCLUDE 'XSCSTK.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
C -- CHECK REQUEST IS LEGAL
C
      IF ( ITEM .LE. 0 ) GO TO 9910
      IF ( ITEM .GT. LSTACK ) GO TO 9910
C
C -- CHECK LEVEL REQUIRED IS LEGAL
C
      LEVEL = ILEVEL(IFLIND)
      IF ( LEVEL .LE. 0 ) GO TO 9920
C
      IF ( IRELLV .LT. 0 ) GO TO 9920
      IREQLV = LEVEL - IRELLV
      IF ( IREQLV .LE. 0 ) GO TO 9920
C
C -- GET THE ITEM REQUIRED
C
      KSCSTK = ISTACK(ITEM,IREQLV)
      RETURN
C
C
9900  CONTINUE
      KSCSTK = -1
      RETURN
9910  CONTINUE
      CALL XSCMSG ( MILLEG , MSTKIT , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MILLEG , MSTKLV , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR KSCSTR
      FUNCTION KSCSTR ( IN )
C
C -- THIS ROUTINE IMPLEMENTS THE 'STORE' INSTRUCTION IN SCRIPTS
C
C      INPUT PARAMETER :-
C            IN          DUMMY
C
C
C -- RETURN VALUES ( OF KSCSTR ) :-
C
C      ( ANY )           VALUE TO BE USED AS RETURN VALUE OF KSCPRC
C
C
C
C      LOCAL VARIABLES :-
C
C            CVALUE      CHARACTER ARRAY DEFINING TYPES OF DATA THAT CAN
C                        BE OUTPUT, AND DEFINING KEYWORDS USED TO
C                        INTRODUCE USER FORMAT AND LENGTH SPECIFICATIONS
C            IRQTYP      EXPRESSION TYPE REQUIRED FOR EACH ITEM IN
C                        CVALUE.
C                              JINTEG      INTEGER EXPRESSION
C                              JREAL       REAL EXPRESSION
C                              JLOGIC      LOGICAL EXPRESSION
C                              JCHAR       CHARACTER EXPRESSION
C            LENGTH      LENGTH OF DATA TO BE OUTPUT. THIS IS INITIALLY
C                        SET TO 12
C
C            CFORM       CHARACTER VARIABLE HOLDING A USER SUPPLIED
C                        FORMAT EXPRESSION
C            LENFRM      LENGTH OF USER SUPPLIED FORMAT EXPRESSION
C            LSPCFM      LOGICAL VALUE. TRUE IF A USER FORMAT EXPRESSION
C                        HAS BEEN SUPPLIED
C
C
C            CLOGIC      CHARACTER REPRESENTATIONS OF LOGICAL VALUES
C
C
cdjwjul09
c            cfmat       format expression for internal writes of 
c                        floating numbers
      character*32  cfmat
c
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCCHK.INC'
C
      PARAMETER ( JINTEG = 1 , JREAL = 2 , JLOGIC = 3 , JCHAR = 4)
C
      CHARACTER*(MAXLAB) CVARIB
      CHARACTER*80 CFORM, CTXT
      LOGICAL LSPCFM
C
      CHARACTER*6 CLOGIC(0:1)
C
      PARAMETER ( NVAL = 7 , LVAL = 9 )
      CHARACTER*(LVAL) CVALUE(NVAL)
      DIMENSION IRQTYP(NVAL)
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      EQUIVALENCE ( IVALUE , VALUE )
C
      DATA CVALUE / 'INTEGER' , 'REAL' , 'KEYWORD' , 'FORMAT' ,
     2              'LOGICAL' , 'LENGTH' , 'CHARACTER' /
C
      DATA IRQTYP / JINTEG , JREAL , JINTEG , 0 , JLOGIC , 0 , JCHAR/
C
      DATA ITPINT / 1 / , ITPREA / 2 /
      DATA ITPKEY / 3 / , ITPFRM / 4 /
      DATA ITPLOG / 5 / , ITPLEN / 6 /
      DATA ITPCHR / 7 /
C
      DATA CLOGIC / ' FALSE' , ' TRUE ' /
C
C
      LSPCFM = .FALSE.
      LENGTH = 12
C
C -- FIND OUT WHAT TYPE OF VALUE IS REQUIRED
C
1100  CONTINUE
C
C
C -- READ A KEYWORD, AND CHECK ITS VALUE
C
      LENTYP = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENTYP .LE. 0 ) GO TO 9910
C
      IVALTP = KCCOMP ( CUPPER(NTYPE:NEND) , CVALUE , NVAL , 2 )
      IF ( IVALTP .LE. 0 ) GO TO 9910
C
      IF ( IVALTP .EQ. ITPFRM ) THEN
C
C -- 'FORMAT'. THIS IS FOLLOWED BY
C            1)  A FORMAT EXPRESSION
C            2)  ANOTHER KEYWORD
C
        LENFRM = KCCARG ( CUPPER , IDIRPS , 2 , NFORM , NEND )
        CFORM = CUPPER(NFORM:NEND)
        LSPCFM = .TRUE.
        GO TO 1100
      ELSE IF ( IVALTP .EQ. ITPLEN ) THEN
C -- 'LENGTH'. THIS IS FOLLOWED BY
C            1)  A LENGTH ( INTEGER EXPRESSION )
C            2)  ANOTHER KEYWORD
C
        ISTAT = KSCEXP ( LENGTH, ITYPE, CUPPER, CLOWER, IDIRPS, 1 )
        IF ( ISTAT .LT. 0 ) GO TO 9900
        IF ( ISTAT .EQ. 0 ) GO TO 9940
        IF ( ITYPE .NE. JINTEG ) GO TO 9940
        GO TO 1100
      ENDIF
C
C -- ANOTHER KEYWORD HAS BEEN READ. THIS MEANS THAT ACTION IS ABOUT
C    TO BEGIN. 'INTEGER' , 'REAL' ETC. ARE FOLLOWED BY EXPRESSIONS.
C
      IVAR = 0
      IREQ = IRQTYP(IVALTP)
C
2000  CONTINUE
C
      ISTAT = KSCEXP ( IVALUE , ITYPE , CUPPER , CLOWER , IDIRPS , 1 )
      IF ( ISTAT .LT. 0 ) GO TO 9900
      IF ( ISTAT .EQ. 0 ) GO TO 9000
C
C -- CHECK TYPE OF EXPRESSION
      IF ( IREQ .NE. ITYPE ) GO TO 9930
C
C -- CONVERT EXPRESSION TO TEXT, USING EITHER DEFAULT FORMAT OR THE USER
C    SUPPLIED EXPRESSION. APPEND THE TEXT GENERATED TO THE COMMAND
C    BUFFER. ( NOTE 'LOGICAL' AND 'KEYWORD' ARE NOT CONVERTED VIA
C    'INTERNAL WRITES', SINCE THE INFORMATION IS ALREADY IN CHARACTER
C    FORM )
C
      IF ( IVALTP .EQ. ITPINT ) THEN
        IF ( LSPCFM ) THEN
          WRITE ( CCOMBF(ICOMLN+1:) , CFORM ) IVALUE
        ELSE
          WRITE ( CCOMBF(ICOMLN+1:) , '(I12)' ) IVALUE
        ENDIF
      ELSE IF ( IVALTP .EQ. ITPREA ) THEN
        IF ( LSPCFM ) THEN
          WRITE ( CCOMBF(ICOMLN+1:) , CFORM ) VALUE
        ELSE
cdjwjul09
c          WRITE ( CCOMBF(ICOMLN+1:) , '(F12.6)' ) VALUE
          call dform(value,cfmat)
          WRITE ( CCOMBF(ICOMLN+1:) , cfmat ) VALUE
        ENDIF
      ELSE IF ( IVALTP .EQ. ITPKEY ) THEN
        CCOMBF(ICOMLN+1:) = CCHECK(IVALUE)
        LENGTH = INDEX(CCHECK(IVALUE)//' ' , ' ' ) - 1
      ELSE IF ( IVALTP .EQ. ITPLOG ) THEN
        CCOMBF(ICOMLN+1:) = CLOGIC(IVALUE)
        LENGTH = 6
      ELSE IF (IVALTP .EQ. ITPCHR ) THEN
C----- CHARACTER EXPRESSION EXPECTED
        IF ( ITYPE .NE. JCHAR ) GO TO 9940
        CTXT = ' '
        ISTAT = KSCSDC ( IVALUE , CTXT , LENTXT )
        IF ( LENTXT .GT. 0 ) THEN
          CCOMBF(ICOMLN+1:ICOMLN+1+LENTXT) = CTXT(1:LENTXT)
          LENGTH =  LENTXT
        ENDIF
      ENDIF
C
C
      ICOMLN = ICOMLN + LENGTH
C
C -- READ ANOTHER EXPRESSION
C
      IVAR = IVAR + 1
      GO TO 2000
C
9000  CONTINUE
C
C -- CHECK THAT AT LEAST ONE EXPRESSION WAS GIVEN.
C
      IF ( IVAR .LE. 0 ) GO TO 9920
      KSCSTR = 0
      RETURN
C
C
C
C
9900  CONTINUE
      KSCSTR = 0
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MILLMS , MKEYWD , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MMISSG , MEXPRE , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MWRONG , MEXPRE , ' ' , 0 )
      GO TO 9900
9940  CONTINUE
      CALL  XSCMSG ( MILLMS , MLENGT , ' ' , 0 )
      GO TO 9900
C
      END
CODE FOR KSCTRA
      FUNCTION KSCTRA ( CTEXT , IUSLEN )
C
C -- PERFORM 'TRANSFER' INSTRUCTION
C
C      INPUT PARAMETERS :-
C            <NONE>
C
C      OUTPUT PARAMETERS :-
C            CTEXT       TEXT TO BE RETURNED TO 'CRYSTALS'
C            IUSLEN      USABLE LENGTH OF 'CTEXT'
C
C      RETURN VALUE :-
C            <ANY>       VALUE TO BE ASSIGNED TO 'KSCPRC'
C
C
C
C      LOCAL VARIABLES :-
C            LTO         LENGTH OF LINK KEYWORDS
C            NTO         NUMBER OF LINKING KEYWORDS
C            CTO         CHARACTER ARRAY HOLDING LINKING KEYWORDS
C                        ( THE ONLY LINKING KEYWORD IS 'TO' )
C            LDEST       LENGTH OF DESTINATION KEYWORDS
C            NDEST       NUMBER OF DESTINATION KEYWORDS
C            CDEST       CHARACTER ARRAY HOLDING DESTINATION KEYWORDS
C                              DISPLAY     DISPLAY DATA ON TERMINAL
C                              CRYSTALS    DATA IS A CRYSTALS COMMAND
C                              SCRIPT      DATA IS A SCRIPT COMMAND
C            CWORK       WORK AREA IN WHICH TEXT TO BE DISPLAYED IS
C                        STORED
C
C
C
      CHARACTER*(*) CTEXT
C
C
C
      PARAMETER ( LTO = 2 , NTO = 1 )
      CHARACTER*(LTO) CTO(NTO)
C
CJAN99
      PARAMETER ( LDEST = 12 , NDEST = 6 )
      CHARACTER*(LDEST) CDEST(NDEST)
C
      PARAMETER ( LENDSP = 256 )
      CHARACTER*(LENDSP) CWORK
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XIOBUF.INC'
C
      DATA CTO / 'TO' /
CJAN99
      DATA CDEST / 'DISPLAY','CRYSTALS','SCRIPT','BUFFER','INPUT',
     1             'PUNCH' /
C
C
C
      ISTAT = KSCEXP ( IVALUE , ITYPE , CUPPER , CLOWER , IDIRPS , 1 )
      IF ( ISTAT .LT. 0 ) GO TO 9900
      IF ( ISTAT .EQ. 0 ) GO TO 9910
C
C
      IF ( ITYPE .NE. 4 ) GO TO 9920
C
      LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
      IF ( LENARG .LE. 0 ) GO TO 9930
C
      ICOMP = KCCOMP ( CUPPER(NARG:NEND) , CTO , NTO , 1 )
      IF ( ICOMP .LE. 0 ) GO TO 9940
C
      LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NARG , NEND )
      IF ( LENARG .LE. 0 ) GO TO 9930
C
      IDEST = KCCOMP ( CUPPER(NARG:NEND) , CDEST , NDEST , 1 )
      IF ( IDEST .LE. 0 ) GO TO 9940
C
      KSCTRA = 0
C
      IF ( IDEST .EQ. 1 ) THEN
C
C -- 'DISPLAY'
C
        ISTAT = KSCSDC ( IVALUE , CWORK , LENWRK )
        IF ( LENWRK .GT. 0 ) THEN
          WRITE ( CMON, 1105 ) CWORK(1:LENWRK)
          CALL XPRVDU(NCVDU, 1,0)
1105      FORMAT ( A )
        ELSE
          WRITE ( CMON, 1115 )
          CALL XPRVDU(NCVDU, 1,0)
1115      FORMAT ( 1X )
        ENDIF
      ELSE IF ( IDEST .EQ. 2 ) THEN
C
C -- 'CRYSTALS'
C
        ISTAT = KSCSDC ( IVALUE , CTEXT , IUSLEN )
        IF ( IUSLEN .GT. 0 ) KSCTRA = 2
      ELSE IF ( IDEST .EQ. 3 ) THEN
C
C -- 'SCRIPT'
C
        ISTAT = KSCSDC ( IVALUE , CTEXT , IUSLEN )
        IF ( IUSLEN .GT. 0 ) KSCTRA = 3
CJAN99
      ELSE IF ( IDEST .EQ. 4 ) THEN
C
C -- 'BUFFER'
C
C Purpose: To transfer text strings to the command buffer.
C This is a bit of a hack for the moment. Because I'm not sure how
C the script processor /really/ works.
C We process the text as for DISPLAY, then tack %INSERT ! on the beginni
C and ! on the end, then set KSCTRA to 3 so that the command is copied b
C to the script processor.
        ISTAT = KSCSDC ( IVALUE , CTEXT , IUSLEN )
          IF ( IUSLEN .GT. 0 ) THEN
            IUSLEN = MIN(256,IUSLEN + 12)
            KSCTRA = 3
C Shift the characters up by 10 places
            DO I = 256,11,-1
                CTEXT(I:I) = CTEXT(I-10:I-10)
            END DO
C Add the pretext
                CTEXT(1:10) = '%INSERT ! '
C Add the posttext
                CTEXT(IUSLEN-1:IUSLEN) = ' !'
          END IF
      ELSE IF ( IDEST .EQ. 5 ) THEN
C
C -- 'INPUT'
C
C Purpose: To transfer text strings to the user input buffer.
C Remarks: Any existing unprocessed user input is overwritten.
        ISTAT = KSCSDC ( IVALUE , CTEXT , IUSLEN )
        IF ( IUSLEN .GT. 0 ) THEN
            IUSLEN = MIN(256,IUSLEN)
            CLINPB = CTEXT(1:IUSLEN)
            CUINPB = CTEXT(1:IUSLEN)
            IINPPS = 1
            IINPLN = IUSLEN
        END IF
      ELSE IF ( IDEST .EQ. 6 ) THEN
C
C -- 'PUNCH' To write lines of text into the punch file.
C
        ISTAT = KSCSDC ( IVALUE , CWORK , LENWRK )
        WRITE ( NCPU, 1105 ) CWORK(1:LENWRK)
      ENDIF
C
C
      RETURN
C
C
9900  CONTINUE
      KSCTRA = 0
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MMISSG , MEXPRE , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MWRONG , MEXPRE , ' ' , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MMISSG , MKEYWD , ' ' , 0 )
      GO TO 9900
9940  CONTINUE
      CALL XSCMSG ( MILLEG , MKEYWD , CUPPER(NARG:NEND) , 0 )
      GO TO 9900
      END
CODE FOR KSCTRN
      FUNCTION KSCTRN ( IDIREC , CVARIB , IVALUE, ILGTH )
C
C -- MOVE VALUE TO OR FROM SCRIPT VARIABLE
C
C -- THIS ROUTINE PROVIDES AN INTERFACE BETWEEN THE MAIN CRYSTALS
C    PROGRAMS AND THE SCRIPT FACILITIES, BY ALLOWING DATA TO BE MOVED
C    QUITE SIMPLY BETWEEN THEM.
C
C      IDIREC      DIRECTION OF MOVEMENT
C                    1      MOVE DATA FROM 'IVALUE' TO VARIABLE
C                    2      MOVE DATA TO 'IVALUE' FROM VARIABLE
C      CVARIB      NAME OF VARIABLE. IF THIS IS ALL BLANK, NO ACTION
C                  IS TAKEN, AND THE ROUTINE IMMEDIATELY RETURNS.
C      IVALUE      VALUE
C      ILGTH       LENGTH IN WORDS TO TRANSFER, IF CHARACTER VARIABLE
C
C      RETURN VALUES OF KSCTRN
C
C      -1          ERROR. VARIABLE NAME IS NOT KNOWN
C      +1          SUCCESS
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XIOBUF.INC'

      DIMENSION IVALUE(ILGTH)

      CHARACTER*(*) CVARIB
      CHARACTER *64 CBUFF, CUPPER



      KSCTRN = 1
      IF ( CVARIB .EQ. ' ' ) RETURN    ! CHECK VARIABLE NAME HAS BEEN GIVEN
      IF ( IRDSCR(IFLIND) .LE. 0 ) RETURN  ! CHECK SCRIPTS ARE RUNNING


C -- FIND IDENTIFIER

      CALL XCCUPC (CVARIB, CUPPER)

      ISTAT = KSCIDN ( 2 , 3 , CUPPER , 1 , ITYPE , IDENT , ICVAL , -1 )
      IF ( ISTAT .LE. 0 ) THEN
c        WRITE(CMON,'(2A)')'Variable not found: ',CUPPER
c        CALL XPRVDU(NCVDU,1,0)
        GO TO 9900
      END IF

c      WRITE(CMON,'(A,I4,1X,A,2I5)')
c     1     'Val,C,IDIR,ITYP: ',IVALUE,CUPPER,IDIREC,ITYPE
c          CALL XPRVDU(NCVDU,1,0)


C -- TRANSFER DATA

      IF ( IDIREC .EQ. 1 ) THEN
        IF (ITYPE .EQ. 4) THEN  ! CHARACTER VARIABLE - CONVERT TO HOLLERITH
C          WRITE (CBUFF, '(A4)') IVALUE
         DO J = 1, ILGTH
          WRITE (CBUFF((J*4)-3:(J*4)), '(A4)') IVALUE(J)
         END DO
CDJW JUL 98 REPLACE CALL TO KSCSCD WITH CALL TO REPLACEMENT ROUTINE
         ISTAT = KSCREP (ICVAL, CBUFF(1:(ILGTH*4)), 4)
         JVALUE = ICVAL
         ISTAT = KSCIDN ( 1, 3, CUPPER, 1, ITYPE, IDENT, JVALUE , -1)
        ELSE
          ISTAT = KSCIDN ( 1, 3, CUPPER, 1, ITYPE, IDENT, IVALUE(1), -1)
c          WRITE(CMON,'(A,I4,1X,A)')
c     1     'Variable transferred: ',IVALUE,CUPPER
c          CALL XPRVDU(NCVDU,1,0)
        END IF
      ELSE
        IF (ITYPE .EQ. 4) THEN  ! CHARACTER VARIABLE - RECOVER FROM HOLLERITH
          ISTAT = KSCSDC (ICVAL, CBUFF, I )
          DO J=1,ILGTH
             READ (CBUFF((J*4)-3:(J*4)), '(A4)') IVALUE(J)
          END DO
        ELSE
             CALL XMOVEI ( ICVAL , IVALUE(1) , 1 )
        ENDIF
      ENDIF
      RETURN


9900  CONTINUE
      KSCTRN = -1
      RETURN
      END

CODE FOR KSCREP
      FUNCTION KSCREP ( IDESC, CTEXT, LENG )
C
C
C      COPY CHARACTER DATA INTO EXISTING DESCRIPTOR
C      ICVAL EXISTING DESCRIPTOR ID
C      TEXT TO BE COPIED
C      LENG LENGTH OF TEXT
      CHARACTER*(*) CTEXT
C
C
      INCLUDE 'XSCDSC.INC'
C
C
      IF (IDESC .LE. 0) THEN
            ISTAT = KSCSCD ( CTEXT(1:LENG), IDESC)
            IF ( ISTAT .LT. 0 ) GO TO 9900
      ENDIF
C
      CDESC(IDESCR(1,IDESC)) = CTEXT
      IDESCR(2,IDESC) = LENG
C
      KSCREP = 1
      RETURN
C
9900  CONTINUE
      KSCREP = -1
      RETURN
      END
C
CODE FOR KSCUMS
      FUNCTION KSCUMS ( IN )
C
C -- CHANGE USER MESSAGE
C
C -- THIS ROUTINE IMPLEMENTS THE SCRIPT 'MESSAGE' INSTRUCTION
C
C      INPUT PARAMETER :-
C            IN          DUMMY
C
C
C      RETURN VALUE OF KSCUMS IS THE VALUE TO BE USED FOR 'KSCPRC'
C
C
C      LOCAL VARIABLES :-
C
C            CTYPE       CHARACTER ARRAY DEFINING NAMES OF MESSAGES
C                        THAT CAN BE CHANGED USING THIS ROUTINE
C
C -- THE MESSAGES ARE STORED IN THE ARRAY 'CSCMSG' WITH LENGTHS IN
C    'LSCMSG'. THESE ARRAYS ARE DESCRIBED IN 'KSCPRC'
C
C
      PARAMETER ( LTYP = 12 , NTYP = 20 )
      CHARACTER*(LTYP) CTYPE(NTYP)
C
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCMSG.INC'
      INCLUDE 'XSCCHR.INC'
C
C
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
C
C
      DATA CTYPE / 'EXTRA' , 'DEFAULT' , 'REAL' , 'INTEGER' ,
     2 'VALUE' , 'ABANDONED' , 'USER1' , 'USER2' , 'USER3' , 'USER4' ,
     3 'PRINTEGER' , 'PRREAL' , 'PRTEXT' , 'PRKEYWORD' , 'PRVERIFIED' ,
     4 'PRFILENAME' , 'PRABBREV' , 'PRYESNO' , 'AMBIG' , 'INAPPROP' /
C
C
C
C
C -- READ/CHECK KEYWORD ( MESSAGE NAME )
C
      LENTYP = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENTYP .LE. 0 ) GO TO 9910
C
      ITYPE = KCCOMP ( CUPPER(NTYPE:NEND) , CTYPE , NTYP , 2 )
      IF ( ITYPE .LE. 0 ) GO TO 9910
C
C -- READ NEW MESSAGE TEXT
C
      LENMSG = KCCARG ( CUPPER , IDIRPS  , 2 , NMSG , NEND )
      IF ( LENMSG .LE. 0 ) GO TO 9920
C
C -- STORE NEW MESSAGE TEXT, AND ITS LENGTH
C
      LSCMSG(ITYPE) = LENMSG
      CSCMSG(ITYPE) = CLOWER(NMSG:NEND)
C
C
9900  CONTINUE
      KSCUMS = 0
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MILLMS , MKEYWD , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MILLMS , MMESSG , ' ' , 0 )
      GO TO 9900
      END
CODE FOR KSCVAL
      FUNCTION KSCVAL ( IN )
C
C -- READ USER INPUT FOR SCRIPT PROCESSING ROUTINE
C
C -- THIS ROUTINE IMPLEMENTS THE 'GET' INSTRUCTION IN SCRIPTS
C
C  'IN' IS A DUMMY ARGUMENT
C
C -- RETURN VALUES ( OF KSCVAL ) :-
C
C      ( ANY )           VALUE TO BE USED AS RETURN VALUE OF KSCPRC
C
C
C      LOCAL VARIABLES :-
C
C            CBUFFR      BUFFER FOR PROMPT STRING ( 80 CHARACTERS )
C            CVAL        BUFFER FOR ALLOWED VALUE LIST ( 160 CHARS )
C            CVAL        BUFFER FOR ALLOWED VALUE LIST ( 160 CHARS )
C            MLIN        MAXIMUM NUMBER OF LINES IN MENU
C            MLNLEN      THE MAXIMUM LINE LENGTH.
C            LINLEN      THIS GIVES THE BREAK POINT FOR THE ALLOWED
C                        VALUE LIST. IF THE LIST WOULD BE LONGER THAN
C                        LINLEN, IT IS BROKEN AT A POINT LE LINLEN.
C
C            LDEFBF      PARAMETER DEFINING MAXIMUM LENGTH OF DEFAULT
C                        VALUE
C            CDEFLT      BUFFER FOR DEFAULT VALUE ( IF ANY )
C
C            CVALTP      CHARACTER ARRAY DEFINING NAMES OF THE POSSIBLE
C                        TYPES OF VALUE ( 'INTEGER', 'KEYWORD', ETC )
C            IRESTP      INTEGER ARRAY DEFINING THE TYPE ( INTEGER/REAL/
C                        LOGICAL/NONE ) OF THE RESULTING VALUE STORED
C                        IN 'ISCVAL'. THE VALUE OF IRESTP() IS MOVED TO
C                        ISCVTP, AND ISCVTP IS USED BY 'KSCEST' FOR
C                        EXAMPLE.
C            CMODIF      CHARACTER ARRAY DEFINING 'MODIFIERS'. THESE
C                        SELECT VARIOUS MODIFICATIONS TO NORMAL ACTION
C                        OF THIS ROUTINE
C
C            IVALUE      VALUE FOUND ( MOVED TO ISCVAL AT THE END )
C            INTERR      ERROR FLAG. IF SET, 'USER ERROR' CAN BE
C                        HANDLED BY THIS ROUTINE ALONE. THIS IS TRUE
C                        IF THE 'USER ERROR' ( I.E. AN ERROR IN THE
C                        FINAL USER'S INPUT ) WAS FOUND IN TEXT WHICH
C                        WAS ENTERED IN THIS CALL OF KSCVAL, RATHER THAN
C                        IN TEXT WHICH WAS ALREADY IN THE INPUT BUFFER
C            ICHECK      IF SET, VALUE READ WILL BE CHECKED AGAINST
C                        ALLOWED VALUE LIST
C
C      ( MODIFIERS, WHICH ARE SET IF 1, CLEAR IF 0 )
C            IFINAL      IF SET, INPUT ITEM MUST BE LAST ON THE INPUT
C                        LINE
C            IAPPND      IF SET, INPUT TEXT IS APPENDED TO COMMAND
C                        BUFFER WITH NO INTERVENING SPACE
C            IFILL       IF SET, FULL FORM OF ABBREVIATED KEYWORDS IS
C                        STORED IN THE COMMAND BUFFER
C            INOSTR      IF SET, INPUT TEXT IS NOT STORED IN COMMAND
C                        BUFFER
C            INOPMT      IF SET, USER IS NOT PROMPTED FOR MORE INPUT
C                        IF THE INPUT BUFFER IS EMPTY
C            INOREM      IF SET, INPUT TEXT IS NOT REMOVED FROM INPUT
C                        BUFFER
C            INOMSG      IF SET, NO MESSAGE IS PRODUCED FOR A 'USER
C                        ERROR'
C            ISILNT      IF SET, NO SCREEN OUTPUT IS PRODUCED AT ALL.
C
C            IFAILS      INDICATES A USER INPUT ERROR OCCURED. IF SET,
C                        OVERRIDE THE SILENT FLAG SO THAT THE USER OR
C                        PROGRAMMER FIGURE OUT THE PROBLEM
C
C
C
C -- CHARACTER BUFFERS FOR GENERATING PROMPT STRINGS
      INCLUDE 'XCLWIN.INC'
C
      CHARACTER *256 CBUFFR
C----- TO HOLD REAL FORMAT EXPRESSION
      CHARACTER *8 CFMTXP
C
C
      PARAMETER (MLNLEN = 78, MLIN = 3)
C----- MENU LINE OVERFLOW COUNTER
      DIMENSION IPMBRK(MLIN)
      CHARACTER *(MLNLEN) CTOP, CBTM, CBOX, CMENU
C
      CHARACTER *240 CVAL
C
C
      PARAMETER ( NVAL = 8 , LVAL = 12 )
      CHARACTER*(LVAL) CVALTP(NVAL)
      DIMENSION IRESTP(NVAL)
      DIMENSION IPRMSG(NVAL)
C
      PARAMETER ( NMOD = 8 , LMOD = 12 )
      CHARACTER*(LMOD) CMODIF(NMOD)
C
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
      INCLUDE 'XSCCNT.INC'
      INCLUDE 'XSCMSG.INC'
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCCHK.INC'
      INCLUDE 'XMENUC.INC'
      INCLUDE 'XSCGBL.INC'
C
C
      INCLUDE 'XSSVAL.INC'
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XERVAL.INC'
      INCLUDE 'XIOBUF.INC'
C        CHARACTER*4 CCRICH
      INCLUDE 'CAMBLK.INC'
C
C
      EQUIVALENCE ( IVALUE , VALUE )
      DATA CLSTNM / ' ' /
      DATA CPRVNM / ' ' /
C
      DATA CVALTP / 'INTEGER'      , 'REAL'         , 'TEXT'         ,
     2              'KEYWORD'      , 'VERIFIED'     , 'FILENAME'     ,
     3              'ABBREVIATED'  , 'YESNO'        /
C
      DATA ITPINT / 1 / , ITPREA / 2 /
      DATA ITPTXT / 3 / , ITPKEY / 4 /
      DATA ITPVKY / 5 / , ITPFIL / 6 /
      DATA ITPABB / 7 / , ITPYSN / 8 /
C
      DATA IRESTP / 1 , 2 , 0 , 0 , 1 , 1 , 1 , 1 /
      DATA IPRMSG / 11 , 12 , 13 , 14 , 15 , 16 , 17 , 18 /
C
      DATA CMODIF / 'FINAL'        , 'APPEND'       , 'FILL'         ,
     2              'NOSTORE'      , 'NOPROMPT'     , 'NOREMOVE'     ,
     3              'NOMESSAGE'    , 'SILENT' /
     3
C
C
      LINLEN = MLNLEN
C
      IF (ISSTML .EQ. 3 ) THEN
C----- LEAVE ROOM FOR THE BORDER
      LINLEN = MLNLEN - 2
C----- INITIALISE MENU BOX FOR DOS
            DO 1 I = 1,MLNLEN
            CTOP(I:I) = CHAR(205)
            CBOX(I:I) = ' '
            CBTM(I:I) = CHAR(196)
1           CONTINUE
            CTOP(1:1) = CHAR(213)
            CTOP(MLNLEN:MLNLEN) = CHAR(187)
            CBOX(1:1) = CHAR(179)
            CBOX(MLNLEN:MLNLEN) = CHAR(186)
            CBTM(1:1) = CHAR(192)
            CBTM(MLNLEN:MLNLEN) = CHAR(189)
      ENDIF
C
      IVALUE = 0
      INTERR = 0
C
C -- SET INITIAL VALUE FOR VALUE FOUND
C
C This seems to be causing memory problems:
C      CALL XMOVEI ( 0 , ISCVAL , 1 )
C Try this instead:
      ISCVAL = 0
C
C -- READ MODIFIERS IF ANY
C -- SET INITIAL VALUES
C
      IFINAL = 0
      IAPPND = 0
      IFILL = 0
      INOSTR = 0
      INOPMT = 0
      INOREM = 0
      INOMSG = 0
      ISILNT = 0
C
1000  CONTINUE
C
C -- READ KEYWORD. CHECK AGAINST MODIFIER NAMES ( IF NO MATCH, IT
C    WILL BE CHECKED AGAINST DATA TYPES BELOW )
C
        LMODIF = KCCARG ( CUPPER , IDIRPS , 1 , NMODIF , NEND )
        IF ( LMODIF .LE. 0 ) GO TO 9810
C
        IMODIF = KCCOMP ( CUPPER(NMODIF:NEND) , CMODIF , NMOD , 2 )
        IF ( IMODIF .LE. 0 ) THEN
          GO TO 1020
        ELSE IF ( IMODIF .EQ. 1 ) THEN
          IFINAL = 1
        ELSE IF ( IMODIF .EQ. 2 ) THEN
          IAPPND = 1
        ELSE IF ( IMODIF .EQ. 3 ) THEN
          IFILL = 1
        ELSE IF ( IMODIF .EQ. 4 ) THEN
          INOSTR = 1
        ELSE IF ( IMODIF .EQ. 5 ) THEN
          INOPMT = 1
        ELSE IF ( IMODIF .EQ. 6 ) THEN
          INOREM = 1
        ELSE IF ( IMODIF .EQ. 7 ) THEN
          INOMSG = 1
        ELSE IF ( IMODIF .EQ. 8 ) THEN
          ISILNT = 1
        ENDIF
C
      GO TO 1000
C
C
1020  CONTINUE
C
C -- CHECK KEYWORD FOUND AGAINST VALUE TYPE NAMES
C
      IVALTP = KCCOMP ( CUPPER(NMODIF:NEND) , CVALTP , NVAL , 2 )
      IF ( IVALTP .LE. 0 ) GO TO 9820
C
C -- CREATE 'ALLOWED VALUES' LIST IF REQUIRED
C
      IF (      ( ( IVALTP .EQ. ITPVKY ) .OR.
     2            ( IVALTP .EQ. ITPABB ) .OR.
     3            ( IVALTP .EQ. ITPYSN ) ) .AND.
     4                        ( NCHKUS .GT. 0 ) ) THEN
        CVAL = '( '
        ICP = 3
        JCP = ICP
        J = 1
        CALL XZEROF (IPMBRK, 3)
        DO 1050 I = 1 , NCHKUS
C -- TRIM SPACES
          CVAL(ICP:) = CCHECK(I)
          K = INDEX ( CCHECK(I)//' ' , ' ' )
          ICP = ICP + K
C -- SET BREAK POINT
          IF ( JCP+K .LT. LINLEN ) THEN
            JCP = JCP + K
          ELSE
            J = J + 1
            IF (J .GT. MLIN) GOTO 9870
            JCP = K
          ENDIF
          IPMBRK(J) = ICP -1
1050      CONTINUE
        CVAL(ICP:) = ')'
        IPMBRK(J) = ICP + 1
        ICHECK = 1
      ELSE
C -- NO ALLOWED VALUE LIST
        ICP = 0
        ICHECK = 0
      ENDIF
C
C -- DETERMINE PROMPT STRING
C
      ISTAT = KSCEXP ( IPMTST, IPMTTP, CUPPER, CLOWER, IDIRPS, 1 )
      IF ( ISTAT .LE. 0 ) GO TO 9830
      IF ( IPMTTP .NE. 4 ) GO TO 9830
C
      ISTAT = KSCSDC ( IPMTST , CBUFFR , LENPMT )
C
C----- SAVE THE PROMPT STRING
      MENPMT = LENPMT
      CPRMPT(1:LENPMT) = CBUFFR(1:LENPMT)
C
      IMSG = IPRMSG(IVALTP)
      CBUFFR(LENPMT+1:) = CSCMSG(IMSG)
      LENPMT = LENPMT + LSCMSG(IMSG) + 1
      CBUFFR(LENPMT+1:LENPMT+2) = '[ '
      LENPMT = LENPMT + 2
C
C -- DETERMINE DEFAULT VALUE STRING IF ANY
C
      ISTAT = KSCEXP ( IDEFST, IDEFTP, CUPPER, CLOWER, IDIRPS, 1 )
      IF ( ISTAT .LT. 0 ) THEN
        GO TO 9840
      ELSE IF ( ISTAT .EQ. 0 ) THEN
        LENDEF = 0
      ELSE
C -- STORE DEFAULT VALUE, AND INSERT TEXT IN PROMPT
        IF ( IDEFTP .NE. 4 ) GO TO 9840
        ISTAT = KSCSDC ( IDEFST, CDEFLT , LENDEF )
      ENDIF
      IF ( LENDEF .LE. 0 ) THEN
C -- NO DEFAULT VALUE. INDICATE THIS BY PUTTING '-' IN PROMPT
        CBUFFR(LENPMT+1:LENPMT+1) = '-'
        LENDEF = 1
        IDEFLT = 0
        CDEFLT = ' '
      ELSE
        CBUFFR(LENPMT+1:) = CDEFLT
        IDEFLT = 1
      ENDIF
C
C -- COMPLETE PROMPT STRING
C
      LENTOT = LENPMT + LENDEF
      CBUFFR(LENTOT+1:LENTOT+5) = ' ] : '
      LENTOT = LENTOT + 5
C
C -- SET UP POINT AT WHICH DATA WILL BE STORED
C
      IF ( ( IAPPND .LE. 0 ) .AND. ( INOSTR .LE. 0 ) ) THEN
        ICOMLN = ICOMLN + 1
      ENDIF
C
      IFAILS = 0
C
1100  CONTINUE
C
C
C -- IF INPUT IS EXHAUSTED, PROMPT THE USER FOR INPUT WITH THE
C    APPROPRIATE PROMPT STRING. CONVERT INPUT TO UPPERCASE FOR
C    PROCESSING.
C

      IF ( ( IINPPS .GT. IINPLN ) .AND.
     2     ( INOPMT .LE. 0 ) )       THEN
C
C -- OUTPUT ALLOWED VALUE LIST IF ANY
C
C -- SKIP IF IN SILENT MODE...
       IF ( ( ISILNT .EQ. 0 ) .OR. ( IFAILS .EQ. 1 ) ) THEN
        IF ( ICHECK .GT. 0 ) THEN
C---- CHECK FOR  TERMINAL TYPE, AND INSTRUCTION VERIFIED OR ABBREVIATED
          IF( ((ISSTML .NE. 1) .AND. (ISSTML .NE. 2))  .OR.
     1      ((IVALTP .NE. 5) .AND.(IVALTP .NE. 7)) ) THEN
C----- NOT MENU MODE
C            CALL VGACOL ('BOL', 'YEL', 'CYA' )
            CALL OUTCOL(4)
            IF (ISSTML .EQ. 3) THEN
C---- SPECIAL  DOS PROMPT - YELLOW ON CYAN
C Don't use those funny characters in Cameron.
#ifdef _DOS_ 
              IF ( LCLOSE ) THEN
#endif
               WRITE ( CMON, 1102) CTOP(1:MLNLEN)
               CALL XPRVDU(NCVDU, 1,0)
#ifdef _DOS_ 
              ENDIF
#endif
              J = 1
              JCP = 1
              DO 1101 I = 1,3
              IF ( IPMBRK(J) .NE. 0 ) THEN
#ifdef _DOS_ 
                IF ( LCLOSE ) THEN
#endif
                 CMENU(1:) = CBOX(1:)
#ifdef _DOS_ 
                ELSE
                 CMENU(1:) = ' '
                ENDIF
#endif
                CMENU(2:IPMBRK(J)+1-JCP) = CVAL(JCP:IPMBRK(J))
                WRITE ( CMON, 1102 ) CMENU(1:MLNLEN)
                CALL XPRVDU(NCVDU, 1,0)
                CMENU(1:) = CBOX(1:)
                JCP = IPMBRK(J) + 1
                J = J + 1
1102            FORMAT ( 1X , A )
              ELSE
                GOTO 1103
              ENDIF
1101          CONTINUE
1103          CONTINUE
#ifdef _DOS_ 
              IF ( LCLOSE ) THEN
#endif
               WRITE ( CMON, 1102) CBTM(1:MLNLEN)
               CALL XPRVDU(NCVDU, 1,0)
#ifdef _DOS_ 
              END IF
C----       NORMAL DOS PROMPT - RED ON WHITE
#endif
            ELSE
C----- NORMAL TEXT TERMINAL
              J = 1
              JCP = 1
              DO 1105 I = 1,3
              IF ( IPMBRK(J) .NE. 0 ) THEN
                WRITE ( CMON, 1102 ) CVAL(JCP:IPMBRK(J))
                CALL XPRVDU(NCVDU, 1,0)
                JCP = IPMBRK(J) + 1
                J = J + 1
              ELSE
                IF (JCP .LE. ICP) THEN
                   WRITE ( CMON, 1102 ) CVAL(JCP:ICP)
                   CALL XPRVDU(NCVDU, 1,0)
                ENDIF
              GOTO 1106
              ENDIF
1105          CONTINUE
1106          CONTINUE
            ENDIF
C            CALL VGACOL ('BOL', 'WHI', 'BLU' )
             CALL OUTCOL(1)

          ELSE
C---- VT52/100       MENU MODE
            CALL XMENUR (CPRMPT, MENPMT, CLINPB, LENLIN, CDEFLT,
     1                  LDEFBF, IINPLN)
            GOTO 1200
          ENDIF
        ENDIF
C
C -- PROMPT THE USER
C
        CALL OUTCOL(3)
        CALL XPRMPT ( NCVDU , CBUFFR(1:LENTOT) )
        CALL OUTCOL(1)
       ENDIF
C----- RECOVER SCRIPT NAME
#ifdef CRY_GUI
      ISTAT= KSCIDN(2,3,'SCRIPTNAME',1,IS,IDSCP,ISCPNM,1)
      ISTAT= KSCSDC( ISCPNM, CSCPNM, LENNM)
      IF (CSCPNM .NE. CLSTNM) CPRVNM = CLSTNM
      CLSTNM = CSCPNM(1:LENNM)
      CALL XCTRIM (CLSTNM,LLSTNM)
      WRITE(CMON(1),'(A)') '^^WI SET PROGOUTPUT TEXT = '
      IF ( CPRVNM(1:3) .NE. '   ' ) THEN
         WRITE(CMON(2),'(5A)')'^^WI ''Running script: ',
     1   CSCPNM(1:LENNM),
     1   ' called from: ', CPRVNM(1:LLSTNM), ''''
      ELSE
         WRITE(CMON(2),'(3A)')'^^WI ''Script: ',
     1  CSCPNM(1:LENNM), ''''
      ENDIF
      WRITE(CMON(3),'(A)') '^^CR'
      CALL XPRVDU(NCVDU,3,0)
C
C -- READ THE USER'S RESPONSE FROM THE TERMINAL
C
#endif
        ISTAT = KRDLIN ( NCUFU(1) , CLINPB , IINPLN )
C -- IF NOT IN SILENT MODE ECHO THE TEXT TO THE OUTPUT FOR THE 
C    GUI VERSION
#ifdef CRY_GUI 
        IF ( ( ISILNT .EQ. 0 ) .OR. ( IFAILS .EQ. 1 ) ) THEN
         WRITE(CMON,'(A)') CLINPB(1:IINPLN)
         CALL XPRVDU(NCVDU,1,0)
        ENDIF
#endif
        IF ( ISTAT .LE. 0 ) GO TO 1100
C
1200    CONTINUE
        INTERR = 1
C -- MAKE UPPERCASE COPY
        CALL XCCUPC ( CLINPB , CUINPB )
        IINPPS = 1
C
C -- CHECK FOR USER INTERRUPT ( E.G. 'ERROR' , 'QUIT' )
        IF ( IINPLN .GT. 0 ) THEN
          ISTAT = KSCINT ( CUINPB(1:IINPLN) )
          IF ( ISTAT .GE. 0 ) THEN
            KSCVAL = ISTAT
            IINPLN = 0
            RETURN
          ENDIF
        ENDIF
      ENDIF
C
C
C -- CHECK IF NO INPUT WAS GIVEN AND A DEFAULT VALUE IS AVAILABLE
C
      IF ( IINPLN .LE. 0 ) THEN
        IF ( IDEFLT .LE. 0 ) GO TO 9920
        CLINPB = CDEFLT
        CUINPB = CDEFLT
        IINPLN = LENDEF
      ENDIF
C
C                   **** CHECK VALUE ****
C
C -- IDENTIFY TEXT REQUIRED FOR THIS INPUT VALUE, AND CHECK FOR
C    EXTRA DATA
C
C -- MOST DATA ITEMS ARE TERMINATED BY A SPACE
C
      NSTART = KCCNEQ ( CLINPB , IINPPS , ' ' )
      IF ( NSTART .LT. 0 ) THEN
        IF ( IDEFLT .LE. 0 ) GO TO 9920
        CLINPB = CDEFLT
        CUINPB = CDEFLT
        IINPLN = LENDEF
      ENDIF
      IF ( NSTART .LE. 0 ) NSTART = 1
      NENDIN = IINPLN
      NDATA = NSTART
C
C -- 'TEXT' HOWEVER CONSISTS OF THE REMAINDER OF THE INPUT LINE
C
      IF ( IVALTP .NE. ITPTXT ) THEN
        LENARG = KCCARG ( CLINPB , NDATA , 3 , NSTART , NEND )
        IF ( NSTART .LE. 0 ) NSTART = 1
        IF ( IFINAL .GT. 0 ) THEN
          IF ( KCCNEQ ( CLINPB , NDATA , ' ' ) .GT. 0 ) GO TO 9910
        ENDIF
        NENDIN = NEND
      ENDIF
C
C -- REMOVE PROCESSED TEXT FROM THAT REMAINING IN BUFFER
C
      IF ( INOREM .LE. 0 ) THEN
        IINPPS = NENDIN + 2
      ENDIF
C
C
C -- CHECKING OF NUMERIC DATA
C
      LFMTXP = NENDIN-NSTART+1
CJAN99
C----  THIS HORRID CODE IS BECAUSE digital visual fortran CANNOT ACCEPT
C      THE WRITE TO A CHARACTER FORMAT EXPRESSION
       IF ( IVALTP .EQ. ITPREA ) THEN
#if !defined(__GID__) 
         WRITE (CFMTXP, '(''( F'', I2, ''.0)'')') LFMTXP
#else
       IF (LFMTXP.EQ.1) THEN
#endif
#ifdef __GID__ 
         READ ( CLINPB(NSTART:NENDIN) , '(F1.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.2) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F2.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.3) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F3.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.4) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F4.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.5) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F5.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.6) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F6.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.7) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F7.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.8) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F8.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.9) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(F9.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.10) THEN
        READ ( CLINPB(NSTART:NENDIN) , '(F10.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.11) THEN
        READ ( CLINPB(NSTART:NENDIN) , '(F11.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.12) THEN
        READ ( CLINPB(NSTART:NENDIN) , '(F12.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.13) THEN
        READ ( CLINPB(NSTART:NENDIN) , '(F13.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.14) THEN
        READ ( CLINPB(NSTART:NENDIN) , '(F14.0)', ERR = 9940 ) VALUE
       ELSEIF (LFMTXP.EQ.15) THEN
        READ ( CLINPB(NSTART:NENDIN) , '(F15.0)', ERR = 9940 ) VALUE
       ENDIF
#else
         READ ( CLINPB(NSTART:NENDIN) , CFMTXP , ERR = 9930 ) VALUE
#endif
       ELSE IF ( IVALTP .EQ. ITPINT ) THEN
#if !defined(__GID__) 
         WRITE (CFMTXP, '(''( I'',I2,''  )'')') LFMTXP
#else
       IF (LFMTXP.EQ.1) THEN
#endif
#ifdef __GID__ 
         READ ( CLINPB(NSTART:NENDIN) , '(I1)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.2) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I2)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.3) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I3)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.4) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I4)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.5) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I5)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.6) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I6)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.7) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I7)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.8) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I8)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.9) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I9)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.10) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I10)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.11) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I11)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.12) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I12)', ERR = 9940 ) IVALUE
       ELSEIF (LFMTXP.EQ.13) THEN
         READ ( CLINPB(NSTART:NENDIN) , '(I13)', ERR = 9940 ) IVALUE
       ENDIF
#else
      READ ( CLINPB(NSTART:NENDIN) , CFMTXP, ERR = 9940 ) IVALUE
#endif
       ENDIF
C
C -- CHECKING OF KEYWORD DATA AGAINST AN ALLOWED LIST
C
      IF ( ICHECK .GT. 0 ) THEN
C -- DETERMINE WHETHER CHECK IS FOR EXACT OR ABBREVIATED MATCH
        IEXACT = 2
        IF ( ( IVALTP .EQ. ITPVKY ) .OR. ( IVALTP .EQ. ITPYSN ) ) THEN
          IEXACT = 1
        ENDIF
        IVALUE = KCCOMP ( CUINPB(NSTART:NENDIN), CCHECK,NCHKUS, IEXACT)
        IF ( IVALUE .LE. 0 ) GO TO 9950
C -- IF WE HAVE FOUND AN ABBREVIATED MATCH, CHECK THAT THERE IS NO
C    AMBIGUITY
C
        IF ( IEXACT .EQ. 2 ) THEN
          IF ( IVALUE .LT. NCHKUS ) THEN
            NCHECK = NCHKUS - IVALUE
            ICHECK = KCCOMP ( CUINPB(NSTART:NENDIN),
     2                          CCHECK(IVALUE+1), NCHECK , 2 )
            IF ( ICHECK .GT. 0 ) GOTO 9960
          ENDIF
        ENDIF
      ENDIF
C
C -- STORE AWAY VALUE OF USER'S INPUT FOR POSSIBLE LATER USE. THE TYPE,
C    STARTING POSITION IN THE INPUT STRING, AND LENGTH ARE ALSO STORED.
      CALL XMOVEI ( IVALUE , ISCVAL , 1 )
      ISCVLS = NSTART
      ISCVLN = NENDIN
C
      ISCVTP = IRESTP(IVALTP)
C
C -- CHECK FOR A VALIDATING EXPRESSION
C
      IDIRSV = IDIRPS
      ISTAT = KSCEXP ( IVALID, IVLDTP, CUPPER, CLOWER, IDIRPS, 1 )
      IF ( ISTAT .LT. 0 ) THEN
        GO TO 9850
      ELSE IF ( ISTAT .EQ. 0 ) THEN
      ELSE
        IF ( IVLDTP .NE. 3 ) GO TO 9850
        IF ( IVALID .NE. 1 ) THEN
          IDIRPS = IDIRSV
          GO TO 9970
        ENDIF
      ENDIF
C
C
C -- STORE USER'S INPUT IN BUFFER
C
      IF ( INOSTR .LE. 0 ) THEN
        IF ( IFILL .GT. 0 ) THEN
          ISTAT = KCCAPP ( CCOMBF , ICOMLN , CCHECK(IVALUE) )
        ELSE
          ISTAT = KCCAPP ( CCOMBF , ICOMLN , CLINPB(NSTART:NENDIN) )
        ENDIF
        IF ( ISTAT .LE. 0 ) GO TO 9860
      ENDIF
C
C -- STORE AWAY VALUE OF USER'S INPUT FOR POSSIBLE LATER USE. THE TYPE,
C    STARTING POSITION IN THE INPUT STRING, AND LENGTH ARE ALSO STORED.
      CALL XMOVE ( IVALUE , ISCVAL , 1 )
      ISCVLS = NSTART
      ISCVLN = NENDIN
C
9000  CONTINUE
C
C -- A VALUE TYPE WILL BE SET BEFORE EACH RETURN
      ISCVTP = IRESTP(IVALTP)
      KSCVAL = 0
      RETURN
C
C
9800  CONTINUE
C
C -- ERROR IN THE SCRIPT COMMAND.
      GO TO 9000
C
9810  CONTINUE
      CALL XSCMSG ( MMISSG , MKEYWD , ' ' , 0 )
      GO TO 9800
9820  CONTINUE
      CALL XSCMSG ( MILLEG , MKEYWD , CLOWER(NMODIF:NEND) , 0 )
      GO TO 9800
9830  CONTINUE
      CALL XSCMSG ( MILLMS , MPRMPT , ' ' , 0 )
      GO TO 9800
9840  CONTINUE
      CALL XSCMSG ( MILLEG , MDEFLT , ' ' , 0 )
      GO TO 9800
9850  CONTINUE
      CALL XSCMSG ( MILLEG , MVLDEX , ' ' , 0 )
      GO TO 9800
9860  CONTINUE
      CALL XSCMSG ( MOVERF , 37 , ' ' , 0 )
      GO TO 9800
9870  CONTINUE
      CALL XSCMSG ( MTOOMY , MIDENT , ' Menu Items ' , 0 )
      GO TO 9800
C
C
9900  CONTINUE
C
C -- ERROR IN USER'S INPUT
C    GET USER TO TRY AGAIN, IF ERROR CAN BE HANDLED HERE
      IINPLN = 0
      IFAILS = 1
      IF ( INTERR .GT. 0 ) GO TO 1100
C -- IF USER MESSAGES ARE BEING PRODUCED, START ERROR SEARCH
      IF ( INOMSG .LE. 0 ) CALL XERHND ( IERSFL )
      GO TO 9000
C
9910  CONTINUE
      IF ( INOMSG .GT. 0 ) GO TO 9900
      IERROR = 1
      GO TO 9990
C
9920  CONTINUE
      IF ( INOMSG .GT. 0 ) GO TO 9900
      IERROR = 2
C -- FIX POINTERS SO THERE IS NO ATTEMPT TO DISPLAY THE 'INCORRECT USER
C    INPUT'
      NSTART = 1
      NENDIN = 0
      GO TO 9990
C
9930  CONTINUE
      IF ( INOMSG .GT. 0 ) GO TO 9900
      IERROR = 3
      GO TO 9990
C
9940  CONTINUE
      IF ( INOMSG .GT. 0 ) GO TO 9900
      IERROR = 4
      GO TO 9990
C
9950  CONTINUE
      IF ( INOMSG .GT. 0 ) GO TO 9900
      IERROR = 5
      GO TO 9990
9960  CONTINUE
      IF ( INOMSG .GT. 0 ) GO TO 9900
      IERROR = 19
      GO TO 9990
9970  CONTINUE
      IF ( INOMSG .GT. 0 ) GO TO 9900
      IERROR = 20
      GO TO 9990
C
C
9990  CONTINUE
C
C
C -- THIS SECTION OUTPUTS MESSAGES FOLLOWING A 'USER ERROR'. THE MESSAGE
C    TEXT CAN BE CHANGED BY THE 'MESSAGE' COMMAND. THE USER IS ALSO
C    SHOWN THE PART OF THE INPUT THAT WAS INCORRECT
C
      WRITE ( CMON, 9995 ) CSCMSG(IERROR)(1:LSCMSG(IERROR))
      CALL XPRVDU(NCVDU, 2,0)
9995  FORMAT ( / , 1X , A )
C
      IF ( NENDIN .GE. NSTART ) THEN
        WRITE ( CMON, 9997 ) '"'//CUINPB(NSTART:NENDIN)//'"'
        CALL XPRVDU(NCVDU, 2,0)
9997    FORMAT ( 11X , A , / )
      ELSE
        WRITE ( CMON, 9998 )
        CALL XPRVDU(NCVDU, 1,0)
9998    FORMAT ( 1X )
      ENDIF
      GO TO 9900
C
C
      END
CODE FOR KSCVAR
      FUNCTION KSCVAR ( IN )
C
C -- DEFINE NEW VARIABLE
C
C -- THIS ROUTINE IMPLEMENTS THE SCRIPT 'VARIABLE' INSTRUCTION
C
C  'IN' IS A DUMMY ARGUMENT
C
C      RETURN VALUE OF KSCVAR IS THE VALUE TO BE USED FOR 'KSCPRC'
C
C
C
      INCLUDE 'PSCRPT.INC'
      INCLUDE 'PSCMSG.INC'
C
C
      CHARACTER*(MAXLAB) CVARIB
C
      PARAMETER ( LTYP = 12 , NTYP = 4 )
      CHARACTER*(LTYP) CTYPE(NTYP)
C
C
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XSCGBL.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
      EQUIVALENCE ( IVALUE , VALUE )
C
C
      DATA CTYPE / 'INTEGER' , 'REAL' , 'LOGICAL' , 'CHARACTER' /
C
C -- READ/CHECK KEYWORD
C
C
      LENARG = KCCARG ( CUPPER , IDIRPS , 1 , NTYPE , NEND )
      IF ( LENARG .LE. 0 ) GO TO 9930
C
      ITYPE = KCCOMP ( CUPPER(NTYPE:NEND) , CTYPE , NTYP , 1 )
      IF ( ITYPE .LE. 0 ) GO TO 9930
C
      IVAR = 0
C
1000  CONTINUE
C
C -- READ VARIABLE NAME
C
      LENVAR = KCCARG ( CUPPER , IDIRPS , 1 , NVAR , NEND )
      IF ( LENVAR .LE. 0 ) GO TO 8000
C
      CVARIB = CUPPER(NVAR:NEND)
C
C -- CHECK IF VARIABLE IS ALREADY KNOWN. IT NOT, CREATE IT. IF IT IS,
C    CHECK THAT ITS EXISTING TYPE IS CONSISTENT WITH THE NEW DEFINITION
C
      IADDR = KSCIDN ( 2, 3, CVARIB, 1, IVTYPE, IDENT, IVALUE, -1 )
C
C -- IF VARIABLE IS NOT ALREADY KNOWN, INITIALISE IT
C
      IF ( IADDR .LE. 0 ) THEN
C
        IF ( ITYPE .EQ. 1 ) THEN
C -- 'INTEGER' - ZERO
          IVALUE = 0
        ELSE IF ( ITYPE .EQ. 2 ) THEN
C -- 'REAL' - ZERO
          VALUE = 0.0
        ELSE IF ( ITYPE .EQ. 3 ) THEN
C -- 'LOGICAL' - SET TO 'FALSE'
          IVALUE = 0
        ELSE IF ( ITYPE .EQ. 4 ) THEN
C -- CHARACTER - ALLOCATE AN EMPTY DESCRIPTOR
          ISTAT = KSCSAD ( 0 , IVALUE )
        ENDIF
C
        IADDR = KSCIDN ( 1, 3, CVARIB, 1, ITYPE, IDENT, IVALUE, -1 )
      ELSE
        IF (ISCVER .GT. 0)  THEN
         WRITE ( CMON, 9998 ) CVARIB
         CALL XPRVDU(NCVDU, 1,0)
         IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') 
     1     CMON(1)(5:len_trim(CMON(1)))
9998     FORMAT ('{9,1 ', A,' Already exists' )
        ENDIF
        IF ( IVTYPE .NE. ITYPE ) GO TO 9920
      ENDIF
C
C -- VERIFY OPERATION
C
      IF ( ISCVER .GT. 0 ) THEN
        WRITE ( CMON, 1505 ) CTYPE(ITYPE) , IADDR , CVARIB
        CALL XPRVDU(NCVDU, 1,0)
1505  FORMAT ( 1X, A, ' variable ( number', I3, ' ) assigned :-', A )
      ENDIF
C
      IVAR = IVAR + 1
      GO TO 1000
C
8000  CONTINUE
C
C -- AT LEAST ONE VARIABLE NAME SHOULD HAVE BEEN GIVEN
C
      IF ( IVAR .EQ. 0 ) GO TO 9910
      KSCVAR = 0
      RETURN
C
C
9900  CONTINUE
      KSCVAR = 0
C
      RETURN
9910  CONTINUE
      CALL XSCMSG ( MMISSG , MVARIA , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MINCON , MVARIA , CVARIB , 0 )
      GO TO 9900
9930  CONTINUE
      CALL XSCMSG ( MILLMS , MKEYWD , ' ' , 0 )
      GO TO 9900
C
      END
CODE FOR XSCFRM
      SUBROUTINE XSCFRM ( ITYPE )
C
C -- CREATE NEW STACK LEVEL
C
C      ITYPE       TYPE OF STACK LEVEL TO CREATE
C
C -- THE 'TYPES' CORRESPOND TO THE VARIOUS STRUCTURE MAKING INSTRUCTIONS
C    'SCRIPT', 'BLOCK', ETC
C
C    IN ADDITION A TYPE OF 0 IS USED WHEN A SCRIPT FILE IS FIRST OPENED
C    SO INDICATE THAT A NEW FILE IS BEING USED.
C
C    THE STACK IS HELD IN AN ARRAY 'ISTACK'. THE STACK LEVEL AT ANY
C    MOMENT IS DETERMINED BY REFERENCE TO THE ARRAY ELEMENT
C    'ILEVEL(IFLIND)'. THIS POINTS TO A SET OF VALUES IN 'ISTACK'. THIS
C    METHOD MEANS THAT A SCRIPT FILE CAN BE CLOSED WITHOUT WORRYING
C    ABOUT STACK POINTERS, AS THE POINTER FOR THE PREVIOUS FILE WILL
C    AUTOMATICALLY COME INTO USE. UP TO 'NSTACK' STACK LEVELS MAY EXIST.
C
C    FOR LEVEL N, ITEM J IN THE STACK IS 'ISTACK(J,N)'. THE ITEMS
C    STORED IN THE STACK ARE REFERRED TO BY NUMERIC CODES. THESE CODES
C    ARE LISTED IN 'KSCPRC'.
C
C
C
C -- THIS ROUTINE BUILDS A NEW STACK FRAME. THE VALUES OF EACH ITEM
C    IN THIS NEW FRAME ARE DERIVED ACCORDING TO THE DESCRIPTION
C    IN 'INOPER'. FOR EACH ITEM, A CODE IN 'INOPER' INDICATES HOW IT
C    IS TO BE GENERATED FOR THE NEW STACK FRAME. THE POSSIBLE CODES
C    ARE :-
C            JCOPY       COPY VALUE IN OUTER STACK FRAME
C            JZERO       SET VALUE TO ZERO
C            JCALC       INVOKE SPECIAL CODE TO CALCULATE THIS
C                        ITEM. ( USED FOR :-
C                              JBTYPE - VALUE = 'ITYPE'
C                              JBSTRT - VALUE = 'IRDREC(IFLIND)'
C                              JSTLVL - VALUE = 'INEWLV'
C
C      THE ARRAY 'ICOPY0' GIVES THE INITIAL VALUES FOR THOSE ELEMENTS
C      WHICH ARE COPIED WHEN THERE IS NO OUTER STACK FRAME.
C
C
C
C
      INCLUDE 'PSCSTI.INC'
      INCLUDE 'PSCSTK.INC'
      INCLUDE 'PSCMSG.INC'
C
C
      PARAMETER ( JCOPY = 1 , JZERO = 2 , JCALC = 3 )
      DIMENSION INOPER(LSTACK)
      DIMENSION ICOPY0(LSTACK)
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSCSTK.INC'
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XIOBUF.INC'
C
C                   JVARIB JNVARI JNFDAT JNFCHR JEXECU
C                   JBTYPE JBSTRT JBLEND JNSTAT JREQST
C                   JWASEX JSTLVL
C
      DATA INOPER / JCOPY , JZERO , JCOPY , JCOPY , JCOPY ,
     2              JCALC , JCALC , JZERO , JZERO , JZERO ,
     3              JZERO , JCALC /
C
      DATA ICOPY0 /     0 ,     0 ,     1 ,     1 ,     1 ,
     2                  0 ,     0 ,     0 ,     0 ,     0 ,
     3                  0 ,     0 /
C
C
C
C -- VERIFY OPERATION
C
      IF ( ISCSVE .GT. 0 ) THEN
        WRITE ( CMON, 1005 ) ITYPE,IFLIND, ILEVEL(IFLIND)
        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') trim(CMON(1))
1005    FORMAT ( 1X , 'Create stack frame of type : ', I6,' file# ',2I6)
      ENDIF
C
C -- INITIALISE STACK POINTERS FOR NEW FILE LEVEL IF REQUIRED
C
      IF ( ITYPE .LE. 0 ) THEN
C
        INEW = MAX0 ( ILEVEL(IFLIND) + 1 , 1 )
C        INEW = 1
        DO ILX = IFLIND+1, NFILVL
          ILEVEL(ILX) =  INEW
        END DO
        ILEVEL(IFLIND+1) = - INEW
        ISCINI = 0
        RETURN
      ENDIF
C
C -- CHECK CURRENT STACK LEVEL
C -- ENSURE THAT 'SCRIPT' IS THE FIRST BLOCK TYPE IN EACH FILE.
C
      ICURLV = ILEVEL(IFLIND)

      IF ( ISCSVE .GT. 0 ) THEN
        WRITE ( CMON, 1006 ) ICURLV, ITYPE, IFLIND
        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') trim(CMON(1))
1006    FORMAT ( 1X , 'Old level : ', I6,' type ',I6,' ifl ',i6)
      ENDIF
C
      IF ( ITYPE .EQ. 1 ) THEN
        IF ( ICURLV .GT. 0 ) GO TO 9910
        ICURLV = -1 - ICURLV
        INEWLV = ICURLV + 1
      ELSE
        IF ( ICURLV .LE. 0 ) GO TO 9910
        INEWLV = ICURLV + 1
      ENDIF
C
C -- CHECK STACK LIMIT
C
      IF ( INEWLV .GT. NSTACK ) GO TO 9920
C
C -- VERIFY OPERATION
C
      IF ( ISCSVE .GT. 0 ) THEN
        WRITE ( CMON, 1015 ) ICURLV , INEWLV
        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') trim(CMON(1))
1015    FORMAT ( 1X , 'Current level :  ' , I5 , ' New level : ' , I5 )
      ENDIF
C
C -- CREATE NEW STACK BLOCK
C
      DO 2000 I = 1 , LSTACK
C
C -- WORK OUT THE NEW VALUE FOR EACH ITEM IN THE STACK FRAME
C
        IF ( INOPER(I) .EQ. JCOPY ) THEN
          IF ( ICURLV .GT. 0 ) THEN
            NEWVAL = ISTACK(I,ICURLV)
          ELSE
            NEWVAL = ICOPY0(I)
          ENDIF
        ELSE IF ( INOPER(I) .EQ. JZERO ) THEN
          NEWVAL = 0
        ELSE IF ( INOPER(I) .EQ. JCALC ) THEN
          IF ( I .EQ. JBTYPE ) THEN
            NEWVAL = ITYPE
          ELSE IF ( I .EQ. JBSTRT ) THEN
            NEWVAL = IRDREC(IFLIND)
          ELSE IF ( I .EQ. JSTLVL ) THEN
            NEWVAL = INEWLV
          ENDIF
        ELSE
          NEWVAL = 0
        ENDIF
C
        ISTACK(I,INEWLV) = NEWVAL
C
2000  CONTINUE
C
C -- VERIFY OPERATION
C
      IF ( ISCSVE .GT. 0 ) THEN
        WRITE ( CMON, 2005 ) ( ISTACK(J,INEWLV) , J = 1 , LSTACK)
        CALL XPRVDU(NCVDU, 3,0)
        IF (ISSPRT .EQ. 0) 
     1  WRITE (NCWU,2005)(ISTACK(J,INEWLV),J=1,LSTACK)
2005    FORMAT ( 1X , 'Contents of new stack level' , / ,
     2 2 ( 1X , 12I7 , / ) )
      ENDIF
C
C -- UPDATE CURRENT STACK LEVEL
      ILEVEL(IFLIND) = INEWLV
      DO ILX = IFLIND+1, NFILVL
        ILEVEL(ILX) = INEWLV
      END DO
C
      ISCINI = 1
C
      RETURN
C
C
9900  CONTINUE
      RETURN
C
9910  CONTINUE
      CALL XSCMSG ( MINCOR, MORDER, 'SCRIPT should be first in file',0)
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MOVERF , MSTACK , ' ' , 0 )
      GO TO 9900
C
C
      END
CODE FOR XSCJMP
      SUBROUTINE XSCJMP ( CLABEL )
C
C -- JUMP TO SPECIFIED LABEL
C
C      CLABEL            LABEL TO BE USED FOR SEARCH
C
C
C
      CHARACTER*(*) CLABEL
C
C
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'XSCCNT.INC'
C
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XIOBUF.INC'
C
C
C -- SET DEFAULT SEARCH START POINT
C    THE SEARCH WILL START FROM THE FURTHEST POINT REACHED IN THE FILE,
C    IF THE LOCATION OF THE LABEL IS NOT KNOWN
C
      ILOCAT = MAX0 ( IRDREC(IFLIND) , IRDHGH(IFLIND) )
C
C -- SEE IF THE VALUE OF THIS LABEL IS KNOWN, IF FAST SEARCH IS ENABLED
C
      IF ( ISCFST .GT. 0 ) THEN
C -- CHECK IF THIS LABEL IS KNOWN
        ISTAT = KSCIDN ( 2 , 1 , CLABEL , 2 ,I , IDENT , IRECRD , -1 )
        IF ( ISTAT .GT. 0 ) THEN
          IF ( IRECRD .GT. 0 ) THEN
            ILOCAT = IRECRD
C -- VERIFY OPERATION
            IF ( ISCVER .GT. 0 ) THEN
              WRITE ( CMON, 1005 ) CLABEL , IRECRD
              CALL XPRVDU(NCVDU, 1,0)
1005          FORMAT ( 1X, 'Fast search for label ' , A , ' at ' , I5 )
            ENDIF
C
          ENDIF
        ENDIF
      ELSE
       ILOCAT = 0
      ENDIF
C
C -- INDICATE LABEL SEARCH IN PROGRESS
C
      ISCSER = 1
      IRDFND(IFLIND) = ILOCAT
      IF ( IRDFND(IFLIND) .LT. IRDREC(IFLIND) ) THEN
C -- SET NEW FILE POSITION
        REWIND NCRU
        IRDHGH(IFLIND) = IRDREC(IFLIND)
        IRDREC(IFLIND) = 0
      ENDIF
C
      RETURN
      END
CODE FOR XSCMSG
      SUBROUTINE XSCMSG ( IERROR , ITYPE , CPARAM , IPARAM )
C
C -- OUTPUT STANDARD MESSAGES
C
C      IERROR      ERROR TYPE
C      ITYPE       DATA TYPE
C      CPARAM      OPTIONAL CHARACTER TEXT
C      IPARAM      OPTIONAL NUMERIC PARAMETER ( IGNORED )
C
C -- THESE MESSAGES ARE USED TO INDICATE SYNTAX ERRORS IN THE SCRIPT
C    SOURCE TEXT, RATHER THAN THE ERRORS OF THE FINAL USER.
C
C
      CHARACTER*(*) CPARAM
C
C
      PARAMETER ( LCOMP = 12, NCOMP = 30 )
      PARAMETER ( LERROR = 22 , NERROR = 17 )
      PARAMETER ( LTYPE = 21 , NTYPE = 37 )
C
      PARAMETER ( MAXQUO = 50 )
C
      CHARACTER*(LCOMP) CCOMP(0:NCOMP)
      CHARACTER*(LTYPE) CTYPE(NTYPE)
      CHARACTER*(LERROR) CERROR(NERROR)
C
      DIMENSION LNTYPE(NTYPE) , LNERR(NERROR)
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
      INCLUDE 'UFILE.INC'
C
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XSCCHR.INC'
      INCLUDE 'XIOBUF.INC'
cdjwdec09
      INCLUDE 'XSCCHK.INC'
      INCLUDE 'XMENUC.INC'
      INCLUDE 'XMENUI.INC'
C
      DATA CCOMP / 'SCRIPT      ' ,
     2 '(LABEL)     ', 'ACTIVATE    ', 'COPY        ',
     2 'CLEAR       ', 'INSERT      ', 'SEND        ', 'GET         ',
     3 'VERIFY      ', '(ERROR)     ', '(JUMP)      ', '(BRANCH)    ',
     4 '(DECREMENT) ', 'FINISH      ', 'END         ', 'QUEUE       ',
     5 'ON          ', 'STORE       ', 'VARIABLE    ', 'SET         ',
     6 'EXTERNAL    ', 'ELSE        ', '(SELECT)    ', 'EXECUTE     ',
     7 'SHOW        ', 'EVALUATE    ', 'MESSAGE     ', 'INDEX       ',
     8 'EXTRACT     ', 'IDENTIFY    ', 'TRANSFER    ' /
C
      DATA CTYPE / 'command' , 'constant' , 'variable' , 'data' ,
     2 'expression' , '"="' , 'allowed value' , 'label' , 'structure' ,
     3 'initialised' , 'operator' , 'argument type(s)' ,
     4 'contingency action' , 'contingency type' , 'argument' ,
     5 'output list' , 'operator stack' , 'number of brackets' ,
     6 'token in expression' , 'keyword' , 'identifier' ,
     7 'identifier list' , 'identifier number' , 'indexing expression',
     8 'parameter' , 'opening file' , 'file channels' , 'stack' ,
     9 'prompt string' , 'message' , 'length' , 'stack level' ,
     * 'stack item code' , 'operation order' , 'default value' ,
     1 'validating expression','command buffer (GET)' /
C
      DATA LNTYPE / 7 , 8 , 8 , 4 ,
     2 10 , 3 , 13 , 5 , 9 ,
     3 11 , 8 , 16 ,
     4 18 , 16 , 8 ,
     5 11 , 14 , 18 ,
     6 19 , 7 , 10 ,
     7 15 , 17 , 19 ,
     8 9 , 12 , 13 , 5 ,
     9 13 , 7 , 6 , 11 ,
     * 15 , 15 , 13 ,
     1 21, 20 /
C
      DATA CERROR / 'Illegal' , 'Illegal or missing' , 'Wrong type of',
     2 'Missing' , 'Incorrect type of' , 'Too many' , 'Not found' ,
     3 'Unexpected' , 'Incorrectly' , 'Insufficent data for' ,
     4 'Mixed or inappropriate', 'Overflow of', 'Inconsistent use of',
     5 'Unknown' , 'Out of range' , 'Error in' ,'** INTERNAL ERROR in' /
C
      DATA LNERR / 7 , 18 , 13 ,
     2 7 , 17 , 8 , 9 ,
     3 10 , 11 , 20 ,
     4 22 , 11 , 19 ,
     5 7 , 12 , 8 , 20 /
C
      IF ( ISCMSG .LE. 0 ) RETURN
C
C
C
C -- CHECK SUPPLIED ARGUMENTS
C
      IF ( IERROR .LE. 0 ) GO TO 9910
      IF ( IERROR .GT. NERROR ) GO TO 9910
      IF ( ITYPE .LE. 0 ) GO TO 9910
      IF ( ITYPE .GT. NTYPE ) GO TO 9910
C
C
      IF ( ISCCOM .LE. 0 ) ISCCOM = 0
C
C -- OUTPUT BASIC MESSAGE
cdjwdec09
C----- RECOVER SCRIPT NAME
      ISTAT = KSCIDN (2, 3, 'SCRIPTNAME', 1, IS, IDSCP, ISCPNM, 1)
      ISTAT = KSCSDC ( ISCPNM, CSCPNM, LENNM)
      IF (CSCPNM .NE. CLSTNM) CPRVNM = CLSTNM
      CLSTNM = CSCPNM(1:LENNM)
c
cdjwjun07
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(a,a)' ) 
     1 'Processing ',cscpnm(1:lennm)
      IF ( CPRVNM(1:3) .NE. CSPACE(1:3) ) THEN
      WRITE(CMON(1),'(5A)')
     1'Script: ',CSCPNM(1:LENNM),
     1   ' called from: ', CPRVNM
      ELSE
      WRITE(CMON(1),'(3A)')' Script: ',
     1  CSCPNM(1:LENNM), ''''
      ENDIF
      CALL XPRVDU(NCVDU, 1,0)
      IF (ISSPRT .EQ. 0) WRITE ( NCWU , '(a)' ) trim(CMON(1))
cdjwjun07
cdjwdec09
C
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 1005 ) IFLIND,IRDREC(IFLIND),IDSCP,
     2             CCOMP(ISCCOM),CERROR(IERROR)(1:LNERR(IERROR)) ,
     3             CTYPE(ITYPE)(1:LNTYPE(ITYPE))
      ENDIF
      WRITE ( CMON, 1005 )  IFLIND,IRDREC(IFLIND),IDSCP,
     2             CCOMP(ISCCOM),CERROR(IERROR)(1:LNERR(IERROR)) ,
     3             CTYPE(ITYPE)(1:LNTYPE(ITYPE))
      CALL XPRVDU(NCVDU, 4,0)
1005  FORMAT ( / 1X , 'CRYSTALS SCRIPT error, file-index: ',I5,
     1 '; line ',I4,'; descriptor:',i4/,
     1 ' Failing component is ', A , / ,
     3 1X , A , 2X , A )
C
C -- OUTPUT A STRING VALUE, IF ONE WAS SUPPLIED
C
      IF ( ( LEN ( CPARAM ) .LE. MAXQUO ) .AND.
     2     ( CPARAM .NE. ' ' ) ) THEN
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 1035 ) CPARAM
      ENDIF
        WRITE ( CMON, 1035 ) CPARAM
        CALL XPRVDU(NCVDU, 2,0)
1035    FORMAT ( 11X , '"' , A , '"' , / )
      ELSE
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 1045 ) CPARAM
      ENDIF
        WRITE ( CMON, 1045 ) CPARAM
        CALL XPRVDU(NCVDU, 2,0)
1045    FORMAT ( 1X , A , / )
      ENDIF
C
C -- OUTPUT THE CURRENT DIRECTIVE, WITH A POINTER TO THE CURRENT
C    CURSOR POSITION WHICH SHOULD INDICATE THE POSITION OF THE ERROR
C
      IPOS = IDIRPS - 1
      IF ( IPOS .LE. 0 ) IPOS = IDIRLN
      IF ( ( IPOS .GT. 0 ) .AND. ( IDIRLN .GT. 0 ) ) THEN
        IMIN = MAX0 ( 1 , IPOS - 35 )
        IMAX = MIN0 ( IPOS + 35 , LENDIR )
      IF (ISSPRT .EQ. 0) THEN
        WRITE ( NCWU , 1055 ) CLOWER(IMIN:IPOS),
     2 CLOWER(IPOS+1:IMAX)
      ENDIF
        WRITE ( CMON, 1055 ) CLOWER(IMIN:IPOS), CLOWER(IPOS+1:IMAX)
        CALL XPRVDU(NCVDU, 2,0)
1055  FORMAT ( 1X , A , '<', A,  / )
      ENDIF
C
      RETURN
C
C
9900  CONTINUE
      RETURN
9910  CONTINUE
      IF (ISSPRT .EQ. 0) THEN
      WRITE ( NCWU , 9915 ) IERROR , ITYPE
      ENDIF
      WRITE ( CMON, 9915 ) IERROR , ITYPE
      CALL XPRVDU(NCVDU, 6,0)
9915  FORMAT ( // , 1X , '*****' , / ,
     2 1X , 'An illegal call to XSCMSG has been made' , / ,
     3 1X , 'The supplied code values were : ' , 2I16 , // )
      GO TO 9900
      END
CODE FOR XSCRST
      SUBROUTINE XSCRST
C
C -- REDUCE STACK LEVEL BY ONE
C
C
      INCLUDE 'PSCSTI.INC'
      INCLUDE 'PSCSTK.INC'
C
C
C
      INCLUDE 'XSCGBL.INC'
      INCLUDE 'XSCSTK.INC'
      INCLUDE 'UFILE.INC'
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
      INCLUDE 'XIOBUF.INC'
C
C
C
C -- VERIFY OPERATION
C
      IF ( ISCSVE .GT. 0 ) THEN
        LEVEL = ILEVEL(IFLIND)
        WRITE ( CMON, 1005 ) LEVEL , ISTACK(JBTYPE,LEVEL)
        CALL XPRVDU(NCVDU, 1,0)
        IF (ISSPRT .EQ. 0) WRITE(NCWU,'(A)') trim(CMON(1))
1005    FORMAT ( 1X , 'Delete current stack level ' , I5 ,
     2 ' of type : ' , I5 )
      ENDIF
C
C -- UPDATE CURRENT STACK LEVEL
C
      ILEVEL(IFLIND) = ILEVEL(IFLIND) - 1
C
      RETURN
C
C
      END
CODE FOR XSCSNM
      SUBROUTINE XSCSNM ( ITYPE , IADDR , CNAME )
C
C -- FORM STANDARD STRUCTURE NAME.
C
C -- THIS ROUTINE FORMS A UNIQUE STRUCTURE NAME BY WHICH THE STRUCTURE
C    BE IDENTIFIED LATER. THIS IS BASED ON THE TYPE AND THE ADDRESS OF
C    THE STRUCTURE
C
C -- THE NAME HAS THE FORM 'TYPENNN' WHERE 'TYPE' REPRESENTS THE TYPE,
C    E.G. 'SCRIPT' OR 'CASE', AND 'NNN' IS A CHARACTER REPRESENTATION
C    OF THE ADDRESS.
C
C
C      INPUT PARAMETERS :-
C            ITYPE       TYPE OF STRUCTURE ( IN RANGE 1 - 5 )
C            IADDR       ADDRESS
C
C      OUTPUT PARAMETER :-
C            CNAME       PASSED LENGTH CHARACTER VARIABLE IN WHICH THE
C                        GENERATED NAME IS STORED
C
C
C      LOCAL VARIABLES
C            CADDR       CHARACTER VARIABLE USED TO STORE CHARACTER FORM
C                        OF IADDR
C            CSTRUC      CHARACTER ARRAY HOLDING STRUCTURE NAMES
C
C
      CHARACTER*(*) CNAME
C
C
      INCLUDE 'PSCRPT.INC'
C
      PARAMETER ( NSTRUC = 5 )
      CHARACTER*(MAXLAB) CADDR
C
      CHARACTER*(MAXLAB) CSTRUC(NSTRUC)
C
C
      DATA CSTRUC / 'SCRIPT' , 'BLOCK' , 'LOOP' , 'IF' , 'CASE' /
C
C
C
C
C -- GET TYPE PART OF NAME AND TRIM SPACES
C
      CNAME = CSTRUC(ITYPE)
      ISTAT = KCCTRM ( 1 , CNAME , ISTART , IEND )
C
C -- GET ADDRESS PART OF NAME AND TRIM SPACES
C
      WRITE ( CADDR , '(I12)' ) IADDR
      ISTAT = KCCTRM ( 1 , CADDR , ISTBEG , ISTEND )
C
C -- ADD SECOND PART OF NAME TO FIRST
C
      CNAME(IEND+1:) = CADDR(ISTBEG:ISTEND)
C
      RETURN
      END
CODE FOR XSCSTU
      SUBROUTINE XSCSTU ( ITEM , IVALUE )
C
C -- UPDATE INFORMATION IN CURRENT STACK FRAME
C
C      INPUT PARAMETERS :-
C
C            ITEM        CODE INDICATING STACK ITEM TO BE UPDATED
C            IVALUE      NEW VALUE
C
C
      INCLUDE 'PSCSTI.INC'
      INCLUDE 'PSCSTK.INC'
      INCLUDE 'PSCMSG.INC'
C
C
      INCLUDE 'UFILE.INC'
C
      INCLUDE 'XSCSTK.INC'
C
      INCLUDE 'XUNITS.INC'
      INCLUDE 'XSSVAL.INC'
C
C
C
C -- CHECK REQUEST
C
      IF ( ITEM .LE. 0 ) GO TO 9910
      IF ( ITEM .GT. LSTACK ) GO TO 9910
C
C -- CHECK STACK LEVEL
C
      LEVEL = ILEVEL(IFLIND)
      IF ( LEVEL .LE. 0 ) GO TO 9920
C
C -- SET NEW VALUE
C
      ISTACK(ITEM,LEVEL) = IVALUE
      RETURN
C
C
9900  CONTINUE
      RETURN
9910  CONTINUE
      CALL XSCMSG ( MILLEG , MSTKIT , ' ' , 0 )
      GO TO 9900
9920  CONTINUE
      CALL XSCMSG ( MILLEG , MSTKLV , ' ' , 0 )
      GO TO 9900
C
C
      END

