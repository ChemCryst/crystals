////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGroupBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGroupBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.9  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.8  2003/01/14 10:27:18  rich
//   Bring all sources up to date on Linux. Still not working: Plots, ModList, ListCtrl
//
//   Revision 1.7  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.6  2001/03/08 16:44:09  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxGroupBox_H__
#define     __CxGroupBox_H__
#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASEGROUPBOX CButton
#else
 #include <wx/statbox.h>
 #define BASEGROUPBOX wxStaticBox
#endif

class CrGrid;
class CxGrid;
class CxGroupBox;

class CxGroupBox : public BASEGROUPBOX
{
    public:
        // methods
        static CxGroupBox * CreateCxGroupBox( CrGrid * container, CxGrid * guiParent );
            CxGroupBox( CrGrid * container );
            ~CxGroupBox();
        void    SetText( const string & text );
        void    SetGeometry( int top, int left, int bottom,  int right );
        static int AddGroupBox( void) { mGroupBoxCount++; return mGroupBoxCount; };
        static void RemoveGroupBox( void) { mGroupBoxCount--; };

        // attributes
        static int mGroupBoxCount;

#ifdef CRY_USEMFC
    protected:
        afx_msg BOOL OnEraseBkgnd(CDC* pDC);
        DECLARE_MESSAGE_MAP()
#endif
};
#endif
