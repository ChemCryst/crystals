////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CrListBox

////////////////////////////////////////////////////////////////////////

//   Filename:  CrListBox.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   22.2.1998 14:43 Uhr

//  $Log: not supported by cvs2svn $
//  Revision 1.1.1.1  2004/12/13 11:16:17  rich
//  New CRYSTALS repository
//
//  Revision 1.16  2004/06/28 13:26:57  rich
//  More Linux fixes, stl updates.
//
//  Revision 1.15  2004/06/24 09:12:01  rich
//  Replaced home-made strings and lists with Standard
//  Template Library versions.
//
//  Revision 1.14  2003/05/07 12:18:57  rich
//
//  RIC: Make a new platform target "WXS" for building CRYSTALS under Windows
//  using only free compilers and libraries. Hurrah, but it isn't very stable
//  yet (CRYSTALS, not the compilers...)
//
//  Revision 1.13  2002/03/05 12:12:58  ckp2
//  Enhancements to listbox for my List 28 project.
//
//  Revision 1.12  2001/09/11 08:31:30  ckp2
//  Delete some old comment.
//
//  Revision 1.11  2001/06/17 15:14:13  richard
//  Addition of CxDestroy function call in destructor to do away with their Cx counterpart properly.
//
//  Revision 1.10  2001/03/28 09:17:07  richard
//  Code to allow you to disable the listbox.
//
//  Revision 1.9  2001/03/08 16:44:05  richard
//  General changes - replaced common functions in all GUI classes by macros.
//  Generally tidied up, added logs to top of all source files.
//
//  Revision 1.8  2001/01/16 15:34:59  richard
//  wxWindows support.
//  Revamped some of CxTextout, Cr/Cx Menu and MenuBar. These changes must be
//  checked out in conjunction with changes to \bin\
//
//  Revision 1.7  2000/12/13 17:57:12  richard
//  Extra safety check for empty string tokens, to prevent infinite loop.
//  CxListBox::SetSelection changed to CxListBox::CxSetSelection to avoid name clash.
//
//  Revision 1.6  1999/06/01 12:48:39  dosuser
//  RIC: Failed to check in with the last bunch of files.
//
//  Revision 1.5  1999/04/28 13:59:48  dosuser
//  RIC: Fix: Added a break to a case statement.
//
//  Revision 1.4  1999/04/26 12:21:03  dosuser
//  RIC: Added a kTSetSelection section in ParseInput to allow the current
//       selection to be changed from SCRIPTS
//

#include    "crystalsinterface.h"
#include    "crconstants.h"
#include    "crlistbox.h"
#include    "crwindow.h"
#include    "crgrid.h"
#include    "cxlistbox.h"
#include    "ccrect.h"
#include    "cccontroller.h"    // for sending commands
#include    <string>
#include    <sstream>


CrListBox::CrListBox( CrGUIElement * mParentPtr )
    :CrGUIElement( mParentPtr )
{
    ptr_to_cxObject = CxListBox::CreateCxListBox( this, (CxGrid *)(mParentPtr->GetWidget()) );
    mTabStop = true;
}

    CrListBox::~CrListBox()
{
    if ( ptr_to_cxObject != nil )
    {
        ((CxListBox*)ptr_to_cxObject)->CxDestroyWindow();
#ifdef CRY_USEMFC
        delete (CxListBox*)ptr_to_cxObject;
#endif
        ptr_to_cxObject = nil;
    }

}


CRSETGEOMETRY(CrListBox,CxListBox)
CRGETGEOMETRY(CrListBox,CxListBox)
CRCALCLAYOUT(CrListBox,CxListBox)


