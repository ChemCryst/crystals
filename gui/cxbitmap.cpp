
////////////////////////////////////////////////////////////////////////
//   CRYSTALS Interface      Class CxBitmap
////////////////////////////////////////////////////////////////////////

//   Filename:  CxBitmap.cpp
//   Authors:   Richard Cooper
//   $Log: not supported by cvs2svn $
//   Revision 1.12  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.2  2005/01/12 13:15:56  rich
//   Fix storage and retrieval of font name and size on WXS platform.
//   Get rid of warning messages about missing bitmaps and toolbar buttons on WXS version.
//
//   Revision 1.1.1.1  2004/12/13 11:16:18  rich
//   New CRYSTALS repository
//
//   Revision 1.11  2004/11/08 16:48:36  stefan
//   1. Replaces some #ifdef (__WXGTK__) with #if defined(__WXGTK__) || defined(__WXMAC) to make the code compile correctly on the mac version.
//
//   Revision 1.10  2004/10/12 12:11:45  rich
//   Remove extra slashes from paths.
//
//   Revision 1.9  2004/10/06 13:57:26  rich
//   Fixes for WXS version.
//
//   Revision 1.8  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.7  2002/07/15 12:19:13  richard
//   Reorder headers to improve ease of linking.
//   Update program to use new standard C++ io libraries.
//   Update to use new version of MFC (5.0 with .NET.)
//
//   Revision 1.6  2001/06/17 14:47:36  richard
//   CxDestroyWindow function.
//   wx support.
//
//   Revision 1.5  2001/03/21 17:00:46  richard
//   Fixed problem with transparent bitmaps.
//
//   Revision 1.4  2001/03/08 15:49:58  richard
//   Support for transparent bitmaps.
//   Support for CRYSDIR with more than one path in it i.e. c:\temp\,c:\build\
//

#include    "crystalsinterface.h"
#include    "cxbitmap.h"
#include    "cxgrid.h"
#include    "cccontroller.h"
#include    "crbitmap.h"
#include    <iostream>
#ifdef CRY_USEWX
#include <sys/stat.h>
#endif

