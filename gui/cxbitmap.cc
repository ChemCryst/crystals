
////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxBitmap
////////////////////////////////////////////////////////////////////////

//   Filename:  CxBitmap.cpp
//   Authors:   Richard Cooper


#include    "crystalsinterface.h"
#include        "cxbitmap.h"
#include    "cxgrid.h"
#include        "crbitmap.h"


int     CxBitmap::mBitmapCount = kBitmapBase;
CxBitmap *        CxBitmap::CreateCxBitmap( CrBitmap * container, CxGrid * guiParent )
{
        CxBitmap  *theBitmap = new CxBitmap( container );
#ifdef __CR_WIN__
      theBitmap->Create(NULL,"Bitmap",WS_CHILD| WS_VISIBLE, CRect(0,0,26,28), guiParent, mBitmapCount++);
#endif
#ifdef __BOTHWX__
      theBitmap->Create(guiParent,-1,wxPoint(0,0),wxSize(0,0));
#endif
      return theBitmap;
}

CxBitmap::CxBitmap( CrBitmap * container )
      :BASEBITMAP()
{
    ptr_to_crObject = container;
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
#ifdef __LINUX__
        CcString file = dir + "/script/" + bitmap;
#endif
#ifdef __BOTHWIN__
        CcString file = dir + "\\script\\" + bitmap;
#endif

#ifdef __CR_WIN__
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
    CClientDC dc(NULL);         // Desktop DC
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
#endif
#ifdef __BOTHWX__
        if (!mbitmap.LoadFile(file.ToCString(), wxBITMAP_TYPE_BMP))
        {
            cerr << "Cannot load bitmap file.";
            return;
        }
        mWidth = mbitmap.GetWidth();
        mHeight = mbitmap.GetHeight();

#endif
    mbOkToDraw = true;
}


void  CxBitmap::SetGeometry( int top, int left, int bottom, int right )
{
#ifdef __CR_WIN__
    MoveWindow(left,top,right-left,bottom-top,true);
#endif
#ifdef __BOTHWX__
      SetSize(left,top,right-left,bottom-top);
#endif

}
int   CxBitmap::GetTop()
{
#ifdef __CR_WIN__
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
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
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
#ifdef __BOTHWX__
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
#ifdef __CR_WIN__
    CRect windowRect;
    GetWindowRect(&windowRect);
    return ( windowRect.Width() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetWidth() );
#endif
}
int   CxBitmap::GetHeight()
{
#ifdef __CR_WIN__
    CRect windowRect;
    GetWindowRect(&windowRect);
      return ( windowRect.Height() );
#endif
#ifdef __BOTHWX__
      wxRect windowRect;
      windowRect = GetRect();
      return ( windowRect.GetHeight() );
#endif
}


int     CxBitmap::GetIdealWidth()
{
        return ( mWidth );

}

int     CxBitmap::GetIdealHeight()
{
        return ( mHeight );
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


#ifdef __CR_WIN__
//Windows Message Map
BEGIN_MESSAGE_MAP(CxBitmap, CWnd)
    ON_WM_PAINT()
END_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
//wx Message Table
BEGIN_EVENT_TABLE(CxBitmap, wxWindow)
      EVT_PAINT( CxBitmap::OnPaint )
END_EVENT_TABLE()
#endif

#ifdef __CR_WIN__
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

#ifdef __BOTHWX__
void CxBitmap::OnPaint(wxPaintEvent & evt)
{
    wxPaintDC dc(this);
        if (!mbOkToDraw) return;
        dc.DrawBitmap(mbitmap,0,0,false);
}
#endif
