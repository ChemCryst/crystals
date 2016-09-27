////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcController

////////////////////////////////////////////////////////////////////////

//   Filename:  CcController.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 15:02 Uhr

// $Log: not supported by cvs2svn $
// Revision 1.131  2013/06/12 11:31:36  rich
// Correct putenv for intel platform.
//
// Revision 1.130  2013/06/11 12:30:39  pascal
// Linux changes
//
// Revision 1.129  2013/01/18 15:13:41  rich
// Allow saving of files from scatter and histogram plots.
// Implement saving of files in Cameron on wxWidgets platform. (Saves PNG instead of WMF).
//
// Revision 1.128  2012/11/09 15:07:17  rich
// Remove debug print
//
// Revision 1.127  2012/09/12 15:06:51  rich
// Fix line on wx version.
//
// Revision 1.126  2012/09/12 13:29:33  rich
// Better SYSOPENFILE syntax:
// SYSOPENFILE [ 'wildcard' 'description' 'wildcard2' 'description' ]
// Add as many wildcard-description pairs to the list as required.
//
// Revision 1.125  2012/05/17 12:03:54  rich
// Special case http: links to ShellExecute.
//
// Revision 1.124  2012/05/14 15:27:52  rich
// Sort out use of unicode and non-unicode functions.
//
// Revision 1.123  2012/05/12 05:13:09  rich
// Fix MFC build.
//
// Revision 1.122  2012/05/12 04:58:14  rich
// Simplified 'spawn' options. Now only using ShellExectute funciton on Win32.
//
// Revision 1.121  2012/05/03 15:41:08  rich
// Mostly commented out debugging for future reference. Trying to track down flicker on dialog closure. May now be fixed...
//
// Revision 1.120  2012/03/26 11:15:31  rich
// Unicode support for GID version.
//
// Revision 1.119  2012/01/05 13:00:04  rich
// Fix breaking of lines when running diffin.exe in crystals window.
//
// Revision 1.118  2011/09/26 13:42:37  rich
// Fix spawn of external programs using % modifier (run in CRYSTALS I/O window).
//
// Revision 1.117  2011/05/17 14:46:38  rich
// strcpy is not part of std namespace
//
// Revision 1.116  2011/05/16 10:56:32  rich
// Added pane support to WX version. Added coloured bonds to model.
//
// Revision 1.115  2011/04/15 15:07:04  rich
// Different exit.
//
// Revision 1.114  2011/03/24 16:32:56  rich
// Exit more cleanly?
//
// Revision 1.113  2011/03/04 06:02:52  rich
// Fix RESTART of CRYSTALS thread on WX version. Some changes to defines to get correct function signature.
//
// Revision 1.112  2009/09/04 09:25:46  rich
// Added support for Show/Hide H from model toolbar
// Fixed atom picking after model update in extra model windows.
//
// Revision 1.111  2008/09/22 12:31:37  rich
// Upgrade GUI code to work with latest wxWindows 2.8.8
// Fix startup crash in OpenGL (cxmodel)
// Fix atom selection infinite recursion in cxmodlist
//
// Revision 1.110  2005/02/22 22:41:46  stefan
// 1. Removal of useless intermediat string
//
// Revision 1.109  2005/02/07 14:18:31  stefan
// 1. Replaced the idle timer with a sequance listener which puts a message on the event queue when the crystals thread sends something for the gui. This has been done for both the windows and the wx version.
//
// Revision 1.108  2005/02/02 15:29:41  stefan
// 1. Replaced the two deques which are used for comunicating between the two threads
// with CcSafeDeque which is a thread safe version. Removing the need for two of the mutexs used
// and the semaphore. This is now encapsulated withing the CcSafeDeque class.
//
// Revision 1.107  2005/01/23 10:20:24  rich
// Reinstate CVS log history for C++ files and header files. Recent changes
// are lost from the log, but not from the files!
//
// Revision 1.5  2005/01/13 17:56:20  rich
// Fix spawning of shell commands (copying data to an pointer into exisiting string was bad).
//
// Revision 1.4  2005/01/12 13:15:56  rich
// Fix storage and retrieval of font name and size on WXS platform.
// Get rid of warning messages about missing bitmaps and toolbar buttons on WXS version.
//
// Revision 1.3  2004/12/20 11:41:31  rich
// Added support for non-MFC windows version. (WXS)
//
// Revision 1.2  2004/12/17 10:28:06  rich
// Error message if CRYSDIR is not set, or is set to blanks.
//
// Revision 1.1.1.1  2004/12/13 11:16:17  rich
// New CRYSTALS repository
//
// Revision 1.106  2004/11/30 11:48:53  rich
// Fix in-place running of shell programs on Linux and Mac versions.
// Due to low-level IO library stuff, you should only run programs which
// either don't require terminal input (e.g. ls, convplat, shelxs) or
// programs that have been specially compiled so as not to buffer output to
// STDOUT. This will happen shortly for kccdin, rc93 etc...
//
// Revision 1.105  2004/11/19 10:56:03  rich
// Remove classes from extern C section - turned back into C. Fixed C.
// May still be problems spawning redirected processes in GUI, but
// other features work as before.
//
// Revision 1.104  2004/11/15 13:27:10  rich
// Allow for possibility of running spawned processes in the CRYSTALS window.
// For example, type: #spawn % crysdir:kccdin.exe to run within the GUI.
//
// Revision 1.103  2004/11/12 11:22:01  rich
// Tidied SPAWN code.
// Fixed bug where failing script could leave pointers to deleted windows
// in our modal window stack.
//
// Revision 1.102  2004/11/09 09:45:02  rich
// Removed some old stuff. Don't use displaylists on the Mac version.
//
// Revision 1.101  2004/11/08 16:48:36  stefan
// 1. Replaces some #ifdef (__WXGTK__) with #if defined(__WXGTK__) || defined(__WXMAC) to make the code compile correctly on the mac version.
//
// Revision 1.100  2004/10/08 09:01:16  rich
// Fix window being deleted from list bug.
//
// Revision 1.99  2004/10/06 13:57:26  rich
// Fixes for WXS version.
//
// Revision 1.98  2004/09/17 14:03:54  rich
// Better support for accessing text in Multiline edit control from scripts.
//
// Revision 1.97  2004/07/02 12:34:03  rich
// Fixed mis-parsing of short tokens. (eg. ^^CW on its own).
//
// Revision 1.96  2004/07/02 11:56:01  rich
// remove unused variables
//
// Revision 1.95  2004/07/02 11:38:45  rich
// Fix command line startup mode. Correct use of putenv under unix - the
// string passed in should not have its memory freed until the program
// closes. Store pointers in a list, and delete at the end.
//
// Revision 1.94  2004/06/29 15:15:29  rich
// Remove references to unused kTNoMoreToken. Protect against reading
// an empty list of tokens.
//
// Revision 1.93  2004/06/28 13:26:56  rich
// More Linux fixes, stl updates.
//
// Revision 1.92  2004/06/25 12:50:37  rich
//
// Removed Completing() series of functions and replaced with a
// simple semaphore. Also wait on empty queue using a semaphore -
// more efficient.
//
// Revision 1.91  2004/06/24 11:39:46  rich
// Removed unused variable.
//
// Revision 1.90  2004/06/24 09:12:00  rich
// Replaced home-made strings and lists with Standard
// Template Library versions.
//
// Revision 1.89  2004/05/19 15:37:55  rich
// Remove debugging output.
//
// Revision 1.88  2004/05/19 14:03:59  rich
// On Unix, use wxConfig routines to store 'user' data rather than the old
// winsizes.ini file. Winsizes.ini is now officially not used anywhere.
//
// Revision 1.87  2004/05/18 13:51:33  rich
// Fixed shut down of Fortran thread in Linux - but requires the use
// of exceptions. To exit properly the thread must return from the
// function that started it ie. CRYSTL(). This would require extensive
// modification of the Fortran to get from XFINAL() back to the top, but
// instead we can throw a C++ exception from XFINAL() and catch it in
// the routine that called CRYSTL(). Seems to work fine.
//
// Revision 1.86  2004/04/16 12:50:16  rich
// Fix compilation on Linux.
//
// Revision 1.85  2004/04/16 10:10:41  rich
// If chdir fails, then popup an error message for debugging purposes.
//
// Revision 1.84  2004/04/01 10:24:34  rich
// Don't delete mCrystalsThread object when the thread ends, otherwise
// the GUI thread can't query its exit status.
// This means that the GUI thread is now responsible for deleting this
// object when it discovers that it is dead.
// This should fix the problems in Manchester.
//
// Revision 1.83  2004/02/16 16:39:11  rich
// After waiting for a spawned application, print a message "Done" to indicate
// no longer waiting.
//
// Revision 1.82  2004/02/09 20:27:09  rich
// Correct use of chdir and putenv on WXS target platform.
// ----------------------------------------------------------------------
//
// Revision 1.81  2004/02/06 13:49:26  rich
// Some debugging messages when spawning programs.
//
// Revision 1.80  2003/12/04 09:53:53  rich
//
// Fix $ and SPAWN on Linux for "quoted" commands.
//
// Revision 1.79  2003/11/28 10:29:10  rich
// Replace min and max macros with CRMIN and CRMAX. These names are
// less likely to confuse gcc.
//
// Revision 1.78  2003/11/19 16:00:53  rich
// Remove the XInitThreads call - seems to cause occasional deadlocks.
// Change exit to _exit in guexec, so that if execvp call fails it
// doesn't kill the whole application.
//
// Revision 1.77  2003/11/19 15:18:50  rich
//
// Rewritten guexec for linux version to use system calls rather than
// stuff from the wxWindows library. The wxWindows library shouldn't
// be called from this, the CRYSTALS thread.
//
// Revision 1.76  2003/11/05 09:17:21  rich
// Use 'cerr' function from the 'std' namespace.
//
// Revision 1.75  2003/10/29 12:29:33  rich
// Add code to CcMenuItem to allow the menu name and command to
// be redefined 'on the fly' by CRYSTALS.
//
// Revision 1.74  2003/09/24 10:40:10  rich
// Remove obsolete keywords from default window spec when no
// guimenu.srt is found.
//
// Revision 1.73  2003/09/19 18:02:27  rich
// Add code to allow inclusion of subsiduary files from the guimenu.srt
// startup file. (Allows clear separation and structure of the GUI).
//
// Revision 1.72  2003/09/17 14:38:53  rich
// On fatal CRYSTALS error jump into the debugger.
//
// Revision 1.71  2003/09/12 14:13:17  rich
//
// WXversion: Protect acquisition of Thread_Alive mutex with a signal.
//
// Revision 1.70  2003/09/03 20:55:17  rich
// Fix elapse time functions under Linux.
//
// Revision 1.69  2003/08/14 18:18:12  rich
// Fix bug discovered in overnight build.
//
// Revision 1.68  2003/08/13 16:01:10  rich
// Find unix equiv of GetTickCount().
// Comment out registry related functions on Linux.
//
// Revision 1.67  2003/07/04 16:33:38  rich
// Fix recently introduced bug, which prevented CRYSTALS from restarting in
// new directories.
//
// Revision 1.66  2003/07/01 16:38:21  rich
// Three small changes. (1) Set flag to indicate CRYSTALS thread exit, and
// exit from the GUI thread accordingly. (2) Make GETKEY a special case for
// input queries. This allows the registry to be queried without losing
// synchronisation of the input queue. (3) In the debug output file "Script.log"
// prefix every line with the elapsed time in seconds since the program
// started. Useful for simple profiling info.
//
// Revision 1.65  2003/06/30 16:39:28  rich
// Set thread pointer to NULL before exiting CRYSTALS thread.
//
// Revision 1.64  2003/05/21 11:22:18  rich
// Log some comments as the CRYSTALS thread dies.
//
// Revision 1.63  2003/05/14 13:31:01  rich
// Diagnostic should go to log, not appear as an error.
//
// Revision 1.62  2003/05/12 11:13:20  rich
//
// RIC: Introduce a "batch" mode which can be set as an attribute of the main CRYSTALS
// window. This prevents modal error messages if CRYSTALS fails, the program
// just shuts down with a non-zero exit code. This is used for the
// overnight rebuilds on galena.xtl.
//
// Revision 1.61  2003/05/07 12:18:56  rich
//
// RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
// using only free compilers and libraries. Hurrah, but it isn't very stable
// yet (CRYSTALS, not the compilers...)
//
// Revision 1.60  2003/03/27 14:57:54  rich
// Added GUI command "GETREG string1 string2" to fetch string values from
// the registry. Will be used to find latest Mogul location. string1 is the
// key name in either CURRENT_USER (default) or LOCAL_MACHINE (falls back
// if not found in C_U). String 2 is the value name. The value data is returned
// to the CRYSTALS input buffer.
//
// Revision 1.59  2003/03/26 10:21:56  rich
// Removed use of \windows\wincrys.ini and \wincrys\script\winsizes.ini
// as places to store and retrieve application information. All information is
// now stored in the registry. This will help people on NT and XP who have
// no admin privileges.
//
// CAREFUL: Crystals should still work without registry info, provided that
// CRYSDIR and USECRYSDIR environment variables are set (they should be already),
// but look out for problems.
//
// Revision 1.58  2003/03/12 17:59:48  rich
// Fix to yesterday's mods to SAFESET, it wasn't pulling new tokens from the queue, so
// was looping infinitely in some situations.
//
// Revision 1.57  2003/03/12 13:38:42  rich
// WHen text output is redirected to a new window, e.g. when Cameron is running,
// it has traditionally been echoed in the base text output window. I think
// this is a bit messy, and now the code is more stable, unecessary. This
// facility has been COMMENTED OUT.
//
// Revision 1.56  2003/03/11 15:43:56  rich
// Avoid printing uneccessary warning in SAFESET code.
//
// Revision 1.55  2003/02/25 15:34:29  rich
// For lines passed up from CRYSTALS (^^lines), allow "" and !!
// and <> to be delimiter pairs aswell as the trad ''.
//
// Revision 1.54  2003/02/20 14:06:21  rich
// Don't crash if initial window fails to open, just stop.
//
// Revision 1.53  2003/01/16 11:44:14  rich
// New "SAFESET [ objectname instructions ]" syntax introduced. If objectname
// doesn't exist, it ignores all the tokens between the square brackets, without
// raising an error. Can be used for updating GUI objects that don't have to
// be there.
//
// Revision 1.52  2003/01/14 10:27:18  rich
// Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
// Revision 1.51  2002/11/24 13:33:05  rich
// (1) Fix serious bug that erased some keys during winsizes.ini writing.
//
// (2) Preliminary support for using USERPROFILE directory to store
// winsizes.ini.
//
// Revision 1.50  2002/07/23 15:49:42  richard
// Small rarely manifested bugette discovered in queue locking behaviour. Now
// fixed. (I said max, I meant min).
//
// Revision 1.49  2002/07/19 08:08:17  richard
// Remove backwards incompatibilty of new std C++ library.
//
// Revision 1.48  2002/07/18 16:57:52  richard
// Upgrade to use standard c++ library, rather than old C libraries.
//
// Revision 1.47  2002/07/15 12:19:13  richard
// Reorder headers to improve ease of linking.
// Update program to use new standard C++ io libraries.
// Update to use new version of MFC (5.0 with .NET.)
//
// Revision 1.46  2002/07/03 14:23:21  richard
// Replace as many old-style stream class header references with new style
// e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
// Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
// stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
// Removed some bits from Steve's Plot classes that were generating (harmless) compiler
// warning messages.
//
// Revision 1.45  2002/03/18 15:31:54  richard
// Removed setting of MT_DIR no longer present.
//
// Revision 1.44  2002/03/16 18:08:22  richard
// Removed old CrGraph class (now obsolete given Steven's work).
// Removed remains of "quickdata" interface (now obsolete, replaced by FASTPOLY etc.)
//
// Revision 1.43  2002/03/13 12:30:25  richard
// Speed up search for ^^ symbols.
// Introduce new ^^ command: ^^CW - like ^^CR it causes execution of anything
// built up in the current list of commands, but it also forces the CRYSTALS thread
// to wait until the execution is complete.
// Added function to OpenDirDialog to get the last structure directory used out
// of the ini file.
//
// Revision 1.42  2002/03/12 17:46:50  ckp2
// Special case spawing of html files containing #'s. Trim back to before #, find
// associated application (iexplore, netscape, etc.), and then launch with original
// filename as argument. Works a treat.
//
// Revision 1.41  2002/02/27 20:17:54  ckp2
// RIC: Increase input line length to 256 chars max, but also trim line back to
// last non-space.
// RIC: Improve default set of GUI objects created when guimenu.srt is not found.
// The program should now has an input line in these cases.
//
// Revision 1.40  2002/02/20 14:44:04  ckp2
// Modified guexec to support quotes around the first thing on the line.
//
// Revision 1.39  2001/11/16 15:11:02  ckp2
// Allow the SET command to find CcPlotData objects - reqd for switching between
// PlotDatas when writing two graphs at once (e.g. <|Fo-Fc|> vs Fo and <Fo>-<Fc> vs Fo.)
//
// Revision 1.38  2001/11/15 10:44:54  ckp2
// Reset default paths for Open and Save file dialogs to the current working
// directory every time.
//
// Revision 1.37  2001/10/10 12:44:48  ckp2
// The PLOT classes!
//
// Revision 1.36  2001/09/19 09:02:46  ckp2
// Fix problem retreiving keys from winsizes.ini when the key also happened to
// be the start of another key, e.g. "_VIS" and "_VISRSZ". (i.e. look for the space).
//
// Revision 1.35  2001/09/11 09:31:27  ckp2
// Improved locking of CRYSTALS queue when ^^?? querying GUI for info.
//
// Revision 1.34  2001/08/14 10:17:58  ckp2
// The new facility for autoclosing windows when scripts crash out needs to
// make sure the deleted window is not left as the mCurrentWindow.
//
// Revision 1.33  2001/07/16 07:20:41  ckp2
// Much cleaner thread sync.
//
// Revision 1.31  2001/07/03 13:24:27  ckp2
// Fixed race condition in queue critical sections. CRYSTALS now waits (up to 1 second)
// to be signalled that something has been added to the queue instead of looping frantically.
//
// Revision 1.30  2001/06/18 12:27:31  richard
// Include errno.h for the linux version.
//
// Revision 1.29  2001/06/17 15:30:06  richard
// ScriptsExited function loops through window list and closes any MODAL windows
// without the STAYOPEN attribute. (Prevents that problem where scripts crash
// and leave a window open blocking the input.)
//
// Revision 1.28  2001/03/27 15:14:58  richard
// Added a timer to the main window that is activated as the main window is
// created.
// The timer fires every half a second and causes any messages in the
// CRYSTALS message queue to be processed. This is not the main way that messages
// are found and processed, but sometimes the program just seemed to freeze and
// would stay that way until you moved the mouse. This should (and in fact, does
// seem to) remedy that problem.
// Good good good.
//
// Revision 1.27  2001/03/23 11:35:07  richard
// Don't set mCurrentWindow pointer if window fails to be created.
//
// Revision 1.26  2001/03/21 16:58:43  richard
// If ShellExectue fails to launch a program of file, then have a go with the
// old spawnvp method instead. As a knock on effect this fixes the Cameron PRINT command
// and the scripts FILEDELETE operator.
//
// Revision 1.25  2001/03/08 16:44:02  richard
// General changes - replaced common functions in all GUI classes by macros.
// Generally tidied up, added logs to top of all source files.
//
// Revision 1.24  2001/03/08 14:57:19  richard
// Moved all CXAPP and CRAPP functions into this class, to try to make the
// whole thing more understandable. This one class has one instance, and it
// holds all the information about the windows which are open. It also recieves
// the commands from CRYSTALS and messages from the GUI.
// Also some new classes for updating the toolbar, and buttons, and windows based on the old ENABLEIF, DISABLEIF status flags.
// Layout code majorly overhauled.
//
// Revision 1.23  2001/01/25 16:49:48  richard
// Tidied error messages. Introduced debug indent to show structure of
// windows as the are created and shown.
// Remove old quickdata method and static object.
// Rename RESTART command FILE attribute to NEWFILE to prevent clash
// with bitmap FILE attribute.
//
// Revision 1.22  2001/01/18 12:15:56  richard
// Fix command history. Caret only goes to end for AddText calls to
// EDITBOX, stays at begining for SetText calls.
// Command history no longer records empty lines (hooray).
//
// Revision 1.21  2001/01/16 15:34:54  richard
// wxWindows support.
// Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
// checked out in conjunction with changes to \bin\
//
// Revision 1.20  2000/12/13 18:52:01  richard
// Linux support. Optimise instruction parsing (a bit) for a faster GUI.
//
// Revision 1.19  2000/11/03 10:49:29  csduser
// RIC: New bitmap control
//
// Revision 1.18  2000/09/20 12:50:36  ckp2
// Support for new TEXTOUT control.
//
// Revision 1.17  2000/07/04 14:41:21  ckp2
// Gui changes since last year.
// Mainly chart handling for multiple charts in one window.
// Some Cx files only changed to split long lines to make inclusion
// into "the thesis" more automatic.
// New GUIMENU.SSR has more "right-click" options and swapped panes for model
// and text output.
//
// Revision 1.16  1999/07/30 20:17:59  richard
// RIC: Added Focus instruction to give the specified window or object
// the users input focus.
// RIC: Added FontIncrease instruction for changing the font size. Follow
// with YES to increase, or NO to decrease the current font size in the
// current output window.
//
// Revision 1.15  1999/07/02 17:59:10  richard
// RIC: Added a boolean m_Wait which is true while CRYSTALS is off processing
// things. It isn't actually used by anything though.
//
// Revision 1.14  1999/06/23 19:51:44  dosuser
// RIC: Added code to postmessage on adding stuff to the interface command
// queue. Didn't work very well, so I commented it out again.
// RIC: No need to use CcController::theController pointer from within
// the CcController class!
// RIC: Checks for ^^ in Tokenize and ^^?? in AddInterfaceCommand have
// been revised to only check the first 6 characters rather than the
// whole string (This allows for accidental extra spaces, while not going
// over the top.)
//
// Revision 1.13  1999/06/22 12:55:42  dosuser
// RIC: Added GetKeyValue and SetKeyValue to ParseInput function + supporting
// subroutines. They allow a key (single word) to be stored in a global file
// followed by a value (any text). This is used to save window size and
// position, but can also be used by for example TIPS.SCP to remember whether
// the user really wants to see tips at startup.
// RIC: SetProgressText changed slightly. It now calls switch text in
// the ProgressBar class. The progress bar remembers what it said before
// the call to SwitchText and pops it back up when you call SwitchText with
// a NULL pointer.
//
// Revision 1.12  1999/06/13 16:31:57  dosuser
// RIC: Added GetInputPlace(), SetInputPlace() and RemoveInputPlace()
// for dynamically changing the Input Window. Check for TEXTINPUT on
// SET command and look up the relevant object using GetInputPlace().
// Added RedirectInput token, to change the input object. Probably
// not needed though, as the token INPUT on an EDITBOX command will
// do the trick.
// Changed char * to string for AddCrystalsCommand and AddInterfaceCommand.
// No longer necessary to check for _MAINTEXTINPUT in AddCrystalsCommand,
// since the CrEditBox now knows if it is the input source and will send
// text and clear itself as appropriate.
// All references to mInputWindow changed to GetInputPlace().
// RemoveTextOutputPlace() and RemoveProgressOutputPlace() changed so
// that they search for the object being destroyed and remove it from
// the appropriate list. This is better then popping it off the end
// of the list as it allows the text to be redirected back to the
// main window before the new window is destroyed, without leaking
// memory. See #SCRIPT XHELP1 and 2 for an example of this.
// OutputToScreen function never used, removed.
// Added StoreSize routine to store a key and a rectangle in the
// winsizes.ini file in the script directory.
// Added GetSize routine to get a rectangle from the winsizes.ini
// file given a key.
// CcController specific tokens moved into the header file.
//
// Revision 1.11  1999/06/07 19:51:00  dosuser
// RIC: The ChangeDir function that used to be a member function of CxApp,
// is now a global function.
//
// Revision 1.10  1999/06/06 19:43:48  dosuser
// RIC: Added new method of adding chart objects to the chartdoc. Objects
// can be added by direct function calls rather than by passing ^^CH
// commands to the interface. Another function, complete(), accessed from
// the Fortran by calling GUWAIT() blocks until all ^^ commands have
// been processed. This allows mixing of ^^CH commands with direct function
// calls provided GUWAIT() is called after ^^CH commands. Cameron updates
// pictures much much faster.
//
// Revision 1.9  1999/06/03 16:53:15  dosuser
// RIC: Fixed an error that was lopping the last character off
// any Interface command before it was processed.
//
// Revision 1.8  1999/06/03 14:35:49  dosuser
// RIC: Changed ParseLine and ParseInput to use strings rather than
// char*'s. Same for ProcessOutput. Changed TRUE and FALSE to
// true and false.
//
// Revision 1.7  1999/05/28 17:52:00  dosuser
// RIC: Attempted world record for most number of files
// checked in at once. Most changes are to do with adding
// support for a LINUX windows library. Nothing has broken
// in the windows version. As far as I can see.
//
// Revision 1.6  1999/05/13 17:46:00  dosuser
// RIC: Fixed argument passing to endthread( long )
//      Added SysRestart token and a member variable to store the
//      path of the directory to restart in.
//      Moved Mutex to after the thread status check otherwise it is never
//      released when the function returns.
//
// Revision 1.5  1999/05/11 16:15:10  dosuser
// RIC: Added token SYSGETDIR and supporting functions for getting a
//      directory from the user via a common dialog.
//
// Revision 1.4  1999/04/30 16:56:49  dosuser
// RIC: Added SetProgressText(string Text) to allow the model window to
//      display atom names in the current progress/status bar.
//

