
#include "crystalsinterface.h"
#include	"crconstants.h"
#include "ccchartellipse.h"
#include "cctokenlist.h"
#include "crchart.h"

CcChartEllipse::CcChartEllipse(Boolean filled)
{
	x=0;
	y=0;
	w=0;
	h=0;
	fill = filled;
}

CcChartEllipse::~CcChartEllipse()
{
}

Boolean CcChartEllipse::ParseInput(CcTokenList* tokenList)
{
	CcString theString;
//Just read four integers.
	theString = tokenList->GetToken();
	x = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	y = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	w = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	h = atoi( theString.ToCString() );
	return true;
}

void CcChartEllipse::Draw(CrChart* chartToDrawOn)
{
	chartToDrawOn->DrawEllipse(x,y,w,h,fill);
}

