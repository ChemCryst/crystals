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
#define kDefaultTables "/Tables.txt"
#else
#define kDefaultTables "\\Tables.txt"
#define PATH_MAX _MAX_PATH
#include "PCPort.h"
#endif
#include "StringClasses.h"
#include "UnitCell.h"
#include "LaueClasses.h"
#include "BaseTypes.h"

class RunParameters
{
    private:
        bool iRequestChirality;	//If this is true then the user will be asked if the file crystal is chiral.
	//SystemID iCrystalSystem;	//Crystal System
	LaueGroup* iLaueGroup; //The LaueGroup identified
	UnitCell iUnitCell;	//The unit cell
	void readParamFile();
	bool handleArg(int *pPos, int pMax, const char * argv[]);
    public:
        Path iFileName;		//File name for the hkl data.
        Path iTablesFile;               //The file name of the tables file.
        Path iOutputFile;		//The path of the file where the stats and ranking should be output to.
        Path iParamFile;		//A path to the file which contains any further parameters.
        bool iChiral;		//False is not nessaseraly chiral. -nc, -c
        bool iVerbose;		//If this is set true the program will output the stats table after it has calculated all it's probabilits. -v
       	bool iMerge;		//If this is set true then the HKL data will be merged to try and find the laue group. Default is true. -m
        
		
		//void setCrystalSystem(SystemID pSystem);
	void setLaueGroup(LaueGroup* pLaueGroup);
	SystemID crystalSystem();
	LaueGroup* laueGroup();
	UnitCell& unitCell();
        RunParameters();
        void handleArgs(int pArgc, const char* argv[]);
        void getParamsFromUser();
};

unsigned int getUserNumResponse(const char* pQuestion, const uint pDefault, const Range pAnswerRange);
#endif





