/*
 *  ComClasses.h
 *  NeuralNetwork
 *
 *  Created by d922qg on Fri Jul 13 2001.
 *  Copyright (c) 2001 Unknown Company. All rights reserved.
 *
 */
#ifndef __COM_CLASSES_H__
#define __COM_CLASSES_H__

#include <iostream>
#include <string.h>
#include <stdio.h>

struct ltstr
{
  bool operator()(const char* s1, const char* s2) const
  {
    return strcmp(s1, s2) < 0;
  }
};

struct ltint
{
	bool operator()(int i1, int i2) const
	{
		return i1 < i2;
	}
};

class MyObject
{
private:
    long iObjectNumber;
public:
    MyObject();    
    virtual ~MyObject();    
    virtual void toString(char* pChars, unsigned int pSize);
    static long objectCount();
    static long TotalObjectNumber();
};

extern std::ostream& operator<<(std::ostream& pStream, const MyObject& pObject);
#endif


