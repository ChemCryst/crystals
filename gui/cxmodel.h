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
#include	<GL\gl.h>
#include	<GL\glu.h>

#ifdef __POWERPC__
class LStdModel;
#endif

#ifdef __MOTO__
#include	<LStdControl.h>
#endif

#ifdef __LINUX__
#include <qpushbt.h>
#include <qobject.h>
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#endif

class CrModel;
class CxGrid;
class CcModelAtom;
//End of user code.         
 
#define COVALENT	1
#define VDW			2

class	CxModel : public CWnd
{
	public:
		void UpdateHighlights();
		HDC hDC;
		GLuint mNormal;
		Boolean m_drawing;
		void OnMenuSelected (int nID);
		void HighlightAtom(CcModelAtom* theAtom, Boolean selected = TRUE);
		void ClearHighlights();
		Boolean IsAtomClicked(int xPos, int yPos, CcString *atomname, CcModelAtom **atom);
		void DrawBond(int x1, int y1, int z1, int x2, int y2, int z2, int r, int g, int b, int rad);
		void DrawTri(int x1, int y1, int z1, int x2, int y2, int z2, int x3, int y3, int z3, int r, int g, int b, Boolean fill);
		float m_radscale;
		void SetRadiusScale(int scale);
		void SetRadiusType(int radtype);
		void Start();
		void Clear();
		void Setup();
		void PaintBuffer();
		void DrawAtom(int x, int y, int z, int r, int g, int b, int cov, int vdw);
		BOOL SetWindowPixelFormat(HDC hDC);
		BOOL CreateViewGLContext(HDC hDC);
//		enum GLDisplayListNames { mNormal = 1, mFast = 2 };  //Normal are the atoms and bonds normally rendered. Fast consists of much cruder bonds for fast drawing during rotation.
		HGLRC m_hGLContext;									 //The rendering context handle.
		int m_GLPixelIndex;									 //The pixel index member?
		int m_radius;
		Boolean m_fastrotate;
		float*	matrix;								//Pointer to a rotation matrix used to rotate the coords before rendering. Set by dragging the mouse in the window.
		CPoint m_ptLDown;

		int mIdealHeight;
		int mIdealWidth;
		void SetIdealWidth(int nCharsWide);
		void SetIdealHeight(int nCharsHigh);
//		CBitmap *oldMemDCBitmap, *newMemDCBitmap;
		CBitmap *oldMemDCBitmap, *newMemDCBitmap;
		CDC memDC;
		void Display();
		CPoint DeviceToLogical(int x, int y);
		CPoint LogicalToDevice(CPoint point);
//		CDC memDC;
		void Focus();
		// methods
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
		
		// attributes
		CrGUIElement *	mWidget;
		static int mModelCount;
//		LDefaultOutline * mOutlineWidget;

		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		afx_msg void OnPaint();
		afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
		afx_msg void OnRButtonUp( UINT nFlags, CPoint point );
		afx_msg void OnMouseMove( UINT nFlags, CPoint point );
		afx_msg void OnLButtonDown( UINT nFlags, CPoint point );
	
		DECLARE_MESSAGE_MAP()
private:
	int mBackBufferReady;
	CcModelAtom* m_LitAtom;
};
#endif
