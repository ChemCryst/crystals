////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModel.h
//   Author:   Richard Cooper
//  $Log: not supported by cvs2svn $
//  Revision 1.25  2001/12/12 16:02:26  ckpgroup
//  SH: Reorganised script to allow right-hand y axes.
//  Added floating key if required, some redraw problems.
//
//  Revision 1.24  2001/12/03 14:25:49  ckp2
//  RIC: Bug fixes. Release version no longer crashes on mouse leave.
//
//  Revision 1.23  2001/11/26 16:46:15  ckpgroup
//  SH: Added Mouse_Leave messaging to remove labels when mouse leaves the window.
//
//  Revision 1.22  2001/09/07 14:39:06  ckp2
//
//  New modelwindow function lets the user choose a background bitmap to
//  display behind the model. David is correct; I've been to too many
//  conferences. But it's too late now, I've done it.
//
//  Revision 1.21  2001/07/16 07:33:57  ckp2
//  wx version: Subclassed the little text windows that popup and tell you the atom names,
//  in order that they pass any mouse events to the model window. Otherwise they just get
//  in the way of the user trying to click on the atoms.
//
//  Revision 1.20  2001/06/18 12:51:40  richard
//  New variables to track whether the mouse has been captured, and if the
//  OpenGL context has been initialised (wx only).
//
//  Revision 1.19  2001/06/17 14:39:36  richard
//  Error checking and warning messages on OpenGL window creation in case of error.
//  Removal of draw_to_bitmap method, instead using compiled GL displaylists, and the
//  SwapBuffers function.
//  wx support.
//  Use GL select and feedback buffers for sizing and hit testing rather than trying to emulate it's
//  calculations.
//  Support for spotting mouse over bonds as well as over atoms - bond name and length
//  is displayed.
//  Change way popup boxes are displayed to avoid GL repaint when the popup is CREATED.
//
//  Revision 1.18  2001/03/12 13:53:26  richard
//  Fixed pixel format when only 256 colours. Removed unused accumulation buffers from
//  OpenGL window, speeding up drawing, I think.
//
//  Revision 1.17  2001/03/08 15:54:59  richard
//  Stop using GL double buffers, and do this manually. (Draw to bitmap then
//  bitblt to screen - some performance lost by looks of things, but also
//  a few gains - no need to re-render whenever window is partially covered, for
//  example. Also necessary for:
//  Polygon selection modes - only box selection implemented at the moment.
//

#ifndef     __CxModel_H__
#define     __CxModel_H__
#include    "crguielement.h"

#ifdef __BOTHWX__
#include  <wx/defs.h>
#include  <wx/app.h>
#include  <wx/menu.h>
#include  <wx/dcclient.h>
#include <wx/dcmemory.h>
#include  <wx/glcanvas.h>
#include  <wx/event.h>
#include <wx/stattext.h>
#define BASEMODEL wxGLCanvas
#endif

#ifdef __CR_WIN__
#include    <GL\gl.h>
#include    <GL\glu.h>
#include    <afxwin.h>
#define BASEMODEL CWnd
#endif

#include "ccpoint.h"

class CrModel;
class CxGrid;
class CcModelAtom;
class CcModelObject;

#define CURSORNORMAL  0
#define CURSORZOOMIN  1
#define CURSORZOOMOUT 2
#define CURSORCROSS   3
#define CURSORCOPY    4

#define MODELSMOOTH   0
#define MODELLINE     2
#define MODELPOINT    3

#define CXROTATE      0
#define CXRECTSEL     1
#define CXPOLYSEL     2
#define CXZOOM        3

#define ATOMLIST      1
#define BONDLIST      2
#define STYLIST       3
#define QATOMLIST     4
#define QBONDLIST     5
#define XOBJECTLIST   6

#ifdef __BOTHWX__
class mywxStaticText : public wxStaticText
{
  public:
    mywxStaticText(wxWindow* s,int i,wxString s,wxPoint p,wxSize ss,int f);
    wxWindow * m_parent;
    void OnLButtonUp(wxMouseEvent & event);
    void OnLButtonDown(wxMouseEvent & event);
    void OnRButtonUp(wxMouseEvent & event);
    DECLARE_EVENT_TABLE()
};
#endif


class CxModel : public BASEMODEL
{
  public:
    void Update();
    void DoDrawingLists();
    int IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelObject **outObject, Boolean atomsOnly=false);
    void SelectBoxedAtoms(CcRect rectangle, bool select);
    void Setup();
    void NeedRedraw(bool needrescale = false);
    void ModelChanged();
    void NewSize(int cx, int cy);
    void ChooseCursor( int cursor );
