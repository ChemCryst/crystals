/*
 *  LaueClasses.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Mon Apr 19 2004.
 *  Copyright (c) 2004 __MyCompanyName__. All rights reserved.
 *
 */

#include "LaueClasses.h"
#include "UnitCell.h"
#include "RunParameters.h"
#include <iterator>
#include "MathFunctions.h"

/*
 * returns whether the HKL pMat1 is greater then HKL pMat2
 * 
 */
inline bool greaterHKL(const Matrix<short>& pMat1, const Matrix<short>& pMat2)
{
    if (pMat1.getValue(2) > pMat2.getValue(2))
        return true;
    else if (pMat1.getValue(2) < pMat2.getValue(2))
        return false;
    else
    {
        if (pMat1.getValue(1) > pMat2.getValue(1))
            return true;
        else if (pMat1.getValue(1) < pMat2.getValue(1))
            return false;
        else
        {
            if (pMat1.getValue(0) > pMat2.getValue(0))
                return true;
            else
                return false;
        }
    }
    return false;
}

/********************************************************/
/* LaueClassMatrices									*/
/********************************************************/

/*
 * Creates a large array containing all the unique matrices.
 */
LaueClassMatrices::LaueClassMatrices():vector<MatrixReader>(39)
{
  //  MatrixReader* tMatrices[39];
	
	(*this)[0].initWith("[-1 -1 0; 0 1 0; 0 0 1]");
	(*this)[1].initWith("[-1 0 0; 0 -1 0; 0 0 1]");
	(*this)[2].initWith("[-1 0 0; 0 0 1; 0 -1 0]");
	(*this)[3].initWith("[-1 0 0; 0 1 0; 0 0 -1]");
	(*this)[4].initWith("[-1 0 0; 0 1 0; 0 0 1]");
	(*this)[5].initWith("[0 1 0; -1 -1 0; 0 0 1]");
	(*this)[6].initWith("[-1 1 0; 1 0 0; 0 0 1]");
	(*this)[7].initWith("[-1 0 0; 1 1 0; 0 0 1]");
	(*this)[8].initWith("[0 -1 0; -1 0 0; 0 0 1]");
	(*this)[9].initWith("[0 -1 0; 0 0 1; -1 0 0]");
	(*this)[10].initWith("[-1 -1 0; 1 0 0; 0 0 1]");
	(*this)[11].initWith("[0 -1 0; 1 0 0; 0 0 -1]");
	(*this)[12].initWith("[0 -1 0; 1 0 0; 0 0 1]");
	(*this)[13].initWith("[0 0 -1; 0 1 0; -1 0 0]");
	(*this)[14].initWith("[0 0 -1; 1 0 0; 0 -1 0]");
	(*this)[15].initWith("[0 0 1; -1 0 0; 0 -1 0]");
	(*this)[16].initWith("[0 0 1; 0 -1 0; -1 0 0]");
	(*this)[17].initWith("[0 0 1; 0 1 0; -1 0 0]");
	(*this)[18].initWith("[0 0 1; 0 1 0; 1 0 0]");
	(*this)[19].initWith("[0 0 1; 1 0 0; 0 -1 0]");
	(*this)[20].initWith("[0 0 1; 1 0 0; 0 1 0]");
	(*this)[21].initWith("[0 1 0; -1 0 0; 0 0 -1]");
	(*this)[22].initWith("[0 1 0; -1 0 0; 0 0 1]");
	(*this)[23].initWith("[1 1 0; -1 0 0; 0 0 1]");
	(*this)[24].initWith("[0 1 0; 0 0 -1; -1 0 0]");
	(*this)[25].initWith("[0 1 0; 0 0 1; -1 0 0]");
	(*this)[26].initWith("[0 1 0; 0 0 1; 1 0 0]");
	(*this)[27].initWith("[0 1 0; 1 0 0; 0 0 -1]");
	(*this)[28].initWith("[0 1 0; 1 0 0; 0 0 1]");
	(*this)[29].initWith("[1 0 0; -1 -1 0; 0 0 1]");
	(*this)[30].initWith("[0 -1 0; 1 1 0; 0 0 1]");
	(*this)[31].initWith("[1 0 0; 0 -1 0; 0 0 -1]");
	(*this)[32].initWith("[1 0 0; 0 -1 0; 0 0 1]");
	(*this)[33].initWith("[1 0 0; 0 0 -1; 0 -1 0]");
	(*this)[34].initWith("[1 0 0; 0 0 1; 0 -1 0]");
	(*this)[35].initWith("[1 0 0; 0 0 1; 0 1 0]");
	(*this)[36].initWith("[1 0 0; 0 1 0; 0 0 -1]");
	(*this)[37].initWith("[1 0 0; 0 1 0; 0 0 1]");
	(*this)[38].initWith("[1 1 0; 0 -1 0; 0 0 1]");

   // iMatrices = new Array<MatrixReader*>(tMatrices, 39);
}