CcParse CrListBox::ParseInput(deque<string> &  tokenList )
{

    CcParse retVal(true, mXCanResize, mYCanResize);
    bool hasTokenForMe = true;
    string theToken;
//t
    // Initialization for the first time
    if( ! mSelfInitialised )
    {
        LOGSTAT("*** ListBox *** Initing...");

        mName = string(tokenList.front());
        tokenList.pop_front();
        mSelfInitialised = true;

        hasTokenForMe = true;
        while ( hasTokenForMe && ! tokenList.empty() )
        {
            switch ( CcController::GetDescriptor( tokenList.front(), kAttributeClass ) )
            {
                case kTVisibleLines:
                {
                    tokenList.pop_front(); // Remove the keyword
                    ( (CxListBox *)ptr_to_cxObject)->SetVisibleLines( atoi( tokenList.front().c_str() )) ;
                    LOGSTAT("Setting ListBox visible lines to " + tokenList.front());
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

        LOGSTAT( "*** Created ListBox     " + mName );
    }
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
                              LOGSTAT( "Enabling ListBox callback" );
                else
                              LOGSTAT( "Disabling ListBox callback" );
                break;
            }
            case kTDisabled:
            {
                tokenList.pop_front(); // Remove that token!
                bool disabled = (CcController::GetDescriptor( tokenList.front(), kLogicalClass ) == kTYes) ? true : false;
                LOGSTAT( "ListBox disabled = " + tokenList.front());
                tokenList.pop_front(); // Remove YES or NO.
                ((CxListBox*)ptr_to_cxObject)->Disable( disabled );
                break;
            }
            case kTAddToList:
            {
                tokenList.pop_front(); // Remove AddToList token!
                bool stop = false;
                while ( ! stop )
                {
                    if (  ( tokenList.empty() )
						 || ( strcmp( kSNull, tokenList.front().c_str() ) == 0 )
                         || ( tokenList.front().length() == 0 ) )
                                                                      stop = true;
                    else
                    {
                        SetText( tokenList.front() );
                        LOGSTAT("Adding ListBox text '" + tokenList.front() + "'");
                    }
                    if ( ! tokenList.empty() ) tokenList.pop_front(); // Remove token
                }
                break;
            }
            case kTSetSelection:
            {
                  tokenList.pop_front(); //Remove that token!
                  ((CxListBox*)ptr_to_cxObject)->CxSetSelection(atoi ( tokenList.front().c_str() ));
                  tokenList.pop_front();
                  break;
            }
            case kTRemove:
            {
                  tokenList.pop_front(); //Remove that token!
                  ((CxListBox*)ptr_to_cxObject)->CxRemoveItem(atoi ( tokenList.front().c_str() ));
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


    return ( retVal );

}


void    CrListBox::SetText( const string &item )
{
    ( (CxListBox *)ptr_to_cxObject)->AddItem( item );
    LOGSTAT( "Adding Item '" + item + "'");
}

void    CrListBox::GetValue()
{
    ostringstream strm;
    strm << ( (CxListBox *)ptr_to_cxObject)->GetBoxValue();
    SendCommand( strm.str() );
}


void CrListBox::GetValue(deque<string> &  tokenList)
{

    int desc = CcController::GetDescriptor( tokenList.front(), kQueryClass );

    if( desc == kTQListtext )
    {
        tokenList.pop_front();
        SendCommand( ((CxListBox*)ptr_to_cxObject)->GetListBoxText(atoi (tokenList.front().c_str())), true );
        tokenList.pop_front();
    }
    else if (desc == kTQSelected )
    {
        tokenList.pop_front();
        ostringstream strm;
        strm << ( (CxListBox *)ptr_to_cxObject)->GetBoxValue();
        SendCommand( strm.str() , true );
    }
    else
    {
        SendCommand( "ERROR",true );
        LOGWARN( "CrEditBox:GetValue Error unrecognised token." + tokenList.front());
        tokenList.pop_front();
    }


}



void    CrListBox::Selected( int item )
{

    if (mCallbackState)
    {
        SendCommand(mName);
        ostringstream strm;
        strm << item;
        SendCommand(strm.str());
    }
}

void    CrListBox::Committed( int item )
{
    if (mCallbackState)
    {
        SendCommand(mName);
        ostringstream strm;
        strm << item;
        SendCommand(strm.str());
        ((CrWindow*)GetRootWidget())->Committed();
    }
}

void CrListBox::CrFocus()
{
    ((CxListBox*)ptr_to_cxObject)->Focus();
}
