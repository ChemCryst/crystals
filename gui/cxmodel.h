////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModel.h
//   Author:   Richard Cooper
//  $Log: not supported by cvs2svn $

#ifndef     __CxModel_H__
#define     __CxModel_H__
#include    "crguielement.h"

#ifdef __BOTHWX__
#include  <wx/defs.h>
#include  <wx/app.h>
#include  <wx/menu.h>
#include  <wx/dcclient.h>
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


class CxModel : public BASEMODEL
{
  public:
    void Update();
    void DoDrawingInMemory();
    bool IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelAtom **atom);
    void SelectBoxedAtoms(CcRect rectangle, bool select);
    void SetRadiusScale(int scale);
    void SetRadiusType(int radtype);
    void Setup();
    void NeedRedraw();
    void NewSize(int cx, int cy);
    void ChooseCursor( int cursor );

#ifdef __CR_WIN__
    void PaintBannerInstead(CPaintDC *dc);
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
    void    SetGeometry( int top, int left, int bottom, int right );
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



    CrGUIElement *  ptr_to_crObject;
    static int mModelCount;

    CcModelAtom* m_LitAtom;  //  Mouse is over this atom

    float m_xTrans;          //
    float m_yTrans;          //  Translation
    float m_zTrans;          //

    float m_xScale;          //  Scaling

    float * mat;             //  Rotaion
    float m_radscale;        //  Scales radius of all objects
    int m_radius;            //  Type of radius to display
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

    int m_DrawStyle;         // Rendering style
    bool m_Autosize;      // Resize when rotating?
    bool m_Hover;         // Highlight atoms on hover?
    bool m_Shading;       // Use fancy shading?
    bool m_bNeedUpdate;

#ifdef __CR_WIN__
    CStatic* m_TextPopup;

    HGLRC m_hGLContext;                                  //The rendering context handle.

    BOOL SetWindowPixelFormat(HDC hDC);
    BOOL CreateViewGLContext(HDC hDC);
    CBitmap *oldMemDCBitmap, *newMemDCBitmap;
    CDC memDC;
    CBitmap m_bitmap;
    bool m_bitmapok, m_bOkToDraw;
    CPalette m_pal;

    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    afx_msg void OnPaint();
    afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
    afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
    afx_msg void OnMouseMove( UINT nFlags, CPoint point );
    afx_msg void OnLButtonDown( UINT nFlags, CPoint point );
    afx_msg BOOL OnEraseBkgnd( CDC* pDC );
    afx_msg void OnMenuSelected (int nID);

    DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
            wxStaticText * m_TextPopup;
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