#include    "crystalsinterface.h"

#ifdef CRY_USEWX
  #include <wx/app.h>
#else
  #include <tchar.h>
#endif

#include    <string>
#include    <vector>
#include    <set>
#include    <iostream>
#include    <iomanip>
#include    <cstdlib>
#include    <sstream>
#include    <deque>
#include    <algorithm>
using namespace std;

#include    "crconstants.h"
#include    "crgrid.h"
#include    "cclock.h"
#include    "cccontroller.h"
#include    "crwindow.h"
#include    "cxgrid.h" //to delete its static font pointer.
#include    "crbutton.h"
#include    "creditbox.h"
#include    "cccrystcommandlistener.h"

// Get all the kT and kS defines for now: TODO - move all into crconstants.

#include    "crwindow.h"
#include    "crmenu.h"
#ifdef CRY_OSMAC
  #include <wx/glcanvas.h>
#else
  #include    <GL/glu.h>
#endif
#include    "crmodel.h"
#include    "crchart.h"
#include    "crbutton.h"
#include    "ccstatus.h"
#include    "cricon.h"
#include    "crbitmap.h"
#include    "crlistbox.h"
#include    "crtab.h"
#include    "crresizebar.h"
#include    "crstretch.h"
#include    "crlistctrl.h"
#include    "cxeditbox.h"
#include    "crmultiedit.h"
#include    "crtextout.h"
#include    "ccplotdata.h"
#include    "ccchartdoc.h"
#include    "ccmodeldoc.h"
#include    "ccchartobject.h"
#include    "crprogress.h"
#include    "ccmenuitem.h"
#include    "crtoolbar.h"
#include    "cxweb.h"

#ifdef __INW__
#include "CrashRpt.h"
#endif

#ifdef CRY_USEMFC
  #include <tchar.h>
  #include <afxwin.h>
  #include <shlobj.h> // For the SHBrowse stuff.
  #include <direct.h> // For the _chdir function.
  #include <process.h>
  CWinThread * CcController::mCrystalsThread = nil;
  CWinThread * CcController::mGUIThread = nil;
  CFont* CcController::mp_font = nil;
  CFont* CcController::mp_inputfont = nil;
#else
  #include <wx/fontdlg.h>
  #include <wx/cmndata.h>
  #include <wx/config.h>
  #include <wx/filedlg.h>
  #include <wx/dirdlg.h>
  #include <wx/mimetype.h>
  #include <wx/utils.h>
  CcThread * CcController::mCrystalsThread = nil;
  #include <wx/settings.h>
  wxFont* CcController::mp_inputfont = nil;
  #include <wx/msgdlg.h>


  
  #ifdef CRY_OSWIN32
    #include <stdio.h>
    #include <shlobj.h> // For the SHBrowse stuff.
    #include <direct.h> // For the _chdir function.
    #include <process.h>
  #else
    #include <errno.h>
    #include <sys/time.h>
    #include "ccthread.h"
    #include <wx/thread.h>
    #include <sys/wait.h>
    #include <fcntl.h>
    #include <unistd.h>
  #endif
  
#endif

#include "fortran.h"


//#include <RDGeneral/Invariant.h>
//#include <GraphMol/RDKitBase.h>
//#include <GraphMol/SmilesParse/SmilesParse.h>
//#include <GraphMol/SmilesParse/SmilesWrite.h>
//#include <GraphMol/Substruct/SubstructMatch.h>
//#include <GraphMol/Depictor/RDDepictor.h>
//#include <GraphMol/FileParsers/FileParsers.h>

                   
#define BZERO(a) memset(a,0,sizeof(a)) //easier -- shortcut

bool bRedir = false;

static CcLock m_Crystals_Thread_Alive(true);

static CcLock m_Complete_Signal(false);
static CcLock m_wait_for_thread_start(false);

static list<char*> stringlist;
static set<string> stringset;

CcController* CcController::theController = nil;
int CcController::debugIndent = 0;

CcController::CcController( const string & directory, const string & dscfile )
{
#ifdef CRY_USEMFC
	CcCrystalsCommandListener tInterfaceCommandListener(AfxGetApp(), WM_CRYSTALS_COMMAND);
#else
	CcCrystalsCommandListener tInterfaceCommandListener(wxTheApp, ccEVT_COMMAND_ADDED);
#endif

	mInterfaceCommandDeq.addAddListener(tInterfaceCommandListener);

#ifdef CRY_OSWIN32
    m_start_ticks = GetTickCount();
#else
    struct timeval time;
    struct timezone tz;
    gettimeofday(&time,&tz);
    m_start_ticks = (time.tv_sec%10000)*1000 + time.tv_usec/1000;
#endif
//Things
    mErrorLog = nil;
    mThisThreadisDead = false;
    m_restart = false;
    mCrystalsThread = nil;
    m_AllowThreadKill = true;
    m_BatchMode = false;
    m_ExitCode = 0;
//Current window pointers. Used to direct streams of input to the correct places (if for some reason the stream has been interuppted.)
    mCurrentWindow = nil;   //The current window. GetValue will search in this window first.
//Token list pointers.
//    mCurTokenList = nil;    //The current token list, could be for charts, model, windows etc.
//    mTempTokenList = nil;   //Stores the current token list when 'quick' commands are jumping the input queue.
// Initialize the static pointers in classes for accessing this controller object.
    CrGUIElement::mControllerPtr = this;
    CcController::theController = this;
    CcController::debugIndent = 0;

#ifdef DEPRECATEDCRY_USEWX
	CxWeb::InitXULRunner();
#endif

#ifdef CRY_USEMFC
      mGUIThread = AfxGetThread();
#endif

    if ( directory.length() )
    {
      string dirtemp = directory;
      if ( dirtemp[0] == '\"' ) dirtemp = dirtemp.substr(1,dirtemp.length()-1);
      ChangeDir( dirtemp );
    }

// Setup initial windows
    CrGUIElement * theElement = nil;

// Must call Tokenize directly when working in this thread. (Not AddInterfaceCommand,
// as this delays window creation until OnIdle is called).
// This sets up the command line window, and the main text output window.
// Source an external menu definition file - "GUIMENU.SRT"

    FILE * file;
//    char charline[256];
    char * ecrys = getenv("CRYSDIR");
    if ( ecrys == 0 )
    {
      std::cerr << "You must set CRYSDIR before running crystals.\n";
      return;
    }
 
    string crysdir ( ecrys );
    if ( crysdir.length() == 0 )
    {
      std::cerr << "Set CRYSDIR to the location of crystals before running crystals.\n";
      return;
    }

    int nEnv = EnvVarCount( crysdir );
    int i = 0;
    bool noLuck = true;

    while ( noLuck )
    {
      string dir = EnvVarExtract( crysdir, i );
      i++;
      string buffer = dir + "guimenu.srt" ;

      if( (file = fopen( buffer.c_str(), "r" ) ) ) //Assignment witin conditional - OK
      {
        ReadStartUp(file,crysdir);
        noLuck = false;
      }
      else
      {
        if ( i >= nEnv )
        {
          //Last resort, there is no external file. Default window defined here:
          Tokenize("^^WI WINDOW _MAIN 'Crystals' MODAL STAYOPEN SIZE CANCEL='_MAIN CLOSE' GRID ");
          Tokenize("^^WI _MAINGRID NROWS=3 NCOLS=1 { @ 1,1 GRID _SUBGRID NROWS=1 NCOLS=3 ");
          Tokenize("^^WI { @ 1,2 TEXTOUT _MAINTEXTOUTPUT '(C)1999 CCL, Oxford.' NCOLS=95 ");
          Tokenize("^^WI NROWS=20 } @ 3,1 PROGRESS ");
          Tokenize("^^WI _MAINPROGRESS 'guimenu.srt NOT FOUND' CHARS=20 @ 2,1 EDITBOX ");
          Tokenize("^^WI _MAINTEXTINPUT ' ' NCOLS=45 LIMIT=80 SENDONRETURN=YES INPUT } SHOW ");
          Tokenize("^^CR  ");
          LOGSTAT ( "Back from tokenizing all \n") ;
          noLuck = false;
        }
      }
    }

// Find the main window and let the framework know what it is. (Without a
// main window, the program will be terminated, as the framework assumes it has closed)
    theElement = FindObject( "_MAIN" );
    if ( theElement == nil )
    {
      LOGERR ("Failed to get main window");
#ifdef CRY_USEMFC
      if ( !m_BatchMode ) MessageBox(NULL,"Failed to create and find main Window","CcController",MB_OK);
      ASSERT(0);
      return;
#endif
    }
    ((CrWindow*)theElement)->SetTimer(); //Start timer events - a sort of
                                         //pacemaker for the GUI to stop
                                         //it freezing up so often ;)

#ifdef CRY_USEMFC
    AfxGetApp()->m_pMainWnd = (CWnd*)(theElement->GetWidget());
#else
    wxGetApp().SetTopWindow((wxWindow*)(theElement->GetWidget()));
#endif
    LOGSTAT ( "Main window found\n") ;

//Find the output window. Needed by CcController so that text can be sent to it.
    CrTextOut* outputWindow;
    outputWindow = (CrTextOut*) FindObject( "_MAINTEXTOUTPUT" );
    if ( outputWindow == nil )
    {
      LOGERR("Failed to get main text output");
#ifdef CRY_USEMFC
      if ( !m_BatchMode ) MessageBox(NULL,"Failed to create main text output Window","CcController",MB_OK);
      ASSERT(0);
      return;
#endif
    }

    SetTextOutputPlace(outputWindow);
    LOGSTAT ( "Text Output window found\n") ;

//Find the progress window. Needed by CcController so that messages can be sent to it.
    CrProgress* progressWindow;
    progressWindow = (CrProgress*)FindObject( "_MAINPROGRESS" );
    if ( progressWindow == nil )
    {
      LOGERR("Failed to get progress window");
#ifdef CRY_USEMFC
      if ( !m_BatchMode ) MessageBox(NULL,"Failed to create progress Window","CcController",MB_OK);
      ASSERT(0);
      return;
#endif
    }

    SetProgressOutputPlace(progressWindow);
    LOGSTAT ( "Progress/status window found\n") ;

// If specified on the command line, set the CRDSC environment variable,
// regardless of whether it is already set...
//                 wxMessageBox("Debug","ing",wxOK|wxICON_HAND|wxCENTRE);
    LOGSTAT ( "Setting CRDSC to " + dscfile + "\n") ;
    if ( dscfile.length() > 1 )
    {
      string dsctemp = "CRDSC=" + dscfile;
      string::size_type qp = dsctemp.find_last_of('\"');
      if ( qp != string::npos ) dsctemp.erase(qp,1);
#ifdef CRY_OSWIN32
      _putenv( dsctemp.c_str() );
#else
      char * env = new char[dsctemp.size()+1];
      strcpy(env, dsctemp.c_str());
      stringlist.push_back(env);
      putenv( env );
#endif
//For info, put DSC name in the title bar.
      Tokenize("^^CO SET _MAIN TEXT 'Crystals - " + dscfile + "'");
    }


/****

    //RDKit test

 RDKit::RWMol *mol=new RDKit::RWMol();

 // add atoms and bonds:
  mol->addAtom(new RDKit::Atom(6)); // atom 0
  mol->addAtom(new RDKit::Atom(6)); // atom 1
  mol->addAtom(new RDKit::Atom(6)); // atom 2
  mol->addAtom(new RDKit::Atom(6)); // atom 3
  mol->addBond(0,1,RDKit::Bond::SINGLE); // bond 0
  mol->addBond(1,2,RDKit::Bond::DOUBLE); // bond 1
  mol->addBond(2,3,RDKit::Bond::SINGLE); // bond 2
 // setup the stereochem:
  mol->getBondWithIdx(0)->setBondDir(RDKit::Bond::ENDUPRIGHT);
  mol->getBondWithIdx(2)->setBondDir(RDKit::Bond::ENDDOWNRIGHT);

 // do the chemistry perception:
  RDKit::MolOps::sanitizeMol(*mol);

 // Get the canonical SMILES, include stereochemistry:
  std::string smiles;
  smiles = MolToSmiles(*(static_cast<RDKit::ROMol *>(mol)),true);
  
//  wxMessageBox(smiles,"OK", wxOK|wxICON_HAND|wxCENTRE);

****/


// If the CRDSC variable is set, leave it's value the same.
// Otherwise, set it to the default value of CRFILEV2.DSC
    char* envv;

#ifdef CRY_USEMFC
    envv = getenv( (LPCTSTR) "CRDSC" );
#else
    envv = getenv( "CRDSC" );
#endif

    if ( envv == NULL )
    {
#ifdef CRY_OSWIN32
       _putenv( "CRDSC=crfilev2.dsc" );
#else
//       _setenv("CRDSC", "crfilev2.dsc", 1);
       string p = "CRDSC=crfilev2.dsc";
       char * env = new char[p.size()+1];
       strcpy(env, p.c_str());
       stringlist.push_back(env);
       putenv( env );
       
//       envv = getenv( "CRDSC" );
#endif
       Tokenize("^^CO SET _MAIN TEXT 'Crystals - crfilev2.dsc'");
    }

    LOGSTAT( "Starting Crystals Thread" );
    
    StartCrystalsThread();
    
//    wxMessageBox("Debug","Started CRYSTALS");


    LOGSTAT ( "Crystals thread started.\n") ;
}


