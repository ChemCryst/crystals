
#include "crystalsinterface.h"
#include	"crconstants.h"
#include "ccmodelbond.h"
#include "cctokenlist.h"
#include <math.h>
#include "crmodel.h"
#include "cxmodel.h"
#include "cccontroller.h"
#include "ccstring.h"

CcModelBond::CcModelBond()
{
	ox1 = oy1 = oz1 = x1 = y1 = z1 = 0;
	ox2 = oy2 = oz2 = x2 = y2 = z2 = 0;
	r = g = b = 0;
	rad = 0;
	xrot = 0;
	yrot = 0;
	length = 1;
}

CcModelBond::~CcModelBond()
{
}

void CcModelBond::ParseInput(CcTokenList* tokenList)
{
    float degToRad = (float) (3.1415926535 / 180.0);
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

// Do these calculations now. Uses 3 bytes more memory per bond, but saves a lot of time later,
// as they were re-calculated every time the model is rotated.
    float xlen = (float)(x2-x1);
	float ylen = (float)(y2-y1);
	float zlen = (float)(z2-z1);
    float xzlen =  (float)sqrt ( xlen*xlen + zlen*zlen );
	
    xrot = -atan2( ylen, xzlen ) / (float) degToRad;
    yrot =  atan2( xlen , zlen ) / (float) degToRad;
    length = (float)sqrt ( xlen*xlen + ylen*ylen + zlen*zlen );


}

void CcModelBond::Render(CrModel * view, Boolean detailed)
{

                                                   
/*   float vecX = ((CxModel*)view->mWidgetPtr)->mat[6] * (z2 - z1)
//              - ((CxModel*)view->mWidgetPtr)->mat[10] * (y2 - y1);
//   float vecY = ((CxModel*)view->mWidgetPtr)->mat[10] * (x2 - x1)
//              - ((CxModel*)view->mWidgetPtr)->mat[2] * (z2 - z1);
//  float vecZ = ((CxModel*)view->mWidgetPtr)->mat[2] * (y2 - y1)
//              - ((CxModel*)view->mWidgetPtr)->mat[6] * (x2 - x1);
//
//
//   TEXTOUT("VECX "+CcString(vecX)+" VECY "+CcString(vecY)+"VECZ "+CcString(vecZ));
//
//   float vecLeng = max ( 0.001, sqrt ( vecX*vecX + vecY*vecY + vecZ*vecZ ));
//   vecX = vecX / vecLeng;
//   vecY = vecY / vecLeng;
//   vecZ = vecZ / vecLeng;
//
*/

   int detail = (detailed)? view->m_NormalRes : view->m_QuickRes ;
   glPushMatrix();
      GLUquadricObj* cylinder;
      GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
      GLfloat Diffuse[] = { 0.2f,0.2f,0.2f,1.0f };
      GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
      GLfloat Shinine[] = {89.6f};
      glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
      glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
      glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
      glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);

      int bondrad = (int)((float)rad* view->RadiusScale());
//      float xlen = (float)(x2-x1), ylen = (float)(y2-y1), zlen = (float)(z2-z1);
//      float length = (float)sqrt ( xlen*xlen + ylen*ylen + zlen*zlen );
//      float xrot = (float)asin (min(1.0f,max(-1.0f,(-ylen/length))));
//      float yrot = (float)acos (min(1.0f,max(-1.0f,(zlen/(length*cos(xrot)) ))));
//      if ( (length*cos(xrot)*sin(yrot))/xlen < 0 )
//			yrot = -yrot;
// Changed to use atan2 instead of acos and asin and moved into ParseInput so only calced once.


	  glTranslated((x1+x2)/2.0f, (y1+y2)/2.0f, (z1+z2)/2.0f);   //Translate view origin to the center of the bond
      glRotatef(yrot,0,1,0);
      glRotatef(xrot,1,0,0);
      glTranslated(0, 0, -length / 2);           //shift the cylinder so it is centered at 0,0,0;
      cylinder = gluNewQuadric();
      gluQuadricDrawStyle(cylinder,GLU_FILL);
      gluCylinder(cylinder,(float)bondrad,(float)bondrad,length, detail, detail);
      gluDeleteQuadric(cylinder);


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
   glPopMatrix();



}

