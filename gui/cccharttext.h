
#ifndef		__CcChartText_H__
#define		__CcChartText_H__

class CrChart;
class CcTokenList;
#include "ccchartobject.h"
#include "ccstring.h"

class CcChartText : public CcChartObject
{
	public:
		void Init(int x1, int y1, int x2, int y2, CcString theText);
		void Init(int xp, int yp, CcString theText);
		CcChartText();
            CcChartText(int ix, int iy, CcString itext );
		~CcChartText();
		void Draw(CrChart* chartToDrawOn);
		Boolean ParseInput(CcTokenList* tokenList);
	private:
		int x, y;
		int xm, ym;
		CcString text;
};

#endif