void CcController::ReadStartUp( FILE * file, string & crysdir )
{
  char charline[256];
  int nEnv = EnvVarCount( crysdir );

  LOGSTAT("Entering ReadStartUp");

  while ( ! feof( file ) )
  {
    if ( fgets( charline, 256, file ) )
    {
      string inputline = charline;
      if ( inputline[0] == '!' )
      {
        inputline = inputline.substr(1,inputline.length()-1); // Remove that shriek.
        int newl = inputline.find("\n");
        if ( newl ) inputline = inputline.substr(0,newl);
        FILE * newfile;
//Remove trailing spaces:
        string::size_type strim = inputline.find_last_not_of(" ");
        if ( strim != string::npos )
            inputline = inputline.substr(0,strim+1);
//Remove leading spaces:
        strim = inputline.find_first_not_of(" ");
        if ( strim != string::npos )
            inputline = inputline.substr(strim,inputline.length()-strim);
        LOGSTAT("Trimmed: "+inputline);
        int i = 0;
        bool noLuck = true;
        while ( noLuck && i < nEnv )
        {
          string dir = EnvVarExtract( crysdir, i++ );
          string buffer = dir + inputline ;
          LOGSTAT("Trying: "+buffer);
          if( (newfile = fopen( buffer.c_str(), "r" ) ) ) //Assignment witin conditional - OK
          {
            LOGSTAT("Success, reading file");
            ReadStartUp( newfile, crysdir );
            noLuck = false;
          }
          else
          {
            LOGSTAT("Failed.");
          }
        }
      }
      else if ( ! (inputline[0]=='%'))  // Line is not a comment
      {
        Tokenize(inputline);
      }
    }
  }
  fclose( file );
}

CcController::~CcController()       //The destructor. Delete all the heap objects.
{
    int i = 0;
    ostringstream aaarg;
	    list<CcModelDoc*>::iterator moddoc;
    while( ! CcModelDoc::sm_ModelDocList.empty() )
    {
        i++;
        moddoc = CcModelDoc::sm_ModelDocList.begin();    // Get first item
        delete *moddoc;              //It will remove itself from the list
    }

    aaarg << i;

    LOGSTAT ( "Deleted " + aaarg.str() + " CcModelDocs from the stack." );

    i = 0;
    list<CcChartDoc*>::iterator chartdoc;
    while ( ! CcChartDoc::sm_ChartDocList.empty() )
    {
        i++;
        chartdoc = CcChartDoc::sm_ChartDocList.begin();  // Get first item
        delete *chartdoc;            //It will remove itself from the list
    }        

    aaarg.str(""); 
    aaarg << i;

    LOGSTAT ( "Deleted " + aaarg.str() + " CcChartDocs from the stack." );

    i = 0;
    list<CcPlotData*>::iterator plotdata;
    while ( ! CcPlotData::sm_PlotList.empty() )
    {
        i++;
        plotdata = CcPlotData::sm_PlotList.begin();  // Get first item
        delete *plotdata;            //It will remove itself from the list
    }        

    aaarg.str(""); 
    aaarg << i;

    LOGSTAT ( "Deleted " + aaarg.str() + " CcPlotDatas from the stack." );

    list<CrWindow*>::iterator mw;
    for ( mw = mWindowList.begin(); mw != mWindowList.end(); mw++ )
        delete *mw;

    mWindowList.clear();
    mQuickTokenList.clear();
    mWindowTokenList.clear();
    mPlotTokenList.clear();
    mChartTokenList.clear();
    mModelTokenList.clear();
    mStatusTokenList.clear();


#ifdef CRY_USEMFC
      delete (CcController::mp_font);
      delete (CcController::mp_inputfont);
#endif

    list<char*>::iterator s = stringlist.begin();
    while ( s != stringlist.end() )
    {
        delete *s;
        s++;
    }


// If the thread isn't dead yet, then kill it.
    if( mCrystalsThread && m_Crystals_Thread_Alive.IsLocked() )
		 delete mCrystalsThread;

}


bool CcController::ParseInput( deque<string> & tokenList )
{
    CcController::debugIndent = 0;

    CcParse retVal(false, false, false);
    int infiniteLoopCheck = 0;
    int infiniteLoopCheck2 = -999999;

    while (! tokenList.empty()) //don't return until the list is empty
    {
        infiniteLoopCheck = tokenList.size();
        if(infiniteLoopCheck == infiniteLoopCheck2) //if the list size has remained the same during one iteration of this loop...
        {
            LOGWARN("CcController::ParseInput:infiniteLoopCheck Getting nowhere with this token: " + tokenList.front());
            tokenList.pop_front();
            if ( tokenList.empty() ) break;
        }
        infiniteLoopCheck2 = infiniteLoopCheck;
        bool safeSet = false;

        switch ( CcController::GetDescriptor( tokenList.front(), kInstructionClass ) )
        {
            case kTCreateWindow:
            {
                LOGSTAT("CcController: Creating window");
                CrWindow * wPtr = new CrWindow();
                if ( wPtr != nil )
                {
                    tokenList.pop_front(); //remove token.
                    retVal = wPtr->ParseInput( tokenList );
                    if ( retVal.OK() )
                    {
                        LOGSTAT("CcController: Adding window to list: " + wPtr->mName );
                        mWindowList.push_back( wPtr );
                        mCurrentWindow = wPtr;
                    }
                    else
                    {
                        LOGERR("CcController: Failed to create window: " + wPtr->mName );
                        delete wPtr;
                    }
                }
                break;
            }
            case kTDisposeWindow:
            {
                tokenList.pop_front();
                LOGSTAT("CcController: Disposing window " + tokenList.front());
                CrWindow* mWindowToClose = (CrWindow*)FindObject(tokenList.front()); //Find window by name.
                tokenList.pop_front();
                ostringstream strstrm;
                strstrm << (uintptr_t) mWindowToClose;
                LOGSTAT("CcController: Found window " + strstrm.str() );
                mWindowList.remove(mWindowToClose);

//                if ( mWindowList.size() )
//                        mWindowList.back()->CrFocus();

                delete mWindowToClose;
                if ( mWindowList.size() )
                    mCurrentWindow = mWindowList.back();
                else
                    mCurrentWindow = nil;
                break;
            }
            case kTGetValue:
            {
                LOGSTAT("CcController: Getting Value");
                // remove that token
                tokenList.pop_front();

                CrGUIElement * theElement;
                if ( mCurrentWindow )
                {
                    // Look for the item in current window first.
                     theElement = mCurrentWindow->FindObject( tokenList.front() );
                }

                if ( theElement == nil )
                {
                    // Look for the element everywhere.
                    theElement = FindObject ( tokenList.front() );
                }
                
                
                if ( theElement != nil )
                {
                    theElement->GetValue();
                }
                else
                {
                    SendCommand("FALSE",true); //This can be used to check if an object exists.
                    LOGWARN( "CcController:ParseInput:GetValue couldn't find object with name '" + tokenList.front() + "'");
                }
                tokenList.pop_front();

                break;

            }
            case kTCloseGroup:
            {
                tokenList.pop_front(); // ]
                break;
            }
            case kTSafeSet:
            {
                safeSet = true;
                tokenList.pop_front(); // SAFESET
                if ( CcController::GetDescriptor( tokenList.front(), kInstructionClass ) != kTOpenGroup )
                {
                    LOGWARN( "CcController:ParseInput:SAFESET must be followed by opening and closing []");
                    break;
                }
                //Continue into kTSet code.
            }
            case kTSet:
            {
             // remove that token
                tokenList.pop_front();

                string name = string(tokenList.front());  // Get the name of the object
                tokenList.pop_front();
                LOGSTAT("CcController: Setting Value of " + name);
                CrGUIElement* theElement = nil;

                if (name == "TEXTOUTPUT")
                {
                    theElement = GetTextOutputPlace();
                    theElement->ParseInput( tokenList );
                }
                else if (name == "PROGOUTPUT")
                {
                    theElement = GetProgressOutputPlace();
                    if ( theElement ) theElement->ParseInput( tokenList );
                }
                else if (name == "TEXTINPUT")
                {
                    theElement = GetInputPlace();
                    theElement->ParseInput( tokenList );
                }
                else
                {
                    // Look for the item
                    theElement = FindObject( name );
                    if(theElement)
                    {
                        theElement->ParseInput( tokenList );
                        break;
                    }

                    list<CcChartDoc*>::iterator doc
                          =  find( CcChartDoc::sm_ChartDocList.begin(),
                                   CcChartDoc::sm_ChartDocList.end(), name );
   
                    if ( doc != CcChartDoc::sm_ChartDocList.end() )
                    {
                        (*doc)->ParseInput( tokenList );
                        break;
                    }

                    CcMenuItem * theMenuItem = nil;

                    theMenuItem = CrMenu::FindMenuItem ( name );
                    if ( theMenuItem )
                    {
                        theMenuItem->ParseInput( tokenList );
                        break;
                    }

                    list<CcPlotData*>::reverse_iterator rpd = CcPlotData::sm_PlotList.rbegin();
//This loop finds the LAST item with a given name in the plotlist.
                    for ( ; rpd != CcPlotData::sm_PlotList.rend(); rpd++ )
                    {
                        if ( (*rpd)->FindObject( name ) )
                        {
                            break;
                        }
                    }
                    if ( rpd != CcPlotData::sm_PlotList.rend())
					{
						(*rpd)->ParseInput( tokenList );
                        break;
					}
// Not found.
                    if ( safeSet )
                    {
                      //Never mind - scan for closing ], but error if find
                      //an InstructionClass first.
                      while (true)
                      {
                         if ( tokenList.empty() )
                         {
                            LOGWARN( "CcController:ParseInput:SAFESET ran off end of input.");
                            break;
                         }
                         else if ( CcController::GetDescriptor( tokenList.front(), kInstructionClass ) == kTCloseGroup )
                         {
                            tokenList.pop_front();
                            break;
                         }
                         tokenList.pop_front();
                      }
                    }
                    else
                    {
                       LOGWARN( "CcController:ParseInput:Set couldn't find object with name '" + name + "'");
                    }
                }
                break;
            }
            case kTFocus:
            {
                // remove that token
                tokenList.pop_front();

                string name = string(tokenList.front());  // Get the name of the object
                tokenList.pop_front();
                LOGSTAT("CcController: Setting Value of " + name);
                CrGUIElement* theElement = nil;

                if (name == "TEXTOUTPUT")
                {
                    theElement = GetTextOutputPlace();
                              theElement->CrFocus();
                }
                else if (name == "PROGOUTPUT")
                {
                    theElement = GetProgressOutputPlace();
                              theElement->CrFocus();
                }
                else if (name == "TEXTINPUT")
                {
                    theElement = GetInputPlace();
                    theElement->CrFocus();
                }
                else
                {
                    // Look for the item
                    theElement = FindObject( name );
                    if(theElement)
                        theElement->CrFocus();
                    else
                        LOGWARN( "CcController:ParseInput:Focus couldn't find object with name '" + name + "'");
                }
                break;
            }
            case kTBatch:
            {
                // remove that token
                tokenList.pop_front();
                m_BatchMode = true;   //Stops blocking dialogs on error.
                break;
            }
            case kTRenameObject:
            {
                // remove that token
                tokenList.pop_front();

                string name = string(tokenList.front());  // Get the name of the object
                tokenList.pop_front();
                LOGSTAT("CcController: About to rename: " + name);
                CrGUIElement* theElement = nil;

        // Look for the item
                theElement = FindObject( name );
                if(theElement)
                    theElement->Rename( tokenList.front() ); 
                else
                {

                    list<CcChartDoc*>::iterator doc
                          =  find( CcChartDoc::sm_ChartDocList.begin(),
                                   CcChartDoc::sm_ChartDocList.end(), name );
   
                    if ( doc != CcChartDoc::sm_ChartDocList.end() )
                    {
                        (*doc)->Rename( tokenList.front() );
                    }
                    else
                    {
                       LOGWARN( "CcController:ParseInput:Rename couldn't find object with name '" + name + "'");
                    }
                }
                tokenList.pop_front();  // Remove the new name.
                break;
            }
            case kTCreateChartDoc:
            {
                tokenList.pop_front(); //remove token
                CcChartDoc* cPtr = new CcChartDoc();
                cPtr->ParseInput( tokenList );
                break;
            }
            case kTCreatePlotData:
            {
                tokenList.pop_front(); //remove token
                CcPlotData* pPtr = CcPlotData::CreatePlotData( tokenList );
                pPtr->ParseInput( tokenList );
                CcPlotData::sm_CurrentPlotData = pPtr;
                break;
            }
            case kTCreateModelDoc:
            {
                tokenList.pop_front(); //remove token
                CreateModelDoc(tokenList.front()); 
                tokenList.pop_front();
                CcModelDoc::sm_CurrentModelDoc->ParseInput( tokenList );
                break;
            }
            case kTSysOpenFile: //Display OpenFileDialog and send result back to the Script.
            {
                tokenList.pop_front();    // remove that token
		string result;  //the answer
		list<pair<string,string> > extensionsAndDescriptions;

//Updated syntax use SYSOPENFILE [ 'ext' 'desc' 'ext' 'desc' ]
                if ( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kInstructionClass ) == kTOpenGroup) {
	                tokenList.pop_front();
                        while ( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kInstructionClass ) != kTCloseGroup) {
	               		string extension = string(tokenList.front()); // Get the extension
		                tokenList.pop_front();
				if ( tokenList.empty() || CcController::GetDescriptor( tokenList.front(), kInstructionClass ) == kTCloseGroup ) {
	                           LOGWARN( "CcController:ParseInput:SysOpenFile extension string without description");
				   break;
				}
                		string description = string(tokenList.front());   // Get the extension description
		                tokenList.pop_front();
				extensionsAndDescriptions.push_back(make_pair(extension,description));

			}
	                tokenList.pop_front();
		} else {
// old syntax
	                string result;
        	        string extension = string(tokenList.front()); // Get the extension
	                tokenList.pop_front();
	                string description = string(tokenList.front());   // Get the extension description
	                tokenList.pop_front();
			extensionsAndDescriptions.push_back(make_pair(extension,description));
		}

	        if ( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kAttributeClass ) == kTTitleOnly)
	        {
	            result = OpenFileDialog(extensionsAndDescriptions, true);
	            tokenList.pop_front(); //Remove TitleOnly token
	        }
	        else
	        {
	            result = OpenFileDialog(extensionsAndDescriptions, false);
        	}
                SendCommand(result);
                break;
            }
            case kTSysSaveFile: //Display SaveFileDialog and send result back to the Script.
            {
                tokenList.pop_front();    // remove that token
                string defName = string(tokenList.front());   // Get the default file name.
                tokenList.pop_front();    // remove that token
                string extension = string(tokenList.front()); // Get the extension.
                tokenList.pop_front();    // remove that token
                string description = string(tokenList.front());   // Get the extension description.
                tokenList.pop_front();    // remove that token

                SendCommand( SaveFileDialog( defName, extension, description ) );
                break;
            }
            case kTSysGetDir: //Display GetDirDialog and send result back to the Script.
            {
                tokenList.pop_front();    // remove that token
                string result = OpenDirDialog();
                SendCommand(result);
                break;
            }
            case kTSysRestart: //Crystals has closed down, restart in specified directory.
            {
                tokenList.pop_front();    // remove that token
                m_newdir = string (tokenList.front());
                tokenList.pop_front();
                m_restart = true;
                if (!tokenList.empty() && CcController::GetDescriptor( tokenList.front(),  kAttributeClass  )==kTRestartFile)
                {
                              tokenList.pop_front();    // remove that token
                              string newdsc = "CRDSC=" + tokenList.front();
                              tokenList.pop_front();    // remove that token
#ifdef CRY_USEMFC
                              _putenv( (LPCTSTR) newdsc.c_str() );
#elif defined(CRY_OSWIN32)
                              _putenv( newdsc.c_str() );
#else
                             char * env = new char[newdsc.size()+1];
                             strcpy(env, newdsc.c_str());
                             stringlist.push_back(env);
                             putenv( env );
#endif
                        }
                        break;
            }
            case kTRedirectText:
            {
                tokenList.pop_front();
                CrTextOut * theTO = (CrTextOut*) FindObject( tokenList.front() );
                if ( theTO != nil )
                    SetTextOutputPlace(theTO);
                else
                    LOGWARN( "CcController:ParseInput:RedirectText couldn't find object with name '" + tokenList.front() + "'");
                tokenList.pop_front();
                break;
            }
            case kTRedirectProgress:
            {
                tokenList.pop_front();
                CrProgress * thePB = (CrProgress*)FindObject( tokenList.front() );
                if ( thePB != nil )
                    SetProgressOutputPlace(thePB);
                else
                    LOGWARN( "CcController:ParseInput:RedirectProgress couldn't find object with name '" + tokenList.front() + "'");
                tokenList.pop_front();
                break;
            }
            case kTRedirectInput:
            {
                tokenList.pop_front();
                CrEditBox * theEB = (CrEditBox*)FindObject( tokenList.front() );
                if ( theEB != nil )
                         SetInputPlace(theEB);
                else
                         LOGWARN( "CcController:ParseInput:RedirectInput couldn't find object with name '" + tokenList.front() + "'");
                tokenList.pop_front();
                break;
            }
            case kTGetRegValue:
            {
                tokenList.pop_front();
                string val = GetRegKey( tokenList[0], tokenList[1] );
                tokenList.pop_front();
                tokenList.pop_front();
                SendCommand(val);
                break;
            }
            case kTGetKeyValue:
            {
                tokenList.pop_front();
                string val = GetKey( tokenList.front() );
                tokenList.pop_front();
                SendCommand(val);
                break;
            }
            case kTSetKeyValue:
            {
                tokenList.pop_front();
                StoreKey( tokenList[0], tokenList[1] );
                tokenList.pop_front();
                tokenList.pop_front();
                break;
            }
            case kTSetStatus:
            {
                tokenList.pop_front();
                status.ParseInput( tokenList );
                break;
            }
            case kTFontSet:
            {
                tokenList.pop_front();
                CcChooseFont();
                break;
            }

            default:
            {
                // This is not a known instruction for Controller.
                // Pass it on to the current window.
                if ( &tokenList == &mWindowTokenList )
                {
                    if ( mCurrentWindow )
                    {
                        LOGSTAT("CcController:ParseInput Passing tokenlist to window");
                        retVal = mCurrentWindow->ParseInput( tokenList );
                    }
                }
                else if ( &tokenList == &mChartTokenList )
                {
                    if ( CcChartDoc::sm_CurrentChartDoc != nil )
                    {
                        LOGSTAT("CcController:ParseInput:default Passing tokenlist to chart");
                        retVal = CcChartDoc::sm_CurrentChartDoc->ParseInput( tokenList );
                    }
                }
                else if ( &tokenList == &mPlotTokenList )
                {
                    if ( CcPlotData::sm_CurrentPlotData != nil )
                    {
                        LOGSTAT("CcController:ParseInput:default Passing tokenlist to plot");
                        retVal = CcPlotData::sm_CurrentPlotData->ParseInput( tokenList );
                    }
                }
                else if ( &tokenList == &mModelTokenList )
                {
                    if ( CcModelDoc::sm_CurrentModelDoc != nil )
                    {
                        LOGSTAT("CcController:ParseInput:default Passing tokenlist to model");
                        retVal = CcModelDoc::sm_CurrentModelDoc->ParseInput( tokenList );
                    }
                }
                else if ( &tokenList == &mStatusTokenList )
                {
                        LOGSTAT("CcController:ParseInput:default Passing tokenlist to status handler");
                        status.ParseInput( tokenList );
                }
                else
                {
                    LOGWARN("CcController:ParseInput:default found an unknown command = '" + tokenList.front() +
                         "', attempting to continue");
                    tokenList.pop_front();
                }
                break;
            }
        } //end case
    } //end of while loop


    return (retVal.OK());

}

