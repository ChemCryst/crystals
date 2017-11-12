
#include "crystalsinterface.h"
#include <string>
#include    <math.h>
using namespace std;

#include "crconstants.h"
#include "ccmodelatom.h"
#include "ccmodeldoc.h"
#include "crmodel.h"
#include "creditbox.h"
#include "crmultiedit.h"
#include "ccpoint.h"
#include "cccontroller.h"

CcModelAtom::CcModelAtom(CcModelDoc* parentptr)
{
  mp_parent = parentptr;
  Init();
}

CcModelAtom::CcModelAtom(const string & llabel,int lx1,int ly1,int lz1, 
                          int lr, int lg, int lb, int locc,float lcov, int lvdw,
                          int lspare, int lflag,
                          float u1,float u2,float u3,float u4,float u5,
                          float u6,float u7,float u8,float u9,
                          float fx, float fy, float fz,
                          const string & elem, int serial, int refflag,
                          int assembly, int group, float ueq, float fspare,
                          CcModelDoc* parentptr)
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
  frac_x = fx;
  frac_y = fy;
  frac_z = fz;
  m_ueq = ueq;
  m_serial = serial;
  m_refflag = refflag;
  m_assembly = assembly;
  m_group = group;
  m_elem = elem;
  m_spare = fspare;
  m_nbonds = 0;
  
  localmatrix[0]=x11;
  localmatrix[1]=x12;
  localmatrix[2]=x13;
  localmatrix[3]=0.0;
  localmatrix[4]=x21;
  localmatrix[5]=x22;
  localmatrix[6]=x23;
  localmatrix[7]=0.0;
  localmatrix[8]=x31;
  localmatrix[9]=x32;
  localmatrix[10]=x33;
  localmatrix[11]=0.0;
  localmatrix[12]=0.0;
  localmatrix[13]=0.0;
  localmatrix[14]=0.0;
  localmatrix[15]=1.0;

}


void CcModelAtom::Init()                                   
{
  m_type = CC_ATOM;
  x = y = z = 0;
  r = g = b = 0;
  id = 0;
  occ = 1;
  sparerad = vdwrad = 1000;
  covrad = 1000.0f;
  x11 = x12 = x13 = x21 = x22 = x23 = x31 = x32 = x33 = 0.0f;
  m_label = "Err";
  m_IsADP = true;
  spare = false;
  m_glID = 0;
  m_ueq = 0.0;
  m_serial = 0;
  m_refflag = 0;
  m_assembly = 0;
  m_group = 0;
  m_elem = "";
  frac_x = 0.0;
  frac_y = 0.0;
  frac_z = 0.0;
  m_spare = 0.0;
  m_nbonds = 0;

}

CcModelAtom::~CcModelAtom()
{
}

