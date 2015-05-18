////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CxTextOut.h
//   Authors:   Richard Cooper

#ifndef     __CxTextOut_H__
#define     __CxTextOut_H__

#include   <string>
#include   <vector>
using namespace std;

#ifdef CRY_USEMFC
 #include <afxwin.h>
 #define BASETEXTOUT CWnd
#else
 #include <wx/window.h>
 #include <wx/dcclient.h>
 #include <wx/font.h>
 #include <wx/colour.h>
 #define BASETEXTOUT wxWindow
#endif


class CrTextOut;
class CxGrid;
class CrGUIElement;

#ifndef FLAG
#define FLAG( a,b )     ( ( a & b ) == b )
#endif  // FLAG

#define         CONTROL_BYTE          '{'                      // Control Character
#define         LINK_BYTE             '&'                      // Control Character
#define         ERROR_BYTE            'E'                      // Control Character
#define         INFO_BYTE             'I'                      // Control Character
#define         STATUS_BYTE           'S'                      // Control Character
#define         RESULT_BYTE           'R'                      // Control Character
#define         NORMAL_BYTE           'N'                      // Control Character

typedef struct _tagCOLOURCODE
{
    int nFore;      // Foreground Colour Index
    int nBack;      // Background Colour Index
        bool nUnder;            // Underline
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
    void CxDestroyWindow();

    void SetTransparent();

        // attributes
    static int mTextOutCount;

    void  SetText( const string &cText );
    void  Empty();                      // Set the Head
    void  ViewTop();                    // Set the Head
    void  ChooseFont();
    void  ScrollPage(bool up);

    unsigned int GetLineCount() const { return m_Lines.size(); };


    void AddLine( const string& strLine );  // Add a Line

#ifdef CRY_USEMFC
    void CxSetFont( LOGFONT& lf );        // Set the Font
    void SetColourTable( COLORREF* pColTable ) { memcpy( &m_ColTable, pColTable, sizeof( COLORREF ) * 16 ); if( GetSafeHwnd() ) Invalidate(); };
#else
 #define COLORREF wxColour
    void CxSetFont( wxFont* lf );        // Set the Font
#endif

    void SetBackColour( COLORREF col ); // Set the background Colour
    void SetHead( int nHead );          // Set the Head
    int GetHead() const { return( m_nHead ); }; // Return the Head
    unsigned int GetMaxViewableLines();     // Return viewable lines

    bool IsAHit( string & commandString, int x, int y );

  private:
// attributes
    CrTextOut * ptr_to_crObject;
    int     mIdealHeight;
    int     mIdealWidth;
    bool mbOkToDraw;

    vector<string> m_Lines;

#ifdef CRY_USEMFC
    CFont*          m_pFont;            // Font we are using
    LOGFONT         m_lfFont;           // Font as a LOGFONT
    COLORREF        m_BackCol;          // Background Colour
    HCURSOR         m_hCursor;          // Cursor for the window
    COLORREF        m_ColTable[ 16 ];   // Colour Table
#else
    wxFont*         m_pFont;            // Font we are using
    wxBrush*        m_brush;
    wxPen*          m_pen;
    wxColour        m_BackCol;
    wxColour        m_ColTable[16];
#endif
    int             m_nHead;            // Head of the buffer
    unsigned int    m_nMaxLines;            // Maximum buffer size
    int             m_nDefTextCol;          // Default Text Colour Index
    int             m_nXOffset;                     // X Offset for drawing
    unsigned int    m_nMaxWidth;            // Maximum Written so far
    unsigned int    m_nAvgCharWidth;        // Average Char Width
    bool            m_bInLink;            // Word wrapping?
    unsigned int    m_nFontHeight;          // Height of the font
    unsigned int    m_nLinesDone;           // Actual number of lines we drew last-time
    void UpdateHScroll();
    void UpdateVScroll();
    int             m_zDelta;

#ifdef CRY_USEMFC
 #define PlatformDC CDC
#else
 #define PlatformDC wxDC
#endif

    bool RenderSingleLine( string&, PlatformDC*, int, int );
    int  GetColourCodes( string&, COLOURCODE* );      // Remains the same

#ifdef CRY_USEMFC
  protected:
    afx_msg void OnPaint();
    afx_msg BOOL OnEraseBkgnd(CDC* pDC);
    afx_msg void OnVScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg void OnSize(UINT nType, int cx, int cy);
    afx_msg void OnHScroll(UINT nSBCode, UINT nPos, CScrollBar* pScrollBar);
    afx_msg BOOL OnSetCursor(CWnd* pWnd, UINT nHitTest, UINT message);
    afx_msg BOOL OnMouseWheel(UINT nFlags, short zDelta, CPoint pt);
    afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
    afx_msg void OnRButtonDown(UINT nFlags, CPoint point);
    afx_msg void OnMouseMove( UINT nFlags, CPoint wpoint );
    afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
    //}}AFX_MSG
    afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
    DECLARE_MESSAGE_MAP()
#else
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
