
#include "crystalsinterface.h"
#include	"crconstants.h"
#include "ccmodelbond.h"
#include "cctokenlist.h"
#include "crmodel.h"

CcModelBond::CcModelBond()
{
	ox1 = oy1 = oz1 = x1 = y1 = z1 = 0;
	ox2 = oy2 = oz2 = x2 = y2 = z2 = 0;
	r = g = b = 0;
	rad = 0;
}

CcModelBond::~CcModelBond()
{
}

CcCoord CcModelBond::ParseInput(CcTokenList* tokenList)
{
	CcString theString;
//Just read four integers.
	theString = tokenList->GetToken();
	x1 = ox1 = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	y1 = oy1 = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	z1 = oz1 = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	x2 = ox2 = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	y2 = oy2 = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	z2 = oz2 = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	r = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	g = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	b = atoi( theString.ToCString() );
	theString = tokenList->GetToken();
	rad = atoi( theString.ToCString() );
	CcCoord retVal(0,0,0);
	return retVal;
}

void CcModelBond::Draw(CrModel* ModelToDrawOn)
{
	ModelToDrawOn->DrawBond(x1,y1,z1,x2,y2,z2,r,g,b,rad);
}


void CcModelBond::Centre(int nx, int ny, int nz)
{
	x1 = 5000 + ox1 - nx; y1 = 5000 + oy1 - ny; z1 = 5000 + oz1 - nz;
	x2 = 5000 + ox2 - nx; y2 = 5000 + oy2 - ny; z2 = 5000 + oz2 - nz;
}

