
#ifndef		__CcModelObject_H__
#define		__CcModelObject_H__

class CrModel;
class CcTokenList;
class CcController;
#include "cccoord.h"
#include <GL/gl.h>
#include <GL/glu.h>

class CcModelObject
{
	public:
		CcModelObject();
		virtual ~CcModelObject();
            virtual void Render( CrModel* view, Boolean detailed ) = 0;
            virtual void ParseInput ( CcTokenList* tokenlist) = 0;
};

#include	"ccmodelatom.h"
#include	"ccmodelbond.h"
#include	"ccmodelcell.h"
#include	"ccmodeltri.h"

#endif
