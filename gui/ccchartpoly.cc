
#include "crystalsinterface.h"
#include    "crconstants.h"
#include "ccchartpoly.h"
#include "crchart.h"
#include "cccontroller.h"

CcChartPoly::CcChartPoly(bool filled)
{
    nVerts = 0;
    verts = nil;
    fill = filled;
}

CcChartPoly::CcChartPoly(bool filled, int iv, int* points )
{
      nVerts = iv;
    fill = filled;
    verts = new int[nVerts*2];
    for ( int i = 0; i<nVerts*2; i++)
    {
            verts[i] = points[i] ;
    }
}

CcChartPoly::~CcChartPoly()
{
    if(verts!=nil)
        delete [] verts;
}

bool CcChartPoly::ParseInput(deque<string> &  tokenList)
{
//read the number of vertices.
    nVerts = atoi( tokenList.front().c_str() );
    tokenList.pop_front();

    verts = new int[nVerts*2];
    for ( int i = 0; i<nVerts*2; i++)
    {
        verts[i] = atoi( tokenList.front().c_str() );
        tokenList.pop_front();
    }
    return true;
}


void CcChartPoly::Draw(CrChart* chartToDrawOn)
{
    chartToDrawOn->DrawPoly(nVerts,verts,fill);
}