void    CcController::SendCommand( string command , bool jumpQueue)
{
    LOGSTAT("CcController:SendCommand received command '" + command + "'");
//    char* theLine = (char*)command.c_str();
    AddCrystalsCommand( command, jumpQueue );
}


void    CcController::Tokenize( const string & cText )
{

//    LOGWARN(cText);

	int clen = cText.length();
    int chop = 0;

// Look out for lines where the ^^ are misplaced.

    if ( clen >= 4 )
    {
        if ( cText[1] == '^' )
        {
          chop = 5; 
          if ( cText[0] == '^' )
          {
            chop = 4;
          }
        }
    }

    if ( chop && (clen >= chop) )   // It is definitely tagged text
    {
        string selector = cText.substr(chop-2,2); // Get the selector and determine list to use
        if ( selector.compare(kSWindowSelector) == 0 )
        {
            mCurTokenList = &mWindowTokenList;
            MakeTokens( cText.substr(chop,cText.length()-chop), *mCurTokenList);
        }
        else if ( selector.compare(kSChartSelector) == 0 )
        {
            mCurTokenList = &mChartTokenList;
            MakeTokens( cText.substr(chop,cText.length()-chop), *mCurTokenList);
        }
        else if ( selector.compare(kSPlotSelector) == 0 )
        {
            mCurTokenList = &mPlotTokenList;
            MakeTokens( cText.substr(chop,cText.length()-chop), *mCurTokenList);
        }
        else if ( selector.compare(kSModelSelector) == 0 )
        {
            mCurTokenList = &mModelTokenList;
            MakeTokens( cText.substr(chop,cText.length()-chop), *mCurTokenList);
        }
        else if ( selector.compare(kSStatusSelector) == 0 )
        {
            mCurTokenList = &mStatusTokenList;
            MakeTokens( cText.substr(chop,cText.length()-chop), *mCurTokenList);
        }
        else if ( selector.compare(kSControlSelector) == 0 )
        {
            while ( ParseInput( *mCurTokenList ) )
		;
        }
        else if ( selector.compare(kSWaitControlSelector) == 0 )
        {
            while ( ParseInput( *mCurTokenList ) )
		;
//We must now signal the waiting Crystals thread that we're complete.
            LOGSTAT ( "CW complete, unlocking output queue.");
            m_Complete_Signal.Signal();
        }
        else if ( selector.compare(kSOneCommand) == 0 )
        {                                                                                                                                //Avoids breaking up (and corrupting) the incoming streams from scripts.
            mTempTokenList = mCurTokenList;
            mCurTokenList  = &mQuickTokenList;
            MakeTokens( cText.substr(chop,cText.length()-chop), *mCurTokenList);
            while ( ParseInput( mQuickTokenList ) );
            mCurTokenList  = mTempTokenList;
        }
        else if ( selector.compare(kSQuerySelector) == 0 )
        {
            mTempTokenList = mCurTokenList;
            mCurTokenList  = &mQuickTokenList;
            MakeTokens( cText.substr(chop,cText.length()-chop), *mCurTokenList);
            GetValue( mQuickTokenList ) ;
            mCurTokenList  = mTempTokenList;
//We must now signal the waiting Crystals thread that it's input is ready.
            LOGSTAT ( "?? complete, unlocking output queue.");
            m_Complete_Signal.Signal();
        }
        else                                             // Simple output text or comment
        {
            ProcessOutput( cText ); // Useful to see mistakes in ^^ format.
        }
    }
    else                                             // Simple output text or comment
    {
            ProcessOutput( cText );
    }
}

string trim(const string& pString)
{
	string::size_type start = pString.find_first_not_of(" \t\r\n");
	string::size_type end = pString.find_last_not_of(" \t\r\n");
	if (start == string::npos || end == string::npos)
		return string();
	else
		return pString.substr(start, end-(start-1));
}

void  CcController::AddCrystalsCommand(const string &line, bool jumpQueue)
{
//Pre check for commands which we should handle. (Useful as these can be handled while the crystals thread is busy...)
// 1. Close the main window. (Close the program).
      if( line.length() > 10 )
      {
         if( ( line.substr(0,11) == "_MAIN CLOSE" ) && m_AllowThreadKill )
         {
           LOGSTAT("---Closing main window.");
           AddInterfaceCommand("^^CO DISPOSE _MAIN ");
           mThisThreadisDead = true;
           return; //Messy at the moment. Need to do this from crystals thread so it can exit cleanly.
         }
      }
// 2. Allow GUIelements to send commands directly to the interface. Trap them here.
      if( line.length() >= 4 )
      {
         if( line.substr(0,2) == "^^")
         {
              AddInterfaceCommand(line,true);
              return;
         }
      }

// 3. Everything else.
//Add this command to the queue to crystals.
	string temp = trim(line);
	string::size_type stp;
	if ( jumpQueue )
	{
		 stp = temp.rfind("_N");
		 if (stp != string::npos)
		 {
			mCrystalsCommandDeq.push_front ( temp.substr(stp+2,temp.length()-stp-2) );   //Add the next command in the list to the command queue
			AddCrystalsCommand(temp.substr(0,stp), jumpQueue);
		 }
		 else
			mCrystalsCommandDeq.push_front ( temp );	//Add the next command in the list to the command queue
	}
	else
	{
		 stp = temp.find("_N");
		 if (stp != string::npos)
		 {
			mCrystalsCommandDeq.push_back ( temp.substr(0,stp) );   //Add the next command in the list to the command queue
			AddCrystalsCommand(temp.substr(stp+2,temp.length()-stp-2), jumpQueue);
		 }
		 else
			mCrystalsCommandDeq.push_back ( temp );	//Add the next command in the list to the command queue
	}
}

void  CcController::AddInterfaceCommand( const string &line, bool internal )
//------------------------------------------------------
{
/*  This is a critical section between the threads.
 *  If the interface thread has a lock on the section, then we
 *  have to wait (using a mutex sync object).

 *  If the command is a query from the CRYSTALS program ( ^^?? ), then
 *  we must get a lock on the Crystals Command Queue, so that
 *  nothing can be read from it, until the answer to the query
 *  is placed at the top of the queue.
 */
  bool lock = false;
    int chop = 0;
  int clen = line.length();
    if (clen >= 4 )
  {
    if ( line[1] == '^' )
    {
      if ( clen >= 5 ) chop = 5;

      if ( line[0] == '^' )
      {
        chop = 4;
      }
      if ( chop ) 
      {
        string selector = line.substr(chop-2,2);
        if ( !internal && (( selector.compare(kSQuerySelector)      ==0) || 
                           ( selector.compare(kSWaitControlSelector)==0)    ) )
        {
          lock = true; // Don't return from here until 
                       // this query is answered.
          LOGSTAT ("-----------Thread will be locked before returning: "+selector);
        }
      }
    }
  }
   
  if(mThisThreadisDead) endthread(0);

//  ostringstream os;
//  os << "-----(" << mInterfaceCommandDeq.size() <<  ")---CRYSTALS puting: " << line ;
//  LOGSTAT(os.str());

  mInterfaceCommandDeq.push_back(line);
  LOGSTAT("-----------CRYSTALS has put: " + line );

	
#ifdef CRY_USEMFC
      if ( mGUIThread ) PostThreadMessage( mGUIThread->m_nThreadID, WM_STUFFTOPROCESS, NULL, NULL );
#else
	//wxCommandEvent tEvent(ccEVT_COMMAND_ADDED);
	//wxTheApp->AddPendingEvent(tEvent);
#endif
	  bool comp = false;
	    if ( lock ) 
  {
       m_Complete_Signal.Wait();
       LOGSTAT ("-----------Queue released");
  }
}

bool CcController::GetInterfaceCommand( string &line )
//------------------------------------------------------
{
    //This routine gets called repeatedly by the Idle loop.
    //It needn't be highly optimised even though it is high on
    //the profile count list.
//  LOGSTAT("GtIfCmd.");
  if( mCrystalsThread ) 
  {
    if ( ! (m_Crystals_Thread_Alive.IsLocked()) )
    {
      LOGSTAT("The CRYSTALS thread has died.");
//      delete mCrystalsThread;
      mCrystalsThread = nil;
      if ( m_restart )
      {
        ChangeDir( m_newdir );
        StartCrystalsThread();
        m_restart = false;
	  } else {
        mThisThreadisDead = true;
        LOGSTAT("Shutting down the main window of this (GUI) thread.");
        line = "^^CO DISPOSE _MAIN ";
        return (true);
	  }
    }
  }
  else
  {
      LOGSTAT("The CRYSTALS thread has ended.");
      mThisThreadisDead = true;
      LOGSTAT("Shutting down this (GUI) thread.");
      line = "^^CO DISPOSE _MAIN ";
      return (true);
  }
  
  try
  {
      if ( mInterfaceCommandDeq.size() == 0 )
          return false;
      
      line = mInterfaceCommandDeq.pop_front(0);
//    ostringstream os;
//    os << "GUI gets (rem: " << mInterfaceCommandDeq.size() << ": " << line;
//    LOGSTAT(os.str());
    LOGSTAT("GUI gets: "+line);
    return (true);
  }
  catch (const exception& e)
  {
    line = "" ;
    return (false);
  }
}

void    CcController::LogError( string errString , int level )
{
    if ( mErrorLog == nil )
    {
        mErrorLog = fopen( "Script.log", "w+" );
    }
    if ( level == 1 ) //Warning mark with stars.
    {
        errString = " WARNING: " + errString;
        ProcessOutput( "{E " + errString );
    }
    else if (level == 0) //Serious error mark with XXXX's
    {
        errString = " ERROR: " + errString;
        ProcessOutput( "{E " + errString );
    }
    for ( int i = 0; i < CcController::debugIndent; i++)
    {
      fprintf( mErrorLog, "  ");
    }

#ifdef CRY_OSWIN32
    int now_ticks = GetTickCount();
#else
    struct timeval time;
    struct timezone tz;
    gettimeofday(&time,&tz);
    int now_ticks = (time.tv_sec%10000)*1000 + time.tv_usec/1000;
#endif


    int elapse = now_ticks - m_start_ticks; // may go negative- GetTickCount wraps every 47 days.

    fprintf( mErrorLog, "%d.%03d %s\n", elapse/1000,elapse%1000,errString.c_str() );
    fflush( mErrorLog );

    #ifdef CRY_OSLINUX
          std::cerr << elapse << " " << errString.c_str() << "\n";
    #endif
}


CrGUIElement* CcController::FindObject(const string & Name)
{
    CrGUIElement * theElement = nil;
    list<CrWindow*>::iterator mw;
    for ( mw = mWindowList.begin(); mw != mWindowList.end(); mw++ )
    {
      LOGSTAT("Find object, testing: " + (*mw)->mName);
      if ( (theElement = (*mw)->FindObject(Name) )) return theElement;
    }
    return nil;
}

bool CcController::InputPlaceIsInTopLevelModalWindow() 
{
	if ( CrWindow::mModalWindowStack.empty() ) return true; //shouldn't happen, but maybe top level window isn't in stack
	if ( GetInputPlace() ) {
		if ( GetInputPlace()->GetRootWidget() == CrWindow::mModalWindowStack.back() ) return true;
	}
	return false;
}

void CcController::FocusToInput(char theChar)
{
    int nChar = (int) theChar;
    if( nChar == 13) //Return key, process input.
    {
            GetInputPlace()->ReturnPressed();
            GetInputPlace()->CrFocus();
    }
    else if ( nChar > 31 && nChar < 127 ) //Some keyboard text. Append to command line.
    {
        string someText = ((CxEditBox*)(GetInputPlace()->GetWidget()))->GetText();
        someText += theChar;
		if ( InputPlaceIsInTopLevelModalWindow() ){
			GetInputPlace()->SetText(someText);
		    GetInputPlace()->CrFocus();
		}
    }
	else if ( InputPlaceIsInTopLevelModalWindow() ) //No input text, but focus anyway.
	{
        GetInputPlace()->CrFocus();
	}
}

void CcController::SetTextOutputPlace(CrGUIElement * outputPane)
{
    mTextOutputWindowList.push_back(outputPane);
}

CrGUIElement* CcController::GetTextOutputPlace()
{
    if (mTextOutputWindowList.empty()) return nil;
    return mTextOutputWindowList.back();
}

void CcController::SetProgressOutputPlace(CrProgress * outputPane)
{
    if ( !mProgressOutputWindowList.empty() )
             mProgressOutputWindowList.back()->SetText(" ");
    mProgressOutputWindowList.push_back(outputPane);
}
CrGUIElement* CcController::GetProgressOutputPlace()
{
    if (mProgressOutputWindowList.empty()) return nil;
    return mProgressOutputWindowList.back();
}

