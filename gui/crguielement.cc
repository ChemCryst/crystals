////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrGUIElement

////////////////////////////////////////////////////////////////////////

//   Filename:  CrGUIElement.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 13:19 Uhr
//   Modified:  30.3.1998 13:33 Uhr

#include	"CrystalsInterface.h"
#include	"CrConstants.h"
#include	"CrGUIElement.h"
//Insert your own code here.
#include	"CcList.h"
#include	"CcRect.h"
#include	"CcController.h"
#include	"CcTokenList.h"
#include	"CrWindow.h"
//End of user code.          

CcController *	CrGUIElement::mControllerPtr;
// OPSignature:  CrGUIElement:CrGUIElement( CrGUIElement *:mParentPtr ) 
	CrGUIElement::CrGUIElement( CrGUIElement * mParentPtr )
//Insert your own initialization here.

//End of user initialization.         
{
//Insert your own code here.
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
//End of user code.         
}
// OPSignature:  CrGUIElement:~CrGUIElement() 
	CrGUIElement::~CrGUIElement()
{
//Insert your own code here.

//End of user code.         
}
// OPSignature: CrGUIElement * CrGUIElement:FindObject( CcString:Name ) 
CrGUIElement *	CrGUIElement::FindObject( CcString Name )
{
//Insert your own code here.
	if ( Name == mName )
		return this;
	else
		return nil;
//End of user code.         
}
// OPSignature: void * CrGUIElement:GetWidget() 
void *	CrGUIElement::GetWidget()
{
//Insert your own code here.
	if ( mWidgetPtr == nil )
		return mParentElementPtr->GetWidget();
	else
		return mWidgetPtr;
//End of user code.         
}
// OPSignature: CrGUIElement * CrGUIElement:GetRootWidget() 
CrGUIElement *	CrGUIElement::GetRootWidget()
{
//Insert your own code here.
	return mParentElementPtr->GetRootWidget();
//End of user code.         
}
// OPSignature: void CrGUIElement:Show( Boolean:show ) 
void	CrGUIElement::Show( Boolean show )
{
//Insert your own code here.
//#pragma unused ( show )
	NOTUSED(show);
//End of user code.         
}
// OPSignature: void CrGUIElement:Align() 
void	CrGUIElement::Align()
{
//Insert your own code here.

//End of user code.         
}
// OPSignature: void CrGUIElement:GetValue() 
void	CrGUIElement::GetValue()
{
//Insert your own code here.
	//For all elements that don't return a value, return the text TRUE,
	//so the programmer can test their existence.
	(CcController::theController)->SendCommand("TRUE",true);
	//(If the element can't be found, FALSE is returned from CcController)
//End of user code.         
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


 
 
// OPSignature: void CrGUIElement:SetController( CcController *:controller ) 
void	CrGUIElement::SetController( CcController * controller )
{
//Insert your own code here.
	mControllerPtr = controller;
//End of user code.         
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


void CrGUIElement::NextFocus(BOOL bPrevious)
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
		GetRootWidget()->SendCommand(theText); //Give the window a chance to handle the
											   //output first.
}
