/*
 *  Conditions.h
 *  Space Groups
 *
 *  Created by Stefan on Tue Jul 15 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#if !defined(__CONDITIONS_H__)
#define __CONDITIONS_H__
#include "Collections.h"
#include "Matrices.h"

class Condition:public MyObject
{
    private:
        Matrix<short>* iMatrix;
        char* iName;
        int iID;
        float iMult;
    public:
        Condition(char* pLine);
        ~Condition();
        char* getName();
        Matrix<short>* getMatrix();
        float getMult();
        int getID();
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Condition& pCondition);

class Conditions:public MyObject
{
    private:
        ArrayList<Condition>* iConditions;
    public:
        Conditions();
        ~Conditions();
        char* getName(int pIndex);
        float getMult(int pIndex);
        Matrix<short>* getMatrix(int pIndex);
        int getID(int pIndex);
        std::ostream& output(std::ostream& pStream);
        char* addCondition(char* pLine);
        void readFrom(filebuf& pFile);
        int length();
};

std::ostream& operator<<(std::ostream& pStream, Conditions& pConditions);
#endif

