////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxTextOut

////////////////////////////////////////////////////////////////////////

//   Filename:  CxTextOut.h
//   Authors:   Richard Cooper

#ifndef		__CxTextOut_H__
#define		__CxTextOut_H__

#include "crystalsinterface.h"

#ifdef __LINUX__
#include <wx/textctrl.h>
#define BASETEXTOUT wxTextCtrl
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASETEXTOUT CWnd
#endif

class CrTextOut;
class CxGrid;
class CrGUIElement;

#ifndef FLAG
#define FLAG( a,b )		( ( a & b ) == b )
#endif	// FLAG

#define         CONTROL_BYTE             "{"                      // Control Character
#define         LINK_BYTE             "&"                      // Control Character
#define		WRAP_BYTE			30			// Word-wrap byte

typedef struct _tagCOLOURCODE
{
	UINT nFore;		// Foreground Colour Index
	UINT nBack;		// Background Colour Index
        BOOL nUnder;            // Underline
} COLOURCODE;

#define COLOUR_WHITE		0
#define COLOUR_BLACK		1
#define COLOUR_BLUE			2
#define COLOUR_GREEN		3
#define COLOUR_LIGHTRED		4
#define COLOUR_BROWN		5
#define COLOUR_PURPLE		6
#define COLOUR_ORANGE		7
#define COLOUR_YELLOW		8
#define COLOUR_LIGHTGREEN	9
#define COLOUR_CYAN			10
#define COLOUR_LIGHTCYAN	11
#define COLOUR_LIGHTBLUE	12
#define COLOUR_PINK			13
#define COLOUR_GREY			14
#define COLOUR_LIGHTGREY	15

//End of user code.         

class CxTextOut : public BASETEXTOUT
{
	public:
		// methods
		
		static	CxTextOut * CreateCxTextOut( CrTextOut * container, CxGrid * guiParent );
		static int AddTextOut( void) { mTextOutCount++; return mTextOutCount; };
		static void RemoveTextOut( void) { mTextOutCount--; };

        CxTextOut( CrTextOut * container );
        ~CxTextOut();
		void Init();
		void Focus();
		void	SetIdealWidth(int nCharsWide);
		void	SetIdealHeight(int nCharsHigh);
		int	GetIdealWidth();
		int	GetIdealHeight();
		int	GetTop();
		int	GetWidth();
		int	GetHeight();
		int	GetLeft();
		void	SetGeometry(int top, int left, int bottom, int right );
        void SetOriginalSizes();
        
		// attributes
		static int mTextOutCount;

        void  SetText( CcString cText );
        void  Empty();                      // Set the Head
        void  ChooseFont();                  

		void SetDefaultTextColour( UINT nIndex ) { m_nDefTextCol = nIndex; if( GetSafeHwnd() ) Invalidate(); };	// Set default text colour
		void AddLine( CString& strLine );	// Add a Line
		void SetFont( LOGFONT& lf );		// Set the Font
		void SetBackColour( COLORREF col );	// Set the background Colour
		void SetColourTable( COLORREF* pColTable ) { memcpy( &m_ColTable, pColTable, sizeof( COLORREF ) * 16 ); if( GetSafeHwnd() ) Invalidate(); };
		void SetHead( int nHead );			// Set the Head
		int GetHead() const { return( m_nHead ); };	// Return the Head
//		void SetMaxLines( UINT nMaxLines );		// Set max number of lines
//		UINT GetMaxLines() const { return( m_nMaxLines ); };	// Return max number of lines
		UINT GetMaxViewableLines();	// Return viewable lines
		int GetLineCount() const { return( m_Lines.GetUpperBound() + 1 ); };	// Get Line Count
		CString GetLine( int l ) const { return( m_Lines.GetAt( l ) ); };	// Retrieve a specific line
                BOOL IsAHit( CString & commandString, CPoint wpoint );

	// Generated message map functions
protected:
	//{{AFX_MSG(CxTextOut)
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


	
	private:
		// attributes
		CrTextOut *	mWidget;
		int		mIdealHeight;
		int		mIdealWidth;
		int    mHeight;
		CFont*			m_pFont;			// Font we are using
		LOGFONT			m_lfFont;			// Font as a LOGFONT
		COLORREF		m_BackCol;			// Background Colour
		CStringArray	m_Lines;			// Lines
		int				m_nHead;			// Head of the buffer
		UINT			m_nMaxLines;		// Maximum buffer size
		UINT			m_nDefTextCol;		// Default Text Colour Index
                int                     m_nXOffset;                     // X Offset for drawing
		UINT			m_nMaxWidth;		// Maximum Written so far
		UINT			m_nAvgCharWidth;	// Average Char Width
		bool			m_bWordWrap;		// Word wrapping?
                bool                    m_bInLink;            // Word wrapping?
		HCURSOR			m_hCursor;			// Cursor for the window
		UINT			m_nFontHeight;		// Height of the font
		COLORREF		m_ColTable[ 16 ];	// Colour Table
		UINT			m_nLinesDone;		// Actual number of lines we drew last-time

		void UpdateHScroll();
		void UpdateVScroll();

		int	 GetLineInfo( CString&, CDC*, int );
		void RenderSingleLine( CString&, CDC*, int, int );
		int  GetColourCodes( CString&, COLOURCODE* );		// Remains the same

#ifdef __WINDOWS__
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		DECLARE_MESSAGE_MAP()
#endif
#ifdef __LINUX__
      public:
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
