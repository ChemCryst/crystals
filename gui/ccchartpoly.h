
#ifndef     __CcChartPoly_H__
#define     __CcChartPoly_H__

class CrChart;
#include "ccchartobject.h"

class CcChartPoly : public CcChartObject
{
    public:
            CcChartPoly(bool filled = true);
            CcChartPoly(bool filled, int iv, int* points );
        ~CcChartPoly();
        void Draw(CrChart* chartToDrawOn);
        bool ParseInput(deque<string> & tokenList);
    private:
        int nVerts;
        int* verts;
        bool fill;
};

#endif
