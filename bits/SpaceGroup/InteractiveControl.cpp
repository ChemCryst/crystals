/*
 *  InteractiveControl.cpp
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 04 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

#include "InteractiveControl.h"

void printInteractiveHelp()
{
    cout << "Available commands.\n";
}

if (tReply.cmp("?"))
        {
            printInteractiveHelp();
        }

void goInteractive(Stats* pStats, Ranking* pRanking)
{
    String tReply("");
    bool tExit=false;
    std::cout << "Interactive Mode. For help type (?)\n";
    while (tReply.cmp("q")!=0)
    {
        std::cout << "-->";
        std::cin >> tReply;
        tExit = handleCommand(tReply);
        
        
    }
}