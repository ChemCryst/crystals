
#ifndef		__CcChartObject_H__
#define		__CcChartObject_H__

class CrChart;
class CcTokenList;
class CcController;

class CcChartObject
{
	public:
		CcChartObject();
		virtual ~CcChartObject();
		virtual void Draw(CrChart* chartToDrawOn) = 0;
		virtual Boolean ParseInput(CcTokenList* tokenList) = 0;
};

#include	"CcChartLine.h"
#include	"CcChartEllipse.h"
#include	"CcChartPoly.h"
#include	"CcChartText.h"
#include	"CcChartColour.h"

#endif