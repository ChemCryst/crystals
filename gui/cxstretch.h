////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxStretch

////////////////////////////////////////////////////////////////////////

//   Filename:  CrStretch.cc
//   Authors:   Richard Cooper
//   Created:   23.2.2001 11:35
//   $Log: not supported by cvs2svn $
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

#ifdef __BOTHWX__
#include <wx/window.h>
#define BASESTRETCH wxWindow
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASESTRETCH CWnd
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
#ifdef __CR_WIN__
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
  public:
        void OnChar(wxKeyEvent & event );
        DECLARE_EVENT_TABLE()
#endif





};
#endif
