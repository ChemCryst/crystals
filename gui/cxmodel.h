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
 
#define COVALENT	1
#define VDW			2
#define THERMAL  3

class CxModel : public BASEMODEL
{
	public:
            void Reset();
            float ScaleToWindow();
            float m_projratio;
            Boolean m_moved;
		void UpdateHighlights();
		Boolean m_drawing;
            void StartHighlights();
            void FinishHighlights();
		void HighlightAtom(CcModelAtom* theAtom, Boolean selected = TRUE);
		Boolean IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelAtom **atom);
		void DrawBond(int x1, int y1, int z1, int x2, int y2, int z2, int r, int g, int b, int rad);
		void DrawTri(int x1, int y1, int z1, int x2, int y2, int z2, int x3, int y3, int z3, int r, int g, int b, Boolean fill);
		float m_radscale;
		void SetRadiusScale(int scale);
		void SetRadiusType(int radtype);
		void Start();
		void Setup();
		void PaintBuffer();
            void DrawAtom(CcModelAtom* anAtom, int style = 0);
		int m_GLPixelIndex;									 //The pixel index member?
		int m_radius;
		Boolean m_fastrotate;
		float*	matrix;								//Pointer to a rotation matrix used to rotate the coords before rendering. Set by dragging the mouse in the window.
            CcPoint m_ptLDown;

		int mIdealHeight;
		int mIdealWidth;
		void SetIdealWidth(int nCharsWide);
		void SetIdealHeight(int nCharsHigh);
		void Display();
            CcPoint DeviceToLogical(int x, int y);
            CcPoint LogicalToDevice(CcPoint point);
		void Focus();
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
		static int AddModel( void ) { mModelCount++; return mModelCount; };
		static void RemoveModel( void ) { mModelCount--; };
		
		CrGUIElement *	mWidget;
		static int mModelCount;

		GLuint mNormal;
		GLuint mHighlights;
		GLuint mLitatom;

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

private:
            CcModelAtom* m_LitAtom;
};
#endif
