////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxMultiEdit

////////////////////////////////////////////////////////////////////////

//   Filename:  CxMultiEdit.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   5.3.1998 13:51 Uhr
//   Modified:  5.3.1998 13:51 Uhr

#ifndef		__CxMultiEdit_H__
#define		__CxMultiEdit_H__

#include "crystalsinterface.h"

#ifdef __LINUX__
#include <wx/textctrl.h>
#define BASEMULTIEDIT wxTextCtrl
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASEMULTIEDIT CRichEditCtrl
#endif

class CrMultiEdit;
class CxGrid;
class CrGUIElement;
//End of user code.         

class CxMultiEdit : public BASEMULTIEDIT
{
	public:
		void BackALine();
            void Empty();
            void Spew();
		void SetFixedWidth(Boolean fixed);
		void SetItalic(Boolean italic);
		void SetUnderline(Boolean underline);
		void SetBold(Boolean bold);
		void SetColour (int red, int green, int blue);
		void Focus();

		// methods
		static	CxMultiEdit * CreateCxMultiEdit( CrMultiEdit * container, CxGrid * guiParent );
            CxMultiEdit( CrMultiEdit * container );
            ~CxMultiEdit();
            void  SetText( CcString cText );
//            void  SetHyperText( CcString cText, CcString cCommand  );
		void	SetIdealWidth(int nCharsWide);
		void	SetIdealHeight(int nCharsHigh);
		int	GetIdealWidth();
		int	GetIdealHeight();
		int	GetTop();
		int	GetWidth();
		int	GetHeight();
		int	GetLeft();
		void	SetGeometry(int top, int left, int bottom, int right );
		static int AddMultiEdit( void) { mMultiEditCount++; return mMultiEditCount; };
		static void RemoveMultiEdit( void) { mMultiEditCount--; };
            void SetOriginalSizes();
            void SetFontHeight( int height );
		
		// attributes
		static int mMultiEditCount;

            CcList mHyperLinks;            

	private:
		// attributes
		CrMultiEdit *	mWidget;
		int		mIdealHeight;
		int		mIdealWidth;
		int    mHeight;

#ifdef __WINDOWS__
		afx_msg void OnChar(UINT nChar, UINT nRepCnt, UINT nFlags);
		afx_msg void OnLButtonUp( UINT nFlags, CPoint point );
            afx_msg void OnLButtonDown( UINT nFlags, CPoint point );

		DECLARE_MESSAGE_MAP()
#endif
#ifdef __LINUX__
      public:
            void OnChar(wxKeyEvent & event );
            DECLARE_EVENT_TABLE()
#endif

};
#endif
