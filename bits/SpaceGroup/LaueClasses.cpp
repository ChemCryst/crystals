/*
 *  JJLaueClasses.cpp
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
/* JJLaueClassMatrices									*/
/********************************************************/

/*
 * Creates a large array containing all the unique matrices.
 */
JJLaueClassMatrices::JJLaueClassMatrices():vector<MatrixReader>(39)
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

static JJLaueClassMatrices* gDefaultMatrices = NULL;

JJLaueClassMatrices* JJLaueClassMatrices::defaultInstance()
{
	if (gDefaultMatrices == NULL)
	{
		gDefaultMatrices = new JJLaueClassMatrices();
	}
	return gDefaultMatrices;
}

void JJLaueClassMatrices::releaseDefault()
{
	delete gDefaultMatrices;
	gDefaultMatrices = NULL;
}

Matrix<short>& JJLaueClassMatrices::getMatrix(unsigned int pIndex) const
{
    return (Matrix<short>&)((*this)[pIndex]);
}

/********************************************************/
/* JJLaueGroup										    */
/********************************************************/

JJLaueGroup::JJLaueGroup():iCrystalSystem(kTriclinicID), iJJLaueGroup(NULL), iLaueGroupMatrices(JJLaueClassMatrices::defaultInstance())
{
	iMatIndices = NULL;
}
   
JJLaueGroup::JJLaueGroup(const SystemID pSys, const char* pJJLaueGroup, const unsigned short pIndices[], const int pNumMat):iCrystalSystem(pSys),iJJLaueGroup(NULL), iLaueGroupMatrices(JJLaueClassMatrices::defaultInstance())
{
	iMatIndices = new vector<unsigned short>(pIndices, &pIndices[pNumMat]);
	iJJLaueGroup = new char[strlen(pJJLaueGroup)+1];
	strcpy(iJJLaueGroup, pJJLaueGroup);
	
}

JJLaueGroup::JJLaueGroup(const JJLaueGroup& pJJLaueGroup):iCrystalSystem(pJJLaueGroup.iCrystalSystem), iJJLaueGroup(NULL), iLaueGroupMatrices(JJLaueClassMatrices::defaultInstance())
{
	if (pJJLaueGroup.iMatIndices != NULL)
	{
		iMatIndices = new vector<unsigned short>(*(pJJLaueGroup.iMatIndices));
	}
	else
	{
		iMatIndices = NULL;
	}
	if (pJJLaueGroup.iJJLaueGroup != NULL)
	{
		iJJLaueGroup = new char[strlen(pJJLaueGroup.iJJLaueGroup)+1];
		strcpy(iJJLaueGroup, pJJLaueGroup.iJJLaueGroup);
	}
}

JJLaueGroup::~JJLaueGroup()
{
	if (iMatIndices != NULL)
	{
		delete iMatIndices;
		iMatIndices = NULL;
	}
	if (iJJLaueGroup != NULL)
	{
		delete[] iJJLaueGroup;
		iJJLaueGroup = NULL;
	}
}

SystemID JJLaueGroup::crystalSystem() const
{
	return iCrystalSystem;
}

Matrix<short>& JJLaueGroup::getMatrix(const int i) const
{
	return iLaueGroupMatrices->getMatrix((*iMatIndices)[i]);
}

size_t JJLaueGroup::numberOfMatrices() const
{
	return iMatIndices->size();
}

float JJLaueGroup::ratingForUnitCell(const UnitCell& pUnitCell)const
{
	Matrix<float> tMetricTensor(pUnitCell.metricTensor());
	Matrix<float> tDiff(3,3);
	Matrix<float> tOperator(3, 3);
	Matrix<float> tOperatorTranspose(3, 3);

	float tScalarDiff = 0;
	for (size_t i = 0; i < iMatIndices->size(); i++) //Run through all the matrices.
	{   // T-((O'*T)*O) where T :  Metric tensor O : Operators matrix
		tOperator = getMatrix(i); //Get the current metrix operator.
		tOperatorTranspose = tOperator;
		tOperatorTranspose.transpose(); //Transpose the matrix
		tOperatorTranspose.mul(tMetricTensor, tDiff); //Multiply the metric tensor by the current transpose of the matrix
		tDiff.mul(tOperator, tOperatorTranspose); //Multiply the metric tensor by the current matrix
		
		tMetricTensor.sub(tOperatorTranspose, tDiff); 
		tScalarDiff = max(tDiff.abssum(), tScalarDiff);
	}
	return tScalarDiff;
}

