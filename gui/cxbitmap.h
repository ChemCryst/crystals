////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxBitmap

////////////////////////////////////////////////////////////////////////

//   Filename:  CxBitmap.h

#ifndef         __CxBitmap_H__
#define         __CxBitmap_H__
#include    "crguielement.h"

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASEBITMAP CWnd
#else 
 #include <wx/bitmap.h>
 #include <wx/window.h>
 #include <wx/dcclient.h>
 #define BASEBITMAP wxWindow
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
        void    LoadFile( string filename, bool transp );
        void    SetGeometry( const int top, const int left, const int bottom, const int right );
        int GetTop();
        int GetLeft();
        int GetWidth();
        int GetHeight();
        int GetIdealWidth();
        int GetIdealHeight();
        static int      AddBitmap();
        static void     RemoveBitmap();
        void CxDestroyWindow();

        // attributes
        CrGUIElement *  ptr_to_crObject;

    protected:
        // attributes
        static int      mBitmapCount;
        int mCharsWidth;
        int mWidth;
        int mHeight;
        bool mbOkToDraw;

#ifdef CRY_USEMFC
        void ReplaceBackgroundColour();
        CBitmap mbitmap;
        CPalette mpal;

        afx_msg void OnPaint();
        DECLARE_MESSAGE_MAP()
#else
		wxBitmap mbitmap;
                wxPalette mpal;

                void OnPaint(wxPaintEvent & event);
                DECLARE_EVENT_TABLE()
#endif
};
#endif
