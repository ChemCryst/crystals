
#include "crystalsinterface.h"
#include <string>
#include <vector>
using namespace std;

#include "crconstants.h"
#include "ccmodeldoc.h"
#include "ccmodelbond.h"
#include <math.h>
#include "ccrect.h"
#include "crmodel.h"
#include "cxmodel.h"
#include "creditbox.h"
#include "cccontroller.h"


static const float partColours[7][3]= { { 255.0f, 0.0f, 0.0f },
										{ 0.0f, 255.0f, 0.0f },
										{ 0.0f, 0.0f, 255.0f },
										{ 255.0f, 255.0f, 0.0f },
										{ 255.0f, 0.0f, 255.0f },
										{ 0.0f, 255.0f, 255.0f },
										{ 128.0f, 0.0f, 255.0f } };

CcModelBond::CcModelBond(CcModelDoc * pointer)
{
    m_x1 = m_y1 = m_z1 = 0;
    m_x2 = m_y2 = m_z2 = 0;
    m_r = m_g = m_b = 0;
    m_rad = 0;
    m_xrot = 0;
    m_yrot = 0;
    m_length = 1;
    mp_parent = pointer;
    m_excluded = false;
    m_glID = 0;
    m_type = CC_BOND;
}

CcModelBond::CcModelBond(int x1,int y1,int z1, int x2, int y2, int z2,
            int r, int g, int b,  int rad,int btype,
            int np, int * ptrs, const string & label, 
            const string & cslabl,
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
  for (int i = 0; i < np; i++ ) {
      CcModelAtom* atom = mp_parent->FindAtomByPosn( ptrs[i] );
	  atom->m_nbonds++;
      m_patms.push_back( atom );
  }
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

void CcModelBond::ParseInput(deque<string> &  tokenList)
{
    float degToRad = (float) (3.1415926535 / 180.0);
//Just read 10 integers.
    m_x1 =  atoi( tokenList[0].c_str() );
    m_y1 =  atoi( tokenList[1].c_str() );
    m_z1 =  atoi( tokenList[2].c_str() );
    m_x2 =  atoi( tokenList[3].c_str() );
    m_y2 =  atoi( tokenList[4].c_str() );
    m_z2 =  atoi( tokenList[5].c_str() );
    m_r =   atoi( tokenList[6].c_str() );
    m_g =   atoi( tokenList[7].c_str() );
    m_b =   atoi( tokenList[8].c_str() );
    m_rad = atoi( tokenList[9].c_str() );
    string catom1 = string(tokenList[10]);
    string catom2 = string(tokenList[11]);
    m_label = catom1 + "-" + catom2 + " " + tokenList[12];
    m_bondtype = atoi( tokenList[13].c_str() );
    
    for ( int i = 0; i<14; i++ ) tokenList.pop_front();
    
    CcModelObject *oitem;
    oitem = mp_parent->FindAtomByLabel( catom1 );
    if ( oitem && oitem->Type()==CC_ATOM )
       m_patms.push_back((CcModelAtom*)oitem);
    oitem = mp_parent->FindAtomByLabel( catom2 );
    if ( oitem && oitem->Type()==CC_ATOM )
       m_patms.push_back((CcModelAtom*)oitem);

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

void CcModelBond::DrawBond(GLfloat* Surface1, GLfloat* Surface2, bool feedback, int detail, int bondrad)  {


		if (feedback) {
                        mp_parent->ApplyIndexColour( m_glID );
//                        glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
		} else {
			glColor4fv( Surface2 );
		}

		GLUquadricObj* cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length/2, detail, detail);
        gluDeleteQuadric(cylinder);

        glTranslated(0, 0, m_length/2);           //shift the end cap

		GLUquadricObj* sphere = gluNewQuadric();
		gluQuadricDrawStyle(sphere,GLU_FILL);
		gluSphere(sphere, (float)bondrad,detail,detail);
		gluDeleteQuadric(sphere);


		if (feedback) {
                        mp_parent->ApplyIndexColour( m_glID );
//                        glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
		} else {
			glColor4fv( Surface1 );
		}

        glTranslated(0, 0, -m_length);           //shift the cylinder 

        cylinder = gluNewQuadric();
        gluQuadricDrawStyle(cylinder,GLU_FILL);
        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length/2, detail, detail);
        gluDeleteQuadric(cylinder);

		sphere = gluNewQuadric();
		gluSphere(sphere, (float)bondrad,detail,detail);
		gluDeleteQuadric(sphere);

}

