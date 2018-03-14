////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcStatus

////////////////////////////////////////////////////////////////////////

//   Filename:  CcStatus.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.9  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.8  2004/07/02 15:10:13  rich
//   Fixed conditional enabling and disabling of menu and toolbar items.
//
//   Revision 1.7  2004/06/28 13:26:57  rich
//   More Linux fixes, stl updates.
//
//   Revision 1.6  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.5  2002/01/31 14:39:36  ckp2
//   RIC: SetBondType function for ccstatus. Allows popup-menus to vary depending on
//   the bond type that has been clicked on.
//
//   Revision 1.4  2001/06/17 15:18:26  richard
//   Notice when scripts exit (status bit 5 changes) and call ScriptsExited to
//   close any modal windows that have been accidentally left open. Windows with
//   the STAYOPEN property (notably the MAIN window) are exempt.
//
//   Revision 1.3  2001/03/08 15:22:11  richard
//   New flag signalling that the model window is in a ZOOMED in state.
//   Call to UpdateToolbars, when status changes, updates toolbar buttons, normal
//   buttons and windows with the DISABLEIF, ENABLEIF flags.
//

#ifndef     __CcStatus_H__
#define     __CcStatus_H__
//Insert your own code here.

//End of user code.

//Updated by crystals thread.
#define bS0     "L1"
#define bS1     "L2"
#define bS2     "L3"
#define bS3     "L5"
#define bS4     "L6"
#define bS5     "IN"
#define bS6     "QS"
#define bS7     "PT"
/*
 #define bS8
 #define bS9
 #define bS10
 #define bS11
 #define bS12
 #define bS13
 #define bS14
 #define bS15
*/

//Reserved for interface.
#define bS16    "SEL0"
#define bS17    "SEL1"
#define bS18    "SEL2"
#define bS19    "SEL3"
#define bS20    "SEL>=3"
#define bS21    "ZOOMED"
#define bS22    "BN"
#define bS23    "BS"
#define bS24    "BA"
#define bS25    "HYD"
/*
 #define bS26
 #define bS27
 #define bS28
 #define bS29
 #define bS30
 #define bS31
*/


#define BOND_NORM 1
#define BOND_SYMM 2
#define BOND_AROMATIC 3

#include <string>
#include <deque>
using namespace std;


//There is only one CcStatus object, it belongs to CcController.

class   CcStatus
{
  public:

// methods

    CcStatus();
    ~CcStatus();

// sets and unsets flags as notified by CRYSTALS.

    void ParseInput(deque<string> & tokenList);


// sets and unsets flags as notified by the MODEL VIEW.

    void SetNumSelectedAtoms(int n);
    void SetZoomedFlag(bool zoomed);

    void SetBondType(int bt);
    void SetAtomFlags(string s);

// Creates a bit flag for menu items/toolbars based on the
// ENABLEIF and DISABLEIF strings they are passed.

    int CreateFlag(const string & theFlags);

// Checks a menu/toolbar item against the current status to determine
// whether it should be enabled.

    bool ShouldBeEnabled(int enableFlags, int disableFlags);

  private:

//methods
    int GetBitByToken(string & token);
    void UnSetBit(int i, int* theFlags);
    void SetBit(int i, int* theFlag);
    void UpdateToolBars();
    void ScriptsExited();

//attributes
    int statusFlags;

};

#define kSSetStatus     "STATSET"
#define kSUnSetStatus       "STATUNSET"

enum
{
 kTSetStatus = 500,
 kTUnSetStatus
};


#endif
