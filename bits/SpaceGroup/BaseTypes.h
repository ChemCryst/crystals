/*
 *  BaseTypes.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 25 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(__BASE_TYPES_H__)
#define __BASE_TYPES_H__

#include "ComClasses.h"

class Column:public MyObject
{
    public:
        void setHeading(char* pHeading);
        int length();
};

#endif