////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrText

////////////////////////////////////////////////////////////////////////

//   Filename:  CrText.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr
//   Modified:  30.3.1998 10:38 Uhr

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crtext.h"
//insert your own code here.
#include    "crgrid.h"
#include    "cxtext.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


// OPSignature:  CrText:CrText( CrGUIElement *:mParentPtr )
    CrText::CrText( CrGUIElement * mParentPtr )
//Insert your own initialization here.
    :   CrGUIElement( mParentPtr )
//End of user initialization.
{
//Insert your own code here.
    ptr_to_cxObject = CxText::CreateCxText( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = false;
//End of user code.
}
// OPSignature:  CrText:~CrText()
    CrText::~CrText()
{
//Insert your own code here.
    if ( ptr_to_cxObject != nil )
    {
        delete (CxText*) ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
//End of user code.
}
// OPSignature: Boolean CrText:ParseInput( CcTokenList *:tokenList )
Boolean CrText::ParseInput( CcTokenList * tokenList )
{
//Insert your own code here.
    Boolean retVal = true;
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Text *** Initing...");

        retVal = CrGUIElement::ParseInput( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created Text        " + mName );
    }

    // End of Init, now comes the general parser
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTTextSelector:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                SetText( mText );
                LOGSTAT( "Setting Text to '" + mText );
                break;
            }
            case kTChars:
            {
                tokenList->GetToken(); // Remove that token!
                CcString theString = tokenList->GetToken();
                int chars = atoi( theString.ToCString() );
                ((CxText*)ptr_to_cxObject)->SetVisibleChars( chars );
                LOGSTAT( "Setting Text Chars Width: " + theString );
                break;
            }
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    return retVal;
//End of user code.
}
// OPSignature: void CrText:SetText( CcString:text )
void    CrText::SetText( CcString text )
{
//Insert your own code here.
    char theText[256];
    strcpy( theText, text.ToCString() );

    ( (CxText *)ptr_to_cxObject)->SetText( theText );
//End of user code.
}
// OPSignature: void CrText:SetGeometry( const CcRect *:rect )
void    CrText::SetGeometry( const CcRect * rect )
{
//Insert your own code here.
    ((CxText*)ptr_to_cxObject)->SetGeometry(     rect->mTop,
                                            rect->mLeft,
                                            rect->mBottom,
                                            rect->mRight );
//End of user code.
}
// OPSignature: CcRect CrText:GetGeometry()
CcRect  CrText::GetGeometry()
{
//Insert your own code here.
    CcRect retVal (
            ((CxText*)ptr_to_cxObject)->GetTop(),
            ((CxText*)ptr_to_cxObject)->GetLeft(),
            ((CxText*)ptr_to_cxObject)->GetTop()+((CxText*)ptr_to_cxObject)->GetHeight(),
            ((CxText*)ptr_to_cxObject)->GetLeft()+((CxText*)ptr_to_cxObject)->GetWidth()   );
    return retVal;
//End of user code.
}
// OPSignature: void CrText:CalcLayout()
void    CrText::CalcLayout()
{
//Insert your own code here.
    int w =  ((CxText*)ptr_to_cxObject)->GetIdealWidth();
    int h =  ((CxText*)ptr_to_cxObject)->GetIdealHeight();
    ((CxText*)ptr_to_cxObject)->SetGeometry(0,0,h,w);
//End of user code.
}

void CrText::CrFocus()
{

}
