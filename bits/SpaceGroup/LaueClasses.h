/*
 *  JJLaueClasses.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Mon Apr 19 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __JJLAUE_CLASSES_H__
#define __JJLAUE_CLASSES_H__
#include <iostream>
#include <vector>
#include "Collections.h"
#include "Matrices.h"
#include "BaseTypes.h"


enum SystemID
{
	kTriclinicID = 0,
	kMonoclinicAID,
	kMonoclinicBID,
	kMonoclinicCID,
	kOrtharombicID,
	kTetragonalID,
	kTrigonalID,
	kTrigonalRhomID,
	kHexagonalID,
	kCubicID,
	kUnknownID
};

class UnitCell;

typedef struct LaueGroupRange_
{
	SystemID location;
	int length;
}LaueGroupRange;

class JJLaueClassMatrices:protected vector<MatrixReader>
{
    public:
        JJLaueClassMatrices();
        Matrix<short>& getMatrix(unsigned int pIndex) const;
		static JJLaueClassMatrices* defaultInstance();
		static void releaseDefault();
};
		
class JJLaueGroup//:public MyObject
{
protected:	
	SystemID iCrystalSystem;
    vector<unsigned short>* iMatIndices;
    char* iJJLaueGroup;
	JJLaueClassMatrices* iLaueGroupMatrices;
public:
	JJLaueGroup();
	JJLaueGroup(const SystemID pSys, const char* pJJLaueGroup, const unsigned short pIndices[], const int pNumMat);
	JJLaueGroup(const JJLaueGroup& pJJLaueGroup);
	~JJLaueGroup();
	SystemID crystalSystem() const;
	Matrix<short>& getMatrix(const int i) const;
	size_t numberOfMatrices() const;
	char* laueGroup() const;
	std::ostream& output(std::ostream& pStream) const;
	Matrix<short> maxEquivilentHKL(const Matrix<short>& pHKL) const;
	float ratingForUnitCell(const UnitCell& pUnitCell)const;
};

std::ostream& operator<<(std::ostream& pStream, const JJLaueGroup& pLaueGroup);

class JJLaueGroups:public vector<JJLaueGroup*>//:public MyObject
{
	public:
		JJLaueGroups();
		~JJLaueGroups();
		static JJLaueGroups* defaultInstance();
		static void releaseDefault();
		JJLaueGroup* laueGroupWithSymbol(const char* pSymbol);
		JJLaueGroup* firstJJLaueGroupFor(const SystemID pCrystalSystem);
		JJLaueGroup* laueGroupAfterFirst(const SystemID pCrystalSystem, const int i); //Returns the JJLaue Group which is i elements after the first of this system
		size_t numberOfLaueGroupsFor(const SystemID pCrystalSystem);
		size_t indexOf(JJLaueGroup* pLaueGroup);
};

std::ostream& laueGroupOptions(std::ostream& pOutputStream);
JJLaueGroup* getLaueGroup(JJLaueGroup* pDefault, std::ostream& pOutputStream);

#endif
