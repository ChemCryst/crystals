////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxToolBar
////////////////////////////////////////////////////////////////////////
//   Filename:  CxToolBar.h
//   Authors:   Richard Cooper
//   Created:   27.1.2001 09:50
//   $Log: not supported by cvs2svn $
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


#ifdef __BOTHWX__
#include <wx/toolbar.h>
#define BASETOOLBAR wxWindow

class mywxToolBar : public wxToolBar
{
     void OnChar(wxKeyEvent & event );
     DECLARE_EVENT_TABLE()
};
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASETOOLBAR CWnd
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
     void    AddTool( CcTool* newTool );
     void    SetGeometry( int top, int left, int bottom, int right );
     int GetTop();
     int GetLeft();
     int GetWidth();
     int GetHeight();
     int GetIdealWidth();
     int GetIdealHeight();
     void CxEnable(bool enable, int id);
     void CheckTool(bool check, int id);
     void Focus();
     void CxDestroyWindow();

// attributes
     CrGUIElement *  ptr_to_crObject;
     static int  mToolBarCount;
     CcList m_bitmapList;
     int m_ImageIndex;

#ifdef __CR_WIN__
     CImageList* m_ImageList;
     CToolBarCtrl * m_ToolBar;
     static void ReplaceBackgroundColor(CBitmap & io);

     afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
     afx_msg void OnToolSelected(UINT nID);
     DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
     mywxToolBar * m_ToolBar;
     void OnChar(wxKeyEvent & event );
     void OnToolSelected(wxCommandEvent & event);
     DECLARE_EVENT_TABLE()
#endif

};
#endif
