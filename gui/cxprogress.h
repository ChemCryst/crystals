////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxProgress

////////////////////////////////////////////////////////////////////////

//   Filename:  CxProgress.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  12.3.1998 9:47 Uhr

#ifndef		__CxProgress_H__
#define		__CxProgress_H__
//Insert your own code here.
#include	"crguielement.h"

#ifdef __POWERPC__
class LCaption;
#endif

#ifdef __MOTO__
#include	<LCaption.h>
#endif

#ifdef __LINUX__
#include <wx/gauge.h>
#include <wx/stattext.h>
#define BASEPROGRESS wxGauge
#endif

#ifdef __WINDOWS__
#include <afxwin.h>
#define BASEPROGRESS CProgressCtrl
#endif

class CrProgress;
class CxGrid;
//End of user code.         
 
class CxProgress : public BASEPROGRESS
{
	public:
		void SetProgress (int complete);
		// methods
		static CxProgress *	CreateCxProgress( CrProgress * container, CxGrid * guiParent );
			CxProgress( CrProgress * container );
			~CxProgress();
		void	SetText( char * text );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		int	GetTop();
		int	GetLeft();
		int	GetWidth();
		int	GetHeight();
		int	GetIdealWidth();
		int	GetIdealHeight();
		static int	AddProgress();
		static void	RemoveProgress();
		void	SetVisibleChars( int count );
		
		// attributes
		CrGUIElement *	mWidget;
		
	protected:
		// methods
		
		// attributes
		static int	mProgressCount;
		int mCharsWidth;		
private:
#ifdef __WINDOWS__
            CStatic* m_TextOverlay;
#endif
#ifdef __LINUX__
            wxStaticText* m_TextOverlay;
#endif

};
#endif
