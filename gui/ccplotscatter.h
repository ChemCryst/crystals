////////////////////////////////////////////////////////////////////////

//   CRYSTALS Interface      Class CcPlotScatter

////////////////////////////////////////////////////////////////////////

//   Filename:  CcPlotScatter.cc
//   Authors:   Richard Cooper and Steve Humphreys
//   Created:   10.11.2001 10:15
//   $Log: not supported by cvs2svn $

#ifndef     __CcPlotScatter_H__
#define     __CcPlotScatter_H__

#include "ccstring.h"
class CcTokenList;
class CcList;
class CrPlot;

class CcPlotScatter : public CcPlotData
{
    public:
        void DrawView();
        void Clear();
        Boolean ParseInput( CcTokenList * tokenList );
        CcPlotScatter();
        ~CcPlotScatter();
};

#endif
