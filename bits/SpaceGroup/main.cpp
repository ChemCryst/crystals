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
#include <sys/time.h>
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

using namespace std;

#if !defined(_WIN32)
#define _TCHAR const char
#define TCHAR char
//define kDefaultTables "/Tables.txt"
#else
//define kDefaultTables "\\Tables.txt"
#define PATH_MAX _MAX_PATH
#endif

#define kVersion "1.0.1.3(Beta)"

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
    std::cout << "Reading in tables...";
    struct timeval time1;
    struct timeval time2;
    gettimeofday(&time1, NULL);
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
    gettimeofday(&time2, NULL);
    std::cout << "\n" << (float)(time2.tv_sec - time1.tv_sec)+(float)(time2.tv_usec-time1.tv_usec)/1000000 << "s\n";
    std::cout << "\nReading in hkl data...";
    gettimeofday(&time1, NULL);
    HKLData* tHKL;
    try
    {
	tHKL = new HKLData(pRunData.iFileName.getCString());
    }
    catch (MyException& eException)
    {
        eException.addError("When opening hkl file:");
        throw eException;
    }
    gettimeofday(&time2, NULL);
    std::cout << "\n" << (float)(time2.tv_sec - time1.tv_sec)+(float)(time2.tv_usec-time1.tv_usec)/1000000 << "s\n";
    
    //This is just testing  
    std::cout << "Merging...\n";  
       gettimeofday(&time1, NULL);
       //getMergeCrystalSys(0);
    LaueGroups tGroups;
    SystemRef tSystemRef;
    unsigned short tNumGroups;
    for (int i = LaueGroups::kCubicID; i >= 0; i--)
    {
	tSystemRef = tGroups.getSystemRef(&tNumGroups, i); 
	cout << "System: " <<  tSystemRef << " " << tNumGroups << "\n";
	for (int j = 0; j<tNumGroups; j++)
	{
	    MergedData tMergedData = tGroups.mergeSystemGroup(*tHKL, tSystemRef, j);
	    cout << j << ": " << tMergedData << "\n";
	}
    }
    gettimeofday(&time2, NULL);    
    std::cout <<"\n" << (float)(time2.tv_sec - time1.tv_sec)+(float)(time2.tv_usec-time1.tv_usec)/1000000 << "s\n";
// this is the end of testing.

    std::cout << "\nCalculating probabilities...";
    gettimeofday(&time1, NULL);
    Table* tTable = tTables->findTable(pRunData.iCrystalSys.getCString());
    Stats* tStats = new Stats(tTables->getHeadings(), tTables->getConditions());
    int tNumRef = tHKL->numberOfReflections();
    for (int i = 0; i < tNumRef; i++)
    {
        Reflection* tReflection = tHKL->getReflection(i);
        tStats->addReflection(tReflection);
    }

    tStats->calProbs();
    gettimeofday(&time2, NULL);
    if (pRunData.iVerbose)
	tStats->output(std::cout, *tTable) << "\n";
    std::cout <<"\n" << (float)(time2.tv_sec - time1.tv_sec)+(float)(time2.tv_usec-time1.tv_usec)/1000000 << "s\n";
    std::cout << "\nRanking space groups...";
    gettimeofday(&time1, NULL);
    RankedSpaceGroups* tRankings = new RankedSpaceGroups(*tTable, *tStats, pRunData.iChiral);
    gettimeofday(&time2, NULL);
    std::cout <<"\n" << (float)(time2.tv_sec - time1.tv_sec)+(float)(time2.tv_usec-time1.tv_usec)/1000000 << "s\n";
    std::cout << "\n" << *tRankings << "\n";
    outputToFile(pRunData, tStats, tRankings, *tTable);
    if (pRunData.iInteractiveMode)
    {
        InteractiveControl tInteractiveControl(tStats, tRankings, tTable);
        tInteractiveControl.goInteractive();
    }
    delete tRankings;
    delete tStats;
    delete tHKL;
    delete tTables;
    std::cout << MyObject::objectCount() << " objects left.\n";
}

#if !defined(_WIN32)
int main(int argc, _TCHAR * argv[])
#else
int _tmain(int argc, _TCHAR* argv[])
#endif
{ 
    std::cout << "The Determinator Version " << kVersion << "\n";
    std::cout << "Written by Stefan Pantos\n";

    RunParameters tRunStruct;

    try
    {
	/* Handle all the arguments which were passed to the program.
	 * If there are any parameters needed where where not passed 
	 * then the user is prompted.
	 */
	tRunStruct.handleArgs(argc, argv);  
        //tRunStruct.getParamsFromUser();
        runTest(tRunStruct);
    }
    catch (MyException eE)
    {
        std::cout << "\n" << eE.what() << "\n";
    }   
    return 0;
}
