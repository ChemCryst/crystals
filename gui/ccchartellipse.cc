
#include "crystalsinterface.h"
#include    "crconstants.h"
#include "ccchartellipse.h"
#include "crchart.h"

CcChartEllipse::CcChartEllipse(bool filled)
{
    x=0;
    y=0;
    w=0;
    h=0;
    fill = filled;
}

CcChartEllipse::CcChartEllipse(bool filled, int ix, int iy, int iw, int ih )
{
      x=ix;
      y=iy;
      w=iw;
      h=ih;
    fill = filled;
}

CcChartEllipse::~CcChartEllipse()
{
}

bool CcChartEllipse::ParseInput(deque<string> &  tokenList)
{
//Just read four integers.
    x = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    y = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    w = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    h = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    return true;
}

void CcChartEllipse::Draw(CrChart* chartToDrawOn)
{
    chartToDrawOn->DrawEllipse(x,y,w,h,fill);
}
