////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListCtrl

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListCtrl.cc
//   Authors:   Richard Cooper
//   Created:   10.11.1998 16:36
//   $Log: not supported by cvs2svn $
//   Revision 1.15  2005/01/23 10:20:24  rich
//   Reinstate CVS log history for C++ files and header files. Recent changes
//   are lost from the log, but not from the files!
//
//   Revision 1.1.1.1  2004/12/13 11:16:17  rich
//   New CRYSTALS repository
//
//   Revision 1.14  2004/06/29 15:15:30  rich
//   Remove references to unused kTNoMoreToken. Protect against reading
//   an empty list of tokens.
//
//   Revision 1.13  2004/06/24 09:12:01  rich
//   Replaced home-made strings and lists with Standard
//   Template Library versions.
//
//   Revision 1.12  2004/05/21 14:00:18  rich
//   Implement LISTCTRL on Linux. Some extra functionality still missing,
//   such as clicking column headers to sort.
//
//   Revision 1.11  2003/08/22 21:40:20  rich
//   Change misleading error message.
//
//   Revision 1.10  2003/08/01 16:18:16  rich
//   Add script access to a command to sort list controls by any
//   column in ascending or descending order.
//
//   Revision 1.9  2003/05/07 12:18:57  rich
//
//   RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//   using only free compilers and libraries. Hurrah, but it isn't very stable
//   yet (CRYSTALS, not the compilers...)
//
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
#include    <string>
#include    <sstream>

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
#ifdef CRY_USEMFC
        ((CxListCtrl*)ptr_to_cxObject)->DestroyWindow();
        delete (CxListCtrl*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }
}

CRSETGEOMETRY(CrListCtrl,CxListCtrl)
CRGETGEOMETRY(CrListCtrl,CxListCtrl)
CRCALCLAYOUT(CrListCtrl,CxListCtrl)