void CcController::SetInputPlace(CrEditBox * inputPane)
{
      mInputWindowList.push_back(inputPane);
}

CrEditBox* CcController::GetInputPlace()
{
    if (mInputWindowList.empty()) return nil;
    return mInputWindowList.back();
}




void CcController::RemoveTextOutputPlace(CrGUIElement* output)
{
      mTextOutputWindowList.remove(output);
}
void CcController::RemoveProgressOutputPlace(CrProgress* output)
{
      mProgressOutputWindowList.remove(output);
}

void CcController::RemoveInputPlace(CrEditBox* input)
{
      mInputWindowList.remove(input);
}

void CcController::RemoveWindowFromList(CrWindow* window)
{
// CxWindows can be destroyed by the framework, when their parent
// windows are destroyed. This bypasses our normal destruction
// method, so to be safe, all dying windows call this function
// to 'de-register' themselves from the Controller's list.
      mWindowList.remove(window);
      LOGSTAT("CcController: Window destroyed by framework?" );
}



CcModelDoc* CcController::FindModelDoc(const string & name)
{
    if ( CcModelDoc::sm_ModelDocList.empty() ) return nil;

    list<CcModelDoc*>::iterator doc = 
              find( CcModelDoc::sm_ModelDocList.begin(), CcModelDoc::sm_ModelDocList.end(), name );
   
    if ( doc == CcModelDoc::sm_ModelDocList.end() ) 
                return nil;
    else 
                return *doc;
}

CcModelDoc* CcController::CreateModelDoc(const string & name)
{
    CcModelDoc* modelDoc;
    modelDoc = FindModelDoc(name);
    if ( modelDoc == nil )
    {
        modelDoc = new CcModelDoc();
        modelDoc->mName = name;
    }
    else
    {
        modelDoc->Clear();
    }

    CcModelDoc::sm_CurrentModelDoc = modelDoc;
    return modelDoc;
}



void CcController::GetValue(deque<string> &  tokenList)
{
    LOGSTAT("CcController: Getting Value");

    string name = string(tokenList.front());  // Get the name of the object
    tokenList.pop_front();
    CrGUIElement * theElement = nil;

    if ( mCurrentWindow )
    {
        // Look for the item in current window first.
         theElement = mCurrentWindow->FindObject( name );
    }

    if ( theElement == nil )
    {
        // Look for the element everywhere.
        theElement = FindObject ( name );
    }

//If this is an EXISTS query, then send either TRUE or FALSE

    if( CcController::GetDescriptor( tokenList.front(), kQueryClass ) == kTQExists )
    {
        tokenList.pop_front(); //Remove token.

        if ( theElement != nil )
            SendCommand("TRUE",true); //This is used to check if an object exists.
        else
            SendCommand("FALSE",true); //This is used to check if an object exists.
    }

//If this is a GETKEY query, then process it at once.

    else if( name.find(kSGetKeyValue) == 0 )
    {
        string val = GetKey( tokenList.front() );
        tokenList.pop_front();
        SendCommand(val,true);
    }

//If this is another query pass control to object, or if it doesn't exist, return ERROR.

    else
    {
        if ( theElement != nil )
            theElement->GetValue(tokenList);
        else
        {
            SendCommand("ERROR",true);
            LOGWARN( "CcController:GetValue couldn't find object with name '" + name + "'");
        }

    }
}


void  CcController::SetProgressText(const string& theText)
{
      CrProgress* theElement = (CrProgress*) GetProgressOutputPlace();
      if (theElement != nil)
            theElement->SwitchText( theText );
}


void CcController::StoreKey( string key, string value )
{
#ifdef CRY_USEMFC
 // Use the registry to store keys.

 string subkey = "Software\\Chem Cryst\\Crystals\\";

 HKEY hkey;
 DWORD dwdisposition, dwtype, dwsize;


 int result = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                              0, NULL,  0, KEY_WRITE, NULL,
                              &hkey, &dwdisposition );
                              
 if ( result == ERROR_SUCCESS )
 {
    dwtype = REG_SZ;
    dwsize = ( _tcslen(value.c_str()) + 1) * sizeof(TCHAR);

    RegSetValueEx(hkey, key.c_str(), 0, dwtype,
                  (PBYTE)value.c_str(), dwsize);

    RegCloseKey(hkey);
 }

#else

 wxString ckey = wxT("Chem Cryst");
 wxString pkey = wxT("Crystals/");
 pkey += wxString(key.c_str(),wxConvUTF8);
 wxString wval(value.c_str(),wxConvUTF8);
 wxConfig * config = new wxConfig(ckey);
 config->Write( pkey, wval );
 delete config;

#endif

  return;

}
string CcController::GetKey( string key )
{
  string value;

#ifdef CRY_USEMFC
 // Use the registry to fetch keys.
 string subkey = "Software\\Chem Cryst\\Crystals\\";

 HKEY hkey;
 DWORD dwdisposition, dwtype, dwsize;

 int result = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                              0, NULL,  0, KEY_READ, NULL,
                              &hkey, &dwdisposition );
                              
 if ( result == ERROR_SUCCESS )
 {

    dwtype=REG_SZ;
    dwsize = 1024; // NB limits max key size to 1K of text.
    char buf [ 1024];

    result = RegQueryValueEx( hkey, key.c_str(), 0, &dwtype,
                             (PBYTE)buf,&dwsize);
    if ( result == ERROR_SUCCESS )
    {
      value = string(buf);
    }
    RegCloseKey(hkey);
 }

#else

 wxString str;
 wxString pkey = wxT("Crystals/");
 pkey += wxString(key.c_str(),wxConvUTF8);
 wxString wstr;

 wxConfig * config = new wxConfig("Chem Cryst");
 if ( config->Read(pkey, &wstr ) ) {
   value = wstr.mb_str();
 }
 delete config;

#endif

 return value;

}

string CcController::GetRegKey( string key, string name )
{

// Fetch any key from the registry. It first looks in HKCU/key for name,
// if not found, then it falls back to HKLM/key. The return value is
// empty if the key isn't found.

 string data;

#ifdef CRY_USEMFC
 HKEY hkey;
 DWORD dwtype, dwsize;

 int result = RegOpenKeyEx( HKEY_CURRENT_USER, key.c_str(),
                              0, KEY_READ, &hkey );
                              
 if ( result == ERROR_SUCCESS )
 {
    dwtype=REG_SZ;
    dwsize = 1024; // NB limits max key size to 1K of text.
    char buf [ 1024];
    result = RegQueryValueEx( hkey, name.c_str(), 0, &dwtype, (PBYTE)buf,&dwsize);
    if ( result == ERROR_SUCCESS ) data = string(buf);
    RegCloseKey(hkey);
 }

 if ( result != ERROR_SUCCESS )
 {
    result = RegOpenKeyEx( HKEY_LOCAL_MACHINE, key.c_str(),
                              0, KEY_READ, &hkey );
                              
    if ( result == ERROR_SUCCESS )
    {
       dwtype=REG_SZ;
       dwsize = 1024; // NB limits max key size to 1K of text.
       char buf [ 1024];
       result = RegQueryValueEx( hkey, name.c_str(), 0, &dwtype, (PBYTE)buf,&dwsize);
       if ( result == ERROR_SUCCESS ) data = string(buf);
       RegCloseKey(hkey);
    }
 }
#else

 wxString str;
 wxString pkey = wxT("Crystals/");
 pkey += wxString(key.c_str(),wxConvUTF8);
 wxString wstr;

 wxConfig * config = new wxConfig("Chem Cryst");
 if ( config->Read(pkey, &wstr ) ) {
   data = str.mb_str();
 }
 delete config;
#endif


 return data;
}

void CcController::UpdateToolBars()
{
  // Unlike menus, the toolbars don't recieve events telling them
  // to update during idle time.
  // So we'll do it from here.

   CrToolBar::UpdateToolBars(status);


   list<CrWindow*>::iterator mdwl;
   for ( mdwl = mDisableableWindowsList.begin(); mdwl != mDisableableWindowsList.end(); mdwl++ )
              (*mdwl)->Enable(status.ShouldBeEnabled((*mdwl)->wEnableFlags,(*mdwl)->wDisableFlags));

   list<CrButton*>::iterator mdbl;
   for ( mdbl = mDisableableButtonsList.begin(); mdbl != mDisableableButtonsList.end(); mdbl++ )
              (*mdbl)->Enable(status.ShouldBeEnabled((*mdbl)->bEnableFlags,(*mdbl)->bDisableFlags));

}
void CcController::ScriptsExited()
{
  //Use this fact to close any modal windows that don't
  //have the STAYOPEN property. (This means that the script
  //has terminated incorrectly without closing the window).

  //Iterate in reverse, so that children of earlier windows are
  //deleted first.

  list<CrWindow*>::reverse_iterator mw;
  list<CrWindow*>::iterator temp;

  for ( mw = mWindowList.rbegin(); mw != mWindowList.rend();  )
  {
     if ( (*mw)->mIsModal && !(*mw)->mStayOpen )
     {
        if ( (*mw) == mCurrentWindow ) mCurrentWindow = nil;
        LOGSTAT("CcController: ScriptsExited, destroying: " + (*mw)->mName );
        delete *mw;
        mw++;
        temp = mw.base();
        mWindowList.erase(temp);
        mw = mWindowList.rbegin(); //start again
     }
     else
       mw++;
  }
}

void CcController::AddDisableableWindow( CrWindow * aWindow )
{
      mDisableableWindowsList.push_back( aWindow );
}
void CcController::RemoveDisableableWindow ( CrWindow * aWindow )
{
   mDisableableWindowsList.remove( aWindow );
}
void CcController::AddDisableableButton( CrButton * aButton )
{
      mDisableableButtonsList.push_back( aButton );
}
void CcController::RemoveDisableableButton ( CrButton * aButton )
{
   mDisableableButtonsList.remove( aButton );
}
void CcController::ReLayout()
{
  CcRect gridRect;
  list<CrWindow*>::iterator mw;
    for ( mw = mWindowList.begin(); mw != mWindowList.end(); mw++ )
  {
    gridRect = (*mw) -> mGridPtr -> GetGeometry();
    (*mw) -> CalcLayout(true);
    (*mw) -> ResizeWindow(gridRect.Width(),gridRect.Height());
    (*mw) -> Redraw();
  }
  return;
}

extern "C" { void crystl(); }

#ifdef CRY_OSWIN32
UINT CrystalsThreadProc( void* arg );
#else
int CrystalsThreadProc( void* arg );
#endif
	

#ifdef CRY_OSWIN32
UINT CrystalsThreadProc( void * arg )
#else
int CrystalsThreadProc( void * arg )
#endif
{
#if defined (__INW__) 
    crInstallToCurrentThread2(0);
#endif

  // Unset exception handlers before exiting the thread
    LOGSTAT("FORTRAN: Grabbing Crystals_Thread_Alive mutex");
    m_Crystals_Thread_Alive.Enter(); //Will be owned whole time crystals thread is running.
    LOGSTAT("FORTRAN: Posting wait_for_thread_start semaphore");
    m_wait_for_thread_start.Signal(true);

    LOGSTAT("FORTRAN: Running CRYSTALS");
    try
    {
       crystl();
       LOGSTAT ("Exited CRYSTL() without exception. Surely some mistake?");
    }
    catch (CcController::MyException ccme )
    {
        LOGSTAT ("Normal close down exception caught. Thread ends. Releasing mutex. Goodbye. " );
    }
    catch (CcController::MyBadException ccme )
    {
        LOGSTAT ("Error Exception caught. Thread ends. Releasing mutex. Goodbye. " );
#if defined (__INW__) 
        m_Crystals_Thread_Alive.Leave(); //Will be owned whole time crystals thread is running.
	    (CcController::theController)->AddInterfaceCommand("^^CR"); // Kick GUI thread to notice we've gone.
		throw;  //rethrow for the crash handler
#endif
    }
//    catch ( ... )
//    {
 //       LOGERR ("Unhandled exception caught. Thread ends. Releasing mutex. Goodbye. " );
//    }
    m_Crystals_Thread_Alive.Leave(); //Will be owned whole time crystals thread is running.
	(CcController::theController)->AddInterfaceCommand("^^CR"); // Kick GUI thread to notice we've gone.
    LOGSTAT ("Final word from the CRYSTALS thread: Bye." );
#if defined (__INW__) 
    //crUninstallFromCurrentThread();    
#endif
    return 0;
}

void CcController::StartCrystalsThread()
{
//************************************************************//
//                                                            //
//    V.Important. Start the CRYSTALS (FORTRAN) thread.       //
//    This returns a pointer which is stored so we can        //
//             kill it later if we want!                      //
//                                                            //
   int arg = 6;

#ifdef CRY_OSMAC
    setlocale( LC_ALL, "POSIX");
#endif
    
#ifdef CRY_USEMFC
   mCrystalsThread = AfxBeginThread(CrystalsThreadProc,&arg);
#else
   mCrystalsThread = new CcThread();
   wxThreadError a =  mCrystalsThread->Create();
   if ( a == wxTHREAD_NO_ERROR ) 
     LOGSTAT("No create error");
   else
     LOGSTAT("Thread create error");

   a = mCrystalsThread->Run();
   if ( a == wxTHREAD_NO_ERROR ) 
     LOGSTAT("No run error");
   else
     LOGSTAT("Thread run error");
#endif
   LOGSTAT("GUI: Waiting for wait_for_thread_start semaphore.");
   m_wait_for_thread_start.Wait(0);
   LOGSTAT("GUI: Continuing.");

//                                                            //
//                                                            //
//                                                            //
//                                                            //
//************************************************************//
}

//  Append the contents of the buffer to the output

void CcController::ProcessOutput( const string & line )
{
    CrGUIElement* element = GetTextOutputPlace();
    if( element != nil ) element->SetText(line);
}

string CcController::OpenFileDialog(list<pair<string,string> > &extensionsAndDescriptions, 
                                  bool titleOnly)
{
	list<pair<string,string> >::iterator i = extensionsAndDescriptions.begin();
	list<pair<string,string> >::iterator e = extensionsAndDescriptions.end();

#ifdef CRY_USEMFC
    CString pathname, filename, filetitle;

    CString extension;
    while ( i!=e ) {
        extension += CString((i->second).c_str()) + "|" + CString((i->first).c_str()) + "|";
        ++i;
    }
    extension += "|";
    
//    CString extension = CString(extensionDescription.c_str()) + "|" + CString(extensionFilter.c_str()) + "||" ;

    CFileDialog fileDialog (      true,                   //TRUE for open, FALSE for save
                                NULL,               //The default extension for the filename
                                NULL,               //The initial filename displayed
                                OFN_HIDEREADONLY|OFN_NOCHANGEDIR|OFN_FILEMUSTEXIST, //some flags
                                extension,    //all the extensions allowed
                                NULL);              //The parent window of this window

    char buffer[_MAX_PATH];

// Get the current working directory:
    if( _getcwd( buffer, _MAX_PATH ) )
         fileDialog.m_ofn.lpstrInitialDir = buffer;


    if (fileDialog.DoModal() == IDOK )
    {
        pathname = fileDialog.GetPathName();

        if(titleOnly)
        {
            filename = fileDialog.GetFileName();
            filetitle = fileDialog.GetFileTitle();
            CString pathandtitle = pathname.Left(pathname.Find(filename)) + filetitle;
            pathname = pathandtitle;
        }
    }
    else
    {
        pathname = "CANCEL";
    }

    return string(pathname.GetBuffer(256));
#else
    wxString pathname, filename, filetitle;

    wxString extension;//  = wxString(extensionDescription.c_str()) + "|" + wxString(extensionFilter.c_str())  ;

    bool firstt = true;
    while ( i!=e ) {
        if ( ! firstt ) {
	        extension += "|";
	} else {
                firstt = false;
	}
        extension += wxString((i->second).c_str()) + "|" + wxString((i->first).c_str());
        ++i;
    }

    wxString cwd = wxGetCwd(); //This filedialog changes the working dir. Save it.

    wxFileDialog fileDialog ( wxGetApp().GetTopWindow(),
                              "Choose a file",
                              cwd,
                              "",
                              extension,
                              wxFD_OPEN  );





    if (fileDialog.ShowModal() == wxID_OK )
    {
        pathname = fileDialog.GetPath();

        if(titleOnly)
        {
            wxString pathandtitle = pathname.BeforeLast('.');
            pathname = pathandtitle;
        }
    }
    else
    {
        pathname = "CANCEL";
    }

    wxSetWorkingDirectory(cwd);

    return string(pathname.c_str());
#endif
}

string CcController::SaveFileDialog(const string &defaultName, 
                                    const string &extensionFilter, 
                                    const string &extensionDescription) 
{

#ifdef CRY_USEMFC
    CString pathname, filename, filetitle;

    CString extension = CString(extensionDescription.c_str()) + "|" + CString(extensionFilter.c_str()) + "||" ;
    CString initName  = CString(defaultName.c_str());


    CFileDialog fileDialog (      false,                        //TRUE for open, FALSE for save
                                NULL,               //The default extension for the filename
                                initName,           //The initial filename displayed
                                OFN_HIDEREADONLY|OFN_NOCHANGEDIR|OFN_OVERWRITEPROMPT, //some flags
                                extension,    //all the extensions allowed
                                NULL);              //The parent window of this window

    char buffer[_MAX_PATH];

// Get the current working directory:
    if( _getcwd( buffer, _MAX_PATH ) )
         fileDialog.m_ofn.lpstrInitialDir = buffer;


    if (fileDialog.DoModal() == IDOK )
    {
        pathname = fileDialog.GetPathName();
    }
    else
    {
        pathname = "CANCEL";
    }

    return string(pathname.GetBuffer(256));
#else

    wxString pathname, filename, filetitle;
    wxString extension = wxString(extensionDescription.c_str()) + "|" + wxString(extensionFilter.c_str())  ;
    wxString initName = wxString(defaultName.c_str());

    wxString cwd = wxGetCwd(); //This filedialog changes the working dir. Save it.

    wxFileDialog fileDialog ( wxGetApp().GetTopWindow(),
                              "Save file as",
                              cwd,
                              initName,
                              extension,
                              wxFD_SAVE|wxFD_OVERWRITE_PROMPT );


    if (fileDialog.ShowModal() == wxID_OK )
    {
        pathname = fileDialog.GetPath();
    }
    else
    {
        pathname = "CANCEL";
    }

    wxSetWorkingDirectory(cwd);

    return string(pathname.c_str());
#endif

}

