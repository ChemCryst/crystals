////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGrid

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGrid.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.14  2011/05/16 10:56:32  rich
//   Added pane support to WX version. Added coloured bonds to model.
//
//   Revision 1.13  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.12  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.11  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.10  2001/07/16 07:31:45  ckp2
//   Process ON_CHAR messages - result in passing keypress to current input editbox. Now
//   whole interface is much easier to start typing from.
//
//   Revision 1.9  2001/06/17 14:42:00  richard
//   CxDestroyWindow function.
//
//   Revision 1.8  2001/03/08 16:44:08  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

#ifndef     __CxGrid_H__
#define     __CxGrid_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include    <afxwin.h>
 #define BASEGRID CWnd
#else
 #include <wx/window.h>
 #include <wx/control.h>
 #include <wx/font.h>
 #define BASEGRID wxPanel
#endif

#include    "cxradiobutton.h"

class CrGrid;
class CxGrid;

//End of user code.

class CxGrid : public BASEGRID
{

// The interface exposed to the CrClass:

      public:
        static CxGrid * CreateCxGrid( CrGrid * container, CxGrid * guiParent );
        CxGrid( CrGrid * container );
        ~CxGrid();
        void    SetText( const string & text );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        void CxDestroyWindow();
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        void CxShowWindow(bool state=true);

        CrGUIElement *  ptr_to_crObject;
        static int mGridCount;


#ifdef CRY_USEMFC
	protected:
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		afx_msg BOOL OnEraseBkgnd(CDC* pDC);
		DECLARE_MESSAGE_MAP()
#else
	public:
         static wxFont* mp_font;
		void OnSize ( wxSizeEvent & event );
		void OnChar(wxKeyEvent & event );
		DECLARE_EVENT_TABLE()
#endif
    


};
#endif
