/*
 *  LaueClasses.h
 *  Space Groups
 *
 *  Created by Stefan Pantos on Mon Apr 19 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */
#ifndef __LAUE_CLASSES_H__
#define __LAUE_CLASSES_H__
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

class LaueClassMatrices:protected vector<MatrixReader>
{
    public:
        LaueClassMatrices();
        Matrix<short>& getMatrix(unsigned int pIndex) const;
		static LaueClassMatrices* defaultInstance();
		static void releaseDefault();
};
		
class LaueGroup//:public MyObject
{
protected:	
	SystemID iCrystalSystem;
    vector<unsigned short>* iMatIndices;
    char* iLaueGroup;
	LaueClassMatrices* iLaueGroupMatrices;
public:
	LaueGroup();
	LaueGroup(const SystemID pSys, const char* pLaueGroup, const unsigned short pIndices[], const int pNumMat);
	LaueGroup(const LaueGroup& pLaueGroup);
	~LaueGroup();
	SystemID crystalSystem() const;
	Matrix<short>& getMatrix(const int i) const;
	size_t numberOfMatrices() const;
	char* laueGroup() const;
	std::ostream& output(std::ostream& pStream) const;
	Matrix<short> maxEquivilentHKL(const Matrix<short>& pHKL) const;
	float ratingForUnitCell(const UnitCell& pUnitCell)const;
};

std::ostream& operator<<(std::ostream& pStream, const LaueGroup& pLaueGroup);

class LaueGroups:public vector<LaueGroup*>//:public MyObject
{
	public:
		LaueGroups();
		~LaueGroups();
		static LaueGroups* defaultInstance();
		static void releaseDefault();
		LaueGroup* laueGroupWithSymbol(const char* pSymbol);
		LaueGroup* firstLaueGroupFor(const SystemID pCrystalSystem);
		LaueGroup* laueGroupAfterFirst(const SystemID pCrystalSystem, const int i); //Returns the Laue Group which is i elements after the first of this system
		size_t numberOfLaueGroupsFor(const SystemID pCrystalSystem);
		size_t indexOf(LaueGroup* pLaueGroup);
};

std::ostream& laueGroupOptions(std::ostream& pOutputStream);
LaueGroup* getLaueGroup(LaueGroup* pDefault, std::ostream& pOutputStream);

#endif
