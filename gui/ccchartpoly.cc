
#include "crystalsinterface.h"
#include	"CrConstants.h"
#include "CcChartPoly.h"
#include "CcTokenList.h"
#include "CrChart.h"
#include "CcController.h"
#include "CcQuickData.h"

CcChartPoly::CcChartPoly(Boolean filled)
{
	nVerts = 0;
	verts = nil;
	fill = filled;
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

Boolean CcChartPoly::FastInput(CcTokenList * tokenList)
{
	CcString theString;
//read the number of vertices.
	theString = tokenList->GetToken();
	nVerts = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	int nID = atoi( theString.ToCString() );

	verts = (CcController::theController)->mQuickData->RetrieveData(nID);

	return true;
}

void CcChartPoly::Draw(CrChart* chartToDrawOn)
{
	chartToDrawOn->DrawPoly(nVerts,verts,fill);
}


