
#include "crystalsinterface.h"
#include    "ccstring.h"
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
      sparerad = covrad = vdwrad = 1000;
	uflag = 0;
//      u1 = u2 = u3 = u4 = u5 = u6 = 0;
      x11 = x12 = x13 = x21 = x22 = x23 = x31 = x32 = x33 = 0;
	label = "Err";
	m_selected = false;
        m_disabled = false;
	parent = parentptr;
}

CcModelAtom::CcModelAtom()
{
	x = y = z = 0;
	r = g = b = 0;
	id = 0;
	occ = 1;
      sparerad = covrad = vdwrad = 1000;
	uflag = 0;
//      u1 = u2 = u3 = u4 = u5 = u6 = 0;
      x11 = x12 = x13 = x21 = x22 = x23 = x31 = x32 = x33 = 0;
	label = "Err";
	m_selected = false;
        m_disabled = false;
}

CcModelAtom::~CcModelAtom()
{
}

void CcModelAtom::ParseInput(CcTokenList* tokenList)
{
	CcString theString;
//Just read ID, LABEL,
// IX, IY, IZ,
// RED, GREEN, BLUE,
// OCC*1000,
// COVRAD, VDWRAD, SPARERAD
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
	theString = tokenList->GetToken();    //VDWRAD (scaled)
      sparerad = atoi ( theString.ToCString() );
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

void CcModelAtom::Disable(Boolean select)
{
        m_disabled = select;
}

Boolean CcModelAtom::IsSelected()
{
	return m_selected;
}

void CcModelAtom::Render(CrModel* view, Boolean detailed)
{
      glPushMatrix();
		GLUquadricObj* sphere = gluNewQuadric();
		gluQuadricDrawStyle(sphere,GLU_FILL);
            glTranslated(x,y,z);

            float extra = 0.0;
            int detail = (detailed)? view->m_NormalRes  : view->m_QuickRes ;

/*            if ( view->LitAtom() == this ) // hover over
		{
                  if ( m_selected )  // hover over a selected atom
                  {
                        GLfloat Surface[] = { 1.0f-(float)r/255.0f, 1.0f-(float)g/255.0f, 1.0f-(float)b/255.0f, 1.0f };
                        GLfloat Diffuse[] = { 0.9f,0.9f,0.9f,1.0f };
                        GLfloat Specula[] = { 0.2f,0.2f,0.2f,1.0f };
                        GLfloat Shinine[] = {0.0f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                        extra = 20.0;
                  }
                  else if ( m_disabled )  // hover over a disabled atom
                  {
                        GLfloat Diffuse[] = { 1.0f-(float)r/255.0f, 1.0f-(float)g/255.0f, 1.0f-(float)b/255.0f, 1.0f };
                        GLfloat Surface[] = { 0.9f,0.9f,0.9f,1.0f };
                        GLfloat Specula[] = { 0.2f,0.2f,0.2f,1.0f };
                        GLfloat Shinine[] = {0.0f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                        extra = 20.0;
                  }
                  else //hover over a normal atom
                  {
                        GLfloat Surface[] = { 1.0f-(float)r/255.0f, 1.0f-(float)g/255.0f, 1.0f-(float)b/255.0f, 1.0f };
                        GLfloat Diffuse[] = { 0.4f,0.4f,0.4f,1.0f };
                        GLfloat Specula[] = { 0.8f,0.8f,0.8f,1.0f };
                        GLfloat Shinine[] = {89.6f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                        extra = 20.0;
                  }
		}
            else   // No hover over
*/            {
                  if ( m_selected ) // highlighted
                  {
                        GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
                        GLfloat Diffuse[] = { 0.9f,0.9f,0.9f,1.0f };
                        GLfloat Specula[] = { 0.7f,0.7f,0.7f,1.0f };
//                        GLfloat Shinine[] = {0.0f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
//                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                        extra = 10.0;
                  }
                  else if ( m_disabled )  // disabled atom
                  {
                        GLfloat Diffuse[] = { (float)r/512.0f,(float)g/512.0f,(float)b/512.0f, 1.0f };
                        GLfloat Surface[] = { 0.0f,0.0f,0.0f,1.0f };
                        GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
//                        GLfloat Shinine[] = {0.0f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
//                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                        extra = 20.0;
                  }
                  else  // normal
                  {
                        GLfloat Surface[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
                        GLfloat Diffuse[] = { (float)r/255.0f,(float)g/255.0f,(float)b/255.0f, 1.0f };
//                        GLfloat Diffuse[] = { 0.0f,0.0f,0.0f,1.0f };
                        GLfloat Specula[] = { 0.0f,0.0f,0.0f,1.0f };
//                        GLfloat Shinine[] = {0.0f};
                        glMaterialfv(GL_FRONT, GL_AMBIENT,  Surface);
                        glMaterialfv(GL_FRONT, GL_DIFFUSE,  Diffuse);
                        glMaterialfv(GL_FRONT, GL_SPECULAR, Specula);
//                        glMaterialfv(GL_FRONT, GL_SHININESS,Shinine);
                  }
            }

            if(view->RadiusType() == COVALENT)
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
                  float * localmatrix = new float[16];
                  localmatrix[0]=(float)x11;
                  localmatrix[1]=(float)x21;
                  localmatrix[2]=(float)x31;
                  localmatrix[3]=0.0;
                  localmatrix[4]=(float)x12;
                  localmatrix[5]=(float)x22;
                  localmatrix[6]=(float)x32;
                  localmatrix[7]=0.0;
                  localmatrix[8]=(float)x13;
                  localmatrix[9]=(float)x23;
                  localmatrix[10]=(float)x33;
                  localmatrix[11]=0.0;
                  localmatrix[12]=0.0;
                  localmatrix[13]=0.0;
                  localmatrix[14]=0.0;
                  localmatrix[15]=1.0;
                  glMultMatrixf(localmatrix);
                  delete [] localmatrix;
                  gluSphere(sphere, ( 1.0f + ((float)extra / 1000.0f) )* view->RadiusScale(), detail,detail);
            }

            gluDeleteQuadric(sphere);

      glPopMatrix();
}

