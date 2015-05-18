
#ifndef     __CcModelObject_H__
#define     __CcModelObject_H__

class CrModel;
class CcController;
class CcModelDoc;
#include "cccoord.h"
#ifdef CRY_USEMFC
 #include <GL/glu.h>
 #include <GL/gl.h>
#elif defined (CRY_OSMAC)
 #include <wx/glcanvas.h>
#include <OpenGL/glu.h>
#else
 #include <wx/glcanvas.h>
#include <GL/glu.h>
#endif

#include <string>
#include <deque>
using namespace std;

#define CC_ATOM 1
#define CC_BOND 2
#define CC_SPHERE 3
#define CC_DONUT 4

class CcModelStyle;

class CcModelObject
{
   public:
     CcModelObject(CcModelDoc* pointer);
     CcModelObject();
     virtual ~CcModelObject();
     virtual void Render( CcModelStyle * style, bool feedback=false ) = 0;
     virtual void ParseInput ( deque<string> &  tokenlist) = 0;
     string Label();
     int Type();
     void Select(bool select);
     void Disable(bool select);
     bool Select();
     bool spare;
     bool IsSelected();
     virtual void SendAtom(int style, bool output=false); 
     GLuint m_glID;

     bool m_disabled;
     bool m_excluded;


   protected:
     CcModelDoc * mp_parent;
     string m_label;
     int m_type;
     bool m_selected;

};

#include    "ccmodelatom.h"
#include    "ccmodelbond.h"
#include        "ccmodelsphere.h"
#include        "ccmodeldonut.h"

#endif
