////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxResizeBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CxResizeBar.h
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $
//   Revision 1.3  2001/07/16 07:34:58  ckp2
//   Process ON_CHAR messages. Only ever capture and release the mouse once under wx or
//   it gets upset.
//
//   Revision 1.2  2001/06/17 14:32:25  richard
//   wx support. CxDestroyWindow function.
//
//   Revision 1.1  2001/02/26 12:04:49  richard
//   New resizebar class. A resize control has two panes and the bar between them
//   can be dragged to change their relative sizes. If one of the panes is of fixed
//   width or height in the relevant direction, then the resize-bar contains a button
//   which will show or hide the fixed size item.
//

#ifndef     __CxResizeBar_H__
#define     __CxResizeBar_H__

#ifdef __BOTHWX__
#include <wx/window.h>
#include <wx/dcclient.h>
#include <wx/dcscreen.h>
#include <wx/font.h>
#define BASERESIZEBAR wxWindow
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASERESIZEBAR CWnd
#endif

class CrResizeBar;
class CxGrid;
class CrGUIElement;


#define SIZE_BAR 8

class CxResizeBar : public BASERESIZEBAR
{
  public:

    CxResizeBar( CrResizeBar * container );
    ~CxResizeBar();
    void CxDestroyWindow();

    static  CxResizeBar * CreateCxResizeBar( CrResizeBar * container, CxGrid * guiParent );
    static int AddResizeBar( void) { mResizeBarCount++; return mResizeBarCount; };
    static void RemoveResizeBar( void) { mResizeBarCount--; };

    void Focus();
    int GetTop();
    int GetWidth();
    int GetHeight();
    int GetLeft();
    int GetIdealWidth();
    int GetIdealHeight();
    void SetGeometry(int top, int left, int bottom, int right );
    void SetType( int type );
    void SetHotRect(CcRect * hotRect);
    void WillNotResize(bool item1, bool item2);
    void AlreadyCollapsed();

private:

    CrResizeBar * ptr_to_crObject;
    CcRect  m_hotRect, m_oldrec, m_veryHotRect;
    int m_startDrag;
    int m_type;
    static int mResizeBarCount;
    bool m_firstNonSize, m_secondNonSize, m_NonSizePresent, m_BothNonSize;
    bool m_Collapsed;
    bool m_ButtonDrawn;


#ifdef __CR_WIN__

protected:
    afx_msg void OnPaint();
    afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
    afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
    afx_msg void OnMouseMove( UINT nFlags, CPoint wpoint );
    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg BOOL OnEraseBkgnd(CDC* pDC);
    DECLARE_MESSAGE_MAP()
#endif

#ifdef __BOTHWX__

public:
    void OnLButtonDown(wxMouseEvent & evt);
    void OnLButtonUp(wxMouseEvent & evt);
    void OnMouseMove(wxMouseEvent & evt);
    void OnPaint(wxPaintEvent & event );
    void OnChar (wxKeyEvent & event );
    DECLARE_EVENT_TABLE()

private:
    bool m_MouseCaught;

#endif

};
#endif
