////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrBitmap

////////////////////////////////////////////////////////////////////////

//   Filename:  CrBitmap.cc
//   Authors:   Richard Cooper

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include        "crbitmap.h"

#include    "crgrid.h"
#include        "cxbitmap.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands


CrBitmap::CrBitmap( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
        ptr_to_cxObject = CxBitmap::CreateCxBitmap( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = false;
    m_Trans = false;
}

CrBitmap::~CrBitmap()
{
    if ( ptr_to_cxObject != nil )
    {
                ((CxBitmap*) ptr_to_cxObject)->CxDestroyWindow();
#ifdef __CR_WIN__
                delete (CxBitmap*) ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrBitmap,CxBitmap)
CRGETGEOMETRY(CrBitmap,CxBitmap)
CRCALCLAYOUT(CrBitmap,CxBitmap)

CcParse CrBitmap::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    Boolean hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
       retVal = CrGUIElement::ParseInputNoText( tokenList );
       mSelfInitialised = true;
       LOGSTAT( "Created Bitmap " + mName );
       if ( tokenList->GetDescriptor(kAttributeClass) == kTTransparent )
       {
         m_Trans = true;
         tokenList->GetToken(); // Remove that token!
       }
    }

    // End of Init, now comes the general parser
    while ( hasTokenForMe )
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTBitmapFile:
            {
                tokenList->GetToken(); // Remove that token!
                mText = tokenList->GetToken();
                                ((CxBitmap*)ptr_to_cxObject)->LoadFile(mText,m_Trans);
                                LOGSTAT( "Loading bitmap " + mText );
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
}

void    CrBitmap::SetText( CcString text )
{
// Do nothing - just overriding virtual void...
}


void CrBitmap::CrFocus()
{

}