#ifdef CRY_USEMFC
static int __stdcall BrowseCallbackProc(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData);
#endif

string CcController::OpenDirDialog()
{
#ifdef CRY_USEMFC

      string lastPath, result;
      char buffer[MAX_PATH];

 // Use the registry to fetch keys.
      string subkey = "Software\\Chem Cryst\\Crystals\\";
      HKEY hkey;
      DWORD dwdisposition, dwtype, dwsize;
      int dwresult = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                     0, NULL,  0, KEY_READ, NULL, &hkey, &dwdisposition );
      if ( dwresult == ERROR_SUCCESS )
      {
         dwtype=REG_SZ;
         dwsize = 1024; // NB limits max key size to 1K of text.
         char buf [ 1024];
         dwresult = RegQueryValueEx( hkey, TEXT("Strdir"), 0, &dwtype,
                                     (PBYTE)buf,&dwsize);
         if ( dwresult == ERROR_SUCCESS )  lastPath = string(buf);
         RegCloseKey(hkey);
      }

      BROWSEINFO bi;
      LPITEMIDLIST chosen; //The chosen directory as an IDLIST(?)
      char title[36] = "Choose a directory to run CRYSTALS";

      bi.hwndOwner = NULL;
      bi.pidlRoot = NULL;
      bi.pszDisplayName = buffer;
      bi.lpszTitle = (char*)&title;
      bi.ulFlags = BIF_RETURNONLYFSDIRS;
      bi.lpfn = NULL;
      bi.lParam = NULL;
      bi.iImage = NULL;
      if ( lastPath.length() )
      {
        bi.lpfn = BrowseCallbackProc;
        bi.lParam = (LPARAM)(&lastPath);
      }
      chosen = ::SHBrowseForFolder( &bi );

      if ( chosen  )
      {
          if ( SHGetPathFromIDList(chosen, buffer))
          {
             result = string(buffer);


             dwresult = RegCreateKeyEx( HKEY_CURRENT_USER, subkey.c_str(),
                                        0, NULL,  0, KEY_WRITE, NULL,
                                        &hkey, &dwdisposition );
                               
             if ( dwresult == ERROR_SUCCESS )
             {
                dwtype=REG_SZ;
                dwsize = ( _tcslen(result.c_str()) + 1) * sizeof(TCHAR);
                RegSetValueEx(hkey, TEXT("Strdir"), 0, dwtype,
                          (PBYTE)result.c_str(), dwsize);
                RegCloseKey(hkey);
             }
          }
          else
          {
             result = "CANCEL";
          }
      }
      else
      {
            result = "CANCEL";
      }
      return result;
#else
    wxConfig * config = new wxConfig("Chem Cryst");
    wxString pathname;
    wxString cwd = wxGetCwd(); //This dir dialog changes the working dir. Save it.
    if ( ! config->Read("Crystals/Strdir",&pathname) ) {
      pathname = cwd;
    }

    wxDirDialog dirDialog ( wxGetApp().GetTopWindow(),
                            "Choose a directory",
                             pathname,
                             wxDD_NEW_DIR_BUTTON);

    if (dirDialog.ShowModal() == wxID_OK )
    {
        pathname = dirDialog.GetPath();
        config->Write("Crystals/Strdir",pathname);
    }
    else
    {
        pathname = "CANCEL";
    }

    delete config;

    wxSetWorkingDirectory(cwd);
    return string(pathname.c_str());
#endif
}

#ifdef CRY_USEMFC
int __stdcall BrowseCallbackProc(HWND hwnd, UINT uMsg, LPARAM lParam, LPARAM lpData)
{
  string* rp = (string*)(lpData);
  if (uMsg == BFFM_INITIALIZED)
  {
     (void)SendMessage(hwnd, BFFM_SETSELECTION, TRUE, (LPARAM)(LPCTSTR)rp->c_str() );
  }
  return 0;
}
#endif


void CcController::ChangeDir (string newDir)
{
#ifdef CRY_USEMFC
//      _chdir ( newDir.c_str());

  if( _chdir( newDir.c_str() )   )
  {
      char buffer[256];
      sprintf( buffer, "Unable to locate the directory: %s\n", newDir.c_str() );
      AfxGetApp()->m_pMainWnd->MessageBox(buffer,"Change dir failed",MB_OK);
  }


#else
      wxSetWorkingDirectory(newDir);

#endif
}


void CcController::CcChooseFont()
{
#ifdef CRY_USEMFC
  LOGFONT lf;
  if ( CcController::mp_inputfont != NULL )
  {
    CcController::mp_inputfont->GetLogFont( &lf );
  }
  else
  {
 #ifndef _WINNT
    HFONT hSysFont = ( HFONT )GetStockObject( ANSI_FIXED_FONT );
 #else
    HFONT hSysFont = ( HFONT )GetStockObject( DEVICE_DEFAULT_FONT );
 #endif  // !_WINNT
    CFont* pFont = CFont::FromHandle( hSysFont );
    pFont->GetLogFont( &lf );
  }

  CFontDialog fd(&lf,CF_SCREENFONTS);

  if ( fd.DoModal() == IDOK )
  {
    if( mp_inputfont ) delete( mp_inputfont );
    CcController::mp_inputfont = new CFont;
    CcController::mp_inputfont->CreateFontIndirect( &lf );
    ostringstream strstrm;
    strstrm << lf.lfHeight;
    StoreKey( "MainFontHeight", strstrm.str() );
    strstrm.str("");
    strstrm << lf.lfWidth;
    StoreKey( "MainFontWidth", strstrm.str() );
    strstrm.str("");
    strstrm << lf.lfFaceName;
    StoreKey( "MainFontFace", strstrm.str() );
    ReLayout();
  }
#else

  wxFontData data;
  wxFont* pFont = new wxFont(12,wxMODERN,wxNORMAL,wxNORMAL);

  if ( CcController::mp_inputfont == NULL )
  {
#ifndef _WINNT
    *pFont = wxSystemSettings::GetFont( wxSYS_ANSI_FIXED_FONT );
#else
    *pFont = wxSystemSettings::GetFont( wxDEVICE_DEFAULT_FONT );
#endif  // !_WINNT
   }
   else
   {
     *pFont = *CcController::mp_inputfont;
   }

   data.SetInitialFont(*pFont);

   wxWindow* top = wxGetApp().GetTopWindow();

   wxFontDialog fd( top, data );

   if ( fd.ShowModal() == wxID_OK )
   {
     wxFontData newdata = fd.GetFontData();
     *pFont = newdata.GetChosenFont();
     if( mp_inputfont ) delete( mp_inputfont );
     mp_inputfont = pFont;

     ostringstream strstrm;
     strstrm << pFont->GetNativeFontInfoDesc().c_str();
     (CcController::theController)->StoreKey( "MainFontInfo", strstrm.str() );
     ReLayout();
   }
#endif

}


int CcController::EnvVarCount( string & dir )
{
// Find the number of commas + 1 in the string.

   int nCommas = 1;
   for ( string::size_type i = 0; i < dir.length(); i++ )
   {
     if ( dir[i] == ',' ) nCommas++;
   }
   return nCommas;
}
string CcController::EnvVarExtract ( string & dir, int i )
{
// Find string following the i th comma.

   string::size_type j;
   int nCommas = 0;

// Find posn of ith comma.

   for ( j = 0; j < dir.length(); j++ )
   {
     if ( nCommas == i ) break;
     if ( dir[j] == ',' ) nCommas++;
   }

   string::size_type firstPos = CRMAX(1,j+1);

// Find posn of ith+1 comma.

   for ( j = j+1; j < dir.length(); j++ )
   {
     if ( dir[j] == ',' ) break;
   }

   string::size_type lastPos = CRMIN(dir.length(),j);

   firstPos = CRMIN (firstPos,lastPos);
   lastPos = CRMAX (firstPos,lastPos);

   string retS =  dir.substr(firstPos-1,1+lastPos-firstPos);

/*  Not used.
// Search for allowed env variables to expand:
// USERPROFILE

   int up = retS.Find("USERPROFILE:");

   if (up)
   {
      string userp ( getenv("USERPROFILE") );
      retS = retS.Sub(1,up-1) + userp + retS.Sub(up+12,-1);
   }
*/
   return retS;
}
void CcController::TimerFired()
{
   DoCommandTransferStuff();
}

bool CcController::DoCommandTransferStuff()
{
  //char theLine[255];
  bool appret = false;
  string theLine;

  if( GetInterfaceCommand(theLine) )
  {
    appret = true;
//    int theLength = 0;

//    if(theLength = strlen( theLine )) //Assignment within conditional (OK)
    if(theLine.length() > 0) //Assignment within conditional (OK)
    {
//      theLine[theLength+1]='\0';
      Tokenize(theLine);
    }
  }
  return appret;
}


  void CcController::endthread ( long theExitcode )
  {
        ostringstream strstrm;
        strstrm << "Thread ends2. Exit code is: " << theExitcode ;

        LOGSTAT (strstrm.str());
  
        if ( theExitcode != 0 && theExitcode != 1000 )
        {
           CcController::theController->m_ExitCode = theExitcode;
  #ifdef CRY_USEMFC
           if ( !CcController::theController->m_BatchMode )
           {
             MessageBox(NULL,"Closing","Crystals ends in error",MB_OK|MB_TOPMOST|MB_TASKMODAL|MB_ICONHAND);
             ASSERT(0);
           }
  #endif

  #ifdef __INW__
		    CR_EXCEPTION_INFO ei;
			memset(&ei, 0, sizeof(CR_EXCEPTION_INFO));
			ei.cb = sizeof(CR_EXCEPTION_INFO);
			ei.exctype = CR_SEH_EXCEPTION;
			ei.code = 1234;
			ei.pexcptrs = NULL;

			int result = crGenerateErrorReport(&ei);

			if(result!=0)
			{
			  // If goes here, crGenerateErrorReport() has failed
			  // Get the last error message
			  TCHAR szErrorMsg[256];
			  crGetLastErrorMsg(szErrorMsg, 256);
			}
  #endif		   
			// Manually terminate program
//			ExitProcess(0);

//  #ifdef __BOTHWX__
//           if ( !CcController::theController->m_BatchMode )
//                 wxMessageBox("Closing","Crystals ends in error",
//                               wxOK|wxICON_HAND|wxCENTRE);
//  #endif
        }

        LOGSTAT ("Really going now. Bye. " );
		#ifdef CRY_OSMAC
			m_Crystals_Thread_Alive.Leave();
			pthread_exit(0);
		#else
        if ( theExitcode != 0 && theExitcode != 1000 )
			throw CcController::MyBadException();   // Leap right out of the Fortran
		else
			throw CcController::MyException();   // Leap right out of the Fortran
												 // to the top of the call stack. 
		#endif
        LOGSTAT ("Thread ends. Execution should never get here. Odd. ");
  }


void CcController::MakeTokens(const string& str,
                deque<string>& tokens,
                const string& delimiters,
                const string& pairopen  ,
                const string& pairclose  )
{

// Find start of first token
   string::size_type nextTokenStart = str.find_first_not_of(delimiters, 0);

// Find next delimiter.
   string::size_type nextDelimStart = str.find_first_of(delimiters, nextTokenStart);

   while (string::npos != nextDelimStart || string::npos != nextTokenStart)
   {
// Found a token, check for pair opener, then add it to the vector.
     string::size_type pTStart = str.substr(nextTokenStart, nextDelimStart - nextTokenStart).find_first_of(pairopen);
     if ( pTStart != string::npos )
     {
		 pTStart += nextTokenStart;
// Find out what pair closer is
       string::size_type pTCloser = pairclose.find( str[pTStart] );
// Find closer in the string
       string::size_type pTEnd = str.find_first_of(pairclose[pTCloser],pTStart+1);
       if ( pTEnd == string::npos )
       {
// No closer found, continue as normal
         tokens.push_back(str.substr(nextTokenStart, nextDelimStart - nextTokenStart));
         LOGSTAT("No closer found. Token added: " + tokens.back() );
       }
       else
       {
         tokens.push_back(str.substr(pTStart+1, pTEnd - pTStart - 1));
         LOGSTAT("Quoted token added: " + tokens.back() );
         nextDelimStart = pTEnd + 1;
       }
     }
     else
     {
       tokens.push_back(str.substr(nextTokenStart, nextDelimStart - nextTokenStart));
       LOGSTAT("Token added: " + tokens.back() );
     }

// Find start of next token
     nextTokenStart = str.find_first_not_of(delimiters, nextDelimStart);

// Find next delimiter
     nextDelimStart = str.find_first_of(delimiters, nextTokenStart);
   }

}