static LaueClassMatrices* gDefaultMatrices = NULL;

LaueClassMatrices* LaueClassMatrices::defaultInstance()
{
	if (gDefaultMatrices == NULL)
	{
		gDefaultMatrices = new LaueClassMatrices();
	}
	return gDefaultMatrices;
}

void LaueClassMatrices::releaseDefault()
{
	delete gDefaultMatrices;
	gDefaultMatrices = NULL;
}

Matrix<short>& LaueClassMatrices::getMatrix(unsigned int pIndex) const
{
    return (Matrix<short>&)((*this)[pIndex]);
}

/********************************************************/
/* LaueGroup										    */
/********************************************************/

LaueGroup::LaueGroup():CrystSymmetry(), iCrystalSystem(kTriclinicID), iLaueGroupMatrices(LaueClassMatrices::defaultInstance())
{
	iMatIndices = NULL;
}
   
LaueGroup::LaueGroup(const SystemID pSys, const string& pLaueGroup, const unsigned short pIndices[], const int pNumMat, const vector<CrystSymmetry>& pPointGroups):CrystSymmetry(pLaueGroup), iCrystalSystem(pSys),
	iLaueGroupMatrices(LaueClassMatrices::defaultInstance()), iPointGroups(pPointGroups)
{
	iMatIndices = new vector<unsigned short>(pIndices, &pIndices[pNumMat]);
}

LaueGroup::LaueGroup(const LaueGroup& pLaueGroup):CrystSymmetry(pLaueGroup), iCrystalSystem(pLaueGroup.iCrystalSystem), iLaueGroupMatrices(LaueClassMatrices::defaultInstance()), iPointGroups(pLaueGroup.iPointGroups)
{
	if (pLaueGroup.iMatIndices != NULL)
	{
		iMatIndices = new vector<unsigned short>(*(pLaueGroup.iMatIndices));
	}
	else
	{
		iMatIndices = NULL;
	}
}

LaueGroup::~LaueGroup()
{
	if (iMatIndices != NULL)
	{
		delete iMatIndices;
		iMatIndices = NULL;
	}
}

bool LaueGroup::contains(const CrystSymmetry& pSymmetry)
{
	vector<CrystSymmetry>::iterator tIter;
	
	for (tIter = iPointGroups.begin(); tIter != iPointGroups.end(); tIter++)
	{
		if ((string)(*tIter) == (string)pSymmetry)
		{
			return true;
		}
	}
	return false;
}

SystemID LaueGroup::crystalSystem() const
{
	return iCrystalSystem;
}

Matrix<short>& LaueGroup::matrix(const size_t i) const
{
	return iLaueGroupMatrices->getMatrix((*iMatIndices)[i]);
}

size_t LaueGroup::matrixCount() const
{
	return iMatIndices->size();
}