void CcModelBond::Render(CcModelStyle *style, bool feedback)
{

	if ( !style->showh ) {
		if (m_patms.size() > 1 ) {
			if ( (m_patms[0]->Label().length() > 1) && (m_patms[0]->Label()[0] == 'H')&& (m_patms[0]->Label()[1] == '(')) return;
			if ( (m_patms[1]->Label().length() > 1) && (m_patms[1]->Label()[0] == 'H')&& (m_patms[1]->Label()[1] == '(')) return;
		}
	}



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
         float vecLeng = (float)CRMAX ( 0.001, sqrt ( vecX*vecX + vecY*vecY + vecZ*vecZ ));
         vecX = vecX / vecLeng;
         vecY = vecY / vecLeng;
         vecZ = vecZ / vecLeng;
   }

   float transparency = 1.0f;
   
   if (m_patms.size() > 1 ) {
	// do not show
       if ( (m_patms[0]->Label().length() > 1) && (m_patms[0]->Label()[0] == 'Q')&& (m_patms[0]->sparerad < style->min_peak_height_to_show ) ) transparency = 0.05;
       if ( (m_patms[1]->Label().length() > 1) && (m_patms[1]->Label()[0] == 'Q')&& (m_patms[1]->sparerad < style->min_peak_height_to_show ) ) transparency = 0.05;
   }   
   
   int detail = style->normal_res;

//   GLUquadricObj* cylinder;

   GLfloat Surface1[] = { (float)m_r/255.0f,(float)m_g/255.0f,(float)m_b/255.0f, transparency };
   GLfloat Surface2[] = { (float)m_r/255.0f,(float)m_g/255.0f,(float)m_b/255.0f, transparency };
