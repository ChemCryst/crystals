
#include "crystalsinterface.h"
#include "ccstring.h"
#include "crconstants.h"
#include "ccmodelatom.h"
#include "cctokenlist.h"
#include "ccmodeldoc.h"
#include "crmodel.h"
#include "creditbox.h"
#include "cccontroller.h"

CcModelAtom::CcModelAtom(CcModelDoc* parentptr)
{
  mp_parent = parentptr;
  Init();
}

CcModelAtom::CcModelAtom(CcString llabel,int lx1,int ly1,int lz1, 
                          int lr, int lg, int lb, int locc,int lcov, int lvdw,
                          int lspare, int lflag,
                          int u1,int u2,int u3,int u4,int u5,
                          int u6,int u7,int u8,int u9, CcModelDoc* parentptr)
{
  mp_parent = parentptr;
  Init();
  x = lx1; y = ly1; z = lz1;
  r = lr; g = lg; b = lb;
  occ = locc;
  covrad = lcov; vdwrad = lvdw; sparerad = lspare;
  x11 = u1; x12 = u2; x13 = u3;
  x21 = u4; x22 = u5; x23 = u6;
  x31 = u7; x32 = u8; x33 = u9;
  m_label = llabel;
  m_IsADP = ( lflag == 0 );


}


void CcModelAtom::Init()
{
  m_type = CC_ATOM;
  x = y = z = 0;
  r = g = b = 0;
  id = 0;
  occ = 1;
  sparerad = covrad = vdwrad = 1000;
  x11 = x12 = x13 = x21 = x22 = x23 = x31 = x32 = x33 = 0;
  m_label = "Err";
  m_IsADP = true;
  spare = false;
  m_glID = 0;
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
      m_label     =        tokenList->GetToken();    //LABEL
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

void CcModelAtom::Render(CcModelStyle *style, bool feedback)
{

  glPushMatrix();

  GLUquadricObj* sphere = gluNewQuadric();
  gluQuadricDrawStyle(sphere,GLU_FILL);
  glTranslated(x,y,z);
  float extra = 0.0;
  int detail = (style->high_res)? style->normal_res  : style->quick_res ;

  if (feedback) glPassThrough((float)m_glID);

  if ( m_excluded )
  {
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
    glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
    detail = 4;
    extra = 10.0;
  }
  else if ( m_disabled )  // disabled atom
  {
    GLfloat Diffuse[] = { (float)r/512.0f,(float)g/512.0f,(float)b/512.0f, 1.0f };
    glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
    extra = 20.0;
  }
  else  // normal
  {
    GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
    GLfloat Diffuse[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
    glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
  }

  if (style->radius_type == COVALENT)
  {
    gluSphere(sphere, ((float)covrad + extra ) * style->radius_scale,detail,detail);
  }
  else if(style->radius_type == VDW)
  {
    gluSphere(sphere, ((float)vdwrad + extra ) * style->radius_scale,detail,detail);
  }
  else if(style->radius_type == SPARE)
  {
    if ( m_label.Length() && ( m_label.Sub(1,1) == "Q" ) )
    {
      gluSphere(sphere, ((float)sparerad + extra ) * style->radius_scale,detail,detail);
    }
    else
    {
      gluSphere(sphere, ((float)covrad + extra ) * style->radius_scale,detail,detail);
    }
  }
  else if(style->radius_type == THERMAL)
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

  if (feedback)  glPassThrough(0.0);

  glPopMatrix();


}

void CcModelAtom::SendAtom(int style, Boolean output)
{
  style = (output) ? CR_SENDA : style;

  if (m_disabled) return;

  switch ( style )
  {
    case CR_SELECT:
    {
      Select();
      mp_parent->DrawViews();
      break;
    }
    case CR_APPEND:
    {
      ((CrEditBox*)(CcController::theController)->GetInputPlace())->AddText(" "+m_label+" ");
      break;
    }
    case CR_SENDA:
    {
      (CcController::theController)->SendCommand(m_label);
      break;
    }
    case CR_SENDB:
    {
      CcString element, number;
      int pos1 = 1, pos2 = 1;
      for (int i = 1; i < m_label.Length(); i++)
      {
        if ( m_label[i] == '(' )
        {
          pos1 = i+1;
          element = m_label.Sub(1,pos1-1);
        }
        if ( m_label[i] == ')' )
        {
          pos2 = i+1;
          number = m_label.Sub(pos1+1, pos2-1);
        }
      }
      if ( ( pos1 != 1 ) && ( pos2 != 1 ) )
      {
        (CcController::theController)->SendCommand(element + "_N" + number);
      }
      break;
    }
    case CR_SENDC:
    {
      (CcController::theController)->SendCommand("ATOM_N" + m_label);
      break;
    }
    case CR_SENDD:
    {
      CcString element, number;
      int pos1 = 1, pos2 = 1;
      for (int i = 1; i < m_label.Length(); i++)
      {
        if ( m_label[i] == '(' )
        {
          pos1 = i+1;
          element = m_label.Sub(1,pos1-1);
        }
        if ( m_label[i] == ')' )
        {
          pos2 = i+1;
          number = m_label.Sub(pos1+1, pos2-1);
        }
      }
      if ( ( pos1 != 1 ) && ( pos2 != 1 ) )
      {
        (CcController::theController)->SendCommand("ATOM_N" + element + "_N" + number);
      }
      break;
    }
    case CR_SENDC_AND_SELECT:
    {
      CcString cSet = (Select()) ? "SET" : "UNSET" ;
      mp_parent->DrawViews();
      (CcController::theController)->SendCommand("ATOM_N" + m_label + "_N" + cSet);
      break;
    }
  }
}
