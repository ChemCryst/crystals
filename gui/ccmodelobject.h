
#ifndef		__CcModelObject_H__
#define		__CcModelObject_H__

class CrModel;
class CcTokenList;
class CcController;
class CcModelDoc;
#include "cccoord.h"
#ifdef __CR_WIN__
#include <GL/glu.h>
#include <GL/gl.h>
#endif
#ifdef __BOTHWX__
#include <wx/glcanvas.h>
#include <GL/glu.h>
#endif

#define CC_ATOM 1
#define CC_BOND 2

class CcModelStyle;

class CcModelObject
{
   public:
     CcModelObject(CcModelDoc* pointer);
     CcModelObject();
     virtual ~CcModelObject();
     virtual void Render( CcModelStyle * style ) = 0;
     virtual void ParseInput ( CcTokenList* tokenlist) = 0;
     CcString Label();
     int Type();
    GLuint glID;
   protected:
     CcModelDoc * mp_parent;
     CcString label;
     int type;
};

#include	"ccmodelatom.h"
#include	"ccmodelbond.h"

#endif
