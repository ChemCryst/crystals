#ifdef __CR_WIN__
////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListCtrl.cc
//   Authors:   Richard Cooper
//   Created:   10.11.1998 16:36
//   Modified:  10.11.1998 16:36

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crlistctrl.h"
#include    "crwindow.h"
#include    "crgrid.h"
#include    "cxlistctrl.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands

CrListCtrl::CrListCtrl( CrGUIElement * mParentPtr )
    :   CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxListCtrl::CreateCxListCtrl( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mXCanResize = true;
    mYCanResize = true;
    mTabStop = true;
    m_cols = 0;
}

CrListCtrl::~CrListCtrl()
{
    if ( ptr_to_cxObject != nil )
    {
        delete (CxListCtrl*)ptr_to_cxObject;
        ptr_to_cxObject = nil;
    }
}

Boolean CrListCtrl::ParseInput( CcTokenList * tokenList )
{
    Boolean retVal = true;
    Boolean hasTokenForMe = true;
    CcString theToken;

    if( ! mSelfInitialised ) //Once Only.
    {
        LOGSTAT("*** ListCtrl *** Initing...");

        mName = tokenList->GetToken();
        mSelfInitialised = true;

        LOGSTAT( "*** Created ListCtrl     " + mName );

        while ( hasTokenForMe )
        {
            switch ( tokenList->GetDescriptor(kAttributeClass) )
            {
                case kTVisibleLines:
                {
                    int lines;
                    tokenList->GetToken(); // Remove the keyword
                    CcString theToken = tokenList->GetToken();
                    lines = atoi( theToken.ToCString() );
                    ( (CxListCtrl *)ptr_to_cxObject)->SetVisibleLines( lines );
                    LOGSTAT("Setting ListCtrl visible lines to " + theToken);
                    break;
                }
                case kTNumberOfColumns:
                {
                    tokenList->GetToken(); // Remove the keyword
                    CcString theToken = tokenList->GetToken();
                    m_cols = atoi( theToken.ToCString() );
                    LOGSTAT("Setting ListCtrl columns to " + theToken);
                    for (int k = 0; k < m_cols; k++)
                    {
                        theToken = tokenList->GetToken();
                        ((CxListCtrl *)ptr_to_cxObject)->AddColumn( theToken );
                    }
                    break;
                }
                default:
                {
                    hasTokenForMe = false;
                    break; // We leave the token in the list and exit the loop
                }
            }
        }

    }
    hasTokenForMe = true;
    while ( hasTokenForMe ) //Every time
    {
        switch ( tokenList->GetDescriptor(kAttributeClass) )
        {
            case kTInform:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
                tokenList->GetToken(); // Remove that token!
                mCallbackState = inform;
                if (mCallbackState)
                    LOGSTAT( "Enabling ListCtrl callback" );
                else
                    LOGSTAT( "Disabling ListCtrl callback" );
                break;
            }
            case kTAddToList:
            {
                tokenList->GetToken(); // Remove that token!
                Boolean stop = false;
                while ( ! stop )
                {
                    CcString* rowOfStrings = new CcString[m_cols];

                    for (int k = 0; k < m_cols; k++)
                    {
                        theToken = tokenList->GetToken();

                        if ( strcmp( kSNull, theToken.ToCString() ) == 0 )
                        {
                            stop = true;
                            k = m_cols;
                        }
                        else
                        {
                            rowOfStrings[k] = theToken;
                        }
                    }
                    if( ! stop ) ((CxListCtrl *)ptr_to_cxObject)->AddRow( rowOfStrings );
                    delete [] rowOfStrings; //Oops, forgot this first time!
                }
                break;
            }
            case kTSelectAtoms:
            {
                tokenList->GetToken(); //Remove the kTSelectAtoms token!
                if( tokenList->GetDescriptor(kLogicalClass) == kTAll)
                {
                    tokenList->GetToken(); //Remove the kTAll token!
                    Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
                    tokenList->GetToken(); //Remove the kTYes/No token!
                    ((CxListCtrl *)ptr_to_cxObject)->SelectAll(select);
                }
                else if( tokenList->GetDescriptor(kLogicalClass) == kTInvert)
                {
                    tokenList->GetToken(); //Remove the kTInvert token!
                    ((CxListCtrl *)ptr_to_cxObject)->InvertSelection();
                }
                else
                {
                    CcString* rowOfStrings = new CcString[m_cols];
                    for (int k = 0; k < m_cols; k++)
                        rowOfStrings[k] = tokenList->GetToken();

                    Boolean select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
                    tokenList->GetToken();
                    ((CxListCtrl*)ptr_to_cxObject)->SelectPattern(rowOfStrings,select);
                    delete [] rowOfStrings;
                }
                break;
            }
            default:
            {
                hasTokenForMe = false;
                break; // We leave the token in the list and exit the loop
            }
        }
    }

    return ( retVal );
}

