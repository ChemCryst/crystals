////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CxEditBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CxEditBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  9.3.1998 10:08 Uhr

#include	"CrystalsInterface.h"
#include	"CxEditBox.h"
//Insert your own code here.
#include	"CxGrid.h"
#include	"CxWindow.h"
#include	"CrEditBox.h"
//#include	<TextUtils.h>
//#include	<LEditField.h>
//#include	<LWindow.h>
//#include "CcController.h"
//#include	<UKeyFilters.h>
//#include	<UTextTraits.h>

int CxEditBox::mEditBoxCount = kEditBoxBase;

//End of user code.          

// OPSignature: CxEditBox * CxEditBox:CreateCxEditBox( CrEditBox *:container  CxGrid *:guiParent ) 
CxEditBox *	CxEditBox::CreateCxEditBox( CrEditBox * container, CxGrid * guiParent )
{
//As with all these Cx classes, this is a static funtion. Call it to create an editbox,
//and it will do the initialisation for you.
	
//Insert your own code here.
/*	SPaneInfo	thePaneInfo;	// Info for Pane
	thePaneInfo.visible = true;
	thePaneInfo.enabled = true;
	thePaneInfo.bindings.left = false;
	thePaneInfo.bindings.right = false;
	thePaneInfo.bindings.top = false;
	thePaneInfo.bindings.bottom = false;
	thePaneInfo.userCon = 0;
	thePaneInfo.superView = reinterpret_cast<LView *>(guiParent);
	thePaneInfo.paneID = AddEditBox();		// Dynamic Pane determination
	thePaneInfo.width = 80;
	thePaneInfo.height = 20;
	thePaneInfo.left = 10;
	thePaneInfo.top = 50;
*/	
//	char * defaultName = (char *)"EditBox";
	CxEditBox	*theEditBox = new CxEditBox( container );
	theEditBox->Create(ES_LEFT|ES_AUTOHSCROLL|WS_VISIBLE|WS_CHILD|ES_WANTRETURN,CRect(0,0,10,10),guiParent,mEditBoxCount++);
	theEditBox->ModifyStyleEx(NULL,WS_EX_CLIENTEDGE,0);  //Sink it into the window.
	theEditBox->SetFont(CxGrid::mp_font);

	return theEditBox;
//End of user code.         
}
// OPSignature:  CxEditBox:CxEditBox( CrEditBox *:container  SPaneInfo:&inPaneInfo char *:defaultName ) 
	CxEditBox::CxEditBox( CrEditBox * container )
//Insert your own initialization here.
	:CEdit()
//End of user initialization.         
{
//Insert your own code here.
	mWidget = container;      //This is the container (CrEditBox)
	mCharsWidth = 5;          //This is the default width if none is specified.
	allowedInput = CXE_TEXT_STRING;  //This is the default allowed input. See header file for other types.
//End of user code.         
}
// OPSignature:  CxEditBox:~CxEditBox() 
	CxEditBox::~CxEditBox()
{
//Insert your own code here.
	RemoveEditBox();
//End of user code.         
}
// OPSignature: void CxEditBox:SetText( char *:text ) 
void	CxEditBox::SetText( char * text )
{
//Insert your own code here.
#ifdef __POWERPC__
	Str255 descriptor;
	
	strcpy( reinterpret_cast<char *>(descriptor), text );
	c2pstr( reinterpret_cast<char *>(descriptor) );
	SetDescriptor( descriptor );
#endif
#ifdef __LINUX__
	setText(text);
#endif
#ifdef __WINDOWS__

//If we have an integer, read it in then write it out again to check.
	if(allowedInput == CXE_INT_NUMBER)
	{
		int number = atoi(text);
		sprintf(text,"%-d",number);
		//Remove spaces.
		for ( int i = strlen(text) - 1; i > 0; i-- )
			if ( text[i] == ' ' )
				text[i] = '\0';
			else
				i = 0;
	}
//If we have an real, read it in then write it out again to check.
	else if( allowedInput == CXE_REAL_NUMBER)
	{
		double number = atof(text);
		sprintf(text,"%-8.5g",number);     //LOOK OUT. Precision limited to 5 places. (Width will probably not truncate though.)
		//Remove spaces.
		for ( int i = strlen(text) - 1; i > 0; i-- )
			if ( text[i] == ' ' )
				text[i] = '\0';
			else
				i = 0;
	}

	
	SetWindowText( text );
#endif
//End of user code.         
}

