/*
 *  main.cpp
 *  Space Groups
 *
 *  Created by Stefan Pantos on Tue Oct 29 2002.
 *  Copyright (c) 2002 __MyCompanyName__. All rights reserved.
 *
 */
 
/*** Naming conventions ***
 ** Variable/Constant **
 * These conventions should be followed as closely as possible when coding in the file.
 * All variable names should start with one of the following lower case letters.
 * t - variables which are declared locally to the method/function
 * i - variables which are members of the object.
 * g - variables which are global to the file.
 * p - variables which are parameters to a method/function.
 * k - constants
 *
 * All variables should be have descriptive names which. Should use capitalization in 
 * variable names.
 *
 * e.g.. 
 * double tSomeVariable;   //A variable which is declared inside method.
 * double pSomeParameter   //A variable which is a parameter to a method/function
 *
 ** Classes/Structures/Typedefs **
 * All these should have the first letter as a capital and the first letter of any word 
 * in the name should be a capital letter. All other letters should be lower case.
 * 
 * e.g.
 * class MyClass
 * {
 * 	function name	
 * };
 */
 
#if defined(_WIN32)
#include <direct.h>
#endif

#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#if !defined(_WIN32)
#include <sys/time.h>
#endif
#include <errno.h>
#include "HKLData.h"
#include "Stats.h"
#include "RunParameters.h"
#include "Timer.h"
#include "LaueGroupGraph.h"
#include "MathFunctions.h"

using namespace std;

#if defined(_WIN32)
#include "PCPort.h"
#define PATH_MAX _MAX_PATH
#endif

#define kVersion "1.1(Beta)"

void outputToFile(RunParameters& pRunData, Stats* pStats, RankedSpaceGroups* pRanking, Table& pTable)	//This outputs the ranked spacegroups and the stats table to the file at the path pRunData->iOutputFile
{
    if (pRunData.iOutputFile.getCString()[0] != 0)
    {
        ofstream tOutputFile(pRunData.iOutputFile.getCString(), ofstream::out);
        if (!tOutputFile.fail())
        {
            pStats->output(tOutputFile, pTable) << "\n";
            tOutputFile << *pRanking << "\n";
            tOutputFile.close();
        }
        else
        {
            FileException tException(errno);
            tException.addError("When opening output file:");
            throw tException;
        }
    }
}

