
#ifndef		__CcChartPoly_H__
#define		__CcChartPoly_H__

class CrChart;
class CcTokenList;
#include "CcChartObject.h"

class CcChartPoly : public CcChartObject
{
	public:
		CcChartPoly(Boolean filled = TRUE);
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