
#ifndef     __CcChartText_H__
#define     __CcChartText_H__

class CrChart;
#include "ccchartobject.h"
#include <string>
using namespace std;


class CcChartText : public CcChartObject
{
    public:
                void Init(int x1, int y1, int x2, int y2, string theText, bool centred=true);
        void Init(int xp, int yp, string theText);
        CcChartText();
            CcChartText(int ix, int iy, string itext );
        ~CcChartText();
        void Draw(CrChart* chartToDrawOn);
        bool ParseInput(deque<string> & tokenList);
    private:
        int x, y;
        int xm, ym;
        string text;
};

#endif