float LaueGroup::ratingForUnitCell(const UnitCell& pUnitCell)const
{
	Matrix<float> tMetricTensor;
	pUnitCell.metricTensor(tMetricTensor);
	Matrix<float> tDiff(3,3);
	Matrix<float> tOperator(3, 3);		//The current operator to be applied to the unit cell tensor. This is the inverse of the one used on the refelctions as it's i
	Matrix<float> tOperatorTrans(3, 3); //Transpose of tOperator.
	float tMaxElement = maximum(tMetricTensor, 0.0f, tDiff.sizeX()*tDiff.sizeY());
	float tScalarDiff = 0;
	for (size_t i = 1; i < iMatIndices->size(); i++) //Run through all the matrices missing the first as it is the identity
	{   // D = T-((O'*T)*O) where T :  Metric tensor O : Operators matrix
		
		tOperator = matrix(i);		//Get the current metrix operator in reciprical space.
		tOperator.inv();				//Convert it into real space.
		tOperatorTrans = tOperator; 
		tOperatorTrans.transpose(); //Transpose the matrix
		tOperatorTrans.mul(tMetricTensor, tDiff); //Multiply the metric tensor by the current transpose of the matrix
		tDiff.mul(tOperator, tOperatorTrans); //Multiply the metric tensor by the current matrix
		
		tOperatorTrans.sub(tMetricTensor, tDiff);
	
		tScalarDiff = max((tDiff.abssum()/tMaxElement), tScalarDiff);
	}
	return tScalarDiff;
}

Matrix<short> LaueGroup::maxEquivilentHKL(const Matrix<short>& pHKL) const
{
	Matrix<short> tTempHKL(1, 3);
	Matrix<short> tZero(1, 3, 0);
	Matrix<short> tCurHKL = pHKL;
	
	for (size_t i = 0; i < this->matrixCount(); i++) //Run through all the matrices.
	{
		matrix(i).mul(pHKL, tTempHKL); //Multiply the hkl value with the current matrix
		for (int j = 0; j < 2; j++) //Do this twice
		{
			if (greaterHKL(tTempHKL, tCurHKL)) //see if this new HKL value is greater then the last. This is just for consistancy could just as well be least hkl value or something.
			{
				tCurHKL = tTempHKL;
			}
			tZero.sub(tTempHKL, tTempHKL); //Invert the hkl value.
		}
	}
	return tCurHKL;
}

/********************************************************/
/* LaueGroups										    */
/********************************************************/

