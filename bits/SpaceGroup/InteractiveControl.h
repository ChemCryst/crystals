/*
 *  InteractiveControl.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 04 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#if !defined(__INTERACTIVE_CONTROL_H__)
#define __INTERACTIVE_CONTROL_H__

#include "Stats.h"
#include "CrystalSystem.h"
#include "StringClasses.h"
#if defined(_WIN32)
#include <Boost/regex.h>
#else
#include <regex.h>
#endif

class Command:public String
{
    public:
        Command();
	Command(char* pCommand);
        Command(const Command& pCommand);
        Command getCommand(int i);
        Command& operator=(Command& pCommand);
};

class InteractiveControl
{
    private:
        Stats* iStats;
        RankedSpaceGroups* iRanking;
        Table* iTable;
        void helpCommand(Command& pCommand);
        bool handleCommand(Command& pCommand);
        void printCommand(Command& pCommand);
        void outputCommand(Command& pCommand);
    public:
        InteractiveControl(Stats* pStats, RankedSpaceGroups* pRankings, Table* pTable);
        void goInteractive();
};


#endif