int CcController::GetDescriptor( string &token, int descriptorClass )
{
//  #define DESCRIPTOR(a) if(token.compare(kS##a)==0)retVal=kT##a;
#define DESCRIPTOR(a) if(token.compare(kS##a)==0){return kT##a ;};
  
  int retVal = kTUnknown;
  switch (descriptorClass)
  {
      case kLogicalClass:
               DESCRIPTOR(Yes)
               DESCRIPTOR(No)
               DESCRIPTOR(All)
               DESCRIPTOR(Invert)
               DESCRIPTOR(On)
               DESCRIPTOR(Off)
               DESCRIPTOR(SelectRect)
               DESCRIPTOR(SelectPoly)
             break;
            
      case kAttributeClass:
               DESCRIPTOR(Default)
               DESCRIPTOR(TextSelector)
               DESCRIPTOR(Select)
               DESCRIPTOR(SelectAtoms)
               DESCRIPTOR(DisableAtoms)
               DESCRIPTOR(NumberOfColumns)
               DESCRIPTOR(NumberOfRows)
               DESCRIPTOR(OpenGrid)
               DESCRIPTOR(EndGrid)
               DESCRIPTOR(VisibleLines)
               DESCRIPTOR(Inform)
               DESCRIPTOR(Ignore)
               DESCRIPTOR(Disabled)
               DESCRIPTOR(State)
               DESCRIPTOR(On)
               DESCRIPTOR(Off)
               DESCRIPTOR(Outline)
               DESCRIPTOR(AlignIsolate)
               DESCRIPTOR(AlignRight)
               DESCRIPTOR(AlignBottom)
               DESCRIPTOR(Modal)
               DESCRIPTOR(Zoom)
               DESCRIPTOR(Pane)
               DESCRIPTOR(Frame)
               DESCRIPTOR(Close)
               DESCRIPTOR(Size)
               DESCRIPTOR(Chars)
               DESCRIPTOR(Complete)
               DESCRIPTOR(NoEcho)
               DESCRIPTOR(Menu)
               DESCRIPTOR(EndMenu)
               DESCRIPTOR(Item)
               DESCRIPTOR(MenuSplit)
               DESCRIPTOR(MenuDisableCondition)
               DESCRIPTOR(MenuEnableCondition)
               DESCRIPTOR(TitleOnly)
               DESCRIPTOR(Append)
               DESCRIPTOR(Limit)
               DESCRIPTOR(GetPolygonArea)
               DESCRIPTOR(Transparent)
               DESCRIPTOR(BitmapFile)
               DESCRIPTOR(GetCursorKeys)
               DESCRIPTOR(IsoView)
               DESCRIPTOR(WantReturn)
               DESCRIPTOR(IsInput)
               DESCRIPTOR(IntegerInput)
               DESCRIPTOR(RealInput)
               DESCRIPTOR(NoInput)
               DESCRIPTOR(SetCommitText)
               DESCRIPTOR(SetCancelText)
               DESCRIPTOR(AttachModel)
               DESCRIPTOR(RadiusType)
               DESCRIPTOR(RadiusScale)
               DESCRIPTOR(BondStyle)
               DESCRIPTOR(VDW)
               DESCRIPTOR(Normal)
               DESCRIPTOR(Part)
               DESCRIPTOR(Element)
               DESCRIPTOR(Covalent)
               DESCRIPTOR(Tiny)
               DESCRIPTOR(Thermal)
               DESCRIPTOR(Spare)
               DESCRIPTOR(SelectAction)
               DESCRIPTOR(AppendTo)
               DESCRIPTOR(SendA)
               DESCRIPTOR(SendB)
               DESCRIPTOR(SendC)
               DESCRIPTOR(SendD)
               DESCRIPTOR(SendCAndSelect)
               DESCRIPTOR(InsertIn)
               DESCRIPTOR(SetCommandText)
               DESCRIPTOR(DefinePopupMenu)
               DESCRIPTOR(ChartHighlight)
               DESCRIPTOR(EndDefineMenu)
               DESCRIPTOR(NoEdge)
               DESCRIPTOR(ChartSave)
               DESCRIPTOR(ChartSaveEnh)
               DESCRIPTOR(ChartPrint)
               DESCRIPTOR(Position)
               DESCRIPTOR(AddToList)
               DESCRIPTOR(SetSelection)
               DESCRIPTOR(SortColumn)
               DESCRIPTOR(CheckValue)
               DESCRIPTOR(Spew)
               DESCRIPTOR(Empty)
               DESCRIPTOR(Remove)
               DESCRIPTOR(RestartFile)
               DESCRIPTOR(IconInfo)
               DESCRIPTOR(IconError)
               DESCRIPTOR(IconWarn)
               DESCRIPTOR(IconQuery)
               DESCRIPTOR(NRes)
               DESCRIPTOR(Style)
               DESCRIPTOR(StyleSmooth)
               DESCRIPTOR(StyleLine)
               DESCRIPTOR(StylePoint)
               DESCRIPTOR(AutoSize)
               DESCRIPTOR(Hover)
               DESCRIPTOR(Shading)
               DESCRIPTOR(SelectTool)
               DESCRIPTOR(RotateTool)
               DESCRIPTOR(ZoomSelected)
               DESCRIPTOR(SelectFrag)
               DESCRIPTOR(LoadBitmap)
               DESCRIPTOR(Keep)
               DESCRIPTOR(Large)
               DESCRIPTOR(StayOpen)
               DESCRIPTOR(FontSelect)
               DESCRIPTOR(TextTransparent)
               DESCRIPTOR(ViewTop)
               DESCRIPTOR(Toggle)
               DESCRIPTOR(AppIcon)
               DESCRIPTOR(AddTool)
               DESCRIPTOR(Horizontal)
               DESCRIPTOR(Vertical)
               DESCRIPTOR(Both)
               DESCRIPTOR(Length)
               DESCRIPTOR(Slim)
               DESCRIPTOR(PlotPrint)
               DESCRIPTOR(PlotSave)
               DESCRIPTOR(PlotExport)
               DESCRIPTOR(Save)
               DESCRIPTOR(Load)
               DESCRIPTOR(ShowH)
             break;

      case kChartClass:
               DESCRIPTOR(ChartAttach)
               DESCRIPTOR(ChartShow)
               DESCRIPTOR(ChartLine)
               DESCRIPTOR(ChartEllipseE)
               DESCRIPTOR(ChartEllipseF)
               DESCRIPTOR(ChartClear)
               DESCRIPTOR(ChartText)
               DESCRIPTOR(ChartPolyE)
               DESCRIPTOR(ChartPolyF)
               DESCRIPTOR(ChartColour)
               DESCRIPTOR(ChartFlow)
               DESCRIPTOR(ChartChoice)
               DESCRIPTOR(ChartLink)
               DESCRIPTOR(ChartAction)
               DESCRIPTOR(ChartN)
               DESCRIPTOR(ChartS)
               DESCRIPTOR(ChartE)
               DESCRIPTOR(ChartW)

             break;

      case kPlotClass:
               DESCRIPTOR(PlotAttach)
               DESCRIPTOR(PlotShow)
               DESCRIPTOR(PlotBarGraph)
               DESCRIPTOR(PlotScatter)
               DESCRIPTOR(PlotSeries)
               DESCRIPTOR(PlotNSeries)
               DESCRIPTOR(PlotLength)
               DESCRIPTOR(PlotLabel)
               DESCRIPTOR(PlotData)
               DESCRIPTOR(PlotAuto)
               DESCRIPTOR(PlotSpan)
               DESCRIPTOR(PlotZoom)
               DESCRIPTOR(PlotLinear)
               DESCRIPTOR(PlotLog)
               DESCRIPTOR(PlotTitle)
               DESCRIPTOR(PlotSeriesName)
               DESCRIPTOR(PlotAxisTitle)
               DESCRIPTOR(PlotSeriesType)
               DESCRIPTOR(PlotAddSeries)
               DESCRIPTOR(PlotXAxis)
               DESCRIPTOR(PlotYAxis)
               DESCRIPTOR(PlotYAxisRight)
               DESCRIPTOR(PlotUseRightAxis)
               DESCRIPTOR(PlotKey)
             break;

      case kModelClass:
               DESCRIPTOR(ModelAtom)
               DESCRIPTOR(ModelBond)
               DESCRIPTOR(ModelShow)
               DESCRIPTOR(ModelCell)
               DESCRIPTOR(ModelTri)
               DESCRIPTOR(ModelClear)
             break;
            
      case kInstructionClass:
               DESCRIPTOR(CreateButton)
               DESCRIPTOR(At)
               DESCRIPTOR(CreateWindow)
               DESCRIPTOR(SysRestart)
               DESCRIPTOR(SysGetDir)
               DESCRIPTOR(SysOpenFile)
               DESCRIPTOR(SysSaveFile)
               DESCRIPTOR(CreateListBox)
               DESCRIPTOR(CreateDropDown)
               DESCRIPTOR(CreateEditBox)
               DESCRIPTOR(CreateGrid)
               DESCRIPTOR(CreateMultiEdit)
               DESCRIPTOR(CreateTextOut)
               DESCRIPTOR(CreateText)
               DESCRIPTOR(CreateIcon)
               DESCRIPTOR(CreateProgress)
               DESCRIPTOR(CreateRadioButton)
               DESCRIPTOR(CreateCheckBox)
               DESCRIPTOR(CreateChart)
               DESCRIPTOR(CreatePlot)
               DESCRIPTOR(CreateModel)
               DESCRIPTOR(CreateBitmap)
               DESCRIPTOR(ShowWindow)
               DESCRIPTOR(HideWindow)
               DESCRIPTOR(DisposeWindow)
               DESCRIPTOR(EndGrid)
               DESCRIPTOR(Set)
               DESCRIPTOR(RenameObject)
               DESCRIPTOR(GetValue)
               DESCRIPTOR(DefineMenu)
               DESCRIPTOR(EndDefineMenu)
               DESCRIPTOR(CreateChartDoc)
               DESCRIPTOR(CreateModelDoc)
               DESCRIPTOR(RedirectText)
               DESCRIPTOR(RedirectInput)
               DESCRIPTOR(RedirectProgress)
               DESCRIPTOR(CreateListCtrl)
               DESCRIPTOR(CreateModList)
               DESCRIPTOR(SetKeyValue)
               DESCRIPTOR(GetKeyValue)
               DESCRIPTOR(GetRegValue)
               DESCRIPTOR(TextSelector)
               DESCRIPTOR(Focus)
               DESCRIPTOR(Batch)
               DESCRIPTOR(FontSet)
               DESCRIPTOR(CreateTab)
               DESCRIPTOR(CreateWeb)
               DESCRIPTOR(CreateTabCtrl)
               DESCRIPTOR(CreateToolBar)
               DESCRIPTOR(CreateResize)
               DESCRIPTOR(CreateStretch)
               DESCRIPTOR(CreateHidden)
               DESCRIPTOR(CreatePlotData)
               DESCRIPTOR(SafeSet)
               DESCRIPTOR(OpenGroup)
               DESCRIPTOR(CloseGroup)
             break;
            
      case kStatusClass:
               DESCRIPTOR(UnSetStatus)
               DESCRIPTOR(SetStatus)
             break;

            
      case kPositionClass:
               DESCRIPTOR(Row)
               DESCRIPTOR(Column)
               DESCRIPTOR(Column)
             break;

      case kPositionalClass:
               DESCRIPTOR(RightOf)
               DESCRIPTOR(LeftOf)
               DESCRIPTOR(Above)
               DESCRIPTOR(Below)
               DESCRIPTOR(Cascade)
               DESCRIPTOR(Centred)
             break;
            
      case kPanePositionClass:
               DESCRIPTOR(Right)
               DESCRIPTOR(Left)
               DESCRIPTOR(Top)
               DESCRIPTOR(Bottom)
               DESCRIPTOR(Centre)
             break;

      case kQueryClass:
               DESCRIPTOR(QExists)
               DESCRIPTOR(QListtext)
               DESCRIPTOR(QText)
               DESCRIPTOR(QModified)
               DESCRIPTOR(QListrow)
               DESCRIPTOR(QListitem)
               DESCRIPTOR(QNselected)
               DESCRIPTOR(QSelected)
               DESCRIPTOR(QState)
               DESCRIPTOR(QNLines)
               DESCRIPTOR(QAtomStyle)
               DESCRIPTOR(QBondStyle)

      default:
               DESCRIPTOR(Null)
             break;
  }
  return retVal;
}


//////////////////////////////
//   STATIC C FUNCTIONS     //
//////////////////////////////