LaueGroups::LaueGroups():vector<LaueGroup*>()
{	
	const unsigned short tIndices[] = {37, //Triclinic
				       37, 31, //2/m 1 1
                                       37, 3, //1 2/m 1
                                       37, 1, //1 1 2/m
				       37, 4, 32, 1, //2/m 2/m 2/m
				       37, 12, 1, 22, //4/m
				       37, 12, 1, 22, 4, 28, 32, 8,//4/m m m
				       37, 10, 5, //-3
				       37, 10, 5, 7, 38, 8, //-3 m 1
				       37, 10, 5, 28, 29, 0, //  -3 1 m
					   
					   37, 20, 26, //-3 rhom
					   37, 20, 26, 28, 35, 18, //-3 m rhom
					   
				       37, 30, 10, 1, 6, 23, //6/m
				       37, 30, 10, 1, 5, 23, 7, 28, 38, 29, 8, 0, //6/m m m
				       37, 26, 20, 36, 25, 19, 24, 15, 14, 3, 9, 31,//m -3
				       37, 26, 20, 36, 25, 19, 24, 15, 14, 3, 9, 31, 28, 18, 35, 27, 17, 34, 13, 2, 33, 21, 16, 11};//m -3 m
					   
    /* The laue groups should always be in order of symmetry as other methods rely this order*/
	PointGroups t1;
	vector<CrystSymmetry> tV1;
	tV1.push_back(t1["1"]);
	tV1.push_back(t1["-1"]);
	insert(end(), new LaueGroup(kTriclinicID, "-1", tIndices, 1, tV1)); //Triclinic
	tV1.clear();
	tV1.push_back(t1["2"]);
	tV1.push_back(t1["m"]);
	tV1.push_back(t1["2/m"]);
	insert(end(), new LaueGroup(kMonoclinicAID, "2/m11", &(tIndices[1]), 2, tV1)); //2/m 1 1
	insert(end(), new LaueGroup(kMonoclinicBID, "12/m1", &(tIndices[3]), 2, tV1)); //1 2/m 1
	insert(end(), new LaueGroup(kMonoclinicCID, "112/m", &(tIndices[5]), 2, tV1)); //1 1 2/m
	tV1.clear();
	tV1.push_back(t1["222"]);
	tV1.push_back(t1["mm2"]);
	tV1.push_back(t1["m2m"]);
	tV1.push_back(t1["2mm"]);
	tV1.push_back(t1["mmm"]);
	insert(end(), new LaueGroup(kOrtharombicID, "2/m2/m2/m", &(tIndices[7]), 4, tV1)); //2/m 2/m 2/m
	tV1.clear();
	tV1.push_back(t1["4"]);
	tV1.push_back(t1["-4"]);
	tV1.push_back(t1["4/m"]);
	insert(end(), new LaueGroup(kTetragonalID, "4/m", &(tIndices[11]), 3, tV1)); //4/m
	tV1.clear();
	tV1.push_back(t1["422"]);
	tV1.push_back(t1["4mm"]);
	tV1.push_back(t1["-42m"]);
	tV1.push_back(t1["-4m2"]);
	tV1.push_back(t1["4/mmm"]);
	insert(end(), new LaueGroup(kTetragonalID, "4/mmm", &(tIndices[15]), 8, tV1)); //4/m m m
	tV1.clear();
	tV1.push_back(t1["3"]);
	tV1.push_back(t1["-3"]);
	insert(end(), new LaueGroup(kTrigonalID, "-3", &(tIndices[23]), 3, tV1)); //-3
	insert(end(), new LaueGroup(kTrigonalRhomID, "-3 rhom", &(tIndices[38]), 3, tV1)); //-3 rhom
	tV1.clear();
	tV1.push_back(t1["32"]);
	tV1.push_back(t1["3m"]);
	tV1.push_back(t1["-3m"]);
	insert(end(), new LaueGroup(kTrigonalRhomID, "-3m1 rhom", &(tIndices[41]), 6, tV1)); //-3 m 1 rhom
	tV1.push_back(t1["321"]);
	tV1.push_back(t1["3m1"]);
	tV1.push_back(t1["-3m1"]);
	insert(end(), new LaueGroup(kTrigonalID, "-3m1", &(tIndices[26]), 6, tV1)); //-3 m 1
	tV1.clear();
	tV1.push_back(t1["312"]);
	tV1.push_back(t1["31m"]);
	tV1.push_back(t1["-31m"]);
	insert(end(), new LaueGroup(kTrigonalID, "-31m", &(tIndices[32]), 6, tV1)); //-3 1 m
	tV1.clear();
	tV1.push_back(t1["6"]);
	tV1.push_back(t1["-6"]);
	tV1.push_back(t1["6/m"]);
	insert(end(), new LaueGroup(kHexagonalID, "6/m", &(tIndices[47]), 6, tV1)); //6/m
	tV1.clear();
	tV1.push_back(t1["622"]);
	tV1.push_back(t1["6mm"]);
	tV1.push_back(t1["-62m"]);
	tV1.push_back(t1["-6m2"]);
	tV1.push_back(t1["-6/mmm"]);
	insert(end(), new LaueGroup(kHexagonalID, "6/mmm", &(tIndices[53]), 12, tV1)); //6/m m m
	tV1.clear();
	tV1.push_back(t1["23"]);
	tV1.push_back(t1["m-3"]);
	insert(end(), new LaueGroup(kCubicID, "m-3", &(tIndices[65]), 12, tV1)); //m -3
	tV1.clear();
	tV1.push_back(t1["432"]);
	tV1.push_back(t1["-43m"]);
	tV1.push_back(t1["m-3m"]);
	insert(end(), new LaueGroup(kCubicID, "m-3m", &(tIndices[77]), 24, tV1)); //m -3m 
}

