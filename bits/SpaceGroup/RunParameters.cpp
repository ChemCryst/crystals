/*
 *  RunParameters.cpp
 *  Space Groups
 *
 *  Created by Stefan on Tue Jun 10 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

/*
 * RunParameter class stores all the parameters which the program was run with.
 * These could be input through a batch file or the command line.
 */

#include <iostream>
#include <fstream>
#include "RunParameters.h"
#include "UnitCell.h"
#if defined(__APPLE__)
#include <vecLib/vDSP.h>
#endif
#include "Exceptions.h"
#if defined(_WIN32)
#include <Boost/regex.h>
#include <direct.h>
#else
#include <regex.h>
#endif
#include <errno.h>
#if !defined(_WIN32)
#include <sys/param.h>
#endif
#include <stdlib.h>
#include "LaueClasses.h"
#include <string>

RunParameters::RunParameters():iLaueGroup(NULL)
{
#if defined(_WIN32)
	char * tWorkingPath = (char*)malloc(PATH_MAX);
	_getcwd(tWorkingPath, PATH_MAX);
#else
	char * tWorkingPath = NULL;
	tWorkingPath = getcwd(NULL, PATH_MAX);
#endif
    iTablesFile.initFormated("%s%s", tWorkingPath, kDefaultTables);
    free(tWorkingPath);
    iRequestChirality = true;
    iChiral = false;
    iVerbose = false;
    iMerge = true;
}

/* Individule arguments from the command line are passed to 
 * this function. The arguments are used to set up the way the 
 * program is to run.
 */