CcParse CrListCtrl::ParseInput( deque<string> &  tokenList )
{
    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;
    string theToken;

    if( ! mSelfInitialised ) //Once Only.
    {
        LOGSTAT("*** ListCtrl *** Initing...");

        mName = string(tokenList.front());
        tokenList.pop_front();
        mSelfInitialised = true;

        LOGSTAT( "*** Created ListCtrl     " + mName );

        while ( hasTokenForMe && ! tokenList.empty() )
        {
            switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
            {
                case kTVisibleLines:
                {
                    tokenList.pop_front(); // Remove the keyword
                    ( (CxListCtrl *)ptr_to_cxObject)->SetVisibleLines( atoi( tokenList.front().c_str() ) );
                    LOGSTAT("Setting ListCtrl visible lines to " + tokenList.front());
                    tokenList.pop_front();
                    break;
                }
                case kTNumberOfColumns:
                {
                    tokenList.pop_front(); // Remove the keyword
                    m_cols = atoi( tokenList.front().c_str() );
                    LOGSTAT("Setting ListCtrl columns to " + tokenList.front());
                    tokenList.pop_front();
                    for (int k = 0; k < m_cols; k++)
                    {
                        ((CxListCtrl *)ptr_to_cxObject)->AddColumn( tokenList.front() );
                        tokenList.pop_front();
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
    while ( hasTokenForMe && ! tokenList.empty() ) //Every time
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
                    LOGSTAT( "Enabling ListCtrl callback" );
                else
                    LOGSTAT( "Disabling ListCtrl callback" );
                break;
            }
            case kTAddToList:
            {
                tokenList.pop_front(); // Remove that token!
                bool stop = false;
                while ( ! stop )
                {
                    string* rowOfStrings = new string[m_cols];

                    for (int k = 0; k < m_cols; k++)
                    {
                        if ( strcmp( kSNull, tokenList.front().c_str() ) == 0 )
                        {
                            stop = true;
                            k = m_cols;
                        }
                        else
                        {
                            rowOfStrings[k] = tokenList.front();
                        }
                        tokenList.pop_front();
                    }
                    if( ! stop ) ((CxListCtrl *)ptr_to_cxObject)->AddRow( rowOfStrings );
                    delete [] rowOfStrings; //Oops, forgot this first time!
                }
                break;
            }
            case kTSetSelection:
            {
                  tokenList.pop_front(); //Remove SetSelection token!
                  ((CxListCtrl*)ptr_to_cxObject)->CxSetSelection(atoi ( tokenList.front().c_str() ));
                  tokenList.pop_front(); //Remove number token!
                  break;
            }
            case kTEmpty:
            {
                  tokenList.pop_front(); //Remove Empty token!
                  ((CxListCtrl*)ptr_to_cxObject)->CxClear();
                  break;
            }
            case kTSortColumn:
            {
                  bool bSort = true;
                  tokenList.pop_front(); //Remove that token!
                  int column = atoi ( tokenList.front().c_str() );
                  tokenList.pop_front();
                  if( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes)  //Check for 'YES'
                  {
                    tokenList.pop_front(); //If there, remove the kTYes token!
                    bSort = false;
                  }
                  ((CxListCtrl*)ptr_to_cxObject)->SortCol(column,bSort);


                  break;
            }


            case kTSelectAtoms:
            {
                tokenList.pop_front(); //Remove the kTSelectAtoms token!
                if( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTAll)
                {
                    tokenList.pop_front(); //Remove the kTAll token!
                    bool select = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes);
                    tokenList.pop_front(); //Remove the kTYes/No token!
                    ((CxListCtrl *)ptr_to_cxObject)->SelectAll(select);
                }
                else if( !tokenList.empty() && CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTInvert)
                {
                    tokenList.pop_front(); //Remove the kTInvert token!
                    ((CxListCtrl *)ptr_to_cxObject)->InvertSelection();
                }
                else
                {
                    string* rowOfStrings = new string[m_cols];
                    for (int k = 0; k < m_cols; k++) {
                        rowOfStrings[k] = string( tokenList.front() ); 
                        tokenList.pop_front();
                    }

                    bool select = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes);
                    tokenList.pop_front();
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


void    CrListCtrl::SetText( const string &item )
{
    LOGWARN( "CrListCtrl:SetText Don't add text to a ListCtrl.");
}

void    CrListCtrl::GetValue()
{
    ostringstream strm;
    strm << ( (CxListCtrl *)ptr_to_cxObject)->GetValue();
    SendCommand( strm.str() );
}

void CrListCtrl::GetValue(deque<string> &  tokenList)
{

    int desc = CcController::GetDescriptor( tokenList.front(), kQueryClass );

    switch (desc)
    {
        case kTQListitem:
        {
            tokenList.pop_front();
            int i = atoi (tokenList.front().c_str()) - 1;
            tokenList.pop_front();
            int j = atoi (tokenList.front().c_str()) - 1;
            tokenList.pop_front();
            SendCommand( ((CxListCtrl*)ptr_to_cxObject)->GetCell(i,j) , true );
            break;
        }
        case kTQListrow:
        {
            tokenList.pop_front();
            (CcController::theController)->SendCommand(((CxListCtrl*)ptr_to_cxObject)->GetListItem(atoi( tokenList.front().c_str() )), true);
            tokenList.pop_front();
            break;
        }
        case kTQSelected:
        {
            tokenList.pop_front();
            int nv = ( (CxListCtrl *)ptr_to_cxObject)->GetNumberSelected();
            int * values = new int [nv];
            ( (CxListCtrl *)ptr_to_cxObject)->GetSelectedIndices(values);
            ostringstream strm;
            for ( int i = 0; i < nv; i++ )
            {
                strm.str("");
                strm << values[i];
                SendCommand( strm.str() , true );
            }
            SendCommand( "END" , true );
            break;
        }
        case kTQNselected:
        {
            tokenList.pop_front();
            ostringstream strm;
            strm << ( (CxListCtrl *)ptr_to_cxObject)->GetNumberSelected();
            SendCommand( strm.str() , true );
            break;
        }
        default:
        {
            SendCommand( "ERROR",true );
            LOGWARN( "CrListCtrl:GetValue Error unrecognised token." + tokenList.front());
            tokenList.pop_front();
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

void CrListCtrl::SendValue(string message)
{
    if(mCallbackState)
    {
            SendCommand(mName + " " + message);
    }
}