LaueGroups::~LaueGroups()
{
	vector<LaueGroup*>::iterator tIterator = begin();
	
	do
	{
		delete (*tIterator);
	}
	while (++tIterator != end());
}

static LaueGroups* gLaueGroupsDefulatInstace = NULL;

LaueGroups* LaueGroups::defaultInstance()
{
	if (gLaueGroupsDefulatInstace == NULL)
	{
		gLaueGroupsDefulatInstace = new LaueGroups();
	}
	return gLaueGroupsDefulatInstace;
}

void LaueGroups::releaseDefault()
{
	delete gLaueGroupsDefulatInstace;
	gLaueGroupsDefulatInstace = NULL;
}		

LaueGroup* LaueGroups::laueGroupWithSymbol(const string& pSymbol)
{
	vector<LaueGroup*>::iterator tIterator = begin();
	
	do
	{
		if ( *((string*)(*tIterator)) == pSymbol)
		{
			return *tIterator;
		}
	}
	while (++tIterator != end());
	
	return NULL;
}

LaueGroup* LaueGroups::firstLaueGroupFor(const SystemID pCrystalSystem)
{
	return laueGroupAfterFirst(pCrystalSystem, 0);
}

LaueGroup* LaueGroups::laueGroupAfterFirst(const SystemID pCrystalSystem, const size_t i)//Returns the Laue Group which is i elements after the first of this system
{
	vector<LaueGroup*>::iterator tIterator = begin();
	size_t tCount = 0;
	
	do
	{
		if ((*tIterator)->crystalSystem() == pCrystalSystem)
		{
			tCount ++;
			if (tCount > i)
			{
				return *tIterator;
			}
		}
	}
	while (++tIterator != end());
	
	return NULL;
}

size_t LaueGroups::numberOfLaueGroupsFor(const SystemID pCrystalSystem)
{
	size_t tCount = 0;
	vector<LaueGroup*>::iterator tIterator = begin();
	
	do
	{
		if ((*tIterator)->crystalSystem() == pCrystalSystem)
		{
			tCount ++;
		}
	}
	while (++tIterator != end());
	
	return tCount;
}

/**************************
 * Returns: the index of the parameters passed or UINT_MAX if it cannot be found.
 **************************/
size_t LaueGroups::indexOf(LaueGroup* pLaueGroup)
{
	size_t tCount = 0;
	vector<LaueGroup*>::iterator tIterator = begin();
	
	do
	{
		if ((*tIterator) == pLaueGroup)
		{
			return tCount;
		}
		tCount ++;
	}
	while (++tIterator != end());
	return UINT_MAX;
}
		

/********************************************************/
/* LaueGroup selection								*/
/********************************************************/

std::ostream& laueGroupOptions(std::ostream& pOutputStream)
{
	LaueGroups *tDefault = LaueGroups::defaultInstance();
	vector<LaueGroup*>::iterator tIter;
	unsigned int i = 0;
	
	for (tIter = tDefault->begin(); tIter != tDefault->end(); tIter++, i++)
	{
		pOutputStream << i << ": " << (**tIter) << " " << crystalSystemConst((*tIter)->crystalSystem()) << "\n";
	}
	return pOutputStream;
}

LaueGroup* getLaueGroup(LaueGroup* pDefault, std::ostream& pOutputStream)
{
	vector<LaueGroup*>::iterator tIter;
	LaueGroups *tDefault = LaueGroups::defaultInstance();
	Range tAnswerRange = {0, 0};
	
	laueGroupOptions(pOutputStream);
	tAnswerRange.length = tDefault->size();
	return (*tDefault)[getUserNumResponse("Please choose the correct laue symmetry", (int)tDefault->indexOf(pDefault), tAnswerRange)];
}