//   GLfloat White[] = { 255.0f,255.0f,255.0f, 1.0f };

   if ( style->bond_style == BONDSTYLE_HALFPARENTELEMENT && m_patms.size() == 2 ) {
   
		Surface1[0] = (float)m_patms[0]->r / 255.0f;
		Surface1[1] = (float)m_patms[0]->g / 255.0f;
		Surface1[2] = (float)m_patms[0]->b / 255.0f;

		Surface2[0] = (float)m_patms[1]->r / 255.0f;
		Surface2[1] = (float)m_patms[1]->g / 255.0f;
		Surface2[2] = (float)m_patms[1]->b / 255.0f;
   
   } else if ( style->bond_style == BONDSTYLE_HALFPARENTPART  && m_patms.size() == 2 ) {

		int g1 = m_patms[0]->m_group;
		int g2 = m_patms[1]->m_group;
		
		if ( g1 != 0 ) {
			Surface1[0] = partColours[g1%7][0] / 255.0f;
			Surface1[1] = partColours[g1%7][1] / 255.0f;
			Surface1[2] = partColours[g1%7][2] / 255.0f;
		}
		if ( g2 != 0 ) {
			Surface2[0] = partColours[g2%7][0] / 255.0f;
			Surface2[1] = partColours[g2%7][1] / 255.0f;
			Surface2[2] = partColours[g2%7][2] / 255.0f;
		}
   }
   
   if ( m_excluded )
   {
		Surface1[0] = 128.0f+Surface1[0]/2.0f;
		Surface1[1] = 128.0f+Surface1[1]/127.0f;
		Surface1[2] = 128.0f+Surface1[2]/127.0f;
		Surface2[0] = 128.0f+Surface2[0]/2.0f;
		Surface2[1] = 128.0f+Surface2[1]/127.0f;
		Surface2[2] = 128.0f+Surface2[2]/127.0f;
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
 		DrawBond(Surface1, Surface2, feedback, detail, bondrad);
//        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
//		if (feedback) {
//			glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
//		} else {
//			glColor4fv( Surface1 );
//		}
//        cylinder = gluNewQuadric();
//        gluQuadricDrawStyle(cylinder,GLU_FILL);
//        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
//        gluDeleteQuadric(cylinder);
     glPopMatrix();
     glPushMatrix();
        glTranslated(-offd*vecX+((m_x1+m_x2)/2.0f), -offd*vecY+((m_y1+m_y2)/2.0f), -offd*vecZ+((m_z1+m_z2)/2.0f));   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
 		DrawBond(Surface1, Surface2, feedback, detail, bondrad);
//        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
//		if (feedback) {
//			glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
//		} else {
//			glColor4fv( Surface1 );
//		}
//        cylinder = gluNewQuadric();
//        gluQuadricDrawStyle(cylinder,GLU_FILL);
//        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
//        gluDeleteQuadric(cylinder);
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
 		DrawBond(Surface1, Surface2, feedback, detail, bondrad);
//        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
//		if (feedback) {
//			glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
//		} else {
//			glColor4fv( Surface1 );
//		}
//        cylinder = gluNewQuadric();
//        gluQuadricDrawStyle(cylinder,GLU_FILL);
//        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
//        gluDeleteQuadric(cylinder);
     glPopMatrix();
     glPushMatrix();
        glTranslated(offd*vecX+(m_x1+m_x2)/2.0f, offd*vecY+(m_y1+m_y2)/2.0f, offd*vecZ+(m_z1+m_z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
 		DrawBond(Surface1, Surface2, feedback, detail, bondrad);
//        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
//		if (feedback) {
//			glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
//		} else {
//			glColor4fv( Surface1 );
//		}
//        cylinder = gluNewQuadric();
//        gluQuadricDrawStyle(cylinder,GLU_FILL);
//        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
//        gluDeleteQuadric(cylinder);
     glPopMatrix();
     glPushMatrix();
        glTranslated(-offd*vecX+(m_x1+m_x2)/2.0f, -offd*vecY+(m_y1+m_y2)/2.0f, -offd*vecZ+(m_z1+m_z2)/2.0f);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
 		DrawBond(Surface1, Surface2, feedback, detail, bondrad);
//        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
//		if (feedback) {
//			glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
//		} else {
//			glColor4fv( Surface1 );
//		}
//        cylinder = gluNewQuadric();
//        gluQuadricDrawStyle(cylinder,GLU_FILL);
//        gluCylinder(cylinder,(float)bondrad,(float)bondrad,m_length, detail, detail);
//        gluDeleteQuadric(cylinder);
     glPopMatrix();
   }
   else if ( m_bondtype == 101 ) //TORUS for aromatic rings
   {
     glPushMatrix();
        glTranslated((float)m_x1, (float)m_y1, (float)m_z1);   //Translate view origin to the center of the bond
        glRotatef(m_yrot,0,1,0);
        glRotatef(m_xrot,1,0,0);
//        glTranslated(0, 0, -m_length / 2);           //shift the cylinder so it is centered at 0,0,0;
//        glScalef((float)bondrad, (float)bondrad, (float)bondrad);
//        glCallList(TORUS);

        float rc = (float)bondrad; // torus thickness
        int numt = CRMAX(10,detail);             // num of cylinders to make torus?
        float rt = m_length ;          // torus radius
        int numc = detail;             // num of sides to cylinder?
        float s, t;
        float x, y, z;
        float pi, twopi;
        pi = 3.14159265358979323846f;
        twopi = 2.0f * pi;
		if (feedback) {
                        mp_parent->ApplyIndexColour( m_glID );
//                        glColor3ub( (m_glID & 0xff0000) >> 16, (m_glID & 0xff00) >> 8, (m_glID & 0xff) );
		} else {
			glColor4fv( Surface1 );
		}
        for (int i = 0; i < numc; i++) {
           glBegin(GL_QUAD_STRIP);
           for (int j = 0; j <= numt; j++) {
              for (int k = 0; k <= 1; k++) {
                 s = (i + k) % numc + 0.5f;
                 t = (float)(j % numt);
                 x = (float)(cos(t*twopi/numt) * cos(s*twopi/numc));
                 y = (float)(sin(t*twopi/numt) * cos(s*twopi/numc));
                 z = (float)sin(s*twopi/numc);
//                 LOGWARN ( "xyz:"+string(x)+" "+string(y)+" "+string(z) );
                 glNormal3f(x, y, z);
                 x = (float)((rt + rc * cos(s*twopi/numc)) * cos(t*twopi/numt));
                 y = (float)((rt + rc * cos(s*twopi/numc)) * sin(t*twopi/numt));
                 z = (float)(rc * sin(s*twopi/numc));
//                 LOGWARN ( "xyz:"+string(x)+" "+string(y)+" "+string(z));
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
		DrawBond(Surface1, Surface2, feedback, detail, bondrad);
	  glPopMatrix();
   }

}



void CcModelBond::SelfExclude()
{
 //Called after atoms have been excluded from the picture.

 if (m_patms.size() > 1 ) {
    m_excluded = m_patms[0]->m_excluded;
    m_excluded = m_patms[1]->m_excluded || m_excluded;
 }

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
