
#include "crystalsinterface.h"
#include "ccstring.h"
#include "crconstants.h"
#include "ccmodeldoc.h"
#include "ccmodelbond.h"
#include "cctokenlist.h"
#include <math.h>
#include "ccrect.h"
#include "crmodel.h"
#include "cxmodel.h"
#include "creditbox.h"
#include "cccontroller.h"
#include "ccstring.h"

CcModelBond::CcModelBond(CcModelDoc * pointer)
{
    m_x1 = m_y1 = m_z1 = 0;
    m_x2 = m_y2 = m_z2 = 0;
    m_r = m_g = m_b = 0;
    m_rad = 0;
    m_xrot = 0;
    m_yrot = 0;
    m_length = 1;
    m_atom1 = nil; m_atom2 = nil;
    mp_parent = pointer;
    m_excluded = false;
    m_glID = 0;
    m_type = CC_BOND;
}

CcModelBond::CcModelBond(int x1,int y1,int z1, int x2, int y2, int z2,
            int r, int g, int b,  int rad,int btype,
            int np, int * ptrs, CcString label, CcString cslabl,
            CcModelDoc* ptr)
{
  mp_parent = ptr;
  m_x1 = x1; m_y1 = y1; m_z1 = z1;
  m_x2 = x2; m_y2 = y2; m_z2 = z2;
  m_r = r; m_g = g; m_b = b;
  m_rad = rad;
  m_bondtype = abs(btype);
  m_bsym = ( btype < 0 );
  m_np = np;
  m_patms = new CcModelAtom*[np];
  for (int i = 0; i < np; i++ ) {
    m_patms[i] = mp_parent->FindAtomByPosn( ptrs[i] );
  }
  m_atom1 = m_patms[0];
  m_atom2 = m_patms[1];
  m_label = label;
  m_slabel = cslabl;
  m_xrot = 0;
  m_yrot = 0;
  m_length = 1;
  m_excluded = false;
  m_glID = 0;
  m_type = CC_BOND;
    float xlen = (float)(m_x2-m_x1);
    float ylen = (float)(m_y2-m_y1);
    float zlen = (float)(m_z2-m_z1);
    float xzlen =  (float)sqrt ( xlen*xlen + zlen*zlen );

    float degToRad = (float) (3.1415926535 / 180.0);
    m_xrot = (float) -atan2( ylen, xzlen ) / (float) degToRad;
    m_yrot =  (float) atan2( xlen , zlen ) / (float) degToRad;
    m_length = (float)sqrt ( xlen*xlen + ylen*ylen + zlen*zlen );


}

CcModelBond::~CcModelBond()
{
}

void CcModelBond::ParseInput(CcTokenList* tokenList)
{
    float degToRad = (float) (3.1415926535 / 180.0);
//Just read 10 integers.
    m_x1 =  atoi( tokenList->GetToken().ToCString() );
    m_y1 =  atoi( tokenList->GetToken().ToCString() );
    m_z1 =  atoi( tokenList->GetToken().ToCString() );
    m_x2 =  atoi( tokenList->GetToken().ToCString() );
    m_y2 =  atoi( tokenList->GetToken().ToCString() );
    m_z2 =  atoi( tokenList->GetToken().ToCString() );
    m_r =   atoi( tokenList->GetToken().ToCString() );
    m_g =   atoi( tokenList->GetToken().ToCString() );
    m_b =   atoi( tokenList->GetToken().ToCString() );
    m_rad = atoi( tokenList->GetToken().ToCString() );
    CcString catom1 = tokenList->GetToken();
    CcString catom2 = tokenList->GetToken();
    m_label = catom1 + "-" + catom2 + " " + tokenList->GetToken();
    m_bondtype = atoi( tokenList->GetToken().ToCString() );
    CcModelObject *oitem;
    oitem = mp_parent->FindAtomByLabel( catom1 );
    if ( oitem && oitem->Type()==CC_ATOM )
       m_atom1 = (CcModelAtom*)oitem;
    oitem = mp_parent->FindAtomByLabel( catom2 );
    if ( oitem && oitem->Type()==CC_ATOM )
       m_atom2 = (CcModelAtom*)oitem;

// Do these calculations now. Uses 3 bytes more memory per bond, but saves a lot of time later,
// as they were re-calculated every time the model is rotated.
    float xlen = (float)(m_x2-m_x1);
    float ylen = (float)(m_y2-m_y1);
    float zlen = (float)(m_z2-m_z1);
    float xzlen =  (float)sqrt ( xlen*xlen + zlen*zlen );

    m_xrot = (float) -atan2( ylen, xzlen ) / (float) degToRad;
    m_yrot =  (float) atan2( xlen , zlen ) / (float) degToRad;
    m_length = (float)sqrt ( xlen*xlen + ylen*ylen + zlen*zlen );

}

