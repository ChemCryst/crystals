
#ifndef     __CcChartObject_H__
#define     __CcChartObject_H__

#include <string>
#include <deque>
using namespace std;

class CrChart;
class CcController;

class CcChartObject
{
    public:
        CcChartObject();
        virtual ~CcChartObject();
        virtual void Draw(CrChart* chartToDrawOn) ;
        virtual bool ParseInput(deque<string> & tokenList) ;
};

#include    "ccchartline.h"
#include    "ccchartellipse.h"
#include    "ccchartpoly.h"
#include    "cccharttext.h"
#include    "ccchartcolour.h"

#endif
