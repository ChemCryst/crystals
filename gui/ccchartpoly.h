
#ifndef		__CcChartPoly_H__
#define		__CcChartPoly_H__

class CrChart;
class CcTokenList;
#include "ccchartobject.h"

class CcChartPoly : public CcChartObject
{
	public:
            CcChartPoly(Boolean filled = true);
            CcChartPoly(Boolean filled, int iv, int* points );
		~CcChartPoly();
		void Draw(CrChart* chartToDrawOn);
		Boolean ParseInput(CcTokenList* tokenList);
		Boolean FastInput(CcTokenList* tokenList);
	private:
		int nVerts;
		int* verts;
		Boolean fill;
};

#endif
