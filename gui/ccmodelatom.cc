
#include "crystalsinterface.h"
#include "CrConstants.h"
#include "CcModelAtom.h"
#include "CcTokenList.h"
#include "CcModelDoc.h"
#include "CrModel.h"

CcModelAtom::CcModelAtom(CcModelDoc* parentptr)
{
	x = y = z = 0;
	r = g = b = 0;
	id = 0;
	occ = 1;
	covrad = vdwrad = 1000;
	uflag = 0;
	u1 = u2 = u3 = u4 = u5 = u6 = 0;
	label = "Err";
	m_selected = false;
	parent = parentptr;
}

CcModelAtom::CcModelAtom()
{
	x = y = z = 0;
	r = g = b = 0;
	id = 0;
	occ = 1;
	covrad = vdwrad = 1000;
	uflag = 0;
	u1 = u2 = u3 = u4 = u5 = u6 = 0;
	label = "Err";
	m_selected = false;
}

CcModelAtom::~CcModelAtom()
{
}

CcCoord CcModelAtom::ParseInput(CcTokenList* tokenList)
{
	CcString theString;
//Just read ID, LABEL,
// IX, IY, IZ,
// RED, GREEN, BLUE,
// OCC*1000,
// COVRAD, VDWRAD,
// FLAG,
// UISO or U11
// U12, U13, U22, U23, U33
	theString = tokenList->GetToken();    //ID
	id = atoi ( theString.ToCString() );
	label =     tokenList->GetToken();    //LABEL
	theString = tokenList->GetToken();    //IX
	ox = x = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //IY
	oy = y = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //IZ
	oz = z = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //RED
	r = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //GREEN
	g = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //BLUE
	b = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //OCC * 1000
	occ = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //COVRAD (scaled)
	covrad = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //VDWRAD (scaled)
	vdwrad = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //UISO/U11 FLAG
	uflag = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //U11 or UISO * 1000
	u1 = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //U12 * 1000
	u2 = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //U13 * 1000
	u3 = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //U22 * 1000
	u4 = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //U23 * 1000
	u5 = atoi ( theString.ToCString() );
	theString = tokenList->GetToken();    //U33 * 1000
	u6 = atoi ( theString.ToCString() );
	CcCoord retVal(x,y,z);
	return retVal;
}

void CcModelAtom::Draw(CrModel* ModelToDrawOn)
{
	ModelToDrawOn->DrawAtom(x,y,z,r,g,b,covrad,vdwrad);
}


void CcModelAtom::Centre(int nx, int ny, int nz)
{
	x = 5000 + ox - nx; 
	y = 5000 + oy - ny; 
	z = 5000 + oz - nz;
}

int CcModelAtom::X()
{
	return x;
}
int CcModelAtom::Y()
{
	return y;
}
int CcModelAtom::Z()
{
	return z;
}
int CcModelAtom::R()
{
	return covrad;
}
CcString CcModelAtom::Label()
{
	return label;
}

Boolean CcModelAtom::Select()
{
	m_selected = !m_selected;
	parent->Select(m_selected);
	return m_selected;
}

void CcModelAtom::Select(Boolean select)
{
	if(m_selected != select)  //Counter in parent must only find out about change.
		parent->Select(select); 
	m_selected = select;
}

void CcModelAtom::Highlight(CrModel * aView)
{
	if(m_selected)
		aView->HighlightAtom(this);
}

int CcModelAtom::Vdw()
{
	return vdwrad;
}

Boolean CcModelAtom::IsSelected()
{
	return m_selected;
}

