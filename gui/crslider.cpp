////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrSlider

////////////////////////////////////////////////////////////////////////

//   Filename:  CrSlider.cc
//   Authors:   Richard Cooper 
//   Created:   22.8.2017 08:08 Uhr

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crslider.h"
#include    "crgrid.h"
#include    "cxslider.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands
#include    "crwindow.h"  // for getting cursor keys


CrSlider::CrSlider( CrGUIElement * mParentPtr )
:   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxSlider::CreateCxSlider( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mXCanResize = true;
    mTabStop = true;
	mCallbackState = true;
}

CrSlider::~CrSlider()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxSlider*)ptr_to_cxObject)->CxDestroyWindow();
        ptr_to_cxObject = nil;
    }

}

CRSETGEOMETRY(CrSlider,CxSlider)
CRGETGEOMETRY(CrSlider,CxSlider)

CcRect CrSlider::CalcLayout(bool recalc)
{                                                                          
  if(!recalc) return CcRect(0,0,m_InitHeight,m_InitWidth);
  return CcRect(0,0,(int)(m_InitHeight=((CxSlider*)ptr_to_cxObject)->GetIdealHeight()),
                          m_InitWidth =((CxSlider*)ptr_to_cxObject)->GetIdealWidth());
};



CcParse CrSlider::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;

    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** Slider *** Initing...");

        retVal = CrGUIElement::ParseInputNoText( tokenList );
        mSelfInitialised = true;

        LOGSTAT( "*** Created Slider     " + mName );

        while ( hasTokenForMe && ! tokenList.empty() )
        {
            switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
            {
                case kTNumberOfColumns:
                case kTChars:
                {
                    tokenList.pop_front(); // Remove that token!
                    ((CxSlider*)ptr_to_cxObject)->SetCharWidth( atoi( tokenList.front().c_str() ) );
                    LOGSTAT( "Setting Slider Chars Width: " + tokenList.front() );
                    tokenList.pop_front();
                    break;
                }
                default:
                {
                    hasTokenForMe = false;
                    break; // We leave the token in the list and exit the loop
                }
            } //end switch
        }// end while

    }// end if

    // End of Init, now comes the general parser

    hasTokenForMe = true;
    while ( hasTokenForMe && ! tokenList.empty() )
    {
        switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
        {
            case kTInform:
            {
                tokenList.pop_front(); // Remove that token!
                bool inform = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                tokenList.pop_front(); // Remove that token!
                mCallbackState = inform;
                if (mCallbackState)
                    LOGSTAT( "Enabling Slider callback" );
                else
                    LOGSTAT( "Disabling Slider callback" );
                break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                bool disabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                LOGSTAT( "Slider disabled = " + tokenList.front());
                tokenList.pop_front();
                ((CxSlider*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTSteps:
            {
                tokenList.pop_front(); // Remove that token!
                ((CxSlider*)ptr_to_cxObject)->SetSteps( atoi( tokenList.front().c_str() ) );
                LOGSTAT( "Slider set n steps = " + tokenList.front());
                tokenList.pop_front();
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

void CrSlider::SetText( const string& s ){

}

void CrSlider::SetValue( float frac )
{
    ( (CxSlider *)ptr_to_cxObject)->SetValue( frac );
}

void CrSlider::GetValue()
{
    SendCommand( ((CxSlider*)ptr_to_cxObject)->GetText() );
}

void CrSlider::GetValue(deque<string> & tokenList)
{
    int desc = CcController::GetDescriptor( tokenList.front(), kQueryClass );
    if( desc == kTQText )
    {
        tokenList.pop_front();
        SendCommand( ((CxSlider*)ptr_to_cxObject)->GetText(), true );  
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrSlider:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }
}


void CrSlider::SliderChanged()
{
    if(mCallbackState)
        SendCommand(mName + "_N" + ((CxSlider*)ptr_to_cxObject)->GetText() );
}


int CrSlider::GetIdealWidth()
{
    return ((CxSlider*)ptr_to_cxObject)->GetIdealWidth();
}

void CrSlider::CrFocus()
{
    ((CxSlider*)ptr_to_cxObject)->Focus();
}



