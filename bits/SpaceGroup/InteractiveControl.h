/*
 *  InteractiveControl.h
 *  Space Groups
 *
 *  Created by Stefan on Wed Jun 04 2003.
 *  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
 *
 */

class InteractiveControl
{
    private:
        Stats* iStats;
        Ranking* iRanking;
        Table* iTable;
        void printHelp();
        void handleCommand(String& pCommand);
    public:
        InteractiveContol(Stats pStats, Ranking* pRankings, Table* pTable);
        goInteractive();
}