void runTest(RunParameters& pRunData)
{
	Timer tTimer;
    std::cout << "Reading in tables...";
    std::cout.flush();
	
    tTimer.start();
	Tables* tTables;
    try
    {
        tTables = new Tables(pRunData.iTablesFile.getCString());
    }
    catch (MyException& eException)
    {
        char tString[100];
        sprintf(tString, "When opening table file:(%s)", pRunData.iTablesFile.getCString());
        eException.addError(tString);
        throw eException;
    }
	tTimer.stop();
    std::cout << "\n" << tTimer << "\n";
    std::cout << "\nReading in hkl data...";
    std::cout.flush();
	tTimer.start();
    HKLData* tHKL;
	
	Matrix<float> tMetricTensor;
	pRunData.unitCell().metricTensor(tMetricTensor);
	
    try
    {
		tHKL = new HKLData(pRunData.iFileName.getCString(), tMetricTensor);
    }
    catch (MyException& eException)
    {
        char tError[255];
        sprintf(tError, "When opening hkl file:%s", pRunData.iFileName.getCString());
        eException.addError(tError);
        throw eException;
    }
	tTimer.stop();
    std::cout << "\n" << tTimer << "\n";
	LaueGroup *tResult;
	std::cout << "\nMerging...\n"; 
	std::cout.flush(); 
	tTimer.start();
	LaueGroupGraph* tGraph = new LaueGroupGraph();
	MergedReflections& tMergedRefl = tGraph->merge(*tHKL);
	tTimer.stop();    
	std::cout << tTimer << "\n\n";
	tResult = tMergedRefl.laueGroup();
	HKLData *tHKLData; //The resulting merged reflections.
	std::cout << "From merging the most likly laue symetry is " << (*tResult) << "\n";
	
	LaueGroup* tNewResult;
	if (pRunData.crystalSystem() == kUnknownID) //If the Laue symmetry hasn't already been specified 
	{
		tNewResult = getLaueGroup(tResult, std::cout);
	}
	else
	{
		tNewResult = pRunData.laueGroup();
	}
	if (tNewResult != tResult) //If what the merge found and the users choise was don't machine
	{
		pRunData.setLaueGroup(tNewResult); //Save the choice
		if (pRunData.iMerge) //If your using the merged data then
		{
			std::cout << "Remerging reflections in " << (*tNewResult) << "...\n"; 
			MergedData tNewMergedData(*tHKL, *tNewResult); 
			tHKLData = new HKLData();
			tNewMergedData.mergeReflections(*tHKLData);
		}
	}
	else
	{
		pRunData.setLaueGroup(tResult);
		tHKLData = new HKLData((HKLData&)tMergedRefl);
	}
	
	delete tGraph;
	if (pRunData.iMerge)
	{
		delete tHKL;
		tHKL = tHKLData;
	}

    std::cout << "Calculating probabilities...\n";
    std::cout.flush();
    tTimer.start();
    Table* tTable = tTables->findTable(crystalSystemConst(pRunData.crystalSystem()));
    Stats* tStats = new Stats(tTables->getRegions(), tTables->getConditions());
	tStats->addReflections(*tHKL, *pRunData.laueGroup());
    tStats->calProbs();
    tTimer.stop();
    if (pRunData.iVerbose)
		tStats->output(std::cout, *tTable) << "\n";
    std::cout << tTimer << "\n";
    std::cout.flush();
    std::cout << "\nRanking space groups...";
    std::cout.flush();
    tTimer.start();
    RankedSpaceGroups* tRankings = new RankedSpaceGroups(*tTable, *tStats, pRunData.iChiral, *pRunData.laueGroup());
    tTimer.stop();
    std::cout <<"\n" << tTimer << "\n\n";
	std::cout << "Table for " << crystalSystemConst(pRunData.laueGroup()->crystalSystem()) << "\n";
    std::cout << "\n" << *tRankings << "\n";
	if (maximum(tHKL->unitCellTensor(), -1000000.0f, tHKL->unitCellTensor().sizeX()*tHKL->unitCellTensor().sizeY()) > 0) //if we where given a unit cell output the new values.
	{
		UnitCell tUnitCell(tHKL->unitCellTensor());
		std::cout << "Unit cell:\n" << tUnitCell << "\n";
	}
	std::cout << "Transformation matrix is: \n" << tHKL->transformation() << "\n"; //Output the transformation matrix which was used.
	
	/* Used for output stats to be read into octave for analysis*/
    /*outputToFile(pRunData, tStats, tRankings, *tTable);
	outputScores(*tRankings, *tStats, *tTable);*/
    delete tRankings;
    delete tStats;
    delete tHKL;
    delete tTables;
}

void cleanup()
{
	LaueGroups::releaseDefault();
	LaueClassMatrices::releaseDefault();
}

int main(int argc, const char* argv[])
{ 
    std::cout << "The Determinator Version " << kVersion << "\n";
    std::cout << "Written by Stefan Pantos\n";
    try
    {
        RunParameters tRunStruct;
        /* Handle all the arguments which were passed to the program.
        * If there are any parameters needed where where not passed 
        * then the user is prompted.
        */
        tRunStruct.handleArgs(argc, argv);  
        tRunStruct.getParamsFromUser(); // Not all the run parameters have been filled in the user will need to add some more.
        runTest(tRunStruct);
    }
	catch (MyException eE)
    {
        std::cout << "\n" << eE.what() << "\n";
    }
    catch (exception eE)
    {
        std::cout << "\n" << eE.what() << "\n";
    }
	
	cleanup();
	#ifdef __DEBUGGING__
    std::cout << MyObject::objectCount() << " objects left.\n";
	#endif
    return 0;
}

