
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

class CcModelObject
{
   public:
     CcModelObject(CcModelDoc* pointer);
     CcModelObject();
     virtual ~CcModelObject();
     virtual void Render( CrModel* view, bool detailed ) = 0;
     virtual void ParseInput ( CcTokenList* tokenlist) = 0;
   protected:
     CcModelDoc * mp_parent;

};

#include	"ccmodelatom.h"
#include	"ccmodelbond.h"

#endif
