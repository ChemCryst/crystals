////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxToolBar
////////////////////////////////////////////////////////////////////////
//   Filename:  CxToolBar.h
//   Authors:   Richard Cooper
//   Created:   27.1.2001 09:50
//   $Log: not supported by cvs2svn $
//   Revision 1.8  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.7  2004/06/24 09:12:02  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.6  2003/09/11 17:50:50  rich
//   AddTool now returns a value so we can tell if it fails.
//
//   Revision 1.5  2002/07/08 11:37:36  richard
//   Remove text from toolbars to save screen space, instead added "tooltips"
//   to say what each button does.
//
//   Revision 1.4  2002/07/03 14:23:21  richard
//   Replace as many old-style stream class header references with new style
//   e.g. <iostream.h> -> <iostream>. Couldn't change the ones in string however, yet.
//
//   Removed OnStuffToProcess message from WinApp, it doesn't compile under the new
//   stricter C++7.0 compiler. (CWinApp isn't a CWnd, so can't recieve messages?)
//
//   Removed some bits from Steve's Plot classes that were generating (harmless) compiler
//   warning messages.
//
//   Revision 1.3  2001/07/16 07:37:19  ckp2
//   wx: Get better guess at ideal toolbar size. Sub-class native toolbar class in
//   order to process ON_CHAR messages.
//
//   Revision 1.2  2001/06/17 14:27:40  richard
//   wx Support.
//   Catch bad bitmaps.
//   Destroy window function.
//
//   Revision 1.1  2001/02/26 12:02:14  richard
//   New toolbar classes.
//

#ifndef     __CxToolBar_H__
#define     __CxToolBar_H__

#include    "crguielement.h"
#include <list>

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASETOOLBAR CWnd
#else
 #include <wx/toolbar.h>
 #define BASETOOLBAR wxWindow

 class mywxToolBar : public wxToolBar
 {
     void OnChar(wxKeyEvent & event );
     DECLARE_EVENT_TABLE()
 };
#endif


class CrToolBar;
class CxGrid;
class CcTool;



class CxToolBar : public BASETOOLBAR
{
  public:
// methods
     static CxToolBar *  CreateCxToolBar( CrToolBar * container, CxGrid * guiParent);
     CxToolBar( CrToolBar * container );
     ~CxToolBar();
     bool    AddTool( CcTool* newTool );
     void    SetGeometry( int top, int left, int bottom, int right );
     int GetTop();
     int GetLeft();
     int GetWidth();
     int GetHeight();
     int GetIdealWidth();
     int GetIdealHeight();
     void CxEnable(bool enable, int id);
     void CheckTool(bool check, int id);
     bool GetToolState(int id);
     void Focus();
     void CxDestroyWindow();

// attributes
     CrGUIElement *  ptr_to_crObject;
     static int  mToolBarCount;
     int m_ImageIndex;

#ifdef CRY_USEMFC
//     list<CBitmap*> m_bitmapList;
     CImageList* m_ImageList;
     CToolBarCtrl * m_ToolBar;
     static void ReplaceBackgroundColor(CBitmap & io);

     afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
     afx_msg void OnToolSelected(UINT nID);
     afx_msg BOOL OnToolTipNotify( UINT id, NMHDR * pNMHDR, LRESULT * pResult );
     DECLARE_MESSAGE_MAP()
#else
//     list<wxBitmap*> m_bitmapList;
     mywxToolBar * m_ToolBar;
     void OnChar(wxKeyEvent & event );
     void OnToolSelected(wxCommandEvent & event);
     int m_totWidth;
     DECLARE_EVENT_TABLE()
#endif

};
#endif
