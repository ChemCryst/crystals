////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxBitmap

////////////////////////////////////////////////////////////////////////

//   Filename:  CxBitmap.h

#ifndef         __CxBitmap_H__
#define         __CxBitmap_H__
#include	"crguielement.h"

#ifdef __LINUX__
#include <wx/statbitmap.h>
#define BASEBITMAP wxWindow
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASEBITMAP CWnd
#endif

class CrBitmap;
class CxGrid;
 
class CxBitmap : public BASEBITMAP
{
	public:
                // methods
                static CxBitmap * CreateCxBitmap( CrBitmap * container, CxGrid * guiParent );
                        CxBitmap( CrBitmap * container );
                        ~CxBitmap();
                void    LoadFile( CcString filename );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
                static int      AddBitmap();
                static void     RemoveBitmap();
		
		// attributes
		CrGUIElement *	mWidget;
		
	protected:
		// methods
		
		// attributes
                static int      mBitmapCount;
		int mCharsWidth;		
                int mWidth;         
                int mHeight;         
		CBitmap mbitmap;
		CPalette mpal;
		bool mbOkToDraw;

		afx_msg void OnPaint();
		DECLARE_MESSAGE_MAP()

};
#endif