void	CxEditBox::AddText( char * text )
{
	SetSel(-1,-1);       //Set the selection at the end of the text buffer.
	ReplaceSel(text);    //Replace the selection (nothing) with the text to add.
	SetWindowPos(&wndTop,0,0,0,0,SWP_NOMOVE|SWP_NOSIZE|SWP_SHOWWINDOW); //Bring the focus to this window.
	//This is notmally nt necessary, as the box will have the focus anyway if the user
	//is typing in to it. It does matter for the floating input box, which gets sent
	//all characters that other windows don't want, in order to make it easier for
	//the user to type things.
}

void	CxEditBox::SetGeometry( int top, int left, int bottom, int right )
{
	MoveWindow(left,top,right-left,bottom-top,true); //Move the edit box
}
int	CxEditBox::GetTop()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.top -= parentRect.top;
	}
	return ( windowRect.top );
}
int	CxEditBox::GetLeft()
{
	RECT windowRect;
	RECT parentRect;
	GetWindowRect(&windowRect);
	CWnd* parent = GetParent();
	if(parent != nil)
	{
		parent->GetWindowRect(&parentRect);
		windowRect.left -= parentRect.left;
	}
	return ( windowRect.left );
}
int	CxEditBox::GetWidth()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Width() );
}
int	CxEditBox::GetHeight()
{
	CRect windowRect;
	GetWindowRect(&windowRect);
	return ( windowRect.Height() );
}

// OPSignature: int CxEditBox:GetIdealWidth() 
int	CxEditBox::GetIdealWidth()
{
//Insert your own code here.
/*	Str255 descriptor, str, dummy = "\p0";
	Int16 strSize, requestSize;
	
	GetDescriptor( descriptor );
	GetDescriptor( str );
	p2cstr( str );
	
	// take a dummy size
	requestSize = ::StringWidth(dummy) * mCharsWidth + 5;
	
	// Check for empty strings
	if ( strlen( (char *)str ) == 0 )
		strSize = 30;
	else
		strSize = ::StringWidth(descriptor) + 5;	// 5 pixels slop on the sides

	if ( requestSize > strSize )
		strSize = requestSize;
*/
/*	CString text;
	SIZE size;
	HDC hdc= (HDC) (GetDC()->m_hAttribDC);
	GetWindowText(text);
	GetTextExtentPoint32(hdc, text, text.GetLength(), &size);
	return ( size.cx + 10);
*/
	CClientDC cdc(this);	//Get the device context for this window (edit box).
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font); //Select the standard font into the device context, save the old one for later.
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);   //Get the metrics for this font.
	cdc.SelectObject(oldFont);         //Select the old font back into the DC.
	return mCharsWidth * textMetric.tmAveCharWidth;  //Work out the ideal width.

	//End of user code.         
}
// OPSignature: int CxEditBox:GetIdealHeight() 
int	CxEditBox::GetIdealHeight()
{
//Insert your own code here.
//	Int16 just = UTextTraits::SetPortTextTraits(mTextTraitsID);

//	FontInfo fInfo;
//	::GetFontInfo(&fInfo);
	CClientDC cdc(this);   //See GetIdealWidth for how this works.
	CFont* oldFont = cdc.SelectObject(CxGrid::mp_font);
	TEXTMETRIC textMetric;
	cdc.GetTextMetrics(&textMetric);
	cdc.SelectObject(oldFont);
	return textMetric.tmHeight + 5;
//End of user code.         
}
// OPSignature: int CxEditBox:GetText() 
int CxEditBox::GetText(char* theText, int maxlen)
{
//Insert your own code here.
	int textlen = GetWindowText(theText,maxlen);
	
//If the allowed input is a number, check it before returning.
//It should be a number, if it isn't 0 or 0.0 will be returned.
	if(allowedInput == CXE_INT_NUMBER)
	{
		int number = atoi(theText);
		sprintf(theText,"%-d",number);
	}
	else if( allowedInput == CXE_REAL_NUMBER)
	{
		double number = atof(theText);
		sprintf(theText,"%-f",number);
	}

	return textlen;

//	GetDescriptor( descriptor );
	
//	if ( theRetVal != nil )
//	{
//		strcpy( theRetVal, reinterpret_cast<char *>(descriptor) );
//		p2cstr( reinterpret_cast<StringPtr>(theRetVal) );
//	}
//	return ( theRetVal );
//End of user code.         
}
// OPSignature: void CxEditBox:SetVisibleChars( int:count ) 
void	CxEditBox::SetVisibleChars( int count )
{
//Insert your own code here.
	mCharsWidth = count;   //Set the ideal width in characters.
//End of user code.         
}
void	CxEditBox::EditChanged()
{
	((CrEditBox*)mWidget)->BoxChanged();  //Inform container that the text has changed.
}


