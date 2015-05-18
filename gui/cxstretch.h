////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $
//   Revision 1.5  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.4  2001/11/14 10:30:41  ckp2
//   Various changes to the painting of the background of Windows as some of the
//   dialogs suddenly went white under XP.
//
//   Revision 1.3  2001/07/16 07:35:32  ckp2
//   Process ON_CHAR messages.
//
//   Revision 1.2  2001/06/17 14:31:09  richard
//   CxDestroyWindow function. wx support.
//
//   Revision 1.1  2001/02/26 12:07:05  richard
//   New stretch class. Probably the simplest class ever written, it has no functionality
//   except that it can be put in a grid of non-resizing items, and it will make that
//   row, column or both appear to be able to resize, thus spreading out fixed size items.
//

#ifndef     __CxStretch_H__
#define     __CxStretch_H__
#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASESTRETCH CWnd
#else
 #include <wx/window.h>
 #define BASESTRETCH wxPanel
#endif


class CrStretch;
class CxGrid;
//End of user code.

class CxStretch : public BASESTRETCH
{
    public:
        // methods
        static CxStretch * CreateCxStretch( CrStretch * container, CxGrid * guiParent );
        CxStretch( CrStretch * container );
        ~CxStretch();
        void CxDestroyWindow();
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();

        // attributes
        CrGUIElement *  ptr_to_crObject;

    protected:
        // attributes
        static int  mStretchCount;
#ifdef CRY_USEMFC
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        afx_msg BOOL OnEraseBkgnd(CDC* pDC);
        DECLARE_MESSAGE_MAP()
#else
    public:
        void OnChar(wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif





};
#endif
