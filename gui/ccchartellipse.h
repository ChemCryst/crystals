
#ifndef     __CcChartEllipse_H__
#define     __CcChartEllipse_H__

class CrChart;
//#include "crystalsinterface.h"
#include "ccchartobject.h"

class CcChartEllipse : public CcChartObject
{
    public:
        bool fill;
        CcChartEllipse(bool filled = TRUE);
            CcChartEllipse(bool filled, int ix, int iy, int iw, int ih );
        ~CcChartEllipse();
        void Draw(CrChart* chartToDrawOn);
        bool ParseInput(deque<string> &  tokenList);
    private:
        int x, y, w, h;
};

#endif
