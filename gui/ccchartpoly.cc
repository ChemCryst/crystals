
#include "crystalsinterface.h"
#include	"crconstants.h"
#include "ccchartpoly.h"
#include "cctokenlist.h"
#include "crchart.h"
#include "cccontroller.h"
#include "ccquickdata.h"

CcChartPoly::CcChartPoly(Boolean filled)
{
	nVerts = 0;
	verts = nil;
	fill = filled;
}

CcChartPoly::CcChartPoly(Boolean filled, int iv, int* points )
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

Boolean CcChartPoly::ParseInput(CcTokenList* tokenList)
{
	CcString theString;
//read the number of vertices.
	theString = tokenList->GetToken();
	nVerts = atoi( theString.ToCString() );

	verts = new int[nVerts*2];
	for ( int i = 0; i<nVerts*2; i++)
	{
		theString = tokenList->GetToken();
		verts[i] = atoi( theString.ToCString() );
	}
	return true;
}


void CcChartPoly::Draw(CrChart* chartToDrawOn)
{
	chartToDrawOn->DrawPoly(nVerts,verts,fill);
}


