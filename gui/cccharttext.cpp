
#include "crystalsinterface.h"
#include    "crconstants.h"
#include "cccharttext.h"
#include "crchart.h"

#ifdef CRY_USEWX
// These macros are being defined somewhere. They shouldn't be.

#ifdef GetCharWidth
 #undef GetCharWidth
#endif
#ifdef DrawText
 #undef DrawText
#endif

#endif

CcChartText::CcChartText()
{
    x=0;
    y=0;
    xm = 0;
    ym = 0;
    text = " ";
}

CcChartText::CcChartText(int ix, int iy, string itext )
{
      x=ix;
      y=iy;
    xm = 0;
    ym = 0;
      text = itext;
}

CcChartText::~CcChartText()
{
}

bool CcChartText::ParseInput(deque<string> &  tokenList)
{
    x = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    y = atoi( tokenList.front().c_str() );
    tokenList.pop_front();
    text = string(tokenList.front());
    tokenList.pop_front();
    return true;
}

void CcChartText::Draw(CrChart* chartToDrawOn)
{
    if(xm == 0)
        chartToDrawOn->DrawText(x,y,text);
        else
        chartToDrawOn->FitText(x,y,xm,ym,text);
}


void CcChartText::Init(int xp, int yp, string theText)
{
    x    = xp;
    y    = yp;
    text = theText;
}

void CcChartText::Init(int x1, int y1, int x2, int y2, string theText, bool centred)
{
// Must fit the text inside the box.
    x = x1;
    y = y1;
    xm = x2;
    ym = y2;
    text = theText;
        if ( !centred ) xm = -xm;
}
