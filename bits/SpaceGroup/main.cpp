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
 
//#include "stdafx.h"
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
#include "Exceptions.h"
#include "CrystalSystem.h"
#include "Stats.h"
#include "UnitCell.h"
#include "InteractiveControl.h"
#include "RunParameters.h"
#include "StringClasses.h"
#include "ReflectionMerging.h"
#include "Timer.h"
#include "LaueGroupGraph.h"
#include "LaueClasses.h"

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
    try
    {
		tHKL = new HKLData(pRunData.iFileName.getCString());
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
	JJLaueGroup *tResult;
	std::cout << "\nMerging...\n"; 
	std::cout.flush(); 
	tTimer.start();
	LaueGroupGraph* tGraph = new LaueGroupGraph();
	MergedReflections& tMergedRefl = tGraph->merge(*tHKL);
	tTimer.stop();    
	std::cout << tTimer << "\n\n";
	tResult = tMergedRefl.laueGroup();
	HKLData *tHKLData; //The resulting merged reflections.
	std::cout << "From merging the most likly laue symetry is " << tResult->laueGroup() << "\n";
	
	JJLaueGroup* tNewResult;
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
			std::cout << "Remerging reflections in " << tNewResult->laueGroup() << "...\n"; 
			JJMergedData tNewMergedData(*tHKL, *tNewResult); 
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
    RankedSpaceGroups* tRankings = new RankedSpaceGroups(*tTable, *tStats, pRunData.iChiral);
    tTimer.stop();
    std::cout <<"\n" << tTimer << "\n\n";
	std::cout << "Table for " << crystalSystemConst(pRunData.laueGroup()->crystalSystem()) << "\n";
    std::cout << "\n" << *tRankings << "\n";
    outputToFile(pRunData, tStats, tRankings, *tTable);
    delete tRankings;
    delete tStats;
    delete tHKL;
    delete tTables;
}

void cleanup()
{
	JJLaueGroups::releaseDefault();
	JJLaueClassMatrices::releaseDefault();
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
	cleanup();
    std::cout << MyObject::objectCount() << " objects left.\n";
    return 0;
}