//Debugging source code. Used to get values of the absent refelections.
//Average Int
/*
static float AbsentAIM = 0.00834789f;
static float AbsentAISD = 0.01289479f;
static float PresentAIM = 0.49585336f;
static float PresentAISD = 0.16645043f;


typedef struct ElemLocation
{
	signed char rowNum;
	signed char colNum;
};

struct ELlt
{
	bool operator()(const ElemLocation& e1, const ElemLocation& e2) const
	{
		return e1.rowNum < e2.rowNum || ((e1.rowNum == e2.rowNum && e1.colNum < e2.colNum));
	}
};

void outputScoresForRow(signed char pRow, Stats& pStats, Table& pTable, set<ElemLocation, ELlt>& pUsedElements)
{
	vector<Index>* tRegion;
	
	int tNumColumn = pTable.numberOfColumns();
	for (int i = 0; i < tNumColumn; i++)
	{
		Indexs* tIndexs = pTable.getConditions(pRow, i);
		tRegion = pTable.getRegions(i);
		if (tIndexs != NULL)
		{
			vector<Index*>::iterator tIndexIterator;
			for (tIndexIterator = tIndexs->begin(); tIndexIterator != tIndexs->end(); tIndexIterator++)
			{
				signed char tIndex = (*tIndexIterator)->value();
				for (vector<Index>::iterator tRegionIterator = tRegion->begin(); tRegionIterator != tRegion->end(); tRegionIterator++)
				{
					signed char tRegionIndex = (*tRegionIterator).value();
					ElemLocation tElement = {tRegionIndex, tIndex};
					if (pUsedElements.count(tElement) == 0)
					{   
						pUsedElements.insert(tElement);
					
						ElemStats* tElemStat = pStats.getElem(tRegionIndex, tIndex);
						float tValue1 = tElemStat->tNonMTotInt/tElemStat->tNumNonM;
						float tValue2 = tElemStat->tMTotInt/tElemStat->tNumM;
						
						float tRating1 = (tValue1)/(tValue2+tValue1);
						float tRating2 = (float)tElemStat->tNumNonMGrInt/(float)tElemStat->tNumNonM;
						float tRating3 = (float)tElemStat->tNumMLsInt/(float)tElemStat->tNumM;
						float tRating4 = ((float)tElemStat->tNumMLsInt+(float)tElemStat->tNumNonMGrInt)/(float)(tElemStat->tNumNonM+tElemStat->tNumM);

						
						if ((tValue2+tValue1) != 0 && (tElemStat->tNumNonMGrInt+tElemStat->tNumNonMLsInt) != 0 
							&& (tElemStat->tNumMGrInt+tElemStat->tNumMLsInt) != 0)
								std::cerr << Stats::evaluationFunction(tRating1, AbsentAIM, AbsentAISD, PresentAIM, PresentAISD) << "\t" << tRating1 << "\t" << tRating2 << "\t" << tRating3 << "\t" << tRating4 << "\n";
					}
				}
			}
		}
	}
}

void outputScores(RankedSpaceGroups& pRankedSGs, Stats& pStats, Table& pTable)
{
	multiset<RowRating, RRlt>::iterator tRow; //Get the highest ranked row.
	set<ElemLocation, ELlt> tUsedElements;
	
	std::cerr << "- " << "\n";
	for (tRow = pRankedSGs.begin(); tRow != pRankedSGs.end(); tRow++)
	{
		outputScoresForRow(tRow->iRowNum, pStats, pTable, tUsedElements);
		if (tRow == pRankedSGs.begin())
			std::cerr << "+" << "\n";
	}
}
	
*/
