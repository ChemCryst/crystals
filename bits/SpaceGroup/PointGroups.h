/*
 *  PointGroups.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed May 19 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#ifndef __POINT_GROUPS_H__
#define __POINT_GROUPS_H__
#include "CrystSymmetry.h"
#include "ComClasses.h"
#include <map>

class PointGroups:public map<const char*, CrystSymmetry, ltstr>
{
	public:
		CrystSymmetry& operator[](const key_type& k);
};
#endif
