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
 
//#if defined(_WIN32)
//#include "stdafx.h"
//#endif

#include <iostream>
#include <stdio.h>
#include <string.h>
#include "HKLData.h"
#include "Exceptions.h"
#include "CrystalSystem.h"
#include "Stats.h"
#include "UnitCell.h"
using namespace std;

typedef struct RunStruct
{
    char* iFileName;		//File name for the hkl data.
    char* iTablesFile;		//The file name of the tables file.
    bool iChiral;		//false is not nessaseraly chiral. false chiral
    char* iCrystalSys;		//Crystal System
}RunStruct;

void runTest(RunStruct *pRunData)
{
    std::cout << "Reading in tables...";
    Tables tTables(pRunData->iTablesFile);
    std::cout << "\nReading in hkl data...";
    HKLData tHKL(pRunData->iFileName);
//    std::cout << "\nReading in unit cell...";
    std::cout << "\nCalculating probabilities...";
    Table* tTable = tTables.findTable(pRunData->iCrystalSys);
    Stats tStats(tTables.getHeadings(), tTables.getConditions());
    int tNumRef = tHKL.numberOfReflections();
    for (int i = 0; i < tNumRef; i++)
    {
        Reflection* tReflection = tHKL.getReflection(i);
        tStats.addReflection(tReflection);
    }
    tStats.calProbs();
    std::cout << "\nRanking space groups...";
    RankedSpaceGroups tRankings(*tTable, tStats);
    std::cout << "\n" << tRankings << "\n";
}

void initRunStruct(RunStruct *pRunStruct)
{
    pRunStruct->iTablesFile = new char[strlen("./Tables.txt"+1)];
    strcpy(pRunStruct->iTablesFile, "./Tables.txt");
    pRunStruct->iFileName = new char[255];
    pRunStruct->iFileName[0] = 0;
    pRunStruct->iCrystalSys = new char[20];
    pRunStruct->iChiral = false;
}

bool handleArg(int *pPos, int pMax, const char * argv[], RunStruct *pRunData)
{
    if (strcmp(argv[(*pPos)], "-c") == 0)
    {
        pRunData->iChiral = true;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[*pPos], "-f")==0)
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            strcpy(pRunData->iFileName, argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-t")==0)
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            delete pRunData->iTablesFile;
            pRunData->iTablesFile = new char[strlen(argv[*pPos])+1];
            strcpy(pRunData->iTablesFile, argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-s")==0)
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            delete pRunData->iTablesFile;
            pRunData->iTablesFile = new char[strlen(argv[*pPos])+1];
            strcpy(pRunData->iTablesFile, argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    return false;
}

bool handleArgs(int pArgc, const char * argv[], RunStruct *pRunData)
{
    int tCount = 1;
    while (tCount < pArgc)
    {
        if (!handleArg(&tCount, pArgc, argv, pRunData))
        {
            std::cout << "Usage: " << argv[0] << "[-f hklfile] [-t tablefile] [-c] [-s system]\n";
            std::cout << "-f hklfile: The path of the hkl file to read in.\n";
            std::cout << "-t tablefile: The path of the table file.\n";
            std::cout << "-c: The structure is chiral.\n";
            std::cout << "-s system#: The crystal system table to use.\n";
            std::cout << "Valid values for system are:\n" <<
            "\t0: Triclinic" <<
            "\t1: MonoclinicA\n" <<
            "\t2: MonoclinicB\n" <<
            "\t3: MonoclinicC\n" <<
            "\t4: Orthorhombic\n" <<
            "\t5: Tetragonal\n" <<
            "\t6: Trigonal\n" <<
            "\t7: Hexagonal\n" <<
            "\t8: Cubic\n";
            return false;
        }
    }
    return true;
}

int main(int argc, const char * argv[]) 
{
    RunStruct tRunStruct;
    initRunStruct(&tRunStruct);
    if (!handleArgs(argc, argv, &tRunStruct))
    {
        return 0;
    }
    if (tRunStruct.iFileName[0] == 0)
    {
        std::cout << "Enter hkl file path: ";
        cin >> tRunStruct.iFileName;
    }
    strcpy(tRunStruct.iCrystalSys, getCrystalSystem());
    try
    {
        runTest(&tRunStruct);
    }
    catch (MyException eE)
    {
        std::cout << eE.what() << "\n";
    }   
    delete tRunStruct.iFileName;
    delete tRunStruct.iTablesFile;
    delete tRunStruct.iCrystalSys;
}