extern "C" {

  void callccode ( char* theLine)
  {
      string temp =  theLine ;    // To be deleted later by the queue.
      string::size_type strim = temp.find_last_not_of(" ");
      if ( strim != string::npos ) temp = temp.substr(0,strim+1);
      (CcController::theController)->AddInterfaceCommand( temp );
  }

  void getcenv ( char* key, char* value)
  {
	  char* v;
	  v = getenv(key);
	  if ( v ) strcpy(value,v);
  }

  void guexec ( char* theLine)
  {
	// Convert to a wchar_t*
//#ifdef __GID__
//    char * tempstr = new char[263];
//    memcpy(tempstr,theLine,262);
//    *(tempstr+262) = '\0';
//    wstring line(tempstr);

//    size_t origsize = strlen(theLine) + 1;
//    const size_t newsize = 263;
//    _TCHAR tempstr[newsize];


//    towcs(tempstr, theLine,  origsize);
//    tstring line = tstring(theLine);
//  (CcController::theController)->AddInterfaceCommand( "Line: " + line );
//  (CcController::theController)->AddInterfaceCommand( "theLine: " + tstring(theLine) );


//#elif defined(CRY_OSWIN32)
//    size_t origsize = strlen(theLine) + 1;
//    const size_t newsize = 263;
//    size_t convertedChars = 0;
//    _TCHAR tempstr[newsize];
//    mbstowcs_s(&convertedChars, tempstr, origsize, theLine, _TRUNCATE);
//    wstring line = wstring(tempstr);
//#else
    string line = string(theLine);
//#endif    

	

    tstring::size_type strim = line.find_last_not_of(' '); //Remove trailing spaces

    if ( strim != string::npos )
        line = line.substr(0,strim+1);
//   delete [] tempstr;
//    tempstr = NULL;

//  (CcController::theController)->AddInterfaceCommand( "Launching: " + line );

    bRedir = false;
    bool bWait = false;
    bool bRest = false;
    tstring::size_type sFirst,eFirst,sRest,eRest;

    sFirst = line.find_first_not_of(' ');     // Find first non-space.
    if ( sFirst == string::npos ) sFirst = 0;

    if ( line[sFirst] == '+' )                // Check for + symbol (signifies 'wait')
    {
       bWait = true;
// Find next non space ( in case + is seperated from first word ).
       sFirst = line.find_first_not_of(' ',sFirst+1);
       if ( sFirst == string::npos ) sFirst = 0; // should not happen unless no content in string
    }
    else if ( line[sFirst] == '%' )  // Check for % symbol (signifies 'redirect STDIN and OUT')
    {
       bRedir = true;
// Find next non space ( in case + is seperated from first word ).
       sFirst = line.find_first_not_of(' ',sFirst+1);
       if ( sFirst == string::npos ) sFirst = 0;
    }
// sFirst now points to the beginning of the command.

    if ( line[sFirst] == '"' ) 
    {
       sFirst++; //Move to after 1st quote.
       eFirst = line.find_first_of('"',sFirst);   // Find next quote.
       if ( eFirst == string::npos ) eFirst = line.length();
    }
    else                        // Find next space ( after the first word )
    {
       eFirst = line.find_first_of(' ',sFirst);
       if ( eFirst == string::npos ) eFirst = line.length();
    }

    tstring firstTok = line.substr(sFirst,eFirst-sFirst);
    tstring restLine;

//        LOGERR(firstTok);

// Find next non space and last non space 
    sRest = line.find_first_not_of(' ',eFirst+1);
    eRest = line.find_last_not_of(' ');


    if ( sRest != string::npos )
    {
      bRest = true;
      eRest = eRest - sRest + 1;
      eRest = CRMAX ( 1, eRest );  // ensure positive length
      restLine = line.substr(sRest, eRest);
    }

//        LOGERR(restLine);

        tstring totalcl = firstTok;
        totalcl += " ";
        totalcl += restLine;
//        LOGERR(totalcl);

#ifdef CRY_OSWIN32

    if ( bWait )
    {
// Launch with ShellExecute function. Then wait for app.
//Special case html files with a # anchor reference after file name:
      string::size_type match = firstTok.find('#');
      if ( match != string::npos ) {
         char buf[MAX_PATH];
         tstring tempfile = firstTok.substr(0,match);
         if ( (uintptr_t)FindExecutableA(tempfile.c_str(),NULL,buf) >= 32) {
            restLine = firstTok + restLine;
            bRest = true;
            firstTok = buf;
         }
      }

//Special case http urls:
      tstring lFirstTok = firstTok; 
#ifdef _UNICODE
      std::transform( lFirstTok.begin(), lFirstTok.end(), lFirstTok.begin(), ::towlower );
#else
      std::transform( lFirstTok.begin(), lFirstTok.end(), lFirstTok.begin(), ::tolower );
#endif
      match = lFirstTok.find("http://");
      if ( match == 0 )
      {
         restLine = "url.dll,FileProtocolHandler " + firstTok + " "+ restLine;
         bRest = true;
         firstTok = "rundll32.exe";
       }



      SHELLEXECUTEINFOA si;

      si.cbSize       = sizeof(si);
      si.fMask        = SEE_MASK_NOCLOSEPROCESS|SEE_MASK_FLAG_NO_UI ;
      si.hwnd         = GetDesktopWindow();
      si.lpVerb       = "open";
      si.lpFile       = firstTok.c_str();
      si.lpParameters = ( (bRest)? restLine.c_str() : NULL );
      si.lpDirectory  = NULL;
      si.nShow        = SW_SHOWNORMAL;

      int err = (int)ShellExecuteExA ( & si );

      if ( (uintptr_t)si.hInstApp == SE_ERR_NOASSOC )
      {
        (CcController::theController)->AddInterfaceCommand( "File has no association. Retrying." );
        tstring newparam = tstring("shell32.dll,OpenAs_RunDLL ")+firstTok+( (bRest) ? " " + restLine : "" ) ;
        si.lpFile       = "rundll32.exe";
        si.lpParameters = newparam.c_str();
        si.fMask        = SEE_MASK_NOCLOSEPROCESS; //Don't mask errors for this call.
        ShellExecuteExA ( & si );
// It is not possible to wait for rundll32's spawned process, so
// we just pop up a message box, to hold this app here.
 #ifdef CRY_USEMFC
        AfxGetApp()->m_pMainWnd->MessageBox("CRYSTALS is waiting.\nClick OK when external application has exited.",
                                            "#SPAWN: Waiting",MB_OK);
 #endif

        CcController::theController->AddInterfaceCommand( " ");
        stringstream t;
        t << "     {0,2 Waiting for {2,0 " << firstTok.c_str() << " {0,2 to finish... ";
        CcController::theController->AddInterfaceCommand( t.str() );
        CcController::theController->AddInterfaceCommand( " ");
        WaitForSingleObject( si.hProcess, INFINITE );
        CcController::theController->AddInterfaceCommand( "                                                               {0,2 ... Done");
        CcController::theController->AddInterfaceCommand( " ");
      }
      else if ( (uintptr_t)si.hInstApp <= 32 )
      {
        (CcController::theController)->AddInterfaceCommand( "Could not launch as Win process. Trying command prompt.");

        tstring newparam = tstring("/c ")+firstTok+( (bRest) ? " " + restLine : "" ) ;
        si.cbSize       = sizeof(si);
        si.fMask        = SEE_MASK_NOCLOSEPROCESS|SEE_MASK_FLAG_NO_UI ;
        si.hwnd         = GetDesktopWindow();
        si.lpVerb       = "open";
        if ( IsWinNT() )
          si.lpFile       = "cmd.exe";
        else
          si.lpFile       = "command.com";
        si.lpParameters = newparam.c_str();
        si.lpDirectory  = NULL;
        si.nShow        = SW_SHOWNORMAL;
 
        err = (int)ShellExecuteExA ( & si );

        if ( (uintptr_t)si.hInstApp > 32 ) {
          CcController::theController->AddInterfaceCommand( " ");
          stringstream t;
          t << "     {0,2 Waiting for {2,0 " << firstTok.c_str() << " {0,2 to finish... ";
          CcController::theController->AddInterfaceCommand( t.str() );
          CcController::theController->AddInterfaceCommand( " ");
          WaitForSingleObject( si.hProcess, INFINITE );
          CcController::theController->AddInterfaceCommand( "                                                               {0,2 ... Done");
          CcController::theController->AddInterfaceCommand( " ");
        }

/*
// Some other failure. Try another method of starting external programs.
  //      CcController::theController->AddInterfaceCommand( "{I Failed to start " + firstTok + ", (security or not found?) trying another method.");
        extern int errno;
        char * str = new char[257];
        memcpy(str,line.substr(sFirst,line.length()-sFirst).c_str(),256);
        *(str+256) = '\0';

        char* args[10];       // This allows a maximum of 9 command line arguments

        for (int i=0;i<10;i++) args[i]=NULL;


        char seps[] = " \t";
        char *token = strtok( str, seps );
        args[0] = token;
        for (int i = 1; (( token != NULL ) && ( i < 10 )); i++ )
        {                                                                     
          token = strtok( NULL, seps );
          args[i] = token;
        }

        LOGERR(string(args[0]?args[0]:"")+" "+
                  string(args[1]?args[1]:"") + " " +  string(args[2]?args[2]:"")+" "+
                  string(args[3]?args[3]:"") + " " +  string(args[4]?args[4]:"")+" ...etc...");

        int result = _spawnvp(_P_WAIT, args[0], args);
  
        if ( result == -1 )  //Start failed
        {
          ostringstream strstrm;
          strstrm << "{I Failed again to start " << firstTok << ", errno is:" << errno << " trying a command shell.";
          CcController::theController->AddInterfaceCommand(strstrm.str());
          for (int ij = 7; ij>=0; ij--)
          {
             args[ij+2] = args[ij];
          }

          if ( IsWinNT() )
            args[0] = "cmd.exe";
          else
            args[0] = "command.com" ;

          args[1] = "/c";

          result = _spawnvp(_P_WAIT, args[0], args);
          LOGERR("Args: "+string(args[0])+" "+
                  string(args[1]?args[1]:"") + " " +  string(args[2]?args[2]:"")+" "+
                  string(args[3]?args[3]:"") + " " +  string(args[4]?args[4]:"")+" ...etc...");

          strstrm.str("");
          strstrm << "{I Failed yet again. Errno is:" << errno << ". Giving up.";

          if ( result != 0 ) LOGERR ( strstrm.str() );
          else LOGERR("Might have worked.");
        }

        delete [] str;
*/
      }
      else
      {
        CcController::theController->AddInterfaceCommand( " ");
        stringstream t;
        t << "     {0,2 Waiting for {2,0 " << firstTok.c_str() << " {0,2 to finish... ";
        CcController::theController->AddInterfaceCommand( t.str() );
        CcController::theController->AddInterfaceCommand( " ");
        WaitForSingleObject( si.hProcess, INFINITE );
        CcController::theController->AddInterfaceCommand( "                                                               {0,2 ... Done");
        CcController::theController->AddInterfaceCommand( " ");
      }
    }
    else if ( bRedir )
    {
      STARTUPINFOA si;
      SECURITY_ATTRIBUTES sa;
      SECURITY_DESCRIPTOR sd;               //security information for pipes
      if (IsWinNT())        //initialize security descriptor (Windows NT)
      {
        InitializeSecurityDescriptor(&sd,SECURITY_DESCRIPTOR_REVISION);
        SetSecurityDescriptorDacl(&sd, true, NULL, false);
        sa.lpSecurityDescriptor = &sd;
      }
      else sa.lpSecurityDescriptor = NULL;
      sa.nLength = sizeof(SECURITY_ATTRIBUTES);
      sa.bInheritHandle = true;         //allow inheritable handles
      CcPipe inPipe(sa);
      if ( ! inPipe.CreateOK ) {
        CcController::theController->AddInterfaceCommand( "Error creating in pipe.");
        return;
      }
      CcPipe outPipe(sa);
      if ( ! outPipe.CreateOK ) {
        CcController::theController->AddInterfaceCommand( "Error creating out pipe.");
        return;
      }

      GetStartupInfoA(&si);      //set startupinfo for the spawned process
      si.dwFlags = STARTF_USESTDHANDLES|STARTF_USESHOWWINDOW;
      si.wShowWindow = SW_HIDE;
      si.hStdOutput = outPipe.input;
      si.hStdError = outPipe.input;     //set the new handles for the child process
      si.hStdInput = inPipe.output;
//      #(totalcl);
      CcProcessInfo pi(firstTok,si,totalcl);
      if (!pi.CreateOK)
      {
        CcController::theController->AddInterfaceCommand( "Error creating process.");
        return;
      }

      unsigned long exit=0;  //process exit code
      unsigned long bread;   //bytes read
      unsigned long avail;   //bytes available

// Disable all menus etc.
      CcController::theController->AddInterfaceCommand( "^^ST STATSET IN");
      CcController::theController->AddInterfaceCommand( "^^CR");
      CcController::theController->m_AllowThreadKill = false;

      char buf[1024];           //i/o buffer
      BZERO(buf);
	  string keep = "";
      for(;;)      //main program reading/writing loop
      {
        PeekNamedPipe(outPipe.output,buf,1023,&bread,&avail,NULL);
        while ( bread != 0 )
        {
          BZERO(buf);
          ReadFile(outPipe.output,buf,1023,&bread,NULL);  //read the stdout pipe
          string s(buf);
          string::size_type i;
          while ( ( i = s.find_first_of("\r") ) != string::npos ) {
            s.erase(i,1);    //Remove \r
          }

		  keep = keep + s;
          for(;;) {
            string::size_type strim = keep.find_first_of("\n");
            if ( strim == string::npos )
            {
//              CcController::theController->AddInterfaceCommand("{0,1 " + s);
              break;
            }
            CcController::theController->AddInterfaceCommand("{0,1 " + keep.substr(0,strim));
            keep.erase(0,strim+1);
          }
          BZERO(buf);
          PeekNamedPipe(outPipe.output,buf,1023,&bread,&avail,NULL);
        }

        GetExitCodeProcess(pi.proc.hProcess,&exit);      //while the process is running
        if (exit != STILL_ACTIVE)  break;

        bool wait = false;
 
        (CcController::theController)->GetCrystalsCommand(*&buf,wait);
        if ( wait ) {
           string s(buf);
           s.erase(s.find_last_not_of(" ")+1,s.length());
           if ( s.substr(0,11) == "_MAIN CLOSE" )
           {
             UINT uexit=0;
             TerminateProcess(pi.proc.hProcess, uexit);
             CloseHandle(pi.proc.hThread);
             CloseHandle(pi.proc.hProcess);
             CcController::theController->AddInterfaceCommand("{0,2 Process terminated.");
             break;
           }
           CcController::theController->AddInterfaceCommand("{0,1 " + s);
           WriteFile(inPipe.input,s.c_str(),s.length(),&bread,NULL); //send it to stdin
           WriteFile(inPipe.input,"\n",1,&bread,NULL); //send an extra newline char
        }
      }

// Dregs of output
      CcController::theController->AddInterfaceCommand("{0,2 " + keep);

// Reenable all menus
      CcController::theController->AddInterfaceCommand( "^^ST STATUNSET IN");
      CcController::theController->AddInterfaceCommand( "^^CR");
      CcController::theController->m_AllowThreadKill = true;
    }
    else
    {
// Launch with ShellExecute function. There is no waiting for apps to finish.

//Special case html files with a # anchor reference after file name:
      string::size_type match = firstTok.find('#');
      if ( match != string::npos ) {
         char buf[MAX_PATH];
         tstring tempfile = firstTok.substr(0,match);
         if ( (uintptr_t)FindExecutableA(tempfile.c_str(),NULL,buf) >= 32) {
            restLine = firstTok + restLine;
            bRest = true;
            firstTok = buf;
         }
      }
//Special case http urls:
      tstring lFirstTok = firstTok; 
#ifdef _UNICODE
      std::transform( lFirstTok.begin(), lFirstTok.end(), lFirstTok.begin(), ::towlower );
#else
      std::transform( lFirstTok.begin(), lFirstTok.end(), lFirstTok.begin(), ::tolower );
#endif
      match = lFirstTok.find("http://");
      if ( match == 0 )
      {
         restLine = "url.dll,FileProtocolHandler " + firstTok + " "+ restLine;
         bRest = true;
         firstTok = "rundll32.exe";
       }


      HINSTANCE ex = ShellExecuteA( GetDesktopWindow(),
                                   "open",
                                   firstTok.c_str(),
                                   ( (bRest)? restLine.c_str() : NULL ),
                                   NULL,
                                   SW_SHOWNORMAL);

      if ( (uintptr_t)ex == SE_ERR_NOASSOC )
      {
        (CcController::theController)->AddInterfaceCommand( "File has no association. Retrying." );
         ShellExecuteA( GetDesktopWindow(),
                       "open",
                       "rundll32.exe",
                       tstring("shell32.dll,OpenAs_RunDLL "+firstTok).c_str(),
                       NULL,
                       SW_SHOWNORMAL);
      }
      else if ( (uintptr_t)ex <= 32 )
      {

        (CcController::theController)->AddInterfaceCommand( "Could not launch Win process. Trying command prompt." );

        tstring newparam = tstring("/c ")+firstTok+( (bRest) ? " " + restLine : "" ) ;
        if ( IsWinNT() )
           ShellExecuteA( GetDesktopWindow(),
                       "open",
                       "cmd.exe",
                       newparam.c_str(),
                       NULL,
                       SW_SHOWNORMAL);
        else
           ShellExecuteA( GetDesktopWindow(),
                       "open",
                       "command.com",
                       newparam.c_str(),
                       NULL,
                       SW_SHOWNORMAL);

/*
// Some other failure. Try another method of starting external programs.
        extern int errno;
        char * str = new char[257];
        memcpy(str,line.substr(sFirst,line.length()-sFirst).c_str(),256);
        *(str+256) = '\0';

        char* args[10];       // This allows a maximum of 9 command line arguments

        char seps[] = " \t";
        char *token = strtok( str, seps );
        args[0] = token;
        for ( int i = 1; (( token != NULL ) && ( i < 10 )); i++ )
        {
          token = strtok( NULL, seps );
          args[i] = token;
        }

        int result = _spawnvp(_P_WAIT, args[0], args);
  
        if ( result == -1 )  //Start failed
        {
          for (int ij = 7; ij>=0; ij--)
          {
             args[ij+2] = args[ij];
          }

          if ( IsWinNT() )
            args[0] = "cmd.exe";
          else
            args[0] = "command.com" ;

          args[1] = "/c";
          result = _spawnvp(_P_WAIT, args[0], args);

          ostringstream strstrm;
          strstrm << "{I Failed yet again. Errno is:" << errno << ". Giving up.";
          if ( result != 0 ) { TEXTOUT ( strstrm.str() ); }
        }
        delete [] str;
*/ 
	}
	    }
#endif

#if defined(__WXGTK__) || defined(__WXMAC__)
// Check if this might be a filename, and if so find application to
// open it with.

    wxString fullname(firstTok.c_str());
    wxString path, name, extension, command;
//    ::wxSplitPath(firstTok.c_str(),&path,&name,&extension);
    wxFileName::SplitPath(firstTok.c_str(),&path,&name,&extension);
    wxFileType * filetype = wxTheMimeTypesManager->GetFileTypeFromExtension(extension);

    if ( filetype && filetype->GetOpenCommand(&command, wxFileType::MessageParameters(fullname,_T("")) ) )
    {
        line = string(command.c_str()) + " " + line;
        std::cerr << "\nGUEXEC: Found handler app: " << line.c_str() << "\n";
    }

    if ( bWait )
    {
      (CcController::theController)->AddInterfaceCommand( "     {0,2 Waiting for {2,0 " + firstTok + " {0,2 to finish... ");
    }
    else if ( bRedir )
    {
      (CcController::theController)->AddInterfaceCommand( "     {0,2 Starting {2,0 " + firstTok + " {0,2 interactively. ");
    }
    else
    {
      (CcController::theController)->AddInterfaceCommand( "     {0,2 Starting {2,0 " + firstTok + " {0,2 ");
    }

    extern int errno;
    char * cmd = new char[257];
    char * str = new char[257];
    memcpy(cmd,firstTok.c_str(),256);
    memcpy(str,restLine.c_str(),256);
    *(str+256) = '\0';
    *(cmd+256) = '\0';
    char* args[10];       // This allows a maximum of 9 command line arguments
    char seps[] = " \t";
    args[0] = cmd;
    char *token = strtok( str, seps );
    args[1] = token;
    for ( int i = 2; (( token != NULL ) && ( i < 10 )); i++ )
    {
      token = strtok( NULL, seps );
      args[i] = token;
    }


    if ( bRedir )
    {
      int ftoChild[2];
      int ftoParent[2];

      if ( pipe(ftoChild) < 0 ) { 
        std::cerr << "GUEXEC: Pipe 1 failed: " << "\n";
        delete [] str;
        delete [] cmd;
        return;
      }
      if ( pipe(ftoParent) < 0 ) { 
        std::cerr << "GUEXEC: Pipe 2 failed: " << "\n";
        close(ftoChild[0]);
        close(ftoChild[1]);
        delete [] str;
        delete [] cmd;
        return;
      }
      if ( fcntl(ftoParent[0],F_SETFL,O_NONBLOCK) == -1 ) {
        std::cerr << "GUEXEC: Pipe 2 switch to Non-blocking failed: " << "\n";
        close(ftoParent[0]);
        close(ftoParent[1]);
        close(ftoChild[0]);
        close(ftoChild[1]);
        delete [] str;
        delete [] cmd;
        return;
      }
     
      int fd;
      pid_t pid = fork();

      if ( pid == 0 ) {          //We're in the child process.
       close(ftoChild[1]);
       close(ftoParent[0]);
       if ( dup2(ftoChild[0],  0) < 0 ) {
         std::cerr << "\nGUEXEC: Child. Failed to dup2 to stdin...\n";
       }
       close(ftoChild[0]);
       if ( dup2(ftoParent[1], 1) < 0 ) {
         std::cerr << "\nGUEXEC: Child. Failed to dup2 to stdout...\n";
       }
       if ( dup2(ftoParent[1], 2) < 0 ) {
         std::cerr << "\nGUEXEC: Child. Failed to dup2 to stderr...\n";
       }
       close(ftoParent[1]);

       std::cerr << "\nGUEXEC: Child. Execing...\n";
       int err = execvp( args[0], args );
       std::cerr << "GUEXEC: Something went wrong: " << err <<"\n";
       std::cerr << "GUEXEC: ERRNO: "<< errno << "\n";
       _exit(-1);
      }

// We're in the parent process
      close(ftoChild[0]);
      close(ftoParent[1]);
      std::cerr << "GUEXEC: Parent.\n";

      unsigned long exit=0;  //process exit code
      unsigned long bread;   //bytes read
      unsigned long avail;   //bytes available

// Disable all menus etc.
      CcController::theController->AddInterfaceCommand( "^^ST STATSET IN");
      CcController::theController->AddInterfaceCommand( "^^CR");
      CcController::theController->m_AllowThreadKill = false;

      char buf[1024];           //i/o buffer
      BZERO(buf);
      for(;;)      //main program loop
      {
        int bread = -1;
        while ( 1 )
        {
          BZERO(buf);
          bread = read(ftoParent[0],buf,1023);  //read the stdout pipe
          if ( bread <= 0 ) break;
          string s(buf);
          string::size_type i;
          while ( ( i = s.find_first_of("\r") ) != string::npos ) {
            s.erase(i,1);    //Remove \r
          }

          for(;;) {
            string::size_type strim = s.find_first_of("\n");
            if ( strim == string::npos )
            {
              CcController::theController->AddInterfaceCommand("{0,1 " + s);
              break;
            }
            CcController::theController->AddInterfaceCommand("{0,1 " + s.substr(0,strim));
            s.erase(0,strim+1);
          }
          BZERO(buf);
        }


        int status;
        if ( waitpid(pid, &status, WNOHANG) != 0 ) {
          std::cerr << "GUEXEC: Detected child process exited\n" ;
          (CcController::theController)->AddInterfaceCommand( "     {0,2 Process has exited. ");
          break;
        }


        bool wait = false;
 
        (CcController::theController)->GetCrystalsCommand(*&buf,wait);
        if ( wait ) {
           string s(buf);
           s.erase(s.find_last_not_of(" ")+1,s.length());
           if ( s.substr(0,11) == "_MAIN CLOSE" )
           {
             UINT uexit=0;
             kill(pid,9);
             CcController::theController->AddInterfaceCommand("{0,2 Process terminated.");
             break;
           }
           CcController::theController->AddInterfaceCommand("{0,1 " + s);
           write(ftoChild[1],s.c_str(),s.length()); //send it to stdin
           write(ftoChild[1],"\n",1); //send an extra newline char
        }

      }

// Reenable all menus
      CcController::theController->AddInterfaceCommand( "^^ST STATUNSET IN");
      CcController::theController->AddInterfaceCommand( "^^CR");
      CcController::theController->m_AllowThreadKill = true;
    }
    else
    {

      pid_t pid = fork();

      if ( pid == 0 ) {          //We're in the child process.
       std::cerr << "\nGUEXEC: Child. Execing...\n";
       int err = execvp( args[0], args );
       std::cerr << "GUEXEC: Arg 0 was: " << args[0] << "\n";
       std::cerr << "GUEXEC: Something went wrong: " << err <<"\n";
       std::cerr << "GUEXEC: ERRNO: "<< errno << "\n";
       _exit(-1);
      }
// We're in the parent process

      std::cerr << "GUEXEC: Parent.\n";

      if ( bWait )
      {
          std::cerr << "\n\nGUEXEC: Parent. Waiting.\n";
          waitpid(pid,NULL,0);

          (CcController::theController)->AddInterfaceCommand( "                                                               {0,2 ... Done");

      }
      std::cerr << "\n\nGUEXEC: Done.\n";

    }

    delete [] str;
    delete [] cmd;
	    return;
#endif
  }

  void cinextcommand ( long *theStatus, char *theLine )
  {
      NOTUSED(theStatus);
      bool temp = true;
      if((CcController::theController)->GetCrystalsCommand( theLine, temp ))
      {
          int ilen = strlen(theLine);

          for (int j = ilen; j<256; j++)   //Pad with blanks.
          {
              *(theLine + j) = ' ';
          }
          *(theLine+256) = '\0';

      }
      else
      {
         CcController::theController->endthread ( 0 );
      }
  }

  void    ciendthread (long theExitcode )
  {
// Scope this bit or it appears to leak a tiny bit of memory.
       {
         ostringstream strstrm;
         strstrm << "Thread ends1. Exit code is: " << theExitcode ;
         LOGSTAT (strstrm.str());
       }
       CcController::theController->endthread ( theExitcode );
  }


#ifdef CRY_OSWIN32
  bool IsWinNT()
  {
    OSVERSIONINFO o;
    o.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
    GetVersionEx(&o);
    return ( o.dwPlatformId == VER_PLATFORM_WIN32_NT );
  }
#endif
} // end of C functions



// Functions that are called from the CRYSTALS thread:
bool CcController::GetCrystalsCommand( char * line, bool & bGuexec )
//-----------------------------------------------------
{
//This is where the Crystals thread will spend most of its time.
//Waiting for the user to do somethine.
	if (mThisThreadisDead) return false;
		string tNextCommand;
	
	strcpy( line, "" );
	if ( bGuexec ) 
		try
		{
			tNextCommand = mCrystalsCommandDeq.pop_front();		
		}
		catch (const exception& e)
		{
		
			std::cerr << "This shouldn't have happened. " << e.what() << endl;
		}
	else 
	{
		try
		{
			tNextCommand = mCrystalsCommandDeq.pop_front(200);
			bGuexec = true;
		}
		catch (const semaphore_timeout& e)
		{
			bGuexec = false;
			return true;
		}
	}
	strcpy( line, tNextCommand.c_str());
	  LOGSTAT("-----------Crystals thread: Got command: "+ string(line));
  if (mThisThreadisDead) return false;
  return (true);
}