#ifdef __CR_WIN__
    void PaintBannerInstead(CPaintDC *dc);
#endif
#ifdef __BOTHWX__
    void PaintBannerInstead(wxPaintDC *dc);
#endif

// The usual functions:
    static CxModel *    CreateCxModel( CrModel * container, CxGrid * guiParent );
#ifdef __CR_WIN__
    CxModel(CrModel* container);
#endif
#ifdef __BOTHWX__
    CxModel(wxWindow* parent, wxWindowID id = -1, const wxPoint& pos = wxDefaultPosition,
                    const wxSize& size = wxDefaultSize, long style = 0, const wxString& name = "GLWindow");
#endif
    ~CxModel();
    void SetGeometry( int top, int left, int bottom, int right );
    void CxDestroyWindow();

    int GetTop();
    int GetLeft();
    int GetWidth();
    int GetHeight();
    int GetIdealWidth();
    int GetIdealHeight();
    int mIdealHeight;
    int mIdealWidth;
    void SetIdealWidth(int nCharsWide);
    void SetIdealHeight(int nCharsHigh);
    void Focus();
    void AutoScale();
    int  AdjustEnclose( CcRect* enc, GLfloat* buf, int point );
    void CameraSetup();
    void ModelSetup();



    CrGUIElement *  ptr_to_crObject;
    static int mModelCount;

    CcModelObject* m_LitObject;  //  Mouse is over this object

    float m_xTrans;          //
    float m_yTrans;          //  Translation
    float m_zTrans;          //

    float m_xScale;          //  Scaling
    int   m_fbsize;
    int   m_sbsize;

    float * mat;             //  Rotaion
    bool m_fastrotate;    //  Detailed or quick drawing

    CcPoint m_ptLDown;       //  Last mouse position when rotating
    CcPoint m_ptMMove;       //  Last mouse position

    CcPoint* m_selectionPoints;
    CcRect m_selectRect;
    int m_nSelectionPoints;

    int m_mouseMode;

    void SetDrawStyle( int drawStyle );
    void SetAutoSize( bool size )  ;
    void SetHover( bool hover )    ;
    void SetShading( bool shade )  ;

    void SelectTool( int toolType );

    void DeletePopup();
    void CreatePopup(CcString atomname, CcPoint point);

    void LoadDIBitmap(CcString filename);
    BYTE * m_bitmapbits;
    BITMAPINFO * m_bitmapinfo;


    int m_DrawStyle;         // Rendering style
    bool m_Autosize;      // Resize when rotating?
    bool m_Hover;         // Highlight atoms on hover?
    bool m_Shading;       // Use fancy shading?
    bool m_bNeedReScale;
    bool m_bModelChanged;
    bool m_bOkToDraw;
    bool m_bFullListOk;
    bool m_bQuickListOk;
    float m_stretchX ;
    float m_stretchY ;
    bool  m_bitmapok;
    bool m_bMouseLeaveInitialised;
#ifdef __CR_WIN__
    HPALETTE m_hPalette;
    CStatic* m_TextPopup;

    HGLRC m_hGLContext;                                  //The rendering context handle.

    BOOL SetWindowPixelFormat(HDC hDC);
    BOOL CreateViewGLContext(HDC hDC);
    CBitmap m_bitmap;
    CPalette m_pal;

    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnPaint();
    afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
    afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
    afx_msg void OnMouseMove( UINT nFlags, CPoint point );
    afx_msg void OnLButtonDown( UINT nFlags, CPoint point );
    afx_msg BOOL OnEraseBkgnd( CDC* pDC );
    afx_msg void OnMenuSelected (int nID);
	afx_msg LRESULT OnMouseLeave(WPARAM wParam, LPARAM lParam);
    DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
    mywxStaticText * m_TextPopup;
    bool m_DoNotPaint;
    bool m_NotSetupYet;
    bool m_MouseCaught;
    wxBitmap m_bitmap;

    void OnEraseBackground(wxEraseEvent & evt);
    void OnLButtonUp(wxMouseEvent & event);
    void OnLButtonDown(wxMouseEvent & event);
    void OnRButtonUp(wxMouseEvent & event);
    void OnMouseMove(wxMouseEvent & event);
    void OnChar(wxKeyEvent & event );
    void OnPaint(wxPaintEvent & event );
    void OnMenuSelected(wxCommandEvent &event );
    DECLARE_EVENT_TABLE()
#endif

};
#endif