BEGIN_MESSAGE_MAP(CxEditBox, CEdit)
	ON_WM_CHAR()
	ON_WM_KEYDOWN()
END_MESSAGE_MAP()

void CxEditBox::Focus()
{
	SetFocus();
	SetSel(GetWindowTextLength(),GetWindowTextLength()); 	//Place caret at end of text.
}

void CxEditBox::OnChar( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	if( nChar == 9 )   //TAB. Move focus to next UI object.
	{
		Boolean shifted = ( HIWORD(GetKeyState(VK_SHIFT)) != 0) ? true : false;
		mWidget->NextFocus(shifted);
	}
	else if ( allowedInput == CXE_READ_ONLY )
	{
		return;
	}
	else if ( nChar == 13 ) //RETURN.
	{
		((CrEditBox*)mWidget)->ReturnPressed();
	}
	else
	{
//Block unwanted keypresses...
		char c = (char) nChar;
		if(iscntrl( nChar )) //It it a control char (delete, arrow keys), let it through
		{
			CEdit::OnChar( nChar, nRepCnt, nFlags );
			EditChanged();
			return;
		}

		if( allowedInput != CXE_TEXT_STRING ) //It's not text (it's a number).
		{
			if (((c < '0') || (c > '9')) && (c != '.')) {Beep(1000,50); return;} //If it is non numeric, and not '.', then ignore.
		}
		
		if( allowedInput == CXE_INT_NUMBER ) //It's an integer.
		{
			if ( c == '.' ) {Beep(1000,50); return;} //If it's a dot, ignore.
		}

		CEdit::OnChar( nChar, nRepCnt, nFlags );
		EditChanged();
		return;
	}
}

void CxEditBox::OnKeyDown( UINT nChar, UINT nRepCnt, UINT nFlags )
{
	if(nChar == 38) //Up.
		((CrEditBox*)mWidget)->Arrow(true);
	else if (nChar == 40) //Down.
		((CrEditBox*)mWidget)->Arrow(false);
	CEdit::OnKeyDown( nChar, nRepCnt, nFlags );
	return;
}

void CxEditBox::Disable(Boolean disable)
{
	if(disable)               //I call it Disable(TRUE), they call it Enable(FALSE).
		EnableWindow(FALSE);
	else
		EnableWindow(TRUE);
}

void CxEditBox::SetInputType(int type)
{
	allowedInput = type;  //See header file for the three types. The default
						  // is to allow text. It can be changed to REAL or INT.
}

void CxEditBox::ClearBox()
{
	SetSel(0,-1);       //Set the selection to the whole of the text buffer.
	Clear();			//Clears the selection.
}
