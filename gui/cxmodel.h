////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModel.h
//   Author:   Richard Cooper

#ifndef     __CxModel_H__
#define     __CxModel_H__
//Insert your own code here.
#include    "crguielement.h"

#ifdef __BOTHWX__
#include  <wx/defs.h>
#include  <wx/app.h>
#include  <wx/menu.h>
#include  <wx/dcclient.h>
#include  <wx/glcanvas.h>
#include  <wx/event.h>
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
//End of user code.

#define CURSORNORMAL  0
#define CURSORZOOMIN  1
#define CURSORZOOMOUT 2
#define MODELSMOOTH   0
#define MODELLINE     2
#define MODELPOINT    3


class CxModel : public BASEMODEL
{
    public:
            void Update();
            Boolean IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelAtom **atom);
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
        void    SetText( char * text );
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


//            GLuint mNormal;
//            GLuint mHighlights;
//            GLuint mLitatom;

            CcModelAtom* m_LitAtom;  //  Mouse is over this atom

            float m_xTrans;          //
            float m_yTrans;          //  Translation
            float m_zTrans;          //

            float m_xScale;          //  Scaling

            float * mat;             //  Rotaion
            float m_radscale;        //  Scales radius of all objects
            int m_radius;            //  Type of raduis to display
            Boolean m_fastrotate;    //  Detailed or quick drawing
            CcPoint m_ptLDown;       //  Last mouse position when rotating

            CcPoint m_ptMMove;       //  Last mouse position


            void SetDrawStyle( int drawStyle );
            void SetAutoSize( Boolean size )  ;
            void SetHover( Boolean hover )    ;
            void SetShading( Boolean shade )  ;

            int m_DrawStyle;         // Rendering style
            Boolean m_Autosize;      // Resize when rotating?
            Boolean m_Hover;         // Highlight atoms on hover?
            Boolean m_Shading;       // Use fancy shading?

#ifdef __CR_WIN__
        int m_GLPixelIndex;                                  //The pixel index member?
        HGLRC m_hGLContext;                                  //The rendering context handle.
        HDC hDC;

        BOOL SetWindowPixelFormat(HDC hDC);
        BOOL CreateViewGLContext(HDC hDC);
        CBitmap *oldMemDCBitmap, *newMemDCBitmap;
        CDC memDC;
            CBitmap m_bitmap;
            Boolean m_bitmapok;
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
