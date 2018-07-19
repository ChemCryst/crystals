
#include "crystalsinterface.h"
#include <string>
using namespace std;

#include "crconstants.h"
#include "ccmodelsphere.h"
#include "ccmodeldoc.h"
#include <math.h>
#include "crmodel.h"
#include "creditbox.h"
#include "cccontroller.h"

CcModelSphere::CcModelSphere(CcModelDoc* parentptr)
{
  mp_parent = parentptr;
  Init();
}

CcModelSphere::CcModelSphere(string llabel,int lx1,int ly1,int lz1, 
                          int lr, int lg, int lb, int locc,int lcov, int lvdw,
                          int lspare, int lflag,
                          int iso, int irad, CcModelDoc* parentptr)
{
  mp_parent = parentptr;
  Init();
  x = lx1; y = ly1; z = lz1;
  r = lr; g = lg; b = lb;
  occ = locc;
  covrad = lcov; vdwrad = lvdw; sparerad = lspare;
  x11 = iso;
  rad = irad;
  m_label = llabel;


}


void CcModelSphere::Init()
{
  m_type = CC_SPHERE;
  x = y = z = 0;
  r = g = b = 0;
  id = 0;
  occ = 1;
  sparerad = covrad = vdwrad = 1000;
  x11 = 0;
  rad = 0;
  m_label = "Err";
  spare = false;
  m_glID = 0;
}

CcModelSphere::~CcModelSphere()
{
}

void CcModelSphere::ParseInput(deque<string> &  tokenList)
{
//        string theString;
//Just read ID, LABEL,
// IX, IY, IZ,
// RED, GREEN, BLUE,
// OCC*1000,
// COVRAD, VDWRAD, SPARERAD
// FLAG,
// UISO or X11
      id        = atoi ( tokenList[0].c_str() );
      m_label   = string( tokenList[1]);    //LABEL
      x         = atoi ( tokenList[2].c_str() );
      y         = atoi ( tokenList[3].c_str() );
      z         = atoi ( tokenList[4].c_str() );
      r         = atoi ( tokenList[5].c_str() );
      g         = atoi ( tokenList[6].c_str() );
      b         = atoi ( tokenList[7].c_str() );
      occ       = atoi ( tokenList[8].c_str() );
      covrad    = atoi ( tokenList[9].c_str() );
      vdwrad    = atoi ( tokenList[10].c_str() );
      sparerad  = atoi ( tokenList[11].c_str() );
      x11       = atoi ( tokenList[12].c_str() );
      rad       = atoi ( tokenList[13].c_str() );
      for ( int i = 0; i<14; i++ ) tokenList.pop_front();

}

int CcModelSphere::X()
{
    return x;
}
int CcModelSphere::Y()
{
    return y;
}
int CcModelSphere::Z()
{
    return z;
}
int CcModelSphere::R()
{
    return covrad;
}

void CcModelSphere::Render(CcModelStyle *style, bool feedback)
{
  glPushMatrix();

  float extra = 0.0;

  int detail = style->normal_res;

   if (feedback) {
        mp_parent->ApplyIndexColour( m_glID );
        //glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
   }
   else if ( m_excluded )
  {
    GLfloat Surface[] = { 128.0f+(float)r/127.0f,128.0f+(float)g/127.0f,128.0f+(float)b/127.0f, 1.0f };
    glColor4fv( Surface );
    extra = 20.0;
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

  float innerrad = ( (float) rad - (float) covrad ) * style->radius_scale;
  float outerrad = ( (float) rad + (float) covrad ) * style->radius_scale;

  if(style->radius_type == CRVDW)
  {
    innerrad = ( (float) rad - (float) vdwrad ) * style->radius_scale;
    outerrad = ( (float) rad + (float) vdwrad ) * style->radius_scale;
  }
  else if(style->radius_type == CRSPARE)
  {
    if ( m_label.length() && ( m_label[0] == 'Q' ) )
    {
      innerrad = ( (float) rad - (float) sparerad ) * style->radius_scale;
      outerrad = ( (float) rad + (float) sparerad ) * style->radius_scale;
    }
  }
  else if(style->radius_type == CRTHERMAL)
  {
      innerrad = ( (float) rad * style->radius_scale ) - (float) x11 ;
      outerrad = ( (float) rad * style->radius_scale ) + (float) x11 ;
  }

  glPushMatrix();
      glTranslated((float)x, (float)y, (float)z);   //Translate view origin to the center.

      for ( int j = 0; j < 2; j ++ )
      {
       glRotatef(90.0f,1,0,0);

       for ( int i = 0; i < 4; i ++ )
       {
        glRotatef(45.0f,0,1,0);

        float rc = (outerrad-innerrad)/2.5f;  // torus thickness
        int numt = CRMAX(10,detail);             // num of cylinders to make torus?
        float rt = (float)rad ;          // torus radius
        int numc = detail;             // num of sides to cylinder?
        float s, t;
        float x, y, z;
        float pi, twopi;
        pi = 3.14159265358979323846f;
        twopi = 2.0f * pi;
        for (int i = 0; i < numc; i++) {
           glBegin(GL_QUAD_STRIP);
           for (int j = 0; j <= numt; j++) {
              for (int k = 0; k <= 1; k++) {
                 s = (i + k) % numc + 0.5f;
                 t = (float)(j % numt);
                 x = (float)(cos(t*twopi/numt) * cos(s*twopi/numc));
                 y = (float)(sin(t*twopi/numt) * cos(s*twopi/numc));
                 z = (float)sin(s*twopi/numc);
                 glNormal3f(x, y, z);
                 x = (float)((rt + rc * cos(s*twopi/numc)) * cos(t*twopi/numt));
                 y = (float)((rt + rc * cos(s*twopi/numc)) * sin(t*twopi/numt));
                 z = (float)(rc * sin(s*twopi/numc));
                 glVertex3f(x, y, z);
              }
           }
           glEnd();
        }
      }
     }

  glPopMatrix();
  glDisable(GL_LIGHT1);

}

void CcModelSphere::SendAtom(int style, bool output)
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
