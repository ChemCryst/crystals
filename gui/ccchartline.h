
#ifndef		__CcChartLine_H__
#define		__CcChartLine_H__

class CrChart;
class CcTokenList;
#include "CcChartObject.h"

class CcChartLine : public CcChartObject
{
	public:
		void Init(int xa, int ya, int xb, int yb);
		CcChartLine();
		~CcChartLine();
		void Draw(CrChart* chartToDrawOn);
		Boolean ParseInput(CcTokenList* tokenList);
	private:
		int x1, y1, x2, y2;
};

#endif