void CcModelAtom::ParseInput(deque<string> &  tokenList)
{
//        string theString;
//Just read ID, LABEL,
// IX, IY, IZ,
// RED, GREEN, BLUE,
// OCC*1000,
// COVRAD, VDWRAD, SPARERAD
// FLAG,
// UISO or X11
// X12, x13, x22, x23, x31, x32, x33
      id        = atoi ( tokenList[0].c_str() );
      m_label     =  string(tokenList[1]);    //LABEL
      x         = atoi ( tokenList[2].c_str() );
      y         = atoi ( tokenList[3].c_str() );
      z         = atoi ( tokenList[4].c_str() );
      r         = atoi ( tokenList[5].c_str() );
      g         = atoi ( tokenList[6].c_str() );
      b         = atoi ( tokenList[7].c_str() );
      occ       = atoi ( tokenList[8].c_str() );
      covrad    = (float)atof ( tokenList[9].c_str() );
      vdwrad    = atoi ( tokenList[10].c_str() );
      sparerad  = atoi ( tokenList[11].c_str() );
      m_IsADP   = (atoi( tokenList[12].c_str() ) == 0 );
      x11       = (float)atof ( tokenList[13].c_str() );
      x12       = (float)atof ( tokenList[14].c_str() );
      x13       = (float)atof ( tokenList[15].c_str() );
      x21       = (float)atof ( tokenList[16].c_str() );
      x22       = (float)atof ( tokenList[17].c_str() );
      x23       = (float)atof ( tokenList[18].c_str() );
      x31       = (float)atof ( tokenList[19].c_str() );
      x32       = (float)atof ( tokenList[20].c_str() );
      x33       = (float)atof ( tokenList[21].c_str() );
      
      for ( int i = 0; i<22; i++ ) tokenList.pop_front();
     
      localmatrix[0]=x11;
      localmatrix[1]=x12;
      localmatrix[2]=x13;
      localmatrix[3]=0.0;
      localmatrix[4]=x21;
      localmatrix[5]=x22;
      localmatrix[6]=x23;
      localmatrix[7]=0.0;
      localmatrix[8]=x31;
      localmatrix[9]=x32;
      localmatrix[10]=x33;
      localmatrix[11]=0.0;
      localmatrix[12]=0.0;
      localmatrix[13]=0.0;
      localmatrix[14]=0.0;
      localmatrix[15]=1.0;
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

float CcModelAtom::R()
{
    return covrad;
}

void CcModelAtom::Render(CcModelStyle *style, bool feedback)
{

  glPushMatrix();

  GLUquadricObj* sphere = gluNewQuadric();
  gluQuadricDrawStyle(sphere,GLU_FILL);
  glTranslated(x,y,z);
  float extra = 0.0f;
  int detail = style->normal_res ;

  if (feedback) {

        mp_parent->ApplyIndexColour( m_glID );
//        glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );

  } else if ( m_label.length() && ( m_label[0] == 'Q' ) && ( sparerad < style->min_peak_height_to_show  ) ) {
  // do not show
		GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 0.05f };
		glColor4fv( Surface );
  } else if ( style->radius_type == CRTINY ) {  //make invisible (unless selected or no bonds)

    if ( m_nbonds == 0 ) {
		GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
		glColor4fv( Surface );
	} else if ( !m_selected ) { 
		GLfloat Surface[] = { 1.0f, 1.0f, 1.0f, 0.0f };
		glColor4fv( Surface );
	} else if ( m_excluded ) {
//        GLfloat Surface[] = { 128.0f+(float)r/127.0f,128.0f+(float)g/127.0f,128.0f+(float)b/127.0f, 0.3f };
		GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 0.05f };
        glColor4fv( Surface );
        extra = 20.0f;
	} else {
		GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 0.3f };
		glColor4fv( Surface );
	}

  } else if ( m_excluded ) {
    GLfloat Surface[] = { 128.0f+(float)r/127.0f,128.0f+(float)g/127.0f,128.0f+(float)b/127.0f, 1.0f };
    glColor4fv( Surface );
    extra = 20.0f;
  }
  else if ( m_selected ) // highlighted
  {

    GLfloat lightDiffuse[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    GLfloat lightAmbient[] ={ 1.0f, 1.0f, 1.0f, 1.0f };
    glLightfv(GL_LIGHT1, GL_DIFFUSE, lightDiffuse);
    glLightfv(GL_LIGHT1, GL_AMBIENT, lightAmbient);
    glEnable(GL_LIGHT1);

    GLfloat Surface[] = { ((float)r+64)/319.0f,((float)g+64)/319.0f,((float)b+64)/319.0f, 1.0f };
    glColor4fv( Surface );
    extra = 10.0f;
  }
  else if ( m_disabled )  // disabled atom
  {
    GLfloat Diffuse[] = { (float)r/512.0f,(float)g/512.0f,(float)b/512.0f, 1.0f };
    glColor4fv( Diffuse );
    extra = 20.0f;
  }
  else  // normal
  {
    GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
    glColor4fv( Surface );
  }




  if ( (!style->showh) && ( m_label.length() > 1 ) && ( m_label[0] == 'H' ) && ( m_label[1] == '(' ) ) {
		// draw nothing
  } else if (style->radius_type == CRCOVALENT) {
		gluSphere(sphere, (covrad + extra ) * style->radius_scale,detail,detail);
  } else if (style->radius_type == CRTINY) {
		gluSphere(sphere, (covrad + extra ) * style->radius_scale,detail,detail);
  } else if(style->radius_type == CRVDW) {
    gluSphere(sphere, ((float)vdwrad + extra ) * style->radius_scale,detail,detail);
  } else if(style->radius_type == CRSPARE) {
    if ( m_label.length() && ( m_label[0] == 'Q' ) )
    {
      gluSphere(sphere, ((float)sparerad + extra ) * style->radius_scale,detail,detail);
    }
    else
    {
      gluSphere(sphere, (covrad + extra ) * style->radius_scale,detail,detail);
    }
  } else if(style->radius_type == CRTHERMAL) {
    if ( m_IsADP) {
     glMultMatrixf(*&localmatrix);
     gluSphere(sphere, ( 1.0f + (extra / 1000.0f) ), detail,detail);

	  
	 if ( !feedback) {

      GLfloat Surface[] = { 0.0f, 0.0f, 0.0f, 1.0f };
      glColor4fv( Surface );

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
    } else {
      gluSphere(sphere, x11 + extra, detail, detail);
    }
  }


  if ( m_selected && ! feedback ) { // highlighted
	glDisable(GL_LIGHT1);
  }
  
  gluDeleteQuadric(sphere);
  glPopMatrix();

}

// Return the radius of given atom, using the style settings provided.
int CcModelAtom::Radius(CcModelStyle * style) {
 
  int radius = 1;

  if (style->radius_type == CRCOVALENT)
  {
    radius = (int)(covrad * style->radius_scale);
  }
  else if(style->radius_type == CRVDW)
  {
    radius = (int)(vdwrad * style->radius_scale);
  }
  else if(style->radius_type == CRSPARE)
  {
    if ( m_label.length() && ( m_label[0] == 'Q' ) )
    {
      radius = (int)(sparerad * style->radius_scale);
    }
    else
    {
      radius =  (int)(covrad  * style->radius_scale);
    }
  }
  else if(style->radius_type == CRTHERMAL)
  {
  // Approximate method, consider action on three orthogonal vectors, and return largest
  // there is potential to underestimate edge cases by a factor of about 1.4.
     float r1 = fabs(x11) + fabs(x12) + fabs(x13);
	 float r2 = fabs(x21) + fabs(x22) + fabs(x23);
	 float r3 = fabs(x31) + fabs(x32) + fabs(x33);
	 radius = (int) ((r1 > r2)? ((r1 > r3)? r1 : r3) : (( r2 > r3 )? r2:r3 ));
  }
  
  return radius;
}

CcPoint CcModelAtom::GetAtom2DCoord(float * mat) {
	int x2 = (int)((mat[0] * (float)x) + (mat[4] * (float)y) + (mat[8] * (float)z));
	int y2 = (int)((mat[1] * (float)x) + (mat[5] * (float)y) + (mat[9] * (float)z));
	return CcPoint(x2,y2);
}


void CcModelAtom::SendAtom(int style, bool output)
{
  style = (output) ? CR_SENDA : style;

  if (m_disabled) return;

  switch ( style )
  {
    case CR_SELECT:
    {
      if ( Select() )  mp_parent->EnsureVisible(this);
      mp_parent->DrawViews();
      break;
    }
    case CR_APPEND:
    {
      ((CrEditBox*)(CcController::theController)->GetInputPlace())->AddText(" "+m_label+" ");
      break;
    }
    case CR_INSERTIN:
    {
      mp_parent->SendInsertText(m_label);
      break;
    }
    case CR_SENDA:
    {
      (CcController::theController)->SendCommand(m_label);
      break;
    }
    case CR_SENDB:
    {
      string element, number;
      string::size_type pos1 = m_label.find('(');
      string::size_type pos2 = m_label.find(')');
      if ( (pos1 != string::npos ) && ( pos2 != string::npos ) )
      {
        element = m_label.substr(0,pos1);
        number = m_label.substr(pos1+1,pos2-pos1-1);
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
      string element, number;
      string::size_type pos1 = m_label.find('(');
      string::size_type pos2 = m_label.find(')');
      if ( (pos1 != string::npos ) && ( pos2 != string::npos ) )
      {
        element = m_label.substr(0,pos1);
        number = m_label.substr(pos1+1,pos2-pos1-1);
        (CcController::theController)->SendCommand("ATOM_N" + element + "_N" + number);
      }
      break;
    }
    case CR_SENDC_AND_SELECT:
    {
      string cSet = (Select()) ? "SET" : "UNSET" ;
      mp_parent->DrawViews();
      (CcController::theController)->SendCommand("ATOM_N" + m_label + "_N" + cSet);
      break;
    }
  }
}
