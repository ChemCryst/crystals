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
#include "Matrices.h"
#include "BaseTypes.h"
#include "Symmetry.h"

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
		
class LaueGroup:public CrystSymmetry
{
protected:	
	SystemID iCrystalSystem;
    vector<unsigned short>* iMatIndices;
	LaueClassMatrices* iLaueGroupMatrices;
	vector<CrystSymmetry> iPointGroups;
public:
	LaueGroup();
	LaueGroup(const SystemID pSys, const string& pLaueGroup, const unsigned short pIndices[], const int pNumMat, const vector<CrystSymmetry>& pPointGroups);
	LaueGroup(const LaueGroup& pLaueGroup);
	~LaueGroup();
	SystemID crystalSystem() const;
	Matrix<short>& getMatrix(const int i) const;
	size_t numberOfMatrices() const;
	Matrix<short> maxEquivilentHKL(const Matrix<short>& pHKL) const;
	float ratingForUnitCell(const UnitCell& pUnitCell)const;
	bool contains(const CrystSymmetry& pSymmetry);
};

//std::ostream& operator<<(std::ostream& pStream, const LaueGroup& pLaueGroup);

class LaueGroups:public vector<LaueGroup*>//:public MyObject
{
	public:
		LaueGroups();
		~LaueGroups();
		static LaueGroups* defaultInstance();
		static void releaseDefault();
		LaueGroup* laueGroupWithSymbol(const string& pSymbol);
		LaueGroup* firstLaueGroupFor(const SystemID pCrystalSystem);
		LaueGroup* laueGroupAfterFirst(const SystemID pCrystalSystem, const int i); //Returns the Laue Group which is i elements after the first of this system
		size_t numberOfLaueGroupsFor(const SystemID pCrystalSystem);
		size_t indexOf(LaueGroup* pLaueGroup);
};

std::ostream& laueGroupOptions(std::ostream& pOutputStream);
LaueGroup* getLaueGroup(LaueGroup* pDefault, std::ostream& pOutputStream);

#endif
