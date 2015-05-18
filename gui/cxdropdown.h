////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxDropDown

////////////////////////////////////////////////////////////////////////

//   Filename:  CxDropDown.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.10  2003/06/19 16:40:30  rich
//   Allow DropDown listboxes to be disabled from SCRIPT.
//
//   Increase minimum height of dropdown listbox on Windows, as
//   it wasn't quite high enough.
//
//   Revision 1.9  2002/07/25 16:00:13  richard
//
//   Resize dropdown listbox if number of items changes.
//
//   Revision 1.8  2001/06/17 14:44:39  richard
//   CxDestroyWindow function.
//
//   Revision 1.7  2001/03/08 16:44:08  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxDropDown_H__
#define     __CxDropDown_H__
//Insert your own code here.
#include    "crguielement.h"

/*#ifdef __POWERPC__
class LStdPopupMenu;
#endif*/

#ifdef __MOTO__
#include    <LStdControl.h>
#endif

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASEDROPDOWN CComboBox
#else
 #include <wx/choice.h>
 #define BASEDROPDOWN wxChoice
#endif


class CrDropDown;
class CxGrid;
//End of user code.

class CxDropDown : public BASEDROPDOWN
{
    public:
        string GetDropDownText(int index);
        int mItems;
        void Focus();
        static CxDropDown * CreateCxDropDown( CrDropDown * container, CxGrid * guiParent );
            CxDropDown( CrDropDown * container );
            ~CxDropDown();
        void    AddItem( const string & text );
        void CxDestroyWindow();
            void  CxSetSelection ( int select );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        void    Disable (bool disable);
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        int GetDroppedHeight();
        static int  AddDropDown( void ) { mDropDownCount++; return mDropDownCount; };
        static void RemoveDropDown( void ) { mDropDownCount--; };
        void BroadcastValueMessage( void );
        int GetDropDownValue();
        void CxRemoveItem ( int select );
        void ResetHeight ( );


        // attributes
        CrGUIElement *  ptr_to_crObject;
        static int  mDropDownCount;

#ifdef CRY_USEMFC
        void    Selected();
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#else
		void Selected(wxCommandEvent & e);
		void OnChar(wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif


};
#endif
