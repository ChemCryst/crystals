
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

#include	"ccchartline.h"
#include	"ccchartellipse.h"
#include	"ccchartpoly.h"
#include	"cccharttext.h"
#include	"ccchartcolour.h"

#endif