bool RunParameters::handleArg(int *pPos, int pMax, const char * argv[])
{
    if (strcmp(argv[(*pPos)], "-c") == 0) // chiral
    {
        iChiral = true;
        iRequestChirality = false;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[(*pPos)], "-nc") == 0) //not chiral
    {
        iChiral = false;
        iRequestChirality = false;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[*pPos], "-v")==0) //verbose mode
    {
        iVerbose = true;
        (*pPos)++;
        return true;
    }
    else if (strcmp(argv[*pPos], "-f")==0) //hkl file name
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iFileName.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-o")==0)	//Output to file.
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iOutputFile.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-t")==0) //table file
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iTablesFile.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-b")==0) //Param file
    {
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            iParamFile.init(argv[*pPos]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-s")==0) //Crystal system
    {
		LaueGroups* tDefaultLaueGroups = LaueGroups::defaultInstance();
        (*pPos)++;
        if (*pPos < pMax && argv[*pPos][0] != '-')
        {
            char* tEnd;
            unsigned int tValue = strtol(argv[*pPos], &tEnd, 10);
            if (tEnd != argv[*pPos]+strlen(argv[*pPos]) || tValue >= (*tDefaultLaueGroups).size())
            {
                return false;
            }
			setLaueGroup((*tDefaultLaueGroups)[tValue]);
            (*pPos)++;
            return true;
        }
    }
    else if (strcmp(argv[*pPos], "-m")==0)
    {
	iMerge = false;
	(*pPos)++;
	return true;
    }
    return false;
}

/*
 * All command line arguments are passed to this method to set up 
 * the object so that the program is run correctly.
 */
void RunParameters::handleArgs(int pArgc, const char* argv[])
{
    int tCount = 1;
    while (tCount < pArgc) //Run through all the arguments
	{
	  if (!handleArg(&tCount, pArgc, argv)) //if the argument is not recognised then error.
		{
            std::cout << "Usage: " << argv[0] << "[-f hklfile] [-t tablefile] [-e extradatafile] [-c|-nc] [-s symetry#]\n";
            std::cout << "-f hklfile: The path of the hkl file to read in.\n";
            std::cout << "-t tablefile: The path of the table file.\n";
            std::cout << "-o outputfile: The path to a file to output the stats table and the raking table.\n";
            std::cout << "[-c| -nc]: -c The structure is chiral. -nc The crystal isn't necessarily chiral.\n";
            std::cout << "-v: verbose output\n";
            std::cout << "-b batchfile: This supplies a file with all the parameters needed to run the program. The parameters in the file override any other parameters set on the command line.\n";
			std::cout << "-m: Merge the data before predicting the Space Group.\n";
            std::cout << "-s symetry#: The symetry to use.\n";
            std::cout << "Valid values for system are:\n";
			laueGroupOptions(std::cout);
            throw MyException(kUnknownException, "");
        }
    }
    readParamFile(); //If there was a parameter files specifed then read it and over right any of the comman line arguments.
}

/*
 * This method does the following. If there where any parameters which 
 * are needed and the user hasn't entered them then promet the user 
 * for them.
 */
void RunParameters::getParamsFromUser()
{
    if (iFileName.empty()) //Get the path of the hkl file from the user.
    {
		char tString[PATH_MAX];
		
		std::cin.clear();
		std::cout << "Enter hkl file path: ";
		std::cin.getline(tString, 255, '\n');
		
		iFileName.init(tString);
		iFileName.removeOutterQuotes();
    }
    char tReply[10];
    while (iRequestChirality)
    {
		//std::cin.ignore();
		std::cin.clear();
		std::cout << "Is the crystal chiral? [y/n]";
		std::cin.getline(tReply, 10, '\n');
        
        String::upcase(tReply);
        
        if (strcmp(tReply, "NO")  == 0 || strcmp(tReply, "N") == 0 || 0 == tReply[0])
        {
            iChiral = false;
            iRequestChirality = false;
        }
        else if (strcmp(tReply, "YES") == 0 || strcmp(tReply, "Y") == 0)
        {
            iChiral = true;
            iRequestChirality = false;
        }
    }
}

void RunParameters::readParamFile()
{
    if (!iParamFile.empty())
    {
        try
        {
	    // The regular expression for parsing the param file.
            char tChiralRE[] = "^[[:space:]]*CHIRAL[[:space:]]+((YES)|(UNKNOWN))[[:space:]]*(#.*)?$";
            char tOutputRE[] = "^[[:space:]]*OUTPUT[[:space:]]+\"([^\"]+)\"[[:space:]]*(#.*)?$";
			char tMergeRE[] = "^[[:space:]]*USE_MERGED[[:space:]]+((YES)|(NO))[[:space:]]*(#.*)?$";
            char tHKLRE[] = "^[[:space:]]*HKL[[:space:]]+\"([^\"]+)\"[[:space:]]*(#.*)?$";
            char tCommentRE[] = "(#.+)$";
			char tSymmetryRE[] = "^[[:space:]]*SYMMETRY[[:space:]]+(([12346/M-]|[[:space:]])+(RHOM)?)[[:space:]]*(#.*)?$";
            filebuf tParamFile;
            if (tParamFile.open(iParamFile.getCString(), std::ios::in) == NULL)
            {
                throw FileException(errno); //Throw the exception if the files couldn't be opened.
            }
            std::istream tFileStream(&tParamFile);
			//Allocate space for all the regular expressions
            regex_t* tChiralFSO = new regex_t;
            regex_t* tOutputFSO = new regex_t;
            regex_t* tHKLFSO = new regex_t;
            regex_t* tCommentSO = new regex_t;
			regex_t* tMergeSO =  new regex_t;
			regex_t* tSymmetryFSO = new regex_t;
			regcomp(tSymmetryFSO, tSymmetryRE, REG_EXTENDED | REG_ICASE);
            regcomp(tChiralFSO, tChiralRE, REG_EXTENDED | REG_ICASE);
            regcomp(tOutputFSO, tOutputRE, REG_EXTENDED | REG_ICASE);
            regcomp(tHKLFSO, tHKLRE, REG_EXTENDED | REG_ICASE);
            regcomp(tCommentSO, tCommentRE, REG_EXTENDED | REG_ICASE);
			regcomp(tMergeSO, tMergeRE, REG_EXTENDED | REG_ICASE);
            regmatch_t tMatchs[13];
            char tLine[255];
            int tLineNum = 0;
            String* tUniqueAxis = NULL;
            String* tClass = NULL;

            while (!tFileStream.eof())//While there are still lines to be read
            {
                tFileStream.getline(tLine, 255);
                tLineNum ++;
                //Look for comments
                if (regexec(tCommentSO, tLine, 13, tMatchs, 0) == 0)
                {
                    tLine[tMatchs[1].rm_so] = '\0';
                }
                String::trim(tLine);
                
                if (strlen(tLine) == 0) //Ignore an empty line
                {}
				else if (regexec(tSymmetryFSO, tLine, 13, tMatchs, 0) == 0) //Crystal System
                {
					LaueGroups* tDefaultLaueGroups = LaueGroups::defaultInstance();
					string tLaueGroup(tLine+tMatchs[1].rm_so, tMatchs[1].rm_eo-tMatchs[1].rm_so);
					do_tolower(tLaueGroup.begin(), tLaueGroup.end());
					setLaueGroup(tDefaultLaueGroups->laueGroupWithSymbol(tLaueGroup.c_str()));
                }
                else if (regexec(tChiralFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    if (tMatchs[2].rm_so > 0)
                        iChiral = true;
                    else
                        iChiral = false;
                    iRequestChirality = false;
                }
				else if (regexec(tMergeSO, tLine, 13, tMatchs, 0) == 0) //Merge
                {
                    if (tMatchs[2].rm_so > 0)
                        iMerge = true;
                    else
                        iMerge = false;
                }
                else if (regexec(tOutputFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    String tTemp(tLine, (int)tMatchs[1].rm_so, (int)tMatchs[1].rm_eo);
                    iOutputFile.copy(tTemp);
                }
                else if (regexec(tHKLFSO, tLine, 13, tMatchs, 0) == 0)
                {
                    String tTemp(tLine, (int)tMatchs[1].rm_so, (int)tMatchs[1].rm_eo);
                    iFileName.copy(tTemp);
                }
                else if (iUnitCell.init(tLine))
                {
                }
                else
                {
                    tParamFile.close();
                    String tMyString;
                    tMyString.initFormated("Badly formated parameter file at line %d", tLineNum);
                    throw MyException(kUnknownException, tMyString.getCString());
                }
            }
            if (tUniqueAxis)
            {
                delete tUniqueAxis;
                
            }
            if (tClass)
            {
                delete tClass;
            }
            tParamFile.close(); //Close the file.
			delete tSymmetryFSO;
            delete tChiralFSO;
            delete tOutputFSO;
            delete tHKLFSO;
	    delete tMergeSO;
        }
        catch(MyException e)
        {
            e.addError("Error in reading the parameter file.");
            throw e;
        }
    }
}

void RunParameters::setLaueGroup(LaueGroup *pLaueGroup)
{
	iLaueGroup = pLaueGroup;
}

UnitCell& RunParameters::unitCell() 
{ 
	return iUnitCell;
}

LaueGroup* RunParameters::laueGroup()
{
	return iLaueGroup;
}

SystemID RunParameters::crystalSystem()
{
	if (iLaueGroup)
	{
		return iLaueGroup->crystalSystem();
	}
	return kUnknownID;
}

unsigned int getUserNumResponse(const char* pQuestion, const uint pDefault, const Range pAnswerRange)
{
    char* iSelect = new char[255];
    char* tEnd = NULL;
	unsigned int tResult = pDefault;
	bool tGotResult =false;
    
    do
    {
		std::cout << pQuestion << "[" << pDefault << "]:";
		std::cin.clear();
        std::cin.getline(iSelect, 255);
	   
		if (iSelect[0] != '\0')
        { 
            tResult = strtol(iSelect, &tEnd, 10);
			if (tResult >= pAnswerRange.location  && tResult < pAnswerRange.length+pAnswerRange.location && tEnd[0] == '\0')
				tGotResult = true;
			else
				std::cout << "Invalid value.\n";
        }
    }
    while (!tGotResult && (iSelect[0] != '\0' || pDefault == UINT_MAX));
    delete[] iSelect;
    return tResult;
}
