
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
#include "cccontroller.h"
#include "ccstring.h"

CcModelBond::CcModelBond(CcModelDoc * pointer)
{
    x1 = y1 = z1 = 0;
    x2 = y2 = z2 = 0;
    r = g = b = 0;
    rad = 0;
    xrot = 0;
    yrot = 0;
    length = 1;
    atom1 = nil; atom2 = nil;
    mp_parent = pointer;
    m_excluded = false;
}

CcModelBond::~CcModelBond()
{
}

void CcModelBond::ParseInput(CcTokenList* tokenList)
{
    float degToRad = (float) (3.1415926535 / 180.0);
//Just read 10 integers.
    x1 =  atoi( tokenList->GetToken().ToCString() );
    y1 =  atoi( tokenList->GetToken().ToCString() );
    z1 =  atoi( tokenList->GetToken().ToCString() );
    x2 =  atoi( tokenList->GetToken().ToCString() );
    y2 =  atoi( tokenList->GetToken().ToCString() );
    z2 =  atoi( tokenList->GetToken().ToCString() );
    r =   atoi( tokenList->GetToken().ToCString() );
    g =   atoi( tokenList->GetToken().ToCString() );
    b =   atoi( tokenList->GetToken().ToCString() );
    rad = atoi( tokenList->GetToken().ToCString() );
    CcString catom1 = tokenList->GetToken();
    CcString catom2 = tokenList->GetToken();
    label = catom1 + "-" + catom2 + " " + tokenList->GetToken();
    atom1 = mp_parent->FindAtomByLabel( catom1 );
    atom2 = mp_parent->FindAtomByLabel( catom2 );


// Do these calculations now. Uses 3 bytes more memory per bond, but saves a lot of time later,
// as they were re-calculated every time the model is rotated.
    float xlen = (float)(x2-x1);
    float ylen = (float)(y2-y1);
    float zlen = (float)(z2-z1);
    float xzlen =  (float)sqrt ( xlen*xlen + zlen*zlen );

    xrot = (float) -atan2( ylen, xzlen ) / (float) degToRad;
    yrot =  (float) atan2( xlen , zlen ) / (float) degToRad;
    length = (float)sqrt ( xlen*xlen + ylen*ylen + zlen*zlen );

}

void CcModelBond::Render(CrModel * view, bool detailed)
{


   int detail = (detailed)? view->m_NormalRes : view->m_QuickRes ;
   glPushMatrix();
   glPushAttrib(GL_POLYGON_BIT);


      GLUquadricObj* cylinder;
      if ( m_excluded )
      {
        glPolygonMode(GL_FRONT, GL_POINT);
        glPolygonMode(GL_BACK, GL_POINT);
        GLfloat Surface[] = { 128.0f+(float)r/127.0f,128.0f+(float)g/127.0f,128.0f+(float)b/127.0f, 1.0f };
        GLfloat Diffuse[] = { 128.0f+(float)r/127.0f,128.0f+(float)g/127.0f,128.0f+(float)b/127.0f, 1.0f };
        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
      }
      else
      {
        GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
        GLfloat Diffuse[] = { 0.2f,0.2f,0.2f,1.0f };
        GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
        GLfloat Shinine[] = {89.6f};
        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
      }

      int bondrad = (int)((float)rad* view->RadiusScale());

// Remember that these commands appear backwards if you think of them
// operating on the bond, instead think of them operating on the whole
// view, while the bond stands still.

      glTranslated((x1+x2)/2.0f, (y1+y2)/2.0f, (z1+z2)/2.0f);   //Translate view origin to the center of the bond
      glRotatef(yrot,0,1,0);
      glRotatef(xrot,1,0,0);
      glTranslated(0, 0, -length / 2);           //shift the cylinder so it is centered at 0,0,0;
      cylinder = gluNewQuadric();
      gluQuadricDrawStyle(cylinder,GLU_FILL);
      gluCylinder(cylinder,(float)bondrad,(float)bondrad,length, detail, detail);
      gluDeleteQuadric(cylinder);

   glPopAttrib();
   glPopMatrix();



}

void CcModelBond::SelfExclude()
{
 //Called after atoms have been excluded from the picture.

 if (atom1) m_excluded = atom1->m_excluded;
 if (atom2) m_excluded = atom2->m_excluded || m_excluded;

}






/*
      glPushMatrix();
        glTranslated(100*vecX+(x1+x2)/2.0f, 100*vecY+(y1+y2)/2.0f, 100*vecZ+(z1+z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(yrot,0,1,0);
        glRotatef(xrot,1,0,0);
        glTranslated(0, 0, -length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,length, detail, detail);
        gluDeleteQuadric(cylinder);
      glPopMatrix();
      glPushMatrix();
        glTranslated(-100*vecX+((x1+x2)/2.0f), -100*vecY+((y1+y2)/2.0f), -100*vecZ+((z1+z2)/2.0f));   //Translate view origin to the center of the bond
        glRotatef(yrot,0,1,0);
        glRotatef(xrot,1,0,0);
        glTranslated(0, 0, -length / 2);           //shift the cylinder so it is centered at 0,0,0;
        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,length, detail, detail);
        gluDeleteQuadric(cylinder);
       glPopMatrix();
*/

