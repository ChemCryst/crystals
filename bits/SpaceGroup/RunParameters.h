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
#include <string>

using namespace std;

/*!
 * @class RunParameters 
 * @description Not yet documented.
 * @abstract
*/
class RunParameters
{
    private:
        bool iRequestChirality;	//If this is true then the user will be asked if the file crystal is chiral.
		LaueGroup* iLaueGroup; //The LaueGroup identified
		UnitCell iUnitCell;	//The unit cell
		string iProgramName;
		
	/*!
	 * @function readParamFile 
	 * @description Not yet documented.
	 * @abstract
	 */
	void readParamFile();

	/*!
	 * @function handleArg 
	 * @description Not yet documented.
	 * @abstract
	 */
	bool handleArg(int *pPos, int pMax, const char * argv[]);
    public:
        Path iFileName;		//File name for the hkl data.
        Path iTablesFile;               //The file name of the tables file.
        Path iOutputFile;		//The path of the file where the stats and ranking should be output to.
        Path iParamFile;		//A path to the file which contains any further parameters.
        bool iChiral;		//False is not nessaseraly chiral. -nc, -c
        bool iVerbose;		//If this is set true the program will output the stats table after it has calculated all it's probabilits. -v
       	bool iMerge;		//If this is set true then the HKL data will be merged to try and find the laue group. Default is true. -m
        
		RunParameters(const string& pProgramName);
		
		/*!
		 * @function setLaueGroup 
		 * @description Not yet documented.
		 * @abstract
		 */
		void setLaueGroup(LaueGroup* pLaueGroup);

		/*!
		 * @function crystalSystem 
		 * @description Not yet documented.
		 * @abstract
		 */
		SystemID crystalSystem();

		/*!
		 * @function laueGroup 
		 * @description Not yet documented.
		 * @abstract
		 */
		LaueGroup* laueGroup();

		/*!
		 * @function unitCell 
		 * @description Not yet documented.
		 * @abstract
		 */
		UnitCell& unitCell();

		/*!
		 * @function handleArgs 
		 * @description Not yet documented.
		 * @abstract
		 */
		void handleArgs(int pArgc, const char* argv[]);

		/*!
		 * @function getParamsFromUser 
		 * @description Not yet documented.
		 * @abstract
		 */
		void getParamsFromUser();
		
		/*!
		 *	@function usage
		 *	@abstract Outputs the usage test.
		 *  @discussion A manipulater used to output the usage text for the application to an ostream
		 *  @param pStream The ostream to output the text to.
		 */
		template<typename _CharT, typename _Traits>
		basic_ostream<_CharT, _Traits>& usage(basic_ostream<_CharT, _Traits>& pStream)
		{
			pStream << "Usage: " << iProgramName << "[-f hklfile] [-t tablefile] [-b batchfile] [-c|-nc] [-s symetry#]\n";
			pStream << "-f hklfile: The path of the hkl file to read in.\n";
			pStream << "-t tablefile: The path of the table file.\n";
			pStream << "-o outputfile: The path to a file to output the stats table and the raking table.\n";
			pStream << "[-c| -nc]: -c The structure is chiral. -nc The crystal isn't necessarily chiral.\n";
			pStream << "-v: verbose output\n";
			pStream << "-b batchfile: This supplies a file with all the parameters needed to run the program. The parameters in the file override any other parameters set on the command line.\n";
			pStream << "-m: Merge the data before predicting the Space Group.\n";
			pStream << "-s symmetry#: The symetry to use.\n";
			pStream << "Valid values for system are:\n";
			pStream << laueGroupOptions;
			return pStream;
		}
};

unsigned int getUserNumResponse(const char* pQuestion, const uint pDefault, const Range pAnswerRange);
#endif

