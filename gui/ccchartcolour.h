
#ifndef		__CcChartColour_H__
#define		__CcChartColour_H__

class CrChart;
class CcTokenList;
#include "ccchartobject.h"

class CcChartColour : public CcChartObject
{
	public:
		CcChartColour();
            CcChartColour(int ir, int ig, int ib);
		~CcChartColour();
		void Draw(CrChart* chartToDrawOn);
		Boolean ParseInput(CcTokenList* tokenList);
	private:
		int r,g,b;
};

#endif
