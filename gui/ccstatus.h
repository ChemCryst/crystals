////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcStatus

////////////////////////////////////////////////////////////////////////

//   Filename:  CcStatus.h
//   Authors:   Richard Cooper and Ludwig Macko
//   Created:   26.2.1998 9:36 Uhr
//   Modified:  11.3.1998 11:36 Uhr

#ifndef		__CcStatus_H__
#define		__CcStatus_H__
//Insert your own code here.

//End of user code.         

//Updated by crystals thread.
#define bS0		"L1"
#define bS1		"L2"
#define bS2		"L3"
#define bS3		"L5"
#define bS4		"L6"
#define bS5		"IN"
#define bS6		"QS"
#define bS7
#define bS8
#define bS9
#define bS10
#define bS11
#define bS12
#define bS13
#define bS14
#define bS15
//Reserved for interface.
#define bS16	"SEL0"
#define bS17	"SEL1"
#define bS18	"SEL2"
#define bS19	"SEL3"
#define bS20	"SEL>=3"
#define bS21
#define bS22
#define bS23
#define bS24
#define bS25
#define bS26
#define bS27
#define bS28
#define bS29
#define bS30
#define bS31

class CcTokenList;

class	CcStatus
{
	public:
		void ParseInput(CcTokenList* tokenList);
		void UnSetBit(int i, int* theFlags);
		int CreateFlag(CcString theFlags);
		Boolean ShouldBeEnabled(int enableFlags, int disableFlags);
		// methods
			CcStatus();
			~CcStatus();
			void SetNumSelectedAtoms(int n);
		
	private:
		int GetBitByToken(CcString token);
		void SetBit(int i, int* theFlag);
		//attributes
		
		int statusFlags;

};
#endif
