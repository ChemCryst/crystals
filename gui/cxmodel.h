////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxModel

////////////////////////////////////////////////////////////////////////

//   Filename:  CxModel.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 15:22 Uhr

#ifndef		__CxModel_H__
#define		__CxModel_H__
//Insert your own code here.
#include	"crguielement.h"

#ifdef __LINUX__
#include    <GL/gl.h>
#include    <GL/glu.h>
#include    "glcanvas.h"
#include <wx/dcclient.h>
#include <wx/event.h>
#include    "glcanvas.h"
#define BASEMODEL wxGLCanvas
#endif

#ifdef __WINDOWS__
#include    <GL\gl.h>
#include    <GL\glu.h>
#include	<afxwin.h>
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

// The usual functions:
		static CxModel *	CreateCxModel( CrModel * container, CxGrid * guiParent );
		CxModel(CrModel* container);
		~CxModel();
		void	SetText( char * text );
		void	SetGeometry( int top, int left, int bottom, int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		int mIdealHeight;
		int mIdealWidth;
		void SetIdealWidth(int nCharsWide);
		void SetIdealHeight(int nCharsHigh);
		void Focus();
            void AutoScale();


		CrGUIElement *	mWidget;
		static int mModelCount;


//            GLuint mNormal;
//            GLuint mHighlights;
//            GLuint mLitatom;
		int m_GLPixelIndex;									 //The pixel index member?

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

#ifdef __WINDOWS__
		HGLRC m_hGLContext;									 //The rendering context handle.
		HDC hDC;

		BOOL SetWindowPixelFormat(HDC hDC);
		BOOL CreateViewGLContext(HDC hDC);
		CBitmap *oldMemDCBitmap, *newMemDCBitmap;
		CDC memDC;

		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		afx_msg void OnPaint();
		afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
		afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
		afx_msg void OnMouseMove( UINT nFlags, CPoint point );
		afx_msg void OnLButtonDown( UINT nFlags, CPoint point );
            afx_msg void OnMenuSelected (int nID);
	
		DECLARE_MESSAGE_MAP()
#endif
#ifdef __LINUX__
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
