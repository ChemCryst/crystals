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

/*!
 * @class UnitCell 
 * @description Not yet documented.
 * @abstract
*/
class UnitCell;

typedef struct LaueGroupRange_
{
	SystemID location;
	int length;
}LaueGroupRange;

/*!
 * @class LaueClassMatrices 
 * @description Not yet documented.
 * @abstract
*/
class LaueClassMatrices:protected vector<MatrixReader>
{
    public:
        LaueClassMatrices();

        /*!
         * @function getMatrix 
         * @description Not yet documented.
         * @abstract
         */
        Matrix<short>& getMatrix(unsigned int pIndex) const;
		
		/*!
         * @function defaultInstance 
         * @description Not yet documented.
         * @abstract
         */
		static LaueClassMatrices* defaultInstance();
		
		/*!
         * @function releaseDefault 
         * @description Not yet documented.
         * @abstract
         */
		static void releaseDefault();
};
		
/*!
 * @class LaueGroup 
 * @description Not yet documented.
 * @abstract
*/
class LaueGroup:virtual public CrystSymmetry
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

	/*!
	 * @function crystalSystem 
	 * @description Not yet documented.
	 * @abstract
	 */
	SystemID crystalSystem() const;

	/*!
	 * @function matrix 
	 * @description Not yet documented.
	 * @abstract
	 */
	virtual Matrix<short>& matrix(const size_t i) const;

	/*!
	 * @function numberOfMatrices 
	 * @description Not yet documented.
	 * @abstract
	 */
	virtual size_t matrixCount() const;

	/*!
	 * @function maxEquivilentHKL 
	 * @description Not yet documented.
	 * @abstract
	 */
	Matrix<short> maxEquivilentHKL(const Matrix<short>& pHKL) const;

	/*!
	 * @function ratingForUnitCell 
	 * @description Not yet documented.
	 * @abstract
	 */
	float ratingForUnitCell(const UnitCell& pUnitCell)const;

	/*!
	 * @function contains 
	 * @description Not yet documented.
	 * @abstract
	 */
	bool contains(const CrystSymmetry& pSymmetry);
};

//std::ostream& operator<<(std::ostream& pStream, const LaueGroup& pLaueGroup);

/*!
 * @class LaueGroups 
 * @description Not yet documented.
 * @abstract
*/
class LaueGroups:public vector<LaueGroup*>//:public MyObject
{
	public:
		LaueGroups();
		~LaueGroups();
		
		/*!
		 * @function defaultInstance 
		 * @description Not yet documented.
		 * @abstract
		 */
		static LaueGroups* defaultInstance();
		
		/*!
		 * @function releaseDefault 
		 * @description Not yet documented.
		 * @abstract
		 */
		static void releaseDefault();

		/*!
		 * @function laueGroupWithSymbol 
		 * @description Not yet documented.
		 * @abstract
		 */
		LaueGroup* laueGroupWithSymbol(const string& pSymbol);

		/*!
		 * @function firstLaueGroupFor 
		 * @description Not yet documented.
		 * @abstract
		 */
		LaueGroup* firstLaueGroupFor(const SystemID pCrystalSystem);

		/*!
		 * @function laueGroupAfterFirst 
		 * @description Not yet documented.
		 * @abstract
		 */
		LaueGroup* laueGroupAfterFirst(const SystemID pCrystalSystem, const size_t i); //Returns the Laue Group which is i elements after the first of this system

		/*!
		 * @function numberOfLaueGroupsFor 
		 * @description Not yet documented.
		 * @abstract
		 */
		size_t numberOfLaueGroupsFor(const SystemID pCrystalSystem);

		/*!
		 * @function indexOf 
		 * @description Not yet documented.
		 * @abstract
		 */
		size_t indexOf(LaueGroup* pLaueGroup);
};


/*!
 * @function laueGroupOptions 
 * @description Not yet documented.
 * @abstract
 */
std::ostream& laueGroupOptions(std::ostream& pOutputStream);

/*!
 * @function getLaueGroup 
 * @description Not yet documented.
 * @abstract
 */
LaueGroup* getLaueGroup(LaueGroup* pDefault, std::ostream& pOutputStream);

#endif
