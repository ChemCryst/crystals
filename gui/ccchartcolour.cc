
#include "crystalsinterface.h"
#include	"CrConstants.h"
#include "CcChartColour.h"
#include "CcTokenList.h"
#include "CrChart.h"

CcChartColour::CcChartColour()
{
	r=0;
	g=0;
	b=0;
}

CcChartColour::~CcChartColour()
{
}

Boolean CcChartColour::ParseInput(CcTokenList* tokenList)
{
	CcString theString;
//Just read three integers.
	theString = tokenList->GetToken();
	r = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	g = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	b = atoi( theString.ToCString() );
	return true;
}

void CcChartColour::Draw(CrChart* chartToDrawOn)
{
	chartToDrawOn->SetColour(r,g,b);
}

