
#include "crystalsinterface.h"
#include "crconstants.h"
#include "ccmodelatom.h"
#include "cctokenlist.h"
#include "ccmodeldoc.h"
#include "crmodel.h"

CcModelAtom::CcModelAtom(CcModelDoc* parentptr)
{
	x = y = z = 0;
	r = g = b = 0;
	id = 0;
	occ = 1;
	covrad = vdwrad = 1000;
	uflag = 0;
//      u1 = u2 = u3 = u4 = u5 = u6 = 0;
      x11 = x12 = x13 = x21 = x22 = x23 = x31 = x32 = x33 = 0;
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
//      u1 = u2 = u3 = u4 = u5 = u6 = 0;
      x11 = x12 = x13 = x21 = x22 = x23 = x31 = x32 = x33 = 0;
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
// UISO or X11
// X12, x13, x22, x23, x31, x32, x33
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
      theString = tokenList->GetToken();    //X11 or UISO * 1000
      x11 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X12 * 1000
      x12 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X13 * 1000
      x13 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X21 * 1000
      x21 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X22 * 1000
      x22 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X23 * 1000
      x23 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X31 * 1000
      x31 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X32 * 1000
      x32 = atoi ( theString.ToCString() );
      theString = tokenList->GetToken();    //X33 * 1000
      x33 = atoi ( theString.ToCString() );
      CcCoord retVal(x,y,z);
	return retVal;
}

void CcModelAtom::Draw(CrModel* ModelToDrawOn)
{
      ModelToDrawOn->DrawAtom(x,y,z,r,g,b,covrad,vdwrad,x11,x12,x13,x21,x22,x23,x31,x32,x33);
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

