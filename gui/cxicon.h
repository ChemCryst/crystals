////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxIcon

////////////////////////////////////////////////////////////////////////

//   Filename:  CxIcon.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 9:47 Uhr

#ifndef           __CxIcon_H__
#define           __CxIcon_H__
#include	"crguielement.h"

#ifdef __LINUX__
#include <wx/stattext.h>
#define BASETEXT wxStaticText
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASETEXT CStatic
#endif

class CrIcon;
class CxGrid;
//End of user code.         
 
class CxIcon : public BASETEXT
{
	public:
		// methods
            static CxIcon *   CreateCxIcon( CrIcon * container, CxGrid * guiParent );
                  CxIcon( CrIcon * container );
                  ~CxIcon();
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
            void SetIconType( int iIconId );
		
		// attributes
		CrGUIElement *	mWidget;
		
	protected:
		// methods
		
		// attributes
		static int	mTextCount;
		int mCharsWidth;		
};
#endif