void CcModelBond::Render(CcModelStyle *style, bool feedback)
{

   float vecX, vecY, vecZ;

   if ( ( m_bondtype >= 2 ) && ( m_bondtype <= 4 ) )
   {

//Our vector is perpendicular to the view direction and the bond
//direction (i.e. cross prod).
         vecX = style->m_modview->mat[6] * (m_z2 - m_z1)
              - style->m_modview->mat[10] * (m_y2 - m_y1);
         vecY = style->m_modview->mat[10] * (m_x2 - m_x1)
              - style->m_modview->mat[2] * (m_z2 - m_z1);
         vecZ = style->m_modview->mat[2] * (m_y2 - m_y1)
              - style->m_modview->mat[6] * (m_x2 - m_x1);
         float vecLeng = (float)max ( 0.001, sqrt ( vecX*vecX + vecY*vecY + vecZ*vecZ ));
         vecX = vecX / vecLeng;
         vecY = vecY / vecLeng;
         vecZ = vecZ / vecLeng;
   }

   int detail = (style->high_res)? style->normal_res : style->quick_res ;

   GLUquadricObj* cylinder;
   if ( m_excluded )
   {
        GLfloat Surface[] = { 128.0f+(float)m_r/127.0f,128.0f+(float)m_g/127.0f,128.0f+(float)m_b/127.0f, 1.0f };
        GLfloat Diffuse[] = { 128.0f+(float)m_r/127.0f,128.0f+(float)m_g/127.0f,128.0f+(float)m_b/127.0f, 1.0f };
        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
   }
   else
   {
        GLfloat Surface[] = { (float)m_r/255.0f,(float)m_g/255.0f,(float)m_b/255.0f, 1.0f };
        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
   }

   int bondrad = (int)((float)m_rad * style->radius_scale);

   if ( m_bondtype == 2 )
   {
     bondrad = (int) ((float)bondrad / 1.5 );
     int offd = (int)(1.5 * (float)bondrad);
     glPushMatrix();
        glTranslated(offd*vecX+(m_x1+m_x2)/2.0f, offd*vecY+(m_y1+m_y2)/2.0f, offd*vecZ+(m_z1+m_z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
        gluDeleteQuadric(cylinder);
     glPopMatrix();
     glPushMatrix();
        glTranslated(-offd*vecX+((m_x1+m_x2)/2.0f), -offd*vecY+((m_y1+m_y2)/2.0f), -offd*vecZ+((m_z1+m_z2)/2.0f));   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
        gluDeleteQuadric(cylinder);
     glPopMatrix();
   }
   else if ( m_bondtype == 3 )
   {
     bondrad = (int) ((float)bondrad / 1.5 );
     int offd = (int)(2.5 * (float)bondrad);
     glPushMatrix();
        glTranslated((m_x1+m_x2)/2.0f, (m_y1+m_y2)/2.0f, (m_z1+m_z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
        gluDeleteQuadric(cylinder);
     glPopMatrix();
     glPushMatrix();
        glTranslated(offd*vecX+(m_x1+m_x2)/2.0f, offd*vecY+(m_y1+m_y2)/2.0f, offd*vecZ+(m_z1+m_z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
        gluDeleteQuadric(cylinder);
     glPopMatrix();
     glPushMatrix();
        glTranslated(-offd*vecX+(m_x1+m_x2)/2.0f, -offd*vecY+(m_y1+m_y2)/2.0f, -offd*vecZ+(m_z1+m_z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
        gluDeleteQuadric(cylinder);
     glPopMatrix();
   }
   else if ( m_bondtype == 101 ) //TORUS!
   {
     glPushMatrix();
        glTranslated((float)m_x1, (float)m_y1, (float)m_z1);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
//        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
//        glScalef((float)bondrad, (float)bondrad, (float)bondrad);
//        glCallList(TORUS);

        float rc = (float)bondrad; // torus thickness
        int numt = max(10,detail);             // num of cylinders to make torus?
        float rt = m_length ;          // torus radius
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
//                 LOGWARN ( "xyz:"+CcString(x)+" "+CcString(y)+" "+CcString(z) );
                 glNormal3f(x, y, z);
                 x = (float)((rt + rc * cos(s*twopi/numc)) * cos(t*twopi/numt));
                 y = (float)((rt + rc * cos(s*twopi/numc)) * sin(t*twopi/numt));
                 z = (float)(rc * sin(s*twopi/numc));
//                 LOGWARN ( "xyz:"+CcString(x)+" "+CcString(y)+" "+CcString(z));
                 glVertex3f(x, y, z);
              }
           }
           glEnd();
        }

     glPopMatrix();
   }
   else
   {
      glPushMatrix();

// Remember that these commands appear backwards if you think of them
// operating on the bond, instead try thinking of them operating on the whole
// view, while the bond stands still.

        glTranslated((m_x1+m_x2)/2.0f, (m_y1+m_y2)/2.0f, (m_z1+m_z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
        gluDeleteQuadric(cylinder);
      glPopMatrix();
   }

}

void CcModelBond::SelfExclude()
{
 //Called after atoms have been excluded from the picture.

 if (m_atom1) m_excluded = m_atom1->m_excluded;
 if (m_atom2) m_excluded = m_atom2->m_excluded || m_excluded;

}



void CcModelBond::SendAtom(int style, bool output)
{
  style = (output) ? CR_SENDA : style;

  if (m_disabled) return;

  if (!m_bsym) return;

  switch ( style )
  {
    case CR_APPEND:
    {
      ((CrEditBox*)(CcController::theController)->GetInputPlace())->AddText(" "+m_slabel+" ");
      break;
    }
    case CR_SENDA:
    {
      (CcController::theController)->SendCommand(m_slabel);
      break;
    }
    case CR_SENDC:
    {
      (CcController::theController)->SendCommand("ATOM_N" + m_slabel);
      break;
    }
  }
}
