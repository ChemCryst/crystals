#include "crystalsinterface.h"
#include <string>
using namespace std;

#include "cccontroller.h"
#include "ccchartobject.h"


CcChartObject::CcChartObject()
{
}

CcChartObject::~CcChartObject()
{
}

void CcChartObject::Draw(CrChart* chartToDrawOn) {} //must be overridden
bool CcChartObject::ParseInput(deque<string> & tokenList) {return false;}

