////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxText

////////////////////////////////////////////////////////////////////////

//   Filename:  CxText.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 9:47 Uhr

#ifndef		__CxText_H__
#define		__CxText_H__
#include	"crguielement.h"

#ifdef __LINUX__
#include <wx/stattext.h>
#define BASETEXT wxStaticText
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASETEXT CStatic
#endif

class CrText;
class CxGrid;
//End of user code.         
 
class CxText : public BASETEXT
{
	public:
		// methods
		static CxText *	CreateCxText( CrText * container, CxGrid * guiParent );
			CxText( CrText * container );
			~CxText();
		void	SetText( char * text );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int	AddText();
		static void	RemoveText();
		void	SetVisibleChars( int count );
		
		// attributes
		CrGUIElement *	mWidget;
		
	protected:
		// methods
		
		// attributes
		static int	mTextCount;
		int mCharsWidth;		
};
#endif