void    CrListCtrl::SetGeometry( const CcRect * rect )
{

    ((CxListCtrl*)ptr_to_cxObject)->SetGeometry( rect->mTop,
                                            rect->mLeft,
                                            rect->mBottom,
                                            rect->mRight );
}

CcRect  CrListCtrl::GetGeometry()
{

    CcRect retVal(
            ((CxListCtrl*)ptr_to_cxObject)->GetTop(),
            ((CxListCtrl*)ptr_to_cxObject)->GetLeft(),
            ((CxListCtrl*)ptr_to_cxObject)->GetTop()+((CxListCtrl*)ptr_to_cxObject)->GetHeight(),
            ((CxListCtrl*)ptr_to_cxObject)->GetLeft()+((CxListCtrl*)ptr_to_cxObject)->GetWidth()   );
    return retVal;
}

void    CrListCtrl::CalcLayout()
{
    int w = (int)(mWidthFactor  * (float)((CxListCtrl*)ptr_to_cxObject)->GetIdealWidth() );
    int h = (int)(mHeightFactor * (float)((CxListCtrl*)ptr_to_cxObject)->GetIdealHeight());
    ((CxListCtrl*)ptr_to_cxObject)->SetGeometry(-1,-1,h,w);
}

void    CrListCtrl::SetText( CcString item )
{
    LOGWARN( "CrListCtrl:SetText Don't add text to a ListCtrl.");
}

void    CrListCtrl::GetValue()
{
    int value = ( (CxListCtrl *)ptr_to_cxObject)->GetValue();
    SendCommand( CcString( value ) );
}

void CrListCtrl::GetValue(CcTokenList * tokenList)
{

    int desc = tokenList->GetDescriptor(kQueryClass);

    switch (desc)
    {
        case kTQListitem:
        {
            tokenList->GetToken();
            int i = atoi ((tokenList->GetToken()).ToCString()) - 1;
            int j = atoi ((tokenList->GetToken()).ToCString()) - 1;
            CcString theItem = ((CxListCtrl*)ptr_to_cxObject)->GetCell(i,j);
            SendCommand( theItem , true );
            break;
        }
        case kTQListrow:
        {
            tokenList->GetToken();
            CcString theString = tokenList->GetToken();
            int itemNo = atoi( theString.ToCString() );
            CcString result = ((CxListCtrl*)ptr_to_cxObject)->GetListItem(itemNo);
            (CcController::theController)->SendCommand(result, true);
            break;
        }
        case kTQSelected:
        {
            tokenList->GetToken();
            int nv = ( (CxListCtrl *)ptr_to_cxObject)->GetNumberSelected();
            int * values = new int [nv];
            ( (CxListCtrl *)ptr_to_cxObject)->GetSelectedIndices(values);
            for ( int i = 0; i < nv; i++ )
            {
                SendCommand( CcString( values[i] ) , true );
            }
            SendCommand( "END" , true );
            break;
        }
        case kTQNselected:
        {
            tokenList->GetToken();
            int value = ( (CxListCtrl *)ptr_to_cxObject)->GetNumberSelected();
            SendCommand( CcString( value ) , true );
            break;
        }
        default:
        {
            SendCommand( "ERROR",true );
            CcString error = tokenList->GetToken();
            LOGWARN( "CrEditCtrl:GetValue Error unrecognised token." + error);
            break;
        }
    }
}




void CrListCtrl::CrFocus()
{
    ((CxListCtrl*)ptr_to_cxObject)->Focus();
}

int CrListCtrl::GetIdealWidth()
{
    return ((CxListCtrl*)ptr_to_cxObject)->GetIdealWidth();
}

int CrListCtrl::GetIdealHeight()
{
    return ((CxListCtrl*)ptr_to_cxObject)->GetIdealHeight();
}

void CrListCtrl::SendValue(CcString message)
{
    if(mCallbackState)
    {
            SendCommand(mName + " " + message);
    }
}

#endif
