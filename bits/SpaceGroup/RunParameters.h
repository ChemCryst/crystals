/*
 *  RunParameters.h
 *  Space Groups
 *
 *  Created by Stefan on Tue Jun 10 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */
#if !defined(__RUN_PARAMETERS_H__)
#define __RUN_PARAMETERS_H__
#if !defined(_WIN32)
#define _TCHAR const char
#define TCHAR char
#define kDefaultTables "/Tables.txt"
#else
#define kDefaultTables "\\Tables.txt"
#define PATH_MAX _MAX_PATH
#endif
#include "StringClasses.h"
#include "UnitCell.h"

class RunParameters
{
    private:
        bool iRequestChirality;	//If this is true then the user will be asked if the file crystal is chiral.
        void readParamFile();
        bool handleArg(int *pPos, int pMax, _TCHAR * argv[]);
    public:
        Path iFileName;		//File name for the hkl data.
        Path iTablesFile;               //The file name of the tables file.
        Path iOutputFile;		//The path of the file where the stats and ranking should be output to.
        Path iParamFile;		//A path to the file which contains any further parameters.
        bool iChiral;		//False is not nessaseraly chiral. false chiral -nc, -c
        bool iInteractiveMode;	//If this is set true the program will go into interactive mode at the end. -i
        bool iVerbose;		//If this is set true the program will output the stats table after it has calculated all it's probabilits. -v
	bool iMerge;            //If this is set true then the HKL data will be merged to try and find the laue group. Default is true. -m
        String iCrystalSys;	//Crystal System
        UnitCell iUnitCell;	//The unit cell
        RunParameters();
        void handleArgs(int pArgc, _TCHAR* argv[]);
        void getParamsFromUser();
};
#endif





