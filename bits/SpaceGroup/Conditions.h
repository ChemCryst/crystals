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
#include "Matrices.h"
#include <vector>

class Condition:public Matrix<short>
{
    private:
        char* iName;
        int iID;
        float iMult;
    public:
        Condition(char* pLine);
        ~Condition();
        char* getName();
        float getMult();
        int getID();
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Condition& pCondition);

class Conditions:public vector<Condition*>
{
    public:
        Conditions();
        ~Conditions();
        char* getName(const size_t pIndex);
        float getMult(const size_t pIndex);
        Matrix<short>* getMatrix(const size_t pIndex);
        int getID(const size_t pIndex);
        char* addCondition(char* pLine);
        void readFrom(filebuf& pFile);
        std::ostream& output(std::ostream& pStream);
};

std::ostream& operator<<(std::ostream& pStream, Conditions& pConditions);
#endif