Matrix<short> JJLaueGroup::maxEquivilentHKL(const Matrix<short>& pHKL) const
{
	Matrix<short> tTempHKL(1, 3);
	Matrix<short> tZero(1, 3, 0);
	Matrix<short> tCurHKL = pHKL;
	
	for (size_t i = 0; i < this->numberOfMatrices(); i++) //Run through all the matrices.
	{
		getMatrix(i).mul(pHKL, tTempHKL); //Multiply the hkl value with the current matrix
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

char* JJLaueGroup::laueGroup() const
{
	return iJJLaueGroup;
}

std::ostream& JJLaueGroup::output(std::ostream& pStream) const
{
	pStream.width(13);
	return pStream << iJJLaueGroup;
}

std::ostream& operator<<(std::ostream& pStream, const JJLaueGroup& pLaueGroup)
{
	return pLaueGroup.output(pStream);
}

/********************************************************/
/* JJLaueGroups										    */
/********************************************************/

JJLaueGroups::JJLaueGroups():vector<JJLaueGroup*>()
{	
	const unsigned short tIndices[] = {37, //Triclinic
				       37, 31, //2/m 1 1
                                       37, 3, //1 2/m 1
                                       37, 1, //1 1 2/m
				       37, 4, 32, 1, //2/m 2/m 2/m
				       37, 11, 1, 22, //4/m
				       37, 12, 1, 4, 22, 28, 32, 8,//4/m m m
				       37, 10, 5, //-3
				       37, 10, 5, 7, 38, 8, //-3 m 1
				       37, 10, 5, 28, 29, 0, //  -3 1 m
					   
					   37, 20, 26, //-3 rhom
					   37, 20, 26, 28, 35, 18, //-3 m rhom
					   
				       37, 30, 10, 1, 6, 23, //6/m
				       37, 30, 10, 1, 5, 23, 7, 28, 38, 29, 8, 0, //6/m m m
				       37, 26, 20, 36, 25, 19, 24, 15, 14, 3, 9, 31,//m -3
				       37, 26, 20, 36, 25, 19, 24, 15, 14, 3, 9, 31, 28, 18, 35, 27, 17, 34, 13, 2, 33, 21, 16, 11};//m -3 m
					   
    /* The laue groups should always bin in order of symmetry as other methods rely this order on this*/
	insert(end(), new JJLaueGroup(kTriclinicID, "-1", tIndices, 1)); //Triclinic
	insert(end(), new JJLaueGroup(kMonoclinicAID, "2/m 1 1", &(tIndices[1]), 2)); //2/m 1 1
	insert(end(), new JJLaueGroup(kMonoclinicBID, "1 2/m 1", &(tIndices[3]), 2)); //1 2/m 1
	insert(end(), new JJLaueGroup(kMonoclinicCID, "1 1 2/m", &(tIndices[5]), 2)); //1 1 2/m
	insert(end(), new JJLaueGroup(kOrtharombicID, "2/m 2/m 2/m", &(tIndices[7]), 4)); //2/m 2/m 2/m
	insert(end(), new JJLaueGroup(kTetragonalID, "4/m", &(tIndices[11]), 3)); //4/m
	insert(end(), new JJLaueGroup(kTetragonalID, "4/m m m", &(tIndices[15]), 8)); //4/m m m
	insert(end(), new JJLaueGroup(kTrigonalID, "-3", &(tIndices[23]), 3)); //-3
	insert(end(), new JJLaueGroup(kTrigonalID, "-3 m 1", &(tIndices[26]), 6)); //-3 m 1
	insert(end(), new JJLaueGroup(kTrigonalID, "-3 1 m", &(tIndices[32]), 6)); //-3 1 m
	
	insert(end(), new JJLaueGroup(kTrigonalRhomID, "-3 rhom", &(tIndices[38]), 3)); //-3 rhom
	insert(end(), new JJLaueGroup(kTrigonalRhomID, "-3 m 1 rhom", &(tIndices[41]), 6)); //-3 m 1 rhom
		
	insert(end(), new JJLaueGroup(kHexagonalID, "6/m", &(tIndices[47]), 6)); //6/m
	insert(end(), new JJLaueGroup(kHexagonalID, "6/m m m", &(tIndices[53]), 12)); //6/m m m
	insert(end(), new JJLaueGroup(kCubicID, "m -3", &(tIndices[65]), 12)); //m -3
	insert(end(), new JJLaueGroup(kCubicID, "m -3 m", &(tIndices[77]), 24)); //m -3 
}

JJLaueGroups::~JJLaueGroups()
{
	vector<JJLaueGroup*>::iterator tIterator = begin();
	
	do
	{
		delete (*tIterator);
	}
	while (++tIterator != end());
}

static JJLaueGroups* gLaueGroupsDefulatInstace = NULL;

JJLaueGroups* JJLaueGroups::defaultInstance()
{
	if (gLaueGroupsDefulatInstace == NULL)
	{
		gLaueGroupsDefulatInstace = new JJLaueGroups();
	}
	return gLaueGroupsDefulatInstace;
}

void JJLaueGroups::releaseDefault()
{
	delete gLaueGroupsDefulatInstace;
	gLaueGroupsDefulatInstace = NULL;
}		

JJLaueGroup* JJLaueGroups::laueGroupWithSymbol(const char* pSymbol)
{
	vector<JJLaueGroup*>::iterator tIterator = begin();
	
	do
	{
		if (strcmp((*tIterator)->laueGroup(), pSymbol) == 0)
		{
			return *tIterator;
		}
	}
	while (++tIterator != end());
	
	return NULL;
}

JJLaueGroup* JJLaueGroups::firstJJLaueGroupFor(const SystemID pCrystalSystem)
{
	return laueGroupAfterFirst(pCrystalSystem, 0);
}

JJLaueGroup* JJLaueGroups::laueGroupAfterFirst(const SystemID pCrystalSystem, const int i)//Returns the JJLaue Group which is i elements after the first of this system
{
	vector<JJLaueGroup*>::iterator tIterator = begin();
	int tCount = 0;
	
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

size_t JJLaueGroups::numberOfLaueGroupsFor(const SystemID pCrystalSystem)
{
	size_t tCount = 0;
	vector<JJLaueGroup*>::iterator tIterator = begin();
	
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
size_t JJLaueGroups::indexOf(JJLaueGroup* pLaueGroup)
{
	size_t tCount = 0;
	vector<JJLaueGroup*>::iterator tIterator = begin();
	
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
/* JJLaueGroup selection								*/
/********************************************************/

std::ostream& laueGroupOptions(std::ostream& pOutputStream)
{
	JJLaueGroups *tDefault = JJLaueGroups::defaultInstance();
	vector<JJLaueGroup*>::iterator tIter;
	unsigned int i = 0;
	
	for (tIter = tDefault->begin(); tIter != tDefault->end(); tIter++, i++)
	{
		pOutputStream << i << ": " << (*tIter)->laueGroup() << " " << crystalSystemConst((*tIter)->crystalSystem()) << "\n";
	}
	return pOutputStream;
}

JJLaueGroup* getLaueGroup(JJLaueGroup* pDefault, std::ostream& pOutputStream)
{
	vector<JJLaueGroup*>::iterator tIter;
	JJLaueGroups *tDefault = JJLaueGroups::defaultInstance();
	Range tAnswerRange = {0, 0};
	
	laueGroupOptions(pOutputStream);
	tAnswerRange.length = tDefault->size();
	return (*tDefault)[getUserNumResponse("Please choose the correct laue symmetry", tDefault->indexOf(pDefault), tAnswerRange)];
}