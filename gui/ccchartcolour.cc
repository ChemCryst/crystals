
#include "crystalsinterface.h"
#include "crconstants.h"
#include "ccchartcolour.h"
#include "cctokenlist.h"
#include "crchart.h"

CcChartColour::CcChartColour()
{
    r=0;
    g=0;
    b=0;
}

CcChartColour::CcChartColour(int ir, int ig, int ib)
{
      r=ir;
      g=ig;
      b=ib;
}

CcChartColour::~CcChartColour()
{
}

bool CcChartColour::ParseInput(CcTokenList* tokenList)
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
