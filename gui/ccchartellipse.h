
#ifndef		__CcChartEllipse_H__
#define		__CcChartEllipse_H__

class CrChart;
class CcTokenList;
//#include "crystalsinterface.h"
#include "ccchartobject.h"

class CcChartEllipse : public CcChartObject
{
	public:
		Boolean fill;
		CcChartEllipse(Boolean filled = TRUE);
            CcChartEllipse(Boolean filled, int ix, int iy, int iw, int ih );
		~CcChartEllipse();
		void Draw(CrChart* chartToDrawOn);
		Boolean ParseInput(CcTokenList* tokenList);
	private:
		int x, y, w, h;
};

#endif
