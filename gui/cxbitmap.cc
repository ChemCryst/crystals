
////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxBitmap
////////////////////////////////////////////////////////////////////////

//   Filename:  CxBitmap.cpp
//   Authors:   Richard Cooper


#include	"crystalsinterface.h"
#include        "cxbitmap.h"
#include	"cxgrid.h"
#include        "crbitmap.h"


int     CxBitmap::mBitmapCount = kBitmapBase;
CxBitmap *        CxBitmap::CreateCxBitmap( CrBitmap * container, CxGrid * guiParent )
{
        CxBitmap  *theBitmap = new CxBitmap( container );
#ifdef __WINDOWS__
      theBitmap->Create(NULL,"Bitmap",WS_CHILD| WS_VISIBLE, CRect(0,0,26,28), guiParent, mBitmapCount++);
#endif
#ifdef __LINUX__
      theBitmap->Create(guiParent, -1, "Bitmap");
#endif
      return theBitmap;
}

CxBitmap::CxBitmap( CrBitmap * container )
      :BASEBITMAP()
{
	mWidget = container;
	mCharsWidth = 0;
	mbOkToDraw = false;
	mWidth = 10;
	mHeight = 10;
}

CxBitmap::~CxBitmap()
{
        RemoveBitmap();
}

void    CxBitmap::LoadFile( CcString bitmap )
{
        char* crysdir = getenv("CRYSDIR") ;
        if ( crysdir == nil )
        {
            cerr << "You must set CRYSDIR before running crystals.\n";
            return;
        }
        CcString dir = CcString(crysdir);
        CcString file = dir + "\\script\\" + bitmap;

        HBITMAP hBmp = (HBITMAP)::LoadImage( NULL, file.ToCString(), IMAGE_BITMAP, 0,0, LR_LOADFROMFILE|LR_CREATEDIBSECTION);

	if( hBmp == NULL ) return;

	mbitmap.Attach( hBmp );

	// Create a logical palette for the mbitmap
	DIBSECTION ds;
	BITMAPINFOHEADER &bmInfo = ds.dsBmih;
	mbitmap.GetObject( sizeof(ds), &ds );

	int nColors = bmInfo.biClrUsed ? bmInfo.biClrUsed : 1 << bmInfo.biBitCount;

    mWidth = bmInfo.biWidth;
    mHeight = bmInfo.biHeight;

	// Create a halftone palette if colors > 256. 
	CClientDC dc(NULL);			// Desktop DC
	if( nColors > 256 )
		mpal.CreateHalftonePalette( &dc );
	else
	{
		// Create the palette

		RGBQUAD *pRGB = new RGBQUAD[nColors];
		CDC memDC;
		CBitmap memBitmap;
		CBitmap* oldBitmap;
		memDC.CreateCompatibleDC(&dc);
                memBitmap.CreateCompatibleBitmap(&dc, mWidth,mHeight);

		oldBitmap = (CBitmap*)memDC.SelectObject( &memBitmap );
		::GetDIBColorTable( memDC, 0, nColors, pRGB );

		UINT nSize = sizeof(LOGPALETTE) + (sizeof(PALETTEENTRY) * nColors);
		LOGPALETTE *pLP = (LOGPALETTE *) new BYTE[nSize];

		pLP->palVersion = 0x300;
		pLP->palNumEntries = nColors;

		for( int i=0; i < nColors; i++)
		{
			pLP->palPalEntry[i].peRed = pRGB[i].rgbRed;
			pLP->palPalEntry[i].peGreen = pRGB[i].rgbGreen;
			pLP->palPalEntry[i].peBlue = pRGB[i].rgbBlue;
			pLP->palPalEntry[i].peFlags = 0;
		}

		mpal.CreatePalette( pLP );

		delete[] pLP;
		delete[] pRGB;

		memDC.SelectObject(oldBitmap);
	}
	mbOkToDraw = true;
}


void  CxBitmap::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __WINDOWS__
	MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __LINUX__
      SetSize(left,top,right-left,bottom-top);
#endif

}
int   CxBitmap::GetTop()
{
#ifdef __WINDOWS__
      RECT windowRect, parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.top -= parentRect.top;
	}
	return ( windowRect.top );
#endif
#ifdef __LINUX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
	if(parent != nil)
	{
            parentRect = parent->GetRect();
            windowRect.y -= parentRect.y;
	}
      return ( windowRect.y );
#endif
}
int   CxBitmap::GetLeft()
{
#ifdef __WINDOWS__
      RECT windowRect, parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.left -= parentRect.left;
	}
	return ( windowRect.left );
#endif
#ifdef __LINUX__
      wxRect windowRect, parentRect;
      windowRect = GetRect();
      wxWindow* parent = GetParent();
	if(parent != nil)
	{
            parentRect = parent->GetRect();
            windowRect.x -= parentRect.x;
	}
      return ( windowRect.x );
#endif

}
int   CxBitmap::GetWidth()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxBitmap::GetHeight()
{
#ifdef __WINDOWS__
	CRect windowRect;
	GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __LINUX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


int     CxBitmap::GetIdealWidth()
{
#ifdef __WINDOWS__
        return ( mWidth );
#endif
#ifdef __LINUX__
      int cx,cy;
      return cx; 
#endif

}

int     CxBitmap::GetIdealHeight()
{
#ifdef __WINDOWS__
        return ( mHeight );
#endif
#ifdef __LINUX__
      return GetCharHeight();
#endif
}

int     CxBitmap::AddBitmap()
{
        mBitmapCount++;
        return mBitmapCount;
}

void    CxBitmap::RemoveBitmap()
{
        mBitmapCount--;
}


#ifdef __WINDOWS__
//Windows Message Map
BEGIN_MESSAGE_MAP(CxBitmap, CWnd)
	ON_WM_PAINT()
END_MESSAGE_MAP()
#endif
#ifdef __LINUX__
//wx Message Table
BEGIN_EVENT_TABLE(CxBitmap, wxControl)
      EVT_PAINT( CxChart::OnPaint )
END_EVENT_TABLE()
#endif

#ifdef __WINDOWS__
void CxBitmap::OnPaint()
{
	CPaintDC dc(this);


	if (!mbOkToDraw) return;

	// Create a memory DC compatible with the paint DC
	CDC memDC;
	memDC.CreateCompatibleDC( &dc );

	memDC.SelectObject( &mbitmap );

	// Select and realize the palette
        if( dc.GetDeviceCaps(RASTERCAPS) & RC_PALETTE && mpal.m_hObject != NULL )
	{
                dc.SelectPalette( &mpal, FALSE );
		dc.RealizePalette();
	}
        dc.BitBlt(0, 0, mWidth, mHeight, &memDC, 0, 0,SRCCOPY);
}
#endif
