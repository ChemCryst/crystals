
#include "crystalsinterface.h"
#include "crconstants.h"
#include "ccchartcolour.h"
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

bool CcChartColour::ParseInput(deque<string> & tokenList)
{
//Just read three integers.
    r = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    g = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    b = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    return true;
}

void CcChartColour::Draw(CrChart* chartToDrawOn)
{
    chartToDrawOn->SetColour(r,g,b);
}
