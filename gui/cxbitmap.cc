
////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxBitmap
////////////////////////////////////////////////////////////////////////

//   Filename:  CxBitmap.cpp
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $

#include    "crystalsinterface.h"
#include    "cxbitmap.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "crbitmap.h"


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

void    CxBitmap::LoadFile( CcString bitmap, bool transp )
{

  CcString crysdir ( getenv("CRYSDIR") );
  if ( crysdir.Length() == 0 )
  {
    cerr << "You must set CRYSDIR before running crystals.\n";
    return;
  }
  HBITMAP hBmp;
  int nEnv = (CcController::theController)->EnvVarCount( crysdir );
  int i = 0;
  bool noLuck = true;
  while ( noLuck )
  {
    CcString dir = (CcController::theController)->EnvVarExtract( crysdir, i );
    i++;
#ifdef __BOTHWIN__
    CcString file = dir + "\\script\\" + bitmap;
#endif
#ifdef __LINUX__
    CcString file = dir + "/script/" + bitmap;
#endif

#ifdef __CR_WIN__
    hBmp = (HBITMAP)::LoadImage( NULL, file.ToCString(), IMAGE_BITMAP, 0,0, LR_LOADFROMFILE|LR_CREATEDIBSECTION);
#endif
    if( hBmp )
    {
      noLuck = false;
    }
    else if ( i >= nEnv )
    {
      LOGERR ( "Bitmap not found " + bitmap );
      return;
    }
  }

#ifdef __CR_WIN__
    mbitmap.Attach( hBmp );

    if ( transp ) ReplaceBackgroundColour();

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

CXSETGEOMETRY(CxBitmap)

CXGETGEOMETRIES(CxBitmap)



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

void CxBitmap::ReplaceBackgroundColour()
{
// figure out how many pixels there are in the bitmap

  BITMAP                bmInfo;
  mbitmap.GetBitmap (&bmInfo);

// add support for additional bit depths if you choose
  const UINT numPixels (bmInfo.bmHeight * bmInfo.bmWidth);


  if ( ( bmInfo.bmBitsPixel != 24 ) || (bmInfo.bmWidthBytes == (bmInfo.bmWidth * 3)))
  {
	  LOGERR ("Can only make 24 bit bitmaps transparent. Increase the colour depth");
      return;
  }


// get a pointer to the pixels
  DIBSECTION  ds;
  mbitmap.GetObject (sizeof (DIBSECTION), &ds);

  RGBTRIPLE* pixels = reinterpret_cast<RGBTRIPLE*>(ds.dsBm.bmBits);

// get the user's preferred button color from the system
  const COLORREF            buttonColor (::GetSysColor (COLOR_BTNFACE));
  const RGBTRIPLE          kBackgroundColor = {
  pixels [0].rgbtBlue, pixels [0].rgbtGreen, pixels [0].rgbtRed};
  const RGBTRIPLE          userBackgroundColor = {
  GetBValue (buttonColor), GetGValue (buttonColor), GetRValue (buttonColor)};


// search through the pixels, substituting the button
// color for any pixel that has the magic background color
  for (UINT i = 0; i < numPixels; ++i)
  {
    if (pixels [i].rgbtBlue == kBackgroundColor.rgbtBlue
     && pixels [i].rgbtGreen == kBackgroundColor.rgbtGreen
     && pixels [i].rgbtRed == kBackgroundColor.rgbtRed)
    {
      pixels [i] = userBackgroundColor;
    }
  }
}



