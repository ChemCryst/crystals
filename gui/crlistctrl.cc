#ifdef __CR_WIN__
////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListCtrl.cc
//   Authors:   Richard Cooper
//   Created:   10.11.1998 16:36
//   $Log: not supported by cvs2svn $
//   Revision 1.8  2003/03/27 16:10:45  rich
//   Allow list control selection to be set from scripts.
//
//   Revision 1.7  2001/06/17 15:14:13  richard
//   Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//   Revision 1.6  2001/03/08 16:44:05  richard
//   General changes - replaced common functions in all GUI classes by macros.
//   Generally tidied up, added logs to top of all source files.
//

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
#ifdef __CR_WIN__
        ((CxListCtrl*)ptr_to_cxObject)->DestroyWindow();
        delete (CxListCtrl*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrListCtrl,CxListCtrl)
CRGETGEOMETRY(CrListCtrl,CxListCtrl)
CRCALCLAYOUT(CrListCtrl,CxListCtrl)

CcParse CrListCtrl::ParseInput( CcTokenList * tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;
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
                bool inform = (tokenList->GetDescriptor(kLogicalClass) == kTYes) ? true : false;
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
                bool stop = false;
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
            case kTSetSelection:
            {
                  tokenList->GetToken(); //Remove that token!
                  int select = atoi ( tokenList->GetToken().ToCString() );
                  ((CxListCtrl*)ptr_to_cxObject)->CxSetSelection(select);
                  break;
            }
            case kTSelectAtoms:
            {
                tokenList->GetToken(); //Remove the kTSelectAtoms token!
                if( tokenList->GetDescriptor(kLogicalClass) == kTAll)
                {
                    tokenList->GetToken(); //Remove the kTAll token!
                    bool select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
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

                    bool select = (tokenList->GetDescriptor(kLogicalClass) == kTYes);
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
