
#include "crystalsinterface.h"
#include "ccstring.h"
#include "crconstants.h"
#include "ccmodelatom.h"
#include "cctokenlist.h"
#include "ccmodeldoc.h"
#include "crmodel.h"

CcModelAtom::CcModelAtom(CcModelDoc* parentptr)
{
  mp_parent = parentptr;
  Init();
}

void CcModelAtom::Init()
{
  x = y = z = 0;
  r = g = b = 0;
  id = 0;
  occ = 1;
  sparerad = covrad = vdwrad = 1000;
  x11 = x12 = x13 = x21 = x22 = x23 = x31 = x32 = x33 = 0;
  label = "Err";
  m_selected = false;
  m_disabled = false;
  m_IsADP = true;
  m_excluded = false;
  spare = false;
}

CcModelAtom::~CcModelAtom()
{
}

void CcModelAtom::ParseInput(CcTokenList* tokenList)
{
//        CcString theString;
//Just read ID, LABEL,
// IX, IY, IZ,
// RED, GREEN, BLUE,
// OCC*1000,
// COVRAD, VDWRAD, SPARERAD
// FLAG,
// UISO or X11
// X12, x13, x22, x23, x31, x32, x33
      id        = atoi ( tokenList->GetToken().ToCString() );
      label     =        tokenList->GetToken();    //LABEL
      x         = atoi ( tokenList->GetToken().ToCString() );
      y         = atoi ( tokenList->GetToken().ToCString() );
      z         = atoi ( tokenList->GetToken().ToCString() );
      r         = atoi ( tokenList->GetToken().ToCString() );
      g         = atoi ( tokenList->GetToken().ToCString() );
      b         = atoi ( tokenList->GetToken().ToCString() );
      occ       = atoi ( tokenList->GetToken().ToCString() );
      covrad    = atoi ( tokenList->GetToken().ToCString() );
      vdwrad    = atoi ( tokenList->GetToken().ToCString() );
      sparerad  = atoi ( tokenList->GetToken().ToCString() );
      m_IsADP   = (atoi( tokenList->GetToken().ToCString() ) == 0 );
      x11       = atoi ( tokenList->GetToken().ToCString() );
      x12       = atoi ( tokenList->GetToken().ToCString() );
      x13       = atoi ( tokenList->GetToken().ToCString() );
      x21       = atoi ( tokenList->GetToken().ToCString() );
      x22       = atoi ( tokenList->GetToken().ToCString() );
      x23       = atoi ( tokenList->GetToken().ToCString() );
      x31       = atoi ( tokenList->GetToken().ToCString() );
      x32       = atoi ( tokenList->GetToken().ToCString() );
      x33       = atoi ( tokenList->GetToken().ToCString() );
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

bool CcModelAtom::Select()
{
	m_selected = !m_selected;
        mp_parent->Select(m_selected);
	return m_selected;
}

void CcModelAtom::Select(bool select)
{
	if(m_selected != select)  //Counter in parent must only find out about change.
            mp_parent->Select(select); 
	m_selected = select;
}

void CcModelAtom::Disable(bool select)
{
        m_disabled = select;
}

bool CcModelAtom::IsSelected()
{
	return m_selected;
}

void CcModelAtom::Render(CrModel* view, bool detailed)
{
  glPushMatrix();
  glPushAttrib(GL_POLYGON_BIT);

  GLUquadricObj* sphere = gluNewQuadric();
  gluQuadricDrawStyle(sphere,GLU_FILL);
  glTranslated(x,y,z);
  float extra = 0.0;
  int detail = (detailed)? view->m_NormalRes  : view->m_QuickRes ;

  if ( m_excluded )
  {
    glPolygonMode(GL_FRONT, GL_POINT);
    glPolygonMode(GL_BACK, GL_POINT);
    GLfloat Surface[] = { 128.0f+(float)r/127.0f,128.0f+(float)g/127.0f,128.0f+(float)b/127.0f, 1.0f };
    GLfloat Diffuse[] = { 128.0f+(float)r/127.0f,128.0f+(float)g/127.0f,128.0f+(float)b/127.0f, 1.0f };
    glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
    extra = 20.0;
  }
  else if ( m_selected ) // highlighted
  {
    int red = r;    int gre = g;    int blu = b;
    if ( (  abs(r-g) < 20 ) && (abs (g-b) < 20) ) //black - grey - white
    {
        if ( r >= 128 ) red = r-128;
        else            red = r+128;
        if ( g >= 128 ) gre = g-128;
        else            gre = g+128;
    }
    GLfloat Surface[] = { (float)red/255.0f,(float)gre/255.0f,(float)blu/255.0f, 1.0f };
    GLfloat Diffuse[] = { 0.6f,0.6f,0.6f,1.0f };
    GLfloat Specula[] = { 0.9f,0.9f,0.9f,1.0f };
    glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
    detail = 4;
    extra = 10.0;
  }
  else if ( m_disabled )  // disabled atom
  {
    GLfloat Surface[] = { 0.0f,0.0f,0.0f,1.0f };
    GLfloat Diffuse[] = { (float)r/512.0f,(float)g/512.0f,(float)b/512.0f, 1.0f };
    GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
    glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
    extra = 20.0;
  }
  else  // normal
  {
    GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
    GLfloat Diffuse[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
    GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
    glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
  }




  if (view->RadiusType() == COVALENT)
  {
    gluSphere(sphere, ((float)covrad + extra ) * view->RadiusScale(),detail,detail);
  }
  else if(view->RadiusType() == VDW)
  {
    gluSphere(sphere, ((float)vdwrad + extra ) * view->RadiusScale(),detail,detail);
  }
  else if(view->RadiusType() == SPARE)
  {
    if ( label.Length() && ( label.Sub(1,1) == "Q" ) )
    {
      gluSphere(sphere, ((float)sparerad + extra ) * view->RadiusScale(),detail,detail);
    }
    else
    {
      gluSphere(sphere, ((float)covrad + extra ) * view->RadiusScale(),detail,detail);
    }
  }
  else if(view->RadiusType() == THERMAL)
  {
    if ( m_IsADP)
    {
      float * localmatrix = new float[16];
      localmatrix[0]=(float)x11;
      localmatrix[1]=(float)x12;
      localmatrix[2]=(float)x13;
      localmatrix[3]=0.0;
      localmatrix[4]=(float)x21;
      localmatrix[5]=(float)x22;
      localmatrix[6]=(float)x23;
      localmatrix[7]=0.0;
      localmatrix[8]=(float)x31;
      localmatrix[9]=(float)x32;
      localmatrix[10]=(float)x33;
      localmatrix[11]=0.0;
      localmatrix[12]=0.0;
      localmatrix[13]=0.0;
      localmatrix[14]=0.0;
      localmatrix[15]=1.0;
      glMultMatrixf(localmatrix);
      delete [] localmatrix;
      gluSphere(sphere, ( 1.0f + ((float)extra / 1000.0f) ), detail,detail);


      GLfloat Surface[] = { 0.0f, 0.0f, 0.0f, 1.0f };
      GLfloat Diffuse[] = { 0.0f, 0.0f, 0.0f, 1.0f }; 
      GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
      glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
      glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
      glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);

      GLUquadricObj* cylinder;
      cylinder = gluNewQuadric();
      gluQuadricDrawStyle(cylinder,GLU_FILL);
      gluCylinder(cylinder,1.02f + ((float)extra / 1000.0f),1.02f + ((float)extra / 1000.0f),0.1f, detail, detail);
      gluDeleteQuadric(cylinder);

      glRotatef(90.0f,0.0f,1.0f,0.0f);

      cylinder = gluNewQuadric();
      gluQuadricDrawStyle(cylinder,GLU_FILL);
      gluCylinder(cylinder,1.02f + ((float)extra / 1000.0f),1.02f + ((float)extra / 1000.0f),0.1f, detail, detail);
      gluDeleteQuadric(cylinder);

      glRotatef(90.0f,1.0f,0.0f,0.0f);

      cylinder = gluNewQuadric();
      gluQuadricDrawStyle(cylinder,GLU_FILL);
      gluCylinder(cylinder,1.02f + ((float)extra / 1000.0f),1.02f + ((float)extra / 1000.0f),0.1f, detail, detail);
      gluDeleteQuadric(cylinder);
    }
    else
    {
      gluSphere(sphere, ((float)x11 + extra ), detail, detail);
    }
  }

  gluDeleteQuadric(sphere);

  glPopAttrib();
  glPopMatrix();
}

