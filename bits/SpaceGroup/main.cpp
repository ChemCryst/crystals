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
 
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <sys/time.h>
#include <regex.h>
#include "Collections.h"
#include "HKLData.h"
#include "Exceptions.h"
#include "Matrices.h"
#include "CrystalSystem.h"
#include <fstream>
using namespace std;

void readInTable(filebuf& pFile, Table* pTable);

int main (int argc, const char * argv[]) 
{  
            try
            {
                HKLData* tReflections = new HKLData("/Users/stefan/Documents/Programming/C++/SpaceGroup/Test files/co1c.hkl");
                //tReflections->centeringTypeInfo();

                Headings tHeadings;
                Conditions tConditions;
                
                filebuf tFile;
                tFile.open("/Users/stefan/Documents/Programming/C++/SpaceGroup/Data/Tables.txt", ios::in);
                
                tHeadings.readFrom(tFile);
                tConditions.readFrom(tFile);
            
                Tables tTables(&tHeadings, &tConditions);
                tTables.readFrom(tFile);
                tFile.close(); 
        
                char tSystem[] = "MONOCLINIC";
                Table* tTable = tTables.findTable(tSystem);
                int tNumRefl = tReflections->numberOfReflections();
                for (int i = 0; i < tNumRefl; i++)
                {
                    Reflection* tReflection = tReflections->getReflection(i);
                    tTable->addReflection(tReflection);
                }
                
             //   cout << tHeadings << "\n";
             //   cout << tConditions << "\n";
                tTable->outputColumn(cout, 0, &tHeadings, &tConditions);
                tTable->outputColumn(cout, 1, &tHeadings, &tConditions);
                tTable->outputColumn(cout, 2, &tHeadings, &tConditions);
                cout << tTables << "\n";

                delete tReflections;
            }
            catch(MyException eE)
            {
                cout << eE.what() << "\n";
            }            
}
/*
    try
    {
        char* tNextLine;
        char* tPrevLine;

        Headings tHeadings;
        Conditions tConditions;
        
            filebuf tFile;
            tFile.open("/Users/stefan/Desktop/Tables.txt", ios::in);
            
            tHeadings.readFrom(tFile);
            tConditions.readFrom(tFile);
        
            Tables tTables(&tHeadings, &tConditions);
            tTables.readFrom(tFile);
            tFile.close(); 
            
            
        
        cout << tHeadings << "\n";
        cout << tConditions << "\n";
        cout << tTables << "\n";
    }
    catch (MyException& e)
    {
        cout << e.what() << "\n";
    }
    return 0;
}*/


