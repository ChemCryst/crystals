////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CxTextOut.h
//   Authors:   Richard Cooper

#ifndef     __CxTextOut_H__
#define     __CxTextOut_H__

#ifdef __BOTHWX__
#include <wx/window.h>
#include <wx/dcclient.h>
#include <wx/font.h>
#define BASETEXTOUT wxWindow
#endif

#ifdef __CR_WIN__
#include <afxwin.h>
#define BASETEXTOUT CWnd
#endif

class CrTextOut;
class CxGrid;
class CrGUIElement;

#ifndef FLAG
#define FLAG( a,b )     ( ( a & b ) == b )
#endif  // FLAG

#define         CONTROL_BYTE             '{'                      // Control Character
#define         LINK_BYTE             '&'                      // Control Character

typedef struct _tagCOLOURCODE
{
    int nFore;      // Foreground Colour Index
    int nBack;      // Background Colour Index
        Boolean nUnder;            // Underline
} COLOURCODE;

#define COLOUR_WHITE        0
#define COLOUR_BLACK        1
#define COLOUR_BLUE         2
#define COLOUR_GREEN        3
#define COLOUR_LIGHTRED     4
#define COLOUR_BROWN        5
#define COLOUR_PURPLE       6
#define COLOUR_ORANGE       7
#define COLOUR_YELLOW       8
#define COLOUR_LIGHTGREEN   9
#define COLOUR_CYAN         10
#define COLOUR_LIGHTCYAN    11
#define COLOUR_LIGHTBLUE    12
#define COLOUR_PINK         13
#define COLOUR_GREY         14
#define COLOUR_LIGHTGREY    15

//End of user code.

class CxTextOut : public BASETEXTOUT
{
    public:
        // methods

    static  CxTextOut * CreateCxTextOut( CrTextOut * container, CxGrid * guiParent );
    static int AddTextOut( void) { mTextOutCount++; return mTextOutCount; };
    static void RemoveTextOut( void) { mTextOutCount--; };

        CxTextOut( CrTextOut * container );
        ~CxTextOut();
    void Init();
    void Focus();
    void    SetIdealWidth(int nCharsWide);
    void    SetIdealHeight(int nCharsHigh);
    int GetIdealWidth();
    int GetIdealHeight();
    int GetTop();
    int GetWidth();
    int GetHeight();
    int GetLeft();
    void    SetGeometry(int top, int left, int bottom, int right );
        void SetOriginalSizes();

        // attributes
        static int mTextOutCount;

        void  SetText( CcString cText );
        void  Empty();                      // Set the Head
        void  ChooseFont();

#ifdef __BOTHWX__
#define COLORREF wxColour
    int GetLineCount() const { return( m_Lines.GetCount() ); }; // Get Line Count
    void CxSetFont( wxFont* lf );        // Set the Font
#endif

    void AddLine( CcString& strLine );  // Add a Line
#ifdef __CR_WIN__
    void CxSetFont( LOGFONT& lf );        // Set the Font
    void SetColourTable( COLORREF* pColTable ) { memcpy( &m_ColTable, pColTable, sizeof( COLORREF ) * 16 ); if( GetSafeHwnd() ) Invalidate(); };
    int GetLineCount() const { return( m_Lines.GetUpperBound() + 1 ); };    // Get Line Count
#endif
    void SetBackColour( COLORREF col ); // Set the background Colour
    void SetHead( int nHead );          // Set the Head
    int GetHead() const { return( m_nHead ); }; // Return the Head
        int GetMaxViewableLines();     // Return viewable lines

        Boolean IsAHit( CcString & commandString, int x, int y );

protected:




    private:
        // attributes
    CrTextOut * ptr_to_crObject;
    int     mIdealHeight;
    int     mIdealWidth;
//    int    mHeight;
    COLORREF        m_BackCol;          // Background Colour
        bool mbOkToDraw;

#ifdef __CR_WIN__
    CFont*          m_pFont;            // Font we are using
    LOGFONT         m_lfFont;           // Font as a LOGFONT
    CStringArray    m_Lines;            // Lines
#endif
#ifdef __BOTHWX__
    wxFont*         m_pFont;            // Font we are using
    wxStringList    m_Lines;
#endif
    int             m_nHead;            // Head of the buffer
        int                    m_nMaxLines;            // Maximum buffer size
        int                    m_nDefTextCol;          // Default Text Colour Index
        int                     m_nXOffset;                     // X Offset for drawing
        int                    m_nMaxWidth;            // Maximum Written so far
        int                    m_nAvgCharWidth;        // Average Char Width
        bool                    m_bInLink;            // Word wrapping?
#ifdef __CR_WIN__
    HCURSOR         m_hCursor;          // Cursor for the window
#endif
        int                    m_nFontHeight;          // Height of the font
    COLORREF        m_ColTable[ 16 ];   // Colour Table
        int                    m_nLinesDone;           // Actual number of lines we drew last-time

    void UpdateHScroll();
    void UpdateVScroll();

#ifdef __CR_WIN__
#define PlatformDC CDC
#endif
#ifdef __BOTHWX__
#define PlatformDC wxDC
#endif

    void RenderSingleLine( CcString&, PlatformDC*, int, int );
    int  GetColourCodes( CcString&, COLOURCODE* );      // Remains the same

#ifdef __CR_WIN__
        protected:
    afx_msg void OnPaint();
        afx_msg BOOL OnEraseBkgnd(CDC* pDC);
    afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
    afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
    afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
        afx_msg void OnMouseMove( UINT nFlags, CPoint wpoint );
    //}}AFX_MSG
        afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
        DECLARE_MESSAGE_MAP()
#endif
#ifdef __BOTHWX__
      public:
     void OnPaint(wxPaintEvent & evt);
     void OnEraseBackground(wxEraseEvent & evt);
     void OnScroll(wxScrollWinEvent & evt);
     void OnSize(wxSizeEvent & evt);
     void OnLButtonUp(wxMouseEvent & evt);
     void OnRButtonDown(wxMouseEvent & evt);
         void OnMouseMove(wxMouseEvent & evt);
         void OnChar(wxKeyEvent & event );
         DECLARE_EVENT_TABLE()
#endif

};
#endif
