/*
 *  BaseTypes.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 25 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 *
 *   This file is for putting file types which need to be extended to be of any use.
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

template <class obj>
class Iterator:public MyObject
{
public:
    virtual ~Iterator()
    {
    }

    virtual void reset()
    {
    }
    
    virtual obj* next()
    {
        return NULL;
    }
    
    virtual bool hasNext()
    {
        return false;
    }
};
#endif