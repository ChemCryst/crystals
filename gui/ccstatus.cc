////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcStatus

////////////////////////////////////////////////////////////////////////

//   Filename:  CcStatus.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   $Log: not supported by cvs2svn $
//   Revision 1.6  2001/06/17 15:18:26  richard
//   Notice when scripts exit (status bit 5 changes) and call ScriptsExited to
//   close any modal windows that have been accidentally left open. Windows with
//   the STAYOPEN property (notably the MAIN window) are exempt.
//
//   Revision 1.5  2001/03/08 15:22:11  richard
//   New flag signalling that the model window is in a ZOOMED in state.
//   Call to UpdateToolbars, when status changes, updates toolbar buttons, normal
//   buttons and windows with the DISABLEIF, ENABLEIF flags.
//

#include    "crystalsinterface.h"
#include "ccstring.h"
#include "cccontroller.h"
#include        "crconstants.h"
#include    "ccstatus.h"
#include    "cctokenlist.h"

CcStatus::CcStatus()
{
    statusFlags = 0;
}

CcStatus::~CcStatus()
{
}

void CcStatus::SetNumSelectedAtoms(int nSelected)
{
    //nSelected;
    UnSetBit(16,&statusFlags);
    UnSetBit(17,&statusFlags);
    UnSetBit(18,&statusFlags);
    UnSetBit(19,&statusFlags);
    UnSetBit(20,&statusFlags);
    if (nSelected == 0)
        SetBit(16,&statusFlags);
    else if(nSelected == 1)
        SetBit(17,&statusFlags);
    else if(nSelected == 2)
        SetBit(18,&statusFlags);
    else if(nSelected == 3)
        SetBit(19,&statusFlags);

    if(nSelected >= 3)
        SetBit(20,&statusFlags);

    UpdateToolBars();
}

void CcStatus::SetZoomedFlag(bool zoomed)
{
  if (zoomed)  SetBit(21,&statusFlags);
  else       UnSetBit(21,&statusFlags);

  UpdateToolBars();
}


Boolean CcStatus::ShouldBeEnabled(int enableFlags, int disableFlags)
{
    if( disableFlags & statusFlags )           //If any bits match, then should be disabled.
            return false;
    if ( enableFlags & ( ~statusFlags) ) //If any 0's in the statusFlag match any 1's in the enableFlags, then should be disabled.
            return false;

      return true;   //Otherwise, enable.
}


void CcStatus::SetBit(int i, int* theFlag)
{
    int addbit = 1;
    for (int j = 0; j < i; j++) addbit *= 2;

    *theFlag |= addbit;
}

void CcStatus::UnSetBit(int i, int * theFlag)
{
    int addbit = 1;
    for (int j = 0; j < i; j++) addbit *= 2;

    *theFlag &= (~addbit);
}



int CcStatus::CreateFlag(CcString text)
{
    int returnFlag = 0;

    int start = 0, i;
    Boolean inSpace = true;

    for (i=1; i < text.Len()+1; i++ )
    {
        if ( text[i-1] == ' ' || text[i-1] == '\t' || text[i-1] == '\r' || text[i-1] == '\n' )
        {
            if ( ! inSpace )                  // end of item
            {
                // Set the appropriate flag bit
                int bit = GetBitByToken(text.Sub(start,i-1));
                if(bit >= 0)
                   SetBit(bit,&returnFlag);
                // init values
                start = 0;
                inSpace = true;
            }
        }
        else if ( inSpace )                   // start of item
        {
            start = i;
            inSpace = false;
        }
    }

    // Check for last item
    if ( ! inSpace && start != 0 )
    {
        // add item to token list
        int bit = GetBitByToken(text.Sub(start,i-1));
        if(bit >= 0)
            SetBit(bit,&returnFlag);
    }

    return returnFlag;
}

int CcStatus::GetBitByToken(CcString token)
{
//   newway           if(token==CcString(bS0))  return 0;
//   oldway           if(token==CcString(bS1))  {SetBit(1,flag);return;}
#define CHECKTOKEN(a) if(token==CcString(bS##a))return a;
    CHECKTOKEN(0)
    CHECKTOKEN(1)
    CHECKTOKEN(2)
    CHECKTOKEN(3)
    CHECKTOKEN(4)
    CHECKTOKEN(5)
    CHECKTOKEN(6)
    CHECKTOKEN(7)
    CHECKTOKEN(8)
    CHECKTOKEN(9)
    CHECKTOKEN(10)
    CHECKTOKEN(11)
    CHECKTOKEN(12)
    CHECKTOKEN(13)
    CHECKTOKEN(14)
    CHECKTOKEN(15)
    CHECKTOKEN(16)
    CHECKTOKEN(17)
    CHECKTOKEN(18)
    CHECKTOKEN(19)
    CHECKTOKEN(20)
    CHECKTOKEN(21)
    CHECKTOKEN(22)
    CHECKTOKEN(23)
    CHECKTOKEN(24)
    CHECKTOKEN(25)
    CHECKTOKEN(26)
    CHECKTOKEN(27)
    CHECKTOKEN(28)
    CHECKTOKEN(29)
    CHECKTOKEN(30)
    CHECKTOKEN(31)
    return -1; //Tokenn not matched.
}


void CcStatus::ParseInput(CcTokenList * tokenList)
{
    Boolean moreTokens = true;
    while (moreTokens)
    {
        switch(tokenList->GetDescriptor(kStatusClass))
        {
            case kTSetStatus:
            {
                tokenList->GetToken();
                int setFlags = CreateFlag(tokenList->GetToken());
                statusFlags |= setFlags;
                break;
            }
            case kTUnSetStatus:
            {
                tokenList->GetToken();
                int unSetFlags = CreateFlag(tokenList->GetToken());
                if (( unSetFlags & 32 ) && ( statusFlags & 32 )) ScriptsExited();
                statusFlags &= (~unSetFlags);
                break;
            }
            default:
            {
                UpdateToolBars();
                moreTokens = false;
                break;
            }

        }
    }

}

void CcStatus::UpdateToolBars()
{
  // Unlike menus, the toolbars don't recieve events telling them
  // to update during idle time.
  // So we'll do it from here.

  (CcController::theController)->UpdateToolBars();


}

void CcStatus::ScriptsExited()
{
  //Use this fact to close any modal windows that don't
  //have the STAYOPEN property. (This means that the script
  //has terminated incorrectly without closing the window).

  (CcController::theController)->ScriptsExited();

}
