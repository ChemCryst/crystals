////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcStatus

////////////////////////////////////////////////////////////////////////

//   Filename:  CcStatus.cc
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   Modified:  11.3.1998 11:36 Uhr

#include	"crconstants.h"
#include	"crystalsinterface.h"
#include	"ccstatus.h"
#include	"cctokenlist.h"

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
}

Boolean CcStatus::ShouldBeEnabled(int enableFlags, int disableFlags)
{
	if( disableFlags & statusFlags )           //If any bits match, then should be disabled.
		return FALSE;
	if ( enableFlags & ( ~statusFlags) ) //If any 0's in the statusFlag match any 1's in the enableFlags, then should be disabled.
		return FALSE;

	return TRUE;   //Otherwise, enable.
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
		else if ( inSpace )  	         	  // start of item
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
//	 newway           if(token==CcString(bS0))  return 0;
//	 oldway           if(token==CcString(bS1))  {SetBit(1,flag);return;}
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
				statusFlags &= (~unSetFlags);
				break;
			}
			default:
			{
				moreTokens = false;
				break;
			}

		}
	}

}
