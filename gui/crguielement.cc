////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGUIElement

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGUIElement.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:19 Uhr
//   Modified:  30.3.1998 13:33 Uhr

#include	"crystalsinterface.h"
#include	"crconstants.h"
#include	"crguielement.h"
#include	"cclist.h"
#include	"ccrect.h"
#include	"cccontroller.h"
#include	"cctokenlist.h"
#include	"crwindow.h"

CcController *	CrGUIElement::mControllerPtr;

CrGUIElement::CrGUIElement( CrGUIElement * mParentPtr )
{
	mParentElementPtr = mParentPtr;
	mWidgetPtr = nil;
	mSelfInitialised = false;
	mCallbackState = false;
	mAlignment = kNoAlignment;
	mWidthFactor = 1.0;
	mHeightFactor = 1.0;
	mXCanResize = false;
	mYCanResize = false;
	mTabStop = true;
	mDisabled = true;
}

CrGUIElement::~CrGUIElement()
{
}

CrGUIElement *	CrGUIElement::FindObject( CcString Name )
{
	if ( Name == mName )
		return this;
	else
		return nil;
}

void *	CrGUIElement::GetWidget()
{
	if ( mWidgetPtr == nil )
		return mParentElementPtr->GetWidget();
	else
		return mWidgetPtr;
}

CrGUIElement *	CrGUIElement::GetRootWidget()
{
	return mParentElementPtr->GetRootWidget();
}


void	CrGUIElement::Show( Boolean show )
{
	NOTUSED(show);
}

void	CrGUIElement::Align()
{

}
void	CrGUIElement::GetValue()
{
//For all elements that don't return a value, return the text TRUE,
//so the programmer can test their existence.
	(CcController::theController)->SendCommand("TRUE",true);
//(If the element can't be found, FALSE is returned from CcController)
}

void	CrGUIElement::GetValue(CcTokenList * tokenList)
{
//For all elements that don't return a value, return the text ERROR,
//The only valid query for an object that doesn't override this function
//is EXISTS, and that is handled in the CcController::GetValue routine.
	(CcController::theController)->SendCommand("ERROR",true);
}

Boolean	CrGUIElement::ParseInput( CcTokenList * tokenList )
{
	Boolean retVal = false;
	
	mName = tokenList->GetToken();
	mText = tokenList->GetToken();

	SetText(mText);
	
	if ( mText.Length() != 0 || mName.Length() != 0 )
		retVal = true;

	LOGSTAT( "Setting identifier " + mName + 
			 "Setting text "      + mText  );
						
	return retVal;
}

Boolean	CrGUIElement::ParseInputNoText( CcTokenList * tokenList )
{
	Boolean retVal = false;
	
	mName = tokenList->GetToken();

	if ( mName.Length() != 0 )
		retVal = true;

	LOGSTAT( "Setting identifier " + mName );
						
	return retVal;
}


 
 
void	CrGUIElement::SetController( CcController * controller )
{
	mControllerPtr = controller;
}


int CrGUIElement::GetIdealWidth()
{
//This just returns zero. It is overridden for elements which can resize.
	return 0;
}

int CrGUIElement::GetIdealHeight()
{
//This just returns zero. It is overridden for elements which can resize.
	return 0;
}

void CrGUIElement::Resize(int newColWidth, int newRowHeight, int origColWidth, int origRowHeight)
{
	mWidthFactor = (float)((float)newColWidth / (float)origColWidth);
	mHeightFactor= (float)((float)newRowHeight/ (float)origRowHeight);
}


void CrGUIElement::NextFocus(Boolean bPrevious)
{
	CrGUIElement* nextWindow;
	CrWindow* rootWindow = (CrWindow*)GetRootWidget();

	if(bPrevious)
		nextWindow = (CrGUIElement*)rootWindow->GetPrevTabItem(this);
	else
		nextWindow = (CrGUIElement*)rootWindow->GetNextTabItem(this);

	if(nextWindow)
		nextWindow->CrFocus();
}


void CrGUIElement::FocusToInput(char theChar)
{
	GetRootWidget()->FocusToInput(theChar); //Give the window a chance to handle the
										  //input first.
}


void CrGUIElement::SendCommand(CcString theText, Boolean jumpQueue)
{
	if(jumpQueue)
		CcController::theController->SendCommand(theText,true);
	else
            mParentElementPtr->SendCommand(theText); //Give the parent objects a chance to handle the
											   //output first.
//NB For Grid and Window, this function is overridden, to allow commands
//to be prefixed to the output.
//If a command is prefixed, the CcController implementation is called and
//the text is not passed any further up the heirarchy.

}


void CrGUIElement::SysKey( UINT nChar )
{
// This should never be called. It means that a Cr object has requested
// system key messages, but doesn't have an over-riding SysKey routine
// to handle them!
}

void CrGUIElement::SysKeyUp( UINT nChar )
{
// This may be called if the requesting window only want KEYDOWN messages.
// This should never be called. It means that a Cr object has requested
// system key messages, but doesn't have an over-riding SysKey routine
// to handle them!
}

void CrGUIElement::Rename( CcString newName )
{
      LOGSTAT("Renameing object: " + mName + " to " + newName );
      mName = newName;
}

void CrGUIElement::SetOriginalSizes()
{
// Do nothing. This function is overridden by all
// re-sizeable GUIElements. e.g. Model, Chart, MultiEdit, EditBox etc.
      return;
}


