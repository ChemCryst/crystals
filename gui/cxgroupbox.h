////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxGroupBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxGroupBox.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  5.3.1998 16:18 Uhr

#ifndef		__CxGroupBox_H__
#define		__CxGroupBox_H__
//Insert your own code here.
#include	"CrGUIElement.h"

#include <afxwin.h>

class CrGrid;
class CxGrid;
class CxGroupBox;
//End of user code.         
 
class	CxGroupBox : public CButton
{
	public:
		// methods
		static CxGroupBox *	CreateCxGroupBox( CrGrid * container, CxGrid * guiParent );
			CxGroupBox( CrGrid * container );
			~CxGroupBox();
		void	SetText( char * text );
		void	SetGeometry( const int top, const int left, const int bottom, const int right );
		static int AddGroupBox( void) { mGroupBoxCount++; return mGroupBoxCount; };
		static void RemoveGroupBox( void) { mGroupBoxCount--; };
		
		// attributes
		static int mGroupBoxCount;
};
#endif
