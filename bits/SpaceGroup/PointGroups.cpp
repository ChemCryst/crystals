/*
 *  PointGroups.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Wed May 19 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "PointGroups.h"

CrystSymmetry& PointGroups::operator[](const key_type& k)
{
	return (*((insert(value_type(k, CrystSymmetry(k)))).first)).second;
}