int     CxBitmap::mBitmapCount = kBitmapBase;
CxBitmap *        CxBitmap::CreateCxBitmap( CrBitmap * container, CxGrid * guiParent )
{
        CxBitmap  *theBitmap = new CxBitmap( container );
#ifdef CRY_USEMFC
      theBitmap->Create(NULL,"Bitmap",WS_CHILD| WS_VISIBLE, CRect(0,0,26,28), guiParent, mBitmapCount++);
#else
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

void CxBitmap::CxDestroyWindow()
{
#ifdef CRY_USEMFC
DestroyWindow();
#else
Destroy();
#endif
}

void    CxBitmap::LoadFile( string bitmap, bool transp )
{

  string crysdir ( getenv("CRYSDIR") );
  if ( crysdir.length() == 0 )
  {
    std::cerr << "You must set CRYSDIR before running crystals.\n";
    return;
  }
#ifdef CRY_USEMFC
  HBITMAP hBmp;
#endif

  int nEnv = (CcController::theController)->EnvVarCount( crysdir );
  int i = 0;
  bool noLuck = true;
  while ( noLuck )
  {
    string dir = (CcController::theController)->EnvVarExtract( crysdir, i );
    i++;
#ifdef CRY_OSWIN32
    string file = dir + "script\\" + bitmap;
#else
    string file = dir + "script/" + bitmap;
#endif

#ifdef CRY_USEMFC
    hBmp = (HBITMAP)::LoadImage( NULL, file.c_str(), IMAGE_BITMAP, 0,0, LR_LOADFROMFILE|LR_CREATEDIBSECTION);
    if( hBmp )
    {
      noLuck = false;
    }
    else if ( i >= nEnv )
    {
      LOGERR ( "Bitmap not found " + bitmap );
      return;
    }
#else
    struct stat buf;
	if ( stat(file.c_str(),&buf)==0 ) {
		wxImage myimage ( file.c_str(), wxBITMAP_TYPE_BMP );
		if ( myimage.Ok() && transp ) {
			unsigned char tr = myimage.GetRed(0,0);
			unsigned char tg = myimage.GetGreen(0,0);
			unsigned char tb = myimage.GetBlue(0,0);
			wxColour ncol = wxSystemSettings::GetColour(wxSYS_COLOUR_3DLIGHT);
			for (int x = 0; x < myimage.GetWidth(); ++x ) {
				for (int y = 0; y < myimage.GetHeight(); ++y ) {
					if ( myimage.GetRed(x,y) == tr ) {
						if ( myimage.GetGreen(x,y) == tg ) {
							if ( myimage.GetBlue(x,y) == tb ) {
								myimage.SetRGB(x,y,ncol.Red(),ncol.Green(),ncol.Blue());
							}
						}
					}
				}
			}
		}
        wxBitmap mymap ( myimage, wxBITMAP_TYPE_BMP );
		if ( mymap.Ok() ) {
			mbitmap=mymap;
			noLuck = false;
		}
	}
    else if ( i >= nEnv )
    {
      LOGERR ( "Bitmap not found " + bitmap );
      return;
    }
#endif
  }

#ifdef CRY_USEMFC
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


#else
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


#ifdef CRY_USEMFC

//Windows Message Map
BEGIN_MESSAGE_MAP(CxBitmap, CWnd)
    ON_WM_PAINT()
END_MESSAGE_MAP()

#else

//wx Message Table
BEGIN_EVENT_TABLE(CxBitmap, wxWindow)
      EVT_PAINT( CxBitmap::OnPaint )
END_EVENT_TABLE()

#endif

#ifdef CRY_USEMFC

void CxBitmap::OnPaint()
{
  CPaintDC dc(this);

  if (!mbOkToDraw) return;

// Create a memory DC compatible with the paint DC

  CDC memDC;
  memDC.CreateCompatibleDC( &dc );

  memDC.SelectObject( &mbitmap );

// Select and realize the palette if present.
  if( dc.GetDeviceCaps(RASTERCAPS) & RC_PALETTE && mpal.m_hObject != NULL )
  {
    dc.SelectPalette( &mpal, FALSE );
    dc.RealizePalette();
  }

  dc.BitBlt(0, 0, mWidth, mHeight, &memDC, 0, 0,SRCCOPY);

}
#else

void CxBitmap::OnPaint(wxPaintEvent & evt)
{
  wxPaintDC dc(this);
  if (!mbOkToDraw) return;
  dc.DrawBitmap(mbitmap,0,0,false);
}
#endif

#ifdef CRY_USEMFC
void CxBitmap::ReplaceBackgroundColour()
{
// figure out how many pixels there are in the bitmap

  BITMAP                bmInfo;
  mbitmap.GetBitmap (&bmInfo);

// add support for additional bit depths if you choose
  const UINT numPixels (bmInfo.bmHeight * bmInfo.bmWidth);


  if ( bmInfo.bmBitsPixel != 24 )
  {
    LOGERR ("Can only make 24 bit bitmaps transparent. Increase the colour depth");
    return;
  }

/*
//  if ( bmInfo.bmWidthBytes != (bmInfo.bmWidth * 3) )
//  {
//    LOGERR ("Bad width for bitmap. Am I making sense?");
//    return;
//  }
*/

// get a pointer to the pixels
  DIBSECTION  ds;
  mbitmap.GetObject (sizeof (DIBSECTION), &ds);

  RGBTRIPLE* pixels = reinterpret_cast <RGBTRIPLE*> (ds.dsBm.bmBits);

// get the user's preferred button color from the system
  const COLORREF            buttonColor (::GetSysColor (COLOR_BTNFACE));
  const RGBTRIPLE          kBackgroundColor = {
  pixels [0].rgbtBlue, pixels [0].rgbtGreen, pixels [0].rgbtRed};
  const RGBTRIPLE          userBackgroundColor = {
  GetBValue (buttonColor), GetGValue (buttonColor), GetRValue (buttonColor)};

// search through the pixels, substituting the button
// color for any pixel that has the magic background color


  unsigned char * pData = reinterpret_cast <unsigned char*> (ds.dsBm.bmBits);;

  for (int y = 0; y < bmInfo.bmHeight; y++ )
  {
    for (int x = 0; x < bmInfo.bmWidth; x++ )
    {
      if (pData[x*3+y*bmInfo.bmWidthBytes]   == kBackgroundColor.rgbtBlue
       && pData[x*3+1+y*bmInfo.bmWidthBytes] == kBackgroundColor.rgbtGreen
       && pData[x*3+2+y*bmInfo.bmWidthBytes] == kBackgroundColor.rgbtRed)
       {
          pData[x*3+y*bmInfo.bmWidthBytes]   = userBackgroundColor.rgbtBlue ;
          pData[x*3+1+y*bmInfo.bmWidthBytes] = userBackgroundColor.rgbtGreen;
          pData[x*3+2+y*bmInfo.bmWidthBytes] = userBackgroundColor.rgbtRed ;
       }
    }
  }
}
#endif
