
#include "crystalsinterface.h"
#include	"CrConstants.h"
#include "CcChartLine.h"
#include "CcTokenList.h"
#include "CrChart.h"

CcChartLine::CcChartLine()
{
	x1=0;
	x2=0;
	y1=0;
	y2=0;
}

CcChartLine::~CcChartLine()
{
}

Boolean CcChartLine::ParseInput(CcTokenList* tokenList)
{
	CcString theString;
//Just read four integers.
	theString = tokenList->GetToken();
	int xa = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	int ya = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	int xb = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	int yb = atoi( theString.ToCString() );
	Init(xa,ya, xb,yb);
	return true;
}




void CcChartLine::Draw(CrChart* chartToDrawOn)
{
	chartToDrawOn->DrawLine(x1,y1,x2,y2);
}


void CcChartLine::Init(int xa, int ya, int xb, int yb)
{
	x1 = xa;
	x2 = xb;
	y1 = ya;
	y2 = yb;
}
