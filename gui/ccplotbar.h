////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotBar

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotBar.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:19
//   $Log: not supported by cvs2svn $

#ifndef     __CcPlotBar_H__
#define     __CcPlotBar_H__

#include "ccstring.h"
class CcTokenList;
class CcList;
class CrPlot;

class CcPlotBar : public CcPlotData
{
    public:
        void DrawView();
        void Clear();
        Boolean ParseInput( CcTokenList * tokenList );
        CcPlotBar();
        ~CcPlotBar();
};

#endif
